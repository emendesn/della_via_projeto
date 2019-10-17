#include "DellaVia.ch"

User Function DVLOJC08(cVarCli,cVarLoja)
	Local   aArea   := GetArea()
	Local   cNomTmp := ""
	Local   cSql    := ""
	Local   aEstru  := {}
	Private aHeader := {}
	Private aRotina := {}
	Private nOps	:= 2
	Private nQtdTit := 0
	Private nTotTit := 0
	Private nTotAtr := 0
	Private nTotNCC := 0


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

	cSql := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_EMISSAO,E1_VENCTO"
	cSql += " ,     E1_VENCREA,E1_BAIXA,E1_VALOR,E1_PORTADO,E1_NUMBCO,X5_DESCRI"
	cSql += " FROM "+RetSqlName("SE1")+" SE1"

	cSql += " LEFT JOIN "+RetSqlName("SX5")+" SX5"
	cSql += " ON   SX5.D_E_L_E_T_ = ''"
	cSql += " AND  X5_FILIAL = '"+xFilial("SX5")+"'"
	cSql += " AND  X5_TABELA = '07'"
	cSql += " AND  X5_CHAVE = E1_SITUACA"

	cSql += " WHERE SE1.D_E_L_E_T_ = ''"
	cSql += " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += " AND   E1_CLIENTE = '"+cVarCli+"'"
	cSql += " AND   E1_LOJA = '"+cVarLoja+"'"
	cSql += " AND   E1_SALDO = 0"

	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","E1_EMISSAO" ,"D",08,0)
	TcSetField("ARQ_SQL","E1_VENCTO"  ,"D",08,0)
	TcSetField("ARQ_SQL","E1_VENCREA" ,"D",08,0)
	TcSetField("ARQ_SQL","E1_BAIXA"   ,"D",08,0)
	TcSetField("ARQ_SQL","E1_VALOR"   ,"N",14,2)
	dbSelectArea("ARQ_SQL")

	aEstru := dbStruct()
	aadd(aEstru,{"XX_BITMAP","C",15,0})
	aadd(aEstru,{"DIAS"     ,"N",06,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	dbSelectArea("ARQ_SQL")
	Do While !eof()
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			For k=1 To Len(aEstru)-2
				FieldPut(k,ARQ_SQL->(FieldGet(k)))
			Next k
			If E1_VENCREA < E1_BAIXA
				XX_BITMAP := "BR_VERMELHO"
				DIAS := E1_BAIXA - E1_VENCREA
			Else
				XX_BITMAP := "BR_VERDE"
			Endif
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea("TMP")

	FuncTot()

	//            Título       ,Campo       ,Picture               ,Tamanho,Decimal,Validação,Reservado,Tipo,Reservado,Reservado
	Aadd(aHeader,{""           ,"XX_BITMAP" ,"@BMP"                ,10     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Emissao"    ,"E1_EMISSAO",""                    ,8      ,0      ,""       ,         ,"D"})
	aadd(aHeader,{"Prefixo"    ,"E1_PREFIXO","@!"                  ,3      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Titulo"     ,"E1_NUM"    ,"@!"                  ,6      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Parcela"    ,"E1_PARCELA","@!"                  ,1      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Tipo"       ,"E1_TIPO"   ,"@!"                  ,3      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Venc. Real" ,"E1_VENCREA",""                    ,8      ,0      ,""       ,         ,"D"})
	aadd(aHeader,{"Dt. Baixa"  ,"E1_BAIXA"  ,""                    ,8      ,0      ,""       ,         ,"D"})
	aadd(aHeader,{"Valor"      ,"E1_VALOR"  ,"@e 99,999,999,999.99",14     ,2      ,""       ,         ,"N"})
	aadd(aHeader,{"Portador"   ,"E1_PORTADO","@!"                  ,3      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Num. Bco"   ,"E1_NUMBCO" ,"@!"                  ,15     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Situacao"   ,"X5_DESCRI" ,"@!"                  ,30     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Dias Atraso","DIAS"      ,"@e 999,999"          ,6      ,0      ,""       ,         ,"N"})


	Define Font oFontTitle Name "Arial" Size 8,  16 Bold
	Define Font oFontBold  Name "Arial" Size 0, -11 Bold
	@ 000,000 TO 450,640 DIALOG oDlg1 TITLE "Titulos recebidos"

	@ 005,005 TO 020,315 PIXEL //Cliente
	@ 010,010 SAY SA1->A1_COD+"-"+SA1->A1_LOJA+" "+SA1->A1_NOME Object oLblCli Font oFontTitle Pixel Color RGB(255,0,0)

	@ 025,005 TO 195,315 PIXEL //Browse
	//                New(nTop, nLeft, nBottom, nRight, nOpc, [cLinhaOk], [cTudoOk], [cIniCpos], [lDelete], [aAlter], [nFreeze], [lEmpty], [uPar1], cTRB  , [cFieldOk], [lCondicional], [lAppend], [oWnd], [lDisparos], [uPar2], [cDelOk], [cSuperDel])
	oGetDb:=MsGetDB():New(030 ,   010,     140,    310,    2,  ""       ,  ""      , ""        , .F.      ,         ,          , .T.     ,        , "TMP" , ""        ,               ,          , oDlg1 , .F.        ,         , ""      , ""         )

	// Legenda
	@ 145,010 BITMAP oBmp RESNAME "BR_VERDE" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
	@ 145,020 SAY "Recebidos" Object oLeg01 Pixel

	@ 155,010 BITMAP oBmp RESNAME "BR_VERMELHO" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
	@ 155,020 SAY "Recebidos com atraso" Object oLeg03 Pixel


	// Totais
	@ 145,200 SAY "Qtd. Titulos:" Object oLblQtdTit Font oFontBold Pixel
	@ 145,250 SAY AllTrim(Transform(nQtdTit,"@e 99,999,999,999")) Size 50,12 Pixel Right

	@ 155,200 SAY "Total Titulos:" Object oLblTotTit Font oFontBold Pixel
	@ 155,250 SAY "R$  "+AllTrim(Transform(nTotTit,"@e 99,999,999,999.99")) Pixel Size 50,12 Right

	@ 165,200 SAY "Total pg c/ atraso:" Object oLblTotAtr Font oFontBold Pixel
	@ 165,250 SAY "R$  "+AllTrim(Transform(nTotAtr,"@e 99,999,999,999.99")) Pixel Size 50,12 Right

	@ 175,200 SAY "Total de NCC:" Object oLblTotAtr Font oFontBold Pixel
	@ 175,250 SAY "R$  "+AllTrim(Transform(nTotNCC,"@e 99,999,999,999.99")) Pixel Size 50,12 Right

	@ 200,005 TO 220,315 PIXEL //Botões
	@ 205,250 BMPBUTTON TYPE  1 ACTION Close(oDlg1)
	@ 205,280 BMPBUTTON TYPE 15 ACTION Visual()

	ACTIVATE DIALOG oDlg1 CENTERED
	
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	RestArea(aArea)
Return nil

Static Function Visual
	Local aArea := GetArea()
	Private cCadastro := "Consulta Titulos recebidos"

	dbSelectArea("TMP")
	if eof()
		Help("",1,"ARQVAZIO")
		Return
	Endif

	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(TMP->E1_FILIAL+TMP->E1_PREFIXO+TMP->E1_NUM)
	AxVisual("SE1",Recno(),2)
	RestArea(aArea)
Return

Static Function FuncTot
	dbSelectArea("TMP")
	dbGotop()
	Do While !eof()
		nQtdTit ++
		If E1_TIPO = "NCC"
			nTotNCC += E1_VALOR
		Else
			nTotTit += E1_VALOR
			If E1_VENCREA < E1_BAIXA
				nTotAtr += E1_VALOR
			Endif
		Endif
		dbSkip()
	Enddo
	dbGotop()
Return