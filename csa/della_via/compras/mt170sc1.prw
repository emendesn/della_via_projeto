
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT170SC1 �Autor  �Alexandre Martim    � Data �  26/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada no final da gravacao das solicitacoes pa ���
���          �gravar o centro de custo da filial.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
