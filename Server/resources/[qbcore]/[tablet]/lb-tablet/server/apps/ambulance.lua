local ambulanceAccounts = {}
local ambulanceJobs = {}
local ambulanceGrades = {}
local ambulanceTags = {}
local ambulanceConditions = {}
local pendingAccountGeneration = {}

for jobName in pairs(Config.Ambulance.Permissions) do
    ambulanceJobs[#ambulanceJobs + 1] = jobName
end

local function findConditionById(conditionId)
    for _, conditions in pairs(ambulanceConditions) do
        for index = 1, #conditions do
            local condition = conditions[index]
            if condition.id == conditionId then
                return condition, index
            end
        end
    end
end

MySQL.ready(function()
    while not DatabaseCheckerFinished do
        Wait(500)
    end

    ambulanceGrades = GetJobGrades(ambulanceJobs)

    ambulanceTags = MySQL.query.await([[
        SELECT
            id,
            title,
            color,
            tag_type AS `type`
        FROM lbtablet_ambulance_tags
    ]])

    local loadedConditions = MySQL.query.await([[
        SELECT
            co.id,
            co.severity,
            co.category_id,
            co.title,
            ca.title AS category
        FROM lbtablet_ambulance_conditions_categories ca
        LEFT JOIN lbtablet_ambulance_conditions co ON co.category_id = ca.id
        ORDER BY co.category_id ASC, co.severity DESC, co.id ASC
    ]])

    for index = 1, #loadedConditions do
        local condition = loadedConditions[index]
        local categoryName = condition.category

        if not ambulanceConditions[categoryName] then
            ambulanceConditions[categoryName] = {}
        end

        if condition.id then
            ambulanceConditions[categoryName][#ambulanceConditions[categoryName] + 1] = condition
        end
    end
end)

local function findTagById(tagId)
    for index = 1, #ambulanceTags do
        local tag = ambulanceTags[index]
        if tag.id == tagId then
            return tag, index
        end
    end
end

local doctorsCacheTime = 0
local cachedDoctorIdentifiers = {}

local function notifyAmbulanceTablets(data, ignoredIdentifiers)
    local now = os.time()

    if doctorsCacheTime < (now - 60) then
        cachedDoctorIdentifiers = GetIdentifiersWithJob(ambulanceJobs)
        doctorsCacheTime = now

        debugprint("Fetched doctors", #cachedDoctorIdentifiers)
    end

    data.app = "Ambulance"
    NotifyTablets(cachedDoctorIdentifiers, data, ignoredIdentifiers)
end

local function registerAmbulanceCallback(name, handler, permissions, rawCallback)
    BaseCallback("ambulance:" .. name, function(source, identifier, ...)
        local job = GetJob(source)

        if not job or not Config.Ambulance.Permissions[job.name] then
            debugprint(
                "No permissions to access ambulance app. Identifier:",
                identifier,
                "Job:",
                job and job.name or "nil"
            )
            return false
        end

        return handler(source, identifier, ...)
    end, permissions, rawCallback)
end

local function callsignExists(callsign)
    local result = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_ambulance_accounts WHERE callsign = ?",
        { callsign }
    )

    return result ~= nil
end

local function generateCallsign()
    local format = Config.Ambulance.Callsign.Format or "11-1111"
    local callsign = GenerateStringFromPattern(format)
    local attempts = 0

    while callsignExists(callsign) do
        attempts = attempts + 1

        if attempts > 50 then
            infoprint(
                "error",
                "Failed to generate a unique callsign after 50 attempts. Consider changing Config.Ambulance.Callsign.Format"
            )
        end

        callsign = GenerateStringFromPattern(format)
        Wait(0)
    end

    return callsign
end

local function isValidCallsign(callsign)
    if not Config.Ambulance.Callsign.RequireTemplate then
        return true
    end

    local pattern = GetStringMatchPattern(Config.Ambulance.Callsign.Format)
    return callsign:match(pattern) ~= nil
end

registerAmbulanceCallback("getEmployees", function(source)
    local employees = GetEmployees(ambulanceJobs, "lbtablet_ambulance_accounts")

    for index = 1, #employees do
        local employee = employees[index]
        local employeeSource = GetSourceFromIdentifier(employee.id)

        if employeeSource then
            employee.onDuty = IsOnDuty(employeeSource)
        end
    end

    return {
        employees = employees,
        ranks = ambulanceGrades.grades,
        labels = ambulanceGrades.labels
    }
end)

function GetAmbulanceCallsign(identifier)
    local account = ambulanceAccounts[identifier]
    return account and account.callsign
end

function GetAmbulanceAvatar(identifier)
    local account = ambulanceAccounts[identifier]
    return account and account.avatar
end

exports("GetAmbulanceCallsign", GetAmbulanceCallsign)
exports("GetAmbulanceAvatar", GetAmbulanceAvatar)

local function getLoggedInAccount(source, tabletId)
    local cachedAccount = ambulanceAccounts[tabletId]
    local job = GetJob(source)

    if cachedAccount then
        cachedAccount.rank = job.grade_label
        return cachedAccount
    end

    local account = MySQL.single.await(
        "SELECT * FROM lbtablet_ambulance_accounts WHERE id = ?",
        { tabletId }
    )

    if not account then
        if pendingAccountGeneration[tabletId] then
            debugprint("Already generating ambulance account for tabletId", tabletId)

            while pendingAccountGeneration[tabletId] do
                Wait(0)
            end

            return ambulanceAccounts[tabletId]
        end

        pendingAccountGeneration[tabletId] = true

        local firstname, lastname = GetCharacterName(source)
        local displayName = firstname .. " " .. lastname
        local callsign = nil

        if Config.Ambulance.Callsign.AutoGenerate then
            callsign = generateCallsign()
        end

        local fields = "id, display_name"
        local values = { tabletId, displayName }

        if callsign then
            fields = fields .. ", callsign"
            values[#values + 1] = callsign
        end

        local placeholders = string.rep("?, ", #values):sub(1, -3)

        MySQL.update.await(
            "INSERT INTO lbtablet_ambulance_accounts (" .. fields .. ") VALUES (" .. placeholders .. ")",
            values
        )

        account = {
            id = tabletId,
            display_name = displayName,
            callsign = callsign
        }

        SetTimeout(1000, function()
            pendingAccountGeneration[tabletId] = nil
        end)
    end

    local formattedAccount = {
        id = account.id,
        name = account.display_name,
        avatar = account.avatar,
        callsign = account.callsign,
        rank = job.grade_label
    }

    ambulanceAccounts[tabletId] = formattedAccount
    return formattedAccount
end

registerAmbulanceCallback("getLoggedIn", getLoggedInAccount)

registerAmbulanceCallback("updateOwnAccount", function(source, identifier, callsign, avatar)
    local account = ambulanceAccounts[identifier]

    if (not account or account.callsign ~= callsign) and not isValidCallsign(callsign) then
        debugprint("Invalid callsign")
        return false
    end

    if account and account.callsign == callsign and account.avatar == avatar then
        debugprint("no changes made, not updating account")
        return true
    end

    local updated = MySQL.update.await(
        "UPDATE lbtablet_ambulance_accounts SET callsign = ?, avatar = ? WHERE id = ?",
        { callsign, avatar, identifier }
    ) > 0

    if updated and ambulanceAccounts[identifier] then
        ambulanceAccounts[identifier].callsign = callsign
        ambulanceAccounts[identifier].avatar = avatar

        TriggerClientEvent("tablet:ambulance:updateCallsign", -1, {
            source = source,
            identifier = identifier,
            callsign = callsign
        })
    end

    return updated
end)

exports("SetAmbulanceCallsign", function(identifier, callsign, skipValidation)
    assert(type(identifier) == "string", "SetAmbulanceCallsign: identifier must be a string")
    assert(type(callsign) == "string", "SetAmbulanceCallsign: callsign must be a string")

    if not skipValidation and not isValidCallsign(callsign) then
        infoprint("warning", "SetAmbulanceCallsign: Invalid callsign '" .. callsign .. "'")
        return false
    end

    MySQL.update(
        "UPDATE lbtablet_ambulance_accounts SET callsign = ? WHERE id = ?",
        { callsign, identifier }
    )

    if ambulanceAccounts[identifier] then
        ambulanceAccounts[identifier].callsign = callsign

        TriggerClientEvent("tablet:ambulance:updateCallsign", -1, {
            source = source,
            identifier = identifier,
            callsign = callsign
        })
    end

    return true
end)

local function createAmbulanceLog(createdBy, relatedId, action, logType, title, content)
    MySQL.insert(
        "INSERT INTO lbtablet_ambulance_logs (created_by, related_id, log_type, log_action, title, content) VALUES (?, ?, ?, ?, ?, ?)",
        {
            createdBy,
            tostring(relatedId),
            logType,
            action,
            title,
            content
        }
    )

    local source = GetSourceFromIdentifier(createdBy)
    if source then
        local level = (action == "create" or action == "update") and "info" or "warning"

        Log(source, "Ambulance", level, title, {
            relatedId = relatedId,
            logType = logType,
            action = action,
            content = content
        })
    end
end

registerAmbulanceCallback("getLogs", function(source, identifier, query, lastId)
    if not HasPermission(source, "Ambulance", "logs", "view") then
        return {}
    end

    local sql = [[
        SELECT
            l.log_id, l.related_id, l.created_by, l.log_type, l.log_action, l.title, l.content, l.created_at,
            a.display_name, a.avatar
        FROM lbtablet_ambulance_logs l
        LEFT JOIN lbtablet_ambulance_accounts a ON a.id = l.created_by
        %s
        ORDER BY l.log_id DESC
        LIMIT 10
    ]]

    local params = {}

    if lastId then
        params[#params + 1] = lastId
    end

    if query then
        params[#params + 1] = "%" .. query .. "%"
        params[#params + 1] = "%" .. query .. "%"
    end

    if lastId and query then
        sql = sql:format("WHERE l.log_id < ? AND (l.title LIKE ? OR l.content LIKE ?)")
    elseif lastId then
        sql = sql:format("WHERE l.log_id < ?")
    elseif query then
        sql = sql:format("WHERE l.title LIKE ? OR l.content LIKE ?")
    else
        sql = sql:format("")
    end

    local logs = MySQL.query.await(sql, params)

    for index = 1, #logs do
        local log = logs[index]

        logs[index] = {
            username = log.display_name or "??",
            avatar = log.avatar,
            identifier = log.created_by,
            id = log.log_id,
            relatedId = log.related_id,
            type = log.log_type,
            action = log.log_action,
            title = log.title,
            description = log.content,
            timestamp = log.created_at
        }
    end

    return logs
end, {})

registerAmbulanceCallback("getConditions", function()
    return ambulanceConditions
end)

registerAmbulanceCallback("addConditionCategory", function(source, identifier, categoryName)
    if not HasPermission(source, "Ambulance", "condition", "create") then
        debugprint("No permissions to create category")
        return false
    end

    local exists = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_ambulance_conditions_categories WHERE title = ?",
        { categoryName }
    )

    if exists then
        debugprint("Category already exists")
        return false
    end

    local categoryId = MySQL.insert.await(
        "INSERT INTO lbtablet_ambulance_conditions_categories (title) VALUES (?)",
        { categoryName }
    )

    if not categoryId then
        debugprint("Failed to insert category")
        return false
    end

    ambulanceConditions[categoryName] = {}

    TriggerClientEvent("tablet:ambulance:addConditionCategory", -1, categoryName)

    createAmbulanceLog(
        identifier,
        categoryId,
        "create",
        "condition_category",
        L("BACKEND.AMBULANCE.LOGS.CREATE_CONDITION_CATEGORY.TITLE"),
        L("BACKEND.AMBULANCE.LOGS.CREATE_CONDITION_CATEGORY.DESCRIPTION", {
            name = categoryName
        })
    )

    return true
end, nil, true)

registerAmbulanceCallback("updateConditionCategory", function(source, identifier, oldCategory, newCategory)
    if not HasPermission(source, "Ambulance", "condition", "edit") then
        debugprint("No permissions to edit category")
        return false
    end

    if not ambulanceConditions[oldCategory] then
        debugprint("Old category doesn't exist")
        return false
    end

    local updated = MySQL.update.await(
        "UPDATE lbtablet_ambulance_conditions_categories SET title = ? WHERE title = ?",
        { newCategory, oldCategory }
    ) > 0

    if not updated then
        debugprint("Failed to change condition category title")
        return false
    end

    ambulanceConditions[newCategory] = ambulanceConditions[oldCategory]
    ambulanceConditions[oldCategory] = nil

    TriggerClientEvent("tablet:ambulance:updateConditionCategory", -1, oldCategory, newCategory)

    createAmbulanceLog(
        identifier,
        oldCategory,
        "update",
        "condition_category",
        L("BACKEND.AMBULANCE.LOGS.UPDATE_CONDITION_CATEGORY.TITLE"),
        L("BACKEND.AMBULANCE.LOGS.UPDATE_CONDITION_CATEGORY.DESCRIPTION", {
            oldName = oldCategory,
            newName = newCategory
        })
    )

    return true
end, nil, true)

registerAmbulanceCallback("deleteConditionCategory", function(source, identifier, categoryName)
    if not HasPermission(source, "Ambulance", "condition", "delete") then
        debugprint("No permissions to delete category")
        return false
    end

    local category = ambulanceConditions[categoryName]
    if not category then
        debugprint("Category does not exist")
        return false
    end

    if #category > 0 then
        debugprint("Category is not empty")
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_ambulance_conditions_categories WHERE title = ?",
        { categoryName }
    ) > 0

    if deleted then
        ambulanceConditions[categoryName] = nil

        TriggerClientEvent("tablet:ambulance:deleteConditionCategory", -1, categoryName)

        createAmbulanceLog(
            identifier,
            categoryName,
            "delete",
            "condition_category",
            L("BACKEND.AMBULANCE.LOGS.DELETE_CONDITION_CATEGORY.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.DELETE_CONDITION_CATEGORY.DESCRIPTION", {
                name = categoryName
            })
        )
    end

    return deleted
end, nil, true)

registerAmbulanceCallback("addCondition", function(source, identifier, categoryName, title, severity)
    if not HasPermission(source, "Ambulance", "condition", "create") then
        debugprint("No permissions to create condition")
        return false
    end

    if not Config.Ambulance.Severities[severity] then
        debugprint("Invalid severity", severity)
        return false
    end

    local categoryId = MySQL.scalar.await(
        "SELECT id FROM lbtablet_ambulance_conditions_categories WHERE title = ?",
        { categoryName }
    )

    if not categoryId or not ambulanceConditions[categoryName] then
        debugprint("Category does not exist")
        return false
    end

    local conditionId = MySQL.insert.await(
        "INSERT INTO lbtablet_ambulance_conditions (severity, category_id, title) VALUES (?, ?, ?)",
        { severity, categoryId, title }
    )

    if not conditionId then
        debugprint("Failed to insert condition")
        return false
    end

    local condition = {
        id = conditionId,
        severity = severity,
        category = categoryName,
        categoryId = categoryId,
        title = title
    }

    ambulanceConditions[categoryName][#ambulanceConditions[categoryName] + 1] = condition

    TriggerClientEvent("tablet:ambulance:addCondition", -1, condition)

    createAmbulanceLog(
        identifier,
        conditionId,
        "create",
        "condition",
        L("BACKEND.AMBULANCE.LOGS.CREATE_CONDITION.TITLE"),
        L("BACKEND.AMBULANCE.LOGS.CREATE_CONDITION.DESCRIPTION", {
            severity = severity,
            name = title,
            category = categoryName
        })
    )

    return conditionId
end)

registerAmbulanceCallback("updateCondition", function(source, identifier, conditionId, title, severity)
    if not HasPermission(source, "Ambulance", "condition", "edit") then
        debugprint("No permissions to edit condition")
        return false
    end

    if not Config.Ambulance.Severities[severity] then
        debugprint("Invalid severity", severity)
        return false
    end

    local condition = findConditionById(conditionId)
    if not condition then
        debugprint("updateCondition: invalid condition", conditionId)
        return false
    end

    condition.title = title
    condition.severity = severity

    local updated = MySQL.update.await([[
        UPDATE lbtablet_ambulance_conditions
        SET severity = ?, title = ?
        WHERE id = ?
    ]], {
        severity,
        title,
        conditionId
    }) > 0

    if not updated then
        debugprint("Failed to update condition")
        return false
    end

    TriggerClientEvent("tablet:ambulance:updateCondition", -1, condition)

    createAmbulanceLog(
        identifier,
        conditionId,
        "update",
        "condition",
        L("BACKEND.AMBULANCE.LOGS.UPDATE_CONDITION.TITLE"),
        L("BACKEND.AMBULANCE.LOGS.UPDATE_CONDITION.DESCRIPTION", {
            name = title,
            severity = severity,
            category = condition.category
        })
    )

    return true
end, nil, true)

registerAmbulanceCallback("deleteCondition", function(source, identifier, conditionId)
    if not HasPermission(source, "Ambulance", "condition", "delete") then
        debugprint("No permissions to delete condition")
        return false
    end

    local condition, conditionIndex = findConditionById(conditionId)
    if not condition then
        debugprint("Condition does not exist")
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_ambulance_conditions WHERE id = ?",
        { conditionId }
    ) > 0

    if deleted then
        local categoryConditions = ambulanceConditions[condition.category]
        table.remove(categoryConditions, conditionIndex)

        TriggerClientEvent("tablet:ambulance:deleteCondition", -1, conditionId)

        createAmbulanceLog(
            identifier,
            conditionId,
            "delete",
            "condition",
            L("BACKEND.AMBULANCE.LOGS.DELETE_CONDITION.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.DELETE_CONDITION.DESCRIPTION", {
                category = condition.category,
                name = condition.title
            })
        )
    end

    return deleted
end, nil, true)

registerAmbulanceCallback("getBulletinBoard", function(source, identifier, page, query)
    page = page or 0

    if type(query) ~= "string" or query == "" then
        query = nil
    end

    local params = {}

    if query then
        params[#params + 1] = "%" .. query .. "%"
    end

    params[#params + 1] = page * 25
    params[#params + 1] = 25

    local sql = [[
        SELECT
            b.id, b.title, b.content, b.pinned, b.created_at AS `timestamp`, b.created_by AS created,
            a.display_name AS author, a.avatar
        FROM lbtablet_ambulance_bulletin b
        LEFT JOIN lbtablet_ambulance_accounts a ON a.id = b.created_by
    ]]

    if query then
        sql = sql .. "WHERE b.title LIKE ?"
    end

    sql = sql .. [[
        ORDER BY pinned DESC, created_at DESC
        LIMIT ?, ?
    ]]

    local bulletins = MySQL.query.await(sql, params)

    for index = 1, #bulletins do
        local bulletin = bulletins[index]
        bulletin.created = bulletin.created == identifier
    end

    return bulletins
end)

registerAmbulanceCallback("toggleBulletinPinned", function(source, identifier, bulletinId, pinned)
    if not HasPermission(source, "Ambulance", "bulletin", "pin") then
        return false
    end

    local updated = MySQL.update.await(
        "UPDATE lbtablet_ambulance_bulletin SET pinned = ? WHERE id = ?",
        { pinned, bulletinId }
    ) > 0

    if updated and pinned then
        createAmbulanceLog(
            identifier,
            bulletinId,
            "update",
            "bulletin",
            L("BACKEND.AMBULANCE.LOGS.PIN_BULLETIN.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.PIN_BULLETIN.DESCRIPTION", { id = bulletinId })
        )
    elseif updated then
        createAmbulanceLog(
            identifier,
            bulletinId,
            "update",
            "bulletin",
            L("BACKEND.AMBULANCE.LOGS.UNPIN_BULLETIN.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.UNPIN_BULLETIN.DESCRIPTION", { id = bulletinId })
        )
    end

    return updated
end)

local function updateBulletin(source, identifier, bulletinId, title, content)
    local canEdit = HasPermission(source, "Ambulance", "bulletin", "edit")

    if not canEdit then
        local creator = MySQL.scalar.await(
            "SELECT created_by FROM lbtablet_ambulance_bulletin WHERE id = ?",
            { bulletinId }
        )

        if creator ~= identifier then
            debugprint("No permissions to edit bulletin")
            return false
        end
    end

    MySQL.update.await(
        "UPDATE lbtablet_ambulance_bulletin SET title = ?, content = ? WHERE id = ?",
        { title, content, bulletinId }
    )

    createAmbulanceLog(
        identifier,
        bulletinId,
        "update",
        "bulletin",
        L("BACKEND.AMBULANCE.LOGS.UPDATE_BULLETIN.TITLE"),
        L("BACKEND.AMBULANCE.LOGS.UPDATE_BULLETIN.DESCRIPTION", {
            title = title
        })
    )

    TriggerClientEvent("tablet:ambulance:bulletinUpdated", -1, {
        id = bulletinId,
        title = title,
        content = content
    })

    return true
end

local function createBulletin(source, identifier, title, content)
    if not HasPermission(source, "Ambulance", "bulletin", "create") then
        debugprint("No permissions to create bulletin")
        return false
    end

    local bulletinId = MySQL.insert.await(
        "INSERT INTO lbtablet_ambulance_bulletin (title, content, created_by) VALUES (?, ?, ?)",
        { title, content, identifier }
    )

    if not bulletinId then
        debugprint("Failed to create bulletin")
        return false
    end

    local firstname, lastname = GetCharacterName(source)
    local authorName = firstname .. " " .. lastname

    if Config.Ambulance.Notifications.NewBulletin then
        notifyAmbulanceTablets({
            title = L("BACKEND.AMBULANCE.NOTIFICATIONS.NEW_BULLETIN.TITLE"),
            content = L("BACKEND.AMBULANCE.NOTIFICATIONS.NEW_BULLETIN.CONTENT", {
                title = title,
                content = content
            })
        }, { identifier })
    end

    createAmbulanceLog(
        identifier,
        bulletinId,
        "create",
        "bulletin",
        L("BACKEND.AMBULANCE.LOGS.CREATE_BULLETIN.TITLE"),
        L("BACKEND.AMBULANCE.LOGS.CREATE_BULLETIN.DESCRIPTION", {
            title = title
        })
    )

    TriggerClientEvent("tablet:ambulance:bulletinCreated", -1, {
        id = bulletinId,
        title = title,
        content = content,
        timestamp = os.time() * 1000,
        createdBy = identifier,
        author = authorName,
        avatar = GetAmbulanceAvatar(identifier)
    })

    return bulletinId
end

registerAmbulanceCallback("saveBulletin", function(source, identifier, bulletinId, title, content)
    if bulletinId then
        if updateBulletin(source, identifier, bulletinId, title, content) then
            return bulletinId
        end

        return false
    end

    bulletinId = createBulletin(source, identifier, title, content)
    return bulletinId or false
end, nil, true)

registerAmbulanceCallback("deleteBulletin", function(source, identifier, bulletinId)
    local deleted = false

    if HasPermission(source, "Ambulance", "bulletin", "delete") then
        deleted = MySQL.update.await(
            "DELETE FROM lbtablet_ambulance_bulletin WHERE id = ?",
            { bulletinId }
        ) > 0
    else
        deleted = MySQL.update.await(
            "DELETE FROM lbtablet_ambulance_bulletin WHERE id = ? AND created_by = ?",
            { bulletinId, identifier }
        ) > 0
    end

    if deleted then
        TriggerClientEvent("tablet:ambulance:bulletinDeleted", -1, bulletinId)

        createAmbulanceLog(
            identifier,
            bulletinId,
            "delete",
            "bulletin",
            L("BACKEND.AMBULANCE.LOGS.DELETE_BULLETIN.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.DELETE_BULLETIN.DESCRIPTION", {
                id = bulletinId
            })
        )
    end

    return deleted
end)

registerAmbulanceCallback("getUnreadChats", function(source, identifier)
    return GetUndreadChatNotifications("ambulance", identifier)
end)

registerAmbulanceCallback("getPublicChatRooms", function(source, identifier, page, query)
    return GetPublicChatRooms("ambulance", identifier, page, query)
end)

registerAmbulanceCallback("getChatRooms", function(source, identifier, page, query)
    return GetChatRooms("ambulance", identifier, page, query)
end)

registerAmbulanceCallback("createChat", function(source, identifier, label, isPrivate)
    if not HasPermission(source, "Ambulance", "chat", "create") then
        return false
    end

    local roomId = CreateChatRoom("ambulance", identifier, label, isPrivate)

    if not isPrivate and Config.Ambulance.Notifications.NewChat then
        notifyAmbulanceTablets({
            title = L("BACKEND.AMBULANCE.NOTIFICATIONS.CHAT.NEW_CHANNEL.TITLE"),
            content = L("BACKEND.AMBULANCE.NOTIFICATIONS.CHAT.NEW_CHANNEL.CONTENT", {
                channel = label
            })
        }, { identifier })
    end

    return roomId
end, nil, true)

registerAmbulanceCallback("toggleChatPrivate", function(source, identifier, roomId, toggle)
    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= identifier and not HasPermission(source, "Ambulance", "chat", "edit") then
        return false
    end

    return ToggleChatRoomPrivate(roomId, toggle == true)
end)

registerAmbulanceCallback("setChatIcon", function(source, identifier, roomId, icon)
    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= identifier and not HasPermission(source, "Ambulance", "chat", "edit") then
        return false
    end

    return SetChatRoomIcon(roomId, icon)
end)

registerAmbulanceCallback("getChatMembers", function(source, identifier, roomId)
    return GetChatRoomMembers("ambulance", roomId)
end)

registerAmbulanceCallback("inviteToChat", function(source, identifier, roomId, targetIdentifier)
    if targetIdentifier == identifier then
        debugprint("Can't invite self to chat")
        return false
    end

    local isMember = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_chat_rooms_members WHERE room_id = ? AND account = ?",
        { roomId, identifier }
    )

    if not isMember then
        debugprint("User not in chat")
        return false
    end

    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= identifier and not HasPermission(source, "Ambulance", "chat", "invite") then
        return false
    end

    return AddToChatRoom("ambulance", roomId, targetIdentifier)
end)

registerAmbulanceCallback("kickFromChat", function(source, identifier, roomId, targetIdentifier)
    if targetIdentifier == identifier then
        debugprint("Can't kick self from chat")
        return false
    end

    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= identifier and not HasPermission(source, "Ambulance", "chat", "kick") then
        return false
    end

    return RemoveMemberFromChatRoom(roomId, targetIdentifier)
end)

registerAmbulanceCallback("joinChat", function(source, identifier, roomId)
    local isPrivate = MySQL.scalar.await(
        "SELECT private FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if isPrivate then
        return false
    end

    return MySQL.update.await(
        "INSERT INTO lbtablet_chat_rooms_members (room_id, account) VALUES (?, ?) ON DUPLICATE KEY UPDATE account = ?",
        { roomId, identifier, identifier }
    ) > 0
end)

registerAmbulanceCallback("leaveChat", function(source, identifier, roomId)
    return LeaveChatRoom(identifier, roomId)
end)

registerAmbulanceCallback("getChatMessages", function(source, identifier, roomId, lastId)
    return GetChatMessages("ambulance", roomId, lastId)
end)

registerAmbulanceCallback("sendMessage", function(source, identifier, roomId, content, attachments)
    local messageSent = SendChatMessage({
        id = identifier,
        name = (ambulanceAccounts[identifier] and ambulanceAccounts[identifier].name) or "",
        avatar = ambulanceAccounts[identifier] and ambulanceAccounts[identifier].avatar
    }, roomId, content, attachments)

    if not messageSent then
        return false
    end

    if Config.Ambulance.Notifications.ChatMessage then
        local room = MySQL.single.await(
            "SELECT label, private FROM lbtablet_chat_rooms WHERE id = ?",
            { roomId }
        )

        if room then
            local notification = {
                title = L("BACKEND.AMBULANCE.NOTIFICATIONS.CHAT.NEW_MESSAGE.TITLE", {
                    channel = room.label or ""
                }),
                content = L("BACKEND.AMBULANCE.NOTIFICATIONS.CHAT.NEW_MESSAGE.CONTENT", {
                    message = content or "attachment"
                }),
                app = "Ambulance"
            }

            if not room.private then
                notifyAmbulanceTablets(notification, { identifier })
            else
                local members = MySQL.query.await(
                    "SELECT account FROM lbtablet_chat_rooms_members WHERE room_id = ? AND account != ?",
                    { roomId, identifier }
                )

                local targetIdentifiers = {}

                for index = 1, #members do
                    targetIdentifiers[#targetIdentifiers + 1] = members[index].account
                end

                NotifyTablets(targetIdentifiers, notification, { identifier })
            end
        end
    end

    return messageSent
end, nil, true)

registerAmbulanceCallback("clearChatNotifications", function(source, identifier, roomId)
    return MySQL.update.await(
        "UPDATE lbtablet_chat_rooms_members SET notifications = 0 WHERE room_id = ? AND account = ?",
        { roomId, identifier }
    ) > 0
end)

registerAmbulanceCallback("getDispatches", function()
    return GetJobDispatches("ambulance")
end)

registerAmbulanceCallback("getActiveUnits", function()
    local activeUnits = {}
    local onDutyEmployees = GetOnDutyEmployees(Config.Ambulance.Permissions)

    for index = 1, #onDutyEmployees do
        local employee = onDutyEmployees[index]

        activeUnits[index] = {
            source = employee.source,
            name = employee.name,
            rank = employee.rank,
            callsign = GetAmbulanceCallsign(employee.identifier)
        }
    end

    return activeUnits
end)

registerAmbulanceCallback("getUnits", function()
    local units = {}
    local rawUnits = GetUnits("ambulance")

    for _, unit in pairs(rawUnits) do
        units[#units + 1] = unit
    end

    return units
end, {})

registerAmbulanceCallback("addUnit", function(source, identifier, unitName)
    if not HasPermission(source, "Ambulance", "unit", "create") then
        return false
    end

    return CreateUnit("ambulance", unitName, Config.Ambulance.DefaultUnitStatus)
end)

registerAmbulanceCallback("deleteUnit", function(source, identifier, unitName)
    if not HasPermission(source, "Ambulance", "unit", "delete") then
        return false
    end

    return RemoveUnit("ambulance", unitName)
end)

registerAmbulanceCallback("updateUnitStatus", function(source, identifier, unitName, status)
    if not HasPermission(source, "Ambulance", "unit", "edit") then
        return false
    end

    if not Config.Ambulance.UnitStatuses or not Config.Ambulance.UnitStatuses[status] then
        debugprint("Invalid unit status", status)
        return false
    end

    return SetUnitStatus("ambulance", unitName, status)
end)

registerAmbulanceCallback("renameUnit", function(source, identifier, oldName, newName)
    if not HasPermission(source, "Ambulance", "unit", "edit") then
        return false
    end

    return RenameUnit("ambulance", oldName, newName)
end)

registerAmbulanceCallback("assignOfficerToUnit", function(source, identifier, unitName, officerSource)
    if not HasPermission(source, "Ambulance", "unit", "edit") then
        return false
    end

    if not GetPlayerName(officerSource) then
        debugprint("Invalid officer source", officerSource)
        return false
    end

    return SetPlayerUnit(officerSource, "ambulance", unitName)
end)

registerAmbulanceCallback("removeOfficerFromUnit", function(source, identifier, officerSource)
    if not HasPermission(source, "Ambulance", "unit", "edit") then
        return false
    end

    if not GetPlayerName(officerSource) then
        debugprint("Invalid officer source", officerSource)
        return false
    end

    ResetPlayerUnit(officerSource)
    return true
end)

local function getEntityTags(tableName, columnName, value)
    local rows = MySQL.query.await(
        "SELECT tag_id FROM " .. tableName .. " WHERE " .. columnName .. " = ?",
        { value }
    )

    local tags = {}

    for index = 1, #rows do
        local tag = findTagById(rows[index].tag_id)
        if tag then
            tags[#tags + 1] = tag
        end
    end

    return tags
end

registerAmbulanceCallback("getTags", function()
    return ambulanceTags
end)

local function createAmbulanceTag(title, color, tagType)
    for index = 1, #ambulanceTags do
        local existingTag = ambulanceTags[index]

        if existingTag.title == title and existingTag.type == tagType then
            debugprint("Tag already exists")
            return
        end
    end

    local tagId = MySQL.insert.await(
        "INSERT INTO lbtablet_ambulance_tags (title, color, tag_type) VALUES (?, ?, ?)",
        { title, color, tagType }
    )

    if tagId then
        local tag = {
            id = tagId,
            title = title,
            color = color,
            type = tagType
        }

        ambulanceTags[#ambulanceTags + 1] = tag
        TriggerClientEvent("tablet:ambulance:createdTag", -1, tag)
    end

    return tagId
end

registerAmbulanceCallback("createTag", function(source, identifier, title, color, tagType)
    if not HasPermission(source, "Ambulance", "tag", "create") then
        debugprint("No permissions to create tag")
        return false
    end

    return createAmbulanceTag(title, color, tagType)
end, nil, true)

exports("CreateAmbulanceTag", createAmbulanceTag)

registerAmbulanceCallback("deleteTag", function(source, identifier, tagId)
    if not HasPermission(source, "Ambulance", "tag", "delete") then
        return false
    end

    local tag, tagIndex = findTagById(tagId)
    if not tag then
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_ambulance_tags WHERE id = ?",
        { tagId }
    ) > 0

    if not deleted then
        return false
    end

    createAmbulanceLog(
        identifier,
        tagId,
        "delete",
        "tag",
        L("BACKEND.AMBULANCE.LOGS.DELETE_TAG.TITLE"),
        L("BACKEND.AMBULANCE.LOGS.DELETE_TAG.DESCRIPTION", {
            type = L("BACKEND.AMBULANCE.TAG_TYPES." .. tag.type:upper()),
            name = tag.title
        })
    )

    table.remove(ambulanceTags, tagIndex)
    TriggerClientEvent("tablet:ambulance:deletedTag", -1, tagId)

    return true
end)

exports("DeleteAmbulanceTag", function(tagId)
    local tag, tagIndex = findTagById(tagId)
    if not tag then
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_ambulance_tags WHERE id = ?",
        { tagId }
    ) > 0

    if deleted then
        table.remove(ambulanceTags, tagIndex)
        TriggerClientEvent("tablet:ambulance:deletedTag", -1, tagId)
    end

    return deleted
end)

registerAmbulanceCallback("searchUsers", function(source, identifier, query, filters, page)
    local searchFilters = {}

    if filters and filters.doctorOnly then
        searchFilters.jobs = ambulanceJobs
    end

    local users = SearchUsers(query or "", searchFilters, "lbtablet_ambulance_profiles", page)

    for index = 1, #users do
        local user = users[index]
        user.tags = getEntityTags("lbtablet_ambulance_profile_tags", "id", user.id)
    end

    return users
end, {})

registerAmbulanceCallback("fetchProfile", function(source, identifier, profileId)
    local query = Queries.Users.FetchProfile
        :gsub("{PROFILE_JOIN}", "lbtablet_ambulance_profiles")
        :gsub("{USERS_COLLATE}", UsersCollate)

    local profile = MySQL.single.await(query, { profileId })
    if not profile then
        return false
    end

    if Config.LBPhone then
        local profileSource = GetSourceFromIdentifier(profileId)

        if profileSource then
            profile.phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(profileSource)
        end

        if not profile.phoneNumber then
            profile.phoneNumber = GetPhoneNumberFromIdentifier(profileId)
        end
    end

    profile.tags = getEntityTags("lbtablet_ambulance_profile_tags", "id", profileId)

    profile.reports = MySQL.query.await(
        "SELECT id, title FROM lbtablet_ambulance_reports WHERE patient = ?",
        { profileId }
    )

    profile.diagnoses = MySQL.query.await([[
        SELECT
            c.id,
            c.title,
            c.severity
        FROM lbtablet_ambulance_profile_conditions pc
        LEFT JOIN lbtablet_ambulance_conditions c ON c.id = pc.condition_id
        WHERE pc.profile_id = ?
    ]], {
        profileId
    })

    return profile
end)

registerAmbulanceCallback("updateProfile", function(source, identifier, profileData)
    if not HasPermission(source, "Ambulance", "profile", "edit") then
        debugprint("No permissions to edit profile")
        return false
    end

    local saved = MySQL.update.await([[
        INSERT INTO lbtablet_ambulance_profiles (id, avatar, notes)
        VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE avatar = VALUES(avatar), notes = VALUES(notes)
    ]], {
        profileData.id,
        profileData.avatar,
        profileData.notes or ""
    }) > 0

    if saved then
        local profileId = profileData.id
        local diagnoses = profileData.diagnoses or {}

        MySQL.rawExecute.await(
            "DELETE FROM lbtablet_ambulance_profile_conditions WHERE profile_id = ?",
            { profileId }
        )

        if #diagnoses > 0 then
            local diagnosisRows = {}

            for index = 1, #diagnoses do
                diagnosisRows[#diagnosisRows + 1] = {
                    profileId,
                    diagnoses[index]
                }
            end

            debugprint("Inserting diagnoses", diagnosisRows)

            MySQL.rawExecute.await(
                "INSERT INTO lbtablet_ambulance_profile_conditions (profile_id, condition_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE condition_id = VALUES(condition_id)",
                diagnosisRows
            )
        end

        createAmbulanceLog(
            identifier,
            profileData.id,
            "update",
            "profile",
            L("BACKEND.AMBULANCE.LOGS.UPDATE_PROFILE.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.UPDATE_PROFILE.DESCRIPTION", {
                name = GetCharacterNameFromIdentifier(profileData.id) or "??"
            })
        )

        TriggerClientEvent("tablet:ambulance:profileUpdated", -1, profileData)
    end

    return saved
end, nil, true)

local function addTagToProfile(profileId, tagId)
    local tag = findTagById(tagId)

    if not tag or tag.type ~= "profile" then
        debugprint("Invalid tag or tag type", tag)
        return false
    end

    local added = MySQL.update.await(
        "INSERT INTO lbtablet_ambulance_profile_tags (id, tag_id) VALUES (?, ?)",
        { profileId, tagId }
    ) > 0

    if added then
        TriggerClientEvent("tablet:ambulance:addedTag", -1, profileId, tag.type, tagId)
    end

    return added
end

registerAmbulanceCallback("addTag", function(source, identifier, profileId, tagId)
    if not HasPermission(source, "Ambulance", "profile", "edit") then
        debugprint("No permissions to add tag to profile")
        return false
    end

    local tag = findTagById(tagId)

    if not tag or tag.type ~= "profile" then
        debugprint("Invalid tag or tag type", tag)
        return false
    end

    return addTagToProfile(profileId, tagId)
end, nil, true)

exports("AddTagToAmbulanceProfile", addTagToProfile)

local function removeTagFromProfile(profileId, tagId)
    local removed = MySQL.update.await(
        "DELETE FROM lbtablet_ambulance_profile_tags WHERE id = ? AND tag_id = ?",
        { profileId, tagId }
    ) > 0

    if removed then
        TriggerClientEvent("tablet:ambulance:removedTag", -1, profileId, tagId)
    end

    return removed
end

registerAmbulanceCallback("removeTag", function(source, identifier, profileId, tagId)
    if not HasPermission(source, "Ambulance", "profile", "edit") then
        debugprint("No permissions to remove tag from profile")
        return false
    end

    local tag = findTagById(tagId)

    if not tag or tag.type ~= "profile" then
        debugprint("Invalid tag or tag type", tag)
        return false
    end

    return removeTagFromProfile(profileId, tagId)
end)

exports("RemoveTagFromAmbulanceProfile", removeTagFromProfile)

registerAmbulanceCallback("billPlayer", function(source, identifier, targetIdentifier, amount, label)
    if not BillPlayer then
        infoprint("warning", "The BillPlayer function is not defined. Please set it up to work with your billing script.")
        return false
    end

    if not targetIdentifier or amount < 0 or not label then
        debugprint("Invalid bill data", targetIdentifier, amount, label)
        return false
    end

    if targetIdentifier == identifier then
        if Config.Debug then
            infoprint("warning", "Normally you cannot bill yourself, but this is allowed in debug mode.")
        else
            SendNotification({
                source = source,
                app = "Police",
                title = L("BACKEND.POLICE.CANT_FINE_YOURSELF_NOTIFICATION.TITLE"),
                content = L("BACKEND.POLICE.CANT_FINE_YOURSELF_NOTIFICATION.CONTENT")
            })

            return false
        end
    end

    local billed = BillPlayer(identifier, targetIdentifier, "ambulance", amount, label)

    if not billed then
        debugprint("Failed to bill player", targetIdentifier, amount, label)
        return false
    end

    return true
end, {
    permissions = {
        { "profile", "bill" }
    }
})

registerAmbulanceCallback("getReports", function(source, identifier, page, query)
    page = page or 0

    if type(query) ~= "string" or query == "" then
        query = nil
    end

    local params = {}
    local whereClause = ""

    if query then
        params[#params + 1] = "%" .. query .. "%"
        whereClause = " WHERE r.title LIKE ?"

        if query:match("^%d+$") ~= nil then
            whereClause = whereClause .. " OR r.id = ?"
            params[#params + 1] = tonumber(query)
        end
    end

    params[#params + 1] = page * 10
    params[#params + 1] = 10

    local sql = ([[
        SELECT
            r.id,
            r.title,
            r.report_type,
            r.`description`,
            r.created_at AS created,
            r.updated_at AS lastUpdated,
            r.created_by AS createdBy,
            a.display_name AS author,
            a.avatar
        FROM lbtablet_ambulance_reports r
        LEFT JOIN lbtablet_ambulance_accounts a ON a.id = r.created_by
        %s
        ORDER BY r.updated_at DESC
        LIMIT ?, ?
    ]]):format(whereClause)

    local reports = MySQL.query.await(sql, params)

    for index = 1, #reports do
        local report = reports[index]
        report.tags = getEntityTags("lbtablet_ambulance_reports_tags", "report_id", report.id)
    end

    return reports
end)

local function getReport(reportId)
    local query = [[
        SELECT
            r.id,
            r.title,
            r.report_type AS `type`,
            r.`description`,
            r.created_at AS created,
            r.updated_at AS lastUpdated,
            r.created_by AS createdBy,
            a.display_name AS author,
            a.avatar,
            r.patient,
            {SELECT_NAME} AS patient_name,
            {SELECT_DOB} AS patient_dob,
            p.avatar AS patient_avatar
        FROM lbtablet_ambulance_reports r
        LEFT JOIN lbtablet_ambulance_accounts a ON a.id = r.created_by
        LEFT JOIN lbtablet_ambulance_profiles p ON p.id = r.patient
        {JOIN_NAME}
        WHERE r.id = ?
    ]]

    query = query
        :gsub("{SELECT_NAME}", Queries.Users.Select.name)
        :gsub("{SELECT_DOB}", Queries.Users.Select.dob)
        :gsub("{JOIN_NAME}", FormatString(
            "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = r.patient",
            {
                USERS_TABLE = Queries.Users.Table,
                IDENTIFIER = Queries.Users.Select.identifier,
                USERS_COLLATE = UsersCollate
            }
        ))

    local report = MySQL.single.await(query, { reportId })
    if not report then
        return false
    end

    report.gallery = MySQL.query.await(
        "SELECT attachment FROM lbtablet_ambulance_reports_attachments WHERE report_id = ?",
        { reportId }
    )

    report.tags = getEntityTags("lbtablet_ambulance_reports_tags", "report_id", reportId)

    report.injuries = MySQL.query.await([[
        SELECT
            c.id,
            c.title,
            c.severity
        FROM lbtablet_ambulance_reports_conditions rc
        LEFT JOIN lbtablet_ambulance_conditions c ON c.id = rc.condition_id
        WHERE rc.report_id = ?
    ]], {
        reportId
    })

    local doctorsQuery = [[
        SELECT
            d.doctor AS id,
            {SELECT_NAME} AS `name`
        FROM lbtablet_ambulance_reports_doctors d
        {JOIN_NAME}
        WHERE d.report_id = ?
    ]]

    doctorsQuery = doctorsQuery
        :gsub("{SELECT_NAME}", Queries.Users.Select.name)
        :gsub("{JOIN_NAME}", FormatString(
            "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = d.doctor",
            {
                USERS_TABLE = Queries.Users.Table,
                IDENTIFIER = Queries.Users.Select.identifier,
                USERS_COLLATE = UsersCollate
            }
        ))

    report.doctorsInvolved = MySQL.query.await(doctorsQuery, { reportId })

    return report
end

registerAmbulanceCallback("getReport", function(source, identifier, reportId)
    return getReport(reportId)
end)

local function saveReport(source, identifier, reportData)
    local isValid =
        type(reportData and reportData.title) == "string" and #reportData.title >= 3 and
        type(reportData and reportData.description) == "string" and #reportData.description >= 3 and
        type(reportData and reportData.type) == "string" and
        type(reportData and reportData.patient) == "string"

    if not isValid then
        debugprint("saveReport: Invalid data", reportData)
        return false
    end

    local reportId = reportData.id
    local title = reportData.title
    local description = reportData.description
    local reportType = reportData.type
    local patientId = reportData.patient
    local gallery = reportData.gallery or {}
    local doctors = reportData.doctors or {}
    local tags = reportData.tags or {}
    local injuries = reportData.injuries or {}

    if not reportId then
        if not HasPermission(source, "Ambulance", "report", "create") then
            debugprint("No permissions to create report")
            return false
        end

        reportId = MySQL.insert.await(
            "INSERT INTO lbtablet_ambulance_reports (created_by, patient, title, `description`, report_type) VALUES (?, ?, ?, ?, ?)",
            { identifier, patientId, title, description, reportType }
        )

        createAmbulanceLog(
            identifier,
            reportId,
            "create",
            "report",
            L("BACKEND.AMBULANCE.LOGS.CREATE_REPORT.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.CREATE_REPORT.DESCRIPTION", {
                title = title,
                type = reportData.type,
                patient = GetCharacterNameFromIdentifier(patientId) or "??",
                patientId = patientId,
                id = reportId
            })
        )

        if Config.Ambulance.Notifications.NewReport then
            notifyAmbulanceTablets({
                title = L("BACKEND.AMBULANCE.NOTIFICATIONS.NEW_REPORT.TITLE"),
                content = L("BACKEND.AMBULANCE.NOTIFICATIONS.NEW_REPORT.CONTENT", {
                    title = title,
                    description = description
                })
            }, { identifier })
        end
    else
        if not HasPermission(source, "Ambulance", "report", "edit") then
            debugprint("No permissions to edit report")
            return false
        end

        MySQL.rawExecute.await(
            "UPDATE lbtablet_ambulance_reports SET title = ?, `description` = ?, report_type = ?, patient = ? WHERE id = ?",
            { title, description, reportType, patientId, reportId }
        )

        MySQL.rawExecute.await(
            "DELETE FROM lbtablet_ambulance_reports_conditions WHERE report_id = ?",
            { reportId }
        )

        MySQL.rawExecute.await(
            "DELETE FROM lbtablet_ambulance_reports_attachments WHERE report_id = ?",
            { reportId }
        )

        MySQL.rawExecute.await(
            "DELETE FROM lbtablet_ambulance_reports_tags WHERE report_id = ?",
            { reportId }
        )

        MySQL.rawExecute.await(
            "DELETE FROM lbtablet_ambulance_reports_doctors WHERE report_id = ?",
            { reportId }
        )

        TriggerClientEvent("tablet:ambulance:reportUpdated", -1, reportData)

        createAmbulanceLog(
            identifier,
            reportId,
            "update",
            "report",
            L("BACKEND.AMBULANCE.LOGS.UPDATE_REPORT.TITLE"),
            L("BACKEND.AMBULANCE.LOGS.UPDATE_REPORT.DESCRIPTION", {
                title = title,
                type = reportData.type,
                id = reportId
            })
        )
    end

    if not reportId then
        return false
    end

    if #gallery > 0 then
        local attachmentRows = {}

        for index = 1, #gallery do
            attachmentRows[#attachmentRows + 1] = {
                reportId,
                gallery[index]
            }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_ambulance_reports_attachments (report_id, attachment) VALUES (?, ?)",
            attachmentRows
        )
    end

    if #doctors > 0 then
        local doctorRows = {}

        for index = 1, #doctors do
            doctorRows[#doctorRows + 1] = {
                reportId,
                doctors[index]
            }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_ambulance_reports_doctors (report_id, doctor) VALUES (?, ?)",
            doctorRows
        )
    end

    if #tags > 0 then
        local tagRows = {}

        for index = 1, #tags do
            tagRows[#tagRows + 1] = {
                reportId,
                tags[index]
            }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_ambulance_reports_tags (report_id, tag_id) VALUES (?, ?)",
            tagRows
        )
    end

    if #injuries > 0 then
        local injuryRows = {}

        for index = 1, #injuries do
            injuryRows[#injuryRows + 1] = {
                reportId,
                injuries[index]
            }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_ambulance_reports_conditions (report_id, condition_id) VALUES (?, ?)",
            injuryRows
        )
    end

    return reportId
end

registerAmbulanceCallback("saveReport", function(source, identifier, reportData)
    return saveReport(source, identifier, reportData)
end, nil, true)

registerAmbulanceCallback("deleteReport", function(source, identifier, reportId)
    if not HasPermission(source, "Ambulance", "report", "delete") then
        debugprint("No permissions to delete report")
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_ambulance_reports WHERE id = ?",
        { reportId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:ambulance:reportDeleted", -1, reportId)
    end

    return deleted
end)

exports("CreateAmbulanceReport", function(source, reportData)
    local tabletId = GetEquippedTablet(source)

    if not tabletId then
        debugprint("CreateAmbulanceReport: No tablet found")
        return false, "no_tablet"
    end

    reportData.id = nil
    return saveReport(source, tabletId, reportData)
end)

exports("GetAmbulanceReport", getReport)

exports("UpdateAmbulanceReport", function(source, reportData)
    local tabletId = GetEquippedTablet(source)

    if not tabletId then
        debugprint("UpdateAmbulanceReport: No tablet found")
        return false, "no_tablet"
    end

    if not reportData or not reportData.id then
        debugprint("UpdateAmbulanceReport: No ID provided")
        return false, "no_id"
    end

    return saveReport(source, tabletId, reportData)
end)

exports("DeleteAmbulanceReport", function(reportId)
    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_ambulance_reports WHERE id = ?",
        { reportId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:ambulance:reportDeleted", -1, reportId)
    end

    return deleted
end)

AddEventHandler("lb-tablet:jobUpdated", function(source, newJob)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        return
    end

    if Config.Ambulance.Permissions[newJob] then
        getLoggedInAccount(source, tabletId)
    else
        ambulanceAccounts[tabletId] = nil
    end
end)

OnTabletDisconnect(function(tabletId, source)
    if ambulanceAccounts[tabletId] then
        ambulanceAccounts[tabletId] = nil
        debugprint("Removed ambulance user from cache", tabletId, source)
    end
end)