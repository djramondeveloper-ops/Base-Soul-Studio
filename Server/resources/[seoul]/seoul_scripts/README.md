# seoul_scripts

## Nome do resource
`seoul_scripts`

## Funcao principal
Pacote de sistemas extras da Seoul, incluindo animacoes, queda de braco, tackle, corda, pets, flashbang, armazem, perimetro e outros modulos.

## Framework compativel
Seoul Base vRP/Creative.

## Dependencias reais usadas
- `vrp`
- `ox_lib`
- `oxmysql`
- `ox_inventory` para alguns modulos
- `ox_target` para Warehouse

## Instalacao
O resource ja esta em:
`Server/resources/[seoul]/seoul_scripts`

Ele inicia com:
`start [seoul]`

Se quiser reiniciar manualmente:
`restart seoul_scripts`

## Banco de dados/SQL
O modulo Warehouse usa a tabela `seoul_warehouses`.

Arquivo SQL de referencia:
`instalacao/sql/warehouse.sql`

O server do Warehouse tambem cria a tabela automaticamente com `CREATE TABLE IF NOT EXISTS`.

## Itens necessarios
Configurados em `shared/config.lua`:
- `dollar`
- `dirtydollar`
- `skate`
- `rope`
- `WEAPON_FLASHBANG`
- `camera`
- `binoculars`

## Permissoes/grupos/jobs usados
Configurados em `SeoulScripts.Permissions`:
- Admin
- Police / Policia
- Paramedic / Hospital
- Mechanic / LSCustoms / Bennys quando usado por modulo relacionado

## Comandos/eventos principais corrigidos
- `tackle:Update`
- `tackle:Player`
- `ArmBraker:check_sv`
- `ArmBraker:updategrade_sv`
- `ArmBraker:disband_sv`

## O que foi corrigido
- O Tackle agora envia e recebe o vetor de queda de forma consistente.
- A queda de braco agora marca a sessao como iniciada.
- A queda de braco valida Passport antes de ocupar mesa.
- A queda de braco valida coordenada server-side com `GetPlayerPed`/`GetEntityCoords`.
- A queda de braco bloqueia jogador em bucket diferente na mesma mesa.
- A queda de braco limpa mesa quando jogador sai ou desconecta.
- A queda de braco reseta estado client quando a mesa esta cheia.

## Como testar
1. `restart seoul_scripts`
2. Testar tackle com dois players policiais proximos.
3. Testar queda de braco com dois players.
4. Sair de uma queda de braco usando cancelar.
5. Desconectar um player durante espera/duelo e conferir se a mesa libera.

## O que deve aparecer no console
Nao deve aparecer erro relacionado a `tackle:Player`, vetor nil, player nil ou mesa cheia travada.

## Erros comuns
- Se o Tackle nao funcionar, confira se o player possui state `Police`.
- Se Warehouse nao abrir, confira `ox_target`, `ox_inventory` e a tabela `seoul_warehouses`.
- Se ArmBraker nao iniciar, confirme que os dois players estao no mesmo bucket/rota.

## Arquivos alterados
- `Tackle/client-side/tackle.lua`
- `Tackle/server-side/server.lua`
- `ArmBraker/client-side/client.lua`
- `ArmBraker/server-side/server.lua`
- `README.md`

## Observacoes finais
As correcoes foram feitas sem transformar o pacote em QBCore/QBX. O resource continua seguindo o contrato Seoul vRP/Creative real da base.
