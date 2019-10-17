#include "rwmake.ch"
#include "topconn.ch"

User Function DFATR82V2()

	Private cString
	Private aOrd 		:= {}
	Private CbTxt       := ""
	Private cDesc1      := "Relatorio de Mapa Diario de Faturamento "
	Private cDesc2      := ""
	Private cDesc3      := ""
	Private cPict       := ""
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 220
	Private tamanho     := "G"
	Private nomeprog    := "DFATR82V2"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private titulo      := "Mapa Diario de Faturamento Por vendedor"
	Private nLin        := 80
	Private nPag		:= 0
	Private Cabec1      := " "
	Private Cabec2      := " "
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private imprime     := .T.
	Private wnrel      	:= "DFATR82V2"
	Private _cPerg     	:= "DFAT06"
	Private cString 	:= "SF2"

	_aRegs:={}

	AAdd(_aRegs,{_cPerg,"01","Da  Data          ","Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"02","Ate Data          ","Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"03","Do  Produto       ","Do Produto"     ,"Do Produto"     ,"mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AAdd(_aRegs,{_cPerg,"04","Ate Produto       ","Ate Produto"    ,"Ate Produto"    ,"mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AAdd(_aRegs,{_cPerg,"05","Do  Cliente       ","Do Cliente"     ,"Do Cliente"     ,"mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CLI"})
	AAdd(_aRegs,{_cPerg,"06","Ate Cliente       ","Ate Cliente"    ,"Ate Data"       ,"mv_ch6","C", 6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CLI"})
	AAdd(_aRegs,{_cPerg,"07","Da  Loja          ","Da Loja"        ,"Da Loja"        ,"mv_ch7","C", 2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"08","Ate Loja          ","Ate Loja"       ,"Ate Loja"       ,"mv_ch8","C", 2,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"09","Do  Motorista     ","Do Vendedor"    ,"Do Vendedor"    ,"mv_ch9","C", 6,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"10","Ate Motorista     ","Ate Vendedor"   ,"Ate Vendedor"   ,"mv_cha","C", 6,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"11","Do  Vendedor      ","Do Vendedor"    ,"Do Vendedor"    ,"mv_chb","C", 6,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"12","Ate Vendedor      ","Ate Vendedor"   ,"Ate Vendedor"   ,"mv_chc","C", 6,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"13","Do  Indicador     ","Do Vendedor"    ,"Do Vendedor"    ,"mv_chd","C", 6,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"14","Ate indicador     ","Ate Vendedor"   ,"Ate Vendedor"   ,"mv_che","C", 6,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AAdd(_aRegs,{_cPerg,"15","Filial            ","Do Vendedor"    ,"Do Vendedor"    ,"mv_chf","C", 2,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"16","                  ","Ate Vendedor"   ,"Ate Vendedor"   ,"mv_chg","C", 2,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"17","Da Nota Saida     ","Da Nota Saida"  ,"Da Nota Saida"  ,"mv_chh","C", 6,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"18","Ate Nota Saida    ","Ate Nota Saida" ,"Ate Nota Saida" ,"mv_chi","C", 6,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"19","Coeficiente Liq.  ","Coeficiente Liq","Coeficiente Liq","mv_chj","N", 6,4,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"20","Agrupar           ","Agrupar"        ,"Agrupar"        ,"mv_chk","N", 1,0,0,"C","","mv_par20","Motorista","","","","","Vendendor","","","","","Indicador","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{_cPerg,"21","Sub-total         ","       "        ,"       "        ,"mv_chl","N", 1,0,0,"C","","mv_par21","Sim"      ,"","","","","Nao"      ,"","","","","         ","","","","","","","","","","","","","",""})

	ValidPerg(_aRegs,_cPerg)

	Pergunte(_cPerg,.F.)

	aOrd :={"Por Cod.Produto", "Por Cod.Cliente", "Por Nota Fiscal de Saida","Geral" }

	wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	Processa( {|| ImpRel() } )
Return

Static Function ImpRel()
	LOCAL _cQry

/*	LOCAL cCod       := cVar := cCodGen := ""
	LOCAL cCodVen    := cCodVen4 := cCodVen5 := ""
	LOCAL cCodCli    := ""
	LOCAL cNota      := ""
	LOCAL _aTam      := _aEstrutura := {}
	LOCAL nOrdem     := aReturn[8]
	LOCAL Titulo     := AllTrim(Titulo) + "  -  " + aOrd[nOrdem]
	LOCAL nTotVlr    := nVlrCons:= nTotCus := nTotDif  := nTtPneu  := nTtCons := nTotRec := 0
	LOCAL nTotTab    := nTotDes := nDescon := nDesconC := nNFReal  := TtNFReal:= 0
	LOCAL nGerVlr    := nGerCus := nGerDif :=	nGerTab  := nGerPneu := nGerCons:= nGerRec := 0
	LOCAL nQtGerCons := nGerDes := 0
	LOCAL cabec1     := "   Coeficiente : "+Alltrim(Str(mv_par19))+"                                                     Periodo de " + DtoC(mv_par01) + " a " + DtoC(mv_par02) + " "
	LOCAL cabec2     := "   Nota   Cod.Cliente Nome do Cliente                   Cod.Serviço         Desc.Serviço            Medida            Banda   Largura   Qtd.  Preco Tab.  DM%  Venda NF  Venda Liq.   Custo   Marg.Contr.  Markup   Coleta "
*/
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 
//                               1         2         3         4         5         6         7         8         9        10        11  

	_cQry := "SELECT (case when B1_TIPO = 'MO' then '1MO' else when B1_TIPO = 'ME' then '2ME' else when 'BN' then '9CA' else 'XOU' end) as TIPO " 
	_cQry += "     F2_DOC,    F2_SERIE,   F2_EMISSAO, F2_CLIENTE, F2_LOJA, "
	If mv_par20 = 1
		_cQry += " F2_VEND3 AS F2_VEND, "
	ElseIf mv_par20 = 2
		_cQry += " F2_VEND4 AS F2_VEND, "
	ElseIf mv_par20 = 3
		_cQry += " F2_VEND5 AS F2_VEND, "
	EndIf
	_cQry += "       D2_TIPO,    D2_COD,     D2_QUANT,   D2_TES,    D2_GRUPO,  D2_TOTAL, "
	_cQry += "       (D2_PRCVEN * " + str(mv_par19) + " - D2_XCSBI) AS MARGEM, "
	_cQry += "       D2_PEDIDO,  D2_ITEM,    D2_ITEMPV,  D2_PRCVEN, D2_PRUNIT, D2_XCSBI, "
	_cQry += "       C6_VALDESC, C6_NUMOP,   C6_ITEMOP, "
	_cQry += "       B1_DESC,    B1_XCSBI,   B1_TIPO, B1_PRODUTO "  
	_cQry += "       F4_DUPLIC, "
	_cQry += "       A1_NOME, "
	_cQry += "       A3_NOME "
	_cQry += " from " + RetSqlName("SF2") + " SF2 " 
	_cQry += " join " + RetSqlName("SD2") + " SD2 "
	_cQry += "  on SD2.D_E_L_E_T_ = ' ' "
	_cQry += " and D2_FILIAL      = '" + mv_par15 + "' "
	_cQry += " and D2_DOC         = F2_DOC "
	_cQry += " and D2_Serie       = F2_Serie "
	_cQry += " and D2_TES NOT IN ('556','594') "
	_cQry += " and D2_COD between '" + mv_par03 + "' and '" + mv_par04 + "' "
	If nOrdem = 4
		_cQry += " and D2_TES    <> '903' "
	EndIF                                     
	_cQry += "join " + RetSqlName("SF4") + " SF4 "
	_cQry += "  on SF4.D_E_L_E_T_ = '' "  
	_cQry += " and F4_FILIAL      = '' "
	_cQry += " and F4_CODIGO      = D2_TES  "
	_cQry += "join " + RetSqlName("SC6") + " SC6 "
	_cQry += "  on SC6.D_E_L_E_T_ = ' ' "
	_cQry += " and C6_Filial      = D2_Filial "
	_cQry += " and C6_NUM         = D2_PEDIDO "
	_cQry += " and C6_ITEM        = D2_ITEMPV "
	_cQry += "join " +  RetSqlName("SB1") + " SB1 "
	_cQry += "  on SB1.D_E_L_E_T_ = '' "
	_cQry += " and B1_FILIAL      = '" + xFilial("SB1") + "' "
	_cQry += " and B1_COD         = D2_COD "        
	_cQry += "join " +  RetSqlName("SA1") + " SA1  "
	_cQry += "  on SA1.D_E_L_E_T_ = '' "  
	_cQry += " and A1_FILIAL      = '' "
	_cQry += " and A1_COD         = F2_CLIENTE  "
	_cQry += " and A1_LOJA        = F2_LOJA  "
	_cQry += "left join " + RetSqlName("SA3") + " SA3 "
	_cQry += "  on SA3.D_E_L_E_T_ = '' "
	_cQry += " and SA3.A3_FILIAL  = '' "
	If mv_par20 = 1
		_cQry += " and SA3.A3_COD = SF2.F2_VEND3 "
	ElseIf mv_par20 = 2
		_cQry += " and SA3.A3_COD = SF2.F2_VEND4 "
	ElseIf mv_par20 = 3
		_cQry += " and SA3.A3_COD = SF2.F2_VEND5 "
	EndIf
	_cQry += "where SF2.D_E_L_E_T_ = ' ' "         
	_cQry += "  and F2_FILIAL = '"        + mv_par15       + "' "
	_cQry += "  and F2_EMISSAO between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' "
	_cQry += "  and F2_DOC     between '" + mv_par17       + "' and '" + mv_par18       + "' "
	_cQry += "  and F2_CLIENTE between '" + mv_par05       + "' and '" + mv_par06       + "' "
	_cQry += "  and F2_LOJA    between '" + mv_par07       + "' and '" + mv_par08       + "' "
	_cQry += "  and F2_TIPO = 'N' "
	If mv_par20 = 1
		_cQry += " AND F2_VEND3 <> ''"
		_cQry += " AND F2_VEND3 BETWEEN '"+mv_par09        + "' AND '" + mv_par10       + "'"
	Elseif mv_par20 = 2
		_cQry += " AND F2_VEND4 <> ''"
		_cQry += " AND F2_VEND4 BETWEEN '"+mv_par11        + "' AND '" + mv_par12       + "'"
	Elseif mv_par20 = 3
		_cQry += " AND F2_VEND5 <> ''"
		_cQry += " AND F2_VEND5 BETWEEN '"+mv_par13        + "' AND '" + mv_par14       + "'"
	Endif
	_cQry += " order by TIPO, "
	IF nOrdem = 1  //Por Produto
		_cQry += " D2_COD "
	ElseIF nOrdem = 2  //Por Cod.Cliente
		_cQry += " F2_CLIENTE "
	ElseIF nOrdem = 6  //Por Nota Fiscal de Saida
		_cQry += " F2_DOC "
	ElseIF nOrdem = 7  //Geral
		_cQry += " D2_GRUPO  "
	EndIF

	_cQry := ChangeQuery(_cQry)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRBFAT",.F.,.T.)

	dbSelectArea("TRBFAT")
	dbGoTop()

	ProcRegua(0)

	While ! Eof()              
	
	    quebra vendedor
	    
		If cChave <> TRBFAT->VEND
			DoCab1 ()
			cNotaSEPU   := TRBFAT->VEND
			aResumoSEPU := {}          
		Endif
		
       	quebra produto 
       
		If TRBFAT->D2_GRUPO == "CARC"    
		    nTtPneu  += 1  
			nGerPneu += 1
		EndIf
		
	   	If TRBFAT->D2_GRUPO == "CI  "
			nTtCons += 1
			nTtCons += 1
		EndIf	 				
		
		If TRBFAT->Tipo $ '1MO/2ME'
			DoLin()
			@ nLin, 003 Psay TRBFAT->D2_DOC+"/"+TRBFAT->D2_ITEM
			@ nLin, 013 Psay TRBFAT->F2_CLIENTE
			@ nLin, 023 Psay LEFT(Alltrim(TRBFAT->A1_NOME),30)
			@ nLin, 057 Psay TRBFAT->D2_COD
			@ nLin, 075 Psay LEFT(ALLTRIM(TRBFAT->B1_DESC),20)
			dbSelectArea("SB1")
			SemD3    := .f.                         
			xMedida  := ""
			xLargura := 0
			if TRBFAT->D2_GRUPO = "SERV"    
				cSql := "SELECT D3_COD, B1_LARG " 
  				cSql += "  FROM SD3030 SD3 "
    			cSql += "  JOIN SB1030 SB1 "
    			cSql += "    ON SB1.D_E_L_E_T_                 = '' "
    			cSql += "   AND SB1.B1_FILIAL                  = '" + xFilial("SB1") + "' "      
 				cSql += "   AND SB1.B1_COD                     = SD3.D3_COD "
    			cSql += " WHERE SD3.D_E_L_E_T_                 = '' "       			
    			cSql += "   AND SD3.D3_FILIAL                  = '" + xFilial("SD3") + "' "      
 				cSql += "   AND SD3.D3_OP                      = '" + TRBFAT->C6_NUMOP + TRBFAT->C6_ITEMOP + '001' +"' "   
    			cSql += "   AND SD3.D3_ESTORNO                 = '' "
    			cSql += "   AND SD3.D3_GRUPO                   = 'BAND' "    
           		cSql := ChangeQuery(cSql)                                               
				dbUseArea(.T.,"TOPCONN",TCGenQry(,,cSql),"ARQ_SQL",.F.,.T.)                            
				dbSelectArea("ARQ_SQL")
				dbGoTop()       
				SemD3    := iif(eof("ARQ_SQL"),.t.,.f.)
				xMedida  := ARQ_SQL->D3_COD
				xLargura := ARQ_SQL->B1_LARG
				dbCloseArea("ARQ_SQL")
			endif
			
            if TRBFAT->D2_GRUPO = "CI  "
				xMedida  := TRBFAT->B1_PRODUTO
			endif
			 
			@ nLin, 120 Psay xMedida
			 
			If xLargura > 0
				@ nLin, 130 Psay TRBFAT->Largura
	        Endif
			
			@ nLin, 136 Psay TRBFAT->D2_QUANT Picture "@E 999"
			
			IF TRBFAT->_TES == '903'
				@ nLin, 159 Psay "RECUSADO"
			Else
				If TRBFAT->D2_PRUNIT > 0  
					@ nLin, 141 Psay TRBFAT->D2_PRUNIT			               Picture "@E 99,999.99"
					@ nLin, 159 Psay TRBFAT->D2_TOTAL 			               Picture "@E 99,999.99" 
					@ nLin, 168 Psay TRBFAT->D2_TOTAL*mv_par19 	               Picture "@E 99,999.99" 
				Endif
				If TMP->TMP_CUSTD > 0
					@ nLin, 178 Psay TRBFAT->D2_XCSBI 			               Picture "@E 99,999.99" //Custo
				EndIf                                          
				
				@ nLin, 188 Psay TRBFAT->MARGEM                                Picture "@E 99,999.99" //margem
				
				@ nLin, 203 Psay (TRBFAT->D2_TOTAL * mv_par19) / TRBFAT->XCSBI Picture "@E 999.99"    //Markup
			Endif
			
			@ nLin, 213 Psay TRBFAT->C2_NUMOP+"/"+TRBFAT->C2_ITEMOP
			 
			
			IF TRBFAT->F4_DUPLIC = "S"
			/*      nTotVlr  += TRBFAT->D2_TOTAL 
					nGerVlr  += TRBFAT->D2_TOTAL 
					nDescon  += TRBFAT->D2_DESC 
					nDesconC += TRBFAT->D2_DESC 
					nNFReal  += TRBFAT->D2_TOTAL + TRBFAT->D2_DESC
					nNFReal  += TRBFAT->D2_TOTAL + TRBFAT->D2_DESC
				
					nTotCus  += TRBFAT->D2_XCSBI
					nTotDif  += TRBFAT->D2_TOTAL*mv_par19 - TRBFAT->D2_XCSBI
					nTotTab  += TRBFAT->D2_TOTAL
	
					nGerCus  += TRBFAT->D2_XCSBI
					nGerDif  += TRBFAT->D2_TOTAL*mv_par19 - TRBFAT->D2_XCSBI
					nGerTab  += TRBFAT->D2_TOTAL
			*/
			EndIF
			
			/*			
			TMP->TMP_PRECO   := IIF(TRBFAT->D2_TES=='903',0,TRBFAT->D2_TOTAL)  //IIF( cGrupo <> "ATEC",,TRBFAT->C6_PRCVEN) //D2_TOTAL+TRBFAT->D2_DESCON
			TMP->TMP_DESCO   := TRBFAT->D2_DESCON //TRBFAT->C6_VALDESC                   //IIF( cGrupo <> "ATEC",,0) //TRBFAT->D2_DESCON
			IF TMP->TMP_PRCTB > 0
				IF TMP->TMP_PRECO > TMP->TMP_PRCTB
					TMP->TMP_DM      :=Round(Abs(((TMP->TMP_PRECO/TMP->TMP_PRCTB)-1)*100),2)
				Else
					IF TMP->TMP_PRECO != 0.01
						TMP->TMP_DM      := Round((((TMP->TMP_PRECO/TMP->TMP_PRCTB)-1)*100)*-1,2)
					Else
						TMP->TMP_DM      :=Round(-9999,2)
					EndIF
				EndIF
			Else
				TMP->TMP_DM      := 0
			EndIF
			
			
			  	@ nLin, 150 Psay TMP->TMP_DM    				            Picture "@E 99999.99" //2
              */

		dbSelectArea("TRBFAT")
		TRBFAT->(dbSkip())
	EndDo

	dbSelectArea("TRBFAT")
	dbCloseArea()

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGotop()

    cChave := ""
	nLin := 99
	
	While ! Eof()
	
		
		IF nLin > 55
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF

		

			IF lEnd
				@ nLin, 001 Psay "Cancelado pelo operador "
				Exit
			EndIF

			IF nLin > 55
				nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
				nLin += 2
			EndIF
	
			IF nOrdem = 1 .and. TMP->TMP_COD != cCodGen
				nLin ++
				@ nLin, 003 Psay 'Faturamento do Produto : '+ TMP->TMP_COD+' -  '+TMP->TMP_DESC
				cCodGen := TMP->TMP_COD
				nLin := nLin + 2
			EndIF
			IF nOrdem = 2 .and. TMP->TMP_CLI != cCodGen
				nLin ++
				@ nLin, 003 Psay 'Faturamento do Cliente : '+ TMP->TMP_CLI + ' ' + TMP->TMP_NOME
				cCodGen := TMP->TMP_CLI
				nLin := nLin + 2
			EndIF
			IF nOrdem = 6 .and. TMP->TMP_DOC != cCodGen
				nLin ++
				@ nLin, 003 Psay 'Faturamento da Nota : ' + TMP->TMP_DOC
				cCodGen := TMP->TMP_DOC
				nLin := nLin + 2
			EndIF
	
			IF nOrdem = 7 .and. TMP->TMP_GRUPO != cCodGen
				IF Trim(TMP->TMP_GRUPO) != "CARC"
					nLin ++
					SBM->(dbSetOrder(1))
					SBM->(dbSeek(xFilial("SBM")+TMP->TMP_GRUPO ) )
					@ nLin, 003 Psay 'Faturamento do Grupo : ' + IIF(Trim(TMP->TMP_GRUPO) $ "CI/SC", "Conserto",Trim(SBM->BM_DESC) )
					cCodGen := TMP->TMP_GRUPO
					nLin := nLin + 2
				EndIF
			EndIF

		
			IF TMP->TMP_TES == '903' .and. ! Trim(TMP->TMP_GRUPO) $ "CI/SC"
				SC6->(dbSetOrder(1))
				SC6->(dbSeek(xFilial("SC6") + TMP->TMP_PED + TMP->TMP_ITEM ) )
	
				SC2->(dbSetOrder(1))
				SC2->(dbSeek(xFilial("SC2") + SC6->C6_NUMOP + SC6->C6_ITEMOP + "001" ) )
			EndIF 
	
			IF Trim(TMP->TMP_GRUPO) $ 'CI/SC'
				IF TMP->TMP_TES != '903'
					nTtCons     += TMP->TMP_QUANT
					nQtGerCons  += TMP->TMP_QUANT
				EndIF	
				IF TMP->TMP_DUPLIC = "S"
					nVlrCons   += TMP->TMP_PRECO
					nGerCons   += TMP->TMP_PRECO
				EndIF	
			EndIF
	
			if !(TMP->TMP_DOC+TMP->TMP_SERIE $ cNotaSEPU)
				cNotaSepu += TMP->TMP_DOC+TMP->TMP_SERIE+"*"
				cSqlSepu := ""
				cSqlSepu += " SELECT E1_MOTDESC,ZS_DESCR,SUM(E5_VALOR) AS VALOR"
				cSqlSepu += " FROM "+RetSqlName("SE5")+" SE5"

				cSqlSepu += " JOIN "+RetSqlName("SE1")+" SE1"
				cSqlSepu += " ON   SE1.D_E_L_E_T_ = ''"
				cSqlSepu += " AND  E1_FILIAL = E5_FILIAL"
				cSqlSepu += " AND  E1_PREFIXO = E5_PREFIXO"
				cSqlSepu += " AND  E1_NUM = E5_NUMERO"
				cSqlSepu += " AND  E1_PARCELA = E5_PARCELA"

				cSqlSepu += " LEFT JOIN "+RetSqlName("SZS")+" SZS"
				cSqlSepu += " ON   SZS.D_E_L_E_T_ = ''"
				cSqlSepu += " AND  ZS_FILIAL = '"+xFilial("SZS")+"'"
				cSqlSepu += " AND  ZS_COD = E1_MOTDESC"

				cSqlSepu += " WHERE SE5.D_E_L_E_T_ = ''"
				cSqlSepu += " AND   E5_FILIAL = '  '"
				cSqlSepu += " AND   E5_BANCO = 'SEP'"
				cSqlSepu += " AND   E5_AGENCIA = '00001'"
				cSqlSepu += " AND   E5_CONTA = '0000000001'"
				cSqlSepu += " AND   E5_NUMCHEQ = '"+AllTrim(TMP->TMP_SERIE)+"' || '"+AllTrim(TMP->TMP_DOC)+"'"
				cSqlSepu += " GROUP BY E1_MOTDESC,ZS_DESCR"
				cSqlSepu += " ORDER BY E1_MOTDESC"

				cSqlSepu := ChangeQuery(cSqlSepu)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSqlSepu),"ARQ_SEPU", .T., .T.)
				TcSetField("ARQ_SEPU","VALOR","N",14,2)
				
				dbSelectArea("ARQ_SEPU")
				dbGoTop()
				Do while !eof()
					nPos := aScan(aResumoSepu, { |x| AllTrim(x[1]) == AllTrim(ARQ_SEPU->E1_MOTDESC) })
					If nPos > 0
						aResumoSepu[nPos,3] += ARQ_SEPU->VALOR
					Else
						aadd(aResumoSepu,{ARQ_SEPU->E1_MOTDESC,ARQ_SEPU->ZS_DESCR,ARQ_SEPU->VALOR})
					Endif
					dbskip()
				Enddo
				dbSelectArea("ARQ_SEPU")
				dbCloseArea()
			Endif

			dbSelectArea("TMP")
			TMP->(dbSkip())
	
			IF nOrdem != 7
				cVar := IIF(nOrdem = 1,TMP_COD,IIF(nOrdem = 2,TMP->TMP_CLI,IIF(Alltrim(Str(nOrdem)) $ '3/4/5',TMP->TMP_VEND,;
				IIF(nOrdem = 5,TMP->TMP_VEND5,TMP->TMP_DOC))))
			ElseIF 	nOrdem == 7
				cVar := TMP->TMP_GRUPO		
			EndIF
	
			IF cVar != cCodGen  .or. eof() .or. TMP_VEND <> cChave // Totalizadores  bof() -->> eof()
				//IF cVar != "CARC" .and. (nOrdem == 7 .OR. nOrdem== 6)
				IF cCodGen != "CARC" .and. (nOrdem == 7 .OR. nOrdem== 6)
					IF nTotTab > 0
						IF nTotVlr > nTotTab
							nTotDes := Abs(((nTotVlr/nTotTab)-1)*100)
							nGerDes += Abs(((nTotVlr/nTotTab)-1)*100)
						Else
							nTotDes := (((nTotVlr/nTotTab)-1)*100)*-1
							nGerDes += (((nTotVlr/nTotTab)-1)*100)*-1
						EndIF
					Else
						nTotDes := 0
					EndIF
					nLin := nLin + 2
					@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)    Desc.Concedido                    Tt.NF Real   "
					@ nLin, 128 Psay "Preco Tab.     DM%      Total NF      Tt.Venda Liq.     Custo         Marg.Contr.  Markup "
					nLin ++
					@ nLin, 005 Psay nTtPneu
					@ nLin, 022 Psay nTtCons
					@ nLin, 039 Psay nVlrCons Picture "@E 99,999,999.99"
					@ nLin, 065 Psay nTotRec
					@ nLin, 077 Psay nDescon Picture "@E 99,999,999.99"
					@ nLin, 107 Psay nNFReal Picture "@E 99,999,999.99"
					@ nLin, 124 Psay nTotTab Picture "@E 99,999,999.99"          //Preco de Tabela
					@ nLin, 138 Psay nTotDes Picture "@E 9999.9999"              //Desconto Medio
					@ nLin, 147 Psay nTotVlr Picture "@E 99,999,999.99"          //Preco de venda
					@ nLin, 165 Psay nTotVlr*mv_par19 Picture "@E 99,999,999.99" //Tabela=Coeficiente
					@ nLin, 179 Psay nTotCus Picture "@E 9,999,999.99" //Custo
					@ nLin, 195 Psay nTotDif Picture "@E 9,999,999.99" //Diferenca
					@ nLin, 209 Psay (nTotVlr*mv_par19)/nTotCus Picture "@E 999.9999" //MarkUp
	
					nTotVlr := nTotCus := nTotDif := nTtPneu := nTotRec := nTtCons := nVlrCons := nTotTab := nDescon:= nNFReal :=0
	
					nLin ++
				EndIF
			EndIF
		Enddo
		

		nLin++
		IF nLin > 55
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF
		@nLin  ,001 PSAY "Resumo SEPU"
		@nLin+1,001 PSAY Replicate("-",68)
		nLin:=nLin+2

		nTotSepu := 0
		aResumoSepu := aSort(aResumoSepu,,, { |x, y| x[1] < y[1] })
		For k=1 to Len(aResumoSepu)
			IF nLin > 55
				nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
				nLin += 2
			EndIF
			@ nLin,001 PSAY aResumoSepu[k,1]+"-"+Subst(aResumoSepu[k,2],1,50)
			@ nLin,055 PSAY aResumoSepu[k,3] PICTURE "@E 999,999,999.99"
			nLin++
			nTotSepu += aResumoSepu[k,3]
		Next k
		nLin++
		@nLin,001 PSAY "Total Sepu"
		@nLin,055 PSAY nTotSepu PICTURE "@E 999,999,999.99"
		nLin+=2
	EndDo

	IF nLin != 80
		IF nLin > 55
			nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin += 2
		EndIF
		nLin ++
		@ nLin, 001 Psay "Total Geral: "

		nLin := nLin + 2

		IF nGerTab > 0
			IF nGerVlr > nGerTab  //nTotVlr > nTotTab
				nGerDes := Abs(((nGerVlr/nGerTab)-1)*100)
			Else
				nGerDes :=(((nGerVlr/nGerTab)-1)*100)*-1
			EndIF
		Else
			nGerDes := 0
		EndIF

		@ nLin, 003 Psay "Pneu(s)        Conserto(s)        Vlr.Conserto(s)         Recusado(s)    Desc.Concedido                    Tt.NF Real   "
		@ nLin, 128 Psay "Preco Tab.     DM%      Total NF      Tt.Venda Liq.     Custo         Marg.Contr.  Markup "
		nLin ++
		@ nLin, 005 Psay nGerPneu
		@ nLin, 022 Psay nQtGerCons
		@ nLin, 039 Psay nGerCons Picture "@E 99,999,999.99"
		@ nLin, 065 Psay nGerRec
		@ nLin, 077 Psay nDesconC Picture "@E 99,999,999.99"
		@ nLin, 107 Psay TtNFReal Picture "@E 99,999,999.99"
		@ nLin, 124 Psay nGerTab Picture "@E 99,999,999.99"          //Preco de Tabela
		@ nLin, 138 Psay nGerDes Picture "@E 9999.9999"              //Desconto Medio
		@ nLin, 147 Psay nGerVlr Picture "@E 99,999,999.99"          //Preco de venda
		@ nLin, 165 Psay nGerVlr*mv_par19 Picture "@E 99,999,999.99" //Tabela=Coeficiente
		@ nLin, 179 Psay nGerCus Picture "@E 9,999,999.99" //Custo
		@ nLin, 195 Psay nGerDif Picture "@E 9,999,999.99" //Diferenca
		@ nLin, 209 Psay (nGerVlr*mv_par19)/nGerCus Picture "@E 999.9999" //MarkUp
	
		Roda(cbcont,cbtxt,"G")
	EndIF

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomArq+GetDBExtension())
	fErase(cNomArq+OrdbagExt())

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	EndiF

	MS_FLUSH()
Return      
Static function DoCab()

	DoLin()
	DoLin()
	@ nLin,000 PSAY iif(mv_par20=1,"Motorista: ",iif(mv_par20=2,"Vendedor: ","Indicador: "))+TRBFAT->VEND+" - "+TRBFAT->A3_NOME
	DoLin()
	DoLin()
	
Return nil

Static function DoLin()
	
	if nLin > 55
		nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		nLin += 1
	Endif
	nLin += 1 
	
Return nil
