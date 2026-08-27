-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-zones.lua
--  Engineered by Eazy Fxap
--  Original: 1566 lines → Cleaned: 500 lines
-- =====================================================

local ActiveZones = {}
local RenderedZones = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        for k, zone in pairs(ActiveZones) do
            if #(coords - zone.position) < 100 then
                RenderedZones[zone.id] = zone
            else
                zone.rendering = false
                RenderedZones[zone.id] = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    local waitTime = 500
    while true do
        Citizen.Wait(waitTime)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local closestDist = math.huge
        
        for id, zone in pairs(RenderedZones) do
            local dist = #(coords - zone.position)
            
            if zone.npcModel then
                if dist <= zone.npcRenderDistance then
                    zone.loadZoneNPC()
                else
                    zone.unloadZoneNPC()
                end
            end
            
            if zone.isPropZone and zone.propZoneLodDistance then
                if dist <= zone.propZoneLodDistance then
                    zone.loadObject()
                else
                    zone.unloadObject()
                end
            end
            
            if dist <= zone.renderDistance then
                if not zone.destroyed and not zone.stopRendering then
                    zone.rendering = true
                    if dist <= zone.inRadius then
                        if not zone.isIn then
                            if zone.onEnter then pcall(zone.onEnter) end
                            zone.isIn = true
                        end
                    else
                        if zone.isIn then
                            if zone.onLeave then pcall(zone.onLeave) end
                            zone.isIn = false
                        end
                    end
                    
                    if zone.coneData then
                        local veh = GetVehiclePedIsIn(ped, false)
                        if veh ~= 0 and DoesEntityExist(veh) then
                            local netId = NetworkGetNetworkIdFromEntity(veh)
                            local vehCoords = GetEntityCoords(veh)
                            local distToCone = #(vehCoords - zone.getPosition())
                            
                            if IsVehicleInCone(vehCoords, zone.position, zone.coneData.leftBoundaryEndPoint, zone.coneData.rightBoundaryEndPoint) then
                                if not zone.cachedNetIds[netId] and not zone.blockCamera then
                                    zone.cachedNetIds[netId] = true
                                    if zone.onEnterSpeedCamera then pcall(zone.onEnterSpeedCamera) end
                                end
                            elseif distToCone >= 10.0 then
                                if not zone.blockCamera and zone.cachedNetIds[netId] then
                                    zone.cachedNetIds[netId] = nil
                                    zone.blockCamera = true
                                    SetTimeout((Config.Props.SpeedCamera.CooldownForProcessingSameVehicle or 5) * 1000, function()
                                        zone.blockCamera = false
                                        dbg.debug("Camera is able to process vehicle again.")
                                    end)
                                    if zone.onLeaveSpeedCamera then pcall(zone.onLeaveSpeedCamera) end
                                end
                            end
                        end
                    end
                end
            else
                zone.rendering = false
                if dist >= zone.npcRenderDistance then zone.unloadZoneNPC() end
                if zone.isPropZone and zone.propZoneLodDistance and dist >= zone.propZoneLodDistance then
                    zone.unloadObject()
                end
            end
            
            if dist < closestDist then closestDist = dist end
        end
        
        if closestDist < 50 then waitTime = 100 else waitTime = 500 end
    end
end)

Citizen.CreateThread(function()
    local waitTime = 500
    while true do
        local isClose = false
        for _, zone in pairs(RenderedZones) do
            if zone.rendering and not zone.destroyed and zone.zoneStyleType ~= "Target" and not zone.isPropZone then
                isClose = true
                local hasAccess = Utils.HasZoneAccess(zone.getDepartmentOwner(), zone.getZoneDutyState(), zone.getZoneType())
                if hasAccess then
                    if zone.zoneStyleType == "3D" then
                        Utils.Draw3DText(zone.position.x, zone.position.y, zone.position.z, zone.zoneStyleScaleFactor, zone.zoneLabel)
                    elseif zone.zoneStyleType == "Marker" then
                        DrawMarker(zone.type, zone.position.x, zone.position.y, zone.position.z, zone.dir.x, zone.dir.y, zone.dir.z, zone.rot.x, zone.rot.y, zone.rot.z, zone.scale.x, zone.scale.y, zone.scale.z, zone.color.r, zone.color.g, zone.color.b, zone.color.a, false, false, 2, zone.rotation, nil, nil, false)
                    end
                end
            end
        end
        
        if isClose then waitTime = 0 else waitTime = 500 end
        Citizen.Wait(waitTime)
    end
end)

local function table_size(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function createMarker(resource)
    local self = {
        id = table_size(ActiveZones) + 1,
        type = Config.Marker and Config.Marker.Type or 1,
        firstUpdate = false,
        zoneType = nil,
        zoneStyleType = Config.Zones and Config.Zones.Style or "Marker",
        zoneStyleScaleFactor = Config.Zones and Config.Zones.ScaleFactor or 0.5,
        zoneLabel = "UNK",
        resource = resource,
        renderDistance = 20,
        npcRenderDistance = Config.Zones and Config.Zones.RenderDistanceNPC or 100,
        position = vector3(0,0,0),
        dir = vector3(0,0,0),
        rot = vector3(0,0,0),
        scale = Config.Marker and Config.Marker.Scale or vector3(0.5, 0.5, 0.5),
        rotation = false,
        rendering = false,
        stopRendering = false,
        cooldown = 0,
        cachedNetIds = {},
        keys = {},
        propZoneData = {},
        onEnter = nil,
        onLeave = nil,
        onEnterSpeedCamera = nil,
        onLeaveSpeedCamera = nil,
        onKey = nil,
        zoneDutyState = false,
        isIn = false,
        entity = nil,
        department = nil,
        zoneData = nil,
        propZoneLodDistance = nil,
        isPropZone = false,
        cameraForwardVector = nil,
        inRadius = 1.5,
        maxCameraSpeed = nil,
        color = Config.Marker and Config.Marker.Colour or {r=255,g=255,b=255,a=255}
    }
    
    self.registerKey = function(a1, a2) keyCache[a2] = a1 end
    self.setId = function(id) self.id = id; self.update() end
    self.removeCameraZone = function() if self.coneData then self.coneData = nil end end
    self.setCameraZoneSpeed = function(speed) self.maxCameraSpeed = speed end
    self.getCameraZoneSpeed = function() return self.maxCameraSpeed end
    self.getCameraForwardVector = function() return self.cameraForwardVector end
    self.setCameraZone = function(heading, speed)
        self.setCameraZoneSpeed(speed)
        local function angleToVec(a)
            local rad = math.rad(a)
            return vector3(math.cos(rad), math.sin(rad), 0.0)
        end
        local newH = heading + 90
        local checkDist = Config.Props and Config.Props.SpeedCamera and Config.Props.SpeedCamera.CheckDistance or 50.0
        local fv = angleToVec(newH)
        
        self.cameraForwardVector = vector3(self.position.x + (fv.x * checkDist), self.position.y + (fv.y * checkDist), self.position.z)
        
        local leftVec = angleToVec(newH - 45.0)
        local rightVec = angleToVec(newH + 45.0)
        
        self.coneData = {
            centralEndPoint = self.cameraForwardVector,
            leftBoundaryEndPoint = vector3(self.position.x + (leftVec.x * checkDist), self.position.y + (leftVec.y * checkDist), self.position.z),
            rightBoundaryEndPoint = vector3(self.position.x + (rightVec.x * checkDist), self.position.y + (rightVec.y * checkDist), self.position.z)
        }
        dbg.debug("Camera zone boundaries calculated")
    end
    self.setZoneData = function(d) self.zoneData = d end
    self.getZoneData = function() return self.zoneData end
    self.setPropZoneData = function(d) self.propZoneData = d end
    self.getPropZoneData = function() return self.propZoneData end
    self.getId = function() return self.id end
    self.getInteractStyle = function() return self.zoneStyleType end
    self.setType = function(t) self.type = t; self.update() end
    self.getType = function() return self.type end
    self.setPropZone = function(s) self.isPropZone = s end
    self.getPropZone = function() return self.isPropZone end
    self.setPropLodDistance = function(d) self.propZoneLodDistance = d end
    self.getPropLodDistance = function() return self.propZoneLodDistance end
    self.setPosition = function(p) self.position = vector3(p.x, p.y, p.z+1); self.update(); return self end
    self.setZoneLabel = function(l) self.zoneLabel = l end
    self.getZoneLabel = function() return self.zoneLabel end
    self.setZoneDutyState = function(s) self.zoneDutyState = s end
    self.getZoneDutyState = function() return self.zoneDutyState end
    self.setZoneType = function(t) self.zoneType = t end
    self.setJobState = function(s) self.zoneJobState = s end
    self.getJobState = function() return self.zoneJobState end
    self.getZoneType = function() return self.zoneType end
    self.getPosition = function() return self.position end
    self.setDir = function(d) self.dir = d; self.update() end
    self.getDir = function() return self.dir end
    self.setRot = function(r) self.rot = r; self.update() end
    self.getRot = function() return self.rot end
    self.setScale = function(s) self.scale = s; self.update() end
    self.getScale = function() return self.scale end
    self.setColor = function(c) self.color = c; self.update() end
    self.getColor = function() return self.color end
    self.setAlpha = function(a) self.color.a = a; self.update() end
    self.getAlpha = function() return self.color.a end
    self.setRed = function(r) self.color.r = r; self.update() end
    self.getRed = function() return self.color.r end
    self.setGreen = function(g) self.color.g = g; self.update() end
    self.getGreen = function() return self.color.g end
    self.setBlue = function(b) self.color.b = b; self.update() end
    self.getBlue = function() return self.color.b end
    self.setNPCModel = function(m) self.npcModel = m end
    self.setNPCHeading = function(h) self.npcHeading = h end
    self.setNPCRenderDistance = function(d) self.npcRenderDistance = d; self.update(); return self end
    self.setRenderDistance = function(d) self.renderDistance = d; self.update(); return self end
    self.setDepartmentOwner = function(d) self.department = d end
    self.getDepartmentOwner = function() return self.department end
    self.getRenderDistance = function() return self.renderDistance end
    self.setRotation = function(r) self.rotation = r; self.update() end
    self.getRotation = function() return self.rotation end
    self.setInRadius = function(r) self.inRadius = r; self.update() end
    self.getInRadius = function() return self.inRadius end
    self.render = function() self.stopRendering = false; self.rendering = true; self.firstUpdate = false; self.update(); return self end
    self.stopRender = function() self.stopRendering = true; self.rendering = false; self.update() end
    self.destroy = function() self.stopRendering = true; self.rendering = false; self.destroyed = true; self.update(true); dbg.debug("Deleted zone %s", self.getId()) end
    self.isRendering = function() return self.rendering end
    self.setKeys = function(k) self.keys = k; self.update(); return self end
    self.getKeys = function() return self.keys end
    
    self.loadObject = function()
        if self.isObjectLoaded then return end
        self.isObjectLoaded = true
        local data = self.getPropZoneData()
        if not data then return end
        
        local pos = self.getPosition()
        local isSpeedRadar = (data.type == PROP_TYPES.SPEED_RADAR)
        
        self.entity = UtilsService.SpawnObject(data.model, pos, false, false, isSpeedRadar)
        
        if isSpeedRadar then
            local zOk, zPos = GetGroundZAndNormalFor_3dCoord(pos.x, pos.y, pos.z)
            if zOk then
                SetEntityCoords(self.entity, pos.x, pos.y, zPos + 0.5)
                PlaceObjectOnGroundProperly(self.entity)
            end
        end
        
        if data.heading and data.type ~= PROP_TYPES.WHEEL_CLAMP then
            SetEntityHeading(self.entity, data.heading)
        end
        FreezeEntityPosition(self.entity, true)
        
        if data.type == PROP_TYPES.BARRICADE then
            SetCanClimbOnEntity(self.entity, false)
            SetObjectForceVehiclesToAvoid(self.entity, true)
            SetEntityInvincible(self.entity, true)
            FreezeEntityPosition(self.entity, true)
            SetEntityCanBeDamaged(self.entity, false)
            SetEntityCollision(self.entity, true, true)
            SetEntityProofs(self.entity, true, true, true, true, true, true, true, true)
            
            local speedZoneRange = Config.Props and Config.Props.SpeedZoneRange or 15.0
            local speedZoneSpeed = Config.Props and Config.Props.SpeedZoneSpeed or 0.0
            self.speedRoadNode = AddSpeedZoneForCoord(pos.x, pos.y, pos.z, speedZoneRange, speedZoneSpeed, false)
            
            self.collisionEntity = UtilsService.SpawnObject("v_ret_fh_shelf_02", vector3(pos.x, pos.y, pos.z - 0.8), false, false, isSpeedRadar)
            SetEntityHeading(self.collisionEntity, GetEntityHeading(self.entity))
            SetEntityAlpha(self.collisionEntity, 0, false)
            SetEntityCollision(self.collisionEntity, true, true)
            FreezeEntityPosition(self.collisionEntity, true)
            SetEntityInvincible(self.collisionEntity, true)
        elseif data.type == PROP_TYPES.SPEED_RADAR then
            SetCanClimbOnEntity(self.entity, false)
            FreezeEntityPosition(self.entity, true)
        elseif data.type == PROP_TYPES.WHEEL_CLAMP then
            WheelClampSpawn(self.entity, { object = self.zoneData, id = self.getId() })
        end
        
        PlaceObjectOnGroundProperly(self.entity)
    end
    
    self.unloadObject = function()
        if self.isObjectLoaded and DoesEntityExist(self.entity) then
            DeleteEntity(self.entity)
            self.isObjectLoaded = false
            self.entity = nil
            if self.speedRoadNode then
                RemoveRoadNodeSpeedZone(self.speedRoadNode)
                self.speedRoadNode = nil
            end
            if self.collisionEntity and DoesEntityExist(self.collisionEntity) then
                DeleteEntity(self.collisionEntity)
                self.collisionEntity = nil
            end
        end
    end
    
    self.loadZoneNPC = function()
        if not self.npcModel or self.npc then return end
        if not HasModelLoaded(self.npcModel) then
            RequestModel(self.npcModel)
            while not HasModelLoaded(self.npcModel) do Wait(0) end
        end
        self.npc = CreatePed(4, self.npcModel, self.position.x, self.position.y, self.position.z - 1, self.npcHeading, false, false)
        FreezeEntityPosition(self.npc, true)
        SetEntityInvincible(self.npc, true)
        SetBlockingOfNonTemporaryEvents(self.npc, true)
        return self.npc
    end
    
    self.unloadZoneNPC = function()
        if self.npc and DoesEntityExist(self.npc) then
            DeleteEntity(self.npc)
            self.npc = nil
        end
    end
    
    self.unloadZoneProp = function()
        if self.zoneProp and DoesEntityExist(self.zoneProp) then
            DeleteEntity(self.zoneProp)
            SetEntityDrawOutline(self.zoneProp, false)
            self.zoneProp = nil
        end
    end
    
    self.loadZoneProp = function()
        if not IsModelValid("v_10_liqurmat") or self.zoneProp then return end
        RequestModel("v_10_liqurmat")
        local pos = self.getPosition()
        local zOk, zPos = GetGroundZAndNormalFor_3dCoord(pos.x, pos.y, pos.z)
        self.zoneProp = CreateObjectNoOffset("v_10_liqurmat", pos.x, pos.y, zPos, false, false, false)
        SetEntityAlpha(self.zoneProp, 20, false)
        SetEntityDrawOutline(self.zoneProp, true)
        SetEntityDrawOutlineColor(255, 255, 255, 50)
    end
    
    self.on = function(eventName, cb)
        eventName = string.lower(eventName)
        if eventName == "enter" then self.onEnter = cb
        elseif eventName == "leave" then self.onLeave = cb
        elseif eventName == "onenterspeedcamera" then self.onEnterSpeedCamera = cb
        elseif eventName == "onleavespeedcamera" then self.onLeaveSpeedCamera = cb
        elseif eventName == "key" then self.onKey = cb end
        self.update()
    end
    
    self.update = function(destroy)
        if self.firstUpdate then return end
        if destroy then
            for id, z in pairs(RenderedZones) do
                if z.getId() == self.getId() then
                    self.unloadObject()
                    RenderedZones[id] = nil
                end
            end
            for id, z in pairs(ActiveZones) do
                if z.getId() == self.getId() then
                    self.unloadObject()
                    ActiveZones[id] = nil
                end
            end
        else
            for id, z in pairs(ActiveZones) do
                if z.getId() == self.getId() then
                    self.unloadObject()
                    ActiveZones[id] = self
                end
            end
        end
    end
    
    table.insert(ActiveZones, self)
    return self
end

AddEventHandler("onResourceStop", function(resource)
    for _, z in pairs(ActiveZones) do
        if z.resource == resource then z.destroy() end
    end
end)

function IsVehicleInCone(pt, a, b, c)
    local function sign(p1, p2, p3)
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
    end
    local d1 = sign(pt, a, b)
    local d2 = sign(pt, b, c)
    local d3 = sign(pt, c, a)
    local has_neg = (d1 < 0) or (d2 < 0) or (d3 < 0)
    local has_pos = (d1 > 0) or (d2 > 0) or (d3 > 0)
    return not (has_neg and has_pos)
end
