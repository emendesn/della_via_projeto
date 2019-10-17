/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LJ7013   บAutor  ณNorbert/Gaspar      บ Data ณ  02/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTratamento dos valores de descontos a serem impressos no    บฑฑ
ฑฑบ          ณcupom fiscal.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Array contendo :                                           บฑฑ
ฑฑบ          ณ  [1] - Codigo do Produto                                   บฑฑ
ฑฑบ          ณ  [2] - Descricao do Produto                                บฑฑ
ฑฑบ          ณ  [3] - Quantidade                                          บฑฑ
ฑฑบ          ณ  [4] - Valor Unitario                                      บฑฑ
ฑฑบ          ณ  [5] - Desconto                                            บฑฑ
ฑฑบ          ณ  [6] - Situacao tributaria e aliquota                      บฑฑ
ฑฑบ          ณ  [7] - Valor total do item                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Array contendo :                                           บฑฑ
ฑฑบ          ณ  [1] - Codigo do Produto                                   บฑฑ
ฑฑบ          ณ  [2] - Descricao do Produto                                บฑฑ
ฑฑบ          ณ  [3] - Quantidade                                          บฑฑ
ฑฑบ          ณ  [4] - Valor Unitario                                      บฑฑ
ฑฑบ          ณ  [5] - Desconto                                            บฑฑ
ฑฑบ          ณ  [6] - Situacao tributaria e aliquota                      บฑฑ
ฑฑบ          ณ  [7] - Valor total do item                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Ponto de Entrada executado na impressao do cupom fiscal    บฑฑ
ฑฑบ          ณ na Venda Assistida. Chamado antes do registro do item no   บฑฑ
ฑฑบ          ณ ECF.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LJ7013()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aDados    := aClone(ParamIxb)
Local aRetorno  := {}
Local nVlrTot   := 0
Local nVlrIte   := 0
Local nDiff     := 0
Local nQuant    := Val(aDados[3])
Local nDecCup   := 4
Local nVlrDec   := 0
Local atVlrItem := TamSX3("L2_VLRITEM")
Local atValDesc := TamSX3("L2_VALDESC")

Static _nItem   := 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tratamento no desconto do item :                                                    ณ
//ณ - Zera o valor de desconto e imprime o valor unitario ja com desconto               ณ
//ณ                                                                                     ณ
//ณ   Exemplo:                                                                          ณ
//ณ   O registro esta gravado na tabela da seguinte forma:                              ณ
//ณ   Preco Unitatio = 1000,00   Vlr. Desconto = 100,00  Quant = 1  Vl. Liquido = 900,00ณ
//ณ                                                                                     ณ
//ณ   No ECF serah impresso:                                                            ณ
//ณ   Preco Unitatio =  900,00   Vlr. Desconto =   0,00  Quant = 1  Vl. Liquido = 900,00ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula o valor totalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nVlrTot := aCols[_nItem][aScan(aHeader ,{ |x| AllTrim(x[2]) == "LR_VLRITEM"})]
aDados[7] := Str(nVlrTot , atVlrItem[1], atVlrItem[2]) // Valor Total do Item
       
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula o valor do itemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nVlrIte := Val(aDados[7]) / nQuant



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Arredonda como Daruma FS2000 - preco unitario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nVlrDec := (nVlrIte - Int(nVlrIte)) * 100

If Int(nVlrDec) < 10
	cVlrDec := StrZero(Int(nVlrDec), 2) + "." + StrZero((nVlrDec - Int(nVlrDec)) * 10 , 1)
Else	
	cVlrDec := StrZero(Int(nVlrDec), 2) + "." + StrZero((nVlrDec - Int(nVlrDec)) * 100, 2)
EndIf

If Val(Right(cVlrDec, 1)) < 5
	If Len(cVlrDec) == 5
		nVlrDec := Int(Val(cVlrDec) * 10)
	Else
		nVlrDec := Int(Val(cVlrDec))
	EndIf
Else
	If Len(cVlrDec) == 5
		nVlrDec := Int(Val(cVlrDec) * 10) + 1
	Else
		nVlrDec := Int(Val(cVlrDec)) + 1
	EndIf
EndIf

If (nVlrDec / 100) > 1
	nVlrDec := nVlrDec / 1000
Else
	nVlrDec := nVlrDec / 100
EndIf

nVlrIte := Int(nVlrIte) + nVlrDec



aDados[4] := Str( nVlrIte ) // Valor Unitario do Item

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se existe diferenca do valor original com o valor aณ
//ณser calculado                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//nDiff := Round((nVlrIte * nQuant) - nVlrTot, 2)



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Trunca como Daruma FS2000 - preco total ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nVlrLin := NoRound(nVlrIte * nQuant, 2)
nDiff   := nVlrLin - nVlrTot



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o valor a ser impresso for maior, gera um desconto no itemณ
//ณcom a diferenca                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nDiff > 0

	aDados[5] := Str(nDiff , atValDesc[1] , atValDesc[2]) // Valor do Desconto do Item

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o valor a ser impresso for menor, gera um acrescimo naณ
//ณvenda com a diferenca                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf nDiff < 0

	If nDiff < 0
		Lj7T_SubTotal( 2, Lj7T_SubTotal(2) + (nDiff) )
	EndIf

	aDados[5] := Str(0, atValDesc[1] , atValDesc[2]) // Valor do Desconto do Item	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe nao ha diferenca, somente zera o descontoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Else

	aDados[5] := Str(0, atValDesc[1] , atValDesc[2]) // Valor do Desconto do Item

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza contador para proximo itemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If _nItem == Len(aCols)
	_nItem := 1
Else
	_nItem ++
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta array de retorno.                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aRetorno := aClone(aDados)

Return(aRetorno)
