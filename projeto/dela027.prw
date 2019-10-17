#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA027   �Autor  �Norbert Waage Junior   � Data �  22/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina para calculo do preco de tabela do produto              ���
����������������������������������������������������������������������������͹��
���Parametros�_cCodTab = Tabela de preco                                     ���
���          �_cProd   = Codigo do produto                                   ���
���          �_nQuant  = Quantidade                                          ���
���          �_cCliente= Codigo do cliente                                   ���
���          �_cLoja   = Loja do cliente                                     ���
���          �_nMoeda  = Moeda a ser considerada                             ���
���          �_dDtLim  = Data limite                                         ���
���          �cCondPg  = Condicao de pagamento atual                         ���
���          �nValDig  = Valor digitado anteriormente                        ���
����������������������������������������������������������������������������͹��
���Retorno   �Valor do produto, considerando a quantidade                    ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotinas especificas da venda assistida                         ���
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
Project Function DELA027(_cCodTab,_cProd,_nQuant,_cCliente,_cLoja,_nMoeda,_dDtLim,cCondPg,nValDig)

Local aArea		:=	GetArea()
Local nPerAcr	:=	0
Local nPreco	:=	MaTabPrVen(_cCodTab,_cProd,_nQuant,_cCliente,_cLoja,_nMoeda,_dDtLim)

Default cCondPg	:= ""
Default nValDig	:= 0

//�������������������������������������������������������Ŀ
//�Tratamento para produtos com saida rapida (sem preco de�
//�tabela) - Norbert - 15/12/05                           �
//���������������������������������������������������������
If nPreco == 0
	nPreco := nValDig
EndIf
                               
//���������������������������������������Ŀ
//�Armazena a condicao de pagamento em uso�
//�����������������������������������������
If Empty(cCondPg) .And. !Empty(_cD020CPG)
	cCondPg := _cD020CPG
EndIf

//���������������������������������Ŀ
//�Se o tipo da venda esta preechido�
//�����������������������������������
If !Empty(M->LQ_TIPOVND)

	//�����������������������������Ŀ
	//�Obtem a condicao de pagamento�
	//�������������������������������
	If Empty(cCondPg)
		cCondPg := GetAdvFVal("PAF","PAF_CONDPG",xFilial("PAF")+cFilAnt+M->LQ_TIPOVND,1,"")
		_cD020CPG := cCondPg
	EndIf
	
	If !Empty(cCondPg)

		//�����������������������������������������������������������������������������������Ŀ
		//�Obtem valor de acrescimo e executa o calculo para produtos fora do grupo de seguros�
		//�������������������������������������������������������������������������������������
		If	((nPerAcr	:=	GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+cCondPg,1,0)) > 0) .And.;
			!((AllTrim(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+_cProd,1,"")) $ AllTrim(GetMV("FS_DEL036"))))
			
			nPreco += nPreco * (nPerAcr/100)
			
		EndIf

	EndIf
	
EndIf	

RestArea(aArea)

Return Round(nPreco,MsDecimais(_nMoeda))