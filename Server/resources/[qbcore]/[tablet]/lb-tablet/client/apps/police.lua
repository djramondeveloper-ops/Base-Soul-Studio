local function hasPoliceAccess()
    if not FrameworkLoaded then
        return false
    end

    local jobName = GetJob()
    return Config.Police.Permissions[jobName] ~= nil
end

IsPolice = hasPoliceAccess

local function getChatMessages(chatId, lastMessageId)
    local messages = AwaitCallback("police:getChatMessages", chatId, lastMessageId)
    local formattedMessages = {}

    for index = 1, #messages do
        local message = messages[index]
        local attachments = nil

        if message.attachments then
            attachments = json.decode(message.attachments)
        end

        formattedMessages[index] = {
            id = message.id,
            content = message.message,
            attachments = attachments,
            timestamp = message.sent_at,
            sender = {
                id = message.author,
                name = message.display_name or "",
                avatar = message.avatar
            }
        }
    end

    return formattedMessages
end

local function searchProfiles(query, filter, page)
    local profiles = AwaitCallback("police:searchUsers", query, filter, page)

    for index = 1, #profiles do
        profiles[index].isMale = profiles[index].isMale == 1
    end

    return profiles
end

local function fetchProfile(profileId)
    local profile = AwaitCallback("police:fetchUser", profileId)

    if profile then
        profile.isMale = profile.isMale == 1

        for index = 1, #profile.vehicles do
            FormatVehicle(profile.vehicles[index])
        end
    end

    return profile
end

local function searchVehicles(query, filter, page)
    local vehicles = AwaitCallback("police:searchVehicles", query, filter, page) or {}

    for index = 1, #vehicles do
        FormatVehicle(vehicles[index])
    end

    debugprint("Got vehicles: ", vehicles)
    return vehicles
end

local function fetchVehicle(plate)
    local vehicle = AwaitCallback("police:fetchVehicle", plate)

    if vehicle then
        FormatVehicle(vehicle)
    end

    debugprint("Got vehicle: ", vehicle)
    return vehicle
end

local function getCase(caseId)
    local caseData = AwaitCallback("police:getCase", caseId)
    if not caseData then
        return false
    end

    local evidence = {}
    for index = 1, #caseData.evidence do
        evidence[index] = caseData.evidence[index].attachment
    end
    caseData.evidence = evidence

    local vehicleModelsByPlate = {}
    for index = 1, #caseData.vehicleModels do
        local vehicleModel = caseData.vehicleModels[index]
        vehicleModelsByPlate[vehicleModel.plate] = tonumber(vehicleModel.model)
    end

    local officersInvolved = {}
    local vehiclesInvolved = {}
    local civiliansInvolved = {}

    for index = 1, #caseData.involved do
        local involvedEntry = caseData.involved[index]

        if involvedEntry.involvement == "vehicle" then
            involvedEntry.model = GetVehicleLabel(vehicleModelsByPlate[involvedEntry.involved])
            involvedEntry.plate = involvedEntry.involved
            involvedEntry.involved = nil
            vehiclesInvolved[#vehiclesInvolved + 1] = involvedEntry
        elseif involvedEntry.involvement == "officer" then
            involvedEntry.id = involvedEntry.involved
            involvedEntry.involved = nil
            officersInvolved[#officersInvolved + 1] = involvedEntry
        elseif involvedEntry.involvement == "civilian" then
            involvedEntry.id = involvedEntry.involved
            involvedEntry.involved = nil
            civiliansInvolved[#civiliansInvolved + 1] = involvedEntry
        end
    end

    caseData.involved = {}
    caseData.officersInvolved = officersInvolved
    caseData.vehiclesInvolved = vehiclesInvolved
    caseData.civiliansInvolved = civiliansInvolved

    return caseData
end

local function getReport(reportId)
    local report = AwaitCallback("police:getReport", reportId)
    if not report then
        return false
    end

    report.officersInvolved = {}
    report.civiliansInvolved = {}
    report.suspectsInvolved = {}

    for index = 1, #report.involved do
        local involvedEntry = report.involved[index]
        local mappedEntry = {
            id = involvedEntry.involved,
            name = involvedEntry.name
        }

        if involvedEntry.involvement == "officer" then
            report.officersInvolved[#report.officersInvolved + 1] = mappedEntry
        elseif involvedEntry.involvement == "civilian" then
            report.civiliansInvolved[#report.civiliansInvolved + 1] = mappedEntry
        elseif involvedEntry.involvement == "suspect" then
            report.suspectsInvolved[#report.suspectsInvolved + 1] = mappedEntry
        end
    end

    local gallery = {}
    for index = 1, #report.gallery do
        gallery[#gallery + 1] = report.gallery[index].attachment
    end

    report.involved = nil
    report.gallery = gallery

    return report
end

local function getWarrant(warrantId)
    local warrant = AwaitCallback("police:getWarrant", warrantId)
    if not warrant then
        return false
    end

    if warrant.target and warrant.target.type == "vehicle" then
        local vehicle = FormatVehicle(warrant.target.vehicle)
        warrant.target.name = vehicle.model
        warrant.target.color = vehicle.color
        warrant.target.vehicle = nil
    end

    return warrant
end

local function getPolicePermissions()
    local permissions = GetPermissions("Police")
    if not permissions then
        return false
    end

    -- Phone unlocking only works with unique phone items.
    if Config.LBPhone and permissions.phone and permissions.phone.unlock then
        local phoneConfig = GetPhoneConfig()
        local isUniquePhoneItem = phoneConfig and phoneConfig.Item and phoneConfig.Item.Unique

        if not isUniquePhoneItem then
            permissions.phone.unlock = false
            debugprint("Unlock phone permission is disabled for police because phone item is not unique")
        end
    end

    return permissions
end

local function extractCaseId(caseData)
    if type(caseData) == "table" and caseData.id then
        return caseData.id
    end

    return nil
end

local policeActions = {
    getPermissions = function()
        return getPolicePermissions()
    end,

    getActiveUnits = function()
        return AwaitCallback("police:getActiveUnits")
    end,

    getLogs = function(data)
        if data.query == "" then
            data.query = nil
        end

        return AwaitCallback("police:getLogs", data.query, data.lastId)
    end,

    getUnits = function()
        return AwaitCallback("police:getUnits")
    end,

    addUnit = function(data)
        return AwaitCallback("police:addUnit", data.name)
    end,

    deleteUnit = function(data)
        return AwaitCallback("police:deleteUnit", data.unit)
    end,

    updateUnitStatus = function(data)
        return AwaitCallback("police:updateUnitStatus", data.unit, data.status)
    end,

    renameUnit = function(data)
        return AwaitCallback("police:renameUnit", data.unit, data.name)
    end,

    assignOfficerToUnit = function(data)
        return AwaitCallback("police:assignOfficerToUnit", data.unit, data.officerId)
    end,

    removeOfficerFromUnit = function(data)
        return AwaitCallback("police:removeOfficerFromUnit", data.officerId)
    end,

    getOffences = function()
        return AwaitCallback("police:getOffences")
    end,

    addOffenceCategory = function(data)
        return AwaitCallback("police:addOffenceCategory", data.category)
    end,

    updateOffenceCategory = function(data)
        return AwaitCallback("police:updateOffenceCategory", data.oldCategory, data.newCategory)
    end,

    deleteOffenceCategory = function(data)
        return AwaitCallback("police:deleteOffenceCategory", data.category)
    end,

    addOffence = function(data)
        return AwaitCallback("police:addOffence", data.category, data.data)
    end,

    updateOffence = function(data)
        return AwaitCallback("police:updateOffence", data.id, data.data)
    end,

    deleteOffence = function(data)
        return AwaitCallback("police:deleteOffence", data.id)
    end,

    getTags = function()
        return AwaitCallback("police:getTags")
    end,

    createTag = function(data)
        return AwaitCallback("police:createTag", data.tag, data.color, data.type)
    end,

    deleteTag = function(data)
        return AwaitCallback("police:deleteTag", data.id)
    end,

    addTag = function(data)
        return AwaitCallback("police:addTag", data.id, data.tag)
    end,

    removeTag = function(data)
        return AwaitCallback("police:removeTag", data.id, data.tag)
    end,

    searchProfiles = function(data)
        return searchProfiles(data.query, data.filter, data.page)
    end,

    fetchProfile = function(data)
        return fetchProfile(data.id)
    end,

    updateProfile = function(data)
        return AwaitCallback("police:updateProfile", data)
    end,

    revokeLicense = function(data)
        return AwaitCallback("police:revokeLicense", data.id, data.license)
    end,

    addLicense = function(data)
        return AwaitCallback("police:addLicense", data.id, data.license)
    end,

    getAllLicenses = function()
        return AwaitCallback("police:getAllLicenses")
    end,

    searchProperties = function(data)
        return AwaitCallback("police:searchProperties", data.query, data.filter, data.page)
    end,

    fetchProperty = function(data)
        local property = AwaitCallback("police:getProperty", data.id)

        if property then
            property.picture = property.avatar
            property.avatar = nil
        end

        return property
    end,

    updateProperty = function(data)
        data.data.type = "property"
        return AwaitCallback("police:updateProfile", data.data)
    end,

    searchWeapons = function(data)
        return AwaitCallback("police:searchWeapons", data.query, data.filter, data.page)
    end,

    fetchWeapon = function(data)
        return AwaitCallback("police:fetchWeapon", data.id)
    end,

    getWeapons = function()
        return GetWeaponsList()
    end,

    registerWeapon = function(data)
        data.data.type = "weapon"
        data.data.id = "weapon:" .. data.data.serialNumber

        local created = AwaitCallback("police:registerWeapon", data.data)
        if not created then
            return false
        end

        AwaitCallback("police:updateProfile", data.data)
        return true
    end,

    deleteWeapon = function(data)
        return AwaitCallback("police:deleteWeapon", data.id)
    end,

    updateWeapon = function(data)
        data.data.type = "weapon"
        return AwaitCallback("police:updateProfile", data.data)
    end,

    searchVehicles = function(data)
        return searchVehicles(data.query, data.filter, data.page)
    end,

    fetchVehicle = function(data)
        return fetchVehicle(data.plate)
    end,

    getEmployees = function()
        return AwaitCallback("police:getEmployees")
    end,

    getUser = function(data)
        return AwaitCallback("police:getLoggedIn", data)
    end,

    updateUser = function(data)
        return AwaitCallback("police:updateOwnAccount", data.callsign, data.avatar)
    end,

    saveReport = function(data)
        return AwaitCallback("police:saveReport", data)
    end,

    getReports = function(data)
        return AwaitCallback("police:getReports", data.page, data.query, data.filter)
    end,

    getReport = function(data)
        return getReport(data.id)
    end,

    deleteReport = function(data)
        return AwaitCallback("police:deleteReport", data.id)
    end,

    saveCase = function(data)
        return AwaitCallback("police:saveCase", data)
    end,

    getCases = function(data)
        return AwaitCallback("police:getCases", data.page, data.query, data.filter)
    end,

    getCase = function(data)
        return getCase(data.id)
    end,

    deleteCase = function(data)
        return AwaitCallback("police:deleteCase", data.id)
    end,

    openStash = function(data)
        if Config.EvidenceStash then
            return AwaitCallback("police:openStash", data.id)
        end
    end,

    finePlayer = function(data)
        return AwaitCallback("police:finePlayer", data.id, data.fine, data.label, data.caseId)
    end,

    saveWarrant = function(data)
        return AwaitCallback("police:saveWarrant", data.data)
    end,

    getWarrants = function(data)
        return AwaitCallback("police:getWarrants", data.page, data.query, data.filter)
    end,

    getWarrant = function(data)
        return getWarrant(data.id)
    end,

    deleteWarrant = function(data)
        return AwaitCallback("police:deleteWarrant", data.id)
    end,

    getBulletinBoard = function(data)
        return AwaitCallback("police:getBulletinBoard", data.page, data.query)
    end,

    saveBulletin = function(data)
        return AwaitCallback("police:saveBulletin", data.id, data.title, data.content)
    end,

    toggleBulletinPinned = function(data)
        return AwaitCallback("police:toggleBulletinPinned", data.id, data.pinned)
    end,

    deleteBulletin = function(data)
        return AwaitCallback("police:deleteBulletin", data.id)
    end,

    getJailees = function(data)
        return AwaitCallback("police:getPrisoners", data.query, data.lastId)
    end,

    jailPlayer = function(data)
        return AwaitCallback(
            "police:jailPlayer",
            data.id,
            data.sentence,
            data.description,
            extractCaseId(data.case)
        )
    end,

    unjail = function(data)
        return AwaitCallback("police:unjailPlayer", data.id) or false
    end,

    getJailee = function(data)
        return AwaitCallback("police:getPrisoner", data.id)
    end,

    updateJailee = function(data)
        return AwaitCallback(
            "police:updatePrisoner",
            data.id,
            data.description,
            extractCaseId(data.case)
        )
    end,

    getUnreadChats = function()
        return AwaitCallback("police:getUnreadChats")
    end,

    getChatRooms = function(data)
        return AwaitCallback("police:getChatRooms", data.page, data.query)
    end,

    getPublicChatRooms = function(data)
        return AwaitCallback("police:getPublicChatRooms", data.page, data.query)
    end,

    createChat = function(data)
        return AwaitCallback("police:createChat", data.name, data.private)
    end,

    togglePrivate = function(data)
        return AwaitCallback("police:toggleChatPrivate", data.id, data.toggle)
    end,

    setChatRoomAvatar = function(data)
        return AwaitCallback("police:setChatIcon", data.id, data.avatar)
    end,

    getChatMembers = function(data)
        return AwaitCallback("police:getChatMembers", data.id)
    end,

    inviteToChat = function(data)
        return AwaitCallback("police:inviteToChat", data.id, data.user)
    end,

    kickFromChat = function(data)
        return AwaitCallback("police:kickFromChat", data.id, data.user)
    end,

    getMessages = function(data)
        return getChatMessages(data.id, data.lastId)
    end,

    sendMessage = function(data)
        return AwaitCallback("police:sendMessage", data.id, data.content, data.attachments)
    end,

    leaveChat = function(data)
        return AwaitCallback("police:leaveChat", data.id)
    end,

    joinChat = function(data)
        return AwaitCallback("police:joinChat", data.id)
    end,

    clearChatNotifications = function(data)
        return AwaitCallback("police:clearChatNotifications", data.id)
    end,

    getServiceConfig = function()
        local towers = GetCellTowers()
        local cellTowers = {}

        for index = 1, #towers do
            cellTowers[index] = {
                x = towers[index].x,
                y = towers[index].y,
                z = towers[index].z
            }
        end

        local phoneConfig = GetPhoneConfig()
        return {
            rangeData = phoneConfig.CellTowers.Range,
            cellTowers = cellTowers
        }
    end,

    triangulate = function(data)
        return AwaitCallback("police:triangulate", data.phoneNumber)
    end,

    getPhones = function()
        return AwaitCallback("police:getPhones")
    end,

    unlockPhone = function(data)
        return AwaitCallback("police:unlockPhone", data.phoneNumber, data.name)
    end,

    resetPin = function(data)
        return AwaitCallback("police:resetPin", data.phoneNumber)
    end,

    getWiretaps = function(data)
        return AwaitCallback("police:getWiretaps", data.page, data.query, data.filter)
    end,

    getCallHistory = function(data)
        return AwaitCallback("police:getCallHistory", data.phoneNumber, data.page, data.query)
    end,

    wiretapNumber = function(data)
        return AwaitCallback("police:wiretapNumber", data.phoneNumber)
    end,

    removeWiretap = function(data)
        return AwaitCallback("police:removeWiretap", data.phoneNumber)
    end,

    toggleSubscribeWiretap = function(data)
        return AwaitCallback("police:toggleSubscribeWiretap", data.phoneNumber, data.subscribe)
    end,

    listenToWiretap = function(data)
        return AwaitCallback("police:listenToWiretap", data.phoneNumber)
    end,

    stopListeningToWiretap = function()
        return AwaitCallback("police:stopListeningToWiretap")
    end
}

local function handlePoliceAction(data)
    local action = data.action
    local actionHandler = policeActions[action]

    if actionHandler then
        return actionHandler(data)
    end

    debugprint("Unknown action Police:" .. tostring(action))
end

ReactCallback("Police", handlePoliceAction, false, true, {
    "jailPlayer",
    "finePlayer"
})

local function registerPoliceForwarder(netEventName, reactEventName, transformPayload, debugLabel)
    RegisterNetEvent(netEventName, function(...)
        local payload = transformPayload and transformPayload(...) or select(1, ...)

        if debugLabel then
            debugprint(debugLabel, payload)
        end

        SendReactMessage(reactEventName, payload)
    end)
end

registerPoliceForwarder("tablet:police:createdTag", "police:tagCreated")
registerPoliceForwarder("tablet:police:deletedTag", "police:tagDeleted")
registerPoliceForwarder("tablet:police:addedTag", "police:tagAdded", function(id, entryType, tagId)
    return {
        id = id,
        type = entryType,
        tagId = tagId
    }
end)
registerPoliceForwarder("tablet:police:removedTag", "police:tagRemoved", function(id, entryType, tagId)
    return {
        id = id,
        type = entryType,
        tagId = tagId
    }
end)
registerPoliceForwarder("tablet:police:profileUpdated", "police:profileUpdated")
registerPoliceForwarder("tablet:police:reportUpdated", "police:reportUpdated")
registerPoliceForwarder("tablet:police:reportDeleted", "police:reportDeleted")
registerPoliceForwarder("tablet:police:caseUpdated", "police:caseUpdated")
registerPoliceForwarder("tablet:police:caseDeleted", "police:caseDeleted")
registerPoliceForwarder("tablet:police:warrantUpdated", "police:warrantUpdated")
registerPoliceForwarder("tablet:police:warrantDeleted", "police:warrantDeleted")
registerPoliceForwarder("tablet:police:bulletinCreated", "police:bulletinCreated")
registerPoliceForwarder("tablet:police:bulletinUpdated", "police:bulletinUpdated")
registerPoliceForwarder("tablet:police:bulletinDeleted", "police:bulletinDeleted")
registerPoliceForwarder("tablet:police:addOffenceCategory", "police:addOffenceCategory")
registerPoliceForwarder("tablet:police:updateOffenceCategory", "police:updateOffenceCategory", function(oldCategory, newCategory)
    return {
        oldCategory = oldCategory,
        newCategory = newCategory
    }
end)
registerPoliceForwarder("tablet:police:deleteOffenceCategory", "police:deleteOffenceCategory")
registerPoliceForwarder("tablet:police:addOffence", "police:addOffence")
registerPoliceForwarder("tablet:police:updateOffence", "police:updateOffence")
registerPoliceForwarder("tablet:police:deleteOffence", "police:deleteOffence")
registerPoliceForwarder("tablet:police:revokedLicense", "police:licenseRevoked", function(id, license)
    return {
        id = id,
        license = license
    }
end)
registerPoliceForwarder("tablet:police:licenseAdded", "police:licenseAdded", function(id, license)
    return {
        id = id,
        license = license
    }
end)
registerPoliceForwarder("tablet:police:newPrisoner", "police:newPrisoner", function(prisoner)
    prisoner.id = prisoner.identifier
    return prisoner
end)
registerPoliceForwarder("tablet:police:prisonerReleased", "police:prisonerReleased")
registerPoliceForwarder("tablet:police:updateCallsign", "police:updateCallsign")
registerPoliceForwarder("tablet:police:weaponDeleted", "police:weaponDeleted")
registerPoliceForwarder("tablet:police:setInCall", "police:setInCall")
registerPoliceForwarder("tablet:police:removeWiretap", "police:removeWiretap")
registerPoliceForwarder("tablet:police:createWiretap", "police:createWiretap", nil, "police:createWiretap")

SetTimeout(500, function()
    RegisterDutyBlipsListener("police", IsPolice)
end)

AddEventHandler("lb-tablet:jobUpdated", function()
    debugprint("Police: job updated, refreshing permissions etc")

    local hasAccess = IsPolice()
    if Config.RequireDutyMDT and not IsOnDuty() then
        debugprint("Not on duty, removing police app")
        hasAccess = false
    end

    local appAccess = {
        app = "police",
        hasAccess = hasAccess,
        appData = hasAccess and PoliceAppData or nil
    }

    debugprint("Police: setHasAccess:", appAccess)
    SendReactMessage("police:updatePermissions", getPolicePermissions())
    SendReactMessage("app:setHasAccess", appAccess)
end)