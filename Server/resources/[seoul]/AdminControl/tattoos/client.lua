local TattoosShops = GlobalState['TattoosShops']
local tattooInteractTargets = {}
local rebuildInteractTattoos

AddStateBagChangeHandler("TattoosShops","",function (_,_,value)
    TattoosShops = value or {}
    if rebuildInteractTattoos then rebuildInteractTattoos() end
end)

local function isInteractReady()
    return GetResourceState("interact") == "started"
end

local function clearInteractTattoos()
    if not isInteractReady() then
        tattooInteractTargets = {}
        return
    end

    for _,id in pairs(tattooInteractTargets) do
        pcall(function() exports.interact:removeCoords(id) end)
    end
    tattooInteractTargets = {}
end

rebuildInteractTattoos = function()
    clearInteractTattoos()
    if not isInteractReady() then return end

    for index,shop in pairs(TattoosShops or {}) do
        if shop.coords then
            local name = "AdminControl:tattoo:"..tostring(index)
            tattooInteractTargets[name] = exports.interact:addCoords(vector3(shop.coords.x,shop.coords.y,shop.coords.z),{
                name = name,
                label = "Abrir loja de tatuagem",
                icon = "fa-solid fa-pen-nib",
                distance = 1.5,
                onSelect = function()
                    TriggerEvent("tattooshop:Open")
                end
            })
        end
    end
end

CreateThread(function()
    while not isInteractReady() do Wait(1000) end
    Wait(500)
    rebuildInteractTattoos()
end)

local function createTattooShop()
    local groups = ServerControl.getGroups()
    if groups then
        local input = lib.inputDialog('Registro de loja de tatuagem', {
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
                ServerControl.registerTattooShop(data)
            end
        end
    end
end

local function manageTattooShop(index)
    local tattooShop = TattoosShops[index]
    if tattooShop then
        lib.registerContext({
            id = 'admin_manage_tattooshop',
            title = 'Gerenciar Loja de Tatuagem',
            menu = 'admin_tattoos_list',
            options = {
                {
                    title = "Teleportar até o local",
                    description = "Teleportar até o local da loja",
                    icon = 'fa-solid fa-location-dot',
                    iconColor = 'blue',
                    onSelect = function()
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Wait(10)
                        end
                        SetEntityCoords(PlayerPedId(),tattooShop.coords.x,tattooShop.coords.y,tattooShop.coords.z)
                        DoScreenFadeIn(500)
                    end
                },
                {
                    title = "Deletar Loja de Tatuagem",
                    description = "Deletar "..tattooShop.label,
                    icon = 'fa-solid fa-trash',
                    iconColor = 'red',
                    onSelect = function()
                        ServerControl.deleteTattooShop(index)
                    end
                },
            }
        })
        lib.showContext('admin_manage_tattooshop')
    end
end

local function listTattooShops()
    local options = {}
    for k,v in pairs(TattoosShops) do
        table.insert(options,{
            title = v.label,
            onSelect = function()
                manageTattooShop(k)
            end
        })
    end
    lib.registerContext({
        id = 'admin_tattoos_list',
        title = 'Lista de Lojas de Tatuagem',
        menu = 'admin_tattoos_control',
        options = options
    })
    lib.showContext('admin_tattoos_list')
end

RegisterNetEvent("AdminControl:openTattoosShop")
AddEventHandler("AdminControl:openTattoosShop",function()
    lib.registerContext({
        id = 'admin_tattoos_control',
        title = 'Controle das Lojas de Tatuagem',
        options = {
            {
                title = 'Registrar Loja de Tatuagem',
                description = 'Registrar um novo local',
                icon = 'toolbox',
                iconColor = 'green',
                onSelect = createTattooShop
            },
            {
                title = "Listar Lojas de Tatuagem",
                description = "Listar todos as lojas",
                icon = 'list',
                iconColor = 'blue',
                onSelect = listTattooShops
            }
        }
    })
    lib.showContext('admin_tattoos_control')
end)


CreateThread(function()
    while true do
        if isInteractReady() then
            Wait(1000)
        else
            local idle = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            for _,shop in pairs(TattoosShops or {}) do
                if shop.coords then
                    local dist = #(coords - vector3(shop.coords.x, shop.coords.y, shop.coords.z))
                    if dist <= 12.0 then
                        idle = 0
                        DrawMarker(27, shop.coords.x, shop.coords.y, shop.coords.z - 0.95, 0,0,0, 0,0,0, 0.75,0.75,0.75, 248,42,42,120, false,false,2,false)
                        if dist <= 1.5 then
                            DrawLocalText("~g~E~w~  Abrir loja de tatuagem",0.015,0.56)
                            if IsControlJustPressed(0,38) then
                                TriggerEvent("tattooshop:Open")
                            end
                        end
                    end
                end
            end
            Wait(idle)
        end
    end
end)
