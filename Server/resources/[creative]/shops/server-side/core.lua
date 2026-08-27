-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("shops",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Name)
	local source = source
	local Passport = vRP.Passport(source)

	if Passport and List[Name] and not exports.bank:CheckTaxes(Passport) and not exports.bank:CheckFines(Passport) then
		if Name == "HuntingBuy" and not vRP.DatatableInformation(Passport,"Firearms") then
			TriggerClientEvent("Notify",source,"Aviso","Você precisa possuir <b>Porte de Armas</b>.","vermelho",5000)
			return false
		end

		if Name == "Laundromat" and not vRP.ConsultItem(Passport,"laundromataccess",1) then
			TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x "..ItemName("laundromataccess").."</b>.","amarelo",5000)
			return false
		end

		if not List[Name]["Permission"] or (List[Name]["Permission"] and vRP.HasService(Passport,List[Name]["Permission"])) then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Name and List[Name] then
		local Primary = {}
		local Inv = vRP.Inventory(Passport)
		for Slot,v in pairs(Inv) do
			if v.amount <= 0 or not ItemExist(v.item) then
				vRP.CleanSlot(Passport,Slot)
			else
				v.key = v.item

				local Split = splitString(v.item)
				local Item = Split[1]

				if not v.desc then
					if Item == "vehiclekey" and Split[2] then
						local Consult = exports.oxmysql:single_async("SELECT * FROM vehicles WHERE Plate = ? LIMIT 1",{ Split[2] })
						if Consult and VehicleExist(Consult.Vehicle) then
							v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common><br>Modelo: <common>"..VehicleName(Consult.Vehicle).."</common><br>Placa: <common>"..Split[2].."</common>"
						else
							v.desc = "Proprietário: <epic>Prefeitura</epic><br>Placa: <common>"..Split[2].."</common>"
						end
					elseif Item == "propertys" and Split[2] then
						local Consult = exports.oxmysql:single_async("SELECT * FROM propertys WHERE Serial = ? LIMIT 1",{ Split[2] })
						if Consult then
							v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common>"
						end
					elseif Item == "prescription" and Split[3] then
						v.desc = "Proprietário: <common>"..vRP.FullName(Split[4]).."</common><br>Medicamento: <rare>"..ItemName(Split[3]).."</rare>"
					elseif ItemNamed(Item) and Split[2] and vRP.Identity(Split[2]) then
						if Item == "identity" then
							v.desc = "Passaporte: <rare>"..Dotted(Split[2]).."</rare><br>Nome: <rare>"..vRP.FullName(Split[2]).."</rare>"
						else
							v.desc = "Proprietário: <common>"..vRP.FullName(Split[2]).."</common>"
						end
					end
				end

				if Split[2] then
					local Loaded = ItemLoads(v.item)
					if Loaded then
						v.charges = parseInt(Split[2] * (100 / Loaded))
					end

					if ItemDurability(v.item) then
						v.durability = parseInt(os.time() - Split[2])
						v.days = ItemDurability(v.item)
					end
				end

				Primary[Slot] = v
			end
		end

		return Primary,vRP.GetWeight(Passport)
	end
end
---------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Amount,Target,Name)
	local source = source
	local Target = tostring(Target)
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and Item and Target and List[Name] and List[Name]["Type"] and List[Name]["List"] and List[Name]["List"][Item] then
		if Amount <= 0 then
			return false
		end

		if Amount > 1 and (ItemUnique(Item) or ItemLoads(Item)) then
			Amount = 1
		end

		local Inventory = vRP.Inventory(Passport)

		if vRP.MaxItens(Passport,Item,Amount) then
			TriggerClientEvent("inventory:Notify",source,"Aviso","Quantidade máxima atingida para este item.","amarelo")
			return false
		end

		if not vRP.CheckWeight(Passport,Item,Amount) then
			TriggerClientEvent("inventory:Notify",source,"Aviso","Espaço insuficiente na mochila.","amarelo")
			return false
		end

		if Inventory[Target] and Inventory[Target]["item"] ~= Item then
			TriggerClientEvent("inventory:Notify",source,"Aviso","Slot já está ocupado por outro item.","amarelo")
			return false
		end

		if List[Name]["Type"] == "Cash" then
			if ItemMedical(Item) then
				local Prescription = vRP.HasPrescription(Passport,Item) or vRP.HasService(Passport,"Paramedic")
				if not Prescription then
					TriggerClientEvent("inventory:Notify",source,"Aviso","Você precisa de uma receita para comprar este medicamento.","amarelo")
					return false
				end
			end

			if vRP.PaymentFull(Passport,List[Name]["List"][Item] * Amount) then
				vRP.GenerateItem(Passport,Item,Amount,false,Target)

				if ItemMedical(Item) then
					local Prescription = vRP.HasPrescription(Passport,Item)
					if Prescription then
						vRP.TakeItem(Passport,Prescription.Item,1,true,Prescription.Slot)
					end
				end

				if Item == "WEAPON_PETROLCAN" then
					vRP.GenerateItem(Passport,"WEAPON_PETROLCAN_AMMO",4500)
				end
			else
				TriggerClientEvent("inventory:Notify",source,"Aviso","Dinheiro insuficiente.","amarelo")
				return false
			end
		elseif List[Name]["Type"] == "Illegal" then

			local Price = List[Name]["List"][Item] * Amount

			if vRP.TakeItem(Passport,"dirtydollar",Price,true) then
				vRP.GenerateItem(Passport,Item,Amount,false,Target)
			else
				TriggerClientEvent("inventory:Notify",source,"Aviso","Dinheiro Sujo insuficiente.","amarelo")
				return false
			end
		elseif List[Name]["Type"] == "Consume" and List[Name]["Item"] then
			local Required = List[Name]["List"][Item] * Amount

			if vRP.TakeItem(Passport,List[Name]["Item"],Required) then
				vRP.GenerateItem(Passport,Item,Amount,false,Target)
			else
				TriggerClientEvent("inventory:Notify",source,"Atenção","<b>"..ItemName(List[Name]["Item"]).."</b> insuficiente.","vermelho")
				return false
			end
		end
	end

	TriggerClientEvent("inventory:Update",source)
end
---------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Amount,Slot,Name)
	local source = source
	local Split = SplitOne(Item)
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and List[Name] and List[Name]["List"] and List[Name]["Type"] and List[Name]["List"][Split] and not vRP.CheckDamaged(Item) then
		if List[Name]["Type"] == "Cash" then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GenerateItem(Passport,"dollar",List[Name]["List"][Split] * Amount,false)
			end
		elseif List[Name]["Type"] == "Consume" then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GenerateItem(Passport,List[Name]["Item"],List[Name]["List"][Split] * Amount,false)
			end
		end
	end

	TriggerClientEvent("inventory:Update",source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL OX SHOP BRIDGE
-----------------------------------------------------------------------------------------------------------------------------------------
local OxShopReady = false
local OxShopAccess = {}

local function OxEnabled()
	return GetConvar("seoul:useOxInventory","true") == "true" and GetResourceState("ox_inventory") == "started"
end

local OxShopMaxDistance = 1.75
local function OxNearShop(source,Number)
	local ShopNumber = tonumber(Number)
	if not ShopNumber or not Location[ShopNumber] or not Location[ShopNumber].Coords then return true end

	local Ped = GetPlayerPed(source)
	if Ped == 0 then return false end

	return #(GetEntityCoords(Ped) - Location[ShopNumber].Coords) <= OxShopMaxDistance
end

local function OxNearShopMode(source,Name)
	Name = tostring(Name or "")
	if Name == "" then return false end

	local Ped = GetPlayerPed(source)
	if Ped == 0 then return false end

	local Coords = GetEntityCoords(Ped)
	for Number,v in pairs(Location) do
		if v.Mode == Name and v.Coords and #(Coords - v.Coords) <= OxShopMaxDistance then
			return true,Number
		end
	end

	return false
end

local function OxNormalizeShopName(Payload)
	local ShopType = tostring(Payload and (Payload.shopType or Payload.shopId or "") or "")
	if ShopType:find("^seoul_shops_") then
		return ShopType:gsub("^seoul_shops_","")
	end

	local ShopId = tostring(Payload and Payload.shopId or "")
	if ShopId:find("^seoul_shops_") then
		return ShopId:gsub("^seoul_shops_","")
	end

	return nil
end

local function OxHasShopAccess(source,Name)
	Name = tostring(Name or "")
	if Name == "" then return false end

	local Access = OxShopAccess[source] or OxShopAccess[tostring(source)]
	if Access and Access.Name == Name and Access.Expires >= os.time() then
		return true
	end

	-- Fallback seguro: se o jogador está fisicamente perto de uma loja desse modo,
	-- libera a compra e renova a janela de acesso. Isso evita falso bloqueio quando
	-- o ox_inventory não preserva a janela criada pelo target/bridge antigo.
	if OxNearShopMode(source,Name) then
		OxShopAccess[source] = { Name = Name, Expires = os.time() + 120 }
		return true
	end

	return false
end

local function OxCurrency(Name)
	if not List[Name] then return "dollar" end
	if List[Name].Type == "Illegal" then return "dirtydollar" end
	if List[Name].Type == "Consume" and List[Name].Item then return List[Name].Item end
	return "dollar"
end

local function OxRegisterShops()
	if not OxEnabled() then return end

	for Name,Shop in pairs(List) do
		if Shop.Mode == "Buy" then
			local Inventory = {}
			local Slot = 0
			local Currency = OxCurrency(Name)

			for Item,Price in pairs(Shop.List or {}) do
				Slot = Slot + 1
				Inventory[Slot] = {
					name = Item,
					price = parseInt(Price),
					currency = Currency
				}
			end

			exports.ox_inventory:RegisterShop("seoul_shops_"..Name,{
				name = Name,
				inventory = Inventory
			})
		end
	end

	OxShopReady = true
	if tostring(GetConvar("seoul:debug", "false")):lower() == "true" then
		print("^2[Seoul]^7 lojas da base registradas no ox_inventory.")
	end
end

CreateThread(function()
	Wait(1500)
	OxRegisterShops()
end)

AddEventHandler("onResourceStart",function(Resource)
	if Resource == "ox_inventory" then
		Wait(1500)
		OxRegisterShops()
	end
end)

RegisterServerEvent("shops:OpenOx")
AddEventHandler("shops:OpenOx",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not OxEnabled() then return end
	if not OxShopReady then OxRegisterShops() end
	if not OxNearShop(source,Number) then
		TriggerClientEvent("Notify",source,"Atenção","Chegue mais perto para abrir a loja.","amarelo",5000)
		return
	end

	local Name = Number
	local Sound = false
	local Title = "Loja"

	local ShopNumber = tonumber(Number)
	if ShopNumber and Location[ShopNumber] then
		Name = Location[ShopNumber].Mode
		Sound = Location[ShopNumber].Sound or false
		Title = Location[ShopNumber].Name or "Loja"
	end

	Name = tostring(Name)
	if not Creative.Permission(Name) then return end

	local Shop = List[Name]
	if not Shop then return end

	if Shop.Mode == "Sell" then
		local Items = {}
		for Item,Price in pairs(Shop.List or {}) do
			Items[#Items + 1] = { name = Item, label = ItemName(Item), price = parseInt(Price) }
		end

		TriggerClientEvent("shops:OpenOxSell",source,Name,Title,Items)
		return
	end

	OxShopAccess[source] = { Name = Name, Expires = os.time() + 120 }
	TriggerClientEvent("shops:OpenOxClient",source,Name,Sound)
end)

RegisterServerEvent("shops:SellOx")
AddEventHandler("shops:SellOx",function(Name,Item,Amount)
	local source = source
	local Passport = vRP.Passport(source)
	Amount = parseInt(Amount,true)
	Name = tostring(Name or "")
	Item = tostring(Item or "")

	if not Passport or Amount <= 0 or not List[Name] or List[Name].Mode ~= "Sell" or not List[Name].List or not List[Name].List[Item] then
		return false
	end

	if not Creative.Permission(Name) then return false end
	if vRP.CheckDamaged(Item) then return false end

	local Consult = vRP.ConsultItem(Passport,Item,Amount)
	if not Consult then
		TriggerClientEvent("inventory:Notify",source,"Atenção","Item insuficiente.","amarelo")
		return false
	end

	if vRP.TakeItem(Passport,Consult.Item,Amount,true,Consult.Slot) then
		local PaymentItem = List[Name].Item or "dollar"
		local Price = parseInt(List[Name].List[Item]) * Amount
		vRP.GenerateItem(Passport,PaymentItem,Price,true)
	end
end)

local OxBuyHook
CreateThread(function()
	Wait(2500)
	if OxEnabled() then
		local HookOk,HookId = pcall(function()
			return exports.ox_inventory:registerHook("buyItem",function(Payload)
			local source = Payload.source
			local Name = OxNormalizeShopName(Payload)
			if not Name then return true end

			if not OxHasShopAccess(source,Name) then
				TriggerClientEvent("inventory:Notify",source,"Atenção","Chegue mais perto da loja para comprar.","amarelo")
				return false
			end

			local Passport = vRP.Passport(source)
			if not Passport or not Creative.Permission(Name) then return false end

			local Item = tostring(Payload.itemName or "")
			if ItemMedical(Item) then
				local Prescription = vRP.HasPrescription(Passport,Item) or vRP.HasService(Passport,"Paramedic")
				if not Prescription then
					TriggerClientEvent("inventory:Notify",source,"Aviso","Você precisa de uma receita para comprar este medicamento.","amarelo")
					return false
				end
			end

			return true
		end)

		end)

		if not HookOk or not HookId then
			return
		end

		OxBuyHook = HookId
		AddEventHandler(OxBuyHook,function(Success,Payload)
			if not Success then return end
			local source = Payload.source
			local Passport = vRP.Passport(source)
			if not Passport then return end

			local Item = tostring(Payload.itemName or "")
			if ItemMedical(Item) then
				local Prescription = vRP.HasPrescription(Passport,Item)
				if Prescription then
					vRP.TakeItem(Passport,Prescription.Item,1,true,Prescription.Slot)
				end
			end

			if Item == "WEAPON_PETROLCAN" then
				vRP.GenerateItem(Passport,"WEAPON_PETROLCAN_AMMO",4500)
			end
		end)
	end
end)
