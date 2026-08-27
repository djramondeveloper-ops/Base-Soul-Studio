# INSTALAÇÃO MANUAL - SEOUL FARMS

Pasta limpa, sem importador e sem item repetido da base.

## Itens incluídos aqui
cocaempo, pastadecoca, folhademaconha, maconhamacerada, weed, acidobateria, methliquid, ecstasy, lean, lsd, detonador

## Itens NÃO incluídos porque já existem na base
cocaine, meth, copper, aluminum, glass, dirtydollar, dollar

## Como instalar
1. Copie as imagens desta pasta `images/` para:
   `Server/resources/[ox]/ox_inventory/web/images/`

2. Abra:
   `Server/resources/[ox]/ox_inventory/data/items.lua`
   e cole o conteúdo de:
   `instalacao/ox_inventory/items.lua`
   dentro do `return { ... }`.

3. Abra:
   `Server/resources/[core]/vrp/config/Item.lua`
   e cole o conteúdo de:
   `instalacao/vrp/Item.lua`
   dentro do `local List = { ... }`.

4. Reinicie:
   `restart ox_inventory`
   `restart vrp`
   `restart seoul_farms`

Não precisa cadastrar `dollar`, `dirtydollar`, `cocaine`, `meth`, `copper`, `aluminum` ou `glass`, porque já existem na base original auditada.
