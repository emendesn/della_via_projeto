
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR15 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDFATR15   บAutor  ณ by Golo            บ Data ณ  27/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Super Relatorio                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Della Via                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

	Private cString        := "SA1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio  "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Relatorio de Clientes                               "
	Private tamanho        := "M"
	Private nomeprog       := "DFATR15"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFATR15"
	Private titulo         := "Relatorio de Clientes"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR15"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
    aAdd(aRegs,{cPerg,"01","Do C๓digo                         ?"," "," ","mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"02","Ate o C๓digo                      ?"," "," ","mv_ch2","C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
 	aAdd(aRegs,{cPerg,"03","(M)otorista/(V)endedor/(I)ndicador?"," "," ","mv_ch3","C", 1,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

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
	Cabec1:=" Do C๓digo de " + mv_par01 + " at้ " + mv_par02

/*            1         2         3         4         5         6         7         8           9        10    117            132                 
              12345678901234567890123456789012345678901234567890123456789012345678901234567890182234567890123456789012345678901234567890 
*/
	Cabec2:=" FL| "
/*                                                                                                           
         1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890
02=Codigo=======[x]@!===========================================ZX0_COD===015
*/
	cSql := ""
	cSql += "select A1_FILIAL"
	for  i = 9 to len(aReturn)
	    if upper(substr(aReturn[i],18,1)) = "X" .and. upper(alltrim(substr(aReturn[i],65,10))) <> "A1_FILIAL"
	       Cabec2 += substr(aReturn[i],4,13) + "|"
	       cSql   += " ,"+alltrim(substr(aReturn[i],65,10))
	    endif
    next
    cSql += "  from " + RetSqlName("SA1")+ " SA1 "
    cSql += " where SA1.D_E_L_E_T_ = ' ' "
    cSql += "   and A1_FILIAL >= '  ' "
    cSql += "   and A1_FILIAL <= 'ZZ' "
    if upper(mv_par03) == "M"
       cSql += "   and A1_VEND3 >= '" + mv_par01 + "' "
       cSql += "   and A1_VEND3 <= '" + mv_par02 + "' "  
       cSql += " order by A1_VEND3, A1_COD "
    endif
    if upper(mv_par03) == "V"
       cSql += "   and A1_VEND4 >= '" + mv_par01 + "' "
       cSql += "   and A1_VEND4 <= '" + mv_par02 + "' "  
       cSql += " order by A1_VEND4, A1_COD "
    endif
    if upper(mv_par03) == "I"
       cSql += "   and A1_VEND5 >= '" + mv_par01 + "' "
       cSql += "   and A1_VEND5 <= '" + mv_par02 + "' "     
       cSql += " order by A1_VEND5, A1_COD "
    endif

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","I2_DATA","D")
	TcSetField("ARQ_SQL","I2_VALOR","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()
    LI:=iif(upper(mv_par05)="N",2,80)
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
	
	    @ Li, 001      Psay " "
    	for  i = 9 to len(aReturn)
             if upper(substr(aReturn[i],18,1)) = "X" .and. upper(alltrim(substr(aReturn[i],65,10))) <> "A1_FILIAL"
                variavel:=upper(alltrim(substr(aReturn[i],65,10)))
                @Li, pcol()+1 psay "|"
	            @Li, pcol()+1 psay &variavel
	         endif
        next

		LI++
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil
