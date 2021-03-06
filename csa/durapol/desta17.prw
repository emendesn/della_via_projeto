#include 'protheus.ch'  
#include 'dellavia.ch'

User Function DESTA17 ()

//  Fun��o			  : Validar Gera Pedido de Venda
	Local 	cDesc1  	:= " "
	Local 	cDesc2  	:= " "
	Local 	cDesc3  	:= " "
	Local 	cString 	:= "SC2"    // Alias utilizado na Filtragem
	Local 	lDic    	:= .F.      // Habilita/Desabilita Dicionario
	Local   cPerg   	:= "DEST17"    
    Private Titulo      := "Validacao Gera Pedido"  
    Private Cabec1		:= ""
    Private Cabec2		:= ""
    Private NomeProg	:= "DEST17"
    Private wnrel		:= "DEST17" // Nome do Arquivo utilizado no Spool 
	Private lAbortPrint := .F.
	Private Tamanho 	:= "G"      // P/M/G
	Private Limite  	:= 220      // 80/132/220
	Private aOrd    	:= {}       // Ordem do Relatorio
	Private aReturn 	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
	Private nTipo   	:= 15
	Private Li			:= 80
	Private lEnd    	:= .F.// Controle de cancelamento do relatorio
	Private m_pag   	:= 1  // Contador de Paginas
	Private nLastKey	:= 0  // Controla o cancelamento da SetPrint e SetDefault
    Private Cabec1      := ""
	Private Cabec2      := ""
	Private lImp        := .F.
    
	cPerg    		  	:= PADR(cPerg,6)
	aRegs    		  	:= {}	
	AADD(aRegs,{cPerg,"01","Do Cliente           "," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"02","At� o Cliente        "," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"03","Da Coleta            "," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"04","At� a Coleta         "," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"05","Da Data Entrega      "," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"06","At� a Data Entrega   "," "," ","mv_ch6","D", 08,0,0,"G","","mv_par06",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"07","Status OP            "," "," ","mv_ch7","N", 01,0,0,"C","","mv_par07","Todas"       ,"","","","","Produzidas","","","","",""       ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"08","Ordenar por          "," "," ","mv_ch8","N", 01,0,0,"C","","mv_par08","Coleta"      ,"","","","",""          ,"","","","",""      ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"09","Da Data Emiss�o OP   "," "," ","mv_ch9","D", 08,0,0,"G","","mv_par09",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"10","At� a Data Emiss�o OP"," "," ","mv_chA","D", 08,0,0,"G","","mv_par10",""            ,"","","","",""          ,"","","","",""       ,"","","","",""            ,"","","","","","","","","   ","","","",""          })

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
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif
	
	wnrel := SetPrint(cString,"DEST17",cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
    
    SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({||RunReport()})

	if lImp 
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()

Return Nil

Static Function RunReport()

    IncProc("Imprimindo ...")

	cSql := "SELECT ZZ2_ENTREG,ZZ2_CODCLI,ZZ2_LOJA,ZZ2_DOC,ZZ2_SERIE,ZZ2_CONDPG, "     
	cSql += "       C2_FILIAL,C2_NUM,C2_ITEM,C2_EMISSAO,C2_XNREDUZ,C2_X_STATU,C2_XMREDIR,C2_XDTCLAV,C2_DATRF,C2_OBS, "
	cSql += "       D1_X_DESEN,D1_CARCACA,D1_NUMFOGO,D1_SERIEPN,D1_COD,D1_SERVICO,D1_ITEM,D1_COD, "
	cSql += "       F1_COND,E4_COND, " 
	cSql += "       A1_VEND3,V3.A3_NOME  AS V3_NOME,V3.A3_COMIS AS V3_COMIS, "
	cSql += "       A1_VEND4,V4.A3_NOME  AS V4_NOME,V4.A3_COMIS AS V4_COMIS, "
	cSql += "       A1_VEND5,V5.A3_NOME  AS V5_NOME,V5.A3_COMIS AS V5_COMIS, "
	cSql += "       A1_CALCCON, "
	cSql += "       C6_NOTA, "
	cSql += "       B1P.B1_GRUPO  AS P_GRUPO, "
	cSql += "       B1P.B1_DESC   AS P_DESC, "
	cSql += "       B1P.B1_MSBLQL AS P_MSBLQL, "
	cSql += "       B1S.B1_GRUPO  AS S_GRUPO, "
	cSql += "       B1S.B1_DESC   AS S_DESC, " 
	cSql += "       B1S.B1_MSBLQL AS S_MSBLQL "
	cSql += " FROM " + RetSqlName("ZZ2") + " ZZ2 "
  	cSql += " JOIN " + RetSqlName("SF1") + " SF1 "
  	cSql += "   ON SF1.D_E_L_E_T_  = '' "     
	cSql += "  AND F1_FILIAL       = ZZ2_FILIAL "
	cSql += "  AND F1_DOC          = ZZ2_DOC "
	cSql += "  AND F1_SERIE        = ZZ2_SERIE "
	cSql += "  AND F1_FORNECE      = ZZ2_CODCLI "
	cSql += "  AND F1_LOJA         = ZZ2_LOJA "
	cSql += " JOIN " + RetSqlName("SD1") + " SD1 "
	cSql += "   ON SD1.D_E_L_E_T_  = '' "
	cSql += "  AND D1_FILIAL       = F1_FILIAL "
	cSql += "  AND D1_DOC          = F1_DOC "
	cSql += "  AND D1_SERIE        = F1_SERIE "
	cSql += "  AND D1_FORNECE      = F1_FORNECE "
	cSql += "  AND D1_LOJA         = F1_LOJA "
    cSql += " JOIN " + RetSqlName("SB6") + " SB6"
    cSql += "   ON SB6.D_E_L_E_T_  = '' "  
    cSql += "  AND B6_FILIAL       = D1_FILIAL "
    cSql += "  AND B6_DOC          = D1_DOC " 
    cSql += "  AND B6_SERIE        = D1_SERIE "
    cSql += "  AND B6_CLIFOR       = D1_FORNECE "  
    cSql += "  AND B6_LOJA         = D1_LOJA "  
    cSql += "  AND B6_IDENT        = D1_IDENTB6 "  
    cSql += "  AND B6_SALDO        > 0 "
	cSql += " JOIN " + RetSqlName("SC2") + " SC2 "
	cSql += "   ON SC2.D_E_L_E_T_  = ''"
	cSql += "  AND C2_FILIAL       = D1_FILIAL "
	cSql += "  AND C2_NUMD1        = D1_DOC "
    cSql += "  AND C2_SERIED1      = D1_SERIE "
	cSql += "  AND C2_ITEMD1       = D1_ITEM "
	cSql += "  AND C2_NUM         >= '" + mv_par03 + "' "
	cSql += "  AND C2_NUM         <= '" + mv_par04 + "' "   
	cSql += "  AND C2_EMISSAO     >= '" + DTOS(mv_par09) + "' "
	cSql += "  AND C2_EMISSAO     <= '" + DTOS(mv_par10) + "' "
	If mv_par07 = 1
		cSql += "  AND C2_X_STATU IN('6','9') "
	EndIf
	cSql += " LEFT JOIN "+ RetSqlName("SC6") + " SC6 "
    cSql += "   ON SC6.D_E_L_E_T_  = '' "
   	cSql += "  AND C6_FILIAL       = C2_FILIAL "
	cSql += "  AND C6_NUMOP        = C2_NUM "
    cSql += "  AND C6_ITEMOP       = C2_ITEM " 
	cSql += " JOIN " + RetSqlName("SA1") + " SA1 "
	cSql += "   ON SA1.D_E_L_E_T_  = '' "
	cSql += "  AND A1_FILIAL       = '' "
	cSql += "  AND A1_COD          = D1_FORNECE "
	cSql += "  AND A1_LOJA         = D1_LOJA " 
	cSql += "  LEFT JOIN " + RetSqlName("SB1") + " B1P"
	cSql += "    ON B1P.D_E_L_E_T_ = '' "
	cSql += "   AND B1P.B1_FILIAL  = '' "
	cSql += "   AND B1P.B1_COD     = D1_COD "
	
	cSql += "  LEFT JOIN " + RetSqlName("SB1") + " B1S"
	cSql += "    ON B1S.D_E_L_E_T_ = '' "
	cSql += "   AND B1S.B1_FILIAL  = '' "
	cSql += "   AND B1S.B1_COD     = D1_SERVICO "
	
	cSql += "  LEFT JOIN " + RetSqlName("SA3")+" V3 "
	cSql += "    ON V3.D_E_L_E_T_  = '' "
	cSql += "   AND V3.A3_FILIAL   = '' "
	cSql += "   AND V3.A3_COD      = SA1.A1_VEND3 "   
	
	cSql += "  LEFT JOIN " + RetSqlName("SA3")+" V4 "
	cSql += "    ON V4.D_E_L_E_T_  = '' "
	cSql += "   AND V4.A3_FILIAL   = '' "
	cSql += "   AND V4.A3_COD      = SA1.A1_VEND4 "
	
	cSql += "  LEFT JOIN " + RetSqlName("SA3")+" V5 "
	cSql += "    ON V5.D_E_L_E_T_  = '' "
	cSql += "   AND V5.A3_FILIAL   = '' "
	cSql += "   AND V5.A3_COD      = SA1.A1_VEND5 "   

	cSql += "  LEFT JOIN " + RetSqlName("SE4")+" SE4"
	cSql += "    ON SE4.D_E_L_E_T_ = ''"
	cSql += "   AND E4_FILIAL      = ''"
	cSql += "   AND E4_CODIGO      = F1_COND " 

    cSql += "WHERE ZZ2.D_E_L_E_T_  = '' "
	cSql += "  AND ZZ2_FILIAL      = '" + xFilial("ZZ2") + "' "
	cSql += "  AND ZZ2_CODCLI     >= '" + mv_par01       + "' "
	cSql += "  AND ZZ2_CODCLI     <= '" + mv_par02       + "' "                                                 
	cSql += "  AND ZZ2_ENTREG     >= '" + dtos(mv_par05) + "' "
	cSql += "  AND ZZ2_ENTREG     <= '" + dtos(mv_par06) + "' " 
	cSql +="   AND C2_EMISSAO     >= '" + dtos(mv_par09) + "' "
	cSql +="   AND C2_EMISSAO     <= '" + dtos(mv_par10) + "' "
    cSql += "ORDER BY C2_FILIAL,ZZ2_DOC,ZZ2_SERIE "
    
	cSql := ChangeQuery(cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"Arq_Db2", .F., .T.)
	
	TCSetField( "Arq_Db2" , "C2_EMISSAO"  , "D", 8 )
	TCSetField( "Arq_Db2" , "C2_DATRF"    , "D", 8 ) 
	TCSetField( "Arq_Db2" , "C2_XDTCLAV"  , "D", 8 )
	TCSetField( "Arq_Db2" , "ZZ2_ENTREG"  , "D", 8 )
	TCSetField( "Arq_Db2" , "V3_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Db2" , "V4_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Db2" , "V5_COMIS"    , "N", 14 , 2)
                 
	//lLibRec 	:= .F.
    
	dbSelectArea("Arq_Db2")
	dbGoTop()
	vReg:=""	
	aTab:={}   
	vSep:=" "
	      //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	CABEC1="FD Coleta Ser Item Client Lj Nome do Cliente      Entrega  OrdemP It Status     Servi�o    Emiss.OP AutoClav Producao  Desenho         Carca�a         Fogo   S�rie"
	CABEC2="                                                                                           Cond.Pagt. Vend3  Vend4  Vend5  CC          Medida          Observa��o"
    vReg := ""
	While !Eof()
		If 	vReg <> Arq_Db2->C2_FILIAL+Arq_Db2->ZZ2_DOC+Arq_Db2->ZZ2_SERIE   
			If Recno() <> 1 .and. TudoOk
			    DoCab()     
			    @Li, 000 PSAY substr(vLin1,1,13)+space(5)+substr(vLin1,19,47)+"    Tudo Ok para Gerar Pedido"
				DoCab()
				@Li, 000 PSAY " "
			EndIf
			vReg	:= Arq_Db2->C2_FILIAL+Arq_Db2->ZZ2_DOC+Arq_Db2->ZZ2_SERIE
			TudoOk  := .T.
		EndIf                                                
		aTab:={}
		vLin1 := Arq_db2->C2_Filial  
		vLin1 += vSep
		vLin1 += Arq_Db2->ZZ2_Doc
		vLin1 += vSep
		vLin1 += Arq_Db2->ZZ2_Serie
		vLin1 += vSep  
		vLin1 += Arq_Db2->D1_Item
		vLin1 += vSep
		vLin1 += Arq_Db2->ZZ2_CodCli
		vLin1 += vSep
		vLin1 += Arq_Db2->ZZ2_Loja
		vLin1 += vSep
		vLin1 += Arq_Db2->C2_XNReduz
		vLin1 += vSep
		vLin1 += dtoc(Arq_Db2->ZZ2_Entreg)
		vLin1 += vSep      
		vLin1 += Arq_Db2->C2_Num
		vLin1 += vSep
		vLin1 += Arq_Db2->C2_Item
		vLin1 += vSep
		// Status OP    
		TudoOk := .T.
		Do Case
			Case substr(Arq_Db2->D1_X_DESEN,1,4) == "EXAM" .and. Empty(Arq_Db2->C2_XMREDIR)
				vStatus := "Exame"
				TudoOk  := .F.
			Case Arq_Db2->C2_X_STATU = "6"
				vStatus := "Liberado"    
			Case Arq_Db2->C2_X_STATU = "9"
				vStatus := "Recusado"
			Case .not.empty(Arq_Db2->C2_XDTClav)
				vStatus := "AutoClave"
				TudoOk  := .F.    
			Case Arq_Db2->C2_X_STATU = "4"
				vStatus := "Em Producao"
				TudoOk  := .F.
			Case Arq_Db2->C2_X_STATU = "T" .or. Arq_Db2->C2_X_STATU = "7"
		 		vStatus := "Parado"                               
		 		aAdd(aTab,"Em Terceiro")
				TudoOk  := .F.
			Case Arq_Db2->C2_X_STATU = "A"
				vStatus := "Parado"
				aAdd(aTab,"Aguardando Autoriza��o do Cliente")
				TudoOk  := .F.
			Case Arq_Db2->C2_X_STATU = "B"
				vStatus := "Parado"
				aAdd(aTab,"Aguardando Aprova��o de Credito")
				TudoOk  := .F.
			Otherwise
				vStatus := "Parado"
				If (date()-Arq_Db2->ZZ2_ENTREG) > 7
				   aAdd(aTab,"Em Inspe��o por mais de 7 dias")
				EndIf
				TudoOk  := .F.
			EndCase                                      
		vLin1 += PADR(vStatus,10)
		vLin1 += vSep            	
    	// Tipo Servi�o	
		Do Case
			Case Alltrim(Arq_Db2->S_GRUPO) $ Alltrim(GetMV("MV_X_GRPSC"))
				vTIPO 	:= "SOCONSERTO"
			Case Posicione( "SB1", 1, xFilial("SB1") + AllTrim(Arq_Db2->D1_SERVICO), "B1_X_ESPEC" ) == "F "
				vTIPO 	:= "RECAPAGEM"
			Case Posicione( "SB1", 1, xFilial("SB1") + AllTrim(Arq_Db2->D1_SERVICO), "B1_X_ESPEC" ) == "Q "
				vTIPO 	:= "RECAUCHUT."
			Otherwise
		 		vTIPO 	:= "INCORRETO"
		   		aAdd (aTab,"Verifique Cadastro B1_X_Espec")
		   		TudoOk  := .F.
		EndCase                                           
		
//		If substr(Arq_Db2->E4_COND,1,1)=" "
//			aAdd(aTab,"Condi��o de Pagamento N�o Informado")
//			TudoOk  := .F.
//		EndIf                                                                   
		
		vLin1 += PADR(vTipo,10)
		vLin1 += vSep 
		vLin1 += dtoc(Arq_Db2->C2_EMISSAO)
		vLin1 += vSep
		vLin1 += dtoc(Arq_Db2->C2_XDTCLAV)
		vLin1 += vSep
		vLin1 += dtoc(Arq_Db2->C2_DATRF)
		vLin1 += vSep
		vLin1 += " "+Arq_Db2->D1_X_DESEN
		vLin1 += vSep
		vLin1 += Arq_Db2->D1_CARCACA
		vLin1 += vSep
		vLin1 += Arq_Db2->D1_NUMFOGO
		vLin1 += vSep
		vLin1 += Arq_Db2->D1_SERIEPN
		
	 	vLin2 := PADR(Arq_Db2->D1_SERVICO,10)
		vLin2 += vSep
	 	vLin2 += PADR(Arq_Db2->E4_COND,10)
		vLin2 += vSep
	 	vLin2 += Arq_Db2->A1_VEND3
		vLin2 += vSep
	 	vLin2 += Arq_Db2->A1_VEND4
		vLin2 += vSep
	 	vLin2 += Arq_Db2->A1_VEND5
		vLin2 += vSep
	 	vLin2 += space(01) + Arq_Db2->A1_CALCCON
		vLin2 += space(10) + Arq_Db2->D1_COD 
		vLin2 += vSep
		vLin2 += Arq_Db2->C2_OBS

		// Verifica Pre�o Recapagem/Recauchutagem

		If !Empty(Arq_Db2->C6_NOTA)
			aAdd(aTab,"J� Faturado ... Atualizar SB6")
			TudoOk  := .F.
		Endif
		
		If vTIPO $ "RECAPAGEM*RECAUCHUT."  
			If U_BuscaAcp ( Arq_Db2->D1_SERVICO, Arq_Db2->ZZ2_CODCLI, Arq_Db2->ZZ2_LOJA ) = 0		
				aAdd (aTab,"Pre�o Servi�o N�o Cadastrado")
				TudoOk  := .F.
			EndIf
		EndIf
		
		If Arq_Db2->P_MSBLQL = "1"
			aAdd(aTab,"C�digo Carca�a Registro com Bloqueio")
			TudoOk  := .F.  
		Endif        
		
		If Arq_Db2->S_MSBLQL = "1"
			aAdd(aTab,"C�digo Servi�o com Bloqueio")
			TudoOk  := .F.
		Endif        
		                       
		If Substr(Arq_Db2->A1_VEND3,1,6)<"971000" .or. Substr(Arq_Db2->A1_VEND3,1,6)>"973999"
			aAdd(aTab,"Vendedor 3 Inv�lido")
			TudoOk  := .F.
		EndIf                                               
		
		// Verifica Banda/Conserto
		cQdb2 := "SELECT ZF_NUMOP   AS NUMOP, "
		cQdb2 += "       ZF_PRODSRV AS X_PROD, "
		cQdb2 += "       ZF_QUANT   AS QUANT, "                       
		cQdb2 += "       '01'       AS X_ARMZ,"
		cQdb2 += "       B1_GRUPO   AS GRUPO, "
		cQdb2 += "       B1_DESC    AS DESC "
		cQdb2 += "  FROM " + RetSqlName("SZF") + " SZF, "
		cQdb2 +=             RetSqlName("SB1") + " SB1 "
		cQdb2 += " WHERE SZF.D_E_L_E_T_ = '' "
		cQdb2 += "   AND SB1.D_E_L_E_T_ = '' "
		cQdb2 += "   AND ZF_FILIAL = '" + Arq_Db2->C2_FILIAL + "' "
		cQdb2 += "   AND B1_FILIAL = '' "
		cQdb2 += "   AND ZF_NUMOP  = '" + Arq_Db2->C2_NUM + Arq_Db2->C2_ITEM + "001' "
		cQdb2 += "   AND ZF_PRODSRV = B1_COD"
		cQdb2 += " UNION  "
		cQdb2 += "SELECT D3_OP     AS NUMOP, "
		cQdb2 += "       D3_X_PROD AS X_PROD, "
		cQdb2 += "       D3_QUANT  AS QUANT, "
		cQdb2 += "       D3_X_ARMZ AS X_ARMZ, "
		cQdb2 += "       B1_GRUPO  AS GRUPO, "
		cQdb2 += "       B1_DESC   AS DESC "
		cQdb2 += "  FROM " + RetSqlName("SD3") + " SD3, "
		cQdb2 +=             RetSqlName("SB1") + " SB1  "
		cQdb2 += " WHERE SD3.D_E_L_E_T_ = '' "
		cQdb2 += "   AND SB1.D_E_L_E_T_ = '' "
 		cQdb2 += "   AND D3_FILIAL      = '" + Arq_Db2->C2_FILIAL + "' "
  		cQdb2 += "   AND B1_FILIAL      = '' "
		cQdb2 += "   AND D3_OP          = '" + Arq_Db2->C2_NUM + Arq_Db2->C2_ITEM + "001' "
		cQdb2 += "   AND D3_ESTORNO     = '' "
		cQdb2 += "   AND D3_X_PROD      = B1_COD"
		
		cQdb2 := ChangeQuery( cQdb2 )		
		dbUseArea( .T., "TOPCONN", TCGenQry(,, cQdb2), "SQL3", .F., .T. ) 
		TCSetField( "SQL3" , "QUANT"    , "N", 14 , 2)	
	
		dbSelectArea("SQL3")
		dbGoTop()   
		nBand := 0
		nCons := 0	
		While !Eof()
			
			If ALLTRIM(SQL3->GRUPO) $ 'CI*SC'
				nCons++
				If U_BuscaAcp ( SQL3->X_PROD, Arq_Db2->ZZ2_CODCLI, Arq_Db2->ZZ2_LOJA ) = 0
					aAdd(aTab,"Servi�o Sem Pre�o Cadastrado")
					TudoOk  := .F.
				EndIf
		   	EndIf
		   	
		   	If SQL3->GRUPO = 'BAND'
		   	    nBand++
		   		If vTIPO = "RECAPAGEM" .and. !("EXAM" $ Arq_Db2->D1_X_Desen)                                        
					vDesCol := AllTrim(Arq_Db2->D1_X_Desen)
					vCodBan := AllTrim(SQL3->X_PROD)
					vDesLan := AllTrim(Posicione( "SB1", 1 , xFilial("SB1") + vCodBan , "B1_XDESENH" )) 
					If StrTran(StrTran(vDesLan,"-","")," ","") <> StrTran(StrTran(vDesCol,"-","")," ","")  
						aAdd(aTab,"Banda Lan�ada na OP-Desenho("+vDesLan+")Diferente do Desenho Informado na Coleta("+vDesCol+")"+" "+SQL3->NUMOP+" "+SQL3->X_PROD) 
						TudoOk  := .F.                         
					EndIf
				EndIf
			EndIf 
			dbSelectArea("SQL3")
			dbSkip()
		EndDo
		dbSelectArea("SQL3")
		dbCloseArea("SQL3")  
		
  		// Verifica Apontamento de Servi�os
		If vStatus = "Liberado"   .and. vTIPO = "SOCONSERTO" .and. nCons = 0
			aAdd(aTab,"Servi�o de Conserto N�o Lan�ado")
			TudoOk  := .F. 
		EndIf		

  		If nBand > 1 .and. !("REPROC" $ Arq_Db2->C2_OBS) 
			aAdd(aTab,"Banda Lan�ada + 1 vez")
			TudoOk  := .F.      
		EndIf
		If vStatus = "Liberado"   .and. vTIPO = "RECAPAGEM"  .and. nBand = 0
			aAdd(aTab,"Banda N�o Lan�ada")
			TudoOk  := .F.
		EndIf
		If vTIPO  = "SOCONSERTO" .and. nBand > 0
			aAdd(aTab,"Banda Lan�ada em S� Conserto")
			TudoOk  := .F.
		EndIf
//		If vTipo = "SOCONSERTO" .and. Arq_dB2->A1_CALCCON="N"
//			aAdd(aTab,"Cobra Conserto = 'N'")
//			TudoOk  := .T.
//		EndIf
	
		If len(aTab) > 0
			DoCab()
			@Li, 000 PSAY vLin1
			DoCab()
			@Li, 080 PSAY vLin2
			For I = 1 to len(aTab) 
				DoCab()
				@Li, 091 PSAY aTab[I]
			EndFor
		EndIf
		                         
	    dbSelectArea("Arq_Db2")
		dbSkip()
	EndDo 
	
	If TudoOk
		DoCab()     
		@Li, 000 PSAY substr(vLin1,1,13)+space(5)+substr(vLin1,19,47)+"    Tudo Ok para Gerar Pedido"

		DoCab()
		@Li, 000 PSAY " "
	EndIf

	dbSelectArea("Arq_Db2")
	dbCloseArea()    
	
Return nil
            
Static Function DoCab()
		lImp:=.t.
		If li>60
  			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			LI+=1
		EndIf
	    Li++
Return nil