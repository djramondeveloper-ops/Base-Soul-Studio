
local dataTable, coords, dataTable2, dataTable4, dataTable3
dataTable = {}
coords = vector3
dataTable2 = -1637.82959
dataTable4 = -1099.2915
dataTable3 = 16.8322926
coords = coords(dataTable2, dataTable4, dataTable3)
dataTable.coords = coords
dataTable.started = false
dataTable.currentrotation = 0.0
dataTable.currentrotation2 = 0.0
dataTable.currentrotation3 = 0.0
dataTable.currentrotation4 = 0.0
dataTable.stageinprogress = false
dataTable.stage = 15
dataTable.stagecounter = 0
dataTable.stagespeed = 0.5
coords = {}
dataTable2 = {}
dataTable4 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[4] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[5] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[6] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[7] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[8] = dataTable3
dataTable2.seats = dataTable4
coords[1] = dataTable2
dataTable2 = {}
dataTable4 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[4] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[5] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[6] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[7] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[8] = dataTable3
dataTable2.seats = dataTable4
coords[2] = dataTable2
dataTable2 = {}
dataTable4 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[4] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[5] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[6] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[7] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4[8] = dataTable3
dataTable2.seats = dataTable4
coords[3] = dataTable2
dataTable.seats = coords
topscanhandler = dataTable
dataTable = GlobalState
dataTable["attraction2 - phase"] = 0
dataTable = GlobalState
dataTable["attraction2 - ridedata1"] = 0.0
dataTable = GlobalState
dataTable["attraction2 - ridedata2"] = 0.0
dataTable = GlobalState
dataTable["attraction2 - ridedata3"] = 0.0
dataTable = GlobalState
dataTable["attraction2 - ridedata4"] = 0.0
dataTable = GlobalState
dataTable["attraction2 - speeddata1"] = 0.1
dataTable = GlobalState
dataTable["attraction2 - synchdata"] = 1

function dataTable()
    local condition3, condition, counter2, counter, isDisabled2, condition2, strValue2, index, isEnabled3, key, value, key2, strValue4, func2, strValue3, var23, isEnabled2, isDisabled, value2, func, strValue, var2, var24, var22, isEnabled, var25
    condition3 = topscanhandler
    condition3 = condition3.started
    if true == condition3 then
        condition3 = topscanhandler
        condition3.stageinprogress = true
        condition3 = topscanhandler
        condition3.stage = 1
        condition3 = topscanhandler
        condition3.stagecounter = 0
        condition3 = topscanhandler
        condition3.stagespeed = 0.5
        condition3 = GlobalState
        condition3["attraction2 - phase"] = 1
        condition3 = GlobalState
        condition3["attraction2 - ridedata1"] = 0.0
        condition3 = GlobalState
        condition3["attraction2 - ridedata2"] = 0.0
        condition3 = GlobalState
        condition3["attraction2 - ridedata3"] = 0.0
        condition3 = GlobalState
        condition3["attraction2 - ridedata4"] = 0.0
        condition3 = GlobalState
        condition3["attraction2 - speeddata1"] = 0.1
        condition3 = 93.0
        condition = Config
        condition = condition.AttractionsSettings
        condition = condition.topscan
        condition = condition.normalstyle
        if false == condition then
            condition3 = 35.0
        end
        condition = ipairs
        counter2 = topscanhandler
        counter2 = counter2.seats
        condition, counter2, counter, isDisabled2 = condition(counter2)
        for condition2, strValue2 in condition, counter2, counter, isDisabled2 do
            index = ipairs
            isEnabled3 = strValue2.seats
            index, isEnabled3, key, value = index(isEnabled3)
            for key2, strValue4 in index, isEnabled3, key, value do
                func2 = strValue4.taken
                if true == func2 then
                    func2 = pairs
                    strValue3 = playsersinthemepark
                    func2, strValue3, var23, isEnabled2 = func2(strValue3)
                    for isDisabled, value2 in func2, strValue3, var23, isEnabled2 do
                        func = TriggerClientEvent
                        strValue = "rtx_themepark:TopScan:SynchronizeSeat"
                        var2 = value2
                        var24 = condition2
                        var22 = key2
                        isEnabled = true
                        var25 = strValue4.takenplayerid
                        func(strValue, var2, var24, var22, isEnabled, var25)
                    end
                    func2 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Global:AttractionUsing"
                    var23 = strValue4.takenplayerid
                    isEnabled2 = true
                    func2(strValue3, var23, isEnabled2)
                end
            end
        end
        condition = TriggerClientEvent
        counter2 = "rtx_themepark:Global:MusicStartAttraction"
        counter = -1
        isDisabled2 = "topscan"
        condition2 = math
        condition2 = condition2.random
        strValue2 = 1
        index = Config
        index = index.AttractionsMusic
        index = index.topscan
        index = index.playlist
        index = #index
        condition2, strValue2, index, isEnabled3, key, value, key2, strValue4, func2, strValue3, var23, isEnabled2, isDisabled, value2, func, strValue, var2, var24, var22, isEnabled, var25 = condition2(strValue2, index)
        condition(counter2, counter, isDisabled2, condition2, strValue2, index, isEnabled3, key, value, key2, strValue4, func2, strValue3, var23, isEnabled2, isDisabled, value2, func, strValue, var2, var24, var22, isEnabled, var25)
        while true do
            condition = topscanhandler
            condition = condition.stageinprogress
            if true ~= condition then
                break
            end
            condition = Citizen
            condition = condition.Wait
            counter2 = 20
            condition(counter2)
            condition = topscanhandler
            condition = condition.stage
            if 1 == condition then
                condition = topscanhandler
                counter2 = Config
                counter2 = counter2.AttractionsSettings
                counter2 = counter2.topscan
                counter2 = counter2.speedmodifier
                counter2 = 0.1 * counter2
                condition.stagespeed = counter2
                condition = topscanhandler
                condition.stagecounter = 0
                condition = topscanhandler
                condition = condition.currentrotation
                if condition3 < condition then
                    condition = topscanhandler
                    condition.stage = 2
                    condition = topscanhandler
                    condition.stagecounter = 0
                    condition = topscanhandler
                    condition.currentrotation = condition3
                end
                condition = topscanhandler
                counter2 = topscanhandler
                counter2 = counter2.currentrotation
                counter = topscanhandler
                counter = counter.stagespeed
                counter2 = counter2 + counter
                condition.currentrotation = counter2
            else
                condition = topscanhandler
                condition = condition.stage
                if 2 == condition then
                    condition = topscanhandler
                    counter2 = Config
                    counter2 = counter2.AttractionsSettings
                    counter2 = counter2.topscan
                    counter2 = counter2.speedmodifier
                    counter2 = 0.25 * counter2
                    condition.stagespeed = counter2
                    condition = topscanhandler
                    counter2 = topscanhandler
                    counter2 = counter2.stagecounter
                    counter2 = counter2 + 1.0
                    condition.stagecounter = counter2
                    condition = topscanhandler
                    condition = condition.stagecounter
                    counter2 = 250.0
                    if condition > counter2 then
                        condition = topscanhandler
                        condition.stage = 3
                        condition = topscanhandler
                        condition.stagecounter = 0
                    end
                    condition = topscanhandler
                    counter2 = topscanhandler
                    counter2 = counter2.currentrotation2
                    counter = topscanhandler
                    counter = counter.stagespeed
                    counter2 = counter2 + counter
                    condition.currentrotation2 = counter2
                    condition = topscanhandler
                    counter2 = topscanhandler
                    counter2 = counter2.currentrotation3
                    counter = topscanhandler
                    counter = counter.stagespeed
                    counter2 = counter2 + counter
                    condition.currentrotation3 = counter2
                    condition = topscanhandler
                    counter2 = topscanhandler
                    counter2 = counter2.currentrotation4
                    counter = topscanhandler
                    counter = counter.stagespeed
                    counter2 = counter2 + counter
                    condition.currentrotation4 = counter2
                else
                    condition = topscanhandler
                    condition = condition.stage
                    if 3 == condition then
                        condition = topscanhandler
                        counter2 = Config
                        counter2 = counter2.AttractionsSettings
                        counter2 = counter2.topscan
                        counter2 = counter2.speedmodifier
                        counter2 = 0.5 * counter2
                        condition.stagespeed = counter2
                        condition = topscanhandler
                        counter2 = topscanhandler
                        counter2 = counter2.stagecounter
                        counter2 = counter2 + 1.0
                        condition.stagecounter = counter2
                        condition = topscanhandler
                        condition = condition.stagecounter
                        counter2 = 250.0
                        if condition > counter2 then
                            condition = topscanhandler
                            condition.stage = 4
                            condition = topscanhandler
                            condition.stagecounter = 0
                        end
                        condition = topscanhandler
                        counter2 = topscanhandler
                        counter2 = counter2.currentrotation2
                        counter = topscanhandler
                        counter = counter.stagespeed
                        counter2 = counter2 + counter
                        condition.currentrotation2 = counter2
                        condition = topscanhandler
                        counter2 = topscanhandler
                        counter2 = counter2.currentrotation3
                        counter = topscanhandler
                        counter = counter.stagespeed
                        counter2 = counter2 + counter
                        condition.currentrotation3 = counter2
                        condition = topscanhandler
                        counter2 = topscanhandler
                        counter2 = counter2.currentrotation4
                        counter = topscanhandler
                        counter = counter.stagespeed
                        counter2 = counter2 + counter
                        condition.currentrotation4 = counter2
                    else
                        condition = topscanhandler
                        condition = condition.stage
                        if 4 == condition then
                            condition = topscanhandler
                            counter2 = Config
                            counter2 = counter2.AttractionsSettings
                            counter2 = counter2.topscan
                            counter2 = counter2.speedmodifier
                            counter2 = 0.75 * counter2
                            condition.stagespeed = counter2
                            condition = topscanhandler
                            counter2 = topscanhandler
                            counter2 = counter2.stagecounter
                            counter2 = counter2 + 1.0
                            condition.stagecounter = counter2
                            condition = topscanhandler
                            condition = condition.stagecounter
                            counter2 = 250.0
                            if condition > counter2 then
                                condition = topscanhandler
                                condition.stage = 5
                                condition = topscanhandler
                                condition.stagecounter = 0
                            end
                            condition = topscanhandler
                            counter2 = topscanhandler
                            counter2 = counter2.currentrotation2
                            counter = topscanhandler
                            counter = counter.stagespeed
                            counter2 = counter2 + counter
                            condition.currentrotation2 = counter2
                            condition = topscanhandler
                            counter2 = topscanhandler
                            counter2 = counter2.currentrotation3
                            counter = topscanhandler
                            counter = counter.stagespeed
                            counter2 = counter2 + counter
                            condition.currentrotation3 = counter2
                            condition = topscanhandler
                            counter2 = topscanhandler
                            counter2 = counter2.currentrotation4
                            counter = topscanhandler
                            counter = counter.stagespeed
                            counter2 = counter2 + counter
                            condition.currentrotation4 = counter2
                        else
                            condition = topscanhandler
                            condition = condition.stage
                            if 5 == condition then
                                condition = topscanhandler
                                counter2 = Config
                                counter2 = counter2.AttractionsSettings
                                counter2 = counter2.topscan
                                counter2 = counter2.speedmodifier
                                counter2 = 1.0 * counter2
                                condition.stagespeed = counter2
                                condition = topscanhandler
                                counter2 = topscanhandler
                                counter2 = counter2.stagecounter
                                counter2 = counter2 + 1.0
                                condition.stagecounter = counter2
                                condition = topscanhandler
                                condition = condition.stagecounter
                                counter2 = 250.0
                                if condition > counter2 then
                                    condition = topscanhandler
                                    condition.stage = 6
                                    condition = topscanhandler
                                    condition.stagecounter = 0
                                end
                                condition = topscanhandler
                                counter2 = topscanhandler
                                counter2 = counter2.currentrotation2
                                counter = topscanhandler
                                counter = counter.stagespeed
                                counter2 = counter2 + counter
                                condition.currentrotation2 = counter2
                                condition = topscanhandler
                                counter2 = topscanhandler
                                counter2 = counter2.currentrotation3
                                counter = topscanhandler
                                counter = counter.stagespeed
                                counter2 = counter2 + counter
                                condition.currentrotation3 = counter2
                                condition = topscanhandler
                                counter2 = topscanhandler
                                counter2 = counter2.currentrotation4
                                counter = topscanhandler
                                counter = counter.stagespeed
                                counter2 = counter2 + counter
                                condition.currentrotation4 = counter2
                            else
                                condition = topscanhandler
                                condition = condition.stage
                                if 6 == condition then
                                    condition = topscanhandler
                                    counter2 = Config
                                    counter2 = counter2.AttractionsSettings
                                    counter2 = counter2.topscan
                                    counter2 = counter2.speedmodifier
                                    counter2 = 1.5 * counter2
                                    condition.stagespeed = counter2
                                    condition = topscanhandler
                                    counter2 = topscanhandler
                                    counter2 = counter2.stagecounter
                                    counter2 = counter2 + 1.0
                                    condition.stagecounter = counter2
                                    condition = topscanhandler
                                    condition = condition.stagecounter
                                    counter2 = 250.0
                                    if condition > counter2 then
                                        condition = topscanhandler
                                        condition.stage = 7
                                        condition = topscanhandler
                                        condition.stagecounter = 0
                                    end
                                    condition = topscanhandler
                                    counter2 = topscanhandler
                                    counter2 = counter2.currentrotation2
                                    counter = topscanhandler
                                    counter = counter.stagespeed
                                    counter2 = counter2 + counter
                                    condition.currentrotation2 = counter2
                                    condition = topscanhandler
                                    counter2 = topscanhandler
                                    counter2 = counter2.currentrotation3
                                    counter = topscanhandler
                                    counter = counter.stagespeed
                                    counter2 = counter2 + counter
                                    condition.currentrotation3 = counter2
                                    condition = topscanhandler
                                    counter2 = topscanhandler
                                    counter2 = counter2.currentrotation4
                                    counter = topscanhandler
                                    counter = counter.stagespeed
                                    counter2 = counter2 + counter
                                    condition.currentrotation4 = counter2
                                else
                                    condition = topscanhandler
                                    condition = condition.stage
                                    if 7 == condition then
                                        condition = topscanhandler
                                        counter2 = Config
                                        counter2 = counter2.AttractionsSettings
                                        counter2 = counter2.topscan
                                        counter2 = counter2.speedmodifier
                                        counter2 = 2.5 * counter2
                                        condition.stagespeed = counter2
                                        condition = topscanhandler
                                        counter2 = topscanhandler
                                        counter2 = counter2.currentrotation2
                                        counter = topscanhandler
                                        counter = counter.stagespeed
                                        counter2 = counter2 + counter
                                        condition.currentrotation2 = counter2
                                        condition = topscanhandler
                                        counter2 = topscanhandler
                                        counter2 = counter2.currentrotation3
                                        counter = topscanhandler
                                        counter = counter.stagespeed
                                        counter2 = counter2 + counter
                                        condition.currentrotation3 = counter2
                                        condition = topscanhandler
                                        counter2 = topscanhandler
                                        counter2 = counter2.currentrotation4
                                        counter = topscanhandler
                                        counter = counter.stagespeed
                                        counter2 = counter2 + counter
                                        condition.currentrotation4 = counter2
                                        condition = topscanhandler
                                        condition = condition.currentrotation2
                                        counter2 = 359.9
                                        if condition > counter2 then
                                            condition = topscanhandler
                                            counter2 = topscanhandler
                                            counter2 = counter2.stagecounter
                                            counter2 = counter2 + 1
                                            condition.stagecounter = counter2
                                            condition = topscanhandler
                                            condition = condition.stagecounter
                                            counter2 = Config
                                            counter2 = counter2.AttractionsSettings
                                            counter2 = counter2.topscan
                                            counter2 = counter2.maxrounds
                                            if condition > counter2 then
                                                condition = topscanhandler
                                                condition.stage = 8
                                                condition = topscanhandler
                                                condition.stagecounter = 0
                                            end
                                        end
                                    else
                                        condition = topscanhandler
                                        condition = condition.stage
                                        if 8 == condition then
                                            condition = topscanhandler
                                            counter2 = Config
                                            counter2 = counter2.AttractionsSettings
                                            counter2 = counter2.topscan
                                            counter2 = counter2.speedmodifier
                                            counter2 = 1.5 * counter2
                                            condition.stagespeed = counter2
                                            condition = topscanhandler
                                            counter2 = topscanhandler
                                            counter2 = counter2.stagecounter
                                            counter2 = counter2 + 1.0
                                            condition.stagecounter = counter2
                                            condition = topscanhandler
                                            condition = condition.stagecounter
                                            if condition > 100.0 then
                                                condition = topscanhandler
                                                condition.stage = 9
                                                condition = topscanhandler
                                                condition.stagecounter = 0
                                            end
                                            condition = topscanhandler
                                            counter2 = topscanhandler
                                            counter2 = counter2.currentrotation2
                                            counter = topscanhandler
                                            counter = counter.stagespeed
                                            counter2 = counter2 + counter
                                            condition.currentrotation2 = counter2
                                            condition = topscanhandler
                                            counter2 = topscanhandler
                                            counter2 = counter2.currentrotation3
                                            counter = topscanhandler
                                            counter = counter.stagespeed
                                            counter2 = counter2 + counter
                                            condition.currentrotation3 = counter2
                                            condition = topscanhandler
                                            counter2 = topscanhandler
                                            counter2 = counter2.currentrotation4
                                            counter = topscanhandler
                                            counter = counter.stagespeed
                                            counter2 = counter2 + counter
                                            condition.currentrotation4 = counter2
                                        else
                                            condition = topscanhandler
                                            condition = condition.stage
                                            if 9 == condition then
                                                condition = topscanhandler
                                                counter2 = Config
                                                counter2 = counter2.AttractionsSettings
                                                counter2 = counter2.topscan
                                                counter2 = counter2.speedmodifier
                                                counter2 = 1.0 * counter2
                                                condition.stagespeed = counter2
                                                condition = topscanhandler
                                                counter2 = topscanhandler
                                                counter2 = counter2.stagecounter
                                                counter2 = counter2 + 1.0
                                                condition.stagecounter = counter2
                                                condition = topscanhandler
                                                condition = condition.stagecounter
                                                if condition > 100.0 then
                                                    condition = topscanhandler
                                                    condition.stage = 10
                                                    condition = topscanhandler
                                                    condition.stagecounter = 0
                                                end
                                                condition = topscanhandler
                                                counter2 = topscanhandler
                                                counter2 = counter2.currentrotation2
                                                counter = topscanhandler
                                                counter = counter.stagespeed
                                                counter2 = counter2 + counter
                                                condition.currentrotation2 = counter2
                                                condition = topscanhandler
                                                counter2 = topscanhandler
                                                counter2 = counter2.currentrotation3
                                                counter = topscanhandler
                                                counter = counter.stagespeed
                                                counter2 = counter2 + counter
                                                condition.currentrotation3 = counter2
                                                condition = topscanhandler
                                                counter2 = topscanhandler
                                                counter2 = counter2.currentrotation4
                                                counter = topscanhandler
                                                counter = counter.stagespeed
                                                counter2 = counter2 + counter
                                                condition.currentrotation4 = counter2
                                            else
                                                condition = topscanhandler
                                                condition = condition.stage
                                                if 10 == condition then
                                                    condition = topscanhandler
                                                    counter2 = Config
                                                    counter2 = counter2.AttractionsSettings
                                                    counter2 = counter2.topscan
                                                    counter2 = counter2.speedmodifier
                                                    counter2 = 0.75 * counter2
                                                    condition.stagespeed = counter2
                                                    condition = topscanhandler
                                                    counter2 = topscanhandler
                                                    counter2 = counter2.stagecounter
                                                    counter2 = counter2 + 1.0
                                                    condition.stagecounter = counter2
                                                    condition = topscanhandler
                                                    condition = condition.stagecounter
                                                    if condition > 100.0 then
                                                        condition = topscanhandler
                                                        condition.stage = 11
                                                        condition = topscanhandler
                                                        condition.stagecounter = 0
                                                    end
                                                    condition = topscanhandler
                                                    counter2 = topscanhandler
                                                    counter2 = counter2.currentrotation2
                                                    counter = topscanhandler
                                                    counter = counter.stagespeed
                                                    counter2 = counter2 + counter
                                                    condition.currentrotation2 = counter2
                                                    condition = topscanhandler
                                                    counter2 = topscanhandler
                                                    counter2 = counter2.currentrotation3
                                                    counter = topscanhandler
                                                    counter = counter.stagespeed
                                                    counter2 = counter2 + counter
                                                    condition.currentrotation3 = counter2
                                                    condition = topscanhandler
                                                    counter2 = topscanhandler
                                                    counter2 = counter2.currentrotation4
                                                    counter = topscanhandler
                                                    counter = counter.stagespeed
                                                    counter2 = counter2 + counter
                                                    condition.currentrotation4 = counter2
                                                else
                                                    condition = topscanhandler
                                                    condition = condition.stage
                                                    if 11 == condition then
                                                        condition = topscanhandler
                                                        counter2 = Config
                                                        counter2 = counter2.AttractionsSettings
                                                        counter2 = counter2.topscan
                                                        counter2 = counter2.speedmodifier
                                                        counter2 = 0.5 * counter2
                                                        condition.stagespeed = counter2
                                                        condition = topscanhandler
                                                        counter2 = topscanhandler
                                                        counter2 = counter2.stagecounter
                                                        counter2 = counter2 + 1.0
                                                        condition.stagecounter = counter2
                                                        condition = topscanhandler
                                                        condition = condition.stagecounter
                                                        if condition > 100.0 then
                                                            condition = topscanhandler
                                                            condition.stage = 12
                                                            condition = topscanhandler
                                                            condition.stagecounter = 0
                                                        end
                                                        condition = topscanhandler
                                                        counter2 = topscanhandler
                                                        counter2 = counter2.currentrotation2
                                                        counter = topscanhandler
                                                        counter = counter.stagespeed
                                                        counter2 = counter2 + counter
                                                        condition.currentrotation2 = counter2
                                                        condition = topscanhandler
                                                        counter2 = topscanhandler
                                                        counter2 = counter2.currentrotation3
                                                        counter = topscanhandler
                                                        counter = counter.stagespeed
                                                        counter2 = counter2 + counter
                                                        condition.currentrotation3 = counter2
                                                        condition = topscanhandler
                                                        counter2 = topscanhandler
                                                        counter2 = counter2.currentrotation4
                                                        counter = topscanhandler
                                                        counter = counter.stagespeed
                                                        counter2 = counter2 + counter
                                                        condition.currentrotation4 = counter2
                                                    else
                                                        condition = topscanhandler
                                                        condition = condition.stage
                                                        if 12 == condition then
                                                            condition = topscanhandler
                                                            counter2 = Config
                                                            counter2 = counter2.AttractionsSettings
                                                            counter2 = counter2.topscan
                                                            counter2 = counter2.speedmodifier
                                                            counter2 = 0.25 * counter2
                                                            condition.stagespeed = counter2
                                                            condition = topscanhandler
                                                            counter2 = topscanhandler
                                                            counter2 = counter2.stagecounter
                                                            counter2 = counter2 + 1.0
                                                            condition.stagecounter = counter2
                                                            condition = topscanhandler
                                                            condition = condition.stagecounter
                                                            if condition > 100.0 then
                                                                condition = topscanhandler
                                                                condition.stage = 13
                                                                condition = topscanhandler
                                                                condition.stagecounter = 0
                                                            end
                                                            condition = topscanhandler
                                                            counter2 = topscanhandler
                                                            counter2 = counter2.currentrotation2
                                                            counter = topscanhandler
                                                            counter = counter.stagespeed
                                                            counter2 = counter2 + counter
                                                            condition.currentrotation2 = counter2
                                                            condition = topscanhandler
                                                            counter2 = topscanhandler
                                                            counter2 = counter2.currentrotation3
                                                            counter = topscanhandler
                                                            counter = counter.stagespeed
                                                            counter2 = counter2 + counter
                                                            condition.currentrotation3 = counter2
                                                            condition = topscanhandler
                                                            counter2 = topscanhandler
                                                            counter2 = counter2.currentrotation4
                                                            counter = topscanhandler
                                                            counter = counter.stagespeed
                                                            counter2 = counter2 + counter
                                                            condition.currentrotation4 = counter2
                                                        else
                                                            condition = topscanhandler
                                                            condition = condition.stage
                                                            if 13 == condition then
                                                                condition = topscanhandler
                                                                counter2 = Config
                                                                counter2 = counter2.AttractionsSettings
                                                                counter2 = counter2.topscan
                                                                counter2 = counter2.speedmodifier
                                                                counter2 = 0.25 * counter2
                                                                condition.stagespeed = counter2
                                                                condition = topscanhandler
                                                                condition = condition.currentrotation2
                                                                counter2 = 360.0
                                                                if condition < counter2 then
                                                                    condition = topscanhandler
                                                                    condition = condition.currentrotation
                                                                    counter2 = 0.25
                                                                    if condition > counter2 then
                                                                        condition = topscanhandler
                                                                        counter2 = topscanhandler
                                                                        counter2 = counter2.currentrotation2
                                                                        counter = topscanhandler
                                                                        counter = counter.stagespeed
                                                                        counter2 = counter2 + counter
                                                                        condition.currentrotation2 = counter2
                                                                        condition = topscanhandler
                                                                        counter2 = topscanhandler
                                                                        counter2 = counter2.currentrotation3
                                                                        counter = topscanhandler
                                                                        counter = counter.stagespeed
                                                                        counter2 = counter2 + counter
                                                                        condition.currentrotation3 = counter2
                                                                        condition = topscanhandler
                                                                        counter2 = topscanhandler
                                                                        counter2 = counter2.currentrotation4
                                                                        counter = topscanhandler
                                                                        counter = counter.stagespeed
                                                                        counter2 = counter2 + counter
                                                                        condition.currentrotation4 = counter2
                                                                    end
                                                                else
                                                                    condition = topscanhandler
                                                                    condition.currentrotation2 = 360.0
                                                                    condition = topscanhandler
                                                                    condition.currentrotation3 = 360.0
                                                                    condition = topscanhandler
                                                                    condition.currentrotation4 = 360.0
                                                                    condition = topscanhandler
                                                                    condition.stagecounter = 0
                                                                    condition = topscanhandler
                                                                    condition.stage = 14
                                                                end
                                                            else
                                                                condition = topscanhandler
                                                                condition = condition.stage
                                                                if 14 == condition then
                                                                    condition = topscanhandler
                                                                    counter2 = Config
                                                                    counter2 = counter2.AttractionsSettings
                                                                    counter2 = counter2.topscan
                                                                    counter2 = counter2.speedmodifier
                                                                    counter2 = 0.1 * counter2
                                                                    condition.stagespeed = counter2
                                                                    condition = topscanhandler
                                                                    condition.stagecounter = 0.0
                                                                    condition = topscanhandler
                                                                    condition = condition.currentrotation
                                                                    counter2 = 0.1
                                                                    if condition < counter2 then
                                                                        condition = topscanhandler
                                                                        condition.stage = 15
                                                                        condition = topscanhandler
                                                                        condition.stagecounter = 0
                                                                        condition = topscanhandler
                                                                        condition.currentrotation = 0.0
                                                                    end
                                                                    condition = topscanhandler
                                                                    counter2 = topscanhandler
                                                                    counter2 = counter2.currentrotation
                                                                    counter = topscanhandler
                                                                    counter = counter.stagespeed
                                                                    counter2 = counter2 - counter
                                                                    condition.currentrotation = counter2
                                                                else
                                                                    condition = topscanhandler
                                                                    condition = condition.stage
                                                                    if 15 == condition then
                                                                        condition = topscanhandler
                                                                        condition.currentrotation = 0.0
                                                                        condition = topscanhandler
                                                                        condition.stageinprogress = false
                                                                        condition = ipairs
                                                                        counter2 = topscanhandler
                                                                        counter2 = counter2.seats
                                                                        condition, counter2, counter, isDisabled2 = condition(counter2)
                                                                        for condition2, strValue2 in condition, counter2, counter, isDisabled2 do
                                                                            index = ipairs
                                                                            isEnabled3 = strValue2.seats
                                                                            index, isEnabled3, key, value = index(isEnabled3)
                                                                            for key2, strValue4 in index, isEnabled3, key, value do
                                                                                func2 = strValue4.taken
                                                                                if true == func2 then
                                                                                    strValue4.taken = false
                                                                                    func2 = pairs
                                                                                    strValue3 = playsersinthemepark
                                                                                    func2, strValue3, var23, isEnabled2 = func2(strValue3)
                                                                                    for isDisabled, value2 in func2, strValue3, var23, isEnabled2 do
                                                                                        func = TriggerClientEvent
                                                                                        strValue = "rtx_themepark:TopScan:SynchronizeSeat"
                                                                                        var2 = value2
                                                                                        var24 = condition2
                                                                                        var22 = key2
                                                                                        isEnabled = false
                                                                                        var25 = strValue4.takenplayerid
                                                                                        func(strValue, var2, var24, var22, isEnabled, var25)
                                                                                    end
                                                                                    func2 = TriggerClientEvent
                                                                                    strValue3 = "rtx_themepark:TopScan:SeatExit"
                                                                                    var23 = strValue4.takenplayerid
                                                                                    isEnabled2 = true
                                                                                    func2(strValue3, var23, isEnabled2)
                                                                                    func2 = TriggerClientEvent
                                                                                    strValue3 = "rtx_themepark:Global:AttractionUsing"
                                                                                    var23 = strValue4.takenplayerid
                                                                                    isEnabled2 = false
                                                                                    func2(strValue3, var23, isEnabled2)
                                                                                    func2 = TriggerClientEvent
                                                                                    strValue3 = "rtx_themepark:Global:TicketHandler"
                                                                                    var23 = strValue4.takenplayerid
                                                                                    isEnabled2 = 2
                                                                                    isDisabled = false
                                                                                    func2(strValue3, var23, isEnabled2, isDisabled)
                                                                                    strValue4.takenplayerid = nil
                                                                                end
                                                                            end
                                                                        end
                                                                        condition = Citizen
                                                                        condition = condition.Wait
                                                                        counter2 = 5000
                                                                        condition(counter2)
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
            condition = topscanhandler
            condition = condition.stage
            if 1 ~= condition then
                condition = topscanhandler
                condition = condition.stage
                if 14 == condition then
                else
                    condition = topscanhandler
                    condition = condition.currentrotation2
                    counter2 = 360.0
                    if condition > counter2 then
                        condition = topscanhandler
                        condition = condition.currentrotation2
                        condition = condition - 360.0
                        counter2 = topscanhandler
                        counter = 0.0 + condition
                        counter2.currentrotation2 = counter
                    end
                    condition = topscanhandler
                    condition = condition.currentrotation3
                    counter2 = 360.0
                    if condition > counter2 then
                        condition = topscanhandler
                        condition = condition.currentrotation3
                        condition = condition - 360.0
                        counter2 = topscanhandler
                        counter = 0.0 + condition
                        counter2.currentrotation3 = counter
                    end
                    condition = topscanhandler
                    condition = condition.currentrotation4
                    counter2 = 360.0
                    if condition > counter2 then
                        condition = topscanhandler
                        condition = condition.currentrotation4
                        condition = condition - 360.0
                        counter2 = topscanhandler
                        counter = 0.0 + condition
                        counter2.currentrotation4 = counter
                    end
                end
            end
            condition = GlobalState
            counter2 = topscanhandler
            counter2 = counter2.stage
            condition["attraction2 - phase"] = counter2
            condition = GlobalState
            counter2 = topscanhandler
            counter2 = counter2.currentrotation
            condition["attraction2 - ridedata1"] = counter2
            condition = GlobalState
            counter2 = topscanhandler
            counter2 = counter2.currentrotation2
            condition["attraction2 - ridedata2"] = counter2
            condition = GlobalState
            counter2 = topscanhandler
            counter2 = counter2.currentrotation3
            condition["attraction2 - ridedata3"] = counter2
            condition = GlobalState
            counter2 = topscanhandler
            counter2 = counter2.currentrotation4
            condition["attraction2 - ridedata4"] = counter2
            condition = GlobalState
            counter2 = topscanhandler
            counter2 = counter2.stagespeed
            condition["attraction2 - speeddata1"] = counter2
            condition = GlobalState
            counter2 = GlobalState
            counter2 = counter2["attraction2 - synchdata"]
            counter2 = counter2 + 1
            condition["attraction2 - synchdata"] = counter2
        end
        condition = TriggerClientEvent
        counter2 = "rtx_themepark:Global:MusicStopAttraction"
        counter = -1
        isDisabled2 = "topscan"
        condition(counter2, counter, isDisabled2)
        condition = topscanhandler
        condition.currentrotation = 0.0
        condition = topscanhandler
        condition.currentrotation2 = 0.0
        condition = topscanhandler
        condition.currentrotation3 = 0.0
        condition = topscanhandler
        condition.currentrotation4 = 0.0
        condition = GlobalState
        condition["attraction2 - phase"] = 0
        condition = GlobalState
        condition["attraction2 - ridedata1"] = 0.0
        condition = GlobalState
        condition["attraction2 - ridedata2"] = 0.0
        condition = GlobalState
        condition["attraction2 - ridedata3"] = 0.0
        condition = GlobalState
        condition["attraction2 - ridedata4"] = 0.0
        condition = topscanhandler
        condition.started = false
        condition = TriggerClientEvent
        counter2 = "rtx_themepark:TopScan:SynchronizeStarted"
        counter = -1
        isDisabled2 = false
        condition(counter2, counter, isDisabled2)
    end
end
StartTopScan = dataTable
dataTable = RegisterServerEvent
coords = "rtx_themepark:TopScan:SeatUse"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:TopScan:SeatUse"

function dataTable2(A0_2, A1_2)
    local counter2, counter, isDisabled2, condition2, strValue2, index, isEnabled3, key, value, key2, strValue4, func2, strValue3, var23, isEnabled2, isDisabled
    counter2 = source
    counter = themeparkattractionsopenstatus
    counter = counter[2]
    if true == counter then
        counter = themeparkdisabled
        if false == counter then
            if nil ~= A0_2 and nil ~= A1_2 then
                counter = topscanhandler
                counter = counter.started
                if false == counter then
                    counter = topscanhandler
                    counter = counter.seats
                    counter = counter[A0_2]
                    isDisabled2 = counter.seats
                    isDisabled2 = isDisabled2[A1_2]
                    condition2 = isDisabled2.taken
                    if false == condition2 then
                        isDisabled2.taken = true
                        isDisabled2.takenplayerid = counter2
                        condition2 = pairs
                        strValue2 = playsersinthemepark
                        condition2, strValue2, index, isEnabled3 = condition2(strValue2)
                        for key, value in condition2, strValue2, index, isEnabled3 do
                            key2 = TriggerClientEvent
                            strValue4 = "rtx_themepark:TopScan:SynchronizeSeat"
                            func2 = value
                            strValue3 = A0_2
                            var23 = A1_2
                            isEnabled2 = true
                            isDisabled = isDisabled2.takenplayerid
                            key2(strValue4, func2, strValue3, var23, isEnabled2, isDisabled)
                        end
                        condition2 = TriggerClientEvent
                        strValue2 = "rtx_themepark:TopScan:SeatData"
                        index = counter2
                        isEnabled3 = A0_2
                        key = A1_2
                        condition2(strValue2, index, isEnabled3, key)
                        condition2 = TriggerClientEvent
                        strValue2 = "rtx_themepark:TopScan:DisableCollision"
                        index = counter2
                        condition2(strValue2, index)
                        condition2 = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:AttractionUsing"
                        index = counter2
                        isEnabled3 = true
                        condition2(strValue2, index, isEnabled3)
                        condition2 = Config
                        condition2 = condition2.ThemeParkControlAttractions
                        if false == condition2 then
                            condition2 = topscanhandler
                            condition2 = condition2.started
                            if false == condition2 then
                                condition2 = attractionlockdown
                                if false == condition2 then
                                    condition2 = Wait
                                    strValue2 = Config
                                    strValue2 = strValue2.AttractionsSettings
                                    strValue2 = strValue2.topscan
                                    strValue2 = strValue2.waitforplayers
                                    condition2(strValue2)
                                    condition2 = topscanhandler
                                    condition2 = condition2.started
                                    if false == condition2 then
                                        condition2 = topscanhandler
                                        condition2.started = true
                                        condition2 = TriggerClientEvent
                                        strValue2 = "rtx_themepark:TopScan:SynchronizeStarted"
                                        index = -1
                                        isEnabled3 = true
                                        condition2(strValue2, index, isEnabled3)
                                        condition2 = StartTopScan
                                        condition2()
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
        isDisabled2 = "rtx_themepark:Notify"
        condition2 = counter2
        strValue2 = Language
        index = Config
        index = index.Language
        strValue2 = strValue2[index]
        strValue2 = strValue2.attractionclosed
        counter(isDisabled2, condition2, strValue2)
    end
end
dataTable(coords, dataTable2)
dataTable = RegisterServerEvent
coords = "rtx_themepark:TopScan:ExitAttraction"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:TopScan:ExitAttraction"

function dataTable2(A0_2, A1_2)
    local counter2, counter, isDisabled2, condition2, strValue2, index, isEnabled3, key, value, key2, strValue4, func2, strValue3, var23, isEnabled2, isDisabled
    counter2 = source
    if nil ~= A0_2 and nil ~= A1_2 then
        counter = topscanhandler
        counter = counter.seats
        counter = counter[A0_2]
        isDisabled2 = counter.seats
        isDisabled2 = isDisabled2[A1_2]
        condition2 = isDisabled2.taken
        if true == condition2 then
            condition2 = isDisabled2.takenplayerid
            if condition2 == counter2 then
                condition2 = Config
                condition2 = condition2.ThemeParkDisableExit
                if false ~= condition2 then
                    condition2 = topscanhandler
                    condition2 = condition2.started
                    if false ~= condition2 then
                        goto lbl_54
                    end
                end
                condition2 = pairs
                strValue2 = playsersinthemepark
                condition2, strValue2, index, isEnabled3 = condition2(strValue2)
                for key, value in condition2, strValue2, index, isEnabled3 do
                    key2 = TriggerClientEvent
                    strValue4 = "rtx_themepark:TopScan:SynchronizeSeat"
                    func2 = value
                    strValue3 = A0_2
                    var23 = A1_2
                    isEnabled2 = false
                    isDisabled = isDisabled2.takenplayerid
                    key2(strValue4, func2, strValue3, var23, isEnabled2, isDisabled)
                end
                condition2 = TriggerClientEvent
                strValue2 = "rtx_themepark:TopScan:SeatExit"
                index = isDisabled2.takenplayerid
                isEnabled3 = false
                condition2(strValue2, index, isEnabled3)
                condition2 = TriggerClientEvent
                strValue2 = "rtx_themepark:Global:AttractionUsing"
                index = isDisabled2.takenplayerid
                isEnabled3 = false
                condition2(strValue2, index, isEnabled3)
                isDisabled2.taken = false
                isDisabled2.takenplayerid = nil
                isDisabled2.seattype = 1
                goto lbl_63
                ::lbl_54::
                condition2 = TriggerClientEvent
                strValue2 = "rtx_themepark:Notify"
                index = counter2
                isEnabled3 = Language
                key = Config
                key = key.Language
                isEnabled3 = isEnabled3[key]
                isEnabled3 = isEnabled3.inprogress
                condition2(strValue2, index, isEnabled3)
            end
        end
    end
    ::lbl_63::
end
dataTable(coords, dataTable2)
dataTable = Config
dataTable = dataTable.ThemeParkAttractionFallChance
if dataTable then
    dataTable = Config
    dataTable = dataTable.ThemeParkFallSettings
    dataTable = dataTable.attractions
    dataTable = dataTable.topscan
    if dataTable then
        dataTable = RegisterServerEvent
        coords = "rtx_themepark:TopScan:ThrowAttraction"
        dataTable(coords)
        dataTable = AddEventHandler
        coords = "rtx_themepark:TopScan:ThrowAttraction"

        function dataTable2(A0_2, A1_2)
            local counter2, counter, isDisabled2, condition2, strValue2, index, isEnabled3, key, value, key2, strValue4, func2, strValue3, var23, isEnabled2, isDisabled
            counter2 = source
            if nil ~= A0_2 and nil ~= A1_2 then
                counter = topscanhandler
                counter = counter.seats
                counter = counter[A0_2]
                isDisabled2 = counter.seats
                isDisabled2 = isDisabled2[A1_2]
                condition2 = isDisabled2.taken
                if true == condition2 then
                    condition2 = isDisabled2.takenplayerid
                    if condition2 == counter2 then
                        condition2 = pairs
                        strValue2 = playsersinthemepark
                        condition2, strValue2, index, isEnabled3 = condition2(strValue2)
                        for key, value in condition2, strValue2, index, isEnabled3 do
                            key2 = TriggerClientEvent
                            strValue4 = "rtx_themepark:TopScan:SynchronizeSeat"
                            func2 = value
                            strValue3 = A0_2
                            var23 = A1_2
                            isEnabled2 = false
                            isDisabled = isDisabled2.takenplayerid
                            key2(strValue4, func2, strValue3, var23, isEnabled2, isDisabled)
                        end
                        condition2 = TriggerClientEvent
                        strValue2 = "rtx_themepark:TopScan:SeatThrowClient"
                        index = isDisabled2.takenplayerid
                        condition2(strValue2, index)
                        condition2 = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:AttractionUsing"
                        index = isDisabled2.takenplayerid
                        isEnabled3 = false
                        condition2(strValue2, index, isEnabled3)
                        isDisabled2.taken = false
                        isDisabled2.takenplayerid = nil
                        isDisabled2.seattype = 1
                    end
                end
            end
        end
        dataTable(coords, dataTable2)
    end
end