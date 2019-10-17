#Include "Dellavia.ch"

User Function DESTV02(cParFilial,cParSerie,cParDoc,cParCond)
	Local   aArea     := GetArea()
	Local   aEstru    := {}
	Local   cSql      := ""
	Local   cAliasSql := ""
	Local   cAliasTMP := ""
	Local   cNomTmp   := ""
	Local   k         := 0
	Private aHeader   := {}
	Private aCols     := {}
	Private aAlter    := {}
	Private nOpc      := 2
	Private aRotina   := {}

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5}) 


	aadd(aEstru,{"ZZ6_CODIGO"   ,"C",03,0})
	aadd(aEstru,{"ZZ6_DESC"     ,"C",50,0})

	cAliasTMP := GetNextAlias()
	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,cAliasTMP,.F.,.F.)
	IndRegua(cAliasTmp,cNomTmp,"ZZ6_CODIGO",,.t.,"Selecionando Registros...")

	cSql := "SELECT ZZ6_CODIGO,ZZ7_DESC"
	cSql += " FROM "+RetSqlName("ZZ6")+" ZZ6"

	cSql += " JOIN "+RetSqlName("ZZ7")+" ZZ7"
	cSql += " ON   ZZ7.D_E_L_E_T_ = ''"
	cSql += " AND  ZZ7_FILIAL = '"+xFilial("ZZ7")+"'"
	cSql += " AND  ZZ7_CODIGO = ZZ6_CODIGO"

	If !Empty(cParCond)
		cSql += " AND  "+cParCond
	Endif

	cSql += " WHERE ZZ6.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ6_FILIAL = '"+cParFilial+"'"
	cSql += " AND   ZZ6_SERIE = '"+cParSerie+"'"
	cSql += " AND   ZZ6_NUM = '"+cParDoc+"'"
	cAliasSql := GetNextAlias()
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),cAliasSql, .T., .T.)
	dbSelectArea(cAliasSql)

	Do While !Eof()
		dbSelectArea(cAliasTMP)
		If RecLock(cAliasTMP,.T.)
			(cAliasTMP)->ZZ6_CODIGO := (cAliasSql)->ZZ6_CODIGO
			(cAliasTMP)->ZZ6_DESC   := (cAliasSql)->ZZ7_DESC
			MsUnLock()
		Endif
		aAdd(aCols,{ZZ6_CODIGO,ZZ6_DESC,.F.})

		dbSelectArea(cAliasSql)
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea(cAliasTMP)


	If !Eof()
		aAdd(aHeader,{"Codigo"   ,"ZZ6_CODIGO","@!",03,0,   ,,"C",,})
		aAdd(aHeader,{"Descrição","ZZ6_DESC"  ,"@!",50,0,   ,,"C",,})

		@ 000,000 TO 200,700 DIALOG oDlgMsg TITLE "Mensagens Pré-Coleta"
			oPanel := TPanel():New(0,0,"",oDlgMsg, oDlgMsg:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
			oPanel:Align := CONTROL_ALIGN_ALLCLIENT

			@ 015,003 SCROLLBOX oScr SIZE 080,347 OF oDlgMsg
			oGetDesc := MSGetDados():New(000,000,078,345,nOpc,"!Empty(aCols[n,1])",,,.T.,aAlter,,,,,,,,oScr)
		ACTIVATE DIALOG oDlgMsg CENTER ON INIT EnchoiceBar(oDlgMsg,{|| Close(oDlgMsg) },{|| Close(oDlgMsg) })

		dbSelectArea(cAliasTMP)
		dbCloseArea()
		fErase(cNomTmp+GetDBExtension())
		fErase(cNomTmp+OrdBagExt())

		For k=1 to Len(aCols)
			dbSelectArea("ZZ6")
			dbSetOrder(1)
			dbSeek(cParFilial+cParSerie+cParDoc+aCols[k,1])

			If Found()
				If Empty(ZZ6->ZZ6_USERVW)
					If RecLock("ZZ6",.F.)
						ZZ6->ZZ6_USERVW := Upper(AllTrim(cUserName))
						ZZ6->ZZ6_DATAVW := dDataBase
						ZZ6->ZZ6_HORAVW := Time()
						MsUnLock()
					Endif
				Endif
			Endif
		Next k
	Endif

	RestArea(aArea)
Return nil