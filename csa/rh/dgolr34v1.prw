
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR34V1 ()

	Private cString        := "SG1"
	Private aOrd           := {}
	Private cDesc1         := "RELATORIO VERIFICACAO SG1 "
	Private cDesc2         := "              "
	Private cDesc3         := "              "
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR34V1"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL34"
	Private titulo         := "SG1"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR34"
	Private lImp           := .F.
    Private xCusto         := 0.0
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {} 
   	AAdd(aRegs,{cPerg,"01","De.....................?"," "," ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"02","Até....................?"," "," ","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})

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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)
	
	if (mv_par02 - mv_par01) > 31 .or. month(mv_par01) <> month(mv_par02)
		MsgBox("Periodo do parametro deve ser mensal","PAR","STOP")
		Return
	endif 
	
	cZGN := "SELECT ZG1_INSUMO AS PRECO_BANDA, ZG1_INI, ZG1_FIM "
	cZGN += "  FROM ZG1030 ZGN "
 	cZGN += " WHERE ZGN.D_E_L_E_T_     = '' "
  	cZGN += "   AND ZGN.ZG1_FILIAL     = '' "
   	cZGN += "   AND '" + DTOS(MV_PAR01) + "' BETWEEN ZGN.ZG1_INI AND ZGN.ZG1_FIM "
   	cZGN += "   AND '" + DTOS(MV_PAR02) + "' BETWEEN ZGN.ZG1_INI AND ZGN.ZG1_FIM "
   	cZGN += "   AND ZGN.ZG1_COD = 'NOVATECK' "
	MsgRun("Consultando Banco de dados ... ZGN",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cZGN),"ARQ_ZGN", .T., .T.)})   
	TcSetField("ARQ_ZGN","PRECO_BANDA",  "N",14,2)
	TcSetField("ARQ_ZGN","ZG1_INI"    ,  "D",8)
	TcSetField("ARQ_ZGN","ZG1_FIM"    ,  "D",8)
	
	dbSelectArea("ARQ_ZGN")
	dbGoTop()
	if eof()
		MsgBox("Registro Preco Banda Novateck Nao Cadastrado","ZG1","STOP")   
		Return
	endif  
	cZGV := "SELECT ZG1_INSUMO AS PRECO_BANDA, ZG1_INI, ZG1_FIM"
	cZGV += "  FROM ZG1030 ZGV "
 	cZGV += " WHERE ZGV.D_E_L_E_T_     = '' "
  	cZGV += "   AND ZGV.ZG1_FILIAL     = '' "
   	cZGV += "   AND '" + DTOS(MV_PAR01) + "' BETWEEN ZGV.ZG1_INI AND ZGV.ZG1_FIM "
   	cZGV += "   AND '" + DTOS(MV_PAR02) + "' BETWEEN ZGV.ZG1_INI AND ZGV.ZG1_FIM "
   	cZGV += "   AND ZGV.ZG1_COD = 'VIPAL' "
	MsgRun("Consultando Banco de dados ... ZGV",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cZGV),"ARQ_ZGV", .T., .T.)})   
	TcSetField("ARQ_ZGV","PRECO_BANDA",  "N",14,2)
	TcSetField("ARQ_ZGV","ZG1_INI"    ,  "D",8)
	TcSetField("ARQ_ZGV","ZG1_FIM"    ,  "D",8)
	
	dbSelectArea("ARQ_ZGV")
	dbGoTop()
	if eof()
		MsgBox("Registro Preco Banda Vipal Nao Cadastrado","ZGV","STOP")   
		Return
	endif                

	cZGD := "SELECT B1_COD, AVG(D1_TOTAL / D1_QUANT) AS CUSTD "
	cZGD += "  FROM SB1030 SB1, SD1030 SD1 "
 	cZGD += " WHERE SB1.D_E_L_E_T_     = '' "
  	cZGD += "   AND SB1.B1_FILIAL      = '' "                       
  	cZGD += "   AND SB1.B1_X_GRUPO     = 'T' "
  	cZGD += "   AND SD1.D_E_L_E_T_     = '' "
  	cZGD += "   AND SD1.D1_COD         = B1_COD "
  	cZGD += "   AND SD1.D1_FILIAL      > '' "                       
   	cZGD += "   AND SD1.D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR01 - 30) + "' AND '" + DTOS(MV_PAR02 + 30) + "' "
   	cZGD += " GROUP BY B1_COD "
	MsgRun("Calculando Custo Mensal Recauchutagem ... SG1",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cZGD),"ARQ_ZGD", .T., .T.)})   
	TcSetField("ARQ_ZGD","CUSTD",  "N",14,2)    
	dbSelectArea("ARQ_ZGD")     
	dbGoTop()
	do while .not.eof()     
		dbSelectArea("SG1")      
		dbSetOrder(1)
		if !SG1->(dbSeek(xFilial("SG1")+"RECAUCHUTAGEM  "+ARQ_ZGD->B1_COD))
			if reclock("SG1",.T.)
				SG1->G1_FILIAL := ""
				SG1->G1_COD    := "RECAUCHUTAGEM  "
				SG1->G1_COMP   := ARQ_ZGD->B1_COD
				SG1->G1_QUANT  := 1
				SG1->G1_INI    := MV_PAR01
				SG1->G1_FIM    := MV_PAR02
				SG1->G1_FIXVAR := "V"
				SG1->G1_REVFIM := "ZZZ"
				SG1->G1_NIV    := "01"
				SG1->G1_NIVINV := "99"
				SG1->G1_OK     := "34"
				SG1->G1_XCSBI  := ARQ_ZGD->CUSTD  
				MsUnlock()
			endif
    	else
 			if reclock("SG1",.F.)
				SG1->G1_XCSBI  := ARQ_ZGD->CUSTD
				SG1->G1_INI    := MV_PAR01
				SG1->G1_FIM    := MV_PAR02
				MsUnlock()	
			endif
		endif
		dbSelectArea("ARQ_ZGD")
		dbSkip()
	enddo
	dbSelectArea("ARQ_ZGD")
	dbCloseArea("ARQ_ZGD")
	
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

	Cabec1 := "Periodo de:" + dtoc(mv_par01) + " ate " + dtoc(mv_par02) 
   	Cabec2 := "Carcaca            Perimetro           Banda               Fabricante          KG/M                Custo Validade Inicio   Fim"
    //                  1         2         3         4         5         6         7         8                  10
    //         1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cSql := "SELECT DISTINCT C2_PRODUTO,D3_COD " 
  	cSql += "  FROM SD3030 SD3 " 
  	cSql += "  JOIN SC2030 SC2 "    
    cSql += "    ON SC2.D_E_L_E_T_                 = '' " 
    cSql += "   AND SC2.C2_FILIAL                  = D3_FILIAL " 
    cSql += "   AND SC2.C2_NUM||SC2.C2_ITEM||'001' = SD3.D3_OP "    
    cSql += "   AND D3_TM                          = '502' " 
    cSql += "   AND D3_GRUPO                       = 'BAND' "    
  	cSql += "  LEFT JOIN SG1030 SG1 "   
    cSql += "    ON SG1.D_E_L_E_T_                 = '' "      
    cSql += "   AND SG1.G1_FILIAL                  = '' "  
    cSql += "   AND SG1.G1_COD                     = SC2.C2_PRODUTO "  
    cSql += "   AND SG1.G1_COMP                    = SD3.D3_COD "                  
    cSql += "   AND '" + dtos(mv_par01) + "' BETWEEN SG1.G1_INI AND SG1.G1_FIM " 
    cSql += "   AND '" + dtos(mv_par02) + "' BETWEEN SG1.G1_INI AND SG1.G1_FIM "
    cSql += " WHERE SD3.D_E_L_E_T_                 = '' "  
    cSql += "   AND SG1.G1_COD IS NULL "  
    cSql += "   AND SD3.D3_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' "   
    cSql += " ORDER BY C2_PRODUTO,D3_COD "
    
	MsgRun("Consultando Banco de dados ... SD3",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
		
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()        
 	IncProc("Imprimindo ...")
	Do While !eof() 
	
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
		endif
		Li++
		@Li,00 psay Arq_Sql->C2_PRODUTO
		cZG1 := "SELECT ZG1_PERIME,ZG1_INSUMO,B1_FABRIC,B1_X_CONV2 "
		cZG1 += "  FROM ZG1030 ZG1, SB1030 SB1"
    	cZG1 += " WHERE ZG1.D_E_L_E_T_      = '' "
        cZG1 += "   AND ZG1.ZG1_FILIAL      = '' "   
  		cZG1 += "   AND '" + DTOS(MV_PAR01) + "' BETWEEN ZG1.ZG1_INI AND ZG1.ZG1_FIM "
   		cZG1 += "   AND '" + DTOS(MV_PAR02) + "' BETWEEN ZG1.ZG1_INI AND ZG1.ZG1_FIM "
    	cZG1 += "   AND SB1.D_E_L_E_T_      = '' "
    	cZG1 += "   AND SB1.B1_FILIAL       = '' "   
		cZG1 += "   AND SB1.B1_COD          = '" + ARQ_SQL->D3_COD     + "' "
		cZG1 += "   AND ZG1.ZG1_COD         = '" + ARQ_SQL->C2_PRODUTO + "' "
		MsgRun("Consultando Banco de dados ... ZG1",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cZG1),"ARQ_ZG1", .T., .T.)})
	    TcSetField("ARQ_ZG1","ZG1_PERIME",  "N",14,4)     
	    TcSetField("ARQ_ZG1","B1_X_CONV2",  "N",14,4)     

		DBSELECTAREA("ARQ_ZG1")    
		GOTO TOP       
		IF EOF()
			@Li,20 psay "Cadastre o perimetro da carcaca na tabela ZG1 e reprocesse o periodo"
		Else
			@Li,20 psay Arq_ZG1->ZG1_Perime
			@Li,40 psay Arq_SQL->D3_Cod
			@Li,60 psay Arq_ZG1->B1_Fabric
			@Li,80 psay Arq_ZG1->B1_X_CONV2
			Do case
				case "BANDAG" $ upper(Arq_ZG1->B1_Fabric)   
					cZGB := "SELECT D3_CUSTO1,ZG1_INSUMO,ZG1_Ini,ZG1_Fim "
					cZGB += "  FROM SD3030 SD3, SC2030 SC2, ZG1030 ZG1 "
					cZGB += " WHERE SD3.D_E_L_E_T_      = '' "
					cZGB += "   AND SC2.D_E_L_E_T_      = '' "
					cZGB += "   AND ZG1.D_E_L_E_T_      = '' "
					cZGB += "   AND SD3.D3_OP           = SC2.C2_NUM||SC2.C2_ITEM||'001' "
					cZGB += "   AND SC2.C2_PRODUTO      = '" + ARQ_SQL->C2_PRODUTO + "' "
					cZGB += "   AND SD3.D3_COD          = '" + ARQ_SQL->D3_COD     + "' "
					cZGB += "   AND SD3.D3_TM           = '502' "
					cZGB += "   AND ZG1_COD             = '" + ARQ_SQL->C2_PRODUTO + "' "
					cZGB += "  	AND '" + DTOS(MV_PAR01) + "' BETWEEN ZG1.ZG1_INI AND ZG1.ZG1_FIM "
   		            cZGB += "   AND '" + DTOS(MV_PAR02) + "' BETWEEN ZG1.ZG1_INI AND ZG1.ZG1_FIM "
					MsgRun("Consultando Banco de dados ... ZGB",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cZGB),"ARQ_ZGB", .T., .T.)})
	    			TcSetField("ARQ_ZGB","D3_CUSTO1" ,  "N",14,4)     
	    			TcSetField("ARQ_ZGB","ZG1_INSUMO",  "N",14,4)
	    			TcSetField("ARQ_ZGB","ZG1_INI"   ,  "D",8)
	    			TcSetField("ARQ_ZGB","ZG1_FIM"   ,  "D",8)
	    			     
					DBSELECTAREA("ARQ_ZGB")    
					GOTO TOP       
					IF EOF()
						@Li,99 psay "Use planilha Excel" 
					ELSE
						xCusto := ARQ_ZGB->D3_CUSTO1 + ARQ_ZGB->ZG1_INSUMO
						dbSelectArea("SG1")
						If RecLock("SG1",.T.)
							SG1->G1_FILIAL := ""
							SG1->G1_COD    := ARQ_SQL->C2_PRODUTO
							SG1->G1_COMP   := ARQ_SQL->D3_COD
							SG1->G1_QUANT  := 1
							SG1->G1_INI    := Arq_ZGB->ZG1_Ini
							SG1->G1_FIM    := Arq_ZGB->ZG1_Fim
							SG1->G1_FIXVAR := "V"
							SG1->G1_REVFIM := "ZZZ"
							SG1->G1_NIV    := "01"
							SG1->G1_NIVINV := "99"
							SG1->G1_OK     := "34"
							SG1->G1_XCSBI  := xCusto  
							MsUnlock()
                    	Endif
                    	@Li,100 psay xCusto picture "@E 999,999,999.99"
						@Li,115 psay Arq_ZGB->ZG1_Ini
						@Li,124 psay Arq_ZGB->ZG1_Fim    
                    	dbSelectArea("ARQ_ZGB")
                    	dbCloseArea("ARQ_ZGB")
					ENDIF
				case "NOVA" $ upper(Arq_ZG1->B1_Fabric)
					xCusto := Arq_ZG1->ZG1_Perime * Arq_ZG1->B1_X_Conv2 * Arq_ZGN->Preco_Banda + Arq_ZG1->ZG1_Insumo
					@Li,100 psay xCusto picture "@E 999,999,999.99"
					@Li,115 psay Arq_ZGN->ZG1_Ini
					@Li,124 psay Arq_ZGN->ZG1_Fim    
					dbSelectArea("SG1")
					If RecLock("SG1",.T.)
						SG1->G1_FILIAL := ""
						SG1->G1_COD    := ARQ_SQL->C2_PRODUTO
						SG1->G1_COMP   := ARQ_SQL->D3_COD
						SG1->G1_QUANT  := 1
						SG1->G1_INI    := Arq_ZGN->ZG1_Ini
						SG1->G1_FIM    := Arq_ZGN->ZG1_Fim
						SG1->G1_FIXVAR := "V"
						SG1->G1_REVFIM := "ZZZ"
						SG1->G1_NIV    := "01"
						SG1->G1_NIVINV := "99"
						SG1->G1_OK     := "34"
						SG1->G1_XCSBI  := xCusto  
						MsUnlock()
                    Endif
				case "VIPAL" $ upper(Arq_ZG1->B1_Fabric)
					xCusto := Arq_ZG1->ZG1_Perime * Arq_ZG1->B1_X_Conv2 * Arq_ZGV->Preco_Banda + Arq_ZG1->ZG1_Insumo
					@Li,100 psay xCusto picture "@E 999,999,999.99"
					@Li,115 psay Arq_ZGV->ZG1_Ini
					@Li,124 psay Arq_ZGV->ZG1_Fim
					If RecLock("SG1",.T.)
						SG1->G1_FILIAL := ""
						SG1->G1_COD    := ARQ_SQL->C2_PRODUTO
						SG1->G1_COMP   := ARQ_SQL->D3_COD
						SG1->G1_QUANT  := 1
						SG1->G1_INI    := Arq_ZGV->ZG1_Ini
						SG1->G1_FIM    := Arq_ZGV->ZG1_Fim
						SG1->G1_FIXVAR := "V"
						SG1->G1_REVFIM := "ZZZ"
						SG1->G1_NIV    := "01"
						SG1->G1_NIVINV := "99"
						SG1->G1_OK     := "34"
						SG1->G1_XCSBI  := xCusto  
						MsUnlock()
                    Endif       
				otherwise
					@Li,100 psay "Fabricante Invalido"
			Endcase
	    Endif   
	    dbSelectArea("Arq_ZG1")
	    dbCloseArea("Arq_ZG1")
		dbSelectArea("ARQ_SQL")
		dbSkip()

	Enddo
	
	dbSelectArea("ARQ_SQL")
	dbCloseArea()     
	dbSelectArea("ARQ_ZGN")
	dbCloseArea()
	dbSelectArea("ARQ_ZGV")
	dbCloseArea()      
	
	MsgRun("Atualizando Custo ... Aguarde",,{ || AtuCusto() })
	
	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil
                  
Static Function AtuCusto()
	
	dbSelectArea("SD2")      
	dbSetOrder(5)   
	dbGoTop()          
	dbSeek(xFilial("SD2")+dtos(mv_par01),.T.)
	do while .not.eof() .and. SD2->D2_FILIAL = XFILIAL("SD2") .and. SD2->d2_emissao >= mv_par01 .and. SD2->d2_emissao <= mv_par02  
		dbSelectArea("SB1")
		dbSeek("  "+SD2->D2_COD)
		Do case      
			case SD2->D2_TES = '903'
				// Recusado                               
			case alltrim(SD2->D2_GRUPO) = "SERV" .and. SB1->B1_X_GRUPO = "T" // RECAUCHUTAGEM
					cSql := "SELECT " + str(SD2->D2_QUANT) + " * G1_XCSBI AS XCSBI " 
  					cSql += "  FROM SG1030 SG1 "
    				cSql += " WHERE SG1.D_E_L_E_T_                 = '' "       			
    				cSql += "   AND SG1.G1_FILIAL                  = '' "     
    				cSql += "   AND SG1.G1_COD                     = 'RECAUCHUTAGEM  ' "
            		cSql += "   AND SG1.G1_COMP                    = '" + SD2->D2_COD  + "' "                  
            		cSql := ChangeQuery(cSql)                                               
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"ARQ_SQL",.F.,.T.)                            
					TcSetField("ARQ_SQL", "XCSBI", "N",14,4)
					GravCusto()
			case alltrim(SD2->D2_GRUPO) = "SERV"   // RECAPAGEM    
					cSql := "SELECT SUM(XCSBI) AS XCSBI FROM ( "
					cSql += "SELECT G1_XCSBI AS XCSBI "  
					cSql += "  FROM SC6030 SC6 " 
					cSql += "  JOIN SC2030 SC2 " 
					cSql += "    ON SC2.D_E_L_E_T_                 = '' " 
    				cSql += "   AND SC2.C2_FILIAL                  = SC6.C6_FILIAL " 
    				cSql += "   AND SC2.C2_NUM					   = SC6.C6_NUMOP "
    				cSql += "   AND SC2.C2_ITEM                    = SC6.C6_ITEMOP "
  		    		cSql += "  JOIN SD3030 SD3 "    
            		cSql += "    ON SD3.D_E_L_E_T_                 = '' " 
            		cSql += "   AND SD3.D3_FILIAL                  = SC2.C2_FILIAL "
            		cSql += "   AND SD3.D3_OP                      = SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN "   
    				cSql += "   AND SD3.D3_ESTORNO                 = '' "
    				cSql += "   AND SD3.D3_GRUPO                   = 'BAND' "    
    				cSql += "  JOIN SG1030 SG1"
    				cSql += "    ON SG1.D_E_L_E_T_                 = '' "       			
    				cSql += "   AND SG1.G1_FILIAL                  = '' "     
    				cSql += "   AND SG1.G1_COD                     = SC2.C2_PRODUTO "
            		cSql += "   AND SG1.G1_COMP                    = SD3.D3_COD "                  
            		cSql += "   AND D3_EMISSAO BETWEEN SG1.G1_INI AND SG1.G1_FIM "
            		cSql += " WHERE SC6.D_E_L_E_T_                 = '' " 
    				cSql += "   AND SC6.C6_FILIAL                  = '" + xFilial("SC6") + "' " 
    				cSql += "   AND SC6.C6_NUM					   = '" + SD2->D2_PEDIDO + "' "
    				cSql += "   AND SC6.C6_ITEM                    = '" + SD2->D2_ITEMPV + "' "
                	cSql += " UNION "
 					cSql += "SELECT G1_XCSBI AS XCSBI "  
					cSql += "  FROM SC6030 SC6 " 
					cSql += "  JOIN SC2030 SC2 " 
					cSql += "    ON SC2.D_E_L_E_T_                 = '' " 
    				cSql += "   AND SC2.C2_FILIAL                  = SC6.C6_FILIAL " 
    				cSql += "   AND SC2.C2_NUM					   = SC6.C6_NUMOP "
    				cSql += "   AND SC2.C2_ITEM                    = SC6.C6_ITEMOP "
  		    		cSql += "  JOIN SZF030 SZF "    
            		cSql += "    ON SZF.D_E_L_E_T_                 = '' " 
            		cSql += "   AND SZF.ZF_FILIAL                  = SC2.C2_FILIAL "
            		cSql += "   AND SZF.ZF_NUMOP                   = SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN "   
					cSql += "  JOIN SB1030 SB1 "
					cSql += "    ON SB1.D_E_L_E_T_                 = '' "
					cSql += "   AND SB1.B1_FILIAL                  = '' "
					cSql += "   AND SB1.B1_COD                     = SZF.ZF_PRODSRV "
					cSql += "   AND SB1.B1_GRUPO                   = 'BAND' "
    				cSql += "  JOIN SG1030 SG1"
    				cSql += "    ON SG1.D_E_L_E_T_                 = '' "       			
    				cSql += "   AND SG1.G1_FILIAL                  = '' "     
    				cSql += "   AND SG1.G1_COD                     = SC2.C2_PRODUTO "
            		cSql += "   AND SG1.G1_COMP                    = SZF.ZF_PRODSRV "                  
            		cSql += "   AND SZF.ZF_DATA BETWEEN SG1.G1_INI AND SG1.G1_FIM "
            		cSql += " WHERE SC6.D_E_L_E_T_                 = '' " 
    				cSql += "   AND SC6.C6_FILIAL                  = '" + xFilial("SC6") + "' " 
    				cSql += "   AND SC6.C6_NUM					   = '" + SD2->D2_PEDIDO + "' "
    				cSql += "   AND SC6.C6_ITEM                    = '" + SD2->D2_ITEMPV + "' "
                	cSql += ") AS TAB34 "       
					cSql := ChangeQuery(cSql)                                               
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"ARQ_SQL",.F.,.T.)                            
					TcSetField("ARQ_SQL", "XCSBI", "N",14,2)
					GravCusto()
			case AllTrim(SD2->D2_GRUPO) $ "CI/SC"          
					cSql := "SELECT " + str(SD2->D2_QUANT) + " * G1_XCSBI AS XCSBI " 
  					cSql += "  FROM SB1030 SB1 "    
                    cSql += "  JOIN SG1030 SG1"
    				cSql += "    ON SG1.D_E_L_E_T_                 = '' "       			
    				cSql += "   AND SG1.G1_FILIAL                  = '' "     
    				cSql += "   AND SG1.G1_COD                     = 'MANC' "
            		cSql += "   AND SG1.G1_COMP                    = SB1.B1_PRODUTO  "                  
            		cSql += "   AND '" + DTOS(SD2->D2_EMISSAO) + "' BETWEEN SG1.G1_INI AND SG1.G1_FIM "
            		cSql += " WHERE SB1.D_E_L_E_T_                 = '' " 
            		cSql += "   AND SB1.B1_FILIAL                  = '" + xFilial("SB1") + "' "
            		cSql += "   AND SB1.B1_COD                     = '" + SD2->D2_COD + "' "   
            		cSql := ChangeQuery(cSql)                                               
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"ARQ_SQL",.F.,.T.)                            
					TcSetField("ARQ_SQL", "XCSBI", "N",14,4)
					GravCusto()
		Endcase
		dbSelectArea("SD2")
		dbSkip()	
	enddo 
	dbSelectArea("SD2")
	dbCloseArea("SD2")
Return nil                  

Static Function GravCusto() 
	dbSelectArea("ARQ_SQL")
	dbGoTop()      
    If ARQ_SQL->XCSBI > 0
       	dbSelectArea("SD2")   
        If RecLock("SD2",.F.)
    		SD2->D2_XCSBI := ARQ_SQL->XCSBI
      		MsUnLock()
       	EndIf       
       	dbSelectArea("SB1")
       	dbSetOrder(1)
       	dbSeek(xFilial("SB1")+SD2->D2_COD)
       	if found() .and. ARQ_SQL->XCSBI <> B1_XCSBI .and. Reclock("SB1",.F.)
       		SB1->B1_XCSBI := ARQ_SQL->XCSBI
       		MsUnLock()
       	endif
    Else
     	If len(alltrim(SD2->D2_COD))<5
     		dbSelectArea("SD2")
     		If RecLock("SD2",.F.)
    			SD2->D2_XCSBI := SD2->D2_TOTAL
       			MsUnLock()
       		EndIf
        Else
     		dbSelectArea("SB1")
       		dbSetOrder(1)
       		dbSeek("  "+SD2->D2_COD)
       		If found() .and. B1_XCSBI > 0
       			dbSelectArea("SD2")
       			If RecLock("SD2",.F.)
    				SD2->D2_XCSBI := SB1->B1_XCSBI
       				MsUnLock()
       			EndIf      
       		Else	
       			lImp:=.t.
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
					LI+=2
				endif
				Li++
				@Li,00       psay " NF:" + SD2->D2_DOC + "/" + SD2->D2_ITEM + ":" + SD2->D2_COD + SB1->B1_DESC + " PV:" + SD2->D2_PEDIDO + "/" + SD2->D2_ITEMPV + " Atenção! Lançar em SZF e Reprocessar" 
    			@Li,pcol()+1 psay SD2->D2_TOTAL
       		Endif
       	EndIf
    EndIf
    
    IF SD2->D2_XCSBI = 0
    	lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			LI+=2
		endif
		Li++
		@Li,00 psay " NF:" + SD2->D2_DOC + "/" + SD2->D2_ITEM + ":" + SD2->D2_COD +  SB1->B1_DESC + " PV:" + SD2->D2_PEDIDO + "/" + SD2->D2_ITEMPV 
    	@Li,pcol()+1 psay SD2->D2_TOTAL
    Endif  
    
    dbSelectArea("ARQ_SQL")
	dbCloseArea("ARQ_SQL")	
Return nil