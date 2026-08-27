# nation_creator

## Funcao principal

Sistema de selecao e criacao de personagens da base.

## Framework compativel

Seoul vRP/Creative, conforme adaptacao ja existente no resource.

## Alteracao visual Mystic

A NUI foi ajustada para usar a identidade roxa/dourada da base Mystic.

Foram trocadas apenas cores de interface:

- azul principal para roxo Mystic
- laranja de bordas/sombras para dourado Mystic
- gradientes de botoes e selecoes para roxo
- contornos ativos para roxo

## Funcoes

Nenhuma funcao foi alterada.

Nao foram alterados:

- eventos
- callbacks
- client.lua
- server.lua
- config
- banco de dados
- fluxo de criacao
- fluxo de login

## Arquivo alterado

- `nui/style.css`

## Banco de dados

Nao precisa de SQL novo para esta alteracao visual.

## Como aplicar

Reinicie o resource:

```cfg
restart nation_creator
```

Se a NUI antiga continuar aparecendo, limpe cache do FiveM e abra novamente a tela de personagem.
