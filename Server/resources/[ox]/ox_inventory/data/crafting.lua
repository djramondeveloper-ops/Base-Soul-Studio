--[[
    Seoul OX Crafting
    Gerado a partir de [scripts]/crafting/shared-side/shared.lua.
    O target continua chamando crafting:Open; o client abre este bench no ox_inventory.
]]
return {
	['seoul_crafting_DrinkBurgerShot'] = {
		name = 'seoul_crafting_DrinkBurgerShot',
		label = 'DrinkBurgerShot',
		items = {
			{
				name = 'acerolajuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['acerola'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'applejuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['apple'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'bananajuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['banana'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'blueberryjuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['blueberry'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'cappuccino',
				count = 1,
				duration = 5000,
				ingredients = {
					['chocolate'] = 1,
					['coffee'] = 1,
					['milkbottle'] = 1,
				}
			},
			{
				name = 'grapejuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['grape'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'lemonjuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['lemon'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'milkshake',
				count = 1,
				duration = 5000,
				ingredients = {
					['milkbottle'] = 1,
					['strawberry'] = 1,
				}
			},
			{
				name = 'orangejuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['orange'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'passionjuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['passion'] = 2,
					['water'] = 1,
				}
			},
			{
				name = 'strawberryjuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['strawberry'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'tangejuice',
				count = 1,
				duration = 5000,
				ingredients = {
					['tange'] = 1,
					['water'] = 1,
				}
			},
		}
	},
	['seoul_crafting_Essence'] = {
		name = 'seoul_crafting_Essence',
		label = 'Essence',
		items = {
			{
				name = 'green_essence',
				count = 1,
				duration = 5000,
				ingredients = {
					['purple_essence'] = 10,
				}
			},
			{
				name = 'pink_essence',
				count = 1,
				duration = 5000,
				ingredients = {
					['red_essence'] = 10,
				}
			},
			{
				name = 'purple_essence',
				count = 1,
				duration = 5000,
				ingredients = {
					['blue_essence'] = 10,
				}
			},
			{
				name = 'red_essence',
				count = 1,
				duration = 5000,
				ingredients = {
					['green_essence'] = 10,
				}
			},
		}
	},
	['seoul_crafting_FoodBurgerShot'] = {
		name = 'seoul_crafting_FoodBurgerShot',
		label = 'FoodBurgerShot',
		items = {
			{
				name = 'applelove',
				count = 2,
				duration = 5000,
				ingredients = {
					['apple'] = 1,
					['sugarbox'] = 1,
				}
			},
			{
				name = 'cookies',
				count = 3,
				duration = 5000,
				ingredients = {
					['chocolate'] = 1,
					['milkbottle'] = 1,
					['sugarbox'] = 1,
				}
			},
			{
				name = 'cupcake',
				count = 3,
				duration = 5000,
				ingredients = {
					['chocolate'] = 1,
					['milkbottle'] = 1,
					['sugarbox'] = 1,
				}
			},
			{
				name = 'hamburger',
				count = 1,
				duration = 5000,
				ingredients = {
					['mayonnaise'] = 1,
					['meatfillet'] = 1,
					['ryebread'] = 1,
				}
			},
			{
				name = 'hamburger2',
				count = 1,
				duration = 5000,
				ingredients = {
					['mayonnaise'] = 1,
					['meatfillet'] = 1,
					['ryebread'] = 1,
				}
			},
			{
				name = 'hamburger3',
				count = 1,
				duration = 5000,
				ingredients = {
					['mayonnaise'] = 1,
					['meatfillet'] = 1,
					['ryebread'] = 1,
				}
			},
			{
				name = 'hotdog',
				count = 1,
				duration = 5000,
				ingredients = {
					['mayonnaise'] = 1,
					['meatfillet'] = 1,
					['ryebread'] = 1,
				}
			},
			{
				name = 'nigirizushi',
				count = 3,
				duration = 5000,
				ingredients = {
					['fishfillet'] = 3,
					['ricebag'] = 1,
				}
			},
			{
				name = 'pizzabanana',
				count = 1,
				duration = 5000,
				ingredients = {
					['banana'] = 1,
					['milkbottle'] = 1,
					['ryebread'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'pizzachocolate',
				count = 1,
				duration = 5000,
				ingredients = {
					['chocolate'] = 1,
					['milkbottle'] = 1,
					['ryebread'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'pizzamozzarella',
				count = 1,
				duration = 5000,
				ingredients = {
					['milkbottle'] = 1,
					['ryebread'] = 1,
					['tomato'] = 1,
					['water'] = 1,
				}
			},
			{
				name = 'sushi',
				count = 2,
				duration = 5000,
				ingredients = {
					['fishfillet'] = 2,
					['sugarbox'] = 1,
				}
			},
		}
	},
	['seoul_crafting_Furnace'] = {
		name = 'seoul_crafting_Furnace',
		label = 'Furnace',
		items = {
			{
				name = 'aluminum',
				count = 5,
				duration = 5000,
				ingredients = {
					['bauxite'] = 1,
				}
			},
			{
				name = 'copper',
				count = 5,
				duration = 5000,
				ingredients = {
					['chalcopyrite'] = 1,
				}
			},
			{
				name = 'glass',
				count = 5,
				duration = 5000,
				ingredients = {
					['sand'] = 1,
				}
			},
			{
				name = 'latex',
				count = 1,
				duration = 5000,
				ingredients = {
					['emptybottle'] = 1,
					['woodlog'] = 5,
				}
			},
			{
				name = 'plastic',
				count = 25,
				duration = 5000,
				ingredients = {
					['WEAPON_PETROLCAN_AMMO'] = 4500,
					['emptybottle'] = 3,
				}
			},
			{
				name = 'rubber',
				count = 20,
				duration = 5000,
				ingredients = {
					['latex'] = 1,
				}
			},
		}
	},

	['seoul_crafting_Mechanic'] = {
		name = 'seoul_crafting_Mechanic',
		label = 'Mechanic',
		items = {
			{
				name = 'advtoolbox',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 75,
					['copper'] = 85,
					['rubber'] = 100,
					['screwnuts'] = 2,
					['screws'] = 2,
				}
			},
			{
				name = 'coilover',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 725,
					['copper'] = 725,
					['insulatingtape'] = 2,
					['metalspring'] = 4,
					['roadsigns'] = 4,
					['scotchtape'] = 2,
					['scrapmetal'] = 425,
					['screwnuts'] = 24,
					['screws'] = 24,
					['sheetmetal'] = 10,
				}
			},
			{
				name = 'nitro',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 55,
					['copper'] = 60,
					['glass'] = 125,
					['insulatingtape'] = 1,
					['scotchtape'] = 2,
					['screwnuts'] = 2,
					['screws'] = 2,
				}
			},
			{
				name = 'plate',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 45,
					['copper'] = 50,
				}
			},
			{
				name = 'toolbox',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 15,
					['copper'] = 18,
					['rubber'] = 50,
					['screwnuts'] = 1,
					['screws'] = 1,
				}
			},
			{
				name = 'tyres',
				count = 1,
				duration = 5000,
				ingredients = {
					['rubber'] = 35,
				}
			},
		}
	},

	['seoul_crafting_drugs_bench'] = {
		name = 'seoul_crafting_drugs_bench',
		label = 'drugs_bench',
		items = {
			{
				name = 'amphetamine',
				count = 1,
				duration = 5000,
				ingredients = {
					['cocaine'] = 6,
					['meth'] = 6,
				}
			},
			{
				name = 'cocaine',
				count = 1,
				duration = 5000,
				ingredients = {
					['coke'] = 1,
				}
			},
			{
				name = 'codeine',
				count = 1,
				duration = 5000,
				ingredients = {
					['alcohol'] = 2,
					['analgesic'] = 1,
					['sulfuric'] = 2,
				}
			},
			{
				name = 'cokesack',
				count = 1,
				duration = 5000,
				ingredients = {
					['cocaine'] = 10,
				}
			},
			{
				name = 'crack',
				count = 1,
				duration = 5000,
				ingredients = {
					['acetone'] = 2,
					['cocaine'] = 10,
				}
			},
			{
				name = 'heroin',
				count = 1,
				duration = 5000,
				ingredients = {
					['alcohol'] = 2,
					['meth'] = 7,
					['saline'] = 2,
					['sulfuric'] = 2,
				}
			},
			{
				name = 'joint',
				count = 1,
				duration = 5000,
				ingredients = {
					['weed'] = 1,
				}
			},
			{
				name = 'metadone',
				count = 1,
				duration = 5000,
				ingredients = {
					['alcohol'] = 2,
					['analgesic'] = 1,
					['sulfuric'] = 2,
				}
			},
			{
				name = 'meth',
				count = 5,
				duration = 5000,
				ingredients = {
					['saline'] = 1,
					['sulfuric'] = 1,
				}
			},
			{
				name = 'methsack',
				count = 1,
				duration = 5000,
				ingredients = {
					['meth'] = 10,
				}
			},
			{
				name = 'weedsack',
				count = 1,
				duration = 5000,
				ingredients = {
					['joint'] = 10,
				}
			},
		}
	},
	['seoul_crafting_pistol_bench'] = {
		name = 'seoul_crafting_pistol_bench',
		label = 'pistol_bench',
		items = {
			{
				name = 'WEAPON_COMBATPISTOL',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 75,
					['copper'] = 75,
					['glass'] = 115,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 125,
					['rubber'] = 125,
					['weaponparts'] = 3,
				}
			},
			{
				name = 'WEAPON_HEAVYPISTOL',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 100,
					['copper'] = 100,
					['glass'] = 155,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 175,
					['rubber'] = 155,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_PISTOL',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 75,
					['copper'] = 75,
					['glass'] = 100,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 120,
					['rubber'] = 100,
					['weaponparts'] = 3,
				}
			},
			{
				name = 'WEAPON_PISTOL50',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 100,
					['copper'] = 100,
					['glass'] = 155,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 165,
					['rubber'] = 155,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_PISTOL_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 75,
					['copper'] = 75,
					['glass'] = 115,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 135,
					['rubber'] = 115,
					['weaponparts'] = 3,
				}
			},
			{
				name = 'WEAPON_SNSPISTOL',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 65,
					['copper'] = 55,
					['glass'] = 75,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 65,
					['rubber'] = 100,
					['weaponparts'] = 3,
				}
			},
			{
				name = 'WEAPON_SNSPISTOL_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 75,
					['copper'] = 75,
					['glass'] = 75,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 110,
					['rubber'] = 100,
					['weaponparts'] = 3,
				}
			},
			{
				name = 'WEAPON_VINTAGEPISTOL',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 50,
					['copper'] = 50,
					['glass'] = 75,
					['metalspring'] = 1,
					['pistolbody'] = 1,
					['plastic'] = 100,
					['rubber'] = 75,
					['weaponparts'] = 3,
				}
			},
		}
	},
	['seoul_crafting_rifle_bench'] = {
		name = 'seoul_crafting_rifle_bench',
		label = 'rifle_bench',
		items = {
			{
				name = 'WEAPON_ADVANCEDRIFLE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 325,
					['copper'] = 335,
					['glass'] = 385,
					['metalspring'] = 3,
					['plastic'] = 405,
					['riflebody'] = 1,
					['rubber'] = 405,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_ASSAULTRIFLE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 300,
					['copper'] = 425,
					['glass'] = 305,
					['metalspring'] = 3,
					['plastic'] = 425,
					['riflebody'] = 1,
					['rubber'] = 425,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_ASSAULTRIFLE_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 345,
					['copper'] = 425,
					['glass'] = 275,
					['metalspring'] = 3,
					['plastic'] = 400,
					['riflebody'] = 1,
					['rubber'] = 400,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_BULLPUPRIFLE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 325,
					['copper'] = 325,
					['glass'] = 385,
					['metalspring'] = 3,
					['plastic'] = 400,
					['riflebody'] = 1,
					['rubber'] = 465,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_BULLPUPRIFLE_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 425,
					['copper'] = 300,
					['glass'] = 305,
					['metalspring'] = 3,
					['plastic'] = 425,
					['riflebody'] = 1,
					['rubber'] = 425,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_CARBINERIFLE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 335,
					['copper'] = 345,
					['glass'] = 405,
					['metalspring'] = 3,
					['plastic'] = 405,
					['riflebody'] = 1,
					['rubber'] = 405,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_CARBINERIFLE_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 375,
					['copper'] = 355,
					['glass'] = 405,
					['metalspring'] = 3,
					['plastic'] = 375,
					['riflebody'] = 1,
					['rubber'] = 415,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_COMPACTRIFLE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 175,
					['copper'] = 175,
					['glass'] = 305,
					['metalspring'] = 2,
					['plastic'] = 265,
					['riflebody'] = 1,
					['rubber'] = 325,
					['weaponparts'] = 8,
				}
			},
			{
				name = 'WEAPON_HEAVYRIFLE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 375,
					['copper'] = 335,
					['glass'] = 305,
					['metalspring'] = 3,
					['plastic'] = 425,
					['riflebody'] = 1,
					['rubber'] = 425,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_PUMPSHOTGUN',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 175,
					['copper'] = 175,
					['glass'] = 225,
					['metalspring'] = 1,
					['plastic'] = 255,
					['riflebody'] = 1,
					['rubber'] = 265,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_PUMPSHOTGUN_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 175,
					['copper'] = 175,
					['glass'] = 375,
					['metalspring'] = 2,
					['plastic'] = 345,
					['riflebody'] = 1,
					['rubber'] = 425,
					['weaponparts'] = 8,
				}
			},
			{
				name = 'WEAPON_SAWNOFFSHOTGUN',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 175,
					['copper'] = 175,
					['glass'] = 225,
					['metalspring'] = 1,
					['plastic'] = 265,
					['riflebody'] = 1,
					['rubber'] = 255,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_SPECIALCARBINE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 300,
					['copper'] = 425,
					['glass'] = 305,
					['metalspring'] = 3,
					['plastic'] = 425,
					['riflebody'] = 1,
					['rubber'] = 425,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_SPECIALCARBINE_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 345,
					['copper'] = 425,
					['glass'] = 275,
					['metalspring'] = 3,
					['plastic'] = 400,
					['riflebody'] = 1,
					['rubber'] = 400,
					['weaponparts'] = 10,
				}
			},
			{
				name = 'WEAPON_TACTICALRIFLE',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 425,
					['copper'] = 345,
					['glass'] = 275,
					['metalspring'] = 3,
					['plastic'] = 400,
					['riflebody'] = 1,
					['rubber'] = 400,
					['weaponparts'] = 10,
				}
			},
		}
	},
	['seoul_crafting_smg_bench'] = {
		name = 'seoul_crafting_smg_bench',
		label = 'smg_bench',
		items = {
			{
				name = 'WEAPON_APPISTOL',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 100,
					['copper'] = 100,
					['glass'] = 145,
					['metalspring'] = 2,
					['plastic'] = 155,
					['rubber'] = 145,
					['smgbody'] = 1,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_GUSENBERG',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 225,
					['copper'] = 225,
					['glass'] = 275,
					['metalspring'] = 2,
					['plastic'] = 305,
					['rubber'] = 305,
					['smgbody'] = 1,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_MACHINEPISTOL',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 100,
					['copper'] = 100,
					['glass'] = 145,
					['metalspring'] = 2,
					['plastic'] = 155,
					['rubber'] = 145,
					['smgbody'] = 1,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_MICROSMG',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 175,
					['copper'] = 175,
					['glass'] = 225,
					['metalspring'] = 2,
					['plastic'] = 275,
					['rubber'] = 235,
					['smgbody'] = 1,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_MINISMG',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 175,
					['copper'] = 175,
					['glass'] = 225,
					['metalspring'] = 2,
					['plastic'] = 275,
					['rubber'] = 235,
					['smgbody'] = 1,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_SMG',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 225,
					['copper'] = 225,
					['glass'] = 275,
					['metalspring'] = 2,
					['plastic'] = 315,
					['rubber'] = 305,
					['smgbody'] = 1,
					['weaponparts'] = 5,
				}
			},
			{
				name = 'WEAPON_SMG_MK2',
				count = 1,
				duration = 5000,
				ingredients = {
					['aluminum'] = 225,
					['copper'] = 225,
					['glass'] = 375,
					['metalspring'] = 2,
					['plastic'] = 305,
					['rubber'] = 305,
					['smgbody'] = 1,
					['weaponparts'] = 5,
				}
			},
		}
	},
}
