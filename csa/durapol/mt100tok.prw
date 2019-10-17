/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100TOK  ºAutor  ³Microsiga           º Data ³  24/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a Entrada da NF Normal no caso da nao existencia de  º±±
±±º          ³pedido de compras                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100TOK
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializacao de variaveis.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea       := GetArea()
	Local aAreaSA2    := SA2->(GetArea())
	Local npLocal     := aScan(aHeader, {|x| rTrim(x[2]) == "D1_LOCAL"})
	Local npLoteCtl   := aScan(aHeader, {|x| rTrim(x[2]) == "D1_LOTECTL"})
	Local npPedido    := aScan(aHeader, {|x| rTrim(x[2]) == "D1_PEDIDO"})
	Local npTES       := aScan(aHeader, {|x| rTrim(x[2]) == "D1_TES"})
	Local nCliente    := aScan(aHeader, {|x| rTrim(x[2]) == "D1_FORNECE"})
	LOCAL nPosStatus  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_X_STATU"})
	Local nTotLin     := Len(aCols)
	Local nTotCol     := Len(aHeader) + 1
	Local lNotStatus  := .F.
	Local lRet        := .T.
	Local i

	IF FUNNAME() == "MATA103"
		For i := 1 to nTotLin
			If aCols[i][nTotCol] //linha deletada
				Loop
			EndIf

			// Valida somente inclusao
			If !INCLUI
				Loop
			EndIf

			IF (cTipo=="N" .and. (_lLibsemPC:=Posicione("SF4",1,xFilial("SF4")+aCols[i][npTES],"F4_LIBPC"))<>"S" .and. Alltrim(funname()) $ "MATA103/MATA100")
				// Verifica se Existe Pedido de compra amarrado
				If Empty(aCols[i][npPedido])
					IF aA100For != "000590"
						lRet := .F.
						MsgAlert(OemtoAnsi("Necessario amarrar o item ao pedido de compra/venda!"), "Aviso")
						Exit
					EndIF
				EndIf
			Endif

			IF cTipo = "B" .AND. GetMv("MV_COLETA",,"0") = "0"
				MsgStop("As coletas não podem ser lançadas por esse programa","Atenção")
				lRet := .F.


				/*
				IF ! aCols[i][nPosStatus] $ "1" //Complementar
					lNotStatus := .T.
				EndIF

				IF lNotStatus
					lRet := .F.
					MsgInfo("Existe algum item com status nao permitido","Atenção")
				EndIF
				*/
			EndIF
		Next i
	EndIF

	RestArea(aAreaSA2)
	RestArea(aArea)
Return(lRet)
