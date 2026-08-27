# mri_Qblips — Manual

Criador de blips em runtime: um painel NUI para criar, editar, apagar e restringir blips do mapa, com persistência em MySQL e sincronização imediata para todos os jogadores.

---

## Sumário

1. [Dependências](#dependências)
2. [Instalação](#instalação)
3. [Permissões (ACE)](#permissões-ace)
4. [Comandos](#comandos)
5. [Configuração](#configuração)
6. [Painel (`/blip`)](#painel-blip)
7. [Restrição por job e gangue](#restrição-por-job-e-gangue)
8. [Banco de dados](#banco-de-dados)
9. [Integrações](#integrações)
10. [Entrypoints para outros recursos](#entrypoints-para-outros-recursos)
11. [Estrutura de arquivos](#estrutura-de-arquivos)

---

## Dependências

| Recurso | Obrigatório | Observação |
|---|---|---|
| `oxmysql` | Sim | Declarado em `dependencies` no `fxmanifest.lua`. O servidor aborta se o recurso não estiver iniciado |
| `qb-core` / `qbx_core` | Sim | `client/framework/qb-core.lua` chama `exports['qb-core']:GetCoreObject()` no load. É de onde vêm job e gangue do jogador |

Existe um `client/framework/es_extended.lua`, mas o arquivo está **inteiramente comentado** — o recurso hoje só funciona com o framework QB.

---

## Instalação

1. Copie a pasta `mri_Qblips` para `resources/`.
2. Adicione ao `server.cfg`, depois do `oxmysql` e do framework:
   ```
   ensure mri_Qblips
   ```
3. Libere a permissão ACE (ver [Permissões (ACE)](#permissões-ace)) — sem ela o `/blip` não responde.
4. O SQL é **opcional**. Se a tabela `mri_Qblips` não existir, o servidor a cria sozinha no `MySQL.ready`. Importe `db/blips.sql` apenas se quiser começar com o conjunto de blips já mapeados (lojas, hospitais, coleta seletiva etc.).

A UI é servida de `web/build/`. Se essa pasta não existir, o recurso imprime um aviso no console e o painel não abre — use uma release já buildada ou rode o build em `web/`.

---

## Permissões (ACE)

Tudo que escreve (criar, editar, apagar blip) e o comando `/blip` são protegidos pela ACE `command.blipcreator`, verificada no servidor com `IsPlayerAceAllowed`:

```
add_ace group.admin command.blipcreator allow
```

O gate existe tanto no `RegisterCommand('blip')` quanto no evento `mri_Qblips:editBlip`, então não é possível criar ou apagar blip disparando o evento direto sem a ACE.

---

## Comandos

| Comando | Permissão | Descrição |
|---|---|---|
| `/blip` | ACE `command.blipcreator` | Abre o painel NUI de gerenciamento de blips |

---

## Configuração

O recurso **não tem arquivo de config**. Toda a configuração é por blip e vive na coluna `data` (JSON) da tabela `mri_Qblips`, editada pelo painel. Os campos abaixo são os que o cliente lê ao desenhar o blip:

| Campo | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `name` | string | Sim | Nome exibido no mapa. Se vier vazio, o servidor usa as coordenadas como nome |
| `coords` | `{x,y,z}` | Sim | Posição do blip. Se vier vazio, o servidor usa a posição atual do jogador que criou |
| `Sprite` | number | Sim | ID do sprite do blip (`SetBlipSprite`) |
| `sColor` | number | Sim | ID da cor do blip (`SetBlipColour`) |
| `scale` | number | Sim | Tamanho do blip. O cliente divide por 10 antes de aplicar (`scale/10`) — `7` no painel vira `0.7` no jogo |
| `alpha` | number | Sim | Opacidade, de 0 a 255 (`SetBlipAlpha`) |
| `sRange` | bool | Não | Blip de curto alcance: só aparece com o jogador por perto (`SetBlipAsShortRange`) |
| `outline` | bool | Não | Desenha o indicador de contorno (`ShowOutlineIndicatorOnBlip`) |
| `tickb` | bool | Não | Desenha o "tick" de concluído sobre o blip (`ShowTickOnBlip`) |
| `hideb` | bool | Não | Esconde do minimapa: usa `SetBlipDisplay = 3` em vez de `2` |
| `bflash` | bool | Não | Faz o blip piscar (`SetBlipFlashes`) |
| `ftimer` | number | Não | Intervalo do piscar, em ms. Só tem efeito com `bflash = true`. Padrão do painel: `50000` |
| `hideUi` | bool | Não | Desativa o blip: o cliente não o cria para ninguém. Serve para guardar um blip sem exibi-lo |
| `groups` | objeto `{ job = grade }` | Não | Restringe a visibilidade — ver [Restrição por job e gangue](#restrição-por-job-e-gangue). Sem `groups`, o blip é visível para todos |
| `SpriteImg` | string | Não | URL da imagem do sprite. Usado só como preview no painel, não afeta o jogo |
| `scImg` | string | Não | Cor em `rgb(...)`. Usado só como preview no painel, não afeta o jogo |
| `zone` | string | — | Nome da zona do GTA, calculado pelo cliente a partir das coordenadas. Só é exibido na tabela do painel |
| `colors`, `items` | number | — | Campos legados, gravados no JSON mas não lidos por nenhum código do cliente |

---

## Painel (`/blip`)

Aberto pelo comando `/blip`. Ao abrir pela primeira vez, o cliente envia a lista completa de blips para a NUI; depois disso a lista é atualizada de forma incremental a cada criação/edição.

- **Tabela de blips** — lista todos os blips com nome e zona, com busca por nome.
- **Criar / editar** — formulário com abas: geral (nome, escala, opacidade, switches), sprite, cor e grupos.
- **Apagar** — remove o blip do banco e de todos os clientes conectados.
- **Teleportar** — move o seu personagem para as coordenadas do blip (`SetEntityCoords`). Não há confirmação nem verificação de altura do solo.
- **Coordenadas** — se o formulário for enviado sem coordenadas, o servidor grava a posição atual de quem criou.

Toda alteração é gravada no MySQL e propagada com `TriggerClientEvent(..., -1, ...)`, ou seja, aparece imediatamente para todos os jogadores online, sem restart.

---

## Restrição por job e gangue

O campo `groups` é um mapa `{ nome_do_grupo = grade_mínima }`. O cliente só desenha o blip se `IsPlayerInGroup(blip.groups)` retornar verdadeiro, comparando o `job` e o `gang` do jogador (`client/framework/qb-core.lua`).

```json
{ "groups": { "police": 0, "ambulance": 2 } }
```

Neste exemplo, o blip aparece para qualquer membro do `police` e apenas para membros do `ambulance` com grade 2 ou superior.

A lista é reavaliada nos eventos `QBCore:Client:OnJobUpdate`, `QBCore:Client:OnGangUpdate` e `QBCore:Client:OnPlayerLoaded` — cada um deles refaz o `mri_Qblips:getBlips`, então trocar de emprego atualiza os blips na hora.

---

## Banco de dados

Tabela única, criada automaticamente se não existir:

```sql
CREATE TABLE IF NOT EXISTS `mri_Qblips` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

O `db/blips.sql` traz essa estrutura mais um seed de blips do mapa (lojas de conveniência, lojas de armas, bares, petshop, coleta seletiva, centro de reciclagem, central de trabalhos, lojas de pesca).

Todos os blips são carregados em memória no `MySQL.ready` e servidos da RAM — o banco só é tocado em escrita.

---

## Integrações

### qb-core / qbx_core

Única integração real. O recurso usa o core para:

- Obter `job` e `gang` do jogador (`QBCore.Functions.GetPlayerData`), base da restrição por `groups`.
- Recarregar os blips quando o jogador entra ou troca de job/gangue (`QBCore:Client:OnPlayerLoaded`, `OnJobUpdate`, `OnGangUpdate`).

---

## Entrypoints para outros recursos

O recurso **não expõe exports**. A comunicação é por eventos de rede.

### `mri_Qblips:editBlip` (server)

Cria, atualiza ou apaga um blip. É o evento usado pela própria NUI e **exige ACE `command.blipcreator`** do chamador.

```lua
-- criar (id = false): coords e name são preenchidos com a posição/coords do jogador se omitidos
TriggerServerEvent('mri_Qblips:editBlip', false, {
    name = 'Hospital',
    coords = vector3(295.83, -1446.94, 29.97),
    Sprite = 61,
    sColor = 1,
    scale = 7,
    alpha = 255,
    sRange = true,
})

-- atualizar
TriggerServerEvent('mri_Qblips:editBlip', blipId, blipData)

-- apagar (data = nil)
TriggerServerEvent('mri_Qblips:editBlip', blipId)
```

### `mri_Qblips:getBlips` (server)

Pede o conjunto completo de blips. O servidor responde com `mri_Qblips:setBlips` para o chamador. É o que o cliente dispara no start e a cada troca de job/gangue.

```lua
TriggerServerEvent('mri_Qblips:getBlips')
```

### Eventos server → client

| Evento | Payload | Descrição |
|---|---|---|
| `mri_Qblips:setBlips` | `(blips)` | Substitui a lista inteira; o cliente remove os blips antigos e recria |
| `mri_Qblips:setBlip` | `(id, _, blipData)` | Um blip novo foi criado — enviado para todos (`-1`) |
| `mri_Qblips:editBlip` | `(id, data)` | Um blip foi alterado (`data`) ou apagado (`data = nil`) — enviado para todos (`-1`) |
| `mri_Qblips:triggeredCommand` | — | Abre o painel NUI no cliente que executou `/blip` |

---

## Estrutura de arquivos

```
mri_Qblips/
├── client/
│   ├── main.lua                 — cria/remove os blips do mundo, aplica sprite, cor, escala, flash e display
│   ├── utils.lua                — callbacks NUI (criar, apagar, teleportar, sair) e abertura do painel
│   └── framework/
│       ├── qb-core.lua          — job/gang do jogador, IsPlayerInGroup e reload nos eventos do core
│       └── es_extended.lua      — suporte a ESX, inteiramente comentado (inativo)
├── server/
│   └── main.lua                 — cache em memória, CRUD no MySQL, gate de ACE e comando /blip
├── db/
│   └── blips.sql                — estrutura da tabela mri_Qblips + seed de blips do mapa
├── web/
│   ├── build/                   — UI compilada (servida como ui_page)
│   └── src/                     — fonte React: tabela de blips, formulário, seletores de sprite e cor
└── fxmanifest.lua
```
