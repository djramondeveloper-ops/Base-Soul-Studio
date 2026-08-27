-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    local IgnoreLicenses = {
        ['THEORY_DRIVER_CAR'] = true,
        ['THEORY_DRIVER_TRUCK'] = true,
    }
    local Licenses = {
        ['DRIVER_TRUCK'] = 'Trucker License',
        ['DRIVER_CAR'] = 'Driving License', 
        ['POLICE'] = 'Police', 
    }
    if Config.Licence == Licence.CODESTUDIO then
        ShowPlayerLicense = function(data)
            local array = {
                {
                    header = _U('LICENSES.MENU_TITLE'),
                    isMenuHeader = true,
                },
            }
            if data and next(data) then
                for name, data in pairs(data) do
                    local licenseName = data.license:upper()
                    local translation = Licenses[licenseName] or licenseName
                    if not IgnoreLicenses[licenseName] then
                        local prefix = ('%s'):format(translation)
                        array[#array + 1] = {
                            type = 'button',
                            header = prefix,
                            description = '',
                            params = {
                                icon = 'fa-solid fa-id-card',
                            },
                        }
                    end
                end
                UI:CreateMenu(MENU_ID_LIST.LICENSES, 'Licenses', array, true)
            end
        end
    end
end)
