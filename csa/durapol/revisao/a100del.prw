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
Local _lMovimento := .F.
Local _lRet       := .T.
                   
//-- Somente executa tratamento para Notas Fiscais de Coleta (Tipo Beneficiamento) da Empresa Durapol (03)
If FunName() = "MATA103" .And. SF1->F1_TIPO = "B" .And. SM0->M0_CODIGO == "03" 

    // verifica se a movimentacoes para a OP gerada automaticamente
	dbSelectArea("SC2")
	dbSetOrder(1)
	MsSeek(xFilial("SC2")+SF1->F1_DOC,.F.)

	While ! Eof() .And. SC2->C2_FILIAL + SC2->C2_NUM == xFilial("SC2") + SF1->F1_DOC
	
		dbSelectArea("SD3")
		dbSetOrder(1)
		If MsSeek(xFilial("SD3")+SC2->C2_NUM,.F.)
		    MsgStop("Existem movimentacoes lancadas para a OP gerada automaticamente. A OP nao sera excluida. Verifique.","Atencao")
			_lMovimento := .T.
			//_lRet       := .F.
		Endif
		
		dbSelectArea("SC2")
		dbSkip()
		
	Enddo

	// caso nao tenha movimentacoes exclui a OP
	If ! _lMovimento

		dbSelectArea("SC2")
		dbSetOrder(1)
		MsSeek(xFilial("SC2")+SF1->F1_DOC,.F.)
	
		While ! Eof() .And. SC2->C2_FILIAL + SC2->C2_NUM == xFilial("SC2") + SF1->F1_DOC
		
			RecLock("SC2",.F.)
			dbDelete()
			MsUnlock()
			
			dbSkip()
			
		Enddo
		
	Endif	
		
Endif

RestArea(_aArea)

Return(_lRet)
