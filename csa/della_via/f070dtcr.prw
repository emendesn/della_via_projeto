/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF070DTCR  บAutor  ณMicrosiga           บ Data ณ  19/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para possibilitar ao usuario a informa็ao บฑฑ
ฑฑบ          ณ da data do credito do lote                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION F070DTCR()
LOCAL dDataCred := PARAMIXB
LOCAL nOPc1 := 1


DEFINE MSDIALOG oDlg FROM  102,5 TO 301,350 TITLE "Data do Cr้dito" PIXEL //"Baixas a Receber Em Lote"
@ 002,004 TO 040,080 OF oDlg  PIXEL

@ 015,009 SAY "Data " SIZE 30,07 OF oDlg PIXEL
@ 012,035 MSGET oBancolt VAR dDataCred      SIZE 20,10 OF oDlg PIXEL Valid .T.

@ 045,009 SAY OemToAnsi("A data informada nesta tela, serแ considerada como") OF oDlg PIXEL
@ 057,009 SAY "Data de Cr้dito no tํtulo totalizador do lote baixado."        OF oDlg PIXEL

DEFINE SBUTTON FROM 080, 100 TYPE 1 ENABLE OF oDlg ACTION (nOpc1 := 1,oDlg:End())
DEFINE SBUTTON FROM 080, 130 TYPE 2 ENABLE OF oDlg ACTION (nOpc1 := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc1 # 1
	IF !IW_MSGBOX("Serแ considerada a database do sistema como a data do cr้dito, deseja continuar",;
	" * * *  A T E N C A O * * *  ","YESNO")
		U_F070DTCR()
	ENDIF
Endif

Return(dDataCred)