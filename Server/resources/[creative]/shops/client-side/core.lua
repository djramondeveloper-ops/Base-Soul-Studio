-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	if Opened then
		Opened = false
	end
end)
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
		vSERVER.Take(Data["item"],Data["amount"],Data["target"],Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Store(Data["item"],Data["amount"],Data["target"],Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Open",function(Number)
	if GetConvar("seoul:useOxInventory","true") == "true" and GetResourceState("ox_inventory") == "started" then
		TriggerServerEvent("shops:OpenOx",Number)
		return
	end

	if not exports.hud:Wanted() then
		if Location[Number] then
			if vSERVER.Permission(Location[Number]["Mode"]) then
				Opened = Location[Number]["Mode"]

				TriggerEvent("inventory:Open",{
					Type = "Shops",
					Mode = List[Opened]["Mode"],
					Item = (List[Opened]["Item"] or "dollar"),
					Resource = "shops",
					Right = Location[Number]["Name"] or "Loja"
				})

				if Location[Number]["Sound"] then
					TriggerEvent("sounds:playSound","shop-open","shop",1.0,false)
				end
			end
		else
			if vSERVER.Permission(Number) then
				Opened = Number

				TriggerEvent("inventory:Open",{
					Type = "Shops",
					Mode = List[Opened]["Mode"],
					Item = (List[Opened]["Item"] or "dollar"),
					Resource = "shops",
					Right = "Loja"
				})
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPENOXCLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:OpenOxClient")
AddEventHandler("shops:OpenOxClient",function(Name,Sound)
	if Sound then
		TriggerEvent("sounds:playSound","shop-open","shop",1.0,false)
	end

	local OpenedShop = exports.ox_inventory:openInventory("shop",{ type = "seoul_shops_"..Name })
	if OpenedShop == false then
		TriggerEvent("Notify","Lojas","Não foi possível abrir esta loja no ox_inventory.","vermelho",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPENOXSELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:OpenOxSell")
AddEventHandler("shops:OpenOxSell",function(Name,Title,Items)
	if not lib then
		TriggerEvent("Notify","Lojas","ox_lib não carregada no resource shops.","vermelho",5000)
		return
	end

	local Options = {}
	for _,Item in ipairs(Items or {}) do
		Options[#Options + 1] = {
			title = Item.label or Item.name,
			description = "Valor unitário: $"..tostring(Item.price),
			icon = "box",
			onSelect = function()
				local Input = lib.inputDialog(Item.label or Item.name,{
					{ type = "number", label = "Quantidade", default = 1, min = 1, required = true }
				})

				if Input and Input[1] then
					TriggerServerEvent("shops:SellOx",Name,Item.name,tonumber(Input[1]) or 1)
				end
			end
		}
	end

	lib.registerContext({ id = "seoul_shop_sell_"..Name, title = Title or "Vender", options = Options })
	lib.showContext("seoul_shop_sell_"..Name)
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
			exports.interact:addCoords(v["Coords"],{
				name = "Shops:"..Number,
				label = v["Name"] or "Abrir",
				icon = "fa-solid fa-store",
				distance = 1.5,
				onSelect = function()
					TriggerEvent("shops:Open",Number)
				end
			})
		else
			if v["Circle"] then
				exports.target:AddCircleZone("Shops:"..Number,v["Coords"],v["Circle"],{
					name = "Shops:"..Number,
					heading = 0.0,
					useZ = true
				},{
					shop = Number,
					Distance = 1.0,
					options = {
						{
							event = "shops:Open",
							label = "Abrir",
							tunnel = "client"
						}
					}
				})
			else
				exports.target:AddBoxZone("Shops:"..Number,v["Coords"],0.75,0.75,{
					name = "Shops:"..Number,
					heading = 0.0,
					minZ = v["Coords"]["z"] - 1.0,
					maxZ = v["Coords"]["z"] + 1.0
				},{
					shop = Number,
					Distance = 1.0,
					options = {
						{
							event = "shops:Open",
							label = v["Name"] or "Abrir",
							tunnel = "client"
						}
					}
				})
			end
		end
	end
end)
