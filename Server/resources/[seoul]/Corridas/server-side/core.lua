-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - SERVER CORE
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local vRPclient = Tunnel.getInterface("vRP")

local Webhooks = {}
do
    local ok,result = pcall(module,"config/webhooks")
    if ok and type(result) == "table" then
        Webhooks = result
    end
end

SeoulCorridas = {
    Tunnel = Tunnel,
    Proxy = Proxy,
    vRP = vRP,
    vRPclient = vRPclient,
    Webhooks = Webhooks,
    sessions = {}
}

local Core = SeoulCorridas

local function toInt(value)
    if parseInt then return parseInt(value) end
    return math.floor(tonumber(value) or 0)
end

function Core.passport(playerSource)
    if vRP.Passport then
        local ok,result = pcall(vRP.Passport,playerSource)
        if ok and result then return result end
    end

    if vRP.getUserId then
        local ok,result = pcall(vRP.getUserId,playerSource)
        if ok and result then return result end
    end

    return nil
end

function Core.sourceFromPassport(passport)
    if vRP.Source then
        local ok,result = pcall(vRP.Source,passport)
        if ok and result then return result end
    end

    if vRP.getUserSource then
        local ok,result = pcall(vRP.getUserSource,passport)
        if ok and result then return result end
    end

    return nil
end

function Core.notify(playerSource,style,message,time)
    TriggerClientEvent("Notify",playerSource,style or "aviso",message or "",time or 5000)
end

function Core.playerCoords(playerSource)
    local ped = GetPlayerPed(playerSource)
    if not ped or ped <= 0 then return nil end
    return GetEntityCoords(ped)
end

function Core.distanceFrom(playerSource,coords)
    local current = Core.playerCoords(playerSource)
    if not current or not coords then return math.huge end
    return #(current - vector3(coords[1],coords[2],coords[3]))
end

function Core.isWanted(passport)
    if vRP.wantedReturn then
        local ok,result = pcall(vRP.wantedReturn,passport)
        if ok then return result == true end
    end

    return false
end

function Core.setWanted(passport,seconds)
    if vRP.wantedTimer then
        pcall(vRP.wantedTimer,passport,toInt(seconds))
    end
end

function Core.addStress(passport,amount)
    if vRP.upgradeStress then
        pcall(vRP.upgradeStress,passport,toInt(amount))
    end
end

function Core.hasPermission(passport,permission)
    if vRP.HasPermission then
        local ok,result = pcall(vRP.HasPermission,passport,permission)
        if ok and result then return true end
    end

    if vRP.hasPermission then
        local ok,result = pcall(vRP.hasPermission,passport,permission)
        if ok and result then return true end
    end

    return false
end


function Core.oxItemExists(item)
    if GetResourceState("ox_inventory") ~= "started" then return true end

    local ok,result = pcall(function()
        return exports.ox_inventory:Items()
    end)

    if not ok then return true end
    return type(result) == "table" and result[item] ~= nil
end

function Core.takeItem(passport,item,amount,notifyItem)
    amount = toInt(amount or 1)
    if not passport or not item or amount <= 0 then return false end
    if not Core.oxItemExists(item) then return false end

    if vRP.TakeItem then
        local ok,result = pcall(vRP.TakeItem,passport,item,amount,notifyItem ~= false)
        if ok then return result ~= false end
    end

    if vRP.RemoveItem then
        local ok,result = pcall(vRP.RemoveItem,passport,item,amount,notifyItem ~= false)
        if ok then return result ~= false end
    end

    if vRP.tryGetInventoryItem then
        local ok,result = pcall(vRP.tryGetInventoryItem,passport,item,amount,notifyItem ~= false)
        if ok then return result ~= false end
    end

    return false
end

function Core.giveItem(passport,item,amount,notifyItem)
    amount = toInt(amount)
    if not passport or not item or amount <= 0 then return false end
    if not Core.oxItemExists(item) then return false end

    if vRP.GenerateItem then
        local ok,result = pcall(vRP.GenerateItem,passport,item,amount,notifyItem ~= false)
        if ok then return result ~= false end
    end

    if vRP.GiveItem then
        local ok,result = pcall(vRP.GiveItem,passport,item,amount,notifyItem ~= false)
        if ok then return result ~= false end
    end

    if vRP.giveInventoryItem then
        local ok,result = pcall(vRP.giveInventoryItem,passport,item,amount,notifyItem ~= false)
        if ok then return result ~= false end
    end

    return false
end

function Core.policeSources()
    local users = {}
    local permission = (Config.seoul and Config.seoul.policePermission) or "policia.permissao"

    if vRP.getUsersByPermission then
        local ok,result = pcall(vRP.getUsersByPermission,permission)
        if ok and type(result) == "table" then users = result end
    elseif vRP.numPermission then
        local ok,result = pcall(vRP.numPermission,permission)
        if ok and type(result) == "table" then users = result end
    end

    local sources = {}
    local seen = {}
    for key,value in pairs(users) do
        local src = nil

        -- Algumas variantes retornam passports como valores; outras, como chaves.
        if type(value) == "number" or type(value) == "string" then
            src = Core.sourceFromPassport(value)
        end
        if not src and (type(key) == "number" or type(key) == "string") then
            src = Core.sourceFromPassport(key)
        end

        if src and not seen[src] then
            seen[src] = true
            sources[#sources + 1] = src
        end
    end

    return sources
end

function Core.serviceEnter(playerSource)
    -- Mantem os eventos originais; TriggerEvent sem handler e seguro no FiveM.
    TriggerEvent("vrp_blipsystem:serviceEnter",playerSource,"Corredor",75)
end

function Core.serviceExit(playerSource)
    TriggerEvent("vrp_blipsystem:serviceExit",playerSource)
end

function Core.coinSound(playerSource)
    TriggerClientEvent("vrp_sound:source",playerSource,"coin",0.5)
end

function Core.log(message)
    local webhook = Webhooks and Webhooks.webhookraces
    if webhook and webhook ~= "" and vRP.createWeebHook then
        pcall(vRP.createWeebHook,webhook,message)
    end
end

function Core.clearSession(playerSource)
    local session = Core.sessions[playerSource]
    if session then
        Core.sessions[playerSource] = nil
        Core.serviceExit(playerSource)
    end
    return session
end

function Core.beginSession(playerSource,kind,route,startCoords,expiresAt)
    if Core.sessions[playerSource] then
        Core.notify(playerSource,"negado","Você já possui uma corrida em andamento.",5000)
        return false
    end

    if Core.distanceFrom(playerSource,startCoords) > 35.0 then
        return false
    end

    local passport = Core.passport(playerSource)
    if not passport then return false end

    if Core.isWanted(passport) then
        Core.notify(playerSource,"negado","Você não pode iniciar uma corrida enquanto estiver procurado.",5000)
        return false
    end

    local ticket = (Config.seoul and Config.seoul.ticketItem) or "racesticket"
    if not Core.oxItemExists(ticket) then
        Core.notify(playerSource,"negado","O item de ticket nao esta cadastrado no ox_inventory.",5000)
        print(("^1[Corridas]^0 Item ausente no ox_inventory: %s"):format(ticket))
        return false
    end

    if not Core.takeItem(passport,ticket,1,true) then
        Core.notify(playerSource,"negado","Você não possui um ticket de corrida.",5000)
        return false
    end

    Core.sessions[playerSource] = {
        kind = kind,
        route = route,
        checkpoint = 1,
        lap = 1,
        passport = passport,
        startedAt = os.time(),
        expiresAt = expiresAt,
        paid = false
    }

    Core.serviceEnter(playerSource)
    Core.addStress(passport,5)
    return Core.sessions[playerSource]
end

function Core.session(playerSource,kind)
    local session = Core.sessions[playerSource]
    if not session or (kind and session.kind ~= kind) then return nil end
    return session
end

function Core.validateCheckpoint(playerSource,coords,tolerance)
    return Core.distanceFrom(playerSource,coords) <= (tonumber(tolerance) or 18.0)
end

CreateThread(function()
    Wait(1000)
    local items = Config.seoul and {
        Config.seoul.ticketItem,
        Config.seoul.dirtyMoneyItem,
        Config.seoul.moneyItem
    } or {}

    for _,item in ipairs(items) do
        if item and not Core.oxItemExists(item) then
            print(("^1[Corridas]^0 Item configurado nao existe no ox_inventory: %s"):format(item))
        end
    end
end)

AddEventHandler("playerDropped",function()
    Core.clearSession(source)
end)
