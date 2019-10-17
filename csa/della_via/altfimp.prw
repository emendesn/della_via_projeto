#Include "Protheus.Ch"

User Function ALTFIMPS()
     //
     Local aCores    := {{ 'F2_FIMP=="S"' , 'DISABLE'},; // NF Impressa
	 				    {  '.t.'          , 'ENABLE'} }	 // NF nao impressa
     //
     //Local aCores    := {{ 'F2_TIPO=="N"'	 , 'DISABLE'},;		// NF Normal
	 //      				{  'F2_TIPO=="P"'	 , 'BR_AZUL'},;		// NF de Compl. IPI
	 //	      			{  'F2_TIPO=="I"'	 , 'BR_MARRON'},;	// NF de Compl. ICMS
	 //		     		{  'F2_TIPO=="C"'	 , 'BR_PINK'},;		// NF de Compl. Preco/Frete
	 //			    	{  'F2_TIPO=="B"'	 , 'BR_CINZA'},;	// NF de Beneficiamento
	 //				    {  'F2_TIPO=="D"'    , 'BR_AMARELO'} }	// NF de Devolucao
     //
     Private cAlias1 := "SF2"
     Private cCadastro := "Altera Flag de impressao em Documento de Saida"
     Private aRotina := {}
     //
     aAdd( aRotina, {"Pesquisar"   ,"AxPesqui"        ,0,1})
     aAdd( aRotina, {"Visualizar"  ,"MC090Visual"     ,0,2})
     aAdd( aRotina, {"Altera Flag" ,"u_FAltFlag('S')" ,0,3})
     aAdd( aRotina, {"Legenda"     ,"u_LegFImp"       ,0,5})
     //
     //aAdd( aRotina, {"Legenda"     ,"MC090Legend"     ,0,5})
     //
     dbSelectArea(cAlias1)
     dbSetOrder(1)
     dbGoTop()
     //
     mBrowse(,,,,"SF2",,,,,,aCores)
     //
     dbSelectArea("SF2")
     dbSetOrder(1)
     //
Return

User Function ALTFIMPE()
     //
     Local aCores    := {{ 'F1_FIMP=="S"' , 'DISABLE'},; // NF Impressa
	 				    {  '.t.'          , 'ENABLE'} }	 // NF nao impressa
     //
     //Local aCores    := {{ 'Empty(F1_STATUS)'	, 'ENABLE'},;		// NF Nao Classificada
	 //      				{  'F1_STATUS=="B"'	 	, 'BR_LARANJA'},;	// NF Bloqueada
	 //	      			{  'F1_TIPO=="N"'	 	, 'DISABLE'},;		// NF Normal
	 //		     		{  'F1_TIPO=="P"'	 	, 'BR_AZUL'},;		// NF de Compl. de IPI
	 //			    	{  'F1_TIPO=="I"'	 	, 'BR_MARRON'},;	// NF de Compl. ICMS
	 //			    	{  'F1_TIPO=="C"'	 	, 'BR_PINK'},;		// NF de Compl. Preco / Frete
	 //			    	{  'F1_TIPO=="B"'	 	, 'BR_CINZA'},;		// NF de Beneficiamento
	 //				    {  'F1_TIPO=="D"'    	, 'BR_AMARELO'} }	// NF de Devolucao
     //
     Private cAlias1 := "SF1"
     Private cCadastro := "Altera Flag de impressao em Documento de Entrada"
     Private aRotina := {}
     //
     aAdd( aRotina, {"Pesquisar"   ,"AxPesqui"       ,0,1})
     aAdd( aRotina, {"Visualizar"  ,"A103NFiscal"    ,0,2})
     aAdd( aRotina, {"Altera Flag" ,"u_FAltFlag('E')",0,3})
     aAdd( aRotina, {"Legenda"     ,"u_LegFImp"      ,0,5})
     //
     aAdd( aRotina, {"Legenda"     ,"A103Legenda"    ,0,5})
     //
     dbSelectArea(cAlias1)
     dbSetOrder(1)
     dbGoTop()
     //
     mBrowse(,,,,"SF1",,,,,,aCores)
     //
     dbSelectArea("SF1")
     dbSetOrder(1)
     //
Return

User Function FAltFlag(_cES)
       //
       Local cTitulo := "Altera Flag de impressao"
       Local aFlag   := {"S","N"," "}
       Local nOpca   := 0
       Local _cTipo  := Iif(_cES=="S",SF2->F2_FIMP,SF1->F1_FIMP)
       //
       DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 100,300 OF oMainWnd PIXEL
          //
          @ 012, 017 SAY "Impressa: " SIZE 030,011 OF oDlg PIXEL
          @ 012, 043 MSCOMBOBOX oCbx VAR _cTipo ITEMS aFlag SIZE 027,065 OF oDlg PIXEL
          //
          DEFINE SBUTTON FROM 035,070 TYPE 1 OF oDlg ENABLE ONSTOP "Confirma alteracao do Flag" ACTION (nOpca:=1,oDlg:End())
          DEFINE SBUTTON FROM 035,110 TYPE 2 OF oDlg ENABLE ONSTOP "Sair..." ACTION (nOpca:=2,oDlg:End())
          //
       ACTIVATE MSDIALOG oDlg CENTER
       //
       If nOpca==1
          //
          If _cES=="S"
             If RecLock("SF2",.F.)
                SF2->F2_FIMP := _cTipo
                msUnlock()
             Endif
          Else
             If RecLock("SF1",.F.)
                SF1->F1_FIMP := _cTipo
                msUnlock()
             Endif
          Endif
          //
       Endif
       //
Return

User Function LegFImp()
     //
	 Local aLegenda := {	{"BR_VERMELHO"	,"Nota Fiscal Impressa    "},;
	    					{"BR_VERDE"	    ,"Nota Fiscal nao impressa"} }
     //
	 BrwLegenda(cCadastro,"Legenda",aLegenda) // Legenda
     //
Return .T.
