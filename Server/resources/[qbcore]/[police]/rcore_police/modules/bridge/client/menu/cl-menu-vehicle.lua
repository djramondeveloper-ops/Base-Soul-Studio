-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Menu.AddVehicleSubMenu = function()
    local propSubmenu = {}
    propSubmenu[#propSubmenu + 1] = {
        type = 'button',
        header = _U('VEHICLE_MENU.UNLOCK_VEHICLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.UNLOCK_VEHICLE,
                type = 'VEHICLE'
            },
            icon = 'fas fa-car'
        },
    }
    propSubmenu[#propSubmenu + 1] = {
        type = 'button',
        header = _U('VEHICLE_MENU.IMPOUND_VEHICLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.IMPOUND_VEHICLE,
                type = 'VEHICLE'
            },
            icon = 'fas fa-car'
        },
    }
    propSubmenu[#propSubmenu + 1] = {
        type = 'button',
        header = _U('VEHICLE_MENU.VEHICLE_INFORMATION'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.SHOW_VEHICLE_INFORMATION,
                type = 'VEHICLE',
            },
            icon = 'fa-solid fa-magnifying-glass'
        },
    }
    if Config.Garage.EnableExtrasMenu then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local isInVehicle = IsPedInVehicle(playerPed, vehicle, false) or false
        local vehicleExtras = {}
        if DoesEntityExist(vehicle) then
            for i = 1, 20, 1 do
                if DoesExtraExist(vehicle, i) then
                    vehicleExtras[#vehicleExtras + 1] = {
                        type = 'button',
                        header = ("Extra: %s"):format(i),
                        description = '',
                        params = {
                            onClick = function(item)
                                HandleVehicleExtras(vehicle, i)
                            end
                        },
                    }
                end
            end
            propSubmenu[#propSubmenu + 1] = {
                type = 'button',
                header = _U('VEHICLE_MENU.VEHICLE_EXTRAS'),
                description = '',
                params = {
                    icon = 'fas fa-car'
                },
                submenu = vehicleExtras
            }
        end
    end
    return propSubmenu
end
