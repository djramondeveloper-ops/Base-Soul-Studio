-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL SEED IMPORTER - ADMINCONTROL SIDE
-- Importa item packs da Seoul Farms e Seoul Scripts dentro do próprio AdminControl.
-----------------------------------------------------------------------------------------------------------------------------------------
if _G.SeoulSeedImporterLoaded then return end
_G.SeoulSeedImporterLoaded = true

local ADMIN_RESOURCE = GetCurrentResourceName()
local ADMIN_ITEMS_FILE = "items"

local SOURCES = {
    farms = {
        label = "Seoul Farms",
        resource = "seoul_farms",
        path = "data/items.json"
    },
    scripts = {
        label = "Seoul Scripts",
        resource = "seoul_scripts",
        path = "data/items.json"
    }
}

local function trim(value)
    return tostring(value or ""):match("^%s*(.-)%s*$") or ""
end

local function lower(value)
    return string.lower(tostring(value or ""))
end

local function notify(source,kind,message,time)
    if source and source > 0 then
        if AdminControlNotify then
            AdminControlNotify(source,kind or "Aviso",message or "",time or 8000)
        else
            TriggerClientEvent("Notify",source,kind or "Aviso",message or "",time or 8000)
        end
    else
        print(("[Seoul Seed Importer] %s"):format(message or ""))
    end
end

local function allowed(source)
    if not source or source == 0 then return true end
    if AdminControlCanUse and Config and Config.Commands and Config.Commands["items"] then
        return AdminControlCanUse(source,Config.Commands["items"].perm)
    end
    return false
end

local function decodeJson(raw)
    if not raw or raw == "" then return {} end
    local ok,data = pcall(json.decode,raw)
    if ok and type(data) == "table" then return data end
    return {}
end

local function isArray(tbl)
    if type(tbl) ~= "table" then return false end
    local count = 0
    for key in pairs(tbl) do
        if type(key) ~= "number" then return false end
        count = count + 1
    end
    if count == 0 then return true end
    for i=1,count do
        if tbl[i] == nil then return false end
    end
    return true
end

local function safeCode(value)
    value = trim(value)
    if value == "" then return nil end
    if value:find("%s") then return nil end
    if value:find("[%\'\"{}%[%],]") then return nil end
    return value
end

local function normalizeSeedEntry(key,value,sourceName)
    if type(value) ~= "table" then return nil end
    local code = safeCode(value.item or value.Item or value.code or value.Code or key)
    if not code then return nil end

    local name = trim(value.name or value.Name or value.label or value.Label or code)
    if name == "" then name = code end

    local image = trim(value.image or value.Image or value.imageFile or value.image_file or (code..".png"))
    if image == "" then image = code..".png" end
    if not image:find("%.") then image = image..".png" end

    local item = {}
    for k,v in pairs(value) do item[k] = v end
    item.item = code
    item.Item = nil
    item.code = nil
    item.Code = nil
    item.name = name
    item.label = trim(item.label or item.Label or name)
    item.Label = nil
    item.type = trim(item.type or item.Type or "Comum")
    item.Type = nil
    item.weight = tonumber(item.weight or item.Weight or item.peso or item.Peso) or 0
    item.Weight = nil
    item.peso = nil
    item.Peso = nil
    item.image = image
    item.Image = nil
    item.stack = item.stack ~= false
    item.close = item.close ~= false
    item._seoulSeed = sourceName
    return item
end

local function loadSeed(sourceKey)
    local sourceInfo = SOURCES[sourceKey]
    if not sourceInfo then return {}, { "Fonte inválida: "..tostring(sourceKey) } end

    local state = GetResourceState(sourceInfo.resource)
    if state == "missing" or state == "unknown" then
        return {}, { sourceInfo.label.." não encontrado: "..sourceInfo.resource }
    end

    local raw = LoadResourceFile(sourceInfo.resource,sourceInfo.path)
    if not raw or raw == "" then
        return {}, { sourceInfo.label.." sem arquivo "..sourceInfo.path }
    end

    local decoded = decodeJson(raw)
    local list = {}
    for key,value in pairs(decoded) do
        local item = normalizeSeedEntry(key,value,sourceKey)
        if item then list[#list + 1] = item end
    end
    table.sort(list,function(a,b) return tostring(a.item) < tostring(b.item) end)
    return list, {}
end

local function adminItemsToMap(data)
    local map = {}
    if type(data) ~= "table" then return map end

    if isArray(data) then
        for _,value in ipairs(data) do
            if type(value) == "table" then
                local code = safeCode(value.item or value.Item or value.code or value.Code)
                if code then
                    value.item = code
                    value.Item = nil
                    map[code] = value
                end
            end
        end
    else
        for key,value in pairs(data) do
            if type(value) == "table" then
                local code = safeCode(value.item or value.Item or value.code or value.Code or key)
                if code then
                    value.item = code
                    value.Item = nil
                    map[code] = value
                end
            end
        end
    end

    return map
end

local function sortedMap(map)
    local keys = {}
    for key in pairs(map or {}) do keys[#keys + 1] = key end
    table.sort(keys,function(a,b) return tostring(a) < tostring(b) end)
    local result = {}
    for _,key in ipairs(keys) do result[key] = map[key] end
    return result, keys
end

local function hasCommand(command)
    -- FiveM não expõe lista simples aqui; executamos mesmo. Comandos inexistentes apenas não fazem nada.
    return true
end

local function runGenerators(source)
    ExecuteCommand("seoulgenerateitems")
    ExecuteCommand("seoulgenerateweapons")
    ExecuteCommand("seoulsyncitems")
    ExecuteCommand("seoulsyncweapons")
    notify(source,"Informação","Geradores executados. Reinicie ox_inventory para carregar os itens.",9000)
end

local function importSeeds(source,which,force)
    if not allowed(source) then
        return notify(source,"Negado","Sem permissão para importar itens.",6000)
    end

    local sourceKeys = {}
    if which == "farms" then
        sourceKeys = { "farms" }
    elseif which == "scripts" then
        sourceKeys = { "scripts" }
    else
        sourceKeys = { "farms", "scripts" }
    end

    local adminItems = GetControlFile and GetControlFile(ADMIN_ITEMS_FILE) or decodeJson(LoadResourceFile(ADMIN_RESOURCE,"data/items.json"))
    local map = adminItemsToMap(adminItems)
    local added, updated, skipped, totalSeeds = 0, 0, 0, 0
    local errors = {}
    local importedNames = {}

    for _,sourceKey in ipairs(sourceKeys) do
        local list, sourceErrors = loadSeed(sourceKey)
        for _,err in ipairs(sourceErrors or {}) do errors[#errors + 1] = err end
        totalSeeds = totalSeeds + #list

        for _,item in ipairs(list) do
            if map[item.item] then
                if force then
                    map[item.item] = item
                    updated = updated + 1
                    importedNames[#importedNames + 1] = item.item
                else
                    skipped = skipped + 1
                end
            else
                map[item.item] = item
                added = added + 1
                importedNames[#importedNames + 1] = item.item
            end
        end
    end

    local sorted = sortedMap(map)
    if SaveAllFile then
        SaveAllFile(ADMIN_ITEMS_FILE,sorted)
    else
        SaveResourceFile(ADMIN_RESOURCE,"data/items.json",json.encode(sorted,{ indent = true }),-1)
    end

    -- Confirma que gravou no próprio AdminControl.
    local check = adminItemsToMap(decodeJson(LoadResourceFile(ADMIN_RESOURCE,"data/items.json")))
    local present = 0
    for _,name in ipairs(importedNames) do
        if check[name] then present = present + 1 end
    end

    if GlobalState then
        if GlobalState.set then GlobalState:set("AdminControlItems",sorted,true) else GlobalState["AdminControlItems"] = sorted end
    end

    local msg = ("Seeds: %s | adicionados: %s | atualizados: %s | pulados: %s | confirmados: %s/%s"):format(totalSeeds,added,updated,skipped,present,#importedNames)
    if #errors > 0 then
        msg = msg.." | avisos: "..#errors
        print("[Seoul Seed Importer] Avisos: "..table.concat(errors," | "))
    end
    notify(source,"Sucesso",msg,12000)
    print("[Seoul Seed Importer] "..msg)

    runGenerators(source)
end

local function statusSeeds(source,which)
    if not allowed(source) then return notify(source,"Negado","Sem permissão.",6000) end
    local adminMap = adminItemsToMap(GetControlFile and GetControlFile(ADMIN_ITEMS_FILE) or decodeJson(LoadResourceFile(ADMIN_RESOURCE,"data/items.json")))
    local sourceKeys = which == "farms" and { "farms" } or which == "scripts" and { "scripts" } or { "farms", "scripts" }
    local total, present = 0, 0
    local missing = {}
    for _,sourceKey in ipairs(sourceKeys) do
        local list = loadSeed(sourceKey)
        for _,item in ipairs(list) do
            total = total + 1
            if adminMap[item.item] then present = present + 1 else missing[#missing + 1] = item.item end
        end
    end
    notify(source,"Informação",("Seeds no AdminControl: %s/%s"):format(present,total),9000)
    if #missing > 0 then
        print("[Seoul Seed Importer] Faltando: "..table.concat(missing,", "))
        if source and source > 0 then notify(source,"Aviso","Faltando: "..table.concat(missing,", "),12000) end
    end
end

RegisterCommand("seoulseeditems",function(source,args)
    importSeeds(source,"all",args and lower(args[1]) == "force")
end,false)

RegisterCommand("seoulseeditemsstatus",function(source,args)
    statusSeeds(source,"all")
end,false)

RegisterCommand("seoulfarmsitems",function(source,args)
    importSeeds(source,"farms",args and lower(args[1]) == "force")
end,false)

RegisterCommand("seoulfarmsitemsstatus",function(source,args)
    statusSeeds(source,"farms")
end,false)

RegisterCommand("seoulscriptsitems",function(source,args)
    importSeeds(source,"scripts",args and lower(args[1]) == "force")
end,false)

RegisterCommand("seoulscriptsitemsstatus",function(source,args)
    statusSeeds(source,"scripts")
end,false)

AddEventHandler("AdminControl:SeoulSeedImporter:Import",function(which,force,requestSource)
    importSeeds(tonumber(requestSource) or 0,which or "all",force == true)
end)

AddEventHandler("AdminControl:SeoulSeedImporter:Status",function(which,requestSource)
    statusSeeds(tonumber(requestSource) or 0,which or "all")
end)

print("[Seoul Seed Importer] Importador central carregado no AdminControl.")
