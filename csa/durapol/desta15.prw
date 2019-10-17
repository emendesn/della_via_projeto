#Include "Dellavia.ch"
#Define VK_F12 123   

User Function DESTA15
	Private aRotina    := {}
	Private aCores     := {}
	Private cCadastro  := "Consulta OPs CQ"
	Private cAliasCab  := "SC2"
	Private cAlias     := "SC2"
	Private cNomSIX    := ""
	Private cNomTmp    := ""
	Private aSetField  := {}
	Private cCamposSql := ""
	Private cFiltro    := ""
	Private cPerg      := "DSTA15"

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""         ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""         ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Mostra Op's        ?"," "," ","mv_ch3","N", 01,0,0,"C","","mv_par03","Todas"  ,"","","","","Liberadas","","","","","Rejeitadas","","","","",""          ,"","","","","","","","","   ","","","",""          })

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif

	// Matriz de definição dos menus
	aAdd(aRotina,{"Pesquisar" ,"AxPesqui"  ,0,1})
	aAdd(aRotina,{"Visualizar","A650View"  ,0,2})
	aAdd(aRotina,{"Parametros","U_DESTA15P",0,2})
	aAdd(aRotina,{"Legenda"   ,"U_DESTA15L",0,2})

	Aadd(aCores,{"SC2->C2_X_STATU = '9'" ,"BR_VERMELHO"}) // Rejeitado
	Aadd(aCores,{"SC2->C2_X_STATU = '6'" ,"BR_VERDE"   }) // Liberado


	Set Key VK_F12 TO U_DESTA15P()
	AbreDic()
	MsgRun("Consultando banco de dados...",,{ || AbreTmp(.T.) })
	mBrowse(,,,,cAliasCab,,,,,,aCores) // Cria o browse
	Set Key VK_F12 TO


	// Fecha Temporários
	dbSelectArea(cAliasCab)
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	ChkFile("SC2")
Return nil

Static Function AbreDic()
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	Do While !eof() .and. X3_ARQUIVO = cAlias
		if X3_CONTEXT <> "V"
			cCamposSql += iif(!Empty(cCamposSql),",","")+AllTrim(X3_CAMPO)
			if X3_TIPO $ "N*D"
				aAdd(aSetField,{AllTrim(X3_CAMPO),X3_TIPO,X3_TAMANHO,X3_DECIMAL})
			Endif
		Endif
		dbSkip()
	Enddo
Return nil


Static Function AbreTmp(lSIX)
	Local cSql    := ""
	Local k       := 0

	Default lSix  := .F.

	cSql := "SELECT "+cCamposSql
	cSql += " FROM   "+RetSqlName("SC2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
	cSql += " AND   C2_XDTCLAV <> ''"
	cSql += " AND   C2_XDTCLAV BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	If mv_par03 = 1
		cSql += " AND   C2_X_STATU IN('6','9')"
	Elseif mv_par03 = 2
		cSql += " AND   C2_X_STATU = '6'"
	Elseif mv_par03 = 3
		cSql += " AND   C2_X_STATU = '9'"
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")

	For k=1 to Len(aSetField)
		TcSetField("ARQ_SQL",aSetField[k,1],aSetField[k,2],aSetField[k,3],aSetField[k,4])
	Next k

	if !Empty(cNomTmp)
		dbSelectArea(cAliasCab)
		dbCloseArea()
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
		dbSelectArea("ARQ_SQL")
	Endif

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,cAliasCab,.F.,.F.)

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbSeek(cAlias)
	Do While !eof() .and. INDICE = cAlias
		cChave := AllTrim(CHAVE)
		cTag   := AllTrim(INDICE+ORDEM)

		dbSelectArea(cAliasCab)
		Index on &cChave TAG &cTag TO &cNomTmp

		dbSelectArea("SIX")
		dbSkip()
	Enddo
	dbSelectArea(cAlias)
	dbSetOrder(1)
Return nil

User Function DESTA15L()
	BrwLegenda("Legenda",cCadastro,{{"BR_VERDE"   ,"Liberada" },;
                	                {"BR_VERMELHO","Rejeitado"}})
Return Nil

User Function DESTA15P()
	if Pergunte(cPerg,.T.)
		MsgRun("Consultando banco de dados...",,{ || AbreTmp() })
	Endif
Return nil