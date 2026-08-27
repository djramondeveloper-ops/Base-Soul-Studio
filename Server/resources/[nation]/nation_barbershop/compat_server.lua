local function dynamicShops()
    local consult = vRP.Query("entitydata/GetData", { Name = "Barbershop" })
    return consult and consult[1] and json.decode(consult[1].Information) or {}
end

function func.getDynamicShops()
    return dynamicShops()
end

exports("Add", function(data)
    local shops = dynamicShops()
    shops[#shops + 1] = data
    vRP.Query("entitydata/SetData", { Name = "Barbershop", Information = json.encode(shops) })
    TriggerClientEvent("nation_barbershop:Insert", -1, data)
end)
