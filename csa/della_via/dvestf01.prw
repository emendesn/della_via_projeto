#include "rwmake.ch"
#include "topconn.ch"

User Function DVESTF01
	Private Titulo   := "Consumo Mes a Mes"
	Private aSays    := {}
	Private aButtons := {}
	Private cPerg    := "DEST01"


	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Mes Referencia     ?"," "," ","mv_ch1","C", 07,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","","99/9999"})
	aAdd(aRegs,{cPerg,"02","Da Filial          ?"," "," ","mv_ch2","C", 02,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })
	aAdd(aRegs,{cPerg,"03","Ate a Filial       ?"," "," ","mv_ch3","C", 02,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""       })

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

	// Monta a tela
	aAdd(aSays,"Esta rotina calcula o consumo de cada produto e grava na tabela de consumo mes a mes")
	aAdd(aSays,"(ZX0), calculando também a media dentro do ano e a curva ABC dos produtos.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcAtu() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                           }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                    }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcAtu()
	Local cSql     := ""
	Local cDataIni := Substr(mv_par01,4,4)+Substr(mv_par01,1,2)+"01"
	Local cDataFim := ""
	Local nInicio  := Seconds()

	IF Val(Substr(mv_par01,4,4)) < 2000
		msgbox("Ano inválido","Ano","STOP")
		Return
	Endif

	IF Val(Substr(mv_par01,1,2)) < 0 .OR. Val(Substr(mv_par01,1,2)) > 12
		msgbox("Mês inválido","Mes","STOP")
		Return
	Endif

	If Val(Substr(mv_par01,1,2))+1 = 13
		cDataFim := dtos(stod(StrZero(Val(Substr(mv_par01,4,4))+1,4)+"0101")-1)
	Else
		cDataFim := dtos(stod(Substr(mv_par01,4,4)+StrZero(Val(Substr(mv_par01,1,2))+1,2)+"01")-1)
	Endif 

	FechaBatch()

	cSql := "UPDATE "+RetSqlName("ZX0")
	cSql += " SET   ZX0_Q"+Substr(mv_par01,1,2)+" = 0"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZX0_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"

	nUpdt := 0
	TcSqlExec(cSql)

	If nUpdt < 0
		MsgBox(TcSqlError(),"Mes a Mes","STOP")
	Endif


	cSql := " SELECT D3_FILIAL AS FILIAL"
	cSql += " ,      D3_COD AS COD"
	cSql += " ,      B1_GRUPO AS GRUPO"
	cSql += " ,      SUM(D3_QUANT) AS QUANT"
	cSql += " FROM "+RetSqlName("SD3")+" SD3"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D3_COD"

	cSql += " WHERE SD3.D_E_L_E_T_ = ''"
	cSql += " AND   D3_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cSql += " AND   D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"
	cSql += " AND   SUBSTR(D3_CF,1,1) = 'R'"
	cSql += " AND   D3_CF <> 'RE4'"
	cSql += " GROUP BY D3_FILIAL,D3_COD,B1_GRUPO"

	cSql += " UNION ALL"

	cSql += " SELECT D2_FILIAL AS FILIAL"
	cSql += " ,      D2_COD AS COD"
	cSql += " ,      B1_GRUPO AS GRUPO"
	cSql += " ,      SUM(D2_QUANT) AS QUANT"
	cSql += " FROM "+RetSqlName("SD2")+" SD2"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = D2_COD"

	cSql += " JOIN "+RetSqlName("SF4")+" SF4"
	cSql += " ON   SF4.D_E_L_E_T_ = ''"
	cSql += " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
	cSql += " AND  F4_CODIGO = D2_TES"
	cSql += " AND  F4_ESTOQUE = 'S'"
	cSql += " AND  F4_CF NOT IN('5152','6152','5409','6409')"

	cSql += " WHERE SD2.D_E_L_E_T_ = ''"
	cSql += " AND   D2_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cSql += " AND   D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"
	cSql += " AND   D2_TIPO = 'N'"
	cSql += " GROUP BY D2_FILIAL,D2_COD,B1_GRUPO"

	cSql += " ORDER BY FILIAL,COD"

	MsgRun("Lendo movimentação do período ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","QUANT","N",14,2)

	dbSelectArea("ARQ_SQL")
	dbGoTop()

	dbSelectArea("ZX0")
	nPosCpo := FieldPos("ZX0_Q"+Substr(mv_par01,1,2))

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)

	Do While !eof()
		incProc(FILIAL+" - "+COD)
		dbSelectArea("ZX0")
		dbSeek(ARQ_SQL->(FILIAL+COD))
		if RecLock("ZX0",!Found())
			ZX0->ZX0_FILIAL := ARQ_SQL->FILIAL
			ZX0->ZX0_COD    := ARQ_SQL->COD
			ZX0->ZX0_GRUPO  := ARQ_SQL->GRUPO
			FieldPut(nPosCpo,FieldGet(nPosCpo)+ARQ_SQL->QUANT)
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()

	cSql := "SELECT DISTINCT B2_FILIAL AS FILIAL"
	cSql += " ,     B2_COD AS COD"
	cSql += " ,     B1_GRUPO AS GRUPO"
	cSql += " FROM "+RetSqlName("SB2")+" SB2"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = B2_COD"

	cSql += " WHERE SB2.D_E_L_E_T_ = ''"
	cSql += " AND   B2_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cSql += " AND   B2_FILIAL || B2_COD"
	cSql += " NOT IN(SELECT DISTINCT ZX0_FILIAL || ZX0_COD FROM "+RetSqlName("ZX0")
	cSql += " WHERE D_E_L_E_T_ = '' AND ZX0_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"')"
	cSql += " ORDER BY FILIAL,COD"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	Do While !eof()
		incProc(FILIAL+" - "+COD)
		dbSelectArea("ZX0")
		if RecLock("ZX0",.T.)
			ZX0->ZX0_FILIAL := ARQ_SQL->FILIAL
			ZX0->ZX0_COD    := ARQ_SQL->COD
			ZX0->ZX0_GRUPO  := ARQ_SQL->GRUPO
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()


	cSql := "UPDATE "+RetSqlName("ZX0")
	cSql += " SET   ZX0_TOTAL = (ZX0_Q01+ZX0_Q02+ZX0_Q03+ZX0_Q04+ZX0_Q05+ZX0_Q06+ZX0_Q07+ZX0_Q08+ZX0_Q09+ZX0_Q10+ZX0_Q11+ZX0_Q12)"
	cSql += " ,     ZX0_MEDIA = (ZX0_Q01+ZX0_Q02+ZX0_Q03+ZX0_Q04+ZX0_Q05+ZX0_Q06+ZX0_Q07+ZX0_Q08+ZX0_Q09+ZX0_Q10+ZX0_Q11+ZX0_Q12)/12"
	cSql += " ,     ZX0_MES = '"+Substr(mv_par01,4,4)+Substr(mv_par01,1,2)+"'"
	cSql += " ,     ZX0_CURVA  = 'C'"
	cSql += " ,     ZX0_ABCGER = 'C'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZX0_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"

	nUpdt := 0
	MsgRun("Atualizando Totais e Médias ...",,{|| nUpdt := TcSqlExec(cSql) })

	If nUpdt < 0
		MsgBox(TcSqlError(),"Mes a Mes","STOP")
	Endif

	cSql := "SELECT X5_CHAVE,X5_DESCRI FROM "+RetSqlName("SX5")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += " AND   X5_TABELA = 'X0'"
	cSql += " ORDER BY X5_CHAVE"

	MsgRun("Consultando Param. Curva ABC ... ",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	dbSelectArea("ARQ_SQL")
	dbGoTop()
	aCurva  := {}
	nVal01 := 0
	nVal02 := 0
	nVal03 := 0
	nVal04 := 0
	Do While !eof()
		nIni := 1
		nTmh := Len(AllTrim(ARQ_SQL->X5_DESCRI))
		nPos := AT(";",AllTrim(ARQ_SQL->X5_DESCRI))
		nVal01 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

		nIni += nPos
		nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
		nVal02 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

		nIni += nPos
		nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
		nVal03 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

		nIni += nPos
		nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
		nVal04 := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh-(nIni-1)))

		aadd(aCurva,{nVal01,nVal02,nVal03,nVal04})
		dbSkip()
	Enddo
	dbCloseArea()

	c3Meses := ""
	nMesAtu := Val(Substr(mv_par01,1,2))
	For k=0 to 2
		If (nMesAtu-k) <= 0
			c3Meses += "ZX0_Q"+StrZero(12-k,2)+iif(k < 2,"+","")
		Else
			c3Meses += "ZX0_Q"+StrZero(nMesAtu-k,2)+iif(k < 2,"+","")
		Endif
	Next k

	cSql := "SELECT ZX0_FILIAL,ZX0_GRUPO,BM_TIPOPRD,COUNT(ZX0_FILIAL) AS TOTGRP"
	cSql += " FROM "+RetSqlName("ZX0")+" ZX0"
	cSql += " JOIN "+RetSqlName("SBM")+" SBM"
	cSql += " ON   SBM.D_E_L_E_T_ = ''"
	cSql += " AND  BM_FILIAL = '"+xFilial("SBM")+"'"
	cSql += " AND  BM_GRUPO = ZX0_GRUPO"
	cSql += " WHERE ZX0.D_E_L_E_T_ = ''"
	cSql += " AND   ZX0_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cSql += " AND   "+c3Meses+" > 0"
	cSql += " GROUP BY ZX0_FILIAL,ZX0_GRUPO,BM_TIPOPRD"
	MsgRun("Totalizando Grupos ... ",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_GRP", .T., .T.)})
	TcSetField("SQL_GRP","TOTGRP","N",14,2)

	dbSelectArea("SQL_GRP")
	ProcRegua(0)
	Do While !eof()
		cSql := "SELECT ZX0_FILIAL,ZX0_COD,("+c3Meses+") AS MOV"
		cSql += " FROM "+RetSqlName("ZX0")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ZX0_FILIAL = '"+ZX0_FILIAL+"'"
		cSql += " AND   ZX0_GRUPO = '"+ZX0_GRUPO+"'"
		cSql += " ORDER BY MOV DESC,ZX0_COD"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		dbSelectArea("ARQ_SQL")
		dbGoTop()
		nItGrp := 0
		Do While !eof()
			incProc(SQL_GRP->ZX0_FILIAL+" - "+SQL_GRP->ZX0_GRUPO+" - "+ZX0_COD)
			cCurva := ""
			nPerc  := 0
			For k=1 to Len(aCurva)-1
				if SQL_GRP->BM_TIPOPRD = "P"
					If nItGrp < SQL_GRP->TOTGRP*((nPerc+aCurva[k,3])/100)
						cCurva := Chr(64+k)
						nItGrp ++
						Exit
					Endif
					nPerc += aCurva[k,3]
				Else
					If nItGrp < SQL_GRP->TOTGRP*((nPerc+aCurva[k,1])/100)
						cCurva := Chr(64+k)
						nItGrp ++
						Exit
					Endif
					nPerc += aCurva[k,1]
				Endif
			Next k
			If cCurva = ""
				Exit
			Endif

			dbSelectArea("ZX0")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(ARQ_SQL->(ZX0_FILIAL+ZX0_COD),.F.)
			If Found()
				If RecLock("ZX0",.F.)
					ZX0_CURVA := cCurva
					MsUnlock()
				Endif
			Endif

			dbSelectArea("ARQ_SQL")
			dbSkip()
		Enddo
		dbSelectArea("ARQ_SQL")
		dbCloseArea()

		dbSelectArea("SQL_GRP")
		dbSkip()
	Enddo
	dbSelectArea("SQL_GRP")
	dbCloseArea()


	cSql := "SELECT ZX0_GRUPO,BM_TIPOPRD,COUNT(ZX0_FILIAL) AS TOTGRP"
	cSql += " FROM "+RetSqlName("ZX0")+" ZX0"

	cSql += " JOIN "+RetSqlName("SBM")+" SBM"
	cSql += " ON   SBM.D_E_L_E_T_ = ''"
	cSql += " AND  BM_FILIAL = '"+xFilial("SBM")+"'"
	cSql += " AND  BM_GRUPO = ZX0_GRUPO"

	cSql += " WHERE ZX0.D_E_L_E_T_ = ''"
	cSql += " AND   ZX0_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   "+c3Meses+" > 0"
	cSql += " GROUP BY ZX0_GRUPO,BM_TIPOPRD"
	MsgRun("Totalizando Grupos ... ",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_GRP", .T., .T.)})
	TcSetField("SQL_GRP","TOTGRP","N",14,2)

	dbSelectArea("SQL_GRP")
	ProcRegua(0)
	Do While !eof()
		cSql := "SELECT ZX0_FILIAL,ZX0_COD,("+c3Meses+") AS MOV"
		cSql += " FROM "+RetSqlName("ZX0")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ZX0_FILIAL BETWEEN '' AND 'ZZ'"
		cSql += " AND   ZX0_GRUPO = '"+ZX0_GRUPO+"'"
		cSql += " ORDER BY MOV DESC,ZX0_COD"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		dbSelectArea("ARQ_SQL")
		dbGoTop()
		nItGrp := 0
		Do While !eof()
			incProc(SQL_GRP->ZX0_GRUPO+" - "+ZX0_COD)
			cCurva := ""
			nPerc  := 0
			For k=1 to Len(aCurva)-1
				if SQL_GRP->BM_TIPOPRD = "P"
					If nItGrp < SQL_GRP->TOTGRP*((nPerc+aCurva[k,3])/100)
						cCurva := Chr(64+k)
						nItGrp ++
						Exit
					Endif
					nPerc += aCurva[k,3]
				Else
					If nItGrp < SQL_GRP->TOTGRP*((nPerc+aCurva[k,1])/100)
						cCurva := Chr(64+k)
						nItGrp ++
						Exit
					Endif
					nPerc += aCurva[k,1]
				Endif
			Next k
			If cCurva = ""
				Exit
			Endif

			cSql := "UPDATE "+RetSqlName("ZX0")+" ZX0"
			cSql += " SET   ZX0_ABCGER = '"+cCurva+"'"
			cSql += " WHERE D_E_L_E_T_ = ''"
			cSql += " AND   ZX0_FILIAL BETWEEN '' AND 'ZZ'"
			cSql += " AND   ZX0_COD = '"+ZX0_COD+"'"

			nUpdt := 0
			nUpdt := TcSqlExec(cSql)

			If nUpdt < 0
				MsgBox(TcSqlError(),"Mes a Mes","STOP")
			Endif

			dbSelectArea("ARQ_SQL")
			dbSkip()
		Enddo
		dbSelectArea("ARQ_SQL")
		dbCloseArea()

		dbSelectArea("SQL_GRP")
		dbSkip()
	Enddo
	dbSelectArea("SQL_GRP")
	dbCloseArea()

	MsgBox("Recalculo efetuado com sucesso em "+Tempo(nInicio,Seconds()),"Mes a Mes","INFO")
Return nil

Static Function Tempo(nIni,nFim)
	Local nDif   := 0
	Local nH     := 0
	Local nM     := 0
	Local nS     := 0
	Local cTempo := ""
	
	If nFim <= nIni
		nFim + 86400
	Endif
	nDif := nFim - nIni

	nH := INT((nDif/60)/60)
	nM := INT((nDif-(nH*60)*60)/60)
	nS := nDif-(((nH*60)*60)+(nM*60))

	cTempo := StrZero(nH,2) + ":" + StrZero(nM,2) + ":" + StrZero(nS,2)
Return cTempo

User Function fSelABC()
	Local   cTitulo  := ""
	Local   MvPar
	Local   MvParDef := ""
	Private aSit     := {}
	Private l1Elem   := .F.

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	cAlias := Alias()

	aAdd(aSit,"A - Itens A")
	aAdd(aSit,"B - Itens B")
	aAdd(aSit,"C - Itens C")
	mvParDef := "ABC"

	dbSelectArea(cAlias)

	cTitulo :="Tipo de venda"
	Do While .T. 
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
		if mvpar = Replicate("*",Len(mvParDef))
			MsgBox("Voce deve selecionar pelo menos 1","Curva ABC","STOP")
			Loop
		Else
			Exit
		Endif
	Enddo
Return MvParDef

User Function fSelLoc()
	Local   MvPar
	Local   cTitulo  := ""
	Local   MvParDef := ""
	Local   cSql     := ""
	Local   nTmCh    := 2
	Local   nMaxIt   := 30
	Private aLocal   := {}
	Private l1Elem   := .F.

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	cAlias := Alias()

	cSql := "SELECT X5_CHAVE,X5_DESCRI FROM "+RetSqlName("SX5")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += " AND   X5_TABELA = 'AM'"
	cSql += " ORDER BY X5_CHAVE"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LOCAL", .T., .T.)
	dbSelectArea("SQL_LOCAL")
	dbGotop()
	Do while !eof()
		aAdd(aLocal,Substr(X5_CHAVE,1,2) + " - " + AllTrim(X5_DESCRI))
		mvParDef += Substr(X5_CHAVE,1,2)
		dbSkip()
	Enddo
	dbCloseArea()

	dbSelectArea(cAlias)

	cTitulo :="Armazens - Local"
	Do While .T. 
		IF f_Opcoes(@MvPar,cTitulo,aLocal,MvParDef,12,49,l1Elem,nTmCh,nMaxIT)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
		if mvpar = Replicate("*",Len(mvParDef))
			MsgBox("Voce deve selecionar pelo menos 1","Local","STOP")
			Loop
		Else
			Exit
		Endif
	Enddo
Return MvParDef