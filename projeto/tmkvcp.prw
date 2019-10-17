#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKVCP    ºAutor  ³Norbert Waage Juniorº Data ³  12/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³P.E. utilizado para validar a condicao de pgto selecionada. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³cCodTransp - Codigo da Transportadora                       º±±
±±º          ³oCodTransp - Objeto a ser atualizado com o cod da transp.   º±±
±±º          ³cTransp - Descricão da transportadora                       º±±
±±º          ³oTransp - Objeto a ser atualizado com o cod da transp       º±±
±±º          ³cCob - Endereco de cobranca                                 º±±
±±º          ³oCob - Objeto que sera atualizado com o end. de Cobranca    º±±
±±º          ³cEnt - Endereco de entrega                                  º±±
±±º          ³oEnt - Objeto que sera atualizado com o endereco de entrega º±±
±±º          ³cCidadeC - Cidade para a cobranca                           º±±
±±º          ³oCidadeC - Objeto que sera atualizado com a cidade de cobr. º±±
±±º          ³cCepC - CEP para a cobranca                                 º±±
±±º          ³oCepC - Objeto que sera atualizado com o bairro de cobranca º±±
±±º          ³cUfC - Estado para a cobranca                               º±±
±±º          ³oUfC - Objeto que sera atualizado com o estado para a cobr. º±±
±±º          ³cBairroE - Bairro de entrega                                º±±
±±º          ³oBairroE - Objeto que sera atualizado com o bairro de entr. º±±
±±º          ³cBairroC - Bairro de cobranca                               º±±
±±º          ³oBairroC - Objeto que sera atualizado com o bairro de cobr. º±±
±±º          ³cCidadeE - Cidade de Entrega                                º±±
±±º          ³oCidadeE - Obj. a ser atualizado com a Cidade para a entregaº±±
±±º          ³cCepE - Cep para entrega                                    º±±
±±º          ³oCepE - Objeto que sera atualizado com o CEP para entrega   º±±
±±º          ³cUfE - Estado para a entrega                                º±±
±±º          ³oUfE - Objeto que sera atualizado com o estado de entrega   º±±
±±º          ³nOpc - Opcão selecionada                                    º±±
±±º          ³cNumTlv - Numero do atendimento Televendas                  º±±
±±º          ³cCliente - Codigo do Cliente                                º±±
±±º          ³cLoja - Loja do cliente                                     º±±
±±º          ³cCodPagto - Codigo da condicão de pagamento escolhida       º±±
±±º          ³aParcelas - Array com as parcelas montadas atraves da       º±±
±±º          ³            condicao de pagamento escolhida.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³lRet - Permite ou nao o uso da condicao selecionada         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Chamado apos a confirmacao da condicao de pagamento         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Della Via Pneus                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                   	  º±±
±±º          ³        ³      ³                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A variavel lTk271Auto eh criada quando a rotina eh          ³
	//³chamada via execauto.                                       ³
	//³Nesta funcao, esta variavel eh criada manualmente para que  ³
	//³a rotina Tk273MontaParcela nao tente atualizar objetos que, ³
	//³nesta funcao, nao estao visiveis por terem sido criados como³
	//³local na rotina Tk273Pagamento - Norbert - 15/07/05         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private	lTk271Auto	:=	.T.
	               
	//CRIADO APENAS PARA NAO GERAR ERRO NA ROTINA Tk273MontaParcela
	@ 1,1 SAY oDescPagto VAR cDescPagto SIZE 1,1 OF oMainWnd PIXEL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa DelA030 para cada elemento do aCols³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aCols)
	P_DelA030(nX,cCodPagto)
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recalcula as parcelas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tk273NFatura ºAutor  ³Andrea Farias       º Data ³  05/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o total do Valor Nao Faturado desse atendimento        º±±
±±º          ³baseado nas linhas validas e com o TES preenchido              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TELEVENDAS                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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