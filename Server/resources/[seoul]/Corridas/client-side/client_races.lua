-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - CORRIDAS BASICAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = SeoulCorridasClient.Tunnel
local ServerRaces = Tunnel.getInterface("Races")

local inLaps = 1
local inTimers = 0
local inSelected = 0
local inCheckpoint = 0
local inRunners = false
local runners = Config.races.runners

local function resetRace(cancelServer)
    if cancelServer then
        ServerRaces.cancelRace()
    end
    inLaps = 1
    inTimers = 0
    inSelected = 0
    inCheckpoint = 0
    inRunners = false
end

CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped,false) then
            local coords = GetEntityCoords(ped)

            if inRunners and runners[inSelected] then
                timeDistance = 4
                local selected = runners[inSelected]
                local point = selected.coords[inCheckpoint]

                if point then
                    DrwText("~b~VOLTAS:~w~ "..inLaps.." / "..selected.laps.."          ~b~CHECKPOINT:~w~ "..inCheckpoint.." / "..#selected.coords.."          ~b~TEMPO:~w~ "..inTimers,0.94)
                    local distance = #(coords - vector3(point[1],point[2],point[3]))

                    if distance <= 200.0 then
                        DrawMarker(1,point[1],point[2],point[3]-3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25)
                        DrawMarker(21,point[1],point[2],point[3]+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,42,137,255,50,true,false,0,true)

                        if distance <= 10.0 then
                            local result = ServerRaces.checkpoint()
                            if result and result.ok then
                                if result.finished then
                                    PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
                                    resetRace(false)
                                else
                                    inCheckpoint = tonumber(result.checkpoint) or inCheckpoint
                                    inLaps = tonumber(result.lap) or inLaps
                                    local nextPoint = selected.coords[inCheckpoint]
                                    if nextPoint then
                                        SetNewWaypoint(nextPoint[1],nextPoint[2])
                                    end
                                end
                            end
                        end
                    end
                end
            else
                for k,v in pairs(runners) do
                    local distance = #(coords - vector3(v.init[1],v.init[2],v.init[3]))
                    if distance <= 50.0 then
                        timeDistance = 4
                        DrawBase3D(v.init[1],v.init[2],v.init[3])
                        DrawMarker(21,v.init[1],v.init[2],v.init[3]+2.0,0,0,0,0,180.0,130.0,3.0,3.0,2.0,42,137,255,50,true,false,0,true)

                        if IsControlJustPressed(1,38) and distance <= 5.0 then
                            local selected = tonumber(k)
                            if selected and ServerRaces.startRace(selected) then
                                inSelected = selected
                                inRunners = true
                                inCheckpoint = 1
                                inTimers = 0
                                inLaps = 1
                                local firstPoint = runners[inSelected].coords[1]
                                SetNewWaypoint(firstPoint[1],firstPoint[2])
                                break
                            end
                        end
                    end
                end
            end
        elseif inRunners then
            resetRace(true)
        end

        Wait(timeDistance)
    end
end)

CreateThread(function()
    while true do
        if inRunners then
            inTimers = inTimers + 1
        end
        Wait(1000)
    end
end)
