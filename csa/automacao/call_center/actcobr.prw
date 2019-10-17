#Include 'rwmake.ch'

User Function ActCobr()

DbSelectArea("ACG")
DbSetOrder(1)       
DbGotop()

Do While !Eof()

	If ACG->ACG_STATUS # "1"
		DbSkip()
		Loop
	Endif	

	DbSelectArea("SE1")
	DbSetOrder(1)
	If DbSeek(ACG->ACG_FILORIG+ACG->ACG_PREFIXO+ACG->ACG_TITULO+ACG->ACG_PARCEL+ACG->ACG_TIPO)
		If Empty(SE1->E1_BAIXA)
//			MsgBox("Titulo baixado erroneamente ! "	+ACG->ACG_FILORIG+ACG->ACG_PREFIXO+ACG->ACG_TITULO+ACG->ACG_PARCEL+ACG->ACG_TIPO)
			DbSelectArea("ACG")
			RecLock("ACG",.F.)
			ACG->ACG_STATUS 	:= "2"
			MsUnlock()
		Endif
	Else
		MsgBox("Titulo não encontrado ! "	+ACG->ACG_FILORIG+ACG->ACG_PREFIXO+ACG->ACG_TITULO+ACG->ACG_PARCEL+ACG->ACG_TIPO)
	Endif		
	
	DbSelectArea("ACG")
	DbSkip()
	
Enddo	
Return .T.
