local BarberShops = GlobalState['BarberShops']
local barberInteractTargets = {}
local rebuildInteractBarbers

AddStateBagChangeHandler("BarberShops","",function (_,_,value)
    BarberShops = value or {}
    if rebuildInteractBarbers then rebuildInteractBarbers() end
end)

local function isInteractReady()
    return GetResourceState("interact") == "started"
end

local function clearInteractBarbers()
    if not isInteractReady() then
        barberInteractTargets = {}
        return
    end

    for _,id in pairs(barberInteractTargets) do
        pcall(function() exports.interact:removeCoords(id) end)
    end
    barberInteractTargets = {}
end

rebuildInteractBarbers = function()
    clearInteractBarbers()
    if not isInteractReady() then return end

    for index,shop in pairs(BarberShops or {}) do
        if shop.coords then
            local name = "AdminControl:barbershop:"..tostring(index)
            barberInteractTargets[name] = exports.interact:addCoords(vector3(shop.coords.x,shop.coords.y,shop.coords.z),{
                name = name,
                label = "Abrir barbearia",
                icon = "fa-solid fa-scissors",
                distance = 1.5,
                onSelect = function()
                    TriggerEvent("barbershop:Open")
                end
            })
        end
    end
end

CreateThread(function()
    while not isInteractReady() do Wait(1000) end
    Wait(500)
    rebuildInteractBarbers()
end)

local function createBarberShop()
    local groups = ServerControl.getGroups()
    if groups then
        local input = lib.inputDialog('Registro de barbearia', {
            { type = 'input', label = 'Nome', description = 'Nome da loja', required = true },
            { type = 'checkbox', label = 'Mostrar blip mapa', icon = "map" },
        })
        if input then
            local data = {}
            data.label = input[1]
            data.showBlip = input[2]
            local coords = GetBlipCoords()
            if coords then
                data.coords = coords
                ServerControl.registerBarberShop(data)
            end
        end
    end
end

local function manageBarberShop(index)
    local barberShop = BarberShops[index]
    if barberShop then
        lib.registerContext({
            id = 'admin_manage_barbershop',
            title = 'Gerenciar Barbearia',
            menu = 'admin_barber_list',
            options = {
                {
                    title = "Teleportar até o local",
                    description = "Teleportar até o local",
                    icon = 'fa-solid fa-location-dot',
                    iconColor = 'blue',
                    onSelect = function()
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Wait(10)
                        end
                        SetEntityCoords(PlayerPedId(),barberShop.coords.x,barberShop.coords.y,barberShop.coords.z,false,false,false,false)
                        DoScreenFadeIn(500)
                    end
                },
                {
                    title = "Deletar Barbearia",
                    description = "Deletar "..barberShop.label,
                    icon = 'fa-solid fa-trash',
                    iconColor = 'red',
                    onSelect = function()
                        ServerControl.deleteBarberShop(index)
                    end
                },
            }
        })
        lib.showContext('admin_manage_barbershop')
    end
end

local function listBarberShops()
    local options = {}
    for k,v in pairs(BarberShops) do
        table.insert(options,{
            title = v.label,
            onSelect = function()
                manageBarberShop(k)
            end
        })
    end
    lib.registerContext({
        id = 'admin_barber_list',
        title = 'Lista de Barbearias',
        menu = 'admin_barber_control',
        options = options
    })
    lib.showContext('admin_barber_list')
end

RegisterNetEvent("AdminControl:openBarberShop")
AddEventHandler("AdminControl:openBarberShop",function()
    lib.registerContext({
        id = 'admin_barber_control',
        title = 'Controle das Barbearias',
        options = {
            {
                title = 'Registrar Barbearia',
                description = 'Registrar um novo local',
                icon = 'toolbox',
                iconColor = 'green',
                onSelect = createBarberShop
            },
            {
                title = "Listar Barbearias",
                description = "Listar todos as lojas",
                icon = 'list',
                iconColor = 'blue',
                onSelect = listBarberShops
            }
        }
    })
    lib.showContext('admin_barber_control')
end)


CreateThread(function()
    while true do
        if isInteractReady() then
            Wait(1000)
        else
            local idle = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            for _,shop in pairs(BarberShops or {}) do
                if shop.coords then
                    local dist = #(coords - vector3(shop.coords.x, shop.coords.y, shop.coords.z))
                    if dist <= 12.0 then
                        idle = 0
                        DrawMarker(27, shop.coords.x, shop.coords.y, shop.coords.z - 0.95, 0,0,0, 0,0,0, 0.75,0.75,0.75, 248,42,42,120, false,false,2,false)
                        if dist <= 1.5 then
                            DrawLocalText("~g~E~w~  Abrir barbearia",0.015,0.56)
                            if IsControlJustPressed(0,38) then
                                TriggerEvent("barbershop:Open")
                            end
                        end
                    end
                end
            end
            Wait(idle)
        end
    end
end)
