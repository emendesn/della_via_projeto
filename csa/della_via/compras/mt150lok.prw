
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT150LOK บAutor  ณAlexandre Martim    บ Data ณ  05/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Ponto de entrada na final da gravacao do documento de     บฑฑ
ฑฑบ          ณsaida para gravar o campo de portador do clinte nos titulos บฑฑ
ฑฑบ          ณgerados caso existam.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT150LOK()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local _nPosProduto := aScan(aHeader, {|x| alltrim(x[2])=="C8_PRODUTO"})
     Local _nPosQuant   := aScan(aHeader, {|x| alltrim(x[2])=="C8_QUANT"})
     Local _nPosPreco   := aScan(aHeader, {|x| alltrim(x[2])=="C8_PRECO"})
     Local _nPosTotal   := aScan(aHeader, {|x| alltrim(x[2])=="C8_TOTAL"})
     Local _nPosCodTab  := aScan(aHeader, {|x| alltrim(x[2])=="C8_CODTAB"})
     Local _lRet := .t., _nPosDel := Len(aHeader)+1
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC8","SC1","SC7"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     //If cEmpAnt == "01"  // DELLA VIA
        //
        _n:=n
        For _x:=1 to len(aCols)
            //
            // Caso o usuario preencha uma linha com o codigo da tabela
            // o programa replica para os outros itens que ainda nao tenha 
            // a tabela preenchida para facilitar. Solicitacao feita em 28/10/05
            // pela usuaria Cleusa com aprovacao do Sr. Rodrigo.
	        If _x<>n .and. Empty(aCols[_x, _nPosCodTab])
	           aCols[_x, _nPosCodTab] := aCols[n, _nPosCodTab]
	           n:=_x
	           M->C8_CODTAB := aCols[_x, _nPosCodTab]
	           A150Tabela("M->C8_CODTAB",aCols[_x, _nPosCodTab])
	           n:=_n
	        Endif 
	        //
	        // Facilitador para replicar os precos para os outros itens
	        // iguais caso existam. Solicitacao feita pelo Sr. Renato Trovati
	        // em 05/09/05 com aprovacao pelo Comite.
	        If _x<>n .and. aCols[_x, _nPosProduto]==aCols[n, _nPosProduto]
	           aCols[_x, _nPosPreco] := aCols[n, _nPosPreco]
	           aCols[_x, _nPosTotal] := aCols[_x, _nPosPreco]*aCols[_x, _nPosQuant]
	           n:=_x
	           M->C8_TOTAL:=aCols[_x, _nPosTotal]
	           A150Total(M->C8_TOTAL)
	           MaFisRef("IT_VALMERC","MT150",M->C8_TOTAL)
	           n:=_n
	        Endif
	    Next
	    //     
	 //Endif        
     //
     // Restaura Areas
     For _nX1 := 1 To Len(_aAlias1)
         dbSelectArea(_aAlias1[_nX1,1])
         dbSetOrder(_aAlias1[_nX1,2])
         dbGoTo(_aAlias1[_nX1,3])
     Next
     RestArea(_aArea1)
     //
Return .t.
