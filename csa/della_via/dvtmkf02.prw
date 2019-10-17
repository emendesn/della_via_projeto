#Include "DellaVia.ch"

User Function DVTMKF02
	Private Titulo      := "Carteira de Prospects"
	Private aSays       := {}
	Private aButtons    := {}
	Private cPerg       := "TMKF02"

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Vendedor Origem    ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""       })
	aAdd(aRegs,{cPerg,"02","Vendedor Destino   ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""       })

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

	aAdd(aSays,"Esta rotina transfere os Prospects de um vendedor para o outro.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Trocar() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Trocar()
	FechaBatch()

	// Valida Operador
	dbSelectArea("SU7")
	dbSetOrder(4)
	dbSeek(xFilial("SU7")+__cUserId)
	If !Found()
		ApMsgStop("Voce não tem acesso a esta rotina","Carteiras")
		Return nil
	Endif


	// Valida Vendedor Origem
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek(xFilial("SA3")+mv_par01)
	if Found()
		If AllTrim(A3_REGIAO) <> AllTrim(SU7->U7_POSTO)
			ApMsgStop("O vendedor "+AllTrim(A3_COD)+" não pertence a sua regional","Carteiras")
			Return nil
		Endif
	Else
		ApMsgStop("O vendedor "+AllTrim(mv_par01)+" não existe no cadastro","Carteiras")
		Return nil
	Endif


	// Valida Vendedor Destino
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek(xFilial("SA3")+mv_par02)
	if Found()
		If AllTrim(A3_REGIAO) <> AllTrim(SU7->U7_POSTO)
			ApMsgStop("O vendedor "+AllTrim(A3_COD)+" não pertence a sua regional","Carteiras")
			Return nil
		Endif
	Else
		ApMsgStop("O vendedor "+AllTrim(mv_par02)+" não existe no cadastro","Carteiras")
		Return nil
	Endif


	// De - Para
	cSql := "UPDATE "+RetSqlName("SUS")
	cSql += " SET  US_VEND = '"+mv_par02+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   US_FILIAL = '"+xFilial("SUS")+"'"
	cSql += " AND   US_VEND = '"+mv_par01+"'"

	nUpdt := 0
	MsgRun("Atualizando Prospects ...",,{|| nUpdt := TcSqlExec(cSql)})

	If nUpdt < 0
		MsgBox(TcSqlError(),"Carteira","STOP")
	Else
		MsgBox("Atualização realizada com sucesso","Carteira","INFO")
	Endif
Return