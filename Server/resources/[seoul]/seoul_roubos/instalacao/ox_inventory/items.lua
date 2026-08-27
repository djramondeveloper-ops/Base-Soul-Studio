-- Seoul Roubos - itens que NAO existiam na base auditada
-- Cole dentro da tabela return { ... } de ox_inventory/data/items.lua

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
