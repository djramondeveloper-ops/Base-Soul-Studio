if SeoulScriptsServer and not SeoulScriptsServer.Enabled('Perimeter') then return end

Creative = {}
Tunnel.bindInterface('perimeter', Creative)

local Perimeters = {}
local SaveKey = 'Seoul:Perimeters'

local function loadPerimeters()
    local consult = {}
    if vRP and vRP.GetSrvData then
        local ok,result = pcall(vRP.GetSrvData, SaveKey, true)
        if ok and result then consult = result end
    end
    if type(consult) == 'string' then
        local ok,decoded = pcall(json.decode, consult)
        consult = ok and decoded or {}
    end
    Perimeters = type(consult) == 'table' and consult or {}
end

local function savePerimeters()
    if vRP and vRP.SetSrvData then
        pcall(vRP.SetSrvData, SaveKey, Perimeters, true)
    end
end

CreateThread(function()
    Wait(1500)
    loadPerimeters()
    TriggerClientEvent('perimeter:List', -1, Perimeters)
end)

function Creative.Perimeters()
    return Perimeters
end

RegisterServerEvent('perimeter:New')
AddEventHandler('perimeter:New', function(name,distance)
    local source = source
    local passport = SeoulScriptsServer.Passport(source)
    if not passport or not SeoulScriptsServer.HasPermission(passport, SeoulScripts.Permissions.Police) then return end
    name = tostring(name or ''):sub(1,32)
    distance = tonumber(distance)
    if #name < 3 then return SeoulScriptsServer.Notify(source,'aviso','O nome do perímetro deve ter ao menos 3 caracteres.',8000) end
    if not distance or distance < 3 or distance > 500 then return SeoulScriptsServer.Notify(source,'aviso','Distância inválida.',8000) end

    local selected
    repeat selected = SeoulScriptsServer.RandomString(8) until not Perimeters[selected]
    local coords = GetEntityCoords(GetPlayerPed(source))
    Perimeters[selected] = { Passport = passport, Name = name, Distance = distance, Coords = { x = coords.x, y = coords.y, z = coords.z } }
    savePerimeters()
    TriggerClientEvent('perimeter:Add', -1, selected, Perimeters[selected])
    TriggerClientEvent('Notify', -1, 'Informativo Policial', 'O perímetro <b>'..name..'</b> encontra-se fechado para circulação.', 'police', 15000)
end)

RegisterServerEvent('perimeter:Remove')
AddEventHandler('perimeter:Remove', function(selected)
    local source = source
    local passport = SeoulScriptsServer.Passport(source)
    if not passport or not SeoulScriptsServer.HasPermission(passport, SeoulScripts.Permissions.Police) then return end
    selected = tostring(selected or '')
    if not Perimeters[selected] then return end
    local name = Perimeters[selected].Name or selected
    Perimeters[selected] = nil
    savePerimeters()
    TriggerClientEvent('perimeter:Remove', -1, selected)
    TriggerClientEvent('Notify', -1, 'Informativo Policial', 'O perímetro <b>'..name..'</b> encontra-se liberado.', 'police', 15000)
end)

AddEventHandler('Connect', function(_,source)
    TriggerClientEvent('perimeter:List', source, Perimeters)
end)
