#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA006A     บAutor  ณPaulo Benedet         บ Data ณ 21/12/07 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Tela de manutencao do convenio                                บฑฑ
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
Project Function DELA006()

Private aRotina := {{"Pesquisar", "axPesqui", 0, 1},;
	{"Visualizar", "P_DELA006A", 0, 2},;
	{"Incluir", "P_DELA006A", 0, 3},;
	{"Alterar", "P_DELA006A", 0, 4},;
	{"Excluir", "P_DELA006A", 0, 5}}

Private cCadastro := "Convenios"

mBrowse(6,1,22,75,"PA6")

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA006A     บAutor  ณPaulo Benedet         บ Data ณ 21/12/07 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Tela de manutencao do convenio                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cAlias - Alias da tabela em manutencao                        บฑฑ
ฑฑบ          ณ nReg   - Numero do registro sendo alterado                    บฑฑ
ฑฑบ          ณ nOpc   - Numero do botao acionado                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina DELA006                            บฑฑ
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
Project Function DELA006A(cAlias, nReg, nOpc)
Local aTam     := msAdvSize(.T.) // resolucao da tela
Local aObj     := {} // objetos
Local aInf     := {} // posicao dos objetos
Local aPosObj  := {} // array com as posicoes dos objetos
Local aInfo    := {} // array com as posicoes da tela

Local aTitles  := {"Clientes", "Produtos", "Cond Pagto"} // abas do folder
Local aPages   := {"", "", ""} // abas do folder
Local nPosGd1  := 0 // posicao das getdados
Local nPosGd2  := 0 // posicao das getdados
Local nPosGd3  := 0 // posicao das getdados
Local nPosGd4  := 0 // posicao das getdados
Local oDlg, oFold, oEnch // objetos da tela

Local aNwHead1 := {} // aheader folder 1
Local aNwCols1 := {} // acols folder 1
Local cShow1   := "PBO_CODCLI|PBO_LOJCLI|PBO_DSCCLI" // campos que aparecem na getdados 1
Local nUsado1  := 0 // numero de colunas getdados 1
Local aNwHead2 := {} // aheader folder 2
Local aNwCols2 := {} // acols folder 2
Local cShow2   := "PBP_CODGRP|PBP_DSCGRP|PBP_CODPRO|PBP_DSCPRO|PBP_TIPPRC" // campos que aparecem na getdados 2
Local nUsado2  := 0 // numero de colunas getdados 2
Local aNwHead3 := {} // aheader folder 3
Local aNwCols3 := {} // acols folder 3
Local cShow3   := "PBQ_CODPAG|PBQ_DSCPAG" // campos que aparecem na getdados 3
Local nUsado3  := 0 // numero de colunas getdados 3

Local lGrv     := .F. // indica a confirmacao da tela
Local nOpcNw   := 0 // indica o tipo de acao sobre a getdados
Local nTotLin  := 0 // total de linhas do acols
Local npLoja   := 0 // posicao do campo PBM_LOJA
Local bOK // Acao executada apos clicar no botao OK
Local bCancel // Acao executada apos clicar no botao Cancelar
Local i, j // for next

If nOpc == 3 .Or. nOpc == 4
	nOpcNw := GD_INSERT + GD_DELETE + GD_UPDATE
EndIf	

// calcula coordenadas do objeto
aAdd(aObj, {100, 040, .T., .T.})
aAdd(aObj, {100, 060, .T., .T.})

aInfo   := {aTam[1], aTam[2], aTam[3], aTam[4], 3, 3}
aPosObj := msObjSize(aInfo, aObj, .T., .F.)

nPosGd1 := 2
nPosGd2 := 2
nPosGd3 := aPosObj[2][3] - aPosObj[2][1] - 20
nPosGd4 := aPosObj[2][4] - aPosObj[2][2] - 4

// Cria as variaveis da Enchoice (M->?)
If nOpc == 3
	RegToMemory("PA6", .T.)
Else
	RegToMemory("PA6", .F.)
EndIf

// Monta aHeader 1
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PBO")

While !EOF() .And. SX3->X3_ARQUIVO == "PBO"
	If rTrim(SX3->X3_CAMPO) $ cShow1
		If x3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			nUsado1 += 1
			
			aAdd(aNwHead1, {rTrim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO,;
			SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO,;
			SX3->X3_WHEN, SX3->X3_VISUAL, SX3->X3_VLDUSER, SX3->X3_PICTVAR,;
			SX3->X3_OBRIGAT})
		EndIf
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
End

// Carrega aCols 1
dbSelectArea("PBO")
dbSetOrder(1) // PBO_FILIAL+PBO_CODCON+PBO_CODCLI+PBO_LOJCLI
dbSeek(xFilial("PBO") + PA6->PA6_COD)

While !EOF() .And. PBO->(PBO_FILIAL + PBO_CODCON) == xFilial("PBO") + PA6->PA6_COD
	
	aAdd(aNwCols1, Array(nUsado1 + 1))
	For i := 1 to nUsado1
		If aNwHead1[i][10] <> "V"
			aNwCols1[Len(aNwCols1)][i] := FieldGet(FieldPos(aNwHead1[i][2]))
		ElseIf rTrim(aNwHead1[i][2]) == "PBO_DSCCLI"
			aNwCols1[Len(aNwCols1)][i] := RetField("SA1", 1, xFilial("SA1") + PBO->(PBO_CODCLI + PBO_LOJCLI), "A1_NOME")
		EndIf
	Next i
	aNwCols1[Len(aNwCols1)][nUsado1 + 1] := .F.
	
	dbSelectArea("PBO")
	dbSkip()
EndDo

If Empty(aNwCols1)
	aAdd(aNwCols1, Array(nUsado1 + 1))
	For i := 1 to nUsado1
		aNwCols1[Len(aNwCols1)][i] := CriaVar(aNwHead1[i][2], .T.)
	Next i
	aNwCols1[Len(aNwCols1)][nUsado1 + 1] := .F.
EndIf

// Monta aHeader 2
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PBP")

While !EOF() .And. SX3->X3_ARQUIVO == "PBP"
	If rTrim(SX3->X3_CAMPO) $ cShow2
		If x3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			nUsado2 += 1
			
			aAdd(aNwHead2, {rTrim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO,;
			SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO,;
			SX3->X3_WHEN, SX3->X3_VISUAL, SX3->X3_VLDUSER, SX3->X3_PICTVAR,;
			SX3->X3_OBRIGAT})
		EndIf
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
End

// Carrega aCols 2
dbSelectArea("PBP")
dbSetOrder(1) // PBP_FILIAL+PBP_CODCON+PBP_CODGRP+PBP_CODPRO
dbSeek(xFilial("PBP") + PA6->PA6_COD)

While !EOF() .And. PBP->(PBP_FILIAL + PBP_CODCON) == xFilial("PBP") + PA6->PA6_COD
	
	aAdd(aNwCols2, Array(nUsado2 + 1))
	For i := 1 to nUsado2
		If aNwHead2[i][10] <> "V"
			aNwCols2[Len(aNwCols2)][i] := FieldGet(FieldPos(aNwHead2[i][2]))
		ElseIf rTrim(aNwHead2[i][2]) == "PBP_DSCGRP"
			aNwCols2[Len(aNwCols2)][i] := RetField("SBM", 1, xFilial("SBM") + PBP->PBP_CODGRP, "BM_DESC")
		ElseIf rTrim(aNwHead2[i][2]) == "PBP_DSCPRO"
			aNwCols2[Len(aNwCols2)][i] := RetField("SB1", 1, xFilial("SB1") + PBP->PBP_CODPRO, "B1_DESC")
		EndIf
	Next i
	aNwCols2[Len(aNwCols2)][nUsado2 + 1] := .F.
	
	dbSelectArea("PBP")
	dbSkip()
EndDo

If Empty(aNwCols2)
	aAdd(aNwCols2, Array(nUsado2 + 1))
	For i := 1 to nUsado2
		aNwCols2[Len(aNwCols2)][i] := CriaVar(aNwHead2[i][2], .T.)
	Next i
	aNwCols2[Len(aNwCols2)][nUsado2 + 1] := .F.
EndIf

// Monta aHeader 3
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PBQ")

While !EOF() .And. SX3->X3_ARQUIVO == "PBQ"
	If rTrim(SX3->X3_CAMPO) $ cShow3
		If x3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			nUsado3 += 1
			
			aAdd(aNwHead3, {rTrim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO,;
			SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO,;
			SX3->X3_WHEN, SX3->X3_VISUAL, SX3->X3_VLDUSER, SX3->X3_PICTVAR,;
			SX3->X3_OBRIGAT})
		EndIf
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
End

// Carrega aCols 3
dbSelectArea("PBQ")
dbSetOrder(1) // PBQ_FILIAL+PBQ_CODCON+PBQ_CODPAG
dbSeek(xFilial("PBQ") + PA6->PA6_COD)

While !EOF() .And. PBQ->(PBQ_FILIAL + PBQ_CODCON) == xFilial("PBQ") + PA6->PA6_COD
	
	aAdd(aNwCols3, Array(nUsado3 + 1))
	For i := 1 to nUsado3
		If aNwHead3[i][10] <> "V"
			aNwCols3[Len(aNwCols3)][i] := FieldGet(FieldPos(aNwHead3[i][2]))
		ElseIf rTrim(aNwHead3[i][2]) == "PBQ_DSCPAG"
			aNwCols3[Len(aNwCols3)][i] := RetField("SE4", 1, xFilial("SE4") + PBQ->PBQ_CODPAG, "E4_DESCRI")
		EndIf
	Next i
	aNwCols3[Len(aNwCols3)][nUsado3 + 1] := .F.
	
	dbSelectArea("PBQ")
	dbSkip()
EndDo

If Empty(aNwCols3)
	aAdd(aNwCols3, Array(nUsado3 + 1))
	For i := 1 to nUsado3
		aNwCols3[Len(aNwCols3)][i] := CriaVar(aNwHead3[i][2], .T.)
	Next i
	aNwCols3[Len(aNwCols3)][nUsado3 + 1] := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta dialogo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define msDialog oDlg Title cCadastro From aTam[7],0 to aTam[6],aTam[5] of oMainWnd Pixel

oEnch := msMGet():New(cAlias, nReg, nOpc,,,,, aPosObj[1],,,,, oDlg,,,, .F.,,.T.)

oFold  := tFolder():New(aPosObj[2][1], aPosObj[2][2], aTitles, aPages, oDlg,,,, .T., .F., aPosObj[2][4] - aPosObj[2][2], aPosObj[2][3] - aPosObj[2][1])
oGetD1 := msNewGetDados():New(nPosGd1, nPosGd2, nPosGd3, nPosGd4, nOpcNw, "P_DELA006B(oGetD1, oGetD1:nAt, 1)", "P_DELA006B(oGetD1, oGetD1:nAt, 1)",,,,,,,, oFold:aDialogs[1], aNwHead1, aNwCols1)
oGetD2 := msNewGetDados():New(nPosGd1, nPosGd2, nPosGd3, nPosGd4, nOpcNw, "P_DELA006B(oGetD2, oGetD2:nAt, 2)", "P_DELA006B(oGetD2, oGetD2:nAt, 2)",,,,,,,, oFold:aDialogs[2], aNwHead2, aNwCols2)
oGetD3 := msNewGetDados():New(nPosGd1, nPosGd2, nPosGd3, nPosGd4, nOpcNw, "P_DELA006B(oGetD3, oGetD3:nAt, 3)", "P_DELA006B(oGetD3, oGetD3:nAt, 3)",,,,,,,, oFold:aDialogs[3], aNwHead3, aNwCols3)

bOK     := {|| IIf(Obrigatorio(oEnch:aGets, oEnch:aTela) .And. oGetD1:TudoOk() .And. oGetD2:TudoOk() .And. oGetD3:TudoOk(), (lGrv := .T.,  oDlg:End()), .F.)}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOK, bCancel)

If !lGrv
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gravacao dos Registros ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Gravacao do aCols 1
nTotLin  := Len(oGetD1:aCols)
npCodCli := P_nwFieldPos(oGetD1, "PBO_CODCLI")
npLojCli := P_nwFieldPos(oGetD1, "PBO_LOJCLI")

dbSelectArea("PBO")
dbSetOrder(1) // PBO_FILIAL+PBO_CODCON+PBO_CODCLI+PBO_LOJCLI

For i := 1 to nTotLin
	If dbSeek(xFilial("PBO") + M->PA6_COD + oGetD1:aCols[i][npCodCli] + oGetD1:aCols[i][npLojCli])
		RecLock("PBO", .F.)
		If P_nwDeleted(oGetD1, i)
			dbDelete()
		Else
			For j := 1 to nUsado1
				If oGetD1:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD1:aHeader[j][2]), oGetD1:aCols[i][j])
				EndIf
			Next j
		EndIf
		msUnlock()
	Else
		If !P_nwDeleted(oGetD1, i)
			RecLock("PBO", .T.)
			PBO->PBO_FILIAL := xFilial("PBO")
			PBO->PBO_CODCON := M->PA6_COD
			For j := 1 to nUsado1
				If oGetD1:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD1:aHeader[j][2]), oGetD1:aCols[i][j])
				EndIf
			Next j
			msUnlock()
		EndIf
	EndIf
Next i

dbSeek(xFilial("PBO") + M->PA6_COD)

While !EOF() .And. PBO->(PBO_FILIAL + PBO_CODCON) == xFilial("PBO") + M->PA6_COD
	If aScan(oGetD1:aCols, {|x| AllTrim(x[npCodCli]) + AllTrim(x[npLojCli]) == PBO->(PBO_CODCLI + PBO_LOJCLI)}) == 0
		RecLock("PBO", .F.)
		dbDelete()
		msUnlock()
	EndIf
	
	dbSkip()
End

// Gravacao do aCols 2
nTotLin  := Len(oGetD2:aCols)
npCodGrp := P_nwFieldPos(oGetD2, "PBP_CODGRP")
npCodPro := P_nwFieldPos(oGetD2, "PBP_CODPRO")

dbSelectArea("PBP")
dbSetOrder(1) // PBP_FILIAL+PBP_CODCON+PBP_CODGRP+PBP_CODPRO

For i := 1 to nTotLin
	If dbSeek(xFilial("PBP") + M->PA6_COD + oGetD2:aCols[i][npCodGrp] + oGetD2:aCols[i][npCodPro])
		RecLock("PBP", .F.)
		If P_nwDeleted(oGetD2, i)
			dbDelete()
		Else
			For j := 1 to nUsado2
				If oGetD2:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD2:aHeader[j][2]), oGetD2:aCols[i][j])
				EndIf
			Next j
		EndIf
		msUnlock()
	Else
		If !P_nwDeleted(oGetD2, i)
			RecLock("PBP", .T.)
			PBP->PBP_FILIAL := xFilial("PBP")
			PBP->PBP_CODCON := M->PA6_COD
			For j := 1 to nUsado2
				If oGetD2:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD2:aHeader[j][2]), oGetD2:aCols[i][j])
				EndIf
			Next j
			msUnlock()
		EndIf
	EndIf
Next i

dbSeek(xFilial("PBP") + M->PA6_COD)

While !EOF() .And. PBP->(PBP_FILIAL + PBP_CODCON) == xFilial("PBP") + M->PA6_COD
	If aScan(oGetD2:aCols, {|x| x[npCodGrp] + x[npCodPro] == PBP->(PBP_CODGRP + PBP_CODPRO)}) == 0
		RecLock("PBP", .F.)
		dbDelete()
		msUnlock()
	EndIf
	
	dbSkip()
End

// Gravacao do aCols 3
nTotLin  := Len(oGetD3:aCols)
npCodPag := P_nwFieldPos(oGetD3, "PBQ_CODPAG")

dbSelectArea("PBQ")
dbSetOrder(1) // PBQ_FILIAL+PBQ_CODCON+PBQ_CODPAG

For i := 1 to nTotLin
	If dbSeek(xFilial("PBQ") + M->PA6_COD + oGetD3:aCols[i][npCodPag])
		RecLock("PBQ", .F.)
		If P_nwDeleted(oGetD3, i)
			dbDelete()
		Else
			For j := 1 to nUsado3
				If oGetD3:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD3:aHeader[j][2]), oGetD3:aCols[i][j])
				EndIf
			Next j
		EndIf
		msUnlock()
	Else
		If !P_nwDeleted(oGetD3, i)
			RecLock("PBQ", .T.)
			PBQ->PBQ_FILIAL := xFilial("PBQ")
			PBQ->PBQ_CODCON := M->PA6_COD
			For j := 1 to nUsado3
				If oGetD3:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD3:aHeader[j][2]), oGetD3:aCols[i][j])
				EndIf
			Next j
			msUnlock()
		EndIf
	EndIf
Next i

dbSeek(xFilial("PBQ") + M->PA6_COD)

While !EOF() .And. PBQ->(PBQ_FILIAL + PBQ_CODCON) == xFilial("PBQ") + M->PA6_COD
	If aScan(oGetD3:aCols, {|x| x[npCodPag] == PBQ->PBQ_CODPAG}) == 0
		RecLock("PBQ", .F.)
		dbDelete()
		msUnlock()
	EndIf
	
	dbSkip()
End

// Gravacao da enchoice
dbSelectArea("PA6")
dbSetOrder(1) // PA6_FILIAL+PA6_COD
nTotLin := fCount()

If dbSeek(xFilial("PA6") + M->PA6_COD)
	RecLock("PA6", .F.)
Else
	RecLock("PA6", .T.)
	PA6->PA6_FILIAL := xFilial("PA6")
	PA6->PA6_COD    := M->PA6_COD
EndIf

For i := 1 to nTotLin
	If !(FieldName(i) $ "PA6_FILIAL|PA6_COD")
		FieldPut(i, &("M->" + FieldName(i)))
	EndIf
Next i
msUnlock()

// Grava memo
If !Empty(M->PA6_MEMOBS)
	If Empty(PA6->PA6_CODOBS)
		MSMM(, 80,, M->PA6_MEMOBS, 1,,, "PA6", "PA6_CODOBS")
	Else
		MSMM(PA6->PA6_CODOBS, 80,, M->PA6_MEMOBS, 1,,, "PA6", "PA6_CODOBS")
	EndIf
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA006B     บAutor  ณPaulo Benedet         บ Data ณ 21/12/07 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da getdados                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ oObj - Objeto NewGetDados                                     บฑฑ
ฑฑบ          ณ nLin - Numero da linha a ser validada                         บฑฑ
ฑฑบ          ณ nGet - Numero da getdados a ser validada                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T. - Linha correta                                           บฑฑ
ฑฑบ          ณ .F. - Linha incorreta                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina DELA006A                           บฑฑ
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
Project Function DELA006B(oObj, nLin, nGet)
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
		
		If nGet == 1
			If P_nwFieldGet(oObj, "PBO_CODCLI", i) + P_nwFieldGet(oObj, "PBO_LOJCLI", i) == P_nwFieldGet(oObj, "PBO_CODCLI", nLin) + P_nwFieldGet(oObj, "PBO_LOJCLI", nLin)
				msgAlert("Cliente / loja jแ informado!", "Aviso")
				lRet := .F.
				Exit
			EndIf
		ElseIf nGet == 2
			If P_nwFieldGet(oObj, "PBP_CODGRP", i) + P_nwFieldGet(oObj, "PBP_CODPRO", i) == P_nwFieldGet(oObj, "PBP_CODGRP", nLin) + P_nwFieldGet(oObj, "PBP_CODPRO", nLin)
				msgAlert("Grupo / produto jแ informado!", "Aviso")
				lRet := .F.
				Exit
			EndIf
		ElseIf nGet == 3
			If P_nwFieldGet(oObj, "PBQ_CODPAG", i) == P_nwFieldGet(oObj, "PBQ_CODPAG", nLin)
				msgAlert("Condi็ใo jแ informada!", "Aviso")
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next i
EndIf

Return(lRet)
