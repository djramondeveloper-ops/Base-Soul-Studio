
local dataTable2, counter4, counter5, var14, dataTable5, isDisabled, isEnabled8, isDisabled2, counter3, var12, var1, dataTable3, dataTable6, dataTable4, coords, counter2, counter, var13
dataTable2 = IsDuplicityVersion
dataTable2 = dataTable2()
if dataTable2 then
    dataTable2 = GetPlayerPositionInRealTime76
    dataTable2()
end
dataTable2 = {}
counter4 = 0
counter5 = 0
var14 = nil
dataTable5 = {}
dataTable5.screen1 = nil
dataTable5.screen2 = nil
isDisabled = false
isEnabled8 = true
isDisabled2 = false
counter3 = 0
var12 = nil
var1 = nil
dataTable3 = {}
dataTable6 = {}
dataTable4 = {}
coords = vector3
counter2 = -1674.04
counter = -1137.58
var13 = 13.5
coords = coords(counter2, counter, var13)
dataTable4.coords = coords
dataTable4.heading = 187.0
dataTable4.taken = false
coords = vector3
counter2 = -1673.80933
counter = -1140.61292
var13 = 14.0093746
coords = coords(counter2, counter, var13)
dataTable4.screencoords = coords
coords = vector3
counter2 = 0.0
counter = 0.0
var13 = -85.0
coords = coords(counter2, counter, var13)
dataTable4.screenrotation = coords
dataTable6[1] = dataTable4
dataTable4 = {}
coords = vector3
counter2 = -1640.65
counter = -1099.73
var13 = 13.5
coords = coords(counter2, counter, var13)
dataTable4.coords = coords
dataTable4.heading = 319.0
dataTable4.taken = false
coords = vector3
counter2 = -1638.60571
counter = -1097.55676
var13 = 14.04349
coords = coords(counter2, counter, var13)
dataTable4.screencoords = coords
coords = vector3
counter2 = 0.0
counter = 0.0
var13 = 49.4
coords = coords(counter2, counter, var13)
dataTable4.screenrotation = coords
dataTable6[2] = dataTable4
dataTable4 = {}
coords = vector3
counter2 = -1593.67
counter = -1095.86
var13 = 13.5
coords = coords(counter2, counter, var13)
dataTable4.coords = coords
dataTable4.heading = 230.0
dataTable4.taken = false
coords = vector3
counter2 = -1591.2832
counter = -1098.0968
var13 = 14.0477915
coords = coords(counter2, counter, var13)
dataTable4.screencoords = coords
coords = vector3
counter2 = 0.0
counter = 0.0
var13 = -40.0
coords = coords(counter2, counter, var13)
dataTable4.screenrotation = coords
dataTable6[3] = dataTable4
dataTable3.shooters = dataTable6
shooterhandler = dataTable3
dataTable3 = RegisterNetEvent
dataTable6 = "rtx_themepark:Shooter:Started"
dataTable3(dataTable6)
dataTable3 = AddEventHandler
dataTable6 = "rtx_themepark:Shooter:Started"

function dataTable4(A0_2)
    local hash4
end
dataTable3(dataTable6, dataTable4)
dataTable3 = RegisterNetEvent
dataTable6 = "rtx_themepark:Shooter:SynchronizeShooter"
dataTable3(dataTable6)
dataTable3 = AddEventHandler
dataTable6 = "rtx_themepark:Shooter:SynchronizeShooter"

function dataTable4(A0_2, A1_2)
    local isEnabled10
    isEnabled10 = shooterhandler
    isEnabled10 = isEnabled10.shooters
    isEnabled10 = isEnabled10[A0_2]
    isEnabled10.taken = A1_2
end
dataTable3(dataTable6, dataTable4)
dataTable3 = RegisterNetEvent
dataTable6 = "rtx_themepark:Shooter:StartClient"
dataTable3(dataTable6)
dataTable3 = AddEventHandler
dataTable6 = "rtx_themepark:Shooter:StartClient"

function dataTable4(A0_2)
    local hash4, isEnabled10, entityCoords, isEnabled4, hash6, hash, hash5, heading, dataTable, hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6
    hash4 = shooterhandler
    hash4 = hash4.shooters
    hash4 = hash4[A0_2]
    isEnabled10 = isDisabled
    if false == isEnabled10 then
        var12 = A0_2
        isEnabled10 = true
        isDisabled = isEnabled10
        isEnabled10 = Config
        isEnabled10 = isEnabled10.OxInventory
        if isEnabled10 then
            isEnabled10 = exports
            isEnabled10 = isEnabled10.ox_inventory
            entityCoords = isEnabled10
            isEnabled10 = isEnabled10.weaponWheel
            isEnabled4 = true
            isEnabled10(entityCoords, isEnabled4)
        end
        isEnabled10 = TriggerEvent
        entityCoords = "rtx_themepark:Shooter:Started"
        isEnabled4 = true
        isEnabled10(entityCoords, isEnabled4)
        isEnabled10 = PlayerPedId
        isEnabled10 = isEnabled10()
        entityCoords = GetEntityCoords
        isEnabled4 = isEnabled10
        entityCoords = entityCoords(isEnabled4)
        isEnabled4 = GetFollowPedCamViewMode
        isEnabled4 = isEnabled4()
        hash6 = FreezeEntityPosition
        hash = isEnabled10
        hash5 = true
        hash6(hash, hash5)
        hash6 = SetEntityCoordsNoOffset
        hash = isEnabled10
        hash5 = hash4.coords
        hash5 = hash5.x
        heading = hash4.coords
        heading = heading.y
        dataTable = hash4.coords
        dataTable = dataTable.z
        hash3 = true
        hash2 = false
        isEnabled9 = false
        hash6(hash, hash5, heading, dataTable, hash3, hash2, isEnabled9)
        hash6 = SetEntityHeading
        hash = isEnabled10
        hash5 = hash4.heading
        hash6(hash, hash5)
        hash6 = GetHashKey
        hash = "sempre_delperropier_bus_blue_screen"
        hash6 = hash6(hash)
        hash = RequestModel
        hash5 = hash6
        hash(hash5)
        while true do
            hash = HasModelLoaded
            hash5 = hash6
            hash = hash(hash5)
            if hash then
                break
            end
            hash = RequestModel
            hash5 = hash6
            hash(hash5)
            hash = Citizen
            hash = hash.Wait
            hash5 = 5
            hash(hash5)
        end
        hash = CreateObjectNoOffset
        hash5 = hash6
        heading = hash4.screencoords
        heading = heading.x
        dataTable = hash4.screencoords
        dataTable = dataTable.y
        hash3 = hash4.screencoords
        hash3 = hash3.z
        hash2 = true
        isEnabled9 = true
        isEnabled11 = true
        hash = hash(hash5, heading, dataTable, hash3, hash2, isEnabled9, isEnabled11)
        var14 = hash
        hash = SetEntityRotation
        hash5 = var14
        heading = hash4.screenrotation
        heading = heading.x
        dataTable = hash4.screenrotation
        dataTable = dataTable.y
        hash3 = hash4.screenrotation
        hash3 = hash3.z
        hash(hash5, heading, dataTable, hash3)
        hash = NetworkAllowLocalEntityAttachment
        hash5 = var14
        heading = true
        hash(hash5, heading)
        hash = FreezeEntityPosition
        hash5 = var14
        heading = true
        hash(hash5, heading)
        hash = SetEntityVisible
        hash5 = var14
        heading = false
        hash(hash5, heading)
        hash = SetEntityInvincible
        hash5 = var14
        heading = true
        hash(hash5, heading)
        hash = GetHashKey
        hash5 = "sempre_delperropier_bus_blue_screen"
        hash = hash(hash5)
        hash5 = RequestModel
        heading = hash
        hash5(heading)
        while true do
            hash5 = HasModelLoaded
            heading = hash
            hash5 = hash5(heading)
            if hash5 then
                break
            end
            hash5 = RequestModel
            heading = hash
            hash5(heading)
            hash5 = Citizen
            hash5 = hash5.Wait
            heading = 5
            hash5(heading)
        end
        hash5 = CreateObjectNoOffset
        heading = hash
        dataTable = hash4.screencoords
        dataTable = dataTable.x
        hash3 = hash4.screencoords
        hash3 = hash3.y
        hash2 = hash4.screencoords
        hash2 = hash2.z
        isEnabled9 = true
        isEnabled11 = true
        isEnabled7 = true
        hash5 = hash5(heading, dataTable, hash3, hash2, isEnabled9, isEnabled11, isEnabled7)
        dataTable5.screen1 = hash5
        hash5 = SetEntityRotation
        heading = dataTable5.screen1
        dataTable = hash4.screenrotation
        dataTable = dataTable.x
        hash3 = hash4.screenrotation
        hash3 = hash3.y
        hash2 = hash4.screenrotation
        hash2 = hash2.z
        hash5(heading, dataTable, hash3, hash2)
        hash5 = NetworkAllowLocalEntityAttachment
        heading = dataTable5.screen1
        dataTable = true
        hash5(heading, dataTable)
        hash5 = FreezeEntityPosition
        heading = dataTable5.screen1
        dataTable = true
        hash5(heading, dataTable)
        hash5 = SetEntityInvincible
        heading = dataTable5.screen1
        dataTable = true
        hash5(heading, dataTable)
        hash5 = GetHashKey
        heading = "sempre_delperropier_bus_red_screen"
        hash5 = hash5(heading)
        heading = RequestModel
        dataTable = hash5
        heading(dataTable)
        while true do
            heading = HasModelLoaded
            dataTable = hash5
            heading = heading(dataTable)
            if heading then
                break
            end
            heading = RequestModel
            dataTable = hash5
            heading(dataTable)
            heading = Citizen
            heading = heading.Wait
            dataTable = 5
            heading(dataTable)
        end
        heading = CreateObjectNoOffset
        dataTable = hash5
        hash3 = hash4.screencoords
        hash3 = hash3.x
        hash2 = hash4.screencoords
        hash2 = hash2.y
        isEnabled9 = hash4.screencoords
        isEnabled9 = isEnabled9.z
        isEnabled11 = true
        isEnabled7 = true
        isEnabled6 = true
        heading = heading(dataTable, hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6)
        dataTable5.screen2 = heading
        heading = SetEntityRotation
        dataTable = dataTable5.screen2
        hash3 = hash4.screenrotation
        hash3 = hash3.x
        hash2 = hash4.screenrotation
        hash2 = hash2.y
        isEnabled9 = hash4.screenrotation
        isEnabled9 = isEnabled9.z
        heading(dataTable, hash3, hash2, isEnabled9)
        heading = NetworkAllowLocalEntityAttachment
        dataTable = dataTable5.screen2
        hash3 = true
        heading(dataTable, hash3)
        heading = FreezeEntityPosition
        dataTable = dataTable5.screen2
        hash3 = true
        heading(dataTable, hash3)
        heading = SetEntityVisible
        dataTable = dataTable5.screen2
        hash3 = false
        heading(dataTable, hash3)
        heading = SetEntityInvincible
        dataTable = dataTable5.screen2
        hash3 = true
        heading(dataTable, hash3)
        heading = 0
        counter4 = heading
        heading = 0
        counter5 = heading
        heading = Config
        heading = heading.AttractionsSettings
        heading = heading.shootingrange
        heading = heading.timetoshoot
        counter3 = heading
        heading = true
        isDisabled2 = heading
        heading = SetFollowPedCamViewMode
        dataTable = 4
        heading(dataTable)
        heading = GiveWeaponToPed
        dataTable = isEnabled10
        hash3 = GetHashKey
        hash2 = Config
        hash2 = hash2.AttractionsSettings
        hash2 = hash2.shootingrange
        hash2 = hash2.shootingrangeweapon
        hash3 = hash3(hash2)
        hash2 = 5
        isEnabled9 = false
        isEnabled11 = true
        heading(dataTable, hash3, hash2, isEnabled9, isEnabled11)
        heading = SendNUIMessage
        dataTable = {}
        dataTable.message = "shootershow"
        hash3 = counter4
        dataTable.shootsdata = hash3
        hash3 = counter5
        dataTable.missdata = hash3
        hash3 = counter3
        dataTable.timedata = hash3
        heading(dataTable)
        heading = 1
        dataTable = Config
        dataTable = dataTable.AttractionsSettings
        dataTable = dataTable.shootingrange
        dataTable = dataTable.maxtargets
        hash3 = 1
        for hash2 = heading, dataTable, hash3 do
            isEnabled9 = SpawnNewTarget
            isEnabled9()
        end
        while true do
            heading = isDisabled2
            if not heading then
                break
            end
            heading = counter5
            dataTable = Config
            dataTable = dataTable.AttractionsSettings
            dataTable = dataTable.shootingrange
            dataTable = dataTable.maxmistakes
            if not (heading < dataTable) then
                break
            end
            heading = GetEntityHeading
            dataTable = isEnabled10
            heading = heading(dataTable)
            dataTable = hash4.heading
            dataTable = dataTable + 0.1
            if not (heading > dataTable) then
                dataTable = hash4.heading
                dataTable = dataTable - 0.1
                if not (heading < dataTable) then
                    goto lbl_291
                end
            end
            dataTable = SetEntityHeading
            hash3 = isEnabled10
            hash2 = hash4.heading
            dataTable(hash3, hash2)
            ::lbl_291::
            dataTable = Citizen
            dataTable = dataTable.Wait
            hash3 = 0
            dataTable(hash3)
            dataTable = SetFollowPedCamViewMode
            hash3 = 4
            dataTable(hash3)
            dataTable = SetControlNormal
            hash3 = 0
            hash2 = 25
            isEnabled9 = 1.0
            dataTable(hash3, hash2, isEnabled9)
            dataTable = SetAmmoInClip
            hash3 = isEnabled10
            hash2 = GetHashKey
            isEnabled9 = Config
            isEnabled9 = isEnabled9.AttractionsSettings
            isEnabled9 = isEnabled9.shootingrange
            isEnabled9 = isEnabled9.shootingrangeweapon
            hash2 = hash2(isEnabled9)
            isEnabled9 = 1
            dataTable(hash3, hash2, isEnabled9)
            dataTable = SetCurrentPedWeapon
            hash3 = isEnabled10
            hash2 = GetHashKey
            isEnabled9 = Config
            isEnabled9 = isEnabled9.AttractionsSettings
            isEnabled9 = isEnabled9.shootingrange
            isEnabled9 = isEnabled9.shootingrangeweapon
            hash2 = hash2(isEnabled9)
            isEnabled9 = true
            dataTable(hash3, hash2, isEnabled9)
        end
        heading = SetFollowPedCamViewMode
        dataTable = isEnabled4
        heading(dataTable)
        heading = RemoveWeaponFromPed
        dataTable = isEnabled10
        hash3 = GetHashKey
        hash2 = Config
        hash2 = hash2.AttractionsSettings
        hash2 = hash2.shootingrange
        hash2 = hash2.shootingrangeweapon
        hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6 = hash3(hash2)
        heading(dataTable, hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6)
        heading = SetCurrentPedWeapon
        dataTable = isEnabled10
        hash3 = GetHashKey
        hash2 = "WEAPON_UNARMED"
        hash3 = hash3(hash2)
        hash2 = true
        heading(dataTable, hash3, hash2)
        heading = ipairs
        dataTable = dataTable2
        heading, dataTable, hash3, hash2 = heading(dataTable)
        for isEnabled9, isEnabled11 in heading, dataTable, hash3, hash2 do
            isEnabled7 = DoesEntityExist
            isEnabled6 = isEnabled11.handler
            isEnabled7 = isEnabled7(isEnabled6)
            if isEnabled7 then
                isEnabled7 = DeleteEntity
                isEnabled6 = isEnabled11.handler
                isEnabled7(isEnabled6)
            end
        end
        heading = DoesEntityExist
        dataTable = var14
        heading = heading(dataTable)
        if heading then
            heading = DeleteEntity
            dataTable = var14
            heading(dataTable)
        end
        heading = DoesEntityExist
        dataTable = dataTable5.screen1
        heading = heading(dataTable)
        if heading then
            heading = DeleteEntity
            dataTable = dataTable5.screen1
            heading(dataTable)
        end
        heading = DoesEntityExist
        dataTable = dataTable5.screen2
        heading = heading(dataTable)
        if heading then
            heading = DeleteEntity
            dataTable = dataTable5.screen2
            heading(dataTable)
        end
        heading = SendNUIMessage
        dataTable = {}
        dataTable.message = "shooterendshow"
        hash3 = counter4
        dataTable.shootsdata = hash3
        hash3 = counter5
        dataTable.missdata = hash3
        heading(dataTable)
        heading = TriggerServerEvent
        dataTable = "rtx_themepark:Shooter:End"
        hash3 = var12
        hash2 = counter4
        heading(dataTable, hash3, hash2)
        heading = {}
        dataTable2 = heading
        heading = 0
        counter4 = heading
        heading = 0
        counter5 = heading
        heading = nil
        var14 = heading
        heading = {}
        heading.screen1 = nil
        heading.screen2 = nil
        dataTable5 = heading
        heading = false
        isDisabled2 = heading
        heading = 0
        counter3 = heading
        heading = true
        isEnabled8 = heading
        heading = FreezeEntityPosition
        dataTable = isEnabled10
        hash3 = false
        heading(dataTable, hash3)
        heading = Config
        heading = heading.OxInventory
        if heading then
            heading = exports
            heading = heading.ox_inventory
            dataTable = heading
            heading = heading.weaponWheel
            hash3 = false
            heading(dataTable, hash3)
        end
        heading = TriggerEvent
        dataTable = "rtx_themepark:Shooter:Started"
        hash3 = false
        heading(dataTable, hash3)
        heading = Citizen
        heading = heading.Wait
        dataTable = 2500
        heading(dataTable)
        heading = false
        isDisabled = heading
        heading = nil
        var12 = heading
    end
end
dataTable3(dataTable6, dataTable4)
dataTable3 = Config
dataTable3 = dataTable3.Target
if true == dataTable3 then
    dataTable3 = RegisterNetEvent
    dataTable6 = "rtx_themepark:Shooter:UseShooter"
    dataTable3(dataTable6)
    dataTable3 = AddEventHandler
    dataTable6 = "rtx_themepark:Shooter:UseShooter"

    function dataTable4()
        local hash7, hash4, isEnabled10
        hash7 = tickets
        if hash7 == nil then return end
        hash7 = hash7.shootingrange
        if true == hash7 then
            hash7 = isDisabled
            if false == hash7 then
                hash7 = usingattraction
                if false == hash7 then
                    hash7 = var1
                    if nil ~= hash7 then
                        hash7 = iteminhand
                        if false == hash7 then
                            hash7 = TriggerServerEvent
                            hash4 = "rtx_themepark:Shooter:Start"
                            isEnabled10 = var1
                            hash7(hash4, isEnabled10)
                        else
                            hash7 = Notify
                            hash4 = Language
                            isEnabled10 = Config
                            isEnabled10 = isEnabled10.Language
                            hash4 = hash4[isEnabled10]
                            hash4 = hash4.iteminhand
                            hash7(hash4)
                        end
                    end
                end
            end
        end
    end
    dataTable3(dataTable6, dataTable4)
end

function dataTable3()
    local hash7, hash4, isEnabled10, entityCoords, isEnabled4, hash6, hash, hash5, heading, dataTable, hash3, hash2, isEnabled9, isEnabled11
    hash7 = 0.0
    hash4 = 0.0
    isEnabled10 = math
    isEnabled10 = isEnabled10.random
    entityCoords = 1
    isEnabled4 = 2
    isEnabled10 = isEnabled10(entityCoords, isEnabled4)
    entityCoords = ""
    if 2 == isEnabled10 then
        entityCoords = "-"
    end
    isEnabled4 = math
    isEnabled4 = isEnabled4.random
    hash6 = 1
    hash = 2
    isEnabled4 = isEnabled4(hash6, hash)
    hash6 = ""
    if 2 == isEnabled4 then
        hash6 = "-"
    end
    hash = math
    hash = hash.random
    hash5 = 14
    hash = hash(hash5)
    hash = hash / 10
    hash5 = math
    hash5 = hash5.random
    heading = 7
    hash5 = hash5(heading)
    hash5 = hash5 / 10
    heading = tonumber
    dataTable = ""
    hash3 = entityCoords
    hash2 = ""
    isEnabled9 = hash
    isEnabled11 = ""
    dataTable = dataTable .. hash3 .. hash2 .. isEnabled9 .. isEnabled11
    heading = heading(dataTable)
    hash = heading
    heading = tonumber
    dataTable = ""
    hash3 = hash6
    hash2 = ""
    isEnabled9 = hash5
    isEnabled11 = ""
    dataTable = dataTable .. hash3 .. hash2 .. isEnabled9 .. isEnabled11
    heading = heading(dataTable)
    hash5 = heading
    heading = hash
    dataTable = hash5
    return heading, dataTable
end
GenerateOffsetShoot = dataTable3

function dataTable3()
    local hash7, hash4, isEnabled10, entityCoords, isEnabled4, hash6, hash, hash5, heading, dataTable, hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6, isDisabled3, isEnabled2, isDisabled5, isDisabled4, isEnabled5
    hash7 = shooterhandler
    hash7 = hash7.shooters
    hash4 = var12
    hash7 = hash7[hash4]
    hash4 = GetHashKey
    isEnabled10 = "sempre_delperropier_bus_target"
    hash4 = hash4(isEnabled10)
    isEnabled10 = RequestModel
    entityCoords = hash4
    isEnabled10(entityCoords)
    while true do
        isEnabled10 = HasModelLoaded
        entityCoords = hash4
        isEnabled10 = isEnabled10(entityCoords)
        if isEnabled10 then
            break
        end
        isEnabled10 = RequestModel
        entityCoords = hash4
        isEnabled10(entityCoords)
        isEnabled10 = Citizen
        isEnabled10 = isEnabled10.Wait
        entityCoords = 5
        isEnabled10(entityCoords)
    end
    isEnabled10 = CreateObjectNoOffset
    entityCoords = hash4
    isEnabled4 = hash7.screencoords
    isEnabled4 = isEnabled4.x
    hash6 = hash7.screencoords
    hash6 = hash6.y
    hash = hash7.screencoords
    hash = hash.z
    hash5 = true
    heading = true
    dataTable = true
    isEnabled10 = isEnabled10(entityCoords, isEnabled4, hash6, hash, hash5, heading, dataTable)
    entityCoords = NetworkAllowLocalEntityAttachment
    isEnabled4 = isEnabled10
    hash6 = true
    entityCoords(isEnabled4, hash6)
    entityCoords = FreezeEntityPosition
    isEnabled4 = isEnabled10
    hash6 = true
    entityCoords(isEnabled4, hash6)
    entityCoords = GenerateOffsetShoot
    entityCoords, isEnabled4 = entityCoords()
    hash6 = AttachEntityToEntity
    hash = isEnabled10
    hash5 = var14
    heading = 0
    dataTable = 0.0
    hash3 = entityCoords
    hash2 = isEnabled4
    isEnabled9 = 0.0
    isEnabled11 = 0.0
    isEnabled7 = 0.0
    isEnabled6 = false
    isDisabled3 = false
    isEnabled2 = true
    isDisabled5 = false
    isDisabled4 = 2
    isEnabled5 = true
    hash6(hash, hash5, heading, dataTable, hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6, isDisabled3, isEnabled2, isDisabled5, isDisabled4, isEnabled5)
    hash6 = SetEntityVisible
    hash = isEnabled10
    hash5 = true
    hash6(hash, hash5)
    hash6 = GenerateOffsetShoot
    hash6, hash = hash6()
    hash5 = table
    hash5 = hash5.insert
    heading = dataTable2
    dataTable = {}
    dataTable.handler = isEnabled10
    hash3 = {}
    hash3.offset1 = entityCoords
    hash3.offset2 = isEnabled4
    dataTable.oldoffsets = hash3
    hash3 = {}
    hash3.offset1 = hash6
    hash3.offset2 = hash
    dataTable.destinationoffsets = hash3
    hash5(heading, dataTable)
end
SpawnNewTarget = dataTable3
dataTable3 = Config
dataTable3 = dataTable3.AttractionsSettings
dataTable3 = dataTable3.shootingrange
dataTable3 = dataTable3.disable
if false == dataTable3 then
    dataTable3 = Citizen
    dataTable3 = dataTable3.CreateThread

    function dataTable6()
        local hash7, hash4, isEnabled10, entityCoords, isEnabled4, hash6, hash, hash5, heading, dataTable, hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6, isDisabled3, isEnabled2, isDisabled5, isDisabled4, isEnabled5, isEnabled3, isDisabled6, var2, isEnabled
        while true do
            hash7 = Citizen
            hash7 = hash7.Wait
            hash4 = 0
            hash7(hash4)
            hash7 = isDisabled2
            if true == hash7 then
                hash7 = Citizen
                hash7 = hash7.Wait
                hash4 = 20
                hash7(hash4)
                hash7 = GetHashKey
                hash4 = Config
                hash4 = hash4.AttractionsSettings
                hash4 = hash4.shootingrange
                hash4 = hash4.shootingrangeweapon
                hash7 = hash7(hash4)
                hash4 = Config
                hash4 = hash4.AttractionsSettings
                hash4 = hash4.shootingrange
                hash4 = hash4.defaultspeed
                isEnabled10 = counter4
                if isEnabled10 > 1 then
                    isEnabled10 = counter4
                    entityCoords = Config
                    entityCoords = entityCoords.AttractionsSettings
                    entityCoords = entityCoords.shootingrange
                    entityCoords = entityCoords.maxpeektargets
                    isEnabled10 = isEnabled10 / entityCoords
                    isEnabled10 = isEnabled10 * 100.0
                    entityCoords = Config
                    entityCoords = entityCoords.AttractionsSettings
                    entityCoords = entityCoords.shootingrange
                    entityCoords = entityCoords.maxspeed
                    isEnabled4 = Config
                    isEnabled4 = isEnabled4.AttractionsSettings
                    isEnabled4 = isEnabled4.shootingrange
                    isEnabled4 = isEnabled4.defaultspeed
                    entityCoords = entityCoords - isEnabled4
                    entityCoords = isEnabled10 * entityCoords
                    entityCoords = entityCoords / 100
                    isEnabled4 = Config
                    isEnabled4 = isEnabled4.AttractionsSettings
                    isEnabled4 = isEnabled4.shootingrange
                    isEnabled4 = isEnabled4.defaultspeed
                    hash4 = entityCoords + isEnabled4
                end
                isEnabled10 = counter4
                entityCoords = Config
                entityCoords = entityCoords.AttractionsSettings
                entityCoords = entityCoords.shootingrange
                entityCoords = entityCoords.maxpeektargets
                if isEnabled10 > entityCoords then
                    isEnabled10 = Config
                    isEnabled10 = isEnabled10.AttractionsSettings
                    isEnabled10 = isEnabled10.shootingrange
                    hash4 = isEnabled10.maxspeed
                end
                isEnabled10 = ipairs
                entityCoords = dataTable2
                isEnabled10, entityCoords, isEnabled4, hash6 = isEnabled10(entityCoords)
                for hash, hash5 in isEnabled10, entityCoords, isEnabled4, hash6 do
                    heading = DoesEntityExist
                    dataTable = hash5.handler
                    heading = heading(dataTable)
                    if heading then
                        heading = true
                        dataTable = hash5.destinationoffsets
                        dataTable = dataTable.offset1
                        if dataTable > 0.0 then
                            dataTable = hash5.oldoffsets
                            dataTable = dataTable.offset1
                            hash3 = hash5.destinationoffsets
                            hash3 = hash3.offset1
                            if dataTable < hash3 then
                                dataTable = hash5.oldoffsets
                                hash3 = hash5.oldoffsets
                                hash3 = hash3.offset1
                                hash3 = hash3 + hash4
                                dataTable.offset1 = hash3
                                heading = false
                            end
                        else
                            dataTable = hash5.oldoffsets
                            dataTable = dataTable.offset1
                            hash3 = hash5.destinationoffsets
                            hash3 = hash3.offset1
                            if dataTable > hash3 then
                                dataTable = hash5.oldoffsets
                                hash3 = hash5.oldoffsets
                                hash3 = hash3.offset1
                                hash3 = hash3 - hash4
                                dataTable.offset1 = hash3
                                heading = false
                            end
                        end
                        dataTable = hash5.destinationoffsets
                        dataTable = dataTable.offset2
                        if dataTable > 0.0 then
                            dataTable = hash5.oldoffsets
                            dataTable = dataTable.offset2
                            hash3 = hash5.destinationoffsets
                            hash3 = hash3.offset2
                            if dataTable < hash3 then
                                dataTable = hash5.oldoffsets
                                hash3 = hash5.oldoffsets
                                hash3 = hash3.offset2
                                hash3 = hash3 + hash4
                                dataTable.offset2 = hash3
                                heading = false
                            end
                        else
                            dataTable = hash5.oldoffsets
                            dataTable = dataTable.offset2
                            hash3 = hash5.destinationoffsets
                            hash3 = hash3.offset2
                            if dataTable > hash3 then
                                dataTable = hash5.oldoffsets
                                hash3 = hash5.oldoffsets
                                hash3 = hash3.offset2
                                hash3 = hash3 - hash4
                                dataTable.offset2 = hash3
                                heading = false
                            end
                        end
                        if true == heading then
                            dataTable = GenerateOffsetShoot
                            dataTable, hash3 = dataTable()
                            hash2 = hash5.destinationoffsets
                            hash2.offset1 = dataTable
                            hash2 = hash5.destinationoffsets
                            hash2.offset2 = hash3
                        end
                        dataTable = AttachEntityToEntity
                        hash3 = hash5.handler
                        hash2 = var14
                        isEnabled9 = 0
                        isEnabled11 = 0.0
                        isEnabled7 = hash5.oldoffsets
                        isEnabled7 = isEnabled7.offset1
                        isEnabled6 = hash5.oldoffsets
                        isEnabled6 = isEnabled6.offset2
                        isDisabled3 = 0.0
                        isEnabled2 = 0.0
                        isDisabled5 = 0.0
                        isDisabled4 = false
                        isEnabled5 = false
                        isEnabled3 = true
                        isDisabled6 = false
                        var2 = 2
                        isEnabled = true
                        dataTable(hash3, hash2, isEnabled9, isEnabled11, isEnabled7, isEnabled6, isDisabled3, isEnabled2, isDisabled5, isDisabled4, isEnabled5, isEnabled3, isDisabled6, var2, isEnabled)
                        dataTable = HasEntityBeenDamagedByWeapon
                        hash3 = hash5.handler
                        hash2 = hash7
                        dataTable = dataTable(hash3, hash2)
                        if dataTable then
                            dataTable = DeleteEntity
                            hash3 = hash5.handler
                            dataTable(hash3)
                            dataTable = table
                            dataTable = dataTable.remove
                            hash3 = dataTable2
                            hash2 = hash
                            dataTable(hash3, hash2)
                            dataTable = isEnabled8
                            if true == dataTable then
                                dataTable = counter4
                                dataTable = dataTable + 1
                                counter4 = dataTable
                                dataTable = Config
                                dataTable = dataTable.AttractionsSettings
                                dataTable = dataTable.shootingrange
                                dataTable = dataTable.timetoshoot
                                counter3 = dataTable
                                dataTable = SendNUIMessage
                                hash3 = {}
                                hash3.message = "shootershow"
                                hash2 = counter4
                                hash3.shootsdata = hash2
                                hash2 = counter5
                                hash3.missdata = hash2
                                hash2 = counter3
                                hash3.timedata = hash2
                                dataTable(hash3)
                                dataTable = SendNUIMessage
                                hash3 = {}
                                hash3.message = "shooterhit"
                                hash3.hittext = "hit"
                                dataTable(hash3)
                            else
                                dataTable = counter5
                                dataTable = dataTable + 1
                                counter5 = dataTable
                                dataTable = SendNUIMessage
                                hash3 = {}
                                hash3.message = "shootershow"
                                hash2 = counter4
                                hash3.shootsdata = hash2
                                hash2 = counter5
                                hash3.missdata = hash2
                                hash2 = counter3
                                hash3.timedata = hash2
                                dataTable(hash3)
                                dataTable = SendNUIMessage
                                hash3 = {}
                                hash3.message = "shooterhit"
                                hash3.hittext = "miss"
                                dataTable(hash3)
                            end
                            dataTable = SpawnNewTarget
                            dataTable()
                        end
                    end
                end
            else
                hash7 = Citizen
                hash7 = hash7.Wait
                hash4 = 1000
                hash7(hash4)
            end
        end
    end
    dataTable3(dataTable6)
    dataTable3 = Citizen
    dataTable3 = dataTable3.CreateThread

    function dataTable6()
        local hash7, hash4, isEnabled10
        while true do
            hash7 = Citizen
            hash7 = hash7.Wait
            hash4 = 2500
            hash7(hash4)
            hash7 = isDisabled2
            if true == hash7 then
                hash7 = isEnabled8
                if true == hash7 then
                    hash7 = false
                    isEnabled8 = hash7
                    hash7 = SetEntityVisible
                    hash4 = dataTable5.screen1
                    isEnabled10 = false
                    hash7(hash4, isEnabled10)
                    hash7 = SetEntityVisible
                    hash4 = dataTable5.screen2
                    isEnabled10 = true
                    hash7(hash4, isEnabled10)
                else
                    hash7 = true
                    isEnabled8 = hash7
                    hash7 = SetEntityVisible
                    hash4 = dataTable5.screen1
                    isEnabled10 = true
                    hash7(hash4, isEnabled10)
                    hash7 = SetEntityVisible
                    hash4 = dataTable5.screen2
                    isEnabled10 = false
                    hash7(hash4, isEnabled10)
                end
                hash7 = isEnabled8
                if true == hash7 then
                    hash7 = math
                    hash7 = hash7.random
                    hash4 = 2000
                    isEnabled10 = 5000
                    hash7 = hash7(hash4, isEnabled10)
                    hash4 = Citizen
                    hash4 = hash4.Wait
                    isEnabled10 = hash7
                    hash4(isEnabled10)
                end
            end
        end
    end
    dataTable3(dataTable6)
    dataTable3 = Citizen
    dataTable3 = dataTable3.CreateThread

    function dataTable6()
        local hash7, hash4, isEnabled10
        while true do
            hash7 = Citizen
            hash7 = hash7.Wait
            hash4 = 1000
            hash7(hash4)
            hash7 = isDisabled2
            if true == hash7 then
                hash7 = isEnabled8
                if true == hash7 then
                    hash7 = counter3
                    if hash7 > 1 then
                        hash7 = counter3
                        hash7 = hash7 - 1
                        counter3 = hash7
                    else
                        hash7 = false
                        isDisabled2 = hash7
                    end
                    hash7 = SendNUIMessage
                    hash4 = {}
                    hash4.message = "shootershow"
                    isEnabled10 = counter4
                    hash4.shootsdata = isEnabled10
                    isEnabled10 = counter5
                    hash4.missdata = isEnabled10
                    isEnabled10 = counter3
                    hash4.timedata = isEnabled10
                    hash7(hash4)
                end
            end
        end
    end
    dataTable3(dataTable6)
    dataTable3 = Citizen
    dataTable3 = dataTable3.CreateThread

    function dataTable6()
        local hash7, hash4, isEnabled10, entityCoords, isEnabled4, hash6, hash, hash5, heading, dataTable, hash3, hash2
        while true do
            hash7 = Citizen
            hash7 = hash7.Wait
            hash4 = 0
            hash7(hash4)
            hash7 = true
            hash4 = false
            isEnabled10 = -1
            entityCoords = nil
            isEnabled4 = tickets
            if isEnabled4 == nil then return end
            isEnabled4 = isEnabled4.shootingrange
            if true == isEnabled4 then
                isEnabled4 = isDisabled
                if false == isEnabled4 then
                    isEnabled4 = ipairs
                    hash6 = shooterhandler
                    hash6 = hash6.shooters
                    isEnabled4, hash6, hash, hash5 = isEnabled4(hash6)
                    for heading, dataTable in isEnabled4, hash6, hash, hash5 do
                        hash3 = dataTable.taken
                        if false == hash3 then
                            hash3 = playercurrentcoords
                            hash2 = dataTable.coords
                            hash3 = hash3 - hash2
                            hash3 = #hash3
                            if hash3 < 20.0 then
                                hash2 = Config
                                hash2 = hash2.AttractionsSettings
                                hash2 = hash2.shootingrange
                                hash2 = hash2.usedistance
                                if hash3 < hash2 and (-1 == isEnabled10 or isEnabled10 > hash3) then
                                    isEnabled10 = hash3
                                    hash4 = true
                                    entityCoords = heading
                                end
                            end
                        end
                    end
                end
            end
            if hash4 then
                var1 = entityCoords
                isEnabled4 = usingattraction
                if false == isEnabled4 then
                    hash7 = false
                    isEnabled4 = Config
                    isEnabled4 = isEnabled4.Target
                    if false == isEnabled4 then
                        isEnabled4 = shooterhandler
                        isEnabled4 = isEnabled4.shooters
                        hash6 = var1
                        isEnabled4 = isEnabled4[hash6]
                        hash6 = Config
                        hash6 = hash6.ThemeParkInteractionSystem
                        if 1 == hash6 then
                            hash6 = SendNUIMessage
                            hash = {}
                            hash.message = "infonotifyshow"
                            hash5 = Language
                            heading = Config
                            heading = heading.Language
                            hash5 = hash5[heading]
                            hash5 = hash5.pressforuseshootingrangeinteract
                            hash.infonotifytext = hash5
                            hash6(hash)
                        else
                            hash6 = Config
                            hash6 = hash6.ThemeParkInteractionSystem
                            if 2 == hash6 then
                                hash6 = DrawText3D
                                hash = isEnabled4.coords
                                hash = hash.x
                                hash5 = isEnabled4.coords
                                hash5 = hash5.y
                                heading = isEnabled4.coords
                                heading = heading.z
                                dataTable = Language
                                hash3 = Config
                                hash3 = hash3.Language
                                dataTable = dataTable[hash3]
                                dataTable = dataTable.pressforuseshootingrange
                                hash6(hash, hash5, heading, dataTable)
                            else
                                hash6 = Config
                                hash6 = hash6.ThemeParkInteractionSystem
                                if 3 == hash6 then
                                    hash6 = ShowGtaClassicInteraction
                                    hash = Language
                                    hash5 = Config
                                    hash5 = hash5.Language
                                    hash = hash[hash5]
                                    hash = hash.pressforuseshootingrangeinteractclassic
                                    hash6(hash)
                                end
                            end
                        end
                    end
                end
            else
                isEnabled4 = Config
                isEnabled4 = isEnabled4.ThemeParkInteractionSystem
                if 1 == isEnabled4 then
                    isEnabled4 = var1
                    if nil ~= isEnabled4 then
                        isEnabled4 = SendNUIMessage
                        hash6 = {}
                        hash6.message = "hide"
                        isEnabled4(hash6)
                    end
                end
                isEnabled4 = nil
                var1 = isEnabled4
            end
            if hash7 then
                isEnabled4 = Citizen
                isEnabled4 = isEnabled4.Wait
                hash6 = 1000
                isEnabled4(hash6)
            end
        end
    end
    dataTable3(dataTable6)
end
dataTable3 = Config
dataTable3 = dataTable3.Target
if false == dataTable3 then
    dataTable3 = RegisterCommand
    dataTable6 = "useshootingrange"

    function dataTable4()
        local hash7, hash4, isEnabled10
        hash7 = usingattraction
        if false == hash7 then
            hash7 = var1
            if nil ~= hash7 then
                hash7 = iteminhand
                if false == hash7 then
                    hash7 = TriggerServerEvent
                    hash4 = "rtx_themepark:Shooter:Start"
                    isEnabled10 = var1
                    hash7(hash4, isEnabled10)
                else
                    hash7 = Notify
                    hash4 = Language
                    isEnabled10 = Config
                    isEnabled10 = isEnabled10.Language
                    hash4 = hash4[isEnabled10]
                    hash4 = hash4.iteminhand
                    hash7(hash4)
                end
            end
        end
    end
    dataTable3(dataTable6, dataTable4)
    dataTable3 = RegisterKeyMapping
    dataTable6 = "useshootingrange"
    dataTable4 = Language
    coords = Config
    coords = coords.Language
    dataTable4 = dataTable4[coords]
    dataTable4 = dataTable4.playshootingrange
    coords = "keyboard"
    counter2 = Config
    counter2 = counter2.AttractionsSettings
    counter2 = counter2.shootingrange
    counter2 = counter2.shootingrangeusekey
    dataTable3(dataTable6, dataTable4, coords, counter2)
end