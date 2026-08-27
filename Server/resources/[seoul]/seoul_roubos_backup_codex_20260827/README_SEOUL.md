# Seoul Roubos

Resource adaptado do pacote `Roubos` para Seoul Base.

## Módulos

- ATM: explode ATM com C4 e cria drop com dinheiro sujo/material.
- Caixa registradora: roubo com lockpick. O target do caixa usa zona local ao redor do prop para evitar o olho piscando ao mirar em objeto pequeno.
- Roubos gerais: lojas, ammunation, Fleeca, bancos, barbearias, Yellow Jack e açougue.
- Joalheria: inicia com C4 + cartão azul e usa vitrines já registradas no compat do ox_target da Seoul.
- Stockade: roubo de carro forte com cartão preto.

## Comando

```txt
/seoulroubosstatus
```

## Instalação

1. Copie o resource para:

```txt
Server/resources/[seoul]/seoul_roubos
```

2. Instale somente os itens faltantes usando:

```txt
seoul_roubos/instalacao/README_INSTALACAO.md
```

3. Coloque no `server.cfg` depois de `ox_target`, `ox_inventory` e `vrp`:

```cfg
ensure seoul_roubos
```

## Itens

O script usa itens já existentes da base: `c4`, `lockpick`, `dirtydollar`, `WEAPON_PISTOL`, `WEAPON_SNSPISTOL`, `ammo-9`, `aluminum`, `rubber`, `plastic`.

A pasta `instalacao/` contém apenas itens que não existiam na base auditada: `blackcard`, `bluecard`, `watch`, `ring`, `goldbar`.

## Observações importantes

- Pagamentos em dinheiro sujo usam `dirtydollar`, item já existente na base.
- O CD inválido `-3800000.385` foi mantido no Config original, mas o client ignora coordenadas absurdas automaticamente.
- Controle de porta da joalheria vem desligado por padrão para não abrir ID errado. Ajuste `Config.JewelryDoors` somente depois de conferir os IDs reais da tua base.
- `Config.CreateJewelryDrawerTargets` vem `false`, porque a Seoul já tem os targets das vitrines no compat do ox_target. Se remover o compat, mude para `true`.
