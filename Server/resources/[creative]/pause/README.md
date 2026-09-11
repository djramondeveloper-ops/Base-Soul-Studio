# pause

Menu pause customizado para a base Seoul/Creative vRP.

## Framework compatível

- Seoul vRP/Creative
- Usa `Tunnel`, `Proxy`, `vRP`, `oxmysql`, `hud`, `lb-phone`, `discord` e `crons`.

## Função principal

Substitui o fluxo do menu de pausa por uma NUI própria com:

- Home do jogador
- Loja de itens
- Loja de veículos
- Premium/VIP
- Battlepass
- Caixas
- Marketplace
- Ranking
- Recompensa diária
- Resgate de códigos
- Atalhos para mapa e configurações

## Instalação

O resource já está em:

```txt
Server/resources/[creative]/pause
```

Como o `server.cfg` usa:

```txt
start [creative]
```

o resource é iniciado junto com a pasta `[creative]`.

Para reiniciar apenas ele:

```txt
restart pause
```

## Dependências reais

- `vrp`
- `oxmysql`
- `hud`
- `lb-phone`
- `discord`
- `crons`
- `propertys`
- `skinweapon`

## Banco de dados

O resource cria automaticamente ao iniciar:

- `deaths_creative`
- `codes_creative`
- `codes_creative_redeemd`

Também existe SQL manual em:

```txt
sql/pause.sql
```

## Itens necessários

Os itens usados ficam em `shared-side/shared.lua`, em:

- `ShopItens`
- `Boxes`
- `Battlepass`
- `Daily`

Cada item precisa existir na configuração real de itens da base (`@vrp/config/Item.lua`) e nas imagens do inventário/NUI quando aplicável.

## Permissões/grupos

As permissões de VIP/propriedade ficam em:

- `Premium`
- `Propertys`

O script usa permissões reais do vRP via:

- `vRP.HasPermission`
- `vRP.SetPermission`
- `exports.crons:Insert`

## Comandos e atalhos

- `PauseBreak`: abre o menu pause customizado.
- `ActiveMap`: abre o mapa nativo.

Keybinds padrão:

- `Escape`: `PauseBreak`
- `P`: `ActiveMap`

Se o cliente já tiver bind salvo no FiveM, pode ser necessário ajustar em Configurações > Key Bindings > FiveM.

## Configurações principais

Arquivo:

```txt
shared-side/shared.lua
```

Configura:

- cupom
- redes sociais
- battlepass
- caixas
- trabalhos/experiência
- VIPs
- propriedades
- veículos da loja
- itens da loja
- daily rewards
- taxa do marketplace
- cooldown de salário

## Funcionamento passo a passo

1. O jogador aperta `ESC`.
2. O comando `PauseBreak` abre a NUI.
3. A NUI busca dados via callbacks do client.
4. O client chama o server via Tunnel.
5. O server usa vRP/oxmysql para retornar dados, comprar itens, resgatar recompensas ou salvar marketplace.

## Correções aplicadas nesta adaptação

- Callback `Propertys` agora retorna dados reais do server.
- Adicionados callbacks `PropertyBuy`, `FurnituresBuy` e `Statistics`.
- Corrigido evento de skin de arma para `skinweapon:Open`.
- Adicionado `VehicleBuy` no server usando contrato real da tabela `vehicles`.
- Adicionada criação automática das tabelas SQL usadas pelo pause.
- Corrigido bug de salário no client (`SalaryCooldown`).
- Corrigido bug de nível na compra de propriedade.
- `Statistics` não quebra se `WeaponNames` não existir.
- Daily reward aceita recompensa configurada como veículo.
- `fxmanifest.lua` limpo e organizado.

## Como testar

1. Reinicie:

```txt
restart pause
```

2. Entre no servidor.
3. Aperte `ESC`.
4. Teste:
   - abrir/fechar menu
   - mapa
   - configurações
   - home
   - ranking
   - daily
   - code
   - loja
   - marketplace

## O que deve aparecer no console

Não deve aparecer erro de:

- callback inexistente
- `VehicleBuy` nil
- tabela `codes_creative` inexistente
- tabela `codes_creative_redeemd` inexistente
- tabela `deaths_creative` inexistente
- evento `core-skins:Open` inexistente

## Erros comuns

- Se `ESC` não abrir: confira Key Bindings do FiveM para `PauseBreak`.
- Se o mapa não abrir: teste o atalho `P` e o botão de mapa dentro da NUI.
- Se loja não comprar: confira gemas do jogador e se o item/veículo existe na configuração.
- Se imagens não aparecerem: confira os nomes em `web-side/images`.
- Se código não resgatar: confira a tabela `codes_creative` e o cadastro feito pelo admin.

## Arquivos alterados/criados

- `fxmanifest.lua`
- `client-side/core.lua`
- `server-side/core.lua`
- `sql/pause.sql`
- `README.md`

## Observações finais

Esta adaptação foi feita para a base Seoul-main-v1. Teste primeiro na v1 antes de copiar para o GitHub.
