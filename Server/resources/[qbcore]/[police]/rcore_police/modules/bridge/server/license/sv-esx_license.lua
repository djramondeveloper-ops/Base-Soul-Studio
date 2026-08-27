-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    local Licenses = {}
    if Config.Licence == Licence.ESX then
        GetPlayerLicenses = function(target)
            local retval = {}
            local p = promise.new()
            if not target then
                return retval
            end
            TriggerEvent('esx_license:getLicenses', target, function(data)
                if not next(data) then
                    retval = {}
                else
                    for k, v in pairs(data) do
                        if not retval[v.type] then
                            retval[v.type] = true
                        end
                    end
                end
                p:resolve(true)
            end)
            Citizen.Await(p)
            return retval
        end
        HasWeaponLicense = function(target)
            local playerLicences = GetPlayerLicenses(target)
            if playerLicences and playerLicences['weapon'] then
                return true
            end
            return false
        end
        ShowPlayerLicense = function(target, playerId)
            if not target or not playerId then return end
            local licenses = GetPlayerLicenses(target)
            if licenses and next(licenses) then
                StartClient(playerId, 'ShowPlayerLicense', licenses)
            else
                Framework.sendNotification(source, _U("NO_LICENCE_FOUND"), "success")
            end
        end
        CacheLicenses = function()
            TriggerEvent('esx_license:getLicensesList', function(list)
                if list and next(list) then
                    for _, v in pairs(list) do
                        local license = v.type
                        if not Licenses[license] then
                            Licenses[license] = true
                        end
                    end
                end
            end)
        end
        AddPlayerLicense = function(initiator, target, licenseName)
            if not initiator or not target or not licenseName then return end
            licenseName = licenseName:lower()
            if not Licenses[licenseName] then
                Framework.sendNotification(initiator, _U("HELP_MESSAGES.NO_VALID_LICENCE", licenseName), "error")
                return false
            end
            local currentLicenses = GetPlayerLicenses(target)
            local size = table.size(currentLicenses)
            if not currentLicenses then
                return
            end
            local canAddLicence = false
            if size <= 0 then
                canAddLicence = true
            end
            if size >= 1 and not currentLicenses[licenseName] then
                canAddLicence = true
            end
            if canAddLicence then
                TriggerEvent('esx_license:addLicense', target, licenseName, function(retval)
                    Framework.sendNotification(target, _U('LICENSES.RECEIVED_LICENSE', licenseName, 'success'))
                end)
            else
                Framework.sendNotification(initiator, _U('LICENSES.YOU_ALREADY_HAVE_LICENSE', licenseName, 'error'))
            end
        end
        RemovePlayerLicense = function(initiator, target, licenseName)
            if not initiator or not target or not licenseName then return end
            licenseName = licenseName:lower()
            if not Licenses[licenseName] then
                Framework.sendNotification(initiator, _U("HELP_MESSAGES.NO_VALID_LICENCE", licenseName), "error")
                return false
            end
            local currentLicenses = GetPlayerLicenses(target)
            local targetIdentifier = Framework.getIdentifier(target)
            if currentLicenses and currentLicenses[licenseName] then
                local retval = MySQL.Sync.execute('DELETE FROM user_licenses WHERE type = ? AND owner = ?', {
                    licenseName,
                    targetIdentifier,
                }) 
            else
                Framework.sendNotification(initiator, _U('LICENSES.YOU_DONT_HAVE_LICENSE', licenseName, 'error'))
            end
        end
        CacheLicenses()
    end
end)
