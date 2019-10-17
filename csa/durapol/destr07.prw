#include "Dellavia.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR07   บAutor  ณ Reinaldo Caldas    บ Data ณ  27/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Controle de Producao Mensal                              ) บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol Renovadora de Pneus LTDA.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
12/03/07 - Denis Tofoli - Desmembrar coluna de Produzidos em: Recapagens,
                          Recauchutagens, Consertos e criar a coluna Total.
04/04/07 - Denis Tofoli - Somar valores na query eliminando la็o totalizador,
                          Recapagens e consertos pela Data AutoClave e 
                          recauchutagem pela data de produ็ใo.
09/04/07 - Denis Tofoli - Criar coluna de revisados no exame inicial.
*/

User Function DESTR07()
	Private cString     := "SC2"
	Private aOrd 		:= {}
	Private CbTxt       := ""
	Private cDesc1      := "Este relatorio ira imprimir as informacoes de acordo"
	Private cDesc2      := "com os dados informados nos parametros pelo usuario."
	Private cDesc3      := "Controle de Producao Mensal"
	Private cPict       := ""
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 78
	Private tamanho     := "M"
	Private nomeprog    := "DESTR07"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private titulo      := "Controle de Producao Mensal"
	Private nLin        := 80
	Private nPag		:= 0
	Private Cabec1      := ""
	Private Cabec2      := ""
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private imprime     := .T.
	Private wnrel      	:= "DESTR07"
	Private _cPerg     	:= "DEST07"

	_aRegs:={}
	AAdd(_aRegs,{_cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

	ValidPerg(_aRegs,_cPerg)
	Pergunte(_cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	Processa( {|| ImpRel() } )
Return

Static Function ImpRel()
	Local cSql     := ""
	Local aTotGer   := {0,0,0,0,0,0}

	Cabec1:=" De "+dtoc(mv_par01)+" at้ "+dtoc(mv_par02)
	Cabec2:=" Medida              Recapados   Recauchutados     Consertos   Rec. AutoCalve    Rec. Exame         Total"
	        * XXXXXXXXXXXXXXX   999,999,999     999,999,999   999,999,999      999,999,999   999,999,999   999,999,999
	        *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	
	cSql := "SELECT C2_PRODUTO"
	cSql += " ,     SUM(RECAPA) AS RECAPA"
	cSql += " ,     SUM(RECAUC) AS RECAUC"
	cSql += " ,     SUM(CONSERTO) AS CONSERTO"
	cSql += " ,     SUM(RECUSA) AS RECUSA"
	cSql += " ,     SUM(EXREC) AS EXREC"
	cSql += " ,     SUM(TOTAL) AS TOTAL"
	cSql += " FROM ("

	cSql += "SELECT C2_PRODUTO"
	cSql += " ,     0 AS RECAPA"
	cSql += " ,     SUM(CASE WHEN C2_PERDA <= 0 THEN C2_QUANT ELSE 0 END) AS RECAUC"
	cSql += " ,     0 AS CONSERTO"
	cSql += " ,     0 AS RECUSA"
	cSql += " ,     0 AS EXREC"
	cSql += " ,     SUM(CASE WHEN C2_PERDA <= 0 THEN C2_QUANT ELSE 0 END) AS TOTAL"
	cSql += " FROM "+RetSqlName("SC2")+" SC2"

	cSql += " JOIN "+RetSqlName("SD1")+" SD1"
	cSql += " ON   D1_FILIAL = C2_FILIAL"
	cSql += " AND  D1_DOC = C2_NUMD1"
	cSql += " AND  D1_SERIE = C2_SERIED1"
	cSql += " AND  D1_ITEM = C2_ITEMD1"
	cSql += " AND  D1_FORNECE = C2_FORNECE"
	cSql += " AND  D1_LOJA = C2_LOJA"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D1_SERVICO"
	cSql += " AND  B1_X_GRUPO = 'T'"

	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
	cSql += " AND   C2_DATRF BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
	cSql += " GROUP BY C2_PRODUTO"

	cSql += " UNION "

	cSql += "SELECT C2_PRODUTO"
	cSql += " ,     0 AS RECAPA"
	cSql += " ,     0 AS RECAUC"
	cSql += " ,     0 AS CONSERTO"
	cSql += " ,     0 AS RECUSA"
	cSql += " ,     SUM(CASE WHEN C2_PERDA > 0 THEN C2_PERDA ELSE 0 END) AS EXREC"
	cSql += " ,     SUM(CASE WHEN C2_PERDA > 0 THEN C2_PERDA ELSE 0 END) AS TOTAL"
	cSql += " FROM "+RetSqlName("SC2")+" SC2"

	cSql += " JOIN "+RetSqlName("SD1")+" SD1"
	cSql += " ON   D1_FILIAL = C2_FILIAL"
	cSql += " AND  D1_DOC = C2_NUMD1"
	cSql += " AND  D1_SERIE = C2_SERIED1"
	cSql += " AND  D1_ITEM = C2_ITEMD1"
	cSql += " AND  D1_FORNECE = C2_FORNECE"
	cSql += " AND  D1_LOJA = C2_LOJA"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D1_SERVICO"
	cSql += " AND  B1_X_GRUPO IN('R','C')"

	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
	cSql += " AND   C2_DATRF BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
	cSql += " AND   C2_XDTCLAV = ''"
	cSql += " GROUP BY C2_PRODUTO"

	cSql += " UNION "

	cSql += "SELECT C2_PRODUTO"
	cSql += " ,     SUM(CASE WHEN C2_PERDA <= 0 AND B1_X_GRUPO = 'R' THEN C2_QUANT ELSE 0 END) AS RECAPA"
	cSql += " ,     0 AS RECAUC"
	cSql += " ,     SUM(CASE WHEN C2_PERDA <= 0 AND B1_X_GRUPO = 'C' THEN C2_QUANT ELSE 0 END) AS CONSERTO"
	cSql += " ,     SUM(CASE WHEN C2_PERDA > 0 THEN C2_PERDA ELSE 0 END) AS RECUSA"
	cSql += " ,     0 AS EXREC"
	cSql += " ,     SUM(CASE WHEN C2_PERDA > 0 THEN C2_PERDA ELSE C2_QUANT END) AS TOTAL"
	cSql += " FROM "+RetSqlName("SC2")+" SC2"

	cSql += " JOIN "+RetSqlName("SD1")+" SD1"
	cSql += " ON   D1_FILIAL = C2_FILIAL"
	cSql += " AND  D1_DOC = C2_NUMD1"
	cSql += " AND  D1_SERIE = C2_SERIED1"
	cSql += " AND  D1_ITEM = C2_ITEMD1"
	cSql += " AND  D1_FORNECE = C2_FORNECE"
	cSql += " AND  D1_LOJA = C2_LOJA"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D1_SERVICO"

	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
	cSql += " AND   C2_XDTCLAV BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
	cSql += " GROUP BY C2_PRODUTO"

	cSql += " ) AS TABTMP"

	cSql += " GROUP BY C2_PRODUTO"
	cSql += " ORDER BY C2_PRODUTO"

	IF Select("ARQ_SQL") > 0
		ARQ_SQL->(dbCloseArea())
	EndIF
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"ARQ_SQL",.F.,.T.)
	TcSetField("ARQ_SQL","RECAPA"  ,"N",11,0)
	TcSetField("ARQ_SQL","RECAUC"  ,"N",11,0)
	TcSetField("ARQ_SQL","CONSERTO","N",11,0)
	TcSetField("ARQ_SQL","RECUSA"  ,"N",11,0)
	TcSetField("ARQ_SQL","EXREC"   ,"N",11,0)
	TcSetField("ARQ_SQL","TOTAL"   ,"N",11,0)

	dbSelectArea("ARQ_SQL")
	dbGoTop()

	ProcRegua(0)

	While ! Eof()
		IncProc("Imprimindo ...")

		IF nLin > 55
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF

		@ nLin,001 Psay C2_PRODUTO
		@ nLin,019 Psay RECAPA   Picture "@E 999,999,999"
		@ nLin,035 Psay RECAUC   Picture "@E 999,999,999"
		@ nLin,049 Psay CONSERTO Picture "@E 999,999,999"
		@ nLin,066 Psay RECUSA   Picture "@E 999,999,999"
		@ nLin,080 Psay EXREC    Picture "@E 999,999,999"
		@ nLin,094 Psay TOTAL    Picture "@E 999,999,999"
		nLin ++

		aTotGer[1] += RECAPA
		aTotGer[2] += RECAUC
		aTotGer[3] += CONSERTO
		aTotGer[4] += RECUSA
		aTotGer[5] += EXREC
		aTotGer[6] += TOTAL

		dbSkip()
	EndDo
	dbCloseArea()

	IF nLin != 80
		IF nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		nLin := nLin + 2
		@ nLin,001 Psay "Total:"
		@ nLin,019 Psay aTotGer[1] Picture "@E 999,999,999"
		@ nLin,035 Psay aTotGer[2] Picture "@E 999,999,999"
		@ nLin,049 Psay aTotGer[3] Picture "@E 999,999,999"
		@ nLin,066 Psay aTotGer[4] Picture "@E 999,999,999"
		@ nLin,080 Psay aTotGer[5] Picture "@E 999,999,999"
		@ nLin,094 Psay aTotGer[6] Picture "@E 999,999,999"
		nLin := nLin + 4
		@ nLin,001 Psay "*  As recapagens e os consertos sใo totalizados pela Data da AutoClave."
		nLin ++
		@ nLin,001 Psay "** As recauchutagens sใo totalizadas pela Data de produ็ใo."
		Roda(cbcont,cbtxt,tamanho)
	EndIF

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	EndiF

	MS_FLUSH()
Return