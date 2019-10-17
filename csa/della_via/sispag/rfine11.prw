#include "rwmake.ch" 

User Function RFINE11() 

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
���Rotina    � RFINE11.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o tipo de inscricao do contribuinte���
���            + CPF ou CNPJ do Contribuinte para a Darf Simples e Darf   ���
���            Posicao 024 024 - Tipo de Contribuinte 1=CPF 2=CNPJ        ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 27/04/2005                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sispag ITAU                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���Alteracao � Marciane Gennari  -  10/05/05                              ���
���          � Tirar o envio  do  CPF/CNPJ porque deu problema no arquivo ���
���            de retorno.                                                ���
�����������������������������������������������������������������������������
/*/             
  _cRetorno := ""               
                                               
  If !Empty(SE2->E2_E_CNPJC)
     _cRetorno := Iif (len(alltrim(SE2->E2_E_CNPJC))>11,"2","1")
     //--- Marciane 10.05.05 
     //_cRetorno += Strzero(Val(SE2->E2_E_CNPJC),14)
     //--- fim Marciane 10.05.05 
  Else               
     //--- Marciane 10.05.05 
     //_cRetorno := "2"+Subs(SM0->M0_CGC,1,14)
     _cRetorno := "2"       
     //--- fim Marciane 10.05.05
  EndIf
  
Return(_cRetorno)  
