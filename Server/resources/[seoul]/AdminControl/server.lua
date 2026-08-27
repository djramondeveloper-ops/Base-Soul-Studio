-----##########################################################-----
--###          ADMINCONTROL SEOUL - CORE
-----##########################################################-----

local CacheFiles = {}

local function decodeJson(data, fallback)
    if not data or data == "" then return fallback or {} end
    local ok, decoded = pcall(json.decode, data)
    if ok and decoded then return decoded end
    return fallback or {}
end

local function isArray(tbl)
    if type(tbl) ~= "table" then return false end
    local count, max = 0, 0
    for k,_ in pairs(tbl) do
        if type(k) ~= "number" then return false end
        count = count + 1
        if k > max then max = k end
    end
    return max == count
end

function GetControlFile(file)
    if CacheFiles[file] then return CacheFiles[file] end
    local data = LoadResourceFile(GetCurrentResourceName(), "data/"..file..".json")
    CacheFiles[file] = decodeJson(data, {})
    return CacheFiles[file]
end
exports("GetControlFile", GetControlFile)

local function notifySeoulBridgeAfterSave(file)
    file = tostring(file or "")
    if file ~= "baseconfig" and file ~= "groups" then return end

    CreateThread(function()
        Wait(300)
        if file == "baseconfig" then
            TriggerEvent("Seoul:AdminControl:ReloadConfig")
        elseif file == "groups" then
            TriggerEvent("Seoul:AdminControl:ReloadGroups")
        end
    end)
end

function SaveAllFile(file,result)
    CacheFiles[file] = result or {}
    SaveResourceFile(GetCurrentResourceName(), "data/"..file..".json", json.encode(CacheFiles[file], { indent = true }), -1)
    notifySeoulBridgeAfterSave(file)
end

function SaveControlFile(file,index,result)
    local data = GetControlFile(file)
    if data and data[index] == nil then
        data[index] = result
        SaveAllFile(file,data)
    end
end

function EditControlFile(file,index,result)
    local data = GetControlFile(file)
    if data then
        data[index] = result
        SaveAllFile(file,data)
    end
end

function RemoveControlFile(file,index)
    local data = GetControlFile(file)
    if data and data[index] ~= nil then
        if isArray(data) then table.remove(data,index) else data[index] = nil end
        SaveAllFile(file,data)
    end
end

-----##########################################################-----
--###          VRP / SEOUL HELPERS
-----##########################################################-----

Server = {}
Webhooks = {}
ClientControl = Tunnel.getInterface("AdminControl")
Tunnel.bindInterface("AdminControl", Server)

local function prepare(name, query)
    if vRP.Prepare then return vRP.Prepare(name, query) end
    if vRP.prepare then return vRP.prepare(name, query) end
end

local function query(name, params)
    if vRP.Query then return vRP.Query(name, params or {}) end
    if vRP.query then return vRP.query(name, params or {}) end
    return {}
end

prepare("AdminControl/get_all_characters", "SELECT id,Name,Lastname,License FROM characters WHERE Deleted = 0 GROUP BY License ORDER BY id ASC")

local function Passport(source)
    if not source or source <= 0 then return false end
    if vRP.Passport then return vRP.Passport(source) end
    if vRP.getUserId then return vRP.getUserId(source) end
    return false
end

local function HasPermission(passport, permission)
    if not passport then return false end
    permission = permission or Config.AdminPermission or "Admin"
    if permission == "admin.permissao" or permission == "owner.permissao" then permission = Config.AdminPermission or "Admin" end
    if vRP.HasPermission and vRP.HasPermission(passport, permission) then return true end
    if vRP.HasGroup and vRP.HasGroup(passport, permission) then return true end
    if vRP.hasPermission and vRP.hasPermission(passport, permission) then return true end
    if permission ~= "Admin" then
        if vRP.HasPermission and vRP.HasPermission(passport, "Admin") then return true end
        if vRP.HasGroup and vRP.HasGroup(passport, "Admin", 1) then return true end
        if vRP.hasPermission and vRP.hasPermission(passport, "Admin") then return true end
    end
    return false
end

function AdminControlPassport(source)
    return Passport(source)
end

function AdminControlCanUse(source, permission)
    return HasPermission(Passport(source), permission or Config.AdminPermission)
end

function AdminControlNotify(source, kind, message, time)
    if source and source > 0 then
        TriggerClientEvent("Notify", source, kind or "Atenção", message or "", time or 5000)
    end
end

function AdminControlLog(tag, message)
    if GetResourceState("discord") == "started" then
        pcall(function() exports.discord:Embed(tag or "AdminControl", message or "") end)
    end
end

function loadSeoulGroups()
    -- A base Seoul/Creative guarda Groups em vrp/config/Global.lua.
    pcall(function() module("vrp", "config/Global") end)
    local result = {}
    if type(Groups) == "table" then
        for name,data in pairs(Groups) do result[name] = data end
    end

    -- Grupos criados pelo AdminControl ficam em data/groups.json como overlay do painel.
    local controlGroups = GetControlFile("groups") or {}
    for name,data in pairs(controlGroups) do result[name] = data end
    return result
end

groups = loadSeoulGroups()
RegisterNetEvent("Seoul:reloadInfos",function() groups = loadSeoulGroups() end)

local function getHierarchyTitle(entry)
    if type(entry) == "table" then return entry.Title or entry.Group or entry.Name or "Cargo" end
    return tostring(entry or "Cargo")
end

function GetAllGroups()
    groups = loadSeoulGroups()
    local formattedGroups = {}
    for groupName,groupData in pairs(groups) do
        local hierarchy = type(groupData) == "table" and groupData.Hierarchy or nil
        if type(hierarchy) == "table" then
            for level,entry in ipairs(hierarchy) do
                formattedGroups[#formattedGroups + 1] = {
                    id = #formattedGroups + 1,
                    label = groupName.." - "..getHierarchyTitle(entry),
                    value = groupName.."-"..level,
                    groupName = groupName,
                    level = level
                }
            end
        else
            formattedGroups[#formattedGroups + 1] = {
                id = #formattedGroups + 1,
                label = groupName,
                value = groupName.."-1",
                groupName = groupName,
                level = 1
            }
        end
    end
    table.sort(formattedGroups,function(a,b) return tostring(a.label) < tostring(b.label) end)
    return formattedGroups
end
Server.getGroups = GetAllGroups

function Server.GetControlFile(file)
    return GetControlFile(file)
end

function Server.getLicenses()
    local options = {}
    local consult = query("AdminControl/get_all_characters") or {}
    for i=1,#consult do
        local row = consult[i]
        options[#options + 1] = {
            label = tostring(row.id).." - "..tostring(row.Name or "").." "..tostring(row.Lastname or ""),
            value = row.License,
        }
    end
    table.sort(options,function(a,b) return tostring(a.label) < tostring(b.label) end)
    return options
end

local function openMenu(source)
    if AdminControlCanUse(source, Config.AdminPermission) then
        ClientControl.openMainMenu(source)
    end
end

RegisterServerEvent("AdminControl:openMenu")
AddEventHandler("AdminControl:openMenu",function()
    openMenu(source)
end)

exports("openMenu",openMenu)
RegisterCommand("adm2", openMenu)
RegisterCommand("gerenciar", openMenu)
RegisterCommand("admincontrol", openMenu)


-----##########################################################-----
--###          SEOUL ADMINCONTROL RELOAD BRIDGE
-----##########################################################-----

function ReloadControlFiles(file)
    if file and file ~= "" then
        CacheFiles[tostring(file)] = nil
    else
        CacheFiles = {}
    end

    if loadSeoulGroups then
        groups = loadSeoulGroups()
    end

    return true
end
exports("ReloadControlFiles",ReloadControlFiles)

RegisterServerEvent("AdminControl:ReloadControlFiles")
AddEventHandler("AdminControl:ReloadControlFiles",function(file)
    local src = source or 0
    if src == 0 or AdminControlCanUse(src,Config.AdminPermission) then
        ReloadControlFiles(file)
    end
end)
