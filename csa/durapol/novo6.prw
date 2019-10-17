
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuAgreg บAutor  ณMicrosiga           บ Data ณ 22/08/2005  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para gravar o campo C9_AGREG para fazer a quebra    บฑฑ
ฑฑบ          ณ das notas                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//-- estes dois arrays so contem os pedidos e os titulos de um unico cliente
User Function AtuAgreg(_aPedidos,_aTitulos)

Local _cTipo,_nItens,_nDesc,_nX,_nZ,_nY,_cAgreg,_nItMax
Local _aProdutos := {}
Local _cCliente  := ""
Local _cLoja     := ""
Local _cPai      := ""
Local _cFilho    := ""

For _nX:=1 To Len(_aPedidos)

	DbSelectArea("SC9")
	DbGoTo(_aPedidos[_nX,9])
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

    _cCliente := SC9->C9_CLIENTE
    _cLoja    := SC9->C9_LOJA
    _cPedido  := SC9->C9_PEDIDO              
    _cItem    := SC9->C9_ITEM                         
    _cProduto := SC9->C9_PRODUTO

    //-- verifica se o item e' produto, servico ou so servico
	_cTipo := VerServico(SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_PRODUTO,SC6->C6_DESCRI)				 
	            
	If _cTipo == "P"   // produto

		_cPai   := _cItem + _cProduto
		_cFilho := ""

	ElseIf _cTipo == "S"  // servico

		_cFilho := _cItem + _cProduto

	ElseIf _cTipo == "SC"  // so servico
                     
		_cPai   := _cItem + _cProduto
		_cFilho := _cItem + _cProduto

	Endif		

	//-- gravar array com os produtos em par pai x filho ( produto x servico )
    If ! Empty(_cPai) .And. ! Empty(_cFilho)
    	AAdd(_aProdutos,{_cPai,_cFilho,_cCliente,_cLoja,_cPedido,_cItem,SC9->(Recno()),""})
    Endif

Next

//-- verifica se quantos descontos ( NCCs ) foram marcados para o cliente
If ! Empty(_cCliente+_cLoja)
	_nDesc := VerDesconto(_cCliente,_cLoja,_aTitulos)				 
	For _nX:=1 To _nDesc
	   	AAdd(_aProdutos,{_cPai,"DESC",_cCliente,_cLoja,_cPedido,_cItem,0,""})
	Next
Endif	

//-- ver situacao de transferencia de mercadorias -> total de itens passa a ser 4 ( produtos ) - nao vai ter
//-- descontos

_nItMax := 19
	
_cAgreg := "0001"
_nItens := 0

_nX := 1

While _nX <= Len(_aProdutos)
	
	_cPai := _aProdutos[_nX,1]

	//-- grava agreg 
	_aProdutos[_nX,8] := _cAgreg

	_nItens ++
	
    //-- chegou no limite de itens
	If _nItens == _nItMax
	
		_nY := _nX + 1
		If _nY > Len(_aProdutos)
			_cNewPai := "********"
		Else
			_cNewPai := _aProdutos[_nY,1]
		Endif
		             
		//-- ficou servicos do mesmo produto fora da nota
		//-- tirar os pares produto/servicos desta nota
		If _cPai == _cNewPai
			For _nZ := 1 To Len(_aProdutos)
				If _aProdutos[_nZ,1] == _cPai
					_aProdutos[_nZ,8] := ""
				Endif         
				//-- volta ponteiro do laco principal para o ultimo prenchido
				If ! Empty(_aProdutos[_nZ,8])
					_nX := _nZ
				Endif
			Next
		Endif
		
        //-- atualiza agreg e zera contador
		_cAgreg := Soma1(_cAgreg,4)
		_nItens := 0
	
	Endif

	_nX ++
		
Enddo

dbSelectArea("SC9")

//-- grava o agreg no SC9
For _nX :=1 To Len(_aProdutos)
	If _aProdutos[_nX,7] > 0
		dbGoto(_aProdutos[_nX,7])
		RecLock("SC9")
		SC9->C9_AGREG := _aProdutos[_nX,8]
		MsUnlock()
	Endif	
Next

Return(NIL)

	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VerServico บAutor  ณMicrosiga         บ Data ณ 22/08/2005  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna tipo do produto ( servico, produto, so servico )   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerServico(_cCliente,_cLoja,_cProduto,_cDescr)	

Local _aAliasAnt := GetArea()
//-- Grupo de produtos so conserto que nao contem valor,no momento da geracao da NFE,
//-- porem os produtos contidod no ajustes de empenho devem pertencer a um grupo que agrega
//-- TES 902
Local _cGrpSC  := GetMV("MV_X_GRPSC")
//-- Grupo de produtos que serao inseridos automaticamente no PV para faturamento a partir do ajuste de empenho
Local _cGrpRO  := GetMV("MV_X_GRPRO")
Local _cTipo   := ""

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+_cCliente+_cLoja)

dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+_cProduto)

_lServico := (SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO ) .or. ;
  			 (SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) == "SERV") .or. ;
			 (SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpSC ) .or. ;
			 (SA1->A1_CALCCON == "S" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO) 

// opcao para tratar SO CONSERTO 			 
_lSoConserto := .F.
If ! _lServico .And. Substr(_cDescr,1,8) == "CONS SC "
	_lSoConserto := .T.
Endif	     

If _lServico 
	_cTipo := "S"
Else
	_cTipo := "P"
	If _lSoConserto
		_cTipo "SC"
	Endif
Endif			

RestArea(_aAliasAnt)

Return(_cTipo)	




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VerDescontoบAutor  ณMicrosiga         บ Data ณ 22/08/2005  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna quantidade de linhas de desconto ( NCCs usadas )   บฑฑ
ฑฑบ          ณ para o cliente.                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerDesconto(_cCliente,_cLoja,_aTitulos)	

Local _nX,_nQtdeDesc := 0

//-- conta somente os titulos do cliente que veio nos itens selecionados e que estao marcados
For _nX:=1 To Len(_aTitulos)
	If _aTitulos[_nX,11]
		_nQtdeDesc ++
	Endif
Next		

Return(_nQtdeDesc)
