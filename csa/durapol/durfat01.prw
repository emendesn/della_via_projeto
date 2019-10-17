#include "rwmake.ch"
#include "topconn.ch"

User Function DURFAT01
	Private Titulo   := "Atualiza Ultima Compra - Cadastro de Clientes"
	Private cPerg    := "DFTF01"
	Private aRegs    := {}
	Private aSays    := {}
	Private aButtons := {}

	If SM0->M0_CODIGO <> "03"
		msgbox("Esta rotina só pode ser executada na Durapol.","Ultima Compra","STOP")
		Return nil
	Endif

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	AADD(aRegs,{cPerg,"01","Do cliente         ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	AADD(aRegs,{cPerg,"02","Até o cliente      ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.F.)


	aAdd(aSays,"Esta rotina pega a emissao da ultima nota para cada cliente e atualiza no campo")
	aAdd(aSays,"A1_ULTCOM, apenas para os clientes selecionados nos parametros, e que tenham o ")
	aAdd(aSays,"campo em branco")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcUC() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcUC()
	Private cSql   := ""

	If !msgbox("Confirma ?","Executar","YESNO")
		Return
	Endif

	FechaBatch()
	
	cSql := ""
	cSql := cSql + "SELECT F2_CLIENTE,F2_LOJA,MAX(F2_EMISSAO) AS ULTCOM"
	cSql := cSql + " FROM SF2030 SF2"

	cSql := cSql + " JOIN SA1010 SA1"
	cSql := cSql + " ON  SA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND A1_FILIAL = ''"
	cSql := cSql + " AND A1_COD = F2_CLIENTE"
	cSql := cSql + " AND A1_LOJA = F2_LOJA"
	cSql := cSql + " AND A1_ULTCOM = ''"

	cSql := cSql + " WHERE SF2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   F2_DUPL <> ''"
	cSql := cSql + " AND   F2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql := cSql + " GROUP BY F2_CLIENTE,F2_LOJA"
	cSql := cSql + " ORDER BY F2_CLIENTE,F2_LOJA"

	MsgRun("Consultando Banco de Dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","ULTCOM","D")
	
	ProcRegua(0)
	dbSelectArea("ARQ_SQL")
	dbGotop()
	
	Do while !eof()
		incProc(ARQ_SQL->F2_CLIENTE+"/"+ARQ_SQL->F2_LOJA)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SA1")+ARQ_SQL->F2_CLIENTE+ARQ_SQL->F2_LOJA)
		if Found()
			if RecLock("SA1",.F.)
				SA1->A1_ULTCOM := ARQ_SQL->ULTCOM
				MsUnlock()
			Endif
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()
Return nil