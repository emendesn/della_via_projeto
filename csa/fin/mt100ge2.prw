#Include "rwmake.ch"
/*
Denis - 25/04/2006
O programa executava as alterações por meio de RecLock() -> MsUnlock(), foi
alterado para UPDATE direto, porque se a condição de pagamento gerar mais de
um titulo, todos serão alterados, e não apenas o titulo posicionado, como estava
antes.
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2  ºAutor  ³GERALDO SABINO      º Data ³  05/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajuste de Valor no E2_VALOR,E2_SALDO e E2_VLCRUZ, dentro DO º±±
±±           ³Limite do Parametro MV_LIMPAG (Caso seja maior, nao faz nada)±±
±±           ³(Siga na Classificacao das NFs via EDI nao esta rejeitando a ±±
±±           ³NF e aceitando varias Divergencias.). A ctb e feita pelo SF1 ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via .                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100GE2
Local cFilSE2  := SE2->E2_FILIAL
Local cPrf     := SE2->E2_PREFIXO
Local cNum     := SE2->E2_NUM
Local cFornece := SE2->E2_FORNECE
Local cLoja    := SE2->E2_LOJA
Local cSql     := ""

cSql := cSql + "UPDATE "+RetSqlName("SE2")
/*
Gravar a conta, centro de custo e item informados no SD1 estes
campos sao obrigatorios e eram gerados vazios, o que fazia a
usuaria ter dificuldades na hora de manipular titulos do SE2
*/
cSql := cSql + " SET E2_CONTAD  = '"+SD1->D1_CONTA+"'"
cSql := cSql + " ,   E2_CCD     = '"+SD1->D1_CC+"'"
cSql := cSql + " ,   E2_ITEMD   = '"+SD1->D1_ITEMCTA+"'"

/*
Denis - 25/04/2006
Grava informações do portador no titulo de acordo com o que foi informado
pelo Depto Financeiro, porém somente quando o fornecedor não for Pirelli.
FS_DEL020 --> Parametro com Código+Loja da Pirelli.
DV_PORTADO --> Parametro com Código do portador.
*/
If SE2->(E2_FORNECE+E2_LOJA) <> AllTrim(SuperGetMv("FS_DEL020",.F.,"00056701"))
	cSql := cSql + " ,   E2_PORTADO = '"+AllTrim(SuperGetMv("DV_PORTADO",.F.,"341"))+"'"
Endif

cSql := cSql + " WHERE D_E_L_E_T_ = ''"
cSql := cSql + " AND   E2_FILIAL  = '"+cFilSE2+"'"
cSql := cSql + " AND   E2_PREFIXO = '"+cPrf+"'"
cSql := cSql + " AND   E2_NUM     = '"+cNum+"'"
cSql := cSql + " AND   E2_FORNECE = '"+cFornece+"'"
cSql := cSql + " AND   E2_LOJA    = '"+cLoja+"'"

If TcSqlExec(cSql) < 0
	MsgBox(TcSqlError(),"MT100GE2","STOP")
Endif

// Implementacao / Geraldo Sabino 05.06.2006
// Tratamento do Arredondamento / Tolerancia na Classificacao da NFE EDI PIRELLI
// Somente Importacao EDI Pirelli vindo do MATA140 - Classificacao de NFE
/*

IF EMPTY(SF1->F1_ARQEDIP)
	Return
ENDIF

// Salva Alias Corrente.
aArea:=GetArea()

dBselectarea("SE2")
_nOrderSE2:=IndexOrd()
_nRecnoSE2:=Recno()
dbsetorder(6)
IF dBseek(xFilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC),.T.)
	
	IF !SE2->E2_MSFIL == SF1->F1_FILIAL
		
		dBselectarea("SE2")
		dbsetorder(_nOrderSE2)
		dbgoto(_nRecnoSE2)
		
		RestArea(aArea)
		Return
	ENDIF
	
	_nVal:=0
	While E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM == xFilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC) .AND. !Eof()
		_nVal:=_nVal + SE2->E2_VALOR
		
		dBselectarea("SE2")
		dBskip()
		
	Enddo
	
	If SF1->F1_VALBRUT > _nVal
		_nDif := SF1->F1_VALBRUT - _nVal
	Else
		_nDif := _nVal - SF1->F1_VALBRUT
	Endif
	
	_nDif2 := SF1->F1_VALBRUT - _nVal
	
	IF _nDif <= GETMV("MV_LIMPAG ")
		
		// Altera / Arredonda / Ajusta  na Primeira Parcela do Titulo Principal
		
		dBselectarea("SE2")
		dbsetorder(6)
		IF dBseek(xFilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC),.T.)
			SE2->(Reclock("SE2",.F.))
			SE2->E2_VALOR   :=  SE2->E2_VALOR  + _nDif2
			SE2->E2_SALDO   :=  SE2->E2_SALDO  + _nDif2
			SE2->E2_VLCRUZ  :=  SE2->E2_VLCRUZ + _nDif2
			SE2->(MsUnlock())
		Endif
		
	Endif
Endif

dBselectarea("SE2")
dbsetorder(_nOrderSE2)
dbgoto(_nRecnoSE2)
RestArea(aArea)
*/

Return nil
