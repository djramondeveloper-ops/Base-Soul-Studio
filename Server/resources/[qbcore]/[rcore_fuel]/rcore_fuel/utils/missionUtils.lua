--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

local blipMission
-- FIX 2: this was declared as unused local "zoneCheckDistance" while the code
-- below actually read/wrote a same-purpose implicit global "blipCheckDistance"
-- (matches bak exactly -- an original naming slip, not a deobfuscation issue).
-- No functional bug (no name collision elsewhere), but renamed to one
-- consistent, properly-scoped local to remove a confusing trap for future edits.
local blipCheckDistance
local pointName = ""
local zoneCoords = vector3(0, 0, 0)
local lastZoneName = nil  -- FIX 1: promoted to file-level so CreateMissionZone can reset it

function CreateBlipMission(coords)
    DestroyBlipMission()
    blipMission = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipRoute(blipMission, true)
end

function DestroyBlipMission()
    if blipMission then
        RemoveBlip(blipMission)
        blipMission = nil
    end
end

function CreateMissionZone(coords, zoneName, distance)
    if type(coords) == "string" then
        zoneName = coords
        distance = 0
        coords = vector3(0, 0, 0)
    end

    zoneCoords = coords
    pointName = zoneName
    lastZoneName = nil   -- resets the trigger guard so enterZone fires again for new zone
    blipCheckDistance = distance
end

function GetMissionName()
    return pointName
end

function GetMissionCoords()
    return zoneCoords
end

function DestroyMissionZone()
    zoneCoords = nil
    pointName = nil
    blipCheckDistance = nil
end

CreateThread(function()
    -- FIX 1: removed shadowing local; now uses file-level lastZoneName
    while true do
        Wait(1000)
        if pointName then
            if #(zoneCoords - GetEntityCoords(PlayerPedId())) < (blipCheckDistance or 20) and lastZoneName ~= pointName then
                lastZoneName = pointName
                TriggerEvent("rcore_fuel:enterZone", pointName)
            end
        end
    end
end, "zone enter name")
