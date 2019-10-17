#include "DellaVia.ch"
#Define VK_F12 123

User Function DVTMKA01
	Local   aListaCpo := {}
	Private aButtons  := {}
	Private aRotina   := {}
	Private aCores    := {}
	Private aCpos     := {}
	Private cCadastro := "Aprovação de descontos"
	Private cNomTmp   := ""
	Private cPerg     := "TMKA01"

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Status             ?"," "," ","mv_ch1","C", 05,0,0,"G","U_DVTKF01A()","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})

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
	aadd(aRotina,{"Visualizar","U_DVTKA01A(0)",0,2})
	aadd(aRotina,{"Consultar" ,"U_DVTKA01A(4)",0,4})
	aadd(aRotina,{"Analisar"  ,"U_DVTKA01A(1)",0,4})
	//aadd(aRotina,{"Liberar"   ,"U_DVTKA01A(1)",0,4})
	//aadd(aRotina,{"Recusar"   ,"U_DVTKA01A(2)",0,4})
	aadd(aRotina,{"Cancelar"  ,"U_DVTKA01A(3)",0,4})
	aadd(aRotina,{"Atualizar" ,"U_DVTKA01R()" ,0,3})
	aadd(aRotina,{"Parametros","U_DVTKA01P()" ,0,4})
	aadd(aRotina,{"Legenda"   ,"U_DVTKA01L()" ,0,3})


	// Matriz de definição de cores da legenda
	aadd(aCores,{"ZX2_STATUS = '1'" ,"BR_AZUL"      })
	aadd(aCores,{"ZX2_STATUS = '2'" ,"BR_VERDE"     })
	aadd(aCores,{"ZX2_STATUS = '3'" ,"BR_VERMELHO"  })
	aadd(aCores,{"ZX2_STATUS = '4'" ,"BR_PRETO"     })
	aadd(aCores,{"ZX2_STATUS = '5'" ,"BR_AMARELO"   })

	dbSelectArea("SU7")
	dbSetOrder(4)
	dbGoTop()
	dbSeek(xFilial("SU7")+__cUserId)
	If !Found()
		msgbox("Voce não pode acessar esta rotina, pois não esta cadastrado como operador","Descontos","STOP")
		Return nil
	Endif

	aadd(aListaCpo,"ZX2_ORC"   )
	aadd(aListaCpo,"ZX2_ITEM"  )
	aadd(aListaCpo,"ZX2_SEQ"   )
	aadd(aListaCpo,"UA_CLIENTE")
	aadd(aListaCpo,"UA_LOJA"   )
	aadd(aListaCpo,"A1_NOME"   )
	aadd(aListaCpo,"UA_VEND"   )
	aadd(aListaCpo,"A3_NREDUZ" )
	aadd(aListaCpo,"ZX2_COD"   )
	aadd(aListaCpo,"ZX2_QUANT" )
	aadd(aListaCpo,"ZX2_PRCTAB")
	aadd(aListaCpo,"ZX2_PDESC" )
	aadd(aListaCpo,"ZX2_VDESC" )
	aadd(aListaCpo,"ZX2_VRUNIT")
	aadd(aListaCpo,"ZX2_TOTAL" )
	aadd(aListaCpo,"ZX2_DATSOL")
	aadd(aListaCpo,"ZX2_HORSOL")
	aadd(aListaCpo,"ZX2_DATLIB")
	aadd(aListaCpo,"ZX2_HORLIB")
	aadd(aListaCpo,"ZX2_CONDPG")
	aadd(aListaCpo,"ZX2_TABELA")
	aadd(aListaCpo,"ZX2_TIPVND")

	dbSelectArea("SX3")
	dbSetOrder(2)
	For k=1 to Len(aListaCpo)
		dbSeek(Alltrim(aListaCpo[k]))
		if Found()
			aAdd(aCpos,{AllTrim(X3_TITULO),Alltrim(X3_CAMPO)})
		Endif
	Next

	AbreZX2()

	dbSelectArea("ZX2")
	Set Key VK_F12 TO U_DVTKA01P()
	mBrowse(,,,,"ZX2",aCpos,,,,,aCores,,,,{|| U_DVTKA01T() }) // Cria o browse
	Set Key VK_F12 TO
	
	dbSelectArea("ZX2")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	ChkFile("ZX2")
Return nil

User Function DVTKA01L()
	BrwLegenda(cCadastro,"Legenda", {{"BR_AZUL"     ,"Pendente"         },;
									 {"BR_VERDE"    ,"Aprovado"         },;
									 {"BR_AMARELO"  ,"Aguardando Sup."  },;
									 {"BR_VERMELHO" ,"Recusado"         },;
									 {"BR_PRETO"    ,"Cancelada"        }}) 
Return nil

User Function DVTKA01A(nX)
	Local   cEnvSup := ""
	Private cChave  := ZX2->ZX2_FILIAL+ZX2->ZX2_ORC+ZX2->ZX2_NUM
	Private cSeq    := ZX2->ZX2_SEQ
	Private lRecusa := .F.

	if nX = 4
		cParam := ZX2->ZX2_ORC
		dbSelectArea("ZX2")
		dbCloseArea()
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
		ChkFile("ZX2")

		U_DVTMKC01(cParam)

		AbreZX2()
		dbSelectArea("ZX2")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(cChave)

		Return nil
	Endif


	if (nX = 1 .or. nX = 2) .AND. ZX2->ZX2_TIPO <> "L"
		MsgBox("Somento o supervisor responsável pode executar esta operação","Desconto","STOP")
		Return nil
	Endif

	if nX = 3 .AND. ZX2->ZX2_TIPO <> "S"
		MsgBox("Somento o operador pode executar esta operação","Desconto","STOP")
		Return nil
	Endif


	if (nX = 3 .AND. ZX2->ZX2_STATUS <> "5") .OR. (ZX2->ZX2_STATUS $ "2*3*4*5" .AND. nX <> 0)
		MsgBox("Operação invalida, verifique o status da solicitação.","Desconto","STOP")
		Return nil
	Endif

	//nRet := AxAltera("ZX2",ZX2->(Recno()),iif(nX=1,4,2))
	nRet := EditDB(ZX2->(Recno()),iif(nX=0,2,4),nX)

	If lRecusa
		nX := 2
	Endif

	cMotivo := ""
	If nRet = 1 .AND. nX = 2
		cMotivo := MotRec()
		If Empty(cMotivo)
			nX := 0
		Endif
	Endif

	If nX = 0
		Return nil
	Endif

	if nRet = 1
		dbSelectArea("ZX2")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(cChave)
		
		Do While !eof() .AND. ZX2->(ZX2_FILIAL+ZX2_ORC+ZX2_NUM) = cChave
			If ZX2->ZX2_PDESC > SU7->U7_DVDESC .AND. nX = 1
				if Empty(SU7->U7_CODSUP)
					msgbox("Existe uma divergência de cadastro ou o percentual de desconto esta errado.","Descontos","ALERT")
					Return nil
				Endif
				nX := 4
			Endif

			cSql := "UPDATE "+RetSqlName("ZX2")
			cSql += " SET ZX2_STATUS = '"+Str(nX+1,1)+"'"
			cSql += " ,   ZX2_MOTREC = '"+cMotivo+"'"
			cSql += " WHERE D_E_L_E_T_ = ''"
			cSql += " AND   ZX2_FILIAL = '"+ZX2->ZX2_FILIAL+"'"
			cSql += " AND   ZX2_ORC = '"+ZX2->ZX2_ORC+"'"
			cSql += " AND   ZX2_NUM = '"+ZX2->ZX2_NUM+"'"
			cSql += " AND   ZX2_ITEM = '"+ZX2->ZX2_ITEM+"'"
			TcSqlExec(cSql)


			ChkFile("ZX2",.F.,"ZX2ORI")
			dbSelectArea("ZX2ORI")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(cChave+ZX2->(ZX2_ITEM+ZX2_SEQ))

			If RecLock("ZX2ORI",.F.)
				ZX2ORI->ZX2_PDESC  := ZX2->ZX2_PDESC
				ZX2ORI->ZX2_VDESC  := ZX2->ZX2_VDESC
				ZX2ORI->ZX2_VRUNIT := ZX2->ZX2_VRUNIT
				ZX2ORI->ZX2_TOTAL  := ZX2->ZX2_TOTAL
				ZX2ORI->ZX2_DATLIB := dDataBase
				ZX2ORI->ZX2_HORLIB := Time()
				ZX2ORI->ZX2_OBSLIB := ZX2->ZX2_OBSLIB
				MsUnlock()
			Endif

			If nX = 4
				If RecLock("ZX2ORI",.T.)
					ZX2ORI->ZX2_FILIAL := ZX2->ZX2_FILIAL
					ZX2ORI->ZX2_ORC    := ZX2->ZX2_ORC
					ZX2ORI->ZX2_NUM    := ZX2->ZX2_NUM
					ZX2ORI->ZX2_SEQ    := StrZero(Val(ZX2->ZX2_SEQ)+1,2)
					ZX2ORI->ZX2_ITEM   := ZX2->ZX2_ITEM
					ZX2ORI->ZX2_COD    := ZX2->ZX2_COD
					ZX2ORI->ZX2_QUANT  := ZX2->ZX2_QUANT
					ZX2ORI->ZX2_PRCTAB := ZX2->ZX2_PRCTAB
					ZX2ORI->ZX2_PDESC  := ZX2->ZX2_PDESC
					ZX2ORI->ZX2_VDESC  := ZX2->ZX2_VDESC
					ZX2ORI->ZX2_VRUNIT := ZX2->ZX2_VRUNIT
					ZX2ORI->ZX2_TOTAL  := ZX2->ZX2_TOTAL
					ZX2ORI->ZX2_OBS    := ZX2->ZX2_OBSLIB
					ZX2ORI->ZX2_OBSGER := ZX2->ZX2_OBSGER
					ZX2ORI->ZX2_OPER   := Posicione("SU7",1,xFilial("SU7")+ZX2->ZX2_OPER,"SU7->U7_CODSUP")
					ZX2ORI->ZX2_DATSOL := dDataBase
					ZX2ORI->ZX2_HORSOL := Time()
					ZX2ORI->ZX2_STATUS := "1"
					ZX2ORI->ZX2_TIPO   := "L"
					ZX2ORI->ZX2_CONDPG := ZX2->ZX2_CONDPG
					ZX2ORI->ZX2_TABELA := ZX2->ZX2_TABELA
					ZX2ORI->ZX2_TIPVND := ZX2->ZX2_TIPVND
					MsUnLock()
				Endif
				cEnvSup := ZX2ORI->ZX2_OPER
			Endif
			dbSelectArea("ZX2ORI")
			dbCloseArea()

			if nX = 1
				dbSelectArea("SUB")
				dbSetOrder(1)
				dbGoTop()
				dbSeek(ZX2->(ZX2_FILIAL+ZX2_ORC+ZX2_ITEM))
				If Found()
					If RecLock("SUB",.F.)
						SUB->UB_VRUNIT  := ZX2->ZX2_VRUNIT
						SUB->UB_VLRITEM := ZX2->ZX2_TOTAL
						SUB->UB_DESC    := ZX2->ZX2_PDESC
						SUB->UB_VALDESC := ZX2->ZX2_VDESC
						MsUnlock()
					Endif
				Endif
			Endif

			dbSelectArea("ZX2")
			dbSkip()
		Enddo

		If nX = 4
			//U_DVTMKF01(cEnvSup,Substr(cChave,3,6),Substr(cChave,9,6))
		Endif

		AbreZX2()
		dbSelectArea("ZX2")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(cChave)
	
		cSql := "SELECT DISTINCT ZX2_ORC FROM "+RetSqlName("ZX2")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ZX2_FILIAL = '"+Substr(cChave,1,2)+"'"
		cSql += " AND   ZX2_ORC = '"+Substr(cChave,3,6)+"'"
		cSql += " AND   ZX2_NUM = '"+Substr(cChave,9,6)+"'"
		cSql += " AND   ZX2_STATUS IN('1','5')"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LIB", .T., .T.)
		dbSelectArea("SQL_LIB")
		lEnvia := Eof()
		dbCloseArea()

		if lEnvia
			cSql := "SELECT DISTINCT ZX2_SEQ,ZX2_OPER FROM "+RetSqlName("ZX2")
			cSql += " WHERE D_E_L_E_T_ = ''"
			cSql += " AND   ZX2_FILIAL = '"+Substr(cChave,1,2)+"'"
			cSql += " AND   ZX2_ORC = '"+Substr(cChave,3,6)+"'"
			cSql += " AND   ZX2_NUM = '"+Substr(cChave,9,6)+"'"
			cSql += " ORDER BY ZX2_SEQ DESC"
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_OPR", .T., .T.)
			dbSelectArea("SQL_OPR")
			dbSkip()
			Do While !eof()
				//U_DVTMKF01(ZX2_OPER,Substr(cChave,3,6),Substr(cChave,9,6))
				dbSelectArea("SQL_OPR")
				dbSkip()
			Enddo
			dbCloseArea()
		Endif
	Endif
Return nil

Static Function EditDb(nRecno,nOpx,nX)
	Local   cCond   := ""
	Local   cTipVnd := ""
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

	aAdd(aHeader,{"Filial"       ,"ZX2_FILIAL" ,""                 ,002,0,                          ,,"C",,})
	aAdd(aHeader,{"Item"         ,"ZX2_ITEM"   ,""                 ,002,0,                          ,,"C",,})
	aAdd(aHeader,{"Codigo"       ,"ZX2_COD"    ,""                 ,015,0,                          ,,"C",,})
	aAdd(aHeader,{"Descrição"    ,"B1_DESC"    ,""                 ,030,0,                          ,,"C",,})
	aAdd(aHeader,{"Quantidade"   ,"ZX2_QUANT"  ,"@E 999,999,999.99",014,2,                          ,,"N",,})
	aAdd(aHeader,{"Prc Tabela"   ,"ZX2_PRCTAB" ,"@E 999,999,999.99",014,2,                          ,,"N",,})
	aAdd(aHeader,{"% Desconto"   ,"ZX2_PDESC"  ,"@E 999.99"        ,006,2,"U_DVTKA01X(M->ZX2_PDESC)",,"N",,})
	aAdd(aHeader,{"Vlr Desconto" ,"ZX2_VDESC"  ,"@E 999,999,999.99",014,2,                          ,,"N",,})
	aAdd(aHeader,{"Vlr Unitario" ,"ZX2_VRUNIT" ,"@E 999,999,999.99",014,2,                          ,,"N",,})
	aAdd(aHeader,{"Total"        ,"ZX2_TOTAL"  ,"@E 999,999,999.99",014,2,                          ,,"N",,})
	aAdd(aHeader,{"Observação"   ,"ZX2_OBS"    ,""                 ,200,0,                          ,,"C",,})
	aAdd(aHeader,{"Obs Liberação","ZX2_OBSLIB" ,""                 ,200,0,"!Empty(M->ZX2_OBSLIB)"   ,,"C",,})
	aAdd(aHeader,{"Data Solicit" ,"ZX2_DATSOL" ,""                 ,008,0,                          ,,"D",,})
	aAdd(aHeader,{"Hora Solicit" ,"ZX2_HORSOL" ,""                 ,005,0,                          ,,"C",,})
	aAdd(aHeader,{"Data Liber"   ,"ZX2_DATLIB" ,""                 ,008,0,                          ,,"D",,})
	aAdd(aHeader,{"Hora Liber"   ,"ZX2_HORLIB" ,""                 ,005,0,                          ,,"C",,})
	aAdd(aHeader,{"Saldo"        ,"nSaldo"     ,"@E 999,999,999.99",014,2,                          ,,"N",,})
	aAdd(aHeader,{"Custo Medio"  ,"nCusto"     ,"@E 999,999,999.99",014,2,                          ,,"N",,})

	If nX = 1
		aAdd(aAlter,"ZX2_PDESC" )
		//aAdd(aAlter,"ZX2_VDESC" )
	Endif
	aAdd(aAlter,"ZX2_OBSLIB")

	dbSelectArea("ZX2")
	dbGoTo(nRecNo)
	cChave := ZX2->(ZX2_FILIAL+ZX2_ORC+ZX2_NUM)
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cChave)
	cNum := ZX2_ORC


	cSql := "SELECT COUNT(UB_ITEM) AS QTD"
	cSql += " FROM "+RetSqlName("SUB")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   UB_FILIAL = '"+Substr(cChave,1,2)+"'"
	cSql += " AND   UB_NUM = '"+cNum+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_QTD", .T., .T.)
	TcSetField("SQL_QTD","QTD" ,"N",11,0)
	dbSelectArea("SQL_QTD")
	nQtdItens := QTD
	dbCloseArea()


	dbSelectArea("SA1")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SA1")+ZX2->UA_CLIENTE+ZX2->UA_LOJA)

	dbSelectArea("SA3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SA3")+ZX2->UA_VEND)

	dbSelectArea("SE4")
	dbGotop()
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+ZX2->ZX2_CONDPG)

	cObs := MSMM(ZX2->ZX2_OBSGER,80)

	nDescMedio := DescMedio(ZX2->ZX2_FILIAL,ZX2->ZX2_ORC,ZX2->ZX2_SEQ,ZX2->ZX2_NUM)


	dbSelectArea("ZX2")
	Do while !eof() .AND. ZX2->(ZX2_FILIAL+ZX2_ORC+ZX2_NUM) = cChave
		cTipVnd := ZX2_TIPVND
		cCondPg := ZX2_CONDPG + " - " + SE4->E4_DESCRI
		cTabPrc := ZX2_TABELA

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SB1")+ZX2->ZX2_COD)
		cDesc := ""
		if Found()
			cDesc := B1_DESC
		Endif
		dbSelectArea("ZX2")

		nSaldo := 0
		nCusto := 0
		IF Empty(SU7->U7_CODSUP)
			cSql := "SELECT SUM(B2_QATU) AS QATU, SUM(B2_VATU1) AS CUSTO"
			cSql += " FROM "+RetSqlName("SB2")
			cSql += " WHERE D_E_L_E_T_ = ''"
			cSql += " AND   B2_FILIAL IN("+cFilEst+")"
			cSql += " AND   B2_LOCAL = '01'"
			cSql += " AND   B2_COD = '"+ZX2_COD+"'"
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_EST", .T., .T.)
			dbSelectArea("SQL_EST")
			TcSetField("SQL_EST","QATU" ,"N",14,2)
			TcSetField("SQL_EST","CUSTO","N",14,2)
			nSaldo := QATU
			nCusto := CUSTO/QATU
			dbCloseArea()
			dbSelectArea("ZX2")
		Endif

		//aAdd(aCols,{ZX2_ITEM,ZX2_COD,cDesc,ZX2_QUANT,ZX2_PRCTAB,ZX2_PDESC,ZX2_VDESC,ZX2_VRUNIT,ZX2_TOTAL,ZX2_OBS,iif(Empty(ZX2_OBSLIB),ZX2_OBS,ZX2_OBSLIB),ZX2_DATSOL,ZX2_HORSOL,ZX2_DATLIB,ZX2_HORLIB,nSaldo,nCusto,.F.})
		aAdd(aCols,{ZX2_FILIAL,ZX2_ITEM,ZX2_COD,cDesc,ZX2_QUANT,ZX2_PRCTAB,ZX2_PDESC,ZX2_VDESC,ZX2_VRUNIT,ZX2_TOTAL,ZX2_OBS,ZX2_OBSLIB,ZX2_DATSOL,ZX2_HORSOL,ZX2_DATLIB,ZX2_HORLIB,nSaldo,nCusto,.F.})
		dbSkip()
	Enddo

	dbSelectArea("PAG")
	dbSetOrder(1)
	dbSeek(xFilial("PAG")+cTipVnd)
	nTamCpo := 10
	If Found()
		cTipVnd := PAG_DESC
		nTamCpo := 60
	Endif


	dbSelectArea("ZX2")
	DEFINE MSDIALOG oDlgDesc FROM 000,000 TO 420,700 TITLE "Solicitação de descontos" Of oMainWnd PIXEL
	oPanel := TPanel():New(0,0,"",oDlgDesc, oDlgDesc:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 015,003 SCROLLBOX oScr SIZE 080,347 OF oDlgDesc
	oGetDesc := MSGetDados():New(000,000,078,345,nOpc,"U_DVTKA01V(.F.)",,,.F.,aAlter,,,Len(aCols),,,,, oScr)

	@ 100,003 SCROLLBOX oScr01 SIZE 105,347 OF oDlgDesc
	@ 003,003 SAY "Observação Geral:" PIXEL OF oScr01 SIZE 50,7
	@ 002,050 MEMO cObs PIXEL OF oScr01 SIZE 130,65 NO VSCROLL READONLY

	@ 003,190 SAY "Orçamento:" PIXEL OF oScr01 SIZE 40,7
	@ 002,240 GET cNum  PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 014,190 SAY "Tipo de Venda:" PIXEL OF oScr01 SIZE 40,7
	@ 013,240 GET cTipVnd  PIXEL OF oScr01 SIZE nTamCpo,7 WHEN .F.

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
	@ 068,240 Get SA1->A1_NOME PIXEL OF oScr01 SIZE 100,7 WHEN .F.

	@ 080,003 SAY "Vendedor:" PIXEL OF oScr01 SIZE 50,7
	@ 079,050 Get SA3->A3_COD PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	@ 080,190 SAY "Nome:" PIXEL OF oScr01 SIZE 50,7
	@ 079,240 Get SA3->A3_NREDUZ PIXEL OF oScr01 SIZE 100,7 WHEN .F.

	@ 091,003 SAY "Itens Orc.:" PIXEL OF oScr01 SIZE 50,7
	@ 090,050 Get nQtdItens PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	aButtons := {}
	aadd(aButtons,{"NOTE"     ,{|| VerObs() },"Obs"})
	aadd(aButtons,{"BMPVISUAL",{|| VerOrc() },"Orcamento"  })

	oDlgDesc:lMaximized := .F.
	ACTIVATE MSDIALOG oDlgDesc CENTERED ON INIT EnchoiceBar(oDlgDesc,{|| nClose:=1,Close(oDlgDesc) },{|| nClose:=2,Close(oDlgDesc)},,aButtons) VALID iif(nOpc=4,U_DVTKA01V(.T.),.T.)

	if nClose = 1
		If nX = 1
			For k = 1 to Len(aCols)
				If aCols[k,7] = 0
					lRecusa := .T.
					exit
				Endif
			Next k
		Endif


		For k=1 to Len(aCols)
			dbSelectArea("ZX2")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(cChave+aCols[k,2])
			If RecLock("ZX2",.F.)
				if !lRecusa
					ZX2->ZX2_PDESC  := aCols[k,7]
					ZX2->ZX2_VDESC  := aCols[k,8]
					ZX2->ZX2_VRUNIT := aCols[k,9]
					ZX2->ZX2_TOTAL  := aCols[k,10]
				Endif
				ZX2->ZX2_OBSLIB := aCols[k,12]
				MsUnlock()
			Endif
		Next k
	Endif
Return nClose

User Function DVTKA01V(lTodos)
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

Static Function AbreZX2
	Local cSql   := ""
	Local aEstru := {}
	Local aIndex := {}
	Local k      := 0

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZX2")
	
	Do While !eof() .AND. X3_ARQUIVO = "ZX2"
		IF X3_CONTEXT <> "V"
			aadd(aEstru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		Endif
		dbSkip()
	Enddo

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZX2")

	Do While !eof() .AND. INDICE = "ZX2"
		aadd(aIndex,{INDICE+ORDEM,AllTrim(CHAVE)})
		dbSkip()
	Enddo

	dbSelectArea("ZX2")
	dbCloseArea()

	if !Empty(cNomTmp)
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
	Endif

	cSql := "SELECT UA_CLIENTE,UA_LOJA,A1_NOME,UA_VEND,A3_NREDUZ,"
	For k=1 to Len(aEstru)
		cSql += AllTrim(aEstru[k,1])+iif(k < Len(aEstru),",","")
	Next
	cSql += " FROM "+RetSqlName("ZX2")+" ZX2"

	cSql += " JOIN "+RetSqlName("SUA")+" SUA"
	cSql += " ON   SUA.D_E_L_E_T_ = ''"
	cSql += " AND  UA_FILIAL = ZX2_FILIAL"
	cSql += " AND  UA_NUM = ZX2_ORC"

	cSql += " LEFT JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = ''"
	cSql += " AND  A1_COD = UA_CLIENTE"
	cSql += " AND  A1_LOJA = UA_LOJA"

	cSql += " LEFT JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = ''"
	cSql += " AND  A3_COD = UA_VEND"

	cSql += " WHERE ZX2.D_E_L_E_T_ = ''"
	cSql += " AND   ZX2_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   ZX2_OPER = '"+SU7->U7_COD+"'"
	cSql += " AND   ZX2_STATUS IN("+MontaIn(mv_par01)+")"
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
	dbUseArea(.T.,,cNomTmp,"ZX2",.F.,.F.)
	
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

User Function DVTKA01P()
	if Pergunte(cPerg,.T.)
		AbreZX2()
	Endif
Return


Static Function VerOrc()
	dbSelectArea("SUA")
	dbSetOrder(1)
	dbSeek(cChave)

	if !eof()
		TK271CallCenter("SUA",SUA->(Recno()),2)
	Else
		ApMsgStop("Erro ao localizar o orçamento")
	Endif
Return nil

Static Function VerObs()
	Local   cSql    := ""
	Local   aArea   := GetArea()
	Private aCampos := {}

	aadd(aCampos,{"ZX2_NUM"  ,"Solicitação","@!"})
	aadd(aCampos,{"ZX2_SEQ"  ,"Nivel"      ,"@!"})
	aadd(aCampos,{"U7_NREDUZ","Operador"   ,"@!"})
	aadd(aCampos,{"ZX2_OBS"  ,"Obsevação"  ,"@!"})


	cSql := "SELECT ZX2_NUM,ZX2_SEQ,U7_NREDUZ,"
	cSql += "     CASE"
	cSql += "         WHEN ZX2_TIPO = 'S' THEN ZX2_OBS"
	cSql += "         WHEN ZX2_TIPO = 'L' THEN ZX2_OBSLIB"
	cSql += "     END AS ZX2_OBS"
	cSql += " FROM "+RetSqlName("ZX2")+" ZX2"

	cSql += " LEFT JOIN "+RetSqlName("SU7")+" SU7"
	cSql += " ON   SU7.D_E_L_E_T_ = ''"
	cSql += " AND  U7_FILIAL = ''"
	cSql += " AND  U7_COD = ZX2_OPER"

	cSql += " WHERE ZX2.D_E_L_E_T_ = ''"
	cSql += " AND   ZX2_FILIAL || ZX2_ORC = '"+Substr(cChave,1,8)+"'"
	cSql += " AND   ZX2_ITEM = '"+aCols[n,2]+"'"
	//cSql += " AND   ZX2_SEQ < '"+cSeq+"'"
	cSql += " ORDER BY ZX2_NUM,ZX2_SEQ"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_OBS", .T., .T.)
	dbSelectArea("SQL_OBS")

	cNomObs := CriaTrab(,.F.)
	Copy to &cNomObs
	dbCloseArea()
	dbUseArea(.T.,,cNomObs,"TMP_OBS",.F.,.F.)

	DEFINE MSDIALOG oDlgObs FROM 000,000 TO 260,640 TITLE "Observações" Of oMainWnd PIXEL
	@ 001,001 TO 100,320 BROWSE "TMP_OBS" FIELDS aCampos
	@ 105,290 BMPBUTTON TYPE 1 ACTION Close(oDlgObs)
	dbSelectArea("ZX2")
	dbSkip(-1)
	IF !Empty(ZX2->ZX2_MOTREC)
		cMotRecTmp := ZX2->ZX2_MOTREC
		@ 105,005 SAY "Motivo Recusa: "+Tabela("X2",cMotRecTmp) Pixel
	Endif
	dbSkip()
	dbSelectArea("TMP_OBS")
	ACTIVATE DIALOG oDlgObs CENTERED

	dbCloseArea()
	RestArea(aArea)
Return nil

Static function DescMedio(cFil,cOrc,cSeq,cSol)
	Local aArea := GetArea()
	Local nVal  := 0
	Local cSql  := ""

	cSql := "SELECT (SUM((UB_QUANT * "
	cSql += "       (CASE"
	cSql += "             WHEN NOT ZX2_PDESC IS NULL THEN"
	cSql += "                 ZX2_VRUNIT"
	cSql += "             WHEN ZX2_PDESC IS NULL THEN"
	cSql += "                 UB_VRUNIT"
	cSql += "         END))) / SUM(UB_QUANT*UB_PRCTAB)) * 100 AS DESC_MEDIO"
	cSql += " FROM "+RetSqlName("SUB")+" SUB"

	cSql += " LEFT JOIN "+RetSqlName("ZX2")+" ZX2"
	cSql += " ON   ZX2.D_E_L_E_T_ = ''"
	cSql += " AND  ZX2_FILIAL = UB_FILIAL"
	cSql += " AND  ZX2_ORC = UB_NUM"
	cSql += " AND  ZX2_ITEM = UB_ITEM"
	cSql += " AND  ZX2_SEQ = '"+cSeq+"'"
	cSql += " AND  ZX2_NUM = '"+cSol+"'"

	cSql += " WHERE SUB.D_E_L_E_T_ = ''"
	cSql += " AND   UB_FILIAL = '"+cFil+"'"
	cSql += " AND   UB_NUM = '"+cOrc+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MEDIO", .T., .T.)
	TcSetField("SQL_MEDIO","DESC_MEDIO","N",6,2)
	dbSelectArea("SQL_MEDIO")
	nVal := 100-DESC_MEDIO
	dbCloseArea()
	RestArea(aArea)
Return nVal

User Function DVTKA01R()
	Local oBrw := GetMbrowse()
	Pergunte(cPerg,.F.)
	MsgRun("Atualizando visualização ...",,{|| AbreZX2(),dbGoTop() })
	oBrw:oCtlFocus:Refresh() //oBrw:Refresh() //SysRefresh()
Return

User Function DVTKA01T()
	Local oBrw := GetMbrowse()
	Define Timer oTmr01 INTERVAL 900000 ACTION U_DVTKA01R() OF oBrw
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

User Function DVTKA01X()
	Local lRet := .F.
	Local cItem := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == "ZX2_ITEM" })]

	dbSelectArea("ZX2")
	dbSetOrder(1)
	dbSeek(cChave+cItem+cSeq)

	If M->ZX2_PDESC = ZX2->ZX2_PDESC .OR. M->ZX2_PDESC = 0
		lRet := .T.
	Endif
Return lRet