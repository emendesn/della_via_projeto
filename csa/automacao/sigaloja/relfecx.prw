
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelFecx   บAutor  ณ 					 บ		ณ			  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณesta Rotina efetua o Fechamento do Caixa com o emissใo do   บฑฑ
ฑฑบ          ณrelatorio de fechamento analitica e Sintetico               บฑฑ                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DELLA VIA                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Data de Re-Impressao                                       บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณManutencao Efetuada                          	  บฑฑ
ฑฑบMarcelo Alณ14/11/05ณAjuste no valor de dinheiro com troco (333)        บฑฑ
ฑฑบMarcelo Alณ14/11/05ณTratado a Situacao quando se tem uma devolucao com บฑฑ
ฑฑบ          ณ        ณNCC e tem parcela com dinheiro para nao pegar os   บฑฑ
ฑฑบ          ณ        ณvalores da tabela SL4 (642)                        บฑฑ
ฑฑบMarcelo Alณ21/11/05ณAjustado para nao considerar lancamentos do        บฑฑ
ฑฑบMarcelo Alณ29/12/05ณValidacao da loja no lancamento de NCC do SE1      บฑฑ
ฑฑบMarcio Domณ07/02/06ณAlteracao no tratamento da devolucao de troca no   บฑฑ
ฑฑบ          ณ        ณSE5, a expressao 'DEV.\TROCA" foi substituida pelo บฑฑ
ฑฑบ          ณ        ณparametro MV_NATDEV								  บฑฑ
ฑฑบMarcio Domณ20/04/06ณAlteracao no tratamento de recebimentos parcial de บฑฑ
ฑฑบ          ณ        ณtitulos.											  บฑฑ
ฑฑศออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RelFecx(_dDataFech)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aOrd 		:= {}
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
Private _cPerg     	:= "" //"RELFCX"

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

// NCC
Private _nNcc := 0
Private _aNcc := {}

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
Private _nTransDeb 			:= 0
Private _nTransCrd 			:= 0
Private _aTransDeb		 	:= {}
Private _aTransCrd		 	:= {}
Private _aDetDeb			:= {}
Private _aDetCrd			:= {}

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
Private nSaldoCx			:= 0.00
Private ChqPrz:= "N"

// Recebimento
Private _aRecebTot			:= {}
Private _aRecebDet			:= {}
Private _aRecebCH			:= {}
Private _nRecebCH			:= 0
Private _nTotRecCH			:= 0

Private _cOperador	//ANTIGO MV_PAR01
Private _dEmissao	//ANTIGO MV_PAR02/03
Private _cTipoRel	//ANTIGO MV_PAR04 (Analitico ou Sintetico)
Private _cSerie		//ANTIGO MV_PAR05/06

CloseOpen({"SL1"},{"SL1"})
dbSelectArea("SL1")
dbSetOrder(5)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Pergunte(_cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( {|| Impressao(_dDataFech) } )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP5 IDE            บ Data ณ  01/06/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

//Static Function RunReport()

Static Function Impressao(_dDataFech)
Local cSL1 		:= RetSQLName("SL1")
Local cSE5 		:= RetSQLName("SE5")
Local _lrImp	:= .F.	
Local i          
Local _nPos     := 0
Local _nPos2	:= 0
Local _c		:= 0

_cTime := Time()

PegaAdministradoras()                                                                         

_cOperador	:=SLF->LF_COD		//ANTIGO MV_PAR01
_dEmissao	:= dDataBase 		//MV_PAR01		//ANTIGO MV_PAR02/03
_cTipoRel	:="2"           	//ANTIGO MV_PAR04
_cSerie		:= SLG->LG_SERIE	//ANTIGO MV_PAR05/06

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o Parametro for passado na funcao significa que e uma re-impressaoณ
//ณdo Relatorio de Fechamento do Caixa                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if _dDataFech <> nil	
	_dEmissao	:= _dDataFech
	_lrImp		:= .T.			//Re-Imprime
endif

ProcRegua(100)
cSQL := "select * from " + cSL1
cSQL += " where D_E_L_E_T_ <> '*' "
cSQL += "and L1_FILIAL = '" + xFilial("SL1") + "' "
cSQL += "and L1_OPERADO = '" +_cOperador+"'" //MV_PAR01 + "' "
cSQL += "and L1_EMISNF = '" + DtoS(_dEmissao) + "' "
//cSQL += "and L1_EMISNF <= '" + DtoS(MV_PAR03) + "' "
//cSQL += "and L1_SERIE >= '"+_cSerie+"'" //" + MV_PAR05 + "' "
//cSQL += "and L1_SERIE <= '"+_cSerie+"'"// + MV_PAR06 + "' "
cSQL += "order by L1_EMISNF"

tcQuery cSQL New Alias "TRBSL1"
tcSetField("TRBSL1", "L1_EMISSAO", "D")
tcSetField("TRBSL1", "L1_EMISNF" , "D")

_cL1Doc		:= ""
_cL1Serie	:= ""
While !EOF()
	IncProc()
	
	//verifica se a nf/cupom ้ um credito de venda
	IF Alltrim(_cOperador) == Alltrim(TRBSL1->L1_OPERADO)
		_CREDVENDA := _CREDVENDA + TRBSL1->L1_CREDITO
	EndIF
	
	IF EMPTY(TRBSL1->L1_SERIE) .AND. EMPTY(TRBSL1->L1_DOC)
		_cL1Serie	:= Trim(L1_SERPED)
		_cL1Doc 	:= Trim(L1_DOCPED)
	ELSE
		_cL1Serie	:= Trim(L1_SERIE)
		_cL1Doc  	:= Trim(L1_DOC)
	ENDIF

	_cSerieSE1	:= U_PegaSerie( _cL1Doc,_cL1Serie ) // Pega a Serie que esta gravado no Financei

	//VALOR EM DINHEIRO
	IF TRBSL1->L1_DINHEIR != 0
		If L1_DINHEIR > L1_VLRLIQ
			_nDinheiro = _nDinheiro + TRBSL1->L1_VLRLIQ
			AADD(_aDinheiro,{"R$",_cL1Doc,_cL1Serie,TRBSL1->L1_CLIENTE,,TRBSL1->L1_VEND,TRBSL1->L1_VLRLIQ})
		Else
			_nDinheiro = _nDinheiro + TRBSL1->L1_DINHEIR
			AADD(_aDinheiro,{"R$",_cL1Doc,_cL1Serie,TRBSL1->L1_CLIENTE,,TRBSL1->L1_VEND,TRBSL1->L1_DINHEIR})
	    Endif
	Endif
	
	dbSelectArea("TRBSL1")
	
	//VALOR EM CHEQUES (A VISTA / PRAZO)
	IF TRBSL1->L1_CHEQUES != 0
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+_cSerieSE1+_cL1Doc))

		WHILE !SE1->(EOF()) .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == _cSerieSE1 .AND. ;
			SE1->E1_NUM == _cL1Doc
			if alltrim(SE1->E1_TIPO) == "CH"
				
				If SE1->E1_MSFIL # xFilial("SL1")
					SE1->(dbSkip())
					Loop
				Endif
				// Procura o cheque na tabela SEF (Tabelas dos dados do Cheque)
				SEF->(dbSetOrder(3))   //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM+EF_SEQUENC
				SEF->(dbSeek(xFilial("SEF")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO))
				
				IF SE1->E1_VENCTO == TRBSL1->L1_EMISNF .Or. SE1->E1_VENCTO < TRBSL1->L1_EMISNF
					_nChequeAV = _nChequeAV + SE1->E1_VALOR
					AADD(_aChequeAV,{"CH",SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR,,;
								 	 SEF->EF_BANCO, SEF->EF_AGENCIA, SEF->EF_CONTA, SEF->EF_NUM, SEF->EF_TERCEIR  })
				ELSE
					_nChequePR = _nChequePR + SE1->E1_VALOR
					AADD(_aChequePR,{"CH",SE1->E1_NUM,SE1->E1_SERIE,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_VEND1,SE1->E1_VALOR,SE1->E1_VENCTO,;
					    			 SEF->EF_BANCO, SEF->EF_AGENCIA, SEF->EF_CONTA, SEF->EF_NUM, SEF->EF_TERCEIR	})
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
		SE1->(dbSeek(xFilial("SE1")+_cSerieSE1+_cL1Doc))
		WHILE !SE1->(EOF()) .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == _cSerieSE1 .AND. ;
			SE1->E1_NUM == _cL1Doc
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
		SE1->(dbSeek(xFilial("SE1")+_cSerieSE1+_cL1Doc))
		WHILE !SE1->(EOF()) .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == _cSerieSE1 .AND. ;
			SE1->E1_NUM == _cL1Doc
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
		SE1->(dbSeek(xFilial("SE1")+_cSerieSE1+_cL1Doc))
		WHILE !EOF() .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == _cSerieSE1 .AND. ;
			SE1->E1_NUM == _cL1Doc
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
		
		//		_nFinanciado = _nFinanciado + TRBSL1->L1_FINANC
		SE1->(DBGOTOP())
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+_cSerieSE1+_cL1Doc))
		WHILE !EOF() .AND. SE1->E1_FILIAL = xFilial("SE1") .AND. SE1->E1_PREFIXO = _cSerieSE1 .AND. ;
			SE1->E1_NUM = _cL1Doc
			if  alltrim(SE1->E1_TIPO) $ "FI&DP"
				_x := 1
				While _x <= Len(_aCodFI)
					IF _aCodFI[_x] == alltrim(SE1->E1_CLIENTE)
						_aVlFI[_x] := _aVlFI[_x] + SE1->E1_VLRREAL
//						_aVlFI[_x] := _aVlFI[_x] + ((SE1->E1_VLRREAL*100)/(100-_aFITaxa[_x]))
						_aVlFI[_x] := round(_aVlFI[_x],2)
						_nFinanciado:= _nFinanciado + SE1->E1_VLRREAL
						AADD(_aFinanciado,{_aCodFI[_x],SE1->E1_NUM,SE1->E1_SERIE,TRBSL1->L1_CLIENTE,,SE1->E1_VEND1,SE1->E1_VLRREAL,SE1->E1_VLRREAL})
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
		SE1->(dbSeek(xFilial("SE1")+_cSerieSE1+_cL1Doc))
		WHILE !EOF() .AND. SE1->E1_FILIAL == xFilial("SE1") .AND. SE1->E1_PREFIXO == _cSerieSE1 .AND. ;
			SE1->E1_NUM == _cL1Doc
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
			IF !ALLTRIM(SL4->L4_FORMA) $ "CD&FI&VA&CO&CH&CC&R$&NCC" .AND. ALLTRIM(SL4->L4_ORIGEM) <> "SIGATMK"
				//a pedido da TMB em 22/10/01 foi colocada a descricao de cada forma de pagto
				_x := 1
				While _x <= Len(_aCodOutros)
					IF _aCodOutros[_x] == SUBSTR(SL4->L4_ADMINIS,1,3)
						_aVlOutros[_x] := _aVlOutros[_x]+SL4->L4_VALOR
						_nOutros = _nOutros + SL4->L4_VALOR
						AADD(_aRegOutros,{_aCodOutros[_x],_cL1Doc,_cL1Serie,TRBSL1->L1_CLIENTE,,TRBSL1->L1_VEND,SL4->L4_VALOR,SL4->L4_VALOR*_aOutrosTaxa[_x]/100})
					ENDIF
					_x++
				enddo
			Endif
			SL4->(dbSkip())
			IncProc()
		Enddo
	ENDIF
	
	TRBSL1->(dbSkip())
	IncProc()
EndDo

//Recebimento  -  Marcelo Alcantara
dbSelectArea("SE5")
cSQLREC := "select * from " + cSE5
cSQLREC += " where D_E_L_E_T_ <> '*'"
cSQLREC += " and E5_BANCO = '" + _cOperador + "' "
cSQLREC += " and E5_RECPAG = 'R' and E5_TIPODOC = 'VL'"
cSQLREC += " and (E5_TIPO = 'NF' or E5_TIPO = 'DP' or E5_TIPO = 'FI' or E5_TIPO = 'BO')"
cSQLREC += " and E5_DATA = '" +DTOS(_dEmissao) + "'"
cSQLREC += "order by E5_MOEDA"

tcQuery cSQLREC New Alias "QREC"

_nTotRec	:= 0.00
_cDoca		:= ""                   

Do While !eof()
	//Verifica se e cheque Predatado ou a vista
	If QREC->E5_MOEDA = "CH" .and. _cDoca <> QREC->E5_PREFIXO+QREC->E5_NUMERO+QREC->E5_PARCELAQ+QREC->E5_TIPO
		_cPrefixo	:= QREC->E5_PREFIXO
		_cTitulo	:= QREC->E5_NUMERO
		_cParcela	:= QREC->E5_PARCELA
		_cTipo		:= QREC->E5_TIPO
		_cMoeda		:= "CH"
		_cCodCli	:= QREC->E5_CLIFOR
		_cLojaCli	:= QREC->E5_LOJA
		_cDescCli	:= Posicione("SA1",1,XFILIAL("SA1")+_cCodCLi+_cLojaCli,"A1_NOME")
		_nRecebCH   := 0
		_lMoedas	:= .F.
		_cMoeda		:= "  "
		DbSelectArea("SEF")
		dbSetOrder(3)
		dbSeek(xFilial("SEF")+_cPrefixo+_cTitulo+_cParcela+_cTipo)
			Do While EF_PREFIXO=_cPrefixo .and. EF_TITULO=_cTitulo .and. EF_PARCELA=_cParcela .and. EF_TIPO=_cTipo .and. !eof()
			If FieldPos("EF_EMISSAO") > 0
				If DTOS(EF_EMISSAO) <> (QREC->E5_DATA)
					dbSkip()
					Loop
				EndIf
			Endif

			If DTOS(EF_VENCTO) > (QREC->E5_DATA)
				If _cMoeda == "CH"
					_lMoedas	:= .T.
				Endif	
				_cMoeda:= "CHP"
			else
				If _cMoeda == "CHP"
					_lMoedas	:= .T.
				Endif	
				_cMoeda:= "CH"
			endif                    
			
			_nPos := Ascan(_aRecebTot, {|x| x[1] == _cMoeda} )

			_nPos2 := Ascan(_aRecebCH, {|x| x[6]+x[7]+x[8]+x[9]+x[2]+x[3] == SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM+SEF->EF_TITULO+SEF->EF_PARCELA} )
			
			If _nPos2 = 0
	
				aAdd(_aRecebCH,{_cPrefixo,_cTitulo,_cParcela,_cTipo,_cMoeda,SEF->EF_BANCO,SEF->EF_AGENCIA,SEF->EF_CONTA,SEF->EF_NUM,SEF->EF_VALOR,SEF->EF_VENCTO})
				_nRecebCh 	+= EF_VALOR
				_nTotRec	+= EF_VALOR
				
				If _nPos > 0
					_aRecebTot[_nPos][2]+= EF_VALOR
				Else
					aAdd(_aRecebTot, {_cMoeda, EF_VALOR})
				Endif                                               

			Endif	
				
//			_nChequeAv	+= EF_VALOR  
//			_nTotCheque	+= EF_VALOR  
//			_nTotRecCH  += EF_VALOR  
			dbSkip()
		EndDo       
		If _nRecebCH > 0
			_lRecebDet	:= .F.
			
			For _c := 1 to Len(_aRecebDet)
				If 	_aRecebDet[_c][1]+_aRecebDet[_c][2]+_aRecebDet[_c][3]+_aRecebDet[_c][4]+_aRecebDet[_c][5] = _cPrefixo+_cTitulo+_cParcela+_cTipo+_cMoeda
					_lRecebDet := .T.
				Endif	
			Next
			
			If !_lRecebDet
			   If !_lMoedas
				  	aAdd(_aRecebDet,{ _cPrefixo, _cTitulo, _cParcela, _cTipo, _cMoeda, _nRecebCH, _cCodCli, _cLojaCli, _cDescCli })	
				Else
				  	aAdd(_aRecebDet,{ _cPrefixo, _cTitulo, _cParcela, _cTipo, "CHP", _nRecebCH, _cCodCli, _cLojaCli, _cDescCli })								  	
				  	aAdd(_aRecebDet,{ _cPrefixo, _cTitulo, _cParcela, _cTipo, "CH" , _nRecebCH, _cCodCli, _cLojaCli, _cDescCli })								  					  	
				Endif				  	
			Endif	                       
		Endif	             
		DbSelectArea("QREC")
		_cDoca:= QREC->E5_PREFIXO+QREC->E5_NUMERO+QREC->E5_PARCELA+QREC->E5_TIPO
	EndIf
	// Para as Outras Formas de Pagto
	If QREC->E5_MOEDA # "CH"
		_nPos := Ascan(_aRecebTot, {|x| x[1] == QREC->E5_MOEDA} )
		If _nPos > 0
			_aRecebTot[_nPos][2]+= QREC->E5_VALOR
		Else
			aAdd(_aRecebTot, {QREC->E5_MOEDA, QREC->E5_VALOR})
		Endif
		aAdd(_aRecebDet,{ QREC->E5_PREFIXO, QREC->E5_NUMERO, QREC->E5_PARCELA, QREC->E5_TIPO,;
		QREC->E5_MOEDA, QREC->E5_VALOR, QREC->E5_CLIFOR, QREC->E5_LOJA, ;
		Posicione("SA1",1,XFILIAL("SA1")+QREC->E5_CLIFOR+QREC->E5_LOJA,"A1_NOME") })
		_nTotRec+= QREC->E5_VALOR
	EndIf
	dbSkip()
EndDo

//Verifica Devolucoes 
dbSelectArea("SD1")
dbSetOrder(6)
dbGoTop()
_cDocAnt:= "000000"
dbSeek(xFilial("SD1")+DTOS(_dEmissao),.T.)
While !Eof() .AND. SD1->D1_FILIAL = xFilial("SD1") .AND. SD1->D1_DTDIGIT >= _dEmissao .AND.;
	SD1->D1_DTDIGIT <= _dEmissao

	IF ALLTRIM(SD1->D1_TIPO) == "D" .And. Alltrim(_cOperador) == Alltrim(SD1->D1_NUMCQ) //se a devolucao foi feita pelo caixa
		
		_xVend := ""
		
		//Verifica se Tem NCC no Contas a Receber
		_bTemNCC := .F.
		SE1->(DbSetOrder(1))
		SE1->(DbSeek(xFilial("SE1")+SD1->(D1_SERIE+D1_DOC)))
		While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+SD1->(D1_SERIE+D1_DOC) .AND. !_bTemNCC
   			if SE1->E1_MSFIL == SD1->D1_FILIAL		//Se a NCC do financeiro for de outra loja desprezar
				_bTemNCC := IIF(ALLTRIM(SE1->E1_TIPO)=="NCC",.T.,.F.)
			EndIf
				
			SE1->(DbSkip())
		EndDo
		
		SF2->(DbSetOrder(1))
		IF SF2->(DbSeek(xFilial("SF2")+SD1->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA)))
			_xVend := SF2->F2_VEND1
		EndIF
		
		_nDevolucoes := _nDevolucoes + SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
		If _cDocAnt # SD1->D1_DOC
			AADD(_aDevolucoes,{"DV",SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,,,SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC,D1_SERIORI+SD1->D1_NFORI,_xVend})
		ELSE
			_aDevolucoes[len(_aDevolucoes)][7]+= SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
		Endif

//		If _bTemNCC		
			SE1->(DbSetOrder(1))
		
			If SF2->F2_EMISSAO = _dEmissao .Or. Empty(SD1->D1_NFORI) // Verifica se a devolucao e do mesmo dia ou de outra loja
				_nSangriaTotal := _nSangriaTotal + SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
			ELSE
				// Verifica se a devolu็ใo foi em dinheiro
				SE5->(DbSetOrder(7))
				If SE5->(DbSeek(XFILIAL("SE5")+SD1->D1_SERIE+SD1->D1_DOC)) .And. SE5->E5_TIPO = "R$" .And. SE5->E5_MSFIL=SD1->D1_FILIAL
					_nSangriaTotal := _nSangriaTotal + SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
				Endif
				// Verifica se a devolu็ใo ้ NCC
				SE1->(dBSetOrder(1))
				if SE1->(DbSeek(XFILIAL("SE1")+SD1->D1_SERIE+SD1->D1_DOC)) .And. SE1->E1_TIPO = "NCC" .And. SE1->E1_MSFIL=SD1->D1_FILIAL
					_nSangriaTotal := _nSangriaTotal + SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
				endif
			
			Endif
//		Endif	

		if _cDocAnt # SD1->D1_DOC //se for um novo documento de devolucao
			if !empty(D1_NFORI) .and. !empty(D1_SERIORI)

				_cSerieSE1	:= U_PegaSerie( SD1->D1_NFORI,SD1->D1_SERIORI ) // Pega a Serie que esta gravado no Financeiro

				SE1->(dBSetOrder(1))
				if !SE1->(DbSeek(xFilial("SE1")+ _cSerieSE1 + SD1->D1_NFORI))  //se nao encontrar o lancamento no financeiro
					parc_Dev()
			// Comentado por Marcelo Alcantara 14/11/05
			//	else
			//		If Trim(SE1->E1_TIPO)=="R$"
			//			parc_Dev()
			//		endif
				endif
			endif
        endif
	
			
			If _bTemNCC  // Se Tiver NCC
				_nTransCrd += SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
				_nPos := Ascan(_aTransCrd, {|x| x[2] == "NCC DEVOLUCAO"} )
				If _nPos == 0
					AADD(_aTransCrd,{"R","NCC DEVOLUCAO",SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC })
				Else
					_aTransCrd[_nPos,3] += SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
				Endif
    			//Para tratamento de um unico lancamento no relatorio detalhado por Documento
				_cExistdev:= .f.  
				for i:= 1 to Len(_aDetCrd)
					if _aDetCrd[i][1]== "NCC DEVOLUCAO" .and. _aDetCrd[i][2]== SD1->D1_DOC
						_aDetCrd[i][4]+= SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC 
						_cExistdev:= .T.
					endif
				next
				IF !_cExistdev		
					AADD(_aDetCrd,{"NCC DEVOLUCAO",SD1->D1_DOC,D1_FORNECE,SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_ICMSRET - SD1->D1_VALDESC })
				ENDIF	
			EndIf
	EndIf
	_cDocAnt:= SD1->D1_DOC
	SD1->(DBSKIP())
	IncProc()
EndDo

_nTotal := _nDinheiro + _nChequeAV + _nChequePR + _nTotCC + _nVales + _nConvenio + ;
_nFinanciado + _nTotCD + _nOutros + _CREDVENDA + _nTransCrd + _nTotRec 

//Verifica Sangrias
dbSelectArea("SE5")
cSQLSE5 := "select * from " + cSE5
cSQLSE5 += " where D_E_L_E_T_ <> '*' "
cSQLSE5 += "and E5_FILIAL = '" + xfilial("SE5") + "' "  //acrescentado por causa que no recebimento esta tratando por filial.
cSQLSE5 += "and E5_BANCO = '" + _cOperador + "' "
cSQLSE5 += "and E5_DATA = '" +DTOS(_dEmissao) + "'"
cSQLSE5 += "order by E5_DATA"

tcQuery cSQLSE5 New Alias "TRBSE5"
While !Eof()
	IF	TRBSE5->E5_BANCO = _cOperador
		IF ALLTRIM(E5_NATUREZ) = "SANGRIA" .and. E5_RECPAG = "P"
			DO Case
				Case ALLTRIM(E5_MOEDA) == "R$"
					_DINHEIRO := _DINHEIRO + E5_VALOR
					AADD(_aSDINHEIRO,{"R$",TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "CH"
					_CHEQUE := _CHEQUE + E5_VALOR
					AADD(_aSCHEQUE,{"CH",TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "CC"
					_CARTAOCREDITO := _CARTAOCREDITO + E5_VALOR
					AADD(_aSCARTAOCREDITO,{"CC",TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "VA"
					_VALES := _VALES + E5_VALOR
					AADD(_aSVALE,{"VA",TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "CO"
					_CONVENIO := _CONVENIO + E5_VALOR
					AADD(_aSCONVENIO,{"C0",TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "FI"
					_FINANCIADO := _FINANCIADO + E5_VALOR
					AADD(_aSFINANCIADO,{"FI",TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
				Case ALLTRIM(E5_MOEDA) == "CD"
					_DEBITO := _DEBITO + E5_VALOR
					AADD(_aSDEBITO,{"CD",TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
				OtherWise
					_Outros := _Outros + E5_VALOR
					AADD(_aSOUTROS,{ALLTRIM(TRBSE5->E5_MOEDA),TRBSE5->E5_NUMCHEQ,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR})
					
			EndCase
			_nSangriaTotal := _nSangriaTotal + E5_VALOR
		Else
			If ALLTRIM(E5_NATUREZ) = "SANGRIA" .and. E5_RECPAG = "R"
				_nTransCrd += TRBSE5->E5_VALOR
				_nPos := Ascan(_aTransCrd, {|x| x[2] == TRBSE5->E5_NATUREZ} )
				If _nPos == 0
					AADD(_aTransCrd,{TRBSE5->E5_RECPAG,TRBSE5->E5_NATUREZ,TRBSE5->E5_VALOR})
				Else
					_aTransCrd[_nPos,3] += TRBSE5->E5_VALOR
				Endif
				AADD(_aDetCrd,{TRBSE5->E5_NATUREZ,TRBSE5->E5_DOCUMEN,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR}) // Conforme levantamento do analista Marcelo
				_nTotal += TRBSE5->E5_VALOR
//			ElseIf TRBSE5->E5_RECPAG = 'P' .AND. TRIM(E5_TIPO)<>"R$" .and. Trim(E5_NATUREZ)<>"DEV./TROCA"
			ElseIf 	(TRBSE5->E5_RECPAG = 'P' .AND. TRIM(E5_TIPO)<>"R$" .And. TRIM(E5_TIPO)<>"CR" .and. Trim(E5_NATUREZ)=&(Trim(GetMv("MV_NATDEV"))));
			.Or.	(TRBSE5->E5_RECPAG = 'P' .And.Rtrim(TRBSE5->E5_MOEDA)="R$".And.Trim(TRBSE5->E5_NATUREZ)<>"SANGRIA")
				_nTransDeb += TRBSE5->E5_VALOR
				_nPos := Ascan(_aTransDeb, {|x| x[2] == TRBSE5->E5_NATUREZ} )
				If _nPos == 0
					AADD(_aTransDeb,{TRBSE5->E5_RECPAG,TRBSE5->E5_NATUREZ,TRBSE5->E5_VALOR})
				Else
					_aTransDeb[_nPos,3] += TRBSE5->E5_VALOR
				Endif
				AADD(_aDetDeb,{TRBSE5->E5_NATUREZ,TRBSE5->E5_DOCUMEN,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR}) // Conforme levantamento do analista Marcelo
				_nSangriaTotal += TRBSE5->E5_VALOR
/*			ElseIf TRBSE5->E5_RECPAG = 'P' .And. Empty(E5_TIPO) .And. Trim(E5_NATUREZ)=&(Trim(GetMv("MV_NATDEV")))
			
				_nTransCrd += SE5->E5_VALOR
				_nPos := Ascan(_aTransCrd, {|x| x[2] == "NCC DEVOLUCAO"} )
				If _nPos == 0
					AADD(_aTransCrd,{"R","NCC DEVOLUCAO",SE5->E5_VALOR})
				Else
					_aTransCrd[_nPos,3] += SE5->E5_VALOR
				Endif */
										
			ElseIf TRBSE5->E5_RECPAG = 'R' .And. TRBSE5->E5_TIPODOC # "LJ" .And. (AllTrim(TRBSE5->E5_TIPO) # "NCC" .And. AllTrim(TRBSE5->E5_TIPO) # "CR");
					.And. TRBSE5->E5_TIPODOC # "VL" .And. TRBSE5->E5_TIPODOC # "JR" .And. TRBSE5->E5_TIPODOC # "BA" .And. TRBSE5->E5_TIPODOC # "MT";
			        .And. TRBSE5->E5_TIPODOC # "DC"
				_nTransCrd += TRBSE5->E5_VALOR
				_nPos := Ascan(_aTransCrd, {|x| x[2] == TRBSE5->E5_NATUREZ} )
				If _nPos == 0
					AADD(_aTransCrd,{TRBSE5->E5_RECPAG,TRBSE5->E5_NATUREZ,TRBSE5->E5_VALOR})
				Else
					_aTransCrd[_nPos,3] += TRBSE5->E5_VALOR
				Endif
				AADD(_aDetCrd,{TRBSE5->E5_NATUREZ,TRBSE5->E5_DOCUMEN,TRBSE5->E5_HISTOR,TRBSE5->E5_VALOR}) // Conforme levantamento do analista Marcelo
				_nTotal += TRBSE5->E5_VALOR
			Endif
		Endif
	Endif
	DBSKIP()
	IncProc()
EndDo

// Roda Rotina de Fechamento
nSaldoCx:=(_nTotal-_nSangriaTotal)  //Calculo do Saldo
nRel:= 0	   	    			    //Tipo de Retorno do Relatorio

// Se nao For Re-Impressao roda rotina de Fechamento
If !_lrImp
	nRel:= FechaCx()
Else
	dbSelectArea("SA6")
	dbSeek(xFilial("SA6")+SLF->LF_COD)
	if A6_DATAABR<>_dEmissao
		nRel:= 1
	else
		nRel:= 0
		Sair()
	endif
	
Endif

if nRel <> 0
	_cTipoRel:= 1	//Relatorio Sintetico
	ImprimeRelatorio()
	_cTipoRel:= 2	//Relatorio Analitico
	ImprimeRelatorio()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SetPgEject(.F.)
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	TRBSE5->(dbCloseArea())
	TRBSL1->(dbCloseArea())
	QREC->(dbCloseArea())
	RetIndex("SE5")
	RetIndex("SAE")
	RetIndex("SE1")
	
	MS_FLUSH()
Endif
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFECX   บAutor  ณ                    บ Data ณ  10/22/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFECX   บAutor  ณ                    บ Data ณ  10/22/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImprimeRelatorio()
Local _nCont
Local i
Local _c
Local _nDet

_nLin := 1
dbSelectArea("SE1")
dbGoTop()

ImpCab()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Dinheiro "
ImpDetalhe(_aDinheiro)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nDinheiro PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cheques"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cheques a Vista "
ImpDetalhe(_aChequeAV)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nChequeAV PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cheques Pre Datados "
chqprz:= "S"
ImpDetalhe(_aChequePR)
chqprz:= "N"
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nChequePR PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cheques (Total) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotCheque PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cartoes de Credito"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodCC)
	If _aVlCreditoVista[_nCont] != 0
		_cTexto:= _aNomeCC[_nCont]
		ImpDetalhe(_aRegCC,_aCodCC[_nCont])
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeCC[_nCont]
		@ _nLin,065 PSAY _aVlCreditoVista[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Endif
Next

@ _nLin,000 PSAY "|"
_cTexto := "Cartoes de Credito (Total) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotCC PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()


//Cartao de Debito Automatico
@ _nLin,000 PSAY "|"
_cTexto := "Cartoes de Debito Automatico"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,006 PSAY "A Vista"
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodCD)
	If _aVlCDVista[_nCont] != 0
		_cTexto:= _aNomeCD[_nCont]
		ImpDetalhe(_aRegCDAV,_aCodCD[_nCont])
		@ _nLin,000 PSAY "|"
		@ _nLin,010 PSAY _aNomeCD[_nCont]

		@ _nLin,065 PSAY _aVlCDVista[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Endif
Next

@ _nLin,000 PSAY "|"
@ _nLin,006 PSAY "A Prazo"
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodCD)
	If _aVlDebitoParcelado[_nCont] != 0
		_cTexto:= _aNomeCD[_nCont]
		ImpDetalhe(_aRegCDPC,_aCodCD[_nCont])
		@ _nLin,000 PSAY "|"
		@ _nLin,010 PSAY _aNomeCD[_nCont]
		@ _nLin,065 PSAY _aVlDebitoParcelado[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Endif
Next

@ _nLin,000 PSAY "|"
_cTexto := "Cartoes de Debito Automatico (Total) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotCD PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

// Financiados
@ _nLin,000 PSAY "|"
_cTexto := "Financiado "
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodFI)
	If _aVlFI[_nCont] != 0
		_cTexto:= _aNomeFI[_nCont]
		ImpDetalhe(_aFinanciado,_aCodFI[_nCont])
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeFI[_nCont]
		//		@ _nLin,042 PSAY _aFITaxa[_nCont] PICTURE "@E 99.99"
		//		@ _nLin,048 PSAY "%"
		//@ _nLin,050 PSAY (_aVlFI[_nCont]*_aFITaxa[_nCont]/100) PICTURE "@E 99,999,999.99"
		@ _nLin,065 PSAY round(_aVlFI[_nCont],2) PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Endif
Next

@ _nLin,000 PSAY "|"
_cTexto := "Financiado (Total)"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nFinanciado PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

//Credito de Venda
@ _nLin,000 PSAY "|"
_cTexto := "Credito de Venda "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CREDVENDA PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
ImpSangria(_aSCREDVENDA)

//Outros
@ _nLin,000 PSAY "|"
_cTexto := "Outros "
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aCodOutros)
	If _aVlOutros[_nCont] != 0
		_cTexto:= _aNomeOutros[_nCont]
		ImpDetalhe(_aRegOutros,_aCodOutros[_nCont])
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY _aNomeOutros[_nCont]
		@ _nLin,065 PSAY _aVlOutros[_nCont] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Endif
Next

@ _nLin,000 PSAY "|"
_cTexto := "Outros (Total)"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nOutros PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

//*** Imprime Recebimentos de Titulos ***
_cTexto := "Recebimentos de Titulos"
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

aSort(_aRecebDet,,,{|x,y| x[5]+x[1]+x[2]+x[3]+x[7] > y[5]+y[1]+y[2]+y[3]+y[7]})
//@ _nLin,000 PSAY "|"
For _nCont:=1 to Len(_aRecebTot)
	_cX5Descr:= IF(_aRecebTot[_nCont][1]=="CHP","CHEQUE A PRAZO", AllTrim(Posicione("SX5",1,xFilial("SX5")+"24"+_aRecebTot[_nCont][1],"X5_DESCRI")))
	If _cTipoRel <> 1
		@ _nLin,000 PSAY "|"
		@ _nLin,079 PSAY "|"
		AddLinha()
		@ _nLin,000 PSAY "|"
		@ _nLin,002 PSAY _cX5Descr
		@ _nLin,079 PSAY "|"
		AddLinha()
		@ _nLin,000 PSAY "|"
		@ _nLin,003 PSAY "Pre"
		@ _nLin,007 psay "Titulo"
		@ _nLin,014 psay "Pa"
		@ _nLIn,017 psay "Tipo"
		@ _nLin,022 psay "Cliente"
		@ _nLin,031 psay "Nome"
		@ _nLin,079 PSAY "|"
		AddLinha()
		@ _nLin,000 PSAY "|"
		@ _nLin,003 PSAY "---"
		@ _nLin,007 psay "------"
		@ _nLin,014 psay "--"
		@ _nLIn,017 psay "----"
		@ _nLin,022 psay "------"
		@ _nLin,030 psay "-----------------------------"
		@ _nLin,079 PSAY "|"
		AddLinha()
		
		For i:=1 to Len(_aRecebDet)
			IF _aRecebDet[i][5]== _aRecebTot[_nCont][1]
				@ _nLin,000 PSAY "|"
				@ _nLin,003 PSAY _aRecebDet[i][1]					//Prefixo
				@ _nLin,007 psay _aRecebDet[i][2]					//Titulo
				@ _nLin,014 psay _aRecebDet[i][3]                   //Parcela
				@ _nLIn,017 psay _aRecebDet[i][4]                   //Tipo
				@ _nLin,022 psay _aRecebDet[i][7]                   //Cliente
				@ _nLin,030 psay _aRecebDet[i][9] PICTURE "@S30"    //Nome do Clieente
				@ _nLin,065 psay _aRecebDet[i][6] PICTURE "@E 99,999,999.99"  //Valor
				@ _nLin,079 PSAY "|"
				AddLinha()             
				If "CHEQUE" $ _cX5Descr  // Se o recebimento for cheque
					For _c:=1 to Len(_aRecebCH)                       
					
						If 	_aRecebDet[i][1]+_aRecebDet[i][2]+_aRecebDet[i][3]+_aRecebDet[i][4]+_aRecebDet[i][5] ==;
							_aRecebCH[_c][1]+_aRecebCH[_c][2]+_aRecebCH[_c][3]+_aRecebCH[_c][4]+_aRecebCH[_c][5] 
					
							@ _nLin,000 PSAY "|"		
							@ _nLin,003 PSAY "Bco:"+_aRecebCH[_c][06]+" Ag:"+_aRecebCH[_c][07]+" CC:" + _aRecebCH[_c][08]+" CH:" + _aRecebCH[_c][09]+" "+Dtoc(_aRecebCH[_c][11])+" Valor:"+Transform(_aRecebCH[_c][10],"@E 999,999.99")
							@ _nLin,079 PSAY "|"
							AddLinha()
							
						Endif	
							
					Next	    
			
					@ _nLin,000 PSAY "|"		
					@ _nLin,079 PSAY "|"
					AddLinha()
                                  
				Endif	
			Endif
		next
		@ _nLin,000 PSAY "|"
		@ _nLin,079 PSAY "|"
		AddLinha()
		
	EndIf
	@ _nLin,000 PSAY "|"
	@ _nLin,002 PSAY _cX5Descr+" "+Replicate("-",60-(Len(_cX5Descr)))+">"
	@ _nLin,065 PSAY _aRecebTot[_nCont][2] PICTURE "@E 99,999,999.99"
	@ _nLin,079 PSAY "|"
	AddLinha()
Next
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+" (TOTAL) "+Replicate("-",60-(Len(_cTexto)+9))+">"
@ _nLin,065 PSAY _nTotRec PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()
@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

// Outras Receitas
_cTexto := "Receitas"
If Len(_aTransCrd) > 0
	@ _nLin,000 PSAY "|"
	@ _nLin,002 PSAY _cTexto
	@ _nLin,079 PSAY "|"
	AddLinha()
	
	For _nCont:=1 to Len(_aTransCrd)
		If _aTransCrd[_nCont,3] != 0
			
			If _cTipoRel == 2
				@ _nLin,000 PSAY "|"
				@ _nLin,003 PSAY "Documento / Historico"
				@ _nLin,079 PSAY "|"
				AddLinha()
				@ _nLin,000 PSAY "|"
				@ _nLin,003 PSAY "--------------------------------------------------------------"
				@ _nLin,079 PSAY "|"
				AddLinha()
				
				For _nDet:=1 to Len(_aDetCrd)
					If _aDetCrd[_nDet,1] == _aTransCrd[_nCont,2]
						
						@ _nLin,000 PSAY "|"
						@ _nLin,003 PSAY Rtrim(Rtrim(_aDetCrd[_nDet,2])+"  "+_aDetCrd[_nDet,3])
						@ _nLin,065 PSAY _aDetCrd[_nDet,4] PICTURE "@E 99,999,999.99"
						@ _nLin,079 PSAY "|"
						AddLinha()
						
					Endif
				Next
				
				@ _nLin,000 PSAY "|"
				@ _nLin,079 PSAY "|"
				AddLinha()
				
			Endif
			
			@ _nLin,000 PSAY "|"
			
			if _aTransCrd[_nCont,2] =="NCC DEVOLUCAO"
				@ _nLin,006 PSAY "NCC DEVOLUCAO"
			Else
				if !empty (Posicione("SED",1,xFilial("SED")+_aTransCrd[_nCont,2],"ED_DESCRIC"))
					@ _nLin,006 PSAY Posicione("SED",1,xFilial("SED")+_aTransCrd[_nCont,2],"ED_DESCRIC")
				else
					@ _nLin,006 PSAY _aTransCrd[_nCont,2]
				endif
				
			endif
			@ _nLin,065 PSAY _aTransCrd[_nCont,3] PICTURE "@E 99,999,999.99"
			@ _nLin,079 PSAY "|"
			AddLinha()
			If _cTipoRel == 2
				@ _nLin,000 PSAY "|"
				@ _nLin,079 PSAY "|"
				AddLinha()
			Endif
			
		Endif
	Next
	@ _nLin,000 PSAY "|"
	@ _nLin,079 PSAY "|"
	AddLinha()
Endif

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTransCrd PICTURE "@E 99,999,999.99"
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
_cTexto := "CREDITOS / VENDAS (Total Geral) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotal PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "DEBITOS / SANGRIAS"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Dinheiro "
ImpSangria(_aSDINHEIRO)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _DINHEIRO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cheques "
ImpSangria(_aSCHEQUE)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CHEQUE PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cartao de Credito "
ImpSangria(_aSCARTAOCREDITO)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CARTAOCREDITO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cartao de Debito automatico "
ImpSangria(_aSDEBITO)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _DEBITO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Convenios "
ImpSangria(_aSCONVENIO)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _CONVENIO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Financiado "
ImpSangria(_aSFINANCIADO)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _FINANCIADO PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Outros "
@ _nLin,000 PSAY "|"
ImpSangria(_aSOUTROS)
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _Outros PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Devolucoes "
ImpDetalhe(_aDevolucoes)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nDevolucoes PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()


@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

// Despesas
_cTexto := "Despesas"
If Len(_aTransDeb) > 0
	@ _nLin,000 PSAY "|"
	@ _nLin,002 PSAY _cTexto
	@ _nLin,079 PSAY "|"
	AddLinha()
	
	For _nCont:=1 to Len(_aTransDeb)
		If _aTransDeb[_nCont,3] != 0
			
			If _cTipoRel == 2
				@ _nLin,000 PSAY "|"
				@ _nLin,003 PSAY "Documento / Historico"
				@ _nLin,079 PSAY "|"
				AddLinha()
				@ _nLin,000 PSAY "|"
				@ _nLin,003 PSAY "--------------------------------------------------------------"
				@ _nLin,079 PSAY "|"
				AddLinha()
				
				For _nDet:=1 to Len(_aDetDeb)
					If _aDetDeb[_nDet,1] == _aTransDeb[_nCont,2]
						
						@ _nLin,000 PSAY "|"
						@ _nLin,003 PSAY Rtrim(Rtrim(_aDetDeb[_nDet,2])+"  "+_aDetDeb[_nDet,3])
						@ _nLin,065 PSAY _aDetDeb[_nDet,4] PICTURE "@E 99,999,999.99"
						@ _nLin,079 PSAY "|"
						AddLinha()
						
					Endif
				Next
				
				@ _nLin,000 PSAY "|"
				@ _nLin,079 PSAY "|"
				AddLinha()
				
			Endif
			
			@ _nLin,000 PSAY "|"
			@ _nLin,006 PSAY Posicione("SED",1,xFilial("SED")+_aTransDeb[_nCont,2],"ED_DESCRIC")
			@ _nLin,065 PSAY _aTransDeb[_nCont,3] PICTURE "@E 99,999,999.99"
			@ _nLin,079 PSAY "|"
			AddLinha()
			If _cTipoRel == 2
				@ _nLin,000 PSAY "|"
				@ _nLin,079 PSAY "|"
				AddLinha()
			Endif
			
		Endif
	Next
	@ _nLin,000 PSAY "|"
	@ _nLin,079 PSAY "|"
	AddLinha()
Endif

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTransDeb PICTURE "@E 99,999,999.99"
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
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

ImpSeguro()

AddLinha()
AddLinha()
AddLinha()
AddLinha()

@ _nLin,000 Psay " Deposito efetuado por: _______________________________________________________"

AddLinha()
AddLinha()                                                                                        
AddLinha()
AddLinha()

@ _nLin,000 Psay " Caixa elaborado por:   _______________________________________________________"

AddLinha()
AddLinha()
AddLinha()
AddLinha()                                                                                        

@ _nLin,000 Psay " Conferido por:         _______________________________________________________"

AddLinha()
AddLinha()
AddLinha()
AddLinha()                                                                                        

@ _nLin,000 Psay "             POR FAVOR, ASSINAR E CARIMBAR TODOS OS CAMPOS ACIMA.              "


Return

Static Function ImpSangria(aMatriz,cChave)
Local _n

If _nLin > 54
	ImpCab()
Endif

If _cTipoRel = 1
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
			@ _nLin,002 PSAY _cTexto
			@ _nLin,079 PSAY "|"
			
			AddLinha()
			
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
		@ _nLin,026 psay Substr(aMatriz[_n][3],1,30)
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFECX   บAutor  ณ                    บ Data ณ  10/22/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpDetalhe(aMatriz,cChave)
Local _n

If _nLin > 54
	ImpCab()
Endif

If _cTipoRel = 1
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
			@ _nLin,002 PSAY _cTexto
			@ _nLin,079 PSAY "|"
			
			AddLinha()
			
			@ _nLin,000 PSAY "|"
			@ _nLin,003 PSAY "Doc."
			@ _nLin,010 psay "Sr."
			@ _nLin,014 psay "Pedido"
			@ _nLIn,021 psay "Cliente"
			@ _nLin,029 psay "Nome"
			@ _nLin,049 psay "Vendedor"
			if chqprz=="S"
				@ _nLin,058 pSay "Vencimento"
			endif
			@ _nLin,079 PSAY "|"
			AddLinha()
			@ _nLin,000 PSAY "|"
			@ _nLin,003 PSAY "------"
			@ _nLin,010 psay "---"
			@ _nLin,014 PSAY "------"
			@ _nLIn,021 psay "------"
			@ _nLin,028 psay "-------------------"
			@ _nLin,049 psay "--------"
			if chqprz=="S"
				@ _nLin,058 pSay "----------"
			endif
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
		if ChqPrz == "S"
			@ _nLin,057	 pSay aMatriz[_n][8]
		endif
		@ _nLin,065 psay aMatriz[_n][7]	PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe For Cheque Imprime os Dados de Banco, Agencia, Conta e Numero do chequeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF Len(aMatriz[_n]) > 8
		If Alltrim(aMatriz[_n,1]) == "CH"
			@ _nLin,000 PSAY "|"		
			@ _nLin,003 PSAY "Banco: " + aMatriz[_n][9]
			@ _nLin,015 PSAY "Ag.: " + aMatriz[_n][10]
			@ _nLin,027 PSAY "C/C.: " + aMatriz[_n][11]
			@ _nLin,045 PSAY "Num CH : " + aMatriz[_n][12]
			If aMatriz[_n][13]		//Se For Cheque de Terceiros
				@ _nLin,072 PSAY "Terc."
			EndIf
			@ _nLin,079 PSAY "|"
			AddLinha()
			@ _nLin,000 PSAY "|"
			@ _nLin,079 PSAY "|"
			AddLinha()
		EndIF
    Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe For Devolucao imprime as formas como foi paga na venda                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao para impressao do cabecalho do relatorio                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
@ _nLin,002 PSAY "Empresa : " + SM0->M0_NOMECOM + " - " + SM0->M0_NOME
@ _nLin,071 PSAY "Pag:"+Str(nPag,3)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,020 PSAY "FECHAMENTO DO CAIXA - "+If(_cTipoRel==1,"SINTETICO","ANALITICO")+"  -  "+If(nrel==1,"CAIXA FECHADO","CAIXA ABERTO")
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Periodo do Movimento : de " + Dtoc(_dEmissao) + " ate " + Dtoc(_dEmissao) + ", as " +_cTime
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao para adicionar linha no relatorio                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function AddLinha() //Acrescenta uma linha

_nLin += 1
If _nLin > 54
	ImpCab()
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFechaCx   บAutor  ณ Marcelo Alcantara  บ Data ณ  01/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta Funcao tem por finalidade verificar se os valores do  บฑฑ
ฑฑบ          ณ estao corretos e efetuar o fechamento do caixa             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณManutencao Efetuada                                บฑฑ
ฑฑบฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤบฑฑ
ฑฑบ          ณ        ณ                                                   บฑฑ
ฑฑบ          ณ        ณ                                                   บฑฑ
ฑฑบ          ณ        ณ                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FechaCx()
dbSelectArea("SLJ")
dbSetOrder(1)
dbGoTop()
dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0"))
nFundoCx	:= SLJ->LJ_FUNDOCX    
_dDtSangr   := SLJ->LJ_DTSANGR
dbCloseArea()
dbSelectArea("SA6")
dbSeek(xFilial("SA6")+SLF->LF_COD)

if A6_DATAABR<>_dEmissao //Verifica se o caixa esta aberto no dia atual
	Aviso("Caixa Fechado","O Caixa Nao esta Aberto nesta Data",{"OK"})
	sair()
	Return 0
Endif
if A6_DATAFCH=_dEmissao  //Verifica se o caixa ja esta fechado
	Aviso("Caixa Fechado","O Caixa ja Esta Fechado",{"OK"})
	sair()
	Return 0
endif
if nSaldoCx >= 0 .and. nSaldoCx <= nFundoCx  //se o saldo estiver dentro do fundo de caixa pocibilita fechar o caixa

	if Aviso("Fechamento do Caixa","O Saldo da Loja em "+DtoC(_dEmissao)+" ้ "+Transform(nSaldoCx, "@E 9,999,999.99")+;
		"             Deseja Fecha-lo Agora??",{"Sim","Nใo"}) == 2
		//Se a Resposta for nao verifica se imprime somente relatorio de conferencia
		if Aviso("Relatorio","Imprimir Relatorio para conferencia?",{"Sim","Nใo"}) == 1 
			Return 2
		else
			sair()
			Return 0
		endif
	Endif

	If _dDtSangr < _dEmissao
		Aviso("Sangria Automatica","Nao foi realizada a sangria automแtica !",{"OK"})
		sair()
		Return 0
	Else
		RecLock("SA6",.F.)
		SA6->A6_DATAFCH:= dDataBase
		SA6->A6_HORAFCH:= Time()
		SA6->A6_DATAABR:= CtoD("  /  /  ")
		SA6->A6_HORAABR:= ""
		SA6->A6_SALANT := nSaldoCx
		msUnlock()
		Aviso("FeChamento do Caixa","Fechamento do Caixa Realizado",{"OK"})
		return 1  
	Endif		
	
Else

	if Aviso("Fechamento do Caixa","O Saldo da Loja em "+DtoC(_dEmissao)+" ้ "+Transform(nSaldoCx, "@E 999,999.99")+;
		"  Nใo ้ possํvel Fechar o Caixa, pois Saldo esta Inconsistente! Deseja imprimir relatorio apenas para conferencia??",{"Sim","Nใo"},2) == 2
		sair()
		Return 0
	else
		Return 2
	Endif
Endif
dbCloseArea()

Static Function Sair()
TRBSL1->(dbCloseArea())
TRBSE5->(dbCloseArea())
QREC->(dbCloseArea())

RetIndex("SE5")
RetIndex("SAE")
RetIndex("SE1")


Static Function Parc_Dev()
SL1->(DbSetOrder(2))
SL1->(DbSeek(xFilial("SL1")+SD1->(D1_SERIORI+D1_NFORI)))
SL4->(DbSetOrder(1))
SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
WHILE !SL4->(EOF()) .and. SL4->L4_FILIAL+SL4->L4_NUM == xFilial("SL4")+SL1->L1_NUM
	IF TRIM(SL4->L4_FORMA)<>"R$"
		
		If SL1->L1_EMISNF < _dEmissao
			SL4->(DbSkip())
			Loop
		Endif
		
		IF TRIM(SL4->L4_FORMA)=="CH"
			IF SL4->L4_DATA == SL1->L1_EMISNF
				_nChequeAV = _nChequeAV + SL4->L4_VALOR
				AADD(_aChequeAV,{"CH",SL1->L1_DOC,SL1->L1_SERIE,SL1->L1_CLIENTE,POSICIONE("SA1",1, XFILIAL("SA1")+SL1->L1_CLIENTE,"A1_NOME"),SL1->L1_VEND,SL4->L4_VALOR})
			ELSE
				_nChequePR = _nChequePR + SL4->L4_VALOR
				AADD(_aChequePR,{"CH",SL1->L1_DOC,SL1->L1_SERIE,SL1->L1_CLIENTE,POSICIONE("SA1",1, XFILIAL("SA1")+SL1->L1_CLIENTE,"A1_NOME"),SL1->L1_VEND,SL4->L4_VALOR,SL4->L4_DATA})
			ENDIF
			_nTotCheque := _nTotCheque + SL4->L4_VALOR
		ELSEIF TRIM(SL4->L4_FORMA)=="CC"
			_x := 1
			While _x <= Len(_aCodCC)
				IF _aCodCC[_x] == SUBSTR(SL4->L4_ADMINIS,1,3)
					_aVlCreditoVista[_x] := _aVlCreditoVista[_x] + SL4->L4_VALOR
					_nTotCC := _nTotCC + SL4->L4_VALOR
					AADD(_aRegCC,{_aCodCC[_x],SL1->L1_DOC,SL1->L1_SERIE,SL1->L1_CLIENTE,,SL1->L1_VEND,SL4->L4_VALOR,SL4->L4_VALOR*_aCCTaxa[_x]/100})
				ENDIF
				_x++
			enddo
		ELSEIF TRIM(SL4->L4_FORMA)=="CD"
			_x := 1
			While _x <= Len(_aCodCD)
				IF _aCodCD[_x] == SUBSTR(SL4->L4_ADMINIS,1,3)
					_aVlCDVista[_x] := _aVlCDVista[_x] + SL4->L4_VALOR
					AADD(_aRegCDAV,{_aCodCD[_x],SL1->L1_DOC,SL1->L1_SERIE,TRBSL1->L1_CLIENTE,,SL1->L1_VEND,SL4->L4_VALOR,SL4->L4_VALOR*_aCCTaxa[_x]/100})
					_nTotCD := _nTotCD + SL4->L4_VALOR
				ENDIF
				_x++
			Enddo
			
		ELSEIF TRIM(SL4->L4_FORMA) $ "FI&DP"
			_x := 1
			While _x <= Len(_aCodFI)
				IF _aCodFI[_x] == SUBSTR(SL4->L4_ADMINIS,1,3)
					_aVlFI[_x] := _aVlFI[_x] + SL4->L4_VALOR
					_aVlFI[_x] := round(_aVlFI[_x],2)
					_nFinanciado = _nFinanciado + SL4->L4_VALOR
					AADD(_aFinanciado,{_aCodFI[_x],SL1->L1_DOC,SL1->L1_SERIE,TRBSL1->L1_CLIENTE,,SL1->L1_VEND,SL4->L4_VALOR,SL4->L4_VALOR})
				ENDIF
				_x++
			Enddo
			
		ENDIF
		
	ENDIF
	
	SL4->(DbSkip())
ENDDO

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao posicionar o registro no SFE e pegar o numero de serie do financeiro SE1 ณ
//ณSeguindo a regra do do Parameto MV_LJPREF                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function PegaSerie( _cDocVnd, _cSerieVnd )
local _aArea	:= GetArea()
local _cRet		:= ""

SF2->(dbSetOrder(1))  //Filial+doc+serie
SF2->(dbSeek(xFilial("SF2") + _cDocVnd + _cSerieVnd))
_cRet:= &(GETMV("MV_LJPREF"))

RestArea(_aArea)
Return _cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpSeguro บAutor  ณMarcelo Alcantara   บ Data ณ  05/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Static Function para impressado dos dados do seguro e do   บฑฑ
ฑฑบ          ณ sinistro emitidos pela loja                                บฑฑ
ฑฑฬออออออออออุออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณManutencao Efetuada                          	  บฑฑ
ฑฑบMarcelo   ณ11/11/05ณDeclaracao da variavel _cSerieSE1                  บฑฑ
ฑฑศออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpSeguro()
Local cPA8 		:= RetSQLName("PA8")

_nLin:= 55			// Coloca linha no final da pagina para comecar uma nova pagina
ImpCab()			// Imprime Cabe็alho

If _cTipoRel = 1	//Se For o Sintetico nao Imprime
	Return
Endif

//Seleciona os Registros correspontendes do Seguro
cSQL := "select * from " + cPA8
cSQL += " where D_E_L_E_T_ <> '*' "
cSQL += " and PA8_LOJSG = '" + cFilAnt + "' "
cSQL += " and PA8_DTSG = '" + DtoS(_dEmissao) + "' "
cSQL += " order by PA8_NFSG"
tcQuery cSQL New Alias "TRBPA8"
tcSetField("TRBPA8", "L1_DTSG", "D")

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY "Seguro de Pneu"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY "N. Fiscal  Serie  No Apolice  Valor Seguro  Nome Cliente     "
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY "---------  -----  ----------  ------------  -----------------------"
@ _nLin,079 PSAY "|"
AddLinha()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณImprime dados do Seguro  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Do While .Not. Eof()
	@ _nLin,000 PSAY "|"
	@ _nLin,001 PSAY TRBPA8->PA8_NFSG   
	@ _nLin,013 PSAY TRBPA8->PA8_SRSG  
	@ _nLin,020 PSAY TRBPA8->PA8_APOLIC
	@ _nLin,030 PSAY TRBPA8->PA8_VLRPRO PICTURE "@E 9,999,999.99"
	@ _nLin,045 PSAY TRBPA8->PA8_NOMCLI PICTURE "@S30"
	@ _nLin,079 PSAY "|"
	dbSkip()
	AddLinha()
EndDo
dbCloseArea()	//Fecha Tabela TRBPA8

//Seleciona os Registros correspontendes do Seguro Sinistrados
cSQL := "select * from " + cPA8
cSQL += " where D_E_L_E_T_ <> '*' "
cSQL += " and PA8_LOJSN = '" + cFilAnt + "' "
cSQL += " and PA8_DTSN = '" + DtoS(_dEmissao) + "' "
cSQL += " order by PA8_NFSN"
tcQuery cSQL New Alias "TRBPA8"
tcSetField("TRBPA8", "L1_DTSN", "D")

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY "Sinistro Emitidos"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY "N.Fisc Serie  Apolice  Orig  NF Orig Serie  Valor     Nome Cliente     "
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY "------ -----  -------  ----  ------- ----- ---------- -------------------"
@ _nLin,079 PSAY "|"
AddLinha()
             
Do While .Not. Eof()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณImprime dados do Sinistroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	@ _nLin,000 PSAY "|"
	@ _nLin,001 PSAY TRBPA8->PA8_NFSN  
	@ _nLin,009 PSAY TRBPA8->PA8_SRSN  
	@ _nLin,015 PSAY TRBPA8->PA8_APOLIC
	@ _nLin,025 PSAY TRBPA8->PA8_LOJSG
	@ _nLin,031 PSAY TRBPA8->PA8_NFSG  
	@ _nLin,039 PSAY TRBPA8->PA8_SRSG  
	@ _nLin,043 PSAY TRBPA8->PA8_VPROSN PICTURE "@E 999,999.99"
	@ _nLin,055 PSAY TRBPA8->PA8_NOMCLI PICTURE "@S23"
	@ _nLin,079 PSAY "|"
	dbSkip()
	AddLinha()
EndDo
dbCloseArea()	//Fecha Tabela TRBPA8

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()
Return Nil
