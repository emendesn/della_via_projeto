#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function F240Arq()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � F420ARQ.PRW                                               ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para declarar variavel publica que sera  ���
���          � utilizada para totalizar o valor de outras entidades na   ���
���          � geracao do SISPAG                                         ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 27/12/2004                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Utilizado no sispag do Itau para declarar variavel publica ���
���            para totalizar o valor de outras entidades.                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Public _nTotEnt   := 0 
Public _nTotAcres := 0       
Public _nTotGps   := 0  
Public _nSubDar   := 0
Public _nTotDar   := 0

Return        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
