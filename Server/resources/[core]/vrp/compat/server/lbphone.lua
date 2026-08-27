-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL LB PHONE BRIDGE
-----------------------------------------------------------------------------------------------------------------------------------------
local function owner(Passport)
    return "vrp:" .. tostring(parseInt(Passport))
end

function vRP.Phone(Passport)
    Passport = parseInt(Passport)
    local rows = exports.oxmysql:query_async("SELECT phone_number FROM phone_phones WHERE owner_id = ? LIMIT 1", { owner(Passport) })
    return rows and rows[1] and rows[1].phone_number or "Inativo"
end

function vRP.GetPhone(Passport) return vRP.Phone(Passport) end
function vRP.UserPhone(Passport) return vRP.Phone(Passport) end
function vRP.getPhone(Passport) return vRP.Phone(Passport) end

function vRP.CleanPhone(Passport)
    Passport = parseInt(Passport)
    return exports.oxmysql:query_async("DELETE FROM phone_phones WHERE owner_id = ?", { owner(Passport) })
end

function vRP.DeletePhone(Passport)
    return vRP.CleanPhone(Passport)
end

function vRP.UpgradePhone(Passport, Phone)
    Passport = parseInt(Passport)
    Phone = tostring(Phone or vRP.GeneratePhone())
    local exists = exports.oxmysql:query_async("SELECT phone_number FROM phone_phones WHERE owner_id = ? LIMIT 1", { owner(Passport) })
    if exists and exists[1] then
        exports.oxmysql:update_async("UPDATE phone_phones SET phone_number = ? WHERE owner_id = ?", { Phone, owner(Passport) })
    else
        exports.oxmysql:insert_async("INSERT INTO phone_phones (phone_number, owner_id) VALUES (?, ?)", { Phone, owner(Passport) })
    end
    return Phone
end
vRP.upgradePhone = vRP.UpgradePhone
