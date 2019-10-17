#Include "Dellavia.ch"
#Define CRLF chr(13)+chr(10)

User Function DVEDI05
	Private Titulo      := "EDI Mercador - Desmarca Nota Fiscal"
	Private aSays       := {}
	Private aButtons    := {}
	Private aEnvLog     := {}
	Private cPerg       := "DVEDI5"
	Private aRegs       := {}

	If SM0->M0_CODIGO <> "01"
		msgbox("Esta rotina só pode ser executada na DellaVia","EDI","STOP")
		Return  nil
	Endif

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}

	aAdd(aRegs,{cPerg,"01","Filial             ?"," "," ","mv_ch1","C", 02,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })
	aAdd(aRegs,{cPerg,"02","Nota               ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })
	aAdd(aRegs,{cPerg,"03","Série              ?"," "," ","mv_ch3","C", 03,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })

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

	aAdd(aSays,"Desmarca NF do Carrefour para nova Exportação.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Desmarca() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Desmarca()
	Local cSql   := ""

	FechaBatch()

	cSql := "UPDATE "+RetSqlName("SF2")
	cSql += " SET  F2_EXFLAG = ''"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   F2_FILIAL  = '"+mv_par01+"'"
	cSql += " AND   F2_DOC     = '"+mv_par02+"'"
	cSql += " AND   F2_SERIE   = '"+mv_par03+"'"
	cSql += " AND   F2_CLIENTE = '0UC8OP'"

	nUpdt := 0
	nUpdt := TcSqlExec(cSql)

	If nUpdt < 0
		MsgBox(TcSqlError(),"EDI - Mercador","STOP")
	Endif
Return nil