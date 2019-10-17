#include "rwmake.ch"
#include "topconn.ch"
#Define IniThinLine Chr(27)+Chr(05)+Chr(01)
#Define FimThinLine Chr(27)+Chr(05)+Chr(02)

User Function DELR501()
	Local   cDesc1      := "Imprime a relacao dos vendedores - (Analitico) "
	Local   cDesc2      := ""
	Local   cDesc3      := ""
	Private cString     := "SF2"
	Private titulo      := "Relatório de vendedores por agrupamentos"
	Private cabec1      := ""
	Private cabec2      := ""
	Private wnrel	 	:= "DLR501"
	Private cPerg   	:= "DLR501"
	Private nomeprog	:= "DELR501"
	Private m_pag		:= 1
	Private tamanho     := "M"
	Private limite      := 132
	Private nTipo       := 15
	Private nLastKey    := 0
	Private lImp        := .F.
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}

	aAdd(aRegs,{cPerg,"01","Tipo de venda  ","","","mv_ch1","C",10,0,0,"G","U_fTipVend()","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","","",""})
	aAdd(aRegs,{cPerg,"02","Data           ","","","mv_ch2","D",08,0,0,"G",""            ,"mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","","",""})
	aAdd(aRegs,{cPerg,"03","Do Vendedor    ","","","mv_ch3","C",06,0,0,"G",""            ,"mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","","",""})
	aAdd(aRegs,{cPerg,"04","Até o Vendedor ","","","mv_ch4","C",06,0,0,"G",""            ,"mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SA3","","","","",""})
	aAdd(aRegs,{cPerg,"05","Do Agrupamento ","","","mv_ch5","C",09,0,0,"G",""            ,"mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SZH","","","","",""})
	aAdd(aRegs,{cPerg,"06","Até Agrupamento","","","mv_ch6","C",09,0,0,"G",""            ,"mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SZH","","","","",""})
	aAdd(aRegs,{cPerg,"07","Imprime        ","","","mv_ch7","N",01,0,0,"C",""            ,"mv_par07","Nivel 1","","","","","NIvel 2","","","","","Nivel 3","","","","","","","","","","","","","",""   ,"","","","",""})
	aAdd(aRegs,{cPerg,"08","Imp.Total Geral","","","mv_ch8","N",01,0,0,"C",""            ,"mv_par08","Sim"    ,"","","","","Nao"    ,"","","","",""       ,"","","","","","","","","","","","","",""   ,"","","","",""})

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

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	Processa({|| DELR501imp(@lEnd,wnRel,cString) },Titulo,,.t.)
Return

Static Function DELR501Imp(lEnd,WnRel,cString)
	Local cabec2         := "                                                                                 Quantidade     Acumulado Mes          Projeção"
	Local cabec1         := ""
	Local _cVENDANT      := " "
	Local _cNomeAnt      := " "
	Local _nTqt          := 0
	Local _nTvlr         := 0
	Local _nTgqt         := 0
	Local _nTgvlr        := 0
	Local _nTgvlr        := 0
	Local  _cFuncao		 := ""
	Local  cFilTipV      := ""

	Private  _nTdevqt    := 0
	Private  _nTdevlr    := 0
	Private  _nTgdevqt   := 0
	Private  _nTgdevlr   := 0
	Private  _nTgdevqtAM := 0
	Private  _nTgdevlrAM := 0
	Private  _nTgqtAM    := 0
	Private  _nTgvlrAM   := 0
	Private  _nTTACqt    := 0
	Private  _nTTACvl    := 0
	Private  _nTgTACqt   := 0
	Private  _nTgTACvl   := 0
	Private  _nTgTACqtAM := 0
	Private  _nTgTACvlAM := 0
	Private  _nLin       := 80
	Private  cMonta      := ""

	cMonta    := VerMont()

	cFilTipV  := ""
	For jj=1 to Len(AllTrim(mv_par01))
		If Substr(mv_par01,jj,1) <> "*"
			cFilTipV := cFilTipV + "'"+Substr(mv_par01,jj,1)+"',"
		Endif
	Next jj
	If Len(cFilTipV) > 0
		cFilTipV := substr(cFilTipV,1,Len(cFilTipV)-1)
	Endif

	Titulo := "Relatorio de Vendedores por agrupamento - Loja: "+xFilial("SF2")+" - "+ DToC(mv_par02)

	cQuery := "SELECT F2_VEND1,'' FUNCAO,F2_TIPVND"
	cQuery += " ,Substr(ZG_CODAGRU,1,3) || '000000' AS AGRUN1, SZHN1.ZH_DESC AS DESCN1"
	cQuery += " ,Substr(ZG_CODAGRU,1,6) || '000' AS AGRUN2, SZHN2.ZH_DESC AS DESCN2"
	cQuery += " ,ZG_CODAGRU AS AGRUN3, SZHN3.ZH_DESC AS DESCN3"
	cQuery += " ,F2_EMISSAO,F2_DOC,F2_SERIE,D2_COD,D2_QUANT,A3_NOME,D2_TOTAL,D2_DOC,D2_SERIE ,D2_ITEM"
	cQuery += " ,'A' ORDEM,D2_PRCVEN,D2_FILIAL,0 QTD_MONT,0 QTD_ALIN"
	cQuery += " ,B1_DESENH,B1_GRUPO,B1_DEPTODV"
	cQuery += " FROM "+RetSqlName("SF2")+" SF2"

	cQuery += " JOIN "+RetSqlName("SA3")+" SA3"
	cQuery += " ON  SA3.D_E_L_E_T_ = ''"
	cQuery += " AND A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += " AND A3_COD = F2_VEND1"

	cQuery += " JOIN "+RetSqlName("SD2")+" SD2"
	cQuery += " ON  SD2.D_E_L_E_T_ = ''"
	cQuery += " AND D2_FILIAL = F2_FILIAL"
	cQuery += " AND D2_DOC = F2_DOC"
	cQuery += " AND D2_SERIE = F2_SERIE"
	cQuery += " AND D2_CLIENTE = F2_CLIENTE"
	cQuery += " AND D2_LOJA = F2_LOJA"

	cQuery += " JOIN "+RetSqlName("SB1")+" SB1"
	cQuery += " ON  SB1.D_E_L_E_T_ = ''"
	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND B1_COD = D2_COD"

	cQuery += " JOIN "+RetSqlName("SF4")+" SF4"
	cQuery += " ON  SF4.D_E_L_E_T_ = ''"
	cQuery += " AND F4_FILIAL = '"+xFilial("SF4")+"'"
	cQuery += " AND F4_CODIGO = D2_TES"
	cQuery += " AND F4_DUPLIC = 'S'"

	cQuery += " LEFT JOIN "+RetSqlName("SZG")+" SZG"
	cQuery += " ON  SZG.D_E_L_E_T_ = ''"
	cQuery += " AND ZG_CODPROD = D2_COD"

	cQuery += " LEFT JOIN "+RetSqlName("SZH")+" SZHN1"
	cQuery += " ON  SZHN1.D_E_L_E_T_ = ''"
	cQuery += " AND SZHN1.ZH_CODAGRU = SUBSTR(ZG_CODAGRU,1,3) || '000000'"

	cQuery += " LEFT JOIN "+RetSqlName("SZH")+" SZHN2"
	cQuery += " ON  SZHN2.D_E_L_E_T_ = ''"
	cQuery += " AND SZHN2.ZH_CODAGRU = SUBSTR(ZG_CODAGRU,1,6) || '000'"

	cQuery += " LEFT JOIN "+RetSqlName("SZH")+" SZHN3"
	cQuery += " ON  SZHN3.D_E_L_E_T_ = ''"
	cQuery += " AND SZHN3.ZH_CODAGRU = ZG_CODAGRU"

	cQuery += " WHERE SF2.D_E_L_E_T_ = ''"
	cQuery += " AND   F2_FILIAL = '"+xFilial("SF2")+"'"
	cQuery += " AND   F2_EMISSAO BETWEEN '"+StrZero(Year(mv_par02),4)+StrZero(Month(mv_par02),2)+ "01' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND   F2_VEND1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND   F2_VALFAT > 0"
	cQuery += " AND   F2_TIPVND IN("+cFilTipV+")"
	cQuery += " AND   ZG_CODAGRU BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

	cQuery += " UNION "

	cQuery += "SELECT PAB_CODTEC AS F2_VEND1,PAB_FUNCAO FUNCAO,F2_TIPVND"
	cQuery += " ,Substr(ZG_CODAGRU,1,3) || '000000' AS AGRUN1, SZHN1.ZH_DESC AS DESCN1"
	cQuery += " ,Substr(ZG_CODAGRU,1,6) || '000' AS AGRUN2, SZHN2.ZH_DESC AS DESCN2"
	cQuery += " ,ZG_CODAGRU AS AGRUN3, SZHN3.ZH_DESC AS DESCN3"
	cQuery += " ,F2_EMISSAO,F2_DOC,F2_SERIE,D2_COD,D2_QUANT,A3_NOME,(D2_TOTAL * PB4_PERC)/100 AS D2_TOTAL"
	cQuery += " ,D2_DOC,D2_SERIE,D2_ITEM,'B' ORDEM,D2_PRCVEN,D2_FILIAL,"

	// Qtd Montagem
	cQuery += " (SELECT COUNT(*) QTD FROM "+RetSqlName("PAB")+" PAB"
	cQuery += " WHERE PAB.D_E_L_E_T_ = ''"
	cQuery += " AND PAB_FILIAL = L1_FILIAL"
	cQuery += " AND PAB_FUNCAO = '2'"
	cQuery += " AND PAB_ORC = L1_NUM"
	cQuery += " GROUP BY PAB_FILIAL,PAB_ORC) AS QTD_MONT,"

	// Qtd Alinhamento
	cQuery += " (SELECT COUNT(*) QTD FROM "+RetSqlName("PAB")+" PAB "
	cQuery += " WHERE D_E_L_E_T_  = ''"
	cQuery += " AND PAB_FILIAL = L1_FILIAL"
	cQuery += " AND PAB_FUNCAO = '1'"
	cQuery += " AND PAB_ORC = L1_NUM"
	cQuery += " GROUP BY PAB_FILIAL, PAB_ORC) QTD_ALIN"

	cQuery += " ,B1_DESENH,B1_GRUPO,B1_DEPTODV"
	cQuery += " FROM "+RetSqlName("SF2")+" SF2"

	cQuery += " JOIN "+RetSqlName("SD2")+" SD2"
	cQuery += " ON  SD2.D_E_L_E_T_ = ''"
	cQuery += " AND D2_FILIAL = F2_FILIAL"
	cQuery += " AND D2_DOC = F2_DOC"
	cQuery += " AND D2_SERIE = F2_SERIE"
	cQuery += " AND D2_CLIENTE = F2_CLIENTE"
	cQuery += " AND D2_LOJA = F2_LOJA"

	cQuery += " JOIN "+RetSqlName("SL1")+" SL1"
	cQuery += " ON  SL1.D_E_L_E_T_ = ''"
	cQuery += " AND L1_FILIAL = F2_FILIAL"
	cQuery += " AND L1_DOC = F2_DOC"
	cQuery += " AND L1_SERIE = F2_SERIE"

	cQuery += " JOIN "+RetSqlName("PAB")+" PAB"
	cQuery += " ON  PAB.D_E_L_E_T_ = ''"
	cQuery += " AND PAB_FILIAL = F2_FILIAL"
	cQuery += " AND PAB_ORC = L1_NUM"
	cQuery += " AND PAB_CODTEC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

	cQuery += " JOIN "+RetSqlName("SB1")+" SB1"
	cQuery += " ON  SB1.D_E_L_E_T_ = ''"
	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND B1_COD = D2_COD"

	cQuery += " JOIN "+RetSqlName("SA3")+" SA3"
	cQuery += " ON  SA3.D_E_L_E_T_ = ''"
	cQuery += " AND A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += " AND A3_COD = PAB_CODTEC"

	cQuery += " JOIN "+RetSqlName("PB4")+" PB4"
	cQuery += " ON  PB4.D_E_L_E_T_ = ''"
	cQuery += " AND PB4_FILIAL = '"+xFilial("PB4")+"'"
	cQuery += " AND PB4_FUNCAO = PAB_FUNCAO"

	cQuery += " JOIN "+RetSqlName("SF4")+" SF4"
	cQuery += " ON  SF4.D_E_L_E_T_ = ''"
	cQuery += " AND F4_FILIAL = '"+xFilial("SF4")+"'"
	cQuery += " AND F4_CODIGO = D2_TES"
	cQuery += " AND F4_DUPLIC = 'S'"

	cQuery += " LEFT JOIN "+RetSqlName("SZG")+" SZG"
	cQuery += " ON  SZG.D_E_L_E_T_ = ''"
	cQuery += " AND ZG_CODPROD = D2_COD"

	cQuery += " LEFT JOIN "+RetSqlName("SZH")+" SZHN1"
	cQuery += " ON  SZHN1.D_E_L_E_T_ = ''"
	cQuery += " AND SZHN1.ZH_CODAGRU = SUBSTR(ZG_CODAGRU,1,3) || '000000'"

	cQuery += " LEFT JOIN "+RetSqlName("SZH")+" SZHN2"
	cQuery += " ON  SZHN2.D_E_L_E_T_ = ''"
	cQuery += " AND SZHN2.ZH_CODAGRU = SUBSTR(ZG_CODAGRU,1,6) || '000'"

	cQuery += " LEFT JOIN "+RetSqlName("SZH")+" SZHN3"
	cQuery += " ON  SZHN3.D_E_L_E_T_ = ''"
	cQuery += " AND   SZHN3.ZH_CODAGRU = ZG_CODAGRU"

	cQuery += " WHERE SF2.D_E_L_E_T_ = ''"
	cQuery += " AND   F2_FILIAL = '"+xFilial("SF2")+"'"
	cQuery += " AND   F2_EMISSAO BETWEEN '"+StrZero(Year(mv_par02),4)+StrZero(Month(mv_par02),2)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND   F2_TIPVND IN("+cFilTipV+")"
	cQuery += " AND   F2_VALFAT > 0"

	If AllTrim(Upper(TcGetDb())) == "DB2"
		cQuery += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN"
		cQuery += " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND"
		cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)"
	Else
		cQuery += " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN"
		cQuery += " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND"
		cQuery += " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM"
	EndIf

	cQuery += " AND   ZG_CODAGRU BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

	cQuery += " ORDER BY F2_VEND1,FUNCAO,F2_TIPVND,AGRUN1,AGRUN2,AGRUN3,F2_EMISSAO"

	If Select("TMP") > 0
		dbSelectArea("TMP")
		dbCloseArea()
	Endif

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TMP", .T., .T.)})

	ProcRegua(0)

	aNfItem := {}

	_nTgqt       := 0
	_nTgvlr      := 0
	_nTgdevqt    := 0
	_nTgdevlr    := 0
	_nTgdevqtAM  := 0
	_nTgdevlrAM  := 0

	aTotMontGer := {0,0}
	aTotSegPGer := {0,0}
	aTotRodaGer := {0,0}
	aTotSegRGer := {0,0}


	dbSelectArea("SZV")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SZV")+StrZero(Month(mv_par02),2)+"/"+StrZero(Year(mv_par02),4)+xFilial("SF2"))
	nDiasUteis := ZV_DIAS
	nDiasFat   := DiasFat()

	Cabec1 := "                                 Dias Uteis: "+AllTrim(Str(nDiasUteis))+"                            Dias Faturados: "+AllTrim(Str(nDiasFat))

	dbSelectArea("TMP")
	Do While !TMP->(eof())
		lImp := .T.
		_cVENDANT := TMP->F2_VEND1
		_cNomeAnt := TMP->A3_NOME
		_cFuncao  := TMP->FUNCAO

		_nTqt     := 0
		_nTvlr    := 0
		_nTdevqt  := 0
		_nTdevlr  := 0

		aTotMontVend := {0,0}
		aTotSegPVend := {0,0}
		aTotRodaVend := {0,0}
		aTotSegRVend := {0,0}
		cNotaMont := ""
		nCarros   := 0

		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		_nLin := 9

		IF Empty(TMP->FUNCAO)
			@_nLin,000 PSAY "Vendedor  "+_cVENDANT+" - "+_cNomeAnt
		ElseIf	TMP->FUNCAO == "1"
			@_nLin,000 PSAY "Alinhador "+_cVENDANT+" - "+_cNomeAnt
		ElseIf	TMP->FUNCAO == "2"
			@_nLin,000 PSAY "Montador  "+_cVENDANT+" - "+_cNomeAnt
		EndIf
		_nLin := _nLin + 1

		dbSelectArea("TMP")
		Do While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao
			cTVAnt := TMP->F2_TIPVND
			aTotVen := {0,0,0}
			@ _nLin,005 PSAY cTVAnt+" - "+Posicione("PAG",1,xFilial("PAG")+cTVAnt,"PAG->PAG_DESC")
			_nLin := _nLin + 1
	
			dbSelectArea("TMP")
			Do While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao .AND. TMP->F2_TIPVND == cTVAnt

				cGrpN1 := TMP->AGRUN1

				@ _nLin,010 PSAY iif(Len(AllTrim(AGRUN1))>0,AGRUN1,"?????????")+" - "+iif(Len(AllTrim(DESCN1))>0,DESCN1,"PROBLEMAS NO AGRUPAMENTO")
				_nLin := _nLin + 1
				aTotN1 := {0,0,0}
	
				Do While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao .AND. TMP->F2_TIPVND == cTVAnt .AND. TMP->AGRUN1 == cGrpN1
	
					cGrpN2 := TMP->AGRUN2
					aTotN2 := {0,0,0}
					If mv_par07 >= 2
						@ _nLin,015 PSAY iif(Len(AllTrim(AGRUN2))>0,AGRUN2,"?????????")+" - "+iif(Len(AllTrim(DESCN2))>0,DESCN2,"PROBLEMAS NO AGRUPAMENTO")
						_nLin := _nLin + 1
					Endif
	
					Do While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao .AND. TMP->F2_TIPVND == cTVAnt .AND. TMP->AGRUN1 == cGrpN1 .AND. TMP->AGRUN2 == cGrpN2

						cGrpN3 := TMP->AGRUN3
						aTotN3 := {0,0,0}
						If mv_par07 = 3
							@ _nLin,020 PSAY iif(Len(AllTrim(AGRUN3))>0,AGRUN3,"?????????")+" - "+iif(Len(AllTrim(DESCN3))>0,DESCN3,"PROBLEMAS NO AGRUPAMENTO")
						Endif
	
						Do While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao .AND. TMP->F2_TIPVND == cTVAnt .AND. TMP->AGRUN1 == cGrpN1 .AND. TMP->AGRUN2 == cGrpN2 .AND. TMP->AGRUN2 == cGrpN2
							IncProc("Imprimindo...")
							
							nAchou := aScan(aNfItem,TMP->F2_VEND1+TMP->D2_DOC+TMP->D2_ITEM)
							If nAchou > 0
								dbSkip()
								Loop
							Else
								aAdd(aNfItem,TMP->F2_VEND1+TMP->D2_DOC+TMP->D2_ITEM)
							Endif

							If Empty(TMP->FUNCAO)
								aTotN1[3] += TMP->D2_QUANT
								aTotN2[3] += TMP->D2_QUANT
								aTotN3[3] += TMP->D2_QUANT
								aTotVen[3] += TMP->D2_QUANT
							ElseIf TMP->FUNCAO == "1" //ALINHADOR
								aTotN1[3] += (TMP->D2_QUANT/TMP->QTD_ALIN)
								aTotN2[3] += (TMP->D2_QUANT/TMP->QTD_ALIN)
								aTotN3[3] += (TMP->D2_QUANT/TMP->QTD_ALIN)
								aTotVen[3] += (TMP->D2_QUANT/TMP->QTD_ALIN)
							Else
								aTotN1[3] += (TMP->D2_QUANT/TMP->QTD_MONT)
								aTotN2[3] += (TMP->D2_QUANT/TMP->QTD_MONT)
								aTotN3[3] += (TMP->D2_QUANT/TMP->QTD_MONT)
								aTotVen[3] += (TMP->D2_QUANT/TMP->QTD_MONT)
							Endif
						
							If TMP->F2_EMISSAO <> dtos(mv_par02)
								dbSkip()
								Loop
							Endif

							Devolve()

							If AllTrim(TMP->D2_COD) $ cMonta
								aTotMontVend[1] += TMP->D2_QUANT
								aTotMontVend[2] += TMP->D2_TOTAL
								aTotMontGer[1] += TMP->D2_QUANT
								aTotMontGer[2] += TMP->D2_TOTAL
								if !(TMP->D2_DOC+TMP->D2_SERIE $ cNotaMont)
									cNotaMont += TMP->D2_DOC+TMP->D2_SERIE+"*"
									nCarros ++
								Endif
							endif

							dbSelectArea("SBM")
							dbSetOrder(1)
							dbgoTop()
							dbSeek(xFilial("SBM")+TMP->B1_GRUPO)
							DbSelectArea("TMP")

							if AllTrim(SBM->BM_TIPOPRD) = "R"
								aTotRodaVend[1] += TMP->D2_QUANT
								aTotRodaVend[2] += TMP->D2_TOTAL
								aTotRodaGer[1] += TMP->D2_QUANT
								aTotRodaGer[2] += TMP->D2_TOTAL
							Endif
							If AllTrim(TMP->B1_DESENH) = "GP"
								aTotSegPVend[1] += TMP->D2_QUANT
								aTotSegPVend[2] += TMP->D2_TOTAL
								aTotSegPGer[1] += TMP->D2_QUANT
								aTotSegPGer[2] += TMP->D2_TOTAL
							Endif
							if AllTrim(TMP->B1_DESENH) = "GR"
								aTotSegRVend[1] += TMP->D2_QUANT
								aTotSegRVend[2] += TMP->D2_TOTAL
								aTotSegRGer[1] += TMP->D2_QUANT
								aTotSegRGer[2] += TMP->D2_TOTAL
							Endif

							If Empty(TMP->FUNCAO) //VENDEDOR
								_nTqt  := _nTqt  + TMP->D2_QUANT
								_nTvlr := _nTvlr + TMP->D2_TOTAL
								aTotN1[1] += TMP->D2_QUANT
								aTotN1[2] += TMP->D2_TOTAL
								aTotN2[1] += TMP->D2_QUANT
								aTotN2[2] += TMP->D2_TOTAL
								aTotN3[1] += TMP->D2_QUANT
								aTotN3[2] += TMP->D2_TOTAL
								aTotVen[1] += TMP->D2_QUANT
								aTotVen[2] += TMP->D2_TOTAL
							ElseIf TMP->FUNCAO == "1" //ALINHADOR
								_nTqt  := _nTqt  + (TMP->D2_QUANT/TMP->QTD_ALIN)
								_nTvlr := _nTvlr + (TMP->D2_TOTAL/TMP->QTD_ALIN)

								aTotN1[1] += (TMP->D2_QUANT/TMP->QTD_ALIN)
								aTotN1[2] += (TMP->D2_TOTAL/TMP->QTD_ALIN)
								aTotN2[1] += (TMP->D2_QUANT/TMP->QTD_ALIN)
								aTotN2[2] += (TMP->D2_TOTAL/TMP->QTD_ALIN)
								aTotN3[1] += (TMP->D2_QUANT/TMP->QTD_ALIN)
								aTotN3[2] += (TMP->D2_TOTAL/TMP->QTD_ALIN)
								aTotVen[1] += (TMP->D2_QUANT/TMP->QTD_ALIN)
								aTotVen[2] += (TMP->D2_TOTAL/TMP->QTD_ALIN)
							Else
								_nTqt  := _nTqt  + (TMP->D2_QUANT/TMP->QTD_MONT)
								_nTvlr := _nTvlr + (TMP->D2_TOTAL/TMP->QTD_MONT)
								aTotN1[1] += (TMP->D2_QUANT/TMP->QTD_MONT)
								aTotN1[2] += (TMP->D2_TOTAL/TMP->QTD_MONT)
								aTotN2[1] += (TMP->D2_QUANT/TMP->QTD_MONT)
								aTotN2[2] += (TMP->D2_TOTAL/TMP->QTD_MONT)
								aTotN3[1] += (TMP->D2_QUANT/TMP->QTD_MONT)
								aTotN3[2] += (TMP->D2_TOTAL/TMP->QTD_MONT)
								aTotVen[1] += (TMP->D2_QUANT/TMP->QTD_MONT)
								aTotVen[2] += (TMP->D2_TOTAL/TMP->QTD_MONT)
							EndIf

							If Empty(TMP->FUNCAO)
								_nTgqt   := _nTgqt  + TMP->D2_QUANT
								_nTgvlr  := _nTgvlr + TMP->D2_TOTAL
							ElseIF TMP->FUNCAO == "1" 
								_nTgqtAM  := _nTgqtAM  + (TMP->D2_QUANT/TMP->QTD_ALIN)
								_nTgvlrAM := _nTgvlrAM + (TMP->D2_TOTAL/TMP->QTD_ALIN)
							Else
								_nTgqtAM  := _nTgqtAM  + (TMP->D2_QUANT/TMP->QTD_MONT)
								_nTgvlrAM := _nTgvlrAM + (TMP->D2_TOTAL/TMP->QTD_MONT)		
							Endif
			
							IF AllTrim( TMP->B1_DEPTODV ) == "TAC"
								_nTTACqt += TMP->D2_QUANT
								_nTTACvl += TMP->D2_TOTAL
				
								IF EMPTY(TMP->FUNCAO)
									_nTgTACqt += TMP->D2_QUANT
									_nTgTACvl += TMP->D2_TOTAL
								Else
									_nTgTACqtAM += TMP->D2_QUANT
									_nTgTACvlAM += TMP->D2_TOTAL
								Endif
							EndIf
							DbSelectArea("TMP")
							dbSkip()
						Enddo
						IF _nLin > 55 .AND. mv_par07 = 3
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
							_nLin := 9
						EndIF
						if mv_par07 = 3
							@_nLin,080      PSAY aTotN3[1]  Picture "@E 999,999,999"
							@_nLin,pCol()+7 PSAY aTotN3[3]  Picture "@E 999,999,999"
							@_nLin,pCol()+7 PSAY (aTotN3[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
							_nLin := _nLin + 1
						Endif
					Enddo
					IF _nLin > 55 .AND. mv_par07 >= 2
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
						_nLin := 9
					EndIF
					if mv_par07 = 3
						@_nLin,015      PSAY "Total do Nivel 2"
					elseif mv_par07 = 2
						_nLin := _nLin -1
					Endif
					if mv_par07 >= 2
						@_nLin,080      PSAY aTotN2[1]  Picture "@E 999,999,999"
						@_nLin,pCol()+7 PSAY aTotN2[3]  Picture "@E 999,999,999"
						@_nLin,pCol()+7 PSAY (aTotN2[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
						_nLin := _nLin + 1
					Endif
				Enddo
				IF _nLin > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
					_nLin := 9
				EndIF
				if mv_par07 >= 2
					@_nLin,010      PSAY "Total do Nivel 1"
				Endif
				if mv_par07 = 1
					_nLin := _nLin -1
				Endif
				@_nLin,080      PSAY aTotN1[1]  Picture "@E 999,999,999"
				@_nLin,pCol()+7 PSAY aTotN1[3]  Picture "@E 999,999,999"
				@_nLin,pCol()+7 PSAY (aTotN1[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
				_nLin := _nLin + 1
			Enddo			
			@_nLin,005      PSAY "Total do Tipo de venda"
			@_nLin,080      PSAY aTotVen[1]  Picture "@E 999,999,999"
			@_nLin,pCol()+7 PSAY aTotVen[3]  Picture "@E 999,999,999"
			@_nLin,pCol()+7 PSAY (aTotVen[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
			_nLin := _nLin + 2
		Enddo

		_nLin++
		@ _nLin,000 PSAY IniThinLine+FimThinLine
		_nLin++
		
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000 PSAY "Total de Rodas Vendidas: "+AllTrim(Transform(aTotRodaVend[1],"@E 999,999,999"))
		@_nLin,045 PSAY "Total de Seguros Rodas: "+AllTrim(Transform(aTotSegRVend[1],"@E 999,999,999"))
		@_nLin,095 PSAY "Aproveitamento: "+AllTrim(Transform((aTotSegRVend[1]/aTotRodaVend[1])*100,"@E 999.99"))+"%"

		_nLin := _nLin + 1
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000 PSAY "Total de Pneus Montados: "+AllTrim(Transform(aTotMontVend[1],"@E 999,999,999"))
		@_nLin,045 PSAY "Total de Seguros Pneus: "+AllTrim(Transform(aTotSegPVend[1],"@E 999,999,999"))
		@_nLin,095 PSAY "Aproveitamento: "+AllTrim(Transform((aTotSegPVend[1]/aTotMontVend[1])*100,"@E 999.99"))+"%"

		_nLin := _nLin + 1
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000 PSAY "Carros antendidos: "+AllTrim(Transform(nCarros,"@E 999,999,999"))

		_nLin := _nLin + 2
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000 PSAY "Total: "+AllTrim(Transform(_nTqt,"@E 999,999,999"))
		@_nLin,045 PSAY "Total de Devoluções: "+AllTrim(Transform(_nTdevqt,"@E 999,999,999"))
		@_nLin,095 PSAY "Total de TAC: "+AllTrim(Transform(_nTTACqt,"@E 999,999,999"))

		_nLin++
		@ _nLin,000 PSAY IniThinLine+FimThinLine
		_nLin++

	Enddo

	dbSelectArea("TMP")
	dbCloseArea()

	If lImp
		If mv_par08 = 1
			_nLin :=  _nLin + 3

			IF _nLin > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				_nLin := 9
			EndIF

			@_nLin,000      PSAY "Total Geral de Rodas Vendidas:"
			@_nLin,080      PSAY aTotRodaGer[1] Picture "@E 999,999,999"
			_nLin++
			@_nLin,000      PSAY "Total Geral de Seguros Rodas:"
			@_nLin,080      PSAY aTotSegRGer[1] Picture "@E 999,999,999"
			_nLin++
			@_nLin,000      PSAY "(%) Aproveitamento:"
			@_nLin,080      PSAY (aTotSegRGer[1]/aTotRodaGer[1])*100 Picture "@E 999,999,999"

			_nLin := _nLin + 2
			IF _nLin > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				_nLin := 9
			EndIF

			@_nLin,000      PSAY "Total Geral de Pneus Montados:"
			@_nLin,080      PSAY aTotMontGer[1] Picture "@E 999,999,999"
			_nLin++
			@_nLin,000      PSAY "Total Geral de Seguros Pneus:"
			@_nLin,080      PSAY aTotSegPGer[1] Picture "@E 999,999,999"
			_nLin++
			@_nLin,000      PSAY "(%) Aproveitamento:"
			@_nLin,080      PSAY (aTotSegPGer[1]/aTotMontGer[1])*100 Picture "@E 999,999,999"

			_nLin := _nLin + 2
			IF _nLin > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				_nLin := 9
			EndIF

			@_nLin,000      PSAY "Total Geral dos Vendedores: "
			@_nLin,080      PSAY _nTgqt  Picture "@E 999,999,999"
			_nLin := _nLin + 1

			@_nLin,000      PSAY "Total Geral de Devolucao dos Vendedores: "
			@_nLin,080      PSAY _nTgdevqt  Picture "@E 999,999,999"
			_nLin := _nLin + 1

			@_nLin,000      PSAY "Total Geral de TAC Vendedores: "
			@_nLin,080      PSAY _nTgTACqt  Picture "@E 999,999,999"
			_nLin := _nLin + 2

			@_nLin,000      PSAY "Total Geral dos Alinhadores e Montadores: "
			@_nLin,080      PSAY _nTgqtAM  Picture "@E 999,999,999"
			_nLin := _nLin + 1

			@_nLin,000      PSAY "Total Geral de Devolucao dos Alinhadores e Montadores: "
			@_nLin,080      PSAY _nTgdevqtAM  Picture "@E 999,999,999"
			_nLin := _nLin + 1

			@_nLin,000      PSAY "Total Geral de TAC dos Alinhadores e Montadores: "
			@_nLin,080      PSAY _nTgTACqtAM  Picture "@E 999,999,999"
			_nLin := _nLin + 2

			@_nLin,000      PSAY "Total Geral: "
			@_nLin,080      PSAY (_nTgqt  + _nTgqtAM)  Picture "@E 999,999,999"
			_nLin := _nLin + 1

			@_nLin,000      PSAY "Total Geral de Devolucao: "
			@_nLin,080      PSAY (_nTgdevqt + _nTgdevqtAM) Picture "@E 999,999,999"
			_nLin := _nLin + 1

			@_nLin,000      PSAY "Total Geral de TAC: "
			@_nLin,080      PSAY (_nTgTACqt + _nTgTACqtAM) Picture "@E 999,999,999"
		Endif

		roda(0,"",Tamanho)
	Endif

	If aReturn[5] = 1
		dbCommitAll()
		Ourspool(wnrel)
	Endif
	MS_FLUSH()
RETURN

Static Function Devolve()
	Local cQuedev := ""
	Local aArea   := GetArea()

	cQuedev := "SELECT D1_QUANT"
	cQuedev += " FROM "+RetSqlName("SD1")+" SD1"
	cQuedev += "     ,"+RetSqlName("SB1")+" SB1"
	cQuedev += "     ,"+RetSqlName("PB4")+" PB4" 
	cQuedev += " WHERE SD1.D_E_L_E_T_ = ''"
	cQuedev += " AND   SB1.D_E_L_E_T_ = ''"
	cQuedev += " AND   PB4.D_E_L_E_T_ = ''"
	cQuedev += " AND   D1_TIPO    = 'D'"
	cQuedev += " AND   D1_FILIAL  = '"+TMP->D2_FILIAL+"'"
	cQuedev += " AND   D1_NFORI   = '"+TMP->D2_DOC+"'"
	cQuedev += " AND   D1_SERIORI = '"+TMP->D2_SERIE+"'"
	cQuedev += " AND   D1_ITEMORI = '"+TMP->D2_ITEM+"'"
	cQuedev += " AND   B1_FILIAL  = '" + xFilial("SB1") + "'"
	cQuedev += " AND   B1_COD = D1_COD"
	cQuedev += " AND   PB4_FILIAL = '" + xFilial("PB4") + "'"
	cQuedev += " AND   PB4_FUNCAO = '3'"
	cQuedev += " AND   PB4_META <> '2'" // A Meta 2 esta dentro da 1 para o Venda
	cQuedev += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV)"
	cQuedev += " BETWEEN  CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI)"
	cQuedev += " AND   CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuedev),"DEV",.F.,.T.)
	DbSelectArea("DEV")

	While !DEV->(eof())
		nValDev := DEV->D1_QUANT * TMP->D2_PRCVEN

		_nTdevqt  := _nTdevqt  + DEV->D1_QUANT
		_nTdevlr  := _nTdevlr  + nValDev

		IF Empty(TMP->FUNCAO)
			_nTgdevqt := _nTgdevqt  + DEV->D1_QUANT
			_nTgdevlr := _nTgdevlr  + nValDev
		Else
			_nTgdevqtAM := _nTgdevqtAM  + DEV->D1_QUANT
			_nTgdevlrAM := _nTgdevlrAM  + nValDev
		Endif
	
		DbSelectArea("DEV")
		dbSkip()
	EndDo
	dbCloseArea()
	RestArea(aArea)
Return

Static Function VerMont()
	// DV_AGMONT - Código do agrupamento para montagem de pneus no BI
	Local cFilMonta := ""
	cSql := ""
	cSql += "SELECT ZG_CODPROD"
	cSql += " FROM "+RetSqlname("SZG")+" SZG,"+RetSqlname("SB1")+" SB1"
	cSql += " WHERE SZG.D_E_L_E_T_ = ''"
	cSql += " AND   SB1.D_E_L_E_T_ = ''"
	cSql += " AND   ZG_FILIAL = '"+xFilial("SZG")+"'"
	cSql += " AND   SUBSTR(ZG_CODAGRU,1,6) = '"+Substr(AllTrim(GetMv("DV_AGMONT")),1,6)+"'"
	cSql += " AND   B1_COD = ZG_CODPROD"
	cSql += " AND   B1_GRTRIB = '015'"
	cSql += " ORDER BY ZG_CODPROD"

	cSql := ChangeQuery(cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MONT1", .T., .T.)

	dbSelectArea("SQL_MONT1")
	dbGoTop()
	do while !eof()
		cFilMonta += AllTrim(ZG_CODPROD) + "*"
		dbSkip()
	Enddo
	dbSelectArea("SQL_MONT1")
	dbCloseArea()
Return cFilMonta

Static Function DiasFat()
	Local nRet := 0
	cSql := "SELECT DISTINCT F2_EMISSAO FROM SF2010"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   F2_FILIAL = '"+xFilial("SF2")+"'"
	cSql += " AND   F2_EMISSAO BETWEEN '"+StrZero(Year(mv_par02),4)+StrZero(Month(mv_par02),2)+"01' AND '"+dtos(mv_par02)+"'"
	cSql += " ORDER BY F2_EMISSAO"

	cSql := ChangeQuery(cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_DFAT", .T., .T.)
	dbSelectArea("SQL_DFAT")
	Do While !eof()
		nRet ++
		dbSkip()
	Enddo
	dbCloseArea()
Return nRet