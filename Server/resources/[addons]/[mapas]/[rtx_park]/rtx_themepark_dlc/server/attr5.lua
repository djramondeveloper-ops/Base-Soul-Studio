
local dataTable, coords, dataTable2, var12, var1
dataTable = {}
coords = vector3
dataTable2 = -1656.25
var12 = -1120.387
var1 = 30.07145
coords = coords(dataTable2, var12, var1)
dataTable.coords = coords
dataTable.started = false
dataTable.currentrotation = 0.0
dataTable.stageinprogress = false
dataTable.stage = 16
dataTable.stagecounter = 0
dataTable.stagespeed = 0.5
dataTable.cageclosed = false
coords = {}
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[1] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[2] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[3] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[4] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[5] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[6] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[7] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[8] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[9] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[10] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[11] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[12] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[13] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[14] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[15] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[16] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[17] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[18] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[19] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[20] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[21] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[22] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[23] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[24] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[25] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[26] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[27] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[28] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[29] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[30] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[31] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
coords[32] = dataTable2
dataTable.seats = coords
boathandler = dataTable

function dataTable(A0_2, A1_2, A2_2)
    local isEnabled, isDisabled2, value2, isEnabled3
    isEnabled = Config
    isEnabled = isEnabled.AttractionsSettings
    isEnabled = isEnabled.boat
    isEnabled = isEnabled.speedmodifier
    isEnabled = A0_2 * isEnabled
    isDisabled2 = A1_2 / A2_2
    isDisabled2 = isDisabled2 * 100.0
    if isDisabled2 > 60.0 then
        value2 = 130.0
        value2 = value2 - isDisabled2
        isEnabled3 = value2 / 100.0
        isEnabled3 = isEnabled3 * isEnabled
        return isEnabled3
    elseif isDisabled2 < 20.0 then
        value2 = 130.0
        value2 = value2 - isDisabled2
        isEnabled3 = 100.0
        isEnabled3 = isEnabled3 / value2
        isEnabled3 = isEnabled3 * isEnabled
        return isEnabled3
    else
        return isEnabled
    end
end
CalculateSpeedBoat = dataTable
dataTable = GlobalState
dataTable["attraction5 - phase"] = 0
dataTable = GlobalState
dataTable["attraction5 - ridedata1"] = 0.0
dataTable = GlobalState
dataTable["attraction5 - speeddata1"] = 0.1
dataTable = GlobalState
dataTable["attraction5 - direction"] = 1
dataTable = GlobalState
dataTable["attraction5 - stop"] = false
dataTable = GlobalState
dataTable["attraction5 - synchdata"] = 1

function dataTable()
    local isEnabled7, strValue2, counter, isEnabled, isDisabled2, value2, isEnabled3, isEnabled6, strValue4, isEnabled2, isEnabled5, isDisabled3, value, strValue3, strValue, var2, isEnabled4, isDisabled, var23, var22
    isEnabled7 = boathandler
    isEnabled7 = isEnabled7.started
    if true == isEnabled7 then
        isEnabled7 = boathandler
        isEnabled7.cageclosed = true
        isEnabled7 = TriggerClientEvent
        strValue2 = "rtx_themepark:Boat:SynchronizeCageClient"
        counter = -1
        isEnabled = true
        isEnabled7(strValue2, counter, isEnabled)
        isEnabled7 = Citizen
        isEnabled7 = isEnabled7.Wait
        strValue2 = 7500
        isEnabled7(strValue2)
        isEnabled7 = TriggerClientEvent
        strValue2 = "rtx_themepark:Global:MusicStartAttraction"
        counter = -1
        isEnabled = "boat"
        isDisabled2 = math
        isDisabled2 = isDisabled2.random
        value2 = 1
        isEnabled3 = Config
        isEnabled3 = isEnabled3.AttractionsMusic
        isEnabled3 = isEnabled3.boat
        isEnabled3 = isEnabled3.playlist
        isEnabled3 = #isEnabled3
        isDisabled2, value2, isEnabled3, isEnabled6, strValue4, isEnabled2, isEnabled5, isDisabled3, value, strValue3, strValue, var2, isEnabled4, isDisabled, var23, var22 = isDisabled2(value2, isEnabled3)
        isEnabled7(strValue2, counter, isEnabled, isDisabled2, value2, isEnabled3, isEnabled6, strValue4, isEnabled2, isEnabled5, isDisabled3, value, strValue3, strValue, var2, isEnabled4, isDisabled, var23, var22)
        isEnabled7 = boathandler
        isEnabled7.stageinprogress = true
        isEnabled7 = boathandler
        isEnabled7.stage = 1
        isEnabled7 = boathandler
        isEnabled7.stagecounter = 0
        isEnabled7 = boathandler
        isEnabled7.stagespeed = 0.5
        isEnabled7 = boathandler
        isEnabled7.stagedirection = 1
        isEnabled7 = GlobalState
        isEnabled7["attraction5 - phase"] = 1
        isEnabled7 = GlobalState
        isEnabled7["attraction5 - ridedata1"] = 0.0
        isEnabled7 = GlobalState
        isEnabled7["attraction5 - speeddata1"] = 0.1
        isEnabled7 = GlobalState
        isEnabled7["attraction5 - direction"] = 1
        isEnabled7 = GlobalState
        isEnabled7["attraction5 - stop"] = false
        isEnabled7 = GlobalState
        isEnabled7["attraction5 - synchdata"] = 1
        isEnabled7 = ipairs
        strValue2 = boathandler
        strValue2 = strValue2.seats
        isEnabled7, strValue2, counter, isEnabled = isEnabled7(strValue2)
        for isDisabled2, value2 in isEnabled7, strValue2, counter, isEnabled do
            isEnabled3 = value2.taken
            if true == isEnabled3 then
                isEnabled3 = pairs
                isEnabled6 = playsersinthemepark
                isEnabled3, isEnabled6, strValue4, isEnabled2 = isEnabled3(isEnabled6)
                for isEnabled5, isDisabled3 in isEnabled3, isEnabled6, strValue4, isEnabled2 do
                    value = TriggerClientEvent
                    strValue3 = "rtx_themepark:Boat:SynchronizeSeat"
                    strValue = isDisabled3
                    var2 = isDisabled2
                    isEnabled4 = true
                    isDisabled = value2.takenplayerid
                    var23 = value2.seattype
                    value(strValue3, strValue, var2, isEnabled4, isDisabled, var23)
                end
                isEnabled3 = TriggerClientEvent
                isEnabled6 = "rtx_themepark:Global:AttractionUsing"
                strValue4 = value2.takenplayerid
                isEnabled2 = true
                isEnabled3(isEnabled6, strValue4, isEnabled2)
            end
        end
        isEnabled7 = false
        while true do
            strValue2 = boathandler
            strValue2 = strValue2.stageinprogress
            if true ~= strValue2 then
                break
            end
            strValue2 = Citizen
            strValue2 = strValue2.Wait
            counter = 20
            strValue2(counter)
            if true == isEnabled7 then
                strValue2 = Citizen
                strValue2 = strValue2.Wait
                counter = 80
                strValue2(counter)
                isEnabled7 = false
            end
            strValue2 = boathandler
            strValue2 = strValue2.stage
            if 1 == strValue2 then
                strValue2 = boathandler
                strValue2 = strValue2.stagedirection
                if 1 == strValue2 then
                    strValue2 = boathandler
                    counter = CalculateSpeedBoat
                    isEnabled = 0.1
                    isDisabled2 = boathandler
                    isDisabled2 = isDisabled2.currentrotation
                    value2 = 5.0
                    counter = counter(isEnabled, isDisabled2, value2)
                    strValue2.stagespeed = counter
                    strValue2 = boathandler
                    strValue2 = strValue2.currentrotation
                    if strValue2 > 5.0 then
                        strValue2 = boathandler
                        strValue2.stagedirection = 2
                    end
                    strValue2 = boathandler
                    counter = boathandler
                    counter = counter.currentrotation
                    isEnabled = boathandler
                    isEnabled = isEnabled.stagespeed
                    counter = counter + isEnabled
                    strValue2.currentrotation = counter
                else
                    strValue2 = boathandler
                    counter = CalculateSpeedBoat
                    isEnabled = 0.1
                    isDisabled2 = boathandler
                    isDisabled2 = isDisabled2.currentrotation
                    value2 = -5.0
                    counter = counter(isEnabled, isDisabled2, value2)
                    strValue2.stagespeed = counter
                    strValue2 = boathandler
                    strValue2 = strValue2.currentrotation
                    if strValue2 < -5.0 then
                        strValue2 = boathandler
                        strValue2.stagedirection = 1
                        strValue2 = boathandler
                        strValue2.stage = 2
                    end
                    strValue2 = boathandler
                    counter = boathandler
                    counter = counter.currentrotation
                    isEnabled = boathandler
                    isEnabled = isEnabled.stagespeed
                    counter = counter - isEnabled
                    strValue2.currentrotation = counter
                end
            else
                strValue2 = boathandler
                strValue2 = strValue2.stage
                if 2 == strValue2 then
                    strValue2 = boathandler
                    strValue2 = strValue2.stagedirection
                    if 1 == strValue2 then
                        strValue2 = boathandler
                        counter = CalculateSpeedBoat
                        isEnabled = 0.25
                        isDisabled2 = boathandler
                        isDisabled2 = isDisabled2.currentrotation
                        value2 = 10.0
                        counter = counter(isEnabled, isDisabled2, value2)
                        strValue2.stagespeed = counter
                        strValue2 = boathandler
                        strValue2 = strValue2.currentrotation
                        if strValue2 > 10.0 then
                            strValue2 = boathandler
                            strValue2.stagedirection = 2
                        end
                        strValue2 = boathandler
                        counter = boathandler
                        counter = counter.currentrotation
                        isEnabled = boathandler
                        isEnabled = isEnabled.stagespeed
                        counter = counter + isEnabled
                        strValue2.currentrotation = counter
                    else
                        strValue2 = boathandler
                        counter = CalculateSpeedBoat
                        isEnabled = 0.25
                        isDisabled2 = boathandler
                        isDisabled2 = isDisabled2.currentrotation
                        value2 = -10.0
                        counter = counter(isEnabled, isDisabled2, value2)
                        strValue2.stagespeed = counter
                        strValue2 = boathandler
                        strValue2 = strValue2.currentrotation
                        if strValue2 < -10.0 then
                            strValue2 = boathandler
                            strValue2.stagedirection = 1
                            strValue2 = boathandler
                            strValue2.stage = 3
                        end
                        strValue2 = boathandler
                        counter = boathandler
                        counter = counter.currentrotation
                        isEnabled = boathandler
                        isEnabled = isEnabled.stagespeed
                        counter = counter - isEnabled
                        strValue2.currentrotation = counter
                    end
                else
                    strValue2 = boathandler
                    strValue2 = strValue2.stage
                    if 3 == strValue2 then
                        strValue2 = boathandler
                        strValue2.stagespeed = 0.5
                        strValue2 = boathandler
                        strValue2 = strValue2.stagedirection
                        if 1 == strValue2 then
                            strValue2 = boathandler
                            counter = CalculateSpeedBoat
                            isEnabled = 0.5
                            isDisabled2 = boathandler
                            isDisabled2 = isDisabled2.currentrotation
                            value2 = 15.0
                            counter = counter(isEnabled, isDisabled2, value2)
                            strValue2.stagespeed = counter
                            strValue2 = boathandler
                            strValue2 = strValue2.currentrotation
                            if strValue2 > 15.0 then
                                strValue2 = boathandler
                                strValue2.stagedirection = 2
                                isEnabled7 = true
                            end
                            strValue2 = boathandler
                            counter = boathandler
                            counter = counter.currentrotation
                            isEnabled = boathandler
                            isEnabled = isEnabled.stagespeed
                            counter = counter + isEnabled
                            strValue2.currentrotation = counter
                        else
                            strValue2 = boathandler
                            counter = CalculateSpeedBoat
                            isEnabled = 0.5
                            isDisabled2 = boathandler
                            isDisabled2 = isDisabled2.currentrotation
                            value2 = -15.0
                            counter = counter(isEnabled, isDisabled2, value2)
                            strValue2.stagespeed = counter
                            strValue2 = boathandler
                            strValue2 = strValue2.currentrotation
                            if strValue2 < -15.0 then
                                strValue2 = boathandler
                                strValue2.stagedirection = 1
                                strValue2 = boathandler
                                strValue2.stage = 4
                                isEnabled7 = true
                            end
                            strValue2 = boathandler
                            counter = boathandler
                            counter = counter.currentrotation
                            isEnabled = boathandler
                            isEnabled = isEnabled.stagespeed
                            counter = counter - isEnabled
                            strValue2.currentrotation = counter
                        end
                    else
                        strValue2 = boathandler
                        strValue2 = strValue2.stage
                        if 4 == strValue2 then
                            strValue2 = boathandler
                            strValue2.stagespeed = 0.75
                            strValue2 = boathandler
                            strValue2 = strValue2.stagedirection
                            if 1 == strValue2 then
                                strValue2 = boathandler
                                counter = CalculateSpeedBoat
                                isEnabled = 0.75
                                isDisabled2 = boathandler
                                isDisabled2 = isDisabled2.currentrotation
                                value2 = 25.0
                                counter = counter(isEnabled, isDisabled2, value2)
                                strValue2.stagespeed = counter
                                strValue2 = boathandler
                                strValue2 = strValue2.currentrotation
                                if strValue2 > 25.0 then
                                    strValue2 = boathandler
                                    strValue2.stagedirection = 2
                                    isEnabled7 = true
                                end
                                strValue2 = boathandler
                                counter = boathandler
                                counter = counter.currentrotation
                                isEnabled = boathandler
                                isEnabled = isEnabled.stagespeed
                                counter = counter + isEnabled
                                strValue2.currentrotation = counter
                            else
                                strValue2 = boathandler
                                counter = CalculateSpeedBoat
                                isEnabled = 0.75
                                isDisabled2 = boathandler
                                isDisabled2 = isDisabled2.currentrotation
                                value2 = -25.0
                                counter = counter(isEnabled, isDisabled2, value2)
                                strValue2.stagespeed = counter
                                strValue2 = boathandler
                                strValue2 = strValue2.currentrotation
                                if strValue2 < -25.0 then
                                    strValue2 = boathandler
                                    strValue2.stagedirection = 1
                                    strValue2 = boathandler
                                    strValue2.stage = 5
                                    isEnabled7 = true
                                end
                                strValue2 = boathandler
                                counter = boathandler
                                counter = counter.currentrotation
                                isEnabled = boathandler
                                isEnabled = isEnabled.stagespeed
                                counter = counter - isEnabled
                                strValue2.currentrotation = counter
                            end
                        else
                            strValue2 = boathandler
                            strValue2 = strValue2.stage
                            if 5 == strValue2 then
                                strValue2 = boathandler
                                strValue2.stagespeed = 1.25
                                strValue2 = boathandler
                                strValue2 = strValue2.stagedirection
                                if 1 == strValue2 then
                                    strValue2 = boathandler
                                    counter = CalculateSpeedBoat
                                    isEnabled = 1.25
                                    isDisabled2 = boathandler
                                    isDisabled2 = isDisabled2.currentrotation
                                    value2 = 40.0
                                    counter = counter(isEnabled, isDisabled2, value2)
                                    strValue2.stagespeed = counter
                                    strValue2 = boathandler
                                    strValue2 = strValue2.currentrotation
                                    if strValue2 > 40.0 then
                                        strValue2 = boathandler
                                        strValue2.stagedirection = 2
                                        isEnabled7 = true
                                    end
                                    strValue2 = boathandler
                                    counter = boathandler
                                    counter = counter.currentrotation
                                    isEnabled = boathandler
                                    isEnabled = isEnabled.stagespeed
                                    counter = counter + isEnabled
                                    strValue2.currentrotation = counter
                                else
                                    strValue2 = boathandler
                                    counter = CalculateSpeedBoat
                                    isEnabled = 1.25
                                    isDisabled2 = boathandler
                                    isDisabled2 = isDisabled2.currentrotation
                                    value2 = -40.0
                                    counter = counter(isEnabled, isDisabled2, value2)
                                    strValue2.stagespeed = counter
                                    strValue2 = boathandler
                                    strValue2 = strValue2.currentrotation
                                    if strValue2 < -40.0 then
                                        strValue2 = boathandler
                                        strValue2.stagedirection = 1
                                        strValue2 = boathandler
                                        strValue2.stage = 6
                                        isEnabled7 = true
                                    end
                                    strValue2 = boathandler
                                    counter = boathandler
                                    counter = counter.currentrotation
                                    isEnabled = boathandler
                                    isEnabled = isEnabled.stagespeed
                                    counter = counter - isEnabled
                                    strValue2.currentrotation = counter
                                end
                            else
                                strValue2 = boathandler
                                strValue2 = strValue2.stage
                                if 6 == strValue2 then
                                    strValue2 = boathandler
                                    strValue2.stagespeed = 1.5
                                    strValue2 = boathandler
                                    strValue2 = strValue2.stagedirection
                                    if 1 == strValue2 then
                                        strValue2 = boathandler
                                        counter = CalculateSpeedBoat
                                        isEnabled = 1.5
                                        isDisabled2 = boathandler
                                        isDisabled2 = isDisabled2.currentrotation
                                        value2 = 55.0
                                        counter = counter(isEnabled, isDisabled2, value2)
                                        strValue2.stagespeed = counter
                                        strValue2 = boathandler
                                        strValue2 = strValue2.currentrotation
                                        if strValue2 > 55.0 then
                                            strValue2 = boathandler
                                            strValue2.stagedirection = 2
                                            isEnabled7 = true
                                        end
                                        strValue2 = boathandler
                                        counter = boathandler
                                        counter = counter.currentrotation
                                        isEnabled = boathandler
                                        isEnabled = isEnabled.stagespeed
                                        counter = counter + isEnabled
                                        strValue2.currentrotation = counter
                                    else
                                        strValue2 = boathandler
                                        counter = CalculateSpeedBoat
                                        isEnabled = 1.5
                                        isDisabled2 = boathandler
                                        isDisabled2 = isDisabled2.currentrotation
                                        value2 = -55.0
                                        counter = counter(isEnabled, isDisabled2, value2)
                                        strValue2.stagespeed = counter
                                        strValue2 = boathandler
                                        strValue2 = strValue2.currentrotation
                                        if strValue2 < -55.0 then
                                            strValue2 = boathandler
                                            strValue2.stagedirection = 1
                                            strValue2 = boathandler
                                            strValue2.stage = 7
                                            isEnabled7 = true
                                        end
                                        strValue2 = boathandler
                                        counter = boathandler
                                        counter = counter.currentrotation
                                        isEnabled = boathandler
                                        isEnabled = isEnabled.stagespeed
                                        counter = counter - isEnabled
                                        strValue2.currentrotation = counter
                                    end
                                else
                                    strValue2 = boathandler
                                    strValue2 = strValue2.stage
                                    if 7 == strValue2 then
                                        strValue2 = boathandler
                                        strValue2.stagespeed = 1.75
                                        strValue2 = boathandler
                                        strValue2 = strValue2.stagedirection
                                        if 1 == strValue2 then
                                            strValue2 = boathandler
                                            counter = CalculateSpeedBoat
                                            isEnabled = 1.75
                                            isDisabled2 = boathandler
                                            isDisabled2 = isDisabled2.currentrotation
                                            value2 = 80.0
                                            counter = counter(isEnabled, isDisabled2, value2)
                                            strValue2.stagespeed = counter
                                            strValue2 = boathandler
                                            strValue2 = strValue2.currentrotation
                                            if strValue2 > 80.0 then
                                                strValue2 = boathandler
                                                strValue2.stagedirection = 2
                                                strValue2 = boathandler
                                                counter = boathandler
                                                counter = counter.stagecounter
                                                counter = counter + 1
                                                strValue2.stagecounter = counter
                                                strValue2 = boathandler
                                                strValue2 = strValue2.stagecounter
                                                counter = Config
                                                counter = counter.AttractionsSettings
                                                counter = counter.boat
                                                counter = counter.maxrounds
                                                if strValue2 > counter then
                                                    strValue2 = boathandler
                                                    strValue2.stage = 8
                                                    isEnabled7 = true
                                                end
                                            end
                                            strValue2 = boathandler
                                            counter = boathandler
                                            counter = counter.currentrotation
                                            isEnabled = boathandler
                                            isEnabled = isEnabled.stagespeed
                                            counter = counter + isEnabled
                                            strValue2.currentrotation = counter
                                        else
                                            strValue2 = boathandler
                                            counter = CalculateSpeedBoat
                                            isEnabled = 1.75
                                            isDisabled2 = boathandler
                                            isDisabled2 = isDisabled2.currentrotation
                                            value2 = -80.0
                                            counter = counter(isEnabled, isDisabled2, value2)
                                            strValue2.stagespeed = counter
                                            strValue2 = boathandler
                                            strValue2 = strValue2.currentrotation
                                            if strValue2 < -80.0 then
                                                strValue2 = boathandler
                                                strValue2.stagedirection = 1
                                                isEnabled7 = true
                                            end
                                            strValue2 = boathandler
                                            counter = boathandler
                                            counter = counter.currentrotation
                                            isEnabled = boathandler
                                            isEnabled = isEnabled.stagespeed
                                            counter = counter - isEnabled
                                            strValue2.currentrotation = counter
                                        end
                                    else
                                        strValue2 = boathandler
                                        strValue2 = strValue2.stage
                                        if 8 == strValue2 then
                                            strValue2 = boathandler
                                            strValue2.stagespeed = 1.5
                                            strValue2 = boathandler
                                            strValue2 = strValue2.stagedirection
                                            if 1 == strValue2 then
                                                strValue2 = boathandler
                                                counter = CalculateSpeedBoat
                                                isEnabled = 1.5
                                                isDisabled2 = boathandler
                                                isDisabled2 = isDisabled2.currentrotation
                                                value2 = 55.0
                                                counter = counter(isEnabled, isDisabled2, value2)
                                                strValue2.stagespeed = counter
                                                strValue2 = boathandler
                                                strValue2 = strValue2.currentrotation
                                                if strValue2 > 55.0 then
                                                    strValue2 = boathandler
                                                    strValue2.stagedirection = 2
                                                    isEnabled7 = true
                                                end
                                                strValue2 = boathandler
                                                counter = boathandler
                                                counter = counter.currentrotation
                                                isEnabled = boathandler
                                                isEnabled = isEnabled.stagespeed
                                                counter = counter + isEnabled
                                                strValue2.currentrotation = counter
                                            else
                                                strValue2 = boathandler
                                                counter = CalculateSpeedBoat
                                                isEnabled = 1.5
                                                isDisabled2 = boathandler
                                                isDisabled2 = isDisabled2.currentrotation
                                                value2 = -55.0
                                                counter = counter(isEnabled, isDisabled2, value2)
                                                strValue2.stagespeed = counter
                                                strValue2 = boathandler
                                                strValue2 = strValue2.currentrotation
                                                if strValue2 < -55.0 then
                                                    strValue2 = boathandler
                                                    strValue2.stagedirection = 1
                                                    strValue2 = boathandler
                                                    strValue2.stage = 9
                                                    isEnabled7 = true
                                                end
                                                strValue2 = boathandler
                                                counter = boathandler
                                                counter = counter.currentrotation
                                                isEnabled = boathandler
                                                isEnabled = isEnabled.stagespeed
                                                counter = counter - isEnabled
                                                strValue2.currentrotation = counter
                                            end
                                        else
                                            strValue2 = boathandler
                                            strValue2 = strValue2.stage
                                            if 9 == strValue2 then
                                                strValue2 = boathandler
                                                strValue2.stagespeed = 1.25
                                                strValue2 = boathandler
                                                strValue2 = strValue2.stagedirection
                                                if 1 == strValue2 then
                                                    strValue2 = boathandler
                                                    counter = CalculateSpeedBoat
                                                    isEnabled = 1.25
                                                    isDisabled2 = boathandler
                                                    isDisabled2 = isDisabled2.currentrotation
                                                    value2 = 40.0
                                                    counter = counter(isEnabled, isDisabled2, value2)
                                                    strValue2.stagespeed = counter
                                                    strValue2 = boathandler
                                                    strValue2 = strValue2.currentrotation
                                                    if strValue2 > 40.0 then
                                                        strValue2 = boathandler
                                                        strValue2.stagedirection = 2
                                                        isEnabled7 = true
                                                    end
                                                    strValue2 = boathandler
                                                    counter = boathandler
                                                    counter = counter.currentrotation
                                                    isEnabled = boathandler
                                                    isEnabled = isEnabled.stagespeed
                                                    counter = counter + isEnabled
                                                    strValue2.currentrotation = counter
                                                else
                                                    strValue2 = boathandler
                                                    counter = CalculateSpeedBoat
                                                    isEnabled = 1.25
                                                    isDisabled2 = boathandler
                                                    isDisabled2 = isDisabled2.currentrotation
                                                    value2 = -40.0
                                                    counter = counter(isEnabled, isDisabled2, value2)
                                                    strValue2.stagespeed = counter
                                                    strValue2 = boathandler
                                                    strValue2 = strValue2.currentrotation
                                                    if strValue2 < -40.0 then
                                                        strValue2 = boathandler
                                                        strValue2.stagedirection = 1
                                                        strValue2 = boathandler
                                                        strValue2.stage = 10
                                                        isEnabled7 = true
                                                    end
                                                    strValue2 = boathandler
                                                    counter = boathandler
                                                    counter = counter.currentrotation
                                                    isEnabled = boathandler
                                                    isEnabled = isEnabled.stagespeed
                                                    counter = counter - isEnabled
                                                    strValue2.currentrotation = counter
                                                end
                                            else
                                                strValue2 = boathandler
                                                strValue2 = strValue2.stage
                                                if 10 == strValue2 then
                                                    strValue2 = boathandler
                                                    strValue2.stagespeed = 0.75
                                                    strValue2 = boathandler
                                                    strValue2 = strValue2.stagedirection
                                                    if 1 == strValue2 then
                                                        strValue2 = boathandler
                                                        counter = CalculateSpeedBoat
                                                        isEnabled = 0.75
                                                        isDisabled2 = boathandler
                                                        isDisabled2 = isDisabled2.currentrotation
                                                        value2 = 25.0
                                                        counter = counter(isEnabled, isDisabled2, value2)
                                                        strValue2.stagespeed = counter
                                                        strValue2 = boathandler
                                                        strValue2 = strValue2.currentrotation
                                                        if strValue2 > 25.0 then
                                                            strValue2 = boathandler
                                                            strValue2.stagedirection = 2
                                                            isEnabled7 = true
                                                        end
                                                        strValue2 = boathandler
                                                        counter = boathandler
                                                        counter = counter.currentrotation
                                                        isEnabled = boathandler
                                                        isEnabled = isEnabled.stagespeed
                                                        counter = counter + isEnabled
                                                        strValue2.currentrotation = counter
                                                    else
                                                        strValue2 = boathandler
                                                        counter = CalculateSpeedBoat
                                                        isEnabled = 0.75
                                                        isDisabled2 = boathandler
                                                        isDisabled2 = isDisabled2.currentrotation
                                                        value2 = -25.0
                                                        counter = counter(isEnabled, isDisabled2, value2)
                                                        strValue2.stagespeed = counter
                                                        strValue2 = boathandler
                                                        strValue2 = strValue2.currentrotation
                                                        if strValue2 < -25.0 then
                                                            strValue2 = boathandler
                                                            strValue2.stagedirection = 1
                                                            strValue2 = boathandler
                                                            strValue2.stage = 11
                                                            isEnabled7 = true
                                                        end
                                                        strValue2 = boathandler
                                                        counter = boathandler
                                                        counter = counter.currentrotation
                                                        isEnabled = boathandler
                                                        isEnabled = isEnabled.stagespeed
                                                        counter = counter - isEnabled
                                                        strValue2.currentrotation = counter
                                                    end
                                                else
                                                    strValue2 = boathandler
                                                    strValue2 = strValue2.stage
                                                    if 11 == strValue2 then
                                                        strValue2 = boathandler
                                                        strValue2.stagespeed = 0.5
                                                        strValue2 = boathandler
                                                        strValue2 = strValue2.stagedirection
                                                        if 1 == strValue2 then
                                                            strValue2 = boathandler
                                                            counter = CalculateSpeedBoat
                                                            isEnabled = 0.5
                                                            isDisabled2 = boathandler
                                                            isDisabled2 = isDisabled2.currentrotation
                                                            value2 = 15.0
                                                            counter = counter(isEnabled, isDisabled2, value2)
                                                            strValue2.stagespeed = counter
                                                            strValue2 = boathandler
                                                            strValue2 = strValue2.currentrotation
                                                            if strValue2 > 15.0 then
                                                                strValue2 = boathandler
                                                                strValue2.stagedirection = 2
                                                                isEnabled7 = true
                                                            end
                                                            strValue2 = boathandler
                                                            counter = boathandler
                                                            counter = counter.currentrotation
                                                            isEnabled = boathandler
                                                            isEnabled = isEnabled.stagespeed
                                                            counter = counter + isEnabled
                                                            strValue2.currentrotation = counter
                                                        else
                                                            strValue2 = boathandler
                                                            counter = CalculateSpeedBoat
                                                            isEnabled = 0.5
                                                            isDisabled2 = boathandler
                                                            isDisabled2 = isDisabled2.currentrotation
                                                            value2 = -15.0
                                                            counter = counter(isEnabled, isDisabled2, value2)
                                                            strValue2.stagespeed = counter
                                                            strValue2 = boathandler
                                                            strValue2 = strValue2.currentrotation
                                                            if strValue2 < -15.0 then
                                                                strValue2 = boathandler
                                                                strValue2.stagedirection = 1
                                                                strValue2 = boathandler
                                                                strValue2.stage = 12
                                                                isEnabled7 = true
                                                            end
                                                            strValue2 = boathandler
                                                            counter = boathandler
                                                            counter = counter.currentrotation
                                                            isEnabled = boathandler
                                                            isEnabled = isEnabled.stagespeed
                                                            counter = counter - isEnabled
                                                            strValue2.currentrotation = counter
                                                        end
                                                    else
                                                        strValue2 = boathandler
                                                        strValue2 = strValue2.stage
                                                        if 12 == strValue2 then
                                                            strValue2 = boathandler
                                                            strValue2.stagespeed = 0.25
                                                            strValue2 = boathandler
                                                            strValue2 = strValue2.stagedirection
                                                            if 1 == strValue2 then
                                                                strValue2 = boathandler
                                                                counter = CalculateSpeedBoat
                                                                isEnabled = 0.25
                                                                isDisabled2 = boathandler
                                                                isDisabled2 = isDisabled2.currentrotation
                                                                value2 = 10.0
                                                                counter = counter(isEnabled, isDisabled2, value2)
                                                                strValue2.stagespeed = counter
                                                                strValue2 = boathandler
                                                                strValue2 = strValue2.currentrotation
                                                                if strValue2 > 10.0 then
                                                                    strValue2 = boathandler
                                                                    strValue2.stagedirection = 2
                                                                    isEnabled7 = true
                                                                end
                                                                strValue2 = boathandler
                                                                counter = boathandler
                                                                counter = counter.currentrotation
                                                                isEnabled = boathandler
                                                                isEnabled = isEnabled.stagespeed
                                                                counter = counter + isEnabled
                                                                strValue2.currentrotation = counter
                                                            else
                                                                strValue2 = boathandler
                                                                counter = CalculateSpeedBoat
                                                                isEnabled = 0.25
                                                                isDisabled2 = boathandler
                                                                isDisabled2 = isDisabled2.currentrotation
                                                                value2 = -10.0
                                                                counter = counter(isEnabled, isDisabled2, value2)
                                                                strValue2.stagespeed = counter
                                                                strValue2 = boathandler
                                                                strValue2 = strValue2.currentrotation
                                                                if strValue2 < -10.0 then
                                                                    strValue2 = boathandler
                                                                    strValue2.stagedirection = 1
                                                                    strValue2 = boathandler
                                                                    strValue2.stage = 13
                                                                    isEnabled7 = true
                                                                end
                                                                strValue2 = boathandler
                                                                counter = boathandler
                                                                counter = counter.currentrotation
                                                                isEnabled = boathandler
                                                                isEnabled = isEnabled.stagespeed
                                                                counter = counter - isEnabled
                                                                strValue2.currentrotation = counter
                                                            end
                                                        else
                                                            strValue2 = boathandler
                                                            strValue2 = strValue2.stage
                                                            if 13 == strValue2 then
                                                                strValue2 = boathandler
                                                                strValue2.stagespeed = 0.1
                                                                strValue2 = boathandler
                                                                strValue2 = strValue2.stagedirection
                                                                if 1 == strValue2 then
                                                                    strValue2 = boathandler
                                                                    counter = CalculateSpeedBoat
                                                                    isEnabled = 0.1
                                                                    isDisabled2 = boathandler
                                                                    isDisabled2 = isDisabled2.currentrotation
                                                                    value2 = 5.0
                                                                    counter = counter(isEnabled, isDisabled2, value2)
                                                                    strValue2.stagespeed = counter
                                                                    strValue2 = boathandler
                                                                    strValue2 = strValue2.currentrotation
                                                                    if strValue2 > 5.0 then
                                                                        strValue2 = boathandler
                                                                        strValue2.stagedirection = 2
                                                                        isEnabled7 = true
                                                                    end
                                                                    strValue2 = boathandler
                                                                    counter = boathandler
                                                                    counter = counter.currentrotation
                                                                    isEnabled = boathandler
                                                                    isEnabled = isEnabled.stagespeed
                                                                    counter = counter + isEnabled
                                                                    strValue2.currentrotation = counter
                                                                else
                                                                    strValue2 = boathandler
                                                                    counter = CalculateSpeedBoat
                                                                    isEnabled = 0.1
                                                                    isDisabled2 = boathandler
                                                                    isDisabled2 = isDisabled2.currentrotation
                                                                    value2 = -5.0
                                                                    counter = counter(isEnabled, isDisabled2, value2)
                                                                    strValue2.stagespeed = counter
                                                                    strValue2 = boathandler
                                                                    strValue2 = strValue2.currentrotation
                                                                    if strValue2 < -5.0 then
                                                                        strValue2 = boathandler
                                                                        strValue2.stagedirection = 1
                                                                        strValue2 = boathandler
                                                                        strValue2.stage = 14
                                                                        isEnabled7 = true
                                                                    end
                                                                    strValue2 = boathandler
                                                                    counter = boathandler
                                                                    counter = counter.currentrotation
                                                                    isEnabled = boathandler
                                                                    isEnabled = isEnabled.stagespeed
                                                                    counter = counter - isEnabled
                                                                    strValue2.currentrotation = counter
                                                                end
                                                            else
                                                                strValue2 = boathandler
                                                                strValue2 = strValue2.stage
                                                                if 14 == strValue2 then
                                                                    strValue2 = boathandler
                                                                    strValue2.stagespeed = 0.1
                                                                    strValue2 = boathandler
                                                                    strValue2 = strValue2.stagedirection
                                                                    if 1 == strValue2 then
                                                                        strValue2 = boathandler
                                                                        counter = boathandler
                                                                        counter = counter.currentrotation
                                                                        isEnabled = boathandler
                                                                        isEnabled = isEnabled.stagespeed
                                                                        counter = counter + isEnabled
                                                                        strValue2.currentrotation = counter
                                                                        strValue2 = boathandler
                                                                        strValue2 = strValue2.currentrotation
                                                                        counter = 0.1
                                                                        if strValue2 > counter then
                                                                            strValue2 = boathandler
                                                                            strValue2.stage = 15
                                                                            isEnabled7 = true
                                                                        end
                                                                    end
                                                                else
                                                                    strValue2 = boathandler
                                                                    strValue2 = strValue2.stage
                                                                    if 15 == strValue2 then
                                                                        strValue2 = boathandler
                                                                        strValue2.currentrotation = 0.0
                                                                        strValue2 = boathandler
                                                                        strValue2.stage = 16
                                                                    else
                                                                        strValue2 = boathandler
                                                                        strValue2 = strValue2.stage
                                                                        if 16 == strValue2 then
                                                                            strValue2 = boathandler
                                                                            strValue2.cageclosed = false
                                                                            strValue2 = pairs
                                                                            counter = playsersinthemepark
                                                                            strValue2, counter, isEnabled, isDisabled2 = strValue2(counter)
                                                                            for value2, isEnabled3 in strValue2, counter, isEnabled, isDisabled2 do
                                                                                isEnabled6 = TriggerClientEvent
                                                                                strValue4 = "rtx_themepark:Boat:SynchronizeCageClient"
                                                                                isEnabled2 = isEnabled3
                                                                                isEnabled5 = false
                                                                                isEnabled6(strValue4, isEnabled2, isEnabled5)
                                                                            end
                                                                            strValue2 = Citizen
                                                                            strValue2 = strValue2.Wait
                                                                            counter = 7500
                                                                            strValue2(counter)
                                                                            strValue2 = ipairs
                                                                            counter = boathandler
                                                                            counter = counter.seats
                                                                            strValue2, counter, isEnabled, isDisabled2 = strValue2(counter)
                                                                            for value2, isEnabled3 in strValue2, counter, isEnabled, isDisabled2 do
                                                                                isEnabled6 = isEnabled3.taken
                                                                                if true == isEnabled6 then
                                                                                    isEnabled3.taken = false
                                                                                    isEnabled6 = pairs
                                                                                    strValue4 = playsersinthemepark
                                                                                    isEnabled6, strValue4, isEnabled2, isEnabled5 = isEnabled6(strValue4)
                                                                                    for isDisabled3, value in isEnabled6, strValue4, isEnabled2, isEnabled5 do
                                                                                        strValue3 = TriggerClientEvent
                                                                                        strValue = "rtx_themepark:Boat:SynchronizeSeat"
                                                                                        var2 = value
                                                                                        isEnabled4 = value2
                                                                                        isDisabled = false
                                                                                        var23 = isEnabled3.takenplayerid
                                                                                        var22 = isEnabled3.seattype
                                                                                        strValue3(strValue, var2, isEnabled4, isDisabled, var23, var22)
                                                                                    end
                                                                                    isEnabled6 = TriggerClientEvent
                                                                                    strValue4 = "rtx_themepark:Boat:SeatExit"
                                                                                    isEnabled2 = isEnabled3.takenplayerid
                                                                                    isEnabled5 = true
                                                                                    isEnabled6(strValue4, isEnabled2, isEnabled5)
                                                                                    isEnabled6 = TriggerClientEvent
                                                                                    strValue4 = "rtx_themepark:Global:AttractionUsing"
                                                                                    isEnabled2 = isEnabled3.takenplayerid
                                                                                    isEnabled5 = false
                                                                                    isEnabled6(strValue4, isEnabled2, isEnabled5)
                                                                                    isEnabled6 = TriggerClientEvent
                                                                                    strValue4 = "rtx_themepark:Global:TicketHandler"
                                                                                    isEnabled2 = isEnabled3.takenplayerid
                                                                                    isEnabled5 = 5
                                                                                    isDisabled3 = false
                                                                                    isEnabled6(strValue4, isEnabled2, isEnabled5, isDisabled3)
                                                                                    isEnabled3.takenplayerid = nil
                                                                                    isEnabled3.seattype = 1
                                                                                end
                                                                            end
                                                                            strValue2 = boathandler
                                                                            strValue2.stageinprogress = false
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
                                end
                            end
                        end
                    end
                end
            end
            strValue2 = GlobalState
            counter = boathandler
            counter = counter.stage
            strValue2["attraction5 - phase"] = counter
            strValue2 = GlobalState
            counter = boathandler
            counter = counter.currentrotation
            strValue2["attraction5 - ridedata1"] = counter
            strValue2 = GlobalState
            counter = boathandler
            counter = counter.stagespeed
            strValue2["attraction5 - speeddata1"] = counter
            strValue2 = GlobalState
            counter = boathandler
            counter = counter.stagedirection
            strValue2["attraction5 - direction"] = counter
            strValue2 = GlobalState
            strValue2["attraction5 - stop"] = isEnabled7
            strValue2 = GlobalState
            counter = GlobalState
            counter = counter["attraction5 - synchdata"]
            counter = counter + 1
            strValue2["attraction5 - synchdata"] = counter
        end
        strValue2 = TriggerClientEvent
        counter = "rtx_themepark:Global:MusicStopAttraction"
        isEnabled = -1
        isDisabled2 = "boat"
        strValue2(counter, isEnabled, isDisabled2)
        strValue2 = boathandler
        strValue2.currentrotation = 0.0
        strValue2 = GlobalState
        strValue2["attraction5 - phase"] = 0
        strValue2 = GlobalState
        strValue2["attraction5 - ridedata1"] = 0.0
        strValue2 = boathandler
        strValue2.started = false
        strValue2 = TriggerClientEvent
        counter = "rtx_themepark:Boat:SynchronizeStarted"
        isEnabled = -1
        isDisabled2 = false
        strValue2(counter, isEnabled, isDisabled2)
    end
end
StartBoat = dataTable
dataTable = RegisterServerEvent
coords = "rtx_themepark:Boat:SeatUse"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:Boat:SeatUse"

function dataTable2(A0_2)
    local strValue2, counter, isEnabled, isDisabled2, value2, isEnabled3, isEnabled6, strValue4, isEnabled2
    strValue2 = source
    counter = themeparkattractionsopenstatus
    counter = counter[10]
    if true == counter then
        counter = themeparkdisabled
        if false == counter then
            if nil ~= A0_2 then
                counter = boathandler
                counter = counter.started
                if false == counter then
                    counter = boathandler
                    counter = counter.seats
                    counter = counter[A0_2]
                    isEnabled = counter.taken
                    if false == isEnabled then
                        counter.taken = true
                        counter.takenplayerid = strValue2
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Boat:SynchronizeSeat"
                        value2 = -1
                        isEnabled3 = A0_2
                        isEnabled6 = true
                        strValue4 = counter.takenplayerid
                        isEnabled2 = counter.seattype
                        isEnabled(isDisabled2, value2, isEnabled3, isEnabled6, strValue4, isEnabled2)
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Boat:SeatData"
                        value2 = strValue2
                        isEnabled3 = A0_2
                        isEnabled(isDisabled2, value2, isEnabled3)
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Boat:DisableCollision"
                        value2 = strValue2
                        isEnabled3 = false
                        isEnabled(isDisabled2, value2, isEnabled3)
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Global:AttractionUsing"
                        value2 = strValue2
                        isEnabled3 = true
                        isEnabled(isDisabled2, value2, isEnabled3)
                        isEnabled = Config
                        isEnabled = isEnabled.ThemeParkControlAttractions
                        if false == isEnabled then
                            isEnabled = boathandler
                            isEnabled = isEnabled.started
                            if false == isEnabled then
                                isEnabled = attractionlockdown
                                if false == isEnabled then
                                    isEnabled = Wait
                                    isDisabled2 = Config
                                    isDisabled2 = isDisabled2.AttractionsSettings
                                    isDisabled2 = isDisabled2.boat
                                    isDisabled2 = isDisabled2.waitforplayers
                                    isEnabled(isDisabled2)
                                    isEnabled = boathandler
                                    isEnabled = isEnabled.started
                                    if false == isEnabled then
                                        isEnabled = boathandler
                                        isEnabled.started = true
                                        isEnabled = TriggerClientEvent
                                        isDisabled2 = "rtx_themepark:Boat:SynchronizeStarted"
                                        value2 = -1
                                        isEnabled3 = true
                                        isEnabled(isDisabled2, value2, isEnabled3)
                                        isEnabled = StartBoat
                                        isEnabled()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        counter = TriggerClientEvent
        isEnabled = "rtx_themepark:Notify"
        isDisabled2 = strValue2
        value2 = Language
        isEnabled3 = Config
        isEnabled3 = isEnabled3.Language
        value2 = value2[isEnabled3]
        value2 = value2.attractionclosed
        counter(isEnabled, isDisabled2, value2)
    end
end
dataTable(coords, dataTable2)
dataTable = RegisterServerEvent
coords = "rtx_themepark:Boat:SeatAnimChange"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:Boat:SeatAnimChange"

function dataTable2(A0_2)
    local strValue2, counter, isEnabled, isDisabled2, value2, isEnabled3, isEnabled6, strValue4, isEnabled2
    strValue2 = source
    if nil ~= A0_2 then
        counter = boathandler
        counter = counter.seats
        counter = counter[A0_2]
        isEnabled = counter.taken
        if true == isEnabled then
            isEnabled = counter.takenplayerid
            if isEnabled == strValue2 then
                isEnabled = counter.seattype
                if 1 == isEnabled then
                    counter.seattype = 2
                else
                    counter.seattype = 1
                end
                isEnabled = TriggerClientEvent
                isDisabled2 = "rtx_themepark:Boat:SynchronizeSeat"
                value2 = -1
                isEnabled3 = A0_2
                isEnabled6 = true
                strValue4 = counter.takenplayerid
                isEnabled2 = counter.seattype
                isEnabled(isDisabled2, value2, isEnabled3, isEnabled6, strValue4, isEnabled2)
            end
        end
    end
end
dataTable(coords, dataTable2)
dataTable = RegisterServerEvent
coords = "rtx_themepark:Boat:ExitAttraction"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:Boat:ExitAttraction"

function dataTable2(A0_2)
    local strValue2, counter, isEnabled, isDisabled2, value2, isEnabled3, isEnabled6, strValue4
    strValue2 = source
    if nil ~= A0_2 then
        counter = boathandler
        counter = counter.seats
        counter = counter[A0_2]
        isEnabled = counter.taken
        if true == isEnabled then
            isEnabled = counter.takenplayerid
            if isEnabled == strValue2 then
                isEnabled = Config
                isEnabled = isEnabled.ThemeParkDisableExit
                if false ~= isEnabled then
                    isEnabled = boathandler
                    isEnabled = isEnabled.started
                    if false ~= isEnabled then
                        goto lbl_47
                    end
                end
                isEnabled = TriggerClientEvent
                isDisabled2 = "rtx_themepark:Boat:DisableCollision"
                value2 = strValue2
                isEnabled3 = true
                isEnabled(isDisabled2, value2, isEnabled3)
                isEnabled = TriggerClientEvent
                isDisabled2 = "rtx_themepark:Boat:SynchronizeSeat"
                value2 = -1
                isEnabled3 = A0_2
                isEnabled6 = false
                strValue4 = counter.takenplayerid
                isEnabled(isDisabled2, value2, isEnabled3, isEnabled6, strValue4)
                isEnabled = TriggerClientEvent
                isDisabled2 = "rtx_themepark:Boat:SeatExit"
                value2 = counter.takenplayerid
                isEnabled3 = false
                isEnabled(isDisabled2, value2, isEnabled3)
                isEnabled = TriggerClientEvent
                isDisabled2 = "rtx_themepark:Global:AttractionUsing"
                value2 = counter.takenplayerid
                isEnabled3 = false
                isEnabled(isDisabled2, value2, isEnabled3)
                counter.taken = false
                counter.takenplayerid = nil
                counter.seattype = 1
                goto lbl_56
                ::lbl_47::
                isEnabled = TriggerClientEvent
                isDisabled2 = "rtx_themepark:Notify"
                value2 = strValue2
                isEnabled3 = Language
                isEnabled6 = Config
                isEnabled6 = isEnabled6.Language
                isEnabled3 = isEnabled3[isEnabled6]
                isEnabled3 = isEnabled3.inprogress
                isEnabled(isDisabled2, value2, isEnabled3)
            end
        end
    end
    ::lbl_56::
end
dataTable(coords, dataTable2)
dataTable = Config
dataTable = dataTable.ThemeParkAttractionFallChance
if dataTable then
    dataTable = Config
    dataTable = dataTable.ThemeParkFallSettings
    dataTable = dataTable.attractions
    dataTable = dataTable.boat
    if dataTable then
        dataTable = RegisterServerEvent
        coords = "rtx_themepark:Boat:ThrowAttraction"
        dataTable(coords)
        dataTable = AddEventHandler
        coords = "rtx_themepark:Boat:ThrowAttraction"

        function dataTable2(A0_2)
            local strValue2, counter, isEnabled, isDisabled2, value2, isEnabled3, isEnabled6, strValue4
            strValue2 = source
            if nil ~= A0_2 then
                counter = boathandler
                counter = counter.seats
                counter = counter[A0_2]
                isEnabled = counter.taken
                if true == isEnabled then
                    isEnabled = counter.takenplayerid
                    if isEnabled == strValue2 then
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Boat:DisableCollision"
                        value2 = strValue2
                        isEnabled3 = true
                        isEnabled(isDisabled2, value2, isEnabled3)
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Boat:SynchronizeSeat"
                        value2 = -1
                        isEnabled3 = A0_2
                        isEnabled6 = false
                        strValue4 = counter.takenplayerid
                        isEnabled(isDisabled2, value2, isEnabled3, isEnabled6, strValue4)
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Boat:SeatThrowClient"
                        value2 = counter.takenplayerid
                        isEnabled(isDisabled2, value2)
                        isEnabled = TriggerClientEvent
                        isDisabled2 = "rtx_themepark:Global:AttractionUsing"
                        value2 = counter.takenplayerid
                        isEnabled3 = false
                        isEnabled(isDisabled2, value2, isEnabled3)
                        counter.taken = false
                        counter.takenplayerid = nil
                        counter.seattype = 1
                    end
                end
            end
        end
        dataTable(coords, dataTable2)
    end
end