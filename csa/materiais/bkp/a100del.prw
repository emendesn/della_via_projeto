/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A100DEL  ºAutor  ³Microsiga              º Data ³  08/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet - .T. - Permite a exclusao da NF                         º±±
±±º          ³        .F. - Nao permite a exclusao da NF                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Ponto de entrada do programa MATA103 (NF de entrada)          º±±
±±º          ³ apos selecao do registro para exclusao e antes da tela de     º±±
±±º          ³ confirmacao.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºBenedet   ³08/06/05³      ³Validar a exclusao das notas de SEPU.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
//Não considero na empresa Durapol
IF SM0->M0_CODIGO <> "03"
	
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
				MsgAlert(OemtoAnsi("Uma nota de SEPU com venda antecipada não pode ser excluída!"), "Aviso")
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
					msgAlert(OemtoAnsi("A nota não poderá ser excluída porque houve remessa do material!"), "Aviso")
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
						msgAlert(OemtoAnsi("A nota não poderá ser excluída porque a nota de crédito do SEPU foi utilizada!"), "Aviso")
					EndIf
					
					// Fecha arquivo
					dbSelectArea("NCTMP")
					dbCloseArea()
				EndIf
			EndIf
		EndIf
	#ELSE
		lRet := .F.
		msgAlert(OemtoAnsi("A exclusão da nota fiscal só poderá ser feita no ambiente on-line!"), "Aviso")
	#ENDIF
EndIF
RestArea(aAreaIni)
Return(lRet)
