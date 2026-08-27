-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Alc = {}
Tunnel.bindInterface("alc-spawn", Alc)
vCLIENT = Tunnel.getInterface("alc-spawn")

local passou = {}

function Alc.GetUserId()
    local source = source
    local user_id = vRP.Passport(source)
    local getid = vRP.Datatable(user_id) 

    if not passou[user_id] then
        passou[user_id] = false
    end

    if getid and getid.Pos then
        return getid.Pos 
    end

    return nil 
end

RegisterServerEvent("alc-spawn:markPassed")
AddEventHandler("alc-spawn:markPassed", function()
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        passou[user_id] = true
    end
end)

function Alc.HasPassedSpawn(user_id)
    return passou[user_id] or false
end

RegisterServerEvent("alc-spawn:checkPassed")
AddEventHandler("alc-spawn:checkPassed", function()
    local source = source
    local user_id = vRP.Passport(source)

    if user_id then
        local hasPassed = passou[user_id] or false
        TriggerClientEvent("alc-spawn:receivePassed", source, hasPassed)
    end
end)


