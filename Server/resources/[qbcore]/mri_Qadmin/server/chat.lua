local messages = {}
local playerRoles = {}

local function getPlayer(src)
    return QBCore.Functions.GetPlayer(tonumber(src))
end

local function getCitizenId(src, player)
    player = player or getPlayer(src)
    if player and player.PlayerData and player.PlayerData.citizenid then
        return tostring(player.PlayerData.citizenid)
    end
    return tostring(src)
end

local function getFullName(src, player)
    player = player or getPlayer(src)
    local data = player and player.PlayerData or {}
    local ci = data.charinfo or {}
    local first = ci.firstname or data.firstname
    local last = ci.lastname or data.lastname
    local name = ((first and tostring(first) or '') .. ' ' .. (last and tostring(last) or '')):gsub('^%s+', ''):gsub('%s+$', '')
    if name ~= '' then return name end
    return GetPlayerName(tonumber(src)) or ('ID ' .. tostring(src))
end

local function getPlayerRole(src, citizenid)
    local key = tostring(citizenid or src)
    if playerRoles[key] ~= nil then
        return playerRoles[key] or nil
    end

    local role = nil
    local passport = tonumber(citizenid)
    if passport and SeoulQAdminDB and SeoulQAdminDB.GetCharacterPermissionNames then
        local ok, groups = pcall(SeoulQAdminDB.GetCharacterPermissionNames, passport)
        if ok and type(groups) == 'table' then
            for _, group in ipairs(groups) do
                local name = tostring(group.name or group.Group or group.permission or group[1] or '')
                if name:lower() == 'admin' then role = 'Admin'; break end
                if not role and name ~= '' then role = name end
            end
        end
    end

    if not role and HasPerms(tonumber(src), 'qadmin.open') then
        role = 'Admin'
    end

    playerRoles[key] = role or false
    return role
end

local function notifyPlayers(src)
    local players = QBCore.Functions.GetPlayers() or {}
    for i = 1, #players do
        local p = players[i]
        if p ~= src and HasPerms(p, 'qadmin.page.staffchat') then
            QBCore.Functions.Notify(p, locale("notifications.new_staffchat"), "inform", 7500)
        end
    end
end

AddEventHandler('playerDropped', function()
    local src = source
    local cid = getCitizenId(src)
    playerRoles[cid] = nil
end)

local MAX_MESSAGE_LEN = 1000
local MAX_MENTIONS = 20
local CHAT_MIN_INTERVAL_MS = 750

RegisterNetEvent("mri_Qadmin:server:sendMessage", function(message, _unused, mentions)
    local src = source
    if not CheckPerms(src, 'qadmin.page.staffchat') then return end
    if not CheckPerms(src, 'qadmin.action.staff_chat_send') then return end
    if not RateLimit(src, 'chat_send', CHAT_MIN_INTERVAL_MS) then return end

    if type(message) ~= 'string' or message == '' then return end
    if #message > MAX_MESSAGE_LEN then message = message:sub(1, MAX_MESSAGE_LEN) end

    local player = getPlayer(src)
    local citizenid = getCitizenId(src, player)
    local fullname = getFullName(src, player)
    local role = getPlayerRole(src, citizenid)
    local createdAt = os.time() * 1000

    local newMsg = {
        id = #messages + 1,
        message = message,
        citizenid = citizenid,
        fullname = fullname,
        role = role,
        createdAt = createdAt,
        created_at = os.date('%Y-%m-%d %H:%M:%S')
    }

    messages[#messages + 1] = newMsg

    local ok, err = pcall(function()
        MySQL.insert.await('INSERT INTO mri_qadmin_chat (message, citizenid, fullname, role) VALUES (?, ?, ?, ?)', {
            message, citizenid, fullname, role
        })
    end)
    if not ok then
        print(('^3[mri_Qadmin]^7 Staff Chat: não consegui salvar no banco, mas a mensagem foi enviada. %s'):format(tostring(err)))
    end

    AddLog(src, 'mri_Qadmin', 'chat', 'info', ('[Staff Chat] %s: %s'):format(fullname, message), { citizenid = citizenid, role = role })
    notifyPlayers(src)

    local mentionSet = {}
    local mentionCount = 0
    if type(mentions) == 'table' then
        for _, cid in ipairs(mentions) do
            if mentionCount >= MAX_MENTIONS then break end
            if cid ~= nil then
                local key = tostring(cid)
                if #key > 0 and #key <= 64 then
                    mentionSet[key] = true
                    mentionCount = mentionCount + 1
                end
            end
        end
    end
    local hasMentions = next(mentionSet) ~= nil

    local players = QBCore.Functions.GetPlayers() or {}
    for i = 1, #players do
        local p = players[i]
        if HasPerms(p, 'qadmin.page.staffchat') then
            TriggerClientEvent('mri_Qadmin:client:newMessage', p, newMsg)
        end
        if hasMentions and p ~= src then
            local pcid = getCitizenId(p)
            if mentionSet[pcid] then
                TriggerClientEvent('mri_Qadmin:client:mentioned', p, fullname)
            end
        end
    end
end)

lib.callback.register('mri_Qadmin:callback:GetStaffPlayers', function(source)
    if not HasPerms(source, 'qadmin.page.staffchat') then return {} end
    local staff = {}
    local players = QBCore.Functions.GetPlayers() or {}
    for _, p in ipairs(players) do
        if HasPerms(p, 'qadmin.page.staffchat') then
            local player = getPlayer(p)
            staff[#staff + 1] = {
                citizenid = getCitizenId(p, player),
                name = getFullName(p, player),
                role = getPlayerRole(p, getCitizenId(p, player))
            }
        end
    end
    return staff
end)

lib.callback.register("mri_Qadmin:callback:GetMessages", function(source)
    if not HasPerms(source, 'qadmin.page.staffchat') then return {} end
    return messages
end)

local function normalizeChatRows(rows)
    local normalized = {}

    if type(rows) ~= 'table' then
        return normalized
    end

    for i = 1, #rows do
        local row = rows[i]
        if type(row) == 'table' then
            normalized[#normalized + 1] = {
                id = tonumber(row.id) or i,
                message = row.message or '',
                citizenid = tostring(row.citizenid or row.passport or row.identifier or ''),
                fullname = row.fullname or row.name or 'Staff',
                role = row.role,
                createdAt = row.createdAt or row.created_at or os.date('%Y-%m-%d %H:%M:%S'),
                created_at = row.created_at or row.createdAt or os.date('%Y-%m-%d %H:%M:%S')
            }
        end
    end

    return normalized
end

local function loadChatHistory()
    -- A SQL original do mri_Qadmin ordenava por `id`, mas a tabela padrão dele
    -- na Seoul foi criada sem coluna id. Aqui tentamos o formato novo primeiro
    -- e caímos para createdAt/created_at sem quebrar o start do painel.
    local queries = {
        "SELECT id, message, citizenid, fullname, role, createdAt, createdAt as created_at FROM mri_qadmin_chat ORDER BY id ASC LIMIT 200",
        "SELECT message, citizenid, fullname, role, createdAt, createdAt as created_at FROM mri_qadmin_chat ORDER BY createdAt ASC LIMIT 200",
        "SELECT message, citizenid, fullname, role, created_at, created_at as createdAt FROM mri_qadmin_chat ORDER BY created_at ASC LIMIT 200",
        "SELECT message, citizenid, fullname, role FROM mri_qadmin_chat LIMIT 200"
    }

    for i = 1, #queries do
        local ok, result = pcall(function()
            return MySQL.query.await(queries[i], {}) or {}
        end)

        if ok and type(result) == 'table' then
            return normalizeChatRows(result), true
        end
    end

    return {}, false
end

AddEventHandler('mri_Qadmin:db:ready', function()
    local loaded, ok = loadChatHistory()
    messages = loaded

    if ok then
        print(('^2[mri_Qadmin]^7 Staff Chat: histórico carregado (%d mensagens).'):format(#messages))
    else
        print('^3[mri_Qadmin]^7 Staff Chat: histórico não carregou, iniciando vazio.')
    end
end)
