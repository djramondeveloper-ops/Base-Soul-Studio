-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-props.lua
--  Engineered by Eazy Fxap
--  Original: 345 lines → Cleaned: 100 lines
-- =====================================================

local PLACING_ANIM_DICT = "amb@prop_human_bum_bin@idle_b"
local PLACING_ANIM_NAME = "idle_d"

NetworkService.RegisterNetEvent("spawnProp", function(success, itemData, propType, vehicleData)
    if not success then return end
    
    if IsPropSessionActive then
        return Framework.sendNotification(_U("YOU_ARE_AREADY_IN_PLACING_MODE"), "error")
    end
    
    IsPropSessionActive = true
    
    -- Route dedicated prop handlers
    if propType == PROP_TYPES.BARRICADE then
        return Props.RequestBarricade(itemData)
    elseif propType == PROP_TYPES.SPIKES then
        return Props.RequestSpikes(itemData)
    elseif propType == PROP_TYPES.MEGA_PHONE then
        return Props.RequestMegaPhone(itemData)
    elseif propType == PROP_TYPES.PAPER_BAG then
        return Props.RequestPaperBag(itemData)
    elseif propType == PROP_TYPES.WHEEL_CLAMP then
        return Props.RequestWheelClamp(itemData)
    end
    
    -- Generic placer route
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local propModelData = Config.Props.ModelDataByPropType[propType]
    local forward = GetEntityForwardVector(ped)
    local spawnCoords = pedCoords + (forward * 2)
    
    ObjectPlacer.startPlace(itemData, function(placedCoords, _, heading)
        -- Placement cancelled or invalid
        if not placedCoords or not heading then
            IsPropSessionActive = false
            return
        end
        if not IsPropSessionActive then return end
        
        local deployData = {
            pos = placedCoords,
            heading = heading,
            type = propType
        }
        
        -- Speed radar requires extra input dialog
        if propType == PROP_TYPES.SPEED_RADAR then
            placedCoords = vec3(placedCoords.x, placedCoords.y, placedCoords.z - 0.8)
            deployData.pos = placedCoords
            
            local inputFields = {
                {
                    label = _U("CAMERA_SPEED_RADAR.INPUT_SPEED_LABEL", Config.Props.SpeedCamera.SpeedType),
                    placeholder = _U("CAMERA_SPEED_RADAR.INPUT_SPEED_PLACEHOLDER"),
                    type = "number",
                    required = true
                },
                {
                    label = _U("CAMERA_SPEED_RADAR.INPUT_FINE_LABEL"),
                    placeholder = _U("CAMERA_SPEED_RADAR.INPUT_FINE_PLACEHOLDER"),
                    type = "number",
                    required = true
                }
            }
            
            if Config.Props.SpeedCamera.BlipOption then
                table.insert(inputFields, {
                    label = _U("CAMERA_SPEED_RADAR.INPUT_BLIP_LABEL"),
                    placeholder = "-",
                    type = "checkbox",
                    required = true
                })
            end
            
            local inputResult = UI.Input(_U("CAMERA_SPEED_RADAR.TITLE"), inputFields)
            if not inputResult then return end
            
            deployData.maxSpeedZone = tonumber(inputResult[tostring(0)])
            deployData.fine = tonumber(inputResult[tostring(1)])
            deployData.blip = inputResult[tostring(2)]
        end
        
        local propLabel = propModelData and propModelData.label or ""
        
        if Config.Props.PG.EnableWhenDeploying then
            CancellableProgress(Config.Props.PG.Time * 1000, _U("PROPS.PLACING_OBJECT", propLabel), PLACING_ANIM_DICT, PLACING_ANIM_NAME, 1,
                function()
                    TriggerServerEvent("rcore_police:server:deployProp", deployData)
                    ClearPedTasksImmediately(ped)
                    IsPropSessionActive = false
                end,
                function()
                    TriggerServerEvent("rcore_police:server:unregisterDeploy")
                    IsPropSessionActive = false
                end,
                {
                    previewObject = true,
                    previewSettings = {
                        model = itemData,
                        pos = placedCoords,
                        heading = heading,
                        fadeType = "fadeIn"
                    }
                }
            )
        else
            UtilsService.LoadAnimationDict(PLACING_ANIM_DICT)
            TaskPlayAnim(ped, PLACING_ANIM_DICT, PLACING_ANIM_NAME, 8.0, -8.0, -1, 49, 0, false, false, false)
            Wait(1000)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent("rcore_police:server:deployProp", deployData)
            IsPropSessionActive = false
        end
    end,
    function()
        -- Cancel
        IsPropSessionActive = false
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
        Framework.sendNotification(_U("PROPS.CANCELING_PLACING", propModelData and propModelData.label or ""), "success")
    end,
    function(err)
        -- Error
        IsPropSessionActive = false
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
        Framework.sendNotification(_U("PROPS.FAILED_PLACING", propModelData and propModelData.label or ""), "error")
    end,
    true, nil, {
        coords = spawnCoords,
        distance = Config.Props.PlaceEditorCheckDistance
    })
end)
