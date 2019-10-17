#include "rwmake.ch"
#include "topconn.ch"

User Function DFATR95()
	Private cString        := "SF2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Vendedor X Cliente X NF"
	Private tamanho        := "P"
	Private nomeprog       := "DFATR95
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFAT95
	Private titulo         := "Vendedor X Cliente X NF"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR95"
	Private lImp           := .F.
	Private aTipoVend      := {"Motorista","Vendedor","Indicador"}

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AAdd(aRegs,{cPerg,"01","Imprimir?           "," "," ","mv_ch1","N", 01,0,0,"C","","mv_par01","Motorista","","","","","Vendendor"   ,"","","","","Indicador","","","","",""     ,"","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Do Vendedor?        "," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"03","Ate o Vendedor?     "," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"04","Da Emissão?         "," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"05","Ate a Emissão?      "," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})
	AADD(aRegs,{cPerg,"06","Do Cliente?         "," "," ","mv_ch6","C", 06,0,0,"G","","mv_par06",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA1","","","",""})
	AADD(aRegs,{cPerg,"07","Ate o Cliente?      "," "," ","mv_ch7","C", 06,0,0,"G","","mv_par07",""         ,"","","","",""            ,"","","","",""         ,"","","","",""     ,"","","","","","","","","SA1","","","",""})
	AAdd(aRegs,{cPerg,"08","Imprimir notas?     "," "," ","mv_ch8","N", 01,0,0,"C","","mv_par08","Sim"      ,"","","","","Não"         ,"","","","",""         ,"","","","",""     ,"","","","","","","","","   ","","","",""})

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
	Cabec1:="     Cliente                                                  Total"
	Cabec2:="          Emissao    Documento                Valor"
	        *     XXXXXX-XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999.99
	        *          99/99/99   XXXXXX-XXX   99,999,999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22


	// Query
	cSql := "SELECT F2_VEND"+Str(mv_par01+2,1)+" AS VEND,A3_NOME,F2_CLIENTE,F2_LOJA,A1_NOME,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALFAT"
	cSql += " FROM "+RetSqlName("SF2")+" SF2"

	cSql += " JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
	cSql += " AND  A3_COD = F2_VEND"+Str(mv_par01+2,1)

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA3")+"'"
	cSql += " AND  A1_COD = F2_CLIENTE"
	cSql += " AND  A1_LOJA = F2_LOJA"

	cSql += " WHERE SF2.D_E_L_E_T_ = ''"
	cSql += " AND   F2_FILIAL = '"+xFilial("SF2")+"'"
	cSql += " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par04)+"' AND '"+dtos(mv_par05)+"'"
	cSql += " AND   F2_VEND"+Str(mv_par01+2,1)+" BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cSql += " AND   F2_CLIENTE BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	cSql += " AND   F2_VALFAT > 0"
	cSql += " ORDER BY F2_VEND3,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","F2_EMISSAO","D")
	TcSetField("ARQ_SQL","F2_VALFAT" ,"N",14,2)
	
	if mv_par08 = 2
		Cabec2 := ""
	Endif

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()
	nTotGer := 0

	Do While !eof()
		cVend := VEND
		nTotVend := 0
		lImp := .T.

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif

		aFerias := VerZZ0(Vend)

		@ LI,001 PSAY aTipoVend[mv_par01]+": "+VEND+" - "+A3_NOME
		LI++

		Do While !eof() .AND. VEND = cVend
			cCliente := F2_CLIENTE+F2_LOJA
			cNomeCli := Substr(A1_NOME,1,30)
			nTotal   := 0
			aNF      := {}
			
			Do while !eof() .AND. VEND = cVend .AND. F2_CLIENTE+F2_LOJA = cCliente
				IncProc("Imprimindo ...")

				lSoma := .T.
				For j=1 to Len(aFerias)
					If F2_EMISSAO >= aFerias[j,1] .AND. F2_EMISSAO <= aFerias[j,2]
						lSoma := .F.
					Endif
				Next j

				if lSoma
					nTotal += F2_VALFAT
					aadd(aNF,{F2_EMISSAO,F2_DOC,F2_SERIE,F2_VALFAT})
				Endif

				dbSkip()
			Enddo

			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif

			If nTotal > 0
				@ LI,005 PSAY Substr(cCliente,1,6)+"-"+Substr(cCliente,7,2)
				@ LI,017 PSAY cNomeCli
				@ LI,050 PSAY nTotal Picture "@e 99,999,999,999.99"
				nTotVend += nTotal
				nTotGer  += nTotal
				LI++

				If mv_par08 = 1
					For k=1 to Len(aNF)
						IncProc("Imprimindo ...")
						if li>55
							LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
							LI+=2
						endif
						@ LI,010 PSAY aNF[k,1]
						@ LI,021 PSAY aNF[k,2] + "-" + aNF[k,3]
						@ LI,034 PSAY aNF[k,4] Picture "@e 99,999,999,999.99"
						LI++
					Next
					LI++
				Endif
			Endif
		Enddo
		@ LI,001 PSAY "Total do "+aTipoVend[mv_par01]+": "+Transform(nTotVend,"@E 99,999,999,999.99")
		LI+=2
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp
        @ LI,001 PSAY "Total do Geral: "+Transform(nTotGer,"@E 99,999,999,999.99")
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

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