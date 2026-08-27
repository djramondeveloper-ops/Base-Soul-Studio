-- Lista de aplicativos com notificações desabilitadas
local disabledNotifications = Config.DisabledNotifications or {}
-- Função principal para enviar notificações
function SendNotification(phoneNumberOrSource, notificationData, callback)
    -- Verifica se as notificações estão desabilitadas para este app
    if table.contains(disabledNotifications, notificationData.app) then
        if callback then
            callback(false)
        end
        debugprint("Notification are disabled for app", notificationData.app)
        return
    end
    
    -- Clona os dados da notificação para evitar modificações
    notificationData = table.clone(notificationData)
    
    -- Validação básica dos dados
    if type(notificationData) == "table" then
        if notificationData.app then
            -- Se tem app, verifica se o primeiro parâmetro é válido
            if type(phoneNumberOrSource) == "string" then
                -- É número de telefone válido
            else
                -- Dados inválidos
                if callback then
                    callback(false)
                end
                debugprint("Invalid data or no app")
                return
            end
        else
            -- Sem app especificado
            if callback then
                callback(false)
            end
            debugprint("Invalid data or no app")
            return
        end
    end
    -- Verifica se o conteúdo não é muito longo (máximo 500 caracteres)
    if notificationData.content and #notificationData.content > 500 then
        if callback then
            callback(false)
        end 
        debugprint("Content too long")
        return
    end
    -- Define o source se foi passado um número (ID do jogador)
    if type(phoneNumberOrSource) == "number" then
        notificationData.source = phoneNumberOrSource
    end
    
    -- Se tem app e não tem source ainda, tenta encontrar pelo número de telefone
    if notificationData.app then
        if not notificationData.source then
            if type(phoneNumberOrSource) == "string" then
                local playerSource = GetSourceFromNumber(phoneNumberOrSource)
                if playerSource then
                    notificationData.source = playerSource
                end
            end
        end
    end
    -- Se não tem app ou não é número de telefone válido, envia notificação direta
    if not notificationData.app or type(phoneNumberOrSource) ~= "string" then
        if callback then
            callback(true)
        end
        
        if notificationData.source then
            TriggerClientEvent("phone:sendNotification", notificationData.source, notificationData)
            debugprint("Sending notification to source: " .. notificationData.source)
        else
            debugprint("Couldn't find source, no notification printing")
        end
        
        debugprint("No app or no phone number provided (not a string)")
        return
    end
    -- Gerencia limite máximo de notificações por telefone
    if Config.MaxNotifications then
        local oldestNotificationId = MySQL.scalar.await(
            "SELECT id FROM phone_notifications WHERE phone_number = ? ORDER BY id DESC LIMIT ?, 1",
            {phoneNumberOrSource, Config.MaxNotifications - 1}
        )
        
        if oldestNotificationId then
            debugprint("Max notifications reached, deleting all older notifications", phoneNumberOrSource, oldestNotificationId)
            MySQL.update.await(
                "DELETE FROM phone_notifications WHERE phone_number = ? AND id <= ?",
                {phoneNumberOrSource, oldestNotificationId}
            )
        end
    end
    -- Insere a notificação no banco de dados
    local notificationId = MySQL.insert.await(
        "INSERT IGNORE INTO phone_notifications (phone_number, app, title, content, thumbnail, avatar, show_avatar, custom_data) VALUES (@phoneNumber, @app, @title, @content, @thumbnail, @avatar, @showAvatar, @data)",
        {
            ["@phoneNumber"] = phoneNumberOrSource,
            ["@app"] = notificationData.app,
            ["@title"] = notificationData.title,
            ["@content"] = notificationData.content,
            ["@thumbnail"] = notificationData.thumbnail,
            ["@avatar"] = notificationData.avatar,
            ["@showAvatar"] = notificationData.showAvatar,
            ["@data"] = notificationData.customData and json.encode(notificationData.customData) or nil
        }
    )
    
    notificationData.id = notificationId
    -- Envia a notificação para o cliente se o jogador está online
    if notificationData.source then
        TriggerClientEvent("phone:sendNotification", notificationData.source, notificationData)
        debugprint("Sending notification to source: " .. notificationData.source)
    else
        debugprint("Couldn't find source, no notification printing")
    end
    
    -- Executa callback se fornecido
    if callback then
        callback(notificationId)
    end
end
-- Exporta a função SendNotification para uso por outros recursos
exports("SendNotification", SendNotification)
-- Função para notificar todos os jogadores ou apenas os online
function NotifyEveryone(notifyType, notificationData)
    -- Validações dos parâmetros
    assert(notifyType == "all" or notifyType == "online", "Invalid notify")
    assert(type(notificationData and notificationData.app) == "string", "Invalid app")
    assert(type(notificationData and notificationData.title) == "string", "Invalid title")
    
    -- Verifica se as notificações estão desabilitadas para este app
    if table.contains(disabledNotifications, notificationData.app) then
        debugprint("NotifyEveryone: Notification are disabled for app", notificationData.app)
        return
    end
    -- Se notificar todos, insere notificações no banco para telefones ativos
    if notifyType == "all" then
        MySQL.insert(
            [[
            INSERT INTO phone_notifications
                (phone_number, app, title, content, thumbnail, avatar, show_avatar)
            SELECT
                phone_number, @app, @title, @content, @thumbnail, @avatar, @showAvatar
            FROM
                phone_phones
            WHERE
                last_seen > DATE_SUB(NOW(), INTERVAL 7 DAY)
            ]],
            {
                ["@app"] = notificationData.app,
                ["@title"] = notificationData.title,
                ["@content"] = notificationData.content,
                ["@thumbnail"] = notificationData.thumbnail,
                ["@avatar"] = notificationData.avatar,
                ["@showAvatar"] = notificationData.showAvatar
            }
        )
    end
    
    -- Envia notificação para todos os jogadores online
    TriggerClientEvent("phone:sendNotification", -1, notificationData)
end
-- Exporta a função NotifyEveryone para uso por outros recursos
exports("NotifyEveryone", NotifyEveryone)
-- Função para notificar telefones específicos baseado em uma query customizada
function NotifyPhones(fromQuery, notificationData, columnPrefix, queryParameters)
    -- Verifica se as notificações estão desabilitadas para este app
    if table.contains(disabledNotifications, notificationData.app) then
        debugprint("NotifyPhones: Notification are disabled for app", notificationData.app)
        return
    end
    
    -- Define parâmetros padrão se não fornecidos
    if not queryParameters then
        queryParameters = {}
    end
    if not columnPrefix then
        columnPrefix = ""
    end
    
    -- Monta parâmetros da query
    queryParameters["@app"] = notificationData.app
    queryParameters["@title"] = notificationData.title
    queryParameters["@content"] = notificationData.content
    queryParameters["@thumbnail"] = notificationData.thumbnail
    queryParameters["@avatar"] = notificationData.avatar
    queryParameters["@showAvatar"] = notificationData.showAvatar
    
    -- Monta a query INSERT customizada (sem RETURNING para compatibilidade MariaDB/MySQL)
    local insertQuery = string.format([[
        INSERT INTO phone_notifications
            (phone_number, app, title, content, thumbnail, avatar, show_avatar)
        SELECT
            %sphone_number, @app, @title, @content, @thumbnail, @avatar, @showAvatar
        FROM
            %s
    ]], columnPrefix, fromQuery)
    
    -- Executa o INSERT das notificações
    MySQL.query(insertQuery, queryParameters, function(insertResult)
        -- Após o INSERT, busca os telefones afetados e envia notificações
        local selectQuery = string.format("SELECT %sphone_number FROM %s", columnPrefix, fromQuery)
        
        MySQL.query(selectQuery, queryParameters, function(phoneResults)
            for i = 1, #phoneResults do
                local phoneNumber = phoneResults[i].phone_number
                local playerSource = GetSourceFromNumber(phoneNumber)
                
                if playerSource then
                    -- Busca o ID da notificação mais recente para este telefone
                    local notificationId = MySQL.scalar.await(
                        "SELECT id FROM phone_notifications WHERE phone_number = ? AND app = ? AND title = ? AND content = ? ORDER BY id DESC LIMIT 1",
                        {phoneNumber, queryParameters["@app"], queryParameters["@title"], queryParameters["@content"]}
                    )
                    
                    notificationData.id = notificationId
                    TriggerClientEvent("phone:sendNotification", playerSource, notificationData)
                end
            end
        end)
    end)
end
-- Função para enviar alertas de emergência
function EmergencyNotification(playerSource, alertData)
    -- Validações dos parâmetros
    assert(type(playerSource) == "number", "Invalid source")
    assert(type(alertData) == "table", "Invalid data")
    
    -- Monta dados da notificação de emergência
    local emergencyNotification = {
        app = "emergency",
        title = alertData.title or "Emergency Alert",
        content = alertData.content or "This is a test emergency alert.",
        thumbnail = "./assets/img/icons/" .. (alertData.icon or "warning") .. ".png"
    }
    
    -- Envia a notificação de emergência
    SendNotification(playerSource, emergencyNotification)
end
-- Exporta a função EmergencyNotification com dois nomes diferentes
exports("SendAmberAlert", EmergencyNotification)
exports("EmergencyNotification", EmergencyNotification)
-- Callback para obter todas as notificações de um telefone
BaseCallback("getNotifications", function(source, phoneNumber, ...)
    return MySQL.query.await(
        "SELECT id, app, title, content, thumbnail, avatar, show_avatar AS showAvatar, custom_data, `timestamp` FROM phone_notifications WHERE phone_number=?",
        {phoneNumber}
    )
end, {})
-- Callback para deletar uma notificação específica
BaseCallback("deleteNotification", function(source, phoneNumber, notificationId)
    local affectedRows = MySQL.update.await(
        "DELETE FROM phone_notifications WHERE id=? AND phone_number=?",
        {notificationId, phoneNumber}
    )
    return affectedRows > 0
end)
-- Callback para limpar todas as notificações de um app específico
BaseCallback("clearNotifications", function(source, phoneNumber, appName)
    MySQL.update.await(
        "DELETE FROM phone_notifications WHERE phone_number=? AND app=?",
        {phoneNumber, appName}
    )
    return true
end)
