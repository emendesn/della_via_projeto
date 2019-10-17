#Include "rwmake.ch"
#Include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DSEPUR01
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Relação de SEPU'S por motivos"
	Private tamanho        := "M"
	Private nomeprog       := "DSEPUR01"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DSPR01"
	Private titulo         := "Relação de SEPU'S por motivos"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DSEPUR01"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Do Motivo          ?"," "," ","mv_ch1","C", 03,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SZS","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate o Motivo       ?"," "," ","mv_ch2","C", 03,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SZS","","","",""          })
	aAdd(aRegs,{cPerg,"03","Da Emissao         ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate a Emissao      ?"," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Do Cliente         ?"," "," ","mv_ch5","C", 06,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate o Cliente      ?"," "," ","mv_ch6","C", 06,0,0,"G","","mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })


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
	Cabec1:=" ..."
	Cabec1:="          Cliente     Nome                                       Emissao    Baixa                  Valor"
	        *          XXXXXX-XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99   99/99/99   99,999,999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	// Query
	cSql := "SELECT E1_MOTDESC,ZS_DESCR,E1_CLIENTE,E1_LOJA,A1_NOME,E1_NUM,E1_EMISSAO,E1_BAIXA,E1_VALOR"
	cSql += " FROM "+RetSqlName("SE1")+" SE1"

	cSql += " LEFT JOIN "+RetSqlName("SZS")+" SZS"
	cSql += " ON   SZS.D_E_L_E_T_ = ''"
	cSql += " AND  ZS_FILIAL = '"+xFilial("SZS")+"'"
	cSql += " AND  ZS_COD = E1_MOTDESC"

	cSql += " LEFT JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = E1_CLIENTE"
	cSql += " AND  A1_LOJA = E1_LOJA"

	cSql += " WHERE SE1.D_E_L_E_T_ = ''"
	cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += " AND   E1_MOTDESC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   E1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	cSql += " AND   E1_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   E1_PREFIXO = 'SEP'"
	cSql += " ORDER BY E1_MOTDESC,E1_NUM"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","E1_EMISSAO","D")
	TcSetField("ARQ_SQL","E1_BAIXA"  ,"D")
	TcSetField("ARQ_SQL","E1_VALOR"  ,"N",14,2)
	
	nSubTot := 0
	nTotGer := 0

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
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

		cMot := E1_MOTDESC
		LI++
		@ LI,005 PSAY E1_MOTDESC + " - " + ZS_DESCR
		LI++

		Do While !eof() .AND. E1_MOTDESC = cMot
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
	
			@ LI,010 PSAY E1_CLIENTE + "-" + E1_LOJA
			@ LI,022 PSAY A1_NOME
			@ LI,065 PSAY E1_EMISSAO
			@ LI,076 PSAY E1_BAIXA
			@ LI,087 PSAY E1_VALOR PICTURE "@e 99,999,999,999.99"
			nSubTot += E1_VALOR ; nTotGer += E1_VALOR
			LI++
			dbSkip()
		Enddo
		@ LI,005 PSAY "Sub-Total"
		@ LI,087 PSAY nSubTot PICTURE "@e 99,999,999,999.99"
		LI++
		nSubTot := 0
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		LI++
		@ LI,005 PSAY "Total Geral"
		@ LI,087 PSAY nTotGer PICTURE "@e 99,999,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil