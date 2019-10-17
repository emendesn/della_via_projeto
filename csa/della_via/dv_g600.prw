#include "rwmake.ch"
#include "topconn.ch"

/*
Denis Francisco Tofoli
22/05/2006 - Reescrito de acordo com novas regras de contabilização
*/

User Function DV_G600()
	Local c_Custo	:= Space(Len(CTT->CTT_CUSTO))
	Local cSql      := ""
	Local a_area	:= GetArea()

	cSql := "SELECT CTT_CUSTO,CTT_TIPOVN"
	cSql += " FROM "+RetSqlName("SA3")+" SA3"

	cSql += " JOIN "+RetSqlName("CTT")+" CTT"
	cSql += " ON   CTT.D_E_L_E_T_ = ''"
	cSql += " AND  CTT_FILIAL = ''"
	cSql += " AND  CTT_FILORI = A3_FILORIG"
	//cSql += " AND  CTT_TIPOVN = '"+SF2->F2_TIPVND+"'"

	cSql += " WHERE SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
	cSql += " AND  A3_COD = '"+SF2->F2_VEND1+"'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	nCount:=0
	Do While !eof()
		If Alltrim(SF2->F2_TIPVND) $ AllTrim(CTT_TIPOVN)
			c_Custo := CTT_CUSTO
			nCount++
		Endif
		dbSkip()
	Enddo
	If nCount <> 1
		msgbox("Houve um problema na regra dos Centro de Custo","DV_G600","STOP")
		c_Custo := ""
	Endif
	dbCloseArea()

	RestArea(a_area)
Return(c_Custo)