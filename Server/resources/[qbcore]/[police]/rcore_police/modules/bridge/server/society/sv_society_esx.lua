-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Society == Society.ESX then
        local function getESXSocietyAccount(business)
            local p = promise.new()
            local societyPrefix = ('society_%s'):format(business)
            TriggerEvent(Config.Events['esx_addonaccount:getSharedAccount'], societyPrefix, function(account)
                p:resolve(account)
            end)
            return Citizen.Await(p)
        end
        SocietyService.GetMoney = function(business)
            if isResourcePresentProvideless(Society.TGG_BANKING) and doesExportExistInResource(Society.TGG_BANKING, "GetSocietyAccountMoney") then
                return safeNumber(exports[Society.TGG_BANKING]:GetSocietyAccountMoney(business), 0)
            end
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    return safeNumber(account.money, 0)
                end
            end
            return 0
        end
        SocietyService.RemoveMoney = function(business, amount)
            if isResourcePresentProvideless(Society.TGG_BANKING) and doesExportExistInResource(Society.TGG_BANKING, "RemoveSocietyMoney") then
                return exports[Society.TGG_BANKING]:RemoveSocietyMoney(business, amount)
            end
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    account.removeMoney(amount)
                    return true
                end
            end
            return false
        end
        SocietyService.AddMoney = function(business, amount)
            if isResourcePresentProvideless(Society.TGG_BANKING) and doesExportExistInResource(Society.TGG_BANKING, "AddSocietyMoney") then
                return exports[Society.TGG_BANKING]:AddSocietyMoney(business, amount)
            end
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    account.addMoney(amount)
                    return true
                end
            end
            return false
        end
        SocietyService.BuyDepartmentVehicle = function(data, cb)
            local retval = false
            if not data then return end
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
            if not data then return end
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
            local societyPrefix = ('%s_%s'):format('society', business)
            TriggerEvent('esx_society:registerSociety', societyPrefix, business, societyPrefix, societyPrefix, societyPrefix, {
                type = "private"
            })
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
            dbg.debug('Returning society business: %s (named: %s)', account and "Account exists" or "Account is nil", businessName)
            return account
        end
    end
end)
