#Include "Protheus.Ch"
#Include "topconn.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LJ7002   º Autor ³Paulo Benedet       º Data ³  10/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ParamIxb[1] = 1 -> Confirmacao do Orcamento                º±±
±±º          ³ ParamIxb[1] = 2 -> Confirmacao da Venda                    º±±
±±º          ³ ParamIxb[1] = 3 -> Confirmacao do Pedido                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Ponto de entrada apos a gravacao dos arquivos.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Della Via Pneus                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                   	  º±±
±±ºMansano   ³18/05/05³      ³Implementacao das Rotinas de Reserva        º±±
±±º          ³        ³      ³em SC0 e B2_RESERVA                         º±±
±±º          ³        ³      ³                                            º±±
±±ºMansano   ³21/05/05³      ³Implementacao da Rotina para salvar a       º±±
±±º          ³        ³      ³Equipe de Montagem utilizada no Orcamento   º±±
±±º          ³        ³      ³ou Venda                                    º±±
±±º          ³        ³      ³                                            º±±
±±ºMansano   ³31/05/05³      ³Implementacao da Rotina para salvar a -     º±±
±±º          ³        ³      ³Margem Media em L2 e D2                     º±±
±±º          ³        ³      ³                                            º±±
±±ºBenedet   ³31/05/05³      ³Atualizar informacoes de faturamento no     º±±
±±º          ³        ³      ³televendas.                                 º±±
±±º          ³        ³      ³                                            º±±
±±ºMansano   ³01/06/05³      ³Funcao para Salvar dados de Bco/Age/C.C.    º±±
±±º          ³        ³      ³no financeiro SE1.                          º±±
±±º          ³        ³      ³                                            º±±
±±ºMansano   ³01/06/05³      ³Funcao para Salvar Naturezas em SE1 de      º±±
±±º          ³        ³      ³acordo com as regras do Cliente             º±±
±±º          ³        ³      ³                                            º±±
±±ºMansano   ³08/06/05³      ³Salvar preco de Tabela no Campo             º±±
±±º          ³        ³      ³L2_PRCATU.                                  º±±
±±º          ³        ³      ³                                            º±±
±±ºNorbert   ³08/06/05³      ³Salva informacoes do sinistro na tabela     º±±
±±º          ³        ³      ³PA8, atraves da funcao P_DELA020D           º±±
±±º          ³        ³      ³                                            º±±
±±ºBenedet   ³09/06/05³      ³Salva informacoes do sepu.                  º±±
±±º          ³        ³      ³                                            º±±
±±ºNorbert   ³10/06/05³      ³Gera titulos no contas a receber caso haja  º±±
±±º          ³        ³      ³promocao nos itens sinistrados.             º±±
±±º          ³        ³      ³                                            º±±
±±ºMansano   ³23/06/05³      ³Incluida impressao do Relatorio de Montagem º±±
±±º          ³        ³      ³no momento de salvar o Orcamento.           º±±
±±º          ³        ³      ³                                            º±±
±±ºBenedet   ³30/06/05³      ³Gravar codigo do banco do cliente no contas º±±
±±º          ³        ³      ³a receber.                                  º±±
±±º          ³        ³      ³                                            º±±
±±ºNorbert   ³12/09/05³      ³Gravacao do NSU para pagamento com cartao noº±±
±±º          ³        ³      ³SE1                                         º±±
±±º          ³        ³      ³                                            º±±
±±ºBenedet   ³23/09/05³      ³Gravar codigo do ISS no SD2 quando produto  º±±
±±º          ³        ³      ³for servico.                                º±±
±±ºMarcelo   ³09/11/05³      ³Alterado a Busca do titulo na gravacao do   º±±
±±ºAlcantara ³        ³      ³banco portador e acrescentado a busca d se  º±±
±±º          ³        ³      ³rie pelo parametro MV_LJPREF                º±±
±±ºMarcelo   ³08/12/05³      ³Acrecentados gravacao de novos campos na tabº±±
±±ºAlcantara ³        ³      ³SF2 (PLACA, CODCON, CODMAR, CODMOD, KM, ANO º±±
±±º          ³        ³      ³e ORIGEM)                                   º±±
±±ºMarcelo   ³16/01/06³      ³- Gravacao do campo L1_LOG, para identificarº±±
±±ºGaspar    ³        ³      ³  se a rotina foi interrompida.             º±±
±±º          ³        ³      ³                                            º±±
±±ºEdison    ³18/01/06³      ³- Retirada do IndRegua para utilizacao de   º±±
±±ºMaricate  ³        ³      ³  indice padrao da tabela SE1.              º±±
±±ºMarcelo   ³16/03/07³      ³Retirado Begins/End Transaction e dbCommit  º±±
±±ºAlcantara ³        ³      ³pois estavam influenciando na gravacao dos  º±±
±±º          ³        ³      ³campos do SF2/SE1.                          º±±
±±ºGuilherme ³27/11/07³      ³Correcao na gravacao do Codigo do ISS, nos  º±±
±±ºSantos    ³        ³      ³livros fiscais SFT/SF3, para vendas de pro- º±±
±±º          ³        ³      ³dutos com CF de tributacao ISS.             º±±
±±ºEder      ³06/05/08³      ³Alterada data de vencimento da reserva dos  º±±
±±º          ³        ³      ³produtos para utilizar o parametro          º±±
±±º          ³        ³      ³MV_DIARESE. Se nao tiver, considera 5 dias. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LJ7002()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao de variaveis.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea    := GetArea()
Local aAreaPA4 := PA4->(GetArea())
Local aAreaPA7 := PA7->(GetArea())
Local aAreaPAB := PAB->(GetArea())
Local aAreaSB2 := SB2->(GetArea())
Local aAreaSC0 := SC0->(GetArea())
Local aAreaSD2 := SD2->(GetArea())
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSF3 := SF3->(GetArea())
Local aAreaSFT := SFT->(GetArea())
Local aAreaSL1 := SL1->(GetArea())
Local aAreaSL2 := SL2->(GetArea())
Local aAreaSL4 := SL4->(GetArea())
Local aAreaSLJ := SLJ->(GetArea())

Local _nY
Local nX   			:= 0
Local cNumReserv	:= ""
Local cArq			:= ""
//Local aSaldoSB2		:= {} // Variavel era usada pela CalcEst que foi substituida pela P_DCalcEst()
Local aProds		:= {}
Local nPos			:= 0
Local nDisponivel 	:= 0
Local nQtdReserv  	:= 0
Local naCols		:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local cTipoPrd		:= ""
//Local cPasta		:= ""
Local aVlrMM		:= {}
Local aDadosBco		:= {}
Local cNaturez		:= ""
Local cCliPad		:= Padr(GetMv("MV_CLIPAD"),TamSx3("A1_COD")[1])
Local cLojaPad		:= GetMv("MV_LOJAPAD")
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO"})
Local nPosLocal   	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_LOCAL"  })
Local nPosItem    	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_ITEM"   })
Local nPosQuant   	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_QUANT"  })
Local nPosTes     	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_TES"    })
Local _cFilial		:= ""
Local _cNum 		:= ""
Local _cDoc       	:= ""
Local _cSerie      	:= ""
Local _cCliente		:= ""
Local _cLoja		:= ""
Local _dEmissao  	:= ""
Local _cCliAdm		:= ""
Local _cEstoque		:= ""
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local _lFezReser    := .F.
Local cBanco        := "" // Codigo do banco a ser gravado no titulo
Local _cSerieSE1	:= ""	//Serie do Parametro MV_LJPREF
Local _cTipoVend	:= ""
Local _cOrigSL4     := Space(TamSx3("L4_ORIGEM")[1] ) // O conteudo deste campo gerado pelo Sigaloja eh em branco e pelo Call Center eh "SIGATMK "
Local _cCondPGx     := SF2->F2_COND

Conout("LJ7002 - Entrando no ponto de entrada")

// EDER - SE FOR CN E TIVER FORMA VALIDA, USA FORMA VALIDA
//For _nY := 1 to len(aPgtos)
//	If ! Alltrim(aPgtos[_nY,3]) $ "SG/CT" .and. !Empty(Alltrim(_cD020CPG)) .and. Alltrim(_cD020CPG)<>"CN"
//		_cCondPGx := _cD020CPG
//	Endif
//Next

// eder - baixa cheques a vista
bxchqav()

// ATUALIZA A ULTIMA COMPRA DO CLIENTE, CASO NAO TENHA SIDO ATUALIZADO
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA) .and. RecLock("SA1",.f.)
	SA1->A1_ULTCOM := dDataBase
	MSUnlock()
Endif

// Verifica empresa
If cEmpAnt == "01"  // DELLA VIA
	// Verifica se eh recebimento
	If lRecebe
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Variavel publica inicalizada no ponto LJ0016³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cD020CPG	:=	""
		
		Return
	EndIf
	
	// Posiciona cabecalho orcamento
	dbSelectArea("SL1")
	dbSetOrder(1) // L1_FILIAL+L1_NUM
	dbSeek(xFilial("SL1") + M->LQ_NUM)
	
	_cFilial	:= SL1->L1_FILIAL
	_cNum 		:= SL1->L1_NUM
	_cDoc       := SL1->L1_DOC
	_cSerie     := SL1->L1_SERIE
	_cCliente	:= SL1->L1_CLIENTE
	_cLoja		:= SL1->L1_LOJA
	_dEmissao  	:= SL1->L1_EMISSAO
	_cTipoVend	:= SL1->L1_TIPOVND
	
	Conout("LJ7002 - Orcamento                 = "+M->LQ_NUM+" "+Substr(cUsuario,7,15))
	Conout("LJ7002 - Linha 156 - cTipoVend     = "+_cTipoVend)
	Conout("LJ7002 - Linha 157 - L1_TIPOVND    = "+SL1->L1_TIPOVND)
	Conout("LJ7002 - Linha 158 - M->LQ_TIPOVND = "+M->LQ_TIPOVND)
	If Empty(_cTipoVend)
		_cTipoVend	:=	M->LQ_TIPOVND
		Conout("LJ7002 - Linha 161 - cTipoVend     = "+_cTipoVend)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o Nome do cliente (L1_NOMCLI) na tabela SL1.                        ³
	//³Este procedimento faz-se necessario porque o Tipo deste campo foi customizado³
	//³para Real (no padrao ele eh virtual). E existe um procedimento de consulta   ³
	//³no Sigacrd que permite a troca do cliente e nestes casos a rotina padrão     ³
	//³troca apenas o Codigo do cliente (L1_CLIENTE).                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SL1",.F.)
	SL1->L1_NOMCLI := GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,1,"Erro")
	SL1->L1_VEIPESQ := _cD020CPG
	MsUnLock()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Deleta todos as reservas relacionadas com o orcamento                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Estorna Reservas em SC0
	dbSelectArea("SB2")
	dbSetOrder(1) // Filial + Codigo + Local
	
	dbSelectArea("SC0")
	dbSetOrder(3) // C0_FILIAL + C0_NUMORC + C0_PRODUTO
	
	If dbSeek(xFilial("SC0")+_cNum)
		
		While !SC0->(Eof()) .And. xFilial("SC0")+_cNum == SC0->(C0_FILIAL + C0_NUMORC)
			
			//Begin Transaction
			// Estorna Reservas em SB2
			If SB2->( DbSeek(xFilial("SB2")+SC0->C0_PRODUTO+SC0->C0_LOCAL) )
				RecLock("SB2",.F.)
				SB2->B2_RESERVA -= SC0->C0_QTDPED
				If SB2->B2_RESERVA < 0
					Conout("LJ7002 - Linha 196 - Reserva Negativa Orcamento = "+M->LQ_NUM+" "+Substr(cUsuario,7,15))
					SB2->B2_RESERVA	:= 0
				Endif
				MsUnLock()
			EndIf
			
			// Deleta Reserva em SC0
			RecLock("SC0",.F.)
			SC0->(dbDelete())
			MsUnLock()
			//End Transaction
			
			SC0->(dbSkip())
			
		EndDo
		
		dbSelectArea("SL1")
		dbSetOrder(1) // L1_FILIAL + L1_NUM
		
		If dbSeek(xFilial("SL1") + _cNum )
			RecLock("SL1",.F.)
			SL1->L1_RESERVA := "" // Campo padrao utilizado na regra que define as cores do mBrowse (LOJA701)
			MsUnLock()
		EndIf
		
	EndIf
	
	If ParamIxb[1] == 1 .Or. ParamIxb[1] == 2	//ORCAMENTO OU VENDA
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Esta funcao se encontra no DELXFUN e eh responsavel pela gravacao do numero de       ³
		//³ Sequencia no arquivo SL4, ela nao deve se tirada deste Ponto de Entrada              ³
		//³ OBS: Origem em branco pois o Venda Assistida nao salva L4_ORIGEM.       			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		P_AtuSeqL4(_cFilial,_cNum,PadR("",8))
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄPrimeiro CHECKPOINTÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao do campo L1_LOG para garantir que a rotina foi executada neste ponto.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SL1")
	dbSetOrder(1)//	L1_FILIAL+L1_NUM
	If dbSeek(xFilial("SL1") + _cNum )
		RecLock("SL1",.F.)
		SL1->L1_LOG := "01" // Primeiro CHECKPOINT
		MsUnLock()
	EndIf
	
	If ParamIxb[1] == 1 // ORCAMENTO
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Informacoes complementares de venda de seguro ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		P_D05DadosSeg(ParamIxb[1], _cNum)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A rotina DELA020J grava os dados da seguradora e corretora ³
		//³utilizadas no sinistro, quando isto ocorrer, na tabela SL4 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		P_DELA020J(_cFilial,_cNum,.T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se ha produtos que manipulam estoque na venda.³
		//³Se nao houver, desconsidera a parte de reservas        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nX := 1
		While nX <= naCols .And. _cEstoque != "S"
			_cEstoque := GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+aColsDet[nX,nPosTes],1,"Erro")
			nX++
		End
		
		// Nao executa Reserva para o Cliente Padrao
		If	(cCliPad <> SL1->L1_CLIENTE) .And. _cEstoque == "S" .And.;
			ApMsgYesNo("Deseja reservar os produtos vendidos no estoque?","Reservas")
			
			// Refaz Reservas caso seja Orcamento
			For nX := 1 to naCols
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ignora aCols Deletados e com F4_ESTOQUE="N"              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cEstoque := GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+aColsDet[nX,nPosTes],1,"Erro")
				
				If (aCols[nX, naColsItem]) .or. (_cEstoque == "N")
					Loop
				Else
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Eh criado um array para controle dos produtos vendidos, pois³
					//³nao eh permitida a duplicidade de produtos para um mesmo    ³
					//³orcamento, na tabela SB0 - Norbert                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (nPos := aScan(aProds,{|x| x[1]+x[2] == aCols[nX,nPosProduto]+aColsDet[nX,nPosLocal] }) ) == 0
						AAdd(aProds,{aCols[nX,nPosProduto],aColsDet[nX,nPosLocal],aCols[nX,nPosQuant]})
					Else
						aProds[nPos][3] += aCols[nX,nPosQuant]
					EndIf
					//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					
				Endif
				
			Next nX
			
			For nX := 1 to Len(aProds)
				
				// Verifica se Existe Saldo em Estoque para Reserva
				// e reserva apenas o que for possivel
				SB2->(DbSetOrder(1)) // B2_FILIAL + B2_COD + B2_LOCAL
				If SB2->( DbSeek(xFilial("SB2")+aProds[nX][1]+aProds[nX][2]) )
					
					// Verifica Estoque Disponivel usando a CalcEst()
					//aSaldoSB2   := CalcEst(aProds[nX][1],aProds[nX][2],dDataBase+1)
					//nDisponivel := aSaldoSB2[1] - ( SB2->B2_QEMP + AvalQtdPre("SB2",1,NIL,"SB2") + SB2->B2_RESERVA + SB2->B2_QEMPSA )
					nDisponivel := P_DCalcEst(xFilial("SB2"),aProds[nX][1],aProds[nX][2])
					
					// Informa Saldo Zerado ou Negativo, impedindo a Reserva
					If nDisponivel <= 0
						Aviso("Atenção !!!","O Produto "+Alltrim(aProds[nX][1])+" não pode ser reservado por estar com estoque Zerado ou Negativo !!!",{" << Voltar"},2,"Reserva !")
						Loop
					Endif
					
					// Verifica se pode reservar a Quantidade digitada no Orcamento
					nQtdReserv := aProds[nX][3]
					If aProds[nX][3] > nDisponivel
						Aviso("Atenção !!!","O Produto "+Alltrim(aProds[nX][1])+" sera reservado apenas a Qtd de: " +str(nDisponivel,12,3)+" !!!",{" << Voltar"},2,"Reserva !")
						// Reajusta quantidade a ser reservada
						nQtdReserv := nDisponivel
					Endif
					
					// Reserva Numero em SC0
					If Empty(cNumReserv)
						cNumReserv  := GetSxeNum("SC0","C0_NUM") // Reserva o Nr em SC0
						// Confirma para evitar problemas se alguem utilizar o mesmo Nr enquanto estiver no FOR
						// pois este FOR podera ter Alerts informando erros na Reserva
						ConfirmSx8()
					Endif
					
					// Inclui registro para Reserva do produto
					//			Begin Transaction
					dbSelectArea("SC0") // Controle de reservas
					RecLock("SC0",.T.)
					SC0->C0_FILIAL  := xFilial("SC0")
					SC0->C0_NUM	    := cNumReserv
					SC0->C0_TIPO    := "VD" //Soh preencho este campo porque ele eh obrigatorio da tela . Ele soh aceita : VD,CL,PD,LB,NF
					SC0->C0_DOCRES  := 	""
					SC0->C0_SOLICIT := 	AllTrim(SubStr(cUsuario,7,15))
					SC0->C0_FILRES  := xFilial("SC0")
					SC0->C0_EMISSAO := dDataBase
					SC0->C0_VALIDA  := dDataBase + GetNewPar("FS_DIARESE",5) //cTod("31/12/2049")
					SC0->C0_PRODUTO := aProds[nX][1]
					SC0->C0_LOCAL   := aProds[nX][2]
					SC0->C0_QUANT   := nQtdReserv
					SC0->C0_QTDORIG := nQtdReserv
					SC0->C0_QTDPED  := nQtdReserv
					SC0->C0_NUMORC  := _cNum // No do Orcamento
					MsUnLock()
					
					// Atualiza a quantidade reservada
					dbSelectArea("SB2")
					RecLock("SB2",.F.)
					SB2->B2_RESERVA += nQtdReserv
					MsUnLock()
					//		End Transaction
					
					_lFezReser := .T.
				Endif
				
			Next nX
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se gerou pelo menos uma reserva e flega a Venda.  ³
			//³ Marcelo Gaspar - 09/06/05                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _lFezReser
				dbSelectArea("SL1")
				dbSetOrder(1) // L1_FILIAL + L1_NUM
				If dbSeek(xFilial("SL1") + _cNum )
					RecLock("SL1",.F.)
					SL1->L1_RESERVA := "S" // Campo padrao utilizado na regra que define as cores do mBrowse (LOJA701)
					MsUnLock()
				EndIf
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o Relatorio de Montagem com o SL1 posicionado.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ApMsgYesNo("Imprimir ordem de montagem?")
			P_DELR001()
		Endif
		
	ElseIf ParamIxb[1] == 2 // VENDA
		
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Informacoes complementares de venda de seguro ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		P_D05GravaNF(_cNum) // Grava informacoes de venda
		
		
		//ÚÄÄÄÄÄÄÄÄÄSegundo CHECKPOINTÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao do campo L1_LOG para garantir que a rotina foi executada neste ponto.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SL1")
		dbSetOrder(1)//	L1_FILIAL+L1_NUM
		If dbSeek(xFilial("SL1") + _cNum )
			RecLock("SL1",.F.)
			SL1->L1_LOG := "02" // Segundo CHECKPOINT
			MsUnLock()
		EndIf
		
		_dEmissao := SL1->L1_EMISNF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava tipo de venda na nota de saida ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Conout("LJ7002 - Linha 415 - ANTES DE GRAVAR DADOS SF2")
		Conout("LJ7002 - Linha 416 - CONTEUDO _cTipoVend = "+_cTipoVend)
		
		If Empty(_cTipoVend)
			Conout("LJ7002 - Linha 419 - CONTEUDO _cTipoVend esta vazio")
		EndIf
		
		dbSelectArea("SF2")
		dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
		If dbSeek(xFilial("SF2") + _cDoc + _cSerie )
			RecLock("SF2", .F.)
			SF2->F2_TIPVND := _cTipoVend
			
			//Marcelo Alcantara 08/12
			SF2->F2_PLACA 	:= SL1->L1_PLACAV
			SF2->F2_CODCON 	:= SL1->L1_CODCON
			SF2->F2_CODMAR 	:= SL1->L1_CODMAR
			SF2->F2_CODMOD 	:= SL1->L1_CODMOD
			SF2->F2_KM 		:= SL1->L1_KM
			SF2->F2_ANO 	:= SL1->L1_ANO
			SF2->F2_ORIGEM 	:= "LOJA"
			
			// eder - aletar F2_CONDPG, conforme solicitado pelo usuario no caso de sinistro
			SF2->F2_COND  := _cCondPGx
			
			// Acerta campo valor de desconto
			If SF2->F2_VALMERC > SF2->F2_VALFAT
				SF2->F2_DESCONT := SF2->F2_VALMERC - SF2->F2_VALFAT
			EndIf
			msUnlock()
		EndIf
		Conout("LJ7002 - Linha 439 - SF2->F2_TIPVND  = "+SF2->F2_TIPVND)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualizacao da tabela de CLIENTE X VEICULO  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Verifica a existencia do veiculo
		dbSelectArea("PA7") // CLIENTE X VEICULO
		dbSetOrder(2) // PA7_FILIAL + PA7_PLACA
		If dbSeek(xFilial("PA7") + SL1->L1_PLACAV )
			// Verifica cliente
			// OBS: Nao grava Veiculo caso seja Cliente Padrao
			If SL1->L1_CLIENTE <> cCliPad .AND. PA7->(PA7_CODCLI + PA7_LOJA) != SL1->(L1_CLIENTE + L1_LOJA)
				GrvVeic(_cNum)
			EndIf
		Else
			// OBS: Nao grava Veiculo caso seja Cliente Padrao
			If SL1->L1_CLIENTE <> cCliPad
				GrvVeic("")
			Endif
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄTerceiro CHECKPOINTÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao do campo L1_LOG para garantir que a rotina foi executada neste ponto.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SL1")
		dbSetOrder(1)//	L1_FILIAL+L1_NUM
		If dbSeek(xFilial("SL1") + _cNum )
			RecLock("SL1",.F.)
			SL1->L1_LOG := "03" // Terceiro CHECKPOINT
			MsUnLock()
		EndIf
		
		
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualizacao da tabela Itens da venda        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Localiza Orçamento em SL2 para Gravar a Margem Média em SD2
		DbSelectArea("SL2")
		SL2->(DbSetOrder(1)) // L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO
		If SL2->(DbSeek(xFilial("SL2")+_cNum))
			While (xFilial("SL2")+_cNum)==SL2->(L2_FILIAL+L2_NUM)
				// Grava Margem Media em SD2
				DbSelectArea("SD2")
				SD2->(DbSetOrder(3)) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				If SD2->(DbSeek(xFilial("SD2")+SL2->L2_DOC+SL2->L2_SERIE+;
					SL1->L1_CLIENTE+SL1->L1_LOJA+SL2->L2_PRODUTO+SL2->L2_ITEM))
					
					/*
					// cPasta := 1=Acessorio / 2=Pneus / 3=Servicos
					cTipoPrd := GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+SL2->L2_PRODUTO,1,"Erro")
					cTipoPrd := Alltrim(GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cTipoPrd,1,"Erro"))
					// A=ACESSORIO, P=PNEU, S=SERVICO, R=RODA(Pega mesma Regra de Servico)
					cPasta   := iif(cTipoPrd=="A","1", iif(cTipoPrd=="P","2","3") )
					*/
					
					// Executa funcao que Retornara Margem Media e Valor de Despesa do Orcamento
					aVlrMM   := P_MargemMedia(SL2->L2_PRODUTO,SL2->L2_LOCAL,SL2->L2_QUANT,SL1->L1_TIPOVND,SL2->L2_VLRITEM)
					
					//				Begin Transaction
					// Atualiza SL2
					RecLock("SL2",.F.)
					SL2->L2_DESPMM 	:= aVlrMM[2]
					SL2->L2_CM1 	:= GetAdvFVal("SB2","B2_CM1",xFilial("SB2")+SL2->L2_PRODUTO+SL2->L2_LOCAL,1,"Erro")
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Alimenta Valor da Tabela de Preco para      ³
					//³comparacao nos relatorios.                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SL2->L2_PRCATU := MaTabPrVen(SL1->L1_CODTAB,SL2->L2_PRODUTO,SL2->L2_QUANT,SL1->L1_CLIENTE,SL1->L1_LOJA,1,SL1->L1_DTLIM)
					MsUnlock()
					
					// Grava Valores em SD2
					RecLock("SD2",.F.)
					SD2->D2_CM1 	:= SL2->L2_CM1
					SD2->D2_MM  	:= SL2->L2_MM
					SD2->D2_DESPMM 	:= SL2->L2_DESPMM
					SD2->D2_CODISS 	:= IIf(SD2->D2_ALIQISS > 0, GetMV("MV_CODISS"), SD2->D2_CODISS)
					MsUnlock()
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava Codigo de Servico na SF3 e SFT ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SD2->D2_ALIQISS > 0
						SFT->(dbSetOrder(1)) // FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
						If SFT->(dbSeek(xFilial("SFT") + "S" + SD2->(D2_SERIE + D2_DOC + D2_CLIENTE + D2_LOJA + D2_ITEM)))
							RecLock("SFT", .F.)
							SFT->FT_CODISS := GetMV("MV_CODISS")
							msUnlock()
						EndIf
						
						SF3->(dbSetOrder(1)) // F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)
						If SF3->(dbSeek(xFilial("SF3") + DtoS(SD2->D2_EMISSAO) + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_CF))
							While !SF3->(Eof()) .AND.;
								(xFilial("SD2") + DtoS(SD2->D2_EMISSAO) + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_CF ==;
								xFilial("SF3") + DtoS(SF3->F3_ENTRADA) + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA + SF3->F3_CFO)
								
								If SF3->F3_TIPO == "S"
									//Grava o codigo do ISS no item do Livro Fiscal
									RecLock("SF3", .F.)
									SF3->F3_CODISS := GetMV("MV_CODISS")
									MsUnlock()
								EndIf
								
								SF3->(DbSkip())
							End
						EndIf
					EndIf
				Endif
				
				DbSelectArea("SL2")
				DbSkip()
			EndDo
		Endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄQuarto CHECKPOINTÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao do campo L1_LOG para garantir que a rotina foi executada neste ponto.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SL1")
		dbSetOrder(1)//	L1_FILIAL+L1_NUM
		If dbSeek(xFilial("SL1") + _cNum )
			RecLock("SL1",.F.)
			SL1->L1_LOG := "04" // Quarto CHECKPOINT
			MsUnLock()
		EndIf
		
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualização das tabelas do Modulo Financeiro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Posiciona arquivo de filiais
		dbSelectArea("SLJ")
		dbSetOrder(3) //LJ_FILIAL+LJ_RPCEMP+LJ_RPCFIL
		If dbSeek(xFilial("SLJ") + cEmpAnt + cFilAnt)
			cBanco := SLJ->LJ_BCO1
		Else
			cBanco := ""
		EndIf
		
		// Verifica banco
		cBanco := IIf(!Empty(M->LQ_BCO1), M->LQ_BCO1, cBanco)
		
		// Posiciona SF2 para pegar serie do parametro MV_LJPREF
		SF2->(dbSetOrder(1))  //Filial+doc+serie
		If SF2->(dbSeek(xFilial("SF2") + _cDoc + _cSerie))
			_cSerieSE1	:= &(GETMV("MV_LJPREF"))
		EndIf
		
		// Localiza Financeiro(SE1) para Gravar dados do Banco/Agencia/Conta
		// OBS: Caso o Cliente(SA1) tenha o Banco cadastrado sera utilizado este
		//      Caso contrario pegara os dados de Banco da Loja(SLJ)
		DbSelectArea("SE1")
		DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		DbSeek(xFilial("SE1") + _cSerieSE1 + _cDoc)
		
		While !SE1->(Eof()) .And. xFilial("SE1")+ _cSerieSE1 +_cDoc == SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM  )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a data de emissao.                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE1->E1_EMISSAO <> _dEmissao
				SE1->(dbSkip())
				Loop
			EndIf
			
			RecLock("SE1",.F.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Regra para Atualizacao da Natureza em SE1.                  ³
			//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
			//³Dinheiro       --> E1_NATUREZ=MV_NATDINH (Padrao)           ³
			//³Cartao         --> E1_NATUREZ=MV_NATCART (Padrao)           ³
			//³Financeira     --> E1_NATUREZ=MV_NATFIN  (Padrao)           ³
			//³A Vista Outras --> E1_NATUREZ=FS_DEL004  (Customizado)      ³
			//³Condicoes                                                   ³
			//³A Vista Cheque --> E1_NATUREZ=FS_DEL004  (Customizado)      ³
			//³A Prazo Cheque --> E1_NATUREZ=FS_DEL005  (Customizado)      ³
			//³A Prazo Duplic --> E1_NATUREZ=FS_DEL006  (Customizado)      ³
			//³A Prazo Outras --> E1_NATUREZ=FS_DEL007  (Customizado)      ³
			//³condicoes                                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Ignora Dinheiro/Cartao/Financeira
			If !(Alltrim(SE1->E1_TIPO) $ "R$|CC|CD|FI")
				// Define se pagamento eh a Viasta ou a Prazo
				If SE1->E1_EMISSAO == SE1->E1_VENCTO
					//ÚÄÄÄÄÄÄÄÄÄ¿
					//³ A Vista ³
					//ÀÄÄÄÄÄÄÄÄÄÙ
					cNaturez := GetMv("FS_DEL004")
				Else
					//ÚÄÄÄÄÄÄÄÄÄ¿
					//³ A Prazo ³
					//ÀÄÄÄÄÄÄÄÄÄÙ
					// Cheque
					If Alltrim(SE1->E1_TIPO) == "CH"
						cNaturez := GetMv("FS_DEL005")
					Endif
					// Duplicada
					If Alltrim(SE1->E1_TIPO) == "DP"
						cNaturez := GetMv("FS_DEL006")
					Endif
					// Outras para Prazo
					If Empty(cNaturez)
						cNaturez := GetMv("FS_DEL007")
					Endif
				Endif
				// Atualiza Natureza
				SE1->E1_NATUREZ	:= cNaturez
			Endif
			
			// Grava informacao do codigo do banco
			SE1->E1_BCO1 := M->LQ_BCO1
			
			If Empty(SE1->E1_BCO1)
				Conout("LJ7002 - linha 632 Portador vazio - Titulo "+_cSerieSE1+"/"+_cDoc+" Usuário "+Substr(cUsuario,7,15)+" "+Dtoc(Date())+" "+Time())
			Else
				Conout("LJ7002 - Linha 634 Portador "+SE1->E1_BCO1+" - Titulo "+_cSerieSE1+"/"+_cDoc+" Usuário "+Substr(cUsuario,7,15)+" "+Dtoc(Date())+" "+Time())
			Endif
			
			// Inicio - Marcio Domingos 11/04/06
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava o nome do cliente, quando o titulo eh CC ou CD. Por que o RPO atual esta com nao conformidade e nao   			    ³
			//³esta gravando este campo corretamente. 																					³
			//³Apos a solucao do chamado :AAOXYI este trecho pode ser retirado do fonte. 												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Rtrim(SE1->E1_TIPO) $ "CC&CD"
				SE1->E1_NOMCLI	:= GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,1,Space(TamSX3("E1_NOMCLI")[1]))
			Endif
			MsUnlock()
			// Fim - Marcio Domingos 11/04/06
			
			dbSelectArea("SE1")
			DbSkip()
			
		EndDo
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava informacoes do sinistro e historico   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		P_DelA020D()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gera titulos no contas a receber quando     ³
		//³houver promocao nos itens sinistrados.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		P_DelA020G()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza informacoes do televendas         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SL1->L1_NUMSUA) // Orcamento originado no televendas
			P_D19AtuTlv(_cFilial, _cNum, SL1->L1_NUMSUA, 1)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza informacoes de sepu               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If M->LQ_CONDPG == GetMV("FS_DEL021") // condicao venda antecipada sobre sepu
			// Posiciona itens da venda
			dbSelectArea("SL2")
			dbSetOrder(1) //L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO
			dbSeek(xFilial("SL2") + _cNum)
			
			// Venda antecipada relacionada a sepu
			dbSelectArea("PA4")
			dbSetOrder(1) //PA4_FILIAL+PA4_SEPU
			If dbSeek(xFilial("PA4") + aPgtos[1][4][4])
				RecLock("PA4", .F.)
				PA4_FILANT := cFilAnt
				PA4_CFANT  := _cDoc
				PA4_SERANT := _cSerie
				PA4_CPRODV := SL2->L2_PRODUTO
				PA4_DPRODV := SL2->L2_DESCRI
				msUnlock()
				//				dbCommit()
			EndIf
		EndIf
		
		//		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//		//³Cria indice temporario³
		//		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//		cArq := CriaTrab(Nil,.F.)
		//		DbSelectArea("SE1")
		//		IndRegua("SE1",cArq,"E1_FILIAL+E1_NUM+E1_PREFIXO+E1_TIPO+E1_CLIENTE+E1_LOJA+DTOS(E1_VENCTO)")
		
		DbSelectArea("SL4")
		DbSetOrder(1) // L4_FILIAL+L4_NUM+L4_ORIGEM
		DbSeek(xFilial("SL4")+_cNum+_cOrigSL4)
		
		//		While !SL4->(Eof())	 .And.;
		//			SL4->L4_NUM	==	_cNum
		While !SL4->(Eof())	 .And.	SL4->(L4_FILIAL+L4_NUM+L4_ORIGEM) == xFilial("SL4")+_cNum+_cOrigSL4
			
			_cCliAdm := LEFT(SL4->L4_ADMINIS,3)
			_cCliAdm += Space(TamSx3("A1_COD")[1] - Len(_cCliAdm))
			
			// Utiliza a expressao de indice 2 para pesquisa - Pode e deve ser melhorado!! Edson . 18-01-06 - CLIENTE + LOJA + PREFIXO + NUM + PARCELA
			dbSelectArea("SE1")
			dbSetOrder(2) // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			dbSeek(xFilial("SE1")+_cCliAdm + "01" +_cSerie+_cDoc)
			While !Eof() .And. xFilial("SE1")+_cCliAdm + "01" +_cSerie+_cDoc == E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM
				If SE1->E1_TIPO == Left(SL4->L4_FORMA,TamSx3("E1_TIPO")[1]) .And. SL4->L4_DATA==SE1->E1_VENCTO
					RecLock("SE1",.F.)
					SE1->E1_NUMCART	:= SL4->L4_NUMCART
					MsUnLock()
					Exit
				EndIf
				dbSkip()
			End
			
			dbSelectArea("SL4")
			DbSkip()
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Apaga arquivo temporario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//		RetIndex("SE1")
		//		DbSetorder(1)
		//		Ferase(cArq+OrdBagExt())
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a Array com Equipe de Montagem _DELA013B foi alimentada no Lancamento ³
	//³ do Orcamento ela serah salva aqui									     ³
	//³ OBS: A equipe sera Salva independente de ser um Orcamento ou uma Venda   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Salva Equipe de Montagem
	If Len(_DELA013B) > 0
		// Apaga Equipe de Montagem se esta jah existir no PAB para este Orcamento,
		// para evitar duplicidade
		DbSelectArea("PAB")
		dbSetOrder(3) // PAB_FILIAL + PAB_ORC
		If DbSeek(xFilial("PAB")+M->LQ_NUM)
			While !(PAB->(Eof())) .and. (PAB->PAB_FILIAL+PAB->PAB_ORC == xFilial("PAB")+M->LQ_NUM)
				RecLock("PAB",.F.)
				PAB->(DbDelete())
				MsUnlock()
				
				PAB->(DbSkip())
			EndDo
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estrutura da Array _DELA013B ³
		//³ [1] := Orcamento 			 ³
		//³ [2] := Codido do Tecnico 	 ³
		//³ [3] := Nome do Tecnico   	 ³
		//³ [4] := Funcao 				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 to Len(_DELA013B)
			If !Empty(Alltrim(_DELA013B[nX,2]))
				RecLock("PAB",.T.)
				PAB->PAB_FILIAL		:= xFilial("PAB")
				PAB->PAB_ORC   		:= _DELA013B[nX,1]
				PAB->PAB_CODTEC		:= _DELA013B[nX,2]
				PAB->PAB_NOMTEC		:= _DELA013B[nX,3]
				PAB->PAB_FUNCAO		:= _DELA013B[nX,4]
				MsUnlock()
			Endif
		Next
		// Limpa Array Publica para evitar problemas no proximo orcamento
		_DELA013B := {}
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A variavel _DELA013A foi criada no P.E. LJ7016 e alimentada no DELA013A  ³
		//³ ela indica que a Tela de Equipe de montagem foi acionada. Foi feito assim³
		//³ para evitar exclusao de uma Equipe quando a Tela nao fosse aberta.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If _DELA013A == .T.
			// Apaga Equipe de Montagem se esta jah existir no PAB para este Orcamento,
			// e _DELA013B estiver vazia
			DbSelectArea("PAB")
			dbSetOrder(3) // PAB_FILIAL + PAB_ORC
			If DbSeek(xFilial("PAB")+M->LQ_NUM)
				While !(PAB->(Eof())) .and. (PAB->PAB_FILIAL+PAB->PAB_ORC == xFilial("PAB")+M->LQ_NUM)
					RecLock("PAB",.F.)
					PAB->(DbDelete())
					MsUnlock()
					PAB->(DbSkip())
				EndDo
			Endif
		Endif
	Endif
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Acrescentado por marcelo para verificar se o tipo de venda esta sendo gravado corretamente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ParamIxb[1] == 2 // Verifica se o Campo SD2_TIPVND foi gravado
		dbSelectArea("SF2")
		dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
		If dbSeek(xFilial("SF2") + _cDoc + _cSerie)
			If Empty(SF2->F2_TIPVND)	// Se nao estiver gravado, Gravar novamente.
				RecLock("SF2", .F.)
				SF2->F2_TIPVND := _cTipoVend
				MsUnLock()
			EndIf
		EndIf
		Conout("LJ7002 - Linha 821 - SF2->F2_TIPVND  = "+SF2->F2_TIPVND)
	EndIf
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄUltimo CHECKPOINTÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao do campo L1_LOG para garantir que a rotina foi executada neste ponto.       ³
	//³                                                                                      ³
	//³ I M P O R T A N T E   :                                                              ³
	//³ Obrigatoriamente, este checkpoint tem que ser a ultima tarefa executada pelo P.E.    ³
	//³ LJ7002.PRW                                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SL1")
	dbSetOrder(1)//	L1_FILIAL+L1_NUM
	If dbSeek(xFilial("SL1") + _cNum )
		RecLock("SL1",.F.)
		SL1->L1_LOG := "OK" // Ultimo CHECKPOINT
		MsUnLock()
	EndIf
	
	if ParamIxb[1] == 2 .AND. SM0->M0_CODFIL $ "04*48*52*18"
		U_DVLOJF09()
	Endif
EndIf


Conout("LJ7002 - Saindo do ponto de entrada")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variavel publica inicalizada no ponto LJ0016³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cD020CPG	:=	""

RestArea(aAreaPA4)
RestArea(aAreaPA7)
RestArea(aAreaPAB)
RestArea(aAreaSB2)
RestArea(aAreaSC0)
RestArea(aAreaSD2)
RestArea(aAreaSE1)
RestArea(aAreaSF2)
RestArea(aAreaSF3)
RestArea(aAreaSFT)
RestArea(aAreaSL1)
RestArea(aAreaSL2)
RestArea(aAreaSL4)
RestArea(aAreaSLJ)
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvVeic   ºAutor  ³Paulo Benedet       º Data ³  10/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravar amarracao cliente x veiculo                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Personalizado della Via                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam     ³ cNumOrc - Numero do orcamento de transferencia             º±±
±±º          ³ No caso de transferencia, o PA7 deve estar posicionado.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvVeic(cNumOrc)

// Atualiza o registro do veiculo
If !Empty(cNumOrc)
	RecLock("PA7", .F.)
	PA7_ORCTRF := cFilAnt + cNumOrc
	PA7_DTTRF  := dDataBase
	msUnlock()
EndIf

// Inclui novo registro
RecLock("PA7", .T.)
PA7_FILIAL := xFilial("PA7")
PA7_CODCLI := SL1->L1_CLIENTE
PA7_LOJA   := SL1->L1_LOJA
PA7_PLACA  := SL1->L1_PLACAV
PA7_ANO    := SL1->L1_ANO
PA7_CODMAR := SL1->L1_CODMAR
PA7_CODMOD := SL1->L1_CODMOD
PA7_OBSERV := SL1->L1_OBSVEIC
MsUnLock()

Return



// Eder - Rotina para baixa automatica de cheque a vista.
Static Function BXCHQAV
Local _aVetor
Local _aArea1 := GetArea()
Local _aArea2 := SE1->(GetArea())
Local _nPos
Local _cQ

SE1->(DBGOTOP())
SE1->(dbSkip())

//reposiciona SL1, caso precise
If SL1->L1_NUM<>M->LQ_NUM
	dbSelectArea("SL1")
	dbSetOrder(1) // L1_FILIAL+L1_NUM
	dbSeek(xFilial("SL1") + M->LQ_NUM)
Endif

If Empty(SL1->L1_DOC)
	Return
Endif

// busca titulos da venda
_cQ := "SELECT SE1.R_E_C_N_O_ NUMREG FROM "+RETSQLNAME("SE1")+" SE1, "+RETSQLNAME("SF2")+" SF2"
_cQ += " WHERE F2_FILIAL='"+SL1->L1_FILIAL+"' AND F2_DOC='"+SL1->L1_DOC+"' AND F2_SERIE='"+SL1->L1_SERIE+"'"
_cQ += " AND E1_FILIAL='"+XFILIAL("SE1")+"' AND E1_NUM=F2_DUPL AND E1_PREFIXO=F2_PREFIXO AND E1_TIPO='CH'"
_cQ += " AND E1_SALDO>0 AND E1_VENCTO='"+DTOS(SL1->L1_EMISNF)+"'"
_cQ += " AND SF2.D_E_L_E_T_=' ' AND SE1.D_E_L_E_T_=' '"
TCQuery _cQ New Alias "_E1"

Do While !_E1->(EoF())
	SE1->(dbGoTo(_E1->NUMREG))
	reclock("SE1")
	_aVetor := {}
	AADD(_avetor , {"E1_PREFIXO"	 , SE1->E1_PREFIXO	, NIL})
	AADD(_avetor , {"E1_NUM"		 , SE1->E1_NUM		, NIL})
	AADD(_avetor , {"E1_PARCELA"	 , SE1->E1_PARCELA	, NIL})
	AADD(_avetor , {"E1_TIPO"	 , SE1->E1_TIPO		, NIL})
	AADD(_avetor , {"E1_CLIENTE"	 , SE1->E1_CLIENTE	, NIL})
	AADD(_avetor , {"E1_LOJA"   	 , SE1->E1_LOJA		, NIL})
	AADD(_avetor , {"AUTMOTBX"    , "NORMAL"	   	, NIL})
	AADD(_avetor , {"E1_PORTADO"  , " " 	, NIL})  // BANCO, AGENCIA E CONTA SAO VERIFICADOS NO P.E. OM010PRC
	AADD(_avetor , {"E1_AGEDEP"   , " "  	, NIL})
	AADD(_avetor , {"E1_CONTA"    , " " 	, NIL})
	AADD(_avetor , {"AUTDTBAIXA"  , dDataBase   	, NIL})
	AADD(_avetor , {"AUTDTCREDITO", dDataBase	, NIL})
	AADD(_avetor , {"AUTHIST"	 , "CHEQUE A VISTA"    , NIL})
	AADD(_avetor , {"AUTVALREC"	 , SE1->E1_VALOR	  	, NIL})
	MSExecAuto({|x, y| FINA070(x,y)}, _avetor, 3)
	If SE1->E1_SALDO>0
		MsgAlert("Erro na baixa do cheque a vista. Favor efetuar a baixa manualmente!")
	Else
		RecLock("SE5",.f.)
		SE5->E5_MOEDA := "CH"
		SE5->(MSUnlock())
	Endif
	SE1->(MSUNLOCK())
	_E1->(dbSkip())
Enddo
_E1->(dbCloseArea())
SE1->(RestArea(_aArea2))
RestArea(_aArea1)

Return
