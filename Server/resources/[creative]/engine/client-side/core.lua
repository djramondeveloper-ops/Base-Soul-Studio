-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("engine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local VehicleBrakes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BRAKESTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			if GetVehiclePedIsTryingToEnter(Ped) > 0 then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if NetworkGetEntityIsNetworked(Vehicle) then
					local Network = NetworkGetNetworkIdFromEntity(Vehicle)
					if GetVehicleClass(Vehicle) ~= 14 and GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16 and GetVehicleClass(Vehicle) ~= 21 then
						VehicleBrakes[Network] = vSERVER.VehicleBrakes(Network)

						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce",VehicleBrakes[Network][1])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront",VehicleBrakes[Network][2])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce",VehicleBrakes[Network][3])
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,Message)
	if Event == "CEventNetworkPlayerEnteredVehicle" and Message[1] == PlayerId() then
		local Ped = PlayerPedId()
		local Vehicle = Message[2]
		SetPedConfigFlag(Ped,35,false)

		if not IsPedInAnyHeli(Ped) then
			TriggerEvent("inventory:CleanWeapons")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSUMEBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			local Vehicle = GetVehiclePedIsUsing(Ped)
			if GetVehicleClass(Vehicle) ~= 14 and GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16 and GetVehicleClass(Vehicle) ~= 21 then
				local Speed = GetEntitySpeed(Vehicle) * VehicleSpeed
				if Speed >= 1 and NetworkGetEntityIsNetworked(Vehicle) then
					local Network = NetworkGetNetworkIdFromEntity(Vehicle)

					if VehicleBrakes[Network] == nil then
						VehicleBrakes[Network] = vSERVER.VehicleBrakes(Network)

						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce",VehicleBrakes[Network][1])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront",VehicleBrakes[Network][2])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce",VehicleBrakes[Network][3])
					end

					if GetPedInVehicleSeat(Vehicle,-1) == Ped then
						if IsPedOnAnyBike(Ped) then
							local BrakeStatus = GetVehicleWheelBrakePressure(Vehicle,0)

							if BrakeStatus ~= 0.0 then
								BrakeUpdate(Vehicle,Network)
							end
						else
							local BrakeStatus = GetVehicleWheelBrakePressure(Vehicle,0)
							local OtherBrakeStatus = GetVehicleWheelBrakePressure(Vehicle,2)

							if BrakeStatus ~= 0.0 or OtherBrakeStatus ~= 0.0 then
								BrakeUpdate(Vehicle,Network)
							end
						end
					end
				end
			end
		end

		Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BRAKEUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function BrakeUpdate(Vehicle,Network)
	local BrakeForceFloat = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce")
	local BrakeFrontFloat = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront")
	local BrakeHandFloat = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce")

	local ForceFloat = BrakeForceFloat - (0.90 * 0.0015)
	local FrontFloat = BrakeFrontFloat - (0.55 * 0.0030)
	local HandFloat = BrakeHandFloat - (0.75 * 0.0030)

	if ForceFloat <= 0.0900 then ForceFloat = 0.0900 end
	if FrontFloat <= 0.0550 then FrontFloat = 0.0550 end
	if HandFloat <= 0.0750 then HandFloat = 0.0750 end

	local PlayersAround = {}
	for _,Player in ipairs(GetActivePlayers()) do
		PlayersAround[#PlayersAround + 1] = GetPlayerServerId(Player)
	end

	TriggerServerEvent("engine:TryBrakes",Network,{ ForceFloat,FrontFloat,HandFloat },PlayersAround)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:SYNCBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:SyncBrakes")
AddEventHandler("engine:SyncBrakes",function(Network,Result)
	VehicleBrakes[Network] = Result

	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce",VehicleBrakes[Network][1])
			SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront",VehicleBrakes[Network][2])
			SetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce",VehicleBrakes[Network][3])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:VEHRIFY
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("engine:Vehrify",function(Entitys)
	local Vehicle = Entitys[3]

	local VehicleBrakes = vSERVER.VehicleBrakes(NetworkGetNetworkIdFromEntity(Vehicle))
	exports.dynamic:AddMenu("Freios","Verificar os freios do veículo.","brakes")
	local BrakeForce = Dotted((VehicleBrakes[1] * 10000) / 90)
	exports.dynamic:AddButton("Integral",("O <rare>Freio Integral</rare> se encontra em <rare>%d%%</rare>."):format(BrakeForce),"","","brakes",false)
	local BrakeFront = Dotted((VehicleBrakes[2] * 10000) / 55)
	exports.dynamic:AddButton("Dianteiro",("O <rare>Freio Dianteiro</rare> se encontra em <rare>%d%%</rare>."):format(BrakeFront),"","","brakes",false)
	local BrakeHands = Dotted((VehicleBrakes[3] * 10000) / 75)
	exports.dynamic:AddButton("Traseiro",("O <rare>Freio Traseiro</rare> se encontra em <rare>%d%%</rare>."):format(BrakeHands),"","","brakes",false)


	local Mods = {
		{ Number = 11, Name = "Motor" },
		{ Number = 12, Name = "Freios" },
		{ Number = 13, Name = "Transmissão" },
		{ Number = 15, Name = "Suspensão" },
		{ Number = 16, Name = "Blindagem" }
	}

	for _,v in ipairs(Mods) do
		local CurrentMod = GetVehicleMod(Vehicle,v.Number)
		if CurrentMod ~= -1 then
			local Total = GetNumVehicleMods(Vehicle,v.Number)
			exports.dynamic:AddButton(v.Name,("Modificação atual instalada: <rare>%d</rare> / %d"):format(CurrentMod + 1,Total),"","",false,false)
		end
	end

	local Force = Dotted(GetVehicleEngineHealth(Vehicle) / 10)
	exports.dynamic:AddButton("Potência",("Potência do motor se encontra em <rare>%d%%</rare>."):format(Force),"","",false,false)

	local Body = Dotted(GetVehicleBodyHealth(Vehicle) / 10)
	exports.dynamic:AddButton("Lataria",("Qualidade da lataria se encontra em <rare>%d%%</rare>."):format(Body),"","",false,false)

	local Health = Dotted(GetEntityHealth(Vehicle) / 10)
	exports.dynamic:AddButton("Chassi",("Rigidez do chassi se encontra em <rare>%d%%</rare>."):format(Health),"","",false,false)

	if Entity(Vehicle).state.Lockpick then
		exports.dynamic:AddButton("Numeração","O veículo possui a numeração <epic>Adulterada</epic>.","","",false,false)
	else
		exports.dynamic:AddButton("Numeração","O veículo possui a numeração <common>Original</common>.","","",false,false)
	end

	exports.dynamic:Open()
end)