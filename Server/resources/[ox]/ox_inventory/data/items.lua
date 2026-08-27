--[[
    Seoul OX Inventory Items
    Gerado a partir de Server/resources/[core]/vrp/config/Item.lua
    Fonte oficial de cadastro da base: vRP Item.lua
    Peso convertido: vRP kg -> OX gramas.
]]
return {

    ["speed_camera"] = {
    ["Index"] = "speed_camera",
    ["Name"] = "Radar de Velocidade",
    ["Description"] = "Radar portátil utilizado em operações policiais.",
    ["Type"] = "Consumível",
    ["Weight"] = 0.10
    },
    ["megaphone"] = {
        ["Index"] = "megaphone",
        ["Name"] = "Megafone",
        ["Description"] = "Megafone portátil para comunicação policial em área externa.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["handcuffs_key"] = {
        ["Index"] = "handcuffs_key",
        ["Name"] = "Chave de Algemas",
        ["Description"] = "Chave utilizada para destravar algemas policiais.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["paper_bag_rcore"] = {
        ["Index"] = "paper_bag_rcore",
        ["Name"] = "Saco de Papel",
        ["Description"] = "Saco de papel utilizado em interações policiais.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["zipties"] = {
        ["Index"] = "zipties",
        ["Name"] = "Enforca-Gato",
        ["Description"] = "Abraçadeira plástica utilizada para contenção.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["zipties_cutter"] = {
        ["Index"] = "zipties_cutter",
        ["Name"] = "Cortador de Abraçadeira",
        ["Description"] = "Ferramenta utilizada para remover abraçadeiras de contenção.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["panic_button"] = {
        ["Index"] = "panic_button",
        ["Name"] = "Botão de Pânico",
        ["Description"] = "Dispositivo de emergência utilizado por agentes em serviço.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["police_camera"] = {
        ["Index"] = "police_camera",
        ["Name"] = "Câmera de Evidências",
        ["Description"] = "Câmera policial destinada ao registro de evidências.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["photo"] = {
        ["Index"] = "photo",
        ["Name"] = "Fotografia",
        ["Description"] = "Registro fotográfico produzido pela câmera de evidências.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10,
        ["Unique"] = true
    },
    ["gps"] = {
        ["Index"] = "gps",
        ["Name"] = "GPS Policial",
        ["Description"] = "Rastreador GPS utilizado por agentes em serviço.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["bodycam"] = {
        ["Index"] = "bodycam",
        ["Name"] = "Bodycam",
        ["Description"] = "Câmera corporal utilizada por agentes em serviço.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["bodycam_tablet"] = {
        ["Index"] = "bodycam_tablet",
        ["Name"] = "Tablet de Bodycam",
        ["Description"] = "Tablet utilizado para visualizar transmissões de bodycams.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.10
    },
    ["wheel_clamp"] = {
        ["Index"] = "wheel_clamp",
        ["Name"] = "Trava de Roda",
        ["Description"] = "Dispositivo policial para imobilização de veículos.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.001
    },
    ["wheel_clamp_wrench"] = {
        ["Index"] = "wheel_clamp_wrench",
        ["Name"] = "Chave da Trava de Roda",
        ["Description"] = "Ferramenta utilizada para remover a trava de roda.",
        ["Type"] = "Consumível",
        ["Weight"] = 0.001
    },

    ['themeparkpass'] = {
    label = 'Passe do Parque',
    weight = 50,
    stack = true,
    close = true,
    consume = 0,
    client = {
        event = 'rtx_themepark:Seoul:UseThemeParkPass',
        },
    },

    ['blackcard'] = {
		label = 'Cartão Preto',
		weight = 10,
		stack = true,
		close = true,
		description = 'Cartão usado em roubos de banco e carro forte.',
		client = {
			image = 'blackcard.png',
		},
	},

	['bluecard'] = {
		label = 'Cartão Azul',
		weight = 10,
		stack = true,
		close = true,
		description = 'Cartão usado para iniciar o roubo da joalheria.',
		client = {
			image = 'bluecard.png',
		},
	},

	['watch'] = {
		label = 'Relógio Roubado',
		weight = 100,
		stack = true,
		close = true,
		description = 'Relógio obtido em roubo de joalheria.',
		client = {
			image = 'watch.png',
		},
	},

	['ring'] = {
		label = 'Anel Roubado',
		weight = 50,
		stack = true,
		close = true,
		description = 'Anel obtido em roubo de joalheria.',
		client = {
			image = 'ring.png',
		},
	},

	['goldbar'] = {
		label = 'Barra de Ouro',
		weight = 500,
		stack = true,
		close = true,
		description = 'Barra de ouro obtida em roubo de alto valor.',
		client = {
			image = 'goldbar.png',
		},
	},

    ['cocaempo'] = {
		label = 'Coca em Pó',
		weight = 20,
		stack = true,
		close = true,
		description = 'Matéria-prima da farm de cocaína.',
		client = {
			image = 'seoul_farm_cocaempo.png',
		},
	},

	['pastadecoca'] = {
		label = 'Pasta de Coca',
		weight = 30,
		stack = true,
		close = true,
		description = 'Pasta processada para produção de cocaína.',
		client = {
			image = 'seoul_farm_pastadecoca.png',
		},
	},

	['folhademaconha'] = {
		label = 'Folha de Maconha',
		weight = 10,
		stack = true,
		close = true,
		description = 'Matéria-prima da farm de maconha.',
		client = {
			image = 'seoul_farm_folhademaconha.png',
		},
	},

	['maconhamacerada'] = {
		label = 'Maconha Macerada',
		weight = 20,
		stack = true,
		close = true,
		description = 'Maconha preparada para embalagem.',
		client = {
			image = 'seoul_farm_maconhamacerada.png',
		},
	},

	['weed'] = {
		label = 'Maconha',
		weight = 20,
		stack = true,
		close = true,
		description = 'Produto final da farm de maconha.',
		client = {
			image = 'seoul_farm_weed.png',
		},
	},

	['acidobateria'] = {
		label = 'Ácido de Bateria',
		weight = 100,
		stack = true,
		close = true,
		description = 'Ingrediente da farm de metanfetamina.',
		client = {
			image = 'seoul_farm_acidobateria.png',
		},
	},

	['methliquid'] = {
		label = 'Metanfetamina Líquida',
		weight = 30,
		stack = true,
		close = true,
		description = 'Metanfetamina em fase líquida.',
		client = {
			image = 'seoul_farm_methliquid.png',
		},
	},

	['ecstasy'] = {
		label = 'Ecstasy',
		weight = 10,
		stack = true,
		close = true,
		description = 'Item de venda de drogas.',
		client = {
			image = 'seoul_farm_ecstasy.png',
		},
	},

	['lean'] = {
		label = 'Lean',
		weight = 150,
		stack = true,
		close = true,
		description = 'Item de venda de drogas.',
		client = {
			image = 'seoul_farm_lean.png',
		},
	},

	['lsd'] = {
		label = 'LSD',
		weight = 10,
		stack = true,
		close = true,
		description = 'Item de venda de drogas.',
		client = {
			image = 'seoul_farm_lsd.png',
		},
	},

	['detonador'] = {
		label = 'Detonador',
		weight = 250,
		stack = true,
		close = true,
		description = 'Item opcional para serviços de desmanche.',
		client = {
			image = 'seoul_farm_detonador.png',
		},
	},

    ['skate'] = {
		label = 'Skate',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Skate portátil.',
		client = {
			image = 'skate.png',
			event = 'skate',
		},
	},


    ['lb_tablet'] = {
        label = 'Seoul Tablet',
        weight = 1000,
        stack = false,
        close = true,
        description = 'Tablet oficial da Seoul com acesso a aplicativos, MDT, serviços policiais, médicos e utilitários.',
        client = {
            event = 'lb-tablet:openFromItem',
            image = 'lb_tablet.png',
        },
    },


	['a_c_cat_01'] = {
		label = 'Gato',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_cat_01.png',
		},
	},
	['a_c_husky'] = {
		label = 'Husky',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_husky.png',
		},
	},
	['a_c_poodle'] = {
		label = 'Poodle',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_poodle.png',
		},
	},
	['a_c_pug'] = {
		label = 'Pug',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_pug.png',
		},
	},
	['a_c_retriever'] = {
		label = 'Retriever',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_retriever.png',
		},
	},
	['a_c_rottweiler'] = {
		label = 'Rottweiler',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_rottweiler.png',
		},
	},
	['a_c_shepherd'] = {
		label = 'Shepherd',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_shepherd.png',
		},
	},
	['a_c_westy'] = {
		label = 'Westy',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'a_c_westy.png',
		},
	},
	['acetone'] = {
		label = 'Acetona',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'acetone.png',
		},
	},
	['adrenaline'] = {
		label = 'Adrenalina',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'adrenaline.png',
		},
	},
	['adrenalineplus'] = {
		label = 'Adrenalina ++',
		weight = 250,
		stack = true,
		close = true,
		description = 'Restaura o tempo ao ser ajudado com <common>Adrenalina</common>.',
		client = {
			image = 'adrenaline.png',
		},
	},
	['advtoolbox'] = {
		label = 'Conjunto de Ferramentas Mestre',
		weight = 4750,
		stack = true,
		close = true,
		description = 'Um arsenal versátil de ferramentas essenciais para todas as suas necessidades de reparo, com qualidade premium e variedade abrangente, este kit é seu parceiro e do seu veículos.',
		client = {
			image = 'advtoolbox.png',
		},
	},
	['alcohol'] = {
		label = 'Álcool',
		weight = 550,
		stack = true,
		close = true,
		client = {
			image = 'alcohol.png',
		},
	},
	['alliance'] = {
		label = 'Aliança',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'alliance.png',
		},
	},
	['alliance2'] = {
		label = 'Aliança de Diamante',
		weight = 0,
		stack = true,
		close = true,
		description = '<epic>Este item não pode ser roubado.</epic> Uma aliança luxuosa cravejada com um <epic>diamante brilhante</epic>. Símbolo de compromisso eterno ou riqueza extrema.',
		client = {
			image = 'alliance2.png',
		},
	},
	['alliance3'] = {
		label = 'Porta-Aliança de Diamante',
		weight = 0,
		stack = true,
		close = true,
		description = '<epic>Este item não pode ser roubado e, ao ser utilizado no alt + Relacionamento, gera dois itens que não podem ser roubados.</epic> Um pequeno estojo luxuoso, usado para guardar alianças de valor inestimável.',
		client = {
			image = 'alliance3.png',
		},
	},
	['aluminum'] = {
		label = 'Alumínio',
		weight = 45,
		stack = true,
		close = true,
		client = {
			image = 'aluminum.png',
		},
	},
	['ammobox'] = {
		label = 'Caixa de Munição',
		weight = 2750,
		stack = false,
		close = true,
		description = 'Robusta e segura, projetada para armazenamento e transporte confiável de munições.',
		client = {
			image = 'ammobox.png',
		},
	},
	['amphetamine'] = {
		label = 'Seringa de Anfetamina',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'amphetamine.png',
		},
	},
	['analgesic'] = {
		label = 'Analgésicos',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'analgesic.png',
		},
	},
	['anchovy'] = {
		label = 'Anchova',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'anchovy.png',
		},
	},
	['antiinfection'] = {
		label = 'Anti Infecção',
		weight = 500,
		stack = true,
		close = true,
		description = 'Utilizável para curar <common>Infecção</common>.',
		client = {
			image = 'antiinfection.png',
		},
	},
	['antipyretic'] = {
		label = 'Antipirético',
		weight = 500,
		stack = true,
		close = true,
		description = 'Utilizável para curar <common>Febre</common>.',
		client = {
			image = 'antipyretic.png',
		},
	},
	['applelove'] = {
		label = 'Maça do Amor',
		weight = 550,
		stack = true,
		close = true,
		client = {
			image = 'applelove.png',
		},
	},
	['ATTACH_CROSSHAIR'] = {
		label = 'Mira Holográfica',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'attach_crosshair.png',
		},
	},
	['ATTACH_FLASHLIGHT'] = {
		label = 'Lanterna Tatica',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'attach_flashlight.png',
		},
	},
	['ATTACH_GRIP'] = {
		label = 'Empunhadura',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'attach_grip.png',
		},
	},
	['ATTACH_MAGAZINE'] = {
		label = 'Pente Estendido',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'attach_magazine.png',
		},
	},
	['ATTACH_SILENCER'] = {
		label = 'Silenciador',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'attach_silencer.png',
		},
	},
	['axe'] = {
		label = 'Machadinha',
		weight = 2750,
		stack = true,
		close = true,
		description = 'Ferramenta robusta e confiável para os desafios mais exigentes, construído com materiais de alta qualidade e design ergonômico, proporciona precisão e potência em cada golpe, ideal para cortar lenha, realizar trabalhos de construção ou aventuras ao ar livre, é o companheiro perfeito para qualquer tarefa que exija força e eficiência.',
		client = {
			image = 'axe.png',
		},
	},
	['axeplus'] = {
		label = 'Machadinha ++',
		weight = 2750,
		stack = true,
		close = true,
		description = 'Ferramenta robusta e confiável para os desafios mais exigentes, construído com materiais de alta qualidade e design ergonômico, proporciona precisão e potência em cada golpe, ideal para cortar lenha, realizar trabalhos de construção ou aventuras ao ar livre, é o companheiro perfeito para qualquer tarefa que exija força e eficiência.',
		client = {
			image = 'axe.png',
		},
	},
	['backpackg'] = {
		label = 'Mochila Grande',
		weight = 2500,
		stack = true,
		close = true,
		description = 'Espaçosa e funcional, projetada para transportar muitos itens de forma confortável, com alças ajustáveis e compartimentos organizados para facilitar o armazenamento.<br>Aumenta o peso de sua mochila em <epic>100Kg</epic>.',
		client = {
			image = 'backpackg.png',
		},
	},
	['backpackm'] = {
		label = 'Mochila Média',
		weight = 2500,
		stack = true,
		close = true,
		description = 'Versátil e compacta, ideal para o dia a dia, oferecendo espaço suficiente para itens essenciais sem ser volumosa, com alças confortáveis para fácil transporte.<br>Aumenta o peso de sua mochila em <epic>75Kg</epic>.',
		client = {
			image = 'backpackm.png',
		},
	},
	['backpackp'] = {
		label = 'Mochila Pequena',
		weight = 2500,
		stack = true,
		close = true,
		description = 'Compacta e leve, perfeita para carregar o essencial de forma prática, com alças ajustáveis para conforto ao transportar.<br>Aumenta o peso de sua mochila em <epic>50Kg</epic>.',
		client = {
			image = 'backpackp.png',
		},
	},
	['bait'] = {
		label = 'Isca',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'bait.png',
		},
	},
	['ballisticplate'] = {
		label = 'Placa Balística',
		weight = 3750,
		stack = true,
		close = true,
		client = {
			image = 'ballisticplate.png',
		},
	},
	['bandage'] = {
		label = 'Bandagem',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'bandage.png',
		},
	},
	['barbershop'] = {
		label = 'Barbearia',
		weight = 0,
		stack = true,
		close = true,
		description = 'Define uma posição no mapa onde a <epic>Barbearia</epic> poderá ser acessada.',
		client = {
			image = 'barbershop.png',
		},
	},
	['barrier'] = {
    label = 'Barreira',
    weight = 2250,
    stack = true,
    close = true,
    consume = 0,
    client = {
        image = 'barrier.png',
    },
    },
	['basket'] = {
		label = 'Cesta',
		weight = 5000,
		stack = true,
		close = true,
		client = {
			image = 'basket.png',
		},
	},
	['batteryaa'] = {
		label = 'Bateria AA',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'batteryaa.png',
		},
	},
	['batteryaaplus'] = {
		label = 'Bateria AA+',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'batteryaaplus.png',
		},
	},
	['bauxite'] = {
		label = 'Minério de Bauxita',
		weight = 225,
		stack = true,
		close = true,
		client = {
			image = 'bauxite.png',
		},
	},
	['binbag'] = {
		label = 'Saco de Lixo',
		weight = 10000,
		stack = true,
		close = true,
		client = {
			image = 'binbag.png',
		},
	},
	['binoculars'] = {
		label = 'Binóculos',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'binoculars.png',
		},
	},
	['black_money'] = {
		label = 'black_money',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'black_money.png',
		},
	},
	['blocksignal'] = {
		label = 'Bloqueador de Sinal',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'blocksignal.png',
		},
	},
	['blue_essence'] = {
		label = 'Essência Azul',
		weight = 0,
		stack = true,
		close = true,
		description = 'Componente químico utilizado em experimentos, possui propriedades energéticas únicas que alimentam dispositivos experimentais, aprimoram armas modificadas ou são vendidas por um bom dinheiro.',
		client = {
			image = 'blue_essence.png',
		},
	},
	['blueprint_acetone'] = {
		label = 'Aprendizado: Acetona',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Acetona</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_alcohol'] = {
		label = 'Aprendizado: Álcool',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Álcool</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_aluminum'] = {
		label = 'Aprendizado: Alumínio',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Alumínio</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_analgesic'] = {
		label = 'Aprendizado: Analgésicos',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Analgésicos</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_ATTACH_CROSSHAIR'] = {
		label = 'Aprendizado: Mira Holográfica',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Mira Holográfica</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_ATTACH_FLASHLIGHT'] = {
		label = 'Aprendizado: Lanterna Tatica',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Lanterna Tatica</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_ATTACH_GRIP'] = {
		label = 'Aprendizado: Empunhadura',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Empunhadura</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_ATTACH_MAGAZINE'] = {
		label = 'Aprendizado: Pente Estendido',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Pente Estendido</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_ATTACH_SILENCER'] = {
		label = 'Aprendizado: Silenciador',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Silenciador</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_bandage'] = {
		label = 'Aprendizado: Bandagem',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Bandagem</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_batteryaa'] = {
		label = 'Aprendizado: Bateria AA',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Bateria AA</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_batteryaaplus'] = {
		label = 'Aprendizado: Bateria AA+',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Bateria AA+</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_bench'] = {
		label = 'Mesa de Aprendizado',
		weight = 7250,
		stack = true,
		close = true,
		description = 'Mesa para aprendizado de produção.',
		client = {
			image = 'blueprint_bench.png',
		},
	},
	['blueprint_circuit'] = {
		label = 'Aprendizado: Circuito Eletrônico',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Circuito Eletrônico</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_copper'] = {
		label = 'Aprendizado: Cobre',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Cobre</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_electroniccomponents'] = {
		label = 'Aprendizado: Componentes Eletrônicos',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Componentes Eletrônicos</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_explosives'] = {
		label = 'Aprendizado: Explosivos',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Explosivos</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_fragment'] = {
		label = 'Fragmento de Aprendizado',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'blueprint_fragment.png',
		},
	},
	['blueprint_gauze'] = {
		label = 'Aprendizado: Ataduras',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Ataduras</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_gear'] = {
		label = 'Aprendizado: Engrenagem',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Engrenagem</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_glass'] = {
		label = 'Aprendizado: Vidro',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Vidro</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_goldnecklace'] = {
		label = 'Aprendizado: Colar de Ouro',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Colar de Ouro</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_gunpowder'] = {
		label = 'Aprendizado: Frasco de Pólvora',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Frasco de Pólvora</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_horsefigurine'] = {
		label = 'Aprendizado: Estatueta de Cavalo',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Estatueta de Cavalo</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_insulatingtape'] = {
		label = 'Aprendizado: Fita Isolante',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Fita Isolante</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_latex'] = {
		label = 'Aprendizado: Látex',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Látex</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_medkit'] = {
		label = 'Aprendizado: Kit de Primeiros Socorros',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Kit de Primeiros Socorros</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_metalspring'] = {
		label = 'Aprendizado: Mola de Metal',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Mola de Metal</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_pistolbody'] = {
		label = 'Aprendizado: Corpo de Pistola',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Corpo de Pistola</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_plastic'] = {
		label = 'Aprendizado: Plástico',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Plástico</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_powercable'] = {
		label = 'Aprendizado: Cabo de Alimentação',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Cabo de Alimentação</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_powersupply'] = {
		label = 'Aprendizado: Fonte de Alimentação',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Fonte de Alimentação</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_processor'] = {
		label = 'Aprendizado: Processador',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Processador</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_processorfan'] = {
		label = 'Aprendizado: Ventoinha do Processador',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Ventoinha do Processador</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_rammemory'] = {
		label = 'Aprendizado: Memória RAM',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Memória RAM</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_riflebody'] = {
		label = 'Aprendizado: Corpo de Rifle',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Corpo de Rifle</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_ritmoneury'] = {
		label = 'Aprendizado: Ritmoneury',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Ritmoneury</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_roadsigns'] = {
		label = 'Aprendizado: Placas de Trânsito',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Placas de Trânsito</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_rubber'] = {
		label = 'Aprendizado: Borracha',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Borracha</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_safependrive'] = {
		label = 'Aprendizado: Pendrive Seguro',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Pendrive Seguro</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_saline'] = {
		label = 'Aprendizado: Soro Fisiológico',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Soro Fisiológico</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_scotchtape'] = {
		label = 'Aprendizado: Fita Adesiva',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Fita Adesiva</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_screwnuts'] = {
		label = 'Aprendizado: Porcas de Parafuso',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Porcas de Parafuso</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_screws'] = {
		label = 'Aprendizado: Parafusos',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Parafusos</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_sheetmetal'] = {
		label = 'Aprendizado: Chapa de Metal',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Chapa de Metal</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_silverchain'] = {
		label = 'Aprendizado: Corrente de Prata',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Corrente de Prata</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_sinkalmy'] = {
		label = 'Aprendizado: Sinkalmy',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Sinkalmy</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_smgbody'] = {
		label = 'Aprendizado: Corpo de Sub',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Corpo de Sub</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_ssddrive'] = {
		label = 'Aprendizado: Unidade SSD',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Unidade SSD</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_sulfuric'] = {
		label = 'Aprendizado: Ácido Sulfúrico',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Ácido Sulfúrico</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_tarp'] = {
		label = 'Aprendizado: Lona',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Lona</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_techtrash'] = {
		label = 'Aprendizado: Lixo Eletrônico',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Lixo Eletrônico</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_toothpaste'] = {
		label = 'Aprendizado: Pasta de Dente',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Pasta de Dente</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_videocard'] = {
		label = 'Aprendizado: Placa de Vídeo',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Placa de Vídeo</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_ADVANCEDRIFLE'] = {
		label = 'Aprendizado: MDR',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>MDR</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_APPISTOL'] = {
		label = 'Aprendizado: Koch Vp9',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Koch Vp9</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_ASSAULTRIFLE'] = {
		label = 'Aprendizado: AK74N',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>AK74N</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_ASSAULTRIFLE_MK2'] = {
		label = 'Aprendizado: AK102',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>AK102</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_ASSAULTSMG'] = {
		label = 'Aprendizado: F2000',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>F2000</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_BULLPUPRIFLE'] = {
		label = 'Aprendizado: QBZ-95',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>QBZ-95</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_BULLPUPRIFLE_MK2'] = {
		label = 'Aprendizado: L85',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>L85</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_CARBINERIFLE'] = {
		label = 'Aprendizado: M4A1',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>M4A1</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_CARBINERIFLE_MK2'] = {
		label = 'Aprendizado: H416',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>H416</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_COMBATPISTOL'] = {
		label = 'Aprendizado: G18C',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>G18C</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_COMPACTRIFLE'] = {
		label = 'Aprendizado: AKS74U',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>AKS74U</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_GUSENBERG'] = {
		label = 'Aprendizado: MPF45',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>MPF45</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_HEAVYPISTOL'] = {
		label = 'Aprendizado: M45A1',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>M45A1</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_HEAVYRIFLE'] = {
		label = 'Aprendizado: Scar-H',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Scar-H</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_MACHINEPISTOL'] = {
		label = 'Aprendizado: Tec-9',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Tec-9</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_MICROSMG'] = {
		label = 'Aprendizado: Uzi',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Uzi</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_MINISMG'] = {
		label = 'Aprendizado: MAC-10',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>MAC-10</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_MOLOTOV'] = {
		label = 'Aprendizado: Coquetel Molotov',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Coquetel Molotov</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_MUSKET'] = {
		label = 'Aprendizado: Winchester 1892',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Winchester 1892</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_MUSKET_AMMO'] = {
		label = 'Aprendizado: Munição de Mosquete',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Munição de Mosquete</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_PISTOL'] = {
		label = 'Aprendizado: M1911',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>M1911</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_PISTOL50'] = {
		label = 'Aprendizado: Deagle',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Deagle</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_PISTOL_AMMO'] = {
		label = 'Aprendizado: Munição de Pistola',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Munição de Pistola</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_PISTOL_MK2'] = {
		label = 'Aprendizado: T54',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>T54</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_PUMPSHOTGUN'] = {
		label = 'Aprendizado: M870',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>M870</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_PUMPSHOTGUN_MK2'] = {
		label = 'Aprendizado: MP133',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>MP133</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_RIFLE_AMMO'] = {
		label = 'Aprendizado: Munição de Rifle',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Munição de Rifle</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SAWNOFFSHOTGUN'] = {
		label = 'Aprendizado: Mossberg 500',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Mossberg 500</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SHOTGUN_AMMO'] = {
		label = 'Aprendizado: Munição de Espingarda',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Munição de Espingarda</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SMG'] = {
		label = 'Aprendizado: MP5',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>MP5</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SMG_AMMO'] = {
		label = 'Aprendizado: Munição de Sub',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Munição de Sub</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SMG_MK2'] = {
		label = 'Aprendizado: MPX',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>MPX</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SMOKEGRENADE'] = {
		label = 'Aprendizado: Granada de Fumaça',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Granada de Fumaça</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SNSPISTOL'] = {
		label = 'Aprendizado: F57',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>F57</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SNSPISTOL_MK2'] = {
		label = 'Aprendizado: CZ52',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>CZ52</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SPECIALCARBINE'] = {
		label = 'Aprendizado: G36C',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>G36C</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_SPECIALCARBINE_MK2'] = {
		label = 'Aprendizado: Sig Sauer 556',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Sig Sauer 556</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_STUNGUN'] = {
		label = 'Aprendizado: Tazer',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Tazer</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_TACTICALRIFLE'] = {
		label = 'Aprendizado: M16',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>M16</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_WEAPON_VINTAGEPISTOL'] = {
		label = 'Aprendizado: M1922',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>M1922</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['blueprint_weaponparts'] = {
		label = 'Aprendizado: Peças de Armas',
		weight = 0,
		stack = true,
		close = true,
		description = 'Após a utilização deste fragmento você se especializa na produção de <epic>Peças de Armas</epic>.',
		client = {
			image = 'blueprint.png',
		},
	},
	['boar1star'] = {
		label = 'Javali',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box1star.png',
		},
	},
	['boar2star'] = {
		label = 'Javali',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box2star.png',
		},
	},
	['boar3star'] = {
		label = 'Javali',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box3star.png',
		},
	},
	['bronzeegg'] = {
		label = 'Ovo de Bronze',
		weight = 100,
		stack = true,
		close = true,
		description = 'Especial de Páscoa.',
		client = {
			image = 'bronzeegg.png',
		},
	},
	['bucket'] = {
		label = 'Balde',
		weight = 1500,
		stack = true,
		close = true,
		client = {
			image = 'bucket.png',
		},
	},
	['burger'] = {
		label = 'burger',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'burger.png',
		},
	},
	['c4'] = {
		label = 'Explosivo C4',
		weight = 1250,
		stack = true,
		close = true,
		client = {
			image = 'c4.png',
		},
	},
	['camera'] = {
		label = 'Câmera',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'camera.png',
		},
	},
	['cappuccino'] = {
		label = 'Cappuccino',
		weight = 650,
		stack = true,
		close = true,
		client = {
			image = 'cappuccino.png',
		},
	},
	['catfish'] = {
		label = 'Peixe-Gato',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'catfish.png',
		},
	},
	['cellphone'] = {
		label = 'Celular',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'cellphone.png',
		},
	},
	['chalcopyrite'] = {
		label = 'Calcopirita',
		weight = 225,
		stack = true,
		close = true,
		client = {
			image = 'chalcopyrite.png',
		},
	},
	['chestgroupg'] = {
		label = 'Compartimento Militar',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Projetado para manter seus e de seu grupo, itens mais valiosos protegidos e sempre ao seu alcance, com capacidade máxima de <b>5.000kg</b>, ele combina segurança, praticidade e organização em um único espaço.<br><common>Ao posicionado não pode ser retirado.</common>',
		client = {
			image = 'chestgroup.png',
		},
	},
	['chestgroupm'] = {
		label = 'Compartimento Militar',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Projetado para manter seus e de seu grupo, itens mais valiosos protegidos e sempre ao seu alcance, com capacidade máxima de <b>2.500kg</b>, ele combina segurança, praticidade e organização em um único espaço.<br><common>Ao posicionado não pode ser retirado.</common>',
		client = {
			image = 'chestgroup.png',
		},
	},
	['chestgroupp'] = {
		label = 'Compartimento Militar',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Projetado para manter seus e de seu grupo, itens mais valiosos protegidos e sempre ao seu alcance, com capacidade máxima de <b>1.000kg</b>, ele combina segurança, praticidade e organização em um único espaço.<br><common>Ao posicionado não pode ser retirado.</common>',
		client = {
			image = 'chestgroup.png',
		},
	},
	['chocolate'] = {
		label = 'Chocolate',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'chocolate.png',
		},
	},
	['cigarette'] = {
		label = 'Maço de Cigarros',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'cigarette.png',
		},
	},
	['circuit'] = {
		label = 'Circuito Eletrônico',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'circuit.png',
		},
	},
	['cocaine'] = {
		label = 'Carreira de Cocaína',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'cocaine.png',
		},
	},
	['codeine'] = {
		label = 'Seringa de Codeína',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'codeine.png',
		},
	},
	['coffeecup'] = {
		label = 'Copo de Café',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'coffeecup.png',
		},
	},
	['coilover'] = {
		label = 'Suspensão Coilover',
		weight = 15250,
		stack = true,
		close = true,
		description = 'Projetada para oferecer ajustabilidade extrema e resposta rápida em curvas fechadas e mudanças de direção rápidas, ajuda a maximizar a aderência nas curvas e proporcionar uma sensação precisa e controlada ao volante, fundamental para executar manobras precisas e controladas durante as competições de drift.',
		client = {
			image = 'coilover.png',
		},
	},
	['cokesack'] = {
		label = 'Pacote de Cocaína',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'cokesack.png',
		},
	},
	['cola'] = {
		label = 'Cola',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'cola.png',
		},
	},
	['complaint'] = {
		label = 'Antigripal',
		weight = 500,
		stack = true,
		close = true,
		description = 'Utilizável para curar <common>Gripe</common>.',
		client = {
			image = 'complaint.png',
		},
	},
	['condensedmilk'] = {
		label = 'Leite Condensado',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'condensedmilk.png',
		},
	},
	['cookies'] = {
		label = 'Cookies',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'cookies.png',
		},
	},
	['copper'] = {
		label = 'Cobre',
		weight = 45,
		stack = true,
		close = true,
		client = {
			image = 'copper.png',
		},
	},
	['copper_pure'] = {
		label = 'Barra de Cobre',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'copper_pure.png',
		},
	},
	['coyote1star'] = {
		label = 'Coyote',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box1star.png',
		},
	},
	['coyote2star'] = {
		label = 'Coyote',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box2star.png',
		},
	},
	['coyote3star'] = {
		label = 'Coyote',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box3star.png',
		},
	},
	['crack'] = {
		label = 'Seringa de Crack',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'crack.png',
		},
	},
	['creditcard'] = {
		label = 'Cartão de Crédito',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'creditcard.png',
		},
	},
	['cupcake'] = {
		label = 'Cupcake',
		weight = 550,
		stack = true,
		close = true,
		client = {
			image = 'cupcake.png',
		},
	},
	['deer1star'] = {
		label = 'Cervo',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box1star.png',
		},
	},
	['deer2star'] = {
		label = 'Cervo',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box2star.png',
		},
	},
	['deer3star'] = {
		label = 'Cervo',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box3star.png',
		},
	},
	['diagram'] = {
		label = 'Diagrama',
		weight = 750,
		stack = true,
		close = true,
		description = 'Aumenta <common>10Kg</common> no peso do compartimento.',
		client = {
			image = 'diagram.png',
		},
	},
	['diamond_pure'] = {
		label = 'Diamante Lapidado',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'diamond_pure.png',
		},
	},
	['dirtydollar'] = {
		label = 'Dólar Sujo',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'dirtydollar.png',
		},
	},
	['dismantle'] = {
		label = 'Cartão Ilegível',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'dismantle.png',
		},
	},
	['dogtag'] = {
		label = 'Plaqueta de Identificação',
		weight = 25,
		stack = true,
		close = true,
		client = {
			image = 'dogtag.png',
		},
	},
	['dollar'] = {
		label = 'Dólar',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'dollar.png',
		},
	},
	['donut'] = {
		label = 'Rosquinha',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'donut.png',
		},
	},
	['drugs_bench'] = {
		label = 'Mesa de Produção',
		weight = 7250,
		stack = true,
		close = true,
		description = 'Mesa para fabricação de <common>Drogas</common>.',
		client = {
			image = 'drugs_bench.png',
		},
	},
	['electroniccomponents'] = {
		label = 'Componentes Eletrônicos',
		weight = 350,
		stack = true,
		close = true,
		client = {
			image = 'electroniccomponents.png',
		},
	},
	['emerald_pure'] = {
		label = 'Esmeralda Lapidada',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'emerald_pure.png',
		},
	},
	['emptybottle'] = {
		label = 'Garrafa Vazia',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'emptybottle.png',
		},
	},
	['emptypurifiedwater'] = {
		label = 'Galão de Água Vazio',
		weight = 750,
		stack = true,
		close = true,
		description = 'Prático para transporte e armazenamento, ideal para reutilização ou descarte responsável.',
		client = {
			image = 'emptypurifiedwater.png',
		},
	},
	['energetic'] = {
		label = 'Energético',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'energetic.png',
		},
	},
	['explosives'] = {
		label = 'Explosivos',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'explosives.png',
		},
	},
	['fishfillet'] = {
		label = 'Filé de Peixe',
		weight = 50,
		stack = true,
		close = true,
		client = {
			image = 'fishfillet.png',
		},
	},
	['fishingrod'] = {
		label = 'Vara de Madeira',
		weight = 2750,
		stack = true,
		close = true,
		description = 'Companheira ideal para os amantes da pesca, seja em água doce ou salgada, com sua construção leve e resistente, proporciona equilíbrio perfeito e sensibilidade para detectar até os mais sutis movimentos dos peixes, seja para pescadores iniciantes ou experientes, esta vara é a escolha confiável para horas de diversão e sucesso nas pescarias.',
		client = {
			image = 'fishingrod.png',
		},
	},
	['fishingrodplus'] = {
		label = 'Vara de Pescar ++',
		weight = 2750,
		stack = true,
		close = true,
		description = 'Companheira ideal para os amantes da pesca, seja em água doce ou salgada, com sua construção leve e resistente, proporciona equilíbrio perfeito e sensibilidade para detectar até os mais sutis movimentos dos peixes, seja para pescadores iniciantes ou experientes, esta vara é a escolha confiável para horas de diversão e sucesso nas pescarias.',
		client = {
			image = 'fishingrodplus.png',
		},
	},
	['fries'] = {
		label = 'Fritas',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'fries.png',
		},
	},
	['GADGET_PARACHUTE'] = {
		label = 'Paraquedas',
		weight = 2250,
		stack = true,
		close = true,
		description = 'Lembrando que após <common>desconectar</common> da cidade o mesmo é removido.',
		client = {
			image = 'parachute.png',
		},
	},
	['gauze'] = {
		label = 'Ataduras',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'gauze.png',
		},
	},
	['gdtkit'] = {
		label = 'Kit Químico',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'gdtkit.png',
		},
	},
	['gear'] = {
		label = 'Engrenagem',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'gear.png',
		},
	},
	['gemstone'] = {
		label = 'Diamante',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'gemstone.png',
		},
	},
	['glass'] = {
		label = 'Vidro',
		weight = 45,
		stack = true,
		close = true,
		client = {
			image = 'glass.png',
		},
	},
	['gold_pure'] = {
		label = 'Barra de Ouro',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'gold_pure.png',
		},
	},
	['goldegg'] = {
		label = 'Ovo de Ouro',
		weight = 100,
		stack = true,
		close = true,
		description = 'Especial de Páscoa.',
		client = {
			image = 'goldegg.png',
		},
	},
	['goldenjug'] = {
		label = 'Jarro de Ouro',
		weight = 7250,
		stack = true,
		close = true,
		client = {
			image = 'goldenjug.png',
		},
	},
	['goldenleopard'] = {
		label = 'Leopardo de Ouro',
		weight = 8750,
		stack = true,
		close = true,
		client = {
			image = 'goldenleopard.png',
		},
	},
	['goldenlion'] = {
		label = 'Leão de Ouro',
		weight = 10250,
		stack = true,
		close = true,
		client = {
			image = 'goldenlion.png',
		},
	},
	['goldnecklace'] = {
		label = 'Colar de Ouro',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'goldnecklace.png',
		},
	},
	['graphite01'] = {
		label = 'Grafite Vermelho',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Repare o <rare>Freio Integral</rare> do veículo.',
		client = {
			image = 'graphite01.png',
		},
	},
	['graphite02'] = {
		label = 'Grafite Verde',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Repare o <rare>Freio Dianteiro</rare> do veículo.',
		client = {
			image = 'graphite02.png',
		},
	},
	['graphite03'] = {
		label = 'Grafite Azul',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Repare o <rare>Freio Traseiro</rare> do veículo.',
		client = {
			image = 'graphite03.png',
		},
	},
	['green_essence'] = {
		label = 'Essência Verde',
		weight = 0,
		stack = true,
		close = true,
		description = 'Componente químico utilizado em experimentos, possui propriedades energéticas únicas que alimentam dispositivos experimentais, aprimoram armas modificadas ou são vendidas por um bom dinheiro.',
		client = {
			image = 'green_essence.png',
		},
	},
	['gsrkit'] = {
		label = 'Kit Residual',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'gsrkit.png',
		},
	},
	['gunpowder'] = {
		label = 'Frasco de Pólvora',
		weight = 100,
		stack = true,
		close = true,
		client = {
			image = 'gunpowder.png',
		},
	},
	['hamburger'] = {
		label = 'Hambúrguer',
		weight = 550,
		stack = true,
		close = true,
		client = {
			image = 'hamburger.png',
		},
	},
	['hamburger2'] = {
		label = 'Hambúrguer Artesanal',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'hamburger2.png',
		},
	},
	['hamburger3'] = {
		label = 'Hambúrguer Vegetariano',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'hamburger3.png',
		},
	},
    ['handcuff'] = {
        label = 'Algemas',
        weight = 1250,
        stack = true,
        close = true,
        consume = 0,
        client = {
            image = 'handcuff.png',
        },
    },
	['heroin'] = {
		label = 'Seringa de Heroína',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'heroin.png',
		},
	},
	['herring'] = {
		label = 'Arenque',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'herring.png',
		},
	},
	['hood'] = {
		label = 'Capuz',
		weight = 1750,
		stack = true,
		close = true,
		client = {
			image = 'hood.png',
		},
	},
	['horsefigurine'] = {
		label = 'Estatueta de Cavalo',
		weight = 1250,
		stack = true,
		close = true,
		client = {
			image = 'horsefigurine.png',
		},
	},
	['hotdog'] = {
		label = 'Cachorro-Quente',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'hotdog.png',
		},
	},
	['identity'] = {
		label = 'Passaporte',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'identity.png',
		},
	},
	['instagram'] = {
		label = 'Seguidores InstaPic',
		weight = 0,
		stack = true,
		close = true,
		description = 'Adiciona 100 seguidores no instapic.',
		client = {
			image = 'instagram.png',
		},
	},
	['insulatingtape'] = {
		label = 'Fita Isolante',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'insulatingtape.png',
		},
	},
	['intoxication'] = {
		label = 'Anti Intoxicação',
		weight = 500,
		stack = true,
		close = true,
		description = 'Utilizável para curar <common>Intoxicação</common>.',
		client = {
			image = 'intoxication.png',
		},
	},
	['iron_pure'] = {
		label = 'Barra de Ferro',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'iron_pure.png',
		},
	},
	['ironfilings'] = {
		label = 'Limalha de Ferro',
		weight = 1,
		stack = true,
		close = true,
		client = {
			image = 'ironfilings.png',
		},
	},
	['joint'] = {
		label = 'Cigarro de Cannabis',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'joint.png',
		},
	},
	['key'] = {
		label = 'Chave',
		weight = 100,
		stack = true,
		close = true,
		client = {
			image = 'key.png',
		},
	},
	['latex'] = {
		label = 'Frasco de Látex',
		weight = 1250,
		stack = true,
		close = true,
		client = {
			image = 'latex.png',
		},
	},
	['laundromataccess'] = {
		label = 'Chave de Acesso',
		weight = 0,
		stack = true,
		close = true,
		description = 'Utilizada para liberar o acesso a Lavanderia.',
		client = {
			image = 'laundromataccess.png',
		},
	},
	['lead_pure'] = {
		label = 'Barra de Chumbo',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'lead_pure.png',
		},
	},
	['legendarykey'] = {
		label = 'Chave da Fortuna',
		weight = 250,
		stack = true,
		close = true,
		description = 'Projetada para ser encontrada e utilizada como parte da progressão na história ou na resolução de um enigma, adicionando um elemento de interatividade e imersão à experiência.',
		client = {
			image = 'legendarykey.png',
		},
	},
	['lighter'] = {
		label = 'Isqueiro',
		weight = 550,
		stack = true,
		close = true,
		client = {
			image = 'lighter.png',
		},
	},
	['lockpick'] = {
		label = 'Gazua',
		weight = 1250,
		stack = true,
		close = true,
		description = 'Ferramenta fina e flexível, frequentemente feita de metal, usada para abrir fechaduras sem a chave correspondente, é uma ferramenta comum entre profissionais de segurança e em situações de emergência.',
		client = {
			image = 'lockpick.png',
		},
	},
	['mapgps'] = {
		label = 'Mapa Adaptativo',
		weight = 0,
		stack = true,
		close = true,
		description = 'Um dispositivo inteligente que, ao ser utilizado, ativa o gps no canto da tela, permitindo ao usuário visualizar melhor o terreno ao redor, rotas e a localização de pontos importantes. Ideal para navegação em áreas desconhecidas ou para ganhar vantagem tática em missões.',
		client = {
			image = 'mapgps.png',
		},
	},
	['mayonnaise'] = {
		label = 'Pote de Maionese',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'mayonnaise.png',
		},
	},
	['meatfillet'] = {
		label = 'Filé de Carne',
		weight = 50,
		stack = true,
		close = true,
		client = {
			image = 'meatfillet.png',
		},
	},
	['medicalkey'] = {
		label = 'Chave da Aurora',
		weight = 250,
		stack = true,
		close = true,
		description = 'Projetada para ser encontrada e utilizada como parte da progressão na história ou na resolução de um enigma, adicionando um elemento de interatividade e imersão à experiência.',
		client = {
			image = 'medicalkey.png',
		},
	},
	['medicbag'] = {
		label = 'Caixa de Medicamentos',
		weight = 2500,
		stack = false,
		close = true,
		description = 'Projetada para armazenamento seguro e organizado de medicamentos, garantindo acessibilidade e segurança no ambiente de saúde.',
		client = {
			image = 'medicbag.png',
		},
	},
	['medicshop'] = {
		label = 'Bolsa Médica',
		weight = 5000,
		stack = true,
		close = true,
		client = {
			image = 'medicshop.png',
		},
	},
	['medkit'] = {
		label = 'Kit de Primeiros Socorros',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'medkit.png',
		},
	},
	['metadone'] = {
		label = 'Seringa de Metadona',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'metadone.png',
		},
	},
	['metalspring'] = {
		label = 'Mola de Metal',
		weight = 350,
		stack = true,
		close = true,
		client = {
			image = 'metalspring.png',
		},
	},
	['meth'] = {
		label = 'Metanfetamina',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'meth.png',
		},
	},
	['methsack'] = {
		label = 'Pacote de Metanfetamina',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'methsack.png',
		},
	},
	['milkbottle'] = {
		label = 'Garrafa de Leite',
		weight = 350,
		stack = true,
		close = true,
		client = {
			image = 'milkbottle.png',
		},
	},
	['milkshake'] = {
		label = 'Milk-shake',
		weight = 850,
		stack = true,
		close = true,
		client = {
			image = 'milkshake.png',
		},
	},
	['money'] = {
		label = 'money',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'money.png',
		},
	},
	['moneywash'] = {
		label = 'Máquina de Lavar',
		weight = 50000,
		stack = true,
		close = true,
		description = 'Compacta e discreta que transforma dinheiro molhado em dinheiro limpo e pronto para uso, seja para jogos ou necessidades do dia a dia, esta máquina é a solução perfeita para lavagem de dinheiro de forma rápida e eficiente.<br><br><common>Lavagem diária: $250.000</common>',
		client = {
			image = 'moneywash.png',
		},
	},
	['moneywashalpha'] = {
		label = 'Máquina de Lavar',
		weight = 50000,
		stack = true,
		close = true,
		description = 'Compacta e discreta que transforma dinheiro molhado em dinheiro limpo e pronto para uso, seja para jogos ou necessidades do dia a dia, esta máquina é a solução perfeita para lavagem de dinheiro de forma rápida e eficiente.<br><br><epic>Lavagem diária: $1.000.000</epic>',
		client = {
			image = 'moneywash.png',
		},
	},
	['moneywashomega'] = {
		label = 'Máquina de Lavar',
		weight = 50000,
		stack = true,
		close = true,
		description = 'Compacta e discreta que transforma dinheiro molhado em dinheiro limpo e pronto para uso, seja para jogos ou necessidades do dia a dia, esta máquina é a solução perfeita para lavagem de dinheiro de forma rápida e eficiente.<br><br><legendary>Lavagem diária: $5.000.000</legendary>',
		client = {
			image = 'moneywash.png',
		},
	},
	['moneywashplus'] = {
		label = 'Máquina de Lavar',
		weight = 50000,
		stack = true,
		close = true,
		description = 'Compacta e discreta que transforma dinheiro molhado em dinheiro limpo e pronto para uso, seja para jogos ou necessidades do dia a dia, esta máquina é a solução perfeita para lavagem de dinheiro de forma rápida e eficiente.<br><br><rare>Lavagem diária: $500.000</rare>',
		client = {
			image = 'moneywash.png',
		},
	},
	['mtlion1star'] = {
		label = 'Puma',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box1star.png',
		},
	},
	['mtlion2star'] = {
		label = 'Puma',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box2star.png',
		},
	},
	['mtlion3star'] = {
		label = 'Puma',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'box3star.png',
		},
	},
	['namechange'] = {
		label = 'Cartão de Nome',
		weight = 0,
		stack = true,
		close = true,
		description = 'Modifica o nome.',
		client = {
			image = 'namechange.png',
		},
	},
	['newchars'] = {
		label = 'Cartão de Personagem',
		weight = 0,
		stack = true,
		close = true,
		description = 'Aumenta 1 no limite de personagens.',
		client = {
			image = 'newchars.png',
		},
	},
	['nigirizushi'] = {
		label = 'Nigirizushi',
		weight = 650,
		stack = true,
		close = true,
		client = {
			image = 'nigirizushi.png',
		},
	},
	['nitro'] = {
		label = 'Garrafa de Nitro',
		weight = 7250,
		stack = true,
		close = true,
		description = 'Uma adição emocionante para veículos motorizados, oferece um aumento instantâneo de potência e velocidade, projetado para os entusiastas da velocidade, proporciona uma aceleração surpreendente, elevando a adrenalina e a emoção das corridas e aventuras automobilísticas.',
		client = {
			image = 'nitro.png',
		},
	},
	['notepad'] = {
		label = 'Bloco de Notas',
		weight = 0,
		stack = false,
		close = true,
		client = {
			image = 'notepad.png',
		},
	},
	['orangeroughy'] = {
		label = 'Peixe Relógio',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'orangeroughy.png',
		},
	},
	['package'] = {
		label = 'Encomenda',
		weight = 10000,
		stack = true,
		close = true,
		client = {
			image = 'package.png',
		},
	},
	['pager'] = {
		label = 'Pager',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'pager.png',
		},
	},
	['personalg'] = {
		label = 'Compartimento Pessoal',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Projetado para manter seus itens mais valiosos protegidos e sempre ao seu alcance, com capacidade máxima de <b>500kg</b>, ele combina segurança, praticidade e organização em um único espaço.<br><common>Ao posicionado não pode ser retirado.</common>',
		client = {
			image = 'personal.png',
		},
	},
	['personalm'] = {
		label = 'Compartimento Pessoal',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Projetado para manter seus itens mais valiosos protegidos e sempre ao seu alcance, com capacidade máxima de <b>250kg</b>, ele combina segurança, praticidade e organização em um único espaço.<br><common>Ao posicionado não pode ser retirado.</common>',
		client = {
			image = 'personal.png',
		},
	},
	['personalp'] = {
		label = 'Compartimento Pessoal',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Projetado para manter seus itens mais valiosos protegidos e sempre ao seu alcance, com capacidade máxima de <b>100kg</b>, ele combina segurança, praticidade e organização em um único espaço.<br><common>Ao posicionado não pode ser retirado.</common>',
		client = {
			image = 'personal.png',
		},
	},
	['phone'] = {
		label = 'phone',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'phone.png',
		},
	},
	['pickaxe'] = {
		label = 'Picareta',
		weight = 2750,
		stack = true,
		close = true,
		description = 'Ferramenta versátil e resistente, projetada para lidar com uma variedade de tarefas, com sua construção robusta e design ergonômico, oferece conforto e eficiência em cada movimento, seja para escavação no jardim, trabalhos de construção ou aventuras ao ar livre, essa picareta é a escolha confiável para enfrentar desafios com facilidade e precisão.',
		client = {
			image = 'pickaxe.png',
		},
	},
	['pickaxeplus'] = {
		label = 'Picareta ++',
		weight = 2750,
		stack = true,
		close = true,
		description = 'Ferramenta versátil e resistente, projetada para lidar com uma variedade de tarefas, com sua construção robusta e design ergonômico, oferece conforto e eficiência em cada movimento, seja para escavação no jardim, trabalhos de construção ou aventuras ao ar livre, essa picareta é a escolha confiável para enfrentar desafios com facilidade e precisão.',
		client = {
			image = 'pickaxe.png',
		},
	},
	['pink_essence'] = {
		label = 'Essência Rosa',
		weight = 0,
		stack = true,
		close = true,
		description = 'Componente químico utilizado em experimentos, possui propriedades energéticas únicas que alimentam dispositivos experimentais, aprimoram armas modificadas ou são vendidas por um bom dinheiro.',
		client = {
			image = 'pink_essence.png',
		},
	},
	['pistol_bench'] = {
		label = 'Mesa de Produção',
		weight = 8750,
		stack = true,
		close = true,
		description = 'Mesa para fabricação de <common>Pistolas</common>.',
		client = {
			image = 'pistol_bench.png',
		},
	},
	['pistolbody'] = {
		label = 'Corpo de Pistola',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'pistolbody.png',
		},
	},
	['pizzabanana'] = {
		label = 'Pizza de Banana',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'pizzabanana.png',
		},
	},
	['pizzachocolate'] = {
		label = 'Pizza de Chocolate',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'pizzachocolate.png',
		},
	},
	['pizzamozzarella'] = {
		label = 'Pizza de Muçarela',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'pizzamozzarella.png',
		},
	},
	['plastic'] = {
		label = 'Plástico',
		weight = 45,
		stack = true,
		close = true,
		client = {
			image = 'plastic.png',
		},
	},
	['plate'] = {
		label = 'Placa Veícular',
		weight = 750,
		stack = true,
		close = true,
		description = 'Embora personalizada e distintiva, desconsidera as normas de trânsito e regulamentos legais, com um design único, destina-se a quem busca evadir-se das regras, mas não é recomendada para uso responsável e ético nas estradas.',
		client = {
			image = 'plate.png',
		},
	},
	['platinum'] = {
		label = 'Platina',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'platinum.png',
		},
	},
	['postit'] = {
		label = 'Post-It',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'postit.png',
		},
	},
	['pouch'] = {
		label = 'Malote',
		weight = 1250,
		stack = true,
		close = true,
		client = {
			image = 'pouch.png',
		},
	},
	['powercable'] = {
		label = 'Cabo de Alimentação',
		weight = 350,
		stack = true,
		close = true,
		client = {
			image = 'powercable.png',
		},
	},
	['powersupply'] = {
		label = 'Fonte de Alimentação',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'powersupply.png',
		},
	},
	['premiumplate'] = {
		label = 'Placa Customizada',
		weight = 0,
		stack = true,
		close = true,
		description = 'Uma escolha ideal para quem busca expressar sua individualidade enquanto trafega pelas estradas, feita com materiais de qualidade e design exclusivo, ela adiciona um toque único ao veículo de seu proprietário, sem comprometer a conformidade com as normas de trânsito.',
		client = {
			image = 'platepremium.png',
		},
	},
	['prescription'] = {
		label = 'Receita Médica',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'prescription.png',
		},
	},
	['processor'] = {
		label = 'Processador',
		weight = 650,
		stack = true,
		close = true,
		client = {
			image = 'processor.png',
		},
	},
	['processorfan'] = {
		label = 'Ventoinha do Processador',
		weight = 950,
		stack = true,
		close = true,
		client = {
			image = 'processorfan.png',
		},
	},
	['promissory1000'] = {
		label = 'Nota Promissória',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'promissory.png',
		},
	},
	['promissory2000'] = {
		label = 'Nota Promissória',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'promissory.png',
		},
	},
	['promissory3000'] = {
		label = 'Nota Promissória',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'promissory.png',
		},
	},
	['promissory4000'] = {
		label = 'Nota Promissória',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'promissory.png',
		},
	},
	['promissory5000'] = {
		label = 'Nota Promissória',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'promissory.png',
		},
	},
	['propertys'] = {
		label = 'Chave de Ferro',
		weight = 350,
		stack = true,
		close = true,
		client = {
			image = 'propertys.png',
		},
	},
	['purifiedwater'] = {
		label = 'Galão de Água Purificada',
		weight = 1250,
		stack = true,
		close = true,
		description = 'Essencial para hidratação segura e saudável, ideal para uso doméstico ou comercial.',
		client = {
			image = 'purifiedwater.png',
		},
	},
	['purple_essence'] = {
		label = 'Essência Roxa',
		weight = 0,
		stack = true,
		close = true,
		description = 'Componente químico utilizado em experimentos, possui propriedades energéticas únicas que alimentam dispositivos experimentais, aprimoram armas modificadas ou são vendidas por um bom dinheiro.',
		client = {
			image = 'purple_essence.png',
		},
	},
	['racestablet'] = {
		label = 'Tablet Descartável',
		weight = 475,
		stack = true,
		close = true,
		description = 'Dispositivo eletrônico compacto e temporário projetado para uso prático e conveniente em situações específicas, oferecendo funcionalidades básicas de navegação na internet, leitura e comunicação, com a vantagem de ser facilmente descartável após o uso.',
		client = {
			image = 'racestablet.png',
		},
	},
	['racesticket'] = {
		label = 'Cartão Descartável',
		weight = 150,
		stack = true,
		close = true,
		description = 'Explore circuitos exclusivos e de acesso privilegiado, desbloqueie portas para emocionantes experiências em locais de elite ao redor do mundo.',
		client = {
			image = 'racesticket.png',
		},
	},
	['radio'] = {
		label = 'Rádio',
		weight = 750,
		stack = true,
		close = true,
		description = 'Transceptor compacto e confiável que proporciona uma comunicação clara e segura para seu grupo, com uma frequência exclusiva para manter suas conversas privadas e protegidas.',
		client = {
			image = 'radio.png',
		},
	},
	['radiomhz'] = {
		label = 'Frequência Mhz',
		weight = 0,
		stack = true,
		close = true,
		description = 'Transceptor compacto e poderoso que oferece uma frequência de rádio exclusiva para comunicação segura entre membros do seu grupo, ideal para operações discretas em ambientes onde privacidade é essencial.',
		client = {
			image = 'radiomhz.png',
		},
	},
	['rammemory'] = {
		label = 'Memória RAM',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'rammemory.png',
		},
	},
	['ration'] = {
		label = 'Ração Animal',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'ration.png',
		},
	},
	['red_essence'] = {
		label = 'Essência Vermelha',
		weight = 0,
		stack = true,
		close = true,
		description = 'Componente químico utilizado em experimentos, possui propriedades energéticas únicas que alimentam dispositivos experimentais, aprimoram armas modificadas ou são vendidas por um bom dinheiro.',
		client = {
			image = 'red_essence.png',
		},
	},
	['repairkit01'] = {
		label = 'Kit de Reparos',
		weight = 3250,
		stack = true,
		close = true,
		description = 'Solucione problemas com facilidade, seja em casa, no carro ou em qualquer lugar, indispensável para manter tudo funcionando perfeitamente.',
		client = {
			image = 'repairkit01.png',
		},
	},
	['repairkit02'] = {
		label = 'Kit de Reparos',
		weight = 3750,
		stack = true,
		close = true,
		description = 'Solucione problemas com facilidade, seja em casa, no carro ou em qualquer lugar, indispensável para manter tudo funcionando perfeitamente.',
		client = {
			image = 'repairkit02.png',
		},
	},
	['repairkit03'] = {
		label = 'Kit de Reparos',
		weight = 4250,
		stack = true,
		close = true,
		description = 'Solucione problemas com facilidade, seja em casa, no carro ou em qualquer lugar, indispensável para manter tudo funcionando perfeitamente.',
		client = {
			image = 'repairkit03.png',
		},
	},
	['repairkit04'] = {
		label = 'Kit de Reparos',
		weight = 4750,
		stack = true,
		close = true,
		description = 'Solucione problemas com facilidade, seja em casa, no carro ou em qualquer lugar, indispensável para manter tudo funcionando perfeitamente.',
		client = {
			image = 'repairkit04.png',
		},
	},
	['ricebag'] = {
		label = 'Saco de Arroz',
		weight = 1250,
		stack = true,
		close = true,
		client = {
			image = 'ricebag.png',
		},
	},
	['rifle_bench'] = {
		label = 'Mesa de Produção',
		weight = 9750,
		stack = true,
		close = true,
		description = 'Mesa para fabricação de <common>Rifles</common>.',
		client = {
			image = 'rifle_bench.png',
		},
	},
	['riflebody'] = {
		label = 'Corpo de Rifle',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'riflebody.png',
		},
	},
	['ritmoneury'] = {
		label = 'Ritmoneury',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'ritmoneury.png',
		},
	},
	['roadsigns'] = {
		label = 'Placas de Trânsito',
		weight = 600,
		stack = true,
		close = true,
		client = {
			image = 'roadsigns.png',
		},
	},
	['rope'] = {
		label = 'Cordas',
		weight = 1750,
		stack = true,
		close = true,
		client = {
			image = 'rope.png',
		},
	},
	['rubber'] = {
		label = 'Borracha',
		weight = 45,
		stack = true,
		close = true,
		client = {
			image = 'rubber.png',
		},
	},
	['ruby_pure'] = {
		label = 'Ruby Lapidado',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'ruby_pure.png',
		},
	},
	['ryebread'] = {
		label = 'Pão de Centeio',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'ryebread.png',
		},
	},
	['safependrive'] = {
		label = 'Pendrive Seguro',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'safependrive.png',
		},
	},
	['saline'] = {
		label = 'Soro Fisiológico',
		weight = 350,
		stack = true,
		close = true,
		client = {
			image = 'saline.png',
		},
	},
	['salmon'] = {
		label = 'Salmão',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'salmon.png',
		},
	},
	['sand'] = {
		label = 'Areia',
		weight = 225,
		stack = true,
		close = true,
		client = {
			image = 'sand.png',
		},
	},
	['sandwich'] = {
		label = 'Sanduiche',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'sandwich.png',
		},
	},
	['sapphire_pure'] = {
		label = 'Safira Lapidada',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'sapphire_pure.png',
		},
	},
	['sardine'] = {
		label = 'Sardinha',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'sardine.png',
		},
	},
	['scotchtape'] = {
		label = 'Fita Adesiva',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'scotchtape.png',
		},
	},
	['scrapmetal'] = {
		label = 'Sucata de Metal',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'scrapmetal.png',
		},
	},
	['screwnuts'] = {
		label = 'Porcas de Parafuso',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'screwnuts.png',
		},
	},
	['screws'] = {
		label = 'Parafusos',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'screws.png',
		},
	},
	['scuba'] = {
		label = 'Roupa de Mergulho',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'scuba.png',
		},
	},
	['seatbelt'] = {
		label = 'Cinto de Corrida',
		weight = 5750,
		stack = true,
		close = true,
		client = {
			image = 'seatbelt.png',
		},
	},
	['sewingkit'] = {
		label = 'Kit de Costura',
		weight = 550,
		stack = true,
		close = true,
		description = 'Utilizado para reparar mochilas <common>Pequenas</common>, <common>Médias</common> e <common>Grandes</common>.',
		client = {
			image = 'sewingkit.png',
		},
	},
	['sheetmetal'] = {
		label = 'Chapa de Metal',
		weight = 650,
		stack = true,
		close = true,
		client = {
			image = 'sheetmetal.png',
		},
	},
	['silverchain'] = {
		label = 'Corrente de Prata',
		weight = 400,
		stack = true,
		close = true,
		client = {
			image = 'silverchain.png',
		},
	},
	['silveregg'] = {
		label = 'Ovo de Prata',
		weight = 100,
		stack = true,
		close = true,
		description = 'Especial de Páscoa.',
		client = {
			image = 'silveregg.png',
		},
	},
	['sinkalmy'] = {
		label = 'Sinkalmy',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'sinkalmy.png',
		},
	},
	['skinshop'] = {
		label = 'Loja de Roupas',
		weight = 0,
		stack = true,
		close = true,
		description = 'Define uma posição no mapa onde a <epic>Loja de Roupas</epic> poderá ser acessada.',
		client = {
			image = 'skinshop.png',
		},
	},
	['smallshark'] = {
		label = 'Tubarão Pequeno',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'smallshark.png',
		},
	},
	['smalltrout'] = {
		label = 'Truta Pequena',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'smalltrout.png',
		},
	},
	['smg_bench'] = {
		label = 'Mesa de Produção',
		weight = 9250,
		stack = true,
		close = true,
		description = 'Mesa para fabricação de <common>Submetralhadoras</common>.',
		client = {
			image = 'smg_bench.png',
		},
	},
	['smgbody'] = {
		label = 'Corpo de Sub',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'smgbody.png',
		},
	},
	['soap'] = {
		label = 'Sabonete',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'soap.png',
		},
	},
	['soda'] = {
		label = 'Sprunk',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'soda.png',
		},
	},
	['spikestrips'] = {
    label = 'Tiras de Espinhos',
    weight = 1250,
    stack = true,
    close = true,
    consume = 0,
    client = {
        image = 'spikestrips.png',
    },
    },
	['spray_ballas'] = {
		label = 'Spray: Ballas',
		weight = 150,
		stack = true,
		close = true,
		description = 'Liberte sua expressão urbana com spray de pichação, sua ferramenta para transformar paredes em telas vibrantes de criatividade.',
		client = {
			image = 'sprays.png',
		},
	},
	['spray_families'] = {
		label = 'Spray: Families',
		weight = 150,
		stack = true,
		close = true,
		description = 'Liberte sua expressão urbana com spray de pichação, sua ferramenta para transformar paredes em telas vibrantes de criatividade.',
		client = {
			image = 'sprays.png',
		},
	},
	['spray_vagos'] = {
		label = 'Spray: Vagos',
		weight = 150,
		stack = true,
		close = true,
		description = 'Liberte sua expressão urbana com spray de pichação, sua ferramenta para transformar paredes em telas vibrantes de criatividade.',
		client = {
			image = 'sprays.png',
		},
	},
	['ssddrive'] = {
		label = 'Unidade SSD',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'ssddrive.png',
		},
	},
	['sugarbox'] = {
		label = 'Caixa de Açucar',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'sugarbox.png',
		},
	},
	['suitcase'] = {
		label = 'Mala de Dinheiro',
		weight = 1000,
		stack = false,
		close = true,
		description = 'Segura e discreta para guardar dinheiro, ideal para proteger e organizar seus recursos financeiros com tranquilidade.',
		client = {
			image = 'suitcase.png',
		},
	},
	['sulfuric'] = {
		label = 'Ácido Sulfúrico',
		weight = 450,
		stack = true,
		close = true,
		client = {
			image = 'sulfuric.png',
		},
	},
	['sushi'] = {
		label = 'Sushi',
		weight = 650,
		stack = true,
		close = true,
		client = {
			image = 'sushi.png',
		},
	},
	['syringe01'] = {
		label = 'Seringa A+',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'syringe.png',
		},
	},
	['syringe02'] = {
		label = 'Seringa B+',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'syringe.png',
		},
	},
	['syringe03'] = {
		label = 'Seringa A-',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'syringe.png',
		},
	},
	['syringe04'] = {
		label = 'Seringa B-',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'syringe.png',
		},
	},
	['tacos'] = {
		label = 'Tacos',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'tacos.png',
		},
	},
	['tarp'] = {
		label = 'Lona',
		weight = 600,
		stack = true,
		close = true,
		client = {
			image = 'tarp.png',
		},
	},
	['tattooshop'] = {
		label = 'Loja de Tatuagem',
		weight = 0,
		stack = true,
		close = true,
		description = 'Define uma posição no mapa onde a <epic>Loja de Tatuagem</epic> poderá ser acessada.',
		client = {
			image = 'tattooshop.png',
		},
	},
	['techtrash'] = {
		label = 'Lixo Eletrônico',
		weight = 650,
		stack = true,
		close = true,
		client = {
			image = 'techtrash.png',
		},
	},
	['teddypack'] = {
		label = 'Mochila de Ursinho',
		weight = 2500,
		stack = true,
		close = true,
		description = 'Adorável bolsa infantil, feita de material macio e peludo, com uma carinha sorridente bordada na frente e orelhas tridimensionais, é prática e encantadora ao mesmo tempo.<br>Aumenta o peso de sua mochila em <epic>100Kg</epic>.',
		client = {
			image = 'teddypack.png',
		},
	},
	['television'] = {
		label = 'Televisão',
		weight = 12500,
		stack = true,
		close = true,
		description = 'Uma experiência visual imersiva equipada com tecnologia LED para cores vibrantes e detalhes nítidos oferecendo entretenimento de alta qualidade.',
		client = {
			image = 'television.png',
		},
	},
	['tin_pure'] = {
		label = 'Barra de Estanho',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'tin_pure.png',
		},
	},
	['toolbox'] = {
		label = 'Kit de Ferramentas',
		weight = 2250,
		stack = true,
		close = true,
		description = 'Um arsenal versátil de ferramentas essenciais para todas as suas necessidades de reparo, com qualidade premium e variedade abrangente, este kit é seu parceiro e do seu veículos.',
		client = {
			image = 'toolbox.png',
		},
	},
	['toothpaste'] = {
		label = 'Pasta de Dente',
		weight = 150,
		stack = true,
		close = true,
		client = {
			image = 'toothpaste.png',
		},
	},
	['treasurebox'] = {
		label = 'Baú do Tesouro',
		weight = 0,
		stack = false,
		close = true,
		client = {
			image = 'treasurebox.png',
		},
	},
	['tyres'] = {
		label = 'Pneu',
		weight = 2750,
		stack = true,
		close = true,
		client = {
			image = 'tyres.png',
		},
	},
	['umbrella'] = {
		label = 'Guarda-chuva',
		weight = 2000,
		stack = true,
		close = true,
		client = {
			image = 'umbrella.png',
		},
	},
	['utilkey'] = {
		label = 'Chave do Crepúsculo',
		weight = 250,
		stack = true,
		close = true,
		description = 'Projetada para ser encontrada e utilizada como parte da progressão na história ou na resolução de um enigma, adicionando um elemento de interatividade e imersão à experiência.',
		client = {
			image = 'utilkey.png',
		},
	},
	['vape'] = {
		label = 'Vape',
		weight = 750,
		stack = true,
		close = true,
		client = {
			image = 'vape.png',
		},
	},
	['vehiclekey'] = {
		label = 'Chave de Veículo',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Utilize a chave para trancar e destrancar as portas, bem como para ligar e desligar o motor do veículo correspondente.',
		client = {
			image = 'vehiclekey.png',
		},
	},
	['videocard'] = {
		label = 'Placa de Vídeo',
		weight = 4250,
		stack = true,
		close = true,
		client = {
			image = 'videocard.png',
		},
	},
	['washbattery'] = {
		label = 'Bateria 75Ah',
		weight = 17500,
		stack = true,
		close = true,
		description = 'Fonte confiável de energia, garantindo longa duração e eficiência durante os ciclos de lavagem, ideal para manter o funcionamento contínuo sem depender exclusivamente da rede elétrica.<br><br><legendary>Duração de 7 dias</legendary>',
		client = {
			image = 'washbattery.png',
		},
	},
	['washbleach'] = {
		label = 'Alvejante',
		weight = 350,
		stack = true,
		close = true,
		description = 'Produto químico potente utilizado para remover manchas difíceis e desinfetar superfícies. Ideal para limpeza pesada de roupas brancas e ambientes que exigem higienização profunda. Deve ser manuseado com cuidado.<br><br><legendary>Duração de 6 horas</legendary>',
		client = {
			image = 'washbleach.png',
		},
	},
	['water'] = {
		label = 'Garrafa de Água',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'water.png',
		},
	},
	['WEAPON_ACIDPACKAGE'] = {
		label = 'Jornal',
		weight = 200,
		stack = false,
		close = true,
		client = {
			image = 'newspaper.png',
		},
	},
	['WEAPON_ADVANCEDRIFLE'] = {
		label = 'MDR',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'mdr.png',
		},
	},
	['WEAPON_APPISTOL'] = {
		label = 'Koch Vp9',
		weight = 2750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'kochvp9.png',
		},
	},
	['WEAPON_ASSAULTRIFLE'] = {
		label = 'AK-74N',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'ak74n.png',
		},
	},
	['WEAPON_ASSAULTRIFLE_MK2'] = {
		label = 'AK-102',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'ak102.png',
		},
	},
	['WEAPON_ASSAULTSMG'] = {
		label = 'F2000',
		weight = 5750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'f2000.png',
		},
	},
	['WEAPON_BAT'] = {
		label = 'Bastão de Beisebol',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'bat.png',
		},
	},
	['WEAPON_BATTLEAXE'] = {
		label = 'Machado de Batalha',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'battleaxe.png',
		},
	},
	['WEAPON_BRICK'] = {
		label = 'Tijolo',
		weight = 750,
		stack = false,
		close = true,
		client = {
			image = 'brick.png',
		},
	},
	['WEAPON_BULLPUPRIFLE'] = {
		label = 'QBZ-95',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'qbz95.png',
		},
	},
	['WEAPON_BULLPUPRIFLE_MK2'] = {
		label = 'L85',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'l85.png',
		},
	},
	['WEAPON_CARBINERIFLE'] = {
		label = 'M4A1',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'm4a1.png',
		},
	},
	['WEAPON_CARBINERIFLE_MK2'] = {
		label = 'H416',
		weight = 8750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'h416.png',
		},
	},
	['WEAPON_COMBATPISTOL'] = {
		label = 'G18C',
		weight = 3250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 'g18c.png',
		},
	},
	['WEAPON_COMPACTRIFLE'] = {
		label = 'AKS74U',
		weight = 4250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'aks74u.png',
		},
	},
	['WEAPON_CROWBAR'] = {
		label = 'Pé de Cabra',
		weight = 1350,
		stack = false,
		close = true,
		client = {
			image = 'crowbar.png',
		},
	},
	['WEAPON_FLASHLIGHT'] = {
		label = 'Lanterna',
		weight = 750,
		stack = false,
		close = true,
		client = {
			image = 'flashlight.png',
		},
	},
	['WEAPON_GOLFCLUB'] = {
		label = 'Taco de Golf',
		weight = 1650,
		stack = false,
		close = true,
		client = {
			image = 'golfclub.png',
		},
	},
	['WEAPON_GUSENBERG'] = {
		label = 'MPF45',
		weight = 6250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'mpf45.png',
		},
	},
	['WEAPON_HAMMER'] = {
		label = 'Martelo',
		weight = 1450,
		stack = false,
		close = true,
		client = {
			image = 'hammer.png',
		},
	},
	['WEAPON_HATCHET'] = {
		label = 'Machado',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'hatchet.png',
		},
	},
	['WEAPON_HEAVYPISTOL'] = {
		label = 'M45A1',
		weight = 2750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 'm45a1.png',
		},
	},
	['WEAPON_HEAVYRIFLE'] = {
		label = 'Scar-H',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'scarh.png',
		},
	},
	['WEAPON_KATANA'] = {
		label = 'Katana',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'katana.png',
		},
	},
	['WEAPON_KNUCKLE'] = {
		label = 'Soco Inglês',
		weight = 1250,
		stack = false,
		close = true,
		client = {
			image = 'knuckle.png',
		},
	},
	['WEAPON_KRUK'] = {
		label = 'Banco de Madeira',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'WEAPON_KRUK.png',
		},
	},
	['WEAPON_MACHETE'] = {
		label = 'Facão',
		weight = 1350,
		stack = false,
		close = true,
		client = {
			image = 'machete.png',
		},
	},
	['WEAPON_MACHINEPISTOL'] = {
		label = 'Tec-9',
		weight = 3250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'tec9.png',
		},
	},
	['WEAPON_MAND'] = {
		label = 'Fritadeira',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'WEAPON_MAND.png',
		},
	},
	['WEAPON_MICROSMG'] = {
		label = 'Uzi',
		weight = 4250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'uzi.png',
		},
	},
	['WEAPON_MINISMG'] = {
		label = 'MAC-10',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'mac10.png',
		},
	},
	['WEAPON_MOLOTOV'] = {
		label = 'Coquetel Molotov',
		weight = 950,
		stack = false,
		close = true,
		client = {
			image = 'molotov.png',
		},
	},
	['WEAPON_MUSKET'] = {
		label = 'Winchester 1892',
		weight = 6250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Mosquete</common>.',
		client = {
			image = 'winchester.png',
		},
	},
	['WEAPON_MUSKET_AMMO'] = {
		label = 'Munição de Mosquete',
		weight = 75,
		stack = true,
		close = true,
		client = {
			image = 'musketammo.png',
		},
	},
	['WEAPON_NIGHTSTICK'] = {
		label = 'Cassetete',
		weight = 1150,
		stack = false,
		close = true,
		client = {
			image = 'nightstick.png',
		},
	},
	['WEAPON_PAN'] = {
		label = 'Frigideira',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'WEAPON_PAN.png',
		},
	},
	['WEAPON_PETROLCAN'] = {
		label = 'Galão',
		weight = 1250,
		stack = false,
		close = true,
		client = {
			image = 'gallon.png',
		},
	},
	['WEAPON_PETROLCAN_AMMO'] = {
		label = 'Combustível',
		weight = 1,
		stack = true,
		close = true,
		client = {
			image = 'fuel.png',
		},
	},
	['WEAPON_PISTOL'] = {
		label = 'M1911',
		weight = 2250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 'm1911.png',
		},
	},
	['WEAPON_PISTOL50'] = {
		label = 'Deagle',
		weight = 3750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 'deagle.png',
		},
	},
	['WEAPON_PISTOL_AMMO'] = {
		label = 'Munição de Pistola',
		weight = 25,
		stack = true,
		close = true,
		client = {
			image = 'pistolammo.png',
		},
	},
	['WEAPON_PISTOL_MK2'] = {
		label = 'T54',
		weight = 2750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 't54.png',
		},
	},
	['WEAPON_POOLCUE'] = {
		label = 'Taco de Sinuca',
		weight = 1250,
		stack = false,
		close = true,
		client = {
			image = 'poolcue.png',
		},
	},
	['WEAPON_PUMPSHOTGUN'] = {
		label = 'M870',
		weight = 7250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Espingarda</common>.',
		client = {
			image = 'm870.png',
		},
	},
	['WEAPON_PUMPSHOTGUN_MK2'] = {
		label = 'MP133',
		weight = 7250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Espingarda</common>.',
		client = {
			image = 'mp133.png',
		},
	},
	['WEAPON_RIFLE_AMMO'] = {
		label = 'Munição de Rifle',
		weight = 25,
		stack = true,
		close = true,
		client = {
			image = 'rifleammo.png',
		},
	},
	['WEAPON_RPG'] = {
		label = 'Lança Foguete',
		weight = 12250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Foguete</common>.',
		client = {
			image = 'rpg.png',
		},
	},
	['WEAPON_RPG_AMMO'] = {
		label = 'Munição de Foguete',
		weight = 2250,
		stack = true,
		close = true,
		client = {
			image = 'rocket.png',
		},
	},
	['WEAPON_SAWNOFFSHOTGUN'] = {
		label = 'Mossberg 500',
		weight = 5750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Espingarda</common>.',
		client = {
			image = 'mossberg500.png',
		},
	},
	['WEAPON_SHOES'] = {
		label = 'Tênis',
		weight = 755,
		stack = false,
		close = true,
		client = {
			image = 'shoes.png',
		},
	},
	['WEAPON_SHOTGUN_AMMO'] = {
		label = 'Munição de Espingarda',
		weight = 50,
		stack = true,
		close = true,
		client = {
			image = 'shotgunammo.png',
		},
	},
	['WEAPON_SMG'] = {
		label = 'MP5',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'mp5.png',
		},
	},
	['WEAPON_SMG_AMMO'] = {
		label = 'Munição de Sub',
		weight = 25,
		stack = true,
		close = true,
		client = {
			image = 'smgammo.png',
		},
	},
	['WEAPON_SMG_MK2'] = {
		label = 'MPX',
		weight = 5250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Sub</common>.',
		client = {
			image = 'mpx.png',
		},
	},
	['WEAPON_SMOKEGRENADE'] = {
		label = 'Granada de Fumaça',
		weight = 950,
		stack = false,
		close = true,
		client = {
			image = 'smokegrenade.png',
		},
	},
	['WEAPON_SNOWBALL'] = {
		label = 'Bola de Neve',
		weight = 550,
		stack = false,
		close = true,
		client = {
			image = 'snowball.png',
		},
	},
	['WEAPON_SNSPISTOL'] = {
		label = 'F57',
		weight = 2250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 'f57.png',
		},
	},
	['WEAPON_SNSPISTOL_MK2'] = {
		label = 'CZ52',
		weight = 3250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 'cz52.png',
		},
	},
	['WEAPON_SPATEL'] = {
		label = 'Espatula',
		weight = 1750,
		stack = false,
		close = true,
		client = {
			image = 'WEAPON_SPATEL.png',
		},
	},
	['WEAPON_SPECIALCARBINE'] = {
		label = 'G36C',
		weight = 8750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'g36c.png',
		},
	},
	['WEAPON_SPECIALCARBINE_MK2'] = {
		label = 'Sig Sauer 556',
		weight = 8750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'sigsauer556.png',
		},
	},
	['WEAPON_STONE_HATCHET'] = {
		label = 'Machado de Pedra',
		weight = 1550,
		stack = false,
		close = true,
		client = {
			image = 'stonehatchet.png',
		},
	},
	['WEAPON_STUNGUN'] = {
		label = 'Tazer',
		weight = 750,
		stack = false,
		close = true,
		client = {
			image = 'stungun.png',
		},
	},
	['WEAPON_SWITCHBLADE'] = {
		label = 'Canivete',
		weight = 750,
		stack = false,
		close = true,
		client = {
			image = 'switchblade.png',
		},
	},
	['WEAPON_TACTICALRIFLE'] = {
		label = 'M16',
		weight = 7750,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Rifle</common>.',
		client = {
			image = 'm16.png',
		},
	},
	['WEAPON_VINTAGEPISTOL'] = {
		label = 'M1922',
		weight = 3250,
		stack = false,
		close = true,
		description = 'Armamento que utiliza <common>Munição de Pistola</common>.',
		client = {
			image = 'm1922.png',
		},
	},
	['WEAPON_WRENCH'] = {
		label = 'Chave Inglesa',
		weight = 1450,
		stack = false,
		close = true,
		client = {
			image = 'wrench.png',
		},
	},
	['weaponbox'] = {
		label = 'Caixa de Armamento',
		weight = 3250,
		stack = false,
		close = true,
		description = 'Resistente e segura, ideal para armazenamento e transporte de armas com praticidade e segurança.',
		client = {
			image = 'weaponbox.png',
		},
	},
	['weaponkey'] = {
		label = 'Chave da Harmonia',
		weight = 250,
		stack = true,
		close = true,
		description = 'Projetada para ser encontrada e utilizada como parte da progressão na história ou na resolução de um enigma, adicionando um elemento de interatividade e imersão à experiência.',
		client = {
			image = 'weaponkey.png',
		},
	},
	['weaponparts'] = {
		label = 'Peças de Armas',
		weight = 1250,
		stack = true,
		close = true,
		client = {
			image = 'weaponparts.png',
		},
	},
	['weedsack'] = {
		label = 'Pacote de Cannabis',
		weight = 2500,
		stack = true,
		close = true,
		client = {
			image = 'weedsack.png',
		},
	},
	['wetdollar'] = {
		label = 'Dólar Molhado',
		weight = 0,
		stack = true,
		close = true,
		client = {
			image = 'wetdollar.png',
		},
	},
	['wheat'] = {
		label = 'Trigo',
		weight = 50,
		stack = true,
		close = true,
		client = {
			image = 'wheat.png',
		},
	},
	['woodlog'] = {
		label = 'Tora de Madeira',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			image = 'woodlog.png',
		},
	},
	['yellowperch'] = {
		label = 'Poleiro Amarelo',
		weight = 500,
		stack = true,
		close = true,
		client = {
			image = 'yellowperch.png',
		},
	},
	['applejuice'] = {
		label = 'Suco de Maçã',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'applejuice.png',
		},
	},

	['orangejuice'] = {
		label = 'Suco de Laranja',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'orangejuice.png',
		},
	},

	['passionjuice'] = {
		label = 'Suco de Maracujá',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'passionjuice.png',
		},
	},

	['tangejuice'] = {
		label = 'Suco de Tangerina',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'tangejuice.png',
		},
	},

	['grapejuice'] = {
		label = 'Suco de Uva',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'grapejuice.png',
		},
	},

	['lemonjuice'] = {
		label = 'Suco de Limão',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'lemonjuice.png',
		},
	},

	['strawberryjuice'] = {
		label = 'Suco de Morango',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'strawberryjuice.png',
		},
	},

	['blueberryjuice'] = {
		label = 'Suco de Blueberry',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'blueberryjuice.png',
		},
	},

	['bananajuice'] = {
		label = 'Suco de Banana',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'bananajuice.png',
		},
	},

	['acerolajuice'] = {
		label = 'Suco de Acerola',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'acerolajuice.png',
		},
	},

	['guaranajuice'] = {
		label = 'Suco de Guaraná',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'guaranajuice.png',
		},
	},

	['calzone'] = {
		label = 'Calzone',
		weight = 250,
		stack = true,
		close = true,
		client = {
			image = 'calzone.png',
		},
	},

	['small_treat'] = {
		label = 'Petisco Pequeno',
		weight = 50,
		stack = true,
		close = true,
		description = 'Petisco pequeno para pets do nn_petshop.',
		client = {
			image = 'small_treat.png',
		},
	},

	['big_treat'] = {
		label = 'Petisco Grande',
		weight = 80,
		stack = true,
		close = true,
		description = 'Petisco grande para pets do nn_petshop.',
		client = {
			image = 'big_treat.png',
		},
	},

	['tastymeat'] = {
		label = 'Carne Saborosa',
		weight = 120,
		stack = true,
		close = true,
		description = 'Carne para pets do nn_petshop.',
		client = {
			image = 'tastymeat.png',
		},
	},

	['medium_cookie'] = {
		label = 'Biscoito Medio',
		weight = 60,
		stack = true,
		close = true,
		description = 'Biscoito medio para pets do nn_petshop.',
		client = {
			image = 'medium_cookie.png',
		},
	},

	['big_cookie'] = {
		label = 'Biscoito Grande',
		weight = 70,
		stack = true,
		close = true,
		description = 'Biscoito grande para pets do nn_petshop.',
		client = {
			image = 'big_cookie.png',
		},
	},

	['fruit_slice'] = {
		label = 'Fatia de Fruta',
		weight = 40,
		stack = true,
		close = true,
		description = 'Fatia de fruta para pets do nn_petshop.',
		client = {
			image = 'fruit_slice.png',
		},
	},

	['pupcup'] = {
		label = 'Pup Cup',
		weight = 90,
		stack = true,
		close = true,
		description = 'Copo especial para pets do nn_petshop.',
		client = {
			image = 'pupcup.png',
		},
	},

	['yogurt'] = {
		label = 'Iogurte',
		weight = 70,
		stack = true,
		close = true,
		description = 'Iogurte para pets do nn_petshop.',
		client = {
			image = 'yogurt.png',
		},
	},

	['dog_treat'] = {
		label = 'Petisco de Cachorro',
		weight = 50,
		stack = true,
		close = true,
		description = 'Petisco legado para pets do nn_petshop.',
		client = {
			image = 'dog_treat.png',
		},
	},

}
