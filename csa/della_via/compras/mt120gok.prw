
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120GOK ºAutor  ³Alexandre Martim    º Data ³  21/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada para tratar da exclusao de pedido de com-º±±
±±º          ³pra. Caso os itens sejam se saida retira a amarracao com o  º±±
±±º          ³pedido de compra da tabela SL2 de orcamentos.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120GOK()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local _lRet := .t.
     //
     Local _cNum    := Paramixb[1]
     Local _lInclui := Paramixb[2]
     Local _lAltera := Paramixb[3]
     Local _lExclui := Paramixb[4]
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC7","SCR","SB1","SL2"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     If cEmpAnt == "01"  // DELLA VIA
        //
        If _lExclui
          //
          DbSelectArea("SC7")
          DbSetOrder(1)
          If DbSeek(xFilial("SC7")+_cNum,.F.)
             //
             If !Empty(SC7->C7_ORCATO)
	            Do While !Eof() .and. SC7->C7_NUM==_cNum .and. SC7->C7_FILIAL==xFilial("SC7")
	               //
	               // Atualizo o orcamento retirando a amarracao
	               //
	               DbSelectArea("SL2")
	               DbSetOrder(1)
	               If DbSeek(xFilial("SL2")+SC7->C7_ORCATO+SC7->C7_ORCITEM,.f.)
	                  If Reclock("SL2",.f.)
	                     SL2->L2_PEDCOM := ""
	                     MsUnlock()
	                  Endif
	               Endif
	               DbSelectArea("SC7")
	               DbSkip()
	               //
	            Enddo
	         Endif
             //
          Endif 
          //
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
Return

