#include "rwmake.ch"
#include "topconn.ch"

User Function DVFATF50(cTab,cProd)
	Local lRet   := .F.
	Local cSql   := ""
	Local aArray := GetArea()

	cSql := "SELECT DA1_PRCVEN FROM "+RetSqlName("DA1")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   DA1_CODTAB = '"+cTab+"'"
	cSql += " AND   DA1_CODPRO = '"+cProd+"'"

	cSql := ChangeQuery(cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"DA1_TMP", .T., .T.)
	dbSelectArea("DA1_TMP")

	If !eof() .OR. AllTrim(SB1->B1_GRUPO) = AllTrim(GetMv("FS_DEL002"))
		lRet := .T.
	Else
		msgbox("O produto "+AllTrim(cProd)+" n�o esta cadastrado na tabela de pre�os "+AllTrim(cTab)+"."+chr(13)+chr(10)+"Entre em contato com o Depto de Custos.","Pre�o","STOP")
	Endif
	dbSelectArea("DA1_TMP")
	dbCloseArea()

	RestArea(aArray)
Return lRet