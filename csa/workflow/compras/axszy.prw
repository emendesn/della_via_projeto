#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZY    � Autor � Alexandre Martim   � Data �  31/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZY
     //
     //���������������������������������������������������������������������Ŀ
     //� Declaracao de Variaveis                                             �
     //�����������������������������������������������������������������������
     //
     Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
     Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
     Private cPerg   := "SZY"
     //
     Private cString := "SZY"
     //
     dbSelectArea("SZY")
     dbSetOrder(1)
     //
     //cPerg   := "SZY"
     //
     //Pergunte(cPerg,.F.)
     //SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros
     //
     AxCadastro(cString,"Cadastro de Grupos de Aprovacao X C.Custo",cVldAlt,cVldExc)
     //
     //Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
     //
Return
