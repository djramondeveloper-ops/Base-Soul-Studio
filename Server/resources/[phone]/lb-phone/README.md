# lb-phone - Origens vRP

## Função principal

Telefone completo com chamadas, mensagens, contatos, câmera, redes sociais, serviços, carteira, garagem, e-mail, App Store e notificações.

## Framework compatível

- Origens vRP/Creative.
- `Config.Framework = "standalone"` ativa a bridge vRP localizada em `server/custom/frameworks/standalone`.
- O identificador interno utilizado pelo telefone é `vrp:<Passport>`.

## Dependências reais

- `vrp`
- `oxmysql`
- `lb-phoneprop`
- `pma-voice` recomendado para chamadas de voz

## Instalação e ordem de início

```cfg
ensure oxmysql
ensure vrp
ensure pma-voice
ensure lb-phoneprop
ensure lb-phone
```

O resource deve iniciar somente depois de `vrp` e `oxmysql`.

## Banco de dados

- O arquivo `phone.sql` contém a estrutura completa.
- `lib/server/autoSql.lua` tenta criar automaticamente as tabelas ausentes.
- O banco precisa possuir as tabelas nativas `characters` e `vehicles` da Origens.
- A bridge consulta `characters.id`, `characters.Bank`, `vehicles.Passport`, `vehicles.Plate` e `vehicles.Vehicle`.

## Item necessário

O telefone utiliza o item já existente na Origens:

```lua
cellphone
```

O item é validado por `vRP.ItemAmount`. Não é necessário alterar o item para abrir pelo comando ou tecla configurada.

## Grupos, permissões e serviços

- Administração: grupo vRP `Admin` ou ACE `command.lbphone_admin`.
- Polícia: `LSPD`, `PRPD` e grupo agregado `Police`.
- Hospital: `Paramedic`.
- Mecânica: `Mechanic`.
- Restaurante: `BurgerShot`.

Os serviços antigos da Seoul/Bloodlines foram removidos da configuração.

## Comandos e teclas

- `/phone`: abre ou fecha o telefone se o jogador possuir `cellphone`.
- Tecla padrão: `K`.
- `/toggleverified`, `/changepassword` e `/resetphonesecurity`: comandos administrativos do LB Phone, protegidos pela bridge.

## Configurações principais

- `Config.Framework = "standalone"`
- `Config.CustomFramework = true`
- `Config.Item.Name = "cellphone"`
- `Config.Item.Require = true`
- `Config.Item.Unique = false`
- `Config.Item.Inventory = "vrp"`
- `Config.CityName = "Origens"`
- `Config.VRPJobs`: mapeamento dos grupos reais da base.
- `Config.Companies.Services`: empresas exibidas no aplicativo Serviços.
- `Config.Valet.Price`: custo do manobrista.
- `Config.KeyBinds`: comandos e teclas.

As coordenadas antigas foram removidas dos serviços para impedir marcações incorretas no GPS. Elas podem ser adicionadas novamente em `Config.Companies.Services` quando os pontos definitivos da cidade forem definidos.

## Uploads, WebRTC e logs

- Configure `server/apiKeys.lua` com chaves próprias do servidor.
- Troque ou revogue webhooks e chaves herdados de outra cidade antes de publicar o servidor.
- `WEBRTC.TokenID` e `WEBRTC.APIToken` são necessários apenas quando a infraestrutura de chamadas de vídeo exigir TURN próprio.

## Funcionamento

1. A bridge converte o Passport em `vrp:<Passport>`.
2. O telefone confirma a existência do item `cellphone`.
3. As tabelas do LB Phone armazenam números, contas, mensagens e aplicativos.
4. Banco, serviços e veículos são consultados na vRP real.
5. Os apps externos registram-se através dos exports `AddCustomApp`, `RemoveCustomApp` e `SendCustomAppMessage`.

## Como testar

1. Entre com um personagem que possua `cellphone`.
2. Use `/phone` ou `K`.
3. Finalize a configuração inicial e confirme a criação do número.
4. Teste ligação entre dois jogadores.
5. Teste transferência bancária com saldo suficiente e insuficiente.
6. Teste Serviços com jogadores em serviço nos grupos `LSPD`, `PRPD`, `Paramedic` e `Mechanic`.
7. Teste a garagem com um veículo cadastrado na tabela `vehicles`.

## Console esperado

- Resource iniciado sem erro de dependência.
- Tabelas do telefone verificadas/criadas.
- Nenhum erro sobre `phone_phones`, `characters`, `vehicles` ou callback inexistente.

## Erros comuns

- `No such export`: confirme que `lb-phone` iniciou antes dos apps.
- `phone_phones doesn't exist`: importe `phone.sql` ou verifique o auto SQL.
- Telefone não abre: confirme o item `cellphone` e `Config.Item.Require`.
- Serviços offline: confirme grupo e entrada em serviço na vRP.
- Upload falha: substitua as chaves em `server/apiKeys.lua`.

## Arquivos adaptados

- `fxmanifest.lua`
- `config/config.lua`
- `server/custom/frameworks/standalone/*.lua`
- `server/custom/uniquePhones/vrp-inventory.lua`
- `lib/server/autoSql.lua`
- `README.md`

## Observação final

A compatibilidade foi validada estaticamente contra a vRP em `Origens-main`. A comprovação final depende de iniciar o FXServer e executar os testes acima.
