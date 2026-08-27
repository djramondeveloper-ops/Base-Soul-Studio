if SeoulScriptsServer and not SeoulScriptsServer.Enabled('ArmBraker') then return end
local sessions = ArmBrakerConfig.sessions

local function resetSession(index)
    local session = sessions[index]
    if not session then return end
    if session.place1 and session.place1 ~= 0 and GetPlayerName(session.place1) then
        TriggerClientEvent('ArmBraker:reset_cl', session.place1)
    end
    if session.place2 and session.place2 ~= 0 and GetPlayerName(session.place2) then
        TriggerClientEvent('ArmBraker:reset_cl', session.place2)
    end
    session.started = false
    session.place1 = 0
    session.place2 = 0
    session.grade = 0.5
end

local function playerInSession(src, session)
    return session and (session.place1 == src or session.place2 == src)
end

local function isNearTable(src, session)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - vec3(session.x, session.y, session.z)) < 2.0
end

RegisterNetEvent('ArmBraker:check_sv')
AddEventHandler('ArmBraker:check_sv', function(position)
    local src = source
    if SeoulScriptsServer and not SeoulScriptsServer.Passport(src) then return end
    for k,v in pairs(sessions) do
        if playerInSession(src, v) then return end
        if isNearTable(src, v) then
            if sessions[k].place1 == 0 and not sessions[k].started then
                sessions[k].place1 = src
                TriggerClientEvent('ArmBraker:check_cl', src, 'place1')
            elseif sessions[k].place2 == 0 and sessions[k].place1 ~= 0 then
                if not GetPlayerName(sessions[k].place1) then
                    resetSession(k)
                    sessions[k].place1 = src
                    TriggerClientEvent('ArmBraker:check_cl', src, 'place1')
                    return
                end
                if GetPlayerRoutingBucket(src) ~= GetPlayerRoutingBucket(sessions[k].place1) then
                    TriggerClientEvent('ArmBraker:check_cl', src, 'noplace')
                    return
                end
                sessions[k].place2 = src
                TriggerClientEvent('ArmBraker:check_cl', src, 'place2')
            else
                TriggerClientEvent('ArmBraker:check_cl', src, 'noplace')
                return
            end

            if sessions[k].place1 ~= 0 and sessions[k].place2 ~= 0 and not sessions[k].started then
                sessions[k].started = true
                TriggerClientEvent('ArmBraker:start_cl', sessions[k].place1)
                TriggerClientEvent('ArmBraker:start_cl', sessions[k].place2)
                break
            end
        end
    end
end)


RegisterNetEvent('ArmBraker:updategrade_sv')
AddEventHandler('ArmBraker:updategrade_sv', function(gradeUpValue)
    local src = source
    for k,v in pairs(sessions) do
        if v.place1 == src or v.place2 == src then
            if not v.started then return end
            v.grade = v.grade + (tonumber(gradeUpValue) or 0.0)
            if v.grade <= 0.10 then
                v.grade = -999
            elseif v.grade >= 0.90 then
                v.grade = 999
            end
            TriggerClientEvent('ArmBraker:updategrade_cl', v.place1, v.grade)
            TriggerClientEvent('ArmBraker:updategrade_cl', v.place2, v.grade)
            break
        end
    end
end)

RegisterNetEvent('ArmBraker:disband_sv')
AddEventHandler('ArmBraker:disband_sv', function(position)
    local src = source
    for k,v in pairs(sessions) do
        if playerInSession(src, v) then
            resetSession(k)
            break
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for k,v in pairs(sessions) do
        if playerInSession(src, v) then
            resetSession(k)
        end
    end
end)
