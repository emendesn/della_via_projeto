#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVESTR03
	Private cString        := "ZX0"
	Private aOrd           := {"Codigo","Grupo","Media"}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Geral - Consumo/Venda Mes a Mes de Materiais"
	Private tamanho        := "G"
	Private nomeprog       := "DVESTR03"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "ESTR03"
	Private titulo         := "Geral - Consumo/Venda Mes a Mes de Materiais"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVESTR03"
	Private lImp           := .F.
	Private aDescMes       := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Do Produto         ?"," "," ","mv_ch1","C", 15,0,0,"G",""           ,"mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate o Produto      ?"," "," ","mv_ch2","C", 15,0,0,"G",""           ,"mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Tipo            ?"," "," ","mv_ch3","C", 02,0,0,"G",""           ,"mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","02 ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate o Tipo         ?"," "," ","mv_ch4","C", 02,0,0,"G",""           ,"mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","02 ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Do Grupo           ?"," "," ","mv_ch5","C", 04,0,0,"G",""           ,"mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate o Grupo        ?"," "," ","mv_ch6","C", 04,0,0,"G",""           ,"mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"07","Itens              ?"," "," ","mv_ch7","C", 03,0,0,"G","U_fSelABC()","mv_par07",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"08","Local              ?"," "," ","mv_ch8","C", 60,0,0,"G","U_fSelLoc()","mv_par08",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })


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
	Private aMeses := {}

	Titulo:=AllTrim(Titulo) + " - Por "+aOrd[aReturn[8]]
	Cabec1:="Do Grupo: ("+mv_par05+") até ("+mv_par06+")"
	Cabec2:="Codigo       Grupo   Descrição                        ABC    Saldo"//AI/2005  JUN/2005  JUL/2005  AGO/2005  SET/2005  OUT/2005  NOV/2005  DEZ/2005  JAN/2006  FEV/2006  MAR/2006  ABR/2006     Média     Total   Dias Est"
	        *XXXXXXXXXX   XXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   X    999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999   999.999      9.999
    	    *012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21

	cFilABC  := ""
	For jj=1 to Len(AllTrim(mv_par07))
		If Substr(mv_par07,jj,1) <> "*"
			cFilABC := cFilABC + "'"+Substr(mv_par07,jj,1)+"',"
		Endif
	Next jj
	If Len(cFilABC) > 0
		cFilABC := substr(cFilABC,1,Len(cFilABC)-1)
	Endif


	cFilLoc  := ""
	For jj=1 to Len(AllTrim(mv_par08)) Step 2
		If Substr(mv_par08,jj,2) <> "**"
			cFilLoc := cFilLoc + "'"+Substr(mv_par08,jj,2)+"',"
		Endif
	Next jj
	If Len(cFilLoc) > 0
		cFilLoc := substr(cFilLoc,1,Len(cFilLoc)-1)
	Endif


	// Query
	cSql := "SELECT ZX0_COD,ZX0_GRUPO"
	cSql += " ,     SUM(ZX0_Q01) AS ZX0_Q01"
	cSql += " ,     SUM(ZX0_Q02) AS ZX0_Q02"
	cSql += " ,     SUM(ZX0_Q03) AS ZX0_Q03"
	cSql += " ,     SUM(ZX0_Q04) AS ZX0_Q04"
	cSql += " ,     SUM(ZX0_Q05) AS ZX0_Q05"
	cSql += " ,     SUM(ZX0_Q06) AS ZX0_Q06"
	cSql += " ,     SUM(ZX0_Q07) AS ZX0_Q07"
	cSql += " ,     SUM(ZX0_Q08) AS ZX0_Q08"
	cSql += " ,     SUM(ZX0_Q09) AS ZX0_Q09"
	cSql += " ,     SUM(ZX0_Q10) AS ZX0_Q10"
	cSql += " ,     SUM(ZX0_Q11) AS ZX0_Q11"
	cSql += " ,     SUM(ZX0_Q12) AS ZX0_Q12"
	cSql += " ,     (SUM(ZX0_TOTAL)/12) AS ZX0_MEDIA"
	cSql += " ,     SUM(ZX0_TOTAL) AS ZX0_TOTAL"
	cSql += " ,     ZX0_MES"
	cSql += " ,     ZX0_ABCGER AS ZX0_CURVA"
	cSql += " FROM "+RetSqlName("ZX0")+" ZX0"

	cSql += " WHERE ZX0.D_E_L_E_T_ = ''"
	cSql += " AND   ZX0_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   ZX0_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   ZX0_ABCGER IN("+cFilABC+")"
	cSql += " AND   ZX0_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " GROUP BY ZX0_COD,ZX0_GRUPO,ZX0_MES,ZX0_ABCGER"
	If aReturn[8] = 1
		cSql += " ORDER BY ZX0_COD"
	Elseif aReturn[8] = 2
		cSql += " ORDER BY ZX0_GRUPO"
	Elseif aReturn[8] = 3
		cSql += " ORDER BY ZX0_MEDIA DESC"
	Endif

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","ZX0_TOTAL","N",14,2)
	TcSetField("ARQ_SQL","ZX0_MEDIA","N",14,2)
	For k=1 to 12
		TcSetField("ARQ_SQL","ZX0_Q"+StrZero(k,2),"N",14,2)
	Next k
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbGoTop()
	If !eof()
		aMeses := {}
		cMes := Substr(ZX0_MES,5,2)
		cAno := Substr(ZX0_MES,1,4)
		nMes := Val(cMes)+1
		nAno := Val(cAno)-1
		For k=1 to 12
			If nMes = 13
				nMes := 1
				nAno := nAno + 1
			Endif
			aadd(aMeses,{StrZero(nMes,2),Str(nAno,4)})
			nMes++
		Next k
	Endif

	For k=1 To Len(aMeses)
		Cabec2 := Cabec2 + "  " + aDescMes[Val(aMeses[k,1])] + "/" + aMeses[k,2]
	Next k
	Cabec2 := Cabec2 + "     Média     Total   Dias Est"

	aTotGer := {0,0,0,0,0,0,0,0,0,0,0,0,0,0}

	Do While !eof()
		If aReturn[8] == 2
			cAnt := ZX0_GRUPO
			cCondSec := "ZX0_GRUPO == cAnt"
			cLinhaSub := "Total do grupo "+cAnt
		Else
			cCondSec := ".T."
		EndIf

		aTotSub := {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
		Do While !eof() .AND. &cCondSec
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("SB1")+ARQ_SQL->ZX0_COD)
			If !Found()
				dbSelectArea("ARQ_SQL")
				dbSkip()
				Loop
			Endif

			If B1_TIPO < mv_par03 .OR. B1_TIPO > mv_par04
				dbSelectArea("ARQ_SQL")
				dbSkip()
				Loop
			Endif


			nSaldo := 0
			cSql := "SELECT SUM(B2_QATU) AS SALDO"
			cSql += " FROM "+RetSqlName("SB2")+" SB2"
			cSql += " WHERE SB2.D_E_L_E_T_ = ''"
			cSql += " AND   B2_COD = '"+ARQ_SQL->ZX0_COD+"'"
			cSql += " AND   B2_LOCAL IN("+cFilLoc+")"
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_SALDO", .T., .T.)

			TcSetField("SQL_SALDO","SALDO"    ,"N",14,2)
			dbSelectArea("SQL_SALDO")
			nSaldo := SALDO
			dbCloseArea()
			dbSelectArea("ARQ_SQL")

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

			@ LI,000 PSAY Substr(ZX0_COD,1,10)
			@ LI,013 PSAY ZX0_GRUPO
			@ LI,021 PSAY SB1->B1_DESC
			@ LI,054 PSAY ZX0_CURVA
			@ LI,059 PSAY nSaldo Picture "@e 999,999"
			aTotGer[1]  += nSaldo
			aTotSub[1]  += nSaldo
			nCol := 69
			For k=1 to Len(aMeses)
				cCampo := "ZX0_Q"+aMeses[k,1]
				@ LI,nCol PSAY &cCampo Picture "@e 999,999"
				nCol += 10
				aTotGer[k+1]  += &cCampo
				aTotGer[14] += &cCampo
				aTotSub[k+1]  += &cCampo
				aTotSub[14] += &cCampo
			Next k
			@ LI,189 PSAY ZX0_MEDIA Picture "@e 999,999"
			@ LI,199 PSAY ZX0_TOTAL Picture "@e 999,999"
			@ LI,212 PSAY nSaldo/(ZX0_MEDIA/30) Picture "@e 9,999"
			LI++
			dbSkip()
		Enddo

		If aReturn[8] == 2
			@ li,015 PSay cLinhaSub
			nCol := 59
			For k=1 To Len(aTotSub)
				If k=14
					@ LI,nCol PSAY aTotSub[k]/12 Picture "@e 999,999"
					nCol += 10
				Endif
				@ LI,nCol PSAY aTotSub[k] Picture "@e 999,999"
				nCol += 10
			Next k
			LI++
		EndIf
		LI++
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		@ LI,000 PSAY "Total da Geral"
		nCol := 59
		For k=1 To Len(aTotGer)
			If k=14
				@ LI,nCol PSAY aTotGer[k]/12 Picture "@e 999,999"
				nCol += 10
			Endif
			@ LI,nCol PSAY aTotGer[k] Picture "@e 999,999"
			nCol += 10
		Next k

		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil