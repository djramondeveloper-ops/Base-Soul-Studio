-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local AmmoMax = -1
local AmmoMin = -1
local Active = false
local LastWeaponHash = nil
local LastTotalAmmo = -1
local WasReloading = false
local TrackedClipAmmo = -1

local function ResolveWeaponHash(Ped,Name)
	local SelectedWeapon = GetSelectedPedWeapon(Ped)
	if SelectedWeapon and SelectedWeapon ~= 0 and SelectedWeapon ~= GetHashKey("WEAPON_UNARMED") then
		return SelectedWeapon
	end

	if type(Name) == "number" then
		return Name
	end

	if type(Name) == "string" and Name ~= "" then
		local Hash = GetHashKey(Name)
		if Hash and Hash ~= 0 then
			return Hash
		end
	end

	return GetSelectedPedWeapon(Ped)
end

local function ResetWeaponTracker()
	LastWeaponHash = nil
	LastTotalAmmo = -1
	WasReloading = false
	TrackedClipAmmo = -1
end

local function ResolveClipAmmo(Ped,WeaponHash,TotalAmmo)
	local Success,ClipAmmo = GetAmmoInClip(Ped,WeaponHash)
	local MaxClip = GetMaxAmmoInClip(Ped,WeaponHash,true) or 0
	local Reloading = IsPedReloading(Ped)

	if WeaponHash ~= LastWeaponHash then
		LastWeaponHash = WeaponHash
		LastTotalAmmo = -1
		WasReloading = false
		TrackedClipAmmo = -1
	end

	if Success and type(ClipAmmo) == "number" and ClipAmmo > 0 then
		TrackedClipAmmo = ClipAmmo
	elseif MaxClip > 0 and TotalAmmo > 0 then
		if TrackedClipAmmo < 0 then
			TrackedClipAmmo = math.min(TotalAmmo,MaxClip)
		end

		if WasReloading and not Reloading then
			TrackedClipAmmo = math.min(TotalAmmo,MaxClip)
		elseif LastTotalAmmo >= 0 then
			if TotalAmmo < LastTotalAmmo then
				TrackedClipAmmo = math.max(TrackedClipAmmo - (LastTotalAmmo - TotalAmmo),0)
			elseif TotalAmmo > LastTotalAmmo and TrackedClipAmmo > TotalAmmo then
				TrackedClipAmmo = TotalAmmo
			end
		end

		ClipAmmo = math.max(math.min(TrackedClipAmmo,TotalAmmo),0)
	else
		ClipAmmo = type(ClipAmmo) == "number" and ClipAmmo or 0
	end

	LastTotalAmmo = TotalAmmo
	WasReloading = Reloading

	return ClipAmmo
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:Weapon",function(Status,Name)
	if Status then
		Active = true

		while Active do
			local Ped = PlayerPedId()
			local WeaponHash = ResolveWeaponHash(Ped,Name)
			local Max = GetAmmoInPedWeapon(Ped,WeaponHash)
			local Min = ResolveClipAmmo(Ped,WeaponHash,Max)

			if AmmoMax ~= Max or AmmoMin ~= Min then
				AmmoMax = Max
				AmmoMin = Min

				if (Max - Min) <= 0 then
					Max = 0
				else
					Max = Max - Min
				end

				SendNUIMessage({ Action = "Weapons", Payload = { Name = ItemName(Name), Current = Min, Stored = Max } })
			end

			Wait(100)
		end
	else
		SendNUIMessage({ Action = "Weapons" })
		Active = false
		AmmoMax = -1
		AmmoMin = -1
		ResetWeaponTracker()
	end
end)
