/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA061      �Autor  �Paulo Benedet         � Data � 13/12/07 ���
����������������������������������������������������������������������������͹��
���Descricao � Cadastro de Lojas X Cond Pagto                                ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada via menu                                       ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                               ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA061()

Private cCadastro := "Lojas X Cond Pagto" // Titulo da tela
Private aRotina   := {} // Botoes da tela

aAdd(aRotina, {"Pesquisar", "axPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "P_DELA061A", 0, 2})
aAdd(aRotina, {"Alterar", "P_DELA061A", 0, 4})

mBrowse(6, 1, 22, 75, "SLJ")

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA061A     �Autor  �Paulo Benedet         � Data � 13/12/07 ���
����������������������������������������������������������������������������͹��
���Descricao � Tela de manutencao                                            ���
����������������������������������������������������������������������������͹��
���Parametros� cAlias - Alias da tabela alterada                             ���
���          � nReg   - Numero do registro em alteracao                      ���
���          � nOpc   - Numero do botao aRotina                              ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pela rotina DELA061                            ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                               ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA061A(cAlias, nReg, nOpc)
Local aTam     := msAdvSize(.T.) // resolucao da tela
Local aObj     := {} // objetos
Local aInf     := {} // posicao dos objetos
Local aPosObj  := {} // array com as posicoes dos objetos
Local aButtons := {} // botoes da enchoice bar
Local aCpoEnch := {"LJ_CODIGO", "LJ_NOME", "NOUSER"} // campos que aparecem na enchoice
Local cShow    := "PBJ_CONDPG|PBJ_DSCPG" // campos que aparecem na getdados
Local aNwHead  := {} // aheader
Local aNwCols  := {} // acols
Local nUsado   := 0 // numero de colunas
Local lGrv     := .F. // indica a confirmacao da tela
Local nOpcNw   := 0 // indica o tipo de acao sobre a getdados
Local nTotLin  := 0 // total de linhas do acols
Local npCondPg := 0 // posicao do campo PBJ_CONDPG
Local bOK // Acao executada apos clicar no botao OK
Local bCancel // Acao executada apos clicar no botao Cancelar
Local i, j // for next

If nOpc == 3
	nOpcNw := GD_INSERT + GD_DELETE + GD_UPDATE
EndIf	

// calcula coordenadas do objeto
aAdd(aObj, {100, 030, .T., .T.})
aAdd(aObj, {100, 070, .T., .T.})

aInfo   := {aTam[1], aTam[2], aTam[3], aTam[4], 3, 3}
aPosObj := msObjSize(aInfo, aObj, .T., .F.)

// Cria as variaveis da Enchoice (M->?)
RegToMemory("SLJ")

// Monta aHeader
dbSelectArea("SX3")
dbSetOrder(1) // X3_ARQUIVO+X3_ORDEM
dbSeek("PBJ")

While !EOF() .And. SX3->X3_ARQUIVO == "PBJ"
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
dbSelectArea("PBJ")
dbSetOrder(1) // 
dbSeek(xFilial("PBJ") + M->LJ_CODIGO)

While !EOF() .And. PBJ->(PBJ_FILIAL + PBJ_LOJA) == xFilial("PBJ") + M->LJ_CODIGO
	
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		If aNwHead[i][10] <> "V"
			aNwCols[Len(aNwCols)][i] := FieldGet(FieldPos(aNwHead[i][2]))
		ElseIf rTrim(aNwHead[i][2]) == "PBJ_DSCPG"
			aNwCols[Len(aNwCols)][i] := RetField("SE4", 1, xFilial("SE4") + PBJ->PBJ_CONDPG, "E4_DESCRI")
		EndIf
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
	
	dbSelectArea("PBJ")
	dbSkip()
EndDo

If Empty(aNwCols)
	aAdd(aNwCols, Array(nUsado + 1))
	For i := 1 to nUsado
		aNwCols[Len(aNwCols)][i] := CriaVar(aNwHead[i][2], .T.)
	Next i
	aNwCols[Len(aNwCols)][nUsado + 1] := .F.
EndIf

/*
Metodo New do objeto msmGet

MsMGet():NEW ( < ExpC1 > , [ ExpN2 ] , < ExpN3 > , [ ExpA4 ] , [ ExpC5 ] , [ ExpC6 ] , [ ExpA7 ] , [ ExpA8 ] , [ ExpA9 ] , [ ExpNA ] , [ ExpNB ] , [ ExpCC ] , [ ExpCD ] , [ ExpOE ] , [ ExpLF ] , [ ExpLG ] , [ ExpLH ] , [ ExpLI ] ) --> oObjMsMGet

ExpC1 
 Caracter
 Alias da tabela
 
ExpN2 
 Num�rico
 Numero do ID do registro. N�o � utilizado em caso de inclus�o de dados.
 
ExpN3 
 Num�rico
 Elemento da matriz aRotina.
 
ExpA4 
 Array
 Obsoleto
 
ExpC5 
 Caracter
 Obsoleto
 
ExpC6 
 Caracter
 Obsoleto
 
ExpA7 
 Array
 Matriz com a rela��o de campos do dicion�rio de dados que dever�o ser exibidos na interface. Caso n�o seja informado, todos os campos ser�o exibidos. Campos de usu�rio s�o sempre apresentados, exceto se no array for informado o texto 'NOUSER'.
Campos de template s�o sempre apresentados.
 
ExpA8 
 Array
 [1] - Coordenada TOP
[2] - Coordenada LEFT
[3] - Coordenada BOTTON
[4] - Coordenada RIGHT
 
ExpA9 
 Array
 Matriz com a rela��o de campos do dicion�rio de dados que poder�o sofrer edi��o. Caso n�o seja informado, todos os campos poder�o ser editados respeitando-se o dicion�rio de dados.
 
ExpNA 
 Num�rico
 Obsoleto
 
ExpNB 
 Num�rico
 Obsoleto
 
ExpCC 
 Caracter
 Obsoleto
 
ExpCD 
 Caracter
 Express�o macro-executada no evento TudoOk. Permite ao desenvolvedor realizar uma interven��o na valida��o dos dados antes do inicio da transa��o.
 
ExpOE 
 Objeto
 Objeto Dialog na qual a interface ser� publicada.
 
ExpLF 
 L�gico
 Uso interno
 
ExpLG 
 L�gico
 Determina se todos os dados devem vir de vari�veis de mem�ria
 
ExpLH 
 Array
 Uso interno
 
ExpLI 
 L�gico
 Permite que a visualiza��o dos dados em pastas seja desligada.
*/ 

// Monta dialogo
Define msDialog oDlg Title cCadastro From aTam[7],0 to aTam[6],aTam[5] of oMainWnd Pixel

oEnch := msMGet():New(cAlias, nReg, 2,,,, aCpoEnch, aPosObj[1],,,,, oDlg,,,, .F.,,.T.)
oGetD := msNewGetDados():New(aPosObj[2][1], aPosObj[2][2], aPosObj[2][3], aPosObj[2][4], nOpcNw, "P_DELA061B(oGetD, oGetD:nAt)", "P_DELA061B(oGetD, oGetD:nAt)",,,,,,,,, aNwHead, aNwCols)

bOK     := {|| IIf(oGetD:TudoOk(), (lGrv := .T.,  oDlg:End()), .F.)}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOK, bCancel)

If !lGrv
	Return
EndIf

//������������������������Ŀ
//� Gravacao dos Registros �
//��������������������������
nTotLin := Len(oGetD:aCols)

dbSelectArea("PBJ")
dbSetOrder(1) // PBJ_FILIAL+PBJ_LOJA+PBJ_CONDPG

For i := 1 to nTotLin
	If dbSeek(xFilial("PBJ") + M->LJ_CODIGO + P_nwFieldGet(oGetD, "PBJ_CONDPG", i))
		RecLock("PBJ", .F.)
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
			RecLock("PBJ", .T.)
			PBJ->PBJ_FILIAL := xFilial("PBJ")
			PBJ->PBJ_LOJA   := M->LJ_CODIGO
			For j := 1 to nUsado
				If oGetD:aHeader[j][10] <> "V"
					FieldPut(FieldPos(oGetD:aHeader[j][2]), oGetD:aCols[i][j])
				EndIf
			Next j
			msUnlock()
		EndIf
	EndIf
Next i

npCondPg := P_nwFieldPos(oGetD, "PBJ_CONDPG")
dbSeek(xFilial("PBJ") + M->LJ_CODIGO)

While !EOF() .And. PBJ->(PBJ_FILIAL + PBJ_LOJA) == xFilial("PBJ") + M->LJ_CODIGO
	If aScan(oGetD:aCols, {|x| AllTrim(x[npCondPg]) == PBJ->PBJ_CONDPG}) == 0
		RecLock("PBJ", .F.)
		dbDelete()
		msUnlock()
	EndIf
	
	dbSkip()
End

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA061B     �Autor  �Paulo Benedet         � Data � 13/12/07 ���
����������������������������������������������������������������������������͹��
���Descricao � Validacao da getdados                                         ���
����������������������������������������������������������������������������͹��
���Parametros� oObj - Objeto NewGetDados                                     ���
���          � nLin - Numero da linha                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � .T. - Linha correta                                           ���
���          � .F. - Linha incorreta                                         ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pela rotina DELA061A                           ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                               ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA061B(oObj, nLin)
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
		
		If P_nwFieldGet(oObj, "PBJ_CONDPG", i) == P_nwFieldGet(oObj, "PBJ_CONDPG", nLin)
			msgAlert("Condi��o de pagamento j� foi informada!", "Aviso")
			lRet := .F.
			Exit
		EndIf
	Next i
EndIf

Return(lRet)
