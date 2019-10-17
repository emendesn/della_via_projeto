#include "rwmake.ch"
User Function A175CQ

Local _aArea    := GetArea()
Local aAreaSav  := {}
Local  _nPosOP  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D7_X_OP"})
Local _nPosTipo := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D7_TIPO"})
Local _aITPed   := {}
Local _aPedido  := {}
Local cITemPV   := ""
Local _nQtdOri  := 0
Local i:=0

// Salva todos os Alias que serão tratados no ponto de entrada
aAreaSav := {{"SC2",0,0},{"SB2",0,0},{"SD3",0,0},{"SD7",0,0}}
For i:= 1 To Len(aAreaSav)
	dbSelectArea(aAreaSav[i][1])
	aAreaSav[i][2] := IndexOrd()
	aAreaSav[i][3] := Recno()
Next

IF SM0->M0_CODIGO == "03"
	IF Select("SD4TMP") > 0
		dbSelectArea("SD4TMP")
		dbCloseArea()
	EndIF
		
	_cQry := "SELECT D4_PRODUTO, D4_X_ARMZ, D4_QTDEORI, B1_CODISS, B1_UM, D4_OP, C2_ITEMPV, A1_CALCCON, C2_PEDIDO, C2_PRODUTO, C6_ITPVSRV "
	//_cQry += "D4_X_ITPV "
	_cQry += "FROM " + RetSqlName("SD4") + " SD4, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SC2") + " SC2, " + RetSqlName("SC5") + " SC5, " + RetSqlName("SC6") + " SC6, " + RetSqlName("SA1") + " SA1 "
	_cQry += "WHERE SD4.D4_FILIAL = '"+xFilial("SD4")+"' AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND "
	_cQry += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
	_cQry += "D4_OP = '"+aCols[n][_nPosOP]+"' AND D4_PRODUTO = B1_COD AND D4_X_ARMZ = B1_LOCPAD AND (B1_GRUPO = 'CI' OR B1_GRUPO = 'SC') AND "
	_cQry += "C2_NUM||C2_ITEM||C2_SEQUEN = D4_OP AND C2_PEDIDO = C5_NUM AND C5_NUM = C6_NUM AND C6_ITEM = C2_ITEMPV AND C6_PRODUTO = C2_PRODUTO AND "
	_cQry += "C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND C6_CLI = C5_CLIENTE AND C6_LOJA = C5_LOJACLI AND "
	_cQry += "C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SUBSTRING(D4_OP,1,6) = C5_NUM AND SUBSTRING(D4_OP,1,6) = C6_NUM AND "
	_cQry += "SUBSTRING(D4_OP,7,2) = C2_ITEM AND SD4.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' AND SC2.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND "
	_cQry += "SC6.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' "
	
	_cQry := ChangeQuery(_cQry)
		
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"SD4TMP",.F.,.T.)
	dbGotop()
		IF !lEstorno //Variavel privada		
			_lEmp := .F.		
			While !Eof()
				_lEmp := .T.
				IF SD4TMP->A1_CALCCON == "S" .AND. aCols[n][_nPosTipo] == 1 //Considerando cobranca para o cliente
					_cTES:=GetMV("MV_X_TSVED")
				ElseIF SD4TMP->A1_CALCCON == "N" .AND. aCols[n][_nPosTipo] == 1 //Considerando cobranca para o cliente
					_cTES:="902"
				Else
					_cTES:= "903" //TES que nao agrega valor Produto
					//Executo gravacao do status recusado na OP
					dbSelectArea("SC2")
					dbSetOrder(1)
					dbSeek(xFilial("SC2")+aCols[n][_nPosOP],.F.)
					RecLock("SC2",.F.)
						SC2->C2_X_STATU := "9" 
					MsUnlock()
				EndIF
				//Marco como item produzido
				SC6->(dbSetOrder(1))
				SC6->(dbSeek(xFilial("SC6")+SD4TMP->C2_PEDIDO+SD4TMP->C2_ITEMPV+SD4TMP->C2_PRODUTO))
				Reclock("SC6",.F.)
					SC6->C6_X_FABRI := "S"
				MsUnlock()
			
				aAdd(_aITPed,{SD4TMP->D4_PRODUTO,SD4TMP->D4_X_ARMZ,_cTES,SD4TMP->D4_QTDEORI,SD4TMP->B1_CODISS,SD4TMP->B1_UM,SD4TMP->D4_OP,SD4TMP->C6_ITPVSRV,SD4TMP->C2_ITEMPV})
				dbSelectArea("SD4TMP")
				dbSkip()
			EndDo
			SD4TMP->(dbCloseArea())
			IF !_lEmp
				
				aAdd(_aPedido,Substr(aCols[n][_nPosOP],1,6))
				
				SC2->(dbSetOrder(1))
				SC2->(dbSeek(xFilial("SC2")+aCols[n][_nPosOP]))
			
				SC6->(dbSetOrder(1))
				SC6->(dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO))
				cNumero := SC6->C6_NUM
				RecLock("SC6",.F.)
					SC6->C6_X_FABRI := "S"
				MsUnlock()
				Begin Transaction
					MalibDoFat(SC6->(Recno()),1,.T.,.T.,.T.,.T.)
					dbSelectArea("SC5")
					dbSetOrder(1)
					dbSeek(xFilial("SC5")+cNumero)
						Reclock("SC5",.F.)
							SC5->C5_LIBEROK := "S"
						Msunlock()	
				End Transaction
			EndIF
		
			//Se houve inclusao de novo item atraves do empenho
    	
				IF Len(_aITPed) > 0
					_aPedido := {}
					dbSelectArea("SC6")
					dbSetOrder(1)
					dbSeek(xFilial("SC6")+Substr(aCols[n][_nPosOP],1,6))
					_cItem := 0
					While!Eof() .and. xFilial("SC6") == SC6->C6_FILIAL .and. SC6->C6_NUM == Substr(aCols[n][_nPosOP],1,6)
						aAdd(_aPedido,SC6->C6_NUM)
						_cItem += 1
						dbSkip()
					Enddo
					_lOk := .F.
					For _i:= 1 To Len(_aITPed)
						dbSelectArea("SC5")
						dbSetOrder(1)
						dbSeek(xFilial("SC5")+Substr(aCols[n][_nPosOP],1,6))
						
						_nValor := U_BuscaPrcVenda(_aITPed[_i,1],SC5->C5_CLIENTE,SC5->C5_LOJACLI)
					
						IF _nValor == 0
							MsgInfo("O Valor do serviço "+Alltrim(_aITPed[_i,1])+" esta sem o preenchimento","Atençao!")
						EndIF
					
						SF4->(dbSetorder(1))
						SF4->(dbSeek(xFilial("SF4")+_aITPed[_i,3]))
				    	
						IF _aITPed[_i,3] == "903" .and. aCols[n][_nPosTipo] == 2
							SC6->(dbSetOrder(1))
							SC6->(dbSeek(xFilial("SC6")+Substr(aCols[n][_nPosOP],1,6)+_aITPed[_i,8]))
							RecLock("SC6",.F.)
								SC6->C6_TES     := _aITPed[_i,3]
								SC6->C6_CF      := SF4->F4_CF
								SC6->C6_X_FABRI := "S"
							MsUnlock()
						Else
							_lOk   := .T.
								_cItem := _cItem + 1
						
							RecLock("SC6",.T.)
							SC6->C6_FILIAL  := xFilial("SC6")
							SC6->C6_ITEM    := Strzero(_cItem,2,0)
							SC6->C6_PRODUTO := _aITPed[_i,1]
							SC6->C6_LOCAL   := _aITPed[_i,2]
							SC6->C6_UM      := _aITPed[_i,6]
							SC6->C6_TES     := _aITPed[_i,3]
							SC6->C6_CF      := SF4->F4_CF
							SC6->C6_NUM     := Substr(aCols[n][_nPosOP],1,6)
							SC6->C6_QTDVEN  := _aITPed[_i,4]
							SC6->C6_PRCVEN  := _nValor
							SC6->C6_PRUNIT  := _nValor
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
							SC6->C6_X_FABRI := "S"
							MsUnlock()
					    	
							aAdd(_aPedido,Substr(aCols[n][_nPosOP],1,6))
							//Habilitar o novo indice e criar campo para controle
							/*
							dbSelectArea("SD4")
							dbSetOrder(5)
							IF dbSeek(xFilial("SD4")+_aITPed[_i,1]+aCols[n][_nPosOP],.F.)
								RecLock("SD4",.F.)
									SD4->D4_X_ITPV := Strzero(_cItem,2,0)
								MsUnlock()
							EndIF
							*/
						EndIF
					Next _i
					//Marco 	liberado o Pedido de vendas
					IF _lOk
						_lCredito := .T.
						dbSelectArea("SC6")
						dbSetOrder(1)
						dbSeek(xFilial("SC6")+Substr(aCols[n][_nPosOP],1,6),.F.)
						While !Eof() .and. xFilial("SC6") == SC6->C6_FILIAL  .and. Substr(aCols[n][_nPosOP],1,6) == SC6->C6_NUM
							_nQtdOri := SC6->C6_QTDVEN
							dbSelectArea("SC9")
							dbSetOrder(1)
							IF ! dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
								Begin Transaction
									MalibDoFat(SC6->(Recno()),_nQtdOri,@_lCredito,.T.,.T.,.T.)
									dbSelectArea("SC5")
									dbSetOrder(1)
									dbSeek(xFilial("SC5")+SC6->C6_NUM)
									Reclock("SC5",.F.)
										SC5->C5_LIBEROK := "S"
									Msunlock()	
								End Transaction
							EndIF	
							dbSelectArea("SC6")
							dbSkip()
						EndDo					
						_lOk := .F.
					EndIF	
				EndIF
		Else
			//No estorno deleto o possivel item inserido no PV
			/*
			While !Eof()
				dbSelectArea("SC6")
				dbSetOrder(1)
				IF dbSeek(xFilial("SC6")+SD4TMP->C2_PEDIDO+SD4TMP->D4_X_ITPV+SD4TMP->D4_PRODUTO,.F.)
					//Deleto o item referente ao que foi empenhado
					Reclock("SC6",.F.)
						dbDelete()
					MsUnlock()
				SD4TMP->(dbSkip())
			EndDo
			aCols[n][_nPosOP] := SD4TMP->D4_OP
			*/
			SD4TMP->(dbCloseArea())
			
		EndIF
EndIF

// Recupera todos os alias
For i:= 1 To Len(aAreaSav)
	dbSelectArea(aAreaSav[i][1])
	dbSetOrder(aAreaSav[i][2])
	dbGoTo(aAreaSav[i][3])
Next
RestArea(_aArea)

Return
