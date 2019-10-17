//--
           
***********
1) Nota Fiscal Coleta - Beneficiamento Carcaca

- Cliente envia carcacas para beneficiamento
- Fluxo Normal Durapol NFE -> OP -> PRODUCAO -> PV -> NFS
- Retorna carcaca já beneficiada para o cliente e cobra os serviços efetuados
- Gera duplicata no valor integral da nota fiscal, livros fiscais e contabilizacao
           
***********
2) Como os Creditos sao Gerados ?

- O produto chega a Durapol através de uma nota fiscal Coleta como outra qualquer, ou seja, vai abrir OP automatica

- A partir de um processo de inspeção do produto, a produção avalia o produto e identifica uma possivel causa de erro.
Este erro é classificado por um motivo, e segue para uma aprovação de desconto ou não para aquele cliente.
FORMULARIO SEPU

- Caso o laudo seja favoravel ao cliente, a Durapol vai conceder desconto comercial que deverá ser aplicado numa
próxima fatura, portanto é interessante que seja registrado uma NCC no financeiro para registrar os creditos em
aberto para este cliente

- Caso o laudo seja desfavoravel ao cliente, a Durapol apenas devolve o produto, sem conceder desconto para o cliente
 
***********
3) Como os creditos sao aplicados ?

1) Primeira Situacao : Desconto Financeiro, aplica-se a NCC a um titulo do financeiro (processo padrao) compensacao CR

2) Segunda Sitauacao : Desconto Comercial, aplica-se a NCC no momento de geracao da Nota Fiscal Fatura

- Para estes casos, o processo nasce novamente como uma coleta normal, ou seja, o cliente esta enviando novas
carcacas para beneficiamento.

- O fluxo segue normalmente para esta nova remessa NFE -> OP -> PRODUCAO -> PV -> NFS, porem os creditos já registrados
na base podem ser aplicados no momento de geração da Nota Fiscal Saida.

- Caso isto ocorra, a Nota Fiscal Saida deverá sair no valor liquido (totais, base imposto)
  - A contabilizacao deverá ser realizada pelo valor liquido
  - A geracao do Livro Fiscal Saida devera ser realizado pelo valor liquido
  - O Titulo a Receber referente a esta nota também já deve ser gerado pelo valor liquido
  - OBS: É o mesmo tratamento de um desconto comercial no Protheus, o desconto é registrado no Pedido de venda
  e a nota fiscal é gerada nos valores liquidos, armazenando item a item qual foi o valor desconto concedido
  
- Nesta situacao, a NCC que foi selecionada e aplicada a esta nota fiscal deverá ser baixada no financeiro
  ( Como baixar ??? baixa ncc, compensa ncc (com qual titulo???) )  
  

************
PROBLEMAS

1) COMO REGISTRAR A BAIXA DA NCC QDO ELA FOR APLICADA NO MOMENTO DE GERACAO DA NOTA FISCAL SAIDA E NAO NO FINANC???

2) COMO APLICAR A NCC NO(s) PEDIDO(s) DE VENDA OU ;
   - RATEIA DESCONTO NOS ITENS ??? OU ;
   - GERA ITEM NEGATIVO ???
   
3) NA NOTA FISCAL SAIDA ????
   - DEIXA PEDIDO DE VENDA ORIGINAL ???
   - CHUMBA DESCONTO NA NOTA FISCAL SAIDA DEPOIS DE GERADA ???
   - ACERTA VALORES DO LIVRO FISCAL, CONTABILIDADE E CONTAS A RECEBER ????



__________________________

CLIENTE
CNPJ
END



DUPLICATAS        070000 01/09/2005 500,00

PRODUTOS

1() DEVOLUCAO PNEUS            10,00     10,00


SERVICOS

CARCACA 1234X3455/R.25                  					1          1000,00 (C6_TOTAL+C6_VALDESC)
CI R120                                  
DESCONTO COMERCIAL VULCANIZACAO                   					   -500,00



TOTAIS                      BASE ISS 500, VLR 25,00         VL. MERCADORIA 500,00
												            VL. PRODUTOS    10,00
---------------------------------

C6_QTD     C6_PRCVEN     C6_TOTAL       C6_VALDESC
1			500,00		 500,00			500,00

1) DISCUSSAO EDMAR COM SAMUEL SOBRE MARGEM BRUTA / LIQUIDA / MARKUP / E OS KCTEA4                              					
2) QUE A MENINA APLICA O DESCONTO POR ITEMMMMM


/////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

SOLUCAO 1                          

- GRAVAR DESCONTO NO PEDIDO (RATEANDO)
- APLICAR NO MOMENTO DE GERACAO DA NOTA FISCAL




PONTO DE ENTRADA 
- LOGO APOS PEGAR NUMERO DA NOTA FISCAL (OBRIGATORIO, PRA PODER GERAR TIT.FICTICIO E BAIXA-LO CONTRA NCC)
- LOGO APOS C9 MARCADO E FILTRADO (
- ANTES DE GERAR O D2/F2 E AFINS

