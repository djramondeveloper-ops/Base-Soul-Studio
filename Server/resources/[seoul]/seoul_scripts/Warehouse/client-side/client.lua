if SeoulScriptsClient and not SeoulScriptsClient.Enabled('Warehouse') then return end
local Config = Config or {}
local insideWarehouse = false
local tablet = nil
local leaveTarget, changePinTarget, stashTarget = nil, nil, nil

local function isInteractReady()
    return GetResourceState("interact") == "started"
end

local function isOxTargetReady()
    return GetResourceState("ox_target") == "started"
end

local function removeTargetZone(target)
    if not target then return nil end

    if type(target) == "table" and target.type == "interact" then
        if isInteractReady() then
            pcall(function() exports.interact:removeCoords(target.id) end)
        end
    elseif isOxTargetReady() then
        pcall(function() exports.ox_target:removeZone(target) end)
    end

    return nil
end

if WarehouseConfig.Blips.enabled then
    for _, warehouse in ipairs(WarehouseConfig.Warehouses) do
        local blip = AddBlipForCoord(warehouse.coords.x, warehouse.coords.y, warehouse.coords.z)
        SetBlipSprite(blip, WarehouseConfig.Blips.blipId)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, WarehouseConfig.Blips.blipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(WarehouseConfig.Blips.blipName)
        EndTextCommandSetBlipName(blip)
    end
end

local function spawnProps()
    for _, propData in ipairs(WarehouseConfig.Props) do
        local model = GetHashKey(propData.model)

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end

        local prop = CreateObject(model, propData.coords.x, propData.coords.y, propData.coords.z, true, true, true)

        if propData.heading then
            SetEntityHeading(prop, propData.heading)
        end

        FreezeEntityPosition(prop, true)
    end
end

local function addTargetZone(coords, radius, name, label, icon, onSelect)
    if isInteractReady() then
        return {
            type = "interact",
            id = exports.interact:addCoords(coords,{
                name = name,
                label = label,
                icon = icon,
                distance = radius or 1.5,
                onSelect = function()
                    onSelect()
                end
            })
        }
    end

    if not isOxTargetReady() then return nil end

    return exports.ox_target:addSphereZone({
        coords = coords,
        radius = radius,
        debugPoly = false,
        options = {
            {
                name = name,
                label = label,
                icon = icon,
                onSelect = function()
                    onSelect()
                end
            }
        }
    })
end

Citizen.CreateThread(function()
    for index, warehouse in ipairs(WarehouseConfig.Warehouses) do
        addTargetZone(warehouse.coords, 1.5, 'buyWarehouse_' .. index, "Comprar Armazém - $" .. warehouse.price, 'fa-solid fa-dollar-sign', function()
            local input = lib.inputDialog('Comprar Armazém', {
                {label = 'Nome do Armazém', type = 'input', placeholder = 'Digite um nome para o armazém...'},
                {label = 'Código de Acesso', type = 'input', placeholder = 'Digite um código de 4 dígitos para o armazém...'}
            })
            if input then
                local name = input[1]
                local code = input[2]
                TriggerServerEvent('seoul_warehouse:buy', index, name, code)
            end
        end)

        addTargetZone(warehouse.coords, 1.5, 'enterWarehouse_' .. index, "Entrar no Armazém", 'fa-solid fa-door-open', function()
            local playerCoords = GetEntityCoords(PlayerPedId())

            local input = lib.inputDialog('Entrar no Armazém', {
                {label = 'Nome do Armazém', type = 'input', placeholder = 'Digite o nome do armazém...'},
                {label = 'Código de Acesso', type = 'input', password = true, placeholder = 'Digite o código de acesso...'}
            })

            if input then
                local name = input[1]
                local code = input[2]
                TriggerServerEvent('seoul_warehouse:enter', name, code, index)
            end
        end)
    end
end)

local function playTabletAnimation()
    local playerPed = PlayerPedId()
    local tabletModel = GetHashKey("prop_cs_tablet")

    RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@base")
    RequestModel(tabletModel)
    while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@base") or not HasModelLoaded(tabletModel) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 8.0, 8.0, -1, 49, 0, false, false, false)
    tablet = CreateObject(tabletModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(tablet, playerPed, GetPedBoneIndex(playerPed, 60309), 0.03, 0.002, -0.03, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    return tablet
end

local function stopTabletAnimation(tablet)
    local playerPed = PlayerPedId()
    StopAnimTask(playerPed, "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
    DeleteObject(tablet)
end

RegisterNetEvent('seoul_warehouse:receiveUpgradeInfo')

local function handleUpgrade(warehouseId, upgradeType)
    local prices = {
        slots = WarehouseConfig.stashes.slotCost,
        weight = WarehouseConfig.stashes.weightCost
    }

    TriggerServerEvent('seoul_warehouse:requestUpgradeInfo', warehouseId, upgradeType)
    local EventHandlerId = nil
    EventHandlerId = AddEventHandler('seoul_warehouse:receiveUpgradeInfo', function(currentSlots, currentWeight)
        local input = lib.inputDialog('Melhorar Armazém', {
            {label = 'Quanto deseja melhorar?', type = 'number', placeholder = 'Digite a quantidade...'}
        })
        if EventHandlerId then
            RemoveEventHandler(EventHandlerId)
        end
        if input and tonumber(input[1]) then
            local upgradeAmount = tonumber(input[1])
            local upgradeCost
            if upgradeType == 'slots' then
                if currentSlots + upgradeAmount > WarehouseConfig.stashes.maxSlots then
                    local maxAllowed = WarehouseConfig.stashes.maxSlots - currentSlots
                    lib.notify({
                        type = 'error',
                        description = ('Melhoria excede o limite máximo de slots! Você só pode adicionar até %d slots.'):format(maxAllowed)
                    })
                    return
                end
                upgradeCost = upgradeAmount * prices.slots
            elseif upgradeType == 'weight' then
                if currentWeight + (upgradeAmount * 1000) > WarehouseConfig.stashes.maxWeight then
                    local maxAllowed = (WarehouseConfig.stashes.maxWeight - currentWeight) / 1000
                    lib.notify({
                        type = 'error',
                        description = ('Melhoria excede o limite máximo de peso! Você só pode adicionar até %d kg.'):format(maxAllowed)
                    })
                    return
                end
                upgradeCost = upgradeAmount * prices.weight
            end

            local confirm = lib.alertDialog({
                header = 'Confirmar Melhoria',
                content = ('Melhorar %s em %d por $%d?'):format(upgradeType == "weight" and "peso" or "slots", upgradeAmount, upgradeCost),
                centered = true,
                cancel = true
            })

            if confirm == 'confirm' then
                TriggerServerEvent('seoul_warehouse:processUpgrade', warehouseId, upgradeType, upgradeAmount, upgradeCost)
                stopTabletAnimation(tablet)
            else
                lib.notify({type = 'info', description = 'Melhoria cancelada.'})
                stopTabletAnimation(tablet)
            end
        else
            lib.notify({type = 'error', description = 'Entrada inválida. Por favor, digite um número válido.'})
            stopTabletAnimation(tablet)
        end
    end)
end

local function openOwnerManagementMenu(warehouseId)
    tablet = playTabletAnimation()

    lib.registerContext({
        id = 'warehouse_owner_management',
        title = 'Gerenciamento do Armazém',
        options = {
            {
                title = 'Melhorar Armazém',
                description = 'Melhorar capacidade ou peso do armazém',
                icon = 'fa-solid fa-arrow-up',
                onSelect = function()
                    lib.registerContext({
                        id = 'warehouse_upgrade_menu',
                        title = 'Opções de Melhoria',
                        options = {
                            {
                                title = 'Melhorar Slots',
                                description = 'Aumentar slots do armazém',
                                icon = 'fa-solid fa-box-open',
                                onSelect = function()
                                    handleUpgrade(warehouseId, 'slots')
                                end
                            },
                            {
                                title = 'Melhorar Peso',
                                description = 'Aumentar peso do armazém',
                                icon = 'fa-solid fa-weight-hanging',
                                onSelect = function()
                                    handleUpgrade(warehouseId, 'weight')
                                end
                            }
                        }
                    })
                    lib.showContext('warehouse_upgrade_menu')
                end
            },
            {
                title = 'Mudar Código',
                description = 'Alterar código de acesso do armazém',
                icon = 'fa-solid fa-key',
                onSelect = function()
                    local input = lib.inputDialog('Alterar Código do Armazém', {
                        {label = 'Novo Código de Acesso', type = 'input', placeholder = 'Digite um novo código de 4 dígitos...', password = true}
                    })
                    if input then
                        local newCode = input[1]
                        TriggerServerEvent('seoul_warehouse:changePin', warehouseId, newCode)
                        stopTabletAnimation(tablet)
                    end
                end
            },
            {
                title = 'Vender o armazém',
                description = 'Vender o armazém',
                icon = 'fa-solid fa-key',
                onSelect = function()
                    local maara = WarehouseConfig.sellpros * 100
                    local confirm = lib.alertDialog({
                        header = 'Confirmar venda',
                        content = ('Vender o armazém, você perde %s do preço original'):format(maara),
                        centered = true,
                        cancel = true
                    })
                    if confirm == 'confirm' then
                        TriggerServerEvent('seoul_warehouse:sell')
                        stopTabletAnimation(tablet)
                    else
                        lib.notify({type = 'info', description = 'Venda cancelada.'})
                        stopTabletAnimation(tablet)
                    end
                end
            }
        }
    })

    lib.showContext('warehouse_owner_management')
    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName == GetCurrentResourceName() then
            stopTabletAnimation(tablet)
        end
    end)
end

RegisterNetEvent('seoul_warehouse:teleportInside')
AddEventHandler('seoul_warehouse:teleportInside', function(warehouseId, isOwner)
    SetEntityCoords(PlayerPedId(), 1048.12, -3096.97, -39.0, false, false, false, true)

    spawnProps()
    leaveTarget = removeTargetZone(leaveTarget)
    changePinTarget = removeTargetZone(changePinTarget)
    stashTarget = removeTargetZone(stashTarget)
    leaveTarget = addTargetZone(vec3(1048.12, -3096.97, -39.0),1.5,'leaveWarehouse',"Sair do ArmazÃ©m",'fa-solid fa-door-closed',function()
        TriggerServerEvent('seoul_warehouse:leave')
    end)
    if not leaveTarget and isOxTargetReady() then leaveTarget = exports.ox_target:addSphereZone({
        coords = vec3(1048.12, -3096.97, -39.0),
        radius = 1.5,
        debugPoly = false,
        options = {
            {
                name = 'leaveWarehouse',
                label = "Sair do Armazém",
                icon = 'fa-solid fa-door-closed',
                onSelect = function()
                    TriggerServerEvent('seoul_warehouse:leave')
                end
            }
        }
    }) end

    if isInteractReady() then
        changePinTarget = {
            type = "interact",
            id = exports.interact:addCoords(vec3(1049.0280, -3100.6545, -39.0287),{
                name = 'manageWarehouse',
                label = "Gerenciar ArmazÃ©m",
                icon = 'fa-solid fa-cogs',
                distance = 1.5,
                canInteract = function()
                    return isOwner
                end,
                onSelect = function()
                    openOwnerManagementMenu(warehouseId)
                end
            })
        }
    elseif isOxTargetReady() then
        changePinTarget = exports.ox_target:addSphereZone({
        coords = vec3(1049.0280, -3100.6545, -39.0287),
        radius = 1.5,
        debugPoly = false,
        options = {
            {
                name = 'manageWarehouse',
                label = "Gerenciar Armazém",
                icon = 'fa-solid fa-cogs',
                canInteract = function()
                    return isOwner
                end,
                onSelect = function()
                    openOwnerManagementMenu(warehouseId)
                end
            }
        }
    })
    end

    stashTarget = addTargetZone(vec3(1052.9585, -3100.9563, -39.0000),1.5,'openStash',"Abrir ArmazÃ©m",'fa-solid fa-box',function()
        TriggerEvent('ox_inventory:openInventory', 'stash', {id = 'seoul_warehouse_' .. warehouseId, name = 'ArmazÃ©m'})
    end)
    if not stashTarget and isOxTargetReady() then stashTarget = exports.ox_target:addSphereZone({
        coords = vec3(1052.9585, -3100.9563, -39.0000),
        radius = 1.5,
        debugPoly = false,
        options = {
            {
                name = 'openStash',
                label = "Abrir Armazém",
                icon = 'fa-solid fa-box',
                onSelect = function()
                    TriggerEvent('ox_inventory:openInventory', 'stash', {id = 'seoul_warehouse_' .. warehouseId, name = 'Armazém'})
                end
            }
        }
    }) end
end)

RegisterNetEvent('seoul_warehouse:teleportOutside')
AddEventHandler('seoul_warehouse:teleportOutside', function(originalPos)
    SetEntityCoords(PlayerPedId(), originalPos.x, originalPos.y, originalPos.z, false, false, false, true)
    insideWarehouse = false

    leaveTarget = removeTargetZone(leaveTarget)
    changePinTarget = removeTargetZone(changePinTarget)
    stashTarget = removeTargetZone(stashTarget)
end)
