#Include 'rwmake.ch'             


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPENTRADA�Autor  �Microsiga           � Data �  07/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Customizacao para impress�o de NF de Entrada e Saida       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function ImpEntrada()
Local aArea    := GetArea()
Local aAreaSF2 := SF2->(GetArea())

If AllTrim(FunName()) == "LOJA920" // Saida de materiais
	U_RFATR01(SF2->F2_DOC, SF2->F2_DOC, SF2->F2_SERIE, 2)
ElseIf AllTrim(FunName()) == "LOJA701" // Venda assistida
	// Posiciona Cabecalho Notas de Saida
	SF2->(dbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	SF2->(dbSeek(xFilial("SF2") + ParamIxb[1] + ParamIxb[2]))
	U_LJNFISCA()
ElseIf AllTrim(FunName()) == "LOJR110" // Reemissao de nota
	// Posiciona Cabecalho Notas de Saida
	SF2->(dbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	SF2->(dbSeek(xFilial("SF2") + MV_PAR01 + MV_PAR02))
	U_LJNFISCA()
Else
	U_RFATR01(SF1->F1_DOC, SF1->F1_DOC, SF1->F1_SERIE, 1)   
EndIf

RestArea(aAreaSF2)
RestArea(aArea)
Return .T.
