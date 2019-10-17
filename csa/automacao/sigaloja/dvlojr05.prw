#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVLOJR05
	Private cString        := "ZX4"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Conferencia de meta por regional"
	Private tamanho        := "G"
	Private nomeprog       := "DVLOJR05"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DLOJR5"
	Private titulo         := "Conferencia de meta por regional"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVLOJR05"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","(AAAAMM) De    ","","","mv_ch1","C",06,0,0,"G",""            ,"mv_par01",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","   ","","","","",""})
	aAdd(aRegs,{cPerg,"02","(AAAAMM) Ate   ","","","mv_ch2","C",06,0,0,"G",""            ,"mv_par02",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","   ","","","","",""})
	aAdd(aRegs,{cPerg,"03","Da Regional    ","","","mv_ch3","C",02,0,0,"G",""            ,"mv_par03",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","PB9","","","","",""})
	aAdd(aRegs,{cPerg,"04","Até a Regional ","","","mv_ch4","C",02,0,0,"G",""            ,"mv_par04",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","PB9","","","","",""})
	aAdd(aRegs,{cPerg,"05","Tipo de venda  ","","","mv_c57","C",10,0,0,"G","U_fTipVend()","mv_par05",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"","","","",""})

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
	Cabec1:="     (AAAAMM)   Area Neg.   Regional   Descricao              Despir   Descrição                           Qtd Pirelli   Agrupamento   Descrição                            Quantidade"
	        *     XXXXXX     X           XXXXXX     XXXXXXXXXXXXXXXXXXXX   XXX      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999   XXXXXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22


	cFilTipV  := ""
	For jj=1 to Len(AllTrim(mv_par05))
		If Substr(mv_par05,jj,1) <> "*"
			cFilTipV := cFilTipV + "'"+Substr(mv_par05,jj,1)+"',"
		Endif
	Next jj
	If Len(cFilTipV) > 0
		cFilTipV := substr(cFilTipV,1,Len(cFilTipV)-1)
	Endif

	// Query
	cSql := "SELECT ZX4_ANOMES"
	cSql += " ,     ZX4_AREANE"
	cSql += " ,      A3_REGIAO"
	cSql += " ,      PB9_DESCR"
	cSql += " ,      ZX4_DESPIR"
	cSql += " ,      X5_DESCRI"
	cSql += " ,      SUM(ZX4_QTDPIR) AS QTDPIR"
	cSql += " ,      ZX4_CODAGR"
	cSql += " ,      ZH_DESC"
	cSql += " ,      SUM(ZX4_QTD) AS QTD"
	cSql += " FROM   "+RetSqlName("ZX4")+" ZX4"

	cSql += " JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
	cSql += " AND  A3_COD = ZX4_VEND"
	cSql += " AND  A3_REGIAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

	cSql += " LEFT JOIN "+RetSqlName("SZH")+" SZH"
	cSql += " ON   SZH.D_E_L_E_T_ = ''"
	cSql += " AND  ZH_FILIAL = '"+xFilial("SZH")+"'"
	cSql += " AND  ZH_CODAGRU = ZX4_CODAGR"

	cSql += " LEFT JOIN "+RetSqlName("SX5")+" SX5"
	cSql += " ON   SX5.D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = ''"
	cSql += " AND  X5_TABELA = 'Z6'"
	cSql += " AND  X5_CHAVE = ZX4_DESPIR"

	cSql += " LEFT JOIN "+RetSqlName("PB9")+" PB9"
	cSql += " ON   PB9.D_E_L_E_T_ = ''"
	cSql += " AND  PB9_FILIAL = '"+xFilial("PB9")+"'"
	cSql += " AND  PB9_CODIGO = A3_REGIAO"

	cSql += " WHERE ZX4.D_E_L_E_T_ = ''"
	cSql += " AND   ZX4_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   ZX4_ANOMES BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   ZX4_AREANE IN("+cFilTipV+")"
	cSql += " GROUP BY ZX4_ANOMES,ZX4_AREANE,A3_REGIAO,PB9_DESCR,ZX4_DESPIR,X5_DESCRI,ZX4_CODAGR,ZH_DESC"
	cSql += " ORDER BY A3_REGIAO,ZX4_ANOMES,ZX4_AREANE"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","QTD"   ,"N",11,0)
	TcSetField("ARQ_SQL","QTDPIR","N",11,0)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbGoTop()
	aTotGer := {0,0,0}

	Do While !eof()
		cChave := A3_REGIAO
		
		Do While !eof() .AND. A3_REGIAO = cChave
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

			@ LI,005 PSAY ZX4_ANOMES
			@ LI,016 PSAY ZX4_AREANE
			@ LI,028 PSAY A3_REGIAO
			@ LI,039 PSAY Upper(Substr(PB9_DESCR,1,20))
			@ LI,062 PSAY ZX4_DESPIR
			@ LI,071 PSAY Substr(X5_DESCRI,1,30)
			@ LI,104 PSAY QTDPIR Picture "@e 99,999,999,999"
			@ LI,121 PSAY ZX4_CODAGRU
			@ LI,135 PSAY Substr(ZH_DESC,1,30)
			@ LI,168 PSAY QTD    Picture "@e 99,999,999,999"
			LI++
			dbSkip()
		Enddo
		LI+=2
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