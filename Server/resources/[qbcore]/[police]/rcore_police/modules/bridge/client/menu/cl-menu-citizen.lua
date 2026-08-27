-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Menu.AddCitizenSubMenu = function()
    local citizenSubMenu = {}
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.CITIZEN_SUB_MENU_ESCORT_PLAYER_TITLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.ESCORT_CITIZEN,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-user'
        },
    }
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.CITIZEN_SUB_MENU_CUFF_SOFT_TITLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.CUFF_SOFT,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-handcuffs'
        },
    }
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.CITIZEN_SUB_MENU_SENT_TO_JAIL_TITLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.SENT_TO_JAIL,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-handcuffs'
        },
    }
    local playerIsBoss = Framework.job.isBoss
    if playerIsBoss then
        citizenSubMenu[#citizenSubMenu + 1] = {
            type = 'button',
            header = _U('MENUS.CITIZEN_SUB_MENU_HIRE_CLOSEST_PLAYER_TITLE'),
            description = '',
            params = {
                isClient = true,
                event = 'rcore_police:client:menuInteract',
                args = {
                    action = MENU_ACTIONS.HIRE_PLAYER,
                    type = ACTION_TYPES.CITIZEN
                },
                icon = 'fa-solid fa-book'
            },
        } 
    end
    if Config.Fines.Enable then
        citizenSubMenu[#citizenSubMenu + 1] = {
            type = 'button',
            header = _U('FINES.HEADER_MENU_TITLE'),
            description = '',
            params = {
                icon = 'fa-solid fa-book'
            },
            submenu = Menu.AddFinesMenu()
        }
    end
    if Config.JobMenu.EnableInvoice then
        citizenSubMenu[#citizenSubMenu + 1] = {
            type = 'button',
            header = _U('MENUS.CITIZEN_SUB_MENU_INVOICE_TITLE'),
            description = '',
            params = {
                isClient = true,
                event = 'rcore_police:client:menuInteract',
                args = {
                    action = MENU_ACTIONS.INVOCE_CITIZEN,
                    type = ACTION_TYPES.CITIZEN
                },
                icon = 'fa-solid fa-book'
            },
        }
    end
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.CITIZEN_SUB_MENU_SEARCH_PLAYER_TITLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.SEARCH_PLAYER,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-magnifying-glass'
        },
    }
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.CITIZEN_SUB_MENU_SHOW_PLAYER_LICENSES'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.SHOW_PLAYER_LICENSES,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-magnifying-glass'
        },
    }
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.CITIZEN_SUB_MENU_SENT_TO_COMS_TITLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.SENT_TO_COMS,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-magnifying-glass'
        },
    }
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.FROM_VEHICLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.FROM_VEHICLE,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-magnifying-glass'
        },
    }
    citizenSubMenu[#citizenSubMenu + 1] = {
        type = 'button',
        header = _U('MENUS.IN_VEHICLE'),
        description = '',
        params = {
            isClient = true,
            event = 'rcore_police:client:menuInteract',
            args = {
                action = MENU_ACTIONS.IN_VEHICLE,
                type = ACTION_TYPES.CITIZEN
            },
            icon = 'fa-solid fa-magnifying-glass'
        },
    }
    return citizenSubMenu
end
