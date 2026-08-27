# lb-tablet - Origens vRP

## Função principal

Tablet com aplicativos de polícia, hospital, dispatch, serviços, e-mail, mapas, câmera, fotos, notas, relógio e gravação de voz.

## Framework compatível

- Origens vRP/Creative.
- `Config.Framework = "vrp"`.
- Bridge própria em `server/custom/frameworks/vrp` e `client/custom/frameworks/vrp.lua`.

## Dependências reais

- `vrp`
- `oxmysql`
- `lb-phone`
- `lb-tablet-prop`
- `pma-voice` recomendado

Não depende de QBCore, Qbox, `qbx_core`, `ox_inventory`, `ps-banking` ou `pickle_prisons`.

## Instalação e ordem de início

```cfg
ensure oxmysql
ensure vrp
ensure pma-voice
ensure lb-phoneprop
ensure lb-phone
ensure lb-tablet-prop
ensure lb-tablet
```

## Item obrigatório

Adicione este item dentro da tabela de itens em `vrp/config/Item.lua`:

```lua
["lb_tablet"] = {
    ["Index"] = "lb_tablet",
    ["Name"] = "Tablet",
    ["Type"] = "Comum",
    ["Weight"] = 1.0,
    ["Execute"] = {
        ["Type"] = "Client",
        ["Event"] = "lb-tablet:openFromItem"
    }
},
```

Adicione também `lb_tablet.png` em `inventory/web-side/images`. O tablet pode ser aberto por `/tablet` ou `F5`, mas `Config.Item.Require = true` bloqueia o uso sem o item.

## Banco de dados

- `tablet.sql` contém as tabelas completas.
- O verificador interno tenta instalar as tabelas quando elas não existem.
- A tabela adicional `lbtablet_registration_licenses` é criada automaticamente pela bridge vRP.
- O faturamento usa a tabela nativa `invoices` com as colunas `Passport`, `Received`, `Reason`, `Price` e `Timestamp`.
- Veículos são consultados na tabela nativa `vehicles`.
- Números são consultados em `phone_phones` pelo identificador `vrp:<Passport>`.

Se o criador automático falhar, importe `tablet.sql` manualmente no mesmo banco da vRP.

## Grupos e permissões

- Administração: `Admin`.
- Polícia: `LSPD` e `PRPD`.
- Hospital: `Paramedic`.
- Mecânica: `Mechanic`.
- Restaurante: `BurgerShot`.

A hierarquia vRP usa nível `1` como chefe. A bridge converte esse nível para o formato crescente esperado pelas permissões do LB Tablet sem modificar os grupos da base.

## Prisão

- `Config.JailScript = "vrp"`.
- Usa `vRP.InsertPrison` e `vRP.UpdatePrison`.
- A notificação segue o contrato real da Origens.

## Comandos e teclas

- `/tablet`: abre ou fecha o tablet.
- `F5`: tecla padrão para abrir.
- `/tabletdebug`: diagnóstico client quando o debug estiver habilitado.
- `/svtabletdebug`: diagnóstico server quando o debug estiver habilitado.

## Configurações principais

- `Config.Framework = "vrp"`
- `Config.Item.Name = "lb_tablet"`
- `Config.Item.Inventory = "vrp"`
- `Config.HousingScript = false`
- `Config.JailScript = "vrp"`
- `Config.VRP.Jobs`: cargos reais da Origens.
- `Config.Services.Companies`: serviços exibidos.
- `Config.Police.Permissions` e `Config.Ambulance.Permissions`: permissões por cargo.
- `Config.KeyBinds`: teclas e comandos.

As coordenadas da base anterior foram removidas. Adicione localizações somente depois de confirmar os pontos usados na cidade Origens.

## Uploads e logs

Preencha `server/apiKeys.lua` com chaves válidas para imagem, vídeo e áudio. Os valores `API_KEY_HERE` não fazem upload. Os webhooks de log permanecem desativados por padrão.

## Funcionamento

1. O contexto vRP entrega Passport, cargo, nível, serviço e item.
2. O jogador abre o tablet pelo item, comando ou tecla.
3. Polícia e hospital recebem acesso conforme o grupo real.
4. Serviços permitem gestão, depósito e saque usando o banco vRP.
5. Multas são inseridas em `invoices`.
6. Prisões usam a sentença nativa da personagem.

## Como testar

1. Importe/verifique `tablet.sql` e cadastre `lb_tablet`.
2. Dê o item a um personagem e abra com `/tablet`.
3. Teste um LSPD e um PRPD em serviço.
4. Teste perfil, ocorrência, multa, prisão e soltura.
5. Teste um Paramedic no aplicativo hospitalar.
6. Teste depósito e saque da empresa.
7. Confirme que funcionários exibem o número do LB Phone.
8. Reinicie o resource e confirme persistência.

## Console esperado

- Tabelas do tablet verificadas.
- `lbtablet_registration_licenses` criada sem erro.
- Nenhum erro de coluna em `invoices`.
- Nenhum erro sobre `phone_phones`, `vehicles` ou `characters`.

## Erros comuns

- Tablet não abre: item ausente ou imagem não cadastrada.
- Aplicativo policial não aparece: grupo diferente de `LSPD`/`PRPD` ou jogador fora de serviço.
- Upload falha: configure `server/apiKeys.lua`.
- SQL checker gera `fix.sql`: execute o arquivo sugerido no banco.
- Números vazios: confirme que o personagem configurou o LB Phone.

## Arquivos adaptados/criados

- `config/config.lua`
- `client/custom/frameworks/vrp.lua`
- `server/custom/frameworks/vrp/*.lua`
- `server/custom/jail/vrp.lua`
- `tablet.sql`
- `README.md`

## Observação final

A validação atual é estática. O funcionamento ao vivo precisa ser confirmado com o FXServer e dois personagens de teste.
