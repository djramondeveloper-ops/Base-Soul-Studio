
local dataTable, dataTable2, dataTable3, dataTable4, func, counter2, counter4, var1
dataTable = {}
dataTable.started = false
dataTable2 = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4 = {}
func = vec3
counter2 = 0.33
counter4 = -0.011
var1 = -0.432
func = func(counter2, counter4, var1)
dataTable4.coords = func
func = vec3
counter2 = 0.0
counter4 = 0.0
var1 = 180.0
func = func(counter2, counter4, var1)
dataTable4.rotation = func
dataTable3.offsets = dataTable4
dataTable2[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable4 = {}
func = vec3
counter2 = -0.284
counter4 = -0.011
var1 = -0.432
func = func(counter2, counter4, var1)
dataTable4.coords = func
func = vec3
counter2 = 0.0
counter4 = 0.0
var1 = 180.0
func = func(counter2, counter4, var1)
dataTable4.rotation = func
dataTable3.offsets = dataTable4
dataTable2[2] = dataTable3
dataTable.seats = dataTable2
slingshothandler = dataTable
dataTable = GlobalState
dataTable["attraction12 - phase"] = 0
dataTable = GlobalState
dataTable["attraction12 - ridedata1"] = 0.0
dataTable = GlobalState
dataTable["attraction12 - ridedata2"] = 0.0
dataTable = GlobalState
dataTable["attraction12 - speeddata1"] = 2.0
dataTable = GlobalState
dataTable["attraction12 - speeddata2"] = 2.0
dataTable = GlobalState
dataTable["attraction12 - rideway"] = 0.0
dataTable = GlobalState
dataTable["attraction12 - synchdata"] = 1

function dataTable()
    local isEnabled6, counter5, strValue3, isEnabled, counter3, counter6, isEnabled2, isEnabled5, counter7, counter, strValue2, isEnabled3, value, func2, strValue, var2, isEnabled4, isDisabled, var23
    isEnabled6 = slingshothandler
    isEnabled6.started = true
    isEnabled6 = true
    counter5 = ipairs
    strValue3 = slingshothandler
    strValue3 = strValue3.seats
    counter5, strValue3, isEnabled, counter3 = counter5(strValue3)
    for counter6, isEnabled2 in counter5, strValue3, isEnabled, counter3 do
        isEnabled5 = isEnabled2.taken
        if true == isEnabled5 then
            isEnabled5 = TriggerClientEvent
            counter7 = "rtx_themepark:SlingShot:SynchronizeSeat"
            counter = -1
            strValue2 = counter6
            isEnabled3 = true
            value = isEnabled2.takenplayerid
            isEnabled5(counter7, counter, strValue2, isEnabled3, value)
        end
    end
    counter5 = Citizen
    counter5 = counter5.Wait
    strValue3 = 1500
    counter5(strValue3)
    counter5 = TriggerClientEvent
    strValue3 = "rtx_themepark:Global:MusicStartAttraction"
    isEnabled = -1
    counter3 = "slingshot"
    counter6 = math
    counter6 = counter6.random
    isEnabled2 = 1
    isEnabled5 = Config
    isEnabled5 = isEnabled5.AttractionsMusic
    isEnabled5 = isEnabled5.slingshot
    isEnabled5 = isEnabled5.playlist
    isEnabled5 = #isEnabled5
    counter6, isEnabled2, isEnabled5, counter7, counter, strValue2, isEnabled3, value, func2, strValue, var2, isEnabled4, isDisabled, var23 = counter6(isEnabled2, isEnabled5)
    counter5(strValue3, isEnabled, counter3, counter6, isEnabled2, isEnabled5, counter7, counter, strValue2, isEnabled3, value, func2, strValue, var2, isEnabled4, isDisabled, var23)
    counter5 = GlobalState
    counter5["attraction12 - phase"] = 1
    counter5 = GlobalState
    counter5["attraction12 - ridedata1"] = 0.0
    counter5 = GlobalState
    counter5["attraction12 - ridedata2"] = 0.0
    counter5 = GlobalState
    counter5["attraction12 - speeddata1"] = 2.0
    counter5 = GlobalState
    counter5["attraction12 - speeddata2"] = 2.0
    counter5 = GlobalState
    counter5["attraction12 - rideway"] = 1
    counter5 = GlobalState
    counter5["attraction12 - synchdata"] = 1
    counter5 = 0
    strValue3 = Config
    strValue3 = strValue3.AttractionsSettings
    strValue3 = strValue3.slingshot
    strValue3 = strValue3.maxrounds
    isEnabled = true
    counter3 = 0.0
    counter6 = 0.0
    isEnabled2 = 0
    while isEnabled6 do
        isEnabled5 = Config
        isEnabled5 = isEnabled5.AttractionsSettings
        isEnabled5 = isEnabled5.slingshot
        isEnabled5 = isEnabled5.maxrounds
        if not (isEnabled2 <= isEnabled5) then
            break
        end
        isEnabled5 = Citizen
        isEnabled5 = isEnabled5.Wait
        counter7 = 20
        isEnabled5(counter7)
        isEnabled5 = GlobalState
        isEnabled5 = isEnabled5["attraction12 - rideway"]
        if 1 == isEnabled5 then
            isEnabled5 = GlobalState
            isEnabled5 = isEnabled5["attraction12 - ridedata1"]
            if isEnabled5 < 50.0 then
                isEnabled5 = GlobalState
                counter7 = GlobalState
                counter7 = counter7["attraction12 - ridedata1"]
                counter7 = counter7 + 2.0
                isEnabled5["attraction12 - ridedata1"] = counter7
            else
                isEnabled5 = GlobalState
                isEnabled5["attraction12 - rideway"] = 2
                isEnabled2 = isEnabled2 + 1
            end
        else
            isEnabled5 = GlobalState
            isEnabled5 = isEnabled5["attraction12 - ridedata1"]
            if isEnabled5 > 5.0 then
                isEnabled5 = GlobalState
                counter7 = GlobalState
                counter7 = counter7["attraction12 - ridedata1"]
                counter7 = counter7 - 2.0
                isEnabled5["attraction12 - ridedata1"] = counter7
            else
                isEnabled5 = GlobalState
                isEnabled5["attraction12 - rideway"] = 1
            end
        end
        isEnabled5 = GlobalState
        isEnabled5 = isEnabled5["attraction12 - ridedata2"]
        counter7 = 360.0
        if isEnabled5 > counter7 then
            isEnabled5 = GlobalState
            isEnabled5 = isEnabled5["attraction12 - ridedata2"]
            isEnabled5 = isEnabled5 - 360.0
            counter7 = GlobalState
            counter = 0.0 + isEnabled5
            counter = counter + 2.0
            counter7["attraction12 - ridedata2"] = counter
        else
            isEnabled5 = GlobalState
            counter7 = GlobalState
            counter7 = counter7["attraction12 - ridedata2"]
            counter7 = counter7 + 2.0
            isEnabled5["attraction12 - ridedata2"] = counter7
        end
        isEnabled5 = GlobalState
        counter7 = GlobalState
        counter7 = counter7["attraction12 - synchdata"]
        counter7 = counter7 + 1
        isEnabled5["attraction12 - synchdata"] = counter7
    end
    isEnabled5 = GlobalState
    isEnabled5["attraction12 - phase"] = 2
    isEnabled5 = GlobalState
    isEnabled5["attraction12 - rideway"] = 2
    isEnabled5 = GlobalState
    counter7 = Config
    counter7 = counter7.AttractionsSettings
    counter7 = counter7.slingshot
    counter7 = counter7.speedmodifier
    counter7 = 2.0 * counter7
    isEnabled5["attraction12 - speeddata2"] = counter7
    while isEnabled6 do
        isEnabled5 = Citizen
        isEnabled5 = isEnabled5.Wait
        counter7 = 20
        isEnabled5(counter7)
        isEnabled5 = GlobalState
        isEnabled5 = isEnabled5["attraction12 - ridedata1"]
        if isEnabled5 > 0.0 then
            isEnabled5 = GlobalState
            isEnabled5 = isEnabled5["attraction12 - ridedata1"]
            if isEnabled5 < 1.0 then
                isEnabled5 = GlobalState
                counter7 = GlobalState
                counter7 = counter7["attraction12 - ridedata1"]
                counter = Config
                counter = counter.AttractionsSettings
                counter = counter.slingshot
                counter = counter.speedmodifier
                counter = 0.01 * counter
                counter7 = counter7 - counter
                isEnabled5["attraction12 - ridedata1"] = counter7
                isEnabled5 = GlobalState
                counter7 = Config
                counter7 = counter7.AttractionsSettings
                counter7 = counter7.slingshot
                counter7 = counter7.speedmodifier
                counter7 = 0.01 * counter7
                isEnabled5["attraction12 - speeddata1"] = counter7
            else
                isEnabled5 = GlobalState
                isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                if isEnabled5 < 2.0 then
                    isEnabled5 = GlobalState
                    counter7 = GlobalState
                    counter7 = counter7["attraction12 - ridedata1"]
                    counter = Config
                    counter = counter.AttractionsSettings
                    counter = counter.slingshot
                    counter = counter.speedmodifier
                    counter = 0.05 * counter
                    counter7 = counter7 - counter
                    isEnabled5["attraction12 - ridedata1"] = counter7
                    isEnabled5 = GlobalState
                    counter7 = Config
                    counter7 = counter7.AttractionsSettings
                    counter7 = counter7.slingshot
                    counter7 = counter7.speedmodifier
                    counter7 = 0.05 * counter7
                    isEnabled5["attraction12 - speeddata1"] = counter7
                else
                    isEnabled5 = GlobalState
                    isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                    if isEnabled5 < 3.0 then
                        isEnabled5 = GlobalState
                        counter7 = GlobalState
                        counter7 = counter7["attraction12 - ridedata1"]
                        counter = Config
                        counter = counter.AttractionsSettings
                        counter = counter.slingshot
                        counter = counter.speedmodifier
                        counter = 0.1 * counter
                        counter7 = counter7 - counter
                        isEnabled5["attraction12 - ridedata1"] = counter7
                        isEnabled5 = GlobalState
                        counter7 = Config
                        counter7 = counter7.AttractionsSettings
                        counter7 = counter7.slingshot
                        counter7 = counter7.speedmodifier
                        counter7 = 0.1 * counter7
                        isEnabled5["attraction12 - speeddata1"] = counter7
                    else
                        isEnabled5 = GlobalState
                        isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                        if isEnabled5 < 5.0 then
                            isEnabled5 = GlobalState
                            counter7 = GlobalState
                            counter7 = counter7["attraction12 - ridedata1"]
                            counter = Config
                            counter = counter.AttractionsSettings
                            counter = counter.slingshot
                            counter = counter.speedmodifier
                            counter = 0.25 * counter
                            counter7 = counter7 - counter
                            isEnabled5["attraction12 - ridedata1"] = counter7
                            isEnabled5 = GlobalState
                            counter7 = Config
                            counter7 = counter7.AttractionsSettings
                            counter7 = counter7.slingshot
                            counter7 = counter7.speedmodifier
                            counter7 = 0.25 * counter7
                            isEnabled5["attraction12 - speeddata1"] = counter7
                        else
                            isEnabled5 = GlobalState
                            isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                            if isEnabled5 < 10.0 then
                                isEnabled5 = GlobalState
                                counter7 = GlobalState
                                counter7 = counter7["attraction12 - ridedata1"]
                                counter = Config
                                counter = counter.AttractionsSettings
                                counter = counter.slingshot
                                counter = counter.speedmodifier
                                counter = 0.5 * counter
                                counter7 = counter7 - counter
                                isEnabled5["attraction12 - ridedata1"] = counter7
                                isEnabled5 = GlobalState
                                counter7 = Config
                                counter7 = counter7.AttractionsSettings
                                counter7 = counter7.slingshot
                                counter7 = counter7.speedmodifier
                                counter7 = 0.5 * counter7
                                isEnabled5["attraction12 - speeddata1"] = counter7
                            else
                                isEnabled5 = GlobalState
                                isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                                if isEnabled5 < 15.0 then
                                    isEnabled5 = GlobalState
                                    counter7 = GlobalState
                                    counter7 = counter7["attraction12 - ridedata1"]
                                    counter = Config
                                    counter = counter.AttractionsSettings
                                    counter = counter.slingshot
                                    counter = counter.speedmodifier
                                    counter = 0.75 * counter
                                    counter7 = counter7 - counter
                                    isEnabled5["attraction12 - ridedata1"] = counter7
                                    isEnabled5 = GlobalState
                                    counter7 = Config
                                    counter7 = counter7.AttractionsSettings
                                    counter7 = counter7.slingshot
                                    counter7 = counter7.speedmodifier
                                    counter7 = 0.75 * counter7
                                    isEnabled5["attraction12 - speeddata1"] = counter7
                                else
                                    isEnabled5 = GlobalState
                                    isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                                    if isEnabled5 < 20.0 then
                                        isEnabled5 = GlobalState
                                        counter7 = GlobalState
                                        counter7 = counter7["attraction12 - ridedata1"]
                                        counter = Config
                                        counter = counter.AttractionsSettings
                                        counter = counter.slingshot
                                        counter = counter.speedmodifier
                                        counter = 1.0 * counter
                                        counter7 = counter7 - counter
                                        isEnabled5["attraction12 - ridedata1"] = counter7
                                        isEnabled5 = GlobalState
                                        counter7 = Config
                                        counter7 = counter7.AttractionsSettings
                                        counter7 = counter7.slingshot
                                        counter7 = counter7.speedmodifier
                                        counter7 = 1.0 * counter7
                                        isEnabled5["attraction12 - speeddata1"] = counter7
                                    else
                                        isEnabled5 = GlobalState
                                        isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                                        if isEnabled5 < 35.0 then
                                            isEnabled5 = GlobalState
                                            counter7 = GlobalState
                                            counter7 = counter7["attraction12 - ridedata1"]
                                            counter = Config
                                            counter = counter.AttractionsSettings
                                            counter = counter.slingshot
                                            counter = counter.speedmodifier
                                            counter = 1.25 * counter
                                            counter7 = counter7 - counter
                                            isEnabled5["attraction12 - ridedata1"] = counter7
                                            isEnabled5 = GlobalState
                                            counter7 = Config
                                            counter7 = counter7.AttractionsSettings
                                            counter7 = counter7.slingshot
                                            counter7 = counter7.speedmodifier
                                            counter7 = 1.25 * counter7
                                            isEnabled5["attraction12 - speeddata1"] = counter7
                                        else
                                            isEnabled5 = GlobalState
                                            isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                                            if isEnabled5 < 40.0 then
                                                isEnabled5 = GlobalState
                                                counter7 = GlobalState
                                                counter7 = counter7["attraction12 - ridedata1"]
                                                counter = Config
                                                counter = counter.AttractionsSettings
                                                counter = counter.slingshot
                                                counter = counter.speedmodifier
                                                counter = 1.5 * counter
                                                counter7 = counter7 - counter
                                                isEnabled5["attraction12 - ridedata1"] = counter7
                                                isEnabled5 = GlobalState
                                                counter7 = Config
                                                counter7 = counter7.AttractionsSettings
                                                counter7 = counter7.slingshot
                                                counter7 = counter7.speedmodifier
                                                counter7 = 1.5 * counter7
                                                isEnabled5["attraction12 - speeddata1"] = counter7
                                            else
                                                isEnabled5 = GlobalState
                                                counter7 = GlobalState
                                                counter7 = counter7["attraction12 - ridedata1"]
                                                counter = Config
                                                counter = counter.AttractionsSettings
                                                counter = counter.slingshot
                                                counter = counter.speedmodifier
                                                counter = 1.75 * counter
                                                counter7 = counter7 - counter
                                                isEnabled5["attraction12 - ridedata1"] = counter7
                                                isEnabled5 = GlobalState
                                                counter7 = Config
                                                counter7 = counter7.AttractionsSettings
                                                counter7 = counter7.slingshot
                                                counter7 = counter7.speedmodifier
                                                counter7 = 1.75 * counter7
                                                isEnabled5["attraction12 - speeddata1"] = counter7
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            isEnabled5 = GlobalState
            isEnabled5 = isEnabled5["attraction12 - ridedata2"]
            counter7 = 360.0
            if isEnabled5 < counter7 then
                isEnabled5 = GlobalState
                isEnabled5 = isEnabled5["attraction12 - ridedata2"]
                counter7 = 0.25
                if isEnabled5 > counter7 then
                    isEnabled5 = GlobalState
                    counter7 = GlobalState
                    counter7 = counter7["attraction12 - ridedata2"]
                    counter = Config
                    counter = counter.AttractionsSettings
                    counter = counter.slingshot
                    counter = counter.speedmodifier
                    counter = 2.0 * counter
                    counter7 = counter7 + counter
                    isEnabled5["attraction12 - ridedata2"] = counter7
                end
            else
                isEnabled5 = GlobalState
                isEnabled5["attraction12 - ridedata2"] = 0.0
                isEnabled5 = GlobalState
                isEnabled5["attraction12 - rideway"] = 1
            end
        else
            isEnabled5 = GlobalState
            isEnabled5["attraction12 - ridedata1"] = 0.0
            isEnabled5 = GlobalState
            isEnabled5 = isEnabled5["attraction12 - rideway"]
            if 1 == isEnabled5 then
                isEnabled5 = GlobalState
                isEnabled5 = isEnabled5["attraction12 - ridedata1"]
                if isEnabled5 <= 0.0 then
                    isEnabled6 = false
                end
            end
        end
        isEnabled5 = GlobalState
        counter7 = GlobalState
        counter7 = counter7["attraction12 - synchdata"]
        counter7 = counter7 + 1
        isEnabled5["attraction12 - synchdata"] = counter7
    end
    isEnabled5 = TriggerClientEvent
    counter7 = "rtx_themepark:Global:MusicStopAttraction"
    counter = -1
    strValue2 = "slingshot"
    isEnabled5(counter7, counter, strValue2)
    isEnabled5 = GlobalState
    isEnabled5["attraction12 - phase"] = 0
    isEnabled5 = ipairs
    counter7 = slingshothandler
    counter7 = counter7.seats
    isEnabled5, counter7, counter, strValue2 = isEnabled5(counter7)
    for isEnabled3, value in isEnabled5, counter7, counter, strValue2 do
        func2 = value.taken
        if true == func2 then
            value.taken = false
            func2 = TriggerClientEvent
            strValue = "rtx_themepark:SlingShot:SynchronizeSeat"
            var2 = -1
            isEnabled4 = isEnabled3
            isDisabled = false
            var23 = value.takenplayerid
            func2(strValue, var2, isEnabled4, isDisabled, var23)
            func2 = TriggerClientEvent
            strValue = "rtx_themepark:SlingShot:SeatExit"
            var2 = value.takenplayerid
            isEnabled4 = true
            func2(strValue, var2, isEnabled4)
            func2 = TriggerClientEvent
            strValue = "rtx_themepark:Global:AttractionUsing"
            var2 = value.takenplayerid
            isEnabled4 = false
            func2(strValue, var2, isEnabled4)
            func2 = TriggerClientEvent
            strValue = "rtx_themepark:Global:TicketHandler"
            var2 = value.takenplayerid
            isEnabled4 = 12
            isDisabled = false
            func2(strValue, var2, isEnabled4, isDisabled)
            value.takenplayerid = nil
        end
    end
    isEnabled5 = TriggerClientEvent
    counter7 = "rtx_themepark:SlingShot:AttractionFinish"
    counter = -1
    isEnabled5(counter7, counter)
    isEnabled5 = slingshothandler
    isEnabled5.started = false
    isEnabled5 = slingshothandler
    isEnabled5.started = false
end
StartAttraction12 = dataTable
dataTable = RegisterServerEvent
dataTable2 = "rtx_themepark:SlingShot:SeatUse"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:SlingShot:SeatUse"

function dataTable3(A0_2)
    local counter5, strValue3, isEnabled, counter3, counter6, isEnabled2, isEnabled5, counter7
    counter5 = source
    strValue3 = themeparkattractionsopenstatus
    strValue3 = strValue3[13]
    if true == strValue3 then
        strValue3 = themeparkdisabled
        if false == strValue3 and nil ~= A0_2 then
            strValue3 = GlobalState
            strValue3 = strValue3["attraction12 - phase"]
            if 0 == strValue3 then
                strValue3 = slingshothandler
                strValue3 = strValue3.seats
                strValue3 = strValue3[A0_2]
                isEnabled = strValue3.taken
                if false == isEnabled then
                    strValue3.taken = true
                    strValue3.takenplayerid = counter5
                    isEnabled = TriggerClientEvent
                    counter3 = "rtx_themepark:SlingShot:SynchronizeSeat"
                    counter6 = -1
                    isEnabled2 = A0_2
                    isEnabled5 = true
                    counter7 = strValue3.takenplayerid
                    isEnabled(counter3, counter6, isEnabled2, isEnabled5, counter7)
                    isEnabled = TriggerClientEvent
                    counter3 = "rtx_themepark:SlingShot:SeatData"
                    counter6 = counter5
                    isEnabled2 = A0_2
                    isEnabled(counter3, counter6, isEnabled2)
                    isEnabled = TriggerClientEvent
                    counter3 = "rtx_themepark:Global:AttractionUsing"
                    counter6 = counter5
                    isEnabled2 = true
                    isEnabled(counter3, counter6, isEnabled2)
                    isEnabled = slingshothandler
                    isEnabled = isEnabled.started
                    if false == isEnabled then
                        isEnabled = Config
                        isEnabled = isEnabled.ThemeParkControlAttractions
                        if false == isEnabled then
                            isEnabled = Wait
                            counter3 = Config
                            counter3 = counter3.AttractionsSettings
                            counter3 = counter3.slingshot
                            counter3 = counter3.waitforplayers
                            isEnabled(counter3)
                            isEnabled = slingshothandler
                            isEnabled = isEnabled.started
                            if false == isEnabled then
                                isEnabled = slingshothandler
                                isEnabled.started = true
                                isEnabled = StartAttraction12
                                isEnabled()
                            end
                        end
                    end
                end
            end
        end
    end
end
dataTable(dataTable2, dataTable3)
dataTable = RegisterServerEvent
dataTable2 = "rtx_themepark:SlingShot:ExitAttraction"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:SlingShot:ExitAttraction"

function dataTable3(A0_2)
    local counter5, strValue3, isEnabled, counter3, counter6, isEnabled2, isEnabled5, counter7
    counter5 = source
    if nil ~= A0_2 then
        strValue3 = slingshothandler
        strValue3 = strValue3.seats
        strValue3 = strValue3[A0_2]
        isEnabled = strValue3.taken
        if true == isEnabled then
            isEnabled = strValue3.takenplayerid
            if isEnabled == counter5 then
                isEnabled = Config
                isEnabled = isEnabled.ThemeParkDisableExit
                if false ~= isEnabled then
                    isEnabled = GlobalState
                    isEnabled = isEnabled["attraction12 - phase"]
                    if 0 ~= isEnabled then
                        goto lbl_41
                    end
                end
                isEnabled = TriggerClientEvent
                counter3 = "rtx_themepark:SlingShot:SynchronizeSeat"
                counter6 = -1
                isEnabled2 = A0_2
                isEnabled5 = false
                counter7 = strValue3.takenplayerid
                isEnabled(counter3, counter6, isEnabled2, isEnabled5, counter7)
                isEnabled = TriggerClientEvent
                counter3 = "rtx_themepark:SlingShot:SeatExit"
                counter6 = strValue3.takenplayerid
                isEnabled2 = false
                isEnabled(counter3, counter6, isEnabled2)
                isEnabled = TriggerClientEvent
                counter3 = "rtx_themepark:Global:AttractionUsing"
                counter6 = strValue3.takenplayerid
                isEnabled2 = false
                isEnabled(counter3, counter6, isEnabled2)
                strValue3.taken = false
                strValue3.takenplayerid = nil
                goto lbl_50
                ::lbl_41::
                isEnabled = TriggerClientEvent
                counter3 = "rtx_themepark:Notify"
                counter6 = counter5
                isEnabled2 = Language
                isEnabled5 = Config
                isEnabled5 = isEnabled5.Language
                isEnabled2 = isEnabled2[isEnabled5]
                isEnabled2 = isEnabled2.inprogress
                isEnabled(counter3, counter6, isEnabled2)
            end
        end
    end
    ::lbl_50::
end
dataTable(dataTable2, dataTable3)
dataTable = RegisterServerEvent
dataTable2 = "rtx_themepark:SlingShot:Resynch"
dataTable(dataTable2)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:SlingShot:Resynch"

function dataTable3()
    local isEnabled6, counter5, strValue3, isEnabled, counter3, counter6, isEnabled2, isEnabled5, counter7, counter, strValue2, isEnabled3, value, func2, strValue, var2, isEnabled4, isDisabled, var23, var22
    isEnabled6 = source
    counter5 = ipairs
    strValue3 = slingshothandler
    strValue3 = strValue3.seats
    counter5, strValue3, isEnabled, counter3 = counter5(strValue3)
    for counter6, isEnabled2 in counter5, strValue3, isEnabled, counter3 do
        isEnabled5 = ipairs
        counter7 = isEnabled2.seats
        isEnabled5, counter7, counter, strValue2 = isEnabled5(counter7)
        for isEnabled3, value in isEnabled5, counter7, counter, strValue2 do
            func2 = TriggerClientEvent
            strValue = "rtx_themepark:SlingShot:SynchronizeSeat"
            var2 = isEnabled6
            isEnabled4 = counter6
            isDisabled = isEnabled3
            var23 = value.taken
            var22 = value.takenplayerid
            func2(strValue, var2, isEnabled4, isDisabled, var23, var22)
        end
    end
    counter5 = slingshothandler
    counter5 = counter5.started
    if true == counter5 then
        counter5 = TriggerClientEvent
        strValue3 = "rtx_themepark:SlingShot:ResynchClient"
        isEnabled = isEnabled6
        counter5(strValue3, isEnabled)
    end
end
dataTable(dataTable2, dataTable3)
dataTable = AddEventHandler
dataTable2 = "rtx_themepark:SlingShot:Start"

function dataTable3()
    local isEnabled6, counter5
    isEnabled6 = slingshothandler
    isEnabled6 = isEnabled6.started
    if false == isEnabled6 then
        isEnabled6 = slingshothandler
        isEnabled6.started = true
        isEnabled6 = StartAttraction12
        isEnabled6()
    end
end
dataTable(dataTable2, dataTable3)