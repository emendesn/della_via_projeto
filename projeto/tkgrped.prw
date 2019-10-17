#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TKGRPED  ºAutor  ³Paulo Benedet          º Data ³  24/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Nao se aplica                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nLiquido - Valor liquido da operacao                          º±±
±±º          ³ aParcelas - Array com as parcelas de pagamento                º±±
±±º          ³ cOper - Tipo de operacao                                      º±±
±±º          ³ cNumSUA - Numero do atendimento televendas                    º±±
±±º          ³ cCodLig - Ocorrencia                                          º±±
±±º          ³ cCodPagto - Condicao de pagamento                             º±±
±±º          ³ cOpFat - Operacao definida no parametro MV_OPFAT              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet - .T. - Confirma gravacao                                º±±
±±º          ³        .F. - Nao confirma gravacao                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Ponto de entrada executado apos confirmacao do atendimento    º±±
±±º          ³ televendas e antes da gravacao dos arquivos.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista       ³ Data   ³Bops ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPaulo Benedet  ³24/05/05³     ³Validar atendimento com o posto de venda.  º±±
±±º               ³        ³     ³                                           º±±
±±ºNorbert W. Jr. ³29/09/05³     ³Validar Tp.Operacao X Tabela de precos.    º±±
±±º               ³        ³     ³                                           º±±
±±ºMarcelo Gaspar ³07/03/06³     ³Validacao para Doacao                      º±±
±±º               ³        ³     ³                                           º±±
±±ºMarcio Domingos³22/05/06³     ³Paleativo para correção de NC dos campos   º±±
±±º               ³        ³     ³UserLgi e UserLga com WebService           º±±
±±º               ³        ³     ³                                           º±±
±±ºMarcio Domingos³26/05/06³     ³Validações do CFOP criadas pelo analista   º±±
±±º               ³        ³     ³Geraldo Sabino (mesma regra utilizada no   º±±
±±º               ³        ³     ³Modulo Faturamento).                       º±±
±±º               ³        ³     ³                                           º±±
±±ºMarcio Domingos³07/08/06³     ³Valida regra para geracao do Pedido        º±±
±±º               ³        ³     ³Não gerar pedido para cliente Pessoa Fisicaº±±
±±º               ³        ³     ³e Tipo consumidor final.	                 º±±
±±º               ³        ³     ³                                           º±±
±±ºMarcio Domingos³01/10/06³     ³Validacao para não permitir que usuário elte±±
±±º               ³        ³     ³re a loja de destino.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                                      

User Function TKGRPED(nLiquido,aParcelas,cOper,cNumSUA,cCodLig,cCodPagto,cOpFat)
	Local aEstIni 		:= GetArea()
	Local aEstSAE 		:= SAE->(GetArea())
	Local aEstSL1 		:= SL1->(GetArea())
	Local aEstSM0 		:= SM0->(GetArea())
	Local aEstSUA 		:= SUA->(GetArea())
	Local aEstSB2 		:= SB2->(GetArea())
	Local aEstSA1 		:= SA1->(GetArea())
	Local aEstSX2 		:= SX2->(GetArea())
	Local aEstSF4 		:= SF4->(GetArea())
	Local lRet 			:= .T.                                                                   
	Local _nPosProduto 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_PRODUTO") })
	Local _nPosQuant 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_QUANT") })
	Local _nPosLocal 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_LOCAL") })
	Local _nPosTes	 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_TES") })
	Local _nPosTpOp 	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_OPER") })
	Local _nPosDel		:= Len(aHeader)+1
	Local _n			:= 1                        
	Local _aMsg			:= {}
	Local _cMsg			:= ""
	Local cFormCRD 		:= SuperGetMv("MV_FORMCRD",,"CH/FI") //Formas de pagamento aceitas para analise de credito do SIGACRD
	Local cTpOpDoa		:= AllTrim(GetMv("FS_DEL038")) //Tipo de operacao utilizado para doacoes
	Local cTabDoa  		:= AllTrim(GetMv("FS_DEL048")) //Tabela de preco de doacoes
	Local nTotPar  		:= 0 //Numero de linhas do array aParcelas
	Local aAdmFin  		:= {} //Array onde cada elemento indica se administradora eh private label
	Local cCrdAval 		:= GetMV("MV_CRDAVAL") //Operacoes que acionam o sigacrd
	Local cCrdOper 		:= "" //Operacoes que acionam o sigacrd traduzidas para o call center
	Local cLojSUA       := ""
	Local i
	Local _lFatura		:= .T.	
	Local _nItens       := 0   // No total de itens do atendimento
	Local _cDoacaoC     := ""  // Identifica se o convenio permite doacao (S/N)
	Local _c                 
	Local _cNumOld		:= ""
	Local _cNumNew		:= ""
	Local _nNumNew		:= 0
	Local nTotCol       := Len(aCols)
	Local npTes         := gdFieldPos("UB_TES")
	
	Conout("TKGRPED - ************ INICIO *************")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajuste da variavel lTesTit para operacao sem financeiro ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lTesTit := .F.
	SF4->(dbSetOrder(1)) // F4_FILIAL+F4_CODIGO
	
	For i := 1 to nTotCol
		If aTail(aCols[i])
			Loop
		EndIf
		
		SF4->(dbSeek(xFilial("SF4") + aCols[i][npTes]))
		
		If SF4->F4_DUPLIC == "S"
			lTesTit := .T.
			Exit
		EndIf
	Next i
	
	If lProspect .And. cOper == "1"
		If !lTk271Auto
			MsgAlert("Nao e permitido faturar para um cliente prospect !", "Aviso")
		EndIf
		lRet := .F.
	Endif	

	If lRet
		If AllTrim(M->UA_TABELA) == cTabDoa //Verifica a partir da tabela de precos
			For i :=1  to Len(aCols) //Percorre aCols, validando Tipos de Operacao
				If !aTail(aCols[i]) .And. (AllTrim(aCols[i][_nPosTpOp]) != cTpOpDoa)
					lRet := .F.
					If !lTk271Auto
						ApMsgStop("Não é permitido utilizar tipos de operação diferente de doação. A tabela de "+;
						"preços utilizada requer que todos os itens utilizem o tipo de operação " + cTpOpDoa+"."+;
						CRLF+"Parâmetros: FS_DEL038 | FS_DEL048","Tipo de operação inválido")
					EndIf
					Exit
				EndIf
			Next i
		EndIf

		If lRet //Verifica a partir dos itens
			//Verifica se existem items de doacao com a tabela de precos incorreta
			If (AllTrim(M->UA_TABELA) != cTabDoa) .And. (aScan(aCols,{|x| ( (x[_nPosTpOp] == cTpOpDoa) .And. !x[_nPosDel]) }) != 0 )
				lRet := .F.
				If !lTk271Auto
					ApMsgStop("Para utilizar o tipo de operação de Doação, deve-se utilizar a tabela de preços "+;
					"referente à doações, sendo que todos o itens devem utilizar o mesmo tipo de operação"+;
					CRLF+"Parâmetros: FS_DEL038 | FS_DEL048","Tipo de operação inválido")			
				EndIf
			EndIf
		EndIf
	EndIf

	If lRet
		If AllTrim(M->UA_TABELA) == cTabDoa //  Verifica se eh doacao
			// Verifica se a doacao tem mais de um item.
			For i := 1 To Len(aCols) // Conta numero de itens não deletados no aCols
				If !aCols[i][_nPosDel]
					_nItens++
				Endif
			Next i
	
			For i :=1  to Len(aCols)
				If aCols[i][_nPosTpOp] == cTpOpDoa .And. !aCols[i][_nPosDel]
					If _nItens > 1
						lRet := .F.
						If !lTk271Auto
							ApMsgStop("Não é permitido mais de 1(um) item para NF de doação." +;
							CRLF+"Parâmetros: FS_DEL038 | FS_DEL048","No de itens inválido")
						EndIf
						Exit                                                                            
					EndIf
				EndIf
			Next i
		
			// Verifica se o convenio selecionado permite doacao.
	 	    If !Empty(M->UA_CODCON) // Verifica se foi preenchido o Codigo de convenio
				_cDoacaoC := GetAdvFVal("PA6","PA6_DOACAO",xFilial("PA6")+M->UA_CODCON,1,"Erro")

		   	   If Upper(AllTrim(_cDoacaoC)) <> "S"
					lRet := .F.
					If !lTk271Auto
					    ApMsgStop("O Convênio selecionado não permite doação." ,"Cadastro de Convênio")
					EndIf
		       EndIf
		    EndIf
		EndIf
	EndIf


	// Verifica tipo de atendimento com o posto de venda
	If lRet .And. !Empty(M->UA_LOJASL1) // Varejo
		If cOper == "1" // Faturamento
			If !lTk271Auto
				MsgAlert("Operacao invalida!", "Aviso")
			EndIf
			lRet := .F.
		ElseIf cOper == "2" // Orcamento
			If Empty(M->UA_LOJASL1) .Or. !ExistCpo("SM0", "01" + M->UA_LOJASL1)
				If !lTk271Auto
					MsgAlert("Loja destino invalida!", "Aviso")
				EndIf
				lRet := .F.
			Else	
				// Verifica o tipo da tabela SUA
				SX2->(dbSetOrder(1))
				SX2->(dbSeek("SUA"))
				cLojSUA := IIf(SX2->X2_MODO == "E", cFilAnt, Space(2))
				
				// Verifica se orcamento foi alterado pela loja
				dbSelectArea("SL1")
				dbOrderNickName("SL1_FS1") //L1_FILIAL+L1_NUMSUA+L1_LOJSUA
				If dbSeek(M->UA_LOJASL1 + cNumSUA + cLojSUA)
					If !Empty(SL1->L1_CONFVEN)
						If !lTk271Auto
							MsgAlert(OemtoAnsi("O orçamento já foi alterado pela loja! As alterações não serão gravadas."), "Aviso")
						EndIf
						RestArea(aEstSL1)
						RestArea(aEstSM0)
						RestArea(aEstSF4)
						RestArea(aEstIni)
						Return(.F.)
					EndIf
				EndIf
				
				// Busca descricao da loja
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbSeek("01" + M->UA_LOJASL1)
				
				If !lTk271Auto
					If !MsgYesNo("Confirma loja " + rTrim(SM0->M0_NOME) + "?", "Pergunta")
						lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	//Em testes
	If lRet 
		SUA->(DbSetOrder(1)) //UA_FILIAL+UA_NUM
    
		// Se for alteracao
		If SUA->(DbSeek(xFilial("SUA")+M->UA_NUM))
			If M->UA_LOJASL1 != SUA->UA_LOJASL1
				// Busca orcamento sigaloja
				dbSelectArea("SL1")
				dbOrderNickName("SL1_FS1") //L1_FILIAL+L1_NUMSUA
				If dbSeek(SUA->(UA_LOJASL1 + UA_NUM))
					P_ApagaReser(SL1->L1_FILIAL, SL1->L1_NUM)
				EndIf
			
				// Chama funcao para apagar orcamentos gerados no sigaloja
				P_D19ApagaLoja(M->UA_NUM)
			EndIf
		EndIf
	
		//Marcio
		If cOper == "1" // Faturamento
			DbSelectArea("SB2")
			DbSetOrder(1)
			DbSelectArea("SF4")
			DbSetorder(1)

			For _n := 1 to Len(aCols)                          
				IF !aCols[_n,Len(aHeader)+1]
					DbSelectArea("SF4")		
					If DbSeek(xFilial("SF4")+aCols[_n][_nPosTes]) .And. SF4->F4_ESTOQUE == 'S' // Verifica se a TES atualiza estoque
						DbSelectArea("SB2")	
						If DbSeek(xFilial("SB2")+aCols[_n][_nPosProduto]+aCols[_n][_nPosLocal]) 
							If aCols[_n][_nPosQuant] >	SaldoSb2() // Verifica se a qtde vendida é maior que a disponível
								aadd(_aMsg,{aCols[_n][_nPosProduto],aCols[_n][_nPosLocal],aCols[_n][_nPosQuant],SB2->B2_QATU})
							Endif
						Else					                                                                               
							aadd(_aMsg,{aCols[_n][_nPosProduto],aCols[_n][_nPosLocal],aCols[_n][_nPosQuant],0})
						Endif	
					Endif	
				Endif	
			Next			

			If Len(_aMsg) > 0
				_cMsg	:= "Produto(s) sem Saldo Disponivel : "+Chr(10)
				For _n := 1 to Len(_aMsg)
					_cMsg	+= Rtrim(_aMsg[_n][1])+" "+Posicione("SB1",1,xFilial("SB1")+_aMsg[_n][1],"B1_DESC")+Chr(10)		
					_cMsg	+= "Verifique o armazem (local)!"
				Next	
				If !lTk271Auto
					MsgAlert(_cMsg,"Aviso")
				EndIf
				lRet := .F.
			Endif	                                                
		Endif	
		// Marcio
	EndIf                                                 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Marcelo Alcantara 04/09/2005                                ³
	//³Bloqueia Atendimento para cliente padrao se for faturamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (M->UA_CLIENTE == GetMV("MV_CLIPAD"); // Venda para cliente padrao
		.And. M->UA_LOJA  == GetMV("MV_LOJAPAD");
		.And. cOper == "1" ) //Se For Faturamento
		If !lTk271Auto
			MsgAlert(OemtoAnsi("Não é permitida a gravar o atendimento para cliente padrão. Favor informar um cliente cadastrado."), "Aviso")
		EndIf
		lRet := .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Marcelo Alcantara - 19/12/05 								          ³
	//³ Valida se o vendedor podera finazilar a venda segungo campo A3_FATURA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cOper == "1" //Se For Faturamento
		_lFatura:= (Posicione("SA3",1,XFILIAL("SA3")+M->UA_VEND,"A3_FATURA") <> "N")
		If .Not. _lFatura 
			If !lTk271Auto
				Aviso("Aviso","Nao e possivel Finalizar o Atendimento como Faturamento para esse vendedor, favor trocar o vendedor!! ",{"Ok"})			
			EndIf
			lRet := .F.
		EndIf			
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificar se cliente esta vazio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(M->UA_CLIENTE) .Or. Empty(M->UA_LOJA)
		lRet := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exigir administradora financeira do tipo "private label" qdo ³
	//³ a forma precisar de analise de credito                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotPar := Len(aParcelas)

	If "21" $ cCrdAval
		cCrdOper += "2"
	EndIf

	If "22" $ cCrdAval
		cCrdOper += "1"
	EndIf

	For i := 1 to nTotPar
		If rTrim(aParcelas[i][3]) $ cFormCRD;
			.And. rTrim(aParcelas[i][3]) <> "CH";
			.And. cOper $ cCrdOper
			
			dbSelectArea("SAE")
			dbSetOrder(1) //AE_FILIAL+AE_COD
			If dbSeek(xFilial("SAE") + Left(aParcelas[i][4], TamSX3("AE_COD")[1]))
				If SAE->AE_PLABEL <> "1"
					aAdd(aAdmFin, 0)
				Else
					aAdd(aAdmFin, 1)
				EndIf
			Else
				aAdd(aAdmFin, 0)
			EndIf
		EndIf
	Next i

	If aScan(aAdmFin, 0) > 0
		If !lTk271Auto
			MsgAlert("Informar uma administradora do tipo Private Label!", "Aviso")
		EndIf
		lRet := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Marcio Domingos
	//³Correção de não conformidade dos campos UserLGI e UserLGA com WS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

	If cOper == "1" .And. GetMv("MV_USERWS") .And. Empty(Mv_Par38) // Faturamento            
		DbSelectArea("SA1")
		DbSetOrder(1)
	
		DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA)
		Mv_Par38	:= SA1->A1_USERLGI
		Mv_Par39	:= SA1->A1_USERLGA
		
		RecLock("SA1",.F.)            
		SA1->A1_USERLGI	:= ""
		SA1->A1_USERLGA	:= ""
		MsUnlock()
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Marcio Domingos
	//³Validações do CFOP criadas pelo analista Geraldo                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

	If cOper == "1" // Faturamento
		nPosTES := Ascan(aHeader,{ |x| Alltrim(x[2])=="UB_TES"})
		nPosCFO := Ascan(aHeader,{ |x| Alltrim(x[2])=="UB_CF"})
	
		_cMsg:=""
		_lret:=.T.       
		
		For _c:=1 to Len(aCols)
			If !aCols[_c,Len(aHeader)+1]
				dBselectarea("SF4")
				dBsetorder(1)
				IF dBseek(xFilial("SF4")+aCols[_c][nPosTES])
				
					If SF4->F4_MSBLQL	= "1"                                                             
						_cMsg:=_cMsg + "TES "+aCols[_c][nPosTES]+" bloqueada !"+Chr(13)+Chr(10)
						_lRet := .F.
					Endif	
				
					If aCols[_c][nPosCFO] # "6108"  // Venda para cliente não contribuinte fora do estado
						IF !Substr(aCols[_c][nPosCFO],2,3) = Substr(SF4->F4_CF,2,3)
							_cMsg:=_cMsg + "CFOP Divergente do Pedido de Venda com o TES "+Chr(13)+Chr(10)
							_lRet:=.F.
						Endif
					Endif	
				
					_cDig:=" "
		
					dBselectarea("SA1")
					dBsetOrder(1)
					dBseek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA)
					If SA1->A1_EST == SM0->M0_ESTENT
						_cDig:="5"
					Else
						_cDig:="6"
					ENDIF
		
				
					IF !Substr(aCols[_c][nPosCFO],1,1) = _cDig
						_cMsg:=_cMsg + "Digito Inicial do CFOP (Dentro ou Fora do Estado) esta Invalido !!!  "+Chr(13)+Chr(10)
						_lret:=.F.
					Endif
				
					dBselectarea("SX5")
					dBsetorder(1)
					IF !dbseek(xFilial("SX5")+"13"+Substr(aCols[_c][nPosCFO],1,4)+Spac(2))
						_cMsg:=_cMsg + "Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
						_lret:=.F.
					Endif
		
				Endif
			
			Endif
		
		Next
	
		IF !_lret
			If !lTk271Auto
				MSGSTOP(_cMsg)    
			EndIf
			lRet := _lRet
		Endif                      
		
	Endif                                      

	////////////////////////////////////////////////////////////////
	// Marcio Domingos - 01/11/06                                 //
	//                                                            //
	// Tratamento para evitar erro de chave duplicada na SUA      //
	////////////////////////////////////////////////////////////////
	If Inclui
		Conout("TKGRPED - Linha 460 - Inclusão do Atendimento "+M->UA_NUM+" "+Substr(cUsuario,7,15))
	
		_nNumNew := 0
		_cNumOld := M->UA_NUM	
	
		DbSelectArea("SUA")             
		DbSetOrder(1)                     
		_cFiltro := DbFilter()
	
		If !Empty(_cFiltro) 
			Conout("TKGRPED - Linha 471 - Atendimento :"+M->UA_NUM+" "+Substr(cUsuario,7,15)+" Filtro:"+_cFiltro)
			Set Filter to 
		Endif	

		If !DbSeek(xFilial("SUA")+M->UA_NUM)
			Conout("TKGRPED - Linha 479 - Antes do FKCOMMIT / Atendimento NÃO encontrado na SUA ! "+M->UA_NUM)
			
			FkCommit() // Commit para Integridade Referencial do SUA.
			
			If !DbSeek(xFilial("SUA")+M->UA_NUM)                                                              
				Conout("TKGRPED - Linha 484 - Depois do FKCOMMIT / Atendimento NÃO encontrado na SUA ! "+M->UA_NUM)
			Else
				Conout("TKGRPED - Linha 486 - Depois do FKCOMMIT / Atendimento "+M->UA_NUM+" já encontrado na SUA registro n:"+Str(Recno(),10))
			Endif	
		Endif	
	Else	
		Conout("TKGRPED - Linha 522 - Alteração do Atendimento "+M->UA_NUM+" "+Substr(cUsuario,7,15))
	Endif

	// Retorna ambiente
	RestArea(aEstSX2)
	RestArea(aEstSAE)
	RestArea(aEstSL1)
	RestArea(aEstSM0)
	RestArea(aEstSUA)
	RestArea(aEstSF4)
	RestArea(aEstSB2)
	RestArea(aEstSA1)
	RestArea(aEstIni)

	If lRet
		lRet := U_DVTMKF05()
	Endif

Return(lRet)