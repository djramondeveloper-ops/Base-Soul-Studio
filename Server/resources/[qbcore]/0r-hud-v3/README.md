# 0r-hud-v3 Seoul

## Nome do resource
`0r-hud-v3`

## Funcao principal
HUD visual para vida, colete, fome, sede, stress, voz, dinheiro, banco, emprego, bussola, minimapa, velocimetro, combustivel e cinto.

## Framework compativel
Adaptado para Seoul Base vRP/Creative. A base possui facade `qb-core`, mas esta adaptacao usa bridge direta `seoul`/`vrp`.

## Dependencias reais
- `vrp`
- `ox_lib`
- `ox_inventory`
- `xsound`
- `pma-voice` para voz/radio

## Instalacao
O resource foi colocado em:
`Server/resources/[qbcore]/0r-hud-v3`

Com `start [qbcore]` no `server.cfg`, ele inicia junto da pasta. Se preferir ensure manual, use:
`ensure 0r-hud-v3`

## Banco de dados/SQL
Nao precisa de tabela propria.

## Itens necessarios
- Dinheiro: `dollar`
- Dinheiro sujo extra: `dirtydollar`

Os itens precisam existir no inventario real da base.

## Permissoes/grupos/jobs
Nao cria permissao propria. O emprego exibido vem dos grupos/servicos do vRP.

## Comandos
- `/hudsettings`: abre configuracao da HUD.
- `/hud`: atalho compat para abrir configuracao.
- `/cinematic`: modo cinematico.
- `/resethudpos`: reseta posicoes.

## Teclas
- `I`: menu de configuracao.
- `B`: cinto da 0r HUD.
- `M`: motor da 0r HUD.

O motor foi movido de `G` para `M` para evitar conflito com o cinto antigo da base.

## Configuracoes principais
Arquivo: `config.lua`

- `Config.MoneySettings.itemName = 'dollar'`
- `Config.MoneySettings.extra_currency.name = 'dirtydollar'`
- `Config.DefaultHudSettings.client_info.extra_currency.active = true`
- `Config.ToggleVehicleEngine.key = 'M'`
- `Config.HideGTAHudComponents = true` para esconder barras nativas de vida/colete do minimapa.

## Funcionamento
1. Ao carregar o player, a bridge Seoul pede dados ao servidor.
2. Fome, sede e stress sao atualizados pelos eventos reais da base:
   - `hud:Hunger`
   - `hud:Thirst`
   - `hud:Stress`
3. Dinheiro em maos vem do item `dollar`.
4. Banco vem das funcoes vRP de banco.
5. Combustivel vem primeiro do statebag `Entity(vehicle).state.Fuel`.

## Como testar
1. Reinicie `vrp`.
2. Reinicie `0r-hud-v3`.
3. Entre no servidor.
4. Confira se aparecem vida, fome, sede, stress, banco e dinheiro.
5. Entre em um veiculo e confira velocimetro, combustivel e cinto.
6. Use `/hudsettings` para abrir o menu.

## O que deve aparecer no console
Nao deve aparecer erro de `modules.bridge.nil`.

## Erros comuns
- `modules.bridge.nil`: `vrp` nao iniciou antes da HUD.
- dinheiro zerado: item `dollar` nao existe ou ox_inventory nao carregou.
- stress/fome/sede zerados: eventos `hud:*` nao chegaram ainda; relogar ou reiniciar `vrp` e a HUD.

## Arquivos alterados/criados
- `shared/init.lua`
- `modules/bridge/seoul/client.lua`
- `modules/bridge/seoul/server.lua`
- `modules/utils/client.lua`
- `config.lua`
- `fxmanifest.lua`
- `locales/pt-br.json`
- `README.md`

## Ajuste do minimapa
As barras nativas verde/azul de vida e colete do GTA foram removidas pelo `modules/hud/client.lua`.
A HUD nova continua exibindo vida/colete nos icones circulares, sem duplicar informacao em cima do minimapa.

## Observacoes finais
O resource antigo `hud` da pasta `[creative]` foi mantido como compatibilidade silenciosa. Ele nao carrega mais a NUI nativa, mas continua atendendo `exports.hud:Wanted`, `exports.hud:Repose`, `hud:Radar`, `hud:Hood`, `hud:AddGemstone` e eventos legados usados pela base.
