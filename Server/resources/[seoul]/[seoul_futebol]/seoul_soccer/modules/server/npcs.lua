-- Seoul Soccer - NPCs persistentes via OneSync/server-side
-- Mantem os NPCs fora do ciclo de cleanup de entidades locais do client.

local SoccerNpcEntities = {}
local SoccerNpcRequestCooldown = {}

local function ValidNpcConfig(pitch)
    if type(pitch) ~= "table" or not pitch.id then return false end
    local npc = pitch.npc
    if type(npc) ~= "table" or npc.enabled ~= true then return false end
    local c = npc.coords
    if not c or type(c.x) ~= "number" or type(c.y) ~= "number" or type(c.z) ~= "number" then
        return false
    end
    return npc.model ~= nil
end

local function SafeDelete(entity)
    if entity and entity ~= 0 and DoesEntityExist(entity) then
        pcall(DeleteEntity, entity)
    end
end

local function GetNpcNetId(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return 0 end
    local ok, netId = pcall(NetworkGetNetworkIdFromEntity, entity)
    if not ok then return 0 end
    return tonumber(netId) or 0
end

local function SnapshotNpcNetIds()
    local snapshot = {}
    for pitchId, data in pairs(SoccerNpcEntities) do
        if data.entity and DoesEntityExist(data.entity) then
            local netId = GetNpcNetId(data.entity)
            if netId > 0 then
                snapshot[pitchId] = netId
                data.netId = netId
            end
        end
    end
    return snapshot
end

local function BroadcastNpcState(target)
    TriggerClientEvent("seoul_soccer:client:SyncNpcs", target or -1, SnapshotNpcNetIds())
end

local function CreateNpcForPitch(pitch)
    if not ValidNpcConfig(pitch) then return nil end

    local old = SoccerNpcEntities[pitch.id]
    if old and old.entity and DoesEntityExist(old.entity) then
        local netId = GetNpcNetId(old.entity)
        if netId > 0 then
            old.netId = netId
            return old
        end
        SafeDelete(old.entity)
    end

    local npc = pitch.npc
    local c = npc.coords
    local heading = tonumber(c.w) or tonumber(c.heading) or 0.0
    local modelHash = type(npc.model) == "number" and npc.model or GetHashKey(tostring(npc.model))

    local ped = CreatePed(4, modelHash, c.x, c.y, c.z, heading, true, true)
    if not ped or ped == 0 then
        print(("[seoul_soccer] ERRO: servidor nao conseguiu criar NPC %s"):format(tostring(pitch.id)))
        return nil
    end

    local deadline = GetGameTimer() + 5000
    while not DoesEntityExist(ped) and GetGameTimer() < deadline do
        Wait(50)
    end

    if not DoesEntityExist(ped) then
        print(("[seoul_soccer] ERRO: NPC %s nao materializou no OneSync"):format(tostring(pitch.id)))
        SafeDelete(ped)
        return nil
    end

    -- KeepEntity: garante persistencia server-side mesmo sem player em scope.
    pcall(SetEntityOrphanMode, ped, 2)
    pcall(SetEntityHeading, ped, heading)
    pcall(FreezeEntityPosition, ped, true)
    pcall(SetEntityInvincible, ped, true)
    pcall(SetBlockingOfNonTemporaryEvents, ped, true)

    local netId = 0
    deadline = GetGameTimer() + 5000
    repeat
        netId = GetNpcNetId(ped)
        if netId > 0 then break end
        Wait(50)
    until GetGameTimer() >= deadline

    if netId <= 0 then
        print(("[seoul_soccer] ERRO: NPC %s criado sem network id"):format(tostring(pitch.id)))
        SafeDelete(ped)
        return nil
    end

    local data = {
        entity = ped,
        netId = netId,
        pitchId = pitch.id,
    }
    SoccerNpcEntities[pitch.id] = data

    print(("[seoul_soccer] NPC networkado criado: %s (netId %s) em %.4f, %.4f, %.4f"):format(
        tostring(pitch.id), tostring(netId), c.x, c.y, c.z
    ))

    return data
end

local function EnsureAllSoccerNpcs()
    if type(Config.Pitches) ~= "table" then return end
    local changed = false

    for _, pitch in ipairs(Config.Pitches) do
        if ValidNpcConfig(pitch) then
            local current = SoccerNpcEntities[pitch.id]
            if not current or not current.entity or not DoesEntityExist(current.entity) then
                SoccerNpcEntities[pitch.id] = nil
                if CreateNpcForPitch(pitch) then changed = true end
            end
        end
    end

    if changed then
        BroadcastNpcState(-1)
    end
end

RegisterNetEvent("seoul_soccer:server:RequestNpcs", function()
    local src = source
    if not src or src <= 0 then return end

    local now = GetGameTimer()
    local last = SoccerNpcRequestCooldown[src] or 0
    if now - last < 1500 then return end
    SoccerNpcRequestCooldown[src] = now

    EnsureAllSoccerNpcs()
    BroadcastNpcState(src)
end)

AddEventHandler("playerDropped", function()
    SoccerNpcRequestCooldown[source] = nil
end)

CreateThread(function()
    -- Aguarda a inicializacao do resource/OneSync antes de criar os NPCs.
    Wait(1000)
    EnsureAllSoccerNpcs()

    while true do
        Wait(10000)
        EnsureAllSoccerNpcs()
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for _, data in pairs(SoccerNpcEntities) do
        SafeDelete(data.entity)
    end
end)
