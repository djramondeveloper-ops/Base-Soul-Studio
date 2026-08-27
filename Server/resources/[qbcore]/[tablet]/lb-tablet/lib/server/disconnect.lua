local tabletDisconnectCallbacks = {}

function OnTabletDisconnect(cb)
    assert(type(cb) == "function", "Invalid argument #1 (function expected), got: " .. type(cb))

    tabletDisconnectCallbacks[#tabletDisconnectCallbacks+1] = cb
end

local playerDisconnectCallbacks = {}

function OnPlayerDisconnect(cb)
    assert(type(cb) == "function", "Invalid argument #1 (function expected), got: " .. type(cb))

    playerDisconnectCallbacks[#playerDisconnectCallbacks+1] = cb
end

function PlayerLoggedOut(source)
    local tabletId = GetEquippedTablet(source)

    if tabletId then
        for i = 1, #tabletDisconnectCallbacks do
            Citizen.CreateThreadNow(function()
                tabletDisconnectCallbacks[i](tabletId, source)
            end)
        end
    end

    for i = 1, #playerDisconnectCallbacks do
        Citizen.CreateThreadNow(function()
            playerDisconnectCallbacks[i](source)
        end)
    end
end

AddEventHandler("playerDropped", function()
    PlayerLoggedOut(source)
end)
