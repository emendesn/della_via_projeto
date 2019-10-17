/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460SOLI  ºAutor  ³Alexandre Martim    º Data ³  07/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada para tratar as TES cuja excecoes em re-  º±±
±±º          ³lacao ao ICMS substituto ocorrem.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460SOLI()
//
Local _nBsIcmsRet:=0.00, _nIcmsRet:=0.00, _nPos, _nDifAlq, _cEstado
//
Local _aRet := {} // { Base de Retencao do ICMS, Valor do ICMS Solidario }
//
//

If !(SC6->C6_TES $ Alltrim(GetMV('MV_EXCSUBS',,'507/508/563/574/580/581/')))
	_aRet := {0.00, 0.00}
Else
	//
	_cEstado := Iif(SC5->C5_TIPO$"D/B",SA2->A2_EST,SA1->A1_EST)
	If SC6->C6_TES $ "508/"
		_nBsIcmsRet := SC6->C6_VALOR
		
		_nPos       := at(_cEstado,getmv("MV_ESTICM"))
		_nIntICMS   := Iif(_nPos>0,val(substr(getmv("MV_ESTICM"),_nPos+2,2)),getmv("MV_ICMPAD"))
		_nAlqICMS   := Iif(!_cEstado$getmv("MV_NORTE"),12,7)
		_nDifAlq    := (_nIntICMS - _nAlqICMS)
		_nIcmsRet   := (SC6->C6_VALOR * _nDifAlq / 100)
		_aRet       := {_nBsIcmsRet, _nIcmsRet}
	Else
		// Complemento Ponto de Entrada para Devolucao de Compras - Pirelli // gsabino
		_cAlias:=Alias()
		
		dBselectarea("SD1")
		_nOrderSD1 := IndexOrd()
		_nRecnoSD1 := Recno()
		
		dBselectarea("SF4")
		_nOrderSF4 := IndexOrd()
		_nRecnoSF4 := Recno()
		
		
		IF SC5->C5_TIPO == "D"
			dBselectarea("SD1")
			dbsetorder(1)
			IF dbseek(xFilial("SD1")+SC6->(C6_NFORI+C6_SERIORI)+SC5->(C5_CLIENTE+C5_LOJACLI)+SC6->C6_PRODUTO+SC6->C6_ITEMORI)
				dBselectarea("SF4")
				dBsetorder(1)
				IF dBseek(xFilial("SF4")+SC6->C6_TES)
					IF SF4->F4_DUPLIC =="S"
						IF SD1->D1_BRICMS > 0
							_aRet:={}
							aadd(_aRet,Round((SD1->D1_BRICMS/SD1->D1_QUANT)*SC6->C6_QTDVEN,2))
							aadd(_aRet,Round((SD1->D1_ICMSRET/SD1->D1_QUANT)*SC6->C6_QTDVEN,2))
						Endif
					ENDIF
				ENDIF
			ENDIF
			dBselectarea("SD1")
			dBsetOrder(_nOrderSD1)
			dBgoto(_nRecnoSD1)
			
			dBselectarea("SF4")
			dBsetorder(_nOrderSF4)
			dBgoto(_nRecnoSF4)
			
			dBselectarea(_cAlias)
			
		ENDIF
	
	ENDIF
	//
Endif
//
Return _aRet

