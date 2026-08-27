-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - CORRIDA EXPLOSIVA
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = SeoulCorridasClient.Tunnel
local ExplodeRace = {}
Tunnel.bindInterface("Street",ExplodeRace)
local ServerStreet = Tunnel.getInterface("Street")

local racePos = 0
local raceTime = 0
local blipRace = {}
local inRace = false
local raceSelect = 0
local timeSeconds = 0
local race = Config.streetRace.races
local raceTimers = Config.streetRace.timers
local startX = Config.streetRace.startRace[1]
local startY = Config.streetRace.startRace[2]
local startZ = Config.streetRace.startRace[3]

local function clearRaceBlips()
    for k,blip in pairs(blipRace) do
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
        blipRace[k] = nil
    end
    blipRace = {}
end

local function resetRace(cancelServer)
    if cancelServer then
        ServerStreet.cancelRace()
    end
    clearRaceBlips()
    racePos = 0
    raceTime = 0
    raceSelect = 0
    inRace = false
end

local function createRaceBlips(selected)
    local route = race[selected]
    if not route then return end

    -- Somente checkpoints numericos: algumas rotas possuem metadados como "payment".
    for i = 1,#route do
        local point = route[i]
        local blip = AddBlipForCoord(point[1],point[2],point[3])
        blipRace[i] = blip
        SetBlipSprite(blip,1)
        SetBlipColour(blip,0)
        SetBlipAsShortRange(blip,true)
        SetBlipScale(blip,0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Checkpoint")
        EndTextCommandSetBlipName(blip)
        ShowNumberOnBlip(blip,i)
    end
end

local function explodeLastVehicle()
    local vehicle = GetPlayersLastVehicle()
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        local coords = GetEntityCoords(vehicle)
        AddExplosion(coords.x,coords.y,coords.z,2,1.0,true,true,1.0)
    end
end

local function initRaceThread()
    CreateThread(function()
        while inRace do
            if raceTime > 0 then
                raceTime = raceTime - 1
                if raceTime <= 0 or not IsPedInAnyVehicle(PlayerPedId(),false) then
                    ServerStreet.cancelRace()
                    clearRaceBlips()
                    raceTime = 0
                    inRace = false
                    Wait(3000)
                    explodeLastVehicle()
                    break
                end
            end
            Wait(1000)
        end
    end)
end

CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped,false) then
            local coords = GetEntityCoords(ped)

            if not inRace then
                local distance = #(coords - vector3(startX,startY,startZ))
                if distance <= 100.0 then
                    timeDistance = 4
                    DrawBase3D(startX,startY,startZ)

                    if distance <= 12.5 then
                        local vehicle = GetVehiclePedIsUsing(ped)
                        if IsControlJustPressed(1,38) and timeSeconds <= 0 and GetPedInVehicleSeat(vehicle,-1) == ped then
                            timeSeconds = 2
                            local selected = ServerStreet.startRace()
                            selected = tonumber(selected)

                            if selected and race[selected] and raceTimers[selected] then
                                racePos = 1
                                inRace = true
                                raceSelect = selected
                                raceTime = tonumber(raceTimers[selected]) or 0
                                clearRaceBlips()
                                createRaceBlips(selected)
                                initRaceThread()
                                SetNewWaypoint(race[selected][1][1]+0.0001,race[selected][1][2]+0.0001)
                            end
                        end
                    end
                end
            elseif race[raceSelect] and race[raceSelect][racePos] then
                local point = race[raceSelect][racePos]
                local distance = #(coords - vector3(point[1],point[2],point[3]))

                if distance <= 200.0 then
                    timeDistance = 4
                    DrawMarker(1,point[1],point[2],point[3]-3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25)
                    DrawMarker(21,point[1],point[2],point[3]+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,255,0,0,50,true,false,0,true)

                    if distance <= 10.0 then
                        local result = ServerStreet.checkpoint()
                        if result and result.ok then
                            if blipRace[racePos] and DoesBlipExist(blipRace[racePos]) then
                                RemoveBlip(blipRace[racePos])
                                blipRace[racePos] = nil
                            end

                            if result.finished then
                                PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
                                resetRace(false)
                            else
                                racePos = tonumber(result.checkpoint) or racePos
                                local nextPoint = race[raceSelect][racePos]
                                if nextPoint then
                                    SetNewWaypoint(nextPoint[1]+0.0001,nextPoint[2]+0.0001)
                                end
                            end
                        elseif result and result.expired then
                            clearRaceBlips()
                            inRace = false
                            raceTime = 0
                            Wait(3000)
                            explodeLastVehicle()
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
            ServerStreet.cancelRace()
            clearRaceBlips()
            inRace = false
            raceTime = 0
            Wait(3000)
            explodeLastVehicle()
        end

        Wait(timeDistance)
    end
end)

CreateThread(function()
    while true do
        if timeSeconds > 0 then
            timeSeconds = timeSeconds - 1
        end
        Wait(1000)
    end
end)

function ExplodeRace.defuseRace()
    clearRaceBlips()
    inRace = false
    raceTime = 0
    timeSeconds = 0
    racePos = 0
    raceSelect = 0
end
