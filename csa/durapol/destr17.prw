#include "DellaVia.ch"

User Function DESTA08
	Private c_Num     := Space(10)
	Private c_X_Statu := Space(1)
	Private c_DatRF   := ctod("  /  /  ")
	Private c_OBS     := Space(30)
	Private lInclui  := .F.


	Define Font oFontBold Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 250,510 DIALOG oDlg1 TITLE "Ajusta Ordem de Produção"

	@ 030,005 TO 120,250 Title "Ordem de Produção" PIXEL

	@ 037,010 SAY "Número OP :"  Font oFontBold Pixel
	@ 035,045 GET c_Num      Picture "!!!!!!!!!!" F3 "SC2" SIZE 60,10 VALID VldOP(c_Num) .OR. Empty(c_Num) OBJECT oNumOP
	@ 037,110 SAY "" PIXEL OBJECT oDescOP SIZE 100,10
	@ 037,225 SAY "" Font oFontBold PIXEL OBJECT oAction SIZE 20,10 Right

	@ 052,010 SAY "X_Status  :"  Font oFontBold Pixel
	@ 050,045 GET c_X_Statu    Picture "!" SIZE 60,10 When .F.

	@ 067,010 SAY "Data RF   :"  Font oFontBold Pixel
	@ 065,045 GET c_DatRF      SIZE 60,10 

	@ 082,010 SAY "Observação:"  Font oFontBold Pixel
	@ 080,045 GET c_Obs        Picture "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" SIZE 60,10

	@ 095,185 BMPBUTTON TYPE 1 ACTION AtuOP()
	@ 095,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
                                                                    
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuOP()
	Local cSql := ""
	If !msgbox("Confirma alteração ?","Custo","YESNO")
		Return
	Endif

	if Empty(c_Num)
		msgbox("Número da Ordem de Produção não fornecida ... FFOOOOOOII","Ajuste","STOP")
		oNumOP:SetFocus()
		Return
	Endif

	dbSelectArea("SC2")
	If !lInclui
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SC2")+c_Num)
	Endif

	If RecLock("SC2",lInclui)
		SC2->C2_X_Statu := c_X_Statu
		SC2->C2_DatRF   := c_DatRF
		SC2->C2_Obs     := c_Obs
		MsUnlock()
	Endif

	oDescOP:cCaption   := ""
	oAction:cCaption   := ""
	c_Num              := Space(10)
	c_X_Statu          := Space(01)
	c_DatRF            := ctod("  /  /  ")
	c_obs              := Space(30)
	oNumOP:SetFocus()
Return

Static function VldOP(cVar01)
	Local lRet         := .F.
	oDescOP:cCaption   := ""
	oAction:cCaption   := ""
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SC2")+cVar01)
	If Found()
		lRet := .T.
		oDescOP:cCaption := C2_Obs
	Endif
	
	If lRet
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SC2")+cVar01)
		If Found()
			lInclui := .F.
			oAction:cCaption := "Alterar"
			oAction:nClrText := RGB(0,0,255)
			c_X_Statu        := SC2->C2_X_Statu
			c_DatRF          := SC2->C2_DatRF
		Endif
	Endif
Return lRet

