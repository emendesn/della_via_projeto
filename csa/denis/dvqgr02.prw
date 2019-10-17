#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVQGR02
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Pagar / Receber"
	Private tamanho        := "G"
	Private nomeprog       := "DVQGR02"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := ""
	Private titulo         := "Pagar / Receber"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := ""
	Private lImp           := .F.

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
	Cabec1 :=" Movimento   Fornecedor / Cliente                                   Prf   Documento   Parcela   Tipo   Emissao    Vencimento               Valor              Baixas"
             * XXXXXXX     XXXXXX-XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXX   XXXXXX      X         X      99/99/99   99/99/99     99,999,999,999.99   99,999,999,999.99
             *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
             *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22


	cSql := "SELECT 'PAGAR' AS RECPAG"
	cSql += " ,     E2_FORNECE AS CLIFOR"
	cSql += " ,     E2_LOJA AS LOJA"
	cSql += " ,     A2_NOME AS NOME"
	cSql += " ,     E2_PREFIXO AS PREFIXO"
	cSql += " ,     E2_NUM AS NUM"
	cSql += " ,     E2_PARCELA AS PARCELA"
	cSql += " ,     E2_TIPO AS TIPO"
	cSql += " ,     E2_EMISSAO AS EMISSAO"
	cSql += " ,     E2_VENCTO AS VENCTO"
	cSql += " ,     E2_VALOR AS VALOR"
	cSql += " ,     SUM(E5_VALOR) AS MOV"
	cSql += " FROM SE5010 SE5"

	cSql += " JOIN SE2010 SE2"
	cSql += " ON   SE2.D_E_L_E_T_ = ''"
	cSql += " AND  E2_FILIAL = E5_FILIAL"
	cSql += " AND  E2_PREFIXO = E5_PREFIXO"
	cSql += " AND  E2_NUM = E5_NUMERO"
	cSql += " AND  E2_PARCELA = E5_PARCELA"
	cSql += " AND  E2_TIPO = E5_TIPO"
	cSql += " AND  E2_FORNECE = E5_CLIFOR"
	cSql += " AND  E2_LOJA = E5_LOJA"

	cSql += " JOIN SA2010 SA2"
	cSql += " ON   SA2.D_E_L_E_T_ = ''"
	cSql += " AND  A2_FILIAL = ''"
	cSql += " AND  A2_COD = E2_FORNECE"
	cSql += " AND  A2_LOJA = E2_LOJA"

	cSql += " WHERE SE5.D_E_L_E_T_ = ''"
	cSql += " AND   E5_FILIAL = ''"
	cSql += " AND   E5_DATA >= '20070101'"
	cSql += " AND   E5_RECPAG = 'P'"
	cSql += " AND   E5_TIPODOC IN('BA','LJ','VL')"
	cSql += " GROUP BY E2_FORNECE,E2_LOJA,A2_NOME,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_EMISSAO,E2_VENCTO,E2_VALOR"

	cSql += " UNION"

	cSql += " SELECT 'RECEBER' AS RECPAG"
	cSql += " ,     E1_CLIENTE AS CLIFOR"
	cSql += " ,     E1_LOJA AS LOJA"
	cSql += " ,     A1_NOME AS NOME"
	cSql += " ,     E1_PREFIXO AS PREFIXO"
	cSql += " ,     E1_NUM AS NUM"
	cSql += " ,     E1_PARCELA AS PARCELA"
	cSql += " ,     E1_TIPO AS TIPO"
	cSql += " ,     E1_EMISSAO AS EMISSAO"
	cSql += " ,     E1_VENCTO AS VENCTO"
	cSql += " ,     E1_VALOR AS VALOR"
	cSql += " ,     SUM(E5_VALOR) AS MOV"
	cSql += " FROM SE5010 SE5"

	cSql += " JOIN SE1010 SE1"
	cSql += " ON   SE1.D_E_L_E_T_ = ''"
	cSql += " AND  E1_FILIAL = E5_FILIAL"
	cSql += " AND  E1_PREFIXO = E5_PREFIXO"
	cSql += " AND  E1_NUM = E5_NUMERO"
	cSql += " AND  E1_PARCELA = E5_PARCELA"
	cSql += " AND  E1_TIPO = E5_TIPO"
	cSql += " AND  E1_CLIENTE = E5_CLIFOR"
	cSql += " AND  E1_LOJA = E5_LOJA"

	cSql += " JOIN SA1010 SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = ''"
	cSql += " AND  A1_COD = E1_CLIENTE"
	cSql += " AND  A1_LOJA = E1_LOJA"

	cSql += " WHERE SE5.D_E_L_E_T_ = ''"
	cSql += " AND   E5_FILIAL = ''"
	cSql += " AND   E5_DATA >= '20070101'"
	cSql += " AND   E5_RECPAG = 'R'"
	cSql += " AND   E5_TIPODOC IN('BA','LJ','VL')"
	cSql += " GROUP BY E1_CLIENTE,E1_LOJA,A1_NOME,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_EMISSAO,E1_VENCTO,E1_VALOR"
	cSql += " ORDER BY RECPAG,CLIFOR,LOJA,PREFIXO,NUM,PARCELA"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","EMISSAO","D")
	TcSetField("ARQ_SQL","VENCTO" ,"D")
	TcSetField("ARQ_SQL","VALOR"  ,"N",14,2)
	TcSetField("ARQ_SQL","MOV"    ,"N",14,2)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)

	Do While !eof()

		cMov := RECPAG
		LI:=99
		nSubTot1 := 0
		nSubTot2 := 0

		Do While !eof() .AND. cMov = RECPAG
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
	
			@ LI,001 PSAY RECPAG
			@ LI,013 PSAY CLIFOR+"-"+LOJA
			@ LI,025 PSAY NOME
			@ LI,068 PSAY PREFIXO
			@ LI,074 PSAY NUM
			@ LI,086 PSAY PARCELA
			@ LI,096 PSAY TIPO
			@ LI,103 PSAY EMISSAO
			@ LI,114 PSAY VENCTO
			@ LI,127 PSAY VALOR Picture "@e 99,999,999,999.99"
			@ LI,147 PSAY MOV   Picture "@e 99,999,999,999.99"
			LI++

			nSubTot1 += VALOR
			nSubTot2 += MOV

			dbSkip()
		Enddo

		@ LI,001 PSAY "TOTAL "+cMov
		@ LI,127 PSAY nSubTot1 Picture "@e 99,999,999,999.99"
		@ LI,147 PSAY nSubTot2 Picture "@e 99,999,999,999.99"

	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil