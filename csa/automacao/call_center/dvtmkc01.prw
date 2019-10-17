#Include "Dellavia.ch" 
#include "Protheus.ch"

// Função principal
User Function DVTMKC01(cParam)
	Local   lFim        := .F.
	Local   cTitulo     := "Consulta solicitações de descontos"
	Local   bValid
	Private oExp
	Private aFuncPanels := {} 
	Private aPanels     := {}
	Private aRecNo      := {}
	Private nRecNo      := 1
	Private cPerg       := "DVTK01"
	Private INCLUI      := .F.
	Private ALTERA      := .F.
	Private aRotina     := {}
	Private cCadastro   := ""
	Private lChamada    := .F.
	Private cOrcParam   := cParam

	//aTeste := GetFuncPrm("enchoice")

	if cOrcParam <> Nil
		lChamada := .T.
	Endif

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5})



	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Do Orcamento       ?"," "," ","mv_ch1","C", 06,0,0,"G",""            ,"mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Ate o Orcamento    ?"," "," ","mv_ch2","C", 06,0,0,"G",""            ,"mv_par02",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"03","Da Emissao         ?"," "," ","mv_ch3","D", 08,0,0,"G",""            ,"mv_par03",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"04","Ate a Emissao      ?"," "," ","mv_ch4","D", 08,0,0,"G",""            ,"mv_par04",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"05","Status             ?"," "," ","mv_ch5","C", 05,0,0,"G","U_DVTKF01A()","mv_par05",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})

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

	If !lChamada
		if !Pergunte(cPerg,.T.)
			Return nil
		Endif
	Endif


	Do While !lFim
		aFuncPanels := {} 
		aPanels     := {}
		aRecNo      := {}
		nRecNo      := 1

		oExp := MsExplorer():New(cTitulo)
		oExp:DefaultBar()

		oExp:oTree:bValid:= { |cPromAtu ,cCargAtu ,cPromFut ,cCargFut|  &(aFuncPanels[Val(cCargFut)]) ,aPanels[Val(cCargFut)]:Show() ,aPanels[Val(cCargAtu)]:FreeChildren() ,.T.}
		oExp:AddDefButton("FINAL"    ,"Saida"     , {|| lFim:=.T.,oExp:DeActivate()               })
		If !lChamada
			oExp:AddDefButton("BMPPERG"  ,"Param"     , {|| Pergunte(cPerg,.T.),oExp:DeActivate()     })
		Endif
		oExp:AddDefButton("NOTE"     ,"Obs"       , {|| VerObs()                                  })
		oExp:AddDefButton("BMPVISUAL","Orçamento" , {|| VerOrc()                                  })

		MsgRun("Carregando Solicitações de Descontos ...",,{|| xProcess(oExp,aPanels)})

		&(aFuncPanels[1])

		oExp:Activate(.T.,bValid)
	Enddo
Return

// Função para montar a tree
Static Function xProcess(oExp)
	Local nPanel  := 0
	Local cSql    := ""
	Local cFilSts := ""

	dbSelectArea("SU7")
	dbSetOrder(4)
	dbGoTop()
	dbSeek(xFilial("SU7")+__cUserId)
	if eof()
		ApMsgStop("Voce não tem acesso a esta rotina","Consultas")
		Return nil
	Endif

	If !lChamada
		cFilSts  := ""
		For jj=1 to Len(AllTrim(mv_par05))
			If Substr(mv_par05,jj,1) <> "*"
				cFilSts := cFilSts + "'"+Substr(mv_par05,jj,1)+"',"
			Endif
		Next jj
		If Len(cFilSts) > 0
			cFilSts := substr(cFilSts,1,Len(cFilSts)-1)
		Endif
	Endif

	cSql := "SELECT DISTINCT ZX2_FILIAL,ZX2_ORC,ZX2_NUM"
	cSql += " FROM "+RetSqlName("ZX2")+" ZX2, "+RetSqlName("SUA")+" SUA"
	cSql += " WHERE ZX2.D_E_L_E_T_ = ''"
	cSql += " AND   SUA.D_E_L_E_T_ = ''"
	cSql += " AND   ZX2_FILIAL = '"+xFilial("ZX2")+"'"
	If lChamada
		cSql += " AND   ZX2_ORC = '"+cOrcParam+"'"
	Else
		cSql += " AND   ZX2_ORC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
		cSql += " AND   ZX2_ORC IN(SELECT ZX2_ORC FROM "+RetSqlName("ZX2")+" WHERE D_E_L_E_T_ = '' AND ZX2_FILIAL = '"+xFilial("ZX2")+"' AND ZX2_OPER = '"+SU7->U7_COD+"')"
		cSql += " AND   ZX2_STATUS IN("+cFilSts+")"
		cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	Endif
	cSql += " AND   UA_FILIAL = ZX2_FILIAL"
	cSql += " AND   UA_NUM = ZX2_ORC"
	cSql += " ORDER BY ZX2_FILIAL,ZX2_ORC,ZX2_NUM"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")

	Do While !eof()
		dbSelectArea("ZX2")
		dbSetOrder(1)
		ProcRegua(0)
		dbSeek(ARQ_SQL->(ZX2_FILIAL+ZX2_ORC+ZX2_NUM))

		cOrc := ZX2_ORC
		cSol := ZX2_NUM
		nPanel++
		oExp:AddTree(cOrc+" - "+cSol+Space(11),"PMSEDT1",,StrZero(nPanel,4))
		aAdd(aPanels,oExp:GetPanel(nPanel))
		aAdd(aFuncPanels,"xPainel(oExp,"+Str(nPanel)+")")
		aAdd(aRecno,Recno())

		Do While !eof() .AND. ZX2_FILIAL = ARQ_SQL->ZX2_FILIAL .AND. ZX2_ORC = cOrc .AND. ZX2_NUM = cSol
			cItem := ZX2_ITEM
			nPanel++
			oExp:AddTree("Item "+cItem+" - "+ZX2_COD,"PMSEDT2",,StrZero(nPanel,4))
			aAdd(aPanels,oExp:GetPanel(nPanel))
			aAdd(aFuncPanels,"xPainel(oExp,"+Str(nPanel)+")")
			aAdd(aRecno,Recno())

			Do While !eof() .AND. ZX2_FILIAL = ARQ_SQL->ZX2_FILIAL .AND. ZX2_ORC = cOrc  .AND. ZX2_NUM = cSol .AND. ZX2_ITEM = cItem
				nPanel++
				oExp:AddItem(ZX2_SEQ+" - "+dtoc(ZX2_DATSOL)+" - "+ZX2_HORSOL,"PMSEDT3",StrZero(nPanel,4))
				aAdd(aPanels,oExp:GetPanel(nPanel))
				aAdd(aFuncPanels,"xCadastro(oExp,"+Str(nPanel)+")")
				aAdd(aRecno,Recno())
				dbSkip()
			Enddo
			oExp:EndTree()
		Enddo
		oExp:EndTree()
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbSelectArea("ARQ_SQL")
	dbCloseArea()
	
	if nPanel = 0
		nPanel++
		oExp:AddTree("Vazio","PMSEDT1",,StrZero(nPanel,4))
		aAdd(aPanels,oExp:GetPanel(nPanel))
		aAdd(aFuncPanels,"xPainel(oExp,"+Str(nPanel)+")")
		aAdd(aRecno,0)
	Endif
Return

// Função que conduz o usuário clicar na subcategoria da tree
Static Function xPainel(oExp,nPanel)
	Local cTitulo := "Selecione uma sequencia para exibição"
	Local nTop    := 0
	Local nLeft   := 0
	Local nBottom := Int((oExp:aPanel[nPanel]:nHeight * 0.995)/2)
	Local nRight  := Int((oExp:aPanel[nPanel]:nWidth * 0.995)/2)
	Local oBmp
	Local oFnt    := TFont():New("Arial",0,-12,,.T.,,,,,.T.)

	@ 000,000 BITMAP oBmp RESNAME "PROJETOAP" oF oExp:GetPanel(nPanel) SIZE nRight/6, nBottom+10 NOBORDER WHEN .F. PIXEL ADJUST
	TSay():New(nTop,(nRight*.1),{|| cTitulo },oExp:GetPanel(nPanel),,oFnt,,,,.T.,CLR_HBLUE,CLR_WHITE)
Return

// Função que apresenta cadastro
Static Function xCadastro(oExp,nPanel)
	Local nTop    := 2
	Local nLeft   := 2
	Local nBottom := Int((oExp:aPanel[nPanel]:nHeight * .995) / 2)
	Local nRight  := Int((oExp:aPanel[nPanel]:nWidth * .995) / 2)
	Local aCoord  := {{nTop,nLeft,nBottom,nRight}}
	Local cAlias  := "ZX2"

	INCLUI := .F.
	ALTERA := .F.

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTo(aRecNo[nPanel])
	RegToMemory(cAlias,.F.)

	MsMGet():New(cAlias,RecNo(),2,,,,,aCoord[1],,,,,,oExp:GetPanel(nPanel),,.F.)
Return

User Function DVTKF01A()
	Local   cTitulo  := ""
	Local   MvParDef := ""
	Local   MvPar
	Private aSit     := {}
	Private l1Elem   := .F.

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	mvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	aAdd(aSit,"1 - Pendente"       )
	aAdd(aSit,"2 - Liberado"       )
	aAdd(aSit,"3 - Recusado"       )
	aAdd(aSit,"4 - Cancelado"      )
	aAdd(aSit,"5 - Aguardando Sup.")
	mvParDef := "12345"

	cTitulo :="Status"
	Do While .T. 
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
		if mvpar = Replicate("*",Len(mvParDef))
			MsgBox("Voce deve selecionar pelo menos 1 tipo de venda","Tipo de venda","STOP")
			Loop
		Else
			Exit
		Endif
	Enddo
Return MvParDef

Static Function VerOrc()
	Local nRec := aRecno[Val(oExp:oTree:GetCargo())]

	If nRec > 0
		dbSelectArea("ZX2")
		dbGoTo(nRec)
		
		dbSelectArea("SUA")
		dbSetOrder(1)
		dbSeek(ZX2->(ZX2_FILIAL+ZX2_ORC))

		if !eof()
			TK271CallCenter("SUA",SUA->(LastRec()),2)
		Else
			ApMsgStop("Erro ao localizar o orçmento")
		Endif
	Endif
Return nil

Static Function VerObs()
	Local nRec := aRecno[Val(oExp:oTree:GetCargo())]
	Local cObs  := ""

	If nRec > 0
		dbSelectArea("ZX2")
		dbGoTo(nRec)
		cObs := MSMM(ZX2->ZX2_OBSGER,80)
		DEFINE MSDIALOG oDlgObs FROM 000,000 TO 180,300 TITLE "Observação geral - "+ZX2->ZX2_ORC PIXEL 
		@ 002,002 MEMO cObs PIXEL OF oDlgObs SIZE 148,65 NO VSCROLL READONLY
		@ 075,120 BMPBUTTON TYPE 1 ACTION Close(oDlgObs)
		ACTIVATE DIALOG oDlgObs CENTERED
	Else
		ApMsgStop("Erro ao localizar a observação")
	Endif
Return nil