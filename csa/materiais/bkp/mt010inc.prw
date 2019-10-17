
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010INC  �Autor  �Microsiga           � Data �  02/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chamar tela de veiculos apos inclusao                      ���
�������������������������������������������������������������������������͹��
���Uso       � Ponto de entrada da tela de produtos                       ���
���          � Personalizado Della Via                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT010INC()

//Nao considero na empresa Durapol
IF SM0->M0_CODIGO <> "03"
	// Adiciona SB0 - nao apagar (produtos de venda precisam deste registro)
	SB0->(dbSetOrder(1))
	If !(SB0->(dbSeek(xFilial("SB0") + SB1->B1_COD)))
		RecLock("SB0", .T.)
		B0_FILIAL  := xFilial("SB0")
		B0_COD     := SB1->B1_COD
		B0_PRV1    := 0.01
		msUnlock()
	EndIf
	
	// Chama tela de inclusao prd x veiculo
	P_DELA003("SB1", SB1->(RecNo()), 9)
EndIF
Return
