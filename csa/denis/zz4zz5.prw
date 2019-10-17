#Include "Rwmake.ch"
#Include "Topconn.ch"

User Function ZZ4ZZ5()
	Private Titulo      := "ACO >>> ZZ4 | ACP >>> ZZ5"
	Private aSays       := {}
	Private aButtons    := {}

	If SM0->M0_CODIGO <> "03"
		msgbox("Esta rotina só pode ser executada na Durapol","Proposta","STOP")
		Return  nil
	Endif

	aAdd(aSays,"Esta rotina efetua a carga das propostas comerciais com base nas regras de desconto")
	aAdd(aSays,"cadastradas no sistema.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Carga() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                         }})

	FormBatch(Titulo,aSays,aButtons)
Return  nil

Static Function Carga()
	Local cSql    := ""
	Local cNomTmp := ""

	FechaBatch()

	ProcRegua(3)
	IncProc("Atualizando ACO ...")

	cSql := "SELECT ACO_FILIAL AS ZZ4_FILIAL"
	cSql += " ,     ACO_CODCLI AS ZZ4_CODCLI"
	cSql += " ,     ACO_LOJA   AS ZZ4_LOJA"
	cSql += " ,     ACO_CODREG AS ZZ4_CODREG"
	cSql += " ,     '001'      AS ZZ4_VERSAO"
	cSql += " ,     ACO_DESCRI AS ZZ4_DESCRI"
	cSql += " ,     ACO_CODTAB AS ZZ4_CODTAB"
	cSql += " ,     ACO_CONDPG AS ZZ4_CONDPG"
	cSql += " ,     ACO_FORMPG AS ZZ4_FORMPG"
	cSql += " ,     ACO_FAIXA  AS ZZ4_FAIXA"
	cSql += " ,     ACO_PERDES AS ZZ4_PERDES"
	cSql += " ,     ACO_TPHORA AS ZZ4_TPHORA"
	cSql += " ,     ACO_DATDE  AS ZZ4_DATDE"
	cSql += " FROM "+RetSqlName("ACO")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ACO_FILIAL = '"+xFilial("ACO")+"'"
	cSql += " AND   ACO_CODREG NOT IN(SELECT ZZ4_CODREG FROM "+RetSqlName("ZZ4")+" WHERE D_E_L_E_T_ = '')"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()

	dbSelectArea("ZZ4")
	Append From &cNomTmp
	fErase(cNomTmp+GetDbExtension())
	IncProc("Atualizando ACP ...")

	cSql := "SELECT ACP_FILIAL AS ZZ5_FILIAL"
	cSql += " ,     ACP_CODREG AS ZZ5_CODREG"
	cSql += " ,     '001'      AS ZZ5_VERSAO"
	cSql += " ,     ACP_ITEM   AS ZZ5_ITEM"
	cSql += " ,     ACP_CODPRO AS ZZ5_CODPRO"
	cSql += " ,     ACP_PERDES AS ZZ5_PERDES"
	cSql += " ,     ACP_PERACR AS ZZ5_PERACR"
	cSql += " ,     ACP_PRCVEN AS ZZ5_PRCVEN"
	cSql += " FROM "+RetSqlName("ACP")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ACP_FILIAL = '"+xFilial("ACP")+"'"
	cSql += " AND   ACP_CODREG NOT IN(SELECT DISTINCT ZZ5_CODREG FROM "+RetSqlName("ZZ5")+" WHERE D_E_L_E_T_ = '')"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()

	dbSelectArea("ZZ5")
	Append From &cNomTmp
	fErase(cNomTmp+GetDbExtension())
	IncProc("Atualizando ACP ...")
Return nil