
local dataTable, coords, dataTable2, var12, var1
dataTable = {}
coords = vector3
dataTable2 = -1707.20227
var12 = -1119.9856
var1 = 34.3946571
coords = coords(dataTable2, var12, var1)
dataTable.coords = coords
dataTable.started = false
dataTable.currentrotation = 0.0
dataTable.currentrotation2 = 0.0
dataTable.stageinprogress = false
dataTable.stage = 16
dataTable.stagecounter = 0
dataTable.stagespeed = 0.5
dataTable.stagespeed2 = 0.5
dataTable.cageclosed = false
coords = {}
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[1] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[2] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[3] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[4] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[5] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[6] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[7] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[8] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[9] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[10] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[11] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[12] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[13] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[14] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[15] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[16] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[17] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[18] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[19] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[20] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[21] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[22] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[23] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[24] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[25] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[26] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[27] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[28] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[29] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[30] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[31] = dataTable2
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
coords[32] = dataTable2
dataTable.seats = coords
vortexhandler = dataTable

function dataTable(A0_2, A1_2, A2_2)
    local isDisabled, strValue, value2, isEnabled2
    isDisabled = Config
    isDisabled = isDisabled.AttractionsSettings
    isDisabled = isDisabled.vortex
    isDisabled = isDisabled.speedmodifier
    isDisabled = A0_2 * isDisabled
    strValue = A1_2 / A2_2
    strValue = strValue * 100.0
    if strValue > 60.0 then
        value2 = 130.0
        value2 = value2 - strValue
        isEnabled2 = value2 / 100.0
        isEnabled2 = isEnabled2 * isDisabled
        return isEnabled2
    elseif strValue < 20.0 then
        value2 = 130.0
        value2 = value2 - strValue
        isEnabled2 = 100.0
        isEnabled2 = isEnabled2 / value2
        isEnabled2 = isEnabled2 * isDisabled
        return isEnabled2
    else
        return isDisabled
    end
end
CalculateSpeedVortex = dataTable
dataTable = GlobalState
dataTable["attraction3 - phase"] = 0
dataTable = GlobalState
dataTable["attraction3 - ridedata1"] = 0.0
dataTable = GlobalState
dataTable["attraction3 - ridedata2"] = 0.0
dataTable = GlobalState
dataTable["attraction3 - speeddata1"] = 0.1
dataTable = GlobalState
dataTable["attraction3 - speeddata2"] = 0.1
dataTable = GlobalState
dataTable["attraction3 - direction"] = 1
dataTable = GlobalState
dataTable["attraction3 - synchdata"] = 1

function dataTable()
    local condition, counter, counter2, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23, var22, isEnabled3, var2
    condition = vortexhandler
    condition = condition.started
    if true == condition then
        condition = vortexhandler
        condition.cageclosed = true
        condition = pairs
        counter = playsersinthemepark
        condition, counter, counter2, isDisabled = condition(counter)
        for strValue, value2 in condition, counter, counter2, isDisabled do
            isEnabled2 = TriggerClientEvent
            strValue2 = "rtx_themepark:Vortex:SynchronizeCageClient"
            value3 = value2
            isEnabled = true
            isEnabled2(strValue2, value3, isEnabled)
        end
        condition = Citizen
        condition = condition.Wait
        counter = 7500
        condition(counter)
        condition = TriggerClientEvent
        counter = "rtx_themepark:Global:MusicStartAttraction"
        counter2 = -1
        isDisabled = "vortex"
        strValue = math
        strValue = strValue.random
        value2 = 1
        isEnabled2 = Config
        isEnabled2 = isEnabled2.AttractionsMusic
        isEnabled2 = isEnabled2.vortex
        isEnabled2 = isEnabled2.playlist
        isEnabled2 = #isEnabled2
        strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23, var22, isEnabled3, var2 = strValue(value2, isEnabled2)
        condition(counter, counter2, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23, var22, isEnabled3, var2)
        condition = vortexhandler
        condition.stageinprogress = true
        condition = vortexhandler
        condition.stage = 1
        condition = vortexhandler
        condition.stagecounter = 0
        condition = vortexhandler
        condition.stagespeed = 0.5
        condition = vortexhandler
        condition.stagespeed2 = 0.5
        condition = vortexhandler
        condition.stagedirection = 1
        condition = GlobalState
        condition["attraction3 - phase"] = 1
        condition = GlobalState
        condition["attraction3 - ridedata1"] = 0.0
        condition = GlobalState
        condition["attraction3 - ridedata2"] = 0.0
        condition = GlobalState
        condition["attraction3 - speeddata1"] = 0.5
        condition = GlobalState
        condition["attraction3 - speeddata2"] = 0.5
        condition = GlobalState
        condition["attraction3 - direction"] = 1
        condition = GlobalState
        condition["attraction3 - synchdata"] = 1
        condition = ipairs
        counter = vortexhandler
        counter = counter.seats
        condition, counter, counter2, isDisabled = condition(counter)
        for strValue, value2 in condition, counter, counter2, isDisabled do
            isEnabled2 = value2.taken
            if true == isEnabled2 then
                isEnabled2 = pairs
                strValue2 = playsersinthemepark
                isEnabled2, strValue2, value3, isEnabled = isEnabled2(strValue2)
                for isDisabled2, value in isEnabled2, strValue2, value3, isEnabled do
                    func = TriggerClientEvent
                    isEnabled4 = "rtx_themepark:Vortex:SynchronizeSeat"
                    var23 = value
                    var22 = strValue
                    isEnabled3 = true
                    var2 = value2.takenplayerid
                    func(isEnabled4, var23, var22, isEnabled3, var2)
                end
                isEnabled2 = TriggerClientEvent
                strValue2 = "rtx_themepark:Global:AttractionUsing"
                value3 = value2.takenplayerid
                isEnabled = true
                isEnabled2(strValue2, value3, isEnabled)
            end
        end
        while true do
            condition = vortexhandler
            condition = condition.stageinprogress
            if true ~= condition then
                break
            end
            condition = Citizen
            condition = condition.Wait
            counter = 20
            condition(counter)
            condition = vortexhandler
            condition = condition.stage
            if 1 == condition then
                condition = vortexhandler
                condition = condition.stagedirection
                if 1 == condition then
                    condition = vortexhandler
                    counter = CalculateSpeedVortex
                    counter2 = 0.25
                    isDisabled = vortexhandler
                    isDisabled = isDisabled.currentrotation
                    strValue = 5.0
                    counter = counter(counter2, isDisabled, strValue)
                    condition.stagespeed = counter
                    condition = vortexhandler
                    condition = condition.currentrotation
                    if condition > 5.0 then
                        condition = vortexhandler
                        condition.stagedirection = 2
                    end
                    condition = vortexhandler
                    counter = vortexhandler
                    counter = counter.currentrotation
                    counter2 = vortexhandler
                    counter2 = counter2.stagespeed
                    counter = counter + counter2
                    condition.currentrotation = counter
                else
                    condition = vortexhandler
                    counter = CalculateSpeedVortex
                    counter2 = 0.25
                    isDisabled = vortexhandler
                    isDisabled = isDisabled.currentrotation
                    strValue = -5.0
                    counter = counter(counter2, isDisabled, strValue)
                    condition.stagespeed = counter
                    condition = vortexhandler
                    condition = condition.currentrotation
                    if condition < -5.0 then
                        condition = vortexhandler
                        condition.stagedirection = 1
                        condition = vortexhandler
                        condition.stage = 2
                    end
                    condition = vortexhandler
                    counter = vortexhandler
                    counter = counter.currentrotation
                    counter2 = vortexhandler
                    counter2 = counter2.stagespeed
                    counter = counter - counter2
                    condition.currentrotation = counter
                end
            else
                condition = vortexhandler
                condition = condition.stage
                if 2 == condition then
                    condition = vortexhandler
                    condition = condition.stagedirection
                    if 1 == condition then
                        condition = vortexhandler
                        counter = CalculateSpeedVortex
                        counter2 = 0.25
                        isDisabled = vortexhandler
                        isDisabled = isDisabled.currentrotation
                        strValue = 15.0
                        counter = counter(counter2, isDisabled, strValue)
                        condition.stagespeed = counter
                        condition = vortexhandler
                        condition = condition.currentrotation
                        if condition > 15.0 then
                            condition = vortexhandler
                            condition.stagedirection = 2
                        end
                        condition = vortexhandler
                        counter = vortexhandler
                        counter = counter.currentrotation
                        counter2 = vortexhandler
                        counter2 = counter2.stagespeed
                        counter = counter + counter2
                        condition.currentrotation = counter
                    else
                        condition = vortexhandler
                        counter = CalculateSpeedVortex
                        counter2 = 0.25
                        isDisabled = vortexhandler
                        isDisabled = isDisabled.currentrotation
                        strValue = -15.0
                        counter = counter(counter2, isDisabled, strValue)
                        condition.stagespeed = counter
                        condition = vortexhandler
                        condition = condition.currentrotation
                        if condition < -15.0 then
                            condition = vortexhandler
                            condition.stagedirection = 1
                            condition = vortexhandler
                            condition.stage = 3
                        end
                        condition = vortexhandler
                        counter = vortexhandler
                        counter = counter.currentrotation
                        counter2 = vortexhandler
                        counter2 = counter2.stagespeed
                        counter = counter - counter2
                        condition.currentrotation = counter
                    end
                else
                    condition = vortexhandler
                    condition = condition.stage
                    if 3 == condition then
                        condition = vortexhandler
                        condition.stagespeed = 0.5
                        condition = vortexhandler
                        counter = vortexhandler
                        counter = counter.stagespeed
                        counter2 = Config
                        counter2 = counter2.AttractionsSettings
                        counter2 = counter2.vortex
                        counter2 = counter2.speedmodifier
                        counter = counter * counter2
                        condition.stagespeed2 = counter
                        condition = vortexhandler
                        counter = vortexhandler
                        counter = counter.currentrotation2
                        counter2 = vortexhandler
                        counter2 = counter2.stagespeed2
                        counter = counter + counter2
                        condition.currentrotation2 = counter
                        condition = vortexhandler
                        condition = condition.stagedirection
                        if 1 == condition then
                            condition = vortexhandler
                            counter = CalculateSpeedVortex
                            counter2 = 0.5
                            isDisabled = vortexhandler
                            isDisabled = isDisabled.currentrotation
                            strValue = 40.0
                            counter = counter(counter2, isDisabled, strValue)
                            condition.stagespeed = counter
                            condition = vortexhandler
                            condition = condition.currentrotation
                            if condition > 40.0 then
                                condition = vortexhandler
                                condition.stagedirection = 2
                            end
                            condition = vortexhandler
                            counter = vortexhandler
                            counter = counter.currentrotation
                            counter2 = vortexhandler
                            counter2 = counter2.stagespeed
                            counter = counter + counter2
                            condition.currentrotation = counter
                        else
                            condition = vortexhandler
                            counter = CalculateSpeedVortex
                            counter2 = 0.5
                            isDisabled = vortexhandler
                            isDisabled = isDisabled.currentrotation
                            strValue = -40.0
                            counter = counter(counter2, isDisabled, strValue)
                            condition.stagespeed = counter
                            condition = vortexhandler
                            condition = condition.currentrotation
                            if condition < -40.0 then
                                condition = vortexhandler
                                condition.stagedirection = 1
                                condition = vortexhandler
                                condition.stage = 4
                            end
                            condition = vortexhandler
                            counter = vortexhandler
                            counter = counter.currentrotation
                            counter2 = vortexhandler
                            counter2 = counter2.stagespeed
                            counter = counter - counter2
                            condition.currentrotation = counter
                        end
                    else
                        condition = vortexhandler
                        condition = condition.stage
                        if 4 == condition then
                            condition = vortexhandler
                            condition.stagespeed = 0.75
                            condition = vortexhandler
                            counter = vortexhandler
                            counter = counter.stagespeed
                            counter2 = Config
                            counter2 = counter2.AttractionsSettings
                            counter2 = counter2.vortex
                            counter2 = counter2.speedmodifier
                            counter = counter * counter2
                            condition.stagespeed2 = counter
                            condition = vortexhandler
                            counter = vortexhandler
                            counter = counter.currentrotation2
                            counter2 = vortexhandler
                            counter2 = counter2.stagespeed2
                            counter = counter + counter2
                            condition.currentrotation2 = counter
                            condition = vortexhandler
                            condition = condition.stagedirection
                            if 1 == condition then
                                condition = vortexhandler
                                counter = CalculateSpeedVortex
                                counter2 = 0.75
                                isDisabled = vortexhandler
                                isDisabled = isDisabled.currentrotation
                                strValue = 80.0
                                counter = counter(counter2, isDisabled, strValue)
                                condition.stagespeed = counter
                                condition = vortexhandler
                                condition = condition.currentrotation
                                if condition > 80.0 then
                                    condition = vortexhandler
                                    condition.stagedirection = 2
                                end
                                condition = vortexhandler
                                counter = vortexhandler
                                counter = counter.currentrotation
                                counter2 = vortexhandler
                                counter2 = counter2.stagespeed
                                counter = counter + counter2
                                condition.currentrotation = counter
                            else
                                condition = vortexhandler
                                counter = CalculateSpeedVortex
                                counter2 = 0.75
                                isDisabled = vortexhandler
                                isDisabled = isDisabled.currentrotation
                                strValue = -80.0
                                counter = counter(counter2, isDisabled, strValue)
                                condition.stagespeed = counter
                                condition = vortexhandler
                                condition = condition.currentrotation
                                if condition < -80.0 then
                                    condition = vortexhandler
                                    condition.stagedirection = 1
                                    condition = vortexhandler
                                    condition.stage = 5
                                end
                                condition = vortexhandler
                                counter = vortexhandler
                                counter = counter.currentrotation
                                counter2 = vortexhandler
                                counter2 = counter2.stagespeed
                                counter = counter - counter2
                                condition.currentrotation = counter
                            end
                        else
                            condition = vortexhandler
                            condition = condition.stage
                            if 5 == condition then
                                condition = vortexhandler
                                condition.stagespeed = 1.25
                                condition = vortexhandler
                                counter = vortexhandler
                                counter = counter.stagespeed
                                counter2 = Config
                                counter2 = counter2.AttractionsSettings
                                counter2 = counter2.vortex
                                counter2 = counter2.speedmodifier
                                counter = counter * counter2
                                condition.stagespeed2 = counter
                                condition = vortexhandler
                                counter = vortexhandler
                                counter = counter.currentrotation2
                                counter2 = vortexhandler
                                counter2 = counter2.stagespeed2
                                counter = counter + counter2
                                condition.currentrotation2 = counter
                                condition = vortexhandler
                                condition = condition.stagedirection
                                if 1 == condition then
                                    condition = vortexhandler
                                    counter = CalculateSpeedVortex
                                    counter2 = 1.25
                                    isDisabled = vortexhandler
                                    isDisabled = isDisabled.currentrotation
                                    strValue = 125.0
                                    counter = counter(counter2, isDisabled, strValue)
                                    condition.stagespeed = counter
                                    condition = vortexhandler
                                    condition = condition.currentrotation
                                    if condition > 125.0 then
                                        condition = vortexhandler
                                        condition.stagedirection = 2
                                    end
                                    condition = vortexhandler
                                    counter = vortexhandler
                                    counter = counter.currentrotation
                                    counter2 = vortexhandler
                                    counter2 = counter2.stagespeed
                                    counter = counter + counter2
                                    condition.currentrotation = counter
                                else
                                    condition = vortexhandler
                                    counter = CalculateSpeedVortex
                                    counter2 = 1.25
                                    isDisabled = vortexhandler
                                    isDisabled = isDisabled.currentrotation
                                    strValue = -125.0
                                    counter = counter(counter2, isDisabled, strValue)
                                    condition.stagespeed = counter
                                    condition = vortexhandler
                                    condition = condition.currentrotation
                                    if condition < -125.0 then
                                        condition = vortexhandler
                                        condition.stagedirection = 1
                                        condition = vortexhandler
                                        condition.stage = 6
                                    end
                                    condition = vortexhandler
                                    counter = vortexhandler
                                    counter = counter.currentrotation
                                    counter2 = vortexhandler
                                    counter2 = counter2.stagespeed
                                    counter = counter - counter2
                                    condition.currentrotation = counter
                                end
                            else
                                condition = vortexhandler
                                condition = condition.stage
                                if 6 == condition then
                                    condition = vortexhandler
                                    condition.stagespeed = 1.5
                                    condition = vortexhandler
                                    counter = vortexhandler
                                    counter = counter.stagespeed
                                    counter2 = Config
                                    counter2 = counter2.AttractionsSettings
                                    counter2 = counter2.vortex
                                    counter2 = counter2.speedmodifier
                                    counter = counter * counter2
                                    condition.stagespeed2 = counter
                                    condition = vortexhandler
                                    counter = vortexhandler
                                    counter = counter.currentrotation2
                                    counter2 = vortexhandler
                                    counter2 = counter2.stagespeed2
                                    counter = counter + counter2
                                    condition.currentrotation2 = counter
                                    condition = vortexhandler
                                    condition = condition.stagedirection
                                    if 1 == condition then
                                        condition = vortexhandler
                                        counter = CalculateSpeedVortex
                                        counter2 = 1.5
                                        isDisabled = vortexhandler
                                        isDisabled = isDisabled.currentrotation
                                        strValue = 150.0
                                        counter = counter(counter2, isDisabled, strValue)
                                        condition.stagespeed = counter
                                        condition = vortexhandler
                                        condition = condition.currentrotation
                                        counter = 150.0
                                        if condition > counter then
                                            condition = vortexhandler
                                            condition.stagedirection = 2
                                        end
                                        condition = vortexhandler
                                        counter = vortexhandler
                                        counter = counter.currentrotation
                                        counter2 = vortexhandler
                                        counter2 = counter2.stagespeed
                                        counter = counter + counter2
                                        condition.currentrotation = counter
                                    else
                                        condition = vortexhandler
                                        counter = CalculateSpeedVortex
                                        counter2 = 1.5
                                        isDisabled = vortexhandler
                                        isDisabled = isDisabled.currentrotation
                                        strValue = -150.0
                                        counter = counter(counter2, isDisabled, strValue)
                                        condition.stagespeed = counter
                                        condition = vortexhandler
                                        condition = condition.currentrotation
                                        counter = -150.0
                                        if condition < counter then
                                            condition = vortexhandler
                                            condition.stagedirection = 1
                                            condition = vortexhandler
                                            condition.stage = 7
                                        end
                                        condition = vortexhandler
                                        counter = vortexhandler
                                        counter = counter.currentrotation
                                        counter2 = vortexhandler
                                        counter2 = counter2.stagespeed
                                        counter = counter - counter2
                                        condition.currentrotation = counter
                                    end
                                else
                                    condition = vortexhandler
                                    condition = condition.stage
                                    if 7 == condition then
                                        condition = vortexhandler
                                        condition.stagespeed = 1.75
                                        condition = vortexhandler
                                        counter = vortexhandler
                                        counter = counter.stagespeed
                                        counter2 = Config
                                        counter2 = counter2.AttractionsSettings
                                        counter2 = counter2.vortex
                                        counter2 = counter2.speedmodifier
                                        counter = counter * counter2
                                        condition.stagespeed2 = counter
                                        condition = vortexhandler
                                        counter = vortexhandler
                                        counter = counter.currentrotation2
                                        counter2 = vortexhandler
                                        counter2 = counter2.stagespeed2
                                        counter = counter + counter2
                                        condition.currentrotation2 = counter
                                        condition = vortexhandler
                                        condition = condition.stagedirection
                                        if 1 == condition then
                                            condition = vortexhandler
                                            counter = CalculateSpeedVortex
                                            counter2 = 1.75
                                            isDisabled = vortexhandler
                                            isDisabled = isDisabled.currentrotation
                                            strValue = 175.0
                                            counter = counter(counter2, isDisabled, strValue)
                                            condition.stagespeed = counter
                                            condition = vortexhandler
                                            condition = condition.currentrotation
                                            counter = 175.0
                                            if condition > counter then
                                                condition = vortexhandler
                                                condition.stagedirection = 2
                                                condition = vortexhandler
                                                counter = vortexhandler
                                                counter = counter.stagecounter
                                                counter = counter + 1
                                                condition.stagecounter = counter
                                                condition = vortexhandler
                                                condition = condition.stagecounter
                                                counter = Config
                                                counter = counter.AttractionsSettings
                                                counter = counter.vortex
                                                counter = counter.maxrounds
                                                if condition > counter then
                                                    condition = vortexhandler
                                                    condition.stage = 8
                                                end
                                            end
                                            condition = vortexhandler
                                            counter = vortexhandler
                                            counter = counter.currentrotation
                                            counter2 = vortexhandler
                                            counter2 = counter2.stagespeed
                                            counter = counter + counter2
                                            condition.currentrotation = counter
                                        else
                                            condition = vortexhandler
                                            counter = CalculateSpeedVortex
                                            counter2 = 1.75
                                            isDisabled = vortexhandler
                                            isDisabled = isDisabled.currentrotation
                                            strValue = -175.0
                                            counter = counter(counter2, isDisabled, strValue)
                                            condition.stagespeed = counter
                                            condition = vortexhandler
                                            condition = condition.currentrotation
                                            counter = -175.0
                                            if condition < counter then
                                                condition = vortexhandler
                                                condition.stagedirection = 1
                                            end
                                            condition = vortexhandler
                                            counter = vortexhandler
                                            counter = counter.currentrotation
                                            counter2 = vortexhandler
                                            counter2 = counter2.stagespeed
                                            counter = counter - counter2
                                            condition.currentrotation = counter
                                        end
                                    else
                                        condition = vortexhandler
                                        condition = condition.stage
                                        if 8 == condition then
                                            condition = vortexhandler
                                            condition.stagespeed = 1.5
                                            condition = vortexhandler
                                            counter = vortexhandler
                                            counter = counter.stagespeed
                                            counter2 = Config
                                            counter2 = counter2.AttractionsSettings
                                            counter2 = counter2.vortex
                                            counter2 = counter2.speedmodifier
                                            counter = counter * counter2
                                            condition.stagespeed2 = counter
                                            condition = vortexhandler
                                            counter = vortexhandler
                                            counter = counter.currentrotation2
                                            counter2 = vortexhandler
                                            counter2 = counter2.stagespeed2
                                            counter = counter + counter2
                                            condition.currentrotation2 = counter
                                            condition = vortexhandler
                                            condition = condition.stagedirection
                                            if 1 == condition then
                                                condition = vortexhandler
                                                counter = CalculateSpeedVortex
                                                counter2 = 1.5
                                                isDisabled = vortexhandler
                                                isDisabled = isDisabled.currentrotation
                                                strValue = 150.0
                                                counter = counter(counter2, isDisabled, strValue)
                                                condition.stagespeed = counter
                                                condition = vortexhandler
                                                condition = condition.currentrotation
                                                counter = 150.0
                                                if condition > counter then
                                                    condition = vortexhandler
                                                    condition.stagedirection = 2
                                                end
                                                condition = vortexhandler
                                                counter = vortexhandler
                                                counter = counter.currentrotation
                                                counter2 = vortexhandler
                                                counter2 = counter2.stagespeed
                                                counter = counter + counter2
                                                condition.currentrotation = counter
                                            else
                                                condition = vortexhandler
                                                counter = CalculateSpeedVortex
                                                counter2 = 1.5
                                                isDisabled = vortexhandler
                                                isDisabled = isDisabled.currentrotation
                                                strValue = -150.0
                                                counter = counter(counter2, isDisabled, strValue)
                                                condition.stagespeed = counter
                                                condition = vortexhandler
                                                condition = condition.currentrotation
                                                counter = -150.0
                                                if condition < counter then
                                                    condition = vortexhandler
                                                    condition.stagedirection = 1
                                                    condition = vortexhandler
                                                    condition.stage = 9
                                                end
                                                condition = vortexhandler
                                                counter = vortexhandler
                                                counter = counter.currentrotation
                                                counter2 = vortexhandler
                                                counter2 = counter2.stagespeed
                                                counter = counter - counter2
                                                condition.currentrotation = counter
                                            end
                                        else
                                            condition = vortexhandler
                                            condition = condition.stage
                                            if 9 == condition then
                                                condition = vortexhandler
                                                condition.stagespeed = 1.25
                                                condition = vortexhandler
                                                counter = vortexhandler
                                                counter = counter.stagespeed
                                                counter2 = Config
                                                counter2 = counter2.AttractionsSettings
                                                counter2 = counter2.vortex
                                                counter2 = counter2.speedmodifier
                                                counter = counter * counter2
                                                condition.stagespeed2 = counter
                                                condition = vortexhandler
                                                counter = vortexhandler
                                                counter = counter.currentrotation2
                                                counter2 = vortexhandler
                                                counter2 = counter2.stagespeed2
                                                counter = counter + counter2
                                                condition.currentrotation2 = counter
                                                condition = vortexhandler
                                                condition = condition.stagedirection
                                                if 1 == condition then
                                                    condition = vortexhandler
                                                    counter = CalculateSpeedVortex
                                                    counter2 = 1.25
                                                    isDisabled = vortexhandler
                                                    isDisabled = isDisabled.currentrotation
                                                    strValue = 125.0
                                                    counter = counter(counter2, isDisabled, strValue)
                                                    condition.stagespeed = counter
                                                    condition = vortexhandler
                                                    condition = condition.currentrotation
                                                    if condition > 125.0 then
                                                        condition = vortexhandler
                                                        condition.stagedirection = 2
                                                    end
                                                    condition = vortexhandler
                                                    counter = vortexhandler
                                                    counter = counter.currentrotation
                                                    counter2 = vortexhandler
                                                    counter2 = counter2.stagespeed
                                                    counter = counter + counter2
                                                    condition.currentrotation = counter
                                                else
                                                    condition = vortexhandler
                                                    counter = CalculateSpeedVortex
                                                    counter2 = 1.25
                                                    isDisabled = vortexhandler
                                                    isDisabled = isDisabled.currentrotation
                                                    strValue = -125.0
                                                    counter = counter(counter2, isDisabled, strValue)
                                                    condition.stagespeed = counter
                                                    condition = vortexhandler
                                                    condition = condition.currentrotation
                                                    if condition < -125.0 then
                                                        condition = vortexhandler
                                                        condition.stagedirection = 1
                                                        condition = vortexhandler
                                                        condition.stage = 10
                                                    end
                                                    condition = vortexhandler
                                                    counter = vortexhandler
                                                    counter = counter.currentrotation
                                                    counter2 = vortexhandler
                                                    counter2 = counter2.stagespeed
                                                    counter = counter - counter2
                                                    condition.currentrotation = counter
                                                end
                                            else
                                                condition = vortexhandler
                                                condition = condition.stage
                                                if 10 == condition then
                                                    condition = vortexhandler
                                                    condition.stagespeed = 0.75
                                                    condition = vortexhandler
                                                    counter = vortexhandler
                                                    counter = counter.stagespeed
                                                    counter2 = Config
                                                    counter2 = counter2.AttractionsSettings
                                                    counter2 = counter2.vortex
                                                    counter2 = counter2.speedmodifier
                                                    counter = counter * counter2
                                                    condition.stagespeed2 = counter
                                                    condition = vortexhandler
                                                    counter = vortexhandler
                                                    counter = counter.currentrotation2
                                                    counter2 = vortexhandler
                                                    counter2 = counter2.stagespeed2
                                                    counter = counter + counter2
                                                    condition.currentrotation2 = counter
                                                    condition = vortexhandler
                                                    condition = condition.stagedirection
                                                    if 1 == condition then
                                                        condition = vortexhandler
                                                        counter = CalculateSpeedVortex
                                                        counter2 = 0.75
                                                        isDisabled = vortexhandler
                                                        isDisabled = isDisabled.currentrotation
                                                        strValue = 100.0
                                                        counter = counter(counter2, isDisabled, strValue)
                                                        condition.stagespeed = counter
                                                        condition = vortexhandler
                                                        condition = condition.currentrotation
                                                        if condition > 100.0 then
                                                            condition = vortexhandler
                                                            condition.stagedirection = 2
                                                        end
                                                        condition = vortexhandler
                                                        counter = vortexhandler
                                                        counter = counter.currentrotation
                                                        counter2 = vortexhandler
                                                        counter2 = counter2.stagespeed
                                                        counter = counter + counter2
                                                        condition.currentrotation = counter
                                                    else
                                                        condition = vortexhandler
                                                        counter = CalculateSpeedVortex
                                                        counter2 = 0.75
                                                        isDisabled = vortexhandler
                                                        isDisabled = isDisabled.currentrotation
                                                        strValue = -150.0
                                                        counter = counter(counter2, isDisabled, strValue)
                                                        condition.stagespeed = counter
                                                        condition = vortexhandler
                                                        condition = condition.currentrotation
                                                        if condition < -100.0 then
                                                            condition = vortexhandler
                                                            condition.stagedirection = 1
                                                            condition = vortexhandler
                                                            condition.stage = 11
                                                        end
                                                        condition = vortexhandler
                                                        counter = vortexhandler
                                                        counter = counter.currentrotation
                                                        counter2 = vortexhandler
                                                        counter2 = counter2.stagespeed
                                                        counter = counter - counter2
                                                        condition.currentrotation = counter
                                                    end
                                                else
                                                    condition = vortexhandler
                                                    condition = condition.stage
                                                    if 11 == condition then
                                                        condition = vortexhandler
                                                        condition.stagespeed = 0.5
                                                        condition = vortexhandler
                                                        counter = vortexhandler
                                                        counter = counter.stagespeed
                                                        counter2 = Config
                                                        counter2 = counter2.AttractionsSettings
                                                        counter2 = counter2.vortex
                                                        counter2 = counter2.speedmodifier
                                                        counter = counter * counter2
                                                        condition.stagespeed2 = counter
                                                        condition = vortexhandler
                                                        condition = condition.currentrotation2
                                                        counter = 360.0
                                                        if condition > counter then
                                                        else
                                                            condition = vortexhandler
                                                            counter = vortexhandler
                                                            counter = counter.currentrotation2
                                                            counter2 = vortexhandler
                                                            counter2 = counter2.stagespeed2
                                                            counter = counter + counter2
                                                            condition.currentrotation2 = counter
                                                        end
                                                        condition = vortexhandler
                                                        condition = condition.stagedirection
                                                        if 1 == condition then
                                                            condition = vortexhandler
                                                            counter = CalculateSpeedVortex
                                                            counter2 = 0.5
                                                            isDisabled = vortexhandler
                                                            isDisabled = isDisabled.currentrotation
                                                            strValue = 25.0
                                                            counter = counter(counter2, isDisabled, strValue)
                                                            condition.stagespeed = counter
                                                            condition = vortexhandler
                                                            condition = condition.currentrotation
                                                            if condition > 25.0 then
                                                                condition = vortexhandler
                                                                condition.stagedirection = 2
                                                            end
                                                            condition = vortexhandler
                                                            counter = vortexhandler
                                                            counter = counter.currentrotation
                                                            counter2 = vortexhandler
                                                            counter2 = counter2.stagespeed
                                                            counter = counter + counter2
                                                            condition.currentrotation = counter
                                                        else
                                                            condition = vortexhandler
                                                            counter = CalculateSpeedVortex
                                                            counter2 = 0.5
                                                            isDisabled = vortexhandler
                                                            isDisabled = isDisabled.currentrotation
                                                            strValue = -25.0
                                                            counter = counter(counter2, isDisabled, strValue)
                                                            condition.stagespeed = counter
                                                            condition = vortexhandler
                                                            condition = condition.currentrotation
                                                            if condition < -25.0 then
                                                                condition = vortexhandler
                                                                condition.stagedirection = 1
                                                                condition = vortexhandler
                                                                condition.stage = 14
                                                            end
                                                            condition = vortexhandler
                                                            counter = vortexhandler
                                                            counter = counter.currentrotation
                                                            counter2 = vortexhandler
                                                            counter2 = counter2.stagespeed
                                                            counter = counter - counter2
                                                            condition.currentrotation = counter
                                                        end
                                                    else
                                                        condition = vortexhandler
                                                        condition = condition.stage
                                                        if 14 == condition then
                                                            condition = vortexhandler
                                                            condition.stagespeed = 0.25
                                                            condition = vortexhandler
                                                            condition = condition.stagedirection
                                                            if 1 == condition then
                                                                condition = vortexhandler
                                                                counter = vortexhandler
                                                                counter = counter.currentrotation
                                                                counter2 = vortexhandler
                                                                counter2 = counter2.stagespeed
                                                                counter = counter + counter2
                                                                condition.currentrotation = counter
                                                                condition = vortexhandler
                                                                condition = condition.currentrotation
                                                                counter = 0.25
                                                                if condition > counter then
                                                                    condition = vortexhandler
                                                                    condition.stage = 15
                                                                end
                                                            end
                                                        else
                                                            condition = vortexhandler
                                                            condition = condition.stage
                                                            if 15 == condition then
                                                                condition = vortexhandler
                                                                condition.currentrotation = 0.0
                                                                condition = vortexhandler
                                                                condition.currentrotation2 = 0.0
                                                                condition = vortexhandler
                                                                condition.stage = 16
                                                            else
                                                                condition = vortexhandler
                                                                condition = condition.stage
                                                                if 16 == condition then
                                                                    condition = pairs
                                                                    counter = playsersinthemepark
                                                                    condition, counter, counter2, isDisabled = condition(counter)
                                                                    for strValue, value2 in condition, counter, counter2, isDisabled do
                                                                        isEnabled2 = TriggerClientEvent
                                                                        strValue2 = "rtx_themepark:Vortex:SynchronizeCageClient"
                                                                        value3 = value2
                                                                        isEnabled = false
                                                                        isEnabled2(strValue2, value3, isEnabled)
                                                                    end
                                                                    condition = vortexhandler
                                                                    condition.cageclosed = false
                                                                    condition = Citizen
                                                                    condition = condition.Wait
                                                                    counter = 7500
                                                                    condition(counter)
                                                                    condition = ipairs
                                                                    counter = vortexhandler
                                                                    counter = counter.seats
                                                                    condition, counter, counter2, isDisabled = condition(counter)
                                                                    for strValue, value2 in condition, counter, counter2, isDisabled do
                                                                        isEnabled2 = value2.taken
                                                                        if true == isEnabled2 then
                                                                            value2.taken = false
                                                                            isEnabled2 = pairs
                                                                            strValue2 = playsersinthemepark
                                                                            isEnabled2, strValue2, value3, isEnabled = isEnabled2(strValue2)
                                                                            for isDisabled2, value in isEnabled2, strValue2, value3, isEnabled do
                                                                                func = TriggerClientEvent
                                                                                isEnabled4 = "rtx_themepark:Vortex:SynchronizeSeat"
                                                                                var23 = value
                                                                                var22 = strValue
                                                                                isEnabled3 = false
                                                                                var2 = value2.takenplayerid
                                                                                func(isEnabled4, var23, var22, isEnabled3, var2)
                                                                            end
                                                                            isEnabled2 = TriggerClientEvent
                                                                            strValue2 = "rtx_themepark:Vortex:SeatExit"
                                                                            value3 = value2.takenplayerid
                                                                            isEnabled = true
                                                                            isEnabled2(strValue2, value3, isEnabled)
                                                                            isEnabled2 = TriggerClientEvent
                                                                            strValue2 = "rtx_themepark:Global:AttractionUsing"
                                                                            value3 = value2.takenplayerid
                                                                            isEnabled = false
                                                                            isEnabled2(strValue2, value3, isEnabled)
                                                                            isEnabled2 = TriggerClientEvent
                                                                            strValue2 = "rtx_themepark:Global:TicketHandler"
                                                                            value3 = value2.takenplayerid
                                                                            isEnabled = 3
                                                                            isDisabled2 = false
                                                                            isEnabled2(strValue2, value3, isEnabled, isDisabled2)
                                                                            value2.takenplayerid = nil
                                                                        end
                                                                    end
                                                                    condition = vortexhandler
                                                                    condition.stageinprogress = false
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
            condition = vortexhandler
            condition = condition.stage
            if condition >= 3 then
                condition = vortexhandler
                condition = condition.stage
                if condition <= 10 then
                    condition = vortexhandler
                    condition = condition.currentrotation2
                    counter = 360.0
                    if condition > counter then
                        condition = vortexhandler
                        condition = condition.currentrotation2
                        condition = condition - 360.0
                        counter = vortexhandler
                        counter2 = 0.0 + condition
                        counter.currentrotation2 = counter2
                    end
                end
            end
            condition = GlobalState
            counter = vortexhandler
            counter = counter.stage
            condition["attraction3 - phase"] = counter
            condition = GlobalState
            counter = vortexhandler
            counter = counter.currentrotation
            condition["attraction3 - ridedata1"] = counter
            condition = GlobalState
            counter = vortexhandler
            counter = counter.currentrotation2
            condition["attraction3 - ridedata2"] = counter
            condition = GlobalState
            counter = vortexhandler
            counter = counter.stagespeed
            condition["attraction3 - speeddata1"] = counter
            condition = GlobalState
            counter = vortexhandler
            counter = counter.stagespeed2
            condition["attraction3 - speeddata2"] = counter
            condition = GlobalState
            counter = vortexhandler
            counter = counter.stagedirection
            condition["attraction3 - direction"] = counter
            condition = GlobalState
            counter = GlobalState
            counter = counter["attraction3 - synchdata"]
            counter = counter + 1
            condition["attraction3 - synchdata"] = counter
        end
        condition = TriggerClientEvent
        counter = "rtx_themepark:Global:MusicStopAttraction"
        counter2 = -1
        isDisabled = "vortex"
        condition(counter, counter2, isDisabled)
        condition = vortexhandler
        condition.currentrotation = 0.0
        condition = vortexhandler
        condition.currentrotation2 = 0.0
        condition = GlobalState
        condition["attraction3 - phase"] = 0
        condition = GlobalState
        condition["attraction3 - ridedata1"] = 0.0
        condition = GlobalState
        condition["attraction3 - ridedata2"] = 0.0
        condition = vortexhandler
        condition.started = false
        condition = TriggerClientEvent
        counter = "rtx_themepark:Vortex:SynchronizeStarted"
        counter2 = -1
        isDisabled = false
        condition(counter, counter2, isDisabled)
    end
end
StartVortex = dataTable
dataTable = RegisterServerEvent
coords = "rtx_themepark:Vortex:SeatUse"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:Vortex:SeatUse"

function dataTable2(A0_2)
    local counter, counter2, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23
    counter = source
    counter2 = themeparkattractionsopenstatus
    counter2 = counter2[7]
    if true == counter2 then
        counter2 = themeparkdisabled
        if false == counter2 then
            if nil ~= A0_2 then
                counter2 = vortexhandler
                counter2 = counter2.started
                if false == counter2 then
                    counter2 = vortexhandler
                    counter2 = counter2.seats
                    counter2 = counter2[A0_2]
                    isDisabled = counter2.taken
                    if false == isDisabled then
                        counter2.taken = true
                        counter2.takenplayerid = counter
                        isDisabled = pairs
                        strValue = playsersinthemepark
                        isDisabled, strValue, value2, isEnabled2 = isDisabled(strValue)
                        for strValue2, value3 in isDisabled, strValue, value2, isEnabled2 do
                            isEnabled = TriggerClientEvent
                            isDisabled2 = "rtx_themepark:Vortex:SynchronizeSeat"
                            value = value3
                            func = A0_2
                            isEnabled4 = true
                            var23 = counter2.takenplayerid
                            isEnabled(isDisabled2, value, func, isEnabled4, var23)
                        end
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Vortex:SeatData"
                        value2 = counter
                        isEnabled2 = A0_2
                        isDisabled(strValue, value2, isEnabled2)
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Global:AttractionUsing"
                        value2 = counter
                        isEnabled2 = true
                        isDisabled(strValue, value2, isEnabled2)
                        isDisabled = Config
                        isDisabled = isDisabled.ThemeParkControlAttractions
                        if false == isDisabled then
                            isDisabled = vortexhandler
                            isDisabled = isDisabled.started
                            if false == isDisabled then
                                isDisabled = attractionlockdown
                                if false == isDisabled then
                                    isDisabled = Wait
                                    strValue = Config
                                    strValue = strValue.AttractionsSettings
                                    strValue = strValue.vortex
                                    strValue = strValue.waitforplayers
                                    isDisabled(strValue)
                                    isDisabled = vortexhandler
                                    isDisabled = isDisabled.started
                                    if false == isDisabled then
                                        isDisabled = vortexhandler
                                        isDisabled.started = true
                                        isDisabled = TriggerClientEvent
                                        strValue = "rtx_themepark:Vortex:SynchronizeStarted"
                                        value2 = -1
                                        isEnabled2 = true
                                        isDisabled(strValue, value2, isEnabled2)
                                        isDisabled = StartVortex
                                        isDisabled()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        counter2 = TriggerClientEvent
        isDisabled = "rtx_themepark:Notify"
        strValue = counter
        value2 = Language
        isEnabled2 = Config
        isEnabled2 = isEnabled2.Language
        value2 = value2[isEnabled2]
        value2 = value2.attractionclosed
        counter2(isDisabled, strValue, value2)
    end
end
dataTable(coords, dataTable2)
dataTable = RegisterServerEvent
coords = "rtx_themepark:Vortex:ExitAttraction"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:Vortex:ExitAttraction"

function dataTable2(A0_2)
    local counter, counter2, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23
    counter = source
    if nil ~= A0_2 then
        counter2 = vortexhandler
        counter2 = counter2.seats
        counter2 = counter2[A0_2]
        isDisabled = counter2.taken
        if true == isDisabled then
            isDisabled = counter2.takenplayerid
            if isDisabled == counter then
                isDisabled = Config
                isDisabled = isDisabled.ThemeParkDisableExit
                if false ~= isDisabled then
                    isDisabled = vortexhandler
                    isDisabled = isDisabled.started
                    if false ~= isDisabled then
                        goto lbl_48
                    end
                end
                isDisabled = pairs
                strValue = playsersinthemepark
                isDisabled, strValue, value2, isEnabled2 = isDisabled(strValue)
                for strValue2, value3 in isDisabled, strValue, value2, isEnabled2 do
                    isEnabled = TriggerClientEvent
                    isDisabled2 = "rtx_themepark:Vortex:SynchronizeSeat"
                    value = value3
                    func = A0_2
                    isEnabled4 = false
                    var23 = counter2.takenplayerid
                    isEnabled(isDisabled2, value, func, isEnabled4, var23)
                end
                isDisabled = TriggerClientEvent
                strValue = "rtx_themepark:Vortex:SeatExit"
                value2 = counter2.takenplayerid
                isDisabled(strValue, value2)
                isDisabled = TriggerClientEvent
                strValue = "rtx_themepark:Global:AttractionUsing"
                value2 = counter2.takenplayerid
                isEnabled2 = false
                isDisabled(strValue, value2, isEnabled2)
                counter2.taken = false
                counter2.takenplayerid = nil
                counter2.seattype = 1
                goto lbl_57
                ::lbl_48::
                isDisabled = TriggerClientEvent
                strValue = "rtx_themepark:Notify"
                value2 = counter
                isEnabled2 = Language
                strValue2 = Config
                strValue2 = strValue2.Language
                isEnabled2 = isEnabled2[strValue2]
                isEnabled2 = isEnabled2.inprogress
                isDisabled(strValue, value2, isEnabled2)
            end
        end
    end
    ::lbl_57::
end
dataTable(coords, dataTable2)
dataTable = Config
dataTable = dataTable.ThemeParkAttractionFallChance
if dataTable then
    dataTable = Config
    dataTable = dataTable.ThemeParkFallSettings
    dataTable = dataTable.attractions
    dataTable = dataTable.vortex
    if dataTable then
        dataTable = RegisterServerEvent
        coords = "rtx_themepark:Vortex:ThrowAttraction"
        dataTable(coords)
        dataTable = AddEventHandler
        coords = "rtx_themepark:Vortex:ThrowAttraction"

        function dataTable2(A0_2)
            local counter, counter2, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23
            counter = source
            if nil ~= A0_2 then
                counter2 = vortexhandler
                counter2 = counter2.seats
                counter2 = counter2[A0_2]
                isDisabled = counter2.taken
                if true == isDisabled then
                    isDisabled = counter2.takenplayerid
                    if isDisabled == counter then
                        isDisabled = pairs
                        strValue = playsersinthemepark
                        isDisabled, strValue, value2, isEnabled2 = isDisabled(strValue)
                        for strValue2, value3 in isDisabled, strValue, value2, isEnabled2 do
                            isEnabled = TriggerClientEvent
                            isDisabled2 = "rtx_themepark:Vortex:SynchronizeSeat"
                            value = value3
                            func = A0_2
                            isEnabled4 = false
                            var23 = counter2.takenplayerid
                            isEnabled(isDisabled2, value, func, isEnabled4, var23)
                        end
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Vortex:SeatThrowClient"
                        value2 = counter2.takenplayerid
                        isDisabled(strValue, value2)
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Global:AttractionUsing"
                        value2 = counter2.takenplayerid
                        isEnabled2 = false
                        isDisabled(strValue, value2, isEnabled2)
                        counter2.taken = false
                        counter2.takenplayerid = nil
                        counter2.seattype = 1
                    end
                end
            end
        end
        dataTable(coords, dataTable2)
    end
end