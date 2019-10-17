#Include "Protheus.ch"
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � D05DadosSeg �Autor �Paulo Benedet       � Data �  19/05/05   ���
���������������������������������������������������������������������������͹��
���Descricao � Rotina para pedir os dados complementares das vendas com     ���
���          � seguro.                                                      ���
���������������������������������������������������������������������������͹��
���Parametros� nOpcx   - 1 - Orcamento                                      ���
���          �           2 - Venda                                          ���
���          � cNumOrc - Numero do orcamento de venda de seguro             ���
���������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                       ���
���������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada dentro do ponto de entrada LJ7002 da        ���
���          � Venda Assistida.                                             ���
���������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                           ���
���������������������������������������������������������������������������͹��
���          �        �      �                                              ���
���������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Project Function D05DadosSeg(nOpcx, cNumOrc)
Local aEstIni := GetArea()
Local aEstPA8 := PA8->(GetArea())
Local aEstSB1 := SB1->(GetArea())
Local aEstSL1 := SL1->(GetArea())
Local aEstSL2 := SL2->(GetArea())
Local aEstSX3 := SX3->(GetArea())

Local bValid
Local cShow := "PA8_ITORCS/PA8_CODPRO/PA8_DSCPRO/PA8_VLRPRO/PA8_APOLIC/PA8_MATRIC/PA8_KMSG/PA8_CODSEG/PA8_DSCSEG/PA8_ITEM/PA8_ITREF"
Local npItemL2  := aScan(aHeader, {|x| rTrim(x[2])=="LR_ITEM"})    // Coluna item da tela de venda
Local npProduto := aScan(aHeader, {|x| rTrim(x[2])=="LR_PRODUTO"}) // Coluna produto da tela de venda
Local npDescri  := aScan(aHeader, {|x| rTrim(x[2])=="LR_DESCRI"})  // Coluna descricao da tela de venda
Local npVrUnit  := aScan(aHeader, {|x| rTrim(x[2])=="LR_VRUNIT"})  // Coluna valor unitario da tela de venda
Local npItRefL2 := aScan(aHeader, {|x| rTrim(x[2])=="LR_ITREF"})   // Coluna item de referencia da tela de venda
Local npItem  := 0 // Coluna item na tela de seguro
Local npItOrc := 0 // Coluna item do orcamento na tela de seguro
Local npItRef := 0 // Coluna item de referencia na tela de seguro
Local i := 0
Local j := 0
Local nCont  := 0
Local aItVda := {}
Local aHeadLoc := {}
Local aColsLoc := {}
Local nTamLoc  := 0
Local aSavHead := {}
Local aSavCols := {}
Local nSavPos  := 0
Local nCampos := 0
Local cProxIt := ""
Local lTrcCli := .F.

Private nUsado  := 0
Private nTotLin := 0
Private oDlg, oGetD

//�������������������Ŀ
//�Posiciona orcamento�
//���������������������
dbSelectArea("SL1")
dbSetOrder(1) // L1_FILIAL+L1_NUM
dbSeek(xFilial("SL1") + cNumOrc)

//����������������������������������������Ŀ
//�Se cliente for o padrao nao fazer seguro�
//������������������������������������������
If SL1->L1_CLIENTE == GetMV("MV_CLIPAD") .And. SL1->L1_LOJA == GetMV("MV_LOJAPAD")
	RestArea(aEstPA8)
	RestArea(aEstSB1)
	RestArea(aEstSL1)
	RestArea(aEstSL2)
	RestArea(aEstSX3)
	RestArea(aEstIni)
	Return
EndIf

//�����������������Ŀ
//�Pega proximo item�
//�������������������
cProxIt := P_D05UltNum(SL1->L1_CLIENTE, SL1->L1_LOJA)

//���������������Ŀ
//�Carrega aHeader�
//�����������������
dbSelectArea("SX3")
dbSetOrder(1) //X3_ARQUIVO+X3_ORDEM
dbSeek("PA8")

While !EOF() .And. X3_ARQUIVO == "PA8"
	If x3Uso(X3_USADO);
		.And. cNivel >= X3_NIVEL;
		.And. rTrim(X3_CAMPO) $ cShow
		
		nUsado += 1
		
		aAdd(aHeadLoc, {Trim(X3_TITULO), X3_CAMPO, X3_PICTURE, ;
		X3_TAMANHO, X3_DECIMAL, X3_VLDUSER, ;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
		
		If rTrim(X3_CAMPO) == "PA8_ITEM"
			npItem  := nUsado
		ElseIf rTrim(X3_CAMPO) == "PA8_ITREF"
			npItRef := nUsado
		ElseIf rTrim(X3_CAMPO) == "PA8_ITORCS"
			npItOrc := nUsado
		EndIf
	EndIf
	
	dbSelectArea("SX3")
	dbSkip()
EndDo

//������������������Ŀ
//�Posiciona arquivos�
//��������������������
dbSelectArea("SB1")
dbSetOrder(1) // B1_FILIAL + B1_COD

dbSelectArea("PA8")
dbSetOrder(5) // PA8_FILIAL+PA8_LOJSG+PA8_ORCSG+PA8_ITORCS

//�������������������������������������������Ŀ
//�Verifica itens de venda para carregar aCols�
//���������������������������������������������
nCont   := 0
nTotLin := Len(aCols)
nCampos := Len(aHeader) + 1

For i := 1 to nTotLin

	//�����������������������Ŀ
	//�Verifica linha deletada�
	//�������������������������
	If aCols[i][nCampos]
		Loop
	EndIf
	
	//������������������������������Ŀ
	//�Monta array com itens de venda�
	//��������������������������������
	nCont += 1
	aAdd(aItVda, {aCols[i][npItemL2], StrZero(nCont, TamSX3("L2_ITEM")[1])})
	
	//���������������������������������������Ŀ
	//�Verifica se item possui dados de seguro�
	//�����������������������������������������
	If PA8->(dbSeek(xFilial("PA8") + cFilAnt + M->LQ_NUM + aCols[i][npItemL2])) .And. !Empty(aCols[i][npItRefL2])
	
		//������������������Ŀ
		//�Posiciona produtos�
		//��������������������
		SB1->(dbSeek(xFilial("SB1") + aCols[i][npProduto]))
		
		//������������������������������������������Ŀ
		//�Verifica se produto eh do grupo de seguros�
		//��������������������������������������������
		If SB1->B1_GRUPO == GetMV("FS_DEL001")
			aAdd(aColsLoc, Array(nUsado + 1))
			nTamLoc := Len(aColsLoc)
			
			For j := 1 to nUsado
				If rTrim(aHeadLoc[j][2]) == "PA8_DSCPRO"
					aColsLoc[nTamLoc][j] := RetField("SB1", 1, xFilial("SB1") + PA8->PA8_CODPRO, "B1_DESC")
				ElseIf rTrim(aHeadLoc[j][2]) == "PA8_DSCSEG"
					aColsLoc[nTamLoc][j] := RetField("PA9", 1, xFilial("PA9") + PA8->PA8_CODSEG, "PA9_DESC")
				Else
					aColsLoc[nTamLoc][j] := PA8->(FieldGet(FieldPos(aHeadLoc[j][2])))
				EndIf
			Next j
			
			aColsLoc[nTamLoc][nUsado + 1] := .F.
		EndIf
	Else

		//������������������Ŀ
		//�Posiciona produtos�
		//��������������������
		SB1->(dbSeek(xFilial("SB1") + aCols[i][npProduto]))

		//������������������������������������������Ŀ
		//�Verifica se produto eh do grupo de seguros�
		//��������������������������������������������
		If SB1->B1_GRUPO == GetMV("FS_DEL001")
			aAdd(aColsLoc, Array(nUsado + 1))
			nTamLoc := Len(aColsLoc)
			
			For j := 1 to nUsado
				If rTrim(aHeadLoc[j][2]) == "PA8_CODPRO"
					aColsLoc[nTamLoc][j] := aCols[i][npProduto]
				ElseIf rTrim(aHeadLoc[j][2]) == "PA8_DSCPRO"
					aColsLoc[nTamLoc][j] := aCols[i][npDescri]
				ElseIf rTrim(aHeadLoc[j][2]) == "PA8_ITEM"
					If (Val(cProxIt) > 0 .And. Val(cProxIt) < 9999) .Or. AllTrim(cProxIt) == "0000"
						cProxIt := StrZero(Val(cProxIt) + 1, TamSX3("PA8_ITEM")[1])
					Else
						cProxIt := Soma1(cProxIt)
					EndIf
					aColsLoc[nTamLoc][j] := cProxIt
				ElseIf rTrim(aHeadLoc[j][2]) == "PA8_VLRPRO"
					aColsLoc[nTamLoc][j] := aCols[i][npVrUnit]
				ElseIf rTrim(aHeadLoc[j][2]) == "PA8_ITREF"
					aColsLoc[nTamLoc][j] := aCols[i][npItRefL2]
				ElseIf rTrim(aHeadLoc[j][2]) == "PA8_ITORCS"
					aColsLoc[nTamLoc][j] := aCols[i][npItemL2]
				Else
					aColsLoc[nTamLoc][j] := CriaVar(aHeadLoc[j][2], .F.)
				EndIf
			Next j
			
			aColsLoc[nTamLoc][nUsado + 1] := .F.
		EndIf
	EndIf
Next i

//������������������������������������������������������������������Ŀ
//�Apaga itens segurados em orcamentos anteriores que foram deletados�
//��������������������������������������������������������������������
dbSelectArea("PA8")
dbSetOrder(4) // PA8_FILIAL + PA8_LOJSG + PA8_ORCSG + PA8_ITEM
dbSeek(xFilial("PA8") + cFilAnt + SL1->L1_NUM)

While !EOF();
	.And. PA8_FILIAL == xFilial("PA8");
	.And. PA8_LOJSG == cFilAnt;
	.And. PA8_ORCSG == SL1->L1_NUM
	
	If aScan(aColsLoc, {|x| x[npItem] == PA8->PA8_ITEM}) == 0
		RecLock("PA8", .F., .T.)
		dbDelete()
		msUnlock()
	EndIf
	
	dbSelectArea("PA8")
	dbSkip()
EndDo

//�����������������������������������Ŀ
//�Verifica se existem itens de seguro�
//�������������������������������������
nTotLin := Len(aColsLoc)

If nTotLin == 0
	RestArea(aEstPA8)
	RestArea(aEstSB1)
	RestArea(aEstSL1)
	RestArea(aEstSL2)
	RestArea(aEstSX3)
	RestArea(aEstIni)
	Return
EndIf

//��������������Ŀ
//�Salva ambiente�
//����������������
aSavHead := aClone(aHeader)
aSavCols := aClone(aCols)
nSavPos  := n

aHeader := aClone(aHeadLoc)
aCols   := aClone(aColsLoc)
n       := 1

//�������������Ŀ
//�Monta dialogo�
//���������������
Define msDialog oDlg Title "Venda de Seguro" From 65,0 to 383,686 of oMainWnd Pixel
oGetD := msGetDados():New(5, 5, 125, 339, 3, "P_D05LinOK()", "P_D05TudOk(.T.)",,,,,, nTotLin)   //"AlwaysTrue()"
Define sButton From 135,297 Type 1 Enable of oDlg Action IIf(oGetD:TudoOk(), oDlg:End(), .F.)
Activate msDialog oDlg Centered Valid IIf(nOpcx == 1, .T., IIf(oGetD:TudoOk(), .T., .F.))

//�����������������Ŀ
//�Posiciona arquivo�
//�������������������
dbSelectArea("SL2")
dbSetOrder(1) // L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO

dbSelectArea("PA8")
dbSetOrder(4) // PA8_FILIAL+PA8_LOJSG+PA8_ORCSG+PA8_ITEM

//���������������������������������������������Ŀ
//�Verifica se todos os campos foram preenchidos�
//�����������������������������������������������
If P_D05TudOk(.F.)
	
	//�����������������Ŀ
	//�Grava informacoes�
	//�������������������
	For i := 1 to nTotLin
		If PA8->(dbSeek(xFilial("PA8") + cFilAnt + SL1->L1_NUM + aCols[i][npItem]))
			RecLock("PA8", .F.)

			//���������������������������������Ŀ
			//�Verifica se o cliente foi trocado�
			//�����������������������������������
			If PA8->(PA8_CODCLI + PA8_LOJCLI) <> SL1->(L1_CLIENTE + L1_LOJA) .And. !lTrcCli
				lTrcCli := .T.
				cProxIt := P_D05UltNum(SL1->L1_CLIENTE, SL1->L1_LOJA)
			EndIf
			
		Else
			RecLock("PA8", .T.)
		EndIf
		
		PA8_FILIAL := xFilial("PA8")
		PA8_ORCSG  := SL1->L1_NUM
		PA8_LOJSG  := cFilAnt
		PA8_NFSG   := SL1->L1_DOC
		PA8_SRSG   := SL1->L1_SERIE
		PA8_DTSG   := IIf(Empty(SL1->L1_EMISNF), SL1->L1_EMISSAO, SL1->L1_EMISNF)
		PA8_CODCLI := SL1->L1_CLIENTE
		PA8_LOJCLI := SL1->L1_LOJA
		PA8_NOMCLI := RetField("SA1", 1, xFilial("SA1") + SL1->(L1_CLIENTE + L1_LOJA), "A1_NOME")
		PA8_CPROSG := aSavCols[Val(aCols[i][npItRef])][npProduto]
		PA8_VPROSG := aSavCols[Val(aCols[i][npItRef])][npVrUnit]
		PA8_PLACA  := SL1->L1_PLACAV
		PA8_CODMOD := SL1->L1_CODMOD
		PA8_CODMAR := SL1->L1_CODMAR
		PA8_ANO    := SL1->L1_ANO
		For j := 1 to nUsado
			If aHeader[j][10] != "V"
				FieldPut(FieldPos(aHeader[j][2]), aCols[i][j])
			EndIf
		Next j
		PA8_ITORCS := aItVda[aScan(aItVda, {|x| x[1] == aCols[i][npItOrc]})][2]
		PA8_ITREF  := aItVda[aScan(aItVda, {|x| x[1] == aCols[i][npItRef]})][2]
//		dbCommit()
		msUnlock()
		
		//����������������������Ŀ
		//�Acerta item pai no SL2�
		//������������������������
		SL2->(dbSeek(xFilial("SL2") + M->LQ_NUM + PA8->PA8_ITORCS))
		
		RecLock("SL2", .F.)
		L2_ITREF := PA8->PA8_ITREF
		msUnlock()
	Next i
	
	//�����������������������������������������������������������������Ŀ
	//�Refaz a sequencia de seguros do cliente (caso tenha sido trocado)�
	//�������������������������������������������������������������������
	If lTrcCli
		dbSelectArea("PA8")
		dbSetOrder(5) // PA8_FILIAL+PA8_LOJSG+PA8_ORCSG+PA8_ITORCS
		dbSeek(xFilial("PA8") + cFilAnt + SL1->L1_NUM)
		
		While !EOF();
			.And. PA8_FILIAL == xFilial("PA8");
			.And. PA8_LOJSG == cFilAnt;
			.And. PA8_ORCSG == SL1->L1_NUM
			
			If (Val(cProxIt) > 0 .And. Val(cProxIt) < 9999) .Or. AllTrim(cProxIt) == "0000"
				cProxIt := StrZero(Val(cProxIt) + 1, TamSX3("PA8_ITEM")[1])
			Else
				cProxIt := Soma1(cProxIt)
			EndIf
			
			RecLock("PA8", .F.)
			PA8->PA8_ITEM := cProxIt
//			dbCommit()
			msUnlock()
			
			dbSelectArea("PA8")
			dbSkip()
		EndDo
	EndIf
EndIf

//����������������Ŀ
//�Devolve ambiente�
//������������������
aHeader := aClone(aSavHead)
aCols   := aClone(aSavCols)
n       := nSavPos

RestArea(aEstPA8)
RestArea(aEstSB1)
RestArea(aEstSL1)
RestArea(aEstSL2)
RestArea(aEstSX3)
RestArea(aEstIni)

Return



/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � D05LinOk    �Autor �Anderson Kurtinaitis� Data �  11/08/05   ���
���������������������������������������������������������������������������͹��
���Descricao � Rotina para validar a linha digitada preenchendo as demais   ���
���          � linhas existentes com os mesmos dados da primeira linha,     ���
���          � porem somente alguns campos sao replicados                   ���
���������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada pelo programa D05DadosSeg.                  ���
���������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                           ���
���������������������������������������������������������������������������͹��
���          �        �      �                                              ���
���������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Project Function D05LinOk()
Local i	:= 0
Local j := 0
Local _lRetorno	:= .T.
Local npApolic	:= aScan(aHeader, {|x| rTrim(x[2])=="PA8_APOLIC"})   // Coluna onde fica a Apolice
Local npMatric	:= aScan(aHeader, {|x| rTrim(x[2])=="PA8_MATRIC"})   // Coluna onde fica a Matricula
Local npKmsg	:= aScan(aHeader, {|x| rTrim(x[2])=="PA8_KMSG"})   // Coluna onde fica a Kilometragem
Local npCodSeg	:= aScan(aHeader, {|x| rTrim(x[2])=="PA8_CODSEG"})   // Coluna onde fica o Codigo da Seguradora
Local npNomSeg	:= npCodSeg + 1

//�������������������������������������������������������Ŀ
//�Somente se usuario estiver na primeira linha do Array e�
//� existirem mais de um item no mesmo                    �
//���������������������������������������������������������
If n == 1 .and. nTotLin > 1
	
	//������������������������������������������������Ŀ
	//�Verifica cada campo,e se o mesmo esta preenchido�
	//��������������������������������������������������
	For j := 1 to nUsado
		If Empty(aCols[n][j])
			MsgAlert("O campo '" + aHeader[j][1] + "' deve ser preenchido!", "Aviso")
			_lRetorno	:= .F.
			Return(.F.)
		EndIf
	Next j
	
	//�����������������������������������������������������Ŀ
	//�Caso esteja todos os campos Ok, continua             �
	//�Verifica a quantidade de itens no array  e replica as�
	//� informacoes para os demais                          �
	//�������������������������������������������������������
	If _lretorno
		
		For i := 2 to Len(aCols)

			aCols[i][npApolic]	:= IIf(Empty(aCols[i][npApolic]), aCols[1][npApolic], aCols[i][npApolic])
			aCols[i][npMatric]	:= IIf(Empty(aCols[i][npMatric]), aCols[1][npMatric], aCols[i][npMatric])
			aCols[i][npKmsg]	:= IIf(Empty(aCols[i][npKmsg]  ), aCols[1][npKmsg]  , aCols[i][npKmsg]  )
			aCols[i][npCodSeg]	:= IIf(Empty(aCols[i][npCodSeg]), aCols[1][npCodSeg], aCols[i][npCodSeg])
			aCols[i][npNomSeg]	:= IIf(Empty(aCols[i][npNomSeg]), aCols[1][npNomSeg], aCols[i][npNomSeg])

		Next i
		
		oGetD:Refresh()
		oDlg:Refresh()
		
	EndIf

EndIf

Return(_lRetorno)


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � D05TudOk    �Autor �Paulo Benedet       � Data �  19/05/05   ���
���������������������������������������������������������������������������͹��
���Descricao � Rotina para validar o preenchimento dos campos da getdados   ���
���          � na tela de dados complementares do seguro.                   ���
���������������������������������������������������������������������������͹��
���Parametros� lMsg - .T. - Mostra mensagens de erro                        ���
���          �        .F. - Nao mostra mensagens de erro                    ���
���������������������������������������������������������������������������͹��
���Retorno   � .T. - getdados preenchida                                    ���
���          � .F. - getdados incompleta                                    ���
���������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada pelo programa D05DadosSeg.                  ���
���������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                           ���
���������������������������������������������������������������������������͹��
���          �        �      �                                              ���
���������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Project Function D05TudOk(lMsg)
Local i := 0
Local j := 0

//�������������������������Ŀ
//�Verifica tipo de operacao�
//���������������������������
For i := 1 to nTotLin
	For j := 1 to nUsado
		If Empty(aCols[i][j])
			If lMsg
				MsgAlert("O campo '" + aHeader[j][1] + "' deve ser preenchido!", "Aviso")
			EndIf
			Return(.F.)
		EndIf
	Next j
Next i

Return(.T.)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � D05UltNum   �Autor �Paulo Benedet       � Data �  19/05/05   ���
���������������������������������������������������������������������������͹��
���Descricao � Rotina para trazer o ultimo numero de item utilizado para o  ���
���          � cliente.                                                     ���
���������������������������������������������������������������������������͹��
���Parametros� cCodCli - Codigo do cliente                                  ���
���          � cLoja   - Loja do cliente                                    ���
���������������������������������������������������������������������������͹��
���Retorno   � cRet - Numero do item                                        ���
���������������������������������������������������������������������������͹��
���Aplicacao � Funcao executada pelo programa D05DadosSeg.                  ���
���������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                           ���
���������������������������������������������������������������������������͹��
���          �        �      �                                              ���
���������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Project Function D05UltNum(cCodCli, cLoja)
Local aEstIni := GetArea()
Local aEstPA8 := PA8->(GetArea())
Local cRet := "0000"

dbSelectArea("PA8")
dbSetOrder(3) // PA8_FILIAL + PA8_CODCLI + PA8_LOJCLI + PA8_ITEM
dbSeek(xFilial("PA8") + cCodCli + cLoja)

While !EOF();
	.And. PA8_FILIAL == xFilial("PA8");
	.And. PA8_CODCLI + PA8_LOJCLI == cCodCli + cLoja
	
	cRet := PA8->PA8_ITEM
	
	dbSelectArea("PA8")
	dbSkip()
EndDo

//����������������Ŀ
//�Retorna ambiente�
//������������������
RestArea(aEstPA8)
RestArea(aEstIni)

Return(cRet)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � D05Item     �Autor �Paulo Benedet       � Data �  19/05/05   ���
���������������������������������������������������������������������������͹��
���Descricao � Rotina para pedir ao usuario o codigo do produto que esta    ���
���          � sendo segurado.                                              ���
���������������������������������������������������������������������������͹��
���Parametros� Nao ha.                                                      ���
���������������������������������������������������������������������������͹��
���Retorno   � cRet - Numero do item do produto segurado                    ���
���������������������������������������������������������������������������͹��
���Aplicacao � Funcao executada na validacao do campo L2_PRODUTO            ���
���������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                           ���
���������������������������������������������������������������������������͹��
���          �        �      �                                              ���
���������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Project Function D05Item()

Local aEstIni := GetArea()
Local aEstSB1 := SB1->(GetArea())

Local cRet := ""
Local nOpc := 0
Local npProduto := aScan(aHeader, {|x| rTrim(x[2])=="LR_PRODUTO"}) // Coluna produto da tela de venda
Local npItem    := aScan(aHeader, {|x| rTrim(x[2])=="LR_ITEM"}) // Coluna item da tela de venda
//Local bValid := {|| ValidItem(cItem)}
Local cItem := Space(TamSX3("LR_ITEM")[1])
Local oDlg

//������������������������������������������Ŀ
//�Verifica se produto eh do grupo de seguros�
//��������������������������������������������
dbSelectArea("SB1")
dbSetOrder(1) // B1_FILIAL + B1_COD
dbSeek(xFilial("SB1") + aCols[n][npProduto])

//���������������������������������Ŀ
//�Verifica se grupo eh o de seguros�
//�����������������������������������
If SB1->B1_GRUPO == GetMV("FS_DEL001")
	
	//�������������Ŀ
	//�Monta dialogo�
	//���������������
	Define msDialog oDlg Title "No do Item Segurado" From 118,114 to 234,320 of oMainWnd Pixel
	
	@ 12,10 Say OemToAnsi("No. do Item") Size 31,8 of oDlg Pixel
	@ 10,55 msGet cItem Valid P_D05VldItem(cItem, aCols[n][npItem]) Size 32,10 of oDlg Pixel
	
	Define sButton From 45,30 Type 1 Enable of oDlg Action (nOpc := 1, oDlg:End())
	Define sButton From 45,70 Type 2 Enable of oDlg Action oDlg:End()
	
	oDlg:Activate(,,, .T.)
	
	//�������������Ŀ
	//�Retorna valor�
	//���������������
	If nOpc == 1
		cRet := StrZero(Val(cItem), TamSX3("LR_ITEM")[1])
	EndIf
EndIf

//����������������Ŀ
//�Retorna ambiente�
//������������������
RestArea(aEstSB1)
RestArea(aEstIni)

Return(cRet)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � D05VldItem  �Autor �Paulo Benedet       � Data �  19/05/05   ���
���������������������������������������������������������������������������͹��
���Descricao � Rotina para validar o numero do item informado pelo usuario. ���
���������������������������������������������������������������������������͹��
���Parametros� cItRef - Item pai do aCols a ser validado                    ���
���Parametros� cItem - Item filho do aCols                                  ���
���������������������������������������������������������������������������͹��
���Retorno   � .T. - Item valido                                            ���
���          � .F. - Item invalido                                          ���
���������������������������������������������������������������������������͹��
���Aplicacao � Funcao executada pela rotina D05Item e pelo pto entrada      ���
���          � LJ7001.                                                      ���
���������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                           ���
���������������������������������������������������������������������������͹��
���          �        �      �                                              ���
���������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Project Function D05VldItem(cItRef, cItem)

Local aEstIni := GetArea()
Local aEstSB1 := SB1->(GetArea())
Local aEstPA3 := PA3->(GetArea())

Local npProduto := aScan(aHeader, {|x| rTrim(x[2])=="LR_PRODUTO"}) // Coluna produto da tela de venda
Local npItem    := aScan(aHeader, {|x| rTrim(x[2])=="LR_ITEM"}) // Coluna item da tela de venda
Local nLinItem  := 0
Local nLinItRef := 0

//���������������Ŀ
//�Corrige tamanho�
//�����������������
If Len(AllTrim(cItRef)) < TamSX3("LR_ITEM")[1]
	cItRef := Replicate("0", TamSX3("LR_ITEM")[1] - Len(AllTrim(cItRef))) + AllTrim(cItRef)
EndIf

//���������������������Ŀ
//�Busca numero da linha�
//�����������������������
nLinItem  := aScan(aCols, {|x| x[npItem] == cItem})
nLinItRef := aScan(aCols, {|x| x[npItem] == cItRef})

If nLinItRef > Len(aCols) .Or. nLinItRef == 0
	MsgAlert("Numero do item incoerente!", "Aviso")
	Return(.F.)
EndIf

//����������������������������������Ŀ
//�Verifica se item pai eh de seguros�
//������������������������������������
dbSelectArea("SB1")
dbSetOrder(1) // B1_FILIAL + B1_COD
dbSeek(xFilial("SB1") + aCols[nLinItRef][npProduto])

If SB1->B1_GRUPO == GetMV("FS_DEL001")
	MsgAlert("Produto pai incoerente!", "Aviso")
	RestArea(aEstSB1)
	RestArea(aEstPA3)
	RestArea(aEstIni)
	Return(.F.)
EndIf

//������������������������Ŀ
//�Verifica kit de servicos�
//��������������������������
dbSelectArea("PA3")
dbSetOrder(2) // PA3_FILIAL+PA3_GRUPO+PA3_CODPRO
If !dbSeek(xFilial("PA3") + SB1->B1_AGREG + aCols[nLinItem][npProduto])
	MsgAlert("Produto pai nao consta no cadastro de servicos!", "Aviso")
	RestArea(aEstSB1)
	RestArea(aEstPA3)
	RestArea(aEstIni)
	Return(.F.)
EndIf

RestArea(aEstSB1)
RestArea(aEstPA3)
RestArea(aEstIni)

Return(.T.)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � D05Apaga    �Autor �Paulo Benedet       � Data �  19/05/05   ���
���������������������������������������������������������������������������͹��
���Descricao � Rotina para apagar os seguros.                               ���
���������������������������������������������������������������������������͹��
���Parametros� cNumOrc - Numero do orcamento                                ���
���������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                       ���
���������������������������������������������������������������������������͹��
���Aplicacao � Funcao executada pelo pto de entrada LOJA140B                ���
���������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                           ���
���������������������������������������������������������������������������͹��
���          �        �      �                                              ���
���������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Project Function D05Apaga(cNumOrc)
Local aEstIni := GetArea()
Local aEstPA8 := PA8->(GetArea())

//����������������������������Ŀ
//�Posiciona arquivo de seguros�
//������������������������������
dbSelectArea("PA8")
dbSetOrder(4) // PA8_FILIAL+PA8_LOJSG+PA8_ORCSG+PA8_ITEM
dbSeek(xFilial("PA8") + cFilAnt + cNumOrc)

While !EOF();
	.And. PA8_FILIAL == xFilial("PA8");
	.And. PA8_LOJSG == cFilAnt;
	.And. PA8_ORCSG == cNumOrc
	
	RecLock("PA8", .F.)
	dbDelete()
	msUnlock()
	
	dbSelectArea("PA8")
	dbSkip()
EndDo

RestArea(aEstPA8)
RestArea(aEstIni)
Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �D05GRAVANF�Autor  �Paulo Benedet             � Data � 23/08/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Grava informacoes de venda no seguro                          ���
����������������������������������������������������������������������������͹��
���Parametros� cNumOrc - Numero do orcamento                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo ponto de entrada LJ7002                   ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function D05GravaNF(cNumOrc)
Local aArea    := GetArea()
Local aAreaSL1 := SL1->(GetArea())
Local aAreaPA8 := PA8->(GetArea())

//�������������������Ŀ
//�Posiciona orcamento�
//���������������������
dbSelectArea("SL1")
dbSetOrder(1) //L1_FILIAL+L1_NUM
If dbSeek(xFilial("SL1") + cNumOrc)
	
	//����������������������������Ŀ
	//�Posiciona arquivo de seguros�
	//������������������������������
	dbSelectArea("PA8")
	dbSetOrder(5) //PA8_FILIAL+PA8_LOJSG+PA8_ORCSG+PA8_ITORCS
	dbSeek(xFilial("PA8") + cFilAnt + SL1->L1_NUM)
	
	While !EOF();
		.And. PA8_FILIAL == xFilial("PA8");
		.And. PA8_LOJSG == cFilAnt;
		.And. PA8_ORCSG == SL1->L1_NUM
		
		RecLock("PA8", .F.)
		PA8_NFSG   := SL1->L1_DOC
		PA8_SRSG   := SL1->L1_SERIE
		PA8_DTSG   := IIf(Empty(SL1->L1_EMISNF), SL1->L1_EMISSAO, SL1->L1_EMISNF)
		msUnlock()
		
		dbSelectArea("PA8")
		dbSkip()
	EndDo
EndIf

RestArea(aAreaSL1)
RestArea(aAreaPA8)
RestArea(aArea)
Return
