#INCLUDE "protheus.ch"       
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA030   �Autor  �Norbert Waage Junior   � Data �  24/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de calculo dos valores do item, respeitando a tabela de ���
���          �precos e aplicando o acrescimo da condicao de pagamento        ���
����������������������������������������������������������������������������͹��
���Parametros�nLinha  - Linha do aCols processada                            ���
���          �cCondPg - Condicao de pagamento a ser utilizada                ���
���          �lCalcArc- Logico, define se sera calculado acrescimo ou nao    ���
����������������������������������������������������������������������������͹��
���Retorno   �nPreco  - Preco unitario                                       ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelos campos da linha do aCols do TeleVendas-TMK���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA030(nLinha,cCondPg,lCalcAcr)

Local aArea		:=	GetArea()
Local nPerAcr
Local nMoeda	:= 1
Local nPosVrUnit:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VRUNIT" })
Local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
Local nPosQuant	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT"  })
Local nPosVlItem:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VLRITEM"})
Local nPosDesc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_DESC"   })
Local nPosVlDesc:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})
Local nPosAcre	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_ACRE"   })
Local nPosVlAcre:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALACRE"})
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_TES"    })
Local nPrcTab	:= aScan(aHeader,{|x| AllTrim(x[2]) == "UB_PRCTAB" })
Local nPreco 	:= 0
Local nPrTab	:= 0
Local nNatu		:= N
Local nDesconto	:= 0
Local nAcresc	:= 0
Local dDataLim	:= IIf(Empty(M->UA_DTLIM),dDataBase,M->UA_DTLIM)

//�������������������������������������������������Ŀ
//�Valores padrao quando nao informadas as variaveis�
//�dos parametros da funcao                         �
//���������������������������������������������������
Default nLinha	:= N
Default cCondPg	:= M->UA_CONDPG
Default lCalcAcr:= .T.

N := nLinha 							//Altera N
nPreco := aCols[nLinha][nPosVrUnit]		//Utiliza preco ja preenchido

//����������������������������������������������������������Ŀ
//�Somente quando a tabela de preco e a condicao de pagamento�
//�estiverem preechidas                                      �
//������������������������������������������������������������
If !Empty (M->UA_TABELA) .And. !Empty(M->UA_CONDPG) .And. lCalcAcr
	
	//���������������Ŀ
	//�Preco de tabela�
	//�����������������
	nPrTab	:=	MaTabPrVen(M->UA_TABELA,aCols[nLinha][nPosProd],aCols[nLinha][nPosQuant],;
				M->UA_CLIENTE,M->UA_LOJA,nMoeda,dDataLim)
    
	//�������������������������������������Ŀ
	//�Se houver preco  de tabela cadastrado�
	//���������������������������������������
	If nPrTab != 0
		
		nPreco := nPrTab

		If !Empty(cCondPg)
			
			//�����������������������������������������������������������������������������Ŀ
			//�Calcula acrecimo para produtos de grupos que nao estao no parametro FS_DEL036�
			//�������������������������������������������������������������������������������
			If !((AllTrim(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nLinha][nPosProd],1,"")) $ AllTrim(GetMV("FS_DEL036"))))
				nPerAcr	:=	GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+cCondPg,1,0)
				nPreco	+=	nPreco * (nPerAcr/100)
			EndIf	
			
			nPrTab := nPreco

			//�����������������Ŀ
			//�Calcula descontos�
			//�������������������
			If aCols[nLinha][nPosVlDesc] != 0

				If AllTrim(ReadVar()) == "M->UB_DESC" .Or. P_NaPilha("P_DELA030G")
					nDesconto := aCols[nLinha][nPosDesc]
					aCols[nLinha][nPosVlDesc] := NoRound((nPreco * aCols[nLinha,nPosQuant] * (nDesconto/100)),TamSX3("UB_VALDESC")[2])
				Else
					nDesconto := (aCols[nLinha][nPosVlDesc] / (nPreco * aCols[nLinha,nPosQuant])) * 100
					aCols[nLinha][nPosDesc]	:= Round(nDesconto,TamSx3("UB_DESC")[2])
				EndIf
			
			EndIf
			
			//�����������������Ŀ
			//�Calcula acrescimo�
			//�������������������
			If aCols[nLinha][nPosVlAcre] != 0
			
				If AllTrim(ReadVar()) == "M->UB_ACRE"
					nAcresc	:= aCols[nLinha][nPosAcre]
					aCols[nLinha][nPosVlAcre] := Round((nPreco * aCols[nLinha,nPosQuant] * (nAcresc/100)),TamSx3("UB_VALACRE")[2])
				Else
					nAcresc := (aCols[nLinha][nPosVlAcre] / (nPreco * aCols[nLinha,nPosQuant])) * 100
					aCols[nLinha][nPosAcre]	:= Round(nAcresc, TamSx3("UB_ACRE")[2])
				Endif
			
			EndIf
			
			nPreco := A410Arred(nPreco,"UB_VRUNIT")
			
			//����������������������������Ŀ
			//�Aplica acrescimo ou desconto�
			//������������������������������
			If AllTrim(ReadVar()) $ "M->UB_VALACRE/M->UB_ACRE"
				nPreco := nPreco  - (nPreco * (aCols[nLinha][nPosDesc]/100)) +;
						 (nPreco * (nAcresc/100))
			Else				
				nPreco := nPreco + (nPreco * (aCols[nLinha][nPosAcre])/100) -;
						 (nPreco * (nDesconto)/100)
	   		EndIf
			
			//��������������������������������������������������Ŀ
			//�Atualiza aCols com o valor do item e total do item�
			//����������������������������������������������������
			nPreco := A410Arred(nPreco,"UB_VRUNIT")
			
			aCols[nLinha][nPosVrUnit] := nPreco
			aCols[nLinha][nPrcTab]	  := A410Arred(nPrTab,"UB_VRUNIT")
			aCols[nLinha][nPosVlItem] := aCols[nLinha][nPosQuant] * nPreco
				
		EndIf
		
	EndIf

	//�����������������������������������������������������������Ŀ
	//�Executa as funcoes fiscais para atualizar os valores totais�
	//�referentes a venda e impostos                              �
	//�������������������������������������������������������������
	MaFisRef("IT_VALMERC", "TK273", aCols[nLinha][nPosVlItem])
	MaFisRef("IT_TES", "TK273", aCols[nLinha][nPosTes])
	
	//��������������������������������������������Ŀ
	//�Atualiza totais da tela e mensagem do rodape�
	//����������������������������������������������
	Tk273Trigger()
	
EndIf

//�������������������������������������������������������Ŀ
//� Nao chamar telas se a rotina for chamada por execauto �
//���������������������������������������������������������
If !lTk271Auto
	//���������������Ŀ
	//�Atualiza Rodape�
	//�����������������
	P_TmRodape()
	
	//�����������������Ŀ
	//�Atualiza GetDados�
	//�������������������
	oGetTlv:oBrowse:Refresh()
EndIf

//�����������������Ŀ
//�Restaura ambiente�
//�������������������
N := nNatu
RestArea(aArea)

Return NoRound(nPreco,TamSx3("D2_PRCVEN")[2])

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �TmRodape  �Autor  �Norbert Waage Junior   � Data �  27/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina para atualizacao da mensagem do rodape informativo dos  ���
���          �totais da venda.                                               ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �uRet - Conteudo do campo que acionou esta funcao/gatilho       ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada para atualizar o rodape, como gatilho ou codigo ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function TmRodape()
Local aArea		:= GetArea()
Local aParc		:= Condicao(aValores[6],M->UA_CONDPG)// aValores[6] Eh o total da venda, definido no TMKDEF.CH
Local cDescCP	:= Space(10) + M->UA_CONDPG + " - " + AllTrim(GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+M->UA_CONDPG,1,""))

If !lTk271Auto
	//�����������������������Ŀ
	//�Se a condicao eh valida�
	//�������������������������
	If Len(aParc) > 0
		
		//����������������������Ŀ
		//�Monta e exibe o rodape�
		//������������������������
		cString   := Space(10) + "TOTAL DA VENDA: " + AllTrim(Str(Len(aParc))) + " X " + Alltrim(Transform(aParc[1][2],"@E 9,999,999.99"))
		cContHist := AllTrim(TkDadosContato(SU5->U5_CODCONT,0)) + cDescCP + cString
		oContHist:Refresh()
	EndIf
EndIf

RestArea(aArea)

Return M->&(ReadVar()) 

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA030G  �Autor  �Norbert Waage Junior   � Data �  27/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Gatilho para executar a rotina de calculo dos itens para todas ���
���          �as linhas do aCols                                             ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �uRet - Conteudo do campo que acionou esta funcao/gatilho       ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada para atualizar os valores e totais da venda, via���
���          �gatilho                                                        ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/                      
Project Function DelA030G()

Local aArea		:=	GetArea()
Local nX
Local cCond		:= M->UA_CONDPG
Local lCalcAcr	:= .F.

//�����������������������������������������������������������Ŀ
//�Verifica se sera necessario recalcular os valores dos itens�
//�com base no acrescimo financeiro da condicao de pagamento  �
//�������������������������������������������������������������
If 	GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+cCond,1,0) !=;
	GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+_DelA030Cond,1,0)
	
	lCalcAcr := .T.
	
EndIf

_DelA030Cond := cCond

//�������������Ŀ
//�Varre o aCols�
//���������������
For nX := 1 to Len(aCols)
	P_DelA030(nX,cCond,lCalcAcr)
Next nX

//�������������������������������������������������������Ŀ
//� Nao chamar telas se a rotina for chamada por execauto �
//���������������������������������������������������������
If !lTk271Auto
	//�����������������Ŀ
	//�Atualiza GetDados�
	//�������������������
	oGetTlv:oBrowse:Refresh()
EndIf

RestArea(aArea)

Return &(ReadVar())        

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA030A  �Autor  �Norbert Waage Junior   � Data �  09/09/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de calculo de descontos dos itens do televendas         ���
����������������������������������������������������������������������������͹��
���Parametros�nLinha - Numero da linha atual                                 ���
���          �nValor - Valor do desconto                                     ���
����������������������������������������������������������������������������͹��
���Retorno   �lRet - (.T.) Permite o uso do campo                            ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada a partir do X3_VALID, substituindo o TK273Calcu-���
���          �la, que calculava os descontos de forma diferente da desejada. ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/                      
Project Function DELA030A(nLinha,nValor)

Local lRet		:= .F.                                 // Retorno da funcao
Local nPQtd		:= aPosicoes[4][2]                     // Posicao da Quantidade
Local nPVrUnit	:= aPosicoes[5][2]						// Posicao do Valor unitario
Local nPVlrItem := aPosicoes[6][2]						// Posicao do Valor do item
Local nPDesc 	:= aPosicoes[9][2]						// Posicao do Desconto em %
Local nPValDesc := aPosicoes[10][2]						// Posicao do Valor desconto $
Local nPTes     := aPosicoes[11][2]						// Posicao do TES
Local nPValAcre := aPosicoes[14][2]						// Posicao do Valor do Acrescimo $
Local nPPrctab  := aPosicoes[15][2]                    // Posicao do Preco de Tabela
Local nValUni   := 0									// Valor Unitario
Local nVlrTab   := 0                                    // Valor da Tabela
Local cDesconto := TkPosto(M->UA_OPERADO,"U0_DESCONT")	// Desconto  1=ITEM / 2=TOTAL / 3=AMBOS / 4=NAO
Local cTesBonus := GetMv("MV_BONUSTS") 					// Codigo da TES usado para as regras de bonificacao
Local cTes    											// Conteudo do TES
Local nValItem  := 0									// Valor auxiliar	

Default nLinha	:= N
Default nValor	:= M->UB_VALDESC
                
cTes := aCols[nLinha][nPTes]				
//���������������������������������������������������������������������������������������Ŀ
//�Se a TES utilizada for igual a TES de bonificacao nao calcula os acrescimos e descontos�
//�����������������������������������������������������������������������������������������
If (cTes == cTesBonus)
	Return(lRet)
Endif	

//���������������������������������������������������������Ŀ
//�So pode dar desconto se o Posto de venda estiver      	�
//�configurado para Item ou Ambos					    	�
//�����������������������������������������������������������
If Alltrim(cDesconto) == "2" .OR. Alltrim(cDesconto) == "4"   // Item ou Total
	If nValor > 0 
		Help( " ", 1, "NAO_DESCON")
		aCols[nLinha][nPValDesc] := 0
		Return(lRet)
	Endif	
Endif

//��������������������Ŀ
//�Zero o desconto em %�
//����������������������
aCols[nLinha][nPDesc]    := 0

//���������������������������������������������������������Ŀ
//�Carrego novamente o valor de desconto calculado		    �
//�����������������������������������������������������������
aCols[nLinha][nPValDesc] := nValor

//���������������������������������������������������������Ŀ
//�O Valor do desconto nao pode ser maior que o vlr. do item�
//�����������������������������������������������������������
If nValor >= aCols[nLinha][nPVlrItem]
	Help( " ", 1, "DESCMAIOR2" )
	aCols[nLinha][nPValDesc] := 0
	aCols[nLinha][nPDesc]    := 0
	aCols[nLinha][nPValDesc] := 0
	Return(lRet)
Endif

//��������������������������������������������������������������
//�Faz os calculos de desconto baseando-se no preco de tabela  �
//��������������������������������������������������������������
If aCols[nLinha][nPPrcTab] > 0
	nVlrTab := aCols[nLinha][nPPrcTab] + aCols[nLinha][nPValAcre]
Else
	nVlrTab := aCols[nLinha][nPVrUnit]
Endif                                       

nValItem:= (nVlrTab * aCols[nLinha][nPQtd])
nValItem:= nValItem - nValor
nValUni := Round(nValItem/aCols[nLinha][nPQtd],4)

//�������������������������������������������������������Ŀ
//�Se houver DESCONTO EM CASCATA ja aplica o valor no item�
//���������������������������������������������������������
If (M->UA_DESC4 > 0) .OR. (M->UA_DESC1 > 0) .OR. (M->UA_DESC2 > 0) .OR. (M->UA_DESC3 > 0)
	Tk273DesCLi(nLinha,2)	// R$
	nValUni := aCols[nLinha][nPVrUnit]
Endif

aCols[nLinha][nPVrUnit] := nValUni
aCols[nLinha][nPVlrItem]:= nValItem
aCols[nLinha][nPValDesc]:= A410Arred(aCols[nLinha][nPQtd]*nVlrTab,"UB_VALDESC") - aCols[nLinha][nPVlrItem]

//���������������������������������Ŀ
//�Calcula a porcentagem do desconto�
//�����������������������������������
aCols[nLinha][nPDesc] := A410Arred((nValor / (aCols[nLinha][nPQtd]*nVlrTab))*100,"UB_DESC")

lRet := .T.

Eval(bRefresh)
                                    
MaFisAlt("IT_TES",aCols[nLinha][nPTes],nLinha)
If MaFisFound()
	MaColsToFis(aHeader,aCols,nLinha,"TK273",.T.)
	Tk273Refresh(aValores)	
Endif

If M->UA_PDESCAB > 0
	Tk273CalcDesc()
Endif
	
//���������������������������������������������������������������������������������������Ŀ
//�Verifica se esse TES gera titulos para nao obrigar a selecao das condicoes de pagamento�
//�����������������������������������������������������������������������������������������
DbSelectArea("SF4")
DbSetOrder(1)
If DbSeek(xFilial("SF4")+aCols[nLinha][nPTes])
	If SF4->F4_DUPLIC == "S"
		lTesTit := .T.
	Else
		lTesTit := .F.
	Endif
Endif

Eval(bRefresh)
                                    
If MaFisFound()
	MaColsToFis(aHeader,aCols,nLinha,"TK273",.T.)
	Tk273Refresh(aValores)	
Endif

If M->UA_PDESCAB > 0
	Tk273CalcDesc()
Endif
	
Return lRet