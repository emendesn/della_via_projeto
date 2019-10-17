#include "DellaVia.ch"

User Function DVLOJC07(cVarCli,cVarLoja)
	Local   cNomTmp := ""
	Local   cSql    := {}
	Local   aEstru  := {}
	Local   aArea   := GetArea()
	Private aHeader := {}
	Private aRotina := {}
	Private nOps	:= 2
	Private nTotOrc := 0
	Private nTotVlr := 0

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5})

	/*
	cVarCli := "15T58T"
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

	cSql := "SELECT '1' AS ID,L1_FILIAL AS FILIAL,L1_NUM AS NUM,L1_VEND AS VEND,A3_NOME AS NOME,L1_CONDPG AS COND,E4_DESCRI DESCR,L1_VLRTOT AS VALOR,L1_EMISSAO AS EMISSAO"
	cSql += " FROM "+RetSqlName("SL1")+" SL1"

	cSql += " JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = '  '"
	cSql += " AND  A3_COD = L1_VEND"

	cSql += " JOIN "+RetSqlName("SE4")+" SE4"
	cSql += " ON   SE4.D_E_L_E_T_ = ''"
	cSql += " AND  E4_FILIAL = '  '"
	cSql += " AND  E4_CODIGO = L1_CONDPG"

	cSql += " WHERE SL1.D_E_L_E_T_ = ''"
	cSql += " AND   L1_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   L1_CLIENTE = '"+cVarCli+"'"
	cSql += " AND   L1_LOJA = '"+cVarLoja+"'"

	cSql += " UNION ALL"

	cSql += " SELECT '2' AS ID,UA_FILIAL AS FILIAL,UA_NUM AS NUM,UA_VEND AS VEND,A3_NOME AS NOME,UA_CONDPG AS COND ,E4_DESCRI AS DESCR,UA_VALBRUT AS VALOR,UA_EMISSAO AS EMISSAO"
	cSql += " FROM SUA010 SUA"

	cSql += " JOIN SA3010 SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = ''"
	cSql += " AND  A3_COD = UA_VEND"

	cSql += " JOIN SE4010 SE4"
	cSql += " ON   SE4.D_E_L_E_T_ = ''"
	cSql += " AND  E4_FILIAL = ''"
	cSql += " AND  E4_CODIGO = UA_CONDPG"

	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND   UA_CLIENTE = '"+cVarCli+"'"
	cSql += " AND   UA_LOJA = '"+cVarLoja+"'"

	cSql += " ORDER BY EMISSAO DESC,FILIAL,NUM"

	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","EMISSAO","D",08,0)
	TcSetField("ARQ_SQL","VALOR" ,"N",14,2)
	dbSelectArea("ARQ_SQL")

	aEstru := dbStruct()
	aadd(aEstru,{"XBITMAP","C",15,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	dbSelectArea("ARQ_SQL")
	Do While !eof()
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			For k=1 To Len(aEstru)-1
				FieldPut(k,ARQ_SQL->(FieldGet(k)))
			Next k
			If ID = "1"
				XBITMAP := "BR_VERDE"
			Else
				XBITMAP := "BR_AZUL"
			Endif
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea("TMP")

	FuncTot()

	//            Título        ,Campo     ,Picture               ,Tamanho,Decimal,Validação,Reservado,Tipo,Reservado,Reservado
	Aadd(aHeader,{""            ,"XBITMAP" ,"@BMP"                ,10     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Filial"      ,"FILIAL"  ,"@!"                  ,2      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Emissao"     ,"EMISSAO" ,""                    ,8      ,0      ,""       ,         ,"D"})
	aadd(aHeader,{"Numero"      ,"NUM"     ,"@!"                  ,6      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Vendedor"    ,"VEND"    ,"@!"                  ,6      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Nome"        ,"NOME"    ,"@!"                  ,30     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Cond. Pagto" ,"COND"    ,"@!"                  ,3      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Descrição"   ,"DESCR"   ,"@!"                  ,30     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Valor"       ,"VALOR"   ,"@e 99,999,999,999.99",14     ,2      ,""       ,         ,"N"})



	Define Font oFontTitle Name "Arial" Size 8,  16 Bold
	Define Font oFontBold  Name "Arial"  Size 0, -11 Bold
	@ 000,000 TO 430,640 DIALOG oDlg1 TITLE "Orçamentos"

	@ 005,005 TO 020,315 PIXEL //Cliente
	@ 010,010 SAY SA1->A1_COD+" - "+SA1->A1_LOJA+" "+SA1->A1_NOME Object oLblCli PIXEL

	@ 025,005 TO 185,315 PIXEL //Browse
	//                New(nTop, nLeft, nBottom, nRight, nOpc, [cLinhaOk], [cTudoOk], [cIniCpos], [lDelete], [aAlter], [nFreeze], [lEmpty], [uPar1], cTRB  , [cFieldOk], [lCondicional], [lAppend], [oWnd], [lDisparos], [uPar2], [cDelOk], [cSuperDel])
	oGetDb:=MsGetDB():New(030 ,   010,     150,    310,    2,  ""       ,  ""      , ""        , .F.      ,         ,          , .T.     ,        , "TMP" , ""        ,               ,          , oDlg1 , .F.        ,         , ""      , ""         )

	@ 155,010 BITMAP oBmp RESNAME "BR_VERDE" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
	@ 155,020 SAY "Loja" Object oLeg01 Pixel

	@ 165,010 BITMAP oBmp RESNAME "BR_AZUL" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
	@ 165,020 SAY "Telemarketing" Object oLeg02 Pixel


	@ 155,185 SAY "Total de Orçamentos:" Object oLblTotOrc PIXEL
	@ 165,185 SAY "Total Orçado:" Object oLblTotVlr PIXEL

	@ 155,250 SAY AllTrim(Transform(nTotOrc ,"@e 99,999,999,999")) PIXEL SIZE 60,12 Right
	@ 165,250 SAY "R$ "+AllTrim(Transform(nTotVlr,"@e 99,999,999,999.99")) PIXEL SIZE 60,12 Right


	@ 190,005 TO 210,315 PIXEL //Botões
	@ 195,250 BMPBUTTON TYPE  1 ACTION Close(oDlg1)
	@ 195,280 BMPBUTTON TYPE 15 ACTION Visual()

	oLblTotOrc:oFont := oFontBold
	oLblTotVlr:oFont := oFontBold
	oLblCli:oFont    := oFontTitle
	oLblCli:nClrText := 255
	ACTIVATE DIALOG oDlg1 CENTERED
	
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	RestArea(aArea)
Return nil

Static Function Visual
	Private aPosicoesV  := {}
	Private nFolder     := 2
	Private aSvFolder   := {}
	Private altera      := .F.
	Private inclui      := .F.
	Private LVASSCONC   := .F.
	Private aRotina 	:=	{{ "Pesquisar"     , "AxPesqui", 0 , 1 },;
							 { "Visualização"  , "LJ7Venda", 0 , 2 },;
							 { "Atendimento"   , "Lj7Venda", 0 , 3 },;
							 { "Finaliza Venda", "Lj7Venda", 0 , 4 },;
							 { "Orçamento"     , "LJ7Orcam", 0 , 4 },;
							 { "Legenda"       , "Lj7Legenda", 0 , 8 }}

	aadd(aSvFolder,{{},{},1})
	aadd(aSvFolder,{{},{},1})
	aadd(aSvFolder,{{},{},1})

	if eof()
		Help("",1,"ARQVAZIO")
		Return
	Endif

	cFilSystem := cFilAnt
	cFilAnt    := TMP->FILIAL

	IF TMP->ID = "1"
		dbSelectArea("SL1")
		dbSetOrder(1)
		dbSeek(TMP->FILIAL+TMP->NUM)

		LJ7Venda("SL1",Recno(), 2)
	Else
		dbSelectArea("SUA")
		dbSetOrder(1)
		If MsSeek( TMP->FILIAL + TMP->NUM)
			lRet := MaMakeView( "SUA" )
		EndIf
	Endif

	cFilAnt := cFilSystem
Return

Static Function FuncTot
	dbSelectArea("TMP")
	dbGotop()
	COUNT TO nTotOrc
	dbGotop()
	SUM VALOR TO nTotVlr
	dbGotop()
Return