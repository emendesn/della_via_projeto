#include "rwmake.ch"
#include "topconn.ch"

User Function AtuSalar()
	Private Titulo   := "Atu Salario"
	Private aSays    := {}
	Private aButtons := {}

	aAdd(aSays,"Esta rotina atualiza o campo de salario com base no valor de comissão de venda")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcSL() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcSL
	Local cSql := ""

	If !msgbox("Confirma processamento?","Coletas","YESNO")
		Return nil
	Endif

	FechaBatch()

	cSql := "SELECT RA_FILIAL,RA_MAT,RC_VALOR"
	cSql += " FROM "+RetSqlName("SRA")+" SRA"

	cSql += " JOIN "+RetSqlName("SRC")+" SRC"
	cSql += " ON   SRC.D_E_L_E_T_ = ''"
	cSql += " AND  RC_FILIAL = RA_FILIAL"
	cSql += " AND  RC_MAT = RA_MAT"
	cSql += " AND  RC_PD IN('033','170')"
	cSql += " AND  RC_DATA = '20060228'"

	cSql += " WHERE SRA.D_E_L_E_T_ = ''"
	cSql += " ORDER  BY RA_FILIAL,RA_MAT"

	//cSql := ChangeQuery(cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)

	dbSelectArea("ARQ_SQL")
	dbGoTop()
	ProcRegua(0)

	Do while !eof()
		incProc()
		dbSelectArea("SRA")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(ARQ_SQL->RA_FILIAL + ARQ_SQL->RA_MAT)
		if found()
			If RecLock("SRA",.F.)
				SRA->RA_SALARIO := SRA->RA_SALARIO + ARQ_SQL->RC_VALOR
				MsUnlock()
			Endif
		Endif

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()
Return nil