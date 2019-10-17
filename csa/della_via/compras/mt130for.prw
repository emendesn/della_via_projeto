
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT130FOR ºAutor  ³Alexandre Martim    º Data ³  05/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Caso a unidade federativa do fornecedor for diferente da  º±±
±±º          ³ loja da solicitacao pesquisada pelo campo SC1->C1_FILENT   º±±
±±º          ³ ---> SM0->M0_ESTENT, exclui-se o mesmo para nao aparecer   º±±
±±º          ³ no acols                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT130FOR()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local aFornec := Paramixb
     //
     // Salva Areas
     _aArea1   := GetArea()
     _aArqs1   := {"SC8","SM0","SC7","SC1","SA2"}
     _aAlias1  := {}
     For _nX1  := 1 To Len(_aArqs1)
         dbSelectArea(_aArqs1[_nX1])
         AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     Next                                      
     //
     If cEmpAnt == "01"  // DELLA VIA
        //
        // Caso a unidade federativa do fornecedor for diferente da loja da solicitacao
        // pesquisada pelo campo SC1->C1_FILENT ---> SM0->M0_ESTENT, exclui-se o mesmo 
        // para nao aparecer no acols.
        //
        If Len(aFornec) > 0
           _nTotal := Len(aFornec)
           _nX1 := 1
           Do While _nX1 <= _nTotal
               _lDelete:=.f.
               DbSelectArea("SA2")
               If DbSeek(xFilial("SA2")+aFornec[_nX1,1]+aFornec[_nX1,2],.f.)
                  If !Empty(SC1->C1_FILENT)
                     DbSelectArea("SM0")
                     If Dbseek(cEmpant+SC1->C1_FILENT,.f.)
                        If SA2->A2_EST <> SM0->M0_ESTENT
                           Adel(aFornec,_nX1)
                           ASize(aFornec, len(aFornec)-1)
                           _nTotal  -=  1
                           _lDelete := .t.
                        Endif
                     Endif
                  Endif
               Endif
               If !_lDelete
                  _nX1 += 1
               Endif
           Enddo
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
Return aFornec
