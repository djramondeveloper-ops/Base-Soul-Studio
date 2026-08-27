-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local EventActionMap = {
    Cuff          = { action = MENU_ACTIONS.CUFF_SOFT, type = ACTION_TYPES.CITIZEN },
    Escort        = { action = MENU_ACTIONS.ESCORT_CITIZEN, type = ACTION_TYPES.CITIZEN },
    Licenses      = { action = MENU_ACTIONS.SHOW_PLAYER_LICENSES, type = ACTION_TYPES.CITIZEN },
    InVehicle     = { action = MENU_ACTIONS.IN_VEHICLE, type = ACTION_TYPES.CITIZEN },
    FromVehicle   = { action = MENU_ACTIONS.FROM_VEHICLE, type = ACTION_TYPES.CITIZEN },
    Search        = { action = MENU_ACTIONS.SEARCH_PLAYER, type = ACTION_TYPES.CITIZEN },
    Jail          = { action = MENU_ACTIONS.SENT_TO_JAIL, type = ACTION_TYPES.CITIZEN },
    Emergency     = { action = MENU_ACTIONS.EMERGENCY, type = ACTION_TYPES.CITIZEN },
    Fine          = { action = MENU_ACTIONS.INVOCE_CITIZEN, type = ACTION_TYPES.CITIZEN },
    Impound       = { action = MENU_ACTIONS.IMPOUND_VEHICLE, type = ACTION_TYPES.VEHICLE },
    UnlockVehicle = { action = MENU_ACTIONS.UNLOCK_VEHICLE, type = ACTION_TYPES.VEHICLE },
    VehicleInfo   = { action = MENU_ACTIONS.SHOW_VEHICLE_INFORMATION, type = ACTION_TYPES.VEHICLE },
    Coms          = { action = MENU_ACTIONS.SENT_TO_COMS, type = ACTION_TYPES.CITIZEN },
    Radar         = { action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.SPEED_RADAR, value = 'rds_speed_camera' },
    Megaphone     = { action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.MEGA_PHONE, value = 'prop_megaphone_01' },
    Spikes        = { action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.SPIKES, value = 'p_ld_stinger_s' },
    Barrier       = { action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.BARRICADE, value = 'rds_prop_barrier_police' },
}
CreateThread(function()
    for key, entry in pairs(EventActionMap) do
        local resource = GetCurrentResourceName()
        local legacyEventName = ("%s:client:%s"):format(resource, key)
        local eventName = ("%s:client:api:%s"):format(resource, key)
        AddEventHandler(eventName, function()
            TriggerEvent("rcore_police:client:menuInteract", entry)
        end)
    end
end)
