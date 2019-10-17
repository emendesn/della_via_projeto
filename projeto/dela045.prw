/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELA045  บAutor  ณPaulo Benedet             บ Data ณ 22/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Fazer a devolucao do seguro                                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cNota  - Numero da nota de devolucao                          บฑฑ
ฑฑบ          ณ cSerie - Serie da nota de devolucao                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo ponto de entrada LOJA020.                 บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑบ          ณ Mostrar interface para o usuario informar as apolices que     บฑฑ
ฑฑบ          ณ estao sendo devolvidas. Se existirem duas apolices com o mesmoบฑฑ
ฑฑบ          ณ numero, o usuario devera informar o numero da apolice duas    บฑฑ
ฑฑบ          ณ vezes (em linhas diferentes).                                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRegiane RBณ14/08/06ณ      ณPesquisa pela NFORI para localizar os registrosบฑฑ
ฑฑบ          ณ        ณ      ณde seguro/sinistro e atraves deles alterar PA8 บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA045(cNota, cSerie)
Local aArea    := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local aAreaPA8 := PA8->(GetArea())
Local cCpoShow := "PA8_APOLIC&PA8_MATRIC" // Campos que serao mostrados na getdados
Local nTotCol  := 0 // numero total de linhas do acols
Local cTitulo  := OemtoAnsi("Informe as ap๓lices que estใo sendo devolvidas") // titulo da tela
Local aPosDlg  := {178,181,403,538} // Coordenas do dialog
Local aPosGd   := {3,3,96,176} // Coordenas da getdados
Local cNFSeg   := "" // Numero da nota fiscal de venda de seguro
Local nLinMax  := 0 // Numero maximo de linhas na getdados
Local lProdSeg := .F. // Mostra se existem produto do tipo seguro
Local nOpca    := 0 // Mostra se usuario confirmou a tela
Local i // contador do for
Local oDlg
Local oGet

Private aHeader := {}
Private aCols := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se existem itens de seguro ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SB1")
dbSetOrder(1) // B1_FILIAL+B1_COD

dbSelectArea("SD1")
dbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
dbSeek(xFilial("SD1") + cNota + cSerie)

If Empty(SD1->D1_NFORI)
	Return
Else
	dbSelectArea("SD2")
	dbSetOrder(3) // D2_FILIAL+D2_DOC+D2_SERIE+D1_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbSeek(xFilial("SD2") + SD1->(D1_NFORI+D1_SERIORI))

	While !EOF();
		.And. D2_FILIAL == xFilial("SD2");
		.And. D2_DOC == SD1->D1_NFORI;
		.And. D2_SERIE == SD1->D1_SERIORI
	
		SB1->(dbSeek(xFilial("SB1") + SD2->D2_COD))
		If SB1->B1_GRUPO == GetMV("FS_DEL001")
			lProdSeg := .T.
			Exit
		EndIf
	
		dbSelectArea("SD2")
		dbSkip()
	EndDo

	If !lProdSeg
		RestArea(aAreaSB1)
		RestArea(aAreaSD1)
		RestArea(aAreaPA8)
		RestArea(aArea)
		Return
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta objetos da interface com o usuario ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// Monta aHeader
	dbSelectArea("SX3")
	dbSetOrder(1) //X3_ARQUIVO+X3_ORDEM
	dbSeek("PA8")

	While !EOF() .And. X3_ARQUIVO == "PA8"
		
		If x3Uso(X3_USADO);
			.And. cNivel >= X3_NIVEL;
			.And. rTrim(X3_CAMPO) $ cCpoShow
			
			aAdd(aHeader, {Trim(X3_TITULO), X3_CAMPO, X3_PICTURE,;
			X3_TAMANHO, X3_DECIMAL, X3_VLDUSER,;
			X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo

	nTotCol := Len(aHeader)

	// Procura nota original
	dbSelectArea("SD1")
	dbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbSeek(xFilial("SD1") + cNota + cSerie)
	
	If !Empty(SD1->D1_NFORI) // Troca da loja
		cNFSeg 	:= SD1->D1_NFORI  
		cSrSeg	:= SD1->D1_SERIORI 
	Else // Troca de outra loja
		cNFSeg := ""
		cSrSeg := ""
	EndIf

	// Monta aCols
	dbSelectArea("PA8")
	dbSetOrder(9) // PA8_LOJSG+PA8_NFSG+PA8_SRSG
	dbSeek(cFilAnt + cNFSeg+ cSrSeg)
	
	While !EOF();
		.And. PA8_LOJSG == cFilAnt;
		.And. PA8_NFSG == cNFSeg  ;
		.And. PA8_SRSG == cSRSeg
		
		aAdd(aCols, Array(nTotCol + 1))
		For i := 1 to nTotCol
			aCols[Len(aCols)][i] := FieldGet(FieldPos(aHeader[i][2]))
		Next i
		aCols[Len(aCols)][nTotCol + 1] := .F.
		
		dbSelectArea("PA8")
		dbSkip()
	EndDo

	nLinMax := Len(aCols)

	If Empty(aCols)
		aAdd(aCols, Array(nTotCol + 1))
		For i := 1 to nTotCol
			aCols[Len(aCols)][i] := CriaVar(aHeader[i][2], .F.)
		Next i
		aCols[Len(aCols)][nTotCol + 1] := .F.
		
		nLinMax := 99
	EndIf

	// Monta interface com o usuario
	Define msDialog oDlg Title cTitulo From aPosDlg[1],aPosDlg[2] to aPosDlg[3],aPosDlg[4] of oMainWnd Pixel
	oGet := msGetDados():New(aPosGd[1], aPosGd[2], aPosGd[3], aPosGd[4], 4, "P_D45LinOK(n)", "P_D45TudOK",, .T.,,,, nLinMax)
	Define sButton From 100,148 Type 1 Enable of oDlg Action IIf(oGet:TudoOk(), (nOpca := 1, oDlg:End()), nOpca := 0)
	Activate msDialog oDlg Centered 
	
	If nOpca == 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza arquivo ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nLinMax := Len(aCols)
		dbSelectArea("PA8")
		dbSetOrder(1) // PA8_FILIAL+PA8_APOLIC
		
		For i := 1 to nLinMax
			If !gdDeleted(i)
				dbSeek(xFilial("PA8") + gdFieldGet("PA8_APOLIC", i))
				
				While !EOF();
					.And. PA8_FILIAL == xFilial("PA8");
					.And. PA8_APOLIC == gdFieldGet("PA8_APOLIC", i)
					
					// Verifica se apolice eh do cliente
					If PA8->PA8_CODCLI <> SF1->F1_FORNECE .Or. PA8->PA8_LOJCLI <> SF1->F1_LOJA
						dbSkip()
						Loop
					EndIf
					
					// Verifica se apolice nao foi faturada
					If Empty(PA8->PA8_NFSG)
						dbSkip()
						Loop
					EndIf
					
					// Verifica se seguro ja foi sinistrado ou devolvido
					If !Empty(PA8->PA8_NFSN) .Or. !Empty(PA8->PA8_DEVOL)
						dbSkip()
						Loop
					EndIf
					
					// Verifica se seguro estah vencido
					If (dDatabase - PA8->PA8_DTSG) > (GetMv("FS_DEL010") * 30)
						dbSkip()
						Loop
					EndIf
					
					// Atualiza arquivo
					RecLock("PA8", .F.)
					PA8->PA8_DEVOL := "S"
					PA8->PA8_NFDEV := cNota		//Incluido 14/08/06 - Regiane
					PA8->PA8_SRDEV := cSerie	//Incluido 14/08/06 - Regiane
					msUnlock()
					dbCommit()
					
					Exit
				EndDo
			EndIf
		Next i
	Else
		MsgAlert(OemtoAnsi("Nenhuma ap๓lice foi devolvida!"), "Aviso")
	EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSD1)
	RestArea(aAreaPA8)
	RestArea(aArea)

EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ D45LinOK บAutor  ณPaulo Benedet             บ Data ณ 22/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Consistir a mudanca de linha                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nLin - Numero da linha a ser validada                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Linha ok                                         บฑฑ
ฑฑบ          ณ        .F. - Linha com dados incorretos                       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo programa DELA045 como parametro da getdad บฑฑ
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
Project Function D45LinOK(nLin)
Local lRet := .T. // Retorno da funcao de validacao
Local aSitu := {} // Array com as situacoes das apolices

If !gdDeleted(nLin)
	dbSelectArea("PA8")
	dbSetOrder(1) // PA8_FILIAL+PA8_APOLIC
	If !dbSeek(xFilial("PA8") + gdFieldGet("PA8_APOLIC", nLin))
		lRet := .F.
		MsgAlert(OemtoAnsi("Nใo existe este n๚mero de ap๓lice!"), "Aviso")
	Else
			While !EOF();
			.And. PA8_FILIAL == xFilial("PA8");
			.And. PA8_APOLIC == gdFieldGet("PA8_APOLIC", nLin)
			
			If PA8->PA8_CODCLI == SF1->F1_FORNECE;
				.And. PA8->PA8_LOJCLI == SF1->F1_LOJA;
				.And. !Empty(PA8->PA8_NFSG)
				
				aAdd(aSitu, {IIf(Empty(PA8->PA8_NFSN), 0, 1), IIf(Empty(PA8->PA8_DEVOL), 0, 1),;
				IIf((dDatabase - PA8->PA8_DTSG) > (GetMv("FS_DEL010") * 30), 1, 0)})
			EndIf
			
			dbSelectArea("PA8")
			dbSkip()
		EndDo
		
		If Len(aSitu) == 0
			lRet := .F.
			MsgAlert(OemtoAnsi("Nใo existe este n๚mero de ap๓lice para este cliente!"), "Aviso")
		ElseIf aScan(aSitu, {|x| x[1] == 0}) == 0
			lRet := .F.
			MsgAlert(OemtoAnsi("Este seguro jแ foi sinistrado!"), "Aviso")
		ElseIf aScan(aSitu, {|x| x[2] == 0}) == 0
			lRet := .F.
			MsgAlert(OemtoAnsi("Este seguro jแ foi devolvido!"), "Aviso")
		ElseIf aScan(aSitu, {|x| x[3] == 0}) == 0
			lRet := .F.
			MsgAlert(OemtoAnsi("Este seguro estแ vencido!"), "Aviso")
		EndIf
	EndIf
EndIf

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ D45TudOK บAutor  ณPaulo Benedet             บ Data ณ 22/08/05 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Consistir a tela                                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Tela ok                                          บฑฑ
ฑฑบ          ณ        .F. - Tela com dados incorretos                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo programa DELA045 como parametro da getdad บฑฑ
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
Project Function D45TudOk()
Local lRet := .T. // Retorno da funcao de validacao
Local nTotLin := Len(aCols) // Numero de linhas do aCols
Local i // Variavel do for

For i := 1 to nTotLin
	If !gdDeleted(i)
		If !P_D45LinOK(i)
			lRet := .F.
			Exit
		EndIf
	EndIf
Next i

Return(lRet)