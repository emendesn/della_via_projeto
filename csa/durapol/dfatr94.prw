#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR94
	Private cString        := "SE5"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Comissão por cliente"
	Private tamanho        := "G"
	Private nomeprog       := "DFATR94"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR94"
	Private titulo         := "Comissão por Cliente"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR94"
	Private lImp           := .F.
	Private aTipRel        := {"Motorista","Vendedor","Indicador"}
	Private aTipData       := {"Baixa","Emissao"}

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Quebra por         ?"," "," ","mv_ch1","N", 01,0,0,"C","","mv_par01","Motorista","","","","","Vendedor","","","","","Indicador","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Do Código          ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""         ,"","","","",""        ,"","","","",""         ,"","","","","","","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"03","Ate o Código       ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""         ,"","","","",""        ,"","","","",""         ,"","","","","","","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"04","Por Data           ?"," "," ","mv_ch4","N", 01,0,0,"C","","mv_par04","Baixa"    ,"","","","","Emissao" ,"","","","",""         ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Da Data            ?"," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""         ,"","","","",""        ,"","","","",""         ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate a Data         ?"," "," ","mv_ch6","D", 08,0,0,"G","","mv_par06",""         ,"","","","",""        ,"","","","",""         ,"","","","","","","","","","","","","","   ","","","",""          })

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
	Titulo := AllTrim(Titulo) + " - Por " + aTipData[mv_par04]

	Cabec1:="                                                                                        Comisssão           Comisssão           Comisssão"
	Cabec2:="     Cliente     Nome                                                Faturado            Vendedor           Motorista           Indicador               Total"
	        *     XXXXXX/XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	// Query
	if mv_par04 = 1
		cSql := "SELECT E1_VEND"+StrZero(mv_par01+2,1)+"      AS CODVEN"
		cSql += " ,     A3"+Substr("MVI",mv_par01,1)+".A3_NOME   AS NOME"
		cSql += " ,     E1_CLIENTE    AS CODCLI"
		cSql += " ,     E1_LOJA       AS LOJACLI"
		cSql += " ,     A1_NOME       AS NOMCLI"
		cSql += " ,     SUM(E5_VALOR) AS VALFAT"
		cSql += " ,     SUM((E5_VALOR*(CASE WHEN A1_COMIS4 > 0 THEN A1_COMIS4 ELSE A3V.A3_COMIS END))/100) AS VEND"
		cSql += " ,      SUM("
		cSql += "            CASE WHEN E1_VEND3 <> '' THEN"
		cSql += "                 (E5_VALOR*(CASE WHEN A1_COMIS3 > 0 THEN A1_COMIS3 ELSE A3M.A3_COMIS END))/100"
		cSql += "            ELSE"
		cSql += "                0"
		cSql += "            END"
		cSql += "          ) AS MOTOR"
		cSql += " ,      SUM("
		cSql += "            CASE WHEN E1_VEND5 <> '' THEN"
		cSql += "                 (E5_VALOR*(CASE WHEN A1_COMIS5 > 0 THEN A1_COMIS5 ELSE A3I.A3_COMIS END))/100"
		cSql += "            ELSE"
		cSql += "                 0"
		cSql += "            END"
		cSql += "          ) AS INDIC"
		cSql += " ,     0 AS TOTAL"

		cSql += " FROM "+RetSqlName("SE5")+" SE5"

		cSql += " JOIN "+RetSqlName("SE1")+" SE1"
		cSql += " ON   SE1.D_E_L_E_T_ = ''"
		cSql += " AND  E1_FILIAL = E5_FILIAL"
		cSql += " AND  E1_PREFIXO = E5_PREFIXO"
		cSql += " AND  E1_NUM = E5_NUMERO"
		cSql += " AND  E1_PARCELA = E5_PARCELA"
		cSql += " AND  E1_TIPO = E5_TIPO"
		cSql += " AND  E1_VEND"+StrZero(mv_par01+2,1)+" <> ''"
		cSql += " AND  E1_VEND"+StrZero(mv_par01+2,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"

		cSql += " JOIN "+RetSqlName("SA1")+" SA1"
		cSql += " ON   SA1.D_E_L_E_T_ = ''"
		cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += " AND  A1_COD = E1_CLIENTE"
		cSql += " AND  A1_LOJA = E1_LOJA"

		cSql += " JOIN "+RetSqlName("SA3")+" A3V"
		cSql += " ON   A3V.D_E_L_E_T_ = ''"
		cSql += " AND  A3V.A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += " AND  A3V.A3_COD = E1_VEND4"

		cSql += " LEFT JOIN "+RetSqlName("SA3")+" A3M"
		cSql += " ON   A3M.D_E_L_E_T_ = ''"
		cSql += " AND  A3M.A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += " AND  A3M.A3_COD = E1_VEND3"

		cSql += " LEFT JOIN "+RetSqlName("SA3")+" A3I"
		cSql += " ON   A3I.D_E_L_E_T_ = ''"
		cSql += " AND  A3I.A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += " AND  A3I.A3_COD = E1_VEND5"

		cSql += " WHERE SE5.D_E_L_E_T_ = ''"
		cSql += " AND   E5_FILIAL = '"+xFilial("SE5")+"'"
		cSql += " AND   E5_DATA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		cSql += " AND   E5_RECPAG ='R'"
		cSql += " AND   E5_TIPODOC IN('BA','VL')"
		cSql += " AND   E5_TIPO = 'NF'"
		cSql += " AND   E5_MOTBX = 'NOR'"
		cSql += " AND   E5_BANCO <> 'EXC'"
		cSql += " GROUP BY E1_VEND"+StrZero(mv_par01+2,1)+",A3"+Substr("MVI",mv_par01,1)+".A3_NOME,E1_CLIENTE,E1_LOJA,A1_NOME"
	Else
		cSql := " SELECT E1_VEND"+StrZero(mv_par01+2,1)+" AS CODVEN"
		cSql += " ,      A3_NOME       AS NOME"
		cSql += " ,      E1_CLIENTE    AS CODCLI"
		cSql += " ,      E1_LOJA       AS LOJACLI"
		cSql += " ,      A1_NOME       AS NOMCLI"
		cSql += " ,      SUM(E1_VALOR) AS VALFAT"

		cSql += " ,      (SELECT SUM("
		cSql += "                   CASE WHEN E1.E1_VEND4 <> '' THEN"
		cSql += "                        (E5_VALOR*(CASE WHEN A1.A1_COMIS4 > 0 THEN A1.A1_COMIS4 ELSE A3.A3_COMIS END))/100"
		cSql += "                   ELSE"
		cSql += "                       0"
		cSql += "                   END"
		cSql += "                 )"
		cSql += "       FROM "+RetSqlName("SE5")+" SE5"

		cSql += "       JOIN "+RetSqlName("SE1")+" E1"
		cSql += "       ON   E1.D_E_L_E_T_ = ''"
		cSql += "       AND  E1.E1_FILIAL = E5_FILIAL"
		cSql += "       AND  E1.E1_PREFIXO = E5_PREFIXO"
		cSql += "       AND  E1.E1_NUM = E5_NUMERO"
		cSql += "       AND  E1.E1_PARCELA = E5_PARCELA"
		cSql += "       AND  E1.E1_TIPO = E5_TIPO"
		cSql += "       AND  E1.E1_CLIENTE = SE1.E1_CLIENTE"
		cSql += "       AND  E1.E1_LOJA = SE1.E1_LOJA"
		cSql += "       AND  E1.E1_VEND4 = SE1.E1_VEND"+StrZero(mv_par01+2,1)
		cSql += "       AND  E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"

		cSql += "       JOIN "+RetSqlName("SA1")+" A1"
		cSql += "       ON   A1.D_E_L_E_T_ = ''"
		cSql += "       AND  A1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += "       AND  A1.A1_COD = E5_CLIFOR"
		cSql += "       AND  A1.A1_LOJA = E5_LOJA"

		cSql += "       LEFT JOIN "+RetSqlName("SA3")+" A3"
		cSql += "       ON   A3.D_E_L_E_T_ = ''"
		cSql += "       AND  A3.A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += "       AND  A3.A3_COD = E1.E1_VEND4"

		cSql += "       WHERE SE5.D_E_L_E_T_ = ''"
		cSql += "       AND   E5_CLIFOR = SE1.E1_CLIENTE"
		cSql += "       AND   E5_LOJA = SE1.E1_LOJA"
		cSql += "       AND   E5_RECPAG ='R'"
		cSql += "       AND   E5_TIPODOC IN('BA','VL')"
		cSql += "       AND   E5_MOTBX = 'NOR'"
		cSql += "       AND   E5_BANCO <> 'EXC') AS VEND"

		cSql += " ,      (SELECT SUM("
		cSql += "                   CASE WHEN E1.E1_VEND3 <> '' THEN"
		cSql += "                        (E5_VALOR*(CASE WHEN A1.A1_COMIS3 > 0 THEN A1.A1_COMIS3 ELSE A3.A3_COMIS END))/100"
		cSql += "                   ELSE"
		cSql += "                       0"
		cSql += "                   END"
		cSql += "                 )"
		cSql += "       FROM "+RetSqlName("SE5")+" SE5"

		cSql += "       JOIN "+RetSqlName("SE1")+" E1"
		cSql += "       ON   E1.D_E_L_E_T_ = ''"
		cSql += "       AND  E1.E1_FILIAL = E5_FILIAL"
		cSql += "       AND  E1.E1_PREFIXO = E5_PREFIXO"
		cSql += "       AND  E1.E1_NUM = E5_NUMERO"
		cSql += "       AND  E1.E1_PARCELA = E5_PARCELA"
		cSql += "       AND  E1.E1_TIPO = E5_TIPO"
		cSql += "       AND  E1.E1_CLIENTE = SE1.E1_CLIENTE"
		cSql += "       AND  E1.E1_LOJA = SE1.E1_LOJA"
		cSql += "       AND  E1.E1_VEND4 = SE1.E1_VEND"+StrZero(mv_par01+2,1)
		cSql += "       AND  E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"

		cSql += "       JOIN "+RetSqlName("SA1")+" A1"
		cSql += "       ON   A1.D_E_L_E_T_ = ''"
		cSql += "       AND  A1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += "       AND  A1.A1_COD = E5_CLIFOR"
		cSql += "       AND  A1.A1_LOJA = E5_LOJA"

		cSql += "       LEFT JOIN "+RetSqlName("SA3")+" A3"
		cSql += "       ON   A3.D_E_L_E_T_ = ''"
		cSql += "       AND  A3.A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += "       AND  A3.A3_COD = E1.E1_VEND3"

		cSql += "       WHERE SE5.D_E_L_E_T_ = ''"
		cSql += "       AND   E5_CLIFOR = SE1.E1_CLIENTE"
		cSql += "       AND   E5_LOJA = SE1.E1_LOJA"
		cSql += "       AND   E5_RECPAG ='R'"
		cSql += "       AND   E5_TIPODOC IN('BA','VL')"
		cSql += "       AND   E5_MOTBX = 'NOR'"
		cSql += "       AND   E5_BANCO <> 'EXC') AS MOTOR"

		cSql += " ,      (SELECT SUM("
		cSql += "                   CASE WHEN E1.E1_VEND5 <> '' THEN"
		cSql += "                        (E5_VALOR*(CASE WHEN A1.A1_COMIS5 > 0 THEN A1.A1_COMIS5 ELSE A3.A3_COMIS END))/100"
		cSql += "                   ELSE"
		cSql += "                       0"
		cSql += "                   END"
		cSql += "                 )"
		cSql += "       FROM "+RetSqlName("SE5")+" SE5"

		cSql += "       JOIN "+RetSqlName("SE1")+" E1"
		cSql += "       ON   E1.D_E_L_E_T_ = ''"
		cSql += "       AND  E1.E1_FILIAL = E5_FILIAL"
		cSql += "       AND  E1.E1_PREFIXO = E5_PREFIXO"
		cSql += "       AND  E1.E1_NUM = E5_NUMERO"
		cSql += "       AND  E1.E1_PARCELA = E5_PARCELA"
		cSql += "       AND  E1.E1_TIPO = E5_TIPO"
		cSql += "       AND  E1.E1_CLIENTE = SE1.E1_CLIENTE"
		cSql += "       AND  E1.E1_LOJA = SE1.E1_LOJA"
		cSql += "       AND  E1.E1_VEND4 = SE1.E1_VEND"+StrZero(mv_par01+2,1)
		cSql += "       AND  E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"

		cSql += "       JOIN "+RetSqlName("SA1")+" A1"
		cSql += "       ON   A1.D_E_L_E_T_ = ''"
		cSql += "       AND  A1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += "       AND  A1.A1_COD = E5_CLIFOR"
		cSql += "       AND  A1.A1_LOJA = E5_LOJA"

		cSql += "       LEFT JOIN "+RetSqlName("SA3")+" A3"
		cSql += "       ON   A3.D_E_L_E_T_ = ''"
		cSql += "       AND  A3.A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += "       AND  A3.A3_COD = E1.E1_VEND5"

		cSql += "       WHERE SE5.D_E_L_E_T_ = ''"
		cSql += "       AND   E5_CLIFOR = SE1.E1_CLIENTE"
		cSql += "       AND   E5_LOJA = SE1.E1_LOJA"
		cSql += "       AND   E5_RECPAG ='R'"
		cSql += "       AND   E5_TIPODOC IN('BA','VL')"
		cSql += "       AND   E5_MOTBX = 'NOR'"
		cSql += "       AND   E5_BANCO <> 'EXC') AS INDIC"

		cSql += " ,     0 AS TOTAL"

		cSql += " FROM "+RetSqlName("SE1")+" SE1"

		cSql += " JOIN "+RetSqlName("SA1")+" SA1"
		cSql += " ON   SA1.D_E_L_E_T_ = ''"
		cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += " AND  A1_COD = E1_CLIENTE"
		cSql += " AND  A1_LOJA = E1_LOJA"

		cSql += " LEFT JOIN "+RetSqlName("SA3")+" SA3"
		cSql += " ON   SA3.D_E_L_E_T_ = ''"
		cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += " AND  A3_COD = E1_VEND"+StrZero(mv_par01+2,1)

		cSql += " WHERE SE1.D_E_L_E_T_ = ''"
		cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
		cSql += " AND   E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		cSql += " AND   E1_VEND"+StrZero(mv_par01+2,1)+" <> ''"
		cSql += " AND   E1_VEND"+StrZero(mv_par01+2,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
		cSql += " AND   E1_TIPO = 'NF'"
		cSql += " GROUP BY E1_VEND"+StrZero(mv_par01+2,1)+",A3_NOME,E1_CLIENTE,E1_LOJA,A1_NOME"
	Endif

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","VALFAT","N",14,2)
	TcSetField("ARQ_SQL","VEND"  ,"N",14,2)
	TcSetField("ARQ_SQL","MOTOR" ,"N",14,2)
	TcSetField("ARQ_SQL","INDIC" ,"N",14,2)
	
	dbSelectArea("ARQ_SQL")
	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.) 

	dbSelectArea("TMP")
	REPLACE ALL TOTAL WITH VEND+MOTOR+INDIC
	IndRegua("TMP",cNomTmp,"CODVEN+Descend(Strzero(TMP->TOTAL,11,2))",,,"Selecionando Registros")

	ProcRegua(LastRec())
	dbgoTop()

	aTotGeral := {0,0,0,0,0}
	Do While !eof()
		IncProc("Imprimindo ...")
		lImp:=.T.

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif
	
		cVend := CODVEN
		aTotVend := {0,0,0,0,0}
		@ LI,001 PSAY aTipRel[mv_par01] + ": " + CODVEN + " - " + NOME
		LI++

		Do While !eof() .and. CODVEN = cVend
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif

			@ LI,005 PSAY CODCLI +"/"+ LOJACLI
			@ LI,017 PSAY NOMCLI
			@ LI,060 PSAY VALFAT Picture "@e 99,999,999,999.99"
			@ LI,080 PSAY VEND   Picture "@e 99,999,999,999.99"
			@ LI,100 PSAY MOTOR  Picture "@e 99,999,999,999.99"
			@ LI,120 PSAY INDIC  Picture "@e 99,999,999,999.99"
			@ LI,140 PSAY TOTAL  Picture "@e 99,999,999,999.99"
			aTotVend[1] += VALFAT
			aTotVend[2] += VEND
			aTotVend[3] += MOTOR
			aTotVend[4] += INDIC
			aTotVend[5] += TOTAL
			LI++
			dbSkip()
		Enddo
		@ LI,001 PSAY "Total do "+aTipRel[mv_par01]
		@ LI,060 PSAY aTotVend[1] Picture "@e 99,999,999,999.99"
		@ LI,080 PSAY aTotVend[2] Picture "@e 99,999,999,999.99"
		@ LI,100 PSAY aTotVend[3] Picture "@e 99,999,999,999.99"
		@ LI,120 PSAY aTotVend[4] Picture "@e 99,999,999,999.99"
		@ LI,140 PSAY aTotVend[5] Picture "@e 99,999,999,999.99"
		aTotGeral[1] += aTotVend[1]
		aTotGeral[2] += aTotVend[2]
		aTotGeral[3] += aTotVend[3]
		aTotGeral[4] += aTotVend[4]
		aTotGeral[5] += aTotVend[5]
		LI+=2
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	if lImp .and. !lAbortPrint
		@ LI,001 PSAY "Total Geral"
		@ LI,060 PSAY aTotGeral[1] Picture "@e 99,999,999,999.99"
		@ LI,080 PSAY aTotGeral[2] Picture "@e 99,999,999,999.99"
		@ LI,100 PSAY aTotGeral[3] Picture "@e 99,999,999,999.99"
		@ LI,120 PSAY aTotGeral[4] Picture "@e 99,999,999,999.99"
		@ LI,140 PSAY aTotGeral[5] Picture "@e 99,999,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil