
User Function AceSD3Desc()

Processa({|| Acerta()},"Acertando Descricao do SD3")

Return
                        


Static Function Acerta()

dbSelectArea("SD3")
ProcRegua(RecCount())
dbGoTop()

While ! Eof()

	IncProc()
	    
	_cCod := SD3->D3_COD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+_cCod,.F.)
	
	_cProd := SB1->B1_PRODUTO
	
	MsSeek(xFilial("SB1")+_cProd,.F.)

	_cCodB1 := SB1->B1_COD
	_cDesB1 := SB1->B1_DESC

	dbSelectArea("SD3")
	RecLock("SD3",.F.)
	SD3->D3_X_PROD := _cCodB1
	SD3->D3_XDESC  := _cDesB1
	MsUnlock()

	dbSkip()

Enddo
      
Alert("Fim do processamento")

Return