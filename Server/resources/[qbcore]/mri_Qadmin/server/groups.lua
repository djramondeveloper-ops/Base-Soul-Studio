-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL GROUPS
-- A aba de grupos usa permissions/entitydata reais da Seoul.
-- Grupos ilegais/organizações são reconhecidos automaticamente pelo AdminControl/data/groups.json
-- e enviados para a coluna GANGUES do MRI; empregos/staff ficam em EMPREGOS.
-----------------------------------------------------------------------------------------------------------------------------------------
local QBCore = SeoulQAdminGetCoreObject()

local IllegalGroups = {}
local IllegalLabels = {}
local IllegalHierarchy = {}

local function loadAdminControlGroups()
    IllegalGroups = {}
    IllegalLabels = {}
    IllegalHierarchy = {}

    local raw = LoadResourceFile('AdminControl', 'data/groups.json')
    if not raw or raw == '' then
        raw = LoadResourceFile(GetCurrentResourceName(), 'data/seoul_groups.json')
    end
    if not raw or raw == '' then return end

    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then return end

    for orgId, info in pairs(data) do
        local orgName = tostring(info.Name or orgId)
        IllegalGroups[orgName] = true
        IllegalGroups[tostring(orgId)] = true
        IllegalLabels[orgName] = orgName
        IllegalLabels[tostring(orgId)] = orgName
        IllegalHierarchy[orgName] = info.Hierarchy or {}
        IllegalHierarchy[tostring(orgId)] = info.Hierarchy or {}

        for _, node in ipairs(info.Hierarchy or {}) do
            local group = node.Group and tostring(node.Group)
            if group and group ~= '' then
                IllegalGroups[group] = true
                IllegalLabels[group] = node.Title or orgName
                IllegalHierarchy[group] = info.Hierarchy or {}
            end
            for _, perm in ipairs(node.Permission or {}) do
                local pname = tostring(perm or ''):gsub('%.permissao$', '')
                if pname ~= '' then IllegalGroups[pname] = true end
            end
        end

        for _, perm in ipairs(info.Permissions or {}) do
            local pname = tostring(perm or ''):gsub('%.permissao$', '')
            if pname ~= '' then IllegalGroups[pname] = true; IllegalLabels[pname] = orgName end
        end
    end
end

local illegalKeywords = {
    ballas=true, families=true, vagos=true, bloods=true, azuis=true, vermelhos=true, verdes=true,
    mafia=true, milicia=true, motoclub=true, vanilla=true, bahamas=true, cassino=true, cartel=true,
    gang=true, gangue=true, faccao=true, ["facção"]=true, ilegal=true, lester=true, bronze=true
}

local function isIllegalGroup(name)
    name = tostring(name or '')
    if IllegalGroups[name] then return true end
    local lower = name:lower()
    lower = lower:gsub('lider$', ''):gsub('leader$', '')
    if IllegalGroups[lower] then return true end
    for key in pairs(illegalKeywords) do
        if lower:find(key, 1, true) then return true end
    end
    return false
end

local function makeGrades(name, maxLevel)
    maxLevel = math.max(1, tonumber(maxLevel) or 1)
    local hierarchy = IllegalHierarchy[name]
    local grades = {}
    if type(hierarchy) == 'table' and #hierarchy > 0 then
        for i, node in ipairs(hierarchy) do
            local level = i
            grades[tostring(level)] = { name = tostring(level), level = level, label = node.Title or node.Group or tostring(level) }
        end
        return grades
    end
    for i = 1, maxLevel do
        grades[tostring(i)] = { name = tostring(i), level = i }
    end
    return grades
end

local function makeGroup(name, groupType)
    local maxLevel = SeoulQAdminDB.GetPermissionMaxLevel(name)
    return {
        name = name,
        label = IllegalLabels[name] or name,
        type = groupType or 'job',
        grades = makeGrades(name, maxLevel),
        members = {}
    }
end

local function addMember(group, member)
    if not group or not member then return end
    group.members = group.members or {}
    group.members[#group.members + 1] = member
end

local function ensureGroup(jobs, gangs, groupName)
    local illegal = isIllegalGroup(groupName)
    local bucket = illegal and gangs or jobs
    if not bucket[groupName] then bucket[groupName] = makeGroup(groupName, illegal and 'gang' or 'job') end
    return bucket[groupName], illegal
end

local function getOnlinePlayersByPermission(jobs, gangs)
    local onlineByGroup = {}
    local onlinePlayers = QBCore.Functions.GetQBPlayers() or {}

    for _, player in pairs(onlinePlayers) do
        local data = player.PlayerData or {}
        local cid = tostring(data.citizenid or '')
        if cid ~= '' then
            local groups = data.groups or {}
            for groupName, level in pairs(groups) do
                groupName = tostring(groupName)
                local group = ensureGroup(jobs, gangs, groupName)
                onlineByGroup[groupName] = onlineByGroup[groupName] or {}
                onlineByGroup[groupName][cid] = true
                addMember(group, {
                    id = data.source,
                    name = ((data.charinfo and data.charinfo.firstname) or 'N/A') .. ' ' .. ((data.charinfo and data.charinfo.lastname) or ''),
                    cid = cid,
                    job = groupName,
                    grade = { name = tostring(level or 1), level = tonumber(level) or 1 },
                    online = true
                })
            end
        end
    end

    return onlineByGroup
end

local function appendOfflineMembers(jobs, gangs, onlineByGroup)
    local allNames = SeoulQAdminDB.GetAllPermissionNames()
    for _, groupName in ipairs(allNames) do
        local group = ensureGroup(jobs, gangs, groupName)
        local members = SeoulQAdminDB.GetPermissionMembers(groupName)
        for _, member in ipairs(members) do
            local cid = tostring(member.cid or member.id or '')
            if not (onlineByGroup[groupName] and onlineByGroup[groupName][cid]) then
                member.job = groupName
                addMember(group, member)
            end
        end
    end
end

local function toSortedList(map)
    local list = {}
    for _, group in pairs(map) do
        table.sort(group.members, function(a, b)
            if a.online == b.online then return (a.name or '') < (b.name or '') end
            return a.online and not b.online
        end)
        list[#list + 1] = group
    end
    table.sort(list, function(a, b) return (a.label or '') < (b.label or '') end)
    return list
end

local function getGroups()
    loadAdminControlGroups()

    local jobs, gangs = {}, {}
    for _, name in ipairs(SeoulQAdminDB.GetAllPermissionNames()) do
        ensureGroup(jobs, gangs, name)
    end

    local onlineByGroup = getOnlinePlayersByPermission(jobs, gangs)
    appendOfflineMembers(jobs, gangs, onlineByGroup)

    return { jobs = toSortedList(jobs), gangs = toSortedList(gangs) }
end

_G.GetGroupsData = getGroups

lib.callback.register('mri_Qadmin:callback:GetGroupsData', function(src)
    if not CheckPerms(src, 'qadmin.page.groups') then return { jobs = {}, gangs = {} } end
    return getGroups()
end)

lib.callback.register('mri_Qadmin:callback:GetGroupMembers', function(source, groupName, groupType)
    if not CheckPerms(source, 'qadmin.page.groups') then return {} end
    local data = getGroups()
    local list = groupType == 'gang' and data.gangs or data.jobs
    for _, group in ipairs(list or {}) do
        if group.name == groupName then return group.members or {} end
    end
    return {}
end)
