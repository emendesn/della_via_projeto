/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � LJ140DEL �Autor  �Paulo Benedet          � Data �  23/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado apos confirmacao de exclusao da    ���
���          � venda e antes da exclusao dos arquivos no LOJA140.            ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �23/05/05�      �Limpar dados de faturamento no arquivo de      ���
���          �        �      �seguros.                                       ���
���Benedet   �31/05/05�      �Limpar dados de faturamento no televendas.     ���
���Benedet   �09/06/05�      �Limpar dados de faturamento no sepu.           ���
���Norbert   �13/06/05�      �Limpar dados do sinistro de pneu.              ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function LJ140DEL()
Local aEstIni := GetArea()
Local aEstPA4 := PA4->(GetArea())
Local aEstPA8 := PA8->(GetArea())

// Verifica se existe seguro relacionado a venda
dbSelectArea("PA8")
dbSetOrder(5) // PA8_FILIAL+PA8_LOJSG+PA8_ORCSG+PA8_ITORCS
dbSeek(xFilial("PA8") + cFilAnt + SL1->L1_NUM)

While !EOF();
	.And. PA8_FILIAL == xFilial("PA8");
	.And. PA8_LOJSG == cFilAnt;
	.And. PA8_ORCSG == SL1->L1_NUM
	
	RecLock("PA8", .F.)
	PA8_NFSG   := ""
	PA8_SRSG   := ""
	PA8_DTSG   := CtoD("  /  /  ")
	msUnlock()
	
	dbSelectArea("PA8")
	dbSkip()
EndDo

If !Empty(SL1->L1_NUMSUA) // Orcamento originado no televendas
	// Atualiza informacoes do televendas
	P_D19AtuTlv(SL1->L1_FILIAL, SL1->L1_NUM, SL1->L1_NUMSUA, 2)
EndIf

// Atualiza informacoes no sepu
dbSelectArea("PA4")
dbSetOrder(2) //PA4_FILIAL+PA4_FILANT+PA4_SERANT+PA4_CFANT
If dbSeek(xFilial("PA4") + cFilAnt + SL1->L1_SERIE + SL1->L1_DOC)
	RecLock("PA4", .F.)
	PA4_FILANT := ""
	PA4_CFANT  := ""
	PA4_SERANT := ""
	PA4_CPRODV := ""
	PA4_DPRODV := ""
	msUnlock()
	dbCommit()
EndIf

//Remove dados do sinistro
P_DelA020E(SL1->L1_FILIAL,SL1->L1_NUM,SL1->L1_DOC,SL1->L1_SERIE)

RestArea(aEstPA4)
RestArea(aEstPA8)
RestArea(aEstIni)
Return
