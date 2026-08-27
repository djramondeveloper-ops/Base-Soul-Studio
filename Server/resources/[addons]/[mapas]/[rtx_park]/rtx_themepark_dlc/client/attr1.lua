
local dataTable2, var13, var14, isDisabled7, isDisabled2, counter, dataTable8, coords, dataTable7, dataTable5, dataTable3, dataTable6, coords2, counter2, var1, var12
dataTable2 = IsDuplicityVersion
dataTable2 = dataTable2()
if dataTable2 then
    dataTable2 = GetPlayerPositionInRealTime67
    dataTable2()
end
dataTable2 = {}
dataTable2.seatcategoryid = nil
dataTable2.seatid = nil
var13 = nil
var14 = nil
isDisabled7 = false
isDisabled2 = false
counter = 0
dataTable8 = {}
coords = vector3
dataTable7 = -1637.834
dataTable5 = -1078.906
dataTable3 = 41.26547
coords = coords(dataTable7, dataTable5, dataTable3)
dataTable8.coords = coords
dataTable8.mainhandler = nil
dataTable8.animhandler = nil
dataTable8.started = false
dataTable8.changingsides = false
dataTable8.currentrotation = 0.0
dataTable8.seatdown = 1
dataTable8.stageinprogress = false
dataTable8.stage = 0
dataTable8.stagecounter = 0
dataTable8.stagespeed = 0.5
dataTable8.getnew = false
dataTable8.synchronizestop = false
coords = {}
dataTable7 = {}
dataTable7.seathandlermain = nil
dataTable7.animhandler = nil
dataTable5 = {}
dataTable3 = {}
dataTable3.handler = nil
dataTable5[1] = dataTable3
dataTable3 = {}
dataTable3.handler = nil
dataTable5[2] = dataTable3
dataTable7.seathandlercage = dataTable5
dataTable7.cageclosed = false
dataTable5 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = 0.4
var1 = -0.34
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = -90.0
dataTable3.offsets = dataTable6
dataTable5[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = 0.4
var1 = -0.98
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = -90.0
dataTable3.offsets = dataTable6
dataTable5[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = -0.4
var1 = -0.34
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = 90.0
dataTable3.offsets = dataTable6
dataTable5[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = -0.4
var1 = -0.98
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = 90.0
dataTable3.offsets = dataTable6
dataTable5[4] = dataTable3
dataTable7.seats = dataTable5
coords[1] = dataTable7
dataTable7 = {}
dataTable7.seathandlermain = nil
dataTable7.animhandler = nil
dataTable5 = {}
dataTable3 = {}
dataTable3.handler = nil
dataTable5[1] = dataTable3
dataTable3 = {}
dataTable3.handler = nil
dataTable5[2] = dataTable3
dataTable7.seathandlercage = dataTable5
dataTable7.cageclosed = true
dataTable5 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = 0.4
var1 = -0.34
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = -90.0
dataTable3.offsets = dataTable6
dataTable5[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = 0.4
var1 = -0.98
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = -90.0
dataTable3.offsets = dataTable6
dataTable5[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = -0.4
var1 = -0.34
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = 90.0
dataTable3.offsets = dataTable6
dataTable5[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable6 = {}
coords2 = vector3
counter2 = -0.4
var1 = -0.98
var12 = -0.15
coords2 = coords2(counter2, var1, var12)
dataTable6.coords = coords2
dataTable6.heading = 90.0
dataTable3.offsets = dataTable6
dataTable5[4] = dataTable3
dataTable7.seats = dataTable5
coords[2] = dataTable7
dataTable8.seats = coords
gforcehandler = dataTable8
dataTable8 = RegisterNetEvent
coords = "rtx_themepark:GForce:SynchronizeMovement"
dataTable8(coords)
dataTable8 = AddEventHandler
coords = "rtx_themepark:GForce:SynchronizeMovement"

function dataTable7(A0_2, A1_2, A2_2)
    local dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3
    dataTable = nearbythemepark
    if true == dataTable then
        if 13 == A2_2 or 15 == A2_2 or 20 == A2_2 then
            dataTable = gforcehandler
            dataTable.getnew = true
            dataTable = gforcehandler
            dataTable.synchronizestop = false
            dataTable = gforcehandler
            dataTable.currentrotation = A0_2
            dataTable = SetEntityRotation
            dataTable4 = gforcehandler
            dataTable4 = dataTable4.mainhandler
            dataTable9 = 0.0
            hash = A0_2
            isDisabled6 = 230.0
            playerPed = false
            dataTable(dataTable4, dataTable9, hash, isDisabled6, playerPed)
            dataTable = ipairs
            dataTable4 = gforcehandler
            dataTable4 = dataTable4.seats
            dataTable, dataTable4, dataTable9, hash = dataTable(dataTable4)
            for isDisabled6, playerPed in dataTable, dataTable4, dataTable9, hash do
                if 1 == isDisabled6 then
                    isEnabled2 = AttachEntityToEntity
                    isDisabled4 = playerPed.seathandlermain
                    isEnabled9 = gforcehandler
                    isEnabled9 = isEnabled9.mainhandler
                    hash2 = 0
                    isEnabled13 = 0.0
                    isEnabled8 = 0.4
                    isEnabled7 = -26.4
                    isEnabled10 = 0.0
                    isEnabled4 = A0_2
                    isDisabled5 = 0.0
                    isEnabled11 = false
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = 2
                    isEnabled = true
                    isEnabled2(isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled)
                else
                    isEnabled2 = AttachEntityToEntity
                    isDisabled4 = playerPed.seathandlermain
                    isEnabled9 = gforcehandler
                    isEnabled9 = isEnabled9.mainhandler
                    hash2 = 0
                    isEnabled13 = 0.0
                    isEnabled8 = 0.4
                    isEnabled7 = 26.2
                    isEnabled10 = 0.0
                    isEnabled4 = A0_2
                    isDisabled5 = 0.0
                    isEnabled11 = false
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = 2
                    isEnabled = true
                    isEnabled2(isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled)
                end
            end
        else
            dataTable = gforcehandler
            dataTable.getnew = true
            dataTable = SetEntityRotation
            dataTable4 = gforcehandler
            dataTable4 = dataTable4.mainhandler
            dataTable9 = 0.0
            hash = A0_2
            isDisabled6 = 230.0
            playerPed = false
            dataTable(dataTable4, dataTable9, hash, isDisabled6, playerPed)
            dataTable = ipairs
            dataTable4 = gforcehandler
            dataTable4 = dataTable4.seats
            dataTable, dataTable4, dataTable9, hash = dataTable(dataTable4)
            for isDisabled6, playerPed in dataTable, dataTable4, dataTable9, hash do
                if 1 == isDisabled6 then
                    isEnabled2 = AttachEntityToEntity
                    isDisabled4 = playerPed.seathandlermain
                    isEnabled9 = gforcehandler
                    isEnabled9 = isEnabled9.mainhandler
                    hash2 = 0
                    isEnabled13 = 0.0
                    isEnabled8 = 0.4
                    isEnabled7 = -26.4
                    isEnabled10 = 0.0
                    isEnabled4 = A0_2
                    isDisabled5 = 0.0
                    isEnabled11 = false
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = 2
                    isEnabled = true
                    isEnabled2(isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled)
                else
                    isEnabled2 = AttachEntityToEntity
                    isDisabled4 = playerPed.seathandlermain
                    isEnabled9 = gforcehandler
                    isEnabled9 = isEnabled9.mainhandler
                    hash2 = 0
                    isEnabled13 = 0.0
                    isEnabled8 = 0.4
                    isEnabled7 = 26.2
                    isEnabled10 = 0.0
                    isEnabled4 = A0_2
                    isDisabled5 = 0.0
                    isEnabled11 = false
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = 2
                    isEnabled = true
                    isEnabled2(isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled)
                end
            end
            dataTable = gforcehandler
            dataTable.currentrotation = A0_2
            dataTable = Citizen
            dataTable = dataTable.Wait
            dataTable4 = 1
            dataTable(dataTable4)
            dataTable = gforcehandler
            dataTable.getnew = false
            dataTable = gforcehandler
            dataTable.synchronizestop = false
            dataTable = A1_2 * 0.1
            dataTable4 = 1
            dataTable9 = currentfps
            if dataTable9 < 70 then
                dataTable = A1_2 * 0.25
                dataTable4 = 0
            else
                dataTable9 = currentfps
                if dataTable9 < 110 then
                    dataTable = A1_2 * 0.15
                    dataTable4 = 0
                end
            end
            while true do
                dataTable9 = gforcehandler
                dataTable9 = dataTable9.getnew
                if false ~= dataTable9 then
                    break
                end
                dataTable9 = gforcehandler
                dataTable9 = dataTable9.synchronizestop
                if false ~= dataTable9 then
                    break
                end
                dataTable9 = nearbythemepark
                if true ~= dataTable9 then
                    break
                end
                dataTable9 = Citizen
                dataTable9 = dataTable9.Wait
                hash = dataTable4
                dataTable9(hash)
                if 12 == A2_2 then
                    dataTable9 = gforcehandler
                    dataTable9 = dataTable9.currentrotation
                    hash = 179.9
                    if not (dataTable9 < hash) then
                        dataTable9 = gforcehandler
                        dataTable9 = dataTable9.currentrotation
                        hash = 180.1
                        if dataTable9 > hash then
                        else
                            dataTable9 = gforcehandler
                            dataTable9.currentrotation = 180.0
                            dataTable9 = SetEntityRotation
                            hash = gforcehandler
                            hash = hash.mainhandler
                            isDisabled6 = 0.0
                            playerPed = gforcehandler
                            playerPed = playerPed.currentrotation
                            isEnabled2 = 230.0
                            isDisabled4 = false
                            dataTable9(hash, isDisabled6, playerPed, isEnabled2, isDisabled4)
                            dataTable9 = ipairs
                            hash = gforcehandler
                            hash = hash.seats
                            dataTable9, hash, isDisabled6, playerPed = dataTable9(hash)
                            for isEnabled2, isDisabled4 in dataTable9, hash, isDisabled6, playerPed do
                                if 1 == isEnabled2 then
                                    isEnabled9 = AttachEntityToEntity
                                    hash2 = isDisabled4.seathandlermain
                                    isEnabled13 = gforcehandler
                                    isEnabled13 = isEnabled13.mainhandler
                                    isEnabled8 = 0
                                    isEnabled7 = 0.0
                                    isEnabled10 = 0.4
                                    isEnabled4 = -26.4
                                    isDisabled5 = 0.0
                                    isEnabled11 = gforcehandler
                                    isEnabled11 = isEnabled11.currentrotation
                                    isEnabled6 = 0.0
                                    isEnabled5 = false
                                    isEnabled14 = false
                                    isDisabled = false
                                    isEnabled = false
                                    isEnabled15 = 2
                                    isEnabled3 = true
                                    isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                                else
                                    isEnabled9 = AttachEntityToEntity
                                    hash2 = isDisabled4.seathandlermain
                                    isEnabled13 = gforcehandler
                                    isEnabled13 = isEnabled13.mainhandler
                                    isEnabled8 = 0
                                    isEnabled7 = 0.0
                                    isEnabled10 = 0.4
                                    isEnabled4 = 26.2
                                    isDisabled5 = 0.0
                                    isEnabled11 = gforcehandler
                                    isEnabled11 = isEnabled11.currentrotation
                                    isEnabled6 = 0.0
                                    isEnabled5 = false
                                    isEnabled14 = false
                                    isDisabled = false
                                    isEnabled = false
                                    isEnabled15 = 2
                                    isEnabled3 = true
                                    isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                                end
                            end
                            dataTable9 = gforcehandler
                            dataTable9.synchronizestop = true
                        end
                    end
                elseif 22 == A2_2 then
                    dataTable9 = gforcehandler
                    dataTable9 = dataTable9.currentrotation
                    hash = 179.9
                    if not (dataTable9 < hash) then
                        dataTable9 = gforcehandler
                        dataTable9 = dataTable9.currentrotation
                        hash = 180.1
                        if dataTable9 > hash then
                        else
                            dataTable9 = gforcehandler
                            dataTable9.currentrotation = 180.0
                            dataTable9 = SetEntityRotation
                            hash = gforcehandler
                            hash = hash.mainhandler
                            isDisabled6 = 0.0
                            playerPed = gforcehandler
                            playerPed = playerPed.currentrotation
                            isEnabled2 = 230.0
                            isDisabled4 = false
                            dataTable9(hash, isDisabled6, playerPed, isEnabled2, isDisabled4)
                            dataTable9 = ipairs
                            hash = gforcehandler
                            hash = hash.seats
                            dataTable9, hash, isDisabled6, playerPed = dataTable9(hash)
                            for isEnabled2, isDisabled4 in dataTable9, hash, isDisabled6, playerPed do
                                if 1 == isEnabled2 then
                                    isEnabled9 = AttachEntityToEntity
                                    hash2 = isDisabled4.seathandlermain
                                    isEnabled13 = gforcehandler
                                    isEnabled13 = isEnabled13.mainhandler
                                    isEnabled8 = 0
                                    isEnabled7 = 0.0
                                    isEnabled10 = 0.4
                                    isEnabled4 = -26.4
                                    isDisabled5 = 0.0
                                    isEnabled11 = gforcehandler
                                    isEnabled11 = isEnabled11.currentrotation
                                    isEnabled6 = 0.0
                                    isEnabled5 = false
                                    isEnabled14 = false
                                    isDisabled = false
                                    isEnabled = false
                                    isEnabled15 = 2
                                    isEnabled3 = true
                                    isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                                else
                                    isEnabled9 = AttachEntityToEntity
                                    hash2 = isDisabled4.seathandlermain
                                    isEnabled13 = gforcehandler
                                    isEnabled13 = isEnabled13.mainhandler
                                    isEnabled8 = 0
                                    isEnabled7 = 0.0
                                    isEnabled10 = 0.4
                                    isEnabled4 = 26.2
                                    isDisabled5 = 0.0
                                    isEnabled11 = gforcehandler
                                    isEnabled11 = isEnabled11.currentrotation
                                    isEnabled6 = 0.0
                                    isEnabled5 = false
                                    isEnabled14 = false
                                    isDisabled = false
                                    isEnabled = false
                                    isEnabled15 = 2
                                    isEnabled3 = true
                                    isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                                end
                            end
                            dataTable9 = gforcehandler
                            dataTable9.synchronizestop = true
                        end
                    end
                elseif 14 == A2_2 then
                    dataTable9 = gforcehandler
                    dataTable9 = dataTable9.currentrotation
                    hash = 359.9
                    if dataTable9 < hash then
                    else
                        dataTable9 = gforcehandler
                        dataTable9.currentrotation = 360.0
                        dataTable9 = SetEntityRotation
                        hash = gforcehandler
                        hash = hash.mainhandler
                        isDisabled6 = 0.0
                        playerPed = gforcehandler
                        playerPed = playerPed.currentrotation
                        isEnabled2 = 230.0
                        isDisabled4 = false
                        dataTable9(hash, isDisabled6, playerPed, isEnabled2, isDisabled4)
                        dataTable9 = ipairs
                        hash = gforcehandler
                        hash = hash.seats
                        dataTable9, hash, isDisabled6, playerPed = dataTable9(hash)
                        for isEnabled2, isDisabled4 in dataTable9, hash, isDisabled6, playerPed do
                            if 1 == isEnabled2 then
                                isEnabled9 = AttachEntityToEntity
                                hash2 = isDisabled4.seathandlermain
                                isEnabled13 = gforcehandler
                                isEnabled13 = isEnabled13.mainhandler
                                isEnabled8 = 0
                                isEnabled7 = 0.0
                                isEnabled10 = 0.4
                                isEnabled4 = -26.4
                                isDisabled5 = 0.0
                                isEnabled11 = gforcehandler
                                isEnabled11 = isEnabled11.currentrotation
                                isEnabled6 = 0.0
                                isEnabled5 = false
                                isEnabled14 = false
                                isDisabled = false
                                isEnabled = false
                                isEnabled15 = 2
                                isEnabled3 = true
                                isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                            else
                                isEnabled9 = AttachEntityToEntity
                                hash2 = isDisabled4.seathandlermain
                                isEnabled13 = gforcehandler
                                isEnabled13 = isEnabled13.mainhandler
                                isEnabled8 = 0
                                isEnabled7 = 0.0
                                isEnabled10 = 0.4
                                isEnabled4 = 26.2
                                isDisabled5 = 0.0
                                isEnabled11 = gforcehandler
                                isEnabled11 = isEnabled11.currentrotation
                                isEnabled6 = 0.0
                                isEnabled5 = false
                                isEnabled14 = false
                                isDisabled = false
                                isEnabled = false
                                isEnabled15 = 2
                                isEnabled3 = true
                                isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                            end
                        end
                        dataTable9 = gforcehandler
                        dataTable9.synchronizestop = true
                    end
                else
                    dataTable9 = gforcehandler
                    dataTable9 = dataTable9.currentrotation
                    hash = 360.0
                    if dataTable9 > hash then
                        dataTable9 = gforcehandler
                        dataTable9 = dataTable9.currentrotation
                        dataTable9 = dataTable9 - 360.0
                        hash = gforcehandler
                        isDisabled6 = 0.0 + dataTable9
                        hash.currentrotation = isDisabled6
                    end
                end
                dataTable9 = gforcehandler
                dataTable9 = dataTable9.synchronizestop
                if false == dataTable9 then
                    dataTable9 = gforcehandler
                    hash = gforcehandler
                    hash = hash.currentrotation
                    hash = hash + dataTable
                    dataTable9.currentrotation = hash
                end
                dataTable9 = gforcehandler
                dataTable9 = dataTable9.getnew
                if false == dataTable9 then
                    dataTable9 = SetEntityRotation
                    hash = gforcehandler
                    hash = hash.mainhandler
                    isDisabled6 = 0.0
                    playerPed = gforcehandler
                    playerPed = playerPed.currentrotation
                    isEnabled2 = 230.0
                    isDisabled4 = false
                    dataTable9(hash, isDisabled6, playerPed, isEnabled2, isDisabled4)
                    dataTable9 = ipairs
                    hash = gforcehandler
                    hash = hash.seats
                    dataTable9, hash, isDisabled6, playerPed = dataTable9(hash)
                    for isEnabled2, isDisabled4 in dataTable9, hash, isDisabled6, playerPed do
                        if 1 == isEnabled2 then
                            isEnabled9 = AttachEntityToEntity
                            hash2 = isDisabled4.seathandlermain
                            isEnabled13 = gforcehandler
                            isEnabled13 = isEnabled13.mainhandler
                            isEnabled8 = 0
                            isEnabled7 = 0.0
                            isEnabled10 = 0.4
                            isEnabled4 = -26.4
                            isDisabled5 = 0.0
                            isEnabled11 = gforcehandler
                            isEnabled11 = isEnabled11.currentrotation
                            isEnabled6 = 0.0
                            isEnabled5 = false
                            isEnabled14 = false
                            isDisabled = false
                            isEnabled = false
                            isEnabled15 = 2
                            isEnabled3 = true
                            isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                        else
                            isEnabled9 = AttachEntityToEntity
                            hash2 = isDisabled4.seathandlermain
                            isEnabled13 = gforcehandler
                            isEnabled13 = isEnabled13.mainhandler
                            isEnabled8 = 0
                            isEnabled7 = 0.0
                            isEnabled10 = 0.4
                            isEnabled4 = 26.2
                            isDisabled5 = 0.0
                            isEnabled11 = gforcehandler
                            isEnabled11 = isEnabled11.currentrotation
                            isEnabled6 = 0.0
                            isEnabled5 = false
                            isEnabled14 = false
                            isDisabled = false
                            isEnabled = false
                            isEnabled15 = 2
                            isEnabled3 = true
                            isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3)
                        end
                    end
                end
            end
        end
    else
        dataTable = gforcehandler
        dataTable.getnew = true
    end
end
dataTable8(coords, dataTable7)
dataTable8 = RegisterNetEvent
coords = "rtx_themepark:GForce:SynchronizeStarted"
dataTable8(coords)
dataTable8 = AddEventHandler
coords = "rtx_themepark:GForce:SynchronizeStarted"

function dataTable7(A0_2)
    local isEnabled12, dataTable10, dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14
    isEnabled12 = gforcehandler
    isEnabled12.started = A0_2
    isEnabled12 = DoesEntityExist
    dataTable10 = gforcehandler
    dataTable10 = dataTable10.mainhandler
    isEnabled12 = isEnabled12(dataTable10)
    if isEnabled12 then
        if true == A0_2 then
            isEnabled12 = SetEntityCompletelyDisableCollision
            dataTable10 = gforcehandler
            dataTable10 = dataTable10.mainhandler
            dataTable = false
            dataTable4 = false
            isEnabled12(dataTable10, dataTable, dataTable4)
        else
            isEnabled12 = SetEntityCompletelyDisableCollision
            dataTable10 = gforcehandler
            dataTable10 = dataTable10.mainhandler
            dataTable = true
            dataTable4 = true
            isEnabled12(dataTable10, dataTable, dataTable4)
            isEnabled12 = ipairs
            dataTable10 = gforcehandler
            dataTable10 = dataTable10.seats
            isEnabled12, dataTable10, dataTable, dataTable4 = isEnabled12(dataTable10)
            for dataTable9, hash in isEnabled12, dataTable10, dataTable, dataTable4 do
                if 1 == dataTable9 then
                    isDisabled6 = AttachEntityToEntity
                    playerPed = hash.seathandlermain
                    isEnabled2 = gforcehandler
                    isEnabled2 = isEnabled2.mainhandler
                    isDisabled4 = 0
                    isEnabled9 = 0.0
                    hash2 = 0.4
                    isEnabled13 = -26.4
                    isEnabled8 = 0.0
                    isEnabled7 = gforcehandler
                    isEnabled7 = isEnabled7.currentrotation
                    isEnabled10 = 0.0
                    isEnabled4 = false
                    isDisabled5 = false
                    isEnabled11 = true
                    isEnabled6 = false
                    isEnabled5 = 2
                    isEnabled14 = true
                    isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14)
                else
                    isDisabled6 = AttachEntityToEntity
                    playerPed = hash.seathandlermain
                    isEnabled2 = gforcehandler
                    isEnabled2 = isEnabled2.mainhandler
                    isDisabled4 = 0
                    isEnabled9 = 0.0
                    hash2 = 0.4
                    isEnabled13 = 26.2
                    isEnabled8 = 0.0
                    isEnabled7 = gforcehandler
                    isEnabled7 = isEnabled7.currentrotation
                    isEnabled10 = 0.0
                    isEnabled4 = false
                    isDisabled5 = false
                    isEnabled11 = true
                    isEnabled6 = false
                    isEnabled5 = 2
                    isEnabled14 = true
                    isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14)
                end
            end
        end
    end
end
dataTable8(coords, dataTable7)
dataTable8 = RegisterNetEvent
coords = "rtx_themepark:GForce:SeatDown"
dataTable8(coords)
dataTable8 = AddEventHandler
coords = "rtx_themepark:GForce:SeatDown"

function dataTable7(A0_2)
    local isEnabled12
    isEnabled12 = gforcehandler
    isEnabled12.seatdown = A0_2
end
dataTable8(coords, dataTable7)
dataTable8 = RegisterNetEvent
coords = "rtx_themepark:GForce:SeatData"
dataTable8(coords)
dataTable8 = AddEventHandler
coords = "rtx_themepark:GForce:SeatData"

function dataTable7(A0_2, A1_2)
    local dataTable10, dataTable
    dataTable10 = SendNUIMessage
    dataTable = {}
    dataTable.message = "attractionhow"
    dataTable.attractionanimchange = true
    dataTable10(dataTable)
    var13 = A0_2
    var14 = A1_2
    dataTable10 = true
    isDisabled2 = dataTable10
    dataTable10 = Config
    dataTable10 = dataTable10.ThemeParkFallSettings
    dataTable10 = dataTable10.fallchancecheck
    counter = dataTable10
end
dataTable8(coords, dataTable7)
dataTable8 = RegisterNetEvent
coords = "rtx_themepark:GForce:SeatExit"
dataTable8(coords)
dataTable8 = AddEventHandler
coords = "rtx_themepark:GForce:SeatExit"

function dataTable7(A0_2)
    local isEnabled12, dataTable10, dataTable, dataTable4, dataTable9, hash
    isEnabled12 = gforcehandler
    isEnabled12 = isEnabled12.started
    if false == isEnabled12 then
        isEnabled12 = gforcehandler
        isEnabled12 = isEnabled12.seatdown
        dataTable10 = var13
        if isEnabled12 == dataTable10 then
            isEnabled12 = PlayerPedId
            isEnabled12 = isEnabled12()
            dataTable10 = DetachEntity
            dataTable = isEnabled12
            dataTable10(dataTable)
            dataTable10 = FreezeEntityPosition
            dataTable = isEnabled12
            dataTable4 = false
            dataTable10(dataTable, dataTable4)
            dataTable10 = ClearPedTasks
            dataTable = isEnabled12
            dataTable10(dataTable)
            dataTable10 = SendNUIMessage
            dataTable = {}
            dataTable.message = "hideattraction"
            dataTable10(dataTable)
            dataTable10 = nil
            var13 = dataTable10
            dataTable10 = nil
            var14 = dataTable10
        end
    elseif true == A0_2 then
        isEnabled12 = PlayerPedId
        isEnabled12 = isEnabled12()
        dataTable10 = DetachEntity
        dataTable = isEnabled12
        dataTable10(dataTable)
        dataTable10 = FreezeEntityPosition
        dataTable = isEnabled12
        dataTable4 = false
        dataTable10(dataTable, dataTable4)
        dataTable10 = ClearPedTasks
        dataTable = isEnabled12
        dataTable10(dataTable)
        dataTable10 = SendNUIMessage
        dataTable = {}
        dataTable.message = "hideattraction"
        dataTable10(dataTable)
        dataTable10 = nil
        var13 = dataTable10
        dataTable10 = nil
        var14 = dataTable10
    else
        isEnabled12 = PlayerPedId
        isEnabled12 = isEnabled12()
        dataTable10 = DetachEntity
        dataTable = isEnabled12
        dataTable10(dataTable)
        dataTable10 = FreezeEntityPosition
        dataTable = isEnabled12
        dataTable4 = false
        dataTable10(dataTable, dataTable4)
        dataTable10 = ClearPedTasks
        dataTable = isEnabled12
        dataTable10(dataTable)
        dataTable10 = SetEntityCoordsNoOffset
        dataTable = isEnabled12
        dataTable4 = Config
        dataTable4 = dataTable4.AttractionsSettings
        dataTable4 = dataTable4.gforce
        dataTable4 = dataTable4.exitcoords
        dataTable4 = dataTable4.coords
        dataTable4 = dataTable4.x
        dataTable9 = Config
        dataTable9 = dataTable9.AttractionsSettings
        dataTable9 = dataTable9.gforce
        dataTable9 = dataTable9.exitcoords
        dataTable9 = dataTable9.coords
        dataTable9 = dataTable9.y
        hash = Config
        hash = hash.AttractionsSettings
        hash = hash.gforce
        hash = hash.exitcoords
        hash = hash.coords
        hash = hash.z
        dataTable10(dataTable, dataTable4, dataTable9, hash)
        dataTable10 = SetEntityHeading
        dataTable = isEnabled12
        dataTable4 = Config
        dataTable4 = dataTable4.AttractionsSettings
        dataTable4 = dataTable4.gforce
        dataTable4 = dataTable4.exitcoords
        dataTable4 = dataTable4.heading
        dataTable10(dataTable, dataTable4)
        dataTable10 = SendNUIMessage
        dataTable = {}
        dataTable.message = "hideattraction"
        dataTable10(dataTable)
        dataTable10 = nil
        var13 = dataTable10
        dataTable10 = nil
        var14 = dataTable10
    end
    isEnabled12 = false
    isDisabled2 = isEnabled12
end
dataTable8(coords, dataTable7)
dataTable8 = Config
dataTable8 = dataTable8.ThemeParkAttractionFallChance
if dataTable8 then
    dataTable8 = Config
    dataTable8 = dataTable8.ThemeParkFallSettings
    dataTable8 = dataTable8.attractions
    dataTable8 = dataTable8.gforce
    if dataTable8 then
        dataTable8 = RegisterNetEvent
        coords = "rtx_themepark:GForce:SeatThrowClient"
        dataTable8(coords)
        dataTable8 = AddEventHandler
        coords = "rtx_themepark:GForce:SeatThrowClient"

        function dataTable7()
            local hash3, isEnabled12, dataTable10, dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4
            hash3 = var13
            if nil ~= hash3 then
                hash3 = var14
                if nil ~= hash3 then
                    hash3 = PlayerPedId
                    hash3 = hash3()
                    isEnabled12 = DetachEntity
                    dataTable10 = hash3
                    isEnabled12(dataTable10)
                    isEnabled12 = FreezeEntityPosition
                    dataTable10 = hash3
                    dataTable = false
                    isEnabled12(dataTable10, dataTable)
                    isEnabled12 = ClearPedTasks
                    dataTable10 = hash3
                    isEnabled12(dataTable10)
                    isEnabled12 = SendNUIMessage
                    dataTable10 = {}
                    dataTable10.message = "hideattraction"
                    isEnabled12(dataTable10)
                    isEnabled12 = nil
                    var13 = isEnabled12
                    isEnabled12 = nil
                    var14 = isEnabled12
                    usingattraction = false
                    isEnabled12 = GetEntityForwardVector
                    dataTable10 = hash3
                    isEnabled12 = isEnabled12(dataTable10)
                    dataTable10 = math
                    dataTable10 = dataTable10.random
                    dataTable10 = dataTable10()
                    dataTable = 40.0
                    dataTable = dataTable - 40.0
                    dataTable10 = dataTable10 * dataTable
                    dataTable10 = 40.0 + dataTable10
                    dataTable = SetPedToRagdoll
                    dataTable4 = hash3
                    dataTable9 = 2000
                    hash = 2000
                    isDisabled6 = false
                    playerPed = false
                    isEnabled2 = false
                    isDisabled4 = false
                    dataTable(dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4)
                    dataTable = ApplyForceToEntity
                    dataTable4 = hash3
                    dataTable9 = 1
                    hash = isEnabled12.x
                    hash = hash * dataTable10
                    isDisabled6 = isEnabled12.y
                    isDisabled6 = isDisabled6 * dataTable10
                    playerPed = isEnabled12.z
                    playerPed = playerPed + 40.0
                    isEnabled2 = 0
                    isDisabled4 = 0
                    isEnabled9 = 0
                    hash2 = 0
                    isEnabled13 = false
                    isEnabled8 = true
                    isEnabled7 = true
                    isEnabled10 = false
                    isEnabled4 = true
                    dataTable(dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4)
                    dataTable = Notify
                    dataTable4 = Language
                    dataTable9 = Config
                    dataTable9 = dataTable9.Language
                    dataTable4 = dataTable4[dataTable9]
                    dataTable4 = dataTable4.themeparkfall
                    dataTable(dataTable4)
                end
            end
        end
        dataTable8(coords, dataTable7)
    end
end
dataTable8 = Config
dataTable8 = dataTable8.Target
if true == dataTable8 then
    dataTable8 = RegisterNetEvent
    coords = "rtx_themepark:GForce:SeatTarget"
    dataTable8(coords)
    dataTable8 = AddEventHandler
    coords = "rtx_themepark:GForce:SeatTarget"

    function dataTable7()
        local hash3, isEnabled12, dataTable10, dataTable
        hash3 = gforcehandler
        hash3 = hash3.started
        if false == hash3 then
            hash3 = gforcehandler
            hash3 = hash3.changingsides
            if false == hash3 then
                hash3 = usingattraction
                if false == hash3 then
                    hash3 = dataTable2.seatcategoryid
                    if nil ~= hash3 then
                        hash3 = dataTable2.seatid
                        if nil ~= hash3 then
                            hash3 = iteminhand
                            if false == hash3 then
                                hash3 = TriggerServerEvent
                                isEnabled12 = "rtx_themepark:GForce:SeatUse"
                                dataTable10 = dataTable2.seatcategoryid
                                dataTable = dataTable2.seatid
                                hash3(isEnabled12, dataTable10, dataTable)
                            else
                                hash3 = Notify
                                isEnabled12 = Language
                                dataTable10 = Config
                                dataTable10 = dataTable10.Language
                                isEnabled12 = isEnabled12[dataTable10]
                                isEnabled12 = isEnabled12.iteminhand
                                hash3(isEnabled12)
                            end
                        end
                    end
                end
            end
        end
    end
    dataTable8(coords, dataTable7)
end
dataTable8 = Citizen
dataTable8 = dataTable8.CreateThread

function coords()
    local hash3, isEnabled12, dataTable10, dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3, isDisabled3, var2, isEnabled16
    while true do
        hash3 = Citizen
        hash3 = hash3.Wait
        isEnabled12 = 1000
        hash3(isEnabled12)
        hash3 = nearbythemepark
        if true == hash3 then
            hash3 = DoesEntityExist
            isEnabled12 = gforcehandler
            isEnabled12 = isEnabled12.mainhandler
            hash3 = hash3(isEnabled12)
            if hash3 then
                hash3 = FreezeEntityPosition
                isEnabled12 = gforcehandler
                isEnabled12 = isEnabled12.mainhandler
                dataTable10 = true
                hash3(isEnabled12, dataTable10)
            else
                hash3 = GetHashKey
                isEnabled12 = "sempre_delperropier_gbooster_rameno"
                hash3 = hash3(isEnabled12)
                isEnabled12 = RequestModel
                dataTable10 = hash3
                isEnabled12(dataTable10)
                while true do
                    isEnabled12 = HasModelLoaded
                    dataTable10 = hash3
                    isEnabled12 = isEnabled12(dataTable10)
                    if isEnabled12 then
                        break
                    end
                    isEnabled12 = RequestModel
                    dataTable10 = hash3
                    isEnabled12(dataTable10)
                    isEnabled12 = Citizen
                    isEnabled12 = isEnabled12.Wait
                    dataTable10 = 5
                    isEnabled12(dataTable10)
                end
                isEnabled12 = gforcehandler
                dataTable10 = CreateObjectNoOffset
                dataTable = hash3
                dataTable4 = gforcehandler
                dataTable4 = dataTable4.coords
                dataTable4 = dataTable4.x
                dataTable9 = gforcehandler
                dataTable9 = dataTable9.coords
                dataTable9 = dataTable9.y
                hash = gforcehandler
                hash = hash.coords
                hash = hash.z
                isDisabled6 = false
                playerPed = true
                isEnabled2 = true
                dataTable10 = dataTable10(dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2)
                isEnabled12.mainhandler = dataTable10
                isEnabled12 = SetEntityRotation
                dataTable10 = gforcehandler
                dataTable10 = dataTable10.mainhandler
                dataTable = 0.0
                dataTable4 = gforcehandler
                dataTable4 = dataTable4.currentrotation
                dataTable9 = 230.0
                isEnabled12(dataTable10, dataTable, dataTable4, dataTable9)
                isEnabled12 = NetworkAllowLocalEntityAttachment
                dataTable10 = gforcehandler
                dataTable10 = dataTable10.mainhandler
                dataTable = true
                isEnabled12(dataTable10, dataTable)
                isEnabled12 = FreezeEntityPosition
                dataTable10 = gforcehandler
                dataTable10 = dataTable10.mainhandler
                dataTable = true
                isEnabled12(dataTable10, dataTable)
            end
            hash3 = DoesEntityExist
            isEnabled12 = gforcehandler
            isEnabled12 = isEnabled12.mainhandler
            hash3 = hash3(isEnabled12)
            if hash3 then
                hash3 = DoesEntityExist
                isEnabled12 = gforcehandler
                isEnabled12 = isEnabled12.animhandler
                hash3 = hash3(isEnabled12)
                if hash3 then
                    hash3 = FreezeEntityPosition
                    isEnabled12 = gforcehandler
                    isEnabled12 = isEnabled12.animhandler
                    dataTable10 = true
                    hash3(isEnabled12, dataTable10)
                else
                    hash3 = GetHashKey
                    isEnabled12 = "sempre_delperropier_gbooster_rameno_anim"
                    hash3 = hash3(isEnabled12)
                    isEnabled12 = RequestModel
                    dataTable10 = hash3
                    isEnabled12(dataTable10)
                    while true do
                        isEnabled12 = HasModelLoaded
                        dataTable10 = hash3
                        isEnabled12 = isEnabled12(dataTable10)
                        if isEnabled12 then
                            break
                        end
                        isEnabled12 = RequestModel
                        dataTable10 = hash3
                        isEnabled12(dataTable10)
                        isEnabled12 = Citizen
                        isEnabled12 = isEnabled12.Wait
                        dataTable10 = 5
                        isEnabled12(dataTable10)
                    end
                    isEnabled12 = gforcehandler
                    dataTable10 = CreateObjectNoOffset
                    dataTable = hash3
                    dataTable4 = gforcehandler
                    dataTable4 = dataTable4.coords
                    dataTable4 = dataTable4.x
                    dataTable9 = gforcehandler
                    dataTable9 = dataTable9.coords
                    dataTable9 = dataTable9.y
                    hash = gforcehandler
                    hash = hash.coords
                    hash = hash.z
                    isDisabled6 = false
                    playerPed = true
                    isEnabled2 = true
                    dataTable10 = dataTable10(dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2)
                    isEnabled12.animhandler = dataTable10
                    isEnabled12 = SetEntityRotation
                    dataTable10 = gforcehandler
                    dataTable10 = dataTable10.animhandler
                    dataTable = 0.0
                    dataTable4 = gforcehandler
                    dataTable4 = dataTable4.currentrotation
                    dataTable9 = 230.0
                    isEnabled12(dataTable10, dataTable, dataTable4, dataTable9)
                    isEnabled12 = NetworkAllowLocalEntityAttachment
                    dataTable10 = gforcehandler
                    dataTable10 = dataTable10.animhandler
                    dataTable = true
                    isEnabled12(dataTable10, dataTable)
                    isEnabled12 = FreezeEntityPosition
                    dataTable10 = gforcehandler
                    dataTable10 = dataTable10.animhandler
                    dataTable = true
                    isEnabled12(dataTable10, dataTable)
                    isEnabled12 = AttachEntityToEntity
                    dataTable10 = gforcehandler
                    dataTable10 = dataTable10.animhandler
                    dataTable = gforcehandler
                    dataTable = dataTable.mainhandler
                    dataTable4 = 0
                    dataTable9 = 0.0
                    hash = 0.0
                    isDisabled6 = 0.0
                    playerPed = 0.0
                    isEnabled2 = 0.0
                    isDisabled4 = 0.0
                    isEnabled9 = false
                    hash2 = false
                    isEnabled13 = true
                    isEnabled8 = false
                    isEnabled7 = 2
                    isEnabled10 = true
                    isEnabled12(dataTable10, dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10)
                end
            end
            hash3 = ipairs
            isEnabled12 = gforcehandler
            isEnabled12 = isEnabled12.seats
            hash3, isEnabled12, dataTable10, dataTable = hash3(isEnabled12)
            for dataTable4, dataTable9 in hash3, isEnabled12, dataTable10, dataTable do
                hash = DoesEntityExist
                isDisabled6 = dataTable9.seathandlermain
                hash = hash(isDisabled6)
                if hash then
                    hash = FreezeEntityPosition
                    isDisabled6 = dataTable9.seathandlermain
                    playerPed = true
                    hash(isDisabled6, playerPed)
                else
                    hash = GetHashKey
                    isDisabled6 = "sempre_delperropier_gbooster_sedacka"
                    hash = hash(isDisabled6)
                    isDisabled6 = RequestModel
                    playerPed = hash
                    isDisabled6(playerPed)
                    while true do
                        isDisabled6 = HasModelLoaded
                        playerPed = hash
                        isDisabled6 = isDisabled6(playerPed)
                        if isDisabled6 then
                            break
                        end
                        isDisabled6 = RequestModel
                        playerPed = hash
                        isDisabled6(playerPed)
                        isDisabled6 = Citizen
                        isDisabled6 = isDisabled6.Wait
                        playerPed = 5
                        isDisabled6(playerPed)
                    end
                    isDisabled6 = CreateObjectNoOffset
                    playerPed = hash
                    isEnabled2 = gforcehandler
                    isEnabled2 = isEnabled2.coords
                    isEnabled2 = isEnabled2.x
                    isDisabled4 = gforcehandler
                    isDisabled4 = isDisabled4.coords
                    isDisabled4 = isDisabled4.y
                    isEnabled9 = gforcehandler
                    isEnabled9 = isEnabled9.coords
                    isEnabled9 = isEnabled9.z
                    hash2 = false
                    isEnabled13 = true
                    isEnabled8 = true
                    isDisabled6 = isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8)
                    dataTable9.seathandlermain = isDisabled6
                    isDisabled6 = SetEntityRotation
                    playerPed = dataTable9.seathandlermain
                    isEnabled2 = 0.0
                    isDisabled4 = 0.0
                    isEnabled9 = 230.0
                    isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9)
                    isDisabled6 = NetworkAllowLocalEntityAttachment
                    playerPed = dataTable9.seathandlermain
                    isEnabled2 = true
                    isDisabled6(playerPed, isEnabled2)
                    isDisabled6 = FreezeEntityPosition
                    playerPed = dataTable9.seathandlermain
                    isEnabled2 = true
                    isDisabled6(playerPed, isEnabled2)
                    if 1 == dataTable4 then
                        isDisabled6 = AttachEntityToEntity
                        playerPed = dataTable9.seathandlermain
                        isEnabled2 = gforcehandler
                        isEnabled2 = isEnabled2.mainhandler
                        isDisabled4 = 0
                        isEnabled9 = 0.0
                        hash2 = 0.4
                        isEnabled13 = -26.4
                        isEnabled8 = 0.0
                        isEnabled7 = gforcehandler
                        isEnabled7 = isEnabled7.currentrotation
                        isEnabled10 = 0.0
                        isEnabled4 = false
                        isDisabled5 = false
                        isEnabled11 = true
                        isEnabled6 = false
                        isEnabled5 = 2
                        isEnabled14 = true
                        isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14)
                    else
                        isDisabled6 = AttachEntityToEntity
                        playerPed = dataTable9.seathandlermain
                        isEnabled2 = gforcehandler
                        isEnabled2 = isEnabled2.mainhandler
                        isDisabled4 = 0
                        isEnabled9 = 0.0
                        hash2 = 0.4
                        isEnabled13 = 26.2
                        isEnabled8 = 0.0
                        isEnabled7 = gforcehandler
                        isEnabled7 = isEnabled7.currentrotation
                        isEnabled10 = 0.0
                        isEnabled4 = false
                        isDisabled5 = false
                        isEnabled11 = true
                        isEnabled6 = false
                        isEnabled5 = 2
                        isEnabled14 = true
                        isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14)
                    end
                end
                hash = DoesEntityExist
                isDisabled6 = dataTable9.seathandlermain
                hash = hash(isDisabled6)
                if hash then
                    hash = DoesEntityExist
                    isDisabled6 = dataTable9.animhandler
                    hash = hash(isDisabled6)
                    if hash then
                        hash = FreezeEntityPosition
                        isDisabled6 = dataTable9.animhandler
                        playerPed = true
                        hash(isDisabled6, playerPed)
                    else
                        hash = GetHashKey
                        isDisabled6 = "sempre_delperropier_gbooster_sedacka_anim"
                        hash = hash(isDisabled6)
                        isDisabled6 = RequestModel
                        playerPed = hash
                        isDisabled6(playerPed)
                        while true do
                            isDisabled6 = HasModelLoaded
                            playerPed = hash
                            isDisabled6 = isDisabled6(playerPed)
                            if isDisabled6 then
                                break
                            end
                            isDisabled6 = RequestModel
                            playerPed = hash
                            isDisabled6(playerPed)
                            isDisabled6 = Citizen
                            isDisabled6 = isDisabled6.Wait
                            playerPed = 5
                            isDisabled6(playerPed)
                        end
                        isDisabled6 = CreateObjectNoOffset
                        playerPed = hash
                        isEnabled2 = gforcehandler
                        isEnabled2 = isEnabled2.coords
                        isEnabled2 = isEnabled2.x
                        isDisabled4 = gforcehandler
                        isDisabled4 = isDisabled4.coords
                        isDisabled4 = isDisabled4.y
                        isEnabled9 = gforcehandler
                        isEnabled9 = isEnabled9.coords
                        isEnabled9 = isEnabled9.z
                        hash2 = false
                        isEnabled13 = true
                        isEnabled8 = true
                        isDisabled6 = isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8)
                        dataTable9.animhandler = isDisabled6
                        isDisabled6 = SetEntityRotation
                        playerPed = dataTable9.animhandler
                        isEnabled2 = 0.0
                        isDisabled4 = 0.0
                        isEnabled9 = 230.0
                        isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9)
                        isDisabled6 = NetworkAllowLocalEntityAttachment
                        playerPed = dataTable9.animhandler
                        isEnabled2 = true
                        isDisabled6(playerPed, isEnabled2)
                        isDisabled6 = FreezeEntityPosition
                        playerPed = dataTable9.animhandler
                        isEnabled2 = true
                        isDisabled6(playerPed, isEnabled2)
                        isDisabled6 = AttachEntityToEntity
                        playerPed = dataTable9.animhandler
                        isEnabled2 = dataTable9.seathandlermain
                        isDisabled4 = 0
                        isEnabled9 = 0.0
                        hash2 = 0.0
                        isEnabled13 = 0.0
                        isEnabled8 = 0.0
                        isEnabled7 = 0.0
                        isEnabled10 = 0.0
                        isEnabled4 = false
                        isDisabled5 = false
                        isEnabled11 = true
                        isEnabled6 = false
                        isEnabled5 = 2
                        isEnabled14 = true
                        isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14)
                    end
                end
                hash = ipairs
                isDisabled6 = dataTable9.seathandlercage
                hash, isDisabled6, playerPed, isEnabled2 = hash(isDisabled6)
                for isDisabled4, isEnabled9 in hash, isDisabled6, playerPed, isEnabled2 do
                    hash2 = DoesEntityExist
                    isEnabled13 = isEnabled9.handler
                    hash2 = hash2(isEnabled13)
                    if hash2 then
                        hash2 = FreezeEntityPosition
                        isEnabled13 = isEnabled9.handler
                        isEnabled8 = true
                        hash2(isEnabled13, isEnabled8)
                    else
                        hash2 = GetHashKey
                        isEnabled13 = "sempre_delperropier_gbooster_zavirani"
                        hash2 = hash2(isEnabled13)
                        isEnabled13 = RequestModel
                        isEnabled8 = hash2
                        isEnabled13(isEnabled8)
                        while true do
                            isEnabled13 = HasModelLoaded
                            isEnabled8 = hash2
                            isEnabled13 = isEnabled13(isEnabled8)
                            if isEnabled13 then
                                break
                            end
                            isEnabled13 = RequestModel
                            isEnabled8 = hash2
                            isEnabled13(isEnabled8)
                            isEnabled13 = Citizen
                            isEnabled13 = isEnabled13.Wait
                            isEnabled8 = 5
                            isEnabled13(isEnabled8)
                        end
                        isEnabled13 = CreateObjectNoOffset
                        isEnabled8 = hash2
                        isEnabled7 = gforcehandler
                        isEnabled7 = isEnabled7.coords
                        isEnabled7 = isEnabled7.x
                        isEnabled10 = gforcehandler
                        isEnabled10 = isEnabled10.coords
                        isEnabled10 = isEnabled10.y
                        isEnabled4 = gforcehandler
                        isEnabled4 = isEnabled4.coords
                        isEnabled4 = isEnabled4.z
                        isDisabled5 = false
                        isEnabled11 = true
                        isEnabled6 = true
                        isEnabled13 = isEnabled13(isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6)
                        isEnabled9.handler = isEnabled13
                        isEnabled13 = SetEntityRotation
                        isEnabled8 = isEnabled9.handler
                        isEnabled7 = 0.0
                        isEnabled10 = 0.0
                        isEnabled4 = 230.0
                        isEnabled13(isEnabled8, isEnabled7, isEnabled10, isEnabled4)
                        isEnabled13 = NetworkAllowLocalEntityAttachment
                        isEnabled8 = isEnabled9.handler
                        isEnabled7 = true
                        isEnabled13(isEnabled8, isEnabled7)
                        isEnabled13 = FreezeEntityPosition
                        isEnabled8 = isEnabled9.handler
                        isEnabled7 = true
                        isEnabled13(isEnabled8, isEnabled7)
                        if 1 == isDisabled4 then
                            isEnabled13 = 0.0
                            isEnabled8 = dataTable9.cageclosed
                            if false == isEnabled8 then
                                isEnabled13 = 70.0
                            end
                            isEnabled8 = AttachEntityToEntity
                            isEnabled7 = isEnabled9.handler
                            isEnabled10 = dataTable9.seathandlermain
                            isEnabled4 = 0
                            isDisabled5 = 0.24
                            isEnabled11 = -0.68
                            isEnabled6 = 0.9
                            isEnabled5 = 0.0
                            isEnabled14 = isEnabled13
                            isDisabled = -180.0
                            isEnabled = false
                            isEnabled15 = false
                            isEnabled3 = false
                            isDisabled3 = false
                            var2 = 2
                            isEnabled16 = true
                            isEnabled8(isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3, isDisabled3, var2, isEnabled16)
                        else
                            isEnabled13 = 0.0
                            isEnabled8 = dataTable9.cageclosed
                            if false == isEnabled8 then
                                isEnabled13 = 70.0
                            end
                            isEnabled8 = AttachEntityToEntity
                            isEnabled7 = isEnabled9.handler
                            isEnabled10 = dataTable9.seathandlermain
                            isEnabled4 = 0
                            isDisabled5 = -0.24
                            isEnabled11 = -0.68
                            isEnabled6 = 0.9
                            isEnabled5 = 0.0
                            isEnabled14 = isEnabled13
                            isDisabled = 0.0
                            isEnabled = false
                            isEnabled15 = false
                            isEnabled3 = false
                            isDisabled3 = false
                            var2 = 2
                            isEnabled16 = true
                            isEnabled8(isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15, isEnabled3, isDisabled3, var2, isEnabled16)
                        end
                    end
                end
            end
        end
    end
end
dataTable8(coords)
dataTable8 = -1
coords = Citizen
coords = coords.CreateThread

function dataTable7()
    local hash3, isEnabled12, dataTable10, dataTable, dataTable4
    while true do
        hash3 = Citizen
        hash3 = hash3.Wait
        isEnabled12 = 0
        hash3(isEnabled12)
        hash3 = GlobalState
        hash3 = hash3["attraction1 - phase"]
        if 0 ~= hash3 then
            hash3 = nearbythemepark
            if false ~= hash3 then
                goto lbl_21
            end
        end
        hash3 = Citizen
        hash3 = hash3.Wait
        isEnabled12 = 500
        hash3(isEnabled12)
        hash3 = gforcehandler
        hash3.getnew = true
        hash3 = -1
        dataTable8 = hash3
        goto lbl_43
        ::lbl_21::
        hash3 = dataTable8
        if -1 ~= hash3 then
            hash3 = dataTable8
            isEnabled12 = GlobalState
            isEnabled12 = isEnabled12["attraction1 - synchdata"]
            if not (hash3 < isEnabled12) then
                goto lbl_43
            end
        end
        hash3 = tonumber
        isEnabled12 = GlobalState
        isEnabled12 = isEnabled12["attraction1 - synchdata"]
        hash3 = hash3(isEnabled12)
        dataTable8 = hash3
        hash3 = TriggerEvent
        isEnabled12 = "rtx_themepark:GForce:SynchronizeMovement"
        dataTable10 = GlobalState
        dataTable10 = dataTable10["attraction1 - ridedata1"]
        dataTable = GlobalState
        dataTable = dataTable["attraction1 - speeddata1"]
        dataTable4 = GlobalState
        dataTable4 = dataTable4["attraction1 - phase"]
        hash3(isEnabled12, dataTable10, dataTable, dataTable4)
        ::lbl_43::
    end
end
coords(dataTable7)
coords = Config
coords = coords.AttractionsSettings
coords = coords.gforce
coords = coords.disable
if false == coords then
    coords = Citizen
    coords = coords.CreateThread

    function dataTable7()
        local hash3, isEnabled12, dataTable10, dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6
        while true do
            hash3 = Citizen
            hash3 = hash3.Wait
            isEnabled12 = 0
            hash3(isEnabled12)
            hash3 = true
            isEnabled12 = false
            dataTable10 = -1
            dataTable = {}
            dataTable.seatcategoryid = nil
            dataTable.seatid = nil
            dataTable4 = nearbythemepark
            if true == dataTable4 then
                dataTable4 = tickets
                dataTable4 = dataTable4.gforce
                if true == dataTable4 then
                    dataTable4 = gforcehandler
                    dataTable4 = dataTable4.started
                    if false == dataTable4 then
                        dataTable4 = gforcehandler
                        dataTable4 = dataTable4.changingsides
                        if false == dataTable4 then
                            dataTable4 = ipairs
                            dataTable9 = gforcehandler
                            dataTable9 = dataTable9.seats
                            dataTable4, dataTable9, hash, isDisabled6 = dataTable4(dataTable9)
                            for playerPed, isEnabled2 in dataTable4, dataTable9, hash, isDisabled6 do
                                isDisabled4 = gforcehandler
                                isDisabled4 = isDisabled4.seatdown
                                if isDisabled4 == playerPed then
                                    isDisabled4 = ipairs
                                    isEnabled9 = isEnabled2.seats
                                    isDisabled4, isEnabled9, hash2, isEnabled13 = isDisabled4(isEnabled9)
                                    for isEnabled8, isEnabled7 in isDisabled4, isEnabled9, hash2, isEnabled13 do
                                        isEnabled10 = isEnabled7.taken
                                        if false == isEnabled10 then
                                            isEnabled10 = GetOffsetFromEntityInWorldCoords
                                            isEnabled4 = isEnabled2.seathandlermain
                                            isDisabled5 = isEnabled7.offsets
                                            isDisabled5 = isDisabled5.coords
                                            isDisabled5 = isDisabled5.x
                                            isEnabled11 = isEnabled7.offsets
                                            isEnabled11 = isEnabled11.coords
                                            isEnabled11 = isEnabled11.y
                                            isEnabled6 = isEnabled7.offsets
                                            isEnabled6 = isEnabled6.coords
                                            isEnabled6 = isEnabled6.z
                                            isEnabled10 = isEnabled10(isEnabled4, isDisabled5, isEnabled11, isEnabled6)
                                            isEnabled4 = playercurrentcoords
                                            isEnabled4 = isEnabled4 - isEnabled10
                                            isEnabled4 = #isEnabled4
                                            if isEnabled4 < 20.0 then
                                                isDisabled5 = Config
                                                isDisabled5 = isDisabled5.AttractionsSettings
                                                isDisabled5 = isDisabled5.gforce
                                                isDisabled5 = isDisabled5.usedistance
                                                if isEnabled4 < isDisabled5 and (-1 == dataTable10 or dataTable10 > isEnabled4) then
                                                    dataTable10 = isEnabled4
                                                    isEnabled12 = true
                                                    dataTable.seatcategoryid = playerPed
                                                    dataTable.seatid = isEnabled8
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if isEnabled12 then
                    dataTable4 = {}
                    dataTable9 = dataTable.seatcategoryid
                    dataTable4.seatcategoryid = dataTable9
                    dataTable9 = dataTable.seatid
                    dataTable4.seatid = dataTable9
                    dataTable2 = dataTable4
                    dataTable4 = false
                    dataTable9 = usingattraction
                    if false == dataTable9 then
                        hash3 = false
                        dataTable9 = Config
                        dataTable9 = dataTable9.Target
                        if false == dataTable9 then
                            dataTable9 = gforcehandler
                            dataTable9 = dataTable9.seats
                            hash = dataTable2.seatcategoryid
                            dataTable9 = dataTable9[hash]
                            hash = dataTable9.seats
                            isDisabled6 = dataTable2.seatid
                            hash = hash[isDisabled6]
                            isDisabled6 = Config
                            isDisabled6 = isDisabled6.ThemeParkInteractionSystem
                            if 1 == isDisabled6 then
                                isDisabled6 = SendNUIMessage
                                playerPed = {}
                                playerPed.message = "infonotifyshow"
                                isEnabled2 = Language
                                isDisabled4 = Config
                                isDisabled4 = isDisabled4.Language
                                isEnabled2 = isEnabled2[isDisabled4]
                                isEnabled2 = isEnabled2.pressforuseseatinteract
                                playerPed.infonotifytext = isEnabled2
                                isDisabled6(playerPed)
                                dataTable4 = true
                            else
                                isDisabled6 = Config
                                isDisabled6 = isDisabled6.ThemeParkInteractionSystem
                                if 2 == isDisabled6 then
                                    isDisabled6 = GetOffsetFromEntityInWorldCoords
                                    playerPed = dataTable9.seathandlermain
                                    isEnabled2 = hash.offsets
                                    isEnabled2 = isEnabled2.coords
                                    isEnabled2 = isEnabled2.x
                                    isDisabled4 = hash.offsets
                                    isDisabled4 = isDisabled4.coords
                                    isDisabled4 = isDisabled4.y
                                    isEnabled9 = hash.offsets
                                    isEnabled9 = isEnabled9.coords
                                    isEnabled9 = isEnabled9.z
                                    isDisabled6 = isDisabled6(playerPed, isEnabled2, isDisabled4, isEnabled9)
                                    playerPed = DrawText3D
                                    isEnabled2 = isDisabled6.x
                                    isDisabled4 = isDisabled6.y
                                    isEnabled9 = isDisabled6.z
                                    hash2 = Language
                                    isEnabled13 = Config
                                    isEnabled13 = isEnabled13.Language
                                    hash2 = hash2[isEnabled13]
                                    hash2 = hash2.pressforuseseat
                                    playerPed(isEnabled2, isDisabled4, isEnabled9, hash2)
                                else
                                    isDisabled6 = Config
                                    isDisabled6 = isDisabled6.ThemeParkInteractionSystem
                                    if 3 == isDisabled6 then
                                        isDisabled6 = ShowGtaClassicInteraction
                                        playerPed = Language
                                        isEnabled2 = Config
                                        isEnabled2 = isEnabled2.Language
                                        playerPed = playerPed[isEnabled2]
                                        playerPed = playerPed.pressforuseseatinteractclassic
                                        isDisabled6(playerPed)
                                    end
                                end
                            end
                        end
                    end
                else
                    dataTable4 = Config
                    dataTable4 = dataTable4.ThemeParkInteractionSystem
                    if 1 == dataTable4 then
                        dataTable4 = dataTable2.seatcategoryid
                        if nil ~= dataTable4 then
                            dataTable4 = SendNUIMessage
                            dataTable9 = {}
                            dataTable9.message = "hide"
                            dataTable4(dataTable9)
                        end
                    end
                    dataTable4 = {}
                    dataTable4.seatcategoryid = nil
                    dataTable4.seatid = nil
                    dataTable2 = dataTable4
                end
            end
            if hash3 then
                dataTable4 = Citizen
                dataTable4 = dataTable4.Wait
                dataTable9 = 1000
                dataTable4(dataTable9)
            end
        end
    end
    coords(dataTable7)
end
coords = Config
coords = coords.ThemeParkAttractionFallChance
if coords then
    coords = Config
    coords = coords.ThemeParkFallSettings
    coords = coords.attractions
    coords = coords.gforce
    if coords then
        coords = Citizen
        coords = coords.CreateThread

        function dataTable7()
            local hash3, isEnabled12, dataTable10, dataTable, dataTable4
            while true do
                hash3 = Citizen
                hash3 = hash3.Wait
                isEnabled12 = 0
                hash3(isEnabled12)
                hash3 = nearbythemepark
                if true == hash3 then
                    hash3 = var13
                    if nil ~= hash3 then
                        hash3 = var14
                        if nil ~= hash3 then
                            hash3 = isDisabled2
                            if true == hash3 then
                                hash3 = gforcehandler
                                hash3 = hash3.started
                                if true == hash3 then
                                    hash3 = counter
                                    if hash3 > 0 then
                                        hash3 = counter
                                        hash3 = hash3 - 1
                                        counter = hash3
                                        hash3 = Citizen
                                        hash3 = hash3.Wait
                                        isEnabled12 = 1000
                                        hash3(isEnabled12)
                                    else
                                        hash3 = Citizen
                                        hash3 = hash3.Wait
                                        isEnabled12 = 1000
                                        hash3(isEnabled12)
                                        hash3 = math
                                        hash3 = hash3.random
                                        isEnabled12 = 1000
                                        hash3 = hash3(isEnabled12)
                                        isEnabled12 = Config
                                        isEnabled12 = isEnabled12.ThemeParkFallSettings
                                        isEnabled12 = isEnabled12.fallchance
                                        if hash3 <= isEnabled12 then
                                            isEnabled12 = false
                                            isDisabled2 = isEnabled12
                                            isEnabled12 = usingattraction
                                            if true == isEnabled12 then
                                                isEnabled12 = var13
                                                if nil ~= isEnabled12 then
                                                    isEnabled12 = var14
                                                    if nil ~= isEnabled12 then
                                                        isEnabled12 = TriggerServerEvent
                                                        dataTable10 = "rtx_themepark:GForce:ThrowAttraction"
                                                        dataTable = var13
                                                        dataTable4 = var14
                                                        isEnabled12(dataTable10, dataTable, dataTable4)
                                                    end
                                                end
                                            end
                                        else
                                            isEnabled12 = Config
                                            isEnabled12 = isEnabled12.ThemeParkFallSettings
                                            isEnabled12 = isEnabled12.fallchancecheck
                                            counter = isEnabled12
                                        end
                                    end
                                end
                            end
                        end
                    else
                        hash3 = Citizen
                        hash3 = hash3.Wait
                        isEnabled12 = 1500
                        hash3(isEnabled12)
                    end
                else
                    hash3 = Citizen
                    hash3 = hash3.Wait
                    isEnabled12 = 1500
                    hash3(isEnabled12)
                end
            end
        end
        coords(dataTable7)
    end
end
coords = RegisterNetEvent
dataTable7 = "rtx_themepark:GForce:SynchronizeSeat"
coords(dataTable7)
coords = AddEventHandler
dataTable7 = "rtx_themepark:GForce:SynchronizeSeat"

function dataTable5(A0_2, A1_2, A2_2, A3_2, A4_2)
    local dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled
    dataTable9 = gforcehandler
    dataTable9 = dataTable9.seats
    dataTable9 = dataTable9[A0_2]
    hash = dataTable9.seats
    hash = hash[A1_2]
    hash.taken = A2_2
    if false == A2_2 then
        if nil ~= A3_2 then
            isDisabled6 = GetPlayerFromServerId
            playerPed = A3_2
            isDisabled6 = isDisabled6(playerPed)
            if -1 ~= isDisabled6 then
                playerPed = GetPlayerPed
                isEnabled2 = isDisabled6
                playerPed = playerPed(isEnabled2)
                isEnabled2 = DoesEntityExist
                isDisabled4 = playerPed
                isEnabled2 = isEnabled2(isDisabled4)
                if isEnabled2 then
                    isEnabled2 = DetachEntity
                    isDisabled4 = playerPed
                    isEnabled2(isDisabled4)
                    isEnabled2 = FreezeEntityPosition
                    isDisabled4 = playerPed
                    isEnabled9 = false
                    isEnabled2(isDisabled4, isEnabled9)
                    isEnabled2 = ClearPedTasks
                    isDisabled4 = playerPed
                    isEnabled2(isDisabled4)
                end
            end
        end
    else
        isDisabled6 = GetPlayerFromServerId
        playerPed = A3_2
        isDisabled6 = isDisabled6(playerPed)
        if -1 ~= isDisabled6 then
            playerPed = GetPlayerPed
            isEnabled2 = isDisabled6
            playerPed = playerPed(isEnabled2)
            isEnabled2 = DoesEntityExist
            isDisabled4 = playerPed
            isEnabled2 = isEnabled2(isDisabled4)
            if isEnabled2 then
                if 2 == A4_2 then
                    isEnabled2 = FreezeEntityPosition
                    isDisabled4 = playerPed
                    isEnabled9 = true
                    isEnabled2(isDisabled4, isEnabled9)
                    isEnabled2 = NetworkAllowLocalEntityAttachment
                    isDisabled4 = playerPed
                    isEnabled9 = true
                    isEnabled2(isDisabled4, isEnabled9)
                    isEnabled2 = AttachEntityToEntity
                    isDisabled4 = playerPed
                    isEnabled9 = dataTable9.seathandlermain
                    hash2 = 0
                    isEnabled13 = hash.offsets
                    isEnabled13 = isEnabled13.coords
                    isEnabled13 = isEnabled13.x
                    isEnabled8 = hash.offsets
                    isEnabled8 = isEnabled8.coords
                    isEnabled8 = isEnabled8.y
                    isEnabled7 = hash.offsets
                    isEnabled7 = isEnabled7.coords
                    isEnabled7 = isEnabled7.z
                    isEnabled7 = isEnabled7 + 0.1
                    isEnabled10 = 0.0
                    isEnabled4 = 0.0
                    isDisabled5 = hash.offsets
                    isDisabled5 = isDisabled5.heading
                    isEnabled11 = false
                    isEnabled6 = false
                    isEnabled5 = true
                    isEnabled14 = false
                    isDisabled = 2
                    isEnabled = true
                    isEnabled2(isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled)
                    isEnabled2 = "rtxthemepark"
                    isDisabled4 = "rtxhandsup_clip"
                    while true do
                        isEnabled9 = HasAnimDictLoaded
                        hash2 = isEnabled2
                        isEnabled9 = isEnabled9(hash2)
                        if isEnabled9 then
                            break
                        end
                        isEnabled9 = RequestAnimDict
                        hash2 = isEnabled2
                        isEnabled9(hash2)
                        isEnabled9 = Citizen
                        isEnabled9 = isEnabled9.Wait
                        hash2 = 5
                        isEnabled9(hash2)
                    end
                    isEnabled9 = TaskPlayAnim
                    hash2 = playerPed
                    isEnabled13 = isEnabled2
                    isEnabled8 = isDisabled4
                    isEnabled7 = 8.0
                    isEnabled10 = 8.0
                    isEnabled4 = -1
                    isDisabled5 = 1
                    isEnabled11 = 0
                    isEnabled6 = 0
                    isEnabled5 = 0
                    isEnabled14 = 0
                    isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14)
                else
                    isEnabled2 = FreezeEntityPosition
                    isDisabled4 = playerPed
                    isEnabled9 = true
                    isEnabled2(isDisabled4, isEnabled9)
                    isEnabled2 = NetworkAllowLocalEntityAttachment
                    isDisabled4 = playerPed
                    isEnabled9 = true
                    isEnabled2(isDisabled4, isEnabled9)
                    isEnabled2 = AttachEntityToEntity
                    isDisabled4 = playerPed
                    isEnabled9 = dataTable9.seathandlermain
                    hash2 = 0
                    isEnabled13 = hash.offsets
                    isEnabled13 = isEnabled13.coords
                    isEnabled13 = isEnabled13.x
                    isEnabled8 = hash.offsets
                    isEnabled8 = isEnabled8.coords
                    isEnabled8 = isEnabled8.y
                    isEnabled7 = hash.offsets
                    isEnabled7 = isEnabled7.coords
                    isEnabled7 = isEnabled7.z
                    isEnabled10 = 0.0
                    isEnabled4 = 0.0
                    isDisabled5 = hash.offsets
                    isDisabled5 = isDisabled5.heading
                    isEnabled11 = false
                    isEnabled6 = false
                    isEnabled5 = true
                    isEnabled14 = false
                    isDisabled = 2
                    isEnabled = true
                    isEnabled2(isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled)
                    isEnabled2 = "amb@prop_human_seat_chair_mp@female@proper@idle_a"
                    isDisabled4 = "idle_b"
                    while true do
                        isEnabled9 = HasAnimDictLoaded
                        hash2 = isEnabled2
                        isEnabled9 = isEnabled9(hash2)
                        if isEnabled9 then
                            break
                        end
                        isEnabled9 = RequestAnimDict
                        hash2 = isEnabled2
                        isEnabled9(hash2)
                        isEnabled9 = Citizen
                        isEnabled9 = isEnabled9.Wait
                        hash2 = 5
                        isEnabled9(hash2)
                    end
                    isEnabled9 = TaskPlayAnim
                    hash2 = playerPed
                    isEnabled13 = isEnabled2
                    isEnabled8 = isDisabled4
                    isEnabled7 = 8.0
                    isEnabled10 = 8.0
                    isEnabled4 = -1
                    isDisabled5 = 1
                    isEnabled11 = 0
                    isEnabled6 = 0
                    isEnabled5 = 0
                    isEnabled14 = 0
                    isEnabled9(hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14)
                end
            end
        end
    end
end
coords(dataTable7, dataTable5)
coords = RegisterNetEvent
dataTable7 = "rtx_themepark:GForce:SynchronizeCageClient"
coords(dataTable7)
coords = AddEventHandler
dataTable7 = "rtx_themepark:GForce:SynchronizeCageClient"

function dataTable5(A0_2, A1_2)
    local dataTable10, dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15
    dataTable10 = gforcehandler
    dataTable10 = dataTable10.seats
    dataTable10 = dataTable10[A0_2]
    dataTable10.cageclosed = A1_2
    if true == A1_2 then
        dataTable = 0.0
        while dataTable < 70.0 do
            dataTable4 = Citizen
            dataTable4 = dataTable4.Wait
            dataTable9 = 10
            dataTable4(dataTable9)
            dataTable = dataTable + 0.25
            dataTable4 = ipairs
            dataTable9 = dataTable10.seathandlercage
            dataTable4, dataTable9, hash, isDisabled6 = dataTable4(dataTable9)
            for playerPed, isEnabled2 in dataTable4, dataTable9, hash, isDisabled6 do
                isDisabled4 = DoesEntityExist
                isEnabled9 = isEnabled2.handler
                isDisabled4 = isDisabled4(isEnabled9)
                if isDisabled4 then
                    if 1 == playerPed then
                        isDisabled4 = AttachEntityToEntity
                        isEnabled9 = isEnabled2.handler
                        hash2 = dataTable10.seathandlermain
                        isEnabled13 = 0
                        isEnabled8 = 0.24
                        isEnabled7 = -0.68
                        isEnabled10 = 0.9
                        isEnabled4 = 0.0
                        isDisabled5 = dataTable
                        isEnabled11 = -180.0
                        isEnabled6 = false
                        isEnabled5 = false
                        isEnabled14 = false
                        isDisabled = false
                        isEnabled = 2
                        isEnabled15 = true
                        isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                    else
                        isDisabled4 = AttachEntityToEntity
                        isEnabled9 = isEnabled2.handler
                        hash2 = dataTable10.seathandlermain
                        isEnabled13 = 0
                        isEnabled8 = -0.24
                        isEnabled7 = -0.68
                        isEnabled10 = 0.9
                        isEnabled4 = 0.0
                        isDisabled5 = dataTable
                        isEnabled11 = 0.0
                        isEnabled6 = false
                        isEnabled5 = false
                        isEnabled14 = false
                        isDisabled = false
                        isEnabled = 2
                        isEnabled15 = true
                        isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                    end
                end
            end
        end
        dataTable4 = ipairs
        dataTable9 = dataTable10.seathandlercage
        dataTable4, dataTable9, hash, isDisabled6 = dataTable4(dataTable9)
        for playerPed, isEnabled2 in dataTable4, dataTable9, hash, isDisabled6 do
            isDisabled4 = DoesEntityExist
            isEnabled9 = isEnabled2.handler
            isDisabled4 = isDisabled4(isEnabled9)
            if isDisabled4 then
                if 1 == playerPed then
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = isEnabled2.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = 0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = 70.0
                    isEnabled11 = -180.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                else
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = isEnabled2.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = -0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = 70.0
                    isEnabled11 = 0.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                end
            end
        end
    else
        dataTable = 70.0
        while dataTable > 0.0 do
            dataTable4 = Citizen
            dataTable4 = dataTable4.Wait
            dataTable9 = 10
            dataTable4(dataTable9)
            dataTable = dataTable - 0.25
            dataTable4 = ipairs
            dataTable9 = dataTable10.seathandlercage
            dataTable4, dataTable9, hash, isDisabled6 = dataTable4(dataTable9)
            for playerPed, isEnabled2 in dataTable4, dataTable9, hash, isDisabled6 do
                isDisabled4 = DoesEntityExist
                isEnabled9 = isEnabled2.handler
                isDisabled4 = isDisabled4(isEnabled9)
                if isDisabled4 then
                    if 1 == playerPed then
                        isDisabled4 = AttachEntityToEntity
                        isEnabled9 = isEnabled2.handler
                        hash2 = dataTable10.seathandlermain
                        isEnabled13 = 0
                        isEnabled8 = 0.24
                        isEnabled7 = -0.68
                        isEnabled10 = 0.9
                        isEnabled4 = 0.0
                        isDisabled5 = dataTable
                        isEnabled11 = -180.0
                        isEnabled6 = false
                        isEnabled5 = false
                        isEnabled14 = false
                        isDisabled = false
                        isEnabled = 2
                        isEnabled15 = true
                        isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                    else
                        isDisabled4 = AttachEntityToEntity
                        isEnabled9 = isEnabled2.handler
                        hash2 = dataTable10.seathandlermain
                        isEnabled13 = 0
                        isEnabled8 = -0.24
                        isEnabled7 = -0.68
                        isEnabled10 = 0.9
                        isEnabled4 = 0.0
                        isDisabled5 = dataTable
                        isEnabled11 = 0.0
                        isEnabled6 = false
                        isEnabled5 = false
                        isEnabled14 = false
                        isDisabled = false
                        isEnabled = 2
                        isEnabled15 = true
                        isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                    end
                end
            end
        end
        dataTable4 = ipairs
        dataTable9 = dataTable10.seathandlercage
        dataTable4, dataTable9, hash, isDisabled6 = dataTable4(dataTable9)
        for playerPed, isEnabled2 in dataTable4, dataTable9, hash, isDisabled6 do
            isDisabled4 = DoesEntityExist
            isEnabled9 = isEnabled2.handler
            isDisabled4 = isDisabled4(isEnabled9)
            if isDisabled4 then
                if 1 == playerPed then
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = isEnabled2.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = 0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = 0.0
                    isEnabled11 = -180.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                else
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = isEnabled2.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = -0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = 0.0
                    isEnabled11 = 0.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                end
            end
        end
    end
end
coords(dataTable7, dataTable5)
coords = RegisterNetEvent
dataTable7 = "rtx_themepark:GForce:SynchronizeCageClientResync"
coords(dataTable7)
coords = AddEventHandler
dataTable7 = "rtx_themepark:GForce:SynchronizeCageClientResync"

function dataTable5(A0_2, A1_2)
    local dataTable10, dataTable, dataTable4, dataTable9, hash, isDisabled6, playerPed, isEnabled2, isDisabled4, isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15
    dataTable10 = gforcehandler
    dataTable10 = dataTable10.seats
    dataTable10 = dataTable10[A0_2]
    dataTable10.cageclosed = A1_2
    if true == A1_2 then
        dataTable = ipairs
        dataTable4 = dataTable10.seathandlercage
        dataTable, dataTable4, dataTable9, hash = dataTable(dataTable4)
        for isDisabled6, playerPed in dataTable, dataTable4, dataTable9, hash do
            isEnabled2 = DoesEntityExist
            isDisabled4 = playerPed.handler
            isEnabled2 = isEnabled2(isDisabled4)
            if isEnabled2 then
                if 1 == isDisabled6 then
                    isEnabled2 = 0.0
                    if false == A1_2 then
                        isEnabled2 = 70.0
                    end
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = playerPed.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = 0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = isEnabled2
                    isEnabled11 = -180.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                else
                    isEnabled2 = 0.0
                    if false == A1_2 then
                        isEnabled2 = 70.0
                    end
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = playerPed.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = -0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = isEnabled2
                    isEnabled11 = 0.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                end
            end
        end
    else
        dataTable = ipairs
        dataTable4 = dataTable10.seathandlercage
        dataTable, dataTable4, dataTable9, hash = dataTable(dataTable4)
        for isDisabled6, playerPed in dataTable, dataTable4, dataTable9, hash do
            isEnabled2 = DoesEntityExist
            isDisabled4 = playerPed.handler
            isEnabled2 = isEnabled2(isDisabled4)
            if isEnabled2 then
                if 1 == isDisabled6 then
                    isEnabled2 = 0.0
                    if false == A1_2 then
                        isEnabled2 = 70.0
                    end
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = playerPed.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = 0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = isEnabled2
                    isEnabled11 = -180.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                else
                    isEnabled2 = 0.0
                    if false == A1_2 then
                        isEnabled2 = 70.0
                    end
                    isDisabled4 = AttachEntityToEntity
                    isEnabled9 = playerPed.handler
                    hash2 = dataTable10.seathandlermain
                    isEnabled13 = 0
                    isEnabled8 = -0.24
                    isEnabled7 = -0.68
                    isEnabled10 = 0.9
                    isEnabled4 = 0.0
                    isDisabled5 = isEnabled2
                    isEnabled11 = 0.0
                    isEnabled6 = false
                    isEnabled5 = false
                    isEnabled14 = false
                    isDisabled = false
                    isEnabled = 2
                    isEnabled15 = true
                    isDisabled4(isEnabled9, hash2, isEnabled13, isEnabled8, isEnabled7, isEnabled10, isEnabled4, isDisabled5, isEnabled11, isEnabled6, isEnabled5, isEnabled14, isDisabled, isEnabled, isEnabled15)
                end
            end
        end
    end
end
coords(dataTable7, dataTable5)
coords = Config
coords = coords.Target
if false == coords then
    coords = RegisterCommand
    dataTable7 = "usegforceseat"

    function dataTable5()
        local hash3, isEnabled12, dataTable10, dataTable
        hash3 = usingattraction
        if false == hash3 then
            hash3 = dataTable2.seatcategoryid
            if nil ~= hash3 then
                hash3 = dataTable2.seatid
                if nil ~= hash3 then
                    hash3 = iteminhand
                    if false == hash3 then
                        hash3 = TriggerServerEvent
                        isEnabled12 = "rtx_themepark:GForce:SeatUse"
                        dataTable10 = dataTable2.seatcategoryid
                        dataTable = dataTable2.seatid
                        hash3(isEnabled12, dataTable10, dataTable)
                    else
                        hash3 = Notify
                        isEnabled12 = Language
                        dataTable10 = Config
                        dataTable10 = dataTable10.Language
                        isEnabled12 = isEnabled12[dataTable10]
                        isEnabled12 = isEnabled12.iteminhand
                        hash3(isEnabled12)
                    end
                end
            end
        end
    end
    coords(dataTable7, dataTable5)
    coords = RegisterKeyMapping
    dataTable7 = "usegforceseat"
    dataTable5 = Language
    dataTable3 = Config
    dataTable3 = dataTable3.Language
    dataTable5 = dataTable5[dataTable3]
    dataTable5 = dataTable5.bindgforceseatuse
    dataTable3 = "keyboard"
    dataTable6 = Config
    dataTable6 = dataTable6.ThemeParkSeatKey
    coords(dataTable7, dataTable5, dataTable3, dataTable6)
end
coords = RegisterCommand
dataTable7 = "changegforceanim"

function dataTable5()
    local hash3, isEnabled12, dataTable10, dataTable
    hash3 = usingattraction
    if true == hash3 then
        hash3 = var13
        if nil ~= hash3 then
            hash3 = var14
            if nil ~= hash3 then
                hash3 = isDisabled7
                if false == hash3 then
                    hash3 = true
                    isDisabled7 = hash3
                    hash3 = TriggerServerEvent
                    isEnabled12 = "rtx_themepark:GForce:SeatAnimChange"
                    dataTable10 = var13
                    dataTable = var14
                    hash3(isEnabled12, dataTable10, dataTable)
                    hash3 = Citizen
                    hash3 = hash3.Wait
                    isEnabled12 = Config
                    isEnabled12 = isEnabled12.AttractionsSettings
                    isEnabled12 = isEnabled12.gforce
                    isEnabled12 = isEnabled12.animcooldown
                    hash3(isEnabled12)
                    hash3 = false
                    isDisabled7 = hash3
                end
            end
        end
    end
end
coords(dataTable7, dataTable5)
coords = RegisterKeyMapping
dataTable7 = "changegforceanim"
dataTable5 = Language
dataTable3 = Config
dataTable3 = dataTable3.Language
dataTable5 = dataTable5[dataTable3]
dataTable5 = dataTable5.bindattractionanimchange
dataTable3 = "keyboard"
dataTable6 = Config
dataTable6 = dataTable6.ThemeParkAnimChangeKey
coords(dataTable7, dataTable5, dataTable3, dataTable6)
coords = RegisterCommand
dataTable7 = "exitgforce"

function dataTable5()
    local hash3, isEnabled12, dataTable10, dataTable
    hash3 = usingattraction
    if true == hash3 then
        hash3 = var13
        if nil ~= hash3 then
            hash3 = var14
            if nil ~= hash3 then
                hash3 = Config
                hash3 = hash3.ThemeParkDisableExit
                if false ~= hash3 then
                    hash3 = gforcehandler
                    hash3 = hash3.started
                    if false ~= hash3 then
                        goto lbl_24
                    end
                end
                hash3 = TriggerServerEvent
                isEnabled12 = "rtx_themepark:GForce:ExitAttraction"
                dataTable10 = var13
                dataTable = var14
                hash3(isEnabled12, dataTable10, dataTable)
                goto lbl_31
                ::lbl_24::
                hash3 = Notify
                isEnabled12 = Language
                dataTable10 = Config
                dataTable10 = dataTable10.Language
                isEnabled12 = isEnabled12[dataTable10]
                isEnabled12 = isEnabled12.inprogress
                hash3(isEnabled12)
            end
        end
    end
    ::lbl_31::
end
coords(dataTable7, dataTable5)
coords = RegisterKeyMapping
dataTable7 = "exitgforce"
dataTable5 = Language
dataTable3 = Config
dataTable3 = dataTable3.Language
dataTable5 = dataTable5[dataTable3]
dataTable5 = dataTable5.bindattractionexitkey
dataTable3 = "keyboard"
dataTable6 = Config
dataTable6 = dataTable6.ThemeParkExitKey
coords(dataTable7, dataTable5, dataTable3, dataTable6)