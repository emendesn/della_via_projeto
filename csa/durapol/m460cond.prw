#include "Protheus.ch"
#INCLUDE "FINA330.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460COND  ºAutor  ³Microsiga           º Data ³  31/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION M460COND()
LOCAL aTitulos  := {}
LOCAL nValTot   := 0
LOCAL oTitulo
LOCAL oOk	  	:= LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo	  	:= LoadBitmap( GetResources(), "LBNO" )
LOCAL nMaxIte   := GETMV("MV_NUMITEN")
LOCAL _cPedido  := SC6->C6_NUM
LOCAL lCredito  := .F.
PRIVATE oDlg
PRIVATE oGet01

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Aplicação de Créditos") From 12,1.5 To 25.6,79.5 OF oMainWnd
@ 0.5,0.5 TO 6, 38.3 LABEL OemToAnsi("Créditos Existente(s)") OF oDlg

Processa({ || aTitulos:= SF460Tit(SC6->C6_CLI)})  // Monta a Matriz com as compensacoes validas

If Len(aTitulos) == 0
	Help(" ",1,"NOTITSEL")
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return
ELSE
	lConfirma := IW_MsgBox("Este Cliente tem nota(s) de credito. Deseja Aplicar estes descontos"," * * *  A T E N Ç Ã O  * * * ","YESNO")
	IF !lConfirma
		Return(dDatabase)
	ENDIF
Endif


@ 1.0,1.0 LISTBOX oTitulo	VAR cVarQ Fields;
HEADER "",OemToAnsi(STR0006),;  //"Prefixo"
OemToAnsi(STR0007),;  //"N£mero"
OemToAnsi(STR0008),;  //"Parcela"
OemToAnsi(STR0009),;  //"Tipo"
OemToAnsi(STR0011),;  //"Loja"
OemToAnsi(STR0016),;  //"Saldo do t¡tulo"
OemToAnsi(STR0017),;   //"Valor compensado"
STR0048,; //"Acréscimos"
STR0049,; //"Decréscimos"
OemToAnsi(STR0038),;   //"Moeda"
OemToAnsi(STR0039);   //"Emissao"
COLSIZES 12,GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBB"),;
GetTextWidth(0,"BBBB"),GetTextWidth(0,"BBB"),GetTextWidth(0,"BBB"),;
GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBB");
SIZE 293,54.5 ON DBLCLICK (aTitulos:= SF460Troca(oTitulo:nAt,aTitulos,@oGet01,@nValTot,@oTitulo,nMaxIte,_cPedido),oTitulo:Refresh()) NOSCROLL

oTitulo:SetArray(aTitulos)
oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,11],;
aTitulos[oTitulo:nAt,12],aTitulos[oTitulo:nAt,9],;
aTitulos[oTitulo:nAt,10]}}

// @  071 , 008 BUTTON "Inverte Seleção" SIZE 50,11 ACTION (nValTot := 0, aEval(aTitulos, {|e| e[8] := !e[8], If(e[8],(If(SF460VTit(e[7])=0,e[7]:=e[6],Nil),nValTot += SF460VTit(e[7])),Nil)}), oTitulo:Refresh(),oGet01:Refresh()) OF oDlg PIXEL
@  072 , 183 SAY "Valor Selecionado" PIXEL OF oDlg SIZE 70,7
@  072 , 233 MSGET oGet01 VAR nValTot PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oDlg SIZE 70,7

DEFINE SBUTTON FROM 90,234.6 TYPE 1 ACTION (nOpca := 1,IF(SF460OK(nValTot,_cPedido),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
DEFINE SBUTTON FROM 90,264.6 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

RETURN(dDatabase)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SF460VTit ³ Autor ³ Microsiga             ³ Data ³ 31/07/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³      	                    							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function SF460VTit(aTitulo,cTipoTit,cValor)
LOCAL nValor
cValor := IIF (cValor == NIL,aTitulo,cValor)
nValor := DesTrans(cValor)
Return nValor

STATIC FUNCTION SF460Troca(nItem,aTitulos,oGet01,nValTot,oTitulo,nMaxIte,_cPedido)
LOCAL oDlg
LOCAL nX      := 0
LOCAL nAcresc := 0
LOCAL nIteSel := 0
LOCAL aPedido := SFItensPed(_cPedido)
LOCAL nItePed := Len(aPedido)
LOCAL nValPed := 0

For n:= 1 to Len(aPedido)
	nValPed += aPedido[n][3]
Next

cValor  := SF460VTit(aTitulos[nItem][7])
cSaldo  := SF460VTit(aTitulos[nItem][6])
nAcresc := SF460VTit(aTitulos[nItem][10])
nValtot := 0

aTitulos[nItem][8] := !aTitulos[nItem][8]

If  !aTitulos[nItem][8]
	aTitulos[nItem][7] :=Transf(0,"@E 9999,999,999.99")
	aTitulos[nItem][9] := 0
Endif

For nX:=1 to Len(aTitulos)
	If	aTitulos[nX][8]
		nValTot += SF460VTit(aTitulos[nX][6])
		nIteSel++
		IF nIteSel+nItePed > nMaxIte
			_cMsg := "O número de itens permitidos por nota fiscal, foi excedido." + chr(13) + chr(10)
			_cMsg += " Este item não será considerado para este processo."
			
			Iw_MsgBox(_cMsg,"","ALERT")
			aTitulos[nItem][8] := .F.
		ENDIF
		
		IF nValTot > nValPed
			_cMsg := "Com este item, o valor do crédito, supera o valor da nota fiscal que será gerada." + chr(13) + chr(10)
			_cMsg += " Este item não será considerado para este processo."
			
			Iw_MsgBox(_cMsg,"","ALERT")
			
			aTitulos[nItem][8] := .F.
		ENDIF
	Endif
Next

oGet01:Refresh()

Return(aTitulos)

STATIC FUNCTION SF460TIT(cCliente)
LOCAL lMarca   := .f.
LOCAL aTitulos := {}
LOCAL nMoeda

DbSelectArea("SE1")
DbSetOrder(2)
DbSeek(xFilial("SE1")+cCliente)

SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE))

DbSelectArea("SE1")

While !EOF() .AND. cCliente == SE1->E1_CLIENTE .AND. "SEP" == SE1->E1_PREFIXO .AND. "NCC" == SE1->E1_TIPO
	
	IF SE1->E1_SALDO == 0
		SE1->(DbSkip())
		LOOP
	ENDIF
	aAdd(aTitulos,{SE1->E1_PREFIXO,;
	SE1->E1_NUM,;
	SE1->E1_PARCELA,;
	SE1->E1_TIPO,;
	SE1->E1_LOJA,;
	Transform(xMoeda(SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,SE1->E1_MOEDA,,5),"@E 9999,999,999.99"),;
	Transform(0,"@E 9999,999,999.99"),;
	lMarca,;
	0,;
	SE1->E1_CLIENTE+"-"+SE1->E1_LOJA,;
	SE1->E1_NOMCLI,;
	Transform(SA1->A1_CGC,Substr(PicPes(SA1->A1_PESSOA),1,at("%",PicPes(SA1->A1_PESSOA))-1)),;
	Transform(xMoeda(SE1->E1_SDACRES,SE1->E1_MOEDA,SE1->E1_MOEDA,,5),"@E 9999,999,999.99"),;
	Transform(xMoeda(SE1->E1_SDDECRE,SE1->E1_MOEDA,SE1->E1_MOEDA,,5),"@E 9999,999,999.99") })
	
	DbSelectARea("SE1")
	SE1->(DbSkip())
	
EndDo

Return(aTitulos)

STATIC FUNCTION SFItensPed(_cPedido)
LOCAL aRet     := {}
LOCAL nRet     := 0
LOCAL nValTot  := 0
LOCAL aAreaSC6 := GetArea("SC6")

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+_cPedido)

While !EOF() .AND. _cPedido == SC6->C6_NUM
	
	AADD(aRet,{SC6->C6_ITEM,SC6->C6_PRUNIT,SC6->C6_VALOR})
	DbSelectArea("SC6")
	SC6->(DbSkip())
EndDo

RestArea(aAreaSC6)

RETURN(aRet)

STATIC FUNCTION SF460OK(nValTot,_cPedido)
LOCAL lRet      := .F.
LOCAL aAreaSC6  := GetArea("SC6")
LOCAL _cTesVend := GetMv("MV_TESVD")
LOCAL aPedido   := SFItensPed(_cPedido)
LOCAL nValPed   := 0

For n:= 1 to Len(aPedido)
	nValPed += aPedido[n][3]
Next

// Irei aplicar o desconto pró-rata nos itens do pedido de venda
DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+_cPedido)
While !EOF() .AND. _cPedido == SC6->C6_NUM
	IF SC6->C6_TES <> _cTesVend
		DbSkip()
		LOOP
	ENDIF

	RecLock("SC6")
	SC6->C6_VALDESC := (Round( (SC6->C6_VALOR / nValPed ),2) * nValTot )
	SC6->C6_DESCONT := ( (Round( (SC6->C6_VALOR / nValPed ),2) * nValTot ) / SC6->C6_VALOR) 
	SC6->C6_VALOR   := (SC6->C6_VALOR - (Round( (SC6->C6_VALOR / nValPed ),2) * nValTot ))
	SC6->C6_PRCVEN  := (SC6->C6_VALOR / SC6->C6_QTDVEN)
	MsUnlocK()

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
	RecLock("SC9")
	SC9->C9_PRCVEN := (SC9->C9_PRCVEN - SC6->C6_VALDESC)
	MsUnlock()

	DbSelectArea("SD2")
	DbSetOrder(8)
	DbSeek(xFilial("SD2")+SC6->C6_NUM+SC6->C6_ITEM)
	RecLock("SD2")
	SD2->D2_TOTAL  := (SD2->D2_TOTAL - SC6->C6_VALDESC)
	SD2->D2_PRCVEN := (SD2->D2_TOTAL / SD2->D2_QUANT)
	MsUnlock()
	DbSelectArea("SC6")
	SC6->(DbSkip())
EndDo

RestArea(aAreaSC6)

RETURN(lRet)
