# target

## Funcao

Resource de interacao da base Creative/Seoul.

Nesta base ele funciona em modo compatibilidade quando `setr seoul:useOxTarget true` esta ativo no `server.cfg`.
Nesse modo, os exports antigos do resource `target` continuam existindo, mas as zonas/modelos sao enviados para o `ox_target`.

## Framework

- Seoul Base / vRP Creative

## Dependencias reais

- `vrp`
- `PolyZone`
- `ox_target` quando `seoul:useOxTarget` estiver `true`

## Instalacao

No `server.cfg`, manter:

```cfg
setr seoul:useOxTarget true
ensure ox_target
ensure target
```

O `ox_target` deve iniciar antes do `target`.

## Exports mantidos

- `AddCircleZone`
- `AddBoxZone`
- `AddTargetModel`
- `RemCircleZone`
- `LabelText`
- `LabelOptions`

## Ajuste aplicado

- A distancia do bridge para `ox_target` foi aumentada para evitar opcao piscando em zonas pequenas.
- `LabelText` e `LabelOptions` agora evitam recriar zona quando o texto/opcao recebido ja e o mesmo.

## Como testar

1. Reinicie `ox_target`.
2. Reinicie `target`.
3. Entre em um ponto que usa `exports.target:AddCircleZone`.
4. Segure a tecla do target configurada no `ox_target`.
5. A opcao deve aparecer sem piscar e permitir selecionar.

## Observacoes

Se `seoul:useOxTarget` for alterado para `false`, o resource volta a usar a NUI antiga do `target`.
