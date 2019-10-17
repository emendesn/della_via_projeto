#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ020ITE  �Autor  �Marcelo Alcantara   � Data �  15/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para nao carregar no acols os produtos de ���
���          � servico com base no grupo de tributavao especificados no   ���
���          � MV_GRTRIBV                                                 ���
�������������������������������������������������������������������������͹��
���Parametros�  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - Carrega Acols com o produto do SL2            ���
���          �        .F. - Nao carrega Acols com o produto do SL2        ���
�������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado Antes de carregar os produtos   ���
���          � no acols na dela de devolucao (LOJA020B). Posic. no Rec SL2���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                          	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LJ020ITE

Local _aArea		:= GetArea()
Local _cGrTrib		:=""
Local lRet			:= .T.                                    
Public _aLote		:= {}

// Posiciona produto e Pega o Grupo de Triburacao
_cGrTrib:=  AllTrim(Posicione("SB1",1,xFilial("SB1") + SL2->L2_PRODUTO,"B1_GRTRIB"))
If (_cGrTrib $ GetMV("MV_GRTRIBV"))  // Se o Produto estiver no parametro especificado nao carrega o acols
	lRet:= .F.
EndIf         

If GetMV("MV_DEVLOTE")  // Tratamento nao conformidade na devolu��o de venda com lote Chamado AANIUJ
						// Ap�s atualiza��o da Build e TopConnect alterar parametro para .F.

	If !Empty(SL2->L2_LOTECTL) // Se o item tiver Lote adiciono dados na matriz p�blica _aLOte
		AADD(_aLote,{SL2->L2_FILIAL,SL2->L2_NUM,SL2->L2_ITEM,SL2->L2_PRODUTO,SL2->L2_LOCAL,SL2->L2_QUANT,SL2->L2_LOTECTL,SL2->L2_LOCALIZ,SL2->L2_NLOTE})
		// Matriz _aLote
		// ==============
		// 1-Filial
		// 2-Orcamento
		// 3-Item
		// 4-Produto
		// 5-Local
		// 6-Quantidade
		// 7-Lote CTL
		// 8-Localiza��o
		// 9-Lote

		// Limpo o dados do lote
		RecLock("SL2",.F.)
		SL2->L2_LOTECTL	:= " " 
		SL2->L2_LOCALIZ	:= " " 
		SL2->L2_NLOTE   := " "
		MsUnlock()       
		
	Endif	                                                                                        
	
Endif	   
Mv_Par40 := _aLote

RestArea(_aArea)
Return lRet
