#INCLUDE "MATXFIS.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   � MATXFIS  � Autor � Eduardo / Edson       � Data �08.12.1999	���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Programa de Calculo de Impostos Fiscais e Financeiros      	���
���������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            	���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   	���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                         	���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
#DEFINE NF_TIPONF		01    //Tipo : N , I , C , P
#DEFINE NF_OPERNF		02    //E-Entrada | S - Saida
#DEFINE NF_CLIFOR		03    //C-Cliente | F - Fornecedor
#DEFINE NF_TPCLIFOR 	04    //Tipo do destinatario R,F,S,X
#DEFINE NF_LINSCR		05    //Indica se o destino possui inscricao estadual
#DEFINE NF_GRPCLI		06    //Grupo de Tributacao
#DEFINE NF_UFDEST		07    //UF do Destinatario
#DEFINE NF_UFORIGEM	    08    //UF de Origem
#DEFINE NF_DESCONTO	    10    //Valor Total do Deconto
#DEFINE NF_FRETE		11    //Valor Total do Frete
#DEFINE NF_DESPESA	    12    //Valor Total das Despesas Acessorias
#DEFINE NF_SEGURO		13    //Valor Total do Seguro
#DEFINE NF_AUTONOMO 	14    //Valor Total do Frete Autonomo
#DEFINE NF_ICMS		    15    //Array contendo os valores de ICMS
#DEFINE NF_BASEICM	    15,01 //Valor da Base de ICMS
#DEFINE NF_VALICM		15,02 //Valor do ICMS Normal
#DEFINE NF_BASESOL	    15,03 //Base do ICMS Solidario
#DEFINE NF_VALSOL		15,04 //Valor do ICMS Solidario
#DEFINE NF_BICMORI	    15,05 //Base do ICMS Original
#DEFINE NF_VALCMP		15,06 //Valor do Icms Complementar
#DEFINE NF_BASEICA	    15,07 //Base do ICMS sobre o Frete Autonomo
#DEFINE NF_VALICA 	    15,08 //Valor do ICMS sobre o Frete Autonomo
#DEFINE NF_IPI  		16    //Array contendo os valores de IPI
#DEFINE NF_BASEIPI	    16,01 //Valor da Base do IPI
#DEFINE NF_VALIPI		16,02 //Valor do IPI
#DEFINE NF_BIPIORI	    16,03 //Valor da Base Original do IPI
#DEFINE NF_TOTAL		17    //Valor Total da NF
#DEFINE NF_VALMERC	    18    //Total de Mercadorias
#DEFINE NF_FUNRURAL 	19	   //Valor Total do FunRural
#DEFINE NF_CODCLIFOR	20    //Codigo do Cliente/Fornecedor
#DEFINE NF_LOJA		    21	  //Loja do Cliente/Fornecedor
#DEFINE NF_LIVRO		22    //Array contendo o Demonstrativo Fiscal
#DEFINE NF_ISS			23	  //Array contendo os Valores de ISS
#DEFINE NF_BASEISS	    23,01 //Base de Calculo do ISS
#DEFINE NF_VALISS		23,02 //Valor do ISS
#DEFINE NF_IR			24    //Array contendo os valores do Imposto de renda
#DEFINE NF_BASEIRR	    24,01 //Base do Imposto de Renda do item
#DEFINE NF_VALIRR		24,02 //Valor do IR do item
#DEFINE NF_INSS		    25    //Array contendo os valores de INSS
#DEFINE NF_BASEINS	    25,01 //Base de calculo do INSS
#DEFINE NF_VALINS		25,02 //Valor do INSS do item
#DEFINE NF_NATUREZA		26	   //Codigo da natureza a ser gravado nos titulos do Financeiro.
#DEFINE NF_VALEMB		27	   //Valor da Embalagem
#DEFINE NF_RESERV1	    28	   //Array contendo as Bases de Impostos ( Argentina,Chile,Etc.)
#DEFINE NF_RESERV2	    29	   //Array contendo os valores de Impostos ( Argentina,Chile,Etc. )
#DEFINE NF_IMPOSTOS		30	   //Array contendo todos os impostos calculados na funcao Fiscal com quebra por impostos+aliquotas
#DEFINE NF_BASEDUP		31	  	//Base de calculo das duplicatas geradas no financeiro
#DEFINE NF_RELIMP		32	  	//Array contendo a relacao de impostos que podem ser alterados
#DEFINE NF_IMPOSTOS2	33	  //Array contendo todos os impostos calculados na funcao Fiscal com quebras por impostos
#DEFINE NF_DESCZF		34	  //Valor Total do desconto da Zona Franca
#DEFINE NF_SUFRAMA	    35	  // Indica se o Cliente pertence a SUFRAMA
#DEFINE NF_BASEIMP	    36	  //Array contendo as Bases de Impostos Variaveis
#DEFINE NF_BASEIV1	    36,01 //Base de Impostos Variaveis 1
#DEFINE NF_BASEIV2	    36,02 //Base de Impostos Variaveis 2
#DEFINE NF_BASEIV3	    36,03 //Base de Impostos Variaveis 3
#DEFINE NF_BASEIV4	    36,04 //Base de Impostos Variaveis 4
#DEFINE NF_BASEIV5	    36,05 //Base de Impostos Variaveis 5
#DEFINE NF_BASEIV6	    36,06 //Base de Impostos Variaveis 6
#DEFINE NF_BASEIV7	    36,07 //Base de Impostos Variaveis 7
#DEFINE NF_BASEIV8	    36,08 //Base de Impostos Variaveis 8
#DEFINE NF_BASEIV9	    36,09 //Base de Impostos Variaveis 9
#DEFINE NF_VALIMP		37 	  //Array contendo os valores de Impostos Agentina/Chile/Etc.
#DEFINE NF_VALIV1		37,01 //Valor do Imposto Variavel 1
#DEFINE NF_VALIV2		37,02 //Valor do Imposto Variavel 2
#DEFINE NF_VALIV3		37,03 //Valor do Imposto Variavel 3
#DEFINE NF_VALIV4		37,04 //Valor do Imposto Variavel 4
#DEFINE NF_VALIV5		37,05 //Valor do Imposto Variavel 5
#DEFINE NF_VALIV6		37,06 //Valor do Imposto Variavel 6
#DEFINE NF_VALIV7		37,07 //Valor do Imposto Variavel 7
#DEFINE NF_VALIV8		37,08 //Valor do Imposto Variavel 8
#DEFINE NF_VALIV9		37,09 //Valor do Imposto Variavel 96
#DEFINE NF_TPCOMP		38    //Tipo de complemento  - F Frete , D Despesa Imp.
#DEFINE NF_INSIMP		39	  //Flag de Controle : Indica se podera inserir Impostos no Rodape.
#DEFINE NF_PESO  		40	  //Peso Total das mercadorias da NF
#DEFINE NF_ICMFRETE 	41	  //Valor do ICMS relativo ao frete
#DEFINE NF_BSFRETE 		42	  //Base do ICMS relativo ao frete
#DEFINE NF_BASECOF 		43	  //Base de calculo do COFINS
#DEFINE NF_VALCOF  		44	  //Valor do COFINS
#DEFINE NF_BASECSL 		45	  //Base de calculo do CSLL
#DEFINE NF_VALCSL 		46	  //Valor do CSLL
#DEFINE NF_BASEPIS 		47	  //Base de calculo do PIS
#DEFINE NF_VALPIS 		48	  //Valor do PIS
#DEFINE NF_ROTINA 		49	  //Nome da rotina que esta utilizando a funcao
#DEFINE NF_AUXACUM 		50	  //Campo auxiliar para acumulacao no calculo de impostos
#DEFINE NF_ALIQIR      51    //Aliquota de IRF do Cliente
#DEFINE NF_VNAGREG     52	  //Valor da Mercadoria nao agregada.
#DEFINE NF_RECPIS      53    //Recolhe PIS
#DEFINE NF_RECCOFI     54    //Recolhe CONFINS
#DEFINE NF_RECCSLL     55    //Recolhe CSLL
#DEFINE NF_RECISS      56    //Recolhe ISS
#DEFINE NF_RECINSS     57    //Recolhe INSS
#DEFINE NF_MOEDA       58    //Moeda da nota
#DEFINE NF_TXMOEDA     59    //Taxa da moeda
#DEFINE NF_SERIENF     60    //Serie da nota fiscal
#DEFINE NF_TIPODOC     61    //Tipo do documento (localizacoes)
#DEFINE NF_MINIMP      62    //Minimo para calcular Impostos Variaveis
#DEFINE NF_MINIV1      62,01 //Minimo para calcular Imposto Variavel 1
#DEFINE NF_MINIV2      62,02 //Minimo para calcular Imposto Variavel 2
#DEFINE NF_MINIV3      62,03 //Minimo para calcular Imposto Variavel 3
#DEFINE NF_MINIV4      62,04 //Minimo para calcular Imposto Variavel 4
#DEFINE NF_MINIV5      62,05 //Minimo para calcular Imposto Variavel 5
#DEFINE NF_MINIV6      62,06 //Minimo para calcular Imposto Variavel 6
#DEFINE NF_MINIV7      62,07 //Minimo para calcular Imposto Variavel 7
#DEFINE NF_MINIV8      62,08 //Minimo para calcular Imposto Variavel 8
#DEFINE NF_MINIV9      62,09 //Minimo para calcular Imposto Variavel 9
#DEFINE NF_BASEPS2     63	  //Base de calculo do PIS 2
#DEFINE NF_VALPS2      64	  //Valor do PIS 2
#DEFINE NF_ESPECIE     65	  //Especie do Documento
#DEFINE NF_CNPJ        66    //CNPJ/CPF
#DEFINE NF_BASECF2     67	  //Base de calculo do COFINS 2
#DEFINE NF_VALCF2      68	  //Valor do COFINS 2
#DEFINE NF_ICMSDIF     69    //Valor do ICMS diferido
#DEFINE NF_MODIRF      70    //Calculo do IRPF
#DEFINE NF_PNF_COD     71,01 //Codigo do pagador do documento fiscal
#DEFINE NF_PNF_LOJ     71,02 //Loja   do pagador do documento fiscal
#DEFINE NF_PNF_UF      71,03 //UF do pagador do documento fiscal
#DEFINE NF_CALCSUF	    72	  // Indica se cliente possui calculo suframa
#DEFINE NF_BASEAFRMM   73	  //Base de calculo do AFRMM ( Cabecalho )
#DEFINE NF_VALAFRMM    74	  //Valor do AFRMM ( Cabecalho )

#DEFINE IT_GRPTRIB  	01    //Grupo de Tributacao
#DEFINE IT_EXCECAO  	02    //Array da EXCECAO Fiscal
#DEFINE IT_ALIQICM	    03    //Aliquota de ICMS
#DEFINE IT_ICMS 		04    //Array contendo os valores de ICMS
#DEFINE IT_BASEICM  	04,01 //Valor da Base de ICMS
#DEFINE IT_VALICM		04,02 //Valor do ICMS Normal
#DEFINE IT_BASESOL	    04,03 //Base do ICMS Solidario
#DEFINE IT_ALIQSOL	    04,04 //Aliquota do ICMS Solidario
#DEFINE IT_VALSOL		04,05 //Valor do ICMS Solidario
#DEFINE IT_MARGEM		04,06 //Margem de lucro para calculo da Base do ICMS Sol.
#DEFINE IT_BICMORI	    04,07 //Valor original da Base de ICMS
#DEFINE IT_ALIQCMP	    04,08 //Aliquota para calculo do ICMS Complementar
#DEFINE IT_VALCMP		04,09 //Valor do ICMS Complementar do item
#DEFINE IT_BASEICA 	    04,10 //Base do ICMS sobre o frete autonomo
#DEFINE IT_VALICA  	    04,11 //Valor do ICMS sobre o frete autonomo
#DEFINE IT_DEDICM      04,12 //Valor do ICMS a ser deduzido
#DEFINE IT_ALIQIPI  	05    //Aliquota de IPI
#DEFINE IT_IPI  		06    //Array contendo os valores de IPI
#DEFINE IT_BASEIPI  	06,01 //Valor da Base do IPI
#DEFINE IT_VALIPI		06,02 //Valor do IPI
#DEFINE IT_BIPIORI	    06,03 //Valor da Base Original do IPI
#DEFINE IT_NFORI		07    //Numero da NF Original
#DEFINE IT_SERORI		08    //Serie da NF Original
#DEFINE IT_RECORI		09    //RecNo da NF Original (SD1/SD2)
#DEFINE IT_DESCONTO	    10    //Valor do Desconto
#DEFINE IT_FRETE		11    //Valor do Frete
#DEFINE IT_DESPESA	    12    //Valor das Despesas Acessorias
#DEFINE IT_SEGURO		13    //Valor do Seguro
#DEFINE IT_AUTONOMO 	14    //Valor do Frete Autonomo
#DEFINE IT_VALMERC	    15    //Valor da mercadoria
#DEFINE IT_PRODUTO	    16    //Codigo do Produto
#DEFINE IT_TES			17    //Codigo da TES
#DEFINE IT_TOTAL		18    //Valor Total do Item
#DEFINE IT_CF			19    //Codigo Fiscal de Operacao
#DEFINE IT_FUNRURAL	    20    //Aliquota para calculo do Funrural
#DEFINE IT_PERFUN		21    //Valor do Funrural do item
#DEFINE IT_DELETED	    22    //Flag de controle para itens deletados
#DEFINE IT_LIVRO		23    //Array contendo o Demonstrativo Fiscal do Item
#DEFINE IT_ISS			24    //Array contendo os valores de ISS
#DEFINE IT_ALIQISS	    24,01 //Aliquota de ISS do item
#DEFINE IT_BASEISS  	24,02 //Base de Calculo do ISS
#DEFINE IT_VALISS		24,03 //Valor do ISS do item
#DEFINE IT_CODISS		24,04 //Codigo do ISS
#DEFINE IT_CALCISS	    24,05 //Flag de controle para calculo do ISS
#DEFINE IT_RATEIOISS	24,06 //Flag de controle para calculo do ISS
#DEFINE IT_IR			25    //Array contendo os valores do Imposto de renda
#DEFINE IT_BASEIRR	    25,01 //Base do Imposto de Renda do item
#DEFINE IT_REDIR		25,02 //Percentual de Reducao da Base de calculo do IR
#DEFINE IT_ALIQIRR	    25,03 //Aliquota de Calculo do IR do Item
#DEFINE IT_VALIRR		25,04 //Valor do IR do Item
#DEFINE IT_INSS		    26    //Array contendo os valores de INSS
#DEFINE IT_BASEINS	    26,01 //Base de calculo do INSS
#DEFINE IT_REDINSS	    26,02 //Percentual de Reducao da Base de Calculo do INSS
#DEFINE IT_ALIQINS	    26,03 //Aliquota de Calculo do INSS
#DEFINE IT_VALINS		26,04 //Valor do INSS
#DEFINE IT_VALEMB		27	  //Valor da embalagem
#DEFINE IT_BASEIMP	    28	  //Array contendo as Bases de Impostos Variaveis
#DEFINE IT_BASEIV1	    28,01 //Base de Impostos Variaveis 1
#DEFINE IT_BASEIV2	    28,02 //Base de Impostos Variaveis 2
#DEFINE IT_BASEIV3	    28,03 //Base de Impostos Variaveis 3
#DEFINE IT_BASEIV4	    28,04 //Base de Impostos Variaveis 4
#DEFINE IT_BASEIV5	    28,05 //Base de Impostos Variaveis 5
#DEFINE IT_BASEIV6	    28,06 //Base de Impostos Variaveis 6
#DEFINE IT_BASEIV7	    28,07 //Base de Impostos Variaveis 7
#DEFINE IT_BASEIV8	    28,08 //Base de Impostos Variaveis 8
#DEFINE IT_BASEIV9	    28,09 //Base de Impostos Variaveis 9
#DEFINE IT_ALIQIMP	    29	  //Array contendo as Aliquotas de Impostos Variaveis
#DEFINE IT_ALIQIV1	    29,01 //Aliquota de Impostos Variaveis 1
#DEFINE IT_ALIQIV2	    29,02 //Aliquota de Impostos Variaveis 2
#DEFINE IT_ALIQIV3	    29,03 //Aliquota de Impostos Variaveis 3
#DEFINE IT_ALIQIV4	    29,04 //Aliquota de Impostos Variaveis 4
#DEFINE IT_ALIQIV5	    29,05 //Aliquota de Impostos Variaveis 5
#DEFINE IT_ALIQIV6	    29,06 //Aliquota de Impostos Variaveis 6
#DEFINE IT_ALIQIV7	    29,07 //Aliquota de Impostos Variaveis 7
#DEFINE IT_ALIQIV8	    29,08 //Aliquota de Impostos Variaveis 8
#DEFINE IT_ALIQIV9	    29,09 //Aliquota de Impostos Variaveis 9
#DEFINE IT_VALIMP		30    //Array contendo os valores de Impostos Agentina/Chile/Etc.
#DEFINE IT_VALIV1		30,01 //Valor do Imposto Variavel 1
#DEFINE IT_VALIV2		30,02 //Valor do Imposto Variavel 2
#DEFINE IT_VALIV3		30,03 //Valor do Imposto Variavel 3
#DEFINE IT_VALIV4		30,04 //Valor do Imposto Variavel 4
#DEFINE IT_VALIV5		30,05 //Valor do Imposto Variavel 5
#DEFINE IT_VALIV6		30,06 //Valor do Imposto Variavel 6
#DEFINE IT_VALIV7		30,07 //Valor do Imposto Variavel 7
#DEFINE IT_VALIV8		30,08 //Valor do Imposto Variavel 8
#DEFINE IT_VALIV9		30,09 //Valor do Imposto Variavel 9
#DEFINE IT_BASEDUP		31	  //Base das duplicatas geradas no financeiro
#DEFINE IT_DESCZF		32	  //Valor do desconto da Zona Franca do item
#DEFINE IT_DESCIV		33	  //Array contendo a descricao dos Impostos Variaveis
#DEFINE IT_DESCIV1		33,1  //Array contendo a Descricao dos IV 1
#DEFINE IT_DESCIV2		33,2  //Array contendo a Descricao dos IV 2
#DEFINE IT_DESCIV3		33,3  //Array contendo a Descricao dos IV 3
#DEFINE IT_DESCIV4		33,4  //Array contendo a Descricao dos IV 4
#DEFINE IT_DESCIV5		33,5  //Array contendo a Descricao dos IV 5
#DEFINE IT_DESCIV6		33,6  //Array contendo a Descricao dos IV 6
#DEFINE IT_DESCIV7		33,7  //Array contendo a Descricao dos IV 7
#DEFINE IT_DESCIV8		33,8  //Array contendo a Descricao dos IV 8
#DEFINE IT_DESCIV9		33,9  //Array contendo a Descricao dos IV 9
#DEFINE IT_QUANT		34	  //Quantidade do Item
#DEFINE IT_PRCUNI		35	  //Preco Unitario do Item
#DEFINE IT_VIPIBICM 	36	  //Valor do IPI Incidente na Base de ICMS
#DEFINE IT_PESO     	37	  //Peso da mercadoria do item
#DEFINE IT_ICMFRETE 	38	  //Valor do ICMS Relativo ao Frete
#DEFINE IT_BSFRETE  	39	  //Base do ICMS Relativo ao Frete
#DEFINE IT_BASECOF  	40	  //Base de calculo do COFINS
#DEFINE IT_ALIQCOF  	41	  //Aliquota de calculo do COFINS
#DEFINE IT_VALCOF   	42	  //Valor do COFINS
#DEFINE IT_BASECSL  	43    //Base de calculo do CSLL
#DEFINE IT_ALIQCSL  	44    //Aliquota de calculo do CSLL
#DEFINE IT_VALCSL   	45	  //Valor do CSLL
#DEFINE IT_BASEPIS  	46	  //Base de calculo do PIS
#DEFINE IT_ALIQPIS  	47	  //Aliquota de calculo do PIS
#DEFINE IT_VALPIS   	48	  //Valor do PIS
#DEFINE IT_RECNOSB1 	49	  //RecNo do SB1
#DEFINE IT_RECNOSF4 	50	  //RecNo do SF4
#DEFINE IT_VNAGREG     51	  //Valor da Mercadoria nao agregada.
#DEFINE IT_TIPONF      52    //Tipo da nota fiscal
#DEFINE IT_REMITO      53    //Remito
#DEFINE IT_BASEPS2     54	  //Base de calculo do PIS 2
#DEFINE IT_ALIQPS2     55	  //Aliquota de calculo do PIS 2
#DEFINE IT_VALPS2      56	  //Valor do PIS 2
#DEFINE IT_BASECF2     57	  //Base de calculo do COFINS 2
#DEFINE IT_ALIQCF2     58	  //Aliquota de calculo do COFINS 2
#DEFINE IT_VALCF2      59	  //Valor do COFINS 2
#DEFINE IT_ABVLINSS    60   //Abatimento da base do INSS em valor 
#DEFINE IT_ABVLISS     61   //Abatimento da base do ISS em valor 
#DEFINE IT_REDISS      62   //Percentual de reducao de base do ISS ( opcional, utilizar normalmente TS_BASEISS ) 
#DEFINE IT_ICMSDIF     63   //Valor do ICMS diferido
#DEFINE IT_DESCZFPIS   64   //Desconto do PIS
#DEFINE IT_DESCZFCOF   65   //Desconto do Cofins
#DEFINE IT_BASEAFRMM   66	  //Base de calculo do AFRMM ( Item )
#DEFINE IT_ALIQAFRMM   67	  //Aliquota de calculo do AFRMM ( Item )
#DEFINE IT_VALAFRMM    68	  //Valor do AFRMM ( Item )

#DEFINE LF_CFO			01	  // Codigo Fiscal
#DEFINE LF_ALIQICMS 	02	  // Aliquota de ICMS
#DEFINE LF_VALCONT		03	  // Valor Contabil
#DEFINE LF_BASEICM		04	  // Base de ICMS
#DEFINE LF_VALICM		05	  // Valor do ICMS
#DEFINE LF_ISENICM		06	  // ICMS Isento
#DEFINE LF_OUTRICM		07	  // ICMS Outros
#DEFINE LF_BASEIPI		08	  // Base de IPI
#DEFINE LF_VALIPI		09	  // IPI Tributado
#DEFINE LF_ISENIPI		10	  // IPI Isento
#DEFINE LF_OUTRIPI		11	  // IPI Outros
#DEFINE LF_OBSERV		12	  // Observacao
#DEFINE LF_VALOBSE		13 	  // Valor na Observacao
#DEFINE LF_ICMSRET		14	  // Valor ICMS Retido
#DEFINE LF_LANCAM		15	  // Numero do Lancamento
#DEFINE LF_TIPO		    16	  // Tipo de Lancamento
#DEFINE LF_ICMSCOMP 	17 	  // ICMS Complementar
#DEFINE LF_CODISS		18	  // Cod.Serv. ISS
#DEFINE LF_IPIOBS		19	  // IPI na Observacao
#DEFINE LF_NFLIVRO		20	  // Numero do Livro
#DEFINE LF_ICMAUTO		21	  // ICMS Frete Autonomo
#DEFINE LF_BASERET		22	  // Base do ICMS Retido
#DEFINE LF_FORMUL		23	  // Flag de Fom. Proprio
#DEFINE LF_FORMULA		24	  // Formula
#DEFINE LF_DESPESA		25	  // Despesas Acessorias
#DEFINE LF_ICMSDIF		26	  // Icms Diferido
#DEFINE LF_TRFICM	    27	  // Transferencia de Debito e Credito
#DEFINE LF_OBSICM	    28	  // Icms na coluna de observacoes
#DEFINE LF_OBSSOL	    29	  // Solidario na coluna de observacoes
#DEFINE LF_SOLTRIB	    30	  // Valor do ICMS Solidario que possui tributacao com credito de imposto
#DEFINE LF_CFOEXT		31	  // Codigo Fiscal Extendido
#DEFINE LF_ISSST		32	  // Codigo Fiscal Extendido 
#DEFINE LF_RECISS		33	  // Codigo Fiscal Extendido 
#DEFINE LF_ISSSUB       34    // ISS de Sub-empreitada.
#DEFINE LF_ISS_ALIQICMS 35,01 // Aliquota de ICMS
#DEFINE LF_ISS_ISENICM	 35,02 // ICMS Isento
#DEFINE LF_ISS_OUTRICM	 35,03 // ICMS Outros
#DEFINE LF_ISS_ISENIPI	 35,04 // IPI Isento
#DEFINE LF_ISS_OUTRIPI	 35,05 // IPI Outros
#DEFINE LF_CREDST       36    // Credito / Debito Substitui��o tribut�ria.
#DEFINE LF_CRDEST       37    // Credito Estimulo de Manaus
#DEFINE LF_CRDPRES      38    // Credito Presumido - RJ
#DEFINE LF_SIMPLES      39    // Valor do ICMS para clientes optantes pelo Simples - SC
#DEFINE LF_CRDTRAN      40    // Credito Presumido - RJ - Prestacoes de Servicos de Transporte
#DEFINE LF_CRDZFM       41    // Credito Presumido - Zona Franca de Manaus

//���������������������������������������������������������Ŀ
//� Controle do Tipo de Entrada e Saida                     �
//�����������������������������������������������������������
#DEFINE TS_CODIGO      01    //Codigo da TES
#DEFINE TS_TIPO        02    //Tipo da TES - S Saida , E Entrada
#DEFINE TS_ICM         03    //Calcula ICMS , S-Sim,N-Nao
#DEFINE TS_IPI         04    //Calcula IPI , S-Sim,N-Nao,R-Comerciante nao Atac.
#DEFINE TS_CREDICM     05    //Credito de ICMS , S-Sim,N-Nao
#DEFINE TS_CREDIPI     06    //Credito de IPI  , S-Sim,N-Nao
#DEFINE TS_DUPLIC      07    //Gera Duplicata , S-Sim,N-Nao
#DEFINE TS_ESTOQUE     08    //Movimenta Estoque , S-Sim,N-Nao
#DEFINE TS_CF          09    //Codigo Fiscal de Operacao
#DEFINE TS_TEXTO       10    //Descricao do TES
#DEFINE TS_BASEICM     11    //Reducao da Base de ICMS
#DEFINE TS_BASEIPI     12    //Reducao da Base de IPI
#DEFINE TS_PODER3      13    //Controla Poder de 3os R-Remessa,D-Devolucao,N-Nao Controla
#DEFINE TS_LFICM       14    //Coluna Livros Fiscais ICM - T-Tributado,I-Isentas,O-Outras,N-Nao,Z-ICMS Zerado
#DEFINE TS_LFIPI       15    //Coluna Livros Fiscais IPI - T-Tributado,I-Isentas,O-Outras,N-Nao,Z-IPI Zerado
#DEFINE TS_DESTACA     16    //Destaca IPI S-Sim,N-Nao
#DEFINE TS_INCIDE      17    //Incide IPI na Base de ICMS , S-Sim,N-Nao
#DEFINE TS_COMPL       18    //Calcula ICMS Complementar , S-Sim,N-NAo
#DEFINE TS_IPIFRET     19    //Calcula IPI sobre Frete S-Sim,N-Nao
#DEFINE TS_ISS         20    //Calcula ISS S-Sim,N-Nao
#DEFINE TS_LFISS       21    //Coluna Livros Fiscais ISS - T=Tributado;I=Isento;O=Outros;N=Nao calcula
#DEFINE TS_NRLIVRO     22    //Numero do Livro
#DEFINE TS_UPRC        23    //Atualiza Ultimo Preco de Compra S-Sim,N-Nao
#DEFINE TS_CONSUMO     24    //Material de Consumo S-Sim,N-Nao
#DEFINE TS_FORMULA     25    //Formula para uso na impressao dos Livros Fiscais
#DEFINE TS_AGREG       26    //Agrega Valor a Mercadoria S-Sim N-Nao
#DEFINE TS_INCSOL      27    //Agrega Valor do ICMS Sol. S-Sim,N-Nao
#DEFINE TS_CIAP        28    //Livro Fiscal CIAP S-Sim,N-Nao
#DEFINE TS_DESPIPI     29    //Calcula IPI sobre Despesas S-Sim,N-Nao
#DEFINE TS_LIVRO       30    //Formula para livro Fiscal
#DEFINE TS_ATUTEC      31    //Atualiza SigaTec S-Sim,N-Nao
#DEFINE TS_ATUATF      32    //Atualiza Ativo Fixo S-Sim,N-Nao
#DEFINE TS_TPIPI       33    //Base do IPI B - Valor Bruto , L - Valor Liquido
#DEFINE TS_SFC         34    //Array contendo os Itens do SFC
#DEFINE TS_LIVRO       35    //Nome do Rdmake de complemento/geracao dos livors Fiscais
#DEFINE TS_STDESC      36    //Define se considera o Desconto no calculo do ICMS Retido.
#DEFINE TS_DESPICM     37    //Define se as Despesas entram na base de Calculo de ICMS
#DEFINE TS_BSICMST     38    //% de Reduco da Base de Calculo do ICMS Solidario
#DEFINE TS_BASEISS     39    //% de Reduco da Base de Calculo do ISS.
#DEFINE TS_IPILICM     40    //O ipi deve ser lancado nas colunas nao tributadas do ICMS
#DEFINE TS_ICMSDIF     41    //ICMS Diferido
#DEFINE TS_QTDZERO     42    //Tes permite digitar quantidade zero.
#DEFINE TS_TRFICM      43    //Tes permite digitar quantidade zero.
#DEFINE TS_OBSICM      44    //Icms na coluna de observacao
#DEFINE TS_OBSSOL      45    //Icms Solidario na coluna de observacao
#DEFINE TS_PICMDIF     46    //Percentual do ICMS Diferido
#DEFINE TS_PISCRED     47    //Credita/Debita PIS/COFIS
#DEFINE TS_PISCOF      48    //Calcula PIS/COFIS
#DEFINE TS_CREDST      49    //Credita Solidario
#DEFINE TS_BASEPIS     50    //Percentual de Reducao do PIS
#DEFINE TS_ICMSST      51    //Indica se o ICMS deve ser somado ao ICMS ST.
#DEFINE TS_FRETAUT     52    //Indica se o Frete Automo deve ser calculo sobre o ICMS ou ICMS-ST
#DEFINE TS_MKPCMP      53    //Indica se o ICMS complementar deve considerar a Margem de Lucro do solidario
#DEFINE TS_CFEXT       54    //Codigo Fiscal de Operacao extendido
#DEFINE TS_BASECOF     55    //Percentual de Reducao do PIS
#DEFINE TS_ISSST       56
#DEFINE TS_MKPSOL      57    //Informa a condi��o da Margem de Lucro no calculo do ICMS Solidario 
#DEFINE TS_AGRPIS      58    //Informa se agrega o valor do PIS ao total da nota 
#DEFINE TS_AGRCOF      59    //Informa se agrega o valor do COFINS ao total da nota 
#DEFINE TS_AGRRETC     60    //Informa se agrega o valor do ICMS Retido na Coluna Outras/Isenta
#DEFINE TS_PISBRUT     61    //Informa a condi��o da Margem de Lucro no calculo do ICMS Solidario 
#DEFINE TS_COFBRUT     62    //Informa se agrega o valor do PIS ao total da nota 
#DEFINE TS_COFDSZF     63    //Informa se agrega o valor do COFINS ao total da nota 
#DEFINE TS_PISDSZF     64    //Informa se agrega o valor do ICMS Retido na Coluna Outras/Isenta
#DEFINE TS_LFICMST     65    //Informa como ser� a escritura��o do ICMS-ST.
#DEFINE TS_DESPRDIC    66    //Informa se as despesas acess�rias devem ser reduzidas juntamente com a base de calculo do ICMS.
#DEFINE TS_CRDEST      67    //Informa se efetua o calculo do Credito Estimulo de Manaus (1 = Nao Calcula, 2 = Produtos Eletronicos, 3 = Contrucao Civil)
#DEFINE TS_CRDPRES     68    //Percentual do Credito Presumido - RJ
#DEFINE TS_AFRMM       69    //Calcula AFRMM: S-Sim,N-Nao
#DEFINE TS_CRDTRAN     70    //Percentual para calculo do Credito Presumido - RJ - Prestacoes de Serv.de Transporte

#DEFINE MAX_TS         70    //Tamanho do array de TES

#DEFINE SFC_SEQ        01    //Sequencia de calculo do Imposto
#DEFINE SFC_IMPOSTO    02    //Codigo do imposto
#DEFINE SFC_INCDUPL    03    //Indica se incide nas Duplicatas
#DEFINE SFC_INCNOTA    04    //Indica se incide no total da NF
#DEFINE SFC_CREDITA    05    //Indica de Credita o Imposto
#DEFINE SFC_INCIMP     06    //Indica se incide na Base de Calculo de Outro imposto
#DEFINE SFC_BASE       07    // %Reducao da base de calculo
#DEFINE SFB_DESCR      08    //Descricao do Imposto
#DEFINE SFB_CPOVREI    09    //Campo do Valor de Entrada Item
#DEFINE SFB_CPOBAEI    10    //Campo da Base de Entrada do Item
#DEFINE SFB_CPOVREC    11    //Campo do Valor de Entrada Cabecalho
#DEFINE SFB_CPOBAEC    12    //Campo da Base de Entrada Cabecalho
#DEFINE SFB_CPOVRSI    13    //Campo do Valor de Saida Item
#DEFINE SFB_CPOBASI    14    //Campo da Base de Saida Item
#DEFINE SFB_CPOVRSC    15    //Campo do Valor de Saida Cabecalho
#DEFINE SFB_CPOBASC    16    //Campo da Base de Saida Cabecalho
#DEFINE SFB_FORMENT    17    //Rotina para calculo do imposto na Entrada
#DEFINE SFB_FORMSAI    18    //Rotina para calculo do imposto na Saida
#DEFINE SFC_CALCULO    19    //Tipo de calculo

#DEFINE IMP_COD		    01    //Codigo do imposto no Array NF_IMPOSTOS
#DEFINE IMP_DESC		02    //Descricao do imposto no Array NF_IMPOSTOS
#DEFINE IMP_BASE		03    //Base de Calculo do Imposto no Array NF_IMPOSTOS
#DEFINE IMP_ALIQ		04    //Aliquota de calculo do imposto
#DEFINE IMP_VAL		    05    //Valor do Imposto no Array NF_IMPOSTOS
#DEFINE IMP_NOME		06    //Nome de referencia aos Impostos do cabecalho

#DEFINE NMAXIV	        36    // Numero maximo de Impostos Variaveis

STATIC aMaster
STATIC aNFCab
STATIC aNFItem
STATIC aItemDec
STATIC bFisRefresh
STATIC bLivroRefresh
STATIC aBrwLF
STATIC aStack
STATIC aRefSX3
STATIC aSaveDec
STATIC aAuxOri
STATIC cAliasPROD := "SB1"

STATIC aTES[MAX_TS]
STATIC aItemRef
STATIC aCabRef
STATIC aResRef
STATIC aLFIS

STATIC MV_ALIQISS
STATIC MV_ESTADO
STATIC MV_ICMPAD
STATIC MV_NORTE
STATIC MV_ESTICM
STATIC MV_IPIBRUT
STATIC MV_SOLBRUT
STATIC MV_DSZFSOL
STATIC MV_BASERET
STATIC MV_GERIMPV
STATIC MV_FRETEST
STATIC MV_CONTSOC
STATIC MV_RATDESP

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisIni  � Autor �Eduardo/Edson          � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inicializa o Calculo das operacoes Fiscais                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 : Codigo do Cliente / Fornecedor                     ���
���          � ExpC2 : Loja do Cliente / Fornecedor                       ���
���          � ExpC3 : "C" / Cliente , "F" / Fornecedor                   ���
���          � ExpC4 : Tipo da NF ( "N","D","B","C","P","I" )             ���
���          � ExpC5 : Tipo do Cliente / Fornecedor                       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���31/03/05  �Andrea Farias  �BOPS 77373 -Inicializar a funcao fiscal para���
���          �               �a entidade Prospect.                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisIni(cCodCliFor,;	// 1-Codigo Cliente/Fornecedor
	cLoja,;		// 2-Loja do Cliente/Fornecedor
	cCliFor,;	// 3-C:Cliente , F:Fornecedor
	cTipoNF,;	// 4-Tipo da NF
	cTpCliFor,;	// 5-Tipo do Cliente/Fornecedor
	aRelImp,;	// 6-Relacao de Impostos que suportados no arquivo
	cTpComp,;	// 7-Tipo de complemento
	lInsere,;	// 8-Permite Incluir Impostos no Rodape .T./.F.
	cAliasP,;	// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	cRotina,;	// 10-Nome da rotina que esta utilizando a funcao
	cTipoDoc,;	// 11-Tipo de documento
	cEspecie,;  // 12-Especie do documento 
    cCodProsp,; // 13-Codigo e Loja do Prospect 
    cGrpCliFor) // 14-Grupo Cliente

Local aArea    := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSA2 := SA2->(GetArea())
Local cOperNf  := ""
Local cUfDest  := ""
Local cUfOrig  := ""
Local cNatureza:= ""
Local cRecPIS  := "N"
Local cRecCOFI := "N"
Local cRecCSLL := "N"
Local cRecISS  := "2"
Local cRecINSS := "N"
Local cCNPJ    := ""
Local lInclui  := .T.
Local lInscrito:= .F.
Local lSuframa := .F.
Local cCalcSuf := ""
Local nAliqIRF := 0
Local cSerie   := ''
Local nMoeda   := 1
Local nTxMoeda := 0
Local cModIRF  := ""

DEFAULT aRelImp := {}
DEFAULT cTpComp := ""
DEFAULT lInsere := .F.
DEFAULT cAliasP := "SB1"
DEFAULT cTipoDoc:= ""
DEFAULT cEspecie:= ""
DEFAULT	cCodProsp:= ""	//Codigo e Loja do Prospect
DEFAULT cGrpCliFor:= CriaVar("A1_GRPTRIB",.F.)

cTpCliFor		 := IIf(cTpCliFor==Nil," ",cTpCliFor)

If MaFisFound("NF")
	lInclui 	:= .F.
	cCodCliFor	:= aNfCab[NF_CODCLIFOR]
	cLoja		:= aNfCab[NF_LOJA]
	cCliFor		:= aNfCab[NF_CLIFOR]
	cTipoNF		:= aNfCab[NF_TIPONF]
	cTpCliFor	:= aNfCab[NF_TPCLIFOR]
	aRelImp		:= aNfCab[NF_RELIMP]
	cNatureza	:= aNfCab[NF_NATUREZA]
	cTpComp		:= aNfCab[NF_TPCOMP]
	lInsere		:= aNfCab[NF_INSIMP]
	cRotina		:= aNfCab[NF_ROTINA]
	nAliqIRF    := aNfCab[NF_ALIQIR]
	cSerie		:= aNfCab[NF_SERIENF]
	cTipoDoc	:= aNfCab[NF_TIPODOC]
	nMoeda 		:= aNfCab[NF_MOEDA]
	nTxMoeda	:= aNfCab[NF_TXMOEDA]
	cEspecie	:= aNfCab[NF_ESPECIE]
	cCNPJ       := aNfCab[NF_CNPJ]
EndIf

If lInclui
	aNFCab	:= {}
	aNFItem	:= {}
	aItemDec:= {}
	MV_ALIQISS := SuperGetMV("MV_ALIQISS")
	MV_ESTADO  := SuperGetMV("MV_ESTADO")
	MV_ICMPAD  := SuperGetMV("MV_ICMPAD")
	MV_NORTE   := SuperGetMV("MV_NORTE")
	MV_ESTICM  := SuperGetMV("MV_ESTICM")
	MV_IPIBRUT := SuperGetMV("MV_IPIBRUT")
	MV_SOLBRUT := SuperGetMV("MV_SOLBRUT")
	MV_DSZFSOL := SuperGetMV("MV_DSZFSOL")
	MV_BASERET := SuperGetMV("MV_BASERET")
	MV_GERIMPV := SuperGetMV("MV_GERIMPV")
	MV_FRETEST := SuperGetMV("MV_FRETEST")
	MV_CONTSOC := SuperGetMV("MV_CONTSOC")
	MV_RATDESP := SuperGetMV("MV_RATDESP")
	cAliasPROD := cAliasP
EndIf

//�������������������������������������������������������������Ŀ
//� Posiciona os registros necessarios                          �
//���������������������������������������������������������������
If ( cCliFor == "C" )
	
	If Empty(cCodProsp)
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+cCodCliFor+cLoja)
		cOperNf   := IIf(cTipoNf$"DB","E","S")
		lInscrito := IIf(Empty(SA1->A1_INSCR).Or."ISENT"$SA1->A1_INSCR.Or."RG"$SA1->A1_INSCR,.T.,.F.)
		lSuframa  := !Empty(SA1->A1_SUFRAMA).And.SA1->A1_CALCSUF<>'N'
		cCalcSuf  := SA1->A1_CALCSUF
		If Empty(cGrpCliFor)
			cGrpCliFor:= SA1->A1_GRPTRIB
		EndIf
		cUfDest   := IIf(cTipoNf$"DB",MV_ESTADO,SA1->A1_EST)
		cUfOrig   := IIf(cTipoNf$"DB",SA1->A1_EST,MV_ESTADO)
		cCNPJ     := SA1->A1_CGC
	
		If lInclui
			cNatureza := SA1->A1_NATUREZ
			cTpCliFor := IIf(Empty(cTpCliFor),SA1->A1_TIPO,cTpCliFor)
		Else
			cTpCliFor := SA1->A1_TIPO
		EndIf
		nAliqIRF    := SA1->A1_ALIQIR
		cRecPIS  := SA1->A1_RECPIS
		cRecCOFI := SA1->A1_RECCOFI
		cRecCSLL := SA1->A1_RECCSLL
		cRecISS  := SA1->A1_RECISS
		cRecINSS := SA1->A1_RECINSS
		cModIRF  := IIf(GetNewPar("MV_IRMP232","2")=="2","1","2")
	Else

		//������������������������������������������������Ŀ
		//�Inicializa as variaveis para a entidade prospect�
		//��������������������������������������������������
		DbSelectArea("SUS") 
		DbSetOrder(1)
		MsSeek(xFilial("SUS")+cCodProsp)
		cOperNf   := IIf(cTipoNf$"DB","E","S")
		
		If SUS->(FieldPos("US_INSCR")) > 0 
			lInscrito := IIf(Empty(SUS->US_INSCR) .OR. "ISENT" $ SUS->US_INSCR .OR. "RG" $ SUS->US_INSCR,.T.,.F.)
		Endif	            
		
		If SUS->(FieldPos("US_SUFRAMA")) > 0 .AND. SUS->(FieldPos("US_CALCSUF")) > 0
			lSuframa  := !Empty(SUS->US_SUFRAMA) .AND. SUS->US_CALCSUF<>'N' 
			cCalcSuf  := SUS->US_CALCSUF
		Endif
				
		If SUS->(FieldPos("US_GRPTRIB")) > 0 .And. Empty(cGrpCliFor)
			cGrpCliFor:= SUS->US_GRPTRIB
	    Endif
	    
		cUfDest   := IIf(cTipoNf$"DB",MV_ESTADO,SUS->US_EST)
		cUfOrig   := IIf(cTipoNf$"DB",SUS->US_EST,MV_ESTADO)
		cCNPJ     := SUS->US_CGC
	
		If lInclui
			If SUS->(FieldPos("US_NATUREZ")) > 0 
				cNatureza := SUS->US_NATUREZ
			Endif
			cTpCliFor := IIf(Empty(cTpCliFor),SUS->US_TIPO,cTpCliFor)
		Else
			cTpCliFor := SUS->US_TIPO
		EndIf
	
		nAliqIRF := IIf(SUS->(FieldPos("US_ALIQIR"))	> 0,SUS->US_ALIQIR	,0)
		cRecPIS  := IIf(SUS->(FieldPos("US_RECPIS"))	> 0,SUS->US_RECPIS	,"N")
		cRecCOFI := IIf(SUS->(FieldPos("US_RECCOFI")) 	> 0,SUS->US_RECCOFI	,"N")
		cRecCSLL := IIf(SUS->(FieldPos("US_RECCSLL")) 	> 0,SUS->US_RECCSLL	,"N")
		cRecISS  := IIf(SUS->(FieldPos("US_RECISS")) 	> 0,SUS->US_RECISS	,"2")
		cRecINSS := IIf(SUS->(FieldPos("US_RECINSS"))	> 0,SUS->US_RECINSS	,"N")
		cModIRF  := IIf(GetNewPar("MV_IRMP232","2")=="2","1","2")
	EndIf
	
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+cCodCliFor+cLoja)
	cOperNf   := IIf(cTipoNf$"DB","S","E")
	If Empty(cGrpCliFor)
		cGrpCliFor:= SA2->A2_GRPTRIB
	EndIf
	lInscrito := IIf(Empty(SM0->M0_INSC).Or."ISENT"$SM0->M0_INSC,.T.,.F.)
	cUfDest   := IIf(cTipoNf$"DB",SA2->A2_EST,MV_ESTADO)
	cUfOrig   := IIf(cTipoNf$"DB",MV_ESTADO,SA2->A2_EST)
	cCNPJ     := SA2->A2_CGC

	If lInclui
		cNatureza := &(SuperGetMV("MV_2DUPNAT"))
		If Empty( cTpCliFor )
			//�������������������������������������������������������������Ŀ
			//� Converte os tipos do fornecedor para os tipos validos       �
			//���������������������������������������������������������������
			cTpCliFor := MaFisTpCon( SA2->A2_TIPO )
		EndIf
	Else
		cTpCliFor := MaFisTpCon( SA2->A2_TIPO )
	EndIf
	If cPaisLoc== "BRA"
		cRecISS  := IIf(SA2->A2_RECISS<>"S","2","1")
		cRecINSS := SA2->A2_RECINSS
		cRecPIS  := IIf(SA2->A2_RECPIS<>"2","N","S")
		cRecCOFI := IIf(SA2->A2_RECCOFI<>"2","N","S")
		cRecCSLL := IIf(SA2->A2_RECCSLL<>"2","N","S")
		cModIRF  := IIf(SA2->(FieldPos("A2_CALCIRF")<>0),SA2->A2_CALCIRF,"1")
	EndIf
EndIf

If lInclui
	aNfCab := {	cTipoNF,;		//1
		cOperNF,;		//2
		cCliFor,;		//3
		cTpCliFor,;		//4
		lInscrito,;		//5
		cGrpCliFor,;	//6
		cUFdest,;       //7
		cUfOrig,;		//8
		0,;				//9
		0,;				//10
		0,;				//11
		0,;				//12
		0,;				//13
		0,;				//14
		{0,0,0,0,0,0,0,0,0},;	//15
		{0,0,0},;		//16
		0,;				//17
		0,;				//18
		0,;				//19
		cCodCliFor,;	//20
		cLoja,;			//21
		{},;			//22
		{0,0},;		    //23
		{0,0},;		    //24
		{0,0},;		    //25
		cNatureza,;		//26
		0,;				//27
		{},;			//28
		{},;			//29
		{{'...','  ',0,0,0,'NEW'}},;	//30
		0,;				//31
		aRelImp,;		//32
		{{'...','  ',0,0,'NEW'}},;//33
		0,;				//34
		lSuframa,;		//35
		Array(NMAXIV),;	//36
		Array(NMAXIV),;	//37
		cTpComp,;		//38
		lInsere,;		//39
		0,;				//40
		0,;				//41
		0,;				//42
		0,;				//43
		0,;				//44
		0,;				//45
		0,;				//46
		0,;				//47
		0,;				//48
		cRotina,;       //49
		0,;				//50
		nAliqIRF,;		//51
		0,;   			//52
		cRecPIS,;		//53
		cRecCOFI,;		//54
		cRecCSLL,;		//55
		cRecISS,;		//56
		cRecINSS,;		//57
		nMoeda,;		//58
		nTxMoeda,;		//59
		cSerie,;		//60
		cTipoDoc,;		//61
		Array(NMAXIV),;	//62
		0,;				//63
		0,;				//64
		cEspecie,;      //65
		cCNPJ,;         //66
		0,;             //67
		0,;             //68
		0,;             //69
		cModIRF,;       //70
		{"","",""},;	//71
		cCalcSuf,;	    //72
		0,;				//73 - Base de Calculo do AFRMM - NF
		0}				//74 - Valor do AFRMM - NF
		
Else
	aNfCab	:= {	cTipoNF,;		//1
		cOperNF,;		//2
		cCliFor,;		//3
		cTpCliFor,;		//4
		lInscrito,;		//5
		cGrpCliFor,;	//6
		cUFdest,;	    //7
		cUfOrig,;		//8
		0,;				//9
		0,;				//10
		0,;				//11
		0,;				//12
		0,;				//13
		0,;				//14
		{0,0,0,0,0,0,0,0,0},;		//15
		{0,0,0},;		//16
		0,;	 			//17
		0,;				//18
		0,;				//19
		cCodCliFor,;	//20
		cLoja,;			//21
		{},;			//22
		{0,0},;			//23
		{0,0},;			//24
		{0,0},;	  		//25
		cNatureza,;		//26
		0,;				//27
		{},;			//28
		{},;			//29
		{{"","",0,0,0,""}},;	//30
		0,;				//31
		aRelImp,;		//32
		{{"","",0,0,""}},;	 //33
		0,;				//34
		lSuframa,;		//35
		Array(NMAXIV),;//36
		Array(NMAXIV),; //37
		cTpComp,;		//38
		lInsere,;		//39
		0,;				//40
		0,;				//41
		0,;				//42
		0,;				//43
		0,;				//44
		0,;				//45
		0,;				//46
		0,;				//47
		0,;				//48
		cRotina,;       //49
		0,;				//50
		nAliqIRF,;    	//51
		0,;   			//52
		cRecPIS,;		//53
		cRecCOFI,;		//54
		cRecCSLL,;		//55
		cRecISS,;		//56
		cRecINSS,;		//57
		nMoeda,;		//58
		nTxMoeda,;		//59
		cSerie,;		//60
		cTipoDoc,;		//61
		Array(NMAXIV),;	//62
		0,;				//63
		0,;				//64
		cEspecie,;      //65
		cCNPJ,;         //66
		0,;             //67
		0,;             //68
		0,;             //69
		cModIRF,;       //70
		{"","",""},;	//71
		cCalcSuf,;	    //72
		0,;				//73
		0}				//74

EndIf

//������������������������������������������������������������Ŀ
//� Inicializa arrays de impostos variaveis                    �
//��������������������������������������������������������������
aNfCab[NF_BASEIMP]:=Afill(aNfCab[NF_BASEIMP],0)
aNfCab[NF_VALIMP]:=Afill(aNfCab[NF_VALIMP],0)
aNfCab[NF_MINIMP]:=Afill(aNfCab[NF_MINIMP],0)
//������������������������������������������������������������Ŀ
//� Cria o array de Referencias                                �
//��������������������������������������������������������������
If aItemRef == Nil
	MaIniRef()
EndIf
//������������������������������������������������������������Ŀ
//� Cria o array de arredondamentos do item                    �
//��������������������������������������������������������������
If aSaveDec == Nil
	aSaveDec := Array(Len(aItemRef))
	aFill(aSaveDec,0)
EndIf
If aAuxOri == Nil
	aAuxOri := {}
EndIf

RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aArea)

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisAdd  � Autor � Edson Maricate        � Data �09.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inicializa o Calculo das operacoes Fiscais por item         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array contendo o calculo de impostos do item                ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisAdd(cProduto,;   	// 1-Codigo do Produto ( Obrigatorio )
	cTes,;	   	// 2-Codigo do TES ( Opcional )
	nQtd,;	   	// 3-Quantidade ( Obrigatorio )
	nPrcUnit,;   	// 4-Preco Unitario ( Obrigatorio )
	nDesconto,;  	// 5-Valor do Desconto ( Opcional )
	cNFOri,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
	cSEROri,;		// 7-Serie da NF Original ( Devolucao/Benef )
	nRecOri,;		// 8-RecNo da NF Original no arq SD1/SD2
	nFrete,;		// 9-Valor do Frete do Item ( Opcional )
	nDespesa,;	// 10-Valor da Despesa do item ( Opcional )
	nSeguro,;		// 11-Valor do Seguro do item ( Opcional )
	nFretAut,;	// 12-Valor do Frete Autonomo ( Opcional )
	nValMerc,;	// 13-Valor da Mercadoria ( Obrigatorio )
	nValEmb,;		// 14-Valor da Embalagem ( Opiconal )
	nRecSB1,;		// 15-RecNo do SB1
	nRecSF4)		// 16-RecNo do SF4

Local aArea    := GetArea()
Local nItem

DEFAULT nRecSB1 := 0
DEFAULT nRecSF4 := 0
//�������������������������������������������������������������Ŀ
//� Posiciona os registros necessarios                          �
//���������������������������������������������������������������
dbSelectArea(cAliasPROD)
If nRecSB1 <> 0 .And. cAliasPROD=="SB1"
	MsGoto(nRecSB1)
Else
	dbSetOrder(1)
	MsSeek(xFilial(cAliasPROD)+cProduto)
EndIf
//��������������������������������������������������������Ŀ
//� Inicializa a TES utilizada no calculo de impostos      �
//����������������������������������������������������������
MaFisTes(@cTes,nRecSF4)

aadd(aNfItem,{MaSBCampo("GRTRIB"),;			//1 - Grupo de Tributacao
	{},;										//2 - Array contendo as excessoes Fiscais
	0,;											//3 - Aliquota de ICMS
	{0,0,0,0,0,0,0,0,0,0,0,0},;				//4 - Valores de ICMS
	0,;											//5 - Aliquota de IPI
	{0,0,0},;									//6 - Valores de IPI
	cNFOri,;          							//7 - Numero da NF Original
	cSEROri,;									//8 - Serie da NF Original
	nRecOri,;									//9 - RecNo da NF original
	nDesconto,;									//10 - Valor do desconto do item
	nFrete,;									//11 - Valor do Frete
	nDespesa,;									//12 - Valor da despesa
	nSeguro,;									//13 - Valor do seguro
	nFretAut,;									//14 - Valor do frete autonomo
	nValMerc,; 									//15 - Valor da Mercadoria
	cProduto ,;									//16 - Codigo do produto
	cTes	,;									//17 - Codigo da TES
	0 ,;										//18 - Valor Total do item
	"",;										//19 - Codigo FIscal de Operacao
	0 ,;										//20 - Valor do Funrural
	0 ,;                     					//21 - Aliquota para calculo do FunRural
	.F.,;										//22 - Flag de controle para itens deletados
	MaFisRetLF() ,;	         					//23 - Array Contendo o demonstrativo fiscal
	{0,0,0,"","",""},;		             		//24 - Array contendo os valores de ISS
	{0,0,0,0},;							     	//25 - Array contendo os valores de IR
	{0,0,0,0},;								    //26 - Array contendo os valores de INSS
	0,; 										//27 - Valor da Embalagem
	Array(NMAXIV),;								//28
	Array(NMAXIV),;								//29
	Array(NMAXIV),;								//30
	0,;											//31
	0,;											//32
	Array(NMAXIV),;								//33
	nQtd ,;										//34
	nPrcUnit,;									//35
	0,;											//36
	0,;											//37
	0,;											//38
	0,;											//39
	0,;											//40
	0,;											//41
	0,;											//42
	0,;			  			  					//43
	0,;			  								//44
	0,;			  								//45
	0,;											//46
	0,;											//47
	0,;											//48
	nRecSB1,;									//49
	nRecSF4,;									//50
	0,; 										//51
	aNfCab[NF_TIPONF],;						    //52
	"",;										//53
	0,;											//54
	0,;											//55
	0,;											//56
	0,;											//57
	0,;											//58
    0,;                                         //59
	0,;     		                            //60
    0,;             		                    //61   
    0,;                     		            //62   
    0,;                             		    //63   
    0,;      		                            //64
    0,;             		                    //65
    0,;											//66 - Base AFRMM - Item
    0,;											//67 - Aliquota AFRMM - Item
    0})											//68 - Valor AFRMM - Item

aadd(aItemDec,{Nil,Nil})
aItemDec[Len(aItemDec)][1] := Array(Len(aItemRef))
aItemDec[Len(aItemDec)][2] := Array(Len(aItemRef))
aFill(aItemDec[Len(aItemDec)][1],0)
aFill(aItemDec[Len(aItemDec)][2],0)

nItem 	:= Len(aNfItem)
//������������������������������������������������������������Ŀ
//� Inicializa arrays de impostos variaveis                    �
//��������������������������������������������������������������
aNfItem[nItem][IT_BASEIMP]:=Afill(aNfItem[nItem][IT_BASEIMP],0)
aNfItem[nItem][IT_ALIQIMP]:=Afill(aNfItem[nItem][IT_ALIQIMP],0)
aNfItem[nItem][IT_VALIMP]:=Afill(aNfItem[nItem][IT_VALIMP],0)
aNfItem[nItem][IT_DESCIV]:=Afill(aNfItem[nItem][IT_DESCIV],{"","",""})

MaFisRecal("",nItem)
MaIt2Cab()

RestArea(aArea)
Return(nItem)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisAlt  � Autor � Edson Maricate        � Data �09.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Altera os valores de impostos e bases do item.              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisAlt(cCampo,nValor,nItem,lNoCabec,nItemNao)

Local aArea    := GetArea()
Local aRef     := {}
Local cPosCpo  := ""
Local nPos     := 0
Local nValAnt  := 0

DEFAULT lNoCabec := .F.
DEFAULT nItemNao := 0

If nValor <> Nil
	Do Case
	Case Substr(cCampo,1,2) == "IT"	
		If MaFisFound("IT",nItem)
			If MaFisRet(nItem,cCampo) <> nValor
				If !lNocabec
					MaFisSomaIt(nItem,.F.,cCampo)
				EndIf
				cPosCpo	:= MaFisScan(cCampo)
				//�������������������������������������������������������������Ŀ
				//� Tratamento para os itens.                                   �
				//���������������������������������������������������������������
				If ValType(cPosCpo) == "A"
					aNfItem[nItem][cPosCpo[1]][cPosCpo[2]] := nValor
				Else
					aNfItem[nItem][Val(cPosCpo)] := nValor
				EndIf
				//�������������������������������������������������������������Ŀ
				//� Tratamento especifico e diferenciado para cada campo.       �
				//���������������������������������������������������������������
				MaFisRecal(cCampo,nItem)
				If !lNoCabec
					MaFisSomaIt(nItem)
					If bFisRefresh <> Nil
						Eval(bFisRefresh)
					EndIf
					If bLivroRefresh <> Nil
						Eval(bLivroRefresh)
					EndIf
				EndIf
			EndIf
		EndIf
	Case Substr(cCampo,1,2) == "NF"
		If MaFisFound("NF")
			If MaFisRet(,cCampo) <> nValor
				cPosCpo	:= MaFisScan(cCampo)
				//�������������������������������������������������������������Ŀ
				//� Tratamento para o cabecalho.                                �
				//���������������������������������������������������������������
				If ValType(cPosCpo) == "A"
					nValAnt	:= aNfCab[cPosCpo[1]][cPosCpo[2]]
					aNfCab[cPosCpo[1]][cPosCpo[2]] := nValor
				Else
					nValAnt	:= aNfCab[Val(cPosCpo)]
					aNfCab[Val(cPosCpo)] := nValor
				EndIf
				//�������������������������������������������������������������Ŀ
				//� Tratamento especifico e diferenciado para cada campo.       �
				//���������������������������������������������������������������
				Do Case
				Case AllTrim(cCampo)$"NF_CODCLIFOR/NF_LOJA/NF_TIPONF/NF_OPERNF/NF_CLIFOR/NF_NATUREZA/NF_PNF_COD/NF_PNF_LOJ"
	
					//�������������������������������������������������������������������������Ŀ
					//� Reinicia os valores de arredondamento dos impostos contidos no aSaveDec.�
					//���������������������������������������������������������������������������
					If AllTrim(cCampo)$"NF_NATUREZA"
						aRef := {"IT_VALISS","IT_VALIRR","IT_VALINS","IT_VALCOF","IT_VALCSL","IT_VALPIS","IT_VALPS2","IT_VALCF2"}
						For nPos := 1 to Len(aItemRef)
							If !Empty(aScan(aRef,aItemRef[nPos,1]))
								aSaveDec[nPos] := 0
							EndIF
						Next nPos
					Else
						aSaveDec := Nil			
					EndIf
	
					MaFisIni()
					For nItem := 1 To Len(aNfItem)
						MaFisRecal(cCampo,nItem)
					Next nItem
					If !lNoCabec
						MaIt2Cab()
					EndIf
				Case AllTrim(cCampo)$"NF_UFDEST/NF_UFORIGEM/NF_SUFRAMA/NF_AUXACUM/NF_RECISS"+Iif(cPaisLoc <> "BRA","/NF_SERIENF","")
					For nItem := 1 To Len(aNfItem)
						MaFisRecal(cCampo,nItem)
						If !lNoCabec .And. cPaisLoc <> "BRA"
							MaFisSomaIt(nItem)
							If bFisRefresh <> Nil
								Eval(bFisRefresh)
							EndIf
							If bLivroRefresh <> Nil
								Eval(bLivroRefresh)
							EndIf
						EndIf
					Next nItem
	
					If !lNoCabec
						MaIt2Cab()
					EndIf
				OtherWise
					If (nValAnt <> nValor .And. ValType(nValor) == "N" ) .And. !(AllTrim(cCampo)$"NF_MOEDA/NF_TXMOEDA/") .And. !'NF_MINIV'$AllTrim(cCampo) .And.!'NF_MINIMP'$AllTrim(cCampo)
						MaRateio("IT"+Substr(cCampo,3,Len(cCampo)-2),nValAnt,nValor)
						For nItem := 1 To Len(aNfItem)
							MaFisRecal("IT"+Substr(cCampo,3,Len(cCampo)-2),nItem)
						Next nItem
						If !lNoCabec
							MaIt2Cab()
						EndIf
					EndIf
				EndCase
			EndIf
		EndIf
	Case Substr(cCampo,1,3) == "IMP"
		If cCampo == "IMP_VALRUR"
			cCampo := "IMP_FUNRURAL"
			MaFisRatRes("IT_FUNRURAL",nValor,aNfCab[NF_IMPOSTOS][nItem][IMP_ALIQ],"IT_PERFUN","",nItemNao)
		Else
			MaFisRatRes("IT"+Substr(cCampo,4,Len(cCampo)-3),nValor,aNfCab[NF_IMPOSTOS][nItem][IMP_ALIQ],'IT_ALIQ'+aNfCab[NF_IMPOSTOS][nItem][IMP_NOME],'IT_BASE'+aNfCab[NF_IMPOSTOS][nItem][IMP_NOME],nItemNao)
		EndIf
		For nItem := 1 to Len(aNfItem)
			If nItem <> nItemNao
				MaFisRecal("IT"+Substr(cCampo,4,Len(cCampo)-3),nItem)
			Endif			
		Next nItem
		If !lNoCabec
			MaIt2Cab(nItemNao)
		EndIf
	EndCase 
EndIF
RestArea(aArea)
Return .T.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisLoad � Autor � Edson Maricate        � Data �09.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Carrega os valores de impostos de bases e item.             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Codigo da referencia                                 ���
���          �ExpN2: Valor a ser atualizado na referencia                 ���
���          �ExpN3: Item a ser considerado                          (OPC)���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisLoad(cCampo,nValor,nItem)

Local aArea    := GetArea()
Local cPosCpo  := MaFisScan(cCampo)

If nValor <> Nil
	//�������������������������������������������������������������Ŀ
	//� Altera o valor do campo no Array aNfCab ou aNfItem          �
	//���������������������������������������������������������������
	If Substr(cCampo,1,2) == "IT"
		//�������������������������������������������������������������Ŀ
		//� Tratamento para os itens.                                   �
		//���������������������������������������������������������������
		If ValType(cPosCpo) == "A"
			aNfItem[nItem][cPosCpo[1]][cPosCpo[2]] := nValor
		Else
			aNfItem[nItem][Val(cPosCpo)] := nValor
		EndIf
	Else
		//�������������������������������������������������������������Ŀ
		//� Tratamento para o cabecalho.                                �
		//���������������������������������������������������������������
		If ValType(cPosCpo) == "A"
			aNfCab[cPosCpo[1]][cPosCpo[2]] := nValor
		Else
			aNfCab[Val(cPosCpo)] := nValor
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisWrite� Autor � Edson Maricate        � Data �10.01.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica arredondamentos para iniciar a gravacao.           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisWrite(nOpc,cArea,nItem,lImpostos)


Local aAcDif 	:= Array(Len(aItemRef))
Local aNotasOri := {}
Local nX                 
Local nY       := 0 
Local nLf      := 0 
DEFAULT lImpostos := .F.
aFill(aAcDif,0)
Do Case
	//�������������������������������������������������������������Ŀ
	//� Efetua a gravacao dos campos de impostos.                   �
	//���������������������������������������������������������������
Case nOpc == 2
	For nX := 1 to Len(aNfCab[NF_RELIMP])
		If aNfCab[NF_RELIMP][nX][1] == cArea
			If !lImpostos .Or.	Substr(aNfCab[NF_RELIMP][nX][1],4,6) == "BASIMP" .Or.;
					Substr(aNfCab[NF_RELIMP][nX][1],4,6) == "ALQIMP" .Or.;
					Substr(aNfCab[NF_RELIMP][nX][1],4,6) == "VALIMP"
				dbSelectArea(cArea)
				FieldPut(FieldPos(aNfCab[NF_RELIMP][nX][2]),MaFisRet(nItem,aNfCab[NF_RELIMP][nX][3]))
			Endif	
		EndIf
	Next
	//�������������������������������������������������������������Ŀ
	//� Inicia a gravacao e fetua a correcao dos arredondamentos.   �
	//���������������������������������������������������������������
OtherWise
	aNfCab[NF_LIVRO]	:= {}
	For nX := 1 to Len(aNfItem)
		If !aNfItem[nX][IT_DELETED]
			For nY := 1 to Len(aItemRef)
				If aItemRef[nY][4]
					If ValType(aItemRef[nY][2]) == "A"
						nAcDif := aAcDif[nY]
						nValor := aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]]
						If nValor > 0
							aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] := MyNoRound(nValor,2,@nAcDif,10)
							aAcDif[nY] := nAcDif
							If MyNoRound(aAcDif[nY],2) >= 0.01
								aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] += 0.01
								aAcDif[nY] -= 0.01
							EndIf
						EndIf
					Else
						nAcDif := aAcDif[nY]
						nValor := aNfItem[nX][Val(aItemRef[nY][2])]
						If nValor > 0
							aNfItem[nX][Val(aItemRef[nY][2])] := MyNoRound(nValor,2,@nAcDif,10)
							aAcDif[nY] := nAcDif
							If MyNoRound(aAcDif[nY],2) >= 0.01
								aNfItem[nX][Val(aItemRef[nY][2])] += 0.01
								aAcDif[nY] -= 0.01
							EndIf
						EndIf
					EndIf
				EndIf
			Next
			MaFisLFToLivro(nX,@aNotasOri)
		EndIf
	Next
	For nX := 1 To Len(aCabRef)
		If ValType(aCabRef[nX,2]) <> "A"
			nY := Val(aCabRef[nX,2])
			If ValType(aNfCab[nY]) == "N" .And. aCabRef[nX][3]
				aNfCab[nY] := MyNoRound(aNfCab[nY]+0.000000001,2,,10)								
			EndIf
		EndIf
	Next
	If cPaisLoc=="BRA"
		For nLf := 1 to Len(aNfCab[NF_LIVRO])
			For nY	:= 1 to Len(aNfCab[NF_LIVRO][nLf])
				If !AllTrim(StrZero(nY,2))$"01#02#12#15#16#18#20#23#24#31#32#33#35#36"
					aNfCab[NF_LIVRO][nLF][nY] := aNfCab[NF_LIVRO][nLF][nY]
				EndIf
			Next
		Next
	Endif
EndCase

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaExcecao � Autor �Eduardo/Edson          � Data �09.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo das Excecoes fiscais                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array da EXCECAO Fiscal                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaExcecao(nItem)

Local aArea	   := GetArea()
Local aAreaSF7 := SF7->(GetArea())
Local aExcecao := {}
Local cGRTrib  := ""
Local nScan    := 0

// Estrutura do Array aExcecao
// [01] - Aliq. de ICMS Interna
// [02] - Aliq. de ICMS Externa
// [03] - Margem de Lucro Presumida
// [04] - Grupo de Tributacao
// [05] - "S"
// [06] - Aliq. de ICMS Destino
// [07] - Refere-se ao ISS "S/N"
// [08] - Valor do Solidario de Pauta
// [09] - Valor do IPI de Pauta
// [10] - Valor do PIS
// [11] - Valor Cofins
// [12] - Aliquota do PIS
// [13] - Aliquota do Cofins                           
// [14] - Reducao da base de calculo do ICMS 
// [15] - Reducao da base de calculo do IPI 

If Empty( cGrTrib := MaFisRet( nItem, "IT_GRPTRIB" ) ) 
	cGrTrib := MaSBCampo("GRTRIB") 
EndIf 	

If ( !Empty(cGRTrib) )
	nScan := aScan(aNfItem,{|x| !Empty(x[IT_EXCECAO]) .And. x[IT_EXCECAO,4]==cGRTrib })
	If ( nScan == 0 )
		dbSelectArea("SF7")
		dbSetOrder(1)
		MsSeek(xFilial()+cGRTrib+aNFCab[NF_GRPCLI])

		While ( !Eof() .And.SF7->F7_FILIAL == xFilial("SF7") .And.;
				SF7->F7_GRTRIB == cGRTrib .And. ;
				SF7->F7_GRPCLI == aNFCab[NF_GRPCLI] )

			If aNFCab[NF_TIPONF] == "D" .And.;
					( aNFCab[NF_UFORIGEM] == SF7->F7_EST .Or. SF7->F7_EST == "**") .AND. ;
					(aNfCab[NF_TPCLIFOR] == SF7->F7_TIPOCLI .Or. SF7->F7_TIPOCLI == "*")
				aadd(aExcecao,SF7->F7_ALIQINT)
				aadd(aExcecao,SF7->F7_ALIQEXT)
				aadd(aExcecao,SF7->F7_MARGEM)
				aadd(aExcecao,SF7->F7_GRTRIB)
				aadd(aExcecao,"S")
				aadd(aExcecao,SF7->F7_ALIQDST)
				aadd(aExcecao,SF7->F7_ISS)
				If cPaisLoc == "BRA"
					aadd(aExcecao,SF7->F7_VLR_ICM)
					aadd(aExcecao,SF7->F7_VLR_IPI)
					aadd(aExcecao,IIf(SF7->(FieldPos("F7_VLR_PIS"))<>0,SF7->F7_VLR_PIS,0))
					aadd(aExcecao,IIf(SF7->(FieldPos("F7_VLR_COF"))<>0,SF7->F7_VLR_COF,0))				
					aadd(aExcecao,IIf(SF7->(FieldPos("F7_ALIQPIS"))<>0,SF7->F7_ALIQPIS,0))
					aadd(aExcecao,IIf(SF7->(FieldPos("F7_ALIQCOF"))<>0,SF7->F7_ALIQCOF,0))				
					aadd(aExcecao,IIf(SF7->(FieldPos("F7_BASEICM"))<>0,SF7->F7_BASEICM,0))
					aadd(aExcecao,IIf(SF7->(FieldPos("F7_BASEIPI"))<>0,SF7->F7_BASEIPI,0))
				Else
					aadd(aExcecao,0)
					aadd(aExcecao,0)
					aadd(aExcecao,0)
					aadd(aExcecao,0)
					aadd(aExcecao,0)
					aadd(aExcecao,0)
					aadd(aExcecao,0)
					aadd(aExcecao,0)
				EndIf
			Else
				If ( aNFCab[NF_UFDEST] == SF7->F7_EST .Or. SF7->F7_EST == "**") .AND. ;
						(aNfCab[NF_TPCLIFOR] == SF7->F7_TIPOCLI .Or. SF7->F7_TIPOCLI == "*")
					aadd(aExcecao,SF7->F7_ALIQINT)
					aadd(aExcecao,SF7->F7_ALIQEXT)
					aadd(aExcecao,SF7->F7_MARGEM)
					aadd(aExcecao,SF7->F7_GRTRIB)
					aadd(aExcecao,"S")
					aadd(aExcecao,SF7->F7_ALIQDST)
					aadd(aExcecao,SF7->F7_ISS)
					If cPaisLoc == "BRA"
						aadd(aExcecao,SF7->F7_VLR_ICM)
						aadd(aExcecao,SF7->F7_VLR_IPI)
						aadd(aExcecao,IIf(SF7->(FieldPos("F7_VLR_PIS"))<>0,SF7->F7_VLR_PIS,0))
						aadd(aExcecao,IIf(SF7->(FieldPos("F7_VLR_COF"))<>0,SF7->F7_VLR_COF,0))				
						aadd(aExcecao,IIf(SF7->(FieldPos("F7_ALIQPIS"))<>0,SF7->F7_ALIQPIS,0))
						aadd(aExcecao,IIf(SF7->(FieldPos("F7_ALIQCOF"))<>0,SF7->F7_ALIQCOF,0))				
						aadd(aExcecao,IIf(SF7->(FieldPos("F7_BASEICM"))<>0,SF7->F7_BASEICM,0))
						aadd(aExcecao,IIf(SF7->(FieldPos("F7_BASEIPI"))<>0,SF7->F7_BASEIPI,0))
					Else
						aadd(aExcecao,0)
						aadd(aExcecao,0)
						aadd(aExcecao,0)
						aadd(aExcecao,0)
						aadd(aExcecao,0)
						aadd(aExcecao,0)
						aadd(aExcecao,0)
						aadd(aExcecao,0)
					EndIf
					Exit
				EndIf
			EndIf
			dbSelectArea("SF7")
			dbSkip()
		EndDo
	Else
		aExcecao := aNfItem[nScan][IT_EXCECAO]
	EndIf
EndIf

aNfItem[nItem][IT_EXCECAO] := aExcecao

RestArea(aAreaSF7)
RestArea(aArea)
Return(aExcecao)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaFisTes � Autor �  Edson Maricate       � Data �03.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inicializa o codigo da TES utilizada no item.              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 : Codigo do TES                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisTes(cTes,nRecSF4,nItemTes)

Local aArea		:= {}
Local aAreaSFC	:= {}
Local nSeq		:= 0
Local cConverte
Local aTmp	:=	{}
Local nX 	:=	0                       
Local cDummy	:=	'z'
Local lTotal	:=	.F.
Local lImport	:=	(Type("lFacImport")=="L" .And. lFacImport)
DEFAULT cTes 	:= ""
DEFAULT nRecSF4 := 0

If cTes <> aTes[TS_CODIGO]
	aArea		:= GetArea()
	aAreaSFC	:= SFC->(GetArea())

	aTes[TS_SFC]		:= {}
	dbSelectArea("SF4")
	If nRecSF4 == 0
		dbSetOrder(1)
		MsSeek(xFilial("SF4")+cTes)
	Else
		MsGoto(nRecSF4)
	EndIf
	If Empty(cTes)
		aTes[TS_CODIGO] 	:= CriaVar("F4_CODIGO",.F.)
		aTes[TS_TIPO]		:= aNfCab[NF_OPERNF]
		aTes[TS_ICM]		:= IIf( cPaisLoc=="BRA","S","N")
		aTes[TS_IPI]		:= IIf( cPaisLoc=="BRA","S","N")
		aTes[TS_CREDICM]	:= "S"
		aTes[TS_CREDIPI]	:= "N"
		aTes[TS_DUPLIC]	    := "S"
		aTes[TS_ESTOQUE]	:= "S"
		aTes[TS_TEXTO]		:= CriaVar("F4_TEXTO",.F.)
		aTes[TS_BASEICM]	:= 0
		aTes[TS_BASEIPI]	:= 0
		aTes[TS_PODER3]	    := "N"
		aTes[TS_LFICM]		:= "T"
		aTes[TS_LFIPI]		:= "T"
		aTes[TS_DESTACA]	:= "N"
		aTes[TS_INCIDE]	    := "N"
		aTes[TS_COMPL]		:= "N"
		aTes[TS_IPIFRET]	:= "N"
		aTes[TS_ISS]		:= " "
		aTes[TS_LFISS]		:= " "
		aTes[TS_NRLIVRO]	:= " "
		aTes[TS_UPRC]		:= " "
		aTes[TS_CONSUMO]	:= " "
		aTes[TS_FORMULA]	:= " "
		aTes[TS_AGREG]		:= " "
		aTes[TS_INCSOL]	    := " "
		aTes[TS_CIAP]		:= " "
		aTes[TS_DESPIPI]	:= " "
		aTes[TS_LIVRO]		:= " "
		aTes[TS_ATUTEC]	    := " "
		aTes[TS_ATUATF]	    := " "
		aTes[TS_TPIPI]		:= "B"
		aTes[TS_STDESC]	    := " "
		If aNfCab[NF_OPERNF] == "E"
			aTes[TS_CF]		:= "111"
		Else
			aTes[TS_CF]		:= "511"
		EndIf
		aTes[TS_LIVRO]		:= ""
		aTes[TS_DESPICM]	:= "1"
		aTes[TS_BSICMST]	:= 0
		aTes[TS_BASEISS]	:= 0
		aTes[TS_IPILICM]  	:= "2"
		aTes[TS_ICMSDIF]  	:= "2"
		aTes[TS_QTDZERO]  	:= "2"
		aTes[TS_TRFICM]  	:= "2"
		aTes[TS_OBSICM]     := "2"
		aTes[TS_OBSSOL]     := "2"
		aTES[TS_PICMDIF]    := 100
		aTES[TS_PISCRED]    := "3"
		aTES[TS_PISCOF]     := "4"
		aTes[TS_CREDST]     := "2"
		aTes[TS_BASEPIS]    := 0
		aTes[TS_BASECOF]    := 0
		aTes[TS_ICMSST]     := "1"
		aTes[TS_FRETAUT]    := "1"
		aTes[TS_MKPCMP]     := "2"
		aTes[TS_CFEXT]      := "" 		
		aTes[TS_ISSST]      := "1"
		aTes[TS_MKPSOL]     := "2"
		aTes[TS_AGRPIS]     := "2"
		aTes[TS_AGRCOF]     := "2"		
		aTes[TS_AGRRETC]    := "2"
		aTes[TS_PISBRUT]    := "2"
		aTes[TS_COFBRUT]    := "2"
		aTes[TS_PISDSZF]    := "2"
		aTes[TS_COFDSZF]    := "2"
		aTES[TS_LFICMST]    := "N"
		aTES[TS_DESPRDIC]   := "1"
		aTes[TS_CRDEST]     := "1"
		aTes[TS_CRDPRES]    := 0
		aTes[TS_AFRMM]		:= "N"
		aTes[TS_CRDTRAN]    := 0
	Else
		aTes[TS_CODIGO] 	:= SF4->F4_CODIGO
		aTes[TS_TIPO]		:= SF4->F4_TIPO
		aTes[TS_ICM]		:= IIf( cPaisLoc=="BRA",SF4->F4_ICM,"N")
		aTes[TS_IPI]		:= IIf( cPaisLoc=="BRA",SF4->F4_IPI,"N")
		aTes[TS_CREDICM]	:= SF4->F4_CREDICM
		aTes[TS_CREDIPI]	:= SF4->F4_CREDIPI
		aTes[TS_DUPLIC]	:= SF4->F4_DUPLIC
		aTes[TS_ESTOQUE]	:= SF4->F4_ESTOQUE
		aTes[TS_CF]			:= SF4->F4_CF
		aTes[TS_TEXTO]		:= SF4->F4_TEXTO
		aTes[TS_BASEICM]	:= SF4->F4_BASEICM
		aTes[TS_BASEIPI]	:= SF4->F4_BASEIPI
		aTes[TS_PODER3]	:= SF4->F4_PODER3
		aTes[TS_LFICM]		:= SF4->F4_LFICM
		aTes[TS_LFIPI]		:= SF4->F4_LFIPI
		aTes[TS_DESTACA]	:= SF4->F4_DESTACA
		aTes[TS_INCIDE]	:= SF4->F4_INCIDE
		aTes[TS_COMPL]		:= SF4->F4_COMPL
		aTes[TS_IPIFRET]	:= SF4->F4_IPIFRET
		aTes[TS_ISS]		:= SF4->F4_ISS
		aTes[TS_LFISS]		:= SF4->F4_LFISS
		aTes[TS_NRLIVRO]	:= SF4->F4_NRLIVRO
		aTes[TS_UPRC]		:= SF4->F4_UPRC
		aTes[TS_CONSUMO]	:= SF4->F4_CONSUMO
		aTes[TS_FORMULA]	:= SF4->F4_FORMULA
		aTes[TS_AGREG]		:= SF4->F4_AGREG
		aTes[TS_INCSOL]	:= SF4->F4_INCSOL
		aTes[TS_CIAP]		:= SF4->F4_CIAP
		aTes[TS_DESPIPI]	:= SF4->F4_DESPIPI
		aTes[TS_LIVRO]		:= SF4->F4_LIVRO
		aTes[TS_ATUTEC]	:= SF4->F4_ATUTEC
		aTes[TS_ATUATF]	:= SF4->F4_ATUATF
		aTes[TS_TPIPI]		:= SF4->F4_TPIPI
		aTes[TS_LIVRO]		:= SF4->F4_LIVRO
		aTes[TS_STDESC]	:= SF4->F4_STDESC
		aTes[TS_DESPICM]	:= SF4->F4_DESPICM
		aTes[TS_BSICMST]	:= SF4->F4_BSICMST
		aTes[TS_BASEISS] 	:= SF4->F4_BASEISS
		aTes[TS_IPILICM] 	:= SF4->F4_IPILICM
		aTes[TS_ICMSDIF] 	:= SF4->F4_ICMSDIF
		aTes[TS_QTDZERO] 	:= SF4->F4_QTDZERO
		aTes[TS_TRFICM]  	:= SF4->F4_TRFICM
		aTes[TS_OBSICM]   := SF4->F4_OBSICM
		aTes[TS_OBSSOL]   := SF4->F4_OBSSOL
		aTES[TS_PICMDIF]  := SF4->F4_PICMDIF
		aTES[TS_PISCRED]  := SF4->F4_PISCRED
		aTES[TS_PISCOF]   := SF4->F4_PISCOF
		aTes[TS_CREDST]   := SF4->F4_CREDST
		aTes[TS_BASEPIS]  := SF4->F4_BASEPIS
		aTes[TS_BASECOF]  := SF4->F4_BASECOF
		aTes[TS_ICMSST]   := SF4->F4_ICMSST
		aTes[TS_ISSST]    := SF4->F4_ISSST     
		aTes[TS_AGRPIS]   := IIF(SF4->(FieldPos("F4_AGRPIS"))>0,SF4->F4_AGRPIS,"2")
		aTes[TS_AGRCOF]   := IIF(SF4->(FieldPos("F4_AGRCOF"))>0,SF4->F4_AGRCOF,"2")
		aTes[TS_AGRRETC]  := IIF(SF4->(FieldPos("F4_AGRRETC"))>0,SF4->F4_AGRRETC,"2")
		
		aTes[TS_PISBRUT]    := IIF(SF4->(FieldPos("F4_PISBRUT"))>0,SF4->F4_PISBRUT,"2")
		aTes[TS_COFBRUT]    := IIF(SF4->(FieldPos("F4_COFBRUT"))>0,SF4->F4_COFBRUT,"2")
		aTes[TS_PISDSZF]    := IIF(SF4->(FieldPos("F4_PISDSZF"))>0,SF4->F4_PISDSZF,"2")
		aTes[TS_COFDSZF]    := IIF(SF4->(FieldPos("F4_COFDSZF"))>0,SF4->F4_COFDSZF,"2")
		aTes[TS_CRDEST]     := IIF(SF4->(FieldPos("F4_CRDEST"))>0,SF4->F4_CRDEST,"1")		
		aTes[TS_CRDPRES]    := IIF(SF4->(FieldPos("F4_CRDPRES"))>0,SF4->F4_CRDPRES,0)		
		aTes[TS_AFRMM]		:= IIF(SF4->(FieldPos("F4_AFRMM"))>0,SF4->F4_AFRMM,"N")
		aTes[TS_CRDTRAN]    := IIF(SF4->(FieldPos("F4_CRDTRAN"))>0,SF4->F4_CRDTRAN,0)
		
		If cPaisLoc == "BRA"
			aTes[TS_FRETAUT]    := SF4->F4_FRETAUT
			aTes[TS_MKPCMP]     := SF4->F4_MKPCMP
			aTes[TS_CFEXT]      := SF4->F4_CFEXT
			aTes[TS_MKPSOL]     := IIF(SF4->(FieldPos("F4_MKPSOL"))>0,SF4->F4_MKPSOL,"2")
			aTES[TS_LFICMST]    := IIF(SF4->(FieldPos("F4_LFICMST"))>0,SF4->F4_LFICMST,"N")
			aTES[TS_DESPRDIC]   := IIF(SF4->(FieldPos("F4_DSPRDIC"))>0,SF4->F4_DSPRDIC,"1")
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Inicializa os impostos variaveis                            �
		//���������������������������������������������������������������	
		dbSelectArea("SFC")
		dbSetOrder(1)
		If MV_GERIMPV == "S" .And. !(IsRemito(1,"'"+MaFisRet(,'NF_TIPODOC')+"'"))
			cTesImp:=SF4->F4_CODIGO
			If cPaisLoc<>"BRA"
				If lImport .And. nItemTes <> Nil
					If (SD1->(MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aNfItem[nItemTes][IT_PRODUTO]+StrZero(nItemTes,TamSX3("D1_ITEM")[1]))))
						If SD1->D1_TIPO_NF $ "5678"
							If (SYD->(MsSeek(xFilial("SYD")+SD1->D1_TEC)))
								cTesImp:=SYD->YD_TES
							Endif
						Else
							cTesImp:=SD1->D1_TESDES
						Endif
					Endif
				Endif
			Endif
			If MsSeek(xFilial()+cTesImp)
				While !Eof() .And. xFilial()+cTesImp == SFC->FC_FILIAL+SFC->FC_TES
					SFB->(dbSetOrder(1))
					SFB->(MsSeek(xFilial()+SFC->FC_IMPOSTO))
					If Ascan(aTes[TS_SFC],{|x| x[SFC_IMPOSTO]==SFC->FC_IMPOSTO})==0
						Aadd(aTes[TS_SFC],Array(19))
						nSeq := Len(aTes[TS_SFC])
						aTes[TS_SFC][nSeq][SFC_SEQ]			:= SFC->FC_SEQ
						aTes[TS_SFC][nSeq][SFC_IMPOSTO]		:= SFC->FC_IMPOSTO
						aTes[TS_SFC][nSeq][SFC_CALCULO]		:= SFC->FC_CALCULO
						If IsAlpha(SFC->FC_INCDUPL)
							cConverte := SFC->FC_INCDUPL + SFC->FC_INCNOTA + SFC->FC_CREDITA
							aTes[TS_SFC][nSeq][SFC_INCDUPL]	 :=	IIf(Subs(cConverte,1,2)=="SN".Or.Subs(cConverte,1,2)=="NS","3",;
								IIf(Subs(cConverte,1,2)=="SS","1","2"))
							aTes[TS_SFC][nSeq][SFC_INCNOTA]	 :=	IIf(Subs(cConverte,2,1)=="S" ,"1",IIf(Subs(cConverte,2,1)=="R" ,"2","3"))
							aTes[TS_SFC][nSeq][SFC_CREDITA]	 :=	IIf(Subs(cConverte,2,2)=="SN","1",IIf(Subs(cConverte,2,2)=="NS","2","3"))
						Else
							aTes[TS_SFC][nSeq][SFC_INCDUPL]		:= SFC->FC_INCDUPL
							aTes[TS_SFC][nSeq][SFC_INCNOTA]		:= SFC->FC_INCNOTA
							aTes[TS_SFC][nSeq][SFC_CREDITA]		:= SFC->FC_CREDITA
						EndIf
						aTes[TS_SFC][nSeq][SFC_INCIMP]		:= SFC->FC_INCIMP
						aTes[TS_SFC][nSeq][SFC_BASE]		:= SFC->FC_BASE
						aTes[TS_SFC][nSeq][SFB_DESCR]		:= SFB->FB_DESCR
						aTes[TS_SFC][nSeq][SFB_CPOVREI]		:= "D1_VALIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_CPOBAEI]		:= "D1_BASIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_CPOVREC]		:= "F1_VALIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_CPOBAEC]		:= "F1_BASIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_CPOVRSI]		:= "D2_VALIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_CPOBASI]		:= "D2_BASIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_CPOVRSC]		:= "F2_VALIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_CPOBASC]		:= "F2_BASIMP"+SFB->FB_CPOLVRO
						aTes[TS_SFC][nSeq][SFB_FORMENT]		:= SFB->FB_FORMENT
						aTes[TS_SFC][nSeq][SFB_FORMSAI]		:= SFB->FB_FORMSAI
						Aadd(aTmp,Val(SFB->FB_CPOLVRO))
						If aTes[TS_SFC][nSeq][SFC_CALCULO]=="T"
							lTotal	:=	.T.
						Endif	
					Endif
					dbSkip()
				Enddo
				If cPaisLoc == "ARG" .and. lTotal
					aSort(aTmp)
					For nX:= 1 To Len(aTmp)
						If aTmp[nX] <> nX
							cDummy	:=	Str(nX,1)
							Exit
						Endif	
					Next
					If cDummy <> 'z' 
						aSize(aTes[TS_SFC],Len(aTes[TS_SFC])+1)
						aIns(aTes[TS_SFC],1)
						aTes[TS_SFC][1]	:=	aClone(aTes[TS_SFC][2])
						aTes[TS_SFC][1][SFC_SEQ]			:= '00'
						aTes[TS_SFC][1][SFC_IMPOSTO]		:= 'DUM'
						aTes[TS_SFC][1][SFC_CALCULO]		:= 'T'
						aTes[TS_SFC][1][SFB_DESCR]			:= "Dummy"
						aTes[TS_SFC][1][SFB_CPOVREI]		:= "D1_VALIMP"+cDummy
						aTes[TS_SFC][1][SFB_CPOBAEI]		:= "D1_BASIMP"+cDummy
						aTes[TS_SFC][1][SFB_CPOVREC]		:= "F1_VALIMP"+cDummy
						aTes[TS_SFC][1][SFB_CPOBAEC]		:= "F1_BASIMP"+cDummy
						aTes[TS_SFC][1][SFB_CPOVRSI]		:= "D2_VALIMP"+cDummy
						aTes[TS_SFC][1][SFB_CPOBASI]		:= "D2_BASIMP"+cDummy
						aTes[TS_SFC][1][SFB_CPOVRSC]		:= "F2_VALIMP"+cDummy
						aTes[TS_SFC][1][SFB_CPOBASC]		:= "F2_BASIMP"+cDummy
						aTes[TS_SFC][1][SFB_FORMENT]		:= "MaFisZero"
						aTes[TS_SFC][1][SFB_FORMSAI]		:= "MaFisZero"
						MaFisZero() //PAra evitar erro de compilacao
					Endif
				Endif
			Endif
		Else
			aTes[TS_SFC] := {}
		EndIf
	EndIf
	RestArea(aAreaSFC)
	RestArea(aArea)
EndIf

cTes := aTes[TS_CODIGO]

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqICM � Autor �Eduardo/Edson          � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo da Aliquota para operacoes de ICMS                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Aliquota de ICMS                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item do documento                                    ���
���          �ExpL2: Calcula a aliquota interna para o calculo do Solid.  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaAliqIcms(nItem,lSolidario)

Local cMV_NORTE	:= SuperGetMV("MV_NORTE")
Local nAliquota := If ( MaSBCampo("PICM") == 0 , MV_ICMPAD ,  MaSBCampo("PICM") )
Local cTipoNF   := aNfCab[NF_TIPONF]

DEFAULT lSolidario := .F.
If aTes[TS_ICM] <> "N" .Or. lSolidario
	//�������������������������������������������������������������Ŀ
	//� Verifica se a nota fiscal eh de Conhecimento de Frete       �
	//���������������������������������������������������������������
	If ("CTR"$AllTrim(aNFCab[NF_ESPECIE]).Or."NFST"$AllTrim(aNFCab[NF_ESPECIE]))
		nAliquota := Val(Substr(MV_FRETEST,(AT(aNfCab[NF_UFORIGEM],MV_FRETEST)+2),2))
		nAliquota := IIf(nAliquota>0,MyNoRound(nAliquota,2),12)			
	EndIf
	Do Case
		//�������������������������������������������������������������Ŀ
		//� Verifica se a nota fiscal eh de Conhecimento de Frete       �
		//���������������������������������������������������������������
	Case aNfCab[NF_TPCOMP] == "F"
		//�������������������������������������������������������������������Ŀ
		//� Verifica o Parametro MV_FRETEST que contem as Aliq. de ICMS/Frete �
		//���������������������������������������������������������������������
		If Empty(MV_FRETEST)
			If aNfCab[NF_UFDEST]$MV_NORTE.And.!(aNfCab[NF_UFORIGEM]$MV_NORTE)
				nAliquota := 7
			Else
				nALiquota := 12 // Aliquota de Frete Fixa em 12%
			EndIf
		Else
			nAliquota := Val(Substr(MV_FRETEST,(AT(aNfCab[NF_UFORIGEM],MV_FRETEST)+2),2))
			nAliquota := IIf(nAliquota>0,MyNoRound(nAliquota,2),12)
		EndIf
	Case AllTrim(aNFCab[NF_ESPECIE])$"CA"
		//�������������������������������������������������������������������Ŀ
		//� Verifica o Parametro MV_FRETEST que contem as Aliq. de ICMS/Frete �
		//���������������������������������������������������������������������
		If aNFCab[NF_LINSCR]
			If aNfCab[NF_UFDEST]$MV_NORTE.And.!(aNfCab[NF_UFORIGEM]$MV_NORTE)
				nAliquota := 7
			Else
				nAliquota := 12 // Aliquota de Frete Fixa em 12%
			EndIf
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Verifica se a nota fiscal eh de Servicos                    �
		//���������������������������������������������������������������
	Case ( aTes[TS_ISS] =="S" )
		//�������������������������������������������������������������Ŀ
		//� Calcula a aliquota do ISS                                   �
		//���������������������������������������������������������������
		nAliquota := If ( MaSBCampo("ALIQISS") == 0 , MV_ALIQISS , MaSBCampo("ALIQISS") )
		//�������������������������������������������������������������Ŀ
		//� Verifica as Excecoes fiscais                                �
		//���������������������������������������������������������������
		If ( !Empty(aNFitem[nItem][IT_EXCECAO]) )
			If ( aNFCab[NF_UFORIGEM]==aNFCab[NF_UFDEST])
				If (aNfItem[nItem][IT_EXCECAO][1] > 0)
					nAliquota := aNfItem[nItem][IT_EXCECAO][1] //Aliquota Interna
				EndIf
			Else
				If aNfItem[nItem][IT_EXCECAO][2] > 0
					nAliquota := aNfItem[nItem][IT_EXCECAO][2] //Aliquota Externa
				EndIf
			EndIf
		EndIf
	Case ( aTes[TS_PODER3] =="D" )  //Devolucao de Poder de Terceiros
		If !Empty(aNFItem[nItem][IT_RECORI])
			If aNFCab[NF_OPERNF] == "E"
				dbSelectArea("SD2")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				nAliquota  := SD2->D2_PICM
				cTipoNF    := IIf(SD2->D2_TIPO$"IP",SD2->D2_TIPO,cTipoNF)
			Else
				dbSelectArea("SD1")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				nAliquota  := SD1->D1_PICM
				cTipoNF    := IIf(SD1->D1_TIPO$"IP",SD1->D1_TIPO,cTipoNF)
			EndIf
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Nas devolucoes sempre pega a aliquota da NF original.       �
		//���������������������������������������������������������������
	Case ( aNFCab[NF_TIPONF] == "D" .And. !Empty(aNFItem[nItem][IT_RECORI]) )
		If aNFCab[NF_TIPONF] == "D"
			If ( aNFCab[NF_CLIFOR] == "C" )
				dbSelectArea("SD2")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				nAliquota  := SD2->D2_PICM
				cTipoNF    := IIf(SD2->D2_TIPO$"IP",SD2->D2_TIPO,cTipoNF)
				If SD2->D2_DESCZFR > 0
					nAliquota := 0
				EndIf
			Else
				dbSelectArea("SD1")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				nAliquota  := SD1->D1_PICM
				cTipoNF    := IIf(SD1->D1_TIPO$"IP",SD1->D1_TIPO,cTipoNF)
			EndIf
		Else
			If ( aNFCab[NF_CLIFOR] == "C" )
				dbSelectArea("SD1")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				nAliquota  := SD1->D1_PICM
				cTipoNF    := IIf(SD1->D1_TIPO$"IP",SD1->D1_TIPO,cTipoNF)
			Else
				dbSelectArea("SD2")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				nAliquota  := SD2->D2_PICM
				cTipoNF    := IIf(SD2->D2_TIPO$"IP",SD2->D2_TIPO,cTipoNF)
			EndIf
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Verifica se a nota fiscal eh de ICMS                        �
		//���������������������������������������������������������������
		//�������������������������������������������������������������Ŀ
		//� Tratamento para Exportacao                                  �
		//���������������������������������������������������������������
	Case ( aNFCab[NF_TPCLIFOR] == "X" )
		If ( aNFCab[NF_CLIFOR]=="C" )
			//�������������������������������������������������������������Ŀ
			//� Calculo da Aliquota de ICMS para Exportacao                 �
			//���������������������������������������������������������������
			nAliquota := 13
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Verifica as Excecoes fiscais                                �
		//���������������������������������������������������������������
		If ( !Empty(aNFitem[nItem][IT_EXCECAO]) .And. aNFItem[nItem][IT_EXCECAO][1]>0)
			nAliquota := aNFItem[nItem][IT_EXCECAO][1] //Aliquota Interna
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Tratamento para Nao Inscritos e Consumidores Finais         �
		//���������������������������������������������������������������
	Case ( aNFCab[NF_LINSCR] )
		If ( aNFCab[NF_CLIFOR]=="F" )
			nAliquota := IIf(!Empty(MaSBCampo("PICM")),MaSBCampo("PICM"),MaAliqOrig(nItem))
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Verifica as Excecoes fiscais                                �
		//���������������������������������������������������������������
		If ( !Empty(aNFItem[nItem][IT_EXCECAO]) )
			If ( aNFCab[NF_UFORIGEM] == aNFCab[NF_UFDEST] )
				If ( aNFItem[nItem][IT_EXCECAO][1] ) <> 0
					nAliquota := aNFItem[nItem][IT_EXCECAO][1]  //Aliq. de ICMS Interna
				EndIf
			Else
				If ( !aNFCab[NF_LINSCR] )
					If (aNFItem[nItem][IT_EXCECAO][2] > 0)
						nAliquota :=  aNFItem[nItem][IT_EXCECAO][2]   //Aliq. de ICMS Externa
					EndIf
				Else
					If (aNFItem[nItem][IT_EXCECAO][1] > 0)
						nAliquota :=  aNFItem[nItem][IT_EXCECAO][1]   //Aliq. de ICMS Interna
					EndIf
				EndIf
			EndIf
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Tratamento para Operacoes internas com ICMS                 �
		//���������������������������������������������������������������
	Case ( aNFCab[NF_UFORIGEM] == aNFCab[NF_UFDEST] )
		//�������������������������������������������������������������Ŀ
		//� Verifica as Excecoes fiscais                                �
		//���������������������������������������������������������������
		If ( !Empty(aNFItem[nItem][IT_EXCECAO]) )
			If ( aNFItem[nItem][IT_EXCECAO][1] ) <> 0
				nAliquota :=  aNFItem[nItem][IT_EXCECAO][1]   //Aliq. de ICMS Interna
			EndIf
		EndIf
		//�������������������������������������������������������������Ŀ
		//� Tratamento para Operacaoes InterEstaduais com ICMS          �
		//���������������������������������������������������������������
	Case ( aNFCab[NF_UFORIGEM] <> aNFCab[NF_UFDEST] )
		If ( aNFCab[NF_TIPONF] <> "D" )
			//�������������������������������������������������������������Ŀ
			//� Calculo da Aliquota de ICMS                                 �
			//���������������������������������������������������������������
			If ( aNFCab[NF_UFORIGEM] $ MV_NORTE )
				nAliquota := 12 //MV_ICMTRF
			Else
				nAliquota := IIf( aNFCab[NF_UFDEST] $ MV_NORTE , 7 , 12 ) //MV_ICMTRF
			EndIf
			//�������������������������������������������������������������Ŀ
			//� Verifica as Excecoes fiscais                                �
			//���������������������������������������������������������������
			If ( !Empty(aNFItem[nItem][IT_EXCECAO]) )
				If ( aNFItem[nItem][IT_EXCECAO][2] ) <> 0
					nAliquota :=  aNFItem[nItem][IT_EXCECAO][2]   //Aliq. de ICMS Externa
				EndIf
			EndIf
		Else
			//�������������������������������������������������������������Ŀ
			//� Calculo da Aliquota de ICMS                                 �
			//���������������������������������������������������������������
			If ( aNFCab[NF_UFORIGEM] $ cMV_NORTE )
				nAliquota := IIf( aNFCab[NF_UFORIGEM] $ cMV_NORTE , 12 , 7 ) //MV_ICMTRF
			Else
				nAliquota := 12 //MV_ICMTRF
			Endif
		EndIf
	EndCase
Else
	nAliquota := 0
EndIf
If aTes[TS_ICM] <> "N"
	aNFitem[nItem][IT_ALIQICM] := nAliquota
	aNFitem[nItem][IT_TIPONF ] := cTipoNF
Else
	aNFitem[nItem][IT_ALIQICM] := 0
	aNFitem[nItem][IT_TIPONF ] := cTipoNF
EndIf

Return(nAliquota)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqDest� Autor �Eduardo/Edson          � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo da Aliquota para operacoes de ICMS                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Aliquota de ICMS                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaAliqDest(nItem)

Local nPerIcm
Local cDestino := aNFCab[NF_UFDEST]

nPerIcm := Val(Subs(MV_ESTICM,AT(cDestino,MV_ESTICM)+2,2))
If !Empty(MV_FRETEST) .And. aNfCab[NF_TPCOMP] == "F"
	nPerICM := Val(Substr(MV_FRETEST,(AT(aNfCab[NF_UFDEST],MV_FRETEST)+2),2))
	nPerICM := IIf(nPerICM>0,MyNoRound(nPerICM,2),12)
EndIf
If ( !Empty(aNFItem[nItem][IT_EXCECAO]) )
	If ( aNFItem[nItem][IT_EXCECAO][6] ) <> 0
		nPerIcm := aNfItem[nItem][IT_EXCECAO][6]
	EndIf
EndIf
Return(nPerIcm)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqIPI � Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo da Aliquota de IPI.                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Aliquota de IPI.                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaAliqIPI(nItem)

Local nAliquota	:= 0
Local cTipoNF   := aNfCab[NF_TIPONF]

If aTes[TS_IPI] <> "N"
	nAliquota := MaSBCampo("IPI")
	Do Case
	Case ( aNFCab[NF_TIPONF] $"DB" ) .Or. aTes[TS_PODER3] =="D"

		If aNFCab[NF_TIPONF] $ "DB"
			If !Empty(aNFItem[nItem][IT_RECORI])
				If ( aNFCab[NF_CLIFOR] == "C" )
					dbSelectArea("SD2")
					MsGoto( aNFItem[nItem][IT_RECORI] )
					nAliquota  := SD2->D2_IPI
					cTipoNF    := IIf(SD2->D2_TIPO$"IP",SD2->D2_TIPO,cTipoNF)
				Else
					dbSelectArea("SD1")
					MsGoto( aNFItem[nItem][IT_RECORI] )
					nAliquota  := SD1->D1_IPI
					cTipoNF    := IIf(SD1->D1_TIPO$"IP",SD1->D1_TIPO,cTipoNF)
				EndIf
			EndIf
		Else
			If !Empty(aNFItem[nItem][IT_RECORI])
				If ( aNFCab[NF_CLIFOR] == "C" )
					dbSelectArea("SD1")
					MsGoto( aNFItem[nItem][IT_RECORI] )
					nAliquota  := SD1->D1_IPI
					cTipoNF    := IIf(SD1->D1_TIPO$"IP",SD1->D1_TIPO,cTipoNF)
				Else
					dbSelectArea("SD2")
					MsGoto( aNFItem[nItem][IT_RECORI] )
					nAliquota  := SD2->D2_IPI
					cTipoNF    := IIf(SD2->D2_TIPO$"IP",SD2->D2_TIPO,cTipoNF)
				EndIf
			EndIf
		EndIf
	EndCase
EndIf
aNFitem[nItem][IT_ALIQIPI] := nAliquota
aNFitem[nItem][IT_TIPONF ] := cTipoNF
Return nAliquota

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaFisRet � Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna os impostos calculados pela MATXFIS.               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Valor do imposto.                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRet(nItem,cCampo)
Local nRetorno
Local cPosCpo := MaFisScan(cCampo)

Do Case
Case Substr(cCampo,1,2) == "IT"
	If ValType(cPosCpo) == "A"
		nRetorno:=aNfItem[nItem][cPosCpo[1]][cPosCpo[2]]
	Else
		nRetorno:=aNfItem[nItem][Val(cPosCpo)]
	EndIf
Case Substr(cCampo,1,2) == "LF"
	If nItem == Nil
		nRetorno:=aNfItem[nItem][NF_LIVRO][cPosCpo]
	Else
		nRetorno:=aNfItem[nItem][IT_LIVRO][cPosCpo]
	EndIf
OtherWise
	If ValType(cPosCpo) == "A"
		nRetorno:=aNfCab[cPosCpo[1]][cPosCpo[2]]
	Else
		nRetorno:=aNfCab[Val(cPosCpo)]
	EndIf
EndCase

Return nRetorno

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisFound� Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se o item ja existe na relacao de itens incluidos. ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Valor do imposto.                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisFound(cCampo,nItem)
Local lRetorno := .T.

If aNfItem <> Nil
	If cCampo == "IT"
		If nItem > Len(aNfItem)
			lRetorno := .F.
		EndIf
	Else
		If Empty(aNfCab)
			lRetorno := .F.
		EndIf
	EndIf
Else
	lRetorno := .F.
EndIf

Return lRetorno

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisScan � Autor �Eduardo/Edson          � Data �02.04.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao de procura da posicao da referencia nos arrays inter ���
���          �nos                                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpX1: Posicao da referencia                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 : Codigo da Referencia                               ���
���          � ExpL2 : Flag de indicacao de tratamento de erro            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisScan(cCampo,lErro)

Local cPosCpo := 0
Local nScan   := 0

DEFAULT lErro := .T.

If aItemRef == Nil
	MaIniRef()
EndIf

If Substr(cCampo,1,2) == "IT"
	nScan	:= aScan(aItemRef,{|x|x[1]==cCampo})
	If nScan > 0
		cPosCpo	:= aItemRef[nScan][2]
	Else
		If lErro
			MsgAlert(STR0001 + cCampo ) //"ERRO MATXFIS - Referencia de imposto invalida : "
			Final(STR0002) //"ERRO MATXFIS - Referencia de imposto invalida "
		EndIf
	EndIf
ElseIf Substr(cCampo,1,2) == "NF"
	nScan	:= aScan(aCabRef,{|x|x[1]==cCampo})
	If nScan > 0
		cPosCpo	:= aCabRef[nScan][2]
	Else
		If lErro
			MsgAlert(STR0001 + cCampo ) //"ERRO MATXFIS - Referencia de imposto invalida : "
			Final(STR0002) //"ERRO MATXFIS - Referencia de imposto invalida "
		EndIf
	EndIf
ElseIf Substr(cCampo,1,2) == "LF"
	nScan	:= aScan(aLFis,{|x|x[1]==cCampo})
	If nScan > 0
		cPosCpo	:= aLFis[nScan][2]
	Else
		If lErro
			MsgAlert(STR0001 + cCampo ) //"ERRO MATXFIS - Referencia de imposto invalida : "
			Final(STR0002) //"ERRO MATXFIS - Referencia de imposto invalida "
		EndIf
	EndIf
ElseIf Substr(cCampo,1,3) == "IMP"
	nScan 	:= aScan(aResRef,{|x|x[1]==cCampo})
	If nScan > 0
		cPosCpo	:= aResRef[nScan][2]
	Else
		If lErro
			MsgAlert(STR0001 + cCampo ) //"ERRO MATXFIS - Referencia de imposto invalida : "
			Final(STR0002) //"ERRO MATXFIS - Referencia de imposto invalida "
		EndIf
	EndIf
EndIf
Return(cPosCpo)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBSICA� Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo da Base do ICMS do frete Autonomo.        ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBSICA(nX)

If aTes[TS_FRETAUT] <> "2"
	aNfItem[nX][IT_BASEICA] := aNfItem[nX][IT_AUTONOMO]
Else
	aNfItem[nX][IT_BASEICA] := 0
EndIf

Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVlICA� Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo do Valor do ICMS do Frete Autonomo.       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVLICA(nX)

If aTes[TS_ICM] <> "N"
	//�������������������������������������������������������������Ŀ
	//� Calculo do valor do ICMS do frete autonomo do item.         �
	//���������������������������������������������������������������
	aNfItem[nX][IT_VALICA]	:= aNfItem[nX][IT_BASEICA]*aNfItem[nX][IT_ALIQICM]/100
Else
	aNfItem[nX][IT_VALICA]	:= 0
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBSICM� Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo da Base do ICMS do Item.                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBSICM(nX,lReproc)

Local nSalvaBase := 0
Local lIncide    := .F.
Local nReduzICMS := 0 
Local nDespOri   := 0
Local nBsFrete   := 0
Local lRet       := .F.

//-- Na devolucao integral a base do ICMS devera ser a mesma da nota original.
If ( aNFCab[NF_TIPONF] $ "DB" .OR. aTes[TS_PODER3] =="D" ) .And. !Empty(aNFItem[nX][IT_RECORI])
	If aNFCab[NF_TIPONF] $ "DB"
		If ( aNFCab[NF_CLIFOR] == "C")
			dbSelectArea("SD2")
			MsGoto(aNFItem[nX][IT_RECORI])
			If aNfItem[nX][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
				aNfItem[nX][IT_BASEICM] := SD2->D2_BASEICM
				lRet := .T.
			EndIf
		Else
			dbSelectArea("SD1")
			MsGoto(aNFItem[nX][IT_RECORI])
			If aNfItem[nX][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
				aNfItem[nX][IT_BASEICM] := SD1->D1_BASEICM
				lRet := .T.
			EndIf
		EndIf
	Else
		If ( aNFCab[NF_CLIFOR] == "C")
			dbSelectArea("SD1")
			MsGoto(aNFItem[nX][IT_RECORI])
			If aNfItem[nX][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
				aNfItem[nX][IT_BASEICM] := SD1->D1_BASEICM
				lRet := .T.
			EndIf
		Else
			dbSelectArea("SD2")
			MsGoto(aNFItem[nX][IT_RECORI])
			If aNfItem[nX][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
				aNfItem[nX][IT_BASEICM] := SD2->D2_BASEICM
				lRet := .T.
			EndIf
		EndIf
	EndIf
EndIf

If !lRet
	//�������������������������������������������������������������Ŀ
	//� Carrega a reducao da base do ICMS                           �
	//���������������������������������������������������������������
	If !Empty(aNFitem[nX,IT_EXCECAO]) .And. aNfItem[nX,IT_EXCECAO,14] > 0
		nReduzICMS := aNfItem[nX,IT_EXCECAO,14]
	Else 
		nReduzICMS := aTes[TS_BASEICM]
	EndIf 	
	
	lReproc := IIf(lReproc==Nil,.F.,lReproc)
	
	//�������������������������������������������������������������Ŀ
	//� Salva  a base do ICMS no reprocessamento.                   �
	//���������������������������������������������������������������
	nSalvaBase	:= aNfItem[nX][IT_BASEICM]
	//�������������������������������������������������������������Ŀ
	//� Calculo da base de ICMS - Valor da Mercadoria               �
	//���������������������������������������������������������������
	aNfItem[nX][IT_BICMORI]	:= aNfItem[nX][IT_VALMERC] - aNfItem[nX][IT_DESCONTO] + aNfItem[nX][IT_DESCZF]
	//�������������������������������������������������������������Ŀ
	//� Calculo da base de ICMS - Pauta fiscal                      �
	//���������������������������������������������������������������
	If MaSbCampo("INT_ICM")<>Nil .And.  MaSbCampo("INT_ICM")<>0
		aNfItem[nX][IT_BICMORI] := Max(aNfItem[nX][IT_QUANT]*MaSbCampo("INT_ICM"),aNfItem[nX][IT_BICMORI])
		If !Empty(GetNewPar("MV_ICMPFAT",""))
			aNfItem[nX][IT_BICMORI] *= MaSBCampo(SubStr(GetNewPar("MV_ICMPFAT",""),4))
		EndIf
		If GetNewPar("MV_ICPAUTA","1")=="2"
			If aTES[TS_DESPRDIC] $ " 1"
				aNfItem[nX][IT_BICMORI]	+= aNfItem[nX][IT_FRETE]
				aNfItem[nX][IT_BSFRETE]	:= aNfItem[nX][IT_FRETE]
				If aTes[TS_DESPICM] <> "2"
					aNfItem[nX][IT_BICMORI]	+= aNfItem[nX][IT_DESPESA]
					aNfItem[nX][IT_BICMORI]	+= aNfItem[nX][IT_SEGURO]
				EndIf
			Else
				nDespOri += aNfItem[nX][IT_FRETE]
				nBsFrete += aNfItem[nX][IT_FRETE]
				If aTes[TS_DESPICM] <> "2"
					nDespOri += aNfItem[nX][IT_DESPESA]
					nDespOri += aNfItem[nX][IT_SEGURO]
				EndIf
			EndIf
		EndIf
	Else
		If aTES[TS_DESPRDIC] $ "1 "
			aNfItem[nX][IT_BICMORI]	+= aNfItem[nX][IT_FRETE]
			aNfItem[nX][IT_BSFRETE]	:= aNfItem[nX][IT_FRETE]
			If aTes[TS_DESPICM] <> "2"
				aNfItem[nX][IT_BICMORI]	+= aNfItem[nX][IT_DESPESA]
				aNfItem[nX][IT_BICMORI]	+= aNfItem[nX][IT_SEGURO]
			EndIf
		Else
			nDespOri += aNfItem[nX][IT_FRETE]
			nBsFrete += aNfItem[nX][IT_FRETE]
			If aTes[TS_DESPICM] <> "2"
				nDespOri += aNfItem[nX][IT_DESPESA]
				nDespOri += aNfItem[nX][IT_SEGURO]
			EndIf
		EndIf
	EndIf
	If aTes[TS_INCIDE] == "S" .or. (aTes[TS_INCIDE] == "F" .and. aNFCab[NF_TPCLIFOR] =="F" .and. aNFCab[NF_CLIFOR] =="C")
		lIncide := .T.
		If aNFitem[nX][IT_TIPONF ] <> "P"
			aNfItem[nX][IT_BICMORI]	+= aNfItem[nX][IT_VALIPI]
		Else
			aNfItem[nX][IT_BICMORI]	:= aNfItem[nX][IT_VALIPI]
		EndIf
		If aNfItem[nX][IT_BSFRETE]<>0
			aNfItem[nX][IT_BSFRETE]	+= aNfItem[nX][IT_VALIPI]
		EndIf
		If aTes[TS_IPILICM] <> "1"
			aNfItem[nX][IT_VIPIBICM]:= (aNfItem[nX][IT_VALIPI])
		Else
			aNfItem[nX][IT_VIPIBICM]:= 	0
		EndIf
	EndIf
	
	If (aTes[TS_ICM] <> "N" .And. !aNFitem[nX][IT_TIPONF ]$"IP") .Or. (aNFitem[nX][IT_TIPONF ]=="P".And.lIncide)
		If aTes[TS_AGREG]=="I" .Or. aTes[TS_AGREG]=="A"
			aNfItem[nX][IT_BICMORI]	:= Round(aNfItem[nX][IT_BICMORI]/( 1 - (aNfItem[nX][IT_ALIQICM]/100*IIF(nReduzICMS==0,1,nReduzICMS/100))),2)
			aNfItem[nX][IT_BSFRETE]	:= Round(aNfItem[nX][IT_BSFRETE]/( 1 - (aNfItem[nX][IT_ALIQICM]/100*IIF(nReduzICMS==0,1,nReduzICMS/100))),2)
			nDespOri := nDespOri/( 1 - (aNfItem[nX][IT_ALIQICM]/100))
			nBsFrete := nBsFrete/( 1 - (aNfItem[nX][IT_ALIQICM]/100))
		EndIf
		If (aTes[TS_AGREG]=="D" .And. nReduzICMS > 0)
			aNfItem[nX][IT_DEDICM]	:= Round(aNfItem[nX][IT_BICMORI]*aNfItem[nX][IT_ALIQICM]/100*(1-(nReduzICMS/100)),2)
		EndIf	
		If (aTes[TS_AGREG]=="E" )
			aNfItem[nX][IT_DEDICM]	:= aNfItem[nX][IT_BICMORI]-Round(aNfItem[nX][IT_BICMORI]*( 1 - (aNfItem[nX][IT_ALIQICM]/100*IIF(nReduzICMS==0,1,nReduzICMS/100))),2)
		EndIf	
		//�������������������������������������������������������������Ŀ
		//� Salva a base de ICMS original e aplica a reducao.           �
		//���������������������������������������������������������������
		aNfItem[nX][IT_BASEICM]	:= aNfItem[nX][IT_BICMORI]
		If nReduzICMS > 0
			aNfItem[nX][IT_BASEICM]	:= aNfItem[nX][IT_BASEICM] * nReduzICMS /100
			MaItArred(nX,{"IT_BASEICM"})
			aNfItem[nX][IT_BSFRETE]	:= aNfItem[nX][IT_BSFRETE] * nReduzICMS /100
			MaItArred(nX,{"IT_BSFRETE"})
			If aTes[TS_INCIDE] == "S"  .or. (aTes[TS_INCIDE] == "F" .and. aNFCab[NF_TPCLIFOR] =="F" .and. aNFCab[NF_CLIFOR] =="C")
				aNfItem[nX][IT_VIPIBICM]	:= MyNoRound(aNfItem[nX][IT_VIPIBICM]* nReduzICMS /100,2)
			Else
				aNfItem[nX][IT_VIPIBICM]	:= 0
			EndIf
		EndIf
		If aTES[TS_DESPRDIC] == "2"
			aNfItem[nX][IT_BASEICM] += nDespOri
			aNfItem[nX][IT_BICMORI] += nDespOri
			aNfItem[nX][IT_BSFRETE] += nBsFrete
		EndIf	
	Else
		aNfItem[nX][IT_BASEICM]	:= 0
		aNfItem[nX][IT_BSFRETE]	:= 0
	EndIf
	If lReproc
		aNfItem[nX][IT_BASEICM]	:= nSalvaBase
	EndIf
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVICMS� Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo do Valor do ICMS  do Item.                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVICMS(nX)

If aTes[TS_ICM] <> "N"
	//�������������������������������������������������������������Ŀ
	//� Calculo do valor do ICMS do item.                           �
	//���������������������������������������������������������������
	If aNFitem[nX][IT_TIPONF ] == "I"
		aNfItem[nX][IT_VALICM]	:= aNfItem[nX][IT_VALMERC]
		aNfItem[nX][IT_ICMFRETE]	:= 0
	Else
		aNfItem[nX][IT_VALICM]	:= aNfItem[nX][IT_BASEICM]*aNfItem[nX][IT_ALIQICM]/100
		aNfItem[nX][IT_ICMFRETE]	:= aNfItem[nX][IT_BSFRETE]*aNfItem[nX][IT_ALIQICM]/100
		If aNFCab[NF_TIPONF] $ "DB" .OR. aTes[TS_PODER3] =="D"
			If !Empty(aNFItem[nX][IT_RECORI])
				If aNFCab[NF_TIPONF] $ "DB"				
					If ( aNFCab[NF_CLIFOR] == "C")
						dbSelectArea("SD2")
						MsGoto(aNFItem[nX][IT_RECORI])
						If Abs(aNfItem[nX][IT_VALICM]-SD2->D2_VALICM)<=1 .And. aNfItem[nX][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
							aNfItem[nX][IT_VALICM] := SD2->D2_VALICM
						EndIf
					Else
						dbSelectArea("SD1")
						MsGoto(aNFItem[nX][IT_RECORI])
						If Abs(aNfItem[nX][IT_VALICM]-SD1->D1_VALICM)<=1 .And. aNfItem[nX][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
							aNfItem[nX][IT_VALICM] := SD1->D1_VALICM
						EndIf
					EndIf
				Else
					If ( aNFCab[NF_CLIFOR] == "C")
						dbSelectArea("SD1")
						MsGoto(aNFItem[nX][IT_RECORI])
						If Abs(aNfItem[nX][IT_VALICM]-SD1->D1_VALICM)<=1 .And. aNfItem[nX][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
							aNfItem[nX][IT_VALICM] := SD1->D1_VALICM
						EndIf
					Else
						dbSelectArea("SD2")
						MsGoto(aNFItem[nX][IT_RECORI])
						If Abs(aNfItem[nX][IT_VALICM]-SD2->D2_VALICM)<=1 .And. aNfItem[nX][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
							aNfItem[nX][IT_VALICM] := SD2->D2_VALICM
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf		
	EndIf
Else
	aNfItem[nX][IT_VALICM]	 := 0
	aNfItem[nX][IT_ICMFRETE] := 0
EndIf
If aTes[TS_AGREG]=="I" .Or. aTes[TS_AGREG]=="A"
	aNfItem[nX][IT_VALICM]   := Round(aNfItem[nX][IT_VALICM],2)
	aNfItem[nX][IT_ICMFRETE] := Round(aNfItem[nX][IT_ICMFRETE],2)
EndIf
If aTES[TS_PICMDIF]<>100 .And. aTES[TS_PICMDIF]<>0
	aNfItem[nX][IT_ICMSDIF] := MyNoRound(aNfItem[nX][IT_VALICM]*aTes[TS_PICMDIF]/100,2)
EndIf


Return

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisBSIPI� Autor �Edson Maricate         � Data �08.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de calculo da base do imposto sobre produtos industri-���
���          �alizacos ( IPI ).                                            ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item do Array ANFItem que deve ser calculado          ���
���          �ExpL2: Indica se o calculo nao deve ser efetuado, assim somen���
���          �       te as variaveis devem ser inicializadas               ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo calcular a base de IPI conforme���
���          �definido no Regulamento do IPI. A base eh calculada para o   ���
���          �IPI de pauta e para o IPI Normal.                            ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisBSIPI(nX,lBsOri)

Local nSalvaBase := aNfItem[nX][IT_BASEIPI]
Local nReduzIPI  := 0 
DEFAULT lBsOri := .F.

If !Empty(aNFitem[nX,IT_EXCECAO]) .And. aNfItem[nX,IT_EXCECAO,15] > 0
	nReduzIPI := aNfItem[nX,IT_EXCECAO,15]
Else 
	nReduzIPI := aTes[TS_BASEIPI]
EndIf 	

//�������������������������������������������������������������Ŀ
//� Posiciona os registros necessarios                          �
//���������������������������������������������������������������
dbSelectArea(cAliasPROD)
If aNfItem[nX][IT_RECNOSB1] <> 0 .And. cAliasPROD=="SB1"
	MsGoto(aNfItem[nX][IT_RECNOSB1])
Else
	dbSetOrder(1)
	MsSeek(xFilial(cAliasPROD)+aNfItem[nX][IT_PRODUTO])
EndIf
MaFisTes(aNfItem[nX][IT_TES],aNfItem[nX][IT_RECNOSF4],nX)
//�������������������������������������������������������������Ŀ
//� Verifica se o IPI deve ser calculado                        �
//���������������������������������������������������������������
If ( aTes[TS_IPI] <> "N" .And. !aNFitem[nX][IT_TIPONF ] $ "PI" )
	//�������������������������������������������������������������Ŀ
	//� Calculo da base de IPI.                                     �
	//���������������������������������������������������������������
	aNfItem[nX][IT_BASEIPI]	:= aNfItem[nX][IT_VALMERC]-aNfItem[nX][IT_DESCONTO]+aNfItem[nX][IT_DESCZF]
	If aTes[TS_DESPIPI] <> "N"
		aNfItem[nX][IT_BASEIPI] += aNfItem[nX][IT_DESPESA]
		aNfItem[nX][IT_BASEIPI] += aNfItem[nX][IT_SEGURO]
	EndIf
	If aTes[TS_IPIFRET] <> "N"
		aNfItem[nX][IT_BASEIPI] += aNfItem[nX][IT_FRETE]
	EndIf
	If ( aTes[TS_TPIPI]=="B" .Or. (MV_IPIBRUTO=="S" .And. aTes[TS_TPIPI] ==" ") )
		aNfItem[nX][IT_BASEIPI] += aNfItem[nX][IT_DESCONTO]
	EndIf
	//�������������������������������������������������������������Ŀ
	//� Salva a base de IPI original e aplica a reducao.            �
	//���������������������������������������������������������������
	aNfItem[nX][IT_BIPIORI]	:= MyNoRound(aNfItem[nX][IT_BASEIPI],2)

	If ( nReduzIPI <> 0 )
		aNfItem[nX][IT_BASEIPI] := MyNoRound(aNfItem[nX][IT_BASEIPI] * nReduzIPI /100,2)
	Else
		aNfItem[nX][IT_BASEIPI] := MyNoRound(aNfItem[nX][IT_BASEIPI],2)
	EndIf
Else
	aNfItem[nX][IT_BASEIPI]	:= 0
EndIf
//�������������������������������������������������������������Ŀ
//� Recupera a base de calculo anterior                         �
//���������������������������������������������������������������
If lBsOri
	aNfItem[nX][IT_BASEIPI] := nSalvaBase
EndIf
Return(Nil)
/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisBSIPI� Autor �Edson Maricate         � Data �08.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de calculo do valor do imposto sobre produtos industri���
���          �alizacos ( IPI ).                                            ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item do Array ANFItem que deve ser calculado          ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo calcular o valor do IPI confor-���
���          �me definido no Regulamento do IPI. O valor eh calculada para ���
���          �o IPI de pauta e para o IPI Normal.                          ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisVIPI(nX)

//�������������������������������������������������������������Ŀ
//� Posiciona os registros necessarios                          �
//���������������������������������������������������������������
dbSelectArea(cAliasPROD)
If aNfItem[nX][IT_RECNOSB1] <> 0 .And. cAliasPROD=="SB1"
	MsGoto(aNfItem[nX][IT_RECNOSB1])
Else
	dbSetOrder(1)
	MsSeek(xFilial(cAliasPROD)+aNfItem[nX][IT_PRODUTO])
EndIf
MaFisTes(aNfItem[nX][IT_TES],aNfItem[nX][IT_RECNOSF4],nX)
//�������������������������������������������������������������Ŀ
//� Calcula o valor do IPI                                      �
//���������������������������������������������������������������
If ( aTes[TS_IPI] <> "N" .And. aNFitem[nX][IT_TIPONF ]<>"I" )
	//�������������������������������������������������������������Ŀ
	//� Calculo do IPI Normal                                       �
	//���������������������������������������������������������������
	If aNFitem[nX][IT_TIPONF ] == "P" .Or. (MaSbCampo("VLR_IPI")==0 .And. (Empty(aNFitem[nX][IT_EXCECAO]) .Or. aNfItem[nX][IT_EXCECAO][9]==0))
		If aNFitem[nX][IT_TIPONF ] == "P"
			aNfItem[nX][IT_VALIPI]  := aNfItem[nX][IT_VALMERC]
		Else	
			If !GetNewPar("MV_RNDIPI",.F.)
				aNfItem[nX][IT_VALIPI]  := MyNoRound(aNfItem[nX][IT_BASEIPI]*aNfItem[nX][IT_ALIQIPI]/100,2)
			Else
				aNfItem[nX][IT_VALIPI]  := Round(aNfItem[nX][IT_BASEIPI]*aNfItem[nX][IT_ALIQIPI]/100,2)
			EndIf
			If aNFCab[NF_TIPONF] $ "DB" .OR. aTes[TS_PODER3] =="D"
				If !Empty(aNFItem[nX][IT_RECORI])
					If aNFCab[NF_TIPONF] $ "DB"				
						If ( aNFCab[NF_CLIFOR] == "C")
							dbSelectArea("SD2")
							MsGoto(aNFItem[nX][IT_RECORI])
							If Abs(aNfItem[nX][IT_VALIPI]-SD2->D2_VALIPI)<=1 .And. aNfItem[nX][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0														
								aNfItem[nX][IT_VALIPI] := SD2->D2_VALIPI
							EndIf
						Else
							dbSelectArea("SD1")
							MsGoto(aNFItem[nX][IT_RECORI])
							If Abs(aNfItem[nX][IT_VALIPI]-SD1->D1_VALIPI)<=1 .And. aNfItem[nX][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0														
								aNfItem[nX][IT_VALIPI] := SD1->D1_VALIPI
							EndIf
						EndIf
					Else
						If ( aNFCab[NF_CLIFOR] == "C")
							dbSelectArea("SD1")
							MsGoto(aNFItem[nX][IT_RECORI])
							If Abs(aNfItem[nX][IT_VALIPI]-SD1->D1_VALIPI)<=1 .And. aNfItem[nX][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0														
								aNfItem[nX][IT_VALIPI] := SD1->D1_VALIPI
							EndIf
						Else
							dbSelectArea("SD2")
							MsGoto(aNFItem[nX][IT_RECORI])
							If Abs(aNfItem[nX][IT_VALIPI]-SD2->D2_VALIPI)<=1 .And. aNfItem[nX][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0														
								aNfItem[nX][IT_VALIPI] := SD2->D2_VALIPI
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf			
		EndIf		
	Else
		//�������������������������������������������������������������Ŀ
		//� Calculo do IPI de Pauta                                     �
		//���������������������������������������������������������������	
		If !Empty(aNFitem[nX][IT_EXCECAO]) .And. aNfItem[nX][IT_EXCECAO][9]<>0
			aNfItem[nX][IT_VALIPI]  := aNfItem[nX][IT_QUANT]*aNfItem[nX][IT_EXCECAO][9]
		Else
			aNfItem[nX][IT_VALIPI]  := aNfItem[nX][IT_QUANT]*MaSbCampo("VLR_IPI")
		EndIf
		If !Empty(SuperGetMV("MV_IPIPFAT"))
			aNfItem[nX][IT_VALIPI] *= MaSBCampo(SubStr(SuperGetMV("MV_IPIPFAT"),4))
		EndIf
	EndIf
Else
	aNfItem[nX][IT_VALIPI]  :=	0
EndIf
//�������������������������������������������������������������Ŀ
//� Caso nao haja valor do IPI nao se deve ter base de calculo  �
//���������������������������������������������������������������
If aNfItem[nX][IT_VALIPI] == 0
	aNfItem[nX][IT_BASEIPI]	:= 0
EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisPRC� Autor � Edson Maricate          � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica o preco unitario do item                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisPRC(nItem)

If aNFitem[nItem][IT_TIPONF ]$"PIC" .And. (cPaisLoc == "BRA" .Or. aTES[TS_QTDZERO] == "1")
	aNfItem[nItem][IT_PRCUNI]  := aNfItem[nItem][IT_VALMERC]
EndIf

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqSol � Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo da Aliquota para operacoes de ICMS Solidario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Aliquota de ICMS Solidario                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1 : Item                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MaAliqSoli(nItem)

Local nAliquota := If ( MaSBCampo("PICM") == 0 , aNfItem[nItem][IT_ALIQICM] ,  MaSBCampo("PICM") )

If ( aNFCab[NF_UFORIGEM] <> aNFCab[NF_UFDEST] )
	If aNFCab[NF_TIPONF] == "D"
		nAliquota := MaAliqOrig(nItem)
	Else
		nAliquota := MaAliqDest(nItem)
	EndIf
EndIf

aNFitem[nItem][IT_ALIQSOL] := nAliquota

Return(nAliquota)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaMargem � Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo da Margem de lucro para calculo do ICMS Solidario.  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Margem de lucro.                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1 : Item                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MaMargem(nItem)

Local nMargem  := If ( aNfCab[NF_CLIFOR] =='F'  , MaSBCampo("PICMENT"), MaSBCampo("PICMRET") )

//�������������������������������������������������������������Ŀ
//� Verifica as Excecoes fiscais                                �
//���������������������������������������������������������������
If ( !Empty(aNFItem[nItem][IT_EXCECAO]) )
	If ( aNFItem[nItem][IT_EXCECAO][3] ) <> 0
		nMargem :=  aNFItem[nItem][IT_EXCECAO][3]   //Margem de Lucro Presumida
	EndIf
EndIf

aNFitem[nItem][IT_MARGEM] := nMargem

Return(nMargem)
/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisBSSol� Autor �Edson Maricate         � Data �08.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de calculo da base do imposto retido/solidario        ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item do Array ANFItem que deve ser calculado          ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo calcular a base do solidario   ���
���          �conforme definido no regulamento de ICMS.                    ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MATXFIS                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisBSSOL(nX)

Local nBsICMSt := 0
Local nMargem  := 0
Local lValido  := .T.
Local nReduzICMS := 0 

//�������������������������������������������������������������Ŀ
//� Carrega a reducao da base do ICMS                           �
//���������������������������������������������������������������
If !Empty(aNFitem[nX,IT_EXCECAO]) .And. aNfItem[nX,IT_EXCECAO,14] > 0
	nReduzICMS := aNfItem[nX,IT_EXCECAO,14]
Else 
	nReduzICMS := aTes[TS_BASEICM]
EndIf 	

//�������������������������������������������������������������Ŀ
//� Posiciona os registros necessarios                          �
//���������������������������������������������������������������
dbSelectArea(cAliasPROD)
If aNfItem[nX][IT_RECNOSB1] <> 0 .And. cAliasPROD=="SB1"
	MsGoto(aNfItem[nX][IT_RECNOSB1])
Else
	dbSetOrder(1)
	MsSeek(xFilial(cAliasPROD)+aNfItem[nX][IT_PRODUTO])
EndIf
MaFisTes(aNfItem[nX][IT_TES],aNfItem[nX][IT_RECNOSF4],nX)
//�������������������������������������������������������������Ŀ
//� Verifica se deve-se calcular o ICMS solidario               �
//���������������������������������������������������������������
If aTES[TS_MKPCMP]<>"1" .And. !(aNFitem[nX][IT_TIPONF ]$'IP') .And. IIf(aNfCab[NF_OPERNF]=="S".And.aNFCab[NF_CLIFOR] == "C",aNfCab[NF_TPCLIFOR]$SuperGetMV("MV_TPSOLCF"),.T.)

	If aNFCab[NF_TIPONF]$"DB"
		If !Empty(aNFItem[nX][IT_RECORI])			
			If ( aNFCab[NF_CLIFOR] == "C" )
				dbSelectArea("SD2")
				MsGoto( aNFItem[nX][IT_RECORI] )
				dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2")+(SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
					If SF2->F2_TIPOCLI$SuperGetMV("MV_TPSOLCF")
						lValido := .T.
					Else
						lValido := .F.
					EndIf
				Endif
			Else
				dbSelectArea("SD1")
				MsGoto( aNFItem[nX][IT_RECORI] )
				dbSelectArea("SF1")
				dbSetOrder(1)
				If MsSeek(xFilial("SF1")+(SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
					If SF1->F1_BRICMS > 0
						lValido := .T.
					Else
						lValido := .F.
					EndIf
				Endif
			Endif
		Endif
	EndIf

	If lValido	
		//�������������������������������������������������������������Ŀ
		//� Calculo do Solidario pela Margem de lucro                   �
		//���������������������������������������������������������������
		If MaSbCampo("VLR_ICM")==0 .And. (Empty(aNFitem[nX][IT_EXCECAO]) .Or. aNfItem[nX][IT_EXCECAO][8]==0)
			If aNfItem[nX][IT_MARGEM] > 0
				nMargem := aNfItem[nX][IT_MARGEM]
				aNfItem[nX][IT_BASESOL] := aNfItem[nX][IT_VALMERC]+aNfItem[nX][IT_VALIPI]+aNfItem[nX][IT_FRETE]
				If aTes[TS_DESPICM] <> "2" .Or. GetNewPar("MV_DESPICM",.T.)
					aNfItem[nX][IT_BASESOL] += 	aNfItem[nX][IT_SEGURO]+aNfItem[nX][IT_DESPESA]
				EndIf
				If aTes[TS_FRETAUT] == "2"
					aNfItem[nX][IT_BASESOL] += aNfItem[nX][IT_AUTONOMO]
				EndIf
				//�������������������������������������������������������������Ŀ
				//� Se nao calcular o ICMS Normal soma-lo na base de ICMS ST    �
				//���������������������������������������������������������������
				If aNfItem[nX][IT_VALICM] == 0 .And. aTES[TS_ICMSST] <> "2" .And. aNfItem[nX][IT_DESCZF] == 0
					aNfItem[nX][IT_BASESOL] /= (1 - (MaAliqIcms(nX,.T.)/100))
				EndIf
				
				If !MV_SOLBRUT .Or. aTes[TS_STDESC] == "1"
					aNfItem[nX][IT_BASESOL] -= aNfItem[nX][IT_DESCONTO]
				EndIf
				
				If !MV_DSZFSOL 
					aNfItem[nX][IT_BASESOL] += aNfItem[nX][IT_DESCZF]
				EndIf			

				//�������������������������������������������������������������Ŀ
				//� Operacoes de venda para consumidor final nao podem ter      �
				//� margem de lucro se o destino for para uso e consumo.        �
				//���������������������������������������������������������������
				If (( aTes[TS_CONSUMO]=="S" .And.;
						(	( aNfCab[NF_TPCLIFOR]=="F" .And. aNfCab[NF_CLIFOR]=="C" ) .Or. ( aNfCab[NF_CLIFOR]=="F" ) ) .And.;
						aNFCab[NF_UFORIGEM] <> aNFCab[NF_UFDEST] ) .OR. aTes[TS_MKPSOL]=="1") .And. aTES[TS_MKPSOL]<>"3"
					nMargem := 0
				EndIf
				If aTes[TS_INCSOL] <> "A"
					aNfItem[nX][IT_BASESOL] := aNfItem[nX][IT_BASESOL]*(1+(nMargem/100))
				EndIf
				If nReduzICMS > 0 .And. MV_BASERET =="S"
					aNfItem[nX][IT_BASESOL] := (aNfItem[nX][IT_BASESOL]*nReduzICMS)/100					
				EndIf
				If aTes[TS_BSICMST] > 0 .And. aTes[TS_INCSOL]<>'A'
					If aTes[TS_BSICMST] == 100
						aNfItem[nX][IT_BASESOL] := 0
					Else
						aNfItem[nX][IT_BASESOL] := (aNfItem[nX][IT_BASESOL]*aTes[TS_BSICMST])/100
					EndIf
				EndIf
			Else
				aNfItem[nX][IT_BASESOL]	:= 0
			EndIf
		Else
			If !Empty(aNFitem[nX][IT_EXCECAO]) .And. aNfItem[nX][IT_EXCECAO][8]<>0
				aNfItem[nX][IT_BASESOL] := aNfItem[nX][IT_QUANT]*aNfItem[nX][IT_EXCECAO][8]
			Else
				aNfItem[nX][IT_BASESOL] := aNfItem[nX][IT_QUANT]*MaSbCampo("VLR_ICM")
			EndIf
			If !Empty(SuperGetMV("MV_ICMPFAT"))
				aNfItem[nX][IT_BASESOL] *= MaSBCampo(SubStr(SuperGetMV("MV_ICMPFAT"),4))
			EndIf
			If GetNewPar("MV_ICPAUTA","1")=="2" //1=Sem Frete/Despesa/Seguro - 2=Com Frete/Despesa/Seguro
				aNfItem[nX][IT_BASESOL] += aNfItem[nX][IT_FRETE]+aNfItem[nX][IT_SEGURO]+aNfItem[nX][IT_DESPESA]
			EndIf			
			nBsICMSt := aNfItem[nX][IT_VALMERC]+aNfItem[nX][IT_VALIPI]+aNfItem[nX][IT_FRETE]+aNfItem[nX][IT_SEGURO]+aNfItem[nX][IT_DESPESA]
			If aTes[TS_FRETAUT] == "2"
				nBSICMSt += aNfItem[nX][IT_AUTONOMO]
			EndIf
			If !MV_SOLBRUT .Or. aTes[TS_STDESC] == "1"
				nBsICMSt -= aNfItem[nX][IT_DESCONTO]
			EndIf
			If !MV_DSZFSOL
				nBsICMSt += aNfItem[nX][IT_DESCZF]
				aNfItem[nX][IT_BASESOL] += aNfItem[nX][IT_DESCZF]
			EndIf                  
			If nReduzICMS > 0 .And. MV_BASERET =="S"
				nBsICMSt := (aNfItem[nX][IT_BASESOL]*nReduzICMS)/100
				aNfItem[nX][IT_BASESOL] := (aNfItem[nX][IT_BASESOL]*nReduzICMS)/100
			EndIf
			If aTes[TS_BSICMST] > 0
				If aTes[TS_BSICMST] == 100
					nBSICMSt := 0
					aNfItem[nX][IT_BASESOL] := 0
				Else
					nBsICMSt := (aNfItem[nX][IT_BASESOL]*aTes[TS_BSICMST])/100
					aNfItem[nX][IT_BASESOL] := (aNfItem[nX][IT_BASESOL]*aTes[TS_BSICMST])/100
				EndIf
			EndIf
			//�������������������������������������������������������������Ŀ
			//� Calculo do valor total para acertar o ICMS de Pauta         �
			//� A pauta nao pode ser menor que o valor comercializado       �
			//���������������������������������������������������������������	
			If !SuperGetMV("MV_ICMPAUT")
				If ( nBsICMSt > aNfItem[nX][IT_BASESOL] )
					aNfItem[nX][IT_BASESOL] := nBsICMSt
				EndIf
			EndIf
		EndIf
	Else		 
		aNfItem[nX][IT_BASESOL]	:= 0	
	EndIf
Else
	aNfItem[nX][IT_BASESOL]	:= 0
EndIf
Return(Nil)
/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisVSol � Autor �Edson Maricate         � Data �08.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de calculo do ICMS retido/solidario                   ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item do Array ANFItem que deve ser calculado          ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo calcular o valor do ICMS retido���
���          �/solidario conforme definido do regulamento de ICMS.         ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MATXFIS                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisVSOL(nItem)

If !(aNFitem[nItem][IT_TIPONF ]$'IP')
	If aNfItem[nItem][IT_BASESOL] <> 0
		MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)	
		If aTES[TS_INCSOL]=="A"
			aNfItem[nItem][IT_VALSOL] := ( aNfItem[nItem][IT_BASESOL]*(aNfItem[nItem][IT_MARGEM]/100) )
			aNfItem[nItem][IT_VALSOL] := ( aNfItem[nItem][IT_VALSOL] * aNfItem[nItem][IT_ALIQSOL]/100 )
			If aTes[TS_BSICMST] > 0
				aNfItem[nItem][IT_VALSOL] := (aNfItem[nItem][IT_VALSOL]*aTes[TS_BSICMST])/100
			EndIf
			aNfItem[nItem][IT_VALICM] -= Max(0,MyNoRound(aNfItem[nItem][IT_VALSOL]*aNfItem[nItem][IT_ALIQICM]/100,2))
		Else
			aNfItem[nItem][IT_VALSOL]	:= ( aNfItem[nItem][IT_BASESOL] * aNfItem[nItem][IT_ALIQSOL]/100 ) - MyNoRound(aNfItem[nItem][IT_VALICM],2) - aNfItem[nItem][IT_DESCZF]
		EndIf
		If aNFCab[NF_TIPONF] $ "DB" .OR. aTes[TS_PODER3] =="D"
			If !Empty(aNFItem[nItem][IT_RECORI])
				If aNFCab[NF_TIPONF] $ "DB"
					If ( aNFCab[NF_CLIFOR] == "C")
						dbSelectArea("SD2")
						MsGoto(aNFItem[nItem][IT_RECORI])
						If Abs(aNfItem[nItem][IT_VALSOL]-SD2->D2_ICMSRET)<=1 .And. aNfItem[nItem][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
							aNfItem[nItem][IT_VALSOL] := SD2->D2_ICMSRET
						EndIf
					Else
						dbSelectArea("SD1")
						MsGoto(aNFItem[nItem][IT_RECORI])
						If Abs(aNfItem[nItem][IT_VALSOL]-SD1->D1_ICMSRET)<=1 .And. aNfItem[nItem][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
							aNfItem[nItem][IT_VALSOL] := SD1->D1_ICMSRET
						EndIf
					EndIf
				Else
					If ( aNFCab[NF_CLIFOR] == "C")
						dbSelectArea("SD1")
						MsGoto(aNFItem[nItem][IT_RECORI])
						If Abs(aNfItem[nItem][IT_VALSOL]-SD1->D1_ICMSRET)<=1 .And. aNfItem[nItem][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
							aNfItem[nItem][IT_VALSOL] := SD1->D1_ICMSRET
						EndIf
					Else
						dbSelectArea("SD2")
						MsGoto(aNFItem[nItem][IT_RECORI])
						If Abs(aNfItem[nItem][IT_VALSOL]-SD2->D2_ICMSRET)<=1 .And. aNfItem[nItem][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
							aNfItem[nItem][IT_VALSOL] := SD2->D2_ICMSRET
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf				

		If aNfItem[nItem][IT_VALSOL]<0 .And. aNfItem[nItem][IT_BASESOL]>0
			aNfItem[nItem][IT_VALSOL]	:= 	0
		EndIf		
	Else
		aNfItem[nItem][IT_VALSOL]	:= 	0
	EndIf
EndIf
//�������������������������������������������������������������Ŀ
//� Caso nao haja valor de ICMS solidario deve-se zerar a base  �
//� de calculo do ICMS-ST                                       �
//���������������������������������������������������������������
If aNfItem[nItem][IT_VALSOL] == 0
	aNfItem[nItem][IT_BASESOL]	:= 0
EndIf
MaItArred(nItem,{"IT_VALSOL"})
Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaALIQCMP � Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo da aliquota do ICMS complementar.         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaALIQCMP(nItem)

Local nAliquota	:= aNfItem[nItem][IT_ALIQICM]

If ( aNFCab[NF_UFORIGEM] <> aNFCab[NF_UFDEST] )
	If ( aNFCab[NF_TIPONF] == "D" ) // devolucao
		nAliquota := Iif (MaSBCampo("PICM") <> 0,MaSBCampo("PICM"),MaAliqOrig(nItem))
	Else
		nAliquota := Iif (MaSBCampo("PICM") <> 0,MaSBCampo("PICM"),MaAliqDest(nItem))
	EndIf
EndIf

aNfItem[nItem][IT_ALIQCMP]	:= nAliquota

Return nAliquota

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVComp� Autor � Edson Maricate        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo do ICMS Complementar.                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVComp(nItem)

Local nMargem := 0
Local nBase   := 0        
Local nReduzICMS := 0

//�������������������������������������������������������������Ŀ
//� Carrega a reducao da base do ICMS                           �
//���������������������������������������������������������������

If !Empty(aNFitem[nItem,IT_EXCECAO]) .And. aNfItem[nItem,IT_EXCECAO,14] > 0
	nReduzICMS := aNfItem[nItem,IT_EXCECAO,14]
Else 
	nReduzICMS := aTes[TS_BASEICM]
EndIf 	

aNfItem[nItem][IT_VALCMP] := 0

If aTes[TS_COMPL] == "S" 
	If aTes[TS_MKPCMP]=="1"
		//�������������������������������������������������������������Ŀ
		//� Calculo do ICMS Complementar por margem de lucro            �
		//���������������������������������������������������������������
		If aNfItem[nItem][IT_MARGEM] > 0
			nMargem := aNfItem[nItem][IT_MARGEM]
			nBase   := aNfItem[nItem][IT_VALMERC]+aNfItem[nItem][IT_VALIPI]+aNfItem[nItem][IT_FRETE]+aNfItem[nItem][IT_SEGURO]+aNfItem[nItem][IT_DESPESA]
			nBase   -= aNfItem[nItem][IT_DESCONTO]
			//�������������������������������������������������������������Ŀ
			//� Operacoes de venda para consumidor final nao podem ter      �
			//� margem de lucro se o destino for para uso e consumo.        �
			//���������������������������������������������������������������
			If aTes[TS_CONSUMO]=="S" .And.;
					(	( aNfCab[NF_TPCLIFOR]=="F" .And. aNfCab[NF_CLIFOR]=="C" ) .Or.;
					( aNfCab[NF_CLIFOR]=="F" ) ) .And.;
					aNFCab[NF_UFORIGEM] <> aNFCab[NF_UFDEST]
				nMargem := 0
			EndIf
			If nReduzICMS > 0 .And. GetNewPar("MV_BICMCMP",.T.)
				nBase := (nBase*nReduzICMS)/100
			EndIf
			If nMargem > 0
				nBase := nBase*(1+(nMargem/100))
			EndIf
			aNfItem[nItem][IT_VALCMP] := (nBase*(aNfItem[nItem][IT_ALIQCMP]/100)) - aNfItem[nItem][IT_VALICM]
		Else
			aNfItem[nItem][IT_VALCMP]	:= 0
		EndIf
	Else
		If ( aNFCab[NF_UFORIGEM] <> aNFCab[NF_UFDEST] ) .And. aNFCab[NF_TPCLIFOR] <> "X"
			If GetNewPar("MV_BICMCMP",.T.)
				aNfItem[nItem][IT_VALCMP] := (aNfItem[nItem][IT_BASEICM]*(aNfItem[nItem][IT_ALIQCMP]/100)) - aNfItem[nItem][IT_VALICM]
			Else
				aNfItem[nItem][IT_VALCMP] := (aNfItem[nItem][IT_BICMORI]*(aNfItem[nItem][IT_ALIQCMP]/100)) - aNfItem[nItem][IT_VALICM]
			EndIf
		EndIf
	EndIf
EndIf
aNfItem[nItem][IT_VALCMP] := Max(0,aNfItem[nItem][IT_VALCMP])
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqOrig� Autor � Edson Maricate        � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo da Aliquota para operacoes de ICMS                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Aliquota de ICMS                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1 : Item                                                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaAliqOrig(nItem)

Local nPerIcm
Local cOrig := aNFCab[NF_UFORIGEM]

nPerIcm := Val(Subs(MV_ESTICM,AT(cOrig,MV_ESTICM)+2,2))

Return(nPerIcm)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVDescZF� Autor � Edson Maricate      � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo do Valor do Desconto da ZF.               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVDescZF(nItem)

If aNfCab[NF_CLIFOR]=='C'.And.aNfCab[NF_SUFRAMA].And.!aNFitem[nItem][IT_TIPONF ]$'BD'.And.;
		!aNfCab[NF_LINSCR].And.MaSBCampo("IMPZFRC")$" N" .And. aTes[TS_ISS]<>"S" .And. ;
		aTes[TS_ICM]=="S" .And. !MaFisConsumo(nItem) .And. GetNewPar("MV_DESCZF",.T.)
	//������������������������������������������������������������Ŀ
	//� Tratamento para SUFRAMA apenas para NF de Saida MATA461    �
	//� Este tratamento nao deve ser utilizado nas NF que serao    �
	//� digitadas pelo usuario ( MATA103/MATA910/MATA920/etc.)     �
	//��������������������������������������������������������������
	If aNfCab[NF_ROTINA] == 'MATA461'
		aNfItem[nItem][IT_VALMERC] += aNfItem[nItem][IT_DESCZF]
		aNfItem[nItem][IT_VALMERC] -= MyNoRound(aNfItem[nItem][IT_VALICM],2)
		aNfItem[nItem][IT_PRCUNI]  := (aNfItem[nItem][IT_VALMERC]-aNfItem[nItem][IT_DESCONTO])/aNfItem[nItem][IT_QUANT]
	EndIf
	aNfItem[nItem][IT_DESCZFCOF] := 0
	aNfItem[nItem][IT_DESCZFPIS] := 0
	aNfItem[nItem][IT_DESCZF]  := MyNoRound(aNfItem[nItem][IT_VALICM],2)
	aNfItem[nItem][IT_VALICM]  := 0
	aNfItem[nItem][IT_BASEICM] := 0
Else
	aNfItem[nItem][IT_DESCZF] := 0
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaFisCFO � Autor � Edson Maricate        � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Processa o Codigo Fiscal do item especificado               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpC1 := MaFisCFO(ExpN1,ExpC2,[ExpA1])                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                 ���
���          �ExpC2: Codigo Fiscal Original ( Opcional )                  ���
���          �ExpA1: Array de parametros opcional a ser enviado quando    ���
���          �a funcao e chamada de fora da matxfis. Estrutura:           ���
���          �  1 - Identificador do parametro ( mnemonico )              ���
���          �  2 - Conteudo                                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpC1: Codigo Fiscal de Operacao                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisCFO(nItem,cAuxCF,aDados)
Local cCfo	:= IIf(cAuxCF==Nil,aTes[TS_CF],cAuxCF)
Local cRetCF:= ""

Local cOperNf   := ""
Local cTpCliFor := ""
Local cUfOrigem := ""
Local cUfDest   := ""
Local cTpComp   := ""
Local cInscri   := ""
Local cRestoCfo := "" 

Local lInscrito := .T. 

Local nLoop     := 0
Local lUsaCfps	:= GetNewPar("MV_USACFPS",.F.)

If ValType( aDados ) == "A"
	cUfOrigem   := SuperGetMv("MV_ESTADO")
	cUfDest     := SuperGetMv("MV_ESTADO")
	For nLoop := 1 To Len( aDados )
		Do Case
		Case aDados[ nLoop, 1 ] == "OPERNF"
			cOperNF   := aDados[ nLoop, 2 ]		
		Case aDados[ nLoop, 1 ] == "TPCLIFOR"
			cTpCliFor := aDados[ nLoop, 2 ]				
		Case aDados[ nLoop, 1 ] == "UFORIGEM"
			cUfOrigem := aDados[ nLoop, 2 ]
		Case aDados[ nLoop, 1 ] == "UFDEST"
			cUfDest   := aDados[ nLoop, 2 ]
		Case aDados[ nLoop, 1 ] == "TPCOMP"					
			cTpComp   := aDados[ nLoop, 2 ]	
		Case aDados[ nLoop, 1 ] == "INSCR"
 			cInscri   := aDados[ nLoop, 2 ]
 			lInscrito := !(Empty(cInscri).Or."ISENT" $ cInscri)
		EndCase	
	Next nLoop

Else	
	cOperNf     := aNfCab[NF_OPERNF]
	cTpCliFor   := aNfCab[NF_TPCLIFOR]
	cUfOrigem   := aNfCab[NF_UFORIGEM]
	cUfDest     := aNfCab[NF_UFDEST]
	cTpComp     := aNfCab[NF_TPCOMP]
	lInscrito   := !( aNfCab[NF_LINSCR] ) 	
EndIf 

cRestoCfo := SubStr(cCfo,2,Len(cCfo)-1)

If cPaisLoc=="BRA"
	If SubStr(cCfo,1,3) == "999" .Or. SubStr(cCfo,1,3) == "000" .Or. SubStr(cCfo,1,4) $ "1601#1602#5601#5602"
		cRetCF := cCfo
	Else
		If cOperNf == "E"
			If cUfOrigem == "EX" .Or. cTpCliFor == "X"
				cRetCF := "3"
			Else
				If cUfOrigem == SuperGetMv("MV_ESTADO")
					cRetCF := "1"
				Else
					cRetCF := "2"
				EndIf
			EndIf
		Else
			If cUfDest == cUfOrigem .And. cTpCliFor <> "X"
				cRetCF := "5"
				If GetNewPar( "MV_CONVCFO", "1" ) == "1"
				//������������������������������������������������������������Ŀ
				//� Caso seja operacao com consumidor final troca a terminacao �
				//� do CFOP                                                    �				
				//��������������������������������������������������������������					
				If (cTpCliFor == "F" .Or. !lInscrito) .And. AllTrim( cRestoCfo ) == "655"
						cRestoCfo := "656" + Space( Len( cRestoCfo ) - 3 )
					EndIf
				EndIf
			ElseIf cTpCliFor <> "X"
				//������������������������������������������������������������Ŀ
				//� Conversao do CFO interestadual                             �
				//��������������������������������������������������������������
				cRetCF := "6"			
				If GetNewPar( "MV_CONVCFO", "1" ) == "1"
					If !lInscrito
						If AllTrim( cRestoCfo ) == "102"
							//������������������������������������������������������������Ŀ
							//� Caso seja operacao interestadual para nao inscritos        �
							//� altera o final do CFO de 102 para 108                      �				
							//��������������������������������������������������������������
							cRestoCfo := "108" + Space( Len( cRestoCfo ) - 3 )
						ElseIf AllTrim( cRestoCfo ) == "101"
							//������������������������������������������������������������Ŀ
							//� Caso seja operacao interestadual para nao inscritos        �
							//� altera o final do CFO de 101 para 107                      �				
							//��������������������������������������������������������������
							cRestoCfo := "107" + Space( Len( cRestoCfo ) - 3 )
						EndIf
					EndIf
					//������������������������������������������������������������Ŀ
					//� Caso seja operacao com consumidor final troca a terminacao �
					//� do CFOP                                                    �				
					//��������������������������������������������������������������
					If (cTpCliFor == "F" .Or. !lInscrito) .And. AllTrim( cRestoCfo ) == "655"
						cRestoCfo := "656" + Space( Len( cRestoCfo ) - 3 )
					EndIf
				EndIf
			Else
				cRetCF := "7"
			EndIf
		EndIf
		//������������������������������������������������������������Ŀ
		//� Tratamento para Complemento de Frete                       �
		//��������������������������������������������������������������
		If cTpComp == "F" .And. GetNewPar( "MV_CONVCFO", "1" ) == "1"
			cRetCF += IIf(SubStr(cCfo,2,3)$"931/932/933/351/352/353/354/355/356",SubStr(cCfo,2,3),"352")	
		Else
			cRetCF += cRestoCfo 
		EndIf
	EndIf
	//������������������������������������������������������������Ŀ
	//� Ajuste do CFO para fora do estado quando for 4 digitos     �
	//��������������������������������������������������������������
	If Left(cRetCf,4) == "6405" .And. GetNewPar( "MV_CONVCFO", "1" ) == "1"
		cRetCf := "6404"+SubStr(cRetCf,5)
	EndIf
	If lUsaCfps .And. Left(LTrim(cCfo),1)=="9"
		cRetCf := "9"+cRestoCfo 
	EndIf
	//������������������������������������������������������������Ŀ
	//� Verifica os CFOPS de Importacao e Exportacao.              �
	//��������������������������������������������������������������
	If SubStr(cRetCF,1,2) == "79"
		SX5->(dbSetOrder(1))
		If !SX5->(MsSeek(xFilial("SX5")+"13"+cRetCF))
			cRetCf := "7949"
		EndIf
	EndIf
	
Else
	cRetCF:=Alltrim(cCfo)
EndIf

If ValType( aDados ) <> "A"
	aNfItem[nItem][IT_CF]	:= PadR(cRetCF,Len(SF4->F4_CF))
Endif	

Return ( cRetCF )

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisIniLo� Autor �Edson Maricate         � Data �13.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina atualizacao dos dados do Cabecalho da funcao fiscal   ���
���          �aNfCab com base em um item da funcao fiscal aNfItem          ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item do Array ANFItem que deve ser inicializado       ���
���          �ExpL2: Indica se eh inclusao (.T.)ou estorno(.F.)       (OPC)���
���          �ExpC3: Campo a ser atualizado                           (OPC)���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo atualizar a variavel aNfCab com���
���          �base nos itens da funcao fiscal                              ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisSomaIt(nX,lSoma,cCampo)

Local nY := 0
Local nG := 0
DEFAULT lSoma := .T.

If !aNfItem[nX][IT_DELETED]
	If lSoma
		//������������������������������������������������������������Ŀ
		//� Atualiza os campos totalizadores.                          �
		//��������������������������������������������������������������
		aNfCab[NF_DESCONTO]	+= aNfItem[nX][IT_DESCONTO]
		aNfCab[NF_FRETE]	+= aNfItem[nX][IT_FRETE]
		aNfCab[NF_DESPESA]	+= aNfItem[nX][IT_DESPESA]
		aNfCab[NF_SEGURO]	+= aNfItem[nX][IT_SEGURO]
		aNfCab[NF_AUTONOMO]	+= aNfItem[nX][IT_AUTONOMO]
		aNfCab[NF_BASEICM]	+= aNfItem[nX][IT_BASEICM]
		aNfCab[NF_VALICM]	+= aNfItem[nX][IT_VALICM]
		aNfCab[NF_BASESOL]	+= aNfItem[nX][IT_BASESOL]
		aNfCab[NF_VALSOL]	+= aNfItem[nX][IT_VALSOL]
		aNfCab[NF_BICMORI]	+= aNfItem[nX][IT_BICMORI]
		aNfCab[NF_VALCMP]	+= aNfItem[nX][IT_VALCMP]
		aNfCab[NF_BASEIPI]	+= aNfItem[nX][IT_BASEIPI]
		aNfCab[NF_BIPIORI]	+= aNfitem[nX][IT_BIPIORI]
		aNfCab[NF_VALIPI]	+= aNfItem[nX][IT_VALIPI]
		aNfCab[NF_TOTAL]	+= aNfItem[nX][IT_TOTAL]
		aNfCab[NF_VALMERC]	+= aNfItem[nX][IT_VALMERC]-aNfItem[nX][IT_VNAGREG]
		aNfCab[NF_VNAGREG]  += aNfItem[nX][IT_VNAGREG]
		aNfCab[NF_FUNRURAL]	+= aNfItem[nX][IT_FUNRURAL]
		aNfCab[NF_BASEIRR]	+= aNfItem[nX][IT_BASEIRR]
		aNfCab[NF_VALIRR]	+= aNfItem[nX][IT_VALIRR]
		aNfCab[NF_BASEINS]	+= aNfItem[nX][IT_BASEINS]
		aNfCab[NF_VALINS]	+= aNfItem[nX][IT_VALINS]
		aNfCab[NF_BASEISS]	+= aNfItem[nX][IT_BASEISS]
		aNfCab[NF_VALISS]	+= aNfItem[nX][IT_VALISS]
		aNfCab[NF_BASEDUP]	+= aNfItem[nX][IT_BASEDUP]
		aNfCab[NF_DESCZF]	+= aNfItem[nX][IT_DESCZF]
		aNfCab[NF_PESO]		+= aNfItem[nX][IT_PESO]
		aNfCab[NF_ICMFRETE]	+= aNfItem[nX][IT_ICMFRETE]
		aNfCab[NF_BSFRETE]	+= aNfItem[nX][IT_BSFRETE]
		aNfCab[NF_BASEICA]	+= aNfItem[nX][IT_BASEICA]
		aNfCab[NF_VALICA]	+= aNfItem[nX][IT_VALICA]
		aNfCab[NF_BASECOF]	+= aNfItem[nX][IT_BASECOF]
		aNfCab[NF_VALCOF]	+= aNfItem[nX][IT_VALCOF]
		aNfCab[NF_BASEPIS]	+= aNfItem[nX][IT_BASEPIS]
		aNfCab[NF_VALPIS]	+= aNfItem[nX][IT_VALPIS]
		aNfCab[NF_BASEPS2] += aNfItem[nX][IT_BASEPS2]
		aNfCab[NF_VALPS2]  += aNfItem[nX][IT_VALPS2]
		aNfCab[NF_BASECF2] += aNfItem[nX][IT_BASECF2]
		aNfCab[NF_VALCF2]  += aNfItem[nX][IT_VALCF2]		
		aNfCab[NF_BASECSL]	+= aNfItem[nX][IT_BASECSL]
		aNfCab[NF_VALCSL]	+= aNfItem[nX][IT_VALCSL]
		For nG:=1 To NMAXIV
			aNfCab[NF_BASEIMP][nG] += aNfItem[nX][IT_BASEIMP][nG]
			aNfCab[NF_VALIMP][nG]  += aNfItem[nX][IT_VALIMP][nG]
		Next
		aNfCab[NF_ICMSDIF]		+= aNfItem[nX][IT_ICMSDIF]
		aNfCab[NF_BASEAFRMM]	+= aNfItem[nX][IT_BASEAFRMM]
		aNfCab[NF_VALAFRMM] 	+= aNfItem[nX][IT_VALAFRMM]		
	Else
		//������������������������������������������������������������Ŀ
		//� Atualiza os campos totalizadores.                          �
		//��������������������������������������������������������������
		aNfCab[NF_DESCONTO]	-= aNfItem[nX][IT_DESCONTO]
		aNfCab[NF_FRETE]	-= aNfItem[nX][IT_FRETE]
		aNfCab[NF_DESPESA]	-= aNfItem[nX][IT_DESPESA]
		aNfCab[NF_SEGURO]	-= aNfItem[nX][IT_SEGURO]
		aNfCab[NF_AUTONOMO]	-= aNfItem[nX][IT_AUTONOMO]
		aNfCab[NF_BASEICM]	-= aNfItem[nX][IT_BASEICM]
		aNfCab[NF_VALICM]	-= aNfItem[nX][IT_VALICM]
		aNfCab[NF_BASESOL]	-= aNfItem[nX][IT_BASESOL]
		aNfCab[NF_VALSOL]	-= aNfItem[nX][IT_VALSOL]
		aNfCab[NF_BICMORI]	-= aNfItem[nX][IT_BICMORI]
		aNfCab[NF_VALCMP]	-= aNfItem[nX][IT_VALCMP]
		aNfCab[NF_BASEIPI]	-= aNfItem[nX][IT_BASEIPI]
		aNfCab[NF_BIPIORI]	-= aNfitem[nX][IT_BIPIORI]
		aNfCab[NF_VALIPI]	-= aNfItem[nX][IT_VALIPI]
		aNfCab[NF_TOTAL]	-= aNfItem[nX][IT_TOTAL]
		aNfCab[NF_VALMERC]	-= aNfItem[nX][IT_VALMERC]-aNfItem[nX][IT_VNAGREG]
		aNfCab[NF_VNAGREG] -= aNfItem[nX][IT_VNAGREG]
		aNfCab[NF_FUNRURAL]	-= aNfItem[nX][IT_FUNRURAL]
		aNfCab[NF_BASEIRR]	-= aNfItem[nX][IT_BASEIRR]
		aNfCab[NF_VALIRR]	-= aNfItem[nX][IT_VALIRR]
		aNfCab[NF_BASEINS]	-= aNfItem[nX][IT_BASEINS]
		aNfCab[NF_VALINS]	-= aNfItem[nX][IT_VALINS]
		aNfCab[NF_BASEISS]	-= aNfItem[nX][IT_BASEISS]
		aNfCab[NF_VALISS]	-= aNfItem[nX][IT_VALISS]
		aNfCab[NF_BASEDUP]	-= aNfItem[nX][IT_BASEDUP]
		aNfCab[NF_DESCZF]	-= aNfItem[nX][IT_DESCZF]
		aNfCab[NF_PESO]		-= aNfItem[nX][IT_PESO]
		aNfCab[NF_ICMFRETE]	-= aNfItem[nX][IT_ICMFRETE]
		aNfCab[NF_BSFRETE]	-= aNfItem[nX][IT_BSFRETE]
		aNfCab[NF_BASEICA]	-= aNfItem[nX][IT_BASEICA]
		aNfCab[NF_VALICA]	-= aNfItem[nX][IT_VALICA]
		aNfCab[NF_BASECOF]	-= aNfItem[nX][IT_BASECOF]
		aNfCab[NF_VALCOF]	-= aNfItem[nX][IT_VALCOF]
		aNfCab[NF_BASEPIS]	-= aNfItem[nX][IT_BASEPIS]
		aNfCab[NF_VALPIS]	-= aNfItem[nX][IT_VALPIS]
		aNfCab[NF_BASEPS2] -= aNfItem[nX][IT_BASEPS2]
		aNfCab[NF_VALPS2]  -= aNfItem[nX][IT_VALPS2]		
		aNfCab[NF_BASECF2] -= aNfItem[nX][IT_BASECF2]
		aNfCab[NF_VALCF2]  -= aNfItem[nX][IT_VALCF2]		
		aNfCab[NF_BASECSL]	-= aNfItem[nX][IT_BASECSL]
		aNfCab[NF_VALCSL]	-= aNfItem[nX][IT_VALCSL]
		For nG:=1 To NMAXIV
			aNfCab[NF_BASEIMP][nG] -= aNfItem[nX][IT_BASEIMP][nG]
			aNfCab[NF_VALIMP][nG]  -= aNfItem[nX][IT_VALIMP][nG]
		Next
		If cPaisLoc <> "BRA" .And. cCampo=="IT_DESCONTO" .And. aNfCab[NF_OPERNF] =='S' .And. SuperGetMV('MV_DESCSAI') =='1'
			aNFitem[nX][IT_VALMERC] +=	aNFitem[nX][IT_DESCONTO]
			aNFitem[nX][IT_PRCUNI]  :=	aNFitem[nX][IT_VALMERC]/Max(aNFitem[nX][IT_QUANT],1)
		EndIf
		aNfCab[NF_ICMSDIF]		-= aNfItem[nX][IT_ICMSDIF]
		aNfCab[NF_BASEAFRMM]	-= aNfItem[nX][IT_BASEAFRMM]
		aNfCab[NF_VALAFRMM] 	-= aNfItem[nX][IT_VALAFRMM]				
	EndIf
	//�������������������������������������������������������������������������������Ŀ
	//�Inclui a linha para inclusao de Impostos.                                      �
	//���������������������������������������������������������������������������������
	If aNfCab[NF_INSIMP]
		If aScan(aNfCab[NF_IMPOSTOS],{|x| x[6] == "NEW"  }) == 0
			aadd(aNfCab[NF_IMPOSTOS],{'...','  ',0,0,0,'NEW'})
		EndIf
		If aScan(aNfCab[NF_IMPOSTOS2],{|x| x[5] == "NEW"  }) == 0
			aadd(aNfCab[NF_IMPOSTOS2],{'...','  ',0,0,'NEW'})
		EndIf
	EndIf
	//�������������������������������������������������������������������������������Ŀ
	//� Montagem do array NF_IMPOSTOS contando o rodape e todos os impostos calculados�
	//� ICMS,IPI,INSS,ICMS RETIDO,ICMS COMP,ISS,IR    Impostos Argentina,Chile,Etc    �
	//���������������������������������������������������������������������������������
	If cPaisLoc == "BRA"
		If (aNfItem[nX][IT_BASEICM]<>0 .Or. aNfItem[nX][IT_VALICM]<>0) .And. aNfItem[nX][IT_VALISS] == 0
			MaFisResumo(aNfItem[nX][IT_BASEICM],aNfItem[nX][IT_ALIQICM],aNfItem[nX][IT_VALICM],;
				'ICM','ICMS','ICM',,,lSoma)
		EndIf
		If aNfItem[nX][IT_BASEIPI]<>0 .Or. aNfItem[nX][IT_VALIPI]<>0
			MaFisResumo(aNfItem[nX][IT_BASEIPI],aNfItem[nX][IT_ALIQIPI],aNfItem[nX][IT_VALIPI],;
				'IPI','IPI ','IPI',,,lSoma)
		EndIf
		If aNfItem[nX][IT_BASEICA]<>0 .Or. aNfItem[nX][IT_VALICA]<>0
			MaFisResumo(aNfItem[nX][IT_BASEICA],aNfItem[nX][IT_ALIQICM],aNfItem[nX][IT_VALICA],;
				'ICA','ICMS ref. Frete Autonomo','ICA',,,lSoma)
		EndIf
		If aNfItem[nX][IT_BASESOL]<>0 .Or. aNfItem[nX][IT_VALSOL]<>0
			MaFisResumo(aNfItem[nX][IT_BASESOL],aNfItem[nX][IT_ALIQSOL],aNfItem[nX][IT_VALSOL],;
				'ICR','ICMS Retido ','SOL',,,lSoma)
		EndIf
		If aNfItem[nX][IT_VALCMP]<>0
			MaFisResumo(aNfItem[nX][IT_BASEICM],aNfItem[nX][IT_ALIQCMP],aNfItem[nX][IT_VALCMP],;
				'ICC','ICMS Complementar ','CMP',,,lSoma)
		EndIf
		If aNfItem[nX][IT_BASEISS]<>0 .Or. aNfItem[nX][IT_VALISS]<>0
			MaFisResumo(aNfItem[nX][IT_BASEISS],aNfItem[nX][IT_ALIQISS],aNfItem[nX][IT_VALISS],;
				'ISS','ISS Imposto sobre servico ','ISS',,,lSoma)
		EndIf
		If aNfItem[nX][IT_BASEIRR]<>0 .Or. aNfItem[nX][IT_VALIRR]<>0
			MaFisResumo(aNfItem[nX][IT_BASEIRR],aNfItem[nX][IT_ALIQIRR],aNfItem[nX][IT_VALIRR],;
				'IRR','IRRF Imposto de renda ','IRR',,,lSoma)
		EndIf
		If aNfItem[nX][IT_BASEINS]<>0 .Or. aNfItem[nX][IT_VALINS]<>0
			MaFisResumo(aNfItem[nX][IT_BASEINS],aNfItem[nX][IT_ALIQINS],aNfItem[nX][IT_VALINS],;
				'INS','INSS ','INS',,,lSoma)
		EndIf
		If aNfItem[nX][IT_BASECOF]<>0 .Or. aNfItem[nX][IT_VALCOF]<>0
			MaFisResumo(aNfItem[nX][IT_BASECOF],aNfItem[nX][IT_ALIQCOF],aNfItem[nX][IT_VALCOF],;
				'COF','COFINS - Via Reten��o','COF',.T.,.T.,lSoma)
		EndIf
		If aNfItem[nX][IT_BASECSL]<>0 .Or. aNfItem[nX][IT_VALCSL]<>0
			MaFisResumo(aNfItem[nX][IT_BASECSL],aNfItem[nX][IT_ALIQCSL],aNfItem[nX][IT_VALCSL],;
				'CSL','CSLL - Via Reten��o','CSL',.T.,.T.,lSoma)
		EndIf
		If aNfItem[nX][IT_BASEPIS]<>0 .Or. aNfItem[nX][IT_VALPIS]<>0
			MaFisResumo(aNfItem[nX][IT_BASEPIS],aNfItem[nX][IT_ALIQPIS],aNfItem[nX][IT_VALPIS],;
				'PIS','PIS - Via Reten�ao','PIS',.T.,.T.,lSoma)
		EndIf
		If aNfItem[nX][IT_FUNRURAL]<>0
			MaFisResumo(0,aNfItem[nX][IT_PERFUN],aNfItem[nX][IT_FUNRURAL],;
				'FRU','FUNRURAL ','RUR',.T.,,lSoma)
		EndIf
		If aNfItem[nx][IT_BASEPS2]<>0 .Or. aNfItem[nx][IT_VALPS2]<>0
			MaFisResumo(aNfItem[nx][IT_BASEPS2],aNfItem[nx][IT_ALIQPS2],aNfItem[nx][IT_VALPS2],;
				'PS2','PIS/Pasep - Via apuracao','PS2',,,lSoma)
		EndIf
		If aNfItem[nx][IT_BASECF2]<>0 .Or. aNfItem[nx][IT_VALCF2]<>0
			MaFisResumo(aNfItem[nx][IT_BASECF2],aNfItem[nx][IT_ALIQCF2],aNfItem[nx][IT_VALCF2],;
				'CF2','COFINS - Via apuracao','CF2',,,lSoma)
		EndIf
		If aNfItem[nx][IT_BASEAFRMM]<>0 .Or. aNfItem[nx][IT_VALAFRMM]<>0
			MaFisResumo(aNfItem[nx][IT_BASEAFRMM],aNfItem[nx][IT_ALIQAFRMM],aNfItem[nx][IT_VALAFRMM],;
				'AFRMM','AFRMM','AFRMM',,,lSoma)
		EndIf
	Endif
	For nG:=1 To NMAXIV
		If aNfItem[nX][IT_BASEIMP][nG]<>0 .Or. aNfItem[nX][IT_VALIMP][nG]<>0
			MaFisResumo(aNfItem[nX][IT_BASEIMP][nG],aNfItem[nX][IT_ALIQIMP][nG],aNfItem[nX][IT_VALIMP][nG],;
				aNfItem[nX][IT_DESCIV][nG][1],aNfItem[nX][IT_DESCIV][nG][2],"IV"+NumCpoImpVar(nG),,,lSoma)
		EndIf
	Next

	MaFisLFToLivro(nX,@aAuxOri,lSoma)
	If !lSoma
		//������������������������������������������������������������Ŀ
		//� Executa a correcao nos arredondamentos.                    �
		//��������������������������������������������������������������
		For nY := 1 to Len(aItemRef)
			If aItemRef[nY][4]
				If ValType(aItemRef[nY][2]) == "A"
					If aItemDec[nX][1][nY]<>0
						aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] -= aItemDec[nX][1][nY]
						If !(!Empty(cCampo) .And. cCampo == aItemRef[nY][1])
							aSaveDec[nY] += aItemDec[nX][1][nY]
						EndIf
					Else
						aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] += aItemDec[nX][2][nY]
						aSaveDec[nY] -= aItemDec[nX][2][nY]
					EndIf
					aItemDec[nX][1][nY]:= 0
					aItemDec[nX][2][nY]:= 0
				Else
					If aItemDec[nX][1][nY]<>0
						aNfItem[nX][Val(aItemRef[nY][2])] -= aItemDec[nX][1][nY]
						If !(!Empty(cCampo) .And. cCampo == aItemRef[nY][1])
							aSaveDec[nY] += aItemDec[nX][1][nY]
						EndIf

					Else
						aNfItem[nX][Val(aItemRef[nY][2])] += aItemDec[nX][2][nY]
						aSaveDec[nY] -= aItemDec[nX][2][nY]
					EndIf
					aItemDec[nX][1][nY]:= 0
					aItemDec[nX][2][nY]:= 0
				EndIf
			EndIf
		Next nY
	EndIf
EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaIt2Cab � Autor � Edson Maricate        � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza os valores totais do cabecalho da NF              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaIt2Cab(nItemNao)
Local nX    := 0
Local nY    := 0
Local nLF	:= 0

DEFAULT nItemNao	:=	0

aAuxOri				:= {}
aNfCab[NF_DESCONTO]	:= 0
aNfCab[NF_FRETE]	:= 0
aNfCab[NF_DESPESA]	:= 0
aNfCab[NF_SEGURO]	:= 0
aNfCab[NF_AUTONOMO]	:= 0
aNfCab[NF_ICMS]		:= {0,0,0,0,0, 0,0,0,0}
aNfCab[NF_IPI]		:= {0,0,0}
aNfCab[NF_TOTAL]	:= 0
aNfCab[NF_VALMERC]	:= 0
aNfCab[NF_VNAGREG]  :=0
aNfCab[NF_FUNRURAL]	:= 0
aNfCab[NF_LIVRO]	:= {}
aNfCab[NF_BASEIRR]	:= 0
aNfCab[NF_VALIRR]	:= 0
aNfCab[NF_BASEINS]  := 0
aNfCab[NF_VALINS]	:= 0
aNfCab[NF_BASEISS] 	:= 0
aNfCab[NF_VALISS]	:= 0
aNfCab[NF_IMPOSTOS]	:= {}
aNfCab[NF_IMPOSTOS2]:= {}
aNfCab[NF_BASEDUP]	:= 0
aNfCab[NF_DESCZF]	:= 0
aNfCab[NF_BASEIMP]	:= Array(NMAXIV)
aNfCab[NF_BASEIMP]	:= Afill(aNfCab[NF_BASEIMP],0)
aNfCab[NF_VALIMP]	:= Array(NMAXIV)
aNfCab[NF_VALIMP]	:= Afill(aNfCab[NF_VALIMP],0)
aNfCab[NF_PESO]		:= 0
aNfCab[NF_ICMFRETE]	:= 0
aNfCab[NF_BSFRETE]	:= 0
aNfCab[NF_BASEICA]	:= 0
aNfCab[NF_VALICA]	:= 0
aNfCab[NF_BASECOF]	:= 0
aNfCab[NF_VALCOF]	:= 0
aNfCab[NF_BASECSL]	:= 0
aNfCab[NF_VALCSL]	:= 0
aNfCab[NF_BASEPIS]	:= 0
aNfCab[NF_VALPIS]	:= 0
aNfCab[NF_BASEPS2]	:= 0
aNfCab[NF_VALPS2]	:= 0
aNfCab[NF_BASECF2]	:= 0
aNfCab[NF_VALCF2]	:= 0
aNfCab[NF_MINIMP]	:=Array(NMAXIV)
aNfCab[NF_MINIMP]	:=Afill(aNfCab[NF_MINIMP],0)
aNfCab[NF_BASEAFRMM]:= 0

For nX	:= 1 to Len(aNfItem)
	If nItemNao <> nX
		MaFisSomaIt(nX)
	Endif
Next

//������������������������������������������������������������������������Ŀ
//� Executa a correcao nos arredondamentos no Cabecalho e Livros Fiscais   �
//��������������������������������������������������������������������������
If cPaisLoc=="BRA"
	For nX := 1 To Len(aCabRef)
		If ValType(aCabRef[nX,2]) <> "A"
			nY := Val(aCabRef[nX,2])
			If ValType(aNfCab[nY]) == "N" .And. aCabRef[nX][3]
				aNfCab[nY] := MyNoRound(aNfCab[nY],2,,10)
			EndIf
		EndIf
	Next
	For nLf := 1 to Len(aNfCab[NF_LIVRO])
		For nY	:= 1 to Len(aNfCab[NF_LIVRO][nLf])
			If !AllTrim(StrZero(nY,2))$"01#02#12#15#16#18#20#23#24#31#32#33#35#36"
				aNfCab[NF_LIVRO][nLF][nY] := aNfCab[NF_LIVRO][nLF][nY]
			EndIf
		Next
	Next
Endif

If bFisRefresh <> Nil
	Eval(bFisRefresh)
EndIf

If bLivroRefresh <> Nil
	Eval(bLivroRefresh)
EndIf

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaFisVTot� Autor � Edson Maricate        � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza os valores totais do item                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisVTot(nItem)
Local nImp := 0,nValImp:=0
Local lDescInc   :=	(cPaisLoc<>"BRA".And.aNfCab[NF_OPERNF]=="S".And.SuperGetMV('MV_DESCSAI')=='1')
Local nImposto   := 0 
Local nAgrPisPas := If( aTes[TS_AGRPIS]=="1",aNfItem[nItem,IT_VALPS2],0) + If( aTes[TS_AGRCOF]=="1",aNfItem[nItem,IT_VALCF2],0)
Local nFretAut   :=  aNfItem[nItem][IT_VALICA]

If !GetNewPar("MV_FRETAUT",.T.)
	nFretAut := 0
EndIf

Do Case
Case aNFitem[nItem][IT_TIPONF ] == "P"
	aNfItem[nItem][IT_TOTAL]	:= aNfItem[nItem][IT_FRETE] + aNfItem[nItem][IT_DESPESA] + aNfItem[nItem][IT_SEGURO]+;
		aNfItem[nItem][IT_VALIPI]+IIf(aTes[TS_INCSOL]$"A,N,D",0,aNfItem[nItem][IT_VALSOL])+;
		aNfItem[nItem][IT_VALEMB]+nFretAut+nAgrPisPas
OtherWise
	Do Case
	Case aTes[TS_AGREG] == "N"
		aNfItem[nItem][IT_TOTAL]	:= aNfItem[nItem][IT_FRETE] + aNfItem[nItem][IT_DESPESA] + aNfItem[nItem][IT_SEGURO]+;
			IIf(aTes[TS_IPI] == 'R',0,aNfItem[nItem][IT_VALIPI]) + IIf(aTes[TS_INCSOL]$"A,N,D",0,aNfItem[nItem][IT_VALSOL])+;
			aNfItem[nItem][IT_VALEMB]+nAgrPisPas
		aNfItem[nItem][IT_VNAGREG] := aNfItem[nItem][IT_VALMERC]-aNfItem[nItem][IT_DESCONTO]
	Case aTes[TS_AGREG] == "I" .Or. aTes[TS_AGREG] == "B"
		aNfItem[nItem][IT_TOTAL]	:= aNfItem[nItem][IT_VALMERC] + aNfItem[nItem][IT_FRETE] + aNfItem[nItem][IT_DESPESA] + aNfItem[nItem][IT_SEGURO]+;
			IIf(aTes[TS_IPI] == 'R',0,aNfItem[nItem][IT_VALIPI])+ IIf(aTes[TS_INCSOL]$"A,N,D",0,aNfItem[nItem][IT_VALSOL]) - IIf(lDescInc,0,aNfItem[nItem][IT_DESCONTO])+;
			If(aNFitem[nItem][IT_TIPONF ]<>"I",aNfItem[nItem][IT_VALICM],0) + aNfItem[nItem][IT_VALEMB]+nFretAut+nAgrPisPas
		aNfItem[nItem][IT_VNAGREG] := 0
	OtherWise
		aNfItem[nItem][IT_TOTAL]	:= aNfItem[nItem][IT_VALMERC] + aNfItem[nItem][IT_FRETE] + aNfItem[nItem][IT_DESPESA] + aNfItem[nItem][IT_SEGURO]+;
			IIf(aTes[TS_IPI] == 'R',0,aNfItem[nItem][IT_VALIPI])+ IIf(aTes[TS_INCSOL]$"A,N,D",0,aNfItem[nItem][IT_VALSOL]) - IIf(lDescInc,0,aNfItem[nItem][IT_DESCONTO])+;
			aNfItem[nItem][IT_VALEMB]+nFretAut + nAgrPisPas - IIf(aTes[TS_AGREG]$"D",aNfItem[nItem][IT_DEDICM],0)
			aNfItem[nItem][IT_VNAGREG] := 0
	EndCase
EndCase

aNfItem[nItem][IT_BASEDUP] := 0

If aTes[TS_DUPLIC] <>"N"
	aNfItem[nItem][IT_BASEDUP] := aNfItem[nItem][IT_TOTAL]
	If SuperGetMV("MV_DPAGREG") .And. aTes[TS_AGREG] == "N"
		aNfItem[nItem][IT_BASEDUP] += aNfItem[nItem][IT_VALMERC]
	EndIf
	If aNFitem[nItem][IT_TIPONF ]=='I'
		aNfItem[nItem][IT_BASEDUP]	-= aNfItem[nItem][IT_VALICM]
	EndIf
	If aTES[TS_PICMDIF]<>100 .And. aTES[TS_PICMDIF]<>0
		MaItArred(nItem, { "IT_ICMSDIF" } )
		aNfItem[nItem][IT_BASEDUP]	-= aNfItem[nItem][IT_ICMSDIF]
	EndIf
	If (aNfCab[NF_RECISS]=="1".And.SuperGetMV("MV_DESCISS").And.aNfCab[NF_OPERNF]=="S".And.GetNewPar("MV_TPABISS","1")=="1")	
		aNfItem[nItem][IT_BASEDUP]	-= aNfItem[nItem][IT_VALISS]
	EndIf
	If aTes[TS_INCSOL]=="D"
		aNfItem[nItem][IT_BASEDUP]	-= aNfItem[nItem][IT_VALSOL]
	EndIf	
	If aTes[TS_AGREG]=="E"
		aNfItem[nItem][IT_BASEDUP]	-= aNfItem[nItem][IT_DEDICM]
	EndIf
EndIf
//��������������������������������������������������������������Ŀ
//� Verifica se a TES possui tratamento para Impostos Variaveis  �
//����������������������������������������������������������������
If !Empty(aTes[TS_SFC])			
	For nImposto := 1 to Len(aTes[TS_SFC])
		nImp := NumCpoImpVar(RIGHT(Alltrim(aTes[TS_SFC][nImposto][SFB_CPOVREI]),1))
		If  aTes[TS_DUPLIC] <> "N" .And. aNFitem[nItem][IT_TIPONF ]<>'B'
			Do Case
			Case aTes[TS_SFC][nImposto][SFC_INCDUPL]=="1"
				nValImp:=aNfItem[nItem][IT_VALIMP][nImp]
			Case aTes[TS_SFC][nImposto][SFC_INCDUPL]=="2"
				nValImp:=-aNfItem[nItem][IT_VALIMP][nImp]
			Case aTes[TS_SFC][nImposto][SFC_INCDUPL]=="3"
				nValImp:=0
			EndCase
			aNfItem[nItem][IT_BASEDUP] += nValImp
		Endif

		Do Case
		Case aTes[TS_SFC][nImposto][SFC_INCNOTA]=="1"
			nValImp:=aNfItem[nItem][IT_VALIMP][nImp]
		Case aTes[TS_SFC][nImposto][SFC_INCNOTA]=="2"
			nValImp:=-aNfItem[nItem][IT_VALIMP][nImp]
		Case aTes[TS_SFC][nImposto][SFC_INCNOTA]=="3"
			nValImp:=0
		EndCase
		aNfItem[nItem][IT_TOTAL] += nValImp
	Next nImposto
EndIf

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqRur � Autor � Edson Maricate        � Data �20.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calcula a aliquota para calculo do Funrural do item.        ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaAliqRur(nItem)
Local cTipoRur  := ""
Local nAliquota	:= 0
Local nPosPer   := 0
Local aPFunRur  := {}

If MaSBCampo("CONTSOC") == "S" .And. aTes[TS_DUPLIC] == "S" .And. aNfCab[NF_TPCLIFOR] <> "X"
	If aNfCab[NF_CLIFOR] == "F"
		cTipoRur := SA2->A2_TIPORUR
	Else
		cTipoRur := SM0->M0_PRODRUR
	EndIf
	aPFunRur := FunRur()
	//�������������������Ŀ
	//�aPFunRur[1]  == "F"�
	//�aPFunRur[2]  == "L"�
	//�aPFunRur[3]  == "J"�
	//���������������������
	nPosPer := At(cTipoRur,"FLJ")
	If nPosPer > 0
		nAliquota := Val(aPFunRur[nPosPer])
	Endif
EndIf
aNfItem[nItem][IT_PERFUN] := nAliquota

Return nAliquota

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaALIQIRR � Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a aliquota para calculo do Imposto de Renda.        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaALIQIRR(nItem)

Local aArea		:= GetArea()
Local nAliquota	:= 0
Local nSomaIRF  := 0
aEval(aNfItem,{|x| nSomaIRF += x[IT_BASEIRR]})

If !Empty(aNfCab[NF_NATUREZA])
	dbSelectArea("SED")
	dbSetOrder(1)
	If MsSeek(xFilial("SED")+aNfCab[NF_NATUREZA])
		If aNfCab[NF_CLIFOR] == "C"
			Do Case
				Case aNfCab[NF_ALIQIR] > 0
					nAliquota := aNfCab[NF_ALIQIR]
				Case SED->ED_CALCIRF = "S" .And. (Len(AllTrim(aNFCAB[NF_CNPJ]))==14 .Or. aNfCab[NF_MODIRF]=="2")
					nAliquota := IIf(SED->ED_PERCIRF>0,SED->ED_PERCIRF,SuperGetMV("MV_ALIQIRF"))
				Case SED->ED_CALCIRF = "S" .And. Len(AllTrim(aNFCAB[NF_CNPJ]))<>14
					nAliquota := MaTbIrfPF(aNfItem[nItem][IT_BASEIRR],nSomaIRF-aNfItem[nItem][IT_BASEIRR])[2]
			EndCase
		Else
			If SED->ED_CALCIRF = "S"
				If aNfCab[NF_TPCLIFOR] == "F" .And. aNfCab[NF_MODIRF]<>"2"
					nAliquota := MaTbIrfPF(aNfItem[nItem][IT_BASEIRR],nSomaIRF-aNfItem[nItem][IT_BASEIRR])[2]
				Else
					nAliquota := IIf(SED->ED_PERCIRF>0,SED->ED_PERCIRF,SuperGetMV("MV_ALIQIRF"))
				EndIf
			EndIf
		EndIf
	EndIf
Else
	nAliquota := aNfCab[NF_ALIQIR]
EndIf
aNfItem[nItem][IT_ALIQIRR]	:= nAliquota
RestArea(aArea)
Return(nAliquota)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaALIQINS � Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a aliquota para calculo do INSS                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaALIQINS(nItem)

Local aArea		:= GetArea()
Local nAliquota	:= 0

If !Empty(aNfCab[NF_NATUREZA])
	dbSelectArea("SED")
	dbSetOrder(1)
	If MsSeek(xFilial("SED")+aNfCab[NF_NATUREZA])
		nAliquota := SED->ED_PERCINSS
	EndIf
EndIf
aNfItem[nItem][IT_ALIQINS]	:= nAliquota

RestArea(aArea)
Return(nAliquota)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRdIR � Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o Percentual de reducao do IRRF do item.            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisRdIR(nItem)

aNfItem[nItem][IT_REDIR] := MaSBCampo("REDIRRF")

Return(aNfItem[nItem][IT_REDIR])

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRdINS� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o Percentual de reducao do INSS do item.            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisRdINSS(nItem)

aNfItem[nItem][IT_REDINSS] := MaSBCampo("REDINSS")

Return(aNfItem[nItem][IT_REDINSS])

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBsIR � Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o base de Caluculo do IIRF do item                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBSIR(nItem)

Local lRetBlock := .T. 

If ExistBlock( "MAFISBIR" ) 
	lRetBlock := ExecBlock( "MAFISBIR",.F.,.F.,;
		{aNfItem[nItem,IT_TES],aNfItem[nItem,IT_PRODUTO],aNfCab[NF_CLIFOR],aNfCab[NF_OPERNF],aNfCab[NF_CODCLIFOR],aNfCab[NF_LOJA]}) 
EndIf

If MaSBCampo("IRRF") == "S" .And. aTES[TS_DUPLIC]=="S" .And. lRetBlock 
	If !Len(AllTrim(aNFCAB[NF_CNPJ]))==14
		aNfItem[nItem][IT_BASEIRR] := aNfItem[nItem][IT_TOTAL]-aNfItem[nItem][IT_VALINS]
	Else	
		aNfItem[nItem][IT_BASEIRR] := aNfItem[nItem][IT_TOTAL]
	Endif
	aNfItem[nItem][IT_BASEIRR] := aNfItem[nItem][IT_BASEIRR]*IIf(aNfItem[nItem][IT_REDIR]>0,aNfItem[nItem][IT_REDIR]/100,1)
Else
	aNfItem[nItem][IT_BASEIRR] := 0
EndIf

Return(aNfItem[nItem][IT_BASEIRR])

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVLIR � Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o valor do Imposto de Renda do Item.                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVLIR(nItem)

Local nSomaIRF  := 0
Local lTbProgressiva := .F.
Local aBIR      := {}
Local nX        := 0
Local cNatureza := ""
aEval(aNfItem,{|x| nSomaIRF += IIf(!x[IT_DELETED],x[IT_BASEIRR],0)})

If aNfItem[nItem][IT_ALIQIRR] <> 0
	If Len(AllTrim(aNFCAB[NF_CNPJ])) < 14 
		If aNfCab[NF_CLIFOR] == "F" .Or. (aNfCab[NF_CLIFOR] == "C" .And. aNfCab[NF_ALIQIR]==0)
			lTbProgressiva := .T.
    	EndIf
  	EndIf
EndIf
If !lTbProgressiva
	aNfItem[nItem][IT_VALIRR] := aNfItem[nItem][IT_BASEIRR] * aNfItem[nItem][IT_ALIQIRR] /100
Else
	If aNfCab[NF_MODIRF]<>"2"		
		aBIR := MaTbIrfPF(aNfItem[nItem][IT_BASEIRR],nSomaIRF-aNfItem[nItem][IT_BASEIRR])
		For nX := 1 To Len(aNFItem)
			aNFItem[nX][IT_ALIQIRR] := aBIR[2]
		Next nX
		MaFisRatRes("IT_VALIRR",aBIR[1],aBIR[2],"IT_ALIQIRR","IT_BASEIRR",nItem)
		MaIt2Cab(nItem)

	Else			
		If aNfItem[nItem][IT_BASEIRR]-MaTbIrfPF(aNfItem[nItem][IT_BASEIRR],nSomaIRF-aNfItem[nItem][IT_BASEIRR])[4] > 0
			aNfItem[nItem][IT_VALIRR] := aNfItem[nItem][IT_BASEIRR] * aNfItem[nItem][IT_ALIQIRR] /100
		Else
			aNfItem[nItem][IT_VALIRR] := 0
		EndIf
	EndIf

EndIf

Return(aNfItem[nItem][IT_VALIRR])

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBsINS� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o base de Caluculo do INSS do item                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBSINSS(nItem)

If MaSBCampo("INSS") == "S" .And. aNfCab[NF_RECINSS]=="S" .And. aTES[TS_DUPLIC]=="S"
	aNfItem[nItem][IT_BASEINS] := (aNfItem[nItem][IT_TOTAL]+If(SuperGetMV("MV_INSSDES")=="1",aNfItem[nItem,IT_DESCONTO],0) )*;
		IIf(aNfItem[nItem][IT_REDINSS]>0,aNfItem[nItem][IT_REDINSS]/100,1)
		
	//��������������������������������������������������������������Ŀ
  	//� Abatimento da base de calculo do INSS                        �
	//����������������������������������������������������������������
	aNfItem[nItem][IT_BASEINS] -= aNfItem[nItem,IT_ABVLINSS] 

Else
	aNfItem[nItem][IT_BASEINS] := 0
EndIf

Return(aNfItem[nItem][IT_BASEINS])


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVLINS� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o valor do INSS do item.                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVLINSS(nItem)

Local aArea     := GetArea()
Local aAreaSA2  := SA2->(GetArea())
Local nLimINSS  := GetNewPar("MV_LIMINSS",0)
Local nInssAcum := 0
Local nValMaxIns:= 0

aNfItem[nItem][IT_VALINS] := aNfItem[nItem][IT_BASEINS] * aNfItem[nItem][IT_ALIQINS] /100
If aNFCab[NF_OPERNF]=="E" .And. aNFCab[NF_CLIFOR]=="F" .And. Len(AllTrim(aNFCab[NF_CNPJ]))<14 .And. Len(AllTrim(aNFCab[NF_CNPJ]))>1 .And. nLimInss > 0
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+aNfCab[NF_CODCLIFOR]+aNfCab[NF_LOJA])
	nInssAcum  := VerInssAcm(SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NREDUZ,dDataBase)	
	nValMaxIns := ( nLimInss - nInssAcum )
	Do Case
		Case nValMaxIns <= 0 
			aNfItem[nItem][IT_VALINS] := 0
		Case nValMaxIns < aNfItem[nItem][IT_VALINS]
			aNfItem[nItem][IT_VALINS] :=  nValMaxIns
	EndCase
EndIf
RestArea(aAreaSA2)
RestArea(aArea)
Return(aNfItem[nItem][IT_VALINS])

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVRur � Autor � Edson Maricate        � Data �20.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo do Valor do funrural no item especificado.���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVRur(nItem)

Local nItemIni := IIf(nItem==Nil,1,nItem)
Local nItemFim := IIf(nItem==Nil,Len(aNfItem),nItem)
Local nX       := 0

For nX := nItemIni to nItemFim
	aNfItem[nX][IT_FUNRURAL]	:= aNfItem[nX][IT_VALMERC] * aNfItem[nX][IT_PERFUN] / 100
Next nX
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisDel  � Autor � Edson Maricate        � Data �21.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Marca/Desmarca o item especificado como deletado.           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1	: Numero do Item.                                     ���
���          �ExpL2 : .T. - Deleta o item , .F. - Ativa o item            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisDel(nItem,lDelete)

If MaFisFound("IT",nItem)
	If lDelete
		If !aNfItem[nItem][IT_DELETED]
			aNfItem[nItem][IT_DELETED]	:= .T.
			MaIt2Cab()
		EndIf
	Else
		If aNfItem[nItem][IT_DELETED]
			aNfItem[nItem][IT_DELETED]	:= .F.
			If cPaisLoc<>"BRA"
				MaFisRecal("IT_VALMERC",nItem)
			Endif
			MaIt2Cab()
		EndIf
	EndIf
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRecal� Autor �  Edson Maricate       � Data �20.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Recalcula os valores de impostos do item.                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Campo que sofreu alteracao.                          ���
���          �ExpN2: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRecal(cCampo,nItem)
//�������������������������������������������������������������Ŀ
//� Posiciona os registros necessarios                          �
//���������������������������������������������������������������
DEFAULT cCampo	:=	''
dbSelectArea(cAliasPROD)
If aNfItem[nItem][IT_RECNOSB1] <> 0 .And. cAliasPROD=="SB1"
	MsGoto(aNfItem[nItem][IT_RECNOSB1])
Else
	dbSetOrder(1)
	MsSeek(xFilial(cAliasPROD)+aNfItem[nItem][IT_PRODUTO])
EndIf
//��������������������������������������������������������Ŀ
//� Inicializa a TES utilizada no calculo de impostos      �
//����������������������������������������������������������
MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)

//�������������������������������������������������������������Ŀ
//� Pesquisa a natureza antes de recalcular                     �
//���������������������������������������������������������������
If !Empty( aNfCab[NF_NATUREZA] )
	SED->( dbSetOrder(1) )
	SED->( MsSeek(xFilial("SED")+aNfCab[NF_NATUREZA] ) )
EndIf

//�������������������������������������������������������������Ŀ
//� Tratamento especifico e diferenciado para cada campo.       �
//���������������������������������������������������������������
Do Case
Case AllTrim(cCampo) == "IT_CF"
	MaItArred(nItem)	// Ajusta os arredondamentos
	MaFisLF(nItem)
	MaFisLF2(nItem)		// Verifica se a TES possui RdMake para complemento/geracao dos Livros
Case AllTrim(cCampo) == "IT_VALMERC"
	If cPaisLoc == "BRA"
		MaAliqSoli(nItem)	
		MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
		MaMargem(nItem)
	Endif
	MaFisPRC(nItem)		// Verifica o preco unitario do item
	If cPaisLoc == "BRA"
		MaFisBSIPI(nItem)
		MaFisVIPI(nItem)
		MaFisBSICM(nItem)
		MaFisVICMS(nItem)

		MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item								
		
		MaFisVComp(nItem)
		MaFisBSSol(nItem)
		MaFisVSol(nItem)
		MaFisVRur(nItem)	// Calcula o valor do funrural do item.
   Endif
	If cPaisLoc=="BRA"
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	Else
		MaFisImpIV(nItem)
	Endif
	MaFisNameIV(,nItem)	// Verifica o Nome dos Impostos Variaveis
	
	If cPaisLoc == "BRA" .And. !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIF 	
	
	MaFisVTot(nItem)
	If cPaisLoc == "BRA"
		MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
		MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
		MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
		MaALIQIRR(nItem)	// Calcula a Aliquota do IRRF do item
		MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
		MaFisBsISS(nItem)	// Calcula a Base do ISS do item
		MaFisVLISS(nItem)	// Calcula o valor do ISS do item
	
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
		EndIF 	
		
		MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
		MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
	MaFisBsAFRMM(nItem)	// Calcula a Base do AFRMM do item
	MaAliqAFRMM(nItem)	// Calcula a Aliquota do AFRMM do item	
	MaFisVlAFRMM(nItem)	// Calcula o Valor do AFRMM do item
Case AllTrim(cCampo) == "IT_BASEICM"
	MaAliqSoli(nItem)	
	MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
	MaMargem(nItem)	
	MaFisVICMS(nItem)
	
	MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item				
	
	MaFisVComp(nItem)
	MaFisBSSol(nItem)
	MaFisVSol(nItem)       
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIf 	
	
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.	
	EndIf	

	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_ALIQICM"
	If aTes[TS_AGREG] $ "I,A,D"
		MaFisBsICM(nItem)
	Endif
	MaAliqSoli(nItem)
	MaFisVICMS(nItem)
	
	MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item					
	
	MaFisVComp(nItem)
	MaFisVSol(nItem)    
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIF 	
	
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.	
	EndIf 

	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_ALIQIPI"
	MaAliqSoli(nItem)	
	MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
	MaMargem(nItem)	
	If MaFisRet(nItem,"IT_BASEIPI") == 0
		MaFisBSIPI(nItem)	// Calcula a Base de IPI
	Endif
	MaFisVIPI(nItem)
	If aTes[TS_INCIDE]	== "S"  .or. (aTes[TS_INCIDE] == "F" .and. aNFCab[NF_TPCLIFOR] =="F" .and. aNFCab[NF_CLIFOR] =="C")
		MaFisBsICM(nItem)
		MaFisVICMS(nItem)
		
		MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item						
		
		MaFisVComp(nItem)
	EndIf
	MaFisBSSol(nItem)
	MaFisVSol(nItem)        
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIF 	
	
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.		
	EndIf	

	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_BASEIPI"
	MaAliqSoli(nItem)	
	MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
	MaMargem(nItem)	
	MaFisVIPI(nItem)
	If aTes[TS_INCIDE]	== "S" .or. (aTes[TS_INCIDE] == "F" .and. aNFCab[NF_TPCLIFOR] =="F" .and. aNFCab[NF_CLIFOR] =="C")
		MaFisBsIcm(nItem)
		MaFisVICMS(nItem)
		
		MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item						
		
		MaFisVComp(nItem)
		MaFisBSSol(nItem)
		MaFisVSol(nitem)
	Endif                              
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIF 	
	
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.		
	EndIf 	

	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_VALIPI"
	MaAliqSoli(nItem)	
	MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
	MaMargem(nItem)
	If aTes[TS_INCIDE]	== "S"  .or. (aTes[TS_INCIDE] == "F" .and. aNFCab[NF_TPCLIFOR] =="F" .and. aNFCab[NF_CLIFOR] =="C")
		MaFisBsIcm(nItem)
		MaFisVICMS(nItem)
		
		MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item								
		
		MaFisVComp(nItem)
		MaFisBSSol(nItem)
		MaFisVSol(nItem)
	Endif               
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIf 	
	
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.		
	EndIf	

	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_BASESOL"
	MaFisVSol(nItem)
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_ALIQSOL"
	MaFisVSol(nItem)
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_VALSOL"
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_MARGEM"
	MaFisBsSol(nItem)
	MaFisVSol(nItem)
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_ALIQCMP"
	MaFisVComp(nItem)
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_VALCMP"
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_VALICM"
	MaFisVComp(nItem)   // Calcula o Valor do ICMS Complementar   
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.		
	EndIf 

	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_PERFUN"
	MaFisVRur(nItem)	// Calcula o valor do funrural do item.
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_FUNRURAL"
	MaFisVTot(nItem)
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal	
Case AllTrim(cCampo) == "IT_FRETE"
	If cPaisLoc == "BRA"
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaAliqSoli(nItem)	
		Endif	
		MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaMargem(nItem)	
			MaFisBSIPI(nItem)	// Calcula a Base de IPI
			MaFisVIPI(nItem)	// Calcula o Valor do IPI
			MaFisBSICM(nItem)	// Calcula a Base de ICMS
			MaFisVICMS(nItem)	// Calcula o Valor do ICMS
			
			MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item			
			MaFisVDescZF(nItem)	// Calcula o Valor do Desconto da Zona Franca	
			
			MaFisVComp(nItem)	// Calcula o Valor do ICMS Complementar
			MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
			MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
		Endif	                        
		                
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	Else
		MaFisImpIV(nItem)
	Endif

	If cPaisLoc == "BRA" .And. !( aTes[TS_AGREG] $ "B|C"	)	
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIf 	
	
	MaFisVTot(nItem)
	If cPaisLoc == "BRA"
		MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
		MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
		MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
		MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
		MaFisBsISS(nItem)	// Calcula a Base do ISS do item
		MaFisVLISS(nItem)	// Calcula o valor do ISS do item
		
		If !( aTes[TS_AGREG] $ "B|C"	)	
			MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
		EndIf 	
			
		MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
		MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.	
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_DESPESA"
	If cPaisLoc == "BRA"
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaAliqSoli(nItem)
		Endif	
		MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaMargem(nItem)	
			MaFisBSIPI(nItem)	// Calcula a Base de IPI
			MaFisVIPI(nItem)	// Calcula o Valor do IPI
			MaFisBSICM(nItem)	// Calcula a Base de ICMS
			MaFisVICMS(nItem)	// Calcula o Valor do ICMS
			
			MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item			
			MaFisVDescZF(nItem)	// Calcula o Valor do Desconto da Zona Franca				
			
			MaFisVComp(nItem)	// Calcula o Valor do ICMS Complementar
			MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
			MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
		Endif	
		                 
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
		EndIf 
	Else
		MaFisImpIV(nItem)
	Endif		
	
	MaFisVTot(nItem)
	If cPaisLoc == "BRA"
		MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
		MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
		MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
		MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
		MaFisBsISS(nItem)	// Calcula a Base do ISS do item
		MaFisVLISS(nItem)	// Calcula o valor do ISS do item
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
		EndIf 
			
		MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
		MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.	
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_SEGURO"
	If cPaisLoc == "BRA"
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaAliqSoli(nItem)
		Endif	
		MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaMargem(nItem)	
			MaFisBSIPI(nItem)	// Calcula a Base de IPI
			MaFisVIPI(nItem)	// Calcula o Valor do IPI
			MaFisBSICM(nItem)	// Calcula a Base de ICMS
			MaFisVICMS(nItem)	// Calcula o Valor do ICMS
			
			MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item
			MaFisVDescZF(nItem)	// Calcula o Valor do Desconto da Zona Franca	
			
			MaFisVComp(nItem)	// Calcula o Valor do ICMS Complementar
			MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
			MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
		Endif	
		
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
		EndIf
	Else
		MaFisImpIV(nItem)
	Endif		
	
	MaFisVTot(nItem)
	If cPaisLoc == "BRA"
		MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
		MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
		MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
		MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
		MaFisBsISS(nItem)	// Calcula a Base do ISS do item
		MaFisVLISS(nItem)	// Calcula o valor do ISS do item
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
		EndIf
			
		MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
		MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_REDIR"
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_BASEIRR"
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_VALIRR"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_ALIQIRR"
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_REDINSS"
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do IRRF do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_BASEINS"
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_ABVLINSS"
	MaFisBsINSS(nItem) // Calcula a base do INSS do item 
	MaFisVlINSS(nItem) // Calcula o Valor do INSS do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_ABVLISS"
	MaFisBsISS(nItem) // Calcula a base do ISS do item 
	MaFisVlISS(nItem) 
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)	
Case AllTrim(cCampo) == "IT_VALINS"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_ALIQINS"
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_VALISS"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)                              
Case Alltrim(cCampo) == "IT_REDISS"
	MaFisBsISS(nItem)
	MaFisVlISS(nItem)
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)
Case Alltrim(cCampo) == "IT_BASEISS"
	MaFisVlISS(nItem)
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)
Case Alltrim(cCampo) == "IT_ALIQISS"
	MaFisVlISS(nItem)
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)
Case AllTrim(cCampo) == "IT_CODISS"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)
Case Alltrim(cCampo) == "IT_BASECOF"
	MaFisVlCOF(nItem)	// Calcula o Valor do COFINS do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
Case Alltrim(cCampo) == "IT_ALIQCOF"
	MaFisVlCOF(nItem)	// Calcula o Valor do COFINS do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
Case Alltrim(cCampo) == "IT_BASEPIS"
	MaFisVlPIS(nItem)	// Calcula o Valor do PIS do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
Case Alltrim(cCampo) == "IT_ALIQPIS"
	MaFisVlPIS(nItem)	// Calcula o Valor do PIS do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_BASEPS2"
	MaFisVlPIS(nItem)	// Calcula o Valor do PIS do item.
	MaFisVTot(nItem)	

	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do COFINS do item.
	EndIf	

	MaFisBsCSL(nItem)	
	MaFisVlCSL(nItem)	
	MaItArred(nItem)	// Ajusta os arredondamentos do item  
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal	
Case Alltrim(cCampo) == "IT_BASECF2"
	MaFisVlCOF(nItem)	// Calcula o Valor do COFINS do item.
	MaFisVTot(nItem)	

	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do COFINS do item.
	EndIf	

	MaFisBsCSL(nItem)	
	MaFisVlCSL(nItem)	
	MaItArred(nItem)	// Ajusta os arredondamentos do item	
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal		
Case Alltrim(cCampo) == "IT_ALIQPS2"
	MaFisVlPIS(nItem)	// Calcula o Valor do PIS do item.
	
	MaFisVTot(nItem)	

	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do COFINS do item.
	EndIf	

	MaFisBsCSL(nItem)	
	MaFisVlCSL(nItem)	
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_ALIQCF2"
	MaFisVlCOF(nItem)	// Calcula o Valor do COFINS do item.
	MaFisVTot(nItem)	

	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do COFINS do item.
	EndIf	

	MaFisBsCSL(nItem)	
	MaFisVlCSL(nItem)	
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal	
Case Alltrim(cCampo) == "IT_VALPS2"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisVTot(nItem)	

	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do COFINS do item.
	EndIf	

	MaFisBsCSL(nItem)	
	MaFisVlCSL(nItem)	
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_VALCF2"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisVTot(nItem)	

	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do COFINS do item.
	EndIf	

	MaFisBsCSL(nItem)	
	MaFisVlCSL(nItem)	
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_BASECSL"
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_ALIQCSL"
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_VALCSL"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_VALCOF"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case Alltrim(cCampo) == "IT_VALPIS"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_DESCONTO"
	If cPaisLoc <> "BRA"
		MaPrcVen(nItem)
		MaFisImpIV(nItem)
	Else
		MaAliqSoli(nItem)
		MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
		MaMargem(nItem)	
		MaFisBSIPI(nItem)	// Calcula a Base de IPI
		MaFisVIPI(nItem)	// Calcula o Valor do IPI
		MaFisBSICM(nItem)	// Calcula a Base de ICMS
		MaFisVICMS(nItem)	// Calcula o Valor do ICMS
		
		MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item								
		
		MaFisVComp(nItem)	// Calcula o Valor do ICMS Complementar
		MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
		MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	Endif
	MaFisNameIV(,nItem)	// Verifica o Nome dos Impostos Variaveis
	
	If cPaisLoc == "BRA"
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
			MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		EndIf 	
	Endif		
	
	MaFisVTot(nItem)
	If cPaisLoc == "BRA"
		MaFisRdINSS(nItem)	// Calcula o Percentual de reducao do INSS do item
		MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
		MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
		MaFisRdIR(nItem)	// Calcula o Percentual de reducao do IRFF do item
		MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
		MaALIQIRR(nItem)	// Calcula a aliquota do IRRF do item	
		MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
		MaFisBsISS(nItem)	// Calcula a Base do ISS do item
		MaFisVLISS(nItem)	// Calcula o valor do ISS do item
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
			MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		EndIf 	
		MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
		MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case Substr(cCampo,1,9) == "IT_BASEIV"
	MaFisVLIV(Ascan(aTes[TS_SFC],{|x| Substr(x[10],10,1) == Substr(cCampo,10,1)}),nItem)	// Executa o calculo do Valor dos IVs
	MaFisVTot(nItem)	// Calcula o valor total do item
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
	MaFisLF2(nItem)	// Verifica se a TES possui RdMake para complemento/geracao dos Livros
Case Substr(cCampo,1,8) == "IT_VALIV"
	MaFisVTot(nItem)	// Calcula o valor total do item
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
	MaFisLF2(nItem)	// Verifica se a TES possui RdMake para complemento/geracao dos Livros
Case AllTrim(cCampo) == "IT_AUTONOMO"
	MaFisBSSOL(nItem)
	MaFisVSol(nItem)
	MaFisBsICA(nItem)		// Calcula o valor da Base do ICMS Autonomo
	MaFisVlICA(nItem)		// Calcula o valor do ICMS Autonomo
	MaFisVTot(nItem)
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_BASEICA"
	MaFisVlICA(nItem)		// Calcula o valor do ICMS Autonomo
	MaFisVTot(nItem)
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_VALICA"
	MaFisVTot(nItem)
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_FUNRURAL"
	MaFisVTot(nItem)
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "NF_NATUREZA"
	If cPaisLoc == "BRA"
	MaALIQINS(nItem)	// CalCula a Aliquota do INSS
	MaAliqISS(nItem)	// CalCula a Aliquota do ISS
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaAliqCOF(nItem)	// CalCula a Aliquota do COFINS
		MaAliqCSL(nItem)	// CalCula a Aliquota do CSLL
		MaAliqPIS(nItem)	// CalCula a Aliquota do PIS
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
	EndIf 	
	MaFisVTot(nItem)	// Calcula o valor total do item
	MaFisRdINSS(nItem)	// Calcula o Percentual de reducao do INSS do item
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisRdIR(nItem)	// Calcula o Percentual de reducao do IRFF do item
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaALIQIRR(nItem)	// Calcula a Aliquota do IRRF do item	
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaFisBsISS(nItem)	// Calcula a Base do ISS do item
	MaFisVLISS(nItem)	// Calcula o valor do ISS do item
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
	EndIf 	
		
	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
Case AllTrim(cCampo) == "IT_TES"
	If cPaisLoc == "BRA"
		MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
	Endif
	MaFisPRC(nItem)		// Verifica o preco unitario do item
	MaFisCFO(nItem)		// Verifica o Codigo Fiscal de Operacao
	If cPaisLoc == "BRA"
		MaAliqRur(nItem)	// Calcula a Aliquota de calculo do Funrural
		If (Empty( MaFisRet(nItem,"IT_ALIQICM") ) .Or. aTes[TS_ICM]=="N") .And. !( aTes[TS_AGREG] $ "B|C" ) 
			MaAliqIcms(nItem)	// Calcula a Aliquota de ICMS
		EndIf
		If (Empty( MaFisRet(nItem,"IT_ALIQIPI") ) .Or. aTes[TS_IPI]=="N") .And. !( aTes[TS_AGREG] $ "B|C" ) 
			MaAliqIPI(nItem)	// Calcula a Aloquota de IPI
		EndIf
	
		If !( aTes[TS_AGREG] $ "B|C" ) 
			MaALIQCMP(nItem)	// Calcula a Aliquota do ICMS Complementar
			MaAliqSoli(nItem)	// Calcula a Aliquota do ICMS Solidario
		Endif
	
		MaALIQINS(nItem)	// CalCula a Aliquota do INSS
		MaAliqISS(nItem)	// CalCula a Aliquota do ISS
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaAliqCOF(nItem)	// CalCula a Aliquota do COFINS
			MaAliqCSL(nItem)	// CalCula a Aliquota do CSLL
			MaAliqPIS(nItem)	// CalCula a Aliquota do PIS
			MaMargem(nItem)		// Calcula o Valor da Margem de lucro
			MaFisBSIPI(nItem)	// Calcula a Base de IPI
			MaFisVIPI(nItem)	// Calcula o Valor do IPI
			MaFisBSICM(nItem)	// Calcula a Base de ICMS
			MaFisVICMS(nItem)	// Calcula o Valor do ICMS
			
			MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item											
			
			MaFisVComp(nItem)	// Calcula o Valor do ICMS Complementar
		Endif
			
		MaFisVDescZF(nItem)	// Calcula o Valor do Desconto da Zona Franca	
		If !( aTes[TS_AGREG] $ "B|C" ) 
			MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
			MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
			MaFisBsICA(nItem)	// Calcula o valor da Base do ICMS Autonomo
			MaFisVlICA(nItem)	// Calcula o valor do ICMS Autonomo
		Endif	
		MaFisVRur(nItem)	// Calcula o valor do funrural do item.
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	Else
		MaFisImpIV(nItem)
	Endif
	MaFisNameIV(,nItem)	// Verifica o Nome dos Impostos Variaveis
	
	If cPaisLoc == "BRA" .And. !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIf 	
	
	MaFisVTot(nItem)	// Calcula o valor total do item
	If cPaisLoc == "BRA" 
		MaFisRdINSS(nItem)	// Calcula o Percentual de reducao do INSS do item
		MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
		MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
		MaFisRdIR(nItem)	// Calcula o Percentual de reducao do IRFF do item
		MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
		MaALIQIRR(nItem)	// Calcula a Aliquota do IRRF do item	
		MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
		MaFisBsISS(nItem)	// Calcula a Base do ISS do item
		MaFisVLISS(nItem)	// Calcula o valor do ISS do item
		
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
		EndIf 	
			
		MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
		MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
	MaFisLF2(nItem)		// Verifica se a TES possui RdMake para complemento/geracao dos Livros
	MaFisBsAFRMM(nItem)	// Calcula a Base do AFRMM do item
	MaAliqAFRMM(nItem)	// Calcula a Aliquota do AFRMM do item	
	MaFisVlAFRMM(nItem)	// Calcula o Valor do AFRMM do item
Case AllTrim(cCampo) == "IT_VALEMB"
	MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
	MaFisPRC(nItem)		// Verifica o preco unitario do item
	MaFisCFO(nItem)		// Verifica o Codigo Fiscal de Operacao
	MaAliqRur(nItem)	// Calcula a Aliquota de calculo do Funrural
	If Empty( MaFisRet(nItem,"IT_ALIQICM") ) .Or. aTes[TS_ICM]=="N"
		MaAliqIcms(nItem)	// Calcula a Aliquota de ICMS
	EndIf
	If Empty( MaFisRet(nItem,"IT_ALIQIPI") ) .Or. aTes[TS_IPI]=="N"
		MaAliqIPI(nItem)	// Calcula a Aloquota de IPI
	EndIf
	MaALIQCMP(nItem)	// Calcula a Aliquota do ICMS Complementar
	MaAliqSoli(nItem)	// Calcula a Aliquota do ICMS Solidario
	MaALIQINS(nItem)	// CalCula a Aliquota do INSS
	MaAliqISS(nItem)	// CalCula a Aliquota do ISS
	MaAliqCOF(nItem)	// CalCula a Aliquota do COFINS
	MaAliqCSL(nItem)	// CalCula a Aliquota do CSLL
	MaAliqPIS(nItem)	// CalCula a Aliquota do PIS
	MaMargem(nItem)		// Calcula o Valor da Margem de lucro
	MaFisBSIPI(nItem)	// Calcula a Base de IPI
	MaFisVIPI(nItem)	// Calcula o Valor do IPI
	MaFisBSICM(nItem)	// Calcula a Base de ICMS
	MaFisVICMS(nItem)	// Calcula o Valor do ICMS
	
	MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item				
	
	MaFisVComp(nItem)	// Calcula o Valor do ICMS Complementar
	MaFisVDescZF(nItem)	// Calcula o Valor do Desconto da Zona Franca	
	MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
	MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
	MaFisBsICA(nItem)	// Calcula o valor da Base do ICMS Autonomo
	MaFisVlICA(nItem)	// Calcula o valor do ICMS Autonomo
	MaFisVRur(nItem)	// Calcula o valor do funrural do item.
	If cPaisLoc=="BRA"
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	Else
		MaFisImpIV(nItem)
	Endif
	MaFisNameIV(,nItem)	// Verifica o Nome dos Impostos Variaveis
	
	If !( aTes[TS_AGREG] $ "B|C"	)	
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIf 	
	
	MaFisVTot(nItem)	// Calcula o valor total do item
	MaFisRdINSS(nItem)	// Calcula o Percentual de reducao do INSS do item
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisRdIR(nItem)	// Calcula o Percentual de reducao do IRFF do item
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaALIQIRR(nItem)	// Calcula a Aliquota do IRRF do item	
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaFisBsISS(nItem)	// Calcula a Base do ISS do item
	MaFisVLISS(nItem)	// Calcula o valor do ISS do item
	If !( aTes[TS_AGREG] $ "B|C"	)	
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
	EndIf 	
	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
	MaFisLF2(nItem)		// Verifica se a TES possui RdMake para complemento/geracao dos Livros
Case Alltrim(cCampo) == "IT_DESCZF"
	MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
	MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
	MaFisBsICA(nItem)	// Calcula o valor da Base do ICMS Autonomo
	MaFisVlICA(nItem)	// Calcula o valor do ICMS Autonomo
	MaFisVRur(nItem)	// Calcula o valor do funrural do item.
	
	If cPaisLoc=="BRA"
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	Else
		MaFisImpIV(nItem)
	Endif 
	
	MaFisNameIV(,nItem)	// Verifica o Nome dos Impostos Variaveis
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
	EndIf	
	
	MaFisVTot(nItem)	// Calcula o valor total do item
	MaFisRdINSS(nItem)	// Calcula o Percentual de reducao do INSS do item
	MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
	MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
	MaFisRdIR(nItem)	// Calcula o Percentual de reducao do IRFF do item
	MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
	MaALIQIRR(nItem)	// Calcula a Aliquota do IRRF do item	
	MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
	MaFisBsISS(nItem)	// Calcula a Base do ISS do item
	MaFisVLISS(nItem)	// Calcula o valor do ISS do item
	
	If !( aTes[TS_AGREG] $ "B|C"	)
		MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
		MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
	EndIf 	
	
	MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
	MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
	MaFisLF2(nItem)		// Verifica se a TES possui RdMake para complemento/geracao dos Livros
Case AllTrim(cCampo) == "IT_BASEDUP"
	MaItArred(nItem)	// Ajusta os arredondamentos do item
OtherWise
	If cPaisLoc == "BRA" 
		MaExcecao(nItem)	// Verifica se o produto possui excecao fiscal
	Endif
	MaFisPRC(nItem)		// Verifica o preco unitario do item
	MaFisCFO(nItem)		// Verifica o Codigo Fiscal de Operacao
	If cPaisLoc == "BRA" 
		MaAliqRur(nItem)	// Calcula a Aliquota de calculo do Funrural
		If Empty( MaFisRet(nItem,"IT_ALIQICM") ) .Or. aNfCab[NF_TIPONF] $ "DB" .Or. ;
			"NF_" $ Alltrim(cCampo) .Or. "IT_RECORI" $ Alltrim(cCampo) .Or.;
			"IT_PRODUTO" $ Alltrim(cCampo) .Or. "IT_GRPTRIB" $ Alltrim(cCampo)
			
			MaAliqIcms(nItem)	// Calcula a Aliquota de ICMS
		Endif
		If Empty( MaFisRet(nItem,"IT_ALIQIPI") ) .Or. aNfCab[NF_TIPONF] $ "DB" .Or. ;
			"NF_" $ Alltrim(cCampo) .Or. "IT_RECORI" $ Alltrim(cCampo) .Or. ;
			"IT_PRODUTO" $ Alltrim(cCampo) .Or. "IT_GRPTRIB" $ Alltrim(cCampo)
			MaAliqIPI(nItem)	// Calcula a Aloquota de IPI
		Endif
		MaALIQCMP(nItem)	// Calcula a Aliquota do ICMS Complementar
		MaAliqSoli(nItem)	// Calcula a Aliquota do ICMS Solidario
	
		MaALIQINS(nItem)	// CalCula a Aliquota do INSS
		MaAliqISS(nItem)	// CalCula a Aliquota do ISS
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaAliqCOF(nItem)	// CalCula a Aliquota do COFINS
			MaAliqCSL(nItem)	// CalCula a Aliquota do CSLL
			MaAliqPIS(nItem)	// CalCula a Aliquota do PIS
		EndIf
		MaMargem(nItem)		// Calcula o Valor da Margem de lucro
		MaFisBSIPI(nItem)	// Calcula a Base de IPI
		MaFisVIPI(nItem)	// Calcula o Valor do IPI
		MaFisBSICM(nItem)	// Calcula a Base de ICMS
		MaFisVICMS(nItem)	// Calcula o Valor do ICMS
		
		MaItArred(nItem, { "IT_BASEICM","IT_VALICM" } )   // Ajusta os arredondamentos do item						
		
		MaFisVComp(nItem)	// Calcula o Valor do ICMS Complementar
		MaFisVDescZF(nItem)	// Calcula o Valor do Desconto da Zona Franca	
		MaFisBSSOL(nItem)	// Calcula o Valor da Base do ICMS Solidario
		MaFisVSOL(nItem)	// Calcula o Valor do ICMS Solidario
		MaFisBsICA(nItem)	// Calcula o valor da Base do ICMS Autonomo
		MaFisVlICA(nItem)	// Calcula o valor do ICMS Autonomo
		MaFisVRur(nItem)	// Calcula o valor do funrural do item.
		
		MaFisAliqIV(,nItem)	// Executa o calculo da Aliquota dos IVs
		MaFisBSIV(,nItem)	// Executa o calculo da Base dos IVs
		MaFisVLIV(,nItem)	// Executa o calculo do Valor dos IVs
	Else
		MaFisImpIV(nItem)
	Endif
	
	MaFisNameIV(,nItem)	// Verifica o Nome dos Impostos Variaveis
	
	If cPaisLoc == "BRA" .And.!( aTes[TS_AGREG] $ "B|C"	)	
		MaFisBsCOF(nItem,"1")	// Calcula a Base do COFINS do item
		MaFisVlCOF(nItem,"1")	// Calcula o Valor do COFINS do item.
		MaFisBsPIS(nItem,"1")	// Calcula a Base do PIS do item
		MaFisVlPIS(nItem,"1")	// Calcula o Valor do PIS do item.
	EndIf 	
	
	MaFisVTot(nItem)	// Calcula o valor total do item
	If cPaisLoc == "BRA" 
		MaFisRdINSS(nItem)	// Calcula o Percentual de reducao do INSS do item
		MaFisBsINSS(nItem)	// Calcula a Base do INSS do item
		MaFisVlINSS(nItem)	// Calcula o Valor do INSS do item.
		MaFisRdIR(nItem)	// Calcula o Percentual de reducao do IRFF do item
		MaFisBsIR(nItem)	// Calcula a Base do IRRF do item
		MaALIQIRR(nItem)	// Calcula a Aliquota do IRRF do item	
		MaFisVlIR(nItem)	// Calcula o Valor do IRRF do item.
		MaFisBsISS(nItem)	// Calcula a Base do ISS do item
		MaFisVLISS(nItem)	// Calcula o valor do ISS do item
		
		If !( aTes[TS_AGREG] $ "B|C"	)
			MaFisBsCOF(nItem,"2")	// Calcula a Base do COFINS do item
			MaFisVlCOF(nItem,"2")	// Calcula o Valor do COFINS do item.
			MaFisBsPIS(nItem,"2")	// Calcula a Base do PIS do item
			MaFisVlPIS(nItem,"2")	// Calcula o Valor do PIS do item.
		EndIf 	
			
		MaFisBsCSL(nItem)	// Calcula a Base do CSLL do item
		MaFisVlCSL(nItem)	// Calcula o Valor do CSLL do item.
	Endif
	MaItArred(nItem)	// Ajusta os arredondamentos do item
	MaFisLF(nItem)		// Atualiza os valores do Livro Fiscal
	MaFisLF2(nItem)		// Verifica se a TES possui RdMake para complemento/geracao dos Livros
	MaFisBsAFRMM(nItem)	// Calcula a Base do AFRMM do item
	MaAliqAFRMM(nItem)	// Calcula a Aliquota do AFRMM do item	
	MaFisVlAFRMM(nItem)	// Calcula o Valor do AFRMM do item
EndCase
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaFisLF  � Autor �  Edson Maricate       � Data �20.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza os livros fiscais para o item.                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisLF(nItem)

Local lConsumo		:= MaFisConsumo(nItem)
Local lConsFinal	:= MaFisConsFin()
Local nRetVCtb		:= IIF(!aTes[TS_INCSOL]$"A,N,D",aNfItem[nItem][IT_VALSOL],0)
Local nDescIpi		:= IIf(aTes[TS_TPIPI]=="B" .Or. (MV_IPIBRUTO=="S" .And. aTes[TS_TPIPI] ==" "),aNfItem[nItem][IT_DESCONTO]+IIf(aNfCab[NF_OPERNF] == "S",aNfItem[nItem][IT_DESCZF],-1*aNfItem[nItem][IT_DESCZF]),0)
Local cIPINaOBS     := SuperGetMV("MV_IPINOBS")  	//Primeiro S - IPI nao tributado
//Segundo  S - IPI na Base do ICMS
Local lLFAgreg      := SuperGetMV("MV_LFAGREG",.F.) .And. aTes[TS_AGREG]=="N" .And. aTes[TS_TRFICM]=="2" //Indica se deve ser feita escrituracao, mesmo nao agregando valor ao total da nota.
Local nBICMOri      := aNfItem[nItem][IT_TOTAL]+IIf(aTes[TS_AGREG]=="N" .And. aTes[TS_TRFICM]=="2",aNfItem[nItem][IT_VALMERC],0)-IIf(aTes[TS_IPILICM] <> "1".And.aTes[TS_IPI]<>"R",aNfItem[nItem][IT_VALIPI],0)-IIF(aTes[TS_AGRRETC]=="1",0,nRetVCtb)
Local nBIPIOri      := aNfItem[nItem][IT_TOTAL]+IIf(aTes[TS_AGREG]=="N" .And. aTes[TS_TRFICM]=="2",aNfItem[nItem][IT_VALMERC],0)-;
		IIf(aTes[TS_IPI]<>"R",aNfItem[nItem][IT_VALIPI],0) - nRetVCtb + nDescIPI - Iif(aTes[TS_AGREG]$"I|B" .and. aTes[TS_INCIDE] == "S",aNfItem[nItem][IT_VALICM],0)-If(aTes[TS_AGRPIS]=="1",aNfItem[nItem,IT_VALPS2],0)-If(aTes[TS_AGRCOF]=="1",aNfItem[nItem,IT_VALCF2],0)-;
		IIf(aTES[TS_DESPIPI]=="N",aNfItem[nItem][IT_DESPESA],0)
Local nReduzICMS := aTes[TS_BASEICM]
Local nReduzIPI  := aTes[TS_BASEIPI]

If !Empty(aNFitem[nItem][IT_EXCECAO] )

	//�������������������������������������������������������������Ŀ
	//� Carrega a reducao da base do ICMS                           �
	//���������������������������������������������������������������
	If aNfItem[nItem,IT_EXCECAO,14] > 0
		nReduzICMS := aNfItem[nItem,IT_EXCECAO,14]
	EndIf 	

	//�������������������������������������������������������������Ŀ
	//� Carrega a reducao da base do IPI                            �
	//���������������������������������������������������������������
	If aNfItem[nItem,IT_EXCECAO,15] > 0
		nReduzIPI := aNfItem[nItem,IT_EXCECAO,15]
	EndIf 
	
EndIf 	

aNfItem[nItem][IT_LIVRO]	:= aClone(MaFisRetLF())

If aTes[TS_LFICM] <> "N" .Or. aTes[TS_LFIPI] <> "N" .Or. aTes[TS_LFISS] $"TIO"
	If cPaisLoc == "BRA"
		aNfItem[nItem][IT_LIVRO][LF_RECISS]   	:= aNfCab[NF_RECISS]
		aNfItem[nItem][IT_LIVRO][LF_ISSST]   	:= aTes[TS_ISSST]
		aNfItem[nItem][IT_LIVRO][LF_CFO] 		:= aNfItem[nItem][IT_CF]
		aNfItem[nItem][IT_LIVRO][LF_CFOEXT]   := aTes[TS_CFEXT] 		
		aNfItem[nItem][IT_LIVRO][LF_NFLIVRO]	:= aTes[TS_NRLIVRO]
		aNfItem[nItem][IT_LIVRO][LF_FORMULA]	:= aTes[TS_FORMULA]
		//
		//Valor de ISS para Sub-empreitada.
		aNfItem[nItem][IT_LIVRO][LF_ISSSUB]	:= aNfItem[nItem][IT_ABVLISS]
		//������������������������������������������������������������Ŀ
		//� Grava o Valor dos Descontos na Observacao.                 �
		//��������������������������������������������������������������
		aNfItem[nItem][IT_LIVRO][LF_VALOBSE]	:= aNfItem[nItem][IT_DESCONTO]+IIf(aNfCab[NF_OPERNF] == "S",aNfItem[nItem][IT_DESCZF],0)
		//�����������������������������������������������������������Ŀ
		//� ICMS Diferido                                             �
		//�������������������������������������������������������������
		If aTes[TS_ICMSDIF]=="1"
			aNfItem[nItem][IT_LIVRO][LF_ICMSDIF]	:= aNfItem[nItem][IT_ICMSDIF]
		EndIf
		//�����������������������������������������������������������Ŀ
		//� Credito Estimulo Manaus                                   �
		//| 1 = Nao Calcula                                           |
		//| 2 = Produtos Eletronicos                                  |
		//| 3 = Contrucao Civil
		//�������������������������������������������������������������
		If aTes[TS_CRDEST]$"23"                             
			If (cAliasPROD)->(FieldPos("B1_CRDEST")) > 0 .And. SF3->(FieldPos("F3_CRDEST")) > 0 
				aNfItem[nItem][IT_LIVRO][LF_CRDEST]	:= MyNoRound(aNfItem[nItem][IT_VALICM]*(cAliasPROD)->B1_CRDEST/100,2)
			Endif
		EndIf 
		//�������������������������������������������������������������������������������������Ŀ
		//�Grava o valor do credito presumido referente a Zona Franca de Manaus                 �
		//�Decreto 20.686 - 28/12/1999                                                          �	
		//���������������������������������������������������������������������������������������
		If SM0->(FieldPos("M0_INS_SUF")) > 0
			If GetMV("MV_ESTADO") == "AM" .And. !Empty(SM0->M0_INS_SUF)
				//�������������������������������������������������������������������������������������Ŀ
				//�Movimentos Interestaduais:                                                           �
				//�O contribuinte tem direito ao credito do valor do ICMS que seria calculado na origem,�
				//�Retirar da base o frete e o seguro.                                                  �
				//���������������������������������������������������������������������������������������	
				If Left(aNfItem[nItem][IT_LIVRO][LF_CFO],1) == "2"
					aNfItem[nItem][IT_LIVRO][LF_CRDZFM] := ((nBICMOri - (aNfItem[nItem][IT_FRETE] + aNfItem[nItem][IT_SEGURO])) * aNfItem[nItem][IT_ALIQICM]) / 100
				Endif                      
			Endif
		Endif
		//������������������������������������������������������������Ŀ
		//� Grava o Valor Contabil.                                    �
		//��������������������������������������������������������������
		If aNFitem[nItem][IT_TIPONF] <> "I" .Or. aNfItem[nItem][IT_VALSOL] <> 0
			aNfItem[nItem][IT_LIVRO][LF_VALCONT]	:= aNfItem[nItem][IT_TOTAL]+IIf(lLfAgreg,aNfItem[nItem][IT_VALMERC],0)-aNfItem[nItem][IT_LIVRO][LF_ICMSDIF]-If(aTes[TS_LFIPI]=="N".And.aTes[TS_AGREG]=="N",aNfItem[nItem][IT_VALIPI],0)
			If aTes[TS_LFICM]=="B"
			   aNfItem[nItem][IT_LIVRO][LF_VALOBSE]	:= 	aNfItem[nItem][IT_LIVRO][LF_VALCONT]
			   aNfItem[nItem][IT_LIVRO][LF_VALCONT]	:=0
			EndIf
			//��������������������������������������������������������Ŀ
			//� Credito Presumido                                      �
			//����������������������������������������������������������
			aNfItem[nItem][IT_LIVRO][LF_CRDPRES]	:= (aNfItem[nItem][IT_LIVRO][LF_VALCONT] * aTes[TS_CRDPRES]) / 100
		EndIf
		//������������������������������������������������������������Ŀ
		//� Grava o valor do ICMS do Frete Autonomo no Livro Fiscal    �
		//��������������������������������������������������������������
		aNfItem[nItem][IT_LIVRO][LF_ICMAUTO] := aNfItem[nItem][IT_VALICA]
		//������������������������������������������������������������Ŀ
		//� Tipo de Nota Fiscal.                                       �
		//��������������������������������������������������������������
		If aNfCab[NF_TIPONF] $ "DB" 
			aNfItem[nItem][IT_LIVRO][LF_TIPO]	:= aNfCab[NF_TIPONF]
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Livro de ICMS                                                           �
		//��������������������������������������������������������������������������
		IF !(aTes[TS_LFICM]$'NZ') .And. aTes[TS_ISS]<>"S"
			//������������������������������������������������������������������������Ŀ
			//�Base do ICMS                                                            �
			//��������������������������������������������������������������������������
			If aNfItem[nItem][IT_TIPONF] <> "I"
				If nReduzICMS > 0
					If !lConsumo
						aNfItem[nItem][IT_LIVRO][LF_BASEICM] := aNfItem[nItem][IT_BASEICM]
					Else
						If aTes[TS_LFICM] == "I"
							aNfItem[nItem][IT_LIVRO][LF_ISENICM] := aNfItem[nItem][IT_BASEICM] - aNfItem[nItem][IT_VIPIBICM]
							aNfItem[nItem][IT_LIVRO][LF_OUTRICM] := nBICMOri-aNfItem[nItem][IT_BASEICM]+aNfItem[nItem][IT_VIPIBICM]
						Else
							aNfItem[nItem][IT_LIVRO][LF_ISENICM] := Max( nBICMOri-aNfItem[nItem][IT_BASEICM]+aNfItem[nItem][IT_VIPIBICM], 0 ) 
							aNfItem[nItem][IT_LIVRO][LF_OUTRICM] := aNfItem[nItem][IT_BASEICM]-aNfItem[nItem][IT_VIPIBICM]
						EndIf
					EndIf
				Else
					If aTes[TS_LFICM] == "T"
						aNfItem[nItem][IT_LIVRO][LF_BASEICM] := aNfItem[nItem][IT_BASEICM]
					EndIf
				EndIf
			EndIf
			//������������������������������������������������������������������������Ŀ
			//�Valor do ICMS Tributado                                                 �
			//��������������������������������������������������������������������������
			If aTes[TS_LFICM] =="T" .Or. (nReduzICMS<>0.And.!lConsumo)						
				aNfItem[nItem][IT_LIVRO][LF_VALICM] := aNfItem[nItem][IT_VALICM]
			EndIf                              
			
			//���������������������������������������������������������������������������������Ŀ
			//� Grava o Valor do Credito Presumido - RJ - Prestacoes de Servicos de Transporte  �
			//�����������������������������������������������������������������������������������
			If aTes[TS_CRDTRAN]<>0
				aNfItem[nItem][IT_LIVRO][LF_CRDTRAN] := (aNfItem[nItem][IT_LIVRO][LF_VALICM] * aTes[TS_CRDTRAN]) / 100
			Endif
			
			//������������������������������������������������������������������������Ŀ
			//�Valor da Coluna Isentas e Nao Tributadas                                �
			//��������������������������������������������������������������������������
			If aTes[TS_LFICM] =="I"
				If nReduzICMS > 0
					If !lConsumo
						aNfItem[nItem][IT_LIVRO][LF_ISENICM] := nBICMOri-aNfItem[nItem][IT_BASEICM]+aNfItem[nItem][IT_VIPIBICM]
					EndIf
				Else
					aNfItem[nItem][IT_LIVRO][LF_ISENICM] := nBICMOri
				EndIf
			EndIf
			//������������������������������������������������������������������������Ŀ
			//�Valor da Coluna Outras                                                  �
			//��������������������������������������������������������������������������
			If aTes[TS_LFICM]=="O"
				If nReduzICMS > 0
					If !lConsumo
						aNfItem[nItem][IT_LIVRO][LF_OUTRICM] := nBICMOri-aNfItem[nItem][IT_BASEICM]+aNfItem[nItem][IT_VIPIBICM]
					EndIf
				Else
					aNfItem[nItem][IT_LIVRO][LF_OUTRICM] := nBICMOri
				EndIf
			EndIf
		EndIf
		//�����������������������������������������������������������Ŀ
		//� ICMS Complementar                                         �
		//�������������������������������������������������������������
		aNfItem[nItem][IT_LIVRO][LF_ICMSCOMP]	:= aNfItem[nItem][IT_VALCMP]
		//�����������������������������������������������������������Ŀ
		//� Transferencia de Debito e Credito                         �
		//�������������������������������������������������������������
		If aTes[TS_TRFICM]=="1"
			aNfItem[nItem][IT_LIVRO][LF_TRFICM]		:= aNfItem[nItem][IT_VALMERC]
		EndIf
		//�����������������������������������������������������������Ŀ
		//� ICMS Solidario.                                           �
		//�������������������������������������������������������������
		aNfItem[nItem][IT_LIVRO][LF_ICMSRET]	:= aNfItem[nItem][IT_VALSOL]
		aNfItem[nItem][IT_LIVRO][LF_BASERET]	:= aNfItem[nItem][IT_BASESOL]
		If aTes[TS_OBSICM] == "1"
			aNfItem[nItem][IT_LIVRO][LF_OBSICM] := aNfItem[nItem][IT_VALICM]
		Endif
		If aTes[TS_OBSSOL] == "1"
			aNfItem[nItem][IT_LIVRO][LF_OBSSOL] := aNfItem[nItem][IT_VALSOL]
		EndIf

		If aTes[TS_CREDST] $ "1#3"
			aNfItem[nItem][IT_LIVRO][LF_SOLTRIB] := aNfItem[nItem][IT_VALSOL]
			aNfItem[nItem][IT_LIVRO][LF_CREDST ] := aTes[TS_CREDST]
		EndIf
		//�����������������������������������������������������������Ŀ
		//� ICMS Aliquota                                             �
		//�������������������������������������������������������������
		If aNfItem[nItem][IT_LIVRO][LF_BASEICM]==0
			aNfItem[nItem][IT_LIVRO][LF_ALIQICMS] := 0
		Else
			aNfItem[nItem][IT_LIVRO][LF_ALIQICMS] := aNfItem[nItem][IT_ALIQICM]
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Quando o IPI estiver na base do ICMS preencher o valor do IPI na Observ.�
		//��������������������������������������������������������������������������
		If aNfItem[nItem][IT_VIPIBICM]>0 .And. SubStr(cIPInaObs,2,1)=="S"
			aNfItem[nItem][IT_LIVRO][LF_IPIOBS]   := aNfItem[nItem][IT_VIPIBICM]
		Else
			aNfItem[nItem][IT_LIVRO][LF_IPIOBS]   := 0
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Livro de ICMS-ST                                                        �
		//��������������������������������������������������������������������������
		IF (aTes[TS_LFICMST]$'IO')
			//������������������������������������������������������������������������Ŀ
			//�Valor da Coluna Isentas e Nao Tributadas                                �
			//��������������������������������������������������������������������������
			If aTes[TS_LFICMST] =="I"
				aNfItem[nItem][IT_LIVRO][LF_ISENICM] += aNfItem[nItem][IT_VALSOL]
			EndIf
			//������������������������������������������������������������������������Ŀ
			//�Valor da Coluna Outras                                                  �
			//��������������������������������������������������������������������������
			If aTes[TS_LFICMST]=="O"
				aNfItem[nItem][IT_LIVRO][LF_OUTRICM] += aNfItem[nItem][IT_VALSOL]
			EndIf
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Livro de IPI                                                            �
		//��������������������������������������������������������������������������
		If !aTes[TS_LFIPI]$"NZ" .And. aTes[TS_ISS]<>"S" .And. aNfItem[nItem][IT_TIPONF] <> "I"
			If nReduzIPI == 0
				Do Case
				Case aTes[TS_LFIPI] == "T"
					aNfItem[nItem][IT_LIVRO][LF_BASEIPI] := aNfItem[nItem][IT_BASEIPI]
					aNfItem[nItem][IT_LIVRO][LF_VALIPI]  := aNfItem[nItem][IT_VALIPI]
				Case aTes[TS_LFIPI] == "I"
					aNfItem[nItem][IT_LIVRO][LF_ISENIPI] := nBIPIOri
				Case aTes[TS_LFIPI] == "O"
					aNfItem[nItem][IT_LIVRO][LF_OUTRIPI] := nBIPIOri
				EndCase
			Else
				If lConsumo
					If aTes[TS_LFIPI]=="I"
						aNfItem[nItem][IT_LIVRO][LF_ISENIPI] := aNfItem[nItem][IT_BASEIPI]
						aNfItem[nItem][IT_LIVRO][LF_OUTRIPI] := nBIPIOri-aNfItem[nItem][IT_BASEIPI]
					Else
						aNfItem[nItem][IT_LIVRO][LF_ISENIPI] := nBIPIOri-aNfItem[nItem][IT_BASEIPI]
						aNfItem[nItem][IT_LIVRO][LF_OUTRIPI] := aNfItem[nItem][IT_BASEIPI]
					EndIf
				Else
					aNfItem[nItem][IT_LIVRO][LF_BASEIPI] := aNfItem[nItem][IT_BASEIPI]
					aNfItem[nItem][IT_LIVRO][LF_VALIPI]  := aNfItem[nItem][IT_VALIPI]
					aNfItem[nItem][IT_LIVRO][IIf(aTes[TS_LFIPI]=="I",LF_ISENIPI,LF_OUTRIPI)] := nBIPIOri-aNfItem[nItem][IT_BASEIPI]
				EndIf
			EndIf
		ElseIf aTes[TS_LFIPI] == "N" .And. aTes[TS_ISS] <> "S" .And. SubStr(cIPInaObs,1,1)=="S" .And. aTes[TS_IPI] <> 'R'
			aNfItem[nItem][IT_LIVRO][LF_IPIOBS]	:= aNfItem[nItem][IT_VALIPI]
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Quando o IPI possuir uma parte nao tributada, preencher o IPI na Observ.�
		//��������������������������������������������������������������������������
		If !lConsFinal
			If nBIPIOri<>aNfItem[nItem][IT_LIVRO][LF_BASEIPI] .And. aNfItem[nItem][IT_LIVRO][LF_VALIPI]<>0
				If SubStr(cIPInaObs,1,1)=="S" .And. aTes[TS_IPI] <> 'R'
					aNfItem[nItem][IT_LIVRO][LF_IPIOBS]   += MyNoRound((nBIPIOri-aNfItem[nItem][IT_LIVRO][LF_BASEIPI])*aNfItem[nItem][IT_LIVRO][LF_VALIPI]/aNfItem[nItem][IT_LIVRO][LF_BASEIPI],2)
				Endif
			Else
				If aTes[TS_LFIPI]$"IO" .And. aNfItem[nItem][IT_LIVRO][LF_VALIPI]==0
					If SubStr(cIPInaObs,1,1)=="S" .And. aTes[TS_IPI] <> 'R'
						aNfItem[nItem][IT_LIVRO][LF_IPIOBS]   := aNfItem[nItem][IT_VALIPI]
					Endif
				EndIf
			EndIf
		EndIf	
		//������������������������������������������������������������������������Ŀ
		//�Livro de ISS                                                            �
		//��������������������������������������������������������������������������
		If aTes[TS_ISS] == "S"
			Do Case
			Case aTes[TS_LFISS] == "T"
				aNfItem[nItem][IT_LIVRO][LF_BASEICM] := IIF(aNfCab[NF_TIPONF]=="I",0,aNfItem[nItem][IT_BASEISS])
				aNfItem[nItem][IT_LIVRO][LF_VALICM]  := IIF(aNfCab[NF_TIPONF]=="I",aNfItem[nItem][IT_BASEISS],aNfItem[nItem][IT_VALISS])
			Case aTes[TS_LFISS] == "I"
				aNfItem[nItem][IT_LIVRO][LF_ISENICM] := aNfItem[nItem][IT_BASEISS]
			Case aTes[TS_LFISS] == "O"
				aNfItem[nItem][IT_LIVRO][LF_OUTRICM] := aNfItem[nItem][IT_BASEISS]
			EndCase
			aNfItem[nItem][IT_LIVRO][LF_TIPO] := "S"
			aNfItem[nItem][IT_LIVRO][LF_CODISS] := aNfItem[nItem][IT_CODISS]
			//�����������������������������������������������������������Ŀ
			//� ISS Aliquota                                              �
			//�������������������������������������������������������������
			If aNfItem[nItem][IT_LIVRO][LF_BASEICM]==0
				aNfItem[nItem][IT_LIVRO][LF_ALIQICMS] := 0
			Else
				aNfItem[nItem][IT_LIVRO][LF_ALIQICMS] := aNfItem[nItem][IT_ALIQISS]
			EndIf		
			//�����������������������������������������������������������Ŀ
			//� Livro de ICMS - Ajuste SINEF 03/04 - DOU 08.04.04         �
			//�������������������������������������������������������������
			aNfItem[nItem][IT_LIVRO][LF_ISS_ALIQICMS] := 0
			Do Case
				Case aTes[TS_LFICM] == "I"
					aNfItem[nItem][IT_LIVRO][LF_ISS_ISENICM] := aNfItem[nItem][IT_LIVRO][LF_VALCONT]
				Case aTes[TS_LFICM] == "O"
					aNfItem[nItem][IT_LIVRO][LF_ISS_OUTRICM] := aNfItem[nItem][IT_LIVRO][LF_VALCONT]
			EndCase
			Do Case
				Case aTes[TS_LFIPI] == "I"
					aNfItem[nItem][IT_LIVRO][LF_ISS_ISENIPI] := aNfItem[nItem][IT_LIVRO][LF_VALCONT]
				Case aTes[TS_LFIPI] == "O"
					aNfItem[nItem][IT_LIVRO][LF_ISS_OUTRIPI] := aNfItem[nItem][IT_LIVRO][LF_VALCONT]
			EndCase
		EndIf
	Endif
	//�����������������������������������������������������������Ŀ
	//� Grava os Valores de Despesas                              �
	//�������������������������������������������������������������
	aNfItem[nItem][IT_LIVRO][LF_DESPESA] := aNfItem[nItem][IT_DESPESA]+aNfItem[nItem][IT_FRETE]+aNfItem[nItem][IT_SEGURO]
	//�����������������������������������������������������������������������������������������d�
	//�SIMPLES SC                                                                              �
	//�Sera gravado o valor do ICMS calculado na nota fiscal.                                  �
	//�Contribuintes do SIMPLES/SC devem destacar o ICMS nos documentos fiscais com            �
	//�destino a optantes do SIMPLES, mas o valor do ICMS nao deve ser apresentado na apuracao.�
	//�����������������������������������������������������������������������������������������d�
	If SubStr(aNfItem[nItem][IT_LIVRO][LF_CFO],1,1) $ "56" .And. aNfItem[nItem][IT_LIVRO][LF_TIPO] <> "S"
		If SA1->(FieldPos("A1_SIMPLES")) > 0 .And. SF3->(FieldPos("F3_SIMPLES")) > 0
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+aNfCab[NF_CODCLIFOR]+aNfCab[NF_LOJA]))
			If SA1->A1_SIMPLES <> "1"
				aNfItem[nItem][IT_LIVRO][LF_SIMPLES] := aNfItem[nItem][IT_LIVRO][LF_VALICM]
			Endif
		Endif
	Endif
EndIf
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRetLF� Autor � Edson Maricate        � Data �03.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna um array com a estrutura inicial do aLivro.        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum.                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisRetLF()
//        1  2  3  4   5  6  7  8  9 10 11  12 13 14  15  16 17   18 19  20 21 22  23  24  25 26 27 28 29 30 31  32  33  34 35          36 37 38 39 40 41
Return {"", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,"", 0, 0, "", "", 0, "", 0, "", 0, 0, "", "", 0, 0, 0, 0, 0, 0, "", "", "", 0,{0,0,0,0,0},"",0, 0, 0, 0, 0}

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqISS � Autor �  Edson Maricate       � Data �03.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a aliquota para calculo do ISS.                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaAliqISS(nItem)

Local nAliquota := 0
Local cCalcISS  := " "

If !Empty(aNfCab[NF_NATUREZA])
	dbSelectArea("SED")
	dbSetOrder(1)
	MsSeek(xFilial("SED")+aNfCab[NF_NATUREZA])
	cCalcISS := SED->ED_CALCISS
EndIf

If (aTes[TS_ISS] == "S" .And. aNfCab[NF_OPERNF] == "E" .And. Empty(aNfItem[nItem][IT_CODISS]))
	aNfItem[nItem][IT_CODISS]	:= MaSBCampo("CODISS")
EndIf

If (aTes[TS_ISS] == "S" .And. aNfCab[NF_OPERNF] == "S") .Or.;
		(aTes[TS_ISS] == "S" .And. aNfCab[NF_OPERNF] == "E" .And. !Empty(aNfItem[nItem][IT_CODISS])) .Or.;
		(cCalcISS=="S" .And. aTes[TS_ICM] == "N" .And. aNfCab[NF_OPERNF]$SuperGetMV("MV_TPNFISS") )

	aNfItem[nItem][IT_CALCISS] := "S"
	nAliquota := If ( MaSBCampo("ALIQISS") == 0 , MV_ALIQISS , MaSBCampo("ALIQISS") )
	//�������������������������������������������������������������Ŀ
	//� Verifica as Excecoes fiscais                                �
	//���������������������������������������������������������������
	If ( !Empty(aNFitem[nItem][IT_EXCECAO]) ) .And. aNfItem[nItem][IT_EXCECAO][7] == "S"
		If ( aNFCab[NF_UFORIGEM]==aNFCab[NF_UFDEST] )
			If aNFItem[nItem][IT_EXCECAO][1] > 0
				nAliquota := aNfItem[nItem][IT_EXCECAO][1] //Aliquota Interna
			EndIf
		Else
			If (aNFItem[nItem][IT_EXCECAO][2] > 0)
				nAliquota := aNfItem[nItem][IT_EXCECAO][2] //Aliquota Externa
			EndIf
		EndIf
	EndIf
Else
	aNfItem[nItem][IT_CALCISS] := "N"	
EndIf

aNfItem[nItem][IT_RATEIOISS] := aTes[TS_ISS]
aNfItem[nItem][IT_ALIQISS] := nAliquota

Return(nAliquota)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBsISS� Autor �  Edson Maricate       � Data �03.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a base de calculo do ISS                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBsISS(nItem)
Local nBase := 0

If aNfItem[nItem][IT_CALCISS] == "S" .And.;
		(aNfCab[NF_OPERNF]=="E".Or.;
		((aNfCab[NF_RECISS]=="1".And.aNfCab[NF_OPERNF]=="S".And.SuperGetMV("MV_DESCISS")).Or.(aNfCab[NF_RECISS]<>"1".And.aNfCab[NF_OPERNF]=="S")))

	nBase := aNfItem[nItem][IT_VALMERC]-aNfItem[nItem][IT_DESCONTO]
	
	//�������������������������������������������������������������Ŀ
	//� Reducao padrao da base do ISS ( TES )                       �
	//���������������������������������������������������������������
	If aTes[TS_BASEISS] > 0
		nBase := (nBase*aTes[TS_BASEISS])/100
	EndIf
	
	//�������������������������������������������������������������Ŀ
	//� Reducao opcional da base do ISS ( TES )                     �
	//���������������������������������������������������������������
	If aNfItem[nItem,IT_REDISS] > 0
		nBase := (nBase*aNfItem[nItem,IT_REDISS])/100
	EndIf
	                        
	//�������������������������������������������������������������Ŀ
	//� Abatimento da base do ISS                                   �
	//���������������������������������������������������������������
	nBase -= aNfItem[nItem,IT_ABVLISS]
	
Else
	nBase := 0
EndIf

aNfItem[nItem][IT_BASEISS] := nBase

Return(nBase)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVLISS� Autor �  Edson Maricate       � Data �03.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor do ISS do item.                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVLISS(nItem)

If aNfItem[nItem][IT_CALCISS] == "S"
	If GetNewPar("MV_TRNDISS","1")=="1"
		aNfItem[nItem][IT_VALISS] := aNfItem[nItem][IT_BASEISS]*aNfItem[nItem][IT_ALIQISS]/100
	Else
		If !GetNewPar("MV_RNDISS",.F.)
			aNfItem[nItem][IT_VALISS] := MyNoRound(aNfItem[nItem][IT_BASEISS]*aNfItem[nItem][IT_ALIQISS]/100,2)
		Else
			aNfItem[nItem][IT_VALISS] := Round(aNfItem[nItem][IT_BASEISS]*aNfItem[nItem][IT_ALIQISS]/100,2)
		EndIf
	EndIf
Else
	aNfItem[nItem][IT_VALISS] := 0
EndIf

Return(aNfItem[nItem][IT_VALISS])
/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisIniLo� Autor �Edson Maricate         � Data �09.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina inicializacao do item da funcao Fiscal                ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item do Array ANFItem que deve ser inicializado       ���
���          �ExpA2: Array de otimizacao de Inicializacao             (OPC)���
���          �ExpL3: Indica se o item deve ser estornado caso exista       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo inicializar a variavel aNFItem ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Function MaFisIniLoad(nItem,aItemLoad,lEstorno)

DEFAULT lEstorno := .F.

If !MaFisFound("IT",nItem)
	If aItemLoad <> Nil
		aadd(aNfItem,{"",;								//1 - Grupo de Tributacao
			{},;										//2 - Array contendo as excessoes Fiscais
			0,;											//3 - Aliquota de ICMS
			{0,0,0,0,0,0,0,0,0,0,0,0},;				//4 - Valores de ICMS
			0,;											//5 - Aliquota de IPI
			{0,0,0},;									//6 - Valores de IPI
			aItemLoad[5],;								//7 - Numero da NF Original
			aItemLoad[6],;   							//8 - Serie da NF Original
			aItemLoad[9],;								//9 - RecNo da NF original
			0,;											//10 - Valor do desconto do item
			0,;											//11 - Valor do Frete
			0,;											//12 - Valor da despesa
			0,;											//13 - Valor do seguro
			0,;											//14 - Valor do frete autonomo
			0,; 										//15 - Valor da Mercadoria
			aItemLoad[1],;								//16 - Codigo do produto
			aItemLoad[2],;								//17 - Codigo da TES
			0,;											//18 - Valor Total do item
			"    ",;									//19 - Codigo FIscal de Operacao
			0,;											//20 - Valor do Funrural
			0,;              							//21 - Aliquota para calculo do FunRural
			.F.,;										//22 - Flag de controle para itens deletados
			MaFisRetLF() ,;								//23 - Array Contendo o demonstrativo fiscal
			{0,0,0,aItemLoad[3],"",""},;				//24 - Array contendo os valores de ISS
			{0,0,0,0},;								//25 - Array contendo os valores de IR
			{0,0,0,0},;								//26 - Array contendo os valores de INSS
			0 ,;										//27 - Valor da Embalagem
			Array(NMAXIV),;								//28
			Array(NMAXIV),;								//29
			Array(NMAXIV),;								//30
			0,;											//31
			0,;											//32
			Array(NMAXIV),;								//33
			aItemLoad[4],;								//34
			0,;											//35
			0,;											//36
			0,;											//37
			0,;											//38
			0,;											//39
			0,;											//40
			0,;											//41
			0,;											//42
			0,;			  			  					//43
			0,;			  								//44
			0,;			  								//45
			0,;											//46
			0,;											//47
			0,;											//48
			aItemLoad[7],;								//49
			aItemLoad[8],;								//50
			0,;											//51
			aNFCAB[NF_TIPONF],;						    //52
			"",;										//53
			0,;											//54
			0,;											//55
			0,;											//56
			0,;											//57
			0,;											//58
			0,;											//59
			0,;											//60
			0,;											//61
			0,;											//62
		    0,;                                 		//63
			0,;                                 		//64
			0,;                                 		//65
			0,;											//66 - AFRMM
			0,;											//67
			0})											//68

	Else
		aadd(aNfItem,{"",;								//1 - Grupo de Tributacao
			{},;										//2 - Array contendo as excessoes Fiscais
			0,;											//3 - Aliquota de ICMS
			{0,0,0,0,0,0,0,0,0,0,0,0},;				//4 - Valores de ICMS
			0,;											//5 - Aliquota de IPI
			{0,0,0},;									//6 - Valores de IPI
			SPACE(LEN(SD1->D1_NFORI)),;				//7 - Numero da NF Original
			SPACE(LEN(SD1->D1_SERIORI)),;				//8 - Serie da NF Original
			,;											//9 - RecNo da NF original
			0,;											//10 - Valor do desconto do item
			0,;											//11 - Valor do Frete
			0,;											//12 - Valor da despesa
			0,;											//13 - Valor do seguro
			0,;											//14 - Valor do frete autonomo
			0,; 										//15 - Valor da Mercadoria
			If( aNfCab[NF_OPERNF] == 'S', Space(Len(SD2->D2_COD)), Space(Len(SD1->D1_COD))),;	//16 - Codigo do produto
			"   ",;										//17 - Codigo da TES
			0 ,;										//18 - Valor Total do item
			"    ",;									//19 - Codigo FIscal de Operacao
			0,;											//20 - Valor do Funrural
			0 ,;            				  			//21 - Aliquota para calculo do FunRural
			.F.,;										//22 - Flag de controle para itens deletados
			MaFisRetLF() ,;								//23 - Array Contendo o demonstrativo fiscal
			{0,0,0,"","",""},;							//24 - Array contendo os valores de ISS
			{0,0,0,0},;								    //25 - Array contendo os valores de IR
			{0,0,0,0},;								    //26 - Array contendo os valores de INSS
			0 ,;										//27 - Valor da Embalagem
			Array(NMAXIV),;								//28
			Array(NMAXIV),;								//29
			Array(NMAXIV),;								//30
			0,;											//31
			0,;											//32
			Array(NMAXIV),;								//33
			0,;											//34
			0,;											//35
			0,;											//36
			0,;											//37
			0,;											//38
			0,;											//39
			0,;											//40
			0,;											//41
			0,;											//42
			0,;			  			  					//43
			0,;			  								//44
			0,;			  								//45
			0,;											//46
			0,;											//47
			0,;											//48
			0,;											//49
			0,;											//50
			0,;											//51
			aNFCAB[NF_TIPONF],;    						//52
			"",;										//53
			0,;											//54
			0,;											//55
			0,;											//56
			0,;											//57
			0,;											//58
			0,;											//59
			0,;											//60
			0,;											//61
			0,;											//62
		    0,;                                 		//63
			0,;                                 		//64
			0,;                                 		//65
			0,;											//66 - AFRMM
			0,;											//67
			0})											//68
	EndIf
	//������������������������������������������������������������Ŀ
	//� Inicializa arrays de impostos variaveis                    �
	//��������������������������������������������������������������
	aNfItem[nItem][IT_BASEIMP]:=Afill(aNfItem[nItem][IT_BASEIMP],0)
	aNfItem[nItem][IT_ALIQIMP]:=Afill(aNfItem[nItem][IT_ALIQIMP],0)
	aNfItem[nItem][IT_VALIMP]:=Afill(aNfItem[nItem][IT_VALIMP],0)
	aNfItem[nItem][IT_DESCIV]:=Afill(aNfItem[nItem][IT_DESCIV],{"","",""})
	aadd(aItemDec,{Nil,Nil})
	aItemDec[Len(aItemDec)][1] := Array(Len(aItemRef))
	aItemDec[Len(aItemDec)][2] := Array(Len(aItemRef))
	aFill(aItemDec[Len(aItemDec)][1],0)
	aFill(aItemDec[Len(aItemDec)][2],0)
Else
	If lEstorno
		MaFisSomaIt(nItem,.F.)
	Endif
EndIf

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisEndLoad� Autor � Edson Maricate      � Data �09.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Finaliza a carga dos itens Fiscais                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1 : Item                                                ���
���          �ExpN2 : Tipo de atualizacao do Item :                       ���
���          �        1-(default) Executa o recalculo de todos os itens   ���
���          �                    para efetuar a atualizacao do cabecalho ���
���          �        2-Executa a soma do item para atualizacao do cabeca ���
���          �                    lho.                                    ���
���          �        3-Nao executa a atualizacao do cabecalho.           ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisEndLoad(nItem,nTipo)

Local aArea    := GetArea()
DEFAULT nTipo  := 1
//�������������������������������������������������������������Ŀ
//� Posiciona os registros necessarios                          �
//���������������������������������������������������������������
dbSelectArea(cAliasPROD)
If aNfItem[nItem][IT_RECNOSB1] <> 0 .And. cAliasPROD=="SB1"
	MsGoto(aNfItem[nItem][IT_RECNOSB1])
Else
	dbSetOrder(1)
	MsSeek(xFilial(cAliasPROD)+aNfItem[nItem][IT_PRODUTO])
EndIf
MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)
MaFisNameIV(,nItem)	// Verifica o Nome dos Impostos Variaveis
MaFisVTot(nItem)
MaItArred(nItem)	// Ajusta os arredondamentos
MaFisLF(nItem)
MaFisLF2(nItem)

Do Case
Case nTipo == 1
	MaIt2cab()
Case nTipo == 2
	MaFisSomaIt(nItem)
EndCase

If bFisRefresh <> Nil
	Eval(bFisRefresh)
EndIf
If bLivroRefresh <> Nil
	Eval(bLivroRefresh)
EndIf
RestArea(aArea)
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisClear� Autor � Edson Maricate        � Data �09.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Limpa os itens da NF e zera as variaveis do cabecalho.      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisClear()

If MaFisFound('NF')
	aNfItem := {}
	aItemDec:= {}
	If aSaveDec<>Nil
		aFill(aSaveDec,0)
	EndIf
	aAuxOri	:= {}
	MaIt2Cab()
EndIf

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisResum� Autor � Edson Maricate        � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza o Array de Resumos da NF.                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisResumo(nValBase,nAliquota,nValor,cCodImp,cDescImp,cNomeRef,lForceVlr,lForceBs,lSoma)
Local nRS		:= 0
Local nRS2		:= 0
DEFAULT lForceVlr	:= .F.
DEFAULT lForceBs	:= .F.
DEFAULT lSoma		:= .T.
If Empty(cCodImp)
	Return	.F.
Endif	
If !Empty(aNfCab[NF_IMPOSTOS]).And.aNfCab[NF_IMPOSTOS][1][1]==""
	aNfCab[NF_IMPOSTOS] := {}
	aNfCab[NF_IMPOSTOS2] := {}
Else
	nRS	:= aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==cCodImp .And.;
		x[IMP_ALIQ]==nAliquota })
	nRS2:= aScan(aNfCab[NF_IMPOSTOS2],{|x| x[IMP_COD] ==cCodImp   })
EndIf

If aNfCab[NF_RELIMP] <> Nil .And. !Empty(aNfCab[NF_RELIMP])
	nValBase 	:= IIf(aScan(aNfCab[NF_RELIMP],{|x|"BASE"+cNomeRef$x[3]})>0.Or.lForceBs,nValBase,0)
	nValor		:= IIf(aScan(aNfCab[NF_RELIMP],{|x|"VAL"+cNomeRef$x[3]})>0.Or.lForceVlr,nValor,0)
EndIf

If lSoma
	If nRS > 0
		aNfCab[NF_IMPOSTOS][nRS][IMP_BASE] 	+= nValBase
		aNfCab[NF_IMPOSTOS][nRS][IMP_VAL]  	+= nValor
	Else
		aadd(aNfCab[NF_IMPOSTOS],{cCodImp,cDescImp,nValBase,nAliquota,nValor,cNomeRef})
	EndIf

	If nRS2 > 0
		aNfCab[NF_IMPOSTOS2][nRS2][3] 	+= nValBase
		aNfCab[NF_IMPOSTOS2][nRS2][4] 	+= nValor
	Else
		aadd(aNfCab[NF_IMPOSTOS2],{cCodImp,cDescImp,nValBase,nValor,cNomeRef})
	EndIf
Else
	If nRS > 0
		aNfCab[NF_IMPOSTOS][nRS][IMP_BASE] 	-= nValBase
		aNfCab[NF_IMPOSTOS][nRS][IMP_VAL]  	-= nValor
		If  aNfCab[NF_IMPOSTOS][nRS][IMP_BASE] <= 0 .And.;
				aNfCab[NF_IMPOSTOS][nRS][IMP_VAL]  <= 0
			aDel(aNfCab[NF_IMPOSTOS],nRS)
			aSize(aNfCab[NF_IMPOSTOS],Len(aNfCab[NF_IMPOSTOS])-1)
		EndIf
	EndIf

	If nRS2 > 0
		aNfCab[NF_IMPOSTOS2][nRS2][3] 	-= nValBase
		aNfCab[NF_IMPOSTOS2][nRS2][4] 	-= nValor
		If  aNfCab[NF_IMPOSTOS2][nRS2][3] <= 0 .And.;
				aNfCab[NF_IMPOSTOS2][nRS2][4]  <= 0
			aDel(aNfCab[NF_IMPOSTOS2],nRS2)
			aSize(aNfCab[NF_IMPOSTOS2],Len(aNfCab[NF_IMPOSTOS2])-1)
		EndIf
	EndIf
EndIf

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRodape� Autor � Edson Maricate       � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza o Array de Resumos da NF.                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRodape(nTipo,;		// Quebra : 1 Imposto+Aliquota,  2-Imposto
	oJanela,;		// Janela onde sera montado
	aImpostos,;	// Relacao de Impostos que deverao aparecer ( Codigo )
	aPos,;			// Array contendo Posicao e Tamanho
	bValidPrg,;	// Validacao executada na Edicao dop Campo
	lVisual,; // So para visualizacao
	cFornIss,; //Fornecedor do ISS
	cLojaIss,; //Loja do Fornecedor do ISS
	aRecSE2,;
	cDirf,;
	cCodRet,;
	oCodRet,;	
	nCombo,;
	oCombo,;
	dVencIss) //Vencimento ISS

Local oList
Local aTemp                                              
Local aOpcoes := {"Sim","Nao"}
Local oFornIss
Local oLojaIss                     
Local oVencIss
Local oDescri 
                                                                  
Local cDescri  := ""
Local aAreaSE2 := {}
Local aAreaSA2 := {}
Local lFornIss     := .F.
Local nPosDum	:=	0

DEFAULT oCodRet := Nil
DEFAULT oCombo  := Nil
DEFAULT nCombo  := 2
DEFAULT dVencIss := CtoD("")

If nTipo == 1
	If Empty(aNfCab) .Or. Empty(aNfCab[NF_IMPOSTOS])
		aTemp	:= {{"","",0,0,0}}
	Else
		aTemp	:= aNFCab[NF_IMPOSTOS]
	EndIf
Else
	If Empty(aNfCab) .Or. Empty(aNfCab[NF_IMPOSTOS2])
		aTemp	:= {{"","",0,0}}

	Else
		aTemp	:= aNFCab[NF_IMPOSTOS2]
	EndIf
EndIf

bFisRefresh	:= {|| MaFisRRefresh(oList,nTipo)}

If SE2->(FieldPos("E2_FORNISS")) > 0 .And. SE2->(FieldPos("E2_LOJAISS")) > 0 
	If cFornIss <> NIL .And. cLojaIss <> NIL

		lFornIss := .T.
			
		aPos[2] := 85 
		aPos[3] -= 80
		@ 03,2 TO 58,84 LABEL '' OF oJanela PIXEL
		@ 06,10 SAY STR0023 Of oJanela PIXEL SIZE 80,09 //"Dados de Cobran�a do ISS"
		@ 19,04 SAY RetTitle("E2_FORNISS") Of oJanela PIXEL SIZE 30,09

		If SE2->(FieldPos("E2_VENCISS")) > 0
			@ 46,04 SAY RetTitle("E2_VENCISS")Of oJanela PIXEL SIZE 30,09
		EndIf
		
		If lVisual 
		    
		    If Len(aRecSE2) > 0
		    	aAreaSE2 := SE2->(GetArea())
			    aAreaSA2 := SA2->(GetArea())
		    
			    SE2->(dbGoTo(aRecSE2[1]))
			    cFornIss := SE2->E2_FORNISS 
		    	cLojaIss := SE2->E2_LOJAISS
			    If SA2->(MsSeek(xFilial("SA2")+cFornIss+cLojaIss))
					cDescri := SA2->A2_NREDUZ
				Endif	
				If SE2->(FieldPos("E2_VENCISS")) > 0
			    	dVencIss := SE2->E2_VENCISS
			 	EndIf
		
				RestArea(aAreaSE2)
				RestArea(aAreaSA2)
		    Endif
			
			@ 18,31 MSGET oFornIss VAR cFornIss ;
			PICTURE PesqPict('SE2','E2_FORNISS')  ;
			OF oJanela PIXEL SIZE 35,09 ;
			READONLY
			                         
			@ 18,67 MSGET oLojaIss VAR cLojaIss ;
			PICTURE PesqPict("SE2","E2_LOJAISS") ;
			OF oJanela PIXEL SIZE 15,09 ;
			READONLY

			If SE2->(FieldPos("E2_VENCISS")) > 0
				@ 44,38 MSGET oVencIss VAR dVencIss ;
				OF oJanela PIXEL READONLY
			EndIf

		Else
		
			@ 18,31 MSGET oFornIss VAR cFornIss ;
			PICTURE PesqPict('SE2','E2_FORNISS')  ;
			OF oJanela PIXEL SIZE 35,09 ;
			F3 CpoRetF3('E2_FORNISS') ;
			VALID MaVldForn(@cFornIss,@cLojaIss,@oDescri,@cDescri,@oLojaISS,@oFornIss,1)
			                         
			@ 18,67 MSGET oLojaIss VAR cLojaIss ;
			PICTURE PesqPict("SE2","E2_LOJAISS") ;
			OF oJanela PIXEL SIZE 15,09 ;
			F3 CpoRetF3("E2_LOJAISS") ;
			VALID MaVldForn(@cFornIss,@cLojaIss,@oDescri,@cDescri,@oLojaISS,@oFornIss,2) 

			If SE2->(FieldPos("E2_VENCISS")) > 0
				@ 44,38 MSGET oVencIss VAR dVencIss ;
				OF oJanela PIXEL
			EndIf
				
		EndIf 	
			
		@ 31,04 MSGET oDescri VAR cDescri OF oJanela PIXEL SIZE 78,09 WHEN .F. 

	Endif
Endif

If SuperGetMv("MV_VISDIRF",.F.,"1") == "1"

	If cDirf <> NIL .And. cCodRet <> NIL
	
	   If lVisual
		   cCodRet := SE2->E2_CODRET
		   If !Empty(cCodRet)
		       cDirf   := "1"
		       nCombo  := 1
		    Else
		       cDirf   := "2"
		       nCombo  := 2
		   EndIf
		Else	
			cDirf := "2"
		Endif	
		If lFornIss 
			aPos[2] := 170 
			aPos[3] -= 80
			@ 03,85 TO 58,169 LABEL '' OF oJanela PIXEL
			@ 06,93 SAY "DIRF" Of oJanela PIXEL SIZE 80,09 //"Dados de Cobran�a do ISS"		
			
			@ 19,89 SAY RetTitle("E2_DIRF") Of oJanela PIXEL SIZE 30,09
			@ 19,125 MSCOMBOBOX oCombo VAR nCombo ITEMS aOpcoes ON CHANGE (cDirf := StrZero(oCombo:nAt,1)) SIZE 40,50 OF oJanela PIXEL		
			
			@ 35,89 SAY RetTitle("E2_CODRET") Of oJanela PIXEL SIZE 50,09
			@ 35,125 MSGET oCodRet VAR cCodRet F3 "37" Valid Empty(cCodRet) .Or. CheckSX3('E2_CODRET',cCodRet) ;
											OF oJanela PIXEL SIZE 40,09 
	
		Else
		
			aPos[2] := 85 
			aPos[3] -= 80
			@ 03,02 TO 58,84 LABEL '' OF oJanela PIXEL
			@ 06,10 SAY "DIRF" Of oJanela PIXEL SIZE 80,09 //"Dados de Cobran�a do ISS"		
			
			@ 19,04 SAY RetTitle("E2_DIRF") Of oJanela PIXEL SIZE 30,09
			@ 19,40  MSCOMBOBOX oCombo VAR nCombo ITEMS aOpcoes ON CHANGE (cDirf := StrZero(oCombo:nAt,1)) SIZE 40,50 OF oJanela PIXEL		
			
			@ 35,04 SAY RetTitle("E2_CODRET") Of oJanela PIXEL SIZE 50,09
			@ 35,40 MSGET oCodRet VAR cCodRet F3 "37" Valid Empty(cCodRet) .Or. CheckSX3('E2_CODRET',cCodRet) ;
											OF oJanela PIXEL SIZE 40,09 
		Endif	
	Endif
Endif	

If nTipo == 1
	oList := TWBrowse():New( aPos[1],aPos[2],aPos[3],aPos[4],,{STR0003,STR0004,STR0005,STR0006,STR0007},{30,90,50,30,50},oJanela,,,,,,,,,,,,.F.,,.T.,,.F.,,, ) //"Cod."###"Descricao"###"Base Imposto"###"Aliquota"###"Vlr. Imposto"
Else
	oList := TWBrowse():New( aPos[1],aPos[2],aPos[3],aPos[4],,{STR0003,STR0004,STR0005,STR0007},{30,90,50,50},oJanela,,,,,,,,,,,,.F.,,.T.,,.F.,,, ) //"Cod."###"Descricao"###"Base Imposto"###"Vlr. Imposto"
EndIf
If cPaisLoc == "ARG"
	nPosDum	:=	Ascan(aTemp,{|x| x[1] == "DUM"})
	If nPosDum > 0
		aDel(aTemp,nPosDum)
		aSize(aTemp,Len(aTemp)-1)
	Endif	
Endif	
oList:SetArray(aTemp)
If !lVisual
	oList:bLDblClick 	:= {|| MaFisVRodape(oList,bValidPrg,nTipo,oList:nColPos) .And. MaFisInsereImp(oList,bValidPrg,nTipo)}
EndIf
oList:bLine 		:= {|| MaFisLine(oList,aTemp,nTipo) }
oList:lAutoEdit	:= !lVisual

Return oList


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisLine� Autor � Edson Maricate         � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a linha de exibicao do ListBox atualizado.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisLine(oList,aTemp,nTipo)
Local aRet,nDec
Local cPictAliq	:= If( cPaisLoc="BRA","@E 999.99",PesqPict("SFB","FB_ALIQ"))
Local cPictVal	:=	""
If cPaisLoc<>"BRA"
	If FunName()=="MATA121" .And. Type("nMoedaPed")=="N"
		nDec:=MsDecimais(nMoedaPed)
	ElseIf FunName()=="MATA150" .And. Type("nMoedaCot")=="N"
		nDec:=MsDecimais(nMoedaCot)
	Else
		nDec:=MsDecimais(If(Type("nMoedaNF")=="N",nMoedaNF,If(Type("nMoedaCor")=="N",nMoedaCor,1)))
	Endif
Else
	nDec:=2
Endif
cPictVal	:= "@E 999,999,999"+IIf(nDec>0,"."+Replicate("9",nDec),"")
If Len(aTemp)>0
	If nTipo == 1
		aRet:= {aTemp[oList:nAt][1],;
			aTemp[oList:nAt][2],;
			IIf(ValType(aTemp[oList:nAt][3])=="N",TransForm(aTemp[oList:nAt][3],cPictVal),aTemp[oList:nAt][3]),;
			TransForm(aTemp[oList:nAt][4],cPictAliq),;
			IIf(valType(aTemp[oList:nAt][5])=="N",TransForm(aTemp[oList:nAt][5],cPictVal),aTemp[oList:nAt][5]) }
	Else
		aRet:= {aTemp[oList:nAt][1],;
			aTemp[oList:nAt][2],;
			IIf(ValType(aTemp[oList:nAt][3])=="N",TransForm(aTemp[oList:nAt][3],cPictVal),aTemp[oList:nAt][3]),;
			IIf(ValType(aTemp[oList:nAt][4])=="N",TransForm(aTemp[oList:nAt][4],cPictVal),aTemp[oList:nAt][4]) }
	EndIf
Else
	aRet:={}
Endif

Return aRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVRoda� Autor � Edson Maricate        � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza o Array de Resumos da NF.                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisVRodape(oList,bValidPrg,nTipo,nCol)

Local nPos        := oList:nAT
Local nBaseAnt    := 0
Local nBase       := 0
Local nVal        := 0
Local cIniCpo     := ""
Local lEditaVal	:= .F.
Local lEditaBas	:= .F.
Local lNfCab      := MaFisFound( "NF" )
Local nDec		  := MsDecimais(Max(MaFisRet(,'NF_MOEDA'),1))
Local cPictGet	  := '@E 999,999,999'+IIf(nDec>0,"."+Replicate("9",nDec),"")

Private nValAnt   := 0


DEFAULT nCol := 0

If Len(MaFisRet(,'NF_IMPOSTOS'))>0
	If lNfCab .And. IIf(nTipo==1,MaFisVldAlt(MaFisRet(,'NF_IMPOSTOS')[nPos][6]),MaFisVldAlt(MaFisRet(,'NF_IMPOSTOS')[nPos][5]))
		
		nBaseAnt := IIf(nTipo==1,aNFCab[NF_IMPOSTOS][nPos][3],aNFCab[NF_IMPOSTOS2][nPos][3])
		nBase    := nBaseAnt
		
		lEditaVal	:= IIf(aScan(aNfCab[NF_RELIMP],{|x|x[3]==AllTrim('IT_VAL'+IIf(nTipo==1,MaFisRet(,'NF_IMPOSTOS')[nPos][6],MaFisRet(,'NF_IMPOSTOS2')[nPos][5]))})>0 ;
		.Or.  aScan(aNfCab[NF_RELIMP],{|x|x[3]==AllTrim('NF_VAL'+IIf(nTipo==1,MaFisRet(,'NF_IMPOSTOS')[nPos][6],MaFisRet(,'NF_IMPOSTOS2')[nPos][5]))})>0 ,.T.,.F.) ;
		.Or. MaFisRet(,'NF_IMPOSTOS')[nPos][6]=="RUR"
		If cPaisLoc <> "BRA"
			lEditaBas := .F.
		Else
			lEditaBas	:= IIf(aScan(aNfCab[NF_RELIMP],{|x|x[3]==AllTrim('IT_BASE'+IIf(nTipo=1,MaFisRet(,'NF_IMPOSTOS')[nPos][6],MaFisRet(,'NF_IMPOSTOS2')[nPos][5]))})>0 ;
			.Or.  aScan(aNfCab[NF_RELIMP],{|x|x[3]==AllTrim('NF_BASE'+IIf(nTipo=1,MaFisRet(,'NF_IMPOSTOS')[nPos][6],MaFisRet(,'NF_IMPOSTOS2')[nPos][5]))})>0 ,.T.,.F.)
		Endif
		
		//������������������������������������������������������Ŀ
		//� Monta a Edicao da Base do imposto                    �
		//��������������������������������������������������������
		If lEditaBas .And. ( nCol == 0 .Or. nCol == 3)
			MaFisEditCell(@nBase,oList,cPictGet,3,'Positivo()')
			If nBaseAnt<>nBase
				If nTipo == 1
					cIniCpo	:= 'IMP_BASE'
					MaFisAlt('IMP_BASE'+MaFisRet(,'NF_IMPOSTOS')[nPos][6],nBase,nPos)
					If Len(aNFCab[NF_IMPOSTOS]) >= nPos
						aNFCab[NF_IMPOSTOS][nPos][3] := nBase
					Else
						lEditaVal := .F.
					EndIf
				Else
					cIniCpo	:= 'NF_BASE'
					MaFisAlt('NF_BASE'+MaFisRet(,'NF_IMPOSTOS2')[nPos][5],nBase,nPos)
					If Len(aNFCab[NF_IMPOSTOS2]) >= nPos
						aNFCab[NF_IMPOSTOS2][nPos][3] := nBase
					Else
						lEditaVal := .F.
					EndIf
				EndIf
				Eval(bValidPrg)
				MaFisRRefresh(oList,nTipo)
			EndIf
		EndIf
		
		If lEditaVal
			
			nValAnt	:= IIf(nTipo==1,aNFCab[NF_IMPOSTOS][nPos][5],aNFCab[NF_IMPOSTOS2][nPos][4])
			nVal	:= nValAnt
			
			If cPaisLoc=="BRA"
				MaFisEditCell(@nVal,oList,cPictGet,IIf(nTipo==1,5,4),'Positivo()')
			Else
				MaFisEditCell(@nVal,oList,cPictGet,IIf(nTipo==1,5,4),'LocxValImp(ReadVar(),nValAnt)')
			Endif
			If nValAnt<>nVal
				If nTipo == 1
					MaFisAlt('IMP_VAL'+MaFisRet(,'NF_IMPOSTOS')[nPos][6],nVal,nPos)
					If Len(aNFCab[NF_IMPOSTOS]) >= nPos
						aNFCab[NF_IMPOSTOS][nPos][5] := nVal
					Endif
				Else
					MaFisAlt('NF_VAL'+MaFisRet(,'NF_IMPOSTOS2')[nPos][5],nVal,nPos)
					If Len(aNFCab[NF_IMPOSTOS2]) >= nPos
						aNFCab[NF_IMPOSTOS2][nPos][4] := nVal
					Endif
				EndIf
				Eval(bValidPrg)
				MaFisRRefresh(oList,nTipo)
			EndIf
		EndIf
	EndIf
Endif

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisInser� Autor � Edson Maricate        � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Insere um novo Imposto na NF.                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisInsereImp(oList,bValidPrg,nTipo)

Local oDlg
Local oCombo
Local lOk		:= .F.
Local nPos		:= oList:nAT
Local lInsere	:= .F.
Local aImpostos	:= { 'IRRF Imposto de Renda','ISS Imp. Servi�o','I.C.M.S','IPI','ICMS Retido','INSS','PIS - Via Apura��o','COFINS - Via Apura��o','PIS - Via Reten�ao','COFINS - Via Reten�ao','CSLL - Via Reten�ao'}
Local aImpCod	:= { 'IRR','ISS','ICM','IPI','SOL','INS','PS2','CF2','PIS','COF','CSL' }
Local nBase		:= 0
Local nValor	:= 0
Local cImposto	:= aImpostos[1]

lInsere := If( MaFisFound("NF"), AllTrim(IIf(nTipo==1,Len(MaFisRet(,'NF_IMPOSTOS'))>0 .And. MaFisRet(,'NF_IMPOSTOS')[nPos][6],Len(MaFisRet(,'NF_IMPOSTOS2'))>0 .And. MaFisRet(,'NF_IMPOSTOS2')[nPos][5]))=="NEW", .F. )

If lInsere .And. cPaisLoc=="BRA"

	DEFINE MSDIALOG oDlg FROM 119,147 TO 270,480 TITLE 'Impostos' Of oMainWnd PIXEL

	@ 22 ,9   SAY 'Imposto' Of oDlg PIXEL SIZE 41 ,9
	@ 21 ,34  MSCOMBOBOX oCombo VAR cImposto ITEMS aImpostos SIZE 106,50 OF oDlg PIXEL
	@ 43 ,9   SAY 'Base' Of oDlg PIXEL SIZE 28 ,9
	@ 59 ,9   SAY 'Valor' Of oDlg PIXEL SIZE 42 ,9
	@ 42 ,34  MSGET nBase  Picture "@E 999,999,999,999.99" Valid Positivo(nBase) OF oDlg PIXEL SIZE 75 ,9

	@ 60 ,34  MSGET nValor Picture "@E 999,999,999,999.99" Valid Positivo(nValor) OF oDlg PIXEL SIZE 75 ,9

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()}) CENTERED

EndIf

If lOk
	If nBase > 0 .Or. aImpCod[aScan(aImpostos,cImposto)] $ "PIS,COF,CSL,IRR"
		MaFisAlt("NF_BASE"+aImpCod[aScan(aImpostos,cImposto)],nBase,)
	EndIf
	If nValor > 0 .Or. aImpCod[aScan(aImpostos,cImposto)] $ "PIS,COF,CSL,IRR" 
		MaFisAlt("NF_VAL"+aImpCod[aScan(aImpostos,cImposto)],nValor,)
	EndIf
	If nBase+nValor>0
		MaFisRRefresh(oList,nTipo)
		Eval(bValidPrg)
	EndIf
EndIf

Return .T.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisEditCellLine� Autor � Edson Maricate � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria um Get para edicao do Imposta no ListBox.              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisEditCell(nValor,oBrowse,cPict,nCol,cValidCpo)
Local oDlg
Local oRect
Local oGet1
Local oBtn
Local cMacro := ''
Local nRow   := oBrowse:nAt
Local oOwner := oBrowse:oWnd
Local cValid := IIf(cValidCpo==Nil,'.T.',cValidCpo)+'.And.Eval(bChange)'


bChange := { ||  nValor := &cMacro,oBrowse:aArray[nRow,nCol] := &cMacro }
oRect := tRect():New(0,0,0,0)            // obtem as coordenadas da celula (lugar onde
oBrowse:GetCellRect(nCol,,oRect)   // a janela de edicao deve ficar)
aDim  := {oRect:nTop,oRect:nLeft,oRect:nBottom,oRect:nRight}

DEFINE MSDIALOG oDlg OF oOwner  FROM 0, 0 TO 0, 0 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL

cMacro := "M->CELL"
&cMacro:= nValor
cPict  := cPict

@ 0,0 MSGET oGet1 VAR &(cMacro) SIZE 0,0 OF oDlg FONT oOwner:oFont PICTURE cPict PIXEL HASBUTTON VALID &cValid
oGet1:Move(-2,-2, (aDim[ 4 ] - aDim[ 2 ]) + 4, aDim[ 3 ] - aDim[ 1 ] + 4 )

@ 0,0 BUTTON oBtn PROMPT "ze" SIZE 0,0 OF oDlg
oBtn:bGotFocus := {|| oDlg:nLastKey := VK_RETURN, oDlg:End(0)}

oGet1:cReadVar  := cMacro

ACTIVATE MSDIALOG oDlg ON INIT oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])

oBrowse:nAt := nRow
SetFocus(oBrowse:hWnd)
oBrowse:Refresh()

Return Nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRRefresh� Autor � Edson Maricate     � Data �13.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o Refresh no ListBox.                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function MaFisRRefresh(oList,nTipo)

Local aTemp
Local nPosDum := 0

If nTipo == 1
	aTemp := IIf(!Empty(aNfCab),aNfCab[NF_IMPOSTOS],{{"","",0,0,0}})
Else
	aTemp := IIf(!Empty(aNfCab),aNfCab[NF_IMPOSTOS2],{{"","",0,0}})
EndIf

If cPaisLoc == "ARG"
	nPosDum	:=	Ascan(aTemp,{|x| x[1] == "DUM"})
	If nPosDum > 0
		aDel(aTemp,nPosDum)
		aSize(aTemp,Len(aTemp)-1)
	Endif	
Endif	

If ValType(oList)<>"U" 
	oList:SetArray(aTemp)
	oList:bLine := {|| MaFisLine(oList,aTemp,nTipo) }
	oList:Refresh()
EndIf	
	
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MaFisRef � Autor � Edson Maricate        � Data � 10.12.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa o calculo dos valores do item da NF.               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Referencia                                         ���
���          � ExpC2 = Identificador do arquivo                           ���
���          � ExpC1 = Valor da Referencia                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA100 / MATA910                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRef(cReferencia,cProg,xValor)
Local aArea	   := GetArea()
Local lRet 	   := .T.
Local nX       := 0
Local nY       := 0
Local cValid   := ""
Local cRefCols := ""
Local cCampo   := ""

If Type('l100') == 'U'
	l100 := .F.
EndIf
If Type('l500') == 'U'
	l500 := .F.
EndIf

Do Case
Case MaFisFound('NF')
	If SubStr(cReferencia,1,2)=="NF"
		If lRet := MaFisVldAlt(cReferencia)
			MaFisAlt(cReferencia,xValor)
			For nY := 1 to Len(aCols)
				If MaFisFound("IT",nY)
					For nX	:= 1 to Len(aHeader)
						cValid	:= AllTrim(UPPER(aHeader[nX][6]))
						If "MAFISREF"$cValid
							nPosRef := AT('MAFISREF("',cValid) + 10
							cRefCols:=Substr(cValid,nPosRef,AT('","'+cProg+'",',cValid)-nPosRef )
							aCols[nY][nX]:= MaFisRet(nY,cRefCols)
						EndIf
					Next
				EndIf
			Next
		EndIf
		Eval(bRefresh)
	Else
		If MaFisFound("IT",N)
			If aNfItem[N][IT_DELETED] .And. IIf(Len(aCols[1])==Len(aHeader)+1,!aCols[N][Len(aHeader)+1],.F.)
				MaFisDel(N,.F.)
			EndIf
		EndIf	
		MaFisIniLoad(n)
		If lRet := MaFisVldAlt(cReferencia,n)
			MaFisAlt(cReferencia,xValor,n)
			For nX	:= 1 to Len(aHeader)
				cValid	:= AllTrim(UPPER(aHeader[nX][6]))
				If "MAFISREF"$cValid
					nPosRef := AT('MAFISREF("',cValid) + 10
					cRefCols:=Substr(cValid,nPosRef,AT('","'+cProg+'",',cValid)-nPosRef )
					aCols[n][nX]:= MaFisRet(n,cRefCols)
				EndIf
			Next
		EndIf
		Eval(bRefresh)
	EndIf
Case l100
	//�������������������������������������������������������������Ŀ
	//� Compatibiliz0acao com o MATA100 p/ v.5.08                    �
	//���������������������������������������������������������������
	cCampo	:= AllTrim(ReadVar())
	Do Case
	Case cCampo ==	'M->D1_COD'
		lRet := A100IniCpo()
	Case cCampo == 'M->D1_VUNIT'
		lRet := IIf(cTipo="D",A100Zera(),.T.) .And. A100Valor()
	Case cCampo == 'M->D1_TOTAL'
		lRet := A100_Multt()
	Case cCampo == 'M->D1_VALIPI'
		lRet := A100Impos()
	Case cCampo == 'M->D1_TES'
		lRet := A100_IniCF()
	Case cCampo == 'M->D1_DESC'
		lRet := A100Impos()
	Case cCampo == 'M->D1_IPI'
		lRet := A100Impos()
	Case cCampo == 'M->D1_PICM'
		lRet := A100Impos()
	Case cCampo == 'M->D1_NFORI'
		lRet := A100Dev()
	Case cCampo == 'M->D1_SERIORI'
		lRet := A100Dev()
	Case cCampo == 'M->D1_ITEMORI'
		lRet := A100ItDev()
	Case cCampo == 'M->D1_BASEICM'
		lRet := A100Impos()
	Case cCampo == 'M->D1_VALDESC'
		lRet := A100VlrDes()
	Case cCampo == 'M->D1_BASEIPI'
		lRet := A100Impos()
	EndCase
Case l500
	//�������������������������������������������������������������Ŀ
	//� Compatibiliz0acao com o MATA920 p/ v.5.08                    �
	//���������������������������������������������������������������
	cCampo	:= AllTrim(ReadVar())
	Do Case
	Case cCampo ==	'M->D2_COD'
		lRet := A100IniCpo()
	Case cCampo == 'M->D2_TOTAL'
		lRet := A100_Multt()
	Case cCampo == 'M->D2_VALIPI'
		lRet := A100Impos()
	Case cCampo == 'M->D2_TES'
		lRet := A100_IniCF()
	Case cCampo == 'M->D2_DESC'
		lRet := A100Impos()
	Case cCampo == 'M->D2_DESCON'
		lRet := A100Impos()
	Case cCampo == 'M->D2_IPI'
		lRet := A100Impos()
	Case cCampo == 'M->D2_PICM'
		lRet := A100Impos()
	Case cCampo == 'M->D2_BASEICM'
		lRet := A100Impos()
	EndCase
EndCase

RestArea(aArea)
Return lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaIniRef� Autor � Edson Maricate          � Data � 10.12.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inicializa as variaveis utilizadas no Retorno Fiscal       ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaIniRef()
Local nG
Local lArredBra	:=	(cPaisLoc == "BRA")

aItemRef	:= {}
aCabRef		:= {}
aLFIs		:= {}
aResRef		:= {}

aadd(aItemRef,{"IT_GRPTRIB","1",15,.F.,.F.})      //Grupo de Tributacao
aadd(aItemRef,{"IT_EXCECAO","2",,.F.,.F.})  		//Array da EXCECAO Fiscal
aadd(aItemRef,{"IT_ALIQICM","3",40,.F.,.F.}) 		//Aliquota de ICMS
aadd(aItemRef,{"IT_ICMS","4",,.F.,.F.})  			//Array contendo os valores de ICMS
aadd(aItemRef,{"IT_BASEICM",{4,1},70,lArredBra,.F.})		//Valor da Base de ICMS
aadd(aItemRef,{"IT_VALICM",{4,2},80,lArredBra,.F.})		//Valor do ICMS Normal
aadd(aItemRef,{"IT_BASESOL",{4,3},100,lArredBra,.F.})	//Base do ICMS Solidario
aadd(aItemRef,{"IT_ALIQSOL",{4,4},40,.F.,.F.})		//Aliquota do ICMS Solidario
aadd(aItemRef,{"IT_VALSOL",{4,5},110,lArredBra,.T.})		//Valor do ICMS Solidario
aadd(aItemRef,{"IT_MARGEM",{4,6},90,.F.,.F.})		//Margem de lucro para calculo da Base do ICMS Sol.
aadd(aItemRef,{"IT_BICMORI",{4,7},,lArredBra,.F.})		//Valor original da Base de ICMS
aadd(aItemRef,{"IT_ALIQCMP",{4,8},40,.F.,.F.})		//Aliquota para calculo do ICMS Complementar
aadd(aItemRef,{"IT_VALCMP",{4,9},80,lArredBra,.F.})		//Valor do ICMS Complementar
aadd(aItemRef,{"IT_BASEICA",{4,10},71,lArredBra,.F.}) 	//Base do ICMS sobre o frete autonomo
aadd(aItemRef,{"IT_VALICA",{4,11},81,lArredBra,.F.})  	//Valor do ICMS sobre o frete autonomo
	aadd(aItemRef,{"IT_DEDICM",{4,12},80,lArredBra,.F.})  	//Valor da deducao do ICMS
aadd(aItemRef,{"IT_ALIQIPI","5",40,.F.,.F.})  		//Aliquota de IPI
aadd(aItemRef,{"IT_IPI","6",,.F.,.F.})  			//Array contendo os valores de IPI
aadd(aItemRef,{"IT_BASEIPI",{6,1},50,lArredBra,.F.})		//Valor da Base do IPI
aadd(aItemRef,{"IT_VALIPI",{6,2},60,lArredBra,GetNewPar("MV_RNDIPI",.F.)})		//Valor do IPI
aadd(aItemRef,{"IT_BIPIORI",{6,3},,lArredBra,.F.})		//Valor da Base Original do IPI
aadd(aItemRef,{"IT_NFORI","7",20,.F.,.F.})  		//Numero da NF Original
aadd(aItemRef,{"IT_SERORI","8",20,.F.,.F.})  		//Serie da NF Original
aadd(aItemRef,{"IT_RECORI","9",20,.F.,.F.})  		//RecNo da NF Original (SD1/SD2)
aadd(aItemRef,{"IT_DESCONTO","10",20,.T.,.F.})		//Valor do Desconto
aadd(aItemRef,{"IT_FRETE","11",20,.T.,.F.}) 		//Valor do Frete
aadd(aItemRef,{"IT_DESPESA","12",20,.T.,.F.}) 		//Valor das Despesas Acessorias
aadd(aItemRef,{"IT_SEGURO","13",20,.T.,.F.}) 		//Valor do Seguro
aadd(aItemRef,{"IT_AUTONOMO","14",20,.T.,.F.})		//Valor do Frete Autonomo
aadd(aItemRef,{"IT_VALMERC","15",,.F.,.F.}) 		//Valor da mercadoria
aadd(aItemRef,{"IT_PRODUTO","16",10,.F.,.F.}) 		//Valor da mercadoria
aadd(aItemRef,{"IT_TES","17",20,.F.,.F.}) 			//Codigo da TES
aadd(aItemRef,{"IT_TOTAL","18",,.T.,.F.}) 			//Valor Total do Item
aadd(aItemRef,{"IT_CF","19",30,.F.,.F.}) 			//Codigo Fiscal de operacao
aadd(aItemRef,{"IT_FUNRURAL","20",,lArredBra,.F.})		//Valor do FunRural do Item
aadd(aItemRef,{"IT_PERFUN","21",,.F.,.F.}) 		//Aliquota para calculo do Funrural
aadd(aItemRef,{"IT_DELETED","22",,.F.,.F.})		//Flag de controle para itens deletados
aadd(aItemRef,{"IT_LIVRO","23",,.F.,.F.})			//Array contendo o demonstrativo fiscal
aadd(aItemRef,{"IT_ISS","24",,.F.,.F.})			//Array contendo os valores de ISS
aadd(aItemRef,{"IT_ALIQISS",{24,1},40,.F.,.F.})	//Aliquota de ISS do item
aadd(aItemRef,{"IT_BASEISS",{24,2},,lArredBra,.F.})		//Base de Calculo do ISS
aadd(aItemRef,{"IT_VALISS",{24,3},,.T.,SuperGetMV("MV_RNDISS")}) 		//Valor do ISS do item
aadd(aItemRef,{"IT_CODISS",{24,4},,.F.,.F.}) 		//Codigo Servico do item
aadd(aItemRef,{"IT_IR","25",,.F.,.F.})				//Array contendo os valores do Imposto de renda
aadd(aItemRef,{"IT_BASEIRR",{25,1},,.T.,.F.})		//Base do Imposto de Renda do item
aadd(aItemRef,{"IT_REDIR",{25,2},,.F.,.F.}) 		//Percentual de Reducao da Base de calculo do IR
aadd(aItemRef,{"IT_ALIQIRR",{25,3},40,.F.,.F.}) 	//Percentual de calculo do Imposto de Renda
aadd(aItemRef,{"IT_VALIRR",{25,4},,lArredBra,.F.}) 		//Valor do Imposto de Renda do item
aadd(aItemRef,{"IT_INSS","26",,.F.,.F.})			//Array contendo os valores de INSS
aadd(aItemRef,{"IT_BASEINS",{26,1},,lArredBra,.F.}) 		//Base de calculo do INSS
aadd(aItemRef,{"IT_REDINSS",{26,2},,.F.,.F.})  	//Percentual de Reducao da Base de Calculo do INSS
aadd(aItemRef,{"IT_ALIQINS",{26,3},,.F.,.F.}) 		//Aliquota de calculo do INSS
aadd(aItemRef,{"IT_VALINS",{26,4},,lArredBra,.F.})  		//Valor do INSS do item
aadd(aItemRef,{"IT_VALEMB","27",,.T.,.F.})  		//Valor da embalagem do item
aadd(aItemRef,{"IT_BASEIMP","28",,.F.,.F.}) 	 	//Bases dos Impostos Variaveis
For nG:=1 To NMAXIV
	aadd(aItemRef,{"IT_BASEIV"+NumCpoImpVar(nG),{28,nG},,.T.,.F.})
Next
aadd(aItemRef,{"IT_ALIQIMP","29",,.F.,.F.})  	 	//Aliquotas dos Impostos Variaveis
For nG:=1 To NMAXIV
	aadd(aItemRef,{"IT_ALIQIV"+NumCpoImpVar(nG),{29,nG},,.F.,.F.})
Next
aadd(aItemRef,{"IT_VALIMP","30",,.F.,.F.})  	 	//Valores dos Impostos Variaveis
For nG:=1 To NMAXIV
	aadd(aItemRef,{"IT_VALIV"+NumCpoImpVar(nG),{30,nG},,.T.,.F.})
Next
aadd(aItemRef,{"IT_BASEDUP","31",,.T.,.F.}) 		//Valor da embalagem do item
aadd(aItemRef,{"IT_DESCZF","32",,lArredBra,.F.})			//Valor do desconto na ZOna Franca do Item
aadd(aItemRef,{"IT_DESCIV","33",,.F.,.F.})  		//Descricao dos Impostos Variaveis
aadd(aItemRef,{"IT_QUANT","34",,.F.,.F.})			//Quantidade do Item
aadd(aItemRef,{"IT_PRCUNI","35",,.F.,.F.})  		//Preco Unitario do Item
aadd(aItemRef,{"IT_VIPIBICM","36",,lArredBra,.F.})		//Valor do IPI Incidente na Base de ICMS
aadd(aItemRef,{"IT_PESO","37",,.F.,.F.})			// Peso do Item
aadd(aItemRef,{"IT_ICMFRETE","38",82,lArredBra,.F.})  	//Valor do ICMS Relativo ao Frete
aadd(aItemRef,{"IT_BSFRETE","39",72,lArredBra,.F.})		//Base do ICMS Relativo ao Frete
aadd(aItemRef,{"IT_BASECOF","40",,lArredBra,.F.})		//Base de calculo do COFINS
aadd(aItemRef,{"IT_ALIQCOF","41",40,lArredBra,.F.})		//Aliquota de calculo do COFINS
aadd(aItemRef,{"IT_VALCOF","42",,lArredBra,GetNewPar("MV_RNDCOF",.F.)})			//Valor do COFINS
aadd(aItemRef,{"IT_BASECSL","43",,lArredBra,.F.})	 	//Base de calculo do CSLL
aadd(aItemRef,{"IT_ALIQCSL","44",40,lArredBra,.F.})		//Aliquota de calculo do CSLL
aadd(aItemRef,{"IT_VALCSL","45",,lArredBra,GetNewPar("MV_RNDCSL",.F.)})			//Valor do CSLL
aadd(aItemRef,{"IT_BASEPIS","46",,lArredBra,.F.})		//Base de calculo do PIS
aadd(aItemRef,{"IT_ALIQPIS","47",40,lArredBra,.F.})		//Aliquota de calculo do PIS
aadd(aItemRef,{"IT_VALPIS","48",,lArredBra,GetNewPar("MV_RNDPIS",.F.)})			//Valor do PIS
aadd(aItemRef,{"IT_RECNOSB1","49",,.T.,.F.})		//RecNo SB1
aadd(aItemRef,{"IT_RECNOSF4","50",,.T.,.F.})		//RecNo SF4
aadd(aItemRef,{"IT_VNAGREG","51",,.T.,.F.})		//Valor da mercadoria nao agregado ao NF_VALMERC
aadd(aItemRef,{"IT_REMITO","53",,.F.,.F.})		   //Numetro do remito
aadd(aItemRef,{"IT_BASEPS2","54",,lArredBra,.F.})		//Base de calculo do PIS 2
aadd(aItemRef,{"IT_ALIQPS2","55",40,lArredBra,.F.})		//Aliquota de calculo do PIS 2
aadd(aItemRef,{"IT_VALPS2","56",,.T.,GetNewPar("MV_RNDPS2",.F.)})			//Valor do PIS 2
aadd(aItemRef,{"IT_BASECF2","57",,lArredBra,.F.})		//Base de calculo do COFINS 2
aadd(aItemRef,{"IT_ALIQCF2","58",40,lArredBra,.F.})		//Aliquota de calculo do COFINS 2
aadd(aItemRef,{"IT_VALCF2","59",,.T.,GetNewPar("MV_RNDCF2",.F.)})			//Valor do COFINS 2
aadd(aItemRef,{"IT_ABVLINSS","60",,.F.,.F.})	 //Abatimento da base do INSS em valor 
aadd(aItemRef,{"IT_ABVLISS","61",,.F.,.F.})	 //Abatimento da base do INSS em valor 
aadd(aItemRef,{"IT_REDISS","62",,.F.,.F.})	 //Reducao opcional de base do ISS 
aadd(aItemRef,{"IT_ICMSDIF","63",,.F.,.F.})	 //Valor do ICMS diferido
aadd(aItemRef,{"IT_DESCZFPIS","64",,.F.,.F.})	 //Valor do PIS descontado - ZF
aadd(aItemRef,{"IT_DESCZFCOF","65",,.F.,.F.})	 //Valor do COFINS descontado - ZF
aadd(aItemRef,{"IT_BASEAFRMM","66",,lArredBra,.F.})	//Base de calculo do AFRMM
aadd(aItemRef,{"IT_ALIQAFRMM","67",,lArredBra,.F.})	//Aliquota de calculo do AFRMM
aadd(aItemRef,{"IT_VALAFRMM","68",,lArredBra,.F.})		//Valor do AFRMM

aadd(aCabRef,{"NF_TIPONF","1",.F.})
aadd(aCabRef,{"NF_OPERNF","2",.F.}) 			//E-Entrada | S - Saida
aadd(aCabRef,{"NF_CLIFOR","3",.F.})  			//C-Cliente | F - Fornecedor
aadd(aCabRef,{"NF_TPCLIFOR","4",.F.})  		//Tipo do destinatario R,F,S,X
aadd(aCabRef,{"NF_LINSCR","5",.F.})  			//Indica se o destino possui inscricao estadual
aadd(aCabRef,{"NF_GRPCLI","6",.F.})  			//Grupo de Tributacao
aadd(aCabRef,{"NF_UFDEST","7",.F.})  			//UF do Destinatario
aadd(aCabRef,{"NF_UFORIGEM","8",.F.})	 		//UF de Origem
aadd(aCabRef,{"NF_DESCONTO","10",.T.})			//Valor Total do Deconto
aadd(aCabRef,{"NF_FRETE","11",.T.}) 			//Valor Total do Frete
aadd(aCabRef,{"NF_DESPESA","12",.T.})			//Valor Total das Despesas Acessorias
aadd(aCabRef,{"NF_SEGURO","13",.T.}) 			//Valor Total do Seguro
aadd(aCabRef,{"NF_AUTONOMO","14",.T.})			//Valor Total do Frete Autonomo
aadd(aCabRef,{"NF_ICMS","15",.F.}) 			//Array contendo os valores de ICMS
aadd(aCabRef,{"NF_BASEICM",{15,1},.T.}) 		//Valor da Base de ICMS
aadd(aCabRef,{"NF_VALICM",{15,2},.T.})			//Valor do ICMS Normal
aadd(aCabRef,{"NF_BASESOL",{15,3},.T.})		//Base do ICMS Solidario
aadd(aCabRef,{"NF_VALSOL",{15,4},.T.})			//Valor do ICMS Solidario
aadd(aCabRef,{"NF_BICMORI",{15,5},.T.})		//Valor do ICMS Complementar
aadd(aCabRef,{"NF_VALCMP",{15,6},.T.})			//Valor do ICMS Complementar
aadd(aCabRef,{"NF_BASEICA",{15,7},.T.})   	  	//Base do ICMS sobre o Frete Autonomo
aadd(aCabRef,{"NF_VALICA",{15,8},.T.})    		//Valor do ICMS sobre o Frete Autonomo
aadd(aCabRef,{"NF_IPI","16",.F.})  			//Array contendo os valores de IPI
aadd(aCabRef,{"NF_BASEIPI",{16,1},.T.})		//Valor da Base do IPI
aadd(aCabRef,{"NF_VALIPI",{16,2},.T.})			//Valor do IPI
aadd(aCabRef,{"NF_BIPIORI",{16,3},.T.})		//Valor da Base Original do IPI
aadd(aCabRef,{"NF_TOTAL","17",.T.})			//Valor Total da NF
aadd(aCabRef,{"NF_VALMERC","18",.T.})			//Valor Total das mercadorias
aadd(aCabRef,{"NF_FUNRURAL","19",.T.})   		//Valor Total do Funrural
aadd(aCabRef,{"NF_CODCLIFOR","20",.F.})		//Codigo do Cliente/Fornecedor
aadd(aCabRef,{"NF_LOJA","21",.F.})	      		//Loja do Cliente/Fornecedor
aadd(aCabRef,{"NF_LIVRO","22",.F.})   			//Array contendo os demonstrativos fiscais
aadd(aCabRef,{"NF_ISS","23",.F.}) 				//Array contendo os Valores de ISS
aadd(aCabRef,{"NF_BASEISS",{23,1},.T.})		//Base de Calculo do ISS
aadd(aCabRef,{"NF_VALISS",{23,2},.T.})			//Valor do ISS
aadd(aCabRef,{"NF_IR","24",.F.})		 		//Array contendo os valores do Imposto de renda
aadd(aCabRef,{"NF_BASEIRR",{24,1},.T.})		//Base do Imposto de Renda do item
aadd(aCabRef,{"NF_VALIRR",{24,2},.T.})			//Valor do IR do item
aadd(aCabRef,{"NF_INSS","25",.F.})				//Array contendo os valores de INSS
aadd(aCabRef,{"NF_BASEINS",{25,1},.T.})		//Base de calculo do INSS
aadd(aCabRef,{"NF_VALINS",{25,2},.T.})			//Valor do INSS do item
aadd(aCabRef,{"NF_NATUREZA","26",.F.})			//Natureza utilizada na geracao dos titulos no financeiro.
aadd(aCabRef,{"NF_VALEMB","27",.T.})			//Valor da Embalagem
aadd(aCabRef,{"NF_IMPOSTOS","30",.T.})			//Array contendo o resumo de Impostos
aadd(aCabRef,{"NF_BASEDUP","31",.T.})			//Array contendo o resumo de Impostos
aadd(aCabRef,{"NF_RELIMP","32",.F.})			//Array contendo o resumo de Impostos
aadd(aCabRef,{"NF_IMPOSTOS2","33",.T.})		//Array contendo o resumo de Impostos
aadd(aCabRef,{"NF_DESCZF","34",.T.})			//Valor total do Desconto da Zona Franca
aadd(aCabRef,{"NF_SUFRAMA","35",.T.})			//Valor total do Desconto da Zona Franca
aadd(aCabRef,{"NF_BASEIMP","36",.F.})			//Array contendo as Bases de Impostos Variaveis
For nG:=1 To NMAXIV
	aadd(aCabRef,{"NF_BASEIV"+NumCpoImpVar(nG),{36,nG},.T.})
Next
aadd(aCabRef,{"NF_VALIMP","37",.F.})   		//Array contendo os valores de Impostos Agentina/Chile/Etc.
For nG:=1 To NMAXIV
	aadd(aCabRef,{"NF_VALIV"+NumCpoImpVar(nG),{37,nG},.T.})
Next
aadd(aCabRef,{"NF_TPCOMP","38",.F.})    		//Tipo de complemento  - F Frete , D Despesa Imp.
aadd(aCabRef,{"NF_INSIMP","39",.F.})	  		//Flag de Controle : Indica se podera inserir Impostos no Rodape.
aadd(aCabRef,{"NF_PESO","40",.T.})  		    //Peso Total das mercadorias da NF
aadd(aCabRef,{"NF_ICMFRETE","41",.T.}) 		//Valor do ICMS relativo ao frete
aadd(aCabRef,{"NF_BSFRETE","42",.T.})   		//Base do ICMS relativo ao frete
aadd(aCabRef,{"NF_BASECOF","43",.T.})   		//Base de calculo do COFINS
aadd(aCabRef,{"NF_VALCOF","44",.T.})	  		//Valor do COFINS
aadd(aCabRef,{"NF_BASECSL","45",.T.})	  		//Base de calculo do CSLL
aadd(aCabRef,{"NF_VALCSL","46",.T.})	  		//Valor do CSLL
aadd(aCabRef,{"NF_BASEPIS","47",.T.})	  		//Base de calculo do PIS
aadd(aCabRef,{"NF_VALPIS","48",.T.})	  		//Valor do PIS
aadd(aCabRef,{"NF_AUXACUM","50",.T.})	  		//Acumulador para calculo de impostos
aadd(aCabRef,{"NF_ALIQIR","51",.T.})	  		//Aliquota de IRF do Cliente
aadd(aCabRef,{"NF_VNAGREG","52",.T.}) 		    //Valor da mercadoria nao agregado ao NF_VALMERC
aadd(aCabRef,{"NF_RECISS","56"})	             //Recolhe ISS
aadd(aCabRef,{"NF_MOEDA","58",.T.})	  	    //Moeda da nota fiscal
aadd(aCabRef,{"NF_TXMOEDA","59",.F.}) 		    //Taxa da moeda para a nota atual
aadd(aCabRef,{"NF_SERIENF","60",.F.}) 		    //Serie da nota fiscal
aadd(aCabRef,{"NF_TIPODOC","61",.F.}) 			//Tipo de documento (localizacoes)
aadd(aCabRef,{"NF_MINIMP","62",.F.}) 			//Minimo PARA CALCULAR IMPOSTOS VARIAVEIS
For nG:=1 To NMAXIV
	aadd(aCabRef,{"NF_MINIV"+NumCpoImpVar(nG),{62,nG},.T.})
Next
aadd(aCabRef,{"NF_BASEPS2","63",.T.})	        //Base de calculo do PIS 2
aadd(aCabRef,{"NF_VALPS2","64",.T.})	        //Valor do PIS 2
aadd(aCabRef,{"NF_ESPECIE","65",.F.})	        //Especie do Documento
aadd(aCabRef,{"NF_CNPJ","66",.F.})	        //CNPJ
aadd(aCabRef,{"NF_BASECF2","67",.T.})	        //Base de calculo do COFINS 2
aadd(aCabRef,{"NF_VALCF2","68",.T.})	        //Valor do COFINS 2
aadd(aCabRef,{"NF_ICMSDIF","69",.T.})	        //Valor do ICMS diferido
aadd(aCabRef,{"NF_MODIRF","70",.T.})	        //Modelo de calculo do IRPF
aadd(aCabRef,{"NF_PNF_COD",{71,01},.T.})	    //Codigo do tomador do Frete
aadd(aCabRef,{"NF_PNF_LOJ",{71,02},.T.})	    //Loja   do tomador do Frete
aadd(aCabRef,{"NF_PNF_UF" ,{71,03},.T.})	    //UF do tomador do Frete
aadd(aCabRef,{"NF_BASEAFRMM","73",.T.})		//Base de calculo do AFRMM
aadd(aCabRef,{"NF_VALAFRMM","74",.T.})			//Valor do AFRMM

aadd(aResRef,{"IMP_COD",1})						// Codigo
aadd(aResRef,{"IMP_DESC",2})					// Descricao
aadd(aResRef,{"IMP_BASE",3})					// Base
aadd(aResRef,{"IMP_ALIQ",4})					// Aliquota
aadd(aResRef,{"IMP_VAL",5})						// Valor
aadd(aResRef,{"IMP_NOME",6})					// Nome

aadd(aLFis,{"LF_CFO",1})						// Codigo Fiscal
aadd(aLFis,{"LF_ALIQICMS",2})					// Aliquota de ICMS
aadd(aLFis,{"LF_VALCONT",3})					// Valor Contabil
aadd(aLFis,{"LF_BASEICM",4})					// Base de ICMS
aadd(aLFis,{"LF_VALICM",5})						// Valor do ICMS
aadd(aLFis,{"LF_ISENICM",6})					// ICMS Isento
aadd(aLFis,{"LF_OUTRICM",7})					// ICMS Outros
aadd(aLFis,{"LF_BASEIPI",8})					// Base de IPI
aadd(aLFis,{"LF_VALIPI",9})						// IPI Tributado
aadd(aLFis,{"LF_ISENIPI",10})					// IPI Isento
aadd(aLFis,{"LF_OUTRIPI",11})					// IPI Outros
aadd(aLFis,{"LF_OBSERV",12})					// Observacao
aadd(aLFis,{"LF_VALOBSE",13}) 					// Valor na Observacao
aadd(aLFis,{"LF_ICMSRET",14})					// Valor ICMS Retido
aadd(aLFis,{"LF_LANCAM",15})					// Numero do Lancamento
aadd(aLFis,{"LF_TIPO",16})						// Tipo de Lancamento
aadd(aLFis,{"LF_ICMSCOMP",17})					// ICMS Complementar
aadd(aLFis,{"LF_CODISS",18})					// Cod.Serv. ISS
aadd(aLFis,{"LF_IPIOBS",19})					// IPI na Observacao
aadd(aLFis,{"LF_NFLIVRO",20})					// Numero do Livro
aadd(aLFis,{"LF_ICMAUTO",21})					// ICMS Frete Autonomo
aadd(aLFis,{"LF_BASERET",22})					// Base do ICMS Retido
aadd(aLFis,{"LF_FORMUL",23})					// Flag de Fom. Proprio
aadd(aLFis,{"LF_FORMULA",24})					// Formula
aadd(aLFis,{"LF_DESPESA",25})					// Despesas Acessorias
aadd(aLFis,{"LF_ICMSDIF",26})					// Icms Diferido
aadd(aLFis,{"LF_TRFICM",27})					// Icms Transferido
aadd(aLFis,{"LF_CRDEST",37}) 					// Valor do Credito Estimulo Manaus
aadd(aLFis,{"LF_CRDPRES",38})   				// Valor do Credito Presumido
aadd(aLFis,{"LF_SIMPLES",39})  				    // Valor do ICMS para clientes optantes pelo Simples - SC
aadd(aLFis,{"LF_CRDTRAN",40})  					// Valor do Credito Presumido - RJ - Prestacao de Servico de Transporte
aadd(aLFis,{"LF_CFOEXT",31})  					// CFOP EXTENDIDO
aadd(aLFis,{"LF_CRDZFM",41})   					// Valor do Credito Presumido - Zona Franca de Manaus - Entradas Interestaduais

Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisSave� Autor � Edson Maricate         � Data � 10.12.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Salva a NF atual em uma area temporaria.                    ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function MaFisSave()

If aMaster == Nil
	aMaster := {}
EndIf

aadd(aMaster,{aClone(aNfCab),;
	aClone(aSaveDec),;
	aClone(aNfItem),;
	aClone(aItemDec),;
	bFisRefresh,;
	bLivroRefresh,;
	aClone(aBrwLF),;
	aClone(aStack),;
	aClone(aSaveDec),;
	aClone(aAuxOri),;
	cAliasProd})

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisRestore� Autor � Edson Maricate      � Data � 10.12.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Carrega a NF salva em uma area temporaia.                   ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRestore()

Local nUltimo := Len(aMaster)

aNfCab		 := aClone(aMaster[nUltimo][01])
aSaveDec	 := aClone(aMaster[nUltimo][02])
aNfItem		 := aClone(aMaster[nUltimo][03])
aItemDec	 := aClone(aMaster[nUltimo][04])
bFisRefresh  := aMaster[nUltimo][05]
bLivroRefresh:= aMaster[nUltimo][06]
aBrwLF	     := aClone(aMaster[nUltimo][07])
aStack		 := aClone(aMaster[nUltimo][08])
aSaveDev	 := aClone(aMaster[nUltimo][09])
aAuxOri		 := aClone(aMaster[nUltimo][10])
cAliasProd	 := aMaster[nUltimo][11]

aMaster      := aSize(aMaster,nUltimo-1)

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisIniPC� Autor � Edson Maricate        � Data �20.05.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inicializa as funcoes Fiscais com o Pedido de Compras      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MaFisIniPC(ExpC1,ExpC2)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Numero do Pedido                                  ���
���          � ExpC2 := Item do Pedido                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110,MATR120,Fluxo de Caixa                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function MaFisIniPC(cPedido,cItem,cSequen,cFiltro)

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local cValid	:= ""
Local nPosRef	:= 0
Local nItem		:= 0
Local cItemDe	:= IIf(cItem==Nil,'',cItem)
Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
Local cRefCols	:= ''
DEFAULT cSequen:= ""
DEFAULT cFiltro:= ""

dbSelectArea("SC7")
dbSetOrder(1)
If	MsSeek(xFilial()+cPedido+cItemDe+Alltrim(cSequen))
	MaFisEnd()
	MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
	While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == xFilial()+cPedido .And. ;
			SC7->C7_ITEM <= cItemAte .And. (Empty(cSequen) .Or. cSequen == SC7->C7_SEQUEN)

		//����������������������������������������������������������������Ŀ
		//� Nao processar os Impostos se o item possuir residuo eliminado  �
		//������������������������������������������������������������������ 
        If &cFiltro
			dbSelectArea('SC7')
			dbSkip()
            Loop
        EndIf
            
		//���������������������������������������������Ŀ
		//� Inicia a Carga do item nas funcoes MATXFIS  �
		//�����������������������������������������������
		nItem++
		MaFisIniLoad(nItem)
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek('SC7')
		While !EOF() .And. (X3_ARQUIVO == 'SC7')
			cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
			cValid	:= StrTran(cValid,"'",'"')
			If "MAFISREF"$cValid
				nPosRef := AT('MAFISREF("',cValid) + 10
				cRefCols:=Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
				//���������������������������������������������Ŀ
				//� Carrega os valores direto do SC7.           �
				//�����������������������������������������������
				MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
			EndIf
			dbSkip()
		End
		MaFisEndLoad(nItem,2)
		dbSelectArea('SC7')
		dbSkip()
	End
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisRelImp� Autor � Edson Maricate       � Data �21.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna um array contendo todos os impostos suportados pelos���
���          �arquivos passados para a funcao.                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 : Codigo de referencia ao programa                    ���
���          �ExpA2 : Array contendo o Alias dos arquivos                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA103,MATA116,MATA119,MATA150,MATA120,MATA930             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRelImp(cProg,aAlias)

Local aArea		:= GetArea()
Local aAreaSX3	:= SX3->(GetArea())
Local aRet		:= {}
Local nAlias    := 0
Local nX        := 0
Local nY        := 0

DEFAULT aRefSX3 := {}

For nX 	:= 1 to Len(aAlias)
	//���������������������������������������������������������Ŀ
	//�Verifica se o alias solicitado esta no cache de memoria  �
	//�����������������������������������������������������������
	nAlias := aScan(aRefSX3,{|x| x[1] == aAlias[nX]})
	If nAlias == 0
		//���������������������������������������������������������Ŀ
		//�Adiciona as referencia ao cache de memoria               �
		//�����������������������������������������������������������
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek(aAlias[nX])
		While !EOF() .And. (X3_ARQUIVO == aAlias[nX])
			//���������������������������������������������������Ŀ
			//� Ajuste na referencia de impostos - SF2  v.508     �
			//�����������������������������������������������������
			If aAlias[nX]=="SF2"
				Do Case
				Case AllTrim(X3_CAMPO) == "F2_VALCSLL" .And. !("MAFISREF"$UPPER(X3_VALID))
					RecLock("SX3",.F.)
					X3_VALID	:= 'MAFISREF("NF_VALCSL","MT100",M->F2_VALCSLL)'
					MsUnlock()
				Case AllTrim(X3_CAMPO) == "F2_VALCOFI" .And. !("MAFISREF"$UPPER(X3_VALID))
					RecLock("SX3",.F.)
					X3_VALID	:= 'MAFISREF("NF_VALCOF","MT100",M->F2_VALCOFI)'
					MsUnlock()
				Case AllTrim(X3_CAMPO) == "F2_VALPIS" .And. !("MAFISREF"$UPPER(X3_VALID))
					RecLock("SX3",.F.)
					X3_VALID	:= 'MAFISREF("NF_VALPIS","MT100",M->F2_VALPIS)'
					MsUnlock()
				Case cPaisLoc <> "BRA" .And. AllTrim(X3_CAMPO) == "F2_TIPODOC" .And. !("MAFISREF"$UPPER(X3_VALID))
					RecLock("SX3",.F.)
					X3_VALID	:= 'MAFISREF("NF_TIPODOC","MT100",M->F2_TIPODOC)'
					MsUnlock()
				Case cPaisLoc <> "BRA" .AND. AllTrim(X3_CAMPO) == "F2_SERIE" .And. !("MAFISREF"$UPPER(X3_VALID))
					RecLock("SX3",.F.)
					X3_VALID	:= 'MAFISREF("NF_SERIENF","MT100",M->F2_SERIE)'
					MsUnlock()
				EndCase
			ElseIf aAlias[nX]=="SF1"
      		Do case
					Case AllTrim(X3_CAMPO) == "F1_VALCSLL" .And. !("MAFISREF"$UPPER(X3_VALID))
						RecLock("SX3",.F.)
						X3_VALID	:= 'MAFISREF("NF_VALCSL","MT100",M->F1_VALCSLL)'
						MsUnlock()
					Case AllTrim(X3_CAMPO) == "F1_VALCOFI" .And. !("MAFISREF"$UPPER(X3_VALID))
						RecLock("SX3",.F.)
						X3_VALID	:= 'MAFISREF("NF_VALCOF","MT100",M->F1_VALCOFI)'
						MsUnlock()
					Case AllTrim(X3_CAMPO) == "F1_VALPIS" .And. !("MAFISREF"$UPPER(X3_VALID))
						RecLock("SX3",.F.)
						X3_VALID	:= 'MAFISREF("NF_VALPIS","MT100",M->F1_VALPIS)'
						MsUnlock()
					Case  cPaisLoc <> "BRA" .AND. AllTrim(X3_CAMPO) == "F1_SERIE" .And. !("MAFISREF"$UPPER(X3_VALID))
						RecLock("SX3",.F.)
						X3_VALID	:= 'MAFISREF("NF_SERIENF","MT100",M->F1_SERIE)'
						MsUnlock()
					Case cPaisLoc <> "BRA" .And. AllTrim(X3_CAMPO) == "F1_TIPODOC" .And. !("MAFISREF"$UPPER(X3_VALID))
						RecLock("SX3",.F.)
						X3_VALID	:= 'MAFISREF("NF_TIPODOC","MT100",M->F1_TIPODOC)'
						MsUnlock()
				EndCase
			EndIf
			If "MAFISREF"$AllTrim(UPPER(SX3->X3_VALID))
				//����������������������������������������������������Ŀ
				//� Cria o Array contendo a relacao Campo x Referencia �
				//� [RELIMP] : [1] - Alias                             �
				//�            [2] - Campo                             �
				//�            [3] - Referencia                        �
				//������������������������������������������������������
				aadd(aRefSX3,{aAlias[nX],AllTrim(X3_CAMPO),MaFisGetRF(SX3->X3_VALID)[1]})
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
	EndIf
	//���������������������������������������������������������Ŀ
	//�Obtem as referencias do cache de memoria                 �
	//�����������������������������������������������������������
	For nY := 1 To Len(aRefSX3)
		If aRefSx3[nY][1] == aAlias[nX]
			aadd(aRet,{aAlias[nX],aRefSx3[nY][2],aRefSx3[nY][3]})
		EndIf
	Next nY
Next nX
RestArea(aAreaSX3)
RestArea(aArea)

Return aRet
/*/
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaColsToFi� Autor �Edson Maricate         � Data �01.02.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina carregamento da funcao fiscal com base no acols e     ���
���          �aheader                                                      ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: Variavel com a estrutura do aHeader                   ���
���          �ExpA2: Variavel com a estrutura do aCols                     ���
���          �ExpN3: Item a ser carregado                             (OPC)���
���          �ExpC4: Nome do programa                                 (OPC)���
���          �ExpL5: Indica se o recalculo dos impostos deve ser feito(OPC)���
���          �ExpL6: Indica se o recalculo dos impostos deve ser feito(OPC)���
���          �ExpL7: Indica se o recalculo vai considerar as linhs apagadas���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo inicializar a variavel aNFItem ���
���          �com base no aCols                                            ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Function MaColsToFis(aHeader,aCols,nItem,cProg,lRecalc,lVisual,lDel,lSoItem)

Local nX       := 0
Local nY       := 0
Local cValid   := ""
Local nItemIni := IIf(nItem==Nil,1,nItem)
Local nItemAte := IIf(nItem==Nil,Len(aCols),nItem)

DEFAULT lRecalc 	:= .F.
DEFAULT lVisual	:= .F.
DEFAULT lDel		:= .F.	//Indica que a linha deletada do acols nao sera considerada
DEFAULT lSoItem	:=	.F.

If nItem == Nil
	MaFisClear()
EndIf

For nY := nItemIni to nItemAte
	//���������������������������������������������Ŀ
	//� Inicia a Carga do item nas funcoes MATXFIS  �
	//�����������������������������������������������
	MaFisIniLoad(nY,,.T.)
	For nX	:= 1 To Len(aHeader)
		cValid	:= AllTrim(UPPER(aHeader[nX][6]))
		cRefCols := MaFisGetRf(cValid)[1]
		If !Empty(cRefCols) .And. MaFisFound("IT",nY)
			//���������������������������������������������Ŀ
			//� Carrega os valores direto do SD1.           �
			//�����������������������������������������������
			MaFisLoad(cRefCols,aCols[nY][nX],nY)
		EndIf
	Next nX
	If lRecalc
		MaFisRecal("IT_",nY)
		For nX	:= 1 To Len(aHeader)
			cValid	:= AllTrim(UPPER(aHeader[nX][6]))
			cRefCols := MaFisGetRf(cValid)[1]
			If !Empty(cRefCols) .And. MaFisFound("IT",nY)
				aCols[nY][nX]:= MaFisRet(nY,cRefCols)
			EndIf
		Next nX
	EndIf
	MaFisEndLoad(nY,Iif(lVisual,3,If(lSoItem,2,Nil)))

	//�������������������������������������������������������������������������Ŀ
	//�Se a execucao da rotina considerar os itens deletados, executa a MAFISDEL�
	//���������������������������������������������������������������������������
	If lDel .AND. aCols[nY][Len(aHeader)+1]
		MaFisDel(nY,.T.)
	Endif

Next nY

Return .T.

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisToCols� Autor � Edson Maricate       � Data � 01.02.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza os valores do aCols com os valores da Funcao Fiscal���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisToCols(aHeader,aCols,nItem,cProg)

Local nX        := 0
Local nY        := 0

Local nItemIni	:= IIf(nItem==Nil,1,nItem)
Local nItemAte	:= IIf(nItem==Nil,Len(aCols),nItem)

For nY := nItemIni to nItemAte
	For nX	:= 1 to Len(aHeader)
		cValid	:= AllTrim(UPPER(aHeader[nX][6]))
		cRefCols := MaFisGetRF(cValid)[1]
		If !Empty(cRefCols) .And. MaFisFound("IT",nY)
			aCols[nY][nX]:= MaFisRet(nY,cRefCols)
		EndIf
	Next nX
Next nY
Return .T.


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisGet� Autor � Edson Maricate          � Data � 01.02.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao utilizada no Pedido de Vendas ( Exclusivamente ) para���
���          �criar a referencia do campo no tratamento fiscal.           ���
���          �Obs.: nao executa o calculo do imposto, apenas utiliza o    ���
���          �      valor informado na preparacao da Nota Fiscal.         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA410,MATA461                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisGet(cReferencia)

Return .T.


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisOrdem� Autor � Edson Maricate        � Data � 01.02.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a ordem utilizada pela rotina de calculo de impostos���
���          �da referencia solicitada.                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA461, Esta ordem e utilizada na rotina de Geracao de NF  ���
���          �         de Saida permitindo que os impostos informados no  ���
���          �         SC6 atraves da Funcao MaFisGet() nao sejam recal-  ���
���          �         culados pela Funcao Fiscal.                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisOrdem(cReferencia)
Local nPos
Local nOrdem := 10000

If aItemRef == Nil
	MaIniRef()
EndIf

If Substr(cReferencia,1,2) == "IT"
	nPos	:= aScan(aItemRef,{|x|x[1]==cReferencia})
	If nPos > 0 .And. aItemRef[nPos][3]<>Nil 
		nOrdem	:= aItemRef[nPos][3]
	EndIf
ElseIf Substr(cReferencia,1,2) == "NF"
	nPos	:= aScan(aCabRef,{|x|x[1]==cReferencia})
	If nPos > 0 .And. Len(aCabRef[nPos]) == 3 .And. aCabRef[nPos][3]<>Nil
		nOrdem := aCabRef[nPos][3]
	EndIf
EndIf

Return nOrdem


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBSIV� Autor � Edson Maricate         � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo da Base dos Impostos Variaveis            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Imposto ( 1 a X )                          ���
���          �ExpN2: Item a ser calculado                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBSIV(nImposto,nItem)
Local nBaseRet	,	nImp:=Len(aTes[TS_SFC])
Local nImpde  := IIF(nImposto==Nil,1,nImposto)
Local nImpAte := IIF(nImposto==Nil,nImp,nImposto)
Private aInfo   //Definida como private pois � usada numa macro    := {}
//��������������������������������������������������������������Ŀ
//� Verifica se a TES possui tratamento para Impostos Variaveis  �
//����������������������������������������������������������������
If !Empty(aTes[TS_SFC])
	If nImpde>0 .And. nImpAte>0
		For nImposto := nImpDe to nImpAte
			//��������������������������������������������������������������Ŀ
			//� Executa o calculo atraves da Funcao cadastrada no SFB        �
			//����������������������������������������������������������������
			aInfo := {aTes[TS_SFC][nImposto][SFC_IMPOSTO],RIGHT(Alltrim(aTes[TS_SFC][nImposto][SFB_CPOVREI]),1)}
			nImp:=NumCpoImpVar(aInfo[2])
			If aNfCab[NF_OPERNF] == "E"
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMENT])
					If cPaisLoc <> "BRA"
						nBaseRet := &(aTes[TS_SFC][nImposto][SFB_FORMENT]+'("B",'+Str(nItem)+',aInfo)')
						If ValType(nBaseRet) == "N"
							aNfItem[nItem][IT_BASEIMP][nImp]:= nBaseRet
						EndIf
					Else
						aNfItem[nItem][IT_BASEIMP][nImp]:= ExecBlock(aTes[TS_SFC][nImposto][SFB_FORMENT],.F.,.F.,{"B",nItem,aInfo},(Left(aTes[TS_SFC][nImposto][SFB_FORMENT],2)=="U_"))
					EndIf
					aNfItem[nItem][IT_DESCIV][nImp] := {aTes[TS_SFC][nImposto][SFC_IMPOSTO],aTes[TS_SFC][nImposto][SFB_DESCR],aTes[TS_SFC][nImposto][SFC_CALCULO]}
				EndIf
			Else
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMSAI])
					If cPaisLoc <> "BRA"
						nBaseRet :=  &(aTes[TS_SFC][nImposto][SFB_FORMSAI]+'("B",'+Str(nItem)+',aInfo)')
						If ValType(nBaseRet) == "N"
							aNfItem[nItem][IT_BASEIMP][nImp]:= nBaseRet
						EndIf
					Else
						aNfItem[nItem][IT_BASEIMP][nImp]:= ExecBlock(aTes[TS_SFC][nImposto][SFB_FORMSAI],.F.,.F.,{"B",nItem,aInfo},(Left(aTes[TS_SFC][nImposto][SFB_FORMENT],2)=="U_"))
					EndIf
					aNfItem[nItem][IT_DESCIV][nImp] := {aTes[TS_SFC][nImposto][SFC_IMPOSTO],aTes[TS_SFC][nImposto][SFB_DESCR],aTes[TS_SFC][nImposto][SFC_CALCULO]}
				EndIf
			EndIf
		Next
	Endif
Else
	//��������������������������������������������������������������Ŀ
	//� Zera todas as aliquotas.                                     �
	//����������������������������������������������������������������
	For nImposto := 1 to NMAXIV
		aNFItem[nItem][IT_BASEIMP][nImposto]:= 0
		aNfItem[nItem][IT_DESCIV][nImposto] := {"","",""}
	Next
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVLIV� Autor � Edson Maricate         � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo do Valor dos Impostos Variaveis           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Imposto ( 1 a X )                          ���
���          �ExpN2: Item a ser calculado                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVLIV(nImposto,nItem)

Local nValImp,nImp:=Len(aTes[TS_SFC])
Local nImpde :=IIF(nImposto==Nil,1,nImposto)
Local nImpAte:=IIF(nImposto==Nil,nImp,nImposto)
Private aInfo   //Definida como private pois � usada numa macro
//��������������������������������������������������������������Ŀ
//� Verifica se a TES possui tratamento para Impostos Variaveis  �
//����������������������������������������������������������������
If !Empty(aTes[TS_SFC])
	If nImpde>0 .And. nImpAte>0
		For nImposto := nImpDe to nImpAte
			//��������������������������������������������������������������Ŀ
			//� Executa o calculo atraves da Funcao cadastrada no SFB        �
			//����������������������������������������������������������������
			aInfo := {aTes[TS_SFC][nImposto][SFC_IMPOSTO],RIGHT(Alltrim(aTes[TS_SFC][nImposto][SFB_CPOVREI]),1)}
			nImp:=NumCpoImpVar(aInfo[2])
			If aNfCab[NF_OPERNF] == "E"
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMENT])
					If cPaisLoc <> "BRA"
						nValImp :=  &(aTes[TS_SFC][nImposto][SFB_FORMENT]+'("V",'+Str(nItem)+',aInfo)')
						If ValType(nValImp) == "N"
							aNfItem[nItem][IT_VALIMP][nImp]:= nValImp
						EndIf
					Else
						aNfItem[nItem][IT_VALIMP][nImp]:= ExecBlock(aTes[TS_SFC][nImposto][SFB_FORMENT],.F.,.F.,{"V",nItem,aInfo},(Left(aTes[TS_SFC][nImposto][SFB_FORMENT],2)=="U_"))
					EndIf
				EndIf
			Else
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMSAI])
					If cPaisLoc <>"BRA"
						nValImp :=  &(aTes[TS_SFC][nImposto][SFB_FORMSAI]+'("V",'+Str(nItem)+',aInfo)')
						If ValType(nValImp) == "N"
							aNfItem[nItem][IT_VALIMP][nImp]:= nValImp
						EndIf
					Else
						aNfItem[nItem][IT_VALIMP][nImp]:= ExecBlock(aTes[TS_SFC][nImposto][SFB_FORMSAI],.F.,.F.,{"V",nItem,aInfo},(Left(aTes[TS_SFC][nImposto][SFB_FORMENT],2)=="U_"))
					EndIf
				EndIf
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Verifica as Propriedades do Imposto                          �
			//����������������������������������������������������������������
			Do Case
			Case aTes[TS_SFC][nImposto][SFC_INCDUPL]=="1"
				nValImp:=aNfItem[nItem][IT_VALIMP][nImp]
			Case aTes[TS_SFC][nImposto][SFC_INCDUPL]=="2"
				nValImp:=-aNfItem[nItem][IT_VALIMP][nImp]
			Case aTes[TS_SFC][nImposto][SFC_INCDUPL]=="3"
				nValImp:=0
			EndCase
			aNfItem[nItem][IT_BASEDUP] += nValImp
			Do Case
			Case aTes[TS_SFC][nImposto][SFC_INCNOTA]=="1"
				nValImp:=aNfItem[nItem][IT_VALIMP][nImp]
			Case aTes[TS_SFC][nImposto][SFC_INCNOTA]=="2"
				nValImp:=-aNfItem[nItem][IT_VALIMP][nImp]
			Case aTes[TS_SFC][nImposto][SFC_INCNOTA]=="3"
				nValImp:=0
			EndCase
			aNfItem[nItem][IT_TOTAL] += nValImp
		Next
	Endif
Else
	//��������������������������������������������������������������Ŀ
	//� Zera todas as aliquotas.                                     �
	//����������������������������������������������������������������
	For nImposto := 1 to NMAXIV
		aNFItem[nItem][IT_VALIMP][nImposto]:= 0
	NExt
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisAliqIV� Autor � Edson Maricate       � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo da Aliquota dos Impostos Variaveis        ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Imposto ( 1 a 6 )                          ���
���          �ExpN2: Item a ser calculado                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisAliqIV(nImposto,nItem)

Local nAliqImp,nImp:=Len(aTes[TS_SFC])
Local nImpde :=IIF(nImposto==Nil,1,nImposto)
Local nImpAte:=IIF(nImposto==Nil,nImp,nImposto)
Private aInfo   //Definida como private pois � usada numa macro
//��������������������������������������������������������������Ŀ
//� Verifica se a TES possui tratamento para Impostos Variaveis  �
//����������������������������������������������������������������
If !Empty(aTes[TS_SFC])
	If nImpde>0 .And. nImpAte>0
		For nImposto := nImpDe to nImpAte
			//��������������������������������������������������������������Ŀ
			//� Executa o calculo atraves da Funcao cadastrada no SFB        �
			//����������������������������������������������������������������
			aInfo := {aTes[TS_SFC][nImposto][SFC_IMPOSTO],RIGHT(Alltrim(aTes[TS_SFC][nImposto][SFB_CPOVREI]),1)}
			nImp:=NumCpoImpVar(aInfo[2])
			If aNfCab[NF_OPERNF] == "E"
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMENT])
					If cPaisLoc <> "BRA"
						nAliqImp :=  &(aTes[TS_SFC][nImposto][SFB_FORMENT]+'("A",'+Str(nItem)+',aInfo)')
						If ValType(nAliqImp) == "N"
							aNfItem[nItem][IT_ALIQIMP][nImp]:= nAliqImp
						EndIf
					Else
						aNfItem[nItem][IT_ALIQIMP][nImp]:= ExecBlock(aTes[TS_SFC][nImposto][SFB_FORMENT],.F.,.F.,{"A",nItem,aInfo},(Left(aTes[TS_SFC][nImposto][SFB_FORMENT],2)=="U_"))
					EndIf
				EndIf
			Else
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMSAI])
					If cPaisLoc <>"BRA"
						nAliqImp :=  &(aTes[TS_SFC][nImposto][SFB_FORMSAI]+'("A",'+Str(nItem)+',aInfo)')
						If ValType(nAliqImp) == "N"
							aNfItem[nItem][IT_ALIQIMP][nImp]:= nAliqImp
						EndIf
					Else
						aNfItem[nItem][IT_ALIQIMP][nImp]:= ExecBlock(aTes[TS_SFC][nImposto][SFB_FORMSAI],.F.,.F.,{"A",nItem,aInfo},(Left(aTes[TS_SFC][nImposto][SFB_FORMENT],2)=="U_"))
					EndIf
				EndIf
			EndIf
		Next
	Endif
Else
	//��������������������������������������������������������������Ŀ
	//� Zera todas as aliquotas.                                     �
	//����������������������������������������������������������������
	For nImposto := 1 to NMAXIV
		aNFItem[nItem][IT_ALIQIMP][nImposto]:= 0
	Next
EndIf
Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisNameIV� Autor � Edson Maricate       � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Preeche o nome dos impostos Variaveis                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Imposto ( 1 a 6 )                          ���
���          �ExpN2: Item a ser calculado                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisNameIV(nImposto,nItem)

Local nImpde := IIf(nImposto==Nil,1,nImposto)
Local nImpAte:= IIF(nImposto==Nil,Len(aTes[TS_SFC]),nImposto)

//��������������������������������������������������������������Ŀ
//� Verifica se a TES possui tratamento para Impostos Variaveis  �
//����������������������������������������������������������������
If !Empty(aTes[TS_SFC])
	If nImpde>0 .And. nImpAte>0
		For nImposto := nImpDe to nImpAte
			//��������������������������������������������������������������Ŀ
			//� Executa o calculo atraves da Funcao cadastrada no SFB        �
			//����������������������������������������������������������������
			If	aNfCab[NF_OPERNF] == "E"
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMENT])
					nImp:=NumCpoImpVar(RIGHT(Alltrim(aTes[TS_SFC][nImposto][SFB_CPOVREI]),1))
					aNfItem[nItem][IT_DESCIV][nImp] := {aTes[TS_SFC][nImposto][SFC_IMPOSTO],aTes[TS_SFC][nImposto][SFB_DESCR],aTes[TS_SFC][nImposto][SFC_CALCULO]}
				EndIf
			Else
				If !Empty(aTes[TS_SFC][nImposto][SFB_FORMSAI])
					nImp:=NumCpoImpVar(RIGHT(Alltrim(aTes[TS_SFC][nImposto][SFB_CPOVRSI]),1))
					aNfItem[nItem][IT_DESCIV][nImp] := {aTes[TS_SFC][nImposto][SFC_IMPOSTO],aTes[TS_SFC][nImposto][SFB_DESCR],aTes[TS_SFC][nImposto][SFC_CALCULO]}
				EndIf
			EndIf
		Next
	Endif
Else
	For nImposto:=1 to NMAXIV
		aNfItem[nItem][IT_DESCIV][nImposto] := {"","",""}
	Next
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisLF2� Autor � Edson Maricate          � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se o TES possui RdMake para geracao/complemento    ���
���          �dos Livros Fiscais                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Item                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisLF2(nItem)

If !Empty(aTes[TS_LIVRO]) .And. cPaisLoc == "BRA"
	aNfItem[nItem][IT_LIVRO] := ExecBlock(aTes[TS_LIVRO],.F.,.F.,{aNfItem[nItem][IT_LIVRO],nItem})
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaAvalTes� Autor � Edson Maricate         � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se o TES pode ser utilizada na operacao.           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Tipo de movimentacao - E Entrada ou Saida            ���
���          �ExpC2: Codigo da TES                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaAvalTes(cOperacao,cTes)
Local lRet := .T.

Do Case
Case cOperacao == "E"
	If SubStr(cTes,1,1) >= "5" .And. cTES <> "500"
		HELP("   ",1,"INV_TE")
		lRet := .F.
	EndIf
Case cOperacao == "S"
	If !SubStr(cTes,1,1) >= "5" .Or. cTES == "500"
		HELP("   ",1,"INV_TS")
		lRet := .F.
	EndIf
EndCase

Return lRet



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaRecImp� Autor � Edson Maricate          � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna array com todos os impostos recuperaveis do Item    ���
���          �da NF.                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Item                                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: [1] -                                                ���
���          �       [2] -                                                ���
���          �       [3] -                                                ���
���          �       [4] -                                                ���
���          �       [5] -                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaRecImp()

Local aArea		:= GetArea()

dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial()+SD1->D1_TES)

//��������������������������������������������������������������Ŀ
//� Verifica os impostos padroes da NF                           �
//����������������������������������������������������������������
If SD1->D1_VALICM <> 0

EndIf
RestArea(aArea)
Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVldAlt� Autor � Edson Maricate       � Data �02.02.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica a referencia e se a mesma pode ser alterada.       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Referencia                                           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Logico                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisVldAlt(cReferencia,nItem)
Local lRet := .T.

If cPaisLoc == "BRA"
	Do Case
	Case aNfCab[NF_TIPONF] == "I" .And. ;
			Alltrim(cReferencia)$"IT_BASEICM#NF_BASEICM#IT_VALICM#NF_VALICM#IT_QUANT#IT_PRCUNI"
		HELP("   ",1,"COMPICM")
		lRet := .F.
	Case aNfCab[NF_TIPONF] == "P" .And. ;
			AllTrim(cReferencia)$"IT_BASEIPI#NF_BASEIPI#IT_VALIPI#NF_VALIPI#IT_QUANT#IT_PRCUNI"
		HELP("   ",1,"COMPIPI")
		lRet := .F.
	Case aNfCab[NF_TIPONF] == "C" .And. ;
			AllTrim(cReferencia)$"IT_QUANT#IT_PRCUNI"
		HELP("   ",1,"COMPPRC")
		lRet := .F.
	EndCase
Else
	If nItem <> NIL .And. !Empty(aNfItem[nItem][IT_REMITO]) .And. Alltrim(cReferencia)$"IT_PRODUTO"
		HELP("   ",1,"LOCXNF0003")
		lRet := .F.
	Endif
Endif	

Return lRet

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisLFToLivro� Autor � Edson Maricate    � Data �07.03.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Adiciona o item nos livros fiscais                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION MaFisLFToLivro(nItem,aNotasOri,lSoma)

Local aGetBook := {}
Local aSFB     := {}
Local aSFC     := {}
Local aSF4     := {}
Local nLF      := 0
Local nY       := 0
Local nX       := 0
Local nS	   := 0
Local dDataEmi	:=	dDataBase
Local cAux     := ""
Local	lImport	:=	(Type("lFacImport")=="L" .And.lFacImport)
DEFAULT lSoma := .T.   

//����������������������������������������������������������������Ŀ
//� Atualiza o array aTes para o correta definicao das observacoes �
//������������������������������������������������������������������

MaFisTes(aNfItem[nItem,IT_TES],aNfItem[nItem,IT_RECNOSF4],nItem)

//������������������������������������������������������������Ŀ
//� Montagem dos Livros Fiscals ( aLivro )                     �
//��������������������������������������������������������������
If cPaisLoc=="BRA"
	If 	aNfItem[nItem][IT_LIVRO][3] +;
			aNfItem[nItem][IT_LIVRO][4] +;
			aNfItem[nItem][IT_LIVRO][5] +;
			aNfItem[nItem][IT_LIVRO][6] +;
			aNfItem[nItem][IT_LIVRO][7] +;
			aNfItem[nItem][IT_LIVRO][9] +;
			aNfItem[nItem][IT_LIVRO][10]+;
			aNfItem[nItem][IT_LIVRO][11] <>0 .Or. !Empty(aNfItem[nItem][IT_LIVRO][24])

		If aNfItem[nItem][IT_CALCISS] == "S"
			nLF	:= aScan(aNfCab[NF_LIVRO],{|x|x[LF_CFO]==aNfItem[nItem][IT_LIVRO][LF_CFO] .And.;
												x[LF_CODISS]==aNfItem[nItem][IT_LIVRO][LF_CODISS] .And.;
												x[LF_ALIQICMS]==aNfItem[nItem][IT_LIVRO][LF_ALIQICMS] .And.;
												x[LF_NFLIVRO]==aNfItem[nItem][IT_LIVRO][LF_NFLIVRO] .And.;
												x[LF_FORMULA]==aNfItem[nItem][IT_LIVRO][LF_FORMULA]})

		Else
			nLF	:= aScan(aNfCab[NF_LIVRO],{|x|x[LF_CFO]==aNfItem[nItem][IT_LIVRO][LF_CFO] .And. ;
				x[LF_CFOEXT]==aNfItem[nItem][IT_LIVRO][LF_CFOEXT] .And. x[LF_ALIQICMS]==aNfItem[nItem][IT_LIVRO][LF_ALIQICMS] ;
				.And. x[LF_NFLIVRO]==aNfItem[nItem][IT_LIVRO][LF_NFLIVRO] .And. x[LF_FORMULA]==aNfItem[nItem][IT_LIVRO][LF_FORMULA] ;
				.And. x[LF_CODISS]==aNfItem[nItem][IT_LIVRO][LF_CODISS]})
		EndIf
		If nLF == 0
			aNotasOri:= {}
			aadd(aNfCab[NF_LIVRO],MaFisRetLF())
			nLF	:= Len(aNfCab[NF_LIVRO])
			aNfCab[NF_LIVRO][nLF][LF_CFO] 		:= aNfItem[nItem][IT_LIVRO][LF_CFO]
			aNfCab[NF_LIVRO][nLF][LF_CFOEXT]   := aNfItem[nItem][IT_LIVRO][LF_CFOEXT]
			aNfCab[NF_LIVRO][nLF][LF_ALIQICMS] := aNfItem[nItem][IT_LIVRO][LF_ALIQICMS]
			aNfCab[NF_LIVRO][nLF][LF_NFLIVRO] 	:= aNfItem[nItem][IT_LIVRO][LF_NFLIVRO]
			aNfCab[NF_LIVRO][nLF][LF_FORMULA] 	:= aNfItem[nItem][IT_LIVRO][LF_FORMULA]
			aNfCab[NF_LIVRO][nLF][LF_TIPO]		:= aNfItem[nItem][IT_LIVRO][LF_TIPO]
			aNfCab[NF_LIVRO][nLF][LF_CODISS]	:= aNfItem[nItem][IT_LIVRO][LF_CODISS]
			aNfCab[NF_LIVRO][nLF][LF_FORMUL]	:= aNfItem[nItem][IT_LIVRO][LF_FORMUL]
			aNfCab[NF_LIVRO][nLF][LF_ISSST]		:= aNfItem[nItem][IT_LIVRO][LF_ISSST]
			aNfCab[NF_LIVRO][nLF][LF_RECISS]	:= aNfItem[nItem][IT_LIVRO][LF_RECISS]
			aNfcab[NF_LIVRO][nLF][LF_CREDST]   := aNfItem[nItem][IT_LIVRO][LF_CREDST]
		EndIf
		For nY	:= 1 to Len(aNfCab[NF_LIVRO][nLf])
			If !AllTrim(StrZero(nY,2))$"01#02#12#15#16#18#20#23#24#31#32#33#36"
				If lSoma
					If Valtype(aNfItem[nItem][IT_LIVRO][nY])<>"A"
						aNfCab[NF_LIVRO][nLF][nY] += aNfItem[nItem][IT_LIVRO][nY]
					Else
						For nS := 1 To Len(aNfCab[NF_LIVRO][nLF][nY])
							aNfCab[NF_LIVRO][nLF][nY][nS] += aNfItem[nItem][IT_LIVRO][nY][nS]
						Next nS
					EndIf
				Else
					If Valtype(aNfItem[nItem][IT_LIVRO][nY])<>"A"
						aNfCab[NF_LIVRO][nLF][nY] -= aNfItem[nItem][IT_LIVRO][nY]
					Else
						For nS := 1 To Len(aNfCab[NF_LIVRO][nLF][nY])
							aNfCab[NF_LIVRO][nLF][nY][nS] += aNfItem[nItem][IT_LIVRO][nY][nS]
						Next nS
					EndIf
				EndIf
			EndIf
		Next
		//������������������������������������������������������������Ŀ
		//� Preenche a Observacao dos livros Fiscais                   �
		//��������������������������������������������������������������
		aNfCab[NF_LIVRO][nLF][LF_OBSERV]   := MaFisObserv(aNfCab[NF_LIVRO][nLF][LF_OBSERV],nItem,@aNotasOri)
		
		//������������������������������������������������������������Ŀ
		//� Zera a coluna outras caso esteja menor que zero            �
		//��������������������������������������������������������������
		aNfCab[NF_LIVRO,nLF,LF_OUTRICM] := Max(aNfCab[NF_LIVRO,nLF,LF_OUTRICM],0)


		If 	aNfCab[NF_LIVRO][nLF][3] +;
				aNfCab[NF_LIVRO][nLF][4] +;
				aNfCab[NF_LIVRO][nLF][5] +;
				aNfCab[NF_LIVRO][nLF][6] +;
				aNfCab[NF_LIVRO][nLF][7] +;
				aNfCab[NF_LIVRO][nLF][9] +;
				aNfCab[NF_LIVRO][nLF][10]+;
				aNfCab[NF_LIVRO][nLF][11] == 0 .And. Empty(aNfCab[NF_LIVRO][nLF][LF_FORMULA])
			aDel(aNfCab[NF_LIVRO],nLF)
			aSize(aNfCab[NF_LIVRO],Len(aNfCab[NF_LIVRO])-1)
		EndIf

	EndIf
Else
	aSF4:=SF4->(GetArea())
	aSFB:=SFB->(GetArea())
	aSFC:=SFC->(GetArea())
	SFC->(DbSetOrder(2))
	SFB->(DbSetOrder(1))
	SF4->(DbSetOrder(1))
	SF4->(MsSeek(xFilial("SF4")+aNfItem[nItem][IT_TES]))
	aImpVar:=Array(7)
	aImpVar[1] := aNfItem[nItem][IT_QUANT]
	If MaFisRet(,'NF_OPERNF') == 'E' .Or. SuperGetMV('MV_DESCSAI')='2'
		aImpVar[2] := (aNfItem[nItem][IT_VALMERC]-aNfItem[nItem][IT_DESCONTO])/Max(aNfItem[nItem][IT_QUANT],1)
		aImpVar[3] := aNfItem[nItem][IT_VALMERC]-aNfItem[nItem][IT_DESCONTO]
	Else
		aImpVar[2] := aNfItem[nItem][IT_PRCUNI]
		aImpVar[3] := aNfItem[nItem][IT_VALMERC]
	Endif	
	aImpVar[4] := aNfItem[nItem][IT_FRETE]
	aImpVar[5] := aNfItem[nItem][IT_DESPESA]
	aImpVar[6] := {}
	aImpVar[7] := ""
	MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)
	For nY:=1 to Len(aTes[TS_SFC])
		If (cPaisLoc <> "ARG".Or. aTes[TS_SFC][nY][SFC_IMPOSTO]<> "DUM") //Ignmorar o DUMMY
			nImp:=NumCpoImpVar(RIGHT(Alltrim(aTes[TS_SFC][nY][SFB_CPOVREI]),1)) 
			aadd(aImpVar[6],Array(17))
			nX:=Len(aImpVar[6])
			aImpVar[6][nX][1] :=aNfItem[nItem][IT_PRODUTO]
			aImpVar[6][nX][2] :=aNfItem[nItem][IT_ALIQIMP][nImp]
			aImpVar[6][nX][3] :=aNfItem[nItem][IT_BASEIMP][nImp]
			aImpVar[6][nX][4] :=aNfItem[nItem][IT_VALIMP][nImp]
			If (lImport)
				SD1->(MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
				If SF1->F1_TIPO_NF$"5678"
					SYD->(MsSeek(xFilial("SYD")+SD1->D1_TEC))
					SFC->(MsSeek(xFilial("SFC")+SYD->YD_TES+aTes[TS_SFC][nY][SFC_IMPOSTO]))
				Else
					SWW->(MsSeek(xfilial("SWW")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
					For nS:=1 To nItem-1
						SWW->(DbSkip())
					Next
					SWD->(DbSetOrder(3))
					SWD->(MsSeek(xFilial("SWD")+Left(SWW->WW_DESPESA,3)+SWW->WW_NF_COMP+SWW->WW_HAWB)) 
					SFC->(MsSeek(xFilial("SFC")+SYB->YB_TES+aTes[TS_SFC][nY][SFC_IMPOSTO]))
				Endif
				SFB->(MsSeek(xFilial("SFB")+aTes[TS_SFC][nY][SFC_IMPOSTO]))
				cAux:=SFC->FC_INCDUPL+SFC->FC_INCNOTA+SFC->FC_CREDITA
				If IsAlpha(SFC->FC_INCDUPL)
					aImpVar[6][nX][5]:=IIf(Subs(cAux,1,2)=="SN".Or.Subs(cAux,1,2)=="NS","3",;
						IIf(Subs(cAux,1,2)=="SS","1","2"))
					aImpVar[6][nX][5]+=IIf(Subs(cAux,2,1)=="S" ,"1",IIf(Subs(cAux,2,1)=="R" ,"2","3"))
					aImpVar[6][nX][5]+=IIf(Subs(cAux,2,2)=="SN","1",IIf(Subs(cAux,2,2)=="NS","2","3"))
				Else
					aImpVar[6][nX][5]:=cAux
				EndIf
				aImpVar[6][nX][17]:=SFB->FB_CPOLVRO
			Else
				aImpVar[6][nX][5]:=	aTes[TS_SFC][nY][SFC_INCDUPL]+	aTes[TS_SFC][nY][SFC_INCNOTA]+	aTes[TS_SFC][nY][SFC_CREDITA]
				aImpVar[6][nX][17]:=Right(aTes[TS_SFC][nY][SFB_CPOVREI],1)
			Endif
		Endif
	Next
	If Type('dDEmissao') == "D" .And. !Empty(dDEmissao)
		dDataEmi	:=	dDEmissao
	Endif
	aNfCab[NF_LIVRO]	:=	GetBook(@aGetBook,aImpVar,If(aNfCab[NF_CLIFOR]=="C","V","C"),If(Type("nTaxa")=="N",nTaxa,If(Type("nTXMoeda")=="N",nTXMoeda,1)),aNfCab[NF_LIVRO],aNfCab[NF_OPERNF],lSoma,,,,,,dDataEmi)
	RestArea(aSF4)
	RestArea(aSFB)
	RestArea(aSFC)
EndIf
Return .T.

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisConsFin()� Autor � Edson Maricate    � Data �07.03.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o e o destino e um Consumidor Final            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MaFisConsFin()
Local lRet := .F.

If aNfCab[NF_OPERNF] == "S"
	lRet := aNfCab[NF_TPCLIFOR] == "F"
Else
	lRet := SM0->M0_PRODRUR == "F"
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisConsumo()� Autor � Edson Maricate    � Data �07.03.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o e material de consumo.                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MaFisConsumo(nItem)
Local lRet := .F.

IF aTes[TS_CONSUMO] == " "
	If (aTes[TS_INCIDE] == "S"  .or. (aTes[TS_INCIDE] == "F" .and. aNFCab[NF_TPCLIFOR] =="F" .and. aNFCab[NF_CLIFOR] =="C")) .And.;
			( Substr(aNfItem[nItem][IT_CF],2,3)$"91 /92 /97 " .Or. (Substr(aNfItem[nItem][IT_CF],2,2) $ "55" .And. Substr(aNfItem[nItem][IT_CF],4,1)<>" "))
		lRet := .T.
	Endif
Else
	lRet := aTes[TS_CONSUMO] == "S"
Endif

Return lRet

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisObserv   � Autor � Edson Maricate    � Data �07.03.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Define mensagem de observacao a ser gravada no F3_OBSERV   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static FUNCTION MaFisObserv(cObservAnt,nItem,aNotasOri)

Local  cNFOri := IIf(!empty(aNfItem[nItem][IT_NFORI]),aNfItem[nItem][IT_NFORI]+"/"+aNfItem[nItem][IT_SERORI],"")
Local  cMsg   := ""

If !Empty(cNFOri) .And. aScan(aNotasOri,cNFOri)==0
	aadd(aNotasOri,cNFOri)
EndIf

cNFOri := IIf(Len(aNotasOri)>1,STR0009,cNFOri) //"DIVERSAS"

//����������������������������������������������������������������Ŀ
//� Ponto de entrada para alteracao da mensagem quanto a devolucao �
//������������������������������������������������������������������
If !Empty( aNotasOri )
	If ExistBlock( "MAFISOBS" )
		cNFOri := ExecBlock( "MAFISOBS", .F., .F., { cNfOri, AClone( aNotasOri ) } )
	EndIf
EndIf 	

Do Case
Case aNfCab[NF_TIPONF]=="D"
	cMsg:=IIf(!empty(cNFOri),STR0011+cNFOri,"") //"DEVOLUCAO N.F.:"
Case aNfCab[NF_TIPONF]=="C" .And. aNfCab[NF_TPCOMP] == "F"
	cMsg:= STR0012 //"CONHEC. FRETE"
Case aNfCab[NF_TIPONF]=="C" .And. aNfCab[NF_TPCOMP] == "D"
	cMsg:= STR0013 //"NF DESPESA"
Case aNfCab[NF_TIPONF]=="C"
	cMsg:=STR0014+cNFOri //"COMPL.PC.N.F.: "
Case aNfCab[NF_TIPONF]=="B".And.aTes[TS_PODER3]<>"R"
	cMsg:=IIf(!empty(cNFOri),STR0015+cNFOri,"") //"N.F.ORIG.: "
Case aNfCab[NF_TIPONF]=="P"
	cMsg:=STR0016+cNFOri //"COMPL.IPI N.F.: "
Case aNfCab[NF_TIPONF]=="I"
	If "CIAP" $ Upper(cNFORi)
		cMsg := ""
	Else
		cMsg:=IIF(aTes[TS_ISS]<>"N",STR0022,STR0017)+cNFOri //"COMPL.ICMS N.F.: " OU "COMPL.ISS N.F.: "
	EndIf
Case aNfCab[NF_TPCLIFOR]=="X" .AND. aNfCab[NF_OPERNF]=="S"
	cMsg:=""
	If !Empty(cNFOri)
	   cMsg:=STR0018+cNFOri //"EXPORTACAO-GE No.: "
	Endif   
Case aTes[TS_IPI]=="R"
	cMsg:=STR0019 //"AQUIS.COMERC.NAO-CONTRIB.IPI"
Case aNfCab[NF_TIPONF]=="N".And.aTes[TS_PODER3] == "D"
	cMsg:=Iif(!Empty(cNfOri),(STR0020+cNFOri),"") //"Dev. Benef. N.F.ORIG.: "
Case aNfCab[NF_FUNRURAL]>0
	cMsg:=STR0021+Alltrim(Transform(aNfCab[NF_FUNRURAL],"@E 999,999,999.99")) //"CONT.SEG.SOCIAL: "
EndCase

Return (cMsg)

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MaSBCampo()  � Autor � Cesar Valadao     � Data �11/09/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o Conteudo do Campo Dependendo do Alias Informado. ���
���          � O Front Loja Utiliza o Arquivo SBI Como Arq. de Produtos.  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATXFIS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MaSBCampo(cNome)
Local cCampo    := Right(cAliasPROD,2)+"_"+cNome
Local cAlias    := cAliasPROD
Local nPosCampo := 0
Local xValor    := Nil

If (cAlias)->(FieldPos(cCampo))>0
	xValor := (cAlias)->(FieldGet(FieldPos(cCampo)))
Else
	If !Empty( nPosCampo := SB1->(FieldPos(Right("SB1",2)+"_"+cNome ) ) )
		xValor := SB1->( FieldGet( nPosCampo ) )
	EndIf 	
EndIf
Return(xValor)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaALIQCOF� Autor � Edson Maricate         � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a aliquota para calculo do COFINS.                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaALIQCOF(nItem)

Local aArea		 := GetArea()
Local aRelImp	 := {}
Local aRelImp2	 := {}

Local nAliquota  := 0  
Local nAliqProd  := 0 
Local nPsAlCOFSa := 0
Local nPsAlCOFEt := 0
Local nScanCOF   := 0

Local cCpAlCOFSa := ""
Local cCpAlCOFEt := ""

Local lMaCalcCOF := ExistBlock("MaCalcCOF")
Local aMaCalcCOF := {}
	
If lMaCalcCOF
	aMaCalcCOF := ExecBlock("MaCalcCOF")
EndIf

nAliqProd := MaSBCampo("PCOFINS")
nAliquota := IIf(Empty(nAliqProd),SuperGetMv("MV_TXCOFIN"),nAliqProd)

If ( aNFCab[NF_TIPONF] $"DB" ) .Or. aTes[TS_PODER3] == "D"

	aRelImp  := MaFisRelImp("MT100",{ "SD1" })
	aRelImp2 := MaFisRelImp("MT100",{ "SD2" })	

	If !Empty( nScanCOF := aScan(aRelImp2,{|x| x[1]=="SD2" .And. x[3]=="IT_ALIQCF2"} ) )
		cCpAlCOFSa := aRelImp2[nScanCOF,2]
		nPsAlCOFSa := SD2->( FieldPos( cCpAlCOFSa ) )
	EndIf

	If !Empty( nScanCOF := aScan(aRelImp ,{|x| x[1]=="SD1" .And. x[3]=="IT_ALIQCF2"} ) )
		cCpAlCOFEt := aRelImp[nScanCOF,2]
		nPsAlCOFEt := SD1->( FieldPos( cCpAlCOFEt ) ) 			
	EndIf 	

	If aNFCab[NF_TIPONF] $ "DB"
		If !Empty(aNFItem[nItem][IT_RECORI])
			If ( aNFCab[NF_CLIFOR] == "C" )
				dbSelectArea("SD2")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlCOFSa > 0
					nAliquota  := SD2->( FieldGet( nPsAlCOFSa ) )
				EndIf
			Else
				dbSelectArea("SD1")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlCOFEt > 0					
					If !Empty( SD1->( FieldGet( nPsAlCOFEt ) ) ) .Or. SD1->D1_EMISSAO >= CTOD( "01/02/2004" )
						nAliquota  := SD1->( FieldGet( nPsAlCOFEt ) )
					EndIf 	
				EndIf	
			EndIf
		EndIf
	Else
		If !Empty(aNFItem[nItem][IT_RECORI])
			If ( aNFCab[NF_CLIFOR] == "C" )
				dbSelectArea("SD1")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlCOFEt > 0					
					nAliquota  := SD1->( FieldGet( nPsAlCOFEt ) )
				Endif	
			Else
				dbSelectArea("SD2")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlCOFSa > 0
					nAliquota  := SD2->( FieldGet( nPsAlCOFSa ) )
				Endif
			EndIf
		EndIf
	EndIf
EndIf

If !( Empty(aNFitem[nItem,IT_EXCECAO]))
	If aNFItem[nItem,IT_EXCECAO,13] <> 0 
		nAliquota := aNFItem[nItem,IT_EXCECAO,13]
	Endif	
Endif	

aNfItem[nItem][IT_ALIQCF2]	:= nAliquota

If (lMaCalcCof .And. aMaCalcCOF[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCCOF=="S")
	If ( Empty(nAliqProd) .And. !Empty(If(lMaCalcCOF,aMaCalcCOF[2],SED->ED_PERCCOF) ) ) .Or. GetNewPar( "MV_TPALCOF", "2" ) == "1" 
		nAliquota := If(lMaCalcCOF,aMaCalcCOF[2],SED->ED_PERCCOF)
	EndIf
	aNfItem[nItem][IT_ALIQCOF]	:= nAliquota	
EndIf


RestArea(aArea)
Return(nAliquota)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaALIQCSL� Autor � Edson Maricate         � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a aliquota para calculo do CSLL.                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaALIQCSL(nItem)

Local aArea		 := GetArea()
Local nAliquota := 0  

Local lMaCalcCSL := ExistBlock("MaCalcCSL")
Local aMaCalcCSL := {}
	
If lMaCalcCSL
	aMaCAlcCSL := ExecBlock("MaCalcCSL")
EndIf

//������������������������������������������������������������Ŀ
//� Carrega aliquota do cadastro de produtos                   �
//��������������������������������������������������������������
nAliquota := MaSBCampo("PCSLL")

If (lMaCalcCSL .And. aMaCalcCSL[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCCSL=="S")	
	If (Empty( nAliquota ) .And. !Empty(If(lMaCalcCSL,aMaCalcCSL[2],SED->ED_PERCCSL))) .Or. GetNewPar( "MV_TPALCSL", "2" ) == "1"
		//������������������������������������������������������������Ŀ
		//� Caso exista da natureza, carrega da natureza               �
		//��������������������������������������������������������������
		nAliquota := If(lMaCalcCSL,aMaCalcCSL[2],SED->ED_PERCCSL)
	EndIf 	
EndIf                                                  

If aNfItem[nItem][IT_TIPONF]=="D"
	nAliquota := 0 
EndIf 

aNfItem[nItem][IT_ALIQCSL]	:= nAliquota

RestArea(aArea)

Return(nAliquota)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaALIQPIS� Autor � Edson Maricate         � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a aliquota para calculo do PIS.                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MaALIQPIS(nItem)

Local aArea		 := GetArea()
Local aRelImp	 := {}
Local aRelImp2	 := {}

Local nAliquota  := 0 
Local nAliqProd  := 0 
Local nPsAlPisSa := 0
Local nPsAlPisEt := 0
Local nScanPis   := 0

Local cCpAlPisSa := ""
Local cCpAlPisEt := ""

Local lMaCalcPIS := ExistBlock("MaCalcPIS")
Local aMaCalcPIS := {}
	
If lMaCalcPIS
	aMaCalcPIS := ExecBlock("MaCalcPIS")
EndIf

nAliqProd := MaSBCampo("PPIS")
nAliquota := IIf(Empty(nAliqProd),SuperGetMv("MV_TXPIS"),nAliqProd)

If ( aNFCab[NF_TIPONF] $"DB" ) .Or. aTes[TS_PODER3] == "D"

	aRelImp  := MaFisRelImp("MT100",{ "SD1" })
	aRelImp2 := MaFisRelImp("MT100",{ "SD2" })	

	If !Empty( nScanPis := aScan(aRelImp2,{|x| x[1]=="SD2" .And. x[3]=="IT_ALIQPS2"} ) )
		cCpAlPisSa := aRelImp2[nScanPis,2]
		nPsAlPisSa := SD2->( FieldPos( cCpAlPisSa ) )
	EndIf

	If !Empty( nScanPis := aScan(aRelImp ,{|x| x[1]=="SD1" .And. x[3]=="IT_ALIQPS2"} ) )
		cCpAlPisEt := aRelImp[nScanPis,2]
		nPsAlPisEt := SD1->( FieldPos( cCpAlPisEt ) ) 			
	EndIf 	

	If aNFCab[NF_TIPONF] $ "DB"
		If !Empty(aNFItem[nItem][IT_RECORI])
			If ( aNFCab[NF_CLIFOR] == "C" )
				dbSelectArea("SD2")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlPisSa > 0
					nAliquota  := SD2->( FieldGet( nPsAlPisSa ) )
				Endif
			Else
				dbSelectArea("SD1")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlPisEt > 0					
					nAliquota  := SD1->( FieldGet( nPsAlPisEt ) )
				Endif	
			EndIf
		EndIf
	Else
		If !Empty(aNFItem[nItem][IT_RECORI])
			If ( aNFCab[NF_CLIFOR] == "C" )
				dbSelectArea("SD1")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlPisEt > 0					
					nAliquota  := SD1->( FieldGet( nPsAlPisEt ) )
				Endif	
			Else
				dbSelectArea("SD2")
				MsGoto( aNFItem[nItem][IT_RECORI] )
				If nPsAlPisSa > 0
					nAliquota  := SD2->( FieldGet( nPsAlPisSa ) )
				Endif
			EndIf
		EndIf
	EndIf
Endif

If !( Empty(aNFitem[nItem,IT_EXCECAO]))
	If aNFItem[nItem,IT_EXCECAO,12] <> 0 
		nAliquota := aNFItem[nItem,IT_EXCECAO,12]
	Endif	
Endif	

aNfItem[nItem][IT_ALIQPS2]	:= nAliquota	

If (lMaCalcPIS .And. aMaCalcPIS[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCPIS=="S")
	If ( Empty(nAliqProd) .And. !Empty(If(lMaCalcPIS,aMaCalcPIS[2],SED->ED_PERCPIS)) ) .Or. GetNewPar( "MV_TPALPIS", "2" ) == "1" 
		nAliquota := If(lMaCalcPIS,aMaCalcPIS[2],SED->ED_PERCPIS)
	EndIf
	aNfItem[nItem][IT_ALIQPIS]	:= nAliquota
EndIf

RestArea(aArea)
Return(nAliquota)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBsCOF� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o base de Caluculo do COFINS .                      ���
���          �ExpC1: Tipo : 1-Apuracao / 2-Retencao / 3-Ambos ( padrao )  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBSCOF(nItem,cTipo)

Local cDebSTCOF     := GetNewPar("MV_DBSTCOF","1")

Local nBaseCOF	  := 0
Local nRedBsCOF	  := MaSBCampo("REDCOF")
Local nFatRedCOF  := 1   
Local nDesconto   := aNfItem[nItem][IT_DESCONTO]           

Local lMaCalcCOF := ExistBlock("MaCalcCOF")
Local aMaCalcCOF := {}
	
Local cCofBru	 := GetNewPar("MV_COFBRU","2")
	
DEFAULT cTipo      := "3"

If lMaCalcCOF
	aMaCalcCOF := ExecBlock("MaCalcCOF")
EndIf

//������������������������������������������������������������Ŀ
//� Caso retorne corretamente a reducao, calcula o fator       �
//��������������������������������������������������������������
DEFAULT nRedBsCOF := 0
If nRedBsCOF <> 0
	nFatRedCOF	:= If( nRedBsCOF>0,1-nRedBsCOF/100,1)
EndIf
nRedBsCOF := aTES[TS_BASECOF]/100
If nRedBsCOF <> 0
	nFatRedCOF	*= If( nRedBsCOF>0,1-nRedBsCOF,1)
EndIf

If cTipo $ "13" 

	If aTES[TS_PISCRED] <> "3" .And. aTES[TS_PISCOF]$"23" .And. !( aNfItem[nItem][IT_TIPONF] $ "I|P" )
		If Empty( aNfItem[nItem][IT_ALIQCF2] )
			nBaseCOF := 0
			aNfItem[nItem][IT_BASECF2] := nBaseCOF
		Else

			If aTes[TS_COFBRUT] == "1"
				nDesconto := 0
			Endif	
		
			nBaseCOF := ( aNfItem[nItem][IT_VALMERC] - nDesconto + aNfItem[nItem][IT_DESCZFCOF] + aNfItem[nItem][IT_DESCZFPIS] + aNfItem[nitem][IT_VALSOL] )
			If !(aNfCab[NF_CLIFOR]=='C'.And.aNfCab[NF_CALCSUF]$'SI'.And.!aNFitem[nItem][IT_TIPONF ]$'BD'.And. !aNfCab[NF_LINSCR] .And. aTes[TS_ISS]<>"S" .And. GetNewPar("MV_DESCZF",.T.) .And. GetNewPar("MV_DESZFPC",.F.))
				nBaseCOF += aNfItem[nItem][IT_DESPESA] + aNfItem[nItem][IT_SEGURO] + aNfItem[nItem][IT_FRETE]
			EndIf				
			//�������������������������������������������������������������������������������������������������Ŀ
			//� Caso seja comerciante atacadista, o valor do IPI deve ser retirado da base de calculo do COFINS �
			//� pois esta embutido no valor da mercadoria                                                       �			
			//��������������������������������������������������������������������������������������������������				
			If aTes[TS_CREDICM] == "S" .And. SuperGetMV("MV_DEDBCOF") $ "S,I"
				nBaseCOF -= aNfItem[nItem][IT_VALICM]
			EndIf			
			If aTes[TS_CREDIPI] == "N" .And. SuperGetMV("MV_DEDBCOF") $ "S,P" .And. aTes[TS_IPI] <> "R"
				nBaseCOF += aNfItem[nItem][IT_VALIPI]
			EndIf
			If aTes[TS_CREDIPI] == "S" .And. SuperGetMV("MV_DEDBCOF") $ "S,P" .And. aTes[TS_IPI] == "R"
				nBaseCOF -= aNfItem[nItem][IT_VALIPI]
			EndIf
			

			If aTes[TS_COFDSZF] == "2"
				nBaseCOF += aNfItem[nItem][IT_DESCZF] - (aNfItem[nItem][IT_DESCZFCOF] + aNfItem[nItem][IT_DESCZFPIS])
			Endif	
				                    
			//����������������������������������������������������������������������������������������Ŀ
			//� Indica o tratamento para retirada do valor do ICMS solidario na base do PIS apurado    �
			//� 1 - Nunca retira                                                                       �
			//� 2 - Retira se houver credito do ICMS ST                                                �
			//� 3 - Retira se nao houver credito do ICMS ST                                            �
			//� 4 - Retira se houver credito do ICMS normal                                            �
			//� 5 - Retira se nao houver credito do ICMS normal                                        �
			//� 6 - Sempre retira                                                                      �
			//������������������������������������������������������������������������������������������
			If cDebSTCOF == "6" .Or. ;
				( aTes[TS_CREDST]  == "1" .And. cDebSTCOF == "2" ) .Or. ;
				( aTes[TS_CREDST]  == "2" .And. cDebSTCOF == "3" ) .Or. ;
				( aTes[TS_CREDICM] == "S" .And. cDebSTCOF == "4" ) .Or. ;
				( aTes[TS_CREDICM] == "N" .And. cDebSTCOF == "5" )
				nBaseCof -= aNfItem[nitem][IT_VALSOL]
			Endif
			
			nBaseCOF *= nFatRedCOF
			aNfItem[nItem][IT_BASECF2] := nBaseCOF
		EndIf
	Else
		nBaseCOF := 0
		aNfItem[nItem][IT_BASECF2] := nBaseCOF
	EndIf

EndIf 
	      
If cTipo $ "23" 	
	If (lMaCalcCof .And. aMaCalcCOF[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCCOF=="S" .And. aNfCab[NF_RECCOFI] $ "S|P" .And. ( MaSBCampo("COFINS")==Nil .Or. MaSBCampo("COFINS")=="1" .Or. aNfCab[NF_RECCOFI] == "P" )	)
		nBaseCOF := aNfItem[nItem,IT_BASEDUP]+IIf(cCofBru=="1",nDesconto,0)
		nBaseCOF *= nFatRedCOF
		aNfItem[nItem][IT_BASECOF] := nBaseCOF
	Else
		aNfItem[nItem][IT_BASECOF] := 0
	EndIf 

EndIf	
	
Return( nBaseCOF )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBsCSL� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o base de Calculo do CSL .                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisBSCSL(nItem)

Local lMaCalcCSL := ExistBlock("MaCalcCSL")
Local aMaCalcCSL := {}
Local nDesconto  := aNfItem[nItem][IT_DESCONTO]   
Local cCSLLBru	 := GetNewPar("MV_CSLLBRU","2")
	
//���������������������������������������������������������������������������Ŀ
//�Caso o parametro indique a base de calculo pelo valor bruto da nota fiscal,�
//�somar o valor do desconto concedido ao total da duplicata.                 �
//�����������������������������������������������������������������������������
If cCSLLBru <> "1"
	nDesconto := 0
Endif	
	
If lMaCalcCSL
	aMaCAlcCSL := ExecBlock("MaCalcCSL")
EndIf

If ((lMaCalcCSL .And. aMaCalcCSL[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCCSL=="S")) .And. aNfItem[nItem][IT_TIPONF]<>"D" .And.;
		( aNfCab[NF_RECCSLL] $ "S|P" ) .And. ( MaSBCampo("CSLL")==Nil .Or. MaSBCampo("CSLL")=="1" .Or. aNfCab[NF_RECCSLL] == "P" )
		
	//������������������������������������������������������������Ŀ
	//� A base de calculo da retencao eh o valor da duplicata      �
	//��������������������������������������������������������������
	aNfItem[nItem][IT_BASECSL] := aNfItem[nItem,IT_BASEDUP] + Iif(aNfItem[nItem,IT_BASEDUP] > 0,nDesconto,0)
Else
	aNfItem[nItem][IT_BASECSL] := 0
EndIf

Return(aNfItem[nItem][IT_BASECSL])

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBsPIS� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o base de Caluculo do PIS .                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
���          �ExpC1: Tipo : 1-Apuracao / 2-Retencao / 3-Ambos ( padrao )  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MaFisBSPIS(nItem,cTipo)

Local cDebSTPIS     := GetNewPar("MV_DBSTPIS","1")

Local nBasePis	 := 0
Local nRedBsPis	 := MaSBCampo("REDPIS")
Local nFatRedPis := 1   
Local nDesconto  := aNfItem[nItem][IT_DESCONTO]   

Local lMaCalcPIS := ExistBlock("MaCalcPIS")
Local aMaCalcPIS := {}
	
Local cPisBru	:= GetNewPar("MV_PISBRU","2")
	
DEFAULT cTipo    := "3"

If lMaCalcPIS
	aMaCalcPIS := ExecBlock("MaCalcPIS")
EndIf

//������������������������������������������������������������Ŀ
//� Caso retorne corretamente a reducao, calcula o fator       �
//��������������������������������������������������������������
DEFAULT nRedBsPIS := 0
If nRedBsPIS <> 0
	nFatRedPis	:= If( nRedBsPis>0,1-nRedBsPis/100,1)
EndIf
nRedBsPis := aTES[TS_BASEPIS]/100
If nRedBsPIS <> 0
	nFatRedPis	*= If( nRedBsPis>0,1-nRedBsPis,1)
EndIf
      
If cTipo $ "13"

	If aTES[TS_PISCRED] <> "3" .And. aTES[TS_PISCOF]$"13" .And. !( aNfItem[nItem][IT_TIPONF] $ "I|P" )
		If Empty( aNfItem[nItem][IT_ALIQPS2] )
			nBasePis := 0
			aNfItem[nItem][IT_BASEPS2] := nBasePis
		Else     
		
			If aTes[TS_PISBRUT] == "1"
				nDesconto := 0
			Endif	
		
			nBasePis := ( aNfItem[nItem][IT_VALMERC] - nDesconto + aNfItem[nitem][IT_VALSOL] + aNfItem[nItem][IT_DESCZFCOF] + aNfItem[nItem][IT_DESCZFPIS] )
			If !(aNfCab[NF_CLIFOR]=='C'.And.aNfCab[NF_CALCSUF]$'SI'.And.!aNFitem[nItem][IT_TIPONF ]$'BD'.And. !aNfCab[NF_LINSCR] .And. aTes[TS_ISS]<>"S" .And. GetNewPar("MV_DESCZF",.T.) .And. GetNewPar("MV_DESZFPC",.F.))
				nBasePis += aNfItem[nItem][IT_DESPESA] + aNfItem[nItem][IT_SEGURO] + aNfItem[nItem][IT_FRETE]
			EndIf
			//����������������������������������������������������������������������������������������������Ŀ
			//� Caso seja comerciante atacadista, o valor do IPI deve ser retirado da base de calculo do PIS �
			//� pois esta embutido no valor da mercadoria                                                    �			
			//������������������������������������������������������������������������������������������������
			If aTes[TS_CREDICM] == "S" .And. SuperGetMV("MV_DEDBPIS") $ "S,I"
				nBasePis -= aNfItem[nItem][IT_VALICM]
			EndIf
			If aTes[TS_CREDIPI] == "N" .And. SuperGetMV("MV_DEDBPIS") $ "S,P" .And. aTes[TS_IPI]<>"R"
				nBasePis += aNfItem[nItem][IT_VALIPI]
			EndIf
			If aTes[TS_CREDIPI] == "S" .And. SuperGetMV("MV_DEDBPIS") $ "S,P" .And. aTes[TS_IPI]=="R"
				nBasePis -= aNfItem[nItem][IT_VALIPI]
			EndIf

			If aTes[TS_PISDSZF] == "2"
				nBasePis += aNfItem[nItem][IT_DESCZF] - (aNfItem[nItem][IT_DESCZFCOF] + aNfItem[nItem][IT_DESCZFPIS])
			Endif	
		
			//����������������������������������������������������������������������������������������Ŀ
			//� Indica o tratamento para retirada do valor do ICMS solidario na base do PIS apurado    �
			//� 1 - Nunca retira                                                                       �
			//� 2 - Retira se houver credito do ICMS ST                                                �
			//� 3 - Retira se nao houver credito do ICMS ST                                            �
			//� 4 - Retira se houver credito do ICMS normal                                            �
			//� 5 - Retira se nao houver credito do ICMS normal                                        �
			//� 6 - Sempre retira                                                                      �
			//������������������������������������������������������������������������������������������
			If cDebSTPIS == "6" .Or. ;
				( aTes[TS_CREDST]  == "1" .And. cDebSTPIS == "2" ) .Or. ;
				( aTes[TS_CREDST]  == "2" .And. cDebSTPIS == "3" ) .Or. ;
				( aTes[TS_CREDICM] == "S" .And. cDebSTPIS == "4" ) .Or. ;
				( aTes[TS_CREDICM] == "N" .And. cDebSTPIS == "5" )
				nBasePis -= aNfItem[nitem][IT_VALSOL]
			Endif
						
			nBasePis *= nFatRedPis
			aNfItem[nItem][IT_BASEPS2] := nBasePis
		EndIf
	Else
		nBasePIS := 0
		aNfItem[nItem][IT_BASEPS2] := nBasePis
	EndIf
	
EndIf 

If cTipo $ "23"
	If ((lMaCalcPIS .And. aMaCalcPIS[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCPIS=="S")) .And. aNfCab[NF_RECPIS]$"S|P" .And. ( MaSBCampo("PIS")==Nil .Or. MaSBCampo("PIS")=="1" .Or. aNfCab[NF_RECPIS]=="P" )
		nBasePis := aNfItem[nItem,IT_BASEDUP]+IIf(cPisBru=="1",nDesconto,0)
		nBasePis *= nFatRedPis
		aNfItem[nItem][IT_BASEPIS] := nBasePis
	Else
		aNfItem[nItem][IT_BASEPIS] := 0
	EndIf
	
EndIf 	
	
Return( nBasePIS )


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVlCOF� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o valor  do COFINS                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
���          �ExpC1: Tipo : 1-Apuracao / 2-Retencao / 3-Ambos ( padrao )  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVLCOF(nItem,cTipo)

Local nVlCOF   := 0
Local aRelImp  := {}
Local aRelImp2 := {}
Local nVlCOFEt := 0
Local nVlCOFSa := 0      

Local lMaCalcCOF := ExistBlock("MaCalcCOF")
Local aMaCalcCOF := {}

DEFAULT cTipo  := "3" 
	
If lMaCalcCOF
	aMaCalcCOF := ExecBlock("MaCalcCOF")
EndIf

If cTipo $ "13" 

	If Empty( aNfItem[nItem,IT_BASECF2] ) .Or. ( Empty( SB1->( FieldPos( "B1_VLR_COF" ) ) ) .Or. Empty( MaSBCampo( "VLR_COF" ))) .And. (Empty(aNFitem[nItem,IT_EXCECAO]).Or.Empty(aNFItem[nItem,IT_EXCECAO,11])) 
		//������������������������������������������������������������Ŀ
		//� Calcula o valor do PIS apurado                             �
		//��������������������������������������������������������������
		nVlCof := aNfItem[nItem][IT_BASECF2]*aNfItem[nItem][IT_ALIQCF2]/100
	Else 	                                 
		//������������������������������������������������������������Ŀ
		//� Calcula o valor do PIS apurado de pauta                    �
		//��������������������������������������������������������������
		If ( Empty(aNFitem[nItem,IT_EXCECAO]).Or.Empty(aNFItem[nItem,IT_EXCECAO,11]))
			nVlCof := aNfItem[nItem,IT_QUANT] * MaSBCampo( "VLR_COF" )
		Else	
			nVlCof := aNfItem[nItem,IT_QUANT] * aNFItem[nItem,IT_EXCECAO,11]
		EndIf 	
	EndIf 	
	aNfItem[nItem][IT_VALCF2] := nVlCOF
	If aNFCab[NF_TIPONF] $ "DB"
		aRelImp  := MaFisRelImp("MT100",{ "SD1" })
		aRelImp2 := MaFisRelImp("MT100",{ "SD2" })	
	
		If !Empty(aNFItem[nItem][IT_RECORI])
			If ( aNFCab[NF_CLIFOR] == "C")
				dbSelectArea("SD2")
				MsGoto(aNFItem[nItem][IT_RECORI])
				If !Empty( nScanCOF := aScan(aRelImp2,{|x| x[1]=="SD2" .And. x[3]=="IT_VALCF2"} ) )
					nVlCOFSa := SD2->( FieldGet(FieldPos( aRelImp2[nScanCOF,2] ) ))
				EndIf
				If Abs(aNfItem[nItem][IT_VALCF2]-nVlCOFSa)<=1 .And. aNfItem[nItem][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
					aNfItem[nItem][IT_VALCF2] := nVlCOFSa
				EndIf
			Else
				dbSelectArea("SD1")
				MsGoto(aNFItem[nItem][IT_RECORI])
				If !Empty( nScanCOF := aScan(aRelImp ,{|x| x[1]=="SD1" .And. x[3]=="IT_VALCF2"} ) )
					nVlCOFEt := SD1->( FieldGet(FieldPos( aRelImp[nScanCOF,2] ) ) )
				EndIf
				If Abs(aNfItem[nItem][IT_VALCF2]-nVlCOFEt)<=1 .And. aNfItem[nItem][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
					aNfItem[nItem][IT_VALCF2] := nVlCOFEt
				EndIf
			EndIf
		EndIf
		nVlCOF := aNfItem[nItem][IT_VALCF2]
	EndIf		
	If aNfCab[NF_CLIFOR]=='C'.And.!aNfCab[NF_CALCSUF]$'IN '.And.!aNFitem[nItem][IT_TIPONF ]$'BD'.And. !aNfCab[NF_LINSCR] .And. aTes[TS_ISS]<>"S" .And. GetNewPar("MV_DESCZF",.T.) .And. GetNewPar("MV_DESZFPC",.F.)
		aNfItem[nItem][IT_DESCZF]    -= aNfItem[nItem][IT_DESCZFCOF]
		If aNfCab[NF_ROTINA] == 'MATA461'
			aNfItem[nItem][IT_VALMERC] += aNfItem[nItem][IT_DESCZFCOF]
			aNfItem[nItem][IT_VALMERC] -= MyNoRound(aNfItem[nItem][IT_VALCF2],2)
			aNfItem[nItem][IT_PRCUNI]  := (aNfItem[nItem][IT_VALMERC]-aNfItem[nItem][IT_DESCONTO])/aNfItem[nItem][IT_QUANT]
		EndIf
		
		aNfItem[nItem][IT_DESCZFCOF] := MyNoRound(aNfItem[nItem][IT_VALCF2],2)
		aNfItem[nItem][IT_DESCZF]    += aNfItem[nItem][IT_DESCZFCOF]
		aNfItem[nItem][IT_VALCF2]  := 0
		aNfItem[nItem][IT_BASECF2] := 0
	EndIf	
EndIf 	
	
If cTipo $ "23" 		 

	If (lMaCalcCof .And. aMaCalcCOF[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCCOF=="S")	
		nVlCOF := aNfItem[nItem][IT_BASECOF]*aNfItem[nItem][IT_ALIQCOF]/100
		aNfItem[nItem][IT_VALCOF] := nVlCOF
	Else
		aNfItem[nItem][IT_VALCOF] := 0
	EndIf
EndIf 
	
Return(nVlCOF)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVLCSL� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o valor do CSLL.                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaFisVLCSL(nItem)

Local lMaCalcCSL := ExistBlock("MaCalcCSL")
Local aMaCalcCSL := {}
	
If lMaCalcCSL
	aMaCAlcCSL := ExecBlock("MaCalcCSL")
EndIf

If ((lMaCalcCSL .And. aMaCalcCSL[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCCSL=="S")) .And.aNfItem[nItem][IT_TIPONF]<>"D"
	aNfItem[nItem][IT_VALCSL] := aNfItem[nItem][IT_BASECSL]*aNfItem[nItem][IT_ALIQCSL]/100
Else
	aNfItem[nItem][IT_VALCSL] := 0
EndIf
Return(aNfItem[nItem][IT_VALCSL])


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVLPIS� Autor � Edson Maricate        � Data �04.01.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o valor do PIS .                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item.                                                ���
���          �ExpC1: Tipo : 1-Apuracao / 2-Retencao / 3-Ambos ( padrao )  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MaFisVLPIS(nItem,cTipo)

LOCAL nVlPis   := 0
Local aRelImp  := {}
Local aRelImp2 := {}
Local nVlPisEt := 0
Local nVlPisSa := 0          

Local lMaCalcPIS := ExistBlock("MaCalcPIS")
Local aMaCalcPIS := {}
	
DEFAULT cTipo  := "3" 

If lMaCalcPIS
	aMaCalcPIS := ExecBlock("MaCalcPIS")
EndIf

If cTipo $ "13" 

	If Empty( aNfItem[nItem,IT_BASEPS2] ) .Or. ( Empty( SB1->( FieldPos( "B1_VLR_PIS" ) ) ) .Or. Empty( MaSBCampo( "VLR_PIS" ))) .And. (Empty(aNFitem[nItem,IT_EXCECAO]).Or.Empty(aNFItem[nItem,IT_EXCECAO,10])) 
		//������������������������������������������������������������Ŀ
		//� Calcula o valor do PIS apurado                             �
		//��������������������������������������������������������������
		nVlPis := aNfItem[nItem][IT_BASEPS2]*aNfItem[nItem][IT_ALIQPS2]/100
	Else 	                                 
		//������������������������������������������������������������Ŀ
		//� Calcula o valor do PIS de pauta                            �
		//��������������������������������������������������������������
		If ( Empty(aNFitem[nItem,IT_EXCECAO]).Or.Empty(aNFItem[nItem,IT_EXCECAO,10]))
			nVlPis := aNfItem[nItem,IT_QUANT] * MaSBCampo( "VLR_PIS" )
		Else	
			nVlPis := aNfItem[nItem,IT_QUANT] * aNFItem[nItem,IT_EXCECAO,10]
		EndIf 	
	EndIf 	
	
	aNfItem[nItem][IT_VALPS2] := nVlPis
	If aNFCab[NF_TIPONF] $ "DB"
		aRelImp  := MaFisRelImp("MT100",{ "SD1" })
		aRelImp2 := MaFisRelImp("MT100",{ "SD2" })	
	
		If !Empty(aNFItem[nItem][IT_RECORI])
			If ( aNFCab[NF_CLIFOR] == "C")
				dbSelectArea("SD2")
				MsGoto(aNFItem[nItem][IT_RECORI])
				If !Empty( nScanPis := aScan(aRelImp2,{|x| x[1]=="SD2" .And. x[3]=="IT_VALPS2"} ) )
					nVlPisSa := SD2->( FieldGet(FieldPos( aRelImp2[nScanPis,2] ) ))
				EndIf
				If Abs(aNfItem[nItem][IT_VALPS2]-nVlPisSa)<=1 .And. aNfItem[nItem][IT_QUANT] == SD2->D2_QUANT .And. SD2->D2_VALFRE+SD2->D2_SEGURO+SD2->D2_DESPESA==0
					aNfItem[nItem][IT_VALPS2] := nVlPisSa
				EndIf
			Else
				dbSelectArea("SD1")
				MsGoto(aNFItem[nItem][IT_RECORI])
				If !Empty( nScanPis := aScan(aRelImp ,{|x| x[1]=="SD1" .And. x[3]=="IT_VALPS2"} ) )
					nVlPisEt := SD1->( FieldGet(FieldPos( aRelImp[nScanPis,2] ) ) )
				EndIf
				If Abs(aNfItem[nItem][IT_VALPS2]-nVlPisEt)<=1 .And. aNfItem[nItem][IT_QUANT] == SD1->D1_QUANT .And. SD1->D1_VALFRE+SD1->D1_SEGURO+SD1->D1_DESPESA==0
					aNfItem[nItem][IT_VALPS2] := nVlPisEt
				EndIf
			EndIf
		EndIf
		nVlPis := aNfItem[nItem][IT_VALPS2]
	EndIf
	If aNfCab[NF_CLIFOR]=='C'.And.!aNfCab[NF_CALCSUF]$'IN '.And.!aNFitem[nItem][IT_TIPONF ]$'BD'.And. !aNfCab[NF_LINSCR] .And. aTes[TS_ISS]<>"S" .And. GetNewPar("MV_DESCZF",.T.) .And. GetNewPar("MV_DESZFPC",.F.) 
		aNfItem[nItem][IT_DESCZF]    -= aNfItem[nItem][IT_DESCZFPIS]
		If aNfCab[NF_ROTINA] == 'MATA461'
			aNfItem[nItem][IT_VALMERC] += aNfItem[nItem][IT_DESCZFPIS]
			aNfItem[nItem][IT_VALMERC] -= MyNoRound(aNfItem[nItem][IT_VALPS2],2)
			aNfItem[nItem][IT_PRCUNI]  := (aNfItem[nItem][IT_VALMERC]-aNfItem[nItem][IT_DESCONTO])/aNfItem[nItem][IT_QUANT]
		EndIf		
		aNfItem[nItem][IT_DESCZFPIS] := MyNoRound(aNfItem[nItem][IT_VALPS2],2)
		aNfItem[nItem][IT_DESCZF]    += aNfItem[nItem][IT_DESCZFPIS]
		aNfItem[nItem][IT_VALPS2]    := 0
		aNfItem[nItem][IT_BASEPS2]   := 0
	EndIf
EndIf	
	          
If cTipo $ "23" 	

	If (lMaCalcPIS .And. aMaCalcPIS[1]=="S") .Or. (!Empty(aNfCab[NF_NATUREZA]) .And. SED->ED_CALCPIS=="S")	
		nVlPis := aNfItem[nItem][IT_BASEPIS]*aNfItem[nItem][IT_ALIQPIS]/100
		aNfItem[nItem][IT_VALPIS] := nVlPis
	Else
		aNfItem[nItem][IT_VALPIS] := 0
	EndIf
EndIf 
	
Return(nVlPis)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaItArred� Autor � Edson Maricate         � Data �12.04.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa a correcao dos arredondamentos do item             ���
���          � Utiliza o Array aSaveDec para armazenar os centesimos      ���
���          � que foram truncados. ( aSaveDec deve estar inicializado    ���
���          � obrigatoriamente pela MaFisIni() )                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MaItArred(nX,aRefs)

Local nY        := 0
Local nDec      := 0
Local nDif      := 0
Local nValor 	:= 0
Local nDifItem	:= 0

If aItemRef == Nil
	MaIniRef()
EndIf
//������������������������������������������������������������Ŀ
//� Executa a correcao nos arredondamentos.                    �
//��������������������������������������������������������������
For nY := 1 to Len(aItemRef)
	If aRefs == Nil .Or. Ascan( aRefs, aItemRef[nY][1] )<>0
		If aItemRef[nY][4]
			nDifItem	:= 0
			If cPaisLoc<>"BRA"
				If FunName()=="MATA121" .And. Type("nMoedaPed")=="N"
					nDec:=MsDecimais(nMoedaPed)
				ElseIf FunName()=="MATA150" .And. Type("nMoedaCot")=="N"
					nDec:=MsDecimais(nMoedaCot)
				ElseIf Type("nMoedaNF")=="N"
					nDec:=MsDecimais(nMoedaNF)
				ElseIf Type("nMoedaCor")=="N"
					nDec:=MsDecimais(nMoedaCor)
				ElseIf Type("M->F1_MOEDA")=="N"
					nDec:=MsDecimais(M->F1_MOEDA)
				ElseIf Type("M->F2_MOEDA")=="N"
					nDec:=MsDecimais(M->F2_MOEDA)
				Else
					nDec:=MsDecimais(1)
				Endif
				nDif:=10**(-nDec)
			Endif
			If ValType(aItemRef[nY][2]) == "A"
				nValor := aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]]
				If nValor <> 0
					If cPaisLoc=="BRA"
						aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] := MyNoRound(nValor,2,@nDifItem,10)
                        If nDifItem <> 0
	 					   If !aItemRef[nY][5]
	 						  If aRefs <> Nil
		 						 aSaveDec[nY] := Max(0,aSaveDec[nY]-aItemDec[nX][2][nY])
		 					  EndIf
							  aItemDec[nX][2][nY]	:= nDifItem
							  aSaveDec[nY]			+= nDifItem
							  If MyNoRound(aSaveDec[nY],2) >= 0.01
								 aItemDec[nX][1][nY]	:= 0.01 - nDifItem
							 	 aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] += 0.01
								 aSaveDec[nY] -= 0.01
							  EndIf
						   ElseIf nDifItem > 0 .And. 	aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] > 0
	 						  If aRefs <> Nil
		 						 aSaveDec[nY] := Max(0,aSaveDec[nY]-aItemDec[nX][2][nY])
		 					  EndIf
							  aItemDec[nX][2][nY]	:= nDifItem
							  aSaveDec[nY]			+= nDifItem
							  If aSaveDec[nY] >= 0.0045
								 aItemDec[nX][1][nY]	-= 0.01
								 aSaveDec[nY] -= 0.01
								 aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] += 0.01
							  EndIf
						   EndIf
						Endif   
					Else
						aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] := MyNoRound(nValor,nDec,@nDifItem,10)
						If nDifItem <> 0
						   aItemDec[nX][2][nY]	 :=	nDifItem
						   aSaveDec[nY] 	+= nDifItem
						   If MyNoRound(aSaveDec[nY],nDec+1)>=(nDif/2)
							  aItemDec[nX][1][nY]	:= nDif - nDifItem
							  aNfItem[nX][aItemRef[nY][2][1]][aItemRef[nY][2][2]] += nDif
							  aSaveDec[nY] 	-= nDif
						   EndIf
						Endif   
					EndIf
				EndIf
			Else
				nValor := aNfItem[nX][Val(aItemRef[nY][2])]
				If nValor <> 0
					If cPaisLoc=="BRA"
						aNfItem[nX][Val(aItemRef[nY][2])] := MyNoRound(nValor,2,@nDifItem,10)
						If nDifItem <> 0
						   If !aItemRef[nY][5]
							  aItemDec[nX][2][nY]	:= nDifItem
							  aSaveDec[nY]		+= nDifItem
							  If MyNoRound(aSaveDec[nY],2) >= 0.01
								 aItemDec[nX][1][nY]	:= 0.01 - nDifItem
								 aNfItem[nX][Val(aItemRef[nY][2])] += 0.01
								 aSaveDec[nY] -= 0.01
							  EndIf
						   ElseIf nDifItem > 0
							  nDifItem *= -1
							  If aSaveDec[nY] == 0 .Or. MyNoRound(Abs(aSaveDec[nY]+nDifItem),2) >= 0.01
								 aNfItem[nX][Val(aItemRef[nY][2])] += 0.01
							  EndIf
							  aItemDec[nX][2][nY]	:= nDifItem
							  aSaveDec[nY]		+= nDifItem
							  If MyNoRound(Abs(aSaveDec[nY]),2) >= 0.01
								 aItemDec[nX][1][nY]	:= 0.01 + nDifItem
								 aSaveDec[nY] += 0.01
								 If MyNoRound(Abs(aSaveDec[nY]),3) <= 0.004
									aNfItem[nX][Val(aItemRef[nY][2])] -= 0.01
								 EndIf
							  EndIf					
						   EndIf
						Endif   
					Else
						aNfItem[nX][Val(aItemRef[nY][2])]:= MyNoRound(nValor,nDec,@nDifItem,10)
						If nDifItem <> 0
						   aItemDec[nX][2][nY]	:= nDifItem
						   aSaveDec[nY]		+= nDifItem
						   If MyNoRound(aSaveDec[nY],nDec+1) >=	(nDif/2)
							  aItemDec[nX][1][nY]	:= nDif - nDifItem
							  aNfItem[nX][Val(aItemRef[nY][2])] += nDif
							  aSaveDec[nY] -= nDif
						   EndIf
						Endif   
					Endif
				EndIf
			EndIf
		EndIf
	EndIf
Next nY

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisTpCon� Autor � Sergio Silveira       � Data �04/07/2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Converte o tipo do fornecedor                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpC1 := MaFisTpCon( ExpC2 )                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpC1 -> Tipo convertido                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC2 : Tipo                                               ���
���          � ExpC2 : Loja do Cliente / Fornecedor                       ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MaFisTpCon( cCodOri )

LOCAL cCodRet := ""

If cCodOri == "J" .Or. cCodOri == " "
	cCodRet := "R"
Else
	cCodRet := cCodOri
EndIf

Return( cCodRet )

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisIniNF� Rev.  � Eduardo Riera         � Data �08.08.2001 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de Inicializacao da funcao fiscal com base nas Notas  ���
���          �Fiscais                                                      ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Tipo de Nota Fiscal                                   ���
���          �       [1] Nota Fiscal de Entrada                            ���
���          �       [2] Nota Fiscal de Saida                              ���
���          �ExpX2: Numero do Registro do Cabecalho da Nota Fiscal, ou    ���
���          �       o Alias da Tabela a ser considerada.                  ���
���          �ExpA3: Array para Otimizacao ( Uso Interno deve-se apenas    ���
���          �       assegurar que seu valor foi amazenado externamente a  ���
���          �       esta rotina)                                          ���
���          �ExpC4: Alias da tabela de notas fiscais de entrada      (OPC)���
���          �ExpL5: Indica se deve ser recalculada a base dos impostos    ���
���          �       Fiscais                                          (OPC)���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo atualizar a funcao fiscal com  ���
���          �base em uma nota fiscal de entrada ou saida. A Funcao Fiscal ���
���          �eh atualizada com base nas referencias do dicionario de dados���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Function MaFisIniNF(nTipoNF,nRecSF,aOtimizacao,cAlias,lReprocess)

Local aArea		:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSF2	:= SF2->(GetArea())

Local cAlias2   := ""

Local lQuery    := .F.
Local lISS      := .F.
Local lGravou   := .F.
Local nX        := 0
Local nY		:= 0
Local nValor    := 0        

#IFDEF TOP 
	Local aStru     := {}
	Local cQuery    := ""
#ENDIF 	

DEFAULT lReprocess := .F.

Do Case
	//������������������������������������������������������������������������Ŀ
	//�Inicializacao das Notas Fiscais de Entrada                              �
	//��������������������������������������������������������������������������
Case nTipoNF == 1
	//������������������������������������������������������������������������Ŀ
	//�Verifica se o Array de otimizacao esta disponivel                       �
	//��������������������������������������������������������������������������
	If Empty(aOtimizacao)
		aOtimizacao := {MaFisSXRef("SF1"),MaFisSxRef("SD1")}
	EndIf
	cAlias2 := "SD1"
	If Empty(cAlias)
		cAlias := "SF1"
		dbSelectArea(cAlias)
		MsGoto(nRecSF)
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Inicializa cabecalho da funcao fiscal                                   �
	//��������������������������������������������������������������������������
	MaFisEnd()
	MaFisIni((cAlias)->F1_FORNECE,(cAlias)->F1_LOJA,IIF((cAlias)->F1_TIPO$'DB',"C","F"),(cAlias)->F1_TIPO,"R",,If((cAlias)->F1_TIPO=="C",AllTrim((cAlias)->F1_ORIGLAN),Nil))
	If (cAlias)->F1_TIPO$"DB" .And. !lReprocess
		MaFisAlt("NF_UFDEST",(cAlias)->F1_EST)
	Else
		MaFisAlt("NF_UFORIGEM",(cAlias)->F1_EST)
	EndIf
	MaFisAlt("NF_ESPECIE",(cAlias)->F1_ESPECIE)
	//������������������������������������������������������������������������Ŀ
	//�Monta a query para otimizacao.                                          �
	//��������������������������������������������������������������������������
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			aStru   := SD1->(dbStruct())
			lQuery  := .T.
			cAlias2 := "MaFisIniNF"
			cQuery  := "SELECT SD1.*,SD1.R_E_C_N_O_ SD1RECNO FROM "+RetSqlName("SD1")+" SD1 "
			cQuery  += "WHERE "
			cQuery  += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
			cQuery  += "SD1.D1_DOC = '"+(cAlias)->F1_DOC+"' AND "
			cQuery  += "SD1.D1_SERIE = '"+(cAlias)->F1_SERIE+"' AND "
			cQuery  += "SD1.D1_FORNECE = '"+(cAlias)->F1_FORNECE+"' AND "
			cQuery  += "SD1.D1_LOJA = '"+(cAlias)->F1_LOJA+"' AND "
			cQuery  += "SD1.D1_TIPO= '"+(cAlias)->F1_TIPO+"' AND "
			cQuery  += "SD1.D_E_L_E_T_=' ' "
			cQuery  += "ORDER BY "+SqlOrder(IndexKey())

			cQuery  := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias2,.T.,.T.)
			For nX := 1 To Len(aStru)
				If aStru[nX][2] <> "C"
					TcSetField(cAlias2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
				EndIf
			Next nX
		Else
	#ENDIF
		MsSeek(xFilial("SD1")+(cAlias)->F1_DOC+(cAlias)->F1_SERIE+(cAlias)->F1_FORNECE+(cAlias)->F1_LOJA)
		#IFDEF TOP				
		EndIf
		#ENDIF
	dbSelectArea(cAlias2)
	While ( !Eof() .And. (cAlias2)->D1_FILIAL == xFilial("SD1") .And.;
			(cAlias2)->D1_DOC == (cAlias)->F1_DOC .And.;
			(cAlias2)->D1_SERIE == (cAlias)->F1_SERIE .And.;
			(cAlias2)->D1_FORNECE == (cAlias)->F1_FORNECE .And.;
			(cAlias2)->D1_LOJA == (cAlias)->F1_LOJA )
		If (cAlias2)->D1_TIPO == (cAlias)->F1_TIPO
			//������������������������������������������������������������������������Ŀ
			//�Inicializa os itens da funcao fiscal                                    �
			//��������������������������������������������������������������������������
			nY++
			MaFisIniLoad(nY)
			//���������������������������������������������Ŀ
			//�Busca o codigo do ISS na tabela de produtos. �
			//�����������������������������������������������
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+(cAlias2)->D1_COD))
				aNFitem[nY][IT_CODISS]	:=	SB1->B1_CODISS
			Endif
					
			For nX := 1 To Len(aOtimizacao[2])
				MaFisLoad(aOtimizacao[2][nX][2],FieldGet(FieldPos(aOtimizacao[2][nX][1])),nY)
			Next nX
			MaFisEndLoad(nY,2)
			If lReprocess
				MaFisBSIPI(nY,.T.)	// Calcula a Base de IPI Original
				MaFisBSICM(nY,.T.)	// Calcula a Base de ICMS Original
				MaFisLF(nY)			// Atualiza os valores do Livro Fiscal
				MaFisLF2(nY)		// Verifica se a TES possui RdMake para complemento/geracao dos Livros
			EndIf
		EndIf
		If (cAlias2)->D1_ORIGLAN<>(cAlias)->F1_ORIGLAN
			If lQuery
				SD1->(MsGoto((cAlias2)->SD1RECNO))
			EndIf		
			RecLock("SD1",.F.)
			SD1->D1_ORIGLAN := (cAlias)->F1_ORIGLAN
			MsUnlock()
		EndIf		
		dbSelectArea(cAlias2)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAlias2)
		dbCloseArea()
		dbSelectArea("SD1")
	EndIf

	If (cAlias)->F1_IMPORT <> "S"
		MaFisAlt("NF_FRETE"    ,(cAlias)->F1_FRETE)
		MaFisAlt("NF_SEGURO"   ,(cAlias)->F1_SEGURO)
		MaFisAlt("NF_DESPESA"  ,(cAlias)->F1_DESPESA)
	EndIf 	

	//������������������������������������������������������������������������Ŀ
	//�Inicializacao das Notas Fiscais de Saida                                �
	//��������������������������������������������������������������������������	
Case nTipoNF == 2
	//������������������������������������������������������������������������Ŀ
	//�Verifica se o Array de otimizacao esta disponivel                       �
	//��������������������������������������������������������������������������
	If Empty(aOtimizacao)
		aOtimizacao := {MaFisSXRef("SF2"),MaFisSxRef("SD2")}
	EndIf
	cAlias2 := "SD2"
	If Empty(cAlias)
		cAlias := "SF2"
		dbSelectArea(cAlias)
		MsGoto(nRecSF)
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Inicializa cabecalho da funcao fiscal                                   �
	//��������������������������������������������������������������������������
	MaFisEnd()
	MaFisIni((cAlias)->F2_CLIENTE,(cAlias)->F2_LOJA,IIF((cAlias)->F2_TIPO$'DB',"F","C"),(cAlias)->F2_TIPO,(cAlias)->F2_TIPOCLI,{})
	If (cAlias)->F2_TIPO$"DB" .And. !lReprocess
		MaFisAlt("NF_UFORIGEM",(cAlias)->F2_EST)
	Else
		MaFisAlt("NF_UFDEST",(cAlias)->F2_EST)
	EndIf
	MaFisAlt("NF_ESPECIE",(cAlias)->F2_ESPECIE)
	dbSelectArea("SD2")
	dbSetOrder(3)
	//������������������������������������������������������������������������Ŀ
	//�Monta a query para otimizacao.                                          �
	//��������������������������������������������������������������������������
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			aStru   := SD2->(dbStruct())
			lQuery  := .T.
			cAlias2 := "MaFisIniNF"
			cQuery  := "SELECT SD2.*,SD2.R_E_C_N_O_ SD2RECNO FROM "+RetSqlName("SD2")+" SD2 "
			cQuery  += "WHERE "
			cQuery  += "SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
			cQuery  += "SD2.D2_DOC = '"+(cAlias)->F2_DOC+"' AND "
			cQuery  += "SD2.D2_SERIE = '"+(cAlias)->F2_SERIE+"' AND "
			cQuery  += "SD2.D2_CLIENTE = '"+(cAlias)->F2_CLIENTE+"' AND "
			cQuery  += "SD2.D2_LOJA = '"+(cAlias)->F2_LOJA+"' AND "
			cQuery  += "SD2.D_E_L_E_T_=' ' "
			cQuery  += "ORDER BY "+SqlOrder(SD2->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias2,.T.,.T.)

			For nX := 1 To Len(aStru)
				If aStru[nX][2]<>"C"
					TcSetField(cAlias2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
				EndIf
			Next nX
		Else
	#ENDIF
		MsSeek(xFilial("SD2")+(cAlias)->F2_DOC+(cAlias)->F2_SERIE+(cAlias)->F2_CLIENTE+(cAlias)->F2_LOJA)		
		#IFDEF TOP
		EndIf		
		#ENDIF
	dbSelectArea(cAlias)						
	While !Eof().And. (cAlias2)->D2_FILIAL == xFilial("SD2") .And.;
			(cAlias2)->D2_DOC == (cAlias)->F2_DOC .And.;
			(cAlias2)->D2_SERIE == (cAlias)->F2_SERIE .And.;
			(cAlias2)->D2_CLIENTE == (cAlias)->F2_CLIENTE .And.;
			(cAlias2)->D2_LOJA == (cAlias)->F2_LOJA
		//������������������������������������������������������������������������Ŀ
		//�Inicializa os itens da funcao fiscal                                    �
		//��������������������������������������������������������������������������
		nY++
		MaFisIniLoad(nY)
		If !Empty((cAlias2)->D2_CODISS) .Or. (cAlias2)->D2_VALISS > 0
			lISS := .T.
			If !Empty((cAlias2)->D2_CODISS)
				aNFItem[nY][IT_RATEIOISS] := "S"
			EndIf

		EndIf
		For nX := 1 To Len(aOtimizacao[2])
			Do Case
			Case aOtimizacao[2][nX][2] == "IT_VALMERC"
				If cPaisLoc<>"BRA" .And. GetNewPar('MV_DESCSAI','1') =='1'
					nValor := (cAlias2)->D2_TOTAL
				Else
					nValor := (cAlias2)->D2_TOTAL+(cAlias2)->D2_DESCON
				Endif
			Case aOtimizacao[2][nX][2] == "IT_VALISS"
				nValor := IIF(lISS.And.Empty((cAlias2)->D2_VALISS),(cAlias2)->D2_VALICM,(cAlias2)->D2_VALISS)
			Case aOtimizacao[2][nX][2] == "IT_BASEISS"
				nValor := IIF(lISS.And.Empty((cAlias2)->D2_BASEISS),(cAlias2)->D2_BASEICM,(cAlias2)->D2_BASEISS)
			Case aOtimizacao[2][nX][2] == "IT_ALIQISS"
				nValor := IIF(lISS.And.Empty((cAlias2)->D2_ALIQISS),(cAlias2)->D2_PICM,(cAlias2)->D2_ALIQISS)						
			OtherWise
				nValor := (cAlias2)->(FieldGet(FieldPos(aOtimizacao[2][nX][1])))
			EndCase
			MaFisLoad(aOtimizacao[2][nX][2],nValor,nY)
		Next nX
		MaFisLoad("IT_DESCZF",(cAlias2)->D2_DESCZFR,nY)
		MaFisEndLoad(nY,2)
		If lReprocess
			MaFisBSIPI(nY,.T.)	// Calcula a Base de IPI Original
			MaFisBSICM(nY,.T.)	// Calcula a Base de ICMS Original
 			If (cAlias2)->D2_TIPO == "D"
				MaALIQCMP(nY)
				MaFisVComp(nY)
			EndIf
			//Acerto de erro de gravacao ocorrida em 31/05/2003 - Retirar apos 1 ano
			If ((cAlias2)->D2_VALISS==0 .And. (cAlias2)->D2_VALICM==0 ) .And. !Empty((cAlias2)->D2_CODISS)
				nValor := MaAliqIss(nY)
				MaFisBSISS(nY)
				MaFisAlt("IT_ALIQISS",0,nY)
				MaFisAlt("IT_ALIQISS",nValor,nY)
				nValor := MaFisRet(nY,"IT_BASEISS")
				MaFisAlt("IT_BASEISS",0,nY)
				MaFisAlt("IT_BASEISS",nValor,nY)				
				If lQuery
					SD2->(MsGoto((cAlias2)->SD2RECNO))
				EndIf
				If ((cAlias2)->D2_VALISS<>MaFisRet(nY,"IT_VALISS"))
					RecLock("SD2")
					SD2->D2_VALICM   := MaFisRet(nY,'IT_VALISS')
					SD2->D2_BASEICM  := MaFisRet(nY,'IT_BASEISS')
					SD2->D2_PICM     := MaFisRet(nY,'IT_ALIQISS')
					SD2->D2_VALISS   := MaFisRet(nY,'IT_VALISS')
					SD2->D2_BASEISS  := MaFisRet(nY,'IT_BASEISS')
					SD2->D2_ALIQISS  := MaFisRet(nY,'IT_ALIQISS')
					lGravou := .T.
					MsUnLock()				
				EndIf
			EndIf
			
			MaFisAlt("NF_VALPIS"   ,(cAlias)->F2_VALPIS)	
			MaFisAlt("NF_VALCOF"   ,(cAlias)->F2_VALCOFI)	
			MaFisAlt("NF_VALCSL"   ,(cAlias)->F2_VALCSLL)			
			
			MaFisLF(nY)			// Atualiza os valores do Livro Fiscal
			MaFisLF2(nY)		// Verifica se a TES possui RdMake para complemento/geracao dos Livros
		EndIf			
		dbSelectArea(cAlias2)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAlias2)
		dbCloseArea()
		dbSelectArea("SD2")			
	EndIf		
	MaFisAlt("NF_FRETE"    ,(cAlias)->F2_FRETE)
	MaFisAlt("NF_SEGURO"   ,(cAlias)->F2_SEGURO)
	MaFisAlt("NF_DESPESA"  ,(cAlias)->F2_DESPESA)
	MaFisLoad("NF_AUTONOMO" ,(cAlias)->F2_FRETAUT)
	If !lISS
		MaFisAlt("NF_BASEICM"  ,(cAlias)->F2_BASEICM,)
		MaFisAlt("NF_VALICM"   ,(cAlias)->F2_VALICM,)
		MaFisAlt("NF_BASEIPI"  ,(cAlias)->F2_BASEIPI,)
		MaFisAlt("NF_VALIPI"   ,(cAlias)->F2_VALIPI,)
	EndIf
	MaFisAlt("NF_VALICA"   ,(cAlias)->F2_ICMAUTO,)
	MaFisAlt("NF_FUNRURAL" ,(cAlias)->F2_CONTSOC,)
	If !lReprocess
		For nX := 1 To Len(aOtimizacao[1])
			If Empty(MaFisRet(,aOtimizacao[1][nX][2]))
				nValor := (cAlias)->(FieldGet(FieldPos(aOtimizacao[1][nX][1])))
				MaFisAlt(aOtimizacao[1][nX][2],nValor)
			EndIf
		Next nX
	EndIf
	//Acerto dos patchs gerados entre Abril e Maio
	If nRecSF > 0 .And. lReprocess
		SF2->(MsGoto(nRecSF))
		RecLock("SF2")
		SF2->F2_VALBRUT	   := MaFisRet(,"NF_TOTAL")
		If lGravou
			SF2->F2_VALICM   := MaFisRet(,'NF_VALISS')
			SF2->F2_BASEICM  := MaFisRet(,'NF_BASEISS')
			SF2->F2_VALISS   := MaFisRet(,'NF_VALISS')
			SF2->F2_BASEISS  := MaFisRet(,'NF_BASEISS')
		EndIf
		MsUnLock()
	EndIf
EndCase
RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aAreaSD1)
RestArea(aAreaSF1)
RestArea(aArea)
Return .T.

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisAtuSF� Autor � Edson Maricate        � Data �21.02.2000 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de atualizacao dos livros fiscais                     ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1 : Tipo de Operacao                                     ���
���          �        [1] Inclusao                                         ���
���          �        [2] Exclusao                                         ���
���          �ExpC2 : Tipo de Movimento                                    ���
���          �        [E] Entrada                                          ���
���          �        [S] Saida                                            ���
���          �ExpN3 : RecNo do cabecalho da nota fiscal                    ���
���          �ExpC4 : Alias do cabecalho da nota fiscal                    ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo atualizar os livros fiscais com���
���          �base em uma nota fiscal de entrada ou saida.                 ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Function MaFisAtuSF3(nCaso,cTpOper,nRecNF,cAlias,cPDV)

Local aArea		:= GetArea()
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSF2	:= SF2->(GetArea())
Local aLivro	:= {}
Local aFixos 	:= {}
Local aRecSF3	:= {}
Local aSF3      := {}
Local nVlrTotal	:= 0
Local nY       := 0 
Local nX       := 0 
Local cCliFor	:= ""
Local cLoja		:= ""
Local cNumNF	:= ""
Local cSerie	:= ""
Local dDEmissao	:= ""
Local cEspecie	:= ""
Local cFormul	:= ""
Local cQuery    := ""
Local cAliasSF3 := "SF3"
Local dEntrada	:= Ctod("")
Local lObserv	:= .F.
Local lQuery    := .F.

DEFAULT cPDV := ""

Do Case
Case cTpOper=="E"
	If Empty(cAlias)
		cAlias := "SF1"
		dbSelectArea("SF1")
		MsGoto(nRecNF)
	EndIf
	//���������������������������������������������������������Ŀ
	//� Posiciona o cabecalho da NF de Entrada                  �
	//�����������������������������������������������������������
	cCliFor		:= (cAlias)->F1_FORNECE
	cLoja		:= (cAlias)->F1_LOJA
	cNumNF		:= (cAlias)->F1_DOC
	cSerie		:= (cAlias)->F1_SERIE
	dDEmissao	:= (cAlias)->F1_EMISSAO
	cEspecie	:= (cAlias)->F1_ESPECIE
	cFormul		:= (cAlias)->F1_FORMUL
	dEntrada	:= (cAlias)->F1_DTDIGIT
	If cPaisLoc<>"BRA"
		cTipo:=(cAlias)->F1_TIPO
	Endif
	//���������������������������������������������������������Ŀ
	//� Verifica se a NF esta carregada nas Funcoes Fiscais.    �
	//�����������������������������������������������������������
	If nCaso == 1 .And. !MaFisFound("NF")
		MaFisIniNF(1,nRecNF)
	EndIf
	//���������������������������������������������������������Ŀ
	//� Gravar Livro Fiscal da NF refrente ao Despacho.         �
	//�����������������������������������������������������������
	If cPaisLoc == "ARG"
		If nCaso == 1 .and. (cAlias)->F1_TIPO_NF == "9"
			MaFisF3Eic(nCaso)
		EndIf	
	EndIf		
OtherWise
	If Empty(cAlias)
		cAlias := "SF2"
		dbSelectArea("SF2")
		MsGoto(nRecNF)
	EndIf
	//���������������������������������������������������������Ŀ
	//� Posiciona o cabecalho da NF de Saida                    �
	//�����������������������������������������������������������
	cCliFor		:= (cAlias)->F2_CLIENTE
	cLoja			:= (cAlias)->F2_LOJA
	cNumNF		:= (cAlias)->F2_DOC
	cSerie		:= (cAlias)->F2_SERIE
	dDEmissao	:= (cAlias)->F2_EMISSAO
	cEspecie		:= (cAlias)->F2_ESPECIE
	cFormul		:= IIf(cPaisLoc=="BRA"," ",(cAlias)->F2_FORMUL)
	If cPaisLoc <> "BRA"
		If (cAlias)->(FieldPos('F2_DTDIGIT')) > 0
			dEntrada		:= (cAlias)->F2_DTDIGIT
		Else
			dEntrada		:= dDataBase
		EndIf	
	Else
		dEntrada		:= (cAlias)->F2_EMISSAO
	Endif
	If cPaisLoc<>"BRA"
		cTipo:=(cAlias)->F2_TIPO
	Endif
	//�������������������������������������������������������������������Ŀ
	//� Verifica se a NF esta carregada nas Funcoes Fiscais.( Inclusao )  �
	//���������������������������������������������������������������������
	If nCaso == 1 .And. !MaFisFound("NF")
		MaFisIniNF(2,nRecNF)
	EndIf
EndCase
Do Case
Case nCaso == 1
	//���������������������������������������������������������Ŀ
	//� Carega o Array contendo os Registros Fiscais (SF3)      �
	//�����������������������������������������������������������
	dbSelectArea("SF3")
	dbSetOrder(If(cTpOper == "S".Or.cFormul=="S",5,4))
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			cAliasSF3 := "MaFisAtuSF3"
			lQuery    := .T.

			cQuery := "SELECT F3_FILIAL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,"
			cQuery += "F3_LOJA,F3_CFO,F3_FORMUL,F3_DTCANC, R_E_C_N_O_ SF3RECNO "
			cQuery += "FROM "+RetSqlName("SF3")+" SF3 "
			cQuery += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
			cQuery += "SF3.F3_SERIE='"+cSerie+"' AND "
			cQuery += "SF3.F3_NFISCAL='"+cNumNF+"' AND "
			If !(cTpOper=="S".Or.cFormul=="S")
				cQuery += "SF3.F3_CLIEFOR='"+cCliFor+"' AND "
				cQuery += "SF3.F3_LOJA='"+cLoja+"' AND "
			EndIf
			cQuery += "SF3.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SF3->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)	

			TcSetField(cAliasSF3,"F3_DTCANC","D",8,0)
		Else
	#ENDIF
		dbSeek(xFilial("SF3")+IIf(cTpOper=="S".Or.cFormul=="S",cSerie+cNumNF,cCliFor+cLoja+cNumNF+cSerie))
		#IFDEF TOP
		EndIf
		#ENDIF
	While (!Eof().And. (cAliasSF3)->F3_FILIAL == xFilial("SF3") .And.;
			(cAliasSF3)->F3_NFISCAL == cNumNF .And.;
			(cAliasSF3)->F3_SERIE == cSerie .And.;
			IIf(cTpOper=="S".Or.cFormul=="S",.T.,(cAliasSF3)->F3_CLIEFOR == cCliFor .And.;
			(cAliasSF3)->F3_LOJA == cLoja) )
		If 	((Substr((cAliasSF3)->F3_CFO,1,1) < "5" .And. (cAliasSF3)->F3_FORMUL == "S") .Or.;
				Substr((cAliasSF3)->F3_CFO,1,1) > "4").And.!Empty((cAliasSF3)->F3_DTCANC)
			If lQuery
				aadd(aRecSF3,(cAliasSF3)->SF3RECNO)
			Else
				aadd(aRecSF3,RecNo())
			EndIf
		EndIf
		dbSelectArea(cAliasSF3)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSF3)
		dbCloseArea()
		dbSelectArea("SF3")
	EndIf	
	//����������������������������������������������������������Ŀ
	//� Grava arquivo de Livros Fiscais (SF3)                    �
	//������������������������������������������������������������
	aLivro	    := MaFisRet(,"NF_LIVRO")
	aFixos		:= MatxAfixos()
	lObserv		:= .F.
	If cPaisLoc=="BRA"
		AEval(aLivro,{ |x| (nVlrTotal+=IIf(x[3]+x[4]+x[5]+x[6]+x[7]+x[9]+x[10]+x[11]>0,x[3]+x[4]+x[5]+x[6]+x[7]+x[9]+x[10]+x[11],0)),((lObserv  := IIf(!Empty(x[24]),.T.,lObserv)))})
	Else
		If Len(aLivro) > 0
			aLivro:=Adel(aLivro,1)
			aLivro:=aSize(aLivro,Len(aLivro)-1)
			nVlrTotal:=Len(aLivro)
		Endif
	Endif
	If nVlrTotal > 0.00 .Or. lObserv
		//���������������������������������������������������������������Ŀ
		//� Coloca os lancamentos fiscais em ordem de CFO e CFO Extendido �
		//�����������������������������������������������������������������
		If cPaisLoc=="BRA"
			Asort(aLivro,,,{|x,y| (x[1]+x[31])<(y[1]+y[31])})
		Endif
		For nX:=1 To Len(aLivro)
			If If(cPaisLoc=="BRA",!Empty(aLivro[nx][1]),.T.)
				//����������������������������������������������Ŀ
				//� Recupera os registros Cancelados.            �
				//������������������������������������������������
				If nX <= Len(aRecSF3)                                       
					SF3->(MsGoto(aRecSF3[nX]))
					RecLock("SF3",.F.)
				Else
					RecLock("SF3",.T.)
				EndIf
				For nY := 1 to Len(aFixos)
					If SF3->(FieldPos(aFixos[nY][1])) > 0
                        If cPaisLoc <>  "BRA" .AND. ValType(aLivro[nX][nY]) == "N" .AND. Subs(aFixos[nY][1],1,6) $ "F3_VAL|F3_BAS|F3_RET|F3_DES"   
							FieldPut(FieldPos(aFixos[nY][1]),Round(aLivro[nX][nY],MsDecimais(1)))
						Else
							FieldPut(FieldPos(aFixos[nY][1]),aLivro[nX][nY])
						EndIF		
					Endif	
				Next nY
				SF3->F3_FILIAL	:= xFilial("SF3")
				SF3->F3_ENTRADA	:= IIF(empty( dEntrada),dDatabase,dEntrada)
				SF3->F3_NFISCAL	:= cNumNF
				SF3->F3_SERIE  	:= cSerie
				SF3->F3_CLIEFOR	:= cCliFor
				SF3->F3_LOJA	:= cLoja
				SF3->F3_PDV     := cPDV
				If !Empty(MaFisRet(,"NF_PNF_UF")) .And. ("CTR"$AllTrim(aNFCab[NF_ESPECIE]).Or."NFST"$AllTrim(aNFCab[NF_ESPECIE]))
					SF3->F3_ESTADO	:= MaFisRet(,"NF_PNF_UF")
				Else
					SF3->F3_ESTADO	:= IIF(cTpOper=="E",MaFisRet(,"NF_UFORIGEM"),MaFisRet(,"NF_UFDEST"))					
				EndIf
				SF3->F3_EMISSAO	:= dDEmissao
				SF3->F3_FORMUL	:= IIF(cTpOper=="E".Or.cPaisLoc<>"BRA",cFormul," ")
				SF3->F3_ESPECIE	:= cEspecie
				SF3->F3_DTCANC	:= CTOD("  /  /  ")
				If Type("l920Auto") == "L" .And. !l920Auto
					SF3->F3_DOCOR := If(lLote,c920NfFim,SF3->F3_DOCOR)
					SF3->F3_TIPO  := If(lLote,"L",SF3->F3_TIPO)
				EndIf
				//��������������������������������������������������Ŀ
				//� Ponto de entrada para atualizar o livro fiscal   �
				//����������������������������������������������������
				If ExistBlock("MTA920L")
					ExecBlock("MTA920L",.f.,.f.)
				EndIf
				//�����������������������������������������������������������Ŀ
				//� Livro de ICMS - Ajuste SINEF 03/04 - DOU 08.04.04         �
				//�������������������������������������������������������������
				If cPaisLoc=="BRA"
					If !Empty(aLivro[nX][35]) .And. (aLivro[nX][LF_ISS_ISENICM]<>0 .Or. aLivro[nX][LF_ISS_OUTRICM]<>0)
						aSF3 := {}
					    For nY := 1 To SF3->(FCount())
					    	aadd(aSF3,SF3->(FieldGet(nY)))
					    Next nY
						RecLock("SF3",.T.)
						For nY := 1 To Len(aSF3)
							If !"_MSIDENT"$SF3->(FieldName(nY))
								FieldPut(nY,aSF3[nY])
							EndIf
						Next nY
						SF3->F3_TIPO    := "N"
						SF3->F3_ALIQICM := aLivro[nX][LF_ISS_ALIQICMS]
						SF3->F3_BASEICM := 0
						SF3->F3_VALICM  := 0
						SF3->F3_ISENICM := aLivro[nX][LF_ISS_ISENICM]
						SF3->F3_OUTRICM := aLivro[nX][LF_ISS_OUTRICM]
						SF3->F3_BASEIPI := 0
						SF3->F3_VALIPI  := 0
						SF3->F3_ISENIPI := aLivro[nX][LF_ISS_ISENIPI]
						SF3->F3_OUTRIPI := aLivro[nX][LF_ISS_OUTRIPI]
						SF3->F3_CODISS  := ""
						SF3->F3_OBSERV  := "NOTA FISCAL DE SERVICO"
						//��������������������������������������������������Ŀ
						//� Ponto de entrada para atualizar o livro fiscal   �
						//����������������������������������������������������
						If ExistBlock("MTA920L")
							ExecBlock("MTA920L",.f.,.f.)
						EndIf					
					EndIf
				EndIf
			Endif
		Next nX
	Endif
	//����������������������������������������������Ŀ
	//� Deleta os registros fiscais cancelados.      �
	//������������������������������������������������
	If Len(aRecSF3) > Len(aLivro)
		For nX := (Len(aLivro)+1) To Len(aRecSF3)
			MsGoto(aRecSF3[nX])
			RecLock("SF3",.F.,.T.)
			dbDelete()
		Next nX
	EndIf
OtherWise
	//���������������������������������������������������������Ŀ
	//� Carega o Array contendo os Registros Fiscais (SF3)      �
	//�����������������������������������������������������������
	dbSelectArea("SF3")
	dbSetOrder(If(cTpOper == "S".Or.cFormul=="S",5,4))
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			cAliasSF3 := "MaFisAtuSF3"
			lQuery    := .T.

			cQuery := "SELECT F3_FILIAL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,"
			cQuery += "F3_LOJA,F3_CFO,F3_FORMUL,R_E_C_N_O_ SF3RECNO "
			cQuery += "FROM "+RetSqlName("SF3")+" SF3 "
			cQuery += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
			cQuery += "SF3.F3_SERIE='"+cSerie+"' AND "
			cQuery += "SF3.F3_NFISCAL='"+cNumNF+"' AND "
			If !(cTpOper=="S".Or.cFormul=="S")
				cQuery += "SF3.F3_CLIEFOR='"+cCliFor+"' AND "
				cQuery += "SF3.F3_LOJA='"+cLoja+"' AND "
			EndIf
			cQuery += "SF3.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SF3->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)	
		Else
	#ENDIF
		dbSeek(xFilial("SF3")+IIf(cTpOper=="S".Or.cFormul=="S",cSerie+cNumNF,cCliFor+cLoja+cNumNF+cSerie))
		#IFDEF TOP
		EndIf
		#ENDIF
	While (!Eof().And. (cAliasSF3)->F3_FILIAL == xFilial("SF3") .And.;
			(cAliasSF3)->F3_NFISCAL == cNumNF .And.;
			(cAliasSF3)->F3_SERIE == cSerie .And.;
			IIf(cTpOper=="S".Or.cFormul=="S",.T.,(cAliasSF3)->F3_CLIEFOR == cCliFor .And.;
			(cAliasSF3)->F3_LOJA == cLoja) )
		If ((cTpOper == "E" .And. Substr((cAliasSF3)->F3_CFO,1,1) < "5" .And. (cAliasSF3)->F3_FORMUL == cFormul) .Or.;
				(cTpOper == "S" .And. Substr((cAliasSF3)->F3_CFO,1,1) > "4"))
			If lQuery
				aadd(aRecSF3,(cAliasSF3)->SF3RECNO)
			Else
				aadd(aRecSF3,RecNo())
			EndIf
		EndIf
		dbSelectArea(cAliasSF3)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSF3)
		dbCloseArea()
		dbSelectArea("SF3")
	EndIf
	//����������������������������������������������������������Ŀ
	//� Cancelamento dos Livros Fiscais.                         �
	//������������������������������������������������������������
	dbSelectArea('SF3')
	For nX := 1 to Len(aRecSF3)
		If cFormul == "S" .Or. cTpOper == "S"
			MsGoto(aRecSF3[nX])
			RecLock("SF3",.F.)
			If IIf(cPaisLoc!="BRA",lAnulaSF3,.T.)			
				SF3->F3_DTCANC := dDataBase
				SF3->F3_OBSERV := STR0008 //"NF CANCELADA"
			Else
				dbDelete()
			EndIf
			MsUnlock()
			If cTpOper == "S"
				//���������������������������������������������������������Ŀ
				//� Pto de Entrada utilizado na Argentina                   �
				//�����������������������������������������������������������
				If ExistBlock("M520SF3") // LUCAS 18/08/99 ARGENTINA
					ExecBlock("M520SF3",.F.,.F.)
				Endif
			EndIf
		Else
			MsGoto(aRecSF3[nX])
			RecLock("SF3",.F.,.T.)
			dbDelete()
		EndIf
	Next
EndCase
RestArea(aAreaSF1)
RestArea(aAreaSF2)
RestArea(aArea)
Return(.T.)
/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisSXRef� Autor � Eduardo Riera         � Data �08.08.2001 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de avalicao das referencias existentes para um deter- ���
���          �minada tabela no dicionario de dados                         ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Tabela do Dicionario de dados                         ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com as referencias da funcao fiscal             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo verificar e retornar as referen���
���          �cias da funcao fiscal com base no dicionario de dados, para  ���
���          �recuperar os valores da funcao fiscal                        ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Function MaFisSXRef(cAlias)

Local aArea    := GetArea()
Local aRefer   := {}
Local nScan    := 0
Local nX       := 0

DEFAULT aRefSX3 := {}

//���������������������������������������������������������Ŀ
//�Verifica se o alias solicitado esta no cache de memoria  �
//�����������������������������������������������������������
nScan := aScan(aRefSx3,{|x| x[1] == cAlias})
If nScan == 0
	//���������������������������������������������������������Ŀ
	//�Atualiza o Cache                                         �
	//�����������������������������������������������������������
	MaFisRelImp("",{cAlias})
EndIf
//���������������������������������������������������������Ŀ
//�Obtem os dados do cache                                  �
//�����������������������������������������������������������
For nX := 1 To Len(aRefSX3)
	If aRefSX3[nX][1] == cAlias
		aadd(aRefer,{aRefSX3[nX][2],aRefSX3[nX][3]})
	EndIf
Next nX
RestArea(aArea)
Return(aRefer)

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisGetRf� Autor � Eduardo Riera         � Data �08.08.2001 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de avalicao das referencias existentes em uma         ���
���          �expressao string.                                            ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Expressao contendo as referencias.                    ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com a seguinte estrutura                        ���
���          �       [1] Codigo da Referencia                              ���
���          �       [2] Nome do programa vinculado a referencia           ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo verificar e retornar as referen���
���          �cias da funcao fiscal com base numa expressao string.        ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Function MaFisGetRF(cValid)

Local nPRefer := 0
Local cRefer  := ""
Local cProg   := ""

cValid	:= Upper(StrTran(cValid," ",""))

Do Case
Case ( "MAFISREF"$cValid )
	nPRefer := AT('MAFISREF("',cValid) + 10
	cValid  := SubStr(cValid,nPRefer)
	cRefer  := SubStr(cValid,1,AT(',',cValid)-2)
	cValid  := SubStr(cValid,AT(',',cValid)+1)
	cProg   := SubStr(cValid,2,AT(',',cValid)-3)
Case ( "MAFISGET"$cValid )
	nPRefer := AT('MAFISGET("',cValid) + 10
	cValid  := SubStr(cValid,nPRefer)
	cRefer  := SubStr(cValid,1,AT(')',cValid)-2)
EndCase
Return({cRefer,cProg})

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaFisEnd � Autor � Edson Maricate        � Data �10.01.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Finaliza o uso das funcoes Fiscais.                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1: Indica se deve reinicializar o codeblock da funcao  ���
���          �        MaFisRodape ( bFisRefresh )                         ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisEnd(lRodape)

DEFAULT lRodape := .T.
aNfCab	:= Nil
aNfItem	:= Nil
aItemDec:= Nil
aSaveDec:= Nil
aAuxOri	:= Nil
aTes    := Array(MAX_TS)
bLivroRefresh := Nil
If lRodape
	bFisRefresh := Nil
EndIf
Return .T.

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaRateio  � Autor �Edson Maricate         � Data �20.12.2000 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de rateio das despesas acessorias.                    ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Nome da Referencia da despesas acessoria              ���
���          �ExpN2: Valor atual da despesa acessoria                      ���
���          �ExpN3: Novo valor da despesa acessoria                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar o rateio das despesas  ���
���          �acessorias sobre todos os itens da nota fiscal, exceto os    ���
���          �que possuirem a referencia ISS.                              ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaRateio(cReferencia,nAnterior,nAtual)

Local nX		 := 0
Local nDiferenca := 0
Local nY		 := 0
Local nSoma 	 := 0
Local aPosCpo	 := MaFisScan(cReferencia)
Local cTpRatDesp 	:= Substr(MV_RATDESP,AT("DESP=",MV_RATDESP)+5,1)
Local cTpRatFrete	:= Substr(MV_RATDESP,AT("FR=",MV_RATDESP)+3,1)
Local cTpRatSeg	:= Substr(MV_RATDESP,AT("SEG=",MV_RATDESP)+4,1)
Local lRatDesc		:=	(cReferencia=="IT_DESCONTO".And.cPaisLoc<>"BRA".And.aNfCab[NF_OPERNF]=="S".And.SuperGetMV('MV_DESCSAI')=='1')

If nAnterior > 0
	nDiferenca := (nAtual-nAnterior) / nAnterior
	For nX	:= 1 to Len(aNfItem)
		If !aNfItem[nX][IT_DELETED] .And. !( aNfItem[nX][IT_RATEIOISS]=="S" .And. ("FRETE"$cReferencia .Or. "SEGURO"$cReferencia .Or. "DESPESA"$cReferencia) )
			nY := nX
			If ValType(aPosCpo) == "A"
				aNfItem[nX][aPosCpo[1]][aPosCpo[2]]	:= (1+nDiferenca)*aNfItem[nX][aPosCpo[1]][aPosCpo[2]]
				nSoma += aNfItem[nX][aPosCpo[1]][aPosCpo[2]]
			Else
				If lRatDesc			
					aNFitem[nX][IT_VALMERC] +=	 aNfItem[nX][Val(aPosCpo)]
					aNfItem[nX][Val(aPosCpo)] := (1+nDiferenca)*aNfItem[nX][Val(aPosCpo)]
					nSoma += aNfItem[nX][Val(aPosCpo)]
				Else
					aNfItem[nX][Val(aPosCpo)] := (1+nDiferenca)*aNfItem[nX][Val(aPosCpo)]
					nSoma += aNfItem[nX][Val(aPosCpo)]
				Endif
			EndIf
		EndIf
	Next
	//��������������������������������������������������������Ŀ
	//� Efetua a correcao da dizima no primeiro item.          �
	//����������������������������������������������������������
	If nY <> 0
		If ValType(aPosCpo) == "A"
			aNfItem[nY][aPosCpo[1]][aPosCpo[2]] += nAtual-nSoma
		Else
			aNfItem[nY][Val(aPosCpo)] += nAtual-nSoma
		EndIf
	EndIf
Else
	For nX	:= 1 to Len(aNfItem)
		If !aNfItem[nX][IT_DELETED] .And. !( aNfItem[nX][IT_RATEIOISS]=="S" .And. ("FRETE"$cReferencia .Or. "SEGURO"$cReferencia .Or. "DESPESA"$cReferencia) )
			nY := nX
			//��������������������������������������������������������Ŀ
			//� Efetua o rateio do valor informado nos itens da NF     �
			//� O rateio das despesas ( frete/seguro/despesas ) podera �
			//� ser efetuado por valor ou peso, de acordo com a config.�
			//� do parametro MV_RATDESP.                               �
			//����������������������������������������������������������
			If aNfCab[NF_PESO]<>0.And.((cReferencia=="IT_FRETE".And.cTpRatFrete=="2").Or.;
					(cReferencia=="IT_DESPESA".And.cTpRatDesp=="2").Or.;
					(cReferencia=="IT_SEGURO".And.cTpRatSeg=="2"))
				//���������������������Ŀ
				//� Rateio por Peso.    �
				//�����������������������
				If ValType(aPosCpo) == "A"
					aNfItem[nX][aPosCpo[1]][aPosCpo[2]]	+= (nAtual-nAnterior)*(aNfItem[nX][IT_PESO]/aNfCab[NF_PESO])
					nSoma += aNfItem[nX][aPosCpo[1]][aPosCpo[2]]
				Else
					aNfItem[nX][Val(aPosCpo)] += (nAtual-nAnterior)*(aNfItem[nX][IT_PESO]/aNfCab[NF_PESO])
					nSoma += aNfItem[nX][Val(aPosCpo)]
				EndIf
			Else
				//���������������������Ŀ
				//� Rateio por Valor.   �
				//�����������������������
				If ValType(aPosCpo) == "A"
					aNfItem[nX][aPosCpo[1]][aPosCpo[2]] += MyNoRound((nAtual-nAnterior)*(aNfItem[nX][IT_VALMERC]/(aNfCab[NF_VALMERC]+aNfCab[NF_VNAGREG])),MsDecimais(aNfCab[NF_MOEDA]))
					nSoma += aNfItem[nX][aPosCpo[1]][aPosCpo[2]]
				Else
					If lRatDesc
						aNFitem[nX][IT_VALMERC] +=	MyNoRound(aNfItem[nX][Val(aPosCpo)],MsDecimais(aNfCab[NF_MOEDA]))
						aNfItem[nX][Val(aPosCpo)] 	+= MyNoRound((nAtual-nAnterior)*(aNfItem[nX][IT_VALMERC]/(aNfCab[NF_VALMERC]+aNfCab[NF_VNAGREG])),MsDecimais(aNfCab[NF_MOEDA]))
						nSoma += aNfItem[nX][Val(aPosCpo)]
					Else
						aNfItem[nX][Val(aPosCpo)] += MyNoRound((nAtual-nAnterior)*(aNfItem[nX][IT_VALMERC]/(aNfCab[NF_VALMERC]+aNfCab[NF_VNAGREG])),MsDecimais(aNfCab[NF_MOEDA]))
						nSoma += aNfItem[nX][Val(aPosCpo)]
					Endif
				EndIf
			EndIf
		EndIf
	Next
	//��������������������������������������������������������Ŀ
	//� Efetua a correcao da dizima no primeiro item.          �
	//����������������������������������������������������������
	If nY <> 0
		If ValType(aPosCpo) == "A"
			aNfItem[nY][aPosCpo[1]][aPosCpo[2]] += nAtual-nSoma
		Else
			aNfItem[nY][Val(aPosCpo)]	+= nAtual-nSoma
		EndIf
	EndIf
EndIf
Return

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisBrwLF� Autor �Edson Maricate         � Data �13.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Browse demonstrativo dos livros fiscais                      ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto ListBox a ser montado                          ���
���          �ExpA2: Array com as coordenadas do Objeto                    ���
���          �ExpL3: Flag de edicao do livro                               ���
���          �       .F. - Editavel                                        ���
���          �       .T. - Nao Editavel                                    ���
���          �ExpA4: Array contendo os registros do Livro Fiscal           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo criar o objeto de exibicao dos ���
���          �livros fiscais                                               ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Function MaFisBrwLivro(oWnd,aPosWnd,lVisual,aRecSF3)

Local aArea		:= GetArea()
Local aAreaSX3	:= SX3->(GetArea())
Local aItensLF	:= {}
Local aHeadLF	:= {}
Local aTamHead	:= {}
Local nX        := 0
Local nY        := 0
Local oLivro
//�������������������������������������������������������������Ŀ
//� Inicializa os campos fixos do Livro Fiscal                  �
//���������������������������������������������������������������
If aBrwLF == Nil
	aBrwLF	:= MaFisHdLF()
EndIf
//�������������������������������������������������������������Ŀ
//� Monta o cabecalho com os titulos do SF3.                    �
//���������������������������������������������������������������
For nX	:= 1 To Len(aBrwLF)
	aadd(aHeadLF,aBrwLF[nX][4])
	If aBrwLF[nX][5] > Len(aBrwLF[nX][4])
		aadd(aTamHead,aBrwLF[nX][5]*3)
	Else
		aadd(aTamHead,Len(aBrwLF[nX][4])*3)
	EndIf
Next nX
//�������������������������������������������������������������Ŀ
//� Monta os itens de visualizacao da ListBox.                  �
//���������������������������������������������������������������
Do Case
Case !Empty(aRecSF3)
	For nX	:= 1 To Len(aRecSF3)
		dbSelectArea("SF3")
		MsGoto(aRecSF3[nX])
		aadd(aItensLF,Array(Len(aBrwLF)))
		For nY := 1 to Len(aBrwLF)
			aItensLF[nX][nY] := &(aBrwLF[nY][1])
		Next nY
	Next nX
Case !Empty(aNFCab)
	aItensLF := aClone(aNFCab[NF_LIVRO])
	If cPaisLoc<>"BRA"
		If !Empty(aItensLF)
			aItensLF:=Adel(aItensLF,1)
			aItensLF:=aSize(aItensLF,Len(aItensLF)-1)
		Endif
	EndIf
EndCase
If Empty(aItensLF)
	aadd(aItensLF,Array(Len(aBrwLF)))
	For nX	:= 1 To Len(aBrwLF)
		aItensLF[1][nX] := aBrwLF[nX][2]
	Next nX
EndIf
//���������������������������������������������������������������������Ŀ
//� Cria o CodeBlock  bLivroRefresh para executar o Refresh do Objeto.  �
//�����������������������������������������������������������������������
bLivroRefresh   := {|| MaFisLFNew(oLivro)}
//���������������������������������������������������������������������Ŀ
//� Inicializa o objeto listbox com os dados                            �
//�����������������������������������������������������������������������
oLivro := TWBrowse():New( aPosWnd[1],aPosWnd[2],aPosWnd[3],aPosWnd[4],,aHeadLF,aTamHead,oWnd,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLivro:SetArray(aItensLF)
If Len(aItensLF) > 0
	oLivro:bLine 		:= {||MaFisLFLine(oLivro,aItensLF)}
EndIf
oLivro:lAutoEdit	:= !lVisual

RestArea(aAreaSX3)
RestArea(aArea)

Return ( oLivro )

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisLFLin� Autor �Edson Maricate         � Data �13.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Browse demonstrativo dos livros fiscais                      ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto ListBox do Livro Fiscal                        ���
���          �ExpA2: Array com os itens do listbox                         ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com a linha do demonstrativo fiscal             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo preparar a montagem da linha a ���
���          �ser exibida no browse do demonstrativo fiscal                ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisLFLine(oLivro,aItensLF)

Local aLinha := aItensLF[oLivro:nAt]
Local aFixos := MatXAFixos()
Local nX     := 0
Local nY     := 0
Local nMax   := Len(aFixos)

For nX := 1 To nMax
	nY := aScan(aBrwLF,{|x| x[1]==aFixos[nX][1]})
	If nY <> 0 .And. ValType(aLinha[nY]) == "N"	
		If cPaisLoc == "BRA"
			aLinha[nY]:= TransForm(aLinha[nY],aBrwLF[nY][3])
		Else
			If SUBS(aBrwLF[nY][1],1,6) $ "F3_VAL|F3_BAS|F3_RET|F3_DES"
    	    	aLinha[nY] := Round(aLinha[nY],MsDecimais(1))
 	       	EndIf
			aLinha[nY]:= TransForm(aLinha[nY],aBrwLF[nY][3])
		EndIf			
	EndIf
Next nX

Return( aLinha )

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisLFNew� Autor �Edson Maricate         � Data �13.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Browse demonstrativo dos livros fiscais                      ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto ListBox dos livros fiscais                     ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo atualizar o array com o demons ���
���          �trativo fiscal.                                              ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisLFNew(oLivro)

Local aTemp      := {}
Local aFixos     := MatXAFixos()
Local aLinha     := {}
Local nMaxBrw    := Len(aBrwLF)
Local nX         := 0
Local nY         := 0
Local nZ         := 0
Local nMax1      := 0
Local nMax2      := 0

If Empty(aNFCab)
	aadd(aLinha,Array(nMaxBrw))
	For nX  := 1 To nMaxBrw
		aLinha[1][nX] := aBrwLF[nX][2]
	Next nX
Else
	aTemp	:= aClone(aNFCab[NF_LIVRO])
	If cPaisLoc<>"BRA"
		If !Empty(aTemp)
			aTemp:=Adel(aTemp,1)
			aTemp:=aSize(aTemp,Len(aTemp)-1)
		Endif
	Endif
	nMax1 := Len(aTemp)
	For nX := 1 To nMax1
		nMax2 := Min(Len(aTemp[nX]),Len(aFixos))
		aadd(aLinha,Array(nMaxBrw))
		For nY := 1 To nMax2
			nZ := aScan(aBrwLF,{|x| x[1]==aFixos[nY][1]})
			If nZ <> 0
				aLinha[nX][nZ]:= aTemp[nX][nY]
			EndIf
		Next nY
	Next nX
EndIf
                          
If ValType(oLivro)<>"U" 
	oLivro:SetArray(aLinha)
	oLivro:bLine := {|| MaFisLFLine(oLivro,aLinha) }
	oLivro:Refresh()
EndIf	
	
Return(.T.)

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisHdLF � Autor �Edson Maricate         � Data �13.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Demonstrativo dos Livros Fiscais                             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com a seguinte estrutura:                       ���
���          �       [1] Nome do Campo da tabela de livros fiscais         ���
���          �       [2] Inicializador padrao do campo                     ���
���          �       [3] Picture do campo                                  ���
���          �       [4] Titulo do campo                                   ���
���          �       [5] Tamanho do campo                                  ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo atualizar o array com a estrutu���
���          �ra do SF3 necessaria para o calculo dos livros fiscais       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisHdLF()

Local aArea     := GetArea()
Local aAreaSX3  := SX3->(GetArea())
Local aFixos	:= MatXAFixos()
Local aRetorno  := {}
Local nX        := 0

DbSelectArea("SX3")
DbSetOrder(2)
For nX := 1 To Len(aFixos)
	If SX3->(DbSeek(aFixos[nX][1]))
		//		If  X3USO(SX3->X3_USADO)
		aadd(aRetorno,{aFixos[nX][1],CriaVar(aFixos[nX][1],.F.),PesqPict("SF3",aFixos[nX][1]),X3Titulo(),SX3->X3_TAMANHO})
		//		EndIf
	EndIf
Next nX

RestArea(aAreaSX3)
RestArea(aArea)
Return (aRetorno)

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisRatRe� Autor �Edson Maricate         � Data �20.12.1999 ���
��������������������������������������������������������������������������Ĵ��
���          �Rateio do resumo de impostos                                 ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Nome da Referencia do imposto                         ���
���          �ExpN2: Valor atual da referencia                             ���
���          �ExpN3: Aliquota da referencia alterada                       ���
���          �ExpN4: Nome da Referencia Aliquota para este imposto         ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo distribuir o valor da referenci���
���          �a alterada, entre os itens de mesma referencia.              ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisRatRes(cReferencia,nAtual,nAliquota,cCpoAliq,cCpoBase,nItemNao)
Local nX        := 0
Local nTotAcum	:= 0
Local nAuxItem	:= 0
Local lAuxItem	:= .T.
Local aPosCpo 	:= MaFisScan(cReferencia)
Local nCpoAliq	:= MaFisScan(cCpoAliq)
Local nCpoBase	:= MaFisScan(cCpoBase,.F.)
Local nAliqItem	:= 0
Local nBaseTot	:=	0
Local nVlrTot   := 0
Local nFator    := 0       
Local nPosItRef := 0
DEFAULT nItemNao	:=	0
For nX:=1 To Len(aNFItem)
	If !Empty(nCpoBase) // so se existir a base, no caso de Dif. de Aliquota nao existe
		//Soh somar as bases da mesma aliquota, porque o rateio eh soh para os itens da mesma aliquota
		If (MaFisRet(nX,cCpoAliq)==nAliquota .And.(IIf(ValType(aPosCpo) == "A",aNfItem[nX][aPosCpo[1]][aPosCpo[2]],aNfItem[nX][Val(aPosCpo)])>0))
			nBaseTot+=IIf(!aNfItem[nX][IT_DELETED],MaFisRet(nX,cCpoBase),0)
		EndIf
	Else
		If nBaseTot <= 0
			nVlrTot+=IIf(!aNfItem[nX][IT_DELETED],MaFisRet(nX,cReferencia),0)
		EndIf
	EndIf
Next

For nX	:= 1 to Len(aNfItem)
	If !aNfItem[nX][IT_DELETED]
		If nAtual <> 0 .And. nAtual == nTotAcum
			Exit
		Endif	
		If !Empty(nCpoBase) // so se existir a base, no caso de Dif. de Aliquota nao existe
			//O rateio de impostos eh feito com base na base calculada para cada item
			nFator	:=	MaFisRet(nX,cCpoBase)/nBaseTot
        Else
			If nBaseTot <= 0
				nFator	:=	MaFisRet(nX,cReferencia)/nVlrTot
         	EndIf 
		EndIf
		If ValType(nCpoAliq) == "A"
			nAliqItem := aNfItem[nX][nCpoAliq[1]][nCpoAliq[2]]
		Else
			nAliqItem := aNfItem[nX][Val(nCpoAliq)]
		EndIf
		If nAliqItem == nAliquota
			If nX	<>	nItemNao			
				MaFisSomaIt(nX,.F.)
			Endif
			If lAuxItem
				nAuxItem	:= nX
				lAuxItem	:= .F.
			EndIf
			
			nPosItRef := Ascan(aItemRef,{|x| x[1] == cReferencia})

			If nPosItRef > 0			
				If aItemRef[nPosItRef][4] .And. aItemRef[nPosItRef][5]
					If ValType(aPosCpo) == "A"
						nTotAcum += aNfItem[nX][aPosCpo[1]][aPosCpo[2]]	:=  MyNoRound(nFator*nAtual,2)
					Else
						nTotAcum += aNfItem[nX][Val(aPosCpo)] := MyNoRound(nFator*nAtual,2)
					EndIf
				Else
					If ValType(aPosCpo) == "A"
						nTotAcum += aNfItem[nX][aPosCpo[1]][aPosCpo[2]]	:=  nFator*nAtual
					Else
						nTotAcum += aNfItem[nX][Val(aPosCpo)] := nFator*nAtual
					EndIf
				EndIf
			Else
				If ValType(aPosCpo) == "A"
					nTotAcum += aNfItem[nX][aPosCpo[1]][aPosCpo[2]]	:=  nFator*nAtual
				Else
					nTotAcum += aNfItem[nX][Val(aPosCpo)] := nFator*nAtual
				EndIf
			Endif	
		EndIf
	EndIf
Next nX
If !lAuxItem .And. nAtual <> nTotAcum
	If ValType(aPosCpo) == "A"
		aNfItem[nAuxItem][aPosCpo[1]][aPosCpo[2]] += (nAtual-nTotAcum)
	Else
		aNfItem[nAuxItem][Val(aPosCpo)] += (nAtual-nTotAcum)
	EndIf
EndIf

Return
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisImpIV� Autor �                        � Data �06.09.2001���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo dos Impostos Variaveis                     ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Imposto ( 1 a 6 )                           ���
���          �ExpN2: Item a ser calculado                                  ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function MaFisImpIV(nItem)
Local nImpAte
Local nX
Local nY
Local nG
Local nAliq,nImposto,nBase,cNumImp,nPosImp,nImpAnt
Local aImpsTotAnt	:=	{}
Local aImpsTot	:=	{}
Private aImposEIC:={}
//�����������������������������������������������������������������������Ŀ
//�Calcula os impostos por total e por item                               �
//�Os imp�stos por item devem ser calculados antes dos impostos           �
//�por total na seguinte sequencia :                                      �
//�BASE IMPOSTO ITEM                                                      �
//�ALIQUOTA IMPOSTO ITEM                                                  �
//�VALOR IMPOSTO ITEM                                                     �
//�                                                                       �
//�E os impostos por total devem ser calculados na sequencia :            �
//�BASE IMPOSTO TOTAL (Todos os itens ate o atual)                        �
//�ALIQUOTA IMPOSTO TOTAL (Todos os itens ate o atual)                    �
//�VALOR IMPOSTO TOTAL (Todos os itens ate o atual)                       �
//�                                                                       �
//�Isto e porque os impostos por total geralmente sao definidos em base a �
//�valor minimo de base para poder calcular                               �
//�������������������������������������������������������������������������

nImpAte:=Len(aTes[TS_SFC])
For nX:=1 to NMAXIV
	//���������������������������������������������������������������������Ŀ
	//�Verificar se com o tes anterior foi calculado algum imposto por total�
	//�����������������������������������������������������������������������
	If aNfItem[nItem][IT_DESCIV][nX][3] == "T"
		Aadd(aImpsTotAnt,{nX,aNfItem[nItem][IT_DESCIV][nX],aNFItem[nItem][IT_ALIQIMP][nX]})   	
	Endif
	aNFItem[nItem][IT_BASEIMP][nX]	:=	0
	aNfItem[nItem][IT_DESCIV][nX]		:=	{"","",""}
	aNFItem[nItem][IT_VALIMP][nX]		:=	0
	aNFItem[nItem][IT_ALIQIMP][nX]	:=	0
Next
For nX := 1 To nImpAte
	//���������������������������������������������������������������������Ŀ
	//�Verificar que impostos por total deverao ser calculados com este TES �
	//�����������������������������������������������������������������������
	If	aTes[TS_SFC][nX][SFC_CALCULO] == "T"
		Aadd(aImpsTot,nX)   	
		nPosAtu	:=	Ascan(aImpsTotAnt,{|x| x[1]==NumCpoImpVar(RIGHT(Alltrim(aTes[TS_SFC][nX][SFB_CPOVREI]),1)) })
		//���������������������������������������������������������������������Ŀ
		//�Eliminar do array com o impostos por total calculados com o TES ante-�
		//�rior, se com o novo TES tambem deve ser calculado o imposto.         �
		//�����������������������������������������������������������������������
		If nPosAtu >0
			aDel(aImpsTotAnt,nPosAtu)
			Asize(aImpsTotAnt,Len(aImpsTotAnt)-1)
		Endif	
	Endif
Next nX
If (Type("lFacImport")=="L" .And. lFacImport)
	SD1->(MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aNfItem[nItem][IT_PRODUTO]+StrZero(nItem,TamSx3("D1_ITEM")[1])))
	A100IniImp(SD1->D1_SERIE,SD1->D1_DOC,SD1->D1_TEC,,,,,,,nItem)
	If Len(aImposEic)>0
		For nX:=1 To Len(aImposEIC)
			nG:=NumCpoImpVar(Right(aImposEIC[nX,6],1))
			If nG>0
				SFB->(MsSeek(xFilial("SFB")+aImposEIC[nX,4]))
				aNFItem[nItem][IT_BASEIMP][nG]	:=	aImposEIC[nX,7]
				aNfItem[nItem][IT_DESCIV][nG]	:=	{aImposEIC[nX,4],SFB->FB_DESCR,Posicione('SFC',1,xFilial("SFC")+aImposEIC[nX][2]+aImposEIC[nX][3]+aImposEIC[nX][4],"FC_CALCULO")}
				aNFItem[nItem][IT_VALIMP][nG]	:=	aImposEIC[nX,9]
				aNFItem[nItem][IT_ALIQIMP][nG]	:=	aImposEIC[nX,5]
			Endif
		Next
	Endif
Else
	If nImpAte>0
		For nX:=1 to nImpAte
			//Calcula os impostos por item
			MaFisBSIV(nX,nItem)		// Executa o calculo da Base dos IVs
			MaFisAliqIV(nX,nItem)	// Executa o calculo da Aliquota dos IVs
			If Ascan(aImpsTot,nX) == 0
				MaFisVLIV(nX,nItem)		// Executa o calculo do Valor dos IVs que nao sao por total
			Endif	
		Next
	EndIf
EndIf

//��������������������������������������������������������Ŀ
//�Verifica se a base de impostos por total que nao sao    �
//�mais calculados e menor que o minimo, se for, zera o    �
//�valor do imposto no total e rateia.                     �
//����������������������������������������������������������
For nX:=1 To Len(aImpsTotAnt)
	cNumImp	:=	NumCpoImpVar(aImpsTotAnt[nX][1],1)
	If MaFisRet(,'NF_BASEIV'+cNumImp) < MaFisRet(,'NF_MINIV'+cNumImp)
		nImposto	:= 0
		nBase		:=	0
	Else
		nImposto	:=	MaFisRet(,'NF_VALIV'	+cNumImp)
		nBase		:=	MaFisRet(,'NF_BASEIV'+cNumImp)
	Endif		
	nAliq		:=	aImpsTotAnt[nX][3]
	aDesc		:=	aClone(aImpsTotAnt[nX][2])
	If nBase >0
		//Garantir que o imposto exista no array de impostos
		If  (nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })) == 0
			MaFisResumo(0,nAliq,0,aDesc[1],aDesc[2],"IV"+cNumImp,,,.T.)
			nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })
		Endif
		MaFisAlt('IMP_BASEIV'+cNumImp,nBase		,nPosImp,.T.,nItem)
	Endif
	//Garantir que o imposto exista no array de impostos
	If  (nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })) == 0
		MaFisResumo(0,nAliq,0,aDesc[1],aDesc[2],"IV"+cNumImp,,,.T.)
		nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })
	Endif
	MaFisAlt('IMP_VALIV'+cNumImp,nImposto,nPosImp,,nItem)
	//��������������������������������������������������������Ŀ
	//� Restaura o TES utilizado no calculo de impostos quando �
	//� quando houve calculo de impostos por total, dado que   �
	//� foram recalculados os valores para todos os itens.     �
	//����������������������������������������������������������
	MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)
Next

//��������������������������������������������������������Ŀ
//�Calculo os impostos por total e rateia em todos os itens�
//����������������������������������������������������������
If !aNfItem[nItem][IT_DELETED]
	For nX:= 1 To Len(aImpsTot)
		cNumImp	:=	RIGHT(Alltrim(aTes[TS_SFC][aImpsTot[nX]][SFB_CPOVREI]),1)
		nImpAnt 	:=	MaFisRet(nItem,'IT_VALIV'	+cNumImp)
		MaFisVLIV(aImpsTot[nX],nItem)			// Executa o calculo do valor dos IVs dos impostos.
		nImposto	:=	MaFisRet(nItem,'IT_VALIV'	+cNumImp)
	
		If Round(nImposto,3) > 0 .Or. (nImpAnt > 0 .And. Round(nImposto,3) == 0)
			nAliq		:=	MaFisRet(nItem,'IT_ALIQIV'	+cNumImp)
			aDesc		:=	aNfItem[nItem][IT_DESCIV][Val(cNumImp)]
			nBase		:=	MaRetBasT(cNumImp,nItem,nAliq)		
			//Garantir que o imposto exista no array de impostos
			If  (nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })) == 0
				MaFisResumo(0,nAliq,0,aDesc[1],aDesc[2],"IV"+cNumImp,,,.T.)
				nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })
			Endif
			MaFisAlt('IMP_BASEIV'+cNumImp,nBase		,nPosImp,.T.,nItem)
			//Garantir que o imposto exista no array de impostos
			If  (nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })) == 0
				MaFisResumo(0,nAliq,0,aDesc[1],aDesc[2],"IV"+cNumImp,,,.T.)
				nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })
			Endif
			MaFisAlt('IMP_VALIV'	+cNumImp,nImposto	,nPosImp,,nItem)
			//��������������������������������������������������������Ŀ
			//� Restaura o TES utilizado no calculo de impostos quando �
			//� quando houve calculo de impostos por total, dado que   �
			//� foram recalculados os valores para todos os itens.     �
			//����������������������������������������������������������
			MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)
		Endif
	Next
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MaFisReprocess� Autor � Edson Maricate    � Data �20.05.2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua o reprocessamento e gera o livro da Nota Fiscal.     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MaFisReprocess()                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum.                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function MaFisReprocess(nOpc)
Local nItem

nOpc := IIF(nOpc==Nil,1,nOpc)

Do Case
Case nOpc == 1
	If MaFisFound('NF')
		For nItem := 1 to len(aNfItem)
			//�������������������������������������������������������������Ŀ
			//� Posiciona os registros necessarios                          �
			//���������������������������������������������������������������
			dbSelectArea(cAliasPROD)
			If aNfItem[nItem][IT_RECNOSB1] <> 0 .And. cAliasPROD=="SB1"
				MsGoto(aNfItem[nItem][IT_RECNOSB1])
			Else
				dbSetOrder(1)
				MsSeek(xFilial(cAliasPROD)+aNfItem[nItem][IT_PRODUTO])
			EndIf
			MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)
			MaFisBSIPI(nItem,.T.)	// Calcula a Base de IPI Original
			MaFisBSICM(nItem,.T.)	// Calcula a Base de ICMS Original
			MaFisLF(nItem)			// Atualiza os valores do Livro Fiscal
			MaFisLF2(nItem)			// Verifica se a TES possui RdMake para complemento/geracao dos Livros
		Next
		MaIt2Cab()
	EndIf
Case nOpc == 2
	If MaFisFound('NF')
		For nItem := 1 to len(aNfItem)
			MaFisRecal(,nItem)
		Next
		MaIt2Cab()
	EndIf
EndCase
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRetSFC� Autor � Leandro Coelho       � Data �14.01.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna as caracteristiscas definidas no SFC para cada um  ���
���          � dos impostos calculados para o item informado.             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com a seguinte estrutura                       ���
���          �   A1[n][01] : Sequencia                                    ���
���          �   A1[n][02] : Imposto                                      ���
���          �   A1[n][03] :                                              ���
���          �   A1[n][04] :                                              ���
���          �   A1[n][05] : Se credita ou nao no custo                   ���
���          �   A1[n][06] :                                              ���
���          �   A1[n][07] :                                              ���
���          �   A1[n][08] :                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRetSFC(nItem)
Local aRetorno

MaFisTes(aNfItem[nItem][IT_TES],aNfItem[nItem][IT_RECNOSF4],nItem)

aRetorno:=aClone(aTes[TS_SFC])

Return aRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MaRetIncIV    � Leandro C.G. �Microsiga � Data �  14/01/02  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna valores de impostos referentes a um item de NF que ���
���          � incidem no custo, Duplicata, ou Nota                       ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*Parametros
nItem		- Numero do item da Nota Fiscal
cOpc		- 1- Custo
2- Nota
3- Duplicata		

Obs.: Considera que o arquivo de itens da Nota Fiscal ja esta posicionado no registro correto e que
as variaveis de calculo de impostos do programa MatxFis ja estao inicializadas
*/

Function MaRetIncIV(nItem,cOpc)

Local aDescImp 	:=	{}	//Descricao/Codigo de todos os impostos que incidem no item
Local aValImp	:=	{}	//Array com os valores de todos os impostos que incidem no item
Local nImposVar	:=	0	//Valor dos impostos variaveis que incidem no custo
Local aSFC		:=	{} //Array com as propriedades dos impostos do item
Local aRet 		:= {} //Array com os impostos e valores que sao somados ou subtraidos no custo
/*						[1] - Codigo do imposto
[2] - Valor positivio (quando imposto e creditado) e negativo (+/-)
*/
Local nI		:=	0
//����������������������Ŀ
//�Consistindo parametros�   	
//������������������������
If Empty(nItem)
	Return( 0 )
EndIf

//������������������������������������������������������������
//�Busca array com todos os impostos que incidem no item item�
//������������������������������������������������������������
aSFC	 :=	MaFisRetSFC(nItem)
aDescImp :=	MaFisRet(nItem,"IT_DESCIV")		//Descricao/Codigo dos impostos
aValImp  :=	MaFisRet(nItem,"IT_VALIMP")		//Valor dos Impostos

//������������������������������������������
//�Buscando valores referentes aos impostos�
//������������������������������������������
For nI := 1 to Len(aSFC)
	nPosImp	:=	Ascan(aDescImp,{|x| x[1] == aSFC[nI][SFC_IMPOSTO]})
	If nPosImp > 0
		Do Case
		Case cOpc == '1'
			If aSFC[nI][SFC_CREDITA] <> '3'
				nImposVar	:=	aValImp[nPosImp] * If(aSFC[nI][SFC_CREDITA] == '1', 1 , -1)
				Aadd(aRet, {aSFC[nI][SFC_IMPOSTO], nImposVar})
			Endif
		Case cOpc == '2'	
			If aSFC[nI][SFC_INCNOTA] <> '3'
				nImposVar	+=	aValImp[nPosImp] * If(aSFC[nI][SFC_INCNOTA] == '1', 1 , -1)
			Endif
		Case cOpc == '3'
			If aSFC[nI][SFC_INCDUPL] <> '3'
				nImposVar	+=	aValImp[nPosImp] * If(aSFC[nI][SFC_INCDUPL] == '1', 1 , -1)
			Endif
		EndCase
	Endif
Next nI

Return(IIf(cOpc=="1",aRet,nImposVar))
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MaRetIncIV    � Leandro C.G. �Microsiga � Data �  14/01/02  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna valores de impostos referentes a um item de NF que ���
���          � incidem no custo, Duplicata, ou Nota                       ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function NumCpoImpVar(xCpoLiv)
Local cCpo,xRet
cCpo:="123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
xRet:=0
If !Empty(xCpoLiv)
	If ValType(xCpoLiv)=="C"
		xRet:=At(xCpoLiv,cCpo)
	ElseIf ValType(xCpoLiv)=="N"
		If xCpoLiv>0
			xRet:=Substr(cCpo,xCpoLiv,1)
		Endif
	Endif
Endif
Return(xRet)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisImpLd� Autor � Eduardo Riera         � Data �11.08.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Carregar os valores de impostos gravados em um arquivo      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com os impostos no formato:                    ���
���          �       [1] Codigo do imposto                                ���
���          �       [2] Base do imposto                                  ���
���          �       [3] Aliquota do imposto                              ���
���          �       [4] Valor do imposto                                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do arquivo                                     ���
���          �ExpC2: Tipo de Imposto                                      ���
���          �       "IT" - Por item                                      ���
���          �       "NF" - Por documento                                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisImpLd(cAlias,cTipo,cCursor)

Local aArea       := GetArea()
Local aReferencia := MaFisSXRef(cAlias)
Local aImposto    := {}
Local aCodImp     := {}
Local nX          := 0
Local nY          := 0

DEFAULT cTipo := "IT"
DEFAULT cCursor := cAlias

//�������������������������������������������������������������Ŀ
//� Verifica os codigos de impostos                             �
//���������������������������������������������������������������
aadd(aCodImp,"ICM")
aadd(aCodImp,"IPI")
aadd(aCodImp,"ICA")
aadd(aCodImp,"SOL")
aadd(aCodImp,"CMP")
aadd(aCodImp,"ISS")
aadd(aCodImp,"IRR")
aadd(aCodImp,"INS")
aadd(aCodImp,"COF")
aadd(aCodImp,"CSL")
aadd(aCodImp,"PIS")
aadd(aCodImp,"PS2")
aadd(aCodImp,"CF2")
aadd(aCodImp,"RUR")
For nX := 1 To NMAXIV
	aadd(aCodImp,"IV"+StrZero(nX,1))
Next nX
//�������������������������������������������������������������Ŀ
//� Verifica os codigos de impostos                             �
//���������������������������������������������������������������
For nX := 1 To Len(aCodImp)
	aadd(aImposto,{aCodImp[nX],0,0,0})
	nY := aScan(aReferencia,{|x| x[2]=cTipo+"_BASE"+aCodImp[nX]})
	If nY <> 0
		aImposto[nX][2] := (cCursor)->(FieldGet(FieldPos(aReferencia[nY][1])))
	EndIf
	nY := aScan(aReferencia,{|x| x[2]=cTipo+"_ALIQ"+aCodImp[nX]})
	If nY <> 0
		aImposto[nX][3] := (cCursor)->(FieldGet(FieldPos(aReferencia[nY][1])))
	EndIf
	nY := aScan(aReferencia,{|x| x[2]=cTipo+"_VAL"+aCodImp[nX]})
	If nY <> 0
		aImposto[nX][4] := (cCursor)->(FieldGet(FieldPos(aReferencia[nY][1])))
	EndIf	
Next nX
nY := 0
For nX := 1 To Len(aImposto)
	If !Empty(aImposto[nX])
		If aImposto[nX][4] == 0	
			aImposto := aDel(aImposto,nX)
		Else
			nY++
		EndIf
	EndIf
Next nX
aImposto := aSize(aImposto,nY)
RestArea(aArea)
Return(aImposto)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisRefLd� Autor � Eduardo Riera         � Data �20.08.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Demonstra as referencias dos impostos de uma tabela         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com os impostos no formato:                    ���
���          �       [1] Codigo do imposto                                ���
���          �       [2] Campo da Base do imposto                         ���
���          �       [3] Campo da Aliquota do imposto                     ���
���          �       [4] Campo do Valor do imposto                        ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do arquivo                                     ���
���          �ExpC2: Tipo de Imposto                                      ���
���          �       "IT" - Por item                                      ���
���          �       "NF" - Por documento                                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisRefLd(cAlias,cTipo)

Local aArea       := GetArea()
Local aReferencia := MaFisSXRef(cAlias)
Local aImposto    := {}
Local aCodImp     := {}
Local nX          := 0
Local nY          := 0

DEFAULT cTipo := "IT"

//�������������������������������������������������������������Ŀ
//� Verifica os codigos de impostos                             �
//���������������������������������������������������������������
aadd(aCodImp,"ICM")
aadd(aCodImp,"IPI")
aadd(aCodImp,"ICA")
aadd(aCodImp,"SOL")
aadd(aCodImp,"CMP")
aadd(aCodImp,"ISS")
aadd(aCodImp,"IRR")
aadd(aCodImp,"INS")
aadd(aCodImp,"COF")
aadd(aCodImp,"CSL")
aadd(aCodImp,"PIS")
aadd(aCodImp,"PS2")
aadd(aCodImp,"CF2")
aadd(aCodImp,"RUR")
For nX := 1 To NMAXIV
	aadd(aCodImp,"IV"+StrZero(nX,1))
Next nX
//�������������������������������������������������������������Ŀ
//� Verifica os codigos de impostos                             �
//���������������������������������������������������������������
For nX := 1 To Len(aCodImp)
	aadd(aImposto,{aCodImp[nX],0,0,0})
	nY := aScan(aReferencia,{|x| x[2]=cTipo+"_BASE"+aCodImp[nX]})
	If nY <> 0
		aImposto[nX][2] := aReferencia[nY][1]
	EndIf
	nY := aScan(aReferencia,{|x| x[2]=cTipo+"_ALIQ"+aCodImp[nX]})
	If nY <> 0
		aImposto[nX][3] := aReferencia[nY][1]
	EndIf
	nY := aScan(aReferencia,{|x| x[2]=cTipo+"_VAL"+aCodImp[nX]})
	If nY <> 0
		aImposto[nX][4] := aReferencia[nY][1]
	EndIf	
Next nX
RestArea(aArea)
Return(aImposto)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisCalAl � Autor � Bruno Sobieski       � Data �29.08.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o calculo da Aliquota dos Impostos Variaveis        ���
���          �Esta funcao foi criada para nao tirar a propriedade de      ���
���          �STATIC da funcao MAFISAliqIV                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Numero do Imposto ( 1 a 6 )                          ���
���          �ExpN2: Item a ser calculado                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisCalAl(nImposto,nItem)

MaFisAliqIV(nImposto,nItem)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MaVldForn     � Nereu H. Jr. �Microsiga � Data �  12/09/03  ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida fornecedor no momento da transferencia de fornecedor���
���          � na implantacao do titulo de ISS                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MaVldForn(cFornIss,cLojaIss,oDescri,cDescri,oLojaISS,oFornIss,nTipo)

Local lRet := .F.

If Empty(cFornIss)
	cLojaISS := Space(Len(cLojaIss))
	lRet := .T. 	
	cDescri := ""
	oDescri:Refresh()
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	If MsSeek(xFilial("SA2")+cFornIss+cLojaIss)
		cDescri := SA2->A2_NREDUZ
		lRet := .T.
		oDescri:Refresh()
	Else
		If nTipo == 1
			lRet := .T.
		Else
			lRet := .F.
		Endif	
		cDescri := ""
	Endif	
EndIf

If nTipo == 2 .And. Empty(cLojaIss) .And. !Empty(cFornIss)
	cFornISS := Space(Len(cFornIss))
	lRet := .T. 	
	cDescri := ""
	oDescri:Refresh()
	oFornIss:Refresh()
Endif

Return(lRet)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaPrcVen � Autor � Bruno Sobieski        � Data �08.12.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Aplica o desconto no campo de preco de venda, quando estamos���
���          �usando a tabelas SD2.                                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1 : Item                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MaPrcVen(nItem)

If cPaisLoc <> "BRA" .And. aNfCab[NF_OPERNF] =='S' .And. SuperGetMV('MV_DESCSAI') =='1'
	aNFitem[nItem][IT_VALMERC] -=	 aNFitem[nItem][IT_DESCONTO]
	aNFitem[nItem][IT_PRCUNI]  :=	aNFitem[nItem][IT_VALMERC]/Max(aNFitem[nItem][IT_QUANT],1)
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisLdImp� Autor � Eduardo Riera         � Data �20.08.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Demonstra os impostos tratados pelo sistema                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com os impostos no formato:                    ���
���          �       [1] Codigo do imposto                                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaFisLdImp()

Local aCodImp     := {}
Local nX          := 0

//�������������������������������������������������������������Ŀ
//� Verifica os codigos de impostos                             �
//���������������������������������������������������������������
aadd(aCodImp,"ICM")
aadd(aCodImp,"IPI")
aadd(aCodImp,"ICA")
aadd(aCodImp,"SOL")
aadd(aCodImp,"CMP")
aadd(aCodImp,"ISS")
aadd(aCodImp,"IRR")
aadd(aCodImp,"INS")
aadd(aCodImp,"COF")
aadd(aCodImp,"CSL")
aadd(aCodImp,"PIS")
aadd(aCodImp,"PS2")
aadd(aCodImp,"CF2")
aadd(aCodImp,"RUR")
For nX := 1 To NMAXIV
	aadd(aCodImp,"IV"+StrZero(nX,1))
Next nX
Return(aCodImp)

Static Function MAFisZero()
Return 0.0001
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MaRetBasT� Autor � Bruno Sobieski        � Data �21.10.2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a base total de um imposto, dependendo da aliquota  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Function MaRetBasT(cNumImp,nItem,nAliq)
Local nBase		:=	0
Local nX			:=	0
//Local nPosImp	:=	aScan(aNfCab[NF_IMPOSTOS],{|x| x[IMP_COD] ==aDesc[1] .And.	x[IMP_ALIQ]==nAliq })

//nBase		:=	MaFisRet(nItem,'IT_BASEIV'	+cNumImp)	
For nX := 1 To Len(aNFItem)
	If !aNfItem[nX][IT_DELETED]
		If MaFisRet(nX,'IT_ALIQIV'+cNumImp) == nAliq
			nBase += MaFisRet(nX,'IT_BASEIV'+cNumImp)
		Endif
	Endif
Next       
Return nBase

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MaTbIrfPF � Autor �Eduardo/Edson          � Data �31.01.2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inicializa o Calculo das operacoes Fiscais                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA: [1] Valor do IRPF                                     ���
���          �      [2] Aliquota do IRPF                                  ���
���          �      [3] Dedu��o  do IRPF                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 : Valor do IRPF                                      ���
���          � ExpN2 : Valor acumulado do IRPF                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MaTbIrfPF(nBaseIRF,nTotIrf)

Local aArea   := GetArea()
Local aTabela := {}
Local cBuffer := ""
Local nX      := 0
Local nBase   := 0
Local nAliq   := 0
Local nValor  := 0
Local nDed    := 0
Local nIsento := 0

DEFAULT nTotIrf := 0

If File("sigaadv.irf")
	FT_FUse("sigaadv.irf")
	FT_FGotop()
	
	While ( !FT_FEof() )
	
		cBuffer := FT_FReadLn()
		aadd(aTabela,{Val(SubStr(cBuffer,1,15)),Val(SubStr(cBuffer,17,6)),Val(SubStr(cBuffer,24,15))})
		FT_FSkip()
		
	EndDo
	FT_FUse()
	
	For nX := 1 To Len(aTabela)
		nBase := aTabela[nX,1]
		nAliq := aTabela[nX,2]
		nDed  := aTabela[nX,3]	
		If nAliq == 0
			nIsento := nBase
		EndIf	
		If nBaseIRF+nTotIrf <= aTabela[nX][1]
			Exit
		EndIf
	Next nX
	
	nValor := MyNoRound(((nBaseIRF+nTotIrf)*nAliq/100),2)-nDed
	
EndIf
RestArea(aArea)
Return({nValor,nAliq,nDed,nIsento})

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MyNoRound � Autor �Eduardo/Wilson         � Data �28.07.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inicializa o Calculo das operacoes Fiscais                  ���
�������������������������������������������������������������������������Ĵ��
���Parametro �ExpN1: Valor de partida                                     ���
���          �ExpN2: Numero de casas decimais                             ���
���          �ExpN3: Resto                                                ���
���          �ExpN4: Precis�o                                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Valor truncado                                             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function MyNoRound(nPartida,nCasas,nDiferenca,nPrecisao)

Local cString := ""
Local nAt     := 0
Local nValor  := 0

DEFAULT nPrecisao := 10
DEFAULT nDiferenca:= 0

cString    := Strzero(nPartida,20,nPrecisao)
nAt        := At(".",cString) 
nAt        += nCasas
nValor     := Round(Val(SubStr(cString,1,nAt)), nCasas)

nAt++

cString    := SubStr(cString,nAt)
nDiferenca := Round(Val(cString) / (10 ** 8), 8)

Return(nValor)

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisBsAFRMM� Autor � Sergio S. Fuzinaka    � Data �25.08.2005���
���������������������������������������������������������������������������Ĵ��
���Descricao �Retorna a Base de Calculo do AFRMM                            ���
���������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function MaFisBsAFRMM(nItem)

Local nBaseAFRMM := 0

If aTes[TS_AFRMM] == "S" .And. !Empty( aNfItem[nItem][IT_VALMERC] )
	nBaseAFRMM := aNfItem[nItem][IT_VALMERC]
	aNfItem[nItem][IT_BASEAFRMM] := nBaseAFRMM
Else
	aNfItem[nItem][IT_BASEAFRMM] := nBaseAFRMM
EndIf

Return( nBaseAFRMM )

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    �MaAliqAFRMM� Autor � Sergio S. Fuzinaka     � Data �25.08.2005���
���������������������������������������������������������������������������Ĵ��
���Descricao �Retorna a Aliquota para o Calculo do AFRMM                    ���
���������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function MaAliqAFRMM(nItem)

Local aArea		 := GetArea()
Local nAliqAFRMM := GetNewPar("MV_TXAFRMM",0)

If aTes[TS_AFRMM] == "S" .And. !Empty( nAliqAFRMM )
	aNfItem[nItem][IT_ALIQAFRMM] := nAliqAFRMM
Else
	nAliqAFRMM := 0
	aNfItem[nItem][IT_ALIQAFRMM] := nAliqAFRMM
Endif
RestArea(aArea)

Return( nAliqAFRMM )

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    �MaFisVlAFRMM� Autor � Sergio S. Fuzinaka    � Data �25.08.2005���
���������������������������������������������������������������������������Ĵ��
���Descricao �Retorna o Valor do AFRMM                                      ���
���������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Item                                                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function MaFisVLAFRMM(nItem)

Local nVlAFRMM	:= 0
Local lMaAFRMM	:= ExistBlock( "MAAFRMM" ) 

If aTes[TS_AFRMM] == "S" .And. !Empty( aNfItem[nItem][IT_BASEAFRMM] ) .And. !Empty( aNfItem[nItem][IT_ALIQAFRMM] )
	nVlAFRMM := (( aNfItem[nItem][IT_BASEAFRMM] * aNfItem[nItem][IT_ALIQAFRMM] ) / 100 )

	//������������������������������������������������������������������������������Ŀ
	//� Ponto de Entrada para tratamento do Valor Calculado do AFRMM com o Adicional �
	//��������������������������������������������������������������������������������
	If lMaAFRMM
		nVlAFRMM := ExecBlock("MAAFRMM",.F.,.F.,{nVlAFRMM})
	Endif

	aNfItem[nItem][IT_VALAFRMM] := nVlAFRMM
Else
	aNfItem[nItem][IT_VALAFRMM] := nVlAFRMM
EndIf
	
Return( nVlAFRMM )

