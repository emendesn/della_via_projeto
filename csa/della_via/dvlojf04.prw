#include "DellaVia.ch"

User Function DVLOJF04(aHeadRec,aColsRec,nTipo)
	Local   aArea     := GetArea()
	Local   nDescLoja := 0
	Local   lRet      := .T.
	Local   lDesconto := .F.
	Private cChDesc   := ""
	Private aColsOrc  := aClone(aColsRec)
	Private nCpoItem  := aScan(aHeadRec,{|x| AllTrim(x[2]) == AllTrim("LR_ITEM")    })
	Private nCpoProd  := aScan(aHeadRec,{|x| AllTrim(x[2]) == AllTrim("LR_PRODUTO") })
	Private nCpoDesc  := aScan(aHeadRec,{|x| AllTrim(x[2]) == AllTrim("LR_DESC")    })
	Private nCpoQtde  := aScan(aHeadRec,{|x| AllTrim(x[2]) == AllTrim("LR_QUANT")   })
	Private nCpoVDes  := aScan(aHeadRec,{|x| AllTrim(x[2]) == AllTrim("LR_VALDESC") })
	Private nCpoVrUn  := aScan(aHeadRec,{|x| AllTrim(x[2]) == AllTrim("LR_VRUNIT")  })
	Private nCpoVrIt  := aScan(aHeadRec,{|x| AllTrim(x[2]) == AllTrim("LR_VLRITEM") })

	// Liminte de desconto da loja
	dbSelectArea("PAN")
	dbSetOrder(1)
	dbSeek(xFilial("PAN")+xFilial("SLQ"))
	nDescLoja := iif(Found(),PAN->PAN_DVDESC,0)

	For k=1 To Len(aColsOrc)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aColsOrc[k,nCpoProd])

		dbSelectArea("PAO")
		dbSetOrder(1)
		dbSeek(xFilial("PAO")+xFilial("SLQ")+SB1->B1_GRUPO)

		If Found()
			If (aColsOrc[k,nCpoDesc] > PAO->PAO_DVDESC)
				cChDesc += aColsOrc[k,nCpoItem]+"*"
			Endif
		Else
			If (aColsOrc[k,nCpoDesc] > nDescLoja)
				cChDesc += aColsOrc[k,nCpoItem]+"*"
			Endif
		Endif
	Next k


    For k=1 to Len(aColsOrc)
		If aColsOrc[k,nCpoItem] $ cChDesc .AND. !VldItens(aColsOrc[k,nCpoItem],aColsOrc[k,nCpoProd],Round(aColsOrc[k,nCpoDesc],2),aColsOrc[k,nCpoQtde])
			lDesconto := .T.
			Exit
		Endif
	Next k

	if lDesconto
		if nTipo = 1
			if M->LQ_CLIENTE <> GetMV("MV_CLIPAD") // Venda para cliente padrao
				lRet := LojaDesc()
			Else
				lRet := .F.
				Aviso("Aviso","Não é possivél submeter descontos para o cliente padrão.",{"Ok"})
			Endif
		Else
			lRet := .F.
			Aviso("Aviso","Não é possivél finalizar venda, primeiro os descontos devem ser submetidos a aprovação.",{"Ok"})
		Endif
	Endif

	RestArea(aArea)
Return lRet

Static Function LojaDesc()
	Local   cSql     := ""
	Local   k        := 0
	Local   lFaz     := .T.
	Local   lRet     := .F.
	Private aRotina  := {}
	Private nOpc     := 4
	Private aHeader  := {}
	Private aCols    := {}
	Private aAlter   := {}
	Private aEstru   := {}
	Private nTotMerc := 0
	Private nTotDesc := 0
	Private n := 1

	dbSelectArea("ZXA")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SLQ")+M->LQ_NUM)

	if Found()
		lFaz := msgbox("Este orçamento ja possui uma solicitação de descontos. Deseja enviar outra?","Descontos","YESNO")
		
		if lFaz
			cSql := "SELECT ZXA_NUM FROM "+RetSqlName("ZXA")+" WHERE D_E_L_E_T_ = '' AND ZXA_FILIAL = '"+xFilial("SLQ")+"' AND ZXA_ORC = '"+M->LQ_NUM+"' AND ZXA_STATUS IN('1','5')"
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
			dbSelectArea("ARQ_SQL")
			lAchou := !Eof()
			dbCloseArea()
			dbSelectArea("ZXA")

			if lAchou
				lFaz := .F.
				msgbox("Este orçamento não pode ser re-enviado pois, seu status é diferente de Recusado ou Cancelado","Descontos","STOP")
			Endif
		Endif
	Endif

	If !lFaz
		Return .F.
	Endif

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5})

	// Monta estrutura do temporario
	aadd(aEstru,{"LR_ITEM"    ,"C",02,0})
	aadd(aEstru,{"LR_PRODUTO" ,"C",15,0})
	aadd(aEstru,{"B1_DESC"    ,"C",30,0})
	aadd(aEstru,{"LR_QUANT"   ,"N",14,2})
	aadd(aEstru,{"LR_PRCTAB"  ,"N",14,2})
	aadd(aEstru,{"LR_PDESC"   ,"N",06,2})
	aadd(aEstru,{"LR_VDESC"   ,"N",14,2})
	aadd(aEstru,{"LR_VRUNIT"  ,"N",14,2})
	aadd(aEstru,{"LR_VLRITEM" ,"N",14,2})
	aadd(aEstru,{"LR_OBSITM"  ,"C",50,0})


	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"LR_ITEM",,.t.,"Selecionando Registros...")

	nTotMerc := 0
	nTotDesc := 0

	cDescFlag := "1"

	For k=1 to Len(aColsOrc)
		if !(aColsOrc[k,nCpoItem] $ cChDesc)
			nTotMerc += SLR->LR_PRCTAB*SLR->LR_QUANT
			nTotDesc += SLR->LR_VALDESC
			Loop
		Endif

		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			TMP->LR_ITEM    := aColsOrc[k,nCpoItem]
			TMP->LR_PRODUTO := aColsOrc[k,nCpoProd]
			TMP->B1_DESC    := Posicione("SB1",1,xFilial("SB1")+TMP->LR_PRODUTO,"SB1->B1_DESC")
			TMP->LR_QUANT   := aColsOrc[k,nCpoQtde]
			TMP->LR_PDESC   := aColsOrc[k,nCpoDesc]
			TMP->LR_VDESC   := aColsOrc[k,nCpoVDes]
			TMP->LR_VRUNIT  := aColsOrc[k,nCpoVrUn]
			TMP->LR_PRCTAB  := TMP->LR_VRUNIT+TMP->LR_VDESC
			TMP->LR_VLRITEM := aColsOrc[k,nCpoVrIt]
			MsUnLock()
		Endif
		dbSelectArea("TMP")
		aAdd(aCols,{LR_ITEM,LR_PRODUTO,B1_DESC,LR_QUANT,LR_PRCTAB,LR_PDESC,LR_VDESC,LR_VRUNIT,LR_VLRITEM,LR_OBSITM,.F.})
	Next k

	dbSelectArea("TMP")
	dbGoTop()

	aAdd(aHeader,{"Item"        ,"LR_ITEM"    ,"@!"               ,02,0,,,"C",,})
	aAdd(aHeader,{"Codigo"      ,"LR_PRODUTO" ,"@!"               ,15,0,,,"C",,})
	aAdd(aHeader,{"Descrição"   ,"B1_DESC"    ,"@!"               ,30,0,,,"C",,})
	aAdd(aHeader,{"Quantidade"  ,"LR_QUANT"   ,"@E 999,999,999.99",14,2,,,"N",,})
	aAdd(aHeader,{"Prc Tabela"  ,"LR_PRCTAB"  ,"@E 999,999,999.99",14,2,,,"N",,})
	aAdd(aHeader,{"% Desconto"  ,"LR_PDESC"   ,"@E 999.99"        ,06,2,,,"N",,})
	aAdd(aHeader,{"Vlr Desconto","LR_VDESC"   ,"@E 999,999,999.99",14,2,,,"N",,})
	aAdd(aHeader,{"Vlr Unitario","LR_VRUNIT"  ,"@E 999,999,999.99",14,2,,,"N",,})
	aAdd(aHeader,{"Total"       ,"LR_VLRITEM" ,"@E 999,999,999.99",14,2,,,"N",,})
	aAdd(aHeader,{"Observação"  ,"LR_OBSITM"  ,"@!"               ,50,0,,,"C",,})

	aAdd(aAlter,"LR_OBSITM")

	@ 000,000 TO 350,700 DIALOG oDlgDesc TITLE "Solicitação de descontos"
	oPanel := TPanel():New(0,0,"",oDlgDesc, oDlgDesc:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 015,003 SCROLLBOX oScr SIZE 080,347 OF oDlgDesc
	oGetDesc := MSGetDados():New(000,000,078,345,nOpc,"!Empty(aCols[n,10])",,,.F.,aAlter,,,Len(aCols),,,,, oScr)

	cObs := ""
	@ 100,003 SCROLLBOX oScr01 SIZE 070,347 OF oDlgDesc
	@ 003,003 SAY "Observação Geral:" PIXEL OF oScr01 SIZE 50,7
	@ 002,050 MEMO cObs PIXEL OF oScr01 SIZE 130,60 NO VSCROLL

	@ 003,190 SAY "Orçamento:" PIXEL OF oScr01 SIZE 40,7
	@ 002,240 GET M->LQ_NUM  PIXEL OF oScr01 SIZE 30,7 WHEN .F.

	oDlgDesc:lMaximized := .F.
	ACTIVATE DIALOG oDlgDesc CENTER ON INIT EnchoiceBar(oDlgDesc,{|| lRet := Fechar(1) },{|| lRet := Fechar(2) }) VALID !Empty(cObs) .AND. VLDDLG()

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())
Return lRet

Static Function Fechar(nAct)
	Local jj       := 0
	Local k        := 0
	Local cCodMemo := ""
	Local lRet     := .T.

	If nAct = 1
		if eVal(oDlgDesc:bValid)
			cNumSol := GetSxeNum("ZXA","ZXA_NUM")
			dbSelectArea("ZXA")
			For k=1 to Len(aCols)
				If RecLock("ZXA",.T.)
					ZXA->ZXA_FILIAL := xFilial("ZXA")
					ZXA->ZXA_ORC    := M->LQ_NUM
					ZXA->ZXA_NUM    := cNumSol
					ZXA->ZXA_ITEM   := aCols[k,1]
					ZXA->ZXA_SEQ    := iif(jj=1,"01","02")
					ZXA->ZXA_COD    := aCols[k,2]
					ZXA->ZXA_QUANT  := aCols[k,4]
					ZXA->ZXA_PRCTAB := aCols[k,5]
					ZXA->ZXA_PDESC  := aCols[k,6]
					ZXA->ZXA_VDESC  := aCols[k,7]
					ZXA->ZXA_VRUNIT := aCols[k,8]
					ZXA->ZXA_TOTAL  := aCols[k,9]
					ZXA->ZXA_OBS    := aCols[k,10]
					ZXA->ZXA_DATSOL := dDataBase
					ZXA->ZXA_HORSOL := Time()
					ZXA->ZXA_STATUS := "1"
					ZXA->ZXA_CONDPG := M->LQ_CONDPG
					ZXA->ZXA_TABELA := M->LQ_CODTAB
					ZXA->ZXA_CODCLI := M->LQ_CLIENTE
					ZXA->ZXA_LOJA   := M->LQ_LOJA
					MsUnLock()
					cCodMemo := MSMM(,,,cObs,1,,,"ZXA","ZXA_OBSGER") // Grava
				Endif
				dbSelectArea("ZXA")
			Next k
			ConfirmSX8()
			Close(oDlgDesc)
		Endif
	Elseif nAct = 2
		Close(oDlgDesc)
		lRet := .F.
	Endif
Return lRet

Static Function VldItens(cParItem,cParProd,nParDesc,nParQuant)
	Local aArea  := GetArea()
	Local lRet   := .T.
	Local nAprov := 0
	Local nQuant := 0
	Local cCod   := ""
	
	cSql := "SELECT ZXA_PDESC,ZXA_COD,ZXA_QUANT FROM "+RetSqlName("ZXA")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZXA_FILIAL = '"+xFilial("SLQ")+"'"
	cSql += " AND   ZXA_ORC = '"+M->LQ_NUM+"'"
	cSql += " AND   ZXA_ITEM = '"+cParItem+"'"
	cSql += " AND   ZXA_STATUS = '2'"
	cSql += " AND   ZXA_CONDPG = '"+M->LQ_CONDPG+"'"
	cSql += " AND   ZXA_TABELA = '"+M->LQ_CODTAB+"'"
	cSql += " AND   ZXA_CODCLI = '"+M->LQ_CLIENTE+"'"
	cSql += " AND   ZXA_LOJA   = '"+M->LQ_LOJA+"'"
	cSql += " ORDER BY ZXA_NUM DESC,ZXA_SEQ DESC"
	cSql += " FETCH FIRST 1 ROW ONLY"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","ZXA_PDESC","C",14,2)
	TcSetField("ARQ_SQL","ZXA_QUANT","C",14,2)

	nAprov := 0
	nQuant := 0
	cCod   := ""
	if !Eof()
		nAprov := ZXA_PDESC
		nQuant := ZXA_QUANT
		cCod   := ZXA_COD
	Endif
	dbCloseArea()

	If nParDesc <> nAprov .OR. cParProd <> cCod .OR. nParQuant <> nQuant
		//msgbox("Os dados do orçamento estão diferentes do aprovado","Desconto","STOP")
		lRet := .F.
	Endif

	RestArea(aArea)
Return lRet

Static Function VLDDLG()
	Local lRet := .F.
	Local L    := 0

	For L=1 to Len(aCols)
		lRet := !Empty(aCols[L,10])
		If !lRet
			exit
		Endif
	Next L

	if !lRet
		Help("",1,"OBRIGAT2")
	Endif
Return lRet