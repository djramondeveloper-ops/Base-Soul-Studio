
local isDisabled, var14, isDisabled4, counter, var15, var12, isDisabled5, var13, dataTable, coords, condition, strValue, tableData, strValue2, var1
isDisabled = IsDuplicityVersion
isDisabled = isDisabled()
if isDisabled then
    isDisabled = GetPlayerPositionInRealTime72
    isDisabled()
end
isDisabled = false
var14 = Config
var14 = var14.AttractionsSettings
var14 = var14.bumpercars
var14 = var14.minminutes
isDisabled4 = false
counter = 0
var15 = nil
var12 = nil
isDisabled5 = false
var13 = nil
dataTable = {}
coords = vector3
condition = -1636.68
strValue = -1063.4
tableData = 12.15
coords = coords(condition, strValue, tableData)
dataTable.coordsbuy = coords
coords = {}
dataTable.bumperplayers = coords
bumperhandler = dataTable
dataTable = RegisterNUICallback
coords = "calculatepricebumper"

function condition(A0_2, A1_2)
    local entityCoords5, playerPed, serverId, playerPed2
    entityCoords5 = isDisabled
    if true == entityCoords5 then
        entityCoords5 = tonumber
        playerPed = A0_2.bumperselectedminutes
        entityCoords5 = entityCoords5(playerPed)
        var14 = entityCoords5
        entityCoords5 = SendNUIMessage
        playerPed = {}
        playerPed.message = "bumperbuyupdateprice"
        serverId = Config
        serverId = serverId.AttractionsSettings
        serverId = serverId.bumpercars
        serverId = serverId.priceperminute
        playerPed2 = var14
        serverId = serverId * playerPed2
        playerPed.bumperpricedata = serverId
        entityCoords5(playerPed)
    end
    entityCoords5 = A1_2
    playerPed = "ok"
    entityCoords5(playerPed)
end
dataTable(coords, condition)
dataTable = RegisterNUICallback
coords = "closebumper"

function condition(A0_2, A1_2)
    local entityCoords5, playerPed, serverId
    entityCoords5 = isDisabled
    if true == entityCoords5 then
        entityCoords5 = false
        isDisabled = entityCoords5
        entityCoords5 = Config
        entityCoords5 = entityCoords5.AttractionsSettings
        entityCoords5 = entityCoords5.bumpercars
        entityCoords5 = entityCoords5.minminutes
        var14 = entityCoords5
        entityCoords5 = SetNuiFocus
        playerPed = false
        serverId = false
        entityCoords5(playerPed, serverId)
        entityCoords5 = SendNUIMessage
        playerPed = {}
        playerPed.message = "hidebumperpay"
        entityCoords5(playerPed)
    end
    entityCoords5 = A1_2
    playerPed = "ok"
    entityCoords5(playerPed)
end
dataTable(coords, condition)
dataTable = RegisterNUICallback
coords = "payforbumper"

function condition(A0_2, A1_2)
    local entityCoords5, playerPed, serverId
    entityCoords5 = isDisabled
    if true == entityCoords5 then
        entityCoords5 = TriggerServerEvent
        playerPed = "rtx_themepark:Bumper:PayForBumper"
        serverId = var14
        entityCoords5(playerPed, serverId)
        -- Don't close menu immediately, wait for server response
        -- The menu will be closed by server callback
    end
    entityCoords5 = A1_2
    playerPed = "ok"
    entityCoords5(playerPed)
end
dataTable(coords, condition)
dataTable = {}

function coords(A0_2)
    local entityCoords4, entityCoords5
    entityCoords4 = A0_2.destructor
    if entityCoords4 then
        entityCoords4 = A0_2.handle
        if entityCoords4 then
            entityCoords4 = A0_2.destructor
            entityCoords5 = A0_2.handle
            entityCoords4(entityCoords5)
        end
    end
    A0_2.destructor = nil
    A0_2.handle = nil
end
dataTable.__gc = coords

function coords(A0_2, A1_2, A2_2)
    local playerPed, serverId
    playerPed = coroutine
    playerPed = playerPed.wrap

    function serverId()
        local func, flag, dataTable2, isEnabled4, func2, var3
        func = A0_2
        func, flag = func()
        if not flag or 0 == flag then
            dataTable2 = A2_2
            isEnabled4 = func
            dataTable2(isEnabled4)
            return
        end
        dataTable2 = {}
        dataTable2.handle = func
        isEnabled4 = A2_2
        dataTable2.destructor = isEnabled4
        isEnabled4 = setmetatable
        func2 = dataTable2
        var3 = dataTable
        isEnabled4(func2, var3)
        isEnabled4 = true
        repeat
            func2 = coroutine
            func2 = func2.yield
            var3 = flag
            func2(var3)
            func2 = A1_2
            var3 = func
            func2, var3 = func2(var3)
            flag = var3
            isEnabled4 = func2
        until not isEnabled4
        func2 = nil
        dataTable2.handle = nil
        dataTable2.destructor = func2
        func2 = A2_2
        var3 = func
        func2(var3)
    end
    return playerPed(serverId)
end

function condition()
    local dataTable3, entityCoords4, entityCoords5, playerPed
    dataTable3 = coords
    entityCoords4 = FindFirstVehicle
    entityCoords5 = FindNextVehicle
    playerPed = EndFindVehicle
    return dataTable3(entityCoords4, entityCoords5, playerPed)
end
EnumerateVehicles = condition

function condition()
    local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6
    dataTable3 = {}
    entityCoords4 = EnumerateVehicles
    entityCoords4, entityCoords5, playerPed, serverId = entityCoords4()
    for playerPed2 in entityCoords4, entityCoords5, playerPed, serverId do
        entityCoords = table
        entityCoords = entityCoords.insert
        model = dataTable3
        entityCoords6 = playerPed2
        entityCoords(model, entityCoords6)
    end
    return dataTable3
end
GetVehicles = condition

function condition(A0_2, A1_2)
    local entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6
    entityCoords5 = GetVehicles
    entityCoords5 = entityCoords5()
    playerPed = {}
    serverId = 1
    playerPed2 = #entityCoords5
    entityCoords = 1
    for model = serverId, playerPed2, entityCoords do
        entityCoords6 = GetEntityCoords
        hash = entityCoords5[model]
        entityCoords6 = entityCoords6(hash)
        hash = entityCoords6 - A0_2
        hash = #hash
        if A1_2 >= hash then
            entityCoords3 = table
            entityCoords3 = entityCoords3.insert
            entityCoords2 = playerPed
            isDisabled6 = entityCoords5[model]
            entityCoords3(entityCoords2, isDisabled6)
        end
    end
    return playerPed
end
GetVehiclesInArea = condition

function condition(A0_2, A1_2)
    local entityCoords5, playerPed, serverId
    entityCoords5 = GetVehiclesInArea
    playerPed = A0_2
    serverId = A1_2
    entityCoords5 = entityCoords5(playerPed, serverId)
    playerPed = #entityCoords5
    playerPed = 0 == playerPed
    return playerPed
end
IsSpawnPointClear = condition

function condition()
    local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash
    dataTable3 = Config
    dataTable3 = dataTable3.BumperCarsSpawnPoints
    entityCoords4 = false
    entityCoords5 = nil
    playerPed = 1
    serverId = #dataTable3
    playerPed2 = 1
    for entityCoords = playerPed, serverId, playerPed2 do
        model = IsSpawnPointClear
        entityCoords6 = dataTable3[entityCoords]
        entityCoords6 = entityCoords6.coords
        hash = dataTable3[entityCoords]
        hash = hash.radius
        model = model(entityCoords6, hash)
        if model then
            model = true
            entityCoords5 = dataTable3[entityCoords]
            entityCoords4 = model
            break
        end
    end
    if entityCoords4 then
        playerPed = true
        serverId = entityCoords5
        return playerPed, serverId
    else
        playerPed = false
        return playerPed
    end
end
GetSpawnPoints = condition

function condition(A0_2)
    local entityCoords4, entityCoords5, playerPed, serverId
    if A0_2 then
        entityCoords4 = string
        entityCoords4 = entityCoords4.gsub
        entityCoords5 = A0_2
        playerPed = "^%s*(.-)%s*$"
        serverId = "%1"
        entityCoords4 = entityCoords4(entityCoords5, playerPed, serverId)
        return entityCoords4
    else
        entityCoords4 = ""
        return entityCoords4
    end
end
PlateReformat = condition

function condition()
    local dataTable3, entityCoords4, entityCoords5, playerPed
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 16
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 17
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 22
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 23
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 24
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 25
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 26
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 36
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 37
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 44
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 47
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 55
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 69
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 81
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 82
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 91
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 92
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 99
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 106
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 114
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 115
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 140
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 142
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 257
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 86
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
    dataTable3 = DisableControlAction
    entityCoords4 = 0
    entityCoords5 = 75
    playerPed = true
    dataTable3(entityCoords4, entityCoords5, playerPed)
end
DisableControlsBumper = condition

function condition(A0_2)
    local entityCoords4
    entityCoords4 = "sempre_delperropier_autodrom_auticko"
    if 1 == A0_2 then
        entityCoords4 = "sempre_delperropier_autodrom_auticko"
    elseif 2 == A0_2 then
        entityCoords4 = "sempre_delperropier_autodrom_auticko_b"
    elseif 3 == A0_2 then
        entityCoords4 = "sempre_delperropier_autodrom_auticko_g"
    elseif 4 == A0_2 then
        entityCoords4 = "sempre_delperropier_autodrom_auticko_p"
    end
    return entityCoords4
end
GetColorBumper = condition
condition = RegisterNetEvent
strValue = "rtx_themepark:Bumper:OpenTicketMenu"
condition(strValue)
condition = AddEventHandler
strValue = "rtx_themepark:Bumper:OpenTicketMenu"

function tableData(A0_2)
    local entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model
    entityCoords4 = PlayerPedId
    entityCoords4 = entityCoords4()
    entityCoords5 = GetEntityCoords
    playerPed = entityCoords4
    entityCoords5 = entityCoords5(playerPed)
    playerPed = tickets
    playerPed = playerPed.bumpercars
    if false == playerPed then
        playerPed = bumperhandler
        playerPed = playerPed.coordsbuy
        playerPed = entityCoords5 - playerPed
        playerPed = #playerPed
        serverId = Config
        serverId = serverId.ThemeParkTicketMachineSettings
        serverId = serverId.usedistance
        if playerPed < serverId then
            serverId = isDisabled
            if false == serverId then
                serverId = SendNUIMessage
                playerPed2 = {}
                playerPed2.message = "updateinterfacedata"
                entityCoords = Config
                entityCoords = entityCoords.InterfaceColor
                playerPed2.interfacecolordata = entityCoords
                entityCoords = tostring
                model = GetCurrentResourceName
                model = model()
                entityCoords = entityCoords(model)
                playerPed2.themeparkresourcenamedata = entityCoords
                serverId(playerPed2)
                serverId = true
                isDisabled = serverId
                serverId = Config
                serverId = serverId.AttractionsSettings
                serverId = serverId.bumpercars
                serverId = serverId.minminutes
                var14 = serverId
                serverId = SendNUIMessage
                playerPed2 = {}
                playerPed2.message = "bumpercarsbuyshow"
                entityCoords = Config
                entityCoords = entityCoords.AttractionsSettings
                entityCoords = entityCoords.bumpercars
                entityCoords = entityCoords.minminutes
                playerPed2.bumperminminutesdata = entityCoords
                entityCoords = Config
                entityCoords = entityCoords.AttractionsSettings
                entityCoords = entityCoords.bumpercars
                entityCoords = entityCoords.maxminutes
                playerPed2.bumpermaxminutesdata = entityCoords
                entityCoords = Config
                entityCoords = entityCoords.AttractionsSettings
                entityCoords = entityCoords.bumpercars
                entityCoords = entityCoords.priceperminute
                model = Config
                model = model.AttractionsSettings
                model = model.bumpercars
                model = model.minminutes
                entityCoords = entityCoords * model
                playerPed2.bumperpricedata = entityCoords
                serverId(playerPed2)
                serverId = SetNuiFocus
                playerPed2 = true
                entityCoords = true
                serverId(playerPed2, entityCoords)
            end
        end
    end
end
condition(strValue, tableData)
condition = Config
condition = condition.Target
if true == condition then
    condition = RegisterNetEvent
    strValue = "rtx_themepark:Bumper:OpenTicketTarget"
    condition(strValue)
    condition = AddEventHandler
    strValue = "rtx_themepark:Bumper:OpenTicketTarget"

    function tableData()
        local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2
        dataTable3 = PlayerPedId
        dataTable3 = dataTable3()
        entityCoords4 = GetEntityCoords
        entityCoords5 = dataTable3
        entityCoords4 = entityCoords4(entityCoords5)
        entityCoords5 = tickets
        if entityCoords5 == nil then return end
        entityCoords5 = entityCoords5.bumpercars
        if false == entityCoords5 then
            entityCoords5 = bumperhandler
            entityCoords5 = entityCoords5.coordsbuy
            entityCoords5 = entityCoords4 - entityCoords5
            entityCoords5 = #entityCoords5
            playerPed = Config
            playerPed = playerPed.ThemeParkTicketMachineSettings
            playerPed = playerPed.usedistance
            if entityCoords5 < playerPed then
                playerPed = iteminhand
                if false == playerPed then
                    playerPed = TriggerServerEvent
                    serverId = "rtx_themepark:Bumper:CheckTickets"
                    playerPed(serverId)
                else
                    playerPed = Notify
                    serverId = Language
                    playerPed2 = Config
                    playerPed2 = playerPed2.Language
                    serverId = serverId[playerPed2]
                    serverId = serverId.iteminhand
                    playerPed(serverId)
                end
            end
        end
    end
    condition(strValue, tableData)
end
condition = Config
condition = condition.ServerSideObjectsOnly
if false == condition then
    condition = RegisterNetEvent
    strValue = "rtx_themepark:Bumper:SpawnBumperClient"
    condition(strValue)
    condition = AddEventHandler
    strValue = "rtx_themepark:Bumper:SpawnBumperClient"

    function tableData(A0_2, A1_2)
        local entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled
        -- Close purchase menu immediately when spawn starts
        entityCoords5 = false
        isDisabled = entityCoords5
        entityCoords5 = Config
        entityCoords5 = entityCoords5.AttractionsSettings
        entityCoords5 = entityCoords5.bumpercars
        entityCoords5 = entityCoords5.minminutes
        var14 = entityCoords5
        entityCoords5 = SetNuiFocus
        playerPed = false
        serverId = false
        entityCoords5(playerPed, serverId)
        entityCoords5 = SendNUIMessage
        playerPed = {}
        playerPed.message = "hidebumperpay"
        entityCoords5(playerPed)
        
        entityCoords5 = PlayerPedId
        entityCoords5 = entityCoords5()
        playerPed = GetPlayerServerId
        serverId = PlayerId
        serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled = serverId()
        playerPed = playerPed(serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled)
        serverId = bumperhandler
        serverId = serverId.bumperplayers
        playerPed2 = {}
        playerPed2.seattaken = false
        playerPed2.vehiclenetwork = nil
        playerPed2.vehicleobject = nil
        playerPed2.bumpercolor = A1_2
        playerPed2.removed = false
        serverId[playerPed] = playerPed2
        serverId = DoesEntityExist
        playerPed2 = var15
        serverId = serverId(playerPed2)
        if serverId then
            serverId = DeletEntity
            playerPed2 = var15
            serverId(playerPed2)
        end
        serverId = false
        playerPed2 = nil
        while false == serverId do
            entityCoords = GetSpawnPoints
            entityCoords, model = entityCoords()
            playerPed2 = model
            serverId = entityCoords
            entityCoords = Citizen
            entityCoords = entityCoords.Wait
            model = 100
            entityCoords(model)
        end
        entityCoords = GetHashKey
        model = "rtxbumper"
        entityCoords = entityCoords(model)
        model = RequestModel
        entityCoords6 = entityCoords
        model(entityCoords6)
        while true do
            model = HasModelLoaded
            entityCoords6 = entityCoords
            model = model(entityCoords6)
            if model then
                break
            end
            model = RequestModel
            entityCoords6 = entityCoords
            model(entityCoords6)
            model = Citizen
            model = model.Wait
            entityCoords6 = 5
            model(entityCoords6)
        end
        model = CreateVehicle
        entityCoords6 = entityCoords
        hash = playerPed2.coords
        hash = hash.x
        entityCoords3 = playerPed2.coords
        entityCoords3 = entityCoords3.y
        entityCoords2 = playerPed2.coords
        entityCoords2 = entityCoords2.z
        isDisabled6 = playerPed2.heading
        model2 = true
        isEnabled7 = true
        model = model(entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7)
        var15 = model
        model = SetVehicleHasBeenOwnedByPlayer
        entityCoords6 = true
        model(entityCoords6)
        model = SetVehicleNeedsToBeHotwired
        entityCoords6 = false
        model(entityCoords6)
        model = SetModelAsNoLongerNeeded
        entityCoords6 = entityCoords
        model(entityCoords6)
        model = SetVehRadioStation
        entityCoords6 = var15
        hash = "OFF"
        model(entityCoords6, hash)
        model = SetVehicleColours
        entityCoords6 = var15
        hash = 111
        entityCoords3 = 64
        model(entityCoords6, hash, entityCoords3)
        model = SetVehicleDirtLevel
        entityCoords6 = var15
        hash = 0.1
        model(entityCoords6, hash)
        model = SetVehicleFuelLevel
        entityCoords6 = var15
        hash = 100.0
        model(entityCoords6, hash)
        model = SetEntityInvincible
        entityCoords6 = var15
        model(entityCoords6)
        model = SetVehicleEngineOn
        entityCoords6 = var15
        hash = true
        entityCoords3 = true
        entityCoords2 = true
        model(entityCoords6, hash, entityCoords3, entityCoords2)
        model = SetVehicleRadioEnabled
        entityCoords6 = var15
        hash = false
        model(entityCoords6, hash)
        model = GetColorBumper
        entityCoords6 = A1_2
        model = model(entityCoords6)
        entityCoords6 = GetHashKey
        hash = model
        entityCoords6 = entityCoords6(hash)
        hash = RequestModel
        entityCoords3 = entityCoords6
        hash(entityCoords3)
        while true do
            hash = HasModelLoaded
            entityCoords3 = entityCoords6
            hash = hash(entityCoords3)
            if hash then
                break
            end
            hash = RequestModel
            entityCoords3 = entityCoords6
            hash(entityCoords3)
            hash = Citizen
            hash = hash.Wait
            entityCoords3 = 5
            hash(entityCoords3)
        end
        hash = bumperhandler
        hash = hash.bumperplayers
        hash = hash[playerPed]
        entityCoords3 = CreateObjectNoOffset
        entityCoords2 = entityCoords6
        isDisabled6 = playerPed2.coords
        isDisabled6 = isDisabled6.x
        model2 = playerPed2.coords
        model2 = model2.y
        isEnabled7 = playerPed2.coords
        isEnabled7 = isEnabled7.z
        isDisabled3 = false
        isEnabled8 = true
        isEnabled3 = true
        entityCoords3 = entityCoords3(entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3)
        hash.vehicleobject = entityCoords3
        hash = FreezeEntityPosition
        entityCoords3 = bumperhandler
        entityCoords3 = entityCoords3.bumperplayers
        entityCoords3 = entityCoords3[playerPed]
        entityCoords3 = entityCoords3.vehicleobject
        entityCoords2 = true
        hash(entityCoords3, entityCoords2)
        hash = SetEntityInvincible
        entityCoords3 = bumperhandler
        entityCoords3 = entityCoords3.bumperplayers
        entityCoords3 = entityCoords3[playerPed]
        entityCoords3 = entityCoords3.vehicleobject
        hash(entityCoords3)
        hash = AttachEntityToEntity
        entityCoords3 = bumperhandler
        entityCoords3 = entityCoords3.bumperplayers
        entityCoords3 = entityCoords3[playerPed]
        entityCoords3 = entityCoords3.vehicleobject
        entityCoords2 = var15
        isDisabled6 = 0
        model2 = 0.0
        isEnabled7 = 0.0
        isDisabled3 = -0.1
        isEnabled8 = 0.0
        isEnabled3 = 0.0
        isEnabled10 = 180.0
        isEnabled9 = false
        isDisabled2 = false
        isEnabled5 = true
        isEnabled11 = false
        isEnabled6 = 2
        isEnabled = true
        hash(entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled)
        hash = TaskWarpPedIntoVehicle
        entityCoords3 = entityCoords5
        entityCoords2 = var15
        isDisabled6 = -1
        hash(entityCoords3, entityCoords2, isDisabled6)
        hash = NetworkGetNetworkIdFromEntity
        entityCoords3 = var15
        hash = hash(entityCoords3)
        entityCoords3 = TriggerServerEvent
        entityCoords2 = "rtx_themepark:Bumper:SpawnBumper"
        isDisabled6 = hash
        entityCoords3(entityCoords2, isDisabled6)
        entityCoords3 = 60 * A0_2
        counter = entityCoords3
        entityCoords3 = true
        isDisabled4 = entityCoords3
        entityCoords3 = SendNUIMessage
        entityCoords2 = {}
        entityCoords2.message = "bumperupdatetime"
        isDisabled6 = counter
        entityCoords2.bumpertimedata = isDisabled6
        entityCoords3(entityCoords2)
        entityCoords3 = SendNUIMessage
        entityCoords2 = {}
        entityCoords2.message = "bumpercarsshow"
        entityCoords2.bumperdriver = true
        isDisabled6 = Config
        isDisabled6 = isDisabled6.AttractionsSettings
        isDisabled6 = isDisabled6.bumpercars
        isDisabled6 = isDisabled6.bumperleavekey
        entityCoords2.bumperleavekeydata = isDisabled6
        entityCoords3(entityCoords2)
        entityCoords3 = SetPlayerCanDoDriveBy
        entityCoords2 = PlayerId
        entityCoords2 = entityCoords2()
        isDisabled6 = false
        entityCoords3(entityCoords2, isDisabled6)
        entityCoords3 = PlateReformat
        entityCoords2 = GetVehicleNumberPlateText
        isDisabled6 = var15
        entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled = entityCoords2(isDisabled6)
        entityCoords3 = entityCoords3(entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled)
        entityCoords2 = AddBumperKey
        isDisabled6 = var15
        model2 = GetEntityModel
        isEnabled7 = var15
        model2 = model2(isEnabled7)
        isEnabled7 = entityCoords3
        entityCoords2(isDisabled6, model2, isEnabled7)
    end
    condition(strValue, tableData)
else
    condition = RegisterNetEvent
    strValue = "rtx_themepark:Bumper:SpawnBumperClient"
    condition(strValue)
    condition = AddEventHandler
    strValue = "rtx_themepark:Bumper:SpawnBumperClient"

    function tableData(A0_2, A1_2)
        local entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3
        -- Close purchase menu immediately when spawn starts
        entityCoords5 = false
        isDisabled = entityCoords5
        entityCoords5 = Config
        entityCoords5 = entityCoords5.AttractionsSettings
        entityCoords5 = entityCoords5.bumpercars
        entityCoords5 = entityCoords5.minminutes
        var14 = entityCoords5
        entityCoords5 = SetNuiFocus
        playerPed = false
        serverId = false
        entityCoords5(playerPed, serverId)
        entityCoords5 = SendNUIMessage
        playerPed = {}
        playerPed.message = "hidebumperpay"
        entityCoords5(playerPed)
        
        entityCoords5 = false
        playerPed = nil
        while false == entityCoords5 do
            serverId = GetSpawnPoints
            serverId, playerPed2 = serverId()
            playerPed = playerPed2
            entityCoords5 = serverId
            serverId = Citizen
            serverId = serverId.Wait
            playerPed2 = 100
            serverId(playerPed2)
        end
        serverId = GetColorBumper
        playerPed2 = A1_2
        serverId = serverId(playerPed2)
        playerPed2 = GetHashKey
        entityCoords = serverId
        playerPed2 = playerPed2(entityCoords)
        entityCoords = RequestModel
        model = playerPed2
        entityCoords(model)
        while true do
            entityCoords = HasModelLoaded
            model = playerPed2
            entityCoords = entityCoords(model)
            if entityCoords then
                break
            end
            entityCoords = RequestModel
            model = playerPed2
            entityCoords(model)
            entityCoords = Citizen
            entityCoords = entityCoords.Wait
            model = 5
            entityCoords(model)
        end
        entityCoords = TriggerServerEvent
        model = "rtx_themepark:Bumper:SpawnBumper"
        entityCoords6 = playerPed.coords
        hash = playerPed.heading
        entityCoords3 = A0_2
        entityCoords(model, entityCoords6, hash, entityCoords3)
    end
    condition(strValue, tableData)
    condition = RegisterNetEvent
    strValue = "rtx_themepark:Bumper:BumperHandler"
    condition(strValue)
    condition = AddEventHandler
    strValue = "rtx_themepark:Bumper:BumperHandler"

    function tableData(A0_2, A1_2)
        local entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6
        entityCoords5 = PlayerPedId
        entityCoords5 = entityCoords5()
        playerPed = false
        while false == playerPed do
            serverId = Citizen
            serverId = serverId.Wait
            playerPed2 = 5
            serverId(playerPed2)
            playerPed = true
            serverId = NetworkDoesNetworkIdExist
            playerPed2 = A1_2
            serverId = serverId(playerPed2)
            if not serverId then
                playerPed = false
                serverId = DoesEntityExist
                playerPed2 = NetToVeh
                entityCoords = A1_2
                playerPed2, entityCoords, model, entityCoords6 = playerPed2(entityCoords)
                serverId = serverId(playerPed2, entityCoords, model, entityCoords6)
                if not serverId then
                    playerPed = false
                end
            end
        end
        serverId = NetToVeh
        playerPed2 = A1_2
        serverId = serverId(playerPed2)
        var15 = serverId

        -- Seoul: confirm the temporary vehicle authorization before the garage hotwire loop
        -- has a chance to shut the bumper engine off. AddBumperKey recalculates the exact plate.
        if var15 and DoesEntityExist(var15) then
            AddBumperKey(var15,GetEntityModel(var15),GetVehicleNumberPlateText(var15))
        end

        serverId = SetVehicleHasBeenOwnedByPlayer
        playerPed2 = var15
        entityCoords = true
        serverId(playerPed2,entityCoords)
        serverId = SetVehicleNeedsToBeHotwired
        playerPed2 = var15
        entityCoords = false
        serverId(playerPed2,entityCoords)
        serverId = SetModelAsNoLongerNeeded
        playerPed2 = bumpermodelveh
        serverId(playerPed2)
        serverId = SetVehRadioStation
        playerPed2 = var15
        entityCoords = "OFF"
        serverId(playerPed2, entityCoords)
        serverId = SetVehicleColours
        playerPed2 = var15
        entityCoords = 111
        model = 64
        serverId(playerPed2, entityCoords, model)
        serverId = SetVehicleDirtLevel
        playerPed2 = var15
        entityCoords = 0.1
        serverId(playerPed2, entityCoords)
        serverId = SetVehicleFuelLevel
        playerPed2 = var15
        entityCoords = 100.0
        serverId(playerPed2, entityCoords)
        serverId = SetEntityInvincible
        playerPed2 = var15
        serverId(playerPed2)
        serverId = SetVehicleEngineOn
        playerPed2 = var15
        entityCoords = true
        model = true
        entityCoords6 = true
        serverId(playerPed2, entityCoords, model, entityCoords6)
        serverId = SetVehicleRadioEnabled
        playerPed2 = var15
        entityCoords = false
        serverId(playerPed2, entityCoords)
        serverId = TaskWarpPedIntoVehicle
        playerPed2 = entityCoords5
        entityCoords = var15
        model = -1
        serverId(playerPed2, entityCoords, model)
        serverId = 60 * A0_2
        counter = serverId
        serverId = true
        isDisabled4 = serverId
        serverId = SendNUIMessage
        playerPed2 = {}
        playerPed2.message = "bumperupdatetime"
        entityCoords = counter
        playerPed2.bumpertimedata = entityCoords
        serverId(playerPed2)
        serverId = SendNUIMessage
        playerPed2 = {}
        playerPed2.message = "bumpercarsshow"
        playerPed2.bumperdriver = true
        entityCoords = Config
        entityCoords = entityCoords.AttractionsSettings
        entityCoords = entityCoords.bumpercars
        entityCoords = entityCoords.bumperleavekey
        playerPed2.bumperleavekeydata = entityCoords
        serverId(playerPed2)
        serverId = SetPlayerCanDoDriveBy
        playerPed2 = PlayerId
        playerPed2 = playerPed2()
        entityCoords = false
        serverId(playerPed2, entityCoords)
        serverId = PlateReformat
        playerPed2 = GetVehicleNumberPlateText
        entityCoords = var15
        playerPed2, entityCoords, model, entityCoords6 = playerPed2(entityCoords)
        serverId = serverId(playerPed2, entityCoords, model, entityCoords6)
        local _bumperPlate = serverId
        -- Seoul: the server already marks the temporary bumper entity with Lockpick = plate.
        -- No platePlayers/GlobalState vehicle registry dependency is required.
        SetVehicleEngineOn(var15, true, true, true)
        playerPed2 = AddBumperKey
        entityCoords = var15
        model = GetEntityModel
        entityCoords6 = var15
        model = model(entityCoords6)
        entityCoords6 = serverId
        playerPed2(entityCoords, model, entityCoords6)
    end
    condition(strValue, tableData)
end
condition = RegisterNetEvent
strValue = "rtx_themepark:Bumper:SynchronizeBumper"
condition(strValue)
condition = AddEventHandler
strValue = "rtx_themepark:Bumper:SynchronizeBumper"

function tableData(A0_2, A1_2, A2_2, A3_2, A4_2)
    local playerPed2, entityCoords
    playerPed2 = bumperhandler
    playerPed2 = playerPed2.bumperplayers
    playerPed2 = playerPed2[A0_2]
    if nil ~= playerPed2 then
        playerPed2 = bumperhandler
        playerPed2 = playerPed2.bumperplayers
        playerPed2 = playerPed2[A0_2]
        playerPed2.vehiclenetwork = A1_2
        playerPed2.seattaken = A2_2
        playerPed2.seattakenid = A3_2
    else
        playerPed2 = bumperhandler
        playerPed2 = playerPed2.bumperplayers
        entityCoords = {}
        entityCoords.seattaken = A2_2
        entityCoords.seattakenid = A3_2
        entityCoords.vehiclenetwork = A1_2
        entityCoords.vehicleobject = nil
        entityCoords.bumpercolor = A4_2
        entityCoords.removed = false
        playerPed2[A0_2] = entityCoords
    end
end
condition(strValue, tableData)
condition = RegisterNetEvent
strValue = "rtx_themepark:Bumper:SynchronizeBumperSeat"
condition(strValue)
condition = AddEventHandler
strValue = "rtx_themepark:Bumper:SynchronizeBumperSeat"

function tableData(A0_2, A1_2, A2_2)
    local playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11
    playerPed = bumperhandler
    playerPed = playerPed.bumperplayers
    playerPed = playerPed[A0_2]
    if nil ~= playerPed then
        playerPed = bumperhandler
        playerPed = playerPed.bumperplayers
        playerPed = playerPed[A0_2]
        playerPed.seattaken = A1_2
        if false == A1_2 then
            serverId = GetPlayerFromServerId
            playerPed2 = playerPed.seattakenid
            serverId = serverId(playerPed2)
            if -1 ~= serverId then
                playerPed2 = GetPlayerPed
                entityCoords = serverId
                playerPed2 = playerPed2(entityCoords)
                entityCoords = DoesEntityExist
                model = playerPed2
                entityCoords = entityCoords(model)
                if entityCoords then
                    entityCoords = DetachEntity
                    model = playerPed2
                    entityCoords(model)
                    entityCoords = FreezeEntityPosition
                    model = playerPed2
                    entityCoords6 = false
                    entityCoords(model, entityCoords6)
                    entityCoords = ClearPedTasks
                    model = playerPed2
                    entityCoords(model)
                end
            end
            playerPed.seattakenid = nil
        else
            playerPed.seattakenid = A2_2
            serverId = GetPlayerFromServerId
            playerPed2 = playerPed.seattakenid
            serverId = serverId(playerPed2)
            if -1 ~= serverId then
                playerPed2 = GetPlayerPed
                entityCoords = serverId
                playerPed2 = playerPed2(entityCoords)
                entityCoords = NetworkDoesNetworkIdExist
                model = playerPed.vehiclenetwork
                entityCoords = entityCoords(model)
                if entityCoords then
                    entityCoords = NetworkGetEntityFromNetworkId
                    model = playerPed.vehiclenetwork
                    entityCoords = entityCoords(model)
                    model = DoesEntityExist
                    entityCoords6 = entityCoords
                    model = model(entityCoords6)
                    if model then
                        model = DoesEntityExist
                        entityCoords6 = playerPed2
                        model = model(entityCoords6)
                        if model then
                            model = FreezeEntityPosition
                            entityCoords6 = playerPed2
                            hash = true
                            model(entityCoords6, hash)
                            model = NetworkAllowLocalEntityAttachment
                            entityCoords6 = playerPed2
                            hash = true
                            model(entityCoords6, hash)
                            model = AttachEntityToEntity
                            entityCoords6 = playerPed2
                            hash = entityCoords
                            entityCoords3 = 0
                            entityCoords2 = 0.25
                            isDisabled6 = -0.25
                            model2 = 0.1
                            isEnabled7 = 0.0
                            isDisabled3 = 0.0
                            isEnabled8 = 0.0
                            isEnabled3 = false
                            isEnabled10 = false
                            isEnabled9 = true
                            isDisabled2 = false
                            isEnabled5 = 2
                            isEnabled11 = true
                            model(entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11)
                            model = "anim@veh@gokart@generic@idles@base"
                            entityCoords6 = "base"
                            while true do
                                hash = HasAnimDictLoaded
                                entityCoords3 = model
                                hash = hash(entityCoords3)
                                if hash then
                                    break
                                end
                                hash = RequestAnimDict
                                entityCoords3 = model
                                hash(entityCoords3)
                                hash = Citizen
                                hash = hash.Wait
                                entityCoords3 = 5
                                hash(entityCoords3)
                            end
                            hash = TaskPlayAnim
                            entityCoords3 = playerPed2
                            entityCoords2 = model
                            isDisabled6 = entityCoords6
                            model2 = 8.0
                            isEnabled7 = 8.0
                            isDisabled3 = -1
                            isEnabled8 = 1
                            isEnabled3 = 0
                            isEnabled10 = 0
                            isEnabled9 = 0
                            isDisabled2 = 0
                            hash(entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2)
                        end
                    end
                end
            end
        end
    end
end
condition(strValue, tableData)
condition = RegisterNetEvent
strValue = "rtx_themepark:Bumper:SeatStart"
condition(strValue)
condition = AddEventHandler
strValue = "rtx_themepark:Bumper:SeatStart"

function tableData(A0_2)
    local entityCoords4, entityCoords5, playerPed
    entityCoords4 = isDisabled5
    if false == entityCoords4 then
        entityCoords4 = true
        isDisabled5 = entityCoords4
        var13 = A0_2
        entityCoords4 = SendNUIMessage
        entityCoords5 = {}
        entityCoords5.message = "bumpercarsshow"
        entityCoords5.bumperdriver = false
        playerPed = Config
        playerPed = playerPed.AttractionsSettings
        playerPed = playerPed.bumpercars
        playerPed = playerPed.bumperleavekey
        entityCoords5.bumperleavekeydata = playerPed
        entityCoords4(entityCoords5)
        entityCoords4 = SetPlayerCanDoDriveBy
        entityCoords5 = PlayerId
        entityCoords5 = entityCoords5()
        playerPed = false
        entityCoords4(entityCoords5, playerPed)
    end
end
condition(strValue, tableData)
condition = RegisterNetEvent
strValue = "rtx_themepark:Bumper:SeatStop"
condition(strValue)
condition = AddEventHandler
strValue = "rtx_themepark:Bumper:SeatStop"

function tableData()
    local dataTable3, entityCoords4, entityCoords5
    dataTable3 = isDisabled5
    if true == dataTable3 then
        dataTable3 = false
        isDisabled5 = dataTable3
        dataTable3 = nil
        var13 = dataTable3
        dataTable3 = SendNUIMessage
        entityCoords4 = {}
        entityCoords4.message = "hidebumpercars"
        dataTable3(entityCoords4)
        dataTable3 = SetPlayerCanDoDriveBy
        entityCoords4 = PlayerId
        entityCoords4 = entityCoords4()
        entityCoords5 = true
        dataTable3(entityCoords4, entityCoords5)
    end
end
condition(strValue, tableData)
condition = RegisterNetEvent
strValue = "rtx_themepark:Bumper:BumperEndClient"
condition(strValue)
condition = AddEventHandler
strValue = "rtx_themepark:Bumper:BumperEndClient"

function tableData(A0_2)
    local entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash
    entityCoords4 = bumperhandler
    entityCoords4 = entityCoords4.bumperplayers
    entityCoords4 = entityCoords4[A0_2]
    if nil ~= entityCoords4 then
        entityCoords4 = bumperhandler
        entityCoords4 = entityCoords4.bumperplayers
        entityCoords4 = entityCoords4[A0_2]
        entityCoords4.removed = true
        entityCoords5 = entityCoords4.seattaken
        if true == entityCoords5 then
            entityCoords5 = GetPlayerFromServerId
            playerPed = entityCoords4.seattakenid
            entityCoords5 = entityCoords5(playerPed)
            if -1 ~= entityCoords5 then
                playerPed = GetPlayerPed
                serverId = entityCoords5
                playerPed = playerPed(serverId)
                serverId = DoesEntityExist
                playerPed2 = playerPed
                serverId = serverId(playerPed2)
                if serverId then
                    serverId = DetachEntity
                    playerPed2 = playerPed
                    serverId(playerPed2)
                    serverId = FreezeEntityPosition
                    playerPed2 = playerPed
                    entityCoords = false
                    serverId(playerPed2, entityCoords)
                    serverId = ClearPedTasks
                    playerPed2 = playerPed
                    serverId(playerPed2)
                    serverId = isDisabled5
                    if true == serverId then
                        serverId = var13
                        if serverId == A0_2 then
                            serverId = GetPlayerServerId
                            playerPed2 = PlayerId
                            playerPed2, entityCoords, model, entityCoords6, hash = playerPed2()
                            serverId = serverId(playerPed2, entityCoords, model, entityCoords6, hash)
                            playerPed2 = entityCoords4.seattakenid
                            if serverId == playerPed2 then
                                playerPed2 = false
                                isDisabled5 = playerPed2
                                playerPed2 = nil
                                var13 = playerPed2
                                playerPed2 = SendNUIMessage
                                entityCoords = {}
                                entityCoords.message = "hidebumpercars"
                                playerPed2(entityCoords)
                                playerPed2 = SetEntityCoordsNoOffset
                                entityCoords = entityCoords5
                                model = Config
                                model = model.AttractionsSettings
                                model = model.bumpercars
                                model = model.bumperdespawncoords
                                model = model.coords
                                model = model.x
                                entityCoords6 = Config
                                entityCoords6 = entityCoords6.AttractionsSettings
                                entityCoords6 = entityCoords6.bumpercars
                                entityCoords6 = entityCoords6.bumperdespawncoords
                                entityCoords6 = entityCoords6.coords
                                entityCoords6 = entityCoords6.y
                                hash = Config
                                hash = hash.AttractionsSettings
                                hash = hash.bumpercars
                                hash = hash.bumperdespawncoords
                                hash = hash.coords
                                hash = hash.z
                                playerPed2(entityCoords, model, entityCoords6, hash)
                                playerPed2 = SetEntityHeading
                                entityCoords = entityCoords5
                                model = Config
                                model = model.AttractionsSettings
                                model = model.bumpercars
                                model = model.bumperdespawncoords
                                model = model.heading
                                playerPed2(entityCoords, model)
                                playerPed2 = SetPlayerCanDoDriveBy
                                entityCoords = PlayerId
                                entityCoords = entityCoords()
                                model = true
                                playerPed2(entityCoords, model)
                            end
                        end
                    end
                end
            end
        end
        entityCoords5 = NetworkDoesNetworkIdExist
        playerPed = entityCoords4.vehiclenetwork
        entityCoords5 = entityCoords5(playerPed)
        if entityCoords5 then
            entityCoords5 = NetworkGetEntityFromNetworkId
            playerPed = entityCoords4.vehiclenetwork
            entityCoords5 = entityCoords5(playerPed)
            playerPed = DoesEntityExist
            serverId = entityCoords5
            playerPed = playerPed(serverId)
            if playerPed then
                playerPed = DeleteEntity
                serverId = entityCoords5
                playerPed(serverId)
            end
        end
        entityCoords5 = DoesEntityExist
        playerPed = entityCoords4.vehicleobject
        entityCoords5 = entityCoords5(playerPed)
        if entityCoords5 then
            entityCoords5 = DetachEntity
            playerPed = entityCoords4.vehicleobject
            entityCoords5(playerPed)
            entityCoords5 = DeleteEntity
            playerPed = entityCoords4.vehicleobject
            entityCoords5(playerPed)
        end
        entityCoords5 = bumperhandler
        entityCoords5 = entityCoords5.bumperplayers
        entityCoords5[A0_2] = nil
    end
end
condition(strValue, tableData)
condition = Config
condition = condition.AttractionsSettings
condition = condition.bumpercars
condition = condition.disable
if false == condition then
    condition = Citizen
    condition = condition.CreateThread

    function strValue()
        local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model
        while true do
            dataTable3 = Citizen
            dataTable3 = dataTable3.Wait
            entityCoords4 = 0
            dataTable3(entityCoords4)
            dataTable3 = true
            entityCoords4 = false
            entityCoords5 = nearbythemepark
            if true == entityCoords5 then
                entityCoords5 = tickets
                if entityCoords5 == nil then return end
                entityCoords5 = entityCoords5.bumpercars
                if false == entityCoords5 then
                    entityCoords5 = playercurrentcoords
                    playerPed = bumperhandler
                    playerPed = playerPed.coordsbuy
                    entityCoords5 = entityCoords5 - playerPed
                    entityCoords5 = #entityCoords5
                    playerPed = Config
                    playerPed = playerPed.ThemeParkTicketMachineSettings
                    playerPed = playerPed.usedistance
                    if entityCoords5 < playerPed then
                        entityCoords4 = true
                    end
                end
            end
            if entityCoords4 then
                dataTable3 = false
                entityCoords5 = isDisabled
                if false == entityCoords5 then
                    entityCoords5 = Config
                    entityCoords5 = entityCoords5.Target
                    if false == entityCoords5 then
                        entityCoords5 = Config
                        entityCoords5 = entityCoords5.ThemeParkInteractionSystem
                        if 1 == entityCoords5 then
                            entityCoords5 = SendNUIMessage
                            playerPed = {}
                            playerPed.message = "infonotifyshow"
                            serverId = Language
                            playerPed2 = Config
                            playerPed2 = playerPed2.Language
                            serverId = serverId[playerPed2]
                            serverId = serverId.pressforbuyticketinteract
                            playerPed.infonotifytext = serverId
                            entityCoords5(playerPed)
                        else
                            entityCoords5 = Config
                            entityCoords5 = entityCoords5.ThemeParkInteractionSystem
                            if 2 == entityCoords5 then
                                entityCoords5 = DrawText3D
                                playerPed = bumperhandler
                                playerPed = playerPed.coordsbuy
                                playerPed = playerPed.x
                                serverId = bumperhandler
                                serverId = serverId.coordsbuy
                                serverId = serverId.y
                                playerPed2 = bumperhandler
                                playerPed2 = playerPed2.coordsbuy
                                playerPed2 = playerPed2.z
                                entityCoords = Language
                                model = Config
                                model = model.Language
                                entityCoords = entityCoords[model]
                                entityCoords = entityCoords.pressforbuyticket
                                entityCoords5(playerPed, serverId, playerPed2, entityCoords)
                            else
                                entityCoords5 = Config
                                entityCoords5 = entityCoords5.ThemeParkInteractionSystem
                                if 3 == entityCoords5 then
                                    entityCoords5 = ShowGtaClassicInteraction
                                    playerPed = Language
                                    serverId = Config
                                    serverId = serverId.Language
                                    playerPed = playerPed[serverId]
                                    playerPed = playerPed.pressforbuyticketinteractclassic
                                    entityCoords5(playerPed)
                                end
                            end
                        end
                    end
                else
                    entityCoords5 = Config
                    entityCoords5 = entityCoords5.ThemeParkInteractionSystem
                    if 1 == entityCoords5 then
                        entityCoords5 = SendNUIMessage
                        playerPed = {}
                        playerPed.message = "hide"
                        entityCoords5(playerPed)
                    end
                end
            else
                entityCoords5 = Config
                entityCoords5 = entityCoords5.ThemeParkInteractionSystem
                if 1 == entityCoords5 then
                    entityCoords5 = SendNUIMessage
                    playerPed = {}
                    playerPed.message = "hide"
                    entityCoords5(playerPed)
                end
            end
            if dataTable3 then
                entityCoords5 = Citizen
                entityCoords5 = entityCoords5.Wait
                playerPed = 1000
                entityCoords5(playerPed)
            end
        end
    end
    condition(strValue)
    condition = Citizen
    condition = condition.CreateThread

    function strValue()
        local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2
        while true do
            dataTable3 = Citizen
            dataTable3 = dataTable3.Wait
            entityCoords4 = 0
            dataTable3(entityCoords4)
            dataTable3 = true
            entityCoords4 = false
            entityCoords5 = -1
            playerPed = nil
            serverId = isDisabled4
            if false == serverId then
                serverId = isDisabled5
                if false == serverId then
                    serverId = nearbythemepark
                    if true == serverId then
                        serverId = pairs
                        playerPed2 = bumperhandler
                        playerPed2 = playerPed2.bumperplayers
                        serverId, playerPed2, entityCoords, model = serverId(playerPed2)
                        for entityCoords6, hash in serverId, playerPed2, entityCoords, model do
                            entityCoords3 = hash.seattaken
                            if false == entityCoords3 then
                                entityCoords3 = NetworkDoesNetworkIdExist
                                entityCoords2 = hash.vehiclenetwork
                                entityCoords3 = entityCoords3(entityCoords2)
                                if entityCoords3 then
                                    entityCoords3 = NetworkGetEntityFromNetworkId
                                    entityCoords2 = hash.vehiclenetwork
                                    entityCoords3 = entityCoords3(entityCoords2)
                                    entityCoords2 = DoesEntityExist
                                    isDisabled6 = entityCoords3
                                    entityCoords2 = entityCoords2(isDisabled6)
                                    if entityCoords2 then
                                        entityCoords2 = GetEntityCoords
                                        isDisabled6 = entityCoords3
                                        entityCoords2 = entityCoords2(isDisabled6)
                                        isDisabled6 = playercurrentcoords
                                        isDisabled6 = isDisabled6 - entityCoords2
                                        isDisabled6 = #isDisabled6
                                        if isDisabled6 < 20.0 then
                                            model2 = Config
                                            model2 = model2.AttractionsSettings
                                            model2 = model2.bumpercars
                                            model2 = model2.seatdistance
                                            if isDisabled6 < model2 and (-1 == entityCoords5 or entityCoords5 > isDisabled6) then
                                                entityCoords5 = isDisabled6
                                                entityCoords4 = true
                                                playerPed = entityCoords6
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if entityCoords4 then
                var12 = playerPed
                serverId = usingattraction
                if false == serverId then
                    dataTable3 = false
                    serverId = Config
                    serverId = serverId.ThemeParkInteractionSystem
                    if 1 == serverId then
                        serverId = SendNUIMessage
                        playerPed2 = {}
                        playerPed2.message = "infonotifyshow"
                        entityCoords = Language
                        model = Config
                        model = model.Language
                        entityCoords = entityCoords[model]
                        entityCoords = entityCoords.pressforusebumperinteract
                        playerPed2.infonotifytext = entityCoords
                        serverId(playerPed2)
                    else
                        serverId = Config
                        serverId = serverId.ThemeParkInteractionSystem
                        if 2 == serverId then
                            serverId = bumperhandler
                            serverId = serverId.bumperplayers
                            playerPed2 = var12
                            serverId = serverId[playerPed2]
                            playerPed2 = NetworkDoesNetworkIdExist
                            entityCoords = serverId.vehiclenetwork
                            playerPed2 = playerPed2(entityCoords)
                            if playerPed2 then
                                playerPed2 = NetworkGetEntityFromNetworkId
                                entityCoords = serverId.vehiclenetwork
                                playerPed2 = playerPed2(entityCoords)
                                entityCoords = DoesEntityExist
                                model = playerPed2
                                entityCoords = entityCoords(model)
                                if entityCoords then
                                    entityCoords = GetEntityCoords
                                    model = playerPed2
                                    entityCoords = entityCoords(model)
                                    model = DrawText3D
                                    entityCoords6 = entityCoords.x
                                    hash = entityCoords.y
                                    entityCoords3 = entityCoords.z
                                    entityCoords2 = Language
                                    isDisabled6 = Config
                                    isDisabled6 = isDisabled6.Language
                                    entityCoords2 = entityCoords2[isDisabled6]
                                    entityCoords2 = entityCoords2.pressforusebumper
                                    model(entityCoords6, hash, entityCoords3, entityCoords2)
                                end
                            end
                        else
                            serverId = Config
                            serverId = serverId.ThemeParkInteractionSystem
                            if 3 == serverId then
                                serverId = ShowGtaClassicInteraction
                                playerPed2 = Language
                                entityCoords = Config
                                entityCoords = entityCoords.Language
                                playerPed2 = playerPed2[entityCoords]
                                playerPed2 = playerPed2.pressforusebumperinteractclassic
                                serverId(playerPed2)
                            end
                        end
                    end
                end
            else
                serverId = Config
                serverId = serverId.ThemeParkInteractionSystem
                if 1 == serverId then
                    serverId = SendNUIMessage
                    playerPed2 = {}
                    playerPed2.message = "hide"
                    serverId(playerPed2)
                end
                serverId = nil
                var12 = serverId
            end
            if dataTable3 then
                serverId = Citizen
                serverId = serverId.Wait
                playerPed2 = 1000
                serverId(playerPed2)
            end
        end
    end
    condition(strValue)
    condition = Citizen
    condition = condition.CreateThread

    function strValue()
        local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6, hash, entityCoords3, entityCoords2, isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled, var2, isEnabled2
        while true do
            dataTable3 = Citizen
            dataTable3 = dataTable3.Wait
            entityCoords4 = 0
            dataTable3(entityCoords4)
            dataTable3 = true
            entityCoords4 = nearbythemepark
            if true == entityCoords4 then
                entityCoords4 = pairs
                entityCoords5 = bumperhandler
                entityCoords5 = entityCoords5.bumperplayers
                entityCoords4, entityCoords5, playerPed, serverId = entityCoords4(entityCoords5)
                for playerPed2, entityCoords in entityCoords4, entityCoords5, playerPed, serverId do
                    model = NetworkDoesNetworkIdExist
                    entityCoords6 = entityCoords.vehiclenetwork
                    model = model(entityCoords6)
                    if model then
                        model = NetToVeh
                        entityCoords6 = entityCoords.vehiclenetwork
                        model = model(entityCoords6)
                        entityCoords6 = DoesEntityExist
                        hash = model
                        entityCoords6 = entityCoords6(hash)
                        if entityCoords6 then
                            entityCoords6 = DoesEntityExist
                            hash = entityCoords.vehicleobject
                            entityCoords6 = entityCoords6(hash)
                            if entityCoords6 then
                            else
                                entityCoords6 = entityCoords.removed
                                if false == entityCoords6 then
                                    entityCoords6 = GetColorBumper
                                    hash = entityCoords.bumpercolor
                                    entityCoords6 = entityCoords6(hash)
                                    hash = GetHashKey
                                    entityCoords3 = entityCoords6
                                    hash = hash(entityCoords3)
                                    entityCoords3 = RequestModel
                                    entityCoords2 = hash
                                    entityCoords3(entityCoords2)
                                    while true do
                                        entityCoords3 = HasModelLoaded
                                        entityCoords2 = hash
                                        entityCoords3 = entityCoords3(entityCoords2)
                                        if entityCoords3 then
                                            break
                                        end
                                        entityCoords3 = RequestModel
                                        entityCoords2 = hash
                                        entityCoords3(entityCoords2)
                                        entityCoords3 = Citizen
                                        entityCoords3 = entityCoords3.Wait
                                        entityCoords2 = 5
                                        entityCoords3(entityCoords2)
                                    end
                                    entityCoords3 = GetEntityCoords
                                    entityCoords2 = model
                                    entityCoords3 = entityCoords3(entityCoords2)
                                    entityCoords2 = CreateObjectNoOffset
                                    isDisabled6 = hash
                                    model2 = entityCoords3.x
                                    isEnabled7 = entityCoords3.y
                                    isDisabled3 = entityCoords3.z
                                    isEnabled8 = false
                                    isEnabled3 = true
                                    isEnabled10 = true
                                    entityCoords2 = entityCoords2(isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10)
                                    entityCoords.vehicleobject = entityCoords2
                                    entityCoords2 = FreezeEntityPosition
                                    isDisabled6 = entityCoords.vehicleobject
                                    model2 = true
                                    entityCoords2(isDisabled6, model2)
                                    entityCoords2 = SetEntityInvincible
                                    isDisabled6 = entityCoords.vehicleobject
                                    entityCoords2(isDisabled6)
                                    entityCoords2 = AttachEntityToEntity
                                    isDisabled6 = entityCoords.vehicleobject
                                    model2 = model
                                    isEnabled7 = 0
                                    isDisabled3 = 0.0
                                    isEnabled8 = 0.0
                                    isEnabled3 = -0.1
                                    isEnabled10 = 0.0
                                    isEnabled9 = 0.0
                                    isDisabled2 = 180.0
                                    isEnabled5 = false
                                    isEnabled11 = false
                                    isEnabled6 = true
                                    isEnabled = false
                                    var2 = 2
                                    isEnabled2 = true
                                    entityCoords2(isDisabled6, model2, isEnabled7, isDisabled3, isEnabled8, isEnabled3, isEnabled10, isEnabled9, isDisabled2, isEnabled5, isEnabled11, isEnabled6, isEnabled, var2, isEnabled2)
                                end
                            end
                        end
                    end
                end
            end
            if dataTable3 then
                entityCoords4 = Citizen
                entityCoords4 = entityCoords4.Wait
                entityCoords5 = 1000
                entityCoords4(entityCoords5)
            end
        end
    end
    condition(strValue)
    condition = Citizen
    condition = condition.CreateThread

    function strValue()
        local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6
        while true do
            dataTable3 = Citizen
            dataTable3 = dataTable3.Wait
            entityCoords4 = 1000
            dataTable3(entityCoords4)
            dataTable3 = isDisabled4
            if true == dataTable3 then
                dataTable3 = counter
                if dataTable3 > 0 then
                    dataTable3 = counter
                    dataTable3 = dataTable3 - 1
                    counter = dataTable3
                    dataTable3 = SendNUIMessage
                    entityCoords4 = {}
                    entityCoords4.message = "bumperupdatetime"
                    entityCoords5 = counter
                    entityCoords4.bumpertimedata = entityCoords5
                    dataTable3(entityCoords4)
                else
                    dataTable3 = PlayerPedId
                    dataTable3 = dataTable3()
                    entityCoords4 = 0
                    counter = entityCoords4
                    entityCoords4 = false
                    isDisabled4 = entityCoords4
                    entityCoords4 = GetPlayerServerId
                    entityCoords5 = PlayerId
                    entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6 = entityCoords5()
                    entityCoords4 = entityCoords4(entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6)
                    entityCoords5 = bumperhandler
                    entityCoords5 = entityCoords5.bumperplayers
                    entityCoords5 = entityCoords5[entityCoords4]
                    playerPed = DoesEntityExist
                    serverId = entityCoords5.vehicleobject
                    playerPed = playerPed(serverId)
                    if playerPed then
                        playerPed = DeleteEntity
                        serverId = entityCoords5.vehicleobject
                        playerPed(serverId)
                    end
                    playerPed = PlateReformat
                    serverId = GetVehicleNumberPlateText
                    playerPed2 = var15
                    serverId, playerPed2, entityCoords, model, entityCoords6 = serverId(playerPed2)
                    playerPed = playerPed(serverId, playerPed2, entityCoords, model, entityCoords6)
                                serverId = RemoveBumperKey
                    playerPed2 = var15
                    entityCoords = GetEntityModel
                    model = var15
                    entityCoords = entityCoords(model)
                    model = playerPed
                    serverId(playerPed2, entityCoords, model)
                    serverId = Config
                    serverId = serverId.ServerSideObjectsOnly
                    if false == serverId then
                        serverId = DoesEntityExist
                        playerPed2 = var15
                        serverId = serverId(playerPed2)
                        if serverId then
                            serverId = DeleteEntity
                            playerPed2 = var15
                            serverId(playerPed2)
                        end
                    end
                    serverId = SetEntityCoordsNoOffset
                    playerPed2 = dataTable3
                    entityCoords = Config
                    entityCoords = entityCoords.AttractionsSettings
                    entityCoords = entityCoords.bumpercars
                    entityCoords = entityCoords.bumperdespawncoords
                    entityCoords = entityCoords.coords
                    entityCoords = entityCoords.x
                    model = Config
                    model = model.AttractionsSettings
                    model = model.bumpercars
                    model = model.bumperdespawncoords
                    model = model.coords
                    model = model.y
                    entityCoords6 = Config
                    entityCoords6 = entityCoords6.AttractionsSettings
                    entityCoords6 = entityCoords6.bumpercars
                    entityCoords6 = entityCoords6.bumperdespawncoords
                    entityCoords6 = entityCoords6.coords
                    entityCoords6 = entityCoords6.z
                    serverId(playerPed2, entityCoords, model, entityCoords6)
                    serverId = SetEntityHeading
                    playerPed2 = dataTable3
                    entityCoords = Config
                    entityCoords = entityCoords.AttractionsSettings
                    entityCoords = entityCoords.bumpercars
                    entityCoords = entityCoords.bumperdespawncoords
                    entityCoords = entityCoords.heading
                    serverId(playerPed2, entityCoords)
                    serverId = TriggerServerEvent
                    playerPed2 = "rtx_themepark:Bumper:BumperEnd"
                    serverId(playerPed2)
                    serverId = SendNUIMessage
                    playerPed2 = {}
                    playerPed2.message = "hidebumpercars"
                    serverId(playerPed2)
                    serverId = SetPlayerCanDoDriveBy
                    playerPed2 = PlayerId
                    playerPed2 = playerPed2()
                    entityCoords = true
                    serverId(playerPed2, entityCoords)
                end
            end
        end
    end
    condition(strValue)
    condition = Config
    condition = condition.AttractionsSettings
    condition = condition.bumpercars
    condition = condition.disablebumperkeyboard
    if condition then
        condition = Citizen
        condition = condition.CreateThread

        function strValue()
            local dataTable3, entityCoords4
            while true do
                dataTable3 = Citizen
                dataTable3 = dataTable3.Wait
                entityCoords4 = 5
                dataTable3(entityCoords4)
                dataTable3 = isDisabled4
                if true ~= dataTable3 then
                    dataTable3 = isDisabled5
                    if true ~= dataTable3 then
                        goto lbl_14
                    end
                end
                dataTable3 = DisableControlsBumper
                dataTable3()
                goto lbl_18
                ::lbl_14::
                dataTable3 = Citizen
                dataTable3 = dataTable3.Wait
                entityCoords4 = 1500
                dataTable3(entityCoords4)
                ::lbl_18::
            end
        end
        condition(strValue)
    end
end
condition = Config
condition = condition.Target
if false == condition then
    condition = RegisterCommand
    strValue = "buybumperticket"

    function tableData()
        local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2
        dataTable3 = PlayerPedId
        dataTable3 = dataTable3()
        entityCoords4 = GetEntityCoords
        entityCoords5 = dataTable3
        entityCoords4 = entityCoords4(entityCoords5)
        entityCoords5 = tickets
        if entityCoords5 == nil then return end
        entityCoords5 = entityCoords5.bumpercars
        if false == entityCoords5 then
            entityCoords5 = bumperhandler
            entityCoords5 = entityCoords5.coordsbuy
            entityCoords5 = entityCoords4 - entityCoords5
            entityCoords5 = #entityCoords5
            playerPed = Config
            playerPed = playerPed.ThemeParkTicketMachineSettings
            playerPed = playerPed.usedistance
            if entityCoords5 < playerPed then
                playerPed = iteminhand
                if false == playerPed then
                    playerPed = TriggerServerEvent
                    serverId = "rtx_themepark:Bumper:CheckTickets"
                    playerPed(serverId)
                else
                    playerPed = Notify
                    serverId = Language
                    playerPed2 = Config
                    playerPed2 = playerPed2.Language
                    serverId = serverId[playerPed2]
                    serverId = serverId.iteminhand
                    playerPed(serverId)
                end
            end
        end
    end
    condition(strValue, tableData)
    condition = RegisterKeyMapping
    strValue = "buybumperticket"
    tableData = Language
    strValue2 = Config
    strValue2 = strValue2.Language
    tableData = tableData[strValue2]
    tableData = tableData.bindbuyticket
    strValue2 = "keyboard"
    var1 = Config
    var1 = var1.ThemeParkTicketMachineSettings
    var1 = var1.usekey
    condition(strValue, tableData, strValue2, var1)
end
condition = RegisterCommand
strValue = "usebumperseat"

function tableData()
    local dataTable3, entityCoords4, entityCoords5
    dataTable3 = isDisabled5
    if false == dataTable3 then
        dataTable3 = var12
        if nil ~= dataTable3 then
            dataTable3 = iteminhand
            if false == dataTable3 then
                dataTable3 = TriggerServerEvent
                entityCoords4 = "rtx_themepark:Bumper:BumperSeatStart"
                entityCoords5 = var12
                dataTable3(entityCoords4, entityCoords5)
            else
                dataTable3 = Notify
                entityCoords4 = Language
                entityCoords5 = Config
                entityCoords5 = entityCoords5.Language
                entityCoords4 = entityCoords4[entityCoords5]
                entityCoords4 = entityCoords4.iteminhand
                dataTable3(entityCoords4)
            end
        end
    end
end
condition(strValue, tableData)
condition = RegisterKeyMapping
strValue = "usebumperseat"
tableData = Language
strValue2 = Config
strValue2 = strValue2.Language
tableData = tableData[strValue2]
tableData = tableData.bindusebumper
strValue2 = "keyboard"
var1 = Config
var1 = var1.AttractionsSettings
var1 = var1.bumpercars
var1 = var1.bumperusekey
condition(strValue, tableData, strValue2, var1)
condition = RegisterCommand
strValue = "leavebumper"

function tableData()
    local dataTable3, entityCoords4, entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6
    dataTable3 = isDisabled4
    if true == dataTable3 then
        dataTable3 = PlayerPedId
        dataTable3 = dataTable3()
        entityCoords4 = 0
        counter = entityCoords4
        entityCoords4 = false
        isDisabled4 = entityCoords4
        entityCoords4 = GetPlayerServerId
        entityCoords5 = PlayerId
        entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6 = entityCoords5()
        entityCoords4 = entityCoords4(entityCoords5, playerPed, serverId, playerPed2, entityCoords, model, entityCoords6)
        entityCoords5 = bumperhandler
        entityCoords5 = entityCoords5.bumperplayers
        entityCoords5 = entityCoords5[entityCoords4]
        playerPed = DoesEntityExist
        serverId = entityCoords5.vehicleobject
        playerPed = playerPed(serverId)
        if playerPed then
            playerPed = DeleteEntity
            serverId = entityCoords5.vehicleobject
            playerPed(serverId)
        end
        playerPed = PlateReformat
        serverId = GetVehicleNumberPlateText
        playerPed2 = var15
        serverId, playerPed2, entityCoords, model, entityCoords6 = serverId(playerPed2)
        playerPed = playerPed(serverId, playerPed2, entityCoords, model, entityCoords6)
        serverId = RemoveBumperKey
        playerPed2 = var15
        entityCoords = GetEntityModel
        model = var15
        entityCoords = entityCoords(model)
        model = playerPed
        serverId(playerPed2, entityCoords, model)
        serverId = Config
        serverId = serverId.ServerSideObjectsOnly
        if false == serverId then
            serverId = DoesEntityExist
            playerPed2 = var15
            serverId = serverId(playerPed2)
            if serverId then
                serverId = DeleteEntity
                playerPed2 = var15
                serverId(playerPed2)
            end
        end
        serverId = SetEntityCoordsNoOffset
        playerPed2 = dataTable3
        entityCoords = Config
        entityCoords = entityCoords.AttractionsSettings
        entityCoords = entityCoords.bumpercars
        entityCoords = entityCoords.bumperdespawncoords
        entityCoords = entityCoords.coords
        entityCoords = entityCoords.x
        model = Config
        model = model.AttractionsSettings
        model = model.bumpercars
        model = model.bumperdespawncoords
        model = model.coords
        model = model.y
        entityCoords6 = Config
        entityCoords6 = entityCoords6.AttractionsSettings
        entityCoords6 = entityCoords6.bumpercars
        entityCoords6 = entityCoords6.bumperdespawncoords
        entityCoords6 = entityCoords6.coords
        entityCoords6 = entityCoords6.z
        serverId(playerPed2, entityCoords, model, entityCoords6)
        serverId = SetEntityHeading
        playerPed2 = dataTable3
        entityCoords = Config
        entityCoords = entityCoords.AttractionsSettings
        entityCoords = entityCoords.bumpercars
        entityCoords = entityCoords.bumperdespawncoords
        entityCoords = entityCoords.heading
        serverId(playerPed2, entityCoords)
        serverId = TriggerServerEvent
        playerPed2 = "rtx_themepark:Bumper:BumperEnd"
        serverId(playerPed2)
        serverId = SendNUIMessage
        playerPed2 = {}
        playerPed2.message = "hidebumpercars"
        serverId(playerPed2)
        serverId = SetPlayerCanDoDriveBy
        playerPed2 = PlayerId
        playerPed2 = playerPed2()
        entityCoords = true
        serverId(playerPed2, entityCoords)
    else
        dataTable3 = isDisabled5
        if true == dataTable3 then
            dataTable3 = var13
            if nil ~= dataTable3 then
                dataTable3 = TriggerServerEvent
                entityCoords4 = "rtx_themepark:Bumper:BumperSeatEnd"
                entityCoords5 = var13
                dataTable3(entityCoords4, entityCoords5)
            end
        end
    end
end
condition(strValue, tableData)
condition = RegisterKeyMapping
strValue = "leavebumper"
tableData = Language
strValue2 = Config
strValue2 = strValue2.Language
tableData = tableData[strValue2]
tableData = tableData.bindleavebumper
strValue2 = "keyboard"
var1 = Config
var1 = var1.AttractionsSettings
var1 = var1.bumpercars
var1 = var1.bumperleavekey
condition(strValue, tableData, strValue2, var1)