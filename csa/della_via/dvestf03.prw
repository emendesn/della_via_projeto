#Include "DellaVia.ch"

User Function DVESTF03()
	Private aRotina   := {}
	Private cCadastro := "Manutenção nos grupos de produtos"
	Private cAlias    := "SB1"

	aAdd(aRotina,{"Pesquisar"       ,"AxPesqui"    ,0,1})
	aAdd(aRotina,{"Visualizar"      ,"AxVisual"    ,0,2})
	aAdd(aRotina,{"Alterar Grupo"   ,"U_DVF03GRP()",0,4})

	mBrowse(,,,,cAlias)
Return nil

User Function DVF03GRP()
	Private nClose   := 0
	Private cGrupo   := SB1->B1_GRUPO
	Private cDescGrp := Posicione("SBM",1,xFilial("SBM")+cGrupo,"SBM->BM_DESC")

	DEFINE MSDIALOG oDlgGrp FROM 000,000 TO 100,700 TITLE "Alterar Grupo" Of oMainWnd PIXEL
	oPanel := TPanel():New(0,0,"",oDlgGrp, oDlgGrp:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 015,003 SCROLLBOX oScr01 SIZE 030,347 OF oDlgGrp
	@ 003,003 SAY "Código:"   PIXEL OF oScr01 SIZE 40,7
	@ 002,040 GET SB1->B1_COD PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 003,090 SAY "Descrição:" PIXEL OF oScr01 SIZE 40,7
	@ 002,140 GET SB1->B1_DESC PIXEL OF oScr01 SIZE 150,7 WHEN .F.

	@ 014,003 SAY "Grupo:" PIXEL OF oScr01 SIZE 40,7
	@ 013,040 GET cGrupo   PIXEL OF oScr01 SIZE 30,7 F3 "SBM" Valid !Empty(cGrupo) .AND. VldGrp()

	@ 014,090 SAY "Descrição:" PIXEL OF oScr01 SIZE 40,7
	@ 013,140 GET cDescGrp     PIXEL OF oScr01 SIZE 150,7 OBJECT oDescGrp READONLY

	oDlgGrp:lMaximized := .F.
	ACTIVATE MSDIALOG oDlgGrp CENTERED ON INIT EnchoiceBar(oDlgGrp,{|| nClose:=1,Close(oDlgGrp) },{|| nClose:=2,Close(oDlgGrp)},,)

	If nClose = 1
		If APMsgNoYes("Esta alteração será replicada para várias tabelas do sistema. Deseja realiza-la?","Alterar")
			GrvGrp()
		Endif
	Endif
Return nil

Static Function VldGrp()
	Local lRet := .T.

	lRet := ExistCpo("SBM",cGrupo,1)

	If lRet
		cDescGrp := Posicione("SBM",1,xFilial("SBM")+cGrupo,"SBM->BM_DESC")
	Else
		cDescGrp := ""
	Endif

	oDescGrp:cText(cDescGrp)
Return lRet

Static Function GrvGrp()
	Local cSql  := ""
	Local nUpdt := 0

	dbSelectArea("SB1")
	if RecLock("SB1",.F.)
		SB1->B1_GRUPO := cGrupo
		MsUnLock()
	Endif

	cSql := "UPDATE "+RetSqlName("SB4")
	cSql += " SET   B4_GRUPO = '"+cGrupo+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   B4_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   B4_COD = '"+SB1->B1_COD+"'"

	nUpdt := 0
	MsgRun("Atualizando Referencia do produto ...",,{|| nUpdt := TcSqlExec(cSql) })

	If nUpdt < 0
		MsgBox(TcSqlError(),"Grupo de produto","STOP")
	Endif



	cSql := "UPDATE "+RetSqlName("SC9")
	cSql += " SET   C9_GRUPO = '"+cGrupo+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   C9_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   C9_PRODUTO = '"+SB1->B1_COD+"'"

	nUpdt := 0
	MsgRun("Atualizando Liberação de produto ...",,{|| nUpdt := TcSqlExec(cSql) })

	If nUpdt < 0
		MsgBox(TcSqlError(),"Grupo de produto","STOP")
	Endif


	cSql := "UPDATE "+RetSqlName("SD1")
	cSql += " SET   D1_GRUPO = '"+cGrupo+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   D1_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   D1_COD = '"+SB1->B1_COD+"'"

	nUpdt := 0
	MsgRun("Atualizando Documentos de Entrada ...",,{|| nUpdt := TcSqlExec(cSql) })

	If nUpdt < 0
		MsgBox(TcSqlError(),"Grupo de produto","STOP")
	Endif


	cSql := "UPDATE "+RetSqlName("SD2")
	cSql += " SET   D2_GRUPO = '"+cGrupo+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   D2_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   D2_COD = '"+SB1->B1_COD+"'"

	nUpdt := 0
	MsgRun("Atualizando Documentos de Saida ...",,{|| nUpdt := TcSqlExec(cSql) })

	If nUpdt < 0
		MsgBox(TcSqlError(),"Grupo de produto","STOP")
	Endif


	cSql := "UPDATE "+RetSqlName("SD3")
	cSql += " SET   D3_GRUPO = '"+cGrupo+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   D3_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   D3_COD = '"+SB1->B1_COD+"'"

	nUpdt := 0
	MsgRun("Atualizando Movimentações Internas ...",,{|| nUpdt := TcSqlExec(cSql) })

	If nUpdt < 0
		MsgBox(TcSqlError(),"Grupo de produto","STOP")
	Endif
Return nil