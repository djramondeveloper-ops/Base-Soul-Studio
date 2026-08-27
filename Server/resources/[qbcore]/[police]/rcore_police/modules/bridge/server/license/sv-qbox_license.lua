-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    local LicenseList = {
        ["business"] = true,
        ["weapon"] = true,
        ["driver"] = true,
    }
    if Config.Licence == Licence.QBOX then
        GetPlayerLicenses = function(target)
            if not target then return {} end
            local player = Framework.getPlayer(target)
            if not player then return {} end
            return player.PlayerData.metadata['licences'] or {}
        end
        HasWeaponLicense = function(target)
            local playerLicenses = GetPlayerLicenses(target)
            return playerLicenses and playerLicenses['weapon'] == true
        end
        ShowPlayerLicense = function(target, playerId)
            if not target or not playerId then return end
            local licenses = GetPlayerLicenses(target)
            if licenses and next(licenses) then
                StartClient(playerId, 'ShowPlayerLicense', licenses)
            end
        end
        AddPlayerLicense = function(initiator, target, name)
            if not initiator or not target or not name then return false end
            name = name:lower()
            if not LicenseList[name] then
                Framework.sendNotification(initiator, _U("HELP_MESSAGES.NO_VALID_LICENCE", name), "error")
                return false
            end
            local currentLicenses = GetPlayerLicenses(target)
            if currentLicenses and currentLicenses[name] then
                Framework.sendNotification(initiator, _U('LICENSES.YOU_ALREADY_HAVE_LICENSE', name), "error")
                return false
            end
            local Player = Framework.getPlayer(target)
            if Player then
                currentLicenses[name] = true
                Player.Functions.SetMetaData('licences', currentLicenses)
                Framework.sendNotification(target, _U('LICENSES.RECEIVED_LICENSE', name), "success")
            end
        end
        RemovePlayerLicense = function(initiator, target, name)
            if not initiator or not target or not name then return false end
            name = name:lower()
            if not LicenseList[name] then
                Framework.sendNotification(initiator, _U("HELP_MESSAGES.NO_VALID_LICENCE", name), "error")
                return false
            end
            local currentLicenses = GetPlayerLicenses(target)
            if currentLicenses and not currentLicenses[name] then
                Framework.sendNotification(initiator, _U('LICENSES.YOU_DONT_HAVE_LICENSE', name), "error")
                return false
            end
            local Player = Framework.getPlayer(target)
            if Player then
                currentLicenses[name] = false
                Player.Functions.SetMetaData('licences', currentLicenses)
                Framework.sendNotification(Player.PlayerData.source, _U('LICENSES.CONFISCATED', name), "success")
            end
        end
    end
end)
