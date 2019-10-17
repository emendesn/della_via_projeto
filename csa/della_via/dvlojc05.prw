#include "Rwmake.ch"
#include "Font.ch"
#include "TopConn.ch"

User Function DVLOJC05(cVarCli,cVarLoja)
	Local   aArea   := GetArea()
	Local   cNomTmp := ""
	Local   aCampos := {}
	Local   cSql    := {}
	Private nTotNf  := 0
	Private nTotFat := 0

	/*
	cVarCli := "159RDW"
	cVarLoja := "01"
	*/

	If cVarCli = NIL .OR. Empty(cVarCli)
		msgbox("Parametro inválido","1 - Cliente","STOP")
		Return nil
	Endif

	If cVarLoja = NIL .OR. Empty(cVarLoja)
		msgbox("Parametro inválido","2 - Loja","STOP")
		Return nil
	Endif

	dbSelectArea("SA1")
	dbGotop()
	dbSeek(xFilial("SA1")+cVarCli+cVarLoja)
	If !Found()
		msgbox("Cliente não encontrado","Faturamento","STOP")
		Return nil		
	Endif

	cSql := "SELECT F2_FILIAL,F2_SERIE,F2_DOC,F2_VEND1,A3_NOME,F2_COND,E4_DESCRI,F2_VALFAT,F2_EMISSAO,F2_ORIGEM"
	cSql += " FROM "+RetSqlName("SF2")+" SF2"

	cSql += " JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
	cSql += " AND  A3_COD = F2_VEND1"

	cSql += " JOIN "+RetSqlName("SE4")+" SE4"
	cSql += " ON   SE4.D_E_L_E_T_ = ''"
	cSql += " AND  E4_FILIAL = '"+xFilial("SE4")+"'"
	cSql += " AND  E4_CODIGO = F2_COND"

	cSql += " WHERE SF2.D_E_L_E_T_ = ''"
	cSql += " AND   F2_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   F2_CLIENTE = '"+cVarCli+"'"
	cSql += " AND   F2_LOJA = '"+cVarLoja+"'"
	cSql += " ORDER BY F2_EMISSAO DESC,F2_FILIAL,F2_SERIE,F2_DOC"

	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","F2_EMISSAO","D",08,0)
	TcSetField("ARQ_SQL","F2_VALFAT" ,"N",14,2)
	dbSelectArea("ARQ_SQL")

	cNomTmp := CriaTrab(Nil,.F.)
	Copy To &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)

	FuncTot()

	dbSelectArea("TMP")
	aadd(aCampos,{"F2_FILIAL" ,"Filial"     ,"@!"})
	aadd(aCampos,{"F2_EMISSAO","Emissao"    ,})
	aadd(aCampos,{"F2_SERIE"  ,"Serie"      ,"@!"})
	aadd(aCampos,{"F2_DOC"    ,"Documento"  ,"@!"})
	aadd(aCampos,{"F2_VEND1"  ,"Vendedor"   ,"@!"})
	aadd(aCampos,{"A3_NOME"   ,"Nome"       ,"@!"})
	aadd(aCampos,{"F2_COND"   ,"Cond. Pagto","@!"})
	aadd(aCampos,{"E4_DESCRI" ,"Descricao"  ,"@!"})
	aadd(aCampos,{"F2_VALFAT" ,"Valor"      ,"@e 99,999,999,999.99"})
	aadd(aCampos,{"F2_ORIGEM" ,"Origem"     ,"@!"})

	Define Font oFontTitle Name "Arial" Size 8,  16 Bold
	Define Font oFontBold  Name "Arial"  Size 0, -11 Bold
	@ 000,000 TO 430,640 DIALOG oDlg1 TITLE "Faturamento"

	@ 005,005 TO 020,315 //Cliente
	@ 010,010 SAY SA1->A1_COD+" - "+SA1->A1_LOJA+" "+SA1->A1_NOME Object oLblCli

	@ 025,005 TO 185,315 //Browse
	@ 030,010 TO 150,310 BROWSE "TMP" Object oBrw FIELDS aCampos

	@ 165,010 SAY "Total de Notas:" Object oLblTotNF
	@ 165,200 SAY "Total Faturado:" Object oLblTotFat

	@ 165,060 SAY AllTrim(Transform(nTotNF ,"@e 99,999,999,999"))
	@ 165,250 SAY "R$ "+AllTrim(Transform(nTotFat,"@e 99,999,999,999.99"))

	@ 190,005 TO 210,315 //Botões
	@ 195,250 BMPBUTTON TYPE  1 ACTION Close(oDlg1)
	@ 195,280 BMPBUTTON TYPE 15 ACTION Visual()

	oLblTotNF:oFont  := oFontBold
	oLblTotFat:oFont := oFontBold
	oLblCli:oFont    := oFontTitle
	oLblCli:nClrText := 255
	ACTIVATE DIALOG oDlg1 CENTERED
	
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	RestArea(aArea)
Return nil

Static Function Visual
	if eof()
		Help("",1,"ARQVAZIO")
		Return
	Endif

	cFilSystem := cFilAnt
	cFilAnt    := TMP->F2_FILIAL

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(TMP->F2_FILIAL+TMP->F2_DOC+TMP->F2_SERIE)

	Mc090Visual()

	cFilAnt := cFilSystem
Return

Static Function FuncTot
	dbSelectArea("TMP")
	dbGotop()
	COUNT TO nTotNf
	dbGotop()
	SUM F2_VALFAT TO nTotFat
	dbGotop()
Return