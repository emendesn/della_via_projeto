#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZ6    � Autor � Alexandre Martim   � Data �  31/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZ6
     //
     //���������������������������������������������������������������������Ŀ
     //� Declaracao de Variaveis                                             �
     //�����������������������������������������������������������������������
     //
     Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
     Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
     Private cPerg   := "SZ6"
     //
     Private cString := "SZ6"
     //
     dbSelectArea("SZ6")
     dbSetOrder(1)
     //
     //
     AxCadastro(cString,"Cadastro de Categorias",cVldAlt,cVldExc)
     //
     //Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
     //
Return