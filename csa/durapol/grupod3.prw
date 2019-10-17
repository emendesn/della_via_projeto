
User Function GrupoD3
	Processa({|| RunProc()})
Return


Static Function RunProc

LOCAL _aArea := GetArea()

dbSelectArea("SD3")
dbSetOrder(1)
//dbSeek(xFilial("SD3")+"07501507001")
dbGotop()

ProcRegua(RecCount())

While !eof() //.And. xFilial("SD3") == SD3->D3_FILIAL .And. Alltrim(SD3->D3_OP) == "07501507001"

	IF SD3->D3_TM == "001"
		SD3->( dbSkip() )
		Loop
	EndIF
	
	IF SD3->D3_ESTORNO == "S"
		SD3->( dbSkip() )
		Loop
	EndIF
	
	IncProc(" OP " + SD3->D3_OP + " DATA " + DTOS(SD3->D3_EMISSAO) )
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SD3->D3_COD))	
	
	dbSelectArea("SD3")
	Reclock("SD3",.F.)
		SD3->D3_GRUPO := SB1->B1_GRUPO
	MsUnlock()

	SD3->( dbSkip() )
	
EndDo

RestArea(_aArea)

Return