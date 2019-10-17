
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGPER01 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGEPR01   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SRA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Titulo do Relatorio"
	Private tamanho        := "M"
	Private nomeprog       := "DGPER01"
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
	Private wnrel          := "DGPER01"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
    AAdd(aRegs,{cPerg,"01","Da Filial     ?"        ,"   "       ,"   "       ,"mv_ch1","C", 2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AAdd(aRegs,{cPerg,"02","Ate a Filial  ?"        ,"   "       ,"   "       ,"mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AAdd(aRegs,{cPerg,"03","Da Matricula  ?"        ,"   "       ,"   "       ,"mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AAdd(aRegs,{cPerg,"04","Ate Matricaula?"        ,"   "       ,"   "       ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
/*	aAdd(aRegs,{cPerg,"05","Da Data            ?"," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate a Data         ?"," "," ","mv_ch6","D", 08,0,0,"G","","mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"07","Da Conta           ?"," "," ","mv_ch7","C", 20,0,0,"G","","mv_par07",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SI1","","","",""          })
	aAdd(aRegs,{cPerg,"08","Ate a Conta        ?"," "," ","mv_ch8","C", 20,0,0,"G","","mv_par08",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SI1","","","",""          })
	aAdd(aRegs,{cPerg,"09","Imprime            ?"," "," ","mv_ch9","N", 01,0,0,"C","","mv_par09","Nivel 1","","","","","NIvel 2","","","","","Nivel 3","","","","","","","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"10","Ligacoes / Mes     ?"," "," ","mv_cha","N", 06,0,0,"G","","mv_par10",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","","@e 999,999"})
*/






	dbSelectArea("SRA")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SRA",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.F.)
	
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
	Cabec1:= "Filial de " + mv_par01 + " a " + mv_par02

/*            1         2         3         4         5         6         7         8           9        10    117            132                 
              12345678901234567890123456789012345678901234567890123456789012345678901234567890182234567890123456789012345678901234567890 
*/
	Cabec2:= "FL|Matric|Nome Cliente                  |S|NASCIMENTO|CPF           |SALARIO   BASE| "
/*            xx|RA_FILIAL                            | |          |              |              |
                |xxxxxx|RA_MAT                        | |          |              |              |
                |      |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|RA_NOME     |              |              |
                                                      |x|RA_SEXO   |              |              | 
                                                         99/99/9999|RA_NASC       |              |
                                                                   |999.999.999-99|RA_CIC        |
                                                                                  |999,999,999.99|RA_SALARIO   
*/                                                                                                             

	cSql := ""
	cSql += "select RA_FILIAL, RA_MAT, RA_NOME, RA_SEXO, RA_NASC, RA_CIC, RA_SALARIO "
    cSql += "  from " + RetSqlName("SRA")+ " SRA "
    cSql += " where SRA.D_E_L_E_T_ = ' ' "
    cSql += "   and RA_FILIAL >= '" + mv_par01 + "' "
    cSql += "   and RA_FILIAL <= '" + mv_par02 + "' "
    cSql += "   and RA_MAT    >= '" + mv_par03 + "' " 
    cSql += "   and RA_MAT    <= '" + mv_par04 + "' "
    cSql += "   and RA_DEMISSA = '' "
    cSql += " order by RA_FILIAL, RA_MAT "

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SRA", .T., .T.)})

	TcSetField("SRA","I2_DATA","D")
	TcSetField("SRA","I2_VALOR","N",14,2)
	
	dbSelectArea("SRA")
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
	
	    @ Li, 001 Psay SRA->RA_FILIAL
        @ Li, 003 Psay "|"
        @ Li, 004 Psay SRA->RA_MAT
        @ Li, 010 Psay "|"
	    @ Li, 011 Psay SRA->RA_NOME
        @ Li, 041 Psay "|"
	    @ Li, 042 Psay SRA->RA_SEXO
        @ Li, 043 Psay "|"
        @ Li, 044 Psay SRA->RA_NASC    
        @ Li, 054 Psay "|"
	    @ Li, 055 Psay SRA->RA_CIC     Picture "@E 999.999.999-99"
        @ Li, 069 Psay "|"
	    @ Li, 070 Psay SRA->RA_SALARIO Picture "@E 999,999,999.99"

		LI++
		dbSkip()
	Enddo
	dbSelectArea("SRA")
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
