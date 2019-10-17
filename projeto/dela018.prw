#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA018A  �Autor  �Ricardo Mansano     � Data �  31/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Trava troca do Tipo de Venda ap�s digita��o dos produtos   ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digita��o)                            ���
���          �        .F. (Impede troca do Tipo de Venda.)                ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em LQ_TIPOVND                                    ���
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
Project Function DELA018A()
Local lRet 		  	:= .T.         
Local naCols		:= Len(aCols)
Local nPosProduto 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
	
	// N�o Permite alterar Tabela de Pre�o se aCols estiver preenchida
	If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
		Aviso("Aten��o !!!","Tipo de Venda n�o pode ser alterado com Itens lan�ados !!!",{" << Voltar"},2,"Tipo de Venda !")
		lRet := .F.
	Endif
	
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA018B  �Autor  �Ricardo Mansano     � Data �  31/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Tela com Margem Media do Orcamento.                        ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atravez de um botao na tela de Venda Assistida     ���
���          � botao este que foi criado a partir do PE. LJ7016.          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���Gaspar    �08/07/05�      �Tratamento da chamado do Call Center pela   ���
���          �        �      �funcao TMKUSER2                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//����������������������������������������������������������Ŀ
//� Monta os dados de acordo com o Programa Executado.       � 
//� TMKA271 --> CallCenter.                                  � 
//� LOJA701 --> Venda Assistida.                             � 
//������������������������������������������������������������
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
		ApMsgAlert("Preencha os itens para calculo da Margem !!!","Margem M�dia !")
	Else                
		//����������������������������������������������������������������Ŀ
		//�Verifica de o item 01 nao esta deletado.                        �
		//�pois caso soh haja uma linha prrenchida esta deve ser ignorada. �
		//������������������������������������������������������������������
		If (aCols[1,naColsItem]) .and. (naCols==1)
			Aviso("Aten��o !!!","Deve haver pelo menos um item n�o deletado no Or�amento !!!",{" << Voltar"},2,"Margem M�dia !")
			Return .T.
		Endif

		//���������������������������������������������������������Ŀ
		//�Soma aCols nao deletados.                                �
		//�����������������������������������������������������������
		For nX := 1 to naCols                                
			If aCols[nX, naColsItem]
				Loop
			Endif
			
			//�����������������������������������������Ŀ
			//� Soma Valor dos Itens (Unitario x Qtd)   �
			//�������������������������������������������
			nVlrItem += aCols[nX,nPosVlrItem] 
	
			//������������������������������������Ŀ
			//� Soma das Despesas                  �
			//��������������������������������������
			/*
			// cPasta := 1=Acessorio / 2=Pneus / 3=Servicos
			cTipoPrd			:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[n,nPosProduto],1,"Erro")
			cTipoPrd		   	:= Alltrim(GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cTipoPrd,1,"Erro")) 
			// A=ACESSORIO, P=PNEU, S=SERVICO, R=RODA(Pega mesma Regra de Servico)
			cPasta := iif(cTipoPrd=="A","1", iif(cTipoPrd=="P","2","3") )
			*/

			//����������������������������������������������������������������������������Ŀ
			//� Executa funcao que Retornara Margem Media e Valor de Despesa do Orcamento  �
			//������������������������������������������������������������������������������
            // OBS: Foi separada a execucao devido a Venda Assistida usar a aColsDet
			If     Alltrim(Upper(FunName())) == "TMKA271" .Or. Alltrim(Upper(FunName())) $ "TMKUSER2" 
  			    aVlrMM := P_MargemMedia(aCols[nX,nPosProduto],aCols[nX,nPosLocal],aCols[nX,nPosQuant],M->UA_TIPOVND,aCols[nX,nPosVlrItem])                   
			ElseIf Alltrim(Upper(FunName())) == "LOJA701"
			    aVlrMM := P_MargemMedia(aCols[nX,nPosProduto],aColsDet[nX,nPosLocal],aCols[nX,nPosQuant],M->LQ_TIPOVND,aCols[nX,nPosVlrItem])                   
			Endif
			nDespesa += aVlrMM[2]
			
			//������������������������������������������Ŀ
			//� Soma Valor dos Custos (Unitario x Qtd)   �
			//��������������������������������������������
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
		
		Aviso("Aten��o !!!","%Margem Media do Pedido"+chr(10)+chr(13)+chr(10)+chr(13) + Str(nVlrGeral,14,2)+"%",{" << Voltar"},2,"%Margem Media do Pedido !")
	Endif
	
Return .T.