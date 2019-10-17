/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Robson Alves        º Data ³  03/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera ordem de producao com base nos itens da NF Entrada.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SF1100I()
Local _aArea        := GetArea()
Local _aAreaSD1     := SD1->(GetArea())
Local _aAreaSA2     := SA2->(GetArea())
Local _aAreaSB2     := SB2->(GetArea())
Local _aLinha       := {}
Local _aSC2         := {}
Local nA            := 0
Local cSeekSD1      := ""
Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.
                   
//-- Somente executa tratamento para Notas Fiscais de Coleta (Tipo Beneficiamento) da Empresa Durapol (03)
If FunName() = "MATA103" .And. SF1->F1_TIPO = "B" .And. SM0->M0_CODIGO == "03" 

	SB1->( dbSetOrder( 1 ) )
	SA1->( dbSetOrder( 1 ) )
	SD1->( dbSetOrder( 1 ) )
	SA3->( dbSetOrder( 1 ) )

	SA1->( MsSeek( xFilial("SA1") + SF1->( F1_FORNECE + F1_LOJA ) ) )
	SA3->( MsSeek( xFilial("SA3") + SA1->A1_VEND3 ) )
	
	SD1->( MsSeek( cSeekSD1 := xFilial("SD1") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
	While SD1->( !Eof() .And. D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA == cSeekSD1 )

		For nA := 1 To SD1->D1_QUANT

			_aLinha := {}
			
			//-- Posiciono o Cadastro de Produtos para saber quais itens deverao ter a O.P. gerada.
			If SB1->( MsSeek( xFilial("SB1") + SD1->D1_COD ) ) .And. SB1->B1_TIPO == "MO"
			   Loop
			Endif
			
			RecLock( "SC2", .T. )
			SC2->C2_FILIAL  := xFilial("SC2")
			SC2->C2_NUM     := SD1->D1_DOC
			SC2->C2_ITEM    := StrZero( Val( SD1->D1_ITEM ), Len(SC2->C2_ITEM) )
			SC2->C2_X_STATU := '1'
			SC2->C2_SEQUEN  := '001'
			SC2->C2_DATPRF  := SD1->D1_DTENTRE //dDataBase
			SC2->C2_PRODUTO := SD1->D1_COD
			SC2->C2_LOCAL   := SB1->B1_LOCPAD
			SC2->C2_XNREDUZ := SA1->A1_NREDUZ
			SC2->C2_QUANT   := 1
			SC2->C2_UM      := SB1->B1_UM
			SC2->C2_DATPRI  := dDataBase
			SC2->C2_OBS     := SD1->D1_X_OBS  // Criar campo para esta 'Auto - Nota Fiscal Coleta :' + SD1->D1_DOC
			SC2->C2_EMISSAO := dDataBase
			SC2->C2_STATUS  := 'N'
			SC2->C2_DESTINA := 'E'
			SC2->C2_AGLUT   := 'N'
			SC2->C2_SEQPAI  := '000'
			SC2->C2_X_DESEN := SD1->D1_X_DESEN
			SC2->C2_CARCACA := SD1->D1_CARCACA
			SC2->C2_NUMFOGO := SD1->D1_NUMFOGO
			SC2->C2_SERIEPN := SD1->D1_SERIEPN
			SC2->C2_TPOP    := "F"
			SC2->C2_XMOTORI := SA3->A3_NREDUZ

			SC2->( MsUnLock() )

			/*
			Aadd( _aLinha, { 'C2_FILIAL' , xFilial("SC2")                             , NIL } )
			Aadd( _aLinha, { 'C2_NUM'    , SD1->D1_DOC                                , NIL } )
			Aadd( _aLinha, { 'C2_ITEM'   , StrZero( Val( SD1->D1_ITEM ), Len(SC2->C2_ITEM) ), NIL } )
			Aadd( _aLinha, { 'C2_X_STATU', '1'                                        , NIL } )
			Aadd( _aLinha, { 'C2_SEQUEN' , '001'                                      , NIL } )
			Aadd( _aLinha, { 'C2_DATPRF' , dDataBase                                  , NIL } )
			Aadd( _aLinha, { 'C2_PRODUTO', SD1->D1_COD                                , NIL } )
			Aadd( _aLinha, { 'C2_LOCAL'  , SB1->B1_LOCPAD                             , NIL } )
			Aadd( _aLinha, { 'C2_XNREDUZ', SA1->A1_NREDUZ                             , NIL } )
			Aadd( _aLinha, { 'C2_QUANT'  , 1                                          , NIL } )
			Aadd( _aLinha, { 'C2_UM'     , SB1->B1_UM                                 , NIL } )
			Aadd( _aLinha, { 'C2_DATPRI' , dDataBase                                  , NIL } )
			Aadd( _aLinha, { 'C2_OBSC'   , 'Auto - Nota Fiscal Coleta :' + SD1->D1_DOC, NIL } )
			Aadd( _aLinha, { 'C2_EMISSAO', dDataBase                                  , NIL } )
			Aadd( _aLinha, { 'C2_STATUS' , 'N'                                        , NIL } )
			Aadd( _aLinha, { 'C2_DESTINA', 'E'                                        , NIL } )
			Aadd( _aLinha, { 'C2_AGLUT'  , 'N'                                        , NIL } )
			Aadd( _aLinha, { 'C2_SEQPAI' , '000'                                      , NIL } )
			Aadd( _aLinha, { 'AUTEXPLODE', 'S'                                        , NIL } )
			
			//-- Chamada da rotina automatica de inclusao da Ordem de Producao.
			MsExecAuto( { |x, y| Mata650( x, y ) }, _aLinha, 3 )
	
			//-- Verifica se houve algum erro.
			If lMsErroAuto
				If Aviso( "Pergunta", "Ordem de Producao nao gerada. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
					MostraErro()
				EndIf
			EndIf
			*/

		Next nA
			
		SD1->( dbSkip() )
	Enddo
EndIf

SD1->( RestArea( _aAreaSD1 ) )
SB2->( RestArea( _aAreaSB2 ) )
SA2->( RestArea( _aAreaSA2 ) )

RestArea(_aArea)

Return Nil