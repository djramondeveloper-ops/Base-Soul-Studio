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

A Seoul Base possui os jobs/departamentos `LSPD`, `PRPD`, `PMRJ`, `PCRJ`, `PFRJ`, `EXERCITORJ`, `BOMBEIRORJ`, `PMESP`, `PCSP`, `PFSP`, `EXERCITOSP` e `BOMBEIROSP`. O grupo `Police` existe no vRP como grupo agregador para todos esses departamentos.

No `rcore_police`, os departamentos ativos em `Config.JobGroups` sao:

- `LSPD`
- `PRPD`
- `PMRJ`
- `PCRJ`
- `PFRJ`
- `EXERCITORJ`
- `BOMBEIRORJ`
- `PMESP`
- `PCSP`
- `PFSP`
- `EXERCITOSP`
- `BOMBEIROSP`

Nos grupos novos, o cargo `Comandante` e o nivel 1 da vRP/Seoul. A camada QBCore da Seoul converte esse nivel para boss no formato esperado pelo `rcore_police`.

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

Atalhos principais:

- `F1`: abre o radial policial.
- `F6`: abre o menu policial antigo/completo.
- `/policeradial`: abre o radial policial por comando, util para testar se alguma tecla esta sendo capturada por outro resource.
- `/policemenu`: abre o menu policial por comando, util para testar se alguma tecla esta sendo capturada por outro resource.
- `E`: interage com zonas, como bater ponto, arsenal, garagem e bau.

O resource tambem possui fallback direto para F1/F6, porque o cache de keybind do FiveM pode manter teclas antigas depois de mudar `RegisterKeyMapping`.

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
7. O cofre/society interno usa a tabela `rcore_police_society` e cria a tabela automaticamente ao iniciar.
8. Multas usam a tabela `invoices` da Seoul.
9. Prisao usa o export real do LB Tablet quando `lb-tablet` estiver iniciado.

## Como testar

1. Reinicie:

```cfg
restart rcore_police
```

2. Verifique no console se nao aparece mais:

```txt
sv-inventory-cheeza.lua:159: attempt to call a nil value (field 'RegisterUsableItem')
sv-st-groups.lua:85: attempt to call a nil value (field 'GetMoney')
```

3. Confirme que o idioma carregou em portugues:

- No radial deve aparecer `Menu principal`, `Outros` e `Voltar`.
- Nas zonas deve aparecer `Bater ponto`, `Garagem policial`, `Arsenal`, `Vestiario`, `Bau compartilhado` etc.

4. Confirme nos logs do rcore que o inventario ativo ficou como:

```txt
inventory: ox_inventory
```

5. Teste um item policial usavel, como algema, fura-pneu, camera, bodycam ou megafone, conforme configurado.

## Onde bater ponto

O ponto de servico e a zona `ZONE_TYPE.DUTY`. Como o rcore escolhe as zonas pelo mapa/MLO detectado, use o ponto correspondente ao resource de delegacia que estiver iniciado na base:

| Mapa/resource | Job | Coordenada de bater ponto |
| --- | --- | --- |
| `GABZ_MRPD` / `gabz-mrpd.lua` | `LSPD` | `441.810730, -981.91, 30.83` |
| `MOLO_MRPD` / `molo_mrpd.lua` | `LSPD` | `446.62, -983.88, 31.78` |
| `MOLO_MRPDV2` / `molo_mrpdv2.lua` | `LSPD` | `446.62, -983.88, 31.78` |
| `DEFAULT_MRPD` / `default-mrpd.lua` | `LSPD` | `440.168, -977.170, 30.689` |
| `FRANCO_MRPD` / `franco-mrpd.lua` | `LSPD` | `447.27398681641, -991.47729492188, 30.707878112793` |
| `ibonoja_mrpd` / `ibonoja-fallback.lua` | `LSPD` | `447.0533, -978.9218, 30.6893` |
| `ibonoja_mrpd_full_editable` / `ibonoja-mrpd.lua` | `LSPD` | `447.0533, -978.9218, 30.6893` |
| `kiiya_mrpd` / `kiiya_mrpd.lua` | `LSPD` | `445.949066, -992.432434, 30.710712` |
| `shmann_vpd_fivem` / `shmann_vpd_fivem.lua` | `LSPD` | `-1104.936280, -837.560424, 34.267456` |
| `NTEAM_ROCKFORD_HILLS` / `nteam-police.lua` | `LSPD` | `-590.2037, -423.2840, 35.1719` |
| `MOLO_LSPDHQ` / `molo_lspdhq.lua` | `LSPD` | `94.52, -423.44, 48.50` |
| `MOLO_DAVISPD` / `molo_davispd.lua` | `LSPD` ou `PRPD` | `240.64, -1348.77, 33.4` |
| `MOLO_BCPD` / `molo_bcpd.lua` | `LSPD` | `-438.33, 6012.83, 32.48` |
| `hn_pb_sheriff` / `hn_pb_sheriff.lua` | `PRPD` | `-449.596405, 6028.826660, 30.967852` |
| `prompt_sandy_sheriff` / `prompt_sandy_sheriff.lua` | `PRPD` | `1827.072510, 3670.285644, 34.402222` |
| `prompt_sahp` / `prompt_sahp.lua` | `LSPD` | `835.59362792969, -1293.1955566406, 26.721313476562` |
| `map4all_ss_sheriff_compatible` | `PRPD` ou `LSPD` | `1846.010254, 3691.378662, 34.326149` |

Com `Config.UseTargetForZones = false`, o teste normal e chegar no ponto e apertar `E` quando aparecer o texto da zona.

## Roteiro rapido de teste

1. Entre com um personagem que tenha job/grupo `LSPD`, `PRPD` ou um dos novos grupos policiais.
2. Va ate a coordenada de bater ponto do MLO ativo.
3. Aperte `E` em `Bater ponto`.
4. Abra o menu policial/radial e confirme os textos em portugues.
5. Teste `Garagem policial`, `Loja do arsenal`, `Arsenal`, `Armario pessoal` e `Bau de evidencias`.
6. Pegue `Algemas`, `Fura-pneus`, `Megafone`, `Camera de evidencia` ou `Bodycam` na loja e use em outro player/veiculo.
7. Se uma zona nao aparecer, confirme se o resource do MLO esta iniciado e se o personagem tem o job esperado para aquele mapa.
8. Se F1/F6 nao abrirem, teste `/policeradial` e `/policemenu`. Se os comandos abrirem, limpe ou refaca o keybind em `ESC > Settings > Key Bindings > FiveM`.

## O que deve aparecer no console

Nao deve aparecer erro da bridge `sv-inventory-cheeza.lua` nem erro de `SocietyService.GetMoney` em `sv-st-groups.lua`.

## Erros comuns e como resolver

- Se voltar a aparecer `sv-inventory-cheeza.lua`, algum arquivo esta forcando `Config.Inventory = Inventory.CHEEZA` ou o resource executado nao e esta copia.
- Se voltar erro `field 'GetMoney'`, o resource executado nao esta com `modules/bridge/server/society/sv_society_standalone.lua` atualizado ou esta carregando cache antigo.
- Se item policial nao funcionar, confira se ele existe no `ox_inventory/data/items.lua`.
- Se o resource reclamar de SQL, importe `rcore_police_seoul.sql`.
- Se o framework nao carregar, confira se `vrp` iniciou antes do `rcore_police`.
- Se o radial continuar em ingles, limpe o cache do resource no FXServer e reinicie `rcore_police`.
- Se prisao nao funcionar, confirme que `lb-tablet` esta iniciado antes do teste.

## Arquivos alterados / criados

- `modules/bridge/sv-bridge.lua`
- `modules/bridge/cl-bridge.lua`
- `modules/bridge/server/inventory/sv-inventory-cheeza.lua`
- `modules/bridge/server/inventory/sv-inventory-ox.lua`
- `modules/bridge/client/inventory/cl-inventory-cheeza.lua`
- `modules/bridge/client/inventory/cl-inventory-ox.lua`
- `modules/bridge/server/society/sv_society_standalone.lua`
- `modules/bridge/server/billing/sv-billing-standalone.lua`
- `modules/bridge/client/billing/cl-billing-standalone.lua`
- `modules/bridge/server/prison/sv-prison-seoul.lua`
- `modules/bridge/client/prison/cl-prison-standalone.lua`
- `modules/bridge/server/duty/sv-qb-duty.lua`
- `modules/bridge/server/dispatch/sv-dispatch-lb_tablet.lua`
- `modules/bridge/client/mdt/cl-mdt-lb_tablet.lua`
- `modules/bridge/server/garage/sv_standalone_garage.lua`
- `modules/base/server/lifecycle/init/sv-l-garage.lua`
- `config_private.lua`
- `config.lua`
- `configs/fines.lua`
- `data/locales/pt-br.lua`
- `README.md`

## Observacoes finais

O erro vinha porque a Seoul Base possui um resource Creative chamado `inventory`. O loader do rcore confundia esse resource com o inventario Cheeza e trocava a bridge mesmo com a configuracao em OX. O ajuste mantem `ox_inventory` como bridge correta quando ele esta presente.
