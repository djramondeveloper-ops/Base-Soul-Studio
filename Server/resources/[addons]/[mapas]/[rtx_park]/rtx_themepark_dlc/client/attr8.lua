
local dataTable2, var1, var12, isDisabled7, isDisabled3, isDisabled, counter3, dataTable6, dataTable8, dataTable4, coords2, dataTable5, coords5, coords4, coords, coords3, counter, counter4, counter2
dataTable2 = IsDuplicityVersion
dataTable2 = dataTable2()
if dataTable2 then
    dataTable2 = GetPlayerPositionInRealTime75
    dataTable2()
end
dataTable2 = {}
dataTable2.cartid = nil
dataTable2.seatid = nil
dataTable2.platformid = nil
var1 = nil
var12 = nil
isDisabled7 = false
isDisabled3 = false
isDisabled = false
counter3 = 0
dataTable6 = {}
dataTable6.started = false
dataTable6.stageid = 0
dataTable6.getnew = false
dataTable8 = {}
dataTable4 = {}
dataTable4.object = "ind_prop_dlc_roller_car"
dataTable4.handler = nil
coords2 = vector3
dataTable5 = -1643.5240478516
coords5 = -1124.6810302734
coords4 = 17.432600021362
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.coords = coords2
coords2 = vector3
dataTable5 = -0.98019218444824
coords5 = -2.5906699011102e-4
coords4 = 140.0203704834
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.rotation = coords2
coords2 = {}
dataTable5 = {}
coords5 = vector3
coords4 = -1644.35
coords = -1123.54
coords3 = 18.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.coords = coords5
dataTable5.seatid1 = 1
dataTable5.seatid2 = 2
coords5 = {}
coords4 = vector3
coords = -1644.97
coords3 = -1124.29
counter = 18.33
coords4 = coords4(coords, coords3, counter)
coords5.coords = coords4
coords5.seatid1 = 3
coords5.seatid2 = 4
coords2[1] = dataTable5
coords2[2] = coords5
dataTable4.platforms = coords2
coords2 = {}
dataTable5 = {}
dataTable5.taken = false
dataTable5.takenplayerid = nil
dataTable5.seattype = 1
dataTable5.seatcategory = "one"
dataTable5.seatcategoryoffset = -1.017
coords5 = vector3
coords4 = -0.231
coords = -0.038
coords3 = 0.914
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatoffsets = coords5
coords5 = vector3
coords4 = -1641.83
coords = -1125.54
coords3 = 17.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatend = coords5
coords5 = {}
coords5.taken = false
coords5.takenplayerid = nil
coords5.seattype = 1
coords5.seatcategory = "two"
coords5.seatcategoryoffset = -1.017
coords4 = vector3
coords = 0.297
coords3 = -0.038
counter = 0.914
coords4 = coords4(coords, coords3, counter)
coords5.seatoffsets = coords4
coords4 = vector3
coords = -1641.83
coords3 = -1125.54
counter = 17.33
coords4 = coords4(coords, coords3, counter)
coords5.seatend = coords4
coords4 = {}
coords4.taken = false
coords4.takenplayerid = nil
coords4.seattype = 1
coords4.seatcategory = "one"
coords4.seatcategoryoffset = 0.0
coords = vector3
coords3 = -0.183
counter = 0.964
counter4 = 0.914
coords = coords(coords3, counter, counter4)
coords4.seatoffsets = coords
coords = vector3
coords3 = -1642.59
counter = -1126.17
counter4 = 17.33
coords = coords(coords3, counter, counter4)
coords4.seatend = coords
coords = {}
coords.taken = false
coords.takenplayerid = nil
coords.seattype = 1
coords.seatcategory = "two"
coords.seatcategoryoffset = 0.0
coords3 = vector3
counter = 0.297
counter4 = 0.964
counter2 = 0.914
coords3 = coords3(counter, counter4, counter2)
coords.seatoffsets = coords3
coords3 = vector3
counter = -1642.59
counter4 = -1126.17
counter2 = 17.33
coords3 = coords3(counter, counter4, counter2)
coords.seatend = coords3
coords2[1] = dataTable5
coords2[2] = coords5
coords2[3] = coords4
coords2[4] = coords
dataTable4.players = coords2
dataTable8[1] = dataTable4
dataTable4 = {}
dataTable4.object = "ind_prop_dlc_roller_car_02"
dataTable4.handler = nil
coords2 = vector3
dataTable5 = -1645.1635742188
coords5 = -1126.6341552734
coords4 = 17.431180953979
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.coords = coords2
coords2 = vector3
dataTable5 = -0.98019218444824
coords5 = -2.5906699011102e-4
coords4 = 140.0203704834
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.rotation = coords2
coords2 = {}
dataTable5 = {}
coords5 = vector3
coords4 = -1645.92
coords = -1125.47
coords3 = 18.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.coords = coords5
dataTable5.seatid1 = 1
dataTable5.seatid2 = 2
coords5 = {}
coords4 = vector3
coords = -1646.54
coords3 = -1126.25
counter = 18.33
coords4 = coords4(coords, coords3, counter)
coords5.coords = coords4
coords5.seatid1 = 3
coords5.seatid2 = 4
coords2[1] = dataTable5
coords2[2] = coords5
dataTable4.platforms = coords2
coords2 = {}
dataTable5 = {}
dataTable5.taken = false
dataTable5.takenplayerid = nil
dataTable5.seattype = 1
dataTable5.seatcategory = "one"
dataTable5.seatcategoryoffset = -1.017
coords5 = vector3
coords4 = -0.2
coords = -0.034
coords3 = 0.914
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatoffsets = coords5
coords5 = vector3
coords4 = -1643.42
coords = -1127.49
coords3 = 17.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatend = coords5
coords5 = {}
coords5.taken = false
coords5.takenplayerid = nil
coords5.seattype = 1
coords5.seatcategory = "two"
coords5.seatcategoryoffset = -1.017
coords4 = vector3
coords = 0.284
coords3 = -0.034
counter = 0.914
coords4 = coords4(coords, coords3, counter)
coords5.seatoffsets = coords4
coords4 = vector3
coords = -1643.42
coords3 = -1127.49
counter = 17.33
coords4 = coords4(coords, coords3, counter)
coords5.seatend = coords4
coords4 = {}
coords4.taken = false
coords4.takenplayerid = nil
coords4.seattype = 1
coords4.seatcategory = "one"
coords4.seatcategoryoffset = 0.0
coords = vector3
coords3 = -0.184
counter = 0.96
counter4 = 0.914
coords = coords(coords3, counter, counter4)
coords4.seatoffsets = coords
coords = vector3
coords3 = -1643.99
counter = -1128.23
counter4 = 17.33
coords = coords(coords3, counter, counter4)
coords4.seatend = coords
coords = {}
coords.taken = false
coords.takenplayerid = nil
coords.seattype = 1
coords.seatcategory = "two"
coords.seatcategoryoffset = 0.0
coords3 = vector3
counter = 0.284
counter4 = 0.974
counter2 = 0.914
coords3 = coords3(counter, counter4, counter2)
coords.seatoffsets = coords3
coords3 = vector3
counter = -1643.99
counter4 = -1128.23
counter2 = 17.33
coords3 = coords3(counter, counter4, counter2)
coords.seatend = coords3
coords2[1] = dataTable5
coords2[2] = coords5
coords2[3] = coords4
coords2[4] = coords
dataTable4.players = coords2
dataTable8[2] = dataTable4
dataTable4 = {}
dataTable4.object = "ind_prop_dlc_roller_car_02"
dataTable4.handler = nil
coords2 = vector3
dataTable5 = -1646.8031005859
coords5 = -1128.5871582031
coords4 = 17.429763793945
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.coords = coords2
coords2 = vector3
dataTable5 = -0.98019218444824
coords5 = -2.5906699011102e-4
coords4 = 140.0203704834
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.rotation = coords2
coords2 = {}
dataTable5 = {}
coords5 = vector3
coords4 = -1647.56
coords = -1127.49
coords3 = 18.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.coords = coords5
dataTable5.seatid1 = 1
dataTable5.seatid2 = 2
coords5 = {}
coords4 = vector3
coords = -1648.21
coords3 = -1128.17
counter = 18.33
coords4 = coords4(coords, coords3, counter)
coords5.coords = coords4
coords5.seatid1 = 3
coords5.seatid2 = 4
coords2[1] = dataTable5
coords2[2] = coords5
dataTable4.platforms = coords2
coords2 = {}
dataTable5 = {}
dataTable5.taken = false
dataTable5.takenplayerid = nil
dataTable5.seattype = 1
dataTable5.seatcategory = "one"
dataTable5.seatcategoryoffset = -1.017
coords5 = vector3
coords4 = -0.2
coords = -0.034
coords3 = 0.914
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatoffsets = coords5
coords5 = vector3
coords4 = -1644.97
coords = -1129.39
coords3 = 17.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatend = coords5
coords5 = {}
coords5.taken = false
coords5.takenplayerid = nil
coords5.seattype = 1
coords5.seatcategory = "two"
coords5.seatcategoryoffset = -1.017
coords4 = vector3
coords = 0.284
coords3 = -0.034
counter = 0.914
coords4 = coords4(coords, coords3, counter)
coords5.seatoffsets = coords4
coords4 = vector3
coords = -1644.97
coords3 = -1129.39
counter = 17.33
coords4 = coords4(coords, coords3, counter)
coords5.seatend = coords4
coords4 = {}
coords4.taken = false
coords4.takenplayerid = nil
coords4.seattype = 1
coords4.seatcategory = "one"
coords4.seatcategoryoffset = 0.0
coords = vector3
coords3 = -0.184
counter = 0.96
counter4 = 0.914
coords = coords(coords3, counter, counter4)
coords4.seatoffsets = coords
coords = vector3
coords3 = -1645.64
counter = -1130.11
counter4 = 17.33
coords = coords(coords3, counter, counter4)
coords4.seatend = coords
coords = {}
coords.taken = false
coords.takenplayerid = nil
coords.seattype = 1
coords.seatcategory = "two"
coords.seatcategoryoffset = 0.0
coords3 = vector3
counter = 0.284
counter4 = 0.974
counter2 = 0.914
coords3 = coords3(counter, counter4, counter2)
coords.seatoffsets = coords3
coords3 = vector3
counter = -1645.64
counter4 = -1130.11
counter2 = 17.33
coords3 = coords3(counter, counter4, counter2)
coords.seatend = coords3
coords2[1] = dataTable5
coords2[2] = coords5
coords2[3] = coords4
coords2[4] = coords
dataTable4.players = coords2
dataTable8[3] = dataTable4
dataTable4 = {}
dataTable4.object = "ind_prop_dlc_roller_car_02"
dataTable4.handler = nil
coords2 = vector3
dataTable5 = -1648.4425048828
coords5 = -1130.5402832031
coords4 = 17.428344726563
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.coords = coords2
coords2 = vector3
dataTable5 = -0.98019218444824
coords5 = -2.5906699011102e-4
coords4 = 140.0203704834
coords2 = coords2(dataTable5, coords5, coords4)
dataTable4.rotation = coords2
coords2 = {}
dataTable5 = {}
coords5 = vector3
coords4 = -1649.26
coords = -1129.44
coords3 = 18.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.coords = coords5
dataTable5.seatid1 = 1
dataTable5.seatid2 = 2
coords5 = {}
coords4 = vector3
coords = -1649.83
coords3 = -1130.31
counter = 18.33
coords4 = coords4(coords, coords3, counter)
coords5.coords = coords4
coords5.seatid1 = 3
coords5.seatid2 = 4
coords2[1] = dataTable5
coords2[2] = coords5
dataTable4.platforms = coords2
coords2 = {}
dataTable5 = {}
dataTable5.taken = false
dataTable5.takenplayerid = nil
dataTable5.seattype = 1
dataTable5.seatcategory = "one"
dataTable5.seatcategoryoffset = -1.017
coords5 = vector3
coords4 = -0.2
coords = -0.034
coords3 = 0.914
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatoffsets = coords5
coords5 = vector3
coords4 = -1646.63
coords = -1131.22
coords3 = 17.33
coords5 = coords5(coords4, coords, coords3)
dataTable5.seatend = coords5
coords5 = {}
coords5.taken = false
coords5.takenplayerid = nil
coords5.seattype = 1
coords5.seatcategory = "two"
coords5.seatcategoryoffset = -1.017
coords4 = vector3
coords = 0.284
coords3 = -0.034
counter = 0.914
coords4 = coords4(coords, coords3, counter)
coords5.seatoffsets = coords4
coords4 = vector3
coords = -1646.63
coords3 = -1131.22
counter = 17.33
coords4 = coords4(coords, coords3, counter)
coords5.seatend = coords4
coords4 = {}
coords4.taken = false
coords4.takenplayerid = nil
coords4.seattype = 1
coords4.seatcategory = "one"
coords4.seatcategoryoffset = 0.0
coords = vector3
coords3 = -0.184
counter = 0.96
counter4 = 0.914
coords = coords(coords3, counter, counter4)
coords4.seatoffsets = coords
coords = vector3
coords3 = -1647.39
counter = -1132.05
counter4 = 17.33
coords = coords(coords3, counter, counter4)
coords4.seatend = coords
coords = {}
coords.taken = false
coords.takenplayerid = nil
coords.seattype = 1
coords.seatcategory = "two"
coords.seatcategoryoffset = 0.0
coords3 = vector3
counter = 0.284
counter4 = 0.974
counter2 = 0.914
coords3 = coords3(counter, counter4, counter2)
coords.seatoffsets = coords3
coords3 = vector3
counter = -1647.39
counter4 = -1132.05
counter2 = 17.33
coords3 = coords3(counter, counter4, counter2)
coords.seatend = coords3
coords2[1] = dataTable5
coords2[2] = coords5
coords2[3] = coords4
coords2[4] = coords
dataTable4.players = coords2
dataTable8[4] = dataTable4
dataTable6.carts = dataTable8
rollercoasterhandler = dataTable6
dataTable6 = RegisterNetEvent
dataTable8 = "rtx_themepark:Rollercoaster:SynchronizeStarted"
dataTable6(dataTable8)
dataTable6 = AddEventHandler
dataTable8 = "rtx_themepark:Rollercoaster:SynchronizeStarted"

function dataTable4(A0_2)
    local isEnabled8
    isEnabled8 = rollercoasterhandler
    isEnabled8.started = A0_2
    if true == A0_2 then
        isEnabled8 = false
        isDisabled3 = isEnabled8
    end
end
dataTable6(dataTable8, dataTable4)
dataTable6 = RegisterNetEvent
dataTable8 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
dataTable6(dataTable8)
dataTable6 = AddEventHandler
dataTable8 = "rtx_themepark:Rollercoaster:SynchronizeSeat"

function dataTable4(A0_2, A1_2, A2_2, A3_2, A4_2)
    local dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6, isEnabled5, isDisabled4, isEnabled3, condition, isDisabled5, isDisabled2, isEnabled4, isDisabled8, var2, isEnabled
    dataTable9 = rollercoasterhandler
    dataTable9 = dataTable9.carts
    dataTable9 = dataTable9[A0_2]
    dataTable7 = rollercoasterhandler
    dataTable7 = dataTable7.carts
    dataTable7 = dataTable7[A0_2]
    dataTable7 = dataTable7.players
    dataTable7 = dataTable7[A1_2]
    dataTable7.taken = A2_2
    if false == A2_2 then
        if nil ~= A3_2 then
            isEnabled9 = GetPlayerFromServerId
            playerPed = A3_2
            isEnabled9 = isEnabled9(playerPed)
            if -1 ~= isEnabled9 then
                playerPed = GetPlayerPed
                isEnabled2 = isEnabled9
                playerPed = playerPed(isEnabled2)
                isEnabled2 = DoesEntityExist
                isDisabled6 = playerPed
                isEnabled2 = isEnabled2(isDisabled6)
                if isEnabled2 then
                    isEnabled2 = DetachEntity
                    isDisabled6 = playerPed
                    isEnabled2(isDisabled6)
                    isEnabled2 = ClearPedTasks
                    isDisabled6 = playerPed
                    isEnabled2(isDisabled6)
                    isEnabled2 = FreezeEntityPosition
                    isDisabled6 = playerPed
                    isEnabled7 = false
                    isEnabled2(isDisabled6, isEnabled7)
                end
            end
        end
    else
        isEnabled9 = GetPlayerFromServerId
        playerPed = A3_2
        isEnabled9 = isEnabled9(playerPed)
        if -1 ~= isEnabled9 then
            playerPed = GetPlayerPed
            isEnabled2 = isEnabled9
            playerPed = playerPed(isEnabled2)
            isEnabled2 = DoesEntityExist
            isDisabled6 = playerPed
            isEnabled2 = isEnabled2(isDisabled6)
            if isEnabled2 then
                isEnabled2 = FreezeEntityPosition
                isDisabled6 = playerPed
                isEnabled7 = true
                isEnabled2(isDisabled6, isEnabled7)
                isEnabled2 = NetworkAllowLocalEntityAttachment
                isDisabled6 = playerPed
                isEnabled7 = true
                isEnabled2(isDisabled6, isEnabled7)
                isEnabled2 = AttachEntityToEntity
                isDisabled6 = playerPed
                isEnabled7 = dataTable9.handler
                isEnabled10 = 0
                isEnabled11 = dataTable7.seatoffsets
                isEnabled11 = isEnabled11.x
                isEnabled6 = dataTable7.seatoffsets
                isEnabled6 = isEnabled6.y
                isEnabled5 = dataTable7.seatoffsets
                isEnabled5 = isEnabled5.z
                isDisabled4 = 0.0
                isEnabled3 = 0.0
                condition = -180.0
                isDisabled5 = false
                isDisabled2 = false
                isEnabled4 = true
                isDisabled8 = false
                var2 = 2
                isEnabled = true
                isEnabled2(isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6, isEnabled5, isDisabled4, isEnabled3, condition, isDisabled5, isDisabled2, isEnabled4, isDisabled8, var2, isEnabled)
                isEnabled2 = "anim@mp_rollarcoaster"
                isDisabled6 = "safety_bar_grip_move_a_player_"
                isEnabled7 = dataTable7.seatcategory
                isEnabled10 = ""
                isDisabled6 = isDisabled6 .. isEnabled7 .. isEnabled10
                if 2 == A4_2 then
                    isEnabled7 = "hands_up_idle_a_player_"
                    isEnabled10 = dataTable7.seatcategory
                    isEnabled11 = ""
                    isEnabled7 = isEnabled7 .. isEnabled10 .. isEnabled11
                    isDisabled6 = isEnabled7
                end
                while true do
                    isEnabled7 = HasAnimDictLoaded
                    isEnabled10 = isEnabled2
                    isEnabled7 = isEnabled7(isEnabled10)
                    if isEnabled7 then
                        break
                    end
                    isEnabled7 = RequestAnimDict
                    isEnabled10 = isEnabled2
                    isEnabled7(isEnabled10)
                    isEnabled7 = Citizen
                    isEnabled7 = isEnabled7.Wait
                    isEnabled10 = 5
                    isEnabled7(isEnabled10)
                end
                isEnabled7 = TaskPlayAnim
                isEnabled10 = playerPed
                isEnabled11 = isEnabled2
                isEnabled6 = isDisabled6
                isEnabled5 = 8.0
                isDisabled4 = 8.0
                isEnabled3 = -1
                condition = 1
                isDisabled5 = 0
                isDisabled2 = 0
                isEnabled4 = 0
                isDisabled8 = 0
                isEnabled7(isEnabled10, isEnabled11, isEnabled6, isEnabled5, isDisabled4, isEnabled3, condition, isDisabled5, isDisabled2, isEnabled4, isDisabled8)
            end
        end
    end
end
dataTable6(dataTable8, dataTable4)
dataTable6 = RegisterNetEvent
dataTable8 = "rtx_themepark:Rollercoaster:AttractionEnded"
dataTable6(dataTable8)
dataTable6 = AddEventHandler
dataTable8 = "rtx_themepark:Rollercoaster:AttractionEnded"

function dataTable4()
    local numValue, isEnabled8, dataTable10, dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2
    numValue = 1
    isEnabled8 = rollercoasterpaths
    dataTable10 = true
    isDisabled3 = dataTable10
    dataTable10 = DoesEntityExist
    dataTable = rollercoasterhandler
    dataTable = dataTable.carts
    dataTable = dataTable[1]
    dataTable = dataTable.handler
    dataTable10 = dataTable10(dataTable)
    if dataTable10 then
        dataTable10 = SetEntityCoordsNoOffset
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[1]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[1]
        dataTable3 = dataTable3.coords
        dataTable3 = dataTable3.x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[1]
        dataTable9 = dataTable9.coords
        dataTable9 = dataTable9.y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[1]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.z
        isEnabled9 = true
        playerPed = false
        isEnabled2 = false
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable10 = SetEntityQuaternion
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[1]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[1]
        dataTable3 = dataTable3.r1objectscoords1x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[1]
        dataTable9 = dataTable9.r1objectscoords1y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[1]
        dataTable7 = dataTable7.r1objectscoords1z
        isEnabled9 = isEnabled8[numValue]
        isEnabled9 = isEnabled9[1]
        isEnabled9 = isEnabled9.r1objectscoords1w
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9)
    end
    dataTable10 = DoesEntityExist
    dataTable = rollercoasterhandler
    dataTable = dataTable.carts
    dataTable = dataTable[2]
    dataTable = dataTable.handler
    dataTable10 = dataTable10(dataTable)
    if dataTable10 then
        dataTable10 = SetEntityCoordsNoOffset
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[2]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[2]
        dataTable3 = dataTable3.coords
        dataTable3 = dataTable3.x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[2]
        dataTable9 = dataTable9.coords
        dataTable9 = dataTable9.y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[2]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.z
        isEnabled9 = true
        playerPed = false
        isEnabled2 = false
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable10 = SetEntityQuaternion
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[2]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[2]
        dataTable3 = dataTable3.r2objectscoords1x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[2]
        dataTable9 = dataTable9.r2objectscoords1y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[2]
        dataTable7 = dataTable7.r2objectscoords1z
        isEnabled9 = isEnabled8[numValue]
        isEnabled9 = isEnabled9[2]
        isEnabled9 = isEnabled9.r2objectscoords1w
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9)
    end
    dataTable10 = DoesEntityExist
    dataTable = rollercoasterhandler
    dataTable = dataTable.carts
    dataTable = dataTable[3]
    dataTable = dataTable.handler
    dataTable10 = dataTable10(dataTable)
    if dataTable10 then
        dataTable10 = SetEntityCoordsNoOffset
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[3]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[3]
        dataTable3 = dataTable3.coords
        dataTable3 = dataTable3.x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[3]
        dataTable9 = dataTable9.coords
        dataTable9 = dataTable9.y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[3]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.z
        isEnabled9 = true
        playerPed = false
        isEnabled2 = false
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable10 = SetEntityQuaternion
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[3]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[3]
        dataTable3 = dataTable3.r3objectscoords1x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[3]
        dataTable9 = dataTable9.r3objectscoords1y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[3]
        dataTable7 = dataTable7.r3objectscoords1z
        isEnabled9 = isEnabled8[numValue]
        isEnabled9 = isEnabled9[3]
        isEnabled9 = isEnabled9.r3objectscoords1w
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9)
    end
    dataTable10 = DoesEntityExist
    dataTable = rollercoasterhandler
    dataTable = dataTable.carts
    dataTable = dataTable[4]
    dataTable = dataTable.handler
    dataTable10 = dataTable10(dataTable)
    if dataTable10 then
        dataTable10 = SetEntityCoordsNoOffset
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[4]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[4]
        dataTable3 = dataTable3.coords
        dataTable3 = dataTable3.x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[4]
        dataTable9 = dataTable9.coords
        dataTable9 = dataTable9.y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[4]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.z
        isEnabled9 = true
        playerPed = false
        isEnabled2 = false
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable10 = SetEntityQuaternion
        dataTable = rollercoasterhandler
        dataTable = dataTable.carts
        dataTable = dataTable[4]
        dataTable = dataTable.handler
        dataTable3 = isEnabled8[numValue]
        dataTable3 = dataTable3[4]
        dataTable3 = dataTable3.r4objectscoords1x
        dataTable9 = isEnabled8[numValue]
        dataTable9 = dataTable9[4]
        dataTable9 = dataTable9.r4objectscoords1y
        dataTable7 = isEnabled8[numValue]
        dataTable7 = dataTable7[4]
        dataTable7 = dataTable7.r4objectscoords1z
        isEnabled9 = isEnabled8[numValue]
        isEnabled9 = isEnabled9[4]
        isEnabled9 = isEnabled9.r4objectscoords1w
        dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9)
    end
    dataTable10 = Config
    dataTable10 = dataTable10.AttractionsSettings
    dataTable10 = dataTable10.rollercoaster
    dataTable10 = dataTable10.soundeffect
    if true == dataTable10 then
        dataTable10 = StopStream
        dataTable10()
    end
end
dataTable6(dataTable8, dataTable4)
dataTable6 = RegisterNetEvent
dataTable8 = "rtx_themepark:Rollercoaster:StartAttraction"
dataTable6(dataTable8)
dataTable6 = AddEventHandler
dataTable8 = "rtx_themepark:Rollercoaster:StartAttraction"

function dataTable4(A0_2, A1_2)
    local dataTable10, dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6
    dataTable10 = nearbythemepark
    if true == dataTable10 then
        dataTable10 = Config
        dataTable10 = dataTable10.AttractionsSettings
        dataTable10 = dataTable10.rollercoaster
        dataTable10 = dataTable10.soundeffect
        if true == dataTable10 then
            dataTable10 = var1
            if nil ~= dataTable10 then
                dataTable10 = var12
                if nil ~= dataTable10 then
                    dataTable10 = LoadStreamWithStartOffset
                    dataTable = "Player_Ride"
                    dataTable3 = 0
                    dataTable9 = "DLC_IND_ROLLERCOASTER_SOUNDS"
                    dataTable10(dataTable, dataTable3, dataTable9)
                    dataTable10 = PlayStreamFromPed
                    dataTable = PlayerPedId
                    dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6 = dataTable()
                    dataTable10(dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                end
            else
                dataTable10 = LoadStreamWithStartOffset
                dataTable = "Ambient_Ride"
                dataTable3 = 0
                dataTable9 = "DLC_IND_ROLLERCOASTER_SOUNDS"
                dataTable10(dataTable, dataTable3, dataTable9)
                dataTable10 = PlayStreamFromObject
                dataTable = rollercoasterhandler
                dataTable = dataTable.carts
                dataTable = dataTable[1]
                dataTable = dataTable.handler
                dataTable10(dataTable)
            end
        end
        dataTable10 = A1_2
        dataTable = rollercoasterpaths
        dataTable = #dataTable
        if dataTable10 > dataTable then
            dataTable = rollercoasterpaths
            dataTable10 = #dataTable
            dataTable = Config
            dataTable = dataTable.AttractionsSettings
            dataTable = dataTable.rollercoaster
            dataTable = dataTable.soundeffect
            if true == dataTable then
                dataTable = StopStream
                dataTable()
            end
        end
        rollercoastercalculateid = A0_2
        dataTable = rollercoastercalculateid
        dataTable3 = rollercoasterpaths
        dataTable3 = #dataTable3
        if dataTable > dataTable3 then
            dataTable = rollercoasterpaths
            dataTable = #dataTable
            rollercoastercalculateid = dataTable
        end
        dataTable = rollercoasterpaths
        dataTable3 = rollercoasterhandler
        dataTable3.getnew = true
        dataTable3 = rollercoasterhandler
        dataTable9 = rollercoastercalculateid
        dataTable3.stageid = dataTable9
        dataTable3 = SetEntityCoordsNoOffset
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[1]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[1]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[1]
        isEnabled9 = isEnabled9.coords
        isEnabled9 = isEnabled9.y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[1]
        playerPed = playerPed.coords
        playerPed = playerPed.z
        isEnabled2 = true
        isDisabled6 = false
        isEnabled7 = false
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7)
        dataTable3 = SetEntityQuaternion
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[1]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[1]
        dataTable7 = dataTable7.r1objectscoords1x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[1]
        isEnabled9 = isEnabled9.r1objectscoords1y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[1]
        playerPed = playerPed.r1objectscoords1z
        isEnabled2 = rollercoasterhandler
        isEnabled2 = isEnabled2.stageid
        isEnabled2 = dataTable[isEnabled2]
        isEnabled2 = isEnabled2[1]
        isEnabled2 = isEnabled2.r1objectscoords1w
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable3 = SetEntityCoordsNoOffset
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[2]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[2]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[2]
        isEnabled9 = isEnabled9.coords
        isEnabled9 = isEnabled9.y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[2]
        playerPed = playerPed.coords
        playerPed = playerPed.z
        isEnabled2 = true
        isDisabled6 = false
        isEnabled7 = false
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7)
        dataTable3 = SetEntityQuaternion
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[2]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[2]
        dataTable7 = dataTable7.r2objectscoords1x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[2]
        isEnabled9 = isEnabled9.r2objectscoords1y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[2]
        playerPed = playerPed.r2objectscoords1z
        isEnabled2 = rollercoasterhandler
        isEnabled2 = isEnabled2.stageid
        isEnabled2 = dataTable[isEnabled2]
        isEnabled2 = isEnabled2[2]
        isEnabled2 = isEnabled2.r2objectscoords1w
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable3 = SetEntityCoordsNoOffset
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[3]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[3]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[3]
        isEnabled9 = isEnabled9.coords
        isEnabled9 = isEnabled9.y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[3]
        playerPed = playerPed.coords
        playerPed = playerPed.z
        isEnabled2 = true
        isDisabled6 = false
        isEnabled7 = false
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7)
        dataTable3 = SetEntityQuaternion
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[3]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[3]
        dataTable7 = dataTable7.r3objectscoords1x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[3]
        isEnabled9 = isEnabled9.r3objectscoords1y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[3]
        playerPed = playerPed.r3objectscoords1z
        isEnabled2 = rollercoasterhandler
        isEnabled2 = isEnabled2.stageid
        isEnabled2 = dataTable[isEnabled2]
        isEnabled2 = isEnabled2[3]
        isEnabled2 = isEnabled2.r3objectscoords1w
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable3 = SetEntityCoordsNoOffset
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[4]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[4]
        dataTable7 = dataTable7.coords
        dataTable7 = dataTable7.x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[4]
        isEnabled9 = isEnabled9.coords
        isEnabled9 = isEnabled9.y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[4]
        playerPed = playerPed.coords
        playerPed = playerPed.z
        isEnabled2 = true
        isDisabled6 = false
        isEnabled7 = false
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7)
        dataTable3 = SetEntityQuaternion
        dataTable9 = rollercoasterhandler
        dataTable9 = dataTable9.carts
        dataTable9 = dataTable9[4]
        dataTable9 = dataTable9.handler
        dataTable7 = rollercoasterhandler
        dataTable7 = dataTable7.stageid
        dataTable7 = dataTable[dataTable7]
        dataTable7 = dataTable7[4]
        dataTable7 = dataTable7.r4objectscoords1x
        isEnabled9 = rollercoasterhandler
        isEnabled9 = isEnabled9.stageid
        isEnabled9 = dataTable[isEnabled9]
        isEnabled9 = isEnabled9[4]
        isEnabled9 = isEnabled9.r4objectscoords1y
        playerPed = rollercoasterhandler
        playerPed = playerPed.stageid
        playerPed = dataTable[playerPed]
        playerPed = playerPed[4]
        playerPed = playerPed.r4objectscoords1z
        isEnabled2 = rollercoasterhandler
        isEnabled2 = isEnabled2.stageid
        isEnabled2 = dataTable[isEnabled2]
        isEnabled2 = isEnabled2[4]
        isEnabled2 = isEnabled2.r4objectscoords1w
        dataTable3(dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2)
        dataTable3 = Citizen
        dataTable3 = dataTable3.Wait
        dataTable9 = 1
        dataTable3(dataTable9)
        dataTable3 = rollercoasterhandler
        dataTable3.getnew = false
        dataTable3 = rollercoasterpaths
        dataTable3 = #dataTable3
        dataTable9 = 1
        dataTable7 = currentfps
        if dataTable7 < 80 then
            dataTable9 = 0
        else
            dataTable9 = 1
        end
        while true do
            dataTable7 = rollercoasterhandler
            dataTable7 = dataTable7.getnew
            if false ~= dataTable7 then
                break
            end
            dataTable7 = nearbythemepark
            if true ~= dataTable7 then
                break
            end
            dataTable7 = isDisabled3
            if false ~= dataTable7 then
                break
            end
            dataTable7 = Citizen
            dataTable7 = dataTable7.Wait
            isEnabled9 = dataTable9
            dataTable7(isEnabled9)
            dataTable7 = rollercoasterhandler
            dataTable7 = dataTable7.stageid
            dataTable7 = dataTable[dataTable7]
            dataTable7 = dataTable7[1]
            dataTable7 = dataTable7.coords
            isEnabled9 = dataTable[dataTable10]
            isEnabled9 = isEnabled9[1]
            isEnabled9 = isEnabled9.coords
            dataTable7 = dataTable7 - isEnabled9
            dataTable7 = #dataTable7
            if dataTable7 > 0.0 then
                isEnabled9 = rollercoasterhandler
                playerPed = rollercoasterhandler
                playerPed = playerPed.stageid
                playerPed = playerPed + 1
                isEnabled9.stageid = playerPed
                isEnabled9 = rollercoasterhandler
                isEnabled9 = isEnabled9.getnew
                if false == isEnabled9 then
                    isEnabled9 = rollercoasterhandler
                    isEnabled9 = isEnabled9.stageid
                    if isEnabled9 == dataTable3 then
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[1]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[1]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[1]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[1]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[1]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[1]
                        isEnabled2 = isEnabled2.r1objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[1]
                        isDisabled6 = isDisabled6.r1objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[1]
                        isEnabled7 = isEnabled7.r1objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[1]
                        isEnabled10 = isEnabled10.r1objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[2]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[2]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[2]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[2]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[2]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[2]
                        isEnabled2 = isEnabled2.r2objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[2]
                        isDisabled6 = isDisabled6.r2objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[2]
                        isEnabled7 = isEnabled7.r2objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[2]
                        isEnabled10 = isEnabled10.r2objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[3]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[3]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[3]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[3]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[3]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[3]
                        isEnabled2 = isEnabled2.r3objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[3]
                        isDisabled6 = isDisabled6.r3objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[3]
                        isEnabled7 = isEnabled7.r3objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[3]
                        isEnabled10 = isEnabled10.r3objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[4]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[4]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[4]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[4]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[4]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[4]
                        isEnabled2 = isEnabled2.r4objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[4]
                        isDisabled6 = isDisabled6.r4objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[4]
                        isEnabled7 = isEnabled7.r4objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[4]
                        isEnabled10 = isEnabled10.r4objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                        isEnabled9 = rollercoasterhandler
                        isEnabled9.getnew = true
                    else
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[1]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[1]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[1]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[1]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[1]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[1]
                        isEnabled2 = isEnabled2.r1objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[1]
                        isDisabled6 = isDisabled6.r1objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[1]
                        isEnabled7 = isEnabled7.r1objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[1]
                        isEnabled10 = isEnabled10.r1objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[2]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[2]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[2]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[2]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[2]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[2]
                        isEnabled2 = isEnabled2.r2objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[2]
                        isDisabled6 = isDisabled6.r2objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[2]
                        isEnabled7 = isEnabled7.r2objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[2]
                        isEnabled10 = isEnabled10.r2objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[3]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[3]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[3]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[3]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[3]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[3]
                        isEnabled2 = isEnabled2.r3objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[3]
                        isDisabled6 = isDisabled6.r3objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[3]
                        isEnabled7 = isEnabled7.r3objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[3]
                        isEnabled10 = isEnabled10.r3objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                        isEnabled9 = SetEntityCoordsNoOffset
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[4]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[4]
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[4]
                        isDisabled6 = isDisabled6.coords
                        isDisabled6 = isDisabled6.y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[4]
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.z
                        isEnabled10 = true
                        isEnabled11 = false
                        isEnabled6 = false
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                        isEnabled9 = SetEntityQuaternion
                        playerPed = rollercoasterhandler
                        playerPed = playerPed.carts
                        playerPed = playerPed[4]
                        playerPed = playerPed.handler
                        isEnabled2 = rollercoasterhandler
                        isEnabled2 = isEnabled2.stageid
                        isEnabled2 = dataTable[isEnabled2]
                        isEnabled2 = isEnabled2[4]
                        isEnabled2 = isEnabled2.r4objectscoords1x
                        isDisabled6 = rollercoasterhandler
                        isDisabled6 = isDisabled6.stageid
                        isDisabled6 = dataTable[isDisabled6]
                        isDisabled6 = isDisabled6[4]
                        isDisabled6 = isDisabled6.r4objectscoords1y
                        isEnabled7 = rollercoasterhandler
                        isEnabled7 = isEnabled7.stageid
                        isEnabled7 = dataTable[isEnabled7]
                        isEnabled7 = isEnabled7[4]
                        isEnabled7 = isEnabled7.r4objectscoords1z
                        isEnabled10 = rollercoasterhandler
                        isEnabled10 = isEnabled10.stageid
                        isEnabled10 = dataTable[isEnabled10]
                        isEnabled10 = isEnabled10[4]
                        isEnabled10 = isEnabled10.r4objectscoords1w
                        isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10)
                    end
                end
            else
                isEnabled9 = Config
                isEnabled9 = isEnabled9.AttractionsSettings
                isEnabled9 = isEnabled9.rollercoaster
                isEnabled9 = isEnabled9.speedmodifier
                isEnabled9 = 8 * isEnabled9
                A1_2 = A1_2 + isEnabled9
            end
        end
    else
        dataTable10 = rollercoasterhandler
        dataTable10.getnew = true
    end
end
dataTable6(dataTable8, dataTable4)
dataTable6 = RegisterNetEvent
dataTable8 = "rtx_themepark:Rollercoaster:SeatData"
dataTable6(dataTable8)
dataTable6 = AddEventHandler
dataTable8 = "rtx_themepark:Rollercoaster:SeatData"

function dataTable4(A0_2, A1_2)
    local dataTable10, dataTable
    dataTable10 = SendNUIMessage
    dataTable = {}
    dataTable.message = "attractionhow"
    dataTable.attractionanimchange = true
    dataTable10(dataTable)
    var1 = A0_2
    var12 = A1_2
    dataTable10 = true
    isDisabled = dataTable10
    dataTable10 = Config
    dataTable10 = dataTable10.ThemeParkFallSettings
    dataTable10 = dataTable10.fallchancecheck
    counter3 = dataTable10
end
dataTable6(dataTable8, dataTable4)
dataTable6 = RegisterNetEvent
dataTable8 = "rtx_themepark:Rollercoaster:SeatExit"
dataTable6(dataTable8)
dataTable6 = AddEventHandler
dataTable8 = "rtx_themepark:Rollercoaster:SeatExit"

function dataTable4()
    local numValue, isEnabled8, dataTable10, dataTable, dataTable3, dataTable9, dataTable7, isEnabled9
    numValue = rollercoasterhandler
    numValue = numValue.carts
    isEnabled8 = var1
    numValue = numValue[isEnabled8]
    isEnabled8 = rollercoasterhandler
    isEnabled8 = isEnabled8.carts
    dataTable10 = var1
    isEnabled8 = isEnabled8[dataTable10]
    isEnabled8 = isEnabled8.players
    dataTable10 = var12
    isEnabled8 = isEnabled8[dataTable10]
    dataTable10 = PlayerPedId
    dataTable10 = dataTable10()
    dataTable = DetachEntity
    dataTable3 = dataTable10
    dataTable(dataTable3)
    dataTable = SetEntityCoordsNoOffset
    dataTable3 = dataTable10
    dataTable9 = isEnabled8.seatend
    dataTable9 = dataTable9.x
    dataTable7 = isEnabled8.seatend
    dataTable7 = dataTable7.y
    isEnabled9 = isEnabled8.seatend
    isEnabled9 = isEnabled9.z
    dataTable(dataTable3, dataTable9, dataTable7, isEnabled9)
    dataTable = SetEntityHeading
    dataTable3 = dataTable10
    dataTable9 = 315.0
    dataTable(dataTable3, dataTable9)
    dataTable = FreezeEntityPosition
    dataTable3 = dataTable10
    dataTable9 = false
    dataTable(dataTable3, dataTable9)
    dataTable = ClearPedTasks
    dataTable3 = dataTable10
    dataTable(dataTable3)
    dataTable = SendNUIMessage
    dataTable3 = {}
    dataTable3.message = "hideattraction"
    dataTable(dataTable3)
    dataTable = nil
    var1 = dataTable
    dataTable = nil
    var12 = dataTable
    dataTable = Config
    dataTable = dataTable.AttractionsSettings
    dataTable = dataTable.rollercoaster
    dataTable = dataTable.soundeffect
    if true == dataTable then
        dataTable = StopStream
        dataTable()
    end
    dataTable = false
    isDisabled = dataTable
end
dataTable6(dataTable8, dataTable4)
dataTable6 = Config
dataTable6 = dataTable6.ThemeParkAttractionFallChance
if dataTable6 then
    dataTable6 = Config
    dataTable6 = dataTable6.ThemeParkFallSettings
    dataTable6 = dataTable6.attractions
    dataTable6 = dataTable6.rollercoaster
    if dataTable6 then
        dataTable6 = RegisterNetEvent
        dataTable8 = "rtx_themepark:Rollercoaster:SeatThrowClient"
        dataTable6(dataTable8)
        dataTable6 = AddEventHandler
        dataTable8 = "rtx_themepark:Rollercoaster:SeatThrowClient"

        function dataTable4()
            local numValue, isEnabled8, dataTable10, dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6, isEnabled5, isDisabled4, isEnabled3
            numValue = var1
            if nil ~= numValue then
                numValue = var12
                if nil ~= numValue then
                    numValue = PlayerPedId
                    numValue = numValue()
                    isEnabled8 = DetachEntity
                    dataTable10 = numValue
                    isEnabled8(dataTable10)
                    isEnabled8 = FreezeEntityPosition
                    dataTable10 = numValue
                    dataTable = false
                    isEnabled8(dataTable10, dataTable)
                    isEnabled8 = ClearPedTasks
                    dataTable10 = numValue
                    isEnabled8(dataTable10)
                    isEnabled8 = SendNUIMessage
                    dataTable10 = {}
                    dataTable10.message = "hideattraction"
                    isEnabled8(dataTable10)
                    isEnabled8 = nil
                    var1 = isEnabled8
                    isEnabled8 = nil
                    var12 = isEnabled8
                    usingattraction = false
                    isEnabled8 = GetEntityForwardVector
                    dataTable10 = numValue
                    isEnabled8 = isEnabled8(dataTable10)
                    dataTable10 = math
                    dataTable10 = dataTable10.random
                    dataTable10 = dataTable10()
                    dataTable = 5.0
                    dataTable = dataTable - 5.0
                    dataTable10 = dataTable10 * dataTable
                    dataTable10 = 5.0 + dataTable10
                    dataTable = SetPedToRagdoll
                    dataTable3 = numValue
                    dataTable9 = 2000
                    dataTable7 = 2000
                    isEnabled9 = false
                    playerPed = false
                    isEnabled2 = false
                    isDisabled6 = false
                    dataTable(dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6)
                    dataTable = ApplyForceToEntity
                    dataTable3 = numValue
                    dataTable9 = 1
                    dataTable7 = isEnabled8.x
                    dataTable7 = dataTable7 * dataTable10
                    isEnabled9 = isEnabled8.y
                    isEnabled9 = isEnabled9 * dataTable10
                    playerPed = isEnabled8.z
                    playerPed = playerPed + 5.0
                    isEnabled2 = 0
                    isDisabled6 = 0
                    isEnabled7 = 0
                    isEnabled10 = 0
                    isEnabled11 = false
                    isEnabled6 = true
                    isEnabled5 = true
                    isDisabled4 = false
                    isEnabled3 = true
                    dataTable(dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6, isEnabled5, isDisabled4, isEnabled3)
                    dataTable = Config
                    dataTable = dataTable.AttractionsSettings
                    dataTable = dataTable.rollercoaster
                    dataTable = dataTable.soundeffect
                    if true == dataTable then
                        dataTable = StopStream
                        dataTable()
                    end
                    dataTable = Notify
                    dataTable3 = Language
                    dataTable9 = Config
                    dataTable9 = dataTable9.Language
                    dataTable3 = dataTable3[dataTable9]
                    dataTable3 = dataTable3.themeparkfall
                    dataTable(dataTable3)
                end
            end
        end
        dataTable6(dataTable8, dataTable4)
    end
end
dataTable6 = Config
dataTable6 = dataTable6.Target
if true == dataTable6 then
    dataTable6 = RegisterNetEvent
    dataTable8 = "rtx_themepark:Rollercoaster:SeatTarget"
    dataTable6(dataTable8)
    dataTable6 = AddEventHandler
    dataTable8 = "rtx_themepark:Rollercoaster:SeatTarget"

    function dataTable4()
        local numValue, isEnabled8, dataTable10, dataTable
        numValue = rollercoasterhandler
        numValue = numValue.started
        if false == numValue then
            numValue = usingattraction
            if false == numValue then
                numValue = dataTable2.cartid
                if nil ~= numValue then
                    numValue = dataTable2.seatid
                    if nil ~= numValue then
                        numValue = iteminhand
                        if false == numValue then
                            numValue = TriggerServerEvent
                            isEnabled8 = "rtx_themepark:Rollercoaster:SeatUse"
                            dataTable10 = dataTable2.cartid
                            dataTable = dataTable2.seatid
                            numValue(isEnabled8, dataTable10, dataTable)
                        else
                            numValue = Notify
                            isEnabled8 = Language
                            dataTable10 = Config
                            dataTable10 = dataTable10.Language
                            isEnabled8 = isEnabled8[dataTable10]
                            isEnabled8 = isEnabled8.iteminhand
                            numValue(isEnabled8)
                        end
                    end
                end
            end
        end
    end
    dataTable6(dataTable8, dataTable4)
end
dataTable6 = Citizen
dataTable6 = dataTable6.CreateThread

function dataTable8()
    local numValue, isEnabled8, dataTable10, dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6
    while true do
        numValue = Citizen
        numValue = numValue.Wait
        isEnabled8 = 1000
        numValue(isEnabled8)
        numValue = nearbythemepark
        if true == numValue then
            numValue = ipairs
            isEnabled8 = rollercoasterhandler
            isEnabled8 = isEnabled8.carts
            numValue, isEnabled8, dataTable10, dataTable = numValue(isEnabled8)
            for dataTable3, dataTable9 in numValue, isEnabled8, dataTable10, dataTable do
                dataTable7 = DoesEntityExist
                isEnabled9 = dataTable9.handler
                dataTable7 = dataTable7(isEnabled9)
                if dataTable7 then
                    dataTable7 = FreezeEntityPosition
                    isEnabled9 = dataTable9.handler
                    playerPed = true
                    dataTable7(isEnabled9, playerPed)
                else
                    dataTable7 = dataTable9.object
                    isEnabled9 = RequestModel
                    playerPed = dataTable7
                    isEnabled9(playerPed)
                    while true do
                        isEnabled9 = HasModelLoaded
                        playerPed = dataTable7
                        isEnabled9 = isEnabled9(playerPed)
                        if isEnabled9 then
                            break
                        end
                        isEnabled9 = RequestModel
                        playerPed = dataTable7
                        isEnabled9(playerPed)
                        isEnabled9 = Citizen
                        isEnabled9 = isEnabled9.Wait
                        playerPed = 5
                        isEnabled9(playerPed)
                    end
                    isEnabled9 = CreateObjectNoOffset
                    playerPed = dataTable7
                    isEnabled2 = dataTable9.coords
                    isEnabled2 = isEnabled2.x
                    isDisabled6 = dataTable9.coords
                    isDisabled6 = isDisabled6.y
                    isEnabled7 = dataTable9.coords
                    isEnabled7 = isEnabled7.z
                    isEnabled10 = false
                    isEnabled11 = true
                    isEnabled6 = true
                    isEnabled9 = isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6)
                    dataTable9.handler = isEnabled9
                    isEnabled9 = SetEntityRotation
                    playerPed = dataTable9.handler
                    isEnabled2 = dataTable9.rotation
                    isEnabled2 = isEnabled2.x
                    isDisabled6 = dataTable9.rotation
                    isDisabled6 = isDisabled6.y
                    isEnabled7 = dataTable9.rotation
                    isEnabled7 = isEnabled7.z
                    isEnabled9(playerPed, isEnabled2, isDisabled6, isEnabled7)
                    isEnabled9 = NetworkAllowLocalEntityAttachment
                    playerPed = dataTable9.handler
                    isEnabled2 = true
                    isEnabled9(playerPed, isEnabled2)
                    isEnabled9 = FreezeEntityPosition
                    playerPed = dataTable9.handler
                    isEnabled2 = true
                    isEnabled9(playerPed, isEnabled2)
                end
            end
        end
    end
end
dataTable6(dataTable8)
dataTable6 = -1
dataTable8 = Citizen
dataTable8 = dataTable8.CreateThread

function dataTable4()
    local numValue, isEnabled8, dataTable10, dataTable
    while true do
        numValue = Citizen
        numValue = numValue.Wait
        isEnabled8 = 0
        numValue(isEnabled8)
        numValue = GlobalState
        numValue = numValue["attraction8 - phase"]
        if 0 ~= numValue then
            numValue = nearbythemepark
            if false ~= numValue then
                goto lbl_21
            end
        end
        numValue = Citizen
        numValue = numValue.Wait
        isEnabled8 = 500
        numValue(isEnabled8)
        numValue = rollercoasterhandler
        numValue.getnew = true
        numValue = -1
        dataTable6 = numValue
        goto lbl_41
        ::lbl_21::
        numValue = dataTable6
        if -1 ~= numValue then
            numValue = dataTable6
            isEnabled8 = GlobalState
            isEnabled8 = isEnabled8["attraction8 - synchdata"]
            if not (numValue < isEnabled8) then
                goto lbl_41
            end
        end
        numValue = tonumber
        isEnabled8 = GlobalState
        isEnabled8 = isEnabled8["attraction8 - synchdata"]
        numValue = numValue(isEnabled8)
        dataTable6 = numValue
        numValue = TriggerEvent
        isEnabled8 = "rtx_themepark:Rollercoaster:StartAttraction"
        dataTable10 = GlobalState
        dataTable10 = dataTable10["attraction8 - ridedata1"]
        dataTable = GlobalState
        dataTable = dataTable["attraction8 - ridedata2"]
        numValue(isEnabled8, dataTable10, dataTable)
        ::lbl_41::
    end
end
dataTable8(dataTable4)
dataTable8 = Config
dataTable8 = dataTable8.AttractionsSettings
dataTable8 = dataTable8.rollercoaster
dataTable8 = dataTable8.disable
if false == dataTable8 then
    dataTable8 = Citizen
    dataTable8 = dataTable8.CreateThread

    function dataTable4()
        local numValue, isEnabled8, dataTable10, dataTable, dataTable3, dataTable9, dataTable7, isEnabled9, playerPed, isEnabled2, isDisabled6, isEnabled7, isEnabled10, isEnabled11, isEnabled6, isEnabled5, isDisabled4, isEnabled3, condition, isDisabled5
        while true do
            numValue = Citizen
            numValue = numValue.Wait
            isEnabled8 = 0
            numValue(isEnabled8)
            numValue = true
            isEnabled8 = false
            dataTable10 = -1
            dataTable = {}
            dataTable.cartid = nil
            dataTable.seatid = nil
            dataTable.platformid = nil
            dataTable3 = nearbythemepark
            if true == dataTable3 then
                dataTable3 = tickets
                dataTable3 = dataTable3.rollercoaster
                if true == dataTable3 then
                    dataTable3 = rollercoasterhandler
                    dataTable3 = dataTable3.started
                    if false == dataTable3 then
                        dataTable3 = ipairs
                        dataTable9 = rollercoasterhandler
                        dataTable9 = dataTable9.carts
                        dataTable3, dataTable9, dataTable7, isEnabled9 = dataTable3(dataTable9)
                        for playerPed, isEnabled2 in dataTable3, dataTable9, dataTable7, isEnabled9 do
                            isDisabled6 = ipairs
                            isEnabled7 = isEnabled2.platforms
                            isDisabled6, isEnabled7, isEnabled10, isEnabled11 = isDisabled6(isEnabled7)
                            for isEnabled6, isEnabled5 in isDisabled6, isEnabled7, isEnabled10, isEnabled11 do
                                isDisabled4 = isEnabled2.players
                                isEnabled3 = isEnabled5.seatid1
                                isDisabled4 = isDisabled4[isEnabled3]
                                isEnabled3 = isDisabled4.taken
                                if false == isEnabled3 then
                                    isEnabled3 = playercurrentcoords
                                    condition = isEnabled5.coords
                                    isEnabled3 = isEnabled3 - condition
                                    isEnabled3 = #isEnabled3
                                    if isEnabled3 < 20.0 then
                                        condition = Config
                                        condition = condition.AttractionsSettings
                                        condition = condition.rollercoaster
                                        condition = condition.usedistance
                                        if isEnabled3 < condition and (-1 == dataTable10 or dataTable10 > isEnabled3) then
                                            dataTable10 = isEnabled3
                                            isEnabled8 = true
                                            dataTable.cartid = playerPed
                                            condition = isEnabled5.seatid1
                                            dataTable.seatid = condition
                                            dataTable.platformid = isEnabled6
                                        end
                                    end
                                end
                                isEnabled3 = isEnabled2.players
                                condition = isEnabled5.seatid2
                                isEnabled3 = isEnabled3[condition]
                                condition = isEnabled3.taken
                                if false == condition then
                                    condition = playercurrentcoords
                                    isDisabled5 = isEnabled5.coords
                                    condition = condition - isDisabled5
                                    condition = #condition
                                    if condition < 20.0 then
                                        isDisabled5 = Config
                                        isDisabled5 = isDisabled5.AttractionsSettings
                                        isDisabled5 = isDisabled5.rollercoaster
                                        isDisabled5 = isDisabled5.usedistance
                                        if condition < isDisabled5 and (-1 == dataTable10 or dataTable10 > condition) then
                                            dataTable10 = condition
                                            isEnabled8 = true
                                            dataTable.cartid = playerPed
                                            isDisabled5 = isEnabled5.seatid2
                                            dataTable.seatid = isDisabled5
                                            dataTable.platformid = isEnabled6
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if isEnabled8 then
                    dataTable3 = {}
                    dataTable9 = dataTable.cartid
                    dataTable3.cartid = dataTable9
                    dataTable9 = dataTable.seatid
                    dataTable3.seatid = dataTable9
                    dataTable9 = dataTable.platformid
                    dataTable3.platformid = dataTable9
                    dataTable2 = dataTable3
                    dataTable3 = usingattraction
                    if false == dataTable3 then
                        numValue = false
                        dataTable3 = Config
                        dataTable3 = dataTable3.Target
                        if false == dataTable3 then
                            dataTable3 = rollercoasterhandler
                            dataTable3 = dataTable3.carts
                            dataTable9 = dataTable2.cartid
                            dataTable3 = dataTable3[dataTable9]
                            dataTable3 = dataTable3.platforms
                            dataTable9 = dataTable2.platformid
                            dataTable3 = dataTable3[dataTable9]
                            dataTable9 = Config
                            dataTable9 = dataTable9.ThemeParkInteractionSystem
                            if 1 == dataTable9 then
                                dataTable9 = SendNUIMessage
                                dataTable7 = {}
                                dataTable7.message = "infonotifyshow"
                                isEnabled9 = Language
                                playerPed = Config
                                playerPed = playerPed.Language
                                isEnabled9 = isEnabled9[playerPed]
                                isEnabled9 = isEnabled9.pressforuseseatinteract
                                dataTable7.infonotifytext = isEnabled9
                                dataTable9(dataTable7)
                            else
                                dataTable9 = Config
                                dataTable9 = dataTable9.ThemeParkInteractionSystem
                                if 2 == dataTable9 then
                                    dataTable9 = DrawText3D
                                    dataTable7 = dataTable3.coords
                                    dataTable7 = dataTable7.x
                                    isEnabled9 = dataTable3.coords
                                    isEnabled9 = isEnabled9.y
                                    playerPed = dataTable3.coords
                                    playerPed = playerPed.z
                                    isEnabled2 = Language
                                    isDisabled6 = Config
                                    isDisabled6 = isDisabled6.Language
                                    isEnabled2 = isEnabled2[isDisabled6]
                                    isEnabled2 = isEnabled2.pressforuseseat
                                    dataTable9(dataTable7, isEnabled9, playerPed, isEnabled2)
                                else
                                    dataTable9 = Config
                                    dataTable9 = dataTable9.ThemeParkInteractionSystem
                                    if 3 == dataTable9 then
                                        dataTable9 = ShowGtaClassicInteraction
                                        dataTable7 = Language
                                        isEnabled9 = Config
                                        isEnabled9 = isEnabled9.Language
                                        dataTable7 = dataTable7[isEnabled9]
                                        dataTable7 = dataTable7.pressforuseseatinteractclassic
                                        dataTable9(dataTable7)
                                    end
                                end
                            end
                        end
                    end
                else
                    dataTable3 = Config
                    dataTable3 = dataTable3.ThemeParkInteractionSystem
                    if 1 == dataTable3 then
                        dataTable3 = dataTable2.cartid
                        if nil ~= dataTable3 then
                            dataTable3 = SendNUIMessage
                            dataTable9 = {}
                            dataTable9.message = "hide"
                            dataTable3(dataTable9)
                        end
                    end
                    dataTable3 = {}
                    dataTable3.cartid = nil
                    dataTable3.seatid = nil
                    dataTable3.platformid = nil
                    dataTable2 = dataTable3
                end
            end
            if numValue then
                dataTable3 = Citizen
                dataTable3 = dataTable3.Wait
                dataTable9 = 1000
                dataTable3(dataTable9)
            end
        end
    end
    dataTable8(dataTable4)
end
dataTable8 = Config
dataTable8 = dataTable8.ThemeParkAttractionFallChance
if dataTable8 then
    dataTable8 = Config
    dataTable8 = dataTable8.ThemeParkFallSettings
    dataTable8 = dataTable8.attractions
    dataTable8 = dataTable8.rollercoaster
    if dataTable8 then
        dataTable8 = Citizen
        dataTable8 = dataTable8.CreateThread

        function dataTable4()
            local numValue, isEnabled8, dataTable10, dataTable, dataTable3
            while true do
                numValue = Citizen
                numValue = numValue.Wait
                isEnabled8 = 0
                numValue(isEnabled8)
                numValue = nearbythemepark
                if true == numValue then
                    numValue = var1
                    if nil ~= numValue then
                        numValue = var12
                        if nil ~= numValue then
                            numValue = isDisabled
                            if true == numValue then
                                numValue = rollercoasterhandler
                                numValue = numValue.started
                                if true == numValue then
                                    numValue = counter3
                                    if numValue > 0 then
                                        numValue = counter3
                                        numValue = numValue - 1
                                        counter3 = numValue
                                        numValue = Citizen
                                        numValue = numValue.Wait
                                        isEnabled8 = 1000
                                        numValue(isEnabled8)
                                    else
                                        numValue = Citizen
                                        numValue = numValue.Wait
                                        isEnabled8 = 1000
                                        numValue(isEnabled8)
                                        numValue = math
                                        numValue = numValue.random
                                        isEnabled8 = 1000
                                        numValue = numValue(isEnabled8)
                                        isEnabled8 = Config
                                        isEnabled8 = isEnabled8.ThemeParkFallSettings
                                        isEnabled8 = isEnabled8.fallchance
                                        if numValue <= isEnabled8 then
                                            isEnabled8 = false
                                            isDisabled = isEnabled8
                                            isEnabled8 = usingattraction
                                            if true == isEnabled8 then
                                                isEnabled8 = var1
                                                if nil ~= isEnabled8 then
                                                    isEnabled8 = var12
                                                    if nil ~= isEnabled8 then
                                                        isEnabled8 = TriggerServerEvent
                                                        dataTable10 = "rtx_themepark:Rollercoaster:ThrowAttraction"
                                                        dataTable = var1
                                                        dataTable3 = var12
                                                        isEnabled8(dataTable10, dataTable, dataTable3)
                                                    end
                                                end
                                            end
                                        else
                                            isEnabled8 = Config
                                            isEnabled8 = isEnabled8.ThemeParkFallSettings
                                            isEnabled8 = isEnabled8.fallchancecheck
                                            counter3 = isEnabled8
                                        end
                                    end
                                end
                            end
                        end
                    else
                        numValue = Citizen
                        numValue = numValue.Wait
                        isEnabled8 = 1500
                        numValue(isEnabled8)
                    end
                else
                    numValue = Citizen
                    numValue = numValue.Wait
                    isEnabled8 = 1500
                    numValue(isEnabled8)
                end
            end
        end
        dataTable8(dataTable4)
    end
end
dataTable8 = Config
dataTable8 = dataTable8.Target
if false == dataTable8 then
    dataTable8 = RegisterCommand
    dataTable4 = "userollercoasterseat"

    function coords2()
        local numValue, isEnabled8, dataTable10, dataTable
        numValue = usingattraction
        if false == numValue then
            numValue = dataTable2.cartid
            if nil ~= numValue then
                numValue = dataTable2.seatid
                if nil ~= numValue then
                    numValue = iteminhand
                    if false == numValue then
                        numValue = TriggerServerEvent
                        isEnabled8 = "rtx_themepark:Rollercoaster:SeatUse"
                        dataTable10 = dataTable2.cartid
                        dataTable = dataTable2.seatid
                        numValue(isEnabled8, dataTable10, dataTable)
                    else
                        numValue = Notify
                        isEnabled8 = Language
                        dataTable10 = Config
                        dataTable10 = dataTable10.Language
                        isEnabled8 = isEnabled8[dataTable10]
                        isEnabled8 = isEnabled8.iteminhand
                        numValue(isEnabled8)
                    end
                end
            end
        end
    end
    dataTable8(dataTable4, coords2)
    dataTable8 = RegisterKeyMapping
    dataTable4 = "userollercoasterseat"
    coords2 = Language
    dataTable5 = Config
    dataTable5 = dataTable5.Language
    coords2 = coords2[dataTable5]
    coords2 = coords2.bindrollercoasterseatuse
    dataTable5 = "keyboard"
    coords5 = Config
    coords5 = coords5.ThemeParkSeatKey
    dataTable8(dataTable4, coords2, dataTable5, coords5)
end
dataTable8 = RegisterCommand
dataTable4 = "changerollercoasteranim"

function coords2()
    local numValue, isEnabled8, dataTable10, dataTable
    numValue = usingattraction
    if true == numValue then
        numValue = var1
        if nil ~= numValue then
            numValue = var12
            if nil ~= numValue then
                numValue = isDisabled7
                if false == numValue then
                    numValue = true
                    isDisabled7 = numValue
                    numValue = TriggerServerEvent
                    isEnabled8 = "rtx_themepark:Rollercoaster:SeatAnimChange"
                    dataTable10 = var1
                    dataTable = var12
                    numValue(isEnabled8, dataTable10, dataTable)
                    numValue = Citizen
                    numValue = numValue.Wait
                    isEnabled8 = Config
                    isEnabled8 = isEnabled8.AttractionsSettings
                    isEnabled8 = isEnabled8.rollercoaster
                    isEnabled8 = isEnabled8.animcooldown
                    numValue(isEnabled8)
                    numValue = false
                    isDisabled7 = numValue
                end
            end
        end
    end
end
dataTable8(dataTable4, coords2)
dataTable8 = RegisterKeyMapping
dataTable4 = "changerollercoasteranim"
coords2 = Language
dataTable5 = Config
dataTable5 = dataTable5.Language
coords2 = coords2[dataTable5]
coords2 = coords2.bindrollercoasteranimchange
dataTable5 = "keyboard"
coords5 = Config
coords5 = coords5.ThemeParkAnimChangeKey
dataTable8(dataTable4, coords2, dataTable5, coords5)
dataTable8 = RegisterCommand
dataTable4 = "exitrollercoaster"

function coords2()
    local numValue, isEnabled8, dataTable10, dataTable
    numValue = usingattraction
    if true == numValue then
        numValue = var1
        if nil ~= numValue then
            numValue = var12
            if nil ~= numValue then
                numValue = Config
                numValue = numValue.ThemeParkDisableExit
                if false ~= numValue then
                    numValue = rollercoasterhandler
                    numValue = numValue.started
                    if false ~= numValue then
                        goto lbl_24
                    end
                end
                numValue = TriggerServerEvent
                isEnabled8 = "rtx_themepark:Rollercoaster:ExitAttraction"
                dataTable10 = var1
                dataTable = var12
                numValue(isEnabled8, dataTable10, dataTable)
                goto lbl_31
                ::lbl_24::
                numValue = Notify
                isEnabled8 = Language
                dataTable10 = Config
                dataTable10 = dataTable10.Language
                isEnabled8 = isEnabled8[dataTable10]
                isEnabled8 = isEnabled8.inprogress
                numValue(isEnabled8)
            end
        end
    end
    ::lbl_31::
end
dataTable8(dataTable4, coords2)
dataTable8 = RegisterKeyMapping
dataTable4 = "exitrollercoaster"
coords2 = Language
dataTable5 = Config
dataTable5 = dataTable5.Language
coords2 = coords2[dataTable5]
coords2 = coords2.bindattractionexitkey
dataTable5 = "keyboard"
coords5 = Config
coords5 = coords5.ThemeParkExitKey
dataTable8(dataTable4, coords2, dataTable5, coords5)