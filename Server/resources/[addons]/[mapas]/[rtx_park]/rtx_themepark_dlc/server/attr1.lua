
local dataTable, coords, dataTable2, dataTable4, dataTable3
dataTable = {}
coords = vector3
dataTable2 = -1637.83447
dataTable4 = -1078.90576
dataTable3 = 41.26547
coords = coords(dataTable2, dataTable4, dataTable3)
dataTable.coords = coords
dataTable.started = false
dataTable.changingsides = false
dataTable.currentrotation = 0.0
dataTable.seatdown = 1
dataTable.stageinprogress = false
dataTable.stage = 15
dataTable.stagecounter = 0
dataTable.stagespeed = 0.5
coords = {}
dataTable2 = {}
dataTable2.cageclosed = false
dataTable4 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[4] = dataTable3
dataTable2.seats = dataTable4
coords[1] = dataTable2
dataTable2 = {}
dataTable2.cageclosed = true
dataTable4 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable4[4] = dataTable3
dataTable2.seats = dataTable4
coords[2] = dataTable2
dataTable.seats = coords
gforcehandler = dataTable
dataTable = GlobalState
dataTable["attraction1 - phase"] = 0
dataTable = GlobalState
dataTable["attraction1 - ridedata1"] = 0.0
dataTable = GlobalState
dataTable["attraction1 - speeddata1"] = 0.1
dataTable = GlobalState
dataTable["attraction1 - synchdata"] = 1

function dataTable()
    local tableData2, tableData, strValue6, counter, counter2, isDisabled3, strValue3, value, isEnabled6, strValue, strValue4, isEnabled2, strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2, var23, isEnabled4, var22, isEnabled, var24, var2
    tableData2 = gforcehandler
    tableData2 = tableData2.started
    if true == tableData2 then
        tableData2 = gforcehandler
        tableData2 = tableData2.seats
        tableData = gforcehandler
        tableData = tableData.seatdown
        tableData2 = tableData2[tableData]
        tableData2.cageclosed = false
        tableData = pairs
        strValue6 = playsersinthemepark
        tableData, strValue6, counter, counter2 = tableData(strValue6)
        for isDisabled3, strValue3 in tableData, strValue6, counter, counter2 do
            value = TriggerClientEvent
            isEnabled6 = "rtx_themepark:GForce:SynchronizeCageClient"
            strValue = strValue3
            strValue4 = gforcehandler
            strValue4 = strValue4.seatdown
            isEnabled2 = false
            value(isEnabled6, strValue, strValue4, isEnabled2)
        end
        tableData = Citizen
        tableData = tableData.Wait
        strValue6 = 5000
        tableData(strValue6)
        tableData = TriggerClientEvent
        strValue6 = "rtx_themepark:Global:MusicStartAttraction"
        counter = -1
        counter2 = "gforce"
        isDisabled3 = math
        isDisabled3 = isDisabled3.random
        strValue3 = 1
        value = Config
        value = value.AttractionsMusic
        value = value.gforce
        value = value.playlist
        value = #value
        isDisabled3, strValue3, value, isEnabled6, strValue, strValue4, isEnabled2, strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2, var23, isEnabled4, var22, isEnabled, var24, var2 = isDisabled3(strValue3, value)
        tableData(strValue6, counter, counter2, isDisabled3, strValue3, value, isEnabled6, strValue, strValue4, isEnabled2, strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2, var23, isEnabled4, var22, isEnabled, var24, var2)
        tableData = gforcehandler
        tableData.stageinprogress = true
        tableData = gforcehandler
        tableData.stage = 22
        tableData = gforcehandler
        tableData.stagecounter = 0
        tableData = gforcehandler
        tableData.stagespeed = 0.5
        tableData = GlobalState
        tableData["attraction1 - phase"] = 22
        tableData = GlobalState
        tableData["attraction1 - ridedata1"] = 0.0
        tableData = GlobalState
        tableData["attraction1 - speeddata1"] = 0.1
        tableData = GlobalState
        tableData["attraction1 - synchdata"] = 1
        tableData = gforcehandler
        tableData = tableData.seats
        tableData = tableData[1]
        strValue6 = ipairs
        counter = tableData.seats
        strValue6, counter, counter2, isDisabled3 = strValue6(counter)
        for strValue3, value in strValue6, counter, counter2, isDisabled3 do
            isEnabled6 = value.taken
            if true == isEnabled6 then
                isEnabled6 = pairs
                strValue = playsersinthemepark
                isEnabled6, strValue, strValue4, isEnabled2 = isEnabled6(strValue)
                for strValue5, isEnabled5 in isEnabled6, strValue, strValue4, isEnabled2 do
                    isDisabled2 = TriggerClientEvent
                    isDisabled = "rtx_themepark:GForce:SynchronizeSeat"
                    isEnabled3 = isEnabled5
                    strValue2 = 1
                    var23 = strValue3
                    isEnabled4 = true
                    var22 = value.takenplayerid
                    isEnabled = value.seattype
                    isDisabled2(isDisabled, isEnabled3, strValue2, var23, isEnabled4, var22, isEnabled)
                end
                isEnabled6 = TriggerClientEvent
                strValue = "rtx_themepark:Global:AttractionUsing"
                strValue4 = value.takenplayerid
                isEnabled2 = true
                isEnabled6(strValue, strValue4, isEnabled2)
            end
        end
        while true do
            strValue6 = gforcehandler
            strValue6 = strValue6.stageinprogress
            if true ~= strValue6 then
                break
            end
            strValue6 = Citizen
            strValue6 = strValue6.Wait
            counter = 20
            strValue6(counter)
            strValue6 = gforcehandler
            strValue6 = strValue6.stage
            if 22 == strValue6 then
                strValue6 = gforcehandler
                counter = Config
                counter = counter.AttractionsSettings
                counter = counter.gforce
                counter = counter.speedmodifier
                counter = 0.25 * counter
                strValue6.stagespeed = counter
                strValue6 = gforcehandler
                strValue6 = strValue6.currentrotation
                counter = 180.0
                if not (strValue6 < counter) then
                    strValue6 = gforcehandler
                    strValue6 = strValue6.currentrotation
                    counter = 180.25
                    if not (strValue6 > counter) then
                        goto lbl_132
                    end
                end
                strValue6 = gforcehandler
                counter = gforcehandler
                counter = counter.currentrotation
                counter2 = gforcehandler
                counter2 = counter2.stagespeed
                counter = counter + counter2
                strValue6.currentrotation = counter
                goto lbl_905
                ::lbl_132::
                strValue6 = gforcehandler
                strValue6.currentrotation = 180.0
                strValue6 = gforcehandler
                strValue6.stage = 20
            else
                strValue6 = gforcehandler
                strValue6 = strValue6.stage
                if 20 == strValue6 then
                    strValue6 = gforcehandler
                    strValue6.currentrotation = 180.0
                    strValue6 = gforcehandler
                    strValue6.seatdown = 2
                    strValue6 = gforcehandler
                    strValue6.started = false
                    strValue6 = pairs
                    counter = playsersinthemepark
                    strValue6, counter, counter2, isDisabled3 = strValue6(counter)
                    for strValue3, value in strValue6, counter, counter2, isDisabled3 do
                        isEnabled6 = TriggerClientEvent
                        strValue = "rtx_themepark:GForce:SeatDown"
                        strValue4 = value
                        isEnabled2 = 2
                        isEnabled6(strValue, strValue4, isEnabled2)
                    end
                    strValue6 = TriggerClientEvent
                    counter = "rtx_themepark:GForce:SynchronizeStarted"
                    counter2 = -1
                    isDisabled3 = false
                    strValue6(counter, counter2, isDisabled3)
                    strValue6 = gforcehandler
                    strValue6 = strValue6.seats
                    strValue6 = strValue6[2]
                    strValue6.cageclosed = true
                    counter = pairs
                    counter2 = playsersinthemepark
                    counter, counter2, isDisabled3, strValue3 = counter(counter2)
                    for value, isEnabled6 in counter, counter2, isDisabled3, strValue3 do
                        strValue = TriggerClientEvent
                        strValue4 = "rtx_themepark:GForce:SynchronizeCageClient"
                        isEnabled2 = isEnabled6
                        strValue5 = 2
                        isEnabled5 = true
                        strValue(strValue4, isEnabled2, strValue5, isEnabled5)
                    end
                    counter = Citizen
                    counter = counter.Wait
                    counter2 = 2500
                    counter(counter2)
                    counter = Wait
                    counter2 = Config
                    counter2 = counter2.AttractionsSettings
                    counter2 = counter2.gforce
                    counter2 = counter2.waitforplayers
                    counter(counter2)
                    counter = gforcehandler
                    counter = counter.seats
                    counter = counter[2]
                    counter2 = ipairs
                    isDisabled3 = counter.seats
                    counter2, isDisabled3, strValue3, value = counter2(isDisabled3)
                    for isEnabled6, strValue in counter2, isDisabled3, strValue3, value do
                        strValue4 = strValue.taken
                        if true == strValue4 then
                            strValue4 = pairs
                            isEnabled2 = playsersinthemepark
                            strValue4, isEnabled2, strValue5, isEnabled5 = strValue4(isEnabled2)
                            for isDisabled2, isDisabled in strValue4, isEnabled2, strValue5, isEnabled5 do
                                isEnabled3 = TriggerClientEvent
                                strValue2 = "rtx_themepark:GForce:SynchronizeSeat"
                                var23 = isDisabled
                                isEnabled4 = 2
                                var22 = isEnabled6
                                isEnabled = true
                                var24 = strValue.takenplayerid
                                var2 = strValue.seattype
                                isEnabled3(strValue2, var23, isEnabled4, var22, isEnabled, var24, var2)
                            end
                            strValue4 = TriggerClientEvent
                            isEnabled2 = "rtx_themepark:Global:AttractionUsing"
                            strValue5 = strValue.takenplayerid
                            isEnabled5 = true
                            strValue4(isEnabled2, strValue5, isEnabled5)
                        end
                    end
                    counter2 = gforcehandler
                    counter2 = counter2.seats
                    counter2 = counter2[2]
                    counter2.cageclosed = false
                    isDisabled3 = pairs
                    strValue3 = playsersinthemepark
                    isDisabled3, strValue3, value, isEnabled6 = isDisabled3(strValue3)
                    for strValue, strValue4 in isDisabled3, strValue3, value, isEnabled6 do
                        isEnabled2 = TriggerClientEvent
                        strValue5 = "rtx_themepark:GForce:SynchronizeCageClient"
                        isEnabled5 = strValue4
                        isDisabled2 = 2
                        isDisabled = false
                        isEnabled2(strValue5, isEnabled5, isDisabled2, isDisabled)
                    end
                    isDisabled3 = Citizen
                    isDisabled3 = isDisabled3.Wait
                    strValue3 = 5000
                    isDisabled3(strValue3)
                    isDisabled3 = gforcehandler
                    isDisabled3.stage = 1
                    isDisabled3 = gforcehandler
                    isDisabled3.started = true
                    isDisabled3 = TriggerClientEvent
                    strValue3 = "rtx_themepark:GForce:SynchronizeStarted"
                    value = -1
                    isEnabled6 = true
                    isDisabled3(strValue3, value, isEnabled6)
                else
                    strValue6 = gforcehandler
                    strValue6 = strValue6.stage
                    if 1 == strValue6 then
                        strValue6 = gforcehandler
                        counter = Config
                        counter = counter.AttractionsSettings
                        counter = counter.gforce
                        counter = counter.speedmodifier
                        counter = 0.25 * counter
                        strValue6.stagespeed = counter
                        strValue6 = gforcehandler
                        counter = gforcehandler
                        counter = counter.stagecounter
                        counter = counter + 1.0
                        strValue6.stagecounter = counter
                        strValue6 = gforcehandler
                        strValue6 = strValue6.stagecounter
                        counter = 250.0
                        if strValue6 > counter then
                            strValue6 = gforcehandler
                            strValue6.stage = 2
                            strValue6 = gforcehandler
                            strValue6.stagecounter = 0
                        end
                        strValue6 = gforcehandler
                        counter = gforcehandler
                        counter = counter.currentrotation
                        counter2 = gforcehandler
                        counter2 = counter2.stagespeed
                        counter = counter + counter2
                        strValue6.currentrotation = counter
                    else
                        strValue6 = gforcehandler
                        strValue6 = strValue6.stage
                        if 2 == strValue6 then
                            strValue6 = gforcehandler
                            counter = Config
                            counter = counter.AttractionsSettings
                            counter = counter.gforce
                            counter = counter.speedmodifier
                            counter = 0.5 * counter
                            strValue6.stagespeed = counter
                            strValue6 = gforcehandler
                            counter = gforcehandler
                            counter = counter.stagecounter
                            counter = counter + 1.0
                            strValue6.stagecounter = counter
                            strValue6 = gforcehandler
                            strValue6 = strValue6.stagecounter
                            counter = 250.0
                            if strValue6 > counter then
                                strValue6 = gforcehandler
                                strValue6.stage = 3
                                strValue6 = gforcehandler
                                strValue6.stagecounter = 0
                            end
                            strValue6 = gforcehandler
                            counter = gforcehandler
                            counter = counter.currentrotation
                            counter2 = gforcehandler
                            counter2 = counter2.stagespeed
                            counter = counter + counter2
                            strValue6.currentrotation = counter
                        else
                            strValue6 = gforcehandler
                            strValue6 = strValue6.stage
                            if 3 == strValue6 then
                                strValue6 = gforcehandler
                                counter = Config
                                counter = counter.AttractionsSettings
                                counter = counter.gforce
                                counter = counter.speedmodifier
                                counter = 0.75 * counter
                                strValue6.stagespeed = counter
                                strValue6 = gforcehandler
                                counter = gforcehandler
                                counter = counter.stagecounter
                                counter = counter + 1.0
                                strValue6.stagecounter = counter
                                strValue6 = gforcehandler
                                strValue6 = strValue6.stagecounter
                                counter = 250.0
                                if strValue6 > counter then
                                    strValue6 = gforcehandler
                                    strValue6.stage = 4
                                    strValue6 = gforcehandler
                                    strValue6.stagecounter = 0
                                end
                                strValue6 = gforcehandler
                                counter = gforcehandler
                                counter = counter.currentrotation
                                counter2 = gforcehandler
                                counter2 = counter2.stagespeed
                                counter = counter + counter2
                                strValue6.currentrotation = counter
                            else
                                strValue6 = gforcehandler
                                strValue6 = strValue6.stage
                                if 4 == strValue6 then
                                    strValue6 = gforcehandler
                                    counter = Config
                                    counter = counter.AttractionsSettings
                                    counter = counter.gforce
                                    counter = counter.speedmodifier
                                    counter = 1.0 * counter
                                    strValue6.stagespeed = counter
                                    strValue6 = gforcehandler
                                    counter = gforcehandler
                                    counter = counter.stagecounter
                                    counter = counter + 1.0
                                    strValue6.stagecounter = counter
                                    strValue6 = gforcehandler
                                    strValue6 = strValue6.stagecounter
                                    counter = 250.0
                                    if strValue6 > counter then
                                        strValue6 = gforcehandler
                                        strValue6.stage = 5
                                        strValue6 = gforcehandler
                                        strValue6.stagecounter = 0
                                    end
                                    strValue6 = gforcehandler
                                    counter = gforcehandler
                                    counter = counter.currentrotation
                                    counter2 = gforcehandler
                                    counter2 = counter2.stagespeed
                                    counter = counter + counter2
                                    strValue6.currentrotation = counter
                                else
                                    strValue6 = gforcehandler
                                    strValue6 = strValue6.stage
                                    if 5 == strValue6 then
                                        strValue6 = gforcehandler
                                        counter = Config
                                        counter = counter.AttractionsSettings
                                        counter = counter.gforce
                                        counter = counter.speedmodifier
                                        counter = 1.25 * counter
                                        strValue6.stagespeed = counter
                                        strValue6 = gforcehandler
                                        counter = gforcehandler
                                        counter = counter.stagecounter
                                        counter = counter + 1.0
                                        strValue6.stagecounter = counter
                                        strValue6 = gforcehandler
                                        strValue6 = strValue6.stagecounter
                                        counter = 250.0
                                        if strValue6 > counter then
                                            strValue6 = gforcehandler
                                            strValue6.stage = 6
                                            strValue6 = gforcehandler
                                            strValue6.stagecounter = 0
                                        end
                                        strValue6 = gforcehandler
                                        counter = gforcehandler
                                        counter = counter.currentrotation
                                        counter2 = gforcehandler
                                        counter2 = counter2.stagespeed
                                        counter = counter + counter2
                                        strValue6.currentrotation = counter
                                    else
                                        strValue6 = gforcehandler
                                        strValue6 = strValue6.stage
                                        if 6 == strValue6 then
                                            strValue6 = gforcehandler
                                            counter = Config
                                            counter = counter.AttractionsSettings
                                            counter = counter.gforce
                                            counter = counter.speedmodifier
                                            counter = 1.75 * counter
                                            strValue6.stagespeed = counter
                                            strValue6 = gforcehandler
                                            counter = gforcehandler
                                            counter = counter.currentrotation
                                            counter2 = gforcehandler
                                            counter2 = counter2.stagespeed
                                            counter = counter + counter2
                                            strValue6.currentrotation = counter
                                            strValue6 = gforcehandler
                                            strValue6 = strValue6.currentrotation
                                            counter = 359.9
                                            if strValue6 > counter then
                                                strValue6 = gforcehandler
                                                counter = gforcehandler
                                                counter = counter.stagecounter
                                                counter = counter + 1
                                                strValue6.stagecounter = counter
                                                strValue6 = gforcehandler
                                                strValue6 = strValue6.stagecounter
                                                counter = Config
                                                counter = counter.AttractionsSettings
                                                counter = counter.gforce
                                                counter = counter.maxrounds
                                                if strValue6 > counter then
                                                    strValue6 = gforcehandler
                                                    strValue6.stage = 7
                                                    strValue6 = gforcehandler
                                                    strValue6.stagecounter = 0
                                                end
                                            end
                                        else
                                            strValue6 = gforcehandler
                                            strValue6 = strValue6.stage
                                            if 7 == strValue6 then
                                                strValue6 = gforcehandler
                                                counter = Config
                                                counter = counter.AttractionsSettings
                                                counter = counter.gforce
                                                counter = counter.speedmodifier
                                                counter = 1.25 * counter
                                                strValue6.stagespeed = counter
                                                strValue6 = gforcehandler
                                                counter = gforcehandler
                                                counter = counter.stagecounter
                                                counter = counter + 1.0
                                                strValue6.stagecounter = counter
                                                strValue6 = gforcehandler
                                                strValue6 = strValue6.stagecounter
                                                if strValue6 > 100.0 then
                                                    strValue6 = gforcehandler
                                                    strValue6.stage = 8
                                                    strValue6 = gforcehandler
                                                    strValue6.stagecounter = 0
                                                end
                                                strValue6 = gforcehandler
                                                counter = gforcehandler
                                                counter = counter.currentrotation
                                                counter2 = gforcehandler
                                                counter2 = counter2.stagespeed
                                                counter = counter + counter2
                                                strValue6.currentrotation = counter
                                            else
                                                strValue6 = gforcehandler
                                                strValue6 = strValue6.stage
                                                if 8 == strValue6 then
                                                    strValue6 = gforcehandler
                                                    counter = Config
                                                    counter = counter.AttractionsSettings
                                                    counter = counter.gforce
                                                    counter = counter.speedmodifier
                                                    counter = 1.0 * counter
                                                    strValue6.stagespeed = counter
                                                    strValue6 = gforcehandler
                                                    counter = gforcehandler
                                                    counter = counter.stagecounter
                                                    counter = counter + 1.0
                                                    strValue6.stagecounter = counter
                                                    strValue6 = gforcehandler
                                                    strValue6 = strValue6.stagecounter
                                                    if strValue6 > 50.0 then
                                                        strValue6 = gforcehandler
                                                        strValue6.stage = 9
                                                        strValue6 = gforcehandler
                                                        strValue6.stagecounter = 0
                                                    end
                                                    strValue6 = gforcehandler
                                                    counter = gforcehandler
                                                    counter = counter.currentrotation
                                                    counter2 = gforcehandler
                                                    counter2 = counter2.stagespeed
                                                    counter = counter + counter2
                                                    strValue6.currentrotation = counter
                                                else
                                                    strValue6 = gforcehandler
                                                    strValue6 = strValue6.stage
                                                    if 9 == strValue6 then
                                                        strValue6 = gforcehandler
                                                        counter = Config
                                                        counter = counter.AttractionsSettings
                                                        counter = counter.gforce
                                                        counter = counter.speedmodifier
                                                        counter = 0.75 * counter
                                                        strValue6.stagespeed = counter
                                                        strValue6 = gforcehandler
                                                        counter = gforcehandler
                                                        counter = counter.stagecounter
                                                        counter = counter + 1.0
                                                        strValue6.stagecounter = counter
                                                        strValue6 = gforcehandler
                                                        strValue6 = strValue6.stagecounter
                                                        if strValue6 > 50.0 then
                                                            strValue6 = gforcehandler
                                                            strValue6.stage = 10
                                                            strValue6 = gforcehandler
                                                            strValue6.stagecounter = 0
                                                        end
                                                        strValue6 = gforcehandler
                                                        counter = gforcehandler
                                                        counter = counter.currentrotation
                                                        counter2 = gforcehandler
                                                        counter2 = counter2.stagespeed
                                                        counter = counter + counter2
                                                        strValue6.currentrotation = counter
                                                    else
                                                        strValue6 = gforcehandler
                                                        strValue6 = strValue6.stage
                                                        if 10 == strValue6 then
                                                            strValue6 = gforcehandler
                                                            counter = Config
                                                            counter = counter.AttractionsSettings
                                                            counter = counter.gforce
                                                            counter = counter.speedmodifier
                                                            counter = 0.5 * counter
                                                            strValue6.stagespeed = counter
                                                            strValue6 = gforcehandler
                                                            counter = gforcehandler
                                                            counter = counter.stagecounter
                                                            counter = counter + 1.0
                                                            strValue6.stagecounter = counter
                                                            strValue6 = gforcehandler
                                                            strValue6 = strValue6.stagecounter
                                                            if strValue6 > 50.0 then
                                                                strValue6 = gforcehandler
                                                                strValue6.stage = 11
                                                                strValue6 = gforcehandler
                                                                strValue6.stagecounter = 0
                                                            end
                                                            strValue6 = gforcehandler
                                                            counter = gforcehandler
                                                            counter = counter.currentrotation
                                                            counter2 = gforcehandler
                                                            counter2 = counter2.stagespeed
                                                            counter = counter + counter2
                                                            strValue6.currentrotation = counter
                                                        else
                                                            strValue6 = gforcehandler
                                                            strValue6 = strValue6.stage
                                                            if 11 == strValue6 then
                                                                strValue6 = gforcehandler
                                                                counter = Config
                                                                counter = counter.AttractionsSettings
                                                                counter = counter.gforce
                                                                counter = counter.speedmodifier
                                                                counter = 0.25 * counter
                                                                strValue6.stagespeed = counter
                                                                strValue6 = gforcehandler
                                                                counter = gforcehandler
                                                                counter = counter.stagecounter
                                                                counter = counter + 1.0
                                                                strValue6.stagecounter = counter
                                                                strValue6 = gforcehandler
                                                                strValue6 = strValue6.stagecounter
                                                                if strValue6 > 50.0 then
                                                                    strValue6 = gforcehandler
                                                                    strValue6.stage = 12
                                                                    strValue6 = gforcehandler
                                                                    strValue6.stagecounter = 0
                                                                end
                                                                strValue6 = gforcehandler
                                                                counter = gforcehandler
                                                                counter = counter.currentrotation
                                                                counter2 = gforcehandler
                                                                counter2 = counter2.stagespeed
                                                                counter = counter + counter2
                                                                strValue6.currentrotation = counter
                                                            else
                                                                strValue6 = gforcehandler
                                                                strValue6 = strValue6.stage
                                                                if 12 == strValue6 then
                                                                    strValue6 = gforcehandler
                                                                    counter = Config
                                                                    counter = counter.AttractionsSettings
                                                                    counter = counter.gforce
                                                                    counter = counter.speedmodifier
                                                                    counter = 0.25 * counter
                                                                    strValue6.stagespeed = counter
                                                                    strValue6 = gforcehandler
                                                                    strValue6 = strValue6.currentrotation
                                                                    counter = 180.0
                                                                    if not (strValue6 < counter) then
                                                                        strValue6 = gforcehandler
                                                                        strValue6 = strValue6.currentrotation
                                                                        counter = 180.25
                                                                        if not (strValue6 > counter) then
                                                                            goto lbl_686
                                                                        end
                                                                    end
                                                                    strValue6 = gforcehandler
                                                                    counter = gforcehandler
                                                                    counter = counter.currentrotation
                                                                    counter2 = gforcehandler
                                                                    counter2 = counter2.stagespeed
                                                                    counter = counter + counter2
                                                                    strValue6.currentrotation = counter
                                                                    goto lbl_905
                                                                    ::lbl_686::
                                                                    strValue6 = gforcehandler
                                                                    strValue6.currentrotation = 180.0
                                                                    strValue6 = gforcehandler
                                                                    strValue6.stage = 13
                                                                else
                                                                    strValue6 = gforcehandler
                                                                    strValue6 = strValue6.stage
                                                                    if 13 == strValue6 then
                                                                        strValue6 = gforcehandler
                                                                        strValue6.currentrotation = 180.0
                                                                        strValue6 = gforcehandler
                                                                        strValue6 = strValue6.seats
                                                                        strValue6 = strValue6[2]
                                                                        strValue6.cageclosed = true
                                                                        counter = pairs
                                                                        counter2 = playsersinthemepark
                                                                        counter, counter2, isDisabled3, strValue3 = counter(counter2)
                                                                        for value, isEnabled6 in counter, counter2, isDisabled3, strValue3 do
                                                                            strValue = TriggerClientEvent
                                                                            strValue4 = "rtx_themepark:GForce:SynchronizeCageClient"
                                                                            isEnabled2 = isEnabled6
                                                                            strValue5 = 2
                                                                            isEnabled5 = true
                                                                            strValue(strValue4, isEnabled2, strValue5, isEnabled5)
                                                                        end
                                                                        counter = Citizen
                                                                        counter = counter.Wait
                                                                        counter2 = 5000
                                                                        counter(counter2)
                                                                        counter = gforcehandler
                                                                        counter = counter.seats
                                                                        counter = counter[2]
                                                                        counter2 = ipairs
                                                                        isDisabled3 = counter.seats
                                                                        counter2, isDisabled3, strValue3, value = counter2(isDisabled3)
                                                                        for isEnabled6, strValue in counter2, isDisabled3, strValue3, value do
                                                                            strValue4 = strValue.taken
                                                                            if true == strValue4 then
                                                                                strValue.taken = false
                                                                                strValue4 = pairs
                                                                                isEnabled2 = playsersinthemepark
                                                                                strValue4, isEnabled2, strValue5, isEnabled5 = strValue4(isEnabled2)
                                                                                for isDisabled2, isDisabled in strValue4, isEnabled2, strValue5, isEnabled5 do
                                                                                    isEnabled3 = TriggerClientEvent
                                                                                    strValue2 = "rtx_themepark:GForce:SynchronizeSeat"
                                                                                    var23 = isDisabled
                                                                                    isEnabled4 = 2
                                                                                    var22 = isEnabled6
                                                                                    isEnabled = false
                                                                                    var24 = strValue.takenplayerid
                                                                                    var2 = strValue.seattype
                                                                                    isEnabled3(strValue2, var23, isEnabled4, var22, isEnabled, var24, var2)
                                                                                end
                                                                                strValue4 = TriggerClientEvent
                                                                                isEnabled2 = "rtx_themepark:GForce:SeatExit"
                                                                                strValue5 = strValue.takenplayerid
                                                                                isEnabled5 = true
                                                                                strValue4(isEnabled2, strValue5, isEnabled5)
                                                                                strValue4 = TriggerClientEvent
                                                                                isEnabled2 = "rtx_themepark:Global:AttractionUsing"
                                                                                strValue5 = strValue.takenplayerid
                                                                                isEnabled5 = false
                                                                                strValue4(isEnabled2, strValue5, isEnabled5)
                                                                                strValue4 = TriggerClientEvent
                                                                                isEnabled2 = "rtx_themepark:Global:TicketHandler"
                                                                                strValue5 = strValue.takenplayerid
                                                                                isEnabled5 = 1
                                                                                isDisabled2 = false
                                                                                strValue4(isEnabled2, strValue5, isEnabled5, isDisabled2)
                                                                                strValue.takenplayerid = nil
                                                                                strValue.seattype = 1
                                                                            end
                                                                        end
                                                                        counter2 = Citizen
                                                                        counter2 = counter2.Wait
                                                                        isDisabled3 = 5000
                                                                        counter2(isDisabled3)
                                                                        counter2 = gforcehandler
                                                                        counter2 = counter2.seats
                                                                        counter2 = counter2[2]
                                                                        counter2.cageclosed = false
                                                                        isDisabled3 = pairs
                                                                        strValue3 = playsersinthemepark
                                                                        isDisabled3, strValue3, value, isEnabled6 = isDisabled3(strValue3)
                                                                        for strValue, strValue4 in isDisabled3, strValue3, value, isEnabled6 do
                                                                            isEnabled2 = TriggerClientEvent
                                                                            strValue5 = "rtx_themepark:GForce:SynchronizeCageClient"
                                                                            isEnabled5 = strValue4
                                                                            isDisabled2 = 2
                                                                            isDisabled = false
                                                                            isEnabled2(strValue5, isEnabled5, isDisabled2, isDisabled)
                                                                        end
                                                                        isDisabled3 = Citizen
                                                                        isDisabled3 = isDisabled3.Wait
                                                                        strValue3 = 5000
                                                                        isDisabled3(strValue3)
                                                                        isDisabled3 = gforcehandler
                                                                        isDisabled3.stage = 14
                                                                    else
                                                                        strValue6 = gforcehandler
                                                                        strValue6 = strValue6.stage
                                                                        if 14 == strValue6 then
                                                                            strValue6 = gforcehandler
                                                                            counter = Config
                                                                            counter = counter.AttractionsSettings
                                                                            counter = counter.gforce
                                                                            counter = counter.speedmodifier
                                                                            counter = 0.25 * counter
                                                                            strValue6.stagespeed = counter
                                                                            strValue6 = gforcehandler
                                                                            strValue6 = strValue6.currentrotation
                                                                            counter = 360.0
                                                                            if strValue6 < counter then
                                                                                strValue6 = gforcehandler
                                                                                strValue6 = strValue6.currentrotation
                                                                                counter = 0.25
                                                                                if strValue6 > counter then
                                                                                    strValue6 = gforcehandler
                                                                                    counter = gforcehandler
                                                                                    counter = counter.currentrotation
                                                                                    counter2 = gforcehandler
                                                                                    counter2 = counter2.stagespeed
                                                                                    counter = counter + counter2
                                                                                    strValue6.currentrotation = counter
                                                                                end
                                                                            else
                                                                                strValue6 = gforcehandler
                                                                                strValue6.currentrotation = 360.0
                                                                                strValue6 = gforcehandler
                                                                                strValue6.stage = 15
                                                                            end
                                                                        else
                                                                            strValue6 = gforcehandler
                                                                            strValue6 = strValue6.stage
                                                                            if 15 == strValue6 then
                                                                                strValue6 = gforcehandler
                                                                                strValue6 = strValue6.seats
                                                                                strValue6 = strValue6[1]
                                                                                strValue6.cageclosed = true
                                                                                counter = pairs
                                                                                counter2 = playsersinthemepark
                                                                                counter, counter2, isDisabled3, strValue3 = counter(counter2)
                                                                                for value, isEnabled6 in counter, counter2, isDisabled3, strValue3 do
                                                                                    strValue = TriggerClientEvent
                                                                                    strValue4 = "rtx_themepark:GForce:SynchronizeCageClient"
                                                                                    isEnabled2 = isEnabled6
                                                                                    strValue5 = 1
                                                                                    isEnabled5 = true
                                                                                    strValue(strValue4, isEnabled2, strValue5, isEnabled5)
                                                                                end
                                                                                counter = Citizen
                                                                                counter = counter.Wait
                                                                                counter2 = 5000
                                                                                counter(counter2)
                                                                                counter = gforcehandler
                                                                                counter = counter.seats
                                                                                counter = counter[1]
                                                                                counter2 = ipairs
                                                                                isDisabled3 = counter.seats
                                                                                counter2, isDisabled3, strValue3, value = counter2(isDisabled3)
                                                                                for isEnabled6, strValue in counter2, isDisabled3, strValue3, value do
                                                                                    strValue4 = strValue.taken
                                                                                    if true == strValue4 then
                                                                                        strValue.taken = false
                                                                                        strValue4 = pairs
                                                                                        isEnabled2 = playsersinthemepark
                                                                                        strValue4, isEnabled2, strValue5, isEnabled5 = strValue4(isEnabled2)
                                                                                        for isDisabled2, isDisabled in strValue4, isEnabled2, strValue5, isEnabled5 do
                                                                                            isEnabled3 = TriggerClientEvent
                                                                                            strValue2 = "rtx_themepark:GForce:SynchronizeSeat"
                                                                                            var23 = isDisabled
                                                                                            isEnabled4 = 1
                                                                                            var22 = isEnabled6
                                                                                            isEnabled = false
                                                                                            var24 = strValue.takenplayerid
                                                                                            var2 = strValue.seattype
                                                                                            isEnabled3(strValue2, var23, isEnabled4, var22, isEnabled, var24, var2)
                                                                                        end
                                                                                        strValue4 = TriggerClientEvent
                                                                                        isEnabled2 = "rtx_themepark:GForce:SeatExit"
                                                                                        strValue5 = strValue.takenplayerid
                                                                                        isEnabled5 = true
                                                                                        strValue4(isEnabled2, strValue5, isEnabled5)
                                                                                        strValue4 = TriggerClientEvent
                                                                                        isEnabled2 = "rtx_themepark:Global:AttractionUsing"
                                                                                        strValue5 = strValue.takenplayerid
                                                                                        isEnabled5 = false
                                                                                        strValue4(isEnabled2, strValue5, isEnabled5)
                                                                                        strValue4 = TriggerClientEvent
                                                                                        isEnabled2 = "rtx_themepark:Global:TicketHandler"
                                                                                        strValue5 = strValue.takenplayerid
                                                                                        isEnabled5 = 1
                                                                                        isDisabled2 = false
                                                                                        strValue4(isEnabled2, strValue5, isEnabled5, isDisabled2)
                                                                                        strValue.takenplayerid = nil
                                                                                        strValue.seattype = 1
                                                                                    end
                                                                                end
                                                                                counter2 = gforcehandler
                                                                                counter2.stageinprogress = false
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
            end
            ::lbl_905::
            strValue6 = gforcehandler
            strValue6 = strValue6.stage
            if 14 == strValue6 then
            else
                strValue6 = gforcehandler
                strValue6 = strValue6.currentrotation
                counter = 360.0
                if strValue6 > counter then
                    strValue6 = gforcehandler
                    strValue6 = strValue6.currentrotation
                    strValue6 = strValue6 - 360.0
                    counter = gforcehandler
                    counter2 = 0.0 + strValue6
                    counter.currentrotation = counter2
                end
            end
            strValue6 = GlobalState
            counter = gforcehandler
            counter = counter.stage
            strValue6["attraction1 - phase"] = counter
            strValue6 = GlobalState
            counter = gforcehandler
            counter = counter.currentrotation
            strValue6["attraction1 - ridedata1"] = counter
            strValue6 = GlobalState
            counter = gforcehandler
            counter = counter.stagespeed
            strValue6["attraction1 - speeddata1"] = counter
            strValue6 = GlobalState
            counter = GlobalState
            counter = counter["attraction1 - synchdata"]
            counter = counter + 1
            strValue6["attraction1 - synchdata"] = counter
        end
        strValue6 = TriggerClientEvent
        counter = "rtx_themepark:Global:MusicStopAttraction"
        counter2 = -1
        isDisabled3 = "gforce"
        strValue6(counter, counter2, isDisabled3)
        strValue6 = gforcehandler
        strValue6.currentrotation = 0.0
        strValue6 = GlobalState
        strValue6["attraction1 - phase"] = 0
        strValue6 = gforcehandler
        strValue6.seatdown = 1
        strValue6 = TriggerClientEvent
        counter = "rtx_themepark:GForce:SeatDown"
        counter2 = -1
        isDisabled3 = 1
        strValue6(counter, counter2, isDisabled3)
        strValue6 = gforcehandler
        strValue6.started = false
        strValue6 = TriggerClientEvent
        counter = "rtx_themepark:GForce:SynchronizeStarted"
        counter2 = -1
        isDisabled3 = false
        strValue6(counter, counter2, isDisabled3)
    end
end
StartGForce = dataTable
dataTable = RegisterServerEvent
coords = "rtx_themepark:GForce:SeatUse"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:GForce:SeatUse"

function dataTable2(A0_2, A1_2)
    local strValue6, counter, counter2, isDisabled3, strValue3, value, isEnabled6, strValue, strValue4, isEnabled2, strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2, var23
    strValue6 = source
    counter = themeparkattractionsopenstatus
    counter = counter[1]
    if true == counter then
        counter = themeparkdisabled
        if false == counter then
            if nil ~= A0_2 and nil ~= A1_2 then
                counter = gforcehandler
                counter = counter.started
                if false == counter then
                    counter = gforcehandler
                    counter = counter.changingsides
                    if false == counter then
                        counter = gforcehandler
                        counter = counter.seatdown
                        if counter == A0_2 then
                            counter = gforcehandler
                            counter = counter.seats
                            counter = counter[A0_2]
                            counter2 = counter.seats
                            counter2 = counter2[A1_2]
                            isDisabled3 = counter2.taken
                            if false == isDisabled3 then
                                counter2.taken = true
                                counter2.takenplayerid = strValue6
                                isDisabled3 = pairs
                                strValue3 = playsersinthemepark
                                isDisabled3, strValue3, value, isEnabled6 = isDisabled3(strValue3)
                                for strValue, strValue4 in isDisabled3, strValue3, value, isEnabled6 do
                                    isEnabled2 = TriggerClientEvent
                                    strValue5 = "rtx_themepark:GForce:SynchronizeSeat"
                                    isEnabled5 = strValue4
                                    isDisabled2 = A0_2
                                    isDisabled = A1_2
                                    isEnabled3 = true
                                    strValue2 = counter2.takenplayerid
                                    var23 = counter2.seattype
                                    isEnabled2(strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2, var23)
                                end
                                isDisabled3 = TriggerClientEvent
                                strValue3 = "rtx_themepark:GForce:SeatData"
                                value = strValue6
                                isEnabled6 = A0_2
                                strValue = A1_2
                                isDisabled3(strValue3, value, isEnabled6, strValue)
                                isDisabled3 = TriggerClientEvent
                                strValue3 = "rtx_themepark:Global:AttractionUsing"
                                value = strValue6
                                isEnabled6 = true
                                isDisabled3(strValue3, value, isEnabled6)
                                isDisabled3 = Config
                                isDisabled3 = isDisabled3.ThemeParkControlAttractions
                                if false == isDisabled3 then
                                    isDisabled3 = gforcehandler
                                    isDisabled3 = isDisabled3.started
                                    if false == isDisabled3 then
                                        isDisabled3 = gforcehandler
                                        isDisabled3 = isDisabled3.seatdown
                                        if 1 == isDisabled3 then
                                            isDisabled3 = Wait
                                            strValue3 = Config
                                            strValue3 = strValue3.AttractionsSettings
                                            strValue3 = strValue3.gforce
                                            strValue3 = strValue3.waitforplayers
                                            isDisabled3(strValue3)
                                            isDisabled3 = gforcehandler
                                            isDisabled3 = isDisabled3.started
                                            if false == isDisabled3 then
                                                isDisabled3 = gforcehandler
                                                isDisabled3.started = true
                                                isDisabled3 = TriggerClientEvent
                                                strValue3 = "rtx_themepark:GForce:SynchronizeStarted"
                                                value = -1
                                                isEnabled6 = true
                                                isDisabled3(strValue3, value, isEnabled6)
                                                isDisabled3 = StartGForce
                                                isDisabled3()
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
    else
        counter = TriggerClientEvent
        counter2 = "rtx_themepark:Notify"
        isDisabled3 = strValue6
        strValue3 = Language
        value = Config
        value = value.Language
        strValue3 = strValue3[value]
        strValue3 = strValue3.attractionclosed
        counter(counter2, isDisabled3, strValue3)
    end
end
dataTable(coords, dataTable2)
dataTable = RegisterServerEvent
coords = "rtx_themepark:GForce:SeatAnimChange"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:GForce:SeatAnimChange"

function dataTable2(A0_2, A1_2)
    local strValue6, counter, counter2, isDisabled3, strValue3, value, isEnabled6, strValue, strValue4, isEnabled2, strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2, var23
    strValue6 = source
    if nil ~= A0_2 and nil ~= A1_2 then
        counter = gforcehandler
        counter = counter.seats
        counter = counter[A0_2]
        counter2 = counter.seats
        counter2 = counter2[A1_2]
        isDisabled3 = counter2.taken
        if true == isDisabled3 then
            isDisabled3 = counter2.takenplayerid
            if isDisabled3 == strValue6 then
                isDisabled3 = counter2.seattype
                if 1 == isDisabled3 then
                    counter2.seattype = 2
                else
                    counter2.seattype = 1
                end
                isDisabled3 = pairs
                strValue3 = playsersinthemepark
                isDisabled3, strValue3, value, isEnabled6 = isDisabled3(strValue3)
                for strValue, strValue4 in isDisabled3, strValue3, value, isEnabled6 do
                    isEnabled2 = TriggerClientEvent
                    strValue5 = "rtx_themepark:GForce:SynchronizeSeat"
                    isEnabled5 = strValue4
                    isDisabled2 = A0_2
                    isDisabled = A1_2
                    isEnabled3 = true
                    strValue2 = counter2.takenplayerid
                    var23 = counter2.seattype
                    isEnabled2(strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2, var23)
                end
            end
        end
    end
end
dataTable(coords, dataTable2)
dataTable = RegisterServerEvent
coords = "rtx_themepark:GForce:ExitAttraction"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:GForce:ExitAttraction"

function dataTable2(A0_2, A1_2)
    local strValue6, counter, counter2, isDisabled3, strValue3, value, isEnabled6, strValue, strValue4, isEnabled2, strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2
    strValue6 = source
    if nil ~= A0_2 and nil ~= A1_2 then
        counter = gforcehandler
        counter = counter.seats
        counter = counter[A0_2]
        counter2 = counter.seats
        counter2 = counter2[A1_2]
        isDisabled3 = counter2.taken
        if true == isDisabled3 then
            isDisabled3 = counter2.takenplayerid
            if isDisabled3 == strValue6 then
                isDisabled3 = Config
                isDisabled3 = isDisabled3.ThemeParkDisableExit
                if false ~= isDisabled3 then
                    isDisabled3 = gforcehandler
                    isDisabled3 = isDisabled3.started
                    if false ~= isDisabled3 then
                        goto lbl_54
                    end
                end
                isDisabled3 = pairs
                strValue3 = playsersinthemepark
                isDisabled3, strValue3, value, isEnabled6 = isDisabled3(strValue3)
                for strValue, strValue4 in isDisabled3, strValue3, value, isEnabled6 do
                    isEnabled2 = TriggerClientEvent
                    strValue5 = "rtx_themepark:GForce:SynchronizeSeat"
                    isEnabled5 = strValue4
                    isDisabled2 = A0_2
                    isDisabled = A1_2
                    isEnabled3 = false
                    strValue2 = counter2.takenplayerid
                    isEnabled2(strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2)
                end
                isDisabled3 = TriggerClientEvent
                strValue3 = "rtx_themepark:GForce:SeatExit"
                value = counter2.takenplayerid
                isEnabled6 = false
                isDisabled3(strValue3, value, isEnabled6)
                isDisabled3 = TriggerClientEvent
                strValue3 = "rtx_themepark:Global:AttractionUsing"
                value = counter2.takenplayerid
                isEnabled6 = false
                isDisabled3(strValue3, value, isEnabled6)
                counter2.taken = false
                counter2.takenplayerid = nil
                counter2.seattype = 1
                goto lbl_63
                ::lbl_54::
                isDisabled3 = TriggerClientEvent
                strValue3 = "rtx_themepark:Notify"
                value = strValue6
                isEnabled6 = Language
                strValue = Config
                strValue = strValue.Language
                isEnabled6 = isEnabled6[strValue]
                isEnabled6 = isEnabled6.inprogress
                isDisabled3(strValue3, value, isEnabled6)
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
    dataTable = dataTable.gforce
    if dataTable then
        dataTable = RegisterServerEvent
        coords = "rtx_themepark:GForce:ThrowAttraction"
        dataTable(coords)
        dataTable = AddEventHandler
        coords = "rtx_themepark:GForce:ThrowAttraction"

        function dataTable2(A0_2, A1_2)
            local strValue6, counter, counter2, isDisabled3, strValue3, value, isEnabled6, strValue, strValue4, isEnabled2, strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2
            strValue6 = source
            if nil ~= A0_2 and nil ~= A1_2 then
                counter = gforcehandler
                counter = counter.seats
                counter = counter[A0_2]
                counter2 = counter.seats
                counter2 = counter2[A1_2]
                isDisabled3 = counter2.taken
                if true == isDisabled3 then
                    isDisabled3 = counter2.takenplayerid
                    if isDisabled3 == strValue6 then
                        isDisabled3 = pairs
                        strValue3 = playsersinthemepark
                        isDisabled3, strValue3, value, isEnabled6 = isDisabled3(strValue3)
                        for strValue, strValue4 in isDisabled3, strValue3, value, isEnabled6 do
                            isEnabled2 = TriggerClientEvent
                            strValue5 = "rtx_themepark:GForce:SynchronizeSeat"
                            isEnabled5 = strValue4
                            isDisabled2 = A0_2
                            isDisabled = A1_2
                            isEnabled3 = false
                            strValue2 = counter2.takenplayerid
                            isEnabled2(strValue5, isEnabled5, isDisabled2, isDisabled, isEnabled3, strValue2)
                        end
                        isDisabled3 = TriggerClientEvent
                        strValue3 = "rtx_themepark:GForce:SeatThrowClient"
                        value = counter2.takenplayerid
                        isDisabled3(strValue3, value)
                        isDisabled3 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Global:AttractionUsing"
                        value = counter2.takenplayerid
                        isEnabled6 = false
                        isDisabled3(strValue3, value, isEnabled6)
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