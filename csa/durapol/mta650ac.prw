#include "rwmake.ch"
User Function MTA650AC
Local _aArea  := GetArea()
Local _cNumOPx:= SC2->C2_NUM 
IF SM0->M0_CODIGO == "03"
    
    _cIndNum := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
    
	SC6->(dbSetOrder(1))	
	SC6->(dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO))	
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA))
	
	_nReduz := Alltrim(SA1->A1_NOME)
	
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(xFilial("SD1")+SC6->C6_NFORI+SC6->C6_SERIORI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_ITEMORI))
	
	_cSeriePN := SD1->D1_SERIEPN
	_cNumFogo := SD1->D1_NUMFOGO
	_cMarcaPN := SD1->D1_MARCAPN
	_cCarcaca := SD1->D1_CARCACA
	_cServPCP := SD1->D1_SERVICO
	_cDesenho := SD1->D1_X_DESEN
	_cOBS     := SD1->D1_X_OBS
	
	SC2->(dbSetOrder(1))
	SC2->(dbSeek(xFilial("SC2")+_cIndNum)) //SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO
	
	Reclock("SC2",.F.)
		SC2->C2_ITEM    := Substr(SC6->C6_ITEMORI,3,2)
		SC2->C2_NUM     := _cNumOPx
		SC2->C2_XNREDUZ := _nReduz
		SC2->C2_SERIEPN := _cSeriePN
		SC2->C2_NUMFOGO := _cNumFogo
		SC2->C2_MARCAPN := _cMarcaPN
		SC2->C2_CARCACA := _cCarcaca
		SC2->C2_SERVPCP := _cServPCP
		SC2->C2_X_DESEN := _cDesenho
		SC2->C2_OBS     := _cOBS
		SC2->C2_X_STATU := "1" //Status da producao
	msUnlock()
	
	//Gravo numero da OP do produto referente ao servico.
	
	_cQry := ""
	_cQry += " UPDATE "
	_cQry += + RetSqlName("SC6") + " "
	_cQry += " SET C6_NUMOP = '" +SC2->C2_NUM+ "', C6_ITEMOP = '" +SC2->C2_ITEM+ "' "
	_cQry += " WHERE C6_PRODUTO = '" +SD1->D1_SERVICO+ "' AND C6_ITEM = '" +SC6->C6_ITPVSRV+ "' AND C6_NUM = '" +SC2->C2_PEDIDO+ "' "
	
	TcSqlExec(_cQry)
	
EndIF

RestArea(_aArea)
Return(aHeader)