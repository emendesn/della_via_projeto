#Include "Dellavia.ch"
// Exame Inicial
User Function DESTA11
	Private aRotina    := {}
	Private aCores     := {}
	Private cCadastro  := "Produção"
	Private cAliasCab  := "SC2"
	Private cAlias     := "SC2"
	Private cNomSIX    := ""
	Private cNomTmp    := ""
	Private aSetField  := {}
	Private cCamposSql := ""
	Private cFiltro    := ""
	Private cPerg      := "DEST11"

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Emissao         ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""          ,"","","","",""           ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate a Emissao      ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""          ,"","","","",""           ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Mostra Op's        ?"," "," ","mv_ch3","N", 01,0,0,"C","","mv_par03","Todas"  ,"","","","","Planejadas","","","","","Em Produçao","","","","",""          ,"","","","","","","","","   ","","","",""          })

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif

	If mv_par03 = 1
		cFiltro := " AND   (C2_X_STATU = ''  Or C2_X_STATU = '1')"
	Elseif mv_par03 = 2
		cFiltro := " AND   (C2_X_STATU = ''  Or C2_X_STATU = '1') AND C2_QUJE = 0 And C2_XPRELOT <> ''"
	Elseif mv_par03 = 3
		cFiltro := " AND   (C2_X_STATU = '4' Or C2_X_STATU = 'T')"
	EndIf	


	// Matriz de definição dos menus
	aAdd(aRotina,{"Pesquisar"    ,"AxPesqui"       ,0,1})
	aAdd(aRotina,{"Visualizar"   ,"A650View"       ,0,2})
	aAdd(aRotina,{"OK"           ,"U_DESTA11A('4')",0,4})
	aAdd(aRotina,{"Recusar"      ,"U_DESTA11A('9')",0,4})
	aAdd(aRotina,{"Terceiro"     ,"U_DESTA11A('T')",0,4})
	aAdd(aRotina,{"Legenda"      ,"U_DESTA11C"     ,0,3})

	Aadd(aCores,{"SC2->C2_X_STATU = '9'"                             ,"BR_PRETO"   }) // Rejeitado
	Aadd(aCores,{"SC2->C2_X_STATU = '6'"                             ,"BR_VERMELHO"}) // Producao
	Aadd(aCores,{"SC2->C2_X_STATU = '1'"                             ,"BR_VERDE"   }) // Inspecao
	Aadd(aCores,{"SC2->C2_X_STATU $ ' 2345' .and. C2_XNUMROD = '  '" ,"BR_AZUL"    }) // Montagem
	Aadd(aCores,{"SC2->C2_X_STATU $ ' 2345' .and. C2_XNUMROD <> '  '","BR_AMARELO" }) // Autoclave
	Aadd(aCores,{".T."                                               ,"BR_BRANCO"  }) // Outros


	//Set Key VK_F12 TO U_DESTA10P()
	AbreDic()
	MsgRun("Consultando banco de dados...",,{ || AbreTmp(.T.) })
	mBrowse(,,,,cAliasCab,,,,,,aCores) // Cria o browse
	//Set Key VK_F12 TO


	// Fecha Temporários
	dbSelectArea(cAliasCab)
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	ChkFile("SC2")
Return nil

Static Function AbreDic()
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	Do While !eof() .and. X3_ARQUIVO = cAlias
		if X3_CONTEXT <> "V"
			cCamposSql += iif(!Empty(cCamposSql),",","")+AllTrim(X3_CAMPO)
			if X3_TIPO $ "N*D"
				aAdd(aSetField,{AllTrim(X3_CAMPO),X3_TIPO,X3_TAMANHO,X3_DECIMAL})
			Endif
		Endif
		dbSkip()
	Enddo
Return nil


Static Function AbreTmp(lSIX)
	Local cSql    := ""
	Local k       := 0

	Default lSix  := .F.

	cSql := "SELECT "+cCamposSql
	cSql += " FROM   "+RetSqlName("SC2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
	cSql += " AND   C2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += cFiltro

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")

	For k=1 to Len(aSetField)
		TcSetField("ARQ_SQL",aSetField[k,1],aSetField[k,2],aSetField[k,3],aSetField[k,4])
	Next k

	if !Empty(cNomTmp)
		dbSelectArea(cAliasCab)
		dbCloseArea()
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
		dbSelectArea("ARQ_SQL")
	Endif

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,cAliasCab,.F.,.F.)

	dbSelectArea("SIX")
	dbSetOrder(1)
	dbSeek(cAlias)
	Do While !eof() .and. INDICE = cAlias
		cChave := AllTrim(CHAVE)
		cTag   := AllTrim(INDICE+ORDEM)

		dbSelectArea(cAliasCab)
		Index on &cChave TAG &cTag TO &cNomTmp

		dbSelectArea("SIX")
		dbSkip()
	Enddo
	dbSelectArea(cAlias)
	dbSetOrder(1)
Return nil

User Function DESTA11A(cStatus)
	Local cChave := ""
	Local lDel   := .F.
	Local nRecTmp := Recno()

	U_DESTV02(SC2->C2_FILIAL,SC2->C2_SERIED1,SC2->C2_NUMD1,"ZZ7_INICIA = 'S'")

	if A650View("SC2",Recno(),2) = 1
		dbSelectArea("SC2")
		cChave := C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
		dbCloseArea() // Fecha temporário
		
		ChkFile("SC2") // Abre Original
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(cChave)

		If cStatus $ "4*T"
			lDel := DESTA11L(cStatus)
		Elseif cStatus = "9"
			lDel := DESTA11R()
		Endif

		dbSelectArea("SC2")
		dbCloseArea() // Fecha Original

		// Reabre temporário
		dbUseArea(.T.,,cNomTmp,cAliasCab,.F.,.F.)
		Set Index to &cNomTmp
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbGoTo(nRecTmp)
		If lDel
			If RecLock(cAlias,.F.)
				dbDelete()
				MsUnLock()
			Endif
		Endif
	Endif
Return nil

Static Function DESTA11L(cVar)
	if RecLock("SC2",.F.)
		SC2->C2_X_STATU := cVar
		SC2->( MsUnLock() )
	Endif
	If RecLock("ZD3",.T.)    
		ZD3->ZD3_Filial := SC2->C2_Filial
		ZD3->ZD3_NumOP	:= SC2->C2_Num
		ZD3->ZD3_ItOP	:= SC2->C2_Item
		ZD3->ZD3_TM		:= cVar
		ZD3->ZD3_XDESC	:= "EXAME INICIAL"
		ZD3->ZD3_EMISSA := dDataBase
		ZD3->ZD3_HORA	:= time()   
		ZD3->( MsUnLock() )
	Endif

Return .T.

Static Function DESTA11R()
	Local   aRegSD3     := {}
	Local   cMotivo     := Space(2)
	Local   cDescMot    := Space(40)
	Local   lRet        := .F.
	Local   oDlgMot
	Local   oGetMot
	Local   oGetDes
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.

	If !Empty(SC2->C2_X_STATU) .And. !(SC2->C2_X_STATU $ "1*4*T")
		MsgStop("Esta OP nao esta com status para Rejeicao.")
		Return lRet
	EndIf

	If MsgYesNo("Confirma a Rejeicao da OP ?")
		DEFINE MSDIALOG oDlgMot TITLE OemToAnsi("Motivo da Rejeicao") From 12,10 To 17,70 OF oMainWnd
		@ 5,08 SAY "Motivo da Rejeicao" PIXEL OF oDlgMot SIZE 70,7
		@ 5,60 MSGET oGetMot VAR cMotivo  PICTURE "@!" VALID VldMot(cMotivo,@cDescMot,@oGetDes) F3 "43" PIXEL OF oDlgMot SIZE 20,7
		@ 5,91 MSGET oGetDes VAR cDescMot PICTURE "@!" WHEN .F. PIXEL OF oDlgMot SIZE 138,7
		DEFINE SBUTTON FROM 22,106 TYPE 1 ACTION oDlgMot:End() ENABLE OF oDlgMot
		ACTIVATE MSDIALOG oDlgMot CENTERED VALID VldMot(cMotivo,@cDescMot,@oGetDes)

		//-- Inclusao.
		Aadd( aRegSD3, { "D3_FILIAL" , xFilial("SD3")                       , NIL } )
		Aadd( aRegSD3, { "D3_TM"     , "509"                                , NIL } )
		Aadd( aRegSD3, { "D3_COD"    , SC2->C2_PRODUTO                      , NIL } )
		Aadd( aRegSD3, { "D3_UM"     , SC2->C2_UM                           , NIL } )
		Aadd( aRegSD3, { "D3_QUANT"  , SC2->C2_QUANT                        , NIL } )
		Aadd( aRegSD3, { "D3_PERDA"  , SC2->C2_QUANT                        , NIL } )
		Aadd( aRegSD3, { "D3_OP"     , SC2->( C2_NUM + C2_ITEM + C2_SEQUEN ), NIL } )
		Aadd( aRegSD3, { "D3_CF"     , "RE0"                                , NIL } )
		Aadd( aRegSD3, { "D3_LOCAL"  , SC2->C2_LOCAL                        , NIL } ) 
		Aadd( aRegSD3, { "D3_X_ARMZ" , SC2->C2_LOCAL                        , NIL } ) 
		Aadd( aRegSD3, { "D3_DOC"    , SC2->C2_NUM                          , NIL } )  
		Aadd( aRegSD3, { "D3_XDESC"  , "RECUSADO EXAME INICIAL"     , NIL } )  
		Aadd( aRegSD3, { "D3_EMISSAO", dDataBase                            , NIL } )
		Aadd( aRegSD3, { "D3_GRUPO"  , SC2->C2_GRUPO                        , NIL } )
		Aadd( aRegSD3, { "D3_SEGUM"  , SC2->C2_SEGUM                        , NIL } )
		Aadd( aRegSD3, { "D3_QTSEGUM", SC2->C2_QTSEGUM                      , NIL } )
		Aadd( aRegSD3, { "D3_USUARIO", SubStr( cUsuario, 7, 15 )            , NIL } )
		Aadd( aRegSD3, { "D3_HORA", TIME()            , NIL } )

        VerSaldo()

        MsExecAuto( { |x, y| Mata240( x, y ) }, aRegSD3, 3 )
		//-- Verifica se houve algum erro.
		If lMsErroAuto
			If Aviso( "Pergunta", "Producao nao Recusada. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
				MostraErro()
			EndIf
		Else
			RecLock("SC2",.F.)
			SC2->C2_X_STATU := "9"
			SC2->C2_PERDA   := SC2->C2_QUANT
			SC2->C2_MOTREJE := cMotivo
			SC2->( MsUnLock() )   
			lRet := .T.
		EndIf
	EndIf
Return lRet

Static Function VldMot(cMotivo,cDescMot,oGetDes)
	Local lRet := .T.

	If Empty(cMotivo)
		MsgStop("Motivo da rejeicao deve ser informado.")
		lRet := .F.
	Else
		lRet := ExistCpo("SX5","43"+cMotivo)
		cDescMot := Tabela("43",cMotivo,.F.)
		oGetDes:Refresh()
	Endif
Return(lRet)

Static Function VerSaldo()
		
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+SC2->C2_PRODUTO+'01')     
	if .not.found() .and. RecLock("SB2",.T.)
		SB2->B2_Filial := xFilial("SB2")
		SB2->B2_Cod    := SC2->C2_PRODUTO   
		SB2->B2_Local  := '01'
		MsUnLock()
	endif
	dbSelectArea("SB9")    
	dbSetOrder(1)
	dbSeek(xFilial("SB9")+SC2->C2_PRODUTO+'01')
	if .not.found() .and. RecLock("SB9",.T.)
		SB9->B9_Filial := xFilial("SB9")
		SB9->B9_Cod    := SC2->C2_PRODUTO
		SB9->B9_Local  := '01'
		MsUnLock()
	endif         
	dbSelectArea("SB2")
	If SB2->B2_QATU < 1
		If RecLock("SB2",.F.)
			SB2->B2_QATU    := 1
			SB2->B2_VATU1   := 10
			SB2->B2_CM1     := 10  
			SB2->B2_QNPT    := 0   
			SB2->B2_QTNP    := 0     
			SB2->B2_RESERVA := 0
			MsUnLock()
		Endif
	Else
		If RecLock("SB2",.F.)
			SB2->B2_QNPT    := 0
			SB2->B2_QTNP	:= 0
			SB2->B2_RESERVA := 0
			MsUnLock()
		Endif
	Endif
		 
Return nil

User Function DESTA11C()
	BrwLegenda("Legenda",cCadastro,{{"BR_VERDE"   ,"Inspecao " },;
    	                            {"BR_AZUL"    ,"Producao " },;
        	                        {"BR_AMARELO" ,"Autoclave"},;
            	                    {"BR_VERMELHO","Liberado " },;
                	                {"BR_PRETO"   ,"Recusado "}})
Return Nil