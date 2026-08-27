
local dataTable, dataTable2, dataTable3, dataTable4, func, counter, counter3, counter2
dataTable = {}
dataTable.started = false
dataTable.startid = 0
dataTable.getnew = false
dataTable2 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4 = {}
func = vec3
counter = 0.267
counter3 = -0.385
counter2 = 0.393
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
dataTable4 = {}
func = vec3
counter = 0.253
counter3 = -0.383
counter2 = 0.393
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
dataTable.seats = dataTable2
hauntedhousehandler = dataTable
dataTable = GlobalState
dataTable["attraction16 - phase"] = 0
dataTable = GlobalState
dataTable["attraction16 - ridedata1"] = 1
dataTable = GlobalState
dataTable["attraction16 - ridedata2"] = 8
dataTable = GlobalState
dataTable["attraction16 - synchdata"] = 1

function dataTable()
    local tableData2, strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6
    tableData2 = hauntedhousehandler
    tableData2 = tableData2.started
    if true == tableData2 then
        tableData2 = ipairs
        strValue3 = hauntedhousehandler
        strValue3 = strValue3.seats
        tableData2, strValue3, tableData, isEnabled = tableData2(strValue3)
        for strValue2, isDisabled in tableData2, strValue3, tableData, isEnabled do
            isEnabled2 = isDisabled.taken
            if true == isEnabled2 then
                isEnabled2 = TriggerClientEvent
                strValue4 = "rtx_themepark:HauntedHouse:SynchronizeSeat"
                value = -1
                strValue = strValue2
                isEnabled4 = true
                isEnabled3 = isDisabled.takenplayerid
                isEnabled2(strValue4, value, strValue, isEnabled4, isEnabled3)
            end
        end
        tableData2 = Citizen
        tableData2 = tableData2.Wait
        strValue3 = 1000
        tableData2(strValue3)
        tableData2 = GlobalState
        tableData2["attraction16 - phase"] = 1
        tableData2 = GlobalState
        tableData2["attraction16 - ridedata1"] = 1
        tableData2 = GlobalState
        tableData2["attraction16 - ridedata2"] = 8
        tableData2 = GlobalState
        tableData2["attraction16 - synchdata"] = 1
        tableData2 = hauntedhousehandler
        tableData2.startid = 0
        tableData2 = 1
        strValue3 = Config
        strValue3 = strValue3.AttractionsSettings
        strValue3 = strValue3.hauntedhouse
        strValue3 = strValue3.speedmodifier
        strValue3 = 8 * strValue3
        tableData = GlobalState
        tableData["attraction16 - ridedata1"] = tableData2
        while true do
            tableData = 40000
            if not (tableData2 < tableData) then
                break
            end
            tableData = Citizen
            tableData = tableData.Wait
            isEnabled = 20
            tableData(isEnabled)
            tableData = Config
            tableData = tableData.AttractionsSettings
            tableData = tableData.hauntedhouse
            tableData = tableData.speedmodifier
            tableData = 8 * tableData
            tableData2 = strValue3
            strValue3 = strValue3 + tableData
            isEnabled = GlobalState
            isEnabled["attraction16 - ridedata1"] = tableData2
            isEnabled = GlobalState
            isEnabled["attraction16 - ridedata2"] = strValue3
            isEnabled = GlobalState
            strValue2 = GlobalState
            strValue2 = strValue2["attraction16 - synchdata"]
            strValue2 = strValue2 + 1
            isEnabled["attraction16 - synchdata"] = strValue2
            if 2288 == tableData2 then
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 1
                isEnabled(strValue2, isDisabled, isEnabled2)
            elseif 3896 == tableData2 then
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 2
                isEnabled(strValue2, isDisabled, isEnabled2)
            elseif 7960 == tableData2 then
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 3
                isEnabled(strValue2, isDisabled, isEnabled2)
            elseif 13832 == tableData2 then
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 4
                isEnabled(strValue2, isDisabled, isEnabled2)
            elseif 18984 == tableData2 then
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 5
                isEnabled(strValue2, isDisabled, isEnabled2)
            elseif 29208 == tableData2 then
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 6
                isEnabled(strValue2, isDisabled, isEnabled2)
            elseif 34536 == tableData2 then
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 7
                isEnabled(strValue2, isDisabled, isEnabled2)
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:OpenDoor"
                isDisabled = -1
                isEnabled2 = 8
                isEnabled(strValue2, isDisabled, isEnabled2)
            end
            if 33080 == tableData2 then
                isEnabled = ipairs
                strValue2 = hauntedhousehandler
                strValue2 = strValue2.seats
                isEnabled, strValue2, isDisabled, isEnabled2 = isEnabled(strValue2)
                for strValue4, value in isEnabled, strValue2, isDisabled, isEnabled2 do
                    strValue = value.taken
                    if true == strValue then
                        strValue = TriggerClientEvent
                        isEnabled4 = "rtx_themepark:HauntedHouse:ValakJumpScare"
                        isEnabled3 = value.takenplayerid
                        strValue(isEnabled4, isEnabled3)
                    end
                end
            elseif 27496 == tableData2 then
                isEnabled = ipairs
                strValue2 = hauntedhousehandler
                strValue2 = strValue2.seats
                isEnabled, strValue2, isDisabled, isEnabled2 = isEnabled(strValue2)
                for strValue4, value in isEnabled, strValue2, isDisabled, isEnabled2 do
                    strValue = value.taken
                    if true == strValue then
                        strValue = TriggerClientEvent
                        isEnabled4 = "rtx_themepark:HauntedHouse:AnabelleHide"
                        isEnabled3 = value.takenplayerid
                        strValue(isEnabled4, isEnabled3)
                    end
                end
            elseif 28368 == tableData2 then
                isEnabled = ipairs
                strValue2 = hauntedhousehandler
                strValue2 = strValue2.seats
                isEnabled, strValue2, isDisabled, isEnabled2 = isEnabled(strValue2)
                for strValue4, value in isEnabled, strValue2, isDisabled, isEnabled2 do
                    strValue = value.taken
                    if true == strValue then
                        strValue = TriggerClientEvent
                        isEnabled4 = "rtx_themepark:HauntedHouse:Anabelle"
                        isEnabled3 = value.takenplayerid
                        strValue(isEnabled4, isEnabled3)
                    end
                end
            elseif 30832 == tableData2 then
                isEnabled = ipairs
                strValue2 = hauntedhousehandler
                strValue2 = strValue2.seats
                isEnabled, strValue2, isDisabled, isEnabled2 = isEnabled(strValue2)
                for strValue4, value in isEnabled, strValue2, isDisabled, isEnabled2 do
                    strValue = value.taken
                    if true == strValue then
                        strValue = TriggerClientEvent
                        isEnabled4 = "rtx_themepark:HauntedHouse:ValakCross"
                        isEnabled3 = value.takenplayerid
                        strValue(isEnabled4, isEnabled3)
                    end
                end
            end
        end
        tableData = Citizen
        tableData = tableData.Wait
        isEnabled = 2000
        tableData(isEnabled)
        tableData = TriggerClientEvent
        isEnabled = "rtx_themepark:HauntedHouse:AttractionEnded"
        strValue2 = -1
        tableData(isEnabled, strValue2)
        tableData = ipairs
        isEnabled = hauntedhousehandler
        isEnabled = isEnabled.seats
        tableData, isEnabled, strValue2, isDisabled = tableData(isEnabled)
        for isEnabled2, strValue4 in tableData, isEnabled, strValue2, isDisabled do
            value = strValue4.taken
            if true == value then
                strValue4.taken = false
                value = TriggerClientEvent
                strValue = "rtx_themepark:HauntedHouse:SynchronizeSeat"
                isEnabled4 = -1
                isEnabled3 = isEnabled2
                isEnabled5 = false
                isEnabled6 = strValue4.takenplayerid
                value(strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6)
                value = TriggerClientEvent
                strValue = "rtx_themepark:HauntedHouse:SeatExit"
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
                isEnabled3 = 16
                isEnabled5 = false
                value(strValue, isEnabled4, isEnabled3, isEnabled5)
                strValue4.takenplayerid = nil
            end
        end
        tableData = hauntedhousehandler
        tableData.started = false
        tableData = GlobalState
        tableData["attraction16 - phase"] = 0
        tableData = GlobalState
        tableData["attraction16 - ridedata1"] = 1
        tableData = GlobalState
        tableData["attraction16 - ridedata2"] = 8
        tableData = TriggerClientEvent
        isEnabled = "rtx_themepark:HauntedHouse:SynchronizeStarted"
        strValue2 = -1
        isDisabled = false
        tableData(isEnabled, strValue2, isDisabled)
    end
end
StartHauntedHouse = dataTable
dataTable = RegisterServerEvent
dataTable2 = "rtx_themepark:HauntedHouse:SeatUse"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:HauntedHouse:SeatUse"

function dataTable3(A0_2)
    local strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6, var2
    strValue3 = source
    tableData = themeparkattractionsopenstatus
    tableData = tableData[17]
    if true == tableData then
        tableData = themeparkdisabled
        if false == tableData then
            if nil ~= A0_2 then
                tableData = hauntedhousehandler
                tableData = tableData.started
                if false == tableData then
                    tableData = hauntedhousehandler
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
                            isEnabled4 = "rtx_themepark:HauntedHouse:SynchronizeSeat"
                            isEnabled3 = value
                            isEnabled5 = A0_2
                            isEnabled6 = true
                            var2 = tableData.takenplayerid
                            strValue(isEnabled4, isEnabled3, isEnabled5, isEnabled6, var2)
                        end
                        isEnabled = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:AttractionUsing"
                        isDisabled = strValue3
                        isEnabled2 = true
                        isEnabled(strValue2, isDisabled, isEnabled2)
                        isEnabled = TriggerClientEvent
                        strValue2 = "rtx_themepark:HauntedHouse:SeatData"
                        isDisabled = strValue3
                        isEnabled2 = A0_2
                        isEnabled(strValue2, isDisabled, isEnabled2)
                        isEnabled = Config
                        isEnabled = isEnabled.ThemeParkControlAttractions
                        if false == isEnabled then
                            isEnabled = hauntedhousehandler
                            isEnabled = isEnabled.started
                            if false == isEnabled then
                                isEnabled = Wait
                                strValue2 = Config
                                strValue2 = strValue2.AttractionsSettings
                                strValue2 = strValue2.hauntedhouse
                                strValue2 = strValue2.waitforplayers
                                isEnabled(strValue2)
                                isEnabled = hauntedhousehandler
                                isEnabled = isEnabled.started
                                if false == isEnabled then
                                    isEnabled = Config
                                    isEnabled = isEnabled.ThemeParkControlAttractions
                                    if false == isEnabled then
                                        isEnabled = hauntedhousehandler
                                        isEnabled.started = true
                                        isEnabled = TriggerClientEvent
                                        strValue2 = "rtx_themepark:HauntedHouse:SynchronizeStarted"
                                        isDisabled = -1
                                        isEnabled2 = true
                                        isEnabled(strValue2, isDisabled, isEnabled2)
                                        isEnabled = StartHauntedHouse
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
dataTable2 = "rtx_themepark:HauntedHouse:ExitAttraction"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:HauntedHouse:ExitAttraction"

function dataTable3(A0_2)
    local strValue3, tableData, isEnabled, strValue2, isDisabled, isEnabled2, strValue4, value, strValue, isEnabled4, isEnabled3, isEnabled5, isEnabled6, var2
    strValue3 = source
    if nil ~= A0_2 then
        tableData = hauntedhousehandler
        tableData = tableData.seats
        tableData = tableData[A0_2]
        isEnabled = tableData.taken
        if true == isEnabled then
            isEnabled = tableData.takenplayerid
            if isEnabled == strValue3 then
                isEnabled = Config
                isEnabled = isEnabled.ThemeParkDisableExit
                if false ~= isEnabled then
                    isEnabled = hauntedhousehandler
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
                    isEnabled4 = "rtx_themepark:HauntedHouse:SynchronizeSeat"
                    isEnabled3 = value
                    isEnabled5 = A0_2
                    isEnabled6 = false
                    var2 = tableData.takenplayerid
                    strValue(isEnabled4, isEnabled3, isEnabled5, isEnabled6, var2)
                end
                isEnabled = TriggerClientEvent
                strValue2 = "rtx_themepark:HauntedHouse:SeatExit"
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
dataTable2 = "rtx_themepark:HauntedHouse:Start"

function dataTable3()
    local tableData2, strValue3, tableData, isEnabled
    tableData2 = hauntedhousehandler
    tableData2 = tableData2.started
    if false == tableData2 then
        tableData2 = hauntedhousehandler
        tableData2.started = true
        tableData2 = TriggerClientEvent
        strValue3 = "rtx_themepark:HauntedHouse:SynchronizeStarted"
        tableData = -1
        isEnabled = true
        tableData2(strValue3, tableData, isEnabled)
        tableData2 = StartHauntedHouse
        tableData2()
    end
end
dataTable(dataTable2, dataTable3)