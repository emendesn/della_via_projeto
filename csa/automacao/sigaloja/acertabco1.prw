//#include "TBICONN.CH" 

User Function AcertaBCO1()
Local aSay			:=	{}
Local aButton		:=	{}
Local lOk			:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Texto explicativo da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSay, "Esta rotina tem por objetivo efetuar a manutenção na tabela Tituloas a Receber  " )
aAdd( aSay, "Atualizando o campo E1_BCO1 para o banco portador definido na Venda Assistida.  " )
aAdd( aSay, "Dependendo da quantidade de vendas efetuadas, a execução desta rotina pode      " )
aAdd( aSay, "demorar alguns minutos.                                                         " )

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
FormBatch( "Atualização do Banco Pordador", aSay, aButton )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acao executada caso o usuario confirme a tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk
	Processa({|lEnd| ProcBco1(@lEnd)},"Atualizando do campo E1_BCO1 - Aguarde","Atualizando Banco Pordador...",.T.)
Endif

Return Nil

Static Function ProcBco1(lEnd)
Local cDoc          
Local cSerie
Local cCliente
Local cLoja
Local _cSerieSE1

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
	
	if L1_DOC = "036639" .AND. L1_FILIAL = "05"
		ApMsgInfo("TESTE","")
	ENDIF

	// Posiciona SF2 para pegar serie do financeiro
	SF2->(dbSetOrder(1))  //Filial+doc+serie
	If SF2->(dbSeek(SL1->L1_FILIAL + cDoc + cSerie))
		//_cSerieSE1	:= &(GETMV("MV_LJPREF"))
		_cSerieSE1	:= IF(ALLTRIM(SF2->F2_ESPECIE)=="CF",SF2->F2_SERIE,"U"+SL1->L1_FILIAL)
	EndIf

	SE1->(dbSetOrder(1))	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If SE1->(dbSeek(xFilial("SE1") + _cSerieSE1 + cDoc))
		While !SE1->(Eof()) .and. SE1->E1_PREFIXO==_cSerieSE1 .AND. SE1->E1_NUM==cDoc
			If  Empty(SE1->E1_BCO1)
				RecLock("SE1",.F.)
				SE1->E1_BCO1:= SL1->L1_BCO1
				SE1->(msUnlock())
			Endif
			SE1->(dbSkip())
		EndDo
	else
	EndIf
	dbSelectArea("SL1")
	dbSkip()
EndDo

ApMsgInfo("Atualização concluída","Atualização Banco Portador")

Return

