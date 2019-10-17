Project Function ExclSB0()
Local cPerg := "TMPSB0"
Local nOpc  := 0
Local aSay  := {}
Local aBut  := {}

PutSx1(cPerg, "01", "Filial exemplo ?           ","","","mv_ch1","C",02,0,0,"G","ExistCpo('SM0','01'+MV_PAR01)","SM0","","","MV_PAR01","","","","","" ,"","","","","","","","","","","")
Pergunte(cPerg, .F.)

aAdd(aSay, "Este programa criará os registros da tabela de preços SB0")
aAdd(aSay, "nas demais filiais do sistema.")
aAdd(aBut, {5, .T.,	{|| Pergunte(cPerg, .T.)}})
aAdd(aBut, {1, .T., {|| nOpc := 1, FechaBatch()}})
aAdd(aBut, {2, .T., {|| FechaBatch()}})

FormBatch("Gerar tabela de preços", aSay, aBut)

If nOpc == 1
	If !Empty(MV_PAR01)
		Processa({|| MontaSB0()})
	EndIf
EndIf

Return



Static Function MontaSB0()
Local aFiliais := {}
Local nTotFil  := 0
Local cSQL := ""
Local nX

ProcRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem filiais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbSetOrder(1) // M0_CODIGO+M0_CODFIL
dbSeek("01")  // DELLA VIA

While SM0->M0_CODIGO == "01"
	aAdd(aFiliais, SM0->M0_CODFIL)
	dbSkip()
End

nTotFil := Len(aFiliais)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem precos da filial MV_PAR01 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSQL := " select B0_COD"
cSQL += "   from " + RetSQLName("SB0")
cSQL += "  where D_E_L_E_T_ <> '*'"
cSQL += "    and B0_FILIAL = " + ValToSql(MV_PAR01)
cSQL := ChangeQuery(cSQL)

dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "TMPSB0", .F., .T.)

While !EOF()
	For nX := 1 to nTotFil
		IncProc()
		If aFiliais[nX] <> MV_PAR01
			If !SB0->(dbSeek(aFiliais[nX] + TMPSB0->B0_COD))
				RecLock("SB0", .T.)
				SB0->B0_FILIAL  := aFiliais[nX]
				SB0->B0_COD     := TMPSB0->B0_COD
				SB0->B0_PRV1    := 0.01
				msUnlock()
			EndIf
		EndIf
	Next nX
	
	dbSelectArea("TMPSB0")
	dbSkip()
End

dbCloseArea()

Return
