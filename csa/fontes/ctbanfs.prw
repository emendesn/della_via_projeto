#INCLUDE "CTBANFS.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE OPT_SELECT 1
#DEFINE OPT_FROM   2
#DEFINE OPT_WHERE  3

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矯TBANFS   矨utor  � Eduardo Riera         � Data �20.10.2001 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北�          砇otina de processamento da contabilizacao off-line dos Docu- 潮�
北�          砿entos de Saida.                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpA1: Parametros da rotina                                  潮�
北�          �       Quando informado nao existe a necessidade de interface潮�
北�          �       com o usuario. Pode ser colocado como um servico do   潮�
北�          �       sistema.                                              潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北矰escri噭o 矱sta rotina tem como objetivo contabilizar os documentos de  潮�
北�          硈aida com base nos lancamentos contabeis, de forma off-line  潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       � CTB/FAT/OMS                                                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
Function CTBANFS(aPergunte)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis locais                                      �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local aSays    := {}
Local aButtons := {}
Local nOpcA    := 0
Local nX       := 0
Local cPerg    := "CTBNFS"
Local cMvPar   := ""
Local lAuto    := aPergunte<>Nil
Local oRegua   := Nil
Local cString

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define variaveis Private                                     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Private aRotina   := { { STR0001 ,"AllwaysTrue", 0 , 3} }  //"Parametros"
Private cCadastro := STR0002  //"Lan嘺mentos Contabeis Off-Line"
Private INCLUI    := .T.
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Desliga Refresh no Lock do Top                               �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
#IFDEF TOP
	TCInternal(5,"*OFF")
#ENDIF
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� mv_par01 - Mostra Lancamentos Contabeis ?  Sim Nao           �
//� mv_par02 - Aglutina Lancamentos         ?  Sim Nao           �  
//� mv_par03 - Gerar Lancamentos Por        ?  NF  Periodo Dia   �
//� mv_par04 - Contabiliza C.M.V.           ?  Sim Nao           �
//� mv_par05 - Data Inicial                                      �
//� mv_par06 - Data Final                                        �
//� mv_par07 - Da Filial                                         �
//� mv_par08 - At� a Filial                                      �
//� mv_par09 - Contabiliza Notas de Credito ? Sim Nao            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Montagem da inteface de processamento                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁


/*谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
  矨TENCAO                                                                �
  矯aso haja a necessidade de adicao de novos parametros entrar em contato�
  砪om o departamento de Localizacoes.          						  �
  滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
*/
If cPaisLoc<>"BRA"
	CTBNFSSX1()
Endif

ACertaSX1(cPerg)

If Empty(aPergunte)
	Pergunte(cPerg,.F.)
	aadd(aSays,STR0003) //"   Este programa tem como objetivo gerar automaticamente os"
	aadd(aSays,STR0004) //"lan嘺mentos cont燽eis dos movimentos de saida."
	aadd(aSays,STR0005) //"   ATEN�AO: A visualiza噭o do lan嘺mentos por Nota Fiscal   "
	aadd(aSays,STR0006) //"ter� uma grande interfer坣cia manual.                       "
	
	aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	aadd(aButtons, { 1,.T.,{|| nOpcA:= 1, FechaBatch() }} )
	aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )
Else
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Inicializacao do processamento automatico                    �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	ConOut("-",80)
	ConOut(STR0002+" - "+STR0007,80) //"Lan嘺mentos Contabeis Off-Line"###"Documento de Saida"
	ConOut("")
	ConOut(STR0001) //"Parametros"
	ConOut("")	
	nOpcA := 1
	Pergunte(cPerg,.F.)
	dbSelectArea("SX1")
	dbSetOrder(1)
	MsSeek(cPerg)
	While SX1->(!Eof()) .And. SX1->X1_GRUPO == cPerg
		nX++		
		If nX <= Len(aPergunte)
			cMvPar  := "M->MV_PAR"+StrZero(nX,2)
			&cMvPar := aPergunte[nX]
		
			Do Case
				Case SX1->X1_TIPO=="N"
					cString := AllTrim(Str(aPergunte[nX],SX1->X1_TAMANHO,SX1->X1_DECIMAL))
				Case SX1->X1_TIPO=="D"
					cString := Dtoc(aPergunte[nX])
				Case SX1->X1_TIPO=="C"
					cString := 	aPergunte[nX]
				OtherWise
					cString := "NULL"
			EndCase
		Else
			cString := "NULL"
		EndIf
		ConOut(X1Pergunt()+": "+cString)
		SX1->( dbSkip() )
	EndDo
	ConOut("")
	ConOut("-",80)
EndIf
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Processamento                                                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If	nOpcA == 1
	Do Case
		Case IsBlind() .And. !lAuto
			BatchProcess( 	cCadastro, 	STR0003 + Chr(13) + Chr(10) +;
			STR0004 + Chr(13) + Chr(10) +;
			STR0005 + Chr(13) + Chr(10) +;
			STR0006, "CTBNFS",;
			{ || 	MaCtbNfs(MV_PAR01==1,MV_PAR02==1,MV_PAR03,;
			MV_PAR04==1,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,If(cPaisLoc=="BRA",.F.,MV_PAR09==1),;
			Nil,.F.) }, { || .F. })
		Case !lAuto
			oRegua := MsNewProcess():New({|lEnd| MaCtbNfs(MV_PAR01==1,;
			MV_PAR02==1,;
			MV_PAR03,;
			MV_PAR04==1,;
			MV_PAR05,;
			MV_PAR06,;
			MV_PAR07,;
			MV_PAR08,;
			If(cPaisLoc=="BRA",.F.,MV_PAR09==1),;
			oRegua,;
			@lEnd) },STR0002,"",.T.)//"Lan嘺mentos Contabeis Off-Line"
			oRegua:Activate()
		OtherWise
			ConOut("Starting: "+Time())
			MaCtbNfs(MV_PAR01==1,;
			MV_PAR02==1,;
			MV_PAR03,;
			MV_PAR04==1,;
			MV_PAR05,;
			MV_PAR06,;
			MV_PAR07,;
			MV_PAR08,;
			If(cPaisLoc=="BRA",.F.,MV_PAR09==1),;
			Nil,;
			.F.)
			ConOut("Finished: "+Time())
	EndCase
EndIf

Return(.T.)
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矼aCtbNfs  矨utor  � Eduardo Riera         � Data �20.10.2001 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北�          砇otina de contabilizacao dos documentos de saida off-line    潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpL1: Mostra Lancamento Contabil                            潮�
北�          矱xpL2: Aglutina lancamentos contabeis                        潮�
北�          矱xpN3: Contabilizar por:                                     潮�
北�          �       [1] Documento de Saida                                潮�
北�          �       [2] Periodo                                           潮�
北�          �       [3] Dia                                               潮�
北�          矱xpL4: Contabiliza Custo da Mercadoria Vendida               潮�
北�          矱xpD5: Data de emissao inicial                               潮�
北�          矱xpD6: Data de emissao final                                 潮�
北�          矱xpC7: Codigo da filial inicial                              潮�
北�          矱xpC8: Codigo da filial final                                潮�
北�          矱xpO9: Objeto da interface                              (OPC)潮�
北�          矱xpLA: Flag de cancelamento da rotina                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北矰escri噭o 矱sta rotina tem como objetivo contabilizar os documentos de  潮�
北�          硈aida com base nas regras dos lancamentos padronizados.      潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       � CTB/FAT/OMS                                                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
Static Function MaCtbNfs(lDigita,lAglutina,nTpCtb,lCMV,dDataIni,dDataFim,cFilDe,cFilAte,lContNCP,oObj,lEnd)

Local aArea      := GetArea()
Local aAreaSM0   := SM0->(GetArea())
Local aCT5       := {}
Local dSavBase   := dDataBase
Local dDataProc  := Ctod("")
Local lFirst     := .T.
Local lCtNfsDt   := ExistBlock("CTNFSDT")
Local lFilSf2    := Existblock("CTNFSFIL")
Local lLctPad10  := VerPadrao("610")	// Credito de Estoque / Debito de C.M.V.
Local lLctPad11  := VerPadrao("611")	// Devolucao do item de rateio
Local lLctPad20  := VerPadrao("620")	// Debito de Cliente  / Credito de Venda
Local lLctPad31  := VerPadrao("631")	// Debito de Cliente  / Credito de Venda (Modulo Loja, a partir do SL4)
Local lLctPad78  := VerPadrao("678")	// Credito de Estoque / Debito de C.M.V. (CUSTO)
Local dDtEmissao
Local lLctPad    := .F.
Local lDetProva  := .F.
Local lHeader    := .F.
Local lContinua  := .T.
Local lValido    := .F.
Local lQuery     := .F.
Local lInterface := oObj<>Nil
Local lOptimize  := .F.
Local lSkipSF2   := .F.
Local cLoteCtb   := ""
Local cArqCtb    := ""
Local cAliasSD2  := "SD2"
Local cAliasSF2  := "SF2"
Local cAliasSB1  := "SB1"
Local cAliasSF4  := "SF4"
Local cAliasSA1  := "SA1"
Local cAliasSA2  := "SA2"
Local cCliente   := ""
Local cLoja      := ""
Local cDocumento := ""
Local cSerie     := ""
Local c610       := Nil
Local c611       := Nil
Local c620       := Nil
Local c631       := Nil
Local c678       := Nil
Local cQuery     := ""
Local cKeySF2    := "F2_FILIAL+DTOS(F2_EMISSAO)+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA"
Local cArqSF2    := ""
Local nHdlPrv    := 0 
Local nTotalCtb  := 0
Local nOrdSF2    := 0
Local nRecSF2    := 0
Local nY         := 0
Local nUltSD2	 := 1
Local lF2DTDIG		:= SF2->(FieldPos("F2_DTDIGIT"))> 0
#IFDEF TOP
	Local aOptimize  := {}
	Local aStruSA1   := {}
	Local aStruSA2   := {}
	Local aStruSD2   := {}
	Local aStruSB1   := {}
	Local aStruSF2   := {}
	Local aStruSF4   := {}
	Local cString    := ""
	Local nX         := 0	
#ENDIF	
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Inicializa parametros DEFAULT                                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DEFAULT lDigita   := .F.
DEFAULT lAglutina := .F.
DEFAULT nTpCtb    := 1
DEFAULT dDataIni  := FirstDay(dDataBase)
DEFAULT dDataFim  := LastDay(dDataBase)
DEFAULT lCMV      := .F.
DEFAULT cFilDe    := cFilAnt
DEFAULT cFilAte   := cFilAnt
DEFAULT lContNCP  := .T.
DEFAULT lEnd      := .F.
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Compatibilizacao dos lancamentos contabeis                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !lCMV
	lLctPad78 := .F.
EndIf
lLctPad  := lLctPad10 .Or. lLctPad20 .Or. lLctPad78 .Or. lLctPad31 .Or. lLctPad11
lContinua := lLctPad

dbSelectArea("SX6")
dbSetOrder(1)
GetMV("MV_OPTNFS")
If !SX6->(SimpleLock())				//// REGISTRO EM USO RETORNA .F. (NAO CONSEGUIU EXECUTAR O SIMPLELOCK)
	MsgAlert(STR0014)
	lContinua := .F.
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Montagem da primeira regua por filiais                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lInterface
	oObj:SetRegua1(SM0->(LastRec()))
EndIf

dbSelectArea("SM0")
dbSetOrder(1)
MsSeek(cEmpAnt+cFilDe,.T.)
While ( !Eof() .And. SM0->M0_CODIGO == cEmpAnt .And. ;
	SM0->M0_CODFIL <= cFilAte .And. lContinua )
	
	cFilAnt := SM0->M0_CODFIL
	aCT5 := {}
	c610 := NIL
	c611 := NIL
	c620 := Nil
	c631 := Nil
	c678 := Nil
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Atualiza a regua de processamento de filiais                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If lInterface
		oObj:IncRegua1(STR0008+": "+SM0->M0_CODFIL+"/"+SM0->M0_FILIAL) //"Contabilizando"
	EndIf
	For nY := 1 To 2
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Processa os documentos de saida da filial corrente           �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSelectArea("SD2")
		dbSetOrder(3)
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.				 
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Demonstra regua de processamento da query                    �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If lInterface
					If lOptimize
						oObj:IncRegua2(STR0010) //"Executando processo de otimizacao com query"
					Else 
						oObj:IncRegua2(STR0011) //"Executando query"
					EndIf
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Verifica o parametro de otimizacao                           �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If GetNewPar("MV_OPTNFS",.F.)
					lOptimize := .T.
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem do Array de otimizacao de Query                     �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aOptimize := {}					
				aadd(aOptimize,{}) //SELECT
				aadd(aOptimize,{}) //FROM
				aadd(aOptimize,{})	//WHERE

				If lOptimize
					cAliasSF2 := "CTBANFS"
					cAliasSD2 := "CTBANFS"
					cAliasSB1 := "CTBANFS"
					cAliasSF4 := "CTBANFS"
					cAliasSA1 := "CTBANFS"
					cAliasSA2 := "CTBANFS"
				
					aStruSF2  := SF2->(dbStruct())
					aStruSD2  := SD2->(dbStruct())
					aStruSB1  := SB1->(dbStruct())
					aStruSF4  := SF4->(dbStruct())
					aStruSA1  := SA1->(dbStruct())
					aStruSA2  := SA2->(dbStruct())
	
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Montagem da instrucao select                                 �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					For nX := 1 To Len(aStruSF2)
						If !"F2_BASE"$aStruSF2[nX][1] .and. !"F2_BASI"$aStruSF2[nX][1] .and. ((!"F2_ESPECI"$aStruSF2[nX][1]).Or.Alltrim(aStruSF2[nX][1])=="F2_ESPECIE") .and.;
						 !"F2_VOLUME"$aStruSF2[nX][1] .and. !"F2_VEND"$aStruSF2[nX][1] .And. !"F2_DTBASE"$aStruSF2[nX][1] .and.;
						 !aStruSF2[nX][1]$"F2_REGIAO/F2_DTREAJ/F2_REAJUST/F2_FATORB0/F2_FATORB1/F2_VARIAC/F2_PLIQUI/F2_PBRUTO/F2_TRANSP/F2_TPREDES/F2_REDESP/F2_PLACA"
							aadd(aOptimize[OPT_SELECT],aStruSF2[nX])
						EndIf
				    Next nX
					For nX := 1 To Min(Len(aStruSD2),255)
						If 	!"D2_BASE"$aStruSD2[nX][1] .And. !"D2_BASI"$aStruSD2[nX][1] .And. !"D2_ALIQ"$aStruSD2[nX][1] .And. ;
							 !"D2_ALQIMP"$aStruSD2[nX][1]	 .And. 	!"D2_COMIS"$aStruSD2[nX][1] .And. !"D2_CP"$aStruSD2[nX][1]
							aadd(aOptimize[OPT_SELECT],aStruSD2[nX])
						EndIf
				    Next nX
                
					If nY == 1
						For nX := 1 To Len(aStruSA1)
							If aStruSA1[nX][1]$"A1_FILIAL,A1_COD,A1_LOJA,A1_CONTA,A1_NOME,A1_NREDUZ"
								aadd(aOptimize[OPT_SELECT],aStruSA1[nX])
							EndIf
					    Next nX
					Else
						For nX := 1 To Len(aStruSA2)
							If aStruSA2[nX][1]$"A2_FILIAL,A2_COD,A2_LOJA,A2_CONTA,A2_NOME,A2_NREDUZ"
								aadd(aOptimize[OPT_SELECT],aStruSA2[nX])
							EndIf
					    Next nX
					EndIf
					For nX := 1 To Len(aStruSB1)
						If aStruSB1[nX][1]$"B1_FILIAL,B1_COD,B1_CONTA"
							aadd(aOptimize[OPT_SELECT],aStruSB1[nX])
						EndIf
				    Next nX
					For nX := 1 To Len(aStruSF4)
						If aStruSF4[nX][1]$"F4_FILIAL,F4_CODIGO,F4_CF"
							aadd(aOptimize[OPT_SELECT],aStruSF4[nX])
						EndIf
			    	Next nX
				Else
					cAliasSF2 := "QRYSD2"
					cAliasSD2 := "QRYSD2"
					cAliasSB1 := "QRYSD2"
					cAliasSF4 := "QRYSD2"
					cAliasSA1 := "QRYSD2"
					cAliasSA2 := "QRYSD2"
                    
					/// CAMPOS CHAVE DA TABELA SF2
					aadd(aOptimize[OPT_SELECT], {"F2_FILIAL"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_EMISSAO"	,"D",8,0} )
					aadd(aOptimize[OPT_SELECT], {"F2_DTLANC"	,"D",8,0} )
					If lF2DTDIG
						aadd(aOptimize[OPT_SELECT], {"F2_DTDIGIT","D",8,0} )
					EndIf
					aadd(aOptimize[OPT_SELECT], {"F2_TIPO"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_CLIENTE"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_LOJA"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_DOC"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_SERIE"		,"C"} )

					aadd(aOptimize[OPT_SELECT], {"D2_FILIAL"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_DOC"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_SERIE"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_CLIENTE"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_LOJA"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_ORIGLAN"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_COD"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_TES"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_ITEMORI"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_NFORI"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_SERIORI"	,"C"} )
					
					//aadd(aOptimize[OPT_SELECT],{{"D2_"},{"D2_"},{"D2_"},{"D2_"},{"D2_"}})
					
				EndIf

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem da instrucao from                                   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF2"),"SF2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SD2"),"SD2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SB1"),"SB1"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF4"),"SF4"})
				If nY == 1
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA1"),"SA1"})
				Else
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA2"),"SA2"})
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem da instrucao where                                  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aOptimize[OPT_WHERE] := " SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
				aOptimize[OPT_WHERE] += "SF2.F2_EMISSAO >= '"+Dtos(dDataIni)+"' AND "
				aOptimize[OPT_WHERE] += "SF2.F2_EMISSAO <= '"+Dtos(dDataFim)+"' AND "
				aOptimize[OPT_WHERE] += "SF2.F2_DTLANC = '"+Dtos(Ctod(""))+"' AND "
				aOptimize[OPT_WHERE] += "SF2.D_E_L_E_T_=' ' AND "
				aOptimize[OPT_WHERE] += "SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
				aOptimize[OPT_WHERE] += "SD2.D2_DOC = SF2.F2_DOC AND "
				aOptimize[OPT_WHERE] += "SD2.D2_SERIE = SF2.F2_SERIE AND "
				aOptimize[OPT_WHERE] += "SD2.D2_CLIENTE = SF2.F2_CLIENTE AND "
				aOptimize[OPT_WHERE] += "SD2.D2_LOJA = SF2.F2_LOJA AND "
				aOptimize[OPT_WHERE] += "SD2.D_E_L_E_T_=' ' AND "
				aOptimize[OPT_WHERE] += "SD2.D2_ORIGLAN<>'LF' AND "
				aOptimize[OPT_WHERE] += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
				aOptimize[OPT_WHERE] += "SB1.B1_COD=SD2.D2_COD AND "
				aOptimize[OPT_WHERE] += "SB1.D_E_L_E_T_=' ' AND "
				aOptimize[OPT_WHERE] += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
				aOptimize[OPT_WHERE] += "SF4.F4_CODIGO=SD2.D2_TES AND "	
				aOptimize[OPT_WHERE] += "SF4.D_E_L_E_T_=' ' AND "
				If nY == 1
					aOptimize[OPT_WHERE] += "SA1.A1_FILIAL='"+xFilial("SA1")+"' AND "
					aOptimize[OPT_WHERE] += "SA1.A1_COD = SF2.F2_CLIENTE AND "
					aOptimize[OPT_WHERE] += "SA1.A1_LOJA = SF2.F2_LOJA AND "
					aOptimize[OPT_WHERE] += "SA1.D_E_L_E_T_=' ' AND "
					aOptimize[OPT_WHERE] += "SF2.F2_TIPO NOT IN('D','B') "
				Else
					aOptimize[OPT_WHERE] += "SA2.A2_FILIAL='"+xFilial("SA2")+"' AND "
					aOptimize[OPT_WHERE] += "SA2.A2_COD = SF2.F2_CLIENTE AND "
					aOptimize[OPT_WHERE] += "SA2.A2_LOJA = SF2.F2_LOJA AND "
					aOptimize[OPT_WHERE] += "SA2.D_E_L_E_T_=' ' AND "
					aOptimize[OPT_WHERE] += "SF2.F2_TIPO IN('D','B') "
				EndIf					
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Execucao do execblock para alteracao da query de otimizacao  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If ExistBlock("CTBNFS")
					aOptimize := ExecBlock("CTBNFS",.F.,.F.,aOptimize)
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem da Query                                            �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁				
				cString := ""
				For nX := 1 To Len(aOptimize[OPT_SELECT])
					cString += ","+aOptimize[OPT_SELECT][nX][1]
				Next nX
				If lOptimize
					cQuery := "SELECT SF2.R_E_C_N_O_ SF2RECNO"+cString
				Else
					cQuery := "SELECT SF2.R_E_C_N_O_ SF2RECNO,"
					If nY == 1
						cQuery += "SA1.R_E_C_N_O_ SA1RECNO,"
					Else
						cQuery += "SA2.R_E_C_N_O_ SA2RECNO,"
					EndIf
					cQuery += "SF4.R_E_C_N_O_ SF4RECNO,"
					cQuery += "SB1.R_E_C_N_O_ SB1RECNO"+cString
				EndIf
				cQuery += ",SD2.R_E_C_N_O_ SD2RECNO"
				cString := ""
				For nX := 1 To Len(aOptimize[OPT_FROM])
					cString += ","+aOptimize[OPT_FROM][nX][1]+" "+aOptimize[OPT_FROM][nX][2]
				Next nX
				cQuery += " FROM "+SubStr(cString,2)
				cQuery += " WHERE "+aOptimize[OPT_WHERE]
				                                     
				If nTpCtb == 3 //-- Contabiliza por Dia
					cQuery += " ORDER BY " + SqlOrder("F2_FILIAL+F2_EMISSAO+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA")+","+SqlOrder(SD2->(IndexKey()))
				Else 
					cQuery += " ORDER BY " + SqlOrder(SF2->(IndexKey()))+ "," +SqlOrder(SD2->(IndexKey()))				
				EndIf	
			
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)
			
				For nX := 1 To Len(aOptimize[OPT_SELECT])
					If aOptimize[OPT_SELECT][nX][2]<>"C"
						TcSetField(cAliasSF2,aOptimize[OPT_SELECT][nX][1],aOptimize[OPT_SELECT][nX][2],aOptimize[OPT_SELECT][nX][3],aOptimize[OPT_SELECT][nX][4])
				    EndIf
				Next nX
			Else
		#ENDIF
				dbSelectArea(cAliasSF2)
				cArqSF2 := CriaTrab(,.F.)
				cQuery  := "F2_FILIAL=='"+xFilial("SF2")+"' .AND. "
				cQuery  += "DTOS(F2_EMISSAO) >= '"+Dtos(dDataIni)+"' .AND. "
				cQuery  += "DTOS(F2_EMISSAO) <= '"+Dtos(dDataFim)+"' .AND. "
				cQuery  += "DTOS(F2_DTLANC) == '"+Dtos(Ctod(""))+"'"
				IndRegua("SF2",cArqSF2,cKeySF2,,cQuery)
				nOrdSF2 := RetIndex("SF2")
				#IFNDEF TOP
					dbSetIndex(cArqSF2+OrdBagExt())
				#ENDIF
				dbSetOrder(nOrdSF2+1)
				MsSeek(xFilial("SF2")+Dtos(dDataIni),.T.)
		#IFDEF TOP
			EndIf
		#ENDIF
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Preparacao da contabilizacao por periodo                     �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lLctPad .And. nTpCtb == 2
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica o numero do lote contabil                           �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SX5")
			dbSetOrder(1)
			If MsSeek(xFilial()+"09FAT")
				cLoteCtb := AllTrim(X5Descri())
			Else
				cLoteCtb := "FAT "
			EndIf		
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Executa um execblock                                         �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If At(UPPER("EXEC"),X5Descri()) > 0
				cLoteCtb := &(X5Descri())
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Inicializa o arquivo de contabilizacao                       �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁		
			nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
			IF nHdlPrv <= 0
				HELP(" ",1,"SEM_LANC")
				lContinua := .F.
			Else
				lHeader := .T.
			EndIf		
		EndIf			
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Montagem da segunda regua por periodo                        �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lInterface
			oObj:SetRegua2(dDataFim+1-dDataIni)
			dDataProc := dDataIni
		EndIf
		dbSelectArea(cAliasSF2)
		While ( !Eof() .And. (cAliasSF2)->F2_FILIAL == xFilial("SF2") .And.;
			(cAliasSF2)->F2_EMISSAO <= dDataFim .And. lContinua)
			
			lValido   := .T.
			lDetProva := .F.
			lSkipSF2  := .T.
         dDtEmissao:= (cAliasSF2)->F2_EMISSAO 			                              

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se a nota nao foi contabilizada                     �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If Empty((cAliasSF2)->F2_DTLANC)
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Executa a filtragem da customizacao                          �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If lFilSf2
					If !(Execblock("CTNFSFIL",.F.,.F.,{cAliasSF2}))
						lValido := .F.
					EndIf
				EndIf
			Else
				lValido := .F.
			EndIf                                                             
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Verifica se a nota e de credito e se o campo de data de digitacao esta preenchido �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			If cPaisLoc<> "BRA" .AND. lF2DTDIG .and. (cAliasSF2)->F2_TIPO == "D"  .AND. !Empty((cAliasSF2)->F2_DTDIGIT)
				lValido := .F.			
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Melhoria pedida no Bops 67407, para contabilizar a NCC no modulo de faturamento e �
			//� as NCP no modulo de compras.                                                      �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			If cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI") .And. ((Alltrim((cAliasSF2)->F2_TIPO) == "D" .And. Alltrim(cModulo) == "FAT") .Or. (Alltrim((cAliasSF2)->F2_TIPO) <> "D" .And. Alltrim(cModulo) == "COM"))
				lValido := .F.
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Inicia a contabilizacao deste documento de saida             �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁			
			If lValido
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Posiciona no Cabecalho do documento de saida                 �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If lQuery 
					If !lOptimize
						SF2->(MsGoto((cAliasSF2)->SF2RECNO))
					Else
						nRecSF2 := (cAliasSF2)->SF2RECNO
					EndIf				
									
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Ajusta a data base com a data de contabilizacao              �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				Do Case
					Case nTpCtb == 1 .Or. nTpCtb == 3 
						dDataBase := (cAliasSF2)->F2_EMISSAO						
						If lCtNfsDt
							dDataBase := Execblock("CTNFSDT",.F.,.F.)
						EndIf
					Case nTpCtb == 2
						dDataBase := dDataFim
				EndCase
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Preparacao da contabilizacao por documento                   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				Begin Transaction
			    	If 	!lHeader
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Verifica o numero do lote contabil                           �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						dbSelectArea("SX5")
						dbSetOrder(1)
						If MsSeek(xFilial()+"09FAT")
							cLoteCtb := AllTrim(X5Descri())
						Else
							cLoteCtb := "FAT "
						EndIf		

						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� No chile contabiliza NCP separada de NF, por isto deve ser   �
						//� contabilizado com LOTE DIFERENCIADO.                         �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			     		If cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI") .And. (AllTrim(cModulo) == "COM") 
							If (cAliasSF2)->F2_TIPO $ "D" 
								If MsSeek(xFilial()+"09COM")
									cLoteCtb := AllTrim(X5Descri())
								Else
									cLoteCtb := "COM "
								EndIf 
							EndIf
						EndIf
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Executa um execblock                                         �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						If At("EXEC",Upper(X5Descri())) > 0
							cLoteCtb := &(X5Descri())
						EndIf
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Inicializa o arquivo de contabilizacao                       �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
						IF nHdlPrv <= 0
							HELP(" ",1,"SEM_LANC")
							lContinua := .F.
						Else
							lHeader := .T.
						EndIf		
	           		EndIf
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Posiciona registros vinculados ao cabecalho do documento     �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If (cAliasSF2)->F2_TIPO $ "DB"
						dbSelectArea("SA2")
						dbSetOrder(1)
						If lQuery .And. !lOptimize
							SA2->(MsGoto((cAliasSA2)->SA2RECNO))
						EndIf
					Else
						dbSelectArea("SA1")
						dbSetOrder(1)
						If lQuery .And. !lOptimize
							SA1->(MsGoto((cAliasSA1)->SA1RECNO))
						EndIf
					EndIf
					If !lQuery
						MsSeek(xFilial()+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
					Else
						dbSelectArea(cAliasSF2)
					EndIf
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Processa os itens do documento de saida                      �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If !lQuery
						dbSelectArea("SD2")
						dbSetOrder(3)
						MsSeek(xFilial("SD2")+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
					Else
						dbSelectArea(cAliasSF2)
					EndIf
					
					cCliente   := (cAliasSF2)->F2_CLIENTE
					cLoja      := (cAliasSF2)->F2_LOJA
					cDocumento := (cAliasSF2)->F2_DOC
					cSerie     := (cAliasSF2)->F2_SERIE
					lFirst     := .T.
					
					While ( !Eof() .And. (cAliasSD2)->D2_FILIAL == xFilial("SD2") .And.;
						(cAliasSD2)->D2_DOC == cDocumento .And.;
						(cAliasSD2)->D2_SERIE == cSerie .And.;
						(cAliasSD2)->D2_CLIENTE == cCliente .And.;
						(cAliasSD2)->D2_LOJA == cLoja )
	
						lValido := .T.
						
						#IFDEF TOP
							If TcSrvType() <> "AS/400"
								nUltSD2 := (cAliasSD2)->SD2RECNO
								If !lOptimize
									SD2->(dbGoTo(nUltSD2))
								EndIf
							Else							
						#ENDIF                                         
							nUltSD2 := SD2->(Recno())
						#IFDEF TOP
							EndIf
						#ENDIF
						If 	(cAliasSD2)->D2_ORIGLAN <> "LF"
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Posiciona registros vinculados ao item do documento          �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If cModulo == "LOJ"
							
								dbSelectArea("SL1")
								dbSetOrder(2)
								MsSeek( xFilial("SL1")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC)
								
								dbSelectArea("SL2")
								dbSetOrder(3)
								MsSeek( xFilial("SL2")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_COD)
					
								If cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI")
									If (cAliasSD2)->D2_ORIGLAN != "LO"
										lValido := .F.
									EndIf
								EndIf
								
								// Permite a contabilizacao pelo SL4 (Itens de Venda por Forma de Pagamento)
								If lLctPad31
									dbSelectArea("SL4")
									dbSetOrder(1)
									If dbSeek(xFilial()+SL1->L1_NUM)
										While !Eof() .and. xFilial() == SL4->L4_FILIAL .and. SL4->L4_NUM == SL1->L1_NUM
											c631       := CtRelation("631",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
											nTotalCtb += DetProva(nHdlPrv,"631","CTBANFS",cLoteCtb,,,,,@c631,@aCT5)
											dbSkip()
											Loop
										End
									EndIf
						 		EndIf
							EndIf
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Preparacao da contabilizacao por item do documento           �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁						
							If lValido						
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Posiciona registros vinculados ao item do documento          �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								dbSelectArea("SB1")
								dbSetOrder(1)
								If !lQuery
									MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
								Else
									If !lOptimize
										SB1->(MsGoto((cAliasSB1)->SB1RECNO))
									EndIf
								EndIf
	
								dbSelectArea("SF4")
								dbSetOrder(1)
								If !lQuery
									MsSeek(xFilial()+(cAliasSD2)->D2_TES)
								Else
									If !lOptimize
										SF4->(MsGoto((cAliasSF4)->SF4RECNO))
									EndIf
								EndIf
								
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Executa os lancamentos contabeis ( 610 ) - Item              �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If lLctPad10  .And. lHeader
									c610       := CtRelation("610",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									nTotalCtb += DetProva(nHdlPrv,"610","CTBANFS",cLoteCtb,,,,,@c610,@aCT5)

									If lLctPad11  .And. lHeader .And. !Empty((cAliasSD2)->D2_ITEMORI)									
										dbSelectArea("SF1")
										dbSetOrder(1)
										MsSeek(xFilial("SF1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
										
										dbSelectArea("SD1")
										dbSetOrder(1)
										MsSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
											
										dbSelectArea("SDE")
										dbSetOrder(1)
										MsSeek(xFilial("SDE")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
										While ( !Eof() .And. ;
											xFilial("SDE") == SDE->DE_FILIAL .And.;
											SD1->D1_DOC == SDE->DE_DOC .And.;
											SD1->D1_SERIE == SDE->DE_SERIE .And.;
											SD1->D1_FORNECE == SDE->DE_FORNECE .And.;
											SD1->D1_LOJA == SDE->DE_LOJA .And.;
											SD1->D1_ITEM == SDE->DE_ITEMNF)

											nTotalCtb += DetProva(nHdlPrv,"611","CTBANFS",cLoteCtb,,,,,@c611,@aCT5)

											dbSelectArea("SDE")
											dbSkip()
										EndDo
									EndIf
								EndIf
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Executa os lancamentos contabeis ( 678 ) - C.M.V.            �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If lLctPad78 .And. lHeader
									c678       := CtRelation("678",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									nTotalCtb += DetProva(nHdlPrv,"678","CNA200C",cLoteCtb,,,,,@c678,@aCT5)
								EndIf
							EndIf
						EndIf						
						If lValido .And. lFirst
							lFirst := .F.
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Executa os lancamentos contabeis ( 620 ) - Cabecalho         �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If lLctPad20 .And. lHeader
								c620       := CtRelation("620",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
								lDetProva := .T.
								nTotalCtb += DetProva(nHdlPrv,"620","CTBANFS",cLoteCtb,,,,,@c620,@aCT5)
							EndIf
						EndIf										
						dbSelectArea(cAliasSD2)
						dbSkip()
						lSkipSF2 := .F.
						
						If lInterface .And. lEnd
							oObj:IncRegua2(STR0012) //"Aguarde abortando execucao"
						EndIf
						
					EndDo
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Atualiza a data de lancamento contabil para nao refaze-lo    �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If lDetProva .And. lHeader
						If lQuery .And. lOptimize
							SF2->(MsGoto(nRecSF2))
						EndIf
						If !lQuery
							dbSelectArea(cAliasSF2)
							dbSkip()
							nRecSF2 := SF2->(RecNo())
							dbSkip(-1)
						EndIf						
						RecLock("SF2")
						SF2->F2_DTLANC := dDataBase
						MsUnlock()
		            EndIf
		    	End Transaction
				If nTpCtb == 1 .And. lHeader
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Fecha os lancamentos contabeis                               �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					lHeader := .F.
					RodaProva(nHdlPrv,nTotalCtb)
					If nTotalCtb > 0 				
						nSD2Ori := SD2->(Recno())	/// GUARDA O POSICIONAMENTO DO SD2
						SD2->(dbGoTo(nUltSD2))		// POSICIONA NO 贚TIMO SD2 DA NF.
						nTotalCtb := 0
						cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
						SD2->(dbGoTo(nSD2Ori))		// VOLTA O POSICIONAMENTO DO SD2 ORIGINAL
					EndIf
				EndIf
			Else
				If !lQuery
					dbSelectArea(cAliasSF2)
					dbSkip()
					nRecSF2 := SF2->(RecNo())
					dbSkip(-1)
				EndIf			
			EndIf
			If lSkipSF2 .Or. !lQuery
				dbSelectArea(cAliasSF2)
				If lQuery
					dbSkip()
				Else
					MsGoto(nRecSF2)
				
				EndIf
			Else
				dbSelectArea(cAliasSF2)
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Atualiza a regua de processamento por periodo                �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If dDataProc<>(cAliasSF2)->F2_EMISSAO
				While dDataProc<=(cAliasSF2)->F2_EMISSAO
					If lInterface
						oObj:IncRegua2(STR0008+": "+Dtoc((cAliasSF2)->F2_EMISSAO)) //"Documento de"
					Endif
					dDataProc++
				EndDo
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se a contabilizacao foi abortada                    �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If lEnd
				Exit
			EndIf
			If nTpCtb == 3 .And. (cAliasSF2)->F2_EMISSAO <> dDtEmissao
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Fecha os lancamentos contabeis                               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				lHeader   := .F.
				RodaProva(nHdlPrv,nTotalCtb)
				If nTotalCtb > 0
					nTotalCtb := 0			
					cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
				EndIf
			EndIf			
		EndDo

		If nTpCtb == 2 .And. lHeader
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Fecha os lancamentos contabeis                               �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			lHeader   := .F.
			RodaProva(nHdlPrv,nTotalCtb)
			If nTotalCtb > 0
				nTotalCtb := 0			
				cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
			EndIf
		EndIf			
	
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Retorna a situacao inicial                                   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lQuery
			dbSelectArea(cAliasSF2)
			dbCloseArea()
		Else
			dbSelectArea("SF2")
			RetIndex("SF2")
			dbClearFilter()
			FErase(cArqSF2+OrdBagExt())
		EndIf
		If !lQuery
			Exit
		EndIf
	Next nY
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica se o arquivo e compartilhado para encerrar a contab.�
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If Empty(xFilial("SF2"))
		Exit
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica se a contabilizacao foi abortada                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If lEnd
		Exit
	EndIf	
	dbSelectArea("SM0")
	dbSkip()
EndDo
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Restaura a integridade da Rotina                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
RestArea(aAreaSM0)
RestArea(aArea)
cFilAnt := SM0->M0_CODFIL
dDataBase := dSavBase

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Efetua lancamentos contabeis do Remito                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If cPaisLoc <> "BRA"
	LocBlock("C200A",.F.,.F.)
EndIf
If cPaisLoc <> "BRA" .and. lF2DTDIG
 	 If cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI") .and. ! AllTrim(cModulo) $ "COM|EST"
	    lContNCP  := .F.
     Else
		If lContNCP
			CTBANCPS(lDigita,lAglutina,nTpCtb,lCMV,dDataIni,dDataFim,cFilDe,cFilAte,oObj,lEnd)
			RestArea(aAreaSM0)
			RestArea(aArea)
			cFilAnt := SM0->M0_CODFIL
			dDataBase := dSavBase
        EndIf
	EndIf
EndIf
Return(.T.)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矯TBANCPS  矨utor  � Paulo Augusto         � Data �28.04.2003 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北�          砇otina de processamento da contabilizacao off-line dos Docu- 潮�
北�          砿entos de Credito de Fornecedores                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros� 							                                   潮�
北�          �														       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北矰escri噭o 矱sta rotina tem como objetivo contabilizar os documentos de  潮�
北�          矯redito de Fornecedores com base nos lancamentos contabeis,  潮�
北�          砫e forma off-line                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       � CTB/FAT/OMS                                                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

Static Function CTBANCPS(lDigita,lAglutina,nTpCtb,lCMV,dDataIni,dDataFim,cFilDe,cFilAte,oObj,lEnd)

Local aCT5       := {}
Local dDataProc  := Ctod("")
Local lFirst     := .T.
Local lCtNfsDt   := ExistBlock("CTNFSDT")
Local lFilSf2    := Existblock("CTNFSFIL")
Local lLctPad10  := VerPadrao("610")	// Credito de Estoque / Debito de C.M.V.
Local lLctPad11  := VerPadrao("611")	// Devolucao do item de rateio
Local lLctPad20  := VerPadrao("620")	// Debito de Cliente  / Credito de Venda
Local lLctPad31  := VerPadrao("631")	// Debito de Cliente  / Credito de Venda (Modulo Loja, a partir do SL4)
Local lLctPad78  := VerPadrao("678")	// Credito de Estoque / Debito de C.M.V. (CUSTO)
Local dDtDigit   
Local lLctPad    := .F.
Local lDetProva  := .F.
Local lHeader    := .F.
Local lContinua  := .T.
Local lValido    := .F.
Local lQuery     := .F.
Local lInterface := oObj<>Nil
Local lOptimize  := .F.
Local lSkipSF2   := .F.
Local cLoteCtb   := ""
Local cArqCtb    := ""
Local cAliasSD2  := "SD2"
Local cAliasSF2  := "SF2"
Local cAliasSB1  := "SB1"
Local cAliasSF4  := "SF4"
Local cAliasSA1  := "SA1"
Local cAliasSA2  := "SA2"
Local cCliente   := ""
Local cLoja      := ""
Local cDocumento := ""
Local cSerie     := ""
Local c610       := Nil
Local c611       := Nil
Local c620       := Nil
Local c631       := Nil
Local c678       := Nil
Local cQuery     := ""
Local cKeySF2    := "F2_FILIAL+DTOS(F2_DTDIGIT)"
Local cArqSF2    := ""
Local nHdlPrv    := 0 
Local nTotalCtb  := 0
Local nOrdSF2    := 0
Local nRecSF2    := 0
Local nY         := 0
Local nUltSD2	 := 1
#IFDEF TOP
	Local aOptimize  := {}
	Local aStruSF2   := {}
	Local aStruSD2   := {}
	Local aStruSB1   := {}
	Local aStruSF4   := {}
	Local aStruSA1   := {}
	Local aStruSA2   := {}
	Local cString    := ""
	Local nX         := 0	
#ENDIF	
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Inicializa parametros DEFAULT                                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DEFAULT lDigita   := .F.
DEFAULT lAglutina := .F.
DEFAULT nTpCtb    := 1
DEFAULT dDataIni  := FirstDay(dDataBase)
DEFAULT dDataFim  := LastDay(dDataBase)
DEFAULT lCMV      := .F.
DEFAULT cFilDe    := cFilAnt
DEFAULT cFilAte   := cFilAnt
DEFAULT lEnd      := .F.
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Compatibilizacao dos lancamentos contabeis                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !lCMV
	lLctPad78 := .F.
EndIf
lLctPad  := lLctPad10 .Or. lLctPad20 .Or. lLctPad78 .Or. lLctPad11
lContinua := lLctPad
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Montagem da primeira regua por filiais                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lInterface
	oObj:SetRegua1(SM0->(LastRec()))
EndIf

dbSelectArea("SM0")
dbSetOrder(1)
MsSeek(cEmpAnt+cFilDe,.T.)
While ( !Eof() .And. SM0->M0_CODIGO == cEmpAnt .And. ;
	SM0->M0_CODFIL <= cFilAte .And. lContinua )
	
	cFilAnt := SM0->M0_CODFIL
	aCT5 := {}
	c610 := NIL
	c611 := NIL
	c620 := Nil
	c631 := Nil
	c678 := Nil	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Atualiza a regua de processamento de filiais                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If lInterface
		oObj:IncRegua1(STR0008+": "+SM0->M0_CODFIL+"/"+SM0->M0_FILIAL) //"Contabilizando"
	EndIf
	For nY := 1 To 2
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Processa os documentos de saida da filial corrente           �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSelectArea("SD2")
		dbSetOrder(3)
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.				 
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Demonstra regua de processamento da query                    �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If lInterface
					If lOptimize
						oObj:IncRegua2(STR0010) //"Executando processo de otimizacao com query"
					Else 
						oObj:IncRegua2(STR0011) //"Executando query"
					EndIf
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Verifica o parametro de otimizacao                           �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If GetNewPar("MV_OPTNFS",.F.)
					lOptimize := .T.
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem do Array de otimizacao de Query                     �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aOptimize := {}					
				aadd(aOptimize,{}) //SELECT
				aadd(aOptimize,{}) //FROM
				aadd(aOptimize,{})	//WHERE

				If lOptimize
					cAliasSF2 := "CTBANFS"
					cAliasSD2 := "CTBANFS"
					cAliasSB1 := "CTBANFS"
					cAliasSF4 := "CTBANFS"
					cAliasSA1 := "CTBANFS"
					cAliasSA2 := "CTBANFS"
				
					aStruSF2  := SF2->(dbStruct())
					aStruSD2  := SD2->(dbStruct())
					aStruSB1  := SB1->(dbStruct())
					aStruSF4  := SF4->(dbStruct())
					aStruSA1  := SA1->(dbStruct())
					aStruSA2  := SA2->(dbStruct())
	
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Montagem da instrucao select                                 �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					For nX := 1 To Len(aStruSF2)
						If !"F2_BASE"$aStruSF2[nX][1]
							aadd(aOptimize[OPT_SELECT],aStruSF2[nX])
						EndIf
				    Next nX
					For nX := 1 To Len(aStruSD2)
						If !"D2_BASE"$aStruSD2[nX][1] .And. !"D2_CP"$aStruSD2[nX][1]
							aadd(aOptimize[OPT_SELECT],aStruSD2[nX])
						EndIf
				    Next nX
					If lOptimize
						If nY == 1
							For nX := 1 To Len(aStruSA1)
								If aStruSA1[nX][1]$"A1_FILIAL,A1_COD,A1_LOJA,A1_CONTA,A1_NOME,A1_NREDUZ"
									aadd(aOptimize[OPT_SELECT],aStruSA1[nX])
								EndIf
						    Next nX
						Else
							For nX := 1 To Len(aStruSA2)
								If aStruSA2[nX][1]$"A2_FILIAL,A2_COD,A2_LOJA,A2_CONTA,A2_NOME,A2_NREDUZ"
									aadd(aOptimize[OPT_SELECT],aStruSA2[nX])
								EndIf
						    Next nX
						EndIf
						For nX := 1 To Len(aStruSB1)
							If aStruSB1[nX][1]$"B1_FILIAL,B1_COD,B1_CONTA"
								aadd(aOptimize[OPT_SELECT],aStruSB1[nX])
							EndIf
					    Next nX
						For nX := 1 To Len(aStruSF4)
							If aStruSF4[nX][1]$"F4_FILIAL,F4_CODIGO,F4_CF"
								aadd(aOptimize[OPT_SELECT],aStruSF4[nX])
							EndIf
				    	Next nX
					EndIf			
				Else
					cAliasSF2 := "QRYSD2"
					cAliasSD2 := "QRYSD2"
					cAliasSB1 := "QRYSD2"
					cAliasSF4 := "QRYSD2"
					cAliasSA1 := "QRYSD2"
					cAliasSA2 := "QRYSD2"

					/// CAMPOS CHAVE DA TABELA SF2
					aadd(aOptimize[OPT_SELECT], {"F2_FILIAL"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_EMISSAO"	,"D",8,0} )
					aadd(aOptimize[OPT_SELECT], {"F2_DTLANC"	,"D",8,0} )
					If lF2DTDIG
						aadd(aOptimize[OPT_SELECT], {"F2_DTDIGIT","D",8,0} )
					EndIf
					aadd(aOptimize[OPT_SELECT], {"F2_TIPO"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_CLIENTE"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_LOJA"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_DOC"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"F2_SERIE"		,"C"} )

					aadd(aOptimize[OPT_SELECT], {"D2_FILIAL"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_DOC"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_SERIE"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_CLIENTE"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_LOJA"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_ORIGLAN"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_COD"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_TES"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_ITEMORI"	,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_NFORI"		,"C"} )
					aadd(aOptimize[OPT_SELECT], {"D2_SERIORI"	,"C"} )
					
				EndIf
				
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem da instrucao from                                   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF2"),"SF2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SD2"),"SD2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SB1"),"SB1"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF4"),"SF4"})
				If nY == 1
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA1"),"SA1"})
				Else
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA2"),"SA2"})
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem da instrucao where                                  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aOptimize[OPT_WHERE] := "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
				aOptimize[OPT_WHERE] += "SF2.F2_DTDIGIT >= '"+Dtos(dDataIni)+"' AND "
				aOptimize[OPT_WHERE] += "SF2.F2_DTDIGIT <= '"+Dtos(dDataFim)+"' AND "
				aOptimize[OPT_WHERE] += "SF2.F2_DTLANC = '"+Dtos(Ctod(""))+"' AND "
				aOptimize[OPT_WHERE] += "SF2.D_E_L_E_T_=' ' AND "
				aOptimize[OPT_WHERE] += "SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
				aOptimize[OPT_WHERE] += "SD2.D2_DOC = SF2.F2_DOC AND "
				aOptimize[OPT_WHERE] += "SD2.D2_SERIE = SF2.F2_SERIE AND "
				aOptimize[OPT_WHERE] += "SD2.D2_CLIENTE = SF2.F2_CLIENTE AND "
				aOptimize[OPT_WHERE] += "SD2.D2_LOJA = SF2.F2_LOJA AND "
				aOptimize[OPT_WHERE] += "SD2.D_E_L_E_T_=' ' AND "
				aOptimize[OPT_WHERE] += "SD2.D2_ORIGLAN<>'LF' AND "
				aOptimize[OPT_WHERE] += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
				aOptimize[OPT_WHERE] += "SB1.B1_COD=SD2.D2_COD AND "
				aOptimize[OPT_WHERE] += "SB1.D_E_L_E_T_=' ' AND "
				aOptimize[OPT_WHERE] += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
				aOptimize[OPT_WHERE] += "SF4.F4_CODIGO=SD2.D2_TES AND "	
				aOptimize[OPT_WHERE] += "SF4.D_E_L_E_T_=' ' AND "
				If nY == 1
					aOptimize[OPT_WHERE] += "SA1.A1_FILIAL='"+xFilial("SA1")+"' AND "
					aOptimize[OPT_WHERE] += "SA1.A1_COD = SF2.F2_CLIENTE AND "
					aOptimize[OPT_WHERE] += "SA1.A1_LOJA = SF2.F2_LOJA AND "
					aOptimize[OPT_WHERE] += "SA1.D_E_L_E_T_=' ' AND "
					aOptimize[OPT_WHERE] += "SF2.F2_TIPO NOT IN('D','B') "
				Else
					aOptimize[OPT_WHERE] += "SA2.A2_FILIAL='"+xFilial("SA2")+"' AND "
					aOptimize[OPT_WHERE] += "SA2.A2_COD = SF2.F2_CLIENTE AND "
					aOptimize[OPT_WHERE] += "SA2.A2_LOJA = SF2.F2_LOJA AND "
					aOptimize[OPT_WHERE] += "SA2.D_E_L_E_T_=' ' AND "
					aOptimize[OPT_WHERE] += "SF2.F2_TIPO IN('D','B') "
				EndIf					
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Execucao do execblock para alteracao da query de otimizacao  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If ExistBlock("CTBNFS")
					aOptimize := ExecBlock("CTBNFS",.F.,.F.,aOptimize)
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Montagem da Query                                            �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁				
				cString := ""
				For nX := 1 To Len(aOptimize[OPT_SELECT])
					cString += ","+aOptimize[OPT_SELECT][nX][1]
				Next nX
				If lOptimize
					cQuery := "SELECT SF2.R_E_C_N_O_ SF2RECNO"+cString
				Else
					cQuery := "SELECT SF2.R_E_C_N_O_ SF2RECNO,"
					If nY == 1
						cQuery += "SA1.R_E_C_N_O_ SA1RECNO,"
					Else
						cQuery += "SA2.R_E_C_N_O_ SA2RECNO,"
					EndIf
					cQuery += "SF4.R_E_C_N_O_ SF4RECNO,"
					cQuery += "SB1.R_E_C_N_O_ SB1RECNO"+cString
				EndIf
				cQuery += ",SD2.R_E_C_N_O_ SD2RECNO"
				cString := ""
				For nX := 1 To Len(aOptimize[OPT_FROM])
					cString += ","+aOptimize[OPT_FROM][nX][1]+" "+aOptimize[OPT_FROM][nX][2]
				Next nX
				cQuery += " FROM "+SubStr(cString,2)
				cQuery += " WHERE "+aOptimize[OPT_WHERE]				

				If nTpCtb == 3 //-- Contabiliza por Dia
					cQuery += " ORDER BY " + SqlOrder("F2_FILIAL+F2_DTDIGIT+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA")+","+SqlOrder(SD2->(IndexKey()))
				Else 
					cQuery += " ORDER BY " + SqlOrder(SF2->(IndexKey()))+ "," +SqlOrder(SD2->(IndexKey()))				
				EndIf	
			
				cQuery := ChangeQuery(cQuery)
				
								
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)
			
				For nX := 1 To Len(aOptimize[OPT_SELECT])
					If aOptimize[OPT_SELECT][nX][2]<>"C"
						TcSetField(cAliasSF2,aOptimize[OPT_SELECT][nX][1],aOptimize[OPT_SELECT][nX][2],aOptimize[OPT_SELECT][nX][3],aOptimize[OPT_SELECT][nX][4])
				    EndIf
				Next nX
			Else
		#ENDIF
				dbSelectArea(cAliasSF2)
				cArqSF2 := CriaTrab(,.F.)
				cQuery  := "F2_FILIAL=='"+xFilial("SF2")+"' .AND. "
				cQuery  += "DTOS(F2_DTDIGIT) >= '"+Dtos(dDataIni)+"' .AND. "
				cQuery  += "DTOS(F2_DTDIGIT) <= '"+Dtos(dDataFim)+"' .AND. "
				cQuery  += "F2_TIPO == 'D' .AND. "
				cQuery  += "DTOS(F2_DTLANC) == '"+Dtos(Ctod(""))+"'"
				IndRegua("SF2",cArqSF2,cKeySF2,,cQuery)
				nOrdSF2 := RetIndex("SF2")
				#IFNDEF TOP
					dbSetIndex(cArqSF2+OrdBagExt())
				#ENDIF
				dbSetOrder(nOrdSF2+1)
				MsSeek(xFilial("SF2")+Dtos(dDataIni),.T.)
		#IFDEF TOP
			EndIf
		#ENDIF
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Preparacao da contabilizacao por periodo                     �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lLctPad .And. nTpCtb == 2
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica o numero do lote contabil                           �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SX5")
			dbSetOrder(1)
			If MsSeek(xFilial()+IIf(!cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI"),"09FAT","09COM"))
				cLoteCtb := AllTrim(X5Descri())
			Else
				cLoteCtb := IIf(!cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI"),"FAT ","COM ")
			EndIf		
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Executa um execblock                                         �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If At(UPPER("EXEC"),X5Descri()) > 0
				cLoteCtb := &(X5Descri())
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Inicializa o arquivo de contabilizacao                       �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁		
			nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
			IF nHdlPrv <= 0
				HELP(" ",1,"SEM_LANC")
				lContinua := .F.
			Else
				lHeader := .T.
			EndIf		
		EndIf			
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Montagem da segunda regua por periodo                        �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lInterface
			oObj:SetRegua2(dDataFim+1-dDataIni)
			dDataProc := dDataIni
			oObj:IncRegua2(STR0013+": "+Dtoc((cAliasSF2)->F2_DTDIGIT)) //"Documento de Credito de "
		EndIf
		dbSelectArea(cAliasSF2)
		While ( !Eof() .And. (cAliasSF2)->F2_FILIAL == xFilial("SF2") .And.;
			(cAliasSF2)->F2_DTDIGIT <= dDataFim .And. lContinua)
			
			lValido   := .T.
			lDetProva := .F.
			lSkipSF2  := .T.
         dDtDigit  := (cAliasSF2)->F2_DTDIGIT 			
         
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se a nota nao foi contabilizada                     �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If Empty((cAliasSF2)->F2_DTLANC)
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Executa a filtragem da customizacao                          �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If lFilSf2
					If !(Execblock("CTNFSFIL",.F.,.F.,{cAliasSF2}))
						lValido := .F.
					EndIf
				EndIf
			Else
				lValido := .F.
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Inicia a contabilizacao deste documento de saida             �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁			
			If lValido	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Posiciona no Cabecalho do documento de saida                 �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If lQuery 
					If !lOptimize
						SF2->(MsGoto((cAliasSF2)->SF2RECNO))
					Else
						nRecSF2 := (cAliasSF2)->SF2RECNO
					EndIf
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Ajusta a data base com a data de contabilizacao              �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				Do Case
					Case nTpCtb == 1 .Or. nTpCtb == 3 
						dDataBase := (cAliasSF2)->F2_DTDIGIT						
						If lCtNfsDt
							dDataBase := Execblock("CTNFSDT",.F.,.F.)
						EndIf
					Case nTpCtb == 2
						dDataBase := dDataFim
				EndCase
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Preparacao da contabilizacao por documento                   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				Begin Transaction
			    	If 	!lHeader
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Verifica o numero do lote contabil                           �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						dbSelectArea("SX5")
						dbSetOrder(1)
						If MsSeek(xFilial()+"09FAT")
							cLoteCtb := AllTrim(X5Descri())
						Else
							cLoteCtb := "FAT "
						EndIf		
						If cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI")	.And. (cAliasSF2)->F2_TIPO $ "D" 
							If MsSeek(xFilial()+"09COM")
								cLoteCtb := AllTrim(X5Descri())
							Else
								cLoteCtb := "COM "
							EndIf 
						EndIf
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Executa um execblock                                         �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						If At("EXEC",Upper(X5Descri())) > 0
							cLoteCtb := &(X5Descri())
						EndIf
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Inicializa o arquivo de contabilizacao                       �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
						IF nHdlPrv <= 0
							HELP(" ",1,"SEM_LANC")
							lContinua := .F.
						Else
							lHeader := .T.
						EndIf		
	            	EndIf
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Posiciona registros vinculados ao cabecalho do documento     �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If (cAliasSF2)->F2_TIPO $ "DB"
						dbSelectArea("SA2")
						dbSetOrder(1)
						If lQuery .And. !lOptimize
							SA2->(MsGoto((cAliasSA2)->SA2RECNO))
						EndIf
					Else
						dbSelectArea("SA1")
						dbSetOrder(1)
						If lQuery .And. !lOptimize
							SA1->(MsGoto((cAliasSA1)->SA1RECNO))
						EndIf
					EndIf
					If !lQuery
						MsSeek(xFilial()+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
					Else
						dbSelectArea(cAliasSF2)
					EndIf
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Processa os itens do documento de saida                      �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If !lQuery
						dbSelectArea("SD2")
						dbSetOrder(3)
						MsSeek(xFilial("SD2")+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
					Else
						dbSelectArea(cAliasSF2)
					EndIf
					
					cCliente   := (cAliasSF2)->F2_CLIENTE
					cLoja      := (cAliasSF2)->F2_LOJA
					cDocumento := (cAliasSF2)->F2_DOC
					cSerie     := (cAliasSF2)->F2_SERIE
					lFirst     := .T.
					
					While ( !Eof() .And. (cAliasSD2)->D2_FILIAL == xFilial("SD2") .And.;
						(cAliasSD2)->D2_DOC == cDocumento .And.;
						(cAliasSD2)->D2_SERIE == cSerie .And.;
						(cAliasSD2)->D2_CLIENTE == cCliente .And.;
						(cAliasSD2)->D2_LOJA == cLoja )
	
						lValido := .T.
						
						#IFDEF TOP
							If TcSrvType() <> "AS/400"
								nUltSD2 := (cAliasSD2)->SD2RECNO
								If !lOptimize
									SD2->(dbGoTo(nUltSD2))
								EndIf
							Else							
						#ENDIF                                         
							nUltSD2 := SD2->(Recno())
						#IFDEF TOP
							EndIf
						#ENDIF											
						If 	(cAliasSD2)->D2_ORIGLAN <> "LF"
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Posiciona registros vinculados ao item do documento          �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If cModulo == "LOJ"
							
								dbSelectArea("SL1")
								dbSetOrder(2)
								MsSeek( xFilial("SL1")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC)

								dbSelectArea("SL2")
								dbSetOrder(3)
								MsSeek( xFilial("SL2")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_COD)

								If cPaisLoc $ GetNewPar("MV_CTBPAIS","CHI")
									If (cAliasSD2)->D2_ORIGLAN != "LO"
										lValido := .F.
									EndIf
								EndIf

								// Permite a contabilizacao pelo SL4 (Itens de Venda por Forma de Pagamento)
								If lLctPad31
									dbSelectArea("SL4")
									dbSetOrder(1)
									If dbSeek(xFilial()+SL1->L1_NUM)
										While !Eof() .and. xFilial() == SL4->L4_FILIAL .and. SL4->L4_NUM == SL1->L1_NUM
											c631       := CtRelation("631",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
											nTotalCtb += DetProva(nHdlPrv,"631","CTBANFS",cLoteCtb,,,,,@c631,@aCT5)
											dbSkip()
											Loop
										End
									EndIf
						 		EndIf
							EndIf
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Preparacao da contabilizacao por item do documento           �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁						
							If lValido						
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Posiciona registros vinculados ao item do documento          �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								dbSelectArea("SB1")
								dbSetOrder(1)
								If !lQuery
									MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
								Else
									If !lOptimize
										SB1->(MsGoto((cAliasSB1)->SB1RECNO))
									EndIf									
								EndIf
	
								dbSelectArea("SF4")
								dbSetOrder(1)
								If !lQuery
									MsSeek(xFilial()+(cAliasSD2)->D2_TES)
								Else
									If !lOptimize
										SF4->(MsGoto((cAliasSF4)->SF4RECNO))
									EndIf
								EndIf								
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Executa os lancamentos contabeis ( 610 ) - Item              �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If lLctPad10  .And. lHeader
									c610       := CtRelation("610",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									nTotalCtb += DetProva(nHdlPrv,"610","CTBANFS",cLoteCtb,,,,,@c610,@aCT5)

									If lLctPad11  .And. lHeader .And. !Empty((cAliasSD2)->D2_ITEMORI)									
										dbSelectArea("SF1")
										dbSetOrder(1)
										MsSeek(xFilial("SF1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
										
										dbSelectArea("SD1")
										dbSetOrder(1)
										MsSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
											
										dbSelectArea("SDE")
										dbSetOrder(1)
										MsSeek(xFilial("SDE")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
										While ( !Eof() .And. ;
											xFilial("SDE") == SDE->DE_FILIAL .And.;
											SD1->D1_DOC == SDE->DE_DOC .And.;
											SD1->D1_SERIE == SDE->DE_SERIE .And.;
											SD1->D1_FORNECE == SDE->DE_FORNECE .And.;
											SD1->D1_LOJA == SDE->DE_LOJA .And.;
											SD1->D1_ITEM == SDE->DE_ITEMNF)

											nTotalCtb += DetProva(nHdlPrv,"611","CTBANFS",cLoteCtb,,,,,@c611,@aCT5)

											dbSelectArea("SDE")
											dbSkip()
										EndDo
									EndIf
								EndIf
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Executa os lancamentos contabeis ( 678 ) - C.M.V.            �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If lLctPad78 .And. lHeader
									c678       := CtRelation("678",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									nTotalCtb += DetProva(nHdlPrv,"678","CNA200C",cLoteCtb,,,,,@c678,@aCT5)
								EndIf
							EndIf
						EndIf						
						If lValido .And. lFirst
							lFirst := .F.
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Executa os lancamentos contabeis ( 620 ) - Cabecalho         �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If lLctPad20 .And. lHeader
								c620       := CtRelation("620",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
								lDetProva := .T.
								nTotalCtb += DetProva(nHdlPrv,"620","CTBANFS",cLoteCtb,,,,,@c620,@aCT5)
							EndIf
						EndIf										
						dbSelectArea(cAliasSD2)
						dbSkip()
						lSkipSF2 := .F.
						
						If lInterface .And. lEnd
							oObj:IncRegua2(STR0012) //"Aguarde abortando execucao"
						EndIf
						
					EndDo
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Atualiza a data de lancamento contabil para nao refaze-lo    �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If lDetProva .And. lHeader
						If lQuery .And. lOptimize
							SF2->(MsGoto(nRecSF2))
						EndIf		
						RecLock("SF2")
						SF2->F2_DTLANC := dDataBase
						MsUnlock()
		            EndIf
		    	End Transaction
				If nTpCtb == 1 .And. lHeader
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Fecha os lancamentos contabeis                               �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					lHeader := .F.
					RodaProva(nHdlPrv,nTotalCtb)
					If nTotalCtb > 0 				
						nSD2Ori := SD2->(Recno())	/// GUARDA O POSICIONAMENTO DO SD2
						SD2->(dbGoTo(nUltSD2))		// POSICIONA NO 贚TIMO SD2 DA NF.
						nTotalCtb := 0
						cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
						SD2->(dbGoTo(nSD2Ori))		// VOLTA O POSICIONAMENTO DO SD2 ORIGINAL
					EndIf
				EndIf
			EndIf
			If lSkipSF2 .Or. !lQuery
				dbSelectArea(cAliasSF2)
				dbSkip()
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Atualiza a regua de processamento por periodo                �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If dDataProc<>(cAliasSF2)->F2_DTDIGIT
				While dDataProc<=(cAliasSF2)->F2_DTDIGIT
					If lInterface
						oObj:IncRegua2(STR0013+": "+Dtoc((cAliasSF2)->F2_DTDIGIT)) //"Documento de Credito de "
					Endif
					dDataProc++
				EndDo
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se a contabilizacao foi abortada                    �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If lEnd
				Exit
			EndIf
			
			If nTpCtb == 3 .And. (cAliasSF2)->F2_DTDIGIT <> dDtDigit
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Fecha os lancamentos contabeis                               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				lHeader   := .F.
				RodaProva(nHdlPrv,nTotalCtb)
				If nTotalCtb > 0
					nTotalCtb := 0			
					cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
				EndIf
			EndIf
				
		EndDo
		
		If nTpCtb == 2 .And. lHeader
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Fecha os lancamentos contabeis                               �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			lHeader   := .F.
			RodaProva(nHdlPrv,nTotalCtb)
			If nTotalCtb > 0
				nTotalCtb := 0			
				cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
			EndIf
		EndIf
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Retorna a situacao inicial                                   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lQuery
			dbSelectArea(cAliasSF2)
			dbCloseArea()
		Else
			dbSelectArea("SF2")
			RetIndex("SF2")
			dbClearFilter()
			FErase(cArqSF2+OrdBagExt())
		EndIf
		If !lQuery
			Exit
		EndIf
	Next nY
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica se o arquivo e compartilhado para encerrar a contab.�
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If Empty(xFilial("SF2"))
		Exit
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica se a contabilizacao foi abortada                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If lEnd
		Exit
	EndIf	
	dbSelectArea("SM0")
	dbSkip()
EndDo
Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪穆哪哪哪哪哪勘�
北矲un噮o    � CTBNFSSX1    矨utor �  Marcello            矰ata� 31/07/03 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪牧哪哪哪哪哪幢�
北矰escri噮o � Atualiza o grupo de perguntas                              潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CTBNFSSX1()
Local aSaveArea	:= GetArea()
Local aPergs:={},aHelpPor:={},aHelpEng:={},aHelpSpa:={}

/*谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
  矨TENCAO                                                                �
  矯aso haja a necessidade de adicao de novos parametros entrar em contato�
  砪om o departamento de Localizacoes.          						  �
  滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
*/
If cPaisLoc<>"BRA"
	Aadd(aHelpPor,"Informe se deseja contabilizar as")
	Aadd(aHelpPor,"notas de credito")
	Aadd(aHelpSpa,"Informe si desea contabilizar las")
	Aadd(aHelpSpa,"notas de credito")
	Aadd(aHelpEng,"Inform if you wish to account the")
	Aadd(aHelpEng,"credit notes")

	Aadd(aPergs,{"Cont.Notas Credito ?","緾ont.Notas Credito?","Post credit notes?","mv_ch9","N",1,0,0,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa})
	AjustaSx1("CTBNFS",aPergs)
Endif

RestArea(aSaveArea)
Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噭o    矨CertaSX1     � Autor � Patricia A. Salomao  � Data �26.07.2005潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噭o 矨certa o SX1 : Inclui a opcao 'Dia' no Combobox do mv_par03    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矨CertaSX1()                                                    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpC1 - Nome da Pergunte                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   �.T.                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北/*/
Static Function ACertaSX1(cPerg)
Local aArea := GetArea() 

DbSelectArea("SX1")
dbSetOrder(1) 
If MsSeek(cPerg+"03") .And. Empty(X1_DEF03)
	RecLock('SX1', .F.) 
	Replace X1_DEF03   With 'Dia'
	MsUnlock()
EndIf

RestArea(aArea)

Return .T.
