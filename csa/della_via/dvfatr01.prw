#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVFATR01
	Private cString        := "SA1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Validade de crédito"
	Private tamanho        := "P"
	Private nomeprog       := "DVFATR01"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR01"
	Private titulo         := "Validade de crédito"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVFATR01"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Do Vendedor        ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""       ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate o Vendedor     ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"03","Dias a vencer      ?"," "," ","mv_ch3","N", 03,0,0,"G","","mv_par03",""       ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","","999"       })
	aAdd(aRegs,{cPerg,"04","Compra Ultimos dias?"," "," ","mv_ch4","N", 03,0,0,"G","","mv_par04",""       ,"","","","",""        ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","","999"       })
	aAdd(aRegs,{cPerg,"05","Pessoa             ?"," "," ","mv_ch5","N", 01,0,0,"C","","mv_par05","Todas"  ,"","","","","Juridica","","","","","Fisica" ,"","","","","","","","","","","","","","   ","","","",""          })


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
	Cabec1:="                                                  Vencto     Ultima     Limite de"
	Cabec2:="     Cliente                                      Lim.Cred   Compra       Crédito"
	        *     XXXXXX-XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99   99/99/99  999,999.99
    	    *012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8

	// Query
	cSql := ""
	cSql := "SELECT A1_VEND,A1_SATIV1,X5_DESCRI,A1_COD,A1_LOJA,A1_NOME,A1_VENCLC,A1_ULTCOM,A1_LC,A1_PESSOA"
	cSql += " FROM "+RetSqlName("SA1")+" SA1"

	cSql += " LEFT JOIN "+RetSqlName("SX5")+" SX5"
	cSql += " ON   SX5.D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += " AND  X5_TABELA = 'T3'"
	cSql += " AND  X5_CHAVE = A1_SATIV1"

	cSql += " WHERE SA1.D_E_L_E_T_ = ''"
	cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND   A1_VENCLC <> ''"
	cSql += " AND   A1_VENCLC <= '"+dtos(dDataBase+mv_par03)+"'"
	cSql += " AND   A1_ULTCOM >= '"+dtos(dDataBase-mv_par04)+"'"
	cSql += " ORDER BY A1_VEND,A1_SATIV1,A1_VENCLC,A1_COD,A1_LOJA"

	MsgRun("Consultando, isto pode levar alguns minutos, aguarde ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","A1_VENCLC","D")
	TcSetField("ARQ_SQL","A1_ULTCOM","D")
	TcSetField("ARQ_SQL","A1_LC","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
		If A1_VEND < mv_par01 .OR. A1_VEND > mv_par02
			dbSkip()
			Loop
		Endif

		If mv_par05 = 2 .AND. A1_PESSOA = "F"
			dbskip()
			Loop
		Elseif mv_par05 = 3 .AND. A1_PESSOA <> "F"
			dbskip()
			Loop
		Endif

		cVend := A1_VEND
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SA3")+cVend)
		dbSelectArea("ARQ_SQL")
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI++
		@ LI,000 PSAY "Vendedor: "+A1_VEND+" - "+SA3->A3_NOME
		LI++

		Do While !eof() .and. A1_VEND = cVend
			If mv_par05 = 2 .AND. A1_PESSOA = "F"
				dbskip()
				Loop
			Elseif mv_par05 = 3 .AND. A1_PESSOA <> "F"
				dbskip()
				Loop
			Endif

			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI++
			endif

			cSegmen := A1_SATIV1
			LI++
			@ LI,003 PSAY "Segmento: "+A1_SATIV1+" - "+X5_DESCRI
			LI++

			Do While !eof() .and. A1_VEND = cVend .and. A1_SATIV1 = cSegmen
				IncProc("Imprimindo ...")
				If lAbortPrint
					LI+=3
					@ LI,001 PSAY "*** Cancelado pelo Operador ***"
					lImp := .F.
					exit
				Endif

				If mv_par05 = 2 .AND. A1_PESSOA = "F"
					dbskip()
					Loop
				Elseif mv_par05 = 3 .AND. A1_PESSOA <> "F"
					dbskip()
					Loop
				Endif


				lImp:=.t.
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
					LI++
				endif
	
				@ LI,005 PSAY A1_COD+" - "+A1_LOJA
				@ LI,017 PSAY Substr(A1_NOME,1,30)
				@ LI,050 PSAY A1_VENCLC
				@ LI,061 PSAY A1_ULTCOM
				@ LI,071 PSAY A1_LC Picture "@e 999,999.99"
				LI++
				dbSkip()
			Enddo
		Enddo
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