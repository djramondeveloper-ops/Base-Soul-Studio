# rcore_police - Seoul Base

## Funcao principal

Sistema policial `rcore_police` adaptado para a Seoul Base.

## Framework compativel

Seoul Base Creative/vRP com facade `qb-core` fornecida pelo resource `vrp`.

## Dependencias reais usadas

- `vrp`
- `oxmysql`
- `ox_lib`
- `ox_inventory`
- `rcore_police_assets`
- `rcore_police_assets_bodycam`

## Instalacao

O resource fica em:

```txt
Server/resources/[qbcore]/[police]/rcore_police
```

No `server.cfg`, mantenha depois das dependencias principais:

```cfg
ensure rcore_police_assets
ensure rcore_police_assets_bodycam
ensure rcore_police
```

## Linha correta de ensure

```cfg
ensure rcore_police
```

## Banco de dados / SQL

Usa `oxmysql`. A base contem o arquivo:

```txt
Server/resources/[qbcore]/[police]/rcore_police_seoul.sql
```

Importe esse SQL se as tabelas do rcore ainda nao existirem no banco.

## Itens necessarios

Os nomes ficam em `config.lua`, tabela `Items`.

Principais itens:

- `spikestrips`
- `speed_camera`
- `megaphone`
- `barrier`
- `handcuff`
- `handcuffs_key`
- `paper_bag_rcore`
- `zipties`
- `zipties_cutter`
- `panic_button`
- `police_camera`
- `photo`
- `gps`
- `bodycam`
- `wheel_clamp`
- `wheel_clamp_wrench`
- `bodycam_tablet`

Os itens devem existir no `ox_inventory` e na tabela de itens da Seoul/vRP quando a base exigir cadastro duplo.

## Permissoes / grupos / jobs usados

A Seoul Base possui os jobs/departamentos `LSPD` e `PRPD`. O grupo `Police` existe no vRP como grupo agregador com permissao para `LSPD` e `PRPD`.

No `rcore_police`, os departamentos ativos em `Config.JobGroups` sao:

- `LSPD`
- `PRPD`

## Comandos disponiveis

Consulte os comandos registrados pelo proprio `rcore_police` e pelo painel policial no jogo. Este ajuste nao adicionou comandos novos.

## Quem pode usar os comandos

As permissoes continuam controladas pelo `rcore_police` e pelo grupo `Police` da Seoul Base.

## Configuracoes do config.lua

Configuracoes principais confirmadas:

```lua
Config.Database = Database.OX
Config.Inventory = Inventory.OX
Config.Framework = Framework.QBCore
```

O `qb-core` e resolvido para `vrp` por `configs/framework.lua`.

## Coordenadas configuraveis

As coordenadas, blips, zonas e pontos do sistema policial ficam nos arquivos de config e data originais do `rcore_police`.

## Valores configuraveis

Valores de itens, loja, interacoes, prisao, dispatch, roupas e MDT ficam em `config.lua`, `configs/*.lua` e `data/*.lua`.

## Tempos / cooldowns configuraveis

Os tempos do sistema continuam nos arquivos originais do `rcore_police`, principalmente `config.lua`.

## Funcionamento passo a passo

1. O `rcore_police` carrega `bridge.lua`.
2. O config define `Inventory.OX`.
3. O loader valida bridges.
4. A bridge correta de inventario deve ser `ox_inventory`.
5. Se a base tambem possuir um resource chamado `inventory`, o bridge Cheeza e ignorado quando `ox_inventory` estiver presente.
6. Os itens usaveis sao registrados pela bridge OX usando evento `ox_inventory:usedItem`.

## Como testar

1. Reinicie:

```cfg
restart rcore_police
```

2. Verifique no console se nao aparece mais:

```txt
sv-inventory-cheeza.lua:159: attempt to call a nil value (field 'RegisterUsableItem')
```

3. Confirme nos logs do rcore que o inventario ativo ficou como:

```txt
inventory: ox_inventory
```

4. Teste um item policial usavel, como algema, spike ou camera, conforme configurado.

## O que deve aparecer no console

Nao deve aparecer erro da bridge `sv-inventory-cheeza.lua`.

## Erros comuns e como resolver

- Se voltar a aparecer `sv-inventory-cheeza.lua`, algum arquivo esta forcando `Config.Inventory = Inventory.CHEEZA` ou o resource executado nao e esta copia.
- Se item policial nao funcionar, confira se ele existe no `ox_inventory/data/items.lua`.
- Se o resource reclamar de SQL, importe `rcore_police_seoul.sql`.
- Se o framework nao carregar, confira se `vrp` iniciou antes do `rcore_police`.

## Arquivos alterados / criados

- `modules/bridge/sv-bridge.lua`
- `modules/bridge/cl-bridge.lua`
- `modules/bridge/server/inventory/sv-inventory-cheeza.lua`
- `modules/bridge/server/inventory/sv-inventory-ox.lua`
- `modules/bridge/client/inventory/cl-inventory-cheeza.lua`
- `modules/bridge/client/inventory/cl-inventory-ox.lua`
- `README.md`

## Observacoes finais

O erro vinha porque a Seoul Base possui um resource Creative chamado `inventory`. O loader do rcore confundia esse resource com o inventario Cheeza e trocava a bridge mesmo com a configuracao em OX. O ajuste mantem `ox_inventory` como bridge correta quando ele esta presente.
