
User Function AtuQtd2UM
	Processa({|| RunProc()})
Return

Static Function RunProc


LOCAL _aArea := GetArea()

dbSelectArea("SB2")
dbSetOrder(1)
//dbSeek(xFilial("SB2")+"180CNTMB       ")
dbGotop()

ProcRegua(RecCount())

While !eof() //.AND. SB2->B2_COD == "180CNTMB       " 

	IF SB2->B2_LOCAL == "02"
		SB2->( dbSkip() )
		Loop
	EndIF
		
	IncProc(" Produto " + SB2->B2_COD + " " )
	
	SB1->( dbSetOrder(1) )
	SB1->(dbSeek(xFilial("SB1")+SB2->B2_COD+SB2->B2_LOCAL ) )
	
	IF SB1->B1_GRUPO <> "BAND"
		dbSelectArea("SB2")
		SB2->( dbSkip() )
		Loop
	EndIF
	
	dbSelectArea("SB2")
	Reclock("SB2",.F.)
		SB2->B2_QTSEGUM  := IIF( SB1->B1_TIPCONV == 'D', SB2->B2_QATU / SB1->B1_CONV,SB2->B2_QATU * SB1->B1_CONV) //OK
		SB2->B2_VATU2    := IIF( SB1->B1_TIPCONV == 'D', SB2->B2_VATU1 / SB1->B1_CONV,SB2->B2_VATU1 * SB1->B1_CONV)
		SB2->B2_QFIM2    := IIF( SB1->B1_TIPCONV == 'D', SB2->B2_QFIM / SB1->B1_CONV,SB2->B2_QFIM * SB1->B1_CONV)
		SB2->B2_VFIM2    := IIF( SB1->B1_TIPCONV == 'D', SB2->B2_VFIM1 / SB1->B1_CONV,SB2->B2_QFIM * SB1->B1_CONV)
	MsUnlock()

	SB2->( dbSkip() )
	
EndDo

RestArea(_aArea)
//Gravacao do B2, somente por que sera iniciado um novo periodo.

Return