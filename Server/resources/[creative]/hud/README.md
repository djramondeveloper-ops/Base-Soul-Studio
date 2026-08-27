# hud

## Nome do resource
`hud`

## Funcao principal
Compatibilidade legada da HUD Creative da base Seoul.

## Framework compativel
Seoul Base vRP/Creative.

## Dependencias reais usadas
- `vrp`
- configs reais da vRP:
  - `@vrp/config/Item.lua`
  - `@vrp/config/Vehicle.lua`
  - `@vrp/config/Global.lua`
  - `@vrp/config/Drops.lua`

## Instalacao
O resource continua em:
`Server/resources/[creative]/hud`

Ele inicia com:
`start [creative]`

Se quiser reiniciar manualmente:
`restart hud`

## Banco de dados/SQL
Nao usa tabela propria.

## Itens necessarios
Nao usa item proprio.

## Permissoes/grupos/jobs usados
Nao usa permissao propria.

## O que mudou
A HUD nativa deixou de carregar NUI, HTML, CSS, JS e velocimetro visual.

Ela agora carrega apenas:
- `client-side/compat.lua`
- `server-side/*`
- `shared/*.lua`

## Por que nao apagar totalmente
Outros scripts da base chamam:
- `exports.hud:Wanted`
- `exports.hud:Repose`
- `hud:Radar`
- `hud:Radaroff`
- `hud:Hood`
- `hud:RemoveHood`
- `hud:AddGemstone`
- `hud:RemoveGemstone`
- `hud:Hunger`
- `hud:Thirst`
- `hud:Stress`

Se o resource `hud` fosse removido sem compatibilidade, lojas, inventario, PDM, banco, crafting e outros scripts poderiam quebrar.

## Como testar
1. `restart hud`
2. `restart 0r-hud-v3`
3. Entrar no servidor.
4. Confirmar que a HUD visual nativa nao aparece.
5. Confirmar que a 0r HUD aparece.
6. Testar scripts que chamam Wanted/Repose, lojas e inventario.

## O que deve aparecer no console
Nao deve aparecer erro de export inexistente `hud`.

## Arquivos alterados/criados
- `fxmanifest.lua`
- `client-side/compat.lua`
- `README.md`

## Observacoes finais
Este resource virou uma ponte silenciosa. A HUD visual principal agora e `0r-hud-v3`.
