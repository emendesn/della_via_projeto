/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � LJ720TES �Autor  � Microsiga                � Data � 13/08/08 ���
����������������������������������������������������������������������������͹��
���Descricao � Trocar o TES da nota de entrada de devolucao de venda         ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � cRet - tes de devolucao                                       ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada do programa de trocas/devolucoes LOJA720     ���
����������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                               ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function LJ720TES()
Local cRet := "" // retorno da funcao
Local cTpOpDev := AllTrim(Upper(GetMv("FS_DEL047"))) // tipo de operacao

cRet := U_MaTesVia(1, cTpOpDev, SD2->D2_CLIENTE, SD2->D2_LOJA, "C", SD2->D2_COD)

If Empty(cRet)
	cRet := SuperGetMv("MV_TESTROC", .F.)
EndIf

Return(cRet)