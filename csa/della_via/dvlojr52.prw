#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVLOJR52
	Private cString        := "SF2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Divergencias Duplicatas X Cond. Pagamento"
	Private tamanho        := "G"
	Private nomeprog       := "DVLOJR52"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "LOJR52"
	Private titulo         := "Divergencias Duplicatas X Cond. Pagamento"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVLOJR52"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := "CSTR04"
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da Filial          ?"," "," ","mv_ch1","C", 02,0,0,"G","","mv_par01",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Filial       ?"," "," ","mv_ch2","C", 02,0,0,"G","","mv_par02",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Da Emissao         ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate a Emissao      ?"," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""     ,"","","","",""     ,"","","","",""          ,"","","","",""     ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Divergencias       ?"," "," ","mv_ch5","N", 01,0,0,"C","","mv_par05","Todas","","","","","Forma","","","","","Vencimento","","","","","Valor","","","","","","","","","   ","","","",""          })

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
	Cabec1:=" Loja   Prefixo   Numero   P   Cliente                                      Emissao    Vencimento           Valor   Cond   Tipo   Forma   Divergencia"
	        * XX     XXX       XXXXXX   X   XXXXXX/XX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99   99/99/99     99,999,999.99   XXX    XX     XX      XXXXXXXXXXXXXXXXXXXXXXXXX
		    *012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17

	cSql := ""
	cSql := cSql + "SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_COND,F2_DUPL,F2_VALFAT"
	cSql := cSql + " ,     E4_FORMA"
	cSql := cSql + " ,     E1_PREFIXO,E1_NUM,E1_TIPO,E1_PARCELA,E1_EMISSAO,E1_VALOR,E1_TIPO,E1_VENCREA"
	cSql := cSql + " ,     A1_NOME"
	cSql := cSql + " FROM "+RetSqlName("SF2")+" SF2"

	cSql := cSql + " JOIN "+RetSqlName("SE4")+" SE4"
	cSql := cSql + " ON   SE4.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  E4_FILIAL = ''"
	cSql := cSql + " AND  E4_CODIGO = F2_COND"

	cSql := cSql + " JOIN "+RetSqlName("SE1")+" SE1"
	cSql := cSql + " ON   SE1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  E1_FILIAL = ''"
	cSql := cSql + " AND  E1_PREFIXO = F2_PREFIXO"
	cSql := cSql + " AND  E1_NUM = F2_DUPL"
	cSql := cSql + " AND  E1_MSFIL = F2_FILIAL"

	cSql := cSql + " JOIN "+RetSqlName("SA1")+" SA1"
	cSql := cSql + " ON   SA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  A1_FILIAL = ''"
	cSql := cSql + " AND  A1_COD = F2_CLIENTE"
	cSql := cSql + " AND  A1_LOJA = F2_LOJA"

	cSql := cSql + " WHERE SF2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql := cSql + " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	cSql := cSql + " AND   F2_DUPL <> ''"
	cSql := cSql + " ORDER BY F2_FILIAL,F2_DOC,F2_SERIE,E1_PARCELA"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","E1_EMISSAO","D")
	TcSetField("ARQ_SQL","E1_VENCREA","D")
	TcSetField("ARQ_SQL","E1_VALOR","N",14,2)
	TcSetField("ARQ_SQL","F2_VALFAT","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
        aPagto := Condicao(F2_VALFAT,F2_COND,,E1_EMISSAO,)
		dbSelectArea("ARQ_SQL")
		cTit := E1_PREFIXO+E1_NUM

		lNota := .F.
		Do While !eof() .and. E1_PREFIXO+E1_NUM = cTit
			IncProc("Imprimindo ...")
			If lAbortPrint
				LI+=3
				@ LI,001 PSAY "*** Cancelado pelo Operador ***"
				lImp := .F.
				exit
			Endif

			lErr := .F.
			cErr := ""
			if AllTrim(E1_TIPO) <> AllTrim(E4_FORMA) .AND. (mv_par05 = 1 .OR. mv_par05 = 2)
				lErr := .T.
				cErr += "Forma"
			Endif
		
			lVenc := .T.
			For k=1 to Len(aPagto)
				if aPagto[k,1] = E1_VENCREA
					lVenc := .F.
				Endif
			Next k
			if lVenc .AND. (mv_par05 = 1 .OR. mv_par05 = 3)
				lErr := .T.
				cErr += iif(Len(AllTrim(cErr))>0,",","") + "Vencimento"
			Endif

			lValor := .T.
			For k=1 to Len(aPagto)
				if aPagto[k,2] = E1_VALOR
					lValor := .F.
				Endif
			Next k
			if lValor .AND. (mv_par05 = 1 .OR. mv_par05 = 4)
				lErr := .T.
				cErr += iif(Len(AllTrim(cErr))>0,",","") + "Valor"
			Endif

			If lErr
				lNota := .T.
				lImp  := .T.
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
					LI+=2
				endif
				@ LI,001 PSAY F2_FILIAL
				@ LI,008 PSAY E1_PREFIXO
				@ LI,018 PSAY E1_NUM
				@ LI,027 PSAY E1_PARCELA
				@ LI,031 PSAY F2_CLIENTE+"/"+F2_LOJA+" - "+OemToAnsi(Substr(A1_NOME,1,30))
				@ LI,076 PSAY E1_EMISSAO
				@ LI,087 PSAY E1_VENCREA
				@ LI,100 PSAY E1_VALOR PICTURE "@e 99,999,999.99"
				@ LI,116 PSAY F2_COND
				@ LI,123 PSAY E1_TIPO
				@ LI,130 PSAY E4_FORMA
				@ LI,138 PSAY cErr
				LI++
			Endif
			dbSkip()
		Enddo
		If lNota
			LI++
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