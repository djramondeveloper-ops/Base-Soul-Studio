-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CONTROLLER - COMPAT CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel") or {}
Proxy = module("vrp","lib/Proxy") or {}
vRP = Proxy.getInterface("vRP")

ControllerCompat = {}
Tunnel.bindInterface("ControllerCompat",ControllerCompat)

function SeoulRegisterCommand(name, callback, restricted)
    local key = string.lower(tostring(name or ""))
    if Config.DisabledCommands and Config.DisabledCommands[key] then return false end
    RegisterCommand(name,callback,restricted or false)
    return true
end

function ControllerCompat.GetPosition()
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    return c.x,c.y,c.z,GetEntityHeading(ped)
end

function ControllerCompat.Teleport(x,y,z)
    local ped = PlayerPedId()
    local entity = ped
    if IsPedInAnyVehicle(ped,false) then entity = GetVehiclePedIsIn(ped,false) end
    SetEntityCoords(entity,tonumber(x) or 0.0,tonumber(y) or 0.0,tonumber(z) or 0.0,false,false,false,false)
    return true
end

function ControllerCompat.SetArmour(value)
    SetPedArmour(PlayerPedId(),math.max(0,math.min(100,tonumber(value) or 0)))
end

function ControllerCompat.SetHealth(value)
    SetEntityHealth(PlayerPedId(),tonumber(value) or 200)
end

function ControllerCompat.Kill()
    SetEntityHealth(PlayerPedId(),0)
end

function ControllerCompat.SetModel(model)
    local hash = type(model) == "number" and model or GetHashKey(tostring(model))
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then return false end
    RequestModel(hash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < timeout do Wait(0) end
    if not HasModelLoaded(hash) then return false end
    SetPlayerModel(PlayerId(),hash)
    SetModelAsNoLongerNeeded(hash)
    return true
end

function ControllerCompat.GetWeapons()
    -- OX controla as armas como itens; não convertemos arma nativa em item automaticamente.
    return {}
end

function ControllerCompat.ClearWeapons()
    RemoveAllPedWeapons(PlayerPedId(),true)
end

function ControllerCompat.RemoveObjects()
    ClearPedTasks(PlayerPedId())
end

function ControllerCompat.NoClip()
    -- /nc nativo da Seoul fica como dono desta função; comando legado é desativado por padrão.
    ExecuteCommand("nc")
end

function ControllerCompat.Prompt(title, default)
    if lib and lib.inputDialog then
        local result = lib.inputDialog(title or "Entrada",{{ type="input", label=title or "Valor", default=default or "" }})
        return result and result[1] or ""
    end
    return ""
end

-- Aliases usados pelos clients antigos do Controller.
function vRP.activePlayers()
    local out = {}
    for _,player in ipairs(GetActivePlayers()) do out[#out+1] = GetPlayerServerId(player) end
    return out
end

local function nearestVehicle(radius)
    local ped = PlayerPedId(); local coords = GetEntityCoords(ped)
    local best,bestDist = 0,tonumber(radius) or 7.0
    for _,veh in ipairs(GetGamePool("CVehicle")) do
        local dist = #(coords-GetEntityCoords(veh))
        if dist < bestDist then best,bestDist = veh,dist end
    end
    if best == 0 then return false end
    return best,NetworkGetNetworkIdFromEntity(best)
end
vRP.getNearestVehicle = nearestVehicle
vRP.getNearVehicle = nearestVehicle



-- Animações esperadas pelos clients legados do Controller.
function vRP.playAnim(upper, sequence, looping)
    local ped = PlayerPedId()
    if type(sequence) ~= "table" then return false end

    if sequence.task then
        TaskStartScenarioInPlace(ped,tostring(sequence.task),0,true)
        return true
    end

    local dict = sequence[1]
    local name = sequence[2]
    if not dict or not name then return false end

    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do Wait(0) end
    if not HasAnimDictLoaded(dict) then return false end

    local flags = 0
    if looping then flags = flags + 1 end
    if upper then flags = flags + 48 end
    TaskPlayAnim(ped,dict,name,8.0,-8.0,-1,flags,0.0,false,false,false)
    return true
end

function vRP.stopAnim(upper)
    local ped = PlayerPedId()
    if upper then
        ClearPedSecondaryTask(ped)
    else
        ClearPedTasks(ped)
    end
end

function vRP.prompt(title,value)
    if lib and lib.setClipboard then
        lib.setClipboard(tostring(value or ""))
        TriggerEvent("Notify","sucesso","Coordenadas copiadas.",3000)
    end
    return value
end

-- Export mínimo disponível mesmo com o módulo Survival legado desligado.
-- Survival, quando ativado, pode sobrescrever este export com a tela/estado de morte completa.
exports("Revive",function(health)
    local ped = PlayerPedId()
    local value = tonumber(health) or 200
    local coords = GetEntityCoords(ped)
    if IsEntityDead(ped) or GetEntityHealth(ped) <= 100 then
        NetworkResurrectLocalPlayer(coords.x,coords.y,coords.z,GetEntityHeading(ped),true,false)
        ped = PlayerPedId()
    end
    SetEntityInvincible(ped,false)
    SetEntityHealth(ped,value)
    ClearPedTasksImmediately(ped)
    ClearPedBloodDamage(ped)
    LocalPlayer.state:set("Invincible",false,false)
end)
