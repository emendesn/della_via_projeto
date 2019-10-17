#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F070DTCR  �Autor  �Microsiga           � Data �  19/10/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para possibilitar ao usuario a informa�ao ���
���          � da data do credito do lote                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION F070DTCR()
LOCAL dDataCred := PARAMIXB
LOCAL nOPc1 := 1


DEFINE MSDIALOG oDlg FROM  102,5 TO 301,350 TITLE "Data do Cr�dito" PIXEL //"Baixas a Receber Em Lote"

@ 002,004 TO 040,080 OF oDlg  PIXEL

@ 015,009 SAY "Data " SIZE 30,07 OF oDlg PIXEL
@ 012,035 MSGET oBancolt VAR dDataCred      SIZE 20,10 OF oDlg PIXEL Valid .T.     
//dDataCred := SE1->E1_BAIXA
//RecLock("SE5",.f.)
//SE5->E5_DTDISPO := SE5->E5_DATA
//SE5->E5_DTDISPO := dDataCred
//MsUnlock()

@ 045,009 SAY OemToAnsi("A data informada nesta tela, ser� considerada como") OF oDlg PIXEL
@ 057,009 SAY "Data de Cr�dito no t�tulo totalizador do lote baixado."        OF oDlg PIXEL

DEFINE SBUTTON FROM 080, 100 TYPE 1 ENABLE OF oDlg ACTION (nOpc1 := 1,oDlg:End())
DEFINE SBUTTON FROM 080, 130 TYPE 2 ENABLE OF oDlg ACTION (nOpc1 := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED



If nOpc1 # 1
	IF !IW_MSGBOX("Ser� considerada a database do sistema como a data do cr�dito, deseja continuar",;
	" * * *  A T E N C A O * * *  ","YESNO")
		U_F070DTCR()
	ENDIF
Endif

Return(dDataCred)