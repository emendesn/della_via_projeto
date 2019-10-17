#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVFATR02
	Private cString        := "SF2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "NF - Transferencia"
	Private tamanho        := "M"
	Private nomeprog       := "DVFATR02"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFATR2"
	Private titulo         := "NF - Transferencia"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVFATR02"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Filial          ?"," "," ","mv_ch1","C", 02,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Filial       ?"," "," ","mv_ch2","C", 02,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Da Emissao         ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate a Emissao      ?"," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Imprime itens      ?"," "," ","mv_ch5","N", 01,0,0,"C","","mv_par05","Sim"    ,"","","","","Não"    ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"06","Considera Serie    ?"," "," ","mv_ch6","N", 01,0,0,"C","","mv_par06","Sim"    ,"","","","","Não"    ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })


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
	Cabec1:=" Origem   Destino   Emissao    NF       Serie"
	Cabec2:="          Codigo            Descrição                               Quantidade       Vlr. Unitario           Vlr Total"
	        * XX       XX        99/99/99   XXXXXX   XXX
	        *          XXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22


	Titulo := AllTrim(Titulo) + " - " + iif(mv_par06=1,"Considera serie","Ignora serie")


	// Query
	cSql := "SELECT F2_FILIAL,F2_LOJA,F2_EMISSAO,F2_DOC,F2_SERIE"
	If mv_par05 = 1
		cSql += " ,     D2_COD,B1_DESC,D2_QUANT,D2_PRCVEN,D2_TOTAL"
	Endif
	cSql += " FROM "+RetSqlName("SF2")+" SF2"

	cSql += " LEFT JOIN "+RetSqlName("SF1")+" SF1"
	cSql += " ON   SF1.D_E_L_E_T_ = ''"
	cSql += " AND  F1_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND  F1_DOC = F2_DOC"
	if mv_par06 = 1
		cSql += " AND  F1_SERIE = F2_SERIE"
	Endif
	cSql += " AND  F1_FORNECE = '000500'"
	cSql += " AND  F1_LOJA = F2_FILIAL"	

	If mv_par05 = 1
		cSql += " JOIN "+RetSqlName("SD2")+" SD2"
		cSql += " ON   SD2.D_E_L_E_T_ = ''"
		cSql += " AND  D2_FILIAL = F2_FILIAL"
		cSql += " AND  D2_DOC = F2_DOC"
		cSql += " AND  D2_SERIE = F2_SERIE"

		cSql += " LEFT JOIN "+RetSqlName("SB1")+" SB1"
		cSql += " ON   SB1.D_E_L_E_T_ = ''"
		cSql += " AND  B1_FILIAL = ''"
		cSql += " AND  B1_COD = D2_COD"
	Endif

	cSql += " WHERE SF2.D_E_L_E_T_ = ''"
	cSql += " AND   F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   F2_CLIENTE = '15LQFY'"
	cSql += " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	cSql += " AND   F1_DOC IS NULL"
	cSql += " ORDER BY F2_FILIAL,F2_DOC,F2_SERIE"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})


	TcSetField("ARQ_SQL","F2_EMISSAO","D")
	if mv_par05 = 1
		TcSetField("ARQ_SQL","D2_QUANT"  ,"N",14,2)
		TcSetField("ARQ_SQL","D2_PRCVEN" ,"N",14,2)
		TcSetField("ARQ_SQL","D2_TOTAL"  ,"N",14,2)
	Else
		Cabec2 := ""
		Tamanho := "P"
	Endif
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
		IncProc("Imprimindo ...")

		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif

		@ LI,001 PSAY F2_FILIAL
		@ LI,010 PSAY F2_LOJA
		@ LI,020 PSAY F2_EMISSAO
		@ LI,031 PSAY F2_DOC
		@ LI,040 PSAY F2_SERIE
		LI++

		cChave := F2_FILIAL+F2_DOC+F2_SERIE
		Do while mv_par05 = 1 .and. !eof() .and. F2_FILIAL+F2_DOC+F2_SERIE = cChave
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
			@ LI,010 PSAY D2_COD
			@ LI,028 PSAY B1_DESC
			@ LI,061 PSAY D2_QUANT  Picture "@e 99,999,999,999.99"
			@ LI,081 PSAY D2_PRCVEN Picture "@e 99,999,999,999.99"
			@ LI,101 PSAY D2_TOTAL  Picture "@e 99,999,999,999.99"
			LI++
			dbSkip()
		Enddo

		if mv_par05 = 2
			dbSkip()
		Else
			@ LI,000 PSAY IniFatLine+FimFatLine
			LI+=2
		Endif
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil