
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA290     ºAutor  ³Microsiga           º Data ³  18/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Complementa a gravação da fatura com as informações obriga º±±
±±º          ³ torias da tabela de contas a pagar                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
