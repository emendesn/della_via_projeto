

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010BRW  �Autor  �Microsiga           � Data �  05/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona botao veiculos                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Ponto de entrada na manutencao de produtos                 ���
���          � Personalizado Della Via                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT010BRW()
Local aRet := {}
IF SM0->M0_CODIGO <> "03" //Tratamento para excessao na empresa Durapol
	aAdd(aRet, {"Veiculos", "P_DELA003", 0, 4})
EndIF

Return(aRet)
