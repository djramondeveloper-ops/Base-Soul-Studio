-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Society == Society.OKOK then
        local function getESXSocietyAccount(business)
            local p = promise.new()
            local societyPrefix = ('society_%s'):format(business)
            TriggerEvent(Config.Events['esx_addonaccount:getSharedAccount'], societyPrefix, function(account)
                p:resolve(account)
            end)
            return Citizen.Await(p)
        end
        SocietyService.GetMoney = function(business)
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    return safeNumber(account.money, 0)
                end
            end
            if IS_QB[Config.Framework] and doesExportExistInResource(Society.OKOK, 'GetAccount') then
                return safeNumber(exports[Society.OKOK]:GetAccount(business), 0)
            end
            if IS_QB[Config.Framework] and not doesExportExistInResource(Society.OKOK, 'GetAccount') then
                dbg.critical("Society: You are running okokBanking for society, but failed to find GetAccount export which is needed when using: %s - update your %s", Config.Framework, Society.OKOK)
                return safeNumber(0, 0)
            end
        end
        SocietyService.RemoveMoney = function(business, amount)
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    account.removeMoney(amount)
                    return true
                end
            end
            if IS_QB[Config.Framework] and doesExportExistInResource(Society.OKOK, 'RemoveMoney') then
                return exports[Society.OKOK]:RemoveMoney(business, amount)
            end
            if IS_QB[Config.Framework] and not doesExportExistInResource(Society.OKOK, 'RemoveMoney') then
                 dbg.critical("Society: Failed to addMoney to society named: %s - since export named: %s doesnt exist with your society script: %s - update to latest version!", business, "RemoveMoney", Society.OKOK)
                return false
            end 
        end
        SocietyService.AddMoney = function(business, amount)
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    account.addMoney(amount)
                    return true
                end
            end
            if IS_QB[Config.Framework] and doesExportExistInResource(Society.OKOK, 'AddMoney') then
                return exports[Society.OKOK]:AddMoney(business, amount)
            end
            if IS_QB[Config.Framework] and not doesExportExistInResource(Society.OKOK, 'AddMoney') then
                 dbg.critical("Society: Failed to addMoney to society named: %s - since export named: %s doesnt exist with your society script: %s - update to latest version!", business, "AddMoney", Society.OKOK)
                return false
            end
        end
        SocietyService.BuyDepartmentVehicle = function(data, cb)
            local retval = false
            if not data then
                return
            end
            local account = SocietyService.GetAccount(data.department)
            if account and next(account) then
                local balance = account.GetBalance()
                if balance and balance >= data.spawnPrice then
                    retval = true
                end
            end
            cb(retval, data.spawnPrice)
        end
        SocietyService.StoreDepartmentVehicle = function(data, cb)
            local retval = false
            if not data then
                return
            end
            local account = SocietyService.GetAccount(data.department)
            if account and next(account) then
                account.AddMoney(data.spawnPrice)
                retval = true
            end
            cb(retval, data.spawnPrice)
        end
        SocietyService.Register = function(business)
            if isResourcePresentProvideless('lb-phone') then
                return true
            end
            if isResourcePresentProvideless(Society.JOBS_CREATOR) then
                return
            end
            if Config.Framework == Framework.ESX then
                local societyPrefix = ('%s_%s'):format('society', business)
                TriggerEvent('esx_society:registerSociety', societyPrefix, business, societyPrefix, societyPrefix, societyPrefix, {
                    type = "private"
                })
            end
            return true
        end
        SocietyService.GetAccount = function(businessName)
            local account = nil
            local accountBalance = SocietyService.GetMoney(businessName)
            if accountBalance and accountBalance >= 0 then
                account = {
                    AddMoney = function(amount) 
                        SocietyService.AddMoney(businessName, amount) 
                    end,
                    RemoveMoney = function(amount) 
                        SocietyService.RemoveMoney(businessName, amount) 
                    end,
                    GetBalance = function() 
                        return SocietyService.GetMoney(businessName)
                    end
                }
            else
                dbg.debug('Failed to get society account: %s', businessName)
            end
            dbg.debug('Returning society: %s (named: %s)', account and "Account exists" or "Account is nil", businessName)
            return account
        end
    end
end)
