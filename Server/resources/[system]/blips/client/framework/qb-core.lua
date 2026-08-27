-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL QB-CORE COMPAT
-----------------------------------------------------------------------------------------------------------------------------------------
-- A Seoul não roda QBCore puro. O core real é o vRP, que fornece um adapter QB.
-- Por isso este resource precisa tentar qb-core e, se não existir export real, cair para vrp.
-----------------------------------------------------------------------------------------------------------------------------------------
local QB = nil

local function SafeExport(resource, exportName)
	if GetResourceState(resource) == 'missing' then return nil end

	local ok, result = pcall(function()
		return exports[resource][exportName](exports[resource])
	end)

	if ok and result then
		return result
	end

	return nil
end

local function LoadQBCore()
	QB = QB or SafeExport('qb-core','GetCoreObject')
	QB = QB or SafeExport('vrp','GetCoreObject')
	return QB
end

CreateThread(function()
	for _ = 1, 20 do
		if LoadQBCore() then
			TriggerServerEvent('mri_Qblips:getBlips')
			return
		end

		Wait(500)
	end

	print('^3[Seoul][blips]^7 QBCore adapter não encontrado em qb-core/vrp. Blips públicos continuam, grupos podem não filtrar.')
	TriggerServerEvent('mri_Qblips:getBlips')
end)

local function TableType(tbl)
	if table.type then return table.type(tbl) end
	if type(tbl) ~= 'table' then return type(tbl) end

	local count = 0
	for key in pairs(tbl) do
		count += 1
		if type(key) ~= 'number' then
			return 'hash'
		end
	end

	return count > 0 and 'array' or 'empty'
end

function GetPlayer()
	local Core = LoadQBCore()
	if Core and Core.Functions and Core.Functions.GetPlayerData then
		local ok, data = pcall(Core.Functions.GetPlayerData)
		if ok and data then
			return data
		end
	end

	return {}
end

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
	local Core = LoadQBCore()
	if Core then
		Core.PlayerData = Core.PlayerData or {}
		Core.PlayerData.job = job or Core.PlayerData.job
	end

	TriggerServerEvent('mri_Qblips:getBlips')
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
	local Core = LoadQBCore()
	if Core then
		Core.PlayerData = Core.PlayerData or {}
		Core.PlayerData.gang = gang or Core.PlayerData.gang
	end

	TriggerServerEvent('mri_Qblips:getBlips')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent('mri_Qblips:getBlips')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
	local Core = LoadQBCore()
	if Core then
		Core.PlayerData = data or {}
	end

	TriggerServerEvent('mri_Qblips:getBlips')
end)

local groups = { 'job', 'gang' }

function IsPlayerInGroup(filter)
	if not filter then return true end

	local filterType = type(filter)
	local player = GetPlayer()

	if filterType == 'string' then
		for i = 1, #groups do
			local data = player[groups[i]]
			local name = data and data.name
			local grade = data and data.grade
			local level = type(grade) == 'table' and (grade.level or grade.grade or grade[1]) or grade

			if name == filter then
				return name, tonumber(level) or 0
			end
		end

		return false
	end

	local tabletype = TableType(filter)
	if tabletype == 'hash' then
		for i = 1, #groups do
			local data = player[groups[i]]
			local name = data and data.name
			local grade = data and data.grade
			local level = tonumber(type(grade) == 'table' and (grade.level or grade.grade or grade[1]) or grade) or 0
			local required = name and filter[name]

			if required and tonumber(required) <= level then
				return name, level
			end
		end
	elseif tabletype == 'array' then
		for i = 1, #filter do
			local group = filter[i]

			for j = 1, #groups do
				local data = player[groups[j]]
				local name = data and data.name
				local grade = data and data.grade
				local level = tonumber(type(grade) == 'table' and (grade.level or grade.grade or grade[1]) or grade) or 0

				if name == group then
					return name, level
				end
			end
		end
	end

	return false
end
