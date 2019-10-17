/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA065A     บAutor  ณPaulo Benedet         บ Data ณ 04/01/08 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Grupo de Atendimento X Codigo Despir              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada via menu                                       บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via Pneus                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DELA065()
Private cCadastro := "Grp Atend X Cod Despir" // Titulo da tela
Private aRotina   := {} // Botoes da tela

aAdd(aRotina, {"Pesquisar" , "axPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "U_DELA065A", 0, 2})
aAdd(aRotina, {"Alterar"   , "U_DELA065A", 0, 4})

mBrowse(6, 1, 22, 75, "SU0")

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA065A     บAutor  ณPaulo Benedet         บ Data ณ 04/01/08 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Tela de manutencao                                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cAlias - Alias da tabela alterada                             บฑฑ
ฑฑบ          ณ nReg   - Numero do registro em alteracao                      บฑฑ
ฑฑบ          ณ nOpc   - Numero do botao aRotina                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina DELA065                            บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via Pneus                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DELA065A(cAlias, nReg, nOpc)
Local aTam     := msAdvSize(.T.) // resolucao da tela
Local aObj     := {} // objetos
Local aInfo    := {} // posicao dos objetos
Local aPosObj  := {} // array com as posicoes dos objetos
Local aCpoEnch := {"U0_CODIGO", "U0_NOME", "NOUSER"} // campos que aparecem na enchoice
Local cShow    := "PBR_CODPIR|PBR_DSCPIR|PBR_DESCTO" // campos que aparecem na getdados
Local aNwHead  := {} // aheader
Local aNwCols  := {} // acols
Local nUsado   := 0 // numero de colunas
Local lGrv     := .F. // indica a confirmacao da tela
Local nOpcNw   := 0 // indica o tipo de acao sobre a getdados
Local nTotLin  := 0 // total de linhas do acols
Local npCodPir := 0 // posicao do campo PBR_CODPIR
Local bOK // Acao executada apos clicar no botao OK
Local bCancel // Acao executada apos clicar no botao Cancelar
Local i, j // for next

Private oDlg, oEnch, oGetD
Private aTELA[0][0]
Private aGETS[0]

If nOpc == 3
	nOpcNw := GD_INSERT + GD_DELETE + GD_UPDATE
EndIf	

// calcula coordenadas do objeto
aAdd(aObj, {100, 025, .T., .T.})
aAdd(aObj, {100, 075, .T., .T.})

aInfo   := {aTam[1], aTam[2], aTam[3], aTam[4], 3, 3}
aPosObj := msObjSize(aInfo, aObj, .T., .F.)

// Cria as variaveis da Enchoice (M->?)
RegToMemory("SU0")

// Monta aHeader
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PBR")

While !EOF() .And. SX3->X3_ARQUIVO == "PBR"
	If rTrim(SX3->X3_CAMPO) $ cShow
		If x3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			nUsado += 1
			
			aAdd(aNwHead, {;
			SX3->X3_TITULO , SX3->X3_CAMPO  , SX3->X3_PICTURE, SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, SX3->X3_VALID  , SX3->X3_USADO  , SX3->X3_TIPO   ,;
			SX3->X3_F3     , SX3->X3_CONTEXT, SX3->X3_CBOX   , SX3->X3_RELACAO,;
			SX3->X3_WHEN   , SX3->X3_VISUAL , SX3->X3_VLDUSER, SX3->X3_PICTVAR,;
			SX3->X3_OBRIGAT})
		EndIf
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
End

// Carrega aCols
dbSelectArea("PBR")
dbSetOrder(1) // PBR_FILIAL+PBR_CODGRP+PBR_CODPIR
dbSeek(xFilial("PBR") + M->U0_CODIGO)

While !EOF() .And. PBR->(PBR_FILIAL + PBR_CODGRP) == xFilial("PBR") + M->U0_CODIGO
	
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		If aNwHead[i][10] <> "V"
			aNwCols[Len(aNwCols)][i] := FieldGet(FieldPos(aNwHead[i][2]))
		ElseIf rTrim(aNwHead[i][2]) == "PBR_DSCPIR"
			aNwCols[Len(aNwCols)][i] := Tabela("Z6", AllTrim(PBR->PBR_CODPIR))
		EndIf
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
	
	dbSelectArea("PBR")
	dbSkip()
End

If Empty(aNwCols)
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		aNwCols[Len(aNwCols)][i] := CriaVar(aNwHead[i][2], .T.)
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta dialogo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define msDialog oDlg Title cCadastro From aTam[7],0 to aTam[6],aTam[5] of oMainWnd Pixel

oEnch := msMGet():New(cAlias, nReg, 2,,,, aCpoEnch, aPosObj[1],,,,, oDlg,,,, .F.,, .T.)
oGetD := msNewGetDados():New(aPosObj[2][1], aPosObj[2][2], aPosObj[2][3], aPosObj[2][4], nOpcNw, "U_DELA065B()", "U_DELA065B()",,,,,,,,, aNwHead, aNwCols)

bOK     := {|| IIf(oGetD:TudoOk(), (lGrv := .T.,  oDlg:End()), .F.)}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOK, bCancel)

If !lGrv
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gravacao dos Registros ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotLin  := Len(oGetD:aCols)
npCodPir := P_nwFieldPos(oGetD, "PBR_CODPIR")

dbSelectArea("PBR")
dbSetOrder(1) // PBR_FILIAL+PBR_CODGRP+PBR_CODPIR

For i := 1 to nTotLin
	If dbSeek(xFilial("PBR") + M->U0_CODIGO + AllTrim(P_nwFieldGet(oGetD, "PBR_CODPIR", i)))
		RecLock("PBR", .F.)
		If P_nwDeleted(oGetD, i)
			dbDelete()
		Else
			For j := 1 to nUsado
				If oGetD:aHeader[j][10] <> "V"
					If rTrim(oGetD:aHeader[j][2]) == "PBR_CODPIR"
						FieldPut(FieldPos(oGetD:aHeader[j][2]), AllTrim(oGetD:aCols[i][j]))
					Else
						FieldPut(FieldPos(oGetD:aHeader[j][2]), oGetD:aCols[i][j])
					EndIf
				EndIf
			Next j
		EndIf
		msUnlock()
	Else
		If !P_nwDeleted(oGetD, i)
			RecLock("PBR", .T.)
			PBR->PBR_FILIAL := xFilial("PBR")
			PBR->PBR_CODGRP := M->U0_CODIGO
			For j := 1 to nUsado
				If oGetD:aHeader[j][10] <> "V"
					If rTrim(oGetD:aHeader[j][2]) == "PBR_CODPIR"
						FieldPut(FieldPos(oGetD:aHeader[j][2]), AllTrim(oGetD:aCols[i][j]))
					Else
						FieldPut(FieldPos(oGetD:aHeader[j][2]), oGetD:aCols[i][j])
					EndIf
				EndIf
			Next j
			msUnlock()
		EndIf
	EndIf
Next i

dbSeek(xFilial("PBR") + M->U0_CODIGO)

While !EOF() .And. PBR->(PBR_FILIAL + PBR_CODGRP) == xFilial("PBR") + M->U0_CODIGO
	If aScan(oGetD:aCols, {|x| AllTrim(x[npCodPir]) == AllTrim(PBR->PBR_CODPIR)}) == 0
		RecLock("PBR", .F.)
		dbDelete()
		msUnlock()
	EndIf
	
	dbSkip()
End

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA065B     บAutor  ณPaulo Benedet         บ Data ณ 04/01/08 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da getdados                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T. - Linha correta                                           บฑฑ
ฑฑบ          ณ .F. - Linha incorreta                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina DELA065A                           บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via Pneus                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DELA065B()
Local lRet := .T. // retorno da funcao
Local nTotLin := Len(oGetD:aCols) // total de linhas do acols
Local i // for next

If !P_nwDeleted(oGetD, oGetD:nAt)
	For i := 1 to nTotLin
		If P_nwDeleted(oGetD, i)
			Loop
		EndIf
		
		If i == oGetD:nAt
			Loop
		EndIf
		
		If AllTrim(P_nwFieldGet(oGetD, "PBR_CODPIR", i)) == AllTrim(P_nwFieldGet(oGetD, "PBR_CODPIR", oGetD:nAt))
			msgAlert("C๓digo Despir jแ foi informado!", "Aviso")
			lRet := .F.
			Exit
		EndIf
	Next i
EndIf

Return(lRet)
