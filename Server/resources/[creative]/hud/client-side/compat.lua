-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD COMPAT
-- Mantem contratos legados da base enquanto a HUD visual fica no 0r-hud-v3.
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

Creative = {}
Tunnel.bindInterface("hud",Creative)

Radar = false

local Hunger = 100
local Thirst = 100
local Stress = 0
local HungerAmount = 90000
local ThirstAmount = 90000
local HungerDelay = GetGameTimer() + HungerAmount
local ThirstDelay = GetGameTimer() + ThirstAmount
local HungerTimer = GetGameTimer()
local ThirstTimer = GetGameTimer()
local StressTimer = GetGameTimer()
local Wanted = 0
local Repose = 0
local Gemstone = 0
local Hood = false

local function loaded()
	return LocalPlayer and LocalPlayer["state"] and LocalPlayer["state"]["Active"]
end

CreateThread(function()
	while true do
		local sleep = 1000
		if loaded() then
			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 100 then
				if Hunger <= 10 and HungerTimer <= GetGameTimer() then
					ApplyDamageToPed(ped,1,false)
					HungerTimer = GetGameTimer() + 60000
					TriggerEvent("Notify","Alimentacao","Sofrendo com a <b>fome</b>.","fome",5000)
				end

				if Thirst <= 10 and ThirstTimer <= GetGameTimer() then
					ApplyDamageToPed(ped,1,false)
					ThirstTimer = GetGameTimer() + 60000
					TriggerEvent("Notify","Hidratacao","Sofrendo com a <b>sede</b>.","sede",5000)
				end

				if Stress ~= 999 and Stress >= 50 and StressTimer <= GetGameTimer() then
					AnimpostfxPlay("MenuMGIn")
					SetTimeout(1000,function()
						AnimpostfxStop("MenuMGIn")
					end)
					StressTimer = GetGameTimer() + 30000
				end

				if Hunger > 0 and HungerDelay <= GetGameTimer() then
					Hunger = Hunger - 1
					if vRPS and vRPS.DowngradeHunger then vRPS.DowngradeHunger() end
					HungerDelay = GetGameTimer() + HungerAmount
				end

				if Thirst > 0 and ThirstDelay <= GetGameTimer() then
					Thirst = Thirst - 1
					if vRPS and vRPS.DowngradeThirst then vRPS.DowngradeThirst() end
					ThirstDelay = GetGameTimer() + ThirstAmount
				end
			end
		end
		Wait(sleep)
	end
end)

RegisterNetEvent("hud:Radar")
AddEventHandler("hud:Radar",function()
	Radar = not Radar
	TriggerEvent("inventory:Notify","Sucesso","Mapa adaptativo "..(Radar and "ativado" or "desativado")..".","verde")
end)

RegisterNetEvent("hud:Radaroff")
AddEventHandler("hud:Radaroff",function()
	Radar = false
end)

RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst",function(Number)
	Thirst = tonumber(Number) or Thirst
end)

RegisterNetEvent("hud:Hunger")
AddEventHandler("hud:Hunger",function(Number)
	Hunger = tonumber(Number) or Hunger
end)

RegisterNetEvent("hud:Stress")
AddEventHandler("hud:Stress",function(Number)
	Stress = tonumber(Number) or Stress
end)

RegisterNetEvent("hud:Wanted")
AddEventHandler("hud:Wanted",function(Seconds)
	Wanted = tonumber(Seconds) or 0
end)

RegisterNetEvent("hud:Repose")
AddEventHandler("hud:Repose",function(Seconds)
	Repose = tonumber(Seconds) or 0
end)

RegisterNetEvent("hud:AddGemstone")
AddEventHandler("hud:AddGemstone",function(Number)
	Gemstone = Gemstone + (tonumber(Number) or 0)
end)

RegisterNetEvent("hud:RemoveGemstone")
AddEventHandler("hud:RemoveGemstone",function(Number)
	Gemstone = Gemstone - (tonumber(Number) or 0)
	if Gemstone < 0 then Gemstone = 0 end
end)

AddEventHandler("Hunger",function(Value)
	HungerAmount = tonumber(Value) or HungerAmount
end)

AddEventHandler("Thirst",function(Value)
	ThirstAmount = tonumber(Value) or ThirstAmount
end)

RegisterNetEvent("hud:Hood")
AddEventHandler("hud:Hood",function()
	Hood = not Hood
	if Hood then
		SetPedComponentVariation(PlayerPedId(),1,69,0,1)
	else
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end
end)

RegisterNetEvent("hud:RemoveHood")
AddEventHandler("hud:RemoveHood",function()
	if Hood then
		Hood = false
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end
end)

AddEventHandler("hud:Active",function() end)
AddEventHandler("hud:Active2",function() end)
AddEventHandler("hud:LogoOnly",function() end)
AddEventHandler("hud:Weapon",function() end)
AddEventHandler("hud:Menu",function() end)
AddEventHandler("hud:Video",function() end)
AddEventHandler("hud:setFrequency",function() end)
AddEventHandler("hud:LocationOverride",function() end)
AddEventHandler("Progress",function() end)

exports("Wanted",function()
	return Wanted > 0
end)

exports("Repose",function()
	return Repose > 0
end)
