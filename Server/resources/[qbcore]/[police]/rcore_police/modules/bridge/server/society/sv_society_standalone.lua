-- Seoul Base integration: persistent department accounts on oxmysql.
CreateThread(function()
    if not Config.Society or Config.Society == Society.NONE then
        local TABLE = 'rcore_police_society'

        MySQL.query.await(([=[
            CREATE TABLE IF NOT EXISTS `%s` (
                `department` VARCHAR(64) NOT NULL,
                `balance` BIGINT NOT NULL DEFAULT 0,
                `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`department`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        ]=]):format(TABLE))

        local function normalizeBusiness(business)
            if type(business) ~= 'string' or business == '' then return nil end
            local _, configuredName = GetDepartmentConfig(business)
            return configuredName or business
        end

        SocietyService.Register = function(business)
            business = normalizeBusiness(business)
            if not business then return false end
            MySQL.insert.await(('INSERT IGNORE INTO `%s` (`department`,`balance`) VALUES (?,0)'):format(TABLE), { business })
            return true
        end

        SocietyService.GetMoney = function(business)
            business = normalizeBusiness(business)
            if not business then return 0 end
            SocietyService.Register(business)
            return tonumber(MySQL.scalar.await(('SELECT `balance` FROM `%s` WHERE `department` = ? LIMIT 1'):format(TABLE), { business })) or 0
        end

        SocietyService.AddMoney = function(business, amount)
            business = normalizeBusiness(business)
            amount = math.floor(tonumber(amount) or 0)
            if not business or amount <= 0 then return false end
            SocietyService.Register(business)
            local changed = MySQL.update.await(('UPDATE `%s` SET `balance` = `balance` + ? WHERE `department` = ?'):format(TABLE), { amount, business })
            return (tonumber(changed) or 0) > 0
        end

        SocietyService.RemoveMoney = function(business, amount)
            business = normalizeBusiness(business)
            amount = math.floor(tonumber(amount) or 0)
            if not business or amount <= 0 then return false end
            SocietyService.Register(business)
            local changed = MySQL.update.await(('UPDATE `%s` SET `balance` = `balance` - ? WHERE `department` = ? AND `balance` >= ?'):format(TABLE), { amount, business, amount })
            return (tonumber(changed) or 0) > 0
        end

        SocietyService.GetAccount = function(businessName)
            businessName = normalizeBusiness(businessName)
            if not businessName then return nil end
            SocietyService.Register(businessName)
            return {
                AddMoney = function(amount) return SocietyService.AddMoney(businessName, amount) end,
                RemoveMoney = function(amount) return SocietyService.RemoveMoney(businessName, amount) end,
                GetBalance = function() return SocietyService.GetMoney(businessName) end,
            }
        end

        SocietyService.StoreDepartmentVehicle = function(data, cb)
            local ok = data and SocietyService.AddMoney(data.department, data.spawnPrice)
            if cb then cb(ok == true, data and data.spawnPrice or 0) end
        end

        SocietyService.BuyDepartmentVehicle = function(data, cb)
            if not data then if cb then cb(false, 0) end return end
            local enough = SocietyService.GetMoney(data.department) >= (tonumber(data.spawnPrice) or 0)
            if cb then cb(enough, data.spawnPrice) end
        end
    end
end)
