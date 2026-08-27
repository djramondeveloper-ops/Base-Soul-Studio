
local dataTable, dataTable4, dataTable5, dataTable8, dataTable6, dataTable2, dataTable7, dataTable3
dataTable = {}
dataTable.started = false
dataTable.startid = 0
dataTable4 = {}
dataTable5 = {}
dataTable8 = {}
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
dataTable7 = {}
dataTable7.taken = false
dataTable7.takenplayerid = nil
dataTable7.seattype = 1
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable8[1] = dataTable6
dataTable8[2] = dataTable2
dataTable8[3] = dataTable7
dataTable8[4] = dataTable3
dataTable5.players = dataTable8
dataTable4[1] = dataTable5
dataTable5 = {}
dataTable8 = {}
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
dataTable7 = {}
dataTable7.taken = false
dataTable7.takenplayerid = nil
dataTable7.seattype = 1
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable8[1] = dataTable6
dataTable8[2] = dataTable2
dataTable8[3] = dataTable7
dataTable8[4] = dataTable3
dataTable5.players = dataTable8
dataTable4[2] = dataTable5
dataTable5 = {}
dataTable8 = {}
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
dataTable7 = {}
dataTable7.taken = false
dataTable7.takenplayerid = nil
dataTable7.seattype = 1
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable8[1] = dataTable6
dataTable8[2] = dataTable2
dataTable8[3] = dataTable7
dataTable8[4] = dataTable3
dataTable5.players = dataTable8
dataTable4[3] = dataTable5
dataTable5 = {}
dataTable8 = {}
dataTable6 = {}
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable6.seattype = 1
dataTable2 = {}
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable2.seattype = 1
dataTable7 = {}
dataTable7.taken = false
dataTable7.takenplayerid = nil
dataTable7.seattype = 1
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable3.seattype = 1
dataTable8[1] = dataTable6
dataTable8[2] = dataTable2
dataTable8[3] = dataTable7
dataTable8[4] = dataTable3
dataTable5.players = dataTable8
dataTable4[4] = dataTable5
dataTable.carts = dataTable4
rollercoasterhandler = dataTable
dataTable = GlobalState
dataTable["attraction8 - phase"] = 0
dataTable = GlobalState
dataTable["attraction8 - ridedata1"] = 1
dataTable = GlobalState
dataTable["attraction8 - ridedata2"] = 8
dataTable = GlobalState
dataTable["attraction8 - synchdata"] = 1

function dataTable()
    local tableData2, strValue8, tableData, strValue, strValue4, isDisabled4, strValue5, isDisabled3, isEnabled4, strValue2, value, strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3, isDisabled, isDisabled2, strValue7, func, strValue3, var24, isEnabled, var2, isDisabled5, var22, var23
    tableData2 = rollercoasterhandler
    tableData2 = tableData2.started
    if true == tableData2 then
        tableData2 = Citizen
        tableData2 = tableData2.Wait
        strValue8 = 1000
        tableData2(strValue8)
        tableData2 = TriggerClientEvent
        strValue8 = "rtx_themepark:Global:MusicStartAttraction"
        tableData = -1
        strValue = "rollercoaster"
        strValue4 = math
        strValue4 = strValue4.random
        isDisabled4 = 1
        strValue5 = Config
        strValue5 = strValue5.AttractionsMusic
        strValue5 = strValue5.rollercoaster
        strValue5 = strValue5.playlist
        strValue5 = #strValue5
        strValue4, isDisabled4, strValue5, isDisabled3, isEnabled4, strValue2, value, strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3, isDisabled, isDisabled2, strValue7, func, strValue3, var24, isEnabled, var2, isDisabled5, var22, var23 = strValue4(isDisabled4, strValue5)
        tableData2(strValue8, tableData, strValue, strValue4, isDisabled4, strValue5, isDisabled3, isEnabled4, strValue2, value, strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3, isDisabled, isDisabled2, strValue7, func, strValue3, var24, isEnabled, var2, isDisabled5, var22, var23)
        tableData2 = rollercoasterhandler
        tableData2.startid = 0
        tableData2 = GlobalState
        tableData2["attraction8 - phase"] = 1
        tableData2 = GlobalState
        tableData2["attraction8 - ridedata1"] = 1
        tableData2 = GlobalState
        tableData2["attraction8 - ridedata2"] = 8
        tableData2 = GlobalState
        tableData2["attraction8 - synchdata"] = 1
        tableData2 = ipairs
        strValue8 = rollercoasterhandler
        strValue8 = strValue8.carts
        tableData2, strValue8, tableData, strValue = tableData2(strValue8)
        for strValue4, isDisabled4 in tableData2, strValue8, tableData, strValue do
            strValue5 = ipairs
            isDisabled3 = isDisabled4.players
            strValue5, isDisabled3, isEnabled4, strValue2 = strValue5(isDisabled3)
            for value, strValue6 in strValue5, isDisabled3, isEnabled4, strValue2 do
                strValue9 = strValue6.taken
                if true == strValue9 then
                    strValue9 = pairs
                    strValue10 = playsersinthemepark
                    strValue9, strValue10, func2, isEnabled2 = strValue9(strValue10)
                    for isEnabled3, isDisabled in strValue9, strValue10, func2, isEnabled2 do
                        isDisabled2 = TriggerClientEvent
                        strValue7 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                        func = isDisabled
                        strValue3 = strValue4
                        var24 = value
                        isEnabled = true
                        var2 = strValue6.takenplayerid
                        isDisabled5 = strValue6.seattype
                        isDisabled2(strValue7, func, strValue3, var24, isEnabled, var2, isDisabled5)
                    end
                    strValue9 = TriggerClientEvent
                    strValue10 = "rtx_themepark:Global:AttractionUsing"
                    func2 = strValue6.takenplayerid
                    isEnabled2 = true
                    strValue9(strValue10, func2, isEnabled2)
                end
            end
        end
        tableData2 = 1
        strValue8 = Config
        strValue8 = strValue8.AttractionsSettings
        strValue8 = strValue8.rollercoaster
        strValue8 = strValue8.speedmodifier
        strValue8 = 8 * strValue8
        tableData = pairs
        strValue = playsersinthemepark
        tableData, strValue, strValue4, isDisabled4 = tableData(strValue)
        for strValue5, isDisabled3 in tableData, strValue, strValue4, isDisabled4 do
            isEnabled4 = TriggerClientEvent
            strValue2 = "rtx_themepark:Rollercoaster:StartAttraction"
            value = isDisabled3
            strValue6 = tableData2
            strValue9 = strValue8
            isEnabled4(strValue2, value, strValue6, strValue9)
        end
        tableData = GlobalState
        tableData["attraction8 - ridedata1"] = tableData2
        tableData = GlobalState
        tableData["attraction8 - ridedata2"] = strValue8
        tableData = GlobalState
        strValue = GlobalState
        strValue = strValue["attraction8 - synchdata"]
        strValue = strValue + 1
        tableData["attraction8 - synchdata"] = strValue
        while true do
            tableData = 9320
            if not (tableData2 < tableData) then
                break
            end
            tableData = Citizen
            tableData = tableData.Wait
            strValue = 20
            tableData(strValue)
            tableData = Config
            tableData = tableData.AttractionsSettings
            tableData = tableData.rollercoaster
            tableData = tableData.speedmodifier
            tableData = 8 * tableData
            tableData2 = strValue8
            strValue8 = strValue8 + tableData
            strValue = GlobalState
            strValue["attraction8 - ridedata1"] = tableData2
            strValue = GlobalState
            strValue["attraction8 - ridedata2"] = strValue8
            strValue = GlobalState
            strValue4 = GlobalState
            strValue4 = strValue4["attraction8 - synchdata"]
            strValue4 = strValue4 + 1
            strValue["attraction8 - synchdata"] = strValue4
        end
        tableData = Citizen
        tableData = tableData.Wait
        strValue = 2000
        tableData(strValue)
        tableData = TriggerClientEvent
        strValue = "rtx_themepark:Rollercoaster:AttractionEnded"
        strValue4 = -1
        tableData(strValue, strValue4)
        tableData = ipairs
        strValue = rollercoasterhandler
        strValue = strValue.carts
        tableData, strValue, strValue4, isDisabled4 = tableData(strValue)
        for strValue5, isDisabled3 in tableData, strValue, strValue4, isDisabled4 do
            isEnabled4 = ipairs
            strValue2 = isDisabled3.players
            isEnabled4, strValue2, value, strValue6 = isEnabled4(strValue2)
            for strValue9, strValue10 in isEnabled4, strValue2, value, strValue6 do
                func2 = strValue10.taken
                if true == func2 then
                    func2 = pairs
                    isEnabled2 = playsersinthemepark
                    func2, isEnabled2, isEnabled3, isDisabled = func2(isEnabled2)
                    for isDisabled2, strValue7 in func2, isEnabled2, isEnabled3, isDisabled do
                        func = TriggerClientEvent
                        strValue3 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                        var24 = strValue7
                        isEnabled = strValue5
                        var2 = strValue9
                        isDisabled5 = false
                        var22 = strValue10.takenplayerid
                        var23 = strValue10.seattype
                        func(strValue3, var24, isEnabled, var2, isDisabled5, var22, var23)
                    end
                    func2 = TriggerClientEvent
                    isEnabled2 = "rtx_themepark:Global:AttractionUsing"
                    isEnabled3 = strValue10.takenplayerid
                    isDisabled = false
                    func2(isEnabled2, isEnabled3, isDisabled)
                    func2 = TriggerClientEvent
                    isEnabled2 = "rtx_themepark:Rollercoaster:SeatExit"
                    isEnabled3 = strValue10.takenplayerid
                    func2(isEnabled2, isEnabled3)
                    func2 = TriggerClientEvent
                    isEnabled2 = "rtx_themepark:Global:TicketHandler"
                    isEnabled3 = strValue10.takenplayerid
                    isDisabled = 7
                    isDisabled2 = false
                    func2(isEnabled2, isEnabled3, isDisabled, isDisabled2)
                    strValue10.taken = false
                    strValue10.takenplayerid = nil
                    strValue10.seattype = 1
                end
            end
        end
        tableData = Citizen
        tableData = tableData.Wait
        strValue = 2500
        tableData(strValue)
        tableData = TriggerClientEvent
        strValue = "rtx_themepark:Global:MusicStopAttraction"
        strValue4 = -1
        isDisabled4 = "rollercoaster"
        tableData(strValue, strValue4, isDisabled4)
        tableData = GlobalState
        tableData["attraction8 - phase"] = 0
        tableData = rollercoasterhandler
        tableData.started = false
        tableData = TriggerClientEvent
        strValue = "rtx_themepark:Rollercoaster:SynchronizeStarted"
        strValue4 = -1
        isDisabled4 = false
        tableData(strValue, strValue4, isDisabled4)
    end
end
StartRollercoaster = dataTable
dataTable = RegisterServerEvent
dataTable4 = "rtx_themepark:Rollercoaster:SeatUse"
dataTable(dataTable4)
dataTable = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster:SeatUse"

function dataTable5(A0_2, A1_2)
    local tableData, strValue, strValue4, isDisabled4, strValue5, isDisabled3, isEnabled4, strValue2, value, strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3, isDisabled, isDisabled2
    tableData = source
    strValue = themeparkattractionsopenstatus
    strValue = strValue[3]
    if true == strValue then
        strValue = themeparkdisabled
        if false == strValue then
            if nil ~= A0_2 and nil ~= A1_2 then
                strValue = rollercoasterhandler
                strValue = strValue.started
                if false == strValue then
                    strValue = rollercoasterhandler
                    strValue = strValue.carts
                    strValue = strValue[A0_2]
                    strValue4 = strValue.players
                    strValue4 = strValue4[A1_2]
                    isDisabled4 = strValue4.taken
                    if false == isDisabled4 then
                        strValue4.taken = true
                        strValue4.takenplayerid = tableData
                        isDisabled4 = pairs
                        strValue5 = playsersinthemepark
                        isDisabled4, strValue5, isDisabled3, isEnabled4 = isDisabled4(strValue5)
                        for strValue2, value in isDisabled4, strValue5, isDisabled3, isEnabled4 do
                            strValue6 = TriggerClientEvent
                            strValue9 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                            strValue10 = value
                            func2 = A0_2
                            isEnabled2 = A1_2
                            isEnabled3 = true
                            isDisabled = strValue4.takenplayerid
                            isDisabled2 = strValue4.seattype
                            strValue6(strValue9, strValue10, func2, isEnabled2, isEnabled3, isDisabled, isDisabled2)
                        end
                        isDisabled4 = TriggerClientEvent
                        strValue5 = "rtx_themepark:Global:AttractionUsing"
                        isDisabled3 = tableData
                        isEnabled4 = true
                        isDisabled4(strValue5, isDisabled3, isEnabled4)
                        isDisabled4 = TriggerClientEvent
                        strValue5 = "rtx_themepark:Rollercoaster:SeatData"
                        isDisabled3 = tableData
                        isEnabled4 = A0_2
                        strValue2 = A1_2
                        isDisabled4(strValue5, isDisabled3, isEnabled4, strValue2)
                        isDisabled4 = Config
                        isDisabled4 = isDisabled4.ThemeParkControlAttractions
                        if false == isDisabled4 then
                            isDisabled4 = rollercoasterhandler
                            isDisabled4 = isDisabled4.started
                            if false == isDisabled4 then
                                isDisabled4 = Wait
                                strValue5 = Config
                                strValue5 = strValue5.AttractionsSettings
                                strValue5 = strValue5.rollercoaster
                                strValue5 = strValue5.waitforplayers
                                isDisabled4(strValue5)
                                isDisabled4 = rollercoasterhandler
                                isDisabled4 = isDisabled4.started
                                if false == isDisabled4 then
                                    isDisabled4 = rollercoasterhandler
                                    isDisabled4.started = true
                                    isDisabled4 = TriggerClientEvent
                                    strValue5 = "rtx_themepark:Rollercoaster:SynchronizeStarted"
                                    isDisabled3 = -1
                                    isEnabled4 = true
                                    isDisabled4(strValue5, isDisabled3, isEnabled4)
                                    isDisabled4 = StartRollercoaster
                                    isDisabled4()
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        strValue = TriggerClientEvent
        strValue4 = "rtx_themepark:Notify"
        isDisabled4 = tableData
        strValue5 = Language
        isDisabled3 = Config
        isDisabled3 = isDisabled3.Language
        strValue5 = strValue5[isDisabled3]
        strValue5 = strValue5.attractionclosed
        strValue(strValue4, isDisabled4, strValue5)
    end
end
dataTable(dataTable4, dataTable5)
dataTable = RegisterServerEvent
dataTable4 = "rtx_themepark:Rollercoaster:SeatAnimChange"
dataTable(dataTable4)
dataTable = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster:SeatAnimChange"

function dataTable5(A0_2, A1_2)
    local tableData, strValue, strValue4, isDisabled4, strValue5, isDisabled3, isEnabled4, strValue2, value, strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3, isDisabled
    tableData = source
    if nil ~= A0_2 and nil ~= A1_2 then
        strValue = rollercoasterhandler
        strValue = strValue.carts
        strValue = strValue[A0_2]
        strValue = strValue.players
        strValue = strValue[A1_2]
        strValue4 = strValue.taken
        if true == strValue4 then
            strValue4 = strValue.takenplayerid
            if strValue4 == tableData then
                strValue4 = strValue.seattype
                if 1 == strValue4 then
                    strValue.seattype = 2
                else
                    strValue.seattype = 1
                end
                strValue4 = pairs
                isDisabled4 = playsersinthemepark
                strValue4, isDisabled4, strValue5, isDisabled3 = strValue4(isDisabled4)
                for isEnabled4, strValue2 in strValue4, isDisabled4, strValue5, isDisabled3 do
                    value = TriggerClientEvent
                    strValue6 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                    strValue9 = strValue2
                    strValue10 = A0_2
                    func2 = A1_2
                    isEnabled2 = true
                    isEnabled3 = strValue.takenplayerid
                    isDisabled = strValue.seattype
                    value(strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3, isDisabled)
                end
            end
        end
    end
end
dataTable(dataTable4, dataTable5)
dataTable = RegisterServerEvent
dataTable4 = "rtx_themepark:Rollercoaster:ExitAttraction"
dataTable(dataTable4)
dataTable = AddEventHandler
dataTable4 = "rtx_themepark:Rollercoaster:ExitAttraction"

function dataTable5(A0_2, A1_2)
    local tableData, strValue, strValue4, isDisabled4, strValue5, isDisabled3, isEnabled4, strValue2, value, strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3
    tableData = source
    if nil ~= A0_2 and nil ~= A1_2 then
        strValue = rollercoasterhandler
        strValue = strValue.carts
        strValue = strValue[A0_2]
        strValue = strValue.players
        strValue = strValue[A1_2]
        strValue4 = strValue.taken
        if true == strValue4 then
            strValue4 = strValue.takenplayerid
            if strValue4 == tableData then
                strValue4 = Config
                strValue4 = strValue4.ThemeParkDisableExit
                if false ~= strValue4 then
                    strValue4 = rollercoasterhandler
                    strValue4 = strValue4.started
                    if false ~= strValue4 then
                        goto lbl_53
                    end
                end
                strValue4 = pairs
                isDisabled4 = playsersinthemepark
                strValue4, isDisabled4, strValue5, isDisabled3 = strValue4(isDisabled4)
                for isEnabled4, strValue2 in strValue4, isDisabled4, strValue5, isDisabled3 do
                    value = TriggerClientEvent
                    strValue6 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                    strValue9 = strValue2
                    strValue10 = A0_2
                    func2 = A1_2
                    isEnabled2 = false
                    isEnabled3 = strValue.takenplayerid
                    value(strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3)
                end
                strValue4 = TriggerClientEvent
                isDisabled4 = "rtx_themepark:Rollercoaster:SeatExit"
                strValue5 = strValue.takenplayerid
                strValue4(isDisabled4, strValue5)
                strValue4 = TriggerClientEvent
                isDisabled4 = "rtx_themepark:Global:AttractionUsing"
                strValue5 = strValue.takenplayerid
                isDisabled3 = false
                strValue4(isDisabled4, strValue5, isDisabled3)
                strValue.taken = false
                strValue.takenplayerid = nil
                strValue.seattype = 1
                goto lbl_62
                ::lbl_53::
                strValue4 = TriggerClientEvent
                isDisabled4 = "rtx_themepark:Notify"
                strValue5 = tableData
                isDisabled3 = Language
                isEnabled4 = Config
                isEnabled4 = isEnabled4.Language
                isDisabled3 = isDisabled3[isEnabled4]
                isDisabled3 = isDisabled3.inprogress
                strValue4(isDisabled4, strValue5, isDisabled3)
            end
        end
    end
    ::lbl_62::
end
dataTable(dataTable4, dataTable5)
dataTable = Config
dataTable = dataTable.ThemeParkAttractionFallChance
if dataTable then
    dataTable = Config
    dataTable = dataTable.ThemeParkFallSettings
    dataTable = dataTable.attractions
    dataTable = dataTable.rollercoaster
    if dataTable then
        dataTable = RegisterServerEvent
        dataTable4 = "rtx_themepark:Rollercoaster:ThrowAttraction"
        dataTable(dataTable4)
        dataTable = AddEventHandler
        dataTable4 = "rtx_themepark:Rollercoaster:ThrowAttraction"

        function dataTable5(A0_2, A1_2)
            local tableData, strValue, strValue4, isDisabled4, strValue5, isDisabled3, isEnabled4, strValue2, value, strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3
            tableData = source
            if nil ~= A0_2 and nil ~= A1_2 then
                strValue = rollercoasterhandler
                strValue = strValue.carts
                strValue = strValue[A0_2]
                strValue = strValue.players
                strValue = strValue[A1_2]
                strValue4 = strValue.taken
                if true == strValue4 then
                    strValue4 = strValue.takenplayerid
                    if strValue4 == tableData then
                        strValue4 = pairs
                        isDisabled4 = playsersinthemepark
                        strValue4, isDisabled4, strValue5, isDisabled3 = strValue4(isDisabled4)
                        for isEnabled4, strValue2 in strValue4, isDisabled4, strValue5, isDisabled3 do
                            value = TriggerClientEvent
                            strValue6 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                            strValue9 = strValue2
                            strValue10 = A0_2
                            func2 = A1_2
                            isEnabled2 = false
                            isEnabled3 = strValue.takenplayerid
                            value(strValue6, strValue9, strValue10, func2, isEnabled2, isEnabled3)
                        end
                        strValue4 = TriggerClientEvent
                        isDisabled4 = "rtx_themepark:Rollercoaster:SeatThrowClient"
                        strValue5 = strValue.takenplayerid
                        strValue4(isDisabled4, strValue5)
                        strValue4 = TriggerClientEvent
                        isDisabled4 = "rtx_themepark:Global:AttractionUsing"
                        strValue5 = strValue.takenplayerid
                        isDisabled3 = false
                        strValue4(isDisabled4, strValue5, isDisabled3)
                        strValue.taken = false
                        strValue.takenplayerid = nil
                        strValue.seattype = 1
                    end
                end
            end
        end
        dataTable(dataTable4, dataTable5)
    end
end