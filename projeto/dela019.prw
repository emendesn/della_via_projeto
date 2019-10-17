/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³D19GRVLOJAºAutor  ³Paulo Benedet          º Data ³  30/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gerar orcamento do sigaloja.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cNumSUA - Numero do orcamento televendas                      º±±
±±º          ³ cLojDst - Codigo da loja destino (onde sera gravado o orc)    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Rotina executada pelo ponto de entrada TMKVFIM.               º±±
±±º          ³ Eg: P_D19GrvLoja("000001","02")                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºMarcio Dom³29/08/06³      ³Alteracao gravacao do campo L2_EMISSAO com o   º±±
±±º          ³        ³      ³conteudo do UA_EMISSAO, para correção de nc    º±±
±±º          ³        ³      ³na funcao LJGRCSB3							 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function D19GrvLoja(cNumSUA, cLojDst)
Local aAreaIni := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSL1 := SL1->(GetArea())
Local aAreaSL2 := SL2->(GetArea())
Local aAreaSL4 := SL4->(GetArea())
Local aAreaSM0 := SM0->(GetArea())
Local aAreaSUA := SUA->(GetArea())
Local aAreaSUB := SUB->(GetArea())
Local aAreaSX2 := SX2->(GetArea())

Local aDadosSL4 := {}
Local nDin := 0
Local nCar := 0
Local nChe := 0
Local nFin := 0
Local nVal := 0
Local nCon := 0
Local nOut := 0
Local nDescL2 := TamSx3("L2_DESC")[2]
Local cLojSUA := ""
Local cNumItem := ""
Local cNumSL1 := ""
Local nTotSL4 := 0
Local cSavFil := cFilAnt
Local cTes    := ""
Local cCFO    := ""
Local lNovo := .F.
Local cMay := ""
Local i := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do array aDadosSL4                                 ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ [1] - Data de pagamento das parcelas                         ³
//³ [2] - Valor da parcelas                                      ³
//³ [3] - Forma de Pagamento                                     ³
//³ [4] - Observacoes                                            ³
//³ [5] - Codigo da Administradora financeira                    ³
//| [6] - Sequencia para controle de múltiplas transaçõies		 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLojDst := AllTrim(cLojDst)

// Posiciona condicao negociada televendas
dbSelectArea("SL4")
dbSetOrder(1) //L4_FILIAL+L4_NUM+L4_ORIGEM
dbSeek(xFilial("SL4") + cNumSUA + "SIGATMK")

While !EOF();
	.And. L4_FILIAL == xFilial("SL4");
	.And. L4_NUM == cNumSUA;
	.And. rTrim(L4_ORIGEM) == "SIGATMK"
	
	// Guarda condicao negociada televendas
	aAdd(aDadosSL4, {SL4->L4_DATA, SL4->L4_VALOR, SL4->L4_FORMA, SL4->L4_OBS, SL4->L4_ADMINIS, SL4->L4_COMP})
	
	// Acumula valores nas formas de pagamento
	If rTrim(SL4->L4_FORMA) == "R$"
		nDin += SL4->L4_VALOR
	ElseIf rTrim(SL4->L4_FORMA) == "CC"
		nCar += SL4->L4_VALOR
	ElseIf rTrim(SL4->L4_FORMA) == "CH"
		nChe += SL4->L4_VALOR
	ElseIf rTrim(SL4->L4_FORMA) == "FI"
		nFin += SL4->L4_VALOR
	ElseIf rTrim(SL4->L4_FORMA) == "VA"
		nVal += SL4->L4_VALOR
	ElseIf rTrim(SL4->L4_FORMA) == "CO"
		nCon += SL4->L4_VALOR
	Else
		nOut += SL4->L4_VALOR
	EndIf
	
	dbSelectArea("SL4")
	dbSkip()
EndDo

//Begin Transaction

// Posiciona cabecalho televendas
dbSelectArea("SUA")
dbSetOrder(1) //UA_FILIAL+UA_NUM
dbSeek(xFilial("SUA") + cNumSUA)

// Verifica se eh inclusao ou alteracao
If !Empty(SUA->UA_ORCSL1)
	dbSelectArea("SL1")
	dbSetOrder(1) //L1_FILIAL+L1_NUM
	
	If cLojDst == Left(SUA->UA_ORCSL1, 2)
		// Loja de destino permanece a mesma do atendimento anterior
		If dbSeek(SUA->UA_ORCSL1)
			lNovo := .F.
		Else
			lNovo := .T.
		EndIf
	Else
		// Loja de destino foi alterada
		lNovo := .T.
		
		// Limpa dados de televendas do orcamento original
		If dbSeek(SUA->UA_ORCSL1)
			RecLock("SL1", .F.)
			SL1->L1_NUMSUA  := ""
			SL1->L1_LOJSUA  := ""
			msUnlock()
		EndIf
	EndIf
Else
	lNovo := .T.
EndIf

If lNovo // Inclusao
	cNumSL1 := GetSXENum("SL1", "L1_NUM", cLojDst + X2Path("SL1"))
	cMay    := "SL1" + cLojDst + cNumSL1
	
	dbSelectArea("SL1")
	dbSetOrder(1)  //L1_FILIAL+L1_NUM
	While msSeek(cLojDst + cNumSL1) .Or. !MayIUseCode(cMay)
		cNumSL1 := Soma1(cNumSL1, Len(cNumSL1))
		cMay 	:= "SL1" + cLojDst + cNumSL1
	EndDo
	
	If __lSX8
		ConfirmSX8()
	EndIf
Else // Alteracao
	cNumSL1 := SubStr(SUA->UA_ORCSL1, 3)
	
	// Apaga os items da forma de pagamento do SL4
	dbSelectArea("SL4")
	dbSetOrder(1) //L4_FILIAL+L4_NUM+L4_ORIGEM
	If dbSeek(cLojDst + cNumSL1)  // Nao preenche a ORIGEM porque e um ORCAMENTO DO SIGALOJA
		While !EOF();
			.And. L4_FILIAL == cLojDst;
			.And. L4_NUM == cNumSL1;
			.And. Empty(L4_ORIGEM)
			
			RecLock("SL4", .F., .T.)
			dbDelete()
			msUnlock()
			
			dbSelectArea("SL4")
			dbSkip()
		EndDo
	EndIf
	
	// Posiciona no orcamento correto
	dbSelectArea("SL1")
	dbSetOrder(1) //L1_FILIAL+L1_NUM
	dbSeek(cLojDst + cNumSL1)
EndIf

// Posiciona clientes
dbSelectArea("SA1")
dbSetOrder(1) //A1_FILIAL+A1_COD+A1_LOJA
dbSeek(xFilial("SA1") + SUA->(UA_CLIENTE + UA_LOJA))

// Atualiza cabecalho televendas
RecLock("SUA", .F.)
SUA->UA_DTLIM   := M->UA_DTLIM
SUA->UA_ORCSL1  := cLojDst + cNumSL1
msUnlock()

//aLinhas := TkMemo(, TamSX3("L1_OBSORC")[1])
// Verifica o tipo da tabela SUA
SX2->(dbSetOrder(1)) // X2_CHAVE
SX2->(dbSeek("SUA"))
cLojSUA := IIf(SX2->X2_MODO == "E", cFilAnt, Space(2))

// Gravacao cabecalho loja
RecLock("SL1", lNovo)
SL1->L1_FILIAL  := cLojDst
SL1->L1_NUM     := cNumSL1
SL1->L1_CLIENTE := SUA->UA_CLIENTE
SL1->L1_EMISSAO := SUA->UA_EMISSAO
SL1->L1_VLRLIQ  := SUA->UA_VLRLIQ
SL1->L1_VLRTOT  := SUA->UA_VLRLIQ
SL1->L1_VALMERC := SUA->UA_VALBRUT
SL1->L1_VALBRUT := SUA->UA_VALBRUT
SL1->L1_DESCONT := SUA->UA_DESCONT
SL1->L1_DTLIM   := SUA->UA_DTLIM
SL1->L1_LOJA    := SUA->UA_LOJA
SL1->L1_VEND    := SUA->UA_VEND
SL1->L1_COMIS   := SUA->UA_COMIS
SL1->L1_TIPOCLI := SA1->A1_TIPO
SL1->L1_DINHEIR := nDin
SL1->L1_CHEQUES := nChe
SL1->L1_CARTAO  := nCar
SL1->L1_CONVENI := nCon
SL1->L1_VALES   := nVal
SL1->L1_FINANC  := nFin
SL1->L1_OUTROS  := nOut
SL1->L1_COND    := 0
SL1->L1_CONDPG  := SUA->UA_CONDPG
SL1->L1_FORMA   := Len(aDadosSL4)
SL1->L1_ENTRADA := SUA->UA_ENTRADA
SL1->L1_PARCELA := Len(aDadosSL4)
SL1->L1_FINANC  := SUA->UA_FINANC
SL1->L1_JUROS   := SUA->UA_JUROS
SL1->L1_PARCELA := SUA->UA_PARCELA
SL1->L1_IMPRIME := "1N"
SL1->L1_FRETE   := SUA->UA_FRETE
//L1_CODCON  := GetMV("FS_DEL003")
SL1->L1_CODTAB  := SUA->UA_TABELA
SL1->L1_NOMCLI  := SA1->A1_NOME
SL1->L1_NUMSUA  := SUA->UA_NUM
SL1->L1_LOJSUA  := cLojSUA
SL1->L1_TIPOVND := SUA->UA_TIPOVND
SL1->L1_COMPL   := SUA->UA_COMPL
SL1->L1_BCO1    := SUA->UA_BCO1
SL1->L1_CODCON  := SUA->UA_CODCON
SL1->L1_PLACAV  := SUA->UA_PLACA
//L1_OBSORC  := 
msUnlock()

// Forca loja destino
dbSelectArea("SM0")
dbSetOrder(1) // M0_CODIGO+M0_CODFIL
dbSeek(cEmpAnt + cLojDst)

// Posiciona TES
dbSelectArea("SF4")
dbSetOrder(1) //F4_FILIAL+F4_CODIGO

// Posiciona itens sigaloja
dbSelectArea("SL2")
dbSetOrder(1) //L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO

// Posiciona itens televendas
dbSelectArea("SUB")
dbSetOrder(1) //UB_FILIAL+UB_NUM+UB_ITEM+UB_PRODUTO
dbSeek(xFilial("SUB") + cNumSUA)

// Gravacao itens sigaloja
While !EOF();
	.And. UB_FILIAL == xFilial("SUB");
	.And. UB_NUM == cNumSUA
	
	// Forca loja destino
	cFilAnt := cLojDst
	
	// Busca TES e CFOP
	cTes := U_maTesVia(2, SUB->UB_OPER, SUA->UA_CLIENTE, SUA->UA_LOJA,, SUB->UB_PRODUTO, "UB_TES")
	cCFO := RetField("SF4", 1, xFilial("SF4") + cTes, "F4_CF")
	
	// Retorna cFilAnt
	cFilAnt := cSavFil
	
	// Verifica item sigaloja
	If SL2->(dbSeek(cLojDst + cNumSL1 + SUB->UB_ITEM))
		RecLock("SL2", .F.)
	Else
		RecLock("SL2", .T.)
	EndIf
	L2_FILIAL  := cLojDst
	L2_NUM     := cNumSL1
	L2_PRODUTO := SUB->UB_PRODUTO
	L2_DESCRI  := RetField("SB1", 1, xFilial("SB1") + SUB->UB_PRODUTO, "B1_DESC")
	L2_ITEM    := SUB->UB_ITEM
	L2_QUANT   := SUB->UB_QUANT
	L2_VRUNIT  := SUB->UB_VRUNIT
	L2_VLRITEM := SUB->UB_VLRITEM
	L2_LOCAL   := SUB->UB_LOCAL
	L2_UM      := SUB->UB_UM
	L2_DESC    := Round((SUB->UB_VALDESC / (SUB->UB_PRCTAB * SUB->UB_QUANT)) * 100,nDescL2)
	L2_VALDESC := SUB->UB_VALDESC
	L2_TES     := cTes
	L2_CF      := cCFO
	L2_TABELA  := "1"
//	L2_EMISSAO := SUB->UB_EMISSAO *** Alterado Marcio 
	L2_EMISSAO := SUA->UA_EMISSAO
	L2_PRCTAB  := SUB->UB_PRCTAB
	L2_MM      := SUB->UB_MM
	L2_CM1     := SUB->UB_CM1
	L2_DESPMM  := SUB->UB_DESPMM
	//Inclusao - Norbert - 04/09/05
	L2_TPOPER  := SUB->UB_OPER
	//Fim Inclusao
	msUnlock()
	
	cNumItem := SL2->L2_ITEM
	dbSelectArea("SUB")
	dbSkip()
EndDo

// Apaga itens sigaloja deletados pelo televendas
cNumItem := SomaIt(SL2->L2_ITEM)

dbSelectArea("SL2")
dbSeek(cLojDst + cNumSL1 + cNumItem)

While !EOF();
	.And. L2_FILIAL == cLojDst;
	.And. L2_NUM == cNumSL1
	
	If L2_ITEM < cNumItem
		dbSkip()
		Loop
	EndIf
	
	RecLock("SL2", .F., .T.)
	dbDelete()
	msUnlock()
	
	dbSelectArea("SL2")
	dbSkip()
EndDo

// Grava condicao negociada sigaloja
nTotSL4 := Len(aDadosSL4)

For i := 1 to nTotSL4
	RecLock("SL4", .T.)
	L4_FILIAL  := cLojDst
	L4_NUM     := cNumSL1
	L4_DATA    := aDadosSL4[i][1]
	L4_VALOR   := aDadosSL4[i][2]
	L4_FORMA   := aDadosSL4[i][3]
	L4_OBS     := aDadosSL4[i][4]
	L4_ORIGEM  := ""
	L4_ADMINIS := aDadosSL4[i][5]
	L4_COMP    := aDadosSL4[i][6]
	msUnlock()
Next i

//End Transaction

// Retorna ambiente
RestArea(aAreaSA1)
RestArea(aAreaSL1)
RestArea(aAreaSL2)
RestArea(aAreaSL4)
RestArea(aAreaSM0)
RestArea(aAreaSUA)
RestArea(aAreaSUB)
RestArea(aAreaSX2)
RestArea(aAreaIni)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³D19APAGALOJAºAutor  ³Paulo Benedet        º Data ³  30/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Apagar orcamento do sigaloja.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cNumSUA - Numero do orcamento televendas                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Rotina executada pelo ponto de entrada TMKVDC.                º±±
±±º          ³ Eg: P_D19ApagaLoja("000001")                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function D19ApagaLoja(cNumSUA)
Local aAreaIni := GetArea()
Local aAreaSUA := SUA->(GetArea())
Local aAreaSL1 := SL1->(GetArea())
Local aAreaSL2 := SL2->(GetArea())
Local aAreaSL4 := SL4->(GetArea())

Local cNumSL1 := ""

// Posiciona atendimento televendas
dbSelectArea("SUA")
dbSetOrder(1)
dbSeek(xFilial("SUA") + cNumSUA)

// Posiciona orcamento sigaloja
dbSelectArea("SL1")
dbOrderNickName("SL1_FS1") //L1_FILIAL+L1_NUMSUA
If !dbSeek(SUA->UA_LOJASL1 + cNumSUA)
	Return
EndIf

cNumSL1 := SL1->L1_NUM

//Begin Transaction

// Apaga orcamento do sigaloja
RecLock("SL1", .F., .T.)
dbDelete()
msUnlock()
//dbCommit()

// Apaga itens do orcamento sigaloja
dbSelectArea("SL2")
dbSetOrder(1) //L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO
dbSeek(SUA->UA_LOJASL1 + cNumSL1)

While !EOF();
	.And. L2_FILIAL == SUA->UA_LOJASL1;
	.And. L2_NUM == cNumSL1
	
	RecLock("SL2", .F., .T.)
	dbDelete()
	msUnlock()
//	dbCommit()
	
	dbSelectArea("SL2")
	dbSkip()
EndDo

// Apaga condicoes negociadas sigaloja
dbSelectArea("SL4")
dbSetOrder(1) //L4_FILIAL+L4_NUM+L4_ORIGEM
dbSeek(SUA->UA_LOJASL1 + cNumSL1)

While !EOF();
	.And. L4_FILIAL == SUA->UA_LOJASL1;
	.And. L4_NUM == cNumSL1;
	.And. Empty(L4_ORIGEM)
	
	RecLock("SL4", .F., .T.)
	dbDelete()
	msUnlock()
//	dbCommit()
	
	dbSelectArea("SL4")
	dbSkip()
EndDo

//End Transaction

// Devolve ambiente
RestArea(aAreaSUA)
RestArea(aAreaSL1)
RestArea(aAreaSL2)
RestArea(aAreaSL4)
RestArea(aAreaIni)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ D19AtuTlv  ºAutor  ³Paulo Benedet        º Data ³  31/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizar informacoes de faturamento no televendas.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cCodLoj - Codigo da loja/filial sigaloja                      º±±
±±º          ³ cNumSL1 - Numero do orcamento sigaloja                        º±±
±±º          ³ cNumSUA - Numero do orcamento televendas                      º±±
±±º          ³ nOpc - Operacao - 1 - Faturamento                             º±±
±±º          ³                   2 - Cancelamento                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Rotina executada pelo ponto de entrada LJ7002.                º±±
±±º          ³ Eg: P_D19AtuTlv(L1_FILIAL,L1_NUM,L1_NUMSUA,1)                 º±±
±±º          ³                                                               º±±
±±º          ³ Rotina executada pelo ponto de entrada LJ140DEL               º±±
±±º          ³ Eg: P_D19AtuTlv(L1_FILIAL,L1_NUM,L1_NUMSUA,2)                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function D19AtuTlv(cCodLoj, cNumSL1, cNumSUA, nOpc)
Local aAreaIni := GetArea()
Local aAreaSL1 := SL1->(GetArea())
Local aAreaSUA := SUA->(GetArea())

// Posiciona cabecalho sigaloja
dbSelectArea("SL1")
dbSetOrder(1) // L1_FILIAL+L1_NUM
dbSeek(cCodLoj + cNumSL1)

// Posiciona televendas
dbSelectArea("SUA")
dbSetOrder(1) // UA_FILIAL+UA_NUM
If dbSeek(SL1->(L1_LOJSUA + L1_NUMSUA))
	// Atualiza televendas
	RecLock("SUA", .F.)
	If nOpc == 1 // Faturamento
		UA_VDALOJ := SL1->L1_VLRTOT
		UA_EMISNF := SL1->L1_EMISNF
		UA_SERIE  := SL1->L1_SERIE
		UA_DOC    := SL1->L1_DOC
		UA_OPER   := "1"
		UA_STATUS := "NF."
	ElseIf nOpc == 2 // Cancelamento
		UA_VDALOJ := 0
		UA_EMISNF := CtoD("  /  /  ")
		UA_SERIE  := ""
		UA_DOC    := ""
		UA_OPER   := "2"
		UA_STATUS := "SUP"
	EndIf
	msUnlock()
//	dbCommit()
EndIf

// Retorna ambiente
RestArea(aAreaSL1)
RestArea(aAreaSUA)
RestArea(aAreaIni)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ D19AtuMM   ºAutor  ³Paulo Benedet        º Data ³  03/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizar margem media no televendas                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nRet - Valor da margem media                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Rotina executada pelos gatilhos: UB_PRODUTO, UB_VRUNIT,       º±±
±±º          ³ UB_DESC, UB_VALDESC, UB_ACRE, UB_VALACRE                      º±±
±±º          ³ Eg: Dominio : UB_PRODUTO                                      º±±
±±º          ³     Cont Dom: UB_MM                                           º±±
±±º          ³     Tipo    : Primario                                        º±±
±±º          ³     Regra   : P_D19AtuMM()                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function D19AtuMM()
Local aAreaIni := GetArea()
Local nRet  := 0
Local aMM   := {}
Local cLoja := "" // codigo da loja onde sera calculada a mm

// Busca loja para calculo do MM
cLoja := IIf(Empty(M->UA_LOJASL1), cFilAnt, M->UA_LOJASL1)

// Executa funcao que Retornara Margem Media e Valor de Despesa do Orcamento
aMM := P_MargemMedia(gdFieldGet("UB_PRODUTO"), gdFieldGet("UB_LOCAL"), gdFieldGet("UB_QUANT"), M->UA_TIPOVND, gdFieldGet("UB_VLRITEM"), cLoja)

// Move margem media
nRet := aMM[1]

RestArea(aAreaIni)

Return(nRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ D19VldFil  ºAutor  ³ Paulo Benedet       º Data ³ 24/06/05    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validar alteracao da filial                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet - .T. - Alteracao permitida                              º±±
±±º          ³        .F. - Alteracao nao permitida                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Funcao utilizada na validacao do campo UA_LOJASL1             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function D19VldFil()
Local aArea	   := GetArea()
Local aAreaSL1 := SL1->(GetArea())
Local lRet 	   := .T.

If INCLUI // inclusao
	If !Empty(M->UA_LOJASL1)
		If !ExistCpo("SM0", "01" + M->UA_LOJASL1)
			lRet := .F.
		EndIf
	Else
		If SU0->U0_INTLOJ == "V" //varejo
			If !lTk271Auto
				MsgAlert(OemtoAnsi("Filial não pode ser igual a branco!"), "Aviso")
			EndIf
			lRet := .F.
		EndIf
	EndIf
Else // alteracao
	If !Empty(SUA->UA_LOJASL1) // foi gerado orcamento no sigaloja
		If Empty(M->UA_LOJASL1)
			If !lTk271Auto
				MsgAlert(OemtoAnsi("Filial não pode ser igual a branco!"), "Aviso")
			EndIf
			lRet := .F.
		Else
			If !ExistCpo("SM0", "01" + M->UA_LOJASL1)
				lRet := .F.
			Else
				// Verifica se orcamento foi alterado pela loja
				dbSelectArea("SL1")
				dbOrderNickName("SL1_FS1") //L1_FILIAL+L1_NUMSUA
				If dbSeek(SUA->UA_LOJASL1 + M->UA_NUM)
					If !Empty(SL1->L1_CONFVEN)
						If !lTk271Auto
							MsgAlert(OemtoAnsi("O orçamento já foi alterado pela loja!"), "Aviso")
						EndIf
						lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aAreaSL1)
RestArea(aArea)

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ D19VldOper      ºAutor ³ Paulo Benedet       ºData ³ 24/06/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validar alteracao do tipo de operacao                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet - .T. - Alteracao permitida                              º±±
±±º          ³        .F. - Alteracao nao permitida                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Funcao utilizada na validacao do campo UA_OPER.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function D19VldOper()
Local lRet := .T.

// Verifica grupo de atendimento
If SU0->U0_INTLOJ == "V" //varejo
	If M->UA_OPER == "1" // faturamento
		If !lTk271Auto
			MsgAlert(OemtoAnsi("Operação não permitida para varejo!"), "Aviso")
		EndIf
		lRet := .F.
	EndIf
	If !INCLUI //alteracao
		If SUA->UA_OPER <> "3" // atendimento
			lRet := .F.
		EndIf
	EndIf
ElseIf SU0->U0_INTLOJ == "A" //atacado
	If !INCLUI //alteracao
		If SUA->UA_OPER == "2" .And. !Empty(SUA->UA_LOJASL1) // orcamento esta no sigaloja
			lRet := .F.
		EndIf
	EndIf
EndIf

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ d19TmkTit     ºAutor ³Paulo Benedet         º Data ³ 21/09/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para verificar se pedido gera titulo                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Sempre .T.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Rotina chamada pelo tkGrPed na validacao do televendas        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via Pneus                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function d19TmkTit()
Local aArea    := GetArea()
Local aAreaSF4 := SF4->(GetArea())
Local npTes    := gdFieldPos("UB_TES") // Posicao do campo UB_TES
Local nTotLin  := Len(aCols) // Numero de linhas
Local nX // For next

lTesTit := .F.
dbSelectArea("SF4")
dbSetOrder(1) // F4_FILIAL+F4_CODIGO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica TES para determinar se gerara titulo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to nTotLin
	If aTail(aCols[nX])
		Loop
	EndIf
	
	If dbSeek(xFilial("SF4") + aCols[nX][npTes])
		If SF4->F4_DUPLIC == "S" // Gera duplicata
			lTesTit := .T.
			Exit
		EndIf
	EndIf
Next nX

RestArea(aAreaSF4)
RestArea(aArea)

Return(.T.)
