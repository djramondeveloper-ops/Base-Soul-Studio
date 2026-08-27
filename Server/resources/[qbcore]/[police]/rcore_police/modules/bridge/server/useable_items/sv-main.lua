-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local Cooldowns = {}
function isOnCooldown(playerId, key, duration)
    local now = GetGameTimer()
    local last = Cooldowns[playerId] and Cooldowns[playerId][key] or 0
    if now - last < duration then
        return true
    end
    Cooldowns[playerId] = Cooldowns[playerId] or {}
    Cooldowns[playerId][key] = now
    return false
end
CreateThread(function()
    InventoryService.RegisterUsableItem(Items.Spikes, function(playerId, metadata)
        ActionService.RequestSpike(playerId)
    end)
    InventoryService.RegisterUsableItem(Items.WheelClamp, function(playerId, metadata)
        if not Config.WheelClamp.Enable then
            return
        end
        ActionService.RequestWheelClamp(playerId)
    end)
    InventoryService.RegisterUsableItem(Items.WheelClampWrench, function(playerId, metadata)
        if not Config.WheelClamp.Enable then
            return
        end
        StartClient(playerId, "RemoveWheelClamp")
    end)
    InventoryService.RegisterUsableItem(Items.SpeedCamera, function(playerId, metadata)
        ActionService.RequestSpeedCamera(playerId)
    end)
    InventoryService.RegisterUsableItem(Items.Megaphone, function(playerId, metadata)
        ActionService.RequestMegaphone(playerId)
    end)
    InventoryService.RegisterUsableItem(Items.Barrier, function(playerId, metadata)
        ActionService.RequestBarrier(playerId)
    end)
    InventoryService.RegisterUsableItem(Items.PaperBag, function(playerId, metadata)
        local target = nil
        if IsInDev then
            target = playerId
        else
            target = Utils.getClosestPlayers(playerId, Config.CheckDistance)
            if playerId == target then
                return
            end
            if target == -1 then
                return Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
            end
        end
        ActionService.RequestHeadBag(playerId, target)
    end)
    InventoryService.RegisterUsableItem(Items.Zipties, function(playerId, metadata)
        local target = nil
        if IsInDev then
            target = playerId
        else
            target = Utils.getClosestPlayers(playerId, Config.CheckDistance)
            if playerId == target then
                return false, 'PLAYER_EQUAL_TARGET'
            end
            if target == -1 then
                Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
                return false, 'TARGET_PLAYER_NOT_FOUND'
            end
        end
        ActionService.ZipTies(playerId, target)
    end)
    InventoryService.RegisterUsableItem(Items.Handcuffs, function(playerId, metadata)
        local target = nil
        if Config.Flags.CuffsItemOnlyForDepartmentGroups then
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not playerData then
                return
            end
        end
        if IsInDev then
            target = playerId
        else
            target = Utils.getClosestPlayers(playerId, Config.CheckDistance)
            if playerId == target then
                return false, 'PLAYER_EQUAL_TARGET'
            end
            if target == -1 then
                Framework.sendNotification(playerId, _U("NO_CITIZEN_NEARBY"), "error")
                return false, 'TARGET_PLAYER_NOT_FOUND'
            end
        end
        StartClient(playerId, "StartInteractionByItem", MENU_ACTIONS.CUFF_SOFT, target)
    end)
    if not Config.Cuffing.DisableCuffKeysUseableItem then
        InventoryService.RegisterUsableItem(Items.HandcuffsKeys, function(playerId, metadata)
            ActionService.RemoveHandcuff(playerId)
        end)
    end
    InventoryService.RegisterUsableItem(Items.PanicButton, function(playerId, metadata)
        local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
        if not playerData then
            return
        end
        EmergencyCall(playerData)
    end)
    InventoryService.RegisterUsableItem(Items.BodyCam, function(playerId, metadata)
        local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
        if not playerData then
            return
        end
        RegisterPlayerBodyCam(playerId)
    end)
    InventoryService.RegisterUsableItem(Items.BodyCamTablet, function(playerId, metadata)
        local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
        if not playerData then
            return
        end
        StartClient(playerId, 'OpenBodyCamsFeed')
    end)
    if Config.Zipties.Enable and Config.Zipties.UseableRemoveItems then
        local items = Config.Zipties.UseableRemoveItems
        if type(items) == "table" then
            for _, itemName in pairs(items) do
                InventoryService.RegisterUsableItem(itemName, function(playerId, metadata)
                    ActionService.RemoveHandcuff(playerId, nil, itemName)
                end)
            end
        else
            InventoryService.RegisterUsableItem(Items.ZipTiesCutter, function(playerId, metadata)
                ActionService.RemoveHandcuff(playerId, nil, Items.ZipTiesCutter)
            end)
        end
    end
    if Config.Image.AllowCameraItem then
        if Items.Camera and isResourcePresentProvideless("screenshot-basic") then
            InventoryService.RegisterUsableItem(Items.Camera, function(playerId, metadata)
                StartClient(playerId, "StartCamera", metadata)
            end)
        end
        if Items.Photo then
            InventoryService.RegisterUsableItem(Items.Photo, function(playerId, metadata)
                if metadata and metadata.photo then
                    if metadata.imageurl then
                        metadata.imageurl = nil
                    end
                    StartClient(playerId, "ViewPhoto", metadata)
                end
            end)
        end
        function CameraMetadata(cameraData, metadata)
            local itemMetadata = {
                photo = cameraData.url,
                date = os.date("%d.%m.%Y - %H:%M")
            }
            if metadata then
                for k, v in pairs(metadata) do
                    itemMetadata[k] = v
                end
            end
            return itemMetadata
        end
    end
    if Config.Inventory == Inventory.OX and Config.Image.AllowTakenPhotoReplaceWithRealImage then
        local hookId = exports.ox_inventory:registerHook('createItem', function(payload)
            local metadata = payload.metadata
            if metadata.photo then
                metadata.imageurl = metadata.photo
            end
            return metadata
        end, {
            print = false,
            itemFilter = {
                [Items.Photo] = true
            }
        })
    end
    if Config.Blips.Enable then
        RegisterListener("onGroups", function(action, member)
            if action == "addMember" and Config.Blips.AutoSubscribe then
                TrackerManager:subscribe(member.playerId)
            end
            if action == "updateMember" and Config.Blips.AutoBlip then
                local shouldBeActive =
                    (Config.Blips.RequireDuty and member.duty) or
                    (not Config.Blips.GPS.RequireItem)
                TrackerManager:setTrackerState(member.playerId, shouldBeActive)
            end
        end)
        RegisterCommand(Config.Commands.SHOW_BLIPS or "SHOW_BLIPS", function(playerId, args, rawCommand)
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not playerData then
                return
            end
            if Config.Blips.RequireDuty and not playerData.duty then
                return Framework.sendNotification(playerId, _U("DUTY.NEED_TO_BE_ON_DUTY_TO_INTERACT_WITH_ZONE"), "error")
            end
            local state = TrackerManager:toggleSubscription(playerId)
            local label = _U("BLIPS.SUBSCRIBE_OFF")
            if state then
                label = _U("BLIPS.SUBSCRIBE_ON")
            end
            Framework.sendNotification(playerId, label, "success")
        end, false)
        InventoryService.RegisterUsableItem(Items.GPS, function(playerId, metadata)
            local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
            if not playerData then
                return
            end
            if Config.Blips.RequireDuty and not playerData.duty then
                return Framework.sendNotification(playerId, _U("DUTY.NEED_TO_BE_ON_DUTY_TO_INTERACT_WITH_ZONE"), "error")
            end
            if isOnCooldown(playerId, "gps_toggle", Config.Blips.GPS.ItemUsageCooldown) then
                return Framework.sendNotification(playerId, _U("BLIPS.GPS_COOLDOWN"), "error")
            end
            local state = TrackerManager:toggleTracker(playerId)
            local label = _U("BLIPS.GPS_TURN_OFF")
            if state then
                label = _U("BLIPS.GPS_TURN_ON")
            end
            Framework.sendNotification(playerId, label, "success")
        end)
    end
end)
