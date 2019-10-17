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
Local _cQry         := ""
Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.

If Reclock("SF1",.F.)
	SF1->F1_HORA := TIME()
	MsUnLock()
Endif


//-- Somente executa tratamento para Notas Fiscais de Coleta (Tipo Beneficiamento) da Empresa Durapol (03)
If AllTrim(FunName()) $ "MATA103*DESTA09" .And. SF1->F1_TIPO = "B" .And. SM0->M0_CODIGO == "03"
	
	SB1->( dbSetOrder( 1 ) )
	SA1->( dbSetOrder( 1 ) )
	SD1->( dbSetOrder( 1 ) )
	SA3->( dbSetOrder( 1 ) )
	
	SA1->( MsSeek( xFilial("SA1") + SF1->( F1_FORNECE + F1_LOJA ) ) )
	SA3->( MsSeek( xFilial("SA3") + SA1->A1_VEND3 ) )
	
	SD1->( MsSeek( cSeekSD1 := xFilial("SD1") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
	While SD1->( !Eof() .And. D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA == cSeekSD1 )
		
		//-- Posiciono o Cadastro de Produtos para saber quais itens deverao ter a O.P. gerada.
		If SB1->( MsSeek( xFilial("SB1") + SD1->D1_COD ) ) .And. SB1->B1_TIPO == "MO"
			Loop
		Endif
		
		_cServAtual      := SD1->D1_SERVICO
		_cForneceAtu     := SD1->D1_FORNECE
		_cForneLoja      := SD1->D1_LOJA
		
		//-- busca dados da coleta anterior
		_cQry := "SELECT * "
		_cQry += " FROM " + RetSqlName("SD1") + " SD1 "
		_cQry += " WHERE D1_COD = '"+SD1->D1_COD+"' "
		_cQry += "   AND D1_TIPO = 'B' "
		_cQry += "   AND D1_FORNECE = '"+SD1->D1_FORNECE+"' "
		_cQry += "   AND D1_LOJA = '"+SD1->D1_LOJA+"' "
		_cQry += "   AND D1_DOC <> '"+SD1->D1_DOC+"' "
	//	_cQry += "   AND D1_SERIE <> '"+SD1->D1_SERIE+"' "
		If ! Empty(SD1->D1_NUMFOGO)
			_cQry += "   AND D1_NUMFOGO = '" + SD1->D1_NUMFOGO +"' "
		Endif
		If ! Empty(SD1->D1_SERIEPN)
			_cQry += "   AND D1_SERIEPN = '" + SD1->D1_SERIEPN +"' "
		Endif
		_cQry += "   AND SD1.D_E_L_E_T_ <> '*' "
		_cQry += "   ORDER BY D1_EMISSAO "
		
		_cQry := ChangeQuery(_cQry)		
		
		dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), 'TEMPSD1', .F., .T.)
		
		_cColetaOrig     := Space(6)
		_dDtProducaoOrig := CtoD("")
		_dDtFaturamOrig  := CtoD("")
		_cFaturaOrig     := Space(6)
		_cBandaOrig      := Space(15)
		_nProfundOrig    := SB1->B1_XPROFUN
		_cProdutoOrig    := TEMPSD1->D1_COD
		_cServicoOrig    := Space(15)		
		_nPrecoOrig      := 0
		_nPrecoTabela    := 0
		
		dbSelectArea("TEMPSD1")
		dbGoTop()
		
		While ! Eof()
			
			//_cColetaOrig  := TEMPSD1->D1_DOC
			//Mudar numero da OP para série "2  " - Denis
			_cColetaOrig  := iif(AllTRim(TEMPSD1->D1_SERIE)="2",StrZero(Val(TEMPSD1->D1_DOC)+100000,6),TEMPSD1->D1_DOC)
			_cServicoOrig := TEMPSD1->D1_SERVICO
			_cBandaOrig   := TEMPSD1->D1_X_DESEN
			                        
			//_cNumOP := TEMPSD1->D1_DOC + StrZero( Val( TEMPSD1->D1_ITEM ), 2 ) + "001" + TEMPSD1->D1_COD
			//Mudar numero da OP para série "2  " - Denis
			_cNumOP := iif(AllTrim(TEMPSD1->D1_SERIE)="2",StrZero(Val(TEMPSD1->D1_DOC)+100000,6),TEMPSD1->D1_DOC) + StrZero( Val( TEMPSD1->D1_ITEM ), 2 ) + "001" + TEMPSD1->D1_COD
			
			//-- busca producao
			dbSelectArea("SC2")
			dbSetOrder(6)
			MsSeek(xFilial("SC2")+_cNumOP)
			
			_dDtProducaoOrig := SC2->C2_DATRF
			                   
			//-- busca pedido para a OP
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC2->C2_NUM+SC2->C2_ITEMPV)

			While ! Eof() .And. SC6->(C6_FILIAL+C6_NUM+C6_ITEM) == xFilial("SC6")+SC2->C2_NUM+SC2->C2_ITEMPV
			
				If SC6->C6_PRODUTO == _cProdutoOrig //_cServicoOrig
                                       
		            //-- busca nota para o pedido
					dbSelectArea("SD2")
					dbSetOrder(8)
					MsSeek(xFilial("SD2")+SC6->C6_NUM+Strzero(Val(SC6->C6_ITEM)+1,2))
					
					_cFaturaOrig     := SD2->D2_DOC
					_dDtFaturamOrig  := SD2->D2_EMISSAO
					_nPrecoOrig      := SD2->D2_PRCVEN
					_nPrecoTabela    := U_BuscaPrcVenda(_cServicoOrig,TEMPSD1->D1_FORNECE,TEMPSD1->D1_LOJA)
					
					Exit
					
				Endif
				
				dbSelectArea("SC6")
				dbSkip()          
				
			Enddo	

			dbSelectArea("TEMPSD1")
			dbSkip()

		Enddo
		
		dbSelectArea("TEMPSD1")
		dbCloseArea()
		IF _nPrecoTabela == 0
			IF !Empty(_cServicoOrig)
			
				_nPrecoTabela:= U_BuscaPrcVenda(_cServicoOrig,_cForneceAtu,_cForneLoja)
				
			Else
			
				_nPrecoTabela:= U_BuscaPrcVenda(_cServAtual,_cForneceAtu,_cForneLoja)
				_nPrecoOrig  := _nPrecoTabela
				
			EndIF
		EndIF			
		
		//-- grava item
		For nA := 1 To SD1->D1_QUANT
			
			_aLinha := {}
			
			dbSelectArea("SC2")
			RecLock( "SC2", .T. )
			SC2->C2_FILIAL  := xFilial("SC2")
			//SC2->C2_NUM     := SD1->D1_DOC
			//Mudar numero da OP para série "2  " - Denis
			SC2->C2_NUM     := iif(AllTrim(SD1->D1_SERIE)="2",StrZero(Val(SD1->D1_DOC)+100000,6),SD1->D1_DOC)
			SC2->C2_ITEM    := StrZero( Val( SD1->D1_ITEM ), Len(SC2->C2_ITEM) )
			SC2->C2_X_STATU := SD1->D1_X_STATU
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
			SC2->C2_STATUS  := ''
			SC2->C2_DESTINA := 'E'
			//--Alterado por Reinaldo				
				SC2->C2_PRIOR   := '500'
				SC2->C2_AGLUT   := ''
			//--Itens escritos originalmente	
			SC2->C2_SEQPAI  := '000'
			SC2->C2_X_DESEN := SD1->D1_X_DESEN
			SC2->C2_CARCACA := SD1->D1_CARCACA
			SC2->C2_NUMFOGO := SD1->D1_NUMFOGO
			SC2->C2_SERIEPN := SD1->D1_SERIEPN
			SC2->C2_TPOP    := "F"
			SC2->C2_XMOTORI := SA3->A3_NREDUZ

            //- JC 23/08/05 - Dados da coleta original
			SC2->C2_XCOLORI := _cColetaOrig     
			SC2->C2_XDPRDOR := _dDtProducaoOrig 
			SC2->C2_XULTNF  := _cFaturaOrig
			SC2->C2_XDFATOR := _dDtFaturamOrig 
			SC2->C2_XBANDA  := _cBandaOrig      
			SC2->C2_XPROFOR := _nProfundOrig    
			SC2->C2_XSERVOR :=	_cServicoOrig    
			SC2->C2_XPRCORI := _nPrecoOrig
			SC2->C2_XPRCTAB := _nPrecoTabela    
			
			// 17/02/2006 - Denis - Referencia com a Nota fiscal de coleta
			SC2->C2_NUMD1   := SD1->D1_DOC
			SC2->C2_SERIED1 := SD1->D1_SERIE
			SC2->C2_ITEMD1  := SD1->D1_ITEM
			SC2->C2_FORNECE := SD1->D1_FORNECE
			SC2->C2_LOJA    := SD1->D1_LOJA
			
			SC2->( MsUnLock() )
			
			If SB1->( MsSeek( xFilial("SB1") + SD1->D1_SERVICO ) ) .And. AllTrim(SB1->B1_X_DEPTO) == "S" .AND. Alltrim(SB1->B1_X_GRUPO) == "T"
				dbSelectArea("SC1")
				dbSetOrder(4)
				dbGoTop()
				dbSeek(xFilial("SC1")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),.F.)
				If Found()
					If RecLock("SC1",.F.)
						dbDelete()
						MsUnlock()
					Endif
				Endif
				If RecLock("SC1",.T.)
					SC1->C1_FILIAL  := xFilial("SC1")
					SC1->C1_SOLICIT := Alltrim(cUserName)
					SC1->C1_NUM		:= GetSx8Num("SC1")
					SC1->C1_ITEM	:= "0001"
					SC1->C1_PRODUTO := SD1->D1_SERVICO
					SC1->C1_UM		:= SB1->B1_UM
					SC1->C1_LOCAL   := ""
					SC1->C1_CC		:= SB1->B1_CC
					SC1->C1_EMISSAO := dDataBase
					SC1->C1_OP      := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
					SC1->C1_DESCRI	:= SB1->B1_DESC
					SC1->C1_SEGUM   := SB1->B1_SEGUM
					SC1->C1_QUANT	:= 1
					SC1->C1_QTSEGUM := ConvUm(SC2->C2_PRODUTO,1,0,2)
					SC1->C1_DATPRF  := dDataBase +15
					SC1->C1_IMPORT  := SB1->B1_IMPORT
					SC1->C1_GRUPCOM := MaRetComSC(SB1->B1_COD,UsrRetGrp(),RetCodUsr())
					SC1->C1_USER    := RetCodUsr()
					SC1->C1_CONTA   := SB1->B1_CONTA
					SC1->C1_OBS     := "SC GERADA AUTOMATICAMENTE"
					SC1->C1_OBS2    := "AUTO: RECAUCHUTAGEM REF COLETA " + SD1->D1_DOC + "/" + SD1->D1_SERIE + "-" + SD1->D1_ITEM
					SC1->C1_FILENT  := xFilEnt(If(Empty(C1_FILENT),C1_FILIAL, C1_FILENT))
					MsUnlock()
					ConfirmSx8()
				Endif
			Endif


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
		
		if SD1->( RecLock("SD1",.F.) )
			SD1->D1_NUMC2  := SC2->C2_NUM
			SD1->D1_ITEMC2 := SC2->C2_ITEM
			MsUnlock()
		Endif
		
		SD1->( dbSkip() )
	Enddo
ElseIF FunName() = "MATA103" .And. SF1->F1_TIPO = "N" .And. SM0->M0_CODIGO == "03"
	
	SB1->( dbSetOrder( 1 ) )
	SD1->( dbSetOrder( 1 ) )
	SF4->( dbSetOrder( 1 ) )
	
	SD1->( MsSeek( cSeekSD1 := xFilial("SD1") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
	
	While SD1->( !Eof() .And. D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA == cSeekSD1 )
		
		//-- Posiciono o Cadastro de Produtos para saber quais itens deverao ter a O.P. gerada.
		If SB1->( MsSeek( xFilial("SB1") + SD1->D1_COD ) ) .And. SB1->B1_TIPO == "MO"
			SD1->( dbSkip() )
			Loop
		Endif
		SF4->( dbSeek( xFilial("SF4")+ SD1->D1_TES ) )
		IF SF4->F4_DUPLIC == "N"
			SD1->( dbSkip() )
			Loop
		EndIF
		
		dbSelectArea("SB1")
		RecLock("SB1",.F.)
			SB1->B1_PRV1  := SD1->D1_VUNIT
		MsUnlock()
				
		SD1->( dbSkip() )
	Enddo
EndIf

SD1->( RestArea( _aAreaSD1 ) )
SB2->( RestArea( _aAreaSB2 ) )
SA2->( RestArea( _aAreaSA2 ) )

RestArea(_aArea)

Return Nil
