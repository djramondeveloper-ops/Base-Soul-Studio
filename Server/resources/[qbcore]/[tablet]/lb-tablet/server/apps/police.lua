local policeTags = {}
local policeAccounts = {}
local policeJobGrades = {}
local policeJobs = {}
local offencesByCategory = {}

for jobName in pairs(Config.Police.Permissions) do
    policeJobs[#policeJobs + 1] = jobName
end

local function getOffenceById(offenceId)
    for _, offences in pairs(offencesByCategory) do
        for index = 1, #offences do
            local offence = offences[index]
            if offence.id == offenceId then
                return offence, index
            end
        end
    end
end

MySQL.ready(function()
    while not DatabaseCheckerFinished do
        Wait(500)
    end

    policeTags = MySQL.query.await("SELECT * FROM lbtablet_police_tags") or {}
    policeJobGrades = GetJobGrades(policeJobs)

    local offences = MySQL.query.await([[ 
        SELECT
            o.id,
            o.category_id AS categoryId,
            o.class,
            o.title,
            o.`description`,
            o.fine,
            o.jail_time AS jailTime,
            oc.title AS category
        FROM lbtablet_police_offences_categories oc
        LEFT JOIN lbtablet_police_offences o ON o.category_id = oc.id
        ORDER BY o.category_id ASC, o.class DESC, o.id ASC
    ]]) or {}

    for i = 1, #offences do
        local offence = offences[i]

        if not offencesByCategory[offence.category] then
            offencesByCategory[offence.category] = {}
        end

        if offence.id then
            offencesByCategory[offence.category][#offencesByCategory[offence.category] + 1] = offence
        end
    end
end)

local function getTagById(tagId)
    for index = 1, #policeTags do
        local tag = policeTags[index]
        if tag.id == tagId then
            return tag, index
        end
    end
end

function GetPoliceCallsign(identifier, skipDatabase)
    local cachedAccount = policeAccounts[identifier]
    if cachedAccount then
        return cachedAccount.callsign
    end

    if skipDatabase then
        return
    end

    return MySQL.scalar.await(
        "SELECT callsign FROM lbtablet_police_accounts WHERE id = ?",
        { identifier }
    )
end

function GetPoliceAvatar(identifier)
    local cachedAccount = policeAccounts[identifier]
    if cachedAccount then
        return cachedAccount.avatar
    end
end

exports("GetPoliceCallsign", GetPoliceCallsign)
exports("GetPoliceAvatar", GetPoliceAvatar)

local officerCacheUpdatedAt = 0
local cachedOfficerIdentifiers = {}

local function notifyPoliceTablets(payload, ignoreIdentifiers)
    if officerCacheUpdatedAt < os.time() + 60 then
        cachedOfficerIdentifiers = GetIdentifiersWithJob(policeJobs)
        officerCacheUpdatedAt = os.time()
        debugprint("Fetched officers", #cachedOfficerIdentifiers)
    end

    payload.app = "Police"
    NotifyTablets(cachedOfficerIdentifiers, payload, ignoreIdentifiers)
end

local function addPoliceLog(createdBy, relatedId, action, logType, title, content)
    MySQL.insert(
        "INSERT INTO lbtablet_police_logs (created_by, related_id, log_type, log_action, title, content) VALUES (?, ?, ?, ?, ?, ?)",
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
    if not source then
        return
    end

    local severity = (action == "create" or action == "update") and "info" or "warning"

    Log(source, "Police", severity, title, {
        relatedId = relatedId,
        logType = logType,
        action = action,
        content = content
    })
end

local function registerPoliceCallback(callbackName, handler, options)
    options = options or {}

    local antiSpam = options.antiSpam and true or false

    if options.permissions then
        for jobName, permissions in pairs(Config.Police.Permissions) do
            for i = 1, #options.permissions do
                local permission = options.permissions[i]
                local category = permission[1]
                local action = permission[2]

                if not permissions[category] or not permissions[category][action] then
                    infoprint(
                        "error",
                        "Permission ^5" .. category .. "." .. action .. "^7 does not exist for ^5" .. jobName .. "^7. Used in police callback ^5" .. callbackName,
                        "^7"
                    )
                end
            end
        end
    end

    BaseCallback("police:" .. callbackName, function(source, identifier, ...)
        local job = GetJob(source)
        if not job or not Config.Police.Permissions[job.name] then
            debugprint("No permissions to access police app. Identifier:", identifier, "Job:", job)
            return false
        end

        if options.permissions then
            for i = 1, #options.permissions do
                local permission = options.permissions[i]
                local category = permission[1]
                local action = permission[2]

                if not HasPermission(source, "Police", category, action) then
                    debugprint(
                        "No permission to access police callback:",
                        callbackName,
                        "Identifier:",
                        identifier,
                        "Permission:",
                        category .. ".",
                        action,
                        "Job:",
                        job
                    )
                    return false
                end
            end
        end

        return handler(source, identifier, ...)
    end, options.defaultReturn, antiSpam)
end

registerPoliceCallback("getEmployees", function(_, _)
    local employees = GetEmployees(policeJobs, "lbtablet_police_accounts")

    for i = 1, #employees do
        local employee = employees[i]
        local source = GetSourceFromIdentifier(employee.id)

        if source then
            employee.onDuty = IsOnDuty(source)
        end
    end

    return {
        employees = employees,
        ranks = policeJobGrades.grades,
        labels = policeJobGrades.labels
    }
end)

registerPoliceCallback("getActiveUnits", function(_, _)
    local activeUnits = {}
    local onDutyEmployees = GetOnDutyEmployees(Config.Police.Permissions)

    for i = 1, #onDutyEmployees do
        local employee = onDutyEmployees[i]
        activeUnits[i] = {
            source = employee.source,
            name = employee.name,
            rank = employee.rank,
            callsign = GetPoliceCallsign(employee.identifier),
            unit = GetPlayerUnit(employee.source)
        }
    end

    return activeUnits
end)

registerPoliceCallback("getUnits", function(_, _)
    local units = {}
    local rawUnits = GetUnits("police")

    for _, unit in pairs(rawUnits) do
        units[#units + 1] = unit
    end

    return units
end, {
    defaultReturn = {}
})

registerPoliceCallback("addUnit", function(_, _, unitName)
    return CreateUnit("police", unitName, Config.Police.DefaultUnitStatus)
end, {
    permissions = {
        { "unit", "create" }
    }
})

registerPoliceCallback("deleteUnit", function(_, _, unitId)
    return RemoveUnit("police", unitId)
end, {
    permissions = {
        { "unit", "delete" }
    }
})

registerPoliceCallback("updateUnitStatus", function(_, _, unitId, status)
    if Config.Police.UnitStatuses and not Config.Police.UnitStatuses[status] then
        debugprint("Invalid unit status", status)
        return false
    end

    return SetUnitStatus("police", unitId, status)
end, {
    permissions = {
        { "unit", "edit" }
    }
})

registerPoliceCallback("renameUnit", function(_, _, unitId, newName)
    return RenameUnit("police", unitId, newName)
end, {
    permissions = {
        { "unit", "edit" }
    }
})

registerPoliceCallback("assignOfficerToUnit", function(_, _, unitId, officerSource)
    if not GetPlayerName(officerSource) then
        debugprint("Invalid officer source", officerSource)
        return false
    end

    return SetPlayerUnit(officerSource, "police", unitId)
end, {
    permissions = {
        { "unit", "edit" }
    }
})

registerPoliceCallback("removeOfficerFromUnit", function(_, _, officerSource)
    if not GetPlayerName(officerSource) then
        debugprint("Invalid officer source", officerSource)
        return false
    end

    ResetPlayerUnit(officerSource)
    return true
end, {
    permissions = {
        { "unit", "edit" }
    }
})

registerPoliceCallback("getLogs", function(_, _, search, lastLogId)
    local query = [[
        SELECT
            l.log_id,
            l.related_id,
            l.created_by,
            l.log_type,
            l.log_action,
            l.title,
            l.content,
            l.created_at,
            a.display_name,
            a.avatar
        FROM lbtablet_police_logs l
        LEFT JOIN lbtablet_police_accounts a ON a.id = l.created_by
        %s
        ORDER BY l.log_id DESC
        LIMIT 10
    ]]

    local params = {}

    if lastLogId then
        params[#params + 1] = lastLogId
    end

    if search then
        params[#params + 1] = "%" .. search .. "%"
        params[#params + 1] = "%" .. search .. "%"
    end

    if lastLogId and search then
        query = query:format("WHERE l.log_id < ? AND (l.title LIKE ? OR l.content LIKE ?)")
    elseif lastLogId then
        query = query:format("WHERE l.log_id < ?")
    elseif search then
        query = query:format("WHERE l.title LIKE ? OR l.content LIKE ?")
    else
        query = query:format("")
    end

    local rows = MySQL.query.await(query, params) or {}

    for i = 1, #rows do
        local row = rows[i]

        if string.match(row.related_id, "^%d+$") then
            local numericRelatedId = tonumber(row.related_id)
            if numericRelatedId then
                row.related_id = numericRelatedId
            end
        end

        rows[i] = {
            username = row.display_name or "??",
            avatar = row.avatar,
            identifier = row.created_by,
            id = row.log_id,
            relatedId = row.related_id,
            type = row.log_type,
            action = row.log_action,
            title = row.title,
            description = row.content,
            timestamp = row.created_at
        }
    end

    return rows
end, {
    defaultReturn = {},
    permissions = {
        { "logs", "view" }
    }
})

registerPoliceCallback("getOffences", function()
    return offencesByCategory
end)

registerPoliceCallback("addOffenceCategory", function(_, tabletId, categoryName)
    local exists = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_police_offences_categories WHERE title = ?",
        { categoryName }
    )

    if exists then
        debugprint("Category already exists")
        return false
    end

    local categoryId = MySQL.insert.await(
        "INSERT INTO lbtablet_police_offences_categories (title) VALUES (?)",
        { categoryName }
    )

    if not categoryId then
        debugprint("Failed to create category")
        return false
    end

    offencesByCategory[categoryName] = {}
    TriggerClientEvent("tablet:police:addOffenceCategory", -1, categoryName)

    addPoliceLog(
        tabletId,
        categoryId,
        "create",
        "offence_category",
        L("BACKEND.POLICE.LOGS.CREATE_OFFENCE_CATEGORY.TITLE"),
        L("BACKEND.POLICE.LOGS.CREATE_OFFENCE_CATEGORY.DESCRIPTION", {
            name = categoryName
        })
    )

    return true
end, {
    antiSpam = true,
    permissions = {
        { "offence", "create" }
    }
})

registerPoliceCallback("updateOffenceCategory", function(_, tabletId, oldCategoryName, newCategoryName)
    if not offencesByCategory[oldCategoryName] then
        debugprint("Old category doesn't exist")
        return false
    end

    local updated = MySQL.update.await(
        "UPDATE lbtablet_police_offences_categories SET title = ? WHERE title = ?",
        { newCategoryName, oldCategoryName }
    ) > 0

    if not updated then
        debugprint("Failed to change offence category title")
        return false
    end

    if newCategoryName ~= oldCategoryName then
        offencesByCategory[newCategoryName] = offencesByCategory[oldCategoryName]
        offencesByCategory[oldCategoryName] = nil
    end

    TriggerClientEvent("tablet:police:updateOffenceCategory", -1, oldCategoryName, newCategoryName)

    addPoliceLog(
        tabletId,
        oldCategoryName,
        "update",
        "offence_category",
        L("BACKEND.POLICE.LOGS.UPDATE_OFFENCE_CATEGORY.TITLE"),
        L("BACKEND.POLICE.LOGS.UPDATE_OFFENCE_CATEGORY.DESCRIPTION", {
            oldName = oldCategoryName,
            newName = newCategoryName
        })
    )

    return true
end, {
    antiSpam = true,
    permissions = {
        { "offence", "edit" }
    }
})

registerPoliceCallback("deleteOffenceCategory", function(_, tabletId, categoryName)
    local offences = offencesByCategory[categoryName]
    if not offences then
        debugprint("Category does not exist")
        return false
    end

    if #offences > 0 then
        debugprint("Category is not empty")
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_offences_categories WHERE title = ?",
        { categoryName }
    ) > 0

    if deleted then
        offencesByCategory[categoryName] = nil
        TriggerClientEvent("tablet:police:deleteOffenceCategory", -1, categoryName)

        addPoliceLog(
            tabletId,
            categoryName,
            "delete",
            "offence_category",
            L("BACKEND.POLICE.LOGS.DELETE_OFFENCE_CATEGORY.TITLE"),
            L("BACKEND.POLICE.LOGS.DELETE_OFFENCE_CATEGORY.DESCRIPTION", {
                name = categoryName
            })
        )
    end

    return deleted
end, {
    permissions = {
        { "offence", "delete" }
    }
})

registerPoliceCallback("addOffence", function(_, tabletId, categoryName, data)
    local offenceClass = data.class
    local title = data.title
    local description = data.description or ""
    local fine = data.fine
    local jailTime = data.jailTime

    if not categoryName or not offenceClass or not title then
        debugprint("Missing required fields", data)
        return false
    end

    if not Config.Police.OffenceClasses[offenceClass] then
        debugprint("Invalid class", offenceClass)
        return false
    end

    local categoryId = MySQL.scalar.await(
        "SELECT id FROM lbtablet_police_offences_categories WHERE title = ?",
        { categoryName }
    )

    if not categoryId or not offencesByCategory[categoryName] then
        debugprint("Category does not exist")
        return false
    end

    local offenceId = MySQL.insert.await(
        "INSERT INTO lbtablet_police_offences (category_id, class, title, `description`, fine, jail_time) VALUES (?, ?, ?, ?, ?, ?)",
        {
            categoryId,
            offenceClass,
            title,
            description,
            fine or 0,
            jailTime or 0
        }
    )

    if not offenceId then
        debugprint("Failed to insert offence")
        return false
    end

    local offence = {
        id = offenceId,
        categoryId = categoryId,
        class = offenceClass,
        title = title,
        description = description,
        fine = fine,
        jailTime = jailTime,
        category = categoryName
    }

    offencesByCategory[categoryName][#offencesByCategory[categoryName] + 1] = offence
    TriggerClientEvent("tablet:police:addOffence", -1, offence)

    addPoliceLog(
        tabletId,
        offenceId,
        "create",
        "offence",
        L("BACKEND.POLICE.LOGS.CREATE_OFFENCE.TITLE"),
        L("BACKEND.POLICE.LOGS.CREATE_OFFENCE.DESCRIPTION", {
            class = offenceClass,
            name = title,
            category = categoryName
        })
    )

    return offenceId
end, {
    antiSpam = true,
    permissions = {
        { "offence", "create" }
    }
})

registerPoliceCallback("updateOffence", function(_, tabletId, offenceId, data)
    local offenceClass = data.class
    local title = data.title
    local description = data.description or ""
    local fine = data.fine or 0
    local jailTime = data.jailTime or 0

    if not offenceId or not offenceClass or not title then
        debugprint("updateOffence: Missing required fields", offenceId, data)
        return false
    end

    local offence = getOffenceById(offenceId)
    if not offence then
        debugprint("updateOffence: invalid offence", offenceId)
        return false
    end

    offence.class = offenceClass
    offence.title = title
    offence.description = description
    offence.fine = fine
    offence.jailTime = jailTime

    local updated = MySQL.update.await([[ 
        UPDATE lbtablet_police_offences
        SET class = ?, title = ?, `description` = ?, fine = ?, jail_time = ?
        WHERE id = ?
    ]], {
        offenceClass,
        title,
        description,
        fine,
        jailTime,
        offenceId
    }) > 0

    if not updated then
        debugprint("Failed to update offence")
        return false
    end

    TriggerClientEvent("tablet:police:updateOffence", -1, offence)

    addPoliceLog(
        tabletId,
        offenceId,
        "update",
        "offence",
        L("BACKEND.POLICE.LOGS.UPDATE_OFFENCE.TITLE"),
        L("BACKEND.POLICE.LOGS.UPDATE_OFFENCE.DESCRIPTION", {
            name = title,
            category = offence.category
        })
    )

    return true
end, {
    antiSpam = true,
    permissions = {
        { "offence", "edit" }
    }
})

registerPoliceCallback("deleteOffence", function(_, tabletId, offenceId)
    local offence, offenceIndex = getOffenceById(offenceId)
    if not offence then
        debugprint("Offence does not exist")
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_offences WHERE id = ?",
        { offenceId }
    ) > 0

    if deleted then
        local categoryOffences = offencesByCategory[offence.category]
        table.remove(categoryOffences, offenceIndex)

        TriggerClientEvent("tablet:police:deleteOffence", -1, offenceId)

        addPoliceLog(
            tabletId,
            offenceId,
            "delete",
            "offence",
            L("BACKEND.POLICE.LOGS.DELETE_OFFENCE.TITLE"),
            L("BACKEND.POLICE.LOGS.DELETE_OFFENCE.DESCRIPTION", {
                category = offence.category,
                name = offence.title
            })
        )
    end

    return deleted
end, {
    permissions = {
        { "offence", "delete" }
    }
})
-- ============================================
-- Part 2 - Tags / Profiles / Licenses / Properties / Weapons / Bulletins
-- Append this file after police_clean_part1.lua
-- ============================================

local function getEntityTags(tableName, columnName, entityId)
    local rows = MySQL.query.await(
        ("SELECT tag_id FROM %s WHERE %s = ?"):format(tableName, columnName),
        { entityId }
    ) or {}

    local tags = {}

    for i = 1, #rows do
        local tag = getTagById(rows[i].tag_id)
        if tag then
            tags[#tags + 1] = tag
        end
    end

    return tags
end

registerPoliceCallback("getTags", function()
    return policeTags
end)

local function createPoliceTag(title, color, tagType)
    for i = 1, #policeTags do
        local tag = policeTags[i]

        if tag.title == title and tag.type == tagType then
            debugprint("Tag already exists")
            return
        end
    end

    local tagId = MySQL.insert.await(
        "INSERT INTO lbtablet_police_tags (title, color, `type`) VALUES (?, ?, ?)",
        { title, color, tagType }
    )

    if tagId then
        local tag = {
            id = tagId,
            title = title,
            color = color,
            type = tagType
        }

        policeTags[#policeTags + 1] = tag
        TriggerClientEvent("tablet:police:createdTag", -1, tag)
    end

    return tagId
end

registerPoliceCallback("createTag", function(_, tabletId, title, color, tagType)
    local tagId = createPoliceTag(title, color, tagType)
    if tagId then
        addPoliceLog(
            tabletId,
            tagId,
            "create",
            "tag",
            L("APPS.POLICE.LOGS.CREATE_TAG_TITLE"),
            L("APPS.POLICE.LOGS.CREATE_TAG_DESCRIPTION", {
                type = L("APPS.POLICE.LOGS.TAG_TYPES." .. string.upper(tagType)),
                name = title
            })
        )
    end

    return tagId
end, {
    antiSpam = true,
    permissions = {
        { "tag", "create" }
    }
})

exports("CreatePoliceTag", createPoliceTag)

registerPoliceCallback("deleteTag", function(_, tabletId, tagId)
    local tag, tagIndex = getTagById(tagId)
    if not tag then
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_tags WHERE id = ?",
        { tagId }
    ) > 0

    if not deleted then
        return false
    end

    addPoliceLog(
        tabletId,
        tagId,
        "delete",
        "tag",
        L("APPS.POLICE.LOGS.DELETE_TAG_TITLE"),
        L("APPS.POLICE.LOGS.DELETE_TAG_DESCRIPTION", {
            type = L("APPS.POLICE.LOGS.TAG_TYPES." .. string.upper(tag.type)),
            name = tag.title
        })
    )

    table.remove(policeTags, tagIndex)
    TriggerClientEvent("tablet:police:deletedTag", -1, tagId)

    return true
end, {
    permissions = {
        { "tag", "delete" }
    }
})

exports("DeletePoliceTag", function(tagId)
    local _, tagIndex = getTagById(tagId)
    if not tagIndex then
        return false
    end

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_tags WHERE id = ?",
        { tagId }
    ) > 0

    if deleted then
        table.remove(policeTags, tagIndex)
        TriggerClientEvent("tablet:police:deletedTag", -1, tagId)
    end

    return deleted
end)

local validTagTypes = {
    profile = true,
    vehicle = true,
    property = true,
    weapon = true
}

local function ensureTagPermissionForType(source, tagType)
    if tagType == "profile" then
        return HasPermission(source, "Police", "profile", "edit")
    elseif tagType == "vehicle" then
        return HasPermission(source, "Police", "vehicle", "edit")
    elseif tagType == "property" then
        return HasPermission(source, "Police", "property", "edit")
    elseif tagType == "weapon" then
        return HasPermission(source, "Police", "weapon", "edit")
    end

    return false
end

local function addTagToEntity(entityId, tagId)
    local tag = getTagById(tagId)
    if not tag then
        debugprint("Invalid tag", tagId)
        return false
    end

    local inserted = MySQL.update.await(
        "INSERT INTO lbtablet_police_profile_tags (id, tag_id) VALUES (?, ?)",
        { entityId, tagId }
    ) > 0

    if inserted then
        TriggerClientEvent("tablet:police:addedTag", -1, entityId, tag.type, tagId)
    end

    return inserted
end

registerPoliceCallback("addTag", function(source, _, entityId, tagId)
    local tag = getTagById(tagId)

    if not tag or not validTagTypes[tag.type] then
        debugprint("Invalid tag or tag type", tag)
        return false
    end

    if not ensureTagPermissionForType(source, tag.type) then
        return false
    end

    return addTagToEntity(entityId, tagId)
end, {
    antiSpam = true
})

exports("AddTagToPoliceProfile", addTagToEntity)

local function removeTagFromEntity(entityId, tagId)
    local removed = MySQL.update.await(
        "DELETE FROM lbtablet_police_profile_tags WHERE id = ? AND tag_id = ?",
        { entityId, tagId }
    ) > 0

    if removed then
        TriggerClientEvent("tablet:police:removedTag", -1, entityId, tagId)
    end

    return removed
end

registerPoliceCallback("removeTag", function(source, _, entityId, tagId)
    local tag = getTagById(tagId)

    if not tag or not validTagTypes[tag.type] then
        debugprint("Invalid tag or tag type", tag)
        return false
    end

    if not ensureTagPermissionForType(source, tag.type) then
        return false
    end

    return removeTagFromEntity(entityId, tagId)
end)

exports("RemoveTagFromPoliceProfile", removeTagFromEntity)

registerPoliceCallback("getDispatches", function()
    return GetJobDispatches("police")
end, {
    defaultReturn = {}
})

registerPoliceCallback("searchUsers", function(_, _, search, options, page)
    local filters = {}

    if options then
        if options.policeOnly then
            filters.jobs = policeJobs
        end

        if options.excludeJailed then
            filters.excludeJailed = true
        end

        if options.licenses then
            filters.licenses = options.licenses
        end

        if options.warrant ~= nil then
            filters.warrant = options.warrant == true
        end

        if options.gender then
            filters.gender = options.gender
        end

        if options.tags then
            filters.tags = {
                tagsTable = "lbtablet_police_profile_tags",
                tagsColumn = "id",
                tags = options.tags
            }
        end
    end

    local results = SearchUsers(search, filters, "lbtablet_police_profiles", page)

    for i = 1, #results do
        local user = results[i]
        user.tags = getEntityTags("lbtablet_police_profile_tags", "id", user.id)
        user.licenses = GetPlayerLicenses(user.id)
    end

    return results
end, {
    defaultReturn = {}
})

registerPoliceCallback("fetchUser", function(_, _, identifier)
    local query = Queries.Users.FetchProfile
    query = query:gsub("{PROFILE_JOIN}", "lbtablet_police_profiles")
    query = query:gsub("{USERS_COLLATE}", UsersCollate)

    local profile = MySQL.single.await(query, { identifier })
    if not profile then
        return false
    end

    local source = GetSourceFromIdentifier(identifier)

    profile.tags = getEntityTags("lbtablet_police_profile_tags", "id", identifier)
    profile.licenses = GetPlayerLicenses(identifier)
    profile.vehicles = GetVehicles(identifier)

    if source then
        local job = GetJob(source)
        if job and job.label and job.grade_label then
            profile.job = job.label
            profile.jobGrade = job.grade_label
        end
    end

    if Config.LBPhone then
        if source then
            profile.phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        end

        if not profile.phoneNumber then
            profile.phoneNumber = GetPhoneNumberFromIdentifier(identifier)
        end
    end

    local customFields = Config.Police.Profile and Config.Police.Profile.CustomFields
    if customFields and #customFields > 0 and GetCustomFields then
        local fields = GetCustomFields("police", "user", identifier)

        for key, value in pairs(fields) do
            profile[key] = value
        end
    end

    profile.cases = MySQL.query.await([[
        SELECT
            c.id,
            c.title,
            IFNULL(i.involvement, 'criminal') AS involvement
        FROM
            lbtablet_police_cases c
        LEFT JOIN lbtablet_police_cases_involved i
            ON c.id = i.case_id
        LEFT JOIN lbtablet_police_cases_criminals cr
            ON c.id = cr.case_id
        WHERE
            i.involved = ?
            OR cr.id = ?
        GROUP BY
            c.id
    ]], { identifier, identifier }) or {}

    profile.reports = MySQL.query.await([[
        SELECT
            r.id,
            r.title,
            i.involvement
        FROM
            lbtablet_police_reports_involved i
        LEFT JOIN lbtablet_police_reports r
            ON r.id = i.report_id
        WHERE
            i.involved = ?
    ]], { identifier }) or {}

    profile.weapons = MySQL.query.await([[
        SELECT
            w.serial_number AS serialNumber,
            w.weapon_name AS model
        FROM lbtablet_police_weapons w
        WHERE w.owner = ?
    ]], { identifier }) or {}

    profile.warrants = MySQL.query.await([[
        SELECT
            id,
            title AS label,
            warrant_status AS `status`
        FROM lbtablet_police_warrants
        WHERE linked_profile_type = 'player' AND linked_profile_id = ?
    ]], { identifier }) or {}

    for i = 1, #profile.weapons do
        local weapon = profile.weapons[i]
        weapon.model = (GetWeaponName and weapon.model and GetWeaponName(weapon.model)) or weapon.model or "??"
    end

    profile.charges = MySQL.query.await([[
        SELECT
            offence_id AS id,
            CAST(SUM(charges) AS INT) AS charges
        FROM
            lbtablet_police_cases_charges
        WHERE
            criminal = ?
        GROUP BY
            offence_id
    ]], { identifier }) or {}

    if GetPlayerProperties then
        profile.properties = GetPlayerProperties(identifier) or {}

        for i = 1, #profile.properties do
            profile.properties[i].id = "house:" .. profile.properties[i].id
        end
    end

    return profile
end)

local editableProfileTypes = {
    player = { permission = { "profile", "edit" } },
    vehicle = { permission = { "vehicle", "edit" } },
    property = { permission = { "property", "edit" } },
    weapon = { permission = { "weapon", "edit" } }
}

registerPoliceCallback("updateProfile", function(source, tabletId, profileData)
    if not profileData or not editableProfileTypes[profileData.type] then
        debugprint("Invalid profile type")
        return false
    end

    local permission = editableProfileTypes[profileData.type].permission
    if not HasPermission(source, "Police", permission[1], permission[2]) then
        return false
    end

    local updated = MySQL.update.await([[
        INSERT INTO lbtablet_police_profiles (id, avatar, notes, profile_type)
        VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            avatar = VALUES(avatar),
            notes = VALUES(notes),
            profile_type = VALUES(profile_type)
    ]], {
        profileData.id,
        profileData.avatar,
        profileData.notes or "",
        profileData.type
    }) > 0

    if not updated then
        return false
    end

    if profileData.type == "player" then
        addPoliceLog(
            tabletId,
            profileData.id,
            "update",
            "profile",
            L("APPS.POLICE.LOGS.UPDATE_PROFILE_TITLE"),
            L("APPS.POLICE.LOGS.UPDATE_PROFILE_DESCRIPTION", {
                name = GetCharacterNameFromIdentifier(profileData.id) or "??"
            })
        )
    elseif profileData.type == "vehicle" then
        addPoliceLog(
            tabletId,
            profileData.id,
            "update",
            "vehicle",
            L("APPS.POLICE.LOGS.UPDATE_VEHICLE_TITLE"),
            L("APPS.POLICE.LOGS.UPDATE_VEHICLE_DESCRIPTION", {
                plate = profileData.id
            })
        )
    elseif profileData.type == "property" then
        addPoliceLog(
            tabletId,
            profileData.id,
            "update",
            "property",
            L("APPS.POLICE.LOGS.UPDATE_PROPERTY_TITLE"),
            L("APPS.POLICE.LOGS.UPDATE_PROPERTY_DESCRIPTION", {
                id = profileData.id
            })
        )
    elseif profileData.type == "weapon" then
        local serial = profileData.id:sub(#("weapon:") + 1)

        if profileData.model then
            MySQL.update.await(
                "UPDATE lbtablet_police_weapons SET weapon_name = ? WHERE serial_number = ?",
                { profileData.model, serial }
            )
        end

        if profileData.owner then
            MySQL.update.await(
                "UPDATE lbtablet_police_weapons SET owner = ? WHERE serial_number = ?",
                { profileData.owner, serial }
            )
        end

        addPoliceLog(
            tabletId,
            profileData.id,
            "update",
            "weapon",
            L("APPS.POLICE.LOGS.UPDATE_WEAPON_TITLE"),
            L("APPS.POLICE.LOGS.UPDATE_WEAPON_DESCRIPTION", {
                serial = serial
            })
        )
    end

    TriggerClientEvent("tablet:police:profileUpdated", -1, profileData)

    return true
end, {
    antiSpam = true
})

registerPoliceCallback("revokeLicense", function(_, tabletId, identifier, licenseType)
    local success = RevokeLicense(identifier, licenseType)
    if success then
        TriggerClientEvent("tablet:police:revokedLicense", -1, identifier, licenseType)

        addPoliceLog(
            tabletId,
            identifier,
            "delete",
            "license",
            L("APPS.POLICE.LOGS.REVOKED_LICENSE_TITLE"),
            L("APPS.POLICE.LOGS.REVOKED_LICENSE_DESCRIPTION", {
                license = GetLicenseLabel(licenseType),
                name = GetCharacterNameFromIdentifier(identifier) or "??"
            })
        )
    end

    return success
end, {
    permissions = {
        { "license", "revoke" }
    }
})

registerPoliceCallback("addLicense", function(_, tabletId, identifier, licenseType)
    local success = AddLicense(identifier, licenseType)
    if success then
        TriggerClientEvent("tablet:police:licenseAdded", -1, identifier, {
            type = licenseType,
            label = GetLicenseLabel(licenseType)
        })

        addPoliceLog(
            tabletId,
            identifier,
            "create",
            "license",
            L("APPS.POLICE.LOGS.ISSUED_LICENSE_TITLE"),
            L("APPS.POLICE.LOGS.ISSUED_LICENSE_DESCRIPTION", {
                license = GetLicenseLabel(licenseType),
                name = GetCharacterNameFromIdentifier(identifier) or "??"
            })
        )
    end

    return success
end, {
    antiSpam = true,
    permissions = {
        { "license", "add" }
    }
})

registerPoliceCallback("getAllLicenses", function()
    if not GetAllLicenses then
        infoprint("error", "GetAllLicenses is not defined (framework not supported / not set up correctly)")
        return {}
    end

    return GetAllLicenses() or {}
end, {
    defaultReturn = {}
})

registerPoliceCallback("searchProperties", function(_, _, search, options, page)
    if not SearchProperties then
        debugprint("Invalid housing script, SearchProperties not defined")
        return {}
    end

    local properties = SearchProperties(search, page, options or {}) or {}

    for i = 1, #properties do
        local property = properties[i]
        property.id = "house:" .. property.id
        property.tags = getEntityTags("lbtablet_police_profile_tags", "id", property.id)
    end

    return properties
end, {
    defaultReturn = {}
})

registerPoliceCallback("getProperty", function(_, _, propertyId)
    if not GetProperty then
        debugprint("Invalid housing script, GetProperty not defined")
        return
    end

    local rawPropertyId = propertyId:sub(#("house:") + 1)
    local property = GetProperty(rawPropertyId)

    if not property then
        return
    end

    local profile = MySQL.single.await(
        "SELECT avatar, notes FROM lbtablet_police_profiles WHERE id = ?",
        { propertyId }
    )

    property.id = propertyId
    property.tags = getEntityTags("lbtablet_police_profile_tags", "id", propertyId)
    property.notes = (profile and profile.notes) or ""
    property.avatar = profile and profile.avatar or nil

    return property
end)

registerPoliceCallback("searchVehicles", function(_, _, search, options, page)
    local filters = {}

    search = search or ""

    if options then
        if options.warrant ~= nil then
            filters.warrant = options.warrant == true
        end

        if options.tags then
            filters.tags = {
                tagsTable = "lbtablet_police_profile_tags",
                tagsColumn = "id",
                tags = options.tags
            }
        end
    end

    local vehicles = SearchVehicles(search, filters, "lbtablet_police_profiles", page) or {}

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        vehicle.tags = getEntityTags("lbtablet_police_profile_tags", "id", vehicle.plate)
    end

    return vehicles
end, {
    defaultReturn = {}
})

registerPoliceCallback("fetchVehicle", function(_, _, plate)
    if not plate or plate == "" then
        return
    end

    local vehicle = FetchVehicle(plate, "lbtablet_police_profiles")
    if not vehicle then
        return
    end

    vehicle.tags = getEntityTags("lbtablet_police_profile_tags", "id", plate)

    vehicle.warrants = MySQL.query.await([[
        SELECT
            id,
            title AS label,
            warrant_status AS `status`
        FROM lbtablet_police_warrants
        WHERE linked_profile_type = 'vehicle' AND linked_profile_id = ?
    ]], { plate }) or {}

    vehicle.cases = MySQL.query.await([[
        SELECT
            i.case_id AS id,
            c.title
        FROM lbtablet_police_cases_involved i
        LEFT JOIN lbtablet_police_cases c
            ON c.id = i.case_id
        WHERE i.involved = ? AND i.involvement = 'vehicle'
    ]], { plate }) or {}

    local customFields = Config.Police.Vehicle and Config.Police.Vehicle.CustomFields
    if customFields and #customFields > 0 and GetCustomFields then
        local fields = GetCustomFields("police", "vehicle", plate) or {}

        for key, value in pairs(fields) do
            vehicle[key] = value
        end
    end

    return vehicle
end)

local function formatWeaponRow(weaponRow)
    local weaponImage
    if weaponRow.weapon_name and GetWeaponImage then
        weaponImage = GetWeaponImage(weaponRow.weapon_name)
    end

    local weaponLabel
    if weaponRow.weapon_name and GetWeaponName then
        weaponLabel = GetWeaponName(weaponRow.weapon_name)
    end

    local owner
    if weaponRow.owner and weaponRow.owner_name then
        owner = {
            identifier = weaponRow.owner,
            name = weaponRow.owner_name
        }
    end

    return {
        id = "weapon:" .. weaponRow.serial_number,
        serialNumber = weaponRow.serial_number,
        model = weaponLabel or weaponRow.weapon_name,
        picture = weaponRow.avatar or weaponImage,
        owner = owner,
        tags = getEntityTags("lbtablet_police_profile_tags", "id", "weapon:" .. weaponRow.serial_number)
    }
end

registerPoliceCallback("searchWeapons", function(_, _, search, options, page)
    local like = "%" .. search .. "%"
    page = page or 0

    local values = { like, like }
    local whereFilter = ""

    if options and options.tags then
        for i = 1, #options.tags do
            whereFilter = whereFilter ..
                " AND EXISTS (SELECT 1 FROM lbtablet_police_profile_tags ppt WHERE ppt.id = CONCAT('weapon:', w.serial_number) AND ppt.tag_id = ?)"
            values[#values + 1] = options.tags[i]
        end
    end

    local query = [[
        SELECT
            w.serial_number,
            w.owner,
            w.weapon_name,
            p.avatar,
            {SELECT_NAME} AS owner_name
        FROM lbtablet_police_weapons w
        LEFT JOIN lbtablet_police_profiles p
            ON p.id = CONCAT("weapon:", w.serial_number)
        {JOIN_NAME}
        WHERE
            (
                w.serial_number LIKE ?
                OR w.weapon_name LIKE ?
            )
            {WHERE_FILTER}
        LIMIT ?, ?
    ]]

    query = query:gsub("{WHERE_FILTER}", whereFilter)
    query = query:gsub("{SELECT_NAME}", Queries.Users.Select.name)
    query = query:gsub("{JOIN_NAME}", FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = w.owner",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate
        }
    ))

    values[#values + 1] = page * 10
    values[#values + 1] = 10

    local rows = MySQL.query.await(query, values) or {}

    for i = 1, #rows do
        rows[i] = formatWeaponRow(rows[i])
    end

    return rows
end, {
    defaultReturn = {}
})

registerPoliceCallback("fetchWeapon", function(_, _, weaponId)
    local query = [[
        SELECT
            w.serial_number,
            w.owner,
            w.weapon_name,
            p.avatar,
            p.notes,
            {SELECT_NAME} AS owner_name
        FROM lbtablet_police_weapons w
        LEFT JOIN lbtablet_police_profiles p
            ON p.id = CONCAT("weapon:", w.serial_number)
        {JOIN_NAME}
        WHERE w.serial_number = ?
    ]]

    query = query:gsub("{SELECT_NAME}", Queries.Users.Select.name)
    query = query:gsub("{JOIN_NAME}", FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = w.owner",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate
        }
    ))

    local serial = weaponId
    if serial:sub(1, #("weapon:")) == "weapon:" then
        serial = serial:sub(#("weapon:") + 1)
    end

    local row = MySQL.single.await(query, { serial })
    if not row then
        return
    end

    local weapon = formatWeaponRow(row)
    weapon.notes = row.notes

    weapon.reports = MySQL.query.await([[
        SELECT
            i.report_id AS id,
            r.title
        FROM lbtablet_police_reports_involved i
        LEFT JOIN lbtablet_police_reports r
            ON r.id = i.report_id
        WHERE i.involved = ?
    ]], { serial }) or {}

    weapon.cases = MySQL.query.await([[
        SELECT
            i.case_id AS id,
            c.title
        FROM lbtablet_police_cases_involved i
        LEFT JOIN lbtablet_police_cases c
            ON c.id = i.case_id
        WHERE i.involved = ?
    ]], { serial }) or {}

    return weapon
end)

registerPoliceCallback("registerWeapon", function(_, _, weaponData)
    if not weaponData.serialNumber then
        debugprint("Missing required fields", weaponData)
        return false
    end

    RegisterWeapon(weaponData.serialNumber, {
        owner = weaponData.owner,
        weaponName = weaponData.model
    })

    return true
end, {
    antiSpam = true,
    permissions = {
        { "weapon", "create" }
    }
})

registerPoliceCallback("deleteWeapon", function(_, tabletId, weaponId)
    local serial = weaponId:sub(#("weapon:") + 1)

    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_weapons WHERE serial_number = ?",
        { serial }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:police:weaponDeleted", -1, weaponId)

        addPoliceLog(
            tabletId,
            serial,
            "delete",
            "weapon",
            L("APPS.POLICE.LOGS.DELETE_WEAPON_TITLE"),
            L("APPS.POLICE.LOGS.DELETE_WEAPON_DESCRIPTION", {
                serial = serial
            })
        )
    end

    return deleted
end, {
    permissions = {
        { "weapon", "delete" }
    }
})

function RegisterWeapon(serialNumber, weaponData)
    assert(type(serialNumber) == "string", "Serial number must be a string")

    MySQL.update.await(
        "INSERT INTO lbtablet_police_weapons (serial_number, owner, weapon_name) VALUES (?, ?, ?)",
        {
            serialNumber,
            weaponData and weaponData.owner or nil,
            weaponData and weaponData.weaponName or nil
        }
    )
end

exports("RegisterWeapon", RegisterWeapon)

registerPoliceCallback("getBulletinBoard", function(_, tabletId, page, search)
    page = page or 0

    if search == "" or type(search) ~= "string" then
        search = nil
    end

    local params = {}

    if search then
        params[#params + 1] = "%" .. search .. "%"
    end

    params[#params + 1] = page * 25
    params[#params + 1] = 25

    local query = [[
        SELECT
            b.id,
            b.title,
            b.content,
            b.pinned,
            b.created_at AS `timestamp`,
            b.created_by AS created,
            a.display_name AS author,
            a.avatar
        FROM lbtablet_police_bulletin b
        LEFT JOIN lbtablet_police_accounts a ON a.id = b.created_by
    ]]

    if search then
        query = query .. " WHERE b.title LIKE ?"
    end

    query = query .. [[
        ORDER BY pinned DESC, created_at DESC
        LIMIT ?, ?
    ]]

    local rows = MySQL.query.await(query, params) or {}

    for i = 1, #rows do
        rows[i].created = rows[i].created == tabletId
    end

    return rows
end, {
    permissions = {
        { "bulletin", "view" }
    }
})

registerPoliceCallback("toggleBulletinPinned", function(_, tabletId, bulletinId, pinned)
    local updated = MySQL.update.await(
        "UPDATE lbtablet_police_bulletin SET pinned = ? WHERE id = ?",
        { pinned, bulletinId }
    ) > 0

    if not updated then
        return false
    end

    if pinned then
        addPoliceLog(
            tabletId,
            bulletinId,
            "update",
            "bulletin",
            L("APPS.POLICE.LOGS.PINNED_BULLETIN_TITLE"),
            L("APPS.POLICE.LOGS.PINNED_BULLETIN_DESCRIPTION", {
                id = bulletinId
            })
        )
    else
        addPoliceLog(
            tabletId,
            bulletinId,
            "update",
            "bulletin",
            L("APPS.POLICE.LOGS.UNPINNED_BULLETIN_TITLE"),
            L("APPS.POLICE.LOGS.UNPINNED_BULLETIN_DESCRIPTION", {
                id = bulletinId
            })
        )
    end

    return true
end, {
    permissions = {
        { "bulletin", "pin" }
    }
})

local function updateBulletin(source, tabletId, bulletinId, title, content)
    if not HasPermission(source, "Police", "bulletin", "edit") then
        local creator = MySQL.scalar.await(
            "SELECT created_by FROM lbtablet_police_bulletin WHERE id = ?",
            { bulletinId }
        )

        if creator ~= tabletId then
            debugprint("No permissions to edit bulletin")
            return false
        end
    end

    MySQL.update.await(
        "UPDATE lbtablet_police_bulletin SET title = ?, content = ? WHERE id = ?",
        { title, content, bulletinId }
    )

    addPoliceLog(
        tabletId,
        bulletinId,
        "update",
        "bulletin",
        L("APPS.POLICE.LOGS.UPDATE_BULLETIN_TITLE"),
        L("APPS.POLICE.LOGS.UPDATE_BULLETIN_DESCRIPTION", {
            title = title
        })
    )

    TriggerClientEvent("tablet:police:bulletinUpdated", -1, {
        id = bulletinId,
        title = title,
        content = content
    })

    return true
end

local function createBulletin(source, tabletId, title, content)
    if not HasPermission(source, "Police", "bulletin", "create") then
        debugprint("No permissions to create bulletin")
        return false
    end

    local bulletinId = MySQL.insert.await(
        "INSERT INTO lbtablet_police_bulletin (title, content, created_by) VALUES (?, ?, ?)",
        { title, content, tabletId }
    )

    if not bulletinId then
        debugprint("Failed to create bulletin")
        return false
    end

    local firstName, lastName = GetCharacterName(source)
    local authorName = (firstName or "") .. " " .. (lastName or "")

    if Config.Police.Notifications.NewBulletin then
        notifyPoliceTablets({
            title = L("BACKEND.POLICE.NEW_BULLETIN_NOTIFICATION.TITLE"),
            content = L("BACKEND.POLICE.NEW_BULLETIN_NOTIFICATION.CONTENT", {
                title = title,
                content = content
            })
        }, { tabletId })
    end

    addPoliceLog(
        tabletId,
        bulletinId,
        "create",
        "bulletin",
        L("APPS.POLICE.LOGS.CREATE_BULLETIN_TITLE"),
        L("APPS.POLICE.LOGS.CREATE_BULLETIN_DESCRIPTION", {
            title = title
        })
    )

    TriggerClientEvent("tablet:police:bulletinCreated", -1, {
        id = bulletinId,
        title = title,
        content = content,
        timestamp = os.time() * 1000,
        createdBy = tabletId,
        author = authorName,
        avatar = GetPoliceAvatar(tabletId)
    })

    return bulletinId
end

registerPoliceCallback("saveBulletin", function(source, tabletId, bulletinId, title, content)
    if bulletinId then
        local success = updateBulletin(source, tabletId, bulletinId, title, content)
        return success and bulletinId or false
    end

    local newBulletinId = createBulletin(source, tabletId, title, content)
    return newBulletinId or false
end, {
    antiSpam = true
})

registerPoliceCallback("deleteBulletin", function(source, tabletId, bulletinId)
    local deleted = false

    if HasPermission(source, "Police", "bulletin", "delete") then
        deleted = MySQL.update.await(
            "DELETE FROM lbtablet_police_bulletin WHERE id = ?",
            { bulletinId }
        ) > 0
    else
        deleted = MySQL.update.await(
            "DELETE FROM lbtablet_police_bulletin WHERE id = ? AND created_by = ?",
            { bulletinId, tabletId }
        ) > 0
    end

    if deleted then
        TriggerClientEvent("tablet:police:bulletinDeleted", -1, bulletinId)

        addPoliceLog(
            tabletId,
            bulletinId,
            "delete",
            "bulletin",
            L("APPS.POLICE.LOGS.DELETE_BULLETIN_TITLE"),
            L("APPS.POLICE.LOGS.DELETE_BULLETIN_DESCRIPTION", {
                id = bulletinId
            })
        )
    end

    return deleted
end)
-- ============================================
-- Part 3 - Reports / Warrants / Cases / Case tools
-- Append this file after police_clean_part2.lua
-- ============================================

registerPoliceCallback("getReports", function(_, _, page, search, filters)
    if search == "" or type(search) ~= "string" then
        search = nil
    end

    local params = {}
    local whereParts = {}

    if search then
        whereParts[#whereParts + 1] = "r.title LIKE ?"
        params[#params + 1] = ("%%%s%%"):format(search)

        if search:match("^%d+$") then
            whereParts[#whereParts] = "(r.title LIKE ? OR r.id = ?)"
            params[#params + 1] = tonumber(search)
        end
    end

    if filters and filters.tags then
        for i = 1, #filters.tags do
            whereParts[#whereParts + 1] =
                "EXISTS (SELECT 1 FROM lbtablet_police_reports_tags rpt WHERE rpt.report_id = r.id AND rpt.tag_id = ?)"
            params[#params + 1] = filters.tags[i]
        end
    end

    if filters and filters.type then
        whereParts[#whereParts + 1] = "r.report_type = ?"
        params[#params + 1] = filters.type
    end

    if filters and filters.involved then
        for i = 1, #filters.involved do
            local involved = filters.involved[i]
            whereParts[#whereParts + 1] =
                "EXISTS (SELECT 1 FROM lbtablet_police_reports_involved i WHERE i.report_id = r.id AND i.involved = ? AND i.involvement = ?)"
            params[#params + 1] = involved.id
            params[#params + 1] = involved.involvement
        end
    end

    params[#params + 1] = (page or 0) * 10
    params[#params + 1] = 10

    local whereClause = ""
    if #whereParts > 0 then
        whereClause = "WHERE " .. table.concat(whereParts, " AND ")
    end

    local reports = MySQL.query.await(([[
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
        FROM lbtablet_police_reports r
        LEFT JOIN lbtablet_police_accounts a ON a.id = r.created_by
        %s
        ORDER BY r.updated_at DESC
        LIMIT ?, ?
    ]]):format(whereClause), params) or {}

    for i = 1, #reports do
        reports[i].tags = getEntityTags("lbtablet_police_reports_tags", "report_id", reports[i].id)
    end

    return reports
end, {
    permissions = {
        { "report", "view" }
    }
})

local function getPoliceReportById(reportId)
    local report = MySQL.single.await([[
        SELECT
            r.id,
            r.title,
            r.report_type AS `type`,
            r.`description`,
            r.created_at AS created,
            r.updated_at AS lastUpdated,
            r.created_by AS createdBy,
            a.display_name AS author,
            a.avatar
        FROM lbtablet_police_reports r
        LEFT JOIN lbtablet_police_accounts a ON a.id = r.created_by
        WHERE r.id = ?
    ]], { reportId })

    if not report then
        return false
    end

    report.gallery = MySQL.query.await(
        "SELECT attachment FROM lbtablet_police_reports_attachments WHERE report_id = ?",
        { reportId }
    ) or {}

    report.tags = getEntityTags("lbtablet_police_reports_tags", "report_id", reportId)

    local involvedQuery = [[
        SELECT
            i.involved,
            i.involvement,
            {SELECT_NAME} AS `name`
        FROM lbtablet_police_reports_involved i
        {JOIN_NAME}
        WHERE
            i.report_id = ?
            AND (i.involvement = "officer" OR i.involvement = "civilian" OR i.involvement = "suspect")
    ]]

    involvedQuery = involvedQuery:gsub("{SELECT_NAME}", Queries.Users.Select.name)
    involvedQuery = involvedQuery:gsub("{JOIN_NAME}", FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = i.involved",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate
        }
    ))

    report.involved = MySQL.query.await(involvedQuery, { reportId }) or {}

    local weapons = MySQL.query.await([[
        SELECT
            i.involved,
            w.weapon_name
        FROM lbtablet_police_reports_involved i
        LEFT JOIN lbtablet_police_weapons w
            ON w.serial_number = i.involved
        WHERE i.report_id = ? AND i.involvement = "weapon"
    ]], { reportId }) or {}

    report.weaponsInvolved = {}

    for i = 1, #weapons do
        local weapon = weapons[i]
        report.weaponsInvolved[i] = {
            id = "weapon:" .. weapon.involved,
            serialNumber = weapon.involved,
            model = GetWeaponName and weapon.weapon_name and GetWeaponName(weapon.weapon_name) or weapon.weapon_name
        }
    end

    return report
end

registerPoliceCallback("getReport", function(_, _, reportId)
    return getPoliceReportById(reportId)
end)

local function savePoliceReport(source, tabletId, data)
    if not data or type(data.title) ~= "string" or #data.title < 3 or type(data.description) ~= "string" or type(data.type) ~= "string" then
        debugprint("SaveReport: Invalid data", data)
        return false
    end

    local reportId = data.id
    local title = data.title
    local description = data.description
    local reportType = data.type
    local tags = data.tags or {}
    local gallery = data.gallery or {}
    local officers = data.officers or {}
    local civilians = data.civilians or {}
    local suspects = data.suspects or {}
    local weapons = data.weapons or {}

    if not reportId then
        if not HasPermission(source, "Police", "report", "create") then
            return false
        end

        reportId = MySQL.insert.await(
            "INSERT INTO lbtablet_police_reports (title, report_type, created_by, `description`) VALUES (?, ?, ?, ?)",
            { title, reportType, tabletId, description }
        )

        if not reportId then
            return false
        end

        addPoliceLog(
            tabletId,
            reportId,
            "create",
            "report",
            L("APPS.POLICE.LOGS.CREATE_REPORT_TITLE"),
            L("APPS.POLICE.LOGS.CREATE_REPORT_DESCRIPTION", {
                type = reportType or "",
                title = title
            })
        )

        if Config.Police.Notifications.NewReport then
            notifyPoliceTablets({
                title = L("BACKEND.POLICE.NEW_REPORT_NOTIFICATION.TITLE"),
                content = L("BACKEND.POLICE.NEW_REPORT_NOTIFICATION.CONTENT", {
                    title = title,
                    description = description
                })
            }, { tabletId })
        end
    else
        if not HasPermission(source, "Police", "report", "edit") then
            return false
        end

        MySQL.rawExecute.await(
            "UPDATE lbtablet_police_reports SET title = ?, report_type = ?, `description` = ? WHERE id = ?",
            { title, reportType, description, reportId }
        )

        MySQL.rawExecute.await("DELETE FROM lbtablet_police_reports_tags WHERE report_id = ?", { reportId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_reports_attachments WHERE report_id = ?", { reportId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_reports_involved WHERE report_id = ?", { reportId })

        TriggerClientEvent("tablet:police:reportUpdated", -1, data)

        addPoliceLog(
            tabletId,
            reportId,
            "update",
            "report",
            L("APPS.POLICE.LOGS.UPDATE_REPORT_TITLE"),
            L("APPS.POLICE.LOGS.UPDATE_REPORT_DESCRIPTION", {
                type = reportType or "",
                title = title
            })
        )
    end

    if #tags > 0 then
        local tagRows = {}

        for i = 1, #tags do
            tagRows[#tagRows + 1] = { reportId, tags[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_reports_tags (report_id, tag_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE tag_id = VALUES(tag_id)",
            tagRows
        )
    end

    if #gallery > 0 then
        local attachmentRows = {}

        for i = 1, #gallery do
            attachmentRows[#attachmentRows + 1] = { reportId, gallery[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_reports_attachments (report_id, attachment) VALUES (?, ?) ON DUPLICATE KEY UPDATE attachment = VALUES(attachment)",
            attachmentRows
        )
    end

    local involvedRows = {}

    for i = 1, #officers do
        involvedRows[#involvedRows + 1] = { reportId, officers[i], "officer" }
    end

    for i = 1, #civilians do
        involvedRows[#involvedRows + 1] = { reportId, civilians[i], "civilian" }
    end

    for i = 1, #suspects do
        involvedRows[#involvedRows + 1] = { reportId, suspects[i], "suspect" }
    end

    for i = 1, #weapons do
        involvedRows[#involvedRows + 1] = { reportId, weapons[i], "weapon" }
    end

    if #involvedRows > 0 then
        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_reports_involved (report_id, involved, involvement) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE involvement = VALUES(involvement)",
            involvedRows
        )
    end

    return reportId
end

registerPoliceCallback("saveReport", function(source, tabletId, data)
    return savePoliceReport(source, tabletId, data)
end, {
    antiSpam = true
})

registerPoliceCallback("deleteReport", function(_, tabletId, reportId)
    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_reports WHERE id = ?",
        { reportId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:police:reportDeleted", -1, reportId)

        addPoliceLog(
            tabletId,
            reportId,
            "delete",
            "report",
            L("APPS.POLICE.LOGS.DELETE_REPORT_TITLE"),
            L("APPS.POLICE.LOGS.DELETE_REPORT_DESCRIPTION", {
                id = reportId
            })
        )
    end

    return deleted
end, {
    permissions = {
        { "report", "delete" }
    }
})

exports("CreatePoliceReport", function(source, data)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        debugprint("CreateReport: No tablet found")
        return false, "no_tablet"
    end

    data.id = nil
    return savePoliceReport(source, tabletId, data)
end)

exports("GetPoliceReport", getPoliceReportById)

exports("UpdatePoliceReport", function(source, data)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        debugprint("UpdateReport: No tablet found")
        return false, "no_tablet"
    end

    if not data or not data.id then
        debugprint("UpdateReport: No ID provided")
        return false, "no_id"
    end

    return savePoliceReport(source, tabletId, data)
end)

exports("DeletePoliceReport", function(reportId)
    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_reports WHERE id = ?",
        { reportId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:police:reportDeleted", -1, reportId)
    end

    return deleted
end)

registerPoliceCallback("getWarrants", function(_, _, page, search, filters)
    debugprint("getWarrants", page, search, filters)

    page = page or 0
    if search == "" or type(search) ~= "string" then
        search = nil
    end

    local whereParts = {}
    local params = {}

    if search then
        whereParts[#whereParts + 1] = "w.title LIKE ?"
        params[#params + 1] = ("%%%s%%"):format(search)

        if IsStringOnlyNumbers(search) then
            whereParts[#whereParts] = "(w.title LIKE ? OR w.id = ?)"
            params[#params + 1] = tonumber(search)
        end
    end

    if filters and filters.tags then
        for i = 1, #filters.tags do
            whereParts[#whereParts + 1] =
                "EXISTS (SELECT 1 FROM lbtablet_police_warrants_tags pwt WHERE pwt.warrant_id = w.id AND pwt.tag_id = ?)"
            params[#params + 1] = filters.tags[i]
        end
    end

    if filters and filters.type then
        whereParts[#whereParts + 1] = "w.warrant_type = ?"
        params[#params + 1] = filters.type
    end

    if filters and filters.status then
        whereParts[#whereParts + 1] = "w.warrant_status = ?"
        params[#params + 1] = filters.status
    end

    if filters and filters.priority then
        whereParts[#whereParts + 1] = "w.priority = ?"
        params[#params + 1] = filters.priority
    end

    local whereClause = ""
    if #whereParts > 0 then
        whereClause = "WHERE " .. table.concat(whereParts, " AND ")
    end

    params[#params + 1] = page * 10
    params[#params + 1] = 10

    local warrants = MySQL.query.await(([[
        SELECT
            w.id,
            w.title,
            w.`description`,
            w.warrant_status AS `status`,
            w.warrant_type AS `type`,
            w.priority,
            w.created_by AS createdBy,
            w.created_at AS `timestamp`,
            w.updated_at AS lastUpdated,
            a.display_name AS author
        FROM lbtablet_police_warrants w
        LEFT JOIN lbtablet_police_accounts a ON a.id = w.created_by
        %s
        ORDER BY w.updated_at DESC
        LIMIT ?, ?
    ]]):format(whereClause), params) or {}

    for i = 1, #warrants do
        warrants[i].tags = getEntityTags("lbtablet_police_warrants_tags", "warrant_id", warrants[i].id)
    end

    return warrants
end, {
    permissions = {
        { "warrant", "view" }
    }
})

local function getPoliceWarrantById(warrantId)
    local warrant = MySQL.single.await([[
        SELECT
            w.id,
            w.title,
            w.`description`,
            w.warrant_type AS `type`,
            w.warrant_status AS `status`,
            w.priority,
            w.created_by AS createdBy,
            w.created_at AS `timestamp`,
            w.updated_at AS lastUpdated,
            a.display_name AS author,
            w.linked_profile_id,
            w.linked_profile_type,
            p.avatar AS linked_profile_avatar
        FROM lbtablet_police_warrants w
        LEFT JOIN lbtablet_police_accounts a ON a.id = w.created_by
        LEFT JOIN lbtablet_police_profiles p ON p.id = w.linked_profile_id
        WHERE w.id = ?
    ]], { warrantId })

    if not warrant then
        return false
    end

    if warrant.linked_profile_id then
        warrant.target = {
            id = warrant.linked_profile_id,
            type = warrant.linked_profile_type == "player" and "profile" or "vehicle",
            avatar = warrant.linked_profile_avatar
        }

        if warrant.linked_profile_type == "player" then
            local target = MySQL.single.await(FormatString(
                "SELECT {NAME} AS `name`, {DOB} AS dob, {IS_MALE} AS isMale FROM {TABLE} user WHERE {IDENTIFIER} = ?",
                {
                    NAME = Queries.Users.Select.name,
                    DOB = Queries.Users.Select.dob,
                    IS_MALE = Queries.Users.Select.isMale,
                    TABLE = Queries.Users.Table,
                    IDENTIFIER = Queries.Users.Select.identifier
                }
            ), { warrant.linked_profile_id })

            if target then
                warrant.target.name = target.name
                warrant.target.dob = target.dob
            end
        else
            local vehicle = MySQL.single.await(Queries.Vehicles.BasicFetch, { warrant.linked_profile_id })
            if vehicle then
                warrant.target.vehicle = vehicle
            end
        end
    end

    local attachments = MySQL.query.await(
        "SELECT attachment FROM lbtablet_police_warrants_attachments WHERE warrant_id = ?",
        { warrantId }
    ) or {}

    warrant.gallery = {}

    for i = 1, #attachments do
        warrant.gallery[i] = attachments[i].attachment
    end

    warrant.tags = getEntityTags("lbtablet_police_warrants_tags", "warrant_id", warrantId)

    warrant.reports = MySQL.query.await([[
        SELECT
            r.id,
            r.title AS label
        FROM lbtablet_police_warrants_linked_reports wr
        LEFT JOIN lbtablet_police_reports r ON r.id = wr.report_id
        WHERE wr.warrant_id = ?
    ]], { warrantId }) or {}

    return warrant
end

registerPoliceCallback("getWarrant", function(_, _, warrantId)
    return getPoliceWarrantById(warrantId)
end)

local function savePoliceWarrant(source, tabletId, data)
    if
        not data
        or type(data.title) ~= "string"
        or #data.title < 3
        or type(data.description) ~= "string"
        or type(data.type) ~= "string"
        or type(data.status) ~= "string"
        or type(data.priority) ~= "string"
    then
        debugprint("saveWarrant: Invalid data", data)
        return false
    end

    local warrantId = data.id
    local linkedProfileId
    local linkedProfileType

    if data.target and data.target.id and data.target.type then
        if data.target.type == "profile" then
            linkedProfileId = data.target.id
            linkedProfileType = "player"
        elseif data.target.type == "vehicle" then
            linkedProfileId = data.target.id
            linkedProfileType = "vehicle"
        end
    end

    if not warrantId then
        if not HasPermission(source, "Police", "warrant", "create") then
            return false
        end

        warrantId = MySQL.insert.await([[
            INSERT INTO lbtablet_police_warrants
                (title, `description`, warrant_type, warrant_status, priority, created_by, linked_profile_id, linked_profile_type)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            data.title,
            data.description,
            data.type,
            data.status,
            data.priority,
            tabletId,
            linkedProfileId,
            linkedProfileType
        })

        if not warrantId then
            return false
        end

        addPoliceLog(
            tabletId,
            warrantId,
            "create",
            "warrant",
            L("APPS.POLICE.LOGS.CREATE_WARRANT_TITLE"),
            L("APPS.POLICE.LOGS.CREATE_WARRANT_DESCRIPTION", {
                type = data.type and (data.type .. " ") or "",
                title = data.title
            })
        )

        if Config.Police.Notifications.NewReport then
            notifyPoliceTablets({
                title = L("BACKEND.POLICE.NEW_WARRANT_NOTIFICATION.TITLE"),
                content = L("BACKEND.POLICE.NEW_WARRANT_NOTIFICATION.CONTENT", {
                    title = data.title,
                    description = data.description
                })
            }, { tabletId })
        end
    else
        if not HasPermission(source, "Police", "warrant", "edit") then
            return false
        end

        MySQL.rawExecute.await([[
            UPDATE lbtablet_police_warrants
            SET
                title = ?,
                `description` = ?,
                warrant_type = ?,
                warrant_status = ?,
                priority = ?,
                linked_profile_id = ?,
                linked_profile_type = ?
            WHERE id = ?
        ]], {
            data.title,
            data.description,
            data.type,
            data.status,
            data.priority,
            linkedProfileId,
            linkedProfileType,
            warrantId
        })

        MySQL.rawExecute.await("DELETE FROM lbtablet_police_warrants_tags WHERE warrant_id = ?", { warrantId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_warrants_attachments WHERE warrant_id = ?", { warrantId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_warrants_linked_reports WHERE warrant_id = ?", { warrantId })

        TriggerClientEvent("tablet:police:warrantUpdated", -1, data)

        addPoliceLog(
            tabletId,
            warrantId,
            "update",
            "warrant",
            L("APPS.POLICE.LOGS.UPDATE_WARRANT_TITLE"),
            L("APPS.POLICE.LOGS.UPDATE_WARRANT_DESCRIPTION", {
                title = data.title
            })
        )
    end

    local tags = data.tags or {}
    if #tags > 0 then
        local rows = {}

        for i = 1, #tags do
            rows[#rows + 1] = { warrantId, tags[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_warrants_tags (warrant_id, tag_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE tag_id = VALUES(tag_id)",
            rows
        )
    end

    local gallery = data.gallery or {}
    if #gallery > 0 then
        local rows = {}

        for i = 1, #gallery do
            rows[#rows + 1] = { warrantId, gallery[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_warrants_attachments (warrant_id, attachment) VALUES (?, ?) ON DUPLICATE KEY UPDATE attachment = VALUES(attachment)",
            rows
        )
    end

    local reports = data.reports or {}
    if #reports > 0 then
        local rows = {}

        for i = 1, #reports do
            rows[#rows + 1] = { warrantId, reports[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_warrants_linked_reports (warrant_id, report_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE report_id = VALUES(report_id)",
            rows
        )
    end

    return warrantId
end

registerPoliceCallback("saveWarrant", function(source, tabletId, data)
    return savePoliceWarrant(source, tabletId, data)
end, {
    antiSpam = true
})

registerPoliceCallback("deleteWarrant", function(_, tabletId, warrantId)
    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_warrants WHERE id = ?",
        { warrantId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:police:warrantDeleted", -1, warrantId)

        addPoliceLog(
            tabletId,
            warrantId,
            "delete",
            "warrant",
            L("APPS.POLICE.LOGS.DELETE_WARRANT_TITLE"),
            L("APPS.POLICE.LOGS.DELETE_WARRANT_DESCRIPTION", {
                id = warrantId
            })
        )
    end

    return deleted
end, {
    permissions = {
        { "warrant", "delete" }
    }
})

exports("CreatePoliceWarrant", function(source, data)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        debugprint("CreateWarrant: No tablet found")
        return false, "no_tablet"
    end

    data.id = nil
    return savePoliceWarrant(source, tabletId, data)
end)

exports("GetPoliceWarrant", getPoliceWarrantById)

exports("UpdatePoliceWarrant", function(source, data)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        debugprint("UpdateWarrant: No tablet found")
        return false, "no_tablet"
    end

    if not data or not data.id then
        debugprint("UpdateWarrant: No ID provided")
        return false, "no_id"
    end

    return savePoliceWarrant(source, tabletId, data)
end)

exports("DeletePoliceWarrant", function(warrantId)
    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_warrants WHERE id = ?",
        { warrantId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:police:warrantDeleted", -1, warrantId)
    end

    return deleted
end)

registerPoliceCallback("getCases", function(_, _, page, search, filters)
    page = page or 0
    if search == "" or type(search) ~= "string" then
        search = nil
    end

    local whereParts = {}
    local params = {}

    if search then
        whereParts[#whereParts + 1] = "c.title LIKE ?"
        params[#params + 1] = ("%%%s%%"):format(search)

        if IsStringOnlyNumbers(search) then
            whereParts[#whereParts] = "(c.title LIKE ? OR c.id = ?)"
            params[#params + 1] = tonumber(search)
        end
    end

    if filters and filters.tags then
        for i = 1, #filters.tags do
            whereParts[#whereParts + 1] =
                "EXISTS (SELECT 1 FROM lbtablet_police_cases_tags pct WHERE pct.case_id = c.id AND pct.tag_id = ?)"
            params[#params + 1] = filters.tags[i]
        end
    end

    if filters and filters.type then
        whereParts[#whereParts + 1] = "c.case_type = ?"
        params[#params + 1] = filters.type
    end

    if filters and filters.involved then
        for i = 1, #filters.involved do
            local involved = filters.involved[i]

            if involved.involvement == "criminal" then
                whereParts[#whereParts + 1] =
                    "EXISTS (SELECT 1 FROM lbtablet_police_cases_criminals pcc WHERE pcc.case_id = c.id AND pcc.id = ?)"
                params[#params + 1] = involved.id
            else
                whereParts[#whereParts + 1] =
                    "EXISTS (SELECT 1 FROM lbtablet_police_cases_involved i WHERE i.case_id = c.id AND i.involved = ? AND i.involvement = ?)"
                params[#params + 1] = involved.id
                params[#params + 1] = involved.involvement
            end
        end
    end

    local whereClause = ""
    if #whereParts > 0 then
        whereClause = "WHERE " .. table.concat(whereParts, " AND ")
    end

    params[#params + 1] = page * 10
    params[#params + 1] = 10

    local cases = MySQL.query.await(([[
        SELECT
            c.id,
            c.title,
            c.description,
            c.created_by AS createdBy,
            c.created_at AS created,
            c.updated_at AS lastUpdated,
            a.display_name as author
        FROM lbtablet_police_cases c
        LEFT JOIN lbtablet_police_accounts a ON a.id = c.created_by
        %s
        ORDER BY c.updated_at DESC
        LIMIT ?, ?
    ]]):format(whereClause), params) or {}

    for i = 1, #cases do
        cases[i].tags = getEntityTags("lbtablet_police_cases_tags", "case_id", cases[i].id)
    end

    return cases
end, {
    defaultReturn = {}
})

local function getPoliceCaseById(caseId)
    local case = MySQL.single.await([[
        SELECT
            c.id,
            c.title,
            c.description,
            c.created_by AS createdBy,
            c.created_at AS created,
            c.updated_at AS lastUpdated,
            a.display_name AS author
        FROM lbtablet_police_cases c
        LEFT JOIN lbtablet_police_accounts a ON a.id = c.created_by
        WHERE c.id = ?
    ]], { caseId })

    if not case then
        return false
    end

    local involvedQuery = [[
        SELECT
            i.involved,
            i.involvement,
            {SELECT_NAME} AS `name`
        FROM lbtablet_police_cases_involved i
        {JOIN_NAME}
        WHERE
            i.case_id = ?
            AND (i.involvement = "officer" OR i.involvement = "civilian" OR i.involvement = "vehicle")
    ]]

    involvedQuery = involvedQuery:gsub("{SELECT_NAME}", Queries.Users.Select.name)
    involvedQuery = involvedQuery:gsub("{JOIN_NAME}", FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = i.involved",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate
        }
    ))

    case.involved = MySQL.query.await(involvedQuery, { caseId }) or {}
    case.evidence = MySQL.query.await(
        "SELECT attachment FROM lbtablet_police_cases_evidence WHERE case_id = ?",
        { caseId }
    ) or {}
    case.tags = getEntityTags("lbtablet_police_cases_tags", "case_id", caseId)

    local vehiclePlates = {}

    for i = 1, #case.involved do
        if case.involved[i].involvement == "vehicle" then
            vehiclePlates[#vehiclePlates + 1] = case.involved[i].involved
        end
    end

    if #vehiclePlates > 0 then
        case.vehicleModels = MySQL.query.await(FormatString(
            "SELECT {PLATE} AS plate, {MODEL} AS model FROM {TABLE} vehicle WHERE {PLATE} IN (?)",
            {
                TABLE = Queries.Vehicles.Table,
                PLATE = Queries.Vehicles.Select.plate,
                MODEL = Queries.Vehicles.Select.model
            }
        ), { vehiclePlates }) or {}
    else
        case.vehicleModels = {}
    end

    local weapons = MySQL.query.await([[
        SELECT
            i.involved,
            w.weapon_name
        FROM lbtablet_police_cases_involved i
        LEFT JOIN lbtablet_police_weapons w
            ON w.serial_number = i.involved
        WHERE i.case_id = ? AND i.involvement = "weapon"
    ]], { caseId }) or {}

    case.weaponsInvolved = {}

    for i = 1, #weapons do
        local weapon = weapons[i]
        case.weaponsInvolved[i] = {
            id = "weapon:" .. weapon.involved,
            serialNumber = weapon.involved,
            model = GetWeaponName and weapon.weapon_name and GetWeaponName(weapon.weapon_name) or weapon.weapon_name
        }
    end

    local criminalsQuery = [[
        SELECT
            c.id,
            c.fine,
            c.jail_time,
            c.fined AS hasFined,
            c.jailed AS hasJailed,
            {SELECT_NAME} AS `name`
        FROM lbtablet_police_cases_criminals c
        {JOIN_NAME}
        WHERE c.case_id = ?
    ]]

    criminalsQuery = criminalsQuery:gsub("{SELECT_NAME}", Queries.Users.Select.name)
    criminalsQuery = criminalsQuery:gsub("{JOIN_NAME}", FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = c.id",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate
        }
    ))

    case.criminalsInvolved = MySQL.query.await(criminalsQuery, { caseId }) or {}

    for i = 1, #case.criminalsInvolved do
        local criminal = case.criminalsInvolved[i]
        local chargeRows = MySQL.query.await(
            "SELECT offence_id, charges FROM lbtablet_police_cases_charges WHERE case_id = ? AND criminal = ?",
            { caseId, criminal.id }
        ) or {}

        criminal.charges = {}

        for j = 1, #chargeRows do
            criminal.charges[#criminal.charges + 1] = {
                id = chargeRows[j].offence_id,
                charges = chargeRows[j].charges
            }
        end
    end

    case.reports = MySQL.query.await([[
        SELECT
            linked_report.report_id AS id,
            report.title AS label
        FROM lbtablet_police_cases_linked_reports linked_report
        LEFT JOIN lbtablet_police_reports report ON report.id = linked_report.report_id
        WHERE linked_report.case_id = ?
    ]], { caseId }) or {}

    return case
end

registerPoliceCallback("getCase", function(_, _, caseId)
    return getPoliceCaseById(caseId)
end)

local function saveCaseCriminals(caseId, criminals)
    local criminalRows = {}
    local chargeRows = {}

    for i = 1, #criminals do
        local criminal = criminals[i]
        criminal.charges = criminal.charges or {}

        criminalRows[#criminalRows + 1] = {
            caseId,
            criminal.id,
            criminal.fine or 0,
            criminal.jailTime or 0,
            criminal.hasFined or false,
            criminal.hasJailed or false
        }

        for j = 1, #criminal.charges do
            local charge = criminal.charges[j]
            chargeRows[#chargeRows + 1] = {
                caseId,
                criminal.id,
                charge.id,
                charge.charges or 1
            }
        end
    end

    if #criminalRows == 0 then
        return
    end

    MySQL.rawExecute.await(
        "INSERT INTO lbtablet_police_cases_criminals (case_id, id, fine, jail_time, fined, jailed) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE fine = VALUES(fine), jail_time = VALUES(jail_time), fined = VALUES(fined), jailed = VALUES(jailed)",
        criminalRows
    )

    if #chargeRows > 0 then
        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_cases_charges (case_id, criminal, offence_id, charges) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE offence_id = VALUES(offence_id), charges = VALUES(charges)",
            chargeRows
        )
    end
end

local function savePoliceCase(source, tabletId, data)
    if not data or type(data.title) ~= "string" or #data.title < 3 or type(data.description) ~= "string" then
        debugprint("SaveCase: Invalid data", data)
        return false
    end

    local caseId = data.id
    local title = data.title
    local description = data.description
    local evidence = data.evidence or {}
    local vehicles = data.vehicles or {}
    local officers = data.officers or {}
    local civilians = data.civilians or {}
    local criminals = data.criminals or {}
    local weapons = data.weapons or {}
    local tags = data.tags or {}
    local reports = data.reports or {}

    if not caseId then
        if not HasPermission(source, "Police", "case", "create") then
            return false
        end

        caseId = MySQL.insert.await(
            "INSERT INTO lbtablet_police_cases (title, `description`, created_by) VALUES (?, ?, ?)",
            { title, description, tabletId }
        )

        if not caseId then
            return false
        end

        addPoliceLog(
            tabletId,
            caseId,
            "create",
            "case",
            L("APPS.POLICE.LOGS.CREATE_CASE_TITLE"),
            L("APPS.POLICE.LOGS.CREATE_CASE_DESCRIPTION", {
                title = title
            })
        )

        if Config.Police.Notifications.NewCase then
            notifyPoliceTablets({
                title = L("BACKEND.POLICE.NEW_CASE_NOTIFICATION.TITLE"),
                content = L("BACKEND.POLICE.NEW_CASE_NOTIFICATION.CONTENT", {
                    title = title,
                    description = description
                })
            }, { tabletId })
        end
    else
        if not HasPermission(source, "Police", "case", "edit") then
            return false
        end

        MySQL.rawExecute.await(
            "UPDATE lbtablet_police_cases SET title = ?, `description` = ? WHERE id = ?",
            { title, description, caseId }
        )

        MySQL.rawExecute.await("DELETE FROM lbtablet_police_cases_evidence WHERE case_id = ?", { caseId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_cases_tags WHERE case_id = ?", { caseId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_cases_involved WHERE case_id = ?", { caseId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_cases_criminals WHERE case_id = ?", { caseId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_cases_charges WHERE case_id = ?", { caseId })
        MySQL.rawExecute.await("DELETE FROM lbtablet_police_cases_linked_reports WHERE case_id = ?", { caseId })

        TriggerClientEvent("tablet:police:caseUpdated", -1, data)

        addPoliceLog(
            tabletId,
            caseId,
            "update",
            "case",
            L("APPS.POLICE.LOGS.UPDATE_CASE_TITLE"),
            L("APPS.POLICE.LOGS.UPDATE_CASE_DESCRIPTION", {
                title = title
            })
        )
    end

    saveCaseCriminals(caseId, criminals)

    if #evidence > 0 then
        local rows = {}

        for i = 1, #evidence do
            rows[#rows + 1] = { caseId, evidence[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_cases_evidence (case_id, attachment) VALUES (?, ?) ON DUPLICATE KEY UPDATE attachment = VALUES(attachment)",
            rows
        )
    end

    if #tags > 0 then
        local rows = {}

        for i = 1, #tags do
            rows[#rows + 1] = { caseId, tags[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_cases_tags (case_id, tag_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE tag_id = VALUES(tag_id)",
            rows
        )
    end

    if #reports > 0 then
        local rows = {}

        for i = 1, #reports do
            rows[#rows + 1] = { caseId, reports[i] }
        end

        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_cases_linked_reports (case_id, report_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE report_id = VALUES(report_id)",
            rows
        )
    end

    local involvedRows = {}

    for i = 1, #vehicles do
        involvedRows[#involvedRows + 1] = { caseId, vehicles[i], "vehicle" }
    end

    for i = 1, #officers do
        involvedRows[#involvedRows + 1] = { caseId, officers[i], "officer" }
    end

    for i = 1, #civilians do
        involvedRows[#involvedRows + 1] = { caseId, civilians[i], "civilian" }
    end

    for i = 1, #weapons do
        involvedRows[#involvedRows + 1] = { caseId, weapons[i], "weapon" }
    end

    if #involvedRows > 0 then
        MySQL.rawExecute.await(
            "INSERT INTO lbtablet_police_cases_involved (case_id, involved, involvement) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE involvement = VALUES(involvement)",
            involvedRows
        )
    end

    return caseId
end

registerPoliceCallback("saveCase", function(source, tabletId, data)
    return savePoliceCase(source, tabletId, data)
end, {
    antiSpam = true
})

registerPoliceCallback("deleteCase", function(_, tabletId, caseId)
    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_cases WHERE id = ?",
        { caseId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:police:caseDeleted", -1, caseId)

        addPoliceLog(
            tabletId,
            caseId,
            "delete",
            "case",
            L("APPS.POLICE.LOGS.DELETE_CASE_TITLE"),
            L("APPS.POLICE.LOGS.DELETE_CASE_DESCRIPTION", {
                id = caseId
            })
        )
    end

    return deleted
end, {
    permissions = {
        { "case", "delete" }
    }
})

registerPoliceCallback("openStash", function(source, _, caseId)
    if not Config.EvidenceStash then
        return false
    end

    local exists = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_police_cases WHERE id = ?",
        { caseId }
    )

    if not exists then
        debugprint("openStash: Case not found")
        return false
    end

    OpenStash(
        source,
        "case-" .. caseId,
        L("BACKEND.POLICE.EVIDENCE_LABEL", { id = caseId })
    )
end, {
    permissions = {
        { "stash", "view" }
    }
})

registerPoliceCallback("finePlayer", function(source, officerIdentifier, targetIdentifier, amount, reason, relatedCase)
    if not BillPlayer then
        infoprint("warning", "The BillPlayer function is not defined. Please set it up to work with your billing script.")
        return false
    end

    if not targetIdentifier or not amount or amount < 0 or not reason then
        debugprint("Invalid fine data", targetIdentifier, amount, reason, relatedCase)
        return false
    end

    if targetIdentifier == officerIdentifier then
        if Config.Debug then
            infoprint("warning", "Normally you cannot fine yourself, but this is allowed in debug mode.")
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

    local success = BillPlayer(officerIdentifier, targetIdentifier, "police", amount, reason)
    if not success then
        debugprint("Failed to bill player", targetIdentifier, amount, reason)
        return false
    end

    if relatedCase then
        MySQL.update.await(
            "UPDATE lbtablet_police_cases_criminals SET fined = 1 WHERE case_id = ? AND id = ?",
            { relatedCase, targetIdentifier }
        )
    end

    return true
end, {
    permissions = {
        { "case", "fine" }
    }
})

exports("GetPolicePlayerCharges", function(identifier)
    assert(type(identifier) == "string", "GetPoliceCharges: identifier must be a string")

    local rows = MySQL.query.await(
        "SELECT case_id, offence_id, charges FROM lbtablet_police_cases_charges WHERE criminal = ?",
        { identifier }
    ) or {}

    local charges = {}

    for i = 1, #rows do
        local offence = getOffenceById(rows[i].offence_id)
        if offence then
            charges[#charges + 1] = {
                caseId = rows[i].case_id,
                offence = offence,
                charges = rows[i].charges
            }
        end
    end

    return charges
end)

exports("CreatePoliceCase", function(source, data)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        debugprint("CreateCase: No tablet found")
        return false, "no_tablet"
    end

    data.id = nil
    return savePoliceCase(source, tabletId, data)
end)

exports("GetPoliceCase", getPoliceCaseById)

exports("UpdatePoliceCase", function(source, data)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        debugprint("UpdateCase: No tablet found")
        return false, "no_tablet"
    end

    if not data or not data.id then
        debugprint("UpdateCase: No ID provided")
        return false, "no_id"
    end

    return savePoliceCase(source, tabletId, data)
end)

exports("DeletePoliceCase", function(caseId)
    local deleted = MySQL.update.await(
        "DELETE FROM lbtablet_police_cases WHERE id = ?",
        { caseId }
    ) > 0

    if deleted then
        TriggerClientEvent("tablet:police:caseDeleted", -1, caseId)
    end

    return deleted
end)
-- ============================================
-- Part 4 - Accounts / Callsigns / Jail / Phone / Chat / Final handlers
-- Append this file after police_clean_part3.lua
-- ============================================

local policeAccountCreationLocks = {}

local function doesPoliceCallsignExist(callsign)
    local exists = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_police_accounts WHERE callsign = ?",
        { callsign }
    )

    return exists ~= nil
end

local function generateUniquePoliceCallsign()
    local pattern = Config.Police.Callsign.Format or "11-1111"
    local callsign = GenerateStringFromPattern(pattern)
    local attempts = 0

    while doesPoliceCallsignExist(callsign) do
        attempts = attempts + 1

        if attempts > 50 then
            infoprint(
                "error",
                "Failed to generate a unique callsign after 50 attempts. Consider changing Config.Police.Callsign.Format"
            )
        end

        callsign = GenerateStringFromPattern(pattern)
        Wait(0)
    end

    return callsign
end

local function isValidPoliceCallsign(callsign)
    if not Config.Police.Callsign.RequireTemplate then
        return true
    end

    local matchPattern = GetStringMatchPattern(Config.Police.Callsign.Format)
    return callsign:match(matchPattern) ~= nil
end

local function getOrCreatePoliceAccount(source, tabletId)
    local cachedAccount = policeAccounts[tabletId]
    local job = GetJob(source)

    if cachedAccount then
        cachedAccount.rank = job.grade_label
        return cachedAccount
    end

    local account = MySQL.single.await(
        "SELECT * FROM lbtablet_police_accounts WHERE id = ?",
        { tabletId }
    )

    if not account then
        if policeAccountCreationLocks[tabletId] then
            debugprint("Already generating police account for tabletId", tabletId)

            while policeAccountCreationLocks[tabletId] do
                Wait(0)
            end

            return policeAccounts[tabletId]
        end

        policeAccountCreationLocks[tabletId] = true

        local firstName, lastName = GetCharacterName(source)
        local callsign = nil

        if Config.Police.Callsign.AutoGenerate then
            callsign = generateUniquePoliceCallsign()
        end

        local columns = { "id", "display_name" }
        local values = {
            tabletId,
            (firstName or "") .. " " .. (lastName or "")
        }

        if callsign then
            columns[#columns + 1] = "callsign"
            values[#values + 1] = callsign
        end

        local placeholders = ("?, "):rep(#values):sub(1, -3)

        MySQL.update.await(
            ("INSERT INTO lbtablet_police_accounts (%s) VALUES (%s)"):format(table.concat(columns, ", "), placeholders),
            values
        )

        account = {
            id = tabletId,
            display_name = values[2],
            callsign = callsign
        }

        SetTimeout(1000, function()
            policeAccountCreationLocks[tabletId] = nil
        end)
    end

    local normalizedAccount = {
        id = account.id,
        name = account.display_name,
        avatar = account.avatar,
        callsign = account.callsign,
        rank = job.grade_label
    }

    policeAccounts[tabletId] = normalizedAccount
    return normalizedAccount
end

registerPoliceCallback("getLoggedIn", getOrCreatePoliceAccount)

registerPoliceCallback("updateOwnAccount", function(source, tabletId, callsign, avatar)
    local cachedAccount = policeAccounts[tabletId]

    if cachedAccount and cachedAccount.callsign ~= callsign then
        if not isValidPoliceCallsign(callsign) then
            debugprint("Invalid callsign")
            return false
        end
    end

    if cachedAccount and cachedAccount.callsign == callsign and cachedAccount.avatar == avatar then
        debugprint("no changes made, not updating account")
        return true
    end

    local updated = MySQL.update.await(
        "UPDATE lbtablet_police_accounts SET callsign = ?, avatar = ? WHERE id = ?",
        { callsign, avatar, tabletId }
    ) > 0

    if updated and policeAccounts[tabletId] then
        policeAccounts[tabletId].callsign = callsign
        policeAccounts[tabletId].avatar = avatar

        TriggerClientEvent("tablet:police:updateCallsign", -1, {
            source = source,
            identifier = tabletId,
            callsign = callsign
        })
    end

    return updated
end, {
    antiSpam = true
})

exports("SetPoliceCallsign", function(identifier, callsign, skipTemplateCheck)
    assert(type(identifier) == "string", "SetPoliceCallsign: identifier must be a string")
    assert(type(callsign) == "string", "SetPoliceCallsign: callsign must be a string")

    if not skipTemplateCheck and not isValidPoliceCallsign(callsign) then
        infoprint("warning", ("SetPoliceCallsign: Invalid callsign '%s'"):format(callsign))
        return false
    end

    MySQL.update(
        "UPDATE lbtablet_police_accounts SET callsign = ? WHERE id = ?",
        { callsign, identifier }
    )

    if policeAccounts[identifier] then
        policeAccounts[identifier].callsign = callsign

        TriggerClientEvent("tablet:police:updateCallsign", -1, {
            source = identifier,
            identifier = identifier,
            callsign = callsign
        })
    end

    return true
end)

registerPoliceCallback("getPrisoners", function(_, _, search, beforeId)
    if search == "" or type(search) ~= "string" then
        search = nil
    end

    local query = [[
        SELECT
            j.id,
            j.prisoner,
            j.jailed_by,
            j.reason,
            j.jail_time,
            j.jailed_at,
            j.related_case,
            j.original_time,
            {SELECT_NAME} AS `name`,
            a.display_name AS jailedBy,
            p.avatar
        FROM lbtablet_police_jail j
        LEFT JOIN lbtablet_police_profiles p ON p.id = j.prisoner
        LEFT JOIN lbtablet_police_accounts a ON a.id = j.jailed_by
        {JOIN_NAME}
        WHERE j.jail_time > 0 {WHERE}
        ORDER BY jailed_at DESC
        LIMIT 10
    ]]

    local params = {}

    if beforeId then
        params[#params + 1] = beforeId
    end

    local numericSearch = search and IsStringOnlyNumbers(search)

    if search then
        params[#params + 1] = ("%%%s%%"):format(search)
        params[#params + 1] = ("%%%s%%"):format(search)
        if numericSearch then
            params[#params + 1] = tostring(search)
        end
    end

    local whereClause = ""
    local searchClause = "(reason LIKE ? OR " .. Queries.Users.Select.name .. " LIKE ?)"
    if numericSearch then
        searchClause = "(reason LIKE ? OR " .. Queries.Users.Select.name .. " LIKE ? OR CAST(j.prisoner AS CHAR) = ?)"
    end

    if beforeId and search then
        whereClause = "AND j.id < ? AND " .. searchClause
    elseif beforeId then
        whereClause = "AND j.id < ?"
    elseif search then
        whereClause = "AND " .. searchClause
    end

    query = query:gsub("{WHERE}", whereClause)
    query = query:gsub("{SELECT_NAME}", Queries.Users.Select.name)
    query = query:gsub("{JOIN_NAME}", FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = j.prisoner",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate
        }
    ))

    local prisoners = MySQL.query.await(query, params) or {}

    for i = 1, #prisoners do
        local prisoner = prisoners[i]
        local remainingTime = prisoner.jail_time
        local relatedCase = nil

        if GetRemainingPrisonSentence then
            remainingTime = GetRemainingPrisonSentence(prisoner.prisoner) or remainingTime
        end

        if prisoner.related_case then
            local caseTitle = MySQL.scalar.await(
                "SELECT title FROM lbtablet_police_cases WHERE id = ?",
                { prisoner.related_case }
            )

            relatedCase = {
                id = prisoner.related_case,
                label = caseTitle
            }
        end

        prisoners[i] = {
            uniqueId = prisoner.id,
            id = prisoner.prisoner,
            avatar = prisoner.avatar,
            name = prisoner.name,
            description = prisoner.reason,
            jailedBy = prisoner.jailedBy or prisoner.jailed_by or "??",
            originalTime = prisoner.original_time,
            remainingTime = math.max(0, remainingTime),
            jailedAt = prisoner.jailed_at,
            releasedAt = (os.time() + remainingTime) * 1000,
            case = relatedCase
        }
    end

    return prisoners
end)

registerPoliceCallback("getPrisoner", function(_, _, identifier)
    local prisoner = GetJailed(identifier)
    if not prisoner then
        return false
    end

    prisoner.uniqueId = prisoner.id
    prisoner.id = prisoner.identifier

    return prisoner
end)

registerPoliceCallback("jailPlayer", function(source, officerIdentifier, targetIdentifier, jailMinutes, reason, relatedCase)
    local currentJailId = MySQL.scalar.await(
        "SELECT id FROM lbtablet_police_jail WHERE prisoner = ? AND jail_time > 0",
        { targetIdentifier }
    )

    if not Config.Police.Jail.AllowJailJailed and currentJailId then
        debugprint("Player is already jailed")
        return false
    end

    if officerIdentifier == targetIdentifier then
        if Config.Debug then
            infoprint("warning", "Normally you cannot jail yourself, but this is allowed in debug mode.")
        else
            SendNotification({
                source = source,
                app = "Police",
                title = L("BACKEND.POLICE.CANT_JAIL_YOURSELF_NOTIFICATION.TITLE"),
                content = L("BACKEND.POLICE.CANT_JAIL_YOURSELF_NOTIFICATION.CONTENT")
            })
            return false
        end
    end

    local jailTimeSeconds = math.floor(jailMinutes * 60)

    if not JailPlayer then
        infoprint("warning", "JailPlayer function is not available, please set up your jail script!")
        return false
    end

    if not JailPlayer(targetIdentifier, jailTimeSeconds, reason, source) then
        debugprint("Failed to jail player")
        return false
    end

    if currentJailId then
        MySQL.update.await(
            "UPDATE lbtablet_police_jail SET jail_time = 0 WHERE id = ?",
            { currentJailId }
        )
    end

    local jailId = LogJailed(targetIdentifier, officerIdentifier, reason, jailTimeSeconds, relatedCase)
    if not jailId then
        return false
    end

    if relatedCase then
        MySQL.update.await(
            "UPDATE lbtablet_police_cases_criminals SET jailed = 1 WHERE case_id = ? AND id = ?",
            { relatedCase, targetIdentifier }
        )
    end

    return jailId
end, {
    permissions = {
        { "jail", "create" }
    }
})

registerPoliceCallback("updatePrisoner", function(_, _, prisonerIdentifier, reason, relatedCase)
    local jailId = MySQL.scalar.await(
        "SELECT id FROM lbtablet_police_jail WHERE prisoner = ? AND jail_time > 0",
        { prisonerIdentifier }
    )

    if not jailId then
        debugprint("Player is not jailed", prisonerIdentifier)
        return false
    end

    return MySQL.update.await(
        "UPDATE lbtablet_police_jail SET reason = ?, related_case = ? WHERE id = ?",
        { reason, relatedCase, jailId }
    ) > 0
end, {
    antiSpam = true,
    permissions = {
        { "jail", "edit" }
    }
})

registerPoliceCallback("unjailPlayer", function(_, _, prisonerIdentifier)
    if not UnjailPlayer then
        infoprint("warning", "UnjailPlayer function is not available, please set up your jail script!")
        return false
    end

    if not UnjailPlayer(prisonerIdentifier) then
        return false
    end

    MySQL.update.await(
        "UPDATE lbtablet_police_jail SET jail_time = 0 WHERE prisoner = ?",
        { prisonerIdentifier }
    )

    TriggerClientEvent("tablet:police:prisonerReleased", -1, prisonerIdentifier)
    return true
end, {
    permissions = {
        { "jail", "unjail" }
    }
})

function GetJailed(prisonerIdentifier)
    assert(type(prisonerIdentifier) == "string", "prisoner must be a string")

    local query = [[
        SELECT
            j.id,
            j.prisoner,
            j.jailed_by,
            j.reason,
            j.jail_time,
            j.jailed_at,
            j.related_case,
            j.original_time,
            {SELECT_NAME} AS `name`,
            a.display_name AS jailedBy,
            p.avatar
        FROM lbtablet_police_jail j
        LEFT JOIN lbtablet_police_profiles p ON p.id = j.prisoner
        LEFT JOIN lbtablet_police_accounts a ON a.id = j.jailed_by
        {JOIN_NAME}
        WHERE j.jail_time > 0 AND j.prisoner = ?
    ]]

    query = query:gsub("{SELECT_NAME}", Queries.Users.Select.name)
    query = query:gsub("{JOIN_NAME}", FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER} {USERS_COLLATE} = j.prisoner",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate
        }
    ))

    local row = MySQL.single.await(query, { prisonerIdentifier })
    if not row then
        return false
    end

    if GetRemainingPrisonSentence then
        row.jail_time = GetRemainingPrisonSentence(row.prisoner) or row.jail_time
    end

    local relatedCase = nil
    if row.related_case then
        local caseTitle = MySQL.scalar.await(
            "SELECT title FROM lbtablet_police_cases WHERE id = ?",
            { row.related_case }
        )

        relatedCase = {
            id = row.related_case,
            label = caseTitle
        }
    end

    return {
        id = row.id,
        identifier = row.prisoner,
        avatar = row.avatar,
        name = row.name,
        description = row.reason,
        jailedBy = row.jailedBy or row.jailed_by or "??",
        originalTime = row.original_time,
        remainingTime = math.max(0, row.jail_time),
        jailedAt = row.jailed_at,
        releasedAt = (os.time() + row.jail_time) * 1000,
        case = relatedCase
    }
end

exports("GetJailed", GetJailed)

function LogJailed(prisonerIdentifier, jailedBy, reason, jailTime, relatedCase)
    assert(type(prisonerIdentifier) == "string", "prisoner must be a string")
    assert(type(reason) == "string", "reason must be a string")
    assert(type(jailTime) == "number", "jailTime must be a number")
    assert(jailTime > 0, "jailTime must be greater than 0")

    local alreadyJailed = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_police_jail WHERE prisoner = ? AND jail_time > 0",
        { prisonerIdentifier }
    )

    if alreadyJailed then
        infoprint("warning", prisonerIdentifier .. " is already jailed")
        return false
    end

    debugprint("LogJailed", prisonerIdentifier, jailedBy, reason, jailTime, relatedCase)

    local columns = { "prisoner", "jailed_by", "reason", "jail_time", "original_time" }
    local values = { prisonerIdentifier, jailedBy, reason, jailTime, jailTime }

    if relatedCase then
        assert(type(relatedCase) == "number", "relatedCase must be a number")

        local caseExists = MySQL.scalar.await(
            "SELECT 1 FROM lbtablet_police_cases WHERE id = ?",
            { relatedCase }
        )

        if not caseExists then
            error("Invalid relatedCase: case does not exist")
        end

        columns[#columns + 1] = "related_case"
        values[#values + 1] = relatedCase
    end

    local placeholders = ("?, "):rep(#values):sub(1, -3)

    local jailId = MySQL.insert.await(
        ("INSERT INTO lbtablet_police_jail (%s) VALUES (%s)"):format(table.concat(columns, ", "), placeholders),
        values
    )

    if not jailId then
        return false
    end

    local prisoner = GetJailed(prisonerIdentifier)
    if prisoner then
        TriggerClientEvent("tablet:police:newPrisoner", -1, prisoner)
    end

    return jailId
end

exports("LogJailed", LogJailed)

function UpdateJailSentence(prisonerIdentifier, jailTime)
    assert(type(prisonerIdentifier) == "string", "prisoner must be a string")
    assert(type(jailTime) == "number", "jailTime must be a number")

    local jailId = MySQL.scalar.await(
        "SELECT id FROM lbtablet_police_jail WHERE prisoner = ? AND jail_time > 0",
        { prisonerIdentifier }
    )

    if not jailId then
        return false
    end

    local updated = MySQL.update.await(
        "UPDATE lbtablet_police_jail SET jail_time = ? WHERE id = ?",
        { math.max(0, jailTime), jailId }
    ) > 0

    if updated and jailTime == 0 then
        TriggerClientEvent("tablet:police:prisonerReleased", -1, prisonerIdentifier)
    end

    return updated
end

exports("UpdateJailSentence", UpdateJailSentence)

registerPoliceCallback("triangulate", function(_, _, phoneNumber)
    if not Config.LBPhone then
        debugprint("LBPhone is not enabled")
        return false
    end

    if not Config.Police.Triangulation then
        debugprint("Phone triangulation is not configured")
        return false
    end

    local targetSource = exports["lb-phone"]:GetSourceFromNumber(phoneNumber)
    if not targetSource then
        debugprint("Source not found from phone number", phoneNumber)
        return false
    end

    if exports["lb-phone"]:HasAirplaneMode(phoneNumber) then
        debugprint("Phone is in airplane mode")
        return false
    end

    if math.random(100) > Config.Police.Triangulation.SuccessRate then
        debugprint("Triangulation failed (SuccessRate)")
        return false
    end

    if Config.Police.Triangulation.RequireCall and not exports["lb-phone"]:IsInCall(targetSource) then
        debugprint("Phone is not in a call")
        return false
    end

    local ped = GetPlayerPed(targetSource)
    if not ped or ped == 0 then
        debugprint("Player ped not found")
        return false
    end

    local coords = GetEntityCoords(ped)
    return {
        x = coords.x,
        y = coords.y,
        z = coords.z
    }
end, {
    permissions = {
        { "phone", "triangulate" }
    }
})

local function canUsePolicePhoneTools(source)
    if not HasPermission(source, "Police", "phone", "view") then
        debugprint("Player does not have permission to view phone tab")
        return false
    end

    if not HasPermission(source, "Police", "phone", "unlock") then
        debugprint("Player does not have permission to unlock phones")
        return false
    end

    if not Config.LBPhone then
        debugprint("LBPhone is not enabled")
        return false
    end

    if not Config.Police.PhoneUnlock then
        debugprint("Phone unlock is not configured")
        return false
    end

    if not GetPhones then
        infoprint("warning", "GetPhones function is not defined. Please set it up to work with your inventory script.")
        return false
    end

    if not HasPhone then
        infoprint("warning", "HasPhone function is not defined. Please set it up to work with your inventory script.")
        return false
    end

    return true
end

registerPoliceCallback("getPhones", function(source, _)
    if not canUsePolicePhoneTools(source) then
        return false
    end

    local phones = GetPhones(source)
    local result = {}

    if not phones or #phones == 0 then
        debugprint("No phones found for player")
        return result
    end

    local phoneNumbers = {}
    local knownPins = {}
    local unlockStates = {}

    for i = 1, #phones do
        phoneNumbers[i] = phones[i].phoneNumber
    end

    local pinRows = MySQL.query.await(
        "SELECT phone_number, pin FROM phone_phones WHERE phone_number IN (?)",
        { phoneNumbers }
    ) or {}

    for i = 1, #pinRows do
        knownPins[pinRows[i].phone_number] = pinRows[i].pin
    end

    local unlockRows = MySQL.query.await([[
        SELECT
            phone_number,
            finished_at,
            unlocked,
            attempts
        FROM lbtablet_police_phone_unlocks
        WHERE phone_number IN (?)
    ]], { phoneNumbers }) or {}

    for i = 1, #unlockRows do
        unlockStates[unlockRows[i].phone_number] = {
            finishedAt = unlockRows[i].finished_at or nil,
            unlocked = unlockRows[i].unlocked,
            attempts = unlockRows[i].attempts or 0
        }
    end

    for i = 1, #phones do
        local phone = phones[i]
        local state = unlockStates[phone.phoneNumber]

        if knownPins[phone.phoneNumber] then
            result[#result + 1] = {
                phoneNumber = phone.phoneNumber,
                phoneName = phone.phoneName,
                timeRemaining = state and state.finishedAt and math.max(0, math.floor(state.finishedAt / 1000) - os.time()) or nil,
                unlocked = state and state.unlocked or false,
                attempts = state and state.attempts or 0
            }
        end
    end

    return result
end)

registerPoliceCallback("unlockPhone", function(source, _, phoneNumber)
    if not canUsePolicePhoneTools(source) then
        return false
    end

    if not HasPhone(source, phoneNumber) then
        debugprint("Player does not have the phone", phoneNumber)
        return false
    end

    local unlockState = MySQL.single.await(
        "SELECT finished_at > NOW() AS processing, unlocked, attempts FROM lbtablet_police_phone_unlocks WHERE phone_number = ?",
        { phoneNumber }
    )

    if unlockState then
        if unlockState.processing == true or unlockState.processing == 1 then
            debugprint("Phone is already being unlocked")
            return false
        end

        if unlockState.unlocked == true or unlockState.unlocked == 1 then
            debugprint("Phone is already unlocked")
            return false
        end

        if unlockState.attempts >= Config.Police.PhoneUnlock.Attempts then
            debugprint("Phone unlock attempts exceeded")
            return false
        end
    end

    local durationMinutes = math.random(
        Config.Police.PhoneUnlock.Time[1],
        Config.Police.PhoneUnlock.Time[2]
    )

    local unlocked = math.random(100) < Config.Police.PhoneUnlock.Chance

    MySQL.insert.await([[
        INSERT INTO lbtablet_police_phone_unlocks (phone_number, finished_at, unlocked, attempts)
            VALUES (?, NOW() + INTERVAL ? MINUTE, ?, 1)
        ON DUPLICATE KEY UPDATE
            finished_at = VALUES(finished_at), unlocked = VALUES(unlocked), attempts = attempts + 1
    ]], { phoneNumber, durationMinutes, unlocked })

    return {
        timeRemaining = durationMinutes,
        unlocked = unlocked
    }
end)

registerPoliceCallback("resetPin", function(source, _, phoneNumber)
    if not canUsePolicePhoneTools(source) then
        return false
    end

    if not HasPhone(source, phoneNumber) then
        debugprint("Player does not have the phone", phoneNumber)
        return false
    end

    local unlocked = MySQL.scalar.await(
        "SELECT unlocked FROM lbtablet_police_phone_unlocks WHERE phone_number = ? AND finished_at < NOW()",
        { phoneNumber }
    )

    if not unlocked or unlocked == 0 then
        debugprint("Phone is not unlocked or is being unlocked")
        return false
    end

    exports["lb-phone"]:ResetSecurity(phoneNumber)
    return true
end)

registerPoliceCallback("wiretapNumber", function(source, tabletId, phoneNumber)
    if not Config.LBPhone then
        debugprint("LBPhone is not enabled")
        return false
    end

    if not Config.Police.Wiretapping then
        debugprint("Wiretapping is not configured")
        return false
    end

    if IsPhoneNumberWiretapped(phoneNumber) then
        debugprint("Phone number is already wiretapped")
        return true
    end

    local exists = MySQL.scalar.await(
        "SELECT 1 FROM phone_phones WHERE phone_number = ?",
        { phoneNumber }
    )

    if not exists then
        debugprint("Phone number does not exist", phoneNumber)
        return false
    end

    if CanWiretapNumber and not CanWiretapNumber(source, phoneNumber) then
        debugprint("Player does not have permission to wiretap this number (CanWiretapNumber returned false)")
        return false
    end

    AddWiretap(phoneNumber)

    MySQL.update.await(
        "INSERT IGNORE INTO lbtablet_police_wiretaps (phone_number, creator_tablet_id) VALUES (?, ?)",
        { phoneNumber, tabletId }
    )

    local phoneName = MySQL.scalar.await(
        "SELECT `name` FROM phone_phones WHERE phone_number = ?",
        { phoneNumber }
    )

    return {
        phoneName = phoneName
    }
end, {
    permissions = {
        { "phone", "createWiretap" }
    }
})

registerPoliceCallback("removeWiretap", function(source, tabletId, phoneNumber)
    local creatorTabletId = MySQL.scalar.await(
        "SELECT creator_tablet_id FROM lbtablet_police_wiretaps WHERE phone_number = ?",
        { phoneNumber }
    )

    if not creatorTabletId then
        debugprint("Phone number is not wiretapped", phoneNumber)
        return false
    end

    if creatorTabletId ~= tabletId and not HasPermission(source, "Police", "phone", "removeWiretap") then
        debugprint("Player does not have permission to remove wiretap")
        return false
    end

    RemoveWiretap(phoneNumber)

    MySQL.update.await(
        "DELETE FROM lbtablet_police_wiretaps WHERE phone_number = ?",
        { phoneNumber }
    )

    return true
end)

registerPoliceCallback("toggleSubscribeWiretap", function(_, tabletId, phoneNumber, enabled)
    if not Config.LBPhone then
        debugprint("LBPhone is not enabled")
        return false
    end

    if not Config.Police.Wiretapping then
        debugprint("Wiretapping is not configured")
        return false
    end

    if not IsPhoneNumberWiretapped(phoneNumber) then
        debugprint("Phone number is not wiretapped", phoneNumber)
        return false
    end

    if enabled then
        MySQL.update.await(
            "INSERT IGNORE INTO lbtablet_police_wiretaps_subscribers (tablet_id, phone_number) VALUES (?, ?)",
            { tabletId, phoneNumber }
        )
    else
        MySQL.update.await(
            "DELETE FROM lbtablet_police_wiretaps_subscribers WHERE tablet_id = ? AND phone_number = ?",
            { tabletId, phoneNumber }
        )
    end

    return true
end, {
    permissions = {
        { "phone", "listenWiretap" }
    }
})

registerPoliceCallback("getWiretaps", function(_, tabletId, page, search, filters)
    page = page or 0

    local params = { tabletId }
    local whereParts = {}

    if search and search ~= "" then
        whereParts[#whereParts + 1] = "wiretap.phone_number LIKE ?"
        params[#params + 1] = ("%%%s%%"):format(search)
    end

    if filters and filters.subscribed then
        whereParts[#whereParts + 1] = "subscribed.tablet_id = ?"
        params[#params + 1] = tabletId
    end

    if filters and filters.createdByMe then
        whereParts[#whereParts + 1] = "wiretap.creator_tablet_id = ?"
        params[#params + 1] = tabletId
    end

    local whereClause = #whereParts > 0 and ("WHERE " .. table.concat(whereParts, " AND ")) or ""

    params[#params + 1] = page * 25
    params[#params + 1] = 25

    local wiretaps = MySQL.query.await(([[]
        SELECT
            wiretap.phone_number AS phoneNumber,
            phone.`name` AS phoneName,
            subscribed.tablet_id IS NOT NULL AS subscribed,
            wiretap.created_at AS createdAt,
            wiretap.creator_tablet_id AS createdBy,
            account.display_name AS author
        FROM lbtablet_police_wiretaps wiretap
        LEFT JOIN phone_phones phone ON phone.phone_number = wiretap.phone_number
        LEFT JOIN lbtablet_police_accounts account ON account.id = wiretap.creator_tablet_id
        LEFT JOIN lbtablet_police_wiretaps_subscribers subscribed
            ON subscribed.tablet_id = ?
            AND subscribed.phone_number = wiretap.phone_number
        %s
        ORDER BY wiretap.created_at DESC
        LIMIT ?, ?
    ]]):format(whereClause), params) or {}

    for i = 1, #wiretaps do
        local wiretap = wiretaps[i]
        local callId = GetWiretappedPhoneNumberCall(wiretap.phoneNumber)

        if callId then
            local call = exports["lb-phone"]:GetCall(callId)
            if call then
                local inCallWith = nil

                if call.caller.number == wiretap.phoneNumber then
                    inCallWith = call.callee.number or call.company
                else
                    inCallWith = call.caller.number
                end

                wiretap.inCall = {
                    inCallWith = inCallWith,
                    duration = os.time() - call.started
                }
            end
        end
    end

    return wiretaps
end, {
    permissions = {
        { "phone", "callHistory" }
    }
})

registerPoliceCallback("getCallHistory", function(_, _, phoneNumber, page, search)
    if not Config.LBPhone then
        debugprint("LBPhone is not enabled")
        return false
    end

    if not IsPhoneNumberWiretapped(phoneNumber) then
        debugprint("Phone number is not wiretapped", phoneNumber)
        return false
    end

    page = page or 0

    local createdAt = MySQL.scalar.await(
        "SELECT created_at FROM lbtablet_police_wiretaps WHERE phone_number = ?",
        { phoneNumber }
    )

    if not createdAt then
        debugprint("Wiretap created date not found for phone number", phoneNumber)
        return false
    end

    local params = {
        phoneNumber,
        phoneNumber,
        math.floor(createdAt / 1000)
    }

    local whereClause = "(caller = ? OR callee = ?) AND UNIX_TIMESTAMP(`timestamp`) >= ?"

    if search and search ~= "" then
        whereClause = whereClause .. " AND (caller LIKE ? OR callee LIKE ?)"
        params[#params + 1] = ("%%%s%%"):format(search)
        params[#params + 1] = ("%%%s%%"):format(search)
    end

    params[#params + 1] = page * 25
    params[#params + 1] = 25

    return MySQL.query.await(([[]
        SELECT
            caller,
            callee,
            duration,
            answered,
            hide_caller_id AS hideCallerId,
            `timestamp`
        FROM phone_phone_calls
        WHERE %s
        ORDER BY id DESC
        LIMIT ?, ?
    ]]):format(whereClause), params)
end, {
    permissions = {
        { "phone", "callHistory" }
    }
})

registerPoliceCallback("listenToWiretap", function(source, _, phoneNumber)
    return ListenToWiretappedCall(source, phoneNumber)
end, {
    permissions = {
        { "phone", "listenWiretap" }
    }
})

registerPoliceCallback("stopListeningToWiretap", function(source)
    StopListeningToWiretappedCall(source)
    return true
end)

registerPoliceCallback("getUnreadChats", function(_, tabletId)
    return GetUndreadChatNotifications("police", tabletId)
end)

registerPoliceCallback("getPublicChatRooms", function(_, tabletId, page, search)
    return GetPublicChatRooms("police", tabletId, page, search)
end)

registerPoliceCallback("getChatRooms", function(_, tabletId, page, search)
    return GetChatRooms("police", tabletId, page, search)
end)

registerPoliceCallback("createChat", function(_, tabletId, label, isPrivate)
    local roomId = CreateChatRoom("police", tabletId, label, isPrivate)

    if not isPrivate and Config.Police.Notifications.NewChat then
        notifyPoliceTablets({
            title = L("BACKEND.POLICE.NEW_CHAT_CHANNEL_NOTIFICATION.TITLE"),
            content = L("BACKEND.POLICE.NEW_CHAT_CHANNEL_NOTIFICATION.CONTENT", {
                channel = label
            })
        }, { tabletId })
    end

    return roomId
end, {
    antiSpam = true,
    permissions = {
        { "chat", "create" }
    }
})

registerPoliceCallback("toggleChatPrivate", function(source, tabletId, roomId, isPrivate)
    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= tabletId and not HasPermission(source, "Police", "chat", "edit") then
        return false
    end

    return ToggleChatRoomPrivate(roomId, isPrivate == true)
end)

registerPoliceCallback("setChatIcon", function(source, tabletId, roomId, icon)
    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= tabletId and not HasPermission(source, "Police", "chat", "edit") then
        return false
    end

    return SetChatRoomIcon(roomId, icon)
end)

registerPoliceCallback("getChatMembers", function(_, _, roomId)
    return GetChatRoomMembers("police", roomId)
end)

registerPoliceCallback("inviteToChat", function(source, tabletId, roomId, memberTabletId)
    if memberTabletId == tabletId then
        debugprint("Can't invite self to chat")
        return false
    end

    local isMember = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_chat_rooms_members WHERE room_id = ? AND account = ?",
        { roomId, tabletId }
    )

    if not isMember then
        debugprint("User not in chat")
        return false
    end

    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= tabletId and not HasPermission(source, "Police", "chat", "invite") then
        return false
    end

    return AddToChatRoom("police", roomId, memberTabletId)
end)

registerPoliceCallback("kickFromChat", function(source, tabletId, roomId, memberTabletId)
    if memberTabletId == tabletId then
        debugprint("Can't kick self from chat")
        return false
    end

    local creator = MySQL.scalar.await(
        "SELECT creator FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if creator ~= tabletId and not HasPermission(source, "Police", "chat", "kick") then
        return false
    end

    return RemoveMemberFromChatRoom(roomId, memberTabletId)
end)

registerPoliceCallback("joinChat", function(_, tabletId, roomId)
    local isPrivate = MySQL.scalar.await(
        "SELECT private FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if isPrivate then
        return false
    end

    return MySQL.update.await(
        "INSERT INTO lbtablet_chat_rooms_members (room_id, account) VALUES (?, ?) ON DUPLICATE KEY UPDATE account = ?",
        { roomId, tabletId, tabletId }
    ) > 0
end)

registerPoliceCallback("leaveChat", function(_, tabletId, roomId)
    return LeaveChatRoom(tabletId, roomId)
end)

registerPoliceCallback("getChatMessages", function(_, _, roomId, page)
    return GetChatMessages("police", roomId, page)
end)

registerPoliceCallback("sendMessage", function(_, tabletId, roomId, message, attachments)
    local sent = SendChatMessage({
        id = tabletId,
        name = policeAccounts[tabletId] and policeAccounts[tabletId].name or "",
        avatar = policeAccounts[tabletId] and policeAccounts[tabletId].avatar or nil
    }, roomId, message, attachments)

    if not sent then
        return false
    end

    if Config.Police.Notifications.ChatMessage then
        local room = MySQL.single.await(
            "SELECT label, private FROM lbtablet_chat_rooms WHERE id = ?",
            { roomId }
        )

        if room then
            local notification = {
                title = L("BACKEND.POLICE.CHAT_MESSAGE_NOTIFICATION.TITLE", {
                    channel = room.label or ""
                }),
                content = L("BACKEND.POLICE.CHAT_MESSAGE_NOTIFICATION.CONTENT", {
                    message = message or "attachment"
                }),
                app = "Police"
            }

            if not room.private then
                notifyPoliceTablets(notification, { tabletId })
            else
                local memberRows = MySQL.query.await(
                    "SELECT account FROM lbtablet_chat_rooms_members WHERE room_id = ? AND account != ?",
                    { roomId, tabletId }
                ) or {}

                local members = {}
                for i = 1, #memberRows do
                    members[#members + 1] = memberRows[i].account
                end

                NotifyTablets(members, notification, { tabletId })
            end
        end
    end

    return sent
end, {
    antiSpam = true
})

registerPoliceCallback("clearChatNotifications", function(_, tabletId, roomId)
    return MySQL.update.await(
        "UPDATE lbtablet_chat_rooms_members SET notifications = 0 WHERE room_id = ? AND account = ?",
        { roomId, tabletId }
    ) > 0
end)

AddEventHandler("lb-tablet:jobUpdated", function(source, jobName)
    local tabletId = GetEquippedTablet(source)
    if not tabletId then
        return
    end

    if Config.Police.Permissions[jobName] then
        getOrCreatePoliceAccount(source, tabletId)
    else
        policeAccounts[tabletId] = nil
    end
end)

OnTabletDisconnect(function(tabletId, source)
    if policeAccounts[tabletId] then
        policeAccounts[tabletId] = nil
        debugprint("Removed police user from cache", tabletId, source)
    end
end)
