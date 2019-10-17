#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LJ7001   º Autor ³Ricardo Mansano     º Data ³  09/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ mansano@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para validacao no final da venda (antes   º±±
±±º          ³ das gravacoes).                                            º±±
±±º          ³ Envia como parametro o nTipo(1-orcamento/2-venda/3-pedido) º±±
±±º          ³ 01 - Estorna Reserva anterior caso exista.                 º±±
±±º          ³ 02 - Gera Reserva em SC0 e Alimenta B2_RESERVA em SB2.     º±±
±±º          ³ 03 - Gera Reserva apenas para clientes <> MV_CLIPAD.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ParamIxb[1] = 1 -> Confirmacao do Orcamento                º±±
±±º          ³ ParamIxb[1] = 2 -> Confirmacao da Venda                    º±±
±±º          ³ ParamIxb[1] = 3 -> Confirmacao do Pedido                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet = .T. (Confirma a gravacao)                           º±±
±±º          ³        .F. (Nao confirma a gravacao)                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ P.E. na confirmacao da tela de Venda Assistida (Loja701C)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                   	  º±±
±±ºBenedet   ³02/06/05³      ³Verificar se existem produtos seguros 	  º±±
±±º          ³        ³      ³sem produto pai dentro do acols.      	  º±±
±±ºBenedet   ³09/06/05³      ³Validar venda antecipada relacionada a SEPU.º±±
±±ºNorbert   ³10/06/05³      ³Validar sinistros da venda a ser gravada    º±±
±±ºGaspar    ³20/07/05³      ³Nao pode finalizar venda para cliente padraoº±±
±±º          ³        ³      ³Solicitado por Rodrigo.               	  º±±
±±ºNorbert   ³02/08/05³      ³Validacao dos Tipos de Operacao da venda    º±±
±±ºBenedet   ³15/08/05³      ³Validacao da tela de montagem que deve      º±±
±±º          ³        ³      ³existir so quando existirem servicos.       º±±
±±ºNorbert   ³28/09/05³      ³Validacao da quantidade de seguros/pneu.    º±±
±±ºNorbert   ³16/02/06³      ³Validacao dos CFOP's utilizados na venda.   º±±
±±ºMarcio Dom³03/03/06³      ³Nao deve validar os CFOP's, no recebimento  º±±
±±º          ³        ³      ³de titulos.                                 º±±
±±ºMarcio Dom³11/07/06³      ³Validacao dos CFOP's utilizados na venda.   º±±
±±º          ³        ³      ³Verifica se o CFOP existe na tabela 13 e se º±±
±±º          ³        ³      ³é o mesmo configurado na TES, também valida º±±
±±º          ³        ³      ³o digito Inicial do CFOP (Dentro ou Fora do º±±
±±º          ³        ³      ³Estado.					 				  º±±
±±ºFernando F³26/12/07³      ³Chamada das Funcoes - P_DELA016 e P_DELA042 º±±
±±º          ³        ³      ³para validar a condicao de Pagto.			  º±±
±±º          ³        ³      ³Essas funcoes eram chamadas no VLD_USER do  º±±
±±º          ³        ³      ³Campo LQ_CONDPG							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LJ7001()
Local aArea    := GetArea()
Local aAreaPAB := PAB->(GetArea())
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSA3 := SA3->(GetArea())
Local aAreaSB0 := SB0->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSF4 := SF4->(GetArea())
Local aAreaSLJ := SLJ->(GetArea())
Local aAreaSX5 := SX5->(GetArea())
Local aAreaPAF := PAF->(GetArea())

Local aSeguros := {}

Local nTotCol   := Len(aHeader) + 1
Local nTotLin   := Len(aCols)
Local cPrdOrf   := ""
Local npProduto := aScan(aHeader, {|x| rTrim(x[2]) == "LR_PRODUTO"})
Local npItem    := aScan(aHeader, {|x| rTrim(x[2]) == "LR_ITEM"})
Local npItRef   := aScan(aHeader, {|x| rTrim(x[2]) == "LR_ITREF"})
Local npQuant   := aScan(aHeader, {|x| rTrim(x[2]) == "LR_QUANT"})
Local npVlrItem := aScan(aHeader, {|x| rTrim(x[2]) == "LR_VLRITEM"})
Local npValDesc := aScan(aHeader, {|x| rTrim(x[2]) == "LR_VALDESC"})
Local npTES     := aScan(aHeaderDet, { |x| AllTrim(x[2]) == "LR_TES" })	//Marcelo
Local npCFOP    := aScan(aHeaderDet, { |x| AllTrim(x[2]) == "LR_CF"  })
Local nPPrcTab	:= aScan(aHeaderDet, { |x| AllTrim(x[2]) == "LR_PRCTAB" })
Local nPosVrUnit := aScan(aHeader, { |x| AllTrim(x[2]) == "LR_VRUNIT" })

Local lRet      := .T.
Local lPrdSeg   := .F. // Indica a existencia de produto seguro
Local lSegVinc  := .F.
Local nItmAtv   := 0
Local nX        := 0
Local nPos      := 0
Local nTotPgtos := Len(aPgtos)
Local lInc      := .F.
Local i         := 0
Local lServico  := .F.
Local cGrTrib   := ""
Local _lFatura  := .T.
Local _c
Local cMoeda	:= 1
Local nValor	:= 0
Local nI		:= 0

// Verifica empresa
If cEmpAnt == "01"  //DELLA VIA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Tratamento para vinculo de 1 seguro por pneu
	If PA6->(FieldPos("PA6_SGVINC")) > 0
		lSegVinc := (GetAdvFVal("PA6","PA6_SGVINC",xFilial("PA6")+M->LQ_CODCON,1,"") == "S")
	EndIf
	
	// Configura produto
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	// Verifica se existem produtos seguros orfaos
	For i := 1 to nTotLin
		If aCols[i][nTotCol] // Linha deletada
			Loop
		EndIf
		
		// Posiciona produto
		SB1->(dbSeek(xFilial("SB1") + aCols[i][npProduto]))
		
		// Acumula item ativo
		nItmAtv += 1
		
		If SB1->B1_GRUPO == GetMV("FS_DEL001") // Produto seguro
			
			lPrdSeg := .T.
			
			//Acumula pais de seguros
			If (nPos := AScan(aSeguros,{|x| x[1] == aCols[i][npItRef] })) == 0
				AAdd(aSeguros,{aCols[i][npItRef],aCols[i][npQuant],1})
			Else
				aSeguros[nPos][3]++
			EndIf
			
			If !P_D05VldItem(aCols[i][npItRef], aCols[i][npItem]) // Seguro orfao
				cPrdOrf += aCols[i][npItem] + ", "
			EndIf
			
		EndIf
		
		If M->LQ_CONDPG == GetMV("FS_DEL021") // condicao venda antecipada sobre sepu
			If aCols[i][npQuant] > 1
				MsgAlert(OemtoAnsi("Venda relacionada ao SEPU só pode ter um item!"), "Aviso")
				lRet := .F.
			EndIf
		EndIf
	Next i
	
	// Marcelo Gaspar - 20/07/05
	If (M->LQ_CLIENTE         == GetMV("MV_CLIPAD"); // Venda para cliente padrao
		.And. M->LQ_LOJA  == GetMV("MV_LOJAPAD");
		.And. ParamIxb[1] == 2 ) .And. !lRecebe
		
		MsgAlert(OemtoAnsi("Não é permitida a venda para cliente padrão. Favor informar um cliente cadastrado."), "Aviso")
		lRet := .F.
	EndIf
	
	If Len(cPrdOrf) > 0 // Se ha produtos orfaos mostra mensagem
		cPrdOrf := Left(cPrdOrf, Len(cPrdOrf) - 2)
		MsgAlert(OemtoAnsi("Os seguintes itens estão sem produto pai: " + cPrdOrf), "Aviso")
		lRet := .F.
	EndIf
	
	If lSegVinc
		
		//Avalia seguros
		aSort(aSeguros)
		
		For nPos := 1 to Len(aSeguros)
			
			If aSeguros[nPos][3] > aCols[Val(aSeguros[nPos][1])][aScan(aHeader, {|x| rTrim(x[2]) == "LR_QUANT"})]
				lRet := .F.
				MsgAlert("O convênio atual não permite mais de um seguro por pneu. Verifique o item '"+aSeguros[nPos][1]+"'","Seguros")
				Exit
			EndIf
			
		Next nPos
		
	EndIf
	
	If M->LQ_CONDPG == GetMV("FS_DEL021"); // condicao venda antecipada sobre sepu
		.And. lRet
		If nItmAtv > 1 // vda antecipada so pode ter um item
			MsgAlert(OemtoAnsi("Esta venda só pode ter um item, porque está relacionada ao SEPU!"), "Aviso")
			lRet := .F.
		EndIf
	EndIf
	
	//Valida sinistros em uso
	If lRet .And. ParamIxb[1] == 2
		lRet := P_DelA020F()
	EndIf
	
	//Valida Tipos de operacao
	If lRet
		lRet := P_ChkTpOp()
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tela de montagem pode ter informacoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i := 1 to nTotLin
		If !gdDeleted(i)
			// verifica se existe produto tipo servico
			If GetMV("FS_DEL037") == RetField("SB1", 1, xFilial("SB1") + gdFieldGet("LR_PRODUTO", i), "B1_GRUPO")
				lServico := .T.
				Exit
			EndIf
		EndIf
	Next i
	
	If !lServico
		If _DELA013A // Entrou na tela de equipe de montagem
			If !Empty(_DELA013B)
				MsgAlert(OemtoAnsi("Favor apagar a tela de montagem porque não há serviços no orçamento!"), "Aviso")
				lRet := .F.
			EndIf
		Else // Nao entrou na tela de equipe de montagem
			dbSelectArea("PAB")
			dbSetOrder(3) // PAB_FILIAL + PAB_ORC
			If dbSeek(xFilial("PAB") + M->LQ_NUM)
				MsgAlert(OemtoAnsi("Favor apagar a tela de montagem porque não há serviços no orçamento!"), "Aviso")
				lRet      := .F.
			EndIf
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obrigar preenchimento da ordem de montagem quando existir servico ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ParamIxb[1] == 2 // Venda
			If !_DELA013A // Nao entrou na tela de equipe de montagem
				dbSelectArea("PAB")
				dbSetOrder(3) // PAB_FILIAL + PAB_ORC
				If !dbSeek(xFilial("PAB") + M->LQ_NUM)
					MsgAlert(OemtoAnsi("Favor preencher a equipe de montagem!"), "Aviso")
					lRet := .F.
				EndIf
			Else // Entrou na tela de equipe de montagem
				If Empty(_DELA013B)
					MsgAlert(OemtoAnsi("Favor preencher a equipe de montagem!"), "Aviso")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Marcelo Alcantara - 04/09/2005 											³
	//³ Verifica se ja foi efetuada a sangria automatica na databaseoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ParamIxb[1] == 2
		dbSelectArea("SLJ")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0")) .and. SLJ->LJ_DTSANGR >= dDataBase
			Aviso("Aviso","Nao e possivel Finalizar Venda apos a emissao da Sangria Automatica!! ",{"Ok"})
			lRet := .F.
		Endif
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Marcelo Alcantara - 14/12/05 								     ³
	//³ Valida o TES de serviço na confirmacao do orcamento com os grupos³
	//³ de Tributacao de acordp com o parametro MV_GRTRIBV               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ParamIxb[1] == 2 .and. !lRecebe
		For i := 1 to nTotLin
			If aCols[i][nTotCol] // Linha deletada
				Loop
			EndIf
			
			If aColsDet[i][npTES] == '900'   	//Verifica se a tes do produto no acolsder e 900
				
				// Posiciona produto e Pega o Grupo de Triburacao
				cGrTrib:=  AllTrim(Posicione("SB1",1,xFilial("SB1") + aColsDet[i][npProduto],"B1_GRTRIB"))
				
				If !(cGrTrib $ GetMV("MV_GRTRIBV"))  // Se o TES 900 for <> do Grupo de Trib que contiver no parametro (004, 015)
					Aviso("Aviso","O produto " + aCols[i][npProduto] + ;
					"esta com TES 900, e nao pertence ao Grupo de Tributacao de servico, verifique o tipo de Operacao",{"Ok"})
					lRet := .F.
				EndIf
			EndIf
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Marcelo Alcantara - 19/12/05 								          ³
		//³ Valida se o vendedor podera finazilar a venda segungo campo A3_FATURA ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_lFatura:= (Posicione("SA3",1,XFILIAL("SA3")+M->LQ_VEND,"A3_FATURA") <> "N")
		If .Not. _lFatura
			Aviso("Aviso","Nao e possivel Finalizar Venda para esse vendedor, favor trocar o vendedor e finalizar a venda!! ",{"Ok"})
			lRet := .F.
		EndIf
	EndIf
	
	/////////////////////////////////////////////////////
	// Validação do CFOP - Marcio Domingos - 11/07/06  //
	/////////////////////////////////////////////////////
	
	If Len(aColsDet) > 0       // No recebimento de titulos o array aColsDel vem vazio
		
		nPosTES := Ascan(aHeaderDet,{ |x| Alltrim(x[2])=="LR_TES"})
		nPosCFO := Ascan(aHeaderDet,{ |x| Alltrim(x[2])=="LR_CF"})
		
		_cMsg:=""
		_lret:=.T.
		
		For _c:=1 to Len(aColsDet)
			If !aColsDet[_c,Len(aHeaderDet)+1]
				dBselectarea("SF4")
				dBsetorder(1)
				IF dBseek(xFilial("SF4")+aColsDet[_c][nPosTES])
					
					If aColsDet[_c][nPosCFO] # "6108"  // Venda para cliente não contribuinte fora do estado
						If !Substr(aColsDet[_c][nPosCFO],2,3) = Substr(SF4->F4_CF,2,3)
							_cMsg:=_cMsg + aColsDet[_c][nPosCFO]+" CFOP Divergente do Pedido de Venda com o TES "+Chr(13)+Chr(10)
							_lret:=.F.
						Endif
					Endif
					
					_cDig:=" "
					
					dBselectarea("SA1")
					dBsetOrder(1)
					dBseek(xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA)
					If SA1->A1_EST == SM0->M0_ESTENT
						_cDig:="5"
					Else
						_cDig:="6"
					ENDIF
					
					IF !Substr(aColsDet[_c][nPosCFO],1,1) = _cDig
						_cMsg:=_cMsg + aColsDet[_c][nPosCFO]+" Digito Inicial do CFOP (Dentro ou Fora do Estado) esta Invalido !!!  "+Chr(13)+Chr(10)
						_lret:=.F.
					Endif
					
					//					If _cDig == "6"
					//						dBselectarea("SX5")
					//						dBsetorder(1)
					//						IF !dbseek(xFilial("SX5")+"13"+"5"+Substr(aColsDet[_c][nPosCFO],2,3)+Spac(2))
					//							_cMsg:=_cMsg + aColsDet[_c][nPosCFO]+" Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
					//							_lret:=.F.
					//						Endif
					//					Else
					dBselectarea("SX5")
					dBsetorder(1)
					IF !dbseek(xFilial("SX5")+"13"+Substr(aColsDet[_c][nPosCFO],1,4)+Spac(2))
						_cMsg:=_cMsg + aColsDet[_c][nPosCFO]+" Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
						_lret:=.F.
					Endif
					
					//					Endif
					
				Endif
				
			Endif
			
		Next
		/*
		If lRet
		lRet := U_VldCupom(Paramixb[3],M->LQ_CLIENTE,M->LQ_LOJA)
		Endif
		*/
		IF !_lret
			MSGSTOP(_cMsg)
			lRet := _lRet
		Endif
		
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Marcelo Alcantara - 14/02/2007 									³
	//³ Verifica se o campo M->LQ_TIPOVND esta vazio.                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ParamIxb[1] == 2 .and. !lRecebe
		
		If Empty(M->LQ_TIPOVND) .Or. M->LQ_TIPOVND == " "
			Aviso("Aviso","Ocorreu um problema no Tipo de Venda (L1_TIPOVND). Favor preencher o campo novamenteda !! ",{"Ok"})
			lRet := .F.
		Endif
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajuste para gravacao do preco de tabela no SB0 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		SB0->(dbSetOrder(1)) // B0_FILIAL+B0_COD
		
		For nX := 1 to nTotLin
			If aCols[nX][nTotCol] // Linha deletada
				Loop
			EndIf
			
			If SB0->(dbSeek(xFilial("SB0") + aCols[nX][npProduto]))
				lInc := .F.
			Else
				lInc := .T.
			Endif
			
			If RecLock("SB0", lInc)
				If lInc
					SB0->B0_FILIAL := xFilial("SB0")
					SB0->B0_COD    := aCols[nX][npProduto]
				EndIf
				SB0->B0_PRV1 	:= NoRound((aCols[nX][npVlrItem] + aCols[nX][npValDesc]) / aCols[nX][npQuant], nDecimais)
				msUnlock()
			Else
				ConOut("Tabela de precos nao corrigida para a filial/orcamento/produto " + cFilAnt + "/" + M->LQ_NUM + "/" + aCols[nX][npProduto])
			EndIf
		Next nX
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recalcula os Preços de Tabela de acordo com        ³
//³a Condição de Pagamento escolhida.                 ³
//³Foi necessária a inclusão pois a função Lj7Detalhe,³
//³zerava o cálculo efetuado durante a entrada na tela³
//³de Pagamentos.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRecebe .AND. Len(aCols) > 0 .AND. Len(aColsDet) > 0
	For nI := 1 to Len(aCols)
		//		If aColsDet[nI,nPPrcTab] <= 0
		// Eder - Alterado para pegar Cond. de Pag. real, ao inves da CN
		//			nValor		:=	P_DELA027(	M->LQ_CODTAB,	aCols[nI][nPProduto],	aCols[nI][nPQuant],;
		//										M->LQ_CLIENTE,	M->LQ_LOJA,				cMoeda,;
		//										M->LQ_DTLIM,	M->LQ_CONDPG,			0)
		nValor		:=	P_DELA027(	M->LQ_CODTAB,	aCols[nI][nPProduto],	aCols[nI][nPQuant],;
		M->LQ_CLIENTE,	M->LQ_LOJA,				cMoeda,;
		M->LQ_DTLIM,	_cD020CPG,			0)
		If nValor > 0
			aColsDet[nI][nPPrcTab] := nValor
		Else
			aColsDet[nI][nPPrcTab] := (aCols[nI][npVlrItem] + aCols[nI][nPValDesc]) / (aCols[nI][nPQuant])
		EndIf
		//		EndIf
	Next nI
EndIf

If lRet .AND. M->LQ_TIPOVND = "V"
	lRet := U_DVLOJF04(aHeader,aCols,ParamIxb[1])
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado por: Fernando Fonseca  Data: 26.12.2007³
//³Validacao da Condicao de Pagto conforme chamada ³
//³das Rotinas: P_DELA0016 e P_DELA042             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	lRet:= P_DELA016A()
EndIf

If lRet
	lRet:= P_DELA042()
EndIf


RestArea(aAreaPAF)
RestArea(aAreaPAB)
RestArea(aAreaSA1)
RestArea(aAreaSA3)
RestArea(aAreaSB0)
RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aAreaSLJ)
RestArea(aAreaSX5)
RestArea(aArea)
Return(lRet)
