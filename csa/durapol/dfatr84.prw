#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR84()
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Acompanhamento de comissões"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 220
	Private tamanho        := "P"
	Private nomeprog       := "DFATR84"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR84"
	Private titulo         := "Acompanhamento de comissões"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "DFATR84"
	Private lImp           := .f.
	Private cSql           := ""
	Private aTipoVend      := {"Motorista","Vendedor","Indicador"}

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AAdd(aRegs,{cPerg,"01","Separar?            "," "," ","mv_ch1","N", 01,0,0,"C","","mv_par01","Motorista","","","","","Vendendor"   ,"","","","","Indicador","","","","","Todos","","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Do Vendedor?        "," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"03","Ate o Vendedor?     "," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"04","Mes Ref. (AAAAMM)?  "," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"05","Data p/ Atrasados?  "," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AAdd(aRegs,{cPerg,"06","Mostra Atrasados?   "," "," ","mv_ch6","N", 01,0,0,"C","","mv_par06","Sim"      ,"","","","","Não"         ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AAdd(aRegs,{cPerg,"07","Quebra Pag. Vendedor"," "," ","mv_ch7","N", 01,0,0,"C","","mv_par07","Sim"      ,"","","","","Não"         ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AAdd(aRegs,{cPerg,"08","Vendas?             "," "," ","mv_ch8","N", 01,0,0,"C","","mv_par08","Normal"   ,"","","","","Em Cobertura","","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})

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

	Processa({|| RunReport() },Titulo,,.t.)
Return nil

Static Function RunReport()
	//Datas
	cMesAtu := mv_par04
	cMesAnt := substr(dtos(ctod("01/"+Substr(mv_par04,5,2)+"/"+Substr(mv_par04,1,4))-1),1,6)
	Titulo  := AllTrim(Titulo)+" - "+iif(mv_par08=1,"Normal","Em Cobertura")

	// Estrutura do Temporário
	aEstru := {}
	aadd(aEstru,{"T_TIPOV"  ,"C",01,0})
	aadd(aEstru,{"T_VEND"   ,"C",06,0})
	aadd(aEstru,{"T_NOMEV"  ,"C",30,0})
//	aadd(aEstru,{"T_SALANT" ,"N",14,2})
	aadd(aEstru,{"T_VENCIDO","N",14,2})
	aadd(aEstru,{"T_VENDASM","N",14,2})
	aadd(aEstru,{"T_PAGOSM" ,"N",14,2})
	aadd(aEstru,{"T_ARECEB" ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_TIPOV+T_VEND",,.t.,"Selecionando Registros...")

	Cabec1:=""
	        *     XXXXXXXXXXXXXXXXXXXXXXXXXXXX                      99.999.999.999,99
	        *          XXXXXXXXXXXXXXXXXXXX   XXXXXX-X   99/99/99   99.999.999.999,99
	        * 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	/*
	//Carrega Saldo mês anterior
	For k=3 to 5
		If mv_par01 = (k-2) .or. mv_par01 = 4
			cSql := ""
			cSql += " SELECT E1_VEND"+Str(k,1)+" AS VEND,A3_NOME,SUM(E1_SALDO) AS VALOR"
			cSql += " FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA3")+" SA3"
			cSql += " WHERE SE1.D_E_L_E_T_ = ''"
			cSql += " AND   SA3.D_E_L_E_T_ = ''"
			cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
			cSql += " AND   E1_EMISSAO < '"+cMesAtu+"01'"
			cSql += " AND   E1_SALDO > 0"
			cSql += " AND   E1_VEND"+Str(k,1)+" <> ''"
			cSql += " AND   E1_VEND"+Str(k,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
			cSql += " AND   A3_COD = E1_VEND"+Str(k,1)
			cSql += " GROUP BY E1_VEND"+Str(k,1)+",A3_NOME"

			MsgRun("Lendo Saldo Mês anterior...",,{|| cSql := ChangeQuery(cSql)})
			MsgRun("Lendo Saldo Mês anterior...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

			dbSelectArea("ARQ_SQL")
			VerCpo("Lendo Saldo Mês anterior...")
			LoadTmp(Str(k-2,1),"1")
			dbCloseArea()
		endif
	Next
	*/


	//Carrega titulos em atraso
	For k=3 to 5
		If mv_par01 = (k-2) .or. mv_par01 = 4
			cSql := ""
			cSql += " SELECT E1_VEND"+Str(k,1)+" AS VEND,A3_NOME,E1_EMISSAO,SUM(E1_SALDO) AS VALOR"
			cSql += " FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA3")+" SA3"
			cSql += " WHERE SE1.D_E_L_E_T_ = ''"
			cSql += " AND   SA3.D_E_L_E_T_ = ''"
			cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
			cSql += " AND   E1_SALDO > 0"
			cSql += " AND   E1_VEND"+Str(k,1)+" <> ''"
			cSql += " AND   E1_VEND"+Str(k,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
			cSql += " AND   E1_VENCREA < '"+dtos(mv_par05)+"'"
			cSql += " AND   A3_COD = E1_VEND"+Str(k,1)
			cSql += " GROUP BY E1_VEND"+Str(k,1)+",A3_NOME,E1_EMISSAO"

			MsgRun("Lendo titulos em atraso...",,{|| cSql := ChangeQuery(cSql)})
			MsgRun("Lendo titulos em atraso...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

			dbSelectArea("ARQ_SQL")
			VerCpo("Lendo titulos em atraso...")
			LoadTmp(Str(k-2,1),"2")
			dbCloseArea()
		endif
	Next

	// Carrega emitidos no periodo
	For k=3 to 5
		If mv_par01 = (k-2) .or. mv_par01 = 4
			cSql := ""
			cSql += "SELECT E1_VEND"+Str(k,1)+" AS VEND,A3_NOME,E1_EMISSAO,SUM(E1_VALOR) AS VALOR"
			cSql += " FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA3")+" SA3"
			cSql += " WHERE SE1.D_E_L_E_T_ = ''"
			cSql += " AND   SA3.D_E_L_E_T_ = ''"
			cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
			cSql += " AND   Substring(E1_EMISSAO,1,6) ='"+cMesAtu+"'"
			cSql += " AND   E1_VEND"+Str(k,1)+" <> ''"
			cSql += " AND   E1_VEND"+Str(k,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
			cSql += " AND   A3_COD = E1_VEND"+Str(k,1)
			cSql += " GROUP BY E1_VEND"+Str(k,1)+",A3_NOME,E1_EMISSAO"

			MsgRun("Lendo titulos emitidos no periodo...",,{|| cSql := ChangeQuery(cSql)})
			MsgRun("Lendo titulos emitidos no periodo...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

			dbSelectArea("ARQ_SQL")
			VerCpo("Lendo titulos emitidos no periodo...")
			LoadTmp(Str(k-2,1),"3")
			dbCloseArea()
		Endif
	Next k

	//Carrega baixas no periodo
	For k=3 to 5
		If mv_par01 = (k-2) .or. mv_par01 = 4
			cSql := ""
			cSql += " SELECT E1_VEND"+Str(k,1)+" AS VEND,A3_NOME,E1_EMISSAO,Sum(E5_VALOR) AS VALOR"
			cSql += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA3")+" SA3"
			cSql += " WHERE SE5.D_E_L_E_T_ = ''"
			cSql += " AND   SE1.D_E_L_E_T_ = ''"
			cSql += " AND   SA3.D_E_L_E_T_ = ''"
			cSql += " AND   E5_FILIAL = '"+xFilial("SE5")+"'"
			cSql += " AND   E5_RECPAG ='R'"
			cSql += " AND   E5_TIPODOC IN('BA','VL')"
			cSql += " AND   E5_TIPO = 'NF'"
			cSql += " AND   Substring(E5_DATA,1,6) ='"+cMesAtu+"'"
			cSql += " AND   E1_FILIAL = E5_FILIAL"
			cSql += " AND   E1_PREFIXO = E5_PREFIXO"
			cSql += " AND   E1_NUM = E5_NUMERO"
			cSql += " AND   E1_PARCELA = E5_PARCELA"
			cSql += " AND   E1_VEND"+Str(k,1)+" <> ''"
			cSql += " AND   E1_VEND"+Str(k,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
			cSql += " AND   A3_COD = E1_VEND"+Str(k,1)
			cSql += " GROUP BY E1_VEND"+Str(k,1)+",A3_NOME,E1_EMISSAO"

			MsgRun("Lendo baixas no periodo...",,{|| cSql := ChangeQuery(cSql)})
			MsgRun("Lendo baixas no periodo...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

			dbSelectArea("ARQ_SQL")
			VerCpo("Lendo baixas no periodo...")
			LoadTmp(Str(k-2,1),"4")
			dbCloseArea()
		Endif
	Next

	//Carrega titulos em aberto
	For k=3 to 5
		If mv_par01 = (k-2) .or. mv_par01 = 4
			cSql := ""
			cSql += " SELECT E1_VEND"+Str(k,1)+" AS VEND,A3_NOME,E1_EMISSAO,SUM(E1_SALDO) AS VALOR"
			cSql += " FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA3")+" SA3"
			cSql += " WHERE SE1.D_E_L_E_T_ = ''"
			cSql += " AND   SA3.D_E_L_E_T_ = ''"
			cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
			cSql += " AND   E1_SALDO > 0"
			cSql += " AND   E1_VEND"+Str(k,1)+" <> ''"
			cSql += " AND   E1_VEND"+Str(k,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
			cSql += " AND   A3_COD = E1_VEND"+Str(k,1)
			cSql += " GROUP BY E1_VEND"+Str(k,1)+",A3_NOME,E1_EMISSAO"

			MsgRun("Lendo titulos em aberto...",,{|| cSql := ChangeQuery(cSql)})
			MsgRun("Lendo titulos em aberto...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

			dbSelectArea("ARQ_SQL")
			VerCpo("Lendo titulos em aberto...")
			LoadTmp(Str(k-2,1),"5")
			dbCloseArea()
		Endif
	Next

	// Imprime temporário
	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()
	lImp :=.F.
	do while !eof()
		cChave1 := T_TIPOV+T_VEND

		if li>55 .or. mv_par07 = 1
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+2
		endif
		@ LI,001 PSAY aTipoVend[Val(T_TIPOV)]+": "+T_VEND+" "+T_NOMEV
		//LI++
		//@ LI,000 PSAY IniFatLine+FimFatLine
		Li++

		Do While !eof() .and. T_TIPOV+T_VEND = cChave1
			incProc("Imprimindo ...")
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif
			lImp:=.T.
			/*
			@ LI,005 PSAY "Saldo "+Substr(cMesAnt,5,2)+"/"+Substr(cMesAnt,1,4)
			@ LI,055 PSAY T_SALANT  PICTURE "@E 99,999,999,999.99"
			Li:=Li+1
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif
			*/
			@ LI,005 PSAY "Titulos Vencidos"
			@ LI,055 PSAY T_VENCIDO PICTURE "@E 99,999,999,999.99"
			Li:=Li+1
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif

			If mv_par06 = 1 .AND. T_VENCIDO > 0
				cSql := ""
				cSql += " SELECT A1_NREDUZ,E1_NUM,E1_PARCELA,E1_VENCREA,E1_SALDO AS VALOR"
				cSql += " FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA1")+" SA1"
				cSql += " WHERE SE1.D_E_L_E_T_ = ''"
				cSql += " AND   SA1.D_E_L_E_T_ = ''"
				cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
				cSql += " AND   E1_SALDO > 0"
				cSql += " AND   E1_VEND"+Str(val(T_TIPOV)+2,1)+" = '"+T_VEND+"'"
				cSql += " AND   E1_VENCREA < '"+dtos(mv_par05)+"'"
				cSql += " AND   A1_FILIAL = ''"
				cSql += " AND   A1_COD = E1_CLIENTE"
				cSql += " AND   A1_LOJA = E1_LOJA"
				cSql += " ORDER BY A1_NREDUZ,E1_NUM,E1_PARCELA"

				cSql := ChangeQuery(cSql)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ATRASADOS", .T., .T.)
			
				dbSelectArea("ATRASADOS")
				dbGoTop()
				lAtrasos := .F.
				Do while !eof()
					lAtrasos := .T.
					if li>55
						LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
						LI:=LI+2
					endif
					@ LI,010 PSAY A1_NREDUZ
					@ LI,033 PSAY E1_NUM+" "+E1_PARCELA
					@ LI,044 PSAY stod(E1_VENCREA)
					@ LI,055 PSAY VALOR PICTURE "@E 99,999,999,999.99"
					LI++
					dbSkip()
				Enddo
				dbSelectArea("ATRASADOS")
				dbCloseArea()
				if lAtrasos
					li++
				Endif
				dbSelectArea("TMP")
			Endif

			@ LI,005 PSAY "Vendas no Mes "+Substr(cMesAtu,5,2)+"/"+Substr(cMesAtu,1,4)
			@ LI,055 PSAY T_VENDASM PICTURE "@E 99,999,999,999.99"
			Li:=Li+1
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif
			@ LI,005 PSAY "Titulo Pagos"
			@ LI,055 PSAY T_PAGOSM PICTURE "@E 99,999,999,999.99"
			Li:=Li+1
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif
			@ LI,005 PSAY "Titulos a Receber"
			@ LI,055 PSAY T_ARECEB PICTURE "@E 99,999,999,999.99"
			Li:=Li+1
			dbSkip()
			LI++
			@ LI,000 PSAY IniFatLine+FimFatLine
			Li++
		Enddo
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()
	
	fErase(cNomTmp+GetDBExtension())

	if lImp .AND. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1 .AND. lImp
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

// Alimenta temporário
Static Function LoadTmp(cTipoVend,cTipoReg)
	dbSelectArea("ARQ_SQL")
	dbGoTop()
	ProcRegua(0)
	Do While !eof()
		incProc("Carregando temporario...")
		aFiltro := VerZZ0(ARQ_SQL->VEND)
		lSkip := .F.
		For jj=1 to Len(aFiltro)
			If ARQ_SQL->E1_EMISSAO >= aFiltro[jj,1] .AND. ARQ_SQL->E1_EMISSAO <= aFiltro[jj,2]
				lSkip := .T.
				Exit
			Endif
		Next

		if iif(mv_par08=1,lSkip,!lSkip)
			dbSkip()
			Loop
		Endif

		dbSelectArea("TMP")
		dbSeek(cTipoVend+ARQ_SQL->VEND)
		If RecLock("TMP",!Found())
			TMP->T_TIPOV   := cTipoVend
			TMP->T_VEND    := ARQ_SQL->VEND
			TMP->T_NOMEV   := ARQ_SQL->A3_NOME
			/*
			If cTipoReg = "1"
				TMP->T_SALANT  += ARQ_SQL->VALOR
			*/
			if cTipoReg = "2"
				TMP->T_VENCIDO += ARQ_SQL->VALOR
			Elseif cTipoReg = "3"
				TMP->T_VENDASM += ARQ_SQL->VALOR
			Elseif cTipoReg = "4"
				TMP->T_PAGOSM  += ARQ_SQL->VALOR
			Elseif cTipoReg = "5"
				TMP->T_ARECEB  += ARQ_SQL->VALOR
			Endif
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo	
Return nil

// Ajusta campos para padrão Protheus
Static Function VerCpo(cTxt)
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","VALOR"     ,"N",14,2)})
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","E1_EMISSAO","D")})
Return

Static Function VerZZ0(cCodVen)
	Local aVendFil := {}
	Local aArea    := GetArea()

	dbSelectArea("ZZ0")
	dbGoTop()
	dbSeek(xFilial("ZZ0")+cCodVen,.F.)
	Do While !eof() .AND. ZZ0_VEND = cCodVen
		aadd(aVendFil,{ZZ0_DTINI,ZZ0_DTFIM})
		dbSkip()
	Enddo

	RestArea(aArea)
Return aVendFil