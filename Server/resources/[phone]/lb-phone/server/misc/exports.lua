-- Sistema de Exports para lb-phone
-- Funções exportadas para outros recursos interagirem com o sistema

-- Tabela de apps de redes sociais suportados
local supportedSocialApps = {
    twitter = true,
    instagram = true,
    tiktok = true
}

-- Mapeamento de nomes alternativos para apps
local appAliases = {
    birdy = "twitter",
    instapic = "instagram",
    trendy = "tiktok"
}

-- Nomes de exibição dos apps
local appDisplayNames = {
    twitter = "Twitter",
    instagram = "Instagram",
    tiktok = "TikTok"
}
-- Função para alternar status de verificação de contas de redes sociais
function ToggleVerified(appName, username, isVerified)
    -- Validação do nome do app
    assert(type(appName) == "string", "Invalid app")
    
    -- Converte para minúsculas para padronização
    appName = appName:lower()
    
    -- Verifica se é um alias e converte para o nome real
    if not supportedSocialApps[appName] then
        appName = tostring(appAliases[appName])
    end
    
    -- Verifica se o app é suportado
    assert(supportedSocialApps[appName], "Invalid app")
    
    -- Validação do username
    assert(type(username) == "string", "Invalid username")
    
    -- Dispara evento para outros recursos
    TriggerEvent("lb-phone:toggleVerified", appName, username, isVerified)
    
    -- Atualiza o status de verificação na base de dados
    local query = ("UPDATE phone_%s_accounts SET verified=@verified WHERE username=@username"):format(appName)
    local affectedRows = MySQL.Sync.execute(query, {
        ["@username"] = username,
        ["@verified"] = isVerified
    })
    
    local success = affectedRows > 0
    
    -- Se a operação foi bem-sucedida e o usuário foi verificado, envia notificações
    if success and isVerified then
        local displayName = appDisplayNames[appName]
        if displayName then
            -- Busca todos os telefones logados nesta conta
            local loggedInPhones = MySQL.query.await(
                "SELECT phone_number FROM phone_logged_in_accounts WHERE app = ? AND username = ? AND `active` = 1",
                { appName, username }
            )
            
            -- Envia notificação para cada telefone logado
            for i = 1, #loggedInPhones do
                local phoneNumber = loggedInPhones[i].phone_number
                SendNotification(phoneNumber, {
                    app = displayName,
                    title = L("BACKEND.MISC.VERIFIED")
                })
            end
        end
    end
    
    return success
end

-- Export da função ToggleVerified
exports("ToggleVerified", ToggleVerified)
-- Export para verificar se uma conta está verificada
exports("IsVerified", function(appName, username)
    -- Validação do nome do app
    assert(type(appName) == "string", "Invalid app")
    
    -- Converte para minúsculas para padronização
    appName = appName:lower()
    
    -- Verifica se é um alias e converte para o nome real
    if not supportedSocialApps[appName] then
        appName = tostring(appAliases[appName])
    end
    
    -- Verifica se o app é suportado
    assert(supportedSocialApps[appName], "Invalid app")
    
    -- Validação do username
    assert(type(username) == "string", "Invalid username")
    
    -- Busca o status de verificação na base de dados
    local query = ("SELECT verified FROM phone_%s_accounts WHERE username=@username"):format(appName)
    local isVerified = MySQL.Sync.fetchScalar(query, {
        ["@username"] = username
    })
    
    -- Retorna false se não encontrou ou se não está verificado
    return isVerified or false
end)
-- Mapeamento dos campos de identificação para cada app
local appUsernameFields = {
    twitter = "username",
    instagram = "username", 
    tiktok = "username",
    mail = "address",
    darkchat = "username"
}

-- Função para alterar senha de contas de apps
function ChangePassword(appName, username, newPassword)
    -- Validação do nome do app
    assert(type(appName) == "string", "Invalid app")
    
    -- Converte para minúsculas para padronização
    appName = appName:lower()
    
    -- Verifica se é um alias e converte para o nome real
    if not appUsernameFields[appName] then
        appName = tostring(appAliases[appName])
    end
    
    -- Verifica se o app é suportado
    assert(appUsernameFields[appName], "Invalid app")
    
    -- Validações dos parâmetros
    assert(type(username) == "string", "Invalid username")
    assert(type(newPassword) == "string", "Invalid password")
    
    -- Obtém o campo de identificação do usuário para este app
    local usernameField = appUsernameFields[appName]
    
    -- Atualiza a senha na base de dados
    local query = ("UPDATE phone_%s_accounts SET password=@password WHERE %s=@username"):format(appName, usernameField)
    local affectedRows = MySQL.Sync.execute(query, {
        ["@username"] = username,
        ["@password"] = GetPasswordHash(newPassword)
    })
    
    -- Verifica se a atualização foi bem-sucedida
    if affectedRows == 0 then
        return false
    end
    
    -- Desconecta todos os dispositivos logados nesta conta (força novo login)
    MySQL.update(
        "DELETE FROM phone_logged_in_accounts WHERE app = ? AND username = ?",
        { appName, username }
    )
    
    return true
end

-- Export da função ChangePassword
exports("ChangePassword", ChangePassword)
-- Export para obter número do telefone equipado
exports("GetEquippedPhoneNumber", function(identifier)
    if type(identifier) == "number" then
        return GetEquippedPhoneNumber(identifier)
    end

    local playerSource = GetSourceFromIdentifier and GetSourceFromIdentifier(identifier)
    if playerSource then
        local equipped = GetEquippedPhoneNumber(playerSource)
        if equipped then return equipped end
    end

    local tableName = Config.Item.Unique and "phone_last_phone" or "phone_phones"

    if Config.Framework == "standalone" then
        local value = tostring(identifier or "")
        local passport = value:match("^vrp:(%d+)$")
            or value:match("^pandora:(%d+)$")
            or value:match("^(%d+)$")

        if passport then
            local currentIdentifier = "vrp:" .. passport
            local legacyIdentifier = "pandora:" .. passport
            local bareIdentifier = tostring(passport)

            if tableName == "phone_last_phone" then
                return MySQL.scalar.await(
                    "SELECT phone_number FROM phone_last_phone WHERE id IN (?, ?, ?) LIMIT 1",
                    { currentIdentifier, legacyIdentifier, bareIdentifier }
                )
            end

            return MySQL.scalar.await([[
                SELECT phone_number
                FROM phone_phones
                WHERE id IN (?, ?, ?) OR owner_id IN (?, ?, ?)
                ORDER BY CASE WHEN id = ? OR owner_id = ? THEN 0 ELSE 1 END, last_seen DESC
                LIMIT 1
            ]], {
                currentIdentifier, legacyIdentifier, bareIdentifier,
                currentIdentifier, legacyIdentifier, bareIdentifier,
                currentIdentifier, currentIdentifier
            })
        end
    end

    return MySQL.scalar.await(("SELECT phone_number FROM %s WHERE id = ? LIMIT 1"):format(tableName), { identifier })
end)
