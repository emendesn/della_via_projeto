#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVESTR07
	Private cString        := "SF1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Documentos de entrada por Usuario"
	Private tamanho        := "M"
	Private nomeprog       := "DVESTR07"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DESTR7"
	Private titulo         := "Documentos de entrada por Usuario"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVESTR07"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Usuario            ?"," "," ","mv_ch1","C", 15,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","US3","","","",""          })
	aAdd(aRegs,{cPerg,"02","Da Digitacao       ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Ate a Digitacao    ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })


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
	Cabec1:=" Usuario           Filial   Documento   Serie   Fornecedor                                             Entrada                Valor"
	        * XXXXXXXXXXXXXXX   XX       XXXXXX      XXX     XXXXXX-XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99   99,999,999,999.99
    	    *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	cSql := "SELECT DB2.USERLG(F1_USERLGI) AS USUARIO,F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F1_DTDIGIT,F1_VALBRUT"
	cSql += " FROM "+RetSqlName("SF1")+" SF1"

	cSql += " JOIN "+RetSqlName("SA2")+" SA2"
	cSql += " ON   SA2.D_E_L_E_T_ = ''"
	cSql += " AND  A2_FILIAL = ''"
	cSql += " AND  A2_COD = F1_FORNECE"
	cSql += " AND  A2_LOJA = F1_LOJA"

	cSql += " WHERE SF1.D_E_L_E_T_ = ''"
	cSql += " AND   F1_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   F1_DTDIGIT  BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'"
	cSql += " AND   F1_TIPO = 'N'"
	cSql += " AND   DB2.USERLG(F1_USERLGI) = '"+mv_par01+"'"
	cSql += " ORDER BY F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","F1_DTDIGIT","D")
	TcSetField("ARQ_SQL","F1_VALBRUT","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
		IncProc("Imprimindo ...")

		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif
	
		@ LI,001 PSAY USUARIO
		@ LI,019 PSAY F1_FILIAL
		@ LI,028 PSAY F1_DOC
		@ LI,040 PSAY F1_SERIE
		@ LI,048 PSAY F1_FORNECE+"-"+F1_LOJA
		@ LI,060 PSAY A2_NOME
		@ LI,103 PSAY F1_DTDIGIT
		@ LI,114 PSAY F1_VALBRUT PICTURE "@e 99,999,999,999.99"
		LI++
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp
		Roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil