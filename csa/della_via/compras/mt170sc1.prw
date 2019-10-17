
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT170SC1 ºAutor  ³Alexandre Martim    º Data ³  26/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada no final da gravacao das solicitacoes pa º±±
±±º          ³gravar o centro de custo da filial.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT170SC1()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     //
     // Salva Areas
     //_aArea1   := GetArea()
     //_aArqs1   := {"SC7","SCR","SB1","SC1"}
     //_aAlias1  := {}
     //For _nX1  := 1 To Len(_aArqs1)
     //    dbSelectArea(_aArqs1[_nX1])
     //    AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
     //Next                                      
     //
     If cEmpAnt == "01"  // DELLA VIA
        SC1->C1_CC     := Posicione("SZ1",1, xFilial("SZ1")+ SM0->M0_CODIGO + SM0->M0_CODFIL ,"Z1_CCATAC")
        SC1->C1_FILENT := cFilAnt // Correcao da filial de entrega
     Endif
     //
     // Restaura Areas
     //For _nX1 := 1 To Len(_aAlias1)
     //    dbSelectArea(_aAlias1[_nX1,1])
     //    dbSetOrder(_aAlias1[_nX1,2])
     //    dbGoTo(_aAlias1[_nX1,3])
     //Next
     //RestArea(_aArea1)
     //
Return
