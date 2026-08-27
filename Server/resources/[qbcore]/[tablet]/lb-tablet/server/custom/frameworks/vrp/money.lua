if Config.Framework ~= "vrp" then return end

function GetBalance(source)
    local id = vRP.Passport(source)
    return id and (vRP.GetBank(id) or 0) or 0
end
function AddMoney(source, amount)
    local id = vRP.Passport(source); amount = math.floor(tonumber(amount) or 0)
    if not id or amount <= 0 then return false end
    vRP.GiveBank(id, amount, true); return true
end
function RemoveMoney(source, amount)
    local id = vRP.Passport(source); amount = math.floor(tonumber(amount) or 0)
    return id and amount > 0 and vRP.PaymentBank(id, amount, true) or false
end
function FrameworkBillPlayer(billerIdentifier, billedIdentifier, job, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    local billed = passport and passport(billedIdentifier) or tonumber(billedIdentifier)
    local biller = tonumber(billerIdentifier) or 0
    local holder = GetCharacterNameFromIdentifier(biller) or job
    local description = ("%s - %s"):format(holder, reason or "Multa")
    -- Seoul invoices: Passport = emissor, Received = destinatário (mesmo padrão do bank da base).
    return MySQL.insert.await([[INSERT INTO invoices (Passport,Received,Reason,Price,Timestamp) VALUES (?, ?, ?, ?, ?)]],
        { biller, billed, description, amount, os.time() }) ~= nil
end
