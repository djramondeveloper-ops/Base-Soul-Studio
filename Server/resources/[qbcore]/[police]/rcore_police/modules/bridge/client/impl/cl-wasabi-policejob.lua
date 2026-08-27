-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local function searchPlayer(target)
    if not target then return end
    local isPlayerOnline = GetPlayerFromServerId(target)
    if isPlayerOnline == -1 then
        return dbg.debug('RequestPlayerSearch: Failed since player is not online!')
    end
    TriggerServerEvent('rcore_police:server:requestSearchInventory', target)
end
local function openOutfits(jobName)
    if not jobName then return end
    OpenOutfitMenu(nil, jobName)
end
local function getHandCuffState()
    return InteractionService.isCuffed()
end
local function escortPlayer()
    if not Config.Escort.Enable then
        return
    end
    TriggerEvent('wasabi_police:escortPlayer')
end
local function getPoliceOnline()
    return GroupsService.GetAllDeparmentsCount()
end
local impl = {
    { name = 'searchPlayer',  func = searchPlayer },
    { name = 'openOutfits',   func = openOutfits  },
    { name = 'IsHandcuffed',   func = getHandCuffState  },
    { name = 'escortPlayer',   func = escortPlayer  },
    { name = 'getPoliceOnline',   func = getPoliceOnline  },
}
local EMULATED_EVENTS = {
    {
        event = 'wasabi_police:handcuffPlayer',
        action = MENU_ACTIONS.CUFF_SOFT,
        type = ACTION_TYPES.CITIZEN
    },
    {
        event = 'wasabi_police:escortPlayer',
        action = MENU_ACTIONS.ESCORT_CITIZEN,
        type = ACTION_TYPES.CITIZEN
    },
    {
        event = 'wasabi_police:searchPlayer',
        action = MENU_ACTIONS.SEARCH_PLAYER,
        type = ACTION_TYPES.CITIZEN
    },
    {
        event = 'wasabi_police:vehicleInfo',
        action = MENU_ACTIONS.SHOW_VEHICLE_INFORMATION,
        type = 'VEHICLE'
    },
    {
        event = 'wasabi_police:lockpickVehicle',
        action = MENU_ACTIONS.UNLOCK_VEHICLE,
        type = 'VEHICLE'
    },
    {
        event = 'wasabi_police:impoundVehicle',
        action = MENU_ACTIONS.IMPOUND_VEHICLE,
        type = 'VEHICLE'
    },
    {
        event = 'wasabi_police:inVehiclePlayer',
        action = MENU_ACTIONS.IN_VEHICLE,
        type = ACTION_TYPES.CITIZEN
    },
    {
        event = 'wasabi_police:outVehiclePlayer',
        action = MENU_ACTIONS.FROM_VEHICLE,
        type = ACTION_TYPES.CITIZEN
    },
    {
        event = 'wasabi_police:createRadarPost',
        value = 'rds_speed_camera', 
        action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, 
        type = PROP_TYPES.SPEED_RADAR
    },
    {
        event = 'wasabi_police:createBarrier',
        value = 'rds_prop_barrier_police', 
        action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, 
        type = PROP_TYPES.BARRICADE
    },
    {
        event = 'wasabi_police:createCone',
        type = nil
    },
    {
        event = 'wasabi_police:deleteClosestProp',
        type = nil
    },
}
CreateThread(function()
    if impl and next(impl) then
        for _, v in ipairs(impl) do
            if v.func and v.name then
                provideExport(v.name, PoliceResources.WASABI, v.func)
            end
        end 
    end
    if EMULATED_EVENTS and next(EMULATED_EVENTS) then
        for id, data in pairs(EMULATED_EVENTS) do
            local eventData = data
            local eventName = eventData.event
            if not eventName then
                return
            end
            dbg.debugAPI('Wasabi: Registering emulated event named: %s', eventName)
            AddEventHandler(eventName, function()
                if not data.type then
                    return dbg.critical('Wasabi: The emulated event named %s is not defined in RCore Police - canceling execution!', eventName)
                end
                dbg.debug('IMPL: Emulated event was called named %s from resource %s', eventName, GetInvokingResource())
                if isResourcePresentProvideless('cs_radialmenu') then
                    TriggerEvent('cs_radialmenu:client:onRadialmenuClose')
                    Wait(100)
                end
                TriggerEvent('rcore_police:client:menuInteract', data, GetInvokingResource())
            end)
        end
    end
end)
