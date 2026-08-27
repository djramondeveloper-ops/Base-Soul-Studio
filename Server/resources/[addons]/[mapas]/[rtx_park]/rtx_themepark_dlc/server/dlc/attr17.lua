
local dataTable, dataTable2, dataTable3, dataTable4, func, counter, counter3, counter2
dataTable = {}
dataTable.started = false
dataTable.startid = 0
dataTable.getnew = false
dataTable2 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable3.seatcategory = "one"
dataTable4 = {}
func = vec3
counter = -0.28
counter3 = -0.213
counter2 = 0.904
func = func(counter, counter3, counter2)
dataTable4.coords = func
func = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
func = func(counter, counter3, counter2)
dataTable4.rotation = func
dataTable3.offsets = dataTable4
dataTable2[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable3.seatcategory = "two"
dataTable4 = {}
func = vec3
counter = 0.28
counter3 = -0.213
counter2 = 0.904
func = func(counter, counter3, counter2)
dataTable4.coords = func
func = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
func = func(counter, counter3, counter2)
dataTable4.rotation = func
dataTable3.offsets = dataTable4
dataTable2[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable3.seatcategory = "one"
dataTable4 = {}
func = vec3
counter = -0.28
counter3 = -1.228
counter2 = 0.904
func = func(counter, counter3, counter2)
dataTable4.coords = func
func = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
func = func(counter, counter3, counter2)
dataTable4.rotation = func
dataTable3.offsets = dataTable4
dataTable2[3] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable3.seatcategory = "two"
dataTable4 = {}
func = vec3
counter = 0.28
counter3 = -1.228
counter2 = 0.904
func = func(counter, counter3, counter2)
dataTable4.coords = func
func = vec3
counter = 0.0
counter3 = 0.0
counter2 = 0.0
func = func(counter, counter3, counter2)
dataTable4.rotation = func
dataTable3.offsets = dataTable4
dataTable2[4] = dataTable3
dataTable.seats = dataTable2
rollercoasterhandler2 = dataTable
dataTable = GlobalState
dataTable["attraction17 - phase"] = 0
dataTable = GlobalState
dataTable["attraction17 - ridedata1"] = 1
dataTable = GlobalState
dataTable["attraction17 - ridedata2"] = 8
dataTable = GlobalState
dataTable["attraction17 - synchdata"] = 1

function dataTable()
    local tableData2, strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6
    tableData2 = rollercoasterhandler2
    tableData2 = tableData2.started
    if true == tableData2 then
        tableData2 = Citizen
        tableData2 = tableData2.Wait
        strValue3 = 1000
        tableData2(strValue3)
        tableData2 = TriggerClientEvent
        strValue3 = "rtx_themepark:Global:MusicStartAttraction"
        tableData = -1
        isEnabled = "rollercoaster2"
        strValue2 = math
        strValue2 = strValue2.random
        isDisabled = 1
        isEnabled2 = Config
        isEnabled2 = isEnabled2.AttractionsMusic
        isEnabled2 = isEnabled2.rollercoaster2
        isEnabled2 = isEnabled2.playlist
        isEnabled2 = #isEnabled2
        strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6 = strValue2(isDisabled, isEnabled2)
        tableData2(strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6)
        tableData2 = GlobalState
        tableData2["attraction17 - phase"] = 1
        tableData2 = GlobalState
        tableData2["attraction17 - ridedata1"] = 1
        tableData2 = GlobalState
        tableData2["attraction17 - ridedata2"] = 8
        tableData2 = GlobalState
        tableData2["attraction17 - synchdata"] = 1
        tableData2 = rollercoasterhandler2
        tableData2.startid = 0
        tableData2 = ipairs
        strValue3 = rollercoasterhandler2
        strValue3 = strValue3.seats
        tableData2, strValue3, tableData, isEnabled = tableData2(strValue3)
        for strValue2, isDisabled in tableData2, strValue3, tableData, isEnabled do
            isEnabled2 = isDisabled.taken
            if true == isEnabled2 then
                isEnabled2 = TriggerClientEvent
                strValue4 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
                value = -1
                strValue = strValue2
                isEnabled4 = true
                isEnabled3 = isDisabled.takenplayerid
                isEnabled2(strValue4, value, strValue, isEnabled4, isEnabled3)
            end
        end
        tableData2 = 1
        strValue3 = Config
        strValue3 = strValue3.AttractionsSettings
        strValue3 = strValue3.rollercoaster2
        strValue3 = strValue3.speedmodifier
        strValue3 = 8 * strValue3
        tableData = GlobalState
        tableData["attraction17 - ridedata1"] = tableData2
        while true do
            tableData = 8576
            if not (tableData2 < tableData) then
                break
            end
            tableData = Citizen
            tableData = tableData.Wait
            isEnabled = 20
            tableData(isEnabled)
            tableData = Config
            tableData = tableData.AttractionsSettings
            tableData = tableData.rollercoaster2
            tableData = tableData.speedmodifier
            tableData = 8 * tableData
            tableData2 = strValue3
            strValue3 = strValue3 + tableData
            isEnabled = GlobalState
            isEnabled["attraction17 - ridedata1"] = tableData2
            isEnabled = GlobalState
            isEnabled["attraction17 - ridedata2"] = strValue3
            isEnabled = GlobalState
            strValue2 = GlobalState
            strValue2 = strValue2["attraction17 - synchdata"]
            strValue2 = strValue2 + 1
            isEnabled["attraction17 - synchdata"] = strValue2
        end
        tableData = Citizen
        tableData = tableData.Wait
        isEnabled = 2000
        tableData(isEnabled)
        tableData = TriggerClientEvent
        isEnabled = "rtx_themepark:Rollercoaster2:AttractionEnded"
        strValue2 = -1
        tableData(isEnabled, strValue2)
        tableData = ipairs
        isEnabled = rollercoasterhandler2
        isEnabled = isEnabled.seats
        tableData, isEnabled, strValue2, isDisabled = tableData(isEnabled)
        for isEnabled2, strValue4 in tableData, isEnabled, strValue2, isDisabled do
            value = strValue4.taken
            if true == value then
                strValue4.taken = false
                value = TriggerClientEvent
                strValue = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
                isEnabled4 = -1
                isEnabled3 = isEnabled2
                isEnabled5 = false
                isEnabled6 = strValue4.takenplayerid
                value(strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6)
                value = TriggerClientEvent
                strValue = "rtx_themepark:Rollercoaster2:SeatExit"
                isEnabled4 = strValue4.takenplayerid
                isEnabled3 = true
                isEnabled5 = true
                value(strValue, isEnabled4, isEnabled3, isEnabled5)
                value = TriggerClientEvent
                strValue = "rtx_themepark:Global:AttractionUsing"
                isEnabled4 = strValue4.takenplayerid
                isEnabled3 = false
                value(strValue, isEnabled4, isEnabled3)
                value = TriggerClientEvent
                strValue = "rtx_themepark:Global:TicketHandler"
                isEnabled4 = strValue4.takenplayerid
                isEnabled3 = 17
                isEnabled5 = false
                value(strValue, isEnabled4, isEnabled3, isEnabled5)
                strValue4.takenplayerid = nil
                strValue4.seattype = 1
            end
        end
        tableData = TriggerClientEvent
        isEnabled = "rtx_themepark:Global:MusicStopAttraction"
        strValue2 = -1
        isDisabled = "rollercoaster2"
        tableData(isEnabled, strValue2, isDisabled)
        tableData = Citizen
        tableData = tableData.Wait
        isEnabled = 2500
        tableData(isEnabled)
        tableData = rollercoasterhandler2
        tableData.started = false
        tableData = GlobalState
        tableData["attraction17 - phase"] = 0
        tableData = GlobalState
        tableData["attraction17 - ridedata1"] = 1
        tableData = GlobalState
        tableData["attraction17 - ridedata2"] = 8
        tableData = TriggerClientEvent
        isEnabled = "rtx_themepark:Rollercoaster2:SynchronizeStarted"
        strValue2 = -1
        isDisabled = false
        tableData(isEnabled, strValue2, isDisabled)
    end
end
StartRollercoaster2 = dataTable
dataTable = RegisterServerEvent
dataTable2 = "rtx_themepark:Rollercoaster2:SeatUse"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:Rollercoaster2:SeatUse"

function dataTable3(A0_2)
    local strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6, var22, var2
    strValue3 = source
    tableData = themeparkattractionsopenstatus
    tableData = tableData[18]
    if true == tableData then
        tableData = themeparkdisabled
        if false == tableData then
            if nil ~= A0_2 then
                tableData = rollercoasterhandler2
                tableData = tableData.started
                if false == tableData then
                    tableData = rollercoasterhandler2
                    tableData = tableData.seats
                    tableData = tableData[A0_2]
                    isEnabled = tableData.taken
                    if false == isEnabled then
                        tableData.taken = true
                        tableData.takenplayerid = strValue3
                        isEnabled = pairs
                        strValue2 = playsersinthemepark
                        isEnabled, strValue2, isDisabled, isEnabled2 = isEnabled(strValue2)
                        for strValue4, value in isEnabled, strValue2, isDisabled, isEnabled2 do
                            strValue = TriggerClientEvent
                            isEnabled4 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
                            isEnabled3 = value
                            isEnabled5 = A0_2
                            isEnabled6 = true
                            var22 = tableData.takenplayerid
                            var2 = tableData.seattype
                            strValue(isEnabled4, isEnabled3, isEnabled5, isEnabled6, var22, var2)
                        end
                        isEnabled = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:AttractionUsing"
                        isDisabled = strValue3
                        isEnabled2 = true
                        isEnabled(strValue2, isDisabled, isEnabled2)
                        isEnabled = TriggerClientEvent
                        strValue2 = "rtx_themepark:Rollercoaster2:SeatData"
                        isDisabled = strValue3
                        isEnabled2 = A0_2
                        isEnabled(strValue2, isDisabled, isEnabled2)
                        isEnabled = Config
                        isEnabled = isEnabled.ThemeParkControlAttractions
                        if false == isEnabled then
                            isEnabled = rollercoasterhandler2
                            isEnabled = isEnabled.started
                            if false == isEnabled then
                                isEnabled = Wait
                                strValue2 = Config
                                strValue2 = strValue2.AttractionsSettings
                                strValue2 = strValue2.rollercoaster2
                                strValue2 = strValue2.waitforplayers
                                isEnabled(strValue2)
                                isEnabled = rollercoasterhandler2
                                isEnabled = isEnabled.started
                                if false == isEnabled then
                                    isEnabled = rollercoasterhandler2
                                    isEnabled.started = true
                                    isEnabled = TriggerClientEvent
                                    strValue2 = "rtx_themepark:Rollercoaster2:SynchronizeStarted"
                                    isDisabled = -1
                                    isEnabled2 = true
                                    isEnabled(strValue2, isDisabled, isEnabled2)
                                    isEnabled = StartRollercoaster2
                                    isEnabled()
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        tableData = TriggerClientEvent
        isEnabled = "rtx_themepark:Notify"
        strValue2 = strValue3
        isDisabled = Language
        isEnabled2 = Config
        isEnabled2 = isEnabled2.Language
        isDisabled = isDisabled[isEnabled2]
        isDisabled = isDisabled.attractionclosed
        tableData(isEnabled, strValue2, isDisabled)
    end
end
dataTable(dataTable2, dataTable3)
dataTable = RegisterServerEvent
dataTable2 = "rtx_themepark:Rollercoaster2:SeatAnimChange"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:Rollercoaster2:SeatAnimChange"

function dataTable3(A0_2)
    local strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6, var22, var2
    strValue3 = source
    if nil ~= A0_2 then
        tableData = rollercoasterhandler2
        tableData = tableData.seats
        tableData = tableData[A0_2]
        isEnabled = tableData.taken
        if true == isEnabled then
            isEnabled = tableData.takenplayerid
            if isEnabled == strValue3 then
                isEnabled = tableData.seattype
                if 1 == isEnabled then
                    tableData.seattype = 2
                else
                    tableData.seattype = 1
                end
                isEnabled = pairs
                strValue2 = playsersinthemepark
                isEnabled, strValue2, isDisabled, isEnabled2 = isEnabled(strValue2)
                for strValue4, value in isEnabled, strValue2, isDisabled, isEnabled2 do
                    strValue = TriggerClientEvent
                    isEnabled4 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
                    isEnabled3 = value
                    isEnabled5 = A0_2
                    isEnabled6 = true
                    var22 = tableData.takenplayerid
                    var2 = tableData.seattype
                    strValue(isEnabled4, isEnabled3, isEnabled5, isEnabled6, var22, var2)
                end
            end
        end
    end
end
dataTable(dataTable2, dataTable3)
dataTable = RegisterServerEvent
dataTable2 = "rtx_themepark:Rollercoaster2:ExitAttraction"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:Rollercoaster2:ExitAttraction"

function dataTable3(A0_2)
    local strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6, var22
    strValue3 = source
    if nil ~= A0_2 then
        tableData = rollercoasterhandler2
        tableData = tableData.seats
        tableData = tableData[A0_2]
        isEnabled = tableData.taken
        if true == isEnabled then
            isEnabled = tableData.takenplayerid
            if isEnabled == strValue3 then
                isEnabled = Config
                isEnabled = isEnabled.ThemeParkDisableExit
                if false ~= isEnabled then
                    isEnabled = rollercoasterhandler2
                    isEnabled = isEnabled.started
                    if false ~= isEnabled then
                        goto lbl_48
                    end
                end
                isEnabled = pairs
                strValue2 = playsersinthemepark
                isEnabled, strValue2, isDisabled, isEnabled2 = isEnabled(strValue2)
                for strValue4, value in isEnabled, strValue2, isDisabled, isEnabled2 do
                    strValue = TriggerClientEvent
                    isEnabled4 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
                    isEnabled3 = value
                    isEnabled5 = A0_2
                    isEnabled6 = false
                    var22 = tableData.takenplayerid
                    strValue(isEnabled4, isEnabled3, isEnabled5, isEnabled6, var22)
                end
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:Rollercoaster2:SeatExit"
                isDisabled = tableData.takenplayerid
                isEnabled2 = false
                isEnabled(strValue2, isDisabled, isEnabled2)
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:Global:AttractionUsing"
                isDisabled = tableData.takenplayerid
                isEnabled2 = false
                isEnabled(strValue2, isDisabled, isEnabled2)
                tableData.taken = false
                tableData.takenplayerid = nil
                goto lbl_57
                ::lbl_48::
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:Notify"
                isDisabled = strValue3
                isEnabled2 = Language
                strValue4 = Config
                strValue4 = strValue4.Language
                isEnabled2 = isEnabled2[strValue4]
                isEnabled2 = isEnabled2.inprogress
                isEnabled(strValue2, isDisabled, isEnabled2)
            end
        end
    end
    ::lbl_57::
end
dataTable(dataTable2, dataTable3)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:Rollercoaster2:Start"

function dataTable3()
    local tableData2, strValue3, tableData, isEnabled
    tableData2 = rollercoasterhandler2
    tableData2 = tableData2.started
    if false == tableData2 then
        tableData2 = rollercoasterhandler2
        tableData2.started = true
        tableData2 = TriggerClientEvent
        strValue3 = "rtx_themepark:Rollercoaster2:SynchronizeStarted"
        tableData = -1
        isEnabled = true
        tableData2(strValue3, tableData, isEnabled)
        tableData2 = StartRollercoaster2
        tableData2()
    end
end
dataTable(dataTable2, dataTable3)