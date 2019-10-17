#Include "rwmake.ch"
#Include "topconn.ch"
#Define VK_F12 123

User Function DSEPUC03
	Private aRotina   := {}
	Private aCpos     := {}
	Private cCadastro := "Consulta SEPU"
	Private cNomTmp   := ""
	Private cNomSIX   := ""


	// Verifica usuário
	dbSelectArea("ZZ1")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("ZZ1")+__cUserID)
	If !Found() .OR. ZZ1->ZZ1_GRUPO <> "3"
		msgbox("Você não tem acesso a esta rotina.","SEPU","STOP")
		Return  nil
	Endif


	// Matriz de definição dos menus
	aAdd(aRotina,{"Pesquisar" ,"AxPesqui"     ,0,1}) // Pesquisar
	aAdd(aRotina,{"Visualizar","U_DSEPU03V()" ,0,2}) // Visualizar
	aAdd(aRotina,{"Parametros","U_DSEPU03A()" ,0,3}) // Parametros


	// Matriz de campos a serem exibidos no Browse
	aAdd(aCpos,{"Filial"     ,"C2_FILIAL" })
	aAdd(aCpos,{"Numero"     ,"C2_NUM"    })
	aAdd(aCpos,{"Item"       ,"C2_ITEM"   })
	aAdd(aCpos,{"Emissao"    ,"C2_EMISSAO"})
	aAdd(aCpos,{"Cliente"    ,"C2_XNREDUZ"})
	aAdd(aCpos,{"Produto"    ,"C2_PRODUTO"})
	aAdd(aCpos,{"Liberação"  ,"C2_XDATDIR"})
	aAdd(aCpos,{"Bonificação","C2_XVALAPR"})
	aAdd(aCpos,{""           ,"FIM"       })

	cPerg    := "DSEP03"
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Liberação       ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Liberação    ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Cliente         ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate o Cliente      ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","SA1","","","",""          })

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

	MsgRun("Consultando banco de dados...",,{ || AbreCom(.T.) })

	Set Key VK_F12 TO U_DSEPU03A()

	mBrowse(,,,,"TMP",aCpos) // Cria o browse
	Set Key VK_F12 TO

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	dbSelectArea("SIX")
	dbCloseArea()
	fErase(cNomSIX+GetDbExtension())
	fErase(cNomSIX+OrdBagExt())
	
	dbUseArea(.T.,,"SIX"+cEmpAnt+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+cEmpAnt+"0")
Return nil

Static Function AbreCom(lSIX)
	Local   cSql      := ""

	cSql := "SELECT C2_FILIAL"
	cSql += " ,     C2_NUM"
	cSql += " ,     C2_ITEM"
	cSql += " ,     C2_EMISSAO"
	cSql += " ,     C2_XNREDUZ"
	cSql += " ,     C2_PRODUTO"
	cSql += " ,     C2_XDATDIR"
	cSql += " ,     C2_XVALAPR"
	cSql += " ,     ' ' AS FIM"
	cSql += " FROM "+RetSqlName("SC2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   C2_X_DESEN LIKE '%EXA%'"
	cSql += " AND   C2_XDATDIR <> ''"
	cSql += " AND   C2_XDATDIR BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   C2_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " ORDER BY C2_NUM,C2_ITEM"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	TcSetField("ARQ_SQL","C2_EMISSAO","D")
	TcSetField("ARQ_SQL","C2_XDATDIR","D")
	TcSetField("ARQ_SQL","C2_XVALAPR","N",14,2)

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"C2_FILIAL+C2_NUM+C2_ITEM",,,"Selecionando Registros...")

	If lSIX
		dbSelectArea("SIX")
		aEstru := dbStruct()
		dbCloseArea()
		cNomSIX := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
		IndRegua("SIX",cNomSIX,"INDICE+ORDEM",,,"Selecionando Registros...")

		If RecLock("SIX",.T.)
			SIX->INDICE    := "TMP"
			SIX->ORDEM     := "1"
			SIX->CHAVE     := "C2_FILIAL+C2_NUM+C2_ITEM"
			SIX->DESCRICAO := "Filial + Coleta + Item"
			SIX->DESCSPA   := "Filial + Coleta + Item"
			SIX->DESCENG   := "Filial + Coleta + Item"
			SIX->PROPRI    := "U"
			SIX->F3        := ""
			SIX->NICKNAME  := ""
			SIX->SHOWPESQ  := "S"
			MsUnLock()
		Endif
	Endif
Return nil

User Function DSEPU03A()
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	MsgRun("Consultando banco de dados...",,{ || AbreCom(.F.) })
	dbSelectArea("TMP")
Return nil

User Function DSEPU03V()
	cFilSystem := cFilAnt

	dbSelectArea("SIX")
	dbCloseArea()
	dbUseArea(.T.,,"SIX"+cEmpAnt+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+cEmpAnt+"0")

	cFilAnt := TMP->C2_FILIAL

	U_DSEPUC02(.F.)

	cFilAnt := cFilSystem

	dbSelectArea("SIX")
	dbCloseArea()
	dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
	dbSetIndex(cNomSIX)
Return nil