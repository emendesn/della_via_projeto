
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
//
// Funcao abaixo inserida por Adriano Luis Brandao (Microsiga) B.I. 11/07/05.
//
//���������������������������������������������������������Ŀ
//�Nao executa o bloco abaixo quando a inclusao de protutos �
//�eh feita de forma atomatica                              �
//�����������������������������������������������������������
If !l010Auto

	MsgRun("Enviando e-mail de confirmacao de cadastro novo",,{ || U_RWF001("Produto",SB1->B1_COD,SB1->B1_DESC)}) // executa e-mail de solicitacao de cadastros.
	
	If cEmpAnt == "01"
	
		// Adiciona SB0
		SB0->(dbSetOrder(1))
		If !(SB0->(dbSeek(xFilial("SB0") + SB1->B1_COD)))
			RecLock("SB0", .T.)
			B0_FILIAL  := xFilial("SB0")
			B0_COD     := SB1->B1_COD
			B0_PRV1    := 0.01
			msUnlock()
		EndIf
		
		P_DELA003("SB1", SB1->(RecNo()), 9)
	
	EndIf

EndIf

Return