#include "rwmake.ch"

User Function AXSZ1()
     //
     //���������������������������������������������������������������������Ŀ
     //� Declaracao de Variaveis                                             �
     //�����������������������������������������������������������������������
     //
     Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
     Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
     Private cPerg   := "SZ1"
     //
     Private cString := "SZ1"
     //
     dbSelectArea("SZ1")
     dbSetOrder(1)
     //
     //
     AxCadastro(cString,"Tabela Centro Custo",cVldAlt,cVldExc)
     //
     //Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
     //
Return