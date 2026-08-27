
local dataTable, dataTable3, func2
dataTable = {}
dataTable.currentplayers = 0
dataTable3 = {}
dataTable.bumperplayers = dataTable3
bumperhandler = dataTable
dataTable = RegisterServerEvent
dataTable3 = "rtx_themepark:Bumper:CheckTickets"
dataTable(dataTable3)
dataTable = AddEventHandler
dataTable3 = "rtx_themepark:Bumper:CheckTickets"

function func2()
    local index, condition, strValue3, strValue, playerPed, strValue4
    index = source
    condition = themeparkattractionsopenstatus
    condition = condition[6]
    if true == condition then
        condition = themeparkdisabled
        if false == condition then
            condition = attractionlockdown
            if false == condition then
                condition = Config
                condition = condition.AttractionsSettings
                condition = condition.bumpercars
                condition = condition.disable
                if false == condition then
                    condition = bumperhandler
                    condition = condition.currentplayers
                    strValue3 = Config
                    strValue3 = strValue3.AttractionsSettings
                    strValue3 = strValue3.bumpercars
                    strValue3 = strValue3.maxplayers
                    if condition < strValue3 then
                        condition = TriggerClientEvent
                        strValue3 = "rtx_themepark:Bumper:OpenTicketMenu"
                        strValue = index
                        condition(strValue3, strValue)
                    else
                        condition = TriggerClientEvent
                        strValue3 = "rtx_themepark:Notify"
                        strValue = index
                        playerPed = Language
                        strValue4 = Config
                        strValue4 = strValue4.Language
                        playerPed = playerPed[strValue4]
                        playerPed = playerPed.bumpermaxplayers
                        condition(strValue3, strValue, playerPed)
                    end
                end
            end
        end
    else
        condition = TriggerClientEvent
        strValue3 = "rtx_themepark:Notify"
        strValue = index
        playerPed = Language
        strValue4 = Config
        strValue4 = strValue4.Language
        playerPed = playerPed[strValue4]
        playerPed = playerPed.attractionclosed
        condition(strValue3, strValue, playerPed)
    end
end
dataTable(dataTable3, func2)
dataTable = RegisterServerEvent
dataTable3 = "rtx_themepark:Bumper:PayForBumper"
dataTable(dataTable3)
dataTable = AddEventHandler
dataTable3 = "rtx_themepark:Bumper:PayForBumper"

function func2(A0_2)
    local condition, strValue3, strValue, playerPed, strValue4, dataTable2, counter, strValue5, strValue2, value
    condition = source
    A0_2 = math.floor(tonumber(A0_2) or 0)
    local _bumperConfig = Config.AttractionsSettings.bumpercars
    if A0_2 < _bumperConfig.minminutes or A0_2 > _bumperConfig.maxminutes then
        return
    end
    strValue3 = themeparkattractionsopenstatus
    strValue3 = strValue3[6]
    if true == strValue3 then
        strValue3 = themeparkdisabled
        if false == strValue3 then
            strValue3 = Config
            strValue3 = strValue3.AttractionsSettings
            strValue3 = strValue3.bumpercars
            strValue3 = strValue3.disable
            if false == strValue3 then
                if nil ~= A0_2 then
                    -- Check if player already has an active bumper car
                    strValue3 = bumperhandler
                    strValue3 = strValue3.bumperplayers
                    strValue3 = strValue3[condition]
                    if nil ~= strValue3 then
                        strValue3 = TriggerClientEvent
                        strValue = "rtx_themepark:Notify"
                        playerPed = condition
                        strValue4 = Language
                        dataTable2 = Config
                        dataTable2 = dataTable2.Language
                        strValue4 = strValue4[dataTable2]
                        strValue4 = strValue4.alreadyinattraction or "You already have an active ride!"
                        strValue3(strValue, playerPed, strValue4)
                        return
                    end
                    strValue3 = bumperhandler
                    strValue3 = strValue3.currentplayers
                    strValue = Config
                    strValue = strValue.AttractionsSettings
                    strValue = strValue.bumpercars
                    strValue = strValue.maxplayers
                    if strValue3 < strValue then
                        strValue3 = Config
                        strValue3 = strValue3.AttractionsSettings
                        strValue3 = strValue3.bumpercars
                        strValue3 = strValue3.priceperminute
                        strValue3 = strValue3 * A0_2
                        strValue = GetMoneyRTX
                        playerPed = condition
                        strValue = strValue(playerPed)
                        if strValue3 <= strValue then
                            playerPed = RemoveMoneyRTX
                            strValue4 = condition
                            dataTable2 = strValue3
                            playerPed(strValue4, dataTable2)
                            playerPed = bumperhandler
                            playerPed = playerPed.currentplayers
                            if 0 == playerPed then
                                playerPed = TriggerClientEvent
                                strValue4 = "rtx_themepark:Global:MusicStartAttraction"
                                dataTable2 = -1
                                counter = "bumpercars"
                                strValue5 = math
                                strValue5 = strValue5.random
                                strValue2 = 1
                                value = Config
                                value = value.AttractionsMusic
                                value = value.bumpercars
                                value = value.playlist
                                value = #value
                                strValue5, strValue2, value = strValue5(strValue2, value)
                                playerPed(strValue4, dataTable2, counter, strValue5, strValue2, value)
                            end
                            playerPed = bumperhandler
                            strValue4 = bumperhandler
                            strValue4 = strValue4.currentplayers
                            strValue4 = strValue4 + 1
                            playerPed.currentplayers = strValue4
                            playerPed = TriggerClientEvent
                            strValue4 = "rtx_themepark:Notify"
                            dataTable2 = condition
                            counter = Language
                            strValue5 = Config
                            strValue5 = strValue5.Language
                            counter = counter[strValue5]
                            counter = counter.bumperticketpurchased
                            playerPed(strValue4, dataTable2, counter)
                            playerPed = math
                            playerPed = playerPed.random
                            strValue4 = 1
                            dataTable2 = 4
                            playerPed = playerPed(strValue4, dataTable2)
                            strValue4 = bumperhandler
                            strValue4 = strValue4.bumperplayers
                            dataTable2 = {}
                            dataTable2.seattaken = false
                            dataTable2.seattakenid = nil
                            dataTable2.vehiclenetwork = nil
                            dataTable2.vehiclehandler = nil
                            dataTable2.bumpercolor = playerPed
                            strValue4[condition] = dataTable2
                            strValue4 = TriggerClientEvent
                            dataTable2 = "rtx_themepark:Bumper:SpawnBumperClient"
                            counter = condition
                            strValue5 = A0_2
                            strValue2 = playerPed
                            strValue4(dataTable2, counter, strValue5, strValue2)
                            strValue4 = Config
                            strValue4 = strValue4.ThemeParkCanBeOwned
                            if strValue4 then
                                strValue4 = round
                                dataTable2 = Config
                                dataTable2 = dataTable2.ThemeParkOwnedSettings
                                dataTable2 = dataTable2.ticketmultipler
                                dataTable2 = strValue3 * dataTable2
                                counter = 0
                                strValue4 = strValue4(dataTable2, counter)
                                dataTable2 = themeparkowned
                                counter = themeparkowned
                                counter = counter.balance
                                counter = counter + strValue4
                                dataTable2.balance = counter
                                dataTable2 = UpdateParkMoney
                                counter = themeparkowned
                                counter = counter.balance
                                dataTable2(counter)
                            end
                        else
                            playerPed = TriggerClientEvent
                            strValue4 = "rtx_themepark:Notify"
                            dataTable2 = condition
                            counter = LanguageFile("nomoneyenoughthemeparkattraction",strValue3)
                            playerPed(strValue4, dataTable2, counter)
                        end
                    else
                        strValue3 = TriggerClientEvent
                        strValue = "rtx_themepark:Notify"
                        playerPed = condition
                        strValue4 = Language
                        dataTable2 = Config
                        dataTable2 = dataTable2.Language
                        strValue4 = strValue4[dataTable2]
                        strValue4 = strValue4.bumpermaxplayers
                        strValue3(strValue, playerPed, strValue4)
                    end
                end
            end
        end
    else
        strValue3 = TriggerClientEvent
        strValue = "rtx_themepark:Notify"
        playerPed = condition
        strValue4 = Language
        dataTable2 = Config
        dataTable2 = dataTable2.Language
        strValue4 = strValue4[dataTable2]
        strValue4 = strValue4.attractionclosed
        strValue3(strValue, playerPed, strValue4)
    end
end
dataTable(dataTable3, func2)
dataTable = Config
dataTable = dataTable.ServerSideObjectsOnly
if false == dataTable then
    dataTable = RegisterServerEvent
    dataTable3 = "rtx_themepark:Bumper:SpawnBumper"
    dataTable(dataTable3)
    dataTable = AddEventHandler
    dataTable3 = "rtx_themepark:Bumper:SpawnBumper"

    function func2(A0_2)
        local condition, strValue3, strValue, playerPed, strValue4, dataTable2, counter, strValue5, strValue2, value, func, isEnabled, isDisabled2, tableData2, tableData
        condition = source
        strValue3 = bumperhandler
        strValue3 = strValue3.bumperplayers
        strValue3 = strValue3[condition]
        if nil ~= strValue3 then
            strValue3 = bumperhandler
            strValue3 = strValue3.bumperplayers
            strValue3 = strValue3[condition]
            strValue3.vehiclenetwork = A0_2
            strValue3 = pairs
            strValue = playsersinthemepark
            strValue3, strValue, playerPed, strValue4 = strValue3(strValue)
            for dataTable2, counter in strValue3, strValue, playerPed, strValue4 do
                strValue5 = TriggerClientEvent
                strValue2 = "rtx_themepark:Bumper:SynchronizeBumper"
                value = counter
                func = condition
                isEnabled = A0_2
                isDisabled2 = false
                tableData2 = nil
                tableData = bumperhandler
                tableData = tableData.bumperplayers
                tableData = tableData[condition]
                tableData = tableData.bumpercolor
                strValue5(strValue2, value, func, isEnabled, isDisabled2, tableData2, tableData)
            end
        end
    end
    dataTable(dataTable3, func2)
else
    dataTable = RegisterServerEvent
    dataTable3 = "rtx_themepark:Bumper:SpawnBumper"
    dataTable(dataTable3)
    dataTable = AddEventHandler
    dataTable3 = "rtx_themepark:Bumper:SpawnBumper"

    function func2(A0_2, A1_2, A2_2)
        local strValue, playerPed, strValue4, dataTable2, counter, strValue5, strValue2, value, func, isEnabled, isDisabled2, tableData2, tableData, isDisabled, var2, tableData3
        strValue = source
        playerPed = bumperhandler
        playerPed = playerPed.bumperplayers
        playerPed = playerPed[strValue]
        if nil ~= playerPed then
            playerPed = GetPlayerPed
            strValue4 = strValue
            playerPed = playerPed(strValue4)
            strValue4 = bumperhandler
            strValue4 = strValue4.bumperplayers
            strValue4 = strValue4[strValue]
            dataTable2 = CreateVehicleServerSetter
            counter = 329824403
            strValue5 = "automobile"
            strValue2 = A0_2.x
            value = A0_2.y
            func = A0_2.z
            func = func + 0.25
            isEnabled = A1_2
            dataTable2 = dataTable2(counter, strValue5, strValue2, value, func, isEnabled)
            strValue4.vehiclehandler = dataTable2
            while true do
                strValue4 = DoesEntityExist
                dataTable2 = bumperhandler
                dataTable2 = dataTable2.bumperplayers
                dataTable2 = dataTable2[strValue]
                dataTable2 = dataTable2.vehiclehandler
                strValue4 = strValue4(dataTable2)
                if strValue4 then
                    break
                end
                strValue4 = Citizen
                strValue4 = strValue4.Wait
                dataTable2 = 0
                strValue4(dataTable2)
            end


            -- Wait for network sync with increased delay
            Wait(250)
            strValue4 = bumperhandler
            strValue4 = strValue4.bumperplayers
            strValue4 = strValue4[strValue]
            if not strValue4 then
                return
            end
            dataTable2 = NetworkGetNetworkIdFromEntity
            counter = bumperhandler
            counter = counter.bumperplayers
            counter = counter[strValue]
            if not counter then
                return
            end
            counter = counter.vehiclehandler
            dataTable2 = dataTable2(counter)
            strValue4.vehiclenetwork = dataTable2
            -- Wait for valid network ID with better retry logic
            local _attempts = 0
            while (strValue4.vehiclenetwork == 65535 or strValue4.vehiclenetwork == 65534 or strValue4.vehiclenetwork == 0) and _attempts < 50 do
                Wait(150)
                _attempts = _attempts + 1
                strValue4 = bumperhandler
                strValue4 = strValue4.bumperplayers
                strValue4 = strValue4[strValue]
                if not strValue4 then
                    return
                end
                dataTable2 = NetworkGetNetworkIdFromEntity
                counter = bumperhandler
                counter = counter.bumperplayers
                counter = counter[strValue]
                if not counter then
                    return
                end
                counter = counter.vehiclehandler
                dataTable2 = dataTable2(counter)
                strValue4.vehiclenetwork = dataTable2
            end
            if strValue4.vehiclenetwork == 65535 or strValue4.vehiclenetwork == 65534 or strValue4.vehiclenetwork == 0 then
                print("[ERROR] Failed to get valid network ID for bumper car after " .. _attempts .. " attempts")
                return
            end

            -- Seoul key integration: only set Lockpick after the entity is network-valid.
            -- Use the exact GTA plate (including spaces) because vRP compares it literally.
            local _seoulBumperEntity = bumperhandler.bumperplayers[strValue] and bumperhandler.bumperplayers[strValue].vehiclehandler
            if not _seoulBumperEntity or not DoesEntityExist(_seoulBumperEntity) then
                return
            end
            local _seoulBumperPlate = GetVehicleNumberPlateText(_seoulBumperEntity)
            if _seoulBumperPlate and _seoulBumperPlate ~= "" then
                Entity(_seoulBumperEntity).state:set("Lockpick",_seoulBumperPlate,true)
                -- Give the state bag a short window to propagate before placing the player in the car.
                Wait(150)
            end

            strValue4 = TaskWarpPedIntoVehicle
            dataTable2 = playerPed
            counter = bumperhandler
            counter = counter.bumperplayers
            counter = counter[strValue]
            counter = counter.vehiclehandler
            strValue5 = -1
            strValue4(dataTable2, counter, strValue5)
            strValue4 = TriggerClientEvent
            dataTable2 = "rtx_themepark:Bumper:BumperHandler"
            counter = strValue
            strValue5 = A2_2
            strValue2 = bumperhandler
            strValue2 = strValue2.bumperplayers
            strValue2 = strValue2[strValue]
            strValue2 = strValue2.vehiclenetwork
            strValue4(dataTable2, counter, strValue5, strValue2)
            strValue4 = pairs
            dataTable2 = playsersinthemepark
            strValue4, dataTable2, counter, strValue5 = strValue4(dataTable2)
            for strValue2, value in strValue4, dataTable2, counter, strValue5 do
                func = TriggerClientEvent
                isEnabled = "rtx_themepark:Bumper:SynchronizeBumper"
                isDisabled2 = value
                tableData2 = strValue
                tableData = bumperhandler
                tableData = tableData.bumperplayers
                tableData = tableData[strValue]
                tableData = tableData.vehiclenetwork
                isDisabled = false
                var2 = nil
                tableData3 = bumperhandler
                tableData3 = tableData3.bumperplayers
                tableData3 = tableData3[strValue]
                tableData3 = tableData3.bumpercolor
                func(isEnabled, isDisabled2, tableData2, tableData, isDisabled, var2, tableData3)
            end
        end
    end
    dataTable(dataTable3, func2)
end
dataTable = Config
dataTable = dataTable.ServerSideObjectsOnly
if false == dataTable then
    dataTable = RegisterServerEvent
    dataTable3 = "rtx_themepark:Bumper:BumperEnd"
    dataTable(dataTable3)
    dataTable = AddEventHandler
    dataTable3 = "rtx_themepark:Bumper:BumperEnd"

    function func2()
        local index, condition, strValue3, strValue, playerPed, strValue4
        index = source
        condition = bumperhandler
        condition = condition.bumperplayers
        condition = condition[index]
        if nil ~= condition then
            condition = bumperhandler
            strValue3 = bumperhandler
            strValue3 = strValue3.currentplayers
            strValue3 = strValue3 - 1
            condition.currentplayers = strValue3
            condition = TriggerClientEvent
            strValue3 = "rtx_themepark:Bumper:BumperEndClient"
            strValue = -1
            playerPed = index
            condition(strValue3, strValue, playerPed)
            condition = TriggerClientEvent
            strValue3 = "rtx_themepark:Notify"
            strValue = index
            playerPed = Language
            strValue4 = Config
            strValue4 = strValue4.Language
            playerPed = playerPed[strValue4]
            playerPed = playerPed.bumperridend
            condition(strValue3, strValue, playerPed)
            condition = bumperhandler
            condition = condition.bumperplayers
            condition[index] = nil
            condition = bumperhandler
            condition = condition.currentplayers
            if 0 == condition then
                condition = TriggerClientEvent
                strValue3 = "rtx_themepark:Global:MusicStopAttraction"
                strValue = -1
                playerPed = "bumpercars"
                condition(strValue3, strValue, playerPed)
            end
        end
    end
    dataTable(dataTable3, func2)
else
    dataTable = RegisterServerEvent
    dataTable3 = "rtx_themepark:Bumper:BumperEnd"
    dataTable(dataTable3)
    dataTable = AddEventHandler
    dataTable3 = "rtx_themepark:Bumper:BumperEnd"

    function func2()
        local index, condition, strValue3, strValue, playerPed, strValue4
        index = source
        condition = bumperhandler
        condition = condition.bumperplayers
        condition = condition[index]
        if nil ~= condition then
            condition = DoesEntityExist
            strValue3 = bumperhandler
            strValue3 = strValue3.bumperplayers
            strValue3 = strValue3[index]
            strValue3 = strValue3.vehiclehandler
            condition = condition(strValue3)
            if condition then
                condition = DeleteEntity
                strValue3 = bumperhandler
                strValue3 = strValue3.bumperplayers
                strValue3 = strValue3[index]
                strValue3 = strValue3.vehiclehandler
                condition(strValue3)
            end
            condition = bumperhandler
            strValue3 = bumperhandler
            strValue3 = strValue3.currentplayers
            strValue3 = strValue3 - 1
            condition.currentplayers = strValue3
            condition = TriggerClientEvent
            strValue3 = "rtx_themepark:Bumper:BumperEndClient"
            strValue = -1
            playerPed = index
            condition(strValue3, strValue, playerPed)
            condition = TriggerClientEvent
            strValue3 = "rtx_themepark:Notify"
            strValue = index
            playerPed = Language
            strValue4 = Config
            strValue4 = strValue4.Language
            playerPed = playerPed[strValue4]
            playerPed = playerPed.bumperridend
            condition(strValue3, strValue, playerPed)
            condition = bumperhandler
            condition = condition.bumperplayers
            condition[index] = nil
            condition = bumperhandler
            condition = condition.currentplayers
            if 0 == condition then
                condition = TriggerClientEvent
                strValue3 = "rtx_themepark:Global:MusicStopAttraction"
                strValue = -1
                playerPed = "bumpercars"
                condition(strValue3, strValue, playerPed)
            end
        end
    end
    dataTable(dataTable3, func2)
end
dataTable = RegisterServerEvent
dataTable3 = "rtx_themepark:Bumper:BumperSeatEnd"
dataTable(dataTable3)
dataTable = AddEventHandler
dataTable3 = "rtx_themepark:Bumper:BumperSeatEnd"

function func2(A0_2)
    local condition, strValue3, strValue, playerPed, strValue4, dataTable2, counter, strValue5, strValue2, value, func, isEnabled, isDisabled2, tableData2
    condition = source
    strValue3 = bumperhandler
    strValue3 = strValue3.bumperplayers
    strValue3 = strValue3[A0_2]
    if nil ~= strValue3 then
        strValue3 = bumperhandler
        strValue3 = strValue3.bumperplayers
        strValue3 = strValue3[A0_2]
        strValue3 = strValue3.seattakenid
        if strValue3 == condition then
            strValue3 = pairs
            strValue = playsersinthemepark
            strValue3, strValue, playerPed, strValue4 = strValue3(strValue)
            for dataTable2, counter in strValue3, strValue, playerPed, strValue4 do
                strValue5 = TriggerClientEvent
                strValue2 = "rtx_themepark:Bumper:SynchronizeBumperSeat"
                value = counter
                func = A0_2
                isEnabled = false
                isDisabled2 = nil
                tableData2 = bumperhandler
                tableData2 = tableData2.bumperplayers
                tableData2 = tableData2[A0_2]
                tableData2 = tableData2.bumpercolor
                strValue5(strValue2, value, func, isEnabled, isDisabled2, tableData2)
            end
            strValue3 = TriggerClientEvent
            strValue = "rtx_themepark:Bumper:SeatStop"
            playerPed = condition
            strValue3(strValue, playerPed)
            strValue3 = bumperhandler
            strValue3 = strValue3.bumperplayers
            strValue3 = strValue3[A0_2]
            strValue3.seattaken = false
            strValue3 = bumperhandler
            strValue3 = strValue3.bumperplayers
            strValue3 = strValue3[A0_2]
            strValue3.seattakenid = nil
        end
    end
end
dataTable(dataTable3, func2)
dataTable = RegisterServerEvent
dataTable3 = "rtx_themepark:Bumper:BumperSeatStart"
dataTable(dataTable3)
dataTable = AddEventHandler
dataTable3 = "rtx_themepark:Bumper:BumperSeatStart"

function func2(A0_2)
    local condition, strValue3, strValue, playerPed, strValue4, dataTable2, counter, strValue5, strValue2, value, func, isEnabled, isDisabled2, tableData2
    condition = source
    strValue3 = bumperhandler
    strValue3 = strValue3.bumperplayers
    strValue3 = strValue3[A0_2]
    if nil ~= strValue3 then
        strValue3 = bumperhandler
        strValue3 = strValue3.bumperplayers
        strValue3 = strValue3[A0_2]
        strValue3 = strValue3.seattakenid
        if nil == strValue3 then
            strValue3 = pairs
            strValue = playsersinthemepark
            strValue3, strValue, playerPed, strValue4 = strValue3(strValue)
            for dataTable2, counter in strValue3, strValue, playerPed, strValue4 do
                strValue5 = TriggerClientEvent
                strValue2 = "rtx_themepark:Bumper:SynchronizeBumperSeat"
                value = counter
                func = A0_2
                isEnabled = true
                isDisabled2 = condition
                tableData2 = bumperhandler
                tableData2 = tableData2.bumperplayers
                tableData2 = tableData2[A0_2]
                tableData2 = tableData2.bumpercolor
                strValue5(strValue2, value, func, isEnabled, isDisabled2, tableData2)
            end
            strValue3 = TriggerClientEvent
            strValue = "rtx_themepark:Bumper:SeatStart"
            playerPed = condition
            strValue4 = A0_2
            strValue3(strValue, playerPed, strValue4)
            strValue3 = bumperhandler
            strValue3 = strValue3.bumperplayers
            strValue3 = strValue3[A0_2]
            strValue3.seattaken = true
            strValue3 = bumperhandler
            strValue3 = strValue3.bumperplayers
            strValue3 = strValue3[A0_2]
            strValue3.seattakenid = condition
        end
    end
end
dataTable(dataTable3, func2)