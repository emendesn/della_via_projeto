#Include "Dellavia.ch"

User Function DVEDI04
	Private Titulo      := "EDI Interchange - Baixas Débito"
	Private aSays       := {}
	Private aButtons    := {}
	Private lAbortPrint := .F.
	Private aEnvLog     := {}
	Private cNomRel     := ""
	Private cNomBx      := ""
	Private cCaminho    := "O:\Applications\Shared\EDI\Interchange\"

	If SM0->M0_CODIGO <> "01"
		msgbox("Esta rotina só pode ser executada na DellaVia","EDI","STOP")
		Return  nil
	Endif

	aAdd(aSays,"Esta rotina efetua as baixas dos titulos gerados pelas vendas nos cartões de débito.")
	aAdd(aSays,"Redeshop / Maestro")


	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Import() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)

	If Select("RELATO") > 0
		If RELATO->(RecCount()) > 0
			ImpRelato()
		Endif

		dbSelectArea("RELATO")
		dbCloseArea()
		fErase(cNomRel+GetDBExtension())
	Endif

	If Select("BAIXAS") > 0
		If BAIXAS->(RecCount()) > 0
			ImpBaixas()
		Endif

		dbSelectArea("BAIXAS")
		dbCloseArea()
		fErase(cNomBx+GetDBExtension())
	Endif
Return nil

Static Function Import()
	Local   aDir   := {}
	Local   cChk   := Space(3)
	Local   aEstru := {}
	Private cFile  := ""
	Private cArq   := ""
	Private nLidos := 0
	Private nEOF   := 0
	Private nHdl

	FechaBatch()

	If Select("RELATO") <= 0
		aAdd(aEstru,{"I_DOCTEF"  ,"C",009,0})
		aAdd(aEstru,{"I_BAIXA"   ,"D",008,0})
		aAdd(aEstru,{"I_DATA"    ,"D",008,0})
		aAdd(aEstru,{"I_VALOR"   ,"N",014,2})
		aAdd(aEstru,{"I_TIPO"    ,"C",002,0})
		aAdd(aEstru,{"I_ARQ"     ,"C",015,0})

		cNomRel := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomRel,"RELATO",.F.,.F.)
	Endif

	If Select("BAIXAS") <= 0
		aAdd(aEstru,{"B_PREFIXO" ,"C",003,0})
		aAdd(aEstru,{"B_NUM"     ,"C",006,0})
		aAdd(aEstru,{"B_PARCELA" ,"C",001,0})
		aAdd(aEstru,{"B_TIPO"    ,"C",002,0})
		aAdd(aEstru,{"B_DATA"    ,"D",008,0})
		aAdd(aEstru,{"B_BAIXA"   ,"D",008,0})
		aAdd(aEstru,{"B_VALOR"   ,"N",014,2})
		aAdd(aEstru,{"B_SALDO"   ,"N",014,2})
		aAdd(aEstru,{"B_ARQ"     ,"C",015,0})
		aAdd(aEstru,{"B_DOCTEF"  ,"C",009,0})

		cNomBx := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomBx,"BAIXAS",.F.,.F.)
	Endif


	aDir := Directory(cCaminho+"*.*")

	ProcRegua(Len(aDir))

	For k=1 to Len(aDir)
		cFile := cCaminho+aDir[k,1]
		cArq := aDir[k,1]
		nHdl := fOpen(cFile,0)

		If fError() != 0
			msgbox("Ocorreu um erro na abertura do arquivo "+cFile,"Importação","STOP")
			Loop
		Endif

		fRead(nHdl,@cChk,Len(cChk))

		IncProc(AllTrim(cArq))

		Do Case
			Case cChk = "00,"
				Debito()
			Case cChk = "030"
			Case cChk = "002"
				//GravaRV()
		EndCase

		If !fClose(nHdl)
			msgbox("Ocorreu um erro ao fechar o arquivo "+cFile,"Importação","STOP")
		EndIf
	Next k
Return nil

Static Function Debito()
	Local   aEstru      := {}
	Local   aDados      := {}
	Local   cSql        := ""
	Private lMsErroAuto := .F.
	
	aEstru := {}
	aAdd(aEstru,{"T_TXT"  ,"C",1024,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"ARQ",.F.,.F.)
	dbSelectArea("ARQ")
    Append From &cFile SDF
	DELETE FOR Substr(T_TXT,1,3) <> "05,"
	Pack


	aEstru := {}
	aAdd(aEstru,{"T_CPO01"  ,"C",002,0})
	aAdd(aEstru,{"T_CPO02"  ,"C",009,0})
	aAdd(aEstru,{"T_CPO03"  ,"C",009,0})
	aAdd(aEstru,{"T_CPO04"  ,"C",008,0})
	aAdd(aEstru,{"T_CPO05"  ,"C",015,0})
	aAdd(aEstru,{"T_CPO06"  ,"C",015,0})
	aAdd(aEstru,{"T_CPO07"  ,"C",015,0})
	aAdd(aEstru,{"T_CPO08"  ,"C",019,0})
	aAdd(aEstru,{"T_CPO09"  ,"C",001,0})
	aAdd(aEstru,{"T_CPO10"  ,"C",012,0})
	aAdd(aEstru,{"T_CPO11"  ,"C",008,0})
	aAdd(aEstru,{"T_CPO12"  ,"C",002,0})
	aAdd(aEstru,{"T_CPO13"  ,"C",006,0})
	aAdd(aEstru,{"T_CPO14"  ,"C",008,0})
	aAdd(aEstru,{"T_CPO15"  ,"C",002,0})
	aAdd(aEstru,{"T_CPO16"  ,"C",005,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"BUFFER",.F.,.F.)


	dbSelectArea("ARQ")
	ProcRegua(LastRec())
	dbGoTop()

	Do While !Eof()
		incProc(cFile)
		aCampos := Virgula(ARQ->T_TXT)

		If RecLock("BUFFER",.T.)
			nMax := fCount()
			For j=1 to Len(aCampos)
				if j <= nMax
					FieldPut(j,aCampos[j])
				Endif
			Next j
			MsUnLock()
		Endif

		dbSelectArea("ARQ")
		dbSkip()
	Enddo
	dbCloseArea()

	dbSelectArea("BUFFER")
	ProcRegua(LastRec())
	dbGoTop()

	Do While !Eof()
		incProc("Efetuando baixas ...")

		cSql := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
		cSql += " FROM "+RetSqlName("SL4")+" SL4"

		cSql += " JOIN  "+RetSqlName("SL1")+" SL1"
		cSql += " ON    SL1.D_E_L_E_T_ = ''"
		cSql += " AND   L1_FILIAL = L4_FILIAL"
		cSql += " AND   L1_NUM = L4_NUM"

		cSql += " JOIN "+RetSqlName("SE1")+" SE1"
		cSql += " ON    SE1.D_E_L_E_T_ = ''"
		cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
		cSql += " AND   E1_PREFIXO = L1_SERIE"
		cSql += " AND   E1_NUM = L1_DOC"
		cSql += " AND   E1_TIPO = L4_FORMA"
		cSql += " AND   E1_PARCELA = CHR(64 + INTEGER(L4_SEQ))"

		cSql += " WHERE SL4.D_E_L_E_T_ = ''"
		cSql += " AND   L4_FILIAL BETWEEN '' AND 'ZZ'"
		cSql += " AND   L4_DOCTEF = '"+Substr(T_CPO10,4,09)+"'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		dbSelectArea("ARQ_SQL")


		If !Eof()
			dbSelectArea("SE1")
			dbSetOrder(1)
			dbSeek(ARQ_SQL->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))

			dbSelectArea("SAE")
			dbSetOrder(1)
			dbSeek(xFilial("SE1")+Substr(SE1->E1_CLIENTE,1,3))

			dbSelectArea("SE1")
			aDados := {}
			aAdd( aDados, { "E1_PREFIXO" ,SE1->E1_PREFIXO                                                                           ,NIL })
			aAdd( aDados, { "E1_NUM"     ,SE1->E1_NUM                                                                               ,NIL })
			aAdd( aDados, { "E1_PARCELA" ,SE1->E1_PARCELA                                                                           ,NIL })
			aAdd( aDados, { "E1_CLIENTE" ,SE1->E1_CLIENTE                                                                           ,NIL })
			aAdd( aDados, { "E1_TIPO"    ,SE1->E1_TIPO                                                                              ,NIL })
			aAdd( aDados, { "E1_LOJA"    ,SE1->E1_LOJA                                                                              ,NIL })
			aAdd( aDados, { "E1_TIPO"    ,SE1->E1_TIPO                                                                              ,NIL })

			aAdd( aDados, { "AUTMOTBX"   ,"NOR"                                                                                     ,NIL })
			aAdd( aDados, { "AUTBANCO"   ,SAE->AE_BANCO                                                                             ,NIL })
			aAdd( aDados, { "AUTAGENCIA" ,SAE->AE_AGENCIA                                                                           ,NIL })
			aAdd( aDados, { "AUTCONTA"   ,SAE->AE_CONTA                                                                             ,NIL })

			aAdd( aDados, { "AUTDTBAIXA" ,stod(Substr(BUFFER->T_CPO11,5,4)+Substr(BUFFER->T_CPO11,3,2)+Substr(BUFFER->T_CPO11,1,2)) ,NIL })
			aAdd( aDados, { "AUTHIST"    ,"BX REDECARD - ARQ: "+AllTrim(cArq)                                                       ,NIL })
			aAdd( aDados, { "AUTVALREC"  ,Val(Transform(BUFFER->T_CPO07,"@r 9999999999999.99"))                                     ,NIL })

			MsExecAuto( { |x,y| Fina070(x,y) } ,aDados,3)

			If lMsErroAuto
				MostraErro()
			EndIf

			dbSelectArea("BAIXAS")
			If RecLock("BAIXAS",.T.)
				BAIXAS->B_PREFIXO  := SE1->E1_PREFIXO
				BAIXAS->B_NUM      := SE1->E1_NUM
				BAIXAS->B_PARCELA  := SE1->E1_PARCELA
				BAIXAS->B_TIPO     := SE1->E1_TIPO
				BAIXAS->B_DATA     := SE1->E1_EMISSAO
				BAIXAS->B_BAIXA    := SE1->E1_BAIXA
				BAIXAS->B_VALOR    := SE1->E1_VALOR
				BAIXAS->B_SALDO    := SE1->E1_SALDO
				BAIXAS->B_ARQ      := cArq
				BAIXAS->B_DOCTEF   := Substr(BUFFER->T_CPO10,4,09)
				MsUnLock()
			Endif
		Else
			dbSelectArea("RELATO")
			If RecLock("RELATO",.T.)
				RELATO->I_DOCTEF := Substr(BUFFER->T_CPO10,3,09)
				RELATO->I_DATA   := stod(Substr(BUFFER->T_CPO04,5,4)+Substr(BUFFER->T_CPO04,3,2)+Substr(BUFFER->T_CPO04,1,2))
				RELATO->I_BAIXA  := stod(Substr(BUFFER->T_CPO11,5,4)+Substr(BUFFER->T_CPO11,3,2)+Substr(BUFFER->T_CPO11,1,2))
				RELATO->I_VALOR  := Val(Transform(BUFFER->T_CPO07,"@r 9999999999999.99"))
				RELATO->I_TIPO   := "CD"
				RELATO->I_ARQ    := cArq
				MsUnLock()
			Endif
		Endif
		dbSelectArea("ARQ_SQL")
		dbCloseArea()

		dbSelectArea("BUFFER")
		dbSkip()
	Enddo

	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
Return nil

Static Function Linha()
	Local cLinha := ""
	Local cTxt   := " "

	Do While Asc(cTxt) <> 13 .AND. nEOF > nLidos
		fRead(nHdl,@cTxt,1)
		IncProc(AllTrim(cFile))
		nLidos ++

		if Asc(cTxt) <> 13
			cLinha += cTxt
		Endif
	Enddo

	fRead(nHdl,@cTxt,1)
	nLidos ++
	IncProc(AllTrim(cFile))
Return cLinha

Static Function Virgula(cPar)
	Local aCampos := {}
	Local cTxt    := ""

	For i=1 To Len(cPar)
		If Substr(cPar,i,1) = ","
			aAdd(aCampos,cTxt)
			cTxt := ""
		Else
			cTxt += Substr(cPar,i,1)
		Endif
	Next i
	aAdd(aCampos,cTxt)
Return aCampos

Static Function ImpRelato()
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Imprime Log gerado por uma atualização via EDI"
	Private cDesc2         := ""
	Private cDesc3         := "Baixas não localizadas"
	Private tamanho        := "P"
	Private nomeprog       := "EDI04A"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := NIL
	Private titulo         := "Baixas não localizadas"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "EDI04A"

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa({|| RunRelato() },Titulo,,.t.)
Return nil

Static Function RunRelato()
	Cabec2:=""
	Cabec1:=" Comprovante   Compra     Baixa                  Valor   Tipo   Arquivo"
	        * XXXXXXXXX     99/99/99   99/99/99   99.999.999.999,99   XX     XXXXXXXXXXXXXXX
    	    *012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8


	dbSelectArea("RELATO")
	ProcRegua(LastRec())
	dbGoTop()

	Do While !eof()
		IncProc("Imprimindo ...")
		
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif
	
		@ LI,001 PSAY I_DOCTEF
		@ LI,015 PSAY I_DATA
		@ LI,026 PSAY I_BAIXA
		@ LI,037 PSAY I_VALOR Picture "@e 99,999,999,999.99"
		@ LI,057 PSAY I_TIPO
		@ LI,064 PSAY I_ARQ
		LI++
		dbSkip()
	Enddo

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

Static Function ImpBaixas()
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Imprime Log gerado por uma atualização via EDI"
	Private cDesc2         := ""
	Private cDesc3         := "Baixas realizadas"
	Private tamanho        := "M"
	Private nomeprog       := "EDI04B"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := NIL
	Private titulo         := "Baixas realizadas"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "EDI04B"

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa({|| RunBaixas() },Titulo,,.t.)
Return nil


Static Function RunBaixas()
	Cabec2:=""
	Cabec1:=" Prefixo   Numero   Parcela   Tipo   Emissão    Baixa                  Valor               Saldo   Arq               Comprovante"
	        * XXX       XXXXXX   X         XX     99/99/99   99/99/99   99,999,999,999.99   99,999,999,999.99   XXXXXXXXXXXXXXX   XXXXXXXXX
    	    *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13


	dbSelectArea("Baixas")
	ProcRegua(LastRec())
	dbGoTop()

	Do While !eof()
		IncProc("Imprimindo ...")
		
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif
	
		@ LI,001 PSAY B_PREFIXO
		@ LI,011 PSAY B_NUM
		@ LI,020 PSAY B_PARCELA
		@ LI,030 PSAY B_TIPO
		@ LI,037 PSAY B_DATA
		@ LI,048 PSAY B_BAIXA
		@ LI,059 PSAY B_VALOR Picture "@e 99,999,999,999.99"
		@ LI,079 PSAY B_SALDO Picture "@e 99,999,999,999.99"
		@ LI,099 PSAY B_ARQ
		@ LI,117 PSAY B_DOCTEF
		LI++
		dbSkip()
	Enddo

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

Static Function GravaRV()
	Local   aEstru      := {}
	Local   cBuffer     := ""
	Local   cSql        := ""

	aAdd(aEstru,{"T_TXT"  ,"C",1024,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"BUFFER",.F.,.F.)
	dbSelectArea("BUFFER")
    Append From &cFile SDF
	DELETE FOR !(Substr(T_TXT,1,3) $ "008*012")
	Pack

	ProcRegua(LastRec())
	dbGoTop()

	Do While !Eof()
		incProc("Gravando RV ...")

		cSql := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
		cSql += " FROM "+RetSqlName("SL4")+" SL4"

		cSql += " JOIN  "+RetSqlName("SL1")+" SL1"
		cSql += " ON    SL1.D_E_L_E_T_ = ''"
		cSql += " AND   L1_FILIAL = L4_FILIAL"
		cSql += " AND   L1_NUM = L4_NUM"

		cSql += " JOIN "+RetSqlName("SE1")+" SE1"
		cSql += " ON    SE1.D_E_L_E_T_ = ''"
		cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
		cSql += " AND   E1_PREFIXO = L1_SERIE"
		cSql += " AND   E1_NUM = L1_DOC"
		cSql += " AND   E1_TIPO = L4_FORMA"
		cSql += " AND   E1_PARCELA = CHR(64 + INTEGER(L4_SEQ))"
		cSql += " WHERE SL4.D_E_L_E_T_ = ''"
		cSql += " AND   L4_FILIAL BETWEEN '' AND 'ZZ'"
		If Substr(T_TXT,1,3) = "008"
			cSql += " AND   L4_DOCTEF = '"+Substr(T_TXT,90,09)+"'"
		Else
			cSql += " AND   L4_DOCTEF = '"+Substr(T_TXT,92,09)+"'"
			cSql += " ORDER BY E1_PARCELA"
		Endif
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		dbSelectArea("ARQ_SQL")

		lAchou := !Eof()

		If Substr(BUFFER->T_TXT,1,3) = "008"
			If lAchou
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbSeek(ARQ_SQL->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))

				If RecLock("SE1",.F.)
					SE1->E1_RVTEF   := Substr(BUFFER->T_TXT,13,09)
					SE1->E1_PARCTEF := "01"
					MsUnlock()
				Endif

				dbSelectArea("BAIXAS")
				If RecLock("BAIXAS",.T.)
					BAIXAS->B_PREFIXO  := SE1->E1_PREFIXO
					BAIXAS->B_NUM      := SE1->E1_NUM
					BAIXAS->B_PARCELA  := SE1->E1_PARCELA
					BAIXAS->B_TIPO     := "RV"
					BAIXAS->B_DATA     := SE1->E1_EMISSAO
					BAIXAS->B_BAIXA    := SE1->E1_BAIXA
					BAIXAS->B_VALOR    := SE1->E1_VALOR
					BAIXAS->B_SALDO    := SE1->E1_SALDO
					BAIXAS->B_ARQ      := cArq
					BAIXAS->B_DOCTEF   := Substr(BUFFER->T_TXT,90,09)
					MsUnLock()
				Endif
			Endif
		Else
			nParcela := 0
			Do While lAchou .and. !eof()
				nParcela ++

				dbSelectArea("SE1")
				dbSetOrder(1)
				dbSeek(ARQ_SQL->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))

				If RecLock("SE1",.F.)
					SE1->E1_RVTEF   := Substr(BUFFER->T_TXT,13,09)
					SE1->E1_PARCTEF := StrZero(nParcela,2)
					MsUnlock()
				Endif

				dbSelectArea("BAIXAS")
				If RecLock("BAIXAS",.T.)
					BAIXAS->B_PREFIXO  := SE1->E1_PREFIXO
					BAIXAS->B_NUM      := SE1->E1_NUM
					BAIXAS->B_PARCELA  := SE1->E1_PARCELA
					BAIXAS->B_TIPO     := "RV"
					BAIXAS->B_DATA     := SE1->E1_EMISSAO
					BAIXAS->B_BAIXA    := SE1->E1_BAIXA
					BAIXAS->B_VALOR    := SE1->E1_VALOR
					BAIXAS->B_SALDO    := SE1->E1_SALDO
					BAIXAS->B_ARQ      := cArq
					BAIXAS->B_DOCTEF   := Substr(BUFFER->T_TXT,92,09)
					MsUnLock()
				Endif

				dbSelectArea("ARQ_SQL")
				dbSkip()
			Enddo
		Endif


		If !lAchou
			dbSelectArea("RELATO")
			If RecLock("RELATO",.T.)
				if Substr(BUFFER->T_TXT,1,3) = "008"
					RELATO->I_DOCTEF := Substr(BUFFER->T_TXT,90,09)
					RELATO->I_DATA   := stod(Substr(BUFFER->T_TXT,26,4)+Substr(BUFFER->T_TXT,24,2)+Substr(BUFFER->T_TXT,22,2))
					RELATO->I_VALOR  := Val(Transform(Substr(BUFFER->T_TXT,38,15),"@r 9999999999999.99"))
				Else
					RELATO->I_DOCTEF := Substr(BUFFER->T_TXT,92,09)
					RELATO->I_DATA   := stod(Substr(BUFFER->T_TXT,26,4)+Substr(BUFFER->T_TXT,24,2)+Substr(BUFFER->T_TXT,22,2))
					RELATO->I_VALOR  := Val(Transform(Substr(BUFFER->T_TXT,206,15),"@r 9999999999999.99"))
				Endif
				RELATO->I_TIPO   := "RV"
				RELATO->I_ARQ    := cArq
				MsUnLock()
			Endif
		Endif

		dbSelectArea("ARQ_SQL")
		dbCloseArea()

		dbSelectArea("BUFFER")
		dbSkip()
	Enddo

	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
Return nil