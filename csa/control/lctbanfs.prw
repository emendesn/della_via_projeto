//#INCLUDE "CTBANFS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

#DEFINE OPT_SELECT 1
#DEFINE OPT_FROM   2
#DEFINE OPT_WHERE  3

/*/
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддд©╠╠
╠╠ЁFun┤└o    ЁcCTBANFS   ЁAutor  Ё Claudio Diniz teste  Ё Data Ё25.08.2005 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддд╢╠╠
╠╠Ё          ЁRotina de processamento da contabilizacao off-line dos Docu- Ё╠╠
╠╠Ё          Ёmentos de Saida.                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁExpA1: Parametros da rotina                                  Ё╠╠
╠╠Ё          Ё       Quando informado nao existe a necessidade de interfaceЁ╠╠
╠╠Ё          Ё       com o usuario. Pode ser colocado como um servico do   Ё╠╠
╠╠Ё          Ё       sistema.                                              Ё╠╠
╠╠Ё          Ё                                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   ЁNenhum                                                       Ё╠╠
╠╠Ё          Ё                                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁDescri┤└o ЁEsta rotina tem como objetivo contabilizar os documentos de  Ё╠╠
╠╠Ё          Ёsaida com base nos lancamentos contabeis, de forma off-line  Ё╠╠
╠╠Ё          Ё                                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё CTB/FAT/OMS                                                 Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function LCTBANFS(aPergunte)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis locais                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aSays    := {}
Local aButtons := {}
Local nOpcA    := 0
Local nX       := 0
Local cPerg    := "CTBNFS"
Local cMvPar   := ""
Local lAuto    := aPergunte<>Nil
Local oRegua   := Nil
Local cString

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define variaveis Private                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private aRotina   := { { "Parametros" ,"AllwaysTrue", 0 , 3} }  //"Parametros"
Private cCadastro := "Lancamentos Contabeis Off-Line"  //"Lancamentos Contabeis Off-Line"
Private INCLUI    := .T.
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Desliga Refresh no Lock do Top                               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF TOP
	TCInternal(5,"*OFF")
#ENDIF
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё mv_par01 - Mostra Lancamentos Contabeis ?  Sim Nao           Ё
//Ё mv_par02 - Aglutina Lancamentos         ?  Sim Nao           Ё  
//Ё mv_par03 - Gerar Lancamentos Por        ?  NF  Periodo       Ё
//Ё mv_par04 - Contabiliza C.M.V.           ?  Sim Nao           Ё
//Ё mv_par05 - Data Inicial                                      Ё
//Ё mv_par06 - Data Final                                        Ё
//Ё mv_par07 - Da Filial                                         Ё
//Ё mv_par08 - At┌ a Filial                                      Ё
//Ё mv_par09 - Contabiliza Notas de Credito ? Sim Nao            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montagem da inteface de processamento                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  ЁATENCAO                                                                Ё
  ЁCaso haja a necessidade de adicao de novos parametros entrar em contatoЁ
  Ёcom o departamento de Localizacoes.          						  Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
If cPaisLoc<>"BRA"
	U_LCCTBNFSSX1()
Endif
If Empty(aPergunte)
	Pergunte(cPerg,.F.)
	aadd(aSays,"   Este programa tem como objetivo gerar automaticamente os")
	aadd(aSays,"lan┤amentos cont═beis dos movimentos de saida.")
	aadd(aSays,"   ATEN─AO: A visualiza┤└o do lan┤amentos por Nota Fiscal   ")
	aadd(aSays,"ter═ uma grande interfer┬ncia manual.                       ")
	
	aadd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	aadd(aButtons, { 1,.T.,{|| nOpcA:= 1, FechaBatch() }} )
	aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )
Else
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicializacao do processamento automatico                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	ConOut("-",80)
	ConOut("Lan┤amentos Contabeis Off-Line"+" - "+"Documento de Saida",80)
	ConOut("")
	ConOut("Parametros")
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
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If	nOpcA == 1
	Do Case
		Case IsBlind() .And. !lAuto
			BatchProcess( 	cCadastro, 	" " + Chr(13) + Chr(10) +;
			" " + Chr(13) + Chr(10) +;
			" "+ Chr(13) + Chr(10) +;
			" ", "CTBNFS",;
			{ || 	U_LCMaCtbNfs(MV_PAR01==1,MV_PAR02==1,MV_PAR03,;
			MV_PAR04==1,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08,If(cPaisLoc=="BRA",.F.,MV_PAR09==1),;
			Nil,.F.) }, { || .F. })
		Case !lAuto
			oRegua := MsNewProcess():New({|lEnd| U_LCMaCtbNfs(MV_PAR01==1,;
			MV_PAR02==1,;
			MV_PAR03,;
			MV_PAR04==1,;
			MV_PAR05,;
			MV_PAR06,;
			MV_PAR07,;
			MV_PAR08,;
			If(cPaisLoc=="BRA",.F.,MV_PAR09==1),;
			oRegua,;
			@lEnd) },"Lancamentos Contabeis Off-Line","",.T.)
			oRegua:Activate()
		OtherWise
			ConOut("Starting: "+Time())
			U_LCMaCtbNfs(MV_PAR01==1,;
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
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддд©╠╠
╠╠ЁFun┤└o    ЁCMaCtbNfs  ЁAutor  Ё Eduardo Riera         Ё Data Ё20.10.2001 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддд╢╠╠
╠╠Ё          ЁRotina de contabilizacao dos documentos de saida off-line    Ё╠╠
╠╠Ё          Ё                                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁExpL1: Mostra Lancamento Contabil                            Ё╠╠
╠╠Ё          ЁExpL2: Aglutina lancamentos contabeis                        Ё╠╠
╠╠Ё          ЁExpN3: Contabilizar por:                                     Ё╠╠
╠╠Ё          Ё       [1] Documento de Saida                                Ё╠╠
╠╠Ё          Ё       [2] Periodo                                           Ё╠╠
╠╠Ё          ЁExpL4: Contabiliza Custo da Mercadoria Vendida               Ё╠╠
╠╠Ё          ЁExpD5: Data de emissao inicial                               Ё╠╠
╠╠Ё          ЁExpD6: Data de emissao final                                 Ё╠╠
╠╠Ё          ЁExpC7: Codigo da filial inicial                              Ё╠╠
╠╠Ё          ЁExpC8: Codigo da filial final                                Ё╠╠
╠╠Ё          ЁExpO9: Objeto da interface                              (OPC)Ё╠╠
╠╠Ё          ЁExpLA: Flag de cancelamento da rotina                        Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   ЁNenhum                                                       Ё╠╠
╠╠Ё          Ё                                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁDescri┤└o ЁEsta rotina tem como objetivo contabilizar os documentos de  Ё╠╠
╠╠Ё          Ёsaida com base nas regras dos lancamentos padronizados.      Ё╠╠
╠╠Ё          Ё                                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё CTB/FAT/OMS                                                 Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function LCMaCtbNfs(lDigita,lAglutina,nTpCtb,lCMV,dDataIni,dDataFim,cFilDe,cFilAte,lContNCP,oObj,lEnd)

Local aArea      := GetArea()
Local aAreaSM0   := SM0->(GetArea())
Local aCT5       := {}
Local dSavBase   := dDataBase
Local dDataProc  := Ctod("")
Local lFirst     := .T.
Local lCtNfsDt   := ExistBlock("CTNFSDT")
Local lFilSf2    := Existblock("CTNFSFIL")
Local lLctPad10  := VerPadrao("610")	// Credito de Estoque / Debito de C.M.V.
Local lLctPad20  := VerPadrao("620")	// Debito de Cliente  / Credito de Venda
Local lLctPad31  := VerPadrao("631")	// Debito de Cliente  / Credito de Venda (Modulo Loja, a partir do SL4)
Local lLctPad78  := VerPadrao("678")	// Credito de Estoque / Debito de C.M.V. (CUSTO)
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

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicializa parametros DEFAULT                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Compatibilizacao dos lancamentos contabeis                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If !lCMV
	lLctPad78 := .F.
EndIf
lLctPad  := lLctPad10 .Or. lLctPad20 .Or. lLctPad78 .Or. lLctPad31
lContinua := lLctPad
   
dbSelectArea("SX6")
dbSetOrder(1)
GetMV("MV_OPTNFS")

/*
If !SX6->(SimpleLock())				//// REGISTRO EM USO RETORNA .F. (NAO CONSEGUIU EXECUTAR O SIMPLELOCK)
	MsgAlert("REGISTRO EM USO")
	lContinua := .F.
Endif
*/


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montagem da primeira regua por filiais                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lInterface
	oObj:SetRegua1(SM0->(LastRec()))
EndIf

dbSelectArea("SM0")
dbSetOrder(1)
MsSeek(cEmpAnt+cFilDe,.T.)
While ( !Eof() .And. SM0->M0_CODIGO == cEmpAnt .And. ;
	SM0->M0_CODFIL <= cFilAte .And. lContinua )
	
	cFilAnt := SM0->M0_CODFIL
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza a regua de processamento de filiais                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lInterface
		oObj:IncRegua1("Contabilizando"+": "+SM0->M0_CODFIL+"/"+SM0->M0_FILIAL)
	EndIf
	For nY := 1 To 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Processa os documentos de saida da filial corrente           Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSelectArea("SD2")
		dbSetOrder(3)
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.				 
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Demonstra regua de processamento da query                    Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lInterface
					If lOptimize
						oObj:IncRegua2("Executando processo de otimizacao com query")
					Else 
						oObj:IncRegua2("Executando query") 
					EndIf
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica o parametro de otimizacao                           Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If GetNewPar("MV_OPTNFS",.F.)
					lOptimize := .T.
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem do Array de otimizacao de Query                     Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
				Else
					cAliasSF2 := "SD2"
					cAliasSD2 := "SD2"
					cAliasSB1 := "SD2"
					cAliasSF4 := "SD2"
					cAliasSA1 := "SD2"
					cAliasSA2 := "SD2"
				EndIf
				
				aStruSF2  := SF2->(dbStruct())
				aStruSD2  := SD2->(dbStruct())
				aStruSB1  := SB1->(dbStruct())
				aStruSF4  := SF4->(dbStruct())
				aStruSA1  := SA1->(dbStruct())
				aStruSA2  := SA2->(dbStruct())

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da instrucao select                                 Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				For nX := 1 To Len(aStruSF2)
					If !"F2_BASE"$aStruSF2[nX][1] .and. !"F2_BASI"$aStruSF2[nX][1] .and. !"F2_ESPECI"$aStruSF2[nX][1] .and.;
					 !"F2_VOLUME"$aStruSF2[nX][1] .and. !"F2_VEND"$aStruSF2[nX][1] .And. !"F2_DTBASE"$aStruSF2[nX][1] .and.;
					 !aStruSF2[nX][1]$"F2_REGIAO/F2_DTREAJ/F2_REAJUST/F2_FATORB0/F2_FATORB1/F2_VARIAC/F2_PLIQUI/F2_PBRUTO/F2_TRANSP/F2_TPREDES/F2_REDESP/F2_PLACA"
						aadd(aOptimize[OPT_SELECT],aStruSF2[nX])
					EndIf
			    Next nX
				For nX := 1 To Min(Len(aStruSD2),255)
					If 	!"D2_BASE"$aStruSD2[nX][1] .And. !"D2_BASI"$aStruSD2[nX][1] .And. !"D2_ALIQ"$aStruSD2[nX][1] .And. ;
						 !"D2_ALQIMP"$aStruSD2[nX][1]	 .And. 	!"D2_COMIS"$aStruSD2[nX][1]
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
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da instrucao from                                   Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF2"),"SF2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SD2"),"SD2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SB1"),"SB1"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF4"),"SF4"})
				If nY == 1
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA1"),"SA1"})
				Else
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA2"),"SA2"})
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da instrucao where                                  Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				aOptimize[OPT_WHERE] := "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
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
				aOptimize[OPT_WHERE] += "SD2.D2_ORIGLAN<>'LF' AND SD2.D2_ORIGLAN='LO' AND "
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
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Execucao do execblock para alteracao da query de otimizacao  Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lOptimize
					If ExistBlock("CTBNFS")
						aOptimize := ExecBlock("CTBNFS",.F.,.F.,aOptimize)
					EndIf
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da Query                                            Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды				
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
				cString := ""
				For nX := 1 To Len(aOptimize[OPT_FROM])
					cString += ","+aOptimize[OPT_FROM][nX][1]+" "+aOptimize[OPT_FROM][nX][2]
				Next nX
				cQuery += "FROM "+SubStr(cString,2)
				cQuery += "WHERE "+aOptimize[OPT_WHERE]
				
				cQuery += "ORDER BY "+SqlOrder(SF2->(IndexKey()))+","+SqlOrder(SD2->(IndexKey()))
			
				cQuery := ChangeQuery(cQuery)
				
				If !lOptimize
					dbSelectArea("SD2")
					dbCloseArea()
				EndIf
								
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
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Preparacao da contabilizacao por periodo                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lLctPad .And. nTpCtb == 2
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica o numero do lote contabil                           Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("SX5")
			dbSetOrder(1)
			If MsSeek(xFilial()+"09FAT")
				cLoteCtb := AllTrim(X5Descri())
			Else
				cLoteCtb := "FAT "
			EndIf		
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Executa um execblock                                         Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If At(UPPER("EXEC"),X5Descri()) > 0
				cLoteCtb := &(X5Descri())
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Inicializa o arquivo de contabilizacao                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
			nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
			IF nHdlPrv <= 0
				HELP(" ",1,"SEM_LANC")
				lContinua := .F.
			Else
				lHeader := .T.
			EndIf		
		EndIf			
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Montagem da segunda regua por periodo                        Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a nota nao foi contabilizada                     Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If Empty((cAliasSF2)->F2_DTLANC)
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Executa a filtragem da customizacao                          Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lFilSf2
					If !(Execblock("CTNFSFIL",.F.,.F.,{cAliasSF2}))
						lValido := .F.
					EndIf
				EndIf
			Else
				lValido := .F.
			EndIf                                                             
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a nota e de credito e se o campo de data de digitacao esta preenchido Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			
			If cPaisLoc<> "BRA" .AND. SF2->(FieldPos("F2_DTDIGIT"))> 0 .and. (cAliasSF2)->F2_TIPO == "D"  .AND. !Empty((cAliasSF2)->F2_DTDIGIT)
				lValido := .F.			
			EndIf			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Melhoria pedida no Bops 67407, para contabilizar a NCC no modulo de faturamento e Ё
			//Ё as NCP no modulo de compras.                                                      Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If cPaisLoc == "CHI"  .And. ;
				((Alltrim(SF2->F2_TIPO) == "D" .And. Alltrim(cModulo) == "FAT") .Or.;
				(Alltrim(SF2->F2_TIPO) <> "D" .And. Alltrim(cModulo) == "COM"))
				lValido := .F.			
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Inicia a contabilizacao deste documento de saida             Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды			
			If lValido
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Posiciona no Cabecalho do documento de saida                 Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lQuery 
					If !lOptimize
						SF2->(MsGoto((cAliasSF2)->SF2RECNO))
					Else
						nRecSF2 := (cAliasSF2)->SF2RECNO
					EndIf
				
				
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Ajusta a data base com a data de contabilizacao              Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Do Case
					Case nTpCtb == 1
						
						dDataBase := (cAliasSF2)->F2_EMISSAO
						
						If lCtNfsDt
							dDataBase := Execblock("CTNFSDT",.F.,.F.)
						EndIf
					Case nTpCtb == 2
						dDataBase := dDataFim
				EndCase
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Preparacao da contabilizacao por documento                   Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Begin Transaction
			    	If 	!lHeader
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifica o numero do lote contabil                           Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						dbSelectArea("SX5")
						dbSetOrder(1)
						If MsSeek(xFilial()+"09FAT")
							cLoteCtb := AllTrim(X5Descri())
						Else
							cLoteCtb := "FAT "
						EndIf		
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Executa um execblock                                         Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If At("EXEC",Upper(X5Descri())) > 0
							cLoteCtb := &(X5Descri())
						EndIf
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Inicializa o arquivo de contabilizacao                       Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
						IF nHdlPrv <= 0
							HELP(" ",1,"SEM_LANC")
							lContinua := .F.
						Else
							lHeader := .T.
						EndIf		
	            	EndIf
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona registros vinculados ao cabecalho do documento     Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Processa os itens do documento de saida                      Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
						
						If 	(cAliasSD2)->D2_ORIGLAN <> "LF"
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Posiciona registros vinculados ao item do documento          Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If cModulo == "LOJ"
							
								dbSelectArea("SL1")
								dbSetOrder(2)
								MsSeek( xFilial("SL1")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC)
								
								dbSelectArea("SL2")
								dbSetOrder(3)
								MsSeek( xFilial("SL2")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_COD)
					
								If cPaisLoc == "CHI"
									If (cAliasSD2)->D2_ORIGLAN = "LO"
										lValido := .F.
									EndIf
								EndIf
								
								// Permite a contabilizacao pelo SL4 (Itens de Venda por Forma de Pagamento)
								If lLctPad31
									dbSelectArea("SL4")
									dbSetOrder(1)									
									If dbSeek(xFilial()+SL1->L1_NUM)
										While !Eof() .and. xFilial("SL1") == SL4->L4_FILIAL .and. SL4->L4_NUM == SL1->L1_NUM
                                         	//eugenio MsgAlert(SL4->L4_NUM+SL1->L1_NUM+SF2->F2_DOC+SD2->D2_ITEM)
				                            c631       := CtRelation("631",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
											nTotalCtb += DetProva(nHdlPrv,"631","CNA200C",cLoteCtb,,,,,@c631,@aCT5)
											dbSkip()
											Loop
										End
									EndIf
						 		EndIf
							EndIf
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Preparacao da contabilizacao por item do documento           Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды						
							If lValido						
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Posiciona registros vinculados ao item do documento          Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
								
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Executa os lancamentos contabeis ( 610 ) - Item              Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If lLctPad10 .And. lLctPad31 .And. !lHeader		// ou usa o 610 ou o 631
//								If lLctPad10 .And. lHeader // nao verica se tem o lp 631
                                 If cModulo = "LOJ"
									c610       := CtRelation("610",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									//nTotalCtb += DetProva(nHdlPrv,"610","CTBANFS",cLoteCtb,,,,,@c610,@aCT5)
                                 Endif
								EndIf
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Executa os lancamentos contabeis ( 678 ) - C.M.V.            Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If lLctPad78 .And. lHeader
									c678       := CtRelation("678",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									nTotalCtb += DetProva(nHdlPrv,"678","CNA200C",cLoteCtb,,,,,@c678,@aCT5)
								EndIf
							EndIf
						EndIf						
						If lValido .And. lFirst
							lFirst := .F.
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Executa os lancamentos contabeis ( 620 ) - Cabecalho         Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
							oObj:IncRegua2("Aguarde abortando execucao")
						EndIf
						
					EndDo
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza a data de lancamento contabil para nao refaze-lo    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Fecha os lancamentos contabeis                               Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					lHeader := .F.
					RodaProva(nHdlPrv,nTotalCtb)
					If nTotalCtb > 0 				
						nTotalCtb := 0
						cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
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
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza a regua de processamento por periodo                Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If dDataProc<>(cAliasSF2)->F2_EMISSAO
				While dDataProc<=(cAliasSF2)->F2_EMISSAO
					If lInterface
						oObj:IncRegua2("Documento de"+": "+Dtoc((cAliasSF2)->F2_EMISSAO))
					Endif
					dDataProc++
				EndDo
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a contabilizacao foi abortada                    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lEnd
				Exit
			EndIf
		EndDo
		If nTpCtb == 2 .And. lHeader
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Fecha os lancamentos contabeis                               Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			lHeader   := .F.
			RodaProva(nHdlPrv,nTotalCtb)
			If nTotalCtb > 0
				nTotalCtb := 0			
				cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
			EndIf
		EndIf
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Retorna a situacao inicial                                   Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lQuery
			dbSelectArea(cAliasSF2)
			dbCloseArea()
			If !lOptimize
				ChkFile("SD2")
			Else
				dbSelectArea("SD2")
			EndIf
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
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se o arquivo e compartilhado para encerrar a contab.Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Empty(xFilial("SF2"))
		Exit
	EndIf
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a contabilizacao foi abortada                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lEnd
		Exit
	EndIf	
	dbSelectArea("SM0")
	dbSkip()
EndDo
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a integridade da Rotina                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RestArea(aAreaSM0)
RestArea(aArea)
cFilAnt := SM0->M0_CODFIL
dDataBase := dSavBase

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Efetua lancamentos contabeis do Remito                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If cPaisLoc <> "BRA"
	LocBlock("C200A",.F.,.F.)
EndIf

If cPaisLoc <> "BRA" .and. SF2->(FieldPos("F2_DTDIGIT"))>0 
 	 If cPaisLoc == "CHI" .and. ! AllTrim(cModulo) $ "COM|EST"
		    lContNCP  := .F.
     Else
			If lContNCP
				U_LCCTBANCPS(lDigita,lAglutina,nTpCtb,lCMV,dDataIni,dDataFim,cFilDe,cFilAte,oObj,lEnd)
				RestArea(aAreaSM0)
				RestArea(aArea)
				cFilAnt := SM0->M0_CODFIL
				dDataBase := dSavBase
	        EndIf
	  EndIf
EndIf	
Return(.T.)
/*/
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддд©╠╠
╠╠ЁFun┤└o    ЁCCTBANCPS  ЁAutor  Ё Paulo Augusto         Ё Data Ё28.04.2003 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддд╢╠╠
╠╠Ё          ЁRotina de processamento da contabilizacao off-line dos Docu- Ё╠╠
╠╠Ё          Ёmentos de Credito de Fornecedores                            Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ 							                                   Ё╠╠
╠╠Ё          Ё														       Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRetorno   ЁNenhum                                                       Ё╠╠
╠╠Ё          Ё                                                             Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁDescri┤└o ЁEsta rotina tem como objetivo contabilizar os documentos de  Ё╠╠
╠╠Ё          ЁCredito de Fornecedores com base nos lancamentos contabeis,  Ё╠╠
╠╠Ё          Ёde forma off-line                                            Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё CTB/FAT/OMS                                                 Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/

User Function LcCTBANCPS(lDigita,lAglutina,nTpCtb,lCMV,dDataIni,dDataFim,cFilDe,cFilAte,oObj,lEnd)

Local aCT5       := {}
Local dDataProc  := Ctod("")
Local lFirst     := .T.
Local lCtNfsDt   := ExistBlock("CTNFSDT")
Local lFilSf2    := Existblock("CTNFSFIL")
Local lLctPad10  := VerPadrao("610")	// Credito de Estoque / Debito de C.M.V.
Local lLctPad20  := VerPadrao("620")	// Debito de Cliente  / Credito de Venda
Local lLctPad31  := VerPadrao("631")	// Debito de Cliente  / Credito de Venda (Modulo Loja, a partir do SL4)
Local lLctPad78  := VerPadrao("678")	// Credito de Estoque / Debito de C.M.V. (CUSTO)
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
Local c610       := ""
Local c620       := ""
Local c631       := ""
Local c678       := ""
Local cQuery     := ""
Local cKeySF2    := "F2_FILIAL+DTOS(F2_DTDIGIT)"
Local cArqSF2    := ""
Local nHdlPrv    := 0 
Local nTotalCtb  := 0
Local nOrdSF2    := 0
Local nRecSF2    := 0
Local nY         := 0

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

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicializa parametros DEFAULT                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DEFAULT lDigita   := .F.
DEFAULT lAglutina := .F.
DEFAULT nTpCtb    := 1
DEFAULT dDataIni  := FirstDay(dDataBase)
DEFAULT dDataFim  := LastDay(dDataBase)
DEFAULT lCMV      := .F.
DEFAULT cFilDe    := cFilAnt
DEFAULT cFilAte   := cFilAnt
DEFAULT lEnd      := .F.
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Compatibilizacao dos lancamentos contabeis                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If !lCMV
	lLctPad78 := .F.
EndIf
lLctPad  := lLctPad10 .Or. lLctPad20 .Or. lLctPad78
lContinua := lLctPad
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Montagem da primeira regua por filiais                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lInterface
	oObj:SetRegua1(SM0->(LastRec()))
EndIf

dbSelectArea("SM0")
dbSetOrder(1)
MsSeek(cEmpAnt+cFilDe,.T.)
While ( !Eof() .And. SM0->M0_CODIGO == cEmpAnt .And. ;
	SM0->M0_CODFIL <= cFilAte .And. lContinua )
	
	cFilAnt := SM0->M0_CODFIL
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza a regua de processamento de filiais                 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lInterface
		oObj:IncRegua1("Contabilizando"+": "+SM0->M0_CODFIL+"/"+SM0->M0_FILIAL)
	EndIf
	For nY := 1 To 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Processa os documentos de saida da filial corrente           Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSelectArea("SD2")
		dbSetOrder(3)
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				lQuery := .T.				 
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Demonstra regua de processamento da query                    Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lInterface
					If lOptimize
						oObj:IncRegua2("Executando processo de otimizacao com query")
					Else 
						oObj:IncRegua2("Executando query")
					EndIf
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica o parametro de otimizacao                           Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If GetNewPar("MV_OPTNFS",.F.)
					lOptimize := .T.
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem do Array de otimizacao de Query                     Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
				Else
					cAliasSF2 := "SD2"
					cAliasSD2 := "SD2"
					cAliasSB1 := "SD2"
					cAliasSF4 := "SD2"
					cAliasSA1 := "SD2"
					cAliasSA2 := "SD2"
				EndIf
				
				aStruSF2  := SF2->(dbStruct())
				aStruSD2  := SD2->(dbStruct())
				aStruSB1  := SB1->(dbStruct())
				aStruSF4  := SF4->(dbStruct())
				aStruSA1  := SA1->(dbStruct())
				aStruSA2  := SA2->(dbStruct())

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da instrucao select                                 Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				For nX := 1 To Len(aStruSF2)
					If !"F2_BASE"$aStruSF2[nX][1]
						aadd(aOptimize[OPT_SELECT],aStruSF2[nX])
					EndIf
			    Next nX
				For nX := 1 To Len(aStruSD2)
					If !"D2_BASE"$aStruSD2[nX][1]
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
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da instrucao from                                   Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF2"),"SF2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SD2"),"SD2"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SB1"),"SB1"})
				aadd(aOptimize[OPT_FROM],{RetSqlName("SF4"),"SF4"})
				If nY == 1
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA1"),"SA1"})
				Else
					aadd(aOptimize[OPT_FROM],{RetSqlName("SA2"),"SA2"})
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da instrucao where                                  Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
				aOptimize[OPT_WHERE] += "SD2.D2_ORIGLAN<>'LF' AND SD2.D2_ORIGLAN='LO' AND "
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
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Execucao do execblock para alteracao da query de otimizacao  Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lOptimize
					If ExistBlock("CTBNFS")
						aOptimize := ExecBlock("CTBNFS",.F.,.F.,aOptimize)
					EndIf
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Montagem da Query                                            Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды				
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
				cString := ""
				For nX := 1 To Len(aOptimize[OPT_FROM])
					cString += ","+aOptimize[OPT_FROM][nX][1]+" "+aOptimize[OPT_FROM][nX][2]
				Next nX
				cQuery += "FROM "+SubStr(cString,2)
				cQuery += "WHERE "+aOptimize[OPT_WHERE]
				
				cQuery += "ORDER BY "+SqlOrder(SF2->(IndexKey()))+","+SqlOrder(SD2->(IndexKey()))
			
				cQuery := ChangeQuery(cQuery)
				
				If !lOptimize
					dbSelectArea("SD2")
					dbCloseArea()
				EndIf
								
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
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Preparacao da contabilizacao por periodo                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lLctPad .And. nTpCtb == 2
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica o numero do lote contabil                           Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("SX5")
			dbSetOrder(1)
			If MsSeek(xFilial()+"09FAT")
				cLoteCtb := AllTrim(X5Descri())
			Else
				cLoteCtb := "FAT "
			EndIf		
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Executa um execblock                                         Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If At(UPPER("EXEC"),X5Descri()) > 0
				cLoteCtb := &(X5Descri())
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Inicializa o arquivo de contabilizacao                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
			nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
			IF nHdlPrv <= 0
				HELP(" ",1,"SEM_LANC")
				lContinua := .F.
			Else
				lHeader := .T.
			EndIf		
		EndIf			
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Montagem da segunda regua por periodo                        Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lInterface
			oObj:SetRegua2(dDataFim+1-dDataIni)
			dDataProc := dDataIni
			oObj:IncRegua2("Documento de Credito de "+": "+Dtoc((cAliasSF2)->F2_DTDIGIT))
		EndIf
		dbSelectArea(cAliasSF2)
		While ( !Eof() .And. (cAliasSF2)->F2_FILIAL == xFilial("SF2") .And.;
			(cAliasSF2)->F2_DTDIGIT <= dDataFim .And. lContinua)
			
			lValido   := .T.
			lDetProva := .F.
			lSkipSF2  := .T.
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a nota nao foi contabilizada                     Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If Empty((cAliasSF2)->F2_DTLANC)
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Executa a filtragem da customizacao                          Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lFilSf2
					If !(Execblock("CTNFSFIL",.F.,.F.,{cAliasSF2}))
						lValido := .F.
					EndIf
				EndIf
			Else
				lValido := .F.
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Inicia a contabilizacao deste documento de saida             Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды			
			If lValido
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Posiciona no Cabecalho do documento de saida                 Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If lQuery 
					If !lOptimize
						SF2->(MsGoto((cAliasSF2)->SF2RECNO))
					Else
						nRecSF2 := (cAliasSF2)->SF2RECNO
					EndIf
				EndIf
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Ajusta a data base com a data de contabilizacao              Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Do Case
					Case nTpCtb == 1
						
						dDataBase := (cAliasSF2)->F2_DTDIGIT
						
						If lCtNfsDt
							dDataBase := Execblock("CTNFSDT",.F.,.F.)
						EndIf
					Case nTpCtb == 2
						dDataBase := dDataFim
				EndCase
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Preparacao da contabilizacao por documento                   Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Begin Transaction
			    	If 	!lHeader
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifica o numero do lote contabil                           Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						dbSelectArea("SX5")
						dbSetOrder(1)
						If MsSeek(xFilial()+"09FAT")
							cLoteCtb := AllTrim(X5Descri())
						Else
							cLoteCtb := "FAT "
						EndIf		
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Executa um execblock                                         Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If At("EXEC",Upper(X5Descri())) > 0
							cLoteCtb := &(X5Descri())
						EndIf
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Inicializa o arquivo de contabilizacao                       Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",Subs(cUsuario,7,6),@cArqCtb)
						IF nHdlPrv <= 0
							HELP(" ",1,"SEM_LANC")
							lContinua := .F.
						Else
							lHeader := .T.
						EndIf		
	            	EndIf
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona registros vinculados ao cabecalho do documento     Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Processa os itens do documento de saida                      Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
						
											
						If 	(cAliasSD2)->D2_ORIGLAN <> "LF"
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Posiciona registros vinculados ao item do documento          Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If cModulo == "LOJ"
							
								dbSelectArea("SL1")
								dbSetOrder(2)
								MsSeek( xFilial("SL1")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC)

								dbSelectArea("SL2")
								dbSetOrder(3)
								MsSeek( xFilial("SL2")+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_COD)

								If cPaisLoc == "CHI"
									If (cAliasSD2)->D2_ORIGLAN = "LO"
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
											nTotalCtb += DetProva(nHdlPrv,"631","CNA200C",cLoteCtb,,,,,@c631,@aCT5)
											dbSkip()
											Loop
										End
									EndIf
						 		EndIf
							EndIf
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Preparacao da contabilizacao por item do documento           Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды						
							If lValido						
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Posiciona registros vinculados ao item do documento          Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
								
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Executa os lancamentos contabeis ( 610 ) - Item              Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If lLctPad10 .And. lLctPad31 .And. !lHeader		// ou usa o 610 ou o 631
//								If lLctPad10 .And. lHeader		// ou usa o 610 ou o 631
                                 IF  cModulo == "LOJ"
									c610       := CtRelation("610",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									nTotalCtb += DetProva(nHdlPrv,"610","CTBANFS",cLoteCtb,,,,,@c610,@aCT5)
          	                      Endif
								EndIf
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Executa os lancamentos contabeis ( 678 ) - C.M.V.            Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If lLctPad78 .And. lHeader
									c678       := CtRelation("678",.F.,{{cAliasSF2,"SF2"},{cAliasSD2,"SD2"},{cAliasSD2,"CTBANFS"}})
									lDetProva := .T.
									nTotalCtb += DetProva(nHdlPrv,"678","CNA200C",cLoteCtb,,,,,@c678,@aCT5)
								EndIf
							EndIf
						EndIf						
						If lValido .And. lFirst
							lFirst := .F.
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Executa os lancamentos contabeis ( 620 ) - Cabecalho         Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
							oObj:IncRegua2("Aguarde abortando execucao") 
						EndIf
						
					EndDo
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza a data de lancamento contabil para nao refaze-lo    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Fecha os lancamentos contabeis                               Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					lHeader := .F.
					RodaProva(nHdlPrv,nTotalCtb)
					If nTotalCtb > 0 				
						nTotalCtb := 0
						cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
					EndIf
				EndIf
			EndIf
			If lSkipSF2 .Or. !lQuery
				dbSelectArea(cAliasSF2)
				dbSkip()
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza a regua de processamento por periodo                Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If dDataProc<>(cAliasSF2)->F2_DTDIGIT
				While dDataProc<=(cAliasSF2)->F2_DTDIGIT
					If lInterface
						oObj:IncRegua2("Documento de Credito de "+": "+Dtoc((cAliasSF2)->F2_DTDIGIT))
					Endif
					dDataProc++
				EndDo
			EndIf
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a contabilizacao foi abortada                    Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lEnd
				Exit
			EndIf
		EndDo
		If nTpCtb == 2 .And. lHeader
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Fecha os lancamentos contabeis                               Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			lHeader   := .F.
			RodaProva(nHdlPrv,nTotalCtb)
			If nTotalCtb > 0
				nTotalCtb := 0			
				cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina)
			EndIf
		EndIf
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Retorna a situacao inicial                                   Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lQuery
			dbSelectArea(cAliasSF2)
			dbCloseArea()
			If !lOptimize
				ChkFile("SD2")
			Else
				dbSelectArea("SD2")
			EndIf
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
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se o arquivo e compartilhado para encerrar a contab.Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Empty(xFilial("SF2"))
		Exit
	EndIf
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a contabilizacao foi abortada                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lEnd
		Exit
	EndIf	
	dbSelectArea("SM0")
	dbSkip()
EndDo
Return
/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддддддбддддддбддддддддддддддддддддддбддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё CCTBNFSSX1    ЁAutor Ё  Marcello            ЁDataЁ 31/07/03 Ё╠╠
╠╠цддддддддддеддддддддддддддаддддддаддддддддддддддддддддддаддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Atualiza o grupo de perguntas                              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function LcCTBNFSSX1()
Local aSaveArea	:= GetArea()
Local aPergs:={},aHelpPor:={},aHelpEng:={},aHelpSpa:={}

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  ЁATENCAO                                                                Ё
  ЁCaso haja a necessidade de adicao de novos parametros entrar em contatoЁ
  Ёcom o departamento de Localizacoes.          						  Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
If cPaisLoc<>"BRA"
	Aadd(aHelpPor,"Informe se deseja contabilizar as")
	Aadd(aHelpPor,"notas de credito")
	Aadd(aHelpSpa,"Informe si desea contabilizar las")
	Aadd(aHelpSpa,"notas de credito")
	Aadd(aHelpEng,"Inform if you wish to account the")
	Aadd(aHelpEng,"credit notes")

	Aadd(aPergs,{"Cont.Notas Credito ?","©Cont.Notas Credito?","Post credit notes?","mv_ch9","N",1,0,0,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa})
	AjustaSx1("CTBNFS",aPergs)
Endif

RestArea(aSaveArea)
Return
