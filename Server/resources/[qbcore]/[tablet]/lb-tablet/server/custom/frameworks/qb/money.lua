if Config.Framework ~= "qb" then
    return
end

while not QB do
    Wait(0)
end

function GetBalance(source)
    local qPlayer = QB.Functions.GetPlayer(tonumber(source))

    if not qPlayer then
        return 0
    end

    return qPlayer.Functions.GetMoney("bank") or 0
end

function AddMoney(source, amount)
    local qPlayer = QB.Functions.GetPlayer(source)
    if not qPlayer or amount < 0 then
        return false
    end

    qPlayer.Functions.AddMoney("bank", math.floor(amount + 0.5), "Tablet")
    return true
end

function RemoveMoney(source, amount)
    if amount < 0 or GetBalance(source) < amount then
        return false
    end

    local qPlayer = QB.Functions.GetPlayer(tonumber(source))

    if not qPlayer then
        return false
    end

    QB.Functions.GetPlayer(source).Functions.RemoveMoney("bank", math.floor(amount + 0.5), "Tablet")

    return true
end

function FrameworkBillPlayer(billerIdentifier, billedIdentifier, job, amount, reason)
    local target = QB.Functions.GetPlayerByCitizenId(billedIdentifier)

    if not target then
        return false
    end

    target.Functions.RemoveMoney("bank", amount, "paid-bills")

    exports["qb-banking"]:AddMoney(job, amount)

    return true
end
