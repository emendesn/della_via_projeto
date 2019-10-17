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

	LOCAL _cQry    :=  ""
	LOCAL nOrdem   := aReturn[8]

	Private cString
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
	Private nLin        := 80
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
	Private cString 	:= "SF2"

//	LOCAL _aTam    := _aEstrutura := {}
//	LOCAL nOrdem   := aReturn[8]

	dbSelectArea("SF2")
	dbSetOrder(1)

	_aRegs:={}

	AAdd(_aRegs,{_cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"03","Do  Código    ?"   ,"Do Código  "    ,"Do Código  "    ,"mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"04","Ate Código    ?"   ,"Ate Código  "   ,"Ate Código  "   ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})

	ValidPerg(_aRegs,_cPerg)

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

	_cQry    := ""
    T1VREP   := T1QREF   := T1QREJ  := T1VASTEC := T1VMERC  := T1VTOTAL := 0
    T1VREP   := T2QREF   := T2QREJ  := T2VASTEC := T2VMERC  := T2VTOTAL := 0
    T1VREP   := T3QREF   := T3QREJ  := T3VASTEC := T3VMERC  := T3VTOTAL := 0

//  SELECIONA REGISTRO 
	IF Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF

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

	_cQry := ChangeQuery(_cQry)
	memowrite("DFATR09.sql",_cQry)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

	dbSelectArea("TRB")
	dbGoTop()

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
            	  @ nLin, 102 Psay T1VASTEC Picture "@E 999,999,999.99"
		          @ nLin, 117 Psay T1VMERC  Picture "@E 999,999,999.99"
		          @ nLin, 132 Psay T1VTOTAL Picture "@E 999,999,999.99"   
		          nLin:=Imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      endif  
		      @ nLin, 001 pSay " "  
              nLin:=imprel(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      //TOTALIZAR VENDEDOR
		      @ nLin, 001 Psay "SubTotal : "
		      @ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
		      @ nLin, 092 Psay T1QREF   Picture "@E 9999"
		      @ nLin, 097 Psay T1QREJ   Picture "@E 9999"
              @ nLin, 102 Psay T1VASTEC Picture "@E 999,999,999.99"
		      @ nLin, 117 Psay T1VMERC  Picture "@E 999,999,999.99"
		      @ nLin, 132 Psay T1VTOTAL Picture "@E 999,999,999.99"   
		      nLin:=(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      //ACUMULAR TOTAL
			  T3VREP   += T2VREP
			  T3QREF   += T2QREF
			  T3QREJ   += T2QREJ
			  T3VASTEC += T2VASTEC
			  T3VMERC  += T2VMERC
			  T3VTOTAL += T2VTOTAL
			  //ZERAR VENDEDOR
		      T2VREP   := T2QREF   := T2QREJ  := T2VASTEC := T2VMERC  := T2VTOTAL := 0
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
			  if (T1VREP + T1QREF + T1QREJ + T1VASTEC + T1VMERC + T1VTOTAL) > 0
                  @ nLin, 001 Psay cCodCli
		          @ nLin, 010 Psay Substr(SA1->A1_NOME,1,40)
		          @ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
		          @ nLin, 092 Psay T1QREF   Picture "@E 9999"
		          @ nLin, 097 Psay T1QREJ   Picture "@E 9999"
            	  @ nLin, 102 Psay T1VASTEC Picture "@E 999,999,999.99"
		          @ nLin, 117 Psay T1VMERC  Picture "@E 999,999,999.99"
		          @ nLin, 132 Psay T1VTOTAL Picture "@E 999,999,999.99"   
                  nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		      endif
			endif
			T2VREP   += T1VREP
			T2QREF   += T1QREF
			T2QREJ   += T1QREJ
			T2VASTEC += T1VASTEC
			T2VMERC  += T1VMERC
			T2VTOTAL += T1VTOTAL
		    T1VREP   := T1QREF   := T1QREJ  := T1VASTEC := T1VMERC  := T1VTOTAL := 0
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
					T1VASTEC += SD2->D2_TOTAL
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
					T1VTOTAL += SD2->D2_TOTAL
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
	if (T1VREP + T1QREF + T1QREJ + T1VASTEC + T1VMERC + T1VTOTAL) > 0
       @ nLin, 001 Psay cCodCli
	   @ nLin, 010 Psay Substr(SA1->A1_NOME,1,40)
	   @ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
	   @ nLin, 092 Psay T1QREF   Picture "@E 9999"
	   @ nLin, 097 Psay T1QREJ   Picture "@E 9999"
       @ nLin, 102 Psay T1VASTEC Picture "@E 999,999,999.99"
	   @ nLin, 117 Psay T1VMERC  Picture "@E 999,999,999.99"
	   @ nLin, 132 Psay T1VTOTAL Picture "@E 999,999,999.99"   
       nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
	endif
    //ACUMULAR ULTIMO CLIENTE 
	T2VREP   += T1VREP
	T2QREF   += T1QREF
	T2QREJ   += T1QREJ
	T2VASTEC += T1VASTEC
	T2VMERC  += T1VMERC
	T2VTOTAL += T1VTOTAL
	//TOTALIZAR ULTIMO VENDEDOR
	@ nLin, 001 Psay "SubTotal : "
	@ nLin, 060 Psay T1VREP   Picture "@E 999,999,999.99"
	@ nLin, 092 Psay T1QREF   Picture "@E 9999"
	@ nLin, 097 Psay T1QREJ   Picture "@E 9999"
    @ nLin, 102 Psay T1VASTEC Picture "@E 999,999,999.99"
	@ nLin, 117 Psay T1VMERC  Picture "@E 999,999,999.99"
	@ nLin, 132 Psay T1VTOTAL Picture "@E 999,999,999.99"   
	nLin:=imprel(nLin,Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
	//ACUMULAR TOTAL
	T3VREP   += T2VREP
	T3QREF   += T2QREF
	T3QREJ   += T2QREJ
	T3VASTEC += T2VASTEC
	T3VMERC  += T2VMERC
	T3VTOTAL += T2VTOTAL	
    //TOTALIZAR RELATORIO    
	@ nLin, 001 Psay "Total Geral: "
	@ nLin, 060 Psay T3VREP   Picture "@E 999,999,999.99"
	@ nLin, 092 Psay T3QREF   Picture "@E 9999"
	@ nLin, 097 Psay T3QREJ   Picture "@E 9999"
    @ nLin, 102 Psay T3VASTEC Picture "@E 999,999,999.99"
	@ nLin, 117 Psay T3VMERC  Picture "@E 999,999,999.99"
	@ nLin, 132 Psay T3VTOTAL Picture "@E 999,999,999.99"   
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
