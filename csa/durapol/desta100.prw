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
	AADD(aRegs,{cPerg,"01","Do Cliente          ?"," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate o Cliente       ?"," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"03","Da Data Entrega     ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"04","Ate Data Entrega    ?"," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"05","Da Data Producao    ?"," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"06","Ate a Data Producao ?"," "," ","mv_ch6","D", 08,0,0,"G","","mv_par06",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"07","Status OP           ?"," "," ","mv_ch7","N", 01,0,0,"C","","mv_par07","Produzidas","","","","","Todas"  ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"08","Classificacao       ?"," "," ","mv_ch8","N", 01,0,0,"C","","mv_par08","OP"        ,"","","","","Cliente","","","","","Data Producao","","","","","Data Entrega","","","","","","","","","   ","","","",""          })
	
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
	aAdd(aRotina,{"Pesquisar"    ,"AxPesqui"    ,0,1})    
	aAdd(aRotina,{"Parametros"   ,"U_DST10P()"  ,0,3})
	aAdd(aRotina,{"Gerar Pedido" ,"U_DST10X()"  ,0,2})
	Set Key VK_F12 TO U_DST10P()
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

User Function DST10P()
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

	Do Case
		case mv_par08 == 3
				cSql := "SELECT DISTINCT C2_FORNECE,C2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO,C2_DATRF"
		case mv_par08 == 4
				cSql := "SELECT DISTINCT C2_FORNECE,C2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO,C2_DATPRF"  
		otherwise
    			cSql := "SELECT DISTINCT C2_FORNECE,C2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO"
	EndCase
	
	cSql += "  FROM   "+RetSqlName("SC2")+" SC2"

	cSql += " LEFT JOIN "+RetSqlName("SC6")+" SC6"
	cSql += "   ON SC6.D_E_L_E_T_ = ''"
	cSql += "  AND C6_FILIAL      = C2_FILIAL"
	cSql += "  AND C6_NUMOP       = C2_NUM"
	cSql += "  AND C6_ITEMOP      = C2_ITEM"

	cSql += " WHERE SC2.D_E_L_E_T_ = ''"
	cSql += "   AND C2_FILIAL      = '"+xFilial("SC2")+"'"
	
	if mv_par07 == 1
		cSql += "   AND C2_X_STATU IN('6','9')"
	endif
	
	cSql += "   AND (C6_NOTA IS NULL OR C6_NOTA = '')"
	
	cSql += "   AND C2_FORNECE BETWEEN '"+mv_par01       +"' AND '"+mv_par02+"'"  
	
	cSql += "   AND C2_DATPRF BETWEEN '"  +dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'" 
	
	cSql += "   AND C2_DATRF BETWEEN '"  +dtos(mv_par05) +"' AND '"+dtos(mv_par06)+"'" 
	
   	Do Case
		case mv_par08 == 1
	   			cSql += " ORDER BY C2_NUM"
	   	case mv_par08 == 2
	   			cSql += " ORDER BY C2_FORNECE,C2_LOJA,C2_NUM"
		case mv_par08 == 3
				cSql += " ORDER BY C2_DATRF,C2_FORNECE,C2_LOJA,C2_NUM"
		case mv_par08 == 4
				cSql += " ORDER BY C2_DATPRF,C2_FORNECE,C2_LOJA,C2_NUM"
	Endcase
	
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
	if mv_par08 == 2
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
			if mv_par07 == 1
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

User Function DST10X ()
	
	dbSelectArea("SIX")
	dbCloseArea()
	fErase(cNomSIX+GetDbExtension())
	fErase(cNomSIX+OrdBagExt())
	
	// Reabre SIX
	dbUseArea(.T.,,"SIX"+Substr(cNumEmp,1,2)+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+Substr(cNumEmp,1,2)+"0")

	if DST10M(TMP->C2_NUM)
		AbreTmp(.T.)
	Endif     
	
Return nil      

Static Function DST10M (cColeta)

	Local cQuery   := ""
	Local cArqTR1  := ""
	Local nOpca    := 0
	Local aStruct  := { { "TR1_OK"     , "C", 2                      , 0                     },;
						{ "TR1_STATUS" , "C", 15                     , 0                     },;
      					{ "TR1_CLIENT" , "C", TamSX3('C2_XNREDUZ')[1], 0                     },;
      					{ "TR1_NUM"    , "C", TamSX3('C2_NUM')    [1], 0                     },;
                    	{ "TR1_ITEM"   , "C", TamSX3('C2_ITEM')   [1], 0                     },;
                    	{ "TR1_SERV"   , "C", TamSX3('D1_SERVICO')[1], 0                     },;
                    	{ "TR1_COD"    , "C", TamSX3('D1_COD')    [1], 0                     },;
                    	{ "TR1_CARCAC" , "C", TamSX3('D1_CARCACA')[1], 0                     },;
                    	{ "TR1_NUMFOG" , "C", TamSX3('D1_NUMFOGO')[1], 0                     },;
                    	{ "TR1_SERIEP" , "C", TamSX3('D1_SERIEPN')[1], 0                     },;
                    	{ "TR1_DESEN"  , "C", TamSX3('D1_X_DESEN')[1], 0                     },;
                    	{ "TR1_EMISSA" , "D", TamSX3('C2_EMISSAO')[1], 0                     },;
                    	{ "TR1_DATRF"  , "D", TamSX3('C2_DATRF')  [1], 0                     },;
                    	{ "TR1_MOTORI" , "C", TamSX3('A3_NOME')   [1], 0                     },;
                    	{ "TR1_XMREDI" , "C", TamSX3('C2_XMREDIR')[1], 0                     },;
                    	{ "TR1_XDTCLA" , "D", TamSX3('C2_XDTCLAV')[1], 0                     },;
                    	{ "TR1_OBS"    , "C", TamSX3('D1_X_OBS')  [1], 0                     },;
						{ "TR1_FILIAL" , "C", TamSX3('C2_FILIAL') [1], 0                     },;
                        { "TR1_SEQUEN" , "C", TamSX3('C2_SEQUEN') [1], 0                     },;
                    	{ "TR1_FORNEC" , "C", TamSX3('D1_FORNECE')[1], 0                     },;
                    	{ "TR1_LOJA"   , "C", TamSX3('D1_LOJA')   [1], 0                     },;
                    	{ "TR1_VEND3"  , "C", TamSX3('A1_VEND3')  [1], 0                     },;
                        { "TR1_VEND4"  , "C", TamSX3('A1_VEND4')  [1], 0                     },;
                        { "TR1_VEND5"  , "C", TamSX3('A1_VEND5')  [1], 0                     },; 
                        { "TR1_CONDA1" , "C", TamSX3('A1_COND')   [1], 0                     },; 
                        { "TR1_CALCCO" , "C", TamSX3('A1_CALCCON')[1], 0                     },;
                        { "TR1_COMIS3" , "N", TamSX3('A3_COMIS')  [1], TamSX3('A3_COMIS') [2]},;
                    	{ "TR1_COMIS4" , "N", TamSX3('A3_COMIS')  [1], TamSX3('A3_COMIS') [2]},;
                    	{ "TR1_COMIS5" , "N", TamSX3('A3_COMIS')  [1], TamSX3('A3_COMIS') [2]},;
                    	{ "TR1_CONDF1" , "C", TamSX3('F1_COND')   [1], 0                     },; 
                        { "TR1_QUANT"  , "N", TamSX3('C2_QUANT')  [1], TamSX3('C2_QUANT') [2]},;
                  		{ "TR1_TES"    , "C", TamSX3('D1_TES')    [1], 0                     },;
                    	{ "TR1_VUNIT"  , "N", TamSX3('D1_VUNIT')  [1], TamSX3('D1_VUNIT') [2]},;
                  		{ "TR1_TOTAL"  , "N", TamSX3('D1_TOTAL')  [1], TamSX3('D1_TOTAL') [2]},;
                  		{ "TR1_LOCAL"  , "C", TamSX3('D1_LOCAL')  [1], 0                     },;
                    	{ "TR1_DOC"    , "C", TamSX3('D1_DOC')    [1], 0                     },;
                    	{ "TR1_ITEMD1" , "C", TamSX3('D1_ITEM')   [1], 0                     },;
                    	{ "TR1_SERIE"  , "C", TamSX3('D1_SERIE')  [1], 0                     },;
                    	{ "TR1_IDENTB" , "C", TamSX3('D1_IDENTB6')[1], 0                     },;
                    	{ "TR1_DTENTR" , "D", TamSX3('D1_DTENTRE')[1], 0                     },;
                    	{ "TR1_C6NOTA" , "C", TamSX3('C6_NOTA')   [1], 0                     },;
                    	{ "TR1_GRUPO"  , "C", TamSX3('B1_GRUPO')  [1], 0                     },;
                    	{ "TR1_DESC"   , "C", TamSX3('B1_DESC')   [1], 0                     },;
                    	{ "TR1_TIPO"   , "C", 10                     , 0                     } }
                    	
	Local aCpoShow := { { "TR1_OK"    ,, ""           , "@!" },;
                    	{ "TR1_STATUS",, "Status"     , "@a" },;
                    	{ "TR1_TIPO"  ,, "Tipo"       , "@!" },;
                    	{ "TR1_CLIENT",, "Cliente"    , "@!" },;
                    	{ "TR1_NUM"   ,, "Numero OP"  , "@!" },;
                    	{ "TR1_ITEM"  ,, "Item"       , "@!" },;
                    	{ "TR1_SERV"  ,, "Servico"    , "@!" },;
                    	{ "TR1_COD"   ,, "Produto"    , "@!" },;
                    	{ "TR1_CARCAC",, "Carcaca"    , "@!" },;
                    	{ "TR1_NUMFOG",, "Numero Fogo", "@!" },;
                    	{ "TR1_SERIEP",, "Serie Pneu" , "@!" },;
                    	{ "TR1_DESEN" ,, "Desenho"    , "@!" },;
                    	{ "TR1_EMISSA",, "Entrada"    , "99/99/99" },;
                    	{ "TR1_DATRF" ,, "Liberacao"  , "99/99/99" },;
                    	{ "TR1_MOTORI",, "Motorista"  , "@!" },;
                    	{ "TR1_XMREDI",, "Mot Rej Dir", "@!" },;
                    	{ "TR1_XDTCLA",, "Auto Clave" , "99/99/99" },;
                    	{ "TR1_OBS"   ,, "Observacao" , "@!" },;
                    	{ "TR1_FORNEC",, "Cliente"    , "@!" },;
                    	{ "TR1_LOJA"  ,, "LJ"         , "@!" },;
                    	{ "TR1_CALCCO",, "C"          , "@!" },;
                    	{ "TR1_QUANT" ,, "Qtde"       , "99" },;
                    	{ "TR1_VUNIT" ,, "Unitario"   , "9,999.99" },;
                    	{ "TR1_IDENTB",, "SB6P3"      , "@!" },;
                    	{ "TR1_C6NOTA",, "NFISCAL"    , "@!" } }

	Private cMarca := GetMark()
	Private cAlias1  := GetNextAlias()

	cArqTR1 := CriaTrab( aStruct, .T. )
	dbUseArea( .T.,, cArqTR1, "TR1", .F. )
                             
	cQuery := "SELECT C2_FILIAL, "
	cQuery += "       C2_NUM, "     
	cQuery += "       C2_ITEM, "
	cQuery += "       C2_SEQUEN, "
	cQuery += "       C2_EMISSAO, "
	cQuery += "       C2_XNREDUZ, "
	cQuery += "       C2_X_STATU, "
	cQuery += "       C2_XMREDIR, "
	cQuery += "       C2_XDTCLAV, "
	cQuery += "       C2_DATRF, "
	cQuery += "       C2_QUANT, "
	cQuery += "       D1_FORNECE, "
	cQuery += "       D1_LOJA, "
	cQuery += "       D1_X_DESEN, "
	cQuery += "       D1_CARCACA, "
	cQuery += "       D1_NUMFOGO, "
	cQuery += "       D1_SERIEPN, "
	cQuery += "       D1_X_OBS, "
	cQuery += "       D1_COD, "	
	cQuery += "       D1_SERVICO, "
	cQuery += "       D1_TES, "
	cQuery += "       D1_VUNIT, "
	cQuery += "       D1_TOTAL, "
	cQuery += "       D1_LOCAL, "
	cQuery += "       D1_DOC, "
	cQuery += "       D1_SERIE, "
	cQuery += "       D1_ITEM, "
	cQuery += "       D1_IDENTB6, "
	cQuery += "       D1_DTENTRE, " 
	cQuery += "       A1_VEND3, "
	cQuery += "       A1_VEND4, "               
	cQuery += "       A1_VEND5, "
	cQuery += "       A1_COND, "
	cQuery += "       A1_CALCCON, "
	cQuery += "       V3.A3_NOME  AS V3_NOME, "
	cQuery += "       V3.A3_COMIS AS V3_COMIS, "
	cQuery += "       V4.A3_COMIS AS V4_COMIS, "
	cQuery += "       V5.A3_COMIS AS V5_COMIS, "
	cQuery += "		  F1_COND, "
	cQuery += "       C6_NOTA, "
	cQuery += "       B1_GRUPO, "
	cQuery += "       B1_DESC "
	
	cQuery += "  FROM " + RetSqlName("SC2") + " SC2 "
	
	cQuery += "  LEFT JOIN " + RetSqlName("SF1") + " SF1 "
	cQuery += "    ON SF1.D_E_L_E_T_ = ' ' " 
	cQuery += "   AND F1_FILIAL      = C2_FILIAL "
	cQuery += "   AND F1_DOC         = C2_NUMD1 "
	cQuery += "   AND F1_SERIE       = C2_SERIED1 "
	cQuery += "   AND F1_FORNECE     = C2_FORNECE "
	cQuery += "   AND F1_LOJA        = C2_LOJA "
	cQuery += "   AND F1_TIPO        = 'B' "
	
	cQuery += "  LEFT JOIN " + RetSqlName("SD1") + " SD1 "
	cQuery += "    ON SD1.D_E_L_E_T_ = ''"
	cQuery += "   AND D1_FILIAL      = C2_FILIAL "
	cQuery += "   AND D1_DOC         = C2_NUMD1 "
	cQuery += "   AND D1_ITEM        = C2_ITEMD1 "
	cQuery += "   AND D1_SERIE       = C2_SERIED1"
	cQuery += "   AND D1_FORNECE     = C2_FORNECE"
	cQuery += "   AND D1_LOJA        = C2_LOJA"

	cQuery += "  LEFT JOIN " + RetSqlName("SA1")+" SA1 "
	cQuery += "    ON SA1.D_E_L_E_T_ = '' "
	cQuery += "   AND A1_FILIAL      = '' "
	cQuery += "   AND A1_COD         = D1_FORNECE "
	cQuery += "   AND A1_LOJA        = D1_LOJA " 
	
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+" V3 "
	cQuery += "    ON V3.D_E_L_E_T_  = '' "
	cQuery += "   AND V3.A3_FILIAL   = '' "
	cQuery += "   AND V3.A3_COD      = SA1.A1_VEND3 "   
	
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+" V4 "
	cQuery += "    ON V4.D_E_L_E_T_  = '' "
	cQuery += "   AND V4.A3_FILIAL   = '' "
	cQuery += "   AND V4.A3_COD      = SA1.A1_VEND4 "
	
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+" V5 "
	cQuery += "    ON V5.D_E_L_E_T_  = '' "
	cQuery += "   AND V5.A3_FILIAL   = '' "
	cQuery += "   AND V5.A3_COD      = SA1.A1_VEND5 "   
	
	cQuery += "  LEFT JOIN " + RetSqlName("SC6")+" SC6"
	cQuery += "    ON SC6.D_E_L_E_T_ = ''"
	cQuery += "   AND C6_FILIAL      = C2_FILIAL"
	cQuery += "   AND C6_NUMOP       = C2_NUM"
	cQuery += "   AND C6_ITEMOP      = C2_ITEM"
	cQuery += "   AND C6_PRODUTO     = C2_PRODUTO"
	
	cQuery += "  LEFT JOIN " + RetSqlName("SB1")+" SB1"
	cQuery += "    ON SB1.D_E_L_E_T_ = '' "
	cQuery += "   AND B1_FILIAL      = '' "
	cQuery += "   AND B1_COD         = D1_SERVICO "
	
	cQuery += " WHERE SC2.D_E_L_E_T_ = ''
	cQuery += "   AND C2_FILIAL      = '" + xFilial("SC2") + "' "
	cQuery += "   AND C2_NUM         = '" + cColeta + "' "
	cQuery += " ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"Arq_Col", .F., .T.)
	TCSetField( "Arq_Col" , "C2_EMISSAO"  , "D", 8 )
	TCSetField( "Arq_Col" , "C2_DATRF"    , "D", 8 ) 
	TCSetField( "Arq_Col" , "C2_XDTCLAV"  , "D", 8 )
	TCSetField( "Arq_Col" , "D1_DTENTRE"  , "D", 8 )
	TCSetField( "Arq_Col" , "V3_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Col" , "V4_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Col" , "V5_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Col" , "D1_QUANT"    , "N", 14 , 2)
	TCSetField( "Arq_Col" , "D1_VUNIT"    , "N", 14 , 2)
	TCSetField( "Arq_Col" , "D1_TOTAL"    , "N", 14 , 2)
                 
	dbSelectArea("Arq_Col")
	If Eof()
		dbCloseArea()
		MsgStop( "Nao existem dados para Coleta informada" )
		Return Nil
	EndIf

	While !Eof()
	
		IF RecLock( "TR1", .T. )
	    
	    	// SD1
			TR1->TR1_FORNEC := Arq_Col->D1_FORNECE
			TR1->TR1_LOJA   := Arq_Col->D1_LOJA
			TR1->TR1_DESEN  := Arq_Col->D1_X_DESEN
			TR1->TR1_CARCAC := Arq_Col->D1_CARCACA  
			TR1->TR1_NUMFOG := Arq_Col->D1_NUMFOGO
			TR1->TR1_SERIEP := Arq_Col->D1_SERIEPN
			TR1->TR1_OBS	:= Arq_Col->D1_X_OBS
    		TR1->TR1_COD	:= Arq_Col->D1_COD
    		TR1->TR1_SERV   := Arq_Col->D1_SERVICO
    		TR1->TR1_TES	:= Arq_Col->D1_TES
    		TR1->TR1_VUNIT	:= Arq_Col->D1_VUNIT
    		TR1->TR1_TOTAL	:= Arq_Col->D1_TOTAL
    		TR1->TR1_LOCAL	:= Arq_Col->D1_LOCAL
    		TR1->TR1_DOC	:= Arq_Col->D1_DOC
    		TR1->TR1_ITEMD1 := Arq_Col->D1_ITEM
    		TR1->TR1_SERIE  := Arq_Col->D1_SERIE
    		TR1->TR1_IDENTB := Arq_Col->D1_IDENTB6
    		TR1->TR1_DTENTR := Arq_Col->D1_DTENTRE	    
	    	// SC2
	    	TR1->TR1_FILIAL := Arq_Col->C2_FILIAL
			TR1->TR1_NUM 	:= Arq_Col->C2_NUM
			TR1->TR1_ITEM	:= Arq_Col->C2_ITEM 
			TR1->TR1_SEQUEN	:= Arq_Col->C2_SEQUEN
    		TR1->TR1_QUANT  := Arq_Col->C2_QUANT 
			TR1->TR1_EMISSA := Arq_Col->C2_EMISSAO
			TR1->TR1_CLIENT := Arq_Col->C2_XNREDUZ
			TR1->TR1_STATUS := Arq_Col->C2_X_STATU
			TR1->TR1_XMREDI := Arq_Col->C2_XMREDIR
			TR1->TR1_XDTCLA := Arq_Col->C2_XDTCLAV
			TR1->TR1_DATRF  := Arq_Col->C2_DATRF
			TR1->TR1_QUANT  := Arq_Col->C2_QUANT
			// SA1
			TR1->TR1_VEND3	:= Arq_Col->A1_VEND3
			TR1->TR1_VEND4  := Arq_Col->A1_VEND4
			TR1->TR1_VEND5  := Arq_Col->A1_VEND5
			TR1->TR1_CONDA1 := Arq_Col->A1_COND
			TR1->TR1_CALCCO := Arq_Col->A1_CALCCON
			// SA3    
			TR1->TR1_MOTORI := Arq_Col->V3_NOME
			TR1->TR1_COMIS3 := Arq_Col->V3_COMIS
			TR1->TR1_COMIS4 := Arq_Col->V4_COMIS
			TR1->TR1_COMIS5 := Arq_Col->V5_COMIS
    		// SF1
    		TR1->TR1_CONDF1 := Arq_Col->F1_COND
    		// SC6
    		TR1->TR1_C6NOTA := Arq_Col->C6_NOTA
    		// SB1
    		TR1->TR1_GRUPO  := Arq_Col->B1_GRUPO
    		TR1->TR1_DESC   := Arq_Col->B1_DESC
    		//                                  
			Do Case
				Case substr(Arq_Col->D1_X_DESEN,1,4) == "EXAM" .and. Empty(Arq_Col->C2_XMREDIR)
					vSTATUS := "SEPU Pendente"
				Case !Empty(Arq_Col->C6_NOTA)
					vSTATUS := "Faturado"
				Case Arq_Col->C2_X_STATU = "6"
					vSTATUS := "Liberado"
				Case Arq_Col->C2_X_STATU = "9"
					vSTATUS := "Recusado"
				Case .not.empty(Arq_Col->C2_XDTClav)
					vSTATUS := "AutoClave"            
				Case Arq_Col->C2_X_STATU = "4"
					vSTATUS := "Em Producao"
				Case Arq_Col->C2_X_STATU = "T" .or. Arq_Col->C2_X_STATU = "7"
		    		vSTATUS := "Fora"    
				Case Arq_Col->C2_X_STATU = "A"
					vSTATUS := "Autoriz.Cliente"
				Case Arq_Col->C2_X_STATU = "B"
					vSTATUS := "Aguard.Credito"
				Otherwise
					vSTATUS := "Inspecao"
			EndCase                      	
    		TR1->TR1_STATUS  := vSTATUS     
    		
			TR1->TR1_OK      := iif(vSTATUS $ "Liberado*Recusado",cMarca,"")
			
			if Alltrim(Arq_Col->B1_GRUPO) $ Alltrim(GetMV("MV_X_GRPSC"))
				TR1->TR1_TIPO := "SOCONSERTO"
			else
				TR1->TR1_TIPO := "REFORMA"
			Endif
		
			MsUnLock() 
		Endif		
	    
	    dbSelectArea("Arq_Col")
		dbSkip()
	EndDo
	dbSelectArea("Arq_Col")
	dbCloseArea()
    
	dbSelectArea("TR1")
	dbGotop()
	
	If TR1->( !Eof() )
		DEFINE MSDIALOG oDlg FROM 60, 1 TO 365, 685 TITLE "Geracao Automatica - Selecione as OP's para " PIXEL
		oMark := MsSelect():New( "TR1", "TR1_OK",,aCpoShow,,@cMarca,{020,001,153,343})
		oMark:bAval := {|| MarcaRegs() }
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || nOpca := 1, oDlg:End() }, { || nOpca := 0, oDlg:End() } ) CENTERED
	
		If nOpca == 1
			MsgRun("Limpando pedidos em aberto...",,{ || DST10U (cColeta) })
			MsgRun("Gerando pedido..."            ,,{ || DST10G (cColeta) })
		EndIf
	EndIf
	
    dbSelectArea("TR1")
	dbCloseArea()

	Ferase( cArqTR1 + GetDbExtension() )

Return (nOpca == 1)             

Static Function MarcaRegs()
	if AllTrim(TR1->TR1_STATUS) $ "Liberado*Recusado"
		If RecLock("TR1",.F.)
			TR1->TR1_OK := iif(TR1->TR1_OK=cMarca," ",cMarca)
			MsUnLock()
		Endif
	Endif
Return nil

Static Function DST10G (cColeta)
    
	Local cTes		    := ""
	Local _aSC5         := {}                                        
	Local _aSC6         := {}
	Local aAux          := {}
	Local _nValor       := 0
	Local aStruSD1      := {}
	Local nA            := 0
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.

	dbSelectArea("TR1")
	dbGotop()      
	
 	_aSC5 := 	{ 	{ 'C5_FILIAL' , xFilial("SC5")  , NIL },;
 					{ 'C5_NUM'    , TR1->TR1_NUM    , NIL },;
			   		{ 'C5_TIPO'   , 'N'             , NIL },;
			     	{ 'C5_CLIENTE', TR1->TR1_FORNEC , NIL },;
			      	{ 'C5_LOJACLI', TR1->TR1_LOJA   , NIL },;
			       	{ 'C5_TABELA' , "   "           , NIL },;
			        { 'C5_VEND1'  , "      "        , NIL },;
			        { 'C5_COMIS1' , 0.00            , NIL },;
			        { 'C5_VEND2'  , "      "        , NIL },;
	          		{ 'C5_COMIS2' , 0.00            , NIL },;
			        { 'C5_VEND3'  , TR1->TR1_VEND3  , NIL },;
			        { 'C5_COMIS3' , TR1->TR1_COMIS3 , NIL },;
			        { 'C5_VEND4'  , iif(TR1->TR1_COMIS4=0,"      ",TR1->TR1_VEND4) , NIL },;
		         	{ 'C5_COMIS4' , TR1->TR1_COMIS4 , NIL },;
			        { 'C5_VEND5'  , iif(TR1->TR1_COMIS5=0,"      ",TR1->TR1_VEND5) , NIL },;
			        { 'C5_COMIS5' , TR1->TR1_COMIS5 , NIL },;
			        { 'C5_LIBEROK', 'S'             , NIL },;
			        { 'C5_CONDPAG', Iif(Empty(TR1->TR1_CONDF1), TR1->TR1_CONDA1, TR1->TR1_CONDF1), NIL } }
    
    dbSelectArea("TR1")
	While !Eof()
		                            
		If TR1->TR1_OK != cMarca
			dbSelectArea("TR1")
			dbSkip()
			Loop
		Endif
					
		// Devolução da Carcaça
		aAux    := {}
		Aadd( aAux , { 'C6_FILIAL' , xFilial("SC6")  , NIL } )
		Aadd( aAux , { 'C6_NUM'    , TR1->TR1_NUM    , NIL } )
		Aadd( aAux , { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0) , NIL } )
		Aadd( aAux , { 'C6_PRODUTO', TR1->TR1_COD    , NIL } )
		Aadd( aAux , { 'C6_DESCRI' , TR1->TR1_COD    , NIL } )
		Aadd( aAux , { 'C6_QTDVEN' , 1               , NIL } )
		Aadd( aAux , { 'C6_QTDLIB' , 1               , NIL } )
		Aadd( aAux , { 'C6_PRCVEN' , TR1->TR1_VUNIT  , NIL } )
		Aadd( aAux , { 'C6_PRUNIT' , TR1->TR1_VUNIT  , NIL } )
		Aadd( aAux , { 'C6_VALOR'  , TR1->TR1_TOTAL  , NIL } )
		Aadd( aAux , { 'C6_LOCAL'  , TR1->TR1_LOCAL  , NIL } )
		Aadd( aAux , { 'C6_NFORI'  , TR1->TR1_DOC    , NIL } )
		Aadd( aAux , { 'C6_SERIORI', TR1->TR1_SERIE  , NIL } )
		Aadd( aAux , { 'C6_ITEMORI', TR1->TR1_ITEMD1 , NIL } )
		Aadd( aAux , { 'C6_IDENTB6', TR1->TR1_IDENTB , NIL } )
		Aadd( aAux , { 'C6_ENTREG' , TR1->TR1_DTENTR , NIL } )
		
		SF4->( MsSeek( xFilial("SF4") + TR1->TR1_TES  ) )      //-- Busca TES Nota Fiscal Entrada para descobrir qual TES sera utilizado na Saida para devolucao do produto carcaca
		SF4->( MsSeek( xFilial("SF4") + SF4->F4_TESDV ) )     //-- Posiciona SF4 com o TES que sera utilizado para a saida (devolucao do produto recebido na nota fiscal entrada)
	
		Aadd( aAux , { 'C6_TES'    , SF4->F4_CODIGO  , NIL } )
		Aadd( aAux , { 'C6_NUMOP'  , TR1->TR1_NUM    , NIL } )
		Aadd( aAux , { 'C6_ITEMOP' , TR1->TR1_ITEM   , NIL } )
		Aadd( aAux , { 'C6_CF'     , SF4->F4_CF      , NIL } )
		Aadd( aAux , { 'C6_ITPVSRV', StrZero(Len(_aSC6)+2,2,0) , NIL } )
		Aadd( _aSC6, aAux )

		// Fatura Serviço  
		If  Alltrim(TR1->TR1_Status) == "Liberado" .and. Alltrim(TR1->TR1_TIPO) == "REFORMA"

			_nValor  := U_BuscaAcp ( TR1->TR1_SERV, TR1->TR1_FORNEC, TR1->TR1_LOJA )		

			If _nValor == 0
				MsgInfo( "O valor serviço " + TR1->TR1_SERV + " Não Cadastrado, o item Não sera gravado no Pedido Venda", "Atencao!" )
			Else
				cTes     := GetMV( "MV_X_TSVED" )
				cDescPro := Alltrim(TR1->TR1_DESC) 
				cDescPro += " " + Alltrim(TR1->TR1_COD)  
				cDescPro += " BANDA " + Alltrim(TR1->TR1_DESEN)
				cDescPro += Iif(Alltrim(TR1->TR1_DESEN) <> Alltrim(TR1->TR1_CARCAC), " " + Alltrim(TR1->TR1_CARCAC),"")
				cDescPro += Iif( !Empty( TR1->TR1_NUMFOG ), " NF-" + Alltrim( TR1->TR1_NUMFOG ) , "")  
				cDescPro += Iif( !Empty( TR1->TR1_SERIEP ), " NS-" + Alltrim( TR1->TR1_SERIEP ) , "") 
				
				aAux  := {}
				Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")           , NIL } )
				Aadd( aAux, { 'C6_NUM'    , TR1->TR1_NUM             , NIL } )
				Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0), NIL } )
				Aadd( aAux, { 'C6_PRODUTO', TR1->TR1_SERV            , NIL } )
				Aadd( aAux, { 'C6_DESCRI' , cDescPro                 , NIL } )
				Aadd( aAux, { 'C6_QTDVEN' , 1                        , NIL } )
				Aadd( aAux, { 'C6_QTDLIB' , 1                        , NIL } )
				Aadd( aAux, { 'C6_PRCVEN' , _nValor                  , NIL } )
				Aadd( aAux, { 'C6_PRUNIT' , _nValor                  , NIL } )
				Aadd( aAux, { 'C6_VALOR'  , _nValor                  , NIL } )
				Aadd( aAux, { 'C6_LOCAL'  , TR1->TR1_LOCAL           , NIL } )
				Aadd( aAux, { 'C6_NFORI'  , ""                       , NIL } )
				Aadd( aAux, { 'C6_SERIORI', ""                       , NIL } )
				Aadd( aAux, { 'C6_ITEMORI', ""                       , NIL } )
				Aadd( aAux, { 'C6_IDENTB6', ""                       , NIL } )
				Aadd( aAux, { 'C6_NUMOP'  , TR1->TR1_NUM             , NIL } )
				Aadd( aAux, { 'C6_ITEMOP' , TR1->TR1_ITEM            , NIL } )
				Aadd( aAux, { 'C6_TES'    , cTes                     , NIL } )

				SF4->( MsSeek( xFilial("SF4") + cTes ) )      
				Aadd( aAux, { 'C6_CF'     , SF4->F4_CF               , NIL } )
				Aadd( _aSC6, aAux )
		    Endif
		Endif

		If Alltrim(TR1->TR1_Status) == "Recusado"
			cDescPro := Alltrim(TR1->TR1_COD)  
			cDescPro += " " + Alltrim(TR1->TR1_CARCAC)
			cDescPro += Iif( !Empty( TR1->TR1_NUMFOG ), " NF-" + Alltrim( TR1->TR1_NUMFOG ) , "")  
			cDescPro += Iif( !Empty( TR1->TR1_SERIEP ), " NS-" + Alltrim( TR1->TR1_SERIEP ) , "") 
			aAux  := {}
			Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")           , NIL } )
			Aadd( aAux, { 'C6_NUM'    , TR1->TR1_NUM             , NIL } )
			Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0), NIL } )
			Aadd( aAux, { 'C6_PRODUTO', TR1->TR1_SERV            , NIL } )
			Aadd( aAux, { 'C6_DESCRI' , cDescPro                 , NIL } )
			Aadd( aAux, { 'C6_QTDVEN' , 1                        , NIL } )
			Aadd( aAux, { 'C6_QTDLIB' , 1                        , NIL } )
			Aadd( aAux, { 'C6_PRCVEN' , TR1->TR1_VUNIT           , NIL } )
			Aadd( aAux, { 'C6_PRUNIT' , TR1->TR1_VUNIT           , NIL } )
			Aadd( aAux, { 'C6_VALOR'  , TR1->TR1_VUNIT           , NIL } )
			Aadd( aAux, { 'C6_LOCAL'  , TR1->TR1_LOCAL           , NIL } )
			Aadd( aAux, { 'C6_NFORI'  , ""                       , NIL } )
			Aadd( aAux, { 'C6_SERIORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_ITEMORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_IDENTB6', ""                       , NIL } )
			Aadd( aAux, { 'C6_NUMOP'  , TR1->TR1_NUM             , NIL } )
			Aadd( aAux, { 'C6_ITEMOP' , TR1->TR1_ITEM            , NIL } )
			Aadd( aAux, { 'C6_TES'    , '903'                    , NIL } )
			SF4->( MsSeek( xFilial("SF4") + '903' ) )      
			Aadd( aAux, { 'C6_CF'     , SF4->F4_CF               , NIL } )
			Aadd( _aSC6, aAux )
		Endif
		
		// Fatura Conserto
		cQuery := "SELECT ZF_NUMOP   AS NUMOP, "
		cQuery += "       ZF_PRODSRV AS X_PROD, "
		cQuery += "       ZF_QUANT   AS QUANT, "
		cQuery += "       '01'       AS X_ARMZ "
		cQuery += "  FROM " + RetSqlName("SZF")
		cQuery += " WHERE D_E_L_E_T_ = '' "
		cQuery += "   AND ZF_FILIAL = '" + xFilial("SZF") + "' "
		cQuery += "   AND SUBSTRING(ZF_NUMOP,1,8) = '" + cColeta + TR1->TR1_ITEM + "' "
		cQuery += " UNION  "
		cQuery += "SELECT D3_OP     AS NUMOP, "
		cQuery += "       D3_X_PROD AS X_PROD, "
		cQuery += "       D3_QUANT  AS QUANT, "
		cQuery += "       D3_X_ARMZ AS X_ARMZ "
		cQuery += "  FROM " + RetSqlName("SD3")
		cQuery += " WHERE D_E_L_E_T_ = ' ' "
        cQuery += "   AND D3_FILIAL = '" + xFilial("SD3") + "' "
		cQuery += "   AND SUBSTRING(D3_OP,1,8) = '" + cColeta + TR1->TR1_ITEM + "' "
		cQuery += "   AND D3_GRUPO             = 'MANC' "
		cQuery += "   AND D3_X_PROD            <> '' "
		cQuery += "   AND D3_ESTORNO           = ' ' "
        
		cQuery := ChangeQuery( cQuery )		
		dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), "SQL3", .F., .T. ) 
		TCSetField( "SQL3" , "QUANT"    , "N", 14 , 2)
		
		vSQL3 := 0
		dbSelectArea("SQL3")			
		While !Eof()
							
			_nValor  := U_BuscaAcp ( TR1->TR1_SERV, TR1->TR1_FORNEC, TR1->TR1_LOJA )		
			If _nValor == 0
				MsgInfo( "O valor serviço " + TR1->TR1_SERVICO + " Não Cadastrado, o item Não sera gravado no Pedido Venda", "Atenção!" )
				Return Nil
			Endif
					
			aAux  := {}
			Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")                , NIL } )
			Aadd( aAux, { 'C6_NUM'    , cCOLETA                       , NIL } )
			Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0)     , NIL } )
			Aadd( aAux, { 'C6_PRODUTO', SQL3->X_PROD                  , NIL } )
			
			cDescPro := Alltrim(TR1->TR1_DESC)
			If Alltrim(TR1->TR1_TIPO) == "SOCONSERTO" .and. vSQL3 == 0
				vSQL3 := 1
				cDescPro += " " + Alltrim(TR1->TR1_COD)	
				cDescPro += iif(!Empty(TR1->TR1_NUMFOG), " NF-" + Alltrim( TR1->TR1_NUMFOG ), "")
				cDescPro += iif(!Empty(TR1->TR1_SERIEP), " SP-" + Alltrim( TR1->TR1_SERIEP ), "")
			EndIf
			Aadd( aAux, { 'C6_DESCRI' , cDescPro                 , NIL } )
			Aadd( aAux, { 'C6_QTDVEN' , SQL3->QUANT              , NIL } )
			Aadd( aAux, { 'C6_QTDLIB' , SQL3->QUANT              , NIL } )
			Aadd( aAux, { 'C6_PRCVEN' , _nValor                  , NIL } )
			Aadd( aAux, { 'C6_PRUNIT' , _nValor                  , NIL } )
			Aadd( aAux, { 'C6_VALOR'  , SQL3->QUANT * _nValor    , NIL } )
			Aadd( aAux, { 'C6_LOCAL'  , SQL3->X_ARMZ             , NIL } )
			Aadd( aAux, { 'C6_NFORI'  , ""                       , NIL } )
			Aadd( aAux, { 'C6_SERIORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_ITEMORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_IDENTB6', ""                       , NIL } )
			Aadd( aAux, { 'C6_NUMOP'  , TR1->TR1_NUM             , NIL } )
			Aadd( aAux, { 'C6_ITEMOP' , TR1->TR1_ITEM            , NIL } )
			
			IF Alltrim(TR1->TR1_STATUS) == "Liberado"
				IF Alltrim(TR1->TR1_TIPO) == "SOCONSERTO"
					cTes := '901'
				Else
					If TR1->TR1_CALCCO == "N"
						cTes := '902'
					Else
						cTes := '901'
					Endif
				Endif
			Else
				cTes := '903'
			Endif
			Aadd( aAux, { 'C6_TES'    , cTes                          , NIL } )
			
			SF4->( MsSeek( xFilial("SF4") + cTes ) )      
			Aadd( aAux, { 'C6_CF'     , SF4->F4_CF                    , NIL } )
			Aadd( _aSC6, aAux )
			
			dbSelectArea("SQL3")		
			dbSkip()			
		EndDo	   
		
		dbSelectArea("SQL3")
		dbCloseArea()
		
		dbSelectArea("TR1")		
		dbSkip()
	EndDo
	
	_ASC6AUX := {}
	NOPCPED   := 3

	//-- Inclusao dos Pedidos de Venda.
	If	Empty( _aSC5 ) .And. Empty( _aSC6 )
		Alert( "VAZIO" )
	Else
		_cNumPed := _ASC5[2][2]
	
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(XFILIAL("SC5")+_cNumPed)
		if eof()
			NOPCPED := 3 // INCLUI CABECALHO PEDIDO
		ELSE 
			NOPCPED := 4 // INCLUI ITENS DE PEDIDO
		ENDIF

		If Empty(_aSC6) .And. nOpcPed == 4
			MsgStop("Não há itens para geracao do pedido. Pedido já gerado. Verifique.","Atencao")
		Else
			MsExecAuto( { |x, y, z| Mata410( x, y, z ) }, _aSC5, _aSC6, NOPCPED )
			If lMsErroAuto
				MostraErro ()
			Else
				DST10L(cColeta)
			Endif
		Endif
	Endif  	
Return

Static Function DST10U (cColeta)
        
// Descrição	: Prepara Gera Pedido
//				: Deleta todos os itens de PV não faturados
//				: Deleta todos os itens de liberação de PV não faturados
//				: Recompõe Saldo de material de terceiro em poder da Durapol
// Uso			: Exclusivo Durapol

	Local lSemItemPV	:= .T.
    // Recupera SB6 e SB2
   	dbSelectArea("SC6")                                    
   	dbSetOrder(7)                                      
	dbSeek(xFilial("SC6") + cColeta)
	Do While .not.eof() .and. xFilial("SC6") == SC6->C6_Filial .and. cColeta == SC6->C6_Num	
		IF !Empty(SC6->C6_NOTA)
			dbSelectArea("SC6")
			dbSkip()
			loop
		Endif
		If !Empty(SC6->C6_IDENTB6) 
			dbSelectArea("SB6")
			dbSetOrder(3)                                      
	  		dbSeek(xFilial("SB6") + SC6->C6_IDENTB6)	   	
	   		If Found() .and. RecLock("SB6",.F.)
      			SB6->B6_SALDO := 1
         		SB6->B6_QULIB := 0
           		MsunLock()
            Endif
			dbSelectArea("SC9")
			dbSetOrder(1)                                      
	 		dbSeek(SC6->C6_Filial + SC6->C6_Num + SC6->C6_ITEM)
	  		If found() 
	   			dbSelectArea("SB2")
	     		dbSetOrder(1)
	      		dbSeek(SC9->(C9_FILIAL+C9_PRODUTO+C9_LOCAL))
	    		If Found() .and. RecLock("SB2",.F.)
	     			SB2->B2_RESERVA := SB2->B2_RESERVA - SC9->C9_QTDLIB
	     			SB2->B2_SALPEDI := SB2->B2_SALPEDI + SC9->C9_QTDLIB
	       			MsUnlock()
	     		EndIf
	     		If RecLock("SC9",.F.)
	     			delete
	     			MsunLock()	     		
	     		EndIf		        
	    	EndIf
	    Endif
	    dbSelectArea("SC6")
	    If RecLock("SC6",.F.)
	    	delete
	    	MsUnlock()
	    Endif
		dbSkip()	
	EndDo
	// Remove Item PV aberto
	dbSelectArea("SC6")
   	dbSetOrder(7)                                      
	dbSeek(xFilial("SC6") + cColeta)
	if .not.found()
	// Remove SC5 Sem Item PV
		dbSelectArea("SC5")
	   	dbSetOrder(1)
	   	dbSeek(xfilial("SC5") + cColeta)
	   	If Found() .and. RecLock("SC5",.F.)                               
			delete
		  	MsUnlock()
		EndIf
   	EndIf 	  	
Return nil
               
Static Function DST10L (cColeta)
// Libera Pedido
	dbSelectArea("SC6")
 	dbSetOrder(7)                                      
	dbSeek(xFilial("SC6") + cColeta)
	Do While .not.eof() .and. xFilial("SC6") == C6_Filial .and. cColeta == C6_Num
		
		If !Empty(SC6->C6_Nota) 
			dbSkip()
			loop
		Endif
		
		dbSelectArea("SC9")
		dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
		if Found() .and. Reclock("SC9",.F.)
			SC9->C9_BLEST	:= "  "  
			SC9->C9_BLCRED  := "  "
			msunlock()
		Endif
	 	dbCloseArea("SC9")
	        
		If !Empty(SC6->C6_IDENTB6) 		
			dbSelectArea("SB6")
			dbSetOrder(3)                                      
	  		dbSeek(xFilial("SB6") + SC6->C6_IDENTB6)
	   		If Found() .and. RecLock("SB6",.F.)
      			SB6->B6_QULIB := 1
         		MsunLock()
			Endif
			dbCloseArea("SB6")
		/*	dbSelectArea("SB2")
	  		dbSetOrder(1)
	    	dbSeek(SC9->C9_FILIAL+SC9->C9_PRODUTO+SC9->C9_LOCAL)
	    	If Found() .and. RecLock("SB2",.F.)
	     		SB2->B2_RESERVA := SB2->B2_RESERVA + SC6->C6_QTDVEN
	       		MsUnlock()
	     	EndIf  */   
		EndIf
		dbSelectArea("SC6")
		dbSkip()	
	EndDo
	dbCloseArea("SC6")
Return nil
