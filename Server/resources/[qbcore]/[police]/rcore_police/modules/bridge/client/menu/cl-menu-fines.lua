-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Menu.AddFinesMenu = function()
    local fineList = {}
    if Config.Fines.List and next(Config.Fines.List) then
        for k, v in pairs(Config.Fines.List) do
            fineList[#fineList + 1] = {
                type = 'button',
                header = v.label,
                description = _U('FINES.HEADER_MENU_LABEL_PREFIX', v.amount),
                params = {
                    isClient = true,
                    event = 'rcore_police:client:menuInteract',
                    args = {
                        action = MENU_ACTIONS.SENT_FINE,
                        type = ACTION_TYPES.CITIZEN,
                        data = {
                            name = v.label,
                            cost = v.amount 
                        }
                    },
                    icon = 'fa-solid fa-book'
                },
            }
        end
    end
    return fineList
end
