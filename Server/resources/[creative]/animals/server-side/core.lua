-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Animal = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS:REGISTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("animals:Register")
AddEventHandler("animals:Register",function(Network)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not Network then
		return
	end

	if Animal[Passport] then
		-- Defesa server-side: se algum segundo spawn atravessar o client lock,
		-- remove a entidade nova e mantém apenas o pet já registrado.
		if Animal[Passport] ~= Network then
			TriggerEvent("DeletePed",Network)
		end
		return
	end

	Animal[Passport] = Network
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS:CLEARNER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("animals:Cleaner")
AddEventHandler("animals:Cleaner",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Animal[Passport] then
		TriggerEvent("DeletePed",Animal[Passport])
		Animal[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("animals:Delete",function(source,Passport)
	if Animal[Passport] then
		TriggerClientEvent("animals:Delete",source)
		TriggerEvent("DeletePed",Animal[Passport])
		Animal[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Animal[Passport] then
		TriggerEvent("DeletePed",Animal[Passport])
		Animal[Passport] = nil
	end
end)