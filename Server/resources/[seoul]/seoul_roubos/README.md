# seoul_roubos

## Funcao principal

Sistema de roubos adaptado para Seoul Base. Cria roubos gerais, caixa registradora, ATM, joalheria e carro forte usando target/interact.

## Framework compativel

Creative/vRP da Seoul Base.

## Dependencias reais

- `vrp`
- `ox_lib`
- `ox_target`
- `ox_inventory`
- `oxmysql`
- `interact` opcional, se a base usar esse target alternativo
- `will_robbery` opcional, apenas para minigame dos roubos gerais

## Instalacao

O resource fica em:

```txt
Server/resources/[seoul]/seoul_roubos
```

No `server.cfg`, inicie depois de `oxmysql`, `ox_lib`, `vrp`, `ox_target` e `ox_inventory`.

```cfg
ensure seoul_roubos
```

Na base atual ele tambem sobe junto com:

```cfg
start [seoul]
```

## Banco de dados / SQL

Nao usa tabela propria e nao precisa de arquivo SQL. O `oxmysql` e carregado por compatibilidade com a base e com o manifest original.

## Itens necessarios

Itens usados pelo script:

- `lockpick`
- `c4`
- `dirtydollar`
- `blackcard`
- `bluecard`
- `watch`
- `ring`
- `goldbar`
- `aluminum`
- `rubber`
- `plastic`
- `WEAPON_PISTOL`
- `WEAPON_SNSPISTOL`
- `ammo-9`

Na base auditada, esses itens ja estao cadastrados em:

```txt
Server/resources/[core]/vrp/config/Item.lua
Server/resources/[ox]/ox_inventory/data/items.lua
Server/resources/[ox]/ox_inventory/data/weapons.lua
```

As imagens dos itens manuais ficam em:

```txt
seoul_roubos/instalacao/images
```

Caso falte imagem no inventario, copie para:

```txt
Server/resources/[ox]/ox_inventory/web/images
```

## Permissoes / grupos / jobs

Grupo policial configurado:

```lua
Config.PolicePermission = "Police"
```

Fallback legado:

```lua
Config.LegacyPolicePermission = "policia.permissao"
```

A base Seoul/Creative usa `vRP.NumPermission("Police")` e `vRP.HasService(Passport,"Police")` em outros sistemas policiais, por isso o resource foi alinhado para `Police`.

## Comandos

```txt
/seoulroubosstatus
```

Mostra status basico do resource, quantidade de roubos gerais configurados, estado da joalheria e quantidade de carros fortes bloqueados.

## Quem pode usar os comandos

O comando `/seoulroubosstatus` nao tem bloqueio de permissao no script atual. Pode ser usado pelo console e por jogadores.

## Configuracoes do Config.lua

- `Config.Debug`: ativa logs extras no console.
- `Config.ResourceName`: nome do resource.
- `Config.PolicePermission`: grupo de policia contado em servico.
- `Config.LegacyPolicePermission`: fallback para bases antigas.
- `Config.PaymentItem`: item de pagamento padrao dos caixas.
- `Config.SkipInvalidCoords`: ignora coordenadas absurdas no config.
- `Config.CreateJewelryDrawerTargets`: cria ou nao os targets das vitrines da joalheria.
- `Config.JewelryDoors`: controle opcional de portas da joalheria.
- `Config.stockade`: item, policiais e pagamento do carro forte.
- `Config.jewelry`: policiais, local da bomba e recompensas da joalheria.
- `Config.gerais`: locais, cooldowns, itens exigidos e recompensas dos roubos gerais.
- `Config.cashMachine`: configuracao de ATM e caixa registradora.

## Coordenadas configuraveis

As coordenadas dos roubos gerais ficam em `Config.gerais`.

O local da bomba da joalheria fica em:

```lua
Config.jewelry.bombLocs
```

As vitrines ficam em:

```lua
Config.JewelryDrawers
```

## Valores configuraveis

- Quantidade minima de policiais.
- Item exigido para cada roubo.
- Tempo de roubo.
- Distancia maxima para nao cancelar.
- Cooldown.
- Pagamento minimo e maximo.
- Tempo da bomba do ATM.

## Tempos / cooldowns

Roubos gerais usam `time` e `cooldown` dentro de cada entrada de `Config.gerais`.

Joalheria usa cooldown interno de 7200 segundos e janela ativa de 2700 segundos depois da explosao.

Caixas e ATMs usam bloqueio local de 120 segundos.

## Funcionamento passo a passo

1. O jogador vai ate um target de roubo.
2. O script verifica se nao e policial e se nao esta em SafeZone.
3. O server confere passaporte, item exigido e policiais em servico.
4. O item exigido e consumido.
5. A policia recebe alerta via `NotifyPush`.
6. O player executa animacao/progresso.
7. Ao finalizar, recebe os itens configurados.

## Como iniciar os roubos no jogo

- Roubos gerais: mirar/interagir no ponto configurado e escolher `Roubar`.
- Caixa registradora: mirar/interagir no caixa e escolher `Roubar Caixa`.
- ATM: mirar/interagir no ATM e escolher `Explodir ATM`.
- Joalheria: ir no ponto da bomba e escolher `Roubar Joalheria`; depois roubar as vitrines quando liberadas.
- Carro forte: mirar/interagir no veiculo `stockade` e escolher `Roubar Carro Forte`.

## Como testar

1. Reinicie dependencias se mexeu em itens:

```cfg
restart ox_inventory
restart vrp
```

2. Reinicie o resource:

```cfg
restart seoul_roubos
```

3. No console ou no jogo, rode:

```txt
/seoulroubosstatus
```

4. Entre com policiais suficientes em servico no grupo `Police`.
5. Teste um roubo simples de caixa com `lockpick`.
6. Teste um ATM com `c4`.
7. Teste joalheria com `c4` e `bluecard`.
8. Teste carro forte com `blackcard`.

## O que deve aparecer no console

Ao iniciar/finalizar roubos:

```txt
[seoul_roubos] Passport ID iniciou/finalizou roubo: Nome
```

Com `Config.Debug = true`, tambem aparecem logs extras do client para coordenadas invalidas ignoradas.

## Erros comuns e como resolver

- `Contingente indisponivel`: nao ha policiais suficientes em servico no grupo `Police`.
- `Voce precisa de item`: o jogador nao possui `lockpick`, `c4`, `bluecard` ou `blackcard`.
- Target nao aparece: confirme `ox_target` ou `interact` iniciado antes do resource.
- Vitrine da joalheria nao aparece: ative `Config.CreateJewelryDrawerTargets = true` se a base nao tiver compat externo de vitrines.
- Item sem imagem: copie as imagens de `instalacao/images` para `ox_inventory/web/images`.

## Arquivos alterados / criados

- `fxmanifest.lua`: adicionada dependencia `ox_lib`.
- `Config.lua`: grupo policial alinhado para `Police` e pagamentos aleatorios configurados por min/max.
- `server/core.lua`: checagem de policiais corrigida, pagamentos aleatorios por roubo e contador de stockades corrigido.
- `README.md`: criado.

## Observacoes finais

Este resource nao cria banco, nao usa NUI propria e nao depende de QBCore/QBX. Ele usa o padrao Creative/vRP da Seoul Base com inventario ox.
