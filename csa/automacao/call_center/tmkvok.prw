#include "DellaVia.ch"

User Function TMKVOK
	Local aArea   := GetArea()
	Local lDescon := .F.

	if M->UA_OPER = "2"
		dbSelectArea("SUB")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(SUA->(UA_FILIAL+UA_NUM))

		Do While !eof() .and. UB_FILIAL = SUA->UA_FILIAL .AND. UB_NUM = SUA->UA_NUM
			if UB_DESC > SU7->U7_DVDESC
				if ALTERA
					If !VldItens()
						lDescon := .T.
						exit
					Endif
				Else
					lDescon := .T.
					exit
				Endif
			Endif
			dbSkip()
		Enddo

		if lDescon
			U_GetDesc()
		Endif
	Endif

	RestArea(aArea)
Return nil

User Function GetDesc()
	Local   cSql     := ""
	Local   k        := 0
	Local   lFaz     := .F.
	Private aRotina  := {}
	Private nOpc     := 4
	Private aHeader  := {}
	Private aCols    := {}
	Private aAlter   := {}
	Private aEstru   := {}
	Private nTotMerc := 0
	Private nTotDesc := 0
	Private n := 1


	dbSelectArea("ZX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(SUA->(UA_FILIAL+UA_NUM))
	if Found()
		lFaz := msgbox("Este orçamento ja possui uma solicitação de descontos. Deseja enviar outra?","Descontos","YESNO")
		
		if lFaz
			cSql := "SELECT ZX2_NUM FROM ZX2010 WHERE D_E_L_E_T_ = '' AND ZX2_FILIAL = '"+SUA->UA_FILIAL+"' AND ZX2_ORC = '"+SUA->UA_NUM+"' AND ZX2_STATUS IN('1','5')"
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
			dbSelectArea("ARQ_SQL")
			lAchou := !Eof()
			dbCloseArea()
			dbSelectArea("ZX2")

			if lAchou
				lFaz := .F.
				msgbox("Este orçamento não pode ser re-enviado pois, seu status é diferente de Recusado ou Cancelado","Descontos","STOP")
			Endif
		Endif

		if !lFaz
			dbSelectArea("SUB")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(SUA->(UA_FILIAL+UA_NUM))
			nTotMerc := 0
			nTotDesc := 0

			Do While !eof() .and. UB_FILIAL = SUA->UA_FILIAL .AND. UB_NUM = SUA->UA_NUM
				if UB_DESC > SU7->U7_DVDESC
					If RecLock("SUB",.F.)
						SUB->UB_VRUNIT  := SUB->UB_PRCTAB
						SUB->UB_VLRITEM := SUB->UB_PRCTAB*SUB->UB_QUANT
						SUB->UB_DESC    := 0
						SUB->UB_VALDESC := 0
						MsUnlock()
						nTotMerc += SUB->UB_PRCTAB*SUB->UB_QUANT
					Endif
				Else
					nTotMerc += SUB->UB_PRCTAB*SUB->UB_QUANT
					nTotDesc += SUB->UB_VALDESC
				Endif
				dbSkip()
			Enddo

			dbSelectArea("SUA")
			if RecLock("SUA",.F.)
				SUA->UA_VALBRUT := nTotMerc
				SUA->UA_VLRLIQ  := nTotMerc
				SUA->UA_VALMERC := nTotMerc
				SUA->UA_ENTRADA := nTotMerc
				SUA->UA_DESCONT := 0 //nTotDesc
				MsUnlock()
			Endif

			Return nil
			/*
		Else
			// De - Para
			cSql := "UPDATE "+RetSqlName("ZX2")
			cSql += " SET  ZX2_STATUS = '4'"
			cSql += " WHERE D_E_L_E_T_ = ''"
			cSql += " AND   ZX2_FILIAL = '"+SUA->UA_FILIAL+"'"
			cSql += " AND   ZX2_NUM IN(SELECT ZX2_NUM"
			cSql += "                  FROM "+RetSqlName("ZX2")
			cSql += "                  WHERE D_E_L_E_T_ = ''"
			cSql += "                  AND   ZX2_FILIAL = '"+SUA->UA_FILIAL+"'"
			cSql += "                  AND   ZX2_ORC = '"+SUA->UA_NUM+"'"
			cSql += "                  ORDER BY ZX2_NUM DESC"
			cSql += "                  FETCH FIRST 1 ROW ONLY)"

			nUpdt := 0
			MsgRun("Limpando aprovação de descontos ...",,{|| nUpdt := TcSqlExec(cSql)})

			If nUpdt < 0
				MsgBox(TcSqlError(),"Descontos","STOP")
			Endif
			*/
		Endif
	Endif

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5})

	// Monta estrutura do temporario
	aadd(aEstru,{"UB_ITEM"    ,"C",02,0})
	aadd(aEstru,{"UB_PRODUTO" ,"C",15,0})
	aadd(aEstru,{"B1_DESC"    ,"C",30,0})
	aadd(aEstru,{"UB_QUANT"   ,"N",14,2})
	aadd(aEstru,{"UB_PRCTAB"  ,"N",14,2})
	aadd(aEstru,{"UB_PDESC"   ,"N",06,2})
	aadd(aEstru,{"UB_VDESC"   ,"N",14,2})
	aadd(aEstru,{"UB_VRUNIT"  ,"N",14,2})
	aadd(aEstru,{"UB_VLRITEM" ,"N",14,2})
	aadd(aEstru,{"UB_OBSITM"  ,"C",50,0})


	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"UB_ITEM",,.t.,"Selecionando Registros...")

	nTotMerc := 0
	nTotDesc := 0

	dbSelectArea("SUB")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(SUA->(UA_FILIAL+UA_NUM))
	Do While !eof() .and. UB_FILIAL = SUA->UA_FILIAL .AND. UB_NUM = SUA->UA_NUM
		if UB_DESC <= SU7->U7_DVDESC
			nTotMerc += SUB->UB_PRCTAB*SUB->UB_QUANT
			nTotDesc += SUB->UB_VALDESC

			dbSkip()
			Loop
		Endif

		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			For k=1 To Len(aEstru)
				cCpo := AllTrim(aEstru[k,1])
				If cCpo = "B1_DESC"
					TMP->B1_DESC := Posicione("SB1",1,xFilial("SB1")+TMP->UB_PRODUTO,"SB1->B1_DESC")
				Elseif cCpo = "UB_PDESC"
					TMP->UB_PDESC := SUB->UB_DESC
				Elseif cCpo = "UB_VDESC"
					TMP->UB_VDESC := SUB->UB_VALDESC
				Elseif ! (AllTrim(cCpo) $ "UB_OBSITM")
					&cCpo := SUB->( &cCpo )
				Endif
			Next k
			MsUnLock()
		Endif
		dbSelectArea("TMP")
		aAdd(aCols,{UB_ITEM,UB_PRODUTO,B1_DESC,UB_QUANT,UB_PRCTAB,UB_PDESC,UB_VDESC,UB_VRUNIT,UB_VLRITEM,UB_OBSITM,.F.})

		dbSelectArea("SUB")
		If RecLock("SUB",.F.)
			SUB->UB_VRUNIT  := SUB->UB_PRCTAB
			SUB->UB_VLRITEM := SUB->UB_PRCTAB*SUB->UB_QUANT
			SUB->UB_DESC    := 0
			SUB->UB_VALDESC := 0
			nTotMerc += SUB->UB_PRCTAB*SUB->UB_QUANT
			MsUnlock()
		Endif
		dbskip()
	Enddo

	dbSelectArea("SUA")
	if RecLock("SUA",.F.)
		SUA->UA_VALBRUT := nTotMerc
		SUA->UA_VLRLIQ  := nTotMerc
		SUA->UA_VALMERC := nTotMerc
		SUA->UA_ENTRADA := nTotMerc
		SUA->UA_DESCONT := 0 //nTotDesc
		MsUnlock()
	Endif


	dbSelectArea("TMP")
	dbGoTop()


	aAdd(aHeader,{"Item"        ,"UB_ITEM"    ,"@!"               ,02,0,                         ,,"C",,})
	aAdd(aHeader,{"Codigo"      ,"UB_PRODUTO" ,"@!"               ,15,0,                         ,,"C",,})
	aAdd(aHeader,{"Descrição"   ,"B1_DESC"    ,"@!"               ,30,0,                         ,,"C",,})
	aAdd(aHeader,{"Quantidade"  ,"UB_QUANT"   ,"@E 999,999,999.99",14,2,                         ,,"N",,})
	aAdd(aHeader,{"Prc Tabela"  ,"UB_PRCTAB"  ,"@E 999,999,999.99",14,2,                         ,,"N",,})
	aAdd(aHeader,{"% Desconto"  ,"UB_PDESC"   ,"@E 999.99"        ,06,2,"U_TMKVOKP(M->UB_PDESC)" ,,"N",,})
	aAdd(aHeader,{"Vlr Desconto","UB_VDESC"   ,"@E 999,999,999.99",14,2,"U_TMKVOKVL(M->UB_VDESC)",,"N",,})
	aAdd(aHeader,{"Vlr Unitario","UB_VRUNIT"  ,"@E 999,999,999.99",14,2,                         ,,"N",,})
	aAdd(aHeader,{"Total"       ,"UB_VLRITEM" ,"@E 999,999,999.99",14,2,                         ,,"N",,})
	aAdd(aHeader,{"Observação"  ,"UB_OBSITM"  ,"@!"               ,50,0,                         ,,"C",,})

	aAdd(aAlter,"UB_PDESC" )
	aAdd(aAlter,"UB_VDESC" )
	aAdd(aAlter,"UB_OBSITM")

	@ 000,000 TO 350,700 DIALOG oDlgDesc TITLE "Solicitação de descontos"
	oPanel := TPanel():New(0,0,"",oDlgDesc, oDlgDesc:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 015,003 SCROLLBOX oScr SIZE 080,347 OF oDlgDesc
	oGetDesc := MSGetDados():New(000,000,078,345,nOpc,"U_TMKVOKOB(.F.)",,,.F.,aAlter,,,Len(aCols),,,,, oScr)

	cObs := ""
	@ 100,003 SCROLLBOX oScr01 SIZE 070,347 OF oDlgDesc
	@ 003,003 SAY "Observação Geral:" PIXEL OF oScr01 SIZE 50,7
	@ 002,050 MEMO cObs PIXEL OF oScr01 SIZE 130,60 NO VSCROLL

	@ 003,190 SAY "Operador:" PIXEL OF oScr01 SIZE 40,7
	@ 002,240 GET M->UA_DESCOPE PIXEL OF oScr01 SIZE 100,7 WHEN .F.

	cNomSup := Posicione("SU7",1,xFilial("SU7")+Posicione("SU7",1,xFilial("SU7")+M->UA_OPERADO,"SU7->U7_CODSUP"),"SU7->U7_NOME")
	Posicione("SU7",1,xFilial("SU7")+M->UA_OPERADO,"SU7->U7_CODSUP")
	@ 014,190 SAY "Supervisor:" PIXEL OF oScr01 SIZE 40,7
	@ 013,240 GET cNomSup PIXEL OF oScr01 SIZE 100,7 WHEN .F.

	@ 025,190 SAY "Orçamento:" PIXEL OF oScr01 SIZE 40,7
	@ 024,240 GET M->UA_NUM  PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	oDlgDesc:lMaximized := .F.
	ACTIVATE DIALOG oDlgDesc CENTER ON INIT EnchoiceBar(oDlgDesc,{|| Fechar(1) },{|| Fechar(2) }) VALID U_TMKVOKOB(.T.) .AND. !Empty(cObs)

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())
Return nil

User Function TMKVOKP(nPDesc)
	Local lRet   := .T.
	
	If nPDesc >= 0 .AND. nPDesc <= 100
		aCols[n,7] := (aCols[n,5]*aCols[n,4])*(nPDesc/100)
		aCols[n,8] := aCols[n,5]*((100-nPDesc)/100)
		aCols[n,9] := (aCols[n,5]*((100-nPDesc)/100))*aCols[n,4]
	Else
		lRet := .F.
	Endif
Return lRet

User Function TMKVOKVL(nVDesc)
	Local lRet   := .T.
	
	If nVDesc >= 0 .AND. nVDesc <= (aCols[n,5]*aCols[n,4])
		aCols[n,6] := (nVDesc/(aCols[n,5]*aCols[n,4]))*100
		aCols[n,8] := ((aCols[n,5]*aCols[n,4])-nVDesc)/aCols[n,4]
		aCols[n,9] := (aCols[n,5]*aCols[n,4])-nVDesc
	Else
		lRet := .F.
	Endif
Return lRet

Static Function Fechar(nAct)
	Local jj       := 0
	Local k        := 0
	Local cCodMemo := ""

	If nAct = 1
		if eVal(oDlgDesc:bValid)
			cNumSol := GetSxeNum("ZX2","ZX2_NUM")
			dbSelectArea("ZX2")
			For k=1 to Len(aCols)
				If aCols[k,6] <= 0
					Loop
				Endif
		
				For jj=1 to 2
					cOperTmp := iif(jj=1,M->UA_OPERADO,Posicione("SU7",1,xFilial("SU7")+M->UA_OPERADO,"SU7->U7_CODSUP"))
					If RecLock("ZX2",.T.)
						ZX2->ZX2_FILIAL := xFilial("ZX2")
						ZX2->ZX2_ORC    := M->UA_NUM
						ZX2->ZX2_NUM    := cNumSol
						ZX2->ZX2_ITEM   := aCols[k,1]
						ZX2->ZX2_SEQ    := iif(jj=1,"01","02")
						ZX2->ZX2_COD    := aCols[k,2]
						ZX2->ZX2_QUANT  := aCols[k,4]
						ZX2->ZX2_PRCTAB := aCols[k,5]
						ZX2->ZX2_PDESC  := aCols[k,6]
						ZX2->ZX2_VDESC  := aCols[k,7]
						ZX2->ZX2_VRUNIT := aCols[k,8]
						ZX2->ZX2_TOTAL  := aCols[k,9]
						ZX2->ZX2_OBS    := aCols[k,10]
						If jj > 1
							ZX2->ZX2_OBSGER := cCodMemo
						Endif
						ZX2->ZX2_OPER   := cOperTmp
						ZX2->ZX2_DATSOL := dDataBase
						ZX2->ZX2_HORSOL := Time()
						ZX2->ZX2_STATUS := iif(jj=1,"5","1")
						ZX2->ZX2_TIPO   := iif(jj=1,"S","L")
						ZX2->ZX2_CONDPG := M->UA_CONDPG
						ZX2->ZX2_TABELA := M->UA_TABELA
						ZX2->ZX2_TIPVND := M->UA_TIPOVND
						MsUnLock()
						If jj = 1
							cCodMemo := MSMM(,,,cObs,1,,,"ZX2","ZX2_OBSGER") // Grava
						Endif
						dbSelectArea("ZX2")
					Endif
				Next jj
			Next k
			ConfirmSX8()
			// U_DVTMKF01(cOperTmp,M->UA_NUM,cNumSol)
			Close(oDlgDesc)
		Endif
	Elseif nAct = 2
		if msgbox("Deseja realmente cancelar a solicitação de descontos?","Descontos","YESNO")
			Close(oDlgDesc)
		Endif
	Endif
Return nil

User Function TMKVOKOB(lTodos)
	Local lRet := .F.
	Local L    := 0

	if lTodos
		For L=1 to Len(aCols)
			lRet := !(Empty(aCols[L,10]) .AND. aCols[L,06] > 0)
			If !lRet
				exit
			Endif
		Next L
	Else
		lRet := !(Empty(aCols[n,10]) .AND. aCols[n,06] > 0)
	Endif

	if !lRet
		Help("",1,"OBRIGAT2")
	Endif
Return lRet

Static Function VldItens()
	Local aArea  := GetArea()
	Local lRet   := .T.
	Local nAprov := 0
	Local nQuant := 0
	Local cCod   := ""
	
	cSql := "SELECT ZX2_PDESC,ZX2_COD,ZX2_QUANT FROM "+RetSqlName("ZX2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZX2_FILIAL = '"+SUA->UA_FILIAL+"'"
	cSql += " AND   ZX2_ORC = '"+SUA->UA_NUM+"'"
	cSql += " AND   ZX2_ITEM = '"+SUB->UB_ITEM+"'"
	cSql += " AND   ZX2_STATUS = '2'"
	cSql += " AND   ZX2_CONDPG = '"+SUA->UA_CONDPG+"'"
	cSql += " AND   ZX2_TABELA = '"+SUA->UA_TABELA+"'"
	cSql += " AND   ZX2_TIPVND = '"+SUA->UA_TIPOVND+"'"
	cSql += " ORDER BY ZX2_NUM DESC,ZX2_SEQ DESC"
	cSql += " FETCH FIRST 1 ROW ONLY"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","ZX2_PDESC","C",14,2)
	TcSetField("ARQ_SQL","ZX2_QUANT","C",14,2)

	nAprov := 0
	nQuant := 0
	cCod   := ""
	if !Eof()
		nAprov := ZX2_PDESC
		nQuant := ZX2_QUANT
		cCod   := ZX2_COD
	Endif
	dbCloseArea()

	If SUB->UB_DESC <> nAprov .OR. SUB->UB_PRODUTO <> cCod .OR. SUB->UB_QUANT <> nQuant
		msgbox("Os dados do orçamento estão diferentes do aprovado","Desconto","STOP")
		lRet := .F.
	Endif

	RestArea(aArea)
Return lRet