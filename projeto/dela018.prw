#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA018A  บAutor  ณRicardo Mansano     บ Data ณ  31/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Trava troca do Tipo de Venda ap๓s digita็ใo dos produtos   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Continua digita็ใo)                            บฑฑ
ฑฑบ          ณ        .F. (Impede troca do Tipo de Venda.)                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ ValidUser em LQ_TIPOVND                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA018A()
Local lRet 		  	:= .T.         
Local naCols		:= Len(aCols)
Local nPosProduto 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
	
	// Nใo Permite alterar Tabela de Pre็o se aCols estiver preenchida
	If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
		Aviso("Aten็ใo !!!","Tipo de Venda nใo pode ser alterado com Itens lan็ados !!!",{" << Voltar"},2,"Tipo de Venda !")
		lRet := .F.
	Endif
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA018B  บAutor  ณRicardo Mansano     บ Data ณ  31/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Tela com Margem Media do Orcamento.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamada atravez de um botao na tela de Venda Assistida     บฑฑ
ฑฑบ          ณ botao este que foi criado a partir do PE. LJ7016.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบGaspar    ณ08/07/05ณ      ณTratamento da chamado do Call Center pela   บฑฑ
ฑฑบ          ณ        ณ      ณfuncao TMKUSER2                             บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA018B()          
Local nX			:= 0   
Local naCols		:= Len(aCols)
Local naColsItem	:= Len(aCols[n])
Local nPosProduto 	:= 0
Local nPosLocal   	:= 0
Local nPosQuant   	:= 0
Local nPosVlrItem  	:= 0
Local cTipoPrd		:= ""
//Local cPasta		:= ""
Local aVlrMM		:= {}  
Local nCustoUnit	:= 0  
Local nVlrGeral		:= 0    
Local nMargemBruta	:= 0
// Variaveis do Calculo final da Margem 
Local nVlrItem		:= 0
Local nDespesa		:= 0
Local nCusto		:= 0 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta os dados de acordo com o Programa Executado.       ณ 
//ณ TMKA271 --> CallCenter.                                  ณ 
//ณ LOJA701 --> Venda Assistida.                             ณ 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If     Alltrim(Upper(FunName())) == "TMKA271" .Or. Alltrim(Upper(FunName())) $ "TMKUSER2" 
	nPosProduto	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_PRODUTO"})
	nPosLocal 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_LOCAL"  })
	nPosQuant   := aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_QUANT"  })
 	nPosVlrItem := aScan(aHeader   ,{ |x| AllTrim(x[2]) == "UB_VLRITEM"})
ElseIf Alltrim(Upper(FunName())) == "LOJA701"
	nPosProduto	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO"})
	nPosLocal 	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_LOCAL"  })
	nPosQuant   := aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_QUANT"  })
 	nPosVlrItem := aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_VLRITEM"})
Endif

	If Empty(aCols[n,nPosProduto])
		ApMsgAlert("Preencha os itens para calculo da Margem !!!","Margem M้dia !")
	Else                
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica de o item 01 nao esta deletado.                        ณ
		//ณpois caso soh haja uma linha prrenchida esta deve ser ignorada. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (aCols[1,naColsItem]) .and. (naCols==1)
			Aviso("Aten็ใo !!!","Deve haver pelo menos um item nใo deletado no Or็amento !!!",{" << Voltar"},2,"Margem M้dia !")
			Return .T.
		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSoma aCols nao deletados.                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nX := 1 to naCols                                
			If aCols[nX, naColsItem]
				Loop
			Endif
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Soma Valor dos Itens (Unitario x Qtd)   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nVlrItem += aCols[nX,nPosVlrItem] 
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Soma das Despesas                  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			/*
			// cPasta := 1=Acessorio / 2=Pneus / 3=Servicos
			cTipoPrd			:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[n,nPosProduto],1,"Erro")
			cTipoPrd		   	:= Alltrim(GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cTipoPrd,1,"Erro")) 
			// A=ACESSORIO, P=PNEU, S=SERVICO, R=RODA(Pega mesma Regra de Servico)
			cPasta := iif(cTipoPrd=="A","1", iif(cTipoPrd=="P","2","3") )
			*/

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Executa funcao que Retornara Margem Media e Valor de Despesa do Orcamento  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
            // OBS: Foi separada a execucao devido a Venda Assistida usar a aColsDet
			If     Alltrim(Upper(FunName())) == "TMKA271" .Or. Alltrim(Upper(FunName())) $ "TMKUSER2" 
  			    aVlrMM := P_MargemMedia(aCols[nX,nPosProduto],aCols[nX,nPosLocal],aCols[nX,nPosQuant],M->UA_TIPOVND,aCols[nX,nPosVlrItem])                   
			ElseIf Alltrim(Upper(FunName())) == "LOJA701"
			    aVlrMM := P_MargemMedia(aCols[nX,nPosProduto],aColsDet[nX,nPosLocal],aCols[nX,nPosQuant],M->LQ_TIPOVND,aCols[nX,nPosVlrItem])                   
			Endif
			nDespesa += aVlrMM[2]
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Soma Valor dos Custos (Unitario x Qtd)   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
            // OBS: Foi separada a execucao devido a Venda Assistida usar a aColsDet
			If     Alltrim(Upper(FunName())) == "TMKA271" .Or. Alltrim(Upper(FunName())) $ "TMKUSER2" 
				nCustoUnit := GetAdvFVal("SB2","B2_CM1",xFilial("SB2")+aCols[nX,nPosProduto]+aCols[nX,nPosLocal],1,"Erro")
			ElseIf Alltrim(Upper(FunName())) == "LOJA701"
				nCustoUnit := GetAdvFVal("SB2","B2_CM1",xFilial("SB2")+aCols[nX,nPosProduto]+aColsDet[nX,nPosLocal],1,"Erro")
			Endif
			nCusto += (nCustoUnit * aCols[nX,nPosQuant])
			
		Next nX                        
		// Acha a Media do Valor pela Qtd de Itens
		nMargemBruta := ((nVlrItem-nDespesa)-nCusto)
		nVlrGeral    := (nMargemBruta / nVlrItem)*100
		
		Aviso("Aten็ใo !!!","%Margem Media do Pedido"+chr(10)+chr(13)+chr(10)+chr(13) + Str(nVlrGeral,14,2)+"%",{" << Voltar"},2,"%Margem Media do Pedido !")
	Endif
	
Return .T.