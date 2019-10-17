#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DELA003   ºAutor  ³Paulo Benedet          º Data ³  02/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina de manutencao do cadastro de pecas x veiculos           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cAlias - Alias do mbrowse                                     º±±
±±º          ³ nReg   - Numero do registro posicionado                       º±±
±±º          ³ nOpcX  - Opcao do aRotina                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina acionada atraves do botao incluido na tela de produtos  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DELA003(cAlias, nReg, nOpcx)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³array asize - tamanho da dialog e area de trabalho                       ³
//³1 - linha inicial area de trabalho                                       ³
//³2 - coluna inicial area de trabalho                                      ³
//³3 - linha final area de trabalho                                         ³
//³4 - coluna final area de trabalho                                        ³
//³5 - coluna final dialog                                                  ³
//³6 - linha final dialog                                                   ³
//³7 - linha inicial dialog                                                 ³
//³                                                                         ³
//³array aobjects - tamanho padrao dos objetos para calculo das posicoes    ³
//³1 - tamanho x                                                            ³
//³2 - tamanho y                                                            ³
//³3 - dimensiona x                                                         ³
//³4 - dimensiona y                                                         ³
//³5 - retorna dimensoes x e y (size) ao inves de linha / coluna final      ³
//³                                                                         ³
//³array ainfo - tamanho da area onde sera calculada as posicoes dos objetos³
//³1 - posicao inicial x                                                    ³
//³2 - posicao inicial y                                                    ³
//³3 - posicao final x                                                      ³
//³4 - posicao final y                                                      ³
//³5 - espaco lateral entre os objetos                                      ³
//³6 - espaco vertical entre os objetos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aEstIni := GetArea()
Local aEstPA0 := PA0->(GetArea())
Local aEstPA1 := PA1->(GetArea())
Local aEstPA2 := PA2->(GetArea())
Local aEstSBM := SBM->(GetArea())
Local aEstSZ3 := SZ3->(GetArea())
Local aEstSZ4 := SZ4->(GetArea())

Local aSize    := {}
Local aObjects := {}
Local aInfo    := {}
Local aPosObj  := {}
Local aPosGet  := {}
Local nUsado   := 0
Local npCodMod := 0
Local oDlg
Local oGet
Local i

Private cCodPro := SB1->B1_COD
Private cCodGrp := SB1->B1_GRUPO
Private cCodCat := SB1->B1_CATEG
Private cCodEsp := SB1->B1_SPECIE2
Private cDesPro := SB1->B1_DESC
Private cDesGrp := ""
Private cDesCat := ""
Private cDesEsp := ""

Private aHeader := {}
Private aCols   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca descricoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SBM")
dbSetOrder(1) // BM_FILIAL
dbSeek(xFilial("SBM") + SB1->B1_GRUPO)

dbSelectArea("SZ6")
dbSetOrder(1)
dbSeek(xFilial("SZ6") + SB1->B1_CATEG)

dbSelectArea("SZ7")
dbSetOrder(1)
dbSeek(xFilial("SZ7") + SB1->B1_SPECIE2)

cDesGrp := SBM->BM_DESC
cDesCat := SZ6->Z6_DESC
cDesEsp := SZ7->Z7_DESC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("PA2")

While !EOF() .And. X3_ARQUIVO == "PA2"
	If x3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		nUsado += 1
		
		aAdd(aHeader, {Trim(X3_TITULO), X3_CAMPO, X3_PICTURE, ;
		X3_TAMANHO, X3_DECIMAL, X3_VLDUSER, ;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
	EndIf
	
	If rTrim(X3_CAMPO) == "PA2_CODMOD"
		npCodMod := nUsado
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PA0")
dbSetOrder(1)

dbSelectArea("PA1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega aCols³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PA2")
dbSetOrder(1)

If dbSeek(xFilial("PA2") + cCodPro)
	While !EOF();
		.And. PA2_FILIAL == xFilial("PA2");
		.And. PA2_CODPRO == cCodPro
		
		aAdd(aCols, Array(nUsado + 1))
		
		For i := 1 to nUsado
			If rTrim(aHeader[i][2]) == "PA2_DSCMOD"
				PA1->(dbSeek(xFilial("PA1") + aCols[Len(aCols)][npCodMod]))
				aCols[Len(aCols)][i] := PA1->PA1_DESC
			ElseIf rTrim(aHeader[i][2]) == "PA2_DSCMAR"
				PA1->(dbSeek(xFilial("PA1") + aCols[Len(aCols)][npCodMod]))
				PA0->(dbSeek(xFilial("PA0") + PA1->PA1_CODMAR))
				aCols[Len(aCols)][i] := PA0->PA0_DESC
			Else
				aCols[Len(aCols)][i] := FieldGet(FieldPos(aHeader[i][2]))
			EndIf
		Next i
		
		aCols[Len(aCols)][nUsado + 1] := .F.
		
		dbSelectArea("PA2")
		dbSkip()
	EndDo
Else
	aCols := {Array(nUsado + 1)}
	aCols[1][nUsado + 1] := .F.
	
	For i := 1 to nUsado
		If rTrim(aHeader[i][2]) == "PA2_ITEM"
			aCols[1][i] := StrZero(1, TamSx3("PA2_ITEM")[1])
		Else
			aCols[1][i] := CriaVar(aHeader[i][2])
		EndIf
	Next i
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Devolve dimensoes da tela do usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := msAdvSize(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³calcula coordenadas do objeto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aObjects, {100, 33, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})

aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 5, 5}
aPosObj := msObjSize(aInfo, aObjects, .T.)
aPosGet := msObjGetPos(aSize[3] - aSize[1], 390, {{5,30,90,210,235,272}})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta dialogo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define msDialog oDlg Title OemtoAnsi(cCadastro) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel

nLinSay := aPosObj[1][1] + 5

@ nLinSay + 2,aPosGet[1][1] Say OemToAnsi("Produto") Size 31,9 of oDlg Pixel
@ nLinSay,aPosGet[1][2] msGet cCodPro When .F. Size 55,10 of oDlg Pixel
@ nLinSay,aPosGet[1][3] msGet cDesPro When .F. Size 115,10 of oDlg Pixel

@ nLinSay + 2,aPosGet[1][4] Say OemToAnsi("Grupo") Size 31,9 of oDlg Pixel
@ nLinSay,aPosGet[1][5] msGet cCodGrp When .F. Size 31,10 of oDlg Pixel
@ nLinSay,aPosGet[1][6] msGet cDesGrp When .F. Size 115,10 of oDlg Pixel

nLinSay += 20

@ nLinSay + 2,aPosGet[1][1] Say OemToAnsi("Categoria") Size 31,9 of oDlg Pixel
@ nLinSay,aPosGet[1][2] msGet cCodCat When .F. Size 55,10 of oDlg Pixel
@ nLinSay,aPosGet[1][3] msGet cDesCat When .F. Size 115,10 of oDlg Pixel

@ nLinSay + 2,aPosGet[1][4] Say OemToAnsi("Especie") Size 31,9 of oDlg Pixel
@ nLinSay,aPosGet[1][5] msGet cCodEsp When .F. Size 31,10 of oDlg Pixel
@ nLinSay,aPosGet[1][6] msGet cDesEsp When .F. Size 115,10 of oDlg Pixel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento do nOpcX para rotina de copia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If P_NaPilha("A010COPIA")
	nOpcX := 1
EndIf

oGet := msGetDados():New(aPosObj[2][1], aPosObj[2][2], aPosObj[2][3], aPosObj[2][4], nOpcX, "P_DA003LinOk", "P_DA003TudOk", "+PA2_ITEM", .T.,,, .T., 999)

Activate msDialog oDlg on Init EnchoiceBar(oDlg, {|| Iif(P_DA003TudOk(),(Grava(), oDlg:End()),.F.)}, {|| oDlg:End()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aEstPA0)
RestArea(aEstPA1)
RestArea(aEstPA2)
RestArea(aEstSBM)
RestArea(aEstSZ3)
RestArea(aEstSZ4)
RestArea(aEstIni)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Grava     ºAutor  ³Paulo Benedet          º Data ³  29/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Efetiva as informacoes de pecas e veiculos no banco de dados   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina acionada apos a confirmacao da tela de pecas x veiculo  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grava()

Local nUsado := Len(aHeader)
Local nLinha := Len(aCols)
Local nItem  := 0
Local nTamIt := TamSX3("PA2_ITEM")[1]
Local i, j

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona arquivo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("PA2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava acols³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to nLinha

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se linha esta deletada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCols[i][nUsado + 1]
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Acrescenta item³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nItem += 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava item³
	//ÀÄÄÄÄÄÄÄÄÄÄÙ
	If dbSeek(xFilial("PA2") + cCodPro + StrZero(nItem, nTamIt))
		RecLock("PA2", .F.)
	Else
		RecLock("PA2", .T.)
	EndIf
	
	For j := 1 to nUsado
		If aHeader[j][10] != "V"
			FieldPut(FieldPos(aHeader[j][2]), aCols[i][j])
		EndIf
	Next j
	
	PA2_FILIAL := xFilial("PA2")
	PA2_ITEM   := StrZero(nItem, nTamIt)
	PA2_CODPRO := cCodPro
	PA2_CODCAT := cCodCat
	PA2_CODESP := cCodEsp
	PA2_CODGRP := cCodGrp
	msUnlock()
Next i

nItem += 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apaga linhas restantes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSeek(xFilial("PA2") + cCodPro + StrZero(nItem, nTamIt), .T.)

While !EOF();
	.And. PA2_FILIAL == xFilial("PA2");
	.And. PA2_CODPRO == cCodPro
	
	RecLock("PA2", .F.)
	dbDelete()
	msUnlock()
	
	dbSelectArea("PA2")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Forca gravacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbCommit()

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³Grava flag³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SB1", .F.)
B1_FLGPA2 := .T.
msUnlock()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DA003LinOkºAutor  ³Paulo Benedet          º Data ³  29/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Valida as informacoes da linha da getdados                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³.T. se as validacoes estiverem corretas, .F. caso contrario    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina acionada apos a confirmacao da tela de pecas x veiculo  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DA003LinOk()

Local npAnoDe  := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANODE"})
Local npAnoAte := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANOATE"})
Local nUsado := Len(aHeader)
Local lRet := .T.
Local i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se linha esta deletada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aCols[n][nUsado + 1]
	Return(.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se campos estao preenchidos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to nUsado
	If Empty(aCols[n][i]) .And. aHeader[i][10] != "V"
		MsgAlert("O campo '" + aHeader[i][1] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica campos data³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aCols[n][npAnoDe] > aCols[n][npAnoAte]
	MsgAlert("Campo 'AnoDe' nao pode ser maior que 'AnoAte'!", "Aviso")
	lRet := .F.
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DA003TudOkºAutor  ³Paulo Benedet          º Data ³  29/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Valida as informacoes da getdados                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³.T. se as validacoes estiverem corretas, .F. caso contrario    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Rotina acionada apos a confirmacao da tela de pecas x veiculo  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista      ³ Data   ³Bops  ³Manutencao Efetuada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DA003TudOk()

Local npAnoDe  := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANODE"})
Local npAnoAte := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANOATE"})
Local nUsado := Len(aHeader)
Local nLinha := Len(aCols)
Local i, j

For i := 1 to nLinha

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se linha esta deletada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCols[i][nUsado + 1]
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se campos estao preenchidos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For j := 1 to nUsado
		If Empty(aCols[i][j]) .And. aHeader[j][10] != "V"
			MsgAlert("O campo '" + aHeader[j][1] + "' deve ser informado!", "Aviso")
			Return(.F.)
		EndIf
	Next j
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica campos data³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCols[i][npAnoDe] > aCols[i][npAnoAte]
		MsgAlert("Campo 'AnoDe' nao pode ser maior que 'AnoAte'!", "Aviso")
		Return(.F.)
	EndIf
Next i

Return(.T.)