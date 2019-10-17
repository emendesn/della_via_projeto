USER FUNCTION MT100LOK
              
LOCAL aArea      := GetArea()
LOCAL nPosCod    := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_COD"})
LOCAL nPosLoc    := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_LOCAL"})
LOCAL nPosFogo   := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_NUMFOGO"})
LOCAL nPosSerie  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_SERIEPN"})
LOCAL cCodProd   := aCols[n][nPosCod]
LOCAL cLocal     := aCols[n][nPosLoc]
LOCAL cFogo      := aCols[n][nPosFogo]
LOCAL cSerie     := aCols[n][nPosSerie]  
LOCAL lRet       := .T.
                
IF SM0->M0_CODIGO == '03'

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial('SB1')+cCodProd+cLocal))

	IF cTipo == 'B' .and. Alltrim(SB1->B1_GRUPO) == "CARC" .and. ( Empty(cFogo) .and. Empty(cSerie) ) 
		iw_MSGBOX("O campo Numero de fogo ou numero de serie são de preenchimento obrigatório","Atenção","Alert")
		lRet := .F.
	EndIF

ENDIF

RestArea(aArea)

RETURN(lRet)