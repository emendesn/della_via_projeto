#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function rfine06()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("TTABAT,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � RFINE06.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para calcular o valor de descontos nos titulos   ���
���          � do contas a pagar a ser gravado no arquivo de remessa de   ���
���          � titulos ao banco via Sispag                                ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 29/11/2004                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sispag Itau                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_TtAbat := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_TtAbat := Left(StrZero((_TtAbat*1000),16),15)

Return(_TtAbat)        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00