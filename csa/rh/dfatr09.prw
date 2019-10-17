
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR09() 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFATR09    ºAutor  ³ by Golo           º Data ³  08/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  VENDAS VENDEDOR X PERIODO                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SF2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "VendedorXPeriodo"
	Private tamanho        := "G"
	Private nomeprog       := "DFATR09"
	Private lAbortPrint    := .F.
	Private nTipo          := 18
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFAT09"
	Private titulo         := "Resumo de Vendas por periodo"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR09"
	Private lImp           := .F.
	Private limite         := 132
	Private nPag		:= 0
        FOR I = 1 TO 3
            VARIAVEL  = "T"+STR(I,1,0)+"VREP"
           &VARIAVEL  = 0.00
            VARIAVEL  = "T"+STR(I,1,0)+"QREF"
           &VARIAVEL  = 0.00
            VARIAVEL  = "T"+STR(I,1,0)+"QREJ"
           &VARIAVEL  = 0.00
            VARIAVEL  = "T"+STR(I,1,0)+"VAST"
           &VARIAVEL  = 0.00
            VARIAVEL  = "T"+STR(I,1,0)+"VMER"
           &VARIAVEL  = 0.00
            VARIAVEL  = "T"+STR(I,1,0)+"VTOT"
           &VARIAVEL  = 0.00
        NEXT    
   
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	_aRegs:={}

	AAdd(_aRegs,{_cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"03","Do  Código    ?"   ,"Do Código  "    ,"Do Código  "    ,"mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"04","Ate Código    ?"   ,"Ate Código  "   ,"Ate Código  "   ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.F.)

	aOrd := {"Por motorista","Por vendedor","Por indicador"}
	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

/*	Cabec1:=" Filial de " + mv_par01 + " a " + mv_par02

                       1         2         3         4         5         6         7         8           9        10    117            132                 
              12345678901234567890123456789012345678901234567890123456789012345678901234567890182234567890123456789012345678901234567890 
              XX | XXXXXX |XXX  |XXXXXXXXXXXXXXXXXXXX  |XXXXXXXXXXXX  | XX | XXXXXXXXXXXX |XXXXXXXXXXXX|XXXXXXXXXXXX|XXXXXXXXX| */
	Cabec2+=" FL|MATRIC|COD|DESCRICAO DA VERBA  |VALOR PRINC.|NP|VALOR PARCEL|PP|  VALOR PAGO|       SALDO|CCUSTO   "                                                                                                                      
*/
	_cQry := "select F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_VEND3, F2_VEND4, F2_VEND5 "
	_cQry += " from " + RetSqlName("SF2")+ " SF2 "
	_cQry += " where SF2.D_E_L_E_T_ = ' ' "
	_cQry += " and F2_FILIAL = '" + xFilial("SF2") + "' "
	_cQry += " and F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' "

	IF nOrdem = 1
		_cQry += " and F2_VEND3 BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' "
		_cQry += " order by F2_VEND3,F2_CLIENTE " //F2_CLIENTE||
	ElseIF nOrdem = 2
		_cQry += " and F2_VEND4 BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' "
		_cQry += " order by F2_VEND4,F2_CLIENTE " //F2_CLIENTE||
	Else
		_cQry += " and F2_VEND5 BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' "
		_cQry += " order by F2_VEND5,F2_CLIENTE " //F2_CLIENTE||
	EndIF

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"TRB", .T., .T.)})
    

	dbSelectArea("TRB")
	ProcRegua(0)
	dbgoTop()
    
	Do While !eof() 
	
	   IncProc("Imprimindo ...")
	   If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
	   Endif
	   cCodCli := "?" //TRB->F2_CLIENTE+TRB->F2_LOJA
	   cCodVen := "?" //IIF(nOrdem = 1,TRB->F2_VEND3,IIF(nOrdem = 2,TRB->F2_VEND4,TRB->F2_VEND5))
 
           While ! Eof()    
	 
                 xVEND = IIF(nOrdem = 1,TRB->F2_VEND3,IIF(nOrdem = 2,TRB->F2_VEND4,TRB->F2_VEND5))
		 IF cCodVen != xVEND
		    IF xVEND <> "?"   // PRIMEIRO REGISTRO
		       //TOTALIZAR CLIENTE
		       if (T1VREP + T1QREF + T1QREJ + T1VASTEC + T1VMERC + T1VTOTAL) > 0
		       	  SA1->(dbSetOrder(1))
		          SA1->(dbSeek(xFilial()+cCodCli)) 
                          @ nLin, 001 Psay cCodCli
		          @ nLin, 010 Psay Substr(SA1->A1_NOME,1,40)
		          @ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
		          @ nLin, 092 Psay T1QREF   Picture "@E 9999"
		          @ nLin, 097 Psay T1QREJ   Picture "@E 9999"
            	          @ nLin, 102 Psay T1VAST   Picture "@E 999,999,999.99"
		          @ nLin, 117 Psay T1VMER   Picture "@E 999,999,999.99"
		          @ nLin, 132 Psay T1VTOT   Picture "@E 999,999,999.99"   
		          nLin:=Imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      endif  
		      @ nLin, 001 pSay " "  
                      nLin:=imprel(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      //TOTALIZAR VENDEDOR
		      @ nLin, 001 Psay "SubTotal : "
		      @ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
		      @ nLin, 092 Psay T1QREF   Picture "@E 9999"
		      @ nLin, 097 Psay T1QREJ   Picture "@E 9999"
                      @ nLin, 102 Psay T1VAST   Picture "@E 999,999,999.99"
		      @ nLin, 117 Psay T1VMER   Picture "@E 999,999,999.99"
		      @ nLin, 132 Psay T1VTOT   Picture "@E 999,999,999.99"   
		      nLin:=(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      //ACUMULAR TOTAL
		      T3VREP   += T2VREP
		      T3QREF   += T2QREF
		      T3QREJ   += T2QREJ
		      T3VAST   += T2VAST
		      T3VMER   += T2VMER
		      T3VTOT   += T2VTOT
		      //ZERAR VENDEDOR
		      T2VREP   := T2QREF   := T2QREJ  := T2VAST := T2VMER  := T2VTOT := 0
		   ENDIF
		   //INICIAR VENDEDOR
		   @ nLin, 001 pSay " "  
                   nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))  
		   SA3->(dbSetOrder(1))
		   SA3->(dbSeek(xFilial("SA3")+xVEND))
		   @ nLin, 001 Psay IIF(nOrdem = 1,"Motorista : " + TRB->TRB_VEND +" - "+ Alltrim(SA3->A3_NOME),;
		   IIF(nOrdem = 2,"Vendedor : " + TRB->TRB_VEND + " - " + Alltrim(SA3->A3_NOME),"Indicador : " + TRB->TRB_VEND + " - " +Alltrim(SA3->A3_NOME)))
		   nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
                   cVend := xVEND
		   cCodCli := TRB->F2_CLIENTE+TRB->F2_LOJA
	    ENDIF
		IF cCodCli <> TRB->F2_CLIENTE+TRB->F2_LOJA
		   IF cCodCli <> "?" // Primeiro Registro
		      SA1->(dbSetOrder(1))
		      SA1->(dbSeek(xFilial()+cCodCli)) 
		      //TOTALIZAR CLIENTE
			  if (T1VREP + T1QREF + T1QREJ + T1VAST + T1VMER + T1VTOT) > 0
                  @ nLin, 001 Psay cCodCli
		          @ nLin, 010 Psay Substr(SA1->A1_NOME,1,40)
		          @ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
		          @ nLin, 092 Psay T1QREF   Picture "@E 9999"
		          @ nLin, 097 Psay T1QREJ   Picture "@E 9999"
            	  @ nLin, 102 Psay T1VAST   Picture "@E 999,999,999.99"
		          @ nLin, 117 Psay T1VMER   Picture "@E 999,999,999.99"
		          @ nLin, 132 Psay T1VTOT   Picture "@E 999,999,999.99"   
                  nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      endif
			endif
			T2VREP   += T1VREP
			T2QREF   += T1QREF
			T2QREJ   += T1QREJ
			T2VAST   += T1VAST
			T2VMER   += T1VMER
			T2VTOT   += T1VTOT
		    T1VREP   := T1QREF   := T1QREJ  := T1VAST := T1VMER  := T1VTOT := 0
		EndIF
		
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE)

		While !Eof() .and. TRB->F2_FILIAL+TRB->F2_DOC+TRB->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE		
		   
			IF SD2->D2_TES $ '594/902' //Nao considero os itens nao agregados
				//--Qtd.Reforma
				SD2->(dbSkip())
				Loop
			EndIF
		
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
			SF2->( dbSetOrder(1) )
			SF2->( dbSeek(xFilial("SF2") + SD2->D2_DOC ) )
		
			SB1->(dbSetOrder(1))
			SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
			cGrupo  := AllTrim( Upper(SB1->B1_GRUPO) )
		
			//--Vlr.Recapagem		
			IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) $ "SERV/CI/SC" //Vlr.Recapagem
				IF SF2->F2_TIPO = 'N'
                   T1VREP   += SD2->D2_TOTAL
				EndIf	
			EndIF
		
			IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) $ "SERV/SC" //Total de reformas
				IF SF2->F2_TIPO = 'N'
					T1QREP += SD2->D2_QUANT
				EndIF	
			EndIF
    		
			//--Qtd.Recusado
			IF SF4->F4_DUPLIC = 'N' .and. Alltrim(cGrupo) $ "SERV/SC" //Total de rejeitados
				IF SF2->F2_TIPO = 'N'
					T1QREJ += SD2->D2_QUANT
				EndIF	
			EndIF		

			//--Vlr.Assitencia Tecnica
			IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) == "ATEC" 
				IF SF2->F2_TIPO = 'N'
					T1VAST += SD2->D2_TOTAL
				EndIF	
			EndIF

			//--Vlr.Mercantil (Pneus novos)
			IF cGrupo $ "0001" .or. SD2->D2_TES = '503' // Grupo de Pneus novos
				IF SF2->F2_TIPO = 'N'
					T1VMERC += SD2->D2_TOTAL
				EndIF	LOCAL    
			EndIF
		
			//--Vlr.Total Faturado
			IF SF4->F4_DUPLIC = 'S' //.and. ! cGrupo $ "CARC" //Total Faturado
				IF SF2->F2_TIPO = 'N'
					T1VTOT += SD2->D2_TOTAL
				EndIF	
			EndIF
			dbSelectArea("SD2")
			dbSkip()
			lGrupo := .F.
		EndDo

		dbSelectArea("TRB")
		TRB->(dbSkip())
	EndDo
	//TOTALIZAR ULTIMO CLIENTE
	if (T1VREP + T1QREF + T1QREJ + T1VAST + T1VMER + T1VTOT) > 0
       @ nLin, 001 Psay cCodCli
	   @ nLin, 010 Psay Substr(SA1->A1_NOME,1,40)
	   @ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
	   @ nLin, 092 Psay T1QREF   Picture "@E 9999"
	   @ nLin, 097 Psay T1QREJ   Picture "@E 9999"
       @ nLin, 102 Psay T1VAST   Picture "@E 999,999,999.99"
	   @ nLin, 117 Psay T1VMER   Picture "@E 999,999,999.99"
	   @ nLin, 132 Psay T1VTOT   Picture "@E 999,999,999.99"   
       nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
	endif
    //ACUMULAR ULTIMO CLIENTE 
	T2VREP   += T1VREP
	T2QREF   += T1QREF
	T2QREJ   += T1QREJ
	T2VAST   += T1VAST
	T2VMER   += T1VMER
	T2VTOT   += T1VTOT
	//TOTALIZAR ULTIMO VENDEDOR
	@ nLin, 001 Psay "SubTotal : "
	@ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
	@ nLin, 092 Psay T1QREF   Picture "@E 9999"
	@ nLin, 097 Psay T1QREJ   Picture "@E 9999"
    @ nLin, 102 Psay T1VAST   Picture "@E 999,999,999.99"
	@ nLin, 117 Psay T1VMER   Picture "@E 999,999,999.99"
	@ nLin, 132 Psay T1VTOT   Picture "@E 999,999,999.99"   
	nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
	//ACUMULAR TOTAL
	T3VREP   += T2VREP
	T3QREF   += T2QREF
	T3QREJ   += T2QREJ
	T3VAST   += T2VAST
	T3VMER   += T2VMER
	T3VTOT   += T2VTOT	
    //TOTALIZAR RELATORIO    
	@ nLin, 001 Psay "Total Geral: "
	@ nLin, 060 Psay T3VREP   Picture "@E 999,999,999.99"
	@ nLin, 092 Psay T3QREF   Picture "@E 9999"
	@ nLin, 097 Psay T3QREJ   Picture "@E 9999"
    @ nLin, 102 Psay T3VAST   Picture "@E 999,999,999.99"
	@ nLin, 117 Psay T3VMER   Picture "@E 999,999,999.99"
	@ nLin, 132 Psay T3VTOT   Picture "@E 999,999,999.99"   
	nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))

	dbSelectArea("TRB")
	dbCloseArea()
	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil
// FINAL DO PROGRAMA  

Static FUNCTION ImpRel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,MV_COMP)         
    Local nLin
    Local Titulo
    Local cabec1
    Local cabec2
    Local nomeprog
    Local MV_Comp
	IF nLin > 55
	   nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
	   nLin += 2
	Else
	   nLin += 1
	Endif
Return nLin


FIM

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
