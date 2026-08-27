-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	Opened = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenCrafting(Mode)
	Opened = Mode

	if GetConvar("seoul:useOxInventory","true") == "true" and GetResourceState("ox_inventory") == "started" then
		exports.ox_inventory:openInventory("crafting",{ id = "seoul_crafting_"..Mode, index = 1 })
		return
	end

	TriggerEvent("inventory:Open",{
		Mode = "Buy",
		Type = "Shops",
		Right = "Produção",
		Resource = "crafting"
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,PrimaryWeight = vSERVER.Mount(Opened)
	if Primary then
		Callback({ Primary = Primary, Secondary = ItemList[Opened], PrimaryMaxWeight = PrimaryWeight, SecondarySlots = math.max(CountTable(ItemList[Opened]),25) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Take(Data.item,Data.amount,Data.target,Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:Open",function(Number)
	if exports.hud:Wanted() then
		return false
	end

	local Data = Location[Number]
	if Data then
		if vSERVER.Permission(Data.Mode) then
			OpenCrafting(Data.Mode)
		end
	else
		if vSERVER.Permission(Number) then
			OpenCrafting(Number)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERACT
-----------------------------------------------------------------------------------------------------------------------------------------
local function UseInteract()
	return GetResourceState("interact") == "started"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Location) do
		if UseInteract() then
			exports.interact:addCoords(v.Coords,{
				name = "Crafting:"..Number,
				label = "Abrir",
				icon = "fa-solid fa-screwdriver-wrench",
				distance = 2.0,
				onSelect = function()
					TriggerEvent("crafting:Open",Number)
				end
			})
		else
			exports.target:AddCircleZone("Crafting:"..Number,v.Coords,v.Circle,{
				name = "Crafting:"..Number,
				heading = 0.0,
				useZ = true
			},{
				shop = Number,
				Distance = 2.0,
				options = {
					{
						event = "crafting:Open",
						label = "Abrir",
						tunnel = "client"
					}
				}
			})
		end
	end
end)
