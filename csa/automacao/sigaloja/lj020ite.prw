#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ020ITE  ºAutor  ³Marcelo Alcantara   º Data ³  15/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para nao carregar no acols os produtos de º±±
±±º          ³ servico com base no grupo de tributavao especificados no   º±±
±±º          ³ MV_GRTRIBV                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³  Nao se aplica                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet - .T. - Carrega Acols com o produto do SL2            º±±
±±º          ³        .F. - Nao carrega Acols com o produto do SL2        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Ponto de entrada executado Antes de carregar os produtos   º±±
±±º          ³ no acols na dela de devolucao (LOJA020B). Posic. no Rec SL2º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Manutencao Efetuada                          	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

If GetMV("MV_DEVLOTE")  // Tratamento nao conformidade na devolução de venda com lote Chamado AANIUJ
						// Após atualização da Build e TopConnect alterar parametro para .F.

	If !Empty(SL2->L2_LOTECTL) // Se o item tiver Lote adiciono dados na matriz pública _aLOte
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
		// 8-Localização
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
