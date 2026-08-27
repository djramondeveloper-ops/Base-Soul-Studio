# seoul_vinewood

Adaptação do editor do letreiro de Vinewood para a Seoul Base.

## Abertura

A interface administrativa não possui comando próprio. Ela é aberta pelo AdminControl através da opção **Vinewood**.

## Segurança

- permissão validada no AdminControl;
- permissão validada novamente no `seoul_vinewood`;
- texto limitado a 8 caracteres, letras A-Z e espaços;
- cor limitada ao formato hexadecimal `#RRGGBB`;
- salvamento com cooldown server-side;
- clientes comuns só recebem o estado necessário para renderizar o letreiro.

## Créditos

Resource original: Ricky-VinewoodSign / R1CKY.
Adaptação para Seoul Base: namespace, vRP, AdminControl e segurança.
