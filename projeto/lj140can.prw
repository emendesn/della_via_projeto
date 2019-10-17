/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � LJ140CAN �Autor  �Paulo Benedet          � Data �  30/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - Permite exclusao                                 ���
���          �        .F. - Nao permite exclusao                             ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado apos clicar no botao excluir do    ���
���          � browse na tela de exclusao de vendas/orcamentos.              ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���Paulo Benedet �30/05/05�Nao ha�Nao permitir exclusao de orcamentos gerados���
���              �        �      �pelo televendas.                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function LJ140CAN()
Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local lRet := .T.
Local cClieFor	:= SF2->F2_CLIENTE
Local cLoja		:= SF2->F2_LOJA
Local cPrefixo	:= IIf(Empty(SF2->F2_PREFIXO),&(GetMv("MV_1DUPREF")),SF2->F2_PREFIXO)
Local cTpVlCan	:= SuperGetMv("MV_TPVLCAN",,"DP")

// Verifica se orcamento foi gerado pelo televendas
If !Empty(SL1->L1_NUMSUA) .And. Empty(SL1->L1_DOC)
	MsgAlert(OemtoAnsi("Este or�amento foi gerado pelo televendas, portanto n�o poder� ser exclu�do!"), "Aviso")
	lRet := .F.
EndIf

//Marcelo
dbSelectArea("SE1")
dbSetOrder(2)

If lRet .And. dbSeek(xFilial("SE1")+cClieFor+cLoja+cPrefixo+SF2->F2_DUPL)
	
	While !Eof() .And. E1_FILIAL ==  xFilial("SE1") .And. E1_CLIENTE == cClieFor .And.;
				  E1_PREFIXO == cPrefixo .And. E1_NUM == SF2->F2_DUPL

		//�������������������������������������������������������������������������������Ŀ
		//� Sera Validado somente os Tipos de Titulos que estiver no parametro MV_TPVLCAN �
		//���������������������������������������������������������������������������������
		If E1_TIPO $ cTpVlCan

			//�����������������������������������������������������������������������������Ŀ
			//� Verifica se eh o titulo principal                                           �
			//�������������������������������������������������������������������������������
			If lRet .And. SE1->E1_TIPO $ MVIRABT+"/"+MVINABT+"/"+MVCFABT+"/"+MVCSABT+"/"+MVPIABT
				Help(" ",1,"NAOPRINCIP")
				lRet := .F.
			EndIf
			//�����������������������������������������������������������������������������Ŀ
			//� Verifica se o titulo esta em carteira                                       �
			//�������������������������������������������������������������������������������
			If lRet .And. SE1->E1_SITUACA <> "0"
				Help(" ",1,"FA040SITU")
				lRet := .F.
			EndIf
			//�����������������������������������������������������������������������������Ŀ
			//� Verifica se o titulo possui bordero                                         �
			//�������������������������������������������������������������������������������
			If lRet .And. !Empty(SE1->E1_NUMBOR)
				Help(" ",1,"A520NUMBOR")
				lRet := .F.
			EndIf
			If !lRet
				Exit
			EndIf
		EndIf
	
		dbSkip()
	End

	//	If !FaCanDelCR("SE1","LOJA701")
	//		lRet:= .F.
	///	EndIf

EndIF

RestArea( aArea )
RestArea( aAreaSE1 )

Return(lRet)
