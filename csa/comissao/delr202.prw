#include "rwmake.ch"
#include "topconn.ch"

User Function DELR500()
	Local   cDesc1      := "Imprime a relacao dos vendedores - (Analitico) "
	Local   cDesc2      := ""
	Local   cDesc3      := ""
	Private cString     := "SF2"
	Private titulo      := "RELATORIO DE VENDEDORES ANALITICO"
	Private cabec1      := ""
	Private cabec2      := ""
	Private wnrel	 	:= "DLR500"
	Private cPerg   	:= "DLR500"
	Private nomeprog	:= "DELR500"
	Private m_pag		:= 1
	Private tamanho     := "M"
	Private limite      := 132
	Private nTipo       := 15
	Private nLastKey    := 0
	Private lImp        := .F.
//	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 1, 1, "", 1}
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}

	aAdd(aRegs,{cPerg,"01","Tipo de venda  ","","","mv_ch1","C",10,0,0,"G","U_fTipVend()","mv_par01",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"","","","",""})
	aAdd(aRegs,{cPerg,"02","Data           ","","","mv_ch2","D",08,0,0,"G",""            ,"mv_par02",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"","","","",""})
	aAdd(aRegs,{cPerg,"03","Do Vendedor    ","","","mv_ch3","C",06,0,0,"G",""            ,"mv_par03",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SA3","","","","",""})
	aAdd(aRegs,{cPerg,"04","Até o Vendedor ","","","mv_ch4","C",06,0,0,"G",""            ,"mv_par04",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SA3","","","","",""})
	aAdd(aRegs,{cPerg,"05","Do Grupo       ","","","mv_ch5","C",04,0,0,"G",""            ,"mv_par05",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SBM","","","","",""})
	aAdd(aRegs,{cPerg,"06","Até o Grupo    ","","","mv_ch6","C",04,0,0,"G",""            ,"mv_par06",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SBM","","","","",""})
	aAdd(aRegs,{cPerg,"07","Da Categoria   ","","","mv_ch7","C",04,0,0,"G",""            ,"mv_par07",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SZ6","","","","",""})
	aAdd(aRegs,{cPerg,"08","Até a Categoria","","","mv_ch8","C",04,0,0,"G",""            ,"mv_par08",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SZ6","","","","",""})
	aAdd(aRegs,{cPerg,"09","Imp. Categoria ","","","mv_ch9","N",01,0,0,"C",""            ,"mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","",""   ,"","","","",""})

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

	Processa({|| DELR500imp(@lEnd,wnRel,cString) },Titulo,,.t.)
Return

Static Function DELR500Imp(lEnd,WnRel,cString)
	Local cabec2         := "                                                             Quantidade     Valor Total     Acumulado Mes          Projeção"
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

	cMonta := VerMont()

	cFilTipV := ""
	For jj=1 to Len(AllTrim(mv_par01))
		If Substr(mv_par01,jj,1) <> "*"
			cFilTipV := cFilTipV + "'"+Substr(mv_par01,jj,1)+"',"
		Endif
	Next jj
	If Len(cFilTipV) > 0
		cFilTipV := substr(cFilTipV,1,Len(cFilTipV)-1)
	Endif

	Titulo := "Relatorio de Vendedores Analitico - Loja: "+xFilial("SF2")+" - "+ DToC(mv_par02)

	cQuery := "SELECT F2_TIPVND,F2_EMISSAO,F2_DOC,F2_SERIE,D2_COD,B1_DESC,D2_QUANT,A3_NOME,D2_TOTAL,D2_DOC,D2_SERIE"
	cQuery += " ,D2_ITEM,F2_VEND1,'' FUNCAO,'A' ORDEM,D2_PRCVEN,D2_FILIAL,B1_DEPTODV,0 QTD_MONT,0 QTD_ALIN,B1_GRUPO,B1_CATEG,B1_DESENH"
	cQuery += " FROM "+RetSqlName("SF2")+" SF2"
	cQuery += " ,"+RetSqlName("SA3")+" SA3"
	cQuery += " ,"+RetSqlName("SD2")+" SD2"
	cQuery += " ,"+RetSqlName("SB1")+" SB1"
	cQuery += " ,"+RetSqlName("SF4")+" SF4"
	cQuery += " WHERE SF2.D_E_L_E_T_ = ''"
	cQuery += " AND   SD2.D_E_L_E_T_ = ''"
	cQuery += " AND   SB1.D_E_L_E_T_ = ''"
	cQuery += " AND   SF4.D_E_L_E_T_ = ''"
	cQuery += " AND   SA3.D_E_L_E_T_ = ''"
	cQuery += " AND   F2_FILIAL = '"+xFilial("SF2")+"'"
	cQuery += " AND   F2_EMISSAO BETWEEN '"+StrZero(Year(mv_par02),4)+StrZero(Month(mv_par02),2)+ "01' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND   F2_VEND1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND   F2_VALFAT > 0"
	cQuery += " AND   F2_TIPVND IN("+cFilTipV+")"
	cQuery += " AND   D2_FILIAL = F2_FILIAL"
	cQuery += " AND   D2_DOC = F2_DOC"
	cQuery += " AND   D2_SERIE = F2_SERIE"
	cQuery += " AND   D2_CLIENTE = F2_CLIENTE"
	cQuery += " AND   D2_LOJA = F2_LOJA"
	cQuery += " AND   B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND   B1_COD = D2_COD"
	cQuery += " AND   B1_GRUPO   BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND   B1_CATEG   BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND   F4_FILIAL = '"+xFilial("SF4")+"'"
	cQuery += " AND   F4_CODIGO = D2_TES"
	cQuery += " AND   F4_DUPLIC = 'S'"
	cQuery += " AND   A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += " AND   A3_COD = F2_VEND1"

	cQuery += " UNION "

	cQuery += "SELECT F2_TIPVND,F2_EMISSAO,F2_DOC,F2_SERIE,D2_COD,B1_DESC,D2_QUANT,A3_NOME,(D2_TOTAL * PB4_PERC)/100 AS D2_TOTAL"
	cQuery += " ,D2_DOC,D2_SERIE,D2_ITEM,PAB_CODTEC AS F2_VEND1,PAB_FUNCAO FUNCAO,'B' ORDEM,D2_PRCVEN,D2_FILIAL,B1_DEPTODV,"

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

	cQuery += " ,B1_GRUPO,B1_CATEG,B1_DESENH"

	cQuery += " FROM "+RetSqlName("SF2")+" SF2"
	cQuery += " ,"+RetSqlName("SD2")+" SD2"
	cQuery += " ,"+RetSqlName("SL1")+" SL1"
	cQuery += " ,"+RetSqlName("PAB")+" PAB"
	cQuery += " ,"+RetSqlName("SA3")+" SA3"
	cQuery += " ,"+RetSqlName("SB1")+" SB1"
	cQuery += " ,"+RetSqlName("PB4")+" PB4"
	cQuery += " ,"+RetSqlName("SF4")+" SF4"
	cQuery += " WHERE SF2.D_E_L_E_T_ = ''"
	cQuery += " AND   SD2.D_E_L_E_T_ = ''"
	cQuery += " AND   SL1.D_E_L_E_T_ = ''"
	cQuery += " AND   PAB.D_E_L_E_T_ = ''"
	cQuery += " AND   SB1.D_E_L_E_T_ = ''"
	cQuery += " AND   SF4.D_E_L_E_T_ = ''"
	cQuery += " AND   PB4.D_E_L_E_T_ = ''"
	cQuery += " AND   SA3.D_E_L_E_T_ = ''"
	cQuery += " AND   F2_FILIAL = '"+xFilial("SF2")+"'"
	cQuery += " AND   F2_EMISSAO BETWEEN '"+StrZero(Year(mv_par02),4)+StrZero(Month(mv_par02),2)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND   F2_TIPVND IN("+cFilTipV+")"
	cQuery += " AND   F2_VALFAT > 0"
	cQuery += " AND   D2_FILIAL = F2_FILIAL"
	cQuery += " AND   D2_DOC = F2_DOC"
	cQuery += " AND   D2_SERIE = F2_SERIE"
	cQuery += " AND   D2_CLIENTE = F2_CLIENTE"
	cQuery += " AND   D2_LOJA = F2_LOJA"
	cQuery += " AND   L1_FILIAL = F2_FILIAL"
	cQuery += " AND   L1_DOC = F2_DOC"
	cQuery += " AND   L1_SERIE = F2_SERIE"
	cQuery += " AND   PAB_FILIAL = F2_FILIAL"
	cQuery += " AND   PAB_ORC = L1_NUM"
	cQuery += " AND   B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND   B1_COD = D2_COD"
	cQuery += " AND   B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND   B1_CATEG BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND   F4_FILIAL = '"+xFilial("SF4")+"'"
	cQuery += " AND   F4_CODIGO = D2_TES"
	cQuery += " AND   F4_DUPLIC = 'S'"
	cQuery += " AND   PB4_FILIAL = '"+xFilial("PB4")+"'"
	cQuery += " AND   PB4_FUNCAO = PAB_FUNCAO"

	If AllTrim(Upper(TcGetDb())) == "DB2"
		cQuery += " AND CONCAT(CONCAT(B1_DEPTODV,B1_GRUPODV),B1_ESPECDV) BETWEEN"
		cQuery += " CONCAT(CONCAT(PB4_DEPINI,PB4_GRUINI),PB4_ESPINI) AND"
		cQuery += " CONCAT(CONCAT(PB4_DEPFIM,PB4_GRUFIM),PB4_ESPFIM)"
	Else
		cQuery += " AND B1_DEPTODV+B1_GRUPODV+B1_ESPECDV BETWEEN"
		cQuery += " PB4_DEPINI+PB4_GRUINI+PB4_ESPINI AND"
		cQuery += " PB4_DEPFIM+PB4_GRUFIM+PB4_ESPFIM"
	EndIf

	cQuery += " AND A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += " AND A3_COD = PAB_CODTEC"
	cQuery += " AND PAB_CODTEC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " ORDER BY F2_VEND1,FUNCAO,F2_TIPVND,B1_GRUPO,B1_CATEG,F2_EMISSAO"

	If Select("TMP") > 0
		dbSelectArea("TMP")
		dbCloseArea()
	Endif

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TMP", .T., .T.)})

	ProcRegua(0)

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
		_cNomeAnt := TMP->A3_NOME   // WM
		_cFuncao  := TMP->FUNCAO

		_nTqt     := 0
		_nTvlr    := 0
		_nTdevqt  := 0
		_nTdevlr  := 0

		aTotMontVend := {0,0}
		aTotSegPVend := {0,0}
		aTotRodaVend := {0,0}
		aTotSegRVend := {0,0}

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

				cGrpAnt := TMP->B1_GRUPO

				dbSelectArea("SBM")
				dbSetOrder(1)
				dbgoTop()
				dbSeek(xFilial("SBM")+cGrpAnt)
				DbSelectArea("TMP")

				@ _nLin,010 PSAY cGrpAnt+" - "+SBM->BM_DESC
				_nLin := _nLin + 1
				aTotGrp := {0,0,0}
	
				Do While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao .AND. TMP->F2_TIPVND == cTVAnt .AND. TMP->B1_GRUPO == cGrpAnt
	
					cCatAnt := TMP->B1_CATEG
					aTotCat := {0,0,0}
	
					Do While !TMP->(eof()) .And. TMP->F2_VEND1 == _cVENDANT .And. TMP->FUNCAO == _cFuncao .AND. TMP->F2_TIPVND == cTVAnt .AND. TMP->B1_GRUPO == cGrpAnt .AND. TMP->B1_CATEG == cCatAnt
						IncProc("Imprimindo...")

						If Empty(TMP->FUNCAO)
							aTotCat[3] += TMP->D2_QUANT
							aTotGrp[3] += TMP->D2_QUANT
							aTotVen[3] += TMP->D2_QUANT
						ElseIf TMP->FUNCAO == "1" //ALINHADOR
							aTotCat[3] += (TMP->D2_QUANT/TMP->QTD_ALIN)
							aTotGrp[3] += (TMP->D2_QUANT/TMP->QTD_ALIN)
							aTotVen[3] += (TMP->D2_QUANT/TMP->QTD_ALIN)
						Else
							aTotCat[3] += (TMP->D2_QUANT/TMP->QTD_MONT)
							aTotGrp[3] += (TMP->D2_QUANT/TMP->QTD_MONT)
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
						endif
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
							aTotGrp[1] += TMP->D2_QUANT
							aTotGrp[2] += TMP->D2_TOTAL
							aTotCat[1] += TMP->D2_QUANT
							aTotCat[2] += TMP->D2_TOTAL
							aTotVen[1] += TMP->D2_QUANT
							aTotVen[2] += TMP->D2_TOTAL
						ElseIf TMP->FUNCAO == "1" //ALINHADOR
							_nTqt  := _nTqt  + (TMP->D2_QUANT/TMP->QTD_ALIN)
							_nTvlr := _nTvlr + (TMP->D2_TOTAL/TMP->QTD_ALIN)
							aTotGrp[1] += (TMP->D2_QUANT/TMP->QTD_ALIN)
							aTotGrp[2] += (TMP->D2_TOTAL/TMP->QTD_ALIN)
							aTotCat[1] += (TMP->D2_QUANT/TMP->QTD_ALIN)
							aTotCat[2] += (TMP->D2_TOTAL/TMP->QTD_ALIN)
							aTotVen[1] += (TMP->D2_QUANT/TMP->QTD_ALIN)
							aTotVen[2] += (TMP->D2_TOTAL/TMP->QTD_ALIN)
						Else
							_nTqt  := _nTqt  + (TMP->D2_QUANT/TMP->QTD_MONT)
							_nTvlr := _nTvlr + (TMP->D2_TOTAL/TMP->QTD_MONT)
							aTotGrp[1] += (TMP->D2_QUANT/TMP->QTD_MONT)
							aTotGrp[2] += (TMP->D2_TOTAL/TMP->QTD_MONT)
							aTotCat[1] += (TMP->D2_QUANT/TMP->QTD_MONT)
							aTotCat[2] += (TMP->D2_TOTAL/TMP->QTD_MONT)
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
					IF _nLin > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
						_nLin := 9
					EndIF
					If mv_par09 = 1
						@_nLin,015 PSAY cCatAnt+" - "+Posicione("SZ6",1,"01"+cCatAnt,"SZ6->Z6_DESC")
						@_nLin,060      PSAY aTotCat[1]  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
						@_nLin,pCol()+2 PSAY aTotCat[2]  Picture PesqPict("SD2","D2_TOTAL")
						@_nLin,pCol()+7 PSAY aTotCat[3]  Picture "@E 999,999,999"
						@_nLin,pCol()+7 PSAY (aTotCat[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
						_nLin := _nLin + 1
					Endif
				Enddo
				If mv_par09 = 1
					@_nLin,010      PSAY "Total do Grupo"
					@_nLin,060      PSAY aTotGrp[1]  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
					@_nLin,pCol()+2 PSAY aTotGrp[2]  Picture PesqPict("SD2","D2_TOTAL")
					@_nLin,pCol()+7 PSAY aTotGrp[3]  Picture "@E 999,999,999"
					@_nLin,pCol()+7 PSAY (aTotGrp[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
				Else
					_nLin := _nLin - 1
					@_nLin,060      PSAY aTotGrp[1]  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
					@_nLin,pCol()+2 PSAY aTotGrp[2]  Picture PesqPict("SD2","D2_TOTAL")
					@_nLin,pCol()+7 PSAY aTotGrp[3]  Picture "@E 999,999,999"
					@_nLin,pCol()+7 PSAY (aTotGrp[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
				Endif
				_nLin := _nLin + 1
			Enddo			
			@_nLin,005      PSAY "Total do Tipo de venda"
			@_nLin,060      PSAY aTotVen[1]  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
			@_nLin,pCol()+2 PSAY aTotVen[2]  Picture PesqPict("SD2","D2_TOTAL")
			@_nLin,pCol()+7 PSAY aTotVen[3]  Picture "@E 999,999,999"
			@_nLin,pCol()+7 PSAY (aTotVen[3]/nDiasFat)*nDiasUteis  Picture "@E 999,999,999"
			_nLin := _nLin + 2
		Enddo

		_nLin++

		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000      PSAY "Total de Rodas Vendidas:"
		@_nLin,060      PSAY aTotRodaVend[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotRodaVend[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "Total de Seguros Rodas:"
		@_nLin,060      PSAY aTotSegRVend[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotSegRVend[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "(%) Aproveitamento:"
		@_nLin,060      PSAY (aTotSegRVend[1]/aTotRodaVend[1])*100 Picture "@E 999,999,999"

		_nLin := _nLin + 2
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000      PSAY "Total de Pneus Montados:"
		@_nLin,060      PSAY aTotMontVend[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotMontVend[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "Total de Seguros Pneus:"
		@_nLin,060      PSAY aTotSegPVend[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotSegPVend[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "(%) Aproveitamento:"
		@_nLin,060      PSAY (aTotSegPVend[1]/aTotMontVend[1])*100 Picture "@E 999,999,999"

		_nLin := _nLin + 2
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000      PSAY "Total:"
		@_nLin,060      PSAY _nTqt  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY _nTvlr Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "Total de Devolucao:"
		@_nLin,060      PSAY _nTdevqt  Picture "@E 999,999,999" //PesqPict("SD1","D1_QUANT")
		@_nLin,pCol()+2 PSAY _nTdevlr  Picture PesqPict("SD1","D1_TOTAL")
		_nLin++
		@_nLin,000      PSAY "Total de TAC:"
		@_nLin,060      PSAY _nTTACqt  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY _nTTACvl  Picture PesqPict("SD2","D2_TOTAL")
	Enddo

	If lImp
		_nLin :=  _nLin + 3

		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000      PSAY "Total Geral de Rodas Vendidas:"
		@_nLin,060      PSAY aTotRodaGer[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotRodaGer[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "Total Geral de Seguros Rodas:"
		@_nLin,060      PSAY aTotSegRGer[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotSegRGer[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "(%) Aproveitamento:"
		@_nLin,060      PSAY (aTotSegRGer[1]/aTotRodaGer[1])*100 Picture "@E 999,999,999"

		_nLin := _nLin + 2
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000      PSAY "Total Geral de Pneus Montados:"
		@_nLin,060      PSAY aTotMontGer[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotMontGer[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "Total Geral de Seguros Pneus:"
		@_nLin,060      PSAY aTotSegPGer[1] Picture "@E 999,999,999"
		@_nLin,pCol()+2 PSAY aTotSegPGer[2] Picture PesqPict("SD2","D2_TOTAL")
		_nLin++
		@_nLin,000      PSAY "(%) Aproveitamento:"
		@_nLin,060      PSAY (aTotSegPGer[1]/aTotMontGer[1])*100 Picture "@E 999,999,999"

		_nLin := _nLin + 2
		IF _nLin > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			_nLin := 9
		EndIF

		@_nLin,000      PSAY "Total Geral dos Vendedores: "
		@_nLin,060      PSAY _nTgqt  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY _nTgvlr Picture PesqPict("SD2","D2_TOTAL")
		_nLin := _nLin + 1

		@_nLin,000      PSAY "Total Geral de Devolucao dos Vendedores: "
		@_nLin,060      PSAY _nTgdevqt  Picture "@E 999,999,999" //PesqPict("SD1","D1_QUANT")
		@_nLin,pCol()+2 PSAY _nTgdevlr  Picture PesqPict("SD1","D1_TOTAL")
		_nLin := _nLin + 1

		@_nLin,000      PSAY "Total Geral de TAC Vendedores: "
		@_nLin,060      PSAY _nTgTACqt  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY _nTgTACvl  Picture PesqPict("SD2","D2_TOTAL")
		_nLin := _nLin + 2

		@_nLin,000      PSAY "Total Geral dos Alinhadores e Montadores: "
		@_nLin,060      PSAY _nTgqtAM  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY _nTgvlrAM Picture PesqPict("SD2","D2_TOTAL")
		_nLin := _nLin + 1

		@_nLin,000      PSAY "Total Geral de Devolucao dos Alinhadores e Montadores: "
		@_nLin,060      PSAY _nTgdevqtAM  Picture "@E 999,999,999" //PesqPict("SD1","D1_QUANT")
		@_nLin,pCol()+2 PSAY _nTgdevlrAM  Picture PesqPict("SD1","D1_TOTAL")
		_nLin := _nLin + 1

		@_nLin,000      PSAY "Total Geral de TAC dos Alinhadores e Montadores: "
		@_nLin,060      PSAY _nTgTACqtAM  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY _nTgTACvlAM  Picture PesqPict("SD2","D2_TOTAL")
		_nLin := _nLin + 2

		@_nLin,000      PSAY "Total Geral: "
		@_nLin,060      PSAY (_nTgqt  + _nTgqtAM)  Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")
		@_nLin,pCol()+2 PSAY (_nTgvlr + _nTgvlrAM) Picture PesqPict("SD2","D2_TOTAL")
		_nLin := _nLin + 1

		@_nLin,000      PSAY "Total Geral de Devolucao: "
		@_nLin,060      PSAY (_nTgdevqt + _nTgdevqtAM) Picture "@E 999,999,999" //PesqPict("SD1","D1_QUANT")
		@_nLin,pCol()+2 PSAY (_nTgdevlr + _nTgdevlrAM) Picture PesqPict("SD1","D1_TOTAL")
		_nLin := _nLin + 1

		@_nLin,000      PSAY "Total Geral de TAC: "
		@_nLin,060      PSAY (_nTgTACqt + _nTgTACqtAM) Picture "@E 999,999,999" //PesqPict("SD2","D2_QUANT")

		@_nLin,pCol()+2 PSAY (_nTgTACvl + _nTgTACvlAM) Picture PesqPict("SD2","D2_TOTAL")

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

User Function fTipVend()
	Local   cTitulo  := ""
	Local   MvPar
	Local   MvParDef := ""
	Private aSit     := {}
	Private l1Elem   := .F.

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	cAlias := Alias()

	dbSelectArea("PAG")
	dbSetOrder(1)
	dbGoTop()
	Do while !eof()
		aAdd(aSit,AllTrim(PAG_TIPO)+" - "+AllTrim(PAG_DESC))
		mvParDef := mvParDef + AllTrim(PAG_TIPO)
		dbSkip()
	Enddo

	dbSelectArea(cAlias)

	cTitulo :="Tipo de venda"
	Do While .T. 
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
		if mvpar = Replicate("*",Len(mvParDef))
			MsgBox("Voce deve selecionar pelo menos 1 tipo de venda","Tipo de venda","STOP")
			Loop
		Else
			Exit
		Endif
	Enddo
Return MvParDef

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