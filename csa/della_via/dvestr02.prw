#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVESTR02
	Private cString        := "ZX0"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Itens em ponto de pedido"
	Private tamanho        := "G"
	Private nomeprog       := "DVESTR02"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "ESTR02"
	Private titulo         := "Itens em ponto de pedido"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVESTR02"
	Private lImp           := .F.
	Private aDescMes       := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}


	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Filial          ?"," "," ","mv_ch1","C", 02,0,0,"G",""           ,"mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SMO","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Filial       ?"," "," ","mv_ch2","C", 02,0,0,"G",""           ,"mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SM0","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Produto         ?"," "," ","mv_ch3","C", 15,0,0,"G",""           ,"mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate o Produto      ?"," "," ","mv_ch4","C", 15,0,0,"G",""           ,"mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"05","Do Grupo           ?"," "," ","mv_ch5","C", 04,0,0,"G",""           ,"mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate o Grupo        ?"," "," ","mv_ch6","C", 04,0,0,"G",""           ,"mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"07","Itens              ?"," "," ","mv_ch7","C", 03,0,0,"G","U_fSelABC()","mv_par07",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"08","Local              ?"," "," ","mv_ch8","C", 60,0,0,"G","U_fSelLoc()","mv_par08",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","",""          })


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
	Cabec1:="                                                           Curva                                               ______________Cosumos Médios___________       Consumo   Ponto de   Quantidade   Quantidade"
	Cabec2:="Código       Descrição                        Grupo   UM   ABC     Saldo Atual       Saldo CD   Saldo Matriz  |        AAA           BBB           CCC|      Mes DDD     Pedido   Por Embal.    a Comprar    Aberto"
	        *XXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXX    XX   X       999,999,999    999,999,999    999,999,999   999,999,999   999,999,999   999,999,999   999,999,999    999,999      999,999      999,999   _______________
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

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

	cSql := "SELECT X5_CHAVE,X5_DESCRI FROM "+RetSqlName("SX5")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += " AND   X5_TABELA = 'X0'"
	cSql += " ORDER BY X5_CHAVE"

	MsgRun("Consultando Param. Curva ABC ... ",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	dbSelectArea("ARQ_SQL")
	dbGoTop()
	aCurva  := {}
	nVal01 := 0
	nVal02 := 0
	nVal03 := 0
	nVal04 := 0
	Do While !eof()
		nIni := 1
		nTmh := Len(AllTrim(ARQ_SQL->X5_DESCRI))
		nPos := AT(";",AllTrim(ARQ_SQL->X5_DESCRI))
		nVal01 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

		nIni += nPos
		nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
		nVal02 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

		nIni += nPos
		nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
		nVal03 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

		nIni += nPos
		nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
		nVal04 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh-(nIni-1)))

		aadd(aCurva,{nVal01,nVal02,nVal03,nVal04})
		dbSkip()
	Enddo
	dbCloseArea()


	c3MSel  := ""
	a3MSel  := {}
	nMesAtu := Val(Substr(ZX0->ZX0_MES,5,2))
	For k=0 to 2
		If (nMesAtu-k) <= 0
			c3MSel += "ZX0_Q"+StrZero(12+(nMesAtu-k),2)+iif(k < 2,",","")
			aadd(a3MSel,"ZX0_Q"+StrZero(12+(nMesAtu-k),2))
			cabec2 := StrTran(cabec2,iif(k=0,"CCC",iif(k=1,"BBB","AAA")),aDescMes[12+(nMesAtu-k)])
		Else
			c3MSel += "ZX0_Q"+StrZero(nMesAtu-k,2)+iif(k < 2,",","")
			aadd(a3MSel,"ZX0_Q"+StrZero(nMesAtu-k,2))
			cabec2 := StrTran(cabec2,iif(k=0,"CCC",iif(k=1,"BBB","AAA")),aDescMes[nMesAtu-k])
		Endif
	Next k
	nMesAtu := iif((nMesAtu+1) > 12,1,nMesAtu+1)
	cabec2 := StrTran(cabec2,"DDD",aDescMes[nMesAtu])

	// Query
	cSql := "SELECT ZX0_FILIAL,ZX0_COD,ZX0_GRUPO,ZX0_CURVA"
	cSql += " ,     SUM(B2_QATU) AS SALDO"
	cSql += " ,     (SELECT SUM(B2_QATU) FROM "+RetSqlName("SB2")+" WHERE D_E_L_E_T_ = '' AND B2_FILIAL = '01' AND B2_COD = ZX0.ZX0_COD AND B2_LOCAL IN("+cFilLoc+")) AS SLDMTZ"
	cSql += " ,     "+c3MSel

	cSql += " ,     (SELECT SUM(B2_QATU)"
	cSql += "        FROM "+RetSqlName("SB2")+" SB2"
	cSql += "        JOIN "+RetSqlName("SX5")+" SX5"
	cSql += "        ON   SX5.D_E_L_E_T_ = ''"
	cSql += "        AND  X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += "        AND  X5_TABELA = 'ZX'"
	cSql += "        AND  X5_CHAVE = ZX0.ZX0_FILIAL"
	cSql += "        WHERE SB2.D_E_L_E_T_ = ''"
	cSql += "        AND B2_FILIAL = SUBSTR(X5_DESCRI,1,2)"
	cSql += "        AND B2_COD = ZX0.ZX0_COD
	cSql += "        AND B2_LOCAL IN("+cFilLoc+")) AS SLD_CD"

	cSql += " ,     ("
	cSql += "       SELECT SUM(D3_QUANT)"
	cSql += "       FROM "+RetSqlName("SD3")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND   D3_FILIAL = ZX0.ZX0_FILIAL"
	cSql += "       AND   D3_COD = ZX0.ZX0_COD"
	cSql += "       AND   SUBSTR(D3_EMISSAO,1,6) > ZX0.ZX0_MES"
	cSql += "       AND   SUBSTR(D3_CF,1,1) = 'R'"
	cSql += "       AND   D3_CF <> 'RE4') AS MOVSD3"

	cSql += " ,     ("
	cSql += "       SELECT SUM(C7_QUANT-C7_QUJE)"
	cSql += "       FROM "+RetSqlName("SC7")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND   C7_FILIAL = ZX0.ZX0_FILIAL"
	cSql += "       AND   C7_PRODUTO = ZX0.ZX0_COD"
	cSql += "       AND   C7_RESIDUO <> 'S'"
	cSql += "       AND   C7_QUJE < C7_QUANT) AS TRANSITO"

	cSql += " ,     ("
	cSql += "       SELECT  SUM(D2_QUANT)"
	cSql += "       FROM "+RetSqlName("SD2")+" SD2"
	cSql += "       JOIN "+RetSqlName("SF4")+" SF4"
	cSql += "       ON   SF4.D_E_L_E_T_ = ''"
	cSql += "       AND  F4_FILIAL = '"+xFilial("SF4")+"'"
	cSql += "       AND  F4_CODIGO = D2_TES"
	cSql += "       AND  F4_ESTOQUE = 'S'"
	cSql += "       WHERE SD2.D_E_L_E_T_ = ''"
	cSql += "       AND   D2_FILIAL = ZX0.ZX0_FILIAL"
	cSql += "       AND   D2_COD = ZX0.ZX0_COD"
	cSql += "       AND   D2_TIPO = 'N'"
	cSql += "       AND   D2_CF NOT IN('5152','6152','5409','6409')"
	cSql += "       AND   SUBSTR(D2_EMISSAO,1,6) > ZX0.ZX0_MES) AS MOVSD2"

	cSql += " FROM "+RetSqlName("ZX0")+" ZX0"

	cSql += " LEFT JOIN "+RetSqlName("SB2")+" SB2"
	cSql += " ON   SB2.D_E_L_E_T_ = ''"
	cSql += " AND  B2_FILIAL = ZX0_FILIAL"
	cSql += " AND  B2_COD = ZX0_COD"
	cSql += " AND  B2_LOCAL IN("+cFilLoc+")"

	cSql += " WHERE ZX0.D_E_L_E_T_ = ''"
	cSql += " AND   ZX0_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   ZX0_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   ZX0_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   ZX0_CURVA IN("+cFilABC+")"
	cSql += " GROUP BY ZX0_FILIAL,ZX0_COD,ZX0_GRUPO,ZX0_CURVA,"+c3MSel+",ZX0_MES"
	cSql += " ORDER BY ZX0_FILIAL,ZX0_CURVA,ZX0_GRUPO,ZX0_COD"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","SALDO"  ,"N",14,2)
	TcSetField("ARQ_SQL","SLDMTZ" ,"N",14,2)
	TcSetField("ARQ_SQL","SLD_CD" ,"N",14,2)

	For k=1 To Len(a3MSel)
		TcSetField("ARQ_SQL",a3MSel[k],"N",14,2)
	Next k

	TcSetField("ARQ_SQL","MOVSD3"  ,"N",14,2)
	TcSetField("ARQ_SQL","MOVSD2"  ,"N",14,2)
	TcSetField("ARQ_SQL","TRANSITO","N",14,2)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	cTitulo_Ori := AllTrim(Titulo)
	Do While !eof()
		cFil := ZX0_FILIAL
		Titulo := cTitulo_Ori + " - Filial "+cFil+" - "+NomeLJ(SM0->M0_CODIGO,cFil)
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI+=2

		Do While !eof() .AND. ZX0_FILIAL = cFil
			IncProc("Imprimindo ...")
			If lAbortPrint
				LI+=3
				@ LI,001 PSAY "*** Cancelado pelo Operador ***"
				lImp := .F.
				exit
			Endif

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("SB1")+ARQ_SQL->ZX0_COD)

			nQEmb := iif(B1_QE > 0,B1_QE,1)

			dbSelectArea("ARQ_SQL")
			if SB1->B1_MSBLQL = "1"
				dbSkip()
				Loop
			Endif

			/*
			dbSelectArea("SBZ")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(ARQ_SQL->(ZX0_FILIAL+ZX0_COD))
			If !Found()
				nQEmb := 1
			Else
				nQEmb := iif(BZ_QE > 0,BZ_QE,1)
			Endif
			*/

			dbSelectArea("SBM")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("SBM")+SB1->B1_GRUPO)
			dbSelectArea("ARQ_SQL")

			nPP := 0
			For k=1 to Len(a3MSel)
				cNomeCpo := a3MSel[k]
				nPP += &cNomeCpo
			Next k

			nPP := (((nPP)/3)/30)*aCurva[Asc(ZX0_CURVA)-64,iif(SBM->BM_TIPOPRD="P",4,2)]
			nNN := nPP - SALDO
			nCompra := 0
			nMult   := 1
			Do While nCompra < nNN
				nCompra := nQEmb*nMult
				nMult ++
			Enddo		

			If nCompra <= 0
				dbSkip()
				Loop
			Endif

			if (nPP - Int(nPP)) > 0
				nPP++
			Endif

			lImp:=.t.
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif

			@ LI,000 PSAY Substr(ZX0_COD,1,10)
			@ LI,013 PSAY SB1->B1_DESC
			@ LI,046 PSAY ZX0_GRUPO
			@ LI,054 PSAY SB1->B1_UM
			@ LI,059 PSAY ZX0_CURVA
			@ LI,067 PSAY SALDO Picture "@e 999,999,999"
			@ LI,082 PSAY SLD_CD Picture "@e 999,999,999"
			@ LI,097 PSAY SLDMTZ Picture "@e 999,999,999"
			nCol := 111
			For k=Len(a3MSel) to 1 step -1
				cNomeCpo := a3MSel[k]
				@ LI,nCol PSAY &cNomeCpo Picture "@e 999,999,999"
				nCol += 14
			Next
			@ LI,153 PSAY MOVSD3+MOVSD2 Picture "@e 999,999,999"
			@ LI,168 PSAY nPP Picture "@e 999,999"
			@ LI,181 PSAY nQEmb Picture "@e 999,999"
			@ LI,194 PSAY nCompra Picture "@e 999,999"
			//@ LI,204 PSAY Replicate("_",15)
			@ LI,204 PSAY TRANSITO Picture "@e 999,999"
			LI++
			dbSkip()
		Enddo
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

Static Function NomeLJ(cEmpPar,cFilPar)
	Local aArea    := GetArea()
	Local cNomeFil := ""

	cSql := "SELECT LJ_NOME FROM "+RetSqlName("SLJ")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   LJ_FILIAL = '"+xFilial("SLJ")+"'"
	cSql += " AND   LJ_RPCEMP = '"+cEmpPar+"'"
	cSql += " AND   LJ_RPCFIL = '"+cFilPar+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LOJ", .T., .T.)
	dbSelectArea("SQL_LOJ")
	cNomeFil := LJ_NOME
	dbCloseArea()
	RestArea(aArea)
Return cNomeFil