
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA290     �Autor  �Microsiga           � Data �  18/10/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Complementa a grava��o da fatura com as informa��es obriga ���
���          � torias da tabela de contas a pagar                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION FA290()

Reclock("SE2")
SE2->E2_CONTAD := POSICIONE("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_DEBITO")
SE2->E2_ITEMD  := TrazItem()
SE2->E2_CCD    := TrazCCD()
MsUnlock()
RETURN

STATIC FUNCTION TrazItem()
LOCAL _cRet := SPACE(9)

DbSelectArea("CTD")
DbSetOrder(1)
DbSeek(xFilial("CTD"))
While !Eof()
	
	IF CTD->CTD_CLASSE == "2"
		_cRet := CTD_ITEM
		EXIT
	ENDIF
	
	DbSelectArea("CTD")
	DbSkip()
EndDo

Return(_cRet)

STATIC FUNCTION TrazCCD()
LOCAL _cRet := SPACE(9)

DbSelectArea("CTT")
DbSetOrder(1)
DbSeek(xFilial("CTT"))

While !Eof()
	
	IF CTT->CTT_CLASSE == "2"
		_cRet := CTT->CTT_CUSTO
		EXIT
	ENDIF

	DbSelectArea("CTT")
	DbSkip()
EndDo

RETURN(_cRet)
