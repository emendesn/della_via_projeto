#Include "Dellavia.ch"

User Function DVTMKF03()
	Local   cTitulo   := "Transferencia de superior"
	Local   aCampos   := {}
	Private cNomSU7   := ""
	Private cRegional := ""
	Private cGetSup   := Space(6)
	Private cCodSup   := ""

	aCampos := {}
	aadd(aCampos,{"U7_POSTO" ,"Regional","@!"})
	aadd(aCampos,{"U7_COD"   ,"Codigo"  ,"@!"})
	aadd(aCampos,{"U7_NOME"  ,"Nome"    ,"@!"})
	aadd(aCampos,{"U7_CODSUP","Superior","@!"})
	
	dbSelectArea("SU7")
	dbSetOrder(4)
	dbGoTop()
	dbSeek(xFilial("SU7")+__cUserId)
	If !Found() .AND. !lVarejo .AND. !lRodas
		msgbox("Voce não pode acessar esta rotina, pois não esta cadastrado como operador","Descontos","STOP")
		Return nil
	Endif
	cRegional := U7_POSTO
	cCodSup   := GetSup()

	AbreSU7()

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 250,500 PIXEL
		@ 005,005 Say "Operador:" Pixel
		@ 004,035 Get cGetSup PIXEL SIZE Len(cGetSup)*5,7 Pixel Valid !Empty(cGetSup) .AND. VLDCOD(cGetSup) F3 "SU7"
		@ 005,075 SAY "" Object oNome Pixel SIZE 100,20

		@ 020,005 TO 100,240 BROWSE "SU7" Object oBrw FIELDS aCampos

		DEFINE SBUTTON FROM 110,183 TYPE 1 ACTION MsgRun("Transferindo regional ...",,{|| Gravar() }) ENABLE OF oDlg
		DEFINE SBUTTON FROM 110,213 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER

	dbSelectArea("SU7")
	dbCloseArea()
	fErase(cNomSU7+GetDbExtension())
	fErase(cNomSU7+OrdBagExt())
	ChkFile("SU7")
Return nil

Static Function AbreSU7
	Local cSql   := ""
	Local aEstru := {}
	Local aIndex := {}
	Local k      := 0

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("SU7")
	
	Do While !eof() .AND. X3_ARQUIVO = "SU7"
		IF X3_CONTEXT <> "V"
			aadd(aEstru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		Endif
		dbSkip()
	Enddo

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("SU7")

	Do While !eof() .AND. INDICE = "SU7"
		aadd(aIndex,{INDICE+ORDEM,AllTrim(CHAVE)})
		dbSkip()
	Enddo

	dbSelectArea("SU7")
	dbCloseArea()

	if !Empty(cNomSU7)
		fErase(cNomSU7+GetDbExtension())
		fErase(cNomSU7+OrdBagExt())
	Endif

	cSql := "SELECT "
	For k=1 to Len(aEstru)
		cSql += AllTrim(aEstru[k,1])+iif(k < Len(aEstru),",","")
	Next
	cSql += " FROM "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SU7.D_E_L_E_T_ = ''"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_POSTO = '"+cRegional+"'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SU7", .T., .T.)
	dbSelectArea("ARQ_SU7")

	For k=1 to Len(aEstru)
		if aEstru[k,2] <> "C"
			TcSetField("ARQ_SU7",aEstru[k,1],aEstru[k,2],aEstru[k,3],aEstru[k,4])
		Endif
	Next k

	cNomSU7 := CriaTrab(,.F.)
	Copy to &cNomSU7
	dbCloseArea()
	dbUseArea(.T.,,cNomSU7,"SU7",.F.,.F.)
	
	For k=1 to Len(aIndex)
		Index on &aIndex[k,2] TAG &aIndex[k,1] TO &cNomSU7
	Next k
Return nil

Static Function VldCod(cVar)
	Local lRet := .F.
	oNome:cCaption := Substr(Posicione("SU7",1,xFilial("SU7")+cVar,"SU7->U7_NOME"),1,30)
	lRet := ExistCpo("SU7",cVar,1)
Return lRet

Static Function Gravar()
	Local cSql  := ""
	Local nUpdt := 0

	cSql := "UPDATE "+RetSqlName("SU7")
	cSql += " SET   U7_CODSUP = '"+cGetSup+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_POSTO = '"+cRegional+"'"
	nUpdt := TcSqlExec(cSql)

	If nUpdt < 0
		MsgBox(TcSqlError(),"Erro ...","STOP")
	Endif


	cSql := "UPDATE "+RetSqlName("SU7")
	cSql += " SET   U7_CODSUP = '"+cCodSup+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = '"+cGetSup+"'"
	nUpdt := TcSqlExec(cSql)

	If nUpdt < 0
		MsgBox(TcSqlError(),"Erro ...","STOP")
	Endif

	AbreSU7()
Return nil

Static Function GetSup()
	Local aArea := GetArea()
	Local cRet  := ""
	Local cSql  := ""

	cSql := "SELECT U7_CODSUP,COUNT(U7_CODSUP) AS QTD FROM "+RetSqlName("SU7")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_POSTO = '"+cRegional+"'"
	cSql += " GROUP BY U7_CODSUP"
	cSql += " ORDER BY QTD"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	If !Eof()
		cRet := U7_CODSUP
	Endif
	dbCloseArea()

	RestArea(aArea)
Return cRet