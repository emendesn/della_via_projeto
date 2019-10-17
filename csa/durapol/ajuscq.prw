
USER FUNCTION AJUSCQ

	Processa({|| Atualiza()},"Atualizando SE1")

RETURN


STATIC FUNCTION Atualiza

LOCAL lGrava := .F.
LOCAL nProc         := 0
LOCAL nProc2        := 0

cMsg := "Prosseguir a Atualizacao?"

If ! MsgYesNo(cMsg,"Confirma")
    MsgAlert("Atualizacao nao efetuada.")
	Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Processos iniciais...                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

dbSelectArea("SC6")
dbSetOrder(1)
dbGotop()

ProcRegua(1000)

While !Eof()

	IncProc("Processados: "+Alltrim(Str(nProc2))+" PEDIDO "+SC6->C6_NUM+SC6->C6_ITEM)
	nProc ++
	nProc2 ++
	
	If nProc > 1000
		ProcRegua(1000)
		nProc := 0
	Endif

	IF Empty(SC6->C6_NFORI)
		dbSkip()
		Loop
	EndIF
	
	SD7->(dbSetOrder(4))
	SD7->(dbSeek(xFilial("SD7")+SC6->C6_NUMOP+SC6->C6_ITEMOP+"001"+SC6->C6_PRODUTO))
	While ! Eof() .and. xFilial("SD7") == SD7->D7_FILIAL .AND. ;
		SD7->D7_X_OP+SD7->D7_PRODUTO == SC6->C6_NUMOP+SC6->C6_ITEMOP+"001"+SC6->C6_PRODUTO	
           /*
		IF SD7->D7_TIPO == 0
			dbSkip()
			Loop
		EndIF
		*/
		lGrava := .T.
		dbSelectArea("SD7")
		dbSkip()
	EndDo
	
    IF lGrava
    	dbSetOrder(1)
	    dbSeek(xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
	    Reclock("SC6",.F.)
	    	SC6->C6_X_FABRI := 'S'
	    MsUnlock()
	    lGrava := .F.
    EndIF
   
    dbSelectArea("SC6")
    dbSkip()
    
EndDo

RETURN