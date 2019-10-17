#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA015A  �Autor  �Ricardo Mansano     � Data �  03/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza Campos da aCols, aColsDet e Rodapes               ���
���          � de acordo com Produtos ou Quantidades digitados            ���
�������������������������������������������������������������������������͹��
���Parametros�_nValor := Preco Unitario do Produto                        ���
���          �_lAtuBar:= Idica se os rodapes devem ser atualizados        ���
���          �_cCond  := Condicao de pagamento utilizada                  ���
�������������������������������������������������������������������������͹��
���Retorno   � 01-nVlrUnit = Valor tratado pela fun��o P_Dela027  que     ���
���          �            o valor da tabela de pre�os em DA1 respeitando  ���
���          �            as mesmas regras do Faturamento.                ���
���          � 02-Caso ja venha preenchido o Valor Unitario o sistema     ���
���          �    Ignora a rotina de busca de preco na tabela.            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Gatilho dos campos:                                        ���
���          � LR_PRODUTO      Sequencia :001  Contra Dominio : LR_VRUNIT ���
���          � LR_QUANT        Sequencia :001  Contra Dominio : LR_VRUNIT ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���Norbert   �23/06/05�      �Substituicao da rotina MaTabPrVen pela roti-���
���          �        �      �na P_DELA027 para calcular o preco de venda.���
���Norbert   �01/07/05�      �Comentado o trecho onde os descontos sao ze-���
���          �        �      �rados.                                      ���
���Norbert   �11/07/05�      �Tratamento para produtos que nao estao ca-  ���
���          �        �      �dastrados em tabela de preco.               ���
���Norbert   �09/02/06�      �Alteracao do calculo dos descontos. Foi uti-���
���          �        �      �lizada a mesma logica do programa Lj7VlItem,���
���          �        �      �do padrao (LOJA701A).                    	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//������������������������������������������������Ŀ
//�Verifica se eh saida rapida - Norbert - 15/12/05�
//��������������������������������������������������
lSaidaR	:= AllTrim(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[N,nPosProduto],1,"")) == AllTrim(GetMv("FS_DEL002"))

//�����������������������������������������������������������Ŀ
//�Grava valor digitado no preco de tabela para itens de saida�
//�rapida - Norbert - 15/12/05                                �
//�������������������������������������������������������������
If	AllTrim(ReadVar()) == "M->LR_VRUNIT" .AND. lSaidaR

	aCols[N,nPosPrcAtu] := &(ReadVar())  //Preco Tabela
	
EndIf

// Impede digita��o de Itens se Tab. de Pre�os ou Tipo de Venda estiver em branco
If (Alltrim(M->LQ_CODTAB)=="").or.(Alltrim(M->LQ_TIPOVND)=="")
	
	// Limpa produto para que usu�rio possa preencher a Tab. de Pre�os
	aCols[n,nPosProduto] := space(15)
	
	// Zera Valor para for�ar digita��o da Tab de Pre�os
	nVlrUnit := 0
	
	Aviso("Aten��o !!!","Preencha o Cod. da Tabela de Pre�os e o Tipo de Venda !!!",{" << Voltar"},2,"Tabela de Pre�os/Tipo de Venda !")
	Return(nVlrUnit)
Else
	
	// Retorna Valor Unitario respeitando as regras de Tabela de Pre�os do Cadastro de Pedidos
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
		
		//���������������������������������������������������������Ŀ
		//�O produto pode nao ter preco cadastrado, o que retornaria�
		//�valor zerado na funcao DELA027 - Norbert - 11/07/05      �
		//�����������������������������������������������������������
		If _nValor == 0
			nVlrUnit	:=	aCols[N,nPosVrUnit]
		Else
			nVlrUnit	:=	_nValor
		EndIf
		
		//��������������Ŀ
		//�Valor unitario�
		//����������������
		nVlrUnBr	:=	nVlrUnit
		nVlrItem	:= NoRound( aCols[n][nPosQuant] * nVlrUnit, nDecimais)
		
		aCols[n,nPosVlrItem]	:= nVlrItem
		
		//����������������������������������������������������Ŀ
		//�Calculo do desconto quando se usa o campo LR_DESC,  �
		//�LR_QUANT, ou o item esta sendo recalculado por outra�
		//�rotina                                              �
		//������������������������������������������������������
		If (AllTrim(ReadVar()) $ "M->LR_DESC/M->LR_QUANT") .Or. P_NaPilha("P_DELA020I")

		    nVlrDesc := Round( aCols[n,nPosPercDesc] * aCols[n][nPosVlrItem] / 100, nDecimais )

	    	aCols[n][nPosValDesc] 	:= nVlrDesc
		
		//����������������������������������������Ŀ
		//�Calculo do desconto nas demais situacoes�
		//������������������������������������������
		Else
		
			nVlrDesc			:= aCols[n,nPosValDesc]
			nVlrPDesc			:= Round( nVlrDesc * 100 / aCols[n][nPosVlrItem], TamSx3("L2_DESC")[2] )

			aCols[n][nPosPercDesc]:= nVlrPDesc
			
		EndIf

		//��������������������������������������Ŀ
		//�Aplicacao do valor de desconto ao item�
		//����������������������������������������
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

//�����������������������������Ŀ
//�Tratamento do TES inteligente�
//�������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA015B  �Autor  �Ricardo Mansano     � Data �  05/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Trava troca da Tabela de pre�o ap�s digita��o dos produtos ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digita��o)                            ���
���          �        .F. (Impede troca da Tabela de pre�os.)             ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em LQ_CODTAB                                     ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���Mansano   �09/06/05�      �Inclusao da validacao de troca de Tabela de ���
���          �        �      �preco de acordo com a Regra no campos    	  ���
���          �        �      �PA6_TRCTAB S=Sim / N=Nao.                	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA015B()
Local lRet 		  	:= .T.
Local naCols		:= Len(aCols)
Local nPosProduto 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"PA6"}) // GetArea

// N�o Permite alterar Tabela de Pre�o se aCols estiver preenchida
If ((naCols==1) .and. (AllTrim(aCols[1,nPosProduto])<>"")) .or. (naCols > 1)
	Aviso("Aten��o !!!","Cod. da Tabela de Pre�os n�o pode ser alterada com Itens lan�ados !!!",{" << Voltar"},2,"Tabela de Pre�os !")
	lRet := .F.
Endif

// Verifica se convenio permite Troca de Tabela
// Verifica existencia do Convenio para evitar perda de ponteiro
PA6->(DbSetOrder(1)) //PA6_FILIAL+PA6_COD
If !(PA6->(DbSeek(xFilial("PA6")+M->LQ_CODCON)))
	Aviso("Aten��o !!!","Conv�nio n�o Localizado !!!",{" << Voltar"},2,"Convenio !")
	lRet := .F.
Else
	If ( PA6->PA6_TRCTAB=="N" ) .and. ( PA6->PA6_TABELA<>M->LQ_CODTAB )
		Aviso("Aten��o !!!","Conv�nio s� permite vendas na Tabela de Pre�o: "+PA6->PA6_TABELA+" !!!",{" << Voltar"},2,"Convenio !")
		lRet := .F.
	Endif
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(lRet)
