-- SEOUL SCRIPTS - COMPAT VRP (SEM REPETIR ITENS QUE JA EXISTEM NA BASE)
-- Cole somente as entradas abaixo dentro do local List em: Server/resources/[core]/vrp/config/Item.lua
-- Itens pulados porque ja existem na base: rope, camera, binoculars

	["skate"] = {
		["Index"] = "skate",
		["Name"] = "Skate",
		["Description"] = "Skate portátil.",
		["Type"] = "Comum",
		["Weight"] = 1.00,
		["Market"] = false,
		["Delete"] = true,
		["Execute"] = {
			["Type"] = "Client",
			["Event"] = "skate"
		},
	},

	["WEAPON_FLASHBANG"] = {
		["Index"] = "WEAPON_FLASHBANG",
		["Name"] = "Flashbang",
		["Description"] = "Granada de luz e concussão.",
		["Type"] = "Arma",
		["Weight"] = 0.60,
		["Market"] = false,
		["Delete"] = true,
	},
