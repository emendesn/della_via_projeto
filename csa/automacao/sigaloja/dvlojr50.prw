#include "rwmake.ch"
#include "topconn.ch"

User Function DVLOJR50()
	Private cString        := "SUA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Sintético de doações"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 132
	Private tamanho        := "G"
	Private nomeprog       := "DVLOJR50"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DVR050"
	Private titulo         := "Sintético de doações"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "DVLOJR50"
	Private lImp           := .f.
	Private cSql           := ""
	Private aResumoCon     := {}
	Private aResumoLoja    := {}

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Emissao         ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Ate a Emissao      ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"03","Do Convenio        ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","PA6","","","",""})
	AADD(aRegs,{cPerg,"04","Ate o Convenio     ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","PA6","","","",""})
	AADD(aRegs,{cPerg,"05","Da Loja            ?"," "," ","mv_ch5","C", 02,0,0,"G","","mv_par05",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SM0","","","",""})
	AADD(aRegs,{cPerg,"06","Ate a Loja         ?"," "," ","mv_ch6","C", 02,0,0,"G","","mv_par06",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SM0","","","",""})
	AADD(aRegs,{cPerg,"07","Do Cliente         ?"," "," ","mv_ch7","C", 06,0,0,"G","","mv_par07",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SB1","","","",""})
	AADD(aRegs,{cPerg,"08","Ate o Cliente      ?"," "," ","mv_ch8","C", 06,0,0,"G","","mv_par08",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SB1","","","",""})
	AADD(aRegs,{cPerg,"09","Do Grupo           ?"," "," ","mv_ch9","C", 04,0,0,"G","","mv_par09",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SBM","","","",""})
	AADD(aRegs,{cPerg,"10","Ate o Grupo        ?"," "," ","mv_cha","C", 04,0,0,"G","","mv_par10",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SBM","","","",""})
	AADD(aRegs,{cPerg,"11","Da Categoria       ?"," "," ","mv_chb","C", 04,0,0,"G","","mv_par11",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SZ6","","","",""})
	AADD(aRegs,{cPerg,"12","Ate a Categoria    ?"," "," ","mv_chc","C", 04,0,0,"G","","mv_par12",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SZ6","","","",""})
	AADD(aRegs,{cPerg,"13","Do Grupo Agregad.  ?"," "," ","mv_chd","C", 04,0,0,"G","","mv_par13",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SBM","","","",""})
	AADD(aRegs,{cPerg,"14","Ate o Grupo Agregad?"," "," ","mv_che","C", 04,0,0,"G","","mv_par14",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SBM","","","",""})

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

	// Monta inferface com usuário	
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
	Titulo:= AllTrim(Titulo)+" - De "+dtoc(mv_par01)+" a "+dtoc(mv_par02)+" - Da Loja ("+mv_par05+") até ("+mv_par06+")"
	Cabec1:="Do Convenio ("+mv_par03+") ate ("+mv_par04+") - Do Cliente ("+mv_par07+") ate ("+mv_par08+") - Do Grupo ("+mv_par09+") ate ("+mv_par10+") - Da Categoria ("+mv_par11+") Ate ("+mv_par12+") - Do Grupo de Agregados ("+mv_par13+") Ate ("+mv_par14+")"
	Cabec2:="     Convenio                                   Qtde Doada        Valor Doação       Qtde Agregada      Valor Agregado        (%)   Qtde não Agregada"
	        *     XXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXX   99.999.999.999,99   99.999.999.999,99   99.999.999.999,99   99.999.999.999,99   9.999,99   99.999.999.999,99
	        *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	lDataAnt := SuperGetMV("FS_DEL011",.F.,.F.)
	nDiasAnt := SuperGetMv("DV_DIASDOA",.F.,180)

	cSql := ""
	cSql += "SELECT UA_FILIAL,LJ_NOME,UA_CODCON,PA6_DESC,UA_EMISSAO,UA_CLIENTE,UB_QUANT,UB_VLRITEM"
	cSql += " FROM "+RetSqlName("SUA")+" SUA"

	cSql += " JOIN "+RetSqlName("SUB")+" SUB"
	cSql += " ON  SUB.D_E_L_E_T_ = ''"
	cSql += " AND UB_FILIAL = UA_FILIAL"
	cSql += " AND UB_NUM = UA_NUM"
	cSql += " AND UB_OPER = '"+AllTrim(GetMV("FS_DEL038"))+"'"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON  SB1.D_E_L_E_T_ = ''"
	cSql += " AND B1_COD = UB_PRODUTO"
	cSql += " AND B1_GRUPO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cSql += " AND B1_CATEG BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"

	cSql += " LEFT JOIN "+RetSqlName("PA6")+" PA6"
	cSql += " ON  PA6.D_E_L_E_T_ = ''"
	cSql += " AND PA6_COD = UA_CODCON"

	cSql += " LEFT JOIN "+RetSqlName("SLJ")+" SLJ"
	cSql += " ON  SLJ.D_E_L_E_T_ = ''"
	cSql += " AND LJ_RPCFIL = UA_FILIAL"

	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   UA_STATUS = 'NF.'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_CODCON BETWEEN  '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_FILIAL BETWEEN  '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UA_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cSql += " ORDER BY UA_FILIAL,UA_CODCON"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	MsgRun("Consultando Banco de dados ...",,{|| TcSetField("ARQ_SQL","UB_QUANT"  ,"N",14,2)})
	MsgRun("Consultando Banco de dados ...",,{|| TcSetField("ARQ_SQL","UB_VLRITEM","N",14,2)})

	dbSelectArea("ARQ_SQL")

	// Monta estrutura do temporario
	aEstru := {}
	aadd(aEstru,{"T_LOJA"     ,"C",02,0})
	aadd(aEstru,{"T_LJNOME"   ,"C",30,0})
	aadd(aEstru,{"T_CODCON"   ,"C",06,0})
	aadd(aEstru,{"T_DESC"     ,"C",30,0})
	aadd(aEstru,{"T_QTDDOA"   ,"N",10,0})
	aadd(aEstru,{"T_VALDOA"   ,"N",14,2})
	aadd(aEstru,{"T_QTDAGR"   ,"N",10,0})
	aadd(aEstru,{"T_NQTDAGR"  ,"N",10,0})
	aadd(aEstru,{"T_VALAGR"   ,"N",14,2})

	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_LOJA+T_CODCON",,.t.,"Selecionando Registros...")

	cNfAgrega := ""
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbGoTop()
	
	Do While !eof()
		incProc("Carregando temporário ...")
		if RecLock("TMP",.T.)
			TMP->T_LOJA   := ARQ_SQL->UA_FILIAL
			TMP->T_LJNOME := ARQ_SQL->LJ_NOME
			TMP->T_CODCON := ARQ_SQL->UA_CODCON
			TMP->T_DESC   := ARQ_SQL->PA6_DESC

			dbSelectArea("ARQ_SQL")
			cChave := ARQ_SQL->UA_FILIAL+ARQ_SQL->UA_CODCON

			do While !eof() .and. ARQ_SQL->UA_FILIAL+ARQ_SQL->UA_CODCON = cChave
				incProc("Carregando temporário ...")
				TMP->T_QTDDOA += ARQ_SQL->UB_QUANT
				TMP->T_VALDOA += ARQ_SQL->UB_VLRITEM
				
				cSql := "SELECT L1_FILIAL,L1_DOC,L1_SERIE,SL1.R_E_C_N_O_,Sum(L2_QUANT) AS QTDAGR,Sum(L2_VLRITEM) AS VALAGR"
				cSql += " FROM "+RetSqlName("SL1")+" SL1"

				cSql += " JOIN "+RetSqlName("SL2")+" SL2"
				cSql += " ON   SL2.D_E_L_E_T_ = ''"
				cSql += " AND  L2_FILIAL = L1_FILIAL"
				cSql += " AND  L2_NUM = L1_NUM"

				cSql += " JOIN "+RetSqlName("SB1")+" SB1"
				cSql += " ON   SB1.D_E_L_E_T_ = ''"
				cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
				cSql += " AND  B1_COD = L2_PRODUTO"
				cSql += " AND  B1_GRUPO BETWEEN '"+mv_par13+"' AND '"+mv_par14+"'"

				cSql += " WHERE SL1.D_E_L_E_T_ = ''"
				cSql += " AND   L1_EMISSAO >= '"+ARQ_SQL->UA_EMISSAO+"'"
				cSql += " AND   L1_CLIENTE = '"+ARQ_SQL->UA_CLIENTE+"'"

				cSql += " GROUP BY L1_FILIAL,L1_DOC,L1_SERIE,SL1.R_E_C_N_O_"
				cSql += " ORDER BY SL1.R_E_C_N_O_"

				cSql := ChangeQuery(cSql)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_AGR", .T., .T.)

				TcSetField("ARQ_SQL","QTDAGR"  ,"N",14,2)
				TcSetField("ARQ_SQL","VALAGR","N",14,2)
				
				dbSelectArea("ARQ_AGR")
				lAchou := .F.
				Do While !eof()
					incProc("Carregando temporário ...")
					If !(L1_FILIAL+L1_DOC+L1_SERIE $ cNfAgrega)
						cNfAgrega += L1_FILIAL+L1_DOC+L1_SERIE + "*"
						TMP->T_QTDAGR += ARQ_AGR->QTDAGR
						TMP->T_VALAGR += ARQ_AGR->VALAGR
						lAchou := .T.
						exit
					Endif
					dbSkip()
				Enddo
				dbSelectArea("ARQ_AGR")
				dbCloseArea()
				
				if !lAchou .And. lDataAnt
					cSql := "SELECT L1_FILIAL,L1_DOC,L1_SERIE,SL1.R_E_C_N_O_,Sum(L2_QUANT) AS QTDAGR,Sum(L2_VLRITEM) AS VALAGR"
					cSql += " FROM "+RetSqlName("SL1")+" SL1"

					cSql += " JOIN "+RetSqlName("SL2")+" SL2"
					cSql += " ON   SL2.D_E_L_E_T_ = ''"
					cSql += " AND  L2_FILIAL = L1_FILIAL"
					cSql += " AND  L2_NUM = L1_NUM"

					cSql += " JOIN "+RetSqlName("SB1")+" SB1"
					cSql += " ON   SB1.D_E_L_E_T_ = ''"
					cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
					cSql += " AND  B1_COD = L2_PRODUTO"
					cSql += " AND  B1_GRUPO BETWEEN '"+mv_par13+"' AND '"+mv_par14+"'"

					cSql += " WHERE SL1.D_E_L_E_T_ = ''"
					cSql += " AND   L1_EMISSAO >= '"+dtos(Stod(ARQ_SQL->UA_EMISSAO)-nDiasAnt)+"'"
					cSql += " AND   L1_CLIENTE = '"+ARQ_SQL->UA_CLIENTE+"'"

					cSql += " GROUP BY L1_FILIAL,L1_DOC,L1_SERIE,SL1.R_E_C_N_O_"
					cSql += " ORDER BY SL1.R_E_C_N_O_ DESC"

					cSql := ChangeQuery(cSql)
					dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_AGR", .T., .T.)

					TcSetField("ARQ_AGR","QTDAGR"  ,"N",14,2)
					TcSetField("ARQ_AGR","VALAGR","N",14,2)
				
					dbSelectArea("ARQ_AGR")
					lAchou := .F.
					Do While !eof()
						incProc("Carregando temporário ...")
						If !(L1_FILIAL+L1_DOC+L1_SERIE $ cNfAgrega)
							cNfAgrega += L1_FILIAL+L1_DOC+L1_SERIE + "*"
							TMP->T_QTDAGR += ARQ_AGR->QTDAGR
							TMP->T_VALAGR += ARQ_AGR->VALAGR
							lAchou := .T.
							exit
						Endif
						dbSkip()
					Enddo
					dbSelectArea("ARQ_AGR")
					dbCloseArea()
				Endif

				If !lAchou
					TMP->T_NQTDAGR += ARQ_SQL->UB_QUANT
				Endif

				dbSelectArea("ARQ_SQL")
				dbSkip()
			Enddo
			MsUnlock()
		Endif
	Enddo

	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	dbSelectArea("TMP")
	aTotGeral := {0,0,0,0,0}
	ProcRegua(LastRec())
	dbGoTop()

	Do while !eof()
		incProc("Imprimindo ...")
		lImp := .T.
		cChave := T_LOJA

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+2
		endif

		@ LI,000 PSAY T_LOJA+" - "+T_LJNOME
		LI++

		Do While !eof() .AND. T_LOJA = cChave
			if lAbortPrint
				If lImp
					li+=2
					@ LI,001 PSAY "*** Cancelado pelo operador ***"
					Exit
				Endif
			Endif

			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif

			@ LI,005 PSAY T_CODCON+" - "+Substr(T_DESC,1,25)
			@ LI,044 PSAY T_QTDDOA PICTURE "@E 99,999,999,999"
			@ LI,061 PSAY T_VALDOA PICTURE "@E 99,999,999,999.99"
			@ LI,084 PSAY T_QTDAGR PICTURE "@E 99,999,999,999"
			@ LI,101 PSAY T_VALAGR PICTURE "@E 99,999,999,999.99"
			@ LI,121 PSAY ((T_QTDDOA-T_NQTDAGR)/T_QTDDOA)*100 PICTURE "@E 9,999.99"
			@ LI,129 PSAY "%"
			@ LI,132 PSAY T_NQTDAGR PICTURE "@E 99,999,999,999.99"
			Li:=Li+1

			nPos := 0
			nPos := aScan(aResumoCon, { |x| x[1] == T_CODCON })
			If nPos > 0
				aResumoCon[nPos,3] += T_QTDDOA
				aResumoCon[nPos,4] += T_VALDOA
				aResumoCon[nPos,5] += T_QTDAGR
				aResumoCon[nPos,6] += T_VALAGR
				aResumoCon[nPos,7] += T_NQTDAGR
			Else
				aadd(aResumoCon,{T_CODCON,T_DESC,T_QTDDOA,T_VALDOA,T_QTDAGR,T_VALAGR,T_NQTDAGR})
			Endif

			nPos := 0
			nPos := aScan(aResumoLoja, { |x| x[1] == T_LOJA })
			If nPos > 0
				aResumoLoja[nPos,3] += T_QTDDOA
				aResumoLoja[nPos,4] += T_VALDOA
				aResumoLoja[nPos,5] += T_QTDAGR
				aResumoLoja[nPos,6] += T_VALAGR
				aResumoLoja[nPos,7] += T_NQTDAGR
			Else
				aadd(aResumoLoja,{T_LOJA,T_LJNOME,T_QTDDOA,T_VALDOA,T_QTDAGR,T_VALAGR,T_NQTDAGR})
			Endif

			dbSkip()
		Enddo

		nPos := aScan(aResumoLoja, { |x| x[1] == cChave })
		@ LI,000 PSAY "Total da Loja"
		@ LI,044 PSAY aResumoLoja[nPos,3] PICTURE "@E 99,999,999,999"
		@ LI,061 PSAY aResumoLoja[nPos,4] PICTURE "@E 99,999,999,999.99"
		@ LI,084 PSAY aResumoLoja[nPos,5] PICTURE "@E 99,999,999,999"
		@ LI,101 PSAY aResumoLoja[nPos,6] PICTURE "@E 99,999,999,999.99"
		@ LI,121 PSAY ((aResumoLoja[nPos,3]-aResumoLoja[nPos,7])/aResumoLoja[nPos,3])*100 PICTURE "@E 9,999.99"
		@ LI,129 PSAY "%"
		@ LI,132 PSAY aResumoLoja[nPos,7] PICTURE "@E 99,999,999,999.99"
		aTotGeral[1] += aResumoLoja[nPos,3]
		aTotGeral[2] += aResumoLoja[nPos,4]
		aTotGeral[3] += aResumoLoja[nPos,5]
		aTotGeral[4] += aResumoLoja[nPos,6]
		aTotGeral[5] += aResumoLoja[nPos,7]
		LI+=2
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	if lImp .AND. !lAbortPrint
		LI++
		@ LI,000 PSAY "Total Geral:"
		@ LI,044 PSAY aTotGeral[1] PICTURE "@E 99,999,999,999"
		@ LI,061 PSAY aTotGeral[2] PICTURE "@E 99,999,999,999.99"
		@ LI,084 PSAY aTotGeral[3] PICTURE "@E 99,999,999,999"
		@ LI,101 PSAY aTotGeral[4] PICTURE "@E 99,999,999,999.99"
		@ LI,121 PSAY ((aTotGeral[1]-aTotGeral[5])/aTotGeral[1])*100 PICTURE "@E 9,999.99"
		@ LI,129 PSAY "%"
		@ LI,132 PSAY aTotGeral[5] PICTURE "@E 99,999,999,999.99"

		aResumoCon  := aSort(aResumoCon ,,, { |x, y| x[1] < y[1] })
		aResumoLoja := aSort(aResumoLoja,,, { |x, y| x[1] < y[1] })

		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI:=LI+2
		@ LI,000 PSAY "Resumo por Convenio"
		LI++
		@ LI,000 PSAY "-------------------"
		LI++

		For k=1 to Len(aResumoCon)
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif
			@ LI,000 PSAY aResumoCon[k,1]+" - "+aResumoCon[k,2]
			@ LI,044 PSAY aResumoCon[k,3] PICTURE "@E 99,999,999,999"
			@ LI,061 PSAY aResumoCon[k,4] PICTURE "@E 99,999,999,999.99"
			@ LI,084 PSAY aResumoCon[k,5] PICTURE "@E 99,999,999,999"
			@ LI,101 PSAY aResumoCon[k,6] PICTURE "@E 99,999,999,999.99"
			@ LI,121 PSAY ((aResumoCon[k,3]-aResumoCon[k,7])/aResumoCon[k,3])*100 PICTURE "@E 9,999.99"
			@ LI,129 PSAY "%"
			@ LI,132 PSAY aResumoCon[k,7] PICTURE "@E 99,999,999,999.99"
			LI++
		Next

		LI++
		@ LI,000 PSAY "Total Geral:"
		@ LI,044 PSAY aTotGeral[1] PICTURE "@E 99,999,999,999"
		@ LI,061 PSAY aTotGeral[2] PICTURE "@E 99,999,999,999.99"
		@ LI,084 PSAY aTotGeral[3] PICTURE "@E 99,999,999,999"
		@ LI,101 PSAY aTotGeral[4] PICTURE "@E 99,999,999,999.99"
		@ LI,121 PSAY ((aTotGeral[1]-aTotGeral[5])/aTotGeral[1])*100 PICTURE "@E 9,999.99"
		@ LI,129 PSAY "%"
		@ LI,132 PSAY aTotGeral[5] PICTURE "@E 99,999,999,999.99"

		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI:=LI+2
		@ LI,000 PSAY "Resumo por Loja"
		LI++
		@ LI,000 PSAY "---------------"
		LI++

		For k=1 to Len(aResumoLoja)
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif
			nQtdNAgreg := iif(aResumoLoja[k,3]>aResumoLoja[k,5],aResumoLoja[k,3]-aResumoLoja[k,5],0)
			@ LI,000 PSAY aResumoLoja[k,1]+" - "+aResumoLoja[k,2]
			@ LI,044 PSAY aResumoLoja[k,3] PICTURE "@E 99,999,999,999"
			@ LI,061 PSAY aResumoLoja[k,4] PICTURE "@E 99,999,999,999.99"
			@ LI,084 PSAY aResumoLoja[k,5] PICTURE "@E 99,999,999,999"
			@ LI,101 PSAY aResumoLoja[k,6] PICTURE "@E 99,999,999,999.99"
			@ LI,121 PSAY ((aResumoLoja[k,3]-aResumoLoja[k,7])/aResumoLoja[k,3])*100 PICTURE "@E 9,999.99"
			@ LI,129 PSAY "%"
			@ LI,132 PSAY aResumoLoja[k,7] PICTURE "@E 99,999,999,999.99"
			LI++
		Next

		LI++
		nQtdNAgreg := iif(aTotGeral[1]>aTotGeral[3],aTotGeral[1]-aTotGeral[3],0)
		@ LI,000 PSAY "Total Geral:"
		@ LI,044 PSAY aTotGeral[1] PICTURE "@E 99,999,999,999"
		@ LI,061 PSAY aTotGeral[2] PICTURE "@E 99,999,999,999.99"
		@ LI,084 PSAY aTotGeral[3] PICTURE "@E 99,999,999,999"
		@ LI,101 PSAY aTotGeral[4] PICTURE "@E 99,999,999,999.99"
		@ LI,121 PSAY ((aTotGeral[1]-aTotGeral[5])/aTotGeral[1])*100 PICTURE "@E 9,999.99"
		@ LI,129 PSAY "%"
		@ LI,132 PSAY aTotGeral[5] PICTURE "@E 99,999,999,999.99"

		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil