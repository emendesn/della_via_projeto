/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A175CQ    ºAutor  ³Microsiga           º Data ³  07/31/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION A175CQ

LOCAL aArea     := GetArea()
LOCAL aAreaSav  := {}
LOCAL nPosOP    := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D7_X_OP"})
LOCAL nPosTipo  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D7_TIPO"})
LOCAL cNumeroOp := Alltrim(aCols[n][nPosOp])
LOCAL cItLibRec := aCols[n][nPosTipo]
LOCAL cNumeroPV := Substr(cNumeroOP,1,6)
LOCAL i:=0

// Salva todos os Alias que serão tratados no ponto de entrada
aAreaSav := {{"SC2",0,0},{"SB2",0,0},{"SD3",0,0},{"SD7",0,0},{"SC5",0,0},{"SC6",0,0}}
For i:= 1 To Len(aAreaSav)
	dbSelectArea(aAreaSav[i][1])
	aAreaSav[i][2] := IndexOrd()
	aAreaSav[i][3] := Recno()
Next  

IF SM0->M0_CODIGO == "03"
	
	SC2->(dbSetOrder(1))
	If !SC2->(dbSeek(xFilial("SC2")+cNumeroOP,.F.))
	    Alert("Ordem de Producao " + cNumeroOP + " nao encontrada na base de dados, favor verificar. Processamento Interrompido !!")
		Return
	EndIf
	
	//atualiza o status da ordem de producao
	//1o. Status 6 PRODUCAO - CQ Final Liberada
	//2o. Status 9 Producao - CQ Final Recusada
	RecLock("SC2",.F.)
		SC2->C2_X_STATU := IIF(cItLibRec == 2 .Or. lEstorno, '9','6') 
	MsUnlock()
		
	SC5->(dbSetOrder(1))
	If !SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO,.F.))
	    Alert("Pedido de Venda " + cNumeroPV + " nao encontrado na base de dados, favor verificar. Processamento Interrompido !!")
		Return
	EndIf

	// PARA ITENS RECUSADOS E caso nao encontre o SD4 (nao foi realizado nenhum empenho), o sistema deve varrer os itens do pedido venda
	// desta OP (SAO OS ITENS ORIGINAIS GERADOS A PARTIR DA NOTA FISCAL ENTRADA (COLETA) e Validar o TES de Saida
	If cItLibRec == 2		
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+cNumeroPV,.f.)
		While!Eof() .and. xFilial("SC6") == SC6->C6_FILIAL .and. SC6->C6_NUM == cNumeroPV
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			IF ( (SC6->C6_NUMOP+SC6->C6_ITEMOP == Substr(cNumeroOP,1,8)) .and. SC6->C6_TES <> '594' .And. SB1->B1_TIPO == 'MP' )
				
				SF4->(dbSeek(xFilial("SF4")+'903',.F.))
				Reclock("SC6",.F.)
					SC6->C6_TES := cTES // tes para operacoes recusadas
					SC6->C6_CF  := SF4->F4_CF
				MsUnLock()
			EndIF         
			dbSelectArea("SC6")
			dbSkip()
		Enddo
	EndIf
	
    // Para Itens LIberados deve varrer os empenhos (SD4 EMPENHOS) registrados neste arquivo, para descobrir se havera necessidade
    // de incluir novos itens no pedido de vendas SC6
	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial("SD4")+cNumeroOP,.F.)
	While !Eof() .And. xFilial("SD4") == D4_FILIAL .And. Alltrim(cNumeroOP) == Alltrim(D4_OP)
		SB1->(dbSetOrder(1))
		// Se nao encontrou produto, ou se encontrou porem o produto não é servico ou concerto, despreza
		// registro do empenho, pois não ira atualizar nada no pedido de venda
		IF !SB1->(dbSeek(xFilial("SB1")+SD4->D4_PRODUTO,.F.)) .Or. !Alltrim(SB1->B1_GRUPO) $ "SC*CI" .and. SB1->B1_TIPO == "MP"
			SD4->(dbSkip())
			Loop
		EndIf
		
		// Se o produto empenhado, trata-se de um novo servico ou concerto e a baixa do CQ LIBEROU ele
		// o processamento devera incluir este novo item no pedido de venda (SC6)
		If !(lEstorno) .and. cItLibRec != 2 
			GeraItemPV(cNumeroOP,cNumeroPv,cItLibRec)  // Atualiza o Pedido de Venda a partir dos empenhos            (SC6)
		Else                                                                     
			// Se o produto empenhado, trata-se de um novo servico ou concerto e a baixa do CQ ESTORNOU ele
			// o processamento devera proucrar este item no pedido venda e exclui-lo
			EstornaItemPV(cNumeroOP,cNumeroPV,cItLibRec)  // Atualiza o Pedido de Venda a partir dos empenhos            (SC6)
		EndIf
		dbSelectArea("SD4")
		dbSkip()
	EndDo

    // Para as Producoes (OPs) que foram liberadas no CQ, o processamente devera procurar todos os itens do
    // pedido de venda que estao vinculados a esta ordem de producao, e realizar a liberacao destes para
    // faturamento
    
	IF !(lEstorno)
    	LiberaItemPV(cNumeroOP,cNumeroPV) // Libera os itens produzidos e liberados CQ para Faturamento (SC9)
    EndIf
	
EndIf

// Recupera todos os alias
For i:= 1 To Len(aAreaSav)
	dbSelectArea(aAreaSav[i][1])
	dbSetOrder(aAreaSav[i][2])
	dbGoTo(aAreaSav[i][3])
Next

RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraItemPVºAutor  ³Microsiga           º Data ³  07/31/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION GeraItemPV(cNumeroOP,cNumeroPV,cItLibRec)

LOCAL cItemPV   := ''
LOCAL cTes      := ''
LOCAL lLiberOk  := .T. 
LOCAL lResidOk  := .T. 
LOCAL lFaturOk  := .F.

//Vai inserir um novo item no SC6, este laco devolve o proximo numero item disponivel

Begin Transaction //Reinaldo

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+cNumeroPV,.f.)
	While!Eof() .and. xFilial("SC6") == SC6->C6_FILIAL .and. SC6->C6_NUM == cNumeroPV
		cItemPV := SOMA1(SC6->C6_ITEM,2)	
		dbSkip()
	Enddo
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.F.))
	cTES := IIF(cItLibRec==1,IIF(SA1->A1_CALCCON == 'S',GetMV("MV_X_TSVED"),'902'),'903')
	SF4->(dbSetOrder(1))
	SF4->(dbSeek(xFilial("SF4")+cTES,.F.))
	
	nValor := U_BuscaPrcVenda(SD4->D4_PRODUTO,SA1->A1_COD,SA1->A1_LOJA)
	
	IF nValor == 0
		MsgInfo("O Valor do serviço "+SD4->D4_PRODUTO+" esta sem o preenchimento, o item nao sera gravado no Pedido Venda","Atençao!")
		Return
	EndIF
	
	RecLock("SC6",.T.)
		SC6->C6_FILIAL  := xFilial("SC6")
		SC6->C6_ITEM    := cItemPV
		SC6->C6_PRODUTO := SD4->D4_PRODUTO
		SC6->C6_LOCAL   := SD4->D4_X_ARMZ
		SC6->C6_UM      := SB1->B1_UM
		SC6->C6_TES     := cTES
		SC6->C6_CF      := SF4->F4_CF
		SC6->C6_NUM     := cNumeroPV
		SC6->C6_QTDVEN  := SD4->D4_QTDEORI
		//Reinaldo
		SC6->C6_QTDLIB  := SC6->C6_QTDVEN
		//
		SC6->C6_PRCVEN  := nValor
		SC6->C6_PRUNIT  := nValor
		SC6->C6_VALOR   := SC6->C6_QTDVEN * SC6->C6_PRCVEN
		SC6->C6_CLI     := SC5->C5_CLIENTE
		SC6->C6_LOJA    := SC5->C5_LOJACLI
		SC6->C6_ENTREG  := dDatabase
		SC6->C6_DESCRI  := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")
		SC6->C6_TPOP    := "F"
		SC6->C6_CODISS  := SB1->B1_CODISS
		SC6->C6_EMPD4   := "S"
		SC6->C6_NUMOP   := cNumeroPV
		SC6->C6_ITEMOP  := Substr(cNumeroOP,7,2)
		SC6->C6_X_FABRI := "S"
	MsUnlock()
			
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+cNumeroPV,.f.)
	While!Eof() .and. xFilial("SC6") == SC6->C6_FILIAL .and. SC6->C6_NUM == cNumeroPV
		If ((SC6->C6_NUMOP+SC6->C6_ITEMOP) != Substr(cNumeroOP,1,8))
			SC6->(dbSkip())
			Loop
		EndIf
	
		Reclock("SC6",.F.)
		    SC6->C6_X_FABRI := "S"
		MsUnlock()
		
		dbSelectArea("SC6")
		dbSkip()
	Enddo
	
	MaAvalSC6("SC6",3,"SC5",.F.,@lLiberOk,@lResidOk,@lFaturOk) //Reinaldo
	
End Transaction	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LiberaItemPvºAutor  ³Microsiga           º Data ³  07/31/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION LiberaItemPv(cNumeroOP,cNumeroPV)

LOCAL cItemPV := ''
LOCAL cTes    := ''
LOCAL lLiberOk  := .T. 
LOCAL lResidOk  := .T. 
LOCAL lFaturOk  := .F.

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+cNumeroPV)

MaAvalSC5("SC5",3,.T.,.F.,@lLiberOk,@lResidOk,@lFaturOk,Nil,Nil,Nil,Nil,.T.) //Reinaldo

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EstornaItemPVºAutor  ³Microsiga           º Data ³  07/31/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION EstornaItemPV(cNumeroOP,cNumeroPV,cItLibRec)

LOCAL cItemPV := ''
LOCAL cTes := ''

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+cNumeroPV,.f.)
While!Eof() .and. xFilial("SC6") == SC6->C6_FILIAL .and. SC6->C6_NUM == cNumeroPV
	If ( (SC6->C6_PRODUTO != SD4->D4_PRODUTO) .Or. (SC6->C6_NUMOP+SC6->C6_ITEMOP != Substr(cNumeroOP,1,8)) )
		dbSkip()
		Loop
	EndIf
	
	RecLock("SC6",.F.)
		dbDelete()
	MsUnlock()
	
	//ESTORNA SC9	
	dbSelectArea("SC9")
	dbSetOrder(1)
	IF dbSeek(xFilial("SC9")+cNumeroPV+SC6->C6_ITEM,.f.)
		A460Estorna()
	EndIF	
	
	dbSelectArea("SC6")
	dbSkip()
Enddo

RETURN