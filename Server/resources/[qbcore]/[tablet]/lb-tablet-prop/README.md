# lb-tablet-prop

## Função principal

Resource de mapa que transmite o modelo `lb_tablet_prop` utilizado pelo LB Tablet.

## Compatibilidade

Standalone. Não utiliza framework, banco, inventário, eventos, exports, permissões, itens ou NUI.

## Dependências

- Artifact do FXServer com suporte a `/assetpacks`.
- Deve iniciar antes de `lb-tablet`.

## Instalação

```cfg
ensure lb-tablet-prop
ensure lb-tablet
```

## Banco de dados e SQL

Não utiliza banco e não possui SQL.

## Configurações

Não possui `config.lua`, coordenadas, valores ou cooldowns.

## Arquivos

- `fxmanifest.lua`
- `stream/lb_tablet_prop.ytyp`
- `stream/lb_tablet_prop.ydr`

O manifest registra `stream/lb_tablet_prop.ytyp` como `DLC_ITYP_REQUEST`.

## Como testar

1. Inicie o prop antes do tablet.
2. Abra o LB Tablet.
3. Confirme que o modelo aparece corretamente na mão do personagem.
4. Verifique o console e F8.

## Erros comuns

- Erro na dependência `/assetpacks`: atualize o artifact do FXServer.
- Prop invisível: confirme a ordem de início e os arquivos da pasta `stream`.

## Arquivos alterados

- `fxmanifest.lua`
- `README.md`
