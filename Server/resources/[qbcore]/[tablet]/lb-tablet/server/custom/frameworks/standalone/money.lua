if Config.Framework ~= "standalone" then
    return
end

function RemoveMoney(source, amount)
    return true
end

function FrameworkBillPlayer(billerIdentifier, billedIdentifier, job, amount, reason)
    return true
end
