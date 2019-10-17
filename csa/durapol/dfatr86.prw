#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR86
	Private cString        := ""
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Resumo de Vendas"
	Private tamanho        := "M"
	Private nomeprog       := "DFATR86"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR86"
	Private titulo         := "Resumo de vendas"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR86"
	Private lImp           := .f.
	Private aTipo          := {"Motorista","Vendedor","Indicador"}

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""          ,"","","","",""          ,"","","","",""           ,"","","","",""     ,"","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""          ,"","","","",""          ,"","","","",""           ,"","","","",""     ,"","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"03","Mostra             ?"," "," ","mv_ch3","N", 01,0,0,"C","","mv_par03","Motoristas","","","","","Vendedores","","","","","Indicadores","","","","","Todos","","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"04","Do Vendedor        ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""          ,"","","","",""          ,"","","","",""           ,"","","","",""     ,"","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"05","Ate o Vendedor     ?"," "," ","mv_ch5","C", 06,0,0,"G","","mv_par05",""          ,"","","","",""          ,"","","","",""           ,"","","","",""     ,"","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"06","Relatorio          ?"," "," ","mv_ch6","N", 01,0,0,"C","","mv_par06","Analitico" ,"","","","","Sintetico" ,"","","","",""           ,"","","","",""     ,"","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"07","Quebra pagina      ?"," "," ","mv_ch7","N", 01,0,0,"C","","mv_par07","Sim"       ,"","","","","Nao"       ,"","","","",""           ,"","","","",""     ,"","","","","","","","",""   ,"","","",""          })

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

	If mv_par06 = 1
		tamanho := "G"
	Else
		tamanho := "M"
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return nil


Static Function RunReport()
	If mv_par06 = 1
		Cabec1  := "     Data       Nota Fiscal   Item   Produto                                                              Servico           Mercantil           Prc. Unitario   Cliente"
				   *     99/99/99   XXXXXX/XXX    XXXX   XXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999.99   99,999,999,999.99   X   99,999,999,999.99   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
				   *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				   *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	Else
		Cabec1  := "Nome                                                                            Servico           Mercantil"
				   *                                                                      99,999,999,999.99   99,999,999,999.99
				   *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				   *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	Endif

	Titulo := AllTrim(Titulo) + " - " + iif(mv_par06=1,"Analitico","Sintetico") + " - " + dtoc(mv_par01) + " a " + dtoc(mv_par02)

	cSql := ""
	For k=3 to 5
		If mv_par03 = (k-2) .or. mv_par03 = 4
			If Len(AllTrim(cSql)) > 0
				cSql += " UNION ALL "
			Endif
			cSql += "SELECT '"+Str(k-2,1)+"' AS CHAVE,F2_VEND"+Str(k,1)+" AS VEND,A3_NOME,D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,C6_DESCRI,B1_GRUPO,D2_TES,D2_PRUNIT,D2_TOTAL,A1_NOME"
			cSql += " FROM "+RetSqlName("SD2")+" SD2"

			cSql += " JOIN "+RetSqlName("SF2")+" SF2"
			cSql += " ON   SF2.D_E_L_E_T_ = ''"
			cSql += " AND  F2_FILIAL = D2_FILIAL"
			cSql += " AND  F2_DOC = D2_DOC"
			cSql += " AND  F2_SERIE = D2_SERIE"
			cSql += " AND  F2_VEND"+Str(k,1)+" BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"

			cSql += " JOIN "+RetSqlName("SB1")+" SB1"
			cSql += " ON   SB1.D_E_L_E_T_ = ''"
			cSql += " AND  B1_COD = D2_COD"

			cSql += " JOIN "+RetSqlName("SF4")+" SF4"
			cSql += " ON   SF4.D_E_L_E_T_ = ''"
			cSql += " AND  F4_CODIGO = D2_TES"
			cSql += " AND  F4_DUPLIC = 'S'"

			cSql += " JOIN "+RetSqlName("SA3")+" SA3"
			cSql += " ON   SA3.D_E_L_E_T_ = ''"
			cSql += " AND  A3_COD = F2_VEND"+Str(k,1)

			cSql += " JOIN "+RetSqlName("SA1")+" SA1"
			cSql += " ON   SA3.D_E_L_E_T_ = ''"
			cSql += " AND  A1_COD = F2_CLIENTE"
			cSql += " AND  A1_LOJA = F2_LOJA"

			cSql += " LEFT JOIN "+RetSqlName("SC6")+" SC6"
			cSql += " ON   SC6.D_E_L_E_T_ = ''"
			cSql += " AND  C6_NUM = D2_PEDIDO"
			cSql += " AND  C6_ITEM = D2_ITEMPV"

			cSql += " WHERE SD2.D_E_L_E_T_ = ''"
			cSql += " AND   D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
			cSql += " AND   D2_TIPO = 'N'"
		endif
	Next

	cSql += " ORDER BY CHAVE,VEND,D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","D2_EMISSAO","D")
	TcSetField("ARQ_SQL","D2_PRUNIT" ,"N",14,2)
	TcSetField("ARQ_SQL","D2_TOTAL"  ,"N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	nTotGerS := 0
	nTotGerM := 0

	Do While !eof()
		lImp:=.t.
		if li>55 .OR. (mv_par07 = 1)
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		Else
			if mv_par06 = 1
				Li+=2
			Else
				Li++
			Endif
		endif

		cChave := CHAVE+VEND
		@ LI,000 PSAY aTipo[Val(CHAVE)] + ": "+VEND+" - "+A3_NOME
		nTotS := 0
		nTotM := 0
		LI++

		Do While !eof() .AND. CHAVE+VEND = cChave
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
	
			If mv_par06 = 1
				@ LI,005 PSAY D2_EMISSAO
				@ LI,016 PSAY D2_DOC+"/"+D2_SERIE
				@ LI,030 PSAY D2_ITEM
				@ LI,037 PSAY Substr(D2_COD,1,5)+"-"+Substr(C6_DESCRI,1,50)

				IF AllTrim(B1_GRUPO) $ "ATEC/SERV/CI/SC" //Serviço
					@ LI,096 PSAY D2_TOTAL Picture "@e 99,999,999,999.99"
					nTotS += D2_TOTAL
					nTotGerS += D2_TOTAL
				Else
					@ LI,096 PSAY "             -,--"
				EndIF

				IF AllTrim(B1_GRUPO) = "0001" .or. D2_TES = "506" //Mercantil
					@ LI,116 PSAY D2_TOTAL Picture "@e 99,999,999,999.99"
					nTotM += D2_TOTAL
					nTotGerM += D2_TOTAL
				Else
					@ LI,116 PSAY "             -,--"
				EndIF

				@ LI,140 PSAY D2_PRUNIT Picture "@e 99,999,999,999.99"
				@ LI,160 PSAY A1_NOME
				LI++
			Else
				IF AllTrim(B1_GRUPO) $ "ATEC/SERV/CI/SC" //Serviço
					nTotS += D2_TOTAL
					nTotGerS += D2_TOTAL
				EndIF

				IF AllTrim(B1_GRUPO) = "0001" .or. D2_TES = "506" //Mercantil
					nTotM += D2_TOTAL
					nTotGerM += D2_TOTAL
				EndIF
			Endif
			dbSkip()
		Enddo
		if mv_par06 = 1
			@ LI,000 PSAY "Total do Vendedor"
			@ LI,096 PSAY nTotS Picture "@e 99,999,999,999.99"
			@ LI,116 PSAY nTotM Picture "@e 99,999,999,999.99"
		Else
			LI:=LI-1
			@ LI,070 PSAY nTotS Picture "@e 99,999,999,999.99"
			@ LI,090 PSAY nTotM Picture "@e 99,999,999,999.99"
		Endif
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		LI+=2
		@ LI,000 PSAY "Total Geral"
		if mv_par06 = 1
			@ LI,096 PSAY nTotGerS Picture "@e 99,999,999,999.99"
			@ LI,116 PSAY nTotGerM Picture "@e 99,999,999,999.99"
		Else
			@ LI,070 PSAY nTotGerS Picture "@e 99,999,999,999.99"
			@ LI,090 PSAY nTotGerM Picture "@e 99,999,999,999.99"
		Endif
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil