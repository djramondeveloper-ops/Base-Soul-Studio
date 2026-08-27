-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Society == Society.QS_BANKING then
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
            if doesExportExistInResource(Society.QB_MANAGEMENT, "GetAccount") then
                return safeNumber(exports[Society.QB_MANAGEMENT]:GetAccount(business), 0)
            end
            if doesExportExistInResource(Society.QB_BANKING, "GetAccountBalance") then
                return safeNumber(exports[Society.QB_BANKING]:GetAccountBalance(business), 0)
            end
            return 0
        end
        SocietyService.RemoveMoney = function(business, amount)
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    account.removeMoney(amount)
                    return true
                end
            end
            if doesExportExistInResource(Society.QB_MANAGEMENT, "RemoveMoney") then
                return exports[Society.QB_MANAGEMENT]:RemoveMoney(business, amount)
            end
            if doesExportExistInResource(Society.QB_BANKING, "RemoveMoney") then
                return exports[Society.QB_BANKING]:RemoveMoney(business, amount)
            end
            return false
        end
        SocietyService.AddMoney = function(business, amount)
            if Config.Framework == Framework.ESX then
                local account = getESXSocietyAccount(business)
                if account then
                    account.addMoney(amount)
                    return true
                end
            end
            if doesExportExistInResource(Society.QB_MANAGEMENT, "AddMoney") then
                return exports[Society.QB_MANAGEMENT]:AddMoney(business, amount)
            end
            if doesExportExistInResource(Society.QB_BANKING, "AddMoney") then
                return exports[Society.QB_BANKING]:AddMoney(business, amount)
            end
            return false
        end
        SocietyService.Register = function(business)
            dbg.debug("Business named %s was registered!", business)
            if Config.Framework == Framework.ESX then
                if isResourcePresentProvideless('lb-phone') then
                    return true
                end
                TriggerEvent(Config.Events['esx_society:registerSociety'] or 'esx_society:registerSociety',
                    business, business, business, business, business, {
                        type = "private"
                    })
            end
            return true
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
