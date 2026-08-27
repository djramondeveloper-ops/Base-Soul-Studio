# lb-phoneprop

## Função principal

Resource de mapa que transmite o modelo e o YTYP utilizados pelo LB Phone.

## Compatibilidade

Standalone. Não utiliza framework, banco, inventário, eventos, exports, permissões, itens ou NUI.

## Dependências

Não possui dependência de framework. Deve iniciar antes de `lb-phone`.

## Instalação

```cfg
ensure lb-phoneprop
ensure lb-phone
```

## Banco de dados e SQL

Não utiliza banco e não possui SQL.

## Configurações

Não possui `config.lua`, coordenadas, valores ou cooldowns.

## Arquivos

- `fxmanifest.lua`
- `stream/lbphone_props.ytyp`
- `stream/lb_phone_prop.ydr`

O manifest registra explicitamente `stream/lbphone_props.ytyp` como `DLC_ITYP_REQUEST`.

## Como testar

1. Inicie o resource antes do telefone.
2. Abra o LB Phone.
3. Confirme que o aparelho aparece na mão do personagem.
4. Verifique se não há erro de YTYP/YDR no console ou F8.

## Erros comuns

- Prop invisível: confirme a ordem de início e a presença dos dois arquivos em `stream`.
- Erro de asset: atualize o artifact do FXServer.

## Arquivos alterados

- `fxmanifest.lua`
- `README.md`
