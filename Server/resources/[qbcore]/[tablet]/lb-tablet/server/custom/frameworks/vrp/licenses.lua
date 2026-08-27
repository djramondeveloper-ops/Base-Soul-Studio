if Config.Framework ~= "vrp" then return end

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `lbtablet_registration_licenses` (
            `character_id` varchar(64) NOT NULL,
            `license` varchar(64) NOT NULL,
            PRIMARY KEY (`character_id`, `license`),
            KEY `license` (`license`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ]])
end)

local function label(t) return Config.VRP.Licenses[t] or t end
function GetLicenseLabel(t) return label(t) end
function GetAllLicenses() local r={} for t,l in pairs(Config.VRP.Licenses) do r[#r+1]={type=t,label=l} end return r end
function AddLicense(identifier, t)
    if not Config.VRP.Licenses[t] then return false end
    MySQL.insert.await("INSERT IGNORE INTO lbtablet_registration_licenses (character_id, license) VALUES (?, ?)", { tostring(identifier), label(t) })
    return true
end
function RevokeLicense(identifier, t)
    return MySQL.update.await("DELETE FROM lbtablet_registration_licenses WHERE character_id = ? AND license = ?", { tostring(identifier), label(t) }) > 0
end
function GetPlayerLicenses(identifier)
    local rows=MySQL.query.await("SELECT license FROM lbtablet_registration_licenses WHERE character_id = ?", { tostring(identifier) }) or {}
    local r={}; for _,row in ipairs(rows) do for t,l in pairs(Config.VRP.Licenses) do if l==row.license then r[#r+1]={type=t,label=l} end end end
    return r
end
