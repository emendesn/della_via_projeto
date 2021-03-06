#include "Protheus.ch"
#INCLUDE "FINA330.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460Proc  �Autor  �Microsiga           � Data �  31/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION M460Proc()
LOCAL aTitulos  := {}
LOCAL nValTot   := 0
LOCAL oTitulo
LOCAL oOk	  	:= LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo	  	:= LoadBitmap( GetResources(), "LBNO" )
LOCAL nMaxIte   := GETMV("MV_NUMITEN")
LOCAL _cPedido  := SC9->C9_PEDIDO
LOCAL lCredito  := .F.
PRIVATE oDlg
PRIVATE oGet01

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Aplica��o de Cr�ditos") From 12,1.5 To 25.6,79.5 OF oMainWnd
@ 0.5,0.5 TO 6, 38.3 LABEL OemToAnsi("Cr�ditos Existente(s)") OF oDlg

Processa({ || aTitulos:= SF460Tit(SC9->C9_CLIENTE)})  // Monta a Matriz com as compensacoes validas

If Len(aTitulos) == 0
	// Help(" ",1,"NOTITSEL")
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return(" ")
ELSE
	lConfirma := IW_MsgBox("Este Cliente tem nota(s) de credito. Deseja Aplicar estes descontos"," * * *  A T E N � � O  * * * ","YESNO")
	IF !lConfirma
		Return(" ")
	ENDIF
Endif


@ 1.0,1.0 LISTBOX oTitulo	VAR cVarQ Fields;
HEADER "",OemToAnsi(STR0006),;  //"Prefixo"
OemToAnsi("Laudo"),;  //"N�mero"
OemToAnsi(STR0008),;  //"Parcela"
OemToAnsi(STR0009),;  //"Tipo"
OemToAnsi(STR0011),;  //"Loja"
OemToAnsi(STR0016),;  //"Saldo do t�tulo"
OemToAnsi(STR0017),;   //"Valor compensado"
STR0048,; //"Acr�scimos"
STR0049,; //"Decr�scimos"
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

// @  071 , 008 BUTTON "Inverte Sele��o" SIZE 50,11 ACTION (nValTot := 0, aEval(aTitulos, {|e| e[8] := !e[8], If(e[8],(If(SF460VTit(e[7])=0,e[7]:=e[6],Nil),nValTot += SF460VTit(e[7])),Nil)}), oTitulo:Refresh(),oGet01:Refresh()) OF oDlg PIXEL
@  072 , 183 SAY "Valor Selecionado" PIXEL OF oDlg SIZE 70,7
@  072 , 233 MSGET oGet01 VAR nValTot PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oDlg SIZE 70,7

DEFINE SBUTTON FROM 90,234.6 TYPE 1 ACTION (nOpca := 1,IF(SF460OK(nValTot,aTitulos,_cPedido,oDlg),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
DEFINE SBUTTON FROM 90,264.6 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

RETURN

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �SF460VTit � Autor � Microsiga             � Data � 31/07/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o saldo ou valor do titulo a ser compensado		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �      	                    							  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	IF aTitulos[nX][8]
		nValTot += SF460VTit(aTitulos[nX][6])
		nIteSel++
		IF nIteSel+nItePed > nMaxIte
			_cMsg := "O n�mero de itens permitidos por nota fiscal, foi excedido." + chr(13) + chr(10)
			_cMsg += " Este item n�o ser� considerado para este processo."
			
			Iw_MsgBox(_cMsg,"","ALERT")
			aTitulos[nItem][8] := .F.
		ENDIF
		
		IF nValTot > nValPed
			_cMsg := "Com este item, o valor do cr�dito, supera o valor da nota fiscal que ser� gerada." + chr(13) + chr(10)
			_cMsg += " Este item n�o ser� considerado para este processo."
			
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
DbSetOrder(1)

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
	
	AADD(aRet,{SC6->C6_ITEM,SC6->C6_PRUNIT,SC6->C6_VALOR,SC6->C6_TES})
	DbSelectArea("SC6")
	SC6->(DbSkip())
EndDo

RestArea(aAreaSC6)

RETURN(aRet)

STATIC FUNCTION SF460OK(nValTot,aTitulos,_cPedido,oDlg)
LOCAL lRet      := .T.
LOCAL aAreaSC6  := GetArea("SC6")
LOCAL _cTesVend := GetMV("MV_X_TSVED")
LOCAL _cNatCR   := STRTRAN(STRTRAN(GetMv("MV_NATCRED"),'"',""),"'","")
LOCAL aPedido   := SFItensPed(_cPedido)
LOCAL nValPed   := 0
LOCAL aVetor    := {}
LOCAL nItPed    := 0
LOCAL _cNumFict := AllTrim(SX5->X5_DESCRI)

For nItPed := 1 to Len(aPedido)
	IF _cTesVend $ aPedido[nItPed][4]
		nValPed += aPedido[nItPed][3]
	ENDIF
Next nItPed

oDlg:End()

// Irei aplicar o desconto pr�-rata nos itens do pedido de venda
DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+_cPedido)
While !EOF() .AND. _cPedido == SC6->C6_NUM
	IF !(SC6->C6_TES $ _cTesVend)
		DbSkip()
		LOOP
	ENDIF
	
	IF RecLock("SC6")
		SC6->C6_VALDESC := (Round( (SC6->C6_VALOR / nValPed ),2) * nValTot )
		SC6->C6_DESCONT := ( ( (Round( (SC6->C6_VALOR / nValPed ),2) * nValTot ) / SC6->C6_VALOR) * 100)
		SC6->C6_VALOR   := (SC6->C6_VALOR - (Round( (SC6->C6_VALOR / nValPed ),2) * nValTot ))
		SC6->C6_PRCVEN  := (SC6->C6_VALOR / SC6->C6_QTDVEN)
		MsUnlocK()
	Endif
	
	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
	IF RecLock("SC9")
		SC9->C9_PRCVEN := (SC9->C9_PRCVEN - SC6->C6_VALDESC)
		MsUnlock()
	ENDIF
	DbSelectArea("SC6")
	SC6->(DbSkip())
EndDo


// Realizar a Baixa dos Cr�ditos aplicados
For nTitulo := 1 to Len(aTitulos)
	IF aTitulos[nTitulo][8] // Somente creditos marcados
		DbSelectArea("SE1")
		DbSetOrder(1)
		IF DbSeek(xFilial("SE1")+aTitulos[nTitulo][1]+aTitulos[nTitulo][2]+aTitulos[nTitulo][3]+"NCC")
			RecLock("SE1")
			SE1->E1_NUMBOR  := SC9->C9_PEDIDO
			SE1->E1_SALDO   := 0
			SE1->E1_VALLIQ  := SE1->E1_VALOR
			SE1->E1_LOTE    := "8850"
			SE1->E1_MOVIMEN := dDataBase
			SE1->E1_STATUS  := "B"
			MsUnlock()
		ENDIF
		
		// Criar titulo do tipo NF com prefixo SEP que ser� compensado com a(s) NCC(s)
	
		// lMsErroAuto := .F.
		
		aVetor  := {	{"E1_PREFIXO" ,"SEP"           ,Nil},;
		{"E1_FILIAL"  , xFilial("SE1") ,NIL},;
		{"E1_NUM"	  ,_cNumFict       ,Nil},;
		{"E1_PARCELA" ,"A"             ,Nil},;
		{"E1_TIPO"	  ,"NF "           ,Nil},;
		{"E1_NATUREZ" ,_cNatCr         ,Nil},;
		{"E1_CLIENTE" ,SC9->C9_CLIENTE ,Nil},;
		{"E1_LOJA"	  ,SC9->C9_LOJA    ,Nil},;
		{"E1_EMISSAO" ,dDataBase       ,Nil},;
		{"E1_VENCTO"  ,(dDataBase)     ,Nil},;
		{"E1_VENCREA" ,(dDataBase)     ,Nil},;
		{"E1_SALDO"   ,0               ,Nil},;
		{"E1_VALOR"	  ,nValTot         ,Nil}}
		
		
		MSExecAuto({|x,y| Fina040(x,y)},aVetor,3)
		
		// Baixa o titulo gerado para compensa��o
		DbSelectArea("SE1")
		DbSetOrder(1)
		IF DbSeek(xFilial("SE1")+"SEP"+_cNumFict+"A"+"NF ")
			RecLock("SE1")
				SE1->E1_SALDO := 0
				SE1->E1_VALLIQ := SE1->E1_VALOR
				SE1->E1_STATUS := "B"
			MsUnlock()
		ENDIF
		// Criar o registro de compensa��o no SE5 finalizando o processo.

		// 1a parte, baixa apenas do titulo de tipo NCC
		DbSelectArea("SE5")
		RecLock("SE5",.T.)
			SE5->E5_FILIAL  := xFilial("SE5")
			SE5->E5_DATA    := dDataBase
			SE5->E5_TIPO    := "NCC"
			SE5->E5_VALOR   := SE1->E1_VALOR
			SE5->E5_NATUREZ := _cNatCR
			SE5->E5_DOCUMEN := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+"NF"+"01"
			SE5->E5_RECPAG  := "R"
			SE5->E5_BENEF   := SA1->A1_NOME
			SE5->E5_HISTOR  := "Baixa por Compensacao"
			SE5->E5_TIPODOC := "BA"
			SE5->E5_VLMOED2 := SE1->E1_VALOR
			SE5->E5_LA      := "S"
			SE5->E5_LOTE    := "8850"
			SE5->E5_PREFIXO := SE1->E1_PREFIXO
			SE5->E5_NUMERO  := _cNumFict  
			SE5->E5_PARCELA := SE1->E1_PARCELA
			SE5->E5_CLIFOR  := SC9->C9_CLIENTE
			SE5->E5_LOJA    := SC9->C9_LOJA
			SE5->E5_DTDIGIT := dDatabase
			SE5->E5_MOTBX   := "CMP"
			SE5->E5_SEQ     := "01"
			SE5->E5_DTDISPO := dDatabase
			SE5->E5_FILORIG := xFilial("SE5")
//			SE5->E5_FORNADT := SC9->C9_CLIENTE
//			SE5->E5_LOJAADT := SC9->C9_LOJA
			SE5->E5_CLIENTE := SC9->C9_CLIENTE
		MsUnlock()
		
		// 2a. parte, baixa do titulo NF
		DbSelectArea("SE5")
		RecLock("SE5",.T.)
			SE5->E5_FILIAL  := xFilial("SE5")
			SE5->E5_DATA    := dDatabase
			SE5->E5_TIPO    := "NF"
			SE5->E5_VALOR   := SE1->E1_VALOR
			SE5->E5_NATUREZ := _cNatCR
			SE5->E5_DOCUMEN := aTitulos[nTitulo][1]+aTitulos[nTitulo][2]+aTitulos[nTitulo][3]+aTitulos[nTitulo][4]+'01' //SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+"NCC"+"01" //**** AJUSTAR ****
			SE5->E5_RECPAG  := "R"
			SE5->E5_BENEF   := SA1->A1_NOME
			SE5->E5_HISTOR  := "Compens. Adiantamento"
			SE5->E5_TIPODOC := "CP"
			SE5->E5_VLMOED2 := SE1->E1_VALOR
			SE5->E5_LA      := "S"
			SE5->E5_LOTE    := "8850"
			SE5->E5_PREFIXO := SE1->E1_PREFIXO
			SE5->E5_NUMERO  := _cNumFict
			SE5->E5_PARCELA := SE1->E1_PARCELA
			SE5->E5_CLIFOR  := SC9->C9_CLIENTE
			SE5->E5_LOJA    := SC9->C9_LOJA
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_MOTBX   := "CMP"
			SE5->E5_SEQ     := "01"
			SE5->E5_DTDISPO := dDataBase
			SE5->E5_FILORIG := xFilial("SE5")
			SE5->E5_CLIENTE := SC9->C9_CLIENTE
		MsUnlock()
	ENDIF
Next nTitulo

//Bloco estava aqui anteriormente



RestArea(aAreaSC6)

RETURN(lRet)
