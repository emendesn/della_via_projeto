#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJHOMTEF  � Autor �Norbert Waage Junior� Data �  20/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � norbert@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada executado na homologacao do TEF           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Permite alterar parcelas)                      ���
���          �        .F. (Impede a alteracao das parecelas)              ���
�������������������������������������������������������������������������͹��
���Aplicacao � P.E. na Venda Assistida (Loja701B)                         ���
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
	//���������������������������������������������������������Ŀ
	//�O trecho abaixo modifica a validacao da delecao da linha �
	//�no GetDados da venda assistida (oGetVa), incluindo uma   �
	//�chamada a a funcao responsavel pelo tratamento de delecao�
	//�aos itens relacionados criados nesta rotina.             �
	//�����������������������������������������������������������
	oGetVa:cDelOk := "P_DELC001A() .And. " + oGetVa:cDelOk
	oGetVa:cLinhaOk := "Iif(Lj7LinOk(),(P_DELA015A(,.T.),.T.),.F.)"
	//����������������������������������������������������������
EndIf 
	
//�������������������������������������������������������Ŀ
//�Quando trata-se de uma confirmacao de venda os valores �
//�sao recalculados                                       �
//���������������������������������������������������������
If !INCLUI .And. !lPassou
	
	//��������������Ŀ
	//�Percorre itens�
	//����������������
	For nX := 1 to Len(aCols)
		
		N := nX
		
		//���������������������������������������������������Ŀ
		//�Registra as variaveis de memoria para a linha atual�
		//�����������������������������������������������������
		For nH := 1 To Len(aHeader)
			M->&(aHeader[nH][2]) := aCols[N][nH]
			If AllTrim(aHeader[nH][2]) == "LR_SLDSTQ"
				aCols[nX][nH] := P_DCalcEst(cFilAnt, gdFieldGet("LR_PRODUTO"), GetMV("FS_DEL028"), .F.)
			EndIf
		Next nH
		
		//������������������������������������Ŀ
		//�Aciona a rotina de calculo dos itens�
		//��������������������������������������
		P_Dela015A(aCols[N][nPosPrUn],.F.,_cD020CPG) 

	Next nX
	
	N := nNatu
	
	//���������������������������������������������������Ŀ
	//�Restaura as variaveis de memoria para a linha atual�
	//�����������������������������������������������������
	For nH := 1 To Len(aHeader)
		M->&(aHeader[nH][2]) := aCols[N][nH]
	Next nH
	
	
	//�����������������������������������������������������Ŀ
	//�Recupera referencias de seguradora e corretora do SL4�
	//�������������������������������������������������������
	P_DELA020J(xFilial("SL1"),M->LQ_NUM,.F.)
	
	//������������������������������������������������Ŀ
	//�Atualiza mensagem no rodape, com tratamento para�
	//�visualizacao da venda e ordena parcelas (aPgtos)�
	//��������������������������������������������������
	P_LjRodape(IIf(nRotina == 2,SL1->L1_CONDPG,NIL))
		
	oGetVA:oBrowse:Refresh()
	N := nNatu
	
EndIf

RestArea(aArea)

Return .F.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RecalcFis �Autor  �Norbert Waage Junior� Data �  22/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Recalcula totais da venda para corrigir o erro de valores   ���
���          �ocasionado pelo uso de descontos                            ���
�������������������������������������������������������������������������͹��
���##*NOTA*##�Esta rotina corrige paliativamente este erro. Os valores da ���
���          �venda sao calculados incorretamente na Venda assitida quando���
���          �finaliza-se um orcamento que possuia descontos.             ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Dellavia Pneus                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

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
//������������������������������������������������������Ŀ
//�Limpa os itens da NF e zera as variaveis do cabecalho.�
//��������������������������������������������������������
If MaFisClear()
	
	//����������������������������
	//�Zera totais para recalculo�
	//����������������������������
	Lj7T_SubTotal(2,0)
                       
	//����������������Ŀ
	//�Recria cabecalho�
	//������������������
	MaFisIni(M->LQ_CLIENTE, M->LQ_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701")
	
	//��������������������������Ŀ
	//�Percorre os itens da venda�
	//����������������������������
	For nX := 1 To Len(aCols)
		
		//Preco de tabela
		nPrcTab := Round(aCols[nX,nPosVrUnit] + (aCols[nX,nPosValDesc] / aCols[nX,nPosQuant]),nDecimais)
		
		//�����������������������Ŀ
		//�Adiciona todos os itens�
		//�������������������������
		MaFisAdd(aCols[nX,nPosProd], aColsDet[nX,nPosTES], aCols[nX,nPosQuant], ;
			aCols[nX,nPosVrUnit], aCols[nX,nPosValDesc],"", "", 0, 0, 0, 0, 0,;
			(nPrcTab * aCols[nX,nPosQuant]), 0)  

		//�����������������������������������������������������������Ŀ
		//�Forca o recalculo do valor do item, pois o padrao arredonda�
		//�o valor incorretamtente, em determinadas situacoes.        �
		//�������������������������������������������������������������
		MaFisAlt("IT_VALMERC",0,n)
		MaFisAlt("IT_VALMERC",aCols[n][nPosVlItem],n)
		
		//������������������Ŀ
		//�Recalcula subtotal�
		//��������������������
		If ! aCols[nX,Len(aCols[nX])]
			Lj7T_SubTotal( 2, ( Lj7T_SubTotal(2) + MaFisRet(nX, "IT_TOTAL") ))
		EndIf
	
	Next
	
	//��������������Ŀ
	//�Atualiza total�
	//����������������
	Lj7T_Total( 2, Lj7T_SubTotal(2) - Lj7T_DescV(2))
	
EndIf

Return Nil
*/