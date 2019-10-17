#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVFISR01
	Private cString        := "SD2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Apuração de PIS/COFINS"
	Private tamanho        := "G"
	Private nomeprog       := "DVFISR01"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FISR01"
	Private titulo         := "Apuração de PIS/COFINS"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVFISR01"
	Private lImp           := .f.
	Private aRel           := {"Vendas que incidem","Vendas que nao incidem","Compras que incidem","Devolucoes de compra que incidem"}

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""           ,"","","","",""               ,"","","","",""           ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""           ,"","","","",""               ,"","","","",""           ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Da Filial          ?"," "," ","mv_ch3","C", 02,0,0,"G","","mv_par03",""           ,"","","","",""               ,"","","","",""           ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate a Filial       ?"," "," ","mv_ch4","C", 02,0,0,"G","","mv_par04",""           ,"","","","",""               ,"","","","",""           ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Apuracao           ?"," "," ","mv_ch5","N", 01,0,0,"C","","mv_par05","Vd. Incidem","","","","","Vd. não Incidem","","","","","Cp. Incidem","","","","","Dev. Incidem","","","","","","","","",""   ,"","","",""          })


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
	titulo := AllTrim(titulo) + " - " + aRel[mv_par05] + " - De "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	Cabec1:="                                                                                                                                                                                          %"
	Cabec2:="Data      Nota     It   CFOP   Produto           Descrição                        Cliente     Nome                                Quantidade           Valor    % PIS       Valor PIS   COFINS    Valor COFINS"
	        *99/99/99  XXXXXX   XX   XXXX   XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXX/XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999.99   99,999,999.99   999.99   99,999,999.99   999.99   99,999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
			*D2_EMISSAO     D2_DOC     D2_ITEM     D2_CF     D2_COD     B1_DESC                         D2_CLIENTE     D2_LOJA     A1_NOME                                   D2_QUANT     D2_TOTAL     B1_PPIS     PIS                   B1_PCOFINS     COFINS


	If mv_par05 <> 3
		cSql := ""
		cSql := cSql + "SELECT D2_EMISSAO,D2_DOC,D2_ITEM,D2_CF,D2_COD,B1_DESC,D2_CLIENTE,D2_LOJA
		If mv_par05 <> 4
			cSql := cSql + " ,A1_NOME AS NOME"
		Else
			cSql := cSql + " ,A2_NOME AS NOME"
		Endif
		cSql := cSql + " ,     D2_QUANT,D2_TOTAL,B1_PPIS,(D2_TOTAL*(B1_PPIS/100)) PIS,B1_PCOFINS,(D2_TOTAL*(B1_PCOFINS/100)) COFINS"

		cSql := cSql + " FROM "+RetSqlName("SD2")+" SD2"

		cSql := cSql + " JOIN "+RetSqlName("SF4")+" SF4"
		cSql := cSql + " ON   SF4.D_E_L_E_T_ = ''"
		cSql := cSql + " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
		cSql := cSql + " AND  F4_CODIGO = D2_TES"
		cSql := cSql + " AND  F4_DUPLIC = 'S'"

		cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
		cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
		cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
		cSql := cSql + " AND  B1_COD = D2_COD"
		If mv_par05 <> 2
			cSql := cSql + " AND  B1_PPIS = 1.65"
		Else
			cSql := cSql + " AND  B1_PPIS = 0"
		Endif

		If mv_par05 <> 4
			cSql := cSql + " JOIN "+RetSqlName("SA1")+" SA1"
			cSql := cSql + " ON   SA1.D_E_L_E_T_ = ''"
			cSql := cSql + " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
			cSql := cSql + " AND  A1_COD = D2_CLIENTE"
			cSql := cSql + " AND  A1_LOJA = D2_LOJA"
		Else
			cSql := cSql + " JOIN "+RetSqlName("SA2")+" SA2"
			cSql := cSql + " ON   SA2.D_E_L_E_T_ = ''"
			cSql := cSql + " AND  A2_FILIAL = '"+xFilial("SA2")+"'"
			cSql := cSql + " AND  A2_COD = D2_CLIENTE"
			cSql := cSql + " AND  A2_LOJA = D2_LOJA"
		Endif

		cSql := cSql + " WHERE SD2.D_E_L_E_T_ = ''"
		cSql := cSql + " AND   D2_FILIAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
		cSql := cSql + " AND   D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
		If mv_par05 <> 4
			cSql := cSql + " AND   D2_TIPO = 'N'"
		Else
			cSql := cSql + " AND   D2_TIPO = 'D'"
		Endif
		cSql := cSql + " ORDER BY D2_EMISSAO,D2_DOC,D2_ITEM"

		MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
		MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

		TcSetField("ARQ_SQL","D2_EMISSAO","D")
		TcSetField("ARQ_SQL","D2_QUANT"  ,"N",14,2)
		TcSetField("ARQ_SQL","D2_TOTAL"  ,"N",14,2)
	Else
		cSql := ""
		cSql := cSql + "SELECT D1_DTDIGIT,D1_DOC,D1_ITEM,D1_CF,D1_COD,B1_DESC,D1_FORNECE,D1_LOJA
		cSql := cSql + " ,     A2_NOME AS NOME"
		cSql := cSql + " ,     D1_QUANT,D1_TOTAL,B1_PPIS,(D1_TOTAL*(B1_PPIS/100)) PIS,B1_PCOFINS,(D1_TOTAL*(B1_PCOFINS/100)) COFINS"

		cSql := cSql + " FROM "+RetSqlName("SD1")+" SD1"

		cSql := cSql + " JOIN "+RetSqlName("SF4")+" SF4"
		cSql := cSql + " ON   SF4.D_E_L_E_T_ = ''"
		cSql := cSql + " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
		cSql := cSql + " AND  F4_CODIGO = D1_TES"
		cSql := cSql + " AND  F4_DUPLIC = 'S'"

		cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
		cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
		cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
		cSql := cSql + " AND  B1_COD = D1_COD"
		cSql := cSql + " AND  B1_PPIS = 1.65"

		cSql := cSql + " JOIN "+RetSqlName("SA2")+" SA2"
		cSql := cSql + " ON   SA2.D_E_L_E_T_ = ''"
		cSql := cSql + " AND  A2_FILIAL = '"+xFilial("SA2")+"'"
		cSql := cSql + " AND  A2_COD = D1_FORNECE"
		cSql := cSql + " AND  A2_LOJA = D1_LOJA"

		cSql := cSql + " WHERE SD1.D_E_L_E_T_ = ''"
		cSql := cSql + " AND   D1_FILIAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
		cSql := cSql + " AND   D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
		cSql := cSql + " AND   D1_TIPO = 'N'"
		cSql := cSql + " ORDER BY D1_DTDIGIT,D1_DOC,D1_ITEM"

		MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
		MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

		TcSetField("ARQ_SQL","D1_DTDIGIT","D")
		TcSetField("ARQ_SQL","D1_QUANT"  ,"N",14,2)
		TcSetField("ARQ_SQL","D1_TOTAL"  ,"N",14,2)
	Endif
	
	TcSetField("ARQ_SQL","B1_PPIS"   ,"N",06,2)
	TcSetField("ARQ_SQL","B1_PCOFINS","N",06,2)
	TcSetField("ARQ_SQL","PIS"       ,"N",14,2)
	TcSetField("ARQ_SQL","COFINS"    ,"N",14,2)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()
	aTotal := {0,0,0}

	Do While !eof()
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

		If mv_par05 <> 3
			@ LI,000 PSAY D2_EMISSAO
			@ LI,010 PSAY D2_DOC
			@ LI,019 PSAY D2_ITEM
			@ LI,024 PSAY D2_CF
			@ LI,031 PSAY D2_COD
			@ LI,049 PSAY B1_DESC
			@ LI,082 PSAY D2_CLIENTE+"/"+D2_LOJA
			@ LI,094 PSAY OemToAnsi(Substr(NOME,1,30))
			@ LI,127 PSAY D2_QUANT   Picture "@e 99,999,999.99"
			@ LI,143 PSAY D2_TOTAL   Picture "@e 99,999,999.99"
			aTotal[1] += D2_TOTAL
		Else
			@ LI,000 PSAY D1_DTDIGIT
			@ LI,010 PSAY D1_DOC
			@ LI,019 PSAY Substr(D1_ITEM,3,2)
			@ LI,024 PSAY D1_CF
			@ LI,031 PSAY D1_COD
			@ LI,049 PSAY B1_DESC
			@ LI,082 PSAY D1_FORNECE+"/"+D1_LOJA
			@ LI,094 PSAY OemToAnsi(Substr(NOME,1,30))
			@ LI,127 PSAY D1_QUANT   Picture "@e 99,999,999.99"
			@ LI,143 PSAY D1_TOTAL   Picture "@e 99,999,999.99"
			aTotal[1] += D1_TOTAL
		Endif

		@ LI,159 PSAY B1_PPIS    Picture "@e 999.99"
		@ LI,168 PSAY PIS        Picture "@e 99,999,999.99"
		@ LI,184 PSAY B1_PCOFINS Picture "@e 999.99"
		@ LI,193 PSAY COFINS     Picture "@e 99,999,999.99"
		aTotal[2] += PIS
		aTotal[3] += COFINS

		LI++
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		LI++
		@ LI,000 PSAY "T O T A L    G E R A L"
		@ LI,143 PSAY aTotal[1] Picture "@e 99,999,999.99"
		@ LI,168 PSAY aTotal[2] Picture "@e 99,999,999.99"
		@ LI,193 PSAY aTotal[3] Picture "@e 99,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil