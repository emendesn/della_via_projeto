#include "rwmake.ch"
#include "topconn.ch"

User Function DVCRDF01(cCodCli,cLojaCli)
	Local aArea := GetArea()
	Local lRet  := .F.
	Local cSql  := ""
	
	cSql := "SELECT A1_BLQVEN,X5_DESCRI FROM "+RetSqlName("SA1")+" SA1"

	cSql += " LEFT JOIN "+RetSqlName("SX5")+" SX5"
	cSql += " ON   SX5.D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += " AND  X5_TABELA = 'BQ'"
	cSql += " AND  X5_CHAVE = A1_BLQVEN"

	cSql += " WHERE SA1.D_E_L_E_T_ = ''"
	cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND   A1_COD = '"+cCodCli+"'"
	cSql += " AND   A1_LOJA = '"+cLojaCli+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	If !eof()
		If A1_BLQVEN = "0" .OR. A1_BLQVEN = " "
			lRet := .T.
		Else
			msgbox("Cliente bloqueado para Orçamento / Vendas"+;
					chr(10)+chr(13)+chr(10)+chr(13)+;
					"Motivo: "+Capital(AllTrim(X5_DESCRI))+;
					chr(10)+chr(13)+chr(10)+chr(13)+;
					"Detalhes, entrar em contato com o Departamento de Crédito.","Bloqueado","STOP")
		Endif
	Endif
	dbCloseArea()
	RestArea(aArea)
Return lRet