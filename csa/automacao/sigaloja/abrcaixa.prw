/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ABRCAIXA  ºAutor  ³Marcelo Alcantara   º Data ³  01/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a Abertura do Caixa na Data Atual recuperando o saldo  º±±
±±º          ³ deixado no dia anterior                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DELLA VIA                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "rwmake.ch"
#Include "Protheus.Ch"

User Function AbrCaixa()
local cBanco								//Banco para Transferencia do Fundo de Caixa
local cAgencia								//Agencia	
local cConta								//Conta
local cNumDoc:= DTOS(dDataBase)+"F"			//Numero do Documento
local cHistorico:= "Fundo de Caixa do dia"	//Historico
local nValor:= 0.00							//Valor do Fundo de Caixa
local cTipo:= "TC"							//Tipo
local oDlg	
local oAbertura
local nOpcA:= 2
local cCaixa
local cNome
local dData
local nFundCx
Local aArea 	:= GetArea()
dbSelectArea("SA6")
dbSeek(xFilial("SA6")+SLF->LF_COD)
if A6_DATAABR>dDataBase
	Aviso("Caixa Aberto","Ja Existe Caixa com Data Posterior Aberto.",{"OK"})
	RestArea(aArea)
	Return
endif
if A6_DATAABR=dDataBase
	Aviso("Caixa Aberto","O Caixa ja Esta Aberto",{"OK"})
	RestArea(aArea)
	Return
Endif
if (A6_DATAABR<dDatabase .and.!Empty(A6_DATAABR)) .and. empty(A6_DATAFCH)
	Aviso("Caixa Aberto","Caixa do Dia "+DtoC(A6_DATAABR)+" ainda esta Aberto.",{"OK"})
	RestArea(aArea)
	Return
endif
if dDataBase<=A6_DATAFCH .and. !empty(A6_DATAFCH)
	Aviso("Caixa Fechado","O Caixa desta Data Ja esta Fechado, Nao é Possivel abri-lo Novamente",{"OK"})
	RestArea(aArea)
	Return
Endif

cCaixa := SA6->A6_COD
cNome  := Capital(SA6->A6_NREDUZ)
dData  := dDataBase
nFundCx:= SA6->A6_SALANT

DEFINE MSDIALOG oDlg FROM 84,71 TO 231,509 TITLE "Abertura do Caixa" PIXEL

@ -1, 3 TO 33, 184 OF oDlg  PIXEL
@ 35, 3 TO 68, 218 OF oDlg  PIXEL

DEFINE SBUTTON FROM	3,189 TYPE 1 ENABLE OF oDlg ACTION ( nOpcA := 1,oDlg:End() )
DEFINE SBUTTON FROM 16,189 TYPE 2 ENABLE OF oDlg ACTION ( nOpcA := 2,oDlg:End() )
DEFINE FONT oFont NAME "Courier New"
@ 08, 005 SAY "Caixa" SIZE 18, 7 OF oDlg PIXEL	 // Caixa
@ 08, 096 SAY "Data Movimento"  SIZE 48, 7 OF oDlg PIXEL	 // Data Movimento
@ 20, 005 SAY "Nome"  SIZE 17, 7 OF oDlg PIXEL	 // Nome
@ 07, 028 MSGET oCaixa Var cCaixa SIZE 14, 9 WHEN .F. OF oDlg PIXEL
@ 07, 140 MSGET oData  Var dData  SIZE 41, 9 WHEN .F. OF oDlg PIXEL
@ 20, 028 MSGET oNome  Var cNome  SIZE 56, 9 WHEN .F. OF oDlg PIXEL
@ 41, 015 SAY "Fundo de Caixa do Dia Anterior:" SIZE 180, 22 OF oDlg PIXEL FONT oFont
//@ 41, 130 SAY nFundCx Picture "@E 999,999.99" SIZE 50,7 OF oDLG PIXEL FONT oFont
@ 41, 130 SAY oAbertura VAR nFundCx Picture "@E 999,999.99" SIZE 50,30 OF oDLG PIXEL FONT oFont // ABERTURA
oAbertura:SetColor( CLR_GREEN, GetSysColor(15) )

ACTIVATE MSDIALOG oDlg CENTERED

if nOpcA == 1
	if RecLock("SA6",.F.)
		SA6->A6_DATAFCH:= CtoD("  /  /  ")
		SA6->A6_HORAFCH:= ""
		SA6->A6_DATAABR:= dDataBase
		SA6->A6_HORAABR:= Time()
		msUnlock()
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza movimentacao bancaria de Entrada 			    	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cBanco:= SLF->LF_COD
	if !CarregaSa6(@cBanco,@cAgencia,@cConta,.F.)
		Msgbox("Erro ao encontrar Banco do Caixa " + cBanco)
		RestArea(aArea)
		Return
	endif
	nValor:=nFundCx
	
	dbSelectArea("SE5")
	If Reclock("SE5",.T.)
		SE5->E5_FILIAL	:= xFilial()
		SE5->E5_DATA	:= dDataBase
		SE5->E5_BANCO	:= cBanco
		SE5->E5_AGENCIA	:= cAgencia
		SE5->E5_CONTA	:= cConta
		SE5->E5_RECPAG	:= "R"
		SE5->E5_DOCUMEN	:= cNumDoc
		SE5->E5_HISTOR	:= cHistorico
		SE5->E5_TIPODOC	:= "TR"
		SE5->E5_VALOR	:= nValor
		SE5->E5_MOEDA	:= cTipo
		SE5->E5_DTDIGIT	:= dDataBase
		SE5->E5_DTDISPO := SE5->E5_DATA
		SE5->E5_NATUREZ := "FUNDO CX"
		SE5->E5_FILORIG := cFilAnt
		MsUnLock()
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Saldo Bancario de Entrada                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	AtuSalBco(cBanco,cAgencia,cConta,dDataBase,SE5->E5_VALOR,"+")
Endif
RestArea(aArea)
Return

