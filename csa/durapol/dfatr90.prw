#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR90()
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Resumo de comissões"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 220
	Private tamanho        := "G"
	Private nomeprog       := "DFATR90"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "FATR90"
	Private titulo         := "Resumo de comissões"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "DFATR90"
	Private lImp           := .f.
	Private cSql           := ""
	Private aTipoReg       := {"Emitidos","Baixados","Em aberto","Em atraso"}
	Private aTipoVend      := {"Motorista","Vendedor","Indicador"}
	Private lRegiao        := .F.

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AAdd(aRegs,{cPerg,"01","Separar?            "," "," ","mv_ch1","N", 01,0,0,"C","","mv_par01","Motorista","","","","","Vendendor"   ,"","","","","Indicador","","","","","Todos","","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Do Vendedor?        "," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"03","Ate o Vendedor?     "," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"04","Da Emissão?         "," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"05","Ate a Emissão?      "," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"06","Da Baixa?           "," "," ","mv_ch6","D", 08,0,0,"G","","mv_par06",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"07","Ate a Baixa?        "," "," ","mv_ch7","D", 08,0,0,"G","","mv_par07",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
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

	lRegiao := (mv_par01 = 3)

	SetDefault(aReturn,cString)

	Processa({|| RunReport() },Titulo,,.t.)
Return nil

Static Function RunReport()
	// Estrutura do Temporário
	aEstru := {}
	aadd(aEstru,{"T_REGION" ,"C",02,0})
	aadd(aEstru,{"T_REGNOM" ,"C",30,0})
	aadd(aEstru,{"T_TIPOV"  ,"C",01,0})
	aadd(aEstru,{"T_VEND"   ,"C",06,0})
	aadd(aEstru,{"T_NOMEV"  ,"C",30,0})
	aadd(aEstru,{"T_TIPOREG","C",01,0})
	aadd(aEstru,{"T_PRF"    ,"C",03,0})
	aadd(aEstru,{"T_NUM"    ,"C",06,0})
	aadd(aEstru,{"T_PARCELA","C",01,0})
	aadd(aEstru,{"T_EMISSAO","D",08,0})
	aadd(aEstru,{"T_VENCTO" ,"D",08,0})
	aadd(aEstru,{"T_BAIXA"  ,"D",08,0})
	aadd(aEstru,{"T_CLIENTE","C",06,0})
	aadd(aEstru,{"T_NOMEC"  ,"C",30,0})
	aadd(aEstru,{"T_VALOR"  ,"N",14,2})
	aadd(aEstru,{"T_VALBX"  ,"N",14,2})
	aadd(aEstru,{"T_SALDO"  ,"N",14,2})
	aadd(aEstru,{"T_COMIS"  ,"N",06,2})
	aadd(aEstru,{"T_VALCOM" ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	if lRegiao
		IndRegua("TMP",cNomTmp,"T_REGION+T_TIPOV+T_VEND+T_TIPOREG",,.t.,"Selecionando Registros...")
	Else
		IndRegua("TMP",cNomTmp,"T_TIPOV+T_VEND+T_TIPOREG",,.t.,"Selecionando Registros...")
	Endif

	//Cabec1:=""
	//Cabec1:="          Prefixo   Numero     Emissao    Vencimento   Baixa      Cliente                                               Valor       Valor Baixado     Saldo em aberto   % Comissão   Valor de Comissão"
	Cabec1:="                                                                                                                        Valor       Valor Baixado     Saldo em aberto                Valor de Comissão"
	        *          XXX       XXXXXX-X   99/99/99   99/99/99     99/99/99   XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99.999.999.999,99   99.999.999.999,99   99.999.999.999,99       999,99   99.999.999.999,99
	        * 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	Titulo := AllTrim(Titulo) + " - " + dtoc(mv_par04)+" a "+dtoc(mv_par05)+" - "+iif(mv_par08=1,"Normal","Em Cobertura")

	//Carrega baixas no periodo
	For k=3 to 5
		If mv_par01 = (k-2) .or. mv_par01 = 4
			cSql := ""
			cSql += "SELECT PB0_REGION"
			cSql += " ,      PB9_DESCR"
			cSql += " ,      E1_VEND"+Str(k,1)+" AS VEND"
			cSql += " ,      A3_NOME"
			cSql += " ,      E1_EMISSAO"
			cSql += " ,      E1_NUM"
			cSql += " ,      E1_PARCELA"
			cSql += " ,      E1_VALOR"
			cSql += " ,      E1_SALDO"
			cSql += " ,      A3_COMIS AS COMIS"
			cSql += " ,      Sum(E5_VALOR) AS VALOR"
			cSql += " ,      A1_COMIS"+Str(k,1)+" AS CLI_COMIS"
			cSql += " FROM "+RetSqlName("SE5")+" SE5"

			cSql += " JOIN "+RetSqlName("SE1")+" SE1"
			cSql += " ON   SE1.D_E_L_E_T_ = ''"
			cSql += " AND  E1_FILIAL = E5_FILIAL"
			cSql += " AND  E1_PREFIXO = E5_PREFIXO"
			cSql += " AND  E1_NUM = E5_NUMERO"
			cSql += " AND  E1_PARCELA = E5_PARCELA"
			cSql += " AND  E1_TIPO = E5_TIPO"
			cSql += " AND  E1_VEND"+Str(k,1)+" <> ''"
			cSql += " AND  E1_VEND"+Str(k,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
			cSql += " AND  E1_EMISSAO >= '20050701'" // Data de inicio do Protheus

			cSql += " LEFT JOIN "+RetSqlName("SA3")+" SA3"
			cSql += " ON   SA3.D_E_L_E_T_ = ''"
			cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
			cSql += " AND  A3_COD = E1_VEND"+Str(k,1)

			cSql += " LEFT JOIN "+RetSqlName("SA1")+" SA1"
			cSql += " ON   SA1.D_E_L_E_T_ = ''"
			cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
			cSql += " AND  A1_COD = E1_CLIENTE"
			cSql += " AND  A1_LOJA = E1_LOJA"

			cSql += " LEFT JOIN PB0010 PB0"
			cSql += " ON   PB0.D_E_L_E_T_ = ''"
			cSql += " AND  PB0_FILIAL = ''"
			cSql += " AND  PB0_LOJA = A3_FILORIG"

			cSql += " LEFT JOIN PB9010 PB9"
			cSql += " ON   PB9.D_E_L_E_T_ = ''"
			cSql += " AND  PB9_FILIAL = ''"
			cSql += " AND  PB9_CODIGO = PB0_REGION"

			cSql += " WHERE SE5.D_E_L_E_T_ = ''"
			cSql += " AND   E5_FILIAL = '"+xFilial("SE5")+"'"
			cSql += " AND   E5_DATA BETWEEN '"+dtos(mv_par06)+"' AND '"+dtos(mv_par07)+"'"
			cSql += " AND   E5_RECPAG ='R'"
			cSql += " AND   E5_TIPODOC IN('BA','VL')"
			cSql += " AND   E5_TIPO = 'NF'"
			cSql += " AND   E5_MOTBX = 'NOR'"
			cSql += " AND   E5_BANCO <> 'EXC'"
			cSql += " GROUP BY PB0_REGION"
			cSql += " ,        PB9_DESCR"
			cSql += " ,        E1_VEND"+Str(k,1)
			cSql += " ,        A3_NOME"
			cSql += " ,        E1_EMISSAO"
			cSql += " ,        E1_NUM"
			cSql += " ,        E1_PARCELA"
			cSql += " ,        E1_VALOR"
			cSql += " ,        E1_SALDO"
			cSql += " ,        A3_COMIS"
			cSql += " ,        A1_COMIS"+Str(k,1)
			cSql += " ORDER BY PB0_REGION"
			cSql += " ,        VEND"

			MsgRun("Lendo baixas no periodo...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

			dbSelectArea("ARQ_SQL")
			VerCpo("Lendo baixas no periodo...")
			LoadTmp(Str(k-2,1),"2")
			dbCloseArea()
		Endif
	Next

	// Imprime temporário
	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()
	lImp :=.F.
	if lRegiao
		nMaisPos := 5
	Else
		nMaisPos := 0
	Endif
	aTotGer := {0,0,0,0}
	do while !eof()
		if li>55 .AND. lRegiao
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+2
		endif

		cRegion := T_REGION
		if lRegiao
			LI++
			If !Empty(T_REGION)
				@ LI,001 PSAY T_REGION + " - " + T_REGNOM
			Else
				@ LI,001 PSAY "?? - SEM REGIONAL"
			Endif
			LI++
		Endif

		Do While !eof() .AND. cRegion = T_REGION
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
				if lRegiao
					@ LI,001 PSAY T_REGION + " - " + T_REGNOM
					LI+=2
				Endif
			endif

			aSubTot := {0,0,0,0}
			cChave1 := T_TIPOV //+T_VEND

			@ LI,001+nMaisPos PSAY aTipoVend[Val(T_TIPOV)] //+": "+T_VEND+" "+T_NOMEV
			LI++

			Do While !eof() .and. T_TIPOV = cChave1 .AND. cRegion = T_REGION

				aTotReg := {0,0,0,0}
				cChave2 := T_TIPOREG
				cChave3 := T_VEND
				cNomeVd := T_NOMEV

				Do while !eof() .AND. T_TIPOREG = cChave2 .and. T_TIPOV = cChave1 .AND. cRegion = T_REGION .AND. cChave3 = T_VEND
					incProc("Imprimindo...")
					aTotReg[1]  += T_VALOR
					aTotReg[2]  += T_VALBX
					aTotReg[3]  += T_SALDO
					aTotReg[4]  += T_VALCOM

					aSubTot[1]  += T_VALOR
					aSubTot[2]  += T_VALBX
					aSubTot[3]  += T_SALDO
					aSubTot[4]  += T_VALCOM

					aTotGer[1]  += T_VALOR
					aTotGer[2]  += T_VALBX
					aTotGer[3]  += T_SALDO
					aTotGer[4]  += T_VALCOM

					dbSkip()
				Enddo

				lImp:=.T.
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
					LI:=LI+2
					if lRegiao
						@ LI,001 PSAY T_REGION + " - " + T_REGNOM
						LI+=2
					Endif
				endif
				if !Empty(cChave3)
					@ LI,010 PSAY cChave3 + " " + cNomeVd
				Else
					@ LI,010 PSAY "??????" + " SEM VENDEDOR"
				Endif
				@ LI,108 PSAY aTotReg[1] PICTURE "@E 99,999,999,999.99"
				@ LI,128 PSAY aTotReg[2] PICTURE "@E 99,999,999,999.99"
				@ LI,148 PSAY aTotReg[3] PICTURE "@E 99,999,999,999.99"
				@ LI,181 PSAY aTotReg[4] PICTURE "@E 99,999,999,999.99"
				LI++
			Enddo
			@ LI,010 PSAY "       Sub-Total" 
			@ LI,108 PSAY aSubTot[1] PICTURE "@E 99,999,999,999.99"
			@ LI,128 PSAY aSubTot[2] PICTURE "@E 99,999,999,999.99"
			@ LI,148 PSAY aSubTot[3] PICTURE "@E 99,999,999,999.99"
			@ LI,181 PSAY aSubTot[4] PICTURE "@E 99,999,999,999.99"
			LI+=2
		Enddo
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()
	
	fErase(cNomTmp+GetDBExtension())

	if lImp .AND. !lAbortPrint
		LI++
		@ LI,010 PSAY "       Total Geral" 
		@ LI,108 PSAY aTotGer[1] PICTURE "@E 99,999,999,999.99"
		@ LI,128 PSAY aTotGer[2] PICTURE "@E 99,999,999,999.99"
		@ LI,148 PSAY aTotGer[3] PICTURE "@E 99,999,999,999.99"
		@ LI,181 PSAY aTotGer[4] PICTURE "@E 99,999,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
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
		If RecLock("TMP",.T.)
			TMP->T_REGION  := iif(lRegiao,ARQ_SQL->PB0_REGION,"")
			TMP->T_REGNOM  := ARQ_SQL->PB9_DESCR
			TMP->T_TIPOV   := cTipoVend
			TMP->T_VEND    := ARQ_SQL->VEND
			TMP->T_NOMEV   := ARQ_SQL->A3_NOME
			TMP->T_TIPOREG := cTipoReg
			TMP->T_VALOR   := ARQ_SQL->E1_VALOR
			TMP->T_VALBX   := ARQ_SQL->VALOR
			TMP->T_SALDO   := ARQ_SQL->E1_SALDO
			TMP->T_COMIS   := iif(ARQ_SQL->CLI_COMIS > 0 , ARQ_SQL->CLI_COMIS , ARQ_SQL->COMIS)
			//TMP->T_VALCOM  := ARQ_SQL->E1_VALOR*(TMP->T_COMIS/100)
			TMP->T_VALCOM  := ARQ_SQL->VALOR*(TMP->T_COMIS/100)
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo	
Return nil

// Ajusta campos para padrão Protheus
Static Function VerCpo(cTxt)
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","E1_EMISSAO","D")})
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","E1_VALOR"  ,"N",14,2)})
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","E1_SALDO"  ,"N",14,2)})
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","VALOR"     ,"N",14,2)})
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","COMIS"     ,"N",06,2)})
	MsgRun(cTxt,,{|| TcSetField("ARQ_SQL","CLI_COMIS" ,"N",06,2)})
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