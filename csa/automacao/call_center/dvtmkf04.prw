#Include "Dellavia.ch"

User Function DVTMKF04
	Private Titulo      := "Corrige Complemento SUA"
	Private aSays       := {}
	Private aButtons    := {}
	Private cPerg       := "TMKF04"
	Private aRegs       := {}
	Private lExec       := .F.

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	aAdd(aRegs,{cPerg,"01","Da Emissao          "," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Emissao       "," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Grupo de Atendimento"," "," ","mv_ch3","C", 02,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SU0","","","",""          })

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

	aAdd(aSays,"Esta rotina atualiza o campo UA_COMPL na tabela de Orçamentos (SUA)")
	aAdd(aSays,"eliminando caracteres especiais.")

	aAdd(aButtons,{ 1,.T.,{|o| lExec:=.T.,FechaBatch() }})
	aAdd(aButtons,{ 2,.T.,{|o| lExec:=.F.,FechaBatch() }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)     }})

	FormBatch(Titulo,aSays,aButtons)

	if lExec .and. msgbox("Confirma processamento ?","Complemento","YESNO")
		Processa({|| ProcCompl() },Titulo,,.t.)
	Endif
Return nil

Static Function ProcCompl
	Local cSql  := ""
	Local cTxt  := ""
	Local cNovo := ""
	Local cChar := ""


	cSql := "SELECT UA_FILIAL,UA_NUM,UA_COMPL FROM "+RetSqlName("SUA")+" SUA"
	
	cSql += " JOIN "+RetSqlName("SU7")+" SU7"
	cSql += " ON   SU7.D_E_L_E_T_ = ''"
	cSql += " AND  U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND  U7_COD = UA_OPERADO"
	cSql += " AND  U7_POSTO = '"+mv_par03+"'"
	
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_COMPL <> ''"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)

	dbSelectArea("ARQ_SQL")

	ProcRegua(0)
	Do While !eof()
		incProc("Processando ...")

		cTxt  := AllTrim(UA_COMPL)
		cNovo := ""

		For k=1 to Len(UA_COMPL)
			cChar := Substr(UA_COMPL,k,1)

			If !(cChar $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ") .AND. !(cChar $ "abcdefghijklmnopqrstuvwxyz") .AND. !(cChar $ "0123456789!@#$%*()-_+=:;,./\")
				cNovo += Space(1)
			Else
				cNovo += cChar
			Endif
		Next

		cSql := "UPDATE "+RetSqlName("SUA")
		cSql += " SET  UA_COMPL = '"+cNovo+"'"
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   UA_FILIAL = '"+ARQ_SQL->UA_FILIAL+"'"
		cSql += " AND   UA_NUM = '"+ARQ_SQL->UA_NUM+"'"

		nUpdt := 0
		nUpdt := TcSqlExec(cSql)

		If nUpdt < 0
			MsgBox(TcSqlError(),"SUA","STOP")
		Endif

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()
Return nil