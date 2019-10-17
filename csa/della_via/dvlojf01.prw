#include "RwMake.ch"
#include "TopConn.ch"

User Function DVLOJF01
	Private Titulo   := "Ajusta Preço PB5 - DEGRES"
	Private aSays    := {}
	Private aButtons := {}
	Private cUltMes  := SuperGetMv("MV_123",.F.,Space(6))

	aAdd(aSays,"Esta rotina recalcula a media do preço de venda por DEGRES e atualiza na")
	aAdd(aSays,"tabela PB5")
	aAdd(aSays,"")
	aAdd(aSays,"Ultimo mes: "+Substr(cUltMes,5,2)+"/"+Substr(cUltMes,1,4))

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcAtu() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                           }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcAtu
	Local cSql   := ""
	Local lAchou := .F.

	If cUltMes >= Substr(dtos(dDataBase),1,6)
		msgbox("Esta rotina só pode ser executada uma vez por mês.","DEGRES","STOP")
		FechaBatch()
		Return nil
	Endif

	If !msgbox("Confirma processamento ?","DEGRES","YESNO")
		Return nil
	Endif

	FechaBatch()

	if ExisteSx6("MV_123")
		dbSelectArea("SX6")
		If RecLock("SX6",.F.)
			SX6->X6_CONTEUD := Substr(dtos(dDataBase),1,6)
		Endif
	Endif
	
	cSql := cSql + "SELECT DISTINCT D2_FILIAL,B1_DEPTODV,B1_GRUPODV,B1_ESPECDV"
	cSql := cSql + " FROM "+RetSqlName("SD2")+" SD2"

	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql := cSql + " AND  B1_COD = D2_COD"
	cSql := cSql + " AND  B1_GRUPODV <> ''"

	cSql := cSql + " JOIN "+RetSqlName("PB5")+" PB5"
	cSql := cSql + " ON   PB5.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  PB5_FILIAL = '"+xFilial("PB5")+"'"
	cSql := cSql + " AND  PB5_LOJA = D2_FILIAL"
	cSql := cSql + " AND  PB5_DEPTO = B1_DEPTODV"
	cSql := cSql + " AND  PB5_GRUPO = B1_GRUPODV"
	cSql := cSql + " AND  PB5_ESPEC = B1_ESPECDV"
	cSql := cSql + " AND  PB5_123 < '3'"
	cSql := cSql + " WHERE SD2.D_E_L_E_T_ = ''"

	cSql := cSql + " UNION ALL"

	cSql := cSql + " SELECT DISTINCT D2_FILIAL,B1_DEPTODV,B1_GRUPODV,B1_ESPECDV"
	cSql := cSql + " FROM "+RetSqlName("SD2")+" SD2"

	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql := cSql + " AND  B1_COD = D2_COD"
	cSql := cSql + " AND  B1_GRUPODV <> ''"

	cSql := cSql + " LEFT JOIN "+RetSqlName("PB5")+" PB5"
	cSql := cSql + " ON   PB5.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  PB5_FILIAL = '"+xFilial("PB5")+"'
	cSql := cSql + " AND  PB5_LOJA = D2_FILIAL"
	cSql := cSql + " AND  PB5_DEPTO = B1_DEPTODV"
	cSql := cSql + " AND  PB5_GRUPO = B1_GRUPODV"
	cSql := cSql + " AND  PB5_ESPEC = B1_ESPECDV"

	cSql := cSql + " WHERE SD2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   PB5_VLUNIT IS NULL"
	cSql := cSql + " ORDER BY D2_FILIAL,B1_DEPTODV,B1_GRUPODV,B1_ESPECDV"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	
	ProcRegua(0)
	Do While !eof()
		incProc("Recalculando ...")
		dbSelectArea("PB5")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("PB5")+ARQ_SQL->(D2_FILIAL+B1_DEPTODV+B1_GRUPODV+B1_ESPECDV))
		lAchou := Found()
		If RecLock("PB5",!lAchou)
			If !lAchou
				PB5->PB5_FILIAL := xFilial("PB5")
				PB5->PB5_LOJA   := ARQ_SQL->D2_FILIAL
				PB5->PB5_DEPTO  := ARQ_SQL->B1_DEPTODV
				PB5->PB5_GRUPO  := ARQ_SQL->B1_GRUPODV
				PB5->PB5_ESPEC  := ARQ_SQL->B1_ESPECDV
				PB5->PB5_DATINC := dDataBase
			Endif
			PB5->PB5_123    := Str(Val(PB5_123)+1,1)
			PB5->PB5_VLUNIT := MediaVenda(ARQ_SQL->D2_FILIAL,ARQ_SQL->B1_DEPTODV,ARQ_SQL->B1_GRUPODV,ARQ_SQL->B1_ESPECDV)
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()
	msgbox("Recalculo efetuado com sucesso","DEGRES","INFO")
Return nil

Static Function MediaVenda(cLoja,cDepto,cGrupo,cEspec)
	Local cSql   := ""
	Local nQuant := 0
	Local nValor := 0
	Local aArea  := {}

	aArea := GetArea()

	cSql += "SELECT D2_FILIAL,B1_DEPTODV,B1_GRUPODV,B1_ESPECDV"
	cSql += " ,     SUBSTR(D2_EMISSAO,1,6) AS MES"
	cSql += " ,     SUM(D2_QUANT) AS QUANT"
	cSql += " ,     SUM(D2_TOTAL) AS VALOR"
	cSql += " FROM SD2010 SD2"

	cSql += " JOIN SB1010 SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D2_COD"
	cSql += " AND  B1_DEPTODV = '"+cDepto+"'"
	cSql += " AND  B1_GRUPODV = '"+cGrupo+"'"
	cSql += " AND  B1_ESPECDV = '"+cEspec+"'"

	cSql += " WHERE SD2.D_E_L_E_T_ = ''"
	cSql += " AND   D2_FILIAL = '"+cLoja+"'"

	cSql += " GROUP BY D2_FILIAL,B1_DEPTODV,B1_GRUPODV,B1_ESPECDV,SUBSTR(D2_EMISSAO,1,6)"
	cSql += " ORDER BY D2_FILIAL,B1_DEPTODV,B1_GRUPODV,B1_ESPECDV,SUBSTR(D2_EMISSAO,1,6)"

	cSql += " FETCH FIRST 3 ROW ONLY"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MEDIA", .T., .T.)
	TcSetField("SQL_MEDIA","QUANT","N",14,2)
	TcSetField("SQL_MEDIA","VALOR","N",14,2)

	dbSelectArea("SQL_MEDIA")
	dbGoTop()
	cMesFim := ""
	Do while !eof()
		If Empty(cMesFim)
			cMesFim := Substr(dtos((stod(MES+"01") + 65)),1,6)
		Endif

		If MES <= cMesFim
			nQuant += QUANT
			nValor += VALOR
		Endif
		dbSkip()
	Enddo
	dbCloseArea()
	RestArea(aArea)
Return Round((nValor / nQuant),2)