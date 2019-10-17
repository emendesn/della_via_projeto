/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � TMKVEX          �Autor � Paulo Benedet       �Data � 24/06/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � .T. - Cancela o atendimento                                   ���
���Retorno   � .F. - Nao cancela o atendimento                               ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado apos clicar no botao de            ���
���          � cancelamento do orcamento televenda.                          ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �24/06/05�      �Validar se houve venda antes de cancelar       ���
���          �        �      �orcamento.                                     ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function TMKVEX()
Local aArea    := GetArea()
Local aAreaSL1 := SL1->(GetArea())

// Posiciona cabecalho sigaloja
dbSelectArea("SL1")
dbOrderNickName("SL1_FS1") //L1_FILIAL+L1_NUMSUA
dbSeek(SUA->UA_LOJASL1 + SUA->UA_NUM)

// Verifica se orcamento foi vendido
If !Empty(SL1->L1_DOC)
	MsgAlert(OemtoAnsi("O or�amento foi vendido pela loja, portanto n�o poder� ser cancelado!"), "Aviso")
	Return(.F.)
EndIf

// Restaura ambiente
RestArea(aAreaSL1)
RestArea(aArea)

Return(.T.)
