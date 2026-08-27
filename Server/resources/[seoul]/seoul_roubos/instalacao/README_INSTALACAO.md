# Instalação manual - Seoul Roubos

Este pacote NÃO usa importador automático.

## Itens já existentes na base auditada

Não foram duplicados:

```txt
c4
lockpick
dirtydollar
dollar
WEAPON_PISTOL
WEAPON_SNSPISTOL
ammo-9
aluminum
rubber
plastic
```

## Itens que precisam ser adicionados

```txt
blackcard
bluecard
watch
ring
goldbar
```

## OX Inventory

1. Copie as imagens de:

```txt
seoul_roubos/instalacao/images/
```

para:

```txt
Server/resources/[ox]/ox_inventory/web/images/
```

2. Copie o conteúdo de:

```txt
seoul_roubos/instalacao/ox_inventory/items.lua
```

para dentro da tabela de:

```txt
Server/resources/[ox]/ox_inventory/data/items.lua
```

## vRP

Copie o conteúdo de:

```txt
seoul_roubos/instalacao/vrp/Item.lua
```

para dentro da tabela de:

```txt
Server/resources/[core]/vrp/config/Item.lua
```

## Depois

```cfg
restart ox_inventory
restart vrp
restart seoul_roubos
```

## Observação

O script foi adaptado para pagar `dirtydollar`, usando a moeda suja já existente na base.
