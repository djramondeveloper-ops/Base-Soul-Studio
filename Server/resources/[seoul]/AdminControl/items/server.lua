GlobalState["AdminControlItems"] = {}

local MANAGED_START = "-- SEOUL ADMINCONTROL ITEMS START"
local MANAGED_END = "-- SEOUL ADMINCONTROL ITEMS END"
local VRP_RESOURCE = "vrp"
local OX_RESOURCE = "ox_inventory"
local VRP_ITEMS_PATH = "config/Item.lua"
local OX_ITEMS_PATH = "data/items.lua"
local OX_WEAPONS_PATH = "data/weapons.lua"
local OX_IMAGES_PATH = "web/images/"
local lastVrpRuntime = 0
local lastOxRuntime = 0

local function seoulItemsDebug()
    local value = tostring(GetConvar("seoul:debug", "false")):lower()
    return value == "true" or value == "1" or value == "yes" or value == "sim"
end

local function debugPrint(...)
    if seoulItemsDebug() then
        print(...)
    end
end

local function adminAllowed(source)
    if source == 0 then return true end
    return AdminControlCanUse(source, Config.Commands["items"].perm)
end

local function notify(source, kind, message, time)
    if source == 0 then
        debugPrint(("[Seoul Items] %s: %s"):format(kind or "Info", message or ""))
    else
        AdminControlNotify(source, kind or "Atenção", message or "", time or 5000)
    end
end

local function sortedKeys(tbl)
    local keys = {}
    if type(tbl) ~= "table" then return keys end
    for key in pairs(tbl) do keys[#keys + 1] = key end
    table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
    return keys
end

local function trim(value)
    value = tostring(value or "")
    return value:match("^%s*(.-)%s*$") or ""
end

local function lower(value)
    return string.lower(tostring(value or ""))
end

local function luaString(value)
    return string.format("%q", tostring(value or ""))
end

local function luaBool(value, default)
    if value == nil then return default and "true" or "false" end
    if value == true or value == 1 or value == "1" or lower(value) == "true" or lower(value) == "sim" or lower(value) == "yes" then return "true" end
    return "false"
end

local function asNumber(value, default)
    local number = tonumber(value)
    if not number then return default or 0 end
    return number
end

local function safeItemName(name)
    name = trim(name)
    if name == "" then return false end
    if name:find("%s") then return false end
    if name:find("[%'%\"{}%[%],]") then return false end
    return name
end

local function isWeaponLike(item, data)
    local itemLower = lower(item)
    local typeLower = lower(data and (data.weaponKind or data.weapon_kind or data.weaponType or data.weapon_type or data.category or data.Category or data.type or data.Type or "") or "")
    if item:match("^WEAPON_") then return true end
    if typeLower:find("arma", 1, true) or typeLower:find("weapon", 1, true) then return true end
    if itemLower:find("^ammo%-") or itemLower:find("_ammo") or typeLower:find("muni", 1, true) or typeLower:find("ammo", 1, true) then return true end
    if typeLower:find("component", 1, true) or typeLower:find("anexo", 1, true) or typeLower:find("tint", 1, true) or typeLower:find("tinta", 1, true) then return true end
    return false
end

local function normalizeIndex(item, data)
    local index = trim(data and (data.index or data.Index or data.image or data.Image) or "")
    if index == "" then index = item end
    index = index:gsub("%.png$", ""):gsub("%.webp$", ""):gsub("%.jpg$", ""):gsub("%.jpeg$", "")
    if index == "" then index = item end
    return index
end

local function normalizeExecute(data)
    if type(data) ~= "table" then return nil end
    local execute = data.Execute or data.execute
    if type(execute) == "table" then
        local event = trim(execute.Event or execute.event)
        if event ~= "" then
            return {
                Type = trim(execute.Type or execute.type or "Client"),
                Event = event
            }
        end
    end

    local event = trim(data.event or data.Event or data.clientEvent or data.client_event or data.serverEvent or data.server_event)
    if event == "" then return nil end

    local eventType = trim(data.eventType or data.event_type or data.executeType or data.execute_type)
    if eventType == "" then
        if data.serverEvent or data.server_event then eventType = "Server" else eventType = "Client" end
    end

    return {
        Type = eventType,
        Event = event
    }
end

local function normalizeItem(item, data)
    data = type(data) == "table" and data or {}
    local normalizedName = safeItemName(data.item or data.Item or item)
    if not normalizedName then return nil, "nome inválido" end

    local label = trim(data.name or data.Name or data.label or data.Label or normalizedName)
    if label == "" then label = normalizedName end

    local index = normalizeIndex(normalizedName, data)
    local weight = asNumber(data.weight or data.Weight or data.peso or data.Peso, 0)
    if weight < 0 then return nil, "peso negativo" end

    local description = trim(data.description or data.Description or data.desc or "")
    local typeName = trim(data.type or data.Type or "Comum")
    if typeName == "use" then typeName = "Consumível" end
    if typeName == "" then typeName = "Comum" end

    local execute = normalizeExecute(data)
    local image = trim(data.imageFile or data.image_file or data.image or data.Image or (index .. ".png"))
    if image == "" then image = index .. ".png" end
    if not image:find("%.") then image = image .. ".png" end

    return {
        item = normalizedName,
        label = label,
        index = index,
        image = image,
        weight = weight,
        description = description,
        type = typeName,
        execute = execute,
        stack = data.stack,
        close = data.close,
        market = data.Market ~= nil and data.Market or data.market,
        delete = data.Delete ~= nil and data.Delete or data.delete,
        durability = data.Durability or data.durability,
        rarity = data.Rarity or data.rarity
    }
end

local function imageExists(image)
    if not image or image == "" then return false end
    return LoadResourceFile(OX_RESOURCE, OX_IMAGES_PATH .. image) ~= nil
end

local function itemExistsInText(content, item)
    if not content or not item then return false end
    item = tostring(item)
    return content:find('["' .. item .. '"]', 1, true) ~= nil
        or content:find("['" .. item .. "']", 1, true) ~= nil
        or content:find('"' .. item .. '"', 1, true) ~= nil
        or content:find("'" .. item .. "'", 1, true) ~= nil
end

local function countItemsInText(content, items)
    local count = 0
    if type(items) ~= "table" then return count end
    for _, item in ipairs(items) do
        if itemExistsInText(content, item.item) then count = count + 1 end
    end
    return count
end

local function collectItems()
    local sourceItems = GetControlFile("items") or {}
    local normalized = {}
    local skipped = {}
    local errors = {}
    local missingImages = {}

    for _, key in ipairs(sortedKeys(sourceItems)) do
        local data = sourceItems[key]
        local rawName = key
        if type(data) == "table" and trim(data.item or data.Item or "") ~= "" then
            rawName = data.item or data.Item
        end
        local itemName = safeItemName(rawName)
        if not itemName then
            errors[#errors + 1] = tostring(rawName) .. ": nome inválido"
        elseif isWeaponLike(itemName, data) then
            skipped[#skipped + 1] = itemName .. " (arma/munição/componente fica para a fase de weapons.lua)"
        else
            local item, err = normalizeItem(itemName, data)
            if not item then
                errors[#errors + 1] = itemName .. ": " .. tostring(err)
            else
                if not imageExists(item.image) then
                    missingImages[#missingImages + 1] = item.item .. " -> " .. item.image
                end
                normalized[#normalized + 1] = item
            end
        end
    end

    table.sort(normalized, function(a,b) return a.item < b.item end)
    return normalized, skipped, errors, missingImages
end

local function renderVrpEntry(item)
    local lines = {}
    lines[#lines + 1] = "\t[" .. luaString(item.item) .. "] = {"
    lines[#lines + 1] = "\t\t[\"Index\"] = " .. luaString(item.index) .. ","
    lines[#lines + 1] = "\t\t[\"Name\"] = " .. luaString(item.label) .. ","
    if item.description and item.description ~= "" then
        lines[#lines + 1] = "\t\t[\"Description\"] = " .. luaString(item.description) .. ","
    end
    lines[#lines + 1] = "\t\t[\"Type\"] = " .. luaString(item.type) .. ","
    lines[#lines + 1] = "\t\t[\"Weight\"] = " .. tostring(item.weight) .. ","
    lines[#lines + 1] = "\t\t[\"Market\"] = " .. luaBool(item.market, true) .. ","
    lines[#lines + 1] = "\t\t[\"Delete\"] = " .. luaBool(item.delete, true) .. ","
    if item.durability then lines[#lines + 1] = "\t\t[\"Durability\"] = " .. tostring(asNumber(item.durability, 0)) .. "," end
    if item.rarity and item.rarity ~= "" then lines[#lines + 1] = "\t\t[\"Rarity\"] = " .. luaString(item.rarity) .. "," end
    if item.execute then
        lines[#lines + 1] = "\t\t[\"Execute\"] = {"
        lines[#lines + 1] = "\t\t\t[\"Type\"] = " .. luaString(item.execute.Type or "Client") .. ","
        lines[#lines + 1] = "\t\t\t[\"Event\"] = " .. luaString(item.execute.Event) .. ""
        lines[#lines + 1] = "\t\t},"
    end
    lines[#lines + 1] = "\t\t[\"SeoulAdminControl\"] = true"
    lines[#lines + 1] = "\t},"
    return table.concat(lines, "\n")
end

local function renderOxEntry(item)
    local oxWeight = math.floor((item.weight or 0) * 1000 + 0.5)
    local lines = {}
    lines[#lines + 1] = "\t[" .. luaString(item.item) .. "] = {"
    lines[#lines + 1] = "\t\tlabel = " .. luaString(item.label) .. ","
    lines[#lines + 1] = "\t\tweight = " .. tostring(oxWeight) .. ","
    lines[#lines + 1] = "\t\tstack = " .. luaBool(item.stack, true) .. ","
    lines[#lines + 1] = "\t\tclose = " .. luaBool(item.close, true) .. ","
    if item.description and item.description ~= "" then
        lines[#lines + 1] = "\t\tdescription = " .. luaString(item.description) .. ","
    end
    if item.execute and lower(item.execute.Type) == "server" then
        lines[#lines + 1] = "\t\tserver = {"
        lines[#lines + 1] = "\t\t\tevent = " .. luaString(item.execute.Event) .. ","
        lines[#lines + 1] = "\t\t},"
        lines[#lines + 1] = "\t\tclient = {"
        lines[#lines + 1] = "\t\t\timage = " .. luaString(item.image) .. ","
        lines[#lines + 1] = "\t\t},"
    else
        lines[#lines + 1] = "\t\tclient = {"
        lines[#lines + 1] = "\t\t\timage = " .. luaString(item.image) .. ","
        if item.execute and item.execute.Event then
            lines[#lines + 1] = "\t\t\tevent = " .. luaString(item.execute.Event) .. ","
        end
        lines[#lines + 1] = "\t\t},"
    end
    lines[#lines + 1] = "\t},"
    return table.concat(lines, "\n")
end

local function renderManagedBlock(items, renderer)
    local lines = {}
    lines[#lines + 1] = MANAGED_START
    lines[#lines + 1] = "-- Gerado pelo AdminControl Seoul. Não edite este bloco manualmente."
    lines[#lines + 1] = "-- Fonte oficial: AdminControl/data/items.json"
    for _, item in ipairs(items) do
        lines[#lines + 1] = renderer(item)
    end
    lines[#lines + 1] = MANAGED_END
    return table.concat(lines, "\n")
end

local function stripManagedBlock(content)
    content = content or ""

    while true do
        local startAt = content:find(MANAGED_START, 1, true)
        if not startAt then break end

        local endAt = content:find(MANAGED_END, startAt, true)
        if not endAt then break end

        local afterEnd = endAt + #MANAGED_END
        local nextLine = content:find("\n", afterEnd, true)
        if nextLine then
            content = content:sub(1, startAt - 1) .. content:sub(nextLine + 1)
        else
            content = content:sub(1, startAt - 1)
        end
    end

    return content
end

local function makeBackup(resource, path, content)
    local stamp = os.date("%Y%m%d-%H%M%S")
    local backupPath = path .. ".seoul-bak-" .. stamp
    SaveResourceFile(resource, backupPath, content or "", -1)
    return backupPath
end

local function insertIntoVrpItemFile(content, block)
    content = stripManagedBlock(content)
    local marker = "\n}\n-----------------------------------------------------------------------------------------------------------------------------------------\n-- VARIABLES"
    local idx = content:find(marker, 1, true)
    if not idx then return nil, "não encontrei o fechamento do local List antes de -- VARIABLES" end
    local before = content:sub(1, idx - 1):gsub("%s*$", "")
    local after = content:sub(idx)

    if before:sub(-1) ~= "," then
        before = before .. ","
    end

    return before .. "\n" .. block .. after
end

local function insertIntoOxItemsFile(content, block)
    content = stripManagedBlock(content)
    local lastBrace = content:match("^.*()\n}%s*$")
    if not lastBrace then return nil, "não encontrei o fechamento final do return do ox_inventory/data/items.lua" end
    local before = content:sub(1, lastBrace - 1):gsub("%s*$", "")
    local after = content:sub(lastBrace)

    if before:sub(-1) ~= "," then
        before = before .. ","
    end

    return before .. "\n\n" .. block .. after
end

local function validateLuaText(name, content)
    if not content or content == "" then return false, name .. " ficou vazio" end
    if content:find(MANAGED_START, 1, true) and not content:find(MANAGED_END, 1, true) then
        return false, name .. " ficou com bloco gerado sem fechamento"
    end
    return true
end

local function toVrpRuntimeItem(item)
    local entry = {
        ["Index"] = item.index,
        ["Name"] = item.label,
        ["Type"] = item.type,
        ["Weight"] = item.weight,
        ["Market"] = luaBool(item.market, true) == "true",
        ["Delete"] = luaBool(item.delete, true) == "true",
        ["SeoulAdminControl"] = true
    }

    if item.description and item.description ~= "" then entry["Description"] = item.description end
    if item.durability then entry["Durability"] = asNumber(item.durability, 0) end
    if item.rarity and item.rarity ~= "" then entry["Rarity"] = item.rarity end
    if item.execute then
        entry["Execute"] = {
            ["Type"] = item.execute.Type or "Client",
            ["Event"] = item.execute.Event
        }
    end

    return entry
end

local function toOxRuntimeItem(item)
    local entry = {
        name = item.item,
        label = item.label,
        weight = math.floor((item.weight or 0) * 1000 + 0.5),
        stack = luaBool(item.stack, true) == "true",
        close = luaBool(item.close, true) == "true",
        seoulAdminControl = true
    }

    if item.description and item.description ~= "" then entry.description = item.description end

    if item.execute and lower(item.execute.Type) == "server" then
        entry.server = { event = item.execute.Event }
        entry.client = { image = item.image }
    else
        entry.client = { image = item.image }
        if item.execute and item.execute.Event then entry.client.event = item.execute.Event end
    end

    return entry
end

local function injectVrpRuntime(items)
    local count = 0
    if type(items) ~= "table" then return count end

    for _, item in ipairs(items) do
        TriggerEvent("AddItem", item.item, toVrpRuntimeItem(item))
        count = count + 1
    end

    lastVrpRuntime = count
    if count > 0 then debugPrint("^2[Seoul Items]^7 vRP runtime recebeu " .. tostring(count) .. " itens do AdminControl.") end
    return count
end

local function getOxItemList()
    if GetResourceState(OX_RESOURCE) ~= "started" then return nil end

    local ok, result = pcall(function()
        return exports[OX_RESOURCE]:Items()
    end)

    if ok and type(result) == "table" then return result end
    return nil
end

local function injectOxRuntime(items)
    local oxItems = getOxItemList()
    if not oxItems then return 0 end

    local count = 0
    for _, item in ipairs(items) do
        oxItems[item.item] = toOxRuntimeItem(item)
        if oxItems[item.item] then count = count + 1 end
    end

    lastOxRuntime = count
    if count > 0 then debugPrint("^2[Seoul Items]^7 OX runtime recebeu " .. tostring(count) .. " itens do AdminControl.") end
    return count
end

local function countOxRuntime(items)
    local oxItems = getOxItemList()
    if not oxItems or type(items) ~= "table" then return 0 end

    local count = 0
    for _, item in ipairs(items) do
        if oxItems[item.item] then count = count + 1 end
    end

    return count
end

local function refreshRuntimeItems(reason)
    local items = collectItems()
    if type(items) ~= "table" or #items == 0 then return 0, 0 end

    local vrpCount = injectVrpRuntime(items)
    local oxCount = injectOxRuntime(items)

    if reason then
        debugPrint(("^3[Seoul Items]^7 Runtime sync (%s): vRP %s | OX %s"):format(reason, vrpCount, oxCount))
    end

    return vrpCount, oxCount
end

local function buildReport()
    local normalized, skipped, errors, missingImages = collectItems()
    local vrpText = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH) or ""
    local oxItemsText = LoadResourceFile(OX_RESOURCE, OX_ITEMS_PATH) or ""
    local oxWeaponsText = LoadResourceFile(OX_RESOURCE, OX_WEAPONS_PATH) or ""

    local inVrpFile, inOxFile, inWeapons = 0, 0, 0
    local missingVrp, missingOx = {}, {}
    for _, item in ipairs(normalized) do
        if itemExistsInText(vrpText, item.item) then inVrpFile = inVrpFile + 1 else missingVrp[#missingVrp + 1] = item.item end
        if itemExistsInText(oxItemsText, item.item) then inOxFile = inOxFile + 1 else missingOx[#missingOx + 1] = item.item end
        if itemExistsInText(oxWeaponsText, item.item) then inWeapons = inWeapons + 1 end
    end

    local inOxRuntime = countOxRuntime(normalized)
    local inVrpRuntime = lastVrpRuntime
    local inVrp = math.max(inVrpFile, inVrpRuntime)
    local inOx = math.max(inOxFile, inOxRuntime, lastOxRuntime)

    return {
        total = #normalized + #skipped + #errors,
        normal = #normalized,
        skipped = skipped,
        errors = errors,
        missingImages = missingImages,
        inVrp = inVrp,
        inOx = inOx,
        inVrpFile = inVrpFile,
        inOxFile = inOxFile,
        inVrpRuntime = inVrpRuntime,
        inOxRuntime = inOxRuntime,
        inWeapons = inWeapons,
        missingVrp = missingVrp,
        missingOx = missingOx,
        items = normalized
    }
end

local function printReport(source, report, detail)
    detail = detail == true

    debugPrint("^3[Seoul Items]^7 Itens staging: " .. tostring(report.total) .. " | comuns fase 1: " .. tostring(report.normal) .. " | pulados: " .. tostring(#report.skipped) .. " | erros: " .. tostring(#report.errors))
    debugPrint("^3[Seoul Items]^7 Presentes: vRP " .. tostring(report.inVrp) .. "/" .. tostring(report.normal) .. " | OX " .. tostring(report.inOx) .. "/" .. tostring(report.normal) .. " | OX weapons " .. tostring(report.inWeapons))
    debugPrint("^3[Seoul Items]^7 Detalhe: vRP arquivo " .. tostring(report.inVrpFile or 0) .. " | vRP runtime " .. tostring(report.inVrpRuntime or 0) .. " | OX arquivo " .. tostring(report.inOxFile or 0) .. " | OX runtime " .. tostring(report.inOxRuntime or 0))

    if #report.errors > 0 then debugPrint("^1[Seoul Items]^7 Erros: " .. table.concat(report.errors, ", ")) end
    if #report.skipped > 0 then debugPrint("^3[Seoul Items]^7 Pulados nesta fase: " .. table.concat(report.skipped, ", ")) end

    if detail and #report.missingImages > 0 then
        debugPrint("^3[Seoul Items]^7 Imagens faltando: " .. table.concat(report.missingImages, ", "))
    elseif #report.missingImages > 0 then
        debugPrint("^3[Seoul Items]^7 Existem " .. tostring(#report.missingImages) .. " imagens faltando. Use /seoulitemsdebug para listar. Isso não bloqueia item comum.")
    end

    local text = ("Staging: %s | comuns: %s | vRP: %s | OX: %s"):format(report.total, report.normal, report.inVrp, report.inOx)
    if #report.errors > 0 then text = text .. " | erros: " .. tostring(#report.errors) end
    if #report.skipped > 0 then text = text .. " | armas/munições puladas: " .. tostring(#report.skipped) end
    notify(source, "Seoul Items", text, 9000)
end

local function hasValue(list, value)
    if type(list) ~= "table" then return false end
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

local function buildClientReport()
    local report = buildReport()
    local missingImageMap = {}
    for _, entry in ipairs(report.missingImages or {}) do
        local item = tostring(entry):match("^(.-)%s*%-%>") or tostring(entry)
        item = trim(item)
        if item ~= "" then missingImageMap[item] = true end
    end

    local vrpText = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH) or ""
    local oxItemsText = LoadResourceFile(OX_RESOURCE, OX_ITEMS_PATH) or ""
    local oxItems = getOxItemList()
    local list = {}

    for _, item in ipairs(report.items or {}) do
        local inVrp = itemExistsInText(vrpText, item.item)
        local inOx = itemExistsInText(oxItemsText, item.item) or (oxItems and oxItems[item.item] ~= nil) or false

        list[#list + 1] = {
            item = item.item,
            label = item.label,
            type = item.type,
            weight = item.weight,
            image = item.image,
            inVrp = inVrp,
            inOx = inOx,
            imageMissing = missingImageMap[item.item] == true
        }
    end

    return {
        total = report.total,
        normal = report.normal,
        inVrp = report.inVrp,
        inOx = report.inOx,
        inVrpFile = report.inVrpFile,
        inOxFile = report.inOxFile,
        inVrpRuntime = report.inVrpRuntime,
        inOxRuntime = report.inOxRuntime,
        skipped = #report.skipped,
        errors = #report.errors,
        missingImages = #report.missingImages,
        skippedList = report.skipped,
        errorsList = report.errors,
        missingImagesList = report.missingImages,
        items = list
    }
end

local function generateItems(source)
    local report = buildReport()
    if #report.errors > 0 then
        printReport(source, report, true)
        notify(source, "Negado", "Corrija os erros do staging antes de gerar. Veja o console.", 8000)
        return false
    end

    local vrpText = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH)
    local oxText = LoadResourceFile(OX_RESOURCE, OX_ITEMS_PATH)
    if not vrpText or vrpText == "" then return notify(source, "Erro", "Não consegui ler vrp/config/Item.lua", 8000) end
    if not oxText or oxText == "" then return notify(source, "Erro", "Não consegui ler ox_inventory/data/items.lua", 8000) end

    local vrpBlock = renderManagedBlock(report.items, renderVrpEntry)
    local oxBlock = renderManagedBlock(report.items, renderOxEntry)
    local newVrp, errVrp = insertIntoVrpItemFile(vrpText, vrpBlock)
    if not newVrp then return notify(source, "Erro", "vRP Item.lua: " .. tostring(errVrp), 10000) end
    local newOx, errOx = insertIntoOxItemsFile(oxText, oxBlock)
    if not newOx then return notify(source, "Erro", "OX items.lua: " .. tostring(errOx), 10000) end

    local okVrp, validErrVrp = validateLuaText("vRP Item.lua", newVrp)
    local okOx, validErrOx = validateLuaText("OX items.lua", newOx)
    if not okVrp then return notify(source, "Erro", validErrVrp, 10000) end
    if not okOx then return notify(source, "Erro", validErrOx, 10000) end

    local backupVrp = makeBackup(VRP_RESOURCE, VRP_ITEMS_PATH, vrpText)
    local backupOx = makeBackup(OX_RESOURCE, OX_ITEMS_PATH, oxText)
    SaveResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH, newVrp, -1)
    SaveResourceFile(OX_RESOURCE, OX_ITEMS_PATH, newOx, -1)

    Wait(250)

    local writtenVrp = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH) or ""
    local writtenOx = LoadResourceFile(OX_RESOURCE, OX_ITEMS_PATH) or ""
    local writtenVrpCount = countItemsInText(writtenVrp, report.items)
    local writtenOxCount = countItemsInText(writtenOx, report.items)
    local vrpRuntimeCount = injectVrpRuntime(report.items)
    local oxRuntimeCount = injectOxRuntime(report.items)

    debugPrint("^2[Seoul Items]^7 Gerados " .. tostring(report.normal) .. " itens comuns em vRP + OX.")
    debugPrint("^2[Seoul Items]^7 Backups: " .. VRP_RESOURCE .. "/" .. backupVrp .. " | " .. OX_RESOURCE .. "/" .. backupOx)
    debugPrint("^3[Seoul Items]^7 Pós-gravação: vRP arquivo " .. tostring(writtenVrpCount) .. "/" .. tostring(report.normal) .. " | OX arquivo " .. tostring(writtenOxCount) .. "/" .. tostring(report.normal) .. " | vRP runtime " .. tostring(vrpRuntimeCount) .. " | OX runtime " .. tostring(oxRuntimeCount))
    if #report.missingImages > 0 then debugPrint("^3[Seoul Items]^7 Atenção: imagens faltando: " .. table.concat(report.missingImages, ", ")) end
    if #report.skipped > 0 then debugPrint("^3[Seoul Items]^7 Armas/munições/componentes pulados nesta fase: " .. table.concat(report.skipped, ", ")) end

    if writtenVrpCount == 0 and writtenOxCount == 0 and vrpRuntimeCount == 0 and oxRuntimeCount == 0 and report.normal > 0 then
        notify(source, "Erro", "A geração rodou, mas não refletiu em arquivo/runtime. Veja o console.", 10000)
        return false
    end

    notify(source, "Sucesso", "Itens sincronizados. Reinicie ox_inventory para recarregar limpo.", 10000)
    return true
end

AddEventHandler("onServerResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        GlobalState:set("AdminControlItems", GetControlFile("items") or {}, true)
        CreateThread(function()
            Wait(2500)
            refreshRuntimeItems("AdminControl start")
        end)
    elseif resourceName == VRP_RESOURCE or resourceName == OX_RESOURCE then
        CreateThread(function()
            Wait(2500)
            refreshRuntimeItems(resourceName .. " start")
        end)
    end
end)

RegisterCommand(Config.Commands["items"]["command"], function(source)
    if AdminControlCanUse(source, Config.Commands["items"].perm) then
        TriggerClientEvent("AdminControl:openItems", source)
    end
end)

RegisterCommand("seoulitemsstatus", function(source)
    if not adminAllowed(source) then return end
    local report = buildReport()
    printReport(source, report, false)
end)

RegisterCommand("seoulitemsdebug", function(source)
    if not adminAllowed(source) then return end
    local report = buildReport()
    printReport(source, report, true)
    debugPrint("^3[Seoul Items]^7 Resource states: vrp=" .. tostring(GetResourceState(VRP_RESOURCE)) .. " | ox_inventory=" .. tostring(GetResourceState(OX_RESOURCE)) .. " | AdminControl=" .. tostring(GetResourceState(GetCurrentResourceName())))
    debugPrint("^3[Seoul Items]^7 Bloco em arquivo: vRP=" .. tostring((LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH) or ""):find(MANAGED_START, 1, true) ~= nil) .. " | OX=" .. tostring((LoadResourceFile(OX_RESOURCE, OX_ITEMS_PATH) or ""):find(MANAGED_START, 1, true) ~= nil))
end)

RegisterCommand("seoulvalidateitems", function(source)
    if not adminAllowed(source) then return end
    local report = buildReport()
    printReport(source, report, false)
    if #report.errors == 0 then
        notify(source, "Sucesso", "Validação concluída. Erros: 0. Imagens não bloqueiam item comum.", 7000)
    else
        notify(source, "Atenção", "Validação encontrou erros. Veja o console.", 8000)
    end
end)

RegisterCommand("seoulgenerateitems", function(source)
    if not adminAllowed(source) then return end
    generateItems(source)
end)

RegisterCommand("seoulsyncitems", function(source)
    if not adminAllowed(source) then return end
    local vrpCount, oxCount = refreshRuntimeItems("command")
    notify(source, "Sucesso", ("Runtime sincronizado: vRP %s | OX %s"):format(vrpCount, oxCount), 7000)
end)

local function resolveItemCode(data)
    if type(data) ~= "table" then return false end

    -- IMPORTANTE:
    -- data.name/name é o nome visual/label, pode ter espaço e acento.
    -- O código interno do item sempre vem em data.item/Item ou no primeiro campo.
    -- A versão anterior priorizava data.name e por isso "Pistola 9mm" dava
    -- "Nome do item inválido" mesmo com item = WEAPON_PISTOL correto.
    return safeItemName(data.item or data.Item or data[1] or data.code or data.Code)
end

RegisterNetEvent("AdminControl:createNewItem")
AddEventHandler("AdminControl:createNewItem", function(data)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    local items = GetControlFile("items") or {}
    local name = resolveItemCode(data)
    if not name or name == "" then return AdminControlNotify(source,"Negado","Código do item inválido. Use o campo Item/WEAPON_ sem espaços.",7000) end
    data.item = name
    items[name] = data
    GlobalState:set("AdminControlItems", items, true)
    SaveAllFile("items", items)
    AdminControlNotify(source,"Sucesso","Item salvo no AdminControl. Use Gerar Itens para criar vRP + OX.",7000)
end)

RegisterNetEvent("AdminControl:editNewItem")
AddEventHandler("AdminControl:editNewItem", function(data)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    local items = GetControlFile("items") or {}
    local name = resolveItemCode(data)
    if not name or name == "" then return AdminControlNotify(source,"Negado","Código do item inválido. Use o campo Item/WEAPON_ sem espaços.",7000) end
    data.item = name
    items[name] = data
    GlobalState:set("AdminControlItems", items, true)
    SaveAllFile("items", items)
    AdminControlNotify(source,"Sucesso","Item editado no AdminControl. Gere os arquivos para aplicar no vRP + OX.",5000)
end)

RegisterNetEvent("AdminControl:deleteNewItem")
AddEventHandler("AdminControl:deleteNewItem", function(item)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    local items = GetControlFile("items") or {}
    items[item] = nil
    GlobalState:set("AdminControlItems", items, true)
    SaveAllFile("items", items)
    AdminControlNotify(source,"Sucesso","Item removido do AdminControl. Gere os arquivos para atualizar vRP + OX.",5000)
end)

RegisterNetEvent("AdminControl:validateItems")
AddEventHandler("AdminControl:validateItems", function()
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    local report = buildReport()
    printReport(source, report, false)
end)

RegisterNetEvent("AdminControl:syncRuntimeItems")
AddEventHandler("AdminControl:syncRuntimeItems", function()
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    local vrpCount, oxCount = refreshRuntimeItems("manual")
    notify(source, "Sucesso", ("Runtime sincronizado: vRP %s | OX %s"):format(vrpCount, oxCount), 7000)
end)

if lib and lib.callback then
    lib.callback.register("AdminControl:getItemsReport", function(source)
        if not adminAllowed(source) then return nil end
        return buildClientReport()
    end)
end

RegisterNetEvent("AdminControl:generateItems")
AddEventHandler("AdminControl:generateItems", function()
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    generateItems(source)
end)


-- SEOUL ITEMS FASE 3 WEAPONS
local WEAPONS_MANAGED_PREFIX = "-- SEOUL ADMINCONTROL WEAPONS"
local VRP_WEAPONS_START = "-- SEOUL ADMINCONTROL WEAPONS VRP START"
local VRP_WEAPONS_END = "-- SEOUL ADMINCONTROL WEAPONS VRP END"
local lastOxWeaponsRuntime = 0
local lastVrpWeaponsRuntime = 0

local function stripBlock(content, startMarker, endMarker)
    content = content or ""
    while true do
        local startAt = content:find(startMarker, 1, true)
        if not startAt then break end
        local endAt = content:find(endMarker, startAt, true)
        if not endAt then break end
        local afterEnd = endAt + #endMarker
        local nextLine = content:find("\n", afterEnd, true)
        if nextLine then
            content = content:sub(1, startAt - 1) .. content:sub(nextLine + 1)
        else
            content = content:sub(1, startAt - 1)
        end
    end
    return content
end

local function weaponMarkers(section)
    local upper = string.upper(section or "WEAPONS")
    return WEAPONS_MANAGED_PREFIX .. " " .. upper .. " START", WEAPONS_MANAGED_PREFIX .. " " .. upper .. " END"
end

local function stripWeaponsBlocks(content)
    for _, section in ipairs({"Weapons", "Ammo", "Components", "Tints"}) do
        local startMarker, endMarker = weaponMarkers(section)
        content = stripBlock(content, startMarker, endMarker)
    end
    return content
end

local function splitCsv(value)
    local list = {}
    if type(value) == "table" then
        for _, item in ipairs(value) do
            local str = trim(item)
            if str ~= "" then list[#list + 1] = str end
        end
        return list
    end

    value = trim(value)
    if value == "" then return list end
    for part in value:gmatch("[^,]+") do
        local str = trim(part):gsub("`", "")
        if str ~= "" then list[#list + 1] = str end
    end
    return list
end

local function normalizeWeaponKind(item, data)
    data = type(data) == "table" and data or {}
    local kind = lower(data.weaponKind or data.weapon_kind or data.weaponType or data.weapon_type or data.category or data.Category or data.kind or data.Kind or "")
    local typeLower = lower(data.type or data.Type or "")
    local itemLower = lower(item or "")

    if kind:find("tint", 1, true) or kind:find("tinta", 1, true) or typeLower:find("tinta", 1, true) then return "tint" end
    if kind:find("component", 1, true) or kind:find("attach", 1, true) or kind:find("anexo", 1, true) or typeLower:find("component", 1, true) or typeLower:find("anexo", 1, true) then return "component" end
    if kind:find("ammo", 1, true) or kind:find("muni", 1, true) or typeLower:find("ammo", 1, true) or typeLower:find("muni", 1, true) then return "ammo" end
    if tostring(item or ""):match("^WEAPON_.+_AMMO$") or itemLower:find("^ammo%-") then return "ammo" end
    if tostring(item or ""):match("^WEAPON_") then return "weapon" end
    if itemLower:find("^at_") or itemLower:find("component") or itemLower:find("attach") then return "component" end
    if typeLower:find("arma", 1, true) or typeLower:find("weapon", 1, true) then return "weapon" end
    return nil
end

local function mapOxAmmoToVrp(ammo)
    ammo = trim(ammo)
    if ammo == "" then return "" end
    if ammo:match("^WEAPON_") then return ammo end
    local map = {
        ["ammo-9"] = "WEAPON_PISTOL_AMMO",
        ["ammo-22"] = "WEAPON_PISTOL_AMMO",
        ["ammo-38"] = "WEAPON_PISTOL_AMMO",
        ["ammo-44"] = "WEAPON_PISTOL_AMMO",
        ["ammo-45"] = "WEAPON_PISTOL_AMMO",
        ["ammo-50"] = "WEAPON_PISTOL_AMMO",
        ["ammo-rifle"] = "WEAPON_RIFLE_AMMO",
        ["ammo-rifle2"] = "WEAPON_RIFLE_AMMO",
        ["ammo-sniper"] = "WEAPON_RIFLE_AMMO",
        ["ammo-heavysniper"] = "WEAPON_RIFLE_AMMO",
        ["ammo-shotgun"] = "WEAPON_SHOTGUN_AMMO",
        ["ammo-musket"] = "WEAPON_MUSKET_AMMO",
        ["ammo-rocket"] = "WEAPON_RPG_AMMO",
        ["ammo-grenade"] = "WEAPON_RPG_AMMO",
        ["ammo-firework"] = "WEAPON_RPG_AMMO",
        ["ammo-flare"] = "WEAPON_PISTOL_AMMO",
        ["ammo-emp"] = "WEAPON_RIFLE_AMMO"
    }
    return map[ammo] or ammo
end

local function normalizeWeaponItem(key, data)
    data = type(data) == "table" and data or {}
    local item = safeItemName(data.item or data.Item or key)
    if not item then return nil, tostring(key) .. ": nome inválido" end

    local kind = normalizeWeaponKind(item, data)
    if not kind then return nil, item .. ": não é arma/munição/componente/tinta" end

    if kind == "weapon" and not item:match("^WEAPON_[A-Z0-9_]+$") then
        return nil, item .. ": arma precisa usar nome WEAPON_ em maiúsculo"
    end

    local label = trim(data.name or data.Name or data.label or data.Label or item)
    if label == "" then label = item end
    local index = normalizeIndex(item, data)
    local image = trim(data.imageFile or data.image_file or data.image or data.Image or (index .. ".png"))
    if image == "" then image = index .. ".png" end
    if not image:find("%.") then image = image .. ".png" end

    local weightKg = asNumber(data.weight or data.Weight or data.peso or data.Peso, kind == "ammo" and 0.01 or kind == "weapon" and 1.0 or 0.05)
    if weightKg < 0 then return nil, item .. ": peso negativo" end

    local description = trim(data.description or data.Description or data.desc or "")
    local ammoName = trim(data.ammoname or data.ammoName or data.ammo_name or data.ammo or data.Ammo or "")
    local vrpAmmo = trim(data.vrpAmmo or data.vrp_ammo or data.Ammo or "")
    local model = trim(data.model or data.Model or "")
    local componentType = trim(data.componentType or data.component_type or data.attachType or data.attach_type or data.typeKey or data.type_key or "")
    local componentHashes = splitCsv(data.components or data.component or data.Component or data.hashes or data.hash or data.Hash)
    local tint = tonumber(data.tint or data.Tint or data.tintIndex or data.tint_index)

    if kind == "component" and #componentHashes == 0 then
        return nil, item .. ": componente/anexo precisa do hash COMPONENT_"
    end

    if kind == "weapon" and ammoName == "" and vrpAmmo ~= "" then
        ammoName = vrpAmmo
    end

    if kind == "weapon" and vrpAmmo == "" and ammoName ~= "" then
        vrpAmmo = mapOxAmmoToVrp(ammoName)
    end

    if componentType == "" then
        if kind == "component" then componentType = "attachment" elseif kind == "tint" then componentType = "tint" end
    end

    return {
        item = item,
        kind = kind,
        label = label,
        index = index,
        image = image,
        weight = weightKg,
        oxWeight = math.floor(weightKg * 1000 + 0.5),
        description = description,
        ammoName = ammoName,
        vrpAmmo = vrpAmmo,
        model = model,
        durability = asNumber(data.oxDurability or data.durabilityOx or data.durability or data.Durability, kind == "weapon" and 0.05 or 0),
        vrpDurability = asNumber(data.vrpDurability or data.durabilityVrp or data.DurabilityVrp, kind == "weapon" and 240 or 0),
        throwable = data.throwable or data.ThrowAble or data.Throw or false,
        componentType = componentType,
        componentHashes = componentHashes,
        usetime = asNumber(data.usetime or data.useTime or data.use_time, 2500),
        tint = tint,
        market = data.Market ~= nil and data.Market or data.market,
        delete = data.Delete ~= nil and data.Delete or data.delete,
        arrest = data.Arrest ~= nil and data.Arrest or data.arrest,
        serial = data.Serial ~= nil and data.Serial or data.serial,
        blueprint = data.Blueprint ~= nil and data.Blueprint or data.blueprint
    }
end

local function collectWeaponItems()
    local sourceItems = GetControlFile("items") or {}
    local weapons, ammo, components, tints = {}, {}, {}, {}
    local errors, missingImages = {}, {}

    for _, key in ipairs(sortedKeys(sourceItems)) do
        local data = sourceItems[key]
        local itemName = safeItemName((type(data) == "table" and (data.item or data.Item)) or key)
        if itemName and isWeaponLike(itemName, data) then
            local entry, err = normalizeWeaponItem(key, data)
            if entry then
                if not imageExists(entry.image) then missingImages[#missingImages + 1] = entry.item .. " -> " .. entry.image end
                if entry.kind == "weapon" then weapons[#weapons + 1] = entry
                elseif entry.kind == "ammo" then ammo[#ammo + 1] = entry
                elseif entry.kind == "component" then components[#components + 1] = entry
                elseif entry.kind == "tint" then tints[#tints + 1] = entry end
            else
                errors[#errors + 1] = err
            end
        end
    end

    local function sortByItem(a,b) return a.item < b.item end
    table.sort(weapons, sortByItem)
    table.sort(ammo, sortByItem)
    table.sort(components, sortByItem)
    table.sort(tints, sortByItem)

    return { Weapons = weapons, Ammo = ammo, Components = components, Tints = tints, errors = errors, missingImages = missingImages }
end

local function allWeaponEntries(collection)
    local all = {}
    if type(collection) ~= "table" then return all end
    for _, section in ipairs({"Weapons", "Ammo", "Components", "Tints"}) do
        for _, item in ipairs(collection[section] or {}) do all[#all + 1] = item end
    end
    table.sort(all, function(a,b) return a.item < b.item end)
    return all
end

local function renderBacktickArray(values, indent)
    indent = indent or "\t\t\t\t"
    local lines = {}
    for _, value in ipairs(values or {}) do
        lines[#lines + 1] = indent .. "`" .. tostring(value):gsub("`", "") .. "`,"
    end
    return table.concat(lines, "\n")
end

local function renderOxWeaponEntry(item)
    local lines = {}
    lines[#lines + 1] = "\t\t[" .. luaString(item.item) .. "] = {"
    lines[#lines + 1] = "\t\t\tlabel = " .. luaString(item.label) .. ","
    lines[#lines + 1] = "\t\t\tweight = " .. tostring(item.oxWeight) .. ","
    lines[#lines + 1] = "\t\t\tdurability = " .. tostring(item.durability) .. ","
    if item.ammoName ~= "" then lines[#lines + 1] = "\t\t\tammoname = " .. luaString(item.ammoName) .. "," end
    if item.model ~= "" and item.model ~= item.item then lines[#lines + 1] = "\t\t\tmodel = " .. luaString(item.model) .. "," end
    if luaBool(item.throwable, false) == "true" then lines[#lines + 1] = "\t\t\tthrowable = true," end
    if item.image and item.image ~= "" then
        lines[#lines + 1] = "\t\t\tclient = {"
        lines[#lines + 1] = "\t\t\t\timage = " .. luaString(item.image) .. ","
        lines[#lines + 1] = "\t\t\t},"
    end
    lines[#lines + 1] = "\t\t\tseoulAdminControl = true"
    lines[#lines + 1] = "\t\t},"
    return table.concat(lines, "\n")
end

local function renderOxAmmoEntry(item)
    local lines = {}
    lines[#lines + 1] = "\t\t[" .. luaString(item.item) .. "] = {"
    lines[#lines + 1] = "\t\t\tlabel = " .. luaString(item.label) .. ","
    lines[#lines + 1] = "\t\t\tweight = " .. tostring(item.oxWeight) .. ","
    if item.image and item.image ~= "" then
        lines[#lines + 1] = "\t\t\tclient = { image = " .. luaString(item.image) .. " },"
    end
    lines[#lines + 1] = "\t\t\tseoulAdminControl = true"
    lines[#lines + 1] = "\t\t},"
    return table.concat(lines, "\n")
end

local function renderOxComponentEntry(item)
    local lines = {}
    lines[#lines + 1] = "\t\t[" .. luaString(item.item) .. "] = {"
    lines[#lines + 1] = "\t\t\tlabel = " .. luaString(item.label) .. ","
    lines[#lines + 1] = "\t\t\ttype = " .. luaString(item.componentType ~= "" and item.componentType or "attachment") .. ","
    lines[#lines + 1] = "\t\t\tweight = " .. tostring(item.oxWeight) .. ","
    lines[#lines + 1] = "\t\t\tclient = {"
    lines[#lines + 1] = "\t\t\t\tcomponent = {"
    lines[#lines + 1] = renderBacktickArray(item.componentHashes, "\t\t\t\t\t")
    lines[#lines + 1] = "\t\t\t\t},"
    lines[#lines + 1] = "\t\t\t\tusetime = " .. tostring(item.usetime) .. ","
    if item.image and item.image ~= "" then lines[#lines + 1] = "\t\t\t\timage = " .. luaString(item.image) .. "," end
    lines[#lines + 1] = "\t\t\t},"
    lines[#lines + 1] = "\t\t\tseoulAdminControl = true"
    lines[#lines + 1] = "\t\t},"
    return table.concat(lines, "\n")
end

local function renderOxTintEntry(item)
    local lines = {}
    lines[#lines + 1] = "\t\t[" .. luaString(item.item) .. "] = {"
    lines[#lines + 1] = "\t\t\tlabel = " .. luaString(item.label) .. ","
    lines[#lines + 1] = "\t\t\tweight = " .. tostring(item.oxWeight) .. ","
    lines[#lines + 1] = "\t\t\ttint = " .. tostring(item.tint or 0) .. ","
    if item.image and item.image ~= "" then lines[#lines + 1] = "\t\t\tclient = { image = " .. luaString(item.image) .. " }," end
    lines[#lines + 1] = "\t\t\tseoulAdminControl = true"
    lines[#lines + 1] = "\t\t},"
    return table.concat(lines, "\n")
end

local function renderWeaponSectionBlock(section, items, renderer)
    if not items or #items == 0 then return nil end
    local startMarker, endMarker = weaponMarkers(section)
    local lines = { "\t\t" .. startMarker, "\t\t-- Gerado pelo AdminControl Seoul. Fonte: AdminControl/data/items.json" }
    for _, item in ipairs(items) do lines[#lines + 1] = renderer(item) end
    lines[#lines + 1] = "\t\t" .. endMarker
    return table.concat(lines, "\n")
end

local function findSection(content, sectionName)
    local pattern = sectionName .. "%s*=%s*{"
    local startAt, endAt = content:find(pattern)
    if not startAt then return nil end
    local openAt = content:find("{", startAt, true)
    if not openAt then return nil end
    local depth = 0
    for i = openAt, #content do
        local ch = content:sub(i, i)
        if ch == "{" then depth = depth + 1
        elseif ch == "}" then
            depth = depth - 1
            if depth == 0 then return startAt, openAt, i end
        end
    end
    return nil
end

local function insertIntoWeaponsSection(content, sectionName, block)
    if not block then return content end
    local sectionStart, openAt, closeAt = findSection(content, sectionName)
    if not sectionStart then
        local finalAt = content:match("^.*()\n}%s*$")
        if not finalAt then return nil, "não encontrei fechamento final do data/weapons.lua para criar seção " .. sectionName end
        local before = content:sub(1, finalAt - 1):gsub("%s*$", "")
        local after = content:sub(finalAt)
        if before:sub(-1) ~= "," then before = before .. "," end
        return before .. "\n\n\t" .. sectionName .. " = {\n" .. block .. "\n\t}\n" .. after
    end

    local before = content:sub(1, closeAt - 1):gsub("%s*$", "")
    local after = content:sub(closeAt)
    local tail = before:sub(-1)
    if tail ~= "{" and tail ~= "," then before = before .. "," end
    return before .. "\n" .. block .. "\n\t" .. after
end

local function renderVrpWeaponEntry(item)
    local typeName = item.kind == "weapon" and "Armamento" or item.kind == "ammo" and "Munição" or item.kind == "tint" and "Tinta" or "Componente"
    local lines = {}
    lines[#lines + 1] = "\t[" .. luaString(item.item) .. "] = {"
    lines[#lines + 1] = "\t\t[\"Index\"] = " .. luaString(item.index) .. ","
    lines[#lines + 1] = "\t\t[\"Name\"] = " .. luaString(item.label) .. ","
    if item.description and item.description ~= "" then lines[#lines + 1] = "\t\t[\"Description\"] = " .. luaString(item.description) .. "," end
    lines[#lines + 1] = "\t\t[\"Type\"] = " .. luaString(typeName) .. ","
    if item.kind == "weapon" then
        lines[#lines + 1] = "\t\t[\"Repair\"] = \"repairkit02\","
        lines[#lines + 1] = "\t\t[\"Arrest\"] = " .. luaBool(item.arrest, true) .. ","
        lines[#lines + 1] = "\t\t[\"Serial\"] = " .. luaBool(item.serial, true) .. ","
        if item.vrpAmmo ~= "" then lines[#lines + 1] = "\t\t[\"Ammo\"] = " .. luaString(item.vrpAmmo) .. "," end
        lines[#lines + 1] = "\t\t[\"Blueprint\"] = " .. luaBool(item.blueprint, true) .. ","
        lines[#lines + 1] = "\t\t[\"Durability\"] = " .. tostring(item.vrpDurability) .. ","
    elseif item.kind == "ammo" then
        lines[#lines + 1] = "\t\t[\"Blueprint\"] = " .. luaBool(item.blueprint, true) .. ","
        lines[#lines + 1] = "\t\t[\"Arrest\"] = " .. luaBool(item.arrest, true) .. ","
    end
    lines[#lines + 1] = "\t\t[\"Market\"] = " .. luaBool(item.market, true) .. ","
    lines[#lines + 1] = "\t\t[\"Delete\"] = " .. luaBool(item.delete, true) .. ","
    lines[#lines + 1] = "\t\t[\"Weight\"] = " .. tostring(item.weight) .. ","
    lines[#lines + 1] = "\t\t[\"SeoulAdminControlWeapon\"] = true"
    lines[#lines + 1] = "\t},"
    return table.concat(lines, "\n")
end

local function renderVrpWeaponsBlock(items)
    if not items or #items == 0 then return nil end
    local lines = { VRP_WEAPONS_START, "-- Gerado pelo AdminControl Seoul. Armas/munições/componentes/tintas." }
    for _, item in ipairs(items) do lines[#lines + 1] = renderVrpWeaponEntry(item) end
    lines[#lines + 1] = VRP_WEAPONS_END
    return table.concat(lines, "\n")
end

local function insertIntoVrpWeaponFile(content, block)
    if not block then return content end
    content = stripBlock(content, VRP_WEAPONS_START, VRP_WEAPONS_END)
    local marker = "\n}\n-----------------------------------------------------------------------------------------------------------------------------------------\n-- VARIABLES"
    local idx = content:find(marker, 1, true)
    if not idx then return nil, "não encontrei o fechamento do local List antes de -- VARIABLES" end
    local before = content:sub(1, idx - 1):gsub("%s*$", "")
    local after = content:sub(idx)
    if before:sub(-1) ~= "," then before = before .. "," end
    return before .. "\n" .. block .. after
end

local function toVrpWeaponRuntime(item)
    local entry = {
        ["Index"] = item.index,
        ["Name"] = item.label,
        ["Type"] = item.kind == "weapon" and "Armamento" or item.kind == "ammo" and "Munição" or item.kind == "tint" and "Tinta" or "Componente",
        ["Weight"] = item.weight,
        ["Market"] = luaBool(item.market, true) == "true",
        ["Delete"] = luaBool(item.delete, true) == "true",
        ["SeoulAdminControlWeapon"] = true
    }
    if item.description and item.description ~= "" then entry["Description"] = item.description end
    if item.kind == "weapon" then
        entry["Repair"] = "repairkit02"
        entry["Arrest"] = luaBool(item.arrest, true) == "true"
        entry["Serial"] = luaBool(item.serial, true) == "true"
        entry["Blueprint"] = luaBool(item.blueprint, true) == "true"
        entry["Durability"] = item.vrpDurability
        if item.vrpAmmo ~= "" then entry["Ammo"] = item.vrpAmmo end
    elseif item.kind == "ammo" then
        entry["Blueprint"] = luaBool(item.blueprint, true) == "true"
        entry["Arrest"] = luaBool(item.arrest, true) == "true"
    end
    return entry
end

local function runtimeComponentHashes(list)
    local hashes = {}
    for _, value in ipairs(list or {}) do
        local str = tostring(value or ""):gsub("`", "")
        if str ~= "" then
            local ok, hashed = pcall(function()
                if joaat then return joaat(str) end
                return str
            end)
            hashes[#hashes + 1] = ok and hashed or str
        end
    end
    return hashes
end

local function toOxWeaponRuntime(item)
    local entry = {
        name = item.item,
        label = item.label,
        weight = item.oxWeight,
        close = item.kind == "ammo",
        stack = item.kind ~= "weapon" or luaBool(item.throwable, false) == "true",
        seoulAdminControl = true
    }
    if item.kind == "weapon" then
        entry.weapon = true
        entry.model = item.model ~= "" and item.model or item.item
        entry.hash = joaat(entry.model)
        entry.durability = item.durability ~= 0 and item.durability or 0.05
        entry.throwable = luaBool(item.throwable, false) == "true"
        if item.ammoName ~= "" then entry.ammoname = item.ammoName end
    elseif item.kind == "ammo" then
        entry.ammo = true
    elseif item.kind == "component" then
        entry.component = true
        entry.type = item.componentType ~= "" and item.componentType or "attachment"
        entry.client = { component = runtimeComponentHashes(item.componentHashes), usetime = item.usetime, image = item.image }
    elseif item.kind == "tint" then
        entry.tint = item.tint or 0
    end
    if not entry.client and item.image and item.image ~= "" then entry.client = { image = item.image } end
    return entry
end

local function injectWeaponsRuntime(collection)
    local all = allWeaponEntries(collection)
    local vrpCount, oxCount = 0, 0
    for _, item in ipairs(all) do
        TriggerEvent("AddItem", item.item, toVrpWeaponRuntime(item))
        vrpCount = vrpCount + 1
    end

    local oxItems = getOxItemList()
    if oxItems then
        for _, item in ipairs(all) do
            oxItems[item.item] = toOxWeaponRuntime(item)
            if oxItems[item.item] then oxCount = oxCount + 1 end
        end
    end

    lastVrpWeaponsRuntime = vrpCount
    lastOxWeaponsRuntime = oxCount
    if vrpCount > 0 or oxCount > 0 then
        debugPrint(("^2[Seoul Weapons]^7 Runtime sync: vRP %s | OX %s"):format(vrpCount, oxCount))
    end
    return vrpCount, oxCount
end

local function countOxWeaponsRuntime(items)
    local oxItems = getOxItemList()
    if not oxItems then return 0 end
    local count = 0
    for _, item in ipairs(items or {}) do if oxItems[item.item] then count = count + 1 end end
    return count
end

local function buildWeaponsReport()
    local collection = collectWeaponItems()
    local all = allWeaponEntries(collection)
    local vrpText = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH) or ""
    local weaponsText = LoadResourceFile(OX_RESOURCE, OX_WEAPONS_PATH) or ""
    local inVrpFile, inOxFile = 0, 0
    local missingVrp, missingOx = {}, {}

    for _, item in ipairs(all) do
        if itemExistsInText(vrpText, item.item) then inVrpFile = inVrpFile + 1 else missingVrp[#missingVrp + 1] = item.item end
        if itemExistsInText(weaponsText, item.item) then inOxFile = inOxFile + 1 else missingOx[#missingOx + 1] = item.item end
    end

    local oxRuntime = countOxWeaponsRuntime(all)
    return {
        total = #all,
        weapons = #collection.Weapons,
        ammo = #collection.Ammo,
        components = #collection.Components,
        tints = #collection.Tints,
        errors = collection.errors,
        missingImages = collection.missingImages,
        inVrp = math.max(inVrpFile, lastVrpWeaponsRuntime),
        inOx = math.max(inOxFile, oxRuntime, lastOxWeaponsRuntime),
        inVrpFile = inVrpFile,
        inOxFile = inOxFile,
        inOxRuntime = oxRuntime,
        missingVrp = missingVrp,
        missingOx = missingOx,
        items = all,
        collection = collection
    }
end

local function printWeaponsReport(source, report, detail)
    debugPrint(("^3[Seoul Weapons]^7 Staging weapons.lua: total %s | armas %s | munições %s | componentes %s | tintas %s | erros %s"):format(report.total, report.weapons, report.ammo, report.components, report.tints, #report.errors))
    debugPrint(("^3[Seoul Weapons]^7 Presentes: vRP %s/%s | OX weapons.lua %s/%s | OX runtime %s"):format(report.inVrp, report.total, report.inOxFile, report.total, report.inOxRuntime or 0))
    if #report.errors > 0 then debugPrint("^1[Seoul Weapons]^7 Erros: " .. table.concat(report.errors, ", ")) end
    if detail and #report.missingImages > 0 then debugPrint("^3[Seoul Weapons]^7 Imagens faltando: " .. table.concat(report.missingImages, ", ")) end
    local text = ("Weapons: %s | armas: %s | ammo: %s | comp: %s | tintas: %s | vRP: %s | OX: %s"):format(report.total, report.weapons, report.ammo, report.components, report.tints, report.inVrp, report.inOx)
    if #report.errors > 0 then text = text .. " | erros: " .. tostring(#report.errors) end
    notify(source, "Seoul Weapons", text, 9000)
end

local function buildClientWeaponsReport()
    local report = buildWeaponsReport()
    local list = {}
    local weaponsText = LoadResourceFile(OX_RESOURCE, OX_WEAPONS_PATH) or ""
    local vrpText = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH) or ""
    local oxItems = getOxItemList()
    for _, item in ipairs(report.items or {}) do
        list[#list + 1] = {
            item = item.item,
            label = item.label,
            kind = item.kind,
            weight = item.weight,
            ammoName = item.ammoName,
            componentType = item.componentType,
            inVrp = itemExistsInText(vrpText, item.item),
            inOx = itemExistsInText(weaponsText, item.item) or (oxItems and oxItems[item.item] ~= nil) or false
        }
    end
    return {
        total = report.total,
        weapons = report.weapons,
        ammo = report.ammo,
        components = report.components,
        tints = report.tints,
        errors = #report.errors,
        missingImages = #report.missingImages,
        inVrp = report.inVrp,
        inOx = report.inOx,
        inVrpFile = report.inVrpFile,
        inOxFile = report.inOxFile,
        inOxRuntime = report.inOxRuntime,
        errorsList = report.errors,
        missingImagesList = report.missingImages,
        items = list
    }
end

local function generateWeapons(source)
    local report = buildWeaponsReport()
    if #report.errors > 0 then
        printWeaponsReport(source, report, true)
        notify(source, "Negado", "Corrija os erros de armas/munições/componentes antes de gerar. Veja o console.", 10000)
        return false
    end

    local weaponsText = LoadResourceFile(OX_RESOURCE, OX_WEAPONS_PATH)
    local vrpText = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH)
    if not weaponsText or weaponsText == "" then return notify(source, "Erro", "Não consegui ler ox_inventory/data/weapons.lua", 10000) end
    if not vrpText or vrpText == "" then return notify(source, "Erro", "Não consegui ler vrp/config/Item.lua", 10000) end

    local newWeapons = stripWeaponsBlocks(weaponsText)
    local blockWeapons = renderWeaponSectionBlock("Weapons", report.collection.Weapons, renderOxWeaponEntry)
    local blockAmmo = renderWeaponSectionBlock("Ammo", report.collection.Ammo, renderOxAmmoEntry)
    local blockComponents = renderWeaponSectionBlock("Components", report.collection.Components, renderOxComponentEntry)
    local blockTints = renderWeaponSectionBlock("Tints", report.collection.Tints, renderOxTintEntry)

    local err
    newWeapons, err = insertIntoWeaponsSection(newWeapons, "Weapons", blockWeapons); if not newWeapons then return notify(source, "Erro", err, 10000) end
    newWeapons, err = insertIntoWeaponsSection(newWeapons, "Ammo", blockAmmo); if not newWeapons then return notify(source, "Erro", err, 10000) end
    newWeapons, err = insertIntoWeaponsSection(newWeapons, "Components", blockComponents); if not newWeapons then return notify(source, "Erro", err, 10000) end
    newWeapons, err = insertIntoWeaponsSection(newWeapons, "Tints", blockTints); if not newWeapons then return notify(source, "Erro", err, 10000) end

    local vrpBlock = renderVrpWeaponsBlock(report.items)
    local newVrp, errVrp = insertIntoVrpWeaponFile(vrpText, vrpBlock)
    if not newVrp then return notify(source, "Erro", "vRP Item.lua: " .. tostring(errVrp), 10000) end

    local okWeapons, validErrWeapons = validateLuaText("OX weapons.lua", newWeapons)
    local okVrp, validErrVrp = validateLuaText("vRP Item.lua", newVrp)
    if not okWeapons then return notify(source, "Erro", validErrWeapons, 10000) end
    if not okVrp then return notify(source, "Erro", validErrVrp, 10000) end

    local backupWeapons = makeBackup(OX_RESOURCE, OX_WEAPONS_PATH, weaponsText)
    local backupVrp = makeBackup(VRP_RESOURCE, VRP_ITEMS_PATH, vrpText)
    SaveResourceFile(OX_RESOURCE, OX_WEAPONS_PATH, newWeapons, -1)
    SaveResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH, newVrp, -1)

    Wait(250)
    local writtenWeapons = LoadResourceFile(OX_RESOURCE, OX_WEAPONS_PATH) or ""
    local writtenVrp = LoadResourceFile(VRP_RESOURCE, VRP_ITEMS_PATH) or ""
    local all = report.items
    local writtenOxCount = countItemsInText(writtenWeapons, all)
    local writtenVrpCount = countItemsInText(writtenVrp, all)
    local vrpRuntime, oxRuntime = injectWeaponsRuntime(report.collection)

    debugPrint(("^2[Seoul Weapons]^7 Gerados %s registros em weapons.lua + vRP Item.lua."):format(report.total))
    debugPrint("^2[Seoul Weapons]^7 Backups: " .. OX_RESOURCE .. "/" .. backupWeapons .. " | " .. VRP_RESOURCE .. "/" .. backupVrp)
    debugPrint(("^3[Seoul Weapons]^7 Pós-gravação: OX file %s/%s | vRP file %s/%s | runtime vRP %s | OX %s"):format(writtenOxCount, report.total, writtenVrpCount, report.total, vrpRuntime, oxRuntime))
    if #report.missingImages > 0 then debugPrint("^3[Seoul Weapons]^7 Imagens faltando: " .. table.concat(report.missingImages, ", ")) end

    notify(source, "Sucesso", "Weapons sincronizado. Reinicie ox_inventory para recarregar weapons.lua limpo.", 10000)
    return true
end

RegisterCommand("seoulweaponsstatus", function(source)
    if not adminAllowed(source) then return end
    printWeaponsReport(source, buildWeaponsReport(), false)
end)

RegisterCommand("seoulweaponsdebug", function(source)
    if not adminAllowed(source) then return end
    printWeaponsReport(source, buildWeaponsReport(), true)
end)

RegisterCommand("seoulvalidateweapons", function(source)
    if not adminAllowed(source) then return end
    local report = buildWeaponsReport()
    printWeaponsReport(source, report, false)
    if #report.errors == 0 then notify(source, "Sucesso", "Validação weapons.lua concluída. Erros: 0.", 7000) else notify(source, "Atenção", "Validação encontrou erros. Veja o console.", 9000) end
end)

RegisterCommand("seoulgenerateweapons", function(source)
    if not adminAllowed(source) then return end
    generateWeapons(source)
end)

RegisterCommand("seoulsyncweapons", function(source)
    if not adminAllowed(source) then return end
    local collection = collectWeaponItems()
    local vrpCount, oxCount = injectWeaponsRuntime(collection)
    notify(source, "Sucesso", ("Runtime weapons sincronizado: vRP %s | OX %s"):format(vrpCount, oxCount), 7000)
end)

RegisterNetEvent("AdminControl:validateWeapons")
AddEventHandler("AdminControl:validateWeapons", function()
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    printWeaponsReport(source, buildWeaponsReport(), false)
end)

RegisterNetEvent("AdminControl:generateWeapons")
AddEventHandler("AdminControl:generateWeapons", function()
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    generateWeapons(source)
end)

RegisterNetEvent("AdminControl:syncRuntimeWeapons")
AddEventHandler("AdminControl:syncRuntimeWeapons", function()
    local source = source
    if not AdminControlCanUse(source, Config.Commands["items"].perm) then return end
    local collection = collectWeaponItems()
    local vrpCount, oxCount = injectWeaponsRuntime(collection)
    notify(source, "Sucesso", ("Runtime weapons sincronizado: vRP %s | OX %s"):format(vrpCount, oxCount), 7000)
end)

if lib and lib.callback then
    lib.callback.register("AdminControl:getWeaponsReport", function(source)
        if not adminAllowed(source) then return nil end
        return buildClientWeaponsReport()
    end)
end

AddEventHandler("onServerResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() or resourceName == VRP_RESOURCE or resourceName == OX_RESOURCE then
        CreateThread(function()
            Wait(3500)
            local collection = collectWeaponItems()
            if #allWeaponEntries(collection) > 0 then injectWeaponsRuntime(collection) end
        end)
    end
end)
