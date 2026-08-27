-- SEOUL SCRIPTS - ITENS NOVOS (SEM REPETIR ITENS QUE JA EXISTEM NA BASE)
-- Cole somente as entradas abaixo dentro de: Server/resources/[ox]/ox_inventory/data/items.lua
-- Itens pulados porque ja existem na base: rope, camera, binoculars

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
