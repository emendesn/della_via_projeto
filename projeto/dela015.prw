#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA015A  บAutor  ณRicardo Mansano     บ Data ณ  03/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza Campos da aCols, aColsDet e Rodapes               บฑฑ
ฑฑบ          ณ de acordo com Produtos ou Quantidades digitados            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_nValor := Preco Unitario do Produto                        บฑฑ
ฑฑบ          ณ_lAtuBar:= Idica se os rodapes devem ser atualizados        บฑฑ
ฑฑบ          ณ_cCond  := Condicao de pagamento utilizada                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ 01-nVlrUnit = Valor tratado pela fun็ใo P_Dela027  que     บฑฑ
ฑฑบ          ณ            o valor da tabela de pre็os em DA1 respeitando  บฑฑ
ฑฑบ          ณ            as mesmas regras do Faturamento.                บฑฑ
ฑฑบ          ณ 02-Caso ja venha preenchido o Valor Unitario o sistema     บฑฑ
ฑฑบ          ณ    Ignora a rotina de busca de preco na tabela.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Gatilho dos campos:                                        บฑฑ
ฑฑบ          ณ LR_PRODUTO      Sequencia :001  Contra Dominio : LR_VRUNIT บฑฑ
ฑฑบ          ณ LR_QUANT        Sequencia :001  Contra Dominio : LR_VRUNIT บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบNorbert   ณ23/06/05ณ      ณSubstituicao da rotina MaTabPrVen pela roti-บฑฑ
ฑฑบ          ณ        ณ      ณna P_DELA027 para calcular o preco de venda.บฑฑ
ฑฑบNorbert   ณ01/07/05ณ      ณComentado o trecho onde os descontos sao ze-บฑฑ
ฑฑบ          ณ        ณ      ณrados.                                      บฑฑ
ฑฑบNorbert   ณ11/07/05ณ      ณTratamento para produtos que nao estao ca-  บฑฑ
ฑฑบ          ณ        ณ      ณdastrados em tabela de preco.               บฑฑ
ฑฑบNorbert   ณ09/02/06ณ      ณAlteracao do calculo dos descontos. Foi uti-บฑฑ
ฑฑบ          ณ        ณ      ณlizada a mesma logica do programa Lj7VlItem,บฑฑ
ฑฑบ          ณ        ณ      ณdo padrao (LOJA701A).                    	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA015A(_nValor,_lAtuBar,cCond)

Local nX   			:= 0
Local nVlrUnit		:= 0
Local nVlrItem		:= 0
Local nVlrUnBr		:= 0
Local nVlrDesc		:= 0
Local nVlrPDesc		:= 0
Local nTot 			:= 0
Local cMoeda	  	:= 1
Local naCols		:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local cTipoPrd		:= ""
Local cCondPg  		:= ""
Local nParc			:= 0
Local nTotSeg		:= 0
Local nTotCorr		:= 0
Local nDespMM 		:= 0 
Local nValDig		:= 0
Local aVlrMM  		:= {}
Local lAtuDet		:= .F.
Local lSaidaR		:= .F.
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local nPosLocal   	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_LOCAL"   })
Local nPosQuant   	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_QUANT"   })
Local nPosVlrItem 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_VLRITEM" })
Local nPosVrUnit	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_VRUNIT"  })
Local nPosValDesc 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_VALDESC" })
Local nPosPercDesc 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_DESC"    })
Local nPosPrcTab  	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_PRCTAB"  })
Local nPosPrcAtu  	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRCATU"  })
Local nPosMM      	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_MM"      })
Local nPosTpOp		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_TPOPER"  })
Local nPosTES		:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_TES"     })
Local nPosDtBIcm	:= aPosCpoDet[05][2]				// Posicao da Base de ICM
Local nPosDtVIcm	:= aPosCpoDet[06][2]				// Posicao do Valor do ICM
Local nPosDtVIpi	:= aPosCpoDet[07][2]				// Posicao do Valor do IPI
Local nPosDtVIss 	:= aPosCpoDet[08][2]				// Posicao do Valor do ISS
Local _aArea   		:= {}
Local _aAlias  		:= {}

Default _lAtuBar	:= .T.

P_CtrlArea(1,@_aArea,@_aAlias,{"PAD"}) // GetArea 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se eh saida rapida - Norbert - 15/12/05ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lSaidaR	:= AllTrim(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[N,nPosProduto],1,"")) == AllTrim(GetMv("FS_DEL002"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava valor digitado no preco de tabela para itens de saidaณ
//ณrapida - Norbert - 15/12/05                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	AllTrim(ReadVar()) == "M->LR_VRUNIT" .AND. lSaidaR

	aCols[N,nPosPrcAtu] := &(ReadVar())  //Preco Tabela
	
EndIf

// Impede digita็ใo de Itens se Tab. de Pre็os ou Tipo de Venda estiver em branco
If (Alltrim(M->LQ_CODTAB)=="").or.(Alltrim(M->LQ_TIPOVND)=="")
	
	// Limpa produto para que usuแrio possa preencher a Tab. de Pre็os
	aCols[n,nPosProduto] := space(15)
	
	// Zera Valor para for็ar digita็ใo da Tab de Pre็os
	nVlrUnit := 0
	
	Aviso("Aten็ใo !!!","Preencha o Cod. da Tabela de Pre็os e o Tipo de Venda !!!",{" << Voltar"},2,"Tabela de Pre็os/Tipo de Venda !")
	Return(nVlrUnit)
Else
	
	// Retorna Valor Unitario respeitando as regras de Tabela de Pre็os do Cadastro de Pedidos
	// OBS: Caso _nValor ja esteja preenchido nao altera Valor Unitario
	If _nValor <> nil
		nVlrUnit := _nValor
		nVlrItem := nVlrUnit * aCols[n,nPosQuant]
		nVlrUnBr := nVlrUnit + (aCols[n,nPosValDesc]/aCols[n,nPosQuant])
	Else
		
		If lSaidaR
			nValDig := aCols[N,nPosPrcAtu]
		EndIf
		
		_nValor		:=	P_DELA027(	M->LQ_CODTAB,aCols[n,nPosProduto],aCols[n,nPosQuant],M->LQ_CLIENTE,;
									M->LQ_LOJA,cMoeda,M->LQ_DTLIM,cCond,nValDig)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณO produto pode nao ter preco cadastrado, o que retornariaณ
		//ณvalor zerado na funcao DELA027 - Norbert - 11/07/05      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If _nValor == 0
			nVlrUnit	:=	aCols[N,nPosVrUnit]
		Else
			nVlrUnit	:=	_nValor
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValor unitarioณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nVlrUnBr	:=	nVlrUnit
		nVlrItem	:= NoRound( aCols[n][nPosQuant] * nVlrUnit, nDecimais)
		
		aCols[n,nPosVlrItem]	:= nVlrItem
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCalculo do desconto quando se usa o campo LR_DESC,  ณ
		//ณLR_QUANT, ou o item esta sendo recalculado por outraณ
		//ณrotina                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (AllTrim(ReadVar()) $ "M->LR_DESC/M->LR_QUANT") .Or. P_NaPilha("P_DELA020I")

		    nVlrDesc := Round( aCols[n,nPosPercDesc] * aCols[n][nPosVlrItem] / 100, nDecimais )

	    	aCols[n][nPosValDesc] 	:= nVlrDesc
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCalculo do desconto nas demais situacoesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Else
		
			nVlrDesc			:= aCols[n,nPosValDesc]
			nVlrPDesc			:= Round( nVlrDesc * 100 / aCols[n][nPosVlrItem], TamSx3("L2_DESC")[2] )

			aCols[n][nPosPercDesc]:= nVlrPDesc
			
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAplicacao do valor de desconto ao itemณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    aCols[n][nPosVlrItem]	-= nVlrDesc
	    aCols[n][nPosVrUnit]	:= aCols[n][nPosVlrItem] / aCols[n][nPosQuant]  

	Endif

Endif

If N <= Len(aColsDet)	//Item inserido manualmente
	aColsDet[n,nPosPrcTab]   := Round(nVlrUnBr,nDecimais)
Else					//Item inserido via codigo
	lAtuDet := .T.
EndIf

//Desmarca delecao do item
If !aTail(aCols[N]) .And. MaFisFound("IT",N) .And. MaFisRet(N,"IT_DELETED")
	MaFisDel(N,.F.)
EndIf

//Refaz Detalhes
Lj7Detalhe()    

//Refaz calculo de ISS
If MaFisRet(N,"IT_BASEISS") > 0
	MaFisAlt("IT_VALISS",Round(((MaFisRet(N,"IT_BASEISS") * MaFisRet(N,"IT_ALIQISS")) / 100),nDecimais),N)
EndIf

//Se o armazem for nulo, troca por branco
If aColsDet[N][nPosLocal] == NIL
	aColsDet[N][nPosLocal] := Space(02)
EndIf

//Recalcula detalhes para itens inseridos via codigo
If lAtuDet
	aColsDet[n,nPosPrcTab]   := Round(nVlrUnBr,nDecimais)
	Lj7Detalhe()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento do TES inteligenteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If (Empty(aCols[N,nPosTpOp]) .And. !Empty(aCols[N,nPosProduto]));
	.Or. AllTrim(aColsDet[n][nPosTES]) == AllTrim(GetMV("MV_TESSAI"));
	.Or. AllTrim(aColsDet[n][nPosTES]) == AllTrim(SB1->B1_TS)
	aCols[N,nPosTpOp] := P_RetTpOp(M->LQ_CLIENTE,M->LQ_LOJA,aCols[N,nPosProduto])
	P_AltTes(.F.)
EndIf

//Preenche o campo preco de tabela no aColsDet, limpo pela Lj7Detalhe()
aColsDet[n,nPosPrcTab]   := Round(nVlrUnBr,nDecimais)

// Executa funcao que Retornara Margem Media e Valor de Despesa do Orcamento
aVlrMM := P_MargemMedia(aCols[n,nPosProduto],aColsDet[n,nPosLocal],aCols[n,nPosQuant],M->LQ_TIPOVND,aCols[n,nPosVlrItem])
aCols[n,nPosMM] 	:= aVlrMM[1]

Lj7T_SubTotal( 2, 0)

// Soma aCols nao deletados
For nX := 1 To naCols
	
	If !aCols[nX,naColsItem]
		
		If MaFisFound("IT",nX) .And. !MaFisRet(nX,"IT_DELETED")
			Lj7T_SubTotal( 2, ( Lj7T_SubTotal(2) + MaFisRet(nX, "IT_TOTAL") ))
		EndIf
		
	EndIf
	
Next nX

// Atualiza Rodapes com Totais
Lj7T_Total(2,Lj7T_SubTot(2) - Lj7T_DescV(2))

//Atualiza o texto do rodape com os dados da condicao de pagamento selecionada
If !Empty(M->LQ_TIPOVND) .And. _lAtuBar .And. !P_NaPilha("P_DELC001G")
	
	P_LjRodape(M->LQ_CONDPG)
	
EndIf

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return aCols[n][nPosVrUnit]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA015B  บAutor  ณRicardo Mansano     บ Data ณ  05/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Trava troca da Tabela de pre็o ap๓s digita็ใo dos produtos บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Continua digita็ใo)                            บฑฑ
ฑฑบ          ณ        .F. (Impede troca da Tabela de pre็os.)             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ ValidUser em LQ_CODTAB                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบMansano   ณ09/06/05ณ      ณInclusao da validacao de troca de Tabela de บฑฑ
ฑฑบ          ณ        ณ      ณpreco de acordo com a Regra no campos    	  บฑฑ
ฑฑบ          ณ        ณ      ณPA6_TRCTAB S=Sim / N=Nao.                	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA015B()
Local lRet 		  	:= .T.
Local naCols		:= Len(aCols)
Local nPosProduto 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"PA6"}) // GetArea

// Nใo Permite alterar Tabela de Pre็o se aCols estiver preenchida
If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
	Aviso("Aten็ใo !!!","Cod. da Tabela de Pre็os nใo pode ser alterada com Itens lan็ados !!!",{" << Voltar"},2,"Tabela de Pre็os !")
	lRet := .F.
Endif

// Verifica se convenio permite Troca de Tabela
// Verifica existencia do Convenio para evitar perda de ponteiro
PA6->(DbSetOrder(1)) //PA6_FILIAL+PA6_COD
If !(PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON)))
	Aviso("Aten็ใo !!!","Conv๊nio nใo Localizado !!!",{" << Voltar"},2,"Convenio !")
	lRet := .F.
Else
	If ( PA6->PA6_TRCTAB=="N" ) .and. ( PA6->PA6_TABELA<>M->LQ_CODTAB )
		Aviso("Aten็ใo !!!","Conv๊nio s๓ permite vendas na Tabela de Pre็o: "+PA6->PA6_TABELA+" !!!",{" << Voltar"},2,"Convenio !")
		lRet := .F.
	Endif
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(lRet)
