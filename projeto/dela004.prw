#INCLUDE "PROTHEUS.CH"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DELA004   �Autor  �Paulo Benedet          � Data �  02/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de manutencao do cadastro de kit de servicos            ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo menu SIGALOJA.XNU especifico.             ���
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
Project Function DELA004() 

Private aRotina := {}
Private cCadastro := "Kit de Servicos"

aAdd(aRotina, {"Pesquisar" , "axPesqui"  , 0, 1})
aAdd(aRotina, {"Visualizar", "P_DELA004M", 0, 2})
aAdd(aRotina, {"Alterar"   , "P_DELA004M", 0, 4})

dbSelectArea("SZ5")
dbGoTop()

mBrowse(6,1,22,75,"SZ5")

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DELA004M  �Autor  �Paulo Benedet          � Data �  05/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Montagem da tela para manipulacao/visualizacao dos kits        ���
����������������������������������������������������������������������������͹��
���Parametros�cAlias - Alias utilizado                                       ���
���          �nReg   - Numero do registro (Recno) atual                      ���
���          �nOpcx  - Opcao da mBrowse que foi selecionada                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada na visualizacao ou alteracao dos kits          ���
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
Project Function DELA004M(cAlias, nReg, nOpcx)
Local aEstIni := GetArea()
Local aEstSZ5 := SZ5->(GetArea())
Local aEstPA3 := PA3->(GetArea())

Local aSize    := {}
Local aObjects := {}
Local aInfo    := {}
Local aPosObj  := {}
Local aPosGet  := {}
Local nUsado   := 0
Local npCodPro := 0
Local lDel := IIf(nOpcx == 2, .F., .T.)
Local oDlg
Local oGet
Local i

Private cCodGrp := SZ5->Z5_COD
Private cDesGrp := SZ5->Z5_DESC

Private aHeader := {}
Private aCols   := {}

//���������������Ŀ
//�Carrega aHeader�
//�����������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("PA3")

While !EOF() .And. X3_ARQUIVO == "PA3"
	If x3Uso(X3_USADO);
		.And. cNivel >= X3_NIVEL;
		.And. rTrim(X3_CAMPO) != "PA3_GRUPO"
		nUsado += 1
		
		aAdd(aHeader, {Trim(X3_TITULO), X3_CAMPO, X3_PICTURE, ;
		X3_TAMANHO, X3_DECIMAL, X3_VLDUSER, ;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
	EndIf
	
	If rTrim(X3_CAMPO) == "PA3_CODPRO"
		npCodPro := nUsado
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
EndDo

//������������������Ŀ
//�Posiciona arquivos�
//��������������������
dbSelectArea("SB1")
dbSetOrder(1)

//�������������Ŀ
//�Carrega aCols�
//���������������
dbSelectArea("PA3")
dbSetOrder(1)
If dbSeek(xFilial("PA3") + cCodGrp)
	While !EOF();
		.And. PA3_FILIAL == xFilial("PA3");
		.And. PA3_GRUPO  == cCodGrp
		
		aAdd(aCols, Array(nUsado + 1))
		
		For i := 1 to nUsado
			If rTrim(aHeader[i][2]) == "PA3_DSCPRO"
				SB1->(dbSeek(xFilial("SB1") + aCols[Len(aCols)][npCodPro]))
				aCols[Len(aCols)][i] := SB1->B1_DESC
			Else
				aCols[Len(aCols)][i] := FieldGet(FieldPos(aHeader[i][2]))
			EndIf
		Next i
		
		aCols[Len(aCols)][nUsado + 1] := .F.
		
		dbSelectArea("PA3")
		dbSkip()
	EndDo
Else
	aCols := {Array(nUsado + 1)}
	aCols[1][nUsado + 1] := .F.
	
	For i := 1 to nUsado
		If rTrim(aHeader[i][2]) == "PA3_ITEM"
			aCols[1][i] := StrZero(1, TamSx3("PA3_ITEM")[1])
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
//�Calcula coordenadas do objeto�
//�������������������������������
aAdd(aObjects, {100, 20, .T., .T.})
aAdd(aObjects, {100, 100, .T., .T.})

aInfo   := {aSize[1], aSize[2], aSize[3], aSize[4], 5, 5}
aPosObj := msObjSize(aInfo, aObjects, .T.)
aPosGet := msObjGetPos(aSize[3] - aSize[1], 396, {{5,35,95}})

//�������������Ŀ
//�Monta dialogo�
//���������������
Define msDialog oDlg Title OemtoAnsi(cCadastro) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd Pixel

@ 27,aPosGet[1][1] Say OemToAnsi("Agregado") Size 31,9 of oDlg Pixel
@ 25,aPosGet[1][2] msGet cCodGrp When .F. Size 55,10 of oDlg Pixel
@ 25,aPosGet[1][3] msGet cDesGrp When .F. Size 115,10 of oDlg Pixel

oGet := msGetDados():New(aPosObj[2][1], aPosObj[2][2], aPosObj[2][3], aPosObj[2][4], nOpcx, "P_DA004LinOk", "P_DA004TudOk", "+PA3_ITEM", lDel,,, .T.)

bOk := {|| IIf(nOpcx == 3, IIf(oGet:TudoOk(), (Grava(), oDlg:End()), .T.), oDlg:End())}
bCancel := {|| oDlg:End()}

Activate msDialog oDlg on Init EnchoiceBar(oDlg, bOk, bCancel)

//�����������������Ŀ
//�Restaura ambiente�
//�������������������
RestArea(aEstSZ5)
RestArea(aEstPA3)
RestArea(aEstIni)

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �Grava     �Autor  �Paulo Benedet          � Data �  29/04/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Gravacao dos dados dos kits de servico no banco de dados       ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Acionada apos a confirmacao da alteracao do kit de servico     ���
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
Local nTamIt := TamSX3("PA3_ITEM")[1]
Local i, j

//�����������������Ŀ
//�Posiciona arquivo�
//�������������������
dbSelectArea("PA3")
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
	If dbSeek(xFilial("PA3") + cCodGrp + StrZero(nItem, nTamIt))
		RecLock("PA3", .F.)
	Else
		RecLock("PA3", .T.)
	EndIf
	
	For j := 1 to nUsado
		If aHeader[j][10] != "V"
			FieldPut(FieldPos(aHeader[j][2]), aCols[i][j])
		EndIf
	Next j
	
	PA3_FILIAL := xFilial("PA3")
	PA3_ITEM   := StrZero(nItem, nTamIt)
	PA3_GRUPO  := cCodGrp
	msUnlock()

Next i

nItem += 1

//����������������������Ŀ
//�Apaga linhas restantes�
//������������������������
dbSeek(xFilial("PA3") + cCodGrp + StrZero(nItem, nTamIt), .T.)

While !EOF();
	.And. PA3_FILIAL == xFilial("PA3");
	.And. PA3_GRUPO  == cCodGrp
	
	RecLock("PA3", .F.)
	dbDelete()
	msUnlock()
	
	dbSelectArea("PA3")
	dbSkip()
EndDo

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DA004LinOk�Autor  �Paulo Benedet          � Data �  02/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Validacao da linha de itens do kit de servicos                 ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �.T. se as validacoes estiverem corretas, .F. caso contrario    ���
����������������������������������������������������������������������������͹��
���Aplicacao �Acionada na mudanca de linha nos itens do kit de servico       ���
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
Project Function DA004LinOk()
Local npCodPro := aScan(aHeader, {|x| rTrim(x[2]) == "PA3_CODPRO"})
Local npQuant  := aScan(aHeader, {|x| rTrim(x[2]) == "PA3_QUANT"})

//�������������������������������Ŀ
//�Verifica se linha esta deletada�
//���������������������������������
If aCols[n][Len(aHeader) + 1]
	Return(.T.)
EndIf

//������������������������������������Ŀ
//�Verifica se campos estao preenchidos�
//��������������������������������������
If Empty(aCols[n][npCodPro])
	MsgAlert("O campo '" + aHeader[npCodPro][1] + "' deve ser informado!", "Aviso")
	Return(.F.)
EndIf

If Empty(aCols[n][npQuant])
	MsgAlert("O campo '" + aHeader[npQuant][1] + "' deve ser informado!", "Aviso")
	Return(.F.)
EndIf

Return(.T.)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DA004TudOk�Autor  �Paulo Benedet          � Data �  02/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Validacao de todas as informacoes da GetDados                  ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �.T. se as validacoes estiverem corretas, .F. caso contrario    ���
����������������������������������������������������������������������������͹��
���Aplicacao �Acionada antes da gravacao dos dados informados                ���
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
Project Function DA004TudOk()

Local npCodPro := aScan(aHeader, {|x| rTrim(x[2]) == "PA3_CODPRO"})
Local npQuant  := aScan(aHeader, {|x| rTrim(x[2]) == "PA3_QUANT"})
Local nLinha := Len(aCols)
Local nUsado := Len(aHeader)
Local i

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
	If Empty(aCols[i][npCodPro])
		MsgAlert("O campo '" + aHeader[npCodPro][1] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
	
	If Empty(aCols[i][npQuant])
		MsgAlert("O campo '" + aHeader[npQuant][1] + "' deve ser informado!", "Aviso")
		Return(.F.)
	EndIf
Next i

Return(.T.)
