/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � TMKVDC   �Autor  �Paulo Benedet          � Data �  31/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� nOpc - 1 - Confirmou a tela de cancelamento                   ���
���          �        2 - Nao confirmou a tela de cancelamento               ���
���          � cNumSUA - Numero do atendimento televendas                    ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado apos a tela de confirmacao do      ���
���          � cancelamento do orcamento televenda. Se o cancelamento foi    ���
���          � confirmado, apos a alteracao dos arquivos.                    ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �31/05/05�Nao ha�Apagar orcamento gerado no sigaloja.           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function TMKVDC(nOpc, cNumSUA)
Local aAreaIni := GetArea()
Local aAreaSUA := SUA->(GetArea())
Local aAreaSL1 := SL1->(GetArea())

// Posiciona televendas
dbSelectArea("SUA")
dbSetOrder(1) //UA_FILIAL+UA_NUM
dbSeek(xFilial("SUA") + cNumSUA)

// Busca orcamento sigaloja
dbSelectArea("SL1")
dbOrderNickName("SL1_FS1") //L1_FILIAL+L1_NUMSUA
If dbSeek(SUA->(UA_LOJASL1 + UA_NUM))
	P_ApagaReser(SL1->L1_FILIAL, SL1->L1_NUM)
EndIf

// Chama funcao para apagar orcamentos gerados no sigaloja
P_D19ApagaLoja(cNumSUA)

// Retorna ambiente
RestArea(aAreaSL1)
RestArea(aAreaSUA)
RestArea(aAreaIni)

Return
