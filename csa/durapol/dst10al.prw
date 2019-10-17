#include "rwmake.ch"
#include "topconn.ch"

User Function DST10AL(cColeta)

	Local 	Titulo  	:= OemToAnsi("Emissao da Confirmacao do Pedido")
	Local 	cDesc1  	:= OemToAnsi("Emissao da confirmacao dos pedidos de venda, de acordo com")
	Local 	cDesc2  	:= OemToAnsi("intervalo informado na opcao Parƒmetros.")
	Local 	cDesc3  	:= " "
	Local 	cString 	:= "SC5"  // Alias utilizado na Filtragem
	Local 	lDic    	:= .F. // Habilita/Desabilita Dicionario
	Local  	nomeprog	:= "DST10AL"
	Local   cPerg   	:= "ST10AL"    
    Private wnrel		:= "DST10AL" // Nome do Arquivo utilizado no Spool 
	Private lAbortPrint := .F.
	Private Tamanho 	:= "G" // P/M/G
	Private Limite  	:= 220 // 80/132/220
	Private aOrd    	:= {}  // Ordem do Relatorio
	Private aReturn 	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)
	Private nTipo   	:= 15
	Private Li			:= 80
	Private lEnd    	:= .F.// Controle de cancelamento do relatorio
	Private m_pag   	:= 1  // Contador de Paginas
	Private nLastKey	:= 0  // Controla o cancelamento da SetPrint e SetDefault
    Private Cabec1      := ""
	Private Cabec2      := ""
	Private wnrel       := "DST10AL"
	Private lImp        := .F.

	cPerg    			:= PADR(cPerg,6)
	aRegs    			:= {}  

    AADD(aRegs,{cPerg,"01","Status OP        ?"," "," ","mv_ch1","N",01,0,0,"C","","mv_par01","So Liberados","","","","","Todas"  ,"","","","",""             ,"","","","",""            ,"","","","","","","",""   ,"","","","",""          })
	AADD(aRegs,{cPerg,"02","Faturados        ?"," "," ","mv_ch2","N",01,0,0,"C","","mv_par02","Nao Imprime" ,"","","","","Todas"  ,"","","","",""             ,"","","","",""            ,"","","","","","","",""   ,"","","","",""          })

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
		Return
	Endif
    
    SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({||Runreport()})

Return Nil

Static Function RunReport()
	
	Local cQuery     := ""
	Local tQtdPro    := 0
	Local tQtdSer	 := 0
	Local tValSer    := 0
    Local vPipe		 := "|"
	cQuery := "SELECT C5_FILIAL, "
	cQuery += "       C5_NUM, "
	cQuery += "       C5_CLIENTE, "
	cQuery += "       C5_LOJACLI, "
	cQuery += "       C5_TIPO, "
	cQuery += "       C5_EMISSAO, "
	cQuery += "       C5_CONDPAG, "
	cQuery += "       C6_PRODUTO, "
	cQuery += "       C6_QTDVEN, "
	cQuery += "       C6_PRUNIT, "
	cQuery += "       C6_VALDESC,"
	cQuery += "       C6_VALOR, "
	cQuery += "       C6_ITEM, "
	cQuery += "       C6_DESCRI, "
	cQuery += "       C6_UM, "
	cQuery += "       C6_PRCVEN, "
	cQuery += "       C6_NOTA, "
	cQuery += "       C6_ENTREG, "
	cQuery += "       C6_DESCONT, "
	cQuery += "       C6_QTDENT, "
	cQuery += "       C6_NFORI, "
	cQuery += "       C6_SERIORI, "
	cQuery += "       C6_ITEMORI, "
	cQuery += "       C6_TES, "
	cQuery += "       A1_NOME,"
	cQuery += "       A1_CGC, "
	cQuery += "       A1_INSCR, "
	cQuery += "       A1_END, "
	cQuery += "       A1_CEP, "
	cQuery += "       A1_MUN, "
	cQuery += "       A1_EST, "
	cQuery += "       A1_ENDENT, "
	cQuery += "       A1_CEPE, "
	cQuery += "       A1_MUNE, "
	cQuery += "       A1_ESTE, "
	cQuery += "       E4_DESCRI, "
	cQuery += "       C2_X_STATU "
	cQuery += "  FROM " + RetSqlName("SC5") + " SC5 " 
	cQuery += "  JOIN " + RetSqlName("SC6") + " SC6 "
	cQuery += "    ON SC6.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC6.C6_FILIAL  = '"   + xFilial("SC6") + "' "
	cQuery += "   AND SC6.C6_NUM     = SC5.C5_NUM "
	If mv_par02 = 1  // Não Imprime Faturado
	   cQuery += "AND SC6.C6_NOTA = '' "
	EndIf
	cQuery += "  LEFT JOIN " + RetSqlName("SC2") + " SC2 "
	cQuery += "    ON SC2.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC2.C2_NUM     = SC6.C6_NUMOP "
	cQuery += "   AND SC2.C2_ITEM    = SC6.C6_ITEMOP "
	cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += "    ON SA1.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SA1.A1_COD     = SC5.C5_CLIENTE "
	cQuery += "   AND SA1.A1_LOJA    = SC5.C5_LOJACLI "
	cQuery += "  JOIN " + RetSqlName("SE4") + " SE4 "
	cQuery += "    ON SE4.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SE4.E4_CODIGO  = SC5.C5_CONDPAG "
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
	cQuery += "   AND SC5.C5_NUM     = '" + cColeta + "' "
		
	cQuery += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM "

 	MsgRun("Consultando Banco de dados ...",,{|| cQuery := ChangeQuery(cQuery)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","C5_EMISSAO","D")
	TcSetField("ARQ_SQL","C6_ENTREG" ,"D")
	TcSetField("ARQ_SQL","C6_QTDVEN" ,"N",14,2)
	TcSetField("ARQ_SQL","C6_PRUNIT" ,"N",14,2)
	TcSetField("ARQ_SQL","C6_VALDESC","N",14,2)       
	TcSetField("ARQ_SQL","C6_VALOR"  ,"N",14,2)       
	
	dbSelectArea("ARQ_SQL")
	dbGoTop()
	ProcRegua(0)
	nTotRec :=0
	nTotLib :=0
	nTotQtd	:=0
	nTotVal	:=0
	nPesBru	:=0
	nPesLiq	:=0
	nCaract	:=limite-41
	nc1		:=044
	nc2		:=108
	nc3		:=180
	
	LI:=01		
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	LI++
	@ LI,000 		psay "| " + SM0->M0_NOMECOM
	@ LI,nc1 		psay "| " + Arq_Sql->A1_NOME
	@ LI,nc2 		psay "| CONFIRMACAO DO PEDIDO "  
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "| "    + SM0->M0_ENDENT
	@ LI,nc1 		psay "| "    + Arq_Sql->A1_ENDENT
	@ LI,nc2 		psay "| CP:" + Arq_Sql->E4_DESCRI
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "| TEL: "+SM0->M0_TEL
	@ LI,nc1 		psay "| CEP:" + Arq_Sql->A1_CEPE
	@ LI,pcol()+1 	psay Arq_Sql->A1_MUNE
	@ LI,pcol()+1	psay Arq_Sql->A1_ESTE
	@ LI,nc2 		psay "| EMISSAO: "
	@ LI,pcol()+1 	psay date()
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "| CNPJ: "	
	@ LI,pcol()+1 	psay SM0->M0_CGC     Picture "@R 99.999.999/9999-99"
	@ LI,pcol()+1 	psay Subs(SM0->M0_CIDENT,1,15)
	@ LI,nc1 		psay "|"
    @ LI,pcol()+1 	psay Arq_Sql->A1_CGC Picture "@R 99.999.999/9999-99"
	@ LI,pcol()+1 	psay "IE: "+Arq_Sql->A1_INSCR		
	@ LI,nc2		psay "| PEDIDO N. "+Arq_Sql->C5_NUM
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	LI++
	@ LI,000 		psay  "| IT | CODIGO          | DESCRICAO DO MATERIAL                                    | SITUACAO | COLETA | SER | ITEM |N.FISCAL| QL | QR | QP | QS |   UNITARIO | VALOR TOTAL| ENTREGA |"
	li++
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	
	While !Eof()

		if (mv_par01 = 1 .and. Arq_Sql->C2_X_Statu = "9") 
			dbSelectArea("Arq_Sql")
			dbskip()
			loop
		endif
		 
		li++
		@li,000      psay vPipe
		@li,pcol()+1 psay Arq_Sql->C6_ITEM
		@li,pcol()+1 psay vPipe
	    @li,pcol()+1 psay Arq_Sql->C6_PRODUTO
		@li,pcol()+1 psay vPipe
		@li,pcol()+1 psay Substr(Arq_Sql->C6_DESCRI,1,56)
		@li,pcol()+1 psay vPipe
		
		if Arq_Sql->C2_X_STATU = "6"
			If Arq_Sql->C6_TES = "594"  
		   		@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Liberado","Lib/Dev.")
		 	Else
		 		@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Liberado","Lib/Fat.")
		 	EndIf
			@li,pcol()+1 psay vPipe
		else
			if Arq_Sql->C2_X_STATU = "9"
				If Arq_Sql->C6_TES = "594"
		   			@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Recusado","Rec/Dev.")
		 		Else
		 			@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Recusado","Rec/Fat.")
		 		EndIf
		        @li,pcol()+1 psay vPipe
			else
				@li,pcol()+1 psay space(8)
		        @li,pcol()+1 psay vPipe
			endif
		endif

		@li,pcol()+1 psay Arq_Sql->C6_NFORI
		@li,pcol()+1 psay vPipe 
		@li,pcol()+1 psay Arq_Sql->C6_SERIORI
		@li,pcol()+1 psay vPipe
		@li,pcol()+1 psay Arq_Sql->C6_ITEMORI
		@li,pcol()+1 psay vPipe		
		@li,pcol()+1 psay Arq_Sql->C6_Nota
		@li,pcol()+1 psay vPipe		
		    		
		If Arq_Sql->C6_TES = '594'        
			if Arq_Sql->C2_X_STATU = "6"
				nTotLib++
				@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
				@li,pcol()+1 psay vPipe
				@li,pcol()+1 psay "  "
			else                    
				if Arq_Sql->C2_X_STATU = "9"
					@li,pcol()+1 psay "  "
					@li,pcol()+1 psay vPipe
					nTotRec++
					@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
				else
					@li,pcol()+1 psay "  "
					@li,pcol()+1 psay vPipe
					@li,pcol()+1 psay "  "
				endif
			endif
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay "  "
			@li,pcol()+1 psay vPipe
			tQtdPro := tQtdPro + Arq_Sql->C6_QTDVEN
			@li,pcol()+1 psay "          "
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay "          "
			@li,pcol()+1 psay vPipe
		else
			@li,pcol()+1 psay "  "
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay "  "
			@li,pcol()+1 psay vPipe
			if Arq_Sql->C6_TES = '901'
				@li,pcol()+1 psay "  "
				@li,pcol()+1 psay vPipe
				@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
				@li,pcol()+1 psay vPipe
				tQtdSer := tQtdSer + Arq_Sql->C6_QTDVEN
				@li,pcol()+1 psay Arq_Sql->C6_PRCVEN picture "@E 999,999.99"
				@li,pcol()+1 psay vPipe
				@li,pcol()+1 psay Arq_Sql->C6_VALOR  picture "@E 999,999.99"
				@li,pcol()+1 psay vPipe
				tValSer := tValSer + Arq_Sql->C6_VALOR
			else	
		  		@li,pcol()+1 psay "  "
				@li,pcol()+1 psay vPipe
		        @li,pcol()+1 psay "  "
				@li,pcol()+1 psay vPipe
		        @li,pcol()+1 psay "          "
				@li,pcol()+1 psay vPipe
		        @li,pcol()+1 psay "          "
				@li,pcol()+1 psay vPipe
		    endif
		endif
		@li,pcol()+1 psay Arq_Sql->C6_ENTREG    
		@LI,PCOL()   PSAY vPipe
		dbSelectArea("Arq_Sql")
		dbSkip()
	Enddo
	Li++
	@ LI,000		psay "+" + Replicate("-",nCaract) + "+"
	Li++
	@li,000      	psay vPipe  
	@li,024      	psay " T O T A I S "
	@li,124     	psay vPipe
	@li,pcol()+1    psay ntotLib picture "99"
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1    psay ntotRec picture "99"
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1 	psay tQtdPro picture "99"	
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1 	psay tQtdSer Picture "99"
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1 	psay space(10)
	@li,pcol()+1	psay vPipe
	@li,pcol()+1 	psay tValSer Picture "@e 999,999.99"
	@li,pcol()+1 	psay vPipe  
	@li,nc3 	 	psay vPipe  
	
	Li++
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	
	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
    dbCloseArea("ARQ_SQL")
    
Return nil
