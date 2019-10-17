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
±±º          ³        ³      ³Estado.									  º±±	
±±ºMarcio Dom³25/08/06³      ³Regras para Impressao de Cupom e Nota Fiscalº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LJ7001()
Local aAreaIni := GetArea()
Local aAreaSB1, aAreaPA8, aAreaSX5
Local aSeguros	:= {}

Local nTotCol 	:= Len(aHeader) + 1
Local nTotLin 	:= Len(aCols)
Local cPrdOrf 	:= ""
Local npProduto := aScan(aHeader, {|x| rTrim(x[2]) == "LR_PRODUTO"})
Local npItem    := aScan(aHeader, {|x| rTrim(x[2]) == "LR_ITEM"})
Local npItRef   := aScan(aHeader, {|x| rTrim(x[2]) == "LR_ITREF"})
Local npQuant   := aScan(aHeader, {|x| rTrim(x[2]) == "LR_QUANT"})
Local npTES		:= aScan(aHeaderDet, { |x| AllTrim(x[2]) == "LR_TES" })	//Marcelo 
Local npCFOP	:= aScan(aHeaderDet, { |x| AllTrim(x[2]) == "LR_CF"  })
Local lRet 		:= .T.
Local lPrdSeg 	:= .F. // Indica a existencia de produto seguro
Local lSegVinc	:= .F.
Local nItmAtv 	:= 0
Local nX	 	:= 0
Local nPos		:= 0
Local nTotPgtos := Len(aPgtos)
Local i 		:= 0
Local lServico 	:= .F.
Local cGrTrib	:= ""
Local _lFatura	:= .T.                                    
Local _c

// Verifica empresa
If cEmpAnt == "01"  //DELLA VIA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaSB1 := SB1->(GetArea())
	aAreaPA8 := PA8->(GetArea())
	aAreaSX5 := SX5->(GetArea())
	
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacao dos CFOP's utilizados na venda - Norbert³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//////////////////////////
	// Comentado por Marcio //
	//////////////////////////
	
	/*
	If Len(aColsDet) > 0       // No recebimento de titulos o array aColsDel vem vazio
	
		SX5->(DbSetOrder(1))
		
		For i := 1 to nTotLin
	
			//Pula linhas deletadas
			If aTail(aColsDet[i])
				Loop
			EndIf
			
			//Valida CFOP
			If !SX5->(DbSeek(xFilial("SX5")+'13'+aColsDet[i][npCFOP]))
	
				ApMsgAlert("CFOP inválido para o item " + StrZero(i,2) +;
				 ". Ajuste os detalhes deste item antes de prosseguir","Aviso")
				lRet := .F.
				Exit
	
			EndIf
			
		Next i
		
	Endif	
	
	
	If M->LQ_CLIENTE == GetMV("MV_CLIPAD"); // Venda para cliente padrao
	.And. M->LQ_LOJA == GetMV("MV_LOJAPAD");
	.And. ParamIxb[1] == 2
	
	For i := 1 to nTotPgtos
	If aPgtos[i][3] $ GetMV("MV_FORMCRD") // Verifica formas de pagamento
	MsgAlert(OemtoAnsi("Não é permitida a venda com as formas de pagamento ";
	+ AllTrim(GetMV("MV_FORMCRD")) + " para cliente padrão."), "Aviso")
	lRet := .F.
	Exit
	EndIf
	Next i
	
	If lPrdSeg // Venda de seguro para cliente padrao
	MsgAlert(OemtoAnsi("Não é permitida a venda de seguro para cliente padrão!"), "Aviso")
	lRet := .F.
	EndIf
	EndIf
	*/
	
	// Marcelo Gaspar - 20/07/05
	If (M->LQ_CLIENTE   	 == GetMV("MV_CLIPAD"); // Venda para cliente padrao
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
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o cliente foi alterado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPrdSeg // Existem seguros no orcamento
		If !SL1->(EOF())
			If SL1->L1_NUM == M->LQ_NUM .And. SL1->(L1_CLIENTE + L1_LOJA) <> M->(LQ_CLIENTE + LQ_LOJA) // Trocou o cliente
				If SL1->(L1_CLIENTE + L1_LOJA) <> GetMV("MV_CLIPAD") + GetMV("MV_LOJAPAD") // Nao e cliente padrao
					MsgAlert(OemtoAnsi("O cliente não pode ser trocado!"), "Aviso")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	*/
	
	// Retorna ambiente
	RestArea(aAreaPA8)
	RestArea(aAreaSB1)
	RestArea(aAreaSX5)
	
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

EndIf

RestArea(aAreaIni)

	If lRet .AND. M->LQ_TIPOVND = "V"
		lRet := U_DVLOJF04(aHeader,aCols,ParamIxb[1])
	Endif

Return(lRet)
