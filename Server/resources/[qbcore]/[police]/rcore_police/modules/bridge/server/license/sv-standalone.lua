-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Licence == Licence.NONE then
        GetPlayerLicenses = function(target)
            return nil
        end
        HasWeaponLicense = function(target)
            return true
        end
        ShowPlayerLicense = function(target, playerId)
            if not target then
                return
            end
            if not playerId then
                return
            end
            local licenses = GetPlayerLicenses(target)
            if licenses and next(licenses) then
                StartClient(playerId, 'ShowPlayerLicense', licenses)
            end
        end
        AddPlayerLicense = function(initiator, target, name)
            if not initiator then
                return
            end
            if not target then
                return
            end
            if not name then
                return
            end
            name = name:lower()
            dbg.debug('AddPlayerLicense: Using resource %s - bridge - the function is not defined!!!', Config.Licence)
        end
        RemovePlayerLicense = function(initiator, target, name)
            if not initiator then
                return
            end
            if not target then
                return
            end
            if not name then
                return
            end
            name = name:lower()
            dbg.debug('RemovePlayerLicense: Using resource %s - bridge - the function is not defined!!!', Config.Licence)
        end
    end
end)
