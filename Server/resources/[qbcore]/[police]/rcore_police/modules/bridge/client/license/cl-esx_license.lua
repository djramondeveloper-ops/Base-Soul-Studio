-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Licence == Licence.ESX then
        ShowPlayerLicense = function(data)
            local array = {
                {
                    header = _U('LICENSES.MENU_TITLE'),
                    isMenuHeader = true,
                },
            }
            if data and next(data) then
                for name, state in pairs(data) do
                    local licenseName = name:upper()
                    local hasLicense = state and _U('LICENSES.HAS_LICENSE') or _U('LICENSES.NO_LICENSE')
                    local prefix = ('%s: %s'):format(licenseName, hasLicense)
                    array[#array + 1] = {
                        type = 'button',
                        header = prefix,
                        description = '',
                        params = {
                            icon = 'fa-solid fa-id-card',
                        },
                    }
                end
                UI:CreateMenu(MENU_ID_LIST.LICENSES, 'Licenses', array, true)
            end
        end
    end
end)
