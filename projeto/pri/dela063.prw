/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELA063      ºAutor  ³Paulo Benedet         º Data ³ 13/12/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Promocoes                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Funcao chamada via menu                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via Pneus                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DELA063()

Private cCadastro := "Promocoes X Produto" // Titulo da tela
Private aRotina   := {} // Botoes da tela

aAdd(aRotina, {"Pesquisar" , "axPesqui"  , 0, 1})
aAdd(aRotina, {"Visualizar", "P_DELA063A", 0, 2})
aAdd(aRotina, {"Incluir"   , "P_DELA063A", 0, 3})
aAdd(aRotina, {"Alterar"   , "P_DELA063A", 0, 4})

mBrowse(6, 1, 22, 75, "PBL")

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELA063A     ºAutor  ³Paulo Benedet         º Data ³ 13/12/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela de manutencao                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cAlias - Alias da tabela alterada                             º±±
±±º          ³ nReg   - Numero do registro em alteracao                      º±±
±±º          ³ nOpc   - Numero do botao aRotina                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Funcao chamada pela rotina DELA063                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via Pneus                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DELA063A(cAlias, nReg, nOpc)
Local aTam     := msAdvSize(.T.) // resolucao da tela
Local aObj     := {} // objetos
Local aInf     := {} // posicao dos objetos
Local aPosObj  := {} // array com as posicoes dos objetos
Local aNwHead  := {} // aheader
Local aNwCols  := {} // acols
Local cShow    := "PBM_LOJA|PBM_DSCLOJ" // campos que aparecem na getdados
Local nUsado   := 0 // numero de colunas
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
aAdd(aObj, {100, 033, .T., .T.})
aAdd(aObj, {100, 067, .T., .T.})

aInfo   := {aTam[1], aTam[2], aTam[3], aTam[4], 3, 3}
aPosObj := msObjSize(aInfo, aObj, .T., .F.)

// Cria as variaveis da Enchoice (M->?)
If nOpc == 3
	RegToMemory("PBL", .T.)
Else
	RegToMemory("PBL", .F.)
EndIf

// Monta aHeader
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PBM")

While !EOF() .And. SX3->X3_ARQUIVO == "PBM"
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
dbSelectArea("PBM")
dbSetOrder(1) // PBM_FILIAL+PBM_CODPRO+PBM_LOJA
dbSeek(xFilial("PBM") + M->PBL_CODPRO)

While !EOF() .And. PBM->(PBM_FILIAL + PBM_CODPRO) == xFilial("PBM") + M->PBL_CODPRO
	
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		If aNwHead[i][10] <> "V"
			aNwCols[Len(aNwCols)][i] := FieldGet(FieldPos(aNwHead[i][2]))
		ElseIf rTrim(aNwHead[i][2]) == "PBM_DSCLOJ"
			aNwCols[Len(aNwCols)][i] := RetField("SLJ", 1, xFilial("SLJ") + PBM->PBM_LOJA, "LJ_NOME")
		EndIf
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
	
	dbSelectArea("PBM")
	dbSkip()
EndDo

If Empty(aNwCols)
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		aNwCols[Len(aNwCols)][i] := CriaVar(aNwHead[i][2], .T.)
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta dialogo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define msDialog oDlg Title cCadastro From aTam[7],0 to aTam[6],aTam[5] of oMainWnd Pixel

oEnch := msMGet():New(cAlias, nReg, nOpc,,,,, aPosObj[1],,,,, oDlg,,,, .F.,,.T.)
oGetD := msNewGetDados():New(aPosObj[2][1], aPosObj[2][2], aPosObj[2][3], aPosObj[2][4], nOpcNw, "P_DELA063B(oGetD, oGetD:nAt)", "P_DELA063B(oGetD, oGetD:nAt)",,,,,,,,, aNwHead, aNwCols)

bOK     := {|| IIf(Obrigatorio(oEnch:aGets, oEnch:aTela) .And. oGetD:TudoOk(), (lGrv := .T.,  oDlg:End()), .F.)}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOK, bCancel)

If !lGrv
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao dos Registros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotLin := Len(oGetD:aCols)
npLoja  := P_nwFieldPos(oGetD, "PBM_LOJA")

dbSelectArea("PBM")
dbSetOrder(1) // PBM_FILIAL+PBM_CODPRO+PBM_LOJA

For i := 1 to nTotLin
	If dbSeek(xFilial("PBM") + M->PBL_CODPRO + oGetD:aCols[i][npLoja])
		RecLock("PBM", .F.)
		If P_nwDeleted(oGetD, i)
			dbDelete()
		Else
			For j := 1 to nUsado
				If oGetD:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD:aHeader[j][2]), oGetD:aCols[i][j])
				EndIf
			Next j
		EndIf
		msUnlock()
	Else
		If !P_nwDeleted(oGetD, i)
			RecLock("PBM", .T.)
			PBM->PBM_FILIAL := xFilial("PBM")
			PBM->PBM_CODPRO := M->PBL_CODPRO
			For j := 1 to nUsado
				If oGetD:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD:aHeader[j][2]), oGetD:aCols[i][j])
				EndIf
			Next j
			msUnlock()
		EndIf
	EndIf
Next i

dbSeek(xFilial("PBM") + M->PBL_CODPRO)

While !EOF() .And. PBM->(PBM_FILIAL + PBM_CODPRO) == xFilial("PBM") + M->PBL_CODPRO
	If aScan(oGetD:aCols, {|x| AllTrim(x[npLoja]) == PBM->PBM_LOJA}) == 0
		RecLock("PBM", .F.)
		dbDelete()
		msUnlock()
	EndIf
	
	dbSkip()
End

dbSelectArea("PBL")
dbSetOrder(1) // PBL_FILIAL+PBL_CODPRO
nTotLin := fCount()

If dbSeek(xFilial("PBL") + M->PBL_CODPRO)
	RecLock("PBL", .F.)
Else
	RecLock("PBL", .T.)
	PBL->PBL_FILIAL := xFilial("PBL")
	PBL->PBL_CODPRO := M->PBL_CODPRO
EndIf

For i := 1 to nTotLin
	If !(FieldName(i) $ "PBL_FILIAL|PBL_CODPRO")
		FieldPut(i, &("M->" + FieldName(i)))
	EndIf
Next i
msUnlock()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELA063B     ºAutor  ³Paulo Benedet         º Data ³ 13/12/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao da getdados                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ oObj - Objeto NewGetDados                                     º±±
±±º          ³ nLin - Numero da linha                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .T. - Linha correta                                           º±±
±±º          ³ .F. - Linha incorreta                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Funcao chamada pela rotina DELA063A                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via Pneus                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DELA063B(oObj, nLin)
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
		
		If P_nwFieldGet(oObj, "PBM_LOJA", i) == P_nwFieldGet(oObj, "PBM_LOJA", nLin)
			msgAlert("Loja já informada!", "Aviso")
			lRet := .F.
			Exit
		EndIf
	Next i
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DELA063C     ºAutor  ³Priscila Prado        º Data ³ 05/08/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o produto possui promocao.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .T. - Possui Promocao                                         º±±
±±º          ³ .F. - Nao possui promocao                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Funcao chamada pela rotina DELA007C                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³        ³      ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via Pneus                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Project Function DELA063C()
Local aAreaPBM := GetArea()
Local lRet 		:= .F. // retorno da funcao
Local cProdDela := ""

If AllTrim(FunName()) == "TMKA271" 
	cProdDela := M->UB_PRODUTO
Else
	cProdDela := M->LR_PRODUTO
EndIf

PBL->(DbSetOrder(1))
If PBL->(dbSeek(xFilial("PBM") + cProdDela))
	If AllTrim(FunName()) == "TMKA271"
		M->UB_VRUNIT 	:= PBL->PBL_VALOR
		If PBL->PBL_LOCAL <> M->UB_LOCAL
			M->UB_LOCAL :=	PBL->PBL_LOCAL 
		Endif
	Else
		M->LR_VRUNIT 	:= PBL->PBL_VALOR
		If PBL->PBL_LOCAL <> M->LR_LOCAL
			M->LR_LOCAL :=	PBL->PBL_LOCAL
		Endif
	EndIf        
		lRet := .T.
EndIf


RestArea(aAreaPBM)

Return(lRet)

Project Function DELA063D()
Local aAreaPBM := GetArea()
Local cProdDela := ""

If AllTrim(FunName()) == "TMKA271" 
	cProdDela := M->UB_PRODUTO
Else
	cProdDela := M->LR_PRODUTO
EndIf

PBL->(DbSetOrder(1))
If PBL->(dbSeek(xFilial("PBM") + cProdDela))
	If AllTrim(FunName()) == "TMKA271"
		M->UB_VRUNIT 	:= PBL->PBL_VALOR
		If PBL->PBL_LOCAL <> M->UB_LOCAL
			M->UB_LOCAL :=	PBL->PBL_LOCAL
		Endif
	Else
		M->LR_VRUNIT 	:= PBL->PBL_VALOR
		If PBL->PBL_LOCAL <> M->LR_LOCAL
			M->LR_LOCAL :=	PBL->PBL_LOCAL
		Endif
	EndIf
EndIf

RestArea(aAreaPBM)

Return(.T.)


//Gatilho do Preço unitario
Project Function DELA063E()
Local aAreaPBM := GetArea()
Local nRet     := 0  
Local nQut     := 0

If SUB->UB_QUANT = Nil .Or. SUB->UB_QUANT = 0
	nQut  := 1
EndIf                

PBL->(DbSetOrder(1))
If PBL->(dbSeek(xFilial("PBM") + M->UB_PRODUTO))
		M->UB_VRUNIT 	:= PBL->PBL_VALOR
		nRet 	:= PBL->PBL_VALOR 
		M->UB_VLRITEM := (nQut * PBL->PBL_VALOR )
Endif

RestArea(aAreaPBM)

Return(nRet)
