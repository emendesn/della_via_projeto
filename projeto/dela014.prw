#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA014   บAutor  ณPaulo Benedet          บ Data ณ  03/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de manutencao do cadastro de despasas p/ margem media   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo menu SIGALOJA.XNU especifico.             บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA014()

Private aRotina   := {}
Private cCadastro := "Despesas Margem Media"

aAdd(aRotina, {"Pesquisar" , "axPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "P_DELA014M", 0, 2})
aAdd(aRotina, {"Incluir"   , "P_DELA014M", 0, 3})
aAdd(aRotina, {"Alterar"   , "P_DELA014M", 0, 4})
aAdd(aRotina, {"Excluir"   , "P_DELA014M", 0, 5})

dbSelectArea("PAD")
dbGoTop()

mBrowse(6,1,22,75,"PAD")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA014M  บAutor  ณPaulo Benedet          บ Data ณ  06/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMontagem da tela de manutencao das despesas  p/ margem media   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada atraves das opcoes da mBrowse                  บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA014M(cAlias, nReg, nOpcx)

Local aPosGet  := {}
Local nPosGd1 := 0
Local nPosGd2 := 0
Local nPosGd3 := 0
Local nPosGd4 := 0
Local i
Local aInfo    := {}
Local aPosObj1 := {}
Local aObj1 := {}
Local aSize    := {}
Local nUsado   := 0
Local npCodDsp := 0
Local nppAtc   := 0
Local nppTrk   := 0
Local nppVrj   := 0
Local npVlr    := 0
Local cNoShow := "PAD_LOJDV/PAD_NOMLOJ/PAD_DTEMI/PAD_DTVAL/PAD_PASTA"
Local aTitles := {"Acessorios", "Pneus", "Servicos"}
Local aPages := {"", "", ""}

Private cCodLoj := IIf(nOpcx == 3, Space(TamSx3("PAD_LOJDV")[1]), PAD->PAD_LOJDV)
Private cDesLoj := ""
Private dDatEmi := IIf(nOpcx == 3, CtoD("  /  /  "), PAD->PAD_DTEMI)
Private dDatVal := IIf(nOpcx == 3, CtoD("  /  /  "), PAD->PAD_DTVAL)

Private oDlg
Private oFolder
Private oDscLoj

Private oAtc1
Private oAtc2
Private oAtc3

Private oTrk1
Private oTrk2
Private oTrk3

Private oVrj1
Private oVrj2
Private oVrj3

Private oVlr1
Private oVlr2
Private oVlr3

Private oGet1
Private oGet2
Private oGet3

Private aHeader := {}
Private aCols   := {}

Private aCols1 := {}
Private aCols2 := {}
Private aCols3 := {}

Private aAtc := {0,0,0}
Private aTrk := {0,0,0}
Private aVrj := {0,0,0}
Private aVlr := {0,0,0}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega aHeaderณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("PAD")

While !EOF() .And. X3_ARQUIVO == "PAD"
	If x3Uso(X3_USADO);
		.And. cNivel >= X3_NIVEL;
		.And. !(rTrim(X3_CAMPO) $ cNoShow)
		
		nUsado += 1
		
		aAdd(aHeader, {Trim(X3_TITULO), X3_CAMPO, X3_PICTURE, ;
		X3_TAMANHO, X3_DECIMAL, X3_VLDUSER, ;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
	EndIf
	
	If rTrim(X3_CAMPO) == "PAD_CODDSP"
		npCodDsp := nUsado
	ElseIf rTrim(X3_CAMPO) == "PAD_PATC"
		nppAtc   := nUsado
	ElseIf rTrim(X3_CAMPO) == "PAD_PTRK"
		nppTrk   := nUsado
	ElseIf rTrim(X3_CAMPO) == "PAD_PVRJ"
		nppVrj   := nUsado
	ElseIf rTrim(X3_CAMPO) == "PAD_VLR"
		npVlr    := nUsado
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega aColsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpcx == 3 // inclusao
	aCols := {Array(nUsado + 1)}
	aCols[1][nUsado + 1] := .F.
	
	For i := 1 to nUsado
		If aHeader[i][10] != "V"
			aCols[1][i] := CriaVar(aHeader[i][2])
		ElseIf rTrim(aHeader[i][2]) == "PAD_DSCDSP"
			aCols[1][i] := ""
		EndIf
	Next i
	
	aCols1 := aClone(aCols)
	aCols2 := aClone(aCols)
	aCols3 := aClone(aCols)
Else

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza nome da filialณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aEstSM0 := SM0->(GetArea())
	
	SM0->(dbSeek(cEmpAnt + cCodLoj))
	cDesLoj := SM0->M0_FILIAL
	
	RestArea(aEstSM0)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza acolsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("PAD")
	dbSetOrder(1)
	dbSeek(xFilial("PAD") + cCodLoj + DtoS(dDatEmi))
	
	While !EOF();
		.And. PAD_FILIAL == xFilial("PAD");
		.And. PAD_LOJDV == cCodLoj;
		.And. PAD_DTEMI == dDatEmi
		
		If PAD->PAD_PASTA == 1
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCarrega acolsณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd(aCols1, Array(nUsado + 1))
			For i := 1 to nUsado
				If rTrim(aHeader[i][2]) == "PAD_DSCDSP"
					aCols1[Len(aCols1)][i] := Tabela("P0", PAD->PAD_CODDSP)
				Else
					aCols1[Len(aCols1)][i] := FieldGet(FieldPos(aHeader[i][2]))
				EndIf
			Next i
			aCols1[Len(aCols1)][nUsado + 1] := .F.
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza totalณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAtc[1] += aCols1[Len(aCols1)][nppAtc]
			aTrk[1] += aCols1[Len(aCols1)][nppTrk]
			aVrj[1] += aCols1[Len(aCols1)][nppVrj]
			aVlr[1] += aCols1[Len(aCols1)][npVlr]
		ElseIf PAD->PAD_PASTA == 2

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCarrega acolsณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd(aCols2, Array(nUsado + 1))
			For i := 1 to nUsado
				If rTrim(aHeader[i][2]) == "PAD_DSCDSP"
					aCols2[Len(aCols2)][i] := Tabela("P0", PAD->PAD_CODDSP)
				Else
					aCols2[Len(aCols2)][i] := FieldGet(FieldPos(aHeader[i][2]))
				EndIf
			Next i
			aCols2[Len(aCols2)][nUsado + 1] := .F.
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza totalณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAtc[2] += aCols2[Len(aCols2)][nppAtc]
			aTrk[2] += aCols2[Len(aCols2)][nppTrk]
			aVrj[2] += aCols2[Len(aCols2)][nppVrj]
			aVlr[2] += aCols2[Len(aCols2)][npVlr]
		ElseIf PAD->PAD_PASTA == 3
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCarrega acolsณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd(aCols3, Array(nUsado + 1))
			For i := 1 to nUsado
				If rTrim(aHeader[i][2]) == "PAD_DSCDSP"
					aCols3[Len(aCols3)][i] := Tabela("P0", PAD->PAD_CODDSP)
				Else
					aCols3[Len(aCols3)][i] := FieldGet(FieldPos(aHeader[i][2]))
				EndIf
			Next i
			aCols3[Len(aCols3)][nUsado + 1] := .F.
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza totalณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAtc[3] += aCols3[Len(aCols3)][nppAtc]
			aTrk[3] += aCols3[Len(aCols3)][nppTrk]
			aVrj[3] += aCols3[Len(aCols3)][nppVrj]
			aVlr[3] += aCols3[Len(aCols3)][npVlr]
	
		EndIf
	
		dbSelectArea("PAD")
		dbSkip()
	EndDo
	
	aCols := aClone(aCols1)

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณarray asize - tamanho da dialog e area de trabalho                       ณ
//ณ                                                                         ณ
//ณ1 - linha inicial area de trabalho                                       ณ
//ณ2 - coluna inicial area de trabalho                                      ณ
//ณ3 - linha final area de trabalho                                         ณ
//ณ4 - coluna final area de trabalho                                        ณ
//ณ5 - coluna final dialog                                                  ณ
//ณ6 - linha final dialog                                                   ณ
//ณ7 - linha inicial dialog                                                 ณ
//ณ                                                                         ณ
//ณarray aobjects - tamanho padrao dos objetos para calculo das posicoes    ณ
//ณ1 - tamanho x                                                            ณ
//ณ2 - tamanho y                                                            ณ
//ณ3 - dimensiona x                                                         ณ
//ณ4 - dimensiona y                                                         ณ
//ณ5 - retorna dimensoes x e y (size) ao inves de linha / coluna final      ณ
//ณ                                                                         ณ
//ณarray ainfo - tamanho da area onde sera calculada as posicoes dos objetosณ
//ณ1 - posicao inicial x                                                    ณ
//ณ2 - posicao inicial y                                                    ณ
//ณ3 - posicao final x                                                      ณ
//ณ4 - posicao final y                                                      ณ
//ณ5 - espaco lateral entre os objetos                                      ณ
//ณ6 - espaco vertical entre os objetos                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDevolve dimensoes da tela do usuarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSize := msAdvSize(.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณcalcula coordenadas do objetoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aObj1, {0,  40, .T., .T.})
aAdd(aObj1, {0, 150, .T., .T.})

aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 3}
aPosObj1 := msObjSize(aInfo, aObj1, .T., .F.)
aPosGet := msObjGetPos(aSize[3] - aSize[1], 396, {{5,35,115,150}})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta dialogoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define msDialog oDlg Title cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel

@ 17,aPosGet[1][1] Say "Loja DV" Size 31,9 of oDlg Pixel
@ 15,aPosGet[1][2] msGet cCodLoj F3 "SM0" Valid ValidFil(cCodLoj) Size 25,10 of oDlg Pixel

@ 17,aPosGet[1][3] Say "Descr" Size 31,9 of oDlg Pixel
@ 15,aPosGet[1][4] msGet oDesLoj Var cDesLoj When .F. Size 115,10 of oDlg Pixel

@ 37,aPosGet[1][1] Say "Dt Emissao" Size 31,9 of oDlg Pixel
@ 35,aPosGet[1][2] msGet dDatEmi Valid NaoVazio() Size 45,10 of oDlg Pixel

@ 37,aPosGet[1][3] Say "Dt Validade" Size 31,9 of oDlg Pixel
@ 35,aPosGet[1][4] msGet dDatVal Valid NaoVazio() Size 45,10 of oDlg Pixel

oFolder := tFolder():New(aPosObj1[2][1], aPosObj1[2][2], aTitles, aPages, oDlg,,,, .T., .F., aPosObj1[2][4] - aPosObj1[2][2], aPosObj1[2][3] - aPosObj1[2][1])
oFolder:bSetOption := {|nDst| MudaPasta(oFolder:nOption, nDst)}

nPosGd1 := 2
nPosGd2 := 2
nPosGd3 := aPosObj1[2][3] - aPosObj1[2][1] - 50
nPosGd4 := aPosObj1[2][4] - aPosObj1[2][2] - 4

oGet1 := msGetDados():New(nPosGd1, nPosGd2, nPosGd3, nPosGd4, nOpcx, "P_D14LinOk", "P_D14TudOk",, .T.,,, .T.,, "P_D14CpoOk",,,, oFolder:aDialogs[1])
oGet1:oBrowse:lDisablePaint := .F.

oGet2 := msGetDados():New(nPosGd1, nPosGd2, nPosGd3, nPosGd4, nOpcx, "P_D14LinOk", "P_D14TudOk",, .T.,,, .T.,, "P_D14CpoOk",,,, oFolder:aDialogs[2])
oGet2:oBrowse:lDisablePaint := .F.

oGet3 := msGetDados():New(nPosGd1, nPosGd2, nPosGd3, nPosGd4, nOpcx, "P_D14LinOk", "P_D14TudOk",, .T.,,, .T.,, "P_D14CpoOk",,,, oFolder:aDialogs[3])
oGet3:oBrowse:lDisablePaint := .F.

nPosGd3 += 10
aPosGet := msObjGetPos(nPosGd4, 386, {{2,166,216,266,346}})

@ nPosGd3,aPosGet[1][1] Say "TOTAIS" Size 31,9 of oFolder:aDialogs[1] Pixel
@ nPosGd3,aPosGet[1][2] Say "% Atacado" Size 31,9 of oFolder:aDialogs[1] Pixel
@ nPosGd3,aPosGet[1][3] Say "% Truck" Size 31,9 of oFolder:aDialogs[1] Pixel
@ nPosGd3,aPosGet[1][4] Say "% Varejo" Size 31,9 of oFolder:aDialogs[1] Pixel
@ nPosGd3,aPosGet[1][5] Say "Valor" Size 31,9 of oFolder:aDialogs[1] Pixel

@ nPosGd3,aPosGet[1][1] Say "TOTAIS" Size 31,9 of oFolder:aDialogs[2] Pixel
@ nPosGd3,aPosGet[1][2] Say "% Atacado" Size 31,9 of oFolder:aDialogs[2] Pixel
@ nPosGd3,aPosGet[1][3] Say "% Truck" Size 31,9 of oFolder:aDialogs[2] Pixel
@ nPosGd3,aPosGet[1][4] Say "% Varejo" Size 31,9 of oFolder:aDialogs[2] Pixel
@ nPosGd3,aPosGet[1][5] Say "Valor" Size 31,9 of oFolder:aDialogs[2] Pixel

@ nPosGd3,aPosGet[1][1] Say "TOTAIS" Size 31,9 of oFolder:aDialogs[3] Pixel
@ nPosGd3,aPosGet[1][2] Say "% Atacado" Size 31,9 of oFolder:aDialogs[3] Pixel
@ nPosGd3,aPosGet[1][3] Say "% Truck" Size 31,9 of oFolder:aDialogs[3] Pixel
@ nPosGd3,aPosGet[1][4] Say "% Varejo" Size 31,9 of oFolder:aDialogs[3] Pixel
@ nPosGd3,aPosGet[1][5] Say "Valor" Size 31,9 of oFolder:aDialogs[3] Pixel

nPosGd3 += 10

@ nPosGd3,aPosGet[1][2] Say oAtc1 Var aAtc[1] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[1] Pixel
@ nPosGd3,aPosGet[1][3] Say oTrk1 Var aTrk[1] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[1] Pixel
@ nPosGd3,aPosGet[1][4] Say oVrj1 Var aVrj[1] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[1] Pixel
@ nPosGd3,aPosGet[1][5] Say oVlr1 Var aVlr[1] Picture "@E 9999,999.99" Size 31,9 of oFolder:aDialogs[1] Pixel

@ nPosGd3,aPosGet[1][2] Say oAtc2 Var aAtc[2] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[2] Pixel
@ nPosGd3,aPosGet[1][3] Say oTrk2 Var aTrk[2] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[2] Pixel
@ nPosGd3,aPosGet[1][4] Say oVrj2 Var aVrj[2] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[2] Pixel
@ nPosGd3,aPosGet[1][5] Say oVlr2 Var aVlr[2] Picture "@E 9999,999.99" Size 31,9 of oFolder:aDialogs[2] Pixel

@ nPosGd3,aPosGet[1][2] Say oAtc3 Var aAtc[3] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[3] Pixel
@ nPosGd3,aPosGet[1][3] Say oTrk3 Var aTrk[3] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[3] Pixel
@ nPosGd3,aPosGet[1][4] Say oVrj3 Var aVrj[3] Picture "@E 9,999.99" Size 31,9 of oFolder:aDialogs[3] Pixel
@ nPosGd3,aPosGet[1][5] Say oVlr3 Var aVlr[3] Picture "@E 9999,999.99" Size 31,9 of oFolder:aDialogs[3] Pixel

bOK := {|| Grava(nOpcx), oDlg:End()}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOK, bCancel)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMudaPasta บAutor  ณPaulo Benedet          บ Data ณ  06/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAltera o folder em exibicao na tela                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnFldOrg - Numero folder origem                                 บฑฑ
ฑฑบ          ณnFldDst - Numero folder destino                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada no programa DELA014M, ao mudar de pasta        บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MudaPasta(nFldOrg, nFldDst)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณreinicia linha da getdadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
n := 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva getdados originalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nFldOrg == 1
	aCols1 := aClone(aCols)
	oGet1:oBrowse:lDisablePaint := .T.
ElseIf nFldOrg == 2
	aCols2 := aClone(aCols)
	oGet2:oBrowse:lDisablePaint := .T.
Else
	aCols3 := aClone(aCols)
	oGet3:oBrowse:lDisablePaint := .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณHabilita nova getdadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nFldDst == 1
	aCols := aClone(aCols1)
	oGet1:oBrowse:lDisablePaint := .F.
	oGet1:oBrowse:Refresh(.T.)
ElseIf nFldDst == 2
	aCols := aClone(aCols2)
	oGet2:oBrowse:lDisablePaint := .F.
	oGet2:oBrowse:Refresh(.T.)
Else
	aCols := aClone(aCols3)
	oGet3:oBrowse:lDisablePaint := .F.
	oGet3:oBrowse:Refresh(.T.)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณD14LinOk  บAutor  ณPaulo Benedet          บ Data ณ  06/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da linha da GetDados                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ.T. apos a validacao de todos os testes, .F. caso contrario    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada na troca de linha da getdados                  บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function D14LinOk()

Local nLin := 0
Local nUsado := Len(aHeader)
Local npCodDsp := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_CODDSP"})
Local nppAtc   := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_PATC"})
Local nppTrk   := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_PTRK"})
Local nppVrj   := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_PVRJ"})
Local npVlr    := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_VLR"})
Local aSvDados := aClone(aCols)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se linha esta deletadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aCols[n][nUsado + 1]

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se campo codigo despesa esta vazioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(aCols[n][npCodDsp])
		Return(.T.)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณApaga despesa das outras pastasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oFolder:nOption == 1
		nLin := aScan(aCols2, {|x| x[npCodDsp] == aCols[n][npCodDsp]})
		If nLin > 0
			aCols2[nLin][nUsado + 1] := .T.
		EndIf
		
		nLin := aScan(aCols3, {|x| x[npCodDsp] == aCols[n][npCodDsp]})
		If nLin > 0
			aCols3[nLin][nUsado + 1] := .T.
		EndIf
	ElseIf oFolder:nOption == 2
		nLin := aScan(aCols1, {|x| x[npCodDsp] == aCols[n][npCodDsp]})
		If nLin > 0
			aCols1[nLin][nUsado + 1] := .T.
		EndIf
		
		nLin := aScan(aCols3, {|x| x[npCodDsp] == aCols[n][npCodDsp]})
		If nLin > 0
			aCols3[nLin][nUsado + 1] := .T.
		EndIf
	Else
		nLin := aScan(aCols1, {|x| x[npCodDsp] == aCols[n][npCodDsp]})
		If nLin > 0
			aCols1[nLin][nUsado + 1] := .T.
		EndIf
		
		nLin := aScan(aCols2, {|x| x[npCodDsp] == aCols[n][npCodDsp]})
		If nLin > 0
			aCols2[nLin][nUsado + 1] := .T.
		EndIf
	EndIf
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se campo codigo despesa esta vazioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(aCols[n][npCodDsp])
		MsgAlert("O campo '" + aHeader[npCodDsp][1] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCopia despesa para as outras pastasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oFolder:nOption == 1

		nLin := aScan(aCols2, {|x| x[npCodDsp] == aCols[n][npCodDsp]})

		If nLin > 0
			aCols2[nLin][nUsado + 1] := .F.
		Else
			nLin := Len(aCols2)
			If Empty(aCols2[nLin][1])
				aCols2[nLin] := aCols[n]
			Else
				aAdd(aCols2, aCols[n])
			EndIf
			nLin := Len(aCols2)
			aCols2[nLin][nppAtc] := 0
			aCols2[nLin][nppTrk] := 0
			aCols2[nLin][nppVrj] := 0
			aCols2[nLin][npVlr]  := 0
		EndIf
		
		nLin := aScan(aCols3, {|x| x[npCodDsp] == aCols[n][npCodDsp]})

		If nLin > 0
			aCols3[nLin][nUsado + 1] := .F.
		Else
			nLin := Len(aCols3)
			If Empty(aCols3[nLin][1])
				aCols3[nLin] := aCols[n]
			Else
				aAdd(aCols3, aCols[n])
			EndIf
			nLin := Len(aCols3)
			aCols3[nLin][nppAtc] := 0
			aCols3[nLin][nppTrk] := 0
			aCols3[nLin][nppVrj] := 0
			aCols3[nLin][npVlr]  := 0
		EndIf
		
	ElseIf oFolder:nOption == 2

		nLin := aScan(aCols1, {|x| x[npCodDsp] == aCols[n][npCodDsp]})

		If nLin > 0
			aCols1[nLin][nUsado + 1] := .F.
		Else
			nLin := Len(aCols1)
			If Empty(aCols1[nLin][1])
				aCols1[nLin] := aCols[n]
			Else
				aAdd(aCols1, aCols[n])
			EndIf
			nLin := Len(aCols1)
			aCols1[nLin][nppAtc] := 0
			aCols1[nLin][nppTrk] := 0
			aCols1[nLin][nppVrj] := 0
			aCols1[nLin][npVlr]  := 0
		EndIf
		
		nLin := aScan(aCols3, {|x| x[npCodDsp] == aCols[n][npCodDsp]})

		If nLin > 0
			aCols3[nLin][nUsado + 1] := .F.
		Else
			nLin := Len(aCols3)
			If Empty(aCols3[nLin][1])
				aCols3[nLin] := aCols[n]
			Else
				aAdd(aCols3, aCols[n])
			EndIf
			nLin := Len(aCols3)
			aCols3[nLin][nppAtc] := 0
			aCols3[nLin][nppTrk] := 0
			aCols3[nLin][nppVrj] := 0
			aCols3[nLin][npVlr]  := 0
		EndIf
		
	Else

		nLin := aScan(aCols1, {|x| x[npCodDsp] == aCols[n][npCodDsp]})

		If nLin > 0
			aCols1[nLin][nUsado + 1] := .F.
		Else
			nLin := Len(aCols1)
			If Empty(aCols1[nLin][1])
				aCols1[nLin] := aCols[n]
			Else
				aAdd(aCols1, aCols[n])
			EndIf
			nLin := Len(aCols1)
			aCols1[nLin][nppAtc] := 0
			aCols1[nLin][nppTrk] := 0
			aCols1[nLin][nppVrj] := 0
			aCols1[nLin][npVlr]  := 0
		EndIf
		
		nLin := aScan(aCols2, {|x| x[npCodDsp] == aCols[n][npCodDsp]})

		If nLin > 0
			aCols2[nLin][nUsado + 1] := .F.
		Else
			nLin := Len(aCols2)
			If Empty(aCols2[nLin][1])
				aCols2[nLin] := aCols[n]
			Else
				aAdd(aCols2, aCols[n])
			EndIf
			nLin := Len(aCols2)
			aCols2[nLin][nppAtc] := 0
			aCols2[nLin][nppTrk] := 0
			aCols2[nLin][nppVrj] := 0
			aCols2[nLin][npVlr]  := 0
		EndIf
	EndIf
	
	aCols := aClone(aSvDados)
	
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณD14CpoOk  บAutor  ณPaulo Benedet          บ Data ณ  06/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao dos campos da GetDados                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ.T. apos a validacao de todos os testes, .F. caso contrario    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada na troca de campo em cada linha da getdados    บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function D14CpoOk()

Local nppAtc := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_PATC"})
Local nppTrk := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_PTRK"})
Local nppVrj := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_PVRJ"})
Local npVlr  := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_VLR"})
Local cAtuCpo := "PAD_PATC/PAD_PTRK/PAD_PVRJ/PAD_VLR"
Local nTot := Len(aCols)
Local i := 0
Local oGetTmp

If SubStr(ReadVar(), 4) $ cAtuCpo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSalva getdadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oFolder:nOption == 1
		oGetTmp := oGet1
	ElseIf oFolder:nOption == 2
		oGetTmp := oGet2
	Else
		oGetTmp := oGet3
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณZera totaisณ
	//ภฤฤฤฤฤฤฤฤฤฤฤู
	aAtc[oFolder:nOption] := 0
	aTrk[oFolder:nOption] := 0
	aVrj[oFolder:nOption] := 0
	aVlr[oFolder:nOption] := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza totaisณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For i := 1 to nTot
		If i == n
			If oGetTmp:oBrowse:nColPos == nppAtc
				aAtc[oFolder:nOption] += &(ReadVar())
				aTrk[oFolder:nOption] += aCols[i][nppTrk]
				aVrj[oFolder:nOption] += aCols[i][nppVrj]
				aVlr[oFolder:nOption] += aCols[i][npVlr]
			ElseIf oGetTmp:oBrowse:nColPos == nppTrk
				aAtc[oFolder:nOption] += aCols[i][nppAtc]
				aTrk[oFolder:nOption] += &(ReadVar())
				aVrj[oFolder:nOption] += aCols[i][nppVrj]
				aVlr[oFolder:nOption] += aCols[i][npVlr]
			ElseIf oGetTmp:oBrowse:nColPos == nppVrj
				aAtc[oFolder:nOption] += aCols[i][nppAtc]
				aTrk[oFolder:nOption] += aCols[i][nppTrk]
				aVrj[oFolder:nOption] += &(ReadVar())
				aVlr[oFolder:nOption] += aCols[i][npVlr]
			ElseIf oGetTmp:oBrowse:nColPos == npVlr
				aAtc[oFolder:nOption] += aCols[i][nppAtc]
				aTrk[oFolder:nOption] += aCols[i][nppTrk]
				aVrj[oFolder:nOption] += aCols[i][nppVrj]
				aVlr[oFolder:nOption] += &(ReadVar())
			EndIf
		Else
			aAtc[oFolder:nOption] += aCols[i][nppAtc]
			aTrk[oFolder:nOption] += aCols[i][nppTrk]
			aVrj[oFolder:nOption] += aCols[i][nppVrj]
			aVlr[oFolder:nOption] += aCols[i][npVlr]
		EndIf
	Next i
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza objetosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oFolder:nOption == 1
		oAtc1:Refresh()
		oTrk1:Refresh()
		oVrj1:Refresh()
		oVlr1:Refresh()
	ElseIf oFolder:nOption == 2
		oAtc2:Refresh()
		oTrk2:Refresh()
		oVrj2:Refresh()
		oVlr2:Refresh()
	Else
		oAtc3:Refresh()
		oTrk3:Refresh()
		oVrj3:Refresh()
		oVlr3:Refresh()
	EndIf
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณD14TudOk  บAutor  ณPaulo Benedet          บ Data ณ  06/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao geral das GetDados                                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ.T. apos a validacao de todos os testes, .F. caso contrario    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada antes da gravacao dos dados dos registros      บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function D14TudOk()

Local nLin   := 0
Local nUsado := Len(aHeader)
Local npCodDsp := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_CODDSP"})
Local i := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica as variaveis do cabecalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cCodLoj)
	MsgAlert("O campo 'Loja DV' deve ser informado!", "Aviso")
	Return(.F.)
EndIf

If Empty(dDatEmi)
	MsgAlert("O campo 'Dt Emissao' deve ser informado!", "Aviso")
	Return(.F.)
EndIf

If Empty(dDatVal)
	MsgAlert("O campo 'Dt Validade' deve ser informado!", "Aviso")
	Return(.F.)
EndIf

If dDatVal < dDatEmi
	MsgAlert("O campo 'Dt Validade' nao pode ser maior que 'Dt Emissao'!", "Aviso")
	Return(.F.)
EndIf

If !ValidFil(cCodLoj)
	Return(.F.)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica acolsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLin := Len(aCols1)

For i := 1 to nLin

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se linha esta deletadaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aCols1[i][nUsado + 1]
		Loop
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se campo codigo despesa esta vazioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(aCols1[i][npCodDsp])
		MsgAlert("O campo '" + aHeader[npCodDsp][1] + "' na pasta '" + oFolder:aPrompts[1] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
Next i

nLin := Len(aCols2)

For i := 1 to nLin
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se linha esta deletadaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aCols2[i][nUsado + 1]
		Loop
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se campo codigo despesa esta vazioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(aCols2[i][npCodDsp])
		MsgAlert("O campo '" + aHeader[npCodDsp][1] + "' na pasta '" + oFolder:aPrompts[2] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
Next i

nLin := Len(aCols3)

For i := 1 to nLin
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se linha esta deletadaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aCols3[i][nUsado + 1]
		Loop
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se campo codigo despesa esta vazioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(aCols3[i][npCodDsp])
		MsgAlert("O campo '" + aHeader[npCodDsp][1] + "' na pasta '" + oFolder:aPrompts[3] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
Next i

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidFil  บAutor  ณPaulo Benedet          บ Data ณ  06/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da filial                                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcFil - Codigo da filial                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ.T. apos a validacao de todos os testes, .F. caso contrario    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada apos a digitacao do campo filial               บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidFil(cFil)

Local aEstSM0 := SM0->(GetArea())

If !(SM0->(dbSeek(cEmpAnt + cFil)))
	MsgAlert("Filial inexistente!", "Aviso")
	Return(.F.)
EndIf

cDesLoj := SM0->M0_FILIAL
oDesLoj:Refresh()

RestArea(aEstSM0)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrava     บAutor  ณPaulo Benedet          บ Data ณ  06/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณEfetivacao das informacoes no banco de dados                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnOpcx - Opcao de gravacao (3-Inclusao;4-Alteracao;5-Exclusao)  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada apos a confirmacao da tela                     บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Grava(nOpcx)

Local npCodDsp := aScan(aHeader, {|x| rTrim(x[2]) == "PAD_CODDSP"})
Local nUsado := Len(aHeader)
Local aGerCol
Local i := 0
Local j := 0
Local k := 0

If nOpcx == 2
	Return
ElseIf nOpcx == 5
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณApaga registrosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("PAD")
	dbSetOrder(1)
	dbSeek(xFilial("PAD") + cCodLoj + DtoS(dDatEmi))
	
	While !EOF();
		.And. PAD_FILIAL == xFilial("PAD");
		.And. PAD_LOJDV == cCodLoj;
		.And. PAD_DTEMI == dDatEmi
		
		RecLock("PAD", .F.)
		dbDelete()
		msUnlock()
		
		dbSelectArea("PAD")
		dbSkip()
	EndDo
Else

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava acols da pasta atualณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If oFolder:nOption == 1
		aCols1 := aClone(aCols)
	ElseIf oFolder:nOption == 2
		aCols2 := aClone(aCols)
	Else
		aCols3 := aClone(aCols)
	EndIf
	
	aGerCol := {aCols1, aCols2, aCols3}
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava registrosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For i := 1 to 3

		For j := 1 to Len(aGerCol[i])
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica linha deletadaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If aGerCol[i][j][nUsado + 1]
				Loop
			EndIf

			dbSelectArea("PAD")
			dbSetOrder(1)

			If dbSeek(xFilial("PAD") + cCodLoj + DtoS(dDatEmi) + Str(i, 1) + aGerCol[i][j][npCodDsp])
				RecLock("PAD", .F.)
			Else
				RecLock("PAD", .T.)
			EndIf

			PAD_FILIAL := xFilial("PAD")
			PAD_LOJDV  := cCodLoj
			PAD_DTEMI  := dDatEmi
			PAD_DTVAL  := dDatVal
			PAD_PASTA  := i
			PAD_GRV    := .T.

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณGrava camposณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤู
			For k := 1 to nUsado
				If aHeader[k][10] != "V"
					FieldPut(FieldPos(aHeader[k][2]), aGerCol[i][j][k])
				EndIf
			Next k
			msUnlock()
		Next j
	Next i
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณApaga excedentesณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("PAD")
	dbSetOrder(1)
	dbSeek(xFilial("PAD") + cCodLoj + DtoS(dDatEmi))
	
	While !EOF();
		.And. PAD_FILIAL == xFilial("PAD");
		.And. PAD_LOJDV == cCodLoj;
		.And. PAD_DTEMI == dDatEmi
		
		RecLock("PAD", .F.)
		If PAD_GRV
			PAD_GRV := .F.
		Else
			dbDelete()
		EndIf
		msUnlock()
		
		dbSelectArea("PAD")
		dbSkip()
	EndDo
EndIf

Return