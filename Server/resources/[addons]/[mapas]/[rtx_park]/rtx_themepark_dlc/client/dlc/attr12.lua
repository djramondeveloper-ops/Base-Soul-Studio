
local dataTable3, dataTable5, dataTable6, dataTable8, func, counter, counter3, strValue2, tableData, strValue, var1
dataTable3 = IsDuplicityVersion
dataTable3 = dataTable3()
if dataTable3 then
    dataTable3 = GetPlayerPositionInRealTime80
    dataTable3()
end
dataTable3 = {}
dataTable3.ropeobjecthandler1 = nil
dataTable3.ropeobjecthandler2 = nil
dataTable3.ropehandler1 = nil
dataTable3.ropehandler2 = nil
dataTable3.getnew = false
dataTable3.ridedata1 = 0.0
dataTable3.ridedata2 = 0.0
dataTable3.rideway = 1
dataTable5 = {}
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable8 = {}
func = vec3
counter = 0.33
counter3 = -0.011
strValue2 = -0.432
func = func(counter, counter3, strValue2)
dataTable8.coords = func
func = vec3
counter = 0.0
counter3 = 0.0
strValue2 = 180.0
func = func(counter, counter3, strValue2)
dataTable8.rotation = func
dataTable6.offsets = dataTable8
dataTable5[1] = dataTable6
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable8 = {}
func = vec3
counter = -0.284
counter3 = -0.011
strValue2 = -0.432
func = func(counter, counter3, strValue2)
dataTable8.coords = func
func = vec3
counter = 0.0
counter3 = 0.0
strValue2 = 180.0
func = func(counter, counter3, strValue2)
dataTable8.rotation = func
dataTable6.offsets = dataTable8
dataTable5[2] = dataTable6
dataTable3.seats = dataTable5
dataTable5 = nil
dataTable6 = nil
dataTable8 = {}
dataTable8.seatid = nil
func = nil
counter = RegisterNetEvent
counter3 = "rtx_themepark:SlingShot:SynchronizeMovement"
counter(counter3)
counter = AddEventHandler
counter3 = "rtx_themepark:SlingShot:SynchronizeMovement"

function strValue2(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
    local dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2, isDisabled7, isDisabled6, var22, isEnabled, isDisabled9, isDisabled3, isDisabled, isDisabled10, var2, isEnabled3
    dataTable4 = nearbythemepark
    if true == dataTable4 then
        if 15 == A5_2 or 16 == A5_2 then
            dataTable3.getnew = true
            dataTable4 = heightdata
            dataTable3.heightdata = dataTable4
            dataTable4 = rotationdata
            dataTable3.currentrotation = dataTable4
            dataTable4 = rotationdata2
            dataTable3.currentrotation2 = dataTable4
            dataTable4 = SetEntityCoordsNoOffset
            dataTable7 = dataTable5
            isEnabled6 = -1611.79
            dataTable2 = -1106.84
            counter4 = heightdata
            counter4 = 20.5 + counter4
            dataTable4(dataTable7, isEnabled6, dataTable2, counter4)
            dataTable4 = SetEntityRotation
            dataTable7 = dataTable5
            isEnabled6 = 0.0
            dataTable2 = 0.0
            counter4 = rotationdata
            dataTable4(dataTable7, isEnabled6, dataTable2, counter4)
            dataTable4 = ipairs
            dataTable7 = seats
            dataTable4, dataTable7, isEnabled6, dataTable2 = dataTable4(dataTable7)
            for counter4, isDisabled5 in dataTable4, dataTable7, isEnabled6, dataTable2 do
                isDisabled8 = DoesEntityExist
                isEnabled5 = isDisabled5.handler
                isDisabled8 = isDisabled8(isEnabled5)
                if isDisabled8 then
                    isDisabled8 = AttachEntityToEntity
                    isEnabled5 = isDisabled5.handler
                    isDisabled4 = dataTable5
                    counter2 = 0
                    isEnabled4 = isDisabled5.coords
                    isEnabled4 = isEnabled4.x
                    isDisabled2 = isDisabled5.coords
                    isDisabled2 = isDisabled2.y
                    isDisabled7 = isDisabled5.coords
                    isDisabled7 = isDisabled7.z
                    isDisabled6 = rotationdata2
                    var22 = isDisabled5.rotation
                    var22 = var22.y
                    isEnabled = isDisabled5.rotation
                    isEnabled = isEnabled.z
                    isDisabled9 = false
                    isDisabled3 = false
                    isDisabled = false
                    isDisabled10 = false
                    var2 = 2
                    isEnabled3 = true
                    isDisabled8(isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2, isDisabled7, isDisabled6, var22, isEnabled, isDisabled9, isDisabled3, isDisabled, isDisabled10, var2, isEnabled3)
                end
            end
        else
            dataTable3.getnew = true
            dataTable4 = SetEntityRotation
            dataTable7 = dataTable5
            isEnabled6 = A1_2
            dataTable2 = 0.0
            counter4 = -40.0
            dataTable4(dataTable7, isEnabled6, dataTable2, counter4)
            dataTable4 = SetEntityCoordsNoOffset
            dataTable7 = dataTable5
            isEnabled6 = -1582.431
            dataTable2 = -1084.60083
            counter4 = 14.0 + A0_2
            dataTable4(dataTable7, isEnabled6, dataTable2, counter4)
            dataTable3.ridedata1 = A0_2
            dataTable3.ridedata2 = A1_2
            dataTable3.rideway = A2_2
            dataTable4 = Citizen
            dataTable4 = dataTable4.Wait
            dataTable7 = 1
            dataTable4(dataTable7)
            dataTable3.getnew = false
            dataTable4 = A3_2 * 0.1
            dataTable7 = A4_2 * 0.1
            isEnabled6 = 1
            dataTable2 = currentfps
            if dataTable2 < 70 then
                dataTable4 = A3_2 * 0.25
                dataTable7 = A4_2 * 0.25
                isEnabled6 = 0
            else
                dataTable2 = currentfps
                if dataTable2 < 110 then
                    dataTable4 = A3_2 * 0.15
                    dataTable7 = A4_2 * 0.15
                    isEnabled6 = 0
                end
            end
            while true do
                dataTable2 = dataTable3.getnew
                if false ~= dataTable2 then
                    break
                end
                dataTable2 = Citizen
                dataTable2 = dataTable2.Wait
                counter4 = isEnabled6
                dataTable2(counter4)
                if 1 == A5_2 then
                    dataTable2 = dataTable3.rideway
                    if 1 == dataTable2 then
                        dataTable2 = dataTable3.ridedata1
                        if dataTable2 < 50.0 then
                            dataTable2 = dataTable3.ridedata1
                            dataTable2 = dataTable2 + dataTable4
                            dataTable3.ridedata1 = dataTable2
                        else
                            dataTable3.rideway = 2
                        end
                    else
                        dataTable2 = dataTable3.ridedata1
                        if dataTable2 > 5.0 then
                            dataTable2 = dataTable3.ridedata1
                            dataTable2 = dataTable2 - dataTable4
                            dataTable3.ridedata1 = dataTable2
                        else
                            dataTable3.rideway = 1
                        end
                    end
                    dataTable2 = dataTable3.ridedata2
                    counter4 = 360.0
                    if dataTable2 > counter4 then
                        dataTable2 = dataTable3.ridedata2
                        dataTable2 = dataTable2 - 360.0
                        counter4 = 0.0 + dataTable2
                        A1_2 = counter4 + dataTable7
                    else
                        dataTable2 = dataTable3.ridedata2
                        dataTable2 = dataTable2 + dataTable7
                        dataTable3.ridedata2 = dataTable2
                    end
                elseif 2 == A5_2 then
                    dataTable2 = dataTable3.ridedata1
                    if dataTable2 > 0.0 then
                        dataTable2 = dataTable3.ridedata1
                        if dataTable2 < 1.0 then
                            dataTable2 = dataTable3.ridedata1
                            dataTable2 = dataTable2 - dataTable4
                            dataTable3.ridedata1 = dataTable2
                        else
                            dataTable2 = dataTable3.ridedata1
                            if dataTable2 < 2.0 then
                                dataTable2 = dataTable3.ridedata1
                                dataTable2 = dataTable2 - dataTable4
                                dataTable3.ridedata1 = dataTable2
                            else
                                dataTable2 = dataTable3.ridedata1
                                if dataTable2 < 3.0 then
                                    dataTable2 = dataTable3.ridedata1
                                    dataTable2 = dataTable2 - dataTable4
                                    dataTable3.ridedata1 = dataTable2
                                else
                                    dataTable2 = dataTable3.ridedata1
                                    if dataTable2 < 5.0 then
                                        dataTable2 = dataTable3.ridedata1
                                        dataTable2 = dataTable2 - dataTable4
                                        dataTable3.ridedata1 = dataTable2
                                    else
                                        dataTable2 = dataTable3.ridedata1
                                        if dataTable2 < 10.0 then
                                            dataTable2 = dataTable3.ridedata1
                                            dataTable2 = dataTable2 - dataTable4
                                            dataTable3.ridedata1 = dataTable2
                                        else
                                            dataTable2 = dataTable3.ridedata1
                                            if dataTable2 < 15.0 then
                                                dataTable2 = dataTable3.ridedata1
                                                dataTable2 = dataTable2 - dataTable4
                                                dataTable3.ridedata1 = dataTable2
                                            else
                                                dataTable2 = dataTable3.ridedata1
                                                if dataTable2 < 20.0 then
                                                    dataTable2 = dataTable3.ridedata1
                                                    dataTable2 = dataTable2 - dataTable4
                                                    dataTable3.ridedata1 = dataTable2
                                                else
                                                    dataTable2 = dataTable3.ridedata1
                                                    if dataTable2 < 35.0 then
                                                        dataTable2 = dataTable3.ridedata1
                                                        dataTable2 = dataTable2 - dataTable4
                                                        dataTable3.ridedata1 = dataTable2
                                                    else
                                                        dataTable2 = dataTable3.ridedata1
                                                        if dataTable2 < 40.0 then
                                                            dataTable2 = dataTable3.ridedata1
                                                            dataTable2 = dataTable2 - dataTable4
                                                            dataTable3.ridedata1 = dataTable2
                                                        else
                                                            dataTable2 = dataTable3.ridedata1
                                                            dataTable2 = dataTable2 - dataTable4
                                                            dataTable3.ridedata1 = dataTable2
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    dataTable2 = dataTable3.rideway
                    if 2 == dataTable2 then
                        dataTable2 = dataTable3.ridedata2
                        counter4 = 360.0
                        if dataTable2 < counter4 then
                            dataTable2 = dataTable3.ridedata2
                            counter4 = 0.25
                            if dataTable2 > counter4 then
                                dataTable2 = dataTable3.ridedata2
                                dataTable2 = dataTable2 + dataTable7
                                dataTable3.ridedata2 = dataTable2
                            end
                        else
                            dataTable3.ridedata2 = 0.0
                            dataTable3.rideway = 1
                        end
                    end
                end
                dataTable2 = dataTable3.getnew
                if false == dataTable2 then
                    dataTable2 = SetEntityRotation
                    counter4 = dataTable5
                    isDisabled5 = dataTable3.ridedata2
                    isDisabled8 = 0.0
                    isEnabled5 = -40.0
                    dataTable2(counter4, isDisabled5, isDisabled8, isEnabled5)
                    dataTable2 = SetEntityCoordsNoOffset
                    counter4 = dataTable5
                    isDisabled5 = -1582.431
                    isDisabled8 = -1084.60083
                    isEnabled5 = dataTable3.ridedata1
                    isEnabled5 = 14.0 + isEnabled5
                    dataTable2(counter4, isDisabled5, isDisabled8, isEnabled5)
                end
            end
        end
    else
        dataTable3.getnew = true
    end
end
counter(counter3, strValue2)
counter = RegisterNetEvent
counter3 = "rtx_themepark:SlingShot:ResynchClient"
counter(counter3)
counter = AddEventHandler
counter3 = "rtx_themepark:SlingShot:ResynchClient"

function strValue2()
    local hash, counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2, isDisabled7, isDisabled6, var22, isEnabled
    hash = ipairs
    counter5 = seats
    hash, counter5, entityCoords, dataTable = hash(counter5)
    for isEnabled2, playerPed in hash, counter5, entityCoords, dataTable do
        dataTable4 = AttachEntityToEntity
        dataTable7 = playerPed.handler
        isEnabled6 = dataTable5
        dataTable2 = 0
        counter4 = playerPed.coords
        counter4 = counter4.x
        isDisabled5 = playerPed.coords
        isDisabled5 = isDisabled5.y
        isDisabled8 = playerPed.coords
        isDisabled8 = isDisabled8.z
        isEnabled5 = playerPed.rotation
        isEnabled5 = isEnabled5.x
        isDisabled4 = playerPed.rotation
        isDisabled4 = isDisabled4.y
        counter2 = playerPed.rotation
        counter2 = counter2.z
        isEnabled4 = false
        isDisabled2 = false
        isDisabled7 = false
        isDisabled6 = false
        var22 = 5
        isEnabled = true
        dataTable4(dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2, isDisabled7, isDisabled6, var22, isEnabled)
    end
    hash = SetEntityCoordsNoOffset
    counter5 = dataTable5
    entityCoords = -75.38789
    dataTable = -818.943848
    isEnabled2 = GlobalState
    isEnabled2 = isEnabled2["attraction12 - ridedata"]
    hash(counter5, entityCoords, dataTable, isEnabled2)
end
counter(counter3, strValue2)
counter = Config
counter = counter.Target
if counter then
    counter = RegisterNetEvent
    counter3 = "rtx_themepark:SlingShot:SeatTarget"
    counter(counter3)
    counter = AddEventHandler
    counter3 = "rtx_themepark:SlingShot:SeatTarget"

    function strValue2()
        local hash, counter5, entityCoords
        hash = usingattraction
        if false == hash then
            hash = GlobalState
            hash = hash["attraction12 - phase"]
            if 0 == hash then
                hash = dataTable8.seatid
                if nil ~= hash then
                    hash = TriggerServerEvent
                    counter5 = "rtx_themepark:SlingShot:SeatUse"
                    entityCoords = dataTable8.seatid
                    hash(counter5, entityCoords)
                end
            end
        end
    end
    counter(counter3, strValue2)
end
counter = Citizen
counter = counter.CreateThread

function counter3()
    local hash, counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2
    while true do
        hash = Citizen
        hash = hash.Wait
        counter5 = 500
        hash(counter5)
        hash = nearbythemepark
        if true ~= hash then
            hash = nearbythemepark
            if false ~= hash then
                goto lbl_368
            end
        end
        hash = DoesEntityExist
        counter5 = dataTable5
        hash = hash(counter5)
        if hash then
        else
            hash = GetHashKey
            counter5 = "sempre_delperropier_slingshot_sedacka"
            hash = hash(counter5)
            counter5 = RequestModel
            entityCoords = hash
            counter5(entityCoords)
            while true do
                counter5 = HasModelLoaded
                entityCoords = hash
                counter5 = counter5(entityCoords)
                if counter5 then
                    break
                end
                counter5 = RequestModel
                entityCoords = hash
                counter5(entityCoords)
                counter5 = Citizen
                counter5 = counter5.Wait
                entityCoords = 5
                counter5(entityCoords)
            end
            counter5 = CreateObjectNoOffset
            entityCoords = hash
            dataTable = -1582.431
            isEnabled2 = -1084.60083
            playerPed = 14.0
            dataTable4 = false
            dataTable7 = true
            isEnabled6 = true
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6)
            dataTable5 = counter5
            counter5 = SetEntityRotation
            entityCoords = dataTable5
            dataTable = 0.0
            isEnabled2 = 0.0
            playerPed = -40.0
            counter5(entityCoords, dataTable, isEnabled2, playerPed)
            counter5 = NetworkAllowLocalEntityAttachment
            entityCoords = dataTable5
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = FreezeEntityPosition
            entityCoords = dataTable5
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = SetEntityMotionBlur
            entityCoords = dataTable5
            dataTable = false
            counter5(entityCoords, dataTable)
        end
        hash = DoesEntityExist
        counter5 = dataTable6
        hash = hash(counter5)
        if hash then
        else
            hash = GetHashKey
            counter5 = "sempre_delperropier_slingshot_sedacka_anim"
            hash = hash(counter5)
            counter5 = RequestModel
            entityCoords = hash
            counter5(entityCoords)
            while true do
                counter5 = HasModelLoaded
                entityCoords = hash
                counter5 = counter5(entityCoords)
                if counter5 then
                    break
                end
                counter5 = RequestModel
                entityCoords = hash
                counter5(entityCoords)
                counter5 = Citizen
                counter5 = counter5.Wait
                entityCoords = 5
                counter5(entityCoords)
            end
            counter5 = CreateObjectNoOffset
            entityCoords = hash
            dataTable = -1582.431
            isEnabled2 = -1084.60083
            playerPed = 14.0
            dataTable4 = false
            dataTable7 = true
            isEnabled6 = true
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6)
            dataTable6 = counter5
            counter5 = SetEntityRotation
            entityCoords = dataTable6
            dataTable = 0.0
            isEnabled2 = 0.0
            playerPed = -40.0
            counter5(entityCoords, dataTable, isEnabled2, playerPed)
            counter5 = NetworkAllowLocalEntityAttachment
            entityCoords = dataTable6
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = FreezeEntityPosition
            entityCoords = dataTable6
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = AttachEntityToEntity
            entityCoords = dataTable6
            dataTable = dataTable5
            isEnabled2 = 0
            playerPed = 0.0
            dataTable4 = 0.0
            dataTable7 = 0.0
            isEnabled6 = 0.0
            dataTable2 = 0.0
            counter4 = 0.0
            isDisabled5 = false
            isDisabled8 = false
            isEnabled5 = true
            isDisabled4 = false
            counter2 = 5
            isEnabled4 = true
            counter5(entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4)
        end
        hash = DoesEntityExist
        counter5 = dataTable3.ropeobjecthandler1
        hash = hash(counter5)
        if hash then
        else
            hash = GetHashKey
            counter5 = "prop_cs_burger_01"
            hash = hash(counter5)
            counter5 = RequestModel
            entityCoords = hash
            counter5(entityCoords)
            while true do
                counter5 = HasModelLoaded
                entityCoords = hash
                counter5 = counter5(entityCoords)
                if counter5 then
                    break
                end
                counter5 = RequestModel
                entityCoords = hash
                counter5(entityCoords)
                counter5 = Citizen
                counter5 = counter5.Wait
                entityCoords = 5
                counter5(entityCoords)
            end
            counter5 = CreateObjectNoOffset
            entityCoords = hash
            dataTable = -1569.42
            isEnabled2 = -1095.51
            playerPed = 47.91
            dataTable4 = false
            dataTable7 = true
            isEnabled6 = true
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6)
            dataTable3.ropeobjecthandler1 = counter5
            counter5 = SetEntityRotation
            entityCoords = dataTable3.ropeobjecthandler1
            dataTable = 0.0
            isEnabled2 = 0.0
            playerPed = 0.0
            counter5(entityCoords, dataTable, isEnabled2, playerPed)
            counter5 = NetworkAllowLocalEntityAttachment
            entityCoords = dataTable3.ropeobjecthandler1
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = FreezeEntityPosition
            entityCoords = dataTable3.ropeobjecthandler1
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = SetEntityVisible
            entityCoords = dataTable3.ropeobjecthandler1
            dataTable = false
            counter5(entityCoords, dataTable)
        end
        hash = DoesEntityExist
        counter5 = dataTable3.ropeobjecthandler2
        hash = hash(counter5)
        if hash then
        else
            hash = GetHashKey
            counter5 = "prop_cs_burger_01"
            hash = hash(counter5)
            counter5 = RequestModel
            entityCoords = hash
            counter5(entityCoords)
            while true do
                counter5 = HasModelLoaded
                entityCoords = hash
                counter5 = counter5(entityCoords)
                if counter5 then
                    break
                end
                counter5 = RequestModel
                entityCoords = hash
                counter5(entityCoords)
                counter5 = Citizen
                counter5 = counter5.Wait
                entityCoords = 5
                counter5(entityCoords)
            end
            counter5 = CreateObjectNoOffset
            entityCoords = hash
            dataTable = -1595.36
            isEnabled2 = -1073.83
            playerPed = 47.91
            dataTable4 = false
            dataTable7 = true
            isEnabled6 = true
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6)
            dataTable3.ropeobjecthandler2 = counter5
            counter5 = SetEntityRotation
            entityCoords = dataTable3.ropeobjecthandler2
            dataTable = 0.0
            isEnabled2 = 0.0
            playerPed = 0.0
            counter5(entityCoords, dataTable, isEnabled2, playerPed)
            counter5 = NetworkAllowLocalEntityAttachment
            entityCoords = dataTable3.ropeobjecthandler2
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = FreezeEntityPosition
            entityCoords = dataTable3.ropeobjecthandler2
            dataTable = true
            counter5(entityCoords, dataTable)
            counter5 = SetEntityVisible
            entityCoords = dataTable3.ropeobjecthandler2
            dataTable = false
            counter5(entityCoords, dataTable)
        end
        hash = DoesRopeExist
        counter5 = dataTable3.ropehandler1
        hash = hash(counter5)
        if hash then
        else
            hash = RopeLoadTextures
            hash()
            hash = AddRope
            counter5 = -1569.42
            entityCoords = -1095.51
            dataTable = 47.91
            isEnabled2 = 0.0
            playerPed = 0.0
            dataTable4 = 0.0
            dataTable7 = 200.0
            isEnabled6 = 4
            dataTable2 = 200.0
            counter4 = 0.25
            isDisabled5 = 0.0
            isDisabled8 = false
            isEnabled5 = false
            isDisabled4 = false
            counter2 = 5.0
            isEnabled4 = false
            isDisabled2 = 0
            hash = hash(counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2)
            dataTable3.ropehandler1 = hash
            hash = GetOffsetFromEntityInWorldCoords
            counter5 = dataTable3.ropeobjecthandler1
            entityCoords = 0.0
            dataTable = 0.0
            isEnabled2 = 0.0
            hash = hash(counter5, entityCoords, dataTable, isEnabled2)
            counter5 = GetOffsetFromEntityInWorldCoords
            entityCoords = dataTable5
            dataTable = 0.8
            isEnabled2 = 0.0
            playerPed = 0.0
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed)
            entityCoords = AttachEntitiesToRope
            dataTable = dataTable3.ropehandler1
            isEnabled2 = dataTable3.ropeobjecthandler1
            playerPed = dataTable5
            dataTable4 = hash.x
            dataTable7 = hash.y
            isEnabled6 = hash.z
            dataTable2 = counter5.x
            counter4 = counter5.y
            isDisabled5 = counter5.z
            isDisabled8 = 1.0
            isEnabled5 = false
            isDisabled4 = false
            counter2 = 0
            isEnabled4 = 0
            entityCoords(dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4)
            entityCoords = StopRopeWinding
            dataTable = dataTable3.ropehandler1
            entityCoords(dataTable)
            entityCoords = StartRopeWinding
            dataTable = dataTable3.ropehandler1
            entityCoords(dataTable)
            entityCoords = RopeForceLength
            dataTable = dataTable3.ropehandler1
            isEnabled2 = 15.0
            entityCoords(dataTable, isEnabled2)
        end
        hash = DoesRopeExist
        counter5 = dataTable3.ropehandler2
        hash = hash(counter5)
        if hash then
        else
            hash = RopeLoadTextures
            hash()
            hash = AddRope
            counter5 = -1595.36
            entityCoords = -1073.83
            dataTable = 47.91
            isEnabled2 = 0.0
            playerPed = 0.0
            dataTable4 = 0.0
            dataTable7 = 200.0
            isEnabled6 = 4
            dataTable2 = 200.0
            counter4 = 0.25
            isDisabled5 = 0.0
            isDisabled8 = false
            isEnabled5 = false
            isDisabled4 = false
            counter2 = 5.0
            isEnabled4 = false
            isDisabled2 = 0
            hash = hash(counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2)
            dataTable3.ropehandler2 = hash
            hash = GetOffsetFromEntityInWorldCoords
            counter5 = dataTable3.ropeobjecthandler2
            entityCoords = 0.0
            dataTable = 0.0
            isEnabled2 = 0.0
            hash = hash(counter5, entityCoords, dataTable, isEnabled2)
            counter5 = GetOffsetFromEntityInWorldCoords
            entityCoords = dataTable5
            dataTable = -0.8
            isEnabled2 = 0.0
            playerPed = 0.0
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed)
            entityCoords = AttachEntitiesToRope
            dataTable = dataTable3.ropehandler2
            isEnabled2 = dataTable3.ropeobjecthandler2
            playerPed = dataTable5
            dataTable4 = hash.x
            dataTable7 = hash.y
            isEnabled6 = hash.z
            dataTable2 = counter5.x
            counter4 = counter5.y
            isDisabled5 = counter5.z
            isDisabled8 = 1.0
            isEnabled5 = false
            isDisabled4 = false
            counter2 = 0
            isEnabled4 = 0
            entityCoords(dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4)
            entityCoords = StopRopeWinding
            dataTable = dataTable3.ropehandler2
            entityCoords(dataTable)
            entityCoords = StartRopeWinding
            dataTable = dataTable3.ropehandler2
            entityCoords(dataTable)
            entityCoords = RopeForceLength
            dataTable = dataTable3.ropehandler2
            isEnabled2 = 15.0
            entityCoords(dataTable, isEnabled2)
        end
        ::lbl_368::
    end
end
counter(counter3)
counter = -1
counter3 = Citizen
counter3 = counter3.CreateThread

function strValue2()
    local hash, counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4
    while true do
        hash = Citizen
        hash = hash.Wait
        counter5 = 20
        hash(counter5)
        hash = GlobalState
        hash = hash["attraction12 - phase"]
        if 0 ~= hash then
            hash = nearbythemepark
            if false ~= hash then
                goto lbl_18
            end
        end
        dataTable3.getnew = true
        hash = Citizen
        hash = hash.Wait
        counter5 = 500
        hash(counter5)
        goto lbl_112
        ::lbl_18::
        hash = counter
        if -1 ~= hash then
            hash = counter
            counter5 = GlobalState
            counter5 = counter5["attraction12 - synchdata"]
            if not (hash < counter5) then
                goto lbl_112
            end
        end
        hash = tonumber
        counter5 = GlobalState
        counter5 = counter5["attraction12 - synchdata"]
        hash = hash(counter5)
        counter = hash
        hash = TriggerEvent
        counter5 = "rtx_themepark:SlingShot:SynchronizeMovement"
        entityCoords = GlobalState
        entityCoords = entityCoords["attraction12 - ridedata1"]
        dataTable = GlobalState
        dataTable = dataTable["attraction12 - ridedata2"]
        isEnabled2 = GlobalState
        isEnabled2 = isEnabled2["attraction12 - rideway"]
        playerPed = GlobalState
        playerPed = playerPed["attraction12 - speeddata1"]
        dataTable4 = GlobalState
        dataTable4 = dataTable4["attraction12 - speeddata2"]
        dataTable7 = GlobalState
        dataTable7 = dataTable7["attraction12 - phase"]
        hash(counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7)
        hash = DoesRopeExist
        counter5 = dataTable3.ropehandler1
        hash = hash(counter5)
        if hash then
            hash = GetOffsetFromEntityInWorldCoords
            counter5 = dataTable3.ropeobjecthandler1
            entityCoords = 0.0
            dataTable = 0.0
            isEnabled2 = 0.0
            hash = hash(counter5, entityCoords, dataTable, isEnabled2)
            counter5 = GetOffsetFromEntityInWorldCoords
            entityCoords = dataTable5
            dataTable = 0.8
            isEnabled2 = 0.0
            playerPed = 0.0
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed)
            entityCoords = AttachEntitiesToRope
            dataTable = dataTable3.ropehandler1
            isEnabled2 = dataTable3.ropeobjecthandler1
            playerPed = dataTable5
            dataTable4 = hash.x
            dataTable7 = hash.y
            isEnabled6 = hash.z
            dataTable2 = counter5.x
            counter4 = counter5.y
            isDisabled5 = counter5.z
            isDisabled8 = 15.0
            isEnabled5 = false
            isDisabled4 = false
            counter2 = 0
            isEnabled4 = 0
            entityCoords(dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4)
        end
        hash = DoesRopeExist
        counter5 = dataTable3.ropehandler2
        hash = hash(counter5)
        if hash then
            hash = GetOffsetFromEntityInWorldCoords
            counter5 = dataTable3.ropeobjecthandler2
            entityCoords = 0.0
            dataTable = 0.0
            isEnabled2 = 0.0
            hash = hash(counter5, entityCoords, dataTable, isEnabled2)
            counter5 = GetOffsetFromEntityInWorldCoords
            entityCoords = dataTable5
            dataTable = -0.8
            isEnabled2 = 0.0
            playerPed = 0.0
            counter5 = counter5(entityCoords, dataTable, isEnabled2, playerPed)
            entityCoords = AttachEntitiesToRope
            dataTable = dataTable3.ropehandler2
            isEnabled2 = dataTable3.ropeobjecthandler2
            playerPed = dataTable5
            dataTable4 = hash.x
            dataTable7 = hash.y
            isEnabled6 = hash.z
            dataTable2 = counter5.x
            counter4 = counter5.y
            isDisabled5 = counter5.z
            isDisabled8 = 15.0
            isEnabled5 = false
            isDisabled4 = false
            counter2 = 0
            isEnabled4 = 0
            entityCoords(dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4)
        end
        ::lbl_112::
    end
end
counter3(strValue2)
counter3 = RegisterNetEvent
strValue2 = "rtx_themepark:SlingShot:AttractionFinish"
counter3(strValue2)
counter3 = AddEventHandler
strValue2 = "rtx_themepark:SlingShot:AttractionFinish"

function tableData()
    local hash, counter5
    hash = -1
    counter = hash
end
counter3(strValue2, tableData)
counter3 = Config
counter3 = counter3.AttractionsSettings
counter3 = counter3.slingshot
counter3 = counter3.disable
if false == counter3 then
    counter3 = Citizen
    counter3 = counter3.CreateThread

    function strValue2()
        local hash, counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4
        while true do
            hash = Citizen
            hash = hash.Wait
            counter5 = 0
            hash(counter5)
            hash = true
            counter5 = PlayerPedId
            counter5 = counter5()
            entityCoords = GetEntityCoords
            dataTable = counter5
            entityCoords = entityCoords(dataTable)
            dataTable = false
            isEnabled2 = -1
            playerPed = {}
            playerPed.seatid = nil
            dataTable4 = GlobalState
            dataTable4 = dataTable4["attraction12 - phase"]
            if 0 == dataTable4 then
                dataTable4 = usingattraction
                if false == dataTable4 then
                    dataTable4 = nearbythemepark
                    if true == dataTable4 then
                        dataTable4 = tickets
                        dataTable4 = dataTable4.slingshot
                        if true == dataTable4 then
                            dataTable4 = ipairs
                            dataTable7 = dataTable3.seats
                            dataTable4, dataTable7, isEnabled6, dataTable2 = dataTable4(dataTable7)
                            for counter4, isDisabled5 in dataTable4, dataTable7, isEnabled6, dataTable2 do
                                isDisabled8 = isDisabled5.taken
                                if false == isDisabled8 then
                                    isDisabled8 = GetOffsetFromEntityInWorldCoords
                                    isEnabled5 = dataTable5
                                    isDisabled4 = isDisabled5.offsets
                                    isDisabled4 = isDisabled4.coords
                                    isDisabled4 = isDisabled4.x
                                    counter2 = isDisabled5.offsets
                                    counter2 = counter2.coords
                                    counter2 = counter2.y
                                    isEnabled4 = isDisabled5.offsets
                                    isEnabled4 = isEnabled4.coords
                                    isEnabled4 = isEnabled4.z
                                    isDisabled8 = isDisabled8(isEnabled5, isDisabled4, counter2, isEnabled4)
                                    isEnabled5 = entityCoords - isDisabled8
                                    isEnabled5 = #isEnabled5
                                    if isEnabled5 < 20.0 then
                                        isDisabled4 = Config
                                        isDisabled4 = isDisabled4.AttractionsSettings
                                        isDisabled4 = isDisabled4.slingshot
                                        isDisabled4 = isDisabled4.usedistance
                                        if isEnabled5 < isDisabled4 and (-1 == isEnabled2 or isEnabled2 > isEnabled5) then
                                            isEnabled2 = isEnabled5
                                            dataTable = true
                                            playerPed.seatid = counter4
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if dataTable then
                dataTable4 = {}
                dataTable7 = playerPed.seatid
                dataTable4.seatid = dataTable7
                dataTable8 = dataTable4
                dataTable4 = false
                dataTable7 = usingattraction
                if false == dataTable7 then
                    hash = false
                    dataTable7 = Config
                    dataTable7 = dataTable7.Target
                    if false == dataTable7 then
                        dataTable7 = dataTable3.seats
                        isEnabled6 = dataTable8.seatid
                        dataTable7 = dataTable7[isEnabled6]
                        isEnabled6 = Config
                        isEnabled6 = isEnabled6.ThemeParkInteractionSystem
                        if 1 == isEnabled6 then
                            isEnabled6 = SendNUIMessage
                            dataTable2 = {}
                            dataTable2.message = "infonotifyshow"
                            counter4 = Language
                            isDisabled5 = Config
                            isDisabled5 = isDisabled5.Language
                            counter4 = counter4[isDisabled5]
                            counter4 = counter4.pressforuseseatinteract
                            dataTable2.infonotifytext = counter4
                            isEnabled6(dataTable2)
                            dataTable4 = true
                        else
                            isEnabled6 = Config
                            isEnabled6 = isEnabled6.ThemeParkInteractionSystem
                            if 2 == isEnabled6 then
                                isEnabled6 = GetOffsetFromEntityInWorldCoords
                                dataTable2 = seatobjecthandler
                                dataTable2 = dataTable2.handler
                                counter4 = dataTable7.offsets
                                counter4 = counter4.coords
                                counter4 = counter4.x
                                isDisabled5 = dataTable7.offsets
                                isDisabled5 = isDisabled5.coords
                                isDisabled5 = isDisabled5.y
                                isDisabled8 = dataTable7.offsets
                                isDisabled8 = isDisabled8.coords
                                isDisabled8 = isDisabled8.z
                                isEnabled6 = isEnabled6(dataTable2, counter4, isDisabled5, isDisabled8)
                                dataTable2 = DrawText3D
                                counter4 = isEnabled6.x
                                isDisabled5 = isEnabled6.y
                                isDisabled8 = isEnabled6.z
                                isEnabled5 = Language
                                isDisabled4 = Config
                                isDisabled4 = isDisabled4.Language
                                isEnabled5 = isEnabled5[isDisabled4]
                                isEnabled5 = isEnabled5.pressforuseseat
                                dataTable2(counter4, isDisabled5, isDisabled8, isEnabled5)
                            else
                                isEnabled6 = Config
                                isEnabled6 = isEnabled6.ThemeParkInteractionSystem
                                if 3 == isEnabled6 then
                                    isEnabled6 = ShowGtaClassicInteraction
                                    dataTable2 = Language
                                    counter4 = Config
                                    counter4 = counter4.Language
                                    dataTable2 = dataTable2[counter4]
                                    dataTable2 = dataTable2.pressforuseseatinteractclassic
                                    isEnabled6(dataTable2)
                                end
                            end
                        end
                    end
                end
            else
                dataTable4 = Config
                dataTable4 = dataTable4.ThemeParkInteractionSystem
                if 1 == dataTable4 then
                    dataTable4 = dataTable8.seatid
                    if nil ~= dataTable4 then
                        dataTable4 = SendNUIMessage
                        dataTable7 = {}
                        dataTable7.message = "hide"
                        dataTable4(dataTable7)
                    end
                end
                dataTable4 = {}
                dataTable4.seatid = nil
                dataTable8 = dataTable4
            end
            if hash then
                dataTable4 = Citizen
                dataTable4 = dataTable4.Wait
                dataTable7 = 1000
                dataTable4(dataTable7)
            end
        end
    end
    counter3(strValue2)
end
counter3 = Config
counter3 = counter3.Target
if false == counter3 then
    counter3 = RegisterCommand
    strValue2 = "useslingshotseat"

    function tableData()
        local hash, counter5, entityCoords
        hash = usingattraction
        if false == hash then
            hash = GlobalState
            hash = hash["attraction12 - phase"]
            if 0 == hash then
                hash = dataTable8.seatid
                if nil ~= hash then
                    hash = TriggerServerEvent
                    counter5 = "rtx_themepark:SlingShot:SeatUse"
                    entityCoords = dataTable8.seatid
                    hash(counter5, entityCoords)
                end
            end
        end
    end
    counter3(strValue2, tableData)
    counter3 = RegisterKeyMapping
    strValue2 = "useslingshotseat"
    tableData = Language
    strValue = Config
    strValue = strValue.Language
    tableData = tableData[strValue]
    tableData = tableData.bindseatuse
    strValue = "keyboard"
    var1 = Config
    var1 = var1.ThemeParkSeatKey
    counter3(strValue2, tableData, strValue, var1)
end
counter3 = RegisterCommand
strValue2 = "exitslingshot"

function tableData()
    local hash, counter5, entityCoords
    hash = usingattraction
    if true == hash then
        hash = func
        if nil ~= hash then
            hash = Config
            hash = hash.ThemeParkDisableExit
            if false ~= hash then
                hash = GlobalState
                hash = hash["attraction12 - phase"]
                if 0 ~= hash then
                    goto lbl_20
                end
            end
            hash = TriggerServerEvent
            counter5 = "rtx_themepark:SlingShot:ExitAttraction"
            entityCoords = func
            hash(counter5, entityCoords)
            goto lbl_27
            ::lbl_20::
            hash = Notify
            counter5 = Language
            entityCoords = Config
            entityCoords = entityCoords.Language
            counter5 = counter5[entityCoords]
            counter5 = counter5.attractioninprogress
            hash(counter5)
        end
    end
    ::lbl_27::
end
counter3(strValue2, tableData)
counter3 = RegisterKeyMapping
strValue2 = "exitslingshot"
tableData = Language
strValue = Config
strValue = strValue.Language
tableData = tableData[strValue]
tableData = tableData.leaveattraciton
strValue = "keyboard"
var1 = Config
var1 = var1.ThemeParkExitKey
counter3(strValue2, tableData, strValue, var1)
counter3 = RegisterNetEvent
strValue2 = "rtx_themepark:SlingShot:SynchronizeSeat"
counter3(strValue2)
counter3 = AddEventHandler
strValue2 = "rtx_themepark:SlingShot:SynchronizeSeat"

function tableData(A0_2, A1_2, A2_2)
    local dataTable, isEnabled2, playerPed, dataTable4, dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2, isDisabled7, isDisabled6, var22, isEnabled
    dataTable = dataTable3.seats
    dataTable = dataTable[A0_2]
    dataTable.taken = A1_2
    if false == A1_2 then
        if nil ~= A2_2 then
            isEnabled2 = GetPlayerFromServerId
            playerPed = A2_2
            isEnabled2 = isEnabled2(playerPed)
            if -1 ~= isEnabled2 then
                playerPed = GetPlayerPed
                dataTable4 = isEnabled2
                playerPed = playerPed(dataTable4)
                dataTable4 = DoesEntityExist
                dataTable7 = playerPed
                dataTable4 = dataTable4(dataTable7)
                if dataTable4 then
                    dataTable4 = DetachEntity
                    dataTable7 = playerPed
                    dataTable4(dataTable7)
                    dataTable4 = FreezeEntityPosition
                    dataTable7 = playerPed
                    isEnabled6 = false
                    dataTable4(dataTable7, isEnabled6)
                    dataTable4 = ClearPedTasks
                    dataTable7 = playerPed
                    dataTable4(dataTable7)
                end
            end
        end
    else
        isEnabled2 = GetPlayerFromServerId
        playerPed = A2_2
        isEnabled2 = isEnabled2(playerPed)
        if -1 ~= isEnabled2 then
            playerPed = GetPlayerPed
            dataTable4 = isEnabled2
            playerPed = playerPed(dataTable4)
            dataTable4 = DoesEntityExist
            dataTable7 = playerPed
            dataTable4 = dataTable4(dataTable7)
            if dataTable4 then
                dataTable4 = FreezeEntityPosition
                dataTable7 = playerPed
                isEnabled6 = true
                dataTable4(dataTable7, isEnabled6)
                dataTable4 = NetworkAllowLocalEntityAttachment
                dataTable7 = playerPed
                isEnabled6 = true
                dataTable4(dataTable7, isEnabled6)
                dataTable4 = AttachEntityToEntity
                dataTable7 = playerPed
                isEnabled6 = dataTable5
                dataTable2 = 0
                counter4 = dataTable.offsets
                counter4 = counter4.coords
                counter4 = counter4.x
                isDisabled5 = dataTable.offsets
                isDisabled5 = isDisabled5.coords
                isDisabled5 = isDisabled5.y
                isDisabled8 = dataTable.offsets
                isDisabled8 = isDisabled8.coords
                isDisabled8 = isDisabled8.z
                isEnabled5 = dataTable.offsets
                isEnabled5 = isEnabled5.rotation
                isEnabled5 = isEnabled5.x
                isDisabled4 = dataTable.offsets
                isDisabled4 = isDisabled4.rotation
                isDisabled4 = isDisabled4.y
                counter2 = dataTable.offsets
                counter2 = counter2.rotation
                counter2 = counter2.z
                isEnabled4 = false
                isDisabled2 = false
                isDisabled7 = false
                isDisabled6 = false
                var22 = 2
                isEnabled = true
                dataTable4(dataTable7, isEnabled6, dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2, isDisabled7, isDisabled6, var22, isEnabled)
                dataTable4 = "amb@prop_human_seat_chair_mp@female@proper@base"
                dataTable7 = "base"
                while true do
                    isEnabled6 = HasAnimDictLoaded
                    dataTable2 = dataTable4
                    isEnabled6 = isEnabled6(dataTable2)
                    if isEnabled6 then
                        break
                    end
                    isEnabled6 = RequestAnimDict
                    dataTable2 = dataTable4
                    isEnabled6(dataTable2)
                    isEnabled6 = Citizen
                    isEnabled6 = isEnabled6.Wait
                    dataTable2 = 5
                    isEnabled6(dataTable2)
                end
                isEnabled6 = TaskPlayAnim
                dataTable2 = playerPed
                counter4 = dataTable4
                isDisabled5 = dataTable7
                isDisabled8 = 8.0
                isEnabled5 = 8.0
                isDisabled4 = -1
                counter2 = 1
                isEnabled4 = 0
                isDisabled2 = 0
                isDisabled7 = 0
                isDisabled6 = 0
                isEnabled6(dataTable2, counter4, isDisabled5, isDisabled8, isEnabled5, isDisabled4, counter2, isEnabled4, isDisabled2, isDisabled7, isDisabled6)
            end
        end
    end
end
counter3(strValue2, tableData)
counter3 = RegisterNetEvent
strValue2 = "rtx_themepark:SlingShot:SeatData"
counter3(strValue2)
counter3 = AddEventHandler
strValue2 = "rtx_themepark:SlingShot:SeatData"

function tableData(A0_2)
    local counter5, entityCoords, dataTable, isEnabled2
    counter5 = SendNUIMessage
    entityCoords = {}
    entityCoords.message = "attractionhow"
    entityCoords.attractionanimchange = false
    counter5(entityCoords)
    func = A0_2
    counter5 = SetEntityCompletelyDisableCollision
    entityCoords = dataTable5
    dataTable = false
    isEnabled2 = false
    counter5(entityCoords, dataTable, isEnabled2)
end
counter3(strValue2, tableData)
counter3 = RegisterNetEvent
strValue2 = "rtx_themepark:SlingShot:SeatExit"
counter3(strValue2)
counter3 = AddEventHandler
strValue2 = "rtx_themepark:SlingShot:SeatExit"

function tableData(A0_2)
    local counter5, entityCoords, dataTable, isEnabled2, playerPed, dataTable4
    counter5 = PlayerPedId
    counter5 = counter5()
    entityCoords = DetachEntity
    dataTable = counter5
    entityCoords(dataTable)
    entityCoords = FreezeEntityPosition
    dataTable = counter5
    isEnabled2 = false
    entityCoords(dataTable, isEnabled2)
    entityCoords = ClearPedTasks
    dataTable = counter5
    entityCoords(dataTable)
    entityCoords = GlobalState
    entityCoords = entityCoords["attraction12 - phase"]
    if 0 == entityCoords then
    else
        entityCoords = SetEntityCoordsNoOffset
        dataTable = counter5
        isEnabled2 = -1586.5808
        playerPed = -1088.532
        dataTable4 = 13.0172
        entityCoords(dataTable, isEnabled2, playerPed, dataTable4)
        entityCoords = SetEntityHeading
        dataTable = counter5
        isEnabled2 = 0.0
        entityCoords(dataTable, isEnabled2)
    end
    entityCoords = SendNUIMessage
    dataTable = {}
    dataTable.message = "hideattraction"
    entityCoords(dataTable)
    entityCoords = nil
    func = entityCoords
    entityCoords = SetEntityCompletelyDisableCollision
    dataTable = dataTable5
    isEnabled2 = true
    playerPed = true
    entityCoords(dataTable, isEnabled2, playerPed)
end
counter3(strValue2, tableData)