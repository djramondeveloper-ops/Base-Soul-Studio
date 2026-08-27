local ZonePrefix = "Elevator"
local CurrentFloorDistance = 3.0
local ElevatorUiOpen = false
local ElevatorBlackout = GlobalState.Blackout == true

local function IsVector3(Coords)
	return Coords and Coords.x and Coords.y and Coords.z
end

local function GetGroupFloors(Group)
	if type(Group) ~= "table" then
		return {}
	end

	-- New format: { Floors = { { Name = "...", Coords = vec3(...) } } }
	if type(Group["Floors"]) == "table" and #Group["Floors"] > 0 then
		return Group["Floors"]
	end

	-- Legacy format: array of floors directly in group.
	return Group
end

local function GetGroupPanels(Group)
	local Panels = {}

	local function AddPanel(Coords)
		if IsVector3(Coords) then
			Panels[#Panels + 1] = Coords
		end
	end

	if type(Group) ~= "table" then
		return Panels
	end

	-- New format: Panels at group level.
	if IsVector3(Group["Panels"]) then
		AddPanel(Group["Panels"])
	elseif type(Group["Panels"]) == "table" then
		for _,Coords in ipairs(Group["Panels"]) do
			AddPanel(Coords)
		end
	end

	if IsVector3(Group["Panel"]) then
		AddPanel(Group["Panel"])
	end

	-- Optional per-floor panel support.
	for _,Floor in ipairs(GetGroupFloors(Group)) do
		if IsVector3(Floor["Panels"]) then
			AddPanel(Floor["Panels"])
		elseif type(Floor["Panels"]) == "table" then
			for _,Coords in ipairs(Floor["Panels"]) do
				AddPanel(Coords)
			end
		end

		if IsVector3(Floor["Panel"]) then
			AddPanel(Floor["Panel"])
		end
	end

	return Panels
end

local function GetCurrentFloorIndex(PedCoords,Floors,MaxDistance)
	local NearestIndex = nil
	local NearestDistance = MaxDistance or CurrentFloorDistance

	for Index,Floor in ipairs(Floors or {}) do
		local Coords = Floor and Floor["Coords"]
		if IsVector3(Coords) then
			local Distance = #(PedCoords - Coords)
			if Distance <= NearestDistance then
				NearestDistance = Distance
				NearestIndex = Index
			end
		end
	end

	return NearestIndex
end

AddStateBagChangeHandler("Blackout",nil,function(Name,Key,Value)
	ElevatorBlackout = Value == true

	if ElevatorUiOpen then
		SendNUIMessage({ Action = "PowerState", Payload = { Blackout = ElevatorBlackout } })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,Group in pairs(Config) do
		local InteractionPoints = {}
		local Cached = {}

		local function AddInteractionPoint(Coords)
			if not IsVector3(Coords) then
				return
			end

			local Key = string.format("%.2f:%.2f:%.2f",Coords.x,Coords.y,Coords.z)
			if not Cached[Key] then
				Cached[Key] = true
				InteractionPoints[#InteractionPoints + 1] = Coords
			end
		end

		local Floors = GetGroupFloors(Group)
		for _,Coords in ipairs(GetGroupPanels(Group)) do
			AddInteractionPoint(Coords)
		end

		-- Fallback: no panel configured, use floor positions as interaction points.
		if #InteractionPoints <= 0 then
			for _,Floor in ipairs(Floors) do
				AddInteractionPoint(Floor["Target"] or Floor["Coords"])
			end
		end

		for Index,Coords in ipairs(InteractionPoints) do
			local ZoneName = ZonePrefix..":"..Number..":"..Index
			exports.target:AddBoxZone(ZoneName,Coords,0.8,0.8,{
				name = ZoneName,
				heading = 0.0,
				minZ = Coords.z - 1.0,
				maxZ = Coords.z + 1.0
			},{
				shop = Number,
				Distance = 1.75,
				options = {
					{
						event = "elevator:Open",
						label = "Usar Elevador",
						tunnel = "client"
					}
				}
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ELEVATOR:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("elevator:Open",function(Selected)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) or exports.hud:Wanted() then
		return
	end

	local Group = Config[Selected]
	if Group then
		local Floors = {}
		for Index,Floor in ipairs(GetGroupFloors(Group)) do
			Floors[Index] = Floor
		end
		local CurrentFloor = GetCurrentFloorIndex(GetEntityCoords(Ped),Floors,CurrentFloorDistance)

		SetNuiFocus(true,true)
		ElevatorUiOpen = true
		SendNUIMessage({ Action = "Open", Payload = { Selected,Floors,CurrentFloor,ElevatorBlackout } })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Click",function(Data,Callback)
	local Ped = PlayerPedId()
	local Floor = Data["Floor"]
	local Selected = Data["Elevator"]
	local Group = Config[Selected]
	local Floors = Group and GetGroupFloors(Group) or nil

	if Floors and Floors[Floor] and Floors[Floor]["Coords"] then
		if ElevatorBlackout then
			Callback("Ok")
			return
		end

		local CurrentFloor = GetCurrentFloorIndex(GetEntityCoords(Ped),Floors,CurrentFloorDistance)
		if CurrentFloor and CurrentFloor == Floor then
			Callback("Ok")
			return
		end

		DoScreenFadeOut(0)
		SetNuiFocus(false,false)
		ElevatorUiOpen = false
		TriggerEvent("hud:Active",false)
		SetEntityCoords(Ped,Floors[Floor]["Coords"])

		SetTimeout(2500,function()
			TriggerEvent("hud:Active",true)
			DoScreenFadeIn(2500)
		end)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	ElevatorUiOpen = false

	Callback("Ok")
end)
