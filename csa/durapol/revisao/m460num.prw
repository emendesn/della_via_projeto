#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460Num  ºAutor  ³Microsiga           º Data ³  31/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na geracao da nota fiscal de saida        º±±
±±º          ³ E' executado a cada geracao de numero de nota              º±±
±±º          ³ Usado para baixar NCC de desconto na nota                  º±±
±±º          ³                                                            º±±
±±º          ³ Usa variavel "_aTitNCC", publica definida no ponto de      º±±
±±º          ³ entrada M460MARK                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460NUM()

Local nTitulo     := 0
Local _nX         := 0
Local _nBaixa     := 0
Local _nSeq       := 0
Local _cRotina    := ""
Local _lOk        := .F.  
Local _aArea      := GetArea()
Local _aAreaSC6   := SC6->(GetArea())
Local _aAreaSE1   := SE1->(GetArea())
Local _aAreaSE5   := SE5->(GetArea())
Local _cSerie     := Alltrim(cSerie)    // pega conteudo da variavel private da rotina de geracao de nota
Local _cNota      := Alltrim(cNumero)   // pega conteudo da variavel private da rotina de geracao de nota
Local aTitulos    := {}     
Local _aItPed     := ParamIxb           // pega itens do SC9 que irao gerar a nota passado como parametro para a funcao
Local _nValTit    := 0
Local _nValComp   := 0
Local _nPerc      := 0
Local _nDif       := 0
Local _nTotDesc   := 0
Local _aDescontos := {}

//-- Executa somente para Durapol
If SM0->M0_CODIGO <> "03"
	Return(NIL)
Endif	

//-- Verifica se a rotina que chamou o ponto e' mesmo a de geracao de nota fiscal de saida MATA461
While .T.

	_cRotina := ProcName(_nX)

	If Empty(_cRotina)
		Exit
	Endif	
	
	If AllTrim(Upper(_cRotina)) == "MAPVLNFS"
		_lOk := .T.
		Exit
	Endif
	
    _nX ++
    
Enddo		

//-- se nao vier do MATA461 sai do ponto
If ! _lOk

	RestArea(_aAreaSC6)
	RestArea(_aAreaSE1)
	RestArea(_aAreaSE5)
	RestArea(_aArea)

	Return(NIL)

Endif	

//-- pega conteudo da variavel publica definida no ponto de entrada M460MARK ( titulos NCC com saldo para o cliente )
aTitulos := _aTitNCC   

//-- se nao tiver titulos marcados nao executa
_nX := 0
For nTitulo := 1 to Len(aTitulos)
	If aTitulos[nTitulo][11] // Somente creditos marcados
		_nX ++
	Endif
Next
If _nX == 0
	_lOk := .F.
Endif		

If _lOk
                           
	//-- soma valor dos descontos rateados para os itens que farao parte da nota atual
	_nTotDesc := 0
	For _nX := 1 To Len(_aItPed)
		dbSelectArea("SC6")
		dbGoTo(_aItPed[_nX,10])  // posiciona do registro do SC6
		_nTotDesc += SC6->C6_VALDESC
	Next	

	//-- Soma o total de descontos das NCCs
	_nValComp := 0
	For nTitulo := 1 to Len(aTitulos)
		If aTitulos[nTitulo][11] // Somente creditos marcados
			_nValComp += DesTrans(aTitulos[nTitulo][9])  // valor compensado da NCC
		Endif
	Next
			
    _aDescontos := {}

    _nDif := 0
        
	//-- Faz rateio do desconto pelo numero de titulos
	For nTitulo := 1 to Len(aTitulos)
		If aTitulos[nTitulo][11] // Somente creditos marcados
            
            //-- calcula proporcao que foi compensado para cada titulo para poder ratear o desconto
            //-- total apurado no pedido
			_nValTit := DesTrans(aTitulos[nTitulo][9])  // valor compensado da NCC
			_nPerc   := _nValTit / _nValComp  
			
			_nBaixa  := Round( _nTotDesc * _nPerc , 2 )
			_nDif    += _nBaixa
			
			AAdd(_aDescontos,{nTitulo,_nBaixa})

		Endif	
    Next nTitulo
    
    //-- se houve diferenca joga no primeiro item do array
    _nDif := _nTotDesc - _nDif 

    If _nDif <> 0
    	_aDescontos[1,2] += _nDif
    Endif

	//-- Realizar a Baixa dos Créditos aplicados
	For nTitulo := 1 to Len(aTitulos)
		
		IF aTitulos[nTitulo][11] // Somente creditos marcados
            
            //-- busca valor do desconto do array com os valores proporcionais por cada titulo
            _nX := AScan(_aDescontos,{|x| x[1]==nTitulo})
            If _nX <> 0
				_nBaixa := _aDescontos[_nX,2]
			Else
				_nBaixa := 0
			Endif
			
			DbSelectArea("SE1")
			DbSetOrder(1)
			dbGoTo(aTitulos[nTitulo][12])
			
			SA1->(dbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			
			// baixa titulo original NCC - Dados do SE1
			
			DbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_BAIXA   := dDataBase
			SE1->E1_NUMBOR  := _cNota
			SE1->E1_SALDO   := SE1->E1_SALDO - _nBaixa
			SE1->E1_VALLIQ  := _nBaixa
			SE1->E1_LOTE    := "8850"
			SE1->E1_MOVIMEN := dDataBase
			SE1->E1_STATUS  := "B"
			MsUnlock()
			
			// busca a ultima sequencia de baixa do titulo no SE5
			
			_nSeq := "00"
			
			DbSelectArea("SE5")
			dbSetOrder(7)
			dbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
			
			While ! Eof() .And. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
				xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA
				_nSeq := SE5->E5_SEQ
				dbSkip()
			Enddo
			
			_nSeq := Soma1(_nSeq,2)
			
			// baixa do titulo no SE5
			
			DbSelectArea("SE5")
			RecLock("SE5",.T.)
			SE5->E5_FILIAL  := xFilial("SE5")
			SE5->E5_DATA    := dDataBase
			SE5->E5_TIPO    := SE1->E1_TIPO
			SE5->E5_VALOR   := _nBaixa
			SE5->E5_NATUREZ := SE1->E1_NATUREZ
			SE5->E5_BANCO   := "SEP"
			SE5->E5_AGENCIA := "00001"
			SE5->E5_CONTA   := "0000000001"
			SE5->E5_NUMCHEQ := _cSerie+_cNota
			SE5->E5_RECPAG  := "P"
			SE5->E5_BENEF   := SA1->A1_NOME
			SE5->E5_HISTOR  := "NF "+_cSerie+"-"+_cNota
			SE5->E5_TIPODOC := "BA"
			SE5->E5_VLMOED2 := _nBaixa
			SE5->E5_LA      := "S"
			SE5->E5_LOTE    := "8850"
			SE5->E5_PREFIXO := SE1->E1_PREFIXO
			SE5->E5_NUMERO  := SE1->E1_NUM
			SE5->E5_PARCELA := SE1->E1_PARCELA
			SE5->E5_CLIFOR  := SE1->E1_CLIENTE
			SE5->E5_LOJA    := SE1->E1_LOJA
			SE5->E5_DTDIGIT := dDatabase
			SE5->E5_MOTBX   := "NOR"
			SE5->E5_SEQ     := _nSeq
			SE5->E5_DTDISPO := dDatabase
			SE5->E5_FILORIG := xFilial("SE5")
			SE5->E5_CLIENTE := SE1->E1_CLIENTE
			MsUnlock()
			
	//		AAdd( _aRegSE5, { "E1_PREFIXO" , SE1->E1_PREFIXO                 , NIL } )
	//		AAdd( _aRegSE5, { "E1_NUMERO"  , SE1->E1_NUM                     , NIL } )
	//		AAdd( _aRegSE5, { "E1_PARCELA" , SE1->E1_PARCELA                 , NIL } )
	//		AAdd( _aRegSE5, { "E1_CLIENTE" , SE1->E1_CLIENTE                 , NIL } )
	//		AAdd( _aRegSE5, { "E1_LOJA"    , SE1->E1_LOJA                    , NIL } )
	//		AAdd( _aRegSE5, { "E1_TIPO"    , SE1->E1_TIPO                    , NIL } )
	//
	//		AAdd( _aRegSE5, { "CPREFIXO"   , SE1->E1_PREFIXO                 , NIL } )
	//		AAdd( _aRegSE5, { "CNUMERO"    , SE1->E1_NUM                     , NIL } )
	//		AAdd( _aRegSE5, { "CPARCELA"   , SE1->E1_PARCELA                 , NIL } )
	//		AAdd( _aRegSE5, { "CCLIENTE"   , SE1->E1_CLIENTE                 , NIL } )
	//		AAdd( _aRegSE5, { "CLOJA"      , SE1->E1_LOJA                    , NIL } )
	//		AAdd( _aRegSE5, { "CTIPO"      , SE1->E1_TIPO                    , NIL } )
	//		AAdd( _aRegSE5, { "DBAIXA"     , dDataBase                       , NIL } )
	//		AAdd( _aRegSE5, { "DDTCREDITO" , dDataBase                       , NIL } )
	//		AAdd( _aRegSE5, { "NVALREC"    , DesTrans(aTitulos[nTitulo][9])  , NIL } )
	//		AAdd( _aRegSE5, { "CBANCO"     , "SEP"                           , NIL } )
	//		AAdd( _aRegSE5, { "CAGENCIA"   , "00001"                         , NIL } )
	//		AAdd( _aRegSE5, { "CCONTA"     , "0000000001"                    , NIL } )
	//		AAdd( _aRegSE5, { "CHIST070"   , _cSerie+"-"+_cNota              , NIL } )
	//		AAdd( _aRegSE5, { "CMOTBX"     , "NOR"                           , NIL } )
	//		
	//		MsExecAuto( {|x,y| Fina070(x,y)}, _aRegSE5, 3 )
	//		
	//		//-- Verifica se houve algum erro.
	//		If lMsErroAuto
	//		MostraErro()
	//		EndIf
			
		ENDIF
		
	Next nTitulo

Endif

RestArea(_aAreaSC6)
RestArea(_aAreaSE1)
RestArea(_aAreaSE5)
RestArea(_aArea)

Return(NIL)
