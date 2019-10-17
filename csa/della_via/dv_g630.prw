#include "rwmake.ch"
#include "topconn.ch"

/*
Denis Francisco Tofoli
22/05/2006 - Reescrito de acordo com novas regras de contabilização
*/

User Function DV_G630()
	Local c_Custo := Space(Len(CTT->CTT_CUSTO))
	Local cSql    := ""
	Local _aArea1
	Local _nX1
	Local _aArqs1
	Local _aAlias1

	// Salva Areas
	_aArea1   := GetArea()
	_aArqs1   := {"SD2"}
	_aAlias1  := {}
	For _nX1  := 1 To Len(_aArqs1)
		dbSelectArea(_aArqs1[_nX1])
		AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
	Next                                      

	dbSelectArea("SD2")
	dbSetOrder(3)
	If MsSeek(SD2->(xFilial("SD2")+SD1->D1_NFORI))
		cSql := "SELECT CTT_CUSTO,F2_TIPVND,CTT_TIPOVN"
		cSql += " FROM "+RetSqlName("SF2")+" SF2"

		cSql += " JOIN "+RetSqlName("SA3")+" SA3"
		cSql += " ON   SA3.D_E_L_E_T_ = ''"
		cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += " AND  A3_COD = F2_VEND1"

		cSql += " JOIN "+RetSqlName("CTT")+" CTT"
		cSql += " ON   CTT.D_E_L_E_T_ = ''"
		cSql += " AND  CTT_FILIAL = '"+xFilial("CTT")+"'"
		cSql += " AND  CTT_FILORI = A3_FILORIG"
		//cSql += " AND  CTT_TIPOVN = F2_TIPVND"

		cSql += " WHERE SF2.D_E_L_E_T_ = ''"
		cSql += " AND   F2_FILIAL = '"+SD2->D2_FILIAL+"'"
		cSql += " AND   F2_DOC = '"+SD2->D2_DOC+"'"
		cSql += " AND   F2_SERIE = '"+SD2->D2_SERIE+"'"

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		dbSelectArea("ARQ_SQL")
		nCount:=0
		Do While !eof()
			If Alltrim(F2_TIPVND) $ AllTrim(CTT_TIPOVN)
				c_Custo := CTT_CUSTO
				nCount++
			Endif
			dbSkip()
		Enddo
		If nCount <> 1
			msgbox("Houve um problema na regra dos Centro de Custo","DV_G630","STOP")
			c_Custo := ""
			Endif
		dbCloseArea()
	Endif

	// Retaura Areas
	For _nX1 := 1 To Len(_aAlias1)
		dbSelectArea(_aAlias1[_nX1,1])
		dbSetOrder(_aAlias1[_nX1,2])
		dbGoTo(_aAlias1[_nX1,3])
	Next
	RestArea(_aArea1)
Return(c_Custo)