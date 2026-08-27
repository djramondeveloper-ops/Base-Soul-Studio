
local dataTable, coords, dataTable2, var12, var1
dataTable = {}
coords = vector3
dataTable2 = 1193.615356
var12 = -222.047531
var1 = 16.522732
coords = coords(dataTable2, var12, var1)
dataTable.coords = coords
dataTable.started = false
dataTable.currentheight = 0.0
dataTable.stageinprogress = false
dataTable.stage = 11
dataTable.stagespeed = 0.5
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
detonatorhandler = dataTable
dataTable = GlobalState
dataTable["attraction4 - phase"] = 0
dataTable = GlobalState
dataTable["attraction4 - ridedata1"] = 0.0
dataTable = GlobalState
dataTable["attraction4 - speeddata1"] = 0.1
dataTable = GlobalState
dataTable["attraction4 - synchdata"] = 1

function dataTable()
    local condition, counter, tableData, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23, var22, isEnabled3, var2
    condition = detonatorhandler
    condition = condition.started
    if true == condition then
        condition = detonatorhandler
        condition.cageclosed = true
        condition = pairs
        counter = playsersinthemepark
        condition, counter, tableData, isDisabled = condition(counter)
        for strValue, value2 in condition, counter, tableData, isDisabled do
            isEnabled2 = TriggerClientEvent
            strValue2 = "rtx_themepark:Detonator:SynchronizeCageClient"
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
        tableData = -1
        isDisabled = "detonator"
        strValue = math
        strValue = strValue.random
        value2 = 1
        isEnabled2 = Config
        isEnabled2 = isEnabled2.AttractionsMusic
        isEnabled2 = isEnabled2.detonator
        isEnabled2 = isEnabled2.playlist
        isEnabled2 = #isEnabled2
        strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23, var22, isEnabled3, var2 = strValue(value2, isEnabled2)
        condition(counter, tableData, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23, var22, isEnabled3, var2)
        condition = detonatorhandler
        condition.stageinprogress = true
        condition = detonatorhandler
        condition.stage = 1
        condition = detonatorhandler
        condition.stagespeed = 0.1
        condition = detonatorhandler
        condition.currentheight = 0.0
        condition = GlobalState
        condition["attraction4 - phase"] = 1
        condition = GlobalState
        condition["attraction4 - ridedata1"] = 0.0
        condition = GlobalState
        condition["attraction4 - speeddata1"] = 0.1
        condition = GlobalState
        condition["attraction4 - synchdata"] = 1
        condition = ipairs
        counter = detonatorhandler
        counter = counter.seats
        condition, counter, tableData, isDisabled = condition(counter)
        for strValue, value2 in condition, counter, tableData, isDisabled do
            isEnabled2 = value2.taken
            if true == isEnabled2 then
                isEnabled2 = pairs
                strValue2 = playsersinthemepark
                isEnabled2, strValue2, value3, isEnabled = isEnabled2(strValue2)
                for isDisabled2, value in isEnabled2, strValue2, value3, isEnabled do
                    func = TriggerClientEvent
                    isEnabled4 = "rtx_themepark:Detonator:SynchronizeSeat"
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
            condition = detonatorhandler
            condition = condition.stageinprogress
            if true ~= condition then
                break
            end
            condition = Citizen
            condition = condition.Wait
            counter = 20
            condition(counter)
            condition = detonatorhandler
            condition = condition.stage
            if 1 == condition then
                condition = detonatorhandler
                counter = Config
                counter = counter.AttractionsSettings
                counter = counter.detonator
                counter = counter.speedmodifier
                counter = 0.1 * counter
                condition.stagespeed = counter
                condition = detonatorhandler
                counter = detonatorhandler
                counter = counter.currentheight
                tableData = detonatorhandler
                tableData = tableData.stagespeed
                counter = counter + tableData
                condition.currentheight = counter
                condition = detonatorhandler
                condition = condition.currentheight
                if condition < 117.0 then
                else
                    condition = detonatorhandler
                    condition.stage = 2
                    condition = Citizen
                    condition = condition.Wait
                    counter = Config
                    counter = counter.AttractionsSettings
                    counter = counter.detonator
                    counter = counter.timeontop
                    condition(counter)
                end
            else
                condition = detonatorhandler
                condition = condition.stage
                if 2 == condition then
                    condition = detonatorhandler
                    counter = Config
                    counter = counter.AttractionsSettings
                    counter = counter.detonator
                    counter = counter.speedmodifier
                    counter = 1.5 * counter
                    condition.stagespeed = counter
                    condition = detonatorhandler
                    counter = detonatorhandler
                    counter = counter.currentheight
                    tableData = detonatorhandler
                    tableData = tableData.stagespeed
                    counter = counter - tableData
                    condition.currentheight = counter
                    condition = detonatorhandler
                    condition = condition.currentheight
                    if condition > 40.0 then
                    else
                        condition = detonatorhandler
                        condition.stage = 3
                    end
                else
                    condition = detonatorhandler
                    condition = condition.stage
                    if 3 == condition then
                        condition = detonatorhandler
                        counter = Config
                        counter = counter.AttractionsSettings
                        counter = counter.detonator
                        counter = counter.speedmodifier
                        counter = 1.25 * counter
                        condition.stagespeed = counter
                        condition = detonatorhandler
                        counter = detonatorhandler
                        counter = counter.currentheight
                        tableData = detonatorhandler
                        tableData = tableData.stagespeed
                        counter = counter - tableData
                        condition.currentheight = counter
                        condition = detonatorhandler
                        condition = condition.currentheight
                        if condition > 30.0 then
                        else
                            condition = detonatorhandler
                            condition.stage = 4
                        end
                    else
                        condition = detonatorhandler
                        condition = condition.stage
                        if 4 == condition then
                            condition = detonatorhandler
                            counter = Config
                            counter = counter.AttractionsSettings
                            counter = counter.detonator
                            counter = counter.speedmodifier
                            counter = 1.0 * counter
                            condition.stagespeed = counter
                            condition = detonatorhandler
                            counter = detonatorhandler
                            counter = counter.currentheight
                            tableData = detonatorhandler
                            tableData = tableData.stagespeed
                            counter = counter - tableData
                            condition.currentheight = counter
                            condition = detonatorhandler
                            condition = condition.currentheight
                            if condition > 25.0 then
                            else
                                condition = detonatorhandler
                                condition.stage = 5
                            end
                        else
                            condition = detonatorhandler
                            condition = condition.stage
                            if 5 == condition then
                                condition = detonatorhandler
                                counter = Config
                                counter = counter.AttractionsSettings
                                counter = counter.detonator
                                counter = counter.speedmodifier
                                counter = 0.75 * counter
                                condition.stagespeed = counter
                                condition = detonatorhandler
                                counter = detonatorhandler
                                counter = counter.currentheight
                                tableData = detonatorhandler
                                tableData = tableData.stagespeed
                                counter = counter - tableData
                                condition.currentheight = counter
                                condition = detonatorhandler
                                condition = condition.currentheight
                                if condition > 20.0 then
                                else
                                    condition = detonatorhandler
                                    condition.stage = 6
                                end
                            else
                                condition = detonatorhandler
                                condition = condition.stage
                                if 6 == condition then
                                    condition = detonatorhandler
                                    counter = Config
                                    counter = counter.AttractionsSettings
                                    counter = counter.detonator
                                    counter = counter.speedmodifier
                                    counter = 0.5 * counter
                                    condition.stagespeed = counter
                                    condition = detonatorhandler
                                    counter = detonatorhandler
                                    counter = counter.currentheight
                                    tableData = detonatorhandler
                                    tableData = tableData.stagespeed
                                    counter = counter - tableData
                                    condition.currentheight = counter
                                    condition = detonatorhandler
                                    condition = condition.currentheight
                                    if condition > 15.0 then
                                    else
                                        condition = detonatorhandler
                                        condition.stage = 7
                                    end
                                else
                                    condition = detonatorhandler
                                    condition = condition.stage
                                    if 7 == condition then
                                        condition = detonatorhandler
                                        counter = Config
                                        counter = counter.AttractionsSettings
                                        counter = counter.detonator
                                        counter = counter.speedmodifier
                                        counter = 0.25 * counter
                                        condition.stagespeed = counter
                                        condition = detonatorhandler
                                        counter = detonatorhandler
                                        counter = counter.currentheight
                                        tableData = detonatorhandler
                                        tableData = tableData.stagespeed
                                        counter = counter - tableData
                                        condition.currentheight = counter
                                        condition = detonatorhandler
                                        condition = condition.currentheight
                                        if condition > 10.0 then
                                        else
                                            condition = detonatorhandler
                                            condition.stage = 8
                                        end
                                    else
                                        condition = detonatorhandler
                                        condition = condition.stage
                                        if 8 == condition then
                                            condition = detonatorhandler
                                            counter = Config
                                            counter = counter.AttractionsSettings
                                            counter = counter.detonator
                                            counter = counter.speedmodifier
                                            counter = 0.1 * counter
                                            condition.stagespeed = counter
                                            condition = detonatorhandler
                                            counter = detonatorhandler
                                            counter = counter.currentheight
                                            tableData = detonatorhandler
                                            tableData = tableData.stagespeed
                                            counter = counter - tableData
                                            condition.currentheight = counter
                                            condition = detonatorhandler
                                            condition = condition.currentheight
                                            if condition > 5.0 then
                                            else
                                                condition = detonatorhandler
                                                condition.stage = 9
                                            end
                                        else
                                            condition = detonatorhandler
                                            condition = condition.stage
                                            if 9 == condition then
                                                condition = detonatorhandler
                                                counter = Config
                                                counter = counter.AttractionsSettings
                                                counter = counter.detonator
                                                counter = counter.speedmodifier
                                                counter = 0.025 * counter
                                                condition.stagespeed = counter
                                                condition = detonatorhandler
                                                counter = detonatorhandler
                                                counter = counter.currentheight
                                                tableData = detonatorhandler
                                                tableData = tableData.stagespeed
                                                counter = counter - tableData
                                                condition.currentheight = counter
                                                condition = detonatorhandler
                                                condition = condition.currentheight
                                                if condition > 0.0 then
                                                else
                                                    condition = detonatorhandler
                                                    condition.stage = 10
                                                end
                                            else
                                                condition = detonatorhandler
                                                condition = condition.stage
                                                if 10 == condition then
                                                    condition = detonatorhandler
                                                    condition.currentheight = 0.0
                                                    condition = detonatorhandler
                                                    condition.stage = 11
                                                else
                                                    condition = detonatorhandler
                                                    condition = condition.stage
                                                    if 11 == condition then
                                                        condition = detonatorhandler
                                                        condition.cageclosed = false
                                                        condition = pairs
                                                        counter = playsersinthemepark
                                                        condition, counter, tableData, isDisabled = condition(counter)
                                                        for strValue, value2 in condition, counter, tableData, isDisabled do
                                                            isEnabled2 = TriggerClientEvent
                                                            strValue2 = "rtx_themepark:Detonator:SynchronizeCageClient"
                                                            value3 = value2
                                                            isEnabled = false
                                                            isEnabled2(strValue2, value3, isEnabled)
                                                        end
                                                        condition = Citizen
                                                        condition = condition.Wait
                                                        counter = 7500
                                                        condition(counter)
                                                        condition = ipairs
                                                        counter = detonatorhandler
                                                        counter = counter.seats
                                                        condition, counter, tableData, isDisabled = condition(counter)
                                                        for strValue, value2 in condition, counter, tableData, isDisabled do
                                                            isEnabled2 = value2.taken
                                                            if true == isEnabled2 then
                                                                value2.taken = false
                                                                isEnabled2 = pairs
                                                                strValue2 = playsersinthemepark
                                                                isEnabled2, strValue2, value3, isEnabled = isEnabled2(strValue2)
                                                                for isDisabled2, value in isEnabled2, strValue2, value3, isEnabled do
                                                                    func = TriggerClientEvent
                                                                    isEnabled4 = "rtx_themepark:Detonator:SynchronizeSeat"
                                                                    var23 = value
                                                                    var22 = strValue
                                                                    isEnabled3 = false
                                                                    var2 = value2.takenplayerid
                                                                    func(isEnabled4, var23, var22, isEnabled3, var2)
                                                                end
                                                                isEnabled2 = TriggerClientEvent
                                                                strValue2 = "rtx_themepark:Detonator:SeatExit"
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
                                                                isEnabled = 4
                                                                isDisabled2 = false
                                                                isEnabled2(strValue2, value3, isEnabled, isDisabled2)
                                                                value2.takenplayerid = nil
                                                            end
                                                        end
                                                        condition = detonatorhandler
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
            condition = GlobalState
            counter = detonatorhandler
            counter = counter.stage
            condition["attraction4 - phase"] = counter
            condition = GlobalState
            counter = detonatorhandler
            counter = counter.currentheight
            condition["attraction4 - ridedata1"] = counter
            condition = GlobalState
            counter = detonatorhandler
            counter = counter.stagespeed
            condition["attraction4 - speeddata1"] = counter
            condition = GlobalState
            counter = GlobalState
            counter = counter["attraction4 - synchdata"]
            counter = counter + 1
            condition["attraction4 - synchdata"] = counter
        end
        condition = TriggerClientEvent
        counter = "rtx_themepark:Global:MusicStopAttraction"
        tableData = -1
        isDisabled = "detonator"
        condition(counter, tableData, isDisabled)
        condition = detonatorhandler
        condition.currentheight = 0.0
        condition = GlobalState
        condition["attraction4 - phase"] = 0
        condition = GlobalState
        condition["attraction4 - ridedata1"] = 0.0
        condition = detonatorhandler
        condition.started = false
        condition = TriggerClientEvent
        counter = "rtx_themepark:Detonator:SynchronizeStarted"
        tableData = -1
        isDisabled = false
        condition(counter, tableData, isDisabled)
    end
end
StartDetonator = dataTable
dataTable = RegisterServerEvent
coords = "rtx_themepark:Detonator:SeatUse"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:Detonator:SeatUse"

function dataTable2(A0_2)
    local counter, tableData, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23
    counter = source
    tableData = themeparkattractionsopenstatus
    tableData = tableData[9]
    if true == tableData then
        tableData = themeparkdisabled
        if false == tableData then
            if nil ~= A0_2 then
                tableData = detonatorhandler
                tableData = tableData.started
                if false == tableData then
                    tableData = detonatorhandler
                    tableData = tableData.seats
                    tableData = tableData[A0_2]
                    isDisabled = tableData.taken
                    if false == isDisabled then
                        tableData.taken = true
                        tableData.takenplayerid = counter
                        isDisabled = pairs
                        strValue = playsersinthemepark
                        isDisabled, strValue, value2, isEnabled2 = isDisabled(strValue)
                        for strValue2, value3 in isDisabled, strValue, value2, isEnabled2 do
                            isEnabled = TriggerClientEvent
                            isDisabled2 = "rtx_themepark:Detonator:SynchronizeSeat"
                            value = value3
                            func = A0_2
                            isEnabled4 = true
                            var23 = tableData.takenplayerid
                            isEnabled(isDisabled2, value, func, isEnabled4, var23)
                        end
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Detonator:SeatData"
                        value2 = counter
                        isEnabled2 = A0_2
                        isDisabled(strValue, value2, isEnabled2)
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Detonator:DisableCollision"
                        value2 = counter
                        isEnabled2 = false
                        isDisabled(strValue, value2, isEnabled2)
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Global:AttractionUsing"
                        value2 = counter
                        isEnabled2 = true
                        isDisabled(strValue, value2, isEnabled2)
                        isDisabled = Config
                        isDisabled = isDisabled.ThemeParkControlAttractions
                        if false == isDisabled then
                            isDisabled = detonatorhandler
                            isDisabled = isDisabled.started
                            if false == isDisabled then
                                isDisabled = attractionlockdown
                                if false == isDisabled then
                                    isDisabled = Wait
                                    strValue = Config
                                    strValue = strValue.AttractionsSettings
                                    strValue = strValue.detonator
                                    strValue = strValue.waitforplayers
                                    isDisabled(strValue)
                                    isDisabled = detonatorhandler
                                    isDisabled = isDisabled.started
                                    if false == isDisabled then
                                        isDisabled = detonatorhandler
                                        isDisabled.started = true
                                        isDisabled = TriggerClientEvent
                                        strValue = "rtx_themepark:Detonator:SynchronizeStarted"
                                        value2 = -1
                                        isEnabled2 = true
                                        isDisabled(strValue, value2, isEnabled2)
                                        isDisabled = StartDetonator
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
        tableData = TriggerClientEvent
        isDisabled = "rtx_themepark:Notify"
        strValue = counter
        value2 = Language
        isEnabled2 = Config
        isEnabled2 = isEnabled2.Language
        value2 = value2[isEnabled2]
        value2 = value2.attractionclosed
        tableData(isDisabled, strValue, value2)
    end
end
dataTable(coords, dataTable2)
dataTable = RegisterServerEvent
coords = "rtx_themepark:Detonator:ExitAttraction"
dataTable(coords)
dataTable = AddEventHandler
coords = "rtx_themepark:Detonator:ExitAttraction"

function dataTable2(A0_2)
    local counter, tableData, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23
    counter = source
    if nil ~= A0_2 then
        tableData = detonatorhandler
        tableData = tableData.seats
        tableData = tableData[A0_2]
        isDisabled = tableData.taken
        if true == isDisabled then
            isDisabled = tableData.takenplayerid
            if isDisabled == counter then
                isDisabled = Config
                isDisabled = isDisabled.ThemeParkDisableExit
                if false ~= isDisabled then
                    isDisabled = detonatorhandler
                    isDisabled = isDisabled.started
                    if false ~= isDisabled then
                        goto lbl_54
                    end
                end
                isDisabled = TriggerClientEvent
                strValue = "rtx_themepark:Detonator:DisableCollision"
                value2 = counter
                isEnabled2 = true
                isDisabled(strValue, value2, isEnabled2)
                isDisabled = pairs
                strValue = playsersinthemepark
                isDisabled, strValue, value2, isEnabled2 = isDisabled(strValue)
                for strValue2, value3 in isDisabled, strValue, value2, isEnabled2 do
                    isEnabled = TriggerClientEvent
                    isDisabled2 = "rtx_themepark:Detonator:SynchronizeSeat"
                    value = value3
                    func = A0_2
                    isEnabled4 = false
                    var23 = tableData.takenplayerid
                    isEnabled(isDisabled2, value, func, isEnabled4, var23)
                end
                isDisabled = TriggerClientEvent
                strValue = "rtx_themepark:Detonator:SeatExit"
                value2 = tableData.takenplayerid
                isEnabled2 = false
                isDisabled(strValue, value2, isEnabled2)
                isDisabled = TriggerClientEvent
                strValue = "rtx_themepark:Global:AttractionUsing"
                value2 = tableData.takenplayerid
                isEnabled2 = false
                isDisabled(strValue, value2, isEnabled2)
                tableData.taken = false
                tableData.takenplayerid = nil
                tableData.seattype = 1
                goto lbl_63
                ::lbl_54::
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
    ::lbl_63::
end
dataTable(coords, dataTable2)
dataTable = Config
dataTable = dataTable.ThemeParkAttractionFallChance
if dataTable then
    dataTable = Config
    dataTable = dataTable.ThemeParkFallSettings
    dataTable = dataTable.attractions
    dataTable = dataTable.detonator
    if dataTable then
        dataTable = RegisterServerEvent
        coords = "rtx_themepark:Detonator:ThrowAttraction"
        dataTable(coords)
        dataTable = AddEventHandler
        coords = "rtx_themepark:Detonator:ThrowAttraction"

        function dataTable2(A0_2)
            local counter, tableData, isDisabled, strValue, value2, isEnabled2, strValue2, value3, isEnabled, isDisabled2, value, func, isEnabled4, var23
            counter = source
            if nil ~= A0_2 then
                tableData = detonatorhandler
                tableData = tableData.seats
                tableData = tableData[A0_2]
                isDisabled = tableData.taken
                if true == isDisabled then
                    isDisabled = tableData.takenplayerid
                    if isDisabled == counter then
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Detonator:DisableCollision"
                        value2 = counter
                        isEnabled2 = true
                        isDisabled(strValue, value2, isEnabled2)
                        isDisabled = pairs
                        strValue = playsersinthemepark
                        isDisabled, strValue, value2, isEnabled2 = isDisabled(strValue)
                        for strValue2, value3 in isDisabled, strValue, value2, isEnabled2 do
                            isEnabled = TriggerClientEvent
                            isDisabled2 = "rtx_themepark:Detonator:SynchronizeSeat"
                            value = value3
                            func = A0_2
                            isEnabled4 = false
                            var23 = tableData.takenplayerid
                            isEnabled(isDisabled2, value, func, isEnabled4, var23)
                        end
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Detonator:SeatThrowClient"
                        value2 = tableData.takenplayerid
                        isDisabled(strValue, value2)
                        isDisabled = TriggerClientEvent
                        strValue = "rtx_themepark:Global:AttractionUsing"
                        value2 = tableData.takenplayerid
                        isEnabled2 = false
                        isDisabled(strValue, value2, isEnabled2)
                        tableData.taken = false
                        tableData.takenplayerid = nil
                        tableData.seattype = 1
                    end
                end
            end
        end
        dataTable(coords, dataTable2)
    end
end