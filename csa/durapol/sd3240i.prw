User Function SD3240I
	If RecLock("SD3",.F.)
		SD3->D3_HORA := Time()
		MsUnLock()
	Endif
Return nil