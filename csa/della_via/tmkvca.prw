#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TMKDEF.CH"

User Function TMKVCA()
	Local lRet		 := .F.
	Local nNAux		 := n
	Local aArea      := GetArea()
	Local aColsAux	 := aClone(aCols)
	Local aHeadAux	 := aClone(aHeader)
	Local cCodFab    := ""

	nPProd    := aPosicoes[1][2]
	nPLocal   := aPosicoes[7][2]

	cProduto := aCols[n][nPProd]
	If nPLocal > 0
		cLocal := aCols[n][nPLocal]
	Endif

	If Empty(cProduto)
		Help(" ",1,"SEM PRODUT" )
		Return(lRet)
	Endif

	DbSelectarea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1") + cProduto)
		cObs   := MSMM(SB1->B1_CODOBS,TamSx3("B1_OBS")[1])
		cGrupo := SB1->B1_GRUPO
		cCodFab := AllTrim(SB1->B1_CODFAB)
		If Empty(cLocal)
			cLocal := SB1->B1_LOCPAD
		Endif
		nPosAnt:= Recno()
	Endif

	DbSelectarea("SB2")
	DbSetorder(1)
	If DbSeek(xFilial("SB2") + cProduto + cLocal)
		nAtu   	:= B2_QATU
		nPedVen := B2_QPEDVEN
		nEmp    := B2_QEMP
		nSalPedi:= B2_SALPEDI
		nReserva:= B2_RESERVA
	
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCompatibilizacao com o SIGAFAT - Tecla F4 Visualizacao do estoqueЁ
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		nSaldo  := SaldoSb2(,GetNewPar("MV_QEMPV",.T.))
	Endif

	DbSelectarea("SB5")
	DbSeek(xFilial("SB5") + cProduto)

	DbSelectarea("SX3")
	DbSetorder(2)
	If DbSeek("B2_QATU")
		cPictSB2 := SX3->(X3_PICTURE)
	Endif

	DbSelectarea("SX5")
	DbSetorder(1)
	If DbSeek(xFilial("SX5")+"03"+cGrupo)
		cGrupo := X5DESCRI()
	Endif


	DEFINE MSDIALOG oDlg FROM 23,181 TO 402,723 TITLE "Caracteristicas do produto" PIXEL
		DbSelectarea("SB1")
		DbGoto(nPosAnt)              
	
		dbSelectArea("SBZ")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SBZ")+SB1->B1_COD)

		DbSelectarea("SB1")

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁDados das caracteristicas do produto                 Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
		@06,02 TO 43,270 LABEL "Dados do Produto" OF oDlg PIXEL COLOR CLR_BLUE

		@13,04  SAY "CСdigo" SIZE  21,7 OF oDlg PIXEL
		@13,29  SAY SB1->B1_COD SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE
	
		@13,80  SAY "Unidade" SIZE  20,7 OF oDlg PIXEL
		@13,102 SAY SB1->B1_UM SIZE  10,8 OF oDlg PIXEL COLOR CLR_BLUE
	
		@13,115 SAY "Grupo" SIZE  18,7 OF oDlg PIXEL
		@13,135 SAY cGrupo SIZE 40,8 OF oDlg PIXEL COLOR CLR_BLUE
	
		@13,155 SAY "Qtd. Embalagem" SIZE  70,7 OF oDlg PIXEL
		@13,225 SAY Transform(SBZ->BZ_QE,"@E 999,999.999") SIZE  35,7 OF oDlg PIXEL COLOR CLR_BLUE
	
		@23, 4  SAY "DescriГЦo" SIZE  32, 7 OF oDlg PIXEL //"Descri┤└o" 
		@23,33  SAY SB1->B1_DESC SIZE 140, 8 OF oDlg PIXEL COLOR CLR_BLUE
	
		@23,155 SAY "Peso Liquido" SIZE  60,7 OF oDlg PIXEL
		@23,225 SAY Transform(SB1->B1_PESO,"@E 999,999.9999") SIZE  35,7 OF oDlg PIXEL COLOR CLR_BLUE
	
		@33, 4  SAY "CСdigo do Fabricante" SIZE  80,7 OF oDlg PIXEL
		@33,90  SAY cCodFab SIZE 138, 8 OF oDlg PIXEL COLOR CLR_BLUE
	
		cBitPro := SB1->B1_BITMAP
		//здддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCarrega a imagem do produto                         Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддды
		@45,02 TO 152,105 LABEL "Foto" OF oDlg PIXEL
		If Empty(SB1->B1_BITMAP)
			@ 80,30 SAY "Foto nЦo disponivИl" SIZE 50,8 PIXEL COLOR CLR_BLUE OF oDlg
		Else
			@ 50,04 REPOSITORY oBitPro OF oDlg NOBORDER SIZE 100,100 PIXEL
			Showbitmap(oBitPro,SB1->B1_BITMAP,"")
			oBitPro:lStretch:=.F.
			oBitPro:Refresh()
		Endif
	
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁCarrega as observa┤ao sobre o produto B1_OBS         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
		@45,110 TO 152,270 LABEL "ObservaГУes" OF oDlg PIXEL
		@51,115 GET oObs VAR cObs OF oDlg MEMO Size 150,99 PIXEL READONLY

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁSaldo do estoque do produto                          Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
		@153,02 TO 188,155 LABEL "Estoque" OF oDlg PIXEL
	
		@158, 04 SAY "Ped. Abertos" SIZE  33, 7 OF oDlg PIXEL
		@158, 42 SAY Transform(nPedVen,cPictSB2) SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
		@168, 04 SAY "a Entrar" SIZE  33, 7 OF oDlg PIXEL
		@168, 42 SAY Transform(nSalPedi,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
		@178, 04 SAY "Atual" SIZE  33, 7 OF oDlg PIXEL
		@178, 42 SAY Transform(nAtu,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
		@158, 83 SAY "Empenho" SIZE  33, 7 OF oDlg PIXEL
		@158,110 SAY Transform(nEmp,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
		@168, 83 SAY "Reservado" SIZE  33, 7 OF oDlg PIXEL
		@168,110 SAY Transform(nReserva,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE
	
		@178, 83 SAY "DisponМvel" SIZE  33, 7 OF oDlg PIXEL
		@178,110 SAY Transform(nSaldo,"@E 999,999,999.99") SIZE 40, 7 OF oDlg PIXEL COLOR CLR_BLUE

		//@154,160 BUTTON STR0057 SIZE 50,15 OF oDlg PIXEL ACTION TKDetalhes(nFolder) 		  		//"Complemento"

		//@154,220 BUTTON STR0058 SIZE 50,15 OF oDlg PIXEL ACTION TKVisuProd(cProduto,cLocal)   		//"Produto"

		//@175,160 BUTTON STR0059 SIZE 50,15 OF oDlg PIXEL ACTION TKTabela(cProduto) 					//"Tabela"

		@165,190 BUTTON "OK" SIZE 50,15 OF oDlg PIXEL ACTION (lRet := .T.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER

	Restarea(aArea)
	n		:= nNAux
	aCols	:= aClone(aColsAux)
	aHeader	:= aClone(aHeadAux)
Return(lRet)