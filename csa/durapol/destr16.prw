#include "rwmake.ch"
#include "topconn.ch"

User Function DESTR16
	Private cString        := "SB3"
	Private aOrd           := {"Ranking","Codigo","Grupo"}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Consumo / Vendas mes a mes de Materiais"
	Private tamanho        := "G"
	Private nomeprog       := "DESTR16"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "ESTR16"
	Private titulo         := "Consumo / Vendas mes a mes de Materiais"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DESTR16"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := "DESTR16"
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Do Produto          "," "," ","mv_ch1","C", 15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	AADD(aRegs,{cPerg,"02","Ate o Produto       "," "," ","mv_ch2","C", 15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	AADD(aRegs,{cPerg,"03","Do Tipo             "," "," ","mv_ch3","C", 02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","",""})
	AADD(aRegs,{cPerg,"04","Ate o Tipo          "," "," ","mv_ch4","C", 02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","02 ","","","",""})
	AADD(aRegs,{cPerg,"05","Do Grupo            "," "," ","mv_ch5","C", 04,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
	AADD(aRegs,{cPerg,"06","Ate o Grupo         "," "," ","mv_ch6","C", 04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
	AADD(aRegs,{cPerg,"07","Unidade de medida   "," "," ","mv_ch7","N", 01,0,0,"C","","mv_par07","Primeira" ,"","","","","Segunda","","","","","","","","","","","","","","","","","","","   ","","","",""})

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
	cMes06  := "B3_Q"+StrZero(iif((Month(dDataBase)-5)<1,12+(Month(dDataBase)-5),Month(dDataBase)-5),2)
	cCabM06 := StrZero(iif((Month(dDataBase)-5)<1,12+(Month(dDataBase)-5),Month(dDataBase)-5),2)+"/"
	cCabM06 += iif((Month(dDataBase)-5)<1,Str(Year(dDataBase)-1,4),Str(Year(dDataBase),4))

	cMes05  := "B3_Q"+StrZero(iif((Month(dDataBase)-4)<1,12+(Month(dDataBase)-4),Month(dDataBase)-4),2)
	cCabM05 := StrZero(iif((Month(dDataBase)-4)<1,12+(Month(dDataBase)-4),Month(dDataBase)-4),2)+"/"
	cCabM05 += iif((Month(dDataBase)-4)<1,Str(Year(dDataBase)-1,4),Str(Year(dDataBase),4))

	cMes04  := "B3_Q"+StrZero(iif((Month(dDataBase)-3)<1,12+(Month(dDataBase)-3),Month(dDataBase)-3),2)
	cCabM04 := StrZero(iif((Month(dDataBase)-3)<1,12+(Month(dDataBase)-3),Month(dDataBase)-3),2)+"/"
	cCabM04 += iif((Month(dDataBase)-3)<1,Str(Year(dDataBase)-1,4),Str(Year(dDataBase),4))

	cMes03  := "B3_Q"+StrZero(iif((Month(dDataBase)-2)<1,12+(Month(dDataBase)-2),Month(dDataBase)-2),2)
	cCabM03 := StrZero(iif((Month(dDataBase)-2)<1,12+(Month(dDataBase)-2),Month(dDataBase)-2),2)+"/"
	cCabM03 += iif((Month(dDataBase)-2)<1,Str(Year(dDataBase)-1,4),Str(Year(dDataBase),4))

	cMes02  := "B3_Q"+StrZero(iif((Month(dDataBase)-1)<1,12+(Month(dDataBase)-1),Month(dDataBase)-1),2)
	cCabM02 := StrZero(iif((Month(dDataBase)-1)<1,12+(Month(dDataBase)-1),Month(dDataBase)-1),2)+"/"
	cCabM02 += iif((Month(dDataBase)-1)<1,Str(Year(dDataBase)-1,4),Str(Year(dDataBase),4))

	cMesAtu := "B3_Q"+StrZero(Month(dDataBase),2)
	cCabAtu := StrZero(Month(dDataBase),2)+"/"+Str(Year(dDataBase),4)


	Cabec1:="                |     |      |                               |  |       Saldo|                                   Consumo                                   |            |"
	Cabec2:="Código          |Tipo |Grupo |Descrição                      |UM|  em estoque|     "+cCabM06+"      "+cCabM05+"      "+cCabM04+"      "+cCabM03+"      "+cCabM02+"      "+cCabAtu+"|       Total| Ranking"
	        *XXXXXXXXXXXXXXX  XX    XXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX 9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99   99,999
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cSql := ""
	cSql := cSql + "SELECT B3_COD,B1_TIPO,B1_GRUPO,B1_DESC,B1_UM,B1_SEGUM,B1_CONV"
	cSql := cSql + " ,B3_Q01,B3_Q02,B3_Q03,B3_Q04,B3_Q05,B3_Q06,B3_Q07,B3_Q08,B3_Q09,B3_Q10,B3_Q11,B3_Q12,"
	cSql := cSql + " Sum(B2_QATU)"+iif(mv_par07=2,"/B1_CONV","")+" AS SALDO"
	cSql := cSql + " ,("+cMes06+"+"+cMes05+"+"+cMes04+"+"+cMes03+"+"+cMes02+"+"+cMesAtu+")"+iif(mv_par07=2,"/B1_CONV","")+" AS TOTAL"
	cSql := cSql + " FROM "+RetSqlName("SB3")+" SB3"
	cSql := cSql + " ,    "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ,    "+RetSqlName("SB2")+" SB2"
	cSql := cSql + " WHERE SB3.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   SB2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   B3_FILIAL = '"+xFilial("SB3")+"'"
	cSql := cSql + " AND   B3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql := cSql + " AND   B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql := cSql + " AND   B1_COD = B3_COD"
	cSql := cSql + " AND   B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql := cSql + " AND   B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	If mv_par07 = 2
		cSql := cSql + " AND   B1_CONV > 0"
	Endif
	cSql := cSql + " AND   B2_FILIAL = B3_FILIAL"
	cSql := cSql + " AND   B2_COD = B3_COD"
	cSql := cSql + " GROUP BY B3_COD,B1_TIPO,B1_GRUPO,B1_DESC,B1_UM,B1_SEGUM,B1_CONV"
	cSql := cSql + " ,B3_Q01,B3_Q02,B3_Q03,B3_Q04,B3_Q05,B3_Q06,B3_Q07,B3_Q08,B3_Q09,B3_Q10,B3_Q11,B3_Q12"
	cSql := cSql + " ORDER BY TOTAL DESC"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","SALDO","N",14,2)
	TcSetField("ARQ_SQL","TOTAL","N",14,2)
	For k=1 to 12
		TcSetField("ARQ_SQL","B3_Q"+StrZero(k,2),"N",14,2)
	Next
	
	dbSelectArea("ARQ_SQL")
	aEstru := dbStruct()
	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	If aReturn[8] = 2
		Index on B3_COD  TAG IND1 TO &cNomTmp
	Elseif aReturn[8] = 3
		Index on B1_GRUPO TAG IND1 TO &cNomTmp
	Endif

	dbSelectArea("ARQ_SQL")
	dbGoTop()

	Do While !eof()
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			For k=1 to Len(aEstru)
				FieldPut(k,ARQ_SQL->(FieldGet(k)))
			Next
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo

	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbgoTop()

	aTotal := {0,0,0,0,0,0,0,0}
	Do While !eof()
		IncProc("Imprimindo ...")
		If lAbortPrint .and. lImp
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

		@ LI,000 PSAY B3_COD
		@ LI,017 PSAY B1_TIPO
		@ LI,023 PSAY B1_GRUPO
		@ LI,030 PSAY B1_DESC
		@ LI,062 PSAY iif(mv_par07=1,B1_UM,B1_SEGUM)
		@ LI,065 PSAY SALDO    Picture "@e 9,999,999.99"
		aTotal[1] += SALDO
		If mv_par07 = 1
			@ LI,078 PSAY &cMes06  Picture "@e 9,999,999.99"
			@ LI,091 PSAY &cMes05  Picture "@e 9,999,999.99"
			@ LI,104 PSAY &cMes04  Picture "@e 9,999,999.99"
			@ LI,117 PSAY &cMes03  Picture "@e 9,999,999.99"
			@ LI,130 PSAY &cMes02  Picture "@e 9,999,999.99"
			@ LI,143 PSAY &cMesAtu Picture "@e 9,999,999.99"
			aTotal[2] += &cMes06
			aTotal[3] += &cMes05
			aTotal[4] += &cMes04
			aTotal[5] += &cMes03
			aTotal[6] += &cMes02
			aTotal[7] += &cMesAtu
		Else
			@ LI,078 PSAY &cMes06 / B1_CONV  Picture "@e 9,999,999.99"
			@ LI,091 PSAY &cMes05 / B1_CONV  Picture "@e 9,999,999.99"
			@ LI,104 PSAY &cMes04 / B1_CONV  Picture "@e 9,999,999.99"
			@ LI,117 PSAY &cMes03 / B1_CONV  Picture "@e 9,999,999.99"
			@ LI,130 PSAY &cMes02 / B1_CONV  Picture "@e 9,999,999.99"
			@ LI,143 PSAY &cMesAtu / B1_CONV Picture "@e 9,999,999.99"
			aTotal[2] += &cMes06 / B1_CONV
			aTotal[3] += &cMes05 / B1_CONV
			aTotal[4] += &cMes04 / B1_CONV
			aTotal[5] += &cMes03 / B1_CONV
			aTotal[6] += &cMes02 / B1_CONV
			aTotal[7] += &cMesAtu / B1_CONV
		Endif
		@ LI,156 PSAY TOTAL    Picture "@e 9,999,999.99"
		aTotal[8] += TOTAL
 		@ LI,171 PSAY RecNo()  Picture "@e 99,999"
		LI++
		dbSkip()
	Enddo

	dbSelectArea("TMP")
	dbCloseArea()

	if lImp
		Li++
		@ LI,000 PSAY "Total Geral"
		@ LI,065 PSAY aTotal[1] Picture "@e 9,999,999.99"
		@ LI,078 PSAY aTotal[2] Picture "@e 9,999,999.99"
		@ LI,091 PSAY aTotal[3] Picture "@e 9,999,999.99"
		@ LI,104 PSAY aTotal[4] Picture "@e 9,999,999.99"
		@ LI,117 PSAY aTotal[5] Picture "@e 9,999,999.99"
		@ LI,130 PSAY aTotal[6] Picture "@e 9,999,999.99"
		@ LI,143 PSAY aTotal[7] Picture "@e 9,999,999.99"
		@ LI,156 PSAY aTotal[8] Picture "@e 9,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
	   dbCommitAll()
	   OurSpool(wnrel)
	Endif
	MS_FLUSH()
	
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())
Return nil