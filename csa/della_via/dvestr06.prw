#include "rwmake.ch"
#include "topconn.ch"

User Function DVESTR06
	Private cString        := "SB9"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Inconsistencias de estoque"
	Private tamanho        := "P"
	Private nomeprog       := "DVESTR06"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "ESTR06"
	Private titulo         := "Inconsistencias de estoque"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVESTR06"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Filial          ?"," "," ","mv_ch1","C", 02,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Filial       ?"," "," ","mv_ch2","C", 02,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Data Fechamento    ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })


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
	Cabec1:=" "
	Cabec2:=" Filial   Codigo            Descrição                        Local   Data"
	        * XX       XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XX      99/99/99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cSql := "SELECT DISTINCT B2_FILIAL"
	cSql += " FROM "+RetSqlName("SB2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   B2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " ORDER BY B2_FILIAL"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	aFil_Est := {}

	Do While !eof()
		IncProc("Filial "+B2_FILIAL)
		aAdd(aFil_Est,B2_FILIAL)

		cSql := "SELECT '01' AS CHAVE"
		cSql += " ,     B2_FILIAL AS FILIAL"
		cSql += " ,     B2_COD AS COD"
		cSql += " ,     B1_DESC AS DESC"
		cSql += " ,     B2_LOCAL AS LOCAL"
		cSql += " ,     '' AS DATA"
		cSql += " FROM "+RetSqlName("SB2")+" SB2"
		cSql += " LEFT JOIN "+RetSqlName("SB1")+" SB1"
		cSql += " ON   SB1.D_E_L_E_T_ = ''"
		cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
		cSql += " AND  B1_COD = B2_COD"
		cSql += " WHERE SB2.D_E_L_E_T_ = ''"
		cSql += " AND   B2_FILIAL = '"+B2_FILIAL+"'"
		cSql += " AND   (B2_COD = '' OR B2_LOCAL = '')"

		cSql += " UNION ALL"

		cSql += " SELECT '02' AS CHAVE"
		cSql += " ,      B9_FILIAL AS FILIAL"
		cSql += " ,      B9_COD AS COD"
		cSql += " ,      B1_DESC AS DESC"
		cSql += " ,      B9_LOCAL AS LOCAL"
		cSql += " ,      B9_DATA AS DATA"
		cSql += " FROM "+RetSqlName("SB9")+" SB9"
		cSql += " LEFT JOIN "+RetSqlName("SB1")+" SB1"
		cSql += " ON   SB1.D_E_L_E_T_ = ''"
		cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
		cSql += " AND  B1_COD = B9_COD"
		cSql += " WHERE SB9.D_E_L_E_T_ = ''"
		cSql += " AND   B9_FILIAL = '"+B2_FILIAL+"'"
		cSql += " AND   (B9_COD = '' OR B9_LOCAL = '')"

		cSql += " ORDER BY CHAVE,FILIAL,COD,LOCAL"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_EST", .T., .T.)
		TcSetField("SQL_EST","DATA","D")
        dbSelectArea("SQL_EST")
		Do While !eof()
			IncProc("Filial "+FILIAL)
			lImp:=.t.
			Cabec1 := iif(CHAVE="01","Inconsistencias nos Saldos (SB2)","Inconsistencias nos Saldos Iniciais (SB9)")

			if li>55 .OR. xChave <> CHAVE
				xChave := CHAVE
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
	
			@ LI,001 PSAY FILIAL
			@ LI,010 PSAY COD
			@ LI,028 PSAY DESC
			@ LI,061 PSAY LOCAL
			@ LI,069 PSAY DATA
			LI++
			dbSkip()
		Enddo
		dbCloseArea("SQL_EST")
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	LI := 99
	Cabec1 := "Ausencia de Saldos Iniciais (SB9)"

	For k=1 to Len(aFil_Est)
		incProc("Filial "+aFil_Est[k])
		dbSelectArea("SX6")
		dbSetOrder(1)
		dbSeek(aFil_Est[k]+"MV_ULMES")
		if Found()
			dUlMes := stod(X6_CONTEUD)
		Else
			dUlMes := ctod("//")
		Endif

		cSql := "SELECT B9_FILIAL AS FILIAL"
		cSql += " ,     B9_COD AS COD"
		cSql += " ,     B1_DESC AS DESC"
		cSql += " ,     B9_LOCAL AS LOCAL"
		cSql += " ,     B9_DATA AS DATA"
		cSql += " ,     B9_QINI AS INICIAL"
		cSql += " FROM "+RetSqlName("SB9")+" SB9"

		cSql += " LEFT JOIN "+RetSqlName("SB1")+" SB1"
		cSql += " ON   SB1.D_E_L_E_T_ = ''"
		cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
		cSql += " AND  B1_COD = B9_COD"

		cSql += " WHERE SB9.D_E_L_E_T_ = ''"
		cSql += " AND   B9_FILIAL = '"+aFil_Est[k]+"'"
		cSql += " AND   B9_COD <> ''"
		cSql += " AND   B9_LOCAL IN('01','02','03')"
		cSql += " ORDER BY FILIAL,COD,LOCAL,DATA"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		TcSetField("ARQ_SQL","DATA"   ,"D")
		TcSetField("ARQ_SQL","INICIAL","N",14,2)


		Do While !eof()
			xChave     := FILIAL+COD+LOCAL
			cDesc      := DESC
			dData_Ant  := ctod("//")
			lUlt_Mes   := .F.
			nUlt_Mes   := 0
			Do While !eof() .and. FILIAL+COD+LOCAL = xChave
				if DATA = dUlMes
					lUlt_Mes := .T.
					nUlt_Mes := INICIAL
				Endif
				If dData_Ant <> ctod("//") .AND. (DATA - dData_Ant) > 31 .AND. DATA >= mv_par03
					For j=1 to 2
						if li>55
							LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
							LI+=2
						endif

						@ LI,001 PSAY FILIAL
						@ LI,010 PSAY COD
						@ LI,028 PSAY DESC
						@ LI,061 PSAY LOCAL
						@ LI,069 PSAY iif(j=1,dData_Ant,DATA)
						LI+=j
					Next j
				Endif

				dData_Ant := DATA
				dbSkip()
			Enddo

			if !lUlt_Mes
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
					LI+=2
				endif
				@ LI,001 PSAY "*** Faltou Ultimo Fechamento"
				LI++
				@ LI,001 PSAY Substr(xChave,1,2)
				@ LI,010 PSAY Substr(xChave,3,15)
				@ LI,028 PSAY cDesc
				@ LI,061 PSAY Substr(xChave,18,2)
				@ LI,069 PSAY dUlMes
				LI+=2
			Elseif nUlt_Mes < 0
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
					LI+=2
				endif
				@ LI,001 PSAY "*** Ultimo Fechamento <<< N E G A T I V O >>> [ "+AllTrim(TransForm(nUlt_Mes,"@e 99,999,999,999.99"))+" ]"
				LI++
				@ LI,001 PSAY Substr(xChave,1,2)
				@ LI,010 PSAY Substr(xChave,3,15)
				@ LI,028 PSAY cDesc
				@ LI,061 PSAY Substr(xChave,18,2)
				@ LI,069 PSAY dUlMes
				LI+=2
			Endif
		Enddo
		dbCloseArea()
	Next k

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil