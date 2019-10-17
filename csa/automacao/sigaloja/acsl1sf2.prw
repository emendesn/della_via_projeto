//#include "TBICONN.CH" 

User Function AcSL1SF2()
Local aSay			:=	{}
Local aButton		:=	{}
Local lOk			:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Texto explicativo da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSay, "Esta rotina tem por objetivo efetuar a manutenção na de nota fiscal" )
aAdd( aSay, "Atualizando o campo E2_PLACA, F2_CODCON, F2_CODMAR, F2_CODMOD, F2_KM")
aAdd( aSay, "F2_ANO, F2_ORIGEM com base no venda assistida e televendas." )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Botoes da tela principal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Confirma
aAdd( aButton, { 1,.T.,	{|| (lOk := .T.,FechaBatch())}} )
//Cancela
aAdd( aButton, { 2,.T.,	{|| FechaBatch()}} )

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre a tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
FormBatch( "Atualização Nota", aSay, aButton )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acao executada caso o usuario confirme a tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk
	Processa({|lEnd| ProcSF2(@lEnd)},"Atualizando cabecalho da NF - Aguarde","Atualizando cabecalho da NF",.T.)
Endif

Return Nil

Static Function ProcSF2(lEnd)
Local cDoc
Local cSerie

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SE1", "SL1", "SF2"

dbSelectArea("SL1")
dbSetOrder(1)

ProcRegua(RecCount())
dbGotop()

nProc  := 0
nProc2 := 0

While !Eof()

	IncProc("Process. Filial: " + SL1->L1_FILIAL + " Orcam.: " + SL1->L1_NUM +  " Nota: " + SL1->L1_DOC)

	nProc ++
	nProc2 ++

	If Empty(L1_DOC) .and. Empty(L1_SERIE)
		dbSkip()
		Loop
	Endif

	cDoc		:= L1_DOC
	cSerie		:= L1_SERIE
	
//	if L1_DOC = "036639" .AND. L1_FILIAL = "05"
//		ApMsgInfo("TESTE","")
//	ENDIF

	// Posiciona SF2 para pegar serie do financeiro
	SF2->(dbSetOrder(1))  //Filial+doc+serie
	If SF2->(dbSeek(SL1->L1_FILIAL + cDoc + cSerie))
		If Empty(SF2->F2_PLACA) .or. Empty(SF2->F2_CODCON) .or. Empty(SF2->F2_CODMAR) .or.;
		   Empty(SF2->F2_CODMOD) .or. Empty(SF2->F2_KM) .or. Empty(SF2->F2_ANO) .or. ;
		   Empty(SF2->F2_ORIGEM)
			
			RecLock("SF2",.F.)		   
			SF2->F2_PLACA 	:= SL1->L1_PLACAV
			SF2->F2_CODCON 	:= SL1->L1_CODCON
			SF2->F2_CODMAR 	:= SL1->L1_CODMAR
			SF2->F2_CODMOD 	:= SL1->L1_CODMOD
			SF2->F2_KM 		:= SL1->L1_KM
			SF2->F2_ANO 	:= SL1->L1_ANO
			SF2->F2_ORIGEM 	:= "LOJA"

			SF2->(msUnlock())
			SF2->(dbCommit())

		EndIf
	EndIf
	dbSelectArea("SL1")
	dbSkip()
EndDo

ApMsgInfo("Atualização concluída","Atualização do Venda Assistida")

Return

