NetworkService.RegisterNetEvent("destroyWall", function(success, zoneId, wallState, extraData)
    if not success then
        return
    end

    DestroyWall(zoneId, wallState, extraData)
end)
