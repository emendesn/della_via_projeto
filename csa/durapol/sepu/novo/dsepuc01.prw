#include "DellaVia.ch"

User Function DSEPUC01
	Local   aArea   := GetArea()
	Local   cNomTmp := ""
	Local   cSql    := ""
	Local   aEstru  := {}
	Private aItens  := {}
	Private cCmb    := ""
	Private aHeader := {}
	Private aRotina := {}
	Private nOps	:= 2
	Private cFil01  := ""
	Private cFil02  := ""
	Private cLeg01  := "Produção"
	Private cLeg02  := "Comercial"
	Private cLeg03  := "Diretoria"
	Private cLeg04  := "Faturamento"

	If SM0->M0_CODIGO <> "03"
		msgbox("Esta rotina só pode ser executada na Durapol","SEPU","STOP")
		Return  nil
	Endif


	dbSelectArea("ZZ1")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("ZZ1")+__cUserID)
	If !Found()
		msgbox("Você não tem acesso a esta rotina.","SEPU","STOP")
		Return  nil
	Endif

	aadd(aItens,"Todos")
	If ZZ1->ZZ1_VPROD = "1"
		aadd(aItens,"Produção")
	Endif
	If ZZ1->ZZ1_VCOM = "1"
		aadd(aItens,"Comercial")
	Endif
	If ZZ1->ZZ1_VDIR = "1"
		aadd(aItens,"Diretoria")
	Endif
	If ZZ1->ZZ1_VFAT = "1"
		aadd(aItens,"Faturamento")
	Endif


	If ZZ1->ZZ1_GRUPO = "3"
		aItSts := {"XX - Todos","?? - Sem Status"}
		cSts   := ""
		cSql := "SELECT SUBSTR(X5_CHAVE,1,2) || ' - ' || X5_DESCRI AS TXT"
		cSql += " FROM "+RetSqlName("SX5")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   X5_FILIAL = ''"
		cSql += " AND   X5_TABELA = 'SP'"
		cSql += " ORDER BY X5_CHAVE"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_SX5", .T., .T.)
		dbSelectArea("SQL_SX5")
		Do While !eof()
			aadd(aItSts,AllTrim(TXT))
			dbSkip()
		Enddo
		dbCloseArea()
	Endif

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5})


	MsgRun("Consultando Banco de dados ...",,{|| ExecQuery() })
	dbSelectArea("ARQ_SQL")

	aEstru := dbStruct()
	aadd(aEstru,{"XX_BITMAP","C",15,0})

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IF ZZ1->ZZ1_GRUPO = "3"
		IndRegua("TMP",cNomTmp,"C2_FILIAL+C2_XSTDIR+DTOS(C2_EMISSAO)",,,"Selecionando Registros")
	Else
		IndRegua("TMP",cNomTmp,"C2_FILIAL+DTOS(C2_EMISSAO)",,,"Selecionando Registros")
	Endif
	dbSelectArea("ARQ_SQL")
	Do While !eof()
		if !Empty(ARQ_SQL->C2_XMREPRD) .AND. !Empty(ARQ_SQL->C2_XMREFIN) .AND. !Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VFAT <> "1"
			dbSkip()
			Loop
		Endif
		if !Empty(ARQ_SQL->C2_XMREPRD) .AND. !Empty(ARQ_SQL->C2_XMREFIN) .AND. Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VDIR <> "1"
			dbSkip()
			Loop
		Endif
		if !Empty(ARQ_SQL->C2_XMREPRD) .AND. Empty(ARQ_SQL->C2_XMREFIN) .AND. Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VCOM <> "1"
			dbSkip()
			Loop
		Endif
		if Empty(ARQ_SQL->C2_XMREPRD) .AND. Empty(ARQ_SQL->C2_XMREFIN) .AND. Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VPROD <> "1"
			dbSkip()
			Loop
		Endif

		IF C2_X_STATU $ "6*9" //Produzido - Rejeitado
			dbSelectArea("SC6")
			dbSetOrder(7)                                      
			dbSeek(ARQ_SQL->(C2_FILIAL+C2_NUM+C2_ITEM))
			IF !Empty(SC6->C6_NOTA) // Ja Faturado 
				dbSelectArea("ARQ_SQL")
				dbSkip()
				Loop
			ENDIF
		ENDIF   

		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			For k=1 To Len(aEstru)-1
				FieldPut(k,ARQ_SQL->(FieldGet(k)))
			Next k
			If Empty(ARQ_SQL->C2_XMREPRD)
				XX_BITMAP := "BR_VERMELHO"
			Elseif Empty(ARQ_SQL->C2_XMREFIN)
				XX_BITMAP := "BR_AMARELO"
			Elseif Empty(ARQ_SQL->C2_XMREDIR)
				XX_BITMAP := "BR_AZUL"
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

	//            Título      ,Campo       ,Picture               ,Tamanho,Decimal,Validação,Reservado,Tipo,Reservado,Reservado
	Aadd(aHeader,{""          ,"XX_BITMAP" ,"@BMP"                ,10     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Filial"    ,"C2_FILIAL" ,"@!"                  ,2      ,0      ,""       ,         ,"C"})
	IF ZZ1->ZZ1_GRUPO = "3"
		aadd(aHeader,{"St Diretoria"    ,"C2_XSTDIR" ,"@!"                  ,2      ,0      ,""       ,         ,"C"})
	Endif
	aadd(aHeader,{"Numero"    ,"C2_NUM"    ,"@!"                  ,6      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Item"      ,"C2_ITEM"   ,"@!"                  ,2      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Data"      ,"C2_EMISSAO",""                    ,8      ,0      ,""       ,         ,"D"})
	aadd(aHeader,{"Cliente"   ,"C2_XNREDUZ","@!"                  ,20     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Produto"   ,"C2_PRODUTO","@!"                  ,15     ,0      ,""       ,         ,"C"})


	Define Font oFontBold  Name "Arial" Size 0, -11 Bold
	@ 000,000 TO 410,640 DIALOG oDlg1 TITLE "SEPU"

	@ 005,005 TO 145,315 PIXEL //Browse
	@ 011,010 SAY "SEPU" Pixel
	@ 010,030 COMBOBOX cCmb ITEMS aItens SIZE 80,7 PIXEL ON CHANGE CmbFil()

	If ZZ1->ZZ1_GRUPO = "3"
		@ 011,170 SAY "Status" Pixel
		@ 010,190 COMBOBOX cSts ITEMS aItSts SIZE 120,7 PIXEL ON CHANGE CmbSts()
	Endif


	//                 New(nTop, nLeft, nBottom, nRight, nOpc, [cLinhaOk], [cTudoOk], [cIniCpos], [lDelete], [aAlter], [nFreeze], [lEmpty], [uPar1], cTRB  , [cFieldOk], [lCondicional], [lAppend], [oWnd], [lDisparos], [uPar2] , [cDelOk], [cSuperDel])
	oGetDb1:=MsGetDB():New(025 ,   010,     140,    310,    2,  ""       ,  ""      , ""        , .F.      ,         ,          , .T.     ,        , "TMP" , ""        ,               ,          , oDlg1 , .F.        ,         , ""      , ""         )

	nLi := 160
	@ 150,005 TO 200,080 PIXEL Title "Legenda" // Legenda

	If ZZ1->ZZ1_VPROD = "1"
		@ nLi,010 BITMAP oBmp RESNAME "BR_VERMELHO" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
		@ nLi,020 SAY cLeg01 Object oLeg01 Pixel
		nLi+=10
	Else
		@ 1000,1000 SAY "" Object oLeg01 Pixel
	Endif
	
	If ZZ1->ZZ1_VCOM = "1"
		@ nLi,010 BITMAP oBmp RESNAME "BR_AMARELO" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
		@ nLi,020 SAY cLeg02 Object oLeg02 Pixel
		nLi+=10
	Else
		@ 1000,1000 SAY "" Object oLeg02 Pixel
	Endif
	
	If ZZ1->ZZ1_VDIR = "1"
		@ nLi,010 BITMAP oBmp RESNAME "BR_AZUL" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
		@ nLi,020 SAY cLeg03 Object oLeg03 Pixel
		nLi+=10
	Else
		@ 1000,1000 SAY "" Object oLeg03 Pixel
	Endif

	If ZZ1->ZZ1_VFAT = "1"
		@ nLi,010 BITMAP oBmp RESNAME "BR_VERDE" SIZE 7,7 NOBORDER OF oDlg1 PIXEL
		@ nLi,020 SAY cLeg04 Object oLeg04 Pixel
		nLi+=10
	Else
		@ 1000,1000 SAY "" Object oLeg04 Pixel
	Endif

	@ 150,085 TO 200,315 PIXEL // Botões

	if ZZ1->ZZ1_GRUPO = "3"
		@ 170,090 BUTTON "Status" ACTION StatDir()
	Endif

	@ 155,280 BMPBUTTON TYPE  1 ACTION Close(oDlg1)
	@ 170,280 BMPBUTTON TYPE 15 ACTION U_DSEPUC02()
	@ 185,280 BMPBUTTON TYPE 11 ACTION eVal({|| U_DSEPUA02(),AtuDados() }) Object oBmpBtn01
	oBmpBtn01:lActive := ZZ1->ZZ1_GRUPO <> "4"

	CntStat()

	DEFINE TIMER oTmr01 INTERVAL 60000 ACTION AtuDados() OF oDlg1

	ACTIVATE DIALOG oDlg1 CENTERED ON INIT oTmr01:Activate()
	
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	RestArea(aArea)
Return nil

Static Function StatDir()
	Local cVar := TMP->C2_XSTDIR
	Local nRec := TMP->(RecNo())

	dbSelectArea("TMP")
	IF !(AllTrim(XX_BITMAP) = "BR_AZUL")
		msgbox("Este registro não pertence a sua alçada","SEPU","STOP")
		Return
	Endif

	DEFINE MSDIALOG oDlgSts FROM 000,000 TO 050,500 TITLE "Status - Diretoria" Pixel
	@ 005,005 SAY "Status:" PIXEL OF oDlgSts SIZE 40,7
	@ 004,030 GET cVar  PIXEL OF oDlgSts SIZE 30,7 F3 "SP" PICTURE "@!" VALID Empty(cVar) .OR. VldSts(cVar)
	@ 005,065 SAY Tabela("SP",cVar,.F.) OBJECT oSayTxt PIXEL OF oDlgSts SIZE 130,7
	@ 003,200 BMPBUTTON TYPE 1 ACTION Close(oDlgSts)
	ACTIVATE MSDIALOG oDlgSts CENTERED

	If RecLock("TMP",.F.)
		TMP->C2_XSTDIR := cVar
		MsUnLock()
	Endif

	dbSelectArea("SC2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(TMP->(C2_FILIAL+C2_NUM+C2_ITEM))
	If RecLock("SC2",.F.)
		SC2->C2_XSTDIR := cVar
		MsUnLock()
	Endif
	dbSelectArea("TMP")
	oGetDb1:oBrowse:Refresh()
	CntStat()
Return

Static Function VldSts(cVar)
	Local lRet := .F.
	lRet := ExistCpo("SX5","SP"+cVar,1)
	If lRet
		oSayTxt:cCaption := Tabela("SP",cVar,.F.)
	Endif
Return lRet


Static Function CntStat()
	Local nLeg01 := 0
	Local nLeg02 := 0
	Local nLeg03 := 0
	Local nLeg04 := 0

	dbSelectArea("TMP")
	dbGoTop()
	Count To nLeg01 For AllTrim(XX_BITMAP) = "BR_VERMELHO"
	Count To nLeg02 For AllTrim(XX_BITMAP) = "BR_AMARELO"
	Count To nLeg03 For AllTrim(XX_BITMAP) = "BR_AZUL"
	Count To nLeg04 For AllTrim(XX_BITMAP) = "BR_VERDE"

	oLeg01:cCaption := cLeg01 + " (" + AllTrim(Str(nLeg01)) + ")"
	oLeg02:cCaption := cLeg02 + " (" + AllTrim(Str(nLeg02)) + ")"
	oLeg03:cCaption := cLeg03 + " (" + AllTrim(Str(nLeg03)) + ")"
	oLeg04:cCaption := cLeg04 + " (" + AllTrim(Str(nLeg04)) + ")"
	dbGoTop()
Return nil

Static Function ExecFil()
	Local cFiltro := cFil01 + iif(Len(AllTrim(cFil01))>0 .AND. Len(AllTrim(cFil02))>0," .AND. ","") + cFil02
	dbSelectArea("TMP")

	Set Filter to &cFiltro

	dbGoTop()
	oGetDb1:oBrowse:Refresh()
Return

Static Function CmbFil()
	If AllTrim(cCmb) = "Todos"
		cFil01 := ""
	Elseif AllTrim(cCmb) = "Produção"
		cFil01 := "AllTrim(XX_BITMAP) = 'BR_VERMELHO'"
	Elseif AllTrim(cCmb) = "Comercial"
		cFil01 := "AllTrim(XX_BITMAP) = 'BR_AMARELO'"
	Elseif AllTrim(cCmb) = "Diretoria"
		cFil01 := "AllTrim(XX_BITMAP) = 'BR_AZUL'"
	Elseif AllTrim(cCmb) = "Faturamento"
		cFil01 := "AllTrim(XX_BITMAP) = 'BR_VERDE'"
	Endif
	ExecFil()
	CntStat()
Return

Static Function CmbSts()
	Local cSel := Substr(cSts,1,2)

	Do Case
		Case cSel = "XX"
			cFil02 := ""
		Case cSel = "??"
			cFil02 := "C2_XSTDIR = '  '"
		OtherWise
			cFil02 := "C2_XSTDIR = '"+cSel+"'"
	EndCase

	ExecFil()
	CntStat()
Return

Static Function AtuDados()
	Local aEstru := {}
	Local nRecNo := TMP->(Recno())


	ExecQuery()
	dbSelectArea("ARQ_SQL")
	aEstru := dbStruct()
	aadd(aEstru,{"XX_BITMAP","C",15,0})

	dbSelectArea("TMP")
	ZAP
	
	dbSelectArea("ARQ_SQL")
	Do While !eof()
		if !Empty(ARQ_SQL->C2_XMREPRD) .AND. !Empty(ARQ_SQL->C2_XMREFIN) .AND. !Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VFAT <> "1"
			dbSkip()
			Loop
		Endif
		if !Empty(ARQ_SQL->C2_XMREPRD) .AND. !Empty(ARQ_SQL->C2_XMREFIN) .AND. Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VDIR <> "1"
			dbSkip()
			Loop
		Endif
		if !Empty(ARQ_SQL->C2_XMREPRD) .AND. Empty(ARQ_SQL->C2_XMREFIN) .AND. Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VCOM <> "1"
			dbSkip()
			Loop
		Endif
		if Empty(ARQ_SQL->C2_XMREPRD) .AND. Empty(ARQ_SQL->C2_XMREFIN) .AND. Empty(ARQ_SQL->C2_XMREDIR) .AND. ZZ1->ZZ1_VPROD <> "1"
			dbSkip()
			Loop
		Endif

		IF C2_X_STATU $ "6*9" //Produzido - Rejeitado
			dbSelectArea("SC6")
			dbSetOrder(7)                                      
			dbSeek(ARQ_SQL->(C2_FILIAL+C2_NUM+C2_ITEM))
			IF !Empty(SC6->C6_NOTA) // Ja Faturado 
				dbSelectArea("ARQ_SQL")
				dbSkip()
				Loop
			ENDIF
		ENDIF   

		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			For k=1 To Len(aEstru)-1
				FieldPut(k,ARQ_SQL->(FieldGet(k)))
			Next k
			If Empty(ARQ_SQL->C2_XMREPRD)
				XX_BITMAP := "BR_VERMELHO"
			Elseif Empty(ARQ_SQL->C2_XMREFIN)
				XX_BITMAP := "BR_AMARELO"
			Elseif Empty(ARQ_SQL->C2_XMREDIR)
				XX_BITMAP := "BR_AZUL"
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
	ExecFil()
	CntStat()
	If Recno() > 0 .and. nRecNo > 0
		Go nRecNo
		oGetDb1:oBrowse:Refresh()
	Endif
Return nil

Static Function ExecQuery()
	Local cSql := ""

	cSql := "SELECT C2_X_STATU,C2_FILIAL,C2_NUM,C2_ITEM,C2_EMISSAO,C2_XNREDUZ,C2_PRODUTO,C2_XMREPRD,C2_XMREFIN,C2_XMREDIR,C2_XSTDIR"
	cSql += " FROM "+RetSqlName("SC2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	//cSql += " AND   C2_X_STATU NOT IN('6','9','7')"
	cSql += " AND   C2_X_STATU <> '7'"
	cSql += " AND   C2_X_DESEN LIKE '%EXA%'"
	cSql += " ORDER BY C2_NUM,C2_ITEM"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","C2_EMISSAO","D",08,0)
Return