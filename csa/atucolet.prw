#include "rwmake.ch"
#include "topconn.ch"

User Function AtuColet()
	Private Titulo   := "Coleta de Pneus"
	Private aSays    := {}
	Private aButtons := {}

	aAdd(aSays,"Esta rotina preenche os campos de relacionamento entre as tabelas SC2 e SD1 referentes")
	aAdd(aSays,"a coleta de pneus - Durapol")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcCP() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcCP
	Local cSql := ""

	If !msgbox("Confirma processamento?","Coletas","YESNO")
		Return nil
	Endif

	FechaBatch()

	cSql := "SELECT C2_NUM,C2_ITEM,C2_PRODUTO"
	cSql += " ,D1_DOC,D1_SERIE,D1_ITEM,D1_FORNECE,D1_LOJA"
	cSql += " FROM SC2030 SC2, SD1030 SD1"
	cSql += " WHERE SC2.D_E_L_E_T_= ''"
	cSql += " AND   SD1.D_E_L_E_T_ = ''"
	cSql += " AND   D1_DOC = C2_NUM"
	cSql += " AND   D1_ITEM = '00' || C2_ITEM"
	cSql += " AND   D1_TIPO = 'B'"
	cSql += " AND   D1_DTDIGIT = C2_EMISSAO"
	cSql := ChangeQuery(cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)

	dbSelectArea("ARQ_SQL")
	dbGoTop()
	ProcRegua(0)

	Do while !eof()
		incProc()
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SC2")+ARQ_SQL->(C2_NUM+C2_ITEM))
		if found()
			If RecLock("SC2",.F.)
				SC2->C2_NUMD1   := ARQ_SQL->D1_DOC
				SC2->C2_SERIED1 := ARQ_SQL->D1_SERIE
				SC2->C2_ITEMD1  := ARQ_SQL->D1_ITEM
				SC2->C2_FORNECE := ARQ_SQL->D1_FORNECE
				SC2->C2_LOJA    := ARQ_SQL->D1_LOJA
				MsUnlock()
			Endif
		Endif

		dbSelectArea("SD1")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SD1")+ARQ_SQL->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+C2_PRODUTO+D1_ITEM))
		if found()
			If RecLock("SD1",.F.)
				SD1->D1_NUMC2  := ARQ_SQL->C2_NUM
				SD1->D1_ITEMC2 := ARQ_SQL->C2_ITEM
				MsUnlock()
			Endif
		Endif

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()
Return nil