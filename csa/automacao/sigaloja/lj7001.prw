#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LJ7001   � Autor �Ricardo Mansano     � Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para validacao no final da venda (antes   ���
���          � das gravacoes).                                            ���
���          � Envia como parametro o nTipo(1-orcamento/2-venda/3-pedido) ���
���          � 01 - Estorna Reserva anterior caso exista.                 ���
���          � 02 - Gera Reserva em SC0 e Alimenta B2_RESERVA em SB2.     ���
���          � 03 - Gera Reserva apenas para clientes <> MV_CLIPAD.       ���
�������������������������������������������������������������������������͹��
���Parametros� ParamIxb[1] = 1 -> Confirmacao do Orcamento                ���
���          � ParamIxb[1] = 2 -> Confirmacao da Venda                    ���
���          � ParamIxb[1] = 3 -> Confirmacao do Pedido                   ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Confirma a gravacao)                           ���
���          �        .F. (Nao confirma a gravacao)                       ���
�������������������������������������������������������������������������͹��
���Aplicacao � P.E. na confirmacao da tela de Venda Assistida (Loja701C)  ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���Benedet   �02/06/05�      �Verificar se existem produtos seguros 	  ���
���          �        �      �sem produto pai dentro do acols.      	  ���
���Benedet   �09/06/05�      �Validar venda antecipada relacionada a SEPU.���
���Norbert   �10/06/05�      �Validar sinistros da venda a ser gravada    ���
���Gaspar    �20/07/05�      �Nao pode finalizar venda para cliente padrao���
���          �        �      �Solicitado por Rodrigo.               	  ���
���Norbert   �02/08/05�      �Validacao dos Tipos de Operacao da venda    ���
���Benedet   �15/08/05�      �Validacao da tela de montagem que deve      ���
���          �        �      �existir so quando existirem servicos.       ���
���Norbert   �28/09/05�      �Validacao da quantidade de seguros/pneu.    ���
���Norbert   �16/02/06�      �Validacao dos CFOP's utilizados na venda.   ���
���Marcio Dom�03/03/06�      �Nao deve validar os CFOP's, no recebimento  ���
���          �        �      �de titulos.                                 ���
���Marcio Dom�11/07/06�      �Validacao dos CFOP's utilizados na venda.   ���
���          �        �      �Verifica se o CFOP existe na tabela 13 e se ���
���          �        �      �� o mesmo configurado na TES, tamb�m valida ���
���          �        �      �o digito Inicial do CFOP (Dentro ou Fora do ��� 
���          �        �      �Estado.									  ���	
���Marcio Dom�25/08/06�      �Regras para Impressao de Cupom e Nota Fiscal���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	//����������������������Ŀ
	//� Inicializa variaveis �
	//������������������������
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
				MsgAlert(OemtoAnsi("Venda relacionada ao SEPU s� pode ter um item!"), "Aviso")
				lRet := .F.
			EndIf
		EndIf
	Next i
	
	//��������������������������������������������������Ŀ
	//�Validacao dos CFOP's utilizados na venda - Norbert�
	//����������������������������������������������������
	
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
	
				ApMsgAlert("CFOP inv�lido para o item " + StrZero(i,2) +;
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
	MsgAlert(OemtoAnsi("N�o � permitida a venda com as formas de pagamento ";
	+ AllTrim(GetMV("MV_FORMCRD")) + " para cliente padr�o."), "Aviso")
	lRet := .F.
	Exit
	EndIf
	Next i
	
	If lPrdSeg // Venda de seguro para cliente padrao
	MsgAlert(OemtoAnsi("N�o � permitida a venda de seguro para cliente padr�o!"), "Aviso")
	lRet := .F.
	EndIf
	EndIf
	*/
	
	// Marcelo Gaspar - 20/07/05
	If (M->LQ_CLIENTE   	 == GetMV("MV_CLIPAD"); // Venda para cliente padrao
		.And. M->LQ_LOJA  == GetMV("MV_LOJAPAD");
		.And. ParamIxb[1] == 2 ) .And. !lRecebe
		
		MsgAlert(OemtoAnsi("N�o � permitida a venda para cliente padr�o. Favor informar um cliente cadastrado."), "Aviso")
		lRet := .F.
		
	EndIf
	
	If Len(cPrdOrf) > 0 // Se ha produtos orfaos mostra mensagem
		cPrdOrf := Left(cPrdOrf, Len(cPrdOrf) - 2)
		MsgAlert(OemtoAnsi("Os seguintes itens est�o sem produto pai: " + cPrdOrf), "Aviso")
		lRet := .F.
	EndIf
	
	If lSegVinc
		
		//Avalia seguros
		aSort(aSeguros)
		
		For nPos := 1 to Len(aSeguros)
			
			If aSeguros[nPos][3] > aCols[Val(aSeguros[nPos][1])][aScan(aHeader, {|x| rTrim(x[2]) == "LR_QUANT"})]
				lRet := .F.
				MsgAlert("O conv�nio atual n�o permite mais de um seguro por pneu. Verifique o item '"+aSeguros[nPos][1]+"'","Seguros")
				Exit
			EndIf
			
		Next nPos
		
	EndIf
	
	If M->LQ_CONDPG == GetMV("FS_DEL021"); // condicao venda antecipada sobre sepu
		.And. lRet
		If nItmAtv > 1 // vda antecipada so pode ter um item
			MsgAlert(OemtoAnsi("Esta venda s� pode ter um item, porque est� relacionada ao SEPU!"), "Aviso")
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
	
	//���������������������������������������������������Ŀ
	//� Verifica se tela de montagem pode ter informacoes �
	//�����������������������������������������������������
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
				MsgAlert(OemtoAnsi("Favor apagar a tela de montagem porque n�o h� servi�os no or�amento!"), "Aviso")
				lRet := .F.
			EndIf
		Else // Nao entrou na tela de equipe de montagem
			dbSelectArea("PAB")
			dbSetOrder(3) // PAB_FILIAL + PAB_ORC
			If dbSeek(xFilial("PAB") + M->LQ_NUM)
				MsgAlert(OemtoAnsi("Favor apagar a tela de montagem porque n�o h� servi�os no or�amento!"), "Aviso")
				lRet      := .F.
			EndIf
		EndIf
	Else
		//�������������������������������������������������������������������Ŀ
		//� Obrigar preenchimento da ordem de montagem quando existir servico �
		//���������������������������������������������������������������������
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
	//������������������������������������Ŀ
	//� Verifica se o cliente foi alterado �
	//��������������������������������������
	If lPrdSeg // Existem seguros no orcamento
		If !SL1->(EOF())
			If SL1->L1_NUM == M->LQ_NUM .And. SL1->(L1_CLIENTE + L1_LOJA) <> M->(LQ_CLIENTE + LQ_LOJA) // Trocou o cliente
				If SL1->(L1_CLIENTE + L1_LOJA) <> GetMV("MV_CLIPAD") + GetMV("MV_LOJAPAD") // Nao e cliente padrao
					MsgAlert(OemtoAnsi("O cliente n�o pode ser trocado!"), "Aviso")
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
	
	//�����������������������������������������������������������������Ŀ
	//� Marcelo Alcantara - 04/09/2005 											�
	//� Verifica se ja foi efetuada a sangria automatica na databaseoes �
	//�������������������������������������������������������������������
	If ParamIxb[1] == 2
		dbSelectArea("SLJ")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0")) .and. SLJ->LJ_DTSANGR >= dDataBase
			Aviso("Aviso","Nao e possivel Finalizar Venda apos a emissao da Sangria Automatica!! ",{"Ok"})
			lRet := .F.
		Endif          

	EndIf

	//������������������������������������������������������������������Ŀ
	//� Marcelo Alcantara - 14/12/05 								     �
	//� Valida o TES de servi�o na confirmacao do orcamento com os grupos�
	//� de Tributacao de acordp com o parametro MV_GRTRIBV               � 
	//��������������������������������������������������������������������
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
		//�����������������������������������������������������������������������Ŀ
		//� Marcelo Alcantara - 19/12/05 								          �
		//� Valida se o vendedor podera finazilar a venda segungo campo A3_FATURA �
		//�������������������������������������������������������������������������
		_lFatura:= (Posicione("SA3",1,XFILIAL("SA3")+M->LQ_VEND,"A3_FATURA") <> "N")
		If .Not. _lFatura 
			Aviso("Aviso","Nao e possivel Finalizar Venda para esse vendedor, favor trocar o vendedor e finalizar a venda!! ",{"Ok"})			
			lRet := .F.
		EndIf			
	EndIf
	
	/////////////////////////////////////////////////////
	// Valida��o do CFOP - Marcio Domingos - 11/07/06  //
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
				
					If aColsDet[_c][nPosCFO] # "6108"  // Venda para cliente n�o contribuinte fora do estado
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


	//�����������������������������������������������������������������Ŀ
	//� Marcelo Alcantara - 14/02/2007 									�
	//� Verifica se o campo M->LQ_TIPOVND esta vazio.                   �
	//�������������������������������������������������������������������
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
