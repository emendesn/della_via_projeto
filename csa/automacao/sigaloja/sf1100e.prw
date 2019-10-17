#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF1100E   �Autor  �Marcelo Alcantara   � Data �  04/11/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para tratar a exclusao de Nota de Devoluca���
���          � 1. Se Foi Gerado com NCC Excluir o Titulo de NCC           ���
���          � 2. Se os Titulos estiverem deletados por nao estarem       ��� 
���          � baixados recupera os titulos                               ���
�������������������������������������������������������������������������͹��
���Parametros�  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Retorno   �  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado apos a exclusao da nota fiscal  ���
���          � entrada (MATA103).                                         ���
���          � Posicionado no registro do SF1.                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                          	  ���
���Marcelo   �11/11/05�Declaracao da variavel _cSerieSE1                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SF1100E
	Local _aArea:= GetArea()
	Local _aAreaSE1:= SE1->(GetArea())
	Local lSetDeleSE1 := SE1->(SET(_SET_DELETED))
	Local lSetDeleSD1 := SD1->(SET(_SET_DELETED))
	Local _cSerieSE1  := ""		//Serie do Titulo gerado no financeiro

	If SF1->F1_TIPO <> "D"  // Se a nota nao for de Devolucao Retorna sem fazer nada
		Return
	Endif

	//���������������������������������������������������������Ŀ
	//�se a devolucao gerau nota de Credito - NCC sera excluida.�
	//�����������������������������������������������������������
	SE1->(dbSetOrder(1))			//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If SE1->(dbSeek(xFilial("SE1")+SF1->F1_SERIE+SF1->F1_DOC)) .And. AllTrim(SE1->E1_TIPO) == "NCC"
		If !Empty(SE1->E1_BAIXA)	// Se a NCC ja estiver baixada nao exclui o titulo
			MsgBox("Nao foi possivel excluir a NCC pos a mesma ja esta baixada")
		Else
			If AllTrim(SF1->F1_FORNECE+SF1->F1_LOJA) == AllTrim(SE1->E1_CLIENTE+SE1->E1_LOJA)
				RecLock("SE1",.F.)
				SE1->(dbDelete())
				SE1->(msUnlock())
			Endif
	    endif
	Endif

	// Excluir NCC, caso nota de beneficiamento.
	If SF1->F1_TIPO = "B"
		SE1->(dbSetOrder(1))			//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		If SE1->(dbSeek(xFilial("SE1")+"U"+cFilAnt+SF1->F1_DOC)) .And. AllTrim(SE1->E1_TIPO) == "NCC"
			If AllTrim(SF1->F1_FORNECE+SF1->F1_LOJA) == AllTrim(SE1->E1_CLIENTE+SE1->E1_LOJA)
				If !Empty(SE1->E1_BAIXA)	// Se a NCC ja estiver baixada nao exclui o titulo
					MsgBox("Nao foi possivel excluir a NCC pois a mesma ja esta baixada")
				Else
					If RecLock("SE1",.F.)
						SE1->(dbDelete())
						SE1->(msUnlock())
					Endif
				Endif
		    endif
		Endif
	Endif
	
	// Posiciona SF2 para pegar serie do financeiro
	SF2->(dbSetOrder(1))  //Filial+doc+serie
	If SF2->(dbSeek(xFilial("SF2") + SD1->D1_NFORI+SD1->D1_SERIORI))
		_cSerieSE1	:= &(GETMV("MV_LJPREF"))
	EndIf

	SE1->(SET(_SET_DELETED, .F.)) // Habilita Titulos Deletados 
	SD1->(SET(_SET_DELETED, .F.)) // Habilita Item de Entrada Deletados 

	//�����������������������������������������������������������������������������������Ŀ
	//�Recupera o Titulo deletado case tenha sido apagado na devolucao por nao haver baixa�
	//�������������������������������������������������������������������������������������
	SE1->(dbSetOrder(1))  // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	if SE1->(dbSeek(xFilial("SE1")+ _cSerieSE1 + SD1->D1_NFORI))  
		While !SE1->(Eof()) .And. SE1->E1_PREFIXO==_cSerieSE1 .AND. SE1->E1_NUM==SD1->D1_NFORI
			//�������������������������������������Ŀ
			//�Se o Titulo estiver deletado recupera�
			//���������������������������������������
			If SE1->(Deleted())
				RecLock("SE1",.F.)
				SE1->(dbRecall())
				SE1->(msUnlock())
	   	 	EndIf
	   	 	SE1->(dbSkip())
	    EndDo
	endif

	SE1->(SET(_SET_DELETED, lSetDeleSE1)) // Restaura ambiente SE1
	SD1->(SET(_SET_DELETED, lSetDeleSD1)) // Restaura ambiente SD1

	RestArea(_aAreaSE1)
	RestArea(_aArea)
Return