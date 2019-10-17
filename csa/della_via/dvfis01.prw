#include "rwmake.ch"

User Function DVFIS01
	Private cTabela   := "SF1"
	Private cCadastro := ""
	Private cFilCpo   := ""
	Private aRotina   := {}
	Private aAtuCpo   := {}
	Private aAltera   := {}
	Private oFLabel
	Private oFData

	cFilCpo := "F1_DOC,F1_SERIE"

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := AllTrim(X2_NOME)
	
	aadd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aadd(aRotina,{"Visualizar","U_DVFIS01V",0,2})
	aadd(aRotina,{"Alterar"   ,"U_DVFIS01A",0,4})

	dbselectarea(cTabela)
	MBrowse(100,001,300,400,cTabela)
Return

User Function DVFIS01V(cAlias,nReg,nOpc)
	AxVisual(cAlias,nReg,nOpc,aAtuCpo)
Return

User Function DVFIS01A()
	aArray:=GetArea()

	Private cFilNF := SF1->F1_FILIAL
	Private cNovoSer := SF1->F1_SERIE
	Private cNovoNF  := SF1->F1_DOC
	Private cSerie := SF1->F1_SERIE
	Private cTipo := SF1->F1_TIPO
	Private cDoc   := SF1->F1_DOC
	Private cForn  := SF1->F1_FORNECE+"/"+SF1->F1_LOJA+"-"+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA2->A2_NOME")
	Private cCodFor:= SF1->F1_FORNECE+SF1->F1_LOJA
	Private cEmiss := dtoc(SF1->F1_EMISSAO)
	Private dEntrada := SF1->F1_DTDIGIT
	Private cValor := Transform(SF1->F1_VALBRUT,"@e 999,999,999.99")

	@ 000,000 TO 150,580 DIALOG oDlgAlt TITLE "Alterar"
	@ 005,005 TO 030,285

	@ 035,005 TO 065,135
	@ 035,145 TO 065,285

	@ 010,010 SAY "Série:"
	@ 010,030 SAY "Nota:"
	@ 010,060 SAY "Cliente:"
	@ 010,210 SAY "Emissao:"
	@ 010,265 SAY "Valor:"
	@ 020,010 SAY cSerie
	@ 020,030 SAY cDoc
	@ 020,060 SAY cForn
	@ 020,210 SAY cEmiss
	@ 020,250 SAY cValor
	@ 040,010 SAY "Série"
	@ 050,010 Get cNovoSer
	@ 040,070 SAY "Nota"
	@ 050,070 Get cNovoNF
	@ 045,185 BMPBUTTON TYPE 1  ACTION GrvNumNF()
	@ 045,225 BMPBUTTON TYPE 2  ACTION Close(oDlgAlt)
	ACTIVATE DIALOG oDlgAlt CENTERED

	RestArea(aArray)
Return

Static function GrvNumNF()
	If !msgbox("Deseja realmente alterar essa NF","Nota Fiscal","YESNO")
		Return nil
	Endif

	dbSelectArea("SF1")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cFilNF+cNovoNF+cNovoSer+cCodFor+cTipo)
	if Found()
		msgbox("Ja existe outra nota com essa numeração","Nota Fiscal","STOP")
		Return nil
	Endif
	
	cSql := "UPDATE SF1010"
	cSql += " SET F1_DOC = '"+cNovoNF+"'"
	cSql += " ,   F1_SERIE = '"+cNovoSer+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   F1_FILIAL = '"+cFilNF+"'"
	cSql += " AND   F1_DOC = '"+cDoc+"'"
	cSql += " AND   F1_SERIE = '"+cSerie+"'"
	cSql += " AND   F1_FORNECE || F1_LOJA = '"+cCodFor+"'"
	cSql += " AND   F1_TIPO = '"+cTipo+"'"

	MsgRun("Atualizando Nota Fiscal ...",,{|| TcSqlExec(cSql)})


	cSql := "UPDATE SD1010"
	cSql += " SET D1_DOC = '"+cNovoNF+"'"
	cSql += " ,   D1_SERIE = '"+cNovoSer+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   D1_FILIAL = '"+cFilNF+"'"
	cSql += " AND   D1_DOC = '"+cDoc+"'"
	cSql += " AND   D1_SERIE = '"+cSerie+"'"
	cSql += " AND   D1_FORNECE || D1_LOJA = '"+cCodFor+"'"
	cSql += " AND   D1_TIPO = '"+cTipo+"'"

	MsgRun("Atualizando Itens ...",,{|| TcSqlExec(cSql)})


	cSql := "UPDATE SF3010"
	cSql += " SET F3_NFISCAL = '"+cNovoNF+"'"
	cSql += " ,   F3_SERIE = '"+cNovoSer+"'"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   SUBSTR(F3_CFO,1,1) < '5'"
	cSql += " AND   F3_FILIAL = '"+cFilNF+"'"
	cSql += " AND   F3_NFISCAL = '"+cDoc+"'"
	cSql += " AND   F3_SERIE = '"+cSerie+"'"
	cSql += " AND   F3_CLIEFOR || F3_LOJA = '"+cCodFor+"'"
	cSql += " AND   F3_ENTRADA = '"+dtos(dEntrada)+"'"

	MsgRun("Atualizando Livro Fiscal ...",,{|| TcSqlExec(cSql)})

	GrvLog()
	Close(oDlgAlt)
Return nil

Static Function GrvLog()
	Local cLog := ""
	Local cCab := ""

	If !File("DVFIS01.LOG")
		nFile := fCreate("DVFIS01.LOG")
		cCab := "DVFIS01 - Log de Alterações de Numeros de Notas Fiscais de entrada"+Chr(13)+Chr(10)
		cCab += "Data e Hora       - Usuario      - Nota Antes                                       - Nota Depois"+Chr(13)+Chr(10)
		cCab += "----------------------------------------------------------------------------------------------------------------------------------------"+Chr(13)+Chr(10)
		fWrite(nFile,cCab)
	Else
		nFile := fOpen("DVFIS01.LOG",2+64)
		Fseek(nFile,0,2)
	Endif
	
	cLog := dtoc(Date())+" "+Time()+" - "  // Data e hora
	cLog += Alltrim(cUserName) // Usuário
	cLog += " - De NF:"+cDoc+" SERIE:"+cSerie+" FORNECEDOR:"+Substr(cCodFor,1,6)+" LOJA:"+Substr(cCodFor,7,2) // Nota antes
	cLog += " - Para NF:"+cNovoNF+" SERIE:"+cNovoSer+" FORNECEDOR:"+Substr(cCodFor,1,6)+" LOJA:"+Substr(cCodFor,7,2) // Nota Depois
	cLog += Chr(13)+Chr(10)

	fWrite(nFile,cLog)
	fClose(nFile)
Return