#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR92
	Private cString        := "SA5"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Custo de comissão"
	Private tamanho        := "M"
	Private nomeprog       := "DFATR92"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR92"
	Private titulo         := "Custo de comissão"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR92"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Do Vendedor        ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate o Vendedor     ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"03","Da Emissao         ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate a Emissao      ?"," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })


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
	Cabec1:=" ..."
	Cabec1:=" Vendedor   Nome                                            Faturamento         Comissão"
	        * XXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	        *            Motorista   Nome
	        *            XXXXXX      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999,999,999.99   999,999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	// Estrutura do Temporário
	aEstru := {}
	aadd(aEstru,{"T_VEND"   ,"C",06,0})
	aadd(aEstru,{"T_NOME"   ,"C",30,0})
	aadd(aEstru,{"T_TIPO"   ,"C",01,0})
	aadd(aEstru,{"T_SUB"    ,"C",06,0})
	aadd(aEstru,{"T_NOMSUB" ,"C",30,0})
	aadd(aEstru,{"T_FAT"    ,"N",14,2})
	aadd(aEstru,{"T_COMIS"  ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_VEND+T_TIPO+T_SUB",,.t.,"Selecionando Registros...")


	// Query
	cSql := "SELECT E1_VEND4  AS VENDEDOR"
	cSql += " ,     E1_VEND3  AS MOTORISTA"
	cSql += " ,     E1_VEND5  AS INDICADOR
	cSql += " ,     E1_VALOR  AS VALOR"
	cSql += " ,     A1_COMIS4 AS COMIS_V"
	cSql += " ,     A1_COMIS3 AS COMIS_M"
	cSql += " ,     A1_COMIS5 AS COMIS_I"
	cSql += " FROM "+RetSqlName("SE1")+" SE1"

	cSql += " LEFT JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = E1_CLIENTE"
	cSql += " AND  A1_LOJA = E1_LOJA"

	cSql += " WHERE SE1.D_E_L_E_T_ = ''"
	cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += " AND   E1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	cSql += " AND   E1_TIPO = 'NF'"
	cSql += " AND   E1_VEND4 <> ''"
	cSql += " AND   E1_VEND4 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " ORDER BY VENDEDOR"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.) })

	TcSetField("ARQ_SQL","VALOR"  ,"N",14,2)
	TcSetField("ARQ_SQL","COMIS_V","N",06,2)
	TcSetField("ARQ_SQL","COMIS_M","N",06,2)
	TcSetField("ARQ_SQL","COMIS_I","N",06,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	// Carrega Temporario
	Do While !eof()
		incProc("Carregando Temporário ...")
		// Soma Vendedor
		dbSelectArea("SA3")
		dbSeek(xFilial("SA3")+ARQ_SQL->VENDEDOR)

		dbSelectArea("TMP")
		dbSeek(ARQ_SQL->VENDEDOR+"0")
		If RecLock("TMP",!Found())
			TMP->T_VEND  := ARQ_SQL->VENDEDOR
			TMP->T_NOME  := SA3->A3_NOME
			TMP->T_TIPO  := "0"
			TMP->T_FAT   += ARQ_SQL->VALOR
			TMP->T_COMIS += ARQ_SQL->VALOR*(iif(ARQ_SQL->COMIS_V > 0 , ARQ_SQL->COMIS_V , SA3->A3_COMIS)/100)
			MsUnLock()
		Endif

		// Soma Motorista
		If !Empty(ARQ_SQL->MOTORISTA)
			dbSelectArea("SA3")
			dbSeek(xFilial("SA3")+ARQ_SQL->MOTORISTA)

			dbSelectArea("TMP")
			dbSeek(ARQ_SQL->VENDEDOR+"1"+ARQ_SQL->MOTORISTA)
			If RecLock("TMP",!Found())
				TMP->T_VEND   := ARQ_SQL->VENDEDOR
				TMP->T_TIPO   := "1"
				TMP->T_SUB    := ARQ_SQL->MOTORISTA
				TMP->T_NOMSUB := SA3->A3_NOME
				TMP->T_FAT    += ARQ_SQL->VALOR
				TMP->T_COMIS  += ARQ_SQL->VALOR*(iif(ARQ_SQL->COMIS_M > 0 , ARQ_SQL->COMIS_M , SA3->A3_COMIS)/100)
				MsUnLock()
			Endif
		Endif


		// Soma Indicador
		if !Empty(ARQ_SQL->INDICADOR)
			dbSelectArea("SA3")
			dbSeek(xFilial("SA3")+ARQ_SQL->INDICADOR)

			dbSelectArea("TMP")
			dbSeek(ARQ_SQL->VENDEDOR+"2"+ARQ_SQL->INDICADOR)
			If RecLock("TMP",!Found())
				TMP->T_VEND   := ARQ_SQL->VENDEDOR
				TMP->T_TIPO   := "2"
				TMP->T_SUB    := ARQ_SQL->INDICADOR
				TMP->T_NOMSUB := SA3->A3_NOME
				TMP->T_FAT    += ARQ_SQL->VALOR
				TMP->T_COMIS  += ARQ_SQL->VALOR*(iif(ARQ_SQL->COMIS_I > 0 , ARQ_SQL->COMIS_I , SA3->A3_COMIS)/100)
				MsUnLock()
			Endif
		Endif

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()



	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()

	Do While !eof()
		lImp     := .T.
		cVend    := T_VEND
		nTotVend := T_COMIS

		LI := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI += 2

		@ LI,001 PSAY T_VEND
		@ LI,012 PSAY T_NOME
		@ LI,057 PSAY T_FAT   Picture "@e 999,999,999.99"
		@ LI,074 PSAY T_COMIS Picture "@e 999,999,999.99"
		LI++
		dbSkip()

		Do While !eof() .AND. T_VEND = cVend
			cTipo   := T_TIPO
			nSubTot := 0

			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
			LI++
			@ LI,012 PSAY iif(cTipo="1","Motorista   Nome","Indicador   Nome")
			LI++
			@ LI,012 PSAY "----------------------------------------------------------------------------"
			LI++

			Do While !eof() .AND. T_VEND = cVend .AND. T_TIPO = cTipo
				IncProc("Imprimindo ...")
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
					LI+=2
				endif
				@ LI,012 PSAY T_SUB
				@ LI,024 PSAY T_NOMSUB
				@ LI,057 PSAY T_FAT   Picture "@e 999,999,999.99"
				@ LI,074 PSAY T_COMIS Picture "@e 999,999,999.99"
				nSubTot  += T_COMIS
				nTotVend += T_COMIS
				LI++
				dbSkip()
			Enddo
			LI++
			@ LI,012 PSAY "Total dos " + iif(cTipo="1","Motoristas","Indicadores")
			@ LI,074 PSAY nSubTot Picture "@e 999,999,999.99"
			LI++
		Enddo
		LI++
		@ LI,001 PSAY "Total do Vendedor"
		@ LI,074 PSAY nTotVend Picture "@e 999,999,999.99"
		LI++
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()

	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())
Return nil