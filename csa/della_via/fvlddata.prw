/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FVldData �Autor  �Microsiga           � Data �  01/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FVldData(_dDataDig)
	Local lRet := .T.
	Local _dDataLim := dDataBase + GetMv("MV_PZRESER")
	//
	IF _dDataDig > _dDataLim
		lRet := .F.
		IW_MsgBox("A data limite para a cria��o da reserva � " + DTOC(_dDataLim),;
		"  * * * A T E N C A O * * * ","ALERT")
	ELSEIF _dDataDig < dDataBase
	    lRet := .F.
		IW_MsgBox("Data de reserva invalida, utilize qualquer data superior a de " + DTOC(dDataBase),;
		"  * * * A T E N C A O * * * ","ALERT")    
	ENDIF
	//
Return(lRet)

