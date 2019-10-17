/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³sangriaM  ºAutor  ³Marcelo Alcantara   º Data ³  06/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a Sangria manualmente de R$ e Cheque para banco espe º±±
±±º          ³cifico (Transf. de bancos manual                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaLoja                                                   º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "rwmake.ch"
#Include "Protheus.Ch"
#Include "TopConn.ch"	
//#INCLUDE "TBICONN.CH"

User Function SangriaM()
Local aCmbTipo  := {"R$ - Dinheiro","CH - Cheque"}
local oFont
local oTotd
local oTotc
Local cSE5 := RetSQLName("SE5")
Local _cOperador	:=SLF->LF_COD

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "loja" // Prepara Ambiente para teste

private oCombo
dbSelectArea("SE5")
//dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0"))
Private cBanco		:= CriaVar("E5_BANCO")
Private cAgencia	:= CriaVar("E5_AGENCIA")
Private cConta		:= CriaVar("E5_CONTA")
Private cHistorico	:= CriaVar("E5_HISTOR")
Private cNumDoc		:= CriaVar("E5_NUMCHEQ")
Private nValor		:= 0.00
Private cCombo
Private oDlg
Private nVlr

dbSelectArea("SLJ")
dbSetOrder(1)
dbGoTop()
dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0"))
cBanco	:= LJ_BCODEP
cAgencia:= LJ_AGDEP
cConta	:= LJ_CNTDEP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Calcula Saldo de Valores em Dinheiro no Caixa
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
dbSelectArea("SE5")
dbSetOrder(1)
dbGoTop()
private nTotDin:= 0
if dbSeek(xfilial("SE5")+DTOS(dDataBase)+SLF->LF_COD)
	do While E5_FILIAL==xFilial("SE5") .and. E5_DATA==dDataBase .and. E5_BANCO==SLF->LF_COD
		If E5_RECPAG=="R" .and. E5_TIPODOC=="LJ" .and. Trim(E5_TIPO)=="R$" //Venda em Dinheiro
			nTotDin+= E5_VALOR
		elseif E5_RECPAG=="R" .and. E5_MOEDA=="R$" .and. EMPTY(E5_TIPO) .and. EMPTY(E5_TIPODOC) // Lancamentos a Receber
			nTotDin+= E5_VALOR					
		elseif E5_RECPAG=="R" .and. E5_TIPODOC=="TR" .and. Trim(E5_MOEDA)=="TC" .and. Trim(E5_NATUREZ)=="FUNDO CX" // Fundo de Caixa
			nTotDin+= E5_VALOR		
		Elseif E5_RECPAG=="R" .and. E5_TIPODOC=="VL" .and. E5_MOEDA=="R$" //Recebimento de Titulos
			nTotDin+= E5_VALOR		
		elseif (E5_RECPAG=="P" .and. E5_MOEDA=="R$" .and. EMPTY(E5_TIPO) .and. EMPTY(E5_TIPODOC)) .or.;
			   (E5_RECPAG=="P" .and. E5_MOEDA=="R$" .and. E5_TIPODOC=="TR" .and. Trim(E5_NATUREZ)=="SANGRIA") //Despesas e sangrias
			nTotDin-= E5_VALOR
		elseif E5_RECPAG=="P" .and. TRIM(E5_TIPO)=="R$" .and. E5_TIPODOC=="LJ" .and. Trim(E5_NATUREZ)=="DEV./TROCA" //Troca
			If SF1->(dbSeek(xFilial("SF1")+SE5->E5_NUMERO+SE5->E5_PREFIXO+SE5->E5_CLIFOR+SE5->E5_LOJA))
				nTotDin-= E5_VALOR
			EndIf
		EndIf
		dbSkip()
	Enddo
EndIf
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Calcula saldo de Valores em Cheque A VISTA
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
private nTotCh := 0
dbSelectArea("SE1")
dbSetOrder(6)
dbGoTop()
if dbSeek(xFilial("SE1")+DTOS(dDataBase))
	do While E1_FILIAL==xFilial("SE1") .and. E1_EMISSAO == dDataBase
		if Trim(E1_PORTADO)==Trim(SLF->LF_COD) .and. Trim(E1_TIPO)=="CH" .and. E1_EMISSAO==E1_VENCTO
			nTotCh+= E1_VALOR
		endif
		dbSkip()
	enddo
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Verifica se houve recebimento de titulos com Cheque
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
dbSelectArea("SE5")
cSQLREC := "select * from " + cSE5
cSQLREC += " where D_E_L_E_T_ <> '*'"
cSQLREC += " and E5_BANCO = '" + _cOperador + "' "
cSQLREC += " and E5_RECPAG = 'R' and E5_TIPODOC = 'VL' and E5_MOEDA = 'CH'"
cSQLREC += " and (E5_TIPO = 'NF' or E5_TIPO = 'DP' or E5_TIPO = 'FI' or E5_TIPO = 'BO')"
cSQLREC += " and E5_DATA = '" +DTOS(dDataBase) + "'"
cSQLREC += "order by E5_MOEDA"

tcQuery cSQLREC New Alias "QREC"

_cDoca	:= ""
Do While !eof()
	//Verifica se e cheque Predatado ou a vista
	If QREC->E5_MOEDA = "CH" .and. _cDoca <> QREC->E5_PREFIXO+QREC->E5_NUMERO+QREC->E5_PARCELAQ+QREC->E5_TIPO
		DbSelectArea("SEF")
		dbSetOrder(3)
		_cPrefixo	:= QREC->E5_PREFIXO
		_cTitulo	:= QREC->E5_NUMERO
		_cParcela	:= QREC->E5_PARCELA
		_cTipo		:= QREC->E5_TIPO
		_cMoeda		:= "CH"
		dbSeek(xFilial("SEF")+_cPrefixo+_cTitulo+_cParcela+_cTipo)
		Do While EF_PREFIXO=_cPrefixo .and. EF_TITULO=_cTitulo .and. EF_PARCELA=_cParcela .and. EF_TIPO=_cTipo .and. !eof()
			If DTOS(EF_VENCTO) = (QREC->E5_DATA)
				nTotCh+=EF_VALOR
			EndIf
			dbSkip()
		EndDo
		DbSelectArea("QREC")
		_cDoca:= QREC->E5_PREFIXO+QREC->E5_NUMERO+QREC->E5_PARCELA+QREC->E5_TIPO
	EndIf
	dbSkip()
EndDo
QREC->(dbCloseArea())
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Subtrai Sangrias ja Efetuadas com Cheque
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

dbselectarea("SE5")
	dbGoTop()
	if dbSeek(xfilial("SE5")+DTOS(dDataBase)+SLF->LF_COD)
		Do While E5_FILIAL==xFilial("SE5") .and. E5_DATA==dDataBase .and. E5_BANCO==SLF->LF_COD
			IF E5_RECPAG=="P" .and. E5_TIPODOC=="TR" .and. Trim(E5_MOEDA)=="CH" .and. Trim(E5_NATUREZ)=="SANGRIA";
				 .and. TRIM(E5_HISTOR) # "TRANSF. AUTOMAT. CHEQUE A PRAZO"
    			nTotCh-= E5_VALOR
    		ENDIF
    		dbSkip()
    	Enddo
   	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe dados a serem digitados  							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")
DEFINE MSDIALOG oDlg TITLE "Transferencia de Caixa Manual" FROM 0,0 TO 280,552 OF oDlg PIXEL
DEFINE FONT oFont NAME "Arial"
@ 06,06 TO 045,271 LABEL "  Destino  " PIXEL
@ 50,06 TO 110,271 LABEL "  Identificacao  " PIXEL
@ 15, 015 Say "Banco:"		PIXEL
@ 15, 046 Say "Agencia:"	PIXEL
@ 15, 078 Say "Conta:"		PIXEL
@ 55, 015 Say "Tipo:"		PIXEL
@ 55, 084 Say "Num. Doc."	PIXEL
@ 55, 110 Say "Valor:"		PIXEL
@ 80, 015 Say "Historico"	PIXEL
@ 25, 015 MSGET oBanco 	var cBanco /*F3 "SA6"*/Picture "@S3" Valid CarregaSa6(@cBanco,@cAgencia,@cConta,.F.) .and. ValBco() SIZE 10, 10 WHEN .F. OF oDlg PIXEL
@ 25, 046 MSGET cAgencia  	Picture "@S5" Valid if(CarregaSa6(@cBanco,@cAgencia,@cConta,.F.) .and. ValBco(),.T., oBanco:SetFocus())  SIZE 20, 10 WHEN .F. OF oDlg PIXEL
@ 25, 078 MSGET cConta	    Picture "@S10" Valid If(CarregaSa6(@cBanco,@cAgencia,@cConta,.F.,,.T.) .and. ValBco() ,.T.,oBanco:SetFocus()) SIZE 45, 10 WHEN .F. OF oDlg PIXEL
@ 65, 015 COMBOBOX oCombo 	Var cCombo ITEMS aCmbTipo SIZE 60,10 OF oDlg PIXEL ON CHANGE (mTela(),oDlg:Refresh())
@ 65, 082 MSGET cNumDoc   	Picture PesqPict("SE5", "E5_NUMCHEQ") OF oDlg PIXEL
@ 65, 175 MSGET nValor   	Picture PesqPict("SE5","E5_VALOR",15) Valid validazero() OF oDlg PIXEL
@ 90, 015 MSGET cHistorico 	Picture "@S25" OF oDlg PIXEL
@ 115,196 BUTTON "&Ok"  SIZE 36,16 PIXEL ACTION sanTransf()
@ 115,235 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()
@ 119,015 Say "Total em Caixa : " pixel
mTela()
ACTIVATE MSDIALOG oDlg CENTER    

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para Efetuar o Lancamento de Transferencia            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function sanTransf()
local cTipo

if SimNao("Deseja realmente efetuar essa Transferencia?","Confirmacao")<>"S"  
	Return
EndIf
cTipo:= SubStr(cCombo,1,2)

U_AutoSang(cBanco,cAgencia,cConta,cNumDoc,cHistorico,cTipo,nValor)
MsgInfo("   Transferencia Efetuada !!   ","Mensagem")
oDlg:End()
Return

User Function AutoSang(cBanco,cAgencia,cConta,cNumDoc,cHistorico,cTipo,nValor)
local cBancoOri
local cAgenciaOri
local cContaOri
local _aArea:= GetArea()
dbSelectArea("SE5")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega dados do Banco de Origem   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBancoOri:= SLF->LF_COD
if !CarregaSa6(@cBancoOri,@cAgenciaOri,@cContaOri,.F.)
	Msgbox("Erro ao encontrar Banco do Caixa " + cBancoOri)
	Return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza movimentacao bancaria de Saida			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Reclock("SE5",.T.)
SE5->E5_FILIAL	:= xFilial()
SE5->E5_DATA	:= dDataBase
SE5->E5_BANCO	:= cBancoOri
SE5->E5_AGENCIA	:= cAgenciaOri
SE5->E5_CONTA	:= cContaOri
SE5->E5_RECPAG	:= "P"
SE5->E5_NUMCHEQ	:= cNumDoc
SE5->E5_HISTOR	:= cHistorico
SE5->E5_TIPODOC	:= "TR"
//SE5->E5_TIPO	:= cTipo
SE5->E5_VALOR	:= nValor
SE5->E5_MOEDA	:= cTipo
SE5->E5_DTDIGIT	:= dDataBase
SE5->E5_DTDISPO := SE5->E5_DATA
SE5->E5_NATUREZ := "SANGRIA"
SE5->E5_FILORIG := cFilAnt
//SE5->E5_PREFIXO := SLG->LG_SERIE
MsUnLock()	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Saldo Bancario de Saida
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AtuSalBco(cBancoOri,cAgenciaOri,cContaOri,dDataBase,SE5->E5_VALOR,"-")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza movimentacao bancaria de Entrada 					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Reclock("SE5",.T.)
SE5->E5_FILIAL	:= xFilial()
SE5->E5_DATA	:= dDataBase
SE5->E5_BANCO	:= cBanco
SE5->E5_AGENCIA	:= cAgencia
SE5->E5_CONTA	:= cConta
SE5->E5_RECPAG	:= "R"
SE5->E5_DOCUMEN	:= cNumDoc
SE5->E5_HISTOR	:= cHistorico
SE5->E5_TIPODOC	:= "TR"
//SE5->E5_TIPO	:= cTipo
SE5->E5_VALOR	:= nValor
SE5->E5_MOEDA	:= cTipo
SE5->E5_DTDIGIT	:= dDataBase
SE5->E5_DTDISPO := SE5->E5_DATA
SE5->E5_NATUREZ := "SANGRIA"
SE5->E5_FILORIG := cFilAnt

MsUnLock()	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Saldo Bancario de Entrada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AtuSalBco(cBanco,cAgencia,cConta,dDataBase,SE5->E5_VALOR,"+")
RestArea(_aArea)
Return 



Static Function ValBco()
aArea:= GetArea()
dbSelectArea("SLJ")
dbSetOrder(1)
dbGoTop()
dbSeek(xfilial("SLJ")+PADL(SM0->M0_CODFIL,6,"0"))
if cBanco==LJ_BCODEP .and. cAgencia==LJ_AGDEP .and. cConta==LJ_CNTDEP
	RestArea(aArea)
	Return .T.
EndIf
Aviso("Erro na Conta","Banco, Agencia ou Conta Invalido. Verifique",{"OK"})
RestArea(aArea)
Return .F.


Static Function mTela() 
//local nVlr
nVlr:= 0.00
if oCombo:nat==1
	nVlr:= nTotDin
else
	nVlr:= nTotCh
endif
@ 115,60 msGet nVlr Picture "@E 99,999,999.99" When .F. Pixel
oDlg:Refresh()

Return

Static Function validazero()
 if nValor >= 0 .And. nValor <= nVlr
    Return .T.
 endif
Aviso("Valor Incorreto","O valor informado deve ser maior ou igual ao Valor do Saldo",{"OK"})
Return .F.
