#include "rwmake.ch"
User Function M030INC

Local _aArea  := GetArea()
Local _cTelex := SA1->A1_TELEX
Local _cNCod  := SA1->A1_COD
Local _cNLocal:= SA1->A1_LOJA

IF SM0->M0_CODIGO == "03"
	IF !Empty(_cTelex) .and. Substr(_cTelex,1,2) == "DV" .and. INCLUI
		
		_cTelex := Substr(_cTelex,3,4) //Codigo Antigo Durapol
		
		IF Select("TMP") > 0
			TMP->(dbCloseArea())
		EndIF
		
		_cQry := ""
		_cQry += " UPDATE "
		_cQry += + RetSqlName("ACO") + " "
		_cQry += " SET ACO_CODREG = '" +_cNCod+ "', ACO_LOJA = '" +_cNLocal+ "', ACO_CODCLI = '"+_cNCod+"' "
		_cQry += " WHERE ACO_FILIAL='" + xFilial( "ACO" )+ "' AND ACO_CODREG = '" +_cTelex+ "' AND D_E_L_E_T_ = '' "
		
		TcSqlExec(_cQry)
		
		IF Select("TMP") > 0
			TMP->(dbCloseArea())
		EndIF
		
		IF Select("TMP1") > 0
			TMP1->(dbCloseArea())
		EndIF
		_cQry1 := ""
		_cQry1 += " UPDATE "
		_cQry1 += + RetSqlName("ACP") + " "
		_cQry1 += " SET ACP_CODREG = '" +_cNCod+ "' "
		_cQry1 += " WHERE ACP_FILIAL='" + xFilial( "ACP" )+ "' AND ACP_CODREG = '" +_cTelex+ "' AND D_E_L_E_T_ = '' "
		
		TcSqlExec(_cQry1)
		
		IF Select("TMP1") > 0
			TMP1->(dbCloseArea())
		EndIF
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+_cNCod+_cNLocal)
		RecLock("SA1",.F.)
			SA1->A1_TELEX := ""
		MsUnlock()
	EndIF
	
	
EndIF

RestArea(_aArea)

Return(.T.)
