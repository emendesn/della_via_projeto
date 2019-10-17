#include "RwMake.ch"
#include "TopConn.ch"

User Function DVFINF02
	Private Titulo      := "Atualiza Portador"
	Private aSays       := {}
	Private aButtons    := {}
	Private cPerg       := "FINF02"
	Private aRegs       := {}
	Private lExec       := .F.

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	aAdd(aRegs,{cPerg,"01","Cliente             "," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"02","Do Vencimento       "," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Até o Vencimento    "," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Portador            "," "," ","mv_ch4","C", 03,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })

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

	aAdd(aSays,"Esta rotina atualiza o campo portador na tabela de titulos a receber (SE1)")
	aAdd(aSays,"de acordo com os parametros definidos pelo usuário.")

	aAdd(aButtons,{ 1,.T.,{|o| lExec:=.T.,FechaBatch() }})
	aAdd(aButtons,{ 2,.T.,{|o| lExec:=.F.,FechaBatch() }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)     }})

	FormBatch(Titulo,aSays,aButtons)

	if lExec .and. msgbox("Confirma processamento ?","Portador","YESNO")
		Processa({|| ProcAtu() },Titulo,,.t.)
	Endif
Return nil

Static Function ProcAtu
	Local cSql := ""

	cSql := "UPDATE "+RetSqlName("SE1")
	cSql += " SET E1_PORTADO = '"+mv_par04+"'"
	cSql += " ,   E1_CONTA = ''"
	cSql += " ,   E1_AGEDEP = ''"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += " AND   E1_CLIENTE = '"+mv_par01+"'"
	cSql += " AND   E1_VENCTO BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'"
	cSql += " AND   E1_SITUACA = '0'"
	cSql += " AND   E1_PORTADO <> '"+mv_par04+"'"

	nUpdt := 0
	MsgRun("Atualizando titulos ...",,{|| nUpdt := TcSqlExec(cSql)})

	If nUpdt < 0
		MsgBox(TcSqlError(),"Portador","STOP")
	Else
		MsgBox("Titulos atualizados com sucesso","Portador","INFO")
	Endif
Return nil