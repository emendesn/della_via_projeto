#include "rwmake.ch"
#include "topconn.ch"

User Function DFATF01()
	Private Titulo   := "Ajusta Regra de Desconto/Acrescimo"
	Private aSays    := {}
	Private aButtons := {}

	If SM0->M0_CODIGO <> "03"
		MsgStop("Este programa só pode ser executado na Durapol")
		Return
	Endif

	aAdd(aSays,"Compara os campos DA1_PRCVEN e ACP_PRCVEN gerando percentual de acrescimo ou")
	aAdd(aSays,"desconto e gravando nos respectivos campos na tabela ACP")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcPrc() },Titulo,,.t.) }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcPrc()
	Local cSql   := ""
	Local nRecs  := 0

	If !msgbox("Confirma a atualização das tabelas ?","Executar","YESNO")
		Return
	Endif

	FechaBatch()
	
	cSql := ""
	cSql := cSql + "SELECT ACP_FILIAL,ACP_CODREG,ACP_ITEM,ACP_CODPRO,ACP_PRCVEN,DA1_PRCVEN"
	cSql := cSql + " FROM "+RetSqlName("ACP")+" ACP"

	cSql := cSql + " JOIN "+RetSqlName("ACO")+" ACO"
	cSql := cSql + " ON   ACO.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  ACO_FILIAL = ''"
	cSql := cSql + " AND  ACO_CODREG = ACP_CODREG"

	cSql := cSql + " JOIN "+RetSqlName("DA1")+" DA1"
	cSql := cSql + " ON   DA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  DA1_FILIAL = ''"
	cSql := cSql + " AND  DA1_CODTAB = '001'"
	cSql := cSql + " AND  DA1_CODPRO = ACP_CODPRO"

	cSql := cSql + " WHERE ACP.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   ACP_FILIAL = ''"
	cSql := cSql + " AND   ACP_PRCVEN > 0"
	cSql := cSql + " ORDER BY ACP_FILIAL,ACP_CODREG,ACP_ITEM,ACP_CODPRO"
	MsgRun("Consultando Banco de Dados...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de Dados...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","DA1_PRCVEN","N",14,2)
	TcSetField("ARQ_SQL","ACP_PRCVEN","N",14,2)

	dbSelectArea("ARQ_SQL")
	dbGoTop()
	ProcRegua(0)
	Do while !eof()
		incProc(ACP_CODREG+"-"+ACP_ITEM)
		If DA1_PRCVEN <> ACP_PRCVEN
			dbSelectArea("ACP")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(ARQ_SQL->(ACP_FILIAL+ACP_CODREG+ACP_ITEM))
			If Found()
				If RecLock("ACP",.F.)
					ACP->ACP_PERDES := Round(iif(ARQ_SQL->(DA1_PRCVEN > ACP_PRCVEN),ARQ_SQL->(((ACP_PRCVEN/DA1_PRCVEN)-1)*-100),0),4)
					ACP->ACP_PERACR := Round(iif(ARQ_SQL->(DA1_PRCVEN < ACP_PRCVEN),ARQ_SQL->(((ACP_PRCVEN/DA1_PRCVEN)-1)*100),0),4)
					MsUnlock()
					nRecs ++
				Endif
			Endif
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()
	msgbox(AllTrim(Str(nRecs))+" registros alterados","Pufff","INFO")
Return nil