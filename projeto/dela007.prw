#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA007A �Autor  �Ricardo Mansano     � Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � 01-Impede alteracao do convenio com aCols preenchido       ���
���          � 02-Verifica e trava pela data de Expira��o do Convenio     ���
���          � 03-Se PA6_TRCCLI == "N" troco cliente digitado no orca-    ���
���          �    mento pelo contido em PA6_CODCLI+PA6_CODLOJA            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digita��o)                            ���
���          �        .F. (Obriga corre��o quanto ao Codigo do Convenio)  ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em LQ_CODCON                                     ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA007A()
Local lRet 		  	:= .T.
Local naCols       	:= Len(aCols)
Local nPosProduto 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"}) // GetArea
                          
	// N�o Permite alterar o Convenio se aCols estiver preenchida
	If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
		Aviso("Aten��o !!!","Cod. de Convenio n�o pode ser alterado com Itens lan�ados !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// Verifica existencia do Convenio para evitar perda de ponteiro
	PA6->(DbSetOrder(1)) //PA6_FILIAL+PA6_COD
	If !(PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON)))
		Aviso("Aten��o !!!","Conv�nio n�o Localizado !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// Verifica data de Expira��o da Tabela de Pre�os
	If !((dDataBase >= PA6->PA6_DATADE) .and. ( dDataBase <= PA6->PA6_DATATE))
		Aviso("Aten��o !!!","Conv�nio expirado !!!",{" << Voltar"},2,"Convenio !")
		lRet := .F.
	Endif
	
	// PA6_TRCCLI == S --> Permite troca de cliente 
	// PA6_TRCCLI == N --> Nao permite troca de cliente 
	// Se PA6_TRCCLI == "N" Troca cliente do Or�amento pelo vinculado ao convenio PA6_CODCLI
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA007B  �Autor  �Ricardo Mansano     � Data �  09/05/05   ���           	
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Se PA6_TRCPRO = "N" aceita somente produtos que estejam    ���
���          � na tabela de pre�o                                         ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digita��o)                            ���
���          �        .F. (Obriga digitacao de um produto em uma tabela   ���
���          �             de pre�os v�lida.)                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em LR_PRODUTO                                    ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Aviso("Aten��o !!!","Conv�nio n�o Localizado !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// PA6_TRCPRO == S --> Permite produtos fora da Tabela de Pre�o especificada
	// PA6_TRCPRO == N --> N�o permite produtos fora da Tabela de Pre�o especificada
	If (PA6->PA6_TRCPRO == "N") 
		DA1->(DbSetOrder(1)) // DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
		If !(DA1->(DbSeek(xFilial("DA1")+M->LQ_CODTAB+aCols[n,nPosProduto])))
			Aviso("Aten��o !!!","Produto fora da Tabela de pre�os especificada !!!",{" << Voltar"},2,"Tabela de Pre�os !")
			lRet := .F.
		Endif
	Endif

	P_CtrlArea(2,_aArea,_aAlias) // RestArea

Endif
	
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA007C  �Autor  �Ricardo Mansano     � Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Trata a Regra em PA6_TRCPRC                                ���
���          � Se PA6_TRCPRC = 1 N�o permite altera��o de Pre�o           ���
���          � Se PA6_TRCPRC = 2 Permite qualquer Valor                   ���
���          � Se PA6_TRCPRC = 3 Permite apenas valores maiores que tabela���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digita��o)                            ���
���          �        .F. (Obriga digitacao de valores de produto compa-  ���
���          �             tiveis com a regra do convenio.)               ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em LR_VRUNIT                                     ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Aviso("Aten��o !!!","Conv�nio n�o Localizado !!!",{" << Voltar"},2,"Convenio !")
		Return(.F.)
	Endif

	// N�o permite altera��o de Pre�os
	If PA6->PA6_TRCPRC == "1"   // 1=Fixo ; 2=Livre ; 3=Acrescimo
		// Localiza Tabela de Pre�o    
		DA1->(DbSetOrder(1)) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
		If DA1->(DbSeek(xFilial("DA1")+M->LQ_CODTAB+aCols[n,nPosProduto]))
			If aColsDet[n,nPosPrcTab] <> &(ReadVar())
				Aviso("Aten��o !!!","Conv�nio n�o permite valores diferentes da Tabela de Pre�os !!!",{" << Voltar"},2,"Convenio !")
				lRet := .F.
			Endif
		Else 
			// Caso N�o ache a Tabela impede altera��o do Pre�o
			Aviso("Aten��o !!!","Conv�nio n�o permite altera��o de Pre�os !!!",{" << Voltar"},2,"Convenio !")
			lRet := .F.
		Endif
	Endif

	// Permite apenas valores Iguais ou Maiores que os da tabela
	If PA6->PA6_TRCPRC == "3"   // 1=Fixo ; 2=Livre ; 3=Acrescimo  
		// Localiza Tabela de Pre�o    
		DA1->(DbSetOrder(1)) //DA1_FILIAL+'A1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
		If DA1->(DbSeek(xFilial("DA1")+M->LQ_CODTAB+aCols[n,nPosProduto]))
			If aColsDet[n,nPosPrcTab] > &(ReadVar())
				Aviso("Aten��o !!!","Conv�nio n�o permite valores abaixo da Tabela de Pre�os !!!",{" << Voltar"},2,"Convenio !")
				lRet := .F.
			Endif
		Else 
			// Caso N�o ache a Tabela impede altera��o do Pre�o
			Aviso("Aten��o !!!","Conv�nio n�o permite valores abaixo da Tabela de Pre�os !!!",{" << Voltar"},2,"Convenio !")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA007D  �Autor  �Ricardo Mansano     � Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � 01-Cliente n�o pode ser alterado com itens lan�ados na aCol���
���          � 02-Se PA6_TRCCLI = N permite apenas vendas para o Cliente  ���
���          � disposto no convenio PA6_CODCLI+PA6_CODLOJA                ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digita��o)                            ���
���          �        .F. (Altera LQ_CLIENTE para o correto e continua    ���
���          �             a digita��o normalmente for�ando um retorno .T.���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em LQ_CLIENTE e LQ_LOJA                          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���TI1009    �15/08/05�      �Aproveitando o local onde esta rotina eh 	  ���
���          �        �      �utilizada pego o numero do telefone do   	  ���
���          �        �      �cliente e atualizo o campo da Venda.        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	// N�o Permite alterar o Cliente e a Loja se aCols estiver preenchida
	If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
		Aviso("Aten��o !!!","Cod. de Cliente n�o pode ser alterado com Itens lan�ados !!!",{" << Voltar"},2,"Cliente !")
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
			
			Aviso("Aten��o !!!","Cliente n�o pertence ao convenio !!!",{" << Voltar"},2,"Cliente !")
			lRet := .T.

			// Limpa detalhes para evitar erros se precionado o Cancel no Cliente X Veiculos
			M->LQ_CODMAR := Space(TamSX3("LQ_CODMAR")[1])
			M->LQ_DSCMAR := ""
			M->LQ_CODMOD := Space(TamSX3("LQ_CODMOD")[1])
			M->LQ_DSCMOD := ""

		Endif
	Endif  
	
	//�����������������������������������������������������������������������������Ŀ
	//� Limpa Campo de Complemento caso Cliente seja Diferente do Padrao            �
	//�������������������������������������������������������������������������������
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
// Final da Implementa��o em 15/08/2005 por Anderson

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA007E  �Autor  �Ricardo Mansano     � Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Se PA6_TRCPRC = 1 ou 3 n�o permite digita��o de valores    ���
���          � de Desconto.                                               ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digita��o)                            ���
���          �        .F. (Desabilita campos de Desconto na venda assis-  ���
���          �             tida impedindo a digitacao.)                   ���
�������������������������������������������������������������������������͹��
���Aplicacao � When em LR_DESC e LR_VALDESC                               ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	// Se PA6_TRCPRC =  1 ou 3 n�o permite digita��o de valores de desconto
	If (PA6->PA6_TRCPRC $ "13") // 1=Fixo ; 2=Livre ; 3=Acrescimo
		lRet := .F.
	Endif
	
P_CtrlArea(2,_aArea,_aAlias) // RestArea
Return(lRet)
