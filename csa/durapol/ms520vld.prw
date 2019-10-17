
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MS520VLD  ºAutor  ³Microsiga           º Data ³  02/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cancelamento da aplicação do desconto financeiro na nota   º±±
±±º          ³ fiscal de saída                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MS520VLD()

LOCAL lRet      := .T.
LOCAL _cTesVend := GetMV("MV_X_TSVED")

DbSelectArea("SC6")
DbSetOrder(4)

IF DbSeek(xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE)
	While !Eof() .AND. SC6->C6_NOTA == SF2->F2_DOC .AND. SC6->C6_SERIE == SF2->F2_SERIE
		IF SC6->C6_TES $ _cTesVend 
		    _cPedido := SC6->C6_NUM
			RecLock("SC6")
			SC6->C6_VALOR   := (SC6->C6_VALOR + SC6->C6_VALDESC)
			SC6->C6_PRCVEN  := (SC6->C6_VALOR / SC6->C6_QTDVEN)
			SC6->C6_VALDESC := 0
			SC6->C6_DESCONT := 0
			MsUnlock()
		ENDIF
		SC6->(DbSkip())
	EndDo
ENDIF

// desfaz baixa da NCC

dbSelectArea("SE5")
dbSetOrder(1)
dbSeek(xFilial("SE5")+DtoS(SF2->F2_EMISSAO)+"SEP000010000000001"+Alltrim(SF2->F2_SERIE)+Alltrim(SF2->F2_DOC))
	
While !Eof() .And. SE5->(E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+Alltrim(E5_NUMCHEQ)) == ;
	xFilial("SE5")+DtoS(SF2->F2_EMISSAO)+"SEP000010000000001"+Alltrim(SF2->F2_SERIE)+Alltrim(SF2->F2_DOC)
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
		RecLock("SE1",.F.)
		If SE5->E5_SEQ == "01"
	    	SE1->E1_BAIXA   := CtoD("")
			SE1->E1_NUMBOR  := " "
			SE1->E1_LOTE    := " "
			SE1->E1_MOVIMEN := CtoD("")
		Endif	
		SE1->E1_SALDO  := SE1->E1_SALDO + SE5->E5_VALOR
		SE1->E1_VALLIQ := 0
		SE1->E1_STATUS := "A"
		If SE1->E1_SALDO > SE1->E1_VLCRUZ
			SE1->E1_SALDO := SE1->E1_VLCRUZ
		Endif	
		MsUnlock()
	Endif
	
	dbSelectArea("SE5")
	RecLock("SE5",.F.)
	dbDelete()
	MsUnlock()

	dbSkip()
	
Enddo	

Return(lRet)