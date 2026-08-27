local Tunnel = module("vrp", "lib/Tunnel")
local vRPC = Tunnel.getInterface("vRP")

local function dynamicShops()
    local consult = vRP.Query("entitydata/GetData", { Name = "Skinshop" })
    return consult and consult[1] and json.decode(consult[1].Information) or {}
end

function func.getDynamicShops()
    return dynamicShops()
end

exports("Add", function(data)
    local shops = dynamicShops()
    shops[#shops + 1] = data
    vRP.Query("entitydata/SetData", { Name = "Skinshop", Information = json.encode(shops) })
    TriggerClientEvent("nation_skinshop:Insert", -1, data)
end)

RegisterNetEvent("skinshop:Send", function()
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local target = vRPC.ClosestPed(source)
    if not target or vRP.GetHealth(target) <= 100 or vRP.ModelPlayer(source) ~= vRP.ModelPlayer(target) then
        TriggerClientEvent("Notify", source, "Aviso", "Vestimentas recusadas.", "amarelo", 5000)
        return
    end

    if vRP.Request(target, "Vestimentas", "Aceitar as vestimentas recebidas?") then
        TriggerClientEvent("skinshop:Apply", target, fclient.getCloths(source), true)
    end
end)

RegisterNetEvent("skinshop:Remove", function(mode)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and vRP.HasService(Passport, "Emergencia") then
        local target = vRPC.ClosestPed(source)
        if target then TriggerClientEvent("skinshop:set" .. tostring(mode), target) end
    end
end)
