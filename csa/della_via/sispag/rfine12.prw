#include "rwmake.ch" 

User Function RFINE12() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_cRetorno")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������� �Ŀ��
���Rotina    � RFINE12.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o nome do contribuinte da Darf e   ���
���            Darf Simples                                               ���
���            Posicao 166 195 - Nome do Contribuinte                     ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 27/04/2005                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sispag ITAU                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/             
  _cRetorno := ""               
                                               
  If !Empty(SE2->E2_E_CONTR)
     _cRetorno := Subs(SE2->E2_E_CONTR,1,30)
  Else
     _cRetorno := Subs(SM0->M0_NOME,1,30) 
  EndIf
  
Return(_cRetorno)  