
User Function AceMot()

Processa({|| Acerta()},"Acertando Motorista no SC2")

Return
                        


Static Function Acerta()

dbSelectArea("SC2")
ProcRegua(RecCount())
dbGoTop()

While ! Eof()

	IncProc()

	dbSelectArea("SF1")
	dbSetOrder(1)
	MsSeek(xFilial("SF1")+SC2->C2_NUM,.F.)
	
	If ! Eof() .And. SF1->F1_TIPO = "B"

		SA1->( dbSetOrder( 1 ) )
		SA3->( dbSetOrder( 1 ) )

		SA1->( MsSeek( xFilial("SA1") + SF1->( F1_FORNECE + F1_LOJA ) ) )
		SA3->( MsSeek( xFilial("SA3") + SA1->A1_VEND3 ) )
    	
		dbSelectArea("SC2")
		RecLock("SC2",.F.)
		SC2->C2_XMOTORI := SA3->A3_NREDUZ
		MsUnlock()

	Endif
	
	dbSelectArea("SC2")
	dbSkip()

Enddo
      
Alert("Fim do processamento")

Return