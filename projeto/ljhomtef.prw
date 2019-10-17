#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLJHOMTEF  บ Autor ณNorbert Waage Juniorบ Data ณ  20/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ norbert@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado na homologacao do TEF           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Permite alterar parcelas)                      บฑฑ
ฑฑบ          ณ        .F. (Impede a alteracao das parecelas)              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ P.E. na Venda Assistida (Loja701B)                         บฑฑ
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
User Function LJHOMTEF()

Local aArea		:=	GetArea()
Local nNatu		:=	N
Local nPosPrUn	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VRUNIT"  })
Local lPassou	:=	("P_DELC001A()" $ oGetVa:cDelOk) 	//Executa uma vez por venda
Local nX,nH

If nRotina == 2 //Visualizacao
	Return .F.
EndIf

If !lPassou
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณO trecho abaixo modifica a validacao da delecao da linha ณ
	//ณno GetDados da venda assistida (oGetVa), incluindo uma   ณ
	//ณchamada a a funcao responsavel pelo tratamento de delecaoณ
	//ณaos itens relacionados criados nesta rotina.             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oGetVa:cDelOk := "P_DELC001A() .And. " + oGetVa:cDelOk
	oGetVa:cLinhaOk := "Iif(Lj7LinOk(),(P_DELA015A(,.T.),.T.),.F.)"
	//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
EndIf 
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuando trata-se de uma confirmacao de venda os valores ณ
//ณsao recalculados                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !INCLUI .And. !lPassou
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPercorre itensณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nX := 1 to Len(aCols)
		
		N := nX
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRegistra as variaveis de memoria para a linha atualณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nH := 1 To Len(aHeader)
			M->&(aHeader[nH][2]) := aCols[N][nH]
			If AllTrim(aHeader[nH][2]) == "LR_SLDSTQ"
				aCols[nX][nH] := P_DCalcEst(cFilAnt, gdFieldGet("LR_PRODUTO"), GetMV("FS_DEL028"), .F.)
			EndIf
		Next nH
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAciona a rotina de calculo dos itensณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		P_Dela015A(aCols[N][nPosPrUn],.F.,_cD020CPG) 

	Next nX
	
	N := nNatu
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRestaura as variaveis de memoria para a linha atualณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nH := 1 To Len(aHeader)
		M->&(aHeader[nH][2]) := aCols[N][nH]
	Next nH
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRecupera referencias de seguradora e corretora do SL4ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	P_DELA020J(xFilial("SL1"),M->LQ_NUM,.F.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza mensagem no rodape, com tratamento paraณ
	//ณvisualizacao da venda e ordena parcelas (aPgtos)ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	P_LjRodape(IIf(nRotina == 2,SL1->L1_CONDPG,NIL))
		
	oGetVA:oBrowse:Refresh()
	N := nNatu
	
EndIf

RestArea(aArea)

Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRecalcFis บAutor  ณNorbert Waage Juniorบ Data ณ  22/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRecalcula totais da venda para corrigir o erro de valores   บฑฑ
ฑฑบ          ณocasionado pelo uso de descontos                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ##*NOTA*##ณEsta rotina corrige paliativamente este erro. Os valores da บฑฑ
ฑฑบ          ณvenda sao calculados incorretamente na Venda assitida quandoบฑฑ
ฑฑบ          ณfinaliza-se um orcamento que possuia descontos.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Dellavia Pneus                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function RecalcFis()

Local nPosVlItem	:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VLRITEM"})][2]
Local nPosProd		:= aScan(aHeader, { |x| AllTrim(x[02]) == "LR_PRODUTO" })
Local nPosQuant		:= aScan(aHeader, { |x| AllTrim(x[02]) == "LR_QUANT" })
Local nPosValDesc	:= aScan(aHeader, { |x| AllTrim(x[02]) == "LR_VALDESC" })
Local nPosTES		:= aScan(aHeaderDet, { |x| AllTrim(x[02]) == "LR_TES" })
Local nPosPRCTab	:= aScan(aHeaderDet, { |x| AllTrim(x[02]) == "LR_PRCTAB" })
Local nX
Local nPosVrunit	:= aScan(aHeader, { |x| AllTrim(x[02]) == "LR_VRUNIT" })
Local nPrcTab		:= 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLimpa os itens da NF e zera as variaveis do cabecalho.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MaFisClear()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณZera totais para recalculoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Lj7T_SubTotal(2,0)
                       
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRecria cabecalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MaFisIni(M->LQ_CLIENTE, M->LQ_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPercorre os itens da vendaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nX := 1 To Len(aCols)
		
		//Preco de tabela
		nPrcTab := Round(aCols[nX,nPosVrUnit] + (aCols[nX,nPosValDesc] / aCols[nX,nPosQuant]),nDecimais)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAdiciona todos os itensณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MaFisAdd(aCols[nX,nPosProd], aColsDet[nX,nPosTES], aCols[nX,nPosQuant], ;
			aCols[nX,nPosVrUnit], aCols[nX,nPosValDesc],"", "", 0, 0, 0, 0, 0,;
			(nPrcTab * aCols[nX,nPosQuant]), 0)  

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณForca o recalculo do valor do item, pois o padrao arredondaณ
		//ณo valor incorretamtente, em determinadas situacoes.        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MaFisAlt("IT_VALMERC",0,n)
		MaFisAlt("IT_VALMERC",aCols[n][nPosVlItem],n)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRecalcula subtotalณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If ! aCols[nX,Len(aCols[nX])]
			Lj7T_SubTotal( 2, ( Lj7T_SubTotal(2) + MaFisRet(nX, "IT_TOTAL") ))
		EndIf
	
	Next
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza totalณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Lj7T_Total( 2, Lj7T_SubTotal(2) - Lj7T_DescV(2))
	
EndIf

Return Nil
*/