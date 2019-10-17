#Include "DellaVia.ch"

User Function DESTR19()
	Local   aPergunta    := {}
	Private cString      := "SC2"
	Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2       := "de acordo com os parametros informados pelo usuario."
	Private cDesc3       := "Resumo Carcaca Producao"
	Private cPict        := ""
	Private Titulo       := "Resumo Carcaca Producao"
	Private nLin         := 80
	Private Cabec1       := " Carcaca         Desenho         Largura   Kg Total         Pneus"
	Private Cabec2       := ""
	Private imprime      := .T.
	Private aOrd         := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "P"
	Private nomeprog     := "DESTR19"
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "ESTR19"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "DESTR19"

	AAdd(aPergunta,{cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

	ValidPerg(aPergunta,cPerg)
	Pergunte(cPerg,.F.)

	// Monta inferface com usuário	
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local cSql     := ""
	Local nTotPneu := 0
	Local nTotProd := 0

	cSql := "SELECT C2_PRODUTO"
	cSql += " ,     C2_X_DESEN"
	cSql += " ,     B1_XLARG"
	cSql += " ,     SUM(D3_QUANT) D3_QUANT"
	cSql += " ,     SUM(C2_QUANT) AS PNEUS"
	cSql += " FROM "+RetSqlName("SD3")+" SD3"

	cSql += " JOIN "+RetSqlName("SC2")+" SC2"
	cSql += " ON   SC2.D_E_L_E_T_ = ''"
	cSql += " AND  C2_FILIAL = D3_FILIAL"
	cSql += " AND  C2_NUM = SUBSTR(D3_OP,1,6)"
	cSql += " AND  C2_ITEM = SUBSTR(D3_OP,7,2)"
	cSql += " AND  C2_SEQUEN = SUBSTR(D3_OP,9,3)"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D3_COD"
	cSql += " AND  B1_GRUPO = 'BAND'"

	cSql += " WHERE SD3.D_E_L_E_T_ = ''"
	cSql += " AND   D3_FILIAL = '"+xFilial("SD3")+"'"
	cSql += " AND   D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   D3_ESTORNO <> 'S'"
	cSql += " GROUP BY C2_PRODUTO,C2_X_DESEN,B1_XLARG"
	cSql += " ORDER BY C2_PRODUTO,C2_X_DESEN,B1_XLARG"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TRB",.F.,.T.)
 
	dbSelectArea("TRB")
	dbGotop()

	SetRegua(0)
	cCod := ""
	lPaginaNova := .F.
	Do While !EOF()
		IncRegua()

		If nLin > 55
			nLin:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			nLin:=nLin+2
			lPaginaNova := .T.
		Endif
	
		if TRB->C2_PRODUTO <> cCod
			If !lPaginaNova
				nLin ++
			Endif
		    @ nLin,001 PSAY TRB->C2_PRODUTO
		    cCod := TRB->C2_PRODUTO
		Endif
		lPaginaNova := .F.
	    @ nLin,017 PSAY TRB->C2_X_DESEN
	    @ nLin,033 PSAY TRB->B1_XLARG Picture "@E 999,999"
	    @ nLin,041 PSAY TRB->D3_QUANT Picture "@E 99,999,999"
	    @ nLin,055 PSAY TRB->PNEUS    Picture "@E 99,999,999"
	    
		nTotPneu += TRB->D3_QUANT
		nTotProd += TRB->PNEUS
		nLin ++

		dbSkip()
	EndDo
	dbCloseArea()

	If nTotPneu > 0
		nLin++
		@ nLin,001 PSAY "TOTAL "
		@ nLin,041 PSAY nTotPneu Picture "@E 99,999,999"
		@ nLin,055 PSAY nTotProd Picture "@E 99,999,999"
		roda(0,"",Tamanho)
	Endif	

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()
Return