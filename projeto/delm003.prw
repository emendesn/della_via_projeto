/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELM003  บAutor  ณPaulo Benedet             บ Data ณ 18/10/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Gravar campo F2_TPVEND                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Esta rotina sera executada para gravar o campo mencionado     บฑฑ
ฑฑบ          ณ para os casos em que estiver vazio. Para os casos de transfe- บฑฑ
ฑฑบ          ณ rencia este campo ficara em branco. Este campo eh utilizado   บฑฑ
ฑฑบ          ณ no sigadw.                                                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELM003()

If MsgNoYes(OemtoAnsi("Confirma processamento?"), "Pergunta")
	Processa({|| Continua()}, "Processando...")
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ Continua บAutor  ณPaulo Benedet             บ Data ณ 18/10/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Processamento                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Bloco de processamento                                        บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Continua()
Local cSQL := ""

dbSelectArea("SF2")
dbSetOrder(1) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

cSQL := "SELECT F2_FILIAL, F2_DOC, F2_SERIE, L1_TIPOVND "
cSQL += "FROM " + RetSQLName("SF2") + " INNER JOIN " + RetSQLName("SL1") + " ON "
cSQL += "F2_FILIAL = L1_FILIAL AND F2_DOC = L1_DOC AND F2_SERIE = L1_SERIE "
cSQL += "WHERE " + RetSQLName("SF2") + ".D_E_L_E_T_ <> '*' AND "
cSQL += RetSQLName("SL1") + ".D_E_L_E_T_ <> '*' AND "
cSQL += "F2_TIPVND = '" + Space(TamSX3("F2_TIPVND")[1]) + "' "
cSQL := ChangeQuery(cSQL)

MemoWrite("DELM03_1.SQL", cSQL)
dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "SF2TMP", .F., .T.)

dbSelectArea("SF2TMP")
ProcRegua(500)
dbGoTop()

While !EOF()
	IncProc()
	
	If SF2->(dbSeek(SF2TMP->(F2_FILIAL + F2_DOC + F2_SERIE)))
		RecLock("SF2", .F.)
		SF2->F2_TIPVND := SF2TMP->L1_TIPOVND
		msUnlock()
	EndIf
	
	dbSelectArea("SF2TMP")
	dbSkip()
EndDo

dbSelectArea("SF2TMP")
dbCloseArea()

cSQL := "SELECT F2_FILIAL, F2_DOC, F2_SERIE, UA_TIPOVND "
cSQL += "FROM " + RetSQLName("SF2") + " SF2 INNER JOIN " + RetSQLName("SC5") + " SC5 ON "
cSQL += "F2_FILIAL = C5_FILIAL AND F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE "
cSQL += "INNER JOIN " + RetSQLName("SUA") + " SUA ON "
cSQL += "C5_FILIAL = UA_FILIAL AND C5_NUM = UA_NUMSC5 "
cSQL += "WHERE SF2.D_E_L_E_T_ <> '*' AND "
cSQL += "SC5.D_E_L_E_T_ <> '*' AND "
cSQL += "SUA.D_E_L_E_T_ <> '*' AND "
cSQL += "F2_TIPVND = '" + Space(TamSX3("F2_TIPVND")[1]) + "' "
cSQL := ChangeQuery(cSQL)

MemoWrite("DELM03_2.SQL", cSQL)
dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "SF2TMP", .F., .T.)

dbSelectArea("SF2TMP")
ProcRegua(500)
dbGoTop()

While !EOF()
	IncProc()
	
	If SF2->(dbSeek(SF2TMP->(F2_FILIAL + F2_DOC + F2_SERIE)))
		RecLock("SF2", .F.)
		SF2->F2_TIPVND := SF2TMP->UA_TIPOVND
		msUnlock()
	EndIf
	
	dbSelectArea("SF2TMP")
	dbSkip()
EndDo

dbSelectArea("SF2TMP")
dbCloseArea()

Return
