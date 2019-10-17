#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function F240Sum()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

SetPrvt("_valor,_abat,_juros")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � F420SOMA.PRW                                               ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para alterar o valor utilizado na funcao  ���
���          � SOMAVALOR() do sispag                                      ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Renato Genesini                                            ���
���mento     � 23/05/2005                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Utilizado no sispag do Itau para totalizar os acrescimos   ���
���            e descontos no valor total enviado ao banco.               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
_Abat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_Valor := SE2->E2_SALDO - _Abat 

//-- Variavel publica declarada no ponto de entrada f240arq()
//_nTotEnt   += SE2->E2_E_VLENT (LINHA DA FUNCTION ORIGINAL)

//_nTotAcres += SE2->E2_E_MUL 
_nTotAcres += SE2->E2_MULTA

//_nTotGps   += (SE2->E2_SALDO - SE2->E2_E_VLENT - SE2->E2_E_MUL) 
_nTotGps   += (SE2->E2_SALDO - SE2->E2_MULTA) 

//_nSubDar   += SE2->E2_E_MUL + SE2->E2_E_JUR                
_nSubDar   += SE2->E2_MULTA + SE2->E2_JUROS                


//_nTotDar   += (SE2->E2_SALDO - SE2->E2_E_MUL - SE2->E2_E_JUR)
_nTotDar   += (SE2->E2_SALDO - SE2->E2_MULTA - SE2->E2_JUROS)

Return(_Valor)        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
