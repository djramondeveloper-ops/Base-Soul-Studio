if Config.JailScript ~= 'vrp' then return end

local PRISON_INSIDE = vec3(1691.54, 2566.08, 45.56)

function JailPlayer(identifier, time, reason, officerSource)
    local id = tonumber(identifier)
    local minutes = math.max(1, math.floor((tonumber(time) or 60) / 60))
    if not id then return false end

    local identity = vRP.Identity(id)
    if not identity then return false end

    vRP.InsertPrison(id, minutes)

    local target = vRP.Source(id)
    if target then
        vRP.Teleport(target, PRISON_INSIDE.x, PRISON_INSIDE.y, PRISON_INSIDE.z)
        Player(target).state.Prison = true
        TriggerClientEvent('prison:Prisioner', target, true)
        TriggerClientEvent(
            'Notify',
            target,
            'Penitenciária de Bolingbroke',
            ('Você foi preso por %d minutos.'):format(minutes),
            'policia',
            10000
        )
    end

    return true
end

function UnjailPlayer(identifier)
    local id = tonumber(identifier)
    local identity = id and vRP.Identity(id)
    if not identity then return false end

    local current = tonumber(identity.Prison) or 0
    if current > 0 then vRP.UpdatePrison(id, current) end

    local target = vRP.Source(id)
    if target then
        Player(target).state.Prison = false
        TriggerClientEvent('prison:Prisioner', target, false)
    end

    return true
end

function GetRemainingPrisonSentence(identifier)
    local identity = vRP.Identity(tonumber(identifier))
    return identity and ((tonumber(identity.Prison) or 0) * 60) or 0
end

-- Seoul integration: the Arius police resource uses the same real jail adapter as the Tablet.
exports('JailPlayer', JailPlayer)
