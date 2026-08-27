-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Society == Society.FD_BANKING then
        SocietyService.GetMoney = function(business)
            if doesExportExistInResource(Society.FD_BANKING, 'GetAccount') then
                return safeNumber(exports[Society.FD_BANKING]:GetAccount(business), 0)
            end
            return 0
        end
        SocietyService.RemoveMoney = function(business, amount)
            if doesExportExistInResource(Society.FD_BANKING, 'RemoveMoney') then
                return exports[Society.FD_BANKING]:RemoveMoney(business, amount)
            end
            return false
        end
        SocietyService.AddMoney = function(business, amount)
            if doesExportExistInResource(Society.FD_BANKING, 'AddMoney') then
                return exports[Society.FD_BANKING]:AddMoney(business, amount)
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
            return account
        end
    end
end)
