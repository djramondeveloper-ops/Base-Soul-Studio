
local dataTable2, dataTable, dataTable3
dataTable2 = {}
dataTable = {}
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable[1] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable[2] = dataTable3
dataTable3 = {}
dataTable3.taken = false
dataTable3.takenplayerid = nil
dataTable[3] = dataTable3
dataTable2.shooters = dataTable
shooterhandler = dataTable2
dataTable2 = RegisterServerEvent
dataTable = "rtx_themepark:Shooter:Start"
dataTable2(dataTable)
dataTable2 = AddEventHandler
dataTable = "rtx_themepark:Shooter:Start"

function dataTable3(A0_2)
    local var2, index, tableData, strValue2, strValue, tableData2, isEnabled, isEnabled2
    var2 = source
    index = 5
    if 2 == A0_2 then
        index = 4
    end
    tableData = themeparkattractionsopenstatus
    tableData = tableData[index]
    if true == tableData then
        tableData = themeparkdisabled
        if false == tableData then
            tableData = attractionlockdown
            if false == tableData then
                tableData = shooterhandler
                tableData = tableData.shooters
                tableData = tableData[A0_2]
                strValue2 = tableData.taken
                if false == strValue2 then
                    tableData.taken = true
                    tableData.takenplayerid = var2
                    strValue2 = TriggerClientEvent
                    strValue = "rtx_themepark:Shooter:SynchronizeShooter"
                    tableData2 = -1
                    isEnabled = A0_2
                    isEnabled2 = true
                    strValue2(strValue, tableData2, isEnabled, isEnabled2)
                    strValue2 = TriggerClientEvent
                    strValue = "rtx_themepark:Shooter:StartClient"
                    tableData2 = var2
                    isEnabled = A0_2
                    strValue2(strValue, tableData2, isEnabled)
                    strValue2 = TriggerClientEvent
                    strValue = "rtx_themepark:Global:AttractionUsing"
                    tableData2 = var2
                    isEnabled = true
                    strValue2(strValue, tableData2, isEnabled)
                    strValue2 = TriggerClientEvent
                    strValue = "rtx_themepark:Global:TicketHandler"
                    tableData2 = var2
                    isEnabled = 8
                    isEnabled2 = false
                    strValue2(strValue, tableData2, isEnabled, isEnabled2)
                end
            end
        end
    else
        tableData = TriggerClientEvent
        strValue2 = "rtx_themepark:Notify"
        strValue = var2
        tableData2 = Language
        isEnabled = Config
        isEnabled = isEnabled.Language
        tableData2 = tableData2[isEnabled]
        tableData2 = tableData2.attractionclosed
        tableData(strValue2, strValue, tableData2)
    end
end
dataTable2(dataTable, dataTable3)
dataTable2 = RegisterServerEvent
dataTable = "rtx_themepark:Shooter:End"
dataTable2(dataTable)
dataTable2 = AddEventHandler
dataTable = "rtx_themepark:Shooter:End"

function dataTable3(A0_2, A1_2)
    local index, tableData, strValue2, strValue, tableData2, isEnabled, isEnabled2, var22, key, value, var23
    index = source
    tableData = shooterhandler
    tableData = tableData.shooters
    tableData = tableData[A0_2]
    strValue2 = tableData.taken
    if true == strValue2 then
        strValue2 = tableData.takenplayerid
        if strValue2 == index then
            tableData.taken = false
            tableData.takenplayerid = nil
            strValue2 = TriggerClientEvent
            strValue = "rtx_themepark:Shooter:SynchronizeShooter"
            tableData2 = -1
            isEnabled = A0_2
            isEnabled2 = false
            strValue2(strValue, tableData2, isEnabled, isEnabled2)
            strValue2 = TriggerClientEvent
            strValue = "rtx_themepark:Global:AttractionUsing"
            tableData2 = index
            isEnabled = false
            strValue2(strValue, tableData2, isEnabled)
            strValue2 = Config
            strValue2 = strValue2.ShootingRangePrizes
            strValue2 = strValue2[1]
            strValue2 = strValue2.minimumscore
            if A1_2 >= strValue2 then
                strValue = 1
                tableData2 = ipairs
                isEnabled = Config
                isEnabled = isEnabled.ShootingRangePrizes
                tableData2, isEnabled, isEnabled2, var22 = tableData2(isEnabled)
                for key, value in tableData2, isEnabled, isEnabled2, var22 do
                    var23 = value.minimumscore
                    if A1_2 >= var23 then
                        strValue = key
                    end
                end
                tableData2 = GiveShootingRangeRewardToPlayer
                isEnabled = index
                isEnabled2 = strValue
                tableData2(isEnabled, isEnabled2)
            end
        end
    end
end
dataTable2(dataTable, dataTable3)