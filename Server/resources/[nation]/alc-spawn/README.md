# alc-spawn

Sistema de seleção de spawn da base Seoul v5.

## Framework

vRP/Creative, usando `vrp/lib/Tunnel` e `vrp/lib/Proxy`.

## Dependências

- `vrp`
- NUI própria em `web/index.html`, `web/script.js` e `web/style.css`

## Instalação

No `server.cfg`:

```txt
ensure alc-spawn
```

## Banco de dados

Não cria tabela própria. O resource consulta o usuário pela interface vRP existente.

## Itens

Não usa item.

## Comandos

Não possui comandos próprios.

## Configuração

Os pontos de spawn ficam em `config.lua`, dentro de `Controller.locations`.
Cada local usa:

```lua
coords = { x, y, z, heading }
```

## Correção aplicada

Antes, o spawn usava `SetEntityCoords` direto no `z` configurado. Quando a colisão do mapa ainda não estava carregada, o jogador ficava preso/flutuando no ar.

Agora o `main.lua` usa um teleport seguro:

1. Fecha a tela com fade.
2. Congela o ped.
3. Solicita colisão em `x,y,z`.
4. Aguarda `HasCollisionLoadedAroundEntity`.
5. Calcula o chão com `GetGroundZFor_3dCoord`.
6. Teleporta para `groundZ + 0.05`.
7. Descongela o ped e reativa colisão.

## Como testar

1. Rode `restart alc-spawn`.
2. Abra o seletor de spawn.
3. Escolha qualquer local.
4. O personagem deve nascer no chão, sem ficar preso no ar.
5. Teste também `Última localização`.

## Arquivos alterados/criados

- `main.lua`: teleport seguro no chão.
- `README.md`: documentação do resource.

## Erros comuns

- Se um local nascer em lugar errado, confira o `coords` em `config.lua`.
- Se cair dentro de interior/MLO, ajuste manualmente o `z` e `heading` daquele local.
- Se o mapa ainda demorar a carregar, aumente o timeout no `teleportToGround` em `main.lua`.