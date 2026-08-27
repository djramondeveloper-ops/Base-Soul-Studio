
local condition, coords, var12, var13, func2, strValue, tableData, strValue2, var1
condition = IsDuplicityVersion
condition = condition()
if condition then
    condition = GetPlayerPositionInRealTime86
    condition()
end
condition = nil
coords = vector3
var12 = -1648.38
var13 = -1195.84
func2 = 14.2
coords = coords(var12, var13, func2)
var12 = nil
var13 = 1
func2 = RegisterNetEvent
strValue = "rtx_themepark:Cannon:PrepareBoom"
func2(strValue)
func2 = AddEventHandler
strValue = "rtx_themepark:Cannon:PrepareBoom"

function tableData()
    local isEnabled15, serverId2, entityCoords, serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9, var22, isEnabled11
    isEnabled15 = GlobalState
    isEnabled15 = isEnabled15["attraction18 - phase"]
    if 1 == isEnabled15 then
        isEnabled15 = GlobalState
        isEnabled15 = isEnabled15["attraction18 - playerid"]
        serverId2 = GetPlayerServerId
        entityCoords = PlayerId
        entityCoords, serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9, var22, isEnabled11 = entityCoords()
        serverId2 = serverId2(entityCoords, serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9, var22, isEnabled11)
        if isEnabled15 == serverId2 then
            isEnabled15 = PlayerPedId
            isEnabled15 = isEnabled15()
            serverId2 = vector3
            entityCoords = -1647.68
            serverId = -1195.15
            isEnabled2 = 15.1
            serverId2 = serverId2(entityCoords, serverId, isEnabled2)
            entityCoords = GetFollowPedCamViewMode
            entityCoords = entityCoords()
            var13 = entityCoords
            entityCoords = SetEntityCoordsNoOffset
            serverId = isEnabled15
            isEnabled2 = serverId2.x
            dataTable2 = serverId2.y
            dataTable = serverId2.z
            entityCoords(serverId, isEnabled2, dataTable2, dataTable)
            boomactivated = true
            entityCoords = GetHashKey
            serverId = "prop_golf_ball"
            entityCoords = entityCoords(serverId)
            serverId = RequestModel
            isEnabled2 = entityCoords
            serverId(isEnabled2)
            while true do
                serverId = HasModelLoaded
                isEnabled2 = entityCoords
                serverId = serverId(isEnabled2)
                if serverId then
                    break
                end
                serverId = RequestModel
                isEnabled2 = entityCoords
                serverId(isEnabled2)
                serverId = Citizen
                serverId = serverId.Wait
                isEnabled2 = 5
                serverId(isEnabled2)
            end
            serverId = DoesEntityExist
            isEnabled2 = condition
            serverId = serverId(isEnabled2)
            if serverId then
                serverId = DeleteEntity
                isEnabled2 = condition
                serverId(isEnabled2)
            end
            serverId = CreateObjectNoOffset
            isEnabled2 = entityCoords
            dataTable2 = serverId2.x
            dataTable = serverId2.y
            isEnabled13 = serverId2.z
            isEnabled16 = true
            isEnabled = true
            isEnabled10 = true
            serverId = serverId(isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10)
            condition = serverId
            serverId = SetEntityProofs
            isEnabled2 = condition
            dataTable2 = true
            dataTable = true
            isEnabled13 = true
            isEnabled16 = true
            isEnabled = true
            isEnabled10 = true
            isEnabled8 = true
            isEnabled14 = true
            serverId(isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14)
            serverId = SetEntityRotation
            isEnabled2 = condition
            dataTable2 = 0.0
            dataTable = 0.0
            isEnabled13 = 140.0
            serverId(isEnabled2, dataTable2, dataTable, isEnabled13)
            serverId = NetworkAllowLocalEntityAttachment
            isEnabled2 = condition
            dataTable2 = true
            serverId(isEnabled2, dataTable2)
            serverId = FreezeEntityPosition
            isEnabled2 = condition
            dataTable2 = true
            serverId(isEnabled2, dataTable2)
            serverId = SetEntityVisible
            isEnabled2 = condition
            dataTable2 = false
            serverId(isEnabled2, dataTable2)
            serverId = SetEntityHeading
            isEnabled2 = condition
            dataTable2 = 142.0
            serverId(isEnabled2, dataTable2)
            serverId = AttachEntityToEntity
            isEnabled2 = PlayerPedId
            isEnabled2 = isEnabled2()
            dataTable2 = condition
            dataTable = 0
            isEnabled13 = -0.025
            isEnabled16 = -1.0
            isEnabled = 0.35
            isEnabled10 = 20.0
            isEnabled8 = 0.0
            isEnabled14 = 0.0
            isDisabled3 = false
            isDisabled = false
            isEnabled4 = true
            isEnabled9 = true
            var22 = 2
            isEnabled11 = true
            serverId(isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9, var22, isEnabled11)
            serverId = "rtx_djn_themepark_canon_char"
            isEnabled2 = "rtx_djn_themepark_canon_char_anim"
            while true do
                dataTable2 = HasAnimDictLoaded
                dataTable = serverId
                dataTable2 = dataTable2(dataTable)
                if dataTable2 then
                    break
                end
                dataTable2 = RequestAnimDict
                dataTable = serverId
                dataTable2(dataTable)
                dataTable2 = Citizen
                dataTable2 = dataTable2.Wait
                dataTable = 5
                dataTable2(dataTable)
            end
            dataTable2 = TaskPlayAnim
            dataTable = isEnabled15
            isEnabled13 = serverId
            isEnabled16 = isEnabled2
            isEnabled = 8.0
            isEnabled10 = 8.0
            isEnabled8 = -1
            isEnabled14 = 1
            isDisabled3 = 0
            isDisabled = 0
            isEnabled4 = 0
            isEnabled9 = 0
            dataTable2(dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9)
            dataTable2 = SetFollowPedCamViewMode
            dataTable = 4
            dataTable2(dataTable)
        end
    end
end
func2(strValue, tableData)
func2 = RegisterNetEvent
strValue = "rtx_themepark:Cannon:StartBoom"
func2(strValue)
func2 = AddEventHandler
strValue = "rtx_themepark:Cannon:StartBoom"

function tableData()
    local isEnabled15, serverId2, entityCoords, serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9, var22, isEnabled11, func3, func, var23, var25, var24, var2, counter6, counter, counter4, counter5, counter7, isEnabled6, isEnabled12, isEnabled5, isEnabled7, isEnabled3
    isEnabled15 = GlobalState
    isEnabled15 = isEnabled15["attraction18 - phase"]
    if 1 == isEnabled15 then
        isEnabled15 = PlayerPedId
        isEnabled15 = isEnabled15()
        serverId2 = vector3
        entityCoords = -1647.68
        serverId = -1195.15
        isEnabled2 = 15.1
        serverId2 = serverId2(entityCoords, serverId, isEnabled2)
        entityCoords = Config
        entityCoords = entityCoords.AttractionsSettings
        entityCoords = entityCoords.cannon
        entityCoords = entityCoords.disableexplosion
        if false == entityCoords then
            entityCoords = AddExplosion
            serverId = serverId2.x
            isEnabled2 = serverId2.y
            dataTable2 = serverId2.z
            dataTable = 5
            isEnabled13 = 0.0
            isEnabled16 = true
            isEnabled = true
            isEnabled10 = 0.0
            isEnabled8 = false
            isEnabled14 = false
            entityCoords(serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14)
        end
        entityCoords = HasNamedPtfxAssetLoaded
        serverId = "scr_indep_fireworks"
        entityCoords = entityCoords(serverId)
        if not entityCoords then
            entityCoords = RequestNamedPtfxAsset
            serverId = "scr_indep_fireworks"
            entityCoords(serverId)
            while true do
                entityCoords = HasNamedPtfxAssetLoaded
                serverId = "scr_indep_fireworks"
                entityCoords = entityCoords(serverId)
                if entityCoords then
                    break
                end
                entityCoords = Wait
                serverId = 10
                entityCoords(serverId)
            end
        end
        entityCoords = UseParticleFxAssetNextCall
        serverId = "scr_indep_fireworks"
        entityCoords(serverId)
        entityCoords = SetParticleFxNonLoopedColour
        serverId = 0.0
        isEnabled2 = 0.0
        dataTable2 = 0.0
        entityCoords(serverId, isEnabled2, dataTable2)
        entityCoords = StartNetworkedParticleFxNonLoopedAtCoord
        serverId = "scr_indep_firework_burst_spawn"
        isEnabled2 = serverId2
        dataTable2 = 0.0
        dataTable = 0.0
        isEnabled13 = 0.0
        isEnabled16 = 0.5
        isEnabled = false
        isEnabled10 = false
        isEnabled8 = false
        isEnabled14 = false
        entityCoords(serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14)
        entityCoords = RemoveNamedPtfxAsset
        serverId = "scr_indep_fireworks"
        entityCoords(serverId)
        entityCoords = GlobalState
        entityCoords = entityCoords["attraction18 - playerid"]
        serverId = GetPlayerServerId
        isEnabled2 = PlayerId
        isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9, var22, isEnabled11, func3, func, var23, var25, var24, var2, counter6, counter, counter4, counter5, counter7, isEnabled6, isEnabled12, isEnabled5, isEnabled7, isEnabled3 = isEnabled2()
        serverId = serverId(isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8, isEnabled14, isDisabled3, isDisabled, isEnabled4, isEnabled9, var22, isEnabled11, func3, func, var23, var25, var24, var2, counter6, counter, counter4, counter5, counter7, isEnabled6, isEnabled12, isEnabled5, isEnabled7, isEnabled3)
        if entityCoords == serverId then
            entityCoords = SetFollowPedCamViewMode
            serverId = 4
            entityCoords(serverId)
            entityCoords = FreezeEntityPosition
            serverId = condition
            isEnabled2 = false
            entityCoords(serverId, isEnabled2)
            entityCoords = SetEntityVisible
            serverId = isEnabled15
            isEnabled2 = true
            entityCoords(serverId, isEnabled2)
            entityCoords = SetEntityDynamic
            serverId = condition
            isEnabled2 = true
            entityCoords(serverId, isEnabled2)
            entityCoords = SetEntityProofs
            serverId = condition
            isEnabled2 = true
            dataTable2 = true
            dataTable = true
            isEnabled13 = true
            isEnabled16 = true
            isEnabled = true
            isEnabled10 = true
            isEnabled8 = true
            entityCoords(serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10, isEnabled8)
            entityCoords = -1738.98
            serverId = -1300.77
            isEnabled2 = 60.6
            dataTable2 = table
            dataTable2 = dataTable2.unpack
            dataTable = serverId2
            dataTable2, dataTable, isEnabled13 = dataTable2(dataTable)
            isEnabled16 = 800.0
            isEnabled = entityCoords - dataTable2
            isEnabled10 = serverId - dataTable
            isEnabled8 = isEnabled2 - isEnabled13
            isEnabled14 = math
            isEnabled14 = isEnabled14.sqrt
            isDisabled3 = isEnabled ^ 2
            isDisabled = isEnabled10 ^ 2
            isDisabled3 = isDisabled3 + isDisabled
            isDisabled = isEnabled8 ^ 2
            isDisabled3 = isDisabled3 + isDisabled
            isEnabled14 = isEnabled14(isDisabled3)
            isDisabled3 = isEnabled / isEnabled14
            isDisabled = isEnabled10 / isEnabled14
            isEnabled4 = isEnabled8 / isEnabled14
            isEnabled9 = isDisabled3 * isEnabled16
            var22 = isDisabled * isEnabled16
            isEnabled11 = isEnabled4 * isEnabled16
            func3 = ApplyForceToEntity
            func = condition
            var23 = 1
            var25 = isEnabled9
            var24 = var22
            var2 = isEnabled11
            counter6 = 0.0
            counter = 0.0
            counter4 = 0.0
            counter5 = 0
            counter7 = 0
            isEnabled6 = true
            isEnabled12 = true
            isEnabled5 = true
            isEnabled7 = true
            isEnabled3 = true
            func3(func, var23, var25, var24, var2, counter6, counter, counter4, counter5, counter7, isEnabled6, isEnabled12, isEnabled5, isEnabled7, isEnabled3)
            func3 = Citizen
            func3 = func3.CreateThread

            function func()
                local condition2, counter2, isDisabled2, counter3, var3
                while true do
                    condition2 = Citizen
                    condition2 = condition2.Wait
                    counter2 = 0
                    condition2(counter2)
                    condition2 = SetFollowPedCamViewMode
                    counter2 = var13
                    condition2(counter2)
                    condition2 = SetEntityRotation
                    counter2 = condition
                    isDisabled2 = 0.0
                    counter3 = 0.0
                    var3 = 140.0
                    condition2(counter2, isDisabled2, counter3, var3)
                    condition2 = IsEntityInWater
                    counter2 = condition
                    condition2 = condition2(counter2)
                    if condition2 then
                        condition2 = DetachEntity
                        counter2 = isEnabled15
                        condition2(counter2)
                        condition2 = DeleteEntity
                        counter2 = condition
                        condition2(counter2)
                        condition2 = FreezeEntityPosition
                        counter2 = isEnabled15
                        isDisabled2 = false
                        condition2(counter2, isDisabled2)
                        condition2 = ClearPedTasks
                        counter2 = isEnabled15
                        condition2(counter2)
                        break
                    end
                end
            end
            func3(func)
        end
    end
end
func2(strValue, tableData)
func2 = Config
func2 = func2.Target
if true == func2 then
    func2 = RegisterNetEvent
    strValue = "rtx_themepark:Cannon:SeatUseTarget"
    func2(strValue)
    func2 = AddEventHandler
    strValue = "rtx_themepark:Cannon:SeatUseTarget"

    function tableData()
        local isEnabled15, serverId2, entityCoords
        isEnabled15 = usingattraction
        if false == isEnabled15 then
            isEnabled15 = var12
            if nil ~= isEnabled15 then
                isEnabled15 = iteminhand
                if false == isEnabled15 then
                    isEnabled15 = TriggerServerEvent
                    serverId2 = "rtx_themepark:Cannon:SeatUse"
                    isEnabled15(serverId2)
                else
                    isEnabled15 = Notify
                    serverId2 = Language
                    entityCoords = Config
                    entityCoords = entityCoords.Language
                    serverId2 = serverId2[entityCoords]
                    serverId2 = serverId2.iteminhand
                    isEnabled15(serverId2)
                end
            end
        end
    end
    func2(strValue, tableData)
end
func2 = Config
func2 = func2.AttractionsSettings
func2 = func2.cannon
func2 = func2.disable
if false == func2 then
    func2 = Citizen
    func2 = func2.CreateThread

    function strValue()
        local isEnabled15, serverId2, entityCoords, serverId, isEnabled2, dataTable2, dataTable, isEnabled13, isEnabled16, isEnabled, isEnabled10
        while true do
            isEnabled15 = Citizen
            isEnabled15 = isEnabled15.Wait
            serverId2 = 0
            isEnabled15(serverId2)
            isEnabled15 = true
            serverId2 = PlayerPedId
            serverId2 = serverId2()
            entityCoords = GetEntityCoords
            serverId = serverId2
            entityCoords = entityCoords(serverId)
            serverId = false
            isEnabled2 = GlobalState
            isEnabled2 = isEnabled2["attraction18 - phase"]
            if 0 == isEnabled2 then
                isEnabled2 = usingattraction
                if false == isEnabled2 then
                    isEnabled2 = nearbythemepark
                    if true == isEnabled2 then
                        isEnabled2 = tickets
                        isEnabled2 = isEnabled2.cannon
                        if true == isEnabled2 then
                            isEnabled2 = coords
                            isEnabled2 = entityCoords - isEnabled2
                            isEnabled2 = #isEnabled2
                            if isEnabled2 < 20.0 then
                                dataTable2 = Config
                                dataTable2 = dataTable2.AttractionsSettings
                                dataTable2 = dataTable2.cannon
                                dataTable2 = dataTable2.usedistance
                                if isEnabled2 < dataTable2 then
                                    serverId = true
                                end
                            end
                        end
                    end
                end
            end
            if serverId then
                isEnabled2 = 1
                var12 = isEnabled2
                isEnabled2 = false
                dataTable2 = usingattraction
                if false == dataTable2 then
                    isEnabled15 = false
                    dataTable2 = Config
                    dataTable2 = dataTable2.Target
                    if false == dataTable2 then
                        dataTable2 = Config
                        dataTable2 = dataTable2.ThemeParkInteractionSystem
                        if 1 == dataTable2 then
                            dataTable2 = SendNUIMessage
                            dataTable = {}
                            dataTable.message = "infonotifyshow"
                            isEnabled13 = Language
                            isEnabled16 = Config
                            isEnabled16 = isEnabled16.Language
                            isEnabled13 = isEnabled13[isEnabled16]
                            isEnabled13 = isEnabled13.pressforuseseatinteract
                            dataTable.infonotifytext = isEnabled13
                            dataTable2(dataTable)
                            isEnabled2 = true
                        else
                            dataTable2 = Config
                            dataTable2 = dataTable2.ThemeParkInteractionSystem
                            if 2 == dataTable2 then
                                dataTable2 = DrawText3D
                                dataTable = coords.x
                                isEnabled13 = coords.y
                                isEnabled16 = coords.z
                                isEnabled = Language
                                isEnabled10 = Config
                                isEnabled10 = isEnabled10.Language
                                isEnabled = isEnabled[isEnabled10]
                                isEnabled = isEnabled.pressforuseseat
                                dataTable2(dataTable, isEnabled13, isEnabled16, isEnabled)
                            else
                                dataTable2 = Config
                                dataTable2 = dataTable2.ThemeParkInteractionSystem
                                if 3 == dataTable2 then
                                    dataTable2 = ShowGtaClassicInteraction
                                    dataTable = Language
                                    isEnabled13 = Config
                                    isEnabled13 = isEnabled13.Language
                                    dataTable = dataTable[isEnabled13]
                                    dataTable = dataTable.pressforuseseatinteractclassic
                                    dataTable2(dataTable)
                                end
                            end
                        end
                    end
                end
            else
                isEnabled2 = Config
                isEnabled2 = isEnabled2.ThemeParkInteractionSystem
                if 1 == isEnabled2 then
                    isEnabled2 = var12
                    if nil ~= isEnabled2 then
                        isEnabled2 = SendNUIMessage
                        dataTable2 = {}
                        dataTable2.message = "hide"
                        isEnabled2(dataTable2)
                    end
                end
                isEnabled2 = nil
                var12 = isEnabled2
            end
            if isEnabled15 then
                isEnabled2 = Citizen
                isEnabled2 = isEnabled2.Wait
                dataTable2 = 1000
                isEnabled2(dataTable2)
            end
        end
    end
    func2(strValue)
end
func2 = Config
func2 = func2.Target
if false == func2 then
    func2 = RegisterCommand
    strValue = "usecannonseat"

    function tableData()
        local isEnabled15, serverId2, entityCoords
        isEnabled15 = usingattraction
        if false == isEnabled15 then
            isEnabled15 = var12
            if nil ~= isEnabled15 then
                isEnabled15 = iteminhand
                if false == isEnabled15 then
                    isEnabled15 = TriggerServerEvent
                    serverId2 = "rtx_themepark:Cannon:SeatUse"
                    isEnabled15(serverId2)
                else
                    isEnabled15 = Notify
                    serverId2 = Language
                    entityCoords = Config
                    entityCoords = entityCoords.Language
                    serverId2 = serverId2[entityCoords]
                    serverId2 = serverId2.iteminhand
                    isEnabled15(serverId2)
                end
            end
        end
    end
    func2(strValue, tableData)
    func2 = RegisterKeyMapping
    strValue = "usecannonseat"
    tableData = Language
    strValue2 = Config
    strValue2 = strValue2.Language
    tableData = tableData[strValue2]
    tableData = tableData.bindrollercoasterseatuse
    strValue2 = "keyboard"
    var1 = Config
    var1 = var1.ThemeParkSeatKey
    func2(strValue, tableData, strValue2, var1)
end