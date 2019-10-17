/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELM004  �Autor  �Paulo Benedet             � Data � 18/10/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Gravar campos de despesas de MM                               ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Esta rotina sera executada para gravar o campo mencionado     ���
���          � para os casos em que estiver vazio. Este campo eh utilizado   ���
���          � no sigadw e na comissao                                       ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Marcelo   �18/11/05|      �Acrescentado a Pergunta DLM004 para tratamento ���
���Alcantara �        |      �de Data de emissao inicial  final e numero de  ���
���          �        |      �NF inicial.                                    ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
//Project Function DELM004()
User Function DELM004()
Local _cPerg:= "DLM004"
Local dIni
Local dFin
Local cNotaIni
Local cNotaFim

Pergunte(_cPerg,.T.)
dIni:= MV_PAR01
dFim:= MV_PAR02
cNotaIni:= MV_PAR03
cNotaFim:= MV_PAR04

If MsgNoYes(OemtoAnsi("Confirma processamento?"), "Pergunta")
	Processa({|| Continua(dIni, dFim, cNotaIni, cNotaFim)}, "Processando...")
EndIf

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � Continua �Autor  �Paulo Benedet             � Data � 18/10/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Processamento                                                 ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Bloco de processamento                                        ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Marcelo   �18/11/05�      �Alteracao na query para recalcular o MM de     ���
���Alcantara �        �      �todos os items da nota fiscal e filtrar por    ���
���          �        �      �data de emissicao e Numero de NF.              ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function Continua(dIni, dFim, cNotaIni, cNotaFim)
Local cSQL := ""
Local aMM  := {}
Local nCM1 := 0
Local nMM  := 0
Local aTam := TamSX3("D2_MM")
Local nTam := aTam[1] - aTam[2] - 1
Local nVlrMrg := 0

dbSelectArea("SD2")
dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

cSQL := "SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, F2_TIPVND "
cSQL += "FROM " + RetSQLName("SD2") + " SD2 INNER JOIN " + RetSQLName("SF2") + " SF2 ON "
cSQL += "D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE "
cSQL += "WHERE SD2.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*'"
cSQL += " AND D2_TIPO = 'N' AND D2_FILIAL = '"+xFilial("SD2")+ "'" 
cSQL += " AND D2_EMISSAO >= '" + DtoS(dIni) + "' AND D2_EMISSAO <= '" + DtoS(dFim) + "'"
cSQL += " AND D2_DOC >= '" + cNotaIni + "' AND D2_DOC <= '" + cNotaFim + "'"
//cSQL += "(D2_MM = 100 OR D2_DESPMM = 0) AND "  //Comentado para recalcular todos os itens da NF (Marcelo)

cSQL := ChangeQuery(cSQL)

MemoWrite("DELM04.SQL", cSQL)
dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "SD2TMP", .F., .T.)

dbSelectArea("SD2TMP")
ProcRegua(500)
dbGoTop()

While !EOF()
	IncProc()
	
	If SD2->(dbSeek(SD2TMP->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM)))
		aMM := P_MargemMedia(SD2TMP->D2_COD, SD2->D2_LOCAL, SD2->D2_QUANT, SD2TMP->F2_TIPVND, SD2->D2_TOTAL, SD2TMP->D2_FILIAL)
		
		nCM1    := IIf(SD2->D2_QUANT <> 0, SD2->D2_CUSTO1 / SD2->D2_QUANT, 0)
		nVlrMrg := (SD2->D2_TOTAL - aMM[2]) - SD2->D2_CUSTO1 
		nMM     := IIf(SD2->D2_TOTAL <> 0, Round((nVlrMrg / SD2->D2_TOTAL) * 100, aTam[2]), 0)
		nMM     := IIf(Abs(nMM) >= (10 ^ nTam), (10 ^ nTam) - 1, nMM)
		
		RecLock("SD2", .F.)
		SD2->D2_MM     := nMM
		SD2->D2_DESPMM := aMM[2]
		SD2->D2_CM1    := nCM1
		msUnlock()
	EndIf
	
	dbSelectArea("SD2TMP")
	dbSkip()
EndDo

dbSelectArea("SD2TMP")
dbCloseArea()

Return
