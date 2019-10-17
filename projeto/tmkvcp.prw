#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKVCP    �Autor  �Norbert Waage Junior� Data �  12/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �P.E. utilizado para validar a condicao de pgto selecionada. ���
�������������������������������������������������������������������������͹��
���Parametros�cCodTransp - Codigo da Transportadora                       ���
���          �oCodTransp - Objeto a ser atualizado com o cod da transp.   ���
���          �cTransp - Descric�o da transportadora                       ���
���          �oTransp - Objeto a ser atualizado com o cod da transp       ���
���          �cCob - Endereco de cobranca                                 ���
���          �oCob - Objeto que sera atualizado com o end. de Cobranca    ���
���          �cEnt - Endereco de entrega                                  ���
���          �oEnt - Objeto que sera atualizado com o endereco de entrega ���
���          �cCidadeC - Cidade para a cobranca                           ���
���          �oCidadeC - Objeto que sera atualizado com a cidade de cobr. ���
���          �cCepC - CEP para a cobranca                                 ���
���          �oCepC - Objeto que sera atualizado com o bairro de cobranca ���
���          �cUfC - Estado para a cobranca                               ���
���          �oUfC - Objeto que sera atualizado com o estado para a cobr. ���
���          �cBairroE - Bairro de entrega                                ���
���          �oBairroE - Objeto que sera atualizado com o bairro de entr. ���
���          �cBairroC - Bairro de cobranca                               ���
���          �oBairroC - Objeto que sera atualizado com o bairro de cobr. ���
���          �cCidadeE - Cidade de Entrega                                ���
���          �oCidadeE - Obj. a ser atualizado com a Cidade para a entrega���
���          �cCepE - Cep para entrega                                    ���
���          �oCepE - Objeto que sera atualizado com o CEP para entrega   ���
���          �cUfE - Estado para a entrega                                ���
���          �oUfE - Objeto que sera atualizado com o estado de entrega   ���
���          �nOpc - Opc�o selecionada                                    ���
���          �cNumTlv - Numero do atendimento Televendas                  ���
���          �cCliente - Codigo do Cliente                                ���
���          �cLoja - Loja do cliente                                     ���
���          �cCodPagto - Codigo da condic�o de pagamento escolhida       ���
���          �aParcelas - Array com as parcelas montadas atraves da       ���
���          �            condicao de pagamento escolhida.                ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - Permite ou nao o uso da condicao selecionada         ���
�������������������������������������������������������������������������͹��
���Aplicacao �Chamado apos a confirmacao da condicao de pagamento         ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TMKVCP(cCodTransp	,oCodTransp	,cTransp	,oTransp	,;
					cCob		,oCob		,cEnt		,oEnt		,;
					cCidadeC	,oCidadeC	,cCepC		,oCepC		,;
					cUfC		,oUfC		,cBairroE	,oBairroE	,;
					cBairroC	,oBairroC	,cCidadeE	,oCidadeE	,;
					cCepE		,oCepE		,cUfE		,oUfE		,;
					nOpc		,cNumTlv	,cCliente	,cLoja		,;
					cCodPagto	,aParcelas)

Local aArea	   		:=	GetArea()
Local lRet 	   		:= .T.
Local lTipo9   		:=	(GetAdvFVal("SE4","E4_TIPO",xFilial("SE4")+cCodPagto,1,"") == "9")
Local nLiquido 		:=	0
Local nValNFat 		:=	0
Local nEntrada		:=	0
Local nFinanciado	:=	0
Local cCodAnt		:=	""
Local cDescPagto	:= ""
Local oDescPagto	:= NIL
Local aDadosParc	:= {}
Local nTxJuros      := 0
Local nTxDescon     := 0
Local nVlrPrazo     := 0
Local nVlJur        := 0
Local nNumParcelas  := Len(aParcelas)
Local nX


If !lTk271Auto
	//������������������������������������������������������������Ŀ
	//�A variavel lTk271Auto eh criada quando a rotina eh          �
	//�chamada via execauto.                                       �
	//�Nesta funcao, esta variavel eh criada manualmente para que  �
	//�a rotina Tk273MontaParcela nao tente atualizar objetos que, �
	//�nesta funcao, nao estao visiveis por terem sido criados como�
	//�local na rotina Tk273Pagamento - Norbert - 15/07/05         �
	//��������������������������������������������������������������
	Private	lTk271Auto	:=	.T.
	               
	//CRIADO APENAS PARA NAO GERAR ERRO NA ROTINA Tk273MontaParcela
	@ 1,1 SAY oDescPagto VAR cDescPagto SIZE 1,1 OF oMainWnd PIXEL
EndIf

//�������������������������������������������Ŀ
//�Executa DelA030 para cada elemento do aCols�
//���������������������������������������������
For nX := 1 to Len(aCols)
	P_DelA030(nX,cCodPagto)
Next nX

//���������������������Ŀ
//�Recalcula as parcelas�
//�����������������������
nLiquido 	:= aValores[6] 		// aValores[6] Eh o total da venda, definido no TMKDEF.CH
nValNFat	:= Tk273NFatura()  //Calcula o Valor Nao Faturado
nLiquido	:= nLiquido - nValNFat

//Armazena dados complementares da parcela
For nX := 1 to Len(aParcelas)
	AAdd(aDadosParc,{aParcelas[nX][3],aParcelas[nX][4]})
Next nX

Tk273MontaParcela(	nOpc		,cNumTlv   		,@nLiquido 		,/*oLiquido*/  		,;
					@nTxJuros	,/*oTxJuros*/	,@nTxDescon		,/*oTxDescon*/ 		,;
					@aParcelas	,/*oParcelas*/	,@cCodPagto	   		,/*oCodPagto*/ 		,;
					@nEntrada	,/*oEntrada*/	,@nFinanciado		,/*oFinanciado*/	,;
					@cDescPagto	,oDescPagto		,@nNumParcelas	,/*oNumParcelas*/	,;
					@nVlrPrazo	,/*oVlrPrazo */	,@nVlJur		,@cCodAnt			,;
					@lTipo9		,nValNFat		,/*oValNFat*/)

//Restaura dados complementares da parcela
If Len(aParcelas) == Len(aDadosParc)
	For nX := 1 to Len(aParcelas)
		aParcelas[nX][3] := aDadosParc[nX][1]
		aParcelas[nX][4] := aDadosParc[nX][2]
	Next nX
EndIf

RestArea(aArea)

Return lRet
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �Tk273NFatura �Autor  �Andrea Farias       � Data �  05/05/04   ���
����������������������������������������������������������������������������͹��
���Desc.     �Retorna o total do Valor Nao Faturado desse atendimento        ���
���          �baseado nas linhas validas e com o TES preenchido              ���
����������������������������������������������������������������������������͹��
���Uso       �TELEVENDAS                                                     ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

Static Function Tk273NFatura()

Local aArea		:= GetArea()        		// Guarda a area anterior
Local nI		:= 0                 		// Controle de loop       
Local nValor  	:= 0                     	// Valor Nao Faturado
Local nPTes		:= aPosicoes[11][2]        // Posicao do TES 
Local nPVlrItem	:= aPosicoes[6][2]         // Posicao do Valor do Item
Local nValIpi	:= 0                       	// Valor do IPI para o Item

For nI:=1 TO Len(aCols)
	If !aCols[nI][Len(aHeader)+1] .AND. !Empty(aCols[nI][nPTes])
		Dbselectarea("SF4")
		DbsetOrder(1)
		If MsSeek(xFilial("SF4")+aCols[nI][nPTes])
			If SF4->F4_DUPLIC == "N" //Nao Gera Duplicata
				//Considera o valor de IPI pois faz parte do valor total da nota.
				nValIpi:=MaFisRet(nI,'IT_VALIPI')
				nValor += aCols[nI][nPVlrItem]+nValIpi
			Endif
		Endif
	Endif
Next nI

RestArea(aArea)
Return(nValor)