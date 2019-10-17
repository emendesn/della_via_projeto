#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DVAJUB2SALº Autor ³ Geraldo Sabino     º Data ³  11/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Checagem da diferenca do Campo B2_SALPEDI                  º±±
±±º          ³ Conforme Parametros do Usuario.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DVAJUB2SAL()

cPerg:="AJUSB2"
CriaSX1()

PERGUNTE("AJUSB2",.T.)

IF MV_PAR01 = Spac(2)
   MV_PAR01:="01"
Endif

IF UPPER(MV_PAR02) = "ZZ"  
   MV_PAR02:="99"
Endif
                
Processa({|lEnd|SC7215()})// Substituido pelo assistente de conversao do AP5 IDE em 09/05/01 ==> 	 Processa({|lEnd|Execute(ESP05)})

Static Function SC7215()     

MV_PAR01   // Filial de
MV_PAR02   // Filial Ate
MV_PAR03   // Produto de
MV_PAR04   // Produto Ate
MV_PAR05   // Local de
MV_PAR06  // Local  Ate


dbSelectArea("SM0")
dbSetOrder(1)
If Empty(xFilial("SA1")) .Or. Empty(xFilial("SB2"))
	MsSeek(cEmpAnt)
	cFirst := SM0->M0_CODFIL
	_nRegs:=1
Else
	Count to _nRegs for M0_CODIGO = cEmpAnt
	MsSeek(cEmpAnt+cFilAnt)
	cFirst := SM0->M0_CODFIL
EndIf

lBat          :=.F.
lQuery    := .F.
ProcRegua(_nRegs)

_cEmp:=SM0->M0_CODIGO
For _c:= VAL(MV_PAR01)    to  VAL(MV_PAR02)
   incProc("Processando a Filial --> "+Strzero(_c,2))
   dBselectarea("SM0")
	dbsetorder(1)
	dbseek(_cEmp+Strzero(_c,2))
	cFilAnt:=SM0->M0_CODFIL
	AJUZERASALPEDI()
	AJUB2SALPEDI()
Next



Static Function AJUB2SALPEDI()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza os dados acumulados do Pedido de Compra              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (!Empty(xFilial("SC7")) .Or. cFilAnt == cFirst )
	dbSelectArea("SX2")
	dbSetOrder(1)
	MsSeek("SC7")
	cMensagem := AllTrim(X2Nome())
	cMensagem := Lower(cMensagem)
	cMensagem := Upper(SubStr(cMensagem,1,1))+SubStr(cMensagem,2)
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SC7->(dbStruct())
		lQuery    := .T.
		cAliasSC7 := "SC7MA215PROC"
		                           
		cQuery := "SELECT C7_FILIAL,C7_PRODUTO,C7_LOCAL,C7_QUJE,C7_QUANT,C7_RESIDUO,C7_FILENT,C7_TPOP,C7_QTSEGUM,C7_FORNECE,C7_LOJA,C7_NUM,C7_ITEM,C7_OP,C7_SEQMRP,C7_DATPRF,C7_TIPO,SB1.B1_FILIAL "
		cQuery += "FROM "+RetSqlName("SC7")+" SC7,"
		cQuery += RetSqlName("SB1")+" SB1 "
		cQuery += "WHERE SC7.C7_FILIAL='"+xFilial("SC7")+"' AND "
		cQuery += "SC7.C7_FILENT IN('  ','"+xFilial("SC7")+"') AND "
		cQuery += "SC7.C7_QUJE < C7_QUANT AND "
		cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "
		cQuery += "SC7.C7_PRODUTO>='"+MV_PAR03+"' AND "
		cQuery += "SC7.C7_PRODUTO<='"+MV_PAR04+"' AND "
		cQuery += "SC7.C7_LOCAL >='"+MV_PAR05+"' AND "
		cQuery += "SC7.C7_LOCAL <='"+MV_PAR06+"' AND "
		cQuery += "SC7.D_E_L_E_T_=' ' AND "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += "SB1.B1_COD=SC7.C7_PRODUTO AND "
		cQuery += "SB1.D_E_L_E_T_=' ' "
		cQuery += "UNION ALL "
		cQuery += "SELECT C7_FILIAL,C7_PRODUTO,C7_LOCAL,C7_QUJE,C7_QUANT,C7_RESIDUO,C7_FILENT,C7_TPOP,C7_QTSEGUM,C7_FORNECE,C7_LOJA,C7_NUM,C7_ITEM,C7_OP,C7_SEQMRP,C7_DATPRF,C7_TIPO,SB1.B1_FILIAL "
		cQuery += "FROM "+RetSqlName("SC7")+" SC7,"
		cQuery += RetSqlName("SB1")+" SB1 "
		cQuery += "WHERE SC7.C7_FILENT='"+xFilial("SC7")+"' AND "
		cQuery += "SC7.C7_FILIAL<>'"+xFilial("SC7")+"' AND "
		cQuery += "SC7.C7_QUJE < C7_QUANT AND "
		cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "
		cQuery += "SC7.C7_PRODUTO>='"+MV_PAR03+"' AND "
		cQuery += "SC7.C7_PRODUTO<='"+MV_PAR04+"' AND "
		cQuery += "SC7.C7_LOCAL >='"+MV_PAR05+"' AND "
		cQuery += "SC7.C7_LOCAL <='"+MV_PAR06+"' AND "
		cQuery += "SC7.D_E_L_E_T_=' ' AND "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += "SB1.B1_COD=SC7.C7_PRODUTO AND "
		cQuery += "SB1.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY 1,2,3 "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
		For nX := 1 To Len(aStru)
			If ( aStru[nX][2] <> "C" )
				TcSetField(cAliasSC7,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	#ELSE
		cQuery := "((C7_FILIAL=='"+xFilial("SC7")+"' .And. C7_FILENT$'  #"+xFilial("SC7")+"') .Or. (C7_FILIAL<>'"+xFilial("SC7")+"' .And. C7_FILENT=='"+xFilial("SC7")+"')) .And. "
		cQuery += "C7_QUJE < C7_QUANT .And. "
		cQuery += "C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"'"
		Set Filter To &cQuery
		MsSeek(xFilial("SC7"))
	#ENDIF
	If !lBat
		//	oObj:SetRegua2(SC7->(LastRec()))
		//	oObj:IncRegua2(cMensagem)
	EndIf
	
	While !Eof()
		lContinua := .T.
		If !lQuery
			If ( (cAliasSC7)->C7_QUJE >= C7_QUANT ) .Or.;
				!Empty((cAliasSC7)->C7_RESIDUO) .Or.;
				!A215FilOk((cAliasSC7)->C7_PRODUTO)
				lContinua := .F.
			EndIf
		EndIf
		
		If lContinua
			SFMaAvalPC(cAliasSC7,1,,.T.)
		EndIf
		a215Skip(cAliasSC7)
		If !lBat
			//	oObj:IncRegua2(cMensagem)
		EndIf
	EndDo
	If lQuery
		dbSelectArea(cAliasSC7)
		dbCloseArea()
		dbSelectArea("SC7")
	EndIf
EndIf


/*/
??????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ???
???Fun??o    ?SFMaAvalPC  ? Autor ? Eduardo Riera         ? Data ?22.08.2000 ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ???
???          ?Rotina de avaliacao dos eventos de um pedido de compra       ???
???          ?                                                             ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Sintaxe   ?MaAvalPC(ExpC1,ExpN1,ExpL1,ExpL2,ExpC2,ExpL3,ExpB1,ExpL4)	   ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Parametros?ExpC1:*Alias da tabela de pedido de compra                   ???
???          ?ExpN1:*Codigo do Evento                                      ???
???          ?       [1] Implantacao de uma Pedido de compra               ???
???          ?       [2] Estorno de um pedido de compra                    ???
???          ?       [3] Exclusao de um pedido de compra                   ???
???          ?       [4] Liberacao de um pedido de compra                  ???
???          ?       [5] Estorno da liberacao do pedido de compra          ???
???          ?       [6] Implantacao de um pre-documento de entrada        ???
???          ?       [7] Estorno de um pre-documento de entrada            ???
???          ?       [8] Implantacao de um documento de entrada            ???
???          ?       [9] Estorno de um documento de entrada                ???
???          ?       [10]Implantacao de um documento de entrada - Average  ???
???          ?       [11]Estorno de um documento de entrada     - Average  ???
???          ?ExpL1: Indica se este eh o ultimo registro a ser processado  ???
???          ?                                                        (OPC)???
???          ?ExpL2: Indica se somente os acumalados devem ser atualizados ???
???          ?                                                        (OPC)???
???          ?ExpC2: Alias da item do documento de entrada            (OPC)???
???          ?ExpL3: Indica se a amarracao fornecedor/produto deve ser atu-???
???          ?       alizada ( DEFAULT .F. )                          (OPC)???
???          ?ExpB1: CodeBlock de contabilizacao                      (OPC)???
???          ?       E passado para o codebock o codigo do evento          ???
???          ?ExpL4: Indica se o SB2 deve ser atualizado                   ???
???          ?               ( DEFAULT .T. )                          (OPC)???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Retorno   ?.T.	                                                       ???
???          ?                                                             ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Descri??o ?Esta rotina tem como objetivo atualizar os eventos vinculados???
???          ?a um pedido de compra:                                       ???
???          ?A) Atualizacao das tabelas complementares.                   ???
???          ?B) Atualizacao das informacoes complementares ao PC          ???
???          ?                                                             ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Uso       ? Materiais                                                   ???
??ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ??
??????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function SFMaAvalPC(cAliasSC7,nEvento,lLast,lAcumulados,cAliasSD1,lIncSA5,bCtbOnLine,lAtuSB2)

Local aArea 	:= GetArea()
Local aAreaSCR 	:= SCR->(GetArea())
Local aLibera   := {}
Local aEstSC1   := {}
Local aRecnoSC8 := {}
Local nX        := 0
Local nQtdSol   := 0
Local nQtdaEst  := 0
Local nQtdaEst2 := 0
Local nQtdSC    := 0
Local nQtdSC2   := 0
Local nRegSC1   := 0
Local nQtdALib  := 0
Local nQtdLib   := 0
Local lContinua := .T.
Local lQuery    := .F.
Local cQuery    := ""
Local cTipo     := ""
Local cAliasSCQ := "SCQ"
Local cAliasSC8 := "SC8"
Local cSC8Ident := ""
Local cEntrega  := If(SuperGetMv("MV_PCFILEN"),SB2->(SC7->(xFilEnt((cAliasSC7)->C7_FILENT))),xFilial("SB2"))
Local lRestCot  := If(SuperGetMV("MV_PCEXCOT")=="1",.T.,.F.)
Local lEncSC3   := .T.

cAliasSC7:= "SC7"
cAliasSD1   := "SD1"
lLast       := .F.
lAcumulados := .T.
lIncSA5     := .F.
lATUSB2     := .T.
bCtbOnLine  := {|| .T.}
Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Implantacao de um Pedido de Compra                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza dados complementares do Pedido de Compra                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lAcumulados
			If ( cAliasSC7 == "SC7" )
				RecLock(cAliasSC7)
				(cAliasSC7)->C7_USER := SA2->(RetCodUsr())
				If Empty((cAliasSC7)->C7_ENCER)
					(cAliasSC7)->C7_ENCER := If((cAliasSC7)->C7_QUANT - (cAliasSC7)->C7_QUJE > 0," ","E")
				EndIf
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza as tabelas auxiliares                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAtuSB2 .And. (cAliasSC7)->C7_RESIDUO <> "S"
			_cAlias:=Alias()
			
			dbSelectArea("SB2")
			dbSetOrder(1)
			If ( !MsSeek(cEntrega+(cAliasSC7)->C7_PRODUTO+(cAliasSC7)->C7_LOCAL) )
				CriaSB2((cAliasSC7)->C7_PRODUTO,(cAliasSC7)->C7_LOCAL,cEntrega)
			EndIf
			dBselectarea(_cAlias)
			SFGravaB2Pre("+",(cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE,(cAliasSC7)->C7_TPOP,((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE)*(cAliasSC7)->C7_QTSEGUM/(cAliasSC7)->C7_QUANT)
		EndIf
		If !lAcumulados
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Baixo as solicitacoes de compra vinculadas                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( !Empty((cAliasSC7)->C7_NUMSC) )
				If ( (cAliasSC7)->C7_TIPO==1 )
					If ( !Empty((cAliasSC7)->C7_NUMCOT) )
						If !(xFilial("SC8") == SC8->C8_FILIAL .And.;
							(cAliasSC7)->C7_NUMCOT == SC8->C8_NUM .And.;
							(cAliasSC7)->C7_PRODUTO == SC8->C8_PRODUTO .And.;
							(cAliasSC7)->C7_FORNECE == SC8->C8_FORNECE .And.;
							(cAliasSC7)->C7_LOJA == SC8->C8_LOJA .And.;
							(cAliasSC7)->C7_ITEM == SC8->C8_ITEMPED .And.;
							(cAliasSC7)->C7_NUM == SC8->C8_NUMPED )
							dbSelectArea("SC8")
							dbSetOrder(3)
							MsSeek(xFilial("SC8")+(cAliasSC7)->C7_NUMCOT+(cAliasSC7)->C7_PRODUTO+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA+(cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM)
						EndIf
						If !(xFilial("SCE") == SCE->CE_FILIAL .And.;
							SC8->C8_NUM == SCE->CE_NUMCOT .And.;
							SC8->C8_PRODUTO == SCE->CE_PRODUTO .And.;
							SC8->C8_FORNECE == SCE->CE_FORNECE .And.;
							SC8->C8_LOJA == SCE->CE_LOJA .And.;
							SC8->C8_ITEM == SCE->CE_ITEMCOT )
							dbSelectArea("SCE")
							dbSetOrder(1)
							MsSeek(xFilial("SCE")+SC8->C8_NUM+SC8->C8_ITEM+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA)
						EndIf
						If !( xFilial("SC1") == SC1->C1_FILIAL .And.;
							SC8->C8_NUM == SC1->C1_COTACAO .And.;
							SC8->C8_PRODUTO == SC1->C1_PRODUTO .And.;
							SC8->C8_IDENT == SC1->C1_IDENT )
							dbSelectArea("SC1")
							dbSetOrder(5)
							MsSeek(xFilial("SC1")+SC8->C8_NUM+SC8->C8_PRODUTO+SC8->C8_IDENT)
						EndIf
						nQtdAEst := SCE->CE_QUANT-(cAliasSC7)->C7_QUANT
						If nQtdAEst < 0
							nQtdaEst  := SC8->C8_QUANT-(cAliasSC7)->C7_QUANT
						EndIf
						nQtdAEst := Max(0,nQtdAEst)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Quando a quantidade do Pedido de Compra for alterada para um valor menor do ³
						//³que a soma das SC´s vinculadas a cotação, deve-se diminuir o Qtd da Cotacao ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ( nQtdAEst > 0 )
							RecLock("SC8")
							SC8->C8_QUANT -= nQtdAEst
							RecLock("SCE")
							SCE->CE_QUANT := Max(SCE->CE_QUANT - nQtdAEst,0)
						EndIf
						While ( !Eof() .And. xFilial("SC1") == SC1->C1_FILIAL .And.;
							SC8->C8_NUM     == SC1->C1_COTACAO .And.;
							SC8->C8_PRODUTO == SC1->C1_PRODUTO .And.;
							SC8->C8_IDENT   == SC1->C1_IDENT )
							nRegSC1   := 0
							If ( nQtdAEst > 0 )
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Quando a quantidade do Pedido de Compra for alterada para um valor menor do ³
								//³que a soma das SC´s vinculadas a cotação, deve-se diminuir a Qtd da SC.     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RecLock("SC7")
								nQtdSol := SC7->C7_QTDSOL
								SC7->C7_QTDSOL := Min(SC1->C1_QUJE,nQtdAEst)
								
								SC1->(dbSkip())
								nRegSC1 := SC1->(RecNo())
								SC1->(dbSkip(-1))
								
								If SC7->C7_QTDSOL<>0
									nQtdAEst -= SC7->C7_QTDSOL
									RecLock("SC1")
									MaAvalSC("SC1",7,"SC8","SC7",Nil,lAtuSB2)
								EndIf
								SC7->C7_QTDSOL := nQtdSol
								If nQtdAEst == 0
									Exit
								EndIf
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Implantacao de um pedido de compra atraves de cotacao                       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nQtdSol := SC7->C7_QTDSOL
								RecLock("SC1",.F.)
								SC7->C7_QTDSOL := Min(SC7->C7_QUANT-nQtdSol,SC1->C1_QUANT-SC1->C1_QUJE)
								If SC7->C7_QTDSOL > 0
									MaAvalSC("SC1",6,"SC8","SC7",Nil,lAtuSB2)
									SC7->C7_QTDSOL += nQtdSol
								Else
									SC7->C7_QTDSOL := nQtdSol
								EndIf
								If SC7->C7_QTDSOL>=SC7->C7_QUANT
									Exit
								EndIf
							EndIf
							dbSelectArea("SC1")
							If ( nRegSC1 <> 0 )
								MsGoto(nRegSC1)
							Else
								dbSkip()
							EndIf
						EndDo
					Else
						dbSelectArea("SC1")
						dbSetOrder(1)
						If ( MsSeek(xFilial("SC1")+(cAliasSC7)->C7_NUMSC+(cAliasSC7)->C7_ITEMSC) )
							MaAvalSC("SC1",6,,"SC7")
							RecLock("SC7")
						EndIf
					EndIf
				Else
					dbSelectArea("SC3")
					dbSetOrder(1)
					If ( MsSeek(xFilial("SC3")+(cAliasSC7)->C7_NUMSC+(cAliasSC7)->C7_ITEMSC,.F.) )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Ponto de entrada para impedir o encerramento do Contrato de Parceria ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ExistBlock("MT125ENC")
							lEncSC3 := ExecBlock("MT125ENC",.F.,.F.,{nEvento,cAliasSC7})
						EndIf
						If lEncSC3
							RecLock("SC3",.F.)
							SC3->C3_QUJE  += (cAliasSC7)->C7_QTDSOL
							SC3->C3_ENCER := IIf(SC3->C3_QUANT - SC3->C3_QUJE > 0," ","E")
						EndIf
					EndIf
				EndIf
			EndIf
			If ( lLast .And. (cAliasSC7)->C7_RESIDUO <> "S")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Neogrid - Verifica a existencia da Administracao colaborativa de Pedidos³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( NeoEnable("001") )
					NeoEnvPC((cAliasSC7)->C7_NUM)
				EndIf
			EndIf
			
			If (cAliasSC7)->C7_RESIDUO <> "S"
				If lIncSA5
					dbSelectArea("SB1")
					dbSetOrder(1)
					MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO)
					
					dbSelectArea("SA5")
					dbSetOrder(1)
					If !MsSeek(xFilial("SA5")+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA+(cAliasSC7)->C7_PRODUTO,.F.)
						RecLock("SA5",.T.)
						SA5->A5_FILIAL  := xFilial("SA5")
						SA5->A5_FORNECE := (cAliasSC7)->C7_FORNECE
						SA5->A5_LOJA    := (cAliasSC7)->C7_LOJA
						SA5->A5_NOMEFOR := SA2->A2_NOME
						SA5->A5_PRODUTO := SB1->B1_COD
						SA5->A5_NOMPROD := SB1->B1_DESC
					EndIf
					If !Empty(SB1->B1_GRUPO)
						dbSelectArea("SBM")
						dbSetOrder( 1 )
						If MsSeek(xFilial("SBM")+SB1->B1_GRUPO)
							dbSelectArea("SAD")
							dbSetOrder(1)
							If !MsSeek(xFilial()+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA+SB1->B1_GRUPO,.F.)
								RecLock("SAD",.T.)
								SAD->AD_FILIAL	:= xFilial("SAD")
								SAD->AD_FORNECE := (cAliasSC7)->C7_FORNECE
								SAD->AD_LOJA    := (cAliasSC7)->C7_LOJA
								SAD->AD_NOMEFOR := SA2->A2_NOME
								SAD->AD_GRUPO   := SB1->B1_GRUPO
								SAD->AD_NOMGRUP := SBM->BM_DESC
								MsUnlock()
							EndIf
						EndIf
					EndIf
				EndIf
				
				If !Empty((cAliasSC7)->C7_SEQMRP) .And. !lAcumulados .And. Type("aPeriodos") == "A"
					A711CriSH5(SC7->C7_DATPRF,SC7->C7_PRODUTO,CriaVar("C2_OPC",.F.),Space(Len(SB1->B1_REVATU)),"SC7",SC7->(Recno()),SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_OP,Max(0,SC7->C7_QUANT-SC7->C7_QUJE),"2",.T.)
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza os arquivos do SIGAPMS                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PMSWritePC(1,cAliasSC7)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim( Upper( ProcName(1) ) ) # "MA215PROC"
					If (cAliasSC7)->C7_TIPO != 2
						If Empty((cAliasSC7)->C7_NUMCOT)
							PcoDetLan("000052","01","MATA121")
							If lLast
								PcoDetLan("000052","03","MATA121")
							EndIf
						Else
							PcoDetLan("000052","02","MATA121")
						Endif
					Else
						If Empty((cAliasSC7)->C7_NUMCOT)
							PcoDetLan("000053","01","MATA122")
							If lLast
								PcoDetLan("000053","03","MATA122")
							EndIf
						Else
							PcoDetLan("000053","02","MATA122")
						Endif
					EndIf
				EndIf
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorno de um pedido de Compra                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza as tabelas auxiliares                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB2")
		dbSetOrder(1)
		If ( !MsSeek(cEntrega+(cAliasSC7)->C7_PRODUTO+(cAliasSC7)->C7_LOCAL) )
			CriaSB2((cAliasSC7)->C7_PRODUTO,(cAliasSC7)->C7_LOCAL,cEntrega)
		EndIf
		If (cAliasSC7)->C7_RESIDUO <> "S"
			SFGravaB2Pre("-",(cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE,(cAliasSC7)->C7_TPOP,((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE)*(cAliasSC7)->C7_QTSEGUM/(cAliasSC7)->C7_QUANT)
		Endif
		If !lAcumulados
			If ( !Empty((cAliasSC7)->C7_NUMSC) )
				If ( (cAliasSC7)->C7_TIPO==1 )
					If ( Empty((cAliasSC7)->C7_NUMCOT) )
						dbSelectArea("SC1")
						dbSetOrder(1)
						MsSeek(xFilial("SC1")+(cAliasSC7)->C7_NUMSC+(cAliasSC7)->C7_ITEMSC)
						MaAvalSC("SC1",7,,cAliasSC7)
					EndIf
				Else
					dbSelectArea("SC3")
					dbSetOrder(1)
					If ( MsSeek(xFilial("SC3")+(cAliasSC7)->C7_NUMSC+(cAliasSC7)->C7_ITEMSC,.F.) )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Ponto de entrada para impedir o encerramento do Contrato de Parceria ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ExistBlock("MT125ENC")
							lEncSC3 := ExecBlock("MT125ENC",.F.,.F.,{nEvento,cAliasSC7})
						EndIf
						If lEncSC3
							RecLock("SC3",.F.)
							SC3->C3_QUJE  := IIf((cAliasSC7)->C7_QTDSOL > SC3->C3_QUJE,0,SC3->C3_QUJE - (cAliasSC7)->C7_QTDSOL)
							SC3->C3_ENCER := IIf(SC3->C3_QUANT - SC3->C3_QUJE > 0," ","E")
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os arquivos do SIGAPMS                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PMSWritePC(2,cAliasSC7)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exclusao de um Pedido de Compra                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 3
		If ( !Empty((cAliasSC7)->C7_NUMSC) ) .And. lContinua
			If ( (cAliasSC7)->C7_TIPO==1 )
				If !( Empty((cAliasSC7)->C7_NUMCOT) )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza as tabelas auxiliares                                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lAcumulados
						
						If lRestCot
							dbSelectArea("SC8")
							dbSetOrder(1)
							
							aRecnoSC8 := {}
							
							#IFDEF TOP
								
								SC8->( dbCommit() )
								
								cAliasSC8 := GetNextAlias()
								
								cQuery := "SELECT C8_FILIAL,C8_NUM,C8_NUMPED,C8_PRODUTO,SC8.R_E_C_N_O_ SC8RECNO "
								cQuery += "FROM "+RetSqlName("SC8")+" SC8 "
								cQuery += "WHERE "
								cQuery += "C8_FILIAL ='" + xFilial( "SC8" )           + "' AND "
								cQuery += "C8_NUM ='" + ( cAliasSC7 )->C7_NUMCOT   + "' AND "
								cQuery += "D_E_L_E_T_=' '"
								
								cQuery := ChangeQuery( cQuery )
								
								dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasSC8, .F.,.T. )
								
								While !( cAliasSC8 )->( Eof() )
									If ( cAliasSC8 )->C8_NUMPED != "XXXXXX" .And. !Empty(( cAliasSC8 )->C8_NUMPED) .And. ( cAliasSC8 )->C8_NUMPED != (cAliasSC7)->C7_NUM
										lRestCot := .F.
										Exit
									EndIf
									
									If (cAliasSC8)->C8_PRODUTO == (cAliasSC7)->C7_PRODUTO
										AAdd( aRecnoSC8, ( cAliasSC8 )->SC8RECNO )
									EndIf
									
									( cAliasSC8 )->( dbSkip() )
								EndDo
								
								( cAliasSC8 )->( dbCloseArea() )
								dbSelectArea("SC8")
								
							#ELSE
								
								MsSeek(xFilial("SC8")+(cAliasSC7)->C7_NUMCOT)
								While !Eof() .And. xFilial("SC8") == SC8->C8_FILIAL .And. SC8->C8_NUM == SC7->C7_NUMCOT
									If SC8->C8_NUMPED != "XXXXXX" .And. !Empty(SC8->C8_NUMPED) .And. SC8->C8_NUMPED != (cAliasSC7)->C7_NUM
										lRestCot := .F.
										Exit
									EndIf
									
									If SC8->C8_PRODUTO == (cAliasSC7)->C7_PRODUTO
										AAdd( aRecnoSC8, SC8->( Recno() ) )
									EndIf
									
									dbSelectArea("SC8")
									dbSkip()
								EndDo
								
							#ENDIF
							
							dbSelectArea("SC8")
							dbSetOrder(3)
							MsSeek(xFilial("SC8")+(cAliasSC7)->C7_NUMCOT+(cAliasSC7)->C7_PRODUTO+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA+(cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM)
							
							cSC8Ident := SC8->C8_IDENT
							
							dbSelectArea("SCE")
							dbSetOrder(1)
							If MsSeek(xFilial("SCE")+SC8->C8_NUM+SC8->C8_ITEM+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA)
								RecLock("SCE",.F.,.T.)
								dbDelete()
								MsUnlock()
							EndIf
						Else
							dbSelectArea("SC8")
							dbSetOrder(3)
							MsSeek(xFilial("SC8")+(cAliasSC7)->C7_NUMCOT+(cAliasSC7)->C7_PRODUTO+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA+(cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM)
							RecLock("SC8",.F.,.T.)
							SC8->C8_OBS := "P.C. Cancel., S.C. Estornada"
							MsUnlock()
						EndIf
						
						dbSelectArea("SC1")
						dbSetOrder(5)
						MsSeek(xFilial("SC1")+SC8->C8_NUM+SC8->C8_PRODUTO+SC8->C8_IDENT)
						While ( !Eof() .And. xFilial("SC1") == SC1->C1_FILIAL .And.;
							SC8->C8_NUM     == SC1->C1_COTACAO .And.;
							SC8->C8_PRODUTO == SC1->C1_PRODUTO .And.;
							SC8->C8_IDENT   == SC1->C1_IDENT )
							aadd(aEstSC1,RecNo())
							dbSelectArea("SC1")
							dbSkip()
						EndDo
						
						For nX := 1 To Len(aEstSC1)
							SC1->(MsGoto(aEstSC1[nX]))
							RecLock("SC1",.F.)
							MaAvalSC("SC1",7,"SC8",cAliasSC7,,,lRestCot)
							If SC7->C7_QTDSOL == 0
								Exit
							EndIf
						Next nX
						
						If lRestCot
							For nX := 1 to Len( aRecnoSC8 )
								SC8->( dbGoto( aRecnoSC8[ nX ] ) )
								
								If cSC8Ident == SC8->C8_IDENT
									RecLock("SC8",.F.,.T.)
									SC8->C8_NUMPED  := ""
									SC8->C8_ITEMPED := ""
									SC8->C8_MOTIVO  := ""
									MsUnlock()
								EndIf
								
							Next nX
						EndIf
						
					EndIf
				EndIf
			EndIf
		EndIf
		If !lAcumulados
			If ( lLast ) .And. lContinua
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se tem SCR gravado faz o estorno.                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SCR")
				dbSetOrder(2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ A rotina a seguir garante o funcionamento correto na base historica dos clientes, ³
				//³ pois com a implementacao do parametro MV_AEAPROV que estende o controle de alcadas³
				//³ para a AE, em 22/07/04 foi alterada a gravacao do tipo do doc para PC e AE afim   ³
				//³ de diferenciar o tipo de doc nos arquivos SC7 e SCR sem afetar o funcionamento ant³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cTipo := "PC"
				MsSeek(xFilial() + cTipo + (cAliasSC7)->C7_NUM)
				
				If SCR->( Eof() )
					cTipo := "AE"
					MsSeek(xFilial() + cTipo + (cAliasSC7)->C7_NUM)
				EndIf
				
				While !Eof() .And. SCR->CR_FILIAL+Substr(SCR->CR_NUM,1,len((cAliasSC7)->C7_NUM)) == ;
					xFilial("SCR")+Substr((cAliasSC7)->C7_NUM,1,len((cAliasSC7)->C7_NUM)) .And. SCR->CR_TIPO == cTipo
					
					If SCR->CR_STATUS == "03"
						MaAlcDoc({SCR->CR_NUM, cTipo,SCR->CR_VALLIB,,,(cAliasSC7)->C7_APROV},SCR->CR_DATALIB,3)
					EndIf
					Reclock("SCR",.F.,.T.)
					dbDelete()
					dbSkip()
				EndDo
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Neogrid - Verifica a existencia da Administracao colaborativa de Pedidos³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( NeoEnable("001") )
					NeoEnvPC(cNumPC,2)
				EndIf
			EndIf
			If ExistBlock("MT120EXC")
				ExecBlock("MT120EXC",.f.,.f.)
			Endif
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os arquivos do SIGAPMS                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PMSWritePC(3,cAliasSC7)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If AllTrim( Upper( ProcName(1) ) ) # "MA215PROC"
			If (cAliasSC7)->C7_TIPO != 2
				If Empty((cAliasSC7)->C7_NUMCOT)
					PcoDetLan("000052","01","MATA121",.T.)
					If lLast
						PcoDetLan("000052","03","MATA121",.T.)
					EndIf
				Else
					PcoDetLan("000052","02","MATA121",.T.)
				Endif
			Else
				If Empty((cAliasSC7)->C7_NUMCOT)
					PcoDetLan("000053","01","MATA122",.T.)
					If lLast
						PcoDetLan("000053","03","MATA122",.T.)
					EndIf
				Else
					PcoDetLan("000053","02","MATA122",.T.)
				Endif
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Implantacao de um pre-documento de entrada                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 6
		If !Empty((cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			dbSelectArea("SC7")
			dbSetOrder(14)
			If !(xFilial("SC7")==SC7->C7_FILENT .And. SC7->C7_NUM==(cAliasSD1)->D1_PEDIDO .And. SC7->C7_ITEM==(cAliasSD1)->D1_ITEMPC )
				MsSeek(xFilial("SC7")+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			EndIf
			If !(Empty(SubStr(SC7->C7_ITEM,3)) .And. !Empty(SC7->C7_SEQUEN))
				RecLock("SC7",.F.)
				SC7->C7_QTDACLA += (cAliasSD1)->D1_QUANT
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorno de um pre-documento de entrada                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 7
		If !Empty((cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			dbSelectArea("SC7")
			dbSetOrder(14)
			If !(xFilial("SC7")==SC7->C7_FILENT .And. SC7->C7_NUM==(cAliasSD1)->D1_PEDIDO .And. SC7->C7_ITEM==(cAliasSD1)->D1_ITEMPC )
				MsSeek(xFilial("SC7")+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			EndIf
			If !(Empty(SubStr(SC7->C7_ITEM,3)) .And. !Empty(SC7->C7_SEQUEN))
				RecLock("SC7",.F.)
				SC7->C7_QTDACLA -= (cAliasSD1)->D1_QUANT
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Implantacao de um documento de entrada                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 8
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza dados do Pedido de Compra/Autorizacao de Entrega³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			dbSelectArea("SC7")
			dbSetOrder(14)
			If !(xFilial("SC7")==SC7->C7_FILENT .And. SC7->C7_NUM==(cAliasSD1)->D1_PEDIDO .And. SC7->C7_ITEM==(cAliasSD1)->D1_ITEMPC )
				MsSeek(xFilial("SC7")+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			EndIf
			If !(Empty(SubStr(SC7->C7_ITEM,3)) .And. !Empty(SC7->C7_SEQUEN))
				RecLock("SC7",.F.)
				SC7->C7_QUJE 	+= SD1->D1_QTDPEDI
				SC7->C7_ENCER 	:= IIF(C7_QUANT-C7_QUJE>0," ","E")
				dbSelectArea("SB2")
				dbSetOrder(1)
				If !(cEntrega==SB2->B2_FILIAL .And. SC7->C7_PRODUTO==SB2->B2_COD .And. SC7->C7_LOCAL==SB2->B2_LOCAL)
					If !MsSeek(cEntrega+SC7->C7_PRODUTO+SC7->C7_LOCAL)
						CriaSB2(SC7->C7_PRODUTO,SC7->C7_LOCAL)
					EndIf
				EndIf
				RecLock("SB2",.F.)
				SB2->B2_SALPEDI -= SD1->D1_QTDPEDI
				SB2->B2_SALPED2 -= ConvUm(SD1->D1_COD,SD1->D1_QTDPEDI,0,2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o arquivo de pre-requisicoes.                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nQtdALib := SD1->D1_QUANT
				dbSelectArea("SCQ")
				dbSetOrder(2)
				#IFDEF TOP
					cAliasSCQ := "MAAVALSD1"
					lQuery    := .T.
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_COTACAO='"+SC7->C7_NUMCOT+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_QUANT > SCQ.CQ_QTDISP AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
						Case SC7->C7_TIPO == 2
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ "
							cQuery += "WHERE "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMAE='"+SC7->C7_NUM+"' AND "
							cQuery += "SCQ.CQ_ITAE='"+SC7->C7_ITEM+"' AND "
							cQuery += "SCQ.CQ_QUANT > SCQ.CQ_QTDISP AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
						OtherWise
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_NUM='"+SC7->C7_NUMSC+"' AND "
							cQuery += "SC1.C1_ITEM='"+SC7->C7_ITEMSC+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_QUANT > SCQ.CQ_QTDISP AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
					EndCase
					
					cQuery := ChangeQuery(cQuery)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCQ)
					
					dbSelectArea(cAliasSCQ)
					While !Eof()
						If nQtdALib > 0
							SCQ->(MsGoto((cAliasSCQ)->SCQRECNO))
							If !Localiza(SCQ->CQ_PRODUTO)
								RecLock("SCQ",.F.)
								nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
								nQtdALib-= nQtdLib
								SCQ->CQ_QTDISP += nQtdLib
								SCQ->CQ_STATUSC:= ""
								dbSelectArea("SB2")
								dbSetOrder(1)
								MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
								Reclock("SB2",.F.)
								SB2->B2_QEMPSA += nQtdLib
							EndIf
						Else
							Exit
						EndIf
						dbSelectArea(cAliasSCQ)
						dbSkip()
					EndDo
					If lQuery
						dbSelectArea(cAliasSCQ)
						dbCloseArea()
						dbSelectArea("SCQ")
					EndIf
				#ELSE
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							dbSelectArea("SC1")
							dbSetOrder(5)
							MsSeek(xFilial("SC1") + SC7->C7_NUMCOT + SC7->C7_PRODUTO)
							While !Eof() .And. xFilial("SC1") == SC1->C1_FILIAL .And.;
								SC7->C7_NUMCOT == SC1->C1_COTACAO .And.;
								SC1->C1_PRODUTO == SC7->C7_PRODUTO
								AADD( aLibera,{SC1->C1_DATPRF,SC1->C1_QUJE,SC1->(RecNo())})
								dbSelectArea("SC1")
								dbSkip()
							EndDo
							aLibera:=aSort( aLibera,,, { | x , y | x[1] < y[1] } )
							For nX := Len(aLibera) To 1 STEP -1
								SC1->(MsGoto(aLibera[nx][3]))
								dbSelectArea("SCQ")
								dbSetOrder(2) //CQ2_FILIAL+CQ_NUMSC+CQ_ITEMSC
								MsSeek(xFilial("SCQ")+SC1->C1_NUM+SC1->C1_ITEM)
								While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
									SCQ->CQ_NUMSC == SC1->C1_NUM .And.;
									SCQ->CQ_ITSC == SC1->C1_ITEM
									If nQtdALib > 0 .And. SCQ->CQ_QUANT > SCQ->CQ_QTDISP .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
										RecLock("SCQ",.F.)
										nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
										nQtdALib-= nQtdLib
										SCQ->CQ_QTDISP += nQtdLib
										SCQ->CQ_STATUSC:= ""
										dbSelectArea("SB2")
										dbSetOrder(1)
										MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
										Reclock("SB2",.F.)
										SB2->B2_QEMPSA += nQtdLib
									EndIf
									dbSelectArea("SCQ")
									dbSkip()
								EndDo
							Next nX
						Case SC7->C7_TIPO==2
							dbSelectArea("SCQ")
							dbSetOrder(3)
							MsSeek(xFilial()+SC7->C7_NUM+SC7->C7_ITEM)
							While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
								SCQ->CQ_NUMAE == SC7->C7_NUM .And.;
								SCQ->CQ_ITAE == SC7->C7_ITEM
								If nQtdALib > 0 .And. !Localiza(SCQ->CQ_PRODUTO)
									RecLock("SCQ",.F.)
									nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
									nQtdALib-= nQtdLib
									SCQ->CQ_QTDISP += nQtdLib
									SCQ->CQ_STATUSC:= ""
									dbSelectArea("SB2")
									dbSetOrder(1)
									MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
									Reclock("SB2",.F.)
									SB2->B2_QEMPSA += nQtdLib
								Else
									Exit
								EndIf
								dbSelectArea(cAliasSCQ)
								dbSkip()
							EndDo
						OtherWise
							dbSelectArea("SC1")
							dbSetOrder(1)
							If MsSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC)
								dbSelectArea("SCQ")
								dbSetOrder(2)
								If MsSeek(xFilial()+SC1->C1_NUM+SC1->C1_ITEM)
									cCondicao := "CQ_FILIAL+CQ_NUMSC+CQ_ITSC==xFilial('SCQ')+SC1->C1_NUM+SC1->C1_ITEM"
									While !Eof() .And. &(cCondicao) .And. nQtdaLib > 0
										If Empty(CQ_NUMREQ) .And. !Localiza(CQ_PRODUTO)
											RecLock("SCQ",.F.)
											nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
											nQtdALib-= nQtdLib
											SCQ->CQ_QTDISP += nQtdLib
											SCQ->CQ_STATUSC:= ""
											dbSelectArea("SB2")
											dbSetOrder(1)
											MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
											Reclock("SB2",.F.)
											SB2->B2_QEMPSA += nQtdLib
											MsUnlock()
										EndIf
										dbSelectArea(cAliasSCQ)
										dbSkip()
									EndDo
								EndIf
							EndIf
					EndCase
				#ENDIF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000054","15","MATA103")
				If lLast
					PcoDetLan("000054","17","MATA103")
				EndIf
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorno de um documento de entrada                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 9
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna dados do Pedido de Compra/Autorizacao de Entrega ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			dbSelectArea("SC7")
			dbSetOrder(14)
			If !(xFilial("SC7")==SC7->C7_FILENT .And. SC7->C7_NUM==(cAliasSD1)->D1_PEDIDO .And. SC7->C7_ITEM==(cAliasSD1)->D1_ITEMPC )
				MsSeek(xFilial("SC7")+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
			EndIf
			If !(Empty(SubStr(SC7->C7_ITEM,3)) .And. !Empty(SC7->C7_SEQUEN))
				RecLock("SC7",.F.)
				SC7->C7_QUJE 	-= SD1->D1_QTDPEDI
				SC7->C7_ENCER 	:= ""
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o Saldo em Pedido do SB2                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB2")
				dbSetOrder(1)
				If !(cEntrega==SB2->B2_FILIAL .And. SC7->C7_PRODUTO==SB2->B2_COD .And.SC7->C7_LOCAL==SB2->B2_LOCAL)
					MsSeek(cEntrega+SC7->C7_PRODUTO+SC7->C7_LOCAL)
				EndIf
				If !SB2->(Eof())
					RecLock("SB2",.F.)
					SB2->B2_SALPEDI += SD1->D1_QTDPEDI
					SB2->B2_SALPED2 += ConvUm(SD1->D1_COD,SD1->D1_QTDPEDI,0,2)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna o arquivo de pre-requisicoes.                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nQtdALib := SD1->D1_QUANT
				dbSelectArea("SCQ")
				dbSetOrder(2)
				#IFDEF TOP
					cAliasSCQ := "MAAVALSD1"
					lQuery    := .T.
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_COTACAO='"+SC7->C7_NUMCOT+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
						Case SC7->C7_TIPO == 2
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ "
							cQuery += "WHERE "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMAE='"+SC7->C7_NUM+"' AND "
							cQuery += "SCQ.CQ_ITAE='"+SC7->C7_ITEM+"' AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
						OtherWise
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_NUM='"+SC7->C7_NUMSC+"' AND "
							cQuery += "SC1.C1_ITEM='"+SC7->C7_ITEMSC+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
					EndCase
					
					cQuery := ChangeQuery(cQuery)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCQ)
					
					dbSelectArea(cAliasSCQ)
					While !Eof()
						If nQtdALib > 0
							SCQ->(MsGoto((cAliasSCQ)->SCQRECNO))
							If !Localiza(SCQ->CQ_PRODUTO)
								RecLock("SCQ",.F.)
								nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
								nQtdALib-= nQtdLib
								SCQ->CQ_QTDISP -= nQtdLib
								SCQ->CQ_STATUSC:= ""
								dbSelectArea("SB2")
								dbSetOrder(1)
								MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
								Reclock("SB2",.F.)
								SB2->B2_QEMPSA -= nQtdLib
							EndIf
						Else
							Exit
						EndIf
						dbSelectArea(cAliasSCQ)
						dbSkip()
					EndDo
					If lQuery
						dbSelectArea(cAliasSCQ)
						dbCloseArea()
						dbSelectArea("SCQ")
					EndIf
				#ELSE
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							dbSelectArea("SC1")
							dbSetOrder(5)
							MsSeek(xFilial("SC1") + SC7->C7_NUMCOT + SC7->C7_PRODUTO)
							While !Eof() .And. xFilial("SC1") == SC1->C1_FILIAL .And.;
								SC7->C7_NUMCOT == SC1->C1_COTACAO .And.;
								SC1->C1_PRODUTO == SC7->C7_PRODUTO
								AADD( aLibera,{SC1->C1_DATPRF,SC1->C1_QUJE,SC1->(RecNo())})
								dbSelectArea("SC1")
								dbSkip()
							EndDo
							aLibera:=aSort( aLibera,,, { | x , y | x[1] < y[1] } )
							For nX := Len(aLibera) To 1 STEP -1
								SC1->(MsGoto(aLibera[nx][3]))
								dbSelectArea("SCQ")
								dbSetOrder(2) //CQ_FILIAL+CQ_NUMSC+CQ_ITEMSC
								MsSeek(xFilial("SCQ")+SC1->C1_NUM+SC1->C1_ITEM)
								While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
									SCQ->CQ_NUMSC == SC1->C1_NUM .And.;
									SCQ->CQ_ITSC == SC1->C1_ITEM
									If nQtdALib > 0 .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
										RecLock("SCQ",.F.)
										nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
										nQtdALib-= nQtdLib
										SCQ->CQ_QTDISP -= nQtdLib
										SCQ->CQ_STATUSC:= ""
										dbSelectArea("SB2")
										dbSetOrder(1)
										MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
										Reclock("SB2",.F.)
										SB2->B2_QEMPSA -= nQtdLib
									EndIf
									dbSelectArea("SCQ")
									dbSkip()
								EndDo
							Next nX
						Case SC7->C7_TIPO==2
							dbSelectArea("SCQ")
							dbSetOrder(3)
							MsSeek(xFilial()+SC7->C7_NUM+SC7->C7_ITEM)
							While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
								SCQ->CQ_NUMAE == SC7->C7_NUM .And.;
								SCQ->CQ_ITAE == SC7->C7_ITEM
								If nQtdALib > 0 .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
									RecLock("SCQ",.F.)
									nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
									nQtdALib-= nQtdLib
									SCQ->CQ_QTDISP -= nQtdLib
									SCQ->CQ_STATUSC:= ""
									dbSelectArea("SB2")
									dbSetOrder(1)
									MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
									Reclock("SB2",.F.)
									SB2->B2_QEMPSA -= nQtdLib
								Else
									Exit
								EndIf
								dbSelectArea(cAliasSCQ)
								dbSkip()
							EndDo
						OtherWise
							dbSelectArea("SC1")
							dbSetOrder(1)
							MsSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC)
							dbSelectArea("SCQ")
							MsSeek(xFilial()+SC1->C1_NUM+SC1->C1_ITEM)
							While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
								SCQ->CQ_NUMSC == SC1->C1_NUM .And.;
								SCQ->CQ_ITSC == SC1->C1_ITEM
								If nQtdALib > 0 .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
									RecLock("SCQ",.F.)
									nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
									nQtdALib-= nQtdLib
									SCQ->CQ_QTDISP -= nQtdLib
									SCQ->CQ_STATUSC:= ""
									dbSelectArea("SB2")
									dbSetOrder(1)
									MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
									Reclock("SB2",.F.)
									SB2->B2_QEMPSA -= nQtdLib
								Else
									Exit
								EndIf
								dbSelectArea(cAliasSCQ)
								dbSkip()
							EndDo
					EndCase
				#ENDIF
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000054","16","MATA103")
				If lLast
					PcoDetLan("000054","18","MATA103")
				EndIf
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Implantacao de um documento de entrada - Average                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 10
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza dados do Pedido de Compra/Autorizacao de Entrega³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SWN->WN_PO_NUM)
			dbSelectArea("SC7")
			dbSetOrder(1)
			If MsSeek(xFilial("SC7")+SubStr(SWN->WN_PO_NUM,1,6)+'01  '+SWN->WN_ITEM)
				RecLock("SC7",.F.)
				SC7->C7_QUJE 	+= SWN->WN_QUANT
				SC7->C7_ENCER 	:= IIF(C7_QUANT-C7_QUJE>0," ","E")
				dbSelectArea("SB2")
				dbSetOrder(1)
				If !(cEntrega==SB2->B2_FILIAL .And. SC7->C7_PRODUTO==SB2->B2_COD .And. SC7->C7_LOCAL==SB2->B2_LOCAL)
					If !MsSeek(cEntrega+SC7->C7_PRODUTO+SC7->C7_LOCAL)
						CriaSB2(SC7->C7_PRODUTO,SC7->C7_LOCAL)
					EndIf
				EndIf
				RecLock("SB2",.F.)
				SB2->B2_SALPEDI -= SWN->WN_QUANT
				SB2->B2_SALPED2 -= ConvUm(SWN->WN_PRODUTO,SWN->WN_QUANT,0,2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o arquivo de pre-requisicoes.                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nQtdALib := SWN->WN_QUANT
				dbSelectArea("SCQ")
				dbSetOrder(2)
				#IFDEF TOP
					cAliasSCQ := "MAAVALSD1"
					lQuery    := .T.
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_COTACAO='"+SC7->C7_NUMCOT+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_QUANT > SCQ.CQ_QTDISP AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
						Case SC7->C7_TIPO == 2
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ "
							cQuery += "WHERE "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMAE='"+SC7->C7_NUM+"' AND "
							cQuery += "SCQ.CQ_ITAE='"+SC7->C7_ITEM+"' AND "
							cQuery += "SCQ.CQ_QUANT > SCQ.CQ_QTDISP AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
						OtherWise
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_NUM='"+SC7->C7_NUMSC+"' AND "
							cQuery += "SC1.C1_ITEM='"+SC7->C7_ITEMSC+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_QUANT > SCQ.CQ_QTDISP AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
					EndCase
					
					cQuery := ChangeQuery(cQuery)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCQ)
					
					dbSelectArea(cAliasSCQ)
					While !Eof()
						If nQtdALib > 0
							SCQ->(MsGoto((cAliasSCQ)->SCQRECNO))
							If !Localiza(SCQ->CQ_PRODUTO)
								RecLock("SCQ",.F.)
								nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
								nQtdALib-= nQtdLib
								SCQ->CQ_QTDISP += nQtdLib
								SCQ->CQ_STATUSC:= ""
								dbSelectArea("SB2")
								dbSetOrder(1)
								MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
								Reclock("SB2",.F.)
								SB2->B2_QEMPSA += nQtdLib
							EndIf
						Else
							Exit
						EndIf
						dbSelectArea(cAliasSCQ)
						dbSkip()
					EndDo
					If lQuery
						dbSelectArea(cAliasSCQ)
						dbCloseArea()
						dbSelectArea("SCQ")
					EndIf
				#ELSE
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							dbSelectArea("SC1")
							dbSetOrder(5)
							MsSeek(xFilial("SC1") + SC7->C7_NUMCOT + SC7->C7_PRODUTO)
							While !Eof() .And. xFilial("SC1") == SC1->C1_FILIAL .And.;
								SC7->C7_NUMCOT == SC1->C1_COTACAO .And.;
								SC1->C1_PRODUTO == SC7->C7_PRODUTO
								AADD( aLibera,{SC1->C1_DATPRF,SC1->C1_QUJE,SC1->(RecNo())})
								dbSelectArea("SC1")
								dbSkip()
							EndDo
							aLibera:=aSort( aLibera,,, { | x , y | x[1] < y[1] } )
							For nX := Len(aLibera) To 1 STEP -1
								SC1->(MsGoto(aLibera[nx][3]))
								dbSelectArea("SCQ")
								dbSetOrder(1)
								MsSeek(xFilial("SCQ")+SC1->C1_NUM+SC1->C1_ITEM)
								While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
									SCQ->CQ_NUMSC == SC1->C1_NUM .And.;
									SCQ->CQ_ITSC == SC1->C1_ITEM
									If nQtdALib > 0 .And. SCQ->CQ_QUANT > SCQ->CQ_QTDISP .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
										RecLock("SCQ",.F.)
										nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
										nQtdALib-= nQtdLib
										SCQ->CQ_QTDISP += nQtdLib
										SCQ->CQ_STATUSC:= ""
										dbSelectArea("SB2")
										dbSetOrder(1)
										MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
										Reclock("SB2",.F.)
										SB2->B2_QEMPSA += nQtdLib
									EndIf
									dbSelectArea("SCQ")
									dbSkip()
								EndDo
							Next nX
						Case SC7->C7_TIPO==2
							dbSelectArea("SCQ")
							dbSetOrder(3)
							MsSeek(xFilial()+SC7->C7_NUM+SC7->C7_ITEM)
							While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
								SCQ->CQ_NUMAE == SC7->C7_NUM .And.;
								SCQ->CQ_ITAE == SC7->C7_ITEM
								If nQtdALib > 0 .And. !Localiza(SCQ->CQ_PRODUTO)
									RecLock("SCQ",.F.)
									nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
									nQtdALib-= nQtdLib
									SCQ->CQ_QTDISP += nQtdLib
									SCQ->CQ_STATUSC:= ""
									dbSelectArea("SB2")
									dbSetOrder(1)
									MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
									Reclock("SB2",.F.)
									SB2->B2_QEMPSA += nQtdLib
								Else
									Exit
								EndIf
								dbSelectArea(cAliasSCQ)
								dbSkip()
							EndDo
						OtherWise
							dbSelectArea("SC1")
							dbSetOrder(1)
							MsSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC)
							dbSelectArea("SCQ")
							MsSeek(xFilial()+SC1->C1_NUM+SC1->C1_ITEM)
							cCondicao := "CQ_FILIAL+CQ_NUMSC+CQ_ITSC==xFilial()+SC1->C1_NUM+SC1->C1_ITEM"
							While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
								SCQ->CQ_NUMSC == SC1->C1_NUM .And.;
								SCQ->CQ_ITSC == SC1->C1_ITEM
								If nQtdALib > 0 .And. !Localiza(SCQ->CQ_PRODUTO)
									RecLock("SCQ",.F.)
									nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
									nQtdALib-= nQtdLib
									SCQ->CQ_QTDISP += nQtdLib
									SCQ->CQ_STATUSC:= ""
									dbSelectArea("SB2")
									dbSetOrder(1)
									MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
									Reclock("SB2",.F.)
									SB2->B2_QEMPSA += nQtdLib
								Else
									Exit
								EndIf
								dbSelectArea(cAliasSCQ)
								dbSkip()
							EndDo
					EndCase
				#ENDIF
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorno de um documento de entrada                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case nEvento == 11
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna dados do Pedido de Compra/Autorizacao de Entrega ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SWN->WN_PO_NUM)
			dbSelectArea("SC7")
			dbSetOrder(1)
			If MsSeek(xFilial("SC7")+SubStr(SWN->WN_PO_NUM,1,6)+'01  '+SWN->WN_ITEM)
				RecLock("SC7",.F.)
				SC7->C7_QUJE 	-= SWN->WN_QUANT
				SC7->C7_ENCER 	:= ""
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o Saldo em Pedido do SB2                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB2")
				dbSetOrder(1)
				If !(cEntrega==SB2->B2_FILIAL .And. SC7->C7_PRODUTO==SB2->B2_COD .And.SC7->C7_LOCAL==SB2->B2_LOCAL)
					MsSeek(cEntrega+SC7->C7_PRODUTO+SC7->C7_LOCAL)
				EndIf
				If !SB2->(Eof())
					RecLock("SB2",.F.)
					SB2->B2_SALPEDI += SWN->WN_QUANT
					SB2->B2_SALPED2 += ConvUm(SWN->WN_PRODUTO,SWN->WN_QUANT,0,2)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna o arquivo de pre-requisicoes.                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nQtdALib := SWN->WN_QUANT
				dbSelectArea("SCQ")
				dbSetOrder(2)
				#IFDEF TOP
					cAliasSCQ := "MAAVALSD1"
					lQuery    := .T.
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_COTACAO='"+SC7->C7_NUMCOT+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
						Case SC7->C7_TIPO == 2
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ "
							cQuery += "WHERE "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMAE='"+SC7->C7_NUM+"' AND "
							cQuery += "SCQ.CQ_ITAE='"+SC7->C7_ITEM+"' AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
						OtherWise
							cQuery := "SELECT SCQ.R_E_C_N_O_ SCQRECNO "
							cQuery += "FROM "+RetSqlName("SCQ")+" SCQ, "
							cQuery += RetSqlName("SC1")+" SC1 "
							cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
							cQuery += "SC1.C1_NUM='"+SC7->C7_NUMSC+"' AND "
							cQuery += "SC1.C1_ITEM='"+SC7->C7_ITEMSC+"' AND "
							cQuery += "SC1.C1_PRODUTO='"+SC7->C7_PRODUTO+"' AND "
							cQuery += "SC1.D_E_L_E_T_=' ' AND "
							cQuery += "SCQ.CQ_FILIAL='"+xFilial("SCQ")+"' AND "
							cQuery += "SCQ.CQ_NUMSC=SC1.C1_NUM AND "
							cQuery += "SCQ.CQ_ITSC=SC1.C1_ITEM AND "
							cQuery += "SCQ.CQ_NUMREQ = '"+Space(Len(SCQ->CQ_NUMREQ))+"' AND "
							cQuery += "SCQ.D_E_L_E_T_=' ' "
							cQuery += "ORDER BY SC1.C1_FILIAL,SC1.C1_DATPRF "
					EndCase
					
					cQuery := ChangeQuery(cQuery)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCQ)
					
					dbSelectArea(cAliasSCQ)
					While !Eof()
						If nQtdALib > 0
							SCQ->(MsGoto((cAliasSCQ)->SCQRECNO))
							If !Localiza(SCQ->CQ_PRODUTO)
								RecLock("SCQ",.F.)
								nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
								nQtdALib-= nQtdLib
								SCQ->CQ_QTDISP -= nQtdLib
								SCQ->CQ_STATUSC:= ""
								dbSelectArea("SB2")
								dbSetOrder(1)
								MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
								Reclock("SB2",.F.)
								SB2->B2_QEMPSA -= nQtdLib
							EndIf
						Else
							Exit
						EndIf
						dbSelectArea(cAliasSCQ)
						dbSkip()
					EndDo
					If lQuery
						dbSelectArea(cAliasSCQ)
						dbCloseArea()
						dbSelectArea("SCQ")
					EndIf
				#ELSE
					Do Case
						Case !Empty(SC7->C7_NUMCOT)
							dbSelectArea("SC1")
							dbSetOrder(5)
							MsSeek(xFilial("SC1") + SC7->C7_NUMCOT + SC7->C7_PRODUTO)
							While !Eof() .And. xFilial("SC1") == SC1->C1_FILIAL .And.;
								SC7->C7_NUMCOT == SC1->C1_COTACAO .And.;
								SC1->C1_PRODUTO == SC7->C7_PRODUTO
								AADD( aLibera,{SC1->C1_DATPRF,SC1->C1_QUJE,SC1->(RecNo())})
								dbSelectArea("SC1")
								dbSkip()
							EndDo
							aLibera:=aSort( aLibera,,, { | x , y | x[1] < y[1] } )
							For nX := Len(aLibera) To 1 STEP -1
								SC1->(MsGoto(aLibera[nx][3]))
								dbSelectArea("SCQ")
								dbSetOrder(1)
								MsSeek(xFilial("SCQ")+SC1->C1_NUM+SC1->C1_ITEM)
								While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
									SCQ->CQ_NUMSC == SC1->C1_NUM .And.;
									SCQ->CQ_ITSC == SC1->C1_ITEM
									If nQtdALib > 0 .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
										RecLock("SCQ",.F.)
										nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
										nQtdALib-= nQtdLib
										SCQ->CQ_QTDISP -= nQtdLib
										SCQ->CQ_STATUSC:= ""
										dbSelectArea("SB2")
										dbSetOrder(1)
										MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
										Reclock("SB2",.F.)
										SB2->B2_QEMPSA -= nQtdLib
									EndIf
									dbSelectArea("SCQ")
									dbSkip()
								EndDo
							Next nX
						Case SC7->C7_TIPO==2
							dbSelectArea("SCQ")
							dbSetOrder(3)
							MsSeek(xFilial()+SC7->C7_NUM+SC7->C7_ITEM)
							While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
								SCQ->CQ_NUMAE == SC7->C7_NUM .And.;
								SCQ->CQ_ITAE == SC7->C7_ITEM
								If nQtdALib > 0 .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
									RecLock("SCQ",.F.)
									nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
									nQtdALib-= nQtdLib
									SCQ->CQ_QTDISP -= nQtdLib
									SCQ->CQ_STATUSC:= ""
									dbSelectArea("SB2")
									dbSetOrder(1)
									MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
									Reclock("SB2",.F.)
									SB2->B2_QEMPSA -= nQtdLib
								Else
									Exit
								EndIf
								dbSelectArea(cAliasSCQ)
								dbSkip()
							EndDo
						OtherWise
							dbSelectArea("SC1")
							dbSetOrder(1)
							MsSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC)
							dbSelectArea("SCQ")
							MsSeek(xFilial()+SC1->C1_NUM+SC1->C1_ITEM)
							While !Eof() .And. SCQ->CQ_FILIAL == xFilial("SCQ") .And.;
								SCQ->CQ_NUMSC == SC1->C1_NUM .And.;
								SCQ->CQ_ITSC == SC1->C1_ITEM
								If nQtdALib > 0 .And. Empty(SCQ->CQ_NUMREQ) .And. !Localiza(SCQ->CQ_PRODUTO)
									RecLock("SCQ",.F.)
									nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
									nQtdALib-= nQtdLib
									SCQ->CQ_QTDISP -= nQtdLib
									SCQ->CQ_STATUSC:= ""
									dbSelectArea("SB2")
									dbSetOrder(1)
									MsSeek(cEntrega+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
									Reclock("SB2",.F.)
									SB2->B2_QEMPSA -= nQtdLib
								Else
									Exit
								EndIf
								dbSelectArea(cAliasSCQ)
								dbSkip()
							EndDo
					EndCase
				#ENDIF
			EndIf
		EndIf
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do CodeBlock de Contabilizacao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Eval(bCtbOnLine,nEvento)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSCR)
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???
???Fun??o    ?SFGravaB2Pre? Autor ?Rodrigo de A. Sartorio ? Data ?21/01/1999???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ???
???Descri??o ? Funcao para atualizacao dos campos B2_SALPEDI / B2_SALPPRE ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Sintaxe   ? SFGravaB2Pre(ExpC1,ExpN1,ExpC2)                              ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Parametros? ExpC1 = Sinal da Opera??o  ("+" ou "-")                    ???
???          ? ExpN1 = Quantidade da Operacao                             ???
???          ? ExpC2 = Tipo da OP/SC                                      ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Uso       ? Mata650                                                    ???
??ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ??
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function SFGravaB2Pre(cSinal,nQuant,cTpOp,nQtSeg)
Local nMultiplic:=If(cSinal == "-",-1,1)
nQtSeg := 0
cTpOp:=IF(cTpOp==NIL,SC2->C2_TPOP,cTpOp)
nQtSeg:=ConvUm(SB2->B2_COD,nQuant,nQtSeg,2)
Reclock("SB2",.F.)
If cTpOp == "P"	// OP PREVISTA
	Replace B2_SALPPRE With B2_SALPPRE+(nQuant*nMultiplic)
ElseIf cTpOp $ " F"	// OP FIRME
	Replace B2_SALPEDI With B2_SALPEDI+(nQuant*nMultiplic)
	Replace B2_SALPED2 With B2_SALPED2+(nQtSeg*nMultiplic)
EndIf
MsUnlock()
Return


//***********************
Static Function CriaSX1()
//***********************

aSx1 := {}
//                                                                                                    14                            20              24                      30                          39
AADD(aSX1 ,{cPerg,"01" ,"Filial de         " , "","", "mv_ch1" ,"C" ,02, 0 ,0,"G" ,"","mv_par01","     ","","","","","         ","","","","","        ","","","","","","","","","","","","","","SM0", "","","","","" })
AADD(aSX1 ,{cPerg,"02" ,"Filial Ate        " , "","", "mv_ch2" ,"C" ,02, 0 ,0,"G" ,"","mv_par02","     ","","","","","         ","","","","","        ","","","","","","","","","","","","","","SM0", "","","","","" })
AADD(aSX1 ,{cPerg,"03" ,"Produto de        " , "","", "mv_ch3" ,"C" ,15, 0 ,0,"G" ,"","mv_par03","     ","","","","","         ","","","","","        ","","","","","","","","","","","","","","SB1", "","","","","" })
AADD(aSX1 ,{cPerg,"04" ,"Produto Ate       " , "","", "mv_ch4" ,"C" ,15, 0 ,0,"G" ,"","mv_par04","     ","","","","","         ","","","","","        ","","","","","","","","","","","","","","SB1", "","","","","" })
AADD(aSX1 ,{cPerg,"05" ,"Local de          " , "","", "mv_ch5" ,"C" ,02, 0 ,0,"G" ,"","mv_par05","     ","","","","","         ","","","","","        ","","","","","","","","","","","","","","", "","","","","" })
AADD(aSX1 ,{cPerg,"06" ,"Local Ate         " , "","", "mv_ch6" ,"C" ,02, 0 ,0,"G" ,"","mv_par06","     ","","","","","         ","","","","","        ","","","","","","","","","","","","","","", "","","","","" })


DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("AJUSB201")
	
	DbSeek("AJUSB2")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "AJUSB2"
		Reclock("SX1",.F.,.F.)
		DbDelete()
		MsunLock()
		DbSkip()
	End
	
	For X1:=1 to Len(aSX1)
		RecLock("SX1",.T.)
		For Z:=1 To FCount()
			FieldPut(Z,aSx1[X1,Z])
		Next
		MsunLock()
	Next
	
Endif

Return


// MV_PAR01 - Filial de
// MV_PAR02 - Filial Ate
// MV_PAR03 - Produto de
// MV_PAR04 - Produto Ate
// MV_PAR05 - Local de
// MV_PAR06 - Local Ate

STATIC FUNCTION AJUZERASALPEDI()
If (!Empty(xFilial("SB2")) .Or. cFilAnt == cFirst )
	dbSelectArea("SX2")
	dbSetOrder(1)
	MsSeek("SB2")
	cMensagem := AllTrim(X2Nome())
	cMensagem := Lower(cMensagem)
	cMensagem := Upper(SubStr(cMensagem,1,1))+SubStr(cMensagem,2)
	#IFDEF TOP
		cAliasSB2 := "SB2MA215PROC"
		cQuery := "SELECT MIN(R_E_C_N_O_) MINRECNO,"
		cQuery += "MAX(R_E_C_N_O_) MAXRECNO "
		cQuery += "FROM "+RetSqlName("SB2")+" "
		cQuery += "WHERE B2_FILIAL='"+xFilial("SB2")+"' AND "
		cQuery += "B2_COD >='"+MV_PAR03+"' AND "
		cQuery += "B2_COD <='"+MV_PAR04+"' AND "
		cQuery += "B2_LOCAL >='"+MV_PAR05+"' AND "
		cQuery += "B2_LOCAL <='"+MV_PAR06+"' AND "
		cQuery += "D_E_L_E_T_=' '"
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB2)
		nMax := (cAliasSB2)->MAXRECNO
		nMin := (cAliasSB2)->MINRECNO
		dbCloseArea()
		
		dbSelectArea("SB2")
		cQuery := "UPDATE "
		cQuery += RetSqlName("SB2")+" "
		cQuery += "SET B2_SALPEDI = 0,"
		cQuery += "B2_SALPED2 = 0 "
		cQuery += "WHERE B2_FILIAL='"+xFilial("SB2")+"' AND "
		cQuery += "D_E_L_E_T_=' ' AND "
		If !lBat
			//				oObj:SetRegua2(Int(nMax/4096)+1)
		EndIf
		For nX := nMin To nMax+4096 STEP 4096
			cChave := "R_E_C_N_O_>="+Str(nX,10,0)+" AND R_E_C_N_O_<="+Str(nX+4096,10,0)+""
			cRegra := cQuery+cChave
			IF TcSqlExec(cRegra) < 0
				MSGSTOP("Ocorreu erro na Instrucao para o Banco !!!")
			ENDIF
			
			If !lBat
				//		oObj:IncRegua2(cMensagem)
			EndIf
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A tabela eh fechada para restaurar o buffer da aplicacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB2")
		dbCloseArea()
		ChkFile("SB2",.T.)
	#ENDIF
ENDIF
Return     


User Function M125SC()
Final("Vou fechar !!!")
Return .F.

User Function M215SC()
Final("Vou fechar !!!")
Return .F.
