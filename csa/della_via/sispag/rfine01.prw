#include "rwmake.ch" 

User Function RFINE01() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CRETORNO,_CONTA")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������� �Ŀ��
���Rotina    � RFINE01.PRW                                                 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para pegar a agencia e conta corrente de         ���
���            favorecido, montar o retorno de acordo com o banco.        ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 24/11/2004                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sispag ITATU                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/             
  _cRetorno := ""
                              
  // Numero da Conta Corrente
  _conta := strzero(val(sa2->a2_numcon),10,0)
                                               
  If sa2->a2_banco == "341"
     _cRetorno := "0"+strzero(val(substr(sa2->a2_agencia,1,4)),4)+" "+"0000000"
     _cRetorno += strzero(val(substr(_conta,6,5)),5)+" "+substr(sa2->a2_e_digcc,1,1)                               
  Else
     _cRetorno := strzero(val(substr(sa2->a2_agencia,1,5)),5)+" "
     _cRetorno += strzero(val(substr(_conta,1,12)),12)
     If len(rtrim(ltrim(sa2->a2_e_digcc))) > 1
        _cRetorno += strzero(val(substr(sa2->a2_e_digcc,1,2)),2)
     Else
        _cRetorno += " "+substr(sa2->a2_e_digcc,1,1)
     EndIf                                     
  EndIf
  
  
Return(_cRetorno)  
