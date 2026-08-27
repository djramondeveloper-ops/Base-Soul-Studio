-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ROUBOS - SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local API = {}
Tunnel.bindInterface("seoul_roubos",API)

local activeGeneral = {}
local activeRegister = {}
local registerTimers = {}
local stockadePlates = {}
local blockStockades = {}
local jewelryDrawer = {}
local jewelryTimer = 0
local jewelryCooldown = 0

GlobalState['JewelryStatus'] = GlobalState['JewelryStatus'] or false

local function debugPrint(...)
    if Config.Debug then
        print("[seoul_roubos]", ...)
    end
end

local function notify(source,kind,msg,time)
    TriggerClientEvent("Notify",source,kind or "aviso",msg or "",time or 5000)
end

local function getPassport(source)
    if vRP.Passport then return vRP.Passport(source) end
    if vRP.getUserId then return vRP.getUserId(source) end
    return nil
end

local function itemName(item)
    if vRP.ItemName then return vRP.ItemName(item) end
    if vRP.itemNameList then return vRP.itemNameList(item) end
    return item
end

local function itemAmount(passport,item)
    if vRP.ItemAmount then
        return parseInt(vRP.ItemAmount(passport,item))
    end
    if vRP.InventoryItemAmount then
        local data = vRP.InventoryItemAmount(passport,item)
        if type(data) == "table" then return parseInt(data[1] or 0) end
        return parseInt(data or 0)
    end
    if vRP.getInventoryItemAmount then
        local data = vRP.getInventoryItemAmount(passport,item)
        if type(data) == "table" then return parseInt(data[1] or 0) end
        return parseInt(data or 0)
    end
    return 0
end

local function randomValue(value, fallbackMin, fallbackMax)
    if type(value) == "table" then
        local min = parseInt(value.min or value[1] or fallbackMin or 1)
        local max = parseInt(value.max or value[2] or min)
        if max < min then max = min end
        return math.random(min,max)
    end

    value = parseInt(value or 0)
    if value > 0 then return value end

    fallbackMin = parseInt(fallbackMin or 1)
    fallbackMax = parseInt(fallbackMax or fallbackMin)
    if fallbackMax < fallbackMin then fallbackMax = fallbackMin end
    return math.random(fallbackMin,fallbackMax)
end

local function countKeys(tableData)
    local amount = 0
    for _ in pairs(tableData or {}) do
        amount = amount + 1
    end
    return amount
end

local function giveItem(passport,item,amount)
    amount = parseInt(amount)
    if amount <= 0 then return false end
    if vRP.GenerateItem then return vRP.GenerateItem(passport,item,amount,true) end
    if vRP.giveInventoryItem then return vRP.giveInventoryItem(passport,item,amount,true) end
    return false
end

local function takeItem(passport,item,amount)
    amount = parseInt(amount)
    if amount <= 0 then return true end
    if vRP.TakeItem then return vRP.TakeItem(passport,item,amount,true) end
    if vRP.tryGetInventoryItem then return vRP.tryGetInventoryItem(passport,item,amount,nil,true) end
    if vRP.removeInventoryItem then return vRP.removeInventoryItem(passport,item,amount,nil,true) end
    return false
end

local function copsAmount()
    if vRP.AmountService then
        return parseInt(vRP.AmountService(Config.PolicePermission or "Police"))
    end
    if vRP.NumPermission then
        local _,amount = vRP.NumPermission(Config.PolicePermission or "Police")
        return parseInt(amount or 0)
    end
    return 0
end

local function policeSources()
    local list = {}
    if vRP.NumPermission then
        local service = vRP.NumPermission(Config.PolicePermission or "Police")
        if type(service) == "table" then
            for _,src in pairs(service) do
                if src then list[#list + 1] = src end
            end
        end
    end

    if #list == 0 and vRP.getUsersByPermission then
        local users = vRP.getUsersByPermission(Config.LegacyPolicePermission or "policia.permissao") or {}
        for _,passport in pairs(users) do
            local src = vRP.getUserSource and vRP.getUserSource(passport) or (vRP.Source and vRP.Source(passport))
            if src then list[#list + 1] = src end
        end
    end
    return list
end

local function setWanted(source,passport,seconds)
    seconds = parseInt(seconds or 0)
    if seconds <= 0 then return end
    if vRP.wantedTimer then pcall(vRP.wantedTimer,passport,seconds) end
    TriggerClientEvent("hud:Wanted",source,seconds)
    TriggerEvent("Wanted",source,passport,seconds)
end

local function checkClosestTimer(x,y,z)
    for _,v in pairs(registerTimers) do
        if #(vector3(x,y,z) - vector3(v[1],v[2],v[3])) <= 2.0 and v[4] > os.time() then
            return v[4]
        end
    end
    return false
end

local function callPolice(x,y,z,reason)
    for _,player in pairs(policeSources()) do
        TriggerClientEvent("NotifyPush",player,{
            time = os.date("%H:%M:%S - %d/%m/%Y"),
            text = "Roubo a "..reason.." em andamento.",
            code = 31,
            title = "Roubo a "..reason,
            x = x,
            y = y,
            z = z,
            rgba = {170,80,25}
        })
    end
end

local function logRobbery(passport,name)
    print(("[seoul_roubos] Passport %s iniciou/finalizou roubo: %s"):format(passport or "?", name or "?"))
end

local function normalizeRewardItem(item)
    return item
end

local function buildDropPayment(payment)
    local result = {}
    for _,v in pairs(payment or {}) do
        local item = v.item or v[1]
        if item then
            result[#result + 1] = { item, randomValue(v, 1, 1) }
        end
    end
    return result
end

local function giveRewards(passport,rewards)
    for _,v in pairs(rewards or {}) do
        local item = normalizeRewardItem(v.item or v[1])
        local min = parseInt(v.min or v[2] or 1)
        local max = parseInt(v.max or v[2] or min)
        giveItem(passport,item,math.random(min,max))
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUBOS GERAIS
-----------------------------------------------------------------------------------------------------------------------------------------
function API.startGeneral(robberyId,x,y,z)
    local source = source
    local passport = getPassport(source)
    robberyId = parseInt(robberyId)
    local cfg = Config.gerais and Config.gerais[robberyId]
    if not passport or not cfg then return false end

    local cooldownMode = cfg.type
    if Config.modeCooldown == "unique" then cooldownMode = robberyId end

    if activeGeneral[source] then
        notify(source,"aviso","Você já está roubando.",4000)
        return false
    end

    if cfg._cooldown and cfg._cooldown > os.time() then
        notify(source,"importante","Aguarde <b>"..(cfg._cooldown - os.time()).."</b> segundos.",4000)
        return false
    end

    Config._generalCooldowns = Config._generalCooldowns or {}
    if Config._generalCooldowns[cooldownMode] and Config._generalCooldowns[cooldownMode] > os.time() then
        notify(source,"importante","Aguarde <b>"..(Config._generalCooldowns[cooldownMode] - os.time()).."</b> segundos.",4000)
        return false
    end

    if copsAmount() < parseInt(cfg.cops) then
        notify(source,"aviso","Contingente indisponível, necessário "..cfg.cops.." policiais em serviço.",4000)
        return false
    end

    if itemAmount(passport,cfg.required) < 1 then
        notify(source,"aviso","Você precisa de <b>1x "..itemName(cfg.required).."</b>.",4000)
        return false
    end

    if not takeItem(passport,cfg.required,1) then
        notify(source,"negado","Falha ao consumir o item necessário.",4000)
        return false
    end

    activeGeneral[source] = {
        passport = passport,
        id = robberyId,
        started = os.time(),
        finish = os.time() + parseInt(cfg.time),
        x = cfg.x,
        y = cfg.y,
        z = cfg.z
    }
    Config._generalCooldowns[cooldownMode] = os.time() + parseInt(cfg.cooldown)
    callPolice(x or cfg.x, y or cfg.y, z or cfg.z, cfg.name or "Local")
    logRobbery(passport,cfg.name)
    return true, parseInt(cfg.time)
end

function API.cancelGeneral(robberyId)
    local source = source
    activeGeneral[source] = nil
    return true
end

function API.finishGeneral(robberyId)
    local source = source
    local passport = getPassport(source)
    robberyId = parseInt(robberyId)
    local active = activeGeneral[source]
    local cfg = Config.gerais and Config.gerais[robberyId]
    if not passport or not active or active.id ~= robberyId or not cfg then return false end

    local ped = GetPlayerPed(source)
    if ped and ped > 0 then
        local coords = GetEntityCoords(ped)
        if #(coords - vector3(cfg.x,cfg.y,cfg.z)) > tonumber(cfg.distance or 12.0) + 2.0 then
            activeGeneral[source] = nil
            notify(source,"negado","Roubo cancelado: você saiu do local.",5000)
            return false
        end
    end

    activeGeneral[source] = nil
    setWanted(source,passport,600)
    giveRewards(passport,cfg.itens)
    logRobbery(passport,cfg.name)
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATM E CAIXA
-----------------------------------------------------------------------------------------------------------------------------------------
function API.startATM(x,y,z)
    local source = source
    local passport = getPassport(source)
    if not passport then return false end

    local copAmount = copsAmount()
    if copAmount < parseInt(Config.cashMachine.atm.cops) then
        notify(source,"aviso","Contingente indisponível, necessário "..Config.cashMachine.atm.cops.." policiais em serviço.",4000)
        return false
    end

    local timer = checkClosestTimer(x,y,z)
    if timer then
        notify(source,"aviso","Aguarde "..(vRP.getTimers and vRP.getTimers(timer - os.time()) or tostring(timer - os.time()).."s"),5000)
        return false
    end

    if itemAmount(passport,"c4") < 1 then
        notify(source,"negado","Necessário de 1x C4.",5000)
        return false
    end

    if not takeItem(passport,"c4",1) then return false end
    table.insert(registerTimers,{ x, y, z, os.time() + 120 })
    TriggerClientEvent("cashRegister:updateRegister",-1,registerTimers)
    setWanted(source,passport,300)
    logRobbery(passport,"ATM")
    return true
end

function API.finishATM(x,y,z)
    local source = source
    local passport = getPassport(source)
    if not passport then return false end
    TriggerEvent("ox_inventory:customDrop","Caixinha",buildDropPayment(Config.cashMachine.atm.payment),vector3(x,y,z))
    return true
end

function API.callPolice(x,y,z,reason)
    callPolice(x,y,z,reason or "Roubo")
    return true
end

function API.startRegister(x,y,z)
    local source = source
    local passport = getPassport(source)
    if not passport then return false end

    if copsAmount() < parseInt(Config.cashMachine.machine.cops) then
        notify(source,"importante","Necessário de no mínimo "..Config.cashMachine.machine.cops.." policiais em patrulha.",5000)
        return false
    end

    if activeRegister[source] and activeRegister[source] > os.time() then
        notify(source,"aviso","Aguarde "..(activeRegister[source] - os.time()).." segundos.",5000)
        return false
    end

    local timer = checkClosestTimer(x,y,z)
    if timer then
        notify(source,"aviso","Aguarde "..(vRP.getTimers and vRP.getTimers(timer - os.time()) or tostring(timer - os.time()).."s"),5000)
        return false
    end

    if itemAmount(passport,"lockpick") < 1 then
        notify(source,"negado","Necessário de 1x lockpick.",5000)
        return false
    end

    if not takeItem(passport,"lockpick",1) then return false end
    table.insert(registerTimers,{ x, y, z, os.time() + 120 })
    TriggerClientEvent("cashRegister:updateRegister",-1,registerTimers)
    activeRegister[source] = os.time() + 15
    callPolice(x,y,z,"Caixa Registradora")
    return true
end

function API.finishRegister(x,y,z)
    local source = source
    local passport = getPassport(source)
    if not passport then return false end
    if not activeRegister[source] then return false end
    activeRegister[source] = nil
    giveItem(passport,Config.PaymentItem or "dirtydollar",randomValue(Config.cashMachine.machine.payment,200,500))
    setWanted(source,passport,30)
    logRobbery(passport,"Caixa Registradora")
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- JOALHERIA
-----------------------------------------------------------------------------------------------------------------------------------------
local function setJewelryStatus(status)
    GlobalState:set("JewelryStatus",status,true)
    if Config.JewelryDoors and Config.JewelryDoors.enabled then
        if Config.JewelryDoors.legacyCloseId then
            TriggerEvent("doors:doorsStatistics",Config.JewelryDoors.legacyCloseId,not status)
        end
        if GetResourceState("ox_doorlock") == "started" and Config.JewelryDoors.oxDoorlockId then
            exports.ox_doorlock:setDoorState(Config.JewelryDoors.oxDoorlockId,not status)
        end
    end
end

function API.startJewelry()
    local source = source
    local passport = getPassport(source)
    if not passport then return false end

    if jewelryCooldown > os.time() then
        notify(source,"aviso","Aguarde "..(vRP.getTimers and vRP.getTimers(jewelryCooldown - os.time()) or tostring(jewelryCooldown - os.time()).."s"),5000)
        return false
    end

    if copsAmount() < parseInt(Config.jewelry.cops) then
        notify(source,"aviso","Sistema indisponível no momento, tente mais tarde.",5000)
        return false
    end

    if itemAmount(passport,"c4") < 1 or itemAmount(passport,"bluecard") < 1 then
        notify(source,"aviso","Você não possui <b>c4</b> e um <b>cartão azul</b>.",5000)
        return false
    end

    if not takeItem(passport,"bluecard",1) then return false end
    if not takeItem(passport,"c4",1) then
        giveItem(passport,"bluecard",1)
        return false
    end

    jewelryCooldown = os.time() + 7200
    jewelryTimer = 2700
    callPolice(Config.jewelry.bombLocs[1],Config.jewelry.bombLocs[2],Config.jewelry.bombLocs[3],"Joalheria")
    logRobbery(passport,"Joalheria")
    return true
end

function API.finishJewelryBomb()
    setJewelryStatus(true)
    return true
end

RegisterNetEvent("robberys:jewelry")
AddEventHandler("robberys:jewelry",function(number)
    local source = source
    local passport = getPassport(source)
    number = tostring(number)
    if not passport or jewelryDrawer[number] or not GlobalState['JewelryStatus'] then return end

    jewelryDrawer[number] = true
    TriggerClientEvent("cancelando",source,true)
    vRPclient._playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)
    TriggerClientEvent("Progress",source,10000,"Roubando...")
    Wait(10000)
    Config.jewelry.itens(passport)
    TriggerClientEvent("cancelando",source,false)
    vRPclient._removeObjects(source)
end)

CreateThread(function()
    while true do
        if GlobalState['JewelryStatus'] and jewelryTimer > 0 then
            jewelryTimer = jewelryTimer - 1
            if jewelryTimer <= 0 then
                jewelryDrawer = {}
                setJewelryStatus(false)
            end
        end
        Wait(1000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- STOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
function API.stockadeWithdraw(vehPlate,vehNet)
    local source = source
    local passport = getPassport(source)
    if not passport or not vehPlate then return false end

    if blockStockades[vehPlate] then return false end

    if stockadePlates[vehPlate] == nil then
        if copsAmount() < parseInt(Config.stockade.cops) then
            notify(source,"aviso","Contingente indisponível, necessário "..Config.stockade.cops.." policiais em serviço.",4000)
            return false
        end

        local item = Config.stockade.stockadeItem or "blackcard"
        if itemAmount(passport,item) < 1 then
            notify(source,"importante","Você não possui um <b>"..itemName(item).."</b>.",5000)
            return false
        end

        if not takeItem(passport,item,1) then return false end
        stockadePlates[vehPlate] = 5
        TriggerClientEvent("vrp_stockade:Destroy",-1,vehNet)
        notify(source,"sucesso","Sistema violado e as autoridades foram notificadas.",5000)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        callPolice(coords.x,coords.y,coords.z,"Carro Forte")
        logRobbery(passport,"Carro Forte")
        return true
    end

    if stockadePlates[vehPlate] > 0 then
        stockadePlates[vehPlate] = stockadePlates[vehPlate] - 1
        setWanted(source,passport,30)
        FreezeEntityPosition(GetPlayerPed(source),true)
        TriggerClientEvent("cancelando",source,true)
        vRPclient._playAnim(source,false,{ task = "PROP_HUMAN_BUM_BIN" },true)
        TriggerClientEvent("Progress",source,10000,"Coletando...")
        Wait(10000)
        vRPclient._stopAnim(source,false)
        FreezeEntityPosition(GetPlayerPed(source),false)
        TriggerClientEvent("cancelando",source,false)
        giveItem(passport,Config.stockade.payment.item,randomValue(Config.stockade.payment,15000,30000))
        if stockadePlates[vehPlate] > 0 then
            notify(source,"aviso","Ainda possui dinheiro no carro forte.",5000)
        else
            blockStockades[vehPlate] = true
            TriggerClientEvent("vrp_stockade:Client",-1,blockStockades)
        end
        return true
    end

    notify(source,"negado","Nenhum dinheiro encontrado.",5000)
    return false
end

RegisterNetEvent("vrp_stockade:inputVehicle")
AddEventHandler("vrp_stockade:inputVehicle",function(vehPlate)
    blockStockades[vehPlate] = true
    TriggerClientEvent("vrp_stockade:Client",-1,blockStockades)
end)

AddEventHandler("vRP:playerSpawn",function(passport,source)
    TriggerClientEvent("vrp_stockade:Client",source,blockStockades)
    TriggerClientEvent("cashRegister:updateRegister",source,registerTimers)
    TriggerClientEvent("vrp_jewelry:jewelryFunctionStart",source)
end)

RegisterCommand("seoulroubosstatus",function(source)
    local msg = ("seoul_roubos OK | gerais: %s | joalheria: %s | stockades bloqueados: %s"):format(
        tostring(Config.gerais and #Config.gerais or 0),
        tostring(GlobalState['JewelryStatus']),
        tostring(countKeys(blockStockades))
    )
    if source == 0 then print("[seoul_roubos] "..msg) else notify(source,"sucesso",msg,8000) end
end)
