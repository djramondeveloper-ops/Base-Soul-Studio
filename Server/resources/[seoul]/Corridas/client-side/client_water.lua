-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - CORRIDAS AQUATICAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = SeoulCorridasClient.Tunnel
local ServerWater = Tunnel.getInterface("Water")

local racePos = 0
local raceTime = 0
local raceSelect = 0
local blipRace = nil
local inRace = false
local race = Config.waterRace.races
local startX = Config.waterRace.startRace[1]
local startY = Config.waterRace.startRace[2]
local startZ = Config.waterRace.startRace[3]

local function clearBlip()
    if blipRace and DoesBlipExist(blipRace) then
        RemoveBlip(blipRace)
    end
    blipRace = nil
end

local function resetRace(cancelServer)
    if cancelServer then
        ServerWater.cancelRace()
    end
    clearBlip()
    racePos = 0
    raceTime = 0
    raceSelect = 0
    inRace = false
end

local function makeBlipMarked()
    local route = race[raceSelect]
    local point = route and route[racePos]
    if not point then return end

    clearBlip()
    blipRace = AddBlipForCoord(point[1],point[2],point[3])
    SetBlipSprite(blipRace,1)
    SetBlipColour(blipRace,1)
    SetBlipScale(blipRace,0.4)
    SetBlipAsShortRange(blipRace,false)
    SetBlipRoute(blipRace,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Checkpoint")
    EndTextCommandSetBlipName(blipRace)
end

CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()

        if IsPedInAnyBoat(ped) then
            local coords = GetEntityCoords(ped)

            if not inRace then
                local distance = #(coords - vector3(startX,startY,startZ))
                if distance <= 500.0 then
                    timeDistance = 4
                    DrawMarker(1,startX,startY,startZ-5,0,0,0,0,0,0,50.0,50.0,100.0,255,0,0,100)
                    DrawBase3D(startX,startY,startZ)

                    if distance <= 25.0 and IsControlJustPressed(1,38) then
                        local selected = ServerWater.startRace()
                        selected = tonumber(selected)

                        if selected and race[selected] then
                            racePos = 1
                            inRace = true
                            raceSelect = selected
                            raceTime = tonumber(race[selected].time) or 0
                            makeBlipMarked()
                        end
                    end
                end
            elseif race[raceSelect] and race[raceSelect][racePos] then
                local point = race[raceSelect][racePos]
                local distance = #(coords - vector3(point[1],point[2],point[3]))

                if distance <= 999.0 then
                    timeDistance = 4
                    DrawMarker(1,point[1],point[2],point[3]-5,0,0,0,0,0,0,50.0,50.0,100.0,100,100,255,100)

                    if distance <= 25.0 then
                        local result = ServerWater.checkpoint()
                        if result and result.ok then
                            if result.finished then
                                PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
                                resetRace(false)
                            else
                                racePos = tonumber(result.checkpoint) or racePos
                                makeBlipMarked()
                            end
                        elseif result and result.expired then
                            resetRace(false)
                        end
                    end
                end

                if raceTime > 0 then
                    timeDistance = 4
                    DrwText("~b~"..raceTime.." SEGUNDOS ~w~RESTANTES PARA O FINAL DA CORRIDA",0.905)
                    DrwText("CORRA CONTRA O TEMPO, SUPERE SEUS LIMITES E QUEBRE SEUS RECORDES",0.93)
                end
            end
        elseif inRace then
            resetRace(true)
        end

        Wait(timeDistance)
    end
end)

CreateThread(function()
    while true do
        if inRace and raceTime > 0 then
            raceTime = raceTime - 1
            if raceTime <= 0 or not IsPedInAnyBoat(PlayerPedId()) then
                resetRace(true)
            end
        end
        Wait(1000)
    end
end)
