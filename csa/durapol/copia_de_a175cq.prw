#include "rwmake.ch"
User Function A175CQ

Local _aArea    := GetArea()
Local aAreaSav  := {}
Local  _nPosOP  := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D7_X_OP"}) 
Local _nPosTipo := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D7_TIPO"})
Local _cGrupo   := GetMV("MV_X_GRPRO")
Local _aITPed   := {}
Local _aPedido  := {}
Local cITemPV   := ""
Local lRet      := .T.
Local i:=0

// Salva todos os Alias que serão tratados no ponto de entrada
aAreaSav := {{"SC2",0,0},{"SB2",0,0},{"SD3",0,0},{"SD7",0,0}}
For i:= 1 To Len(aAreaSav)
      dbSelectArea(aAreaSav[i][1])
      aAreaSav[i][2] := IndexOrd()
      aAreaSav[i][3] := Recno()
Next

IF SM0->M0_CODIGO == "03"
	IF !lEstorno //Variavel privada
		dbSelectArea("SD4")
		dbSetOrder(2)
		//Verifico se houve algum produto empenhado
		IF dbSeek(xFilial("SD4")+aCols[n][_nPosOP])
		
			While !Eof() .and. xFilial("SD4") == SD4->D4_FILIAL .and. Alltrim(aCols[n][_nPosOP]) == Alltrim(SD4->D4_OP);
				.and. Alltrim(SD4->D4_X_CHAVE) != "S"
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+SD4->D4_PRODUTO) //Alterado do D4_COD para D4_PRODUTO para contemplar gatilho
				IF Alltrim(SB1->B1_GRUPO) $ Alltrim(_cGrupo) //Grupo de produto que deverao ser inseridos no pedido de vendas e cobrados
				    SC2->(dbSetOrder(1))
				    SC2->(dbSeek(xFilial("SC2")+aCols[n][_nPosOP]))				    
					SC5->(dbSetOrder(1))
					SC5->(dbSeek(xFilial("SC5")+Substr(aCols[n][_nPosOP],1,6)))
					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO))
					Reclock("SC6",.F.)
						SC6->C6_X_FABRI := "S"
					MsUnlock()
					_cITSrv := SC6->C6_ITPVSRV
					SA1->(dbSetOrder(1))
					SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
					IF SA1->A1_CALCCON == "S" .AND. aCols[n][_nPosTipo] == 1 //Considerando cobranca para o cliente
						_cTES:=GetMV("MV_X_TSVED")
					ElseIF SA1->A1_CALCCON == "N" .AND. aCols[n][_nPosTipo] == 1 //Considerando cobranca para o cliente
						_cTES:="902"
					Else
						_cTES:= "903" //TES que nao agrega valor Produto
					EndIF
					aAdd(_aITPed,{SB1->B1_COD,SB1->B1_LOCPAD,_cTES,SD4->D4_QTDEORI,SB1->B1_CODISS,SB1->B1_UM,SD4->D4_OP,_cITSrv,SC2->C2_ITEMPV})
					dbSelectArea("SD4")
					Reclock("SD4",.F.)
						SD4->D4_X_CHAVE := "S"
					MsUnlock()
				EndIF
				dbSelectArea("SD4")
				dbSkip()
			EndDo
		Else
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+aCols[n][_nPosOP]))
			
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO))
			
			RecLock("SC6",.F.)
				SC6->C6_QTDLIB  := SC2->C2_QUANT
				SC6->C6_X_FABRI := "S"
			MsUnlock()
		EndIF
		//Se houve inclusao de novo item atraves do empenho
		IF Len(_aITPed) > 0			
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+Substr(aCols[n][_nPosOP],1,6))
			_cItem := 0
			While!Eof() .and. xFilial("SC6") == SC6->C6_FILIAL .and. SC6->C6_NUM == Substr(aCols[n][_nPosOP],1,6)
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
					_lOk := .T.	
					RecLock("SC6",.T.)
					SC6->C6_FILIAL  := xFilial("SC6")
					SC6->C6_ITEM    := Strzero(_cItem+1,2,0)
					SC6->C6_PRODUTO := _aITPed[_i,1]
					SC6->C6_LOCAL   := _aITPed[_i,2]
					SC6->C6_UM      := _aITPed[_i,6]
					SC6->C6_TES     := _aITPed[_i,3]
					SC6->C6_CF      := SF4->F4_CF
					SC6->C6_NUM     := Substr(aCols[n][_nPosOP],1,6)
					SC6->C6_QTDVEN  := _aITPed[_i,4]
					SC6->C6_QTDLIB  := _aITPed[_i,4]
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
				EndIF
			Next _i
			//Libero o Pedido de vendas
			IF _lOk
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
				Reclock("SC5",.F.)
					SC5->C5_LIBEROK := "S"
				MsUnlock()
				_lOk := .F.	
			EndIF	
		Else //Libero somente o item produzido
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+aCols[n][_nPosOP]))
			dbSelectArea("SC6")
			dbSetOrder(1)
			IF dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+Strzero(Val(SC2->C2_ITEMPV)+1,2)+SC2->C2_PRODUTO)
			    IF aCols[n][_nPosTipo] == 1
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
		//No estorno deleto o possivel item inserido no PV
		dbSelectArea("SD4")
		dbSetOrder(2)
		dbSeek(xFilial("SD4")+aCols[n][_nPosOP])
		
		While !Eof() .and. xFilial("SD4") == SD4->D4_FILIAL .and. Alltrim(aCols[n][_nPosOP]) == Alltrim(SD4->D4_OP)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD4->D4_COD)
			IF Alltrim(SB1->B1_GRUPO) $  Alltrim(_cGrupo) //Grupo de produto que deverao ser inseridos no pedido de vendas e cobrados
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+Substr(aCols[n][_nPosOP],1,6)))
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
				IF SA1->A1_CALCCON == "S" .and. aCols[n][_nPosTipo] == 1 //Considerando cobranca para o cliente
					_cTES:=GetMV("MV_X_TSVED")
				ElseIF 	SA1->A1_CALCCON == "N" .and. aCols[n][_nPosTipo] == 1 //Considerando cobranca para o cliente
					_cTES:="902"
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
		IF dbSeek(xFilial("SC6")+Substr(aCols[n][_nPosOP],1,6))
			For _i:=1 To Len(_aITPed)
				lachou := .F.
				While !Eof().and. xFilial("SC6") == SC6->C6_FILIAL .and. Substr(aCols[n][_nPosOP],1,6) == SC6->C6_NUM .and. !lachou
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

// Recupera todos os alias
For i:= 1 To Len(aAreaSav)
     dbSelectArea(aAreaSav[i][1])
     dbSetOrder(aAreaSav[i][2])
     dbGoTo(aAreaSav[i][3])
Next
RestArea(_aArea)

Return(lRet)
