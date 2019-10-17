#Include "DellaVia.ch"

User Function SF1100E
	Local aArea := GetArea()

	If AllTrim(FunName()) = "MATA103" .And. SF1->F1_TIPO = "B" .And. SM0->M0_CODIGO == "03"
		// Retorna Status da Pre-Coleta
		dbSelectArea("ZZ2")
		dbSetOrder(1)
		dbSeek(xFilial("ZZ2")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		If Found()
			If RecLock("ZZ2",.F.)
				ZZ2->ZZ2_STATUS := "1"
				MsUnlock()
			Endif
		Endif

		// Exclui OP
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+SD1->D1_NUMC2)

		Do While ! Eof() .And. SC2->C2_FILIAL + SC2->C2_NUM == xFilial("SC2") + SD1->D1_NUMC2
			if RecLock("SC2",.F.)
				dbDelete()
				MsUnlock()
			Endif
			dbSkip()
		Enddo
	Endif

	RestArea(aArea)
Return nil