-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL MULTIFRAMEWORK V2 - QBCORE SERVER
-- Expande o adapter existente sem editar compat/server/qbcore.lua.
-- Fonte de verdade: vRP/Creative + OX configurados na Seoul.
-----------------------------------------------------------------------------------------------------------------------------------------
if not SeoulMultiframework or not SeoulMultiframework.QBCore or SeoulMultiframework.QBCore.Enabled == false then
    return
end

QBCore = QBCore or {}
QBCore.Functions = QBCore.Functions or {}
QBCore.Player = QBCore.Player or {}
QBCore.Players = QBCore.Players or {}
QBCore.PlayersByCitizenId = QBCore.PlayersByCitizenId or {}
QBCore.Player_Buckets = QBCore.Player_Buckets or {}
QBCore.Entity_Buckets = QBCore.Entity_Buckets or {}
QBCore.ClientCallbacks = QBCore.ClientCallbacks or {}
QBCore.ServerCallbacks = QBCore.ServerCallbacks or {}
QBCore.UsableItems = QBCore.UsableItems or {}

local Config = SeoulMultiframework.QBCore
local OriginalLogin = QBCore.Player.Login
local OriginalLogout = QBCore.Player.Logout
local OriginalCanUseItem = QBCore.Functions.CanUseItem
local OriginalUseItem = QBCore.Functions.UseItem
local PlayerExtras = {}

local function normalizeItem(item)
    if Seoul and Seoul.NormalizeItem then
        return Seoul.NormalizeItem(item)
    end
    return item
end

local function normalizeMoneyType(moneyType)
    moneyType = tostring(moneyType or "cash"):lower()
    if moneyType == "money" then return "cash" end
    return moneyType
end

local function passportFromSource(source)
    source = tonumber(source)
    return source and vRP.Passport(source) or false
end

local function sourceFromPassport(passport)
    return vRP.Source(tonumber(passport)) or false
end

local function copyTable(source)
    local target = {}
    if type(source) == "table" then
        for key, value in pairs(source) do
            if type(value) == "table" then
                target[key] = copyTable(value)
            else
                target[key] = value
            end
        end
    end
    return target
end

local function isCallable(value)
    if type(value) == "function" then return true end
    if type(value) == "table" and rawget(value, "__cfx_functionReference") then return true end
    local mt = getmetatable(value)
    return mt and type(mt.__call) == "function" or false
end

local NotifyTypes = {
    success = "verde",
    error = "vermelho",
    warning = "amarelo",
    primary = "default",
    info = "default",
    police = "policia"
}

local function qbNotifyPayload(text, notifyType)
    local title = "Aviso"
    local message = text
    if type(text) == "table" then
        title = tostring(text.caption or text.title or title)
        message = text.text or text.message or ""
    end
    return title, tostring(message or ""), NotifyTypes[tostring(notifyType or "primary"):lower()] or tostring(notifyType or "default")
end

local function currentGroups(passport)
    return vRP.UserGroups(passport) or {}
end

local function configuredGroup(passport, list)
    local groups = currentGroups(passport)
    local firstMatch

    for _, name in ipairs(list or {}) do
        if groups[name] then
            firstMatch = firstMatch or name
            if vRP.HasService(passport, name) then
                return name, tonumber(groups[name]) or 1
            end
        end
    end

    if firstMatch then
        return firstMatch, tonumber(groups[firstMatch]) or 1
    end

    return nil, 0
end

local function seoulLevelToQB(name, seoulLevel, gang)
    if not Config.UseQBCoreGradeOrder then
        return tonumber(seoulLevel) or 0
    end

    local shared = gang and QBCore.Shared.Gangs or QBCore.Shared.Jobs
    local entry = shared and shared[name]
    local maxGrade = -1

    if entry and type(entry.grades) == "table" then
        for grade in pairs(entry.grades) do
            local number = tonumber(grade)
            if number and number > maxGrade then maxGrade = number end
        end
    end

    if maxGrade < 0 then return math.max((tonumber(seoulLevel) or 1) - 1, 0) end
    return math.max(maxGrade - ((tonumber(seoulLevel) or 1) - 1), 0)
end

local function qbGradeToSeoul(name, qbGrade, gang)
    local shared = gang and QBCore.Shared.Gangs or QBCore.Shared.Jobs
    local entry = shared and shared[name]
    local gradeKey = tostring(tonumber(qbGrade) or 0)
    local gradeData = entry and entry.grades and entry.grades[gradeKey]

    if gradeData and tonumber(gradeData.seoulLevel) then
        return tonumber(gradeData.seoulLevel)
    end

    if not Config.UseQBCoreGradeOrder then
        return math.max(tonumber(qbGrade) or 1, 1)
    end

    return false
end

local function buildRole(passport, gang)
    local list = gang and Config.Gangs or Config.Jobs
    local name, seoulLevel = configuredGroup(passport, list)

    if not name then
        if gang then
            return {
                name = "none",
                label = "No Gang",
                isboss = false,
                grade = { name = "none", level = 0, payment = 0, seoulLevel = 0 }
            }
        end

        return {
            name = "unemployed",
            label = "Civilian",
            type = "none",
            onduty = false,
            isboss = false,
            payment = 0,
            grade = { name = "Freelancer", level = 0, payment = 0, seoulLevel = 0 }
        }
    end

    local shared = gang and QBCore.Shared.Gangs or QBCore.Shared.Jobs
    local sharedEntry = shared and shared[name] or nil
    local qbLevel = seoulLevelToQB(name, seoulLevel, gang)
    local gradeData = sharedEntry and sharedEntry.grades and sharedEntry.grades[tostring(qbLevel)] or nil
    local role = {
        name = name,
        label = sharedEntry and sharedEntry.label or name,
        isboss = seoulLevel == 1,
        grade = {
            name = gradeData and gradeData.name or vRP.NameHierarchy(name, seoulLevel),
            level = qbLevel,
            payment = tonumber(gradeData and gradeData.payment or 0) or 0,
            seoulLevel = seoulLevel
        }
    }

    if not gang then
        role.type = "job"
        role.onduty = vRP.HasService(passport, name) and true or false
        role.payment = role.grade.payment
    end

    return role
end

local MetadataMap = {
    hunger = "Hunger",
    thirst = "Thirst",
    stress = "Stress",
    armour = "Armour",
    armor = "Armour"
}

local function buildMetadata(passport)
    local datatable = copyTable(vRP.Datatable(passport) or {})

    for qbKey, seoulKey in pairs(MetadataMap) do
        if datatable[qbKey] == nil and datatable[seoulKey] ~= nil then
            datatable[qbKey] = datatable[seoulKey]
        end
    end

    return datatable
end

local function buildItems(passport)
    local result = {}
    local inventory = vRP.Inventory(passport) or {}

    for slot, data in pairs(inventory) do
        if data and data.item then
            local itemName = normalizeItem(data.item)
            local shared = QBCore.Shared.Items and QBCore.Shared.Items[itemName] or nil
            local slotNumber = tonumber(slot) or tonumber(data.slot) or slot
            local amount = tonumber(data.amount or data.count or 0) or 0

            result[slotNumber] = {
                name = itemName,
                amount = amount,
                count = amount,
                label = shared and shared.label or itemName,
                weight = shared and shared.weight or 0,
                type = shared and shared.type or "item",
                unique = shared and shared.unique or false,
                useable = shared and shared.useable or false,
                image = shared and shared.image or (itemName .. ".png"),
                shouldClose = shared == nil or shared.shouldClose ~= false,
                slot = slotNumber,
                info = data.metadata or data.info or {},
                metadata = data.metadata or data.info or {}
            }
        end
    end

    return result
end

local function buildPlayerData(source, passport, offline)
    passport = tonumber(passport)
    local identity = passport and vRP.Identity(passport) or nil
    if not identity then return nil end

    local data = {
        source = offline and nil or tonumber(source),
        citizenid = tostring(passport),
        cid = passport,
        license = identity.License or vRP.License(passport) or "",
        name = ((identity.Name or identity.name or "") .. " " .. (identity.Lastname or identity.name2 or "")):gsub("^%s+", ""):gsub("%s+$", ""),
        charinfo = {
            firstname = identity.Name or identity.name or "",
            lastname = identity.Lastname or identity.name2 or "",
            birthdate = identity.Birthdate or identity.Birth or "",
            gender = identity.Sex == "F" and 1 or (identity.Sex == "M" and 0 or nil),
            nationality = identity.Nationality or "",
            phone = vRP.Phone(passport),
            account = tostring(passport)
        },
        money = {
            cash = vRP.getMoney(passport),
            bank = vRP.GetBank(passport),
            crypto = 0
        },
        job = buildRole(passport, false),
        gang = buildRole(passport, true),
        metadata = buildMetadata(passport),
        items = offline and {} or buildItems(passport),
        position = nil
    }

    local extras = PlayerExtras[passport]
    if extras then
        for key, value in pairs(extras) do
            if data[key] == nil then data[key] = value end
        end
    end

    if not offline and source then
        local ped = GetPlayerPed(source)
        if ped and ped ~= 0 and DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)
            data.position = vector4(coords.x, coords.y, coords.z, GetEntityHeading(ped))
        end
    end

    if not data.position then
        local datatable = vRP.Datatable(passport) or {}
        data.position = datatable.Pos or vector4(0.0, 0.0, 0.0, 0.0)
    end

    if Config.ExposeSeoulFields then
        data.seoul = {
            passport = passport,
            groups = currentGroups(passport),
            datatable = vRP.Datatable(passport) or {}
        }
    end

    return data
end

local function pushPlayerData(player)
    if not player or player.Offline then return end
    local source = player.PlayerData and player.PlayerData.source
    if source then
        TriggerClientEvent("QBCore:Player:SetPlayerData", source, player.PlayerData)
        TriggerClientEvent("QBCore:Player:UpdatePlayerData", source, player.PlayerData)
    end
end

local function refreshPlayer(player, push)
    if not player or not player.PlayerData then return false end
    local passport = tonumber(player.PlayerData.citizenid or player.PlayerData.cid)
    if not passport then return false end
    local source = player.Offline and nil or player.PlayerData.source or sourceFromPassport(passport)
    local refreshed = buildPlayerData(source, passport, player.Offline)
    if not refreshed then return false end

    player.PlayerData = refreshed
    if push then pushPlayerData(player) end
    return player.PlayerData
end

local function refreshPassport(passport)
    passport = tonumber(passport)
    if not passport then return false end

    local player = QBCore.PlayersByCitizenId[tostring(passport)]
    if not player then
        local source = sourceFromPassport(passport)
        player = source and QBCore.Players[tonumber(source)] or nil
    end

    if not player then return false end

    if player.Functions and player.Functions.UpdatePlayerData then
        return player.Functions.UpdatePlayerData()
    end

    return refreshPlayer(player,true)
end

AddEventHandler("Seoul:PermissionsChanged",function(passport)
    refreshPassport(passport)
end)

local function saveDatatable(passport, source)
    passport = tonumber(passport)
    if not passport then return false end

    local datatable = vRP.Datatable(passport)
    if not datatable then return false end

    if source then
        local ped = GetPlayerPed(source)
        if ped and ped ~= 0 and DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)
            datatable.Pos = { x = coords.x, y = coords.y, z = coords.z }
            datatable.Armour = GetPedArmour(ped)
            datatable.Health = GetEntityHealth(ped)
        end
    end

    vRP.Query("playerdata/SetData", {
        Passport = passport,
        Name = "Datatable",
        Information = json.encode(datatable)
    })
    return true
end

local function giveItemVerified(passport, item, amount, notify, slot, metadata)
    item = normalizeItem(item)
    amount = tonumber(amount) or 0
    if amount <= 0 then return false end

    local before = vRP.ItemAmount(passport, item)
    local result = vRP.GenerateItem(passport, item, amount, notify, slot, metadata)
    local after = vRP.ItemAmount(passport, item)
    return result == true or after >= (before + amount)
end

local function getPlayerItem(player, itemName, all)
    if not player or not player.PlayerData then return all and {} or nil end
    itemName = normalizeItem(itemName)
    local items = buildItems(tonumber(player.PlayerData.citizenid))
    local matches = {}

    for _, item in pairs(items) do
        if item.name == itemName then
            if not all then return item end
            matches[#matches + 1] = item
        end
    end

    return all and matches or nil
end

local function enhancePlayer(player, passport, offline)
    if not player then return nil end
    passport = tonumber(passport or (player.PlayerData and (player.PlayerData.citizenid or player.PlayerData.cid)))
    if not passport then return player end

    player.Offline = offline == true
    player.Functions = player.Functions or {}
    player.PlayerData = buildPlayerData(player.Offline and nil or sourceFromPassport(passport), passport, player.Offline) or player.PlayerData

    function player.Functions.GetPlayerData()
        return player.PlayerData
    end

    function player.Functions.UpdatePlayerData()
        return refreshPlayer(player, true)
    end

    function player.Functions.UpdateClient()
        return player.Functions.UpdatePlayerData()
    end

    function player.Functions.SetPlayerData(key, value)
        if key == "metadata" and type(value) == "table" then
            for metaKey, metaValue in pairs(value) do
                player.Functions.SetMetaData(metaKey, metaValue)
            end
            return true
        end

        PlayerExtras[passport] = PlayerExtras[passport] or {}
        PlayerExtras[passport][key] = value
        player.PlayerData[key] = value
        pushPlayerData(player)
        return true
    end

    function player.Functions.SetMetaData(key, value)
        local datatableKey = MetadataMap[key] or key
        vRP.UpdateDatatable(passport, datatableKey, value)
        refreshPlayer(player, true)
        return true
    end

    function player.Functions.GetMetaData(key)
        refreshPlayer(player, false)
        return player.PlayerData.metadata and player.PlayerData.metadata[key]
    end

    function player.Functions.GetName()
        local identity = vRP.Identity(passport)
        return identity and ((identity.Name or "") .. " " .. (identity.Lastname or "")):gsub("^%s+", ""):gsub("%s+$", "") or player.PlayerData.name
    end

    function player.Functions.GetItemByName(item)
        return getPlayerItem(player, item, false)
    end

    function player.Functions.GetItemsByName(item)
        return getPlayerItem(player, item, true)
    end

    function player.Functions.AddItem(item, amount, slot, info, reason)
        if player.Offline then return false end
        item = normalizeItem(item)
        amount = tonumber(amount) or 1
        if amount <= 0 then return false end

        local ok = giveItemVerified(passport, item, amount, true, slot, info)
        if ok then refreshPlayer(player, true) end
        return ok
    end

    function player.Functions.RemoveItem(item, amount, slot, reason)
        if player.Offline then return false end
        item = normalizeItem(item)
        local ok = vRP.TakeItem(passport, item, tonumber(amount) or 1, true, slot)
        if ok then refreshPlayer(player, true) end
        return ok and true or false
    end

    function player.Functions.ClearInventory()
        if player.Offline then return false end
        local ok = vRP.ClearInventory(passport)
        if ok ~= false then refreshPlayer(player, true) end
        return ok ~= false
    end

    -- Substituir um inventario inteiro e uma operacao destrutiva. A Seoul nao possui uma primitiva atomica equivalente.
    -- Retorna false em vez de fingir sucesso ou arriscar perda parcial de itens.
    function player.Functions.SetInventory(items)
        return false, "unsupported_atomic_inventory_replace"
    end

    function player.Functions.AddMoney(moneyType, amount, reason)
        moneyType = normalizeMoneyType(moneyType)
        amount = tonumber(amount) or 0
        if amount <= 0 then return false end

        local ok
        if moneyType == "bank" then
            ok = vRP.GiveBank(passport, amount, true)
            ok = ok ~= false
        elseif moneyType == "cash" then
            if player.Offline then return false end
            ok = giveItemVerified(passport, SeoulCashItem or "dollar", amount, true)
        else
            return false
        end

        if ok then refreshPlayer(player, true) end
        return ok and true or false
    end

    function player.Functions.RemoveMoney(moneyType, amount, reason)
        moneyType = normalizeMoneyType(moneyType)
        amount = tonumber(amount) or 0
        if amount <= 0 then return false end

        local ok
        if moneyType == "bank" then
            if player.Offline then
                local current = vRP.GetBank(passport)
                if current < amount then return false end
                vRP.RemoveBank(passport, amount)
                ok = true
            else
                ok = vRP.PaymentBank(passport, amount, true)
            end
        elseif moneyType == "cash" then
            if player.Offline then return false end
            ok = vRP.TakeItem(passport, SeoulCashItem or "dollar", amount, true)
        else
            return false
        end

        if ok then refreshPlayer(player, true) end
        return ok and true or false
    end

    function player.Functions.SetMoney(moneyType, amount, reason)
        moneyType = normalizeMoneyType(moneyType)
        amount = math.max(tonumber(amount) or 0, 0)

        if moneyType == "bank" then
            local current = vRP.GetBank(passport)
            if amount > current then
                vRP.GiveBank(passport, amount - current, false)
            elseif amount < current then
                vRP.RemoveBank(passport, current - amount)
            end
        elseif moneyType == "cash" then
            if player.Offline then return false end
            local current = vRP.getMoney(passport)
            if amount > current then
                if not giveItemVerified(passport, SeoulCashItem or "dollar", amount - current, true) then return false end
            elseif amount < current then
                if not vRP.TakeItem(passport, SeoulCashItem or "dollar", current - amount, true) then return false end
            end
        else
            return false
        end

        refreshPlayer(player, true)
        return true
    end

    function player.Functions.GetMoney(moneyType)
        moneyType = normalizeMoneyType(moneyType)
        if moneyType == "bank" then return vRP.GetBank(passport) end
        if moneyType == "cash" then return vRP.getMoney(passport) end
        return 0
    end

    function player.Functions.SetJob(job, grade)
        job = tostring(job or "")
        if job == "" then return false end

        local current = buildRole(passport, false).name
        if job == "unemployed" then
            if current ~= "unemployed" and Config.JobLookup[current] then
                vRP.RemovePermission(passport, current)
            end
            refreshPlayer(player, true)
            return true
        end

        if not Config.JobLookup[job] or not QBCore.Shared.Jobs[job] then return false end
        local seoulLevel = qbGradeToSeoul(job, grade, false)
        if not seoulLevel then return false end

        if current ~= "unemployed" and current ~= job and Config.JobLookup[current] then
            vRP.RemovePermission(passport, current)
        end

        vRP.SetPermission(passport, job, seoulLevel)
        refreshPlayer(player, true)
        return true
    end

    function player.Functions.SetGang(gang, grade)
        gang = tostring(gang or "")
        if gang == "" then return false end

        local current = buildRole(passport, true).name
        if gang == "none" then
            if current ~= "none" and Config.GangLookup[current] then
                vRP.RemovePermission(passport, current)
            end
            refreshPlayer(player, true)
            return true
        end

        if not Config.GangLookup[gang] or not QBCore.Shared.Gangs[gang] then return false end
        local seoulLevel = qbGradeToSeoul(gang, grade, true)
        if not seoulLevel then return false end

        if current ~= "none" and current ~= gang and Config.GangLookup[current] then
            vRP.RemovePermission(passport, current)
        end

        vRP.SetPermission(passport, gang, seoulLevel)
        refreshPlayer(player, true)
        return true
    end

    function player.Functions.SetJobDuty(onDuty)
        if player.Offline then return false end
        local job = buildRole(passport, false)
        if job.name == "unemployed" or not Config.JobLookup[job.name] then return false end
        local source = sourceFromPassport(passport)
        if not source then return false end

        if onDuty then
            vRP.ServiceEnter(source, passport, job.name, true)
        else
            vRP.ServiceLeave(source, passport, job.name, true)
        end

        refreshPlayer(player, true)
        TriggerClientEvent("QBCore:Client:SetDuty", source, onDuty and true or false)
        return true
    end

    function player.Functions.Save()
        return saveDatatable(passport, player.Offline and nil or sourceFromPassport(passport))
    end

    function player.Functions.Logout()
        if player.Offline then return false end
        return QBCore.Player.Logout(player.PlayerData.source)
    end

    function player.Functions.AddMethod(methodName, handler)
        if type(methodName) ~= "string" or not isCallable(handler) then return false end
        player.Functions[methodName] = handler
        return true
    end

    function player.Functions.AddField(fieldName, data)
        if type(fieldName) ~= "string" or type(data) == "function" then return false end
        player[fieldName] = data
        return true
    end

    return player
end

-- Mantem o login/lifecycle existente do compat e apenas enriquece o objeto criado por ele.
if type(OriginalLogin) == "function" then
    QBCore.Player.Login = function(source, citizenid, newData)
        local player = OriginalLogin(source, citizenid, newData)
        if not player then return false end

        local passport = tonumber(citizenid) or passportFromSource(source)
        enhancePlayer(player, passport, false)
        QBCore.Players[tonumber(source)] = player
        QBCore.PlayersByCitizenId[tostring(passport)] = player
        pushPlayerData(player)
        return player
    end
end

QBCore.Player.Logout = function(source)
    source = tonumber(source)
    local player = source and QBCore.Players[source] or nil
    local citizenid = player and player.PlayerData and player.PlayerData.citizenid or nil

    if type(OriginalLogout) == "function" then
        OriginalLogout(source)
    else
        TriggerClientEvent("QBCore:Client:OnPlayerUnload", source)
        TriggerEvent("QBCore:Server:OnPlayerUnload", source)
        QBCore.Players[source] = nil
    end

    if citizenid then QBCore.PlayersByCitizenId[tostring(citizenid)] = nil end
    return true
end

function QBCore.Player.GetOfflinePlayer(citizenid)
    local passport = tonumber(citizenid)
    if not passport or not vRP.Identity(passport) then return nil end

    -- Com OX ativo a Seoul nao expoe uma primitiva segura para carregar o inventario/cash de um personagem offline.
    -- Retornar um Player incompleto faria scripts tomarem decisoes com saldo/itens falsos, portanto nao fingimos suporte.
    if UsingOxInventory and GetResourceState("ox_inventory") == "started" and not sourceFromPassport(passport) then
        return nil
    end

    return enhancePlayer({ PlayerData = {}, Functions = {}, Offline = true }, passport, true)
end

function QBCore.Player.Save(source)
    source = tonumber(source)
    local player = source and QBCore.Players[source] or nil
    return player and player.Functions.Save() or false
end

function QBCore.Player.SaveOffline(playerData)
    local passport = playerData and tonumber(playerData.citizenid or playerData.cid)
    return passport and saveDatatable(passport, nil) or false
end

function QBCore.Functions.GetPlayer(source)
    if tonumber(source) then return QBCore.Players[tonumber(source)] end
    local resolved = QBCore.Functions.GetSource(source)
    return resolved and resolved ~= 0 and QBCore.Players[resolved] or nil
end

function QBCore.Functions.GetPlayerByCitizenId(citizenid)
    return QBCore.PlayersByCitizenId[tostring(citizenid)]
end

function QBCore.Functions.GetOfflinePlayerByCitizenId(citizenid)
    return QBCore.Player.GetOfflinePlayer(citizenid)
end

function QBCore.Functions.GetPlayerByLicense(license)
    for _, player in pairs(QBCore.Players) do
        if player.PlayerData and tostring(player.PlayerData.license) == tostring(license) then return player end
    end
    return nil
end

function QBCore.Functions.GetOfflinePlayerByLicense(license)
    -- Uma License pode possuir varios personagens na Seoul. Sem um criterio de personagem,
    -- License -> Passport nao e um contrato univoco; retornar um personagem arbitrario seria adivinhacao.
    return nil
end

function QBCore.Functions.GetPlayerByAccount(account)
    for _, player in pairs(QBCore.Players) do
        if player.PlayerData and player.PlayerData.charinfo and tostring(player.PlayerData.charinfo.account) == tostring(account) then return player end
    end
    return nil
end

function QBCore.Functions.GetPlayerByCharInfo(property, value)
    for _, player in pairs(QBCore.Players) do
        local charinfo = player.PlayerData and player.PlayerData.charinfo
        if charinfo and charinfo[property] ~= nil and tostring(charinfo[property]) == tostring(value) then return player end
    end
    return nil
end

function QBCore.Functions.HasPermission(source, permission)
    if tonumber(source) == 0 then return true end
    local passport = passportFromSource(source)
    if not passport then return false end

    if type(permission) == "table" then
        for _, value in pairs(permission) do
            if QBCore.Functions.HasPermission(source, value) then return true end
        end
        return false
    end

    permission = tostring(permission or "")
    if permission == "" then return false end
    local mapped = Config.Permissions and Config.Permissions[permission:lower()]
    if mapped == false then return true end
    if type(mapped) == "table" then
        return vRP.HasPermission(passport, mapped.group, mapped.level) and true or false
    end

    return vRP.HasPermission(passport, permission) and true or false
end

function QBCore.Functions.GetPermission(source)
    local result = {}
    for permission in pairs(Config.Permissions or {}) do
        if permission ~= "user" and QBCore.Functions.HasPermission(source, permission) then
            result[permission] = true
        end
    end
    return result
end

function QBCore.Functions.HasItem(source, items, amount)
    local passport = passportFromSource(source)
    if not passport then return false end
    amount = tonumber(amount) or 1

    if type(items) == "string" then
        return vRP.ItemAmount(passport, normalizeItem(items)) >= amount
    end

    if type(items) ~= "table" then return false end
    for key, value in pairs(items) do
        local itemName, required
        if type(key) == "number" then
            itemName, required = value, amount
        else
            itemName, required = key, tonumber(value) or amount
        end
        if vRP.ItemAmount(passport, normalizeItem(itemName)) < required then return false end
    end
    return true
end

function QBCore.Functions.Notify(source, text, notifyType, length)
    source = tonumber(source)
    if not source or source <= 0 then
        print(("[QBCore.Notify] source invalido: %s | %s"):format(tostring(source), tostring(text)))
        return false
    end

    local title, message, seoulType = qbNotifyPayload(text, notifyType)
    TriggerClientEvent("Notify", source, title, message, seoulType, tonumber(length) or 5000)
    return true
end

RegisterNetEvent("QBCore:ToggleDuty", function()
    local player = QBCore.Functions.GetPlayer(source)
    if not player or not player.PlayerData or not player.PlayerData.job then return end
    player.Functions.SetJobDuty(not player.PlayerData.job.onduty)
end)

RegisterNetEvent("QBCore:Server:SetMetaData", function(meta, value)
    local player = QBCore.Functions.GetPlayer(source)
    if not player or type(meta) ~= "string" then return end
    if meta == "hunger" or meta == "thirst" or meta == "stress" then
        value = math.max(0, math.min(100, tonumber(value) or 0))
    end
    player.Functions.SetMetaData(meta, value)
end)

function QBCore.Functions.GetPlayersByJob(job, checkOnDuty)
    local players = {}
    for source, player in pairs(QBCore.Players) do
        local data = player.PlayerData and player.PlayerData.job
        if data and (data.name == job or data.type == job) and (not checkOnDuty or data.onduty) then
            players[#players + 1] = source
        end
    end
    return players, #players
end

function QBCore.Functions.GetPlayersOnDuty(job)
    return QBCore.Functions.GetPlayersByJob(job, true)
end

function QBCore.Functions.GetDutyCount(job)
    local _, count = QBCore.Functions.GetPlayersOnDuty(job)
    return count
end

function QBCore.Functions.GetBucketObjects()
    return QBCore.Player_Buckets, QBCore.Entity_Buckets
end

function QBCore.Functions.SetPlayerBucket(source, bucket)
    source, bucket = tonumber(source), tonumber(bucket)
    if not source or not bucket then return false end

    if bucket == 0 then
        exports.vrp:Bucket(source, "Exit")
    else
        exports.vrp:Bucket(source, "Enter", bucket)
    end

    local identifier = QBCore.Functions.GetIdentifier(source, "license") or tostring(source)
    QBCore.Player_Buckets[identifier] = { id = source, bucket = bucket }
    return true
end

function QBCore.Functions.SetEntityBucket(entity, bucket)
    entity, bucket = tonumber(entity), tonumber(bucket)
    if not entity or not bucket then return false end
    SetEntityRoutingBucket(entity, bucket)
    QBCore.Entity_Buckets[entity] = { id = entity, bucket = bucket }
    return true
end

function QBCore.Functions.GetPlayersInBucket(bucket)
    bucket = tonumber(bucket)
    if not bucket then return {} end
    local result = {}
    for _, data in pairs(QBCore.Player_Buckets) do
        if data.bucket == bucket then result[#result + 1] = data.id end
    end
    return result
end

function QBCore.Functions.GetEntitiesInBucket(bucket)
    bucket = tonumber(bucket)
    if not bucket then return {} end
    local result = {}
    for _, data in pairs(QBCore.Entity_Buckets) do
        if data.bucket == bucket then result[#result + 1] = data.id end
    end
    return result
end

function QBCore.Functions.SetMethod(methodName, handler)
    if type(methodName) ~= "string" or not isCallable(handler) then return false, "invalid_method" end
    QBCore.Functions[methodName] = handler
    TriggerEvent("QBCore:Server:UpdateObject")
    return true, "success"
end

function QBCore.Functions.SetField(fieldName, data)
    if type(fieldName) ~= "string" then return false, "invalid_field" end
    QBCore[fieldName] = data
    TriggerEvent("QBCore:Server:UpdateObject")
    return true, "success"
end

local function sharedMutation(collection, action, name, data)
    if type(name) ~= "string" or not QBCore.Shared[collection] then return false, "invalid_name" end
    local target = QBCore.Shared[collection]

    if action == "add" and target[name] then return false, "already_exists" end
    if (action == "update" or action == "remove") and not target[name] then return false, "not_exists" end

    if action == "remove" then target[name] = nil else target[name] = data end
    TriggerClientEvent("QBCore:Client:OnSharedUpdate", -1, collection, name, target[name])
    TriggerEvent("QBCore:Server:UpdateObject")
    return true, "success"
end

function QBCore.Functions.AddJob(name, data) return sharedMutation("Jobs", "add", name, data) end
function QBCore.Functions.UpdateJob(name, data) return sharedMutation("Jobs", "update", name, data) end
function QBCore.Functions.RemoveJob(name) return sharedMutation("Jobs", "remove", name) end
function QBCore.Functions.AddGang(name, data) return sharedMutation("Gangs", "add", name, data) end
function QBCore.Functions.UpdateGang(name, data) return sharedMutation("Gangs", "update", name, data) end
function QBCore.Functions.RemoveGang(name) return sharedMutation("Gangs", "remove", name) end
function QBCore.Functions.AddItem(name, data) return sharedMutation("Items", "add", name, data) end
function QBCore.Functions.UpdateItem(name, data) return sharedMutation("Items", "update", name, data) end
function QBCore.Functions.RemoveItem(name) return sharedMutation("Items", "remove", name) end

local function multipleMutation(collection, values)
    if type(values) ~= "table" or not QBCore.Shared[collection] then return false, "invalid_data" end
    local target = QBCore.Shared[collection]
    for name, data in pairs(values) do
        if type(name) ~= "string" or target[name] then return false, "already_exists", name end
        if type(data) ~= "table" then return false, "invalid_data", name end
    end
    for name, data in pairs(values) do target[name] = data end
    TriggerClientEvent("QBCore:Client:OnSharedUpdateMultiple", -1, collection, values)
    TriggerEvent("QBCore:Server:UpdateObject")
    return true, "success"
end

function QBCore.Functions.AddJobs(values) return multipleMutation("Jobs", values) end
function QBCore.Functions.AddGangs(values) return multipleMutation("Gangs", values) end
function QBCore.Functions.AddItems(values) return multipleMutation("Items", values) end

function QBCore.Functions.AddPlayerMethod(ids, methodName, handler)
    local function apply(source)
        local player = QBCore.Functions.GetPlayer(source)
        if player then player.Functions.AddMethod(methodName, handler) end
    end
    if type(ids) == "table" then for _, id in ipairs(ids) do apply(id) end else apply(ids) end
end

function QBCore.Functions.AddPlayerField(ids, fieldName, data)
    local function apply(source)
        local player = QBCore.Functions.GetPlayer(source)
        if player then player.Functions.AddField(fieldName, data) end
    end
    if type(ids) == "table" then for _, id in ipairs(ids) do apply(id) end else apply(ids) end
end

-- Callbacks server -> client, presentes no QBCore atual e ausentes no compat antigo da Seoul.
function QBCore.Functions.TriggerClientCallback(name, source, ...)
    source = tonumber(source)
    if not source then return nil end

    local args = { ... }
    local callback
    if type(args[1]) == "function" then
        callback = table.remove(args, 1)
    end

    local key = tostring(name) .. ":" .. tostring(source)
    local pending = { callback = callback, promise = promise.new() }
    QBCore.ClientCallbacks[key] = pending

    TriggerClientEvent("QBCore:Client:TriggerClientCallback", source, name, table.unpack(args))

    if callback then return end
    Citizen.Await(pending.promise)
    local value = pending.promise.value
    QBCore.ClientCallbacks[key] = nil
    return value
end

RegisterNetEvent("QBCore:Server:TriggerClientCallback", function(name, ...)
    local key = tostring(name) .. ":" .. tostring(source)
    local pending = QBCore.ClientCallbacks[key]
    if not pending then return end

    pending.promise:resolve(...)
    if pending.callback then pending.callback(...) end
    QBCore.ClientCallbacks[key] = nil
end)

-- Mantem o registro existente, mas aceita o formato moderno { cb = function } / { callback = function }.
QBCore.Functions.CreateUseableItem = function(item, data)
    local callback = data
    if type(data) == "table" and not rawget(data, "__cfx_functionReference") then
        callback = data.cb or data.callback
    end
    if not isCallable(callback) then return false end
    QBCore.UsableItems[normalizeItem(item)] = {
        func = callback,
        resource = GetInvokingResource()
    }
    return true
end

QBCore.Functions.CanUseItem = function(item)
    return QBCore.UsableItems[normalizeItem(item)] or (OriginalCanUseItem and OriginalCanUseItem(item))
end

QBCore.Functions.UseItem = function(source, item)
    local itemData = type(item) == "table" and item or { name = item }
    local name = normalizeItem(itemData.name)
    local entry = QBCore.UsableItems[name]
    local callback = type(entry) == "table" and entry.func or entry
    if isCallable(callback) then return callback(source, itemData) end
    if OriginalUseItem then return OriginalUseItem(source, item) end
    return false
end

AddEventHandler("onResourceStop", function(resource)
    for item, entry in pairs(QBCore.UsableItems) do
        if type(entry) == "table" and entry.resource == resource then
            QBCore.UsableItems[item] = nil
        end
    end
end)

QBCore.Commands = QBCore.Commands or { List = {}, IgnoreList = { user = true, owner = true } }
QBCore.Commands.List = QBCore.Commands.List or {}
QBCore.Commands.IgnoreList = QBCore.Commands.IgnoreList or { user = true, owner = true }

function QBCore.Commands.Add(name, help, arguments, argsRequired, callback, permission, ...)
    if type(name) ~= "string" or not isCallable(callback) then return false end
    permission = permission or "user"
    local extra = { ... }
    local permissions = { permission }
    for _, value in ipairs(extra) do permissions[#permissions + 1] = value end

    RegisterCommand(name, function(source, args, rawCommand)
        if source ~= 0 and not QBCore.Functions.HasPermission(source, permissions) then return end
        if argsRequired and type(arguments) == "table" and #args < #arguments then
            if source ~= 0 then
                QBCore.Functions.Notify(source, "Argumentos obrigatorios ausentes.", "error", 5000)
            end
            return
        end
        callback(source, args, rawCommand)
    end, false)

    QBCore.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permissions,
        help = help or "",
        arguments = arguments or {},
        argsrequired = argsRequired == true,
        callback = callback
    }
    return true
end

function QBCore.Commands.Refresh(source)
    source = tonumber(source)
    if not source or source <= 0 then return false end
    local suggestions = {}
    for command, info in pairs(QBCore.Commands.List) do
        if QBCore.Functions.HasPermission(source, info.permission) then
            suggestions[#suggestions + 1] = { name = "/" .. command, help = info.help, params = info.arguments }
        else
            TriggerClientEvent("chat:removeSuggestion", source, "/" .. command)
        end
    end
    if #suggestions > 0 then TriggerClientEvent("chat:addSuggestions", source, suggestions) end
    return true
end

-- Reindexa players caso o resource seja reiniciado com jogadores online.
CreateThread(function()
    Wait(0)
    if SeoulMultiframework.QBCore.RebuildSharedGroups then SeoulMultiframework.QBCore.RebuildSharedGroups() end

    for _, source in ipairs(GetPlayers()) do
        source = tonumber(source)
        local passport = passportFromSource(source)
        if passport then
            local player = QBCore.Players[source]
            if player then
                enhancePlayer(player, passport, false)
                QBCore.PlayersByCitizenId[tostring(passport)] = player
                pushPlayerData(player)
            elseif type(QBCore.Player.Login) == "function" then
                QBCore.Player.Login(source, passport, {})
            end
        end
    end
end)

AddEventHandler("Disconnect", function(passport, source)
    passport = tonumber(passport)
    source = tonumber(source)
    if passport then QBCore.PlayersByCitizenId[tostring(passport)] = nil end
    if source then
        local identifier = QBCore.Functions.GetIdentifier(source, "license") or tostring(source)
        QBCore.Player_Buckets[identifier] = nil
        QBCore.Players[source] = nil
    end
end)

-- Exports diretos modernos do qb-core. GetCoreObject ja e fornecido pelo compat atual.
for name, handler in pairs(QBCore.Functions) do
    if type(handler) == "function" then
        exports(name, handler)
    end
end

if tostring(GetConvar("seoul:debug", "false")):lower() == "true" then
    print("^2[Seoul]^7 Multiframework QBCore V2 server ativo sem substituir compat/.")
end
