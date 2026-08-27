# LB Tablet — adaptação direta para vRP

Adaptação feita para a vRP enviada pelo usuário. Não usa `seoul_bridge`.

## Dependências

- `oxmysql`
- `vrp` (a resource precisa manter esse nome)
- `lb-phone`
- `lb-tablet-prop`

## Ordem no server.cfg

```cfg
ensure oxmysql
ensure vrp
ensure lb-phone
ensure lb-tablet-prop
ensure lb-tablet
```

## Banco de dados

Importe:

```text
lb-tablet/tablet.sql
```

Os dados de personagens são lidos da tabela `characters` e os veículos da tabela `vehicles` da sua vRP.

## Item do tablet

Adicione em `vrp/config/Item.lua`, dentro de `local List = {`:

```lua
["lb_tablet"] = {
    Index = "lb_tablet",
    Name = "Tablet",
    Description = "Tablet pessoal com acesso a aplicativos e serviços.",
    Type = "Consumível",
    Weight = 1.0,
    Unique = true,
    Market = true,
    Execute = {
        Type = "Client",
        Event = "lb-tablet:openFromItem"
    }
},
```

Coloque a imagem `lb_tablet.png` no diretório de imagens do inventário. O pacote inclui `lbtablet.png` e `inventoryitem.webp` como referência.

Caso não queira exigir item, altere em `config/config.lua`:

```lua
Config.Item.Require = false
```

## Grupos usados

A integração já vem configurada para:

- Polícia: `DP`
- Hospital: `Hospital`
- Mecânica: `Mecanica`
- Restaurante: `Restaurante`
- Administração: `Admin`

Ajuste em `Config.VRP.Jobs` se os nomes mudarem.

## Identificação

O tablet usa o **Passport** como identificador oficial. Perfis, tablets, multas, prisão e funcionários ficam vinculados ao Passport.

## Dinheiro e multas

- Saldo pessoal: banco nativo da vRP.
- Multas: tabela `invoices` da base.
- Empresa: saldo persistido no `entitydata` da vRP usando `LBTablet:Company:<grupo>`.

## Prisão

A opção configurada é:

```lua
Config.JailScript = "vrp"
```

O tablet utiliza `vRP.InsertPrison`, `vRP.UpdatePrison` e o campo `characters.Prison`.

## LB Phone

A integração original com `lb-phone` foi mantida. O `lb-phone` deve iniciar antes do tablet.

## Evidências

`Config.EvidenceStash` foi desativado porque o inventário desta vRP não expõe uma API genérica de stash compatível com o tablet. Pode ser integrado depois ao resource de inventário real da cidade.

## Uso

- Comando: `/tablet`
- Item: `lb_tablet`
- Os aplicativos Police e Ambulance dependem dos grupos `DP` e `Hospital`.
- Gestão de funcionários exige o primeiro nível da hierarquia por padrão (`bossGrade = 1`).

## Testes recomendados

1. Entrar com personagem sem grupo e abrir o tablet.
2. Entrar como `DP`, selecionar serviço e abrir o app policial.
3. Pesquisar um Passport e uma placa.
4. Criar multa e conferir a tabela `invoices`.
5. Prender e soltar um personagem.
6. Testar e-mail, fotos e chamadas com `lb-phone`.
7. Entrar como chefe e testar contratar, demitir e alterar cargo.

## Observações

- O script original é protegido por escrow; toda a adaptação foi feita nos arquivos customizáveis liberados.
- Data de nascimento, altura e sexo não existem claramente na estrutura fornecida da tabela `characters`; esses campos aparecem vazios no MDT até serem adicionados à base ou ligados a outra tabela.
- O stash de evidências permanece desativado.
