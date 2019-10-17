#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DVCA150   º Autor ³  Priscila Prado    º Data ³  26/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calculo de comissoes de varejo. 						      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - Uso Especifico - Della Via - Comissao                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DVCA150(dPerIni,dPerFim,cLojaIni,cLojaFim)
Local cQuery  		:= ""
Local cEnter  		:= Chr(13)
Local cLoja   		:= ""
Local aEstrut		:= {}
Local cArqTRBVEND   := ""

//recalcula o mm realizado para todas as lojas
MMLoja(dPerIni,dPerFim,cLojaIni,cLojaFim)

cQuery := "SELECT PBH_LOJA, COALESCE(SUM(PBH_VLPNEU),0) VLPNEU, COALESCE(SUM(PBH_VLACES),0) VLACES, COALESCE(SUM(PBH_VLPNCO),0) VLPNEUCON, "+cEnter
cQuery += "COALESCE(SUM(PBH_VLACES + PBH_VLPNCO),0) VLTOTAL, "+cEnter
cQuery += "COALESCE(SUM(PBH_VLSERV),0) VLSERVICO, COALESCE(SUM(PBH_QTPNP),0) QTDPNEU, COALESCE(SUM(PBH_QTAM),0) QTDAMORT, "+cEnter
cQuery += "COALESCE(SUM(PBH_QTSERV),0) QTSERV "+cEnter
cQuery += "FROM " + RetSqlName("PBH") + " PBH "+cEnter
cQuery += "WHERE PBH_FILIAL = '" + xFilial("PBH") + "' "+cEnter
cQuery += "AND PBH.PBH_LOJA BETWEEN '"+ cLojaIni + "' AND '"+cLojaFim+"' "+cEnter
cQuery += "AND PBH_TPVEND = 'V' "+cEnter
cQuery += "AND PBH_EMISSA BETWEEN '"+ DTOS(dPerIni) + "' AND '" + DTOS(dPerFim) + "' "+cEnter
cQuery += "AND PBH_FUNCAO = '3' "+cEnter
cQuery += "AND PBH.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "GROUP BY PBH_LOJA "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "TMPLOJAV", .T., .T. )

TCSetField( "TMPLOJAV", "VLPNEU"    , "N", 12, 2 )
TCSetField( "TMPLOJAV", "VLACES"    , "N", 12, 2 )
TCSetField( "TMPLOJAV", "VLPNEUCON" , "N", 12, 2 )
TCSetField( "TMPLOJAV", "VLTOTAL"   , "N", 12, 2 )
TCSetField( "TMPLOJAV", "VLSERVICO" , "N", 12, 2 )
TCSetField( "TMPLOJAV", "QTDPNEU"   , "N", 4, 0 )
TCSetField( "TMPLOJAV", "QTDAMORT"  , "N", 4, 0 )
TCSetField( "TMPLOJAV", "QTSERV"    , "N", 12, 2 )

cQuery := "SELECT PBH_LOJA, PBH_VEND, PBH_FUNCAO, SUM(PBH_VLPNEU) VLPNEU, SUM(PBH_VLACES) VLACES, SUM(PBH_VLPNCO) VLPNEUCON, "+cEnter
cQuery += "SUM(PBH_VLACES + PBH_VLPNCO) VLTOTAL, "+cEnter
cQuery += "SUM(PBH_VLSERV) VLSERVICO, SUM(PBH_QTPNP) QTDPNEU, SUM(PBH_QTAM) QTDAMORT, "+cEnter
cQuery += "SUM(PBH_QTSERV) QTSERV "+cEnter
cQuery += "FROM " + RetSqlName("PBH") + " PBH "+cEnter
cQuery += "WHERE PBH_FILIAL = '" + xFilial("PBH") + "' "+cEnter
cQuery += "AND PBH.PBH_LOJA BETWEEN '"+ cLojaIni + "' AND '"+cLojaFim+"' "+cEnter
cQuery += "AND PBH_TPVEND = 'V' "+cEnter
cQuery += "AND PBH_EMISSA BETWEEN '"+ DTOS(dPerIni) + "' AND '" + DTOS(dPerFim) + "' "+cEnter
cQuery += "AND PBH.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "GROUP BY PBH_LOJA, PBH_VEND, PBH_FUNCAO "
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "TMPVEND", .T., .T. )

TCSetField( "TMPVEND", "VLPNEU"    , "N", 12, 2 )
TCSetField( "TMPVEND", "VLACES"    , "N", 12, 2 )
TCSetField( "TMPVEND", "VLPNEUCON" , "N", 12, 2 )
TCSetField( "TMPVEND", "VLTOTAL"   , "N", 12, 2 )
TCSetField( "TMPVEND", "VLSERVICO" , "N", 12, 2 )
TCSetField( "TMPVEND", "QTDPNEU"   , "N", 4, 0 )
TCSetField( "TMPVEND", "QTDAMORT"  , "N", 4, 0 )
TCSetField( "TMPVEND", "QTSERV"    , "N", 12, 2 )

aAdd(aEstrut,{"PBH_LOJA"	, "C", 02, 00})
aAdd(aEstrut,{"PBH_VEND"	, "C", 06, 00})
aAdd(aEstrut,{"PBH_FUNCAO"	, "C", 01, 00})
aAdd(aEstrut,{"VLPNEU" 		, "N", 12, 02})
aAdd(aEstrut,{"VLACES" 		, "N", 12, 02})
aAdd(aEstrut,{"VLPNEUCON"  , "N", 12, 02})
aAdd(aEstrut,{"VLTOTAL"    , "N", 12, 02})
aAdd(aEstrut,{"VLSERVICO"  , "N", 12, 02})
aAdd(aEstrut,{"QTDPNEU"	   , "N", 12, 02})
aAdd(aEstrut,{"QTDAMORT"  , "N", 12, 02})
aAdd(aEstrut,{"QTSERV"    , "N", 12, 02})

cArqTRBVEND := CriaTrab(aEstrut)
dbUseArea(.T.,,cArqTRBVEND,"TRBVEND",.F.,.F.)
IndRegua("TRBVEND",  cArqTRBVEND, "PBH_LOJA+PBH_VEND+PBH_FUNCAO",,, "Criando Indice..." )

dbSelectArea("TMPVEND")
While  !EOF()
	
	dbSelectArea("TRBVEND")
	RecLock("TRBVEND",.T.)
	TRBVEND->PBH_LOJA 	:= TMPVEND->PBH_LOJA
	TRBVEND->PBH_VEND 	:= TMPVEND->PBH_VEND
	TRBVEND->PBH_FUNCAO	:= TMPVEND->PBH_FUNCAO
	TRBVEND->VLPNEU 	:= TMPVEND->VLPNEU
	TRBVEND->VLACES 	:= TMPVEND->VLACES
	TRBVEND->VLPNEUCON 	:= TMPVEND->VLPNEUCON
	TRBVEND->VLTOTAL 	:= TMPVEND->VLTOTAL
	TRBVEND->VLSERVICO 	:= TMPVEND->VLSERVICO
	TRBVEND->QTDPNEU 	:= TMPVEND->QTDPNEU
	TRBVEND->QTDAMORT 	:= TMPVEND->QTDAMORT
	TRBVEND->QTSERV    	:= TMPVEND->QTSERV
	msUnlock()
	dbSelectArea("TMPVEND")
	dbSkip()
End
dbCloseArea()




dbSelectArea("TMPLOJAV")
While !EOF()
	cLoja := TMPLOJAV->PBH_LOJA
	While !EOF() .And.  TMPLOJAV->PBH_LOJA == cLoja
		CalcLojaV(cLoja,dPerIni,dPerFim)
		dbSelectArea("TMPLOJAV")
		dbSkip()
	End
End
dbCloseArea()

dbSelectArea("TRBVEND")
dbCloseArea()
FErase(cArqTRBVEND+".DBF")

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CalcLojaV ºAutor  ³Microsiga           º Data ³  10/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula a comissao da loja de varejo.			              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - Especifico - Della Via - Comissao                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcLojaV(cLoja,dPerIni,dPerFim)
Local nPrProd := 0 // Indice de Premio da Meta de Produto
Local nPrServ := 0 // Indice de Premio da Meta de Servico
Local nPrSrPr := 0 // Indice de Premio da Meta de Servico Sobre Produto
Local nPrPnPs := 0 // Indice de Premio da Meta de Pneu Passeio
Local nPrSAut := 0 // Indice de Premio da Meta de Seguro Auto
Local nPrAmor := 0 // Indice de Premio da Meta de Amortecedores
Local nPrMM   := 0 // Indice de Premio da Meta da Margem Media
Local nPoProd := 0 // Indice de Potencial da Meta de Produto
Local nPoServ := 0 // Indice de Potencial da Meta de Servico
Local nPoSrPr := 0 // Indice de Potencial da Meta de Servico Sobre Produto
Local nPoPnPs := 0 // Indice de Potencial da Meta de Pneu Passeio
Local nPoSAut := 0 // Indice de Potencial da Meta de Seguro Auto
Local nPoAmor := 0 // Indice de Potencial da Meta de Amortecedores
Local nPoMM   := 0 // Indice de Potencial da Meta da Margem Media
Local lAchou  := .F.

DbSelectArea("PBA")
DbSetOrder(2)  //PBA_LOJA + PBA_DTINI
If dbSeek(xFilial("PBA")+ cLoja)
	
	While !EOF() .And. PBA_LOJA == cLoja
		If dPerIni >= PBA_DTINI .And. dPerFim <= PBA_DTFIM
			lAchou := .T.
			Exit
		EndIf
		dbSkip()
	EndDo
	
	If !lAchou
		Return .F.	
	EndIf
	
	
	DbSelectArea("PB3")
	DbSetOrder(1) // PB3_FUNCAO + PB3_INDINI
	If dbSeek(xFilial("PB3")+ "3" )//+ STR(PBA->PBA_APPROD))
		While !Eof() .And. PB3_FILIAL = xFilial("PB3") .And. PB3_FUNCAO == "3"
			//Premio de meta de produto
			If PBA->PBA_APPROD >= PB3->PB3_INDINI .And. PBA->PBA_APPROD <= PB3->PB3_INDFIM
				If PB3->PB3_TIPO == "F"
					nPrProd := PB3->PB3_INDPRE
				Else
					nPrProd := PBA->PBA_APPROD
				Endif
			Endif
			//Premio de meta de servico
			If PBA->PBA_APSERV >= PB3->PB3_INDINI .And. PBA->PBA_APSERV <= PB3->PB3_INDFIM
				If PB3->PB3_TIPO == "F"
					nPrServ := PB3->PB3_INDPRE
				Else
					nPrServ := PBA->PBA_APSERV
				Endif
			Endif
			//Premio de meta de servico sobre produto
			If PBA->PBA_APSSP >= PB3->PB3_INDINI .And. PBA->PBA_APSSP <= PB3->PB3_INDFIM
				If PB3->PB3_TIPO == "F"
					nPrSrPr := PB3->PB3_INDPRE
				Else
					nPrSrPr := PBA->PBA_APSSP
				Endif
			Endif
			//Premio de meta de pneu passeio
			If PBA->PBA_APPNP >= PB3->PB3_INDINI .And. PBA->PBA_APPNP <= PB3->PB3_INDFIM
				If PB3->PB3_TIPO == "F"
					nPrPnPs := PB3->PB3_INDPRE
				Else
					nPrPnPs := PBA->PBA_APPNP
				Endif
			Endif
			//Premio de meta de seguro auto
			If PBA->PBA_APSG >= PB3->PB3_INDINI .And. PBA->PBA_APSG <= PB3->PB3_INDFIM
				If PB3->PB3_TIPO == "F"
					nPrSAut := PB3->PB3_INDPRE
				Else
					nPrSAut := PBA->PBA_APSG
				Endif
			Endif
			//Premio de meta de amortecedores
			If PBA->PBA_APAM >= PB3->PB3_INDINI .And. PBA->PBA_APAM <= PB3->PB3_INDFIM
				If PB3->PB3_TIPO == "F"
					nPrAmor := PB3->PB3_INDPRE
				Else
					nPrAmor := PBA->PBA_APAM
				Endif
			Endif
			//Premio de meta da margem media
			If PBA->PBA_APMM >= PB3->PB3_INDINI .And. PBA->PBA_APMM <= PB3->PB3_INDFIM
				If PB3->PB3_TIPO == "F"
					nPrMM := PB3->PB3_INDPRE
				Else
					nPrMM := PBA->PBA_APMM
				Endif
			Endif
			
			DbSkip()
		Enddo
	Endif
	
	// Indice de Potencial da Loja
	DbSelectArea("PB1")
	DbSetOrder(1) // PB1_POTENC
	If dbSeek(xFilial("PB1")+ PBA->PBA_POTENC)
		nPoProd := PB1->PB1_INDPRO
		nPoServ := PB1->PB1_INDSER
		nPoSrPr := PB1->PB1_INDSSP
		nPoPnPs := PB1->PB1_INDPNP
		nPoSAut := PB1->PB1_INDSG
		nPoMM   := PB1->PB1_INDMM
		nPoAmor := PB1->PB1_INDAM
	Endif
	
	dbSelectArea("PBA")
	Reclock("PBA",.F.)
    
	//ZERA VALORES
	PBA->PBA_RLPNEU :=  0
	PBA->PBA_RLACES :=  0
	PBA->PBA_RLPNCO :=  0
	PBA->PBA_RLPROD :=  0
	PBA->PBA_RLSERV :=  0
	PBA->PBA_RLSSP  :=  0
	PBA->PBA_RLPNP  :=  0
	PBA->PBA_RLAM   :=  0
	PBA->PBA_MTPROD :=  0
	PBA->PBA_MTSERV :=  0
	PBA->PBA_MTSERL :=  0
	PBA->PBA_MTSSP  :=  0
	PBA->PBA_APPROD :=  0
	PBA->PBA_APSERV :=  0
	PBA->PBA_APSSP  :=  0
	PBA->PBA_APPNP  :=  0
	PBA->PBA_APSG   :=  0
	PBA->PBA_APAM   :=  0
	PBA->PBA_APMM   :=  0
	PBA->PBA_APPNEU  := 0
	PBA->PBA_APACES  := 0
	PBA->PBA_PRPROD := 0
	PBA->PBA_PRSERV := 0
	PBA->PBA_PRSSP  := 0
	PBA->PBA_PRPNP  := 0
	PBA->PBA_PRSG   := 0
	PBA->PBA_PRAM   := 0
	PBA->PBA_PRMM   := 0
	PBA->PBA_POPROD := 0
	PBA->PBA_POSERV := 0
	PBA->PBA_POSSP  := 0
	PBA->PBA_POPNP  := 0
	PBA->PBA_POSG   := 0
	PBA->PBA_POAM   := 0
	PBA->PBA_POMM   := 0
	PBA->PBA_COPROD := 0
	PBA->PBA_COSERV := 0
	PBA->PBA_COSSP  := 0
	PBA->PBA_COPNP  := 0
	PBA->PBA_COSG   := 0
	PBA->PBA_COAM   := 0
	PBA->PBA_COMM   := 0
	PBA->PBA_VLBASE := 0
	PBA->PBA_INPROD := 0
	PBA->PBA_INSERV := 0
	PBA->PBA_INSSP  := 0
	PBA->PBA_INPNP  := 0
	PBA->PBA_INSG   := 0
	PBA->PBA_INMM   := 0
	PBA->PBA_BASEVV := 0
	PBA->PBA_INDVV  := 0
	PBA->PBA_INDVV  := 0
	PBA->PBA_VLVV   := 0
	PBA->PBA_VLCOML := 0
	//FIM       9604-3397
	
	PBA->PBA_RLPNEU :=  TMPLOJAV->VLPNEU                          // Valor Realizado de Pneus
	PBA->PBA_RLACES :=  TMPLOJAV->VLACES                          // Valor Realizado de Acessorios
	PBA->PBA_RLPNCO :=  TMPLOJAV->VLPNEUCON                       // Valor Realizado de Pneu Congelado
	PBA->PBA_RLPROD :=  TMPLOJAV->VLACES+TMPLOJAV->VLPNEU         //TMPLOJAV->VLTOTAL  // Valor Realidado de Produto
	PBA->PBA_RLSERV :=  TMPLOJAV->VLSERVICO                       // Valor Realizado de Servico
	PBA->PBA_RLSSP  :=  (TMPLOJAV->VLSERVICO / TMPLOJAV->VLTOTAL) // Indice Realizado de Servico / Produto
	PBA->PBA_RLPNP  :=  TMPLOJAV->QTDPNEU                         // Quantidade Realizada de Pneu Passeio
	PBA->PBA_RLAM   :=  TMPLOJAV->QTDAMORT                        // Quantidade Realizada de Amortecedor
	PBA->PBA_MTPROD := (PBA->PBA_MTPNEU + PBA->PBA_MTACES)        // Valor da Meta de Produto
	PBA->PBA_MTSERV := (PBA->PBA_MTSERM + PBA->PBA_MTSERA)        // Valor da Meta de Servico para Vendedor
	PBA->PBA_MTSERL := (PBA->PBA_MTSERM + PBA->PBA_MTSERA)        // Valor da Meta de Servico para Loja
	PBA->PBA_MTSSP  := (PBA->PBA_MTSERV / PBA->PBA_MTPROD)        // Indice de Servico Sobre Produto
	PBA->PBA_APPROD := (PBA->PBA_RLPROD	 / PBA->PBA_MTPROD)       //(TMPLOJAV->VLTOTAL	 / PBA->PBA_MTPROD) //Indice de Aproveitamento de Produtos
	PBA->PBA_APSERV := (PBA->PBA_RLSERV /PBA->PBA_MTSERL)	      // Indice de Aproveitamento de Servico
	PBA->PBA_APSSP  := (PBA->PBA_RLSSP / PBA->PBA_MTSSP)          //Indice de Aproveitamento de Servico Sobre Produto
	PBA->PBA_APPNP  := (PBA->PBA_RLPNP / PBA->PBA_MTPNP) // Indice de Aproveitamento da Meta de Pneu Passeio
	PBA->PBA_APSG   := (PBA->PBA_RLSG / PBA->PBA_MTSG) // Indice de Aproveitamento de Seguro de Automovel
	PBA->PBA_APAM   := (PBA->PBA_RLAM / PBA->PBA_MTAM) // Indice de Aproveitamento de Amortecedores
	PBA->PBA_APMM   := (PBA->PBA_RLMM / PBA->PBA_MTMM) // Indice de Aproveitamento da Margem Media
	PBA->PBA_APPNEU  := (PBA->PBA_RLPNEU / PBA->PBA_MTPNEU) // Indice de Aproveitamento de pneu
	PBA->PBA_APACES  := (PBA->PBA_RLACES / PBA->PBA_MTACES) // Indice de Aproveitamento de acessorios
	PBA->PBA_PRPROD := nPrProd // Indice de Premio da Meta de Produto
	PBA->PBA_PRSERV := nPrServ  // Indice de Premio da Meta de Servico
	PBA->PBA_PRSSP  := nPrSrPr  // Indice de Premio da Meta de Servico Sobre Produto
	PBA->PBA_PRPNP  := nPrPnPs  // Indice de Premio da Meta de Pneu Passeio
	PBA->PBA_PRSG   := nPrSAut  // Indice de Premio da Meta de Seguro Auto
	PBA->PBA_PRAM   := nPrAmor  // Indice de Premio da Meta de Amortecedores
	PBA->PBA_PRMM   := nPrMM    // Indice de Premio da Meta da Margem Media
	PBA->PBA_POPROD := nPoProd // Indice de Potencial da Meta de Produto
	PBA->PBA_POSERV := nPoServ // Indice de Potencial da Meta de Servico
	PBA->PBA_POSSP  := nPoSrPr // Indice de Potencial da Meta de Servico Sobre Produto
	PBA->PBA_POPNP  := nPoPnPs // Indice de Potencial da Meta de Pneu Passeio
	PBA->PBA_POSG   := nPoSAut // Indice de Potencial da Meta de Seguro Auto
	PBA->PBA_POAM   := nPoAmor // Indice de Potencial da Meta de Amortcedor
	PBA->PBA_POMM   := nPoMM   // Indice de Potencial da Meta da Margem Media
	PBA->PBA_COPROD := (PBA->PBA_PRPROD * PBA->PBA_POPROD) // Indice de Comissao de Produto
	PBA->PBA_COSERV := (PBA->PBA_PRSERV * PBA->PBA_POSERV) // Indice de Comissao de Servico
	PBA->PBA_COSSP  := (PBA->PBA_PRSSP * PBA->PBA_POSSP)  // Indice de Comissao de Servico Sobre Produto
	PBA->PBA_COPNP  := (PBA->PBA_PRPNP * PBA->PBA_POPNP)  // Indice de Comissao de Pneu Passeio
	PBA->PBA_COSG   := (PBA->PBA_PRSG * PBA->PBA_POSG)   // Indice de Comissao de Seguro Auto
	PBA->PBA_COAM   := (PBA->PBA_PRAM * PBA->PBA_POAM)	 // Indice de Comissao de Amortecedor
	PBA->PBA_COMM   := (PBA->PBA_PRMM * PBA->PBA_POMM) // Indice de Comissao de Margem Media
	
	PBA->PBA_VLBASE := (PBA->PBA_RLSERV + PBA->PBA_RLPNCO + PBA->PBA_RLACES) // Valor da Base de Calculo TMPLOJAV->VLTOTAL
	PBA->PBA_INPROD := ((PBA->PBA_RLPNCO + PBA->PBA_RLACES) * PBA->PBA_COPROD) // valor de Incentivo de Produtos
	PBA->PBA_INSERV := (PBA->PBA_RLSERV * PBA->PBA_COSERV) // valor de Incentivo de Servicos
	PBA->PBA_INSSP  := (PBA->PBA_VLBASE * PBA->PBA_COSSP)  // valor de Incentivo de Servicos Sobre Produtos
	PBA->PBA_INPNP  := (PBA->PBA_VLBASE * PBA->PBA_COPNP)  // valor de Incentivo de Pneu Passeio
	PBA->PBA_INSG   := (PBA->PBA_VLBASE * PBA->PBA_COSG)  // valor de Incentivo de Seguro Automovel
	PBA->PBA_INMM   := (PBA->PBA_VLBASE * PBA->PBA_COMM)  // valor de Incentivo de Margem Media
	PBA->PBA_BASEVV := (PBA->PBA_INPROD + PBA->PBA_INSERV + PBA->PBA_INSSP + PBA->PBA_INPNP + PBA->PBA_INSG + PBA->PBA_INMM) // Valor da Base de Calculo Variavel
	
	If PBA->PBA_APMM < 1       // Indice de Comissao Variavel
		PBA->PBA_INDVV  := (PBA->PBA_APMM - 1)
	ElseIf PBA->PBA_APMM == 1
		PBA->PBA_INDVV  := 0
	Else
		PBA->PBA_INDVV  := (PBA->PBA_APMM - 1) / 2
	Endif
	
	PBA->PBA_VLVV   := (PBA->PBA_BASEVV * PBA->PBA_INDVV)  // Valor Variavel

	PBA->PBA_VLCOML := (PBA->PBA_BASEVV + PBA->PBA_VLVV)   // Valor da Comissao
	
	//zera em caso de negativo
	If 	PBA->PBA_VLCOML < 0
		PBA->PBA_VLCOML := 0 
	EndIf
	
	MsUnlock()
	
	CalcGerent(PBA->PBA_CODIGO,PBA->PBA_VLCOML,PBA->PBA_QTDIAS)
	CalcVend(PBA->PBA_CODIGO,PBA->PBA_MTPNEU,PBA->PBA_MTACES,PBA->PBA_MTSERM,PBA->PBA_MTSERA,PBA->PBA_MTSERV,PBA->PBA_QTDIAS,PBA->PBA_LOJA,PBA->PBA_DTINI,PBA->PBA_DTFIM,PBA->PBA_INDVV,PBA->PBA_QMSERA)
	
	
	
Endif


Return( Nil )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcGerentºAutor  ³Priscila Prado      º Data ³  10/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo da comissao do gerente de varejo com base na base   º±±
±±º          ³de calculo de comissoes gerada.                       	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ ExpC1: Codigo da Meta                                      ³±±
±±³          ³ ExpN1: Valor da base de calculo                            ³±±
±±³          ³ ExpN2: Quantidades de dias trabalhados da loja             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ Della Via (Comissoes)                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcGerent(cCodigo,nVlBase,nDiasLj)
Local nGerente := 0 //Quantidade de gerentes na loja para a meta

DbSelectArea("PBB")
DbSetOrder(2)  //PBB_CODIGO + PBB_QTDIAS + PBB_VEND
If dbSeek(xFilial("PBB")+ cCodigo)
	While !Eof() .And. PBB_FILIAL = xFilial("PBB") .And. PBB_CODIGO == cCodigo
		nGerente++
		DbSkip()
	Enddo
	
	dbSeek(xFilial("PBB")+ cCodigo)
	
	While !Eof() .And. PBB_FILIAL = xFilial("PBB") .And. PBB_CODIGO == cCodigo
		nVlRateio := (nVlBase / nGerente)
		nVlComis  := Iif(nGerente ==1 ,nVlRateio,(nVlRateio * ( PBB->PBB_QTDIAS / nDiasLj) ))
		nVlBase   := (nVlBase - nVlComis)
		nGerente--
		
		Reclock("PBB",.F.)            
		PBB->PBB_VLCOML := nVlComis

		If PBB_VLCOML < 0
			PBB->PBB_VLCOML :=0
		EndIf	
		MsUnlock()
		
		DbSkip()
	Enddo
	
Endif
Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcVend  ºAutor  ³Priscila Prado      º Data ³  11/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo da comissao do vendedor, montador e alinhador de    º±±
±±º          ³varejo com base na base base de calculo de comissoes. 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ ExpC1: Codigo da Loja                                      ³±±
±±³          ³ ExpC2: Codigo da Funcao do Vendedor                        ³±±
±±³          ³ ExpN1: Valor da Meta Pneu                                  ³±±
±±³          ³ ExpN2: Valor da Meta Acessorios                            ³±±
±±³          ³ ExpC2: Codigo da Funcao do Vendedor                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ Della Via (Comissoes)                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CalcVend(cCodigo,nMtPneu,nMtAces,nMtSerM,nMtSerA,nMtSerV,nDiasLj,cLoja,dDtIni,dDtFim,nIndCoLj,nMtQtServA)
Local nVendedor := 0 //Quantidade de vendedores na loja para a meta
Local cFuncao   := "" //Codigo da funcao do vendedor
Local nVlMtPnV  := 0 // Valor da meta de Pneu do vendedor
Local nVlMtAcV  := 0 // Valor da meta de Acessorios do vendedor
Local nCont     := 0
Local nAux      := 0
Local nMtPneu2  := 0
Local nMtAces2  := 0
Local nMtSer2   := 0
Local nMtSer    := 0
Local aVlVend   := {}
Local nPrProd   := 0
Local nIndFun   := 0
Local nPrServ   := 0

Local nA_QtServ  := 0 //Quantidade de servico alinhador
Local nRatQtSerA := 0
Local nValRatAli := 0
Local nMQSer2    := 0

DbSelectArea("PBC")
DbSetOrder(3)  //PBC_CODIGO + PBC_FUNCAO + PBC_QTDIAS + PBC_VEND
If dbSeek(xFilial("PBC")+ cCodigo)
	While !Eof() .And. PBC_FILIAL = xFilial("PBC") .And. PBC_CODIGO == cCodigo
		cFuncao := PBC->PBC_FUNCAO
		While !Eof() .And. PBC_FILIAL = xFilial("PBC") .And. PBC_CODIGO == cCodigo .And. PBC_FUNCAO == cFuncao
			nVendedor++
			DbSkip()
		Enddo
		
		dbSeek(xFilial("PBC")+ cCodigo+cFuncao)
		nAux     := nVendedor
		nMtPneu2 := nMtPneu
		nMtAces2 := nMtAces
		nA_QtServ := 0
      nRatQtSerA := 0		
      nValRatAli := 0
		If cFuncao == '1'
			nMtSer  := nMtSerA
			nA_QtServ := nMtQtServA			
		ElseIf cFuncao == '2'
			nMtSer  := nMtSerM
		Else
			nMtSer  := nMtSerV
		Endif
		nMtSer2  := nMtSer
		nMQSer2  := nA_QtServ
		For nCont:=1 to nAux
			// Calculo do valor da meta de pneu
			nVlRateio := (nMtPneu2 / nVendedor)
			nVlMtPnV  := Iif(nVendedor ==1 ,nVlRateio,(nVlRateio * ( PBC->PBC_QTDIAS / nDiasLj) ))
			nMtPneu2   := (nMtPneu2 - nVlMtPnV)
			// Calculo do valor da meta de acessorios
			nVlRatAce := (nMtAces2 / nVendedor)
			nVlMtAcV  := Iif(nVendedor ==1 ,nVlRatAce,(nVlRatAce * ( PBC->PBC_QTDIAS / nDiasLj) ))
			nMtAces2   := (nMtAces2 - nVlMtAcV)
			// Calculo do valor da meta de servicos
			nVlRatSer := (nMtSer2 / nVendedor)
			nVlMtSer  := Iif(nVendedor ==1 ,nVlRatSer,(nVlRatSer * ( PBC->PBC_QTDIAS / nDiasLj) ))
			nMtSer2   := (nMtSer2 - nVlMtSer)			
			//Calculo da quantidade da meta do alinhador
			nValRatAli := (nMQSer2 / nVendedor)
			nRatQtSerA := Iif(nVendedor ==1 ,nValRatAli,(nValRatAli * ( PBC->PBC_QTDIAS / nDiasLj) ))
			nMQSer2    := (nMQSer2 - nRatQtSerA)
			
			nVendedor--
			
			aVlVend := {}
			dbSelectArea("TRBVEND")
			dbSetOrder(1)
			If dbSeek(cLoja+PBC->PBC_VEND+PBC->PBC_FUNCAO)
				aAdd( aVlVend, { TRBVEND->VLPNEU, TRBVEND->VLACES, TRBVEND->VLPNEUCON, TRBVEND->VLTOTAL,TRBVEND->VLSERVICO, TRBVEND->QTDPNEU, TRBVEND->QTDAMORT, TRBVEND->QTSERV } )
			Else
				aAdd( aVlVend, { 0, 0, 0,  0, 0, 0, 0, 0 } )
			EndIf
			
			// Indice da Funcao
			DbSelectArea("PB2")
			DbSetOrder(1) // PB2_FUNCAO
			If dbSeek(xFilial("PB1")+ cFuncao)
				nIndFun := PB2->PB2_INDICE
			Endif
			
			Reclock("PBC",.F.)
			
			//ZERA
			PBC->PBC_MTPNEU := 0
			PBC->PBC_MTACES := 0
			PBC->PBC_MTPROD := 0
			PBC->PBC_MTSERV := 0
			PBC->PBC_RLPNEU := 0
			PBC->PBC_APPNEU := 0
			PBC->PBC_RLACES := 0
			PBC->PBC_APACES := 0
			PBC->PBC_RLPROD := 0
			PBC->PBC_APPROD := 0
			PBC->PBC_RLPNCO := 0
			PBC->PBC_BASEPR := 0
			PBC->PBC_RLSERV := 0
			PBC->PBC_APSERV := 0
			PBC->PBC_BASESE := 0
			PBC->PBC_QRSERA := 0			
			//FIM
			
			PBC->PBC_MTPNEU := nVlMtPnV                             // Valor da Meta de Pneu
			PBC->PBC_MTACES := nVlMtAcV                             // Valor da Meta de Acessorios
			PBC->PBC_MTPROD := (PBC->PBC_MTPNEU + PBC->PBC_MTACES)  // Valor da Meta de Produto
			PBC->PBC_MTSERV := nVlMtSer                             // Valor da Meta de Servico
			PBC->PBC_RLPNEU := aVlVend[1,1]                         // Valor Realizado de Pneus
			PBC->PBC_APPNEU := PBC->PBC_RLPNEU / PBC->PBC_MTPNEU    // Indice de aproveitamento de pneu
			PBC->PBC_RLACES := aVlVend[1,2]                         // Valor Realizado de Acessorios
			PBC->PBC_APACES := PBC->PBC_RLACES / PBC->PBC_MTACES    // Indice de aproveitamento de acessorio
			PBC->PBC_RLPROD := (PBC->PBC_RLACES + PBC->PBC_RLPNEU)  // Valor Realizado de Produto
			PBC->PBC_APPROD := (PBC->PBC_RLPROD / PBC->PBC_MTPROD)  // Indice de Aproveitamento de Produto
			PBC->PBC_RLPNCO := aVlVend[1,3]                         // Valor Realizado de Pneu Congelado
			PBC->PBC_BASEPR := (aVlVend[1,2] + aVlVend[1,3]) // Valor da Base de Calculo do Produto
			PBC->PBC_RLSERV := aVlVend[1,5] // Valor Realizado de Servico
			PBC->PBC_APSERV := (PBC->PBC_RLSERV / PBC->PBC_MTSERV) // Indice de Aproveitamento de Servico
			PBC->PBC_BASESE := aVlVend[1,5] // Valor da Base de Calculo
			PBC->PBC_QMSERA := nRatQtSerA //Quantidade da meta de serviço do alinhador			
			PBC->PBC_QRSERA  := aVlVend[1,8] // Valor da Base de Calculo
			MsUnlock()
			
			// Indice de Premio para produto
			DbSelectArea("PB3")
			DbSetOrder(1) // PB3_FUNCAO + PB3_INDINI
			If dbSeek(xFilial("PB3")+ cFuncao )
				While !Eof() .And. PB3_FILIAL = xFilial("PB3") .And. PB3_FUNCAO == cFuncao
					If PBC->PBC_APPROD >= PB3->PB3_INDINI .And. PBC->PBC_APPROD <= PB3->PB3_INDFIM
						If PB3->PB3_TIPO == "F"
							nPrProd := PB3->PB3_INDPRE
						Else
							nPrProd := PBC->PBC_APPROD
						Endif
					Endif
					
					If PBC->PBC_APSERV >= PB3->PB3_INDINI .And. PBC->PBC_APSERV <= PB3->PB3_INDFIM
						If PB3->PB3_TIPO == "F"
							nPrServ := PB3->PB3_INDPRE
						Else
							nPrServ := PBC->PBC_APSERV
						Endif
					Endif
					
					DbSkip()
				Enddo
			Endif
			
			
			//se o vendedor teve uma falta nao justificada o maximo de premio dele eh de 1.
			If PBC->PBC_FUNCAO == "3" .And. PBC->PBC_FALTA == "S"  //Vendedor
				If nPrProd > 1
					nPrProd := 1
				EndIf
				
				If nPrServ > 1
					nPrServ := 1
				EndIf
				
			EndIf
			
			DbSelectArea("PBC")
			Reclock("PBC",.F.)
			
			//zera
			PBC->PBC_PRPROD := 0
			PBC->PBC_COPROD := 0
			PBC->PBC_VLCOPR := 0
			PBC->PBC_PRSERV := 0
			PBC->PBC_COSERV := 0
			PBC->PBC_VLCOSE := 0
			PBC->PBC_BASEVV := 0
			PBC->PBC_VLVV   := 0
		
			
			
			PBC->PBC_PRPROD := nPrProd // Indice de Premio para Produto
			PBC->PBC_COPROD := (PBC->PBC_PRPROD * nIndFun) // Indice de Comissao de Produtos
			PBC->PBC_VLCOPR := (PBC->PBC_BASEPR * PBC->PBC_COPROD) // Valor de Comissao para Produto
			PBC->PBC_PRSERV := nPrServ // Indice de Premio para a Meta de Servico
			PBC->PBC_COSERV := (PBC->PBC_PRSERV * nIndFun) // Indice de Comissao de Servicos
			PBC->PBC_VLCOSE := PBC->PBC_COSERV * aVlVend[1,5]  // Valor de Comissao de Servico
			PBC->PBC_BASEVV := (PBC->PBC_VLCOPR + PBC->PBC_VLCOSE) // Valor da Base de Calculo Variavel
			PBC->PBC_VLVV   := (nIndCoLj * PBC->PBC_BASEVV) // Valor de Comissao Variavel
			
			PBC->PBC_VLCOML := (PBC->PBC_BASEVV + PBC->PBC_VLVV) // Valor da Comissao
			
			//zera em caso de negativo
			If PBC->PBC_VLCOML < 0
				PBC->PBC_VLCOML := 0
			EndIf
			
			MsUnlock()
			
			DbSkip()
		Next
		nVlRateio := 0
		nVlMtPnV  := 0
		nVlMtSer  := 0
		
	Enddo
	
Endif
Return( Nil )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MMLoja    ºAutor  ³Microsiga           º Data ³  12/19/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula o MM da Loja                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MMLoja(dPerIni,dPerFim,cLojaIni,cLojaFim)
Local aArea  := GetArea()
Local cQuery := ""
Local cEnter := Chr(13)

cQuery := "UPDATE "+RetSQLName("PBA")+" "+cEnter
cQuery += "SET PBA_RLMM =  ( "+cEnter
cQuery += "SELECT "+cEnter
cQuery += "ROUND(SUM(PBH_CM1) / SUM(PBH_VLTOT),4)     "+cEnter
cQuery += "FROM "+RetSQLName("PBH")+" PBH,  "+RetSQLName("SA3")+" SA3 "+cEnter
cQuery += "WHERE PBH_FILIAL  = '"+xFilial("PBH")+"' AND PBH.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND PBH_EMISSA BETWEEN '"+DToS(dPerIni)+"' AND '"+DToS(dPerFim)+"' "+cEnter                                                                                       
cQuery += "AND PBH_LOJA BETWEEN '  ' AND 'ZZ' "+cEnter
cQuery += "AND PBH_TPVEND = 'V' "+cEnter
cQuery += "AND PBH_FUNCAO = '3' "+cEnter
cQuery += "AND A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "AND A3_COD = PBH_VEND "+cEnter
cQuery += "AND A3_FILORIG = PBA_LOJA) "+cEnter                                         
cQuery += "WHERE PBA_FILIAL = '"+xFilial("PBA")+" ' AND D_E_L_E_T_ = '  ' "+cEnter
cQuery += "AND PBA_LOJA BETWEEN '"+cLojaIni+"' AND '"+cLojaFim+"'  "+cEnter
cQuery += "AND PBA_DTINI >= '"+DToS(dPerIni)+"' AND PBA_DTFIM <= '"+DToS(dPerFim)+"' "+cEnter

TCSqlExec(cQuery)


RestArea(aArea)

Return .T.