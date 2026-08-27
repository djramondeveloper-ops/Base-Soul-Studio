# LB Phone adaptado para vRP

Esta versão foi adaptada diretamente para a vRP fornecida, sem bridge.

## Dependências

- `oxmysql`
- `vrp` (a base fornecida)
- recurso de voz compatível configurado no LB Phone

## Ordem no server.cfg

```cfg
ensure oxmysql
ensure vrp
ensure lb-phone
```

## Banco de dados

Importe `phone.sql` caso as tabelas ainda não existam. A base já possui prepares para `phone_phones` e integração em `vrp/modules/lb-phone.lua`.

## Item

A base fornecida já possui o item `cellphone` em `vrp/config/Item.lua`. O telefone foi configurado para exigir esse item.

Configuração aplicada:

```lua
Config.Framework = "standalone"
Config.CustomFramework = true
Config.Item.Name = "cellphone"
Config.Item.Require = true
Config.Item.Unique = false
```

O modo unique foi desativado porque o inventário nativo dessa vRP não trabalha com metadata/slots no formato esperado pelo LB Phone. Cada personagem ainda mantém número e contas próprios pelo Passport.

## Identificador

O dono das contas é salvo como:

```text
vrp:<Passport>
```

Exemplo: `vrp:15`.

## Grupos e empresas

Edite `Config.VRPJobs` em `config/config.lua` para ligar os jobs do LB Phone aos grupos reais da cidade. Exemplo:

```lua
Config.VRPJobs = {
    police = { "DP" },
    ambulance = { "Hospital" },
    mechanic = { "Mecanica" }
}
```

Os nomes usados em `Config.Companies.Services[].job` precisam existir como chaves de `Config.VRPJobs`.

## Banco

- Saldo: `vRP.GetBank`
- Crédito: `vRP.GiveBank`
- Débito: `vRP.PaymentBank`
- Transferências offline: atualização segura da coluna `characters.Bank`

## Veículos

A garagem consulta a tabela `vehicles` usando `Passport`, `Vehicle`, `Plate`, `Engine`, `Body`, `Fuel` e `Arrest`.

## Comandos administrativos

Os comandos originais do LB Phone continuam disponíveis mediante ACE e/ou grupo configurado em `Config.VRPAdminGroups`.

## Teste rápido

1. Dê um `cellphone` ao personagem.
2. Entre no servidor e abra o telefone pela tecla configurada.
3. Conclua a configuração inicial e confirme que um registro foi criado em `phone_phones` com `owner_id = vrp:<Passport>`.
4. Teste mensagens e chamadas com dois jogadores.
5. Teste Wallet: saldo, transferência online e offline.
6. Teste Garage com veículo próprio.
7. Entre em serviço no grupo de uma empresa e confirme chamadas/mensagens empresariais.

## Migração da adaptação antiga

Caso já existam registros com `owner_id` começando por `pandora:`, execute após backup:

```sql
UPDATE phone_phones SET owner_id = REPLACE(owner_id, 'pandora:', 'vrp:') WHERE owner_id LIKE 'pandora:%';
```

Faça a mesma substituição em outras tabelas do telefone que tenham uma coluna de identificador/owner_id, somente se houver dados antigos.
