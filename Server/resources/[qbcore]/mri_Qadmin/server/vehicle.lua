local function GetVehiclesList()
    local vehicles = {}
    local baseVehicles

    if GetResourceState('qbx_core') == 'started' then
        baseVehicles = exports.qbx_core:GetVehiclesByName()
    else
        baseVehicles = QBCore.Shared.Vehicles
    end

    local dbStocks = {}
    if Config.Dealership == 'mri' then
        local dbResult = MySQL.query.await('SELECT model, stock FROM vehicles_data')
        if dbResult then
            for _, v in pairs(dbResult) do
                dbStocks[v.model] = v.stock
            end
        end
    end

    local added = {}
    for model, data in pairs(baseVehicles or {}) do
        local m = data.model or model
        local vehicle = {
            name = data.name or m,
            hash = data.hash,
            model = m,
            category = data.category or 'seoul',
            brand = data.brand or 'Seoul',
            price = data.price or 0
        }

        if Config.Dealership == 'mri' then
            vehicle.stock = dbStocks[m] or 0
        end

        vehicles[#vehicles + 1] = vehicle
        added[tostring(m)] = true
    end

    -- Seoul Base não depende de QBCore.Shared.Vehicles. Se a lista shared vier vazia,
    -- aproveitamos os modelos que já existem na garagem real da base.
    local dbModels = MySQL.query.await('SELECT DISTINCT Vehicle FROM vehicles WHERE Vehicle IS NOT NULL AND Vehicle <> "" ORDER BY Vehicle ASC LIMIT 500') or {}
    for _, row in ipairs(dbModels) do
        local model = tostring(row.Vehicle or '')
        if model ~= '' and not added[model] then
            vehicles[#vehicles + 1] = { name = model, model = model, category = 'seoul', brand = 'Seoul', price = 0 }
            added[model] = true
        end
    end

    table.sort(vehicles, function(a, b) return (a.name or "") < (b.name or "") end)
    return vehicles
end
_G.GetVehiclesList = GetVehiclesList

lib.callback.register('mri_Qadmin:callback:GetVehicles', function(source)
    if not CheckPerms(source, 'qadmin.page.vehicles') then return {} end
    return GetVehiclesList()
end)

-- Admin Car
RegisterNetEvent('mri_Qadmin:server:SaveCar', function(mods, vehicle, _, plate)
    local src = source
    if not CheckPerms(src, 'qadmin.action.admincar') then return end

    -- SECURITY: nunca confiar em vehicle.model/hash vindos do cliente.
    -- Resolver o model a partir de QBCore.Shared.Vehicles usando a chave que
    -- o cliente envia em `mods.model` (já vem de lib.getVehicleProperties).
    local modelKey = type(mods) == 'table' and tostring(mods.model or '') or ''
    if modelKey == '' then
        return TriggerClientEvent('QBCore:Notify', src, locale("notifications.cannot_store_veh"), 'error', 3000)
    end

    -- Em FiveM, mods.model é o hash (number/uint). Buscamos o trusted entry
    -- correspondente no shared table.
    local trustedEntry
    for k, v in pairs(QBCore.Shared.Vehicles or {}) do
        if tostring(v.hash) == modelKey or tostring(k) == modelKey then
            trustedEntry = v
            trustedEntry._sharedKey = k
            break
        end
    end
    if not trustedEntry then
        AddLog(src, 'mri_Qadmin', 'vehicles', 'error', ('Admin Car rejeitado: modelo desconhecido %s'):format(modelKey), { received = modelKey })
        return TriggerClientEvent('QBCore:Notify', src, locale("notifications.cannot_store_veh"), 'error', 3000)
    end

    if type(plate) ~= 'string' or #plate == 0 or #plate > 8 then
        return TriggerClientEvent('QBCore:Notify', src, locale("notifications.plate_max"), 'error', 3000)
    end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local result = SeoulQAdminDB.HasVehiclePlate(plate) and { { Plate = plate } } or {}

    if not result or result[1] == nil then
        SeoulQAdminDB.InsertVehicle(Player.PlayerData.citizenid, trustedEntry.model or trustedEntry._sharedKey, plate, mods)
        TriggerClientEvent('QBCore:Notify', src, locale("veh_owner"), 'success', 5000)
        AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Admin Car: veículo %s salvo com placa %s'):format(trustedEntry.model or trustedEntry._sharedKey, plate), { model = trustedEntry.model, plate = plate })
    else
        TriggerClientEvent('QBCore:Notify', src, locale("notifications.u_veh_owner"), 'error', 3000)
    end
end)

-- Give Car
RegisterNetEvent("mri_Qadmin:server:givecar", function(_, selectedData)
    local src = source

    if not CheckPerms(src, 'qadmin.action.spawn_vehicle') then
        QBCore.Functions.Notify(src, locale("notifications.no_perms"), "error", 5000)
        return
    end

    local vehmodel = selectedData['Vehicle'] and selectedData['Vehicle'].value
    if type(vehmodel) ~= 'string' or vehmodel == '' then
        return QBCore.Functions.Notify(src, locale("notifications.cannot_store_veh"), "error", 5000)
    end

    local vehicleData = lib.callback.await("mri_Qadmin:client:getvehData", src, vehmodel)

    if not vehicleData or not next(vehicleData) then
        return
    end

    local tsrc = tonumber(selectedData['Player'] and selectedData['Player'].value)
    if not tsrc then return end
    local plate = selectedData['Placa (Opcional)'] and selectedData['Placa (Opcional)'].value or vehicleData.plate
    local garage = selectedData['Garagem (Opcional)'] and selectedData['Garagem (Opcional)'].value or Config.DefaultGarage
    local Player = QBCore.Functions.GetPlayer(tsrc)

    if type(plate) ~= 'string' or #plate < 1 then
        plate = vehicleData.plate
    end

    if type(garage) ~= 'string' or #garage < 1 then
        garage = Config.DefaultGarage
    end

    if type(plate) ~= 'string' or #plate > 8 then
        QBCore.Functions.Notify(src, locale("notifications.plate_max"), "error", 5000)
        return
    end

    if not Player then
        QBCore.Functions.Notify(src, locale("notifications.not_online"), "error", 5000)
        return
    end

    if CheckAlreadyPlate(plate) then
        QBCore.Functions.Notify(src, locale("notifications.givecar.plates_alreadyused", plate:upper()), "error", 5000)
        return
    end

    SeoulQAdminDB.InsertVehicle(Player.PlayerData.citizenid, vehmodel, plate, vehicleData)

    local targetName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    QBCore.Functions.Notify(src,
        locale("notifications.givecar.success.source", (QBCore.Shared.Vehicles[vehmodel] and QBCore.Shared.Vehicles[vehmodel].name) or vehmodel, targetName), "success", 5000)
    QBCore.Functions.Notify(Player.PlayerData.source, locale("notifications.givecar.success.target", plate:upper(), garage), "success",
        5000)
    local giveCarData = GetTargetData(tsrc)
    giveCarData.model = vehmodel
    giveCarData.plate = plate
    giveCarData.garage = garage
    AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Dar veículo: %s dado a %s (placa: %s)'):format(vehmodel, targetName, plate), giveCarData)
end)

-- Dedicated event for the Vehicle Wizard (Frontend)
RegisterNetEvent("mri_Qadmin:server:GiveVehicle", function(data)
    local src = source
    if not CheckPerms(src, 'qadmin.action.spawn_vehicle') then
        QBCore.Functions.Notify(src, locale("notifications.no_perms"), "error")
        return
    end

    if type(data) ~= 'table' then return end
    local playerId = tonumber(data.playerId)
    local model = data.model
    if type(model) ~= 'string' or model == '' then
        return QBCore.Functions.Notify(src, locale("notifications.cannot_store_veh"), "error")
    end
    local garage = data.garage or Config.DefaultGarage
    if type(garage) ~= 'string' or garage == '' then garage = Config.DefaultGarage end
    local props = type(data.props) == 'table' and data.props or {}
    local plate = type(props.plate) == 'string' and props.plate:upper() or nil
    if plate and #plate > 8 then
        return QBCore.Functions.Notify(src, locale("notifications.plate_max"), "error")
    end

    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then
        QBCore.Functions.Notify(src, locale("notifications.not_online"), "error")
        return
    end

    if not plate or plate == "" then
        plate = GeneratePlate()
    end
    props.plate = plate -- Put plate in overrides for client application

    if CheckAlreadyPlate(plate) then
        QBCore.Functions.Notify(src, locale("notifications.givecar.plates_alreadyused", plate), "error")
        return
    end

    -- Fetch FULL default properties with NATIVE customization from the admin's client
    local vehicleMods = lib.callback.await("mri_Qadmin:client:getvehData", src, model, props)
    if not vehicleMods or not next(vehicleMods) then
        vehicleMods = { model = model, plate = plate } -- Minimum Fallback
    end

    SeoulQAdminDB.InsertVehicle(Player.PlayerData.citizenid, model, plate, vehicleMods)

    local vehName = QBCore.Shared.Vehicles[model] and QBCore.Shared.Vehicles[model].name or model
    local targetName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname

    QBCore.Functions.Notify(src, locale("notifications.givecar.success.source", vehName, targetName), "success")
    QBCore.Functions.Notify(Player.PlayerData.source, locale("notifications.givecar.success.target", plate, garage), "success")
    local wizardCarData = GetTargetData(playerId)
    wizardCarData.model = model
    wizardCarData.plate = plate
    wizardCarData.garage = garage
    AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Dar veículo (wizard): %s dado a %s (placa: %s)'):format(model, targetName, plate), wizardCarData)
end)

-- Give Car
RegisterNetEvent("mri_Qadmin:server:SetVehicleState", function(_, selectedData)
    local src = source

    if not CheckPerms(src, 'qadmin.action.change_vehicle_state') then
        QBCore.Functions.Notify(src, locale("notifications.no_perms"), "error", 5000)
        return
    end

    local plateField = selectedData and selectedData['Plate']
    local stateField = selectedData and selectedData['State']
    if not plateField or not stateField then return end
    local plate = string.upper(plateField.value)
    local state = tonumber(stateField.value)

    if plate:len() > 8 then
        QBCore.Functions.Notify(src, locale("notifications.plate_max"), "error", 5000)
        return
    end

    if not CheckAlreadyPlate(plate) then
        QBCore.Functions.Notify(src, locale("plate_doesnt_exist"), "error", 5000)
        return
    end

    MySQL.update.await('UPDATE vehicles SET Block = ? WHERE Plate = ?', { state, plate })

    QBCore.Functions.Notify(src, locale("notifications.state_changed"), "success", 5000)
    AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Estado do veículo: placa %s alterada para estado %d'):format(plate, state), { plate = plate, state = state })
end)

-- Change Plate
RegisterNetEvent('mri_Qadmin:server:ChangePlate', function(newPlate, currentPlate)
    local src = source
    if not CheckPerms(src, 'qadmin.action.change_plate') then return end

    if type(newPlate) ~= 'string' or type(currentPlate) ~= 'string' then return end
    if #newPlate == 0 or #newPlate > 8 then
        return QBCore.Functions.Notify(src, locale("notifications.plate_max"), 'error', 5000)
    end
    if #currentPlate == 0 or #currentPlate > 16 then return end

    newPlate = newPlate:upper()
    currentPlate = currentPlate:upper()

    if newPlate == currentPlate then return end

    if Config.Inventory == 'ox_inventory' then
        exports.ox_inventory:UpdateVehicle(currentPlate, newPlate)
    end

    MySQL.update.await('UPDATE vehicles SET Plate = ? WHERE Plate = ?', { newPlate, currentPlate })
    -- Seoul/ox_inventory armazena porta-malas/luvas em vehicles/ox_inventory; sem trunkitems/gloveboxitems QBCore.
    AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Placa alterada: %s -> %s'):format(currentPlate, newPlate), { oldPlate = currentPlate, newPlate = newPlate })
end)

lib.callback.register('mri_Qadmin:server:GetVehicleByPlate', function(src, plate)
    if not CheckPerms(src, 'qadmin.page.vehicles') then return nil end
    local result = MySQL.query.await('SELECT Vehicle FROM vehicles WHERE Plate = ?', { plate })
    local veh = result[1] and result[1].Vehicle or {}
    return veh
end)

-- Fix Vehicle for player
RegisterNetEvent('mri_Qadmin:server:FixVehFor', function(_, selectedData)
    if not CheckPerms(source, 'qadmin.action.fix_vehicle') then return end
    local src = source
    local playerField = selectedData and selectedData['Player']
    if not playerField then return end
    local playerId = playerField.value
    local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
    if Player then
        local name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
        TriggerClientEvent('iens:repaira', Player.PlayerData.source)
        TriggerClientEvent('vehiclemod:client:fixEverything', Player.PlayerData.source)
        QBCore.Functions.Notify(src, locale("notifications.veh_fixed", name), 'success', 7500)
        AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Reparar veículo: veículo de %s reparado'):format(name), { target = playerId })
    else
        TriggerClientEvent('QBCore:Notify', src, locale("notifications.not_online"), "error")
    end
end)

-- Delete Vehicle by Plate
RegisterNetEvent('mri_Qadmin:server:DeleteVehicleByPlate', function(_, selectedData)
    local src = source

    if not CheckPerms(src, 'qadmin.action.delete_vehicle') then
        QBCore.Functions.Notify(src, locale("notifications.no_perms"), "error", 5000)
        return
    end

    local plateField = selectedData and selectedData["Plate"]
    if not plateField then return end
    local plate = plateField.value:upper()

    if plate:len() > 8 then
        QBCore.Functions.Notify(src, locale("notifications.plate_max"), "error", 5000)
        return
    end

    if not CheckAlreadyPlate(plate) then
        QBCore.Functions.Notify(src, locale("plate_doesnt_exist", plate), "error", 5000)
        return
    end

    -- Apagar dados relacionados
    MySQL.query.await('DELETE FROM vehicles WHERE Plate = ?', { plate })

    QBCore.Functions.Notify(src, locale("veh_deleted", plate), "success", 5000)
    AddLog(src, 'mri_Qadmin', 'vehicles', 'warn', ('Deletar veículo: placa %s removida do banco'):format(plate), { plate = plate })
end)

-- Update Vehicle Stock
lib.callback.register('mri_Qadmin:server:UpdateVehicleStock', function(src, actionKey, selectedData)
    if not CheckPerms(src, 'qadmin.action.update_vehicle_stock') then return false end

    if Config.Dealership ~= 'mri' then
        QBCore.Functions.Notify(src, "Stock management is only available for mri dealership system", "error")
        return false
    end

    local modelField = selectedData and selectedData["model"]
    local stockField = selectedData and selectedData["stock"]
    if not modelField or not stockField then return false end
    local model = modelField.value
    local stock = tonumber(stockField.value)

    local vehInfo = QBCore.Shared.Vehicles[model]
    if vehInfo then
        MySQL.query.await('INSERT INTO vehicles_data (model, stock, name, brand, category, price, hash) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = VALUES(stock)',
        {
            model, stock, vehInfo.name or model, vehInfo.brand or "", vehInfo.category or "", vehInfo.price or 0, vehInfo.hash or 0
        })
        QBCore.Functions.Notify(src, "Stock updated for " .. model, "success")
        AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Estoque do veículo %s alterado para %d'):format(model, stock), { model = model, stock = stock })
        return true
    else
        -- Fallback if not in shared vehicles, just try to update existing record
        local affected = MySQL.update.await('UPDATE vehicles_data SET stock = ? WHERE model = ?', { stock, model })
        if affected and affected >= 0 then
             QBCore.Functions.Notify(src, "Stock updated for " .. model, "success")
             AddLog(src, 'mri_Qadmin', 'vehicles', 'info', ('Estoque do veículo %s alterado para %d (fallback)'):format(model, stock), { model = model, stock = stock })
             return true
        end
    end

    return false
end)
