/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A100DEL  ºAutor  ³Jader               º Data ³  10/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui ordem de producao gerada automaticamente na NFE     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function A100DEL()
	Local _aArea      := GetArea()
	Local _lRet       := .T.

	//-- Somente executa tratamento para Notas Fiscais de Coleta (Tipo Beneficiamento) da Empresa Durapol (03)
	If FunName() = "MATA103" .And. SF1->F1_TIPO = "B" .And. SM0->M0_CODIGO == "03" 

		_lRet := .F.
		MsgStop("Nota fiscal de coleta não pode ser excluida.","Atencao")

        /*
		// Posiciona no item da NF para pegar o Nr. da OP gerada - Denis
		dbSelectArea("SD1")
		dbSetOrder(1)
		MsSeek(xFilial("SD1")+SF1->F1_DOC,.F.)

		// Verifica se a movimentacoes para a OP gerada automaticamente
		dbSelectArea("SC2")
		dbSetOrder(1)
		//MsSeek(xFilial("SC2")+SF1->F1_DOC,.F.) - Denis
		MsSeek(xFilial("SC2")+SD1->D1_NUMC2,.F.)

		While !Eof() .And. SC2->C2_FILIAL + SC2->C2_NUM == xFilial("SC2") + SD1->D1_NUMC2
			dbSelectArea("SD3")
			dbSetOrder(1)
			If MsSeek(xFilial("SD3")+SC2->C2_NUM,.F.)
				MsgStop("A nota fiscal nao pode ser excluida pois existem apontamentos para a OP realacionada a ela. Verifique.","Atencao")
				_lRet := .F.
				Exit
			Endif

			dbSelectArea("SC2")
			dbSkip()
		Enddo
		*/
	Endif

	RestArea(_aArea)
Return(_lRet)