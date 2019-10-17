#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function Rfine02()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
   
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
���Rotina    � RFINE02.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para calcular o valor de l�quido (principal -    ���
���          � abatimentos concedidos) nos t�tulos do contas a pagar,     ���
���          � a ser gravado no arquivo de remessa de titulos ao banco    ���
���          � via SISPAG                                                 ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari Rosa                                      ���
���mento     � 24/11/04.                                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sispag ITAU                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_TtAbat := 0.00
_Juros  := 0.00

//--- Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao
//---        titulo do parametro 
_TtAbat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_Juros := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
_Liqui := (SE2->E2_SALDO-_TtAbat+_Juros)
_Liqui := Left(StrZero((_Liqui*1000),16),15)

Return(_Liqui)
