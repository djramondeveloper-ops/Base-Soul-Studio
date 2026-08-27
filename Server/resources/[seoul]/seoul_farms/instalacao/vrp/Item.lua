-- SEOUL FARMS - COMPAT VRP (SEM REPETIR ITENS QUE JA EXISTEM NA BASE)
-- Cole somente as entradas abaixo dentro do local List em: Server/resources/[core]/vrp/config/Item.lua
-- Itens pulados porque ja existem na base: cocaine, meth, copper, aluminum, glass, dirtydollar, dollar

	["cocaempo"] = {
		["Index"] = "cocaempo",
		["Name"] = "Coca em Pó",
		["Description"] = "Matéria-prima da farm de cocaína.",
		["Type"] = "Material",
		["Weight"] = 0.02,
		["Market"] = false,
		["Delete"] = true,
	},

	["pastadecoca"] = {
		["Index"] = "pastadecoca",
		["Name"] = "Pasta de Coca",
		["Description"] = "Pasta processada para produção de cocaína.",
		["Type"] = "Material",
		["Weight"] = 0.03,
		["Market"] = false,
		["Delete"] = true,
	},

	["folhademaconha"] = {
		["Index"] = "folhademaconha",
		["Name"] = "Folha de Maconha",
		["Description"] = "Matéria-prima da farm de maconha.",
		["Type"] = "Material",
		["Weight"] = 0.01,
		["Market"] = false,
		["Delete"] = true,
	},

	["maconhamacerada"] = {
		["Index"] = "maconhamacerada",
		["Name"] = "Maconha Macerada",
		["Description"] = "Maconha preparada para embalagem.",
		["Type"] = "Material",
		["Weight"] = 0.02,
		["Market"] = false,
		["Delete"] = true,
	},

	["weed"] = {
		["Index"] = "weed",
		["Name"] = "Maconha",
		["Description"] = "Produto final da farm de maconha.",
		["Type"] = "Droga",
		["Weight"] = 0.02,
		["Market"] = false,
		["Delete"] = true,
	},

	["acidobateria"] = {
		["Index"] = "acidobateria",
		["Name"] = "Ácido de Bateria",
		["Description"] = "Ingrediente da farm de metanfetamina.",
		["Type"] = "Material",
		["Weight"] = 0.10,
		["Market"] = false,
		["Delete"] = true,
	},

	["methliquid"] = {
		["Index"] = "methliquid",
		["Name"] = "Metanfetamina Líquida",
		["Description"] = "Metanfetamina em fase líquida.",
		["Type"] = "Material",
		["Weight"] = 0.03,
		["Market"] = false,
		["Delete"] = true,
	},

	["ecstasy"] = {
		["Index"] = "ecstasy",
		["Name"] = "Ecstasy",
		["Description"] = "Item de venda de drogas.",
		["Type"] = "Droga",
		["Weight"] = 0.01,
		["Market"] = false,
		["Delete"] = true,
	},

	["lean"] = {
		["Index"] = "lean",
		["Name"] = "Lean",
		["Description"] = "Item de venda de drogas.",
		["Type"] = "Droga",
		["Weight"] = 0.15,
		["Market"] = false,
		["Delete"] = true,
	},

	["lsd"] = {
		["Index"] = "lsd",
		["Name"] = "LSD",
		["Description"] = "Item de venda de drogas.",
		["Type"] = "Droga",
		["Weight"] = 0.01,
		["Market"] = false,
		["Delete"] = true,
	},

	["detonador"] = {
		["Index"] = "detonador",
		["Name"] = "Detonador",
		["Description"] = "Item opcional para serviços de desmanche.",
		["Type"] = "Ferramenta",
		["Weight"] = 0.25,
		["Market"] = false,
		["Delete"] = true,
	},
