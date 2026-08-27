-- =====================================================
--  rcore_police · modules/base/client/lib/interactions/cl-int-vehicle.lua
--  Engineered by Eazy Fxap
--  Original: 584 lines → Cleaned: 135 lines
-- =====================================================

local Doors = { [0] = "dside_f", [1] = "pside_f", [2] = "dside_r", [3] = "pside_r" }
local Seats = { [0] = -1, [1] = 0, [2] = 1, [3] = 2 }
local SeatToDoor = { [-1] = 0, [0] = 1, [1] = 2, [2] = 3 }
local SeatToBoneName = { [-1] = "seat_dside_f", [0] = "seat_pside_f", [1] = "seat_dside_r", [2] = "seat_pside_r" }
local EntryPositions = {
    [-1] = vector3(-0.5, 1.5, 0.0),
    [0] = vector3(0.5, 1.5, 0.0),
    [1] = vector3(-0.5, -1.5, 0.0),
    [2] = vector3(0.5, -1.5, 0.0)
}

local currentSeat = nil
local PuttingPlayerInVehicle = false

function Interactions.PutPlayerInVehicle(targetServerId)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local targetPed = UtilsService.GetPlayerPedFromServerId(targetServerId)
    local tCoords = GetEntityCoords(targetPed)
    
    local veh = Utils.GetClosestVehicleToPlayer(coords, 6.0)
    dbg.debug("Checking if player is close to vehicle: %s", veh)
    
    local attached = IsEntityAttachedToAnyPed(ped)
    if attached then
        DetachEntity(ped, false, false)
    end
    
    if veh and veh > 0 then
        local seatIdx, doorIdx = GetClosestSeatToPlayer(veh, coords)
        if not seatIdx or not doorIdx then
            seatIdx, doorIdx = GetClosestSeatToPlayer(veh, tCoords)
            dbg.debug("Fallback: Found vehicle with seat & door id: %s %s", seatIdx, doorIdx)
        else
            dbg.debug("Origin: Found vehicle with seat & door id: %s %s", seatIdx, doorIdx)
        end
        
        if not DoesEntityExist(veh) then
            return dbg.critical("Not existing vehicle - put player in vehicle!")
        end
        
        if IsPedCuffed(ped) then
            PuttingPlayerInVehicle = true
            SetEnableHandcuffs(ped, false)
        end
        
        local isTargetDead = false
        if not attached then
            isTargetDead = DeadUtils.IsTargetPlayerDead(MyServerId)
        end
        
        if isTargetDead and seatIdx then
            SetPedIntoVehicle(ped, veh, seatIdx)
            return
        end
        
        SetPedConfigFlag(ped, 184, true)
        if seatIdx and doorIdx then
            dbg.debug("Player is getting into seat with id: %s", seatIdx)
            currentSeat = seatIdx
            SetVehicleDoorOpen(veh, doorIdx, false, false)
            Wait(250)
            toggleEnterOrExit(ped, veh, seatIdx, "ENTER")
            
            if not PuttingPlayerInVehicle then return end
            
            local enterTime = 0
            local success = false
            repeat
                Wait(250)
                enterTime = enterTime + 250
                if IsPedInVehicle(ped, veh, false) then
                    success = true
                    break
                end
                if GetSeatPedIsTryingToEnter(ped) < 0 then break end
            until enterTime >= 2500
            
            if not success then
                dbg.debug("Fallback: Forcing ped into vehicle after timeout")
                SetPedIntoVehicle(ped, veh, seatIdx)
            end
            
            SetVehicleDoorShut(veh, doorIdx, true)
            SetEnableHandcuffs(ped, true)
            PuttingPlayerInVehicle = false
        else
            dbg.debug("Failed to get seat and door id from vehicle: %s %s %s", veh, seatIdx, doorIdx)
        end
    end
end

function Interactions.TakePlayerFromVehicle(targetServerId, seatData)
    local ped = PlayerPedId()
    local targetPed = UtilsService.GetPlayerPedFromServerId(targetServerId)
    local tCoords = GetEntityCoords(targetPed)
    
    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, true)
        if veh then
            local cuffed = IsPedCuffed(ped)
            local escorted = InteractionService.isEscorted()
            local waitTime = cuffed and 3000 or 3000
            
            TaskLeaveAnyVehicle(ped, 0, 0)
            SetPedConfigFlag(ped, 184, false)
            
            if currentSeat then currentSeat = nil end
            
            if IsPedSittingInAnyVehicle(ped) then
                dbg.debug("Teleporting player from vehicle to the initiator coords instead..")
                SetEntityCoords(ped, tCoords.x, tCoords.y, tCoords.z, false, false, false, true)
            end
        end
    end
end

function DrawText2D(x, y, text, r, g, b, a)
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DebugVehicleSeats(veh)
    if not veh or not DoesEntityExist(veh) then return end
    
    local seats = {}
    for seat, door in pairs(Doors) do
        local boneIdx = GetEntityBoneIndexByName(veh, "handle_" .. door)
        if boneIdx ~= -1 then
            local pos = GetEntityBonePosition_2(veh, boneIdx)
            table.insert(seats, { seatIndex = seat, position = pos })
            DrawLine(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z + 1.0, 255, 255, 0, 255)
            DrawBox(pos.x - 0.1, pos.y - 0.1, pos.z - 0.1, pos.x + 0.1, pos.y + 0.1, pos.z + 0.1, 0, 0, 255, 150)
            Utils.Draw3DText(pos.x, pos.y, pos.z + 1.5, 1.0, Seats[seat] .. " - " .. door)
        end
    end
    return seats
end

function GetEntryPositionOfSeat(seatIdx)
    return EntryPositions[seatIdx]
end

function GetClosestSeatToPlayer(veh, coords, checkEmpty)
    if not veh or not DoesEntityExist(veh) then
        dbg.debug("No valid vehicle nearby.")
        return nil, nil
    end
    
    local vehCoords = GetEntityCoords(veh)
    if #(vehCoords - coords) > Config.CheckVehicleDistance then
        dbg.debug("Player too far from vehicle to search for seat.")
        return nil, nil
    end
    
    local closestSeat = nil
    local closestDist = math.huge
    local closestDoor = nil
    
    for i = GetVehicleMaxNumberOfPassengers(veh), -1, -1 do
        if IsVehicleSeatFree(veh, i) or (checkEmpty and GetPedInVehicleSeat(veh, i) > 0) then
            local boneName = SeatToBoneName[i]
            local boneIdx = boneName and GetEntityBoneIndexByName(veh, "handle_" .. boneName) or -1
            local seatPos = nil
            
            if boneIdx ~= -1 then
                seatPos = GetEntityBonePosition_2(veh, boneIdx)
            end
            
            if not seatPos then
                local offset = GetEntryPositionOfSeat(i) or vector3(0.0, 0.0, 0.0)
                seatPos = GetOffsetFromEntityInWorldCoords(veh, offset.x, offset.y, offset.z)
            end
            
            if seatPos then
                local dist = #(coords - seatPos)
                if dist < closestDist then
                    closestDist = dist
                    closestSeat = i
                    closestDoor = SeatToDoor[i]
                end
            end
        end
    end
    
    dbg.debug("Closest seat: %s, doorId: %s", closestSeat, closestDoor)
    return closestSeat, closestDoor
end

function toggleEnterOrExit(ped, veh, seatIdx, action)
    if action == "ENTER" then
        TaskEnterVehicle(ped, veh, -1, seatIdx, 1.0, 3, 0)
    end
end
