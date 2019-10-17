/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100TOK ºAutor  ³Microsiga              º Data ³  10/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ParamIxb[1] - ?                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ lRet - .T. - Dados ok                                         º±±
±±º          ³        .F. - Dados incorretos                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Ponto de entrada do programa MATA103 (NF de entrada)          º±±
±±º          ³ na confirmacao da tela.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºBenedet   ³10/06/05³      ³Validar a exclusao do sepu.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			msgAlert(OemtoAnsi("O tamanho do número SEPU está incorreto!"), "Aviso")
			Exit
		EndIf
		
		// Verifica se SEPU ja foi incluido
		If PA4->(dbSeek(xFilial("PA4") + AllTrim(aCols[i][npLoteCtl])))
			lRet := .F.
			msgAlert(OemtoAnsi("Número de SEPU duplicado!"), "Aviso")
			Exit
		EndIf
	EndIf
Next i

EndIF

Return(lRet)
