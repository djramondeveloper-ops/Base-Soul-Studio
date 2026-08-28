# interact

## Funcao principal

Resource de interacao/target da base Seoul. Ele mostra indicadores 3D, lista opcoes proximas e dispara os eventos/exports reais dos resources configurados.

## Framework compativel

- Seoul Creative/vRP
- ox_lib
- Compatibilidade declarada para ox_target/qtarget pelo proprio resource

## Dependencias reais

- `ox_lib`
- `vrp`

O `fxmanifest.lua` tambem carrega `server/lib/session_store.js` e arquivos web/client do proprio resource.

## Instalacao

Este resource ja esta dentro da base em:

`Server/resources/[system]/interact`

No `Server/server.cfg`, mantenha a ordem geral da base:

```cfg
ensure ox_lib
ensure vrp
start [system]
```

Como ele esta dentro de `[system]`, normalmente sobe junto com `start [system]`.

## Banco de dados e SQL

Nao usa SQL proprio nesta correcao.

## Itens necessarios

Nao cadastra itens.

## Permissoes, grupos e jobs

Esta correcao nao adiciona permissao, grupo ou job.

## Comandos

Nao foram adicionados comandos.

## Configuracoes principais

Arquivo:

`client/modules/config.lua`

Campos importantes:

- `config.maxInteractDistance`: distancia em que o indicador pequeno aparece.
- `config.themeColor`: cor padrao de fallback.
- `config.IndicatorSprite`: textura usada como referencia original do indicador.
- `config.minInteractionSize` e `config.maxInteractionSize`: tamanho minimo/maximo do indicador.

## Coordenadas configuraveis

As coordenadas das interacoes nao ficam neste README. Elas vem dos resources que registram opcoes no `interact`.

## Funcionamento passo a passo

1. O client procura interacoes proximas.
2. Quando a interacao esta longe ou sem opcao ativa, desenha o indicador pequeno.
3. Quando chega perto, desenha a DUI com as opcoes, como `ABRIR BANCO`.
4. A cor da base vem do AdminControl/Seoul por eventos e `GlobalState`.
5. Agora a mesma cor e enviada tambem para o indicador pequeno.

## Correcao aplicada

Antes, o indicador pequeno carregava `web/assets/hidden.svg` como imagem direta. Esse SVG possui `fill="#9B59B6"`, deixando o pontinho roxo fixo mesmo quando o AdminControl mudava a cor da base.

Agora:

- `web/hidden.html` usa um elemento `div` para o indicador.
- `web/style.css` aplica `hidden.svg` como mascara e colore com `var(--theme-color)`.
- `client/modules/hidden.lua` ganhou `sendMessage`.
- `client/main.lua` envia `setColor` para a DUI principal e para a DUI do indicador pequeno.

## Como testar

1. Reinicie o resource:

```cfg
restart interact
```

2. Entre em uma interacao de longe e veja o pontinho no chao.
3. Altere a cor da base pelo AdminControl.
4. Confirme que o pontinho muda junto com o card de interacao.

## O que deve aparecer no console

Nao ha log novo obrigatorio para esta correcao. O resource deve reiniciar sem erro Lua/NUI.

## Erros comuns

- Se o card muda cor, mas o pontinho nao muda: reinicie `interact` e limpe cache NUI se necessario.
- Se o pontinho sumir: conferir se `web/assets/hidden.svg` existe e se `web/**` continua listado em `fxmanifest.lua`.
- Se a cor voltar roxa ao iniciar: conferir se o AdminControl esta publicando `SeoulTheme` ou `Basics` no `GlobalState`.

## Arquivos alterados/criados

Alterados:

- `client/main.lua`
- `client/modules/hidden.lua`
- `web/hidden.html`
- `web/style.css`

Criado:

- `README.md`

Backup criado antes da alteracao em `_codex_backups/`.

## Observacoes finais

Correcao visual e isolada ao `interact`. Nao altera HUD, inventario, banco, target de outros resources ou contratos de abertura como banco/lojas.
