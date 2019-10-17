
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120F   ºAutor  ³Alexandre Martim    º Data ³  17/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada no final da gravacao do pedido de compra º±±
±±º          ³para zerar as aprovacoes e gravar o numero do pedido de com-º±±
±±º          ³pra no item do orcamento de venda (tabela SL2) para os pro- º±±
±±º          ³duto de saida rapida evitando novas amarracoes.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120F()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local _lRet := .t.
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC7","SCR","SB1"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     If cEmpAnt == "01"  // DELLA VIA
        //
	     // Se campo estiver preenchido trata-se de pedido de produto de saida rapida
	     // elimina-se os niveis de alcadas caso existam.
	     If !Empty(SC7->C7_ORCATO)
	        DbSelectArea("SCR")
	        DbSetOrder(1)
	        If DbSeek(xFilial("SCR")+"PC"+cA120Num,.F.)
	           Do While !Eof() .and. SCR->CR_NUM==cA120Num .and.;
	                    SCR->CR_TIPO=="PC" .and. SCR->CR_FILIAL==xFilial("SCR")
	              If Reclock("SCR",.f.)
	                 DbDelete()
	                 MsUnlock()
	              Endif
	              DbSelectArea("SCR")
	              DbSkip()
	           Enddo
	        Endif
	        DbSelectArea("SC7")
	        DbSetOrder(1)
	        If DbSeek(xFilial("SC7")+cA120Num,.F.)
	           Do While !Eof() .and. SC7->C7_NUM==cA120Num .and.;
	                    SC7->C7_FILIAL==xFilial("SC7")
	              If Reclock("SC7",.f.)
	                 SC7->C7_APROV   := ""
	                 SC7->C7_CONAPRO := "L"
	                 MsUnlock()
	              Endif
	              //
	              // Atualizo o orcamento com o numero do pedido de compra
	              DbSelectArea("SL2")
	              DbSetOrder(1)
	              If DbSeek(xFilial("SL2")+SC7->C7_ORCATO+SC7->C7_ORCITEM,.f.)
	                 If Reclock("SL2",.f.)
	                    SL2->L2_PEDCOM := cA120Num
	                    MsUnlock()
	                 Endif
	              Endif
	              DbSelectArea("SC7")
	              DbSkip()
	           Enddo
	        Endif
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

