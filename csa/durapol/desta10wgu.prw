#include 'protheus.ch'  
#include 'dellavia.ch'
#Define VK_F12 123   

User Function DESTA10 ()

	Private aRotina   := {}
	Private cCadastro := ""
	Private cAliasCab := "TMP"
	Private cMarca    := "X"
	Private cNomSIX   := ""
	Private cNomTmp   := ""
	Private aCpos     := {}
	Private cPerg     := "DEST10" 
	cPerg    := PADR(cPerg,6)
	aRegs    := {}	
	AADD(aRegs,{cPerg,"01","Do Cliente          ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate o Cliente       ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"03","Da Data Producao    ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"04","Ate a Data          ?"," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"05","Ordem [C]liente/[O]P?"," "," ","mv_ch5","C", 01,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })

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
// Matriz de definição dos menus
	aAdd(aRotina,{"Pesquisar"    ,"AxPesqui"      ,0,1})    
	aAdd(aRotina,{"Gerar Pedido" ,"U_DST10AG()"  ,0,2})
	aAdd(aRotina,{"Parametros"   ,"U_DST10AP()"  ,0,3})
	Set Key VK_F12 TO U_DST10AP()
	MsgRun("Consultando banco de dados...",,{ || AbreTmp(.T.) })
	mBrowse(,,,,cAliasCab,aCpos,,,,,) // Cria o browse
	Set Key VK_F12 TO
// Fecha Temporários
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())
	dbSelectArea("SIX")
	dbCloseArea()
	fErase(cNomSIX+GetDbExtension())
	fErase(cNomSIX+OrdBagExt())	
// Reabre SIX
	dbUseArea(.T.,,"SIX"+Substr(cNumEmp,1,2)+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+Substr(cNumEmp,1,2)+"0")    	
Return nil

/*User Function DST10AP()
	if Pergunte(cPerg,.T.)
		MsgRun("Consultando banco de dados...",,{ || AbreTmp() })
	Endif
Return nil

Static Function AbreTmp(lSIX)
	Local cSql    := ""
	Local aEstru  := {}
	Local aCampos := {}
	Local aIndex  := {}
	Local k       := 0

	Default lSix  := .F.

	Pergunte(cPerg,.F.)

	cSql := "SELECT DISTINCT C2_FORNECE,C2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO"
	cSql += " FROM   "+RetSqlName("SC2")+" SC2"

	cSql += " LEFT JOIN "+RetSqlName("SC6")+" SC6"
	cSql += " ON   SC6.D_E_L_E_T_ = ''"
	cSql += " AND  C6_FILIAL = C2_FILIAL"
	cSql += " AND  C6_NUMOP = C2_NUM"
	cSql += " AND  C6_ITEMOP = C2_ITEM"

	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += " AND   C2_FILIAL = '"+xFilial("SC2")+"'"
	cSql += " AND   C2_X_STATU IN('9','6')"
	cSql += " AND   (C6_NOTA IS NULL OR C6_NOTA = '')"
	cSql += " AND   C2_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   C2_DATRF BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'" 
	if upper(mv_par05) == "C"
	   cSql += " ORDER BY C2_FORNECE,C2_LOJA,C2_NUM"
	else
	   cSql += " ORDER BY C2_NUM"
	endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	aFields(aCampos)

	For k=1 to Len(aCampos)
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek(aCampos[k],.F.)
		If Found() .AND. AllTrim(X3_CAMPO) == AllTrim(aCampos[k])
			IF X3_CONTEXT <> "V"
				aadd(aEstru,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
				aadd(aCpos,{Capital(Alltrim(X3_TITULO)),AllTrim(X3_CAMPO)})
			Endif
		Endif
	Next

	dbSelectArea("ARQ_SQL")
	For k=1 to Len(aEstru)
		if aEstru[k,2] <> "C"
			TcSetField("ARQ_SQL",aEstru[k,1],aEstru[k,2],aEstru[k,3],aEstru[k,4])
		Endif
	Next k

	if !Empty(cNomTmp)
		dbSelectArea("TMP")
		dbCloseArea()
		fErase(cNomTmp+GetDbExtension())
		fErase(cNomTmp+OrdBagExt())
		dbSelectArea("ARQ_SQL")
	Endif

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.) 
	if upper(mv_par05) == "C"
	   Index on C2_FORNECE+C2_LOJA+C2_NUM TAG IND1 TO &cNomTmp
	else
	   Index on C2_NUM                    TAG IND1 TO &cNomTmp
    endif
    
	if lSIX
		dbSelectArea("SIX")
		aEstru := dbStruct()
		dbCloseArea()
		cNomSIX := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
	    IndRegua("SIX",cNomSIX,"INDICE+ORDEM",,,"Selecionando Registros...")
	    
		If RecLock("SIX",.T.)
			SIX->INDICE    := "TMP"
			SIX->ORDEM     := "1"
			if upper(mv_par05) == "C"
			   SIX->CHAVE     := "C2_FORNECE+C2_LOJA+C2_NUM"     
			   SIX->DESCRICAO := "Cliente + Loja + Numero + Item"
			else
			   SIX->CHAVE     := "C2_Num"
			   SIX->DESCRICAO := "Numero Ordem de Producao"
		    endif   
			SIX->DESCSPA   := ""
			SIX->DESCENG   := ""
			SIX->PROPRI    := "U"
			SIX->F3        := ""
			SIX->NICKNAME  := ""
			SIX->SHOWPESQ  := "S"
			MsUnLock()
		Endif
	Endif
Return nil


User Function DST10ALL()
	MarkBRefresh()
Return nil

User Function DST10MARK() 
	If RecLock("TMP",.F.) 
		TMP->C2_MARCA := iif(IsMark("C2_MARCA",cMarca)," ",cMarca)
		MsUnLock()
	Endif
Return


User Function DSTA10X()
	dbSelectArea("SIX")
	dbCloseArea()
	fErase(cNomSIX+GetDbExtension())
	fErase(cNomSIX+OrdBagExt())
	
	// Reabre SIX
	dbUseArea(.T.,,"SIX"+Substr(cNumEmp,1,2)+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+Substr(cNumEmp,1,2)+"0")

	if U_DESTA10F(TMP->C2_NUM)
		AbreTmp(.T.)
	Endif
Return nil      

User Function DESTA10F (cColeta)

	Local aArea    := GetArea()
	Local cQuery   := ""
	Local lInverte := .F.
	Local cArqTR1  := ""
	Local nOpca    := 0
	Local aStruct  := { { "TR1_OK"     , "C", 2                      , 0                     },;
                    	{ "TR1_STATUS" , "C", 15                     , 0                     },;
                    	{ "TR1_CLIENT" , "C", 30                     , 0                     },;
                    	{ "TR1_MOTORI" , "C", 30                     , 0                     },;
                    	{ "TR1_NUM"    , "C", TamSX3('C2_NUM')[1]    , 0                     },;
                    	{ "TR1_ITEM"   , "C", TamSX3('C2_ITEM')[1]   , 0                     },;
                    	{ "TR1_SEQUEN" , "C", TamSX3('C2_SEQUEN')[1] , 0                     },;
                    	{ "TR1_PRODUT" , "C", TamSX3('C2_PRODUTO')[1], 0                     },;
                    	{ "TR1_SERV"   , "C", TamSX3('D1_SERVICO')[1], 0                     },;
                    	{ "TR1_QUANT"  , "N", TamSX3('C2_QUANT')[1]  , TamSX3('C2_QUANT')[2] },;
                    	{ "TR1_QUJE"   , "N", TamSX3('C2_QUJE')[1]   , TamSX3('C2_QUJE')[2]  },;
                    	{ "TR1_PERDA"  , "N", TamSX3('C2_PERDA')[1]  , TamSX3('C2_PERDA')[2] },;
                    	{ "TR1_CARCAC" , "C", TamSX3('C2_CARCACA')[1], 0                     },;
                    	{ "TR1_NUMFOG" , "C", TamSX3('C2_NUMFOGO')[1], 0                     },;
                    	{ "TR1_SERIEP" , "C", TamSX3('C2_SERIEPN')[1], 0                     },;
                    	{ "TR1_DESEN"  , "C", TamSX3('C2_X_DESEN')[1], 0                     },;
                    	{ "TR1_EMISSA" , "D", TamSX3('C2_EMISSAO')[1], 0                     },;
                    	{ "TR1_DATRF"  , "D", TamSX3('C2_DATRF')[1]  , 0                     },;
                    	{ "TR1_NUMD1"  , "C", TamSX3('C2_NUMD1')[1]  , 0                     },;
                    	{ "TR1_SERD1"  , "C", TamSX3('C2_SERIED1')[1], 0                     },;
                    	{ "TR1_ITEMD1" , "C", TamSX3('C2_ITEMD1')[1] , 0                     },;
                    	{ "TR1_FORNEC" , "C", TamSX3('C2_FORNECE')[1], 0                     },;
                    	{ "TR1_LOJA"   , "C", TamSX3('C2_LOJA')[1]   , 0                     },;
                    	{ "TR1_XMRDIR" , "C", TamSX3('C2_XMREDIR')[1], 0                     },;
                    	{ "TR1_DTCLAV" , "D", TamSX3('C2_XDTCLAV')[1], 0                     },;
                    	{ "TR1_OBS"    , "C", TamSX3('C2_OBS')    [1], 0                     } }

	Local aCpoShow := { { "TR1_OK"    ,, ""           , "@!" },;
                    	{ "TR1_STATUS",, "Status"     , "@a" },;
                    	{ "TR1_CLIENT",, "Cliente"    , "@!" },;
                    	{ "TR1_NUM"   ,, "Coleta"     , "@!" },;
                    	{ "TR1_ITEM"  ,, "Item"       , "@!" },;
                    	{ "TR1_SERV"  ,, "Servico"    , "@!" },;
                    	{ "TR1_PRODUT",, "Produto"    , "@!" },;
                    	{ "TR1_CARCAC",, "Carcaca"    , "@!" },;
                    	{ "TR1_NUMFOG",, "Numero Fogo", "@!" },;
                    	{ "TR1_SERIEP",, "Serie Pneu" , "@!" },;
                    	{ "TR1_DESEN" ,, "Desenho"    , "@!" },;
                    	{ "TR1_EMISSA",, "Entrada"    , "99/99/99" },;
                    	{ "TR1_DATRF" ,, "Liberacao"  , "99/99/99" },;
                    	{ "TR1_MOTORI",, "Motorista"  , "@!" },;
                    	{ "TR1_XMRDIR",, "Mot Rej Dir", "@!" },;
                    	{ "TR1_DTCLAV",, "Auto Clave" , "99/99/99" },;
                    	{ "TR1_OBS"   ,, "Observacao" , "@!" } }

	Private cMarca := GetMark()
	Private cAlias1  := GetNextAlias()

	cArqTR1 := CriaTrab( aStruct, .T. )

	dbUseArea( .T.,, cArqTR1, "TR1", .F. )

	cQuery := "SELECT C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_QUANT,C2_QUJE,C2_PERDA"
	cQuery += "       ,C2_X_DESEN,C2_PRODUTO,C2_CARCACA,C2_NUMFOGO,C2_SERIEPN,C2_EMISSAO,C2_DATRF,D1_SERVICO"
	cQuery += "       ,C2_NUMD1,C2_SERIED1,C2_ITEMD1,C2_FORNECE,C2_LOJA,C6_NOTA,C2_XNREDUZ,C2_X_STATU,C2_XMREDIR,C2_XDTCLAV,C2_OBS"
	cQuery += " FROM " + RetSqlName("SC2") + " SC2"

	cQuery += " JOIN " + RetSqlName("SD1") + " SD1"
	cQuery += " ON    SD1.D_E_L_E_T_ = ''"
	cQuery += " AND   D1_FILIAL = C2_FILIAL"
	cQuery += " AND   D1_DOC = C2_NUMD1"
	cQuery += " AND   D1_ITEM = C2_ITEMD1"
	cQuery += " AND   D1_SERIE = C2_SERIED1"
	cQuery += " AND   D1_FORNECE = C2_FORNECE"
	cQuery += " AND   D1_LOJA = C2_LOJA"

	cQuery += " LEFT JOIN "+RetSqlName("SC6")+" SC6"
	cQuery += " ON   SC6.D_E_L_E_T_ = ''"
	cQuery += " AND  C6_FILIAL = C2_FILIAL"
	cQuery += " AND  C6_NUMOP = C2_NUM"
	cQuery += " AND  C6_ITEMOP = C2_ITEM"
	cQuery += " AND  C6_PRODUTO = C2_PRODUTO"

	cQuery += " WHERE SC2.D_E_L_E_T_ = ''
	cQuery += " AND   C2_FILIAL = '" + xFilial("SC2") + "'"
	cQuery += " AND   C2_NUM = '" + cColeta + "'"
	cQuery += " ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN"

	dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias1, .F., .F. )

	TCSetField( cAlias1, "C2_EMISSAO", "D", 8 )
	TCSetField( cAlias1, "C2_DATRF"  , "D", 8 )
	TCSetField( cAlias1, "C2_XDTCLAV", "D", 8 )

	If (cAlias1)->( Eof() )
		TR1->( dbCloseArea() )
		MsgStop( "Nao existem dados para Coleta informada" )
		Return Nil
	EndIf

	While (cAlias1)->( !Eof() )
		SA3->(dbSetOrder(1))
		SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND3,.F.))
	
		RecLock( "TR1", .T. )
	
		TR1->TR1_CLIENT  := (cAlias1)->C2_XNREDUZ   
		TR1->TR1_MOTORI  := SA3->A3_NOME
		TR1->TR1_STATUS  := VerStatus()                             
		TR1->TR1_OK      := iif(AllTrim(TR1->TR1_STATUS) $ "Liberado*Recusado",cMarca,"")
		TR1->TR1_NUM     := (cAlias1)->C2_NUM
		TR1->TR1_ITEM    := (cAlias1)->C2_ITEM
		TR1->TR1_SEQUEN  := (cAlias1)->C2_SEQUEN
		TR1->TR1_SERV    := (cAlias1)->D1_SERVICO
		TR1->TR1_PRODUT  := (cAlias1)->C2_PRODUTO
		TR1->TR1_QUANT   := (cAlias1)->C2_QUANT
		TR1->TR1_QUJE    := (cAlias1)->C2_QUJE
		TR1->TR1_PERDA   := (cAlias1)->C2_PERDA
		TR1->TR1_CARCAC  := (cAlias1)->C2_CARCACA
		TR1->TR1_NUMFOG  := (cAlias1)->C2_NUMFOGO
		TR1->TR1_SERIEP  := (cAlias1)->C2_SERIEPN
		TR1->TR1_DESEN   := (cAlias1)->C2_X_DESEN
		TR1->TR1_EMISSA  := (cAlias1)->C2_EMISSAO
		TR1->TR1_DATRF   := (cAlias1)->C2_DATRF
		TR1->TR1_DTCLAV  := (cAlias1)->C2_XDTCLAV
		TR1->TR1_NUMD1   := (cAlias1)->C2_NUMD1
		TR1->TR1_SERD1   := (cAlias1)->C2_SERIED1
		TR1->TR1_ITEMD1  := (cAlias1)->C2_ITEMD1
		TR1->TR1_FORNEC  := (cAlias1)->C2_FORNECE
		TR1->TR1_LOJA    := (cAlias1)->C2_LOJA
		TR1->TR1_XMRDIR  := (cAlias1)->C2_XMREDIR
		TR1->TR1_OBS     := (cAlias1)->C2_OBS

	
		MsUnLock()
	
		(cAlias1)->( dbSkip() )
	EndDo

	TR1->( dbGotop() )
	If TR1->( !Eof() )
		DEFINE MSDIALOG oDlg FROM 60, 1 TO 365, 685 TITLE "Geracao Automatica - Selecione as OP's para " PIXEL
		oMark := MsSelect():New( "TR1", "TR1_OK",,aCpoShow,,@cMarca,{020,001,153,343})
		oMark:bAval := {|| MarcaRegs() }
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || nOpca := 1, oDlg:End() }, { || nOpca := 0, oDlg:End() } ) CENTERED
	
		If nOpca == 1
			MsgRun("Limpando pedidos em aberto...",,{ || U_DGOLA22(cColeta) })
			MsgRun("Gerando pedido...",,{ || U_DESTA10g(cColeta) })
		EndIf
	EndIf

	(cAlias1)->( dbCloseArea() )

	TR1->( dbCloseArea() )

	Ferase( cArqTR1 + GetDbExtension() )

	RestArea( aArea )

Return (nOpca == 1)




User Function DSTA10AG (cColeta)

	Local cTsServ       := GetMV( "MV_X_TSVED" )
	Local aArea         := GetArea()
	Local _aAreaSD1     := SD1->(GetArea())
	Local _aAreaSF4     := SF4->(GetArea())
	Local _aAreaSA1     := SA1->(GetArea())
	Local _aAreaSA2     := SA2->(GetArea())
	Local _aAreaSE4     := SE4->(GetArea())
	Local _aAreaSB2     := SB2->(GetArea())
	Local _aSC5         := {}
	Local _aSC6         := {}
	Local aAux          := {}
	Local _nValor       := 0
	Local aStruSD1      := {}
	Local nA            := 0
	//Local lProduziu     := .T.   
	Local lLiberado		:= .T.
	Local lSoConcerto   := .F.
	Local cDescPro      := ""
	Local lcodvend3     := space(6)
	Local lvalcomi3     := 0
	Local lcodvend4     := space(6)
	Local lvalcomi4     := 0
	Local lcodvend5     := space(6)
	Local lvalcomi5     := 0  
	Local lexcitped     := .F.
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.

	//SD1->( dbSetOrder( 1 ) )
	SF4->( dbSetOrder( 1 ) )
	SB1->( dbSetOrder( 1 ) )   
	
	TR1->( dbGotop() )      
	
	SF1->( dbSetOrder( 1 ) )
	SF1->( MsSeek( xFilial("SF1") + TR1->TR1_NUMD1 + TR1->TR1_SERD1 + TR1->TR1_FORNEC + TR1->TR1_LOJA ))
	IF EOF() .OR. SF1->F1_TIPO = "B" 
		 MsgInfo( "Coleta Invalida Verifique SF1 ou Tipo SF1 ... Pedido Não Gerado", "Atençao!" )
	Return Nil
	
	SA1->( dbSetOrder( 1 ) )
	SA1->( MsSeek( xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA ) )

	SE4->( dbSetOrder( 1 ) )
	SE4->( MsSeek( xFilial("SE4") + SF1->F1_COND ) )   
    
	// Consiste e despreza vendedores não ativos
	
	SA3->(dbSetOrder(1))
	if .not.(SA1->A1_VEND3 = SPACE(6) .OR. SA1->A1_VEND3 = '000000') 
		SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND3,.F.))
	 	if .not.eof() .and. upper(SA3->A3_ATIVO) # "N"
	  		lcodvend3 := SA1->A1_VEND3
	    	lvalcomi3 := SA1->A1_COMIS3
	    endif
	endif
				
	if .not.(SA1->A1_VEND4 = SPACE(6) .OR. SA1->A1_VEND4 = '000000') 
		SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND4,.F.))
	 	if .not.eof() .and. upper(SA3->A3_ATIVO) # "N"
	  		lcodvend4 := SA1->A1_VEND4
	    	lvalcomi4 := SA1->A1_COMIS4
	  	endif
	endif
	
	if .not.(SA1->A1_VEND5 = SPACE(6) .OR. SA1->A1_VEND5 = '000000') 
		SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND5,.F.))
	 	if .not.eof() .and. upper(SA3->A3_ATIVO) # "N"
	  		lcodvend5 := SA1->A1_VEND5
	    	lvalcomi5 := SA1->A1_COMIS5
	    endif
	endif
	        
            //-- Adiciono o Cabecalho do Pedido Venda.      
            //For nA := 1 To 1   // (cAlias2)->D1_QUANT  // D1_QUANT == 1
	_aSC5 := 	{ 	{'C5_FILIAL'   , xFilial("SC5")     , NIL },;
 					{  'C5_NUM'    , (cAlias2)->D1_NUMC2, NIL },;
			   		{  'C5_TIPO'   , 'N'                , NIL },;
			     	{  'C5_CLIENTE', SF1->F1_FORNECE    , NIL },;
			      	{  'C5_LOJACLI', SF1->F1_LOJA       , NIL },;
			       	{  'C5_TABELA' , "   "              , NIL },;
			        {  'C5_VEND1'  , "      "           , NIL },;
			        {  'C5_COMIS1' , 0.00               , NIL },;
			        {  'C5_VEND2'  , "      "           , NIL },;
	          		{  'C5_COMIS2' , 0.00               , NIL },;
			        {  'C5_VEND3'  , lcodvend3          , NIL },;
			        {  'C5_COMIS3' , lvalcomi3          , NIL },;
			        {  'C5_VEND4'  , lcodvend4          , NIL },;
		         	{  'C5_COMIS4' , lvalcomi4          , NIL },;
			        {  'C5_VEND5'  , lcodvend5          , NIL },;
			        {  'C5_COMIS5' , lvalcomi5          , NIL },;
			        {  'C5_LIBEROK', 'S'                , NIL },;
			        {  'C5_CONDPAG', Iif(Empty(SF1->F1_COND), SA1->A1_COND, SF1->F1_COND), NIL } }

	While TR1->( !Eof() )
		                            
		If TR1->TR1_OK != cMarca
			TR1->( dbSkip() )
			Loop
		Endif
		
		cItem    := StrZero( Val( TR1->TR1_ITEM ), Len( SD1->D1_ITEM ) )
		cAlias2  := GetNextAlias()
		
		//-- Busco o item da nota.               
		cQuery := "SELECT * FROM " + RetSqlName("SD1")
		cQuery += " WHERE D1_DOC = '"     + TR1->TR1_NUMD1  + "' AND"
		cQuery += "       D1_ITEM = '"    + TR1->TR1_ITEMD1 + "' AND"
		cQuery += "       D1_SERIE = '"   + TR1->TR1_SERD1  + "' AND"
		cQuery += "       D1_FORNECE = '" + TR1->TR1_FORNEC + "' AND"
		cQuery += "       D1_LOJA = '"    + TR1->TR1_LOJA   + "' AND"
		cQuery += " D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery( cQuery )
		
		aStruSD1 := SD1->( dbStruct() )
		
		dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias2, .F., .F. )
		
		For nA := 1 To Len( aStruSD1 )
			If aStruSD1[nA, 2] <> "C" .And. aStruSD1[nA, 2] <> "M" .And. FieldPos( aStruSD1[nA, 2] ) != 0
				TCSetField( cAlias2, aStruSD1[nA, 1], aStruSD1[nA, 2], aStruSD1[nA, 3], aStruSD1[nA, 4] )
			EndIf
		Next nA
			
		_nValor := (cAlias2)->D1_TOTAL // / (cAlias2)->D1_QUANT
				
		SB1->( MsSeek( xFilial("SB1") + (cAlias2)->D1_SERVICO ) )
		lSoConcerto := Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
				
		SF4->( MsSeek( xFilial("SF4") + (cAlias2)->D1_TES ) ) //-- Busca TES Nota Fiscal Entrada para descobrir qual TES sera utilizado na Saida para devolucao do produto carcaca
		SF4->( MsSeek( xFilial("SF4") + SF4->F4_TESDV ) )     //-- Posiciona SF4 com o TES que sera utilizado para a saida (devolucao do produto recebido na nota fiscal entrada)
		SB1->( MsSeek( xFilial("SB1") + (cAlias2)->D1_COD ) )
				
		lLiberado   := TR1->TR1_STATUS $ "Liberado"
		
		cDescPro  := ''
		If lSoConcerto
			cDescPro := If(lLiberado,"","RECUSADO ")+"SC " + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Iif( !Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP )  )
		Else
			cDescPro := Alltrim ( (cAlias2)->D1_COD )
		EndIf
				
				//-- Adiciono o Item do Pedido referente ao produto.
		aAux    := {}
		Aadd( aAux , { 'C6_FILIAL' , xFilial("SC6")            , NIL } )
		Aadd( aAux , { 'C6_NUM'    , (cAlias2)->D1_NUMC2       , NIL } )
		Aadd( aAux , { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0) , NIL } )
		Aadd( aAux , { 'C6_PRODUTO', (cAlias2)->D1_COD         , NIL } )
		Aadd( aAux , { 'C6_DESCRI' , cDescPro                  , NIL } )
		Aadd( aAux , { 'C6_QTDVEN' , 1                         , NIL } )
		Aadd( aAux , { 'C6_QTDLIB' , 1                         , NIL } )
		Aadd( aAux , { 'C6_PRCVEN' , (cAlias2)->D1_VUNIT       , NIL } )
		Aadd( aAux , { 'C6_PRUNIT' , (cAlias2)->D1_VUNIT       , NIL } )
		Aadd( aAux , { 'C6_VALOR'  , (cAlias2)->D1_TOTAL       , NIL } )
		Aadd( aAux , { 'C6_LOCAL'  , (cAlias2)->D1_LOCAL       , NIL } )
		Aadd( aAux , { 'C6_NFORI'  , (cAlias2)->D1_DOC         , NIL } )
		Aadd( aAux , { 'C6_SERIORI', (cAlias2)->D1_SERIE       , NIL } )
		Aadd( aAux , { 'C6_ITEMORI', (cAlias2)->D1_ITEM        , NIL } )
		Aadd( aAux , { 'C6_IDENTB6', (cAlias2)->D1_IDENTB6     , NIL } )
		dEntrega := ctod("")
		dEntrega := STOD((cAlias2)->D1_DTENTRE)
		Aadd( aAux , { 'C6_ENTREG' , dEntrega                   , NIL } )
		Aadd( aAux , { 'C6_TES'    , SF4->F4_CODIGO            , NIL } )
		Aadd( aAux , { 'C6_NUMOP'  , (cAlias2)->D1_NUMC2       , NIL } )
		Aadd( aAux , { 'C6_ITEMOP' , Substr((cAlias2)->D1_ITEM,3,2), NIL } )
		Aadd( aAux , { 'C6_CF'     , SF4->F4_CF                , NIL } )
		Aadd( aAux , { 'C6_ITPVSRV', StrZero(Len(_aSC6)+2,2,0) , NIL } )
		Aadd( _aSC6, aAux )
				
		cItOrig := Substr( (cAlias2)->D1_ITEM, 3, 2 )
				
		SF4->( MsSeek( xFilial("SF4") + cTsServ ) )
		SB1->( MsSeek( xFilial("SB1") + (cAlias2)->D1_SERVICO ) )
				
		_nValor  := U_BuscaAcp ( (cAlias2)->D1_SERVICO, SF1->F1_FORNECE, SF1->F1_LOJA )
				
		If _nValor == 0
			MsgInfo( "O valor do serviço SD1" + (cAlias2)->D1_SERVICO + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Atençao!" )
			Return Nil
		EndIf
				
		cTes      := Iif( lLiberado, cTsServ, '903' )
		cDescPro  := ''
				
		If lLiberado 
			cDescPro := AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " BANDA " + Alltrim( TR1->TR1_DESEN ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( !Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP ) )
		Else
			cDescPro := AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP )  )
		EndIf
				
		aAux  := {}
				
		If !lSoConserto
					//-- Adiciono Servico (D1_SERVICO) no Pedido de Venda.
			Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")           , NIL } )
			Aadd( aAux, { 'C6_NUM'    , (cAlias2)->D1_NUMC2      , NIL } )
			Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0), NIL } )
			Aadd( aAux, { 'C6_PRODUTO', (cAlias2)->D1_SERVICO    , NIL } )
			Aadd( aAux, { 'C6_DESCRI' , cDescPro                 , NIL } )
			Aadd( aAux, { 'C6_QTDVEN' , 1                        , NIL } )
			Aadd( aAux, { 'C6_QTDLIB' , 1                        , NIL } )
			Aadd( aAux, { 'C6_PRCVEN' , _nValor                  , NIL } )
			Aadd( aAux, { 'C6_PRUNIT' , _nValor                  , NIL } )
			Aadd( aAux, { 'C6_VALOR'  , _nValor                  , NIL } )
			Aadd( aAux, { 'C6_LOCAL'  , (cAlias2)->D1_LOCAL      , NIL } )
			Aadd( aAux, { 'C6_NFORI'  , ""                       , NIL } )
			Aadd( aAux, { 'C6_SERIORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_ITEMORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_IDENTB6', ""                       , NIL } )
			Aadd( aAux, { 'C6_NUMOP'  , (cAlias2)->D1_NUMC2      , NIL } )
			Aadd( aAux, { 'C6_ITEMOP' , cItOrig                  , NIL } )
			Aadd( aAux, { 'C6_TES'    , cTes                     , NIL } )
			Aadd( aAux, { 'C6_CF'     , SF4->F4_CF               , NIL } )
			Aadd( _aSC6, aAux )
		EndIf
				
			//(cAlias2)->(dbCloseArea() )
			
			//-- Verifico se foi executado mais algum servico.
			
		cOrdemP := cColeta + TR1->TR1_ITEM
			
		cAlias3 := GetNextAlias()
			
		dbSelectArea("SZF")
		dbSetorder(1)
		dbSeek(xFilial("SZF")+cOrdemP+"001  ")	
		While .not.eof() .and. xFilial("SZF")==SZF->ZF_Filial .and. cOrdemP+"001  "==SZF->ZF_NumOP
					
			If ! ( SB1->( MsSeek( xFilial("SB1") + SZF->ZF_PRODSRV, .F. ) ) )
				SZF->( dbSkip() )
				Loop
			EndIf
					
			_nValor := U_BuscaAcp ( SZF->ZF_PRODSRV, SF1->F1_FORNECE, SF1->F1_LOJA )
					
			If _nValor == 0
				MsgInfo( "O valor do serviço SZF" + (cAlias3)->ZF_PRODSRV + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Atençao!" )
				Exit
			EndIf
							
			cTes      := Iif( lLiberado, Iif( SA1->A1_CALCCON == 'S', GetMV("MV_X_TSVED"),Iif(Alltrim( SB1->B1_GRUPO ) == "SC",GetMV("MV_X_TSVED"), '902' ) ) , '903' )
					
			SF4->( MsSeek( xFilial("SF4") + cTes ) )
					
					//-- Zero array para adicionar novo item ao pedido.
			aAux  := {}
					
					//-- Troca a Descricao para OP's que foram recusadas.
			If Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
				cDescPro := AllTrim( SB1->B1_DESC ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP ) )
			Else
				cDescPro := SB1->B1_DESC
			EndIf
					
					//-- Adiciono o Conserto no Pedido de Venda.
			Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")                , NIL } )
			Aadd( aAux, { 'C6_NUM'    , Left( (cAlias3)->ZF_NUMOP, 6 )   , NIL } )
			Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0)     , NIL } )
			Aadd( aAux, { 'C6_PRODUTO', (cAlias3)->ZF_PRODSRV          , NIL } )
			Aadd( aAux, { 'C6_DESCRI' , cDescPro                      , NIL } )
			Aadd( aAux, { 'C6_QTDVEN' , (cAlias3)->ZF_QUANT           , NIL } )
			Aadd( aAux, { 'C6_QTDLIB' , (cAlias3)->ZF_QUANT           , NIL } )
			Aadd( aAux, { 'C6_PRCVEN' , _nValor                       , NIL } )
			Aadd( aAux, { 'C6_PRUNIT' , _nValor                       , NIL } )
			Aadd( aAux, { 'C6_VALOR'  , (cAlias3)->ZF_QUANT * _nValor , NIL } )
			Aadd( aAux, { 'C6_LOCAL'  , '01'				          , NIL } )
			Aadd( aAux, { 'C6_NFORI'  , ""                            , NIL } )
			Aadd( aAux, { 'C6_SERIORI', ""                            , NIL } )
			Aadd( aAux, { 'C6_ITEMORI', ""                            , NIL } )
			Aadd( aAux, { 'C6_IDENTB6', ""                            , NIL } )
			Aadd( aAux, { 'C6_NUMOP'  , (cAlias3)->ZF_NUMOP           , NIL } )
			Aadd( aAux, { 'C6_ITEMOP' , Subs( (cAlias3)->ZF_NUMOP, 7, 2 ), NIL } )
			Aadd( aAux, { 'C6_TES'    , cTes                          , NIL } )
			Aadd( aAux, { 'C6_CF'     , SF4->F4_CF                    , NIL } )	
				
			Aadd( _aSC6, aAux )
					
			SZF->( dbSkip() )
		Enddo		
				
		SZF->( dbCloseArea() )
											
		cQuery := "SELECT * FROM " + RetSqlName("SD3")
		cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "' AND"
		cQuery += " SUBSTRING( D3_OP, 1, 8 ) = '" + cOrdemP + "' AND"
		cQuery += " D3_GRUPO = 'MANC' AND"
		cQuery += " D3_X_PROD <> ''  AND"
		cQuery += " D3_ESTORNO = ' ' AND"
		cQuery += " D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery( cQuery )
				
		aStruSD3 := SD3->( dbStruct() )
				
		dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias3, .F., .F. )
						
		For nA := 1 To Len( aStruSD3 )
			If aStruSD3[nA, 2] <> "C" .And. aStruSD3[nA, 2] <> "M" .And. FieldPos( aStruSD3[nA, 2] ) != 0
				TCSetField( cAlias3, aStruSD3[nA, 1], aStruSD3[nA, 2], aStruSD3[nA, 3], aStruSD3[nA, 4] )
			EndIf
		Next nA
					
		While (cAlias3)->( !Eof() )
					
			If ! ( SB1->( MsSeek( xFilial("SB1") + (cAlias3)->D3_X_PROD, .F. ) ) )
				(cAlias3)->( dbSkip() )
				Loop
			EndIf
					
			_nValor := U_BuscaAcp ( (cAlias3)->D3_X_PROD, SF1->F1_FORNECE, SF1->F1_LOJA )
					
			If _nValor == 0
				MsgInfo( "O valor do serviço SD3" + (cAlias3)->D3_X_PROD + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Atençao!" )
				Exit
			EndIf
							
			cTes      := Iif( lLiberado, Iif( SA1->A1_CALCCON == 'S', GetMV("MV_X_TSVED"),Iif(Alltrim( SB1->B1_GRUPO ) == "SC",GetMV("MV_X_TSVED"), '902' ) ) , '903' )
					
			SF4->( MsSeek( xFilial("SF4") + cTes ) )
					
					//-- Zero array para adicionar novo item ao pedido.
					
					//-- Troca a Descricao para OP's que foram recusadas.
			If Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
				cDescPro := AllTrim( SB1->B1_DESC ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP ) )
			Else
				cDescPro := SB1->B1_DESC			
			EndIf
					
					//-- Adiciono o Conserto no Pedido de Venda.
			aAux  := {}
			Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")                , NIL } )
			Aadd( aAux, { 'C6_NUM'    , Left( (cAlias3)->D3_OP, 6 )   , NIL } )
			Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0)     , NIL } )
			Aadd( aAux, { 'C6_PRODUTO', (cAlias3)->D3_X_PROD          , NIL } )
			Aadd( aAux, { 'C6_DESCRI' , cDescPro                      , NIL } )
			Aadd( aAux, { 'C6_QTDVEN' , (cAlias3)->D3_QUANT           , NIL } )
			Aadd( aAux, { 'C6_QTDLIB' , (cAlias3)->D3_QUANT           , NIL } )
			Aadd( aAux, { 'C6_PRCVEN' , _nValor                       , NIL } )
			Aadd( aAux, { 'C6_PRUNIT' , _nValor                       , NIL } )
			Aadd( aAux, { 'C6_VALOR'  , (cAlias3)->D3_QUANT * _nValor , NIL } )
			Aadd( aAux, { 'C6_LOCAL'  , (cAlias3)->D3_X_ARMZ          , NIL } )
			Aadd( aAux, { 'C6_NFORI'  , ""                            , NIL } )
			Aadd( aAux, { 'C6_SERIORI', ""                            , NIL } )
			Aadd( aAux, { 'C6_ITEMORI', ""                            , NIL } )
			Aadd( aAux, { 'C6_IDENTB6', ""                            , NIL } )
			Aadd( aAux, { 'C6_NUMOP'  , (cAlias3)->D3_OP              , NIL } )
			Aadd( aAux, { 'C6_ITEMOP' , Subs( (cAlias3)->D3_OP, 7, 2 ), NIL } )
			Aadd( aAux, { 'C6_TES'    , cTes                          , NIL } )
			Aadd( aAux, { 'C6_CF'     , SF4->F4_CF                    , NIL } )
					
			Aadd( _aSC6, aAux )
					
			(cAlias3)->( dbSkip() )
		EndDo	
		(cAlias3)->( dbCloseArea() )
			
		(cAlias2)->(dbCloseArea() )
		
		TR1->( dbSkip() )
	EndDo

_ASC6AUX := {}
NOPCPED   := 3

//-- Inclusao dos Pedidos de Venda.
If Empty( _aSC5 ) .OR. Empty( _aSC6 )¨
	Alert( "Pedido Não Gerado..." )    
ELSE
	_cNumPed := _ASC5[2][2]
	
	SC5->(dBSetOrder(1))
	IF ! ( SC5->(DBSEEK(XFILIAL("SC5")+_cNumPed,.F.)) )
		NOPCPED := 3 // INCLUI
	ELSE 
	    // LOOP PARA ENCONTRAR SE TEM ITEM FATURADO/ABERTO  
	    DBSELECTAREA("SC6")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SC6")+_cNumPed,.F.)
		lexcitped := .F.
		WHILE !EOF() .AND. XFILIAL("SC6") == SC6->C6_FILIAL .AND. SC6->C6_NUM  == _cNumPed
			  if .not.empty(SC6->C6_NOTA)
				 lexcitped = .T.
			  endif
			  SC6->(DBSKIP())                       
		ENDDO
		FOR I := 1 TO LEN(_ASC6)
			_lOk := .T.
			
			_nPos := AScan(_aSC6[I],{|x| Alltrim(Upper(x[1]))=="C6_IDENTB6"})
			If _nPos == 0
				_cIdentB6 := ""
			Else
				_cIdentB6 := _aSC6[I,_nPos,2]
			Endif
			
			_nPos := AScan(_aSC6[I],{|x| Alltrim(Upper(x[1]))=="C6_NUMOP"})
			If _nPos == 0
				_cNumOP := ""
			Else
				_cNumOP := Substr(_aSC6[I,_nPos,2],1,6)
			Endif
			
			_nPos := AScan(_aSC6[I],{|x| Alltrim(Upper(x[1]))=="C6_ITEMOP"})
			If _nPos == 0
				_cItemOP := ""
			Else
				_cItemOP := _aSC6[I,_nPos,2]
			Endif
			
			DBSELECTAREA("SC6")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SC6")+_cNumPed,.F.)
			WHILE !EOF() .AND. XFILIAL("SC6") == SC6->C6_FILIAL .AND. SC6->C6_NUM  == _cNumPed
				NITEM := SC6->C6_ITEM
				If ! Empty(_cNumOP+_cItemOP)
					IF SC6->C6_NUMOP+SC6->C6_ITEMOP == _cNumOP+_cItemOP // OP PELA OP
						_lOk := .F.
					ENDIF
				Endif
				If ! Empty(_cIdentB6)
					IF SC6->C6_IDENTB6 == _cIdentB6
						_lOk := .F.
					ENDIF
				Endif
				// Eliminando item de pedido em aberto
				if empty(SC6->C6_NOTA) .and. lexcitped
				   reclock("SC6",.F.)
				   dbdelete()
				   msunlock()
				endif
				SC6->(DBSKIP())                       
			ENDDO
			If _lOk
				AADD(_ASC6AUX,_ASC6[I])
			Endif
		NEXT
		FOR I := 1 TO LEN(_ASC6AUX)
			NITEM := SOMA1(NITEM,2)
			_ASC6AUX[I][3][2] := NITEM
		NEXT
		_ASC6   := _ASC6AUX
		NOPCPED := 4
	ENDIF
	
	If Empty(_aSC6) .And. nOpcPed == 4
		MsgStop("Não há itens para geracao do pedido. Pedido já gerado. Verifique.","Atencao")
	Else
		MsExecAuto( { |x, y, z| Mata410( x, y, z ) }, _aSC5, _aSC6, NOPCPED )
	Endif
	
	If lMsErroAuto
		If Aviso( "Pergunta", "Pedido de venda nao gerado. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
			MostraErro()
		EndIf
	EndIf
EndIf

SD1->( RestArea( _aAreaSD1 ) )
SB2->( RestArea( _aAreaSB2 ) )
SF4->( RestArea( _aAreaSF4 ) )
SA1->( RestArea( _aAreaSA1 ) )
SA2->( RestArea( _aAreaSA2 ) )
SE4->( RestArea( _aAreaSE4 ) )
RestArea( aArea)

Return Nil
*/