#Include "Dellavia.ch"

User Function LP_CCCTB(cFil)
	Local   cRetCtb := ""
	Local   cSql    := ""
	Local   aArea   := GetArea()
	Local   cAlias 	:= GetNextAlias() 
	Default cFil    := ""

	cSql := "SELECT Z1_CCCTB"
	cSql += " FROM "+RetSqlName("SZ1")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   Z1_FILIAL = '"+xFilial("SZ1")+"'"
	cSql += " AND   Z1_CODEMP = '"+SM0->M0_CODIGO+"'"
	cSql += " AND   Z1_CODFIL = '"+cFil+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),cAlias, .T., .T.)
	dbSelectArea(cAlias)
	If !eof()
		cRetCtb := Z1_CCCTB
	Endif
	dbCloseArea()

	RestArea(aArea)
Return cRetCtb