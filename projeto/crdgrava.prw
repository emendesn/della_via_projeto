/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCRDGRAVA  บAutor  ณ Ernani Forastieri  บ Data ณ  28/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada na gravacao do cadastos de clientes       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ ParamIxb[1] - 2 -> Visualizacao                            บฑฑ
ฑฑบ          ณ               3 -> Inclusao                                บฑฑ
ฑฑบ          ณ               4 -> Alteracao                               บฑฑ
ฑฑบ          ณ               5 -> Exclusao                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T. - Inicia gravacao dos dados                            บฑฑ
ฑฑบ          ณ .F. - Volta pra tela de edicao sem gravar                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada na validacao do cadasto de clientes       บฑฑ
ฑฑบ          ณ no SIGACRD - CRDA010                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Della Via Pneus                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CrdGrava()
Local aArea     := GetArea()
Local lRet      := .F.
Local nTotPto   := 0
Local cCodUsu   := __cUserId
Local npPonto   := aScan(oGetD8:aHeader, {|x| rTrim(x[2]) == "MAI_PONTO"})
Local nTotCol   := Len(oGetD8:aCols)
Local cVarAtual := Space(TamSX3('PAK_CAMPO')[1])
Local i

// Somente inclusao ou alteracao
If ParamIXB[1] <> 3 .And. ParamIXB[1] <> 4
	Return(.T.)
EndIf

If M->A1_PESSOA == "J"
	If ParamIXB[1] == 4
		// Verifica permissoes de campos
		If PAK->(dbSeek(xFilial('PAK') + cCodUsu + cVarAtual))
			If PAK->PAK_PERMIS == 'T'
				lRet := .T.
			EndIf
		EndIf
		
		If !lRet
			MsgAlert(OemtoAnsi('Usuแrio sem permissใo para altera็ใo destas informa็๕es'), OemtoAnsi('ATENวรO'))
		EndIf
	Else
		lRet := .T.
	EndIf
	
ElseIf M->A1_PESSOA == "F" .And. (ParamIXB[1] == 3 .Or. ParamIXB[1] == 4)
	// Verificando pontuacao
	For i := 1 to nTotCol
		nTotPto += oGetD8:aCols[i][npPonto]
	Next i
	
	If nTotPto == 0
		MsgAlert(OemtoAnsi('Favor preencher o questionแrio!'), OemtoAnsi('Aviso'))
	ElseIf M->A1_VENCLC < dDataBase .And. ParamIXB[1] == 4
		If MsgNoYes(OemtoAnsi('O questionแrio foi atualizado?'), OemtoAnsi('Pergunta'))
			lRet := .T.
			M->A1_PONTOS += 1
		EndIf
	Else
		lRet := .T.
	EndIf
EndIf

RestArea(aArea)

Return(lRet)
