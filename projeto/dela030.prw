#INCLUDE "protheus.ch"       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelA030   ºAutor  ³Norbert Waage Junior   º Data ³  24/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de calculo dos valores do item, respeitando a tabela de º±±
±±º          ³precos e aplicando o acrescimo da condicao de pagamento        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³nLinha  - Linha do aCols processada                            º±±
±±º          ³cCondPg - Condicao de pagamento a ser utilizada                º±±
±±º          ³lCalcArc- Logico, define se sera calculado acrescimo ou nao    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³nPreco  - Preco unitario                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina chamada pelos campos da linha do aCols do TeleVendas-TMKº±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DelA030(nLinha,cCondPg,lCalcAcr)

Local aArea		:=	GetArea()
Local nPerAcr
Local nMoeda	:= 1
Local nPosVrUnit:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VRUNIT" })
Local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
Local nPosQuant	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT"  })
Local nPosVlItem:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VLRITEM"})
Local nPosDesc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_DESC"   })
Local nPosVlDesc:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})
Local nPosAcre	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_ACRE"   })
Local nPosVlAcre:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALACRE"})
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_TES"    })
Local nPrcTab	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRCTAB" })
Local nPreco 	:= 0
Local nPrTab	:= 0
Local nNatu		:= N
Local nDesconto	:= 0
Local nAcresc	:= 0
Local dDataLim	:= IIf(Empty(M->UA_DTLIM),dDataBase,M->UA_DTLIM)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valores padrao quando nao informadas as variaveis³
//³dos parametros da funcao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Default nLinha	:= N
Default cCondPg	:= M->UA_CONDPG
Default lCalcAcr:= .T.

N := nLinha 							//Altera N
nPreco := aCols[nLinha][nPosVrUnit]		//Utiliza preco ja preenchido

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente quando a tabela de preco e a condicao de pagamento³
//³estiverem preechidas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty (M->UA_TABELA) .And. !Empty(M->UA_CONDPG) .And. lCalcAcr
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preco de tabela³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPrTab	:=	MaTabPrVen(M->UA_TABELA,aCols[nLinha][nPosProd],aCols[nLinha][nPosQuant],;
				M->UA_CLIENTE,M->UA_LOJA,nMoeda,dDataLim)
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se houver preco  de tabela cadastrado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nPrTab != 0
		
		nPreco := nPrTab

		If !Empty(cCondPg)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula acrecimo para produtos de grupos que nao estao no parametro FS_DEL036³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !((AllTrim(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nLinha][nPosProd],1,"")) $ AllTrim(GetMV("FS_DEL036"))))
				nPerAcr	:=	GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+cCondPg,1,0)
				nPreco	+=	nPreco * (nPerAcr/100)
			EndIf	
			
			nPrTab := nPreco

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula descontos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aCols[nLinha][nPosVlDesc] != 0

				If AllTrim(ReadVar()) == "M->UB_DESC" .Or. P_NaPilha("P_DELA030G")
					nDesconto := aCols[nLinha][nPosDesc]
					aCols[nLinha][nPosVlDesc] := NoRound((nPreco * aCols[nLinha,nPosQuant] * (nDesconto/100)),TamSX3("UB_VALDESC")[2])
				Else
					nDesconto := (aCols[nLinha][nPosVlDesc] / (nPreco * aCols[nLinha,nPosQuant])) * 100
					aCols[nLinha][nPosDesc]	:= Round(nDesconto,TamSx3("UB_DESC")[2])
				EndIf
			
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula acrescimo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aCols[nLinha][nPosVlAcre] != 0
			
				If AllTrim(ReadVar()) == "M->UB_ACRE"
					nAcresc	:= aCols[nLinha][nPosAcre]
					aCols[nLinha][nPosVlAcre] := Round((nPreco * aCols[nLinha,nPosQuant] * (nAcresc/100)),TamSx3("UB_VALACRE")[2])
				Else
					nAcresc := (aCols[nLinha][nPosVlAcre] / (nPreco * aCols[nLinha,nPosQuant])) * 100
					aCols[nLinha][nPosAcre]	:= Round(nAcresc, TamSx3("UB_ACRE")[2])
				Endif
			
			EndIf
			
			nPreco := A410Arred(nPreco,"UB_VRUNIT")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Aplica acrescimo ou desconto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(ReadVar()) $ "M->UB_VALACRE/M->UB_ACRE"
				nPreco := nPreco  - (nPreco * (aCols[nLinha][nPosDesc]/100)) +;
						 (nPreco * (nAcresc/100))
			Else				
				nPreco := nPreco + (nPreco * (aCols[nLinha][nPosAcre])/100) -;
						 (nPreco * (nDesconto)/100)
	   		EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza aCols com o valor do item e total do item³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPreco := A410Arred(nPreco,"UB_VRUNIT")
			
			aCols[nLinha][nPosVrUnit] := nPreco
			aCols[nLinha][nPrcTab]	  := A410Arred(nPrTab,"UB_VRUNIT")
			aCols[nLinha][nPosVlItem] := aCols[nLinha][nPosQuant] * nPreco
				
		EndIf
		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa as funcoes fiscais para atualizar os valores totais³
	//³referentes a venda e impostos                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisRef("IT_VALMERC", "TK273", aCols[nLinha][nPosVlItem])
	MaFisRef("IT_TES", "TK273", aCols[nLinha][nPosTes])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza totais da tela e mensagem do rodape³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Tk273Trigger()
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao chamar telas se a rotina for chamada por execauto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lTk271Auto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza Rodape³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	P_TmRodape()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetTlv:oBrowse:Refresh()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
N := nNatu
RestArea(aArea)

Return NoRound(nPreco,TamSx3("D2_PRCVEN")[2])

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TmRodape  ºAutor  ³Norbert Waage Junior   º Data ³  27/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para atualizacao da mensagem do rodape informativo dos  º±±
±±º          ³totais da venda.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³uRet - Conteudo do campo que acionou esta funcao/gatilho       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina chamada para atualizar o rodape, como gatilho ou codigo º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function TmRodape()
Local aArea		:= GetArea()
Local aParc		:= Condicao(aValores[6],M->UA_CONDPG)// aValores[6] Eh o total da venda, definido no TMKDEF.CH
Local cDescCP	:= Space(10) + M->UA_CONDPG + " - " + AllTrim(GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+M->UA_CONDPG,1,""))

If !lTk271Auto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se a condicao eh valida³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aParc) > 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta e exibe o rodape³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString   := Space(10) + "TOTAL DA VENDA: " + AllTrim(Str(Len(aParc))) + " X " + Alltrim(Transform(aParc[1][2],"@E 9,999,999.99"))
		cContHist := AllTrim(TkDadosContato(SU5->U5_CODCONT,0)) + cDescCP + cString
		oContHist:Refresh()
	EndIf
EndIf

RestArea(aArea)

Return M->&(ReadVar()) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelA030G  ºAutor  ³Norbert Waage Junior   º Data ³  27/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Gatilho para executar a rotina de calculo dos itens para todas º±±
±±º          ³as linhas do aCols                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³uRet - Conteudo do campo que acionou esta funcao/gatilho       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina chamada para atualizar os valores e totais da venda, viaº±±
±±º          ³gatilho                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      
Project Function DelA030G()

Local aArea		:=	GetArea()
Local nX
Local cCond		:= M->UA_CONDPG
Local lCalcAcr	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se sera necessario recalcular os valores dos itens³
//³com base no acrescimo financeiro da condicao de pagamento  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If 	GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+cCond,1,0) !=;
	GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+_DelA030Cond,1,0)
	
	lCalcAcr := .T.
	
EndIf

_DelA030Cond := cCond

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Varre o aCols³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aCols)
	P_DelA030(nX,cCond,lCalcAcr)
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao chamar telas se a rotina for chamada por execauto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lTk271Auto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetTlv:oBrowse:Refresh()
EndIf

RestArea(aArea)

Return &(ReadVar())        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelA030A  ºAutor  ³Norbert Waage Junior   º Data ³  09/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de calculo de descontos dos itens do televendas         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³nLinha - Numero da linha atual                                 º±±
±±º          ³nValor - Valor do desconto                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³lRet - (.T.) Permite o uso do campo                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina chamada a partir do X3_VALID, substituindo o TK273Calcu-º±±
±±º          ³la, que calculava os descontos de forma diferente da desejada. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      
Project Function DELA030A(nLinha,nValor)

Local lRet		:= .F.                                 // Retorno da funcao
Local nPQtd		:= aPosicoes[4][2]                     // Posicao da Quantidade
Local nPVrUnit	:= aPosicoes[5][2]						// Posicao do Valor unitario
Local nPVlrItem := aPosicoes[6][2]						// Posicao do Valor do item
Local nPDesc 	:= aPosicoes[9][2]						// Posicao do Desconto em %
Local nPValDesc := aPosicoes[10][2]						// Posicao do Valor desconto $
Local nPTes     := aPosicoes[11][2]						// Posicao do TES
Local nPValAcre := aPosicoes[14][2]						// Posicao do Valor do Acrescimo $
Local nPPrctab  := aPosicoes[15][2]                    // Posicao do Preco de Tabela
Local nValUni   := 0									// Valor Unitario
Local nVlrTab   := 0                                    // Valor da Tabela
Local cDesconto := TkPosto(M->UA_OPERADO,"U0_DESCONT")	// Desconto  1=ITEM / 2=TOTAL / 3=AMBOS / 4=NAO
Local cTesBonus := GetMv("MV_BONUSTS") 					// Codigo da TES usado para as regras de bonificacao
Local cTes    											// Conteudo do TES
Local nValItem  := 0									// Valor auxiliar	

Default nLinha	:= N
Default nValor	:= M->UB_VALDESC
                
cTes := aCols[nLinha][nPTes]				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a TES utilizada for igual a TES de bonificacao nao calcula os acrescimos e descontos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cTes == cTesBonus)
	Return(lRet)
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³So pode dar desconto se o Posto de venda estiver      	³
//³configurado para Item ou Ambos					    	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(cDesconto) == "2" .OR. Alltrim(cDesconto) == "4"   // Item ou Total
	If nValor > 0 
		Help( " ", 1, "NAO_DESCON")
		aCols[nLinha][nPValDesc] := 0
		Return(lRet)
	Endif	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Zero o desconto em %³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[nLinha][nPDesc]    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrego novamente o valor de desconto calculado		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[nLinha][nPValDesc] := nValor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O Valor do desconto nao pode ser maior que o vlr. do item³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nValor >= aCols[nLinha][nPVlrItem]
	Help( " ", 1, "DESCMAIOR2" )
	aCols[nLinha][nPValDesc] := 0
	aCols[nLinha][nPDesc]    := 0
	aCols[nLinha][nPValDesc] := 0
	Return(lRet)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz os calculos de desconto baseando-se no preco de tabela  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aCols[nLinha][nPPrcTab] > 0
	nVlrTab := aCols[nLinha][nPPrcTab] + aCols[nLinha][nPValAcre]
Else
	nVlrTab := aCols[nLinha][nPVrUnit]
Endif                                       

nValItem:= (nVlrTab * aCols[nLinha][nPQtd])
nValItem:= nValItem - nValor
nValUni := Round(nValItem/aCols[nLinha][nPQtd],4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se houver DESCONTO EM CASCATA ja aplica o valor no item³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (M->UA_DESC4 > 0) .OR. (M->UA_DESC1 > 0) .OR. (M->UA_DESC2 > 0) .OR. (M->UA_DESC3 > 0)
	Tk273DesCLi(nLinha,2)	// R$
	nValUni := aCols[nLinha][nPVrUnit]
Endif

aCols[nLinha][nPVrUnit] := nValUni
aCols[nLinha][nPVlrItem]:= nValItem
aCols[nLinha][nPValDesc]:= A410Arred(aCols[nLinha][nPQtd]*nVlrTab,"UB_VALDESC") - aCols[nLinha][nPVlrItem]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula a porcentagem do desconto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[nLinha][nPDesc] := A410Arred((nValor / (aCols[nLinha][nPQtd]*nVlrTab))*100,"UB_DESC")

lRet := .T.

Eval(bRefresh)
                                    
MaFisAlt("IT_TES",aCols[nLinha][nPTes],nLinha)
If MaFisFound()
	MaColsToFis(aHeader,aCols,nLinha,"TK273",.T.)
	Tk273Refresh(aValores)	
Endif

If M->UA_PDESCAB > 0
	Tk273CalcDesc()
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se esse TES gera titulos para nao obrigar a selecao das condicoes de pagamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SF4")
DbSetOrder(1)
If DbSeek(xFilial("SF4")+aCols[nLinha][nPTes])
	If SF4->F4_DUPLIC == "S"
		lTesTit := .T.
	Else
		lTesTit := .F.
	Endif
Endif

Eval(bRefresh)
                                    
If MaFisFound()
	MaColsToFis(aHeader,aCols,nLinha,"TK273",.T.)
	Tk273Refresh(aValores)	
Endif

If M->UA_PDESCAB > 0
	Tk273CalcDesc()
Endif
	
Return lRet