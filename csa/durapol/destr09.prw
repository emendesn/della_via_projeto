#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR09     บ Autor ณ Jader            บ Data ณ  27/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio diario de produto x banda                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function DESTR09()

LOCAL cDesc1         := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2         := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3         := "Resumo Bandas Producao"
LOCAL cPict          := ""
LOCAL titulo         := "Resumo Bandas Producao"
LOCAL nLin           := 80
LOCAL Cabec1         := "cabec1"
LOCAL Cabec2         := "cabec2"
LOCAL imprime        := .T.
LOCAL aOrd           := {}
LOCAL aPergunta         :={}
PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 80
PRIVATE tamanho      := "P"
PRIVATE nomeprog     := "DESTR09"
PRIVATE nTipo        := 15
PRIVATE aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
PRIVATE nLastKey     := 0
PRIVATE cPerg        := "ESTR09"
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "DESTR09"
PRIVATE cString      := "SC2"

dbSelectArea("SC2")
dbSetOrder(1)

AAdd(aPergunta,{cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aPergunta,cPerg)

pergunte(cPerg,.F.)

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


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Jader              บ Data ณ  27/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION RunReport(Cabec1,Cabec2,Titulo,nLin)

LOCAL nOrdem
LOCAL cQuery   := ''
LOCAL nTotPneu := 0
LOCAL nCount   := 0

SetRegua(100)

IncRegua()

cQuery := "SELECT D3_COD, C2_X_DESEN, B1_XLARG, SUM(D3_QUANT) D3_QUANT "
////////cQuery := "SELECT D3_COD, C2_X_DESEN, B1_IPI, SUM(D3_QUANT) D3_QUANT "
cQuery += "  ,SUM(C2_QUANT) AS PNEUS"
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
cQuery += "   AND B1_COD = D3_COD "
cQuery += "   AND B1_GRUPO = 'BAND' "
cQuery += "   AND D3_ESTORNO <> 'S' "
cQuery += "   AND D3_EMISSAO >= '"+DTOS(mv_par01)+"' "
cQuery += "   AND D3_EMISSAO <= '"+DTOS(mv_par02)+"' "
cQuery += " GROUP BY D3_COD, C2_X_DESEN, B1_XLARG "
cQuery += " ORDER BY D3_COD, C2_X_DESEN, B1_XLARG "
//////cQuery += " GROUP BY D3_COD, C2_X_DESEN, B1_IPI "
/////cQuery += " ORDER BY D3_COD, C2_X_DESEN, B1_IPI "

IncRegua()

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TRB",.F.,.T.)

Titulo  := "Resumo Bandas Producao"
Cabec1  := ' Medida          Desenho         Largura   Kg Total         Pneus'
Cabec2  := ' '
//           123456789012345 123456789012345 999,999 99,999,999    99,999,999
//           12345678901234567890123456789012345678901234567890123456789012345678901234567890
//                   1         2         3         4         5         6         7         8

nTotPneu := 0
nTotProd := 0
nCount   := 0
    
dbSelectArea("TRB")
dbGotop()

While !EOF()

	IncRegua()

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		lQuebra := .T.
	Endif
	
	If TRB->D3_QUANT == 0
		dbSkip()
		Loop
	Endif	

    @ nLin,001 PSAY TRB->D3_COD
    @ nLin,017 PSAY TRB->C2_X_DESEN
    @ nLin,033 PSAY TRB->B1_XLARG    Picture "@E 999,999"
    /////////@ nLin,033 PSAY TRB->B1_IPI      Picture "@E 999,999"
    @ nLin,041 PSAY TRB->D3_QUANT    Picture "@E 99,999,999"
    @ nLin,055 PSAY TRB->PNEUS    Picture "@E 99,999,999"
	    
	nTotPneu += TRB->D3_QUANT
	nTotProd += TRB->PNEUS
	
	nLin ++
	
	dbSkip()
	
	nCount ++
	
	If nCount > 100
		SetRegua(100)
		nCount := 0
	Endif	
	
EndDo

nLin++

If nTotPneu > 0

	@ nLin,001 PSAY "TOTAL "
    @ nLin,041 PSAY nTotPneu Picture "@E 99,999,999"
    @ nLin,055 PSAY nTotProd Picture "@E 99,999,999"

Endif	
	
dbSelectArea("TRB")
dbCloseArea("TRB")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return