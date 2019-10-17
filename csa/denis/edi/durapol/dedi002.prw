#Include "DellaVia.ch"

User Function DEDI002
	Private Titulo      := "EDI Vipal - Importação de notas fiscais"
	Private aSays       := {}
	Private aButtons    := {}
	Private lAbortPrint := .F.
	Private aEnvLog     := {}

	If SM0->M0_CODIGO <> "03"
		msgbox("Esta rotina só pode ser executada na Durapol","EDI","STOP")
		Return  nil
	Endif

	aAdd(aSays,"Esta rotina faz a importação das Notas fiscais da Vipal.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Import() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Import()
	Local   aDir        := {}
	Local   aPos        := {{},{}}
	Local   aEstru      := {}
	Private lMsErroAuto := .F.

	FechaBatch()
	
	aAdd(aPos[1],{"C_SERIE"  ,"C",002,005,0})
	aAdd(aPos[1],{"C_DOC"    ,"C",007,016,0})
	aAdd(aPos[1],{"C_NATUREZ","C",023,006,0})
	aAdd(aPos[1],{"C_EMISSAO","D",029,008,0})
	aAdd(aPos[1],{"C_MODFRE" ,"N",037,002,0})
	aAdd(aPos[1],{"C_PESO"   ,"N",039,014,4})
	aAdd(aPos[1],{"C_VALFRE" ,"N",053,013,2})
	aAdd(aPos[1],{"C_VALMERC","N",066,013,2})
	aAdd(aPos[1],{"C_VALTOT" ,"N",079,015,2})
	aAdd(aPos[1],{"C_OBS"    ,"C",094,2000,0})
	aAdd(aPos[1],{"C_TRANS"  ,"C",2094,012,0})


	aAdd(aPos[2],{"I_ITEM"   ,"C",002,016,0})
	aAdd(aPos[2],{"I_PCOMPRA","N",018,008,0})
	aAdd(aPos[2],{"I_QTDCLI" ,"N",026,014,4})
	aAdd(aPos[2],{"I_QTDFOR" ,"N",040,012,4})
	aAdd(aPos[2],{"I_TOTAL"  ,"N",052,012,2})
	aAdd(aPos[2],{"I_PESO"   ,"N",064,012,5})
	aAdd(aPos[2],{"I_LOTE"   ,"C",076,010,0})
	aAdd(aPos[2],{"I_VLDLOTE","D",086,008,0})
	aAdd(aPos[2],{"I_VALIPI" ,"N",094,012,2})
	aAdd(aPos[2],{"I_ALIQICM","N",106,005,2})
	aAdd(aPos[2],{"I_BASEICM","N",111,012,2})
	aAdd(aPos[2],{"I_VALICM" ,"N",123,012,2})
	aAdd(aPos[2],{"I_BCSUBS" ,"N",135,013,2})
	aAdd(aPos[2],{"I_VALSUBS","N",148,013,2})
	aAdd(aPos[2],{"I_SERIE"  ,"C",161,005,0})
	aAdd(aPos[2],{"I_DOC"    ,"C",166,016,0})

	aEstru := {}
	aAdd(aEstru,{"T_CMP01"  ,"C",500,0})
	aAdd(aEstru,{"T_CMP02"  ,"C",500,0})
	aAdd(aEstru,{"T_CMP03"  ,"C",500,0})
	aAdd(aEstru,{"T_CMP04"  ,"C",500,0})
	aAdd(aEstru,{"T_CMP05"  ,"C",500,0})

	cTmp01 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cTmp01,"BUFFER",.F.,.F.)


	aEstru := {}
	aAdd(aEstru,{"C_FILIAL" ,"C", 002,0})
	aAdd(aEstru,{"C_SERIE"  ,"C", 005,0})
	aAdd(aEstru,{"C_DOC"    ,"C", 016,0})
	aAdd(aEstru,{"C_FORNECE","C", 006,0})
	aAdd(aEstru,{"C_LOJA"   ,"C", 002,0})
	aAdd(aEstru,{"C_NATUREZ","C", 006,0})
	aAdd(aEstru,{"C_EMISSAO","D", 008,0})
	aAdd(aEstru,{"C_MODFRE" ,"N", 002,0})
	aAdd(aEstru,{"C_PESO"   ,"N", 014,4})
	aAdd(aEstru,{"C_VALFRE" ,"N", 013,2})
	aAdd(aEstru,{"C_VALMERC","N", 013,2})
	aAdd(aEstru,{"C_VALTOT" ,"N", 015,2})
	aAdd(aEstru,{"C_OBS"    ,"C",2000,2})
	aAdd(aEstru,{"C_TRANS"  ,"C", 012,0})
	aAdd(aEstru,{"C_ITENS"  ,"N", 003,0})
	aAdd(aEstru,{"X_LINHA"  ,"N", 006,0})
	aAdd(aEstru,{"X_ARQ"    ,"C", 015,0})
	cTmp02 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cTmp02,"CABEC",.F.,.F.)
	IndRegua("CABEC",cTmp02,"C_SERIE+C_DOC",,.t.,"Selecionando Registros...")


	aEstru := {}
	aAdd(aEstru,{"I_FILIAL" ,"C",002,0})
	aAdd(aEstru,{"I_ITEM"   ,"C",016,0})
	aAdd(aEstru,{"I_COD"    ,"C",015,0})
	aAdd(aEstru,{"I_PCOMPRA","N",008,0})
	aAdd(aEstru,{"I_QTDCLI" ,"N",014,4})
	aAdd(aEstru,{"I_QTDFOR" ,"N",012,4})
	aAdd(aEstru,{"I_TOTAL"  ,"N",012,2})
	aAdd(aEstru,{"I_PESO"   ,"N",012,5})
	aAdd(aEstru,{"I_LOTE"   ,"C",010,0})
	aAdd(aEstru,{"I_VLDLOTE","D",008,0})
	aAdd(aEstru,{"I_VALIPI" ,"N",012,2})
	aAdd(aEstru,{"I_ALIQICM","N",005,2})
	aAdd(aEstru,{"I_BASEICM","N",012,2})
	aAdd(aEstru,{"I_VALICM" ,"N",012,2})
	aAdd(aEstru,{"I_BCSUBS" ,"N",013,2})
	aAdd(aEstru,{"I_VALSUBS","N",013,2})
	aAdd(aEstru,{"I_SERIE"  ,"C",005,0})
	aAdd(aEstru,{"I_DOC"    ,"C",016,0})
	aAdd(aEstru,{"I_FORNECE","C",006,0})
	aAdd(aEstru,{"I_LOJA"   ,"C",002,0})
	aAdd(aEstru,{"X_LINHA"  ,"N",006,0})
	aAdd(aEstru,{"X_ARQ"    ,"C",015,0})
	cTmp03 := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cTmp03,"ITENS",.F.,.F.)
	IndRegua("ITENS",cTmp03,"I_SERIE+I_DOC",,.t.,"Selecionando Registros...")


	aDir := Directory("\SYSTEM\IMPORT\NF-*.TXT")


	For k=1 to Len(aDir)
		cFile := "\SYSTEM\IMPORT\"+aDir[k,1]
		If !File(cFile)
			msgbox("Ocorreu um erro na abertura do "+aDir[k,1],"Importação","STOP")
			aAdd(aEnvLog,{1,"Ocorreu um erro na abertura do ",0,aDir[k,1]})
			Loop
		Endif
		dbSelectArea("BUFFER")
		Append From &cFile SDF
		ProcRegua(LastRec())
		dbGoTop()
		
		Do While !eof()
			incProc("Carregando arquivo "+aDir[k,1])
			cBuffer := T_CMP01+T_CMP02+T_CMP03+T_CMP04+T_CMP05
			nTpReg  := Val(Substr(cBuffer,1,1))
			If nTpReg = 0
				dbSelectArea("SA2")
				dbSetOrder(3)
				dbSeek(xFilial("SA2")+AllTrim(Substr(cBuffer,2,20)))
				cCodFor := A2_COD
				cLojFor := A2_LOJA

				dbSelectArea("SM0")
				nRec := Recno()
				cEmp := M0_CODIGO
				Do While !eof() .AND. M0_CODIGO = cEmp
					If Alltrim(M0_CGC) = AllTrim(Substr(cBuffer,22,20))
						cCodFil := M0_CODFIL
					Endif
					dbSkip()
				Enddo

				dbSelectArea("BUFFER")
				dbSkip()
				Loop
			Endif

			cAlias := iif(nTpReg = 1,"CABEC","ITENS")

			dbSelectArea(cAlias)
			If RecLock(cAlias,.T.)
				For j=1 to Len(aPos[nTpReg])
					cCpo := cAlias+"->"+aPos[nTpReg,j,1]
					uVal := Substr(cBuffer,aPos[nTpReg,j,3],aPos[nTpReg,j,4])
					If aPos[nTpReg,j,2] = "C"
						&cCpo := uVal
					Elseif aPos[nTpReg,j,2] = "D"
						&cCpo := ctod(Substr(uVal,1,2)+"/"+Substr(uVal,3,2)+"/"+Substr(uVal,5,4))
					Else
						&cCpo := Val(uVal)/(10^aPos[nTpReg,j,5])
					Endif
				Next
				If nTpReg = 2
					ITENS->I_DOC     := CABEC->C_DOC
					ITENS->I_SERIE   := CABEC->C_SERIE
					ITENS->I_FILIAL  := cCodFil
					ITENS->I_FORNECE := cCodFor
					ITENS->I_LOJA    := cLojFor

					cSql := "SELECT A5_PRODUTO FROM "+RetSqlName("SA5")
					cSql += " WHERE D_E_L_E_T_ = ''"
					cSql += " AND   A5_FILIAL = '"+xFilial("SA5")+"'"
					cSql += " AND   A5_FORNECE = '"+cCodFor+"'"
					cSql += " AND   A5_LOJA = '"+cLojFor+"'"
					cSql += " AND   A5_CODPRF = '"+AllTrim(ITENS->I_ITEM)+"'"
					dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
					dbSelectArea("ARQ_SQL")
					if !eof()
						ITENS->I_COD := ARQ_SQL->A5_PRODUTO
					Endif
					dbSelectArea("ARQ_SQL")
					dbCloseArea()
					dbSelectArea("ITENS")
				Else
					CABEC->C_FILIAL  := cCodFil
					CABEC->C_FORNECE := cCodFor
					CABEC->C_LOJA    := cLojFor
				Endif
				(cAlias)->X_LINHA := BUFFER->(Recno())
				(cAlias)->X_ARQ   := aDir[k,1]
				MsUnlock()
			Endif
			dbSelectArea("BUFFER")
			dbSkip()
		Enddo
		Zap
	Next k
	dbSelectArea("BUFFER")
	dbCloseArea()


	dbSelectArea("CABEC")
	ProcRegua(LastRec())
	dbGoTop()
	
	Do while !eof()
		incProc("Lançando Pre-nota " + Substr(CABEC->C_DOC,2,6))
		aCab := {}
		aItn := {}

		aAdd(aCab,{"F1_FILIAL"      ,CABEC->C_FILIAL          ,Nil})
		aAdd(aCab,{"F1_TIPO"        ,"N"                      ,Nil})
		aAdd(aCab,{"F1_FORMUL"      ,"S"                      ,Nil})
		aAdd(aCab,{"F1_DOC"         ,Substr(CABEC->C_DOC,2,6) ,Nil})
		aAdd(aCab,{"F1_SERIE"       ,CABEC->C_SERIE           ,Nil})
		aAdd(aCab,{"F1_EMISSAO"     ,CABEC->C_EMISSAO         ,Nil})
		aAdd(aCab,{"F1_FORNECE"     ,CABEC->C_FORNECE         ,Nil})
		aAdd(aCab,{"F1_LOJA"        ,CABEC->C_LOJA            ,Nil})
		aAdd(aCab,{"F1_ESPECIE"     ,"NF"                     ,Nil})
		aAdd(aCab,{"F1_DTDIGIT"     ,dDataBase                ,Nil})
		aAdd(aCab,{"F1_EST"         ,"SP"                     ,Nil}) 
		aAdd(aCab,{"F1_TIPODOC"     ,"10"                     ,Nil})
		aAdd(aCab,{"F1_PESOL"       ,CABEC->C_PESO            ,Nil})
		aAdd(aCab,{"F1_PESO"        ,CABEC->C_PESO            ,Nil})
		aAdd(aCab,{"F1_FOB_R"       ,CABEC->C_VALFRE          ,Nil})
		aAdd(aCab,{"F1_FRETE"       ,CABEC->C_VALFRE          ,Nil})
		aAdd(aCab,{"F1_VALMERC"     ,CABEC->C_VALMERC         ,Nil})
		aAdd(aCab,{"F1_VALBRUT"     ,CABEC->C_VALTOT          ,Nil})

		If CABEC->C_MODFRE = 1
			aAdd(aCab,{"F1_CIF"   ,CABEC->C_VALFRE            ,Nil})
		Elseif CABEC->C_MODFRE = 2
			aAdd(aCab,{"F1_FOB"   ,CABEC->C_VALFRE            ,Nil})
		Endif

		dbSelectArea("ITENS")
		dbSeek(CABEC->(C_SERIE+C_DOC))
		Do While !eof() .and. ITENS->I_DOC = CABEC->C_DOC .and. ITENS->I_SERIE = CABEC->C_SERIE
			If Empty(I_COD)
				aAdd(aEnvLog,{2,"Não foi encontrado codigo no Protheus para o produto "+allTrim(I_ITEM),X_LINHA,X_ARQ})
				dbSkip()
				Loop
			Endif

			aTmp:={}
			aAdd(aTmp,{"D1_FILIAL" ,ITENS->I_FILIAL          ,Nil})
			aAdd(aTmp,{"D1_DOC"    ,Substr(ITENS->I_DOC,2,6) ,NIL})
			aAdd(aTmp,{"D1_SERIE"  ,ITENS->I_SERIE           ,NIL})
			aAdd(aTmp,{"D1_FORNECE",ITENS->I_FORNECE         ,NIL})
			aAdd(aTmp,{"D1_LOJA"   ,ITENS->I_LOJA            ,NIL})
			aAdd(aTmp,{"D1_COD"    ,ITENS->I_COD             ,NIL})
			aAdd(aTmp,{"D1_QUANT"  ,ITENS->I_QTDFOR          ,NIL})
			aAdd(aTmp,{"D1_VUNIT"  ,ITENS->(I_TOTAL/I_QTDFOR),NIL})
			aAdd(aTmp,{"D1_TOTAL"  ,ITENS->(I_TOTAL/I_QTDFOR)*ITENS->I_QTDFOR,NIL})
			aAdd(aTmp,{"D1_PESO"   ,ITENS->I_PESO            ,NIL})
			aAdd(aTmp,{"D1_VALIPI" ,ITENS->I_VALIPI          ,NIL})
			aAdd(aTmp,{"D1_VALICM" ,ITENS->I_VALICM          ,NIL})
			aAdd(aTmp,{"D1_IPI"    ,0                        ,NIL})
			aAdd(aTmp,{"D1_PICM"   ,ITENS->I_ALIQICM         ,NIL})
			aAdd(aTmp,{"D1_BASEICM",ITENS->I_BASEICM         ,NIL})
			aAdd(aTmp,{"D1_ICMSRET",ITENS->I_VALSUBS         ,NIL})
			aAdd(aTmp,{"D1_BRICMS" ,ITENS->I_BCSUBS          ,NIL})
			aAdd(aItn,aClone(aTmp))
			dbSkip()
		Enddo

		if Len(aItn) > 0
			dbSelectArea("SF1")
			dbSetOrder(2)
			dbGoTop()
			dbSeek(CABEC->(C_FILIAL+C_FORNECE+C_LOJA)+Substr(CABEC->C_DOC,2,6))
			If !Found()
				cFilSystem := cFilAnt
				cFilAnt    := CABEC->C_FILIAL

				MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItn)

				cFilAnt := cFilSystem

				If lMsErroAuto
					MostraErro()
				Endif
			Else
				aAdd(aEnvLog,{1,"Ja existe uma nota fiscal com essa numeração "+Substr(CABEC->C_DOC,2,6),CABEC->X_LINHA,CABEC->X_ARQ})
			Endif
		Else
			aAdd(aEnvLog,{1,"Não existem itens válidos para a nota "+Substr(CABEC->C_DOC,2,6),CABEC->X_LINHA,CABEC->X_ARQ})
		Endif

		dbSelectArea("CABEC")
		dbSkip()
	Enddo


	dbSelectArea("CABEC")
	dbCloseArea()

	dbSelectArea("ITENS")
	dbCloseArea()
	
	fErase(cTmp01+GetDBExtension())
	fErase(cTmp01+OrdBagExt())

	fErase(cTmp02+GetDBExtension())
	fErase(cTmp02+OrdBagExt())

	fErase(cTmp03+GetDBExtension())
	fErase(cTmp03+OrdBagExt())
	
	/*
	If msgbox("Deseja imprimir o Log de importação","EDI","YESNO")
		U_DEDI003(aEnvLog,"EDI - Notas fiscais")
	Endif

	if paramlog
		U_DEDI004(aEnvLog,"EDI - Tabela de preços")
	Endif
	*/
Return nil