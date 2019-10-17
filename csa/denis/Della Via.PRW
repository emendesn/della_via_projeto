#Include "Dellavia.ch"
#Define CRLF chr(13)+chr(10)

User Function DVEDI05
	Private Titulo      := "EDI Mercador - Nota Fiscal"
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

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Export() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})

	FormBatch(Titulo,aSays,aButtons)
