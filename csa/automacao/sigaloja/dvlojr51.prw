#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVLOJR51
	Private cString        := "PA8"
	Private aOrd           := {"Loja Seguro","Loja Sinistro"}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Relatório de sinistros"
	Private tamanho        := "G"
	Private nomeprog       := "DVLOJR51"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DVR051"
	Private titulo         := "Relatório de sinistros"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVLOJR51"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data             "," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate a Data          "," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Da Seguradora       "," "," ","mv_ch3","C", 03,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","PA9","","","",""          })
	AADD(aRegs,{cPerg,"04","Ate a Seguradora    "," "," ","mv_ch4","C", 03,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","PA9","","","",""          })
	aAdd(aRegs,{cPerg,"05","Tipo                "," "," ","mv_ch5","N", 01,0,0,"C","","mv_par05","Rodas"  ,"","","","","Pneus"  ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"06","Mostra Bonificação  "," "," ","mv_ch6","N", 01,0,0,"C","","mv_par06","Sim"    ,"","","","","Não"    ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","",""          })

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
	titulo:=AllTrim(titulo)+" - "+iif(mv_par05=1,"Rodas","Pneus")+" - De "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
	Cabec1:="     Loja     Data       Nota       Nota                                                                           Km            Km                                                    Loja"
	Cabec2:="     Seguro   Sinistro   Sinistro   Seguro        Valor   Apolice   Matricula         Lacre        Residuo   Sinistro        Seguro     Cliente                                        Sinistro"+iif(mv_par06=1,"   % Bonific   ","")
	        *     XX       99/99/99   XXXXXX     XXXXXX   999,999.99   XXXXXX    XXXXXXXXXXXXXXX   XXXXXXXXXX    999.99    999,999       999,999     XXXXXX/XX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XX            999.99   ______
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cSql := ""
	cSql := cSql + "SELECT PA8_CODSEG,PA9_DESC,PA8_LOJSG,PA8_DTSN,PA8_NFSN,PA8_NFSG"
	cSql := cSql + " ,PA8_VLRSEG"
	cSql := cSql + " ,      PA8_APOLIC,PA8_MATRIC,PA8_LACRE,PA8_RESID,PA8_KMSN,PA8_KMSG,PA8_CODCLI,PA8_PERC"
	cSql := cSql + " ,      PA8_LOJCLI,PA8_NOMCLI,PA8_LOJSN"
	cSql := cSql + " FROM "+RetSqlName("PA8")+" PA8"

	cSql := cSql + " LEFT JOIN "+RetSqlName("PA9")+" PA9"
	cSql := cSql + " ON PA9.D_E_L_E_T_ = ''"
	cSql := cSql + " AND PA9_COD = PA8_CODSEG"

	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND B1_COD = PA8_CPROSN"

	cSql := cSql + " JOIN "+RetSqlName("SBM")+" SBM"
	cSql := cSql + " ON SBM.D_E_L_E_T_ = ''"
	cSql := cSql + " AND BM_GRUPO = B1_GRUPO"
	if mv_par05 = 1
		cSql := cSql + " AND BM_TIPOPRD = 'R'"
	Else
		cSql := cSql + " AND BM_TIPOPRD = 'P'"
	Endif

	cSql := cSql + " WHERE PA8.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   PA8_DTSN BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   PA8_CODSEG BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql := cSql + " AND   PA8_NFDEV = ''"
	cSql := cSql + " ORDER BY PA8_CODSEG"
	If aReturn[8] = 1
		cSql := cSql + ",PA8_LOJSG,PA8_DTSN"
	Else
		cSql := cSql + ",PA8_LOJSN,PA8_DTSN"
	Endif

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","PA8_DTSN","D")
	TcSetField("ARQ_SQL","PA8_VLRSEG","N",09,2)
	TcSetField("ARQ_SQL","PA8_RESID" ,"N",06,2)
	TcSetField("ARQ_SQL","PA8_KMSN"  ,"N",06,0)
	TcSetField("ARQ_SQL","PA8_KMNF"  ,"N",06,0)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	nTotGeral := 0
	Do While !eof()
		cChave := PA8_CODSEG
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI+=2
		@ LI,001 PSAY PA8_CODSEG+" - "+PA9_DESC
		if mv_par06 = 1
			@ LI,206 PSAY " ____ "
		Else
			@ LI,197 PSAY " ____ "
		Endif
		LI++
		
		nSubTot := 0
		Do While !eof() .and. PA8_CODSEG = cChave
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
				if mv_par06 = 1
					@ LI,206 PSAY " ____ "
				Else
					@ LI,197 PSAY " ____ "
				Endif
				LI++
			endif

			@ LI,005 PSAY PA8_LOJSG
			@ LI,014 PSAY PA8_DTSN
			@ LI,025 PSAY PA8_NFSN
			@ LI,036 PSAY PA8_NFSG
			@ LI,045 PSAY PA8_VLRSEG Picture "@e 999,999.99"
			@ LI,058 PSAY PA8_APOLIC
			@ LI,068 PSAY PA8_MATRIC
			@ LI,086 PSAY PA8_LACRE
			@ LI,100 PSAY PA8_RESID  Picture "@e 999.99"
			@ LI,110 PSAY PA8_KMSN   Picture "@e 999,999"
			@ LI,124 PSAY PA8_KMSG   Picture "@e 999,999"
			@ LI,136 PSAY PA8_CODCLI+"/"+PA8_LOJCLI+" - "+Substr(PA8_NOMCLI,1,30)
			@ LI,183 PSAY PA8_LOJSN
			if mv_par06 = 1
				@ LI,197 PSAY PA8_PERC Picture "@e 999.99"
				@ LI,203 PSAY "%"
				@ LI,206 PSAY "|____|"
			Else
				@ LI,197 PSAY "|____|"
			Endif
			LI++
			nSubTot   += PA8_VLRSEG
			nTotGeral += PA8_VLRSEG
			dbSkip()
		Enddo
		LI++
		@ LI,001 PSAY "Total da Seguradora:"
		@ LI,045 PSAY nSubTot Picture "@e 999,999.99"
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	if lImp .and. !lAbortPrint
		if mv_par06 = 1
			LI+=2
			@ LI,001 PSAY "Total Geral:"
			@ LI,045 PSAY nTotGeral Picture "@e 999,999.99"
		Endif
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil