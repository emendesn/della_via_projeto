#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFINR01   ºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fechamento de caixa atraves do financeiro                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFINR01()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
Private nomeprog    := "DFINR01"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Fechamento Caixa"
Private nLin        := 80
Private nPag		:= 0

Private Cabec1      := ""
Private Cabec2      := ""
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "DFINR01"
Private _cPerg     	:= "DFIN01"

Private cString 	:= "SE1"
Private _nTotal 	:= 0
Private _nSTotal 	:= 0

// aHeader
Private _aHDin     := {}
Private _aHChqAV   := {}
Private _aHChqPR   := {}
Private _aHCC      := {}
Private _aHCDAV    := {}
Private _aHCDPR    := {}
Private _aHRec     := {}

Private _aHSDin    := {}
Private _aHSChqAV  := {}
Private _aHSChqPR  := {}
Private _aHSCC     := {}
Private _aHSCDAV   := {}
Private _aHSCDPR   := {}
Private _aHSJur    := {}
Private _aHSMul    := {}
Private _aHSDes    := {}
Private _aHSMRec   := {}
Private _aHSMPag   := {}
                         
// Saldo em aberto faturamento do dia 
Private _nSaldoDia := 0
Private _aSaldoDia := {}
Private _aHSalDia  := {} 

// Dinheiro
Private  _nDinheiro := 0
Private  _aDinheiro := {}

// Dinheiro - Debito
Private  _nSDinheiro := 0
Private  _aSDinheiro := {}

// Cheque A Vista
Private  _nChequeAV := 0
Private  _aChequeAV := {}

// Cheque A Vista - Debito
Private  _nSChequeAV := 0
Private  _aSChequeAV := {}

// Cheque A Vista - lista
Private  _nChqAV   := 0
Private  _aChqAV   := {}
Private  _aHCAV    := {}

// Cheque a Prazo
Private  _nChequePR := 0
Private  _aChequePR := {}

// Cheque a Prazo - Debito
Private  _nSChequePR := 0
Private  _aSChequePR := {}

// Cartao de Credito
Private  _nTotCC 	:= 0
Private  _aTotCC 	:= {}

// Cartao de Credito - Debito
Private  _nSTotCC 	:= 0
Private  _aSTotCC 	:= {}

// Cartao de Debito a vista
Private _nTotCDAV := 0
Private _aTotCDAV := {}

// Cartao de Debito a vista - Debito
Private _nSTotCDAV := 0
Private _aSTotCDAV := {}

// Cartao de Debito a prazo
Private _nTotCDAP := 0
Private _aTotCDAP := {}

// Cartao de Debito a prazo - Debito
Private _nSTotCDAP := 0
Private _aSTotCDAP := {}

// Total Cartao de Debito
Private _nTotCD := 0
Private _nSTotCD := 0

// Total Cartao de Debito - Debito
Private _nSTotCD := 0

// resumos de cartoes
Private _aResCC   := {}
Private _aResCDAV := {}
Private _aResCDAP := {}

// Receitas Multas
Private _nMultas 	:= 0
Private _aMultas 	:= {}

// Receitas Juros
Private _nJuros 	:= 0
Private _aJuros 	:= {}

// Despesas Descontos
Private _nDescontos	:= 0
Private _aDescontos	:= {}

// Despesas Pagamentos ( mov bancario )
Private _nMovPag    := 0
Private _aMovPag	:= {}

// Receitas Recebimentos ( mov bancario )
Private _nMovRec    := 0
Private _aMovRec	:= {}

// Receitas
Private _nReceitas  := 0

Private _nLin := 0

Private _nTotCheque := 0
Private _nSTotCheque := 0

Private _nCont := 0
Private _x := 0

Private _cTipoRel

dbSelectArea("SE1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs:={}
AAdd(_aRegs,{_cPerg,"01","Data Fechamento?"  ,"Data Fechamento?"  ,"Data Fechamento?"  ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Caixa?"            ,"Caixa?"            ,"Caixa?"            ,"mv_ch2","C", 3,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})

ValidPerg(_aRegs,_cPerg)
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpressaoºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para impressao do relatorio                         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Impressao()

LOCAL _nX,_nPos

Private _dDataFec := mv_par01
Private _cCaixa   := mv_par02

ProcRegua(100)

// movimentacoes no SE1 - titulos gerados automaticamente no dia

dbSelectArea("SE1")
dbSetOrder(6)
dbSeek(xFilial("SE1")+DTOS(_dDataFec))

While ! Eof() .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_EMISSAO == _dDataFec
	
	IncProc()
	
	_lTemCheque := TemCheque(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE)
	
	_lLiquidacao := Liquidacao(_dDataFec)

    // soma todos os titulos faturados no dia 
	If Alltrim(SE1->E1_ORIGEM) == "MATA460" 
		_nSaldoTit := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,_dDataFec,_dDataFec,SE1->E1_LOJA,SE1->E1_FILIAL)
        If _nSaldoTit > 0
			_nSaldoDia += _nSaldoTit
			AADD(_aSaldoDia,{SE1->E1_PREFIXO,SE1->E1_NUM,DtoC(SE1->E1_EMISSAO),SE1->E1_CLIENTE,SE1->E1_NOMCLI,DtoC(SE1->E1_VENCTO),_nSaldoTit})
			_aHSalDia := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Vencto",6,8},{"Cliente",5,30},{"Valor",7,13}}
		Endif	
	Endif
	
	// se o titulo foi gerado pela rotina de liquidacao e esta liquidado na data, e' uma reliquidacao
	_lReliquidacao := .F.
	If Alltrim(SE1->E1_ORIGEM) == "FINA460" .And. _lLiquidacao
		_lReliquidacao := .T.
	Endif
	
	// cheque a vista gerado pela liquidacao
	If SE1->E1_TIPO == "CH " .And. SE1->E1_VENCTO == SE1->E1_EMISSAO .And. Alltrim(SE1->E1_ORIGEM) == "FINA460"
		_nChqAV += SE1->E1_VALOR
		AADD(_aChqAV,{SE1->E1_NUM,SE1->E1_BCOCHQ,SE1->E1_AGECHQ,SE1->E1_CTACHQ,SE1->E1_NOMCLI,SE1->E1_VALOR})
		_aHCAV := {{"Cheque",1,15},{"Bco",2,3},{"Ag.",3,5},{"Conta",4,10},{"Cliente",5,13},{"Valor",6,13}}
	Endif

	// cheque a prazo gerado pela liquidacao
	If SE1->E1_TIPO == "CH " .And. SE1->E1_VENCTO <> SE1->E1_EMISSAO .And. Alltrim(SE1->E1_ORIGEM) == "FINA460"
		_nSChequePR += SE1->E1_VALOR
		AADD(_aSChequePR,{SE1->E1_NUM,SE1->E1_BCOCHQ,SE1->E1_AGECHQ,SE1->E1_CTACHQ,SE1->E1_NOMCLI,DtoC(SE1->E1_VENCTO),SE1->E1_VALOR})
		_aHSChqPR := {{"Cheque",1,15},{"Bco",2,3},{"Ag.",3,5},{"Conta",4,10},{"Cliente",5,13},{"Vencto",6,8},{"Valor",7,13}}
	Endif
	
	// cartao de credito gerado pela liquidacao
	If SE1->E1_TIPO == "CC " .And. ! _lReliquidacao .And. Alltrim(SE1->E1_ORIGEM) == "FINA460"
		_nSTotCC += SE1->E1_VALOR
		AADD(_aSTotCC,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_NOMCLI,DTOC(SE1->E1_VENCTO),SE1->E1_VALOR})
		_aHSCC := {{"Pr.",1,3},{"Tit.",2,6},{"Cliente",4,30},{"Vencto",5,8},{"Valor",6,13}}
	Endif
	
	// cartao de debito a vista gerado pela liquidacao
	If SE1->E1_TIPO == "CD " .And. SE1->E1_EMISSAO == SE1->E1_VENCTO .And. ! _lReliquidacao .And. Alltrim(SE1->E1_ORIGEM) == "FINA460"
		_nSTotCDAV += SE1->E1_VALOR
		AADD(_aSTotCDAV,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_NOMCLI,DTOC(SE1->E1_VENCTO),SE1->E1_VALOR})
		_aHSCDAV := {{"Pr.",1,3},{"Tit.",2,6},{"Cliente",4,30},{"Vencto",5,8},{"Valor",6,13}}
	Endif
	
	// cartao de debito a prazo gerado pela liquidacao
	If SE1->E1_TIPO == "CD " .And. SE1->E1_EMISSAO <> SE1->E1_VENCTO .And. ! _lReliquidacao .And. Alltrim(SE1->E1_ORIGEM) == "FINA460"
		_nSTotCDAP += SE1->E1_VALOR
		AADD(_aSTotCDAP,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_NOMCLI,DTOC(SE1->E1_VENCTO),SE1->E1_VALOR})
		_aHSCDPR := {{"Pr.",1,3},{"Tit.",2,6},{"Cliente",4,30},{"Vencto",5,8},{"Valor",6,13}}
	Endif                                                                
	
	dbSelectArea("SE1")
	dbSkip()
	
Enddo

// movimentacoes bancarias - sangrias

dbSelectArea("SE5")
dbSetOrder(1)
dbSeek(xFilial("SE5")+DtoS(_dDataFec))

While ! Eof() .And. SE5->E5_FILIAL == xFilial("SE5") .And. SE5->E5_DATA == _dDataFec
	
	IncProc()
	
	_lTemCheque := TemCheque(SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR)
	
	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek(xFilial("SE1")+SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))

	_cPreTit := SE1->E1_PREFIXO
	_cNumTit := SE1->E1_NUM
	_cDatTit := DtoC(SE1->E1_EMISSAO)
	_cCliTit := SE1->E1_CLIENTE
	_cNomTit := SE1->E1_NOMCLI
	_cValTit := SE1->E1_VALOR

	// valor total do titulo ( desconto, multa e juros estao separados )
	_nValorTot := SE5->E5_VALOR - SE5->E5_VLJUROS - SE5->E5_VLMULTA + SE5->E5_VLDESCO

	// baixa em dinheiro = baixa normal no banco caixa da loja sem preencher dados do cheque
	If SE5->E5_RECPAG == "R" .And. SE5->E5_MOTBX == "NOR" .And. SE5->E5_BANCO == _cCaixa .And. ;
		! _lTemCheque .And. (SE5->E5_TIPODOC == "BA" .Or. SE5->E5_TIPODOC == "VL")
		// Dinheiro recebido de titulos do dia e de dias anteriores
		_nDinheiro += _nValorTot
		AADD(_aDinheiro,{SE1->E1_PREFIXO,SE1->E1_NUM,DtoC(SE1->E1_EMISSAO),SE1->E1_CLIENTE,SE1->E1_NOMCLI,_nValorTot})
		_aHDin := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Cliente",5,30},{"Valor",6,13}}
	Endif
	
	// baixa em cheque a vista = baixa normal no banco caixa da loja com dados do cheque preenchidos
	If SE5->E5_RECPAG == "R" .And. SE5->E5_MOTBX == "NOR" .And. SE5->E5_BANCO == _cCaixa .And. ;
		_lTemCheque .And. (SE5->E5_TIPODOC == "BA" .Or. SE5->E5_TIPODOC == "VL")
		_nChequeAV += _nValorTot
		AADD(_aChequeAV,{SE5->E5_PREFIXO,SE5->E5_NUMERO,DtoC(SE1->E1_EMISSAO),SE5->E5_CLIFOR,SE1->E1_NOMCLI,_nValorTot})
		_aHChqAV := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Cliente",5,30},{"Valor",6,13}}

		_nChqAV += _nValorTot
		AADD(_aChqAV,{SEF->EF_NUM,SEF->EF_BANCO,SEF->EF_AGENCIA,SEF->EF_CONTA,SE1->E1_NOMCLI,_nValorTot})
		_aHCAV := {{"Cheque",1,15},{"Bco",2,3},{"Ag.",3,5},{"Conta",4,10},{"Cliente",5,13},{"Valor",6,13}}
	Endif
	
	// guarda receitas por juros
	If SE5->E5_RECPAG == "R" .And. SE5->E5_TIPODOC == "JR"
		_nJuros += SE5->E5_VALOR
		//AADD(_aJuros,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE5->E5_VALOR})
		AADD(_aJuros,{SE5->(E5_PREFIXO+"-"+E5_NUMERO+"-"+E5_PARCELA),SE5->E5_BENEF,SE5->E5_VALOR})
		_aHSJur := {{"Titulo",1,12},{"Cliente",2,20},{"Valor",3,13}}
	Endif
	
	// guarda receitas por multas
	If SE5->E5_RECPAG == "R" .And. SE5->E5_TIPODOC == "MT"
		_nMultas += SE5->E5_VALOR
		AADD(_aMultas,{SE5->(E5_PREFIXO+"-"+E5_NUMERO+"-"+E5_PARCELA),SE5->E5_BENEF,SE5->E5_VALOR})
		_aHSMul := {{"Titulo",1,12},{"Cliente",2,20},{"Valor",3,13}}
	Endif
	
	// guarda despesas por desconto
	If SE5->E5_RECPAG == "R" .And. SE5->E5_TIPODOC == "DC"
		_nDescontos += SE5->E5_VALOR
		AADD(_aDescontos,{SE5->(E5_PREFIXO+"-"+E5_NUMERO+"-"+E5_PARCELA),SE5->E5_BENEF,SE5->E5_VALOR})
		_aHSDes := {{"Titulo",1,12},{"Cliente",2,20},{"Valor",3,13}}
	Endif
	
	// guarda pagamentos feitos no caixa ( movimento bancario )
	If SE5->E5_RECPAG == "P" .And. ! Empty(SE5->E5_MOEDA) .And. SE5->E5_BANCO == _cCaixa
        // outras movimentacoes
		If SE5->E5_MOEDA == "M1"
			_nMovPag += SE5->E5_VALOR
			AADD(_aMovPag,{SE5->E5_HISTOR,SE5->E5_DOCUMEN,SE5->E5_VALOR})
			_aHSMPag := {{"Documento",2,17},{"Historico",1,30},{"Valor",3,13}}
		Endif	
		// deposito do dinheiro 
		If SE5->E5_MOEDA == "R$" .And. SE5->E5_TIPODOC == "TR"
			_nSDinheiro += SE5->E5_VALOR
			AADD(_aSDinheiro,{SE5->E5_BENEF,SE5->E5_HISTOR,SE5->E5_VALOR})
			_aHSDin := {{"Beneficiario",1,19},{"Historico",2,40},{"Valor",3,13}}
		Endif
		// deposito do cheque a vista
		If SE5->E5_MOEDA == "TB" .And. SE5->E5_TIPODOC == "TR"
			_nSChequeAV += SE5->E5_VALOR
			AADD(_aSChequeAV,{SE5->E5_BENEF,SE5->E5_HISTOR,SE5->E5_VALOR})
			_aHSChqAV := {{"Beneficiario",1,19},{"Historico",2,40},{"Valor",3,13}}
		Endif
	Endif
	
	// guarda recebimentos feitos no caixa ( movimento bancario )
	If SE5->E5_RECPAG == "R" .And. ! Empty(SE5->E5_MOEDA) .And. SE5->E5_BANCO == _cCaixa
        // outras movimentacoes
		If SE5->E5_MOEDA == "M1"
			_nMovRec += SE5->E5_VALOR
			AADD(_aMovRec,{SE5->E5_HISTOR,SE5->E5_DOCUMEN,SE5->E5_VALOR})
			_aHSMRec := {{"Documento",2,17},{"Historico",1,30},{"Valor",3,13}}
		Endif	
	Endif
	
	// quando for baixa por liquidacao, busca titulos gerados no SE1
	If SE5->E5_RECPAG == "R" .And. SE5->E5_MOTBX == "LIQ" .And. SE5->E5_SITUACA <> "C" .And. SE5->E5_TIPODOC == "BA"
		
		_cNumLiq := Substr(SE5->E5_DOCUMEN,1,6)
		
		dbSelectArea("SE1")
		dbSetOrder(15)
		dbSeek(xFilial("SE1")+_cNumLiq)
		
		While ! Eof() .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_NUMLIQ == _cNumLiq
			
			// se for reliquidado ignora
			_lReliquidacao := Liquidacao(_dDataFec)
			
			If _lReliquidacao
				dbSkip()
				Loop
			Endif
			                                                                 
			// cheque a vista gerado pela liquidacao
			If SE1->E1_TIPO == "CH " .And. SE1->E1_VENCTO == SE1->E1_EMISSAO
				_nChequeAV += _nValorTot
				AADD(_aChequeAV,{_cPreTit,_cNumTit,_cDatTit,_cCliTit,_cNomTit,_nValorTot})
				_aHChqAV := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Cliente",5,30},{"Valor",6,13}}
			Endif

			// cheque a prazo gerado pela liquidacao
			If SE1->E1_TIPO == "CH " .And. SE1->E1_VENCTO <> SE1->E1_EMISSAO
				_nChequePR += _nValorTot
				AADD(_aChequePR,{_cPreTit,_cNumTit,_cDatTit,_cCliTit,_cNomTit,_nValorTot})
				_aHChqPR := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Cliente",5,30},{"Valor",6,13}}
			Endif
			
			// cartao de credito
			If SE1->E1_TIPO == "CC "
				_nTotCC += _nValorTot
				AADD(_aTotCC,{_cPreTit,_cNumTit,_cDatTit,_cCliTit,_cNomTit,SE1->E1_NOMCLI,_nValorTot})
				_aHCC := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Cliente",5,30},{"Valor",7,13}}
			Endif
			
			// cartao de debito a vista
			If SE1->E1_TIPO == "CD " .And. SE1->E1_EMISSAO == SE1->E1_VENCTO
				_nTotCDAV += _nValorTot
				AADD(_aTotCDAV,{_cPreTit,_cNumTit,_cDatTit,_cCliTit,_cNomTit,SE1->E1_NOMCLI,_nValorTot})
				_aHCDAV := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Cliente",5,30},{"Valor",7,13}}
			Endif
			
			// cartao de debito a prazo
			If SE1->E1_TIPO == "CD " .And. SE1->E1_EMISSAO <> SE1->E1_VENCTO
				_nTotCDAP += _nValorTot
				AADD(_aTotCDAP,{_cPreTit,_cNumTit,_cDatTit,_cCliTit,_cNomTit,SE1->E1_NOMCLI,_nValorTot})
				_aHCDPR := {{"Ser",1,3},{"Nota",2,6},{"Emissao",3,8},{"Cliente",5,30},{"Valor",7,13}}
			Endif
			
			dbSelectArea("SE1")
			dbSkip()
			
		Enddo
		
	Endif
	
	dbSelectArea("SE5")
	dbSkip()
	
Enddo

_aTotCC   := ASort(_aTotCC,,,{|x,y| x[6]<y[6]})
_aTotCDAV := ASort(_aTotCDAV,,,{|x,y| x[6]<y[6]})
_aTotCDAP := ASort(_aTotCDAP,,,{|x,y| x[6]<y[6]})

_aSTotCC   := ASort(_aSTotCC,,,{|x,y| x[4]<y[4]})
_aSTotCDAV := ASort(_aSTotCDAV,,,{|x,y| x[4]<y[4]})
_aSTotCDAP := ASort(_aSTotCDAP,,,{|x,y| x[4]<y[4]})

_aResCC   := {}
_aResCDAV := {}
_aResCDAP := {}

// preenche resumo de cartao de credito
For _nX := 1 To Len(_aTotCC)
	_nPos := AScan(_aResCC,{|x| x[1]==_aTotCC[_nX,6]})
	If _nPos == 0
		AAdd(_aResCC,{"",_aTotCC[_nX,6],_aTotCC[_nX,7]})
	Else
		_aResCC[_nPos,3] +=	_aTotCC[_nX,7]
	Endif
Next

// preenche resumo de cartao de debito a vista
For _nX := 1 To Len(_aTotCDAV)
	_nPos := AScan(_aResCDAV,{|x| x[1]==_aTotCDAV[_nX,6]})
	If _nPos == 0
		AAdd(_aResCDAV,{"",_aTotCDAV[_nX,6],_aTotCDAV[_nX,7]})
	Else
		_aResCDAV[_nPos,3] += _aTotCDAV[_nX,7]
	Endif
Next

// preenche resumo de cartao de debito a prazo
For _nX := 1 To Len(_aTotCDAP)
	_nPos := AScan(_aResCDAP,{|x| x[1]==_aTotCDAP[_nX,6]})
	If _nPos == 0
		AAdd(_aResCDAP,{"",_aTotCDAP[_nX,6],_aTotCDAP[_nX,7]})
	Else
		_aResCDAP[_nPos,3] += _aTotCDAP[_nX,7]
	Endif
Next

_aResCC   := ASort(_aResCC,,,{|x,y| x[2]<y[2]})
_aResCDAV := ASort(_aResCDAV,,,{|x,y| x[2]<y[2]})
_aResCDAP := ASort(_aResCDAP,,,{|x,y| x[2]<y[2]})


_nTotCheque := _nChequeAV + _nChequePR
_nTotCD     := _nTotCDAV + _nTotCDAP
_nReceitas  := _nJuros + _nMultas

_nSTotCheque:= _nSChequeAV + _nSChequePR
_nSTotCD    := _nSTotCDAV + _nSTotCDAP

_nTotal     := _nDinheiro + _nTotCheque + _nTotCC + _nTotCD + _nReceitas + _nSaldoDia + _nMovRec

_nSTotal    := _nSDinheiro + _nSTotCheque + _nSTotCC + _nSTotCD + _nMovPag + _nDescontos

ImpRel(1)
ImpRel(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPgEject(.F.)
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpRel   ºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do relatorio analitico/sintetico                 º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel(_cTipoRel)

LOCAL _nX

_nLin := 1
dbSelectArea("SE1")
dbGoTop()

ImpCab(_cTipoRel)

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Dinheiro "
ImpDet(_cTipoRel,_aHDin,_aDinheiro,_cTexto)
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
ImpDet(_cTipoRel,_aHChqAV,_aChequeAV,_cTexto)
@ _nLin,000 PSAY "|"
@ _nLin,005 PSAY _cTexto+Replicate("-",57-Len(_cTexto))+">"
@ _nLin,065 PSAY _nChequeAV PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cheques Pre Datados "
ImpDet(_cTipoRel,_aHChqPR,_aChequePR,_cTexto)
@ _nLin,000 PSAY "|"
@ _nLin,005 PSAY _cTexto+Replicate("-",57-Len(_cTexto))+">"
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

For _nCont:=1 to Len(_aResCC)
	_cTexto:= _aResCC[_nCont,2]
	ImpDet(_cTipoRel,_aHCC,_aTotCC,_cTexto,{_cTexto,6})
	@ _nLin,000 PSAY "|"
	@ _nLin,006 PSAY _cTexto
	@ _nLin,065 PSAY _aResCC[_nCont,3] PICTURE "@E 99,999,999.99"
	@ _nLin,079 PSAY "|"
	AddLinha()
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

@ _nLin,000 PSAY "|"
_cTexto := "Cartoes de Debito Automatico"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

For _nCont:=1 to Len(_aResCDAV)
	If _nCont == 1
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY "A Vista"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Endif
	_cTexto:= _aResCDAV[_nCont,2]
	ImpDet(_cTipoRel,_aHCDAV,_aTotCDAV,_cTexto,{_cTexto,6})
	@ _nLin,000 PSAY "|"
	@ _nLin,009 PSAY _cTexto
	@ _nLin,065 PSAY _aResCDAV[_nCont,3] PICTURE "@E 99,999,999.99"
	@ _nLin,079 PSAY "|"
	AddLinha()
Next

For _nCont:=1 to Len(_aResCDAP)
	If _nCont == 1
		@ _nLin,000 PSAY "|"
		@ _nLin,006 PSAY "A Prazo"
		@ _nLin,079 PSAY "|"
		AddLinha()
    Endif
	_cTexto:= _aResCDAP[_nCont,2]
	ImpDet(_cTipoRel,_aHCDPR,_aTotCDAP,_cTexto,{_cTexto,6})
	@ _nLin,000 PSAY "|"
	@ _nLin,009 PSAY _cTexto
	@ _nLin,065 PSAY _aResCDAP[_nCont,3] PICTURE "@E 99,999,999.99"
	@ _nLin,079 PSAY "|"
	AddLinha()
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

// Receitas

_cTexto := "Receitas/Entradas "
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

If _cTipoRel == 1
	For _nX:=1 to Len(_aMovRec)
		@ _nLin,000 PSAY "|"
		@ _nLin,003 PSAY Substr(_aMovRec[_nX,1],1,60)
		@ _nLin,065 PSAY _aMovRec[_nX,3] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Next
Else
	_cTexto := "Receitas/Entradas"
	ImpDet(_cTipoRel,_aHSMRec,_aMovRec,_cTexto)
Endif

_cTexto := "Receitas/Entradas "
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nMovRec PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

If _cTipoRel == 2
    If (Len(_aJuros)+Len(_aMultas))>0
		_cTexto := "Juros/Multas Pagas "
		@ _nLin,000 PSAY "|"
		@ _nLin,002 PSAY _cTexto
		@ _nLin,079 PSAY "|"
		AddLinha()
		_cTexto := "Juros"
		ImpDet(_cTipoRel,_aHSJur,_aJuros,_cTexto)
		_cTexto := "Multas"
		ImpDet(_cTipoRel,_aHSMul,_aMultas,_cTexto)
		@ _nLin,000 PSAY "|"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Endif	
Endif	
_cTexto := "Juros/Multas Pagas "
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nReceitas PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "A Receber do dia em aberto "
ImpDet(_cTipoRel,_aHSalDia,_aSaldoDia,_cTexto)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSaldoDia PICTURE "@E 99,999,999.99"
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
_cTexto := "CREDITOS / VENDAS "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nTotal PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

//------------------- DEBITOS / SANGRIAS

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
ImpDet(_cTipoRel,_aHSDin,_aSDinheiro,_cTexto)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSDinheiro PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cheques"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cheques a Vista "
ImpDet(_cTipoRel,_aHSChqAV,_aSChequeAV,_cTexto)
@ _nLin,000 PSAY "|"
@ _nLin,005 PSAY _cTexto+Replicate("-",57-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSChequeAV PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

If _cTipoRel == 2
	_cTexto := "Demonstrativo de Cheques a Vista "
	ImpDet(_cTipoRel,_aHCAV,_aChqAV,_cTexto)
	@ _nLin,000 PSAY "|"
	@ _nLin,005 PSAY _cTexto+Replicate("-",57-Len(_cTexto))+">"
	@ _nLin,065 PSAY _nChqAV PICTURE "@E 99,999,999.99"
	@ _nLin,079 PSAY "|"
	AddLinha()
Endif	
	
_cTexto := "Cheques Pre Datados "
ImpDet(_cTipoRel,_aHSChqPR,_aSChequePR,_cTexto)
@ _nLin,000 PSAY "|"
@ _nLin,005 PSAY _cTexto+Replicate("-",57-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSChequePR PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
_cTexto := "Cheques (Total) "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSTotCheque PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

_cTexto := "Cartao de Credito "
ImpDet(_cTipoRel,_aHSCC,_aSTotCC,_cTexto)
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSTotCC PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

If _cTipoRel == 2
	_cTexto := "Cartao de Debito Automatico "
	@ _nLin,000 PSAY "|"
	@ _nLin,002 PSAY _cTexto
	@ _nLin,079 PSAY "|"
	AddLinha()
	_cTexto := "A Vista"
	ImpDet(_cTipoRel,_aHSCDAV,_aSTotCDAV,_cTexto)
	_cTexto := "A Prazo"
	ImpDet(_cTipoRel,_aHSCDPR,_aSTotCDAP,_cTexto)
	@ _nLin,000 PSAY "|"
	@ _nLin,079 PSAY "|"
	AddLinha()
Endif	
_cTexto := "Cartao de Debito Automatico "
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSTotCD PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

// Despesas
_cTexto := "Despesas/Saidas "
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto
@ _nLin,079 PSAY "|"
AddLinha()

If _cTipoRel == 1
	For _nX:=1 to Len(_aMovPag)
		@ _nLin,000 PSAY "|"
		@ _nLin,003 PSAY Substr(_aMovPag[_nX,1],1,60)
		@ _nLin,065 PSAY _aMovPag[_nX,3] PICTURE "@E 99,999,999.99"
		@ _nLin,079 PSAY "|"
		AddLinha()
	Next
	@ _nLin,000 PSAY "|"
	@ _nLin,003 PSAY "Descontos concedidos "
	@ _nLin,065 PSAY _nDescontos PICTURE "@E 99,999,999.99"
	@ _nLin,079 PSAY "|"
	AddLinha()
Else
	_cTexto := "Despesas/Saidas"
	ImpDet(_cTipoRel,_aHSMPag,_aMovPag,_cTexto)
	_cTexto := "Descontos Concedidos"
	ImpDet(_cTipoRel,_aHSDes,_aDescontos,_cTexto)
Endif

_cTexto := "Despesas/Saidas "
@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nMovPag+_nDescontos PICTURE "@E 99,999,999.99"
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
_cTexto := "DEBITOS / SANGRIAS "
@ _nLin,002 PSAY _cTexto+Replicate("-",60-Len(_cTexto))+">"
@ _nLin,065 PSAY _nSTotal PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Saldo do Caixa"
@ _nLin,065 PSAY _nTotal-_nSTotal PICTURE "@E 99,999,999.99"
@ _nLin,079 PSAY "|"
AddLinha()

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
AddLinha()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpDet   ºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos arrays com o detalhamento dos valores        º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpDet(_cTipoRel,_aHeader,_aCols,_cTexto,_aChave)

LOCAL _nY,_nX,_nTam,_lCab
                 
If _aChave == NIL
	_aChave := {}
Endif

If _nLin > 54
	ImpCab(_cTipoRel)
Endif

If _cTipoRel == 1
	Return
Endif

If len(_aCols) == 0
	Return
Endif

_lCab := .T.

For _nX := 1 to len(_aCols)

    If Len(_aChave) > 0
    	_cChave := _aChave[1] 
    	_nPos   := _aChave[2]
    	If Alltrim(_aCols[_nX,_nPos]) <> Alltrim(_cChave)
    		Loop
    	Endif	
    Endif

	If _lCab
	
		_lCab := .F.
		                    
		// imprime cabecalho adicional
		@ _nLin,000 PSAY "|"
		@ _nLin,079 PSAY "|"
		AddLinha()
		
		@ _nLin,000 PSAY "|"
		@ _nLin,002 PSAY _cTexto
		@ _nLin,079 PSAY "|"
		AddLinha()
		          
		// imprime cabecalho
		@ _nLin,000 PSAY "|"
		_nCol := 3
		For _nY:=1 To Len(_aHeader)
		    _nTam := _aHeader[_nY,3]
			@ _nLin,_nCol PSAY Substr(_aHeader[_nY,1],1,_nTam)
			_nCol += _nTam + 1
		Next
		@ _nLin,079 PSAY "|"
		AddLinha()

		@ _nLin,000 PSAY "|"
		_nCol := 3
		For _nY:=1 To Len(_aHeader)
		    _nTam := _aHeader[_nY,3]
			@ _nLin,_nCol PSAY Replicate("-",_nTam)
			_nCol += _nTam + 1
		Next
		@ _nLin,079 PSAY "|"
		AddLinha()
		
	Endif
	
	@ _nLin,000 PSAY "|"
	_nCol := 3
	For _nY:=1 To Len(_aHeader)
	    _nPos := _aHeader[_nY,2]
	    _nTam := _aHeader[_nY,3]
	    If _nY == Len(_aHeader)
			@ _nLin,_nCol PSAY _aCols[_nX,_nPos] PICTURE "@E 99,999,999.99"
		Else	
			@ _nLin,_nCol PSAY Substr(_aCols[_nX,_nPos],1,_nTam)
		Endif	
		_nCol += _nTam + 1
	Next
	@ _nLin,079 PSAY "|"
	AddLinha()
	
Next

@ _nLin,000 PSAY "|"
@ _nLin,079 PSAY "|"
AddLinha()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpCab   ºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do cabecalho                                     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCab(_cTipoRel)

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
@ _nLin,020 PSAY "FECHAMENTO DO CAIXA - "+If(_cTipoRel==1,"SINTETICO","ANALITICO")
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,002 PSAY "Periodo do Movimento : " + Dtoc(_dDataFec) + ", as " +Time()
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

@ _nLin,000 PSAY "|"
@ _nLin,001 PSAY Replicate("-",limite)
@ _nLin,079 PSAY "|"
_nLin := _nLin + 1

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AddLinha ºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adiciona um nova linha, se ultrapassar limete imprime      º±±
±±º          ³ cabecalho                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AddLinha()

_nLin += 1
If _nLin > 54
	ImpCab()
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LiquidacaoºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o titulo teve baixa por liquidacao no SE5      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Liquidacao(_dData)

LOCAL _aAlias := GetArea()
LOCAL _aAliasSE5 := SE5->(GetArea())
LOCAL _lReliquidacao := .F.

// verifica se o titulo liquidado tem liquidacao na mesma data, se sim foi reliquidado
dbSelectArea("SE5")
dbSetOrder(7)
dbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)

While ! Eof() .And. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
	xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA
	If SE5->E5_DATA == _dData .And. SE5->E5_RECPAG == "R" .And. SE5->E5_MOTBX == "LIQ" .And. SE5->E5_SITUACA <> "C" .And. SE5->E5_TIPODOC == "BA"
		_lReliquidacao := .T.
		Exit
	Endif
	dbSkip()
Enddo

RestArea(_aAliasSE5)
RestArea(_aAlias)

Return(_lReliquidacao)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TemCheque ºAutor  ³ Jader              º Data ³  27/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se tem cheque no arquivo de cheques SEF           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TemCheque(_cPrefixo,_cTitulo,_cParcela,_cTipo,_cCliente)

LOCAL _aAlias := GetArea()
LOCAL _lTemCheque := .F.

dbSelectArea("SEF")
dbSetOrder(7)
dbSeek(xFilial("SEF")+"R"+_cPrefixo+_cTitulo+_cParcela+_cTipo)

While ! Eof() .And. SEF->(EF_FILIAL+EF_CART+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO) == ;
	xFilial("SEF")+"R"+_cPrefixo+_cTitulo+_cParcela+_cTipo
	If SEF->EF_CLIENTE == _cCliente
		_lTemCheque := .T.
		Exit
	Endif
	dbSkip()
Enddo

RestArea(_aAlias)

Return(_lTemCheque)
