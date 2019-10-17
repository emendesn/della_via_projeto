/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LJ7013   �Autor  �Norbert/Gaspar      � Data �  02/07/04   ���
�������������������������������������������������������������������������͹��
���Descricao �Tratamento dos valores de descontos a serem impressos no    ���
���          �cupom fiscal.                                               ���
�������������������������������������������������������������������������͹��
���Parametros� Array contendo :                                           ���
���          �  [1] - Codigo do Produto                                   ���
���          �  [2] - Descricao do Produto                                ���
���          �  [3] - Quantidade                                          ���
���          �  [4] - Valor Unitario                                      ���
���          �  [5] - Desconto                                            ���
���          �  [6] - Situacao tributaria e aliquota                      ���
���          �  [7] - Valor total do item                                 ���
�������������������������������������������������������������������������͹��
���Retorno   � Array contendo :                                           ���
���          �  [1] - Codigo do Produto                                   ���
���          �  [2] - Descricao do Produto                                ���
���          �  [3] - Quantidade                                          ���
���          �  [4] - Valor Unitario                                      ���
���          �  [5] - Desconto                                            ���
���          �  [6] - Situacao tributaria e aliquota                      ���
���          �  [7] - Valor total do item                                 ���
�������������������������������������������������������������������������͹��
���Observacao� Ponto de Entrada executado na impressao do cupom fiscal    ���
���          � na Venda Assistida. Chamado antes do registro do item no   ���
���          � ECF.                                                       ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LJ7013()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
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

//�������������������������������������������������������������������������������������Ŀ
//� Tratamento no desconto do item :                                                    �
//� - Zera o valor de desconto e imprime o valor unitario ja com desconto               �
//�                                                                                     �
//�   Exemplo:                                                                          �
//�   O registro esta gravado na tabela da seguinte forma:                              �
//�   Preco Unitatio = 1000,00   Vlr. Desconto = 100,00  Quant = 1  Vl. Liquido = 900,00�
//�                                                                                     �
//�   No ECF serah impresso:                                                            �
//�   Preco Unitatio =  900,00   Vlr. Desconto =   0,00  Quant = 1  Vl. Liquido = 900,00�
//���������������������������������������������������������������������������������������

//���������������������Ŀ
//�Calcula o valor total�
//�����������������������
nVlrTot := aCols[_nItem][aScan(aHeader ,{ |x| AllTrim(x[2]) == "LR_VLRITEM"})]
aDados[7] := Str(nVlrTot , atVlrItem[1], atVlrItem[2]) // Valor Total do Item
       
//�����������������������Ŀ
//�Calcula o valor do item�
//�������������������������
nVlrIte := Val(aDados[7]) / nQuant



//�����������������������������������������������Ŀ
//� Arredonda como Daruma FS2000 - preco unitario �
//�������������������������������������������������
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

//������������������������������������������������������������Ŀ
//�Verifica se existe diferenca do valor original com o valor a�
//�ser calculado                                               �
//��������������������������������������������������������������
//nDiff := Round((nVlrIte * nQuant) - nVlrTot, 2)



//�����������������������������������������Ŀ
//� Trunca como Daruma FS2000 - preco total �
//�������������������������������������������
nVlrLin := NoRound(nVlrIte * nQuant, 2)
nDiff   := nVlrLin - nVlrTot



//�������������������������������������������������������������Ŀ
//�Se o valor a ser impresso for maior, gera um desconto no item�
//�com a diferenca                                              �
//���������������������������������������������������������������
If nDiff > 0

	aDados[5] := Str(nDiff , atValDesc[1] , atValDesc[2]) // Valor do Desconto do Item

//���������������������������������������������������������Ŀ
//�Se o valor a ser impresso for menor, gera um acrescimo na�
//�venda com a diferenca                                    �
//�����������������������������������������������������������
ElseIf nDiff < 0

	If nDiff < 0
		Lj7T_SubTotal( 2, Lj7T_SubTotal(2) + (nDiff) )
	EndIf

	aDados[5] := Str(0, atValDesc[1] , atValDesc[2]) // Valor do Desconto do Item	

//��������������������������������������������Ŀ
//�Se nao ha diferenca, somente zera o desconto�
//����������������������������������������������
Else

	aDados[5] := Str(0, atValDesc[1] , atValDesc[2]) // Valor do Desconto do Item

EndIf

//�����������������������������������Ŀ
//�Atualiza contador para proximo item�
//�������������������������������������
If _nItem == Len(aCols)
	_nItem := 1
Else
	_nItem ++
EndIf

//����������������������������������������������������������������������Ŀ
//� Alimenta array de retorno.                                           �
//������������������������������������������������������������������������
aRetorno := aClone(aDados)

Return(aRetorno)
