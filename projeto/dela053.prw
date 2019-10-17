/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA053  �Autor  �Paulo Benedet             � Data � 20/10/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Trocar o tes dos itens da distribuicao                        ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - Cliente / loja corretos                          ���
���          �        .F. - Cliente / loja errados                           ���
����������������������������������������������������������������������������͹��
���Aplicacao � Esta rotina valida o cliente e a loja e troca os tes dos itens���
���          � da distribuicao.                                              ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA053
Local nTotLin := Len(aCols)
Local cTes    := ""
Local lRet    := .F.
Local i

// Verifica cliente
If Empty(M->LM_CLIENTE) .And. Empty(M->LM_LOJA)
	MsgAlert(OemtoAnsi("Favor preencher o c�digo e a loja do cliente!"), "Aviso")
	lRet := .F.
Else
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + M->LM_CLIENTE + M->LM_LOJA))
	
	For i := 1 to nTotLin
		If Empty(gdFieldGet("LN_TPOPER", i))
			If !Empty(gdFieldGet("LN_COD", i))
				MsgAlert(OemtoAnsi("Favor preencher o c�digo de opera��o!"), "Aviso")
				Return(.F.)
			EndIf
		EndIf
		
		// Devolve tes
		cTes := U_maTesVia(2, gdFieldGet("LN_TPOPER", i), M->LM_CLIENTE, M->LM_LOJA,, gdFieldGet("LN_COD", i), "LN_TES")
		gdFieldPut("LN_TES", cTes, i)
		
		// Devolve cfop
		gdFieldPut("LN_CF", RetField("SF4", 1, xFilial("SF4") + gdFieldGet("LN_TES", i), "F4_CF"), i)
	Next i
	
	lRet := .T.
	oGet:oBrowse:Refresh()
EndIf

Return(lRet)
