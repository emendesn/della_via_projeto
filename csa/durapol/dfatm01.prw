User Function DFatM01

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DFATM01   �Autor  �Microsiga           � Data �  10/10/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

LOCAL aArea:= GetArea()
LOCAL nRet := 0

dbSelectArea("DA1")
dbSetOrder(2)
dbSeek(xFilial("DA1")+ACP->ACP_CODPROD)

IF ACP->ACP_PERDES > 0
	
	nRet := DA1->DA1_PRCVEN * ( ( 100 - ACP->ACP_PERDES ) / 100 )

ElseIF ACP->ACP_PERACR > 0

	nRet := DA1->DA1_PRCVEN + ( ( DA1->DA1_PRCVEN * ACP->ACP_PERDES ) / 100 )
	
Else

	nRet := DA1->DA1_PRCVEN
	
EndIF

RestArea(aArea)

Return(nRet)
