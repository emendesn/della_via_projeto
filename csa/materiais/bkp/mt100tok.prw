/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � MT100TOK �Autor  �Microsiga              � Data �  10/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� ParamIxb[1] - ?                                               ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - Dados ok                                         ���
���          �        .F. - Dados incorretos                                 ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada do programa MATA103 (NF de entrada)          ���
���          � na confirmacao da tela.                                       ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �10/06/05�      �Validar a exclusao do sepu.                    ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function MT100TOK()
Local npCod     := aScan(aHeader, {|x| rTrim(x[2]) == "D1_COD"})
Local npLocal   := aScan(aHeader, {|x| rTrim(x[2]) == "D1_LOCAL"})
Local npLoteCtl := aScan(aHeader, {|x| rTrim(x[2]) == "D1_LOTECTL"})
Local nTotLin := Len(aCols)
Local nTotCol := Len(aHeader) + 1
Local lRet := .T.
Local i

IF SM0->M0_CODIGO <> "03" //Nao considero na Durapol
// Escolhe indice
PA4->(dbSetOrder(1))

For i := 1 to nTotLin
	If aCols[i][nTotCol] //linha deletada
		Loop
	EndIf
	
	// Valida somente inclusao
	If !INCLUI
		Loop
	EndIf
	
	// Busca os produtos SEPU
	If AllTrim(aCols[i][npCod]) == GetMV("FS_DEL008");
		.And. aCols[i][npLocal] == GetMV("FS_DEL013")
		
		// Verifica tipo de nota
		If cTipo <> "B"
			lRet := .F.
			msgAlert(OemtoAnsi("O tipo de nota para entrada de SEPU deve ser 'B' !"), "Aviso")
			Exit
		EndIf
			
		// Verifica tamanho do codigo SEPU
		If Len(AllTrim(aCols[i][npLoteCtl])) <> TamSX3("PA4_SEPU")[1]
			lRet := .F.
			msgAlert(OemtoAnsi("O tamanho do n�mero SEPU est� incorreto!"), "Aviso")
			Exit
		EndIf
		
		// Verifica se SEPU ja foi incluido
		If PA4->(dbSeek(xFilial("PA4") + AllTrim(aCols[i][npLoteCtl])))
			lRet := .F.
			msgAlert(OemtoAnsi("N�mero de SEPU duplicado!"), "Aviso")
			Exit
		EndIf
	EndIf
Next i

EndIF

Return(lRet)
