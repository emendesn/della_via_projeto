#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFATR09   ºAutor  ³Golo                º Data ³  27/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Resumo de vendas por periodo                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol Renovadora de Pneus LTDA.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

User Function DFATR09() 

	LOCAL   _cQry       :=  ""   
	Private cString     := "SF2"
	Private aOrd 		:= {}
	Private CbTxt       := ""
	Private cDesc1      := "Este relatorio tem a finalidade de demonstrar o total faturado dos clientes "
	Private cDesc2      := "atendidos por seus motoristas, vendedores, indicadores em um periodo."
	Private cDesc3      := "Resumo de Vendas por periodo"
	Private cPict       := ""
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 132
	Private tamanho     := "G"
	Private nomeprog    := "DFATR09"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private titulo      := "Resumo de Vendas por periodo"
	Private nPag		:= 0
	Private Cabec1      := " "
	Private Cabec2      := " "
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private imprime     := .T.
	Private wnrel      	:= "DFATR09"
	Private _cPerg     	:= "DFAT09"
    Private Linha       := ""
    
    FOR I = 1 TO 3
        VARIAVEL  = "T"+STR(I,1,0)+"VREP"
        &VARIAVEL = 0.00
        VARIAVEL  = "T"+STR(I,1,0)+"QREF"     
        &VARIAVEL = 0.00  
        VARIAVEL  = "T"+STR(I,1,0)+"QSOC"
        &VARIAVEL = 0.00
        VARIAVEL  = "T"+STR(I,1,0)+"QREJ"
        &VARIAVEL = 0.00
        VARIAVEL  = "T"+STR(I,1,0)+"VAST"
        &VARIAVEL = 0.00
        VARIAVEL  = "T"+STR(I,1,0)+"VMER"
        &VARIAVEL = 0.00
        VARIAVEL  = "T"+STR(I,1,0)+"VTOT"
        &VARIAVEL = 0.00
    NEXT    

	_aRegs := {}
	AAdd(_aRegs,{_cPerg,"01","Da Data                ?","I","E","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Data               ?","I","E","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"03","Do Código (M/V/I)      ?","I","E","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"04","Até Código(M/V/I)      ?","I","E","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"05","Do Cliente             ?","I","E","mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"06","Até o Cliente          ?","I","E","mv_ch6","C", 6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"07","(S)intetico/(A)nalitico?","I","E","mv_ch7","C", 1,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"08","Cabeçalho (S)im/(N)ão  ?","I","E","mv_ch8","C", 1,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	For i:=1 to Len(_aRegs)
		If !dbSeek(_cPerg+_aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to len(_aRegs[i])
				FieldPut(j,_aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(_cPerg,.F.)

	aOrd := {"Por motorista","Por vendedor","Por indicador"}    
	
	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	ProcRegua(100)

    nOrdem   := aReturn[8]
	_cQry    := ""
    Cabec1   := "Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) + " - Ordem: " +IIF(nOrdem = 1,"Motorista",IIF(nOrdem = 2,"Vendedor","Indicador")) 
    Cabec2   := " Vended Cliente     Nome                                          Recapagem Qtde Soc. Rec. Assist.Tecnica      Mercantil          Total"
//  SELECIONA REGISTRO 
	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

	_cQry := "select F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_VEND3, F2_VEND4, F2_VEND5, F2_EMISSAO, F2_TIPO,"
	_cQry += "       D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_DOC, D2_SERIE, D2_COD, D2_TES, D2_TOTAL, D2_QUANT, D2_ITEM, D2_GRUPO, D2_CF" 
	_cQry += " from " + RetSqlName("SD2")+ " SD2, " 
	_cQry +=          + RetSqlName("SF2")+ " SF2  " 
	_cQry += " where SD2.D_E_L_E_T_ = ' ' "    
	_cQry += " and   SF2.D_E_L_E_T_ = ' ' "  
	_cQry += " and   F2_FILIAL  = '" + xFilial("SF2") + "' "   
	_cQry += " and   F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' "      
	_cQry += " and   F2_CLIENTE BETWEEN '" + mv_par05       + "' and '" + mv_par06       + "' "  
	_cQry += " and   D2_FILIAL  = F2_FILIAL"  
	_cQry += " and   D2_DOC     = F2_DOC" 
	_cQry += " and   D2_SERIE   = F2_SERIE" 
	_cQry += " and   D2_CLIENTE = F2_CLIENTE"
    _cQry += " and   D2_LOJA    = F2_LOJA"
	IF nOrdem = 1
		_cQry += " and F2_VEND3 BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' "
		_cQry += " order by F2_VEND3,F2_CLIENTE,F2_LOJA " 
	ElseIF nOrdem = 2
		_cQry += " and F2_VEND4 BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' "
		_cQry += " order by F2_VEND4,F2_CLIENTE,F2_LOJA " 
	Else
		_cQry += " and F2_VEND5 BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' "
		_cQry += " order by F2_VEND5,F2_CLIENTE,F2_LOJA " 
	EndIF

	MsgRun("Consultando Banco de dados ...",,{|| _cQry := ChangeQuery(_cQry)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry),"TRB", .T., .T.)})

	TcSetField("TRB","F2_EMISSAO","D")
	TcSetField("TRB","D2_TOTAL"  ,"N",14,2)
	TcSetField("TRB","D2_QUANT"  ,"N",11,2)

    if mv_par08=="S"
       nLin := 80
    else
       nLin := 00
    endif

	dbSelectArea("TRB")
	dbGoTop()
    ProcRegua (0)
    
	
   	cCodVen   := "???" //IIF(nOrdem = 1,TRB->F2_VEND3,IIF(nOrdem = 2,TRB->F2_VEND4,TRB->F2_VEND5))
   	cCodCli   := "???" //TRB->F2_CLIENTE+TRB->F2_LOJA   
	pVez      := .t.  
	While ! Eof()   

		IF cCodVen !=  IIF(nOrdem = 1,TRB->F2_VEND3,IIF(nOrdem = 2,TRB->F2_VEND4,TRB->F2_VEND5)) 
		   IF !pVez//Primeiro Registro? 
		      //TOTALIZA CLIENTE 
		      IF T1VTOT > 0 .OR. T1QREJ > 0
                 SA1->(dbSetOrder(1))
		         SA1->(dbSeek(xFilial()+cCodCli))
		         Linha  := cCodVen + " " 
                 Linha  += Substr(cCodCli,1,6)+"-"+Substr(cCodCli,7,2)+"   "
                 Linha  += Substr(SA1->A1_NOME,1,40)
		         Linha  += Transform(T1VREP,"9999,999,999.99")
		         Linha  += Transform(T1QREF,"99999")    
		         Linha  += Transform(T1QSOC,"99999")
		         Linha  += Transform(T1QREJ,"99999")
                 Linha  += Transform(T1VAST,"9999,999,999.99")
		         Linha  += Transform(T1VMER,"9999,999,999.99")
		         Linha  += Transform(T1VTOT,"9999,999,999.99")   
		         nLin   := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)  
		      ENDIF
		      //ACUMULA CLIENTE EM VENDEDOR 
			  T2VREP += T1VREP
			  T2QREF += T1QREF   
			  T2QSOC += T1QSOC
			  T2QREJ += T1QREJ
			  T2VAST += T1VAST
			  T2VMER += T1VMER
			  T2VTOT += T1VTOT
			  //ZERA CLIENTE 
		      cCodCli:= TRB->F2_Cliente+TRB->F2_Loja
			  T1VREP := T1QREF := T1QSOC := T1QREJ := T1VAST := T1VMER := T1VTOT := 0 
			  //TOTALIZA VENDEDOR
              nLin   := IMPRIME(nLin,"",Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)
              Linha  := cCodVen +" "
              Linha  += "SubTotal : " + SPACE(41)
              Linha  += Transform(T2VREP,"9999,999,999.99")
		      Linha  += Transform(T2QREF,"99999") 
		      Linha  += Transform(T2QSOC,"99999")
		      Linha  += Transform(T2QREJ,"99999")
              Linha  += Transform(T2VAST,"9999,999,999.99")
		      Linha  += Transform(T2VMER,"9999,999,999.99")
		      Linha  += Transform(T2VTOT,"9999,999,999.99")  
		      nLin   := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08) 
		      nLin   := IMPRIME(nLin,"",   Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)
		      //ACUMULAR TOTAL
			  T3VREP   += T2VREP
			  T3QREF   += T2QREF   
			  T3QSOC   += T2QSOC
			  T3QREJ   += T2QREJ
			  T3VAST   += T2VAST
			  T3VMER   += T2VMER
			  T3VTOT   += T2VTOT
		   ENDIF
		   //INICIA VENDEDOR 
		   cCodVen = IIF(nOrdem = 1,TRB->F2_VEND3,IIF(nOrdem = 2,TRB->F2_VEND4,TRB->F2_VEND5))
		   //ZERA VENDEDOR
		   T2VREP   := T2QREF   := T2QSOC  := T2QREJ  := T2VAST := T2VMER  := T2VTOT := 0 
		   //CABEÇALHO VENDEDOR
           nLin  := IMPRIME(nLin,"",Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)
		   SA3->(dbSetOrder(1))
		   SA3->(dbSeek(xFilial("SA3")+cCodVen))  
		   Linha := cCodVen + " "
		   Linha += SA3->A3_NOME
           nLin  := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08) 
           nLin  := IMPRIME(nLin,"",   Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)
        ENDIF 
		
		IF cCodCli <> TRB->F2_Cliente+TRB->F2_Loja
		   IF !pVez
		      //TOTALIZAR CLIENTE 
		      IF T1VTOT > 0 .OR. T1QREJ > 0
                 SA1->(dbSetOrder(1))
		         SA1->(dbSeek(xFilial()+cCodCli))
		         Linha  := cCodVen + " " 
                 Linha  += Substr(cCodCli,1,6)+"-"+Substr(cCodCli,7,2)+"   "
                 Linha  += Substr(SA1->A1_NOME,1,40)
		         Linha  += Transform(T1VREP,"9999,999,999.99")
		         Linha  += Transform(T1QREF,"99999")
		         Linha  += Transform(T1QSOC,"99999")
		         Linha  += Transform(T1QREJ,"99999")
                 Linha  += Transform(T1VAST,"9999,999,999.99")
		         Linha  += Transform(T1VMER,"9999,999,999.99")
		         Linha  += Transform(T1VTOT,"9999,999,999.99")     
		         nLin  := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08) 
		      ENDIF
		      //ACUMULA CLIENTE EM VENDEDOR 
			  T2VREP   += T1VREP
			  T2QREF   += T1QREF
			  T2QSOC   += T1QSOC
			  T2QREJ   += T1QREJ
			  T2VAST   += T1VAST
			  T2VMER   += T1VMER
			  T2VTOT   += T1VTOT
		   ELSE
		      pVez=.f.
		   ENDIF 
		   //INICIA OUTRO CLIENTE	  
		   cCodCli := TRB->F2_Cliente+TRB->F2_Loja
		   //ZERA CLIENTE
		   T1VREP  := T1QREF   := T1QSOC  := T1QREJ  := T1VAST := T1VMER  := T1VTOT := 0 
	    EndIF //cCodCli <> TRB->F2_CLIENTE+TRB->F2_LOJA
        
        TIPOITEMD2 := SPACE(11) 
  		IF .NOT.(TRB->D2_TES $ '594/902') //Nao considero os itens nao agregados 
           SF4->(dbSetOrder(1))
		   SF4->(dbSeek(xFilial("SF4") + TRB->D2_TES))
		
		   SF2->(dbSetOrder(1) )
		   SF2->(dbSeek(xFilial("SF2") + TRB->D2_DOC ) )
		
           IF SF4->F4_DUPLIC = "S" .AND. TRB->F2_TIPO = "N"
		      IF upper(TRB->D2_GRUPO) $ "SERV/CI  /SC  "  
			     T1VREP      += D2_TOTAL //IIF(TRB->D2_TOTAL<0,0,TRB->D2_TOTAL)  //--Valor de reformas   
			     T1VTOT      += D2_TOTAL //IIF(TRB->D2_TOTAL<0,0,TRB->D2_TOTAL)  // --Vlr.Total Faturado
                 TIPOITEMD2  := " SERVICO   "
			  EndIF
		      IF upper(TRB->D2_GRUPO) = "SERV" 
                 T1QREF      += TRB->D2_QUANT                         //-- Quantidade de reformas 
              EndIF   
              IF upper(TRB->D2_GRUPO) = "SC  "                        //-- Quantidade de só conserto
                 T1QSOC      += TRB->D2_QUANT
                 TIPOITEMD2  := " SO CONSER "
              ENDIF
   		      IF upper(TRB->D2_GRUPO) = "ATEC" 
			     T1VAST      += D2_TOTAL //IIF(TRB->D2_TOTAL<0,0,TRB->D2_TOTAL)  // --Vlr.Assitencia Tecnica 
			     T1VTOT      += D2_TOTAL //IIF(TRB->D2_TOTAL<0,0,TRB->D2_TOTAL)  // --Vlr.Total Faturado
			     TIPOITEMD2  := " ASSIST.TEC"
              EndIF
	          IF TRB->D2_TES $ '503/506' 
			     T1VMER      += D2_TOTAL //IIF(TRB->D2_TOTAL<0,0,TRB->D2_TOTAL)  // --Grupo de Pneus novos
			     T1VTOT      += D2_TOTAL //IIF(TRB->D2_TOTAL<0,0,TRB->D2_TOTAL)  // --Vlr.Total Faturado
			     TIPOITEMD2  := " MERCANTIL "
              ENDIF
           ELSE
		      IF upper(TRB->D2_GRUPO) $ "SERV/SC  " .and. TRB->F2_TIPO = 'N'
			     T1QREJ      += TRB->D2_QUANT                         // --Quantidade de rejeitados
			     TIPOITEMD2  := " RECUSADO  "
		      EndIF		
           ENDIF
        ENDIF     
        
        IF upper(mv_par07) = "A"     
           Linha := cCodVen + " "
           Linha +=  "DT:"
           Linha += Dtoc(TRB->F2_Emissao)
           Linha += " CL:"
           Linha += Substr(cCodCli,1,6)+"-"+Substr(cCodCli,7,2)
           Linha += " NFS:"
           Linha += TRB->D2_DOC  
           Linha += " ITEM:"
           Linha += TRB->D2_ITEM
           Linha += " PROD:"
           Linha += TRB->D2_COD
           Linha += " TES:"
           Linha += TRB->D2_TES
           Linha += " CFOP:"
           Linha += TRB->D2_CF 
           Linha += " GRUPO:"  
           Linha += TRB->D2_GRUPO          
           IF TIPOITEMD2<>SPACE(11)
              Linha += TIPOITEMD2    
           ELSE
              IF TRB->D2_GRUPO=="CARC"
                 Linha += " RETORNO   "
              ELSE
                  IF TRB->D2_GRUPO=="RECA"
                     Linha += " BENEFIC   "
                  ELSE
                     Linha += " DEVOLUCAO "
                  ENDIF
              ENDIF 
           ENDIF
           Linha += " QT:"
           Linha += Transform(TRB->D2_QUANT,"9999")
           Linha += " VL:"
	       Linha += IIF(TIPOITEMD2<>SPACE(11).AND.TIPOITEMD2<>" RECUSADO  ",Transform(TRB->D2_TOTAL,"999,999.99")," ")  
	       nLin  := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)        
	    ENDIF 
		dbSelectArea("TRB")
		dbSkip()
	EndDo 
	//TOTALIZAR ULTIMO CLIENTE
	IF T1VTOT > 0 .OR. T1QREJ > 0
       SA1->(dbSetOrder(1))
	   SA1->(dbSeek(xFilial()+cCodCli))
	   Linha  := cCodVen + " " 
       Linha  += Substr(cCodCli,1,6)+"-"+Substr(cCodCli,7,2)+"   "
       Linha  += Substr(SA1->A1_NOME,1,40)
	   Linha  += Transform(T1VREP,"9999,999,999.99")
	   Linha  += Transform(T1QREF,"99999") 
	   Linha  += Transform(T1QSOC,"99999")
	   Linha  += Transform(T1QREJ,"99999")
       Linha  += Transform(T1VAST,"9999,999,999.99")
	   Linha  += Transform(T1VMER,"9999,999,999.99")
	   Linha  += Transform(T1VTOT,"9999,999,999.99")    
	   nLin   := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)   
	ENDIF
	//ACUMULA CLIENTE EM VENDEDOR 
	T2VREP += T1VREP
	T2QREF += T1QREF
	T2QSOC += T1QSOC
	T2QREJ += T1QREJ
	T2VAST += T1VAST
	T2VMER += T1VMER
	T2VTOT += T1VTOT
	//ZERA CLIENTE 
	T1VREP   := T1QREF   := T1QSOC  := T1QREJ  := T1VAST := T1VMER  := T1VTOT := 0 
	//TOTALIZA VENDEDOR
    nLin   := IMPRIME(nLin,"",Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)
    Linha  := cCodVen +" "
    Linha  += "SubTotal : " + SPACE(41)
	Linha  += Transform(T2VREP,"9999,999,999.99")
	Linha  += Transform(T2QREF,"99999")
	Linha  += Transform(T2QSOC,"99999")
	Linha  += Transform(T2QREJ,"99999")
    Linha  += Transform(T2VAST,"9999,999,999.99")
	Linha  += Transform(T2VMER,"9999,999,999.99")
	Linha  += Transform(T2VTOT,"9999,999,999.99")  
	nLin   := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)   
	nLin   := IMPRIME(nLin,"",   Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)
	//ACUMULAR TOTAL
	T3VREP   += T2VREP
	T3QREF   += T2QREF
	T3QSOC   += T2QSOC
	T3QREJ   += T2QREJ
	T3VAST   += T2VAST
	T3VMER   += T2VMER
	T3VTOT   += T2VTOT
	//TOTALIZAR RELATORIO    
	Linha  := "Total Geral: " + SPACE(46)
	Linha  += Transform(T3VREP,"9999,999,999.99")
	Linha  += Transform(T3QREF,"99999")
	Linha  += Transform(T3QSOC,"99999")
	Linha  += Transform(T3QREJ,"99999")
    Linha  += Transform(T3VAST,"9999,999,999.99")
	Linha  += Transform(T3VMER,"9999,999,999.99")
	Linha  += Transform(T3VTOT,"9999,999,999.99")  
	nLin   := IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,,.f.,mv_par08)

	dbSelectArea("TRB")
	dbCloseArea()
	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil
// FINAL DO PROGRAMA  

Static Function IMPRIME(nLin,Linha,Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,X,Y,mv_par08)     
IF nLin > 55 .and. upper(mv_par08) = "S"
   nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,ntipo,X,Y)
ENDIF        
nLin +=1
@ nLin, 01 pSay Linha

RETURN nLin



