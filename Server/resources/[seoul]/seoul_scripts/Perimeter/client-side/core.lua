if SeoulScriptsClient and not SeoulScriptsClient.Enabled('Perimeter') then return end

local SvPerimeter = Tunnel.getInterface('perimeter')
local Blip = {}
local Notified = false
local Perimeters = {}

local function drawOne(selected,data)
    if Blip[selected] and DoesBlipExist(Blip[selected]) then RemoveBlip(Blip[selected]) end
    local c = data.Coords
    local coords = type(c) == 'vector3' and c or vec3(c.x or c[1], c.y or c[2], c.z or c[3])
    Blip[selected] = AddBlipForRadius(coords, (tonumber(data.Distance) or 30.0) + 0.0)
    SetBlipAlpha(Blip[selected], 200)
    SetBlipColour(Blip[selected], 1)
end

RegisterNetEvent('perimeter:Remove')
AddEventHandler('perimeter:Remove', function(selected)
    if Blip[selected] and DoesBlipExist(Blip[selected]) then RemoveBlip(Blip[selected]) end
    Blip[selected] = nil
    Perimeters[selected] = nil
end)

RegisterNetEvent('perimeter:Add')
AddEventHandler('perimeter:Add', function(selected,data)
    Perimeters[selected] = data
    drawOne(selected,data)
end)

RegisterNetEvent('perimeter:List')
AddEventHandler('perimeter:List', function(list)
    for _,blip in pairs(Blip) do if DoesBlipExist(blip) then RemoveBlip(blip) end end
    Blip = {}
    Perimeters = list or {}
    for selected,data in pairs(Perimeters) do drawOne(selected,data) end
end)

RegisterCommand('perimetro', function()
    local input = lib.inputDialog('Perímetro Policial', {
        { type = 'input', label = 'Nome', required = true, min = 3, max = 32 },
        { type = 'number', label = 'Distância', required = true, default = 50, min = 3, max = 500 }
    })
    if input then
        TriggerServerEvent('perimeter:New', input[1], tonumber(input[2]))
    end
end)

RegisterCommand('perimetros', function()
    local list = SvPerimeter.Perimeters() or {}
    local options = {}
    for selected,data in pairs(list) do
        options[#options+1] = {
            title = data.Name or selected,
            description = ('Raio: %sm | Criado por passaporte %s'):format(data.Distance or '?', data.Passport or '?'),
            icon = 'fa-solid fa-triangle-exclamation',
            onSelect = function()
                TriggerServerEvent('perimeter:Remove', selected)
            end
        }
    end
    if #options == 0 then options[#options+1] = { title = 'Nenhum perímetro ativo' } end
    lib.registerContext({ id = 'seoul_perimeters', title = 'Perímetros', options = options })
    lib.showContext('seoul_perimeters')
end)

AddEventHandler('perimeter:Dynamic', function()
    ExecuteCommand('perimetros')
end)

CreateThread(function()
    Wait(2000)
    local ok,list = pcall(function() return SvPerimeter.Perimeters() end)
    if ok and list then TriggerEvent('perimeter:List', list) end
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for selected,blip in pairs(Blip) do
            local data = Perimeters[selected]
            if data and DoesBlipExist(blip) then
                local dist = #(coords - GetBlipCoords(blip))
                if dist <= (tonumber(data.Distance) or 30.0) and Notified ~= selected then
                    Notified = selected
                    TriggerEvent('Notify','Atenção','Você entrou em uma área de circulação restrita.',10000)
                elseif Notified == selected and dist > (tonumber(data.Distance) or 30.0) then
                    Notified = false
                    TriggerEvent('Notify','Aviso','Você saiu da área de circulação restrita.',8000)
                end
            end
        end
        Wait(1000)
    end
end)
