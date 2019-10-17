/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � CRD003   �Autor  �Paulo Benedet             � Data � 02/09/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� ParamIxb[1] - Codigo do cliente                               ���
���          � ParamIxb[2] - Loja do cliente                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � cRet - Mensagem que sera aparecera ao operador                ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada acionado apos clicar no botao "refresh"      ���
���          � da tela de espera da analise de credito.                      ���
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
User Function CRD003()
Local aArea    := GetArea()
Local aAreaMA7 := MA7->(GetArea())
Local aAreaPAM := PAM->(GetArea())
Local cRet     := "" // Retorno da funcao

// Busca contrato
dbSelectArea("MA7")
dbSetOrder(1) //MA7_FILIAL+MA7_CODCLI+MA7_LOJA
If dbSeek(xFilial("MA7") + ParamIxb[1] + ParamIxb[2])
	If !Empty(MA7->MA7_MOTIVO)
		// Busca descricao do motivo
		dbSelectArea("PAM")
		dbSetOrder(1) //PAM_FILIAL+PAM_COD
		dbSeek(xFilial("PAM") + MA7->MA7_MOTIVO)
		
		cRet := AllTrim(MA7->MA7_MOTIVO) + " - "
		cRet += AllTrim(PAM->PAM_DESC) + " - "
		cRet += AllTrim(MA7->MA7_OBS)
		
		// Apaga motivo e observacao - para nao mostrar a mesma observacao numa proxima consulta
		RecLock("MA7", .F.)
		MA7_MOTIVO := ""
		MA7_OBS    := ""
		MA7_MOTTRA := ""
		msUnlock()
		dbCommit()
	EndIf
EndIf

// Retorna ambiente
RestArea(aAreaMA7)
RestArea(aAreaPAM)
RestArea(aArea)

Return(cRet)
