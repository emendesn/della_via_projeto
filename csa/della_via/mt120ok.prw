
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120OK  ºAutor  ³Alexandre Martim    º Data ³  07/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120OK()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local _nPosProduto := aScan(aHeader, {|x| alltrim(x[2])=="C7_PRODUTO"})
     Local _nPosOrcato  := aScan(aHeader, {|x| alltrim(x[2])=="C7_ORCATO"})
     Local _nPosOrcItem := aScan(aHeader, {|x| alltrim(x[2])=="C7_ORCITEM"})
     Local _nPosQuant   := aScan(aHeader, {|x| alltrim(x[2])=="C7_QUANT"})
     Local _nPosItem    := aScan(aHeader, {|x| alltrim(x[2])=="C7_ITEM"})
     Local _lRet := .t., _nPosDel := Len(aHeader)+1, _lHa_Item_de_Saida_Rapida := .f., _lHa_Produto_Normal:=.f.
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC7","SA2","SB1","SF4","SL2"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     If cEmpAnt == "01"  // DELLA VIA
        //
	     For _x:=1 to len(aCols)
	         //
	         DbSelectArea("SB1")
	         DbSetOrder(1)
	         If DbSeek(xFilial("SB1")+aCols[_x, _nPOsProduto],.f.)
	            //
	            If !aCols[_x, _nPosDel]
	               If SB1->B1_GRUPO$GetMV('FS_DEL002',,'0081')
	                  _lHa_Item_de_Saida_Rapida := .t.
	               Else
	                  _lHa_Produto_Normal := .t.
	               Endif
	            Endif
	            //
	            If SB1->B1_GRUPO$GetMV('FS_DEL002',,'0081') .and. Empty(aCols[_x, _nPosOrcato]) .and. !aCols[_x, _nPosDel]
	               Alert("O Item "+aCols[_x, _nPosItem]+" precisa estar associado a um orcamento de venda!")
	               _lRet := .f.
	               exit
	            Endif
	            If !SB1->B1_GRUPO$GetMV('FS_DEL002',,'0081') .and. !Empty(aCols[_x, _nPosOrcato]) .and. !aCols[_x, _nPosDel]
	               Alert("O Item "+aCols[_x, _nPosItem]+" deve ser de saida rapida para associar-se a um orcamento de venda!")
	               _lRet := .f.
	               exit
	            Endif
	            //
	            If !Empty(aCols[_x, _nPosOrcato])
	               DbSelectArea("SL2")
	               DbSetOrder(1)
	               If !DbSeek(xFilial("SL2")+aCols[_x, _nPosOrcato]+aCols[_x, _nPosOrcItem],.f.)
	                  Alert("Nao existe o item ["+aCols[_x, _nPosOrcItem]+"] no orcamento ["+aCols[_x, _nPosOrcato]+"], verifique!")
	                  _lRet := .f.
	               Else
	                  If aCols[_x, _nPosProduto]<>SL2->L2_PRODUTO
	                     Alert("No item ["+aCols[_x, _nPosItem]+"] o produto digitado ["+aCols[_x, _nPosProduto]+"] nao e o mesmo do orcamento ["+SL2->L2_PRODUTO+"], verifique!")
	                     _lRet := .f.
	                  Endif
	                  If aCols[_x, _nPosQuant] > SL2->L2_QUANT
	                     Alert("No item ["+aCols[_x, _nPosItem]+"] a quantidade digitada ["+Alltrim(Str(aCols[_x, _nPosQuant],11,2))+"] e maior que a do orcamento ["+Alltrim(Str(SL2->L2_QUANT,11,2))+"], verifique!")
	                     _lRet := .f.
	                  Endif
	                  If !Empty(SL2->L2_PEDCOM)
	                     Alert("No item ["+aCols[_x, _nPosItem]+"] o Produto-Item do orcamento ["+aCols[_x, _nPosProduto]+"-"+aCols[_x, _nPosOrcItem]+"] ja foi associado ao pedido de compra ["+SL2->L2_PEDCOM+"], verifique!")
	                     _lRet := .f.
	                  Endif
	               Endif
	            Endif
	            //
	         Endif
	         //
    	 Next
	     //
	     If _lHa_Produto_Normal .and. _lHa_Item_de_Saida_Rapida
	        Alert("Existem itens que nao sao de venda rapida no pedido, verifique!")
	        _lRet := .f.
	     Endif
	     //
     Endif
     //
     // Restaura Areas
     For _nX1 := 1 To Len(_aAlias1)
         dbSelectArea(_aAlias1[_nX1,1])
         dbSetOrder(_aAlias1[_nX1,2])
         dbGoTo(_aAlias1[_nX1,3])
     Next
     RestArea(_aArea1)
     //
Return _lRet
