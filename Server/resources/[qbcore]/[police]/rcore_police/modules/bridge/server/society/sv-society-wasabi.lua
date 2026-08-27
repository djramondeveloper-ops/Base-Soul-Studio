-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Society == Society.WASABI_BANKING then
        SocietyService.GetMoney = function(business)
            if doesExportExistInResource(Society.WASABI_BANKING, "GetAccountBalance") then
                return safeNumber(exports[Society.WASABI_BANKING]:GetAccountBalance(business, "society"), 0)
            end
            return 0
        end
        SocietyService.RemoveMoney = function(business, amount)
            if doesExportExistInResource(Society.WASABI_BANKING, "RemoveMoney") then
                return exports[Society.WASABI_BANKING]:RemoveMoney("society", business, amount)
            end
            return false
        end
        SocietyService.AddMoney = function(business, amount)
            if doesExportExistInResource(Society.WASABI_BANKING, "AddMoney") then
                return exports[Society.WASABI_BANKING]:AddMoney("society", business, amount)
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
            dbg.debug('Returning society business: %s (named: %s)', account and "Account exists" or "Account is nil",
            businessName)
            return account
        end
    end
end)
