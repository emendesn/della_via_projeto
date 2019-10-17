#include "rwmake.ch"
#include "font.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVLOJC04
	Private cLjDV   := Space(2)
	Private cCodTab := Space(3)
	Private cProd   := Space(15)

	If AllTrim(cUserName) $ AllTrim(GetMv("MV_APDESC1",,""))
		If !(U_VLDIP(GetClientIP(),"192.1.1.20","192.1.1.180") .OR. U_VLDIP(GetClientIP(),"192.1.1.10","192.1.1.10"))
			Aviso("Aviso","Você não pode acessar esta rotina deste computador.",{"Ok"})
			Return nil
		Endif
	Endif


	Define Font oFontBold Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 280,510 DIALOG oDlg1 TITLE "Saldos de Produtos"
	@ 005,005 TO 055,250 //Loja - Produto - Tabela

	@ 012,010 SAY "Loja:" Object oLblLoja
	@ 010,040 GET cLjDV Picture "99" Valid U_LOJC04A() Object oGetLoja
	@ 012,100 SAY "" Object oLoja SIZE 100,20

	@ 027,010 SAY "Tabela:" Object oLblTab
	@ 025,040 GET cCodTab F3 "DA0" SIZE 30,20  Valid U_LOJC04D() Object oGetTab
	@ 027,100 SAY "" Object oTabela SIZE 100,20

	@ 042,010 SAY "Produto:" Object oLblProd
	@ 040,040 GET cProd F3 "SB1" SIZE 50,20  Valid U_LOJC04B() Object oGetProd
	@ 042,100 SAY "" Object oProd SIZE 100,20


	@ 060,005 TO 110,250 //Tabela - Estoque - Custo
	@ 065,010 SAY "Valor de Tabela:" Object oLblVlr
	@ 065,060 SAY "" Object oVlr SIZE 60,20

	@ 065,130 SAY "Quant. Estoque:" Object oLblEst
	@ 065,180 SAY "" Object oEst SIZE 60,20

	@ 080,010 SAY "Custo Médio:" Object oLblCM
	@ 080,060 SAY "" Object oCm SIZE 60,20

	@ 080,130 SAY "Mkp. CM:" Object oLblMkpCm
	@ 080,180 SAY "" Object oMkpCm SIZE 200,20

	@ 095,010 SAY "Custo Reposição:" Object oLblCr
	@ 095,060 SAY "" Object oCr SIZE 60,20

	@ 095,130 SAY "Mkp. CR:" Object oLblMkpCr
	@ 095,180 SAY "" Object oMkpCr SIZE 60,20

	@ 115,005 TO 135,250 //Botões
	@ 120,160 BUTTON "_Limpar" SIZE 40,11 ACTION U_LOJC04C()
	@ 120,205 BUTTON "Sai_r"   SIZE 40,11 ACTION Close(oDlg1)

	oLblLoja:oFont  := oFontBold
	oLblTab:oFont   := oFontBold
	oLblProd:oFont  := oFontBold
	oLblVlr:oFont   := oFontBold
	oLblEst:oFont   := oFontBold
	oLblCM:oFont    := oFontBold
	oLblMkpCM:oFont := oFontBold
	oLblCr:oFont    := oFontBold
	oLblMkpCr:oFont := oFontBold

	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

User Function LOJC04A()
	Local aArea := GetArea()
	Local lRet := .F.
	Local cSql := ""

	If Empty(cLjDV)
		Return .T.
	Endif

	cSql := "SELECT LJ_NOME FROM "+RetSqlName("SLJ")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   LJ_FILIAL = '"+xFilial("SLJ")+"'"
	cSql += " AND   LJ_RPCFIL = '"+cLjDV+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	If !Eof()
		lRet := .T.
		oLoja:cCaption := AllTrim(LJ_NOME)
	Else
		lRet := .F.
		oLoja:cCaption := ""
	Endif
	dbCloseArea()
	RestArea(aArea)
Return lRet

User Function LOJC04B()
	Local aArea   := GetArea()
	Local lRet    := .F.
	Local cSql    := ""
	Local nCusto  := 0
	Local nCstRep := 0

	If Empty(cLjDV) .OR. Empty(cProd) .OR. Empty(cCodTab)
		Return .T.
	Endif

	cSql := "SELECT B2_CM1"
	cSql += " FROM "+RetSqlName("SB2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   B2_FILIAL = '"+cLjDV+"'"
	cSql += " AND   B2_COD = '"+cProd+"'"
	cSql += " AND   B2_LOCAL = '01'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","B2_CM1","N",14,2)
	If !Eof()
		nCusto := B2_CM1
	Else
		nCusto := 0
	Endif
	dbCloseArea()


	cSql := "SELECT (D1_CUSTO/D1_QUANT) AS CUSTOREP"
	cSql += " FROM "+RetSqlName("SD1")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   D1_FILIAL = '"+cLjDV+"'"
	cSql += " AND   D1_COD = '"+cProd+"'"
	cSql += " ORDER BY R_E_C_N_O_ DESC"
	cSql += " FETCH FIRST 1 ROWS ONLY"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","CUSTOREP","N",14,2)
	If !Eof()
		nCstRep := CUSTOREP
	Else
		nCstRep := 0
	Endif
	dbCloseArea()


	cSql := "SELECT B1_DESC,DA1_PRCVEN,SUM(B2_QATU) AS SALDO"
	cSql += " FROM  "+RetSqlName("SB2")+" SB2"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = ''"
	cSql += " AND  B1_COD = B2_COD"

	cSql += " JOIN "+RetSqlName("DA1")+" DA1"
	cSql += " ON   DA1.D_E_L_E_T_ = ''"
	cSql += " AND  DA1_FILIAL = ''"
	cSql += " AND  DA1_CODTAB = '"+cCodTab+"'"
	cSql += " AND  DA1_CODPRO = B2_COD"

	cSql += " WHERE SB2.D_E_L_E_T_ = ''"
	cSql += " AND   B2_FILIAL = '"+cLjDV+"'"
	cSql += " AND   B2_COD = '"+cProd+"'"
	cSql += " AND   B2_LOCAL IN('01','02')"
	cSql += " GROUP BY B1_DESC,DA1_PRCVEN"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","DA1_PRCVEN","N",14,2)
	TcSetField("ARQ_SQL","SALDO"     ,"N",14,2)

	dbSelectArea("ARQ_SQL")
	If !Eof()
		lRet := .T.
		oProd:cCaption  := AllTrim(B1_DESC)
		oVlr:cCaption   := "R$ "+AllTrim(Transform(DA1_PRCVEN,"@e 99,999,999,999.99"))
		oEst:cCaption   := AllTrim(Transform(SALDO,"@e 99,999,999,999"))
		oCM:cCaption    := "R$ "+AllTrim(Transform(nCusto,"@e 99,999,999,999.99"))
		oMkpCM:cCaption := AllTrim(Transform(DA1_PRCVEN/nCusto,"@e 99,999,999,999.99"))
		oCr:cCaption    := "R$ "+AllTrim(Transform(nCstRep,"@e 99,999,999,999.99"))
		oMkpCr:cCaption := AllTrim(Transform(DA1_PRCVEN/nCstRep,"@e 99,999,999,999.99"))
	Else
		lRet := .F.
		oProd:cCaption  := ""
		oVlr:cCaption   := ""
		oEst:cCaption   := ""
		oCM:cCaption    := ""
		oMkpCM:cCaption := ""
		oCr:cCaption    := ""
		oMkpCr:cCaption := ""
	Endif
	dbCloseArea()

	RestArea(aArea)
Return lRet

User Function LOJC04C()
	oGetLoja:cCaption := ""
	oGetProd:cCaption := ""
	oGetTab:cCaption  := ""
	oLoja:cCaption    := ""
	oProd:cCaption    := ""
	oTabela:cCaption  := ""
	oVlr:cCaption     := ""
	oEst:cCaption     := ""
	oCM:cCaption      := ""
	oMkpCM:cCaption := ""
	oCr:cCaption    := ""
	oMkpCr:cCaption := ""
	cLjDV   := Space(2)
	cProd   := Space(15)
	cCodTab := Space(3)
	oGetLoja:SetFocus()
Return nil

User Function LOJC04D()
	Local aArea := GetArea()
	Local lRet := .F.
	Local cSql := ""

	If Empty(cCodTab)
		Return .T.
	Endif

	cSql := "SELECT DA0_DESCRI FROM "+RetSqlName("DA0")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   DA0_FILIAL = '"+xFilial("DA0")+"'"
	cSql += " AND   DA0_CODTAB = '"+cCodTab+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	If !Eof()
		lRet := .T.
		oTabela:cCaption := AllTrim(DA0_DESCRI)
	Else
		lRet := .F.
		oTabela:cCaption := ""
	Endif
	dbCloseArea()
	RestArea(aArea)
Return lRet