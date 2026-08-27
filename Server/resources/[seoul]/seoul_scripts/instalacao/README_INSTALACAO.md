# INSTALAÇÃO MANUAL - SEOUL SCRIPTS

Pasta limpa, sem importador e sem item repetido da base.

## Itens incluídos aqui
Comuns: skate
Weapons: WEAPON_FLASHBANG

## Itens NÃO incluídos porque já existem na base
rope, camera, binoculars

## Como instalar
1. Copie as imagens desta pasta `images/` para:
   `Server/resources/[ox]/ox_inventory/web/images/`

2. Abra:
   `Server/resources/[ox]/ox_inventory/data/items.lua`
   e cole o conteúdo de:
   `instalacao/ox_inventory/items.lua`
   dentro do `return { ... }`.

3. Abra:
   `Server/resources/[ox]/ox_inventory/data/weapons.lua`
   e cole o conteúdo de:
   `instalacao/ox_inventory/weapons.lua`
   dentro da tabela `Weapons = { ... }`.

4. Abra:
   `Server/resources/[core]/vrp/config/Item.lua`
   e cole o conteúdo de:
   `instalacao/vrp/Item.lua`
   dentro do `local List = { ... }`.

5. Se for usar Warehouse, execute:
   `instalacao/sql/warehouse.sql`

6. Reinicie:
   `restart ox_inventory`
   `restart vrp`
   `restart seoul_scripts`

Não inclui `rope`, `camera` ou `binoculars`, porque já existem na base original auditada.
