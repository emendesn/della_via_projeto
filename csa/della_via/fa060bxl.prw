#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  FA070BXL � Autor �  �              Data � 10/11/05 �       ��
�������������������������������������������������������������������������Ĵ��
���Descricao � Atualiza o campo E5_FILORIG de acordo com a filial logada  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Della Via Pneus                                            ���
�������������������������������������������������������������������������Ĵ��
/*/
 
User Function FA060BXL()  

SE5->E5_FILORIG := XFILIAL()  