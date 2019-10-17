#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A175GRV   ºAutor  ³Microsiga           º Data ³  03/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Insercao/Exclusao de itens no pedido de vendas de servicos º±±
±±º          ³ executados mais do que foi contratado                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A175Grv

Local _aArea    := GetArea()
Local _aAreaSD3 := SD3->(GetArea())
Local _aAreaSB2 := SB2->(GetArea())
Local _aAreaSD7 := SD7->(GetArea())
Local  _cOP     := aCols[n][2]
Local _cGrupo   := GetMV("MV_X_GRPRO")
Local lRet      := .T.

IF SM0->M0_CODIGO == "03"
	IF !lEstorno		
		dbSelectArea("SD4")
		dbSetOrder(2)
		dbSeek(xFilial("SD4")+aCols[n][2])
		
		While !Eof() .and. _cOP == SD4->D4_OP
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD4->D4_PRODUTO) //Alterado do D4_COD para D4_PRODUTO
			IF Alltrim(SB1->B1_GRUPO) $  Alltrim(_cGrupo) //Grupo de produto que deverao ser inseridos no pedido de vendas e cobrados
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+Substr(aCols[n][2],1,6)))
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
				IF SA1->A1_CALCCON == "S" .AND. aCols[n][4] == 1 //Considerando cobranca para o cliente
					_cTES:=GetMV("MV_X_TSVED")
				Else
					_cTES:= "903" //TES que nao agrega valor Produto
				EndIF
				aAdd(_aITPed,{SB1->B1_COD,SB1->B1_LOCPAD,_cTES,SD4->D4_QTDEORI,SB1->B1_CODISS,SB1->B1_UM,SD4->D4_OP})
			EndIF
			dbSelectArea("SD4")
			dbSkip()
		EndDo
		
		IF Len(_aITPed) > 0			
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+Substr(_cOP,1,6))
			_cItem := 0
			While!Eof() .and. SC6->C6_NUM == Substr(_cOP,1,6)
				_cItem += 1
				dbSkip()
			Enddo
			_lOk := .F.
			For _i:= 1 To Len(_aITPed)
				dbSelectArea("SC5")
				dbSetOrder(1)
				dbSeek(xFilial("SC5")+Substr(_cOP,1,6))
				
				_nValor := U_BuscaPrcVenda(_aITPed[_i,1],SC5->C5_CLIENTE,SC5->C5_LOJACLI)
				
				IF _nValor == 0
					MsgInfo("O Valor do serviço "+Alltrim(_aITPed[_i,1])+" esta sem o preenchimento","Atençao!")
				EndIF
				
				SF4->(dbSetorder(1))
				SF4->(dbSeek(xFilial("SF4")+_aITPed[_i,3]))
				
				IF !Empty(SF4->F4_TESDV)
					IF _aITPed[_i,3] == "903"
						SC2->(dbSetOrder(1))
						SC2->(dbSeek(xFilial("SC2")+aCols[n][2]))
					
						SC6->(dbSetOrder(1))
						SC6->(dbSeek(xFilial("SC6")+Substr(aCols[n][2],1,6)+SC2->C2_ITEMPV))
						RecLock("SC6",.F.)
							SC6->C6_TES     := _aITPed[_i,3]
							SC6->C6_CF      := SF4->F4_CF
						MsUnlock()	
					Else
						_lOk := .T.						
						RecLock("SC6",.F.)
						SC6->C6_FILIAL  := xFilial("SC6")
						SC6->C6_ITEM    := Strzero(_cItem+_i,2,0)
						SC6->C6_PRODUTO := _aITPed[_i,1]
						SC6->C6_LOCAL   := _aITPed[_i,2]
						SC6->C6_UM      := _aITPed[_i,6]
						SC6->C6_TES     := _aITPed[_i,3]
						SC6->C6_CF      := SF4->F4_CF
						SC6->C6_NUM     := Substr(_cOP,1,6)
						SC6->C6_QTDVEN  := _aITPed[_i,4]
						SC6->C6_QTDLIB := _aITPed[_i,4]
						SC6->C6_PRCVEN  := _aITPed[_i,4]*_nValor
						SC6->C6_PRUNIT  := _aITPed[_i,4]*_nValor
						SC6->C6_VALOR   := _aITPed[_i,4]*_nValor
						SC6->C6_CLI     := SC5->C5_CLIENTE
						SC6->C6_LOJA    := SC5->C5_LOJACLI
						SC6->C6_ENTREG  := dDatabase
						SC6->C6_DESCRI  := Posicione("SB1",1,xFilial("SB1")+_aITPed[_i,1]+_aITPed[_i,2],"B1_DESC")
						SC6->C6_TPOP    := "F"
						SC6->C6_CODISS  := _aITPed[_i,5]
						SC6->C6_EMPD4   := "S"
						SC6->C6_NUMOP   := Substr(_aITPed[_i,7],1,6)
						SC6->C6_ITEMOP  := Substr(_aITPed[_i,7],7,2) 
						MsUnlock()				
					EndIF
				Else 
					MsgInfo("Favor cadastrar o TES de devolução para o produto "+Alltrim(SC6->C6_PRODUTO)+";pois assim nao será possivel a inclusao deste item no pedido de vendas.","Atenção")
				EndIF	
			Next
			//Libero o Pedido de vendas
			IF _lOk
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
				Reclock("SC5",.F.)
					SC5->C5_LIBEROK := "S"
				MsUnlock()
			EndIF	
		Else //Libero somente o item produzido
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+_cOP))
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			IF dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO)
			    IF aCols[n][4] == 1
					Reclock("SC6",.F.)
						SC6->C6_QTDLIB := SC6->C6_QTDVEN
					MsUnlock()
					SC5->(dbSetOrder(1))
					SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
					Reclock("SC5",.F.)
						SC5->C5_LIBEROK := "S"
					MsUnlock()
				EndIF	
			EndIF
		EndIF	
	Else
		dbSelectArea("SD4")
		dbSetOrder(2)
		dbSeek(xFilial("SD4")+_cOP)
		
		While !Eof() .and. _cOP == SD4->D4_OP
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD4->D4_COD)
			IF Alltrim(SB1->B1_GRUPO) $  Alltrim(_cGrupo) //Grupo de produto que deverao ser inseridos no pedido de vendas e cobrados
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+Substr(_cOP,1,6)))
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
				IF SA1->A1_CALCCON == "S" .and. aCols[n][4] == 1 //Considerando cobranca para o cliente
					_cTES:=GetMV("MV_X_TSVED")
				Else
					_cTES:= "903" //TES que nao agrega valor
				EndIF
				aAdd(_aITPed,{SB1->B1_COD,SB1->B1_LOCPAD,SB1->B1_TS,SD4->D4_QUANT,SB1->B1_CODISS,SB1->B1_UM})
			EndIF
			dbSelectArea("SD4")
			dbSkip()
		EndDo
		dbSelectArea("SC6")
		dbSetOrder(1)
		IF dbSeek(xFilial("SC6")+Substr(_cOP,1,6))
			For _i:=1 To Len(_aITPed)
				lachou := .F.
				While !Eof().and. xFilial("SC6") == SC6->C6_FILIAL .and. Substr(_cOP,1,6) == SC6->C6_NUM .and. !lachou
					IF SC6->C6_PRODUTO == _aITPed[_i,1] .and. SC6->C6_EMPD4 == "S"
						Reclock("SC6",.F.)
						dbDelete()
						MsUnlock()
						lachou := .T.
					EndIF
					dbSkip()
				EndDo
			Next
		EndIF
	EndIF
EndIF

RestArea(_aAreaSD3)
RestArea(_aAreaSB2)
RestArea(_aAreaSD7)
RestArea(_aArea)

Return(lRet)
/*
MALibDoFat(SC6->(Recno()),nQtdaLib,.F.,.F.,.T.,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O alias e passado no xFilial para garantir a abertura do SC9          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasQry := GetNextAlias()

cQuery := "SELECT R_E_C_N_O_ SC9RECNO FROM " + RetSqlName( "SC9" ) + " "
cQuery += "WHERE "
cQuery += "C9_FILIAL='" + SC9->( xFilial( "SC9" ) ) + "' AND "
cQuery += "C9_PEDIDO='" + SC6->C6_NUM      + "' AND "
cQuery += "C9_ITEM='"   + SC6->C6_ITEM     + "' AND "
cQuery += "C9_BLEST<>'10' AND C9_BLCRED<>'10' AND C9_BLEST<>'  ' AND "
cQuery += "D_E_L_E_T_=' '"

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TcgenQry( ,,cQuery ), cAliasQry, .F., .T. )
TcSetField( cAliasQry, "SC9RECNO", "N", 10, 0 )
aRecnoSC9 := {}
While !( cAliasQry )->( Eof() )
AAdd( aRecnoSC9, ( cAliasQry )->SC9RECNO )
( cAliasQry )->( dbSkip() )
EndDo
( cAliasQry )->( dbCloseArea() )
dbSelectArea( "SC9" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua a liberacao do PV                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aRecnoSC9 )
SC9->( dbGoto( aRecnoSC9[ nLoop ] ) )
If SC9->C9_QTDLIB <= SC6->C6_QTDVEN
a450Grava( 1, .F., .T., .F. )
EndIf
Next nLoop
*/
