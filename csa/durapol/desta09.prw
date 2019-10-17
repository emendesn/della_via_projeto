#Include "DellaVia.ch"
#Include "rwmake.ch"

User Function DESTA09()
	Private aRotina   := {}
	Private aCores    := {}
	Private cCadastro := ""
	Private cAliasCab := "ZZ2"
	Private cAliasItm := "ZZ3"
	Private cMarca    := "X"
	//Private	xcpo	  := "?"
	cCadastro := "Pré Coleta"

	// Matriz de definição dos menus
	aAdd(aRotina,{"Pesquisar"    ,"AxPesqui"      ,0,1})  //"Pesquisar"
	aAdd(aRotina,{"Visualizar"   ,"U_DST09FUNC(0)",0,2})  //"Visual"
	aAdd(aRotina,{"Incluir"      ,"U_DST09FUNC(1)",0,3})  //"Incluir"
	aAdd(aRotina,{"Alterar"      ,"U_DST09FUNC(2)",0,4})  //"Alterar"
	aAdd(aRotina,{"Excluir"      ,"U_DST09FUNC(3)",0,5})  //"Excluir"
	aAdd(aRotina,{"Marcar"       ,"U_DST09SELE()" ,0,4})  //"Marcar Registros"
	aAdd(aRotina,{"Desmarcar"    ,"U_DST09DESM()" ,0,4})  //"Desmarcar Registros"
	aAdd(aRotina,{"Gerar Coleta" ,"U_DST09GERA()" ,0,4})  //"Gerar Coleta"
	aAdd(aRotina,{"Legenda"      ,"U_DST09LEG()"  ,0,4})  // Legenda
	aAdd(aRotina,{"Imprime Ficha","U_DST09FICH()" ,0,4})  // Imprime Ficha 

	// Matriz de definição de cores da legEnda
	aadd(aCores,{"ZZ2_STATUS='1'" ,"BR_VERDE"   })
	aadd(aCores,{"ZZ2_STATUS='2'" ,"BR_VERMELHO"})
	
	U_DST09DESM() // Desmarca registros
	MarkBrow(cAliasCab,"ZZ2_MARCA","ZZ2->ZZ2_STATUS='2'",,,cMarca,"U_DST09ALL()",,,,"U_DST09MARK()",)
Return NIL


// EDICAO DE DADOS
User Function DST09FUNC(nnTipo)
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
			cOpcao:="ALTERAR"    
			nOpcE:=nOpcG:=4
		case nnTipo == 3
			If ZZ2->ZZ2_STATUS = "2"
				Msgbox("Pre-Coleta não pode ser excluida","Pre-Coleta","STOP")
				Return nil
			Endif
			cOpcao:="EXCLUIR"
			nOpcE:=nOpcG:=5
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
		dbSeek(xFilial(cAliasItm)+M->ZZ2_DOC+M->ZZ2_SERIE)

		Do While !eof() .and. xFilial(cAliasItm)==ZZ3_FILIAL .and. M->ZZ2_DOC==ZZ3_DOC .and. M->ZZ2_SERIE==ZZ3_SERIE
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

	// Define e Abre janela para cadastro
	cTitulo :="Pré Coleta"
	cLinOk  :="U_DST09LinhaOk()"
	cTudOk  :="U_DST09TudoOk()"
	cFieldOk:="AllwaysTrue()"
	If DST09MOD3(Capital(Alltrim(cTitulo)+" - "+Alltrim(cOpcao)),cAliasCab,cAliasItm,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.T.,,aAltEnchoice)
		fSS_Salvar()
		If cOpcao $ "INCLUIR*ALTERAR" 
			DST09OBS()
		Endif
	Endif
Return NIL

Static Function DST09Mod3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze)
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
	nLinhas  := iif(M->ZZ2_STATUS="2",Len(aCols),99)
	lDel     := (M->ZZ2_STATUS="1")

	DEFINE MSDIALOG oDlg TITLE cTitulo From 5,5 to 30,99 of oMainWnd
	EnChoice(cAlias1,nReg,nOpcE,,,,aMyEncho,{15,1,100,370},aAltEnchoice,3,,,,,,lVirtual)
	oGetDados := MsGetDados():New(101,1,185,370,nOpcG,cLinOk,cTudoOk,"",lDel,,nFreeze,,nLinhas,cFieldOk)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)} , {||oDlg:End()})

	lRet:=(nOpca==1)
Return lRet

// validação de linha de itens
User Function DST09LinhaOk()
 	Local cTpServ   := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_TPSERV"})]    
  	Local cCdServ   := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_SERVIC"})]  
	Local cCdCarc   := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_CARC"  })]    
   	Local cSerPn    := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_SERPN" })]           
	Local cNumFogo  := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_NUMFOG"})]            
	Local cMarca    := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_MARCA" })]           
	Local cModelo   := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_MODELO"})]            
	Local cDesenho  := aCols[n,aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_DESENH"})]  
	Local lRET      := .T.    
	
	Do Case            
		Case cTPServ == "1" .and. Posicione( "SB1", 1, xFilial("SB1") + cCdServ, "B1_X_ESPEC" ) != "F"
				MsgAlert("RECAPAGEM ?","Pré-Coleta")
			 	lRet := .F.     
		Case cTPServ == "1" .and. Posicione( "SB1", 8, xFilial("SB1") + AllTrim(cDesenho), "B1_GRUPO" ) != 'BAND' 	 	
				MsgAlert("DESENHO GRUPO BANDA ?"+cDesenho,"Pré-Coleta")
				lRet := .F.  
		Case cTPServ == "2" .and. Posicione( "SB1", 1, xFilial("SB1") + cCdServ, "B1_X_ESPEC" ) != "Q"
				MsgAlert("REUCAUCHUTAGEM ?","Pré-Coleta")   
		  		lRet := .F.          
		Case cTpServ == "3" .and. Posicione( "SB1", 1, xFilial("SB1") + cCdServ, "B1_X_ESPEC" )  != "S" 
				MsgAlert("SO CONSERTO ?","Pré-Coleta")
			 	lRet := .F.
		Case Posicione( "SB1", 1, xFilial("SB1") + cCdCarc, "B1_MSBLQL" ) = "1"
				MsgAlert("PRODUTO COM BLOQUEIO ?","Pré-Coleta")
			 	lRet := .F.
		Case empty(cSerPn) .and. empty(cNumFogo)
				MsgAlert("Informe Serie e/ou Fogo","Pré-Coleta")  
		     	lRet := .F.
		Case empty(cMarca)
		     	MsgAlert("Informe Marca","Pré-Coleta")
		     	lRet := .F.
		Case empty(cModelo)
			 	MsgAlert("Informe Modelo","Pré-Coleta")
			 	lRet := .F.      
		Case empty(cDesenho)
		     	MsgAlert("Informe Desenho","Pré-Coleta")
		     	lRet := .F.
		Case cTpServ == "4" .and. subs(cDesenho,1,4) # "EXAM"
			 	MsgAlert("Informe 'EXAME' no campo Desenho","Pré-Coleta")
		     	lRet := .F.     
	    Case cTpServ == "3" .and. subs(cDesenho,1,4) # "CONS"
		     	MsgAlert("Informe 'CONSERTO' no campo Desenho","Pré-Coleta")  
		     	lRet := .F.                                                   
		Case empty(cSerPn) .and. empty(cNumFogo)
		     	MsgAlert("Serie e Fogo ... Não Informado","Pré-Coleta")  
		     	lRet := .F.
		Case cTpServ == "4" .and. subs(cDesenho,1,4) # "EXAM"
			 	MsgAlert("informe 'EXAME' no campo Desenho","Pré-Coleta")
		     	lRet := .F.     
	    Case cTpServ == "3" .and. subs(cDesenho,1,4) # "CONS"
		     	MsgAlert("Informe 'CONSERTO' no campo Desenho","Pré-Coleta")
		     	lRet := .F.                                      
	Endcase

Return lRet

User Function DST09TudoOk()
	Local lRet      := .T.
    Local nPosCpo   := aScan(aHeader,{|x| AllTrim(x[2])=="ZZ3_PRUNIT"})  
	Local nTotItens := 0
	Local nQtdItens := 0	
	For j=1 to Len(aCols)
		if !aCols[j,Len(aCols[j])]
			nTotItens += aCols[j,nPosCpo]
			nQtdItens ++
		Endif
	Next j

	Do Case           
		Case M->ZZ2_TOTAL <> nTotItens
			 MsgAlert("O total da coleta deve ser igual ao total dos itens","Pré-Coleta")
			 lRet := .F.
		Case LEN(STRTRAN(ALLTRIM(M->ZZ2_DOC)," ","")) <> 6 .or.ALLTRIM(M->ZZ2_DOC) < "000000" .or. ALLTRIM(M->ZZ2_DOC) > "999999"
			 MsgAlert("O número da coleta deve ser estar entre 000001 e 999999","Pré-Coleta")
			 lRet := .F.                
		Case M->ZZ2_ENTREG < M->ZZ2_EMISSA
			 MsgAlert("A data de entrega deve ser maior ou igual a data de emissão")
			 lRet := .F. 
		Case M->ZZ2_NFCLI = "S" .AND. EMPTY(M->ZZ2_DOCCLI)
			 MsgAlert("Nota Fiscal de Remessa do Cliente Não Informado ... NFCLI = S")
			 lRet := .F.                                               
		Case M->ZZ2_NFCLI = "S" .AND. M->ZZ2_TOTAL <> M->ZZ2_TOTNFC
			 MsgAlert("Valor Total Inválido ... NFCLI = S")
			 lRet := .F.
		Case M->ZZ2_NFCLI = "S" .AND. (nTotItens / nQTdItens) = 10
			 MsgAlert("Valor Unitário Não Deve Ser 10 ... NFCLI = S")
			 lRet := .F.                                               
		Case M->ZZ2_NFCLI = "N" .AND. M->ZZ2_TOTNFC > 0
			 MsgAlert("Valor Total Inválido ... NFCLI = N")
			 lRet := .F.    
		Case M->ZZ2_NFCLI = "N" .AND. !EMPTY(M->ZZ2_DOCCLI)
			 MsgAlert("Número do Documento Inválido ... NFCLI = N")
			 lRet := .F.            
		Case M->ZZ2_NFCLI = "S" .AND. (M->ZZ2_DOCCLI < "000001" .or. M->ZZ2_DOCCLI > "999999")
			 MsgAlert("Intervaldo do Documento de 000001 a 999999")
			 lRet := .F.            			 
		Case M->ZZ2_NFCLI = "S" .AND. len(M->ZZ2_DOCCLI) <> 6
			 MsgAlert("Intervaldo do Documento de 000001 a 999999")
			 lRet := .F.            			 
		Case cOpcao="INCLUIR"     // Última validação
			 
			 dbSelectArea("ZZ2")
		     dbSetOrder(1)
		     dbSeek(xFilial("ZZ2")+M->ZZ2_DOC+M->ZZ2_SERIE)
	         If found()
	         	MsgAlert("Pré-Coleta Já Cadastrada ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf     
	         
	         dbSelectArea("ZZ3")
	         dbSetOrder(1)
	         dbSeek(xFilial("ZZ3")+M->ZZ2_DOC+M->ZZ2_SERIE)
	         If found()
	         	MsgAlert("Item Pré-Coleta Já Cadastrada ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf     
	         
	         dbSelectArea("SF1")
	         dbSetOrder(1)
	         dbSeek(xFilial("SF1")+M->ZZ2_DOC+M->ZZ2_SERIE+M->ZZ2_CODCLI+M->ZZ2_LOJA+"B")
	         If found()
	         	MsgAlert("Documento de Entrada Já Cadastrado ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf                                
	         
	         dbSelectArea("SD1")
	         dbSetOrder(1)
	         dbSeek(xFilial("SD1")+M->ZZ2_DOC+M->ZZ2_SERIE+M->ZZ2_CODCLI+M->ZZ2_LOJA)
	         If found()
	         	MsgAlert("Item de Documento de Entrada Já Cadastrado ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf                                   
	         
	         dbSelectArea("SC2")
	         dbSetOrder(1)                                                                       
	         dbSeek(xFilial("SC2")+iif(M->ZZ2_SERIE="2","1"+substr(M->ZZ2_DOC,2,5),M->ZZ2_DOC))
	         If found()
	         	MsgAlert("OP Já Cadastrado ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf          
	         
	         dbSelectArea("SFT")
	         dbSetOrder(1)                                                                       
	         dbSeek(xFilial("SFT")+"B"+M->ZZ2_SERIE+M->ZZ2_DOC)
	         If found()
	         	MsgAlert("Doc Cadastrado em SFT ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf     
	         
	         dbSelectArea("SC5")
	         dbSetOrder(1)                                                                       
	         dbSeek(xFilial("SC5")+iif(M->ZZ2_SERIE="2","1"+substr(M->ZZ2_DOC,2,5),M->ZZ2_DOC))
	         If found()
	         	MsgAlert("PV Cadastrado ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf	
	         
	         dbSelectArea("SC6")
	         dbSetOrder(1)                                                                       
	         dbSeek(xFilial("SC6")+iif(M->ZZ2_SERIE="2","1"+substr(M->ZZ2_DOC,2,5),M->ZZ2_DOC))
	         If found()
	         	MsgAlert("Item PV Cadastrado ... Para Número e Série Informada","Pré-Coleta")
	         	lRet := .F.
	         EndIf            
	EndCase
		
Return lRet

// Salva Informações
Static Function fSS_Salvar()
	#IFDEF TOP
		BeginTran()
	#EndIF   

	// Trata Cabecalho Enchoice
	DbSelectArea(cAliasCab)
	DbSetOrder(1)

	IF cOpcao == "INCLUIR"
		If RecLock(cAliasCab,.T.)
			For nCampo := 1 TO FCount()
				If "_FILIAL" $ FieldName(nCampo)
					FieldPut(nCampo,xFilial(cAliasCab))
				Else
					FieldPut(nCampo,M->&(FieldName(nCampo)))
				EndIf
			Next nCampo
			MsUnlock()
		Endif
	Elseif cOpcao == "EXCLUIR" 
		cSql := "UPDATE "+RetSqlName("ZZ6")
		cSql += " SET D_E_L_E_T_ = '*'"
		cSql += " WHERE D_E_L_E_T_ = ''
		cSql += " AND ZZ6_FILIAL = '"+ZZ2->ZZ2_FILIAL+"'"
		cSql += " AND ZZ6_SERIE = '"+ZZ2->ZZ2_SERIE+"'"
		cSql += " AND ZZ6_NUM = '"+ZZ2->ZZ2_DOC+"'"
		nUpdt := TcSqlExec(cSql)
		If nUpdt < 0
			MsgBox(TcSqlError(),"Pré Coleta","STOP")
		Endif

		if RecLock(cAliasCab,.F.)
			Delete
			MsUnlock()
		Endif
	EndIf          


	// Trata Itens aCols
	DbSelectArea(cAliasItm)

	If cOpcao == "EXCLUIR"
		dbSelectArea(cAliasItm)
		dbSeek(xFilial(cAliasItm)+M->ZZ2_DOC+M->ZZ2_SERIE)
		Do While !eof() .AND. xFilial(cAliasItm) == ZZ3_FILIAL .AND. M->ZZ2_DOC == ZZ3_DOC .AND. M->ZZ2_SERIE == ZZ3_SERIE
			IF RecLock(cAliasItm,.F.)
				Delete
				MsUnlock()
			Endif
			dbSkip()
		Enddo
	ElseIF cOpcao == "INCLUIR"
		For ii := 1 to Len(aCols)
			If aCols[ii,Len(aHeader)+1]  // Itens Excluidos
				Loop
			EndIf

			if RecLock(cAliasItm,.T.)
				// Campo de relacionameto com Cabec
				ZZ3->ZZ3_FILIAL := xFilial(cAliasItm)
				ZZ3->ZZ3_DOC    := M->ZZ2_DOC
				ZZ3->ZZ3_SERIE  := M->ZZ2_SERIE

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
			dbSeek(xFilial(cAliasItm)+M->ZZ2_DOC+M->ZZ2_SERIE+aCols[ii,1])
			If aCols[ii,Len(aHeader)+1] .and. Found()
				if RecLock(cAliasItm,.F.)
					Delete
					MsUnLock()
				Endif
			Elseif !aCols[ii,Len(aHeader)+1]
				cCodProd := ZZ3->ZZ3_CARC
				if RecLock(cAliasItm,!Found())
					// Campo de relacionameto com Cabec
					ZZ3->ZZ3_FILIAL := xFilial(cAliasItm)
					ZZ3->ZZ3_DOC    := M->ZZ2_DOC
					ZZ3->ZZ3_SERIE  := M->ZZ2_SERIE

					// Outros Campos
					For jj := 1 to Len(aHeader)
						nPosCpo := FieldPos(Alltrim(aHeader[jj,2]))
						If nPosCpo > 0
							FieldPut(nPosCpo,aCols[ii,jj])
						Endif
					Next                         
					MsUnLock()
				Endif
				if M->ZZ2_STATUS = "2"
					Altera_Item(ii,cCodProd)
				Endif
			Endif
		Next
	EndIf   

	#IFDEF TOP
		EndTran()
	#EndIF
Return NIL

User Function DST09MARK()
	if ZZ2->ZZ2_STATUS = "1"
		If RecLock("ZZ2",.F.)
			ZZ2->ZZ2_MARCA := iif(IsMark("ZZ2_MARCA",cMarca)," ",cMarca)
			MsUnLock()
		Endif
	Endif
Return

User Function DST09SELE()
	Local   cSql  := ""
	Local   nUpdt := 0
	Private cPerg := "DSTA09"

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	aAdd(aRegs,{cPerg,"01","Da Emissao          "," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Até a Emissao       "," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Motorista        "," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"04","Até o Motorista     "," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""          })

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


	if Pergunte(cPerg,.T.)
		cSql := "UPDATE "+RetSqlName("ZZ2")
		cSql += " SET   ZZ2_MARCA = 'X'"
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ZZ2_FILIAL = '"+xFilial("ZZ2")+"'"
		cSql += " AND   ZZ2_EMISSA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
		cSql += " AND   ZZ2_VEnd3 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
		cSql += " AND   ZZ2_STATUS = '1'"
	
		MsgRun("Marcando registros ...",,{|| nUpdt := TcSqlExec(cSql)})
	
		If nUpdt < 0
			MsgBox(TcSqlError(),"Pré Coleta","STOP")
		Endif
	Endif
Return nil

User Function DST09DESM()
	Local   cSql  := ""
	Local   nUpdt := 0

	cSql := "UPDATE "+RetSqlName("ZZ2")
	cSql += " SET   ZZ2_MARCA = ' '"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZZ2_FILIAL = '"+xFilial("ZZ2")+"'"
	cSql += " AND   ZZ2_STATUS = '1'"
	cSql += " AND   ZZ2_MARCA = 'X'"
	
	MsgRun("Marcando registros ...",,{|| nUpdt := TcSqlExec(cSql)})
	
	If nUpdt < 0
		MsgBox(TcSqlError(),"Pré Coleta","STOP")
	Endif
Return nil

User Function DST09ALL()
	Local   cSql  := ""
	Local   nUpdt := 0

	cSql := "UPDATE "+RetSqlName("ZZ2")
	cSql += " SET   ZZ2_MARCA = 'X'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZZ2_FILIAL = '"+xFilial("ZZ2")+"'"
	cSql += " AND   ZZ2_STATUS = '1'"
	cSql += " AND   ZZ2_MARCA = ' '"
	
	MsgRun("Marcando registros ...",,{|| nUpdt := TcSqlExec(cSql) })
	
	If nUpdt < 0
		MsgBox(TcSqlError(),"Pré Coleta","STOP")
	Endif

	MarkBRefresh()
Return nil

User Function DST09GERA()
	If msgbox("Confirma geração de Coletas?","Pré-Coleta","YESNO")
		MsgRun("Gerando coletas ...",,{|| GeraColeta() })
	Endif
Return nil

Static Function GeraColeta()
	Local   aArea       := GetArea()
	Local   cSql        := ""
	Local   aCab        := {}
	Local   aItens      := {}
	Local   aItem       := {}
	Private aCols       := {}
	Private lMsErroAuto := .F.

	cSql := "SELECT ZZ2_FILIAL,ZZ2_DOC,ZZ2_SERIE,ZZ2_EMISSA,ZZ2_ENTREG,ZZ2_CODCLI,ZZ2_LOJA,ZZ2_CONDPG"
	cSql += "      ,ZZ3_ITEM,ZZ3_SERVIC,ZZ3_CARC,ZZ3_SERPN,ZZ3_NUMFOG,ZZ3_MARCA"
	cSql += "      ,ZZ3_MODELO,ZZ3_DESENH,ZZ3_QUANT,ZZ3_PRUNIT,ZZ3_OBS"
	cSql += " FROM "+RetSqlName("ZZ2")+" ZZ2"

	cSql += " JOIN  "+RetSqlName("ZZ3")+" ZZ3"
	cSql += " ON    ZZ3.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ3_FILIAL     = ZZ2_FILIAL"
	cSql += " AND   ZZ3_DOC        = ZZ2_DOC"
	cSql += " AND   ZZ3_SERIE      = ZZ2_SERIE"

	cSql += " WHERE ZZ2.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ2_FILIAL     = '"+xFilial("ZZ2")+"'"
	cSql += " AND   ZZ2_MARCA      = 'X'"
	cSql += " AND   ZZ2_STATUS     = '1'"
	cSql += " ORDER BY ZZ2_SERIE,ZZ2_DOC,ZZ3_ITEM"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","ZZ2_EMISSA" ,"D",08)
	TcSetField("ARQ_SQL","ZZ2_ENTREG" ,"D",08)
	TcSetField("ARQ_SQL","ZZ3_QUANT"  ,"N",14,2)
	TcSetField("ARQ_SQL","ZZ3_PRUNIT" ,"N",14,2)

	dbSelectArea("ARQ_SQL")
	dbGoTop()

	Do While !eof()
		aCab   := {}
		aItens := {}
		aAdd(aCab,{"F1_FILIAL"      ,ZZ2_FILIAL ,Nil})
		aAdd(aCab,{"F1_TIPO"        ,"B"        ,Nil})
		aAdd(aCab,{"F1_FORMUL"      ,"S"        ,Nil})
		aAdd(aCab,{"F1_DOC"         ,ZZ2_DOC    ,Nil})
		aAdd(aCab,{"F1_SERIE"       ,ZZ2_SERIE  ,Nil})
		aAdd(aCab,{"F1_EMISSAO"     ,ZZ2_EMISSA ,Nil})
		aAdd(aCab,{"F1_FORNECE"     ,ZZ2_CODCLI ,Nil})
		aAdd(aCab,{"F1_LOJA"        ,ZZ2_LOJA   ,Nil})
		aAdd(aCab,{"F1_ESPECIE"     ,"NF"       ,Nil})
		aAdd(aCab,{"F1_DTDIGIT"     ,dDataBase  ,Nil})
		aAdd(aCab,{"F1_EST"         ,"SP"       ,Nil}) 
		aAdd(aCab,{"F1_COND"        ,ZZ2_CONDPG ,Nil}) 
		aAdd(aCab,{"F1_HORA"        ,Time()     ,Nil}) 

		cChave := ZZ2_FILIAL+ZZ2_DOC+ZZ2_SERIE

		aItem:={}
		Do While !eof() .AND. ZZ2_FILIAL+ZZ2_DOC+ZZ2_SERIE = cChave
			aItem:={}
			AADD(aItem,{"D1_FILIAL"  ,ZZ2_FILIAL           ,NIL})
			AADD(aItem,{"D1_DOC"     ,ZZ2_DOC              ,NIL})
			AADD(aItem,{"D1_SERIE"   ,ZZ2_SERIE            ,NIL})
			AADD(aItem,{"D1_FORNECE" ,ZZ2_CODCLI           ,NIL})
			AADD(aItem,{"D1_LOJA"    ,ZZ2_LOJA             ,NIL})
			AADD(aItem,{"D1_SERVICO" ,ZZ3_SERVIC           ,NIL})
			AADD(aItem,{"D1_COD"     ,ZZ3_CARC             ,NIL})
			AADD(aItem,{"D1_SERIEPN" ,ZZ3_SERPN            ,NIL})
			AADD(aItem,{"D1_NUMFOGO" ,ZZ3_NUMFOG           ,NIL})
			AADD(aItem,{"D1_MARCAPN" ,ZZ3_MARCA            ,NIL})
			AADD(aItem,{"D1_CARCACA" ,ZZ3_MODELO           ,NIL})
			AADD(aItem,{"D1_X_DESEN" ,ZZ3_DESENH           ,NIL})
			AADD(aItem,{"D1_DTENTRE" ,ZZ2_ENTREG           ,NIL})
			AADD(aItem,{"D1_QUANT"   ,ZZ3_QUANT            ,NIL})
			AADD(aItem,{"D1_VUNIT"   ,ZZ3_PRUNIT           ,NIL})
			AADD(aItem,{"D1_TOTAL"   ,ZZ3_QUANT*ZZ3_PRUNIT ,NIL})
			AADD(aItem,{"D1_TES"     ,"121"                ,NIL})
			AADD(aItem,{"D1_X_OBS"   ,ZZ3_OBS              ,NIL})
			AADD(aItens,ACLONE(aItem))
			dbSkip()
		Enddo

		//MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens)
		MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItens,3)

		If lMsErroAuto
			MostraErro()
		Else
			dbSelectArea("ZZ2")
			dbSeek(cChave)
			if Found()
				If RecLock("ZZ2",.F.)
					ZZ2->ZZ2_STATUS := "2"
					MsUnLock()
				Endif
			Endif
		Endif

		dbSelectArea("ARQ_SQL")
	Enddo
	dbCloseArea()
	RestArea(aArea)
	MarkBRefresh()
Return nil

User Function DST09LEG()
	BrwLegEnda(cCadastro,"LegEnda", {{"BR_VERDE"    ,"PEndente"   },;
									 {"BR_VERMELHO" ,"NF Gerada"  }} ) 
Return nil

Static Function Altera_Item(nItem,cProd)
	Local aArea := GetArea()

	// Documento de entrada
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial("SD1")+ZZ2->ZZ2_DOC+ZZ2->ZZ2_SERIE+ZZ2->ZZ2_CODCLI+ZZ2->ZZ2_LOJA+cProd+StrZero(nItem,4))
	If Found()
		If RecLock("SD1",.F.)
			SD1->D1_SERVICO := ZZ3->ZZ3_SERVIC
			SD1->D1_COD     := ZZ3->ZZ3_CARC
			SD1->D1_X_DESEN := ZZ3->ZZ3_DESENH
			SD1->D1_SERIEPN := ZZ3->ZZ3_SERPN
			SD1->D1_NUMFOGO := ZZ3->ZZ3_NUMFOGO
			SD1->D1_MARCAPN := ZZ3->ZZ3_MARCA
			SD1->D1_CARCACA := ZZ3->ZZ3_MODELO
			SD1->D1_X_OBS   := ZZ3->ZZ3_OBS
			MsUnlock()
		Endif
	Endif


	// Ordem de produção
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+SD1->D1_NUMC2+SD1->D1_ITEMC2)
	If Found()
		Do While !eof() .AND. SC2->(C2_NUM+C2_ITEM) = SD1->(D1_NUMC2+D1_ITEMC2)
			If RecLock("SC2",.F.)
				SC2->C2_PRODUTO := ZZ3->ZZ3_CARC
				SC2->C2_X_DESEN := ZZ3->ZZ3_DESENH
				SC2->C2_SERIEPN := ZZ3->ZZ3_SERPN
				SC2->C2_NUMFOGO := ZZ3->ZZ3_NUMFOGO
				SC2->C2_MARCAPN := ZZ3->ZZ3_MARCA
				SC2->C2_CARCACA := ZZ3->ZZ3_MODELO
				SC2->C2_OBS     := ZZ3->ZZ3_OBS
				MsUnlock()
			Endif
			dbSkip()
		Enddo
	Endif


	// Poder de terceiros
	dbSelectArea("SB6")
	dbSetOrder(3)
	dbSeek(xFilial("SB6")+SD1->D1_IDENTB6)
	If Found()
		If RecLock("SB6",.F.)
			SB6->B6_PRODUTO := ZZ3->ZZ3_CARC
			MsUnlock()
		Endif
	Endif

	RestArea(aArea)
Return nil           

User Function DST09FICH   
	Local 	cDesc1      := "Este programa tem como objetivo imprimir relatorio "
	Local 	cDesc2      := "de acordo com os parametros informados pelo usuario."
	Local 	cDesc3      := "Emissao de Fichas de Produção "
	Local 	cPict       := ""
	Local 	titulo      := "Emissao de Fichas de Producao "
	Local 	cPerg       := "ESTA09"
	Local 	Cabec1      := "Este programa ira emitir fichas de producao de acordo com
	Local 	Cabec2      := "os parametros selecionados"
	Local 	imprime     := .T.
	Local 	aOrd 		:= {}
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite     	:= 80
	Private tamanho    	:= "P"
	Private nomeprog   	:= "DESTA09"
	Private nTipo      	:= 18
	Private aReturn    	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   	:= 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "ESTA09"
    Private cString		:= "SC2"

	cPerg    			:= PADR(cPerg,6)
	aRegs    			:= {}  
                        
	aAdd(aRegs,{cPerg,"01","Imprime Atual            "," "," ","mv_ch1","N",01,0,0,"C","","mv_par01","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Da Coleta                "," "," ","mv_ch2","C",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Até a Coleta             "," "," ","mv_ch3","C",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Da Data                  "," "," ","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Até a Data               "," "," ","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.) 
	
	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

    nTipo := If(aReturn[4]==1,15,18)  
	If aReturn[5] == 2
		SetPrc(0,0)
	Endif
	RptStatus({|| RunRelat ()})    

Return

Static Function RunRelat

	Local nLin := 0

	_cQry:= "SELECT C2_FILIAL"
	_cQry+= " ,     C2_NUM"
	_cQry+= " ,     C2_ITEM"
	_cQry+= " ,     C2_SEQUEN"
	_cQry+= " ,     C2_EMISSAO"
	_cQry+= " ,     C2_NUMD1"
	_cQry+= " ,     C2_SERIED1" 
	_cQry+= " ,     C2_FORNECE"
	_cQry+= " ,     C2_LOJA"
	_cQry+= " ,     C2_PRODUTO" 
	_cQry+= " ,     C2_NUMFOGO" 
	_cQry+= " ,     C2_SERIEPN" 
	_cQry+= " ,     C2_OBS" 
	_cQry+= " ,     C2_X_DESEN"
	_cQry+= " ,     A1_NOME"
	_cQry+= " ,     D1_DOC"
	_cQry+= " FROM " + RetSqlName("SD1") + " SD1"
	_cQry+= " ," + RetSqlName("SC2") + " SC2"
	_cQry+= " ," + RetSqlName("SA1") + " SA1"	
	_cQry+= " WHERE SD1.D_E_L_E_T_ = ''"
	_cQry+= " AND   SC2.D_E_L_E_T_ = ''"
	_cQry+= " AND   SA1.D_E_L_E_T_ = ''"

	if mv_par01 = 1
		_cQry+= " AND   D1_FILIAL      = '"+ZZ2->ZZ2_FILIAL+"'"
		_cQry+= " AND   D1_DOC         = '"+ZZ2->ZZ2_DOC+"'"
		_cQry+= " AND   D1_SERIE       = '"+ZZ2->ZZ2_SERIE+"'"
		_cQry+= " AND   D1_FORNECE     = '"+ZZ2->ZZ2_CODCLI+"'"
		_cQry+= " AND   D1_LOJA        = '"+ZZ2->ZZ2_LOJA+"'"
	else
		_cQry+= " AND   D1_FILIAL      = '"+xFilial("SD1")+"'"
		_cQry+= " AND   D1_DOC||SUBSTR(D1_ITEM,3,2) BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
		_cQry+= " AND   D1_EMISSAO BETWEEN '"+dtos(mv_par04)+"' AND '"+dtos(mv_par05)+"'"
	Endif

	_cQry+= " AND   C2_FILIAL  = D1_FILIAL"
	_cQry+= " AND   C2_NUMD1   = D1_DOC"
	_cQry+= " AND   C2_ITEMD1  = D1_ITEM"

	_cQry+= " AND   A1_FILIAL  = '"+xFilial("SA1")+"'"
	_cQry+= " AND   A1_COD     = D1_FORNECE"
	_cQry+= " AND   A1_LOJA    = D1_LOJA"
	_cQry+= " ORDER BY C2_NUM, C2_ITEM"

	dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'SC2TMP', .F., .T.)
	dbGoTop()

	@ nLin,000 PSAY chr(18)

	dbSelectArea("SC2TMP")
	SetRegua(RecCount())

	While !Eof()

   		nLin := nLin + 1
   		
		@ nLin,010 PSAY Alltrim(SC2TMP->A1_NOME)    //Cliente
		@ nLin,050 PSAY SC2TMP->C2_FORNECE          //Cod.Cliente
		nLin:= nLin + 1   
		
		_cMedida := SC2TMP->C2_PRODUTO   
		
		@ nLin,010 PSAY SC2TMP->D1_DOC            //Coleta
		@ nLin,030 PSAY DTOC(STOD(SC2TMP->C2_EMISSAO)) +" "+Time()         //Data Emissao
	
		nLin:= nLin + 1
	
		@ nLin,010 PSAY SC2TMP->C2_PRODUTO           //Medida
		//@ nLin,035 PSAY IIF(Empty(SC2TMP->C2_SERIEPN),SC2TMP->C2_NUMFOGO,SC2TMP->C2_SERIEPN) //Num.Serie/Numero Fogo 
		@ nLin,035 PSAY AllTrim(SC2TMP->C2_SERIEPN) + "/" + AllTrim(SC2TMP->C2_NUMFOGO)
	
		nLin:= nLin + 1
		@ nLin,010 PSAY chr(255)+ Chr(14)+ (SC2TMP->C2_NUM)+" "+(SC2TMP->C2_ITEM) //Numero da Ficha
		
		nLin:= nLin + 17   //17
	
		@ nLin,012 PSAY SC2TMP->C2_OBS            //Obs
		@ nLin,070 PSAY SC2TMP->C2_X_DESEN
	
		nLin:=nLin+ 3 //22           
		
   		@ nLin,010 PSAY substr(Alltrim(SC2TMP->A1_NOME),1,20)  //Cliente
		@ nLin,039 PSAY SC2TMP->C2_X_DESEN          //Banda
	    @ nLin,058 PSAY SC2TMP->C2_NUM+"/"+SC2TMP->C2_ITEM
		nLin:= nLin + 1
	
		@ nLin,010 PSAY SD1->D1_DOC            //Coleta
		@ nLin,036 PSAY DTOC(STOD(SC2TMP->C2_EMISSAO)) +" "+Time() //Data Emissao
		@ nLin,058 PSAY SC2TMP->C2_PRODUTO       //Medida chr(255)+Chr(14) +
		nLin:= nLin + 1
	
		@ nLin,010 PSAY  _cMedida                //Medida
		//@ nLin,042 PSAY  IIF(Empty(SC2TMP->C2_SERIEPN),SC2TMP->C2_NUMFOGO,SC2TMP->C2_SERIEPN) //Num.Serie/Numero Fogo
		@ nLin,042 PSAY  AllTrim(SC2TMP->C2_SERIEPN) + "/" + AllTrim(SC2TMP->C2_NUMFOGO)
	
    	nlin := nLin + 1
    	@ nLin,010 PSAY  SC2TMP->C2_NUM+SC2TMP->C2_ITEM       //Numero da Ficha+Item da Ficha
    
		nlin := nLin + 1
	
		@ nLin,018 PSAY SC2TMP->C2_X_DESEN          //Banda        
		nlin := nLin + 2				

		nLin := nLin+6  //11
       
		dbSelectArea("SC2TMP")
		dbSkip()
	EndDo

	dbSelectArea("SC2TMP")
	dbCloseArea()

	If aReturn[5]==1
		dbCommitAll()
		Set Printer to
		OurSpool(wnRel)
	EndIf

	MS_FLUSH()
Return

Static Function DST09OBS()
	Local   aEstru   := {}
	Local   cSql     := ""
	Private aHeader  := {}
	Private aCols    := {}
	Private aAlter   := {}
	Private nOpc     := 4
	Private aSist    := {}

	aadd(aEstru,{"ZZ6_CODIGO"   ,"C",03,0})
	aadd(aEstru,{"ZZ6_DESC"     ,"C",25,0})  
	aadd(aEstru,{"ZZ6_TXT"      ,"C",25,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"ZZ6_CODIGO",,.t.,"Selecionando Registros...")


	If M->ZZ2_CONDPG <> M->ZZ2_CONDCL
		If cOpcao = "INCLUIR" 
			dbSelectArea("ZZ7")
			dbSetOrder(1)
			dbSeek(xFilial("ZZ7")+"001")

			dbSelectArea("TMP")
			If RecLock("TMP",.T.)
				TMP->ZZ6_CODIGO := ZZ7->ZZ7_CODIGO
				TMP->ZZ6_DESC   := ZZ7->ZZ7_DESC
				MsUnLock()
			Endif
			aAdd(aCols,{ZZ6_CODIGO,ZZ6_DESC,.F.})
		Endif

		aAdd(aSist,{"001",.F.})
	Endif

    //////////////////////////////////////////////
	cSql := "SELECT SUBSTR(ZZ3_ITEM,3,2) AS ITEM "
	cSql += " FROM "+RetSqlName("ZZ3")+" ZZ3"

	cSql += " LEFT JOIN "+RetSqlName("ACP")+" ACP "
	cSql += " ON   ACP.D_E_L_E_T_ = ''"
	cSql += " AND  ACP_FILIAL = '"+xFilial("ACP")+"'"
	cSql += " AND  ACP_CODREG = '" + ZZ2->ZZ2_CODCLI + "' "
	cSql += " AND  ACP_CODPRO = ZZ3_SERVIC "
	cSql += " WHERE ZZ3.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ3_FILIAL = '"+xFilial("ZZ2")+"' "
	cSql += " AND   ZZ3_SERIE  = '"+ZZ2->ZZ2_SERIE+"' "
	cSql += " AND   ZZ3_DOC    = '"+ZZ2->ZZ2_DOC  +"' "
	cSql += " AND   ACP_CODPRO IS NULL "
	cSql += " ORDER BY ITEM "
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MSG", .T., .T.)
	dbSelectArea("SQL_MSG")    
	Do While .not. eof()
		dbSelectArea("ZZ7")
		dbSetOrder(1)
		dbSeek(xFilial("ZZ7")+"9"+SQL_MSG->ITEM)
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			TMP->ZZ6_CODIGO := ZZ7->ZZ7_CODIGO
			TMP->ZZ6_DESC   := ZZ7->ZZ7_DESC
			TMP->ZZ6_TXT	:= "C:" + ZZ2->ZZ2_CODCLI + " S:" + ZZ3->SERVIC
			MsUnLock()
		Endif
		aAdd(aCols,{ZZ6_CODIGO,ZZ6_DESC,ZZ6_TXT,.F.})
		aAdd(aSist,{ZZ6_CODIGO,.F.})
		dbSelectArea("SQL_MSG")
		dbSkip()
	EndDo
	if SA1->A1_MAXNUMCONS
	
	
	dbCloseArea()

	cSql := "SELECT ZZ6_CODIGO,ZZ7_DESC,ZZ6_BLQ"
	cSql += " FROM "+RetSqlName("ZZ6")+" ZZ6"

	cSql += " LEFT JOIN "+RetSqlName("ZZ7")+" ZZ7"
	cSql += " ON   ZZ7.D_E_L_E_T_ = ''"
	cSql += " AND  ZZ7_FILIAL = '"+xFilial("ZZ7")+"'"
	cSql += " AND  ZZ7_CODIGO = ZZ6_CODIGO"

	cSql += " WHERE ZZ6.D_E_L_E_T_ = ''"
	cSql += " AND   ZZ6_FILIAL = '"+xFilial("ZZ6")+"'"
	cSql += " AND   ZZ6_SERIE = '"+M->ZZ2_SERIE+"'"
	cSql += " AND   ZZ6_NUM = '"+M->ZZ2_DOC+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MSG", .T., .T.)
	dbSelectArea("SQL_MSG")

	Do While !Eof()
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			TMP->ZZ6_CODIGO := SQL_MSG->ZZ6_CODIGO
			TMP->ZZ6_DESC   := SQL_MSG->ZZ7_DESC
			MsUnLock()
		Endif
		aAdd(aCols,{ZZ6_CODIGO,ZZ6_DESC,.F.})

		dbSelectArea("SQL_MSG")
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea("TMP")

   	
	aAdd(aHeader,{"Codigo"   ,"ZZ6_CODIGO","@!",03,0,"U_PREOBSVL(1)",,"C",,})
	aAdd(aHeader,{"Descrição","ZZ6_DESC"  ,"@!",50,0,              ,,"C",,})

	aAdd(aAlter,"ZZ6_CODIGO")
	

	@ 000,000 TO 200,700 DIALOG oDlgMsg TITLE "Mensagens Pré-Coleta"
		oPanel := TPanel():New(0,0,"",oDlgMsg, oDlgMsg:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT

		@ 015,003 SCROLLBOX oScr SIZE 080,347 OF oDlgMsg
		oGetDesc := MSGetDados():New(000,000,078,345,nOpc,"!Empty(aCols[n,1])",,,.T.,aAlter,,,,,,,,oScr)
	ACTIVATE DIALOG oDlgMsg CENTER ON INIT EnchoiceBar(oDlgMsg,{|| Close(oDlgMsg) },{||  }) VALID U_PREOBSVL(2)

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())

	For k=1 to Len(aCols)
		If !Empty(aCols[k,1])
			dbSelectArea("ZZ7")
			dbSetOrder(1)
			dbSeek(xFilial("ZZ7")+aCols[k,1])

			dbSelectArea("ZZ6")
			dbSetOrder(1)
			dbSeek(xFilial("ZZ6")+M->ZZ2_SERIE+M->ZZ2_DOC+aCols[k,1])
			If Found()
				If aCols[k,3]
					If RecLock("ZZ6",.F.)
						dbDelete()
						MsUnLock()
					Endif
				Endif
			Else
				If !aCols[k,3]
					If RecLock("ZZ6",.T.)
						ZZ6->ZZ6_FILIAL := xFilial("ZZ6")
						ZZ6->ZZ6_SERIE  := M->ZZ2_SERIE
						ZZ6->ZZ6_NUM    := M->ZZ2_DOC
						ZZ6->ZZ6_CODIGO := M->aCols[k,1]
						ZZ6->ZZ6_BLQ    := ZZ7->ZZ7_BLQFAT 
						ZZ6->ZZ6_USERIN := Upper(AllTrim(cUserName))
						ZZ6->ZZ6_DATAIN := dDataBase
						ZZ6->ZZ6_HORAIN := Time()
						MsUnLock()
					Endif
				Endif
			Endif
		Endif
	Next k
Return nil

User Function PREOBSVL(nTipo)
	Local lRet := .F.
	
	If nTipo = 1
		lRet := ExistCpo("ZZ7",M->ZZ6_CODIGO,1)

		If lRet
			For k=1 To Len(aCols)
				lRet := !(k<>n .AND. aCols[k,1] = M->ZZ6_CODIGO)

				If !lRet
					ApMsgInfo("Este código ja foi informado.")
					Exit
				Endif
			Next k
		Endif
		aCols[n,2] := iif(lRet,Posicione("ZZ7",1,xFilial("ZZ7")+M->ZZ6_CODIGO,"ZZ7->ZZ7_DESC"),"")

	Elseif nTipo = 2
		lRet := .T.

		For ii=1 to Len(aSist)
			For jj=1 To Len(aCols)
				If aSist[ii,1] = aCols[jj,1] .AND. !aCols[jj,3]
					aSist[ii,2] := .T.
					Exit
				Endif
			Next
			If !aSist[ii,2]
				ApMsgInfo("O sistema incluiu uma ou mais mensagens e não podem ser alteradas.")
				lRet := .F.
				Exit
			Endif
		Next
	Endif
Return lRet