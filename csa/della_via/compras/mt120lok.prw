
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT120LOK บAutor  ณAlexandre Martim    บ Data ณ  05/09/05   บฑฑ
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

User Function MT120LOK()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local _nPosProduto := aScan(aHeader, {|x| alltrim(x[2])=="C7_PRODUTO"})
     Local _nPosQuant   := aScan(aHeader, {|x| alltrim(x[2])=="C7_QUANT"})
     Local _nPosPreco   := aScan(aHeader, {|x| alltrim(x[2])=="C7_PRECO"})
     Local _nPosTotal   := aScan(aHeader, {|x| alltrim(x[2])=="C7_TOTAL"})
     Local _nPosCodTab  := aScan(aHeader, {|x| alltrim(x[2])=="C7_CODTAB"})
     Local _nPosTES     := aScan(aHeader, {|x| alltrim(x[2])=="C7_TES"})
     Local _nPosOper    := aScan(aHeader, {|x| alltrim(x[2])=="C7_OPER"})
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
     If cEmpAnt == "01"  // DELLA VIA
        //               
        If n==1 // Empty(aCols[len(aCols), _nPosCodTab]) .or. Empty(aCols[len(aCols), _nPosOper])
	       _n:=n
	       For _x:=1 to len(aCols)
	            //
	            // Caso o usuario preencha uma linha com o codigo da tabela
	            // o programa replica para os outros itens que ainda nao tenha 
	            // a tabela preenchida para facilitar. Solicitacao feita em 09/11/05
	            // pelo usuario Claudio com aprovacao do Sr. Rodrigo.
	            //
		        If _x<>n
		           aCols[_x, _nPosOper] := aCols[n, _nPosOper]
		           n:=_x
		           M->C7_OPER := aCols[_x, _nPosOper]
	               aCols[_x, _nPosTES]  := u_MaTesVia(1,M->C7_OPER,cA120Forn,cA120Loj,"F",aCols[_x, _nPosProduto],"C7_TES")
		           n:=_n
	            Endif
	            //
		        If _x<>n .and. Empty(aCols[_x, _nPosCodTab])
		           aCols[_x, _nPosCodTab] := aCols[n, _nPosCodTab]
		           n:=_x
		           M->C8_CODTAB := aCols[_x, _nPosCodTab]
		           A120Tabela("M->C7_CODTAB",aCols[_x, _nPosCodTab])
		           n:=_n
		        Endif 
		        //
		   Next
        Endif
	    //     
	 Endif        
     //

	// Valida็ใo incluida por Denis
	// Trava a inclusใo de itens duplicados no PC
	// ***********************************************************************************************
	lRet := .T.
	If cA120Forn = AllTrim(SuperGetMv("DV_FORNPIR",.F.,"000567"))
		cCod := aCols[n,_nPosProduto]
		For kk = 1 to Len(aCols)
			if !aCols[kk,Len(aCols[kk])] .and. kk <> n
				if aCols[kk,_nPosProduto] = cCod
					Help(" ",1,"Pirelli",,"Nao e permitido 2 ou mais itens com o mesmo codigo",4,1)
					lRet := .F.
					exit
				Endif
			Endif
		Next kk
	Endif
	// ***********************************************************************************************

     // Restaura Areas
     For _nX1 := 1 To Len(_aAlias1)
         dbSelectArea(_aAlias1[_nX1,1])
         dbSetOrder(_aAlias1[_nX1,2])
         dbGoTo(_aAlias1[_nX1,3])
     Next
     RestArea(_aArea1)
     //
Return lRet