#include "DellaVia.ch"

User Function DVLOJF03
	Private cTabela  := Space(3)
	Private cCodPro  := Space(15)
	Private nPrcBase := 0
	Private nPrcVen  := 0
	Private nVlrDes  := 0
	Private nFator   := 0
	Private lInclui  := .F.


	Define Font oFontBold Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 280,510 DIALOG oDlg1 TITLE "Ajusta Tabela de Preço"

	@ 005,005 TO 025,250 Title "Tabela" PIXEL
	@ 012,010 SAY "Código:"  Font oFontBold Pixel
	@ 010,035 GET cTabela Picture "@!" F3 "DA0" SIZE 10,10 OBJECT oGetTab VALID VldTab(cTabela) Pixel
	@ 012,070 SAY "" PIXEL OBJECT oDescTab SIZE 100,10

	@ 030,005 TO 135,250 Title "Item" PIXEL

	@ 037,010 SAY "Código:"  Font oFontBold Pixel
	@ 035,045 GET cCodPro Picture "@!" F3 "SB1" SIZE 60,10 VALID VldProd(cCodPro) .OR. Empty(cCodPro) OBJECT oCodPro Pixel
	@ 037,110 SAY "" PIXEL OBJECT oDescProd SIZE 100,10
	@ 037,225 SAY "" Font oFontBold PIXEL OBJECT oAction SIZE 20,10 Right

	@ 052,010 SAY "Prc. Base:"  Font oFontBold Pixel
	@ 050,045 GET nPrcBase Picture "@e 99,999,999,999.99" SIZE 60,10 When .F.  Pixel

	@ 067,010 SAY "Prc. Venda:"  Font oFontBold Pixel
	@ 065,045 GET nPrcVen Picture "@e 99,999,999,999.99" SIZE 60,10 VALID nPrcVen > 0  Pixel

	@ 082,010 SAY "Desconto:"  Font oFontBold Pixel
	@ 080,045 GET nVlrDes Picture "@e 99,999,999,999.99" SIZE 60,10  Pixel

	aOpcoes := {"1-Preco Venda","2-Preco Base"}
	cCmb    := ""
	@ 097,010 SAY "Base Fator:"  Font oFontBold Pixel
	@ 095,045 COMBOBOX cCmb ITEMS aOpcoes SIZE 60,10 PIXEL

	@ 112,010 SAY "Fator:"  Font oFontBold Pixel
	@ 110,045 GET nFator Picture "@e 999.9999" SIZE 60,10 Valid MudaPrc() Pixel

	@ 110,185 BMPBUTTON TYPE 1 ACTION AtuPrc()
	@ 110,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function MudaPrc
	if SubStr(cCmb,1,1) = "1"
		nPrcVen := nPrcVen * nFator
	Else
		nPrcVen := nPrcBase * nFator
	Endif
Return .T.

Static Function AtuPrc()
	Local cSql := ""
	If !msgbox("Confirma alteração ?","Custo","YESNO")
		Return
	Endif

	if Empty(cCodPro)
		msgbox("Código do produto não preenchido","Ajuste","STOP")
		oCodPro:SetFocus()
		Return
	Endif

	If lInclui
		cSql := "SELECT INTEGER(MAX(DA1_ITEM))+1 AS MAX"
		cSql += " FROM "+RetSqlName("DA1")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   DA1_FILIAL = '"+xFilial("DA1")+"'"
		cSql += " AND   DA1_CODTAB = '"+cTabela+"'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MAX", .T., .T.)
		dbSelectArea("SQL_MAX")
		cItem := StrZero(MAX,4)
		dbCloseArea()
	Endif

	dbSelectArea("DA1")
	If !lInclui
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("DA1")+cTabela+cCodPro)
	Endif

	If RecLock("DA1",lInclui)
		if lInclui
			DA1->DA1_FILIAL := xFilial("DA1")
			DA1->DA1_CODTAB := cTabela
			DA1->DA1_CODPRO := cCodPro
			DA1->DA1_ITEM   := cItem
			DA1->DA1_ATIVO  := "1"
			DA1->DA1_TPOPER := "4"
			DA1->DA1_QTDLOT := 999999.99
			DA1->DA1_INDLOT := StrZero(DA1->DA1_QTDLOT,18,2)
			DA1->DA1_MOEDA  := 1
		Endif
		DA1->DA1_PRCVEN := nPrcVen
		DA1->DA1_VLRDES := nVlrDes
		DA1->DA1_PERDES := nFator
		MsUnlock()
	Endif

	oDescProd:cCaption := ""
	oAction:cCaption   := ""
	cCodPro  := Space(15)
	nPrcBase := 0
	nPrcVen  := 0
	nVlrDes  := 0
	nFator   := 0
	oCodPro:SetFocus()
Return

Static function VldProd(cVar01)
	Local lRet := .F.
	oDescProd:cCaption := ""
	oAction:cCaption   := ""
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SB1")+cVar01)
	If Found()
		lRet := .T.
		oDescProd:cCaption := B1_DESC
	Endif
	
	If lRet
		dbSelectArea("DA1")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("DA1")+cTabela+cVar01)
		If Found()
			lInclui := .F.
			oAction:cCaption := "Alterar"
			oAction:nClrText := RGB(0,0,255)
			nPrcBase := SB1->B1_PRV1
			nPrcVen  := DA1_PRCVEN
			nVlrDes  := DA1_VLRDES
			nFator   := DA1_PERDES
		else
			lInclui := .T.
			oAction:cCaption := "Incluir"
			oAction:nClrText := RGB(255,0,0)
			nPrcBase := SB1->B1_PRV1
			nPrcVen  := 0
			nVlrDes  := 0
			nFator   := 0
		Endif
	Endif
Return lRet

Static function VldTab(cVar01)
	Local lRet := .F.
	oDescTab:cCaption := ""
	dbSelectArea("DA0")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("DA0")+cVar01)
	If Found()
		lRet := .T.
		oDescTab:cCaption := DA0_DESCRI
	Endif
Return lRet