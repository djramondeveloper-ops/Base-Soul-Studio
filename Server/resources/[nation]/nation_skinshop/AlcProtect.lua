local Tunnel = module("vrp", "lib/Tunnel")
Alc = Tunnel.getInterface("Alc_Protect")

local ProhibitedVariables = {
"fESX", "Plane", "TiagoMenu", "Outcasts666", "dexMenu", "Cience", "LynxEvo", "zzzt", "AKTeam",
"gaybuild", "ariesMenu", "WarMenu", "SwagMenu", "Dopamine", "Gatekeeper", "MIOddhwuie", "HydroMenu"
}

CreateThread(function()
    while true do
        Wait(1000)
        for i, v in pairs(ProhibitedVariables) do
            if _G[v] ~= nil then
                Alc.banplayer("Mod Menu Variable\nVariable Info: "..v.."")
            end
        end
        local DetectableTextures = {
			{txd = "HydroMenu", txt = "HydroMenuHeader", name = "HydroMenu"},
			{txd = "mpmissmarkers256", txt = "mpmissmarkers256", name = "DrawFov"},
			{txd = "John", txt = "John2", name = "SugarMenu"},
			{txd = "darkside", txt = "logo", name = "Darkside"},
			{txd = "ISMMENU", txt = "ISMMENUHeader", name = "ISMMENU"},
			{txd = "dopatest", txt = "duiTex", name = "Copypaste Menu"},
			{txd = "fm", txt = "menu_bg", name = "Fallout"},
			{txd = "wave", txt = "logo", name ="Wave"},
			{txd = "wave1", txt = "logo1", name = "Wave (alt.)"},
			{txd = "meow2", txt = "woof2", name ="Alokas66", x = 1000, y = 1000},
			{txd = "adb831a7fdd83d_Guest_d1e2a309ce7591dff86", txt = "adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6", name ="Guest Menu"},
			{txd = "hugev_gif_DSGUHSDGISDG", txt = "duiTex_DSIOGJSDG", name="HugeV Menu"},
			{txd = "MM", txt = "menu_bg", name="MetrixFallout"},
			{txd = "MM", txt = "menu_bg", name="MetrixFallout"},
			{txd = "aries ~n~~r~MENU", txt = "aries ~n~~r~MENU", name="Aries Menu"},
			{txd = "wm", txt = "wm2", name="WM Menu"}
			
		}
		
		for i, data in pairs(DetectableTextures) do
			if data.x and data.y then
				if GetTextureResolution(data.txd, data.txt).x == data.x and GetTextureResolution(data.txd, data.txt).y == data.y then
					Alc.banplayer("Mod Menu\nMod Info: "..data.name.."")
				end
			else 
				if GetTextureResolution(data.txd, data.txt).x ~= 4.0 then
					Alc.banplayer("Mod Menu\nMod Info: "..data.name.."")
				end
			end
		end
    end
end)

AddEventHandler("onClientResourceStop", function(rsc)
	local source = source
	if source ~= 0 then
		if rsc == "Alc_Protect" then
			local source = source
			if source ~= 0 and source ~= -1 then
				Alc.banplayer("Stop AntiCheat")
				CancelEvent()
			end
		end
	end
end)

SetPedDefaultComponentVariation = function()
	Alc.logplayer("SetPedDefaultComponentVariation Detected. (Maybe Random Clothes)\nType: 1")
end
_G.SetPedDefaultComponentVariation = function()
	Alc.logplayer("SetPedDefaultComponentVariation Detected. (Maybe Random Clothes)\nType: 1")
end

SetPedRandomComponentVariation = function()
	Alc.logplayer("SetPedRandomComponentVariation Detected. (Maybe Random Clothes)\nType: 2")
end
_G.SetPedRandomComponentVariation = function()
	Alc.logplayer("SetPedRandomComponentVariation Detected. (Maybe Random Clothes)\nType: 2")
end