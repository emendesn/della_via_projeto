#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR89V3
	Private cString        := "SD2"
	Private aOrd           := {"Grupo","Data"}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Mapa Diário de Faturamento - Analitico"
	Private tamanho        := "G"
	Private nomeprog       := "DFATR89V3"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFAT89"
	Private titulo         := "Mapa Diário de Faturamento - Analitico"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR89V3"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da  Data ?"          ," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate Data ?"          ," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do  Cliente ? "      ," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate Cliente ?"       ," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA1","","","",""          })
	aAdd(aRegs,{cPerg,"05","Da Filial ?"         ," "," ","mv_ch5","C", 02,0,0,"G","","mv_par05",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"06","Ate Filial ?"        ," "," ","mv_ch6","C", 02,0,0,"G","","mv_par06",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"07","Da Nota Saida ?"     ," "," ","mv_ch7","C", 06,0,0,"G","","mv_par07",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"08","Ate Nota Saida ?"    ," "," ","mv_ch8","C", 06,0,0,"G","","mv_par08",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"09","Coeficiente Liq. ?"  ," "," ","mv_ch9","N", 06,4,0,"G","","mv_par09",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","","@e 9.9999" })
	aAdd(aRegs,{cPerg,"10","Quebra ?"            ," "," ","mv_cha","N", 01,0,0,"C","","mv_par10","Geral","","","","","Todos","","","","","Motorista","","","","","Vendedor","","","","","Indicador","","","",""   ,"","","",""          })
	aAdd(aRegs,{cPerg,"11","Do Vendedor ? "      ," "," ","mv_chb","C", 06,0,0,"G","","mv_par11",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"12","Ate o Vendedor ?"    ," "," ","mv_chc","C", 06,0,0,"G","","mv_par12",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA3","","","",""          })

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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
	Titulo := AllTrim(Titulo) + " De " + dtoc(mv_par01) + " até " + dtoc(mv_par02)
	Cabec1:=" Coeficiente : "+Alltrim(Str(mv_par09))
	Cabec2:=" Nota       Cliente                         Servico  Descrição do serviço            Medida           Banda            Larg.    Quant  Prc. Tabela   DM(%)    Venda NF  Venda Liq.      Custo    Mc Liq    Mkp    Mc Coml"
	        * XXXXXX/XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  99999  999,999   999,999.99  999.99  999,999.99  999,999.99 999,999.99 999,999.99 999.99 999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cRoda :=" Pneu(s)    Conserto(s)    Vlr.Conserto(s)    Recusado(s)    Desc.Concedido                  Tt.NF Real    Preco Tab.       DM%      Total NF    Tt.Venda Liq.         Custo    Marg.Liqui.    Mkp Lq     Marg.Coml   Mkp Cml"
	        *   9,999          9,999         999,999.99          9,999        999,999.99                  999,999.99    999,999.99    999.99    999,999.99       999,999.99    999,999.99     999,999.99    999.99    999,999.99    999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	cNotaSepu := ""
	aResumoSepu := {}

	cSql := ""
	cSql := cSql + " SELECT D2_DOC,D2_SERIE,D2_ITEM,D2_CLIENTE,D2_LOJA,D2_XCSBI "
	cSql := cSql + "       ,D2_PRUNIT,D2_QUANT,D2_TOTAL,D2_DESCON,D2_EMISSAO,D2_GRUPO,D2_TES,D2_COD "
	cSql := cSql + "       ,A1_NOME,B1_DESC,B1_X_GRUPO,B1_GRUPO,B1_X_DEPTO,B1_PRODUTO "
	cSql := cSql + "       ,C2_SEQUEN,C2_PRODUTO,C2_NUM,C2_ITEM,C7_TOTAL "
	cSql := cSql + "       ,F2_VEND3,F2_VEND4,F2_VEND5 "
	cSql := cSql + " FROM "+RetSqlName("SD2")+" SD2"

	cSql := cSql + " JOIN "+RetSqlName("SF4")+" SF4"
	cSql := cSql + " ON   SF4.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
	cSql := cSql + " AND  F4_CODIGO = D2_TES"
	cSql := cSql + " AND  F4_DUPLIC = 'S'"

	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql := cSql + " AND  B1_COD = D2_COD"
	cSql := cSql + " AND  (B1_X_DEPTO = 'S' OR B1_GRUPO IN('0001','0002','0003','BAND'))"

	cSql := cSql + " JOIN "+RetSqlName("SC6")+" SC6"
	cSql := cSql + " ON   SC6.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C6_FILIAL      = D2_FILIAL"
	cSql := cSql + " AND  C6_NUM         = D2_PEDIDO"
	cSql := cSql + " AND  C6_ITEM        = D2_ITEMPV"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SC2")+" SC2"
	cSql := cSql + " ON   SC2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C2_FILIAL      = D2_FILIAL"
	cSql := cSql + " AND  C2_NUM         = C6_NUMOP"
	cSql := cSql + " AND  C2_ITEM        = C6_ITEMOP"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SC1")+" SC1"
	cSql := cSql + " ON   SC1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C1_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  C1_OP = C2_NUM || C2_ITEM || C2_SEQUEN"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SC7")+" SC7"
	cSql := cSql + " ON   SC7.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C7_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  C7_NUM = C1_PEDIDO"
	cSql := cSql + " AND  C7_ITEM = C1_ITEMPED"

	cSql := cSql + " JOIN "+RetSqlName("SA1")+" SA1"
	cSql := cSql + " ON   SA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql := cSql + " AND  A1_COD = D2_CLIENTE"
	cSql := cSql + " AND  A1_LOJA = D2_LOJA"

	cSql := cSql + " JOIN "+RetSqlName("SF2")+" SF2"
	cSql := cSql + " ON   SF2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  F2_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  F2_DOC = D2_DOC"
	cSql := cSql + " AND  F2_SERIE = D2_SERIE"
	If mv_par10 > 2
		cSql += " and F2_VEND"+Str(mv_par10,1)+" BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
		cSql += " AND F2_VEND"+Str(mv_par10,1)+" <> ''"
	Elseif mv_par10 = 2
		cSql += " and (F2_VEND3 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
		cSql += " or   F2_VEND4 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
		cSql += " or   F2_VEND5 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"')"
	Endif

	cSql := cSql + " WHERE SD2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   D2_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql := cSql + " AND   D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   D2_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql := cSql + " AND   D2_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"

	//MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","D2_QUANT" ,"N",14,2)
	TcSetField("ARQ_SQL","D2_PRUNIT","N",14,2)
	TcSetField("ARQ_SQL","D2_TOTAL" ,"N",14,2)
	
	aEstru := {}
	aadd(aEstru,{"T_VEND"    ,"C",07,0})
	aadd(aEstru,{"T_CHAVE"   ,"C",15,0})
	aadd(aEstru,{"T_DOC"     ,"C",06,0})
	aadd(aEstru,{"T_SERIE"   ,"C",03,0})
	aadd(aEstru,{"T_ITEM"    ,"C",02,0})
	aadd(aEstru,{"T_NOME"    ,"C",30,0})
	aadd(aEstru,{"T_SERVICO" ,"C",05,0})
	aadd(aEstru,{"T_QUANT"   ,"N",06,0})
	aadd(aEstru,{"T_DESCSERV","C",30,0})
	aadd(aEstru,{"T_CARCACA" ,"C",15,0})
	aadd(aEstru,{"T_TES"     ,"C",03,0})
	aadd(aEstru,{"T_BANDA"   ,"C",15,0})
	aadd(aEstru,{"T_LARGURA" ,"N",05,0})
	aadd(aEstru,{"T_PRCTAB"  ,"N",14,2})
	aadd(aEstru,{"T_DESCON"  ,"N",14,2})
	aadd(aEstru,{"T_DM"      ,"N",10,2})
	aadd(aEstru,{"T_PRCVEN"  ,"N",14,2})
	aadd(aEstru,{"T_PRCLIQ"  ,"N",14,2})
	aadd(aEstru,{"T_CUSTO"   ,"N",14,2})
	aadd(aEstru,{"T_MARGEM"  ,"N",14,2})
	aadd(aEstru,{"T_MARKUP"  ,"N",06,2})
	aadd(aEstru,{"T_MCCOML"  ,"N",14,2})
	aadd(aEstru,{"T_GRUPO"   ,"C",04,0})
	aadd(aEstru,{"T_X_DEPTO" ,"C",01,0})
	aadd(aEstru,{"T_X_GRUPO" ,"C",01,0})

	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_VEND+T_CHAVE+Descend(StrZero(T_MCCOML,11,2))",,.t.,"Selecionando Registros...")
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbGoTop()
	
	If aReturn[8] = 1
		aChave := { {|| B1_GRUPO+B1_X_GRUPO} , {|| T_CHAVE} , "Faturamento do Grupo"}
	Else
		aChave := { {|| D2_EMISSAO} , {|| DTOC(STOD(T_CHAVE))} , "Faturamento do Dia"}
	Endif


			
	Do While !eof()
		if mv_par10 = 2
			nLoop := 3
		Else
			nLoop := 1
		Endif
		
		For k=1 to nLoop
			cVarVend := ""
			If mv_par10 = 2
				If Empty(FieldGet(FieldPos("F2_VEND"+Str(k+2,1)))) .OR. FieldGet(FieldPos("F2_VEND"+Str(k+2,1))) < mv_par11 .OR. FieldGet(FieldPos("F2_VEND"+Str(k+2,1))) > mv_par12
					Loop
				Endif
				cVarVend := Str(k+2,1)+FieldGet(FieldPos("F2_VEND"+Str(k+2,1)))
			Elseif mv_par10 > 2
				cVarVend := Str(mv_par10,1)+FieldGet(FieldPos("F2_VEND"+Str(mv_par10,1)))
			Endif

			Do while !RecLock("TMP",.T.)
			Enddo

			dbSelectArea("ARQ_SQL")
			TMP->T_VEND     := cVarVend
			TMP->T_CHAVE    := Eval(aChave[1])
			TMP->T_DOC      := D2_DOC
			TMP->T_SERIE    := D2_SERIE
			TMP->T_ITEM     := D2_ITEM
			TMP->T_NOME     := A1_NOME
			TMP->T_SERVICO  := D2_COD
			TMP->T_QUANT    := D2_QUANT
			TMP->T_DESCSERV := B1_DESC
			TMP->T_CARCACA  := C2_PRODUTO 
			IF EMPTY(TMP->T_CARCACA)
				TMP->T_CARCACA  := B1_PRODUTO
			ENDIF
			TMP->T_PRCTAB   := D2_TOTAL + D2_DESCON //iif(D2_PRUNIT<=0,D2_TOTAL+D2_DESCON,D2_PRUNIT*D2_QUANT)
			TMP->T_DESCON   := D2_DESCON
			TMP->T_PRCVEN   := D2_TOTAL
			TMP->T_DM       := (((TMP->T_PRCVEN/TMP->T_PRCTAB)-1)*100)*-1
			TMP->T_PRCLIQ   := TMP->T_PRCVEN * mv_par09
			TMP->T_TES      := D2_TES
			TMP->T_X_DEPTO  := B1_X_DEPTO
			TMP->T_X_GRUPO  := B1_X_GRUPO
			TMP->T_GRUPO    := B1_GRUPO
			
			If Upper(AllTrim(B1_X_GRUPO)) $ "RC"
				
			  	cSql := ""
				cSql := cSql + "SELECT D3_COD,D3_GRUPO,G1_XCSBI,B1_CUSTD"
				cSql := cSql + " FROM "+RetSqlName("SD3")+" SD3"

				cSql := cSql + " LEFT JOIN "+RetSqlName("SG1")+" SG1"
				cSql := cSql + " ON   SG1.D_E_L_E_T_ = ''"
				cSql := cSql + " AND  G1_COD = '"+C2_PRODUTO+"'"
				cSql := cSql + " AND  G1_COMP = D3_COD"
    			cSql := cSql + " AND  G1_INI >= D3_EMISSAO"
       			cSql := cSql + " AND  G1_FIM <= D3_EMISSAO"
                    
				cSql := cSql + " JOIN SB1030 SB1"
				cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
				cSql := cSql + " AND  B1_COD = D3_COD"

				cSql := cSql + " WHERE SD3.D_E_L_E_T_ = ''"
				cSql := cSql + " AND   D3_OP = '"+C2_NUM+C2_ITEM+C2_SEQUEN+"'"
				cSql := cSql + " AND   D3_ESTORNO <> 'S'"
				cSql := cSql + " AND   D3_GRUPO IN('BAND','MANC')"

				cSql := ChangeQuery(cSql)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_CST", .T., .T.)
				TcSetField("ARQ_CST","G1_XCSBI","N",14,2)
				dbSelectArea("ARQ_CST")
                
				Do While !eof()

					/*If ARQ_SQL->B1_X_GRUPO = "R"
						TMP->T_CUSTO += iif(D3_GRUPO="BAND",G1_XCSBI,0)  
						TMP->T_CUSTO += iif(D3_GRUPO="BAND",G1_XCSBI,0)
					Else
						TMP->T_CUSTO += iif(D3_GRUPO<>"BAND",B1_CUSTD,0)
					Endif 
					TMP->T_CUSTO += iif(D3_GRUPO="BAND",G1_XCSBI  
					
					If (D3_GRUPO = "BAND" .AND. ARQ_SQL->B1_X_GRUPO = "R") .OR. (D3_GRUPO = "MANC" .AND. ARQ_SQL->B1_X_GRUPO <> "R")
						TMP->T_BANDA    := D3_COD
						TMP->T_LARGURA  := Posicione("SB1",1,xFilial("SB1")+ARQ_CST->D3_COD,"B1_XLARG")
					Endif*/
					if Arq_Sql->D2_GRUPO = "SERV" .and. Arq_Cst->D3_GRUPO = 'BAND'
						TMP->T_BANDA   := D3_COD
						TMP->T_LARGURA := Posicione("SB1",1,xFilial("SB1")+D3_COD,"B1_XLARG")      
					endif                                                                          
					if alltrim(Arq_Sql->D2_GRUPO) $ "CI/SC" .and. alltrim(D3_GRUPO) = "MANC"
						TMP->T_BANDA   := D3_COD
					endif 
					dbSkip()
				Enddo
				dbCloseArea()
				dbSelectArea("ARQ_SQL")
				
				TMP->T_CUSTO   := ARQ_SQL->D2_XCSBI
			Endif

			
			If Upper(AllTrim(B1_X_GRUPO)) = "T"
				TMP->T_CUSTO += C7_TOTAL
			Endif

			TMP->T_MARGEM   := (TMP->T_PRCVEN * mv_par09) - TMP->T_CUSTO
			TMP->T_MARKUP   := (TMP->T_PRCVEN * mv_par09) / TMP->T_CUSTO

			TMP->T_MCCOML   := (TMP->T_PRCTAB * mv_par09) - TMP->T_CUSTO

			dbSelectArea("TMP")
			MsUnlock()
			dbSelectArea("ARQ_SQL")
		Next k

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbgoTop()

	/*
	1 - Pneus
	2 - Consertos
	3 - Vlr.Consertos
	4 - Recusados
	5 - Desc.Concedido
	6 - Tt.NF Real
	7 - Preco Tb.
	8 - Total NF
	9 - Custo
	*/

	Do While !eof()
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI+=2

		cVend := T_VEND
		aTotGer := {0,0,0,0,0,0,0,0,0}

		If mv_par10 > 1
			cNotaSepu := ""
			aResumoSepu := {}
			@ LI,001 PSAY iif(Substr(T_VEND,1,1)="3","Motorista: ",iif(Substr(T_VEND,1,1)="4","Vendedor: ","Indicador: "))+Substr(T_VEND,2,6)+" - "+Posicione("SA3",1,xFilial("SA3")+Substr(TMP->T_VEND,2,6),"SA3->A3_NOME")
			LI+=2
		Endif

		Do While !eof() .and. T_VEND = cVend
			lImp:=.t.
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif

			cChave := T_CHAVE
			aTotGrp :=  {0,0,0,0,0,0,0,0,0}

			If aReturn[8] = 1
				If Substr(TMP->T_CHAVE,5,1) $ "RT"
					@ LI,001 PSAY aChave[3]+" "+iif(Substr(TMP->T_CHAVE,5,1)="R","RECAPAGEM","RECAUCHUTAGEM")
				Else
					@ LI,001 PSAY aChave[3]+" "+Posicione("SBM",1,xFilial("SBM")+Substr(TMP->T_CHAVE,1,4),"BM_DESC")
				Endif
			Else
				@ LI,001 PSAY aChave[3]+" "+Eval(aChave[2])
			Endif

			LI+=2    
			IncProc("Imprimindo ...")
			Do While !eof() .and. T_CHAVE = cChave  .and. T_VEND = cVend

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
	
				@ LI,001 PSAY T_DOC+"/"+T_ITEM
				@ LI,012 PSAY T_NOME
				@ LI,044 PSAY T_SERVICO
				@ LI,053 PSAY T_DESCSERV
				@ LI,085 PSAY T_CARCACA
				cAlert := ""

				If Len(AllTrim(T_BANDA)) <= 0 .AND. Substr(TMP->T_CHAVE,5,1) $ "RC" .AND. T_TES <> "903"
					@ LI,102 PSAY "??????????"
					cAlert += "**"
				Else
					@ LI,102 PSAY T_BANDA
				Endif

				IF T_LARGURA > 0
					@ LI,119 PSAY T_LARGURA PICTURE "99999"
                ENDIF
                
				If T_CUSTO <= 0  .AND. Substr(TMP->T_CHAVE,5,1) $ "RC" .AND. T_TES <> "903"
					@ LI,179 PSAY "      ?,??"
					cAlert += "*"
				Else
					@ LI,179 PSAY T_CUSTO   PICTURE "@ze 999,999.99"
				Endif
				If T_TES $ "903*902"
					@ LI,140 PSAY "RECUSADO"
					aTotGrp[4] ++
				Else
					@ LI,126 PSAY T_QUANT   PICTURE "@e 999,999"
					@ LI,136 PSAY T_PRCTAB  PICTURE "@e 999,999.99"
					@ LI,148 PSAY T_DM      PICTURE "@e 999.99"
					@ LI,156 PSAY T_PRCVEN  PICTURE "@e 999,999.99"
					@ LI,168 PSAY T_PRCLIQ  PICTURE "@e 999,999.99"
					@ LI,190 PSAY T_MARGEM  PICTURE "@e 999,999.99"
					@ LI,201 PSAY T_MARKUP  PICTURE "@e 999.99"
					@ LI,208 PSAY T_MCCOML  PICTURE "@e 999,999.99"
					aTotGrp[1] += iif(AllTrim(TMP->T_X_GRUPO) $ "R",T_QUANT,0)
					aTotGrp[2] += iif(T_X_DEPTO = "S" .AND. T_X_GRUPO = "C",T_QUANT,0)
					aTotGrp[3] += iif(T_X_DEPTO = "S" .AND. T_X_GRUPO = "C",T_PRCVEN,0)
					aTotGrp[5] += T_DESCON
		 			aTotGrp[6] += T_PRCVEN
					aTotGrp[7] += T_PRCTAB
					aTotGrp[8] += T_PRCVEN
					aTotGrp[9] += T_CUSTO

					aTotGer[1] += iif(AllTrim(TMP->T_X_GRUPO) $ "R",T_QUANT,0)
					aTotGer[2] += iif(T_X_DEPTO = "S" .AND. T_X_GRUPO = "C",T_QUANT,0)
					aTotGer[3] += iif(T_X_DEPTO = "S" .AND. T_X_GRUPO = "C",T_PRCVEN,0)
					aTotGer[5] += T_DESCON
					aTotGer[6] += T_PRCVEN
					aTotGer[7] += T_PRCTAB
					aTotGer[8] += T_PRCVEN
					aTotGer[9] += T_CUSTO
				Endif
				@ LI,218 PSAY cAlert
				LI++

				if !(T_DOC+T_SERIE $ cNotaSEPU)
					cNotaSepu += T_DOC+T_SERIE+"*"
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
					cSqlSepu += " AND   E5_NUMCHEQ = '"+AllTrim(T_SERIE)+"' || '"+AllTrim(T_DOC)+"'"
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
				dbSkip()
			Enddo
			LI++
			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			endif
			@ LI,000 PSAY cRoda
			LI++
			@ LI,003 PSAY aTotGrp[1] PICTURE "@e 9,999"
			@ LI,018 PSAY aTotGrp[2] PICTURE "@e 9,999"
			@ LI,032 PSAY aTotGrp[3] PICTURE "@e 999,999.99"
			@ LI,052 PSAY aTotGrp[4] PICTURE "@e 9,999"
			@ LI,065 PSAY aTotGrp[5] PICTURE "@e 999,999.99"
			@ LI,093 PSAY aTotGrp[6] PICTURE "@e 999,999.99"
			@ LI,107 PSAY aTotGrp[7] PICTURE "@e 999,999.99"
			@ LI,121 PSAY (((aTotGrp[6]/aTotGrp[7])-1)*100)*-1 PICTURE "@e 999.99"
			@ LI,131 PSAY aTotGrp[8] PICTURE "@e 999,999.99"
			@ LI,148 PSAY aTotGrp[8]*mv_par09 PICTURE "@e 999,999.99"
			@ LI,162 PSAY aTotGrp[9] PICTURE "@e 999,999.99"
			@ LI,177 PSAY (aTotGrp[8] * mv_par09) - aTotGrp[9] PICTURE "@e 999,999.99"
			@ LI,191 PSAY (aTotGrp[8] * mv_par09) / aTotGrp[9] PICTURE "@e 999.99"
			@ LI,201 PSAY (aTotGrp[7] * mv_par09) - aTotGrp[9] PICTURE "@e 999,999.99"
			@ LI,215 PSAY (aTotGrp[7] * mv_par09) / aTotGrp[9] PICTURE "@e 999.99"
			LI+=3
		Enddo

		Li:=Li+2
		@ Li,001 PSAY "Resumo SEPU"
		@ Li+1,001 PSAY Replicate("-",68)
		Li:=Li+2

		nTotSepu := 0
		aResumoSepu := aSort(aResumoSepu,,, { |x, y| x[1] < y[1] })
		For k=1 to Len(aResumoSepu)
			IF LI > 55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI+=2
			EndIF
			@ LI,001 PSAY aResumoSepu[k,1]+"-"+Subst(aResumoSepu[k,2],1,50)
			@ LI,055 PSAY aResumoSepu[k,3] PICTURE "@E 999,999,999.99"
			LI++
			nTotSepu += aResumoSepu[k,3]
		Next k
		LI++
		@LI,001 PSAY "Total Sepu"
		@LI,055 PSAY nTotSepu PICTURE "@E 999,999,999.99"
		LI+=3

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif

		@ LI,000 PSAY cRoda
		LI++
		@ LI,003 PSAY aTotGer[1] PICTURE "@e 9,999"
		@ LI,018 PSAY aTotGer[2] PICTURE "@e 9,999"
		@ LI,032 PSAY aTotGer[3] PICTURE "@e 999,999.99"
		@ LI,052 PSAY aTotGer[4] PICTURE "@e 9,999"
		@ LI,065 PSAY aTotGer[5] PICTURE "@e 999,999.99"
		@ LI,093 PSAY aTotGer[6] PICTURE "@e 999,999.99"
		@ LI,107 PSAY aTotGer[7] PICTURE "@e 999,999.99"
		@ LI,121 PSAY (((aTotGer[6]/aTotGer[7])-1)*100)*-1 PICTURE "@e 999.99"
		@ LI,131 PSAY aTotGer[8] PICTURE "@e 999,999.99"
		@ LI,148 PSAY aTotGer[8]*mv_par09 PICTURE "@e 999,999.99"
		@ LI,162 PSAY aTotGer[9] PICTURE "@e 999,999.99"
		@ LI,177 PSAY (aTotGer[8] * mv_par09) - aTotGer[9] PICTURE "@e 999,999.99"
		@ LI,191 PSAY (aTotGer[8] * mv_par09) / aTotGer[9] PICTURE "@e 999.99"
		@ LI,201 PSAY (aTotGer[7] * mv_par09) - aTotGer[9] PICTURE "@e 999,999.99"
		@ LI,215 PSAY (aTotGer[7] * mv_par09) / aTotGer[9] PICTURE "@e 999.99"
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil