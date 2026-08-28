NetworkService.RegisterNetEvent("openBooth", function(success, boothData)
    if success then
        Booths.OpenUI(boothData)
    end
end)

NetworkService.RegisterNetEvent("startCall", function(success, boothId, callData)
    if success then
        Booths.StartCall(boothId, callData)
    end
end)

NetworkService.RegisterNetEvent("endCall", function(success, boothId)
    if success then
        Booths.EndCall(boothId)
    end
end)

NetworkService.RegisterNetEvent("ResetCallState", function(success)
    if success then
        Booths.Reset()
    end
end)