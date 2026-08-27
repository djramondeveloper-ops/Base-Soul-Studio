local function dynamicShops()
    local consult = vRP.Query("entitydata/GetData", { Name = "Tattooshop" })
    return consult and consult[1] and json.decode(consult[1].Information) or {}
end

function func.getDynamicShops()
    return dynamicShops()
end

exports("Add", function(data)
    local shops = dynamicShops()
    shops[#shops + 1] = data
    vRP.Query("entitydata/SetData", { Name = "Tattooshop", Information = json.encode(shops) })
    TriggerClientEvent("nation_tattoos:Insert", -1, data)
end)
