#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUSF3    � Autor � MAURICIO MENDES    � Data �  16/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � ATUALIZA ARQUIVO SF3 LIVROS FISCAIS                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SETOR FISCAL PARA ACERTO SINTEGRA                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ATUSF3


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SF3"

dbSelectArea("SF3")
dbSetOrder(1)

AxCadastro(cString,"LIVRO FISCAL. . .",cVldAlt,cVldExc)

Return
