#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA007A บAutor  ณRicardo Mansano     บ Data ณ  09/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ 01-Impede alteracao do convenio com aCols preenchido       บฑฑ
ฑฑบ          ณ 02-Verifica e trava pela data de Expira็ใo do Convenio     บฑฑ
ฑฑบ          ณ 03-Se PA6_TRCCLI == "N" troco cliente digitado no orca-    บฑฑ
ฑฑบ          ณ    mento pelo contido em PA6_CODCLI+PA6_CODLOJA            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Continua digita็ใo)                            บฑฑ
ฑฑบ          ณ        .F. (Obriga corre็ใo quanto ao Codigo do Convenio)  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ ValidUser em LQ_CODCON                                     บฑฑ
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
Project Function DELA007A()
Local lRet 		  	:= .T.
Local naCols       	:= Len(aCols)
Local nPosProduto 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"}) // GetArea
                          
	// Nใo Permite alterar o Convenio se aCols estiver preenchida
	If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
		Aviso("Aten็ใo !!!","Cod. de Convenio nใo pode ser alterado com Itens lan็ados !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// Verifica existencia do Convenio para evitar perda de ponteiro
	PA6->(DbSetOrder(1)) //PA6_FILIAL+PA6_COD
	If !(PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON)))
		Aviso("Aten็ใo !!!","Conv๊nio nใo Localizado !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// Verifica data de Expira็ใo da Tabela de Pre็os
	If !((dDataBase >= PA6->PA6_DATADE) .and. ( dDataBase <= PA6->PA6_DATATE))
		Aviso("Aten็ใo !!!","Conv๊nio expirado !!!",{" << Voltar"},2,"Convenio !")
		lRet := .F.
	Endif
	
	// PA6_TRCCLI == S --> Permite troca de cliente 
	// PA6_TRCCLI == N --> Nao permite troca de cliente 
	// Se PA6_TRCCLI == "N" Troca cliente do Or็amento pelo vinculado ao convenio PA6_CODCLI
	If (lRet) .and. (PA6->PA6_TRCCLI == "N") .and.;
	   (!Empty(PA6->PA6_CODCLI)) .and. (M->LQ_CLIENTE <> PA6->PA6_CODCLI)
		M->LQ_CLIENTE := PA6->PA6_CODCLI	
		M->LQ_LOJA	  := PA6->PA6_LOJA                                      
		// Refresha nome do Cliente (Campo Visual)
	   	M->LQ_NOMCLI := Posicione("SA1",1,xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,"A1_NOME")

		// Limpa detalhes para evitar erros se precionado o Cancel no Cliente X Veiculos
		M->LQ_CODMAR := Space(TamSX3("LQ_CODMAR")[1])
		M->LQ_DSCMAR := ""
		M->LQ_CODMOD := Space(TamSX3("LQ_CODMOD")[1])
		M->LQ_DSCMOD := ""
        // *** Inclusao de codigo Carlos ***
		M->LQ_PLACAV := P_D11PESQ(M->LQ_CLIENTE,M->LQ_LOJA)
		
		// Comentado pois alteramos a ordem dos Campos no Configurador
		// Executa o Gatilho do Campo
		//SX3->(dbSetOrder(2))
		//SX3->(dbSeek("LQ_CLIENTE"))
		//IF ExistTrigger("LQ_CLIENTE") 
		//	//M->L2_DESC := nDesc
		//	RunTrigger(2,n)
		//EndIf
		
	Endif
	
P_CtrlArea(2,_aArea,_aAlias) // RestArea
Return(lRet)
                                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA007B  บAutor  ณRicardo Mansano     บ Data ณ  09/05/05   บฑฑ           	
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Se PA6_TRCPRO = "N" aceita somente produtos que estejam    บฑฑ
ฑฑบ          ณ na tabela de pre็o                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Continua digita็ใo)                            บฑฑ
ฑฑบ          ณ        .F. (Obriga digitacao de um produto em uma tabela   บฑฑ
ฑฑบ          ณ             de pre็os vแlida.)                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ ValidUser em LR_PRODUTO                                    บฑฑ
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
Project Function DELA007B()
Local lRet 		  	:= .T.
Local nPosProduto 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local cGrupo 		:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[n,nPosProduto],1,"Erro")
Local lProdGenerico	:= (cGrupo == Alltrim(GetMv("FS_DEL002"))) // Parametro de Produto Generico

// Ignora regras do Convenio se for venda de um Produto Generico
If !lProdGenerico

	P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4","PA6","DA1"}) // GetArea

	// Verifica existencia do Convenio para evitar perda de ponteiro
	PA6->(DbSetOrder(1)) //PA6_FILIAL+PA6_COD
	If !(PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON)))
		Aviso("Aten็ใo !!!","Conv๊nio nใo Localizado !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// PA6_TRCPRO == S --> Permite produtos fora da Tabela de Pre็o especificada
	// PA6_TRCPRO == N --> Nใo permite produtos fora da Tabela de Pre็o especificada
	If (PA6->PA6_TRCPRO == "N") 
		DA1->(DbSetOrder(1)) // DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
		If !(DA1->(DbSeek(xFilial("DA1")+M->LQ_CODTAB+aCols[n,nPosProduto])))
			Aviso("Aten็ใo !!!","Produto fora da Tabela de pre็os especificada !!!",{" << Voltar"},2,"Tabela de Pre็os !")
			lRet := .F.
		Endif
	Endif

	P_CtrlArea(2,_aArea,_aAlias) // RestArea

Endif
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA007C  บAutor  ณRicardo Mansano     บ Data ณ  09/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Trata a Regra em PA6_TRCPRC                                บฑฑ
ฑฑบ          ณ Se PA6_TRCPRC = 1 Nใo permite altera็ใo de Pre็o           บฑฑ
ฑฑบ          ณ Se PA6_TRCPRC = 2 Permite qualquer Valor                   บฑฑ
ฑฑบ          ณ Se PA6_TRCPRC = 3 Permite apenas valores maiores que tabelaบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Continua digita็ใo)                            บฑฑ
ฑฑบ          ณ        .F. (Obriga digitacao de valores de produto compa-  บฑฑ
ฑฑบ          ณ             tiveis com a regra do convenio.)               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ ValidUser em LR_VRUNIT                                     บฑฑ
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

Project Function DELA007C()
Local lRet        	:= .T.
Local cMoeda	  	:= 1
Local cTipoPrd		:= ""
//Local cPasta		:= ""
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO"})
Local nPosLocal   	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_LOCAL"  })
Local nPosQuant   	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_QUANT"  })
Local nPosPrcTab  	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_PRCTAB" })
Local nPosVlrUnit 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_VRUNIT" })
Local nPosVlrItem 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_VLRITEM"})
Local nPosMM      	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_MM"     })
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local cGrupo 		:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[n,nPosProduto],1,"Erro")
Local lProdGenerico	:= (cGrupo == Alltrim(GetMv("FS_DEL002"))) // Parametro de Produto Generico

// Ignora regras do Convenio se for venda de um Produto Generico
If !lProdGenerico

	P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4","PA6","DA1"}) // GetArea

	// Verifica existencia do Convenio para evitar perda de ponteiro
	PA6->(DbSetOrder(1)) //PA6_FILIAL+PA6_COD
	If !(PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON)))
		Aviso("Aten็ใo !!!","Conv๊nio nใo Localizado !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// Nใo permite altera็ใo de Pre็os
	If PA6->PA6_TRCPRC == "1"   // 1=Fixo ; 2=Livre ; 3=Acrescimo
		// Localiza Tabela de Pre็o    
		DA1->(DbSetOrder(1)) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
		If DA1->(DbSeek(xFilial("DA1")+M->LQ_CODTAB+aCols[n,nPosProduto]))
			If aColsDet[n,nPosPrcTab] <> &(ReadVar())
				Aviso("Aten็ใo !!!","Conv๊nio nใo permite valores diferentes da Tabela de Pre็os !!!",{" << Voltar"},2,"Convenio !")
				lRet := .F.
			Endif
		Else 
			// Caso Nใo ache a Tabela impede altera็ใo do Pre็o
			Aviso("Aten็ใo !!!","Conv๊nio nใo permite altera็ใo de Pre็os !!!",{" << Voltar"},2,"Convenio !")
			lRet := .F.
		Endif
	Endif

	// Permite apenas valores Iguais ou Maiores que os da tabela
	If PA6->PA6_TRCPRC == "3"   // 1=Fixo ; 2=Livre ; 3=Acrescimo  
		// Localiza Tabela de Pre็o    
		DA1->(DbSetOrder(1)) //DA1_FILIAL+'A1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
		If DA1->(DbSeek(xFilial("DA1")+M->LQ_CODTAB+aCols[n,nPosProduto]))
			If aColsDet[n,nPosPrcTab] > &(ReadVar())
				Aviso("Aten็ใo !!!","Conv๊nio nใo permite valores abaixo da Tabela de Pre็os !!!",{" << Voltar"},2,"Convenio !")
				lRet := .F.
			Endif
		Else 
			// Caso Nใo ache a Tabela impede altera็ใo do Pre็o
			Aviso("Aten็ใo !!!","Conv๊nio nใo permite valores abaixo da Tabela de Pre็os !!!",{" << Voltar"},2,"Convenio !")
			lRet := .F.
		Endif                          	
	Endif
               
	// Calcula e Salva Margem Media Quando Valor Unitario for alterado
	/*
	If lRet
		// cPasta := 1=Acessorio / 2=Pneus / 3=Servicos
		cTipoPrd			:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[n,nPosProduto],1,"Erro")
		cTipoPrd		   	:= Alltrim(GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cTipoPrd,1,"Erro")) 
		// A=ACESSORIO, P=PNEU, S=SERVICO, R=RODA(Pega mesma Regra de Servico)
		cPasta := iif(cTipoPrd=="A","1", iif(cTipoPrd=="P","2","3") )
	    // Executa funcao que Retornara Margem Media e Valor de Despesa do Orcamento
	    aVlrMM := P_MargemMedia(aCols[n,nPosProduto],aColsDet[n,nPosLocal],aCols[n,nPosQuant],cPasta,M->LQ_TIPOVND,aCols[n,nPosVlrItem])                   
		aCols[n,nPosMM] 	:= aVlrMM[1]
	Endif
	*/
	
	P_CtrlArea(2,_aArea,_aAlias) // RestArea
	
Endif
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA007D  บAutor  ณRicardo Mansano     บ Data ณ  10/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ 01-Cliente nใo pode ser alterado com itens lan็ados na aColบฑฑ
ฑฑบ          ณ 02-Se PA6_TRCCLI = N permite apenas vendas para o Cliente  บฑฑ
ฑฑบ          ณ disposto no convenio PA6_CODCLI+PA6_CODLOJA                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Continua digita็ใo)                            บฑฑ
ฑฑบ          ณ        .F. (Altera LQ_CLIENTE para o correto e continua    บฑฑ
ฑฑบ          ณ             a digita็ใo normalmente for็ando um retorno .T.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ ValidUser em LQ_CLIENTE e LQ_LOJA                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบTI1009    ณ15/08/05ณ      ณAproveitando o local onde esta rotina eh 	  บฑฑ
ฑฑบ          ณ        ณ      ณutilizada pego o numero do telefone do   	  บฑฑ
ฑฑบ          ณ        ณ      ณcliente e atualizo o campo da Venda.        บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA007D()
Local lRet 		  	:= .T.
Local naCols       	:= Len(aCols)
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local _aArea   		:= {}
Local _aAreaA1		:= {}
Local _aAlias  		:= {}           
Local cCliPad		:= Padr(GetMv("MV_CLIPAD"),TamSx3("A1_COD")[1])


P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4","PA6"}) // GetArea
                          
	/*
	Permitir a alteracao do cliente
	// Nใo Permite alterar o Cliente e a Loja se aCols estiver preenchida
	If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
		Aviso("Aten็ใo !!!","Cod. de Cliente nใo pode ser alterado com Itens lan็ados !!!",{" << Voltar"},2,"Cliente !")
		Return(.F.)
	Endif
    */
    
	// PA6_TRCCLI == S (Permite troca de cl1iente)
	// PA6_TRCCLI == N (Nao permite troca de cliente)
	// Se PA6_TRCCLI == "N" deve-se respeitar o Cliente disposto em:
	// PA6_CLIENTE+PA6_LOJA  
	PA6->(DbSetOrder(1))
	PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON))
	If (PA6->PA6_TRCCLI == "N") .and. (!Empty(M->LQ_CODCON))
		If M->LQ_CLIENTE+M->LQ_LOJA <> PA6->PA6_CODCLI+PA6->PA6_LOJA
		    // Corrijo Dados do Cliente
			M->LQ_CLIENTE := PA6->PA6_CODCLI
			M->LQ_LOJA    := PA6->PA6_LOJA			
			
			Aviso("Aten็ใo !!!","Cliente nใo pertence ao convenio !!!",{" << Voltar"},2,"Cliente !")
			lRet := .T.

			// Limpa detalhes para evitar erros se precionado o Cancel no Cliente X Veiculos
			M->LQ_CODMAR := Space(TamSX3("LQ_CODMAR")[1])
			M->LQ_DSCMAR := ""
			M->LQ_CODMOD := Space(TamSX3("LQ_CODMOD")[1])
			M->LQ_DSCMOD := ""

		Endif
	Endif  
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Limpa Campo de Complemento caso Cliente seja Diferente do Padrao            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If M->LQ_CLIENTE <> cCliPad
		M->LQ_COMPL := Space(TamSx3("LQ_COMPL")[1])
	Endif
	
P_CtrlArea(2,_aArea,_aAlias) // RestArea

// Implementado por Anderson em 15/08/2005
// Colocar o numero do telefone do cadastro de clientes, SA1->A1_TEL no campo SLQ->LQ_TELEFON
IF !Empty(M->LQ_CLIENTE)

	DbSelectArea("SA1")
	_aAreaA1	:= GetArea()
	DbSetOrder(1)
	If Dbseek(xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA)
	
		// Somente se o cliente NAO FOR o cliente padrao
		If GetMV("MV_CLIPAD") == SA1->A1_COD 
			M->LQ_TELEFON	:= Space(TamSx3("LQ_TELEFON")[1])
		Else
			M->LQ_TELEFON	:= SA1->A1_TEL	
		EndIF
			
	EndIf
    RestArea(_aAreaA1)
    
EndIF
// Final da Implementa็ใo em 15/08/2005 por Anderson

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA007E  บAutor  ณRicardo Mansano     บ Data ณ  10/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Se PA6_TRCPRC = 1 ou 3 nใo permite digita็ใo de valores    บฑฑ
ฑฑบ          ณ de Desconto.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Continua digita็ใo)                            บฑฑ
ฑฑบ          ณ        .F. (Desabilita campos de Desconto na venda assis-  บฑฑ
ฑฑบ          ณ             tida impedindo a digitacao.)                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ When em LR_DESC e LR_VALDESC                               บฑฑ
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
Project Function DELA007E()
Local lRet 		  	:= .T.
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4","PA6"}) // GetArea

	// Verifica existencia do Convenio para evitar perda de ponteiro
	PA6->(DbSetOrder(1)) //PA6_FILIAL+PA6_COD
	If !(PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON)))
		Return(.F.)
	Endif

	// Se PA6_TRCPRC =  1 ou 3 nใo permite digita็ใo de valores de desconto
	If (PA6->PA6_TRCPRC $ "13") // 1=Fixo ; 2=Livre ; 3=Acrescimo
		lRet := .F.
	Endif
	
P_CtrlArea(2,_aArea,_aAlias) // RestArea
Return(lRet)
