-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-props.lua
--  Engineered by Eazy Fxap
--  Original: 786 lines → Cleaned: 240 lines
-- =====================================================

local PropsPool = {}

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if PropsPool and next(PropsPool) then
            for id, propData in pairs(PropsPool) do
                local zone = propData.zone
                if zone then
                    if zone.speedRoadNode then RemoveSpeedZone(zone.speedRoadNode) end
                    
                    local pCoords = zone.getPosition()
                    local dist = #(pCoords - GetEntityCoords(PlayerPedId()))
                    if dist <= 10.0 then
                        UI.HelpKeys(nil, false)
                    end
                    
                    if zone.collisionEntity and DoesEntityExist(zone.collisionEntity) then
                        DeleteEntity(zone.collisionEntity)
                        zone.collisionEntity = nil
                    end
                    
                    local data = zone.getPropZoneData()
                    if data and data.type == PROP_TYPES.WHEEL_CLAMP then
                        local veh = NetToVeh(data.vehNetId)
                        if DoesEntityExist(veh) then
                            WheelClampDespawn(veh)
                        end
                    end
                    
                    zone.destroy()
                    zone.unloadObject()
                end
                
                if propData.blip and DoesBlipExist(propData.blip) then
                    RemoveBlip(propData.blip)
                end
            end
        end
    end
end)

RegisterNetEvent("rcore_police:client:syncObjectPool", function(id, data)
    if data then
        RegisterPropIntoDynamicPool(id, data)
    else
        local propData = PropsPool[id]
        if propData then
            local zone = propData.zone
            if zone then
                local dist = #(zone.getPosition() - GetEntityCoords(PlayerPedId()))
                if dist <= 10.0 then
                    UI.HelpKeys(nil, false)
                end
                
                if zone.collisionEntity and DoesEntityExist(zone.collisionEntity) then
                    DeleteEntity(zone.collisionEntity)
                    zone.collisionEntity = nil
                end
                
                if zone.speedRoadNode then RemoveSpeedZone(zone.speedRoadNode) end
                
                local data = zone.getPropZoneData()
                if data and data.type == PROP_TYPES.WHEEL_CLAMP then
                    local veh = NetToVeh(data.vehNetId)
                    if DoesEntityExist(veh) then
                        WheelClampDespawn(veh)
                    end
                end
                
                zone.destroy()
                zone.unloadObject()
            end
            
            if propData.blip and DoesBlipExist(propData.blip) then
                RemoveBlip(propData.blip)
            end
            PropsPool[id] = nil
        end
    end
end)

NetworkService.RegisterNetEvent("RenderVehicleFlash", function(success, id)
    if success then
        local propData = PropsPool[id]
        if propData and propData.zone then
            Sounds.PlaySpeedCamera()
            fadeInFlashlight(propData.zone.getPosition(), propData.zone.getCameraForwardVector(), 0.5)
        end
    end
end)

NetworkService.RegisterNetEvent("SyncObjectPoolForUser", function(success, data)
    if success and data then
        dbg.debug("Syncing object pool, since new user loaded.")
        for id, propData in pairs(data) do
            RegisterPropIntoDynamicPool(id, propData)
        end
    end
end)

NetworkService.RegisterNetEvent("StartRemovingPropTask", function(success, id, propType)
    if success then
        local propData = PropsPool[id]
        local modelData = Config.Props.ModelDataByPropType[propType]
        local animDict = "amb@prop_human_bum_bin@idle_b"
        local animName = "idle_d"
        
        if propType == PROP_TYPES.WHEEL_CLAMP then
            animDict = "weapon@w_sp_jerrycan"
            animName = "discard_crouch"
        end
        
        local ped = PlayerPedId()
        MakePedIgnoreHitFromOtherPlayer(ped, true)
        
        if Config.Props.PG.EnableWhenPicking then
            CancellableProgress(
                Config.Props.PG.Time * 1000, 
                _U("PROPS.PICKING_UP_PROP", modelData.label or ""), 
                animDict, animName, 1, 
                function()
                    MakePedIgnoreHitFromOtherPlayer(ped, false)
                    TriggerServerEvent("rcore_police:server:removePropDeploy", id, propType)
                end, 
                function()
                    MakePedIgnoreHitFromOtherPlayer(ped, false)
                    TriggerServerEvent("rcore_police:server:resetPropDeployState", id)
                    if propData.zone.entity and DoesEntityExist(propData.zone.entity) then
                        UtilsService.StopCurrentFade()
                        SetEntityAlpha(propData.zone.entity, 255, false)
                    end
                end, 
                { previewObject = true, previewSettings = { entity = propData.zone.entity, fadeType = "fadeOut" } }
            )
        else
            MakePedIgnoreHitFromOtherPlayer(ped, false)
            TriggerServerEvent("rcore_police:server:removePropDeploy", id, propType)
        end
    end
end)

function RegisterPropIntoDynamicPool(id, data)
    local pType = data.type
    local heading = data.heading
    local createBlip = data.blip
    local maxSpeed = data.maxSpeedZone or Config.Props.SpeedCamera.DefaultMaxSpeed
    local modelData = Config.Props.ModelDataByPropType[pType]
    
    if not modelData then return dbg.info("Failure") end
    
    local propModel = modelData.prop
    if not propModel then return end
    
    local pos = vec3(data.pos.x, data.pos.y, data.pos.z)
    local zoneIdStr = string.format("%s_%s", pType, id)
    local zone = createMarker()
    
    PropsPool[id] = { zone = zone, data = data }
    
    if Framework.job and Framework.job.name then
        zone.setDepartmentOwner(Framework.job.name)
    end
    
    zone.setPosition(pos)
    zone.setPropZone(true)
    zone.setPropLodDistance(Config.Props.LodDistance)
    
    zone.setPropZoneData({
        model = propModel,
        heading = heading,
        id = zoneIdStr,
        type = pType,
        wheelBone = data.wheelBone,
        vehNetId = data.vehNetId
    })
    
    zone.registerKey(function(key)
        if not PropsPool[id] then return end
        local success, err = pcall(zone.onKey, key)
        if not success then dbg.debug("Error in onKey: %s", err) end
    end, zoneIdStr, "Activate Marker", "E", nil)
    
    zone.onKey = function()
        local restrict = Config.Props.DespawnOnlyForDepartmentGroups
        if restrict and Framework.job and GetDepartmentConfig(Framework.job.name) then
            restrict = false
        end
        if restrict then return end
        
        UI.HelpKeys(nil, false)
        TriggerServerEvent("rcore_police:server:requestRemoveProp", id, pType)
    end
    
    zone.onEnter = function()
        GlobalZoneId = zone.getId()
        local restrict = Config.Props.DespawnOnlyForDepartmentGroups
        if restrict and Framework.job and GetDepartmentConfig(Framework.job.name) then
            restrict = false
        end
        
        if not IsPedInAnyVehicle(PlayerPedId(), false) and not restrict then
            UI.HelpKeys({
                keys = {
                    { key = Config.InteractZone, label = _U("PROPS.HELP_TEXT") }
                }
            }, true)
        end
        
        if modelData.action == ZONE_ACTIONS.DESTROY_VEHICLE_TYRES then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                if DoesEntityExist(veh) then
                    dbg.debug("Destroying vehicle tyres")
                    for i = 0, 7 do
                        if not IsVehicleTyreBurst(veh, i, true) then
                            SetVehicleTyreBurst(veh, i, true, 1000)
                        end
                    end
                end
            end
        end
    end
    
    zone.onLeave = function()
        GlobalZoneId = nil
        UI.HelpKeys(nil, false)
    end
    
    if modelData.action == ZONE_ACTIONS.DESTROY_VEHICLE_TYRES then
        dbg.debug("Props: Setting zone radius for spikes, adjusted range.")
        zone.setInRadius(Config.Props.SpikesRange or 1.5)
    end
    
    if modelData.action == ZONE_ACTIONS.BLOCK_VEHICLE_MOVEMENT then
        zone.setInRadius(Config.Props.DistanceBetweenWheelClamp or 1.0)
    end
    
    if modelData.action == ZONE_ACTIONS.CHECK_VEHICLE_SPEED then
        zone.setCameraZone(heading, maxSpeed)
        zone.onEnterSpeedCamera = function()
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            local speed = getVehicleSpeed(GetEntitySpeed(veh))
            if speed >= zone.getCameraZoneSpeed() then
                TriggerServerEvent("rcore_police:server:requestSpeedCameraFine", id, VehToNet(veh))
            end
        end
        zone.onLeaveSpeedCamera = function() end
    end
    
    if createBlip then
        dbg.debug("Creating blip for camera at vec3 -> %s %s %s", pos.x, pos.y, pos.z)
        PropsPool[id].createBlip = true
        PropsPool[id].blip = Utils.CreateBlipAtCoords({
            sprite = Config.Props.SpeedCamera.Blip.Sprite,
            color = Config.Props.SpeedCamera.Blip.Color or 1,
            display = 4,
            scale = Config.Props.SpeedCamera.Blip.Scale,
            shortRange = false,
            name = Config.Props.SpeedCamera.Blip.Label,
            pos = pos
        })
    end
    
    zone.setId(zoneIdStr)
    zone.render()
end
