NetworkService.RegisterNetEvent("createSquaredArea", function(success, data)
    if success then
        Blips.CreateSquaredArea(data)
    end
end)

NetworkService.RegisterNetEvent("RemoveBlipByType", function(success, blipType)
    if success then
        Blips.RemoveByType(blipType)
    end
end)

NetworkService.RegisterNetEvent("SetWaypoint", function(success, coords)
    if success then
        Blips.SetWaypoint(coords)
    end
end)