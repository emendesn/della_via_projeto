#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESTR11     º Autor ³ Jader            º Data ³  27/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio diario de produto x banda                        º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DESTR11()
	LOCAL cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	LOCAL cDesc2         := "de acordo com os parametros informados pelo usuario."
	LOCAL cDesc3         := "Resumo Diario de Produto x Banda"
	LOCAL cPict          := ""
	LOCAL titulo         := "Resumo Diario de Produto x Banda"
	LOCAL nLin           := 80
	LOCAL Cabec1         := "cabec1"
	LOCAL Cabec2         := "cabec2"
	LOCAL imprime        := .T.
	LOCAL aOrd           := {}
	LOCAL aPergunta      := {}
	PRIVATE lEnd         := .F.
	PRIVATE lAbortPrint  := .F.
	PRIVATE CbTxt        := ""
	PRIVATE limite       := 132
	PRIVATE tamanho      := "M"
	PRIVATE nomeprog     := "DESTR11"
	PRIVATE nTipo        := 15
	PRIVATE aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	PRIVATE nLastKey     := 0
	PRIVATE cPerg        := "ESTR11"
	PRIVATE cbtxt        := Space(10)
	PRIVATE cbcont       := 00
	PRIVATE CONTFL       := 01
	PRIVATE m_pag        := 01
	PRIVATE wnrel        := "DESTR11"
	PRIVATE cString      := "SC2"
	Private cSql         := ""

	dbSelectArea("SC2")
	dbSetOrder(1)

	// mv_par01 Lista Por ? Produto / Produto x Cliente
	// mv_par02 Da Data ?
	// mv_par02 Ate Data ?
	AAdd(aPergunta,{cPerg,"01","Lista Por?"        ,"Lista Por"      ,"Lista Por"     ,"mv_ch1","N", 1,0,0,"C","","mv_par01","Produto",""   ,""   ,"","","Prod x Cliente","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"02","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"03","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch3","D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})

	ValidPerg(aPergunta,cPerg)

	Pergunte(cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Jader              º Data ³  27/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION RunReport(Cabec1,Cabec2,Titulo,nLin)
	LOCAL nOrdem
	LOCAL cQuery   := ''
	LOCAL nTotPneu := 0
	LOCAL nTotPeso := 0
	LOCAL lQuebra  := .T.
	LOCAL cQuebra  := ''
	LOCAL nCount   := 0

	SetRegua(0)

	/*
	_aEstrutura := {}

	aAdd(_aEstrutura,{"TMP_CODPRO"  ,"C",TamSX3("B1_COD")[1]  ,TamSX3("B1_COD")[2]  })
	aAdd(_aEstrutura,{"TMP_DESC"    ,"C",TamSX3("B1_DESC")[1] ,TamSX3("B1_DESC")[2] })
	aAdd(_aEstrutura,{"TMP_NOME"    ,"C",TamSX3("A1_NOME")[1] ,TamSX3("A1_NOME")[2] })
	aAdd(_aEstrutura,{"TMP_SUBT"    ,"N",4                    ,0                    })
	aAdd(_aEstrutura,{"TMP_QUANT"   ,"N",TamSX3("C2_QUANT")[1],TamSX3("C2_QUANT")[2]})
	aAdd(_aEstrutura,{"TMP_PESO"    ,"N",TamSX3("D3_QUANT")[1],TamSX3("D3_QUANT")[2]})

	cNomArq := CriaTrab(_aEstrutura,.T.)
	dbUseArea(.T.,,cNomArq,"TMP")
	IndRegua("TMP",cNomArq,"Descend(Strzero(TMP->TMP_SUBT,11,2))",,,"Selecionando Registros")
	dbSelectArea("TMP")

	GeraTRB()
	*/

	cSql := "SELECT D3_X_PROD     AS TMP_CODPRO
	cSql += "      ,SB1.B1_DESC   AS TMP_DESC"
	cSql += "      ,C2_PRODUTO    AS TMP_MEDIDA"
	cSql += "      ,B1.B1_DESC    AS TMP_DESMED"
	cSql += "      ,Sum(C2_QUANT) AS TMP_QUANT"
	cSql += "      ,Sum(D3_QUANT) AS TMP_PESO"
	if mv_par01 = 2
		cSql += "      ,C2_XNREDUZ  AS TMP_NOME" 
	Endif
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
	cSql += " AND  B1_COD = D3_X_PROD"
	cSql += " AND  B1_GRUPO = 'BAND'"

	cSql += " JOIN "+RetSqlName("SB1")+" B1"
	cSql += " ON   B1.D_E_L_E_T_ = '"+xFilial("SB1")+"'"
	cSql += " AND  B1.B1_FILIAL = ''"
	cSql += " AND  B1.B1_COD = C2_PRODUTO"

	cSql += " WHERE SD3.D_E_L_E_T_ = ''"
	cSql += " AND   D3_FILIAL = '"+xFilial("SD3")+"'"
	cSql += " AND   D3_EMISSAO BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'"
	cSql += " AND   D3_ESTORNO <> 'S'"
	if mv_par01 = 1
		cSql += " GROUP BY D3_X_PROD,SB1.B1_DESC,C2_PRODUTO,B1.B1_DESC"
		cSql += " ORDER BY D3_X_PROD,C2_PRODUTO"
	Else
		cSql += " GROUP BY D3_X_PROD,SB1.B1_DESC,C2_XNREDUZ,C2_PRODUTO,B1.B1_DESC"
		cSql += " ORDER BY D3_X_PROD,C2_XNREDUZ,C2_PRODUTO"
	Endif

	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"TMP",.F.,.T.)
	TcSetField("TMP","TMP_QUANT","N",14,2)
	TcSetField("TMP","TMP_PESO","N",14,2)

	dbSelectArea("TMP")
	dbGotop()

	If Mv_Par01 == 1                        
		Titulo  := "Resumo Diario Produto x Banda"
		Cabec1  := ' Codigo          Produto                        Medida                                  Pneus           Peso'
		Cabec2  := ' '
		//           123456789012345 123456789012345678901234567890 123456789012345678901234567890 999,999,999.99 999,999,999.99
		//          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		//                   1         2         3         4         5         6         7         8         9        10        11        12        13
	ElseIf Mv_Par01 == 2
		Titulo  := "Resumo Diario Produto x Banda Cliente"
		Cabec1  := ' Codigo          Produto                        Cliente              Medida                                  Pneus           Peso'
		Cabec2  := ' '
		//           123456789012345 123456789012345678901234567890 12345678901234567890 123456789012345678901234567890 999,999,999.99 999,999,999.99
		//          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		//                   1         2         3         4         5         6         7         8         9        10        11        12        13
	EndIf   

	nSubPneu  := 0
	nSubPeso  := 0

	nTotPneu := 0
	nTotPeso := 0
	nCount   := 0
    
	cChave := ""
	While !EOF()
		IncRegua()

		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If mv_par01 == 1
			If cChave <> TMP->TMP_CODPRO
				cChave := TMP->TMP_CODPRO
			    @ nLin,001 PSAY TMP->TMP_CODPRO
			    @ nLin,017 PSAY TMP->TMP_DESC
			Endif
			@ nLin,049 psay TMP->TMP_DESMED
		    @ nLin,080 PSAY TMP->TMP_QUANT Picture "@E 99,999,999,999"
		    @ nLin,095 PSAY TMP->TMP_PESO  Picture "@E 999,999,999.99"
		ElseIf mv_par01 == 2
			If cChave <> TMP->TMP_CODPRO+TMP->TMP_NOME
				cChave := TMP->TMP_CODPRO+TMP->TMP_NOME
				@ nLin,001 PSAY TMP->TMP_CODPRO
				@ nLin,017 PSAY TMP->TMP_DESC
				@ nLin,048 PSAY LEFT(Alltrim(TMP->TMP_NOME),20)
			Endif	
			@ nLin,070 psay TMP->TMP_DESMED
			@ nLin,101 PSAY TMP->TMP_QUANT Picture "@E 99,999,999,999"
			@ nLin,116 PSAY TMP->TMP_PESO  Picture "@E 999,999,999.99"
		Endif

		nTotPneu  += TMP->TMP_QUANT
		nTotPeso  += TMP->TMP_PESO
		nSubPneu  += TMP->TMP_QUANT
		nSubPeso  += TMP->TMP_PESO
		nLin ++
	
		dbSkip()

		If mv_par01 == 1
			If cChave <> TMP->TMP_CODPRO
				@ nLin,001 PSAY "Total da Banda"
				@ nLin,080 PSAY nSubPneu Picture "@E 99,999,999,999"
				@ nLin,095 PSAY nSubPeso Picture "@E 999,999,999.99"
				nSubPneu  := 0
				nSubPeso  := 0
				nLin += 2
			Endif
		Else
			If cChave <> TMP->TMP_CODPRO+TMP->TMP_NOME
				@ nLin,001 PSAY "Total Banda X Cliente"
				@ nLin,101 PSAY nSubPneu  Picture "@E 99,999,999,999"
				@ nLin,116 PSAY nSubPeso  Picture "@E 999,999,999.99"
				nSubPneu  := 0
				nSubPeso  := 0
				nLin += 2
			Endif
		EndIF	
	EndDo

	nLin++

	If nTotPneu + nTotPeso > 0
		@ nLin,001 PSAY "TOTAL "

		If mv_par01 == 1
		    @ nLin,080 PSAY nTotPneu Picture "@E 99,999,999,999"
		    @ nLin,095 PSAY nTotPeso Picture "@E 999,999,999.99"
		ElseIf mv_par01 == 2
		    @ nLin,101 PSAY nTotPneu Picture "@E 99,999,999,999"
		    @ nLin,116 PSAY nTotPeso Picture "@E 999,999,999.99"
		Endif
	Endif	
	
	dbSelectArea("TMP")
	dbCloseArea("TMP")

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()
Return

Static Function GeraTRB()
	LOCAL cQuery := ""
	LOCAL nQtdGr := nQt2MGr := nSub := 0

	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

	cQuery := "SELECT D3_X_PROD, B1_DESC, C2_XNREDUZ, SUM(C2_QUANT) C2_QUANT, SUM(D3_QUANT) D3_QUANT "
	cQuery += "  FROM "+RetSqlName("SD3")+" SD3, "+RetSqlName("SC2")+" SC2, "+RetSqlName("SB1")+" SB1 "
	cQuery += " WHERE SD3.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "   AND D3_FILIAL = '" + xFilial("SD3") + "' "
	cQuery += "   AND C2_FILIAL = '" + xFilial("SC2") + "' "
	cQuery += "   AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += "   AND C2_NUM = SUBSTRING(D3_OP,1,6) "
	cQuery += "   AND C2_ITEM = SUBSTRING(D3_OP,7,2) "
	cQuery += "   AND C2_SEQUEN = SUBSTRING(D3_OP,9,3) "
	cQuery += "   AND B1_COD = D3_X_PROD "
	cQuery += "   AND B1_GRUPO = 'BAND' "
	cQuery += "   AND D3_ESTORNO <> 'S' "
	cQuery += "   AND D3_EMISSAO >= '"+DTOS(mv_par02)+"' "
	cQuery += "   AND D3_EMISSAO <= '"+DTOS(mv_par03)+"' "
	cQuery += " GROUP BY D3_X_PROD, B1_DESC, C2_XNREDUZ "
	cQuery += " ORDER BY D3_X_PROD"

	IncRegua()

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TRB",.F.,.T.)

	dbSelectArea("TRB")
	dbGotop()

	cCod := TRB->D3_X_PROD

	While !EOF()
		IF cCod == TRB->D3_X_PROD
			cCodGr  := TRB->D3_X_PROD
			cNomeGr := TRB->C2_XNREDUZ
			cDescGr := TRB->B1_DESC

			//--SubTotal da qtd. pneus		
			nSub    += TRB->C2_QUANT
			nQt2MGr += TRB->D3_QUANT
		EndIF

		cCod := TRB->D3_X_PROD

		dbSelectArea("TRB")
		TRB->(dbSkip())

		IF cCod != TRB->D3_X_PROD	
			dbSelectArea("TMP")
			If Reclock("TMP",.T.)
				TMP->TMP_SUBT   := nSub
				TMP->TMP_CODPRO := cCodGr
				TMP->TMP_DESC   := cDescGr
				TMP->TMP_NOME   := cNomeGr

				//-Qtd.de pneus
				TMP->TMP_QUANT  := nSub

				//--Peso
				TMP->TMP_PESO   := nQt2MGr
				MsUnlock()
			Endif
			cCod := TRB->D3_X_PROD
			nSub := nQtdGr := nQt2MGr := 0
		EndIF
	EndDo

	dbSelectArea("TRB")
	TRB->(dbCloseArea())
Return