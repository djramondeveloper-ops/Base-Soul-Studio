# rcore_fuel

## Funcao principal

Sistema completo de combustivel para FiveM. Ele controla abastecimento de veiculos, bombas, galoes, tipo de combustivel, postos/empresas, estoque, NUI e compatibilidade com exports de outros fuels.

## Framework compativel nesta base

Esta instalacao usa Seoul Creative/vRP como framework real. O resource `vrp` declara `provide 'qb-core'`, entao o `rcore_fuel` roda configurado como QBCore pela camada de compatibilidade da propria Seoul.

Configuracao atual validada:

- `Config.Framework.Active = 2`
- `Config.Framework.QB_CORE_NAME = "qb-core"`
- `Config.InventorySystem = Inventory.OX`
- `Config.TargetZoneType = 4`

## Dependencias reais

- `vrp`
- `oxmysql`
- `ox_inventory`
- `ox_target`
- `rcore_fuel_assets`

O resource tambem fornece compatibilidade para:

- `LegacyFuel`
- `ps-fuel`
- `cdn-fuel`
- `ox_fuel`

## Instalacao

O resource esta em:

`Server/resources/[qbcore]/[rcore_fuel]/rcore_fuel`

Os assets estao em:

`Server/resources/[qbcore]/[rcore_fuel]/rcore_fuel_assets`

Como o `server.cfg` ja usa `start [qbcore]`, ambos sobem junto com a categoria. Se preferir garantir manualmente, use:

```cfg
ensure rcore_fuel_assets
ensure rcore_fuel
```

Eles devem iniciar depois de:

```cfg
ensure oxmysql
ensure ox_lib
ensure vrp
ensure ox_target
ensure ox_inventory
```

## Banco de dados

Precisa de banco de dados MySQL/MariaDB via `oxmysql`.

O proprio `server/main.lua` cria automaticamente:

```sql
CREATE TABLE IF NOT EXISTS rcore_fuel_companies
```

Nao foi necessario adicionar arquivo `.sql` separado.

## Itens necessarios

Foram cadastrados os itens usados pelo script:

- `vehicle_manual`
- `fuel_pump`
- `window_cleaner`

Arquivos ajustados:

- `Server/resources/[core]/vrp/config/Item.lua`
- `Server/resources/[ox]/ox_inventory/data/items.lua`

As imagens dos itens devem existir em:

- `Server/resources/[ox]/ox_inventory/web/images/vehicle_manual.png`
- `Server/resources/[ox]/ox_inventory/web/images/fuel_pump.png`
- `Server/resources/[ox]/ox_inventory/web/images/window_cleaner.png`

## Permissoes, grupos e jobs

O editor usa os grupos configurados em `Config.CommandGroups`:

- `admin`
- `superadmin`
- `god`
- grupos numericos `2`, `3`, `4`, `5`

Na Seoul, esses grupos passam pela camada QBCore/vRP. Se algum comando/editor nao abrir, valide primeiro o mapeamento de permissoes no `vrp`.

## Comandos e uso

O script possui comandos e eventos internos para editor/debug quando habilitados no config. Por padrao:

- `Config.Debug = false`
- `Config.AllowDebugCommand = false`
- `Config.ScaleformEditor = false`

Os jogadores usam o sistema pelo `ox_target` nas bombas e pelos itens do inventario.

## Configuracoes importantes

Arquivo principal:

`config.lua`

Pontos principais:

- `Config.Locale = "en"`
- `Config.TargetZoneType = 4`
- `Config.InventorySystem = Inventory.OX`
- `Config.CashItem = "dollar"`
- `Config.IsCashBasedOnItem = true`
- `Config.DisablePaymentModal = false`
- `Config.JerryCanStartsFull = true`

Coordenadas e postos ficam principalmente em:

- `config/shop_config.lua`
- `config/itemshop_config.lua`
- `config/dispenser_config.lua`
- `config/mission_config.lua`

## Funcionamento passo a passo

1. O jogador mira/interage em uma bomba via `ox_target`.
2. O `rcore_fuel` abre a interface de abastecimento.
3. O servidor valida posto, combustivel, dinheiro e estoque.
4. O abastecimento atualiza o nivel de fuel do veiculo.
5. Dados de empresa/posto sao salvos em `rcore_fuel_companies`.
6. Os itens especiais chamam exports do proprio `rcore_fuel`.

## Como testar

1. Reinicie `vrp`.
2. Reinicie `ox_inventory`.
3. Reinicie `rcore_fuel_assets`.
4. Reinicie `rcore_fuel`.
5. Entre no servidor.
6. Va ate um posto.
7. Confirme que o `ox_target` aparece nas bombas.
8. Abasteca um veiculo e veja se o dinheiro e removido.
9. Compre `vehicle_manual` e `fuel_pump` na loja do posto.
10. Use os itens pelo inventario.

## O que deve aparecer no console

Esperado:

- `rcore_fuel` iniciando depois de `oxmysql`.
- `rcore_fuel_assets` iniciado antes do `rcore_fuel`.
- Tabela `rcore_fuel_companies` criada ou lida sem erro.
- Sem erro de item invalido no `ox_inventory`.

## Erros comuns

Se a loja cobra e nao entrega item:

- Confira se `vehicle_manual`, `fuel_pump` e `window_cleaner` existem em `ox_inventory/data/items.lua`.

Se o item aparece sem imagem:

- Confira as imagens em `ox_inventory/web/images`.

Se o script disser que nao ha dinheiro:

- Confirme se o dinheiro da base esta sincronizado com o item `dollar` do `ox_inventory`.

Se editor ou empresa falhar por permissao:

- Confira o adapter QBCore do `vrp` e os grupos reais da Seoul.

Se funcoes de society/banking falharem:

- Esta base nao possui necessariamente `qb-banking`, `qb-management`, `qbx_management` ou `esx_addonaccount`. O dinheiro interno do posto ainda usa `rcore_fuel_companies`, mas integracoes de society dependem desses resources.

## Arquivos alterados ou criados

- Criado: `Server/resources/[qbcore]/[rcore_fuel]/rcore_fuel/README.md`
- Alterado: `Server/resources/[qbcore]/[rcore_fuel]/rcore_fuel/fxmanifest.lua`
- Alterado: `Server/resources/[qbcore]/[rcore_fuel]/rcore_fuel/config.lua`
- Alterado: `Server/resources/[qbcore]/[rcore_fuel]/rcore_fuel/server/framework/qbcore.lua`
- Alterado: `Server/resources/[core]/vrp/config/Item.lua`
- Alterado: `Server/resources/[ox]/ox_inventory/data/items.lua`
- Imagens adicionadas ao `ox_inventory/web/images` a partir do pacote `rcore_fuel/image items`

## Observacoes finais

Esta entrega nao converte o script para vRP puro. Ela preserva o contrato real da base Seoul: Creative/vRP com camada de compatibilidade QBCore, usando `ox_inventory`, `ox_target` e `oxmysql`.
