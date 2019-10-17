#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR85
	Private cString        := ""
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Posição Cliente - Recusado / Produzido"
	Private tamanho        := "G"
	Private nomeprog       := "DFATR85"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFAT85"
	Private titulo         := "Posição Cliente - Recusado / Produzido"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR85"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Do Cliente         ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"04","Ate o Cliente      ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"05","Do Tipo de Saida   ?"," "," ","mv_ch5","C", 03,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SF4","","","",""          })
	AADD(aRegs,{cPerg,"06","Ate o Tipo de Saida?"," "," ","mv_ch6","C", 03,0,0,"G","","mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SF4","","","",""          })
	AADD(aRegs,{cPerg,"07","Do Grupo           ?"," "," ","mv_ch7","C", 04,0,0,"G","","mv_par07",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	AADD(aRegs,{cPerg,"08","Ate o Grupo        ?"," "," ","mv_ch8","C", 04,0,0,"G","","mv_par08",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })

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
	Cabec1:="     Pedido   Emissao    Nota Fisca   Tipo de Saida   Grupo   Produto           Descrição                               Quantidade       Prc. Unitario"
	        *     XXXXXX   99/99/99   XXXXXX       999             XXXX    XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999.99   99,999,999,999.99   x
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cSql := "SELECT C5_CLIENTE,C5_LOJACLI,A1_NOME,C6_NUM,C5_EMISSAO,C6_NOTA,C6_TES,B1_GRUPO,C6_PRODUTO,B1_DESC,C6_QTDVEN,C6_PRCVEN"
	cSql += " FROM "+RetSqlName("SC5")+" SC5"
	cSql += " ,    "+RetSqlName("SC6")+" SC6"
	cSql += " ,    "+RetSqlName("SB1")+" SB1"
	cSql += " ,    "+RetSqlName("SA1")+" SA1"
	cSql += " WHERE SC5.D_E_L_E_T_ = ''"
	cSql += " AND   SC6.D_E_L_E_T_ = ''"
	cSql += " AND   SB1.D_E_L_E_T_ = ''"
	cSql += " AND   SA1.D_E_L_E_T_ = ''"
	cSql += " AND   C5_FILIAL = '"+xFilial("SC5")+"'"
	cSql += " AND   C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   C5_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   C6_FILIAL = C5_FILIAL"
	cSql += " AND   C6_NUM = C5_NUM"
	cSql += " AND   C6_TES BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND   B1_COD = C6_PRODUTO"
	cSql += " AND   B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND   A1_COD = C5_CLIENTE"
	cSql += " AND   A1_LOJA = C5_LOJACLI"
	cSql += " ORDER BY C5_CLIENTE,C6_NUM"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","C5_EMISSAO","D")
	TcSetField("ARQ_SQL","C6_QTDVEN","N",14,2)
	TcSetField("ARQ_SQL","C6_PRCVEN","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	nTotGer := 0
	nTotCli := 0

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
	
		@ LI,001 PSAY C5_CLIENTE+"/"+C5_LOJACLI+" - "+A1_NOME
		LI++
		cChave := C5_CLIENTE+C5_LOJACLI
		nTotCli := 0
		
		Do While !eof() .and. C5_CLIENTE+C5_LOJACLI = cChave
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
			@ LI,005 PSAY C6_NUM
			@ LI,014 PSAY C5_EMISSAO
			@ LI,025 PSAY C6_NOTA
			@ LI,038 PSAY C6_TES
			@ LI,054 PSAY B1_GRUPO
			@ LI,062 PSAY C6_PRODUTO
			@ LI,080 PSAY B1_DESC
			@ LI,113 PSAY C6_QTDVEN Picture "@e 99,999,999,999.99"
			@ LI,133 PSAY C6_PRCVEN Picture "@e 99,999,999,999.99"
			if C6_TES = "903"
				@ LI,153 PSAY "Recusado"
			Endif
			nTotCli += C6_QTDVEN
			nTotGer += C6_QTDVEN
			LI++
			dbSkip()
		Enddo
		@ LI,001 PSAY "Total do Cliente"
		@ LI,113 PSAY nTotCli Picture "@e 99,999,999,999.99"
		LI+=2
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		@ LI,001 PSAY "Total Geral"
		@ LI,113 PSAY nTotGer Picture "@e 99,999,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil