#include "rwmake.ch"
#include "topconn.ch"

User Function M460SC9
Local _aArea := GetArea()
Local _aAreaSF2:= SF2->(GetArea())
Local _aAreaSD2:= SD2->(GetArea())
Local _aAreaSE1:= SE1->(GetArea())
Local _cQry := " "
/*
_cQry:= "SELECT * "
_cQry+= " FROM " + RetSqlName("SE1") + " SE1 "
_cQry+= " WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND "
_cQry+= " E1_CLIENTE = '" + SC9->C9_CLIENTE + "' AND "
_cQry+= " E1_LOJA = '" + SC9->C9_LOJA + "' AND "
_cQry+= " E1_TIPO = 'NCC' AND "
_cQry+= " E1_SALDO > 0 AND "
_cQry+= " D_E_L_E_T_ = ' '"

_cQry := ChangeQuery(_cQry)

dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'E1TMP', .F., .T.)
dbGotop()
IF !EOF()
	IF Aviso("Pergunta","Este Cliente tem nota(s) de credito. Deseja Aplicar estes descontos ?",{"Sim","Nao"},1,"Atencao")=1
	
	EndIF
END
IF Select("E1TMP") > 0
	dbSelectArea("E1TMP")
	dbCloseArea()
EndIF
*/
RestArea(_aAreaSF2)
RestArea(_aAreaSD2)
RestArea(_aAreaSE1)
RestArea(_aArea)
Return