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
Tunnel.bindInterface("pause",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Salarys = {}
local Shopping = {}
local PlayerBox = {}
local BattleStart = 0
local Marketplace = {}
local MarketplaceBusy = {}
local BattlepassConfig = type(Battlepass) == "table" and Battlepass or {}
local BattlepassFree = type(BattlepassConfig.Free) == "table" and BattlepassConfig.Free or {}
local BattlepassPremium = type(BattlepassConfig.Premium) == "table" and BattlepassConfig.Premium or {}
local BattlepassNecessary = tonumber(BattlepassPoints) or 0
local BattlepassCost = tonumber(BattlepassPrice) or 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATABASE
-----------------------------------------------------------------------------------------------------------------------------------------
local function EnsureDatabase()
	exports.oxmysql:query_async([[
		CREATE TABLE IF NOT EXISTS `deaths_creative` (
			`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
			`Attacker` INT NULL DEFAULT NULL,
			`Victim` INT NULL DEFAULT NULL,
			`Weapon` VARCHAR(64) NULL DEFAULT NULL,
			`Timestamp` INT UNSIGNED NOT NULL DEFAULT 0,
			PRIMARY KEY (`id`),
			INDEX `idx_deaths_creative_attacker` (`Attacker`),
			INDEX `idx_deaths_creative_victim` (`Victim`),
			INDEX `idx_deaths_creative_timestamp` (`Timestamp`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])

	exports.oxmysql:query_async([[
		CREATE TABLE IF NOT EXISTS `codes_creative` (
			`Code` VARCHAR(64) NOT NULL,
			`Rewards` LONGTEXT NOT NULL,
			`Max` INT NOT NULL DEFAULT 0,
			`Used` INT NOT NULL DEFAULT 0,
			`CreatedAt` INT UNSIGNED NOT NULL DEFAULT 0,
			PRIMARY KEY (`Code`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])

	exports.oxmysql:query_async([[
		CREATE TABLE IF NOT EXISTS `codes_creative_redeemd` (
			`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
			`Code` VARCHAR(64) NOT NULL,
			`Passport` INT NOT NULL,
			`RedeemdAt` INT UNSIGNED NOT NULL DEFAULT 0,
			PRIMARY KEY (`id`),
			UNIQUE KEY `idx_codes_creative_redeemd_code_passport` (`Code`,`Passport`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])
end

local function GiveConfiguredReward(Passport,Reward)
	if type(Reward) == "table" and Reward.Vehicle then
		local Days = parseInt(Reward.Days,true)
		local Duration = Days > 0 and Days * 86400 or 2592000
		local Vehicle = Reward.Vehicle
		local Consult = vRP.SelectVehicle(Passport,Vehicle)

		if not Consult then
			exports.oxmysql:insert_async("INSERT INTO vehicles (Passport,Vehicle,Plate,Weight,Tax,Work,Block) VALUES (@Passport,@Vehicle,@Plate,@Weight,@Tax,@Work,@Block)",{
				Passport = Passport,
				Vehicle = Vehicle,
				Plate = vRP.GeneratePlate(),
				Weight = VehicleWeight(Vehicle),
				Tax = os.time() + Duration,
				Work = (VehicleMode(Vehicle) == "Work" and 1 or 0),
				Block = 0
			})
		end

		return true
	end

	if type(Reward) == "table" and Reward.Item and Reward.Amount then
		vRP.GenerateItem(Passport,Reward.Item,parseInt(Reward.Amount,true))
		return true
	end

	return false
end

CreateThread(EnsureDatabase)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Disconnect()
	local source = source
	vRP.Kick(source,"Desconectado")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Home()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Identity = vRP.Identity(Passport)
	local Datatable = vRP.Datatable(Passport)
	if not Identity or not Datatable then
		return false
	end

	local Experience = {}
	for Index,Name in pairs(Works) do
		Experience[#Experience + 1] = { Name,Datatable[Index] or 0 }
	end

	local Shop = {}
	local Count = math.min(#Shopping,15)
	for Number,Item in ipairs(Shopping) do
		if Number > Count then
			break
		end

		Shop[Number] = {
			Index = Item.Index,
			Amount = Item.Amount,
			Name = Item.Name
		}
	end

	local Consult = vRP.DatatableInformation(Passport,"MedicPlan") or 0
	local MedicRemaining = math.floor((Consult - os.time()) / 86400)
	local Playing = vRP.Playing(Passport,"Online")
	local MedicPlan = math.max(MedicRemaining,0)

	return {
		{
			Medic = MedicPlan,
			Passport = Passport,
			Bank = Identity.Bank,
			Blood = Sanguine(Identity.Blood),
			Playing = CompleteTimers(Playing),
			Gemstone = vRP.UserGemstone(Identity.License),
			Name = ("%s %s"):format(Identity.Name,Identity.Lastname)
		},
		Coupon
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGENERATE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local ConsultM = vRP.SingleQuery("entitydata/GetData",{ Name = "Marketplace" })
	Marketplace = ConsultM and json.decode(ConsultM.Information) or {}

	local ConsultB = vRP.SingleQuery("entitydata/GetData",{ Name = "Battlepass" })
	BattleStart = ConsultB and json.decode(ConsultB.Information) or 0
	if type(BattleStart) ~= "number" or BattleStart <= 0 then
		BattleStart = os.time()
		vRP.Query("entitydata/SetData",{ Name = "Battlepass", Information = BattleStart })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COUPON HOT RELOAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local LastCode = Coupon and Coupon.Code or ""
	local LastDiscount = Coupon and Coupon.Discount or 0

	while true do
		Wait(1000)

		local Content = LoadResourceFile(GetCurrentResourceName(),"shared-side/shared.lua")
		local Block = Content and Content:match("Coupon%s*=%s*{(.-)}")
		if Block then
			local Code = Block:match('Code%s*=%s*"([^"]*)"') or Block:match("Code%s*=%s*'([^']*)'")
			local Discount = tonumber(Block:match("Discount%s*=%s*([%d%.]+)"))

			if Code and Discount and (Code ~= LastCode or Discount ~= LastDiscount) then
				Coupon = { Code = Code, Discount = Discount }
				LastCode = Code
				LastDiscount = Discount
				TriggerClientEvent("pause:UpdateCoupon",-1,Coupon)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Config()
	local Store = {}
	for Index,Data in pairs(ShopItens) do
		Store[#Store + 1] = {
			Index = Index,
			Name = Data.Name or ItemName(Index) or Index,
			Image = Data.Image or ItemIndex(Index) or Index,
			Category = Data.Category,
			Price = Data.Price,
			Discount = Data.Discount,
			Highlight = Data.Highlight,
			Description = Data.Description
		}
	end

	return {
		TableLevel(),
		type(HomeBoxes) == "table" and HomeBoxes or {},
		Premium,
		Propertys,
		ShopVehicles,
		Store,
		{
			BattlepassNecessary,
			BattlepassCost,
			(BattleStart + 2592000) >= os.time() and (BattleStart + 2592000) or 0,
			BattlepassFree,
			BattlepassPremium
		},
		Boxes,
		MarketplaceTax,
		#Daily,
		Socials
	}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StoreBuy(Item,Amount,OtherPassport)
	local source = source
	local Data = ShopItens[Item]
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if not (Passport and Data and not Active[Passport]) then
		return false
	end

	Active[Passport] = true

	if Amount > 1 and ItemUnique(Item) then
		Amount = 1
	end

	local Price = Data.Price * (Data.Discount < 1.0 and Data.Discount or 1.0)
	local Valuation = Price * Amount

	local function FinishBuy(TargetPassport)
		if Passport ~= TargetPassport then
			local Name = vRP.FullName(Passport)
			local OtherName = vRP.FullName(TargetPassport)

			TriggerClientEvent("chat:ClientMessage",-1,"","Com grande estilo, <b><yellow>"..Name.."</yellow></b> presenteou <b><yellow>"..OtherName.."</yellow></b> com <b><green>"..Dotted(Amount).."x "..ItemName(Item).."</green></b>, marcando esse momento como algo especial.","Importante",true,true)
		end

		exports.discord:Embed("Shopping","**[TIPO]:** Compra\n**[PASSAPORTE]:** "..Passport.."\n"..(TargetPassport and ("**[PARA]:** "..TargetPassport.."\n") or "").."**[ITEM]:** "..Dotted(Amount).."x "..Item.."\n**[DIAMANTES]:** "..Dotted(Valuation))
		table.insert(Shopping,1,{ Amount = Amount, Index = ItemIndex(Item), Name = vRP.LowerName(TargetPassport) })
		TriggerClientEvent("pause:Notify",source,"Sucesso","Compra concluÃ­da.","verde")
		Active[Passport] = nil

		return Amount
	end

	if OtherPassport and Passport ~= OtherPassport and vRP.Identity(OtherPassport) then
		local OtherSource = vRP.Source(OtherPassport)

		if OtherSource then
			if not vRP.MaxItens(OtherPassport,Item,Amount) and vRP.PaymentGems(Passport,Valuation) then
				vRP.GenerateItem(OtherPassport,Item,Amount,false)

				return FinishBuy(OtherPassport)
			end
		else
			if vRP.PaymentGems(Passport,Valuation) then
				local Selected
				local Consult = vRP.GetSrvData("Offline:"..OtherPassport,true)

				repeat
					Selected = GenerateString("DDLLDDLL")
				until Selected and not Consult[Selected]

				Consult[Selected] = { Item = Item, Amount = Amount }
				vRP.SetSrvData("Offline:"..OtherPassport,Consult,true)

				return FinishBuy(OtherPassport)
			end
		end

		Active[Passport] = nil

		return false
	end

	if not vRP.MaxItens(Passport,Item,Amount) and vRP.PaymentGems(Passport,Valuation) then
		vRP.GenerateItem(Passport,Item,Amount,false)

		return FinishBuy(Passport)
	end

	Active[Passport] = nil

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FURNITURESBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.FurnituresBuy(Item,Amount,OtherPassport)
	local source = source
	local Data = FurnituresItens[Item]
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if not (Passport and Data and not Active[Passport]) then
		return false
	end

	Active[Passport] = true

	if Amount > 1 and ItemUnique(Item) then
		Amount = 1
	end

	local Price = Data.Price * (Data.Discount < 1.0 and Data.Discount or 1.0)
	local Valuation = Price * Amount

	local function FinishBuy(TargetPassport)
		if Passport ~= TargetPassport then
			local Name = vRP.FullName(Passport)
			local OtherName = vRP.FullName(TargetPassport)

			TriggerClientEvent("chat:ClientMessage",-1,"","Com grande estilo, <b><yellow>"..Name.."</yellow></b> presenteou <b><yellow>"..OtherName.."</yellow></b> com <b><green>"..Dotted(Amount).."x "..ItemName(Item).."</green></b>, marcando esse momento como algo especial.","Importante",true,true)
		end

		exports.discord:Embed("Shopping","**[TIPO]:** Compra\n**[PASSAPORTE]:** "..Passport.."\n"..(TargetPassport and ("**[PARA]:** "..TargetPassport.."\n") or "").."**[ITEM]:** "..Dotted(Amount).."x "..Item.."\n**[DIAMANTES]:** "..Dotted(Valuation))
		table.insert(Shopping,1,{ Amount = Amount, Index = ItemIndex(Item), Name = vRP.LowerName(TargetPassport) })
		TriggerClientEvent("pause:Notify",source,"Sucesso","Compra concluÃ­da.","verde")
		Active[Passport] = nil

		return Amount
	end

	if OtherPassport and Passport ~= OtherPassport and vRP.Identity(OtherPassport) then
		local OtherSource = vRP.Source(OtherPassport)

		if OtherSource then
			if not vRP.MaxItens(OtherPassport,Item,Amount) and vRP.PaymentGems(Passport,Valuation) then
				vRP.GenerateItem(OtherPassport,Item,Amount,false)

				return FinishBuy(OtherPassport)
			end
		else
			if vRP.PaymentGems(Passport,Valuation) then
				local Selected
				local Consult = vRP.GetSrvData("Offline:"..OtherPassport,true)

				repeat
					Selected = GenerateString("DDLLDDLL")
				until Selected and not Consult[Selected]

				Consult[Selected] = { Item = Item, Amount = Amount }
				vRP.SetSrvData("Offline:"..OtherPassport,Consult,true)

				return FinishBuy(OtherPassport)
			end
		end

		Active[Passport] = nil

		return false
	end

	if not vRP.MaxItens(Passport,Item,Amount) and vRP.PaymentGems(Passport,Valuation) then
		vRP.GenerateItem(Passport,Item,Amount,false)

		return FinishBuy(Passport)
	end

	Active[Passport] = nil

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALARYS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Salarys()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local CurrentTimer = os.time()
	local NextPayment = Salarys[Passport]
	if not NextPayment or NextPayment < CurrentTimer then
		local Valuation = vRP.UserSalarys(Passport)
		if Valuation and Valuation > 0 then
			Salarys[Passport] = CurrentTimer + SalaryCooldown
			vRP.GiveBank(Passport,Valuation)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Propertys()
	local source = source
	local Information = {}
	local Passport = vRP.Passport(source)
	if Passport then
		for Index,v in pairs(Propertys) do
			Information[Index] = exports.crons:Check(Passport,"WipePermission",{ Permission = v.Permission }) or (vRP.AmountGroups(v.Permission) > 0 and true) or false
		end
	end

	return Information
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PropertyBuy(Index)
	local source = source
	local Property = Propertys[Index]
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] or not Property or not Property.Permission then
		return false
	end

	if Property.Necessary and not vRP.Permission(Passport,Property.Necessary) then
		return false
	end

	local Level = 1
	local Price = Property.Price or 0
	local Permission = Property.Permission
	local Discount = Property.Discount or 1.0

	if not Permission then
		TriggerClientEvent("pause:Notify",source,"AtenÃ§Ã£o","PermissÃ£o nÃ£o encontrada.","amarelo")
		return false
	end

	local Amount = vRP.AmountGroups(Propertys[Index].Permission)
	local CurrentLevel = vRP.HasPermission(Passport,Propertys[Index].Permission)
	if Amount > 0 and CurrentLevel and CurrentLevel > 1 then
		TriggerClientEvent("pause:Notify",source,"AtenÃ§Ã£o","Propriedade indisponÃ­vel.","amarelo")
		return false
	end

	Active[Passport] = true

	if Discount < 1.0 then
		Price = parseInt(Price * Discount)
	end

	if vRP.PaymentGems(Passport,Price) then
		exports.discord:Embed("Propertys","**[PASSAPORTE]:** "..Passport.."\n**[PERMISSÃƒO]:** "..Permission.."\n**[COMPROU]:** "..(Property.Name or "Desconhecido").."\n**[VALOR]:** "..Price.."\n**[DURAÃ‡ÃƒO]:** "..CompleteTimers(Property.Duration))
		TriggerClientEvent("pause:Notify",source,"Sucesso","Compra concluÃ­da.","verde")

		if not CurrentLevel then
			vRP.SetPermission(Passport,Permission,Level)
		end

		Active[Passport] = nil

		return exports.crons:Insert(Passport,"WipePermission",Property.Duration,{ Permission = Permission, Level = Level })
	end

	Active[Passport] = nil

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Premium()
	local source = source
	local Information = {}
	local Passport = vRP.Passport(source)
	if Passport then
		for Index,v in pairs(Premium) do
			Information[Index] = exports.crons:Check(Passport,"RemovePermission",{ Permission = v.Permission })
		end
	end

	return Information
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PremiumBuy(Index,Selectable)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Data = Premium[Index]
	if not Data or not Data.Permission or Active[Passport] then
		return false
	end

	local Duration = Data.Duration or 0
	if Duration <= 0 then
		return false
	end

	Active[Passport] = true

	if Data.Group and not vRP.HasGroup(Passport,Data.Group) then
		TriggerClientEvent("pause:Notify",source,"AtenÃ§Ã£o","PermissÃ£o nÃ£o encontrada.","amarelo")
		Active[Passport] = nil
		return false
	end

	if Selectable and #Selectable > 0 then
		for Number = 1,#Selectable do
			local Model = Selectable[Number]
			local Consult = vRP.SingleQuery("vehicles/selectVehicles",{ Passport = Passport, Vehicle = Model })
			if Consult and not Consult.Block then
				TriggerClientEvent("pause:Notify",source,"Aviso","JÃ¡ possui um <b>"..VehicleName(Model).."</b>.","amarelo")
				Active[Passport] = nil
				return false
			end
		end
	end

	local Price = Data.Price or 0
	if Data.Discount and Data.Discount < 1.0 then
		Price = math.floor(Price * Data.Discount)
	end

	if Price > 0 and not vRP.PaymentGems(Passport,Price) then
		TriggerClientEvent("pause:Notify",source,"AtenÃ§Ã£o","Diamante insuficiente.","amarelo")
		Active[Passport] = nil
		return false
	end

	if Selectable and #Selectable > 0 then
		for Number = 1,#Selectable do
			local Model = Selectable[Number]
			if not vRP.SelectVehicle(Passport,Model) then
				exports.oxmysql:insert_async("INSERT INTO vehicles (Passport,Vehicle,Plate,Weight,Tax,Work,Block) VALUES (@Passport,@Vehicle,@Plate,@Weight,@Tax,@Work,@Block)",{ Passport = Passport, Vehicle = Model, Plate = vRP.GeneratePlate(), Weight = VehicleWeight(Model), Tax = os.time() + Duration, Block = 1, Work = (VehicleMode(Model) == "Work" and 1 or 0) })
			end

			exports.crons:Insert(Passport,"RemoveVehicle",Duration,{ Model = Model })
		end
	end

	if not vRP.HasPermission(Passport,Data.Permission,1) then
		vRP.SetPermission(Passport,Data.Permission,1)
	end

	exports.discord:Embed("Premium","**[PASSAPORTE]:** "..Passport.."\n**[COMPROU]:** "..Data.Name.."\n**[VALOR]:** "..Price.."\n**[DURAÃ‡ÃƒO]:** "..CompleteTimers(Duration))
	exports.crons:Insert(Passport,"RemovePermission",Duration,{ Permission = Data.Permission, Level = 1 })
	TriggerClientEvent("pause:Notify",source,"Sucesso","Compra concluÃ­da.","verde")
	Active[Passport] = nil

	return exports.crons:Check(Passport,"RemovePermission",{ Permission = Data.Permission })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Battlepass()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Consult = vRP.Battlepass(Passport)
	if not Consult then
		return false
	end

	return { Consult.Free,Consult.Premium,Consult.Points,Consult.Active }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASSRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.BattlepassRescue(Mode,Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Rewards = Mode == "Free" and BattlepassFree or Mode == "Premium" and BattlepassPremium
	local DataItens = Rewards and Rewards[Number]
	if not DataItens then
		return false
	end

	if Active[Passport] then
		return false
	end

	if (BattleStart + 2592000) < os.time() then
		return false
	end

	Active[Passport] = true

	local Consult = vRP.Battlepass(Passport)
	if not Consult then
		Active[Passport] = nil
		return false
	end

	if Mode == "Premium" and not Consult.Active then
		Active[Passport] = nil
		return false
	end

	local Item = DataItens.Item
	local Amount = DataItens.Amount
	local Next = (Consult[Mode] or 0) + 1

	if not vRP.CheckWeight(Passport,Item,Amount) then
		Active[Passport] = nil
		return false
	end

	if Next ~= Number then
		Active[Passport] = nil
		return false
	end

	if BattlepassNecessary <= 0 or not vRP.BattlepassPayment(Passport,Mode,BattlepassNecessary) then
		Active[Passport] = nil
		return false
	end

	exports.discord:Embed("Battlepass",("**[PASSAPORTE]:** %s\n**[MODO]:** %s\n**[VALOR]:** %s"):format(Passport,Mode,Number))
	TriggerClientEvent("pause:Notify",source,"Sucesso","Resgate concluÃ­do.","verde")
	vRP.GenerateItem(Passport,Item,Amount)
	Active[Passport] = nil

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASSBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.BattlepassBuy()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if Active[Passport] or BattlepassCost <= 0 then
		return false
	end

	Active[Passport] = true

	local Configpass = vRP.Battlepass(Passport)
	if not Configpass then
		Active[Passport] = nil
		return false
	end

	local Consult = vRP.SingleQuery("entitydata/GetData",{ Name = "Battlepass" })
	local Start = Consult and json.decode(Consult.Information) or 0
	local ValidPeriod = (Start + 2592000) >= os.time()

	if (ValidPeriod and not Configpass.Active and vRP.PaymentGems(Passport,BattlepassCost)) then
		exports.discord:Embed("Battlepass",("**[PASSAPORTE]:** %s\n**[MODO]:** Comprou\n**[VALOR]:** %s"):format(Passport,BattlepassCost))
		TriggerClientEvent("pause:Notify",source,"Sucesso","Compra concluÃ­da.","verde")
		vRP.BattlepassBuy(Passport)
		Active[Passport] = nil

		return true
	end

	Active[Passport] = nil

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.VehicleBuy(Index)
	local source = source
	local Passport = vRP.Passport(source)
	local Data = ShopVehicles[Index]
	if not Passport or Active[Passport] or not Data or not Data.Model then
		return false
	end

	local Model = Data.Model
	local Consult = vRP.SelectVehicle(Passport,Model)
	if Consult and not Consult.Block then
		TriggerClientEvent("pause:Notify",source,"Aviso","JÃ¡ possui um <b>"..VehicleName(Model).."</b>.","amarelo")
		return false
	end

	local Price = parseInt(Data.Price,true)
	local Discount = tonumber(Data.Discount) or 1.0
	if Discount < 1.0 then
		Price = parseInt(Price * Discount)
	end

	if Price <= 0 then
		return false
	end

	Active[Passport] = true

	if not vRP.PaymentGems(Passport,Price) then
		TriggerClientEvent("pause:Notify",source,"AtenÃ§Ã£o","Diamante insuficiente.","amarelo")
		Active[Passport] = nil
		return false
	end

	local Days = parseInt(Data.Days,true)
	local Duration = Days > 0 and Days * 86400 or 2592000
	local Tax = os.time() + Duration

	if Consult and Consult.Block then
		exports.oxmysql:update_async("UPDATE vehicles SET Plate = ?, Weight = ?, Tax = ?, Work = ?, Block = 0 WHERE Passport = ? AND Vehicle = ?",{
			vRP.GeneratePlate(),
			VehicleWeight(Model),
			Tax,
			(VehicleMode(Model) == "Work" and 1 or 0),
			Passport,
			Model
		})
	else
		exports.oxmysql:insert_async("INSERT INTO vehicles (Passport,Vehicle,Plate,Weight,Tax,Work,Block) VALUES (@Passport,@Vehicle,@Plate,@Weight,@Tax,@Work,@Block)",{
			Passport = Passport,
			Vehicle = Model,
			Plate = vRP.GeneratePlate(),
			Weight = VehicleWeight(Model),
			Tax = Tax,
			Work = (VehicleMode(Model) == "Work" and 1 or 0),
			Block = 0
		})
	end

	if Days > 0 then
		exports.crons:Insert(Passport,"RemoveVehicle",Duration,{ Model = Model })
	end

	exports.discord:Embed("Vehicles","**[PASSAPORTE]:** "..Passport.."\n**[COMPROU]:** "..Model.."\n**[VALOR]:** "..Dotted(Price).."\n**[DURAÃ‡ÃƒO]:** "..(Days > 0 and CompleteTimers(Duration) or "Permanente"))
	TriggerClientEvent("pause:Notify",source,"Sucesso","Compra concluÃ­da.","verde")
	Active[Passport] = nil

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENBOX
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OpenBox(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] or PlayerBox[Passport] then
		return false
	end

	local Box = Boxes[Number]
	if not Box then
		return false
	end

	Active[Passport] = true

	local Price = Box.Price
	if Box.Discount and Box.Discount < 1.0 then
		Price = Price * Box.Discount
	end

	if not vRP.PaymentGems(Passport,Price) then
		Active[Passport] = nil
		return false
	end

	local Reward = RandPercentage(Box.Rewards)
	if not Reward then
		Active[Passport] = nil
		return false
	end

	PlayerBox[Passport] = Reward

	SetTimeout(6000,function()
		local CurrentReward = PlayerBox[Passport]
		if not CurrentReward then
			Active[Passport] = nil
			return false
		end

		local RewardData = Box.Rewards[CurrentReward.Id]
		if RewardData then
			exports.discord:Embed("Boxes","**[PASSAPORTE]:** "..Passport.."\n**[CAIXA]:** "..Box.Name.."\n**[PRÃŠMIO]:** "..RewardData.Amount.."x "..RewardData.Item)
			vRP.GenerateItem(Passport,RewardData.Item,RewardData.Amount)
		end

		PlayerBox[Passport] = nil
		Active[Passport] = nil
	end)

	return Reward.Id
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Marketplace()
	local Result = {}
	local ToRemove = {}
	local Changed = false
	local CurrentTimer = os.time()
	for Index,v in pairs(Marketplace) do
		if not v or not v.item or not v.timer then
			ToRemove[#ToRemove + 1] = Index
			goto Continue
		end

		if v.timer <= CurrentTimer then
			if v.passport and vRP.Source(v.passport) and not vRP.MaxItens(v.passport,v.item,v.quantity) and vRP.CheckWeight(v.passport,v.item,v.quantity) and vRP.GiveItem(v.passport,v.item,v.quantity) then
				ToRemove[#ToRemove + 1] = Index
			end
			goto Continue
		end

		local Item = v.item
		if not ItemExist(Item) then
			ToRemove[#ToRemove + 1] = Index
			goto Continue
		end

		local Data = {
			Index = Index,
			Price = v.price or 0,
			Amount = v.quantity or 0,
			Passport = v.passport,
			Name = ItemName(Item),
			Image = v.key
		}

		local Split = splitString(Item)
		local Extra = Split and Split[2]
		if Extra then
			local Loaded = ItemLoads(Item)
			if Loaded and Loaded > 0 then
				Data.Charges = parseInt(Extra * (100 / Loaded))
			end

			local Durability = ItemDurability(Item)
			if Durability then
				local Elapsed = CurrentTimer - Extra
				local Remaining = Durability - Elapsed

				Data.Durability = parseInt(math.max(Remaining,0))
				Data.Days = Durability
			end
		end

		Result[#Result + 1] = Data

		::Continue::
	end

	for Number = 1,#ToRemove do
		Marketplace[ToRemove[Number]] = nil
		Changed = true
	end

	if Changed then
		vRP.Query("entitydata/SetData",{ Name = "Marketplace", Information = json.encode(Marketplace) })
	end

	return Result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACEINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceInventory(Mode)
	local source = source
	local Passport = vRP.Passport(source)

	if not (Passport and Mode) then
		return false
	end

	local Return = {}
	local CurrentTimer = os.time()

	if Mode == "Create" then
		local Inv = vRP.Inventory(Passport)
		for Index,v in pairs(Inv) do
			if not BlockMarket(v.item) and not vRP.CheckDamaged(v.item) then
				local Table = {
					Key = v.item,
					Item = v.item,
					Index = Index,
					Amount = v.amount,
					Name = ItemName(v.item),
					Image = ItemIndex(v.item)
				}

				local Split = splitString(v.item)
				if Split[2] then
					local Loaded = ItemLoads(v.item)
					if Loaded then
						Table.Charges = parseInt(Split[2] * (100 / Loaded))
					end

					local Durability = ItemDurability(v.item)
					if Durability then
						Table.Durability = parseInt(CurrentTimer - Split[2])
						Table.Days = Durability
					end
				end

				table.insert(Return,Table)
			end
		end
	elseif Mode == "Announce" then
		for Index,v in pairs(Marketplace) do
			if Passport == v.passport then
				local Table = {
					Key = Index,
					Price = v.price,
					Amount = v.quantity,
					Name = ItemName(v.item),
					Image = v.key
				}

				local Split = splitString(v.item)
				if Split[2] then
					local Loaded = ItemLoads(v.item)
					if Loaded then
						Table.Charges = parseInt(Split[2] * (100 / Loaded))
					end

					local Durability = ItemDurability(v.item)
					if Durability then
						Table.Durability = parseInt(CurrentTimer - Split[2])
						Table.Days = Durability
					end
				end

				table.insert(Return,Table)
			end
		end
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACEANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceAnnounce(Table)
	local source = source
	if type(Table) ~= "table" then
		return false
	end

	local Item = type(Table.Item) == "string" and Table.Item
	local Price = math.floor(tonumber(Table.Price) or 0)
	local Quantity = math.floor(tonumber(Table.Amount) or 0)
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] or not Item or Price <= 0 or Price > 1000000000 or Quantity <= 0 or Quantity > 100000 or not ItemExist(Item) or BlockMarket(Item) or vRP.CheckDamaged(Item) then
		return false
	end

	Active[Passport] = true
	if not vRP.TakeItem(Passport,Item,Quantity) then
		Active[Passport] = nil
		return false
	end

	local Tax = math.floor(Price * MarketplaceTax)
	if Tax > 0 and not vRP.PaymentFull(Passport,Tax) then
		vRP.GiveItem(Passport,Item,Quantity)
		Active[Passport] = nil
		return false
	end

	do
		local Selected
		repeat
			Selected = GenerateString("DDLLDDLL")
		until Selected and not Marketplace[Selected]

		Marketplace[Selected] = {
			item = Item,
			price = Price,
			quantity = Quantity,
			passport = Passport,
			key = ItemIndex(Item),
			timer = os.time() + 259200
		}

		exports.discord:Embed("Marketplace","**[MODO]:** AnÃºncio\n**[PASSAPORTE]:** "..Passport.."\n**[ITEM]:** "..Dotted(Quantity).."x "..Item.."\n**[VALOR]:** $"..Dotted(Price))
		vRP.Query("entitydata/SetData",{ Name = "Marketplace", Information = json.encode(Marketplace) })
		Active[Passport] = nil

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACECANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceCancel(Selected)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Offer = Marketplace[Selected]
	if not Offer or Offer.passport ~= Passport or MarketplaceBusy[Selected] then
		return false
	end

	if vRP.MaxItens(Passport,Offer.item,Offer.quantity) or not vRP.CheckWeight(Passport,Offer.item,Offer.quantity) then
		return false
	end

	MarketplaceBusy[Selected] = true
	if not vRP.GiveItem(Passport,Offer.item,Offer.quantity) then
		MarketplaceBusy[Selected] = nil
		return false
	end

	exports.discord:Embed("Marketplace",("**[MODO]:** Cancelar\n**[PASSAPORTE]:** %s\n**[ITEM]:** %sx %s\n**[VALOR]:** $%s"):format(Passport,Offer.quantity,Offer.item,Offer.price))
	Marketplace[Selected] = nil
	MarketplaceBusy[Selected] = nil
	vRP.Query("entitydata/SetData",{ Name = "Marketplace", Information = json.encode(Marketplace) })

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETPLACEBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MarketplaceBuy(Selected)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and not MarketplaceBusy[Selected] and Marketplace[Selected] and Marketplace[Selected].passport and Marketplace[Selected].passport ~= Passport then
		Active[Passport] = true
		MarketplaceBusy[Selected] = true
		local Offer = Marketplace[Selected]

		if Offer.timer <= os.time() or vRP.MaxItens(Passport,Offer.item,Offer.quantity) or not vRP.CheckWeight(Passport,Offer.item,Offer.quantity) then
			TriggerClientEvent("pause:Notify",source,"AtenÃ§Ã£o","Oferta expirada, limite atingido ou espaÃ§o insuficiente.","vermelho")
			MarketplaceBusy[Selected] = nil
			Active[Passport] = nil

			return false
		end

		local Paid = vRP.PaymentFull(Passport,Offer.price)
		if Paid and vRP.GiveItem(Passport,Offer.item,Offer.quantity) then
			exports.discord:Embed("Marketplace","**[MODO]:** Compra\n**[PASSAPORTE]:** "..Passport.."\n**[VENDEDOR]:** "..Offer.passport.."\n**[ITEM]:** "..Dotted(Offer.quantity).."x "..Offer.item.."\n**[VALOR]:** $"..Dotted(Offer.price))
			TriggerClientEvent("pause:Notify",source,"Sucesso","Compra concluÃ­da.","verde")
			vRP.GiveBank(Offer.passport,Offer.price)
			Marketplace[Selected] = nil
			MarketplaceBusy[Selected] = nil
			vRP.Query("entitydata/SetData",{ Name = "Marketplace", Information = json.encode(Marketplace) })
			Active[Passport] = nil

			return true
		end

		if Paid then
			vRP.GiveBank(Passport,Offer.price)
		end

		MarketplaceBusy[Selected] = nil
		Active[Passport] = nil
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Ranking(Column,Direction)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then
		return {}
	end

	Active[Passport] = true

	Column = Column == "Death" and "Death" or "Killed"
	Direction = Direction == "ASC" and "ASC" or "DESC"

	local Ranking = {}
	local Query = string.format([[SELECT Passport,SUM(Killed) AS Killed,SUM(Death) AS Death FROM (
		SELECT Attacker AS Passport,1 AS Killed,0 AS Death FROM deaths_creative WHERE Attacker IS NOT NULL
		UNION ALL
		SELECT Victim AS Passport,0 AS Killed,1 AS Death FROM deaths_creative WHERE Victim IS NOT NULL
	) AS Statistics GROUP BY Passport ORDER BY %s %s LIMIT 50]],Column,Direction)
	local Consult = exports.oxmysql:query_async(Query)
	if Consult and #Consult > 0 then
		for _,v in ipairs(Consult) do
			local OtherPassport = parseInt(v.Passport)
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				local Killed = parseInt(v.Killed,true)
				local Death = parseInt(v.Death,true)
				Ranking[#Ranking + 1] = {
					Passport = OtherPassport,
					Name = ("%s %s"):format(Identity.Name,Identity.Lastname),
					Killed = Killed,
					Death = Death,
					Ratio = Death > 0 and (Killed / Death) or Killed,
					Hours = parseInt(vRP.Playing(OtherPassport,"Online"),true)
				}
			end
		end
	end

	Active[Passport] = nil

	return Ranking
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Statistics()
	local Result = {
		Kills = 0,
		Deaths = 0,
		Logs = {}
	}

	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return Result
	end

	local PlayerName = vRP.FullName(Passport)
	local Query = "SELECT * FROM deaths_creative WHERE Attacker = @Passport OR Victim = @Passport LIMIT 50"
	local Deaths = exports.oxmysql:query_async(Query,{ Passport = Passport })

	if not Deaths or #Deaths == 0 then
		return Result
	end

	for _,v in ipairs(Deaths) do
		local WeaponHash = tonumber(v.Weapon)
		local WeaponName = (type(WeaponNames) == "table" and WeaponNames[WeaponHash]) or tostring(v.Weapon or "Desconhecida")

		local IsKiller = v.Attacker == Passport
		local Killer = IsKiller and Passport or v.Attacker
		local Victim = IsKiller and v.Victim or Passport

		local KillerName = IsKiller and PlayerName or vRP.FullName(Killer)
		local VictimName = IsKiller and vRP.FullName(Victim) or PlayerName

		if IsKiller then
			Result.Kills = Result.Kills + 1
		else
			Result.Deaths = Result.Deaths + 1
		end

		Result.Logs[#Result.Logs + 1] = {
			Killer = { Passport = Killer, Name = KillerName },
			Victim = { Passport = Victim, Name = VictimName },
			Weapon = WeaponName,
			Date = v.Timestamp
		}
	end

	return Result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAILY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Daily()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return {}
	end

	local Identity = vRP.Identity(Passport)
	if not Identity or not Identity.Daily then
		return {}
	end

	local Consult = splitString(Identity.Daily)
	return { string.format("%s-%s-%s",Consult[1],Consult[2],Consult[3]),parseInt(Consult[4]),#Daily }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAILYRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DailyRescue(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not Daily[Number] or Active[Passport] then
		return false
	end

	local Identity = vRP.Identity(Passport)
	if not Identity or not Identity.Daily then
		return false
	end

	Active[Passport] = true

	local Date = os.date("%d-%m-%Y")
	local SplitDate,SplitCurrent = splitString(Date),splitString(Identity.Daily)
	local CurrentDay = os.time({ day = SplitDate[1], month = SplitDate[2], year = SplitDate[3] })
	local LastedDay = os.time({ day = SplitCurrent[1], month = SplitCurrent[2], year = SplitCurrent[3] })

	if CurrentDay > LastedDay and Number > parseInt(SplitCurrent[4]) then
		for Item,Amount in pairs(Daily[Number]) do
			if type(Amount) == "table" then
				GiveConfiguredReward(Passport,Amount)
			else
				vRP.GenerateItem(Passport,Item,Amount)
			end
		end

		exports.discord:Embed("Daily","**[PASSAPORTE]:** "..Passport.."\n**[DIA]:** "..Number)
		TriggerClientEvent("pause:Notify",source,"Sucesso","Recompensa recebida.","verde")
		vRP.UpdateDaily(Passport,source,string.format("%s-%d",Date,Number))
	end

	Active[Passport] = nil

	return CurrentDay > LastedDay and Number > tonumber(SplitCurrent[4])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CODE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Code(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then
		return false
	end

	Active[Passport] = true

	local ConsultCodes = exports.oxmysql:single_async("SELECT * FROM codes_creative WHERE Code = ? LIMIT 1",{ Name })
	if not ConsultCodes then
		TriggerClientEvent("pause:Notify",source,"Aviso","CÃ³digo invÃ¡lido.","amarelo")
		Active[Passport] = nil
		return false
	end

	if ConsultCodes.Max > 0 and ConsultCodes.Used >= ConsultCodes.Max then
		TriggerClientEvent("pause:Notify",source,"Aviso","Limite de resgate atingido.","amarelo")
		Active[Passport] = nil
		return false
	end

	local ConsultRedemptions = exports.oxmysql:single_async("SELECT 1 FROM codes_creative_redeemd WHERE Code = ? AND Passport = ? LIMIT 1",{ Name,Passport })
	if ConsultRedemptions then
		TriggerClientEvent("pause:Notify",source,"Aviso","CÃ³digo jÃ¡ resgatado.","amarelo")
		Active[Passport] = nil
		return false
	end

	local Rewards = json.decode(ConsultCodes.Rewards or "[]")
	for _,v in ipairs(Rewards) do
		if v.Item and ItemExist(v.Item) and v.Amount and v.Amount > 0 then
			vRP.GenerateItem(Passport,v.Item,v.Amount)
		end
	end

	exports.oxmysql:transaction_async({
		{
			query = "INSERT INTO codes_creative_redeemd (Code,Passport,RedeemdAt) VALUES (?,?,?)", values = { Name,Passport,os.time() }
		},{
			query = "UPDATE codes_creative SET Used = Used + 1 WHERE Code = ?", values = { Name }
		}
	})

	TriggerClientEvent("pause:Notify",source,"ParabÃ©ns","CÃ³digo resgatado com sucesso.","verde")
	Active[Passport] = nil

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WIPEBATTLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("pause:WipeBattlepass",function(CurrentTimer)
	BattleStart = CurrentTimer
	TriggerClientEvent("pause:UpdateConfig",-1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if PlayerBox[Passport] then
		PlayerBox[Passport] = nil
	end

	if Active[Passport] then
		Active[Passport] = nil
	end

	if Salarys[Passport] then
		Salarys[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaveServer",function(Silenced)
	vRP.Query("entitydata/SetData",{ Name = "Marketplace", Information = json.encode(Marketplace) })

	if not Silenced then
		print("O resource ^2Pause^7 salvou os dados.")
	end
end)

