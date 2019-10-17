#INCLUDE "protheus.ch"

Project Function DelA050()

Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local aTitulos	:= {}
Local cSE1		:= "SE1"
Local nPTitulo	:= aPosicoes[1][2]							//Numero do Titulo  
Local nPPrefix	:= aPosicoes[2][2]							//Prefixo do Titulo
Local nPParcel	:= aPosicoes[3][2]							//Parcela do Titulo
Local nPTipo	:= aPosicoes[4][2]							//Tipo do Titulo
Local nNAtu		:= N  
Local nLenAux

#IFDEF TOP
	Local cQuery	:= ""									// Query para TOP
	Local aStruSE1	:= SE1->(DbStruct())					// Estrutura do Alias SE1
	Local nI		:= 0 
#ENDIF

If !ApMsgYesNo("Inserir titulos não vencidos?","DELA050")
	Return Nil
EndIf
	
//lVencido := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona os titulos A VENCER do cliente atual. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SE1")
DbSetOrder(1)		// E1_FILIAL+DTOS(E1_VENCREA)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA
#IFDEF TOP
	cSE1	:= "TMPSE1"	
	cQuery	:=	" SELECT	E1_FILIAL, E1_VENCREA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_VENCTO, E1_VENCORI, " +;
				" 			E1_LOJA, E1_NATUREZ, E1_PORTADO, E1_NUMBOR, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_HIST " +;
				" FROM " +	RetSqlName("SE1") + " SE1 " +;
				" WHERE	SE1.E1_VENCREA 	>= 	'" + DtoS(dDataBase) + 	"' AND" +;
				"		SE1.E1_CLIENTE 	= 	'" + M->ACF_CLIENT + 	"' AND" +;
				"		SE1.E1_LOJA 	= 	'" + M->ACF_LOJA + 		"' AND" +;
				"		SE1.D_E_L_E_T_ 	= 	''" +;
				" ORDER BY " + SqlOrder(IndexKey())
	
	cQuery	:= ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cSE1, .F., .T.)
	
	Dbselectarea(cSE1)		
	nLenAux := Len(aStruSE1)
	For nI := 1 TO nLenAux
		If aStruSE1[nI][2] $ "NDL" .AND. FieldPos(aStruSE1[nI][1]) > 0
			TCSetField(cSE1, aStruSE1[nI][1], aStruSE1[nI][2], aStruSE1[nI][3], aStruSE1[nI][4])
		Endif
	Next nI

#ELSE
	MsSeek(xFilial("SE1")+DtoS(dDataBase),.T.)
#ENDIF

While !Eof() .AND. ((cSE1)->E1_VENCREA >= dDataBase)
	
	#IFNDEF TOP
		If (cSE1)->E1_CLIENTE <> M->ACF_CLIENT .OR. (cSE1)->E1_LOJA <> M->ACF_LOJA
			DbSkip()
			Loop
		Endif
	#ENDIF

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Atualiza o flag de marcado se o titulo ja existir no Acols³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Ascan(aCols, {|x| x[nPPrefix]+x[nPTitulo]+x[nPParcel]+x[nPTipo] == (cSE1)->E1_PREFIXO+(cSE1)->E1_NUM+(cSE1)->E1_PARCELA+(cSE1)->E1_TIPO} ) == 0
	
		AAdd(aTitulos,{	(cSE1)->E1_PREFIXO	,;
						(cSE1)->E1_NUM		,;
						(cSE1)->E1_PARCELA	,;
						(cSE1)->E1_TIPO	,;
						(cSE1)->E1_FILIAL	})

	EndIf
	
	DbSkip()
	
End

#IFDEF TOP
	DbSelectArea(cSE1)
	DbCloseArea()
#ENDIF
     
If Len(aTitulos) > 0
	AtuTLC(aTitulos)
EndIf

RestArea(aAreaSE1)
RestArea(aArea)
N := nNAtu

Return Nil

Static Function AtuTLC(aTitulos)

Local nPTitulo	:= aPosicoes[1][2]		//Numero do Titulo
Local nPPrefix	:= aPosicoes[2][2]		//Prefixo do Titulo
Local nPParcel	:= aPosicoes[3][2]		//Parcela do Titulo
Local nPTipo	:= aPosicoes[4][2]		//Tipo do Titulo
Local nPRecebe	:= aPosicoes[11][2]		//Valor a Receber do Titulo
Local nPJuros	:= aPosicoes[12][2]		//Valor de Juros do Titulo
Local nPPromoc	:= aPosicoes[16][2]		//Promocao 
Local nPValRef	:= aPosicoes[28][2]		//Valor de Referencia
Local nPBaixa   := aPosicoes[29][2]		//Log de Baixa        
Local nPStatus  := aPosicoes[30][2]		//Status do Atendimento
Local nPDtReal	:= aPosicoes[9][2] 		//Data de Vencimento Real				
Local nPAtraso	:= Ascan(aHeader, {|x| x[2] == "ACG_ATRASO"} )                
Local nUsado	:= Len(aHeader) + 1
Local nI		:= 0
Local nJ		:= 0
Local aValores	:= {}
Local nPFilOrig	:= 0                 
Local cFilOrig	:= ""

If (ACG->(FieldPos("ACG_FILORI"))  > 0)
	nPFilOrig	:= Ascan(aHeader, {|x| x[2] == "ACG_FILORI"} )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara ambiente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SK3")
DbSetOrder(2)		// K3_FILIAL+K3_VCTINI
DbSelectArea("SE1")
DbSetOrder(1)//Filial + Prefixo + Numero + Parcela + Tipo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Insere titulos selecionados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI:= 1 To Len(aTitulos)
	
	If nPfilOrig > 0
		cFilOrig:= aTitulos[nI][5]	//Filial de origem do titulo
	Else
		cFilOrig:= xFilial("SE1")
	Endif		

	If SE1->(MsSeek(cFilOrig + aTitulos[nI][1] + aTitulos[nI][2] + aTitulos[nI][3] + aTitulos[nI][4]))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona uma linha no acols e inicializa os campos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AAdd(aCols,Array(nUsado))
		For nJ := 1 to Len(aHeader)
			aCols[Len(aCols)][nJ] := CriaVar(aHeader[nJ][2])
		Next nJ
		aCols[Len(aCols)][nUsado] := .F.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o campos do acols e executa os gatilhos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[Len(aCols)][nPTitulo] := aTitulos[nI][2]
		Posicione("SX3",2,"ACG_TITULO","")
		RunTrigger(2,Len(aCols))
		
		aValores := FaVlAtuCr()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o Valor de Referencia, Receber, Juros, Baixa e Status na Inclusao        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[nI][nPValRef]	:= aValores[6]	//Saldo do Titulo 
		aCols[nI][nPJuros]	:= aValores[8]
		aCols[nI][nPRecebe]	:= aValores[12]
		aCols[nI][nPAtraso]	:= dDataBase - aCols[nI][nPDtReal]
  		If nPFilOrig > 0
	  		aCols[nI][nPFilOrig]:= aTitulos[nI][5] //Filial Original do titulo
	  	Endif

        Do Case 
        	Case !Empty(SE1->E1_BAIXA) // Se houve uma baixa verifica se foi TOTAL ou PARCIAL
        		 If (SE1->E1_SALDO > 0)
					aCols[nI][nPBaixa] := "1" //Baixa Parcial
					aCols[nI][nPStatus]:= "4" //Baixa
				 Endif
				 
				 If (SE1->E1_SALDO == 0)
					aCols[nI][nPBaixa] := "3" //Baixa Total
					aCols[nI][nPStatus]:= "1" //Pago
				 Endif	

	        Case Empty(SE1->E1_BAIXA) // Nao houve nenhuma baixa 
				aCols[nI][nPBaixa] := "2" //Sem Baixa            	

	  	EndCase	  	
	  	
		// [2] Abatimentos
		// [A] Correcao Monetaria
		// [8] Juros
		// [5] Acrescimo	- E1_SDACRES
		// [4] Decrescimo   - E1_SDDECRE
		// [9] Desconto
		// [1] Valor Original do Titulo
		// [6] Saldo do Titulo na Moeda do Titulo
		// [7] Saldo do Titulo na Moeda Corrente
		// [3] Pagto Parcial
		// [B] Valor a ser Recebido na moeda do titulo
		// [C] Valor a ser Recebido na moeda corrente

		aRdpTlc[1][2]	+= aValores[2]
		aRdpTlc[2][2]	+= aValores[10]
		aRdpTlc[3][2]	+= aValores[8]
		aRdpTlc[4][2]	+= SE1->E1_SDACRES 
		aRdpTlc[5][2]	+= SE1->E1_SDDECRE
		aRdpTlc[6][2]	+= aValores[9]
		aRdpTlc[7][2]	+= aValores[1]
		aRdpTlc[8][2]	+= aValores[6]
		aRdpTlc[9][2]	+= aValores[7]
		aRdpTlc[10][2]	+= aValores[3]
		aRdpTlc[11][2]	+= aValores[11]
		aRdpTlc[12][2]	+= aValores[12]
		
		
		SK3->(MsSeek(xFilial("SK3") + DtoS(SE1->E1_VENCREA), .T.))
		
		If SE1->E1_VENCREA >= SK3->K3_VCTINI .AND. SE1->E1_VENCREA <= SK3->K3_VCTFIM
			If dDataBase >= SK3->K3_INICIO .AND. dDataBase <= SK3->K3_FINAL
				aCols[nI][nPPromoc] := SK3->K3_CODIGO
			Endif
		Else
			SK3->(DbSkip(-1))
			If SE1->E1_VENCREA >= SK3->K3_VCTINI .AND. SE1->E1_VENCREA <= SK3->K3_VCTFIM
				If dDataBase >= SK3->K3_INICIO .AND. dDataBase <= SK3->K3_FINAL
					aCols[nI][nPPromoc] := SK3->K3_CODIGO
				Endif
			Endif
		Endif		
		
	Endif
Next

		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza Rodapes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRdpTlc[1][1]:Refresh()
aRdpTlc[2][1]:Refresh()
aRdpTlc[3][1]:Refresh()
aRdpTlc[4][1]:Refresh()
aRdpTlc[5][1]:Refresh()
aRdpTlc[6][1]:Refresh()
aRdpTlc[7][1]:Refresh()
aRdpTlc[8][1]:Refresh()
aRdpTlc[9][1]:Refresh()
aRdpTlc[10][1]:Refresh()
aRdpTlc[11][1]:Refresh()
aRdpTlc[12][1]:Refresh()

oGetTlc:oBrowse:Refresh(.T.)

Return Nil