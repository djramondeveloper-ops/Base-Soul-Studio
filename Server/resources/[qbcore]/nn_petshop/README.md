# nn_petshop

## Funcao principal
Sistema de petshop para comprar pets, spawnar pets comprados, controlar cachorro, comprar acessorios e comprar/usar petiscos.

## Framework compativel
Adaptado para a Seoul Base vRP/Creative, usando `vRP.Passport`, inventario vRP/Creative e itens tambem registrados no `ox_inventory`.

## Dependencias reais
- `vrp`
- `oxmysql`
- `interact`
- `ox_inventory` para imagens e registro paralelo de itens

## Instalacao
O resource foi instalado em:

`Server/resources/[qbcore]/nn_petshop`

Como o `server.cfg` ja inicia a pasta `[qbcore]`, normalmente nao precisa adicionar ensure individual. Se preferir iniciar separado, use:

```cfg
ensure nn_petshop
```

Mantenha `vrp`, `oxmysql`, `ox_inventory` e `interact` iniciados antes do resource.

## Banco de dados / SQL
Precisa de banco de dados.

O `server/main.lua` cria automaticamente ao iniciar:
- `nn_petshop_pets`
- `nn_petshop_clothing`

Se a tabela ja existir incompleta de uma instalacao antiga, o start tambem confere e adiciona as colunas necessarias:
- `custom_name`
- `obedience`
- `hunger`
- `thirst`
- `equipped_clothing`

Tambem existe SQL original em `install/nn_petshop.sql`, mantido apenas como referencia.

## Itens necessarios
Os itens abaixo foram cadastrados nos dois sistemas obrigatorios da Seoul:

- `small_treat`
- `big_treat`
- `tastymeat`
- `medium_cookie`
- `big_cookie`
- `fruit_slice`
- `pupcup`
- `yogurt`
- `dog_treat`

Registros alterados:
- `Server/resources/[core]/vrp/config/Item.lua`
- `Server/resources/[ox]/ox_inventory/data/items.lua`

Imagens copiadas para:
- `Server/resources/[ox]/ox_inventory/web/images`

## Permissoes, grupos e jobs
Nao usa permissao, grupo ou job por padrao.

## Comandos disponiveis
- `/petshop` abre a loja de pets.
- `/treatshop` abre a loja de petiscos.
- `/dogspawn` abre a lista de pets comprados.
- `/controlldog` abre o controle do cachorro.
- `/adjustaccessory` comando tecnico do script para ajuste de acessorios.
- `/testdogsit` comando de teste do script original.

Os comandos sao liberados para qualquer jogador.

## Configuracoes principais
Arquivo:

`shared/config.lua`

Configuravel:
- coordenada do petshop em `Config.ShopCoords`
- alvo da loja em `Config.PetShopTarget`
- alvo dos petiscos em `Config.TreatShopTarget`
- comandos e keybinds em `Config.Shortcuts`
- lista de cachorros em `Config.Dogs`
- lista de gatos em `Config.Cats`
- acessorios em `Config.Clothing`
- props dos acessorios em `Config.ClothingProps`
- petiscos em `Config.Treats`
- obediencia, fome, sede e cooldowns

## Funcionamento passo a passo
1. Jogador usa o interact no ponto do petshop ou o comando `/petshop`.
2. UI abre para comprar pet e acessorio.
3. Servidor valida passaporte, dinheiro e duplicidade.
4. Compra e posse ficam salvas no banco.
5. Jogador usa `/dogspawn` para abrir pets comprados e spawnar.
6. Jogador usa `/controlldog` para controlar o cachorro.
7. Jogador compra petiscos no interact da loja de petiscos ou em `/treatshop`.
8. Ao usar petisco no cachorro, servidor valida o item no inventario e aplica efeito.

## Como testar
1. Reinicie `vrp`, `oxmysql`, `ox_inventory`, `interact` e `nn_petshop`.
2. No console deve aparecer:

```text
[nn_petshop] Framework: Seoul vRP/Creative
[nn_petshop] Server ready (Seoul vRP/Creative + oxmysql).
[nn_petshop] Target: interact
```

3. Entre no ponto configurado em `Config.ShopCoords`.
4. Veja se o interact mostra `Abrir Petshop`.
5. Compre um pet com dinheiro suficiente.
6. Use `/dogspawn` e spawn o pet.
7. Use `/treatshop`, compre um petisco e teste no cachorro.

## Erros comuns
- Se nao aparecer interact: confira se `interact` esta iniciado antes do `nn_petshop`.
- Se nao comprar: confira se o jogador tem dinheiro no item de dinheiro da Seoul ou banco compativel com `vRP.PaymentFull`.
- Se item nao aparecer no inventario: reinicie `ox_inventory` apos alterar `data/items.lua`.
- Se tabela nao criar: confira conexao do `oxmysql`.

## Arquivos alterados/criados
- `fxmanifest.lua`
- `server/framework.lua`
- `server/main.lua`
- `client/target_adapter.lua`
- `client/main.lua`
- `shared/config.lua`
- `README.md`
- `Server/resources/[core]/vrp/config/Item.lua`
- `Server/resources/[ox]/ox_inventory/data/items.lua`
- imagens em `Server/resources/[ox]/ox_inventory/web/images`

## Observacoes finais
O resource original tinha bridge ESX/QBCore/Standalone. Nesta instalacao, a bridge usada e a Seoul vRP/Creative real da base. O target principal foi ajustado para preferir `interact`.
