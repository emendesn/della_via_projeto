#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DESTA03  � Autor � Jader              � Data �  24/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de motivos de rejeicao/aprovacao SEPU             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � DURAPOL                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DESTA03()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZS"
Private aMemos  := {{"ZS_CODOBS","ZS_OBS"}}

dbSelectArea("SZS")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Motivos SEPU",cVldAlt,cVldExc)

Return
