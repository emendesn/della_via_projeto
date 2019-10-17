#include "rwmake.ch" 

User Function RFINE10() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_cRetorno,_Vlrrb,_Percr")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������� �Ŀ��
���Rotina    � RFINE10.PRW                                                 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar dados da Darf Simples ou Darf.     ���
���            Da posicao 047 ate 063                                     ���
���            Darf Simples Posicao 047 055 - Receita Bruta               ���
���                                 056 059 - Percentual Receita Bruta    ���
���                                 060 063 - Brancos                     ���
���            Darf         Posicao 047 063 - Brancos                     ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 26/04/2005                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sispag ITAU                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/             
  _cRetorno := ""               
  _Vlrrb    := ""
  _Percr    := ""
                              
                                               
  If se2->e2_e_vlrrb > 0    
     _Vlrrb   := Left(StrZero((se2->e2_e_vlrrb*1000),10),9)
     _Percr   := Left(StrZero((se2->e2_e_percr*1000),5),4)
     _cRetorno := _Vlrrb+_Percr+space(4)                               
  Else
     _cRetorno := repl("0",17)
  EndIf
  
Return(_cRetorno)  
