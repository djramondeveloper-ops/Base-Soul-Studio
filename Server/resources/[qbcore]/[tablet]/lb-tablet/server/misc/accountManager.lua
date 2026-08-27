local loggedInCache = {}

local supportedApps = {
    mail = true
}

local function isSupportedApp(app)
    return supportedApps[app] or false
end

local function fetchLoggedInAccounts(tabletId, app)
    local data = {
        active = false,
        accounts = {}
    }

    local rows = MySQL.query.await(
        "SELECT `account`, `active` FROM lbtablet_apps_loggedin WHERE tablet_id = ? AND `app` = ?",
        { tabletId, app }
    )

    for i = 1, #rows do
        local row = rows[i]

        if row.active then
            data.active = row.account
        end

        data.accounts[#data.accounts + 1] = row.account
    end

    loggedInCache[tabletId] = loggedInCache[tabletId] or {}
    loggedInCache[tabletId][app] = data

    debugprint(("Fetched logged in accounts for tablet %s and app %s"):format(tabletId, app), data)

    return data
end

function GetActiveAccount(tabletId, app)
    if not isSupportedApp(app) then
        return false
    end

    local cachedApp = loggedInCache[tabletId] and loggedInCache[tabletId][app]
    if cachedApp and cachedApp.active ~= nil then
        return cachedApp.active
    end

    return fetchLoggedInAccounts(tabletId, app).active
end

function GetSignedInAccounts(tabletId, app)
    if not isSupportedApp(app) then
        return {}
    end

    local cachedApp = loggedInCache[tabletId] and loggedInCache[tabletId][app]
    if cachedApp and cachedApp.accounts then
        return cachedApp.accounts
    end

    return fetchLoggedInAccounts(tabletId, app).accounts
end

function AddSignedInAccount(tabletId, app, account)
    if not isSupportedApp(app) then
        return false
    end

    local accounts = GetSignedInAccounts(tabletId, app)

    for i = 1, #accounts do
        if accounts[i] == account then
            debugprint("Account already signed in", account)
            return true
        end
    end

    MySQL.insert.await(
        "INSERT INTO lbtablet_apps_loggedin (tablet_id, app, `account`) VALUES (?, ?, ?)",
        { tabletId, app, account }
    )

    fetchLoggedInAccounts(tabletId, app)
    return true
end

function SetActiveAccount(tabletId, app, account)
    if not isSupportedApp(app) then
        return false
    end

    local accountData = loggedInCache[tabletId] and loggedInCache[tabletId][app]
    if not accountData then
        accountData = fetchLoggedInAccounts(tabletId, app)
    end

    local accounts = accountData.accounts or {}
    local currentActive = accountData.active
    local accountExists = false

    if not account then
        if not currentActive then
            return false
        end

        for i = 1, #accounts do
            if accounts[i] == currentActive then
                table.remove(accounts, i)
                break
            end
        end

        MySQL.update.await(
            "DELETE FROM lbtablet_apps_loggedin WHERE tablet_id = ? AND `app` = ? AND `account` = ?",
            { tabletId, app, currentActive }
        )

        loggedInCache[tabletId][app].active = false

        debugprint(GetSignedInAccounts(tabletId, app))
        return true
    end

    for i = 1, #accounts do
        if accounts[i] == account then
            accountExists = true
            break
        end
    end

    if not accountExists then
        return false
    end

    local success = MySQL.transaction.await({
        {
            "UPDATE lbtablet_apps_loggedin SET `active` = 0 WHERE tablet_id = ? AND app = ?",
            { tabletId, app }
        },
        {
            "UPDATE lbtablet_apps_loggedin SET `active` = 1 WHERE tablet_id = ? AND app = ? AND `account` = ?",
            { tabletId, app, account }
        }
    })

    if not success then
        return false
    end

    debugprint(("Set active account for tablet %s and app %s to %s"):format(tabletId, app, account))
    loggedInCache[tabletId][app].active = account

    return true
end

BaseCallback("accountManager:switch", function(source, tabletId, app, account)
    if not isSupportedApp(app) then
        return false
    end

    return SetActiveAccount(tabletId, app, account)
end)

BaseCallback("accountManager:getAccounts", function(source, tabletId, app)
    if not isSupportedApp(app) then
        return false
    end

    return GetSignedInAccounts(tabletId, app)
end)

OnTabletDisconnect(function(tabletId)
    if loggedInCache[tabletId] then
        debugprint("Removing logged in accounts for tablet " .. tabletId)
        loggedInCache[tabletId] = nil
    end
end)