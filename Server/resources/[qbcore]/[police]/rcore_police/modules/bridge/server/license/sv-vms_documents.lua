-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Licence == Licence.VMS then
        GetPlayerLicenses = function(target)
            local identifier = Framework.getIdentifier(target)
            local retval = {}
            if doesExportExistInResource(Licence.VMS, "getMyDocuments") then
                return exports[Licence.VMS]:getMyDocuments(identifier)
            end
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
        AddPlayerLicense = function(initiator, target, licenseName)
            if not initiator or not target or not licenseName then return end
            licenseName = licenseName:lower()
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
                if doesExportExistInResource(Licence.VMS, "giveDocument") then
                    return exports[Licence.VMS]:giveDocument(target, licenseName, nil, true)
                end
            else
                Framework.sendNotification(initiator, _U('LICENSES.YOU_ALREADY_HAVE_LICENSE', licenseName, 'error'))
            end
        end
        RemovePlayerLicense = function(initiator, target, licenseName)
            if not initiator or not target or not licenseName then return end
            licenseName = licenseName:lower()
            local currentLicenses = GetPlayerLicenses(target)
            local targetIdentifier = Framework.getIdentifier(target)
            local serialNumber = exports[Licence.VMS]:isAnyDocumentValid(targetIdentifier, licenseName)
            if currentLicenses and currentLicenses[licenseName] and serialNumber then
                exports[Licence.VMS]:invalidateDocument(targetIdentifier, serialNumber)
            else
                Framework.sendNotification(initiator, _U('LICENSES.YOU_DONT_HAVE_LICENSE', licenseName, 'error'))
            end
        end
    end
end)
