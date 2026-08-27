
local dataTable, strValue, func
dataTable = {}
dataTable.started = false
cannonhandler = dataTable
dataTable = GlobalState
dataTable["attraction18 - phase"] = 0
dataTable = GlobalState
dataTable["attraction18 - playerid"] = nil
cannontaken = false

function dataTable(A0_2)
    local tableData, strValue2, var2, isEnabled
    tableData = cannonhandler
    tableData = tableData.started
    if true == tableData then
        tableData = cannontaken
        if true == tableData then
            tableData = GlobalState
            tableData["attraction18 - phase"] = 1
            tableData = GlobalState
            tableData["attraction18 - playerid"] = A0_2
            tableData = Citizen
            tableData = tableData.Wait
            strValue2 = 500
            tableData(strValue2)
            tableData = TriggerClientEvent
            strValue2 = "rtx_themepark:Cannon:PrepareBoom"
            var2 = A0_2
            tableData(strValue2, var2)
            tableData = Citizen
            tableData = tableData.Wait
            strValue2 = 5000
            tableData(strValue2)
            tableData = TriggerClientEvent
            strValue2 = "rtx_themepark:Cannon:StartBoom"
            var2 = -1
            tableData(strValue2, var2)
            tableData = Citizen
            tableData = tableData.Wait
            strValue2 = 5000
            tableData(strValue2)
            tableData = cannonhandler
            tableData.started = false
            cannontaken = false
            tableData = GlobalState
            tableData["attraction18 - phase"] = 0
            tableData = GlobalState
            tableData["attraction18 - playerid"] = nil
            tableData = TriggerClientEvent
            strValue2 = "rtx_themepark:Global:AttractionUsing"
            var2 = A0_2
            isEnabled = false
            tableData(strValue2, var2, isEnabled)
        end
    end
end
StartCannon = dataTable
dataTable = RegisterServerEvent
strValue = "rtx_themepark:Cannon:SeatUse"
dataTable(strValue)
dataTable = AddEventHandler
strValue = "rtx_themepark:Cannon:SeatUse"

function func()
    local var22, tableData, strValue2, var2, isEnabled, isDisabled
    var22 = source
    tableData = themeparkattractionsopenstatus
    tableData = tableData[19]
    if true == tableData then
        tableData = themeparkdisabled
        if false == tableData then
            tableData = cannontaken
            if false == tableData then
                tableData = cannonhandler
                tableData = tableData.started
                if false == tableData then
                    tableData = cannonhandler
                    tableData = tableData.started
                    if false == tableData then
                        cannontaken = true
                        tableData = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:AttractionUsing"
                        var2 = var22
                        isEnabled = true
                        tableData(strValue2, var2, isEnabled)
                        tableData = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:TicketHandler"
                        var2 = var22
                        isEnabled = 18
                        isDisabled = false
                        tableData(strValue2, var2, isEnabled, isDisabled)
                        tableData = Config
                        tableData = tableData.ThemeParkControlAttractions
                        if false == tableData then
                            tableData = cannonhandler
                            tableData.started = true
                            tableData = StartCannon
                            strValue2 = var22
                            tableData(strValue2)
                        else
                            tableData = GlobalState
                            tableData["attraction18 - playerid"] = var22
                        end
                    end
                end
            end
        end
    else
        tableData = TriggerClientEvent
        strValue2 = "rtx_themepark:Notify"
        var2 = var22
        isEnabled = Language
        isDisabled = Config
        isDisabled = isDisabled.Language
        isEnabled = isEnabled[isDisabled]
        isEnabled = isEnabled.attractionclosed
        tableData(strValue2, var2, isEnabled)
    end
end
dataTable(strValue, func)