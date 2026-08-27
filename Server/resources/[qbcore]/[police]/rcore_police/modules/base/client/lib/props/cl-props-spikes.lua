-- =====================================================
--  rcore_police · modules/base/client/lib/props/cl-props-spikes.lua
--  Engineered by Eazy Fxap
--  Original: 189 lines → Cleaned: 60 lines
-- =====================================================

function Props.RequestSpikes(model)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local modelData = Config.Props.ModelDataByPropType[PROP_TYPES.SPIKES]
    local forwardVector = GetEntityForwardVector(ped) * 2
    local targetCoords = coords + forwardVector
    
    ObjectPlacer.startPlace(model, function(pos, entity, heading)
        if not pos or not heading then
            IsPropSessionActive = false
            return
        end
        
        if not IsPropSessionActive then return end
        
        if Config.Props.PG.EnableWhenDeploying then
            CancellableProgress(Config.Props.PG.Time * 1000, _U("PROPS.PLACING_OBJECT", modelData.label or ""), "amb@prop_human_bum_bin@idle_b", "idle_d", 1, function()
                TriggerServerEvent("rcore_police:server:deployProp", { heading = heading, pos = pos, type = PROP_TYPES.SPIKES })
                ClearPedTasksImmediately(ped)
                IsPropSessionActive = false
            end, function()
                TriggerServerEvent("rcore_police:server:unregisterDeploy")
                IsPropSessionActive = false
            end, {
                previewObject = true,
                previewSettings = { model = model, pos = pos, heading = heading, fadeType = "fadeIn" }
            })
        else
            UtilsService.LoadAnimationDict("amb@prop_human_bum_bin@idle_b")
            TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, -8.0, -1, 49, 0, false, false, false)
            Wait(1000)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent("rcore_police:server:deployProp", { heading = heading, pos = pos, type = PROP_TYPES.SPIKES })
            IsPropSessionActive = false
        end
    end, function()
        IsPropSessionActive = false
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
        Framework.sendNotification(_U("PROPS.CANCELING_PLACING", modelData.label or ""), "success")
    end, function(reason)
        IsPropSessionActive = false
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
        Framework.sendNotification(_U("PROPS.FAILED_PLACING", modelData.label or ""), "error")
    end, true, nil, { coords = targetCoords, distance = Config.Props.PlaceEditorCheckDistance })
end
