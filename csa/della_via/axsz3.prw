#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZ3    � Autor � Alexandre Martim   � Data �  31/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZ3
     //
     //���������������������������������������������������������������������Ŀ
     //� Declaracao de Variaveis                                             �
     //�����������������������������������������������������������������������
     //
     Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
     Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
     Private cPerg   := "SZ3"
     //
     Private cString := "SZ3"
     //
     dbSelectArea("SZ3")
     dbSetOrder(1)
     //
     //cPerg   := "SZ3"
     //
     //Pergunte(cPerg,.F.)
     //SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros
     //
     AxCadastro(cString,"Cadastro de Categorias X Grupo",cVldAlt,cVldExc)
     //
     //Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
     //
Return
