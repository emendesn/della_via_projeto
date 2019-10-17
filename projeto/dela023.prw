/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA023  �Autor  �Paulo Benedet          � Data �  13/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Gera creditos para a Pirelli                                  ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo menu                                      ���
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
Project Function DELA023()
Local cPerg := "ADEL23" 	//grupo de perguntas
Local cArqTmp := "" 		//arq de trabalho
Local aCampos := {}  		//dados do markbrowse
Local i 					//variavel do for

Private aRotina   := {} 	//botoes do browse
Private cMarca    := "" 	//codigo da marca
Private cCadastro := "" 	//titulo da tela
Private oMark 				//objeto markbrowse

cCadastro := OemToAnsi("Gera Cr�dito Pirelli")

// Verifica base de dados
#IFNDEF TOP
	MsgAlert(OemtoAnsi("Esta rotina est� dispon�vel somente no modo on-line!"), "Aviso")
	Return
#ENDIF

// Carrega dados do markbrowse
aAdd(aCampos, {"OK", "", "", ""})
aAdd(aCampos, {"PA4_NUMLOT", "", "Num Lote", "@!"})
aAdd(aCampos, {"PA4_DTDIGI", "", "Dt.Digitacao", ""})
aAdd(aCampos, {"PA4_VBONFA", "", "Vlr.Total", "@E 999,999.99"})

// Carrega arotina
aAdd(aRotina, {"Confirmar", "Processa({|| P_D23GeraNDF()}, 'Avaliando registros...')", 0, 4})

// Chama perguntas
ValidPerg(cPerg)
If !Pergunte(cPerg, .T.)
	Return
EndIf

// Monta filtro
cSQL := "SELECT '  ' OK, PA4_NUMLOT, PA4_DTDIGI, SUM(PA4_VBONFA) PA4_VBONFA "
cSQL += "FROM " + RetSQLName("PA4") + " WHERE "
cSQL += "D_E_L_E_T_ <> '*' AND "
cSQL += "PA4_FILIAL = '" + xFilial("PA4") + "' AND "
cSQL += "PA4_NUMLOT BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
cSQL += "PA4_DTDIGI BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' AND "
cSQL += "PA4_NUMNDF = '" + Space(TamSX3("PA4_NUMNDF")[1]) + "' "
cSQL += "GROUP BY PA4_NUMLOT, PA4_DTDIGI "
cSQL += "ORDER BY PA4_NUMLOT, PA4_DTDIGI "
cSQL := ChangeQuery(cSQL)

MemoWrite("DELA023_B.SQL", cSQL)

msAguarde({|| dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "LOTTMP", .F., .T.)}, "Selecionando registros...")
tcSetField("LOTTMP", "PA4_DTDIGI", "D")

// copia para arquivo local
cArqTmp := CriaTrab(Nil, .F.)
__dbCopy(cArqTmp, {},,,,,.F.,)

// fecha consulta sql
dbSelectArea("LOTTMP")
dbCloseArea()

// abre arquivo local
dbUseArea(.T.,, cArqTmp, "LOCTMP", .F., .F.)

// monta markbrowse
cMarca := GetMark()
MarkBrowse("LOCTMP", "OK",, aCampos,, cMarca)

// Fecha arquivo temporario
dbSelectArea("LOCTMP")
dbCloseArea()

// Apaga arquivo temporario
If File(cArqTmp + GetDBExtension())
	fErase(cArqTmp + GetDBExtension())
EndIf

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Paulo Benedet          � Data �  13/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Confere perguntas do SX1                                      ���
����������������������������������������������������������������������������͹��
���Parametros� cPerg - Grupo de perguntas                                    ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo menu                                      ���
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
Static Function ValidPerg(cPerg)
Local nCampos := 0
Local aDados  := {}
Local i, j

aAdd(aDados, {cPerg, "01", "Do lote ?                     ", "", "", "mv_ch1", "C", 6, 0, 0, "G", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aDados, {cPerg, "02", "Ate o lote ?                  ", "", "", "mv_ch2", "C", 6, 0, 0, "G", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aDados, {cPerg, "03", "Da data de aplicacao ?        ", "", "", "mv_ch3", "D", 8, 0, 0, "G", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aDados, {cPerg, "04", "Ate a data de aplicacao ?     ", "", "", "mv_ch4", "D", 8, 0, 0, "G", "", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

//exemplo
//aAdd(aDados, {cPerg, "05", "Quinzena                     ?", "", "", "mv_ch5", "C", 1, 0, 0, "G", "", "MV_PAR05", "D1", "", "", "", "V2", "", "", "", "", "V3", "", "", "", "", "V4", "", "", "", "", "V5", "", "", "", "", "F3", "", "", "", ""})

dbSelectArea("SX1")
dbSetOrder(1)
nCampos := fCount()

For i := 1 to Len(aDados)
	If !dbSeek(aDados[i][1] + aDados[i][2])
		RecLock("SX1", .T.)
		For j := 1 to nCampos
			FieldPut(j, aDados[i][j])
		Next j
		msUnlock()
	EndIf
Next i

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �D23GeraNDF�Autor  �Paulo Benedet          � Data �  13/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Faz a geracao da NDF para a Pirelli e atualiza dados          ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo programa DELA023                          ���
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
Project Function D23GeraNDF()
Local cSQL := "" 						// comando sql
Local nSQL := 0 						// retorno comando sql
Local aVetor := {} 						// array do execauto
Local cCodFor := GetMV("FS_DEL020") 	// codigo da Pirelli no SA2

Private lmsErroAuto := .F. // retorno do execauto

// posiciona fornecedores
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2") + cCodFor)

// Processa itens marcados
dbSelectArea("LOCTMP")
ProcRegua(RecCount())
dbGoTop()

While !EOF()
	IncProc()
	aVetor := {}
	
	If isMark("OK", cMarca) //item marcado
		// Gera NDF
		IncProc(OemtoAnsi("Gravando Nota de D�bito..."))
		
		// verifica se ndf ja existe
		dbSelectArea("SE2")
		dbSetOrder(1) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		If SE2->(dbSeek(xFilial("SE2") + "SEP" + LOCTMP->PA4_NUMLOT + Alltrim(GetMv("MV_1DUP")) + "NDF" + SA2->A2_COD + SA2->A2_LOJA))
			MsgAlert(OemtoAnsi("Cr�dito para o lote " + LOCTMP->PA4_NUMLOT + " j� existe!"), "Aviso")
			dbSelectArea("LOCTMP")
			dbSkip()
			Loop
		EndIf
		
		// Monta array com as informacoes da ndf
		aAdd(aVetor, {"E2_FILIAL" , xFilial("SE2"), Nil})
		aAdd(aVetor, {"E2_PREFIXO", "SEP", Nil})
		aAdd(aVetor, {"E2_NUM"    , LOCTMP->PA4_NUMLOT, Nil})
		aAdd(aVetor, {"E2_PARCELA", GetMv("MV_1DUP"), Nil})
		aAdd(aVetor, {"E2_TIPO"   , "NDF", Nil})
		aAdd(aVetor, {"E2_NATUREZ", GetMV("FS_DEL018"), Nil})
		aAdd(aVetor, {"E2_FORNECE", SA2->A2_COD, Nil})
		aAdd(aVetor, {"E2_LOJA"   , SA2->A2_LOJA, Nil})
		aAdd(aVetor, {"E2_NOMCLI" , SA2->A2_NREDUZ, Nil})
		aAdd(aVetor, {"E2_EMISSAO", dDataBase, Nil})
		aAdd(aVetor, {"E2_VENCTO" , dDataBase, Nil})
		aAdd(aVetor, {"E2_VENCREA", dDataBase, Nil})
		aAdd(aVetor, {"E2_VALOR"  , LOCTMP->PA4_VBONFA, Nil})
		aAdd(aVetor, {"E2_HIST"   , "LOTE : " + LOCTMP->PA4_NUMLOT, Nil})
		aAdd(aVetor, {"E2_ORIGEM" , "FINA050", Nil})
		
		// Gera nota de credito
		msExecAuto({|x| Fina050(x)}, aVetor)
		
		If lmsErroAuto
			MostraErro()
			MsgStop(OemtoAnsi("A nota de d�bito n�o foi gerada! Tente novamente ou contate o administrador do sistema."), OemtoAnsi("Aten��o"))
		Else
			// Atualizar sepus
			cSQL := "UPDATE " + RetSQLName("PA4") + " SET "
			cSQL += "PA4_NUMNDF = '" + LOCTMP->PA4_NUMLOT + "', "
			cSQL += "PA4_DTNDF  = '" + DtoS(dDataBase) + "', "
			cSQL += "PA4_VLNDF  = " + AllTrim(Str(LOCTMP->PA4_VBONFA)) + " "
			cSQL += "WHERE D_E_L_E_T_ <> '*' AND "
			cSQL += "PA4_FILIAL = '" + xFilial("PA4") + "' AND "
			cSQL += "PA4_NUMLOT = '" + LOCTMP->PA4_NUMLOT + "' AND "
			cSQL += "PA4_NUMNDF = '" + Space(TamSX3("PA4_NUMNDF")[1]) + "'"
			
			MemoWrite("DELA023_S.SQL", cSQL)
			nSQL := tcSqlExec(cSQL)
			
			// Apaga registro do markbrowse
			RecLock("LOCTMP", .F., .T.)
			dbDelete()
			msUnlock()
		EndIf
	EndIf
	
	dbSelectArea("LOCTMP")
	dbSkip()
EndDo

Return
