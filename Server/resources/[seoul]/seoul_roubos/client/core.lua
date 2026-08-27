-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ROUBOS - CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
local API = Tunnel.getInterface("seoul_roubos")
local robberyId = 0
local robberyTimer = 0
local startRobbery = false
local machineStart = false
local machineTimer = 0
local machinePosX, machinePosY, machinePosZ = 0.0, 0.0, 0.0
local objectBomb = nil
local registerCoords = {}
local blockStockades = {}
local machines = { "prop_atm_02", "prop_atm_03", "prop_fleeca_atm" }
local registerTargetZones = {}
local interactTargetZones = {}

local function isInteractReady()
    return GetResourceState("interact") == "started"
end

local function isOxTargetReady()
    return GetResourceState("ox_target") == "started"
end

local function addInteractCoords(name, coords, distance, icon, label, cb, canInteract)
    if not isInteractReady() then return false end

    if interactTargetZones[name] then
        exports.interact:removeCoords(interactTargetZones[name])
        interactTargetZones[name] = nil
    end

    interactTargetZones[name] = exports.interact:addCoords(coords,{
        name = name,
        icon = icon,
        label = label,
        distance = distance or 2.0,
        canInteract = canInteract,
        onSelect = cb
    })

    return interactTargetZones[name] ~= nil
end

local function addInteractModel(models, options)
    if not isInteractReady() then return false end

    exports.interact:addModel(models, options)
    return true
end

local function debugPrint(...)
    if Config.Debug then
        print("[seoul_roubos]", ...)
    end
end

local function notify(kind, message, time)
    TriggerEvent("Notify", kind or "aviso", message or "", time or 5000)
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

local function isSafezone()
    return LocalPlayer and LocalPlayer.state and (LocalPlayer.state.Safezone or LocalPlayer.state['Safezone'])
end

local function isPolice()
    return LocalPlayer and LocalPlayer.state and LocalPlayer.state.Police
end

local function validCoord(v)
    if not v or not v.x or not v.y or not v.z then return false end
    if Config.SkipInvalidCoords and (math.abs(v.x) > 10000 or math.abs(v.y) > 10000 or math.abs(v.z) > 2000) then
        return false
    end
    return true
end

local function loadModel(model)
    local hash = type(model) == "number" and model or GetHashKey(model)
    if not IsModelInCdimage(hash) then return false end
    RequestModel(hash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < timeout do
        Wait(10)
    end
    return HasModelLoaded(hash) and hash or false
end

local function deleteObject(obj)
    if obj and DoesEntityExist(obj) then
        TriggerServerEvent("tryDeleteEntity", ObjToNet(obj))
        DeleteEntity(obj)
    end
end

local function playRobAnim()
    vRP._playAnim(false,{"oddjobs@shop_robbery@rob_till","loop"},true)
end

local function stopAnim()
    vRP.removeObjects()
    ClearPedTasks(PlayerPedId())
end

local function addSphere(name, coords, radius, distance, icon, label, cb, canInteract)
    if addInteractCoords(name, coords, distance, icon, label, cb, canInteract) then
        return
    end

    if not isOxTargetReady() then
        debugPrint("interact/ox_target nao iniciado para zone", name)
        return
    end

    exports.ox_target:addSphereZone({
        coords = coords,
        radius = radius or 0.75,
        debug = false,
        options = {
            {
                name = name,
                icon = icon or "fa-solid fa-sack-dollar",
                label = label or "Roubar",
                distance = distance or 2.0,
                canInteract = canInteract,
                onSelect = cb
            }
        }
    })
end

local function registerZoneKey(coords)
    local x = math.floor((coords.x or 0.0) * 10.0 + 0.5)
    local y = math.floor((coords.y or 0.0) * 10.0 + 0.5)
    local z = math.floor((coords.z or 0.0) * 10.0 + 0.5)
    return ("seoul_roubos:register:%s:%s:%s"):format(x, y, z)
end

local function removeRegisterTargetZone(key)
    local zoneId = registerTargetZones[key]
    if zoneId and zoneId ~= key and isOxTargetReady() then
        exports.ox_target:removeZone(zoneId, true)
    end
    registerTargetZones[key] = nil

    if interactTargetZones[key] then
        exports.interact:removeCoords(interactTargetZones[key])
        interactTargetZones[key] = nil
    end
end

local function addRegisterTargetZone(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    local coords = GetEntityCoords(entity)
    local key = registerZoneKey(coords)
    if registerTargetZones[key] then return end

    if addInteractCoords(key, vector3(coords.x, coords.y, coords.z + 0.15), 1.8, "fa-solid fa-cash-register", "Roubar Caixa", function()
        TriggerEvent("cashRegister:robberyMachine")
    end, function()
        return not isPolice() and not isSafezone()
    end) then
        registerTargetZones[key] = key
        return
    end

    if not isOxTargetReady() then return end

    registerTargetZones[key] = exports.ox_target:addSphereZone({
        name = key,
        coords = vector3(coords.x, coords.y, coords.z + 0.15),
        radius = 0.8,
        debug = false,
        options = {
            {
                name = key,
                canInteract = function()
                    return not isPolice() and not isSafezone()
                end,
                distance = 1.8,
                icon = "fa-solid fa-cash-register",
                label = "Roubar Caixa",
                onSelect = function()
                    TriggerEvent("cashRegister:robberyMachine")
                end
            }
        }
    })
end

local function startRegisterTargetScanner()
    CreateThread(function()
        local tillHash = GetHashKey("prop_till_01")

        while isInteractReady() or isOxTargetReady() do
            local seen = {}

            for _, object in ipairs(GetGamePool("CObject")) do
                if DoesEntityExist(object) and GetEntityModel(object) == tillHash then
                    local coords = GetEntityCoords(object)
                    local key = registerZoneKey(coords)
                    seen[key] = true
                    addRegisterTargetZone(object)
                end
            end

            for key in pairs(registerTargetZones) do
                if not seen[key] then
                    removeRegisterTargetZone(key)
                end
            end

            Wait(2500)
        end
    end)
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for key in pairs(registerTargetZones) do
        removeRegisterTargetZone(key)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while not isInteractReady() and not isOxTargetReady() do Wait(500) end
    Wait(1000)

    for id,v in pairs(Config.gerais or {}) do
        local coords = vector3(v.x or 0.0, v.y or 0.0, v.z or 0.0)
        if validCoord(coords) then
            addSphere("seoul_roubos:general:"..id, coords, 0.75, 2.5, "fa-solid fa-sack-dollar", "Roubar "..(v.name or "Local"), function()
                TriggerEvent("seoul_roubos:startGeneral", id)
            end, function()
                return not isPolice() and not isSafezone() and not startRobbery
            end)
        else
            debugPrint("CD invalida ignorada no Config.gerais", id, v.x, v.y, v.z)
        end
    end

    local atmOptions = {
        {
            name = "seoul_roubos:atm",
            canInteract = function()
                return not isPolice() and not isSafezone() and not machineStart
            end,
            distance = 2.0,
            icon = 'fa-solid fa-explosion',
            label = "Explodir ATM",
            onSelect = function()
                TriggerEvent("vrp_cashmachine:machineRobbery")
            end
        }
    }

    if not addInteractModel(machines,atmOptions) and isOxTargetReady() then
        exports.ox_target:addModel(machines,atmOptions)
    end

    startRegisterTargetScanner()

    local stockadeOptions = {
        {
            name = "seoul_roubos:stockade",
            canInteract = function(entity)
                local plate = GetVehicleNumberPlateText(entity)
                return blockStockades[plate] == nil and not isPolice() and not isSafezone()
            end,
            distance = 1.5,
            bones = {"door_pside_r","door_dside_r"},
            icon = "fa-solid fa-sack-dollar",
            label = "Roubar Carro Forte",
            onSelect = function()
                TriggerEvent("robbery:startStockade")
            end
        }
    }

    if not addInteractModel({ GetHashKey("stockade") },stockadeOptions) and isOxTargetReady() then
        exports.ox_target:addModel({ GetHashKey("stockade") },stockadeOptions)
    end

    local bombLoc = Config.jewelry and Config.jewelry.bombLocs
    if bombLoc then
        addSphere("seoul_roubos:jewelry:bomb", vector3(bombLoc[1], bombLoc[2], bombLoc[3]), 0.75, 1.5, "fa-solid fa-bomb", "Roubar Joalheria", function()
            TriggerEvent("robbery:jewelryRobbery")
        end, function()
            return not isPolice() and not isSafezone() and not GlobalState['JewelryStatus']
        end)
    end

    if Config.CreateJewelryDrawerTargets then
        for _,drawer in pairs(Config.JewelryDrawers or {}) do
            addSphere("seoul_roubos:jewelry:drawer:"..drawer.id, drawer.coords, 0.75, 1.0, "fa-solid fa-ring", "Roubar Vitrine", function()
                TriggerServerEvent("robberys:jewelry", tostring(drawer.id))
            end, function()
                return GlobalState['JewelryStatus'] == true
            end)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUBOS GERAIS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("seoul_roubos:startGeneral")
AddEventHandler("seoul_roubos:startGeneral",function(service)
    service = parseInt(service)
    if not service or service <= 0 or startRobbery then return end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local ok, time = API.startGeneral(service, coords.x, coords.y, coords.z)
    if not ok then return end

    if GetResourceState("will_robbery") == "started" then
        local status = exports["will_robbery"]:PlayMinigame("memorygame")
        if not status then
            API.cancelGeneral(service)
            ClearPedTasks(ped)
            notify("negado","Falha ao roubar",5000)
            return
        end
    end

    robberyId = service
    robberyTimer = parseInt(time)
    startRobbery = true
    playRobAnim()
    TriggerEvent("cancelando",true)
    TriggerEvent("Progress",robberyTimer * 1000,"Roubando...")
    SetPedComponentVariation(ped,5,45,0,2)

    CreateThread(function()
        while startRobbery do
            local currentPed = PlayerPedId()
            local cfg = Config.gerais[robberyId]
            local distance = #(GetEntityCoords(currentPed) - vector3(cfg.x,cfg.y,cfg.z))
            if distance > cfg.distance or GetEntityHealth(currentPed) <= 101 then
                startRobbery = false
                TriggerEvent("cancelando",false)
                stopAnim()
                API.cancelGeneral(robberyId)
                return
            end

            robberyTimer = robberyTimer - 1
            if robberyTimer <= 0 then
                startRobbery = false
                TriggerEvent("cancelando",false)
                stopAnim()
                API.finishGeneral(robberyId)
                return
            end
            Wait(1000)
        end
    end)
end)

RegisterNetEvent("robbery:startRobbery")
AddEventHandler("robbery:startRobbery",function(data)
    local service = data and (data.service or data.id or data.args and data.args.service)
    TriggerEvent("seoul_roubos:startGeneral", service)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATM
-----------------------------------------------------------------------------------------------------------------------------------------
local function startMachineThread()
    CreateThread(function()
        while machineStart do
            if machineTimer > 0 then
                machineTimer = machineTimer - 1
                if machineTimer <= 0 then
                    machineStart = false
                    deleteObject(objectBomb)
                    API.finishATM(machinePosX,machinePosY,machinePosZ)
                    AddExplosion(machinePosX,machinePosY,machinePosZ,2,100.0,true,false,1.0)
                end
            end
            Wait(1000)
        end
    end)
end

RegisterNetEvent("vrp_cashmachine:machineRobbery")
AddEventHandler("vrp_cashmachine:machineRobbery",function()
    local ped = PlayerPedId()
    if machineStart or IsPedInAnyVehicle(ped,false) then return end

    local coords = GetEntityCoords(ped)
    for _,model in pairs(machines) do
        local object = GetClosestObjectOfType(coords.x,coords.y,coords.z,1.5,GetHashKey(model),false,false,false)
        if object and DoesEntityExist(object) then
            if API.startATM(coords.x,coords.y,coords.z) then
                local bombCds = GetEntityCoords(object)
                machineStart = true
                machinePosX,machinePosY,machinePosZ = bombCds.x,bombCds.y,bombCds.z

                SetEntityHeading(ped,GetEntityHeading(object))
                TriggerEvent("cancelando",true)
                SetEntityCoords(ped,machinePosX,machinePosY,machinePosZ,false,false,false,false)
                vRP._playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
                Wait(5000)
                stopAnim()
                TriggerEvent("cancelando",false)

                machineTimer = randomValue(Config.cashMachine.atm.timeToExplode,30,40)
                startMachineThread()
                API.callPolice(machinePosX,machinePosY,machinePosZ,"ATM")

                local mHash = loadModel("prop_c4_final_green")
                if mHash then
                    local bombCoords = GetOffsetFromEntityInWorldCoords(object,0.0,-0.2,0.7)
                    objectBomb = CreateObjectNoOffset(mHash,bombCoords.x,bombCoords.y,bombCoords.z,true,false,false)
                    SetEntityAsMissionEntity(objectBomb,true,true)
                    FreezeEntityPosition(objectBomb,true)
                    SetEntityHeading(objectBomb,GetEntityHeading(object))
                    SetModelAsNoLongerNeeded(mHash)
                end
            end
            return
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAIXA REGISTRADORA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cashRegister:robberyMachine")
AddEventHandler("cashRegister:robberyMachine",function()
    local ped = PlayerPedId()
    local coordsPed = GetEntityCoords(ped)

    for _,v in pairs(registerCoords) do
        if #(coordsPed - vector3(v[1],v[2],v[3])) <= 2.0 then
            notify("aviso","Esse caixa foi roubado recentemente.",5000)
            return
        end
    end

    if isSafezone() then
        notify("negado","Não é permitido roubar em SafeZone.",7000)
        return
    end

    if API.startRegister(coordsPed.x,coordsPed.y,coordsPed.z) then
        TriggerEvent("cancelando",true)
        vRP._playAnim(false,{"oddjobs@shop_robbery@rob_till","loop"},true)
        TriggerEvent("Progress",15000,"Roubando...")
        SetPedComponentVariation(ped,5,45,0,2)
        Wait(15000)
        TriggerEvent("cancelando",false)
        stopAnim()
        API.finishRegister(coordsPed.x,coordsPed.y,coordsPed.z)
    end
end)

RegisterNetEvent("cashRegister:updateRegister")
AddEventHandler("cashRegister:updateRegister",function(status)
    registerCoords = status or {}
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- JOALHERIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("robbery:jewelryRobbery")
AddEventHandler("robbery:jewelryRobbery",function()
    if not API.startJewelry() then return end

    local ped = PlayerPedId()
    TriggerEvent("cancelando",true)
    vRP._playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
    Wait(10000)
    stopAnim()
    TriggerEvent("cancelando",false)

    local bombLoc = Config.jewelry.bombLocs
    local mHash = loadModel("prop_c4_final_green")
    local bomb
    if mHash then
        bomb = CreateObjectNoOffset(mHash,bombLoc[1],bombLoc[2],bombLoc[3]-0.3,true,false,false)
        SetEntityAsMissionEntity(bomb,true,true)
        FreezeEntityPosition(bomb,true)
        SetEntityHeading(bomb,bombLoc[4])
        SetModelAsNoLongerNeeded(mHash)
    end

    Wait(20000)
    if bomb then deleteObject(bomb) end
    AddExplosion(bombLoc[1],bombLoc[2],bombLoc[3],2,100.0,true,false,1.0)
    API.finishJewelryBomb()
end)

RegisterNetEvent("vrp_jewelry:jewelryFunctionStart")
AddEventHandler("vrp_jewelry:jewelryFunctionStart",function()
    -- Mantido por compatibilidade com scripts/targets antigos da base.
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- STOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("robbery:startStockade")
AddEventHandler("robbery:startStockade",function()
    local ped = PlayerPedId()
    local vehicle = vRP.getNearVehicle(11)
    if DoesEntityExist(vehicle) and GetEntityModel(vehicle) == GetHashKey("stockade") then
        local plate = GetVehicleNumberPlateText(vehicle)
        SetEntityHeading(ped,GetEntityHeading(vehicle))
        API.stockadeWithdraw(plate,VehToNet(vehicle))
    end
end)

RegisterNetEvent("vrp_stockade:Destroy")
AddEventHandler("vrp_stockade:Destroy",function(vehNet)
    if NetworkDoesNetworkIdExist(vehNet) then
        local vehicle = NetToEnt(vehNet)
        if DoesEntityExist(vehicle) then
            SetVehicleEngineHealth(vehicle,100.0)
            SetVehicleBodyHealth(vehicle,100.0)
            SetVehicleDoorOpen(vehicle,2,true,true)
            SetVehicleDoorOpen(vehicle,3,true,true)
            SetVehicleDoorOpen(vehicle,5,true,true)
        end
    end
end)

RegisterNetEvent("vrp_stockade:Client")
AddEventHandler("vrp_stockade:Client",function(status)
    blockStockades = status or {}
end)
