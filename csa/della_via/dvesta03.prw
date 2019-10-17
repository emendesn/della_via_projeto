#Include "DellaVia.ch"
#Include "rwmake.ch"

User Function DVESTA03()
	Private aRotina   := {}
	Private aCores    := {}
	Private aCampos   := {}
	Private cCadastro := "Produtos Saida Rapida"
	Private cAlias    := "TMP"
	Private cMarca    := "X"
	Private cNomTmp   := ""
	Private cNomSix   := ""

	// Matriz de definição dos menus
	aAdd(aRotina,{"Pesquisar"       ,"AxPesqui"       ,0,1})
	aAdd(aRotina,{"Bloquear"        ,"U_DST03BLQ(.T.)",0,4})
	aAdd(aRotina,{"Desbloquear"     ,"U_DST03BLQ(.F.)",0,4})
	aAdd(aRotina,{"Marcar Todos"    ,"U_DST03ALL(.T.)",0,4})
	aAdd(aRotina,{"Desmarcar Todos" ,"U_DST03ALL(.F.)",0,4})
	aAdd(aRotina,{"Legenda"         ,"U_DST03LEG()"   ,0,4})

	aAdd(aCampos,{"B1_MARCA" ,,""         })
	aAdd(aCampos,{"B1_COD"   ,,"Código"   })
	aAdd(aCampos,{"B1_GRUPO" ,,"Grupo"    })
	aAdd(aCampos,{"B1_DESC"  ,,"Descrição"})

	// Matriz de definição de cores da legenda
	aadd(aCores,{"B1_MSBLQL $ ' 2'" ,"BR_VERDE"   })
	aadd(aCores,{"B1_MSBLQL = '1'"  ,"BR_VERMELHO"})

	dbSelectArea("SB1")
	dbSetOrder(1)
	
	AbreTmp()
	MarkBrow(cAlias,"B1_MARCA",,aCampos,,cMarca,"U_DST03ALL(.T.)",,,,"U_DST03MARK()",,,,aCores)

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	dbSelectArea("SIX")
	dbCloseArea()
	fErase(cNomSIX+GetDbExtension())
	fErase(cNomSIX+OrdBagExt())
	
	dbUseArea(.T.,,"SIX"+Substr(cNumEmp,1,2)+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+Substr(cNumEmp,1,2)+"0")
Return NIL

User Function DST03LEG()
	BrwLegEnda(cCadastro,"Legenda", {{"BR_VERDE"    ,"Liberado"   },;
									 {"BR_VERMELHO" ,"Bloqueado"  }} ) 
Return nil

User Function DST03ALL(lMarca)
	Local nRecNum := 0

	dbSelectArea("TMP")
	nRecNum := RecNo()
	dbGoTop()
	
	Do While !eof()
		If RecLock("TMP",.F.)
			TMP->B1_MARCA := iif(lMarca,cMarca,"")
			MsUnLock()
		Endif
		dbSkip()
	Enddo
	
	dbGoTo(nRecNum)

	MarkBRefresh()
Return nil

User Function DST03MARK()
	If RecLock("TMP",.F.)
		TMP->B1_MARCA := iif(IsMark("B1_MARCA",cMarca)," ",cMarca)
		MsUnLock()
	Endif
Return

Static Function AbreTmp()
	Local cSql := ""

	cSql := "SELECT B1_COD"
	cSql += " ,     B1_GRUPO"
	cSql += " ,     B1_DESC"
	cSql += " ,     B1_MSBLQL"
	cSql += " ,     ' ' AS B1_MARCA"
	cSql += " FROM "+RetSqlName("SB1")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND   B1_GRUPO IN('0081','0084')" // Grupos para saida rápida
	cSql += " ORDER BY B1_COD"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"B1_COD+B1_GRUPO",,,"Selecionando Registros...")

	dbSelectArea("SIX")
	aEstru := dbStruct()
	dbCloseArea()
	cNomSIX := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
	IndRegua("SIX",cNomSIX,"INDICE+ORDEM",,,"Selecionando Registros...")

	If RecLock("SIX",.T.)
		SIX->INDICE    := "TMP"
		SIX->ORDEM     := "1"
		SIX->CHAVE     := "B1_COD+B1_GRUPO"
		SIX->DESCRICAO := "Codigo + Grupo"
		SIX->DESCSPA   := ""
		SIX->DESCENG   := ""
		SIX->PROPRI    := "U"
		SIX->F3        := ""
		SIX->NICKNAME  := ""
		SIX->SHOWPESQ  := "S"
		MsUnLock()
	Endif
Return nil

User Function DST03BLQ(lBlq)
	MsgRun("Aguarde ...",,{|| BlqProd(lBlq)})
Return nil	

Static Function BlqProd(lBlq)
	Local nRecNum := 0

	dbSelectArea("TMP")
	nRecNum := RecNo()
	dbGoTop()
	
	Do While !eof()
		If B1_MARCA = cMarca
			If RecLock("TMP",.F.)
				TMP->B1_MSBLQL := iif(lBlq,"1","2")
				MsUnLock()
			Endif

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+TMP->B1_COD)
			If Found()
				If RecLock("SB1",.F.)
					SB1->B1_MSBLQL := TMP->B1_MSBLQL
					MsUnLock()
				Endif
			Endif
		Endif

		dbSelectArea("TMP")
		dbSkip()
	Enddo
	
	dbGoTo(nRecNum)

	MarkBRefresh()
Return nil