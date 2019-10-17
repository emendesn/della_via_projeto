USER FUNCTION DCOMV01

LOCAL aArea    := GetArea()
LOCAL nPosCod  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_COD"})
LOCAL nPosLoc  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_LOCAL"})
LOCAL nPosQtd  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_QUANT"})
LOCAL cCodProd := aCols[n][nPosCod]
LOCAL cLocal   := aCols[n][nPosLoc]
LOCAL nQuant   := aCols[n][nPosQtd]
LOCAL lRet     := .T.

IF SM0->M0_CODIGO == '03' .and. Funname() == "MATA103"
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial('SB1')+cCodProd+cLocal))

	IF cTipo == 'B' .and. Alltrim(SB1->B1_GRUPO) == "CARC" .and. nQuant > 1
	IW_MSGBOX("Quantidade deste tipo de produto nao podera ser maior que 1", " * * * A T E N C A O  * * * ","ALERT") 
		lRet := .F.
	EndIF
EndIF

RestArea(aArea)

RETURN(lRet)