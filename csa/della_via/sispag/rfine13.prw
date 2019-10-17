#include "rwmake.ch" 

User Function RFINE13() 

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
���Rotina    � RFINE13.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o CPF/CNPJ do contribuinte para a  ���
���            Darf Simples e Darf                                        ���
���            Posicao 025 038 - CPF/CNPJ do Contribuinte                 ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 10/05/2005                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sispag ITAU                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/             
  _cRetorno := ""               
                                               
  If !Empty(SE2->E2_E_CNPJC)
     _cRetorno := Strzero(Val(SE2->E2_E_CNPJC),14)
  Else
     _cRetorno := Subs(SM0->M0_CGC,1,14)
  EndIf
  
Return(_cRetorno)  