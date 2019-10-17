#Include "DellaVia.ch"

User Function DEDI001
	Private Titulo      := "EDI Vipal - Importação de tabela de preços"
	Private aSays       := {}
	Private aButtons    := {}
	Private lAbortPrint := .F.
	Private aEnvLog     := {}

	If SM0->M0_CODIGO <> "03"
		msgbox("Esta rotina só pode ser executada na Durapol","EDI","STOP")
		Return  nil
	Endif

	aAdd(aSays,"Esta rotina atualiza a tabela de preço para compra de produtos Vipal.") 

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Import() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Import()
	Local aDir        := {}
	Local aPos        := {}
	Local aEstru      := {}
	Local cBuffer     := ""
	Local nEOF        := 0
	Local nTamLinha   := 169
	Local nBytesLidos := 0
	Local cEOL        := CHR(13)+CHR(10)

	FechaBatch()
	
	aadd(aPos,{"T_CPFORN","C",011,016,0})
	aadd(aPos,{"T_DATDE" ,"D",099,008,0})
	aadd(aPos,{"T_DATATE","D",107,008,0})
	aadd(aPos,{"T_PRECO" ,"N",142,014,5})

	aadd(aEstru,{"T_ARQ"    ,"C",15,0})
	aadd(aEstru,{"T_LINHA"  ,"N",06,0})
	aadd(aEstru,{"T_CODIGO" ,"C",15,0})
	aadd(aEstru,{"T_CPFORN" ,"C",16,0})
	aadd(aEstru,{"T_DATDE"  ,"D",08,0})
	aadd(aEstru,{"T_DATATE" ,"D",08,0})
	aadd(aEstru,{"T_PRECO"  ,"N",14,5})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)

	aDir := Directory("\SYSTEM\IMPORT\TP.TXT")

	For k=1 to Len(aDir)
		cFile := "\SYSTEM\IMPORT\"+aDir[k,1]
		nHdl := fOpen(cFile)
		If fError() != 0
			msgbox("Ocorreu um erro na abertura do "+aDir[k,1],"Importação","STOP")
			aAdd(aEnvLog,{1,"Ocorreu um erro na abertura do ",0,aDir[k,1]})
			Loop
		Endif
		nEOF := fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)

		ProcRegua(nEOF/(nTamLinha + Len(cEOL)))
	
		nLinha := 0
		Do While nEOF > nBytesLidos
			incProc("Carregando arquivo "+aDir[k,1])
			nBytesLidos += fRead(nHdl,@cBuffer,nTamLinha + Len(cEOL))

			nLinha++
			dbSelectArea("TMP")
			if RecLock("TMP",.T.)
				TMP->T_ARQ := aDir[k,1]
				TMP->T_LINHA := nLinha
				For j=1 to Len(aPos)
					cCpo := "TMP->"+aPos[j,1]
					uVal := Substr(cBuffer,aPos[j,3],aPos[j,4])
					If aPos[j,2] = "C"
						&cCpo := uVal
					Elseif aPos[j,2] = "D"
						&cCpo := ctod(Substr(uVal,1,2)+"/"+Substr(uVal,3,2)+"/"+Substr(uVal,5,4))
					Else
						&cCpo := Val(uVal)/(10^aPos[j,5])
					Endif
				Next
				MsUnLock()
			Endif
			dbSelectArea("SA5")
			dbSetOrder(5)
			dbSeek(xFilial("SA5")+TMP->T_CPFORN)
			If Found()
				dbSelectArea("TMP")
				If RecLock("TMP",.F.)
					TMP->T_CODIGO := SA5->A5_PRODUTO
					MsUnlock()
				Endif
			Else
				aAdd(aEnvLog,{1,"Não foi encontrado codigo no Protheus para o produto "+allTrim(TMP->T_CPFORN),TMP->T_LINHA,TMP->T_ARQ})
			Endif
		Enddo
		fClose(nHdl)
	Next k

	dbSelectArea("AIA")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("0100270701001")
	if !Found()
		aAdd(aEnvLog,{3,"Não não existia tabela de preço para este fornecedor, a mesma foi criada",0,TMP->T_ARQ})
		If RecLock("AIA",.T.)
			AIA->AIA_FILIAL := "01"
			AIA->AIA_CODFOR := "002707"
			AIA->AIA_LOJFOR := "01"
			AIA->AIA_CODTAB := "001"
			AIA->AIA_DESCRI := "VIPAL SAO PAULO"
			MsUnlock()
		Endif
	Endif

	If RecLock("AIA",.F.)
		AIA->AIA_DATDE  := TMP->T_DATDE
		AIA->AIA_DATATE := TMP->T_DATATE
		MsUnlock()
	Endif

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()
	
	Do While !eof()
		incProc("Atualizando a tabela de preços ...")

		If Empty(T_CODIGO)
			dbSkip()
			Loop
		Endif

		dbSelectArea("AIB")
		dbSetOrder(2)
		dbSeek("0100270701001"+TMP->T_CODIGO)
		If !Found()
			aAdd(aEnvLog,{3,"Não existia preço na tabela para o codigo "+Alltrim(TMP->T_CODIGO)+", o mesmo foi criado",TMP->T_LINHA,TMP->T_ARQ})
			If RecLock("AIB",.T.)
				AIB->AIB_FILIAL := "01"
				AIB->AIB_CODFOR := "002707"
				AIB->AIB_LOJFOR := "01"
				AIB->AIB_CODTAB := "001"
				AIB->AIB_ITEM   := PrxItem()
				AIB->AIB_CODPRO := TMP->T_CODIGO
				AIB->AIB_MOEDA  := 1
				AIB->AIB_QTDLOT := 999999.99
				MsUnlock()
			Endif
		Endif
		aAdd(aEnvLog,{3,Alltrim(TMP->T_CODIGO)+": Alterado o preço na tabela de "+AllTrim(Transform(AIB->AIB_PRCCOM,"@e 999,999.99"))+" para "+AllTrim(Transform(TMP->T_PRECO,"@e 999,999.99")),TMP->T_LINHA,TMP->T_ARQ})
		If RecLock("AIB",.F.)
			AIB->AIB_PRCCOM := TMP->T_PRECO
			AIB->AIB_DATVIG := TMP->T_DATATE
			MsUnlock()
		Endif

		dbSelectArea("TMP")
		dbSkip()
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()

	fErase(cNomTmp+GetDBExtension())

	/*
	If msgbox("Deseja imprimir o Log de importação","EDI","YESNO")
		U_DEDI003(aEnvLog,"EDI - Tabela de preços")
	Endif

	if paramlog
		U_DEDI004(aEnvLog,"EDI - Tabela de preços")
	Endif

	*/
Return nil

Static Function PrxItem()
	Local aArea := GetArea()
	Local cRet := ""
	Local cSql := ""

	cSql := "SELECT INTEGER(MAX(AIB_ITEM)) AS NUM FROM "+RetSqlName("AIB")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   AIB_FILIAL = '01'"
	cSql += " AND   AIB_CODFOR = '002707'"
	cSql += " AND   AIB_LOJFOR = '01'"
	cSql += " AND   AIB_CODTAB = '001'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_ITN", .T., .T.)
	dbSelectArea("SQL_ITN")
	TcSetField("SQL_ITN","NUM","N",4,0)

	cRet := StrZero(NUM+1,4)
	dbCloseArea()
	RestArea(aArea)
Return cRet