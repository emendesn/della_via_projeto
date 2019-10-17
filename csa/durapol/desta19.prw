#Include "DellaVia.ch"
#Define VK_F12 123
#Define VK_F5  116

User Function DESTA19
	Local   aListaCpo := {}
	Private aButtons  := {}
	Private aRotina   := {}
	Private aCores    := {}
	Private aCpos     := {}
	Private cCadastro := "Cond. Especial Coleta"
	Private cNomTmp   := ""
	Private cPerg     := "DEST19"


	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Status             ?"," "," ","mv_ch1","C", 02,0,0,"G","U_DESTA19F()","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})

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
	Pergunte(cPerg,.F.)
	if Empty(mv_par01)
		Pergunte(cPerg,.T.)
	Endif

	aadd(aRotina,{"Pesquisar" ,"AxPesqui"    ,0,1})
	aadd(aRotina,{"Visualizar","AxVisual"    ,0,2})
	aadd(aRotina,{"Liberar"   ,"U_DESTA19A"  ,0,4})
	aadd(aRotina,{"Atualizar" ,"U_DESTA19R()",0,3})
	aadd(aRotina,{"Parametros","U_DESTA19P()",0,4})
	aadd(aRotina,{"Legenda"   ,"U_DESTA19L()",0,3})


	// Matriz de definição de cores da legenda
	aadd(aCores,{"ZZ6_BLQ = 'S'" ,"BR_VERMELHO"})
	aadd(aCores,{"ZZ6_BLQ = 'N'" ,"BR_VERDE"   })


	aadd(aListaCpo,"ZZ6_SERIE")
	aadd(aListaCpo,"ZZ6_NUM")
	aadd(aListaCpo,"ZZ6_CODIGO")
	aadd(aListaCpo,"ZZ7_DESC")
	aadd(aListaCpo,"ZZ6_DATAIN")
	aadd(aListaCpo,"ZZ6_BLQ")

	dbSelectArea("SX3")
	dbSetOrder(2)
	For k=1 to Len(aListaCpo)
		dbSeek(Alltrim(aListaCpo[k]))
		if Found()
			aAdd(aCpos,{AllTrim(X3_TITULO),Alltrim(X3_CAMPO)})
		Endif
	Next

	AbreZZ6()

	dbSelectArea("ZZ6")
	Set Key VK_F5  TO U_DESTA19R()
	Set Key VK_F12 TO U_DESTA19P()
	mBrowse(,,,,"ZZ6",aCpos,,,,,aCores,,,,) // Cria o browse
	Set Key VK_F5  TO
	Set Key VK_F12 TO
	
	dbSelectArea("ZZ6")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	ChkFile("ZZ6")
Return nil

User Function DESTA19A(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons)
	Local   aCRA    := {"Confirma","Redigita","Abandona"}
	Private aTELA[0][0]
	Private aGETS[0]
	Private cOpcao  := ""
	Private lF3     := .F.
	Private cTudoOk := ".T."
	Private INCLUI  := .F.
	Private ALTERA  := .T.

	If ZZ6->ZZ6_BLQ <> "S"
		ApMsgInfo("Cond. Esp. já liberada.")
		Return nil
	Endif

	nOpc := 4

	bOk := &("{|| "+cTudoOk+"}")

	RegToMemory(cAlias,(nOpc=3))

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 9,0 TO TranslateBottom(.F.,28),80 OF oMainWnd
	aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}  // Ocupa todo o espaço da janela
	EnChoice(cAlias,nReg,nOpc,aCRA,"CRA","Quanto … inclusão?",aAcho,aPosEnch,aCpos,,,,cTudoOk,,lF3)
	nOpca := 3
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,If(Obrigatorio(aGets,aTela).and. Eval(bOk),oDlg:End(),(nOpca:=3,.f.))},{|| nOpca := 3,oDlg:End()},,aButtons)

	If nOpca = 1
		If RecLock("ZZ6",.F.)
			ZZ6->ZZ6_BLQ := "N"
			ZZ6->ZZ6_USERVW := Upper(AllTrim(cUserName))
			ZZ6->ZZ6_DATAVW := dDataBase
			ZZ6->ZZ6_HORAVW := Time()
			ZZ6->ZZ6_JUSTIF := M->ZZ6_JUSTIF
			MsUnLock()

			cSql := "UPDATE "+RetSqlName("ZZ6")
			cSql += " SET ZZ6_BLQ = 'N'"
			cSql += " ,   ZZ6_USERVW = '"+ZZ6->ZZ6_USERVW+"'"
			cSql += " ,   ZZ6_DATAVW = '"+dtos(ZZ6->ZZ6_DATAVW)+"'"
			cSql += " ,   ZZ6_HORAVW = '"+ZZ6->ZZ6_HORAVW+"'"
			cSql += " ,   ZZ6_JUSTIF = '"+ZZ6->ZZ6_JUSTIF+"'"
			cSql += " WHERE D_E_L_E_T_ = ''
			cSql += " AND ZZ6_FILIAL = '"+ZZ6->ZZ6_FILIAL+"'"
			cSql += " AND ZZ6_SERIE = '"+ZZ6->ZZ6_SERIE+"'"
			cSql += " AND ZZ6_NUM = '"+ZZ6->ZZ6_NUM+"'"
			cSql += " AND ZZ6_CODIGO = '"+ZZ6->ZZ6_CODIGO+"'"
			nUpdt := TcSqlExec(cSql)
			If nUpdt < 0
				MsgBox(TcSqlError(),"Pré Coleta","STOP")
			Endif
		Endif
	Endif


Return

User Function DESTA19F()
	Local   cTitulo  := ""
	Local   MvParDef := ""
	Local   MvPar
	Private aSit     := {}
	Private l1Elem   := .F.

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	aAdd(aSit,"S - Bloqueado")
	aAdd(aSit,"N - Liberado" )
	mvParDef := "SN"

	cTitulo :="Status"
	Do While .T. 
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
		if mvpar = Replicate("*",Len(mvParDef))
			MsgBox("Voce deve selecionar pelo menos 1","Status","STOP")
			Loop
		Else
			Exit
		Endif
	Enddo
Return MvParDef

Static Function AbreZZ6
	Local cSql   := ""
	Local aEstru := {}
	Local aIndex := {}
	Local k      := 0

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZZ6")
	
	Do While !eof() .AND. X3_ARQUIVO = "ZZ6"
		IF X3_CONTEXT <> "V"
			aadd(aEstru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		Endif
		dbSkip()
	Enddo

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZZ6")

	Do While !eof() .AND. INDICE = "ZZ6"
		aadd(aIndex,{INDICE+ORDEM,AllTrim(CHAVE)})
		dbSkip()
	Enddo

	dbSelectArea("ZZ6")
	dbCloseArea()

	if !Empty(cNomTmp)
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
	Endif

	cSql := "SELECT ZZ7_DESC,"
	For k=1 to Len(aEstru)
		cSql += AllTrim(aEstru[k,1])+iif(k < Len(aEstru),",","")
	Next
	cSql += " FROM "+RetSqlName("ZZ6")+" ZZ6"

	cSql += " JOIN "+RetSqlName("ZZ7")+" ZZ7"
	cSql += " ON   ZZ7.D_E_L_E_T_ = ''"
	cSql += " AND  ZZ7_FILIAL = ''"
	cSql += " AND  ZZ7_CODIGO = ZZ6_CODIGO"
	cSql += " AND  ZZ7_BLQFAT = 'S'"

	cSql += " WHERE ZZ6.D_E_L_E_T_ = ''
	cSql += " AND   ZZ6_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   ZZ6_BLQ IN("+MontaIn(mv_par01)+")"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	For k=1 to Len(aEstru)
		if aEstru[k,2] <> "C"
			TcSetField("ARQ_SQL",aEstru[k,1],aEstru[k,2],aEstru[k,3],aEstru[k,4])
		Endif
	Next k

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"ZZ6",.F.,.F.)
	
	For k=1 to Len(aIndex)
		Index on &aIndex[k,2] TAG &aIndex[k,1] TO &cNomTmp
	Next k
Return nil

Static Function MontaIn(cParam)
	Local cRet := ""

	cRet  := ""
	For jj=1 to Len(AllTrim(cParam))
		If Substr(cParam,jj,1) <> "*"
			cRet := cRet + "'"+Substr(cParam,jj,1)+"',"
		Endif
	Next jj
	If Len(cRet) > 0
		cRet := substr(cRet,1,Len(cRet)-1)
	Endif
Return cRet

User Function DESTA19R()
	Local oBrw := GetMbrowse()
	Pergunte(cPerg,.F.)
	MsgRun("Atualizando visualização ...",,{|| AbreZZ6(),dbGoTop() })
	oBrw:oCtlFocus:Refresh()
Return

User Function DESTA19P()
	if Pergunte(cPerg,.T.)
		AbreZZ6()
	Endif
Return

User Function DESTA19L()
	BrwLegenda(cCadastro,"Legenda", {{"BR_VERMELHO","Bloqueada"},;
									 {"BR_VERDE"   ,"Liberada" }})
Return nil