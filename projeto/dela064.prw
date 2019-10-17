/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA064      บAutor  ณPaulo Benedet         บ Data ณ 13/12/07 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Tela de bloqueio Tab Preco X Lojas X Tipo Venda               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina os010btn                           บฑฑ
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
Project Function DELA064()
Local aArea    := GetArea()
Local aTam     := msAdvSize(.T.) // resolucao da tela
Local aObj     := {} // objetos
Local aInf     := {} // posicao dos objetos
Local aPosObj  := {} // array com as posicoes dos objetos
Local cShow    := "PBN_ITEM|PBN_LOJA|PBN_DSCLOJ|PBN_TPVEND" // campos que aparecem na getdados
Local aNwHead  := {} // aheader
Local aNwCols  := {} // acols
Local nUsado   := 0 // numero de colunas
Local lGrv     := .F. // indica a confirmacao da tela
Local nOpcNw   := 0 // indica o tipo de acao sobre a getdados
Local nTotLin  := 0 // total de linhas do acols
Local nItem    := 0 // item do registro gravado
Local nTamIt   := TamSX3("PBN_ITEM")[1] // tamanho do campo item
Local bOK // Acao executada apos clicar no botao OK
Local bCancel // Acao executada apos clicar no botao Cancelar
Local i, j // for next

// Permite alterar a getdados somente no modo de alteracao da tabela
If Inclui .Or. Altera
	nOpcNw := GD_INSERT + GD_DELETE + GD_UPDATE
EndIf

// calcula coordenadas do objeto
aAdd(aObj, {100, 100, .T., .T.})

aInfo   := {aTam[1], aTam[2], aTam[3], aTam[4], 3, 3}
aPosObj := msObjSize(aInfo, aObj, .T., .F.)

// Monta aHeader
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PBN")

While !EOF() .And. SX3->X3_ARQUIVO == "PBN"
	If rTrim(SX3->X3_CAMPO) $ cShow
		If x3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			nUsado += 1
			
			aAdd(aNwHead, {rTrim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO,;
			SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO,;
			SX3->X3_WHEN, SX3->X3_VISUAL, SX3->X3_VLDUSER, SX3->X3_PICTVAR,;
			SX3->X3_OBRIGAT})
		EndIf
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
End

// Carrega aCols
dbSelectArea("PBN")
dbSetOrder(1) // PBN_FILIAL+PBN_CODTAB+PBN_ITEM
dbSeek(xFilial("PBN") + DA0->DA0_CODTAB)

While !EOF() .And. PBN->(PBN_FILIAL + PBN_CODTAB) == xFilial("PBN") + DA0->DA0_CODTAB
	
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		If aNwHead[i][10] <> "V"
			aNwCols[Len(aNwCols)][i] := FieldGet(FieldPos(aNwHead[i][2]))
		ElseIf rTrim(aNwHead[i][2]) == "PBN_DSCLOJ"
			aNwCols[Len(aNwCols)][i] := RetField("SLJ", 1, xFilial("SLJ") + PBN->PBN_LOJA, "LJ_NOME")
		EndIf
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
	
	dbSelectArea("PBN")
	dbSkip()
EndDo

If Empty(aNwCols)
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		If rTrim(aNwHead[i][2]) == "PBN_ITEM"
			aNwCols[Len(aNwCols)][i] := StrZero(1, nTamIt)
		Else
			aNwCols[Len(aNwCols)][i] := CriaVar(aNwHead[i][2], .T.)
		EndIf
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta dialogo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define msDialog oDlg Title cCadastro + " - Bloqueios" From aTam[7],0 to aTam[6],aTam[5] of oMainWnd Pixel

oGetD := msNewGetDados():New(aPosObj[1][1], aPosObj[1][2], aPosObj[1][3], aPosObj[1][4], nOpcNw, "P_DELA064A(oGetD, oGetD:nAt)", "P_DELA064A(oGetD, oGetD:nAt)", "+PBN_ITEM",,,,,,,, aNwHead, aNwCols)

bOK     := {|| IIf(oGetD:TudoOk(), (lGrv := .T.,  oDlg:End()), .F.)}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOK, bCancel)

If !lGrv
	RestArea(aArea)
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gravacao dos Registros ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotLin := Len(oGetD:aCols)
nItem   := 1

dbSelectArea("PBN")
dbSetOrder(1) // PBN_FILIAL+PBN_CODTAB+PBN_ITEM

For i := 1 to nTotLin
	If P_nwDeleted(oGetD, i)
		Loop
	EndIf
	
	If dbSeek(xFilial("PBN") + DA0->DA0_CODTAB + StrZero(nItem, nTamIt))
		RecLock("PBN", .F.)
	Else
		RecLock("PBN", .T.)
		PBN->PBN_FILIAL := xFilial("PBN")
		PBN->PBN_CODTAB := DA0->DA0_CODTAB
	EndIf
	
	For j := 1 to nUsado
		If oGetD:aHeader[j][10] <> "V"
			If rTrim(oGetD:aHeader[j][2]) == "PBN_ITEM"
				PBN->PBN_ITEM := StrZero(nItem, nTamIt)
			Else
				FieldPut(FieldPos(oGetD:aHeader[j][2]), oGetD:aCols[i][j])
			EndIf
		EndIf
	Next j
	msUnlock()
	
	nItem += 1
Next i

dbSeek(xFilial("PBN") + DA0->DA0_CODTAB + StrZero(nItem, nTamIt))

While !EOF() .And. PBN->(PBN_FILIAL + PBN_CODTAB) == xFilial("PBN") + DA0->DA0_CODTAB
	RecLock("PBN", .F.)
	dbDelete()
	msUnlock()
	
	dbSkip()
End

RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA064A     บAutor  ณPaulo Benedet         บ Data ณ 13/12/07 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da getdados                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ oObj - Objeto NewGetDados                                     บฑฑ
ฑฑบ          ณ nLin - Numero da linha                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T. - Linha correta                                           บฑฑ
ฑฑบ          ณ .F. - Linha incorreta                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina DELA064                            บฑฑ
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
Project Function DELA064A(oObj, nLin)
Local lRet := .T. // retorno da funcao
Local nTotLin := Len(oObj:aCols) // total de linhas do acols
Local i // for next

If !P_nwDeleted(oObj, nLin)
	For i := 1 to nTotLin
		If P_nwDeleted(oObj, i)
			Loop
		EndIf
		
		If i == nLin
			Loop
		EndIf
		
		If P_nwFieldGet(oObj, "PBN_LOJA", i) + P_nwFieldGet(oObj, "PBN_TPVEND", i) == P_nwFieldGet(oObj, "PBN_LOJA", nLin) + P_nwFieldGet(oObj, "PBN_TPVEND", nLin)
			msgAlert("Loja e Tipo de Venda jแ informados!", "Aviso")
			lRet := .F.
			Exit
		EndIf
	Next i
EndIf

Return(lRet)
