-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Society == Society.QB_BANKING then
        SocietyService.GetMoney = function(business)
            local services = {
                {
                    resource = Society.TGG_BANKING,
                    check = "GetSocietyAccountMoney",
                    get = function(business)
                        local account = exports[Society.TGG_BANKING]:GetSocietyAccount(business)
                        if not account then
                            exports[Society.TGG_BANKING]:CreateBusinessAccount(business, 0, business, 'red')
                        end
                        return exports[Society.TGG_BANKING]:GetSocietyAccountMoney(business)
                    end
                },
                {
                    resource = Society.JOBS_CREATOR,
                    check = "getJobAccountMoney",
                    get = function(business)
                        return exports[Society.JOBS_CREATOR]:getJobAccountMoney(business)
                    end
                },
                {
                    resource = Society.QB_MANAGEMENT,
                    check = "GetAccount",
                    get = function(business)
                        return exports[Society.QB_MANAGEMENT]:GetAccount(business)
                    end
                },
                {
                    resource = Society.QB_BANKING,
                    check = "GetAccountBalance",
                    get = function(business)
                        return exports[Society.QB_BANKING]:GetAccountBalance(business)
                    end
                }
            }
            for _, service in ipairs(services) do
                if isResourcePresentProvideless(service.resource) and doesExportExistInResource(service.resource, service.check) then
                    return safeNumber(service.get(business), 0)
                end
            end
            return 0
        end
        SocietyService.RemoveMoney = function(business, amount)
            local services = {
                {
                    resource = Society.TGG_BANKING,
                    check = "RemoveSocietyMoney",
                    call = function(business, amount)
                        return exports[Society.TGG_BANKING]:RemoveSocietyMoney(business, amount)
                    end
                },
                {
                    resource = Society.QB_MANAGEMENT,
                    check = "RemoveMoney",
                    call = function(business, amount)
                        return exports[Society.QB_MANAGEMENT]:RemoveMoney(business, amount)
                    end
                },
                {
                    resource = Society.QB_BANKING,
                    check = "RemoveMoney",
                    call = function(business, amount)
                        return exports[Society.QB_BANKING]:RemoveMoney(business, amount)
                    end
                },
                {
                    resource = Society.JOBS_CREATOR,
                    check = "removeSocietyMoney",
                    call = function(business, amount)
                        return exports[Society.JOBS_CREATOR]:removeSocietyMoney(business, amount)
                    end
                },
            }
            for _, service in ipairs(services) do
                if isResourcePresentProvideless(service.resource) and doesExportExistInResource(service.resource, service.check) then
                    return service.call(business, amount)
                end
            end
            return false
        end
        SocietyService.AddMoney = function(business, amount)
            local services = {
                {
                    resource = Society.TGG_BANKING,
                    check = "AddSocietyMoney",
                    call = function(business, amount)
                        return exports[Society.TGG_BANKING]:AddSocietyMoney(business, amount)
                    end
                },
                {
                    resource = Society.QB_MANAGEMENT,
                    check = "AddMoney",
                    call = function(business, amount)
                        return exports[Society.QB_MANAGEMENT]:AddMoney(business, amount)
                    end
                },
                {
                    resource = Society.QB_BANKING,
                    check = "AddMoney",
                    call = function(business, amount)
                        return exports[Society.QB_BANKING]:AddMoney(business, amount)
                    end
                },
                {
                    resource = Society.JOBS_CREATOR,
                    check = "addSocietyMoney",
                    call = function(business, amount)
                        return exports[Society.JOBS_CREATOR]:addSocietyMoney(business, amount)
                    end
                },
            }
            for _, service in ipairs(services) do
                if isResourcePresentProvideless(service.resource) and doesExportExistInResource(service.resource, service.check) then
                    return service.call(business, amount)
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
        SocietyService.Register = function(businessName)
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
