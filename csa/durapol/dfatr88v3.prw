#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)
#Define nDescReca 1
#Define nDescServ 2
#Define nDescAtec 3
#Define nDescNovo 4
#Define nDescOutr 5

User Function DFATR88V3
	Private cString        := ""
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Mapa Diario de Faturamento - Sintético"
	Private tamanho        := "G"
	Private nomeprog       := "DFATR88V3"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFAT88"
	Private titulo         := "Mapa Diario de Faturamento - Sintético"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR88V3"
	Private lImp           := .f.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Da  Data ?"          ,"","","mv_ch1","D", 8,0,0,"G","","mv_par01",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate Data ?"          ,"","","mv_ch2","D", 8,0,0,"G","","mv_par02",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Coeficiente Liq.?"   ,"","","mv_ch3","N", 6,4,0,"G","","mv_par03",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Custo Fixo ?"        ,"","","mv_ch4","N",17,2,0,"G","","mv_par04",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Quebra ?"            ,"","","mv_ch5","N",01,0,0,"C","","mv_par05","Geral","","","","","Todos","","","","","Motorista","","","","","Vendedor","","","","","Indicador","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"06","Do Vendedor ? "      ,"","","mv_ch6","C",06,0,0,"G","","mv_par06",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA3","","","",""          })
	aAdd(aRegs,{cPerg,"07","Ate o Vendedor ?"    ,"","","mv_ch7","C",06,0,0,"G","","mv_par07",""     ,"","","","",""     ,"","","","",""         ,"","","","",""        ,"","","","",""         ,"","","","SA3","","","",""          })

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
	Cabec1:="             Faturamento                     Faturamento                           Custo                           Custo                      Assitencia                                      (%)          Margem"
	Cabec2:="Data               Bruto       Descontos         Liquido       Recapagem       Recapagem   Recauchutagem   Recauchutagem        Serviços         Tecnica       Mercantil          Outros   Margem    Contribuição     Pneus"
	        *99/99/99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   999,99   99,999,999.99   999,999
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	aResumoSepu  := {}
	aResumoPneus := {}
	aResumoDesc  := {}

	cSql := ""
	cSql := cSql + "SELECT D2_FILIAL,D2_EMISSAO,D2_TOTAL,D2_DESCON,D2_QUANT,D2_TES,D2_DOC,D2_SERIE,D2_XCSBI, "
	cSql := cSql + "       F4_DUPLIC,F4_ESTOQUE, "
	cSql := cSql + "       B1_GRUPO,B1_X_ESPEC,B1_X_GRUPO,B1_X_DEPTO, "
	cSql := cSql + "       C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_MOTREJE, "
	cSql := cSql + "       C7_TOTAL, "
	cSql := cSql + "       C6_NUM,C6_FILIAL, "
	cSql := cSql + "       F2_VEND3,F2_VEND4,F2_VEND5"
	cSql := cSql + " FROM "+RetSqlName("SD2")+" SD2"
	cSql := cSql + " JOIN "+RetSqlName("SF4")+" SF4"
	cSql := cSql + " ON   SF4.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
	cSql := cSql + " AND  F4_CODIGO = D2_TES"
	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql := cSql + " AND  B1_COD = D2_COD"
	cSql := cSql + " JOIN "+RetSqlName("SC6")+" SC6"
	cSql := cSql + " ON   SC6.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C6_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  C6_NUM = D2_PEDIDO"
	cSql := cSql + " AND  C6_ITEM = D2_ITEMPV"
	cSql := cSql + " LEFT JOIN "+RetSqlName("SC2")+" SC2"
	cSql := cSql + " ON   SC2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C2_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  C2_NUM = C6_NUMOP"
	cSql := cSql + " AND  C2_ITEM = C6_ITEMOP"
	cSql := cSql + " LEFT JOIN "+RetSqlName("SC1")+" SC1"
	cSql := cSql + " ON   SC1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C1_FILIAL = C2_FILIAL"
	cSql := cSql + " AND  C1_OP = C2_NUM || C2_ITEM || C2_SEQUEN"
	cSql := cSql + " LEFT JOIN "+RetSqlName("SC7")+" SC7"
	cSql := cSql + " ON   SC7.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C7_FILIAL = C1_FILIAL"
	cSql := cSql + " AND  C7_NUM = C1_PEDIDO"
	cSql := cSql + " AND  C7_ITEM = C1_ITEMPED"
	cSql := cSql + " JOIN "+RetSqlName("SF2")+" SF2"
	cSql := cSql + " ON   SF2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  F2_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  F2_DOC = D2_DOC"
	cSql := cSql + " AND  F2_SERIE = D2_SERIE"
	If mv_par05 > 2
		cSql += " and F2_VEND"+Str(mv_par05,1)+" BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
		cSql += " AND F2_VEND"+Str(mv_par05,1)+" <> ''"
	Elseif mv_par05 = 2
		cSql += " and (F2_VEND3 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
		cSql += " or   F2_VEND4 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
		cSql += " or   F2_VEND5 BETWEEN '"+mv_par06+"' AND '"+mv_par07+"')"
	Endif
	cSql := cSql + " WHERE SD2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   D2_FILIAL = '"+xFilial("SD2")+"'"
	cSql := cSql + " AND   D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   D2_TIPO = 'N'"
	cSql := cSql + " AND   D2_TES NOT IN('903','902')"
	cSql := cSql + " ORDER BY D2_FILIAL,D2_DOC,D2_ITEM"
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","D2_EMISSAO","D")
	TcSetField("ARQ_SQL","D2_TOTAL"  ,"N",14,2)
	TcSetField("ARQ_SQL","D2_QUANT"  ,"N",14,2)
	TcSetField("ARQ_SQL","D2_DESCON" ,"N",14,2)
	TcSetField("ARQ_SQL","C7_TOTAL"  ,"N",14,2)
	
	aEstru := {}
	aadd(aEstru,{"T_VEND"   ,"C",07,0})
	aadd(aEstru,{"T_EMISSAO","D",08,0})
	aadd(aEstru,{"T_FATBRU" ,"N",14,2})
	aadd(aEstru,{"T_FATLIQ" ,"N",14,2})
	aadd(aEstru,{"T_DESCONT","N",14,2})
	aadd(aEstru,{"T_RECAPA" ,"N",14,2})
	aadd(aEstru,{"T_RECLIQ" ,"N",14,2})
	aadd(aEstru,{"T_CSTREC" ,"N",14,2})
	aadd(aEstru,{"T_RECAUC" ,"N",14,2})
	aadd(aEstru,{"T_CSTRCH" ,"N",14,2})
	aadd(aEstru,{"T_SERVICO","N",14,2})
	aadd(aEstru,{"T_ASSTEC" ,"N",14,2})
	aadd(aEstru,{"T_MERCANT","N",14,2})
	aadd(aEstru,{"T_OUTROS" ,"N",14,2})
	aadd(aEstru,{"T_PNEUS"  ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_VEND+DTOS(T_EMISSAO)",,.t.,"Selecionando Registros...")

	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	Do While !eof()
		if mv_par05 = 2
			nLoop := 3
		Else
			nLoop := 1
		Endif

		For k=1 to nLoop
			cVarVend := Space(7)
			If mv_par05 = 2
				If Empty(FieldGet(FieldPos("F2_VEND"+Str(k+2,1)))) .OR. FieldGet(FieldPos("F2_VEND"+Str(k+2,1))) < mv_par06 .OR. FieldGet(FieldPos("F2_VEND"+Str(k+2,1))) > mv_par07
					Loop
				Endif
				cVarVend := Str(k+2,1)+FieldGet(FieldPos("F2_VEND"+Str(k+2,1)))
			Elseif mv_par05 > 2
				cVarVend := Str(mv_par05,1)+FieldGet(FieldPos("F2_VEND"+Str(mv_par05,1)))
			Endif
		
			dbSelectArea("TMP")
			lAppend := !dbSeek(cVarVend+dtos(ARQ_SQL->D2_EMISSAO),.F.)

			Do while !RecLock("TMP",lAppend)
			Enddo

			dbSelectArea("ARQ_SQL")
			TMP->T_VEND    := cVarVend
			TMP->T_EMISSAO := D2_EMISSAO
//				incProc("Montando Temporário ...")
				lFatura := ( !(Upper(AllTrim(B1_GRUPO)) = "CARC") .AND. F4_DUPLIC = "S")
				lRecapa := (Upper(AllTrim(B1_GRUPO)) = "SERV" .AND. F4_ESTOQUE = "N"  .AND. B1_X_GRUPO = "R" .AND. F4_DUPLIC = "S")
				lRecauc := (Upper(AllTrim(B1_GRUPO)) $ "SERV" .AND. F4_ESTOQUE = "N"  .AND. B1_X_GRUPO = "T" .AND. F4_DUPLIC = "S")
				lServic := (Upper(AllTrim(B1_GRUPO)) $ GetMv("MV_X_GRPRO",.F.,"CI  /SC  ") .AND. F4_ESTOQUE = "N" .AND. F4_DUPLIC = "S")
				lAssTec := (Upper(AllTrim(B1_GRUPO)) $ "ATEC" .AND. F4_DUPLIC = "S")
				lNovo   := ((Upper(AllTrim(B1_GRUPO)) $ "0001/0002/0003/BAND" .or. SD2->D2_TES $ "503*506") .AND. F4_DUPLIC = "S")
				lOutros := (!lRecapa .AND. !lRecauc .AND. !lServic .AND. !lAssTec .AND. !lNovo .AND. F4_DUPLIC = "S")

				nPosDesc := AScan(aResumoDesc,{|x| x[1] == cVarVend })
				If nPosDesc <= 0
					aAdd(aResumoDesc,{cVarVend,{0,0,0,0,0}})
					nPosDesc := Len(aResumoDesc)
				Endif

				aResumoDesc[nPosDesc,2,nDescReca] += iif(lRecapa .or. lRecauc,D2_DESCON,0)
				aResumoDesc[nPosDesc,2,nDescServ] += iif(lServic,D2_DESCON,0)
				aResumoDesc[nPosDesc,2,nDescAtec] += iif(lAssTec,D2_DESCON,0)
				aResumoDesc[nPosDesc,2,nDescNovo] += iif(lNovo  ,D2_DESCON,0)
				aResumoDesc[nPosDesc,2,nDescOutr] += iif(lOutros,D2_DESCON,0)

				TMP->T_FATBRU  += iif(lFatura,ARQ_SQL->(D2_TOTAL+D2_DESCON),0)
				TMP->T_FATLIQ  += iif(lFatura,ARQ_SQL->D2_TOTAL,0)
				TMP->T_DESCONT += iif(lFatura .OR. lRecapa .OR. lRecauc .OR. lServic .OR. lAsstec .OR. lNovo .OR. lOutros,ARQ_SQL->D2_DESCON,0)
				TMP->T_RECAPA  += iif(lRecapa,ARQ_SQL->(D2_TOTAL+D2_DESCON),0)
				TMP->T_RECLIQ  += iif(lRecapa,ARQ_SQL->(D2_TOTAL),0)
				TMP->T_RECAUC  += iif(lRecauc,ARQ_SQL->(D2_TOTAL+D2_DESCON),0)
				TMP->T_SERVICO += iif(lServic,ARQ_SQL->(D2_TOTAL+D2_DESCON),0)
				TMP->T_ASSTEC  += iif(lAssTec,ARQ_SQL->(D2_TOTAL+D2_DESCON),0)
				TMP->T_MERCANT += iif(lNovo  ,ARQ_SQL->(D2_TOTAL+D2_DESCON),0)
				TMP->T_OUTROS  += iif(lOutros,ARQ_SQL->(D2_TOTAL+D2_DESCON),0)
				TMP->T_PNEUS   += iif(lRecapa,ARQ_SQL->D2_QUANT,0)
			
				If lRecapa
				/*	cSql := ""
					cSql := cSql + "SELECT D3_GRUPO,G1_XCSBI,B1_CUSTD"
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

					dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_CST", .T., .T.)
					TcSetField("ARQ_CST","G1_XCSBI","N",14,2)
					dbSelectArea("ARQ_CST")
					//incProc("Montando Temporário ...")
					Do While !eof()
						TMP->T_CSTREC += iif(D3_GRUPO="BAND",G1_XCSBI,0)  // B1_CUSTD
						dbSkip()
					Enddo
					dbCloseArea()
					dbSelectArea("ARQ_SQL")
					*/
					TMP->T_CSTREC += D2_XCSBI
				Endif
			
				If lRecauc
					TMP->T_CSTRCH += C7_TOTAL
				Endif
			
				If lRecapa
					nPosPVend := AScan(aResumoPneus,{|x| x[1] == cVarVend })
					If nPosPVend <= 0
						aAdd(aResumoPneus,{cVarVend,{}})
						nPosPVend := Len(aResumoPneus)
					Endif

					cEsp := Posicione("SB1",1,xFilial("SB1")+ARQ_SQL->C2_PRODUTO,"SB1->B1_X_ESPEC")
					nPosPneu := AScan(aResumoPneus[nPosPVend,2],{|x| x[1] == cEsp })
					If nPosPneu <= 0
						AAdd(aResumoPneus[nPosPVend,2],{cEsp,D2_QUANT,D2_TOTAL+D2_DESCON})
					Else			
						aResumoPneus[nPosPVend,2,nPosPneu,2] += D2_QUANT
						aResumoPneus[nPosPVend,2,nPosPneu,3] += D2_TOTAL+D2_DESCON
					Endif
				Endif

				nPosSVend := AScan(aResumoSepu,{|x| x[1] == cVarVend })
				If nPosSVend <= 0
					aAdd(aResumoSepu,{cVarVend,"",{}})
					nPosSVend := Len(aResumoSepu)
				Endif

				if !(D2_DOC+D2_SERIE $ aResumoSepu[nPosSVend,2])
					aResumoSepu[nPosSVend,2] += D2_DOC+D2_SERIE+"*"
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
					cSqlSepu += " AND   E5_NUMCHEQ = '"+AllTrim(D2_SERIE)+"' || '"+AllTrim(D2_DOC)+"'"
					cSqlSepu += " GROUP BY E1_MOTDESC,ZS_DESCR"
					cSqlSepu += " ORDER BY E1_MOTDESC"

					cSqlSepu := ChangeQuery(cSqlSepu)
					dbUseArea(.T., "TOPCONN", TCGenQry(,,cSqlSepu),"ARQ_SEPU", .T., .T.)
					TcSetField("ARQ_SEPU","VALOR","N",14,2)
				
					dbSelectArea("ARQ_SEPU")
					dbGoTop()
					Do while !eof()
						nPos := aScan(aResumoSepu[nPosSVend,3], { |x| AllTrim(x[1]) == AllTrim(ARQ_SEPU->E1_MOTDESC) })
						If nPos > 0
							aResumoSepu[nPosSVend,3,nPos,3] += ARQ_SEPU->VALOR
						Else
							aadd(aResumoSepu[nPosSVend,3],{ARQ_SEPU->E1_MOTDESC,ARQ_SEPU->ZS_DESCR,ARQ_SEPU->VALOR})
						Endif
						dbskip()
					Enddo
					dbSelectArea("ARQ_SEPU")
					dbCloseArea()
					dbSelectArea("ARQ_SQL")
				Endif

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

	Do While !eof()
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI+=2

		aTotais:= {0,0,0,0,0,0,0,0,0,0,0,0}
		nRecapLiq := 0
		nMCLiq := 0
		nMCCml := 0
		cVend := T_VEND

		If mv_par05 > 1
			@ LI,000 PSAY iif(Substr(T_VEND,1,1)="3","Motorista: ",iif(Substr(T_VEND,1,1)="4","Vendedor: ","Indicador: "))+Substr(T_VEND,2,6)+" - "+Posicione("SA3",1,xFilial("SA3")+Substr(TMP->T_VEND,2,6),"SA3->A3_NOME")
			LI+=2
		Endif
		IncProc("Imprimindo ... Aguarda")
		Do While !eof() .and. T_VEND = cVend

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
	
			@ LI,000 PSAY T_EMISSAO
			@ LI,011 PSAY T_FATBRU  PICTURE "@e 99,999,999.99"
			@ LI,027 PSAY T_DESCONT PICTURE "@e 99,999,999.99"
			@ LI,043 PSAY T_FATLIQ  PICTURE "@e 99,999,999.99"
			@ LI,059 PSAY T_RECAPA  PICTURE "@e 99,999,999.99"
			@ LI,075 PSAY T_CSTREC  PICTURE "@e 99,999,999.99"
			@ LI,091 PSAY T_RECAUC  PICTURE "@e 99,999,999.99"
			@ LI,107 PSAY T_CSTRCH  PICTURE "@e 99,999,999.99"
			@ LI,123 PSAY T_SERVICO PICTURE "@e 99,999,999.99"
			@ LI,139 PSAY T_ASSTEC  PICTURE "@e 99,999,999.99"
			@ LI,155 PSAY T_MERCANT PICTURE "@e 99,999,999.99"
			@ LI,171 PSAY T_OUTROS  PICTURE "@e 99,999,999.99"
			@ LI,187 PSAY (T_RECLIQ * mv_par03) / T_CSTREC PICTURE "@e 999.99"
			@ LI,196 PSAY (T_RECLIQ * mv_par03) - T_CSTREC PICTURE "@e 99,999,999.99"
			@ LI,212 PSAY T_PNEUS   PICTURE "@e 999,999"
			aTotais[1] += T_FATBRU
			aTotais[2] += T_DESCONT
			aTotais[3] += T_FATLIQ
			aTotais[4] += T_RECAPA
			aTotais[5] += T_CSTREC
			aTotais[6] += T_RECAUC
			aTotais[7] += T_CSTRCH
			aTotais[8] += T_SERVICO
			aTotais[9] += T_ASSTEC
			aTotais[10] += T_MERCANT
			aTotais[11] += T_OUTROS
			aTotais[12] += T_PNEUS
			nRecapLiq += T_RECLIQ
			nMCLiq += (T_RECLIQ * mv_par03) - T_CSTREC
			nMCCml += (T_RECAPA * mv_par03) - T_CSTREC
			LI++
			dbSkip()
		Enddo

		Li++
		@ LI,000 PSAY Replicate("-",220)
		LI++
		@ LI,011 PSAY aTotais[1] PICTURE "@e 99,999,999.99"
		@ LI,027 PSAY aTotais[2] PICTURE "@e 99,999,999.99"
		@ LI,043 PSAY aTotais[3] PICTURE "@e 99,999,999.99"
		@ LI,059 PSAY aTotais[4] PICTURE "@e 99,999,999.99"
		@ LI,075 PSAY aTotais[5] PICTURE "@e 99,999,999.99"
		@ LI,091 PSAY aTotais[6] PICTURE "@e 99,999,999.99"
		@ LI,107 PSAY aTotais[7] PICTURE "@e 99,999,999.99"
		@ LI,123 PSAY aTotais[8] PICTURE "@e 99,999,999.99"
		@ LI,139 PSAY aTotais[9] PICTURE "@e 99,999,999.99"
		@ LI,155 PSAY aTotais[10] PICTURE "@e 99,999,999.99"
		@ LI,171 PSAY aTotais[11] PICTURE "@e 99,999,999.99"
		@ LI,187 PSAY (nRecapLiq * mv_par03) / aTotais[5] PICTURE "@e 999.99"
		@ LI,196 PSAY nMCLiq      PICTURE "@e 99,999,999.99"
		@ LI,212 PSAY aTotais[12] PICTURE "@e 999,999"
		li++
		@ LI,160 PSAY "Mc Comercial"
		@ LI,187 PSAY (aTotais[4] * mv_par03) / aTotais[5] PICTURE "@e 999.99"
		@ LI,196 PSAY (aTotais[4] * mv_par03) - aTotais[5] PICTURE "@e 99,999,999.99"
		LI+=2

		@LI,001 PSAY "CF"
		@LI,004 PSAY mv_par04  PICTURE "@E 9,999,999.99"
		@LI,018 PSAY "MC LIQ:"
		@LI,026 PSAY nMCLiq PICTURE "@E 9999,999.99"
		@LI,039 PSAY "PRECO MEDIO:"
		@LI,052 PSAY aTotais[4] / aTotais[12] PICTURE "@E 9999.99"
		@LI,063 PSAY "MARGEM MEDIA:"
		@LI,077 PSAY nMCLiq / aTotais[12] PICTURE "@E 9999.99"


		Li:=Li+2
		@LI  ,001 PSAY "Distribuicao de Pneus"
		@LI+1,001 PSAY "Tam.         Qtd            Total        Media"
		@LI+2,001 PSAY "----------------------------------------------"
		LI:=LI+3
		nPosPVend := AScan(aResumoPneus,{|x| x[1] == cVend })
		If nPosPVend > 0
			For i:=1 To Len(aResumoPneus[nPosPVend,2])
				If LI > 55
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					LI := 9
				Endif
				@LI,001 PSAY IIF( Empty(aResumoPneus[nPosPVend,2,i,1]) , "Indefinido" , Substr(aResumoPneus[nPosPVend,2,i,1],1,15) ) 
				@LI,012 PSAY aResumoPneus[nPosPVend,2,i,2] PICTURE "99999"
				@LI,024 PSAY aResumoPneus[nPosPVend,2,i,3] PICTURE "@e 999,999.99"
				@LI,037 PSAY aResumoPneus[nPosPVend,2,i,3]/aResumoPneus[nPosPVend,2,i,2] PICTURE "@e 999,999.99"
				LI++
			Next
		Endif

		Li:=Li+2
		@ Li,001 PSAY "Resumo SEPU"
		@ Li+1,001 PSAY Replicate("-",68)
		Li:=Li+2

		nTotSepu := 0
		For k=1 To Len(aResumoSepu)
			aResumoSepu[k,3] := aSort(aResumoSepu[k,3],,, { |x, y| x[1] < y[1] })
		Next

		nPosSVend := AScan(aResumoSepu,{|x| x[1] == cVend })
        if nPosSVend > 0
			For k=1 to Len(aResumoSepu[nPosSVend,3])
				IF LI > 55
					LI := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
					LI += 2
				EndIF
				@ LI,001 PSAY aResumoSepu[nPosSVend,3,k,1]+"-"+Subst(aResumoSepu[nPosSVend,3,k,2],1,50)
				@ LI,055 PSAY aResumoSepu[nPosSVend,3,k,3] PICTURE "@E 999,999,999.99"
				LI++
				nTotSepu += aResumoSepu[nPosSVend,3,k,3]
			Next k
		Endif
		LI++
		@LI,001 PSAY "Total Sepu"
		@LI,055 PSAY nTotSepu PICTURE "@E 999,999,999.99"

		Li:=Li+2
		If LI > 50
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			LI := 9
		Endif

		nPosDesc := AScan(aResumoDesc,{|x| x[1] == cVend })

		@ LI,001 PSAY "Descritivo de descontos"
		LI ++
		@ LI,001 PSAY "-----------------------"
		LI++
		@LI,001 PSAY "Descontos Recapagem"
		@LI,055 PSAY aResumoDesc[nPosDesc,2,nDescReca] PICTURE "@E 999,999,999.99"
		LI++
		@LI,001 PSAY "Descontos Serviços"
		@LI,055 PSAY aResumoDesc[nPosDesc,2,nDescServ] PICTURE "@E 999,999,999.99"
		LI++
		@LI,001 PSAY "Descontos Ass. Tecnica"
		@LI,055 PSAY aResumoDesc[nPosDesc,2,nDescAtec] PICTURE "@E 999,999,999.99"
		LI++
		@LI,001 PSAY "Descontos Novos"
		@LI,055 PSAY aResumoDesc[nPosDesc,2,nDescNovo] PICTURE "@E 999,999,999.99"
		LI++
		@LI,001 PSAY "Descontos Outros"
		@LI,055 PSAY aResumoDesc[nPosDesc,2,nDescOutr] PICTURE "@E 999,999,999.99"
		LI+=2
		@LI,001 PSAY "Total Descontos"
		@LI,055 PSAY aResumoDesc[nPosDesc,2,nDescReca];
					+ aResumoDesc[nPosDesc,2,nDescServ];
					+ aResumoDesc[nPosDesc,2,nDescAtec];
					+ aResumoDesc[nPosDesc,2,nDescNovo];
					+ aResumoDesc[nPosDesc,2,nDescOutr] PICTURE "@E 999,999,999.99"
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()

	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())

	if lImp .AND. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil