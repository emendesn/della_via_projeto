#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVLOJR04
	Private cString        := "ZX4"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Conferencia de meta"
	Private tamanho        := "G"
	Private nomeprog       := "DVLOJR04"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DLOJR4"
	Private titulo         := "Conferencia de meta"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVLOJR04"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Filial      ","","","mv_ch1","C",02,0,0,"G",""            ,"mv_par01",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","   ","","","","",""})
	aAdd(aRegs,{cPerg,"02","Até a Filial   ","","","mv_ch2","C",02,0,0,"G",""            ,"mv_par02",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","   ","","","","",""})
	aAdd(aRegs,{cPerg,"03","(AAAAMM) De    ","","","mv_ch3","C",06,0,0,"G",""            ,"mv_par03",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","   ","","","","",""})
	aAdd(aRegs,{cPerg,"04","(AAAAMM) Ate   ","","","mv_ch4","C",06,0,0,"G",""            ,"mv_par04",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","   ","","","","",""})
	aAdd(aRegs,{cPerg,"05","Do Vendedor    ","","","mv_ch5","C",06,0,0,"G",""            ,"mv_par05",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SA3","","","","",""})
	aAdd(aRegs,{cPerg,"06","Até o Vendedor ","","","mv_ch6","C",06,0,0,"G",""            ,"mv_par06",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SA3","","","","",""})
	aAdd(aRegs,{cPerg,"07","Tipo de venda  ","","","mv_ch7","C",10,0,0,"G","U_fTipVend()","mv_par07",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"","","","",""})

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
	Cabec1:="LJ   (AAAAMM)   Area Neg.   Vendedor   Nome                   Despir   Descrição                           Qtd Pirelli   Agrupamento   Descrição                            Quantidade             VAT"
	        *XX   XXXXXX     X           XXXXXX     XXXXXXXXXXXXXXXXXXXX   XXX      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999   XXXXXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999   9,999,999,999
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22


	cFilTipV  := ""
	For jj=1 to Len(AllTrim(mv_par07))
		If Substr(mv_par07,jj,1) <> "*"
			cFilTipV := cFilTipV + "'"+Substr(mv_par07,jj,1)+"',"
		Endif
	Next jj
	If Len(cFilTipV) > 0
		cFilTipV := substr(cFilTipV,1,Len(cFilTipV)-1)
	Endif

	// Query
	cSql := "SELECT  ZX4.*,A3_NREDUZ,ZH_DESC,X5_DESCRI"
	cSql += " FROM "+RetSqlName("ZX4")+" ZX4"

	cSql += " JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
	cSql += " AND  A3_COD = ZX4_VEND"

	cSql += " LEFT JOIN "+RetSqlName("SZH")+" SZH"
	cSql += " ON   SZH.D_E_L_E_T_ = ''"
	cSql += " AND  ZH_FILIAL = '"+xFilial("SZH")+"'"
	cSql += " AND  ZH_CODAGRU = ZX4_CODAGR"

	cSql += " LEFT JOIN "+RetSqlName("SX5")+" SX5"
	cSql += " ON   SX5.D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = ''"
	cSql += " AND  X5_TABELA = 'Z6'"
	cSql += " AND  X5_CHAVE = ZX4_DESPIR"

	cSql += " WHERE ZX4.D_E_L_E_T_  = ''"
	cSql += " AND   ZX4_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   ZX4_ANOMES BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   ZX4_VEND BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   ZX4_AREANE IN("+cFilTipV+")"
	cSql += " ORDER BY ZX4_FILIAL,ZX4_VEND"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","ZX4_OBJCAR","N",11,0)
	TcSetField("ARQ_SQL","ZX4_QTD"   ,"N",11,0)
	TcSetField("ARQ_SQL","ZX4_QTDPIR","N",11,0)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbGoTop()
	aTotGer := {0,0,0}

	Do While !eof()
		cChave := ZX4_FILIAL
		aTotal  := {0,0,0}
		
		Do While !eof() .AND. ZX4_FILIAL = cChave
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

			@ LI,000 PSAY ZX4_FILIAL
			@ LI,005 PSAY ZX4_ANOMES
			@ LI,016 PSAY ZX4_AREANE
			@ LI,028 PSAY ZX4_VEND
			@ LI,039 PSAY Upper(Substr(A3_NREDUZ,1,20))
			@ LI,062 PSAY ZX4_DESPIR
			@ LI,071 PSAY Substr(X5_DESCRI,1,30)
			@ LI,104 PSAY ZX4_QTDPIR Picture "@e 99,999,999,999"
			@ LI,121 PSAY ZX4_CODAGRU
			@ LI,135 PSAY Substr(ZH_DESC,1,30)
			@ LI,168 PSAY ZX4_QTD    Picture "@e 99,999,999,999"
			@ LI,185 PSAY ZX4_OBJCAR Picture "@e 9,999,999,999"
			LI++
			
			aTotal[1] += ZX4_QTDPIR
			aTotal[2] += ZX4_QTD
			aTotal[3] += ZX4_OBJCAR

			aTotGer[1] += ZX4_QTDPIR
			aTotGer[2] += ZX4_QTD
			aTotGer[3] += ZX4_OBJCAR
			
			dbSkip()
		Enddo

		LI++
		@ LI,000 PSAY "Total da Filial"
		@ LI,104 PSAY aTotal[1] Picture "@e 99,999,999,999"
		@ LI,168 PSAY aTotal[2] Picture "@e 99,999,999,999"
		@ LI,185 PSAY aTotal[3] Picture "@e 9,999,999,999"
		LI+=2
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		LI++
		@ LI,000 PSAY "Total da Geral"
		@ LI,104 PSAY aTotGer[1] Picture "@e 99,999,999,999"
		@ LI,168 PSAY aTotGer[2] Picture "@e 99,999,999,999"
		@ LI,185 PSAY aTotGer[3] Picture "@e 9,999,999,999"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil