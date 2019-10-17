#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVQGR01
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Vencidos X A Vencer"
	Private tamanho        := "M"
	Private nomeprog       := "DVQGR01"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := ""
	Private titulo         := "Vencidos X A Vencer"
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
	Cabec1 :="Data Base: 31/12/2006"
	Cabec2 :=" Tipo   Descrição                                 Carteira      (%)            Vencidos      (%)            A Vencer      (%)"

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
	cSql += "        AND   E1_VENCREA < '20061231'"
	cSql += "        AND   E1_BAIXA = ''"
	cSql += "        GROUP BY E1_TIPO"

	cSql += "        UNION"

	cSql += "        SELECT E1_TIPO AS TIPO"
	cSql += "        ,      0 AS VENCIDO"
	cSql += "        ,      SUM(E1_VALOR) AS AVENCER"
	cSql += "        FROM "+RetSqlName("SE1")
	cSql += "        WHERE D_E_L_E_T_ = ''"
	cSql += "        AND   E1_FILIAL = ''"
	cSql += "        AND   E1_VENCREA >= '20061231'"
	cSql += "        AND   E1_BAIXA = ''"
	cSql += "        GROUP BY E1_TIPO) AS TABTMP"

	cSql += " LEFT JOIN "+RetSqlName("SX5")
	cSql += " ON   D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = ''"
	cSql += " AND  X5_TABELA = '05'"
	cSql += " AND  X5_CHAVE = TIPO"

	cSql += " WHERE TIPO <> ''"
	cSql += " AND   TIPO NOT IN('NCC','CR ')"
	cSql += " GROUP BY TIPO,X5_DESCRI"
	cSql += " ORDER BY TIPO"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_TOT", .T., .T.)})
	TcSetField("ARQ_TOT","TOTVEN","N",14,2)
	TcSetField("ARQ_TOT","TOTAV" ,"N",14,2)

	LI+=3
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
		endif
	
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

	if !lAbortPrint
		LI++
		@ LI,001 PSAY "T O T A L"
		@ LI,041 PSAY nTotVen+nTotAV  Picture "@e 99,999,999,999.99"
		@ LI,061 PSAY 100             Picture "@e 999.99"
		@ LI,070 PSAY nTotVen         Picture "@e 99,999,999,999.99"
		@ LI,090 PSAY (nTotVen/(nTotVen+nTotAV))*100 Picture "@e 999.99"
		@ LI,099 PSAY nTotAV          Picture "@e 99,999,999,999.99"
		@ LI,119 PSAY (nTotAV/(nTotVen+nTotAV))*100  Picture "@e 999.99"
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil