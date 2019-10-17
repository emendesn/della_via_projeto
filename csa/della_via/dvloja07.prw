#Include "DellaVia.ch"
#Define VK_F12 123
#Define VK_F5  116

User Function DVLOJA07
	Local   aListaCpo := {}
	Private aButtons  := {}
	Private aRotina   := {}
	Private aCores    := {}
	Private aCpos     := {}
	Private cCadastro := "Aprovação de descontos"
	Private cNomTmp   := ""
	Private cPerg     := "LOJA07"
	Private Param01   := AllTrim(GetMv("MV_APDESC1",,"")) // Usuário que podem aprovar descontos
	Private Param02   := GetMv("MV_APDESC2",,0)           // % Maximo de desconto para aprovação
	Private Param03   := AllTrim(GetMv("MV_APDESC3",,"")) // Usuário para proximo nivel de aprovação
	Private cNivelDV  := ""
	Private lSuperior := .F.


	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Status             ?"," "," ","mv_ch1","C", 05,0,0,"G","U_DVLJF07A()","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})

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

	aadd(aRotina,{"Pesquisar" ,"AxPesqui"     ,0,1})
	aadd(aRotina,{"Visualizar","U_DVLJA07A(0)",0,2})
	aadd(aRotina,{"Analisar"  ,"U_DVLJA07A(1)",0,4})
	aadd(aRotina,{"Atualizar" ,"U_DVLJA07R()" ,0,3})
	aadd(aRotina,{"Parametros","U_DVLJA07P()" ,0,4})
	aadd(aRotina,{"Legenda"   ,"U_DVLJA07L()" ,0,3})


	// Matriz de definição de cores da legenda
	aadd(aCores,{"ZXA_STATUS = '1'" ,"BR_AZUL"      })
	aadd(aCores,{"ZXA_STATUS = '2'" ,"BR_VERDE"     })
	aadd(aCores,{"ZXA_STATUS = '3'" ,"BR_VERMELHO"  })
	aadd(aCores,{"ZXA_STATUS = '4'" ,"BR_PRETO"     })
	aadd(aCores,{"ZXA_STATUS = '5'" ,"BR_AMARELO"   })


	aadd(aListaCpo,"ZXA_ORC"   )
	aadd(aListaCpo,"ZXA_ITEM"  )
	aadd(aListaCpo,"ZXA_SEQ"   )
	aadd(aListaCpo,"L1_CLIENTE")
	aadd(aListaCpo,"L1_LOJA"   )
	aadd(aListaCpo,"A1_NREDUZ" )
	aadd(aListaCpo,"L1_VEND"   )
	aadd(aListaCpo,"A3_NREDUZ" )
	aadd(aListaCpo,"ZXA_COD"   )
	aadd(aListaCpo,"ZXA_QUANT" )
	aadd(aListaCpo,"ZXA_PRCTAB")
	aadd(aListaCpo,"ZXA_PDESC" )
	aadd(aListaCpo,"ZXA_VDESC" )
	aadd(aListaCpo,"ZXA_VRUNIT")
	aadd(aListaCpo,"ZXA_TOTAL" )
	aadd(aListaCpo,"ZXA_DATSOL")
	aadd(aListaCpo,"ZXA_HORSOL")
	aadd(aListaCpo,"ZXA_DATLIB")
	aadd(aListaCpo,"ZXA_HORLIB")
	aadd(aListaCpo,"ZXA_CONDPG")
	aadd(aListaCpo,"ZXA_TABELA")

	dbSelectArea("SX3")
	dbSetOrder(2)
	For k=1 to Len(aListaCpo)
		dbSeek(Alltrim(aListaCpo[k]))
		if Found()
			aAdd(aCpos,{AllTrim(X3_TITULO),Alltrim(X3_CAMPO)})
		Endif
	Next

	AbreZXA()

	dbSelectArea("ZXA")
	Set Key VK_F5  TO U_DVLJA07R()
	Set Key VK_F12 TO U_DVLJA07P()
	mBrowse(,,,,"ZXA",aCpos,,,,,aCores,,,,{|| U_DVLJA07T() }) // Cria o browse
	Set Key VK_F5  TO
	Set Key VK_F12 TO
	
	dbSelectArea("ZXA")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	ChkFile("ZXA")
Return nil

User Function DVLJA07L()
	BrwLegenda(cCadastro,"Legenda", {{"BR_AZUL"     ,"Pendente"         },;
									 {"BR_VERDE"    ,"Aprovado"         },;
									 {"BR_AMARELO"  ,"Aguardando Sup."  },;
									 {"BR_VERMELHO" ,"Recusado"         },;
									 {"BR_PRETO"    ,"Cancelada"        }}) 
Return nil

User Function DVLJA07A(nX)
	Private cChave  := ZXA->ZXA_FILIAL+ZXA->ZXA_ORC+ZXA->ZXA_NUM
	Private cSeq    := ZXA->ZXA_SEQ


	If nX = 1
		cNivelDV := ""
		If AllTrim(cUserName) $ Param03
			cNivelDV := "2"
		ElseIf AllTrim(cUserName) $ Param01
			cNivelDV := "1"
		Endif

		If Empty(cNivelDV)
			msgbox("Usuário sem permissão para aprovar descontos","Desconto","STOP")
			Return nil
		Endif
	Endif


	if (ZXA->ZXA_STATUS $ "2*3*4" .AND. nX <> 0) .OR. (ZXA->ZXA_STATUS = "5" .AND. cNivelDV = "1" .AND. nX <> 0)
		MsgBox("Operação invalida, verifique o status da solicitação.","Desconto","STOP")
		Return nil
	Endif

	nRet := EditDB(ZXA->(Recno()),iif(nX=0,2,4),nX)

	if nRet = 1 .AND. nX <> 0
		ChkFile("ZXA",.F.,"ZXAORI")

		dbSelectArea("ZXA")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(cChave)
		
		Do While !eof() .AND. ZXA->(ZXA_FILIAL+ZXA_ORC+ZXA_NUM) = cChave
			dbSelectArea("ZXAORI")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(cChave+ZXA->(ZXA_ITEM+ZXA_SEQ))

			If RecLock("ZXAORI",.F.)
				ZXAORI->ZXA_DATLIB := dDataBase
				ZXAORI->ZXA_HORLIB := Time()
				ZXAORI->ZXA_OBSLIB := ZXA->ZXA_OBSLIB
				ZXAORI->ZXA_STATUS := ZXA->ZXA_STATUS
				ZXAORI->ZXA_MOTREC := ZXA->ZXA_MOTREC
				MsUnlock()
			Endif

			dbSelectArea("ZXA")
			dbSkip()
		Enddo
		dbSelectArea("ZXAORI")
		dbCloseArea()

		AbreZXA()
		dbSelectArea("ZXA")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(cChave)
	Endif
Return nil

Static Function EditDb(nRecno,nOpx,nX)
	Local   cCond   := ""
	Local   cTabPrc := ""
	Local   k       := 0
	Private nOpc    := nOpx
	Private aHeader := {}
	Private aCols   := {}
	Private aAlter  := {}
	Private nClose  := 2
	Private cFilEst := ""
	Private nDescMedio := 0
	Private nQtdItens  := 0

	dbSelectArea("SM0")
	cEmpSM0 := M0_CODIGO
	cEstEmp := M0_ESTENT
	nRecSM0 := Recno()
	dbGoTop()
	Do While !eof() .AND. M0_CODIGO = cEmpSM0
		if M0_ESTENT = cEstEmp
			cFilEst += iif(!Empty(cFilEst),",","")+"'"+M0_CODFIL+"'"
		Endif
		dbSkip()
	Enddo
	dbSelectArea("SM0")
	dbGoTo(nRecSM0)

	aAdd(aHeader,{"Filial"       ,"ZXA_FILIAL" ,""                 ,02,0,                          ,,"C",,})
	aAdd(aHeader,{"Item"         ,"ZXA_ITEM"   ,""                 ,02,0,                          ,,"C",,})
	aAdd(aHeader,{"Codigo"       ,"ZXA_COD"    ,""                 ,15,0,                          ,,"C",,})
	aAdd(aHeader,{"Descrição"    ,"B1_DESC"    ,""                 ,30,0,                          ,,"C",,})
	aAdd(aHeader,{"Quantidade"   ,"ZXA_QUANT"  ,"@E 999,999,999.99",14,2,                          ,,"N",,})
	aAdd(aHeader,{"Prc Tabela"   ,"ZXA_PRCTAB" ,"@E 999,999,999.99",14,2,                          ,,"N",,})
	aAdd(aHeader,{"% Desconto"   ,"ZXA_PDESC"  ,"@E 999.99"        ,06,2,                          ,,"N",,})
	aAdd(aHeader,{"Vlr Desconto" ,"ZXA_VDESC"  ,"@E 999,999,999.99",14,2,                          ,,"N",,})
	aAdd(aHeader,{"Vlr Unitario" ,"ZXA_VRUNIT" ,"@E 999,999,999.99",14,2,                          ,,"N",,})
	aAdd(aHeader,{"Total"        ,"ZXA_TOTAL"  ,"@E 999,999,999.99",14,2,                          ,,"N",,})
	aAdd(aHeader,{"Observação"   ,"ZXA_OBS"    ,""                 ,50,0,                          ,,"C",,})
	aAdd(aHeader,{"Obs Liberação","ZXA_OBSLIB" ,""                 ,50,0,"!Empty(M->ZXA_OBSLIB)"   ,,"C",,})
	aAdd(aHeader,{"Data Solicit" ,"ZXA_DATSOL" ,""                 ,08,0,                          ,,"D",,})
	aAdd(aHeader,{"Hora Solicit" ,"ZXA_HORSOL" ,""                 ,05,0,                          ,,"C",,})
	aAdd(aHeader,{"Data Liber"   ,"ZXA_DATLIB" ,""                 ,08,0,                          ,,"D",,})
	aAdd(aHeader,{"Hora Liber"   ,"ZXA_HORLIB" ,""                 ,05,0,                          ,,"C",,})
	aAdd(aHeader,{"Saldo"        ,"nSaldo"     ,"@E 999,999,999.99",14,2,                          ,,"N",,})
	aAdd(aHeader,{"Custo Medio"  ,"nCusto"     ,"@E 999,999,999.99",14,2,                          ,,"N",,})

	aAdd(aAlter,"ZXA_OBSLIB")

	dbSelectArea("ZXA")
	dbGoTo(nRecNo)
	cChave := ZXA->(ZXA_FILIAL+ZXA_ORC+ZXA_NUM)
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cChave)
	cNum := ZXA_ORC


	cSql := "SELECT COUNT(L2_ITEM) AS QTD"
	cSql += " FROM "+RetSqlName("SL2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   L2_FILIAL = '"+Substr(cChave,1,2)+"'"
	cSql += " AND   L2_NUM = '"+cNum+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_QTD", .T., .T.)
	TcSetField("SQL_QTD","QTD" ,"N",11,0)
	dbSelectArea("SQL_QTD")
	nQtdItens := QTD
	dbCloseArea()


	dbSelectArea("SA1")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SA1")+ZXA->L1_CLIENTE+ZXA->L1_LOJA)

	dbSelectArea("SA3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SA3")+ZXA->L1_VEND)

	dbSelectArea("SE4")
	dbGotop()
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+ZXA->ZXA_CONDPG)

	cObs := MSMM(ZXA->ZXA_OBSGER,80)

	nDescMedio := DescMedio(ZXA->ZXA_FILIAL,ZXA->ZXA_ORC,ZXA->ZXA_SEQ,ZXA->ZXA_NUM)

	lSuperior := .F.

	dbSelectArea("ZXA")
	Do while !eof() .AND. ZXA->(ZXA_FILIAL+ZXA_ORC+ZXA_NUM) = cChave
		cCondPg := ZXA_CONDPG + " - " + SE4->E4_DESCRI
		cTabPrc := ZXA_TABELA

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SB1")+ZXA->ZXA_COD)
		cDesc := ""
		if Found()
			cDesc := B1_DESC
		Endif
		dbSelectArea("ZXA")

		nSaldo := 0
		nCusto := 0

		cSql := "SELECT SUM(B2_QATU) AS QATU, SUM(B2_VATU1) AS CUSTO"
		cSql += " FROM "+RetSqlName("SB2")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   B2_FILIAL IN("+cFilEst+")"
		cSql += " AND   B2_LOCAL = '01'"
		cSql += " AND   B2_COD = '"+ZXA_COD+"'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_EST", .T., .T.)
		dbSelectArea("SQL_EST")
		TcSetField("SQL_EST","QATU" ,"N",14,2)
		TcSetField("SQL_EST","CUSTO","N",14,2)
		nSaldo := QATU
		nCusto := CUSTO/QATU
		dbCloseArea()
		dbSelectArea("ZXA")

		If ZXA_PDESC > Param02 .AND. cNivelDV = "1"
			lSuperior := .T.
		Endif

		aAdd(aCols,{ZXA_FILIAL,ZXA_ITEM,ZXA_COD,cDesc,ZXA_QUANT,ZXA_PRCTAB,ZXA_PDESC,ZXA_VDESC,ZXA_VRUNIT,ZXA_TOTAL,ZXA_OBS,ZXA_OBSLIB,ZXA_DATSOL,ZXA_HORSOL,ZXA_DATLIB,ZXA_HORLIB,nSaldo,nCusto,.F.})
		dbSkip()
	Enddo

	dbSelectArea("ZXA")
	DEFINE MSDIALOG oDlgDesc FROM 000,000 TO 420,700 TITLE "Solicitação de descontos" Of oMainWnd PIXEL
	oPanel := TPanel():New(0,0,"",oDlgDesc, oDlgDesc:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 015,003 SCROLLBOX oScr SIZE 080,347 OF oDlgDesc
	oGetDesc := MSGetDados():New(000,000,078,345,nOpc,"U_DVLJA07V(.F.)",,,.F.,aAlter,,,Len(aCols),,,,, oScr)

	@ 100,003 SCROLLBOX oScr01 SIZE 105,347 OF oDlgDesc
	@ 003,003 SAY "Observação Geral:" PIXEL OF oScr01 SIZE 50,7
	@ 002,050 MEMO cObs PIXEL OF oScr01 SIZE 130,65 NO VSCROLL READONLY

	@ 003,190 SAY "Orçamento:" PIXEL OF oScr01 SIZE 40,7
	@ 002,240 GET cNum  PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 014,190 SAY "Itens Orc.:" PIXEL OF oScr01 SIZE 50,7
	@ 013,240 Get nQtdItens PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 025,190 SAY "Cond. Pagto:" PIXEL OF oScr01 SIZE 40,7
	@ 024,240 GET cCondPg  PIXEL OF oScr01 SIZE 100,7 WHEN .F.

	@ 036,190 SAY "Tabela:" PIXEL OF oScr01 SIZE 40,7
	@ 035,240 GET cTabPrc  PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 047,190 SAY "Prazo Médio:" PIXEL OF oScr01 SIZE 40,7
	@ 046,240 GET SE4->E4_CPOCPBI PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 058,190 SAY "Desc. Médio:" PIXEL OF oScr01 SIZE 40,7
	@ 057,240 GET nDescMedio PICTURE "@e 999.99" PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 069,003 SAY "Cliente:" PIXEL OF oScr01 SIZE 50,7
	@ 068,050 Get SA1->A1_COD PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 069,190 SAY "Nome:" PIXEL OF oScr01 SIZE 50,7
	@ 068,240 Get SA1->A1_NREDUZ PIXEL OF oScr01 SIZE 100,7 WHEN .F.

	@ 080,003 SAY "Vendedor:" PIXEL OF oScr01 SIZE 50,7
	@ 079,050 Get SA3->A3_COD PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 080,190 SAY "Nome:" PIXEL OF oScr01 SIZE 50,7
	@ 079,240 Get SA3->A3_NREDUZ PIXEL OF oScr01 SIZE 100,7 WHEN .F.

	aButtons := {}
	aadd(aButtons,{"BMPVISUAL",{|| VerOrc() },"Orcamento"  })

	oDlgDesc:lMaximized := .F.
	ACTIVATE MSDIALOG oDlgDesc CENTERED ON INIT EnchoiceBar(oDlgDesc,{|| nClose:=1,Close(oDlgDesc) },{|| nClose:=2,Close(oDlgDesc)},,aButtons) VALID iif(nOpc=4,U_DVLJA07V(.T.),.T.)

	if nClose = 1 .AND. nX = 1
		cStatus := ApvRec()
		cMotivo := iif(cStatus="3",MotRec(),"")

		For k=1 to Len(aCols)
			dbSelectArea("ZXA")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(cChave+aCols[k,2])
			If RecLock("ZXA",.F.)
				ZXA->ZXA_OBSLIB := aCols[k,12]
				ZXA->ZXA_STATUS := cStatus
				ZXA->ZXA_MOTREC := cMotivo
				MsUnlock()
			Endif
		Next k
	Endif
Return nClose

User Function DVLJA07V(lTodos)
	Local lRet := .F.
	Local L    := 0

	if lTodos
		For L=1 to Len(aCols)
			lRet := !Empty(aCols[L,12])
			If !lRet
				exit
			Endif
		Next L
	Else
		lRet := !Empty(aCols[n,12])
	Endif

	if nOpc <> 4
		lRet := .T.
	Endif

	if !lRet
		Help("",1,"OBRIGAT2")
		nClose := 2
	Endif
Return lRet

Static Function AbreZXA
	Local cSql   := ""
	Local aEstru := {}
	Local aIndex := {}
	Local k      := 0

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZXA")
	
	Do While !eof() .AND. X3_ARQUIVO = "ZXA"
		IF X3_CONTEXT <> "V"
			aadd(aEstru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		Endif
		dbSkip()
	Enddo

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZXA")

	Do While !eof() .AND. INDICE = "ZXA"
		aadd(aIndex,{INDICE+ORDEM,AllTrim(CHAVE)})
		dbSkip()
	Enddo

	dbSelectArea("ZXA")
	dbCloseArea()

	if !Empty(cNomTmp)
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
	Endif

	cSql := "SELECT L1_CLIENTE,L1_LOJA,A1_NREDUZ,L1_VEND,A3_NREDUZ,"
	For k=1 to Len(aEstru)
		cSql += AllTrim(aEstru[k,1])+iif(k < Len(aEstru),",","")
	Next
	cSql += " FROM "+RetSqlName("ZXA")+" ZXA"

	cSql += " JOIN "+RetSqlName("SL1")+" SL1"
	cSql += " ON   SL1.D_E_L_E_T_ = ''"
	cSql += " AND  L1_FILIAL = ZXA_FILIAL"
	cSql += " AND  L1_NUM = ZXA_ORC"

	cSql += " LEFT JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = ''"
	cSql += " AND  A1_COD = L1_CLIENTE"
	cSql += " AND  A1_LOJA = L1_LOJA"

	cSql += " LEFT JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = ''"
	cSql += " AND  A3_COD = L1_VEND"

	cSql += " WHERE ZXA.D_E_L_E_T_ = ''"
	cSql += " AND   ZXA_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   ZXA_STATUS IN("+MontaIn(mv_par01)+")"
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
	dbUseArea(.T.,,cNomTmp,"ZXA",.F.,.F.)
	
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

User Function DVLJA07P()
	if Pergunte(cPerg,.T.)
		AbreZXA()
	Endif
Return


Static Function VerOrc()
	dbSelectArea("SL1")
	dbSetOrder(1)
	dbSeek(cChave)

	if !eof()
		Lj7Venda("SL1",SL1->(Recno()),2)
	Else
		ApMsgStop("Erro ao localizar o orçamento")
	Endif
Return nil

Static function DescMedio(cFil,cOrc,cSeq,cSol)
	Local aArea := GetArea()
	Local nVal  := 0
	Local cSql  := ""

	cSql := "SELECT (SUM((L2_QUANT * "
	cSql += "       (CASE"
	cSql += "             WHEN NOT ZXA_PDESC IS NULL THEN"
	cSql += "                 ZXA_VRUNIT"
	cSql += "             WHEN ZXA_PDESC IS NULL THEN"
	cSql += "                 L2_VRUNIT"
	cSql += "         END))) / SUM(L2_QUANT*L2_PRCTAB)) * 100 AS DESC_MEDIO"
	cSql += " FROM "+RetSqlName("SL2")+" SL2"

	cSql += " LEFT JOIN "+RetSqlName("ZXA")+" ZXA"
	cSql += " ON   ZXA.D_E_L_E_T_ = ''"
	cSql += " AND  ZXA_FILIAL = L2_FILIAL"
	cSql += " AND  ZXA_ORC = L2_NUM"
	cSql += " AND  ZXA_ITEM = L2_ITEM"
	cSql += " AND  ZXA_SEQ = '"+cSeq+"'"
	cSql += " AND  ZXA_NUM = '"+cSol+"'"

	cSql += " WHERE SL2.D_E_L_E_T_ = ''"
	cSql += " AND   L2_FILIAL = '"+cFil+"'"
	cSql += " AND   L2_NUM = '"+cOrc+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MEDIO", .T., .T.)
	TcSetField("SQL_MEDIO","DESC_MEDIO","N",6,2)
	dbSelectArea("SQL_MEDIO")
	nVal := 100-DESC_MEDIO
	dbCloseArea()
	RestArea(aArea)
Return nVal

User Function DVLJA07R()
	Local oBrw := GetMbrowse()
	Pergunte(cPerg,.F.)
	MsgRun("Atualizando visualização ...",,{|| AbreZXA(),dbGoTop() })
	oBrw:oCtlFocus:Refresh() //oBrw:Refresh() //SysRefresh()
Return

User Function DVLJA07T()
	Local oBrw := GetMbrowse()
	Define Timer oTmr01 INTERVAL 900000 ACTION U_DVLJA07R() OF oBrw
	Activate Timer oTmr01
Return nil

Static Function MotRec()
	Local cMot := Space(2)

	DEFINE MSDIALOG oDlgMot FROM 000,000 TO 050,500 TITLE "Recusar - Motivo" Pixel //Of oMainWnd PIXEL
	@ 005,005 SAY "Motivo:" PIXEL OF oDlgMot SIZE 40,7
	@ 004,030 GET cMot  PIXEL OF oDlgMot SIZE 30,7 F3 "X2" PICTURE "@!" VALID !Empty(cMot) .AND. VldMot(cMot)
	@ 005,065 SAY "" OBJECT oSayTxt PIXEL OF oDlgMot SIZE 40,7
	@ 003,200 BMPBUTTON TYPE 1 ACTION Close(oDlgMot)
	ACTIVATE MSDIALOG oDlgMot CENTERED VALID !Empty(cMot)

Return cMot

Static Function VldMot(cVar)
	Local lRet := .F.
	lRet := ExistCpo("SX5","X2"+cVar,1)
	If lRet
		oSayTxt:cCaption := Tabela("X2",cVar,.F.)
	Endif
Return lRet

User Function DVLJF07A()
	Local   cTitulo  := ""
	Local   MvParDef := ""
	Local   MvPar
	Private aSit     := {}
	Private l1Elem   := .F.

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	aAdd(aSit,"1 - Pendente"       )
	aAdd(aSit,"2 - Liberado"       )
	aAdd(aSit,"3 - Recusado"       )
	aAdd(aSit,"4 - Cancelado"      )
	aAdd(aSit,"5 - Aguardando Sup.")
	mvParDef := "12345"

	cTitulo :="Status"
	Do While .T. 
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
		if mvpar = Replicate("*",Len(mvParDef))
			MsgBox("Voce deve selecionar pelo menos 1 tipo de venda","Tipo de venda","STOP")
			Loop
		Else
			Exit
		Endif
	Enddo
Return MvParDef

Static Function ApvRec()
	Local cRet := ""

	DEFINE MSDIALOG oDlgApr FROM 000,000 TO 030,180 TITLE "Desconto" Pixel
	@ 003,005 BUTTON "_Aprovar"  SIZE 35,11 ACTION  {cRet:=iif(lSuperior,"5","2"),Close(oDlgApr)}
	@ 003,045 BUTTON "_Reprovar" SIZE 35,11 ACTION  {cRet:="3",Close(oDlgApr)}
	ACTIVATE MSDIALOG oDlgApr CENTERED VALID !Empty(cRet)

Return cRet