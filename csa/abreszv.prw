#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AbreSZV  � Autor � Felipe Fernandes 	 � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao �AxCadatro de tabela  customizada SZV                        ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusvio Dellavia                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AbreSZV


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZV"

dbSelectArea("SZV")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de dias uteis por loja - SigaDw",cVldAlt,cVldExc)

Return
