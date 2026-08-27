# seoul_brothels

## Funcao principal

Sistema de bordeis para Seoul Base, com cadastro por Passport, quartos, funcionarias NPC, caixa do estabelecimento, precos por servico e atendimento pago.

## Framework compativel

Creative/vRP da Seoul Base.

Este resource usa `vrp` diretamente, nao QBCore/QBX puro.

## Dependencias reais

- `vrp`
- `ox_lib`
- `oxmysql`
- `ox_target`
- OneSync ativo
- `AdminControl` opcional para abrir o menu pela central de administracao

## Instalacao

Coloque a pasta em:

```txt
Server/resources/[seoul]/seoul_brothels
```

Garanta que o `server.cfg` inicie as dependencias antes do resource.

## Linha correta de ensure

Se usar `start [seoul]`, o resource deve iniciar junto com os outros resources da pasta.

Ordem recomendada:

```cfg
ensure oxmysql
ensure ox_lib
ensure vrp
ensure ox_target
ensure AdminControl
ensure seoul_brothels
```

Se deixar dentro do bloco `[seoul]`, confirme no console se aparece:

```txt
[seoul_brothels] carregado: X bordel(is), Y funcionaria(s) spawnada(s)
```

## Banco de dados / SQL

Precisa de banco de dados.

O arquivo SQL existe em:

```txt
sql/install.sql
```

O `server/main.lua` tambem cria automaticamente as tabelas ao iniciar usando `CREATE TABLE IF NOT EXISTS`.

Tabelas usadas:

- `seoul_brothels`
- `seoul_brothel_rooms`
- `seoul_brothel_workers`
- `seoul_brothel_members`
- `seoul_brothel_transactions`

## Itens necessarios

Nao usa item obrigatorio.

O pagamento e feito por dinheiro/banco via funcoes vRP configuradas em `Config.MoneyAccount`.

## Permissoes / grupos / jobs

Permissao administrativa:

```lua
Config.AdminPermission = 'Admin'
```

Quem tem grupo/permissao `Admin` pode criar e configurar bordeis.

O dono do bordel e definido por Passport. O dono pode administrar o caixa, precos e gerentes. Gerentes podem acessar os pontos de administracao do estabelecimento.

## Comandos disponiveis

```txt
/seoulbrothels
```

Abre diretamente o painel de bordeis para administradores.

```txt
/seoulbrothelsstatus
```

Mostra no console e notifica o admin com:

- quantidade de bordeis
- quantidade de quartos
- quantidade de funcionarias cadastradas
- quantidade de funcionarias ativas
- quantidade de funcionarias spawnadas
- status de `ox_target`, `interact` e OneSync

```txt
/seoulbrothelsrespawn
```

Recarrega os dados do banco, recria as funcionarias NPC e sincroniza os clients.

Pelo console do servidor tambem pode usar:

```txt
seoulbrothelsstatus
seoulbrothelsrespawn
```

## Configuracoes do config.lua

- `Config.AdminPermission`: grupo/permissao admin.
- `Config.Debug`: quando `true`, mostra logs extras de spawn.
- `Config.TargetDistance`: distancia do target na funcionaria.
- `Config.WorkerInteractDistance`: distancia maxima para comprar atendimento.
- `Config.SessionExpireSeconds`: tempo maximo para chegar ao quarto.
- `Config.ServiceDurationMs`: duracao do progress do atendimento.
- `Config.BusinessShare`: porcentagem que entra no caixa do bordel.
- `Config.MoneyAccount`: `bank` usa `PaymentBank`; `full` usa `PaymentFull`.
- `Config.MaxBrothels`: limite de bordeis.
- `Config.MaxRoomsPerBrothel`: limite de quartos por bordel.
- `Config.MaxWorkersPerBrothel`: limite de funcionarias por bordel.
- `Config.MaxManagersPerBrothel`: limite de gerentes.
- `Config.MaxTransactionAmount`: limite de deposito/saque.
- `Config.WorkerModels`: modelos permitidos para funcionarias.
- `Config.Services`: servicos e precos padrao.
- `Config.Street`: atendimento de rua com NPCs naturais do GTA.

## Coordenadas configuraveis

As coordenadas ficam no banco, nao no arquivo config.

Pelo menu admin voce define:

- entrada
- administracao
- caixa
- quartos
- posicao das funcionarias

## Como configurar um bordel

1. Entre no servidor com grupo `Admin`.
2. Use `/gerenciar`, `/admincontrol`, `/adm2` ou `/seoulbrothels`.
3. Abra o menu de bordeis.
4. Clique em `Criar novo bordel aqui`.
5. Entre no local do estabelecimento.
6. Marque `ENTRADA`, `ADMINISTRACAO` e `CAIXA`.
7. Va ate cada quarto e use `Adicionar quarto nesta posicao`.
8. Va ate o local onde a funcionaria deve ficar e use `Adicionar funcionaria nesta posicao`.
9. Escolha um modelo permitido.
10. Deixe o bordel como `ABERTO`.
11. Use `/seoulbrothelsrespawn` se a funcionaria nao aparecer imediatamente.

## Como usar o quarto

1. O jogador chega perto da funcionaria.
2. Usa o target: `Falar com funcionaria`.
3. Escolhe o servico.
4. O sistema cobra o valor.
5. O waypoint e marcado no quarto disponivel.
6. O jogador vai ate o quarto.
7. Dentro do quarto aparece `[E] Iniciar atendimento`.
8. Pressiona `E` e aguarda o progress terminar.

## O que deve aparecer no console

Ao iniciar:

```txt
[seoul_brothels] carregado: X bordel(is), Y funcionaria(s) spawnada(s)
```

Ao usar status:

```txt
[seoul_brothels] bordels=X quartos=Y funcionarias=Z ativas=A spawnadas=B invalidas=C
[seoul_brothels] ox_target=started interact=missing onesync=on
```

`interact=missing` nao impede o funcionamento se `ox_target=started`.

## Erros comuns e como resolver

### As funcionarias nao aparecem

Use:

```txt
/seoulbrothelsstatus
```

Se `funcionarias=0`, nenhuma funcionaria foi cadastrada. Adicione pelo menu admin.

Se `funcionarias>0` e `spawnadas=0`, use:

```txt
/seoulbrothelsrespawn
```

Se continuar `spawnadas=0`, confira:

- OneSync ligado.
- `ox_target` iniciado.
- coordenadas da funcionaria validas.
- modelo dentro de `Config.WorkerModels`.

### Nao abre o menu de bordeis

Confira se voce tem grupo `Admin`.

Teste:

```txt
/seoulbrothels
```

Se abrir por esse comando, o problema esta no caminho via `AdminControl`.

### Nao aparece target na funcionaria

Confira se `ox_target` esta iniciado:

```txt
/seoulbrothelsstatus
```

O status precisa mostrar:

```txt
ox_target=started
```

### Compra aprovada mas quarto nao funciona

O jogador precisa ir ate menos de 2 metros da coordenada do quarto. O texto `[E] Iniciar atendimento` aparece somente durante uma sessao ativa e antes de `Config.SessionExpireSeconds` expirar.

### Mensagem "Nenhum quarto disponivel"

O bordel nao tem quarto ativo cadastrado, ou todos os quartos estao em sessoes ativas.

## Arquivos alterados / criados

- `config.lua`
- `server/main.lua`
- `README.md`

## Observacoes finais

Nao precisa reiniciar a base inteira para testar. Na maioria dos casos basta:

```txt
restart seoul_brothels
```

Se o menu pelo AdminControl nao aparecer:

```txt
restart AdminControl
restart seoul_brothels
```

Depois use:

```txt
/seoulbrothelsstatus
```
