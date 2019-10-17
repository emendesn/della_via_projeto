#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F070DTCR  ºAutor  ³Microsiga           º Data ³  19/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para possibilitar ao usuario a informaçao º±±
±±º          ³ da data do credito do lote                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION F070DTCR()
LOCAL dDataCred := PARAMIXB
LOCAL nOPc1 := 1


DEFINE MSDIALOG oDlg FROM  102,5 TO 301,350 TITLE "Data do Crédito" PIXEL //"Baixas a Receber Em Lote"

@ 002,004 TO 040,080 OF oDlg  PIXEL

@ 015,009 SAY "Data " SIZE 30,07 OF oDlg PIXEL
@ 012,035 MSGET oBancolt VAR dDataCred      SIZE 20,10 OF oDlg PIXEL Valid .T.     
//dDataCred := SE1->E1_BAIXA
//RecLock("SE5",.f.)
//SE5->E5_DTDISPO := SE5->E5_DATA
//SE5->E5_DTDISPO := dDataCred
//MsUnlock()

@ 045,009 SAY OemToAnsi("A data informada nesta tela, será considerada como") OF oDlg PIXEL
@ 057,009 SAY "Data de Crédito no título totalizador do lote baixado."        OF oDlg PIXEL

DEFINE SBUTTON FROM 080, 100 TYPE 1 ENABLE OF oDlg ACTION (nOpc1 := 1,oDlg:End())
DEFINE SBUTTON FROM 080, 130 TYPE 2 ENABLE OF oDlg ACTION (nOpc1 := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED



If nOpc1 # 1
	IF !IW_MSGBOX("Será considerada a database do sistema como a data do crédito, deseja continuar",;
	" * * *  A T E N C A O * * *  ","YESNO")
		U_F070DTCR()
	ENDIF
Endif

Return(dDataCred)