#include "Dellavia.ch"
#include "Folder.ch"

User Function DSEPUA02(lBar)
	Local   cSql    := ""
	Local   aArea   := GetArea()
	Local   LI      := 5
	Local   lSair   := .F.
	Local   nMais   := 0
	Private cMotX   := Space(Len(SZS->ZS_COD))
	Private cMemo   := ""
	Private cStat   := Space(2)
	Private cDesc   := Space(60)
	Private cColOri := ""
	Private cItmOri := ""
	Private nProf   := 0
	Private nAfer   := 0
	Private aBtnAdd := {}
	Private cCombo  := "Nao"
	Private aCombo  := {"Sim","Nao"}
	Private nValor  := 0
	Private nPerc   := 0
	Private nSuger  := 0
	Private cOrig   := "Coleta"
	Private cCodServ := ""

	Default lBar    := .T.

	if TMP->XX_BITMAP = "BR_VERMELHO" .AND. ZZ1->ZZ1_GRUPO <> "1"
		lSair := .T.
	Elseif TMP->XX_BITMAP = "BR_AMARELO" .AND. ZZ1->ZZ1_GRUPO <> "2"
		lSair := .T.
	Elseif TMP->XX_BITMAP = "BR_AZUL" .AND. ZZ1->ZZ1_GRUPO <> "3"
		lSair := .T.
	Elseif TMP->XX_BITMAP = "BR_VERDE"
		lSair := .T.
	Endif

	If lSair
		msgbox("Este registro não pertence a sua alçada","SEPU","STOP")
		Return nil
	Endif

	dbSelectArea("SC2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(TMP->(C2_FILIAL+C2_NUM+C2_ITEM))
	If !Found()
		msgbox("OP não localizada !!!","SEPU","STOP")
		Return nil
	Endif

	if ZZ1->ZZ1_GRUPO = "3"
		cMotX := SC2->C2_XMREFIN
		if ExistCpo("SZS",cMotx,1)
			cDesc := SZS->ZS_DESCR
			cMemo := MSMM(SC2->C2_XCOBS2,80)
		Endif
	Endif


	cSql := "SELECT D1_SERVICO"
	cSql += " FROM "+RetSqlName("SD1")+" SD1"
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   D1_FILIAL = '"+C2_FILIAL+"'"
	cSql += " AND   D1_DOC = '"+C2_NUMD1+"'"
	cSql += " AND   D1_SERIE = '"+C2_SERIED1+"'"
	cSql += " AND   D1_ITEM = '"+C2_ITEMD1+"'"
	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SD1_SQL", .T., .T.)})
	dbSelectArea("SD1_SQL")
	cCodServ := ""
	If !eof()
		cCodServ := D1_SERVICO
	Endif
	dbCloseArea()
	
	if ZZ1->ZZ1_GRUPO = "1"
		nMais   := 15
		nProf   := SC2->C2_XPROFOR
		nAfer   := SC2->C2_XPROFAF
		cColOri := SC2->C2_XCOLORI
		cItmOri := SC2->C2_XITMORI
	Elseif ZZ1->ZZ1_GRUPO = "3"
		nMais := 35
		nPerc := (SC2->C2_XPROFAF/SC2->C2_XPROFOR)*100
		if !Empty(SC2->C2_XCOLORI) .and. !Empty(SC2->C2_XITMORI) .and. !Empty(cCodServ)
			cOrig := "Coleta"
			
			cSql := "SELECT (C6_PRUNIT*C6_QTDVEN) AS VALOR FROM "+RetSqlName("SC2")+" SC2"

			cSql += " JOIN "+RetSqlName("SC6")+" SC6"
			cSql += " ON   SC6.D_E_L_E_T_ = ''"
			cSql += " AND  C6_FILIAL = C2_FILIAL"
			cSql += " AND  C6_NUMOP = C2_NUM"
			cSql += " AND  C6_ITEMOP = C2_ITEM"
			cSql += " AND  C6_PRODUTO = '"+SC2->cCodServ+"'"

			cSql += " WHERE SC2.D_E_L_E_T_ = ''"
			cSql += " AND   C2_FILIAL = '"+SC2->C2_FILIAL+"'"
			cSql += " AND   C2_NUM = '"+SC2->C2_XCOLORI+"'"
			cSql += " AND   C2_ITEM = '"+SC2->C2_XITMORI+"'"
			MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_VALOR", .T., .T.)})
			dbSelectArea("ARQ_VALOR")
			TcSetField("ARQ_VALOR","VALOR","N",14,2)
			nValor := VALOR
			dbCloseArea()
			dbSelectArea("SC2")
		Elseif !Empty(cCodServ)
			cOrig := "Regra de negocio"

			cSql := "SELECT DA1_PRCVEN,ACP_PRCVEN"
			cSql += " FROM DA1030 DA1"

			cSql += " LEFT JOIN ACP030 ACP"
			cSql += " ON   ACP.D_E_L_E_T_ = ''"
			cSql += " AND  ACP_FILIAL = ''"
			cSql += " AND  ACP_CODREG = '"+SC2->C2_FORNECE+"'"
			cSql += " AND  ACP_CODPRO = DA1_CODPRO"

			cSql += " WHERE DA1.D_E_L_E_T_ = ''"
			cSql += " AND   DA1_FILIAL = ''"
			cSql += " AND   DA1_CODTAB = '001'"
			cSql += " AND   DA1_CODPRO = '"+cCodServ+"'"
			MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_VALOR", .T., .T.)})
			dbSelectArea("ARQ_VALOR")
			TcSetField("ARQ_VALOR","DA1_PRCVEN","N",14,2)
			TcSetField("ARQ_VALOR","ACP_PRCVEN","N",14,2)
			nValor := iif(ACP_PRCVEN>0,ACP_PRCVEN,DA1_PRCVEN)
			dbCloseArea()
			dbSelectArea("SC2")
		Else
			cOrig := "Não Encontrado"
		Endif
		nSuger := nValor * (nPerc/100)
	Endif

	dbSelectArea("SC2")

	DEFINE MSDIALOG oDlgAtu FROM 000,000 TO 210+nMais,640 TITLE "SEPU - "+TMP->(C2_FILIAL+C2_NUM+C2_ITEM) PIXEL
	@ 012,000 SCROLLBOX oSbr SIZE 095+nMais,321 PIXEL

	@ LI  ,003 SAY "Mot. Rejei."     PIXEL OF oSbr
	@ LI-1,035 GET cMotX             PIXEL OF oSbr SIZE 30,7 F3 "SZS" Valid VldMot(cMotX)
	@ LI  ,120 SAY "Desc. Rejei"     PIXEL OF oSbr
	@ LI-1,150 GET cDesc             PIXEL OF oSbr SIZE 150,7 When .F. OBJECT oGetDesc
		
	LI+=11
	@ LI  ,003 SAY "Observação"      PIXEL OF oSbr
	@ LI-1,035 MEMO cMemo            PIXEL OF oSbr SIZE 265,60 NO VSCROLL
	if ZZ1->ZZ1_GRUPO = "1"
		LI+=61
		@ LI  ,003 SAY "Profundid"      PIXEL OF oSbr
		@ LI-1,035 GET nProf            PIXEL OF oSbr SIZE 40,7 Picture "@e 99,999.99" Valid nProf > 0
		@ LI  ,085 SAY "Prf. Aferida"   PIXEL OF oSbr
		@ LI-1,120 GET nAfer            PIXEL OF oSbr SIZE 40,7 Picture "@e 99,999.99" Valid nProf > 0
		LI+=11
		@ LI  ,003 SAY "Col. Original"  PIXEL OF oSbr
		@ LI-1,035 GET cColOri          PIXEL OF oSbr SIZE 40,7
		@ LI  ,085 SAY "Itm. Original"  PIXEL OF oSbr
		@ LI-1,120 GET cItmOri          PIXEL OF oSbr SIZE 40,7
	ElseIf ZZ1->ZZ1_GRUPO = "3"
		LI+=61
		@ LI  ,003 SAY "Origem"         PIXEL OF oSbr
		@ LI-1,035 GET cOrig            PIXEL OF oSbr SIZE 70,7 WHEN .F.
		@ LI  ,120 SAY "Status"         PIXEL OF oSbr
		@ LI-1,150 GET cStat            PIXEL OF oSbr SIZE 10,7 F3 "SP"
		LI+=11
		@ LI  ,003 SAY "Valor"          PIXEL OF oSbr
		@ LI-1,035 GET nValor           PIXEL OF oSbr SIZE 60,7 PICTURE "@E 99,999,999,999.99"  WHEN .F.
		@ LI  ,120 SAY "Percentual"     PIXEL OF oSbr
		@ LI-1,150 GET nPerc            PIXEL OF oSbr SIZE 60,7 PICTURE "@E 999.99" WHEN .F.
		LI+=11
		@ LI  ,003 SAY "Bonificação"     PIXEL OF oSbr
		@ LI-1,035 COMBOBOX cCombo ITEMS aCombo SIZE 50,7 OF oSbr PIXEL
		@ LI  ,120 SAY "Vlr Bonif."     PIXEL OF oSbr
		@ LI-1,150 GET nSuger           PIXEL OF oSbr SIZE 50,7 When (cCombo="Sim") PICTURE "@E 99,999,999,999.99"
	Endif

	if lBar
		aadd(aBtnAdd, {"BMPVISUAL",{|| U_DSEPUC02(.F.) },"Visualizar"} )
	Endif

	ACTIVATE MSDIALOG oDlgAtu CENTER ON INIT EnchoiceBar(oDlgAtu,{|| Gravar(),Close(oDlgAtu) },{|| Close(oDlgAtu) } , , aBtnAdd)

	RestArea(aArea)
Return nil

Static Function VldMot(cVar)
	Local lRet := ExistCpo("SZS",cVar,1)
	If lRet
		oGetDesc:cCaption := SZS->ZS_DESCR
		cDesc := SZS->ZS_DESCR
		if ZZ1->ZZ1_GRUPO <> "3" .OR. cVar <> SC2->C2_XMREFIN
			cMemo := MSMM(Posicione("SZS",1,xFilial("SZS")+cVar,"SZS->ZS_CODOBS"),80)
		Endif
	Else
		oGetDesc:cCaption := ""
		cDesc := ""
	Endif
Return lRet

Static Function Gravar()
	cCodMemo := Msmm(,,,cMemo,1,,,"SC2","C2_XCOBS1")
	dbSelectArea("SC2")
	If RecLock("SC2",.F.)
		if ZZ1->ZZ1_GRUPO = "1"
			SC2->C2_XMREPRD := cMotX
			SC2->C2_XCOBS1  := cCodMemo
			SC2->C2_XDATPRD := dDataBase
			SC2->C2_XPROFOR := nProf
			SC2->C2_XPROFAF := nAfer
			SC2->C2_XCOLORI := cColOri
			SC2->C2_XITMORI := cItmOri

		Elseif ZZ1->ZZ1_GRUPO = "2"
			SC2->C2_XMREFIN := cMotX
			SC2->C2_XCOBS2  := cCodMemo
			SC2->C2_XDATFIN := dDataBase

		Elseif ZZ1->ZZ1_GRUPO = "3"
			SC2->C2_XMREDIR := cMotX
			SC2->C2_XCOBS3  := cCodMemo
			SC2->C2_XDATDIR := dDataBase
			SC2->C2_XVALAPR := iif(cCombo="Sim",nSuger,0)
			SC2->C2_XSTDIR  := cStat
		Endif
		MsUnlock()
	Endif
	If cCombo = "Sim"
		CriaNCC()
	Endif
Return nil

Static Function CriaNCC
	Local aReg     := {}
	Local cParcela := iif(Val(SC2->C2_ITEM)>9,Str(Val(SC2->C2_ITEM),1),Chr(Val(SC2->C2_ITEM)+55))

	aAdd( aReg, { "E1_FILIAL"  , SC2->C2_FILIAL                  , NIL } )
	aAdd( aReg, { "E1_PREFIXO" , "SEP"                           , NIL } )
	aAdd( aReg, { "E1_NUM"     , SC2->C2_NUMD1                   , NIL } )
	aAdd( aReg, { "E1_PARCELA" , cParcela                        , NIL } )
	aAdd( aReg, { "E1_TIPO"    , "NCC"                           , NIL } )
	aAdd( aReg, { "E1_MOTDESC" , cMotx                           , NIL } )
	aAdd( aReg, { "E1_NATUREZ" , "1300"                          , NIL } )
	aAdd( aReg, { "E1_CLIENTE" , SC2->C2_FORNECE                 , NIL } )
	aAdd( aReg, { "E1_LOJA"    , SC2->C2_LOJA                    , NIL } )
	aAdd( aReg, { "E1_EMISSAO" , dDataBase                       , NIL } )
	aAdd( aReg, { "E1_VENCTO"  , dDataBase                       , NIL } )
	aAdd( aReg, { "E1_VENCREA" , DataValida(dDataBase,.T.)       , NIL } )
	aAdd( aReg, { "E1_VALOR"   , nSuger                          , NIL } )
	aAdd( aReg, { "E1_COLETA"  , SC2->C2_XCOLORI                 , NIL } )
				
    MsExecAuto( {|x,y| Fina040(x,y)}, aReg, 3)
Return nil