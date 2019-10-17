#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DVDIVSE2  º Autor ³ Geraldo Sabino      º Data ³  15/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verificacao via relatorio de titulos que estao com o valor º±±
±±º          ³ da duplicata diferente da NF.  (Erro na Entrada c/EDI)     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE  Solicitacao do Alex                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DVDIVSE2()

Private cPerg   := "DVDIVE"

titulo   := "Divergência entre valor de Titulos a Pagar x NF Entrada"
wnrel    := "DVDIVSE2"
Tamanho  := "G"
nTipo    := 0
cString  := "SF1"
cDesc1   := "Emite o Relatorio de Divergencia entre NF x Tit.Pagar"
cDesc2   := " "
cDesc3   := " "
aOrd     := {}
Li		 := 80
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
m_pag	 := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Perg(cPerg)
pergunte(cPerg,.T.)

wnrel:=SetPrint("SF1",wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

nLastKey:=IIf(LastKey()==27,27,nLastKey)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

Processa({|lEnd|SF1CHEC()})// Substituido pelo assistente de conversao do AP5 IDE em 09/05/01 ==> 	 Processa({|lEnd|Execute(ESP05)})

Static Function SF1CHEC()

PERGUNTE("DVDIVE",.F.)

_cQuery := "SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_PREFIXO,F1_FORNECE,F1_LOJA,F1_VALMERC,F1_VALIPI,F1_ICMSRET,F1_DTDIGIT,F1_DESCONT,F1_FRETE,F1_SEGURO,F1_DESPESA, "
_cQuery += "F1_IRRF,F1_INSS,F1_ISS,F1_ARQEDIP,F1_VALBRUT FROM "+RetSqlName("SF1")+" WHERE D_E_L_E_T_<>'*' AND F1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND "
_cQuery += "F1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND F1_DUPL<>''  AND   "
_cQuery += "F1_TIPO = 'N' ORDER BY F1_FILIAL,F1_DTDIGIT  "

IF SELECT("TMPSF1")<>0
	dBselectarea("TMPSF1")
	dBclosearea("")
Endif

TCQUERY _cQuery New Alias TMPSF1


TCSETFIELD("TMPSF1","F1_DTDIGIT","D")

cabec1 := "Fl  Docto  Ser Fornec Lj Nome do Fornecedor        Entrada               Valor Bruto                        Data Vencto                   Total Fin      Dif         Origem          "
cabec2 := " "

//          XXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    999999999    999999999    999999999    999999999
//          0         1         2         3         4         5         6         7         8         9        10        11        12        13
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

DbSelectarea("TMPSF1")
ProcRegua(Reccount())
dBgotop()
_nt1:=0
_nt2:=0

While ! Eof()

	 _lShow:=.F.
	//IF Str((TMPSF1->(F1_VALMERC + F1_VALIPI + F1_ICMSRET)),13,2) <> Str(TMPSF1->F1_VALBRUT,13,2)
	//	_lShow:=.T.
	//ENDIF
	
	
	If !_lShow
		dBselectarea("SE2")
		dBsetorder(6)
		dbseek(xFilial("SE2")+TMPSF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC),.T.)
		_nVal:=0
		While ! Eof() .AND. E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM == xFilial("SE2")+TMPSF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC)
			
			_nVal:=_nVal + (SE2->E2_VALOR + SE2->E2_INSS + SE2->E2_ISS + SE2->E2_IRRF)
			dBselectarea("SE2")
			dBskip()
		Enddo
		
		if Str(_nVal,13,2) <> str(TMPSF1->F1_VALBRUT,13,2)
			_lShow := .T.
		Else
			dBselectarea("TMPSF1")
			dBskip()
			Loop
		Endif
		
	Endif
	
	dBselectarea("SE2")
	dBsetorder(6)
	dbseek(xFilial("SE2")+TMPSF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC),.T.)
	_nVal:=0
	While ! Eof() .AND. E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM == xFilial("SE2")+TMPSF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC)
		
		_nVal:=_nVal + (SE2->E2_VALOR + SE2->E2_INSS + SE2->E2_ISS + SE2->E2_IRRF)
		dBselectarea("SE2")
		dBskip()
	Enddo
	
	if Str(_nVal,13,2) <> str(TMPSF1->F1_VALBRUT,13,2)
		_lShow := .T.
	Else
		dBselectarea("TMPSF1")
		dBskip()
		Loop
	Endif
	
	
	incProc("Filial "+TMPSF1->F1_FILIAL+"-"+DTOC(TMPSF1->F1_DTDIGIT))
	
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		li := 8
	EndIf
	
	if _lShow
		
		@ li,001 PSAY TMPSF1->F1_FILIAL
		@ li,004 PSAY TMPSF1->F1_DOC
		@ li,011 PSAY TMPSF1->F1_PREFIXO
		@ li,015 PSAY TMPSF1->F1_FORNECE
		@ li,022 PSAY TMPSF1->F1_LOJA
		@ li,025 PSAY POSICIONE("SA2",1,xFilial("SA2")+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA,"A2_NREDUZ")
		@ li,050 PSAY TMPSF1->F1_DTDIGIT
		@ li,070 PSAY TMPSF1->F1_VALBRUT  PICTURE "@E 999,999,999.99"
		
		dBselectarea("SE2")
		dBsetorder(6)
		dbseek(xFilial("SE2")+TMPSF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC),.T.)
		_nCol:=110
		_nVal:=0
		@ li,108 PSAY iif(Empty(SE2->E2_BAIXA)," ","*")
		
		While ! Eof() .AND. E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM == xFilial("SE2")+TMPSF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DOC)
			
			_nVal:=_nVal + SE2->E2_VALOR
			@ li,_nCol PSAY SE2->E2_VENCREA
			dBselectarea("SE2")
			dBskip()
			_nCol:=_nCol+10
		Enddo
		@ li,138 PSAY _nVal    PICTURE "@E 999,999,999.99"
		
		@ li,153 PSAY  iif(_nVal<>TMPSF1->(F1_VALMERC+F1_ICMSRET+F1_VALIPI-F1_DESCONT+F1_FRETE+F1_SEGURO+F1_DESPESA),"** Dif ** ","          ")
		@ li,165 PSAY  TMPSF1->F1_ARQEDIP
		
		_nt1 := _nt1 + TMPSF1->(F1_VALMERC+F1_ICMSRET+F1_VALIPI-F1_DESCONT+F1_FRETE+F1_SEGURO+F1_DESPESA)
		_nt2 := _nt2 + _nVal
		
		li:=li+1
		
	Endif
	
	dBselectarea("TMPSF1")
	dBskip()
Enddo
li:=li+1
li:=li+1


@ li,090 PSAY _nt1        PICTURE "@E 999,999,999.99"
@ li,158 PSAY _nt2        PICTURE "@E 999,999,999.99"


Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

dBselectarea("TMPSF1")
dBclosearea("")

Return


Static Function Perg(cPerg)

_cAlias  := Alias()
_aRegs    := {}

dbSelectArea("SX1")
dbSetOrder(1)
//
AADD(_aRegs,{cPerg,"01","Data de                      ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aRegs,{cPerg,"02","Data Ate                     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//
For i := 1 to Len(_aRegs)
	If !DbSeek(cPerg+_aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(_aRegs[i])
				FieldPut(j,_aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_cAlias)
//
Return

