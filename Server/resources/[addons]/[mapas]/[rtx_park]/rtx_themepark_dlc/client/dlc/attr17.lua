
local dataTable3, var12, isDisabled6, var15, var13, isDisabled, var14, var1, isDisabled3, dataTable5, dataTable4, dataTable6, dataTable8, strValue, counter, counter3, counter2
dataTable3 = IsDuplicityVersion
dataTable3 = dataTable3()
if dataTable3 then
    dataTable3 = GetPlayerPositionInRealTime85
    dataTable3()
end
dataTable3 = {}
dataTable3.seatid = nil
var12 = nil
isDisabled6 = false
var15 = nil
var13 = nil
isDisabled = false
var14 = nil
var1 = nil
isDisabled3 = false
dataTable5 = {}
dataTable5.started = false
dataTable5.stageid = 0
dataTable5.soundid = nil
dataTable5.getnew = false
dataTable4 = {}
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable6.seatcategory = "one"
dataTable8 = {}
strValue = vec3
counter = -0.28
counter3 = -0.213
counter2 = 0.905
strValue = strValue(counter, counter3, counter2)
dataTable8.coords = strValue
strValue = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
strValue = strValue(counter, counter3, counter2)
dataTable8.rotation = strValue
dataTable6.offsets = dataTable8
dataTable4[1] = dataTable6
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable6.seatcategory = "two"
dataTable8 = {}
strValue = vec3
counter = 0.28
counter3 = -0.213
counter2 = 0.905
strValue = strValue(counter, counter3, counter2)
dataTable8.coords = strValue
strValue = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
strValue = strValue(counter, counter3, counter2)
dataTable8.rotation = strValue
dataTable6.offsets = dataTable8
dataTable4[2] = dataTable6
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable6.seatcategory = "one"
dataTable8 = {}
strValue = vec3
counter = -0.28
counter3 = -1.228
counter2 = 0.905
strValue = strValue(counter, counter3, counter2)
dataTable8.coords = strValue
strValue = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
strValue = strValue(counter, counter3, counter2)
dataTable8.rotation = strValue
dataTable6.offsets = dataTable8
dataTable4[3] = dataTable6
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable6.seatcategory = "two"
dataTable8 = {}
strValue = vec3
counter = 0.28
counter3 = -1.228
counter2 = 0.905
strValue = strValue(counter, counter3, counter2)
dataTable8.coords = strValue
strValue = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
strValue = strValue(counter, counter3, counter2)
dataTable8.rotation = strValue
dataTable6.offsets = dataTable8
dataTable4[4] = dataTable6
dataTable5.seats = dataTable4
rollercoasterhandler2 = dataTable5
dataTable5 = RegisterNetEvent
dataTable4 = "rtx_themepark:Rollercoaster2:SynchronizeStarted"
dataTable5(dataTable4)
dataTable5 = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster2:SynchronizeStarted"

function dataTable6(A0_2)
    local isEnabled5, entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7
    isEnabled5 = rollercoasterhandler2
    isEnabled5.started = A0_2
    if true == A0_2 then
        isEnabled5 = false
        isDisabled6 = isEnabled5
        isEnabled5 = Config
        isEnabled5 = isEnabled5.AttractionsSettings
        isEnabled5 = isEnabled5.rollercoaster2
        isEnabled5 = isEnabled5.sound
        if true == isEnabled5 then
            isEnabled5 = RequestScriptAudioBank
            entityCoords2 = "CABLE_CAR"
            dataTable = false
            entityCoords = -1
            isEnabled5(entityCoords2, dataTable, entityCoords)
            isEnabled5 = RequestScriptAudioBank
            entityCoords2 = "CABLE_CAR_SOUNDS"
            dataTable = false
            entityCoords = -1
            isEnabled5(entityCoords2, dataTable, entityCoords)
            isEnabled5 = LoadStream
            entityCoords2 = "CABLE_CAR"
            dataTable = "CABLE_CAR_SOUNDS"
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = LoadStream
            entityCoords2 = "CABLE_CAR_SOUNDS"
            dataTable = "CABLE_CAR"
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = rollercoasterhandler2
            entityCoords2 = GetSoundId
            entityCoords2 = entityCoords2()
            isEnabled5.soundid = entityCoords2
            isEnabled5 = PlaySoundFromEntity
            entityCoords2 = rollercoasterhandler2
            entityCoords2 = entityCoords2.soundid
            dataTable = "Running"
            entityCoords = var15
            hash = "CABLE_CAR_SOUNDS"
            playerPed = 0
            dataTable7 = 0
            isEnabled5(entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7)
        end
    else
        isEnabled5 = Config
        isEnabled5 = isEnabled5.AttractionsSettings
        isEnabled5 = isEnabled5.rollercoaster2
        isEnabled5 = isEnabled5.sound
        if true == isEnabled5 then
            isEnabled5 = StopSound
            entityCoords2 = rollercoasterhandler2
            entityCoords2 = entityCoords2.soundid
            isEnabled5(entityCoords2)
        end
    end
end
dataTable5(dataTable4, dataTable6)
dataTable5 = RegisterNetEvent
dataTable4 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
dataTable5(dataTable4)
dataTable5 = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"

function dataTable6(A0_2, A1_2, A2_2, A3_2)
    local entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3, isEnabled, isDisabled8, isDisabled7, isDisabled2, isEnabled2, isEnabled7
    entityCoords = rollercoasterhandler2
    entityCoords = entityCoords.seats
    entityCoords = entityCoords[A0_2]
    entityCoords.taken = A1_2
    if false == A1_2 then
        if nil ~= A2_2 then
            hash = GetPlayerFromServerId
            playerPed = A2_2
            hash = hash(playerPed)
            if -1 ~= hash then
                playerPed = GetPlayerPed
                dataTable7 = hash
                playerPed = playerPed(dataTable7)
                dataTable7 = DoesEntityExist
                isEnabled8 = playerPed
                dataTable7 = dataTable7(isEnabled8)
                if dataTable7 then
                    dataTable7 = DetachEntity
                    isEnabled8 = playerPed
                    dataTable7(isEnabled8)
                    dataTable7 = ClearPedTasks
                    isEnabled8 = playerPed
                    dataTable7(isEnabled8)
                    dataTable7 = FreezeEntityPosition
                    isEnabled8 = playerPed
                    dataTable2 = false
                    dataTable7(isEnabled8, dataTable2)
                end
            end
        end
    else
        hash = GetPlayerFromServerId
        playerPed = A2_2
        hash = hash(playerPed)
        if -1 ~= hash then
            playerPed = GetPlayerPed
            dataTable7 = hash
            playerPed = playerPed(dataTable7)
            dataTable7 = print
            isEnabled8 = entityCoords.offsets
            isEnabled8 = isEnabled8.coords
            isEnabled8 = isEnabled8.x
            dataTable2 = entityCoords.offsets
            dataTable2 = dataTable2.coords
            dataTable2 = dataTable2.y
            isEnabled4 = entityCoords.offsets
            isEnabled4 = isEnabled4.coords
            isEnabled4 = isEnabled4.z
            dataTable7(isEnabled8, dataTable2, isEnabled4)
            dataTable7 = DoesEntityExist
            isEnabled8 = playerPed
            dataTable7 = dataTable7(isEnabled8)
            if dataTable7 then
                dataTable7 = FreezeEntityPosition
                isEnabled8 = playerPed
                dataTable2 = true
                dataTable7(isEnabled8, dataTable2)
                dataTable7 = NetworkAllowLocalEntityAttachment
                isEnabled8 = playerPed
                dataTable2 = true
                dataTable7(isEnabled8, dataTable2)
                dataTable7 = AttachEntityToEntity
                isEnabled8 = playerPed
                dataTable2 = var15
                isEnabled4 = 0
                isDisabled5 = entityCoords.offsets
                isDisabled5 = isDisabled5.coords
                isDisabled5 = isDisabled5.x
                isEnabled6 = entityCoords.offsets
                isEnabled6 = isEnabled6.coords
                isEnabled6 = isEnabled6.y
                isDisabled9 = entityCoords.offsets
                isDisabled9 = isDisabled9.coords
                isDisabled9 = isDisabled9.z
                isDisabled4 = entityCoords.offsets
                isDisabled4 = isDisabled4.rotation
                isDisabled4 = isDisabled4.x
                counter4 = entityCoords.offsets
                counter4 = counter4.rotation
                counter4 = counter4.y
                isEnabled3 = entityCoords.offsets
                isEnabled3 = isEnabled3.rotation
                isEnabled3 = isEnabled3.z
                isEnabled = false
                isDisabled8 = false
                isDisabled7 = false
                isDisabled2 = false
                isEnabled2 = 2
                isEnabled7 = true
                dataTable7(isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3, isEnabled, isDisabled8, isDisabled7, isDisabled2, isEnabled2, isEnabled7)
                dataTable7 = "anim@mp_rollarcoaster"
                isEnabled8 = "safety_bar_grip_move_a_player_"
                dataTable2 = entityCoords.seatcategory
                isEnabled4 = ""
                isEnabled8 = isEnabled8 .. dataTable2 .. isEnabled4
                if 2 == A3_2 then
                    dataTable2 = "hands_up_idle_a_player_"
                    isEnabled4 = entityCoords.seatcategory
                    isDisabled5 = ""
                    dataTable2 = dataTable2 .. isEnabled4 .. isDisabled5
                    isEnabled8 = dataTable2
                end
                while true do
                    dataTable2 = HasAnimDictLoaded
                    isEnabled4 = dataTable7
                    dataTable2 = dataTable2(isEnabled4)
                    if dataTable2 then
                        break
                    end
                    dataTable2 = RequestAnimDict
                    isEnabled4 = dataTable7
                    dataTable2(isEnabled4)
                    dataTable2 = Citizen
                    dataTable2 = dataTable2.Wait
                    isEnabled4 = 5
                    dataTable2(isEnabled4)
                end
                dataTable2 = TaskPlayAnim
                isEnabled4 = playerPed
                isDisabled5 = dataTable7
                isEnabled6 = isEnabled8
                isDisabled9 = 8.0
                isDisabled4 = 8.0
                counter4 = -1
                isEnabled3 = 1
                isEnabled = 0
                isDisabled8 = 0
                isDisabled7 = 0
                isDisabled2 = 0
                dataTable2(isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3, isEnabled, isDisabled8, isDisabled7, isDisabled2)
            end
        end
    end
end
dataTable5(dataTable4, dataTable6)
dataTable5 = RegisterNetEvent
dataTable4 = "rtx_themepark:Rollercoaster2:AttractionEnded"
dataTable5(dataTable4)
dataTable5 = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster2:AttractionEnded"

function dataTable6()
    local hash2, isEnabled5, entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2
    hash2 = 1
    isEnabled5 = rollercoaster2paths
    entityCoords2 = true
    isDisabled6 = entityCoords2
    entityCoords2 = SetEntityCoordsNoOffset
    dataTable = var13
    entityCoords = isEnabled5[hash2]
    entityCoords = entityCoords.coords
    entityCoords = entityCoords.x
    hash = isEnabled5[hash2]
    hash = hash.coords
    hash = hash.y
    playerPed = isEnabled5[hash2]
    playerPed = playerPed.coords
    playerPed = playerPed.z
    dataTable7 = true
    isEnabled8 = false
    dataTable2 = false
    entityCoords2(dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2)
    entityCoords2 = SetEntityQuaternion
    dataTable = var13
    entityCoords = isEnabled5[hash2]
    entityCoords = entityCoords.objectscoords1x
    hash = isEnabled5[hash2]
    hash = hash.objectscoords1y
    playerPed = isEnabled5[hash2]
    playerPed = playerPed.objectscoords1z
    dataTable7 = isEnabled5[hash2]
    dataTable7 = dataTable7.objectscoords1w
    entityCoords2(dataTable, entityCoords, hash, playerPed, dataTable7)
end
dataTable5(dataTable4, dataTable6)
dataTable5 = RegisterNetEvent
dataTable4 = "rtx_themepark:Rollercoaster2:SynchronizeMovement"
dataTable5(dataTable4)
dataTable5 = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster2:SynchronizeMovement"

function dataTable6(A0_2, A1_2)
    local entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4
    entityCoords2 = nearbythemepark
    if true == entityCoords2 then
        entityCoords2 = A1_2
        dataTable = rollercoaster2paths
        dataTable = #dataTable
        if entityCoords2 > dataTable then
            dataTable = rollercoaster2paths
            entityCoords2 = #dataTable
        end
        rollercoaster2calculateid = A0_2
        dataTable = rollercoaster2calculateid
        entityCoords = rollercoaster2paths
        entityCoords = #entityCoords
        if dataTable > entityCoords then
            dataTable = rollercoaster2paths
            dataTable = #dataTable
            rollercoaster2calculateid = dataTable
        end
        dataTable = rollercoaster2paths
        entityCoords = rollercoasterhandler2
        entityCoords.getnew = true
        entityCoords = rollercoasterhandler2
        hash = rollercoaster2calculateid
        entityCoords.stageid = hash
        entityCoords = SetEntityCoordsNoOffset
        hash = var13
        playerPed = rollercoasterhandler2
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed.coords
        playerPed = playerPed.x
        dataTable7 = rollercoasterhandler2
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.y
        isEnabled8 = rollercoasterhandler2
        isEnabled8 = isEnabled8.stageid
        isEnabled8 = dataTable[isEnabled8]
        isEnabled8 = isEnabled8.coords
        isEnabled8 = isEnabled8.z
        dataTable2 = true
        isEnabled4 = false
        isDisabled5 = false
        entityCoords(hash, playerPed, dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5)
        entityCoords = SetEntityQuaternion
        hash = var13
        playerPed = rollercoasterhandler2
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed.objectscoords1x
        dataTable7 = rollercoasterhandler2
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7.objectscoords1y
        isEnabled8 = rollercoasterhandler2
        isEnabled8 = isEnabled8.stageid
        isEnabled8 = dataTable[isEnabled8]
        isEnabled8 = isEnabled8.objectscoords1z
        dataTable2 = rollercoasterhandler2
        dataTable2 = dataTable2.stageid
        dataTable2 = dataTable[dataTable2]
        dataTable2 = dataTable2.objectscoords1w
        entityCoords(hash, playerPed, dataTable7, isEnabled8, dataTable2)
        entityCoords = Citizen
        entityCoords = entityCoords.Wait
        hash = 1
        entityCoords(hash)
        entityCoords = rollercoasterhandler2
        entityCoords.getnew = false
        entityCoords = rollercoaster2paths
        entityCoords = #entityCoords
        hash = 1
        playerPed = currentfps
        if playerPed < 80 then
            hash = 0
        else
            hash = 1
        end
        while true do
            playerPed = rollercoasterhandler2
            playerPed = playerPed.getnew
            if false ~= playerPed then
                break
            end
            playerPed = nearbythemepark
            if true ~= playerPed then
                break
            end
            playerPed = isDisabled6
            if false ~= playerPed then
                break
            end
            playerPed = Citizen
            playerPed = playerPed.Wait
            dataTable7 = hash
            playerPed(dataTable7)
            playerPed = rollercoasterhandler2
            playerPed = playerPed.stageid
            playerPed = dataTable[playerPed]
            playerPed = playerPed.coords
            dataTable7 = dataTable[entityCoords2]
            dataTable7 = dataTable7.coords
            playerPed = playerPed - dataTable7
            playerPed = #playerPed
            if playerPed > 0.0 then
                dataTable7 = rollercoasterhandler2
                isEnabled8 = rollercoasterhandler2
                isEnabled8 = isEnabled8.stageid
                isEnabled8 = isEnabled8 + 1
                dataTable7.stageid = isEnabled8
                dataTable7 = rollercoasterhandler2
                dataTable7 = dataTable7.getnew
                if false == dataTable7 then
                    dataTable7 = rollercoasterhandler2
                    dataTable7 = dataTable7.stageid
                    if dataTable7 == entityCoords then
                        dataTable7 = SetEntityCoordsNoOffset
                        isEnabled8 = var13
                        dataTable2 = rollercoasterhandler2
                        dataTable2 = dataTable2.stageid
                        dataTable2 = dataTable[dataTable2]
                        dataTable2 = dataTable2.coords
                        dataTable2 = dataTable2.x
                        isEnabled4 = rollercoasterhandler2
                        isEnabled4 = isEnabled4.stageid
                        isEnabled4 = dataTable[isEnabled4]
                        isEnabled4 = isEnabled4.coords
                        isEnabled4 = isEnabled4.y
                        isDisabled5 = rollercoasterhandler2
                        isDisabled5 = isDisabled5.stageid
                        isDisabled5 = dataTable[isDisabled5]
                        isDisabled5 = isDisabled5.coords
                        isDisabled5 = isDisabled5.z
                        isEnabled6 = true
                        isDisabled9 = false
                        isDisabled4 = false
                        dataTable7(isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4)
                        dataTable7 = SetEntityQuaternion
                        isEnabled8 = var13
                        dataTable2 = rollercoasterhandler2
                        dataTable2 = dataTable2.stageid
                        dataTable2 = dataTable[dataTable2]
                        dataTable2 = dataTable2.objectscoords1x
                        isEnabled4 = rollercoasterhandler2
                        isEnabled4 = isEnabled4.stageid
                        isEnabled4 = dataTable[isEnabled4]
                        isEnabled4 = isEnabled4.objectscoords1y
                        isDisabled5 = rollercoasterhandler2
                        isDisabled5 = isDisabled5.stageid
                        isDisabled5 = dataTable[isDisabled5]
                        isDisabled5 = isDisabled5.objectscoords1z
                        isEnabled6 = rollercoasterhandler2
                        isEnabled6 = isEnabled6.stageid
                        isEnabled6 = dataTable[isEnabled6]
                        isEnabled6 = isEnabled6.objectscoords1w
                        dataTable7(isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6)
                        dataTable7 = rollercoasterhandler2
                        dataTable7.getnew = true
                    else
                        dataTable7 = SetEntityCoordsNoOffset
                        isEnabled8 = var13
                        dataTable2 = rollercoasterhandler2
                        dataTable2 = dataTable2.stageid
                        dataTable2 = dataTable[dataTable2]
                        dataTable2 = dataTable2.coords
                        dataTable2 = dataTable2.x
                        isEnabled4 = rollercoasterhandler2
                        isEnabled4 = isEnabled4.stageid
                        isEnabled4 = dataTable[isEnabled4]
                        isEnabled4 = isEnabled4.coords
                        isEnabled4 = isEnabled4.y
                        isDisabled5 = rollercoasterhandler2
                        isDisabled5 = isDisabled5.stageid
                        isDisabled5 = dataTable[isDisabled5]
                        isDisabled5 = isDisabled5.coords
                        isDisabled5 = isDisabled5.z
                        isEnabled6 = true
                        isDisabled9 = false
                        isDisabled4 = false
                        dataTable7(isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4)
                        dataTable7 = SetEntityQuaternion
                        isEnabled8 = var13
                        dataTable2 = rollercoasterhandler2
                        dataTable2 = dataTable2.stageid
                        dataTable2 = dataTable[dataTable2]
                        dataTable2 = dataTable2.objectscoords1x
                        isEnabled4 = rollercoasterhandler2
                        isEnabled4 = isEnabled4.stageid
                        isEnabled4 = dataTable[isEnabled4]
                        isEnabled4 = isEnabled4.objectscoords1y
                        isDisabled5 = rollercoasterhandler2
                        isDisabled5 = isDisabled5.stageid
                        isDisabled5 = dataTable[isDisabled5]
                        isDisabled5 = isDisabled5.objectscoords1z
                        isEnabled6 = rollercoasterhandler2
                        isEnabled6 = isEnabled6.stageid
                        isEnabled6 = dataTable[isEnabled6]
                        isEnabled6 = isEnabled6.objectscoords1w
                        dataTable7(isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6)
                    end
                end
            else
                dataTable7 = Config
                dataTable7 = dataTable7.AttractionsSettings
                dataTable7 = dataTable7.rollercoaster2
                dataTable7 = dataTable7.speedmodifier
                dataTable7 = 8 * dataTable7
                A1_2 = A1_2 + dataTable7
            end
        end
    else
        entityCoords2 = rollercoasterhandler2
        entityCoords2.getnew = true
    end
end
dataTable5(dataTable4, dataTable6)
dataTable5 = RegisterNetEvent
dataTable4 = "rtx_themepark:Rollercoaster2:SeatData"
dataTable5(dataTable4)
dataTable5 = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster2:SeatData"

function dataTable6(A0_2)
    local isEnabled5, entityCoords2, dataTable, entityCoords
    isEnabled5 = SendNUIMessage
    entityCoords2 = {}
    entityCoords2.message = "attractionhow"
    entityCoords2.attractionanimchange = true
    entityCoords2.rollercoastercamchange = true
    isEnabled5(entityCoords2)
    var12 = A0_2
    isEnabled5 = SetEntityCompletelyDisableCollision
    entityCoords2 = var13
    dataTable = false
    entityCoords = false
    isEnabled5(entityCoords2, dataTable, entityCoords)
    isEnabled5 = true
    isDisabled3 = isEnabled5
end
dataTable5(dataTable4, dataTable6)
dataTable5 = RegisterNetEvent
dataTable4 = "rtx_themepark:Rollercoaster2:SeatExit"
dataTable5(dataTable4)
dataTable5 = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster2:SeatExit"

function dataTable6(A0_2)
    local isEnabled5, entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7
    isEnabled5 = PlayerPedId
    isEnabled5 = isEnabled5()
    entityCoords2 = DetachEntity
    dataTable = isEnabled5
    entityCoords2(dataTable)
    entityCoords2 = FreezeEntityPosition
    dataTable = isEnabled5
    entityCoords = false
    entityCoords2(dataTable, entityCoords)
    entityCoords2 = ClearPedTasks
    dataTable = isEnabled5
    entityCoords2(dataTable)
    entityCoords2 = GlobalState
    entityCoords2 = entityCoords2["attraction17 - phase"]
    if 0 == entityCoords2 then
    else
        entityCoords2 = SetEntityCoordsNoOffset
        dataTable = isEnabled5
        entityCoords = -1631.4513
        hash = -1194.3196
        playerPed = 14.1111
        entityCoords2(dataTable, entityCoords, hash, playerPed)
        entityCoords2 = SetEntityHeading
        dataTable = isEnabled5
        entityCoords = 0.0
        entityCoords2(dataTable, entityCoords)
    end
    entityCoords2 = SendNUIMessage
    dataTable = {}
    dataTable.message = "hideattraction"
    entityCoords2(dataTable)
    currentseatid = nil
    entityCoords2 = SetEntityCompletelyDisableCollision
    dataTable = var13
    entityCoords = true
    hash = true
    entityCoords2(dataTable, entityCoords, hash)
    if true == A0_2 then
        entityCoords2 = SetEntityCoordsNoOffset
        dataTable = isEnabled5
        entityCoords = -1629.79
        hash = -1192.59
        playerPed = 14.0
        entityCoords2(dataTable, entityCoords, hash, playerPed)
    end
    entityCoords2 = DoesCamExist
    dataTable = var14
    entityCoords2 = entityCoords2(dataTable)
    if entityCoords2 then
        entityCoords2 = DestroyCam
        dataTable = var14
        entityCoords = false
        entityCoords2(dataTable, entityCoords)
    end
    entityCoords2 = DoesEntityExist
    dataTable = var1
    entityCoords2 = entityCoords2(dataTable)
    if entityCoords2 then
        entityCoords2 = DeleteEntity
        dataTable = var1
        entityCoords2(dataTable)
    end
    entityCoords2 = RenderScriptCams
    dataTable = false
    entityCoords = 0
    hash = 0
    playerPed = true
    dataTable7 = false
    entityCoords2(dataTable, entityCoords, hash, playerPed, dataTable7)
    entityCoords2 = false
    isDisabled = entityCoords2
    entityCoords2 = false
    isDisabled3 = entityCoords2
end
dataTable5(dataTable4, dataTable6)
dataTable5 = Config
dataTable5 = dataTable5.Target
if true == dataTable5 then
    dataTable5 = RegisterNetEvent
    dataTable4 = "rtx_themepark:Rollercoaster2:SeatUseTarget"
    dataTable5(dataTable4)
    dataTable5 = AddEventHandler
    dataTable4 = "rtx_themepark:Rollercoaster2:SeatUseTarget"

    function dataTable6()
        local hash2, isEnabled5, entityCoords2
        hash2 = usingattraction
        if false == hash2 then
            hash2 = dataTable3.seatid
            if nil ~= hash2 then
                hash2 = iteminhand
                if false == hash2 then
                    hash2 = TriggerServerEvent
                    isEnabled5 = "rtx_themepark:Rollercoaster2:SeatUse"
                    entityCoords2 = dataTable3.seatid
                    hash2(isEnabled5, entityCoords2)
                else
                    hash2 = Notify
                    isEnabled5 = Language
                    entityCoords2 = Config
                    entityCoords2 = entityCoords2.Language
                    isEnabled5 = isEnabled5[entityCoords2]
                    isEnabled5 = isEnabled5.iteminhand
                    hash2(isEnabled5)
                end
            end
        end
    end
    dataTable5(dataTable4, dataTable6)
end
dataTable5 = Citizen
dataTable5 = dataTable5.CreateThread

function dataTable4()
    local hash2, isEnabled5, entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3
    while true do
        hash2 = Citizen
        hash2 = hash2.Wait
        isEnabled5 = 500
        hash2(isEnabled5)
        hash2 = nearbythemepark
        if true ~= hash2 then
            hash2 = nearbythemepark
            if false ~= hash2 then
                goto lbl_152
            end
        end
        hash2 = DoesEntityExist
        isEnabled5 = var13
        hash2 = hash2(isEnabled5)
        if hash2 then
        else
            hash2 = GetHashKey
            isEnabled5 = "sempre_delperropier_rollercoaster_vozik"
            hash2 = hash2(isEnabled5)
            isEnabled5 = RequestModel
            entityCoords2 = hash2
            isEnabled5(entityCoords2)
            while true do
                isEnabled5 = HasModelLoaded
                entityCoords2 = hash2
                isEnabled5 = isEnabled5(entityCoords2)
                if isEnabled5 then
                    break
                end
                isEnabled5 = RequestModel
                entityCoords2 = hash2
                isEnabled5(entityCoords2)
                isEnabled5 = Citizen
                isEnabled5 = isEnabled5.Wait
                entityCoords2 = 5
                isEnabled5(entityCoords2)
            end
            isEnabled5 = CreateObjectNoOffset
            entityCoords2 = hash2
            dataTable = -1628.0427246094
            entityCoords = -1194.2862548828
            hash = 13.053557395935
            playerPed = false
            dataTable7 = true
            isEnabled8 = true
            isEnabled5 = isEnabled5(entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8)
            var13 = isEnabled5
            isEnabled5 = SetEntityRotation
            entityCoords2 = var13
            dataTable = 0.0
            entityCoords = 0.0
            hash = 0.0
            isEnabled5(entityCoords2, dataTable, entityCoords, hash)
            isEnabled5 = SetEntityQuaternion
            entityCoords2 = var13
            dataTable = -0.0013869871618226
            entityCoords = -4.342730389908e-4
            hash = 0.9387509226799
            playerPed = 0.34459361433983
            isEnabled5(entityCoords2, dataTable, entityCoords, hash, playerPed)
            isEnabled5 = NetworkAllowLocalEntityAttachment
            entityCoords2 = var13
            dataTable = true
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = FreezeEntityPosition
            entityCoords2 = var13
            dataTable = true
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = SetEntityVisible
            entityCoords2 = var13
            dataTable = false
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = SetEntityMotionBlur
            entityCoords2 = var13
            dataTable = false
            isEnabled5(entityCoords2, dataTable)
        end
        hash2 = DoesEntityExist
        isEnabled5 = var15
        hash2 = hash2(isEnabled5)
        if hash2 then
        else
            hash2 = GetHashKey
            isEnabled5 = "sempre_delperropier_rollercoaster_vozik"
            hash2 = hash2(isEnabled5)
            isEnabled5 = RequestModel
            entityCoords2 = hash2
            isEnabled5(entityCoords2)
            while true do
                isEnabled5 = HasModelLoaded
                entityCoords2 = hash2
                isEnabled5 = isEnabled5(entityCoords2)
                if isEnabled5 then
                    break
                end
                isEnabled5 = RequestModel
                entityCoords2 = hash2
                isEnabled5(entityCoords2)
                isEnabled5 = Citizen
                isEnabled5 = isEnabled5.Wait
                entityCoords2 = 5
                isEnabled5(entityCoords2)
            end
            isEnabled5 = CreateObjectNoOffset
            entityCoords2 = hash2
            dataTable = -1628.0427246094
            entityCoords = -1194.2862548828
            hash = 13.053557395935
            playerPed = false
            dataTable7 = true
            isEnabled8 = true
            isEnabled5 = isEnabled5(entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8)
            var15 = isEnabled5
            isEnabled5 = SetEntityRotation
            entityCoords2 = var15
            dataTable = 0.0
            entityCoords = 0.0
            hash = 0.0
            isEnabled5(entityCoords2, dataTable, entityCoords, hash)
            isEnabled5 = SetEntityQuaternion
            entityCoords2 = var15
            dataTable = -0.0013869871618226
            entityCoords = -4.342730389908e-4
            hash = 0.9387509226799
            playerPed = 0.34459361433983
            isEnabled5(entityCoords2, dataTable, entityCoords, hash, playerPed)
            isEnabled5 = NetworkAllowLocalEntityAttachment
            entityCoords2 = var15
            dataTable = true
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = FreezeEntityPosition
            entityCoords2 = var15
            dataTable = true
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = SetEntityMotionBlur
            entityCoords2 = var15
            dataTable = false
            isEnabled5(entityCoords2, dataTable)
            isEnabled5 = AttachEntityToEntity
            entityCoords2 = var15
            dataTable = var13
            entityCoords = 0
            hash = 0.0
            playerPed = 0.0
            dataTable7 = 0.2
            isEnabled8 = 0.0
            dataTable2 = 0.0
            isEnabled4 = 0.0
            isDisabled5 = false
            isEnabled6 = false
            isDisabled9 = false
            isDisabled4 = false
            counter4 = 5
            isEnabled3 = true
            isEnabled5(entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3)
        end
        ::lbl_152::
    end
end
dataTable5(dataTable4)
dataTable5 = -1
dataTable4 = Citizen
dataTable4 = dataTable4.CreateThread

function dataTable6()
    local hash2, isEnabled5, entityCoords2, dataTable
    while true do
        hash2 = Citizen
        hash2 = hash2.Wait
        isEnabled5 = 0
        hash2(isEnabled5)
        hash2 = GlobalState
        hash2 = hash2["attraction17 - phase"]
        if 0 ~= hash2 then
            hash2 = nearbythemepark
            if false ~= hash2 then
                goto lbl_21
            end
        end
        hash2 = rollercoasterhandler2
        hash2.getnew = true
        hash2 = -1
        dataTable5 = hash2
        hash2 = Citizen
        hash2 = hash2.Wait
        isEnabled5 = 500
        hash2(isEnabled5)
        goto lbl_41
        ::lbl_21::
        hash2 = dataTable5
        if -1 ~= hash2 then
            hash2 = dataTable5
            isEnabled5 = GlobalState
            isEnabled5 = isEnabled5["attraction17 - synchdata"]
            if not (hash2 < isEnabled5) then
                goto lbl_41
            end
        end
        hash2 = tonumber
        isEnabled5 = GlobalState
        isEnabled5 = isEnabled5["attraction17 - synchdata"]
        hash2 = hash2(isEnabled5)
        dataTable5 = hash2
        hash2 = TriggerEvent
        isEnabled5 = "rtx_themepark:Rollercoaster2:SynchronizeMovement"
        entityCoords2 = GlobalState
        entityCoords2 = entityCoords2["attraction17 - ridedata1"]
        dataTable = GlobalState
        dataTable = dataTable["attraction17 - ridedata2"]
        hash2(isEnabled5, entityCoords2, dataTable)
        ::lbl_41::
    end
end
dataTable4(dataTable6)
dataTable4 = Config
dataTable4 = dataTable4.AttractionsSettings
dataTable4 = dataTable4.rollercoaster2
dataTable4 = dataTable4.disable
if false == dataTable4 then
    dataTable4 = Citizen
    dataTable4 = dataTable4.CreateThread

    function dataTable6()
        local hash2, isEnabled5, entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3
        while true do
            hash2 = Citizen
            hash2 = hash2.Wait
            isEnabled5 = 0
            hash2(isEnabled5)
            hash2 = true
            isEnabled5 = PlayerPedId
            isEnabled5 = isEnabled5()
            entityCoords2 = GetEntityCoords
            dataTable = isEnabled5
            entityCoords2 = entityCoords2(dataTable)
            dataTable = false
            entityCoords = -1
            hash = {}
            hash.seatid = nil
            playerPed = GlobalState
            playerPed = playerPed["attraction17 - phase"]
            if 0 == playerPed then
                playerPed = usingattraction
                if false == playerPed then
                    playerPed = nearbythemepark
                    if true == playerPed then
                        playerPed = tickets
                        playerPed = playerPed.rollercoaster2
                        if true == playerPed then
                            playerPed = ipairs
                            dataTable7 = rollercoasterhandler2
                            dataTable7 = dataTable7.seats
                            playerPed, dataTable7, isEnabled8, dataTable2 = playerPed(dataTable7)
                            for isEnabled4, isDisabled5 in playerPed, dataTable7, isEnabled8, dataTable2 do
                                isEnabled6 = isDisabled5.taken
                                if false == isEnabled6 then
                                    isEnabled6 = GetOffsetFromEntityInWorldCoords
                                    isDisabled9 = var15
                                    isDisabled4 = isDisabled5.offsets
                                    isDisabled4 = isDisabled4.coords
                                    isDisabled4 = isDisabled4.x
                                    counter4 = isDisabled5.offsets
                                    counter4 = counter4.coords
                                    counter4 = counter4.y
                                    isEnabled3 = isDisabled5.offsets
                                    isEnabled3 = isEnabled3.coords
                                    isEnabled3 = isEnabled3.z
                                    isEnabled6 = isEnabled6(isDisabled9, isDisabled4, counter4, isEnabled3)
                                    isDisabled9 = entityCoords2 - isEnabled6
                                    isDisabled9 = #isDisabled9
                                    if isDisabled9 < 20.0 then
                                        isDisabled4 = Config
                                        isDisabled4 = isDisabled4.AttractionsSettings
                                        isDisabled4 = isDisabled4.rollercoaster2
                                        isDisabled4 = isDisabled4.usedistance
                                        if isDisabled9 < isDisabled4 and (-1 == entityCoords or entityCoords > isDisabled9) then
                                            entityCoords = isDisabled9
                                            dataTable = true
                                            hash.seatid = isEnabled4
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if dataTable then
                playerPed = {}
                dataTable7 = hash.seatid
                playerPed.seatid = dataTable7
                dataTable3 = playerPed
                playerPed = false
                dataTable7 = usingattraction
                if false == dataTable7 then
                    hash2 = false
                    dataTable7 = Config
                    dataTable7 = dataTable7.Target
                    if false == dataTable7 then
                        dataTable7 = rollercoasterhandler2
                        dataTable7 = dataTable7.seats
                        isEnabled8 = dataTable3.seatid
                        dataTable7 = dataTable7[isEnabled8]
                        isEnabled8 = Config
                        isEnabled8 = isEnabled8.ThemeParkInteractionSystem
                        if 1 == isEnabled8 then
                            isEnabled8 = SendNUIMessage
                            dataTable2 = {}
                            dataTable2.message = "infonotifyshow"
                            isEnabled4 = Language
                            isDisabled5 = Config
                            isDisabled5 = isDisabled5.Language
                            isEnabled4 = isEnabled4[isDisabled5]
                            isEnabled4 = isEnabled4.pressforuseseatinteract
                            dataTable2.infonotifytext = isEnabled4
                            isEnabled8(dataTable2)
                            playerPed = true
                        else
                            isEnabled8 = Config
                            isEnabled8 = isEnabled8.ThemeParkInteractionSystem
                            if 2 == isEnabled8 then
                                isEnabled8 = GetOffsetFromEntityInWorldCoords
                                dataTable2 = var15
                                isEnabled4 = dataTable7.offsets
                                isEnabled4 = isEnabled4.coords
                                isEnabled4 = isEnabled4.x
                                isDisabled5 = dataTable7.offsets
                                isDisabled5 = isDisabled5.coords
                                isDisabled5 = isDisabled5.y
                                isEnabled6 = dataTable7.offsets
                                isEnabled6 = isEnabled6.coords
                                isEnabled6 = isEnabled6.z
                                isEnabled8 = isEnabled8(dataTable2, isEnabled4, isDisabled5, isEnabled6)
                                dataTable2 = DrawText3D
                                isEnabled4 = isEnabled8.x
                                isDisabled5 = isEnabled8.y
                                isEnabled6 = isEnabled8.z
                                isDisabled9 = Language
                                isDisabled4 = Config
                                isDisabled4 = isDisabled4.Language
                                isDisabled9 = isDisabled9[isDisabled4]
                                isDisabled9 = isDisabled9.pressforuseseat
                                dataTable2(isEnabled4, isDisabled5, isEnabled6, isDisabled9)
                            else
                                isEnabled8 = Config
                                isEnabled8 = isEnabled8.ThemeParkInteractionSystem
                                if 3 == isEnabled8 then
                                    isEnabled8 = ShowGtaClassicInteraction
                                    dataTable2 = Language
                                    isEnabled4 = Config
                                    isEnabled4 = isEnabled4.Language
                                    dataTable2 = dataTable2[isEnabled4]
                                    dataTable2 = dataTable2.pressforuseseatinteractclassic
                                    isEnabled8(dataTable2)
                                end
                            end
                        end
                    end
                end
            else
                playerPed = Config
                playerPed = playerPed.ThemeParkInteractionSystem
                if 1 == playerPed then
                    playerPed = dataTable3.seatid
                    if nil ~= playerPed then
                        playerPed = SendNUIMessage
                        dataTable7 = {}
                        dataTable7.message = "hide"
                        playerPed(dataTable7)
                    end
                end
                playerPed = {}
                playerPed.seatid = nil
                dataTable3 = playerPed
            end
            if hash2 then
                playerPed = Citizen
                playerPed = playerPed.Wait
                dataTable7 = 1000
                playerPed(dataTable7)
            end
        end
    end
    dataTable4(dataTable6)
end
dataTable4 = Config
dataTable4 = dataTable4.Target
if false == dataTable4 then
    dataTable4 = RegisterCommand
    dataTable6 = "userollercoaster2seat"

    function dataTable8()
        local hash2, isEnabled5, entityCoords2
        hash2 = usingattraction
        if false == hash2 then
            hash2 = dataTable3.seatid
            if nil ~= hash2 then
                hash2 = iteminhand
                if false == hash2 then
                    hash2 = TriggerServerEvent
                    isEnabled5 = "rtx_themepark:Rollercoaster2:SeatUse"
                    entityCoords2 = dataTable3.seatid
                    hash2(isEnabled5, entityCoords2)
                else
                    hash2 = Notify
                    isEnabled5 = Language
                    entityCoords2 = Config
                    entityCoords2 = entityCoords2.Language
                    isEnabled5 = isEnabled5[entityCoords2]
                    isEnabled5 = isEnabled5.iteminhand
                    hash2(isEnabled5)
                end
            end
        end
    end
    dataTable4(dataTable6, dataTable8)
    dataTable4 = RegisterKeyMapping
    dataTable6 = "userollercoaster2seat"
    dataTable8 = Language
    strValue = Config
    strValue = strValue.Language
    dataTable8 = dataTable8[strValue]
    dataTable8 = dataTable8.bindrollercoasterseatuse
    strValue = "keyboard"
    counter = Config
    counter = counter.ThemeParkSeatKey
    dataTable4(dataTable6, dataTable8, strValue, counter)
end
dataTable4 = false
dataTable6 = RegisterCommand
dataTable8 = "changerollercoaster2anim"

function strValue()
    local hash2, isEnabled5, entityCoords2
    hash2 = usingattraction
    if true == hash2 then
        hash2 = var12
        if nil ~= hash2 then
            hash2 = dataTable4
            if false == hash2 then
                hash2 = true
                dataTable4 = hash2
                hash2 = TriggerServerEvent
                isEnabled5 = "rtx_themepark:Rollercoaster2:SeatAnimChange"
                entityCoords2 = var12
                hash2(isEnabled5, entityCoords2)
                hash2 = Citizen
                hash2 = hash2.Wait
                isEnabled5 = Config
                isEnabled5 = isEnabled5.AttractionsSettings
                isEnabled5 = isEnabled5.rollercoaster
                isEnabled5 = isEnabled5.animcooldown
                hash2(isEnabled5)
                hash2 = false
                dataTable4 = hash2
            end
        end
    end
end
dataTable6(dataTable8, strValue)
dataTable6 = RegisterKeyMapping
dataTable8 = "changerollercoaster2anim"
strValue = Language
counter = Config
counter = counter.Language
strValue = strValue[counter]
strValue = strValue.bindrollercoasteranimchange
counter = "keyboard"
counter3 = Config
counter3 = counter3.ThemeParkAnimChangeKey
dataTable6(dataTable8, strValue, counter, counter3)
dataTable6 = RegisterCommand
dataTable8 = "exitrollercoaster2"

function strValue()
    local hash2, isEnabled5, entityCoords2
    hash2 = usingattraction
    if true == hash2 then
        hash2 = var12
        if nil ~= hash2 then
            hash2 = Config
            hash2 = hash2.ThemeParkDisableExit
            if false ~= hash2 then
                hash2 = rollercoasterhandler2
                hash2 = hash2.started
                if false ~= hash2 then
                    goto lbl_20
                end
            end
            hash2 = TriggerServerEvent
            isEnabled5 = "rtx_themepark:Rollercoaster2:ExitAttraction"
            entityCoords2 = var12
            hash2(isEnabled5, entityCoords2)
            goto lbl_27
            ::lbl_20::
            hash2 = Notify
            isEnabled5 = Language
            entityCoords2 = Config
            entityCoords2 = entityCoords2.Language
            isEnabled5 = isEnabled5[entityCoords2]
            isEnabled5 = isEnabled5.inprogress
            hash2(isEnabled5)
        end
    end
    ::lbl_27::
end
dataTable6(dataTable8, strValue)
dataTable6 = RegisterKeyMapping
dataTable8 = "exitrollercoaster2"
strValue = Language
counter = Config
counter = counter.Language
strValue = strValue[counter]
strValue = strValue.bindattractionexitkey
counter = "keyboard"
counter3 = Config
counter3 = counter3.ThemeParkExitKey
dataTable6(dataTable8, strValue, counter, counter3)
dataTable6 = RegisterCommand
dataTable8 = "changecamerarollercoaster"

function strValue(A0_2, A1_2)
    local entityCoords2, dataTable, entityCoords, hash, playerPed, dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3, isEnabled, isDisabled8, isDisabled7, isDisabled2, isEnabled2
    entityCoords2 = usingattraction
    if true == entityCoords2 then
        entityCoords2 = isDisabled3
        if true == entityCoords2 then
            entityCoords2 = var12
            if nil ~= entityCoords2 then
                entityCoords2 = isDisabled
                if false == entityCoords2 then
                    entityCoords2 = true
                    isDisabled = entityCoords2
                    entityCoords2 = DoesCamExist
                    dataTable = var14
                    entityCoords2 = entityCoords2(dataTable)
                    if entityCoords2 then
                        entityCoords2 = DestroyCam
                        dataTable = var14
                        entityCoords = false
                        entityCoords2(dataTable, entityCoords)
                    end
                    entityCoords2 = DoesEntityExist
                    dataTable = var1
                    entityCoords2 = entityCoords2(dataTable)
                    if entityCoords2 then
                        entityCoords2 = DeleteEntity
                        dataTable = var1
                        entityCoords2(dataTable)
                    end
                    entityCoords2 = CreateCam
                    dataTable = "DEFAULT_SCRIPTED_CAMERA"
                    entityCoords = true
                    entityCoords2 = entityCoords2(dataTable, entityCoords)
                    var14 = entityCoords2
                    entityCoords2 = PlayerPedId
                    entityCoords2 = entityCoords2()
                    dataTable = rollercoasterhandler2
                    dataTable = dataTable.seats
                    entityCoords = var12
                    dataTable = dataTable[entityCoords]
                    entityCoords = GetEntityCoords
                    hash = entityCoords2
                    entityCoords = entityCoords(hash)
                    hash = GetHashKey
                    playerPed = "blazer"
                    hash = hash(playerPed)
                    playerPed = RequestModel
                    dataTable7 = hash
                    playerPed(dataTable7)
                    while true do
                        playerPed = HasModelLoaded
                        dataTable7 = hash
                        playerPed = playerPed(dataTable7)
                        if playerPed then
                            break
                        end
                        playerPed = RequestModel
                        dataTable7 = hash
                        playerPed(dataTable7)
                        playerPed = Citizen
                        playerPed = playerPed.Wait
                        dataTable7 = 5
                        playerPed(dataTable7)
                    end
                    playerPed = CreateVehicle
                    dataTable7 = hash
                    isEnabled8 = entityCoords
                    dataTable2 = 0.0
                    isEnabled4 = false
                    isDisabled5 = false
                    playerPed = playerPed(dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5)
                    var1 = playerPed
                    playerPed = FreezeEntityPosition
                    dataTable7 = var1
                    isEnabled8 = true
                    playerPed(dataTable7, isEnabled8)
                    playerPed = SetEntityInvincible
                    dataTable7 = var1
                    isEnabled8 = true
                    playerPed(dataTable7, isEnabled8)
                    playerPed = FreezeEntityPosition
                    dataTable7 = var1
                    isEnabled8 = true
                    playerPed(dataTable7, isEnabled8)
                    playerPed = NetworkAllowLocalEntityAttachment
                    dataTable7 = var1
                    isEnabled8 = true
                    playerPed(dataTable7, isEnabled8)
                    playerPed = SetEntityMotionBlur
                    dataTable7 = var1
                    isEnabled8 = false
                    playerPed(dataTable7, isEnabled8)
                    playerPed = SetEntityVisible
                    dataTable7 = var1
                    isEnabled8 = false
                    playerPed(dataTable7, isEnabled8)
                    playerPed = AttachEntityToEntity
                    dataTable7 = var1
                    isEnabled8 = var15
                    dataTable2 = 0
                    isEnabled4 = 0.0
                    isDisabled5 = dataTable.offsets
                    isDisabled5 = isDisabled5.coords
                    isDisabled5 = isDisabled5.y
                    isEnabled6 = dataTable.offsets
                    isEnabled6 = isEnabled6.coords
                    isEnabled6 = isEnabled6.z
                    isEnabled6 = isEnabled6 + 0.2
                    isDisabled9 = dataTable.offsets
                    isDisabled9 = isDisabled9.rotation
                    isDisabled9 = isDisabled9.x
                    isDisabled4 = dataTable.offsets
                    isDisabled4 = isDisabled4.rotation
                    isDisabled4 = isDisabled4.y
                    counter4 = dataTable.offsets
                    counter4 = counter4.rotation
                    counter4 = counter4.z
                    isEnabled3 = false
                    isEnabled = false
                    isDisabled8 = false
                    isDisabled7 = false
                    isDisabled2 = 5
                    isEnabled2 = true
                    playerPed(dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3, isEnabled, isDisabled8, isDisabled7, isDisabled2, isEnabled2)
                    playerPed = AttachCamToVehicleBone
                    dataTable7 = var14
                    isEnabled8 = var1
                    dataTable2 = 0
                    isEnabled4 = true
                    isDisabled5 = 0.0
                    isEnabled6 = 0.0
                    isDisabled9 = 0.0
                    isDisabled4 = 0.0
                    counter4 = 0.0
                    isEnabled3 = 0.0
                    isEnabled = true
                    playerPed(dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5, isEnabled6, isDisabled9, isDisabled4, counter4, isEnabled3, isEnabled)
                    playerPed = SetCamActive
                    dataTable7 = var14
                    isEnabled8 = true
                    playerPed(dataTable7, isEnabled8)
                    playerPed = RenderScriptCams
                    dataTable7 = true
                    isEnabled8 = 0
                    dataTable2 = 0
                    isEnabled4 = true
                    isDisabled5 = false
                    playerPed(dataTable7, isEnabled8, dataTable2, isEnabled4, isDisabled5)
                else
                    entityCoords2 = DoesCamExist
                    dataTable = var14
                    entityCoords2 = entityCoords2(dataTable)
                    if entityCoords2 then
                        entityCoords2 = DestroyCam
                        dataTable = var14
                        entityCoords = false
                        entityCoords2(dataTable, entityCoords)
                    end
                    entityCoords2 = DoesEntityExist
                    dataTable = var1
                    entityCoords2 = entityCoords2(dataTable)
                    if entityCoords2 then
                        entityCoords2 = DeleteEntity
                        dataTable = var1
                        entityCoords2(dataTable)
                    end
                    entityCoords2 = false
                    isDisabled = entityCoords2
                    entityCoords2 = RenderScriptCams
                    dataTable = false
                    entityCoords = 0
                    hash = 0
                    playerPed = true
                    dataTable7 = false
                    entityCoords2(dataTable, entityCoords, hash, playerPed, dataTable7)
                end
            end
        end
    end
end
dataTable6(dataTable8, strValue)
dataTable6 = RegisterKeyMapping
dataTable8 = "changecamerarollercoaster"
strValue = Language
counter = Config
counter = counter.Language
strValue = strValue[counter]
strValue = strValue.attractioncamera
counter = "keyboard"
counter3 = Config
counter3 = counter3.AttractionsSettings
counter3 = counter3.brakedance
counter3 = counter3.changecamera
dataTable6(dataTable8, strValue, counter, counter3)