User Function AjNomeOP

dbSelectArea("SC2")
dbSetOrder(1)
dbGotop()
While !Eof()

	IF Empty(SC2->C2_XMOTORI)
		
		SF1->(dbSetOrder(1))
		dbSeek(xFilial("SF1")+SC2->C2_NUM)
		
		SA1->(dbSetOrder(1))
		dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		SA3->(dbSetOrder(1))
		dbseek(xFilial("SA3")+SA1->A1_VEND3)
		
		dbSelectArea("SC2")
		Reclock("SC2",.F.)
			SC2->C2_XMOTORI := SA3->A3_NREDUZ
		Msunlock()		
		
	EndIF
	SC2->(dbSkip())
EndDo
Alert("FIM")
Return