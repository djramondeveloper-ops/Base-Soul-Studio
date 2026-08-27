local Proxy = module("vrp", "lib/Proxy") or {}
local vRP = Proxy.getInterface("vRP")

local saveCooldown = {}

local function notify(src, kind, message)
    TriggerClientEvent("Notify", src, kind or "negado", message, 5000)
end

local function getPassport(src)
    if not vRP then return nil end

    if type(vRP.Passport) == "function" then
        local ok, passport = pcall(vRP.Passport, src)
        if ok and passport then return passport end
    end

    if type(vRP.getUserId) == "function" then
        local ok, passport = pcall(vRP.getUserId, src)
        if ok and passport then return passport end
    end

    return nil
end

local function hasPermission(src)
    src = tonumber(src)
    if not src or src <= 0 then return false end

    local passport = getPassport(src)
    if not passport then return false end

    local permissions = {}
    local seen = {}

    local function addPermission(permission)
        if type(permission) == "string" and permission ~= "" and not seen[permission] then
            seen[permission] = true
            permissions[#permissions + 1] = permission
        end
    end

    addPermission(Config.AdminPermission)
    addPermission("admin.permissao")

    if type(Config.AdminGroups) == "table" then
        for i = 1, #Config.AdminGroups do
            addPermission(Config.AdminGroups[i])
        end
    end

    for i = 1, #permissions do
        local permission = permissions[i]

        if type(vRP.HasPermission) == "function" then
            local ok, allowed = pcall(vRP.HasPermission, passport, permission)
            if ok and allowed then return true end
        end

        if type(vRP.HasGroup) == "function" then
            local ok, allowed = pcall(vRP.HasGroup, passport, permission)
            if ok and allowed then return true end
        end

        if type(vRP.hasPermission) == "function" then
            local ok, allowed = pcall(vRP.hasPermission, passport, permission)
            if ok and allowed then return true end
        end
    end

    return false
end

local function validText(text)
    if type(text) ~= "string" then return nil end

    text = text:upper()
    text = text:gsub("^%s+", ""):gsub("%s+$", "")

    local maxCharacters = math.min(tonumber(Config.MaxCharacters) or #Config.Coords, #Config.Coords)
    if #text < 1 or #text > maxCharacters then return nil end
    if not text:match("^[A-Z ]+$") then return nil end

    return text
end

local function validColor(color)
    if type(color) ~= "string" then return nil end
    if not color:match("^#%x%x%x%x%x%x$") then return nil end
    return color:lower()
end

local function defaultSettings()
    return {
        validText(Config.DefaultText) or "SEOUL",
        validColor(Config.DefaultColor) or "#ffffff"
    }
end

local function getFileData()
    local raw = LoadResourceFile(GetCurrentResourceName(), Config.FileName)
    if not raw or raw == "" then
        return defaultSettings()
    end

    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= "table" then
        return defaultSettings()
    end

    local text = validText(data[1])
    local color = validColor(data[2])
    if not text or not color then
        return defaultSettings()
    end

    return { text, color }
end

local function openForPlayer(src)
    src = tonumber(src)
    if not src or src <= 0 or not hasPermission(src) then
        return false
    end

    local settings = getFileData()
    TriggerClientEvent("seoul_vinewood:openNui", src, settings[1], settings[2])
    return true
end

exports("OpenForPlayer", openForPlayer)
exports("HasPermission", hasPermission)

RegisterNetEvent("seoul_vinewood:saveText", function(data)
    local src = source

    if not hasPermission(src) then
        notify(src, "negado", "Sem permissão para editar o letreiro de Vinewood.")
        return
    end

    local now = os.time()
    if saveCooldown[src] and now - saveCooldown[src] < 1 then
        return
    end
    saveCooldown[src] = now

    if type(data) ~= "table" then return end

    local text = validText(data.text)
    local color = validColor(data.color)
    if not text or not color then
        notify(src, "negado", "Texto ou cor inválidos.")
        return
    end

    local settings = { text, color }
    SaveResourceFile(GetCurrentResourceName(), Config.FileName, json.encode(settings, { indent = true }), -1)
    TriggerClientEvent("seoul_vinewood:applyText", -1, settings)
    notify(src, "sucesso", "Letreiro de Vinewood atualizado.")
end)

RegisterNetEvent("seoul_vinewood:loadText", function()
    local src = source
    TriggerClientEvent("seoul_vinewood:applyText", src, getFileData())
end)

AddEventHandler("playerDropped", function()
    saveCooldown[source] = nil
end)
