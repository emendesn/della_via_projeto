#include "Dellavia.ch"
#include "Folder.ch"

User Function DSEPUC02(lBar)
	Local   aArea   := GetArea()
	Private aHeader := {}
	Private aRotina := {}
	Private aBtnAdd := {}
	
	Default lBar    := .T.

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5})

	If SM0->M0_CODIGO <> "03"
		msgbox("Esta rotina só pode ser executada na Durapol","SEPU","STOP")
		Return  nil
	Endif

	//            Título       ,Campo       ,Picture               ,Tamanho,Decimal,Validação,Reservado,Tipo,Reservado,Reservado
	aadd(aHeader,{"Item"       ,"ACP_ITEM"  ,"@!"                  ,3      ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Serviço"    ,"ACP_CODPRO","@!"                  ,15     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Descrição"  ,"B1_DESC"   ,"@!"                  ,30     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Carcaca"    ,"B1_PRODUTO","@!"                  ,15     ,0      ,""       ,         ,"C"})
	aadd(aHeader,{"Prc. Venda" ,"ACP_PRCVEN","@e 99,999,999,999.99",14     ,2      ,""       ,         ,"N"})
	aadd(aHeader,{"Prc. Tabela","DA1_PRCVEN","@e 999.99"           ,14     ,2      ,""       ,         ,"N"})
	aadd(aHeader,{"Desconto"   ,"ACP_PERDES","@e 999.99"           ,6      ,2      ,""       ,         ,"N"})
	aadd(aHeader,{"Acrescimo"  ,"ACP_PERACR","@e 999.99"           ,6      ,6      ,""       ,         ,"N"})



	cSql := "SELECT A1_COD,A1_LOJA,A1_CGC,A1_NOME,A1_END,A1_MUN,A1_EST,A1_TEL,A1_ULTCOM,A1_RISCO"
	cSql += " ,     C2_NUMD1,C2_EMISSAO,C2_PRODUTO,C2_MARCAPN,C2_SERIEPN,C2_NUMFOGO,D1_SERVICO,C2_NUM"
	cSql += " ,     C2_XMREPRD,C2_XCOBS1,ZS1.ZS_DESCR AS DESCPRD,C2_XDATPRD"
	cSql += " ,     C2_XMREFIN,C2_XCOBS2,ZS2.ZS_DESCR AS DESCFIN,C2_XDATFIN"
	cSql += " ,     C2_XMREDIR,C2_XCOBS3,ZS3.ZS_DESCR AS DESCDIR,C2_XDATDIR,C2_XSTDIR"
	cSql += " ,     C2_XCOLORI,C2_XBANDA,D1_SERVICO,C2_XPRCTAB,C2_XPROFOR,C2_XPROFAF,C2_XVALAPR"

	cSql += " FROM "+RetSqlName("SC2")+" SC2"

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND  A1_COD = C2_FORNECE"
	cSql += " AND  A1_LOJA = C2_LOJA"

	cSql += " LEFT JOIN "+RetSqlName("SD1")+" SD1"
	cSql += " ON   SD1.D_E_L_E_T_ = ''"
	cSql += " AND  D1_FILIAL = C2_FILIAL"
	cSql += " AND  D1_DOC = C2_NUMD1"
	cSql += " AND  D1_SERIE = C2_SERIED1"
	cSql += " AND  D1_ITEM = C2_ITEMD1"

	cSql += " LEFT JOIN "+RetSqlName("SZS")+" ZS1"
	cSql += " ON   ZS1.D_E_L_E_T_ = ''"
	cSql += " AND  ZS1.ZS_FILIAL = '"+xFilial("SZS")+"'"
	cSql += " AND  ZS1.ZS_COD = C2_XMREPRD"

	cSql += " LEFT JOIN "+RetSqlName("SZS")+" ZS2"
	cSql += " ON   ZS2.D_E_L_E_T_ = ''"
	cSql += " AND  ZS2.ZS_FILIAL = '"+xFilial("SZS")+"'"
	cSql += " AND  ZS2.ZS_COD = C2_XMREFIN"

	cSql += " LEFT JOIN "+RetSqlName("SZS")+" ZS3"
	cSql += " ON   ZS3.D_E_L_E_T_ = ''"
	cSql += " AND  ZS3.ZS_FILIAL = '"+xFilial("SZS")+"'"
	cSql += " AND  ZS3.ZS_COD = C2_XMREDIR"

	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+TMP->C2_FILIAL+"'"
	cSql += " AND   C2_NUM = '"+TMP->C2_NUM+"'"
	cSql += " AND   C2_ITEM = '"+TMP->C2_ITEM+"'"

	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SEPU", .T., .T.)})
	TcSetField("SEPU","A1_ULTCOM" ,"D")
	TcSetField("SEPU","C2_EMISSAO","D")
	TcSetField("SEPU","C2_XPRCTAB","N",14,2)
	TcSetField("SEPU","C2_XDATPRD","D")
	TcSetField("SEPU","C2_XDATFIN","D")
	TcSetField("SEPU","C2_XDATDIR","D")
	TcSetField("SEPU","C2_XVALAPR","N",14,2)



	cSql := "SELECT ACP_ITEM,ACP_CODPRO,B1_DESC,B1_PRODUTO,DA1_PRCVEN,ACP_PERDES,ACP_PERACR,ACP_PRCVEN"
	cSql += " FROM "+RetSqlName("ACP")+" ACP"

	cSql += " JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = ACP_CODPRO"

	cSql += " JOIN "+RetSqlName("DA1")+" DA1"
	cSql += " ON   DA1.D_E_L_E_T_ = ''"
	cSql += " AND  DA1_FILIAL = '"+xFilial("DA1")+"'"
	cSql += " AND  DA1_CODTAB = '001'"
	cSql += " AND  DA1_CODPRO = ACP_CODPRO"

	cSql += " WHERE ACP.D_E_L_E_T_ = ''"
	cSql += " AND   ACP_FILIAL = '"+xFilial("ACP")+"'"
	cSql += " AND   ACP_CODREG = '"+SEPU->A1_COD+"'"
	cSql += " ORDER BY ACP_ITEM"

	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_RGD", .T., .T.)})
	TcSetField("SQL_RGD","DA1_PRCVEN","N",14,2)
	TcSetField("SQL_RGD","ACP_PERDES","N",14,2)
	TcSetField("SQL_RGD","ACP_PERACR","N",14,2)
	TcSetField("SQL_RGD","ACP_PRCVEN","N",14,2)

	cNomTmp := CriaTrab(NIL,.F.)
	dbSelectArea("SQL_RGD")
	Copy To &cNomTmp
	dbSelectArea("SQL_RGD")
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"REGRA",.F.,.F.)
	dbSelectArea("REGRA")
	dbGoTop()

	cSql := "SELECT D1_DTDIGIT FROM "+RetSqlName("SD1")
	cSql += " WHERE  D_E_L_E_T_ = ''"
	cSql += " AND    D1_FILIAL = '"+TMP->C2_FILIAL+"'"
	cSql += " AND    D1_NUMC2 = '"+SEPU->C2_XCOLORI+"'"
	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","D1_DTDIGIT","D")
	dbSelectArea("ARQ_SQL")
	dColOri := ctod("//")
	If !eof() .AND. !Empty(SEPU->C2_XCOLORI)
		dColOri := D1_DTDIGIT
	Endif
	dbCloseArea()

	cSql := "SELECT F2_DOC,F2_EMISSAO FROM "+RetSqlName("SF2")
	cSql += " WHERE  D_E_L_E_T_ = ''"
	cSql += " AND    F2_FILIAL BETWEEN '' AND 'ZZ'"
	cSql += " AND    F2_CLIENTE = '"+SEPU->A1_COD+"'"
	cSql += " AND    F2_LOJA    = '"+SEPU->A1_LOJA+"'"
	cSql += " ORDER BY F2_EMISSAO DESC"
	cSql += " FETCH FIRST 1 ROWS ONLY"
	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","F2_EMISSAO","D")
	dbSelectArea("ARQ_SQL")
	cUltNF  := ""
	dUltFat := ctod("//")
	If !eof()
		cUltNF  := F2_DOC
		dUltFat := F2_EMISSAO
	Endif
	dbCloseArea()
	

	cSql := "SELECT "
	cSql += "     (SELECT SUM(C2_QUANT)"
	cSql += "     FROM "+RetSqlName("SC2")
	cSql += "     WHERE D_E_L_E_T_ = ''"
	cSql += "     AND   C2_FORNECE = SC2.C2_FORNECE"
	cSql += "     AND   C2_LOJA = SC2.C2_LOJA"
	cSql += "     AND   C2_X_STATU = '6'"
	cSql += "     AND   NOT C2_X_DESEN LIKE '%EXA%') AS PROD"

	cSql += "     ,(SELECT SUM(C2_QUANT)"
	cSql += "     FROM "+RetSQlName("SC2")
	cSql += "     WHERE D_E_L_E_T_ = ''"
	cSql += "     AND   C2_FORNECE = SC2.C2_FORNECE"
	cSql += "     AND   C2_LOJA = SC2.C2_LOJA"
	cSql += "     AND   C2_X_STATU = '9'"
	cSql += "     AND   NOT C2_X_DESEN LIKE '%EXA%') AS REJEI"

	cSql += "     ,(SELECT SUM(C2_QUANT)"
	cSql += "     FROM "+RetSqlName("SC2")
	cSql += "     WHERE D_E_L_E_T_ = ''"
	cSql += "     AND   C2_FORNECE = SC2.C2_FORNECE"
	cSql += "     AND   C2_LOJA = SC2.C2_LOJA"
	cSql += "     AND   C2_X_STATU = '6'"
	cSql += "     AND   C2_X_DESEN LIKE '%EXA%') AS QTD_ATE"

	cSql += "     ,(SELECT SUM(C2_XPRCTAB)"
	cSql += "     FROM "+RetSqlName("SC2")
	cSql += "     WHERE D_E_L_E_T_ = ''"
	cSql += "     AND   C2_FORNECE = SC2.C2_FORNECE"
	cSql += "     AND   C2_LOJA = SC2.C2_LOJA"
	cSql += "     AND   C2_X_STATU = '6'"
	cSql += "     AND   C2_X_DESEN LIKE '%EXA%') AS VLR_ATE"

	cSql += "     ,(SELECT SUM(E1_VALOR)"
	cSql += "     FROM "+RetSqlName("SE1")
	cSql += "     WHERE D_E_L_E_T_ = ''"
	cSql += "     AND   E1_TIPO = 'NCC'"
	cSql += "     AND   E1_PREFIXO = 'SEP'"
	cSql += "     AND   E1_CLIENTE = SC2.C2_FORNECE"
	cSql += "     AND   E1_LOJA = SC2.C2_LOJA) AS BONIF"

	cSql += "     ,(SELECT SUM(C2_QUANT)"
	cSql += "     FROM "+RetSqlName("SC2")
	cSql += "     WHERE D_E_L_E_T_ = ''"
	cSql += "     AND   C2_FORNECE = SC2.C2_FORNECE"
	cSql += "     AND   C2_LOJA = SC2.C2_LOJA"
	cSql += "     AND   C2_X_STATU = '9'"
	cSql += "     AND   C2_X_DESEN LIKE '%EXA%') AS RECUSA"

	cSql += " FROM "+RetSqlName("SC2")+" SC2"
	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += " AND   C2_FORNECE = '"+SEPU->A1_COD+"'"
	cSql += " AND   C2_LOJA = '"+SEPU->A1_LOJA+"'"
	cSql += " FETCH FIRST 1 ROW ONLY"
	MsgRun("Consultando Banco de Dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_HIST", .T., .T.)})
	TcSetField("SQL_HIST","PROD"   ,"N",14,2)
	TcSetField("SQL_HIST","REJEI"  ,"N",14,2)
	TcSetField("SQL_HIST","QTD_ATE","N",14,2)
	TcSetField("SQL_HIST","VLR_ATE","N",14,2)
	TcSetField("SQL_HIST","BONIF"  ,"N",14,2)
	TcSetField("SQL_HIST","RECUSA" ,"N",14,2)

	dbSelectArea("SEPU")
	dbGoTop()

	DEFINE MSDIALOG oDlg FROM 000,000 TO 480,640 TITLE "SEPU" PIXEL
	@ 012,002 Folder oFolder ;
		ITEMS "Cliente","Inspeção","Pneus","Regra de Negocio","Laudo","Histórico" ;
		SIZE 318,228 PIXEL OF oDlg

		For k=1 to Len(oFolder:aDialogs)
			cNomObj := "oSbr"+StrZero(k,2)
			@ 001,001 SCROLLBOX &cNomObj SIZE 212,314 OF oFolder:aDialogs[k]
		Next
	
		// Folder Cliente
		LI:=5
		@ LI  ,003 SAY "Cliente"       PIXEL OF oSbr01
		@ LI-1,035 GET SEPU->A1_COD    PIXEL OF oSbr01 SIZE 20,7 READONLY
		@ LI  ,120 SAY "Loja"          PIXEL OF oSbr01
		@ LI-1,150 GET SEPU->A1_LOJA   PIXEL OF oSbr01 SIZE 10,7 READONLY
		@ LI  ,200 SAY "CNPJ"          PIXEL OF oSbr01
		@ LI-1,230 GET SEPU->A1_CGC    PIXEL OF oSbr01 SIZE 60,7 READONLY
		
		LI+=11
		@ LI  ,003 SAY "Nome"         PIXEL OF oSbr01
		@ LI-1,035 GET SEPU->A1_NOME   SIZE 275,7 PIXEL OF oSbr01 READONLY

		LI+=11
		@ LI  ,003 SAY "Endereço"     PIXEL OF oSbr01
		@ LI-1,035 GET SEPU->A1_END    SIZE 275,7 PIXEL OF oSbr01 READONLY

		LI+=11
		@ LI  ,003 SAY "Cidade"        PIXEL OF oSbr01
		@ LI-1,035 GET SEPU->A1_MUN    PIXEL OF oSbr01 SIZE 60,7 READONLY
		@ LI  ,120 SAY "Estado"        PIXEL OF oSbr01
		@ LI-1,150 GET SEPU->A1_EST    PIXEL OF oSbr01 SIZE 10,7 READONLY
		@ LI  ,200 SAY "Telefone"      PIXEL OF oSbr01
		@ LI-1,230 GET SEPU->A1_TEL    PIXEL OF oSbr01 SIZE 60,7 READONLY

		LI+=11
		@ LI  ,003 SAY "Ult. Compra"   PIXEL OF oSbr01
		@ LI-1,035 GET SEPU->A1_ULTCOM PIXEL OF oSbr01 SIZE 40,7 READONLY
		@ LI  ,200 SAY "Risco"         PIXEL OF oSbr01
		@ LI-1,230 GET SEPU->A1_RISCO  PIXEL OF oSbr01 SIZE 10,7 READONLY


		// Folder Inspeção
		LI:=5
		@ LI  ,003 SAY "Coleta Ori."    PIXEL OF oSbr02
		@ LI-1,035 GET SEPU->C2_XCOLORI PIXEL OF oSbr02 SIZE 20,7 READONLY
		@ LI  ,120 SAY "Dt. Coleta"     PIXEL OF oSbr02
		@ LI-1,150 GET dColOri          PIXEL OF oSbr02 SIZE 40,7 READONLY

		LI+=11
		@ LI  ,003 SAY "Ult. NF"        PIXEL OF oSbr02
		@ LI-1,035 GET cUltNF           PIXEL OF oSbr02 SIZE 20,7 READONLY
		@ LI  ,120 SAY "Dt. Fatura"     PIXEL OF oSbr02
		@ LI-1,150 GET dUltFat PIXEL OF oSbr02 SIZE 40,7 READONLY

		LI+=11
		@ LI  ,003 SAY "Coleta Exam"    PIXEL OF oSbr02
		@ LI-1,035 GET SEPU->C2_NUMD1   PIXEL OF oSbr02 SIZE 20,7 READONLY
		@ LI  ,120 SAY "Dt. Exame"      PIXEL OF oSbr02
		@ LI-1,150 GET SEPU->C2_EMISSAO PIXEL OF oSbr02 SIZE 40,7 READONLY

		// Folder Pneu
		cVar := Space(30)
		nVar := 0
		LI:=5
		@ LI  ,003 SAY "Medida"         PIXEL OF oSbr03
		@ LI-1,035 GET SEPU->C2_PRODUTO PIXEL OF oSbr03 SIZE 40,7 READONLY
		@ LI  ,120 SAY "Marca"          PIXEL OF oSbr03
		@ LI-1,150 GET SEPU->C2_MARCAPN PIXEL OF oSbr03 SIZE 40,7 READONLY
		@ LI  ,200 SAY "Banda"          PIXEL OF oSbr03
		@ LI-1,230 GET SEPU->C2_XBANDA  PIXEL OF oSbr03 SIZE 60,7 READONLY

		LI+=11
		@ LI  ,003 SAY "Série"          PIXEL OF oSbr03
		@ LI-1,035 GET SEPU->C2_SERIEPN PIXEL OF oSbr03 SIZE 60,7 READONLY
		@ LI  ,120 SAY "Fogo"           PIXEL OF oSbr03
		@ LI-1,150 GET SEPU->C2_NUMFOGO PIXEL OF oSbr03 SIZE 60,7 READONLY

		LI+=11
		@ LI  ,003 SAY "Cod. Serviço"   PIXEL OF oSbr03
		@ LI-1,035 GET SEPU->D1_SERVICO PIXEL OF oSbr03 SIZE 60,7 READONLY
		@ LI  ,120 SAY "Cod. Exame"     PIXEL OF oSbr03
		@ LI-1,150 GET SEPU->C2_NUM     PIXEL OF oSbr03 SIZE 60,7 READONLY
		@ LI  ,230 SAY "Item"           PIXEL OF oSbr03
		@ LI-1,250 GET TMP->C2_ITEM     PIXEL OF oSbr03 SIZE 20,7 READONLY

		LI+=11
		@ LI  ,003 SAY "Prc. Tab."      PIXEL OF oSbr03
		@ LI-1,035 GET SEPU->C2_XPRCTAB PIXEL OF oSbr03 SIZE 60,7 READONLY Picture "@e 99,999.99"
		@ LI  ,120 SAY "Profundid"      PIXEL OF oSbr03
		@ LI-1,150 GET SEPU->C2_XPROFOR PIXEL OF oSbr03 SIZE 40,7 READONLY Picture "@e 99,999.99"
		@ LI  ,200 SAY "Prf. Aferida"   PIXEL OF oSbr03
		@ LI-1,230 GET SEPU->C2_XPROFAF PIXEL OF oSbr03 SIZE 60,7 READONLY Picture "@e 99,999.99"

		// Folder Regra
		//                New(nTop, nLeft, nBottom, nRight, nOpc, [cLinhaOk], [cTudoOk], [cIniCpos], [lDelete], [aAlter], [nFreeze], [lEmpty], [uPar1], cTRB    , [cFieldOk], [lCondicional], [lAppend], [oWnd], [lDisparos], [uPar2], [cDelOk], [cSuperDel])
		oGetDb:=MsGetDB():New(000 ,   000,     210,    312,    2,  ""       ,  ""      , ""        , .F.      ,         ,          , .T.     ,        , "REGRA" , ""        ,               ,          , oSbr04 , .F.        ,         , ""      , ""         )


		// Folder Laudo
		LI:=5
		@ LI,001 TO LI+107,303 TITLE "Produção" PIXEL OF oSbr05
		LI+=11
		@ LI  ,003 SAY "Mot. Rejei."     PIXEL OF oSbr05
		@ LI-1,035 GET SEPU->C2_XMREPRD  PIXEL OF oSbr05 SIZE 20,7 READONLY
		@ LI  ,120 SAY "Desc. Rejei"     PIXEL OF oSbr05
		@ LI-1,150 GET SEPU->DESCPRD     PIXEL OF oSbr05 SIZE 150,7 READONLY
		
		LI+=11
		cMemo01 := MSMM(SEPU->C2_XCOBS1,80)
		@ LI  ,003 SAY "Observação"      PIXEL OF oSbr05
		@ LI-1,035 MEMO cMemo01          PIXEL OF oSbr05 SIZE 265,60 NO VSCROLL READONLY

		LI+=61
		@ LI  ,003 SAY "Dt. Inspeção"   PIXEL OF oSbr05
		@ LI-1,035 GET SEPU->C2_XDATPRD PIXEL OF oSbr05 SIZE 40,7 READONLY

		LI+=11
		@ LI  ,003 SAY "Profundid"      PIXEL OF oSbr05
		@ LI-1,035 GET SEPU->C2_XPROFOR PIXEL OF oSbr05 SIZE 40,7 Picture "@e 99,999.99" READONLY
		@ LI  ,085 SAY "Prf. Aferida"   PIXEL OF oSbr05
		@ LI-1,120 GET SEPU->C2_XPROFAF PIXEL OF oSbr05 SIZE 40,7 Picture "@e 99,999.99" READONLY


		LI+=22
		@ LI,001 TO LI+97,303 TITLE "Comercial" PIXEL OF oSbr05
		LI+=11
		@ LI  ,003 SAY "Mot. Rejei."     PIXEL OF oSbr05
		@ LI-1,035 GET SEPU->C2_XMREFIN  PIXEL OF oSbr05 SIZE 20,7 READONLY
		@ LI  ,120 SAY "Desc. Rejei"     PIXEL OF oSbr05
		@ LI-1,150 GET SEPU->DESCFIN     PIXEL OF oSbr05 SIZE 150,7 READONLY
		
		LI+=11
		cMemo02 := MSMM(SEPU->C2_XCOBS2,80)
		@ LI  ,003 SAY "Observação"      PIXEL OF oSbr05
		@ LI-1,035 MEMO cMemo02          PIXEL OF oSbr05 SIZE 265,60 NO VSCROLL READONLY

		LI+=61
		@ LI  ,003 SAY "Dt. Inspeção"   PIXEL OF oSbr05
		@ LI-1,035 GET SEPU->C2_XDATFIN PIXEL OF oSbr05 SIZE 40,7 READONLY


		LI+=22
		@ LI,001 TO LI+107,303 TITLE "Diretoria" PIXEL OF oSbr05
		LI+=11
		@ LI  ,003 SAY "Mot. Rejei."     PIXEL OF oSbr05
		@ LI-1,035 GET SEPU->C2_XMREDIR  PIXEL OF oSbr05 SIZE 20,7 READONLY
		@ LI  ,120 SAY "Desc. Rejei"     PIXEL OF oSbr05
		@ LI-1,150 GET SEPU->DESCDIR     PIXEL OF oSbr05 SIZE 150,7 READONLY
		
		LI+=11
		cMemo03 := MSMM(SEPU->C2_XCOBS3,80)
		@ LI  ,003 SAY "Observação"      PIXEL OF oSbr05
		@ LI-1,035 MEMO cMemo03          PIXEL OF oSbr05 SIZE 265,60 NO VSCROLL READONLY

		LI+=61
		@ LI  ,003 SAY "Dt. Inspeção"   PIXEL OF oSbr05
		@ LI-1,035 GET SEPU->C2_XDATDIR PIXEL OF oSbr05 SIZE 40,7 READONLY
		@ LI  ,120 SAY "Status"   PIXEL OF oSbr05
		@ LI-1,150 GET SEPU->C2_XSTDIR PIXEL OF oSbr05 SIZE 20,7 READONLY F3 "SP"

		/*
		LI+=11
		@ LI  ,003 SAY "Status"          PIXEL OF oSbr05
		@ LI-1,035 GET cVar              PIXEL OF oSbr05 SIZE 10,7 READONLY
		*/

		nPerc  := (SEPU->C2_XPROFAF/SEPU->C2_XPROFOR)*100
		nSuger := SEPU->C2_XVALAPR

		LI+=11
		@ LI  ,003 SAY "Vlr Bonif."     PIXEL OF oSbr05
		@ LI-1,035 GET nSuger           PIXEL OF oSbr05 SIZE 50,7 When (cCombo="Sim") PICTURE "@E 99,999,999,999.99" READONLY
		@ LI  ,120 SAY "Percentual"     PIXEL OF oSbr05
		@ LI-1,150 GET nPerc            PIXEL OF oSbr05 SIZE 60,7 PICTURE "@E 999.99" READONLY


		// Folder Histórico
		LI:=5
		@ LI,001 TO LI+30,303 TITLE "Pneus" PIXEL OF oSbr06
		LI+=11
		@ LI  ,003 SAY "Produzidos"    PIXEL OF oSbr06
		@ LI-1,035 GET SQL_HIST->PROD  PIXEL OF oSbr06 SIZE 60,7 READONLY PICTURE "@e 999,999"
		@ LI  ,120 SAY "Rejeitados"    PIXEL OF oSbr06
		@ LI-1,150 GET SQL_HIST->REJEI PIXEL OF oSbr06 SIZE 60,7 READONLY PICTURE "@e 999,999"

		LI+=22
		@ LI,001 TO LI+41,303 TITLE "SEPU" PIXEL OF oSbr06
		LI+=11
		@ LI  ,003 SAY "Qtd Atendido"    PIXEL OF oSbr06
		@ LI-1,035 GET SQL_HIST->QTD_ATE PIXEL OF oSbr06 SIZE 60,7 READONLY PICTURE "@e 999,999"
		@ LI  ,120 SAY "Vlr Atendido"    PIXEL OF oSbr06
		@ LI-1,150 GET SQL_HIST->VLR_ATE PIXEL OF oSbr06 SIZE 60,7 READONLY PICTURE "@e 999,999.99"
		LI+=11
		@ LI  ,003 SAY "Bonificação"     PIXEL OF oSbr06
		@ LI-1,035 GET SQL_HIST->BONIF   PIXEL OF oSbr06 SIZE 60,7 READONLY PICTURE "@e 999,999.99"
		@ LI  ,120 SAY "Recusados"       PIXEL OF oSbr06
		@ LI-1,150 GET SQL_HIST->RECUSA  PIXEL OF oSbr06 SIZE 60,7 READONLY PICTURE "@e 999,999"

		if lBar
			aadd(aBtnAdd, {"NOTE",{|| U_DSEPUA02(.F.),Close(oDlg) },"Laudo"} )
		Endif

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| Close(oDlg) },{|| Close(oDlg) } , , aBtnAdd)

	dbSelectArea("SQL_HIST")
	dbCloseArea()
	dbSelectArea("REGRA")
	dbCloseArea()
	dbSelectArea("SEPU")
	dbCloseArea()
	RestArea(aArea)
Return nil