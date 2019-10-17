#Include "rwmake.ch"
#Include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)


User Function DESTR18 ()
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Declaracao de Variaveis                                             Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Private cString        := "SE1"
	Private aOrd           := {}
	Private cDesc1      := "Pesquisa Sepu / NCC "
	Private cDesc2      := "Informar o CСdigo do Cliente:"
	Private cDesc3      := "(S)epu / (C)upom            :"
	Private cPict       := ""
	Private titulo      := "Relatorio de NCC por Cliente"
	Private Cabec2      := " "                                                                                                                           
	Private Cabec1      := " Codigo LJ Cliente              Titulo P Pre Tip Emissao     Valor Baixa      Saldo  Coleta Mot Descricao Motivo"
	Private imprime     := .T.
	Private cPerg       := "DEST18"
	Private nLin        := 80
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "DESTR18"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "DESTR18"
	Private aPergunta   := {}
	Private aRegs    := {}  

	cPerg    := PADR(cPerg,6)
                                                                                                       
	AAdd(aRegs,{cPerg,"01","Codigo Cliente ?"        ," "       ," "       ,"mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","" ,"SA1","","","",""})
	AAdd(aRegs,{cPerg,"02","Loja           ?"        ," "       ," "       ,"mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
	AAdd(aRegs,{cPerg,"03","[S]epu [C]upom ?"        ," "       ," "       ,"mv_ch3","C", 1,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
	AAdd(aRegs,{cPerg,"04","Data Inicial   ?"        ," "       ," "       ,"mv_ch4","D", 8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
	AAdd(aRegs,{cPerg,"05","Data Final     ?"        ," "       ," "       ,"mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","",""})
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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)


    If nLastKey == 27
		Return nil
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return nil
	Endif

    if mv_par01 != space(6)
		RptStatus({||Runreport()})
    endif
    
Return nil


Static Function RunReport()

	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

	cQry := "SELECT E1_FILIAL ,E1_NOMCLI,E1_EMISSAO,E1_HIST   ,E1_NUMNOTA,E1_SERIE,E1_MOTDESC,E1_NUM ,E1_PARCELA"
	cQry += "      ,E1_PREFIXO,E1_TIPO  ,E1_NATUREZ,E1_CLIENTE,E1_LOJA   ,E1_VALOR,E1_SALDO  ,E1_BAIXA,E1_COLETA"
	cQry += " FROM "+RetSqlName("SE1")
	cQry += " WHERE D_E_L_E_T_ = ''"
	cQry += " AND   E1_FILIAL  = '  '"              
	if upper(mv_par03) = "T"
	   	cQry += " AND   E1_CLIENTE > '      ' AND E1_CLIENTE < 'ZZZZZZ' "
    else
        cQry += " AND   E1_CLIENTE = '" + mv_par01 + "' "
    endif
	cQry += " AND   E1_LOJA    = '" + mv_par02 + "' "
	cQry += " AND   E1_PREFIXO = 'SEP' "
	if upper(mv_par03) = "S"
	   cQry += " AND E1_MOTDESC <> '390' "
	else
	   cQry += " AND E1_MOTDESC  = '390' "
	endif
	if mv_par04 # CTOD("  /  /  ") .or. mv_par05 # CTOD("  /  /  ")
	    cQry += " AND E1_EMISSAO >= '" + DTOS(mv_par04) + "'" 
	    cQry += " AND E1_EMISSAO <= '" + DTOS(mv_par05) + "'"
	endif
	    
    cQry += " ORDER BY E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA" 
    
	MsgRun("Consultando Banco de dados ...",,{|| cQry:= ChangeQuery(cQry)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"TRB", .F., .T.)})

	TcSetField("TRB","E1_EMISSAO","D")
	TcSetField("TRB","E1_BAIXA",  "D")
	TcSetField("TRB","E1_SALDO",  "N",14,2)
	TcSetField("TRB","E1_VALOR"  ,"N",14,2)
	
	dbSelectArea("TRB")
	ProcRegua(0)

	While !EOF()      
	     
		 IncProc("Imprimindo ...")
	
		 IF lAbortPrint
		  	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		 Endif
		 
         IF nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			nLin := 9
		 EndIF
     
         @ nLin,001      PSAY TRB->E1_CLIENTE
         @ nLin,PCOL()+1 PSAY TRB->E1_LOJA
		 @ nLin,PCOL()+1 PSAY TRB->E1_NOMCLI
		 @ nLin,PCOL()+1 PSAY TRB->E1_NUM 
		 @ nLin,PCOL()+1 PSAY TRB->E1_PARCELA
		 @ nLin,PCOL()+1 PSAY TRB->E1_PREFIXO
		 @ nLin,PCOL()+1 PSAY TRB->E1_TIPO  
		 @ nLin,PCOL()+1 PSAY TRB->E1_EMISSAO
		 @ nLin,PCOL()+1 PSAY TRB->E1_VALOR   PICTURE "@E 9,999.99"
		 @ nLin,PCOL()+1 PSAY TRB->E1_BAIXA
		 @ nLin,PCOL()+1 PSAY TRB->E1_SALDO   PICTURE "@E 9,999.99"
		 @ nLin,PCOL()+1 PSAY TRB->E1_COLETA 
		 @ nLin,PCOL()+1 PSAY TRB->E1_MOTDESC
         dbSelectArea("SZS")
         dbSetOrder(1) 
         dbSeek("  " + TRB->E1_MOTDESC)
         @ nLin,PCOL()+1 PSAY SZS->ZS_DESCR      
         nLin ++
		 dbSelectArea("TRB")    
 		 dbSkip()
	EndDo

	Roda(cbcont,cbtxt,"G")
	dbSelectArea("TRB")
	dbCloseArea("TRB")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return


