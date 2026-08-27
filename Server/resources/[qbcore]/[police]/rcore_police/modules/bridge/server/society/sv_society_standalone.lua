-- Seoul Base integration: persistent department accounts on oxmysql.
if not Config.Society or Config.Society == Society.NONE then
    local TABLE = 'rcore_police_society'
    local tableReady = false

    local function ensureSocietyTable()
        if tableReady then return true end

        local ok, err = pcall(function()
            MySQL.query.await(([=[
                CREATE TABLE IF NOT EXISTS `%s` (
                    `department` VARCHAR(64) NOT NULL,
                    `balance` BIGINT NOT NULL DEFAULT 0,
                    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (`department`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            ]=]):format(TABLE))
        end)

        if not ok then
            print(('[rcore_police/Seoul] Failed to prepare society table: %s'):format(err))
            return false
        end

        tableReady = true
        return true
    end

    local function normalizeBusiness(business)
        if type(business) ~= 'string' or business == '' then return nil end
        local _, configuredName = GetDepartmentConfig(business)
        return configuredName or business
    end

    SocietyService.Register = function(business)
        business = normalizeBusiness(business)
        if not business or not ensureSocietyTable() then return false end
        MySQL.insert.await(('INSERT IGNORE INTO `%s` (`department`,`balance`) VALUES (?,0)'):format(TABLE), { business })
        return true
    end

    SocietyService.GetMoney = function(business)
        business = normalizeBusiness(business)
        if not business or not SocietyService.Register(business) then return 0 end
        return tonumber(MySQL.scalar.await(('SELECT `balance` FROM `%s` WHERE `department` = ? LIMIT 1'):format(TABLE), { business })) or 0
    end

    SocietyService.AddMoney = function(business, amount)
        business = normalizeBusiness(business)
        amount = math.floor(tonumber(amount) or 0)
        if not business or amount <= 0 or not SocietyService.Register(business) then return false end
        local changed = MySQL.update.await(('UPDATE `%s` SET `balance` = `balance` + ? WHERE `department` = ?'):format(TABLE), { amount, business })
        return (tonumber(changed) or 0) > 0
    end

    SocietyService.RemoveMoney = function(business, amount)
        business = normalizeBusiness(business)
        amount = math.floor(tonumber(amount) or 0)
        if not business or amount <= 0 or not SocietyService.Register(business) then return false end
        local changed = MySQL.update.await(('UPDATE `%s` SET `balance` = `balance` - ? WHERE `department` = ? AND `balance` >= ?'):format(TABLE), { amount, business, amount })
        return (tonumber(changed) or 0) > 0
    end

    SocietyService.GetAccount = function(businessName)
        businessName = normalizeBusiness(businessName)
        if not businessName or not SocietyService.Register(businessName) then return nil end
        return {
            AddMoney = function(amount) return SocietyService.AddMoney(businessName, amount) end,
            RemoveMoney = function(amount) return SocietyService.RemoveMoney(businessName, amount) end,
            GetBalance = function() return SocietyService.GetMoney(businessName) end,
            GetMoney = function() return SocietyService.GetMoney(businessName) end,
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

    CreateThread(ensureSocietyTable)
end
