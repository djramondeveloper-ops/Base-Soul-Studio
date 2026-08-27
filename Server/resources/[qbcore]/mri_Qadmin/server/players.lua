
local function getPlayers(page, pageSize, search)
    page = math.max(1, tonumber(page) or 1)
    pageSize = math.max(1, tonumber(pageSize) or 20)
    local offset = (page - 1) * pageSize

    local GetPlayers = QBCore.Functions.GetQBPlayers() or {}
    local allJobs = (GetResourceState('qbx_core') == 'started' and exports.qbx_core:GetJobs()) or QBCore.Shared.Jobs or {}

    local filteredOnlineIds = {}
    local lowerSearch = search and string.lower(tostring(search)) or nil
    local searchId = tonumber(search)

    for src, player in pairs(GetPlayers) do
        local sourceId = tonumber(src) or src
        local playerData = player.PlayerData
        if playerData and playerData.charinfo then
            local charinfo = playerData.charinfo
            local name = (charinfo.firstname or "N/A") .. ' ' .. (charinfo.lastname or "")
            local citizenid = tostring(playerData.citizenid or "N/A")
            local license = playerData.license or QBCore.Functions.GetIdentifier(sourceId, 'license')

            local match = true
            if lowerSearch and lowerSearch ~= "" then
                local nameMatch = string.find(string.lower(name), lowerSearch, 1, true)
                local licenseMatch = license and string.find(string.lower(license), lowerSearch, 1, true)
                local cidMatch = citizenid and string.find(string.lower(citizenid), lowerSearch, 1, true)
                local idMatch = searchId and (tonumber(sourceId) == searchId)
                if not (nameMatch or licenseMatch or cidMatch or idMatch) then
                    match = false
                end
            end

            if match then filteredOnlineIds[#filteredOnlineIds + 1] = sourceId end
        end
    end

    table.sort(filteredOnlineIds, function(a,b) return tonumber(a) < tonumber(b) end)

    local totalOnline = #filteredOnlineIds
    local resultPlayers = {}
    local onlineStartIndex = offset + 1
    local onlineEndIndex = offset + pageSize

    for i = onlineStartIndex, math.min(onlineEndIndex, totalOnline) do
        local src = filteredOnlineIds[i]
        local player = GetPlayers[src] or GetPlayers[tostring(src)]
        local playerData = player and player.PlayerData
        local charinfo = playerData and playerData.charinfo or {}
        local ped = GetPlayerPed(tonumber(src))

        resultPlayers[#resultPlayers + 1] = {
            id = tonumber(src),
            name = (charinfo.firstname or "N/A") .. ' ' .. (charinfo.lastname or ""),
            birthdate = charinfo.birthdate or "N/A",
            phone = charinfo.phone or "N/A",
            bucket = GetPlayerRoutingBucket(tonumber(src)),
            ping = GetPlayerPing(tonumber(src)),
            cid = tostring(playerData.citizenid or "N/A"),
            citizenid = tostring(playerData.citizenid or "N/A"),
            license = playerData.license or QBCore.Functions.GetIdentifier(tonumber(src), 'license'),
            license2 = QBCore.Functions.GetIdentifier(tonumber(src), 'license2'),
            discord = QBCore.Functions.GetIdentifier(tonumber(src), 'discord'),
            steam = QBCore.Functions.GetIdentifier(tonumber(src), 'steam'),
            fivem = QBCore.Functions.GetIdentifier(tonumber(src), 'fivem'),
            ip = QBCore.Functions.GetIdentifier(tonumber(src), 'ip'),
            job = playerData.job,
            gang = playerData.gang,
            money = (function()
                local m = {}
                for mk, mv in pairs(playerData.money or {}) do m[#m+1] = { name = mk, amount = mv } end
                return m
            end)(),
            health = ped and ped ~= 0 and GetEntityHealth(ped) or 0,
            armor = ped and ped ~= 0 and GetPedArmour(ped) or 0,
            vehicles = {},
            metadata = SeoulQAdminRuntime.NormalizeMetadataForSource(tonumber(src), playerData.metadata or {}),
            charinfo = charinfo,
            last_loggedout = nil,
            online = true
        }
    end

    local slotsRemaining = pageSize - #resultPlayers
    local dbOffset = math.max(0, offset - totalOnline)

    local onlineCids = {}
    for _, src in ipairs(filteredOnlineIds) do
        local player = GetPlayers[src] or GetPlayers[tostring(src)]
        local cid = player and player.PlayerData and tonumber(player.PlayerData.citizenid)
        if cid then onlineCids[#onlineCids + 1] = cid end
    end

    local cleanSearch = SanitizeLikeSearch(search, 64)
    local where = " WHERE c.Deleted = 0"
    local params = {}

    if cleanSearch ~= "" then
        local likePattern = "%" .. string.lower(cleanSearch) .. "%"
        where = where .. " AND (LOWER(CONCAT(c.Name, ' ', c.Lastname)) LIKE ? OR CAST(c.id AS CHAR) LIKE ? OR LOWER(c.License) LIKE ?)"
        params = { likePattern, likePattern, likePattern }
    end

    if #onlineCids > 0 then
        where = where .. " AND c.id NOT IN (?)"
        params[#params + 1] = onlineCids
    end

    local dbCount = MySQL.scalar.await("SELECT COUNT(*) FROM characters c" .. where, params) or 0
    local totalRecords = totalOnline + dbCount

    if slotsRemaining > 0 then
        local selectQuery = [[
            SELECT c.id, c.Name, c.Lastname, c.License, c.Bank, c.age, c.Sex, c.Created, c.Login,
                   p.phone_number as phone,
                   a.Banned, a.Reason
            FROM characters c
            LEFT JOIN phone_phones p ON p.owner_id = CONCAT('vrp:', c.id)
            LEFT JOIN accounts a ON a.License = c.License
        ]] .. where .. " GROUP BY c.id ORDER BY c.id ASC LIMIT ? OFFSET ?"

        local selectParams = { table.unpack(params) }
        selectParams[#selectParams + 1] = slotsRemaining
        selectParams[#selectParams + 1] = dbOffset

        local dbResults = MySQL.query.await(selectQuery, selectParams) or {}
        for _, row in ipairs(dbResults) do
            local charinfo = SeoulQAdminDB.MakeCharInfo(row, row.phone)
            local money = {
                { name = 'cash', amount = 0 },
                { name = 'bank', amount = tonumber(row.Bank) or 0 },
                { name = 'crypto', amount = 0 }
            }
            local ban
            local banned = tonumber(row.Banned or 0) or 0
            if banned == -1 or banned > os.time() then
                ban = { id = row.id, reason = row.Reason or '', expire = banned, bannedby = 'Seoul Admin', isPermanent = banned == -1 }
            end

            resultPlayers[#resultPlayers + 1] = {
                id = nil,
                bucket = nil,
                ping = nil,
                name = SeoulQAdminDB.GetCharacterName(row),
                license = row.License,
                job = { name = 'unemployed', label = 'Desempregado', grade = { name = '0', level = 0 } },
                gang = { name = 'none', label = 'Nenhum', grade = { name = '0', level = 0 } },
                money = money,
                phone = row.phone or "Desconhecido",
                birthdate = charinfo.birthdate,
                vehicles = {},
                metadata = {},
                charinfo = charinfo,
                citizenid = tostring(row.id),
                cid = tostring(row.id),
                last_loggedout = row.Login,
                online = false,
                ban = ban
            }
        end
    end

    if #resultPlayers > 0 then
        local passports, map = {}, {}
        for i, p in ipairs(resultPlayers) do
            local cid = tonumber(p.citizenid)
            if cid then passports[#passports + 1] = cid; map[tostring(cid)] = i end
            p.vehicles = p.vehicles or {}
        end

        if #passports > 0 then
            local vResults = MySQL.query.await('SELECT * FROM vehicles WHERE Passport IN (?)', { passports }) or {}
            for _, v in ipairs(vResults) do
                local idx = map[tostring(v.Passport)]
                if idx then
                    local model = v.Vehicle or 'N/A'
                    local vData = QBCore.Shared.Vehicles[model] or { name = model, brand = 'N/A', model = model }
                    table.insert(resultPlayers[idx].vehicles, {
                        cid = tostring(v.Passport),
                        label = vData.name or model,
                        brand = vData.brand or 'N/A',
                        model = model,
                        plate = v.Plate,
                        fuel = v.Fuel,
                        engine = v.Engine,
                        body = v.Body
                    })
                end
            end
        end
    end

    return { data = resultPlayers, total = totalRecords, pages = math.ceil(totalRecords / pageSize) }
end

_G.getPlayers = getPlayers

lib.callback.register('mri_Qadmin:callback:GetPlayers', function(src, page, limit, search)
    if not CheckPerms(src, 'qadmin.page.players') then return { players = {}, total = 0 } end
    return getPlayers(page, limit, search)
end)

RegisterNetEvent('mri_Qadmin:server:SetJob', function(_actionKey, selectedData)
    if not CheckPerms(source, 'qadmin.action.set_job') then return end
    local src = source

    local playerId = tonumber(GetValue(selectedData, "Player"))
    local Job = tostring(GetValue(selectedData, "Job") or '')
    local Grade = tonumber(GetValue(selectedData, "Grade")) or 1

    if not playerId then return QBCore.Functions.Notify(src, 'Player inválido.', 'error', 5000) end
    if Job == '' then return QBCore.Functions.Notify(src, 'Grupo inválido.', 'error', 5000) end
    if Grade < 1 or Grade > 100 then return QBCore.Functions.Notify(src, 'Nível inválido.', 'error', 5000) end
    Grade = math.floor(Grade)

    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player and not CheckTargetable(src, Player.PlayerData.source) then return end

    local passport = Player and tonumber(Player.PlayerData.citizenid) or tonumber(playerId)
    local char = SeoulQAdminDB.GetCharacter(passport)
    if not char then return QBCore.Functions.Notify(src, 'Passaporte não encontrado na tabela characters.', 'error', 5000) end

    local ok = SeoulQAdminRuntime.SetPermission(passport, Job, Grade)
    if not ok then return QBCore.Functions.Notify(src, 'Não foi possível setar o grupo da Seoul.', 'error', 5000) end

    local name = SeoulQAdminDB.GetCharacterName(char)
    QBCore.Functions.Notify(src, ('Grupo %s nível %s setado para %s.'):format(Job, Grade, name), 'success', 5000)
    AddLog(src, 'mri_Qadmin', 'permissions', 'warn', ('Grupo Seoul: %s recebeu %s nível %s'):format(name, Job, Grade), { target_citizenid = tostring(passport), group = Job, grade = Grade })
    TriggerClientEvent('mri_Qadmin:client:RefreshPlayers', src)
    BroadcastPermissionUpdate()
end)

-- Set Gang
RegisterNetEvent('mri_Qadmin:server:SetGang', function(_actionKey, selectedData)
    -- Na Seoul não existe separação QBCore real entre job/gang. Mantemos o botão funcionando como grupo vRP.
    if not CheckPerms(source, 'qadmin.action.set_gang') then return end
    local src = source

    local playerId = tonumber(GetValue(selectedData, "Player"))
    local Gang = tostring(GetValue(selectedData, "Gang") or '')
    local Grade = tonumber(GetValue(selectedData, "Grade")) or 1

    if not playerId then return QBCore.Functions.Notify(src, 'Player inválido.', 'error', 5000) end
    if Gang == '' or Gang == 'none' then return QBCore.Functions.Notify(src, 'Grupo inválido.', 'error', 5000) end
    if Grade < 1 or Grade > 100 then return QBCore.Functions.Notify(src, 'Nível inválido.', 'error', 5000) end
    Grade = math.floor(Grade)

    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player and not CheckTargetable(src, Player.PlayerData.source) then return end

    local passport = Player and tonumber(Player.PlayerData.citizenid) or tonumber(playerId)
    local char = SeoulQAdminDB.GetCharacter(passport)
    if not char then return QBCore.Functions.Notify(src, 'Passaporte não encontrado na tabela characters.', 'error', 5000) end

    local ok = SeoulQAdminRuntime.SetPermission(passport, Gang, Grade)
    if not ok then return QBCore.Functions.Notify(src, 'Não foi possível setar o grupo da Seoul.', 'error', 5000) end

    local name = SeoulQAdminDB.GetCharacterName(char)
    QBCore.Functions.Notify(src, ('Grupo %s nível %s setado para %s.'):format(Gang, Grade, name), 'success', 5000)
    AddLog(src, 'mri_Qadmin', 'permissions', 'warn', ('Grupo Seoul: %s recebeu %s nível %s'):format(name, Gang, Grade), { target_citizenid = tostring(passport), group = Gang, grade = Grade })
    TriggerClientEvent('mri_Qadmin:client:RefreshPlayers', src)
    BroadcastPermissionUpdate()
end)

-- Set Perms
-- SECURITY: ranks que escalam para god/admin do QBCore só podem ser atribuídos
-- por quem tem qadmin.master, senão um admin de tier médio promoveria players
-- ao god QBCore (que auto-sincroniza para o grupo "god" do Qadmin via
-- QBCoreAutoSync).
local ELEVATED_QBCORE_RANKS = { god = true, admin = true, superadmin = true }
RegisterNetEvent("mri_Qadmin:server:SetPerms", function(dataKey, selectedData)
    if not CheckPerms(source, 'qadmin.page.permissions') then return end
    local src = source
    local rank = GetValue(selectedData, "Permissions")
    local targetId = tonumber(GetValue(selectedData, "Player"))
    if not CheckTargetable(src, targetId) then return end
    local tPlayer = QBCore.Functions.GetPlayer(targetId)

    if not tPlayer then
        QBCore.Functions.Notify(src, locale("notifications.not_online"), "error", 5000)
        return
    end

    rank = tostring(rank or ''):lower()
    if rank == '' then
        QBCore.Functions.Notify(src, "Rank inválido.", "error", 5000)
        return
    end

    if ELEVATED_QBCORE_RANKS[rank] and not HasPerms(src, 'qadmin.master') then
        QBCore.Functions.Notify(src, "Apenas Master Admins podem atribuir o rank '" .. rank .. "'.", "error", 5000)
        AddLog(src, 'mri_Qadmin', 'players', 'error', ('Tentativa de escalada: %s tentou atribuir rank "%s"'):format(GetPlayerName(src), rank), { target = targetId, rank = rank })
        return
    end

    local name = tPlayer.PlayerData.charinfo.firstname .. ' ' .. tPlayer.PlayerData.charinfo.lastname
    local passport = tonumber(tPlayer.PlayerData.citizenid)

    SeoulQAdminRuntime.SetPermission(passport, rank, 1)
    QBCore.Functions.Notify(tPlayer.PlayerData.source, locale("notifications.player_perms", name, rank), 'success', 5000)
    local permLogData = GetTargetData(tonumber(targetId))
    permLogData.rank = rank
    AddLog(src, 'mri_Qadmin', 'permissions', 'warn', ('Permissão Seoul: %s recebeu grupo/permissão %s'):format(name, rank), permLogData)
    BroadcastPermissionUpdate()
end)

-- Remove Stress
RegisterNetEvent("mri_Qadmin:server:RemoveStress", function(dataKey, selectedData)
    if not CheckPerms(source, 'qadmin.action.remove_stress') then return end
    local src = source
    local playerOpt = GetValue(selectedData, 'Player (Optional)')
    local targetId = playerOpt and tonumber(playerOpt) or src
    if not CheckTargetable(src, tonumber(targetId)) then return end
    local tPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))

    if not tPlayer then
        QBCore.Functions.Notify(src, locale("notifications.not_online"), "error", 5000)
        return
    end

    TriggerClientEvent('mri_Qadmin:client:removeStress', targetId)

    QBCore.Functions.Notify(tPlayer.PlayerData.source, locale("notifications.removed_stress_player"), 'success', 5000)
    AddLog(src, 'mri_Qadmin', 'players', 'info', ('Stress removido de %s %s'):format(tPlayer.PlayerData.charinfo.firstname, tPlayer.PlayerData.charinfo.lastname), GetTargetData(tonumber(targetId)))
end)

-- Set Vital (Unified event for Health, Armor, Hunger, Thirst, Stress)
RegisterNetEvent("mri_Qadmin:server:SetVital", function(targetId, vital, value)
    -- Health usa revive perm (curar vida); demais vitals usam set_vital
    local requiredPerm = vital == 'health' and 'qadmin.action.revive' or 'qadmin.action.set_vital'
    if not CheckPerms(source, requiredPerm) then return end
    local src = source
    if not CheckTargetable(src, tonumber(targetId)) then return end
    local tPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))

    if not tPlayer then
        QBCore.Functions.Notify(src, locale("notifications.not_online"), "error", 5000)
        return
    end

    local numValue = tonumber(value)
    if not numValue then
        QBCore.Functions.Notify(src, "Valor de vital inválido.", "error", 5000)
        return
    end

    -- Clamp ranges para evitar valores absurdos / negativos
    local VITAL_RANGES = {
        health = { min = 0, max = 200 },
        armor  = { min = 0, max = 100 },
        hunger = { min = 0, max = 100 },
        thirst = { min = 0, max = 100 },
        stress = { min = 0, max = 100 },
    }
    local range = VITAL_RANGES[vital]
    if not range then
        QBCore.Functions.Notify(src, "Vital desconhecido: " .. tostring(vital), "error", 5000)
        return
    end
    if numValue < range.min then numValue = range.min end
    if numValue > range.max then numValue = range.max end
    value = numValue

    local ped = GetPlayerPed(tonumber(targetId))
    local okVital = SeoulQAdminRuntime.SetVital(tonumber(targetId), vital, numValue)
    if not okVital then
        return QBCore.Functions.Notify(src, "Não foi possível aplicar o vital na base Seoul.", "error", 5000)
    end
    if tPlayer.Functions and tPlayer.Functions.UpdatePlayerData then
        pcall(tPlayer.Functions.UpdatePlayerData)
    end

    local targetName = tPlayer.PlayerData.charinfo.firstname .. ' ' .. tPlayer.PlayerData.charinfo.lastname
    local vitalLogData = GetTargetData(tonumber(targetId))
    vitalLogData.vital = vital
    vitalLogData.value = value
    AddLog(src, 'mri_Qadmin', 'players', 'info', ('Vital: %s de %s definido para %s'):format(vital, targetName, value), vitalLogData)

    -- Broadcast update immediate to admins only
    local admins = GetAdminPlayers()
    for _, adminId in ipairs(admins) do
        TriggerClientEvent('mri_Qadmin:client:UpdatePlayerVitals', adminId, {
            id = tonumber(targetId),
            health = (vital == "health") and tonumber(value) or GetEntityHealth(ped),
            armor = (vital == "armor") and tonumber(value) or GetPedArmour(ped),
            metadata = SeoulQAdminRuntime.NormalizeMetadataForSource(tonumber(targetId), tPlayer.PlayerData.metadata)
        })
    end

    -- Notify staff
    QBCore.Functions.Notify(src, locale("vitals.set_success"):format(vital, value, targetId), "success")
end)

-- Helper to broadcast vitals/metadata updates to all admins
local function broadcastVitalsUpdate(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    if not player then return end

    local ped = GetPlayerPed(playerId)
    local admins = GetAdminPlayers()
    for _, adminId in ipairs(admins) do
        TriggerClientEvent('mri_Qadmin:client:UpdatePlayerVitals', adminId, {
            id = playerId,
            health = GetEntityHealth(ped),
            armor = GetPedArmour(ped),
            metadata = SeoulQAdminRuntime.NormalizeMetadataForSource(playerId, player.PlayerData.metadata)
        })
    end
end

-- Sync Vitals from Client (e.g., from HUD events)
RegisterNetEvent("mri_Qadmin:server:SyncVitals", function(vitals)
    local src = source
    if not CheckPerms(src, 'qadmin.open') then return end

    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    -- This is now a simple broadcast bridge for admins.
    -- Dynamic data (health/armor) is fetched from ped for security.

    local metadataClone = SeoulQAdminRuntime.NormalizeMetadataForSource(src, player.PlayerData.metadata)
    for k, v in pairs(vitals) do
        metadataClone[k] = tonumber(v)
    end

    local admins = GetAdminPlayers()
    for _, adminId in ipairs(admins) do
        TriggerClientEvent('mri_Qadmin:client:UpdatePlayerVitals', adminId, {
            id = src,
            health = GetEntityHealth(GetPlayerPed(src)),
            armor = GetPedArmour(GetPlayerPed(src)),
            metadata = metadataClone
        })
    end
end)

-- Sync Death Status from Client
RegisterNetEvent('mri_Qadmin:server:SyncDeathStatus', function(isDead)
    local src = source
    if not RateLimit(src, 'sync_death', 500) then return end
    -- Espelha o gate isAdminPlayer do client (client/main.lua): só quem tem
    -- acesso ao painel sincroniza status de morte. Sem isto, qualquer client
    -- não-admin dispara o net event direto e forja/limpa o próprio isdead.
    if not HasPerms(src, 'qadmin.open') then return end
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    -- Coerce para boolean — qualquer outra coisa é rejeitada.
    if type(isDead) ~= 'boolean' then return end

    -- Sync to metadata for standard QBCore compatibility
    player.Functions.SetMetaData("isdead", isDead)
end)

-- Real-time Metadata Sync
AddEventHandler('QBCore:Server:SetMetaData', function(source, meta, value)
    local src = source
    if meta == 'hunger' or meta == 'thirst' or meta == 'stress' or meta == 'isdead' then
        Debug('debug', ('[mri_Qadmin] SetMetaData detectado para ID: %s'):format(tostring(src)))
        broadcastVitalsUpdate(src)
    end
end)

-- StateBag handlers for universal death status coverage
local function GetPlayerFromBagName(bagName)
    local playerHandle = bagName:gsub('player:', '')
    return tonumber(playerHandle)
end

AddStateBagChangeHandler("dead", nil, function(bagName, _, _, _, _)
    local playerId = GetPlayerFromBagName(bagName)
    if not playerId then return end
    broadcastVitalsUpdate(playerId)
end)

AddStateBagChangeHandler("isdead", nil, function(bagName, _, _, _, _)
    local playerId = GetPlayerFromBagName(bagName)
    if not playerId then return end
    broadcastVitalsUpdate(playerId)
end)
