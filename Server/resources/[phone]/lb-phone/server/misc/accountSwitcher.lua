-- Cache local das contas ativas por aplicativo
local activeAccountsCache = {}

-- Lista de aplicativos que suportam múltiplas contas
local supportedApps = {
    Twitter = true,
    Instagram = true,
    Mail = true,
    TikTok = true,
    DarkChat = true
}

-- Mapeamento de nomes de aplicativos alternativos
local appNameMapping = {
    instapic = "Instagram",
    birdy = "Twitter", 
    trendy = "TikTok",
    darkchat = "DarkChat",
    mail = "Mail"
}

-- Inicializa cache vazio para cada aplicativo suportado
for appName, _ in pairs(supportedApps) do
    activeAccountsCache[appName] = {}
end
-- Callback para trocar de conta ativa em um aplicativo
BaseCallback("accountSwitcher:switchAccount", function(source, phoneNumber, appName, username)
    -- Verifica se o aplicativo é suportado
    if not supportedApps[appName] then
        return false
    end
    
    -- Verifica se o jogador está realmente logado nesta conta
    local isLoggedIn = MySQL.scalar.await(
        "SELECT TRUE FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ? AND username = ?",
        {phoneNumber, appName, username}
    )
    
    if not isLoggedIn then
        print(string.format(
            "Possible abuse? %s (%i) tried to switch to an account they aren't logged into.",
            GetPlayerName(source), source
        ))
        return false
    end
    
    -- Atualiza no banco: define esta conta como ativa e as outras como inativas
    local rowsAffected = MySQL.update.await(
        "UPDATE phone_logged_in_accounts SET `active` = (username = ?) WHERE phone_number = ? AND app = ?",
        {username, phoneNumber, appName}
    )
    
    local success = rowsAffected > 0
    if success then
        -- Atualiza cache local
        activeAccountsCache[appName][phoneNumber] = username
        
        -- Dispara evento para outros sistemas
        TriggerEvent("phone:loggedInToAccount", appName, phoneNumber, username)
    end
    
    return success
end)
-- Callback para obter todas as contas disponíveis de um aplicativo
BaseCallback("accountSwitcher:getAccounts", function(source, phoneNumber, appName)
    -- Verifica se o aplicativo é suportado
    if not supportedApps[appName] then
        return {}
    end
    
    -- Busca todas as contas do telefone para este aplicativo
    return MySQL.query.await(
        "SELECT username FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ?",
        {phoneNumber, appName}
    )
end)
-- Função para adicionar uma conta logada e defini-la como ativa
function AddLoggedInAccount(phoneNumber, appName, username)
    -- Validações dos parâmetros
    assert(supportedApps[appName], "Invalid app: " .. appName)
    assert(type(phoneNumber) == "string", "Invalid phone number. Expected string.")
    assert(type(username) == "string", "Invalid username. Expected string.")
    
    -- Primeiro, desativa todas as outras contas do mesmo app
    MySQL.update.await(
        "UPDATE phone_logged_in_accounts SET `active` = 0 WHERE phone_number = ? AND app = ? AND username != ?",
        {phoneNumber, appName, username}
    )
    
    -- Insere ou atualiza a conta como ativa
    local rowsAffected = MySQL.update.await(
        "INSERT INTO phone_logged_in_accounts (phone_number, app, username, active) VALUES (?, ?, ?, 1) ON DUPLICATE KEY UPDATE active = 1",
        {phoneNumber, appName, username}
    )
    
    local success = rowsAffected > 0
    if success then
        -- Atualiza cache local
        activeAccountsCache[appName][phoneNumber] = username
        
        -- Dispara evento para outros sistemas
        TriggerEvent("phone:loggedInToAccount", appName, phoneNumber, username)
    end
    
    return success
end
-- Função para remover uma conta logada
function RemoveLoggedInAccount(phoneNumber, appName, username)
    -- Validações dos parâmetros
    assert(supportedApps[appName], "Invalid app: " .. appName)
    assert(type(phoneNumber) == "string", "Invalid phone number. Expected string.")
    assert(type(username) == "string", "Invalid username. Expected string.")
    
    -- Remove a conta do banco de dados
    local rowsAffected = MySQL.update.await(
        "DELETE FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ? AND username = ?",
        {phoneNumber, appName, username}
    )
    
    local success = rowsAffected > 0
    if success then
        -- Se esta era a conta ativa no cache, remove do cache
        if activeAccountsCache[appName][phoneNumber] == username then
            activeAccountsCache[appName][phoneNumber] = nil
        end
        
        -- Dispara evento para outros sistemas
        TriggerEvent("phone:loggedOutFromAccount", appName, username, phoneNumber)
    end
    
    return success
end
-- Função para obter a conta ativa de um telefone em um aplicativo
function GetLoggedInAccount(phoneNumber, appName, skipCacheUpdate)
    -- Validações dos parâmetros
    assert(supportedApps[appName], "Invalid app: " .. appName)
    assert(type(phoneNumber) == "string", "Invalid phone number. Expected string.")
    
    -- Verifica primeiro no cache local
    local cachedUsername = activeAccountsCache[appName][phoneNumber]
    if cachedUsername then
        return cachedUsername
    end
    
    -- Se não está no cache, busca no banco de dados
    local username = MySQL.scalar.await(
        "SELECT username FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ? AND active = 1",
        {phoneNumber, appName}
    )
    
    -- Atualiza o cache se encontrou um usuário e não foi solicitado para pular
    if username and not skipCacheUpdate then
        debugprint("AccountSwitcher: Setting cache for " .. phoneNumber .. ", logged in as " .. username .. " on " .. appName)
        activeAccountsCache[appName][phoneNumber] = username
    end
    
    return username or false
end
-- Função para obter todos os números de telefone logados com um username específico
function GetLoggedInNumbers(appName, username)
    -- Validações dos parâmetros
    assert(supportedApps[appName], "Invalid app: " .. appName)
    assert(type(username) == "string", "Invalid username. Expected string.")
    
    -- Busca todos os telefones logados com este username
    local results = MySQL.query.await(
        "SELECT phone_number FROM phone_logged_in_accounts WHERE app = ? AND username = ?",
        {appName, username}
    )
    
    if not results then
        return {}
    end
    
    -- Extrai apenas os números de telefone do resultado
    local phoneNumbers = {}
    for i = 1, #results do
        phoneNumbers[#phoneNumbers + 1] = results[i].phone_number
    end
    
    return phoneNumbers
end
-- Função para obter todas as contas ativas de um aplicativo
function GetActiveAccounts(appName)
    return activeAccountsCache[appName] or {}
end
-- Função para limpar cache de contas ativas (exceto um telefone específico)
function ClearActiveAccountsCache(appName, username, excludePhoneNumber)
    -- Validações dos parâmetros
    assert(supportedApps[appName], "Invalid app: " .. appName)
    assert(type(username) == "string", "Invalid username. Expected string.")
    
    -- Remove do cache todos os telefones que usam este username, exceto o especificado
    for phoneNumber, cachedUsername in pairs(activeAccountsCache[appName]) do
        if cachedUsername == username and phoneNumber ~= excludePhoneNumber then
            activeAccountsCache[appName][phoneNumber] = nil
        end
    end
end
-- Export para obter username de redes sociais por nome alternativo da app
exports("GetSocialMediaUsername", function(phoneNumber, appAlias)
    -- Validações dos parâmetros
    assert(type(phoneNumber) == "string", "Invalid phone number. Expected string.")
    assert(type(appAlias) == "string", "Invalid app. Expected string.")
    assert(appNameMapping[appAlias], "Invalid app: " .. appAlias)
    
    -- Converte o alias para o nome real da app e busca a conta
    return GetLoggedInAccount(phoneNumber, appNameMapping[appAlias], true)
end)
-- Event handler para quando um jogador desconecta do servidor
AddEventHandler("playerDropped", function()
    local phoneNumber = GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return
    end
    
    -- Remove o telefone do cache de todas as apps quando o jogador desconecta
    for appName, appCache in pairs(activeAccountsCache) do
        if appCache[phoneNumber] then
            appCache[phoneNumber] = nil
            debugprint("AccountSwitcher: Player dropped, logging out " .. phoneNumber .. " from " .. appName)
        end
    end
end)
