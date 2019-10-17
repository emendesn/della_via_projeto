User Function TstProc()
Local aArea    := GetArea()
Local cQuery   := ""
Local cAlias1  := GetNextAlias()
Local lInverte := .F.
Local cArqTR1  := ""
Local nOpca    := 0
Local aStruct  := { { "TR1_OK"     , "C", 2                      , 0                     },;
                    { "TR1_STATUS" , "C", 10                     , 0                     },;
                    { "TR1_CLIENT" , "C", 30                     , 0                     },;
                    { "TR1_MOTORI" , "C", 30                     , 0                     },;                    
                    { "TR1_NUM"    , "C", TamSX3('C2_NUM')[1]    , 0                     },;
                    { "TR1_ITEM"   , "C", TamSX3('C2_ITEM')[1]   , 0                     },;
                    { "TR1_SEQUEN" , "C", TamSX3('C2_SEQUEN')[1] , 0                     },;
                    { "TR1_PRODUT" , "C", TamSX3('C2_PRODUTO')[1], 0                     },;
                    { "TR1_QUANT"  , "N", TamSX3('C2_QUANT')[1]  , TamSX3('C2_QUANT')[2] },;
                    { "TR1_QUJE"   , "N", TamSX3('C2_QUJE')[1]   , TamSX3('C2_QUJE')[2]  },;
                    { "TR1_PERDA"  , "N", TamSX3('C2_PERDA')[1]  , TamSX3('C2_PERDA')[2] },;
                    { "TR1_CARCAC" , "C", TamSX3('C2_CARCACA')[1], 0                     },;
                    { "TR1_NUMFOG" , "C", TamSX3('C2_NUMFOGO')[1], 0                     },;
                    { "TR1_SERIEP" , "C", TamSX3('C2_SERIEPN')[1], 0                     },;
                    { "TR1_DESEN"  , "C", TamSX3('C2_X_DESEN')[1], 0                     },; 
                    { "TR1_EMISSAO", "D", TamSX3('C2_EMISSAO')[1], 0                     },;
                    { "TR1_DATRF"  , "D", TamSX3('C2_DATRF')[1]  , 0                     } }                                        

                    
Local aCpoShow := { { "TR1_OK"    ,, ""           , "@!" },;
                    { "TR1_STATUS",, "Status"     , "@!" },;
                    { "TR1_CLIENT",, "Cliente"    , "@!" },;                    
                    { "TR1_MOTORI",, "Motorista"  , "@!" },;
                    { "TR1_NUM"   ,, "Coleta"     , "@!" },;
                    { "TR1_ITEM"  ,, "Item"       , "@!" },;
                    { "TR1_PRODUT",, "Produto"    , "@!" },;
                    { "TR1_CARCAC",, "Carcaca"    , "@!" },;
                    { "TR1_NUMFOG",, "Numero Fogo", "@!" },;
                    { "TR1_SERIEP",, "Serie Pneu" , "@!" },;
                    { "TR1_DESEN" ,, "Desenho"    , "@!" },;
                    { "TR1_EMISSAO", "Entrada"    , "99/99/99" },;
                    { "TR1_DATRF"  , "Liberacao"  , "99/99/99" } }

/*
   Status    Cliente              Motorista          Coleta It Produto       Carcaca N.Fogo Serie Desenho Entrada  Liberacao 
x  Liberado  VIACAO SANTA BRIGIDA ZE MANUEL DA SILVA 070000 01 255x698/R.255 xxxxxxx 21548        BDY     99/99/99 99/99/99
x  Rejeitado                                         070000 02 311x698/R.255 xxxxxxx 23dsr        BDT     99/99/99 99/99/99
*/

Private cMarca := GetMark()

cArqTR1 := CriaTrab( aStruct, .T. )

dbUseArea( .T.,, cArqTR1, "TR1", .F. )

cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_QUANT, C2_QUJE, C2_PERDA,"
cQuery += " C2_X_DESEN, C2_PRODUTO, C2_CARCACA, C2_NUMFOGO, C2_SERIEPN, C2_EMISSAO, C2_DATRF FROM " + RetSqlName("SC2")
cQuery += " WHERE C2_FILIAL = '" + xFilial('SC2') + "' AND"
cQuery += " C2_NUM = '" + mv_par01 + "' AND"
cQuery += " C2_QUANT = C2_QUJE AND"
cQuery += " D_E_L_E_T_ = ' '"
cQuery += " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN"

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias1, .F., .F. )

If (cAlias1)->( Eof() )
	TR1->( dbCloseArea() )
	MsgStop( "Nao existem dados para Coleta informada" )
	Return Nil
EndIf

While (cAlias1)->( !Eof() )

    //-- Posiciona NFE Coleta pra identificar cliente
    SF1->(dbSetOrder(1)) 
    SF1->(dbSeek(xFilial("SF1")+(cAlias1)->C2_NUM,.F.))

    //-- Posiciona Cliente para trazer nome reduzido
    SA1->(dbSetOrder(1))
    SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.))

    //-- Posiciona Vendedor para buscar nome do motorista "a1_vend3"
    SA3->(dbSetOrder(1))
    SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND3,.F.))
    
	RecLock( "TR1", .T. )
	
    TR1->TR1_CLIENT  := SA1->A1_NREDUZ
    TR1->TR1_MOTORI  := SA3->A3_NOME
    TR1->TR1_STATUS  := Iif((cAlias1)->C2_QUANT == (cAlias1)->C2_PERDA, "Recusado", "Liberado")
	TR1->TR1_NUM     := (cAlias1)->C2_NUM
	TR1->TR1_ITEM    := (cAlias1)->C2_ITEM
	TR1->TR1_SEQUEN  := (cAlias1)->C2_SEQUEN
	TR1->TR1_PRODUT  := (cAlias1)->C2_PRODUTO
	TR1->TR1_QUANT   := (cAlias1)->C2_QUANT
	TR1->TR1_QUJE    := (cAlias1)->C2_QUJE
	TR1->TR1_PERDA   := (cAlias1)->C2_PERDA
	TR1->TR1_PRODUT  := (cAlias1)->C2_PRODUTO
	TR1->TR1_CARCAC  := (cAlias1)->C2_CARCACA
	TR1->TR1_NUMFOG  := (cAlias1)->C2_NUMFOGO
	TR1->TR1_SERIEP  := (cAlias1)->C2_SERIEPN
	TR1->TR1_DESEN   := (cAlias1)->C2_X_DESEN
	TR1->TR1_EMISSAO := (cAlias1)->C2_EMISSAO
	TR1->TR1_DATRF   := (cAlias1)->C2_DATRF

	MsUnLock()
	
	(cAlias1)->( dbSkip() )
EndDo

TR1->( dbGotop() )
If TR1->( !Eof() )
	DEFINE MSDIALOG oDlg FROM 60, 1 TO 365, 685 TITLE "Geracao Automatica - Selecione as OP's para " PIXEL
		oMark := MsSelect():New( "TR1", "TR1_OK",,aCpoShow, @lInverte, @cMarca, { 20, 1, 153, 343 } )
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || nOpca := 1, oDlg:End() }, { || nOpca := 0, oDlg:End() } ) CENTERED
	
	If nOpca == 1
		U_TstGrava()
	EndIf
EndIf

(cAlias1)->( dbCloseArea() )

TR1->( dbCloseArea() )

Ferase( cArqTR1 + GetDbExtension() )

RestArea( aArea )

Return Nil