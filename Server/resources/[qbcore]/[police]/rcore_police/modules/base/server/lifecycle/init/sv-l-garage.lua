-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-garage.lua
--  Engineered by Eazy Fxap
--  Original: 650 lines → Cleaned: 217 lines
-- =====================================================

local ActiveVehicles = {}

local function trimPlate(plate)
    return tostring(plate or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function playerHasSeoulVehicleKey(player, plate)
    local items = player and player.PlayerData and player.PlayerData.items
    if type(items) ~= "table" then
        return false
    end

    for _, item in pairs(items) do
        local itemName = item and (item.item or item.name)
        if itemName and trimPlate(tostring(itemName):match("^vehiclekey%-(.+)$")) == plate then
            return true
        end
    end

    return false
end

local function giveSeoulVehicleKey(src, netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return false
    end

    local plate = GetVehicleNumberPlateText(entity)
    local trimmedPlate = trimPlate(plate)
    if trimmedPlate == "" then
        return false
    end

    Entity(entity).state:set("Lockpick", plate, true)

    if GetResourceState("ox_inventory") == "started" then
        return true
    end

    local player = Framework.getPlayer(src)
    if not player or not player.Functions or not player.Functions.AddItem then
        return true
    end

    if playerHasSeoulVehicleKey(player, trimmedPlate) then
        return true
    end

    return player.Functions.AddItem("vehiclekey-" .. trimmedPlate, 1, nil, nil, "rcore_police_garage") == true
end

AddEventHandler("rcore_police:server:databaseReady", function()
    Wait(1000)
    GarageService.RegisterInitGroups()
end)

RegisterNetEvent("rcore_police:server:unregisterVehicleSession", function()
    local src = source
    if spawnVehicleSessions[src] then
        spawnVehicleSessions[src] = nil
    end
end)

RegisterNetEvent("rcore_police:server:registerVehicle", function(netId)
    local src = source
    if not spawnVehicleSessions[src] then return end
    
    local job = Framework.getJob(src)
    local jobName = job and job.name or nil
    
    if not ActiveVehicles[netId] then
        ActiveVehicles[netId] = {
            paymentMethod = spawnVehicleSessions[src].paymentMethod,
            owner = spawnVehicleSessions[src].zoneOwner,
            netId = netId,
            spawnCost = spawnVehicleSessions[src].spawnCost
        }
        
        spawnVehicleSessions[src] = {}
        
        Utils.Log("Garage", ("Player named %s (%s) pickup vehicle from garage with spawnPrice: %s"):format(
            Framework.getCharacterShortName(src),
            src,
            ActiveVehicles[netId].spawnCost
        ))
    end

    giveSeoulVehicleKey(src, netId)
    
    TriggerEvent("rcore_police:server:garage:spawnedVehicle", netId, src, jobName)
end)

RegisterNetEvent("rcore_police:server:requestBuyGarageVehicle", function(amount)
    local src = source
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then return end
    
    local group = groupData and groupData.group or nil
    
    if not amount then return end
    if not Config.Garage.DepartmentsEnableBuyVehicles then return end
    
    local account = SocietyService.GetAccount(group)
    local cost = Config.Garage.PricePerVehicleOrder * amount
    
    if account and next(account) then
        local balance = account.GetBalance()
        if balance and cost <= balance then
            account.RemoveMoney(cost)
            print(group, amount, src)
            GarageService.OrderedVehicles(group, amount, src)
            Framework.sendNotification(src, _U("GARAGE.GARAGE_ORDER_VEHICLE_SUCC", amount, cost, _U("CURRENCY_SYMBOL")), "success")
        else
            Framework.sendNotification(src, _U("GARAGE.GARAGE_ORDER_VEHICLE_FAIL", cost, _U("CURRENCY_SYMBOL")), "error")
        end
    else
        dbg.critical("Failed to find society account when buying garage vehicles.")
    end
end)

RegisterNetEvent("rcore_police:server:requestVehicleFromStorage", function(data)
    local src = source
    if not data then return end
    if not spawnVehicleSessions[src] then return end
    
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then return end
    
    local group = groupData and groupData.group or nil
    
    GarageService.RequestVehicleFromGarage(src, group, data.coords, data.model)
end)

RegisterNetEvent("rcore_police:server:requestBuyDepartmentVehicle", function(data)
    local src = source
    if not data then return end
    if not spawnVehicleSessions[src] then return end
    
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then return end
    
    local group = groupData and groupData.group or nil
    local paymentMethod = data.paymentMethod:upper()
    local spawnCost = spawnVehicleSessions[src].spawnCost
    
    if paymentMethod == PAYMENT_METHODS.COMPANY then
        local success, err = pcall(function()
            SocietyService.BuyDepartmentVehicle({
                department = group,
                spawnPrice = spawnCost
            }, function(successStatus, errMessage)
                if successStatus then
                    spawnVehicleSessions[src].paymentMethod = paymentMethod
                    StartClient(src, "spawnVehicle", data.coords, data.model)
                    Framework.sendNotification(src, _U("GARAGE.VEHICLE_BOUGHT", errMessage, _U("CURRENCY_SYMBOL")), "success")
                else
                    spawnVehicleSessions[src] = nil
                    Framework.sendNotification(src, _U("GARAGE.NOT_ENOUGH_MONEY_IN_SOCIETY_TO_GET_VEHICLE", errMessage, _U("CURRENCY_SYMBOL")), "error")
                end
            end)
        end)
        
        if not success then
            print("An error occurred during the Society.BuyDepartmentVehicle: ", err)
        end
    elseif paymentMethod == PAYMENT_METHODS.BANK then
        local success, err = pcall(function()
            Framework.HandleGarageBankTransaction({
                playerId = src,
                transactionType = BANK_TRANSACTION_TYPES.REMOVE,
                spawnPrice = spawnCost
            }, function(successStatus, errMessage)
                if successStatus then
                    spawnVehicleSessions[src].paymentMethod = paymentMethod
                    StartClient(src, "spawnVehicle", data.coords, data.model)
                    Framework.sendNotification(src, _U("GARAGE.VEHICLE_BOUGHT", errMessage, _U("CURRENCY_SYMBOL")), "success")
                else
                    spawnVehicleSessions[src] = nil
                    Framework.sendNotification(src, _U("GARAGE.NOT_ENOUGH_MONEY_IN_BANK_TO_GET_VEHICLE", errMessage, _U("CURRENCY_SYMBOL")), "error")
                end
            end)
        end)
        
        if not success then
            print("An error occurred during the bank transaction: ", err)
        end
    end
end)

RegisterNetEvent("rcore_police:server:requestParkingSpace", function(data)
    local src = source
    if not data then return end
    
    local zone = data.zone
    local model = data.model
    local label = data.label
    local price = data.price or 150
    
    if not UtilsService.IsPlayerAtInteract(src, zone) then
        return dbg.debug("Failed spawn vehicle for player named %s with playerId (%s), player not at request zone area.", GetPlayerName(src), src)
    end
    
    local isMember, groupData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then
        return dbg.debug("Failed spawn vehicle for player named %s with playerId (%s), player is not part of department.", GetPlayerName(src), src)
    end
    
    local zoneJob = UtilsService.GetZoneJob(zone)
    local playerJob = Framework.getJob(src)
    local targetJob = groupData and groupData.group or nil
    
    if type(zoneJob) == "table" then
        for _, jobName in pairs(zoneJob) do
            if playerJob and playerJob.name == jobName then
                targetJob = jobName
                break
            end
        end
    elseif playerJob and playerJob.name == zoneJob then
        targetJob = playerJob.name
    end
    
    spawnVehicleSessions[src] = {
        zoneOwner = targetJob,
        spawnCost = price
    }
    
    StartClient(src, "checkDepartmentGarageSpawnPoint", zone, model, label)
end)

RegisterNetEvent("rcore_police:server:requestStoreVehicle", function(netId, zone)
    local src = source
    if not netId then return end
    
    if not ActiveVehicles[netId] then
        return Framework.sendNotification(src, _U("GARAGE.NOT_DEPARTMENT_VEHICLE"), "error")
    end
    
    local entity = NetworkGetEntityFromNetworkId(netId)
    
    if not UtilsService.IsPlayerAtGarage(src, zone) then
        return dbg.debug("Failed to store vehicle, player is not close to garage.")
    end
    
    local job = Framework.getJob(src)
    if job and job.name then
        GarageService.ReturnedVehicle(job.name)
    end
    
    if Config.Garage.DepartmentsEnableBuyVehicles then
        local paymentMethod = ActiveVehicles[netId].paymentMethod
        if not paymentMethod then return end
        
        local owner = ActiveVehicles[netId].owner
        local spawnCost = ActiveVehicles[netId].spawnCost or Config.Garage.DepartmentsBuyVehicleCostPrice
        
        Utils.Log("Garage", ("Player named %s (%s) stored vehicle in garage!"):format(Framework.getCharacterShortName(src), src))
        
        if paymentMethod == PAYMENT_METHODS.COMPANY then
            SocietyService.StoreDepartmentVehicle({
                department = owner,
                spawnPrice = spawnCost
            }, function(success)
                if success then
                    DespawnVehicle(src, entity, netId)
                end
            end)
        elseif paymentMethod == PAYMENT_METHODS.BANK then
            Framework.HandleGarageBankTransaction({
                playerId = src,
                transactionType = BANK_TRANSACTION_TYPES.ADD,
                spawnPrice = spawnCost
            }, function(success)
                if success then
                    DespawnVehicle(src, entity, netId)
                end
            end)
        end
    else
        DespawnVehicle(src, entity, netId)
    end
end)

function DespawnVehicle(src, entity, netId)
    if DoesEntityExist(entity) then
        StartClient(src, "despawnVehicle", netId)
        TriggerEvent("rcore_police:server:garage:despawnVehicle", netId)
        DeleteEntity(entity)
        ActiveVehicles[netId] = {}
        Framework.sendNotification(src, _U("GARAGE.VEHICLE_WAS_STORED"))
    end
end
