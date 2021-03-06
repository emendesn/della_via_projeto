/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFW120P  �Autor  �BRUNO PAULINELLI      � Data � 07/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada zera a flag C7_WF                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WFW120P()
Local lRet 		:= .T.
Local _cNum		:= SC7->C7_NUM
Local _aArea    := GetArea()

If ! Altera
	Return(lRet)
EndIf

DbSelectArea("SC7")
DbSetOrder(1)
SC7->(DbGoTop())
If DbSeek(xFilial("SC7")+_cNum)
	While !SC7->(Eof()) .AND. _cNum == SC7->C7_NUM
		Reclock("SC7",.F.)
		SC7->C7_WF := " "
		SC7->(MsUnlock())	
	SC7->(DbSkip())	
	EndDo
EndIf

RestArea(_aArea)

Return(lRet)