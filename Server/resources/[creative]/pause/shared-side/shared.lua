-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
MarketplaceTax = 0.03 -- Taxa em cima do valor do item anunciado.
SalaryCooldown = 1800 -- Quantidade de segundos.
-----------------------------------------------------------------------------------------------------------------------------------------
-- COUPON
-----------------------------------------------------------------------------------------------------------------------------------------
Coupon = {
	Discount = 30,
	Code = "NN30"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SOCIALSz
-----------------------------------------------------------------------------------------------------------------------------------------
Socials = {
	Discord = "https://discord.gg/connecthype",
	Instagram = "https://instagram.com/connecthyperp",
	Tiktok = "http://tiktok.com/hyperoleplayoficial",
	Facebook = "",
	Twitter = "",
	Youtube = ""
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
BattlepassPoints = 100 -- Pontos necessários para resgatar cada nível.
BattlepassPrice = 500 -- Preço do passe premium em diamantes.

Battlepass = {
	Free = {
		{ Id = 1, Name = "Água", Description = "5 unidades de água.", Image = "water", Item = "water", Amount = 5 },
		{ Id = 2, Name = "Sanduíche", Description = "5 unidades de sanduíche.", Image = "sandwich", Item = "sandwich", Amount = 5 },
		{ Id = 3, Name = "Dinheiro", Description = "Recompensa de 10 mil dólares.", Image = "dollar", Item = "dollar", Amount = 10000 },
		{ Id = 4, Name = "Bandagem", Description = "3 unidades de bandagem.", Image = "bandage", Item = "bandage", Amount = 3 },
		{ Id = 5, Name = "Água", Description = "10 unidades de água.", Image = "water", Item = "water", Amount = 10 },
		{ Id = 6, Name = "Dinheiro", Description = "Recompensa de 15 mil dólares.", Image = "dollar", Item = "dollar", Amount = 15000 },
		{ Id = 7, Name = "Rádio", Description = "1 rádio comunicador.", Image = "radio", Item = "radio", Amount = 1 },
		{ Id = 8, Name = "Bandagem", Description = "5 unidades de bandagem.", Image = "bandage", Item = "bandage", Amount = 5 },
		{ Id = 9, Name = "Dinheiro", Description = "Recompensa de 20 mil dólares.", Image = "dollar", Item = "dollar", Amount = 20000 },
		{ Id = 10, Name = "Celular", Description = "1 aparelho celular.", Image = "cellphone", Item = "cellphone", Amount = 1 }
	},
	Premium = {
		{ Id = 1, Name = "Dinheiro", Description = "Recompensa premium de 20 mil dólares.", Image = "dollar", Item = "dollar", Amount = 20000 },
		{ Id = 2, Name = "Bandagem", Description = "5 unidades de bandagem.", Image = "bandage", Item = "bandage", Amount = 5 },
		{ Id = 3, Name = "Dinheiro", Description = "Recompensa premium de 30 mil dólares.", Image = "dollar", Item = "dollar", Amount = 30000 },
		{ Id = 4, Name = "Adrenalina", Description = "2 unidades de adrenalina.", Image = "adrenaline", Item = "adrenaline", Amount = 2 },
		{ Id = 5, Name = "Mochila média", Description = "1 mochila de tamanho médio.", Image = "backpackm", Item = "backpackm", Amount = 1 },
		{ Id = 6, Name = "Dinheiro", Description = "Recompensa premium de 40 mil dólares.", Image = "dollar", Item = "dollar", Amount = 40000 },
		{ Id = 7, Name = "Kit de reparo", Description = "1 kit de reparo.", Image = "repairkit01", Item = "repairkit01", Amount = 1 },
		{ Id = 8, Name = "Adrenalina Plus", Description = "1 unidade de adrenalina plus.", Image = "adrenalineplus", Item = "adrenalineplus", Amount = 1 },
		{ Id = 9, Name = "Dinheiro", Description = "Recompensa premium de 50 mil dólares.", Image = "dollar", Item = "dollar", Amount = 50000 },
		{ Id = 10, Name = "Gemas", Description = "50 gemas como prêmio final.", Image = "gemstone", Item = "gemstone", Amount = 50 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOXES
-----------------------------------------------------------------------------------------------------------------------------------------
Boxes = {
	{
		["Id"] = 1,
		["Name"] = "Caixa de Itens",
		["Image"] = "itensbox",
		["Price"] = 60,
		["Discount"] = 1.0,
		["Rewards"] = {
			{
				["Id"] = 1,
				["Amount"] = 1,
				["Image"] = "cellphone",
				["Item"] = "cellphone",
				["Name"] = "Celular",
				["Chance"] = 400
			},{
				["Id"] = 2,
				["Amount"] = 1,
				["Image"] = "radio",
				["Item"] = "radio",
				["Name"] = "Radio",
				["Chance"] = 400
			},{
				["Id"] = 3,
				["Amount"] = 10,
				["Image"] = "energetic",
				["Item"] = "energetic",
				["Name"] = "Energético",
				["Chance"] = 380
			},{
				["Id"] = 4,
				["Amount"] = 1,
				["Image"] = "advtoolbox",
				["Item"] = "advtoolbox",
				["Name"] = "Caixa de Ferramentas",
				["Chance"] = 380
			},{
				["Id"] = 5,
				["Amount"] = 2,
				["Image"] = "adrenaline",
				["Item"] = "adrenalineplus",
				["Name"] = "Adrenalina Plus",
				["Chance"] = 380
			},{
				["Id"] = 6,
				["Amount"] = 40000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 120
			},{
				["Id"] = 7,
				["Amount"] = 50000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 150
			},{
				["Id"] = 8,
				["Amount"] = 20000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 200
			},{
				["Id"] = 9,
				["Amount"] = 100000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 30
			},{
				["Id"] = 10,
				["Amount"] = 1,
				["Image"] = "instagram",
				["Item"] = "instagram",
				["Name"] = "100 Seguidores Instagram",
				["Chance"] = 50
			},{
				["Id"] = 11,
				["Amount"] = 3,
				["Image"] = "diagram",
				["Item"] = "diagram",
				["Name"] = "Diagrama 10KG",
				["Chance"] = 100
			},{
				["Id"] = 12,
				["Amount"] = 1,
				["Image"] = "platepremium",
				["Item"] = "premiumplate",
				["Name"] = "Placa Personalizada",
				["Chance"] = 30
			},{
				["Id"] = 13,
				["Amount"] = 1,
				["Image"] = "WEAPON_PISTOL_MK2",
				["Item"] = "WEAPON_PISTOL_MK2",
				["Name"] = "Five-Seven",
				["Chance"] = 80
			},{
				["Id"] = 14,
				["Amount"] = 1,
				["Image"] = "WEAPON_GLOCKRAJADA",
				["Item"] = "WEAPON_GLOCKRAJADA",
				["Name"] = "Glock Rajada",
				["Chance"] = 28
			},{
				["Id"] = 15,
				["Amount"] = 1,
				["Image"] = "WEAPON_M4GOLD",
				["Item"] = "WEAPON_M4GOLD",
				["Name"] = "M4 GOLD",
				["Chance"] = 25
			},{
				["Id"] = 16,
				["Amount"] = 1,
				["Image"] = "WEAPON_PARAFAL",
				["Item"] = "WEAPON_FAL",
				["Name"] = "Parafal",
				["Chance"] = 20
			},{
				["Id"] = 16,
				["Amount"] = 1,
				["Image"] = "WEAPON_ARRELIKIASHOPFEMININO1",
				["Item"] = "WEAPON_ARRELIKIASHOPFEMININO1",
				["Name"] = "AR15 ROSA",
				["Chance"] = 15
			},{
				["Id"] = 16,
				["Amount"] = 1,
				["Image"] = "WEAPON_G3RELIKIASHOPFEMININO",
				["Item"] = "WEAPON_G3RELIKIASHOPFEMININO",
				["Name"] = "G3 ROSA",
				["Chance"] = 15
			},{
				["Id"] = 17,
				["Amount"] = 1,
				["Image"] = "barretmengo",
				["Item"] = "WEAPON_BARRETMENGO",
				["Name"] = "Barret",
				["Chance"] = 2
			}
		}
	},
	{
		["Id"] = 2,
		["Name"] = "EnerBox",
		["Image"] = "itensbox",
		["Price"] = 15,
		["Discount"] = 1.0,
		["Rewards"] = {
			{
				["Id"] = 1,
				["Amount"] = 3,
				["Image"] = "energetic2",
				["Item"] = "energetic2",
				["Name"] = "Super Energético",
				["Chance"] = 400
			},{
				["Id"] = 2,
				["Amount"] = 5,
				["Image"] = "energetic2",
				["Item"] = "energetic2",
				["Name"] = "Super Energético",
				["Chance"] = 300
			},{
				["Id"] = 3,
				["Amount"] = 10,
				["Image"] = "energetic2",
				["Item"] = "energetic2",
				["Name"] = "Super Energético",
				["Chance"] = 150
			},{
				["Id"] = 4,
				["Amount"] = 20,
				["Image"] = "energetic2",
				["Item"] = "energetic2",
				["Name"] = "Super Energético",
				["Chance"] = 100
			},{
				["Id"] = 5,
				["Amount"] = 30,
				["Image"] = "energetic2",
				["Item"] = "energetic2",
				["Name"] = "Super Energético",
				["Chance"] = 5
			},{
				["Id"] = 6,
				["Amount"] = 80,
				["Image"] = "energetic2",
				["Item"] = "energetic2",
				["Name"] = "Super Energético",
				["Chance"] = 2
			}
		}
	},
	{
		["Id"] = 3,
		["Name"] = "Caixa de Dinheiro",
		["Image"] = "itensbox",
		["Price"] = 50,
		["Discount"] = 1.0,
		["Rewards"] = {
			{
				["Id"] = 1,
				["Amount"] = 10000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 380
			},{
				["Id"] = 2,
				["Amount"] = 15000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 300
			},{
				["Id"] = 3,
				["Amount"] = 20000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 250
			},{
				["Id"] = 4,
				["Amount"] = 25000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 200
			},{
				["Id"] = 5,
				["Amount"] = 30000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 150
			},{
				["Id"] = 6,
				["Amount"] = 40000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 100
			},{
				["Id"] = 7,
				["Amount"] = 50000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 50
			},{
				["Id"] = 8,
				["Amount"] = 100000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 5
			},{
				["Id"] = 9,
				["Amount"] = 1000000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 2
			}
		}
	},
	{
		["Id"] = 4,
		["Name"] = "Caixa de Comida",
		["Image"] = "itensbox",
		["Price"] = 10,
		["Discount"] = 1.0,
		["Rewards"] = {
			{
				["Id"] = 1,
				["Amount"] = 2,
				["Image"] = "combonatal",
				["Item"] = "combonatal",
				["Name"] = "Combo Especial de Natal",
				["Chance"] = 380
			},{
				["Id"] = 2,
				["Amount"] = 2,
				["Image"] = "combobrinquedo1",
				["Item"] = "combobrinquedo1",
				["Name"] = "Combo Brinquedos Connect",
				["Chance"] = 300
			},{
				["Id"] = 3,
				["Amount"] = 20000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 250
			},{
				["Id"] = 4,
				["Amount"] = 25000,
				["Image"] = "dollar",
				["Item"] = "dollar",
				["Name"] = "Dinheiro",
				["Chance"] = 200
			},{
				["Id"] = 5,
				["Amount"] = 3,
				["Image"] = "combobrinquedo1",
				["Item"] = "combobrinquedo1",
				["Name"] = "Combo Brinquedos Connect",
				["Chance"] = 150
			},{
				["Id"] = 6,
				["Amount"] = 5,
				["Image"] = "combobrinquedo1",
				["Item"] = "combobrinquedo1",
				["Name"] = "Combo Brinquedos Connect",
				["Chance"] = 100
			},{
				["Id"] = 7,
				["Amount"] = 1,
				["Image"] = "capybara",
				["Item"] = "capybara",
				["Name"] = "Capivara Rena",
				["Chance"] = 20
			},{
				["Id"] = 8,
				["Amount"] = 10,
				["Image"] = "combobrinquedo1",
				["Item"] = "combobrinquedo1",
				["Name"] = "Combo Brinquedos Connect",
				["Chance"] = 5
			},{
				["Id"] = 9,
				["Amount"] = 20,
				["Image"] = "combobrinquedo1",
				["Item"] = "combobrinquedo1",
				["Name"] = "Combo Brinquedos Connect",
				["Chance"] = 2
			}
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
Works = {
	Grime = "Grime",
	Taxi = "Taxista",
	Towed = "Impound",
	Dismantle = "Desmanche",
	Delivery = "Entregador",
	Transporter = "Transportador",
	Lumberman = "Lenhador",
	Milkman = "Leiteiro",
	Trucker = "Caminhoneiro",
	Fisherman = "Pescador",
	Driver = "Motorista",
	Traffic = "Traficante",
	Garbageman = "Lixeiro",
	Race = "Corredor"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
Premium = {
	{
		Name = "VIP Carnaval (30D)",
		Image = "VIPCarnaval",
		Permission = "VipCarnaval",
		Price = 90000,
		Discount = 1.0,
		Duration = 2592000,
		Highlight = true,
		Rewards = {
			{
				Type = "Info",
				Name = "Duração: O Pacote VIP Carnaval é válido por 30 dias a partir da data de aprovação."
			},{
				Type = "Info",
				Name = "Reduz 30% de quebrar a Lockpick."
			},{
				Type = "Info",
				Name = "Tag 'VIP Carnaval' no Discord"
			},{
				Type = "Info",
				Name = "Redução de spawn em 40%"
			},{
				Type = "Info",
				Name = "Redução de 35% no tempo de prisão."
			},{
				Type = "Info",
				Name = "Acesso a um Vale Mansão, garanta uma casa sem pagar nada!"
			},{
				Type = "Info",
				Name = "Acesso ao comando /gps para liberar o minimapa mesmo sem estar no veículo e sem precisar do item."
			},{
				Type = "Info",
				Name = "Acesso a todas Skins de armas (30 Dias)."
			},{
				Type = "Info",
				Name = "Recebe 50Kg a mais de peso na mochila."
			},{
				Type = "Info",
				Name = "Limite de inventário na academia aumentado para 65 kg."
			},{
				Type = "Info",
				Name = "Recebe 20% a mais de bonificação nos empregos/venda de drogas."
			},{
				Type = "Info",
				Name = "Recebe 10% a mais de bonificação nos Roubos."
			},{
				Type = "Info",
				Name = "Acesso a 1000 seguidores no HypeGram"
			},{
				Type = "Info",
				Name = "Salário de $8.500 a cada 30 minutos."
			},{
				Type = "Info",
				Name = "35% de desconto em todos os impostos."
			},{
				Type = "Info",
				Name = "Prioridade na fila de 50% (30 dias)"
			},{
				Type = "Info",
				Name = "Acesso a 50 Mil reais na ativação do Vip"
			},{
				Type = "Info",
				Name = "Acesso a 200 Coins na ativação do VIP"
			},{
				Type = "Info",
				Name = "Acesso ao comando /cor"
			},{
				Type = "Info",
				Name = "Acesso ao sem perder mochila"
			},{
				Type = "Info",
				Name = "Acesso a 2 placas personalizada"
			},{
				Type = "Info",
				Name = "Acesso ao /som"
			},{
				Type = "Info",
				Name = "Acesso ao /cam"
			},{
				Type = "Info",
				Name = "Recebe 6 Vagas para salvar Roupas no /outfits"
			},{
				Type = "Info",
				Name = "Limite máximo de veículos da concessionária: 18"
			},{
				Type = "Info",
				Name = "Desconto exclusivo de 20% na concessionária."
			},{
				Type = "Vehicle",
				Name = "Acesso a um veículo da Classe Hypers (30 Dias)"
			},{
				Type = "Vehicle",
				Name = "Acesso a uma Motocicleta Exclusiva (30 Dias)"
			},{
				Type = "Vehicle",
				Name = "Acesso a um veículo Exclusivo Vip Carnaval (Permanente)"
			},{
				Type = "Vehicle",
				Name = "Acesso a um veículo Blindado Exclusivo Carnaval (30 Dias)"
			},{
				Type = "Vehicle",
				Name = "Acesso exclusivo a uma Caminhonete Temática de Carnaval (30 Dias)"
			}			
		},
		Selectables = {
			{
				Name = "Veículo Classe Hypers",
				Options = {
					{
						Name = "Karin RX",
						Index = "karinrx"
					},{
						Name = "Progen T1",
						Index = "progent1"
					},{
						Name = "Trigris 900",
						Index = "tigris9"
					},{
						Name = "Strident RS",
						Index = "stridentrs"
					},{
						Name = "Pfister Spaider",
						Index = "spider"
					}
				}
			},{
				Name = "Classe Blindados Carnaval",
				Options = {
					{
						Name = "Ubermacht R5 - 16 Tiros",
						Index = "Ubermachtr5"
					},{
						Name = "Gallivanter - 16 Tiros (6 Lugares)",
						Index = "Gallivanter_Baller"
					},{
						Name = "Ubermacht Vorstand - 16 Tiros",
						Index = "vorstandr"
					},{
						Name = "XIS M - 16 Tiros",
						Index = "RMPXM"
					},{
						Name = "Oros Solo Leveling - 16 Tiros",
						Index = "OROSREMAP"
					},{
						Name = "Que888 Attack on Titan - 16 Tiros",
						Index = "Q888REMAP"
					},{
						Name = "Durantan Demon Slayer - 16 Tiros",
						Index = "DURANTANRMP"
					},{
						Name = "Dewbauchee BX - 16 Tiros",
						Index = "Dewbaucheebx"
					},{
						Name = "Sentinel GR Deboxe - 16 Tiros",
						Index = "sentinelgr"
					},{
						Name = "Levantezza Blood - 16 Tiros",
						Index = "PUROSANGUEVALLENTINESDM"
					},{
						Name = "Pegassi V700 - 16 Tiros",
						Index = "P700REMAP"
					},{
						Name = "Ubermacht R5 2010 - 16 Tiros ( NOVIDADE CARNAVAL)",
						Index = "70uber"
					},{
						Name = "Tail Sedan - 16 Tiros ( NOVIDADE CARNAVAL)",
						Index = "tailsedan"
					},{
						Name = "Pfister Astron CA - 16 Tiros ( NOVIDADE CARNAVAL)",
						Index = "ccoup"
					}
				}
			},{
				Name = "Motocicleta Exclusiva",
				Options = {
					{
						Name = "Maibatsu Sprinter",
						Index = "sprinter"
					},{
						Name = "Dominus Range",
						Index = "range"
					},{
						Name = "Lampadati Flash",
						Index = "flash"
					},{
						Name = "Expedition V-Rider",
						Index = "vrider"
					}
				}
			},{
				Name = "Veículo Classe 2",
				Options = {
					{
						Name = "Annis 50GT",
						Index = "50gt"
					},{
						Name = "Pegassi Aventor",
						Index = "aventor"
					},{
						Name = "Kanjuro",
						Index = "kanjuro"
					},{
						Name = "C-500",
						Index = "c500x"
					},{
						Name = "Grotti 458",
						Index = "g458"
					},{
						Name = "Strah L",
						Index = "strahl"
					}
				}
			}
		},
		Items = {
			['instagram'] = 10,
			['newchars'] = 1,
			['premiumplate'] = 1,
			['dollar'] = 70000
		}
	},{
		Name = "Vip Herdeiro (60D)",
		Image = "herdeiro",
		Permission = "Herdeiro",
		Price = 90000,
		Discount = 1.0,
		Duration = 5184000,
		Highlight = false,
		Rewards = {
			{
				Type = "Info",
				Name = "Reduz 60% de quebrar a Lockpick."
			},{
				Type = "Info",
				Name = "Tag Vip Herdeiro no Discord"
			},{
				Type = "Info",
				Name = "Acesso a todas Skins de armas 30 dias."
			},{
				Type = "Info",
				Name = "Recebe 120 Kilos a mais de peso na mochila."
			},{
				Type = "Info",
				Name = "Limite de inventário na academia aumentado para 100 kg."
			},{
				Type = "Info",
				Name = "Recebe 50% a mais de bonificação nos empregos/venda de drogas."
			},{
				Type = "Info",
				Name = "Recebe 25% a mais de bonificação nos Roubos."
			},{
				Type = "Info",
				Name = "Salário de $15.000 a cada 30 minutos."
			},{
				Type = "Info",
				Name = "70% de desconto em todos os impostos."
			},{
				Type = "Info",
				Name = "Prioridade na fila de ADM"
			},{
				Type = "Info",
				Name = "Acesso ao comando /cor"
			},{
				Type = "Info",
				Name = "Acesso a 150 Mil reais na ativacao do Vip"
			},{
				Type = "Info",
				Name = "Acesso a 500 Coins na ativacao do VIP"
			},{
				Type = "Info",
				Name = "Acesso a 35 Mil seguidores no HypeGram"
			},{
				Type = "Info",
				Name = "Acesso a +2 Slot de personagem"
			},{
				Type = "Info",
				Name = "Acesso ao sem perder mochila"
			},{
				Type = "Info",
				Name = "Acesso a 6 placa personalizada"
			},{
				Type = "Info",
				Name = "Acesso ao /som"
			},{
				Type = "Info",
				Name = "Acesso ao /cam"
			},{
				Type = "Info",
				Name = "Recebe 20 Vagas para salvar Roupas no /outfits"
			},{
				Type = "Vehicle",
				Name = "Veículo Classe Hypers"
			},{
				Type = "Vehicle",
				Name = "Veículo Classe Supers"
			},{
				Type = "Vehicle",
				Name = "Veículo Classe Esportivos"
			},{
				Type = "Vehicle",
				Name = "Veículo Classe Blindado Herdeiro"
			},{
				Type = "Vehicle",
				Name = "Veículo Blindado 32 Tiros (30D) (Após a finalização da doação, abra um Ticket de Doação VIP no nosso discord oficial!"
			}
		},
		Selectables = {
			{
				Name = "Veículo Classe Blindado Herdeiro",
				Options = {
					{
						Name = "Durrango Durantan - 16 Tiros",
						Index = "DURANTANRMP"
					},{
						Name = "Benefector GellR - 16 Tiros",
						Index = "GLLRMPNORMAL"
					},{
						Name = "Pegassi Oros - 16 Tiros",
						Index = "OROSREMAP"
					},{
						Name = "Obey QUE888 - 16 Tiros",
						Index = "Q888REMAP"
					},{
						Name = "Annis 35GT GHOUL - 16 Tiros",
						Index = "RMPGHOUL"
					},{
						Name = "Toros Pega - Blindada",
						Index = "torospega"
					},{
						Name = "Gallivanter - Blindada (6 Lugares)",
						Index = "Gallivanter_Baller"
					},{
						Name = "Dewbauchee BX - Blindada",
						Index = "Dewbaucheebx"
					},{
						Name = "Ubermacht R5 - Blindada",
						Index = "Ubermachtr5"
					},{
						Name = "Ubermacht Vorstand - Blindada",
						Index = "vorstandr"
					},{
						Name = "Ubermacht Bravur - Blindada",
						Index = "bravur"
					},{
						Name = "Vapid NX - Blindada",
						Index = "Vapid_Nivex"
					},{
						Name = "Vulcar Karelia - Blindada",
						Index = "karelia"
					},{
						Name = "Benefactor Neuron-E - Blindada",
						Index = "neurone"
					},{
						Name = "XIS M - 16 Tiros",
						Index = "RMPXM"
					}
				}
			},{
				Name = "Veículo Classe Supers",
				Options = {
					{
						Name = "Annis 34GT",
						Index = "34gt"
					},{
						Name = "Benefactor 45",
						Index = "b45"
					},{
						Name = "Templa RZ",
						Index = "templarz"
					},{
						Name = "DUKO 90",
						Index = "duko90"
					},{
						Name = "Draken",
						Index = "draken"
					},{
						Name = "Emperor EFA",
						Index = "efa"
					},{
						Name = "Lumera",
						Index = "lumera"
					},{
						Name = "Tenrai",
						Index = "tenrai"
					},{
						Name = "Klingen T4",
						Index = "klingen"
					}
				}
			},{
				Name = "Veículo Classe Hypers",
				Options = {
					{
						Name = "Karin RX",
						Index = "karinrx"
					},{
						Name = "Progen T1",
						Index = "progent1"
					},{
						Name = "Pfister Spaider",
						Index = "spider"
					},{
						Name = "Trigris 900",
						Index = "tigris9"
					},{
						Name = "Renngeist",
						Index = "renngeist"
					},{
						Name = "Strident RS",
						Index = "stridentrs"
					}
				}
			},{
				Name = "Veículo Esportivo",
				Options = {
					{
						Name = "Annis 35GT",
						Index = "35gt"
					},{
						Name = "Dinka R",
						Index = "dinkar"
					},{
						Name = "Pfister RS",
						Index = "pfisterrs"
					},{
						Name = "U1250 ADV",
						Index = "u1250adv"
					},{
						Name = "Seraph",
						Index = "seraph"
					},{
						Name = "Velocita",
						Index = "velocita"
					},{
						Name = "Raijux",
						Index = "raijux"
					},{
						Name = "Rennhart",
						Index = "rennhart"
					},{
						Name = "Feronx",
						Index = "feronx"
					},{
						Name = "Solairu",
						Index = "solairu"
					}
				}
			}
		},
		Items = {
			['instagram'] = 35,
			['newchars'] = 2,
			['premiumplate'] = 6,
			['gemstone2'] = 500,
			['dollar'] = 150000
		}
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
Propertys = {
	{
		Name = "Fazenda",
		Image = "fazenda",
		Permission = "Fazenda",
		Coords = vec3(0.0,0.0,0.0),
		Price = 100000,
		Discount = 1.0,
		Duration = 2592000,
		Rewards = {
			"Textos da descrição. 01",
			"Textos da descrição. 02",
			"Textos da descrição. 03"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
ShopVehicles = {
	{
		Category = "Veículos Blindados",
		Model = "Gallivanter_Baller",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = true,
		Description = "Duração: O Pacote *Gallivanter - Blindada (6 Lugares)* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	},{
		Category = "Veículos Blindados",
		Model = "Dewbaucheebx",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = false,
		Description = "Duração: O Pacote *Dewbauchee BX - Blindada* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	},{
		Category = "Veículos Blindados",
		Model = "vorstandr",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = false,
		Description = "Duração: O Pacote *Ubermacht Vorstand - Blindada* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	},{
		Category = "Veículos Blindados",
		Model = "Vapid_Nivex",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = false,
		Description = "Duração: O Pacote *Vapid NX - Blindada* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	},{
		Category = "Veículos Blindados",
		Model = "karelia",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = false,
		Description = "Duração: O Pacote *Vulcar Karelia - Blindada* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	},{
		Category = "Veículos Blindados",
		Model = "neurone",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = false,
		Description = "Duração: O Pacote *Benefactor Neuron-E - Blindada* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	},{
		Category = "Veículos Blindados",
		Model = "RMPGHOUL",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = false,
		Description = "Duração: O Pacote *Benefactor Dubsta - Blindada* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	},{
		Category = "Veículos Blindados",
		Model = "RMPXM",
		Days = 30, -- 0 para permanente
		Price = 2497,
		Discount = 1.0,
		Highlight = false,
		Description = "Duração: O Pacote *Benefactor Dubsta - Blindada* é válido por 30 dias a partir da data de aprovação.<br><br>• Velocidade: 250 km/h.<br>• Nível de blindagem: 16 tiros em todos os vidros."
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPITENS
-----------------------------------------------------------------------------------------------------------------------------------------
ShopItens = {
	vipfac01 = {
		Category = "ORGS",
		Price = 31588,
		Discount = 1.0,
		Highlight = true,
		Description = "O Pacote *VIP Facção* é válido por 30 dias a partir da data de aprovação.<br><br>• 15 Veículos da Classe Blindados (Mensal - 30 dias)<br><br>• 15 Veículos da Classe 2 (Mensal - 30 dias)<br><br>• 1 Rádio Privada (Até Wipe)<br><br>• 1 Helicóptero Volatus ( Comprador )<br><br>• 1 Caminhão ( Liderança ) (Mensal - 30 dias)<br><br>• Blip de Roupas (Até Wipe)<br><br>• Blip de Barbearia (Até Wipe)<br><br>• Blip de Tatuagem (Até Wipe)<br><br>• +10.000 KG Baú Membros (Até Wipe)<br><br>• +5.000 KG Baú Lider Adicional (Até Wipe)<br><br>• Uniforme para a facção direito a 4 peças de roupa (Mensal - 30 dias)<br><br>• 15 pessoas com salários de R$4000 a cada 30 minutos.<br><br>• 15 Acessos ao comando /cor <br><br>• 15 Cargos Exclusivos no Discord."
	},
	carroexclusivo = {
		Category = "Extras",
		Price = 2970,
		Discount = 1.0,
		Highlight = true,
		Description = "• Tenha um VEÍCULO Personalizado dentro da cidade para chamar de seu, para confirmar as regras vigentes e especificações técnicas verifique diretamente no nosso discord oficial via ticket de doação VIP."
	},
	blindaoexclusivo = {
		Category = "Extras",
		Price = 5053,
		Discount = 1.0,
		Highlight = true,
		Description = "• Tenha um VEÍCULO Blindado Personalizado dentro da cidade para chamar de seu, para confirmar as regras vigentes e especificações técnicas verifique diretamente no nosso discord oficial via ticket de doação VIP."
	},
	pedpersonalizado = {
		Category = "Extras",
		Price = 1688,
		Discount = 1.0,
		Highlight = true,
		Description = "• 1 Adição de PED (20MB) – Válido até o wipe. Abrir ticket. Obs: Após a finalização da doação, abra um ticket de Doação VIP no nosso discord oficial!"
	},
	bau2000kg = {
		Category = "Extras",
		Price = 1758,
		Discount = 1.0,
		Highlight = false,
		Description = "• Aumente o espaço do baú da sua casa ou QG para 2000kgs.<br><br>• Observação: Após a finalização da doação, abra um ticket de Doação VIP no nosso discord oficial!"
	},
	hypecam = {
		Category = "Extras",
		Price = 250,
		Discount = 1.0,
		Highlight = false,
		Description = "• Tenha acesso ao comando /cam e solte sua criatividade para registrar momentos únicos com fotos incríveis!"
	},
	prioridade75 = {
		Category = "Extras",
		Price = 1875,
		Discount = 1.0,
		Highlight = false,
		Description = "• Prioridade na fila aumentada para 75%"
	},
	renovarexclusivo = {
		Category = "Extras",
		Price = 2922,
		Discount = 1.0,
		Highlight = false,
		Description = "• Renovação do seu veículo exclusivo por +30 dias na cidade.<br><br>• Lembrando que você precisa ADQUIRIR o veículo exclusivo antes de adquirir a renovação, para confirmar as regras vigentes e especificações técnicas verifique diretamente no nosso discord oficial via ticket de doação VIP."
	},
	roupapersonalizada = {
		Category = "Extras",
		Price = 4117,
		Discount = 1.0,
		Highlight = false,
		Description = "Adquirindo este item você poderá adicionar até 4 itens de peças de roupa personalizada.<br><br>• Dentre os itens, você pode selecionar a quantidade para masculino e feminino, exemplo:<br><br>• 1 Jaqueta e 1 Short Masculino.<br><br>• 1 Jaqueta e 1 Short Feminino.<br><br>• Observação: O valor refere-se a adição, os pacotes de roupas personalizadas precisam ser renovados mensalmente pelo mesmo valor.<br><br>• Observação²: Alterações, mudanças e atualizações serão cobradas o valor de adição."
	},
	som = {
		Category = "Extras",
		Price = 550,
		Discount = 1.0,
		Highlight = false,
		Description = "• Tenha acesso ao comando /som para tocar suas músicas favoritas."
	},
	verificado = {
		Category = "Extras",
		Price = 350,
		Discount = 1.0,
		Highlight = false,
		Description = "• Tenha o selo de verificado nas Redes Sociais."
	},
	premiumplate = {
		Category = "Extras",
		Price = 350,
		Discount = 1.0,
		Highlight = false,
		Description = "• Placa personalizada"
	},
	newchars = {
		Category = "Extras",
		Price = 1292,
		Discount = 1.0,
		Highlight = false,
		Description = "• Novo Personagem"
	},
	diagram = {
		Category = "Extras",
		Price = 100,
		Discount = 1.0,
		Highlight = false,
		Description = "• Diagrama usado em baus para aumentar o espaço de armazenamento."
	},
	WEAPON_KATANA = {
		Category = "Extras",
		Price = 20,
		Discount = 1.0,
		Highlight = false,
		Description = "• Katana"
	},
	backpackm = {
		Category = "Extras",
		Price = 235,
		Discount = 1.0,
		Highlight = false,
		Description = "• Mochila Média (75 Kg)"
	},
	sewingkit = {
		Category = "Extras",
		Price = 120,
		Discount = 1.0,
		Highlight = false,
		Description = "• Kit de costura usado para reparar mochilas rasgadas."
	},
	adrenalineplus = {
		Category = "Extras",
		Price = 10,
		Discount = 1.0,
		Highlight = false,
		Description = "• Adrenalina usada para usada em momentos de dores extremas."
	},
	radiomhz = {
		Category = "Extras",
		Price = 1964,
		Discount = 1.0,
		Highlight = false,
		Description = "• Rádio Privada (Até Wipe)"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLEITENS
-----------------------------------------------------------------------------------------------------------------------------------------
--[[
	Configuração para veiculos no passe vip
			Amount = 1,
			Item = "repairkit02",
			Days = 30,
			Vehicle = "aventor"
]]
RoleItens = {
	Free = {
		{
			Amount = 10000,
			Item = "dollar"
		},{
			Amount = 8,
			Item = "advtoolbox"
		},{
			Amount = 12000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "energetic2"
		},{
			Amount = 1,
			Item = "diagram"
		},{
			Amount = 1,
			Item = "medkit"
		},{
			Amount = 15000,
			Item = "dollar"
		},{
			Amount = 20,
			Item = "gemstone2"
		},{
			Amount = 17000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "WEAPON_KATANA"
		},{
			Amount = 20000,
			Item = "dollar"
		},{
			Amount = 5,
			Item = "WEAPON_CROWBAR"
		},{
			Amount = 22000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "sewingkit"
		},{
			Amount = 1,
			Item = "keycarsultan",
			Days = 15,
			Vehicle = "sultan2"
		},{
			Amount = 25000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "adrenalineplus"
		},{
			Amount = 28000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "premiumplate"
		},{
			Amount = 30000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "backpackp"
		},{
			Amount = 32000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "gemstone2"
		},{
			Amount = 34000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "diagram"
		},{
			Amount = 36000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "WEAPON_M4GOLD"
		},{
			Amount = 38000,
			Item = "dollar"
		},{
			Amount = 40000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "keycarpassefree",
			Days = 30,
			Vehicle = "gb200"
		}
	},
	Premium = {
		{
			Amount = 15000,
			Item = "dollar"
		},{
			Amount = 8,
			Item = "advtoolbox"
		},{
			Amount = 5,
			Item = "diagram"
		},{
			Amount = 15,
			Item = "energetic2"
		},{
			Amount = 20000,
			Item = "dollar"
		},{
			Amount = 7,
			Item = "medkit"
		},{
			Amount = 25000,
			Item = "dollar"
		},{
			Amount = 40,
			Item = "gemstone2"
		},{
			Amount = 30000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "WEAPON_KATANA"
		},{
			Amount = 10,
			Item = "diagram"
		},{
			Amount = 5,
			Item = "WEAPON_CROWBAR"
		},{
			Amount = 35000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "sewingkit"
		},{
			Amount = 1,
			Item = "keycarpassepremium15dias",
			Days = 15,
			Vehicle = "duko90"
		},{
			Amount = 40000,
			Item = "dollar"
		},{
			Amount = 4,
			Item = "adrenalineplus"
		},{
			Amount = 5,
			Item = "diagram"
		},{
			Amount = 2,
			Item = "premiumplate"
		},{
			Amount = 45000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "backpackg"
		},{
			Amount = 50000,
			Item = "dollar"
		},{
			Amount = 60,
			Item = "gemstone2"
		},{
			Amount = 55000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "WEAPON_HK417DENDE"
		},{
			Amount = 60000,
			Item = "dollar"
		},{
			Amount = 1,
			Item = "WEAPON_G3RELIKIASHOPFEMININO"
		},{
			Amount = 65000,
			Item = "dollar"
		},{
			Amount = 10,
			Item = "diagram"
		},{
			Amount = 1,
			Item = "keycarpassepremium30d",
			Days = 30,
			Vehicle = "34gt"
		}		
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Daily = {
	{
		gemstone2 = 40
	},{
		energetic2 = 15
	},{
		advtoolbox = 5
	},{
		energetic = 15
	},{
		dollar = 20000
	},{
		racestablet = 1
	},{
		racesticket = 3
	},{
		dollar = 40000
	},{
		energetic = 15
	},{
		gemstone2 = 40
	},{
		advtoolbox = 3
	},{
		dollar = 60000
	},{
		WEAPON_KATANA = 1
	},{
		{ Vehicle = 'gb200', Days = 3 },
	},

	--[[
	
	EXEMPLO VEHICLE: 
	{
		{ Vehicle = 'panto', Days = 15 },
	},
	]]
}
