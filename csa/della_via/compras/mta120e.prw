
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA120E  �Autor  �Alexandre Martim    � Data �  21/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para tratar da exclusao de pedido de com-���
���          �pra. Caso os itens sejam se saida retira a amarracao com o  ���
���          �pedido de compra da tabela SL2 de orcamentos.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA120E()
     //
     Local _aArea1 , _nX1 ,  _aArqs1 , _aAlias1
     Local _lRet := .t.
     //
     //Local _cNum := SC7->C7_NUM
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
        DbSelectArea("SC7")
        DbSetOrder(1)
        If DbSeek(xFilial("SC7")+cA120Num,.F.)
           //
           If !Empty(SC7->C7_ORCATO)
              Do While !Eof() .and. SC7->C7_NUM==cA120Num .and. SC7->C7_FILIAL==xFilial("SC7")
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
	 // Restaura Areas
     For _nX1 := 1 To Len(_aAlias1)
         dbSelectArea(_aAlias1[_nX1,1])
         dbSetOrder(_aAlias1[_nX1,2])
         dbGoTo(_aAlias1[_nX1,3])
     Next
     RestArea(_aArea1)
     //
Return _lRet

