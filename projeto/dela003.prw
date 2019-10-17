#Include "Protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DELA003   �Autor  �Paulo Benedet          � Data �  02/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de manutencao do cadastro de pecas x veiculos           ���
����������������������������������������������������������������������������͹��
���Parametros� cAlias - Alias do mbrowse                                     ���
���          � nReg   - Numero do registro posicionado                       ���
���          � nOpcX  - Opcao do aRotina                                     ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada atraves do botao incluido na tela de produtos  ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA003(cAlias, nReg, nOpcx)

//�������������������������������������������������������������������������Ŀ
//�array asize - tamanho da dialog e area de trabalho                       �
//�1 - linha inicial area de trabalho                                       �
//�2 - coluna inicial area de trabalho                                      �
//�3 - linha final area de trabalho                                         �
//�4 - coluna final area de trabalho                                        �
//�5 - coluna final dialog                                                  �
//�6 - linha final dialog                                                   �
//�7 - linha inicial dialog                                                 �
//�                                                                         �
//�array aobjects - tamanho padrao dos objetos para calculo das posicoes    �
//�1 - tamanho x                                                            �
//�2 - tamanho y                                                            �
//�3 - dimensiona x                                                         �
//�4 - dimensiona y                                                         �
//�5 - retorna dimensoes x e y (size) ao inves de linha / coluna final      �
//�                                                                         �
//�array ainfo - tamanho da area onde sera calculada as posicoes dos objetos�
//�1 - posicao inicial x                                                    �
//�2 - posicao inicial y                                                    �
//�3 - posicao final x                                                      �
//�4 - posicao final y                                                      �
//�5 - espaco lateral entre os objetos                                      �
//�6 - espaco vertical entre os objetos                                     �
//���������������������������������������������������������������������������

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

//����������������Ŀ
//�Busca descricoes�
//������������������
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

//���������������Ŀ
//�Carrega aHeader�
//�����������������
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

//������������������Ŀ
//�Posiciona arquivos�
//��������������������
dbSelectArea("PA0")
dbSetOrder(1)

dbSelectArea("PA1")
dbSetOrder(1)

//�������������Ŀ
//�Carrega aCols�
//���������������
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

//������������������������������������Ŀ
//�Devolve dimensoes da tela do usuario�
//��������������������������������������
aSize := msAdvSize(.T.)

//�����������������������������Ŀ
//�calcula coordenadas do objeto�
//�������������������������������
aAdd(aObjects, {100, 33, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})

aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 5, 5}
aPosObj := msObjSize(aInfo, aObjects, .T.)
aPosGet := msObjGetPos(aSize[3] - aSize[1], 390, {{5,30,90,210,235,272}})

//�������������Ŀ
//�Monta dialogo�
//���������������
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

//����������������������������������������Ŀ
//�Tratamento do nOpcX para rotina de copia�
//������������������������������������������
If P_NaPilha("A010COPIA")
	nOpcX := 1
EndIf

oGet := msGetDados():New(aPosObj[2][1], aPosObj[2][2], aPosObj[2][3], aPosObj[2][4], nOpcX, "P_DA003LinOk", "P_DA003TudOk", "+PA2_ITEM", .T.,,, .T., 999)

Activate msDialog oDlg on Init EnchoiceBar(oDlg, {|| Iif(P_DA003TudOk(),(Grava(), oDlg:End()),.F.)}, {|| oDlg:End()})

//����������������Ŀ
//�Retorna ambiente�
//������������������
RestArea(aEstPA0)
RestArea(aEstPA1)
RestArea(aEstPA2)
RestArea(aEstSBM)
RestArea(aEstSZ3)
RestArea(aEstSZ4)
RestArea(aEstIni)

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �Grava     �Autor  �Paulo Benedet          � Data �  29/04/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Efetiva as informacoes de pecas e veiculos no banco de dados   ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada apos a confirmacao da tela de pecas x veiculo  ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function Grava()

Local nUsado := Len(aHeader)
Local nLinha := Len(aCols)
Local nItem  := 0
Local nTamIt := TamSX3("PA2_ITEM")[1]
Local i, j

//�����������������Ŀ
//�Posiciona arquivo�
//�������������������
dbSelectArea("PA2")
dbSetOrder(1)

//�����������Ŀ
//�Grava acols�
//�������������
For i := 1 to nLinha

	//�������������������������������Ŀ
	//�Verifica se linha esta deletada�
	//���������������������������������
	If aCols[i][nUsado + 1]
		Loop
	EndIf
	
	//���������������Ŀ
	//�Acrescenta item�
	//�����������������
	nItem += 1
	
	//����������Ŀ
	//�Grava item�
	//������������
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

//����������������������Ŀ
//�Apaga linhas restantes�
//������������������������
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

//��������������Ŀ
//�Forca gravacao�
//����������������
dbCommit()

//����������Ŀ
//�Grava flag�
//������������
RecLock("SB1", .F.)
B1_FLGPA2 := .T.
msUnlock()

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DA003LinOk�Autor  �Paulo Benedet          � Data �  29/04/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Valida as informacoes da linha da getdados                     ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �.T. se as validacoes estiverem corretas, .F. caso contrario    ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada apos a confirmacao da tela de pecas x veiculo  ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DA003LinOk()

Local npAnoDe  := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANODE"})
Local npAnoAte := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANOATE"})
Local nUsado := Len(aHeader)
Local lRet := .T.
Local i

//�������������������������������Ŀ
//�Verifica se linha esta deletada�
//���������������������������������
If aCols[n][nUsado + 1]
	Return(.T.)
EndIf

//������������������������������������Ŀ
//�Verifica se campos estao preenchidos�
//��������������������������������������
For i := 1 to nUsado
	If Empty(aCols[n][i]) .And. aHeader[i][10] != "V"
		MsgAlert("O campo '" + aHeader[i][1] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
Next i

//��������������������Ŀ
//�Verifica campos data�
//����������������������
If aCols[n][npAnoDe] > aCols[n][npAnoAte]
	MsgAlert("Campo 'AnoDe' nao pode ser maior que 'AnoAte'!", "Aviso")
	lRet := .F.
EndIf

Return(lRet)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DA003TudOk�Autor  �Paulo Benedet          � Data �  29/04/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Valida as informacoes da getdados                              ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �.T. se as validacoes estiverem corretas, .F. caso contrario    ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada apos a confirmacao da tela de pecas x veiculo  ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DA003TudOk()

Local npAnoDe  := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANODE"})
Local npAnoAte := aScan(aHeader, {|x| rTrim(x[2]) == "PA2_ANOATE"})
Local nUsado := Len(aHeader)
Local nLinha := Len(aCols)
Local i, j

For i := 1 to nLinha

	//�������������������������������Ŀ
	//�Verifica se linha esta deletada�
	//���������������������������������
	If aCols[i][nUsado + 1]
		Loop
	EndIf
	
	//������������������������������������Ŀ
	//�Verifica se campos estao preenchidos�
	//��������������������������������������
	For j := 1 to nUsado
		If Empty(aCols[i][j]) .And. aHeader[j][10] != "V"
			MsgAlert("O campo '" + aHeader[j][1] + "' deve ser informado!", "Aviso")
			Return(.F.)
		EndIf
	Next j
	
	//��������������������Ŀ
	//�Verifica campos data�
	//����������������������
	If aCols[i][npAnoDe] > aCols[i][npAnoAte]
		MsgAlert("Campo 'AnoDe' nao pode ser maior que 'AnoAte'!", "Aviso")
		Return(.F.)
	EndIf
Next i

Return(.T.)