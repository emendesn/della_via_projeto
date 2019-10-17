
User Function CriaSB0()
Local aSay := {}
Local aButton := {}
Local nOpc := 0

//Texto explicativo da rotina
aAdd( aSay, "Esta rotina tem por objetivo criar o registro da tabela de preços nas filiais   " )
aAdd( aSay, "onde a mesma não existe, tornando possível utilizar o SB0 como exclusivo.       " )

//Botoes da tela principal
aAdd(aButton, {1, .T., {|| nOpc := 1, FechaBatch()} }) //Confirma
aAdd(aButton, {2, .T., {|| FechaBatch()} }) //Cancela

//Abre a tela
FormBatch("Acerta SB0", aSay, aButton)

//Acao executada caso o usuario confirme a tela
If nOpc <> 0
	Processa({|| Continua()}, "Aguarde")
EndIf

Return



Static Function Continua()
Local aAreaSM0 := SM0->(GetArea())
Local cGrupos := ""
Local cSQL := ""
Local aFilis := {}
Local nTotFil := 0
Local nCount := 0
Local i := 0

dbSelectArea("SB0")
dbSetOrder(1) // B0_FILIAL+B0_COD

dbSelectArea("SM0")
ProcRegua(RecCount())
dbSetOrder(1) // M0_CODIGO+M0_CODFIL
dbSeek("01") // DELLA VIA

While !EOF() .And. SM0->M0_CODIGO == "01"
	IncProc("Filiais")
	
	If Val(SM0->M0_CODFIL) > 0
		aAdd(aFilis, SM0->M0_CODFIL)
	EndIf
	
	dbSelectArea("SM0")
	dbSkip()
End

nTotFil := Len(aFilis)

dbSelectArea("SBM")
ProcRegua(RecCount())
dbSetOrder(1) // BM_FILIAL+BM_GRUPO
dbSeek(xFilial("SBM"))

While !EOF() .And. SBM->BM_FILIAL == xFilial("SBM")
	IncProc("Grupos")
	
	If Val(SBM->BM_GRUPO) > 0
		If !Empty(cGrupos)
			cGrupos += ","
		EndIf
		cGrupos += "'" + SBM->BM_GRUPO + "'"
	EndIf
	
	dbSelectArea("SBM")
	dbSkip()
End

If !Empty(cGrupos)
	cGrupos := "(" + cGrupos + ")"
EndIf

cSQL := "   select B1_COD from " + RetSQLName("SB1")
cSQL += "    where D_E_L_E_T_ <> '*'"
cSQL += "      and B1_GRUPO in " + cGrupos
cSQL += " order by B1_COD"
cSQL := ChangeQuery(cSQL)

dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "TMPSB1", .F., .T.)

ProcRegua(0)

While !EOF()
	If (nCount % 5) == 0
		IncProc("Preços")
	EndIf
	
	For i := 1 to nTotFil
		If !SB0->(dbSeek(aFilis[i] + TMPSB1->B1_COD))
			RecLock("SB0", .T.)
			SB0->B0_FILIAL  := aFilis[i]
			SB0->B0_COD     := TMPSB1->B1_COD
			SB0->B0_PRV1    := 0.01
			msUnlock()
		EndIf
	Next i
	
	nCount += 1
	dbSelectArea("TMPSB1")
	dbSkip()
End

dbCloseArea()
RestArea(aAreaSM0)

Return
