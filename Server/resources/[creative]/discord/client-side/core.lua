-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
	SetDiscordAppId(1367324225949663322)
	SetDiscordRichPresenceAsset("seoul")
	SetRichPresence("#"..Passport.." "..Name)
	SetDiscordRichPresenceAssetText("seoul")
	SetDiscordRichPresenceAssetSmall("seoul")
	SetDiscordRichPresenceAssetSmallText("seoul")
	SetDiscordRichPresenceAction(0,"Site","https://discord.gg/tmkndB8rVT")
end)