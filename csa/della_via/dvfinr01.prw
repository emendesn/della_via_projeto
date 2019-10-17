#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVFINR01
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := ""
	Private tamanho        := "P"
	Private nomeprog       := "DVFINR01"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DVFN01"
	Private titulo         := "Atrasados X Compra a vista"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVFINR01"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Do Vencimento      ?"," "," ","mv_ch1","D", 08,0,0,"G",""             ,"mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate o Vencimento   ?"," "," ","mv_ch2","D", 08,0,0,"G",""             ,"mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Compra a partir de ?"," "," ","mv_ch3","D", 08,0,0,"G",""             ,"mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"04","Formas Pgto a vista?"," "," ","mv_ch4","C", 50,0,0,"G","U_fSelForma()","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })

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
	Cabec1:="     Prf   Numero     Emissao    Vencimento        Valor   Loja"
	        *     XXX   XXXXXX/X   99/99/99   99/99/99     999,999.99   XX
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cForma := ""
	For k=1 To Len(Alltrim(mv_par04)) Step 3
		cForma += iif(Substr(mv_par04,k,3)<>"***","'"+Substr(mv_par04,k,3)+"',","")
	Next k
	cForma := Substr(cForma,1,Len(cForma)-1)


	cSql := ""
	cSql := cSql + "SELECT E1_CLIENTE,E1_LOJA,A1_NOME,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_EMISSAO,E1_VENCREA,E1_VALOR,E1_MSFIL"
	cSql := cSql + " FROM "+RetSqlName("SE1")+" SE1

	cSql := cSql + " JOIN "+RetSqlName("SA1")+" SA1"
	cSql := cSql + " ON   SA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  A1_FILIAL = ''"
	cSql := cSql + " AND  A1_COD = E1_CLIENTE"
	cSql := cSql + " AND  A1_LOJA = E1_LOJA"

	cSql := cSql + " WHERE SE1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   E1_FILIAL = ''"
	cSql := cSql + " AND   E1_VENCREA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   E1_SALDO > 0"
	cSql := cSql + " AND   E1_STATUS = 'A'"
	cSql := cSql + " ORDER BY E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","E1_EMISSAO","D")
	TcSetField("ARQ_SQL","E1_VENCREA","D")
	TcSetField("ARQ_SQL","E1_VALOR"  ,"N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
		cCli := E1_CLIENTE+E1_LOJA

		cSql := ""
		cSql := cSql + "SELECT F2_PREFIXO,F2_DOC,F2_EMISSAO,F2_VALFAT,F2_FILIAL"
		cSql := cSql + " FROM "+RetSqlName("SF2")+" SF2"

		cSql := cSql + " JOIN "+RetSqlName("SE4")+" SE4"
		cSql := cSql + " ON   SE4.D_E_L_E_T_ = ''"
		cSql := cSql + " AND  E4_FILIAL = ''"
		cSql := cSql + " AND  E4_CODIGO = F2_COND"
		cSql := cSql + " AND  E4_FORMA IN("+cForma+")"

		cSql := cSql + " WHERE SF2.D_E_L_E_T_ = ''"
		cSql := cSql + " AND   F2_FILIAL BETWEEN '' AND 'ZZ'"
		cSql := cSql + " AND   F2_CLIENTE = '"+ARQ_SQL->E1_CLIENTE+"'"
		cSql := cSql + " AND   F2_LOJA = '"+ARQ_SQL->E1_LOJA+"'"
		cSql := cSql + " AND   F2_EMISSAO > '"+dtos(mv_par03)+"'"
		cSql := cSql + " ORDER BY F2_PREFIXO,F2_DOC"

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_AVISTA", .T., .T.)

		TcSetField("SQL_AVISTA","F2_EMISSAO","D")
		TcSetField("SQL_AVISTA","F2_VALFAT" ,"N",14,2)

		dbSelectArea("SQL_AVISTA")
		If eof()
			dbCloseArea()
			dbSelectArea("ARQ_SQL")
			Do While !eof() .AND. cCli = E1_CLIENTE+E1_LOJA
				IncProc("Imprimindo ...")
				dbSkip()
			Enddo
			Loop
		Endif

		dbSelectArea("ARQ_SQL")
		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif

		@ li,000 PSAY E1_CLIENTE+"/"+E1_LOJA+" - "+A1_NOME
		LI++

		@ LI,005 PSAY "Titulos em aberto"
		LI++
		Do While !eof() .and. cCli =  E1_CLIENTE+E1_LOJA
			IncProc("Imprimindo ...")
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
	
			@ LI,005 PSAY E1_PREFIXO
			@ LI,011 PSAY E1_NUM + iif(Len(AllTrim(E1_PARCELA))>0,"/"+E1_PARCELA,"")
			@ LI,022 PSAY E1_EMISSAO
			@ LI,033 PSAY E1_VENCREA
			@ LI,046 PSAY E1_VALOR PICTURE "@E 999,999.99"
			@ LI,059 PSAY E1_MSFIL
			LI++
			dbSkip()
		Enddo
		LI++

		dbSelectArea("SQL_AVISTA")
		dbGotop()
		@ LI,005 PSAY "Compras a vista"
		LI++
		Do While !eof()
			IncProc("Imprimindo ...")
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
	
			@ LI,005 PSAY F2_PREFIXO
			@ LI,011 PSAY F2_DOC
			@ LI,022 PSAY F2_EMISSAO
			@ LI,046 PSAY F2_VALFAT PICTURE "@E 999,999.99"
			@ LI,059 PSAY F2_FILIAL
			LI++
			dbSkip()
		Enddo
		dbCloseArea()
		dbSelectArea("ARQ_SQL")
		LI++
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

User Function fSelForma()
	Local   cTitulo  := ""
	Local   MvPar
	Local   MvParDef := ""
	Private aSit     := {}
	Private l1Elem   := .F.

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	cAlias := Alias()

	dbSelectArea("SX5")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SX5")+"24")
	Do while !eof() .and. X5_TABELA = "24"
		aAdd(aSit,Substr(X5_CHAVE,1,3)+" - "+AllTrim(X5_DESCRI))
		mvParDef := mvParDef + Substr(X5_CHAVE,1,3)
		dbSkip()
	Enddo

	dbSelectArea(cAlias)

	cTitulo :="Formas de Pagamento"
	Do While .T. 
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,,,l1Elem,3)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
		if mvpar = Replicate("*",Len(mvParDef))
			MsgBox("Voce deve selecionar pelo menos 1 forma de pagamanto","Tipo de venda","STOP")
			Loop
		Else
			Exit
		Endif
	Enddo
Return MvParDef