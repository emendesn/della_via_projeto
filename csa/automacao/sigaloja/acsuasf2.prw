User Function AcSUASF2()
Local aSay			:=	{}
Local aButton		:=	{}
Local lOk			:=	.F.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿟exto explicativo da rotina�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴�
aAdd( aSay, "Esta rotina tem por objetivo efetuar a manuten豫o na de nota fiscal" )
aAdd( aSay, "Atualizando o campo E2_PLACA, F2_CODCON, F2_ORIGEM, com base nas vendas")
aAdd( aSay, "do televendas." )

//旼컴컴컴컴컴컴컴컴컴컴컴커
//쿍otoes da tela principal�
//읕컴컴컴컴컴컴컴컴컴컴컴켸
//Confirma
aAdd( aButton, { 1,.T.,	{|| (lOk := .T.,FechaBatch())}} )
//Cancela
aAdd( aButton, { 2,.T.,	{|| FechaBatch()}} )

//旼컴컴컴컴컴�
//쿌bre a tela�
//읕컴컴컴컴컴�
FormBatch( "Atualiza豫o Nota", aSay, aButton )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿌cao executada caso o usuario confirme a tela�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If lOk
	Processa({|lEnd| ProcSF2(@lEnd)},"Atualizando cabecalho da NF - Aguarde","Atualizando cabecalho da NF",.T.)
Endif

Return Nil

Static Function ProcSF2(lEnd)
Local cDoc
Local cSerie

dbSelectArea("SUA")
dbSetOrder(1)

ProcRegua(RecCount())
dbGotop()

nProc  := 0
nProc2 := 0

While !Eof()

	IncProc("Process. Filial: " + SUA->UA_FILIAL + " Orcam.: " + SUA->UA_NUM +  " Nota: " + SUA->UA_DOC)

	nProc ++
	nProc2 ++

	If Empty(UA_DOC) .and. Empty(UA_SERIE)
		dbSkip()
		Loop
	Endif

	cDoc		:= UA_DOC
	cSerie		:= UA_SERIE
	cPedido		:= UA_NUMSC5
	
//	if L1_DOC = "036639" .AND. L1_FILIAL = "05"
//		ApMsgInfo("TESTE","")
//	ENDIF
	
	// Posiciona SF2 Cabecalho da NF
	SF2->(dbSetOrder(1))  //Filial+doc+serie
	If SF2->(dbSeek(SUA->UA_FILIAL + cDoc + cSerie))
		If Empty(SF2->F2_PLACA) .or. Empty(SF2->F2_CODCON) .or. Empty(SF2->F2_ORIGEM)
			
			RecLock("SF2",.F.)		   
			SF2->F2_PLACA 	:= SUA->UA_PLACA
			SF2->F2_CODCON 	:= SUA->UA_CODCON
			SF2->F2_ORIGEM 	:= "TMK"

			SF2->(msUnlock())
			SF2->(dbCommit())

		EndIf
	EndIf

	// Posiciona SC5 Pedido
	SC5->(dbSetOrder(1))  //Filial+doc+serie
	If SC5->(dbSeek(SUA->UA_FILIAL + cPedido))
		If Empty(SC5->C5_PLACA) .or. Empty(SC5->C5_CODCON) .or. Empty(SC5->C5_ORIGEM)
			
			RecLock("SC5",.F.)		   
			SC5->C5_PLACA 	:= SUA->UA_PLACA
			SC5->C5_CODCON 	:= SUA->UA_CODCON
			SC5->C5_ORIGEM 	:= "TMK"

			SC5->(msUnlock())
			SC5->(dbCommit())
		EndIf
	EndIf

	dbSelectArea("SUA")
	dbSkip()
EndDo

ApMsgInfo("Atualiza豫o conclu�da","Atualiza豫o do Venda Assistida")

Return

