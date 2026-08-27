-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CONTROLLER - COMPAT SERVER
-- Bridge local do Controller para a base Seoul (vRP/Creative + OX + Nation).
-- Não depende dos antigos resources externos do pacote original.
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel") or {}
Proxy = module("vrp","lib/Proxy") or {}
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

-- Carrega apenas o catálogo de veículos da própria vRP para VehicleExist/VehicleWeight.
module("vrp","config/Vehicle")

-- Webhooks são opcionais. O Controller não depende de um resource/config externo para iniciar.
Webhooks = type(Webhooks) == "table" and Webhooks or {}

local SeoulCore = Proxy.getInterface("Seoul")
local ControllerClient = Tunnel.getInterface("ControllerCompat")

-- Queries exclusivas deste resource; evitam SQL solto e aliases antigos.
vRP.Prepare("controller/SetWhitelist","UPDATE accounts SET Whitelist = @Whitelist WHERE License = @License")
vRP.Prepare("controller/DeletePlayerData","DELETE FROM playerdata WHERE Passport = @Passport AND Name = @Name")

local function notify(src, kind, title, message, time)
    if not src or src <= 0 then return end
    if message == nil then
        message = title
        title = kind
    end
    TriggerClientEvent("Notify", src, kind or "aviso", title or "Controller", message or "", time or 5000)
end

function SeoulRegisterCommand(name, callback, restricted)
    local key = string.lower(tostring(name or ""))
    if Config.DisabledCommands and Config.DisabledCommands[key] then
        return false
    end
    RegisterCommand(name, callback, restricted or false)
    return true
end

local function resolvePermission(permission)
    local alias = Config.PermissionAliases and Config.PermissionAliases[permission]
    if alias then return alias.group, alias.level end
    return permission, nil
end

function SeoulHasPermission(passport, permission, level)
    passport = parseInt(passport)
    if passport <= 0 or not permission then return false end

    local group, mappedLevel = resolvePermission(permission)
    local requiredLevel = level or mappedLevel

    -- Grupos diretos (Admin, LSPD, PRPD, Paramedic etc.).
    if vRP.HasPermission(passport, group, requiredLevel) then
        return true
    end

    -- Grupos agregadores da Seoul (ex.: Police -> LSPD/PRPD).
    -- HasPermission consulta somente Permissions:<grupo> e por isso não resolve
    -- os pais configurados em Groups[group].Permission.
    if vRP.HasGroup and vRP.HasGroup(passport, group, requiredLevel) then
        return true
    end

    return false
end

function SeoulHasAnyPermission(passport, permissions)
    if type(permissions) ~= "table" then return SeoulHasPermission(passport, permissions) end
    for _,permission in pairs(permissions) do
        if SeoulHasPermission(passport, permission) then return true end
    end
    return false
end

function HasPermission(source,command)
    local rule = Config.Admin and Config.Admin[command]
    if not rule then return false end
    if rule == "console" then return source == 0 end
    if source == 0 then return true end
    local passport = vRP.getUserId(source)
    if not passport then return false end
    if type(rule) == "string" then return SeoulHasPermission(passport,rule) end
    if type(rule) == "table" then return SeoulHasAnyPermission(passport,rule) end
    return false
end

-- Somente neste resource: traduz contratos de permissão vRP antiga para a Seoul.
vRP.hasPermission = SeoulHasPermission
vRP.hasAnyPermission = SeoulHasAnyPermission

function vRP.getUsersByPermission(permission)
    local group = resolvePermission(permission)
    local players = vRP.NumPermission(group)
    local list = {}
    for passport in pairs(players or {}) do list[#list + 1] = parseInt(passport) end
    return list
end

function vRP.numPermission(permission)
    local group = resolvePermission(permission)
    local players = vRP.NumPermission(group) or {}
    local list = {}
    for passport in pairs(players) do list[#list + 1] = parseInt(passport) end
    table.sort(list)
    return list
end

function vRP.getGroup(name)
    local groups = SeoulCore.groups() or {}
    return groups[name]
end

function vRP.getGroupTitle(name, level)
    local group = vRP.getGroup(name)
    if not group then return name end
    return (group.Hierarchy and group.Hierarchy[parseInt(level)]) or group.Name or name
end

function vRP.format(value)
    local left,num,right = tostring(parseInt(value)):match('^([^%d]*%d)(%d*)(.-)$')
    if not left then return tostring(value or 0) end
    return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function vRP.getTimers(seconds)
    seconds = math.max(0, parseInt(seconds))
    local days = math.floor(seconds / 86400); seconds = seconds % 86400
    local hours = math.floor(seconds / 3600); seconds = seconds % 3600
    local minutes = math.floor(seconds / 60)
    if days > 0 then return ("%dd %02dh %02dm"):format(days,hours,minutes) end
    if hours > 0 then return ("%02dh %02dm"):format(hours,minutes) end
    return ("%dm"):format(minutes)
end

function vRP.getPremium(passport)
    return SeoulHasPermission(passport,"Ouro") or SeoulHasPermission(passport,"Prata") or SeoulHasPermission(passport,"Bronze")
end

function vRP.getSalaryByGroup(group, level)
    local data = vRP.getGroup(group)
    return data and data.Salary and data.Salary[parseInt(level)] or 0
end

function vRP.wantedReturn() return false end
function vRP.reposeReturn() return false end
function vRP.reposeTimer() return true end

function vRP.setBankMoney(passport, amount)
    passport = parseInt(passport); amount = math.max(0,parseInt(amount))
    local current = vRP.GetBank(passport) or 0
    if amount > current then return vRP.GiveBank(passport,amount-current) end
    if amount < current then return vRP.RemoveBank(passport,current-amount) end
    return true
end

function vRP.addGmsId(passport, amount)
    return vRP.GiveGemstone and vRP.GiveGemstone(parseInt(passport),parseInt(amount)) or false
end

function vRP.kick(passport, reason)
    local src = vRP.Source(parseInt(passport))
    if src then return vRP.Kick(src, reason or "Desconectado.") end
    return false
end

function vRP.modelPlayer(src) return vRP.ModelPlayer(src) end

function vRP.request(src, message, timeout)
    return vRP.Request(src,"Confirmação",tostring(message or ""))
end

function vRP.prompt(src, title, default)
    return ControllerClient.Prompt(src,tostring(title or "Entrada"),tostring(default or "")) or ""
end

function vRP.createWeebHook(webhook, message)
    if type(webhook) ~= "string" or webhook == "" or not webhook:match("^https?://") then return false end
    PerformHttpRequest(webhook,function() end,"POST",json.encode({ content = tostring(message or "") }),{ ["Content-Type"] = "application/json" })
    return true
end

function vRP.setWhitelist(passport, value)
    passport = parseInt(passport)
    local rows = vRP.Query("characters/Person",{ Passport = passport })
    local row = rows and rows[1]
    if not row or not row.License then return false end
    vRP.Query("controller/SetWhitelist",{ Whitelist = value and parseInt(value) > 0 and 1 or 0, License = row.License })
    return true
end

function vRP.addUserVehicle(passport, model)
    passport = parseInt(passport); model = tostring(model or "")
    if model == "" or (VehicleExist and not VehicleExist(model)) then return false end
    vRP.Query("vehicles/addVehicles",{
        Passport = passport, Vehicle = model, Plate = vRP.GeneratePlate(),
        Weight = VehicleWeight and VehicleWeight(model) or 50, Work = 0, Save = 1
    })
    return true
end

function SeoulAddTempVehicle(passport, model, days)
    passport = parseInt(passport); model = tostring(model or ""); days = math.max(1,parseInt(days))
    if model == "" or (VehicleExist and not VehicleExist(model)) then return false end
    vRP.Query("vehicles/rentalVehicles",{
        Passport = passport, Vehicle = model, Plate = vRP.GeneratePlate(), Days = days,
        Weight = VehicleWeight and VehicleWeight(model) or 50, Work = 0, Save = 1
    })
    return true
end

function SeoulRemoveVehicle(passport, model)
    passport = parseInt(passport); model = tostring(model or "")
    local rows = vRP.Query("vehicles/UserVehicles",{ Passport = passport }) or {}
    local found = false
    for _,row in pairs(rows) do if row.Vehicle == model then found = true break end end
    if not found then return false end
    vRP.Query("vehicles/removeVehicles",{ Passport = passport, Vehicle = model })
    return true
end


function SeoulDeletePlayerData(passport,name)
    passport = parseInt(passport)
    name = tostring(name or "")
    if passport <= 0 or name == "" then return false end
    vRP.Query("controller/DeletePlayerData",{ Passport = passport, Name = name })
    return true
end

function vRP.updateSelectSkin(passport, model)
    vRP.Query("characters/SetSkin",{ Passport = parseInt(passport), Skin = tostring(model) })
    return true
end

function vRP.insertPermission(passport, group, level) return vRP.SetPermission(parseInt(passport),group,parseInt(level) > 0 and parseInt(level) or 1) end
function vRP.removePermission(passport, group) return vRP.RemovePermission(parseInt(passport),group) end

-- Assinaturas antigas usadas neste Controller; evita interpretar booleano como slot do OX.
function vRP.giveInventoryItem(passport,item,amount,notify,slot,metadata)
    if type(slot) == "boolean" then slot = nil end
    return vRP.GenerateItem(parseInt(passport),item,parseInt(amount),notify,slot,metadata)
end

function vRP.tryGetInventoryItem(passport,item,amount,slot,notify,metadata)
    if type(slot) == "boolean" and notify == nil then notify = slot; slot = nil end
    return vRP.TakeItem(parseInt(passport),item,parseInt(amount),notify,slot,metadata)
end

-- Compatibilidade vRPclient antiga usada internamente pelo Controller.
vRPclient = setmetatable({}, { __index = function(_,key) return vRPC[key] end })
function vRPclient.getHealth(src) return vRP.GetHealth(src) end
function vRPclient.inVehicle(src) return vRP.InsideVehicle(src) end
function vRPclient.nearestPlayer(src, radius) return vRPC.ClosestPed(src,radius or 2.0) end
function vRPclient.getNearestPlayer(src, radius) return vRPC.ClosestPed(src,radius or 2.0) end
function vRPclient.getNearVehicle(src, radius) return vRPC.VehicleList(src,radius or 7.0) end
function vRPclient.vehList(src, radius) return vRPC.VehicleList(src,radius or 7.0) end
function vRPclient.getPositions(src) return ControllerClient.GetPosition(src) end
function vRPclient.teleport(src,x,y,z) return ControllerClient.Teleport(src,x,y,z) end
function vRPclient.setArmour(src,value) return ControllerClient.SetArmour(src,value) end
function vRPclient.setHealth(src,value) return ControllerClient.SetHealth(src,value) end
function vRPclient.killGod(src) return ControllerClient.Kill(src) end
function vRPclient.Skin(src,model) return ControllerClient.SetModel(src,model) end
function vRPclient.getWeapons(src) return ControllerClient.GetWeapons(src) or {} end
function vRPclient.clearWeapons(src) return ControllerClient.ClearWeapons(src) end
function vRPclient._clearWeapons(src) ControllerClient._ClearWeapons(src) end
function vRPclient._removeObjects(src) ControllerClient._RemoveObjects(src) end
function vRPclient.noClip(src) return ControllerClient.NoClip(src) end
function vRPclient.playAnim(src,upper,sequence,loop) return vRPC.playAnim(src,upper,sequence,loop) end
function vRPclient._playAnim(src,upper,sequence,loop) vRPC._playAnim(src,upper,sequence,loop) end
function vRPclient.stopAnim(src,upper) return vRPC.stopAnim(src,upper) end
function vRPclient._stopAnim(src,upper) vRPC._stopAnim(src,upper) end
function vRPclient.playSound(src,name,set) return vRPC.PlaySound(src,name,set) end

-- Cuff/uncuff usa os arquivos reais existentes em [system]/sounds.
function SeoulPlayInteractSound(src, sound, volume)
    if GetResourceState("sounds") == "started" then
        TriggerClientEvent("InteractSound_CL:PlayOnOne",src,sound,volume or 0.5)
    else
        vRPC.PlaySound(src,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET")
    end
end

-- O xsound existe na base do usuário e fica disponível para scripts que o chamarem.
-- O Controller original não chama xsound diretamente, portanto não inventamos URLs/arquivos aqui.
function SeoulHasXSound()
    return GetResourceState("xsound") == "started"
end

-- Remoção de NPC protegida server-side.
RegisterNetEvent("tryDeleteEntity",function(netId)
    local src = source
    local passport = vRP.Passport(src)
    if not passport or not SeoulHasPermission(passport,"admin.permissao") then return end
    netId = parseInt(netId)
    if netId <= 0 then return end
    local ent = NetworkGetEntityFromNetworkId(netId)
    if not ent or ent == 0 or not DoesEntityExist(ent) or GetEntityType(ent) ~= 1 or IsPedAPlayer(ent) then return end
    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped)-GetEntityCoords(ent)) > 25.0 then return end
    DeleteEntity(ent)
end)

-- Bucket somente para os teleportes cadastrados; ignora source/bucket arbitrários enviados pelo client.
RegisterNetEvent("Controller:TeleportBucket",function(mode,bucket)
    local src = source
    bucket = parseInt(bucket)
    local cfg = Config.BucketTeleports and Config.BucketTeleports[bucket]
    if not cfg then return end
    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local coords = GetEntityCoords(ped)
    if mode == "Enter" then
        if #(coords-cfg.enter) > 5.0 then return end
        SetPlayerRoutingBucket(src,bucket)
        Player(src).state:set("Route",bucket,true)
    elseif mode == "Exit" then
        if #(coords-cfg.exit) > 5.0 then return end
        SetPlayerRoutingBucket(src,0)
        Player(src).state:set("Route",0,true)
    end
end)

print("^2[Controller Seoul]^7 compat carregado (vRP + OX + Nation).")
