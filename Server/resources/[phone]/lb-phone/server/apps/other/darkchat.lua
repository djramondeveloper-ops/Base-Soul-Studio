-- Função para notificar todos os usuários logados no DarkChat com um username específico
function NotifyLoggedInUsers(username, notification, excludePhoneNumber)
    -- Monta a query base
    local query = "SELECT phone_number FROM phone_logged_in_accounts WHERE app = 'DarkChat' AND `active` = 1 AND username = ?"
    
    -- Adiciona condição para excluir um número específico se fornecido
    if excludePhoneNumber then
        query = query .. " AND phone_number != ?"
    end
    
    -- Executa a consulta no banco de dados
    local loggedInAccounts = MySQL.query.await(query, {username, excludePhoneNumber})
    
    -- Envia notificação para cada número de telefone encontrado
    for i = 1, #loggedInAccounts do
        local phoneNumber = loggedInAccounts[i].phone_number
        SendNotification(phoneNumber, notification)
    end
end
-- Callback para obter o username do DarkChat do jogador
BaseCallback("darkchat:getUsername", function(source, phoneNumber)
    -- Verifica se já está logado no DarkChat
    local loggedInUsername = GetLoggedInAccount(phoneNumber, "DarkChat")
    
    if not loggedInUsername then
        -- Se não está logado, verifica se tem conta sem senha (conta automática)
        local automaticUsername = MySQL.scalar.await(
            "SELECT username FROM phone_darkchat_accounts WHERE phone_number = ? AND `password` IS NULL",
            {phoneNumber}
        )
        
        if automaticUsername then
            -- Faz login automático na conta sem senha
            AddLoggedInAccount(phoneNumber, "DarkChat", automaticUsername)
            loggedInUsername = automaticUsername
        else
            -- Não tem conta ou conta automática
            return false
        end
    end
    
    -- Verifica se a conta tem senha definida
    local hasPassword = MySQL.scalar.await(
        "SELECT TRUE FROM phone_darkchat_accounts WHERE username = ? AND `password` IS NOT NULL",
        {loggedInUsername}
    )
    
    -- Retorna informações do username e se tem senha
    return {
        username = loggedInUsername,
        password = hasPassword and true or false
    }
end)
-- Callback para definir senha em uma conta DarkChat
BaseCallback("darkchat:setPassword", function(source, phoneNumber, password)
    -- Valida se a senha tem pelo menos 3 caracteres
    if #password < 3 then
        debugprint("DarkChat: password < 3 characters")
        return false
    end
    
    -- Verifica se o usuário está logado no DarkChat
    local username = GetLoggedInAccount(phoneNumber, "DarkChat")
    if not username then
        return false
    end
    
    -- Verifica se a conta já tem senha definida
    local alreadyHasPassword = MySQL.scalar.await(
        "SELECT TRUE FROM phone_darkchat_accounts WHERE username = ? AND `password` IS NOT NULL",
        {username}
    )
    
    if alreadyHasPassword then
        return false
    end
    
    -- Gera hash da senha e atualiza no banco de dados
    local passwordHash = GetPasswordHash(password)
    MySQL.update.await(
        "UPDATE phone_darkchat_accounts SET `password` = ? WHERE username = ?",
        {passwordHash, username}
    )
    
    return true
end)
-- Callback para fazer login no DarkChat
BaseCallback("darkchat:login", function(source, phoneNumber, username, password)
    -- Busca a senha hash da conta no banco de dados
    local storedPasswordHash = MySQL.scalar.await(
        "SELECT `password` FROM phone_darkchat_accounts WHERE username = ?",
        {username}
    )
    
    -- Verifica se o username existe
    if not storedPasswordHash then
        return {
            success = false,
            reason = "invalid_username"
        }
    end
    
    -- Verifica se a senha está correta
    if not VerifyPasswordHash(password, storedPasswordHash) then
        return {
            success = false,
            reason = "incorrect_password"
        }
    end
    
    -- Faz login na conta
    AddLoggedInAccount(phoneNumber, "DarkChat", username)
    
    return {success = true}
end)
-- Callback para registrar nova conta no DarkChat
BaseCallback("darkchat:register", function(source, phoneNumber, username, password)
    -- Converte username para minúsculas
    username = username:lower()
    
    -- Valida se o username é permitido
    if not IsUsernameValid(username) then
        return {
            success = false,
            reason = "USERNAME_NOT_ALLOWED"
        }
    end
    
    -- Verifica se o username já existe
    local usernameExists = MySQL.scalar.await(
        "SELECT 1 FROM phone_darkchat_accounts WHERE username = ?",
        {username}
    )
    
    if usernameExists then
        return {
            success = false,
            reason = "username_taken"
        }
    end
    
    -- Gera hash da senha
    local passwordHash = GetPasswordHash(password)
    
    -- Cria a nova conta no banco de dados
    local insertResult = MySQL.update.await(
        "INSERT INTO phone_darkchat_accounts (phone_number, username, `password`) VALUES (?, ?, ?)",
        {phoneNumber, username, passwordHash}
    )
    
    -- Verifica se a inserção foi bem-sucedida
    if insertResult <= 0 then
        return {
            success = false,
            reason = "unknown"
        }
    end
    
    -- Faz login automático na nova conta
    AddLoggedInAccount(phoneNumber, "DarkChat", username)
    
    return {success = true}
end)
-- Função wrapper para callbacks que requerem autenticação no DarkChat
function CreateAuthenticatedCallback(callbackName, callbackFunction, fallbackValue)
    BaseCallback("darkchat:" .. callbackName, function(source, phoneNumber, ...)
        -- Verifica se o usuário está logado no DarkChat
        local username = GetLoggedInAccount(phoneNumber, "DarkChat")
        
        if not username then
            -- Se não está logado, retorna valor de fallback
            return fallbackValue
        end
        
        -- Se está logado, executa a função passando o username como parâmetro adicional
        return callbackFunction(source, phoneNumber, username, ...)
    end, fallbackValue)
end
-- Callback autenticado para alterar senha do DarkChat
CreateAuthenticatedCallback("changePassword", function(source, phoneNumber, username, currentPassword, newPassword)
    -- Verifica se a funcionalidade está habilitada na configuração
    if not Config.ChangePassword.DarkChat then
        infoprint("warning", 
            string.format("%s tried to change password on DarkChat, but it's not enabled in the config.", source)
        )
        return false
    end
    
    -- Valida se a nova senha é diferente da atual e tem pelo menos 3 caracteres
    if currentPassword == newPassword or #newPassword < 3 then
        debugprint("same password / too short")
        return false
    end
    
    -- Busca a senha atual no banco de dados
    local storedPasswordHash = MySQL.scalar.await(
        "SELECT `password` FROM phone_darkchat_accounts WHERE username = ?",
        {username}
    )
    
    -- Verifica se a senha atual está correta
    if not storedPasswordHash or not VerifyPasswordHash(currentPassword, storedPasswordHash) then
        return false
    end
    
    -- Atualiza a senha no banco de dados
    local updateResult = MySQL.update.await(
        "UPDATE phone_darkchat_accounts SET `password` = ? WHERE username = ?",
        {GetPasswordHash(newPassword), username}
    )
    
    if updateResult <= 0 then
        return false
    end
    
    -- Notifica outros dispositivos logados sobre a mudança de senha
    NotifyLoggedInUsers(username, {
        title = L("BACKEND.MISC.LOGGED_OUT_PASSWORD.TITLE"),
        content = L("BACKEND.MISC.LOGGED_OUT_PASSWORD.DESCRIPTION")
    }, phoneNumber)
    
    -- Desloga todos os outros dispositivos
    MySQL.update.await(
        "DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'DarkChat' AND phone_number != ?",
        {username, phoneNumber}
    )
    
    -- Limpa o cache de contas ativas
    ClearActiveAccountsCache("DarkChat", username, phoneNumber)
    
    -- Notifica clientes sobre o logout forçado
    TriggerClientEvent("phone:logoutFromApp", -1, {
        username = username,
        app = "darkchat",
        reason = "password",
        number = phoneNumber
    })
    
    return true
end, false)
-- Callback autenticado para deletar conta do DarkChat
CreateAuthenticatedCallback("deleteAccount", function(source, phoneNumber, username, password)
    -- Verifica se a funcionalidade está habilitada na configuração
    if not Config.DeleteAccount.DarkChat then
        infoprint("warning", 
            string.format("%s tried to delete their account on DarkChat, but it's not enabled in the config.", source)
        )
        return false
    end
    
    -- Busca a senha da conta no banco de dados
    local storedPasswordHash = MySQL.scalar.await(
        "SELECT `password` FROM phone_darkchat_accounts WHERE username = ?",
        {username}
    )
    
    -- Verifica se a senha está correta
    if not storedPasswordHash or not VerifyPasswordHash(password, storedPasswordHash) then
        return false
    end
    
    -- Notifica todos os dispositivos logados sobre a exclusão da conta
    NotifyLoggedInUsers(username, {
        title = L("BACKEND.MISC.DELETED_NOTIFICATION.TITLE"),
        content = L("BACKEND.MISC.DELETED_NOTIFICATION.DESCRIPTION")
    })
    
    -- Remove todos os logins da conta
    MySQL.update.await(
        "DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'DarkChat'",
        {username}
    )
    
    -- Limpa o cache de contas ativas
    ClearActiveAccountsCache("DarkChat", username)
    
    -- Notifica clientes sobre a exclusão da conta
    TriggerClientEvent("phone:logoutFromApp", -1, {
        username = username,
        app = "darkchat",
        reason = "deleted"
    })
    
    return true
end, false)
-- Callback autenticado para fazer logout do DarkChat
CreateAuthenticatedCallback("logout", function(source, phoneNumber, username)
    -- Remove a conta logada
    RemoveLoggedInAccount(phoneNumber, "DarkChat", username)
    return true
end, true)
-- Callback autenticado para entrar em um canal do DarkChat
CreateAuthenticatedCallback("joinChannel", function(source, phoneNumber, username, channelName)
    -- Verifica se já está no canal
    local alreadyInChannel = MySQL.scalar.await(
        "SELECT TRUE FROM phone_darkchat_members WHERE channel_name = ? AND username = ?",
        {channelName, username}
    )
    
    if alreadyInChannel then
        debugprint("darkchat: already in channel")
        return false
    end
    
    -- Verifica se o canal já existe
    local channelExists = MySQL.scalar.await(
        "SELECT TRUE FROM phone_darkchat_channels WHERE `name` = ?",
        {channelName}
    )
    
    -- Se o canal não existe, cria um novo
    if not channelExists then
        MySQL.update.await(
            "INSERT INTO phone_darkchat_channels (`name`) VALUES (?)",
            {channelName}
        )
        
        -- Registra log da criação do canal
        Log("DarkChat", source, "info",
            L("BACKEND.LOGS.DARKCHAT_CREATED_TITLE"),
            L("BACKEND.LOGS.DARKCHAT_CREATED_DESCRIPTION", {
                creator = username,
                channel = channelName
            })
        )
    end
    
    -- Adiciona o usuário ao canal
    local joinResult = MySQL.update.await(
        "INSERT INTO phone_darkchat_members (channel_name, username) VALUES (?, ?)",
        {channelName, username}
    )
    
    if joinResult <= 0 then
        debugprint("darkchat: failed to insert into members")
        return false
    end
    
    -- Se é um canal novo (primeiro membro), retorna dados simples
    if not channelExists then
        return {
            name = channelName,
            members = 1
        }
    end
    
    -- Busca informações completas do canal
    local channelInfo = MySQL.single.await([[
        SELECT `name`, (SELECT COUNT(username) FROM phone_darkchat_members WHERE channel_name = `name`) AS members
        FROM phone_darkchat_channels c
        WHERE `name` = ?
    ]], {channelName})
    
    -- Busca a última mensagem do canal
    local lastMessage = MySQL.single.await([[
        SELECT sender, content, `timestamp`
        FROM phone_darkchat_messages
        WHERE `channel` = ?
        ORDER BY `timestamp` DESC
        LIMIT 1
    ]], {channelName})
    
    -- Adiciona informações da última mensagem se existir
    if lastMessage then
        channelInfo.sender = lastMessage.sender
        channelInfo.lastMessage = lastMessage.content
        channelInfo.timestamp = lastMessage.timestamp
    end
    
    -- Notifica outros clientes sobre o novo membro
    TriggerClientEvent("phone:darkChat:updateChannel", -1, channelName, username, "joined")
    
    return channelInfo
end, false)
-- Callback autenticado para sair de um canal do DarkChat
CreateAuthenticatedCallback("leaveChannel", function(source, phoneNumber, username, channelName)
    -- Remove o usuário do canal
    local leaveResult = MySQL.update.await(
        "DELETE FROM phone_darkchat_members WHERE channel_name = ? AND username = ?",
        {channelName, username}
    )
    
    if leaveResult <= 0 then
        return false
    end
    
    -- Notifica outros clientes sobre o usuário que saiu
    TriggerClientEvent("phone:darkChat:updateChannel", -1, channelName, username, "left")
    
    return true
end, false)
-- Callback autenticado para obter lista de canais do usuário
CreateAuthenticatedCallback("getChannels", function(source, phoneNumber, username)
    -- Busca todos os canais onde o usuário é membro, incluindo a última mensagem
    return MySQL.query.await([[
        SELECT
            `name`,
            (SELECT COUNT(username) FROM phone_darkchat_members WHERE channel_name = `name`) AS members,
            m.sender AS sender,
            m.content AS lastMessage,
            m.`timestamp` AS `timestamp`
        FROM phone_darkchat_channels c
        LEFT JOIN phone_darkchat_messages m ON m.`channel` = c.name
        WHERE EXISTS (SELECT TRUE FROM phone_darkchat_members WHERE channel_name = c.name AND username = ?)
        AND COALESCE(m.`timestamp`, '1970-01-01 00:00:00') = (
            SELECT COALESCE(MAX(`timestamp`), '1970-01-01 00:00:00') FROM phone_darkchat_messages WHERE `channel` = c.`name`
        )
    ]], {username})
end, {})
-- Callback autenticado para obter mensagens de um canal (paginação)
CreateAuthenticatedCallback("getMessages", function(source, phoneNumber, username, channelName, page)
    -- Busca mensagens com paginação (15 por página)
    return MySQL.query.await([[
        SELECT sender, content, `timestamp`
        FROM phone_darkchat_messages
        WHERE `channel` = ?
        ORDER BY `timestamp` DESC
        LIMIT ?, ?
    ]], {channelName, page * 15, 15})
end, {})
-- Função interna para processar envio de mensagem no DarkChat
function ProcessDarkChatMessage(sender, channelName, messageContent)
    -- Insere a mensagem no banco de dados
    local insertResult = MySQL.insert.await(
        "INSERT INTO phone_darkchat_messages (sender, `channel`, content) VALUES (?, ?, ?)",
        {sender, channelName, messageContent}
    )
    
    if not insertResult then
        return false
    end
    
    -- Notifica membros do canal que estão online
    NotifyPhones([[
        phone_darkchat_members m
        JOIN phone_logged_in_accounts l
            ON l.app = 'DarkChat'
            AND l.`active` = 1
            AND l.username = m.username
        WHERE
            m.channel_name = @channel
            AND m.username != @username
    ]], {
        app = "DarkChat",
        title = channelName,
        content = sender .. ": " .. messageContent
    }, "l.", {
        ["@channel"] = channelName,
        ["@username"] = sender
    })
    
    -- Notifica clientes sobre a nova mensagem
    TriggerClientEvent("phone:darkChat:newMessage", -1, channelName, sender, messageContent)
    
    return true
end
-- Callback autenticado para enviar mensagem no DarkChat
CreateAuthenticatedCallback("sendMessage", function(source, phoneNumber, username, channelName, messageContent)
    -- Verifica se a mensagem contém palavras banidas
    if ContainsBlacklistedWord(source, "DarkChat", messageContent) then
        return false
    end
    
    -- Processa o envio da mensagem
    if not ProcessDarkChatMessage(username, channelName, messageContent) then
        return false
    end
    
    -- Registra log da mensagem enviada
    Log("DarkChat", source, "info",
        L("BACKEND.LOGS.DARKCHAT_MESSAGE_TITLE"),
        L("BACKEND.LOGS.DARKCHAT_MESSAGE_DESCRIPTION", {
            sender = username,
            channel = channelName,
            message = messageContent
        })
    )
    
    return true
end, false)
-- Export para enviar mensagem no DarkChat externamente
exports("SendDarkChatMessage", function(username, channelName, messageContent, callback)
    -- Validações de tipo
    assert(type(username) == "string", "username must be a string")
    assert(type(channelName) == "string", "channel must be a string")
    assert(type(messageContent) == "string", "message must be a string")
    
    -- Processa o envio da mensagem
    local success = ProcessDarkChatMessage(username, channelName, messageContent)
    
    -- Executa callback se fornecido
    if callback then
        callback(success)
    end
    
    return success
end)
-- Export para enviar localização no DarkChat externamente
exports("SendDarkChatLocation", function(username, channelName, location, callback)
    -- Validações de tipo com mensagens de erro detalhadas
    assert(type(username) == "string", "Expected string for argument 1, got " .. type(username))
    assert(type(channelName) == "string", "Expected string for argument 2, got " .. type(channelName))
    assert(type(location) == "vector2", "Expected vector2 for argument 3, got " .. type(location))
    
    -- Formata mensagem de localização
    local locationMessage = "<!SENT-LOCATION-X=" .. location.x .. "Y=" .. location.y .. "!>"
    
    -- Processa o envio da localização
    local success = ProcessDarkChatMessage(username, channelName, locationMessage)
    
    -- Executa callback se fornecido
    if callback then
        callback(success)
    end
    
    return success
end)
