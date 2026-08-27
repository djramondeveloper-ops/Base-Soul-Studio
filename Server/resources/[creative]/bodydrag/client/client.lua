-- =====================================================
-- COMPATIBILIDADE DE FRAMEWORK (ESX / QBCore / QBox / vRP / Standalone-Creative)
-- =====================================================
local Framework = 'standalone'

local function ResourceRunning(name)
    return name ~= nil and name ~= '' and GetResourceState(name) == 'started'
end

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end

    if ResourceRunning(Config.FrameworkResources.esx) then
        return 'esx'
    elseif ResourceRunning(Config.FrameworkResources.qbox) then
        return 'qbox'
    elseif ResourceRunning(Config.FrameworkResources.qbcore) then
        return 'qbcore'
    elseif ResourceRunning(Config.FrameworkResources.vrp) then
        return 'vrp'
    end

    return 'standalone'
end

Citizen.CreateThread(function()
    Framework = DetectFramework()
    print(('[icemallow-drag] Framework detectado: %s'):format(Framework))
end)

-- Dispara (se configurado) o evento de status de morte do framework atual.
-- Se o evento estiver vazio ou o resource nao existir, simplesmente nao faz nada.
local function NotifyDeathStatus(isDead)
    local event = Config.DeathStatusEvent[Framework]
    if event == nil or event == '' then return end

    TriggerServerEvent(event, isDead)
end

-- =====================================================
-- UTILITÁRIOS
-- =====================================================
function GetPlayers()
    local players = {}
    for i = 0, 1024 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)

    for _, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if target ~= ply then
            local targetCoords = GetEntityCoords(target)
            local distance = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, plyCoords.x, plyCoords.y, plyCoords.z, true)

            if Config.ShowDistance > distance and IsPedDeadOrDying(target, 0) then
                if closestDistance == -1 or distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = value
                end
            end
        end
    end

    return closestPlayer
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.30, 0.30)
    SetTextFont(8)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 255, 51, 51, 80)
    ClearDrawOrigin()
end

-- =====================================================
-- LÓGICA DE DRAG
-- =====================================================
local drag = false
local draggingPed = nil
local animFinished = false
local draggingPlayer = nil
local Player = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        local p1 = PlayerPedId()

        if not IsPedDeadOrDying(p1) and not drag then
            local p1pos = GetEntityCoords(p1)
            local p2 = Player and GetPlayerPed(Player) or nil

            if p2 and p2 ~= -1 then
                local p2pos = GetEntityCoords(p2)

                if GetDistanceBetweenCoords(p2pos, p1pos, true) <= Config.ShowDistance then
                    if IsPedDeadOrDying(p2, 0) then
                        if GetEntityHealth(p2) <= 6 then
                            SetEntityInvincible(p2, true)

                            if GetDistanceBetweenCoords(p2pos, p1pos, true) <= Config.InteractDistance then
                                DrawText3D(p2pos.x, p2pos.y, p2pos.z, '~w~[~b~E~w~] Arrastar')

                                if IsControlJustPressed(0, Config.DragControl) then
                                    drag = true
                                    draggingPed = p2
                                    draggingPlayer = Player

                                    while not HasAnimDictLoaded(Config.AnimDict) do
                                        RequestAnimDict(Config.AnimDict)
                                        Wait(0)
                                    end

                                    local duration = 5700
                                    TaskPlayAnim(p1, Config.AnimDict, 'injured_pickup_back_plyr', 2.0, 2.0, duration, 1, 0, false, false, false)
                                    TriggerServerEvent('icemallow-drag-server:attach', GetPlayerServerId(Player))
                                    Citizen.Wait(duration)
                                    animFinished = true
                                    TaskPlayAnim(p1, Config.AnimDict, 'injured_drag_plyr', 2.0, 2.0, -1, 1, 0, false, false, false)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local sleep = 500
    while true do
        Player = GetClosestPlayer()
        sleep = (Player == -1) and 500 or 1000
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local sleep = 5000
    while true do
        if drag and animFinished then
            local playerPed = PlayerPedId()
            sleep = 7

            if IsControlPressed(0, Config.TurnLeftControl) then
                SetEntityHeading(playerPed, GetEntityHeading(playerPed) + 0.5)
            elseif IsControlPressed(0, Config.TurnRightControl) then
                SetEntityHeading(playerPed, GetEntityHeading(playerPed) - 0.5)
            end

            if IsControlJustPressed(0, Config.ReleaseControl) then
                drag = false
                animFinished = false
                draggingPed = nil
                RequestAnimDict(Config.AnimDict)
                TaskPlayAnim(playerPed, Config.AnimDict, 'injured_putdown_plyr', 2.0, 2.0, 5500, 1, 0, false, false, false)
                TriggerServerEvent('icemallow-drag-server:deattach', GetPlayerServerId(draggingPlayer))
                draggingPlayer = nil
            end
        else
            sleep = 1000
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('icemallow-drag:attach')
AddEventHandler('icemallow-drag:attach', function(who)
    local p1 = PlayerPedId()
    local p2 = GetPlayerPed(GetPlayerFromServerId(who))
    local coords = GetEntityCoords(p1)
    local coords2 = GetEntityCoords(p2)

    SetEntityCoordsNoOffset(p1, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(p2), true, false)
    SetEntityHeading(p1, GetEntityHeading(p2))
    SetEntityHealth(p1, GetPedMaxHealth(p1))

    AttachEntityToEntity(p1, p2, 11816, 0.0, 0.5, 0.0, GetEntityRotation(coords2), false, false, true, false, 2, false)

    while not HasAnimDictLoaded(Config.AnimDict) do
        RequestAnimDict(Config.AnimDict)
        Wait(0)
    end

    TaskPlayAnim(p1, Config.AnimDict, 'injured_pickup_back_ped', 2.0, 2.0, -1, 1, 0, false, false, false)
    Citizen.Wait(5700)
    TaskPlayAnim(p1, Config.AnimDict, 'injured_drag_ped', 2.0, 2.0, -1, 1, 0, false, false, false)

    NotifyDeathStatus(false)
end)

RegisterNetEvent('icemallow-drag:deattach')
AddEventHandler('icemallow-drag:deattach', function(who)
    local p1 = PlayerPedId()

    RequestAnimDict(Config.AnimDict)
    TaskPlayAnim(p1, Config.AnimDict, 'injured_putdown_ped', 2.0, 2.0, 5700, 1, 0, false, false, false)

    Citizen.Wait(5700)

    DetachEntity(p1, true, true)
    SetEntityHealth(p1, 0)

    NotifyDeathStatus(true)
end)
