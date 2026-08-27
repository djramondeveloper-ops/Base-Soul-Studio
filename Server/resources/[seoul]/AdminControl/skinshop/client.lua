local SkinShops = GlobalState["SkinShops"] or {}
local skinshopInteractTargets = {}
local rebuildInteractSkinshops

AddStateBagChangeHandler("SkinShops","",function(_,_,value)
    SkinShops = value or {}
    if rebuildInteractSkinshops then rebuildInteractSkinshops() end
end)

local function openNationSkinshop()
    if GetResourceState("nation_skinshop") == "started" then
        TriggerEvent("skinshop:Open")
    else
        TriggerEvent("Notify","Negado","nation_skinshop não iniciado.",5000)
    end
end

local function isInteractReady()
    return GetResourceState("interact") == "started"
end

local function clearInteractSkinshops()
    if not isInteractReady() then
        skinshopInteractTargets = {}
        return
    end

    for _,id in pairs(skinshopInteractTargets) do
        pcall(function() exports.interact:removeCoords(id) end)
    end
    skinshopInteractTargets = {}
end

rebuildInteractSkinshops = function()
    clearInteractSkinshops()
    if not isInteractReady() then return end

    for index,shop in pairs(SkinShops or {}) do
        if shop.coords then
            local name = "AdminControl:skinshop:"..tostring(index)
            skinshopInteractTargets[name] = exports.interact:addCoords(vector3(shop.coords.x,shop.coords.y,shop.coords.z),{
                name = name,
                label = "Abrir loja de roupas",
                icon = "fa-solid fa-shirt",
                distance = 1.5,
                onSelect = openNationSkinshop
            })
        end
    end
end

CreateThread(function()
    while not isInteractReady() do Wait(1000) end
    Wait(500)
    rebuildInteractSkinshops()
end)

CreateThread(function()
    while true do
        if isInteractReady() then
            Wait(1000)
        else
            local idle = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            for _,shop in pairs(SkinShops or {}) do
                if shop.coords then
                    local dist = #(coords - vector3(shop.coords.x, shop.coords.y, shop.coords.z))
                    if dist <= 12.0 then
                        idle = 0
                        DrawMarker(27, shop.coords.x, shop.coords.y, shop.coords.z - 0.95, 0,0,0, 0,0,0, 0.75,0.75,0.75, 248,42,42,120, false,false,2,false)
                        if dist <= 1.5 then
                            DrawLocalText("~g~E~w~  Abrir loja de roupas",0.015,0.56)
                            if IsControlJustPressed(0,38) then openNationSkinshop() end
                        end
                    end
                end
            end
            Wait(idle)
        end
    end
end)

local function createSkinShop()
    local input = lib.inputDialog("Registro de loja de roupas", {
        { type = "input", label = "Nome", description = "Nome da loja", required = true },
        { type = "checkbox", label = "Mostrar blip mapa", icon = "map" }
    })
    if input then
        local coords = GetBlipCoords()
        if coords then
            ServerControl.registerSkinShop({ label = input[1], showBlip = input[2], coords = coords })
        end
    end
end

local function manageSkinShop(index)
    local shop = SkinShops[index]
    if not shop then return end
    lib.registerContext({
        id = "admin_manage_skinshop",
        title = "Gerenciar Loja de Roupas",
        menu = "admin_skinshop_list",
        options = {
            {
                title = "Teleportar até o local",
                icon = "fa-solid fa-location-dot",
                iconColor = "blue",
                onSelect = function()
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do Wait(10) end
                    SetEntityCoords(PlayerPedId(), shop.coords.x, shop.coords.y, shop.coords.z, false, false, false, false)
                    DoScreenFadeIn(500)
                end
            },
            {
                title = "Deletar Loja de Roupas",
                description = "Deletar "..tostring(shop.label or shop.name or "Loja"),
                icon = "fa-solid fa-trash",
                iconColor = "red",
                onSelect = function() ServerControl.deleteSkinShop(index) end
            }
        }
    })
    lib.showContext("admin_manage_skinshop")
end

local function listSkinShops()
    local options = {}
    for k,v in pairs(SkinShops or {}) do
        options[#options + 1] = { title = v.label or v.name or ("Loja #"..tostring(k)), onSelect = function() manageSkinShop(k) end }
    end
    lib.registerContext({ id = "admin_skinshop_list", title = "Lista de Lojas de Roupas", menu = "admin_skinshop_control", options = options })
    lib.showContext("admin_skinshop_list")
end

RegisterNetEvent("AdminControl:openSkinShop", function()
    lib.registerContext({
        id = "admin_skinshop_control",
        title = "Controle das Lojas de Roupas",
        options = {
            { title = "Registrar Loja de Roupas", icon = "toolbox", iconColor = "green", onSelect = createSkinShop },
            { title = "Listar Lojas de Roupas", icon = "list", iconColor = "blue", onSelect = listSkinShops }
        }
    })
    lib.showContext("admin_skinshop_control")
end)
