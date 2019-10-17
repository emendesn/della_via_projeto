#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR91
	Private cString        := "SD2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Controle de Produção Mensal"
	Private tamanho        := "M"
	Private nomeprog       := "DFATR91"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR91"
	Private titulo         := "Controle de Produção Mensal"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR91"
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
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	*/
	
	wnrel := SetPrint(cString,NomeProg,NIL,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
	Cabec1:=" ..."
	Cabec2:=" ..."
	        * 
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22


	// Query
	cSql := ""
	cSql := cSql + "SELECT ..."

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","I2_DATA","D")
	TcSetField("ARQ_SQL","I2_VALOR","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif
	
		@ LI,001 PSAY ZB_SUBGRP
		@ LI,015 PSAY ZB_CONTA
		@ LI,040 PSAY I1_DESC
		@ LI,070 PSAY I2_DATA
		@ LI,085 PSAY Substr(I2_NUM,1,4)+"/"+Substr(I2_NUM,5,6)+"-"+I2_LINHA
		@ LI,104 PSAY I2_HIST
		@ LI,149 PSAY CC
		LI++
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		@ LI,015 PSAY "T O T A L   G E R A L"
		@ LI,170 PSAY nTotDebito  Picture "@e 99,999,999,999.99"
		@ LI,192 PSAY nTotCredito Picture "@e 99,999,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil