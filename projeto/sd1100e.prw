/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � SD1100E  �Autor  �Paulo Benedet          � Data �  10/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� ParamIxb[1] - ?                                               ���
���          � ParamIxb[2] - ?                                               ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada do programa MATA103 (NF de entrada)          ���
���          � apos a confirmacao da exclusao dos arquivos e antes da        ���
���          � exclusao dos itens da nf.                                     ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �08/06/05�      �Apagar SEPU e NCC vinculada.                   ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function SD1100E()
Local aAreaIni := GetArea()
Local aAreaSE1 := SE1->(GetArea())

If cEmpAnt <> "01"
	Return
EndIf

// Busca os produtos SEPU
If AllTrim(SD1->D1_COD) == GetMV("FS_DEL008"); // produto sepu
	.And. SD1->D1_LOCAL == GetMV("FS_DEL013") // Armazem SEPU
	
	// Apaga SEPU
	dbSelectArea("PA4")
	dbSetOrder(1) //PA4_FILIAL+PA4_SEPU
	If dbSeek(xFilial("PA4") + SD1->D1_LOTECTL)
		RecLock("PA4", .F., .T.)
		dbDelete()
		msUnlock()
	EndIf
	
	// Apaga NCC
	dbSelectArea("SE1")
	dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If dbSeek(xFilial("SE1") + "SEP" + SD1->D1_LOTECTL)
		RecLock("SE1", .F., .T.)
		dbDelete()
		msUnlock()
	EndIf
EndIf


// Retorna ambiente
RestArea(aAreaSE1)
RestArea(aAreaIni)

Return
