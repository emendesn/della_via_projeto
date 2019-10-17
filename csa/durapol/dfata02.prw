#Include "DellaVia.ch"
#Include "rwmake.ch"
#Define VK_F12 123

User Function DFATA02()
	Local   cPerg     := "DFTA2X"
	Local   aRegs     := {}
	Private aRotina   := {}
	Private aCores    := {}
	Private aCampos   := {}
	Private cCampos   := ""
	Private cCadastro := "Proposta comercial"
	Private cAliasCab := "ZZ4"
	Private cAliasItm := "ZZ5"
	Private cMarca    := "X"
	Private cNomTmp   := ""
	Private cNomSIX   := ""
	Private uPar01,uPar02,uPar03

	// Matriz de definição dos menus
	aAdd(aRotina,{"Pesquisar"    ,"AxPesqui"      ,0,1})
	aAdd(aRotina,{"Visualizar"   ,"U_DFT02FUNC(0)",0,2})
	aAdd(aRotina,{"Incluir"      ,"U_DFT02FUNC(1)",0,3})
	aAdd(aRotina,{"Alterar"      ,"U_DFT02FUNC(7)",0,4})
	aAdd(aRotina,{"Revisar"      ,"U_DFT02FUNC(3)",0,4})
	aAdd(aRotina,{"Excluir"      ,"U_DFT02FUNC(2)",0,5})
	aAdd(aRotina,{"Efetivar"     ,"U_DFT02FUNC(5)",0,4})
	aAdd(aRotina,{"Reajuste"     ,"U_DFT02FUNC(4)",0,4})
	aAdd(aRotina,{"Recusar"      ,"U_DFT02FUNC(8)",0,4})
	aAdd(aRotina,{"Imp. Proposta","U_DFT02FUNC(6)",0,4})
	aAdd(aRotina,{"Parametros"   ,"U_DFT02PAR()"  ,0,4})
	aAdd(aRotina,{"Legenda"      ,"U_DFT02LEG()"  ,0,4})

	// Matriz de definição de cores da legenda
	aadd(aCores,{"ZZ4_STATUS='1'" ,"BR_VERDE"   })
	aadd(aCores,{"ZZ4_STATUS='2'" ,"BR_VERMELHO"})
	aadd(aCores,{"ZZ4_STATUS='3'" ,"BR_PRETO"})

	// Matriz com os campos do browse
	aAdd(aCampos,{"ZZ4_MARCA"  ,,""})
	aAdd(aCampos,{"ZZ4_CODREG" ,,""})
	aAdd(aCampos,{"ZZ4_VERSAO" ,,""})
	aAdd(aCampos,{"ZZ4_DESCRI" ,,""})
	aAdd(aCampos,{"ZZ4_CODCLI" ,,""})
	aAdd(aCampos,{"ZZ4_LOJA"   ,,""})
	aAdd(aCampos,{"A1_NOME"    ,,""})
	aAdd(aCampos,{"ZZ4_CODTAB" ,,""})
	aAdd(aCampos,{"ZZ4_CONDPG" ,,""})
	aAdd(aCampos,{"ZZ4_DATDE"  ,,""})

	dbSelectArea("SX3")
	dbSetOrder(2)
	For k=2 To Len(aCampos)
		dbSeek(AllTrim(aCampos[k,1]))
		If Found()
			aCampos[k,3] := AllTrim(X3_TITULO)
		Endif
	Next k
	dbSelectArea("SX3")
	dbSetOrder(1)

	aAdd(aRegs,{cPerg,"01","Propostas          ?"," "," ","mv_ch1","N", 01,0,0,"C","","mv_par01","Pendentes" ,"","","","","Ativas"  ,"","","","","Recusadas","","","","","Todas","","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"02","Do Vendedor        ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""          ,"","","","",""        ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"03","Ate o Vendedor     ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""          ,"","","","",""        ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""          })
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

	if !Pergunte(cPerg,.T.)
		Return
	Endif

	uPar01 := mv_par01
	uPar02 := mv_par02
	uPar03 := mv_par03

	MsgRun("Consultando banco de dados...",,{ || AbreTMP(.T.) })

	Set Key VK_F12 TO U_DFT02PAR()
	MarkBrow(cAliasCab,"ZZ4_MARCA","ZZ4->ZZ4_STATUS $ '2*3'",aCampos,,cMarca,"U_DFT02ALL()",,,,"U_DFT02MARK()",,,,aCores)
	Set Key VK_F12 TO
Return NIL


// EDICAO DE DADOS
User Function DFT02FUNC(nnTipo)
	nRecNo := ZZ4->RECNO

	FechaTMP(!(nnTipo == 5))

	dbSelectArea("ZZ4")
	dbSetOrder(1)
	dbGoTo(nRecNo)


	// Verifica Opção
	cOpcao:="VISUALIZAR"
	Do Case
		case nnTipo == 0
			cOpcao:="VISUALIZAR"
			nOpcE:=nOpcG:=2
		case nnTipo == 1
			cOpcao:="INCLUIR"
			nOpcE:=nOpcG:=3
		case nnTipo == 2
			If ZZ4->ZZ4_STATUS <> "1"
				MsgBox("Operação não realizada. Verifique o Status da revisão.","Proposta","STOP")
				AbreTMP(.T.)
				Return
			Endif

			cOpcao:="EXCLUIR"
			nOpcE:=nOpcG:=5
		case nnTipo == 3
			If !PodeRever(ZZ4->ZZ4_CODREG)
				MsgBox("Existem revisões pendentes para esta Proposta","Proposta","STOP")
				AbreTMP(.T.)
				Return
			Endif

			cOpcao:="REVISAR"
			nOpcE:=nOpcG:=4
		case nnTipo == 4
			cOpcao:="REAJUSTE"
			nOpcE:=nOpcG:=2
			Reajustar()
			AbreTMP(.T.)
			Return nil
		case nnTipo == 5
			cOpcao:="EFETIVAR"
			nOpcE:=nOpcG:=2
			MsgRun("Atualizando Regras de desconto ...",,{|| Efetivar() })
			AbreTMP(.T.)
			Return nil
		case nnTipo == 6
			cOpcao:="IMPRIMIR"
			nOpcE:=nOpcG:=2
			Imprimir()
			AbreTMP(.T.)
			Return nil
		case nnTipo == 7
			If ZZ4->ZZ4_STATUS <> "1"
				MsgBox("Operação não realizada. Verifique o Status da revisão.","Proposta","STOP")
				AbreTMP(.T.)
				Return
			Endif

			cOpcao:="ALTERAR"
			nOpcE:=nOpcG:=4
		case nnTipo == 8
			If ZZ4->ZZ4_STATUS = "1"
				cOpcao:="RECUSAR"
				nOpcE:=nOpcG:=4
				if msgbox("Deseja realmente recusar esta proposta?","Proposta","YESNO")
					RECUSAR()
				Endif
			Else
				MsgBox("Operação não realizada. Verifique o Status da revisão.","Proposta","STOP")
			Endif

			AbreTMP(.T.)
			Return nil
	EndCase
         
	// Carrega campos da tabela em variáveis
	RegToMemory(cAliasCab,(cOpcao=="INCLUIR"),.T.)

	// Array's para Enchoice
	aCpoEnchoice:={}
	aAltEnchoice:={}

	dbSelectArea("SX3")
	dbSeek(cAliasCab)
	Do While !Eof() .And. X3_ARQUIVO == cAliasCab
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
			aAdd(aAltEnchoice,AllTrim(X3_CAMPO))
			aAdd(aCpoEnchoice,AllTrim(X3_CAMPO))
		Endif
		DbSkip()
	End

	// Monta aHeader
	dbSelectArea("SX3")
	dbSeek(cAliasItm)
	aHeader:={}
	Do While !Eof() .And. X3_ARQUIVO == cAliasItm
		if X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
			aAdd(aHeader,{Trim(X3_TITULO) , X3_CAMPO , X3_PICTURE , X3_TAMANHO , X3_DECIMAL , X3_VALID , X3_USADO , X3_TIPO , X3_ARQUIVO , X3_CONTEXT})
		Endif
		dbSkip()
	Enddo


	// Carrega aCols
	aCols    := {}
	If cOpcao <> "INCLUIR"
		dbSelectArea(cAliasItm)
		dbSetOrder(1)
		dbSeek(xFilial(cAliasItm)+M->ZZ4_CODREG+M->ZZ4_VERSAO)

		Do While !eof() .and. xFilial(cAliasItm)==ZZ5_FILIAL .and. M->ZZ4_CODREG==ZZ5_CODREG .and. M->ZZ4_VERSAO==ZZ5_VERSAO
			aAdd(aCols , Array(Len(aHeader) + 1))
			For _ni:=1 to Len(aHeader)
				nPosCpo := FieldPos(aHeader[_ni,2])
				if nPosCpo > 0
					aCols[Len(aCols),_ni] := FieldGet(nPosCpo)
				Else
					If ExistIni(aHeader[_ni,2])
						aCols[Len(aCols),_ni] := InitPad(SX3->X3_RELACAO)
					Endif
				Endif
			Next 
			aCols[Len(aCols),Len(aHeader)+1]:=.F.
			dbSkip()
		Enddo
	Endif

	// Nao Existe Itens
	If Len(aCols) = 0
		aCols:={Array(Len(aHeader)+1)}
		aCols[1,Len(aHeader)+1]:=.F.
		For _ni:=1 to Len(aHeader)
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Next
	EndIf	

	If cOpcao == "REVISAR"
		M->ZZ4_VERSAO := ProxVer(M->ZZ4_CODREG)
		M->ZZ4_DATDE  := CTOD("//")
		M->ZZ4_MOTREC := ""
	Endif

	// Define e Abre janela para cadastro
	cTitulo :="Proposta Comercial"
	cLinOk  :="U_DFT02LinhaOk()"
	cTudOk  :="U_DFT02TudoOk()"
	cFieldOk:="AllwaysTrue()"
	If DFT02MOD3(Capital(Alltrim(cTitulo)+" - "+Alltrim(cOpcao)),cAliasCab,cAliasItm,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.T.,,aAltEnchoice)
		fSS_Salvar()
	Endif

	AbreTMP(.T.)
Return NIL

Static Function DFT02Mod3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze)
	Local lRet
	Local nOpca := 0
	Local cSaveMenuh
	Local nReg:=(cAlias1)->(Recno())
	Local oDlg

	Private Altera:=(cOpcao="ALTERAR")
	Private Inclui:=(cOpcao="INCLUIR")
	Private lRefresh:=.t.
	Private aTELA:=Array(0,0)
	Private aGets:=Array(0)
	Private bCampo:={|nCPO|Field(nCPO)}
	Private nPosAnt:=9999
	Private nColAnt:=9999
	Private cSavScrVT
	Private cSavScrVP
	Private cSavScrHT
	Private cSavScrHP
	Private CurLen
	Private nPosAtu:=0

	nOpcE    := IIf(nOpcE==Nil,3,nOpcE)
	nOpcG    := IIf(nOpcG==Nil,3,nOpcG)
	lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
	nLinhas  := 99
	lDel     := .T.

	DEFINE MSDIALOG oDlg TITLE cTitulo From 5,5 to 30,99 of oMainWnd
	EnChoice(cAlias1,nReg,nOpcE,,,,aMyEncho,{15,1,100,370},aAltEnchoice,3,,,,,,lVirtual)
	oGetDados := MsGetDados():New(101,1,185,370,nOpcG,cLinOk,cTudoOk,"",lDel,,nFreeze,,nLinhas,cFieldOk)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()})

	lRet:=(nOpca==1)
Return lRet

// validação de linha de itens
User Function DFT02LinhaOk()
	Local lRet    := .T.
	Local nCodPro := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "ZZ5_CODPRO"})
	Local cCodPro := aCols[n,nCodPro]

	For k=1 To Len(aCols)
		if !aCols[n,Len(aCols[n])] .AND. !aCols[k,Len(aCols[k])]
			If aCols[k,nCodPro] = cCodPro .AND. K <> N
				lRet := .F.
				msgbox("Este produto ja esta na proposta","Proposta","STOP")
				Exit
			Endif
		Endif
	Next
Return lRet

User Function DFT02TudoOk()
	Local lRet    := .F.
	Local nCodPro := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "ZZ5_CODPRO"})

	For k=1 To Len(aCols)
		if !aCols[k,Len(aCols[k])] .AND. !Empty(aCols[k,nCodPro])
			lRet := .T.
		Endif
	Next
	If !lRet
		msgbox("Não exitem itens cadastrados","Proposta","STOP")
	Endif

Return lRet

// Salva Informações
Static Function fSS_Salvar()
	#IFDEF TOP
		BeginTran()
	#EndIF   

	// Trata Cabecalho Enchoice
	DbSelectArea(cAliasCab)
	DbSetOrder(1)

	IF cOpcao == "INCLUIR" .OR. cOpcao == "REVISAR" .OR. cOpcao == "ALTERAR"
		If RecLock(cAliasCab,!(cOpcao == "ALTERAR"))
			For nCampo := 1 TO FCount()
				If "_FILIAL" $ FieldName(nCampo)
					FieldPut(nCampo,xFilial(cAliasCab))
				Else
					FieldPut(nCampo,M->&(FieldName(nCampo)))
				EndIf
			Next nCampo
			ZZ4->ZZ4_STATUS := "1"
			MsUnlock()
		Endif
	Elseif cOpcao == "EXCLUIR" 
		if RecLock(cAliasCab,.F.)
			Delete
			MsUnlock()
		Endif
	EndIf          


	// Trata Itens aCols
	DbSelectArea(cAliasItm)

	If cOpcao == "EXCLUIR"
		dbSelectArea(cAliasItm)
		dbSeek(xFilial(cAliasItm)+M->ZZ4_CODREG+M->ZZ4_VERSAO)
		Do While !eof() .AND. xFilial(cAliasItm) == ZZ5_FILIAL .AND. M->ZZ4_CODREG == ZZ5_CODREG .AND. M->ZZ4_VERSAO == ZZ4_VERSAO
			IF RecLock(cAliasItm,.F.)
				Delete
				MsUnlock()
			Endif
			dbSkip()
		Enddo
	ElseIF cOpcao == "INCLUIR" .OR. cOpcao == "REVISAR"
		For ii := 1 to Len(aCols)
			If aCols[ii,Len(aHeader)+1]  // Itens Excluidos
				Loop
			EndIf

			if RecLock(cAliasItm,.T.)
				// Campo de relacionameto com Cabec
				ZZ5->ZZ5_FILIAL := xFilial(cAliasItm)
				ZZ5->ZZ5_CODREG := M->ZZ4_CODREG
				ZZ5->ZZ5_VERSAO := M->ZZ4_VERSAO

				// Outros Campos
				For jj := 1 to Len(aHeader)
					nPosCpo := FieldPos(Alltrim(aHeader[jj,2]))
					If nPosCpo > 0
						FieldPut(nPosCpo,aCols[ii,jj])
					Endif
				Next                         
				MsUnLock()
			Endif
		Next
	ElseIF cOpcao == "ALTERAR"
		For ii := 1 to Len(aCols)
			dbSeek(xFilial(cAliasItm)+M->ZZ4_CODREG+M->ZZ4_VERSAO+aCols[ii,1])
			If aCols[ii,Len(aHeader)+1] .and. Found()
				if RecLock(cAliasItm,.F.)
					Delete
					MsUnLock()
				Endif
			Elseif !aCols[ii,Len(aHeader)+1]
				if RecLock(cAliasItm,!Found())
					// Campo de relacionameto com Cabec
					ZZ5->ZZ5_FILIAL := xFilial(cAliasItm)
					ZZ5->ZZ5_CODREG := M->ZZ4_CODREG
					ZZ5->ZZ5_VERSAO := M->ZZ4_VERSAO

					// Outros Campos
					For jj := 1 to Len(aHeader)
						nPosCpo := FieldPos(Alltrim(aHeader[jj,2]))
						If nPosCpo > 0
							FieldPut(nPosCpo,aCols[ii,jj])
						Endif
					Next                         
					MsUnLock()
				Endif
			Endif
		Next
	EndIf   

	#IFDEF TOP
		EndTran()
	#EndIF
Return NIL

User Function DFT02MARK()
	If RecLock("ZZ4",.F.)
		ZZ4->ZZ4_MARCA := iif(IsMark("ZZ4_MARCA",cMarca)," ",cMarca)
		MsUnLock()
	Endif
Return

User Function DFT02ALL()
	Local nRec  := RecNo()

	dbGotop()
	Do While !eof()
		If ZZ4->ZZ4_STATUS = "1"
			If RecLock("ZZ4",.F.)
				ZZ4->ZZ4_MARCA := "X"
				MsUnLock()
			Endif
		Endif
		dbSkip()
	Enddo	

	dbGoTo(nRec)

	MarkBRefresh()
Return nil

User Function DFT02LEG()
	BrwLegEnda(cCadastro,"Legenda", {{"BR_VERDE"    ,"Pendente" },;
									 {"BR_VERMELHO" ,"Ativa"    },;
									 {"BR_PRETO"    ,"Recusada" }} )
Return nil

Static Function ProxVer(cNum)
	Local aArea := GetArea()
	Local cSql  := ""
	Local cRet  := ""

	cSql := "SELECT RIGHT(RTRIM('000' || CHAR(INT(MAX(ZZ4_VERSAO))+1)),3) AS PROX"
	cSql += " FROM "+RetSqlName("ZZ4")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
	cSql += " AND   ZZ4_CODREG = '"+cNum+"'"
	cSql += " AND   ZZ4_STATUS IN('2','3')"
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cSql), "ARQ_SQL", .F., .T.)
	cRet := PROX
	dbCloseArea()

	RestArea(aArea)
Return cRet

Static Function Efetivar()
	Local cSql  := ""
	Local aArea := GetArea()

	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	Do While !eof()
		If TMP->ZZ4_MARCA = "X"
			dbSelectArea("ZZ4")
			dbGoTo(TMP->RECNO)
			If RecLock("ZZ4",.F.)
				ZZ4->ZZ4_MARCA := "X"
				MsUnLock()
			Endif
		Endif


		dbSelectArea("TMP")
		dbSkip()
	Enddo

	cSql := "SELECT ZZ4_FILIAL,ZZ4_CODREG,ZZ4_VERSAO"
	cSql += " FROM "+RetSqlName("ZZ4")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
	cSql += " AND   ZZ4_STATUS = '1'"
	cSql += " AND   ZZ4_MARCA = 'X'"
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cSql), "ARQ_SQL", .F., .T.)

	dbSelectArea("ARQ_SQL")
	Do While !eof()
		dbSelectArea("ZZ4")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(ARQ_SQL->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO))

		BeginTran()

		If RecLock("ZZ4",.F.)
			ZZ4->ZZ4_MARCA  := " "
			ZZ4->ZZ4_STATUS := "2"
			MsUnLock()
		Endif

		GravaRegra()

		EndTran()

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()

	dbSelectArea("TMP")
	dbCloseArea()

	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	RestArea(aArea)
Return nil

Static Function Reajustar()
	Local   aArea := GetArea()
	Local   cSql  := ""
	Private aRegs := {}
	Private cPerg := "DFTA2A"

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	aAdd(aRegs,{cPerg,"01","Cliente            ?"," "," ","mv_ch1","N", 01,0,0,"C","","mv_par01","Ativos" ,"","","","","Todos"  ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"02","Do Cliente         ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"03","Ate o Cliente      ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"04","Reajuste (%)       ?"," "," ","mv_ch4","N", 08,4,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Do Inicio em       ?"," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })

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

	if !Pergunte(cPerg,.T.)
		Return
	Endif

	cSql := "SELECT ZZ4_FILIAL,ZZ4_CODREG,MAX(ZZ4_VERSAO) AS ZZ4_VERSAO"
	cSql += " FROM "+RetSqlName("ZZ4")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
	cSql += " AND   ZZ4_CODCLI BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cSql += " AND   ZZ4_DATDE >= '"+dtos(mv_par05)+"'"
	If mv_par01 = 1 // Cliente ativos a 10 meses
		cSql += " AND ZZ4_CODCLI || ZZ4_LOJA"
		cSql += " IN(SELECT DISTINCT F2_CLIENTE || F2_LOJA"
		cSql += "       FROM "+RetSqlName("SF2")
		cSql += "       WHERE D_E_L_E_T_ = ''"
		cSql += "       AND   F2_FILIAL BETWEEN '' AND 'ZZ'"
		cSql += "       AND   F2_TIPO = 'N'"
		cSql += "       AND   F2_EMISSAO >= '"+dtos(dDataBase-300)+"'"
		cSql += ")"
	Endif
	cSql += " GROUP BY ZZ4_FILIAL,ZZ4_CODREG"
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cSql), "SQL_REA", .F., .T.)

	dbSelectArea("SQL_REA")
	Do While !eof()
		cVersao := ProxVer(ZZ4_CODREG)
		dbSelectArea("ZZ4")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(SQL_REA->(ZZ4_FILIAL+ZZ4_CODREG)+cVersao)
		If !Found()
			cSql := "SELECT ZZ4.*,ZZ5.*,DA1_PRCVEN"
			cSql += " FROM "+RetSqlName("ZZ4")+" ZZ4"

			cSql += " JOIN "+RetSqlName("ZZ5")+" ZZ5"
			cSql += " ON   ZZ5.D_E_L_E_T_ = ''"
			cSql += " AND  ZZ5_FILIAL = ZZ4_FILIAL"
			cSql += " AND  ZZ5_CODREG = ZZ4_CODREG"
			cSql += " AND  ZZ5_VERSAO = ZZ4_VERSAO"

			cSql += " LEFT JOIN DA1030 DA1"
			cSql += " ON   DA1.D_E_L_E_T_ = ''"
			cSql += " AND  DA1_FILIAL = '"+xFilial("DA1")+"'"
			cSql += " AND  DA1_CODTAB = ZZ4_CODTAB"
			cSql += " AND  DA1_CODPRO = ZZ5_CODPRO"

			cSql += " WHERE ZZ4.D_E_L_E_T_ = ''"
			cSql += " AND   ZZ4_FILIAL = '"+SQL_REA->ZZ4_FILIAL+"'"
			cSql += " AND   ZZ4_CODREG = '"+SQL_REA->ZZ4_CODREG+"'"
			cSql += " AND   ZZ4_VERSAO = '"+SQL_REA->ZZ4_VERSAO+"'"
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cSql), "SQL_INC", .F., .T.)

			dbSelectArea("SQL_INC")
			If !eof()
				dbSelectArea("ZZ4")
				If RecLock("ZZ4",.T.)
					For k=1 to Len(dbStruct())
						cCpo := Field(k)
						FieldPut(k,SQL_INC->(&cCpo))
					Next k
					ZZ4->ZZ4_VERSAO := cVersao
					ZZ4->ZZ4_STATUS := "1"
					ZZ4->ZZ4_DATDE  := dDataBase
					MsUnLock()
				Endif
			Endif

			dbSelectArea("SQL_INC")
			Do While !eof()
				dbSelectArea("ZZ5")
				If RecLock("ZZ5",.T.)
					For k=1 to Len(dbStruct())
						cCpo := Field(k)
						FieldPut(k,SQL_INC->(&cCpo))
					Next k
					ZZ5->ZZ5_VERSAO := cVersao
					ZZ5->ZZ5_PRCVEN := ZZ5->ZZ5_PRCVEN * (1+(mv_par04/100))
					ZZ5->ZZ5_PERDES := iif(ZZ5->ZZ5_PRCVEN < SQL_INC->DA1_PRCVEN,100-(ZZ5->ZZ5_PRCVEN/(SQL_INC->DA1_PRCVEN/100)),0)
					ZZ5->ZZ5_PERACR := iif(ZZ5->ZZ5_PRCVEN > SQL_INC->DA1_PRCVEN,(ZZ5->ZZ5_PRCVEN/(SQL_INC->DA1_PRCVEN/100))-100,0)
					MsUnLock()
				Endif
				
				dbSelectArea("SQL_INC")
				dbSkip()
			Enddo
			dbCloseArea()
		Endif

		dbSelectArea("SQL_REA")
		dbSkip()
	Enddo
	dbCloseArea()

	RestArea(aArea)
Return nil

Static Function PodeRever(cNum)
	Local aArea := GetArea()
	Local lRet  := ""
	Local cSql  := ""

	cSql := "SELECT ZZ4_FILIAL,ZZ4_CODREG,MAX(ZZ4_VERSAO) AS ZZ4_VERSAO"
	cSql += " FROM "+RetSqlName("ZZ4")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
	cSql += " AND   ZZ4_CODREG = '"+cNum+"'"
	cSql += " GROUP BY ZZ4_FILIAL,ZZ4_CODREG"
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cSql), "SQL_TST", .F., .T.)

	dbSelectArea("ZZ4")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(SQL_TST->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO))

	lRet := (ZZ4_STATUS <> "1")

	dbSelectArea("SQL_TST")
	dbCloseArea()

	If lRet
		dbSelectArea("ZZ4")
	Else
		RestArea(aArea)
	Endif
Return lRet

Static Function Imprimir()
	Local aArea := GetArea()
	Local nOp   := 0

	DEFINE MSDIALOG oDlgImp TITLE "Imprimir" From 0,0 To 040,190 OF oMainWnd Pixel
		@ 05,05 BUTTON "Carta"    Size 40,10 Action ( nOp:=1,Close(oDlgImp) )
		@ 05,50 BUTTON "Proposta" Size 40,10 Action ( nOp:=2,Close(oDlgImp) )
	ACTIVATE MSDIALOG oDlgImp CENTERED

	if nOp = 1
		Carta()
	Elseif nOp = 2
		Proposta()		
	Endif

	RestArea(aArea)
Return 

Static Function Carta()
	Private cPerg  := "DFTA2B"
	Private aRegs  := {}

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	
	aAdd(aRegs,{cPerg,"01","Cliente            ?"," "," ","mv_ch1","N",01,0,0,"C","","mv_par01","Ativos","","","","","Todos"   ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","",""          })
	AADD(aRegs,{cPerg,"02","Do Cliente         ?"," "," ","mv_ch2","C",06,0,0,"G","","mv_par02",""      ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"03","Até o Cliente      ?"," "," ","mv_ch3","C",06,0,0,"G","","mv_par03",""      ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"04","Inicio             ?"," "," ","mv_ch4","D",08,0,0,"G","","mv_par04",""      ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"05","Reajuste (%)       ?"," "," ","mv_ch5","N",08,4,0,"G","","mv_par05",""      ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"06","Compras            ?"," "," ","mv_ch6","D",08,0,0,"G","","mv_par06",""      ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"07","Pessoa             ?"," "," ","mv_ch7","N",01,0,0,"C","","mv_par07","Fisica","","","","","Juridica","","","","","Ambas"  ,"","","","","","","","","","","","","",""   ,"","","",""          })

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

	iF Pergunte(cPerg,.T.)
		Processa({|| ImpCarta() },"Carta de reajuste",,.t.)
	Endif
Return

Static Function ImpCarta()
	Local aMeses := {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
	Local cSql   := ""
	Local cData  := "São Paulo, "+Strzero(Day(dDataBase),2)+" de "+aMeses[Month(dDataBase)]+" de "+Strzero(Year(dDataBase),4)

	cSql := "SELECT DISTINCT ZZ4_CODCLI,ZZ4_LOJA,A1_NOME"
	cSql += " FROM "+RetSqlName("ZZ4")+" ZZ4"

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = ZZ4_CODCLI"
	cSql += " AND  A1_LOJA = ZZ4_LOJA"
	cSql += " AND  A1_VEND4 BETWEEN '"+uPar02+"' AND '"+uPar03+"'"
	If mv_par07 = 1
		cSql += " AND A1_PESSOA = 'F'"
	Elseif mv_par07 = 2
		cSql += " AND A1_PESSOA <> 'F'"
	Endif

	cSql += " WHERE ZZ4.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
	cSql += " AND   ZZ4_CODCLI BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cSql), "ARQ_SQL", .F., .T.)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)

	oPrint := TMSPrinter():New("Proposta Comercial")
	oPrint:SetPortrait() // ou SetLandscape()

	DEFINE FONT oFont10  NAME "Times New Roman" SIZE 10,10
	DEFINE FONT oFont14n NAME "Times New Roman" SIZE 14,14 BOLD
	DEFINE FONT oFont14  NAME "Arial"           SIZE 12,12 BOLD
	DEFINE FONT oFont20n NAME "Arial Black"     SIZE 18,18 BOLD

	Do While !Eof()
		incProc("Imprimindo...")

		oPrint:StartPage()   // Inicia uma nova página
		ImpCab()
		oPrint:Say(0600,1500,cData,oFont14n)
		oPrint:Say(0800,0100,"À "+Capital(A1_NOME),oFont14n)
		oPrint:Say(1000,0100,"Prezado cliente,",oFont14n)
		oPrint:Say(1200,0100,"Vimos pela presente informar que a partir de "+dtoc(mv_par04)+", estaremos repassando o reajuste de "+AllTrim(Str(mv_par05))+"% nas",oFont14n)
		oPrint:Say(1250,0100,"reformas de pneus devido ao aumento nos impostos pelos nossos fornecedores de borracha e insumos"                                ,oFont14n)
		oPrint:Say(1300,0100,"como cola, ligação, etc."                                                                                                        ,oFont14n)
		oPrint:Say(1350,0100,"Para conhecimento aos Srs. toda as nossas compras realizadas já a partir do dia "+dtoc(mv_par06)+" estão rejustadas."            ,oFont14n)
		oPrint:Say(1400,0100,"Por este fato necessitamos urgentemente da compreensão de todos, ja que estamos a dois anos sem "                                ,oFont14n)
		oPrint:Say(1450,0100,"qualquer reajuste ou correção de valores."                                                                                       ,oFont14n)
		oPrint:Say(1500,0100,"Desde ja agradecemos a atenção e nos colocamos a disposição para quaisquer esclarecimentos."                                     ,oFont14n)
		oPrint:Say(1600,0100,"Sem mais,"                                                                                                                       ,oFont14n)
		oPrint:Say(1700,1500,"Atenciosamente"                                                                                                                  ,oFont14n)
		oPrint:Say(2000,1300,"____________________________________"                                                                                            ,oFont14n)
		oPrint:Say(2050,1300,"DURAPOL RENOVADORA DE PNEUS"                                                                                                     ,oFont14n)
		ImpRoda()
		oPrint:EndPage()     // Finaliza a página

		dbSkip()
	Enddo
	dbCloseArea()

	oPrint:Preview()     // Visualiza antes de imprimir
Return

Static Function ImpCab()
	oPrint:SayBitmap(0050,0050,AllTrim(GetSrvProfString("Startpath",""))+"\Durapol\durapol.bmp",359,129)
	oPrint:Say(0050,0500,"DURAPOL RENOVADORA DE PNEUS LTDA",oFont20n)
	oPrint:Say(0120,0650,"CNPJ: 43.427.517/0001-74      Insc. Estadual: 108.796.490.114",oFont14)
	oPrint:Line(0200,0050,0200,2300)
	oPrint:SayBitmap(0210,1980,AllTrim(GetSrvProfString("Startpath",""))+"\Durapol\vipal.bmp"   ,146,048)
	oPrint:SayBitmap(0210,2150,AllTrim(GetSrvProfString("Startpath",""))+"\Durapol\novateck.bmp",147,055)
Return

Static Function ImpRoda()
	oPrint:Line(3000,0050,3000,2300)
	oPrint:Say(3010,0100,"Av. Presidente Wilson 6000 Vl. Carioca - Ipiranga - CEP:04220-002 São Paulo - SP Tel:6167.1234 / Fax:6167.1235 - e-mail:durapol@dellavia.com.br",oFont10)
Return

Static Function Proposta()
	Private cPerg  := "DFTA2C"
	Private aRegs  := {}

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	
	aAdd(aRegs,{cPerg,"01","Propostas          ?"," "," ","mv_ch1","N",01,0,0,"C","","mv_par01","Pendentes","","","","","Ativas"  ,"","","","","Todas","","","","","","","","","","","","","",""   ,"","","",""          })
	AADD(aRegs,{cPerg,"02","Do Cliente         ?"," "," ","mv_ch2","C",06,0,0,"G","","mv_par02",""         ,"","","","",""        ,"","","","",""     ,"","","","","","","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"03","Até o Cliente      ?"," "," ","mv_ch3","C",06,0,0,"G","","mv_par03",""         ,"","","","",""        ,"","","","",""     ,"","","","","","","","","","","","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"04","Pessoa             ?"," "," ","mv_ch4","N",01,0,0,"C","","mv_par04","Fisica"   ,"","","","","Juridica","","","","","Ambas","","","","","","","","","","","","","",""   ,"","","",""          })

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

	iF Pergunte(cPerg,.T.)
		Processa({|| ImpProposta() },"Proposta Comercial",,.t.)
	Endif
Return

Static Function ImpProposta()
	Local aMeses := {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
	Local cSql   := ""
	Local cData  := "São Paulo, "+Strzero(Day(dDataBase),2)+" de "+aMeses[Month(dDataBase)]+" de "+Strzero(Year(dDataBase),4)

	cSql := "SELECT ZZ4_FILIAL,ZZ4_CODREG,A1_NOME,MAX(ZZ4_VERSAO) AS ZZ4_VERSAO"
	cSql += " FROM "+RetSqlName("ZZ4")+" ZZ4"

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = ZZ4_CODCLI"
	cSql += " AND  A1_LOJA = ZZ4_LOJA"
	cSql += " AND  A1_VEND4 BETWEEN '"+uPar02+"' AND '"+uPar03+"'"
	If mv_par04 = 1
		cSql += " AND A1_PESSOA = 'F'"
	Elseif mv_par04 = 2
		cSql += " AND A1_PESSOA <> 'F'"
	Endif

	cSql += " WHERE ZZ4.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
	cSql += " AND  ZZ4_CODCLI BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cSql += " GROUP BY ZZ4_FILIAL,ZZ4_CODREG,A1_NOME"

	dbUseArea( .T., "TOPCONN", TCGenQry(,,cSql), "ARQ_SQL", .F., .T.)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)

	oPrint := TMSPrinter():New("Proposta Comercial")
	oPrint:SetPortrait() // ou SetLandscape()

	DEFINE FONT oFont10  NAME "Times New Roman" SIZE 10,10
	DEFINE FONT oFont14n NAME "Times New Roman" SIZE 14,14 BOLD
	DEFINE FONT oFont14  NAME "Arial"           SIZE 12,12 BOLD
	DEFINE FONT oFont20n NAME "Arial Black"     SIZE 18,18 BOLD

	Do While !Eof()
		incProc("Imprimindo...")

		dbSelectArea("ZZ4")
		dbSetOrder(1)
		dbSeek(ARQ_SQL->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO))
		dbSelectArea("ARQ_SQL")

		if mv_par01 <> 3 .and. ZZ4->ZZ4_STATUS <> StrZero(mv_par01,1)
			dbSkip()
			Loop
		Endif

		oPrint:StartPage()   // Inicia uma nova página
		ImpCab()
		oPrint:Say(0600,1500,cData,oFont14n)
		oPrint:Say(0800,0050,"À "+Capital(A1_NOME),oFont14n)
		oPrint:Say(1000,0050,"Prezado cliente,",oFont14n)
		oPrint:Say(1200,0050,"Atuando no ramo de reforma de pneus há mais de 30 anos, em constante atualização de processo e",oFont14n)
		oPrint:Say(1250,0050,"procedimentos, tem a presente como finalidade apresentar nossa empresa para participação no processo",oFont14n)
		oPrint:Say(1300,0050,"de reforma de pneus para V.sa.",oFont14n)
		oPrint:Say(1350,0050,"Utilizando avançadas técnicas, modernos equipamentos e material de primeira qualidade, fornecidor pelos",oFont14n)
		oPrint:Say(1400,0050,"principais fabricantes de materias par reforma e Cias fabricantes de pneus, executando serviços de",oFont14n)
		oPrint:Say(1450,0050,"RECAPAGEM em pneus RADIAIS e CONVENCIONAIS (sistema PRÉ-MOLDADO VIPAL) oferecendo",oFont14n)
		oPrint:Say(1500,0050,"assitência técnica e economia por Km rodado.",oFont14n)
		oPrint:Say(1550,0050,"Reformador credenciado pelas Cias de pneus, dispondo atualmente da condição MASTER que oferece um ",oFont14n)
		oPrint:Say(1600,0050,"novo patamar de qualidade na reforma de pneus.",oFont14n)
		oPrint:Say(1650,0050,"Retirada e entrega dos pneus feitos por frota própria (veículos com carroceria baú e seguro) e profissionais",oFont14n)
		oPrint:Say(1700,0050,"treinados, garantindo que os pneus serão devolvidos à sua empresa com segurança, rapidez e pontualidade.",oFont14n)
		oPrint:Say(1750,0050,"Com objetivo de oferecer uma linha completa de produtos, uniu forças com a Della Via Pneus, um dos",oFont14n)
		oPrint:Say(1800,0050,"maiores revendedores Pirelli do Brasil.",oFont14n)
		oPrint:Say(1850,0050,"Finalmente desejamos registrar nosso convite para uma visita em nossas instalações em São Paulo.",oFont14n)
		ImpRoda()
		oPrint:EndPage()     // Finaliza a página

		oPrint:StartPage()   // Inicia uma nova página
		ImpCab()
		oPrint:Say(0300,0050,"Atendendo a vossa solicitação passamos abaixo nossos preço para reforma de pneus:",oFont14n)
		oPrint:Box(0400,0050,0500,0500)
		oPrint:Box(0400,0500,0500,0950)
		oPrint:Box(0400,0950,0500,1550)
		oPrint:Box(0400,1550,0500,2000)

		oPrint:Say(0420,0100,"Código",oFont14n)
		oPrint:Say(0420,0550,"Medida",oFont14n)
		oPrint:Say(0420,1000,"Serviço / Banda",oFont14n)
		oPrint:Say(0420,1600,"Pré-Moldado (R$)",oFont14n)
		
		dbSelectArea("ZZ4")
		dbSetOrder(1)
		dbSeek(ARQ_SQL->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO))		

		dbSelectArea("ZZ5")
		dbSetOrder(1)
		dbSeek(ARQ_SQL->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO))		
		
		nRow := 500
		Do While !eof() .and. ZZ5->(ZZ5_FILIAL+ZZ5_CODREG+ZZ5_VERSAO) = ARQ_SQL->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO)
			If nRow > 2800
				nRow := 300
				ImpRoda()
				oPrint:EndPage()
				oPrint:StartPage()
				ImpCab()
			Endif			

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+ZZ5->ZZ5_CODPRO)
			dbSelectArea("ZZ5")

			If SB1->B1_GRUPO <> "SERV"
				dbSkip()
				Loop
			Endif

			oPrint:Box(nRow,0050,nRow+100,0500)
			oPrint:Box(nRow,0500,nRow+100,0950)
			oPrint:Box(nRow,0950,nRow+100,1550)
			oPrint:Box(nRow,1550,nRow+100,2000)

			oPrint:Say(nRow+20,0100,ZZ5_CODPRO,oFont14)
			oPrint:Say(nRow+20,0550,SB1->B1_PRODUTO,oFont14)
			oPrint:Say(nRow+20,1000,iif(" DIR" $ Upper(AllTrim(SB1->B1_DESC)),"Direcional","Tração"),oFont14)
			oPrint:Say(nRow+20,1600,Transform(ZZ5_PRCVEN,"@e 99,999,999,999.99"),oFont14)

			nRow += 100
			dbSkip()
		Enddo

		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+ZZ4->ZZ4_CONDPG)

		oPrint:Say(nRow+50,0050,"Cond. Pagto:",oFont14n)
		oPrint:Say(nRow+60,0350,AllTrim(E4_DESCRI),oFont14)
		nRow += 100
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA)

		If nRow > 2600
			nRow := 300
			ImpRoda()
			oPrint:EndPage()
			oPrint:StartPage()
			ImpCab()
		Endif			

		oPrint:Say(nRow+50,0050,"Motorista:",oFont14n)
		oPrint:Say(nRow+60,0350,Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND3,"SA3->A3_NOME"),oFont14)
		nRow += 50
		oPrint:Say(nRow+50,0050,"Vendedor:",oFont14n)
		oPrint:Say(nRow+60,0350,Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND4,"SA3->A3_NOME"),oFont14)
		nRow += 50
		oPrint:Say(nRow+50,0050,"Indicador:",oFont14n)
		oPrint:Say(nRow+60,0350,Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND5,"SA3->A3_NOME"),oFont14)
		nRow += 200

		If nRow > 2600
			nRow := 300
			ImpRoda()
			oPrint:EndPage()
			oPrint:StartPage()
			ImpCab()
		Endif			

		oPrint:Say(nRow,1500,"Atenciosamente,",oFont14n)
		oPrint:Say(nRow+0300,1300,"____________________________________",oFont14n)
		oPrint:Say(nRow+0350,1300,"             Departamento Comercial",oFont14n)



		ImpRoda()
		oPrint:EndPage()     // Finaliza a página

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()

	oPrint:Preview()     // Visualiza antes de imprimir
Return


Static Function AbreTMP(lSIX)
	Local cSql := ""

	dbSelectArea("ZZ4")
	dbCloseArea()

	cSql := "SELECT ZZ4_FILIAL,ZZ4_CODREG,ZZ4_VERSAO,ZZ4_DESCRI,ZZ4_CODCLI,ZZ4_LOJA,A1_NOME,ZZ4_CODTAB,ZZ4_CONDPG,ZZ4_DATDE,ZZ4_MARCA,ZZ4_STATUS,ZZ4.R_E_C_N_O_ AS RECNO"
	cSql += " FROM "+RetSqlName("ZZ4")+" ZZ4"

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = ZZ4_CODCLI"
	cSql += " AND  A1_LOJA = ZZ4_LOJA"
	cSql += " AND  A1_VEND4 BETWEEN '"+uPar02+"' AND '"+uPar03+"'"

	cSql += " WHERE ZZ4.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ4_FILIAL = '"+xFilial("ZZ4")+"'"
	If uPar01 <> 4
		cSql += " AND ZZ4_STATUS = '"+StrZero(uPar01,1)+"'"
	Endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	TcSetField("ARQ_SQL","ZZ4_DATDE","D")

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"ZZ4",.F.,.F.)
	IndRegua("ZZ4",cNomTmp,"ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO",,,"Selecionando Registros...")

	If lSIX
		AbreSIX()
	Endif
Return nil

Static Function AbreSIX()
	dbSelectArea("SIX")
	aEstru := dbStruct()
	dbCloseArea()
	cNomSIX := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
	IndRegua("SIX",cNomSIX,"INDICE+ORDEM",,,"Selecionando Registros...")

	If RecLock("SIX",.T.)
		SIX->INDICE    := "ZZ4"
		SIX->ORDEM     := "1"
		SIX->CHAVE     := "ZZ4_FILIAL+ZZ4_CODREG+ZZ4_SERIE"
		SIX->DESCRICAO := "Proposta + Revisao"
		SIX->DESCSPA   := ""
		SIX->DESCENG   := ""
		SIX->PROPRI    := "U"
		SIX->F3        := ""
		SIX->NICKNAME  := ""
		SIX->SHOWPESQ  := "S"
		MsUnLock()
	Endif
Return nil

Static Function FechaTMP(lApaga)
	Default lApaga := .T.

	dbSelectArea("ZZ4")
	dbCloseArea()

	If lApaga
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
	Endif

	dbSelectArea("SIX")
	dbCloseArea()
	fErase(cNomSIX+GetDbExtension())
	fErase(cNomSIX+OrdBagExt())
	
	dbUseArea(.T.,,"SIX"+Substr(cNumEmp,1,2)+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+Substr(cNumEmp,1,2)+"0")

	ChkFile("ZZ4")
Return nil

User Function DFT02PAR()
	Local cPerg := "DFTA2X"

	If !Pergunte(cPerg,.T.)
		Return nil
	Endif

	uPar01 := mv_par01
	uPar02 := mv_par02
	uPar03 := mv_par03

	MsgRun("Consultando banco de dados...",,{ || AbreTMP(.F.) })
	dbSelectArea("ZZ4")
Return nil

Static Function RECUSAR()
	Local cMot := Space(20)

	DEFINE MSDIALOG oDlgMot FROM 000,000 TO 050,400 TITLE "Recusar - Motivo" Pixel
	@ 005,005 SAY "Motivo:" PIXEL OF oDlgMot SIZE 40,7
	@ 004,030 GET cMot  PIXEL OF oDlgMot SIZE 100,7 PICTURE "@!" VALID !Empty(cMot)
	@ 003,150 BMPBUTTON TYPE 1 ACTION Close(oDlgMot)
	ACTIVATE MSDIALOG oDlgMot CENTERED VALID !Empty(cMot)

	If RecLock("ZZ4",.F.)
		ZZ4->ZZ4_STATUS := "3"
		ZZ4->ZZ4_MOTREC := cMot
		MsUnLock()
	Endif
Return nil

Static Function GravaRegra()
	Local lAchou := .F.
	Local cSql   := ""
	Local nUpdt  := 0

	dbSelectArea("ACO")
	dbSetOrder(1)
	dbSeek(xFilial("ACO")+ZZ4->ZZ4_CODREG)
	lAchou := Found()

	If RecLock("ACO",!lAchou)
		ACO->ACO_FILIAL := xFilial("ACO")
		ACO->ACO_CODREG := ZZ4->ZZ4_CODREG
		ACO->ACO_DESCRI := ZZ4->ZZ4_DESCRI
		ACO->ACO_CODCLI := ZZ4->ZZ4_CODCLI
		ACO->ACO_LOJA   := ZZ4->ZZ4_LOJA
		ACO->ACO_CODTAB := ZZ4->ZZ4_CODTAB
		ACO->ACO_CONDPG := ZZ4->ZZ4_CONDPG
		ACO->ACO_FORMPG := ZZ4->ZZ4_FORMPG
		ACO->ACO_FAIXA  := ZZ4->ZZ4_FAIXA
		ACO->ACO_MOEDA  := 1
		ACO->ACO_PERDES := ZZ4->ZZ4_PERDES
		ACO->ACO_TPHORA := ZZ4->ZZ4_TPHORA
		ACO->ACO_HORADE := "00:00"
		ACO->ACO_HORATE := "23:59"
		ACO->ACO_DATDE  := ZZ4->ZZ4_DATDE
		MsUnLock()
	Endif

	If lAchou
		cSql := "DELETE FROM "+RetSqlName("ACP")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ACP_FILIAL = '"+xFilial("ACP")+"'"
		cSql += " AND   ACP_CODREG = '"+ZZ4->ZZ4_CODREG+"'"
		nUpdt := TcSqlExec(cSql)
	
		If nUpdt < 0
			MsgBox(TcSqlError(),"Proposta","STOP")
		Endif
	Endif

	dbSelectArea("ZZ5")
	dbSetOrder(1)
	dbSeek(ZZ4->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO))

	Do While !eof() .AND. ZZ5->(ZZ5_FILIAL+ZZ5_CODREG+ZZ5_VERSAO) = ZZ4->(ZZ4_FILIAL+ZZ4_CODREG+ZZ4_VERSAO)
		dbSelectArea("ACP")
		If RecLock("ACP",.T.)
			ACP->ACP_FILIAL := xFilial("ACP")
			ACP->ACP_CODREG := ZZ5->ZZ5_CODREG
			ACP->ACP_ITEM   := ZZ5->ZZ5_ITEM
			ACP->ACP_CODPRO := ZZ5->ZZ5_CODPRO
			ACP->ACP_PERDES := ZZ5->ZZ5_PERDES
			ACP->ACP_PERACR := ZZ5->ZZ5_PERACR
			ACP->ACP_PRCVEN := ZZ5->ZZ5_PRCVEN
			MsUnLock()
		Endif
		dbSelectArea("ZZ5")
		dbSkip()
	Enddo
Return nil