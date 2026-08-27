-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMINCONTROL BRIDGE - FASE 5 REAL
-- Ponte segura e reversível: lê BaseConfig/Groups do AdminControl, aplica tema/runtime, injeta grupos, entrada/whitelist/manutenção e AutoReload real.
-- Não roda wipe e não altera banco automaticamente. AutoReload executa comando real de encerramento/restart quando habilitado.
-----------------------------------------------------------------------------------------------------------------------------------------
Seoul = Seoul or {}
Reborn = Reborn or Seoul

local Bridge = {
    base = {},
    nativeGroups = {},
    controlGroups = {},
    mergedGroups = {},
    lastReload = 0,
    lastError = nil,
    adminControlState = "unknown",
    controlGroupCount = 0,
    nativeGroupCount = 0,
    mergedGroupCount = 0,
    injectedGroupCount = 0,
    updatedGroupCount = 0,
    removedGroupCount = 0,
    skippedNativeGroupCount = 0,
    groupSyncStatus = "pending",
    autoReload = {
        running = false,
        reason = nil,
        startedAt = 0,
        endsAt = 0,
        lastTimerKey = nil,
        lastTimerDate = nil,
        lastRecurringAt = os.time(),
        sentMilestones = {},
        simulation = false,
        lastResult = "pending"
    },
    themeCore = {
        lastStatus = "pending",
        lastColor = nil,
        lastRuntimeMain = nil,
        lastGlobalChanged = false,
        lastGlobalBackup = nil,
        lastGlobalError = nil,
        lastReplacements = 0,
        lastAppliedAt = 0
    },
    serverIdentity = {
        lastStatus = "pending",
        lastError = nil,
        lastAppliedAt = 0,
        lastReason = nil,
        hostname = nil,
        projectName = nil,
        projectDesc = nil,
        tags = nil,
        locale = nil,
        discord = nil,
        bannerConnecting = nil,
        bannerDetail = nil,
        commandCount = 0
    }
}

local function isDebug()
    local value = tostring(GetConvar("seoul:debug", "false")):lower()
    return value == "true" or value == "1" or value == "yes" or value == "sim"
end

local function log(message)
    if isDebug() then
        print(("^2[Seoul AdminControl]^7 %s"):format(tostring(message)))
    end
end

local function warn(message)
    if isDebug() then
        print(("^3[Seoul AdminControl]^7 %s"):format(tostring(message)))
    end
end

local function err(message)
    print(("^1[Seoul AdminControl]^7 %s"):format(tostring(message)))
end

local function toNumber(value, fallback)
    local number = tonumber(value)
    if number == nil then return fallback end
    return number
end

local function toBoolean(value, fallback)
    if type(value) == "boolean" then return value end
    if type(value) == "number" then return value ~= 0 end
    if type(value) == "string" then
        local lowered = value:lower()
        if lowered == "true" or lowered == "1" or lowered == "yes" or lowered == "sim" then return true end
        if lowered == "false" or lowered == "0" or lowered == "no" or lowered == "nao" or lowered == "não" then return false end
    end
    return fallback
end

local function deepCopy(value, seen)
    if type(value) ~= "table" then return value end
    if seen and seen[value] then return seen[value] end
    local result = {}
    seen = seen or {}
    seen[value] = result
    for key, item in pairs(value) do
        result[deepCopy(key, seen)] = deepCopy(item, seen)
    end
    return result
end

local function tableCount(value)
    if type(value) ~= "table" then return 0 end
    local amount = 0
    for _ in pairs(value) do amount = amount + 1 end
    return amount
end

local function normalizeHex(value, fallback)
    value = tostring(value or "")
    local hex = value:match("#%x%x%x%x%x%x")
    if hex then return hex end

    local r, g, b = value:match("rgb%((%d+)%s*,%s*(%d+)%s*,%s*(%d+)%)")
    if r and g and b then
        return string.format("#%02X%02X%02X", math.max(0, math.min(255, tonumber(r) or 0)), math.max(0, math.min(255, tonumber(g) or 0)), math.max(0, math.min(255, tonumber(b) or 0)))
    end

    return fallback or "#1EA1DA"
end

local function hexToRgbString(hex)
    hex = normalizeHex(hex, "#1EA1DA")
    local r = tonumber(hex:sub(2, 3), 16) or 30
    local g = tonumber(hex:sub(4, 5), 16) or 161
    local b = tonumber(hex:sub(6, 7), 16) or 218
    return ("rgb(%s, %s, %s)"):format(r, g, b)
end

local function compactString(value, fallback)
    local text = tostring(value or "")
    text = text:gsub("\r", " "):gsub("\n", " "):gsub("\t", " ")
    text = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if text == "" then return fallback or "" end
    return text
end

local function firstNonEmpty(...)
    for i = 1, select("#", ...) do
        local value = compactString(select(i, ...), "")
        if value ~= "" and value ~= "nil" then return value end
    end
    return ""
end

local function commandValue(value)
    local text = compactString(value, "")
    -- Evita quebrar o parser do console com aspas/quebras de linha.
    text = text:gsub('"', "'")
    return text
end

local function getConvarSafe(name, fallback)
    local ok, result = pcall(GetConvar, tostring(name), tostring(fallback or ""))
    if ok then return compactString(result, fallback or "") end
    return fallback or ""
end


local function removeManagedThemeCoreBlock(raw)
    raw = tostring(raw or "")
    local cleaned = raw:gsub("\n?%-%- SEOUL ADMINCONTROL THEME CORE START[%s%S]-%-%- SEOUL ADMINCONTROL THEME CORE END\n?", "\n")
    return cleaned
end

local function buildManagedThemeCoreBlock(base)
    local primary = normalizeHex(base and (base.CityColorHex or base.CityColor), "#1EA1DA")
    return ([=[
-- SEOUL ADMINCONTROL THEME CORE START
-- Gerado automaticamente pelo AdminControl. Não edite este bloco manualmente.
do
    local primary = "%s"

    Theme = Theme or {}
    Theme.main = primary
    Theme.common = primary
    Theme.mainText = Theme.mainText or "#ffffff"

    Theme.accept = type(Theme.accept) == "table" and Theme.accept or {}
    Theme.accept.background = primary
    Theme.accept.letter = Theme.accept.letter or "#dcffe9"

    Theme.hud = type(Theme.hud) == "table" and Theme.hud or {}
    Theme.hud.health = primary
    Theme.hud.progress = type(Theme.hud.progress) == "table" and Theme.hud.progress or {}
    Theme.hud.progress.circle = primary
end
-- SEOUL ADMINCONTROL THEME CORE END
]=]):format(primary)
end

local function replaceManagedThemeValues(raw, primary)
    raw = tostring(raw or "")
    primary = normalizeHex(primary, "#1EA1DA")

    local startAt, afterHeader = raw:find("Theme%s*=%s*{")
    if not startAt then return raw, 0 end

    local openAt = raw:find("{", afterHeader - 1, true)
    if not openAt then return raw, 0 end

    local depth = 0
    local closeAt = nil
    for i = openAt, #raw do
        local char = raw:sub(i, i)
        if char == "{" then
            depth = depth + 1
        elseif char == "}" then
            depth = depth - 1
            if depth == 0 then
                closeAt = i
                break
            end
        end
    end

    if not closeAt then return raw, 0 end

    local before = raw:sub(1, startAt - 1)
    local block = raw:sub(startAt, closeAt)
    local after = raw:sub(closeAt + 1)
    local total = 0
    local count = 0

    block, count = block:gsub('([\n\r]%s*main%s*=%s*")[^"]*(")', '%1'..primary..'%2', 1)
    total = total + count
    block, count = block:gsub('([\n\r]%s*common%s*=%s*")[^"]*(")', '%1'..primary..'%2', 1)
    total = total + count
    block, count = block:gsub('(accept%s*=%s*{[%s%S]-background%s*=%s*")[^"]*(")', '%1'..primary..'%2', 1)
    total = total + count
    block, count = block:gsub('(hud%s*=%s*{[%s%S]-health%s*=%s*")[^"]*(")', '%1'..primary..'%2', 1)
    total = total + count
    block, count = block:gsub('(progress%s*=%s*{[%s%S]-circle%s*=%s*")[^"]*(")', '%1'..primary..'%2', 1)
    total = total + count

    return before..block..after, total
end

local function syncGlobalLuaTheme(base, reason)
    base = type(base) == "table" and base or {}
    local primary = normalizeHex(base.CityColorHex or base.CityColor, "#1EA1DA")
    local resource = GetCurrentResourceName()
    local path = "config/Global.lua"

    Bridge.themeCore.lastColor = primary
    Bridge.themeCore.lastAppliedAt = os.time()
    Bridge.themeCore.lastGlobalError = nil

    local okLoad, raw = pcall(LoadResourceFile, resource, path)
    if not okLoad or not raw or raw == "" then
        Bridge.themeCore.lastStatus = "erro"
        Bridge.themeCore.lastGlobalChanged = false
        Bridge.themeCore.lastGlobalError = "Não foi possível ler vrp/config/Global.lua"
        Bridge.lastError = Bridge.themeCore.lastGlobalError
        return false
    end

    local normalizedRaw = raw:gsub("\r\n", "\n")
    local withoutManagedBlock = removeManagedThemeCoreBlock(normalizedRaw)
    local replacedRaw, replacements = replaceManagedThemeValues(withoutManagedBlock, primary)

    if replacedRaw:sub(-1) ~= "\n" then replacedRaw = replacedRaw.."\n" end
    local finalRaw = replacedRaw.."\n"..buildManagedThemeCoreBlock(base)

    Bridge.themeCore.lastReplacements = tonumber(replacements or 0) or 0

    if finalRaw == normalizedRaw then
        Bridge.themeCore.lastStatus = "ok"
        Bridge.themeCore.lastGlobalChanged = false
        Bridge.themeCore.lastGlobalBackup = Bridge.themeCore.lastGlobalBackup
        return true
    end

    local backupPath = ("config/Global.lua.seoul-theme-%s.bak"):format(os.date("%Y%m%d-%H%M%S"))
    local okBackup = pcall(SaveResourceFile, resource, backupPath, raw, -1)
    if okBackup then Bridge.themeCore.lastGlobalBackup = backupPath end

    local okSave, saveResult = pcall(SaveResourceFile, resource, path, finalRaw, -1)
    if not okSave or saveResult == false then
        Bridge.themeCore.lastStatus = "erro"
        Bridge.themeCore.lastGlobalChanged = false
        Bridge.themeCore.lastGlobalError = "Falha ao salvar vrp/config/Global.lua"
        Bridge.lastError = Bridge.themeCore.lastGlobalError
        return false
    end

    Bridge.themeCore.lastStatus = "ok"
    Bridge.themeCore.lastGlobalChanged = true
    log(("Theme Core sincronizado no Global.lua%s. Cor: %s | campos: %s | backup: %s"):format(
        reason and (" ("..tostring(reason)..")") or "",
        tostring(primary),
        tostring(Bridge.themeCore.lastReplacements),
        tostring(Bridge.themeCore.lastGlobalBackup or "não criado")
    ))

    return true
end

local function safeGet(root, ...)
    local current = root
    for i = 1, select("#", ...) do
        if type(current) ~= "table" then return nil end
        current = current[select(i, ...)]
    end
    return current
end

local function adminControlStarted()
    local state = GetResourceState("AdminControl")
    Bridge.adminControlState = state
    return state == "started"
end

local function reloadAdminControlCache()
    if not adminControlStarted() then return false end

    -- Chamada direta do export. Não checar exports[resource].Function antes,
    -- porque no FiveM isso pode retornar nil mesmo com o export válido.
    local ok, result = pcall(function()
        return exports["AdminControl"]:ReloadControlFiles()
    end)

    if not ok then
        Bridge.lastError = "Falha ao limpar cache do AdminControl: "..tostring(result)
        return false
    end

    return result == true
end

local function readControlFileDirect(file)
    if not adminControlStarted() then return nil end

    local ok, raw = pcall(LoadResourceFile, "AdminControl", "data/"..tostring(file)..".json")
    if not ok or not raw or raw == "" then return nil end

    local decodedOk, decoded = pcall(json.decode, raw)
    if decodedOk and type(decoded) == "table" then
        return decoded
    end

    Bridge.lastError = ("Falha ao decodificar AdminControl/data/%s.json diretamente do disco."):format(tostring(file))
    return nil
end

local function getControlFile(file)
    if not adminControlStarted() then
        Bridge.lastError = "AdminControl não iniciado. Usando fallback da Seoul."
        return {}
    end

    -- Para reload runtime, ler direto do disco evita cache antigo do AdminControl após criar/editar grupo.
    local direct = readControlFileDirect(file)
    if direct then
        return direct
    end

    local ok, result = pcall(function()
        return exports["AdminControl"]:GetControlFile(file)
    end)

    if not ok then
        Bridge.lastError = ("Falha ao ler AdminControl/data/%s.json: %s"):format(tostring(file), tostring(result))
        return {}
    end

    if type(result) ~= "table" then
        Bridge.lastError = ("AdminControl/data/%s.json retornou %s. Usando fallback."):format(tostring(file), type(result))
        return {}
    end

    return result
end

local function normalizeBaseConfig(raw)
    raw = type(raw) == "table" and raw or {}

    local needs = type(raw.Needs) == "table" and raw.Needs or {}
    local npc = type(raw.NpcControl) == "table" and raw.NpcControl or {}
    local maintenance = type(raw.Maintenance) == "table" and raw.Maintenance or {}
    local autoReload = type(raw.AutoReload) == "table" and raw.AutoReload or {}
    local wipe = type(raw.Wipe) == "table" and raw.Wipe or {}
    local identity = type(raw.Identity) == "table" and raw.Identity or {}

    local serverName = firstNonEmpty(raw.ServerName, identity.ServerName, ServerName, "Seoul")
    local projectName = firstNonEmpty(raw.ProjectName, raw.Project, identity.ProjectName, getConvarSafe("sv_projectName", ""), serverName)
    local projectDesc = firstNonEmpty(raw.ProjectDesc, raw.ProjectDescription, raw.Description, identity.ProjectDesc, identity.ProjectDescription, getConvarSafe("sv_projectDesc", ""), serverName)
    local tags = firstNonEmpty(raw.Tags, raw.ServerTags, identity.Tags, getConvarSafe("tags", ""))
    local locale = firstNonEmpty(raw.Locale, identity.Locale, getConvarSafe("locale", "pt-BR"))
    local discord = firstNonEmpty(raw.Discord, identity.Discord, ServerLink, "")

    local base = {
        ServerName = serverName,
        ProjectName = projectName,
        ProjectDesc = projectDesc,
        Tags = tags,
        Locale = locale,
        BannerConnecting = firstNonEmpty(raw.BannerConnecting, identity.BannerConnecting, getConvarSafe("banner_connecting", "")),
        BannerDetail = firstNonEmpty(raw.BannerDetail, identity.BannerDetail, getConvarSafe("banner_detail", "")),
        Discord = discord,
        Theme = tostring(raw.Theme or "default"),
        CityColorHex = normalizeHex(raw.CityColorHex or raw.CityColor, "#1EA1DA"),
        CityColor = tostring(raw.CityColor or hexToRgbString(raw.CityColorHex or "#1EA1DA")),
        CityLogo = tostring(raw.CityLogo or ""),
        ImageSize = toNumber(raw.ImageSize or raw.CityLogoSize, 1.0),
        Identifier = tostring(raw.Identifier or BaseMode or "license"),
        Whitelist = toBoolean(raw.Whitelist, Whitelisted or false),
        MaxHealth = toNumber(raw.MaxHealth, 400),
        Debug = toBoolean(raw.Debug, false),
        Needs = {
            Tempo = math.max(1, math.floor(toNumber(needs.Tempo, 90))),
            Fome = math.max(0, toNumber(needs.Fome, 2)),
            Sede = math.max(0, toNumber(needs.Sede, 1))
        },
        NpcControl = {
            PedDensity = math.max(0.0, math.min(0.99, toNumber(npc.PedDensity, 0.5))),
            VehicleDensity = math.max(0.0, math.min(0.99, toNumber(npc.VehicleDensity, 0.4))),
            ParkedVehicle = math.max(0.0, math.min(0.99, toNumber(npc.ParkedVehicle, 0.4)))
        },
        Maintenance = {
            enabled = toBoolean(maintenance.enabled, MaintenanceEnabled or false),
            text = tostring(maintenance.text or "Servidor em manutenção"),
            licenses = type(maintenance.licenses) == "table" and maintenance.licenses or (type(Maintenance) == "table" and Maintenance or {})
        },
        AutoReload = {
            Enabled = toBoolean(autoReload.Enabled, false),
            RecurringTime = toNumber(autoReload.RecurringTime, 12 * 60 * 60 * 1000),
            Timers = type(autoReload.Timers) == "table" and autoReload.Timers or {},
            Warning = type(autoReload.Warning) == "table" and autoReload.Warning or {},
            Simulation = false,
            ExecuteCommand = tostring(autoReload.ExecuteCommand or autoReload.Command or "quit")
        },
        Wipe = {
            Password = tostring(wipe.Password or "Seoul"),
            StartId = math.max(1, math.floor(toNumber(wipe.StartId, 1))),
            StartBank = math.max(0, math.floor(toNumber(wipe.StartBank, 0)))
        }
    }

    return base
end

local illegalKeywords = {
    ballas = true,
    vagos = true,
    families = true,
    mafia = true,
    ["máfia"] = true,
    milicia = true,
    ["milícia"] = true,
    faccao = true,
    ["facção"] = true,
    gang = true,
    cartel = true,
    motoclub = true,
    lester = true,
    azuis = true,
    vermelhos = true,
    verdes = true,
    roxos = true,
    amarelos = true,
    cv = true,
    tcp = true,
    ada = true,
    pcc = true
}

local function groupLooksIllegal(name, data)
    local text = tostring(name or ""):lower()
    local typeText = tostring(type(data) == "table" and (data.Type or data.type or data.Category or "") or ""):lower()

    if typeText == "gang" or typeText == "illegal" or typeText == "ilegal" or typeText == "facção" or typeText == "faccao" then
        return true
    end

    for keyword in pairs(illegalKeywords) do
        if text:find(keyword, 1, true) then
            return true
        end
    end

    if type(data) == "table" and (data.Domination or data.Chest or data.OrgPanel) and not (data.Salary or data.Banned) then
        return true
    end

    return false
end

local function normalizeHierarchy(hierarchy)
    local result = {}
    if type(hierarchy) ~= "table" then return result end

    for level, entry in ipairs(hierarchy) do
        if type(entry) == "table" then
            result[#result + 1] = {
                Title = tostring(entry.Title or entry.Name or entry.Group or ("Cargo "..level)),
                Group = tostring(entry.Group or ""),
                Leader = entry.Leader == true,
                Permission = type(entry.Permission) == "table" and deepCopy(entry.Permission) or {}
            }
        else
            result[#result + 1] = {
                Title = tostring(entry),
                Group = "",
                Leader = level == 1,
                Permission = {}
            }
        end
    end

    return result
end

local function cleanPermissionName(value)
    local permission = tostring(value or ""):gsub("^%s+",""):gsub("%s+$","")
    if permission == "" then return nil end

    -- Permissões antigas do Reborn/AdminControl no padrão "x.permissao" não são grupos reais da vRP Seoul.
    -- Elas ficam fora do mapa runtime para evitar HasGroup olhando Permissions:x.permissao.
    if permission:find("%.permissao",1,false) then
        return nil
    end

    return permission
end

local function addPermission(result, value)
    local permission = cleanPermissionName(value)
    if permission then
        result[permission] = true
    end
end

local function normalizePermission(permission, groupName, source)
    local result = {}

    -- Todo grupo AdminControl precisa ser reconhecido pelo próprio nome na vRP.
    addPermission(result, groupName)

    if type(permission) == "table" then
        for key, value in pairs(permission) do
            if type(key) == "string" and value == true then
                addPermission(result, key)
            elseif type(value) == "string" then
                addPermission(result, value)
            elseif type(value) == "table" and value.Group then
                addPermission(result, value.Group)
            end
        end
    elseif type(permission) == "string" then
        for part in permission:gmatch("[^,]+") do
            addPermission(result, part)
        end
    end

    if not next(result) then
        result[tostring(groupName)] = true
    end

    return result
end

local function normalizeGroup(name, data, source)
    data = type(data) == "table" and data or {}
    local illegal = groupLooksIllegal(name, data)
    local groupType = data.Type or data.type or (illegal and "Gang" or "Work")

    return {
        Id = tostring(name),
        Name = tostring(data.Name or name),
        Source = source or "unknown",
        Type = tostring(groupType),
        Kind = illegal and "gang" or "job",
        Permission = normalizePermission(data.Permission or data.Permissions, name, source),
        LegacyPermissions = deepCopy(data.Permission or data.Permissions or {}),
        Hierarchy = normalizeHierarchy(data.Hierarchy),
        Service = data.Service ~= false,
        Chat = data.Chat == true,
        Chest = data.Chest == true,
        Domination = data.Domination == true,
        Block = data.Block == true,
        Markers = data.Markers or false,
        Max = data.Max or data.Members or false,
        Salary = type(data.Salary) == "table" and deepCopy(data.Salary) or nil,
        Backpack = type(data.Backpack) == "table" and deepCopy(data.Backpack) or nil,
        OrgPanel = data.OrgPanel == true,
        SecurityCam = data.SecurityCam == true,
        Banned = data.Banned == true,
        NativeData = source == "global" and deepCopy(data) or nil
    }
end

local function runtimeHierarchy(group)
    local result = {}
    local hierarchy = type(group.Hierarchy) == "table" and group.Hierarchy or {}

    for level, entry in ipairs(hierarchy) do
        if type(entry) == "table" then
            result[#result + 1] = tostring(entry.Title or entry.Name or entry.Group or ("Cargo "..level))
        else
            result[#result + 1] = tostring(entry)
        end
    end

    if #result == 0 then
        result[1] = "Membro"
    end

    return result
end

local function runtimeSalary(group)
    if type(group.NativeData) == "table" and type(group.NativeData.Salary) == "table" then
        return deepCopy(group.NativeData.Salary)
    end

    if type(group.Salary) == "table" then
        return deepCopy(group.Salary)
    end

    return nil
end

local function runtimeType(group)
    local raw = tostring(group.Type or ""):lower()
    if raw == "unworked" or raw == "vip" or raw == "premium" then
        return group.Type
    end

    -- A Seoul usa Type = "Work" inclusive para gangs nativas; manter padrão seguro.
    return "Work"
end

local function buildRuntimeGroup(name, group)
    local permission = {}
    permission[tostring(name)] = true

    local runtime = {
        Permission = permission,
        Hierarchy = runtimeHierarchy(group),
        Name = tostring(group.Name or name),
        Service = group.Service ~= false,
        Type = runtimeType(group),
        Markers = group.Markers or false,
        Chat = group.Chat == true,
        Chest = group.Chest == true,
        Domination = group.Domination == true or group.Kind == "gang",
        Block = group.Block == true,
        OrgPanel = group.OrgPanel == true,
        SecurityCam = group.SecurityCam == true,
        Banned = group.Banned == true,
        SeoulAdminControl = true,
        SeoulKind = group.Kind or "job"
    }

    local salary = runtimeSalary(group)
    if salary then runtime.Salary = salary end

    if group.Max then runtime.Max = group.Max end
    if group.Backpack then runtime.Backpack = deepCopy(group.Backpack) end

    return runtime
end

local function buildRuntimeControlGroups()
    local runtime = {}

    for name, group in pairs(Bridge.controlGroups or {}) do
        if not Bridge.nativeGroups[name] then
            runtime[name] = buildRuntimeGroup(name, group)
        end
    end

    return runtime
end

local function ensureControlGroupRuntime(groupName)
    groupName = tostring(groupName or ""):gsub("^%s+",""):gsub("%s+$","")
    if groupName == "" then return false end

    -- Garante que a ponte esteja com dados atuais do arquivo.
    if not Bridge.controlGroups[groupName] then
        loadGroups()
    end

    local group = Bridge.controlGroups[groupName]
    if not group or Bridge.nativeGroups[groupName] then
        return false
    end

    local runtime = buildRuntimeGroup(groupName, group)
    runtime.Source = "admincontrol"
    runtime.SeoulAdminControl = true

    if vRP and vRP.SeoulAdminControlEnsureGroup then
        local ok,result = pcall(vRP.SeoulAdminControlEnsureGroup, groupName, runtime)
        if ok and result then
            return true
        end
    end

    syncRuntimeGroups()
    local runtimeGroups = vRP.Groups and vRP.Groups() or Groups or {}
    return runtimeGroups and runtimeGroups[groupName] ~= nil
end

local function syncRuntimeGroups()
    Bridge.groupSyncStatus = "pending"
    Bridge.injectedGroupCount = 0
    Bridge.updatedGroupCount = 0
    Bridge.removedGroupCount = 0
    Bridge.skippedNativeGroupCount = 0

    if not (vRP and vRP.SeoulAdminControlSyncGroups) then
        Bridge.groupSyncStatus = "vRP.SeoulAdminControlSyncGroups indisponível"
        return false
    end

    local ok, result = pcall(vRP.SeoulAdminControlSyncGroups, buildRuntimeControlGroups())
    if not ok then
        Bridge.groupSyncStatus = tostring(result)
        Bridge.lastError = "Falha ao sincronizar groups AdminControl no vRP: "..tostring(result)
        return false
    end

    result = type(result) == "table" and result or {}
    Bridge.injectedGroupCount = tonumber(result.Added or 0) or 0
    Bridge.updatedGroupCount = tonumber(result.Updated or 0) or 0
    Bridge.removedGroupCount = tonumber(result.Removed or 0) or 0
    Bridge.skippedNativeGroupCount = tonumber(result.Skipped or 0) or 0
    Bridge.groupSyncStatus = "ok"

    return true
end

local function loadGroups()
    local native = {}
    if type(Groups) == "table" then
        for name, data in pairs(Groups) do
            native[name] = normalizeGroup(name, data, "global")
        end
    end

    local controlRaw = getControlFile("groups") or {}
    local control = {}
    for name, data in pairs(controlRaw) do
        control[name] = normalizeGroup(name, data, "admincontrol")
    end

    local merged = deepCopy(native)
    for name, data in pairs(control) do
        if merged[name] then
            data.Overlays = true
            data.NativeExists = true
        end
        merged[name] = data
    end

    Bridge.nativeGroups = native
    Bridge.controlGroups = control
    Bridge.mergedGroups = merged
    Bridge.nativeGroupCount = tableCount(native)
    Bridge.controlGroupCount = tableCount(control)
    Bridge.mergedGroupCount = tableCount(merged)
end

local function buildRuntimeTheme(base)
    base = type(base) == "table" and base or {}
    local primary = normalizeHex(base.CityColorHex or base.CityColor, "#1EA1DA")
    local mainText = "#ffffff"

    return {
        Theme = tostring(base.Theme or "default"),
        Primary = primary,
        Main = primary,
        MainText = mainText,
        CityColor = base.CityColor or hexToRgbString(primary),
        CityColorHex = primary,
        Logo = base.CityLogo or "",
        ImageSize = base.ImageSize or 1.0,
        Source = "AdminControl"
    }
end

local function applyRuntimeTheme(base)
    if type(Theme) ~= "table" then return end

    local runtime = buildRuntimeTheme(base)
    local primary = runtime.Primary

    Theme.main = primary
    Theme.mainText = Theme.mainText or runtime.MainText
    Theme.common = primary
    Theme.currency = Currency or Theme.currency
    Theme.items = ListItem or Theme.items
    Theme.groups = Groups or Theme.groups

    Theme.accept = type(Theme.accept) == "table" and Theme.accept or {}
    Theme.accept.background = primary
    Theme.accept.letter = Theme.accept.letter or "#dcffe9"

    Theme.hud = type(Theme.hud) == "table" and Theme.hud or {}
    Theme.hud.health = primary
    Theme.hud.progress = type(Theme.hud.progress) == "table" and Theme.hud.progress or {}
    Theme.hud.progress.circle = primary

    Theme.loading = type(Theme.loading) == "table" and Theme.loading or {}
    Theme.loading.mode = Theme.loading.mode or "dark"

    Bridge.themeCore.lastRuntimeMain = Theme.main

    return runtime
end


local function applyServerIdentity(base, reason)
    base = type(base) == "table" and base or {}

    local hostname = firstNonEmpty(base.ServerName, "Seoul")
    local projectName = firstNonEmpty(base.ProjectName, hostname)
    local projectDesc = firstNonEmpty(base.ProjectDesc, hostname)
    local tags = firstNonEmpty(base.Tags, "")
    local locale = firstNonEmpty(base.Locale, "pt-BR")
    local discord = firstNonEmpty(base.Discord, "")
    local bannerConnecting = firstNonEmpty(base.BannerConnecting, "")
    local bannerDetail = firstNonEmpty(base.BannerDetail, "")

    Bridge.serverIdentity.lastStatus = "pending"
    Bridge.serverIdentity.lastError = nil
    Bridge.serverIdentity.lastAppliedAt = os.time()
    Bridge.serverIdentity.lastReason = tostring(reason or "reload")
    Bridge.serverIdentity.hostname = hostname
    Bridge.serverIdentity.projectName = projectName
    Bridge.serverIdentity.projectDesc = projectDesc
    Bridge.serverIdentity.tags = tags
    Bridge.serverIdentity.locale = locale
    Bridge.serverIdentity.discord = discord
    Bridge.serverIdentity.bannerConnecting = bannerConnecting
    Bridge.serverIdentity.bannerDetail = bannerDetail
    Bridge.serverIdentity.commandCount = 0

    local errors = {}

    local function applyConvar(label, name, value, mode)
        value = commandValue(value)
        name = tostring(name or "")
        if name == "" then return false end

        local ok, result

        -- Preferir natives em vez de ExecuteCommand.
        -- Isso evita "Access denied for command sv_hostname/sets" quando o resource não tem ACE.
        if mode == "serverinfo" and type(SetConvarServerInfo) == "function" then
            ok, result = pcall(SetConvarServerInfo, name, value)
        elseif mode == "replicated" and type(SetConvarReplicated) == "function" then
            ok, result = pcall(SetConvarReplicated, name, value)
        elseif type(SetConvar) == "function" then
            ok, result = pcall(SetConvar, name, value)
        else
            ok, result = false, "natives SetConvar/SetConvarServerInfo indisponíveis"
        end

        if ok then
            Bridge.serverIdentity.commandCount = Bridge.serverIdentity.commandCount + 1
            return true
        end

        errors[#errors + 1] = tostring(label)..": "..tostring(result)
        return false
    end

    -- Nome real usado pelo servidor.
    applyConvar("sv_hostname", "sv_hostname", hostname, "convar")

    -- Dados públicos que substituem o antigo comando `sets` sem precisar de ACE.
    applyConvar("sv_projectName", "sv_projectName", projectName, "serverinfo")
    applyConvar("sv_projectDesc", "sv_projectDesc", projectDesc, "serverinfo")

    if tags ~= "" then
        applyConvar("tags", "tags", tags, "serverinfo")
    end

    if locale ~= "" then
        applyConvar("locale", "locale", locale, "serverinfo")
    end

    if discord ~= "" then
        applyConvar("Discord", "Discord", discord, "serverinfo")
        applyConvar("discord", "discord", discord, "serverinfo")
    end

    if bannerConnecting ~= "" then
        applyConvar("banner_connecting", "banner_connecting", bannerConnecting, "serverinfo")
    end

    if bannerDetail ~= "" then
        applyConvar("banner_detail", "banner_detail", bannerDetail, "serverinfo")
    end

    if #errors > 0 then
        Bridge.serverIdentity.lastStatus = "erro"
        Bridge.serverIdentity.lastError = table.concat(errors, " | ")
        Bridge.lastError = Bridge.serverIdentity.lastError
        err("Server Identity não aplicou por native: "..Bridge.serverIdentity.lastError)
        return false
    end

    Bridge.serverIdentity.lastStatus = "ok"
    log(("Server Identity aplicado%s. Hostname: %s | ProjectName: %s | Desc: %s | campos: %s"):format(
        reason and (" ("..tostring(reason)..")") or "",
        tostring(hostname),
        tostring(projectName),
        tostring(projectDesc),
        tostring(Bridge.serverIdentity.commandCount)
    ))
    return true
end

local function publishStates()
    local base = Bridge.base
    local runtimeTheme = applyRuntimeTheme(base) or buildRuntimeTheme(base)

    GlobalState["Basics"] = {
        ServerName = base.ServerName,
        ProjectName = base.ProjectName,
        ProjectDesc = base.ProjectDesc,
        Tags = base.Tags,
        Locale = base.Locale,
        BannerConnecting = base.BannerConnecting,
        BannerDetail = base.BannerDetail,
        Discord = base.Discord,
        MaxHealth = base.MaxHealth,
        Theme = base.Theme,
        CityColor = base.CityColor,
        CityColorHex = base.CityColorHex,
        CityLogo = base.CityLogo,
        ImageSize = base.ImageSize,
        Identifier = base.Identifier,
        Whitelist = base.Whitelist,
        Maintenance = base.Maintenance.enabled,
        Debug = base.Debug
    }

    GlobalState["SeoulTheme"] = runtimeTheme

    GlobalState["SeoulGroups"] = Bridge.mergedGroups
    GlobalState["SeoulAdminControl"] = {
        Loaded = true,
        AdminControlState = Bridge.adminControlState,
        LastReload = Bridge.lastReload,
        LastError = Bridge.lastError,
        NativeGroups = Bridge.nativeGroupCount,
        ControlGroups = Bridge.controlGroupCount,
        TotalGroups = Bridge.mergedGroupCount,
        InjectedGroups = Bridge.injectedGroupCount,
        UpdatedGroups = Bridge.updatedGroupCount,
        RemovedGroups = Bridge.removedGroupCount,
        SkippedNativeGroups = Bridge.skippedNativeGroupCount,
        GroupSyncStatus = Bridge.groupSyncStatus,
        Theme = base.Theme,
        ServerName = base.ServerName,
        Base = {
            Needs = deepCopy(base.Needs),
            NpcControl = deepCopy(base.NpcControl),
            MaxHealth = base.MaxHealth,
            Theme = base.Theme,
            CityColorHex = base.CityColorHex,
            CityColor = base.CityColor,
            CityLogo = base.CityLogo,
            ImageSize = base.ImageSize,
            ServerName = base.ServerName,
            ProjectName = base.ProjectName,
            ProjectDesc = base.ProjectDesc,
            Tags = base.Tags,
            Locale = base.Locale,
            BannerConnecting = base.BannerConnecting,
            BannerDetail = base.BannerDetail,
            Discord = base.Discord,
            Identifier = base.Identifier,
            Whitelist = base.Whitelist,
            Maintenance = deepCopy(base.Maintenance),
            AutoReload = deepCopy(base.AutoReload)
        },
        ThemeCore = deepCopy(Bridge.themeCore),
        ServerIdentity = deepCopy(Bridge.serverIdentity),
        AutoReload = {
            Enabled = safeGet(base,"AutoReload","Enabled") == true,
            Simulation = false,
            Running = Bridge.autoReload.running == true,
            Reason = Bridge.autoReload.reason,
            StartedAt = Bridge.autoReload.startedAt,
            EndsAt = Bridge.autoReload.endsAt,
            LastResult = Bridge.autoReload.lastResult,
            RecurringTime = toNumber(safeGet(base,"AutoReload","RecurringTime"), 12 * 60 * 60 * 1000),
            TimerCount = tableCount(safeGet(base,"AutoReload","Timers") or {}),
            Warning = deepCopy(safeGet(base,"AutoReload","Warning") or {})
        },
        Connection = {
            ServerName = base.ServerName,
            ProjectName = base.ProjectName,
            ProjectDesc = base.ProjectDesc,
            Tags = base.Tags,
            Locale = base.Locale,
            Discord = base.Discord,
            Identifier = base.Identifier,
            Whitelist = base.Whitelist,
            MaintenanceEnabled = safeGet(base,"Maintenance","enabled") == true,
            MaintenanceText = tostring(safeGet(base,"Maintenance","text") or "Servidor em manutenção"),
            MaintenanceLicenseCount = tableCount(safeGet(base,"Maintenance","licenses") or {})
        }
    }
end

local function reloadBridge(reason, options)
    options = options or {}
    Bridge.lastError = nil

    if options.clearAdminControlCache then
        reloadAdminControlCache()
    end

    Bridge.base = normalizeBaseConfig(getControlFile("baseconfig"))
    loadGroups()
    syncRuntimeGroups()
    syncGlobalLuaTheme(Bridge.base, reason or "reload")
    applyServerIdentity(Bridge.base, reason or "reload")
    Bridge.lastReload = os.time()
    publishStates()
    TriggerClientEvent("Seoul:AdminControl:ApplyClientConfig", -1, GlobalState["SeoulAdminControl"], GlobalState["SeoulTheme"], GlobalState["Basics"])

    log(("Config recarregada%s. BaseConfig: OK | Tema: %s | Groups: %s nativos + %s AdminControl = %s | runtime: +%s ~%s -%s, %s nativos protegidos."):format(
        reason and (" ("..tostring(reason)..")") or "",
        tostring(Bridge.base.Theme),
        tostring(Bridge.nativeGroupCount),
        tostring(Bridge.controlGroupCount),
        tostring(Bridge.mergedGroupCount),
        tostring(Bridge.injectedGroupCount),
        tostring(Bridge.updatedGroupCount),
        tostring(Bridge.removedGroupCount),
        tostring(Bridge.skippedNativeGroupCount)
    ))

    if Bridge.lastError then warn(Bridge.lastError) end

    return true
end

Seoul.AdminControlReload = reloadBridge
Reborn.AdminControlReload = reloadBridge

function Seoul.adminControlStatus()
    return {
        BaseConfig = Bridge.base,
        AdminControlState = Bridge.adminControlState,
        LastReload = Bridge.lastReload,
        LastError = Bridge.lastError,
        NativeGroups = Bridge.nativeGroupCount,
        ControlGroups = Bridge.controlGroupCount,
        TotalGroups = Bridge.mergedGroupCount,
        InjectedGroups = Bridge.injectedGroupCount,
        UpdatedGroups = Bridge.updatedGroupCount,
        RemovedGroups = Bridge.removedGroupCount,
        SkippedNativeGroups = Bridge.skippedNativeGroupCount,
        GroupSyncStatus = Bridge.groupSyncStatus
    }
end
Reborn.adminControlStatus = Seoul.adminControlStatus

function Seoul.adminControlGroups()
    return deepCopy(Bridge.mergedGroups)
end
Reborn.adminControlGroups = Seoul.adminControlGroups

function Seoul.theme()
    return deepCopy(GlobalState["SeoulTheme"] or buildRuntimeTheme(Bridge.base))
end
Reborn.theme = Seoul.theme

function Seoul.identity()
    return deepCopy(Bridge.serverIdentity)
end
Reborn.identity = Seoul.identity

function Seoul.needs()
    local needs = safeGet(Bridge.base, "Needs") or {}
    return {
        Tempo = toNumber(needs.Tempo, 90),
        Fome = toNumber(needs.Fome, 2),
        Sede = toNumber(needs.Sede, 1)
    }
end
Reborn.needs = Seoul.needs

function Seoul.npcControl()
    local npc = safeGet(Bridge.base, "NpcControl") or {}
    return {
        PedDensity = toNumber(npc.PedDensity, 0.5),
        VehicleDensity = toNumber(npc.VehicleDensity, 0.4),
        ParkedVehicle = toNumber(npc.ParkedVehicle, 0.4)
    }
end
Reborn.npcControl = Seoul.npcControl

function Seoul.maintenance()
    local maintenance = safeGet(Bridge.base, "Maintenance") or {}
    return {
        enabled = maintenance.enabled == true,
        text = tostring(maintenance.text or "Servidor em manutenção"),
        licenses = type(maintenance.licenses) == "table" and maintenance.licenses or {}
    }
end
Reborn.maintenance = Seoul.maintenance

function Seoul.whitelist()
    return {
        enabled = safeGet(Bridge.base,"Whitelist") == true,
        identifier = tostring(safeGet(Bridge.base,"Identifier") or BaseMode or "license"),
        serverName = tostring(safeGet(Bridge.base,"ServerName") or ServerName or "Seoul"),
        discord = tostring(safeGet(Bridge.base,"Discord") or ServerLink or "")
    }
end
Reborn.whitelist = Seoul.whitelist

function Seoul.connection()
    local maintenance = Seoul.maintenance()
    local whitelist = Seoul.whitelist()

    return {
        ServerName = whitelist.serverName,
        ServerLink = whitelist.discord,
        Identifier = whitelist.identifier,
        Whitelist = whitelist.enabled,
        MaintenanceEnabled = maintenance.enabled == true,
        MaintenanceText = maintenance.text,
        MaintenanceLicenses = maintenance.licenses
    }
end
Reborn.connection = Seoul.connection

function Seoul.autoReload()
    local autoReload = safeGet(Bridge.base, "AutoReload") or {}
    return {
        Enabled = autoReload.Enabled == true,
        RecurringTime = toNumber(autoReload.RecurringTime, 12 * 60 * 60 * 1000),
        Timers = type(autoReload.Timers) == "table" and autoReload.Timers or {},
        Warning = type(autoReload.Warning) == "table" and autoReload.Warning or {},
        Simulation = false,
        ExecuteCommand = tostring(autoReload.ExecuteCommand or autoReload.Command or "quit"),
        Running = Bridge.autoReload.running == true,
        StartedAt = Bridge.autoReload.startedAt,
        EndsAt = Bridge.autoReload.endsAt,
        LastResult = Bridge.autoReload.lastResult
    }
end
Reborn.autoReload = Seoul.autoReload

function Seoul.segurity_code()
    local wipe = safeGet(Bridge.base, "Wipe") or {}
    return {
        code = tostring(wipe.Password or "Seoul"),
        start_id = math.max(1, math.floor(toNumber(wipe.StartId, 1))),
        start_bank = math.max(0, math.floor(toNumber(wipe.StartBank, 0))),
        db_tables = {}
    }
end
Reborn.segurity_code = Seoul.segurity_code

function Seoul.frameworkTables()
    return {
        users = false,
        owned_vehicles = false,
        players = false,
        player_vehicles = false,
        ox_inventory = true,
        characters = true,
        vehicles = true,
        accounts = true,
        permissions = true,
        phone_phones = true
    }
end
Reborn.frameworkTables = Seoul.frameworkTables

function Seoul.dbSimilarTables()
    local similar = {
        { Old = "vrp_user_vehicles", New = "vehicles", Columns = { detido = "arrest", ipva = "time" } },
        { Old = "vrp_vehicles", New = "vehicles" },
        { Old = "vrp_user_identities", New = "characters", Columns = { user_id = "id", firstname = "name", name = "name2" } },
        { Old = "vrp_infos", New = "accounts" },
        { Old = "vrp_users", New = "characters" },
        { Old = "vrp_user_moneys", New = "characters", Columns = { user_id = "id", wallet = "bank" } },
        { Old = "summerz_entitydata", New = "entitydata" },
        { Old = "summerz_playerdata", New = "playerdata" },
        { Old = "summerz_accounts", New = "accounts" },
        { Old = "summerz_characters", New = "characters" },
        { Old = "summerz_vehicles", New = "vehicles", Columns = { tax = "time" } }
    }
    GlobalState["DbSimilarTables"] = similar
    return similar
end
Reborn.dbSimilarTables = Seoul.dbSimilarTables

function Seoul.groups()
    return Seoul.adminControlGroups()
end
Reborn.groups = Seoul.groups

exports("ReloadAdminControlConfig", function()
    return reloadBridge("export", { clearAdminControlCache = true })
end)

exports("ReloadAdminControlGroups", function()
    return reloadBridge("export groups", { clearAdminControlCache = true })
end)

local function isAdmin(source)
    if source == 0 then return true end
    if not source or source <= 0 then return false end

    local passport = vRP.Passport and vRP.Passport(source) or (vRP.getUserId and vRP.getUserId(source))
    if not passport then return false end

    if vRP.HasPermission and vRP.HasPermission(passport, "Admin") then return true end
    if vRP.HasGroup and vRP.HasGroup(passport, "Admin", 1) then return true end
    if vRP.hasPermission and vRP.hasPermission(passport, "Admin") then return true end

    return false
end

local function notify(source, message)
    if source and source > 0 then
        TriggerClientEvent("Notify", source, "AdminControl", tostring(message), "verde", 7000)
    end
end


local function notifyAll(title, message, color, time)
    local notifyTitle = tostring(title or "AdminControl")
    local text = tostring(message or "")
    TriggerClientEvent("Notify", -1, notifyTitle, text, color or "amarelo", time or 10000)
    TriggerClientEvent("chat:addMessage", -1, {
        color = { 30, 161, 218 },
        multiline = true,
        args = { notifyTitle, text }
    })
end

local function getAutoReloadRuntimeConfig()
    local cfg = Seoul.autoReload and Seoul.autoReload() or {}
    local warning = type(cfg.Warning) == "table" and cfg.Warning or {}
    local warningMs = toNumber(warning.TimeToRestart, 5 * 60 * 1000)
    local seconds = math.max(10, math.floor(warningMs / 1000))

    return {
        Enabled = cfg.Enabled == true,
        Simulation = false,
        RecurringSeconds = math.max(0, math.floor(toNumber(cfg.RecurringTime, 12 * 60 * 60 * 1000) / 1000)),
        Timers = type(cfg.Timers) == "table" and cfg.Timers or {},
        WarningSeconds = seconds,
        Message = tostring(warning.Message or "Previsão de terremoto em breve..."),
        ChangeWeather = tostring(warning.ChangeWeather or "THUNDER"),
        ExecuteCommand = tostring(cfg.ExecuteCommand or cfg.Command or "quit")
    }
end

local function applyAutoReloadWeather(weather)
    weather = tostring(weather or "")
    if weather == "" then return end

    GlobalState["Weather"] = weather
    GlobalState["SeoulWeather"] = weather
    GlobalState["SeoulAutoReloadWeather"] = weather
end

local function formatSeconds(seconds)
    seconds = math.max(0, tonumber(seconds) or 0)
    if seconds >= 60 then
        local minutes = math.floor(seconds / 60)
        local rest = seconds % 60
        if rest > 0 then
            return ("%s minuto(s) e %s segundo(s)"):format(minutes, rest)
        end
        return ("%s minuto(s)"):format(minutes)
    end
    return ("%s segundo(s)"):format(seconds)
end


local function trimText(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeShutdownCommand(command, reason)
    command = trimText(command)
    reason = tostring(reason or "Seoul AutoReload")

    if command == "" then
        command = "quit"
    end

    local lower = string.lower(command)

    if lower == "quit" then
        return ('quit "%s"'):format(reason:gsub('"', "'"))
    end

    return command
end

local function executeShutdownCommand(command, reason)
    local finalCommand = normalizeShutdownCommand(command, reason)
    Bridge.autoReload.lastCommand = finalCommand
    Bridge.autoReload.lastResult = "executing-command"
    publishStates()

    log(("AutoReload executando comando real: %s"):format(finalCommand))
    ExecuteCommand(finalCommand)

    CreateThread(function()
        Wait(8000)

        -- Se o servidor ainda chegou até aqui, o comando não encerrou o FXServer.
        -- Tentamos o fallback explícito do quit com mensagem. Se ainda continuar vivo,
        -- provavelmente faltou permissão ACL command.quit para o resource vrp.
        if Bridge.autoReload.lastResult == "executing-command" then
            local fallback = normalizeShutdownCommand("quit", reason)
            Bridge.autoReload.lastResult = "fallback-quit"
            Bridge.autoReload.lastCommand = fallback
            publishStates()
            log(("AutoReload fallback: servidor ainda ativo, tentando %s"):format(fallback))
            ExecuteCommand(fallback)
        end

        Wait(8000)
        if Bridge.autoReload.lastResult == "fallback-quit" then
            Bridge.autoReload.lastResult = "command-blocked-or-ignored"
            publishStates()
            log("AutoReload não encerrou o servidor. Verifique ACL: add_ace resource.vrp command.quit allow")
            notifyAll("AdminControl", "AutoReload tentou encerrar, mas o servidor continuou ativo. Libere no server.cfg: add_ace resource.vrp command.quit allow", "vermelho", 20000)
        end
    end)
end

local function startAutoReloadCountdown(reason, overrideSeconds, source)
    local runtime = getAutoReloadRuntimeConfig()
    local seconds = math.floor(tonumber(overrideSeconds) or runtime.WarningSeconds or 60)
    seconds = math.max(10, math.min(seconds, 3600))

    if Bridge.autoReload.running then
        notify(source, "Já existe uma contagem de terremoto/restart em andamento.")
        return false
    end

    Bridge.autoReload.running = true
    Bridge.autoReload.reason = tostring(reason or "manual")
    Bridge.autoReload.startedAt = os.time()
    Bridge.autoReload.endsAt = Bridge.autoReload.startedAt + seconds
    Bridge.autoReload.sentMilestones = {}
    Bridge.autoReload.simulation = false
    Bridge.autoReload.lastResult = "running"
    publishStates()

    if runtime.ChangeWeather and runtime.ChangeWeather ~= "" then
        applyAutoReloadWeather(runtime.ChangeWeather)
    end

    notifyAll("AdminControl", ("%s Tempo restante: %s. O servidor será reiniciado/encerrado ao final da contagem."):format(runtime.Message, formatSeconds(seconds)), "amarelo", 15000)

    CreateThread(function()
        local milestones = { 600, 300, 180, 120, 60, 30, 10, 5 }

        while Bridge.autoReload.running do
            local remaining = Bridge.autoReload.endsAt - os.time()
            if remaining <= 0 then break end

            for _, milestone in ipairs(milestones) do
                if remaining <= milestone and not Bridge.autoReload.sentMilestones[milestone] then
                    Bridge.autoReload.sentMilestones[milestone] = true
                    notifyAll("AdminControl", ("Terremoto/restart em %s."):format(formatSeconds(remaining)), "amarelo", 8000)
                end
            end

            Wait(1000)
        end

        if Bridge.autoReload.running then
            Bridge.autoReload.running = false
            Bridge.autoReload.lastResult = "executing"
            local command = tostring((getAutoReloadRuntimeConfig().ExecuteCommand or "quit"))
            publishStates()
            notifyAll("AdminControl", ("AutoReload finalizado. Executando comando real: %s"):format(normalizeShutdownCommand(command, "Seoul AutoReload")), "vermelho", 12000)
            Wait(3000)
            Bridge.autoReload.running = false
            Bridge.autoReload.reason = nil
            executeShutdownCommand(command, "Seoul AutoReload")
        end
    end)

    return true
end

local function cancelAutoReload(source)
    if not Bridge.autoReload.running then
        notify(source, "Nenhuma contagem de AutoReload em andamento.")
        return false
    end

    Bridge.autoReload.running = false
    Bridge.autoReload.lastResult = "cancelled"
    Bridge.autoReload.reason = nil
    publishStates()
    notifyAll("AdminControl", "AutoReload cancelado.", "vermelho", 8000)
    return true
end

local function autoReloadStatusMessage()
    local runtime = getAutoReloadRuntimeConfig()
    local running = Bridge.autoReload.running == true
    local remaining = running and math.max(0, Bridge.autoReload.endsAt - os.time()) or 0
    return ("AutoReload: enabled=%s | real=true | comando=%s | rodando=%s | timers=%s | aviso=%s | restante=%s | resultado=%s | ultimo=%s"):format(
        tostring(runtime.Enabled),
        tostring(normalizeShutdownCommand(runtime.ExecuteCommand or "quit", "Seoul AutoReload")),
        tostring(running),
        tostring(tableCount(runtime.Timers)),
        formatSeconds(runtime.WarningSeconds),
        formatSeconds(remaining),
        tostring(Bridge.autoReload.lastResult or "none"),
        tostring(Bridge.autoReload.lastCommand or "none")
    )
end

RegisterCommand("seoulreloadconfig", function(source)
    if not isAdmin(source) then return end
    reloadBridge("comando", { clearAdminControlCache = true })
    notify(source, "Configurações do AdminControl recarregadas.")
end)

RegisterCommand("reloadconfig", function(source)
    if not isAdmin(source) then return end
    reloadBridge("reloadconfig", { clearAdminControlCache = true })
    notify(source, "Configurações do AdminControl recarregadas.")
end)

RegisterCommand("seoulreloadgroups", function(source)
    if not isAdmin(source) then return end
    reloadBridge("groups runtime", { clearAdminControlCache = true })
    notify(source, ("Groups recarregados em runtime. +%s ~%s -%s | status: %s"):format(tostring(Bridge.injectedGroupCount), tostring(Bridge.updatedGroupCount), tostring(Bridge.removedGroupCount), tostring(Bridge.groupSyncStatus)))
end)

RegisterCommand("seoulacstatus", function(source)
    if not isAdmin(source) then return end
    local message = ("AdminControl: %s | Theme: %s | Base: %s | Groups: %s nativos + %s AdminControl = %s | Runtime: +%s ~%s -%s | LastError: %s"):format(
        tostring(Bridge.adminControlState),
        tostring(safeGet(Bridge.base, "Theme") or "nil"),
        tostring(safeGet(Bridge.base, "ServerName") or "nil"),
        tostring(Bridge.nativeGroupCount),
        tostring(Bridge.controlGroupCount),
        tostring(Bridge.mergedGroupCount),
        tostring(Bridge.injectedGroupCount),
        tostring(Bridge.updatedGroupCount),
        tostring(Bridge.removedGroupCount),
        tostring(Bridge.lastError or "none")
    )
    log(message)
    notify(source, message)
end)

RegisterCommand("seoulthemestatus", function(source)
    if not isAdmin(source) then return end
    local runtimeTheme = GlobalState["SeoulTheme"] or {}
    local runtimeMain = type(Theme) == "table" and Theme.main or "nil"
    local message = ("Theme Core: AdminControl=%s | GlobalState=%s | Theme.main=%s | Global.lua=%s | alterou=%s | campos=%s | erro=%s"):format(
        tostring(safeGet(Bridge.base, "CityColorHex") or "nil"),
        tostring(runtimeTheme.Primary or runtimeTheme.CityColorHex or "nil"),
        tostring(runtimeMain),
        tostring(Bridge.themeCore.lastStatus or "pending"),
        tostring(Bridge.themeCore.lastGlobalChanged == true),
        tostring(Bridge.themeCore.lastReplacements or 0),
        tostring(Bridge.themeCore.lastGlobalError or "none")
    )
    log(message)
    notify(source, message)
end)

RegisterCommand("seoulthemeapply", function(source)
    if not isAdmin(source) then return end
    reloadBridge("theme core manual", { clearAdminControlCache = true })
    local message = ("Theme Core aplicado. Cor: %s | Global.lua: %s | alterou: %s"):format(
        tostring(Bridge.themeCore.lastColor or safeGet(Bridge.base, "CityColorHex") or "nil"),
        tostring(Bridge.themeCore.lastStatus or "pending"),
        tostring(Bridge.themeCore.lastGlobalChanged == true)
    )
    log(message)
    notify(source, message)
end)

RegisterCommand("seoulidentitystatus", function(source)
    if not isAdmin(source) then return end
    local identity = Bridge.serverIdentity or {}
    local message = ("Server Identity: hostname=%s | projectName=%s | desc=%s | tags=%s | locale=%s | status=%s | erro=%s"):format(
        tostring(identity.hostname or safeGet(Bridge.base, "ServerName") or "nil"),
        tostring(identity.projectName or safeGet(Bridge.base, "ProjectName") or "nil"),
        tostring(identity.projectDesc or safeGet(Bridge.base, "ProjectDesc") or "nil"),
        tostring(identity.tags or safeGet(Bridge.base, "Tags") or ""),
        tostring(identity.locale or safeGet(Bridge.base, "Locale") or ""),
        tostring(identity.lastStatus or "pending"),
        tostring(identity.lastError or "none")
    )
    log(message)
    notify(source, message)
end)

RegisterCommand("seoulidentityapply", function(source)
    if not isAdmin(source) then return end
    reloadBridge("server identity manual", { clearAdminControlCache = true })
    local identity = Bridge.serverIdentity or {}
    local message = ("Server Identity aplicado. Hostname: %s | ProjectName: %s | status: %s"):format(
        tostring(identity.hostname or "nil"),
        tostring(identity.projectName or "nil"),
        tostring(identity.lastStatus or "pending")
    )
    log(message)
    notify(source, message)
end)

RegisterCommand("seoulconnectionstatus", function(source)
    if not isAdmin(source) then return end
    local connection = Seoul.connection and Seoul.connection() or {}
    local message = ("Entrada Seoul: manutenção=%s | whitelist=%s | base=%s | discord=%s | licenses manutenção=%s"):format(
        tostring(connection.MaintenanceEnabled == true),
        tostring(connection.Whitelist == true),
        tostring(connection.ServerName or "nil"),
        tostring(connection.ServerLink or "nil"),
        tostring(tableCount(connection.MaintenanceLicenses or {}))
    )
    log(message)
    notify(source,message)
end)

RegisterCommand("seoulautoreloadstatus", function(source)
    if not isAdmin(source) then return end
    local message = autoReloadStatusMessage()
    log(message)
    notify(source, message)
end)

RegisterCommand("seoulautoreloadtest", function(source, args)
    if not isAdmin(source) then return end
    local seconds = tonumber(args and args[1]) or 60
    startAutoReloadCountdown("teste manual", seconds, source)
end)

RegisterCommand("seoulautoreloadcancel", function(source)
    if not isAdmin(source) then return end
    cancelAutoReload(source)
end)

RegisterCommand("seoulquitnow", function(source)
    if not isAdmin(source) then return end
    notifyAll("AdminControl", "Comando imediato de encerramento executado pelo Seoul AutoReload.", "vermelho", 8000)
    Wait(1000)
    executeShutdownCommand("quit", "Seoul AutoReload manual")
end)


RegisterCommand("seoulgroupsstatus", function(source)
    if not isAdmin(source) then return end
    local jobs, gangs = 0, 0
    for _, data in pairs(Bridge.mergedGroups) do
        if data.Kind == "gang" then gangs = gangs + 1 else jobs = jobs + 1 end
    end
    local message = ("Groups Seoul: %s total | %s empregos/staff | %s gangs/ilegais | %s vindos do AdminControl | runtime +%s ~%s -%s, %s nativos protegidos."):format(
        tostring(Bridge.mergedGroupCount), tostring(jobs), tostring(gangs), tostring(Bridge.controlGroupCount), tostring(Bridge.injectedGroupCount), tostring(Bridge.updatedGroupCount), tostring(Bridge.removedGroupCount), tostring(Bridge.skippedNativeGroupCount)
    )
    log(message)
    notify(source, message)
end)

RegisterCommand("seoulcheckgroup", function(source,args)
    if not isAdmin(source) then return end

    local passport = tonumber(args and args[1])
    local group = args and args[2]

    if not passport or not group then
        notify(source,"Uso: /seoulcheckgroup passaporte grupo")
        return
    end

    ensureControlGroupRuntime(group)
    local runtimeGroups = vRP.Groups and vRP.Groups() or Groups or {}
    local level = vRP.HasPermission and vRP.HasPermission(passport,group) or false
    local exists = runtimeGroups and runtimeGroups[group] and true or false
    local origin = Bridge.controlGroups[group] and "AdminControl" or (Bridge.nativeGroups[group] and "Global.lua" or "desconhecido")
    local message = ("Grupo %s | existe: %s | origem: %s | passaporte %s nível: %s | runtime +%s ~%s -%s"):format(tostring(group), tostring(exists), tostring(origin), tostring(passport), tostring(level or "não possui"), tostring(Bridge.injectedGroupCount), tostring(Bridge.updatedGroupCount), tostring(Bridge.removedGroupCount))
    log(message)
    notify(source,message)
end)

RegisterServerEvent("Seoul:AdminControl:ReloadConfig")
AddEventHandler("Seoul:AdminControl:ReloadConfig", function()
    reloadBridge("evento", { clearAdminControlCache = true })
end)

RegisterServerEvent("Seoul:AdminControl:SyncThemeCore")
AddEventHandler("Seoul:AdminControl:SyncThemeCore", function()
    reloadBridge("theme core evento", { clearAdminControlCache = true })
end)

RegisterServerEvent("Seoul:AdminControl:SyncServerIdentity")
AddEventHandler("Seoul:AdminControl:SyncServerIdentity", function()
    reloadBridge("server identity evento", { clearAdminControlCache = true })
end)

RegisterServerEvent("Seoul:AdminControl:ReloadGroups")
AddEventHandler("Seoul:AdminControl:ReloadGroups", function()
    reloadBridge("groups runtime", { clearAdminControlCache = true })
end)

RegisterServerEvent("Seoul:AdminControl:EnsureGroup")
AddEventHandler("Seoul:AdminControl:EnsureGroup", function(groupName)
    if ensureControlGroupRuntime(groupName) then
        local runtimeGroups = vRP.Groups and vRP.Groups() or Groups or {}
        if runtimeGroups and runtimeGroups[groupName] then
            Bridge.groupSyncStatus = "ok"
        end
    end
end)

AddEventHandler("Seoul:reloadInfos", function()
    reloadBridge("Seoul:reloadInfos", { clearAdminControlCache = true })
end)

CreateThread(function()
    Wait(15000)

    while true do
        Wait(10000)

        local runtime = getAutoReloadRuntimeConfig()
        if runtime.Enabled and not Bridge.autoReload.running then
            local now = os.time()
            local today = os.date("%Y-%m-%d", now)
            local currentTime = os.date("%H:%M", now)

            if type(runtime.Timers) == "table" and runtime.Timers[currentTime] == true then
                if Bridge.autoReload.lastTimerKey ~= currentTime or Bridge.autoReload.lastTimerDate ~= today then
                    Bridge.autoReload.lastTimerKey = currentTime
                    Bridge.autoReload.lastTimerDate = today
                    startAutoReloadCountdown("timer "..currentTime, runtime.WarningSeconds, 0)
                end
            elseif runtime.RecurringSeconds and runtime.RecurringSeconds > 0 then
                if (now - (Bridge.autoReload.lastRecurringAt or now)) >= runtime.RecurringSeconds then
                    Bridge.autoReload.lastRecurringAt = now
                    startAutoReloadCountdown("recorrente", runtime.WarningSeconds, 0)
                end
            end
        end
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == "AdminControl" then
        CreateThread(function()
            Wait(1500)
            reloadBridge("AdminControl iniciado", { clearAdminControlCache = true })
        end)
    elseif resource == GetCurrentResourceName() then
        CreateThread(function()
            Wait(3000)
            reloadBridge("boot")
            Wait(6000)
            if not adminControlStarted() then
                warn("AdminControl ainda não iniciou. A ponte ficará em fallback até o resource iniciar.")
            end
        end)
    end
end)

CreateThread(function()
    Wait(5000)
    if Bridge.lastReload == 0 then
        reloadBridge("fallback boot")
    end
end)

log("Bridge fase server identity carregada: Global.lua + identidade pública do servidor sincronizados com AdminControl.")
