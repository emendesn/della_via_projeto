/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110GRV ºAutor  ³BRUNO PAULINELLI      º Data ³ 22/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PONTO DE ENTRADA PARA A SOLICITACAO GERADA SER BLOQUEADA E  º±±
±±º          ³NA ALTERACAO, LIMPAR OS FLAGS UTILIZADO PELO WORKFLOW       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110GRV()
Local lRet 		:= .T.
Local _cNum		:= SC1->C1_NUM
Local _aArea    := GetArea()

If INCLUI
	
		Reclock("SC7",.F.)
		SC1->C1_APROV   := "B"
		//SC1->C1_SITUACA := "N"
		SC1->(MsUnlock())	
EndIf

If ALTERA

		DbSelectArea("SC1")
		DbSetOrder(1)
		SC1->(DbGoTop())
		If DbSeek(xFilial("SC1")+_cNum)
			While !SC1->(Eof()) .AND. _cNum == SC1->C1_NUM
				Reclock("SC1",.F.)
				SC1->C1_WF      := " "
				SC1->C1_WFID    := " "
				//SC1->C1_SITUACA := "N"
				SC1->C1_APROV   := "B" 
				SC1->C1_OBS2    := " "
				SC1->(MsUnlock())	
			SC1->(DbSkip())	
			EndDo
		EndIf
	         
EndIf

RestArea(_aArea)

Return(lRet)