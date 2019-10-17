#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA049  บAutor  ณPaulo Benedet             บ Data ณ 23/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Grupo Atendimento X Tabela Precos                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada via menu                                       บฑฑ
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
Project Function DELA049()
Private aRotina   := {}
Private cCadastro := OemtoAnsi("Grp Atend X Tab Pre็os")

aAdd(aRotina, {"Pesquisar" , "axPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "P_D49Man", 0, 2})
aAdd(aRotina, {"Incluir"   , "P_D49Man", 0, 3})
aAdd(aRotina, {"Alterar"   , "P_D49Man", 0, 4})
aAdd(aRotina, {"Excluir"   , "P_D49Man", 0, 5})

dbSelectArea("PAP")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,75,"PAP")

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ D49MAN   บAutor  ณPaulo Benedet             บ Data ณ 23/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Manutencao no cadastro                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cAlias - Alias do mbrowse                                     บฑฑ
ฑฑบ          ณ nReg   - Numero do registro posicionado                       บฑฑ
ฑฑบ          ณ nOpcX  - Opcao do aRotina                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo programa DELA049                          บฑฑ
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
Project Function D49Man(cAlias, nReg, nOpcX)
Local aSize      := msAdvSize(.T.) // dimensoes da tela
Local aObjects   := {} // proporcoes dos objetos
Local aInfo      := {} // dimensoes da tela
Local aPosObj    := {} // dimensoes dos objetos
Local cCpoGdShow := "PAP_CODTAB/PAP_DSCTAB" // campos da getdados
Local nUsado     := 0 // numero de colunas da getdados
Local nOpc       := 0 // resposta do usuario
Local nTotLin    := 0 // numero de linhas da get dados
Local i

Private cCodGrp := Space(TamSX3("PAP_GRPATD")[1]) // codigo do grupo de atendimento
Private cDscGrp := "" // descricao do grupo de atendimento
Private aHeader := {}
Private aCols   := {}
Private oDscGrp
Private oDlg
Private oGd

If nOpcX <> 3
	dbSelectArea("SU0")
	dbSetOrder(1)
	If dbSeek(xFilial("SU0") + PAP->PAP_GRPATD)
		cCodGrp := PAP->PAP_GRPATD
		cDscGrp := SU0->U0_NOME
	EndIf
EndIf

// carrega aheader
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PAP")

While !EOF() .And. X3_ARQUIVO == "PAP"
	If x3Uso(X3_USADO);
		.And. cNivel >= X3_NIVEL;
		.And. X3_CAMPO $ cCpoGdShow
		
		aAdd(aHeader, {Trim(X3_TITULO), X3_CAMPO, X3_PICTURE, ;
		X3_TAMANHO, X3_DECIMAL, X3_VLDUSER, ;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
EndDo

nUsado := Len(aHeader)

// carrega acols
dbSelectArea("PAP")
dbSetOrder(1) //PAP_FILIAL+PAP_GRPATD
dbSeek(xFilial("PAP") + cCodGrp)

While !EOF();
	.And. PAP_FILIAL == xFilial("PAP");
	.And. PAP_GRPATD == cCodGrp
	
	aAdd(aCols, Array(nUsado + 1))
	For i := 1 to nUsado
		If aHeader[i][10] == "V"
			aCols[Len(aCols)][i] := CriaVar(aHeader[i][2])
		Else
			aCols[Len(aCols)][i] := FieldGet(FieldPos(aHeader[i][2]))
		EndIf
	Next i
	aCols[Len(aCols)][nUsado + 1] := .F.
	
	dbSelectArea("PAP")
	dbSkip()
EndDo

If Len(aCols) == 0
	aAdd(aCols, Array(nUsado + 1))
	For i := 1 to nUsado
		aCols[1][i] := CriaVar(aHeader[i][2], .F.)
	Next i
	aCols[1][nUsado + 1] := .F.
EndIf

// calcula coordenadas do objeto
aAdd(aObjects, {100, 33, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})

aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 5, 5}
aPosObj := msObjSize(aInfo, aObjects, .T.)
aPosGet := msObjGetPos(aSize[3] - aSize[1], 800, {{18,53,116}})

// Monta dialogo
Define msDialog oDlg Title OemtoAnsi(cCadastro) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel
@ aPosObj[1][1],aPosObj[1][2] to aPosObj[1][3],aPosObj[1][4] Label "" of oDlg Pixel
@ aPosObj[1][1] + 7,aPosGet[1][1] Say OemToAnsi("Grupo") Size 18,8 of oDlg Pixel
@ aPosObj[1][1] + 5,aPosGet[1][2] msGet cCodGrp F3 "SU0" Valid AtuDsc() When Inclui Size 29,10 of oDlg Pixel
@ aPosObj[1][1] + 5,aPosGet[1][3] msGet oDscGrp Var cDscGrp When .F. Size 127,10 of oDlg Pixel
oGd := msGetDados():New(aPosObj[2][1], aPosObj[2][2], aPosObj[2][3], aPosObj[2][4], nOpcX, "P_D49LinOk(n)", "P_D49TudOk()",, .T.,,, .T.)
bOk := {|| IIf(oGd:TudoOk(), (nOpc := 1, oDlg:End()), nOpc := 0)}
bCn := {|| (nOpc := 0, oDlg:End())}
Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOk, bCn)

If nOpc == 1 // confirmacao do usuario
	If nOpcX == 4 .Or. nOpcX == 5
		// Apaga registros existentes
		dbSelectArea("PAP")
		dbSetOrder(1) //PAP_FILIAL+PAP_GRPATD+PAP_CODTAB
		dbSeek(xFilial("PAP") + cCodGrp)
		
		While !EOF();
			.And. PAP_FILIAL == xFilial("PAP");
			.And. PAP_GRPATD == cCodGrp
			
			RecLock("PAP", .F., .T.)
			dbDelete()
			msUnlock()
			
			dbSelectArea("PAP")
			dbSkip()
		EndDo
	EndIf
	If nOpcX == 3 .Or. nOpcX == 4
		nTotLin := Len(aCols)
		
		// inclui registros
		For i := 1 to nTotLin
			If !gdDeleted(i)
				RecLock("PAP", .T.)
				PAP_FILIAL := xFilial("PAP")
				PAP_GRPATD := cCodGrp
				PAP_CODTAB := gdFieldGet("PAP_CODTAB", i)
				msUnlock()
			EndIf
		Next i
	EndIf
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ D49LINOK บAutor  ณPaulo Benedet             บ Data ณ 23/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da linha                                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nLin - Numero da linha da getdados                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Linha ok                                         บฑฑ
ฑฑบ          ณ        .F. - Linha incorreta                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo programa D49MAN                           บฑฑ
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
Project Function D49LinOk(nLin)
Local nTotLin := Len(aCols) // numero de linhas do acols
Local lRet := .T. // retorno da funcao
Local i // variavel do for

// verifica se linha estah repetida
If !gdDeleted(nLin)
	For i := 1 to nTotLin
		If i <> nLin;
			.And. !gdDeleted(i);
			.And. gdFieldGet("PAP_CODTAB", i) == gdFieldGet("PAP_CODTAB", nLin)
			lRet := .F.
			MsgAlert(OemtoAnsi("Tabela de pre็o repetida!"), "Aviso")
			Exit
		EndIf
	Next i
EndIf

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ D49TUDOK บAutor  ณPaulo Benedet             บ Data ณ 23/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da getdados                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Tela ok                                          บฑฑ
ฑฑบ          ณ        .F. - Tela incorreta                                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo programa D49MAN                           บฑฑ
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
Project Function D49TudOk()
Local nTotLin := Len(aCols) // numero de linhas do acols
Local lRet := .T. // retorno da funcao
Local i // variavel do for

// refaz a validacao da linha
For i := 1 to nTotLin
	If !gdDeleted(i)
		If !P_D49LinOk(i)
			lRet := .F.
			Exit
		EndIf
	EndIf
Next i

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ ATUDSC   บAutor  ณPaulo Benedet             บ Data ณ 23/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Validacao do get de grupo de atendimento                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Grupo ok                                         บฑฑ
ฑฑบ          ณ        .F. - Grupo incorreto                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo programa D49MAN                           บฑฑ
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
Static Function AtuDsc()
Local lRet := .T. //retorno da funcao

If ExistChav("PAP")
	dbSelectArea("SU0")
	dbSetOrder(1) //U0_FILIAL+U0_CODIGO
	If dbSeek(xFilial("SU0") + cCodGrp)
		cDscGrp := SU0->U0_NOME
		lRet := .T.
	Else
		cDscGrp := ""
		lRet := .F.
		msgAlert(OemtoAnsi("Grupo de atendimento inexistente!"), "Aviso")
	EndIf
Else
	cDscGrp := ""
	lRet := .F.
EndIf

oDscGrp:Refresh()

Return(lRet)
