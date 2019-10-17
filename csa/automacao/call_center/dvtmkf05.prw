#include "DellaVia.ch"

User Function DVTMKF05
	Local lRet     := .T.
	Local aArea    := GetArea()
	Local nPosCod  := aScan(aHeader,{|x| alltrim(x[2]) == "UB_PRODUTO"})
	Local nPosQtde := aScan(aHeader,{|x| alltrim(x[2]) == "UB_QUANT"})
	Local nPosDesc := aScan(aHeader,{|x| alltrim(x[2]) == "UB_DESC"})
	Local nPosItem := aScan(aHeader,{|x| alltrim(x[2]) == "UB_ITEM"})
	Local cSql     := ""
	Local nAprov   := 0
	Local nQuant   := 0
	Local cCod     := ""

	if M->UA_OPER = "1"
		For k=1 To Len(aCols)
			if aCols[k,nPosDesc] > SU7->U7_DVDESC
				cSql := "SELECT ZX2_PDESC,ZX2_COD,ZX2_QUANT FROM "+RetSqlName("ZX2")
				cSql += " WHERE D_E_L_E_T_ = ''"
				cSql += " AND   ZX2_FILIAL = '"+M->UA_FILIAL+"'"
				cSql += " AND   ZX2_ORC = '"+M->UA_NUM+"'"
				cSql += " AND   ZX2_ITEM = '"+aCols[k,nPosItem]+"'"
				cSql += " AND   ZX2_STATUS = '2'"
				cSql += " AND   ZX2_CONDPG = '"+M->UA_CONDPG+"'"
				cSql += " AND   ZX2_TABELA = '"+M->UA_TABELA+"'"
				cSql += " AND   ZX2_TIPVND = '"+M->UA_TIPOVND+"'"
				cSql += " ORDER BY ZX2_NUM DESC,ZX2_SEQ DESC"
				cSql += " FETCH FIRST 1 ROW ONLY"
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
				TcSetField("ARQ_SQL","ZX2_PDESC","C",14,2)
				TcSetField("ARQ_SQL","ZX2_QUANT","C",14,2)

				nAprov := 0
				nQuant := 0
				cCod   := ""

				if !Eof()
					nAprov := ZX2_PDESC
					nQuant := ZX2_QUANT
					cCod   := ZX2_COD
				Endif
				dbCloseArea()

				If aCols[k,nPosDesc] <> nAprov .OR. aCols[k,nPosCod] <> cCod .OR. aCols[k,nPosQtde] <> nQuant
					msgbox("Os dados do orçamento estão diferentes do aprovado","Desconto","STOP")
					lRet := .F.
					Exit
				Endif
			Endif
		Next k
	Endif

	RestArea(aArea)
Return lRet