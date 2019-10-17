#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function Rfine08()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
   
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_TTABAT,_JUROS,_LIQUI,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � RFINE08.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para calcular o valor dos abatimentos concedidos ���
���          � nos titulos de contas a receber a ser gravando no arquivo  ���
���          � de remessa ao banco via Cnab.                            ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari Rosa                                      ���
���mento     � 03/02/05.                                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cnab a Receber Itau                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_TtAbat := 0.00

//--- Funcao SOMAABAT totaliza todos os titulos com e1_tipo AB- relacionado ao
//---        titulo do parametro 
_TtAbat  := somaabat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,'R',SE1->E1_MOEDA,DDATABASE,SE1->E1_CLIENTE,SE1->E1_LOJA)

Return(_TtAbat)
