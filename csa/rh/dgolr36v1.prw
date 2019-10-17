
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR36V1 ()

	Private cString        := "SG1"
	Private aOrd           := {}
	Private cDesc1         := "CALCULAR CUSTO PARA RELATORIO"
	Private cDesc2         := "              "
	Private cDesc3         := "              "
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR36V1"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL36"
	Private titulo         := "SG1"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR36"
	Private lImp           := .F.
    Private xCusto         := 0.0
	dbSelectArea("ARQ_SB1")
	do while .not.eof()                   
		IF B1_GRUPO = 
	
	
		If RecLock("SB1",.T.)
							SG1->G1_REL :=FILIAL := ""
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
	
	If Aviso( "Pergunta", "Deseja Atualizar o Custo ?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
		AtuCusto()
	EndIf

	
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
	dbSeek(xFilial("SD2")+dtos(mv_par01))
	do while .not.eof() .and. SD2->d2_emissao >= mv_par01 .and. SD2->d2_emissao <= mv_par02  
		Do case
			case AllTrim(SD2->D2_GRUPO) = "SERV"   // RECAPAGEM       
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
			case AllTrim(SD2->D2_GRUPO) = "CI"          
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
       		dbSeek(xFilial("SB1")+SD2->D2_COD)
       		If found() .and. B1_XCSBI > 0
       			dbSelectArea("SD2")
       			If RecLock("SD2",.F.)
    				SD2->D2_XCSBI := ARQ_SQL->XCSBI
       				MsUnLock()
       			EndIf      
       		Else	
       			lImp:=.t.
				if li>55
					LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
					LI+=2
				endif
				Li++
				@Li,00 psay " NF:" + SD2->D2_DOC + "/" + SD2->D2_ITEM + ":" + SD2->D2_COD + " PV:" + SD2->D2_PEDIDO + "/" + SD2->D2_ITEMPV + " Atenção! Lançar em SZF e Reprocessar" 
       		Endif
       	EndIf
    EndIf
	dbSelectArea("ARQ_SQL")
	dbCloseArea("ARQ_SQL")        
Return nil