BaseCallback("airShare:share", function(source, tabletId, targetSource, targetDevice, payload)
    local sourcePlayer = Player(source)
    if not sourcePlayer or not sourcePlayer.state then
        debugprint("AirShare: sender player not found")
        return false
    end

    local senderName = sourcePlayer.state.lbTabletName
    if not senderName then
        debugprint("AirShare: no sender name")
        return false
    end

    payload = payload or {}
    payload.sender = {
        name = senderName,
        source = source,
        device = "tablet"
    }

    local targetPlayer = Player(targetSource)
    if not targetPlayer or not targetPlayer.state then
        debugprint("AirShare: target player not found")
        return false
    end

    if targetDevice == "tablet" then
        if GetResourceState("lb-tablet") ~= "started" then
            return false
        end

        if not targetPlayer.state.lbTabletOpen then
            return false
        end

        TriggerClientEvent("tablet:airShare:received", targetSource, payload)
        return true
    end

    if targetDevice == "phone" then
        if not targetPlayer.state.phoneOpen then
            return false
        end

        TriggerClientEvent("phone:airShare:received", targetSource, payload)
        return true
    end

    debugprint("AirShare: invalid target device", targetDevice)
    return false
end, false)

RegisterNetEvent("tablet:airShare:interacted", function(targetSource, targetDevice, accepted)
    local senderSource = source

    if type(targetSource) ~= "number" or type(accepted) ~= "boolean" then
        return
    end

    if targetDevice == "tablet" then
        TriggerClientEvent("tablet:airShare:interacted", targetSource, senderSource, accepted)
        return
    end

    if targetDevice == "phone" then
        TriggerClientEvent("phone:airShare:interacted", targetSource, senderSource, accepted)
    end
end)