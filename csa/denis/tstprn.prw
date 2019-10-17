#include "DellaVia.ch"

User Function TstPrn()
	Private cString        := "SA1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Titulo do Relatorio"
	Private tamanho        := "M"
	Private nomeprog       := "RELNOME"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "PERG"
	Private titulo         := "Titulo do Relatorio"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "RELNOME"
	Private lImp           := .F.

	/*
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Do Sub-Grupo       ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SZA","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate o Sub-Grupo    ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SZA","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do C. de Custos    ?"," "," ","mv_ch3","C", 09,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SI3","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate o C. de Custos ?"," "," ","mv_ch4","C", 09,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SI3","","","",""          })
	aAdd(aRegs,{cPerg,"05","Da Data            ?"," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate a Data         ?"," "," ","mv_ch6","D", 08,0,0,"G","","mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"07","Da Conta           ?"," "," ","mv_ch7","C", 20,0,0,"G","","mv_par07",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SI1","","","",""          })
	aAdd(aRegs,{cPerg,"08","Ate a Conta        ?"," "," ","mv_ch8","C", 20,0,0,"G","","mv_par08",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SI1","","","",""          })
	aAdd(aRegs,{cPerg,"09","Imprime            ?"," "," ","mv_ch9","N", 01,0,0,"C","","mv_par09","Nivel 1","","","","","NIvel 2","","","","","Nivel 3","","","","","","","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"10","Ligacoes / Mes     ?"," "," ","mv_cha","N", 06,0,0,"G","","mv_par10",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","","@e 999,999"})


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
	*/
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return nil


Static Function RunReport()
	@ 000,034 PSAY CHR(27)+"0" //1/8
	For k=1 to 3
		@ 001,035 PSAY "LINHA 01"
		@ 040,035 PSAY "LINHA 30"
		@ 080,035 PSAY "LINHA 60"
	Next

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

