-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Menu.AddPropsSubMenu = function()
    local propSubmenu = {}
    if Config.JobMenu.EnableProps and next(Config.JobMenu.PropList) then
        for _, propData in pairs(Config.JobMenu.PropList) do
            propSubmenu[#propSubmenu + 1] = {
                type = 'button',
                header = propData.label,
                description = '',
                params = {
                    isClient = true,
                    event = 'rcore_police:client:menuInteract',
                    args = {
                        action = MENU_ACTIONS.REQUEST_SPAWN_MODEL,
                        value = propData.model,
                        type = propData.type
                    },
                    icon = propData.icon,
                },
            }
        end
    else
        dbg.debug('Submenu props is disabled, not adding into job menu!')
    end
    return propSubmenu
end
