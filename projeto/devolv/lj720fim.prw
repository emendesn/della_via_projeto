
User Function LJ720FIM()
Local aArea    := GetArea()
Local aAreaSD1 := SD1->(GetArea())

Local nDecs := msDecimais(1)

Begin Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Insere o desconto da venda no valor da mercadoria |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)

While !EOF();
	.And. SD1->D1_FILIAL  == xFilial("SD1");
	.And. SD1->D1_DOC     == SF1->F1_DOC;
	.And. SD1->D1_SERIE   == SF1->F1_SERIE;
	.And. SD1->D1_FORNECE == SF1->F1_FORNECE;
	.And. SD1->D1_LOJA    == SF1->F1_LOJA
	
	If SD1->D1_VALDESC > 0
		RecLock("SD1", .F.)
		SD1->D1_VUNIT	:= SD1->D1_VUNIT - Round(SD1->D1_VALDESC / SD1->D1_QUANT, nDecs)	// Grava os Campo do Valor Unitario ja com desconto
		SD1->D1_TOTAL	:= Round(SD1->D1_VUNIT * SD1->D1_QUANT, nDecs)			  			// Totaliza novamente
		SD1->D1_DESC	:= 0																// Zera o Desconto
		SD1->D1_VALDESC	:= 0																// Zera o Valor do Desconto
		msUnlock()
	EndIf
	
	dbSelectArea("SD1")
	dbSkip()
End

If SF1->F1_DESCONT > 0
	RecLock("SF1", .F.)
	SF1->F1_VALMERC	:= SF1->F1_VALMERC - SF1->F1_DESCONT 					//Grava os Campo do Valor Unitario ja com desconto
	SF1->F1_DESCONT	:= 0													//Zera o Valor do Desconto
	msUnlock()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Altera prefixo do titulo gerado |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
dbSeek(xFilial("SE1") + SF1->F1_PREFIXO + SF1->F1_DUPL)

While !EOF();
	.And. SE1->E1_FILIAL  == xFilial("SE1");
	.And. SE1->E1_PREFIXO == SF1->F1_PREFIXO;
	.And. SE1->E1_NUM     == SF1->F1_DUPL
	
	If SE1->E1_TIPO == "NCC"
		RecLock("SE1", .F.)
		SE1->E1_PREFIXO := "U" + cFilAnt
		msUnlock()
		
		RecLock("SF1", .F.)
		SF1->F1_PREFIXO := "U" + cFilAnt
		msUnlock()
	EndIf
	
	dbSelectArea("SE1")
	dbSkip()
End

End Transaction

// restaura ambiente
RestArea(aAreaSD1)
RestArea(aArea)

Return
