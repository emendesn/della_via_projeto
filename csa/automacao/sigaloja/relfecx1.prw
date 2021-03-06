#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

User Function RelFecx()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1      := "Relatorio de Fechamento de Caixa"
Private cDesc2      := ""
Private cDesc3      := ""
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 78
Private tamanho     := "P"
Private nomeprog    := "RELFECX"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := ""
Private nLin        := 80
Private nPag		:= 0

Private Cabec1      := ""
Private Cabec2      := ""
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "RELFECX"
Private _cPerg     	:= "RELFCX"

Private cString 	:= "SL1"
Private _nTotal 	:= 0

// Dinheiro
Private  _nDinheiro := 0
Private  _aDinheiro := {}

// Cheque A Vista
Private  _nChequeAV := 0
Private  _aChequeAV := {}

// Cheque a Prazo
Private  _nChequePR := 0
Private  _aChequePR := {}

// Cartao de Credito
Private  _nTotCC 	:= 0
Private  _aTotCC 	:= {}

// Vales
Private _nVales 	:= 0
Private _aVales 	:= {}

// Convenio
Private _nConvenio 	:= 0
Private _aConvenio 	:= {}

// Financiado
Private _nFinanciado := 0
Private _aFinanciado := {}

// Cartao de Debito
Private _nTotCD := 0
Private _aTotCD := {}

// Outros
Private _nOutros := 0
Private _aOutros := {}

// Devolucoes
Private _nDevolucoes := 0
Private _aDevolucoes := {}

Private _nDevRessarcir := 0
Private _aDevRessarcir := {}

// Orcamentos em aberto
Private _nOrcAberto	:= 0
Private _aOrcAberto	:= {}

Private _nLin := _nTotCheque := 0

Private _nCont := 0
Private _x := 0
Private	_bAchouDevolucao := .F.

// Sangria Dinheiro
Private	_DINHEIRO   := 0
Private	_aSDINHEIRO := {}

// Sangria Cheque
Private _CHEQUE := 0
Private _aSCHEQUE := {}

// Sangria Cartao de Credito
Private _CARTAOCREDITO := 0
Private _aSCARTAOCREDITO := {}

// Sangria Vale
Private _VALES := 0
Private _aSVALES := {}

// Sangria Convenio
Private	_CONVENIO := 0
Private	_aSCONVENIO := {}

// Sangria Financiado
Private _FINANCIADO := 0
Private _aSFINANCIADO := {}

// Sangria Cartao de Debito
Private _DEBITO := 0
Private _aSDEBITO := {}

// Sangria Outros
Private _Outros := 0
Private _aSOutros := {}

// Credito de Venda
Private _CREDVENDA := 0
Private _aSCREDVENDA := {}

// Transferencias
Private _TRANSFERENCIAS := 0
Private _aSTRANSFERENCIAS := {}

Private _nSangriaTotal := 0

//Cartao de Credito
Private	_aCodCC	 			:= {}
Private _aNomeCC 			:= {}
Private _aVlCreditoVista	:= {}
Private _aCCTaxa 			:= {}
Private _aRegCC 			:= {}

//Cartao de Debito Automatico
Private	_aCodCD	 			:= {}
Private _aNomeCD 			:= {}
Private _aVlCDVista			:= {}
Private _aVlDebitoParcelado	:= {}
Private _aCDTaxa			:= {}
Private _aDiasVirada		:= {}
Private _aRegCDAV 			:= {}
Private _aRegCDPC 			:= {}

//Financiamento
Private _aCodFI				:= {}
Private _aNomeFI			:= {}
Private _aVlFI				:= {}
Private _aFITaxa			:= {}
Private _aRegFI 			:= {}

//Convenio
Private _aCodCO				:= {}
Private _aNomeCO			:= {}
Private _aVlCO				:= {}
Private _aCOTaxa			:= {}
Private _aRegCO 			:= {}

//Vales
Private _aCodVA				:= {}
Private _aNomeVA			:= {}
Private _aVlVA				:= {}
Private _aVATaxa			:= {}
Private _aRegVA 			:= {}

//Outros
Private _aCodOutros 		:= {}
Private _aNomeOutros		:= {}
Private _aVlOutros			:= {}
Private _aOutrosTaxa		:= {}
Private _aRegOutros			:= {}

CloseOpen({"SL1"},{"SL1"})
dbSelectArea("SL1")
dbSetOrder(5)


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta a interface padrao com o usuario...                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Pergunte(_cPerg,.F.)
wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( {|| Impressao() } )

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔un뇙o    쿝UNREPORT � Autor � AP5 IDE            � Data �  01/06/00   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 볍�
굇�          � monta a janela com a regua de processamento.               볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Programa principal                                         볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

//Static Function RunReport()

Static Function Impressao()
Local cSL1 := RetSQLName("SL1")

_cTime := Time()

PegaAdministradoras()
ProcRegua(100)

cSQL := "select * from " + cSL1
cSQL += " where D_E_L_E_T_ <> '*' "
cSQL += "and L1_FILIAL = '" + xFilial("SL1") + "' "
cSQL += "and L1_OPERADO = '" + MV_PAR01 + "' "
cSQL += "and L1_EMISNF >= '" + DtoS(MV_PAR02) + "' "
cSQL += "and L1_EMISNF <= '" + DtoS(MV_PAR03) + "' "
cSQL += "and L1_SERIE >= '" + MV_PAR05 + "' "
cSQL += "and L1_SERIE <= '" + MV_PAR06 + "' "
cSQL += "order by L1_EMISNF"

tcQuery cSQL New Alias "TRBSL1"
tcSetField("TRBSL1", "L1_EMISSAO", "D")
tcSetField("TRBSL1", "L1_EMISNF" , "D")

While !EOF()
	IncProc()
	
	//verifica se o orcamento foi faturado
	IF EMPTY(ALLTRIM(TRBSL1->L1_DOC))
		_nOrcAberto += TRBSL1->L1_VLRTOT
		AADD(_aOrcAberto,{"OA",TRBSL1->L1_NUM,TRBSL1->L1_SERIE,TRBSL1->L1_CLIENTE,,TRBSL1->L1_VEND,TRBSL1->L1_VLRTOT})
		Dbskip()
		Loop
	ENDIF
	
	//verifica se a nf/cupom � um credito de venda
	IF Alltrim(Mv_Par01) == Alltrim(TRBSL1->L1_OPERADO)
		_CREDVENDA := _CREDVENDA + TRBSL1->L1_CREDITO
	EndIF
	
	//VALOR EM DINHEIRO
	IF TRBSL1->L1_DINHEIR != 0
		_nDinheiro = _nDinheiro + TRBSL1->L1_DINHEIR
		AADD(_aDinheiro,{"R$",TRBSL1->L1_DOC,TRBSL1->L1_SERIE,TRBSL1->L1_CLIENTE,,TRBSL1->L1_VEND,TRBSL1->L1_DINHEIR})
	Endif
	
	dbSelectArea("TRBSL1")
	
	//VALOR EM CHEQUES (A VISTA / PRAZO)
	IF TRBSL1->L1_CHEQUES != 0
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+TRBSL1->L1_SERIE+TRBSL1->L1_DOC))
		WHILE !SE1->(EOF()) .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == TRBSL1->L1_SERIE .AND. ;
			SE1->E1_NUM == TRBSL1->L1_DOC
			if alltrim(SE1->E1_TIPO) == "CH"    

			    If SE1->E1_MSFIL # xFilial("SL1") 
			    	SE1->(dbSkip())
			    	Loop
			    Endif	
					
				IF SE1->E1_VENCTO == TRBSL1->L1_EMISNF
					_nChequeAV = _nChequeAV + SE1->E1_VALOR
					AADD(_aChequeAV,{"CH",SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR})
				ELSE
					_nChequePR = _nChequePR + SE1->E1_VALOR
					AADD(_aChequePR,{"CH",SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR})
				ENDIF
				_nTotCheque := _nTotCheque + SE1->E1_VALOR
			endif
			SE1->(dbSkip())
			IncProc()
		ENDDO
	ENDIF
	
	
	//VALOR EM CARTAO DE CREDITO
	IF TRBSL1->L1_CARTAO != 0
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+TRBSL1->L1_SERIE+TRBSL1->L1_DOC))
		WHILE !SE1->(EOF()) .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == TRBSL1->L1_SERIE .AND. ;
			SE1->E1_NUM == TRBSL1->L1_DOC
			if  alltrim(SE1->E1_TIPO) == "CC"
				_x := 1
				While _x <= Len(_aCodCC)
					IF _aCodCC[_x] == ALLTRIM(SE1->E1_CLIENTE)
						_aVlCreditoVista[_x] := _aVlCreditoVista[_x] + SE1->E1_VLRREAL
						_nTotCC := _nTotCC + SE1->E1_VLRREAL
						AADD(_aRegCC,{_aCodCC[_x],SE1->E1_NUM,SE1->E1_SERIE,TRBSL1->L1_CLIENTE,,SE1->E1_VEND1,SE1->E1_VLRREAL,SE1->E1_VLRREAL*_aCCTaxa[_x]/100})
					ENDIF
					_x++
				enddo
			endif
			SE1->(dbSkip())
			IncProc()
		ENDDO
	ENDIF
	
	
	//VALOR EM VALES/RECEITAS
	IF TRBSL1->L1_VALES != 0
		_nVales = _nVales + TRBSL1->L1_VALES
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+TRBSL1->L1_SERIE+TRBSL1->L1_DOC))
		WHILE !SE1->(EOF()) .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == TRBSL1->L1_SERIE .AND. ;
			SE1->E1_NUM == TRBSL1->L1_DOC
			if  alltrim(SE1->E1_TIPO) == "VA"
				_x := 1
				While _x <= Len(_aCodVA)
					IF _aCodVA[_x] == alltrim(SE1->E1_CLIENTE)
						_aVlVA[_x] := _aVlVA[_x] + ((SE1->E1_VALOR*100)/(100-_aVATaxa[_x]))
						_aVlVA[_x] := round(_aVlVA[_x],2)
						AADD(_aVales,{_aCodVA[_x],SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR})
					ENDIF
					_x++
				Enddo
			endif
			SE1->(dbSkip())
			IncProc()
		ENDDO
	ENDIF
	
	//VALOR EM CONVENIOS
	IF TRBSL1->L1_CONVENI != 0
		_nConvenio = _nConvenio + TRBSL1->L1_CONVENI
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+TRBSL1->L1_SERIE+TRBSL1->L1_DOC))
		WHILE !EOF() .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == TRBSL1->L1_SERIE .AND. ;
			SE1->E1_NUM == TRBSL1->L1_DOC
			if  alltrim(SE1->E1_TIPO) == "CO"
				_x := 1
				While _x <= Len(_aCodCO)
					IF _aCodCO[_x] == alltrim(SE1->E1_CLIENTE)
						_aVlCO[_x] := _aVlCO[_x] + ((SE1->E1_VALOR*100)/(100-_aCOTaxa[_x]))
						_aVlCO[_x] := round(_aVlCO[_x],2)
						AADD(_aConvenio,{_aCodCO[_x],SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR})
					ENDIF
					_x++
				Enddo
			endif
			SE1->(dbSkip())
			IncProc()
		ENDDO
	ENDIF
	
	//VALOR EM FINANCIAMENTO
	IF TRBSL1->L1_FINANC != 0
		
		_nFinanciado = _nFinanciado + TRBSL1->L1_FINANC
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+TRBSL1->L1_SERIE+TRBSL1->L1_DOC))
		WHILE !EOF() .AND. SE1->E1_FILIAL = xFilial("SE1") .AND. SE1->E1_PREFIXO = TRBSL1->L1_SERIE .AND. ;
			SE1->E1_NUM = TRBSL1->L1_DOC
			if  alltrim(SE1->E1_TIPO) $ "FI&DP"
				_x := 1
				While _x <= Len(_aCodFI)
					IF _aCodFI[_x] == alltrim(SE1->E1_CLIENTE)
						_aVlFI[_x] := _aVlFI[_x] + ((SE1->E1_VALOR*100)/(100-_aFITaxa[_x]))
						_aVlFI[_x] := round(_aVlFI[_x],2)
						AADD(_aFinanciado,{_aCodFI[_x],SE1->E1_NUM,SE1->E1_SERIE,TRBSL1->L1_CLIENTE,,SE1->E1_VEND1,SE1->E1_VALOR,SE1->E1_VALOR})
						//						AADD(_aFinanciado,{_aCodFI[_x],SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR})
					ENDIF
					_x++
				Enddo
			endif
			SE1->(dbSkip())
			IncProc()
		ENDDO
	ENDIF
	
	//VALOR EM CARTAO DE DEBITO AUTOMATICO
	IF TRBSL1->L1_VLRDEBI != 0
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+TRBSL1->L1_SERIE+TRBSL1->L1_DOC))
		WHILE !EOF() .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == TRBSL1->L1_SERIE .AND. ;
			SE1->E1_NUM == TRBSL1->L1_DOC
			if  alltrim(SE1->E1_TIPO) == "CD"
				_x := 1
				While _x <= Len(_aCodCD)
					IF _aCodCD[_x] == alltrim(SE1->E1_CLIENTE)
						IF SE1->E1_VENCTO == (SE1->E1_EMISSAO+_aDiasVirada[_x])
							_aVlCDVista[_x] := _aVlCDVista[_x] + SE1->E1_VLRREAL
							AADD(_aRegCDAV,{_aCodCD[_x],SE1->E1_NUM,SE1->E1_SERIE,TRBSL1->L1_CLIENTE,,SE1->E1_VEND1,SE1->E1_VLRREAL,SE1->E1_VLRREAL*_aCDTaxa[_x]/100})
							//                            AADD(_aRegCDAV,{_aCodCD[_x],SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VLRREAL})
						ELSE
							_aVlDebitoParcelado[_x] := _aVlDebitoParcelado[_x] + SE1->E1_VLRREAL
							//                            AADD(_aRegCDPC,{_aCodCD[_x],SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VLRREAL})
							AADD(_aRegCDPC,{_aCodCD[_x],SE1->E1_NUM,SE1->E1_SERIE,TRBSL1->L1_CLIENTE,,SE1->E1_VEND1,SE1->E1_VLRREAL,SE1->E1_VLRREAL*_aCDTaxa[_x]/100})
						ENDIF
						_nTotCD := _nTotCD + SE1->E1_VLRREAL
					ENDIF
					_x++
				Enddo
			endif
			SE1->(dbSkip())
			IncProc()
		ENDDO
	ENDIF
	
	
	//VALOR EM OUTROS
	IF TRBSL1->L1_OUTROS != 0
		SL4->(dbSetOrder(1))
		SL4->(dbSeek(xFilial("SL4")+TRBSL1->L1_NUM))
		WHILE !EOF() .AND. SL4->L4_FILIAL == xFilial("SL4") .AND. SL4->L4_NUM == TRBSL1->L1_NUM
			IF !ALLTRIM(SL4->L4_FORMA) $ "CD&FI&VA&CO&CH&CC&R$&NCC"
				//a pedido da TMB em 22/10/01 foi colocada a descricao de cada forma de pagto
				_x := 1
				While _x <= Len(_aCodOutros)
					IF _aCodOutros[_x] == SUBSTR(SL4->L4_ADMINIS,1,3)
						_aVlOutros[_x] := SL4->L4_VALOR
						_nOutros = _nOutros + SL4->L4_VALOR
						AADD(_aRegOutros,{_aCodOutros[_x],TRBSL1->L1_DOC,TRBSL1->L1_SERIE,TRBSL1->L1_CLIENTE,,TRBSL1->L1_VEND,SL4->L4_VALOR,SL4->L4_VALOR*_aOutrosTaxa[_x]/100})
					ENDIF
					_x++
				enddo
				//				_nOutros = _nOutros + IIF(SE1->E1_VLRREAL <> 0, SE1->E1_VLRREAL, SE1->E1_VALOR)
				//				AADD(_aOutros,{SE1->E1_TIPO,SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR})
			Endif
			SL4->(dbSkip())
			IncProc()
		Enddo
	ENDIF
	
	TRBSL1->(dbSkip())
	IncProc()
EndDo

//Verifica Devolucoes

dbSelectArea("SD1")
dbSetOrder(6)
dbGoTop()
dbSeek(xFilial("SD1")+DTOS(MV_PAR02),.T.)
While !Eof() .AND. SD1->D1_FILIAL = xFilial("SD1") .AND. SD1->D1_DTDIGIT >= MV_PAR02 .AND.;
	SD1->D1_DTDIGIT <= MV_PAR03
	
	If SD1->D1_SERIE < MV_PAR05 .Or. SD1->D1_SERIE > MV_PAR06
		DbSelectArea("SD1")
		DbSkip()
		Loop
	Endif
	
	IF ALLTRIM(SD1->D1_TIPO) == "D" .And. Alltrim(Mv_Par01) == Alltrim(SD1->D1_NUMCQ)
		
		IF "UNI" $ SD1->D1_SERIORI
			_SERIEORI := SM0->M0_CODFIL + "U"
		ElseIF "CNF" $ SD1->D1_SERIORI
			_SERIEORI := SM0->M0_CODFIL + "N"
		Else
			_SERIEORI := Alltrim(MV_PAR01)
		EndIF
		
		_xVend := ""
		
		SF2->(DbSetOrder(1))
		IF SF2->(DbSeek(xFilial("SF2")+SD1->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA)))
			_xVend := SF2->F2_VEND1
		EndIF
		
		If SF2->F2_EMISSAO == MV_PAR03 // se � uma devolucao do mesmo dia ou nao
			
			_nDevolucoes := _nDevolucoes + SD1->D1_TOTAL - SD1->D1_VALDESC
			AADD(_aDevolucoes,{"DV",SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,,,SD1->D1_TOTAL,_SERIEORI+SD1->D1_NFORI,_xVend})
			
			_nSangriaTotal := _nSangriaTotal + SD1->D1_TOTAL - SD1->D1_VALDESC
		Else
			_bTemNCC := .F.
			SE1->(DbSetOrder(1))
			SE1->(DbSeek(xFilial("SE1")+SD1->(D1_SERIE+D1_DOC)))
			While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+SD1->(D1_SERIE+D1_DOC) .AND. !_bTemNCC
				_bTemNCC := IIF(ALLTRIM(SE1->E1_TIPO)=="NCC",.T.,.F.)
				SE1->(DbSkip())
			EndDo
			
			If _bTemNCC  // troca nao entra em dev. a ressarcir
				_nDevolucoes := _nDevolucoes + SD1->D1_TOTAL - SD1->D1_VALDESC
				AADD(_aDevolucoes,{"DV",SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,,,SD1->D1_TOTAL,_SERIEORI+SD1->D1_NFORI,_xVend})
				
				_nSangriaTotal := _nSangriaTotal + SD1->D1_TOTAL - SD1->D1_VALDESC
			Else
				_nDevRessarcir := _nDevRessarcir + SD1->D1_TOTAL - SD1->D1_VALDESC
				AADD(_aDevRessarcir,{"DV",SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,,,SD1->D1_TOTAL,_SERIEORI+SD1->D1_NFORI,_xVend})
			EndIf
			
		EndIf
	EndIf
	
	SD1->(DBSKIP())
	IncProc()
EndDo

_nTotal := _nDinheiro + _nChequeAV + _nChequePR + _nTotCC + _nVales + _nConvenio + ;
_nFinanciado + _nTotCD + _nOutros + _CREDVENDA


//Verifica Sangrias
dbSelectArea("SE5")
dbSetOrder(1)
Set Softseek on
dbSeek(xFilial("SE5")+DTOS(MV_PAR02))
Set Softseek off
While !Eof() .AND. SE5->E5_FILIAL = xFilial("SE5") .AND. SE5->E5_DATA >= MV_PAR02 .AND.;
	SE5->E5_DATA <= MV_PAR03
	
	IF ALLTRIM(E5_NATUREZ) == "SANGRIA" .AND. SE5->E5_BANCO = MV_PAR01
		IF ALLTRIM(E5_TIPODOC) == "TE"
			_TRANSFERENCIAS := _TRANSFERENCIAS + E5_VALOR
			
		ELSE
			DO Case
				Case ALLTRIM(E5_MOEDA) == "R$"
					_DINHEIRO := _DINHEIRO + E5_VALOR
					AADD(_aSDINHEIRO,{"R$",SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
					
				Case ALLTRIM(E5_MOEDA) == "CH"
					_CHEQUE := _CHEQUE + E5_VALOR
					AADD(_aSCHEQUE,{"CH",SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "CC"
					_CARTAOCREDITO := _CARTAOCREDITO + E5_VALOR
					AADD(_aSCARTAOCREDITO,{"CC",SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "VA"
					_VALES := _VALES + E5_VALOR
					AADD(_aSVALE,{"VA",SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "CO"
					_CONVENIO := _CONVENIO + E5_VALOR
					AADD(_aSCONVENIO,{"C0",SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "FI"
					_FINANCIADO := _FINANCIADO + E5_VALOR
					AADD(_aSFINANCIADO,{"FI",SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "CD"
					_DEBITO := _DEBITO + E5_VALOR
					AADD(_aSDEBITO,{"CD",SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
				OtherWise
					_Outros := _Outros + E5_VALOR
					AADD(_aSOUTROS,{ALLTRIM(SE5->E5_MOEDA),SE5->E5_NUMCHEQ,SE5->E5_HISTOR,SE5->E5_VALOR})
					
			EndCase
			_nSangriaTotal := _nSangriaTotal + E5_VALOR
		EndIf
	ENDIF
	DBSKIP()
	IncProc()
EndDo

//_nSangriaTotal := _nSangriaTotal + _nDevolucoes

ImprimeRelatorio()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPgEject(.F.)                                                          
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

TRBSL1->(dbCloseArea())
RetIndex("SE5")
RetIndex("SAE")
RetIndex("SE1")

MS_FLUSH()

Return



/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿝ELFECX   튍utor  �                    � Data �  10/22/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function PegaAdministradoras()

dbSelectArea("SAE")
dbSetOrder(1)
dbSeek(xFilial("SAE"))

While !Eof() .AND. AE_FILIAL == xFilial("SAE")
	Do Case
		Case AE_TIPO == "CC"
			AADD(_aCodCC  ,SUBSTR(SAE->AE_COD,1,3))
			AADD(_aNomeCC ,SAE->AE_DESC)
			AADD(_aVlCreditoVista,0)
			AADD(_aCCTaxa,SAE->AE_TAXA)
		Case AE_TIPO == "CD"
			AADD(_aCodCD  ,SUBSTR(SAE->AE_COD,1,3))
			AADD(_aNomeCD ,SAE->AE_DESC)
			AADD(_aVlCDVista,0)
			AADD(_aVlDebitoParcelado,0)
			AADD(_aCDTaxa,SAE->AE_TAXA)
			AADD(_aDiasVirada,SAE->AE_DIAS)
		Case AE_TIPO == "CO"
			AADD(_aCodCO,SUBSTR(SAE->AE_COD,1,3))
			AADD(_aNomeCO,SAE->AE_DESC)
			AADD(_aVlCO,0)
			AADD(_aCOTaxa,SAE->AE_TAXA)
		Case AE_TIPO == "FI"
			AADD(_aCodFI  ,SUBSTR(SAE->AE_COD,1,3))
			AADD(_aNomeFI ,SAE->AE_DESC)
			AADD(_aVlFI,0)
			AADD(_aFITaxa,SAE->AE_TAXA)
		Case AE_TIPO == "VA"
			AADD(_aCodVA  ,SUBSTR(SAE->AE_COD,1,3))
			AADD(_aNomeVA ,SAE->AE_DESC)
			AADD(_aVlVA,0)
			AADD(_aVATaxa,SAE->AE_TAXA)
		OtherWise
			AADD(_aCodOutros,SUBSTR(SAE->AE_COD,1,3))
			AADD(_aNomeOutros,SAE->AE_DESC)
			AADD(_aVlOutros,0)
			AADD(_aOutrosTaxa,SAE->AE_TAXA)
	EndCase
	SAE->(DBSKIP())
	IncProc()
ENDDO
Return




/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿝ELFECX   튍utor  �                    � Data �  10/22/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function ImprimeRelatorio()

_nLin := 1
dbSelectArea("SE1")
dbGoTop()

ImpCab()

@ _nLin,000 PSAY "|"
_cTexto := "CREDITOS / VENDAS (Total Geral) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotal PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Dinheiro "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nDinheiro PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpDetalhe(_aDinheiro)

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cheques (Total) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotCheque PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cheques a Vista "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nChequeAV PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpDetalhe(_aChequeAV)

@ _nLin,000 PSAY "|"
_cTexto := "Cheques Pre Datados "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nChequePR PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpDetalhe(_aChequePR)

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cartoes de Credito (Total) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotCC PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodCC)
	If _aVlCreditoVista[_nCont] != 0
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeCC[_nCont]
		//		@ _nLin,042 PSAY _aCCTaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nLin,048 PSAY "%"
		@ _nLin,050 PSAY (_aVlCreditoVista[_nCont]*_aCCTaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY _aVlCreditoVista[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		ImpDetalhe(_aRegCC,_aCodCC[_nCont])
	Endif
Next

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Vales/Receitas "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nVales PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()


For _nCont:=1 to Len(_aCodVA)
	If _aVlVA[_nCont] != 0
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeVA[_nCont]
		//		@ _nLin,042 PSAY _aVATaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nLin,048 PSAY "%"
		@ _nLin,050 PSAY (_aVlVA[_nCont]*_aVATaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY round(_aVlVA[_nCont],2) PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		ImpDetalhe(_aVales,_aCodVA[_nCont])
	Endif
Next

@ _nLin,000 PSAY "|"
_cTexto := "Convenios "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nConvenio PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodCO)
	If _aVlCO[_nCont] != 0
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeCO[_nCont]
		//		@ _nLin,042 PSAY _aCOTaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nLin,048 PSAY "%"
		@ _nLin,050 PSAY (_aVlCO[_nCont]*_aCOTaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY round(_aVlCO[_nCont],2) PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		ImpDetalhe(_aConvenio,_aCodCO[_nCont])
	Endif
Next

@ _nLin,000 PSAY "|"
_cTexto := "Financiado "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nFinanciado PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodFI)
	If _aVlFI[_nCont] != 0
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeFI[_nCont]
		//		@ _nLin,042 PSAY _aFITaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nLin,048 PSAY "%"
		@ _nLin,050 PSAY (_aVlFI[_nCont]*_aFITaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY round(_aVlFI[_nCont],2) PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		ImpDetalhe(_aFinanciado,_aCodFI[_nCont])
	Endif
Next

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cartoes de Debito Automatico (Total) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotCD PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
@ _nLin,000 PSAY "|"
@ _nLin,006 PSAY "A Vista"
@ _nLin,079 PSAY "|"
AddLinha()


For _nCont:=1 to Len(_aCodCD)
	If _aVlCDVista[_nCont] != 0
		@ _nLin,000 PSAY "|"
		@ _nLin,010 PSAY _aNomeCD[_nCont]
		//		@ _nLin,042 PSAY _aCDTaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nlin,048 PSAY "%"
		@ _nLin,050 PSAY (_aVlCDVista[_nCont]*_aCDTaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY _aVlCDVista[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		ImpDetalhe(_aRegCDAV,_aCodCD[_nCont])
	Endif
Next

@ _nLin,000 PSAY "|"
@ _nLin,006 PSAY "A Prazo"
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodCD)
	If _aVlDebitoParcelado[_nCont] != 0
		@ _nLin,000 PSAY "|"
		@ _nLin,010 PSAY _aNomeCD[_nCont]
		//		@ _nLin,042 PSAY _aCDTaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nlin,048 PSAY "%"
		@ _nLin,050 PSAY (_aVlDebitoParcelado[_nCont]*_aCDTaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY _aVlDebitoParcelado[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		ImpDetalhe(_aRegCDPC,_aCodCD[_nCont])
	Endif
Next


@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Credito de Venda (Troca)"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CREDVENDA PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSCREDVENDA)

@ _nLin,000 PSAY "|"
_cTexto := "Outros "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nOutros PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodOutros)
	If _aVlOutros[_nCont] != 0
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeOutros[_nCont]
		//		@ _nLin,042 PSAY _aCCTaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nLin,048 PSAY "%"
		@ _nLin,050 PSAY (_aVlOutros[_nCont]*_aOutrosTaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY _aVlOutros[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		ImpDetalhe(_aRegOutros,_aCodOutros[_nCont])
	Endif
Next


@ _nLin,000 PSAY "|"
_cTexto := "Transferencias "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _TRANSFERENCIAS PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()


@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "DEBITOS / SANGRIAS (Total Geral Com Devolucoes)"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSangriaTotal PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

//    @ _nLin,000 PSAY "|"
//    @ _nLin,002 PSAY "(Total Geral Sem Devolu寤es)"
//    @ _nLin,065 PSAY (_nSangriaTotal-_nDevolucoes) PICTURE "@E 99,999,999.99"
//    @ _nLin,079 PSAY "|"
//    AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Dinheiro "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _DINHEIRO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSDINHEIRO)

@ _nLin,000 PSAY "|"
_cTexto := "Cheques "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CHEQUE PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSCHEQUE)


@ _nLin,000 PSAY "|"
_cTexto := "Cartao de Credito "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CARTAOCREDITO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSCARTAOCREDITO)


@ _nLin,000 PSAY "|"
_cTexto := "Vales/Despesas "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _VALES PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSVALES)


@ _nLin,000 PSAY "|"
_cTexto := "Convenios "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CONVENIO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSCONVENIO)


@ _nLin,000 PSAY "|"
_cTexto := "Financiado "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _FINANCIADO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSFINANCIADO)


@ _nLin,000 PSAY "|"
_cTexto := "Cartao de Debito automatico "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _DEBITO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSDEBITO)


@ _nLin,000 PSAY "|"
_cTexto := "Outros "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _Outros PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSOUTROS)

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()


@ _nLin,000 PSAY "|"
_cTexto := "Devolucoes "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nDevolucoes PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpDetalhe(_aDevolucoes)

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Saldo do Caixa"
@ _nLin,065 PSAY _nTotal-_nSangriaTotal PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
_cTexto := "Devolucoes a Ressarcir a Clientes"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nDevRessarcir PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpDetalhe(_aDevRessarcir)

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()
/*
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Orcamentos em Aberto"
@ _nLin,065 PSAY _nOrcAberto PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpDetalhe(_aOrcAberto)

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()
*/
@ 66,000 PSAY "."
SetPrc(0,0)

Return

Static Function ImpSangria(aMatriz,cChave)

If _nLin > 54
	ImpCab()
Endif

If MV_PAR04 = 1
	Return
Endif

If len(aMatriz) = 0
	Return
Endif

lCab := .T.
For _n = 1 to len(aMatriz)
	
	If cChave = nil .OR. aMatriz[_n][1] = cChave
		if lCab
			
			@ _nLin,000 PSAY "|"
			@ _nLin,079 PSAY "|"
			_nLin := _nLin + 1
			
			@ _nLin,000 PSAY "|"
			@ _nLin,010 PSAY "Doc."
			@ _nLin,026 psay "Historico"
			@ _nLin,079 PSAY "|"
			_nLin := _nLin + 1
			@ _nLin,000 PSAY "|"
			@ _nLin,010 PSAY "---------------"
			@ _nLin,026 psay "----------------------------------------"
			@ _nLin,079 PSAY "|"
			_nLin := _nLin + 1
			lCab := .F.
		Endif
		@ _nLin,000 PSAY "|"
		@ _nLin,010 PSAY aMatriz[_n][2]
		@ _nLin,026 psay Substr(aMatriz[_n][3],1,15)
		@ _nLin,065 psay aMatriz[_n][4]	PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		_nLin := _nLin + 1
		
	Endif
Next
@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

Return





/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿝ELFECX   튍utor  �                    � Data �  10/22/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function ImpDetalhe(aMatriz,cChave)

If _nLin > 54
	ImpCab()
Endif

If MV_PAR04 = 1
	Return
Endif

If len(aMatriz) = 0
	Return
Endif

lCab := .T.
For _n := 1 to len(aMatriz)
	
	If cChave == nil .OR. aMatriz[_n][1] == cChave
		if lCab
			
			@ _nLin,000 PSAY "|"
			@ _nLin,079 PSAY "|"
			AddLinha()
			
			@ _nLin,000 PSAY "|"
			@ _nLin,003 PSAY "Doc."
			@ _nLin,010 psay "Sr."
			@ _nLin,014 psay "Pedido"
			@ _nLIn,021 psay "Cliente"
			@ _nLin,029 psay "Nome"
			@ _nLin,049 psay "Vendedor"
			If Len(aMatriz[_n]) = 8 .and. Alltrim(aMatriz[_n,1]) != "DV"
				@ _nLin,057 psay " Taxa"
			Endif
			@ _nLin,079 PSAY "|"
			AddLinha()
			@ _nLin,000 PSAY "|"
			@ _nLin,003 PSAY "------"
			@ _nLin,010 psay "---"
			@ _nLin,014 PSAY "------"
			@ _nLIn,021 psay "------"
			@ _nLin,028 psay "-------------------"
			@ _nLin,049 psay "------"
			If Len(aMatriz[_n]) = 8 .and. Alltrim(aMatriz[_n,1]) != "DV"
				@ _nLin,057 psay "------"
			Endif
			@ _nLin,079 PSAY "|"
			AddLinha()
			lCab := .F.
		Endif
		If Empty(aMatriz[_n][5])
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xfilial("SA1")+aMatriz[_n][4])
				aMatriz[_n][5] := Substr(A1_NOME,1,20)
			Endif
		Endif
		
		SL1->(dbSetOrder(2))
		SL1->(dbSeek(xFilial("SL1") + aMatriz[_n][3] + aMatriz[_n][2]))
		
		@ _nLin,000 PSAY "|"
		@ _nLin,003 PSAY aMatriz[_n][2]
		@ _nLin,010 psay aMatriz[_n][3]
		@ _nLin,014 PSAY SL1->L1_NUM
		@ _nLIn,021 psay aMatriz[_n][4]
		@ _nLin,028 psay aMatriz[_n][5]
		If Len(aMatriz[_n]) = 9 .and. Alltrim(aMatriz[_n,1]) == "DV"
			@ _nLin,049 psay aMatriz[_n][9]
		Else
			@ _nLin,049 psay aMatriz[_n][6]
		EndIF
		If Len(aMatriz[_n]) = 8 .and. Alltrim(aMatriz[_n,1]) != "DV"
			@ _nLin,057 psay aMatriz[_n][8] picture "@E 999.99"
		Endif
		@ _nLin,065 psay aMatriz[_n][7]	PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
		
		IF Alltrim(aMatriz[_n,1]) == "DV"
			DbSelectArea("SE1")
			DbSetOrder(1)
			
			IF DbSeek(xFilial("SE1")+Alltrim(aMatriz[_n,8]))
				
				@ _nLin,000 PSAY "|"
				@ _nLin,079 PSAY "|"
				AddLinha()
				While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == xFilial("SE1")+Alltrim(aMatriz[_n,8])
					
					@ _nLin,000 PSAY "|"
					@ _nLin,020 PSAY SE1->E1_TIPO
					@ _nLin,040 PSAY IIF(SE1->E1_VLRREAL<>0,SE1->E1_VLRREAL,SE1->E1_VALOR) PICTURE "@E 99,999,999.99"
					@ _nLin,079 PSAY "|"
					AddLinha()
					
					SE1->(DbSkip())
					IncProc()
				EndDo
				@ _nLin,000 PSAY "|"
				@ _nLin,079 PSAY "|"
				AddLinha()
			EndIF
		EndIF
		
	Endif
Next
@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()
Return

Static Function ImpCab()
nPag += 1
If _nLin > 53
	@ _nLin,000 PSAY "|"
	@ _nLin,001 PSAY Replicate("-",limite)
	@ _nLin,079 PSAY "|"
	_nLin :=  1
Endif

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLIn,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Empresa : " + SM0->M0_NOMECOM + " - " + SM0->M0_FILIAL
@ _nLin,071 PSAY "Pag:"+Str(nPag,3)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,020 PSAY "FECHAMENTO DO CAIXA - "+If(Mv_par04==1,"SINTETICO","ANALITICO")
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Codigo: " + MV_PAR01
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Periodo do Movimento : de " + Dtoc(MV_PAR02) + " ate " + Dtoc(MV_PAR03) + ", as " +_cTime
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

Return



/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿝ELFECX   튍utor  �                    � Data �  10/22/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function AddLinha()

_nLin += 1
If _nLin > 54
	ImpCab()
Endif

Return
