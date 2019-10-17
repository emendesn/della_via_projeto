#Include "rwmake.ch"
#Include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     � Autor � AP6 IDE            � Data �  09/01/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DESTR14
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local   aPergunta   := {}
	Local   cSql        := ""
	Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2      := "de acordo com os parametros informados pelo usuario."
	Private cDesc3      := "Saldos por setores de produ��o"
	Private cPict       := ""
	Private titulo      := "Saldo por status de produ��o"
	Private Cabec2      := " "                                                                                                                          
	Private Cabec1      := " Ordem Pro Cliente              Carca�a         Desenho        S�rie/Fogo      Status.Prod. S Dt.Prod. Valor NCC Observa��o"
	Private imprime     := .T.
	Private aOrd        := {}
	Private cPerg       := "DEST14"
	Private nLin        := 80
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "DESTR14"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "DESTR14"
	Private cString     := "SC2"
	Private aStatus     := {}


	cSql := "SELECT X5_CHAVE,X5_DESCRI FROM "+RetSqlName("SX5")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   X5_FILIAL = ''"
	cSql += " AND   X5_TABELA = 'Z1'"
	cSql += " ORDER BY X5_CHAVE"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SX5_SQL", .T., .T.)
	dbSelectArea("SX5_SQL")
	Do while !eof()
		aadd(aStatus,{ AllTrim(X5_CHAVE),Capital(AllTrim(X5_DESCRI)) })
		dbSkip()
	Enddo
	dbCloseArea()


	dbSelectArea("SC2")
	dbSetOrder(1)

	dbSelectArea("SX1")
	dbSeek(cPerg)
	If Found()
		If RecLock("SX1",.F.)
			SX1->X1_CNT01 := "'01/01/01'"
			MsUnlock()
		Endif
		dbSkip()

		// Tratamento de datas inv�lidas
		if Empty(dtos(ctod(StrZero(Day(dDataBase),2)+"/"+StrZero(Month(dDataBase),2)+"/"+Str(Year(dDataBase)+2,4))))
			dData := dDataBase + 1
		Else
			dData := dDataBase
		Endif

		If RecLock("SX1",.F.)
			SX1->X1_CNT01 := "'"+StrZero(Day(dData),2)+"/"+StrZero(Month(dData),2)+"/"+Substr(Str(Year(dData)+2,4),3,2)+"'"
			MsUnlock()
		Endif
	Endif


	AAdd(aPergunta,{cPerg,"01","Da Data Entrega  ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"02","Ate Data Entrega ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aPergunta,{cPerg,"03","(E)xame ( ) Todos?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch3","C", 1,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})

	ValidPerg(aPergunta,cPerg)

	while .t.
		Pergunte(cPerg,.F.)

		//���������������������������������������������������������������������Ŀ
		//� Monta a interface padrao com o usuario...                           �
		//�����������������������������������������������������������������������
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

		If nLastKey == 27
			exit
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Exit
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//���������������������������������������������������������������������Ŀ
		//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
		//�����������������������������������������������������������������������
		Processa({|| RunReport() },Titulo,,.t.)
	Enddo
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  09/01/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport()
	Local nOrdem
	Local nTotal  := 0
	Local nGeral  := 0

	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

	cQry := "SELECT C2_NUM,C2_ITEM,C2_SEQUEN,C2_XNREDUZ,C2_QUJE,C2_QUANT,C2_X_STATU,C2_FORNECE,C2_LOJA"
	cQry += "      ,C2_PRODUTO,C2_DATPRF,C2_X_DESEN,C2_NUMFOGO,C2_SERIEPN,C2_XMREDIR,C2_XMREPRD,C2_XMREFIN,C2_OBS"
	cQry += " FROM "+RetSqlName("SC2")
	cQry += " WHERE D_E_L_E_T_ = ''"
	cQry += " AND   C2_FILIAL = '" + xFilial("SC2") + "'"
	cQry += " AND   C2_DATPRF BETWEEN '"+Dtos(mv_par01)+"' AND  '"+Dtos(mv_par02)+"'"
	if mv_par03 = "E"
	   cQry += " AND C2_X_DESEN LIKE 'EXAM%' "
	endif
    cQry += " ORDER BY C2_X_STATU,C2_FORNECE,C2_LOJA,C2_DATPRF"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRB",.F.,.T.)

	//���������������������������������������������������������������������Ŀ
	//� SETREGUA -> Indica quantos registros serao processados para a regua �
	//�����������������������������������������������������������������������
	ProcRegua(ContaSql("TRB"))

	dbGoTop()
	cStatus := TRB->C2_X_STATU  //
	cStatus := "?"

	While !EOF()      
	     
		IncProc("Imprimindo ...")
	
		IF lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		IF TRB->C2_X_STATU $ "6/9" //Produzido - Rejeitado
			dbSelectArea("SC6")
			dbSetOrder(7)                                      
			dbSeek(xFilial("SC6") + TRB->C2_NUM+TRB->C2_ITEM )  
			IF !Empty(SC6->C6_NOTA) // Ja Faturado 
     	   	   dbSelectArea("TRB")    
 		       dbSkip()
               LOOP
            ENDIF
         ENDIF   

		IF cStatus = "?"
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin    := 9 
			cStatus := TRB->C2_X_STATU
			@ nLin,001 PSAY "Setor : " + OndeEsta(cStatus)
			nLin    += 2    
			nTotal  := 0
		Endif
		
		IF cStatus <> TRB->C2_X_STATU
           IF nLin > 55
         	   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
         	   nLin := 9
		   EndIF
	
		   nLin ++
		   @ nLin,001 PSAY "Subtotal :"
		   @ nLin,020 PSAY nTotal Picture "@E 99,999,999"
		
		   nTotal  := 0
           cStatus := TRB->C2_X_STATU
           IF nLin > 55
			  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			  nLin := 9
		   EndIF
		   nLin    += 2
   
		   @ nLin,001 PSAY "Setor : " + OndeEsta(TRB->C2_X_STATU)
		   nLin    += 2
			
		EndIF
        //          1         2         3         4         5         6         7         8         9        100       110       120
        // 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		// Ordem Pro Cliente              Carca�a         Desenho        S�rie/Fogo      Status.Prod. Dt.Prod. Observa��o
		// 101457-01 MARIMEX DESPACHOS TR 295/80R22.5     EXAME          549             SEM LAUDO    27/06/06 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
         
         IF nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			nLin := 9
		 EndIF
     
 		 dbSelectArea("SA1")
         dbSetOrder(1) 
         dbSeek(xFilial("SA1") + TRB->C2_FORNECE+TRB->C2_LOJA)
         @ nLin,001 PSAY Padr(TRB->C2_NUM+"-"+TRB->C2_ITEM,9)
		 @ nLin,012 PSAY Padr(SA1->A1_NOME,20)
		 @ nLin,033 PSAY Padr(TRB->C2_PRODUTO,15)
		 @ nLin,049 PSAY Padr(TRB->C2_X_DESEN,15)
		 @ nLin,064 PSAY Padr(IIF(Empty(TRB->C2_SERIEPN),TRB->C2_NUMFOGO,TRB->C2_SERIEPN),15)
         vExame  := SPACE(12)              
         vOBSSYP := ""
		 IF mv_par03 == " " 
		    IF TRB->C2_X_STATU $ "6/9" //Produzido - Rejeitado     
               vExame := "Faturamento "   
            ENDIF
         ELSE                   
            IF TRB->C2_XMREPRD == "   "
			   vExame := "Sem Laudo   "
			ELSE   
			   vExame := "Em Aprov.Com"
			ENDIF
			IF TRB->C2_XMREFIN != "   "
			   vExame  = "Em Aprov.Dir"
			ENDIF
            IF TRB->C2_XMREDIR != "   "  
			   dbSelectArea("SZS")
               dbSetOrder(1) 
               dbSeek("  " + TRB->C2_XMREDIR)
			   IF ZS_TIPO == "5"
                  vExame = "N�o Bonific."
               ELSE
                  vExame = "Bonificado  "
               ENDIF
			ENDIF                  
			//vOBSSYP := ""
			if TRB->C2_XMREPRD # SPACE(3)                    
               vOBSSYP := TRB->C2_XMREPRD + " "
               dbSelectArea("SZS")
               dbSetOrder(1) 
               dbSeek("  " + TRB->C2_XMREPRD)
			   dbSelectArea("SYP")
               dbSetOrder(1) 
               dbSeek("  " + SZS->ZS_CODOBS)
               do while .not.eof() .and. SZS->ZS_CODOBS = SYP->YP_CHAVE
                  vX      := rtrim(SYP->YP_TEXTO)  
                  vOBSSYP += strtran(vX,"\13\10"," ")
                  dbskip ()
               enddo
            endif
		 EndIF
         @ nLin,080 PSAY vExame      
         @ nLin,093 PSAY TRB->C2_X_STATU
		 @ nLin,095 PSAY STOD(TRB->C2_DATPRF)     
		 vCred = 0
		 dbSelectArea("SE1")
         dbSetOrder(1)                       
         dbSeek("  " + "SEP" + TRB->C2_NUM + subst("ABCDEFGHIJKLMNOPQRSTUVXYWZ",VAL(TRB->C2_ITEM),1) + "NCC")
		 if eof()
		    dbSeek("  " + "SEP" + TRB->C2_NUM + subst("123456789ABCDEFGHIJKLMNOPQRSTUVXYWZ",VAL(TRB->C2_ITEM),1) + "NCC")
		    if .not.eof()
		       vCred = SE1->E1_Valor
		    endif
		 else
		    vCred = SE1->E1_Valor
		 endif                              
		 @ nLin,104 PSAY vCred picture "@E 99,999.99"
		 @ nLin,114 PSAY TRB->C2_Obs 
 		 nTotal ++
		 nGeral ++
	     nLin ++
		 if vOBSSYP # ""   	
	        IF nLin > 55
		    	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			    nLin := 9
		    EndIF
		    @ nLin,011 PSAY vOBSSYP
		    nLin ++
		 endif
     
		dbSelectArea("TRB")    
 		dbSkip()
	
	EndDo

	nLin ++


	IF nLin > 55
       cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	nLin ++  

	@ nLin,001 PSAY "Subtotal :"
	@ nLin,020 PSAY nTotal Picture "@E 99,999,999"
    nLin ++
	@ nLin,001 PSAY "Total Geral: "
	@ nLin,020 PSAY nGeral Picture "@E 99,999,999"
	Roda(cbcont,cbtxt,"G")
	dbSelectArea("TRB")
	dbCloseArea("TRB")

	//���������������������������������������������������������������������Ŀ
	//� Se impressao em disco, chama o gerenciador de impressao...          �
	//�����������������������������������������������������������������������
	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function OndeEsta(xRec)
	Local cRet := ""
	Local nPos := aScan(aStatus,{ |x| AllTrim(x[1]) == xRec} )

	IF nPos > 0
		cRet := aStatus[nPos,2]
	EndIF
Return(cRet)

Static Function ContaSql(cAlias)
	Local nRegs := 0
	Local aArea := GetArea()
	dbSelectArea(cAlias)
	dbGoTop()
	Do While !eof()
		nRegs++
		dbSkip()
	Enddo
	dbGoTop()
	RestArea(aArea)
Return nRegs   
