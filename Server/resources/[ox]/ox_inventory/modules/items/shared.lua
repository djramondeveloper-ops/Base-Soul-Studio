local function useExport(resource, export)
	return function(...)
		return exports[resource][export](nil, ...)
	end
end

local ItemList = {}
local isServer = IsDuplicityVersion()

local function setImagePath(path)
    if path then
        return path:match('^[%w]+://') and path or ('%s/%s'):format(client.imagepath, path)
    end
end

---@param data OxItem
local function newItem(data)
	data.weight = data.weight or 0

	if data.close == nil then
		data.close = true
	end

	if data.stack == nil then
		data.stack = true
	end

	local clientData, serverData = data.client, data.server
	---@cast clientData -nil
	---@cast serverData -nil

	if not data.consume and (clientData and (clientData.status or clientData.usetime or clientData.export) or serverData?.export) then
		data.consume = 1
	end

	if isServer then
        ---@cast data OxServerItem
        serverData = data.server
		data.client = nil

		if not data.durability then
			if data.degrade or (data.consume and data.consume ~= 0 and data.consume < 1) then
				data.durability = true
			end
		end

        if not serverData then goto continue end

        if serverData.export then
            data.cb = useExport(string.strsplit('.', serverData.export))
        end
	else
        ---@cast data OxClientItem
        clientData = data.client
		data.server = nil
		data.count = 0

        if not clientData then goto continue end

        if clientData.export then
            data.export = useExport(string.strsplit('.', clientData.export))
        end

        clientData.image = setImagePath(clientData.image)

        if clientData.propTwo then
            clientData.prop = clientData.prop and { clientData.prop, clientData.propTwo } or clientData.propTwo
            clientData.propTwo = nil
        end
	end

    ::continue::
	ItemList[data.name] = data
end

for type, data in pairs(lib.load('data.weapons') or {}) do
	for k, v in pairs(data) do
		v.name = k
		v.close = type == 'Ammo' and true or false
        v.weight = v.weight or 0

		if type == 'Weapons' then
			---@cast v OxWeapon
			v.model = v.model or k -- actually weapon type or such? model for compatibility
			v.hash = joaat(v.model)
			v.stack = v.throwable and true or false
			v.durability = v.durability or 0.05
			v.weapon = true
		else
			v.stack = true
		end

		v[type == 'Ammo' and 'ammo' or type == 'Components' and 'component' or type == 'Tints' and 'tint' or 'weapon'] = true

		if isServer then v.client = nil else
			v.count = 0
			v.server = nil
			local clientData = v.client

			if clientData?.image then
                clientData.image = setImagePath(clientData.image)
			end
		end

		ItemList[k] = v
	end
end

local function seoulLower(value)
    return string.lower(tostring(value or ''))
end

local function seoulTrim(value)
    value = tostring(value or '')
    return value:match('^%s*(.-)%s*$') or ''
end

local function seoulBool(value, default)
    if value == nil then return default end
    if value == true or value == 1 or value == '1' or seoulLower(value) == 'true' or seoulLower(value) == 'sim' or seoulLower(value) == 'yes' then return true end
    return false
end

local function seoulNumber(value, default)
    local number = tonumber(value)
    if not number then return default or 0 end
    return number
end

local function seoulIsWeaponLike(item, data)
    local typeLower = seoulLower(data and (data.weaponKind or data.weapon_kind or data.weaponType or data.weapon_type or data.category or data.Category or data.type or data.Type or '') or '')
    local itemLower = seoulLower(item)
    if tostring(item):match('^WEAPON_') then return true end
    if typeLower:find('arma', 1, true) or typeLower:find('weapon', 1, true) then return true end
    if itemLower:find('^ammo%-') or itemLower:find('_ammo') or typeLower:find('muni', 1, true) or typeLower:find('ammo', 1, true) then return true end
    if typeLower:find('component', 1, true) or typeLower:find('anexo', 1, true) or typeLower:find('tint', 1, true) or typeLower:find('tinta', 1, true) then return true end
    return false
end

local function seoulNormalizeIndex(item, data)
    local index = seoulTrim(data and (data.index or data.Index or data.image or data.Image) or '')
    if index == '' then index = item end
    index = index:gsub('%.png$', ''):gsub('%.webp$', ''):gsub('%.jpg$', ''):gsub('%.jpeg$', '')
    if index == '' then index = item end
    return index
end

local function seoulNormalizeExecute(data)
    if type(data) ~= 'table' then return nil end
    local execute = data.Execute or data.execute
    if type(execute) == 'table' then
        local event = seoulTrim(execute.Event or execute.event)
        if event ~= '' then
            return { Type = seoulTrim(execute.Type or execute.type or 'Client'), Event = event }
        end
    end

    local event = seoulTrim(data.event or data.Event or data.clientEvent or data.client_event or data.serverEvent or data.server_event)
    if event == '' then return nil end

    local eventType = seoulTrim(data.eventType or data.event_type or data.executeType or data.execute_type)
    if eventType == '' then
        if data.serverEvent or data.server_event then eventType = 'Server' else eventType = 'Client' end
    end

    return { Type = eventType, Event = event }
end


-- SEOUL ADMINCONTROL WEAPONS RUNTIME
local function seoulClassifyWeaponItem(item, data)
    local kind = seoulLower(data and (data.weaponKind or data.weapon_kind or data.weaponType or data.weapon_type or data.category or data.Category or data.kind or data.Kind or '') or '')
    local typeLower = seoulLower(data and (data.type or data.Type or '') or '')
    local itemLower = seoulLower(item)
    if kind:find('tint', 1, true) or kind:find('tinta', 1, true) or typeLower:find('tinta', 1, true) then return 'Tints' end
    if kind:find('component', 1, true) or kind:find('attach', 1, true) or kind:find('anexo', 1, true) or typeLower:find('component', 1, true) or typeLower:find('anexo', 1, true) then return 'Components' end
    if kind:find('ammo', 1, true) or kind:find('muni', 1, true) or typeLower:find('ammo', 1, true) or typeLower:find('muni', 1, true) then return 'Ammo' end
    if tostring(item):match('^WEAPON_.+_AMMO$') or itemLower:find('^ammo%-') then return 'Ammo' end
    if tostring(item):match('^WEAPON_') or typeLower:find('arma', 1, true) or typeLower:find('weapon', 1, true) then return 'Weapons' end
    if itemLower:find('^at_') or itemLower:find('component') or itemLower:find('attach') then return 'Components' end
    return nil
end

local function seoulSplitCsv(value)
    local list = {}
    if type(value) == 'table' then
        for _, item in ipairs(value) do
            local str = seoulTrim(item):gsub('`', '')
            if str ~= '' then list[#list + 1] = str end
        end
        return list
    end

    value = seoulTrim(value)
    if value == '' then return list end
    for part in value:gmatch('[^,]+') do
        local str = seoulTrim(part):gsub('`', '')
        if str ~= '' then list[#list + 1] = str end
    end
    return list
end

local function seoulHashComponents(list)
    local hashes = {}
    for _, value in ipairs(list or {}) do
        local str = tostring(value or ''):gsub('`', '')
        if str ~= '' then
            local ok, hashed = pcall(function()
                if joaat then return joaat(str) end
                return str
            end)
            hashes[#hashes + 1] = ok and hashed or str
        end
    end
    return hashes
end

local function seoulLoadAdminControlWeapons()
    if not LoadResourceFile or not json or not json.decode then return {} end

    local raw = LoadResourceFile('AdminControl', 'data/items.json')
    if not raw or raw == '' then return {} end

    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then return {} end

    local generated = { Weapons = {}, Ammo = {}, Components = {}, Tints = {} }

    for key, data in pairs(decoded) do
        if type(data) == 'table' then
            local item = seoulTrim(data.item or data.Item or key)
            local section = item ~= '' and seoulClassifyWeaponItem(item, data)
            if section then
                local label = seoulTrim(data.name or data.Name or data.label or data.Label or item)
                local index = seoulNormalizeIndex(item, data)
                local image = seoulTrim(data.imageFile or data.image_file or data.image or data.Image or (index .. '.png'))
                if image == '' then image = index .. '.png' end
                if not image:find('%.') then image = image .. '.png' end
                local weight = math.floor(seoulNumber(data.weight or data.Weight or data.peso or data.Peso, section == 'Ammo' and 0.01 or section == 'Weapons' and 1.0 or 0.05) * 1000 + 0.5)

                if section == 'Weapons' then
                    generated.Weapons[item] = {
                        label = label,
                        weight = weight,
                        durability = seoulNumber(data.oxDurability or data.durabilityOx or data.durability or data.Durability, 0.05),
                        ammoname = seoulTrim(data.ammoname or data.ammoName or data.ammo_name or data.ammo or data.Ammo or '') ~= '' and seoulTrim(data.ammoname or data.ammoName or data.ammo_name or data.ammo or data.Ammo or '') or nil,
                        model = seoulTrim(data.model or data.Model or '') ~= '' and seoulTrim(data.model or data.Model or '') or nil,
                        throwable = seoulBool(data.throwable or data.ThrowAble or data.Throw, false),
                        client = { image = image },
                        seoulAdminControl = true
                    }
                elseif section == 'Ammo' then
                    generated.Ammo[item] = { label = label, weight = weight, client = { image = image }, seoulAdminControl = true }
                elseif section == 'Components' then
                    local componentHashes = seoulSplitCsv(data.components or data.component or data.Component or data.hashes or data.hash or data.Hash)
                    if #componentHashes > 0 then
                        generated.Components[item] = {
                            label = label,
                            type = seoulTrim(data.componentType or data.component_type or data.attachType or data.attach_type or data.typeKey or data.type_key or 'attachment'),
                            weight = weight,
                            client = { component = seoulHashComponents(componentHashes), usetime = seoulNumber(data.usetime or data.useTime or data.use_time, 2500), image = image },
                            seoulAdminControl = true
                        }
                    end
                elseif section == 'Tints' then
                    generated.Tints[item] = { label = label, weight = weight, tint = seoulNumber(data.tint or data.Tint or data.tintIndex or data.tint_index, 0), client = { image = image }, seoulAdminControl = true }
                end
            end
        end
    end

    return generated
end

for type, data in pairs(seoulLoadAdminControlWeapons()) do
    for k, v in pairs(data) do
        v.name = k
        v.close = type == 'Ammo' and true or false
        v.weight = v.weight or 0

        if type == 'Weapons' then
            v.model = v.model or k
            v.hash = joaat(v.model)
            v.stack = v.throwable and true or false
            v.durability = v.durability or 0.05
            v.weapon = true
        else
            v.stack = true
        end

        v[type == 'Ammo' and 'ammo' or type == 'Components' and 'component' or type == 'Tints' and 'tint' or 'weapon'] = true

        if isServer then
            v.client = nil
        else
            v.count = 0
            v.server = nil
            local clientData = v.client
            if clientData?.image then clientData.image = setImagePath(clientData.image) end
        end

        ItemList[k] = v
    end
end
-- SEOUL ADMINCONTROL WEAPONS RUNTIME END

local function seoulLoadAdminControlItems()
    if not LoadResourceFile or not json or not json.decode then return {} end

    local raw = LoadResourceFile('AdminControl', 'data/items.json')
    if not raw or raw == '' then return {} end

    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then return {} end

    local generated = {}

    for key, data in pairs(decoded) do
        if type(data) == 'table' then
            local item = seoulTrim(data.item or data.Item or key)
            -- Usa o código real do item para classificar. Em alguns fluxos o JSON
            -- pode vir por array/chave numérica; se a checagem usar só a chave,
            -- WEAPON_/ammo acabam entrando como item comum e sobrescrevem o
            -- registro correto de data.weapons.lua. Resultado: o OX trata arma
            -- como item usável normal e chama server.UseItem, que imprime
            -- "inventory recusou uso do item WEAPON_*".
            if item ~= '' and not item:find('%s') and not seoulIsWeaponLike(item, data) then
                local label = seoulTrim(data.name or data.Name or data.label or data.Label or item)
                local index = seoulNormalizeIndex(item, data)
                local image = seoulTrim(data.imageFile or data.image_file or data.image or data.Image or (index .. '.png'))
                if image == '' then image = index .. '.png' end
                if not image:find('%.') then image = image .. '.png' end

                local itemData = {
                    label = label,
                    weight = math.floor(seoulNumber(data.weight or data.Weight or data.peso or data.Peso, 0) * 1000 + 0.5),
                    stack = seoulBool(data.stack, true),
                    close = seoulBool(data.close, true),
                    seoulAdminControl = true,
                    client = { image = image }
                }

                local description = seoulTrim(data.description or data.Description or data.desc or '')
                if description ~= '' then itemData.description = description end

                local execute = seoulNormalizeExecute(data)
                if execute and execute.Event then
                    if seoulLower(execute.Type) == 'server' then
                        itemData.server = { event = execute.Event }
                    else
                        itemData.client.event = execute.Event
                    end
                end

                generated[item] = itemData
            end
        end
    end

    return generated
end

local dataItems = lib.load('data.items') or {}
for k, v in pairs(seoulLoadAdminControlItems()) do
    dataItems[k] = v
end

for k, v in pairs(dataItems) do
    -- Proteção: nunca deixa uma entrada de data/items.lua sobrescrever arma,
    -- munição, componente ou tinta carregada de data/weapons.lua/AdminControl.
    -- Isso mantém item.weapon/item.ammo corretos no servidor e no cliente.
    if seoulIsWeaponLike(k, v) then
        if ItemList[k] == nil then
            -- Se não veio do weapons.lua, ainda assim não registra como comum;
            -- o cadastro deve ser corrigido/gerado pela Fase Weapons.
        end
    else
	    v.name = k
	    local success, response = pcall(newItem, v)

        if not success then
            warn(('An error occurred while creating item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(k, response))
        end
    end
end

ItemList.cash = ItemList.money

return ItemList
