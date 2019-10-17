#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVFINR02
	Private cString        := "SE5"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Vencimentos X Baixas (Sintético)"
	Private tamanho        := "G"
	Private nomeprog       := "DVFINR02"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DVFN02"
	Private titulo         := "Vencimentos X Baixas (Sintético)"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVFINR02"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Data Base          ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })


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
	Cabec1 :="Data Base: " + dtoc(mv_par01)
	Cabec2 :=" Cliente     Nome                             Prf   Titulo     Tipo   Vencimento            Valor    % Juros     Juros Devido   Juros Recebido            Multa      Abatimentos   Portador               Situação"
	         * XXXXXX/XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXX   XXXXXX-X   XX     99/99/99     999,999,999.99     999.99   999,999,999.99   999,999,999.99   999,999,999.99   999,999,999.99   XXXXXXXXXXXXXXXXXXXX   XXX
    	     *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	         *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	// Verifica se exite a View no banco de dados, se não existir criar.
	cSql := "SELECT NAME FROM SYSIBM.SYSVIEWS WHERE NAME = 'VW_DVFINR02'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"CHK_VIEW", .T., .T.)
	dbSelectArea("CHK_VIEW")
	lCriaView := EOF()
	dbCloseArea()
	
	If lCriaView
		cSql := "CREATE VIEW DB2.VW_DVFINR02 AS"

		cSql += " SELECT E1_CLIENTE"
		cSql += " ,      E1_LOJA"
		cSql += " ,      E1_NOMCLI"
		cSql += " ,      E1_PREFIXO"
		cSql += " ,      E1_NUM"
		cSql += " ,      E1_PARCELA"
		cSql += " ,      E1_TIPO"
		cSql += " ,      E1_VENCREA"
		cSql += " ,      E1_VALOR"
		cSql += " ,      E1_PORCJUR" 
		cSql += " ,      E1_SITUACA"
		cSql += " ,      (E1_VALOR*(E1_PORCJUR/100))*((CASE WHEN DB2.MSDATEDIFF('DAY',E1_VENCREA,E5_DATA) > 0 THEN DB2.MSDATEDIFF('DAY',E1_VENCREA,E5_DATA) ELSE 0 END)) AS JURREAL"
		cSql += " ,      E5_VALOR"
		cSql += " ,      E5_DATA"
		cSql += " ,      E5_TIPODOC"
		cSql += " ,      E5_BANCO"
		cSql += " ,      A6_NOME"

		cSql += " FROM SE5010 SE5"

		cSql += " LEFT JOIN SE1010 SE1"
		cSql += " ON   SE1.D_E_L_E_T_ = ''"
		cSql += " AND  E1_FILIAL = E5_FILIAL"
		cSql += " AND  E1_PREFIXO = E5_PREFIXO"
		cSql += " AND  E1_NUM = E5_NUMERO"
		cSql += " AND  E1_PARCELA = E5_PARCELA"
		cSql += " AND  E1_TIPO = E5_TIPO"

		cSql += " LEFT JOIN SA6010 SA6"
		cSql += " ON   SA6.D_E_L_E_T_ = ''"
		cSql += " AND  A6_FILIAL = '  '"
		cSql += " AND  A6_COD = E5_BANCO"
		cSql += " AND  A6_AGENCIA = E5_AGENCIA"
		cSql += " AND  A6_NUMCON = E5_CONTA"

		cSql += " WHERE SE5.D_E_L_E_T_ = ''"
		cSql += " AND   E5_FILIAL = '  '"
		cSql += " AND   E5_RECPAG = 'R'"

		nUpdt := 0
		MsgRun("Criando View VW_DVFINR02 ...",,{|| nUpdt := TcSqlExec(cSql) })

		If nUpdt < 0
			MsgBox(TcSqlError(),"Erro ao criar a View","STOP")
			Return nil
		Endif
	Endif


	// Acumulados do Dia
	cSql := "SELECT TIPO"
	cSql += " ,     UPPER(SUBSTR(X5_DESCRI,1,30)) AS DESC"
	cSql += " ,     SUM(EMITIDO) AS TOTDIA"
	cSql += " ,     SUM(VENCTO) AS TOTVENC"
	cSql += " ,     SUM(BAIXAS) AS TOTBX"
	cSql += " ,     SUM(OUTREC) AS TOTRC"
	cSql += " ,     SUM(JURREAL) AS TOTREAL"
	cSql += " ,     SUM(JUROS) AS TOTJUR"
	cSql += " ,     SUM(MULTA) AS TOTMUL"
	cSql += " ,     SUM(ABAT) AS TOTABT"
	cSql += " FROM (SELECT E1_TIPO AS TIPO"
	cSql += "       ,      SUM(E1_VALOR) AS EMITIDO"
	cSql += "       ,      0 AS VENCTO"
	cSql += "       ,      0 AS BAIXAS"
	cSql += "       ,      0 AS OUTREC"
	cSql += "       ,      0 AS JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       FROM "+RetSqlName("SE1")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += "       AND   E1_EMISSAO = '"+dtos(mv_par01)+"'"
	cSql += "       GROUP BY E1_TIPO"

	cSql += "       UNION"

	cSql += "       SELECT E1_TIPO AS TIPO"
	cSql += "       ,      0 AS EMITIDO"
	cSql += "       ,      SUM(E1_VALOR) AS VENCTO"
	cSql += "       ,      0 AS BAIXAS"
	cSql += "       ,      0 AS OUTREC"
	cSql += "       ,      0 AS JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       FROM "+RetSqlName("SE1")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += "       AND   E1_VENCREA = '"+dtos(mv_par01)+"'"
	cSql += "       GROUP BY E1_TIPO"

	cSql += "       UNION"

	cSql += "       SELECT E5_TIPO AS TIPO"
	cSql += "       ,      0 AS EMITIDO"
	cSql += "       ,      0 AS VENCTO"
	cSql += "       ,      SUM(E5_VALOR) AS BAIXAS"
	cSql += "       ,      0 AS OUTREC"
	cSql += "       ,      0 AS JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       FROM "+RetSqlName("SE5")+" SE5" 

	cSql += "       JOIN "+RetSqlName("SE1")+" SE1"
	cSql += "       ON   SE1.D_E_L_E_T_ = ''"
	cSql += "       AND  E1_FILIAL = E5_FILIAL"
	cSql += "       AND  E1_NUM = E5_NUMERO"
	cSql += "       AND  E1_PREFIXO = E5_PREFIXO"
	cSql += "       AND  E1_PARCELA = E5_PARCELA"
	cSql += "       AND  E1_TIPO = E5_TIPO"
	cSql += "       AND  E1_CLIENTE = E5_CLIFOR"
	cSql += "       AND  E1_LOJA = E5_LOJA"
	cSql += "       AND  E1_VENCREA = '"+dtos(mv_par01)+"'"

	cSql += "       WHERE SE5.D_E_L_E_T_ = ''"
	cSql += "       AND E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += "       AND E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND E5_RECPAG = 'R'"
	cSql += "       AND E5_MOTBX = 'NOR'
	cSql += "       GROUP BY E5_TIPO"

	cSql += "       UNION"

	cSql += "       SELECT E5_TIPO AS TIPO"
	cSql += "       ,      0 AS EMITIDO"
	cSql += "       ,      0 AS VENCTO"
	cSql += "       ,      0 AS BAIXAS"
	cSql += "       ,      SUM(E5_VALOR) AS OUTREC"
	cSql += "       ,      0 AS JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       FROM "+RetSqlName("SE5")+" SE5" 

	cSql += "       JOIN "+RetSqlName("SE1")+" SE1"
	cSql += "       ON   SE1.D_E_L_E_T_ = ''"
	cSql += "       AND  E1_FILIAL = E5_FILIAL"
	cSql += "       AND  E1_NUM = E5_NUMERO"
	cSql += "       AND  E1_PREFIXO = E5_PREFIXO"
	cSql += "       AND  E1_PARCELA = E5_PARCELA"
	cSql += "       AND  E1_TIPO = E5_TIPO"
	cSql += "       AND  E1_CLIENTE = E5_CLIFOR"
	cSql += "       AND  E1_LOJA = E5_LOJA"
	cSql += "       AND  E1_VENCREA <> '"+dtos(mv_par01)+"'"

	cSql += "       WHERE SE5.D_E_L_E_T_ = ''"
	cSql += "       AND E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += "       AND E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND E5_RECPAG = 'R'"
	cSql += "       AND E5_MOTBX = 'NOR'
	cSql += "       GROUP BY E5_TIPO"

	cSql += "       UNION"

	cSql += "       SELECT E1_TIPO AS TIPO"
	cSql += "       ,      0 AS EMITIDO"
	cSql += "       ,      0 AS VENCTO"
	cSql += "       ,      0 AS BAIXAS"
	cSql += "       ,      0 AS OUTREC"
	cSql += "       ,      SUM(JURREAL) AS JURREAL"
	cSql += "       ,      0 AS JUROS" 
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       FROM (SELECT E1_TIPO,JURREAL"
	cSql += "             FROM VW_DVFINR02"
	cSql += "             WHERE  E5_DATA = '20070117'"
	cSql += "             AND    E5_TIPODOC IN('DC','MT','JR')"

	cSql += "             UNION"

	cSql += "             SELECT E1_TIPO,(E1_VALOR*(E1_PORCJUR/100))*((CASE WHEN DB2.MSDATEDIFF('DAY',E1_VENCREA,E1_BAIXA) > 0 THEN DB2.MSDATEDIFF('DAY',E1_VENCREA,E1_BAIXA) ELSE 0 END)) AS JURREAL"
	cSql += "             FROM SE1010 SE1"
	cSql += "             LEFT JOIN SE5010 SE5"
	cSql += "             ON   SE5.D_E_L_E_T_ = ''"
	cSql += "             AND  E5_FILIAL = '  '"
	cSql += "             AND  E5_PREFIXO = E1_PREFIXO"
	cSql += "             AND  E5_NUMERO = E1_NUM"
	cSql += "             AND  E5_PARCELA = E1_PARCELA"
	cSql += "             AND  E5_TIPO = E1_TIPO"
	cSql += "             AND  E5_CLIFOR = E1_CLIENTE"
	cSql += "             AND  E5_LOJA = E1_LOJA"
	cSql += "             AND  E5_RECPAG = 'R'"
	cSql += "             AND  E5_TIPODOC IN('JR','MT','DC')"
	cSql += "             WHERE SE1.D_E_L_E_T_ = ''"
	cSql += "             AND   E1_FILIAL = '  '"
	cSql += "             AND   E1_BAIXA = '20070117'"
	cSql += "             AND   E1_VENCREA < E1_BAIXA"
	cSql += "             AND   E1_TIPO IN('NF','DP')"
	cSql += "             AND   E5_VALOR IS NULL"
	cSql += "       ) AS TABJUR"
	cSql += "       GROUP BY E1_TIPO"

	cSql += "       UNION"

	cSql += "       SELECT E5_TIPO AS TIPO"
	cSql += "       ,      0 AS EMITIDO"
	cSql += "       ,      0 AS VENCTO"
	cSql += "       ,      0 AS BAIXAS"
	cSql += "       ,      0 AS OUTREC"
	cSql += "       ,      0 AS JURREAL"
	cSql += "       ,      SUM(E5_VALOR) AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       FROM "+RetSqlName("SE5")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += "       AND E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND E5_RECPAG = 'R'"
	cSql += "       AND E5_TIPODOC = 'JR'"
	cSql += "       GROUP BY E5_TIPO"

	cSql += "       UNION"

	cSql += "       SELECT E5_TIPO AS TIPO"
	cSql += "       ,      0 AS EMITIDO"
	cSql += "       ,      0 AS VENCTO"
	cSql += "       ,      0 AS BAIXAS"
	cSql += "       ,      0 AS OUTREC"
	cSql += "       ,      0 AS JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      SUM(E5_VALOR) AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       FROM "+RetSqlName("SE5")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += "       AND E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND E5_RECPAG = 'R'"
	cSql += "       AND E5_TIPODOC = 'MT'"
	cSql += "       GROUP BY E5_TIPO"

	cSql += "       UNION"

	cSql += "       SELECT E5_TIPO AS TIPO"
	cSql += "       ,      0 AS EMITIDO"
	cSql += "       ,      0 AS VENCTO"
	cSql += "       ,      0 AS BAIXAS"
	cSql += "       ,      0 AS OUTREC"
	cSql += "       ,      0 AS JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      SUM(E5_VALOR) AS ABAT"
	cSql += "       FROM "+RetSqlName("SE5")
	cSql += "       WHERE D_E_L_E_T_ = ''"
	cSql += "       AND E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += "       AND E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND E5_RECPAG = 'R'"
	cSql += "       AND E5_TIPODOC = 'DC'"
	cSql += "       GROUP BY E5_TIPO"

	cSql += ") AS TABTMP"

	cSql += " LEFT JOIN "+RetSqlName("SX5")
	cSql += " ON   D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = ''"
	cSql += " AND  X5_TABELA = '05'"
	cSql += " AND  X5_CHAVE = TIPO"

	cSql += " WHERE TIPO <> ''"

	cSql += " GROUP BY TIPO,X5_DESCRI"
	cSql += " ORDER BY TIPO"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","TOTDIA" ,"N",14,2)
	TcSetField("ARQ_SQL","TOTVENC","N",14,2)
	TcSetField("ARQ_SQL","TOTBX"  ,"N",14,2)
	TcSetField("ARQ_SQL","TOTREAL","N",14,2)
	TcSetField("ARQ_SQL","TOTJUR" ,"N",14,2)
	TcSetField("ARQ_SQL","TOTMUL" ,"N",14,2)
	TcSetField("ARQ_SQL","TOTRC"  ,"N",14,2)
	TcSetField("ARQ_SQL","TOTABT" ,"N",14,2)
	

	// Acumulados em Carteira
	cSql := "SELECT TIPO"
	cSql += " ,      UPPER(SUBSTR(X5_DESCRI,1,30)) AS DESC"
	cSql += " ,      SUM(VENCIDO) AS TOTVEN"
	cSql += " ,      SUM(AVENCER) AS TOTAV"
	cSql += " FROM  (SELECT E1_TIPO AS TIPO"
	cSql += "        ,      SUM(E1_VALOR) AS VENCIDO"
	cSql += "        ,      0 AS AVENCER"
	cSql += "        FROM "+RetSqlName("SE1")
	cSql += "        WHERE D_E_L_E_T_ = ''"
	cSql += "        AND   E1_FILIAL = ''"
	cSql += "        AND   E1_VENCREA < '"+dtos(mv_par01)+"'"
	cSql += "        AND   E1_BAIXA = ''"
	cSql += "        GROUP BY E1_TIPO"

	cSql += "        UNION"

	cSql += "        SELECT E1_TIPO AS TIPO"
	cSql += "        ,      0 AS VENCIDO"
	cSql += "        ,      SUM(E1_VALOR) AS AVENCER"
	cSql += "        FROM "+RetSqlName("SE1")
	cSql += "        WHERE D_E_L_E_T_ = ''"
	cSql += "        AND   E1_FILIAL = ''"
	cSql += "        AND   E1_VENCREA >= '"+dtos(mv_par01)+"'"
	cSql += "        AND   E1_BAIXA = ''"
	cSql += "        GROUP BY E1_TIPO) AS TABTMP"

	cSql += " LEFT JOIN "+RetSqlName("SX5")
	cSql += " ON   D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = ''"
	cSql += " AND  X5_TABELA = '05'"
	cSql += " AND  X5_CHAVE = TIPO"

	cSql += " WHERE TIPO <> ''"
	cSql += " GROUP BY TIPO,X5_DESCRI"
	cSql += " ORDER BY TIPO"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_TOT", .T., .T.)})
	TcSetField("ARQ_TOT","TOTVEN","N",14,2)
	TcSetField("ARQ_TOT","TOTAV" ,"N",14,2)


	// Lista Titulos
	cSql := "SELECT E1_CLIENTE"
	cSql += " ,      E1_LOJA"
	cSql += " ,      E1_NOMCLI"
	cSql += " ,      E1_PREFIXO"
	cSql += " ,      E1_NUM"
	cSql += " ,      E1_PARCELA"
	cSql += " ,      E1_TIPO"
	cSql += " ,      E1_VENCREA"
	cSql += " ,      E1_VALOR"
	cSql += " ,      E1_PORCJUR"
	cSql += " ,      JURREAL"
	cSql += " ,      SUM(JUROS) AS JUROS"
	cSql += " ,      SUM(MULTA) AS MULTA"
	cSql += " ,      SUM(ABAT) AS ABAT"
	cSql += " ,      E5_BANCO"
	cSql += " ,      A6_NOME"
	cSql += " ,      X5_DESCRI"

	cSql += " FROM (SELECT E1_CLIENTE"
	cSql += "       ,      E1_LOJA"
	cSql += "       ,      E1_NOMCLI"
	cSql += "       ,      E1_PREFIXO"
	cSql += "       ,      E1_NUM"
	cSql += "       ,      E1_PARCELA"
	cSql += "       ,      E1_TIPO"
	cSql += "       ,      E1_VENCREA"
	cSql += "       ,      E1_VALOR"
	cSql += "       ,      E1_PORCJUR"
	cSql += "       ,      JURREAL"
	cSql += "       ,      E5_VALOR AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       ,      E5_BANCO"
	cSql += "       ,      A6_NOME"
	cSql += "       ,      E1_SITUACA"
	cSql += "       FROM VW_DVFINR02"
	cSql += "       WHERE  E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND    E5_TIPODOC = 'JR'"

	cSql += "       UNION"

	cSql += "       SELECT E1_CLIENTE"
	cSql += "       ,      E1_LOJA"
	cSql += "       ,      E1_NOMCLI"
	cSql += "       ,      E1_PREFIXO"
	cSql += "       ,      E1_NUM"
	cSql += "       ,      E1_PARCELA" 
	cSql += "       ,      E1_TIPO"
	cSql += "       ,      E1_VENCREA"
	cSql += "       ,      E1_VALOR"
	cSql += "       ,      E1_PORCJUR"
	cSql += "       ,      JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      E5_VALOR AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       ,      E5_BANCO"
	cSql += "       ,      A6_NOME"
	cSql += "       ,      E1_SITUACA"
	cSql += "       FROM VW_DVFINR02"
	cSql += "       WHERE  E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND    E5_TIPODOC = 'MT'"

	cSql += "       UNION"

	cSql += "       SELECT E1_CLIENTE"
	cSql += "       ,      E1_LOJA"
	cSql += "       ,      E1_NOMCLI"
	cSql += "       ,      E1_PREFIXO"
	cSql += "       ,      E1_NUM"
	cSql += "       ,      E1_PARCELA"
	cSql += "       ,      E1_TIPO"
	cSql += "       ,      E1_VENCREA"
	cSql += "       ,      E1_VALOR"
	cSql += "       ,      E1_PORCJUR"
	cSql += "       ,      JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      E5_VALOR AS ABAT"
	cSql += "       ,      E5_BANCO"
	cSql += "       ,      A6_NOME"
	cSql += "       ,      E1_SITUACA"
	cSql += "       FROM VW_DVFINR02"
	cSql += "       WHERE  E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += "       AND    E5_TIPODOC = 'DC'"

	cSql += "       UNION"

	cSql += "       SELECT E1_CLIENTE"
	cSql += "       ,      E1_LOJA"
	cSql += "       ,      E1_NOMCLI"
	cSql += "       ,      E1_PREFIXO"
	cSql += "       ,      E1_NUM"
	cSql += "       ,      E1_PARCELA"
	cSql += "       ,      E1_TIPO"
	cSql += "       ,      E1_VENCREA"
	cSql += "       ,      E1_VALOR"
	cSql += "       ,      E1_PORCJUR"
	cSql += "       ,      (E1_VALOR*(E1_PORCJUR/100))*((CASE WHEN DB2.MSDATEDIFF('DAY',E1_VENCREA,E1_BAIXA) > 0 THEN DB2.MSDATEDIFF('DAY',E1_VENCREA,E1_BAIXA) ELSE 0 END)) AS JURREAL"
	cSql += "       ,      0 AS JUROS"
	cSql += "       ,      0 AS MULTA"
	cSql += "       ,      0 AS ABAT"
	cSql += "       ,      E5_BANCO"
	cSql += "       ,      A6_NOME"
	cSql += "       ,      E1_SITUACA"

	cSql += "       FROM "+RetSqlName("SE1")+" SE1"

	cSql += "       LEFT JOIN "+RetSqlName("SE5")+" SE5"
	cSql += "       ON   SE5.D_E_L_E_T_ = ''"
	cSql += "       AND  E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += "       AND  E5_PREFIXO = E1_PREFIXO"
	cSql += "       AND  E5_NUMERO = E1_NUM"
	cSql += "       AND  E5_PARCELA = E1_PARCELA"
	cSql += "       AND  E5_TIPO = E1_TIPO"
	cSql += "       AND  E5_CLIFOR = E1_CLIENTE"
	cSql += "       AND  E5_LOJA = E1_LOJA"
	cSql += "       AND  E5_RECPAG = 'R'"
	cSql += "       AND  E5_TIPODOC IN('JR','MT','DC')"

	cSql += "       LEFT JOIN SA6010 SA6"
	cSql += "       ON   SA6.D_E_L_E_T_ = ''"
	cSql += "       AND  A6_FILIAL = '"+xFilial("SA6")+"'"
	cSql += "       AND  A6_COD = E5_BANCO"
	cSql += "       AND  A6_AGENCIA = E5_AGENCIA"
	cSql += "       AND  A6_NUMCON = E5_CONTA"

	cSql += "       WHERE SE1.D_E_L_E_T_ = ''"
	cSql += "       AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += "       AND   E1_BAIXA = '"+dtos(mv_par01)+"'"
	cSql += "       AND   E1_VENCREA < E1_BAIXA"
	cSql += "       AND   E1_TIPO IN('NF','DP')"
	cSql += "       AND   E5_VALOR IS NULL) AS TABTMP"

	cSql += " LEFT JOIN "+RetSqlName("SX5")+" SX5"
	cSql += " ON   SX5.D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += " AND  X5_TABELA = '07'"
	cSql += " AND  X5_CHAVE = E1_SITUACA"

	cSql += " GROUP BY E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCREA,E1_VALOR,E1_PORCJUR,JURREAL,E5_BANCO,A6_NOME,X5_DESCRI"
	cSql += " ORDER BY E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_JUR", .T., .T.)})

	TcSetField("ARQ_JUR","E1_VENCREA","D")
	TcSetField("ARQ_JUR","E1_VALOR"  ,"N",14,2)
	TcSetField("ARQ_JUR","E1_PORCJUR","N",06,2)
	TcSetField("ARQ_JUR","JURREAL"   ,"N",14,2)
	TcSetField("ARQ_JUR","JUROS"     ,"N",14,2)
	TcSetField("ARQ_JUR","MULTA"     ,"N",14,2)
	TcSetField("ARQ_JUR","ABAT"      ,"N",14,2)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	nTotDia  := 0
	nTotVenc := 0
	nTotBx   := 0
	nTotRc   := 0
	nTotReal := 0
	nTotJur  := 0
	nTotMul  := 0
	nTotAbt  := 0

	Do While !eof()
		IncProc("Preparando relatório ...")

		nTotDia  += TOTDIA
		nTotVenc += TOTVENC
		nTotBx   += TOTBX
		nTotRc   += TOTRC
		nTotReal += TOTREAL
		nTotJur  += TOTJUR
		nTotMul  += TOTMUL
		nTotAbt  += TOTABT

		dbSkip()
	Enddo
	dbgoTop()


	lFirst := .T.
	dbSelectArea("ARQ_SQL")
	Do While !eof()
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		lImp := .T.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
			lFirst := .T.
		endif

		if lFirst
			lFirst := .F.
			@ LI,000 PSAY " A C U M U L A D O S   D O   D I A"
			LI++
			@ LI,000 PSAY " Tipo   Descrição                             Emimtidos       (%)         Vencidos    Receb. do dia   Receb Diversos     Juros Devido            Juros            Multa      Abatimentos"
			LI++
			@ LI,000 PSAY IniFatLine+FimFatLine
			LI+=2
		Endif


		@ LI,001 PSAY TIPO
		@ LI,008 PSAY DESC
		@ LI,041 PSAY TOTDIA  Picture "@e 999,999,999.99"
		@ LI,058 PSAY (TOTDIA/nTotDia)*100 Picture "@e 999.99"
		@ LI,064 PSAY "%"
		@ LI,068 PSAY TOTVENC Picture "@e 999,999,999.99"
		@ LI,085 PSAY TOTBX   Picture "@e 999,999,999.99"
		@ LI,102 PSAY TOTRC   Picture "@e 999,999,999.99"
		@ LI,119 PSAY TOTREAL Picture "@e 999,999,999.99"
		@ LI,136 PSAY TOTJUR  Picture "@e 999,999,999.99"
		@ LI,153 PSAY TOTMUL  Picture "@e 999,999,999.99"
		@ LI,170 PSAY TOTABT  Picture "@e 999,999,999.99"
		LI++
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		LI++
		@ LI,001 PSAY "T O T A L"
		@ LI,041 PSAY nTotDia  Picture "@e 999,999,999.99"
		@ LI,068 PSAY nTotVenc Picture "@e 999,999,999.99"
		@ LI,085 PSAY nTotBx   Picture "@e 999,999,999.99"
		@ LI,102 PSAY nTotRc   Picture "@e 999,999,999.99"
		@ LI,119 PSAY nTotReal Picture "@e 999,999,999.99"
		@ LI,136 PSAY nTotJur  Picture "@e 999,999,999.99"
		@ LI,153 PSAY nTotMul  Picture "@e 999,999,999.99"
		@ LI,170 PSAY nTotAbt  Picture "@e 999,999,999.99"
	endif


	LI+=3
	lFirst  := .T.
	nTotVen := 0
	nTotAV  := 0
	dbSelectArea("ARQ_TOT")
	Do While !eof()
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
			lFirst := .T.
		endif
	
		if lFirst
			lFirst := .F.
			@ LI,000 PSAY " A C U M U L A D O S   E M   C A R T E I R A"
			LI++
			@ LI,000 PSAY " Tipo   Descrição                                 Carteira      (%)            Vencidos      (%)            A Vencer      (%)"
			LI++
			@ LI,000 PSAY IniFatLine+FimFatLine
			LI+=2
		Endif

		@ LI,001 PSAY TIPO
		@ LI,008 PSAY DESC
		@ LI,041 PSAY TOTVEN+TOTAV                Picture "@e 99,999,999,999.99"
		@ LI,061 PSAY 100                         Picture "@e 999.99"
		@ LI,070 PSAY TOTVEN                      Picture "@e 99,999,999,999.99"
		@ LI,090 PSAY (TOTVEN/(TOTVEN+TOTAV))*100 Picture "@e 999.99"
		@ LI,099 PSAY TOTAV                       Picture "@e 99,999,999,999.99"
		@ LI,119 PSAY (TOTAV/(TOTVEN+TOTAV))*100  Picture "@e 999.99"
		nTotVen += TOTVEN
		nTotAV  += TOTAV

		LI++
		dbSkip()
	Enddo
	dbSelectArea("ARQ_TOT")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		LI++
		@ LI,001 PSAY "T O T A L"
		@ LI,041 PSAY nTotVen+nTotAV  Picture "@e 99,999,999,999.99"
		@ LI,061 PSAY 100             Picture "@e 999.99"
		@ LI,070 PSAY nTotVen         Picture "@e 99,999,999,999.99"
		@ LI,090 PSAY (nTotVen/(nTotVen+nTotAV))*100 Picture "@e 999.99"
		@ LI,099 PSAY nTotAV          Picture "@e 99,999,999,999.99"
		@ LI,119 PSAY (nTotAV/(nTotVen+nTotAV))*100  Picture "@e 999.99"
	endif


	dbSelectArea("ARQ_JUR")
	dbGoTop()

	LI:=99
	nTotVal := 0
	nTotJur := 0
	nTotRec := 0
	nTotMul := 0
	nTotAbt := 0

	Do While !eof() .and. !lAbortPrint
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif

		@ LI,001 PSAY E1_CLIENTE+"/"+E1_LOJA
		@ LI,013 PSAY E1_NOMCLI
		@ LI,046 PSAY E1_PREFIXO
		@ LI,052 PSAY E1_NUM+"-"+E1_PARCELA
		@ LI,063 PSAY E1_TIPO
		@ LI,070 PSAY E1_VENCREA
		@ LI,083 PSAY E1_VALOR   Picture "@e 999,999,999.99"
		@ LI,102 PSAY E1_PORCJUR Picture "@e 999.99"
		@ LI,111 PSAY JURREAL    Picture "@e 999,999,999.99"
		@ LI,128 PSAY JUROS      Picture "@e 999,999,999.99"
		@ LI,145 PSAY MULTA      Picture "@e 999,999,999.99"
		@ LI,162 PSAY ABAT       Picture "@e 999,999,999.99"
		@ LI,179 PSAY Substr(E5_BANCO + " - " + A6_NOME,1,20)
		@ LI,202 PSAY X5_DESCRI
		nTotVal += E1_VALOR
		nTotJur += JURREAL
		nTotRec += JUROS
		nTotMul += MULTA
		nTotAbt += ABAT
		LI++

		dbSkip()
	Enddo
	dbCloseArea()

	if lImp .and. !lAbortPrint
		LI++
		@ LI,000 PSAY "T O T A L   D O S   J U R O S"
		@ LI,083 PSAY nTotVal Picture "@e 999,999,999.99"
		@ LI,111 PSAY nTotJur Picture "@e 999,999,999.99"
		@ LI,128 PSAY nTotRec Picture "@e 999,999,999.99"
		@ LI,145 PSAY nTotMul Picture "@e 999,999,999.99"
		@ LI,162 PSAY nTotAbt Picture "@e 999,999,999.99"
		roda(0,"",Tamanho)
	Endif


	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil