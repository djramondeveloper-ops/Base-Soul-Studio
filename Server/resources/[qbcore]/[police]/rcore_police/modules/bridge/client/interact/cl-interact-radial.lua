-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local lastInteractTime = nil
local cooldownTime = 500
function OpenRadialMenu()
    if not Config.RadialMenu.Enable then
        return
    end
    local currentTime = GetGameTimer()
    if lastInteractTime and (currentTime - lastInteractTime) < cooldownTime then
        return
    end       
    lastInteractTime = GetGameTimer()
    if not Utils.CanPlayerInteract() then
        return
    end
    if not Utils.HasAccessToJobMenu() then
        return
    end
    local payload = {
        title = _U("RADIAL_MENU.MAIN_MENU_TITLE"),
        options = {
            { name = _U("RADIAL_MENU.CUFF_LABEL"),         action = MENU_ACTIONS.CUFF_SOFT,            icon = 'Cuff',              type = ACTION_TYPES.CITIZEN },
            { name = _U("RADIAL_MENU.ESCORT_LABEL"),       action = MENU_ACTIONS.ESCORT_CITIZEN,       icon = 'Escort',            type = ACTION_TYPES.CITIZEN },
            { name = _U("RADIAL_MENU.LICENCES_LABEL"),     action = MENU_ACTIONS.SHOW_PLAYER_LICENSES, icon = 'faIdBadge',         type = ACTION_TYPES.CITIZEN },
            { name = _U("RADIAL_MENU.IN_VEHICLE_LABEL"),   action = MENU_ACTIONS.IN_VEHICLE,           icon = 'faCarSide',         type = ACTION_TYPES.CITIZEN },
            { name = _U("RADIAL_MENU.FROM_VEHICLE_LABEL"), action = MENU_ACTIONS.FROM_VEHICLE,         icon = 'faCarSide',         type = ACTION_TYPES.CITIZEN },
            { name = _U("RADIAL_MENU.SEARCH_LABEL"),       action = MENU_ACTIONS.SEARCH_PLAYER,        icon = 'faMagnifyingGlass', type = ACTION_TYPES.CITIZEN },
            { name = _U("RADIAL_MENU.JAIL_LABEL"),         action = MENU_ACTIONS.SENT_TO_JAIL,         icon = 'faUserLock',        type = ACTION_TYPES.CITIZEN },
            { name = _U("RADIAL_MENU.EMERGENCY_LABEL"),    action = MENU_ACTIONS.EMERGENCY,            icon = 'Alarm' },
            { name = _U("RADIAL_MENU.FINE_LABEL"),         action = MENU_ACTIONS.INVOCE_CITIZEN,       icon = 'faBook',            type = ACTION_TYPES.CITIZEN },
            {
                name = _U("RADIAL_MENU.POLICE_MENU_TITLE"),
                icon = 'faListCheck',
                submenu = {
                    {
                        name = _U("RADIAL_MENU.MDT_LABEL"),
                        extraActions = {
                            typeInvoke = "event",
                            name = "rcore_police:client:showMDT",
                            type = "client",
                        },
                        icon = 'faTabletScreenButton'
                    },
                    {
                        name = _U("RADIAL_MENU.DISPATCH_LABEL"),
                        extraActions = {
                            typeInvoke = "event",
                            name = "rcore_police:client:showDispatch",
                            type = "client",
                        },
                        icon = 'faTabletScreenButton'
                    },
                    { name = _U("RADIAL_MENU.IMPOUND_VEHICLE"), icon = 'faFile', action = MENU_ACTIONS.IMPOUND_VEHICLE, type = ACTION_TYPES.VEHICLE },
                    { name = _U("RADIAL_MENU.UNLOCK_VEHICLE"), icon = 'faUnlock',  action = MENU_ACTIONS.UNLOCK_VEHICLE, type = ACTION_TYPES.VEHICLE },
                    { name = _U("RADIAL_MENU.VEHICLE_INFO"), icon = 'faCar',  action = MENU_ACTIONS.SHOW_VEHICLE_INFORMATION, type = ACTION_TYPES.VEHICLE },
                    { name = _U("RADIAL_MENU.COMS"), icon = 'faUserLock', action = MENU_ACTIONS.SENT_TO_COMS, type = ACTION_TYPES.CITIZEN},
                    { name = _U("RADIAL_MENU.RADAR"), icon = 'Camera',   value = 'rds_speed_camera', action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.SPEED_RADAR},
                    { name = _U("RADIAL_MENU.MEGAPHONE"), icon = 'Megaphone',   value = 'prop_megaphone_01', action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.MEGA_PHONE},
                    { name = _U("RADIAL_MENU.SPIKES"), icon = 'Spike',   value = 'p_ld_stinger_s', action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.SPIKES},
                    { name = _U("RADIAL_MENU.BARRIER"), icon = 'Barricade',  value = 'rds_prop_barrier_police', action = MENU_ACTIONS.REQUEST_SPAWN_MODEL, type = PROP_TYPES.BARRICADE},
                }
            },
        }
    }
    UI.RadialMenu(payload)
end
function RadialActionListener(data)
    if not Utils.CanPlayerInteract() then
        return
    end
    local extraActions = data.extraActions
    if extraActions and next(extraActions) then
        local invokeName = extraActions.name
        local invokeType = extraActions.typeInvoke:upper()
        local sideType = extraActions.type:upper()
        if invokeType == RADIAL_MENU.SENT_TYPE_EVENT then
            if sideType == RADIAL_MENU.SENT_SIDE_CLIENT then
                TriggerEvent(invokeName)
            elseif sideType == RADIAL_MENU.SENT_SIDE_SERVER then
                TriggerServerEvent(invokeName)
            end
        elseif invokeType == RADIAL_MENU.SENT_TYPE_COMMAND then
            ExecuteCommand(invokeName)
        end
    else
        TriggerEvent('rcore_police:client:menuInteract', data)
    end
end
CreateThread(function()
    if Config.Framework == Framework.QBOX and Config.RadialMenu.Key == 'F5' and isResourcePresentProvideless('scully_emotemenu') then
        Config.RadialMenu.Key = 'F4'
        dbg.debug('RadialMenu: Switching key to F4 since detected scully_emotemenu.')
    end
    RegisterKey(OpenRadialMenu, 'RCORE_POLICE_RADIAL', _U("KEY_MAPPING.RADIAL_MENU"), Config.RadialMenu.Key)
end)

RegisterCommand('policeradial', function()
    OpenRadialMenu()
end, false)

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 288) then -- F1
            OpenRadialMenu()
        end
    end
end)
