#include "DellaVia.ch"

User Function DESTA08

	Private c_Num     := Space(14)
	Private c_X_Statu := Space(1)
	Private c_DatRF   := ctod("  /  /  ")
	Private c_OBS     := Space(30)
	
	Define Font oFontBold Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 250,510 DIALOG oDlg1 TITLE "Ajusta Ordem de Produção" 

	@ 030,005 TO 120,250 Title "Ordem de Produção" PIXEL

	@ 037,010 SAY "Número OP  "  Pixel Font oFontBold 
	@ 035,045 GET c_Num          Pixel Picture "@!" F3 "SC2" SIZE 60,7 VALID VldOP(" ") OBJECT oNumOP

	@ 052,010 SAY "X_Status   "  Pixel Font oFontBold 
	@ 050,045 GET c_X_Statu      Pixel Picture "@!" SIZE 60,7 OBJECT oGetXStat 

	@ 067,010 SAY "Data RF    "  Pixel Font oFontBold 
	@ 065,045 GET c_DatRF        Pixel SIZE 60,7 OBJECT oGetDatRF

	@ 082,010 SAY "Observação "  Pixel Font oFontBold 
	@ 080,045 GET c_Obs          Pixel Picture "@!" SIZE 100,7 OBJECT oGetObs
                                                                                                     
	@ 095,185 BMPBUTTON TYPE 1 ACTION AtuOP()
	@ 095,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
                                                                    
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuOP()
	Local cSql := ""
	If !msgbox("Confirma alteração ?","Custo","YESNO")
		Return
	Endif

	dbSelectArea("SC2")
	If RecLock("SC2",.F.)
		SC2->C2_X_Statu := c_X_Statu
		SC2->C2_DatRF   := c_DatRF
		SC2->C2_Obs     := c_Obs
		MsUnlock()
	Endif
	oGetXStat:cCaption := " " 
	c_X_Statu          := " "
	oGetDatRF:cCaption := DTOC(CTOD("  /  /  "))
	c_DatRF            := ctod("  /  /  ")
	oGetObs:cCaption   := SPACE(30)
	c_Obs              := SPACE(30)
    oNumOp:cCaption    := SPACE(14)
	c_Num              := Space(14)
	oNumOP:SetFocus()
Return

Static function VldOP(cVar01)
	Local lRet         := .T.
	oGetXStat:cCaption := SC2->C2_X_Statu 
	c_X_Statu          := SC2->C2_X_Statu
	oGetDatRF:cCaption := DTOC(SC2->C2_DatRF)
	c_DatRF            := SC2->C2_DatRF
	oGetObs:cCaption   := SC2->C2_Obs
	c_Obs              := SC2->C2_Obs
	
Return lRet

