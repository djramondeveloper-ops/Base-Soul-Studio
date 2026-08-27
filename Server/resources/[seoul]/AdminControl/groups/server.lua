local function resolveAdminControlGroupLevel(groupName, value)
    local numeric = parseInt(value)
    if numeric and numeric > 0 then return numeric end

    local wanted = tostring(value or ""):lower():gsub("^%s+",""):gsub("%s+$","")
    if wanted == "" then return 1 end

    local all = GetControlFile("groups") or groups or {}
    local data = type(all) == "table" and all[groupName] or nil
    local hierarchy = type(data) == "table" and data.Hierarchy or nil

    if type(hierarchy) == "table" then
        for level,entry in ipairs(hierarchy) do
            local name
            if type(entry) == "table" then
                name = entry.Title or entry.Name or entry.Group or entry.group or entry.title
            else
                name = entry
            end

            if tostring(name or ""):lower():gsub("^%s+",""):gsub("%s+$","") == wanted then
                return level
            end
        end
    end

    return 1
end

local function eachGroupPayload(payload, callback)
    if type(payload) ~= "table" then return end

    for key,value in pairs(payload) do
        local groupName,level

        if type(value) == "table" then
            groupName = value.groupName or value.Group or value.group or value.Name or value.name or value.Permission or value.permission or key
            level = value.Level or value.level or value.Hierarchy or value.hierarchy or value.Cargo or value.cargo or 1
        else
            groupName = key
            level = value
        end

        groupName = tostring(groupName or ""):gsub("^%s+",""):gsub("%s+$","")
        if groupName ~= "" then
            callback(groupName,level)
        end
    end
end

local function ensureAdminControlRuntimeGroup(groupName)
    TriggerEvent("Seoul:AdminControl:EnsureGroup", groupName)

    -- Em caso de race entre salvar o JSON, limpar cache e setar a permissão,
    -- força também um reload geral de groups e tenta novamente antes do SetPermission.
    local runtime = vRP.Groups and vRP.Groups() or {}
    if not (runtime and runtime[groupName]) then
        TriggerEvent("Seoul:AdminControl:ReloadGroups")
        Wait(150)
        TriggerEvent("Seoul:AdminControl:EnsureGroup", groupName)
        Wait(50)
    else
        Wait(25)
    end
end

RegisterServerEvent("AdminControl:setUserGroups",function(nuser_id, addGroups, remGroups)
    local source = source
    local user_id = AdminControlPassport(source)
    if not AdminControlCanUse(source, Config.AdminPermission) then return end

    nuser_id = parseInt(nuser_id)
    if not nuser_id or nuser_id <= 0 then return AdminControlNotify(source,"Negado","Passaporte inválido.",5000) end

    eachGroupPayload(addGroups,function(AddGroup,Level)
        ensureAdminControlRuntimeGroup(AddGroup)

        Level = resolveAdminControlGroupLevel(AddGroup, Level)
        if vRP.SetPermission then
            vRP.SetPermission(nuser_id, AddGroup, Level)
        elseif vRP.addUserGroup then
            vRP.addUserGroup(nuser_id, AddGroup, Level)
        end

        local HasLevel = vRP.HasPermission and vRP.HasPermission(nuser_id, AddGroup) or false
        if HasLevel then
            AdminControlNotify(source,"Sucesso","O cidadão foi setado em "..AddGroup.." nível "..HasLevel..".",5000)
        else
            AdminControlNotify(source,"Aviso","O grupo "..AddGroup.." foi solicitado, mas ainda não apareceu na permissão do passaporte. Use /seoulcheckgroup para validar.",7000)
        end

        AdminControlLog("SetGroup",("**[ADMIN]:** %s\n**[SETOU]:** %s\n**[GRUPO]:** %s\n**[NÍVEL]:** %s\n**[VALIDADO]:** %s"):format(user_id,nuser_id,AddGroup,Level,tostring(HasLevel or false)))
    end)

    eachGroupPayload(remGroups,function(RemGroup)
        ensureAdminControlRuntimeGroup(RemGroup)

        if vRP.RemovePermission then
            vRP.RemovePermission(nuser_id, RemGroup)
        elseif vRP.removeUserGroup then
            vRP.removeUserGroup(nuser_id, RemGroup)
        end
        AdminControlNotify(source,"Aviso","O cidadão foi retirado de "..RemGroup..".",5000)
        AdminControlLog("UnsetGroup",("**[ADMIN]:** %s\n**[REMOVEU]:** %s\n**[GRUPO]:** %s"):format(user_id,nuser_id,RemGroup))
    end)
end)

local function reloadGroupsFromDisk()
    if ReloadControlFiles then ReloadControlFiles("groups") end
    groups = loadSeoulGroups and loadSeoulGroups() or groups or {}
    return groups
end

local function refreshGroupsState(target)
    local AllGroups = reloadGroupsFromDisk()
    GlobalState:set("AllGroups", AllGroups, true)
    if target and target > 0 then
        TriggerClientEvent("AdminControl:refreshGroupsList", target, AllGroups)
    end
    return AllGroups
end

local function reloadSeoulAdminControlBridge()
    -- Atualização em duas etapas: primeiro limpa cache local, depois força o vRP a reler groups.json do disco
    -- e sincronizar a tabela Groups viva, sem depender de RR.
    if ReloadControlFiles then ReloadControlFiles("groups") end

    TriggerEvent("Seoul:AdminControl:ReloadGroups")

    SetTimeout(250,function()
        TriggerEvent("Seoul:AdminControl:ReloadGroups")
        TriggerEvent("Seoul:AdminControl:ReloadConfig")
    end)
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then refreshGroupsState() end
end)

RegisterCommand(Config.Commands["groups"]['command'],function(source)
    if AdminControlCanUse(source,Config.Commands["groups"].perm) then
        refreshGroupsState(source)
        TriggerClientEvent("AdminControl:openGroups",source)
    end
end)

local function splitPerms(value)
    local result = {}
    if type(value) == "table" then
        for k,v in pairs(value) do
            if type(k) == "number" then
                if v and tostring(v) ~= "" then result[tostring(v)] = true end
            elseif v then
                result[tostring(k)] = true
            end
        end
        return result
    end

    if type(value) ~= "string" then return result end
    for perm in value:gmatch("[^,]+") do
        perm = perm:gsub("^%s+", ""):gsub("%s+$", "")
        if perm ~= "" then result[perm] = true end
    end
    return result
end

local function normalizeHierarchy(input)
    local hierarchy = {}
    if type(input) == "table" then
        for level, entry in ipairs(input) do
            if type(entry) == "table" then
                hierarchy[#hierarchy + 1] = entry.Title or entry.Group or entry.Name or ("Cargo "..tostring(level))
            elseif entry ~= nil then
                hierarchy[#hierarchy + 1] = tostring(entry)
            end
        end
    end

    -- Grupo sem nível não aparece na lista de setar grupos. Criar cargo padrão seguro.
    if #hierarchy == 0 then
        hierarchy[1] = "Membro"
    end

    return hierarchy
end

local function normalizeGroup(data)
    data = type(data) == "table" and data or {}
    local groupName = data.groupName or data.Group or data.name or data.Name
    local groupType = data.Type or data.type
    if groupType == "none" then groupType = nil end

    return {
        Name = data.Name or data.Title or groupName,
        Type = groupType,
        QBESXGroup = data.QBESXGroup,
        Markers = data.Markers or false,
        Service = data.Service == nil and true or (data.Service and true or false),
        OrgPanel = data.OrgPanel or nil,
        Permission = splitPerms(data.Permissions or data.Permission or data.perms),
        Hierarchy = normalizeHierarchy(data.Hierarchy),
        Salary = type(data.Salary) == "table" and data.Salary or nil
    }
end

local function saveGroupsAndApply(source, all, message)
    SaveAllFile("groups", all or {})

    -- Atualiza a lista do AdminControl imediatamente e depois novamente após o reload runtime,
    -- para evitar StateBag/cache atrasado quando o grupo é criado com a cidade online.
    refreshGroupsState(source)
    reloadSeoulAdminControlBridge()

    if source and source > 0 then
        AdminControlNotify(source,"Sucesso",message or "Grupos atualizados.",5000)
        SetTimeout(500,function()
            refreshGroupsState(source)
            TriggerClientEvent("AdminControl:refreshGroupsList", source, groups or {})
        end)
    end
end

RegisterServerEvent("AdminControl:createGroup")
AddEventHandler("AdminControl:createGroup",function(data)
    local source = source
    if not AdminControlCanUse(source,Config.Commands["groups"].perm) then return end
    if type(data) ~= "table" or not data.groupName or data.groupName == "" then return end

    local all = GetControlFile("groups") or {}
    if all[data.groupName] then return AdminControlNotify(source,"Negado","Esse grupo já existe no AdminControl.",5000) end

    all[data.groupName] = normalizeGroup(data)
    saveGroupsAndApply(source, all, "Grupo registrado e aplicado na ponte do AdminControl.")
end)

RegisterServerEvent("AdminControl:createGroupHierarchy")
AddEventHandler("AdminControl:createGroupHierarchy",function(data)
    local source = source
    if not AdminControlCanUse(source,Config.Commands["groups"].perm) then return end
    if type(data) ~= "table" or not data.groupName then return end

    local all = GetControlFile("groups") or {}
    if not all[data.groupName] then all[data.groupName] = normalizeGroup({ groupName = data.groupName, Name = data.groupName }) end

    all[data.groupName].Hierarchy = type(all[data.groupName].Hierarchy) == "table" and all[data.groupName].Hierarchy or {}
    local title = tostring(data.title or data.group or "Cargo")
    if #all[data.groupName].Hierarchy == 1 and all[data.groupName].Hierarchy[1] == "Membro" then
        all[data.groupName].Hierarchy[1] = title
    else
        table.insert(all[data.groupName].Hierarchy, title)
    end

    if data.salary and tonumber(data.salary) then
        all[data.groupName].Salary = all[data.groupName].Salary or {}
        all[data.groupName].Salary[#all[data.groupName].Hierarchy] = tonumber(data.salary)
    end

    saveGroupsAndApply(source, all, "Hierarquia registrada e aplicada.")
end)

RegisterServerEvent("AdminControl:deleteGroup")
AddEventHandler("AdminControl:deleteGroup",function(group)
    local source = source
    if not AdminControlCanUse(source,Config.Commands["groups"].perm) then return end
    local all = GetControlFile("groups") or {}
    if not all[group] then return AdminControlNotify(source,"Negado","Por segurança, esta fase só deleta grupos criados pelo AdminControl, não grupos nativos do Global.lua.",7000) end
    all[group] = nil
    saveGroupsAndApply(source, all, "Grupo deletado do overlay do AdminControl.")
end)

RegisterNetEvent("AdminControl:deleteGroupLevel")
AddEventHandler("AdminControl:deleteGroupLevel",function(group,level)
    local source = source
    if not AdminControlCanUse(source,Config.Commands["groups"].perm) then return end
    local all = GetControlFile("groups") or {}
    if not all[group] or not all[group].Hierarchy then return AdminControlNotify(source,"Negado","Esta fase só altera hierarquia de grupos criados pelo AdminControl.",7000) end
    table.remove(all[group].Hierarchy, parseInt(level))
    all[group].Hierarchy = normalizeHierarchy(all[group].Hierarchy)
    saveGroupsAndApply(source, all, "Hierarquia removida.")
end)

RegisterServerEvent("AdminControl:editGroup")
AddEventHandler("AdminControl:editGroup",function(data)
    local source = source
    if not AdminControlCanUse(source,Config.Commands["groups"].perm) then return end
    if type(data) ~= "table" or not data.groupName then return end
    local all = GetControlFile("groups") or {}
    if not all[data.groupName] then return AdminControlNotify(source,"Negado","Por segurança, esta fase só edita grupos criados pelo AdminControl, não grupos nativos da base.",7000) end
    local oldHierarchy = all[data.groupName].Hierarchy or {}
    local oldSalary = all[data.groupName].Salary
    all[data.groupName] = normalizeGroup(data)
    all[data.groupName].Hierarchy = normalizeHierarchy(oldHierarchy)
    all[data.groupName].Salary = oldSalary
    saveGroupsAndApply(source, all, "Grupo editado e reaplicado.")
end)

RegisterServerEvent("AdminControl:editGroupHierarchy")
AddEventHandler("AdminControl:editGroupHierarchy",function(data)
    local source = source
    if not AdminControlCanUse(source,Config.Commands["groups"].perm) then return end
    if type(data) ~= "table" or not data.groupName then return end
    local all = GetControlFile("groups") or {}
    if not all[data.groupName] or not all[data.groupName].Hierarchy then return AdminControlNotify(source,"Negado","Esta fase só edita hierarquia de grupos criados pelo AdminControl.",7000) end
    local level = parseInt(data.level)
    if level <= 0 then return end
    all[data.groupName].Hierarchy[level] = tostring(data.title or data.group or "Cargo")
    if data.salary and tonumber(data.salary) then
        all[data.groupName].Salary = all[data.groupName].Salary or {}
        all[data.groupName].Salary[level] = tonumber(data.salary)
    end
    saveGroupsAndApply(source, all, "Hierarquia editada e reaplicada.")
end)

-- Interface Tunnel para o client sempre buscar lista fresca, sem depender de StateBag atrasado.
function Server.getAdminControlGroups()
    return refreshGroupsState()
end

RegisterCommand("seoulacgroupsfresh",function(source)
    if source ~= 0 and not AdminControlCanUse(source,Config.Commands["groups"].perm) then return end
    local all = refreshGroupsState(source)
    reloadSeoulAdminControlBridge()
    if source and source > 0 then
        AdminControlNotify(source,"AdminControl","Lista de grupos atualizada: "..tostring(CountTable and CountTable(all) or 0),5000)
    else
        print("[AdminControl] Lista de grupos atualizada em runtime.")
    end
end)
