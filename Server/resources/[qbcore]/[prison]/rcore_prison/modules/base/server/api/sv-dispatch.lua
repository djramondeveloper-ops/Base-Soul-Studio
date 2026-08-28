NetworkService.EventListener('heartbeat', function(eventType, data)
    local destroyWall = Config.DispatchSettings.InvokeWhenDestroyedWall
    local playerEscapedPrison = Config.DispatchSettings.InvokeWhenPlayerEscapePrison

    local prisoner = data.prisoner

    if not prisoner then
        return
    end

    local playerId = prisoner.source

    if not playerId then
        return
    end
    

    if Config.Escape.Experimental and Config.Escape.Experimental.RemoveCuttersAfterWallDestroyed and eventType == HEARTBEAT_EVENTS.PLAYER_DESTROYED_WALL then
        -- Check if we should remove after second wall only, or after any wall
        local shouldRemove = false

        if Config.Escape.Experimental.RemoveCuttersAfterSecondWall then
            -- Only remove after the second (outer) wall
            shouldRemove = data.layerName == 'SECOND_LAYER'
        else
            -- Remove after any wall (original behavior - needs 2 cutters for full escape)
            shouldRemove = true
        end

        if shouldRemove then
            local clearInventoryState, clearInventoryRetval = pcall(function()
                return Inventory.removeItem(playerId, Config.Escape.ItemName, 1)
            end)

            if clearInventoryState then
                dbg.debug('Player wire cutters has been removed since destroyed wall: %s (%s)', playerId, GetPlayerName(playerId))
            end
        end
    end

    if Config.Escape.Experimental and Config.Escape.Experimental.ClearPlayerInventoryWhenEscape and eventType == HEARTBEAT_EVENTS.PLAYER_ESCAPE_FROM_PRISON then
        local clearInventoryState, clearInventoryRetval = pcall(function()
            return Inventory.ClearPlayerInventory(playerId)
        end)

        if clearInventoryState then
            dbg.debug('Player inventory has been cleared since escaped prison: %s (%s)', playerId, GetPlayerName(playerId))
        end
    end
    

    if destroyWall and eventType == HEARTBEAT_EVENTS.PLAYER_DESTROYED_WALL then
        dbg.debug('Calling dispatch since destroyed wall event is called.')
        Dispatch.Breakout(playerId)
        StartPrisonBreakAlarm()
    elseif playerEscapedPrison and eventType == HEARTBEAT_EVENTS.PLAYER_ESCAPE_FROM_PRISON then
        dbg.debug('Calling dispatch since player escaped from prison is called.')
        Dispatch.Breakout(playerId)
        StartPrisonBreakAlarm()
    end
end)