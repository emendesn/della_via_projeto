/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A100DEL  บAutor  ณMicrosiga              บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada                                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Permite a exclusao da NF                         บฑฑ
ฑฑบ          ณ        .F. - Nao permite a exclusao da NF                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Ponto de entrada do programa MATA103 (NF de entrada)          บฑฑ
ฑฑบ          ณ apos selecao do registro para exclusao e antes da tela de     บฑฑ
ฑฑบ          ณ confirmacao.                                                  บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบBenedet   ณ08/06/05ณ      ณValidar a exclusao das notas de SEPU.          บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A100DEL()
Local aAreaIni := GetArea()
Local lRet := .T. // retorno
Local cSQL := "" // comando sql
Local cPrdSEPU := GetMV("FS_DEL008") + Space(TamSX3("B1_COD")[1] - Len(AllTrim(GetMV("FS_DEL008")))) // produto sepu
Local cNumSEPU := "" // numero do sepu
#IFDEF TOP
	Local cSD1 := RetSQLName("SD1") // Tabela sd1
	Local cSD2 := RetSQLName("SD2") // Tabela sd2
	Local cSE1 := RetSQLName("SE1") // Tabela se1
	Local cPA4 := RetSQLName("PA4") // Tabela pa4
#ENDIF

If cEmpAnt <> "01"
	Return(.T.)
EndIf

#IFDEF TOP
	// busca numero do sepu
	dbSelectArea("PA4")
	dbSetOrder(3) //PA4_FILIAL+PA4_FILDV+PA4_SRNFE+PA4_NFE
	If dbSeek(xFilial("PA4") + SF1->(F1_FILIAL + F1_SERIE + F1_DOC))
		// nota de sepu
		cNumSEPU := PA4->PA4_SEPU
		
		// Verifica venda antecipada
		If !Empty(PA4->PA4_CFANT)
			lRet := .F.
			MsgAlert(OemtoAnsi("Uma nota de SEPU com venda antecipada nใo pode ser excluํda!"), "Aviso")
		Else
			// Verifica se houve remessa do material
			cSQL := "SELECT 'SAIDA' ID, D2_FILIAL FILIAL, D2_DOC DOC, D2_SERIE SERIE "
			cSQL += "FROM " + cSD2 + " WHERE "
			cSQL += "D_E_L_E_T_ <> '*' AND "
			cSQL += "D2_COD = '" + cPrdSEPU + "' AND "
			cSQL += "D2_LOCAL = '" + GetMV("FS_DEL013") + "' AND "
			cSQL += "D2_LOTECTL = '" + cNumSEPU + "' "
			cSQL += " UNION "
			cSQL += "SELECT 'ENTRADA' ID, D1_FILIAL FILIAL, D1_DOC DOC, D1_SERIE SERIE "
			cSQL += "FROM " + cSD1 + " WHERE "
			cSQL += "D_E_L_E_T_ <> '*' AND "
			cSQL += "D1_COD = '" + cPrdSEPU + "' AND "
			cSQL += "D1_LOCAL = '" + GetMV("FS_DEL013") + "' AND "
			cSQL += "D1_LOTECTL = '" + cNumSEPU + "' AND "
			cSQL += "D1_FILIAL <> '" + SF1->F1_FILIAL + "' AND "
			cSQL += "D1_DOC <> '" + SF1->F1_DOC + "' AND "
			cSQL += "D1_SERIE <> '" + SF1->F1_SERIE + "'"
			cSQL := ChangeQuery(cSQL)
			
			MemoWrite("A100DEL_1.SQL", cSQL)
			
			msAguarde({|| dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "RMTMP", .F., .T.)}, "Selecionando registros...")
			dbSelectArea("RMTMP")
			dbGoTop()
			
			If !EOF()
				lRet := .F.
				msgAlert(OemtoAnsi("A nota nใo poderแ ser excluํda porque houve remessa do material!"), "Aviso")
			EndIf
			
			// Fecha arquivo
			dbSelectArea("RMTMP")
			dbCloseArea()
			
			If lRet
				// Verifica se ncc foi utilizada
				cSQL := "SELECT E1_NUM "
				cSQL += "FROM " + cSE1 + " WHERE "
				cSQL += "D_E_L_E_T_ <> '*' AND "
				cSQL += "E1_PREFIXO = 'SEP' AND "
				cSQL += "E1_PARCELA = 'A' AND "
				cSQL += "E1_TIPO = 'NCC' AND "
				cSQL += "E1_NUM = '" + cNumSEPU + "' AND "
				cSQL += "E1_VALOR <> E1_SALDO"
				cSQL := ChangeQuery(cSQL)
				
				MemoWrite("A100DEL_2.SQL", cSQL)
				
				msAguarde({|| dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "NCTMP", .F., .T.)}, "Selecionando registros...")
				dbSelectArea("NCTMP")
				dbGoTop()
				
				If !EOF()
					lRet := .F.
					msgAlert(OemtoAnsi("A nota nใo poderแ ser excluํda porque a nota de cr้dito do SEPU foi utilizada!"), "Aviso")
				EndIf
				
				// Fecha arquivo
				dbSelectArea("NCTMP")
				dbCloseArea()
			EndIf
		EndIf
	EndIf
#ELSE
	lRet := .F.
	msgAlert(OemtoAnsi("A exclusใo da nota fiscal s๓ poderแ ser feita no ambiente on-line!"), "Aviso")
#ENDIF

RestArea(aAreaIni)
Return(lRet)
