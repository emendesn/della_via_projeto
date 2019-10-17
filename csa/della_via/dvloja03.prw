#Include "Dellavia.ch"
#Define DESPIR "DESPIR"
#Define AGRUP  "AGRUPAMENTO"

/*
DVLOJA03 - Manutenção no cadastro de Metas Quantitativo (ZX4)
31/03/2007 - Denis Francisco Tofoli
*/

User Function DVLOJA03
	Private cTabela   := "ZX4"
	Private cCadastro := ""
	Private aCores    := {}
	Private aRotina   := {}
	Private cNomZX4   := ""
	Private cNomSA3   := ""
	Private lVarejo   := (Upper(AllTrim(cUserName)) $ Upper(AllTrim(GetMv("MV_UVAREJO",,""))))
	Private lRodas    := (Upper(AllTrim(cUserName)) $ Upper(AllTrim(GetMv("MV_URODAS",,""))))
	Private cRegiao   := ""

	dbSelectArea("SU7")
	dbSetOrder(4)
	dbGoTop()
	dbSeek(xFilial("SU7")+__cUserId)
	If !Found() .AND. !lVarejo .AND. !lRodas
		msgbox("Voce não pode acessar esta rotina, pois não esta cadastrado como operador","Descontos","STOP")
		Return nil
	Endif

	dbSelectArea("SA3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SA3")+SU7->U7_CODVEN)
	If !Found() .AND. !lVarejo .AND. !lRodas
		msgbox("Voce não pode acessar esta rotina, pois não esta cadastrado como vendedor","Descontos","STOP")
		Return nil
	Endif
	cRegiao := SA3->A3_REGIAO


	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))

	MsgRun("Consultando Banco de dados ...",,{|| AbreSA3(), AbreZX4()  })

	aadd(aCores,{"ZX4_STATUS = '1'" ,"BR_VERDE"      })
	aadd(aCores,{"ZX4_STATUS = '2'" ,"BR_VERMELHO"   })


	aadd(aRotina,{"Pesquisar" ,"AxPesqui"  ,0,1})
	aadd(aRotina,{"Visualizar","U_DVLJA03A",0,2})
	aadd(aRotina,{"Incluir"   ,"U_DVLJA03A",0,3})
	aadd(aRotina,{"Alterar"   ,"U_DVLJA03A",0,4})
	aadd(aRotina,{"Excluir"   ,"U_DVLJA03A",0,5})
	aadd(aRotina,{"Copiar"    ,"U_DVLJA03A",0,6})
	aadd(aRotina,{"Legenda"   ,"U_DVLJA03L",0,4})

	mBrowse(,,,,cTabela,,,,,,aCores)

	dbSelectArea(cTabela)
	dbCloseArea()
	fErase(cNomZX4+GetDbExtension())
	fErase(cNomZX4+OrdBagExt())

	dbSelectArea("SA3")
	dbCloseArea()
	fErase(cNomSA3+GetDbExtension())
	fErase(cNomSA3+OrdBagExt())

	ChkFile(cTabela)
	ChkFile("SA3")
Return nil

User Function DVLJA03A(cAlias,nReg,nOpc)
	Local aEstru   := {}
	Local aAlter   := {"T_QUANT"}
	Local cNomTmp  := ""
	Local cSql     := ""
	Local LI       := 5
	
	Private aHeader := {}
	Private aCols   := {}
	Private lCopia  := .F.

	if ZX4->ZX4_STATUS = "2" .AND. nOpc = 5
		Help(" ",1,"ZX4BLQ",,"Meta Bloqueada, não pode ser alterada nem excluida.",4,1)
		Return nil
	Endif

	aAdd(aHeader,{"Tipo"       ,"T_TIPO" ,"@!"            ,11,0,,,"C",,})
	aAdd(aHeader,{"Codigo"     ,"T_COD"  ,"@!"            ,09,0,,,"C",,})
	aAdd(aHeader,{"Descrição"  ,"T_DESC" ,"@!"            ,50,0,,,"C",,})
	aAdd(aHeader,{"Quantidade" ,"T_QUANT","@e 999,999,999",09,0,,,"N",,})

	If nOpc = 3
		M->ZX4_FILIAL := SM0->M0_CODFIL
		M->ZX4_ANOMES := Space(Len(ZX4->ZX4_ANOMES))
		M->ZX4_AREANE := AreaNeg()
		M->ZX4_VEND   := Space(Len(ZX4->ZX4_VEND))
		M->ZX4_REVISA := "001"
		M->ZX4_NOME   := Space(30)
	Else
		M->ZX4_FILIAL := ZX4->ZX4_FILIAL
		M->ZX4_ANOMES := ZX4->ZX4_ANOMES
		M->ZX4_AREANE := ZX4->ZX4_AREANE
		M->ZX4_VEND   := ZX4->ZX4_VEND
		If nOpc = 4
			M->ZX4_REVISA := NovaRevisao()
		Else
			M->ZX4_REVISA := ZX4->ZX4_REVISA
		Endif
		M->ZX4_NOME   := Substr(Posicione("SA3",1,xFilial("SA3")+ZX4_VEND,"SA3->A3_NOME"),1,30)
	Endif

	If Empty(M->ZX4_AREANE)
		Return
	Endif


	aEstru := {}
	aAdd(aEstru,{"T_TIPO" ,"C",11,0})
	aAdd(aEstru,{"T_COD"  ,"C",09,0})
	aAdd(aEstru,{"T_DESC" ,"C",50,0})
	aAdd(aEstru,{"T_QUANT","N",09,0})
	cNomTmp1 := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp1,"LISTA",.F.,.F.)
	IndRegua("LISTA",cNomTmp1,"DESCEND(T_TIPO)+T_COD",,.t.,"Selecionando Registros...")


	If M->ZX4_AREANE <> "V"
		cSql := "SELECT X5_CHAVE,X5_DESCRI FROM "+RetSqlName("SX5")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   X5_FILIAL = ''"
		cSql += " AND   X5_TABELA = 'Z6'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		dbSelectArea("ARQ_SQL")
		Do While !eof()
			dbSelectArea("LISTA")
			If RecLock("LISTA",.T.)
				LISTA->T_TIPO := DESPIR
				LISTA->T_COD  := ARQ_SQL->X5_CHAVE
				LISTA->T_DESC := ARQ_SQL->X5_DESCRI
				MsUnLock()
			Endif
			dbSelectArea("ARQ_SQL")
			dbSkip()
		Enddo
		dbCloseArea()
	Endif


	cSql := "SELECT SZH.ZH_CODAGRU,RTRIM(N1.ZH_DESC) || ' - '  || RTRIM(N2.ZH_DESC) || ' - ' || RTRIM(SZH.ZH_DESC) AS ZH_DESC"
	cSql += " FROM "+RetSqlName("SZH")+" SZH"

	cSql += " JOIN "+RetSqlName("SZH")+" N1"
	cSql += " ON   N1.D_E_L_E_T_ = ''"
	cSql += " AND  N1.ZH_FILIAL = '"+xFilial("SZH")+"'"
	cSql += " AND  N1.ZH_CODAGRU = SUBSTR(SZH.ZH_CODAGRU,1,3) || '000000'"

	cSql += " JOIN "+RetSqlName("SZH")+" N2"
	cSql += " ON   N2.D_E_L_E_T_ = ''"
	cSql += " AND  N2.ZH_FILIAL = '"+xFilial("SZH")+"'"
	cSql += " AND  N2.ZH_CODAGRU = SUBSTR(SZH.ZH_CODAGRU,1,6) || '000'"

	cSql += " WHERE SZH.D_E_L_E_T_ = ''"
	cSql += " AND   SZH.ZH_FILIAL = '"+xFilial("SZH")+"'"
	cSql += " AND   SUBSTR(SZH.ZH_CODAGRU,7,3) <> '000'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	Do While !eof()
		dbSelectArea("LISTA")
		If RecLock("LISTA",.T.)
			LISTA->T_TIPO := AGRUP
			LISTA->T_COD  := ARQ_SQL->ZH_CODAGRU
			LISTA->T_DESC := ARQ_SQL->ZH_DESC
			MsUnLock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()


	If nOpc <> 3
		cSql := "SELECT ZX4_CODAGR,ZX4_QTD,ZX4_DESPIR,ZX4_QTDPIR"
		cSql += " FROM ZX4010 ZX4"
		cSql += " WHERE ZX4.D_E_L_E_T_ = ''"
		cSql += " AND   ZX4.ZX4_FILIAL = '"+M->ZX4_FILIAL+"'"
		cSql += " AND   ZX4.ZX4_ANOMES = '"+M->ZX4_ANOMES+"'"
		cSql += " AND   ZX4.ZX4_AREANE = '"+M->ZX4_AREANE+"'"
		cSql += " AND   ZX4.ZX4_VEND = '"+M->ZX4_VEND+"'"
		If nOpc = 2 .OR. nOpc = 6
			cSql += " AND   ZX4.ZX4_REVISA = '"+M->ZX4_REVISA+"'"
		Else
			cSql += " AND   ZX4.ZX4_REVISA = (SELECT MAX(ZX4_REVISA) FROM "+RetSqlName("ZX4")
			cSql += "                         WHERE D_E_L_E_T_ = ''"
			cSql += "                         AND ZX4_FILIAL = ZX4.ZX4_FILIAL"
			cSql += "                         AND ZX4_ANOMES = ZX4.ZX4_ANOMES"
			cSql += "                         AND ZX4_AREANE = ZX4.ZX4_AREANE"
			cSql += "                         AND ZX4_VEND = ZX4.ZX4_VEND)"
		Endif
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
		TcSetField("ARQ_SQL","ZX4_QTD"   ,"N",09,0)
		TcSetField("ARQ_SQL","ZX4_QTDPIR","N",09,0)
	
		dbSelectArea("ARQ_SQL")
		dbGoTop()
		
		Do While !eof()
			If !Empty(ZX4_CODAGR)
				dbSelectArea("LISTA")
				dbSeek(DESCEND(AGRUP)+ARQ_SQL->ZX4_CODAGR)
				If RecLock("LISTA",!Found())
					LISTA->T_TIPO  := AGRUP
					LISTA->T_COD   := ARQ_SQL->ZX4_CODAGR
					LISTA->T_QUANT := ARQ_SQL->ZX4_QTD
					MsUnLock()
				Endif
			Else
				dbSelectArea("LISTA")
				dbSeek(DESCEND(Substr(DESPIR+Space(11),1,11))+ARQ_SQL->ZX4_DESPIR)
				If RecLock("LISTA",!Found())
					LISTA->T_TIPO  := DESPIR
					LISTA->T_COD   := ARQ_SQL->ZX4_DESPIR
					LISTA->T_QUANT := ARQ_SQL->ZX4_QTDPIR
					MsUnLock()
				Endif
			Endif
			dbSelectArea("ARQ_SQL")
			dbSkip()
		Enddo
		dbCloseArea()
	Endif


	dbSelectArea("LISTA")
	dbGoTop()
	Do While !eof()
		aAdd(aCols,{T_TIPO,T_COD,T_DESC,T_QUANT,.F.})
		dbSkip()
	Enddo

	lCopia := (nOpc = 6)
	if lCopia
		nOpc := 4
	Endif

	dbSelectArea("LISTA")
	DEFINE MSDIALOG oDlgAtu FROM 000,000 TO 420,640 TITLE "Meta" PIXEL
		@ 012,000 SCROLLBOX oSbr SIZE 045,321 PIXEL
		@ LI  ,003 SAY "Filial"          PIXEL OF oSbr COLOR RGB(0,0,255)
		@ LI-1,035 GET M->ZX4_FILIAL     PIXEL OF oSbr SIZE Len(M->ZX4_FILIAL)*5,7 WHEN nOpc = 3 VALID !Empty(M->ZX4_FILIAL)
		@ LI  ,120 SAY "Ano / Mes"       PIXEL OF oSbr COLOR RGB(0,0,255)
		@ LI-1,150 GET M->ZX4_ANOMES     PIXEL OF oSbr SIZE Len(M->ZX4_ANOMES)*5,7 WHEN nOpc = 3 .OR. lCopia VALID !Empty(M->ZX4_ANOMES)
		LI+=11
		@ LI  ,003 SAY "Area Neg."       PIXEL OF oSbr
		@ LI-1,035 GET M->ZX4_AREANE     PIXEL OF oSbr SIZE Len(M->ZX4_AREANE)*5,7 WHEN .F.
		@ LI  ,120 SAY "Revisao"         PIXEL OF oSbr
		@ LI-1,150 GET M->ZX4_REVISA     PIXEL OF oSbr SIZE Len(M->ZX4_REVISA)*5,7 WHEN .F.
		LI+=11
		IF M->ZX4_AREANE <> "V"
			@ LI  ,003 SAY "Vendedor"        PIXEL OF oSbr COLOR RGB(0,0,255)
			@ LI-1,035 GET M->ZX4_VEND       PIXEL OF oSbr SIZE Len(M->ZX4_VEND)*5,7 WHEN nOpc = 3 F3 "SA3" VALID VldVend()
			@ LI  ,120 SAY "Nome"            PIXEL OF oSbr
			@ LI-1,150 GET M->ZX4_NOME       PIXEL OF oSbr SIZE Len(M->ZX4_NOME)*5,7 WHEN .F. OBJECT oNome
		Endif

		MsGetDados():New(060,001,210,321,nOpc,,,, .F. , aAlter,,,,,,,,oDlgAtu)
	ACTIVATE MSDIALOG oDlgAtu CENTER ON INIT EnchoiceBar(oDlgAtu,{|| Gravar(nOpc) },{|| Close(oDlgAtu) })

	dbSelectArea("LISTA")
	dbCloseArea()

	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())
Return nil

Static Function NovaRevisao()
	Local aArea := GetArea()
	Local cRet  := ""
	Local cSql  := ""

	cSql := "SELECT INT(MAX(ZX4_REVISA))+1 AS REVISA"
	cSql += " FROM "+RetSqlName("ZX4")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZX4_FILIAL = '"+ZX4->ZX4_FILIAL+"'"
	cSql += " AND   ZX4_ANOMES = '"+ZX4->ZX4_ANOMES+"'"
	cSql += " AND   ZX4_AREANE = '"+ZX4->ZX4_AREANE+"'"
	cSql += " AND   ZX4_VEND = '"+ZX4->ZX4_VEND+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","REVISA","N",3,0)
	cRet := StrZero(REVISA,3)
	dbCloseArea()

	RestArea(aArea)
Return cRet

Static Function VldVend()
	Local aArea := GetArea()
	Local lRet := .T.
	M->ZX4_NOME := Substr(Posicione("SA3",1,xFilial("SA3")+M->ZX4_VEND,"SA3->A3_NOME"),1,30)

	cSql := "SELECT ZX4_FILIAL FROM "+RetSqlName("ZX4")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZX4_VEND = '"+M->ZX4_VEND+"'"
	cSql += " AND   ZX4_ANOMES = '"+M->ZX4_ANOMES+"'"
	cSql += " AND   ZX4_REVISA = '"+M->ZX4_REVISA+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"VLD_VEND", .T., .T.)
	dbSelectArea("VLD_VEND")

	lRet := Eof()
	If !lRet
		Help(" ",1,"JAGRAVADO")
	Endif

	dbCloseArea()
	RestArea(aArea)
Return lRet

Static Function Gravar(nOpc)
    Local nTotal := 0

	aEval(aCols,{ |aX| nTotal += aX[4] })

	If nTotal <= 0
		msgbox("Não é possivel zerar todos os itens.","Metas","STOP")
		Return nil
	Endif
	
	dbSelectArea("ZX4")
	dbCloseArea()
	fErase(cNomZX4+GetDbExtension())
	fErase(cNomZX4+OrdBagExt())

	ChkFile("ZX4")
	dbSelectArea("ZX4")

	If nOpc = 3
		IF !ExistChav("ZX4",M->ZX4_ANOMES+M->ZX4_AREANE+M->ZX4_VEND,1)
			Return nil
		Endif
	Endif

	if lCopia
		IF dbSeek(M->ZX4_FILIAL+M->ZX4_ANOMES+M->ZX4_AREANE+M->ZX4_VEND,.F.)
			Help(" ",1,"JAGRAVADO")
			Return nil
		Endif
	Endif

	Close(oDlgAtu)

	If nOpc = 4 .OR. nOpc = 5
		cSql := "UPDATE "+RetSqlName("ZX4")
		If nOpc = 5
			cSql += " SET D_E_L_E_T_  = '*'"
		Else
			cSql += " SET ZX4_STATUS = '2'"
		Endif
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ZX4_FILIAL = '"+M->ZX4_FILIAL+"'"
		cSql += " AND   ZX4_ANOMES = '"+M->ZX4_ANOMES+"'"
		cSql += " AND   ZX4_AREANE = '"+M->ZX4_AREANE+"'"
		cSql += " AND   ZX4_VEND = '"+M->ZX4_VEND+"'"
		cSql += " AND   ZX4_STATUS = '1'"
		If nOpc = 5
			cSql += " AND ZX4_REVISA = '"+M->ZX4_REVISA+"'"
		Endif

		nUpdt := TcSqlExec(cSql)

		If nUpdt < 0
			MsgBox(TcSqlError(),"Erro ...","STOP")
			Return nil
		Endif
	Endif

	If nOpc = 5
		cSql := "UPDATE "+RetSqlName("ZX4")
		cSql += " SET    ZX4_STATUS = '1'"
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ZX4_FILIAL = '"+M->ZX4_FILIAL+"'"
		cSql += " AND   ZX4_ANOMES = '"+M->ZX4_ANOMES+"'"
		cSql += " AND   ZX4_AREANE = '"+M->ZX4_AREANE+"'"
		cSql += " AND   ZX4_VEND = '"+M->ZX4_VEND+"'"
		cSql += " AND   ZX4_REVISA = '"+StrZero(Val(M->ZX4_REVISA)-1,3)+"'"

		nUpdt := TcSqlExec(cSql)

		If nUpdt < 0
			MsgBox(TcSqlError(),"Erro ...","STOP")
			Return nil
		Endif
	Endif


	if nOpc = 3 .OR. nOpc = 4 .OR. nOpc = 6
		For k=1 to Len(aCols)
			If aCols[k,4] > 0
				If RecLock("ZX4",.T.)
					ZX4->ZX4_FILIAL := M->ZX4_FILIAL
					ZX4->ZX4_ANOMES := M->ZX4_ANOMES
					ZX4->ZX4_AREANE := M->ZX4_AREANE
					ZX4->ZX4_VEND   := M->ZX4_VEND
					ZX4->ZX4_REVISA := M->ZX4_REVISA
					ZX4->ZX4_STATUS := "1"

					If aCols[k,1] = DESPIR
						ZX4->ZX4_DESPIR := aCols[k,2]
						ZX4->ZX4_QTDPIR := aCols[k,4]
					Else
						ZX4->ZX4_CODAGR := aCols[k,2]
						ZX4->ZX4_QTD    := aCols[k,4]
					Endif

					MsUnLock()
				Endif
			Endif
		Next k
	Endif

	AbreZX4()
Return nil

Static Function AreaNeg()
	Local cRet   := ""
	Local cCombo := ""
	Local aCombo := {}
	
	dbSelectArea("PAG")
	dbSetOrder(1)
	dbGoTop()
	Do while !eof()
		If lVarejo
			if AllTrim(PAG_TIPO) = "V"
				aAdd(aCombo,AllTrim(PAG_TIPO)+" - "+Capital(AllTrim(PAG_DESC)))
			Endif
		Elseif lRodas
			if AllTrim(PAG_TIPO) = "R"
				aAdd(aCombo,AllTrim(PAG_TIPO)+" - "+Capital(AllTrim(PAG_DESC)))
			Endif
		Else
			If AllTrim(PAG_TIPO) $ AllTrim(SU7->U7_TIPVND)
				aAdd(aCombo,AllTrim(PAG_TIPO)+" - "+Capital(AllTrim(PAG_DESC)))
			Endif
		Endif
		dbSkip()
	Enddo

	If Len(aCombo) <= 0
		msgbox("Você não tem permissão para incluir nenhum tipo de meta","Incluir","STOP")
		Return ""
	Endif


	DEFINE MSDIALOG oDlgArea TITLE "Area de Negocio" From 0,0 To 040,190 OF oMainWnd Pixel
		@ 05,05 COMBOBOX cCombo ITEMS aCombo SIZE 50,10 PIXEL
		@ 03,65 BMPBUTTON TYPE 1 ACTION Close(oDlgArea)
	ACTIVATE MSDIALOG oDlgArea CENTERED
	
	cRet := Substr(cCombo,1,1)
Return cRet

Static Function AbreZX4
	Local cSql   := ""
	Local aEstru := {}
	Local aIndex := {}
	Local k      := 0

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZX4")
	
	Do While !eof() .AND. X3_ARQUIVO = "ZX4"
		IF X3_CONTEXT <> "V"
			aadd(aEstru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		Endif
		dbSkip()
	Enddo

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("ZX4")

	Do While !eof() .AND. INDICE = "ZX4"
		aadd(aIndex,{INDICE+ORDEM,AllTrim(CHAVE)})
		dbSkip()
	Enddo

	dbSelectArea("ZX4")
	dbCloseArea()

	if !Empty(cNomZX4)
		fErase(cNomZX4+GetDbExtension())
		fErase(cNomZX4+OrdBagExt())
	Endif

	cSql := "SELECT "
	For k=1 to Len(aEstru)
		cSql += AllTrim(aEstru[k,1])+iif(k < Len(aEstru),",","")
	Next
	cSql += " FROM "+RetSqlName("ZX4")+" ZX4"

	If !lVarejo .AND. !lRodas
		cSql += " JOIN "+RetSqlName("SA3")+" SA3"
		cSql += " ON   SA3.D_E_L_E_T_ = ''"
		cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
		cSql += " AND  A3_COD = ZX4_VEND"
		cSql += " AND  A3_REGIAO = '"+cRegiao+"'"
	Endif

	cSql += " WHERE ZX4.D_E_L_E_T_ = ''"
	cSql += " AND   ZX4_FILIAL BETWEEN '' AND 'ZZ'"
	If lVarejo .OR. lRodas
		cSql += " AND   ZX4_AREANE = '"+iif(lVarejo,"V","R")+"'"
	Endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_ZX4", .T., .T.)
	dbSelectArea("ARQ_ZX4")

	For k=1 to Len(aEstru)
		if aEstru[k,2] <> "C"
			TcSetField("ARQ_ZX4",aEstru[k,1],aEstru[k,2],aEstru[k,3],aEstru[k,4])
		Endif
	Next k

	cNomZX4 := CriaTrab(,.F.)
	Copy to &cNomZX4
	dbCloseArea()
	dbUseArea(.T.,,cNomZX4,"ZX4",.F.,.F.)
	
	For k=1 to Len(aIndex)
		Index on &aIndex[k,2] TAG &aIndex[k,1] TO &cNomZX4
	Next k
Return nil

Static Function AbreSA3
	Local cSql   := ""
	Local aEstru := {}
	Local aIndex := {}
	Local k      := 0

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("SA3")
	
	Do While !eof() .AND. X3_ARQUIVO = "SA3"
		IF X3_CONTEXT <> "V"
			aadd(aEstru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		Endif
		dbSkip()
	Enddo

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("SA3")

	Do While !eof() .AND. INDICE = "SA3"
		aadd(aIndex,{INDICE+ORDEM,AllTrim(CHAVE)})
		dbSkip()
	Enddo

	dbSelectArea("SA3")
	dbCloseArea()

	if !Empty(cNomSA3)
		fErase(cNomSA3+GetDbExtension())
		fErase(cNomSA3+OrdBagExt())
	Endif

	cSql := "SELECT "
	For k=1 to Len(aEstru)
		cSql += AllTrim(aEstru[k,1])+iif(k < Len(aEstru),",","")
	Next
	cSql += " FROM "+RetSqlName("SA3")+" SA3"
	cSql += " WHERE SA3.D_E_L_E_T_ = ''"
	cSql += " AND   A3_FILIAL = '"+xFilial("SA3")+"'"
	If !lVarejo .AND. !lRodas
		cSql += " AND   A3_REGIAO = '"+cRegiao+"'"
	Endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SA3", .T., .T.)
	dbSelectArea("ARQ_SA3")

	For k=1 to Len(aEstru)
		if aEstru[k,2] <> "C"
			TcSetField("ARQ_SA3",aEstru[k,1],aEstru[k,2],aEstru[k,3],aEstru[k,4])
		Endif
	Next k

	cNomSA3 := CriaTrab(,.F.)
	Copy to &cNomSA3
	dbCloseArea()
	dbUseArea(.T.,,cNomSA3,"SA3",.F.,.F.)
	
	For k=1 to Len(aIndex)
		Index on &aIndex[k,2] TAG &aIndex[k,1] TO &cNomSA3
	Next k
Return nil

User Function DVLJA03L()
	BrwLegenda(cCadastro,"Legenda", {{ "BR_VERDE","Ativa" },{ "BR_VERMELHO","Inativa" }})
Return nil