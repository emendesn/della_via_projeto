#include 'protheus.ch'  
#include 'dellavia.ch'
#Define VK_F12 123   

User Function DESTA10Z ()
//  Função			  : Gerar Pedido de Venda 
	Private aRotina   := {}
	Private cCadastro := ""
	Private cAliasCab := "TMP"
	Private cMarca    := "X"
	Private cNomSIX   := ""
	Private cNomTmp   := ""
	Private aCpos     := {}
	Private cPerg     := "EST10A"   
	Private lAddPV    := .T.
	Private lNumPV	  := "00"    
	Private lC5Cliente:= ""
	Private lC5LojaCli:= ""
	Private vMsg	  := ""	 
	Private cColeta   := ""
	cPerg    		  := PADR(cPerg,6)
	aRegs    		  := {}	
	AADD(aRegs,{cPerg,"01","Do Cliente           "," "," ","mv_ch1","C", 06,0,0,"G","","mv_par01",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"02","Até o Cliente        "," "," ","mv_ch2","C", 06,0,0,"G","","mv_par02",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","SA1","","","",""          })
	AADD(aRegs,{cPerg,"03","Da Coleta            "," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"04","Até a Coleta         "," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"05","Da Data Entrega      "," "," ","mv_ch5","D", 08,0,0,"G","","mv_par05",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"06","Até a Data Entrega   "," "," ","mv_ch6","D", 08,0,0,"G","","mv_par06",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"07","Status OP            "," "," ","mv_ch7","N", 01,0,0,"C","","mv_par07","Produzidas","","","","","Todas"  ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"08","Ordenar por          "," "," ","mv_ch8","N", 01,0,0,"C","","mv_par08","Ordem Prod","","","","","Cliente","","","","","Data Entrega" ,"","","","","Coleta"      ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"09","Da Data Emissão OP   "," "," ","mv_ch9","D", 08,0,0,"G","","mv_par09",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"10","Até a Data Emissão OP"," "," ","mv_chA","D", 08,0,0,"G","","mv_par10",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	
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
	aAdd(aRotina,{"Parametros"   ,"U_DST10ZP()"  ,0,3})
	aAdd(aRotina,{"Gerar Pedido" ,"U_DST10ZX()"  ,0,2})
	dbSelectArea("SC5")
	aAdd(aRotina,{"Pre-Nota"     ,"U_DST10ZL()" ,0,1})
	Set Key VK_F12 TO U_DST10P()
	MsgRun("Consultando banco de dados...",,{ || AbreTmp() })
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

User Function DST10ZP()
	if Pergunte(cPerg,.T.)
		MsgRun("Consultando banco de dados...",,{ || AbreTmp() })
	Endif
Return nil

Static Function AbreTmp(lSix)
	Local cSql    := ""
	Local aEstru  := {}
	Local aCampos := {}
	Local aIndex  := {}
	Local k       := 0

	Default lSix  := .F.

	Pergunte(cPerg,.F.)

  	Do Case
		case mv_par08 = 1  // Ordem de Produção
			 cSql := "SELECT DISTINCT C2_NUM,C2_XNREDUZ,C2_EMISSAO,ZZ2_CODCLI,ZZ2_LOJA,ZZ2_DOC,ZZ2_SERIE,ZZ2_ENTREG,ZZ2_CONDPG "
		case mv_par08 = 2  // Cliente
			 cSql := "SELECT DISTINCT ZZ2_CODCLI,ZZ2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO,ZZ2_DOC,ZZ2_SERIE,ZZ2_ENTREG,ZZ2_CONDPG " 
		case mv_par08 = 3  // Entrega
			 cSql := "SELECT DISTINCT ZZ2_ENTREG,ZZ2_CODCLI,ZZ2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO,ZZ2_DOC,ZZ2_SERIE,ZZ2_CONDPG " 
		case mv_par08 = 4  // Coleta
			cSql  := "SELECT DISTINCT C2_NUM,ZZ2_SERIE,ZZ2_CODCLI,ZZ2_LOJA,C2_XNREDUZ,C2_EMISSAO,ZZ2_DOC,ZZ2_ENTREG,ZZ2_CONDPG "    
	EndCase
  	cSql += " FROM " + RetSqlName("ZZ2") + " ZZ2 "
  	cSql += " JOIN " + RetSqlName("SF1") + " SF1 "
  	cSql += "   ON SF1.D_E_L_E_T_ = '' "     
	cSql += "  AND F1_FILIAL      = ZZ2_FILIAL "
	cSql += "  AND F1_DOC         = ZZ2_DOC "
	cSql += "  AND F1_SERIE       = ZZ2_SERIE "
	cSql += "  AND F1_FORNECE     = ZZ2_CODCLI "
	cSql += "  AND F1_LOJA        = ZZ2_LOJA "
	cSql += " JOIN " + RetSqlName("SD1") + " SD1 "
	cSql += "   ON SD1.D_E_L_E_T_ = '' "
	cSql += "  AND D1_FILIAL      = F1_FILIAL "
	cSql += "  AND D1_DOC         = F1_DOC "
	cSql += "  AND D1_SERIE       = F1_SERIE "
	cSql += "  AND D1_FORNECE     = F1_FORNECE "
	cSql += "  AND D1_LOJA        = F1_LOJA "
    cSql += " JOIN " + RetSqlName("SB6") + " SB6"
    cSql += "   ON SB6.D_E_L_E_T_ = '' "  
    cSql += "  AND B6_FILIAL      = D1_FILIAL "
    cSql += "  AND B6_DOC         = D1_DOC " 
    cSql += "  AND B6_SERIE       = D1_SERIE "
    cSql += "  AND B6_CLIFOR      = D1_FORNECE "  
    cSql += "  AND B6_LOJA        = D1_LOJA "  
    cSql += "  AND B6_IDENT       = D1_IDENTB6 "  
    cSql += "  AND B6_SALDO       > 0 "
	cSql += " JOIN " + RetSqlName("SC2") + " SC2 "
	cSql += "   ON SC2.D_E_L_E_T_ = ''"
	cSql += "  AND C2_FILIAL      = D1_FILIAL "
	cSql += "  AND C2_NUMD1       = D1_DOC "
    cSql += "  AND C2_SERIED1     = D1_SERIE "
	cSql += "  AND C2_ITEMD1      = D1_ITEM "
	cSql += "  AND C2_NUM        >= '" + mv_par03 + "' "
	cSql += "  AND C2_NUM        <= '" + mv_par04 + "' "   
	cSql += "  AND C2_EMISSAO    >= '" + DTOS(mv_par09) + "' "
	cSql += "  AND C2_EMISSAO    <= '" + DTOS(mv_par10) + "' "
	If mv_par07 = 1
		cSql += "  AND C2_X_STATU     IN('6','9') "
	EndIf
	cSql += " LEFT JOIN "+ RetSqlName("SC6") + " SC6 "
    cSql += "   ON SC6.D_E_L_E_T_ = '' "
   	cSql += "  AND C6_FILIAL      = C2_FILIAL "
	cSql += "  AND C6_NUMOP       = C2_NUM "
    cSql += "  AND C6_ITEMOP      = C2_ITEM " 
    cSql += "WHERE ZZ2.D_E_L_E_T_ = '' "
	cSql += "  AND ZZ2_FILIAL     = '" + xFilial("ZZ2") + "' "
	cSql += "  AND ZZ2_CODCLI    >= '" + mv_par01       + "' "
	cSql += "  AND ZZ2_CODCLI    <= '" + mv_par02       + "' "
	cSql += "  AND ZZ2_ENTREG    >= '" + dtos(mv_par05) + "'
	cSql += "  AND ZZ2_ENTREG    <= '" + dtos(mv_par06) + "'

   	Do Case
		case mv_par08 = 1  // Ordem de Produção
			 cSql += "ORDER BY C2_NUM,C2_XNREDUZ,C2_EMISSAO,ZZ2_CODCLI,ZZ2_LOJA,ZZ2_DOC,ZZ2_SERIE,ZZ2_ENTREG,ZZ2_CONDPG "
		case mv_par08 = 2  // Cliente
			 cSql += "ORDER BY ZZ2_CODCLI,ZZ2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO,ZZ2_DOC,ZZ2_SERIE,ZZ2_ENTREG,ZZ2_CONDPG " 
		case mv_par08 = 3  // Entrega
			 cSql += "ORDER BY ZZ2_ENTREG,ZZ2_CODCLI,ZZ2_LOJA,C2_XNREDUZ,C2_NUM,C2_EMISSAO,ZZ2_DOC,ZZ2_SERIE,ZZ2_CONDPG "  
		case mv_par08 = 4  // Coleta
			 cSql += "ORDER BY ZZ2_DOC,ZZ2_SERIE " 
	EndCase

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

   	Do Case
		case mv_par08 = 1  // Coleta
			 Index on C2_NUM TAG IND1 TO &cNomTmp
		case mv_par08 = 2  // Cliente  
			 Index on C2_XNREDUZ+ZZ2_CODCLI+ZZ2_LOJA+C2_NUM TAG IND1 TO &cNomTmp 
		case mv_par08 = 3  // Entrega
			 Index on DTOS(ZZ2_ENTREG)+ZZ2_CODCLI+ZZ2_LOJA+C2_NUM TAG IND1 TO &cNomTmp 
		case mv_par08 = 4  // Entrega
			 Index on ZZ2_DOC+ZZ2_SERIE TAG IND1 TO &cNomTmp
	EndCase
	
	if lSix 
		dbSelectArea("SIX")
		aEstru := dbStruct()
		dbCloseArea()
		cNomSIX := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
		IndRegua("SIX",cNomSIX,"INDICE+ORDEM",,,"Selecionando Registros...")
	    
		If RecLock("SIX",.T.)
			SIX->INDICE    := "TMP"
			SIX->ORDEM     := "1"
			Do Case
			   case mv_par08 = 1  // Ordem de Produção
			 		SIX->CHAVE     := "C2_NUM"
			 		SIX->DESCRICAO := "Ordem de Produção"
			   case mv_par08 = 2  // Cliente  
			 		SIX->CHAVE     := "C2_XNREDUZ+ZZ2_CODCLI+ZZ2_LOJA+C2_NUM"     
			 		SIX->DESCRICAO := "Nome + Cliente + Loja + Coleta"
		       case mv_par08 = 3  // Entrega
			 		SIX->CHAVE     := "DTOS(ZZ2_ENTREG)+ZZ2_CODCLI+ZZ2_LOJA+C2_NUM"     
			 		SIX->DESCRICAO := "Data Entrega + Cliente + Loja + Coleta"   
			   case mv_par08 = 4  // Coleta
			 		SIX->CHAVE     := "ZZ2_DOC+ZZ2_SERIE"     
			 		SIX->DESCRICAO := "Coleta"
			EndCase
			SIX->DESCSPA   := ""
			SIX->DESCENG   := ""
			SIX->PROPRI    := "U"
			SIX->F3        := ""
			SIX->NICKNAME  := ""
			SIX->SHOWPESQ  := "S"
			MsUnLock()
		EndIf
	Endif
Return nil 

User Function DST10ZX ()
	
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
	Local cMarca := GetMark()
	Local cQdb2    := ""
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
                    	{ "TR1_OBS"    , "C", TamSX3('C2_OBS')    [1], 0                     },;
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
                    	{ "TR1_PGRUPO" , "C", TamSX3('B1_GRUPO')  [1], 0                     },;
                    	{ "TR1_PDESC"  , "C", TamSX3('B1_DESC')   [1], 0                     },;
                    	{ "TR1_SGRUPO" , "C", TamSX3('B1_GRUPO')  [1], 0                     },;
                    	{ "TR1_SDESC"  , "C", TamSX3('B1_DESC')   [1], 0                     },;
                    	{ "TR1_MSG"    , "C", 40                     , 0                     },;
                    	{ "TR1_TIPO"   , "C", 10                     , 0                     } }
                    	
	Local aCpoShow := { { "TR1_OK"    ,, ""           , "@!" },;
                    	{ "TR1_STATUS",, "Status"     , "@a" },;
                    	{ "TR1_TIPO"  ,, "Tipo"       , "@!" },;
                    	{ "TR1_CLIENT",, "Cliente"    , "@!" },; 
                    	{ "TR1_MSG"   ,, "Ocorência"  , "@!" },;
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
                    	{ "TR1_CALCCO",, "CC"         , "@!" },;
                    	{ "TR1_QUANT" ,, "Qtde"       , "99" },;
                    	{ "TR1_VUNIT" ,, "Unitario"   , "9,999.99" },;
                    	{ "TR1_IDENTB",, "SB6P3"      , "@!" },;
                    	{ "TR1_C6NOTA",, "NFISCAL"    , "@!" } }

	cQdb2 := "SELECT C2_FILIAL, "
	cQdb2 += "       C2_NUM, "     
	cQdb2 += "       C2_ITEM, "
	cQdb2 += "       C2_SEQUEN, "
	cQdb2 += "       C2_EMISSAO, "
	cQdb2 += "       C2_XNREDUZ, "
	cQdb2 += "       C2_X_STATU, "
	cQdb2 += "       C2_XMREDIR, "
	cQdb2 += "       C2_XDTCLAV, "
	cQdb2 += "       C2_DATRF, "
	cQdb2 += "       C2_QUANT, "
	cQdb2 += "       C2_OBS, "
	cQdb2 += "       F1_FORNECE, "
	cQdb2 += "       F1_LOJA, "
	cQdb2 += "		 F1_COND, "
	cQdb2 += "       D1_X_DESEN, "
	cQdb2 += "       D1_CARCACA, "
	cQdb2 += "       D1_NUMFOGO, "
	cQdb2 += "       D1_SERIEPN, "
	cQdb2 += "       D1_COD, "	
	cQdb2 += "       D1_SERVICO, "
	cQdb2 += "       D1_TES, "
	cQdb2 += "       D1_VUNIT, "
	cQdb2 += "       D1_TOTAL, "
	cQdb2 += "       D1_LOCAL, "
	cQdb2 += "       D1_DOC, "
	cQdb2 += "       D1_SERIE, "
	cQdb2 += "       D1_ITEM, "
	cQdb2 += "       D1_IDENTB6, "
	cQdb2 += "       D1_DTENTRE, "
	cQdb2 += "       E4_COND, " 
	cQdb2 += "       A1_VEND3, "
	cQdb2 += "       A1_VEND4, "               
	cQdb2 += "       A1_VEND5, "
	cQdb2 += "       A1_COND, "
	cQdb2 += "       A1_CALCCON, "
	cQdb2 += "       V3.A3_NOME  AS V3_NOME, "
	cQdb2 += "       V3.A3_COMIS AS V3_COMIS, "
	cQdb2 += "       V4.A3_COMIS AS V4_COMIS, "
	cQdb2 += "       V5.A3_COMIS AS V5_COMIS, "
	cQdb2 += "       C6_NOTA, "
	cQdb2 += "       B1P.B1_GRUPO  AS P_GRUPO, "
	cQdb2 += "       B1P.B1_DESC   AS P_DESC, "
	cQdb2 += "       B1P.B1_MSBLQL AS P_MSBLQL, "
	cQdb2 += "       B1S.B1_GRUPO  AS S_GRUPO, "
	cQdb2 += "       B1S.B1_DESC   AS S_DESC, " 
	cQdb2 += "       B1S.B1_MSBLQL AS S_MSBLQL"
	cQdb2 += "  FROM " + RetSqlName("SC2") + " SC2 "
	cQdb2 += "  LEFT JOIN " + RetSqlName("SF1") + " SF1 "
	cQdb2 += "    ON SF1.D_E_L_E_T_ = ' ' " 
	cQdb2 += "   AND F1_FILIAL      = C2_FILIAL "
	cQdb2 += "   AND F1_DOC         = C2_NUMD1 "
	cQdb2 += "   AND F1_SERIE       = C2_SERIED1 "
	cQdb2 += "   AND F1_FORNECE     = C2_FORNECE "
	cQdb2 += "   AND F1_LOJA        = C2_LOJA "
	cQdb2 += "   AND F1_TIPO        = 'B' "
	
	cQdb2 += "  JOIN " + RetSqlName("SD1") + " SD1 "
	cQdb2 += "    ON SD1.D_E_L_E_T_ = ''"
	cQdb2 += "   AND D1_FILIAL      = C2_FILIAL "
	cQdb2 += "   AND D1_DOC         = C2_NUMD1 "
	cQdb2 += "   AND D1_ITEM        = C2_ITEMD1 "
	cQdb2 += "   AND D1_SERIE       = C2_SERIED1"
	cQdb2 += "   AND D1_FORNECE     = C2_FORNECE"
	cQdb2 += "   AND D1_LOJA        = C2_LOJA"

	cQdb2 += "  JOIN " + RetSqlName("SA1") + " SA1 "
	cQdb2 += "    ON SA1.D_E_L_E_T_ = '' "
	cQdb2 += "   AND A1_FILIAL      = '' "
	cQdb2 += "   AND A1_COD         = D1_FORNECE "
	cQdb2 += "   AND A1_LOJA        = D1_LOJA " 
	
	cQdb2 += "  LEFT JOIN " + RetSqlName("SB1") + " B1P"
	cQdb2 += "    ON B1P.D_E_L_E_T_ = '' "
	cQdb2 += "   AND B1P.B1_FILIAL  = '' "
	cQdb2 += "   AND B1P.B1_COD     = D1_COD "
	
	cQdb2 += "  LEFT JOIN " + RetSqlName("SB1") + " B1S"
	cQdb2 += "    ON B1S.D_E_L_E_T_ = '' "
	cQdb2 += "   AND B1S.B1_FILIAL  = '' "
	cQdb2 += "   AND B1S.B1_COD     = D1_SERVICO "
	
	cQdb2 += "  LEFT JOIN " + RetSqlName("SA3")+" V3 "
	cQdb2 += "    ON V3.D_E_L_E_T_  = '' "
	cQdb2 += "   AND V3.A3_FILIAL   = '' "
	cQdb2 += "   AND V3.A3_COD      = SA1.A1_VEND3 "   
	
	cQdb2 += "  LEFT JOIN " + RetSqlName("SA3")+" V4 "
	cQdb2 += "    ON V4.D_E_L_E_T_  = '' "
	cQdb2 += "   AND V4.A3_FILIAL   = '' "
	cQdb2 += "   AND V4.A3_COD      = SA1.A1_VEND4 "
	
	cQdb2 += "  LEFT JOIN " + RetSqlName("SA3")+" V5 "
	cQdb2 += "    ON V5.D_E_L_E_T_  = '' "
	cQdb2 += "   AND V5.A3_FILIAL   = '' "
	cQdb2 += "   AND V5.A3_COD      = SA1.A1_VEND5 "   
	
	cQdb2 += "  LEFT JOIN " + RetSqlName("SC6")+" SC6"
	cQdb2 += "    ON SC6.D_E_L_E_T_ = ''"
	cQdb2 += "   AND C6_FILIAL      = C2_FILIAL"
	cQdb2 += "   AND C6_NUMOP       = C2_NUM"
	cQdb2 += "   AND C6_ITEMOP      = C2_ITEM"
	cQdb2 += "   AND C6_PRODUTO     = C2_PRODUTO" 
	
	cQdb2 += "  LEFT JOIN " + RetSqlName("SE4")+" SE4"
	cQdb2 += "    ON SE4.D_E_L_E_T_ = ''"
	cQdb2 += "   AND E4_FILIAL      = ''"
	cQdb2 += "   AND E4_CODIGO      = F1_COND" 
	
	cQdb2 += " WHERE SC2.D_E_L_E_T_ = ''
	cQdb2 += "   AND C2_FILIAL      = '" + xFilial("SC2") + "' "
	cQdb2 += "   AND C2_NUM         = '" + cColeta + "' "
	cQdb2 += " ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN"

	cQdb2 := ChangeQuery(cQdb2)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQdb2),"Arq_Db2", .F., .T.)
	
	TCSetField( "Arq_Db2" , "C2_EMISSAO"  , "D", 8 )
	TCSetField( "Arq_Db2" , "C2_DATRF"    , "D", 8 ) 
	TCSetField( "Arq_Db2" , "C2_XDTCLAV"  , "D", 8 )
	TCSetField( "Arq_Db2" , "D1_DTENTRE"  , "D", 8 )
	TCSetField( "Arq_Db2" , "V3_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Db2" , "V4_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Db2" , "V5_COMIS"    , "N", 14 , 2)
	TCSetField( "Arq_Db2" , "D1_QUANT"    , "N", 14 , 2)
	TCSetField( "Arq_Db2" , "D1_VUNIT"    , "N", 14 , 2)
	TCSetField( "Arq_Db2" , "D1_TOTAL"    , "N", 14 , 2)
                 
	lLibRec 	:= .F.
    lAddPV    	:= .F.
	lNumPV	  	:= "00"    
	lC5Cliente	:= ""
	lC5LojaCli	:= ""
	
	dbSelectArea("Arq_Db2")
	dbGoTop()
	If Eof()
		vMsg := "Vazio"
	Else	
		cArqTR1 := CriaTrab( aStruct, .T. )
		dbUseArea( .T.,, cArqTR1, "TR1", .F. )
	EndIf
    dbSelectArea("Arq_DB2")
	While !Eof()    
	
		vMsg := ""
		// Status OP
		Do Case 
			Case substr(Arq_Db2->D1_X_DESEN,1,4) == "EXAM" .and. Empty(Arq_Db2->C2_XMREDIR)
				vSTATUS := "SEPU Pendente"
				vMsg	:= "Aguardando aprovação de Exame"
			Case !Empty(Arq_Db2->C6_NOTA)
				vSTATUS := "Faturado"
			Case Arq_Db2->C2_X_STATU = "6" 
				vSTATUS := "Liberado"
				vMsg	:= "OK"
				lLibRec := .T. 
			Case Arq_Db2->C2_X_STATU = "9"
				vSTATUS := "Recusado"
				vMsg	:= "OK"
				lLibRec := .T.
			Case .not.empty(Arq_Db2->C2_XDTClav)
				vSTATUS := "AutoClave"            
			Case Arq_Db2->C2_X_STATU = "4"
				vSTATUS := "Em Producao"
			Case Arq_Db2->C2_X_STATU = "T" .or. Arq_Db2->C2_X_STATU = "7"
		 		vSTATUS := "Fora"
		 		If (date()-Arq_Db2->D1_DtEntre)>7
		 			vMsg:= "Parado a mais de 7 dias"
		 		EndIf
			Case Arq_Db2->C2_X_STATU = "A"
				vSTATUS := "Autoriz.Cliente"
			Case Arq_Db2->C2_X_STATU = "B"
				vSTATUS := "Aguard.Credito"
				If (date()-Arq_Db2->D1_DtEntre)>7
		 			vMsg:= "Parado a mais de 7 dias"
		 		EndIf 
			Otherwise
				vSTATUS := "Inspecao"
				If (date()-Arq_Db2->D1_DtEntre)>7
		 			vMsg:= "Parado a mais de 7 dias"
		 		EndIf
		EndCase
    	
    	
    	// Tipo Serviço	
		Do Case
			Case Alltrim(Arq_Db2->S_GRUPO) $ Alltrim(GetMV("MV_X_GRPSC"))
				vTIPO 	:= "SOCONSERTO"
			Case Posicione( "SB1", 1, xFilial("SB1") + AllTrim(Arq_Db2->D1_SERVICO), "B1_X_ESPEC" ) == "F "
				vTIPO 	:= "RECAPAGEM"
			Case Posicione( "SB1", 1, xFilial("SB1") + AllTrim(Arq_Db2->D1_SERVICO), "B1_X_ESPEC" ) == "Q "
				vTIPO 	:= "RECAUCHUT."
			Otherwise
		 		vTIPO 	:= "INCORRETO"
		   		vMsg	:= "Verifique B1_X_Espec"
		EndCase     
		// Verifica Preço Recapagem/Recauchutagem
		                                                                             
		
		If vTIPO $ "RECAPAGEM*RECAUCHUT."  
			If U_BuscaAcp ( Arq_Db2->D1_SERVICO, Arq_Db2->F1_FORNECE, Arq_Db2->F1_LOJA ) = 0		
				vMsg 	:= "Preço serviço não cadastrado"
			EndIf
		EndIf
		
		If Arq_Db2->P_MSBLQL = "1"
			vMsg := "Código Carcaça com Bloqueio"  
		Endif        
		
		If Arq_Db2->S_MSBLQL = "1"
			vMsg := "Código Serviço com Bloqueio" 
		Endif        
		                       
		If Empty(Arq_Db2->A1_Cond) .and. Empty(Arq_Db2->E4_Cond)
			vMsg := "Condição de Pagamento Não Informado"
		EndIf
		// Verifica Banda/Conserto
		nBand := 0
		nCons := 0	
		DoSQL3 (Arq_Db2->C2_NUM,Arq_Db2->C2_ITEM,"1")
		dbSelectArea("SQL3")
		dbGoTop()
		While !Eof() 
			
			If SQL3->GRUPO $ 'CI*SC'
				nCons := nCons + 1
				If U_BuscaAcp ( SQL3->X_PROD, Arq_Db2->F1_FORNECE, Arq_Db2->F1_LOJA ) = 0
					vMsg := "Serviço "+AllTrim(SQL3->X_PROD)+" Sem Preço Cadastrado"
				EndIf
		   	EndIf
		   	
		   	If SQL3->GRUPO = 'BAND'
		   		If !("EXAM" $ Arq_Db2->D1_X_Desen)
					nBand 	:= nBand + 1                                     
					vDesCol := AllTrim(Arq_Db2->D1_X_Desen)
					vCodBan := AllTrim(SQL3->X_PROD)
					vDesLan := AllTrim(Posicione( "SB1", 1 , xFilial("SB1") + vCodBan , "B1_XDESENH" )) 
					If StrTran(StrTran(vDesLan,"-","")," ","") <> StrTran(StrTran(vDesCol,"-","")," ","")  
						vMsg := "Aviso! DC="+vDesCol+" DL="+vDesLan+" BL="+vCodBan 
					EndIf
				EndIf
			EndIf                                                   
			
			dbSelectArea("SQL3")
			dbSkip()
		EndDo
		dbSelectArea("SQL3")
		dbCloseArea("SQL3")
  		// Verifica Apontamento de Serviços
  		
  		Do Case
			Case nBand > 1 .and. "REPROC" $ TR1->TR1_OBS 
				vMsg := "Banda Lançada + 1 vez"
				// Fazer Reprocesso
			Case vStatus = "Liberado"   .and. vTIPO = "RECAPAGEM"  .and. nBand = 0
				vMsg := "Banda Não Lançada"
			Case vStatus = "Liberado"   .and. vTIPO = "SOCONSERTO" .and. nCons = 0
				vMsg := "Serviço Só Conserto Não Lançado"
			Case vTipo   = "SOCONSERTO" .and. nBand > 0
				vMsg := "Banda Lançada em Só Conserto"  
		EndCase
		
		If RecLock( "TR1", .T. )
	                                                              
	 		// SF1
			TR1->TR1_FORNEC := Arq_Db2->F1_FORNECE
			TR1->TR1_LOJA   := Arq_Db2->F1_LOJA
			TR1->TR1_CONDF1 := Arq_Db2->F1_COND
   			// SD1
			TR1->TR1_DESEN  := Arq_Db2->D1_X_DESEN
			TR1->TR1_CARCAC := Arq_Db2->D1_CARCACA  
			TR1->TR1_NUMFOG := Arq_Db2->D1_NUMFOGO
			TR1->TR1_SERIEP := Arq_Db2->D1_SERIEPN
			TR1->TR1_COD	:= Arq_Db2->D1_COD
    		TR1->TR1_SERV   := Arq_Db2->D1_SERVICO
    		TR1->TR1_TES	:= Arq_Db2->D1_TES
    		TR1->TR1_VUNIT	:= Arq_Db2->D1_VUNIT
    		TR1->TR1_TOTAL	:= Arq_Db2->D1_TOTAL
    		TR1->TR1_LOCAL	:= Arq_Db2->D1_LOCAL
    		TR1->TR1_DOC	:= Arq_Db2->D1_DOC
    		TR1->TR1_ITEMD1 := Arq_Db2->D1_ITEM
    		TR1->TR1_SERIE  := Arq_Db2->D1_SERIE
    		TR1->TR1_IDENTB := Arq_Db2->D1_IDENTB6
    		TR1->TR1_DTENTR := Arq_Db2->D1_DTENTRE	    
	    	// SC2
	    	TR1->TR1_FILIAL := Arq_Db2->C2_FILIAL
			TR1->TR1_NUM 	:= Arq_Db2->C2_NUM
			TR1->TR1_ITEM	:= Arq_Db2->C2_ITEM 
			TR1->TR1_SEQUEN	:= Arq_Db2->C2_SEQUEN
   			TR1->TR1_QUANT  := Arq_Db2->C2_QUANT 
			TR1->TR1_EMISSA := Arq_Db2->C2_EMISSAO
			TR1->TR1_CLIENT := Arq_Db2->C2_XNREDUZ
			TR1->TR1_STATUS := Arq_Db2->C2_X_STATU
			TR1->TR1_XMREDI := Arq_Db2->C2_XMREDIR
			TR1->TR1_XDTCLA := Arq_Db2->C2_XDTCLAV
			TR1->TR1_DATRF  := Arq_Db2->C2_DATRF
			TR1->TR1_QUANT  := Arq_Db2->C2_QUANT
			TR1->TR1_OBS	:= Arq_Db2->C2_OBS
			// SA1
			TR1->TR1_VEND3	:= Arq_Db2->A1_VEND3
			TR1->TR1_VEND4  := Arq_Db2->A1_VEND4
			TR1->TR1_VEND5  := Arq_Db2->A1_VEND5
			TR1->TR1_CONDA1 := Arq_Db2->A1_COND
			TR1->TR1_CALCCO := Arq_Db2->A1_CALCCON
			// SA3    
			TR1->TR1_MOTORI := Arq_Db2->V3_NOME
			TR1->TR1_COMIS3 := Arq_Db2->V3_COMIS
			TR1->TR1_COMIS4 := Arq_Db2->V4_COMIS
			TR1->TR1_COMIS5 := Arq_Db2->V5_COMIS
   			// SC6
    		TR1->TR1_C6NOTA := Arq_Db2->C6_NOTA
    		// SB1
    		TR1->TR1_PGRUPO := Arq_Db2->P_GRUPO
    		TR1->TR1_PDESC  := Arq_Db2->P_DESC
    		TR1->TR1_SGRUPO := Arq_Db2->S_GRUPO
    		TR1->TR1_SDESC  := Arq_Db2->S_DESC
    		TR1->TR1_MSG	:= vMsg                  	
    		TR1->TR1_STATUS := vSTATUS     
			TR1->TR1_TIPO 	:= vTIPO
			TR1->TR1_OK     := iif(vSTATUS $ "Liberado*Recusado",cMarca,"") 				
			MsUnLock() 
		Endif		
	                                      
	    dbSelectArea("Arq_Db2")
		dbSkip()
	EndDo
	dbSelectArea("Arq_Db2")
	dbCloseArea()
    
	if vMsg == "Vazio"
		If Aviso( "Pergunta", "Cadastros inconsistentes. Deseja visualizar ?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
			U_DST10ZC(cColeta)
		Endif
	Else
		dbSelectArea("TR1")
		dbGotop()
		If TR1->( !Eof() )
			DEFINE MSDIALOG oDlg FROM 60, 1 TO 365, 685 TITLE "Geracao Automatica - Selecione as OP's para " PIXEL
			oMark := MsSelect():New( "TR1", "TR1_OK",,aCpoShow,,@cMarca,{020,001,153,343})
			oMark:bAval := {|| MarcaRegs() }
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || nOpca := 1, oDlg:End() }, { || nOpca := 0, oDlg:End() } ) CENTERED
			If nOpca == 1 .and. lLibRec
				MsgRun("Eliminando itens de pedidos em aberto...",,{ || DST10U (cColeta) })
				MsgRun("Gerando pedido ... Aguarde"              ,,{ || DST10G (cColeta) })  
			EndIf
		EndIf   
		dbSelectArea("TR1")
		dbCloseArea()
		Ferase( cArqTR1 + GetDbExtension() )
	EndIf

Return (nOpca == 1)             

Static Function MarcaRegs()
	if AllTrim(TR1->TR1_STATUS) $ "Liberado*Recusado"
		If RecLock("TR1",.F.)
			TR1->TR1_OK := iif(AllTrim(TR1->TR1_OK)=cMarca,"",cMarca)
			MsUnLock()
		Endif
	Endif
Return nil     

Static Function DoSQL3 (vOP,vItOP,vX)

	cQdb2 := "SELECT ZF_NUMOP   AS NUMOP, "
	cQdb2 += "       ZF_PRODSRV AS X_PROD, "
	cQdb2 += "       ZF_QUANT   AS QUANT, "
	cQdb2 += "       '01'       AS X_ARMZ,"
	cQdb2 += "       B1_GRUPO   AS GRUPO, "
	cQdb2 += "       B1_DESC    AS DESC "
	cQdb2 += "  FROM " + RetSqlName("SZF") + " SZF, "
	cQdb2 +=             RetSqlName("SB1") + " SB1 "
	cQdb2 += " WHERE SZF.D_E_L_E_T_ = '' "
	cQdb2 += "   AND SB1.D_E_L_E_T_ = '' "
	cQdb2 += "   AND ZF_FILIAL = '" + xFilial("SZF") + "' "
	cQdb2 += "   AND B1_FILIAL = '' "
	cQdb2 += "   AND ZF_NUMOP  = '" + vOP + vItOP + "001' "
	cQdb2 += "   AND ZF_PRODSRV = B1_COD"
	cQdb2 += " UNION  "
	cQdb2 += "SELECT D3_OP     AS NUMOP, "
	cQdb2 += "       D3_X_PROD AS X_PROD, "
	cQdb2 += "       D3_QUANT  AS QUANT, "
	cQdb2 += "       D3_X_ARMZ AS X_ARMZ, "
	cQdb2 += "       B1_GRUPO  AS GRUPO, "
	cQdb2 += "       B1_DESC  AS DESC "
	cQdb2 += "  FROM " + RetSqlName("SD3") + " SD3, "
	cQdb2 +=             RetSqlName("SB1") + " SB1  "
	cQdb2 += " WHERE SD3.D_E_L_E_T_ = '' "
	cQdb2 += "   AND SB1.D_E_L_E_T_ = '' "
 	cQdb2 += "   AND D3_FILIAL      = '" + xFilial("SD3") + "' "
  	cQdb2 += "   AND B1_FILIAL      = '' "
	cQdb2 += "   AND D3_OP          = '" +  vOP + vItOP + "001' "
	cQdb2 += "   AND D3_ESTORNO     = '' "
	cQdb2 += "   AND D3_X_PROD      = B1_COD"
		
	cQdb2 := ChangeQuery( cQdb2 )		
	dbUseArea( .T., "TOPCONN", TCGenQry(,, cQdb2), "SQL3", .F., .T. ) 
	TCSetField( "SQL3" , "QUANT"    , "N", 14 , 2)
		
Return nil

Static Function DST10U (cColeta)
        
	// Descrição	: Prepara Gera Pedido
	//				: Deleta todos os itens de PV não faturados
	//				: Deleta todos os itens de liberação de PV não faturados
	//				: Recompõe Saldo de material de terceiro em poder da Durapol
	// Uso			: Exclusivo Durapol

	// Remove Item PV aberto
    // Recupera SB6 e SB2
   	dbSelectArea("SC6")                                    
   	dbSetOrder(7)                                      
	dbSeek(xFilial("SC6") + cColeta)
	lAddPV := .T.
	Do While .not.eof() .and. xFilial("SC6") == SC6->C6_Filial .and. cColeta == SC6->C6_Num	
		If !Empty(SC6->C6_NOTA)
			lAddPV := .F.
			If val(lNumPV) < val(SC6->C6_Item)
				lNumPV := SC6->C6_Item
			EndIf
			dbSelectArea("SC6")
			dbSkip()
			loop
		EndIf
		If !Empty(SC6->C6_IDENTB6) 
			dbSelectArea("SB6")
			dbSetOrder(3)                                      
	  		dbSeek(xFilial("SB6") + SC6->C6_IDENTB6)	   	
	   		If Found()
	   		 	If RecLock("SB6",.F.)
      				SB6->B6_SALDO := 1
         			SB6->B6_QULIB := 0
           			MsunLock()
           		EndIf
           	Else
           		MsgInfo( "Sem SB6 carcaça de terceiro, IDENTB6: " + SC6->C6_IDENTB6, "Atenção!" )  
            Endif
			dbSelectArea("SC9")
			dbSetOrder(1)                                      
	 		dbSeek(SC6->C6_Filial + SC6->C6_Num + SC6->C6_ITEM)
	  		If found() 
	   			dbSelectArea("SB2")
	     		dbSetOrder(1)
	      		dbSeek(SC9->(C9_FILIAL+C9_PRODUTO+C9_LOCAL))
	    		If Found()
	    			If Empty(SC9->C9_NFISCAL)
	    				If RecLock("SB2",.F.)
	     					SB2->B2_RESERVA := SB2->B2_RESERVA - SC9->C9_QTDLIB
	     					SB2->B2_SALPEDI := SB2->B2_SALPEDI + SC9->C9_QTDLIB
	       					MsUnlock()
	       					If RecLock("SC9",.F.)
	     						delete
	     						MsunLock()	     		
	     					EndIf
	       				EndIf
	       			Else
	       				MsgInfo( "Liberação SC9 Ja Faturada, OP: " + TR1->TR1_Num + " It:" + TR1->TR1_Item, "Atenção!" )
					EndIf
	     		EndIf		        
	    	EndIf
	    EndIf
	    dbSelectArea("SC6")
	    If RecLock("SC6",.F.)
	    	delete
	    	MsUnlock()
	    Endif
		dbSkip()	
	EndDo
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xfilial("SC5") + cColeta)
	If found() .and. lAddPV .and. RecLock("SC5",.F.)                               
		delete
		MsUnlock()
	Else    
		lC5Cliente := SC5->C5_Cliente
	    lC5LojaCli := SC5->C5_LojaCli
   	EndIf 	  
   	// Restaura SB6 invalido
	dbSelectArea("SB6")
 	dbSetOrder(5)
 	dbSeek(xFilial("SB6")+TR1->TR1_Doc+TR1->TR1_Serie)
 	Do While .not.eof() .and. xFilial("SB6") == SB6->B6_Filial .and. SB6->B6_Doc = TR1->TR1_Doc .and. SB6->B6_Serie = TR1->TR1_Serie 
 		dbSelectArea("SC6")   
 		dbSetOrder(9)
 		dbSeek(xFilial("SC6")+SB6->B6_Doc+SB6->B6_Serie+SB6->B6_Ident) 
 		If .not.found() .or. Empty(SC6->C6_Nota) 
 			dbSelectArea("SB6")
 			If RecLock("SB6",.F.)
 				SB6->B6_SALDO := 1
    			SB6->B6_QULIB := 0
 				MsunLock()
 			EndIf
 		EndIf
 		dbSelectArea("SB6")
 		dbSkip()                                      
 	EndDo
   	// Remove SC9 invalido
   	dbSelectArea("SC9")
	dbSetOrder(1)                                      
	dbSeek(xfilial("SC9") + cColeta) 
	Do While .not.eof() .and. xFilial("SC9") == SC9->C9_Filial .and. cColeta == SC9->C9_PEDIDO
		If Empty(SC9->C9_NFISCAL) .and. RecLock("SC9",.F.)
			delete
	 		MsunLock()	     		
		EndIf
		dbSkip()
	EndDo
	
Return nil
               
Static Function DST10G (cColeta)
    
	Local cTes		    := ""
	Local _aSC5         := {}                                        
	Local _aSC6         := {}
	Local aAux          := {}
	Local _nValor       := 0
	Private lMsHelpAuto := .F.
	Private lMsErroAuto := .F.

	dbSelectArea("TR1")
	dbGotop()      	
 	_aSC5 := 	{ 	{ 'C5_FILIAL' , xFilial("SC5")  , NIL },;
 					{ 'C5_NUM'    , TR1->TR1_NUM    , NIL },;
			   		{ 'C5_TIPO'   , 'N'             , NIL },;
			     	{ 'C5_CLIENTE', iif(lAddPV,TR1->TR1_FORNEC,lC5Cliente) , NIL },;
			      	{ 'C5_LOJACLI', iif(lAddPV,TR1->TR1_LOJA  ,lC5LojaCli) , NIL },;
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
    While !Eof()		                            
		If Empty(TR1->TR1_OK)  
			dbSkip()
			Loop
		Endif
		// Devolução da Carcaça
		SF4->( MsSeek( xFilial("SF4") + TR1->TR1_TES  ) )      //-- Busca TES Nota Fiscal Entrada para descobrir qual TES sera utilizado na Saida para devolucao do produto carcaca
		SF4->( MsSeek( xFilial("SF4") + SF4->F4_TESDV ) )     //-- Posiciona SF4 com o TES que sera utilizado para a saida (devolucao do produto recebido na nota fiscal entrada)
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
		Aadd( aAux , { 'C6_NUMOP'  , TR1->TR1_NUM    , NIL } )
		Aadd( aAux , { 'C6_ITEMOP' , TR1->TR1_ITEM   , NIL } )
		Aadd( aAux , { 'C6_TES'    , SF4->F4_CODIGO  , NIL } )
		Aadd( aAux , { 'C6_NUMOP'  , TR1->TR1_NUM    , NIL } )
		Aadd( aAux , { 'C6_ITEMOP' , TR1->TR1_ITEM   , NIL } )
		Aadd( aAux , { 'C6_CF'     , SF4->F4_CF      , NIL } )
		Aadd( aAux , { 'C6_ITPVSRV', StrZero(Len(_aSC6)+2,2,0) , NIL } )
		Aadd( _aSC6, aAux )
		// Fatura Reforma
		If	Alltrim(TR1->TR1_Status) == "Liberado" .and. AllTrim(TR1->TR1_TIPO) $ "RECAPAGEM*RECAUCHUT."	
			_nValor  := U_BuscaAcp ( TR1->TR1_SERV, TR1->TR1_FORNEC, TR1->TR1_LOJA )
			cTes     := GetMV( "MV_X_TSVED" )
			SF4->( MsSeek( xFilial("SF4") + cTes ) )      
			cDescPro := Alltrim(TR1->TR1_SDESC) 
			cDescPro += " " + Alltrim(TR1->TR1_COD)  
			cDescPro += iif(AllTrim(TR1->TR1_TIPO) == "RECAPAGEM"," BANDA " + Alltrim(TR1->TR1_DESEN),"")
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
			Aadd( aAux, { 'C6_CF'     , SF4->F4_CF               , NIL } )
			Aadd( _aSC6, aAux )
		EndIf
		// Adiciona Serviço Recusado 
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
			Aadd( aAux, { 'C6_LOCAL'  , "01"	                 , NIL } )
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
		DoSQL3 (TR1->TR1_NUM,TR1->TR1_ITEM,"2")
		dbSelectArea("SQL3")
		dbGoTop()
		IF EOF() .and. AllTrim(TR1->TR1_Status) == "Liberado"  .and. AllTrim(TR1->TR1_TIPO) == "RECAPAGEM"
			ALERT("SQL3 VAZIO")
		ENDIF
		vCons := 0			
		While !Eof()  
		
			If	!(Alltrim(SQL3->Grupo) $ "CI/SC")
				dbSelectArea("SQL3")
				dbSkip() 
				Loop
			EndIf
							
			_nValor  := U_BuscaAcp ( SQL3->X_PROD, TR1->TR1_FORNEC, TR1->TR1_LOJA )		
			cDescPro := Alltrim(SQL3->DESC)
			If Alltrim(TR1->TR1_TIPO) == "SOCONSERTO" .and. vCons == 0 .and. Alltrim(TR1->TR1_Status) == "Liberado"
				vCons    := vCons + 1
				cDescPro := cDescPro + " " + Alltrim(TR1->TR1_COD)	
				cDescPro := cDescPro + iif(!Empty(TR1->TR1_NUMFOG), " NF-" + Alltrim( TR1->TR1_NUMFOG ), "")
				cDescPro := cDescPro + iif(!Empty(TR1->TR1_SERIEP), " SP-" + Alltrim( TR1->TR1_SERIEP ), "")
			EndIf
			
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
			
			SF4->( MsSeek( xFilial("SF4") + cTes ) )      
					
			aAux  := {}
			Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")           , NIL } )
			Aadd( aAux, { 'C6_NUM'    , cCOLETA                  , NIL } )
			Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0), NIL } )
			Aadd( aAux, { 'C6_PRODUTO', SQL3->X_PROD             , NIL } )
			Aadd( aAux, { 'C6_DESCRI' , cDescPro                 , NIL } )
			Aadd( aAux, { 'C6_QTDVEN' , SQL3->QUANT              , NIL } )
			Aadd( aAux, { 'C6_QTDLIB' , SQL3->QUANT              , NIL } )
			Aadd( aAux, { 'C6_PRCVEN' , _nValor                  , NIL } )
			Aadd( aAux, { 'C6_PRUNIT' , _nValor                  , NIL } )
			Aadd( aAux, { 'C6_VALOR'  , SQL3->QUANT * _nValor    , NIL } )
			Aadd( aAux, { 'C6_LOCAL'  , "01"                     , NIL } )
			Aadd( aAux, { 'C6_NFORI'  , ""                       , NIL } )
			Aadd( aAux, { 'C6_SERIORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_ITEMORI', ""                       , NIL } )
			Aadd( aAux, { 'C6_IDENTB6', ""                       , NIL } )
			Aadd( aAux, { 'C6_NUMOP'  , TR1->TR1_NUM             , NIL } )
			Aadd( aAux, { 'C6_ITEMOP' , TR1->TR1_ITEM            , NIL } )
			Aadd( aAux, { 'C6_TES'    , cTes                     , NIL } )
			Aadd( aAux, { 'C6_CF'     , SF4->F4_CF               , NIL } )
			Aadd( _aSC6, aAux )
			
			dbSelectArea("SQL3")		
			dbSkip()			
		EndDo
		dbSelectArea("SQL3")
		dbCloseArea()
		
		dbSelectArea("TR1")		
		dbSkip()
	EndDo
	
	//-- Inclusao dos Pedidos de Venda.
	If Empty( _aSC5 ) .or. Empty( _aSC6 )
		Alert( "VAZIO" )                       
		IF Empty( _aSC5 )
			ALERT ("C5 VAZIO")
		ENDIF
		IF Empty( _aSC6 )
			ALERT ("C6 VAZIO")
		ENDIF
	Else
		For I := 1 TO LEN(_ASC6)      
			lNumPV			:= strzero(val(lNumPV) + 1 , 2)
			_ASC6[I][3][2] 	:= lNumPV
		Next
		nOpcPed := iif(lAddPV , 3 , 4)
		MsExecAuto( { |x, y, z| Mata410( x, y, z ) }, _aSC5, _aSC6, nOpcPed )
		If lMsErroAuto
			If Aviso( "Pergunta", "Pedido de venda nao gerado. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
				MostraErro()
			EndIf
		Else     
			If Aviso( "Pergunta", "Pedido de Venda Gerado. Deseja Liberar Pedido?",       { "Sim", "Nao" }, 1, "Liberar PV" ) == 1
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
	 			
					If !Empty(SC6->C6_IDENTB6) 		
						dbSelectArea("SB6")
						dbSetOrder(3)                                      
	  					dbSeek(xFilial("SB6") + SC6->C6_IDENTB6)
	   					If Found() .and. RecLock("SB6",.F.)
      						SB6->B6_QULIB := 1
         					MsunLock()
						Endif
				
				/*	dbSelectArea("SB2")
	  			dbSetOrder(1)
	    		dbSeek(SC9->C9_FILIAL+SC9->C9_PRODUTO+SC9->C9_LOCAL)
	    		If Found() .and. RecLock("SB2",.F.)
	     			SB2->B2_RESERVA := SB2->B2_RESERVA + SC6->C6_QTDVEN
	       			MsUnlock()
	     		EndIf 
	     		 */   
					EndIf
					dbSelectArea("SC6")
					dbSkip()           
				EndDo
			EndIf
		Endif
	EndIf

Return nil                           

User Function DST10ZL()

	Local 	Titulo  	:= OemToAnsi("Emissao da Confirmacao do Pedido")
	Local 	cDesc1  	:= OemToAnsi("Emissao da confirmacao dos pedidos de venda, de acordo com")
	Local 	cDesc2  	:= OemToAnsi("intervalo informado na opcao Parƒmetros.")
	Local 	cDesc3  	:= " "
	Local 	cString 	:= "SC5"  // Alias utilizado na Filtragem
	Local 	lDic    	:= .F. // Habilita/Desabilita Dicionario
	Local   cPerg   	:= "ST10AL"    
    Private wnrel		:= "DST10ZL" // Nome do Arquivo utilizado no Spool 
	Private lAbortPrint := .F.
	Private Tamanho 	:= "G" // P/M/G
	Private Limite  	:= 220 // 80/132/220
	Private aOrd    	:= {}  // Ordem do Relatorio
	Private aReturn 	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)
	Private nTipo   	:= 15
	Private Li			:= 80
	Private lEnd    	:= .F.// Controle de cancelamento do relatorio
	Private m_pag   	:= 1  // Contador de Paginas
	Private nLastKey	:= 0  // Controla o cancelamento da SetPrint e SetDefault
    Private Cabec1      := ""
	Private Cabec2      := ""
	Private wnrel       := "DST10ZL"
	Private lImp        := .F.

	cPerg    			:= PADR(cPerg,6)
	aRegs    			:= {}  

    AADD(aRegs,{cPerg,"01","Status OP        ?"," "," ","mv_ch1","N",01,0,0,"C","","mv_par01","So Liberados","","","","","Todas"  ,"","","","",""             ,"","","","",""            ,"","","","","","","",""   ,"","","","",""          })
	AADD(aRegs,{cPerg,"02","Faturados        ?"," "," ","mv_ch2","N",01,0,0,"C","","mv_par02","Nao Imprime" ,"","","","","Todas"  ,"","","","",""             ,"","","","",""            ,"","","","","","","",""   ,"","","","",""          })

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
	Pergunte(cPerg,.F.)

	wnrel := SetPrint(cString,"DST10ZL",cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
    
    SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus({||Runreport()})

Return Nil

Static Function RunReport()
	
	Local cQuery     := ""
	Local tQtdPro    := 0
	Local tQtdSer	 := 0
	Local tValSer    := 0
    Local vPipe		 := "|"
	cQuery := "SELECT C5_FILIAL, "
	cQuery += "       C5_NUM, "
	cQuery += "       C5_CLIENTE, "
	cQuery += "       C5_LOJACLI, "
	cQuery += "       C5_TIPO, "
	cQuery += "       C5_EMISSAO, "
	cQuery += "       C5_CONDPAG, "
	cQuery += "       C6_PRODUTO, "
	cQuery += "       C6_QTDVEN, "
	cQuery += "       C6_PRUNIT, "
	cQuery += "       C6_VALDESC,"
	cQuery += "       C6_VALOR, "
	cQuery += "       C6_ITEM, "
	cQuery += "       C6_DESCRI, "
	cQuery += "       C6_UM, "
	cQuery += "       C6_PRCVEN, "
	cQuery += "       C6_NOTA, "
	cQuery += "       C6_ENTREG, "
	cQuery += "       C6_DESCONT, "
	cQuery += "       C6_QTDENT, "
	cQuery += "       C6_NFORI, "
	cQuery += "       C6_SERIORI, "
	cQuery += "       C6_ITEMORI, "
	cQuery += "       C6_TES, "
	cQuery += "       A1_NOME,"
	cQuery += "       A1_CGC, "
	cQuery += "       A1_INSCR, "
	cQuery += "       A1_END, "
	cQuery += "       A1_CEP, "
	cQuery += "       A1_MUN, "
	cQuery += "       A1_EST, "
	cQuery += "       A1_ENDENT, "
	cQuery += "       A1_CEPE, "
	cQuery += "       A1_MUNE, "
	cQuery += "       A1_ESTE, "
	cQuery += "       E4_DESCRI, "
	cQuery += "       C2_X_STATU "
	cQuery += "  FROM " + RetSqlName("SC5") + " SC5 " 
	cQuery += "  JOIN " + RetSqlName("SC6") + " SC6 "
	cQuery += "    ON SC6.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC6.C6_FILIAL  = '"   + xFilial("SC6") + "' "
	cQuery += "   AND SC6.C6_NUM     = SC5.C5_NUM "
	If mv_par02 = 1  // Não Imprime Faturado
	   cQuery += "AND SC6.C6_NOTA = '' "
	EndIf
	cQuery += "  LEFT JOIN " + RetSqlName("SC2") + " SC2 "
	cQuery += "    ON SC2.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC2.C2_NUM     = SC6.C6_NUMOP "
	cQuery += "   AND SC2.C2_ITEM    = SC6.C6_ITEMOP "
	cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += "    ON SA1.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SA1.A1_COD     = SC5.C5_CLIENTE "
	cQuery += "   AND SA1.A1_LOJA    = SC5.C5_LOJACLI "
	cQuery += "  JOIN " + RetSqlName("SE4") + " SE4 "
	cQuery += "    ON SE4.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SE4.E4_CODIGO  = SC5.C5_CONDPAG "
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
	cQuery += "   AND SC5.C5_NUM     = '" + TMP->C2_NUM + "' "
		
	cQuery += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM "

 	MsgRun("Consultando Banco de dados ...",,{|| cQuery := ChangeQuery(cQuery)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","C5_EMISSAO","D")
	TcSetField("ARQ_SQL","C6_ENTREG" ,"D")
	TcSetField("ARQ_SQL","C6_QTDVEN" ,"N",14,2)
	TcSetField("ARQ_SQL","C6_PRUNIT" ,"N",14,2)
	TcSetField("ARQ_SQL","C6_VALDESC","N",14,2)       
	TcSetField("ARQ_SQL","C6_VALOR"  ,"N",14,2)       
	
	dbSelectArea("ARQ_SQL")
	dbGoTop()
	ProcRegua(0)
	nTotRec :=0
	nTotLib :=0
	nTotQtd	:=0
	nTotVal	:=0
	nPesBru	:=0
	nPesLiq	:=0
	nCaract	:=limite-41
	nc1		:=044
	nc2		:=108
	nc3		:=180
	
	LI:=01		
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	LI++
	@ LI,000 		psay "| " + SM0->M0_NOMECOM
	@ LI,nc1 		psay "| " + Arq_Sql->A1_NOME
	@ LI,nc2 		psay "| CONFIRMACAO DO PEDIDO "  
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "| "    + SM0->M0_ENDENT
	@ LI,nc1 		psay "| "    + Arq_Sql->A1_ENDENT
	@ LI,nc2 		psay "| CP:" + Arq_Sql->E4_DESCRI
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "| TEL: "+SM0->M0_TEL
	@ LI,nc1 		psay "| CEP:" + Arq_Sql->A1_CEPE
	@ LI,pcol()+1 	psay Arq_Sql->A1_MUNE
	@ LI,pcol()+1	psay Arq_Sql->A1_ESTE
	@ LI,nc2 		psay "| EMISSAO: "
	@ LI,pcol()+1 	psay date()
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "| CNPJ: "	
	@ LI,pcol()+1 	psay SM0->M0_CGC     Picture "@R 99.999.999/9999-99"
	@ LI,pcol()+1 	psay Subs(SM0->M0_CIDENT,1,15)
	@ LI,nc1 		psay "|"
    @ LI,pcol()+1 	psay Arq_Sql->A1_CGC Picture "@R 99.999.999/9999-99"
	@ LI,pcol()+1 	psay "IE: "+Arq_Sql->A1_INSCR		
	@ LI,nc2		psay "| PEDIDO N. "+Arq_Sql->C5_NUM
	@ LI,nc3 		psay "|"
	LI++
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	LI++
	@ LI,000 		psay  "| IT | CODIGO          | DESCRICAO DO MATERIAL                                    | SITUACAO | COLETA | SER | ITEM |N.FISCAL| QL | QR | QP | QS |   UNITARIO | VALOR TOTAL| ENTREGA |"
	li++
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	
	While !Eof()

		if (mv_par01 = 1 .and. Arq_Sql->C2_X_Statu = "9") 
			dbSelectArea("Arq_Sql")
			dbskip()
			loop
		endif
		 
		li++
		@li,000      psay vPipe
		@li,pcol()+1 psay Arq_Sql->C6_ITEM
		@li,pcol()+1 psay vPipe
	    @li,pcol()+1 psay Arq_Sql->C6_PRODUTO
		@li,pcol()+1 psay vPipe
		@li,pcol()+1 psay Substr(Arq_Sql->C6_DESCRI,1,56)
		@li,pcol()+1 psay vPipe
		
		if Arq_Sql->C2_X_STATU = "6"
			If Arq_Sql->C6_TES = "594"  
		   		@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Liberado","Lib/Dev.")
		 	Else
		 		@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Liberado","Lib/Fat.")
		 	EndIf
			@li,pcol()+1 psay vPipe
		else
			if Arq_Sql->C2_X_STATU = "9"
				If Arq_Sql->C6_TES = "594"
		   			@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Recusado","Rec/Dev.")
		 		Else
		 			@li,pcol()+1 psay iif(Empty(Arq_Sql->C6_Nota),"Recusado","Rec/Fat.")
		 		EndIf
		        @li,pcol()+1 psay vPipe
			else
				@li,pcol()+1 psay space(8)
		        @li,pcol()+1 psay vPipe
			endif
		endif

		@li,pcol()+1 psay Arq_Sql->C6_NFORI
		@li,pcol()+1 psay vPipe 
		@li,pcol()+1 psay Arq_Sql->C6_SERIORI
		@li,pcol()+1 psay vPipe
		@li,pcol()+1 psay Arq_Sql->C6_ITEMORI
		@li,pcol()+1 psay vPipe		
		@li,pcol()+1 psay Arq_Sql->C6_Nota
		@li,pcol()+1 psay vPipe		
		    		
		If Arq_Sql->C6_TES = '594'        
			if Arq_Sql->C2_X_STATU = "6"
				nTotLib++
				@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
				@li,pcol()+1 psay vPipe
				@li,pcol()+1 psay "  "
			else                    
				if Arq_Sql->C2_X_STATU = "9"
					@li,pcol()+1 psay "  "
					@li,pcol()+1 psay vPipe
					nTotRec++
					@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
				else
					@li,pcol()+1 psay "  "
					@li,pcol()+1 psay vPipe
					@li,pcol()+1 psay "  "
				endif
			endif
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay "  "
			@li,pcol()+1 psay vPipe
			tQtdPro := tQtdPro + Arq_Sql->C6_QTDVEN
			@li,pcol()+1 psay "          "
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay "          "
			@li,pcol()+1 psay vPipe
		else
			@li,pcol()+1 psay "  "
			@li,pcol()+1 psay vPipe
			@li,pcol()+1 psay "  "
			@li,pcol()+1 psay vPipe
			if Arq_Sql->C6_TES = '901'
				@li,pcol()+1 psay "  "
				@li,pcol()+1 psay vPipe
				@li,pcol()+1 psay Arq_Sql->C6_QTDVEN picture "99"
				@li,pcol()+1 psay vPipe
				tQtdSer := tQtdSer + Arq_Sql->C6_QTDVEN
				@li,pcol()+1 psay Arq_Sql->C6_PRCVEN picture "@E 999,999.99"
				@li,pcol()+1 psay vPipe
				@li,pcol()+1 psay Arq_Sql->C6_VALOR  picture "@E 999,999.99"
				@li,pcol()+1 psay vPipe
				tValSer := tValSer + Arq_Sql->C6_VALOR
			else	
		  		@li,pcol()+1 psay "  "
				@li,pcol()+1 psay vPipe
		        @li,pcol()+1 psay "  "
				@li,pcol()+1 psay vPipe
		        @li,pcol()+1 psay "          "
				@li,pcol()+1 psay vPipe
		        @li,pcol()+1 psay "          "
				@li,pcol()+1 psay vPipe
		    endif
		endif
		@li,pcol()+1 psay Arq_Sql->C6_ENTREG    
		@LI,PCOL()   PSAY vPipe
		dbSelectArea("Arq_Sql")
		dbSkip()
	Enddo
	Li++
	@ LI,000		psay "+" + Replicate("-",nCaract) + "+"
	Li++
	@li,000      	psay vPipe  
	@li,024      	psay " T O T A I S "
	@li,124     	psay vPipe
	@li,pcol()+1    psay ntotLib picture "99"
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1    psay ntotRec picture "99"
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1 	psay tQtdPro picture "99"	
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1 	psay tQtdSer Picture "99"
	@li,pcol()+1 	psay vPipe
	@li,pcol()+1 	psay space(10)
	@li,pcol()+1	psay vPipe
	@li,pcol()+1 	psay tValSer Picture "@e 999,999.99"
	@li,pcol()+1 	psay vPipe  
	@li,nc3 	 	psay vPipe  
	
	Li++
	@ LI,000 		psay "+" + Replicate("-",nCaract) + "+"
	
	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
    dbCloseArea("ARQ_SQL")
    
Return nil
