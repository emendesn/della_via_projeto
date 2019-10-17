#INCLUDE "MATA103.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA103  ³ Autor ³ Edson Maricate        ³ Data ³ 24.01.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Notas Fiscais de Entrada                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MATA103(xAutoCab,xAutoItens,nOpcAuto,lWhenGet,xAutoImp)
Local nPos      := 0
Local bBlock    := {|| Nil}    
Local nX		:= 0
Local aRotina3  := {{STR0002,"NfeDocVin",0,2},; //"Visualizar"
					{STR0164,"NfeDocVin",0,4},; //"Alterar"
					{STR0006,"NFeDocVin",0,5}}  //"Excluir"
Local aRotina4  := {{STR0009,"NfeDocCob",0,4}} //"Documento de Entrada"
Local aRotina2  := {{STR0165,aRotina3,0,4},; //"Vincular"
					{STR0166,aRotina4,0,4}} //"Cobertura"
Local aCores    := {{ 'Empty(F1_STATUS)', 'ENABLE' },; // NF Nao Classificada
	{'F1_STATUS=="B"','BR_LARANJA'},; // NF Bloqueada
	{'F1_TIPO=="N"', 'DISABLE'   },; // NF Normal
	{'F1_TIPO=="P"', 'BR_AZUL'   },; // NF de Compl. IPI
	{'F1_TIPO=="I"', 'BR_MARRON' },;	 // NF de Compl. ICMS
	{'F1_TIPO=="C"', 'BR_PINK'   },;	 // NF de Compl. Preco/Frete
	{'F1_TIPO=="B"', 'BR_CINZA'  },;	 // NF de Beneficiamento
	{'F1_TIPO=="D"', 'BR_AMARELO'} }	 // NF de Devolucao

PRIVATE l103Auto 	:= (xAutoCab<>NIL .And. xAutoItens<>NIL)
PRIVATE aAutoCab	:= {}
PRIVATE aAutoImp    := {}
PRIVATE aAutoItens 	:= {}
PRIVATE aRotina 	:= {{ OemToAnsi(STR0001),"AxPesqui"    , 0 , 1},; //"Pesquisar"
	{OemToAnsi(STR0002), "A103NFiscal", 0, 2},; //"Visualizar"
	{OemToAnsi(STR0003), "A103NFiscal", 0, 3},; //"Incluir"
	{OemToAnsi(STR0004), "A103NFiscal", 0, 4},; //"Classificar"
	{OemToAnsi(STR0005), "A103Devol"  , 0, 3},; //"Retornar"
	{OemToAnsi(STR0006), "A103NFiscal", 3, 5},; //"Excluir"
	{OemToAnsi(STR0007), "A103Impri"  , 0, 4},; //"Imprimir"
	{OemToAnsi(STR0008), "A103Legenda", 0, 2} } //"Legenda"
PRIVATE cCadastro	:= OemToAnsi(STR0009) //"Documento de Entrada"
PRIVATE aBackSD1    := {}
PRIVATE aBackSDE    := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao da rotina do documento vinculado                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasInDic("SDH") .And. SDH->(FieldPos("DH_ITEM"))<>0
	aadd(aRotina,{STR0167   , aRotina2, 0, 4}) //"Doc.Vinculado"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os parametros DEFAULTS da rotina                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFAULT lWhenGet := .F.
//-- Forca a criacao do arq. dcf pois o sigamdi nao cria o arq.
If	(SuperGetMV('MV_INTDL')=='S')
	DbSelectArea("DCF")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ P.E. Utilizado para adicionar botoes ao Menu Principal       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("MA103OPC") .And. !l103Auto
   aRotNew := ExecBlock("MA103OPC",.F.,.F.,aRotina)
   For nX := 1 to len(aRotNew)
		aAdd(aRotina,aRotNew[nX])
   Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta as cores se utilizar coletor de dados                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SuperGetMV("MV_CONFFIS") == "S"
		
	aCores    := {{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. Empty(F1_STATUS)', 'ENABLE' },;	// NF Nao Classificada
		{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="N"'	 , 'DISABLE'},;		// NF Normal
		{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="P"'	 , 'BR_AZUL'},;		// NF de Compl. IPI
		{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="I"'	 , 'BR_MARRON'},;	// NF de Compl. ICMS
		{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="C"'	 , 'BR_PINK'},;		// NF de Compl. Preco/Frete
		{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="B"'	 , 'BR_CINZA'},;	// NF de Beneficiamento
		{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="D"'    , 'BR_AMARELO'},;	// NF de Devolucao
		{ 'F1_STATCON<>"1" .AND. !EMPTY(F1_STATCON)', 'BR_PRETO'}}
		
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a permissao do programa em relacao aos modulos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AMIIn(2,4,11,12,14,17,39,41,42,43,97,44)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de rotina a ser executada                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aAutoCab   := xAutoCab
	aAutoItens := xAutoItens
	aAutoImp   := IIf(xAutoImp<>NIL,xAutoImp,{})
	Do Case
	Case lWhenGet .Or. ( !l103Auto .And. nOpcAuto <> Nil )

		Do Case
			Case nOpcAuto == 3
				INCLUI := .T.
				ALTERA := .F.
			Case nOpcAuto == 4
				INCLUI := .F.
				ALTERA := .T.
			OtherWise	
				INCLUI := .F.
				ALTERA := .F.
		EndCase		

		dbSelectArea('SF1')
		nPos := Ascan(aRotina,{|x| x[4]== nOpcAuto})
		If ( nPos <> 0 )
			bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPos,2 ] + "(a,b,c,d,e) }" )
			Eval( bBlock, Alias(), (Alias())->(Recno()),nPos,lWhenGet)
		EndIf
	Case l103Auto
		AAdd( aRotina, {OemToAnsi(STR0006), "A103NFiscal", 3, 20 } ) //"Exclusao EIC"
		AAdd( aRotina, {OemToAnsi(STR0006), "A103NFiscal", 3, 21 } ) //"Exclusao TMS"		
		DEFAULT nOpcAuto := 3//alteraw
		MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"SF1")
	OtherWise
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Interface com o usuario via Mbrowse                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Set Key VK_F12 To FAtiva()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para pre-validar os dados a serem  ³
		//³ exibidos.                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF ExistBlock("M103BROW")
			ExecBlock("M103BROW",.f.,.f.)
		EndIf
		mBrowse(6,1,22,75,"SF1",,,,,,aCores)
		Set Key VK_F12 To
	EndCase
EndIf
Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103NFiscal³ Autor ³ Edson Maricate       ³ Data ³24.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Incl/Alter/Excl/Visu.de NF Entrada             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103NFiscal(ExpC1,ExpN1,ExpN2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103NFiscal(cAlias,nReg,nOpcx,lWhenGet)

Local lContinua  := .T.
Local l103Inclui := .F.
Local l103Exclui := .F.
Local l103Class  := .F.
Local lMT103NFE  := Existblock("MT103NFE")
Local lTMT103NFE := ExistTemplate("MT103NFE")
Local lDigita    := .F.
Local lAglutina  := .F.
Local lQuery     := .F.
Local lGeraLanc  := .F.
Local lPyme      := If( Type( "__lPyme" ) <> "U", __lPyme, .F. )
Local lClassOrd  := ( SuperGetMV( "MV_CLASORD" ) == "1" ) 
Local lNfeOrd    := ( GetNewPar( "MV_NFEORD" , "2" ) == "1" )
Local lExcViaEIC := .F. 
Local lExcViaTMS := .F. 
Local lProcGet   := .T.

Local nRecSF1	 := 0
Local nOpc		 := 0
Local nUsado	 := 0
Local nUsadoSDE	 := 0
Local nItemSDE   := 0
Local nItRatFro  := 0
Local nItRatVei  := 0
Local nTpRodape  := 1
Local nX         := 0
Local nY         := 0      
Local nCounterSD1:= 0
Local nMaxCodes  := SetMaxCodes( 999 )      
Local nBasePIS   := 0 
Local nBaseCOF   := 0 
Local nValorPIS  := 0 
Local nValorCOF  := 0 
Local nAliqPIS   := 0 
Local nAliqCOF   := 0 

Local nIndexSE2  := 0   

Local nScanBsPis := 0 
Local nScanVlPis := 0
Local nScanAlPis := 0 
Local nScanBsCof := 0
Local nScanVlCof := 0
Local nScanAlCof := 0          
Local nLoop      := 0 

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local cModRetPIS := GetNewPar( "MV_RT10925", "1" ) 

Local aStruSF3   := {}
Local aStruSDE   := {}
Local aStruSE2   := {}
Local aStruSD1   := {}
Local aRecSD1	 := {}
Local aRecSE1	 := {}
Local aRecSE2	 := {}
Local aRecSF3	 := {}
Local aRecSC5	 := {}
Local aRecSDE	 := {}
Local aHeadSDE   := {}
Local aHeadSE2   := {}
Local aColsSE2   := {}
Local aHeadSEV   := {}
Local aColsSEV   := {}
Local aColsSDE   := {}
Local aHistor	 := {}
Local aObjects	 := {}
Local aInfo 	 := {}
Local aPosGet	 := {}
Local aPosObj	 := {}
Local aPages	 := {"HEADER"}
Local aInfForn	 := {"","",CTOD("  /  /  "),CTOD("  /  /  "),"","","",""}
Local a103Var	 := {0,0,0,0,0,0,0,0}
Local aButControl:= {}
Local aTitles	 := {	OemToAnsi(STR0010),; //"Totais"
	OemToAnsi(STR0011),;//"Inf. Fornecedor/Cliente"
	OemToAnsi(STR0012),;//"Descontos/Frete/Despesas"
	OemToAnsi(STR0014),;//"Livros Fiscais"
	OemToAnsi(STR0015),;//"Impostos"
	OemToAnsi(STR0013)} //"Duplicatas"
Local aSizeAut	 := {}
Local aButVisual := {}
Local aButtons	 := {}
Local aAuxRefSD1 := MaFisSXRef("SD1")
Local aRateio    := {0,0,0}
Local aFldCBAtu  := Array(Len(aTitles))
Local aRecClasSD1:= {}  
Local aRelImp    := MaFisRelImp("MT100",{ "SD1" })
Local aFil10925  := {}

Local cCadastro	 := OemToAnsi(STR0009) //"Documento de Entrada"
Local cPrefixo 	 := IIf(Empty(SF1->F1_PREFIXO),&(SuperGetMV("MV_2DUPREF")),SF1->F1_PREFIXO)
Local cHistor	 := ""
Local cItem      := ""
Local cItemSDE	 := ""
Local cItemSDG	 := ""
Local cQuery     := ""
Local cAliasSF3 := "SF3"
Local cAliasSDE := "SDE"
Local cAliasSE2 := "SE2"
Local cAliasSD1 := "SD1"
Local cAliasSB1 := "SB1"
Local cUfOrig   := ""         
Local cFornIss  := Space(Len(SE2->E2_FORNECE))
Local cLojaIss  := Space(Len(SE2->E2_LOJA))
Local cDirf     := Space(Len(SE2->E2_DIRF))
Local cCodRet   := Space(Len(SE2->E2_CODRET))

Local cVarFoco  := "     " 
Local cIndex    := "" 
Local cCond     := "" 
Local cNatureza := "" 

Local cCpBasePIS:= "" 
Local cCpValPIS := ""                       
Local cCpAlqPIS := ""
Local cCpBaseCOF:= "" 
Local cCpValCOF := ""
Local cCpAlqCOF := ""                       
               
Local nPosRec   := 0
Local nCombo    := 2
Local nItValido := 0
Local oDlg
Local oHistor
Local oLivro
Local oCombo
Local oCodRet

Local bKeyF12   := Nil
Local bPMSDlgNF	:= {||PmsDlgNF(nOpcx,cNFiscal,cSerie,cA100For,cLoja,cTipo)} // Chamada da Dialog de Gerenc. Projetos
Local bCabOk    := {|| .T.}
Local bIPRefresh:= {|| MaFisToCols(aHeader,aCols,,"MT100"),Eval(bRefresh),Eval(bGdRefresh)}	// Carrega os valores da Funcao fiscal e executa o Refresh
Local bWhileSD1 := { || .T. } 
Local lMT103NAT := Existblock("MT103NAT") 

PRIVATE l103Visual := .F.
PRIVATE lReajuste  := .F.
PRIVATE lAmarra    := .F.
PRIVATE lConsLoja  := .F.
PRIVATE lPrecoDes  := .F.
PRIVATE cTipo      := ""
PRIVATE cFormul    := ""
PRIVATE cNFiscal   := ""
PRIVATE cSerie	   := ""
PRIVATE cA100For   := ""
PRIVATE cLoja      := ""
PRIVATE cEspecie   := ""
PRIVATE cCondicao  := ""
PRIVATE cForAntNFE := ""
PRIVATE dDEmissao  := dDataBase
PRIVATE n          := 1
PRIVATE nMoedaCor  := 1
PRIVATE aCols	   := {}
PRIVATE aHeader    := {}
PRIVATE aRatVei    := {}
PRIVATE aRatFro    := {}
PRIVATE aArraySDG  := {}
PRIVATE aRatAFN    := {}	//Variavel utilizada pela Funcao PMSDLGRQ - Gerenc. Projetos
PRIVATE xUserData  := NIL 

PRIVATE bRefresh   := {|nX| NfeFldChg(nX,nY,,aFldCBAtu)}
PRIVATE bGDRefresh := {|| IIf(oGetDados<>Nil,(oGetDados:oBrowse:Refresh()),.F.) }		// Efetua o Refresh da GetDados
PRIVATE oGetDados
PRIVATE oFolder
PRIVATE oFoco103
PRIVATE l240:=.F.
PRIVATE l241:=.F.
PRIVATE aBaseDup 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o tratamento eh pela baixa e disabilita a altera ³
//³ cao do tipo de retencao                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPccBaixa
	cModRetPis := "3"
Endif	

aBackSDE := If(Type('aBackSDE')=='U',{},aBackSDE)
aAdd(aButtons, {'PEDIDO',{||A103ForF4()},OemToAnsi(STR0024+" - <F5> "),STR0061} ) //"Selecionar Pedido de Compra"
aAdd(aButtons, {'PEDIDO2',{||A103ItemPC()},OemToAnsi(STR0025+" - <F6> "),STR0148} ) //"Selecionar Pedido de Compra ( por item )"
aAdd(aButtons, {'RECALC',{||A103NFORI()},OemToAnsi(STR0026+" - <F7> "),STR0062} ) //"Selecionar Documento Original ( Devolucao/Beneficiamento/Complemento )"

If ! lPyme
	aAdd(aButtons, {'NOVACELULA',{||A103LoteF4()},OemToAnsi(STR0027+" - <F8> "),STR0149} ) //"Selecionar Lotes Disponiveis"
EndIf
If ( aRotina[ nOpcX, 4 ] == 2 .Or. aRotina[ nOpcX, 4 ] == 6 ) .And. !AtIsRotina("A103TRACK")
	AAdd(aButtons  ,{ "ORDEM", {|| A103Track() }, OemToAnsi(STR0150), OemToAnsi(STR0150) } )  // "System Tracker"
	AAdd(aButVisual,{ "ORDEM", {|| A103Track() }, OemToAnsi(STR0150), OemToAnsi(STR0150) } )  // "System Tracker"
EndIf 	

 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para rotina automatica                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('l103Auto') == 'U'
	PRIVATE l103Auto	:= .F.
EndIf
lWhenGet   := IIf(ValType(lWhenGet) <> "L" , .F. , lWhenGet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
Case aRotina[nOpcx][4] == 2
	l103Visual := .T.
	INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
	ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)	
Case aRotina[nOpcx][4] == 3
	l103Inclui	:= .T.
	INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
	ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)		
Case aRotina[nOpcx][4] == 4
	l103Class	:= .T.
	INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
	ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)		
Case aRotina[nOpcx][4] == 5 .Or. aRotina[nOpcx][4] == 20 .or. aRotina[nOpcx][4] == 21 
	l103Exclui	:= .T.
	l103Visual	:= .T.
	INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
	ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Indica a chamada de exclusao via SIGAEIC                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aRotina[ nOpcx, 4 ] == 20 
		lExcViaEIC := .T. 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Encontra o nOpcx referente ao tipo 5 - Exclusao padrao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( nScan := AScan( aRotina, { |x| x[4] == 5 } ) )
			nOpcx := nScan 
		EndIf 	
	EndIf 	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Indica a chamada de exclusao via SIGATMS                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aRotina[ nOpcx, 4 ] == 21
		lExcViaTMS := .T. 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Encontra o nOpcx referente ao tipo 5 - Exclusao padrao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( nScan := AScan( aRotina, { |x| x[4] == 5 } ) )
			nOpcx := nScan 
		EndIf 	
	EndIf 
	
OtherWise
	l103Visual := .T.
	INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
	ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)	
EndCase
nRecSF1	 := IIF(INCLUI,0,SF1->(RecNo()))

If l103Class

	If !Empty( nScanBsPis := aScan(aRelImp,{|x| x[1]=="SD1" .And. x[3]=="IT_BASEPS2"} ) ) .And. ;
		!Empty( nScanVlPis := aScan(aRelImp,{|x| x[1]=="SD1" .And. x[3]=="IT_VALPS2"} ) ) .And. ;
		!Empty( nScanAlPis := aScan(aRelImp,{|x| x[1]=="SD1" .And. x[3]=="IT_ALIQPS2"} ) )		
		cCpBasePIS  := aRelImp[nScanBsPis,2]
		cCpValPIS   := aRelImp[nScanVlPis,2]
		cCpAlqPIS   := aRelImp[nScanAlPis,2]		
	EndIf
	
	If !Empty( nScanBsCof := aScan(aRelImp,{|x| x[1]=="SD1" .And. x[3]=="IT_BASECF2"} ) ) .And. ;
		!Empty( nScanVlCof := aScan(aRelImp,{|x| x[1]=="SD1" .And. x[3]=="IT_VALCF2"} ) ) .And. ;
		!Empty( nScanAlCof := aScan(aRelImp,{|x| x[1]=="SD1" .And. x[3]=="IT_ALIQCF2"} ) )
		cCpBaseCOF  := aRelImp[nScanBsCOF,2]
		cCpValCOF   := aRelImp[nScanVlCOF,2]
		cCpAlqCOF   := aRelImp[nScanAlCOF,2] 
	EndIf

EndIf 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as Hot-keys da rotina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !l103Auto .And. (l103Inclui .Or. l103Class .Or. lWhenGet)
	SetKey( VK_F4 , { || A103F4() } )
	SetKey( VK_F5 , { || A103ForF4() } )
	SetKey( VK_F6 , { || A103ItemPC() } )
	SetKey( VK_F7 , { || A103NFORI() } )
	If !lPyme
		SetKey( VK_F8 , { || A103LoteF4() } )	
	EndIf	
	SetKey( VK_F9 , { |lValidX3| NfeRatCC(aHeadSDE,aColsSDE,l103Inclui.Or.l103Class,lValidX3)})
	bKeyF12 := SetKey( VK_F12 , Nil )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Integracao com o modulo de Projetos                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If IntePms()		// Integracao PMS
		SetKey( VK_F10, { || Eval(bPmsDlgNF)} )
	EndIf
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Integracao com o modulo de Transportes                     ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IntTMS()		// Integracao TMS
		SetKey( VK_F11, { || oGetDados:oBrowse:lDisablePaint:=.T.,A103RatVei(),oGetDados:oBrowse:lDisablePaint:=.F.} )
	EndIf
ElseIf !l103Auto .Or. lWhenGet
	bKeyF12 := SetKey( VK_F12 , Nil )
	SetKey( VK_F9 , { |lValidX3| oGetDados:oBrowse:lDisablePaint:=.T.,NfeRATCC(aHeadSDE,aColsSDE,l103Inclui.Or.l103Class,lValidX3),oGetDados:oBrowse:lDisablePaint:=.F. } )
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Integracao com o modulo de Projetos                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If IntePms()		// Integracao PMS
	aadd(aButtons	, {'PROJETPMS',{||Eval(bPmsDlgNF)},OemToAnsi(STR0029+" - <F10> "),OemToAnsi(STR0151)}) //"Gerenciamento de Projetos"
	aadd(aButVisual	, {'PROJETPMS',{||Eval(bPmsDlgNF)},OemToAnsi(STR0029+" - <F10> "),OemToAnsi(STR0151)}) //"Gerenciamento de Projetos"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Integracao com o modulo de Transportes                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IntTMS()		// Integracao TMS
	Aadd(aButtons	, {'CARGA',{||oGetDados:oBrowse:lDisablePaint:=.T.,A103RATVEI(),oGetDados:oBrowse:lDisablePaint:=.F. },STR0030+" - <F11>" , STR0152}) //"Rateio por Veiculo/Viagem"
	Aadd(aButVisual	, {'CARGA',{||oGetDados:oBrowse:lDisablePaint:=.T.,A103RATVEI(),oGetDados:oBrowse:lDisablePaint:=.F. },STR0030+" - <F11>", STR0152 }) //"Rateio por Veiculo/Viagem"
	Aadd(aButtons	, {'CARGASEQ',{||oGetDados:oBrowse:lDisablePaint:=.T.,A103FROTA(),oGetDados:oBrowse:lDisablePaint:=.F. },STR0031,STR0153}) //"Rateio por Frota"
	Aadd(aButVisual	, {'CARGASEQ',{||oGetDados:oBrowse:lDisablePaint:=.T.,A103FROTA(),oGetDados:oBrowse:lDisablePaint:=.F. },STR0031,STR0153}) //"Rateio por Frota"
EndIf
Aadd(aButtons	, {'S4WB013N',{||oGetDados:oBrowse:lDisablePaint:=.T.,NfeRatCC(aHeadSDE,aColsSDE,l103Inclui.Or.l103Class),oGetDados:oBrowse:lDisablePaint:=.F. },OemToAnsi(STR0032+" - <F9> "),STR0154} ) //"Rateio do item por Centro de Custo"
Aadd(aButVisual	, {'S4WB013N',{||oGetDados:oBrowse:lDisablePaint:=.T.,NfeRatCC(aHeadSDE,aColsSDE,l103Inclui.Or.l103Class),oGetDados:oBrowse:lDisablePaint:=.F. },OemToAnsi(STR0032+" - <F9> "),STR0154} ) //"Rateio do item por Centro de Custo"
aadd(aButVisual	, {"S4WB005N" ,{|| NfeViewPrd() },STR0142,STR0034}) //"Historico de Compras"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento p/ Nota Fiscal geradas no SIGAEIC            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !l103Inclui .And. SF1->F1_IMPORT == "S"
	If !lExcViaEIC .And. l103Exclui 
		Help( "", 1, "A103EXCIMP" )  // "Este documento nao pode ser excluido pois foi criado pelo SIGAEIC. A exclusao devera ser efetuada pelo SIGAEIC."
	Else
		A103NFEIC(cAlias,nReg,nOpcx)
	EndIf 	
	lContinua := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipo		:= IIf(l103Inclui,CriaVar("F1_TIPO",.F.),SF1->F1_TIPO)
cFormul		:= IIf(l103Inclui,CriaVar("F1_FORMUL",.F.),SF1->F1_FORMUL)
cNFiscal 	:= IIf(l103Inclui,CriaVar("F1_DOC"),SF1->F1_DOC)
cSerie		:= IIf(l103Inclui,CriaVar("F1_SERIE"),SF1->F1_SERIE)
dDEmissao	:= IIf(l103Inclui,CriaVar("F1_EMISSAO"),SF1->F1_EMISSAO)
cA100For	:= IIf(l103Inclui,CriaVar("F1_FORNECE",.F.),SF1->F1_FORNECE)
cLoja		:= IIf(l103Inclui,CriaVar("F1_LOJA",.F.),SF1->F1_LOJA)
cEspecie	:= IIf(l103Inclui,CriaVar("F1_ESPECIE"),SF1->F1_ESPECIE)
cCondicao	:= IIf(l103Inclui,CriaVar("F1_COND"),SF1->F1_COND)
cUfOrig     := IIf(l103Inclui,CriaVar("F1_EST"),SF1->F1_EST)

If l103Class
	dbSelectArea("SA2")
	dbSetOrder(1)
	If MsSeek(xFilial("SA2")+cA100For+cLoja)
		cCondicao  := SA2->A2_COND
	EndIf
	dbSelectArea("SF1")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as variaveis do pergunte                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("MTA103",.F.)
lDigita     := (mv_par01==1)
lAglutina   := (mv_par02==1)
lReajuste   := (mv_par04==1)
lAmarra     := (mv_par05==1)
lGeraLanc   := (mv_par06==1)
lConsLoja   := (mv_par07==1)
IsTriangular(mv_par08==1)
nTpRodape   := (mv_par09)
lPrecoDes   := (mv_par10==1)
lDataUcom   := (mv_par11==1)
lAtuAmarra  := (mv_par12==1)
If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Template acionando ponto de entrada                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTMt103NFE
		ExecTemplate("MT103NFE",.F.,.F.,nOpcx)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada no inicio do Documento de Entrada         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMt103NFE
		Execblock("MT103NFE",.F.,.F.,nOpcx)
	EndIf
	If l103Inclui .Or. l103Class
		If l103Class
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada na Classificacao da NF                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MT100CLA")
				ExecBlock("MT100CLA",.F.,.F.)
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Validacoes para Inclusao/Classificacao de NF de Entrada    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !NfeVldIni(l103Class,lGeraLanc)
			lContinua := .F.
		EndIf
	ElseIf l103Exclui
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ As Validacoes para Exclusao de NF de Entrada serao aplicadas³
		//³ somente quando a NFE nao esteja Bloqueada.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If SF1->F1_STATUS <> "B"
			If !MaCanDelF1(nRecSF1,@aRecSC5,aRecSE2,Nil,Nil,Nil,Nil,aRecSE1,lExcViaEIC,lExcViaTMS)
				lContinua := .F.
			EndIf
        EndIf
	EndIf
EndIf	
If lContinua
	If !l103Inclui .And. !l103Auto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa as veriaveis utilizadas na exibicao da NF         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		NfeCabOk(l103Visual)
	Else
		If !l103Inclui
			MaFisIni(SF1->F1_FORNECE,SF1->F1_LOJA,IIf(cTipo$'DB',"C","F"),cTipo,Nil,MaFisRelImp("MT100",{"SF1","SD1"}),,!l103Visual)
		EndIf
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type("aBackSD1")=="U" .Or. Empty(aBackSD1)

		aBackSD1 := {}

		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SD1")
		While !Eof() .And. (SX3->X3_ARQUIVO == "SD1")
			IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
				AADD(aBackSD1,{ TRIM(x3titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					Iif(Alltrim(SX3->X3_CAMPO) == "D1_ITEM",".T.",SX3->X3_VALID) ,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT})

			EndIf
			dbSelectArea("SX3")		
			dbSkip()
		EndDo
	EndIf
	aHeader := aBackSD1
	nUsado  := Len(aHeader)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do acols e arrays acessorios.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If l103Inclui
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a montagem de uma linha em branco no aCols.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aCols,Array(Len(aHeader)+1))
		For nY := 1 To Len(aHeader)
			If Trim(aHeader[nY][2]) == "D1_ITEM"
				aCols[1][nY] 	:= StrZero(1,Len(SD1->D1_ITEM))
			Else
				aCols[1][nY] := CriaVar(aHeader[nY][2])
			EndIf
			aCols[1][nUsado+1] := .F.
		Next nY
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Trava os registros do SF1 - Alteracao e Exclusao       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If l103Class .Or. l103Exclui
			If !SoftLock("SF1")
				lContinua := .F.
			EndIf
		EndIf
		If lContinua
			If l103Visual .Or. l103Exclui
				aadd(aTitles,(STR0034)) //"Historico"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega o Array contendo os Registros Fiscais.(SF3)     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SF3")
				dbSetOrder(4)
				#IFDEF TOP
					If TcSrvType()<>"AS/400"
						lQuery    := .T.
						cAliasSF3 := "A103NFISCAL"
						aStruSF3  := SF3->(dbStruct())

						cQuery    := "SELECT SF3.*,SF3.R_E_C_N_O_ SF3RECNO "
						cQuery    += "FROM "+RetSqlName("SF3")+" SF3 "
						cQuery    += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
						cQuery    += "SF3.F3_CLIEFOR='"+SF1->F1_FORNECE+"' AND "
						cQuery    += "SF3.F3_LOJA='"+SF1->F1_LOJA+"' AND "
						cQuery    += "SF3.F3_NFISCAL='"+SF1->F1_DOC+"' AND "
						cQuery    += "SF3.F3_SERIE='"+SF1->F1_SERIE+"' AND "
						cQuery    += "SF3.F3_FORMUL='"+SF1->F1_FORMUL+"' AND "
						cQuery    += "SF3.D_E_L_E_T_=' ' "
						cQuery    += "ORDER BY "+SqlOrder(SF3->(IndexKey()))

						cQuery := ChangeQuery(cQuery)

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)
						For nX := 1 To Len(aStruSF3)
							If aStruSF3[nX,2]<>"C"
								TcSetField(cAliasSF3,aStruSF3[nX,1],aStruSF3[nX,2],aStruSF3[nX,3],aStruSF3[nX,4])
							EndIf
						Next nX
					Else
				#ENDIF						
					MsSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)
					#IFDEF TOP
					EndIf
					#ENDIF
				While !Eof() .And. lContinua .And.;
						xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
						SF1->F1_FORNECE == (cAliasSF3)->F3_CLIEFOR .And.;
						SF1->F1_LOJA == (cAliasSF3)->F3_LOJA .And.;
						SF1->F1_DOC == (cAliasSF3)->F3_NFISCAL .And.;
						SF1->F1_SERIE == (cAliasSF3)->F3_SERIE
					If Substr((cAliasSF3)->F3_CFO,1,1) < "5" .And. (cAliasSF3)->F3_FORMUL == SF1->F1_FORMUL
						aadd(aRecSF3,If(lQuery,(cAliasSF3)->SF3RECNO,SF3->(RecNo())))
					EndIf
					dbSelectArea(cAliasSF3)
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSF3)
					dbCloseArea()
					dbSelectArea("SF3")
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta o Array contendo as registros do SDE           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SDE")
				dbSetOrder(1)		
				#IFDEF TOP
					If TcSrvType()<>"AS/400"
						lQuery    := .T.
						aStruSDE  := SDE->(dbStruct())
						cAliasSDE := "A103NFISCAL"
						cQuery    := "SELECT SDE.*,SDE.R_E_C_N_O_ SDERECNO "
						cQuery    += "FROM "+RetSqlName("SDE")+" SDE "
						cQuery    += "WHERE SDE.DE_FILIAL='"+xFilial("SDE")+"' AND "
						cQuery    += "SDE.DE_DOC='"+SF1->F1_DOC+"' AND "
						cQuery    += "SDE.DE_SERIE='"+SF1->F1_SERIE+"' AND "
						cQuery    += "SDE.DE_FORNECE='"+SF1->F1_FORNECE+"' AND "
						cQuery    += "SDE.DE_LOJA='"+SF1->F1_LOJA+"' AND "
						cQuery    += "SDE.D_E_L_E_T_=' ' "
						cQuery    += "ORDER BY "+SqlOrder(SDE->(IndexKey()))

						cQuery := ChangeQuery(cQuery)

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSDE,.T.,.T.)
						For nX := 1 To Len(aStruSDE)
							If aStruSDE[nX,2]<>"C"
								TcSetField(cAliasSDE,aStruSDE[nX,1],aStruSDE[nX,2],aStruSDE[nX,3],aStruSDE[nX,4])
							EndIf
						Next nX
					Else
				#ENDIF
					MsSeek(xFilial("SDE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
					#IFDEF TOP
					EndIf
					#ENDIF
				While ( !Eof() .And. lContinua .And.;
						xFilial('SDE') == (cAliasSDE)->DE_FILIAL .And.;
						SF1->F1_DOC == (cAliasSDE)->DE_DOC .And.;
						SF1->F1_SERIE == (cAliasSDE)->DE_SERIE .And.;
						SF1->F1_FORNECE == (cAliasSDE)->DE_FORNECE .And.;
						SF1->F1_LOJA == (cAliasSDE)->DE_LOJA )
					If Empty(aBackSDE)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Montagem do aHeader                                          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SX3")
						dbSetOrder(1)
						MsSeek("SDE")
						While ( !EOF() .And. SX3->X3_ARQUIVO == "SDE" )
							If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"DE_CUSTO"$SX3->X3_CAMPO
								nUsadoSDE++
								aadd(aBackSDE,{ TRIM(X3Titulo()),;
									SX3->X3_CAMPO,;
									SX3->X3_PICTURE,;
									SX3->X3_TAMANHO,;
									SX3->X3_DECIMAL,;
									SX3->X3_VALID,;
									SX3->X3_USADO,;
									SX3->X3_TIPO,;
									SX3->X3_ARQUIVO,;
									SX3->X3_CONTEXT })
							EndIf
							dbSelectArea("SX3")
							dbSkip()
						EndDo
					EndIf

               aHeadSDE  := aBackSDE
               nUsadoSDE := Len(aHeadSDE)				

					aadd(aRecSDE,If(lQuery,(cAliasSDE)->SDERECNO,SDE->(RecNo())))
					If cItemSDE <> 	(cAliasSDE)->DE_ITEMNF
						cItemSDE	:= (cAliasSDE)->DE_ITEMNF
						aadd(aColsSDE,{cItemSDE,{}})
						nItemSDE++
					EndIf
					aadd(aColsSDE[nItemSDE][2],Array(nUsadoSDE+1))

					For nY := 1 to Len(aHeadSDE)
						If ( aHeadSDE[nY][10] <> "V")
							aColsSDE[nItemSDE][2][Len(aColsSDE[nItemSDE][2])][nY] := (cAliasSDE)->(FieldGet(FieldPos(aHeadSDE[nY][2])))
						Else
							aColsSDE[nItemSDE][2][Len(aColsSDE[nItemSDE][2])][nY] := (cAliasSDE)->(CriaVar(aHeadSDE[nY][2]))
						EndIf
						aColsSDE[nItemSDE][2][Len(aColsSDE[nItemSDE][2])][nUsadoSDE+1] := .F.
					Next nY
					dbSelectArea(cAliasSDE)
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSDE)
					dbCloseArea()
					dbSelectArea("SDE")
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta o Array contendo as duplicatas SE2             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SF1->F1_TIPO$"DB"
					cPrefixo := PadR( cPrefixo, Len( SE1->E1_PREFIXO ) ) 
					dbSelectArea("SE1")
					dbSetOrder(2)
					MsSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DOC)
					While !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
							SF1->F1_FORNECE == SE1->E1_CLIENTE .And.;
							SF1->F1_LOJA == SE1->E1_LOJA .And.;
							cPrefixo == SE1->E1_PREFIXO .And.;
							SF1->F1_DOC == SE1->E1_NUM
						If (SE1->E1_TIPO $ MV_CRNEG)
							aadd(aRecSe1,SE1->(Recno()))
						EndIf
						dbSelectArea("SE1")
						dbSkip()
					EndDo
				Else
					If Empty(aRecSE2)
						cPrefixo := PadR( cPrefixo, Len( SE2->E2_PREFIXO ) )
						dbSelectArea("SE2")
						dbSetOrder(6)
						#IFDEF TOP
							If TcSrvType()<>"AS/400"
								lQuery    := .T.
								aStruSE2  := SE2->(dbStruct())
								cAliasSE2 := "A103NFISCAL"
								cQuery    := "SELECT SE2.*,SE2.R_E_C_N_O_ SE2RECNO "
								cQuery    += "FROM "+RetSqlName("SE2")+" SE2 "
								cQuery    += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
								cQuery    += "SE2.E2_FORNECE='"+SF1->F1_FORNECE+"' AND "
								cQuery    += "SE2.E2_LOJA='"+SF1->F1_LOJA+"' AND "
								cQuery    += "SE2.E2_PREFIXO='"+cPrefixo+"' AND "
								cQuery    += "SE2.E2_NUM='"+SF1->F1_DUPL+"' AND "
								cQuery    += "SE2.E2_TIPO='NF ' AND "
								cQuery    += "SE2.D_E_L_E_T_=' ' "
								cQuery    += "ORDER BY "+SqlOrder(SE2->(IndexKey()))

								cQuery := ChangeQuery(cQuery)

								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)
								For nX := 1 To Len(aStruSE2)
									If aStruSE2[nX][2]<>"C"
										TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
									EndIf
								Next nX
							Else
						#ENDIF
							MsSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+cPrefixo+SF1->F1_DUPL)
							#IFDEF TOP
							EndIf
							#ENDIF
						While ( !Eof() .And. lContinua .And.;
								xFilial("SE2") == (cAliasSE2)->E2_FILIAL .And.;
								SF1->F1_FORNECE == (cAliasSE2)->E2_FORNECE .And.;
								SF1->F1_LOJA == (cAliasSE2)->E2_LOJA .And.;
								cPrefixo == (cAliasSE2)->E2_PREFIXO .And.;
								SF1->F1_DUPL == (cAliasSE2)->E2_NUM )
							If (cAliasSE2)->E2_TIPO == "NF "
								aadd(aRecSE2,If(lQuery,(cAliasSE2)->SE2RECNO,(cAliasSE2)->(RecNo())))
							EndIf
							dbSelectArea(cAliasSE2)
							dbSkip()
						EndDo
						If lQuery
							dbSelectArea(cAliasSE2)
							dbCloseArea()
							dbSelectArea("SE2")
						EndIf
					EndIf
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a montagem do aCols com os dados do SD1                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD1")
			dbSetOrder(1)
			#IFDEF TOP
				If TcSrvType()<>"AS/400" .And. Ascan(aHeader,{|x| x[8] == "M" }) == 0
					lQuery    := .T.
					cAliasSD1 := "A103NFISCAL"
					cAliasSB1 := "A103NFISCAL"
					aStruSD1  := SD1->(dbStruct())
					cQuery    := "SELECT SD1.*,SD1.R_E_C_N_O_ SD1RECNO, B1_GRUPO,B1_CODITE,B1_TE,B1_COD "
					cQuery    += "FROM "+RetSqlName("SD1")+" SD1, "
					cQuery    += RetSqlName("SB1")+" SB1 "					
					cQuery    += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "
					cQuery    += "SD1.D1_DOC='"+SF1->F1_DOC+"' AND "
					cQuery    += "SD1.D1_SERIE='"+SF1->F1_SERIE+"' AND "
					cQuery    += "SD1.D1_FORNECE='"+SF1->F1_FORNECE+"' AND "
					cQuery    += "SD1.D1_LOJA='"+SF1->F1_LOJA+"' AND "
					cQuery    += "SD1.D1_TIPO='"+SF1->F1_TIPO+"' AND "
					cQuery    += "SD1.D_E_L_E_T_=' ' AND "
					cQuery    += "SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
					cQuery    += "SB1.B1_COD = SD1.D1_COD AND "					
					cQuery    += "SB1.D_E_L_E_T_=' ' " 					
					
					If (l103Class .And. lClassOrd) .Or. lNfeOrd
						cQuery    += "ORDER BY "+SqlOrder( "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD" ) 
					Else
						cQuery    += "ORDER BY "+SqlOrder(SD1->(IndexKey()))
					EndIf                  

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
					For nX := 1 To Len(aStruSD1)
						If aStruSD1[nX][2]<>"C"
							TcSetField(cAliasSD1,aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
						EndIf
					Next nX
				Else
			#ENDIF
				lQuery := .F.
				MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
				#IFDEF TOP
				EndIf
				#ENDIF
				
			bWhileSD1 := { || ( !Eof().And. lContinua .And. ;
					(cAliasSD1)->D1_FILIAL== xFilial("SD1") .And. ;
					(cAliasSD1)->D1_DOC == SF1->F1_DOC .And. ;
					(cAliasSD1)->D1_SERIE == SF1->F1_SERIE .And. ;
					(cAliasSD1)->D1_FORNECE == SF1->F1_FORNECE .And. ;
					(cAliasSD1)->D1_LOJA == SF1->F1_LOJA ) } 
				
			If !lQuery .And. ((l103Class .And. lClassOrd) .Or. lNfeOrd)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Este procedimento eh necessario para fazer a montagem        ³
				//³ do acols na ordem ITEM + COD quando classificacao em CDX     ³
				//³ e o parametro MV_CLASORD estiver ativado                     ³				
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aRecClasSD1 := {} 
				While ( !Eof().And. lContinua .And. ;
						(cAliasSD1)->D1_FILIAL== xFilial("SD1") .And. ;
						(cAliasSD1)->D1_DOC == SF1->F1_DOC .And. ;
						(cAliasSD1)->D1_SERIE == SF1->F1_SERIE .And. ;
						(cAliasSD1)->D1_FORNECE == SF1->F1_FORNECE .And. ;
						(cAliasSD1)->D1_LOJA == SF1->F1_LOJA )
	
						AAdd( aRecClasSD1, { ( cAliasSD1 )->D1_ITEM + ( cAliasSD1 )->D1_COD, ( cAliasSD1 )->( Recno() ) } ) 
			
					( cAliasSD1 )->( dbSkip() ) 
					
				EndDo 				
				
				ASort( aRecClasSD1, , , { |x,y| y[1] > x[1] } )
				
				bWhileSD1 := { || nCounterSD1 <= Len( aRecClasSD1 ) .And. lContinua  } 
				
				nCounterSD1 := 1 
			
			EndIf	
				
			While Eval( bWhileSD1 )
			
				If !lQuery .And. ((l103Class .And. lClassOrd).Or.lNfeOrd)
					SD1->( dbGoto( aRecClasSD1[ nCounterSD1, 2 ] ) ) 
				EndIf 			

				If !lQuery
					SB1->(MsSeek(xFilial("SB1")+(cAliasSD1)->D1_COD))					
				Endif						

				aadd(aRecSD1,If(lQuery,(cAliasSD1)->SD1RECNO,(cAliasSD1)->(RecNo())))

				aadd(aCols,Array(nUsado+1))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa a funcao fiscal                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaFisIniLoad(Len(aCols))
				For nX := 1 To Len(aAuxRefSD1)
					MaFisLoad(aAuxRefSD1[nX][2],(cAliasSD1)->(FieldGet(FieldPos(aAuxRefSD1[nX][1]))),Len(aCols))
				Next nX
				MaFisEndLoad(Len(aCols),2)				

				For nY := 1 To nUsado
					If ( aHeader[nY][10] <> "V")
						aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
						If l103Class .And. Alltrim(aHeader[ny][2]) == "D1_TES" .And. Empty(D1_TES)
							If !Empty(D1_TESACLA)
								aCols[Len(aCols)][ny] := D1_TESACLA
								MaFisAlt("IT_TES",D1_TESACLA,Len(aCols))
							Else
								aCols[Len(aCols)][ny] := RetFldProd((cAliasSB1)->B1_COD,"B1_TE",cAliasSB1)
							EndIf
						EndIf
					Else
						aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])

						Do Case
						Case Alltrim(aHeader[nY][2]) == "D1_CODITE"
							aCols[Len(aCols)][ny] := (cAliasSB1)->B1_CODITE
						Case Alltrim(aHeader[nY][2]) == "D1_CODGRP"
							aCols[Len(aCols)][ny] := (cAliasSB1)->B1_GRUPO
						EndCase		

					EndIf
					If Trim(aHeader[ny][2]) == "D1_TES"
						nPosTes := nY
					EndIf
					aCols[Len(aCols)][nUsado+1] := .F.
				Next nY
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza a condicao de pagamento com base no Pedido de compra³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( Empty(cCondicao) .And. !Empty((cAliasSD1)->D1_PEDIDO) )
					dbSelectArea("SC7")
					dbSetOrder(14)
					If MsSeek(xFilial()+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
						cCondicao := SC7->C7_COND
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza os dados do acols com base no Pedido de compra      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !Empty((cAliasSD1)->D1_PEDIDO) .And. l103Class)
					dbSelectArea("SC7")
					dbSetOrder(14)
					If MsSeek(xFilial()+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC)
						If Empty(SC7->C7_SEQUEN)
							NfePC2Acols(SC7->(RecNo()),Len(aCols),(cAliasSD1)->D1_QUANT,(cAliasSD1)->D1_ITEM,l103Class,@aRateio)
						EndIf
					EndIf
					MaFisAlt("IT_DESPESA",(cAliasSD1)->D1_DESPESA,Len(aCols))
					MaFisAlt("IT_SEGURO",(cAliasSD1)->D1_SEGURO,Len(aCols))
					MaFisAlt("IT_FRETE",(cAliasSD1)->D1_VALFRE,Len(aCols))					
				EndIf
				dbSelectArea(cAliasSD1)
				If l103Class .And. nPosTes > 0 .And. !Empty(aCols[Len(aCols),nPosTes])
					MaFisLoad("IT_TES","",Len(aCols))
					MaFisAlt("IT_TES",aCols[Len(aCols)][nPosTes],Len(aCols))
					MaFisToCols(aHeader,aCols,Len(aCols),"MT100")
					If ExistTrigger("D1_TES")
					   RunTrigger(2,Len(aCols),,"D1_TES")
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento especial para a Average                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If l103Class .And. Empty((cAliasSD1)->D1_TES)
					If (cAliasSD1)->D1_BASEIPI > 0
						MaFisAlt("IT_BASEIPI",(cAliasSD1)->D1_BASEIPI,Len(aCols))
						MaFisAlt("IT_ALIQIPI",(cAliasSD1)->D1_IPI,Len(aCols))
						MaFisAlt("IT_VALIPI",(cAliasSD1)->D1_VALIPI,Len(aCols))										
					EndIf                                        
					If (cAliasSD1)->D1_BASEICM > 0
						MaFisAlt("IT_BASEICM",(cAliasSD1)->D1_BASEICM,Len(aCols))
						MaFisAlt("IT_ALIQICM",(cAliasSD1)->D1_PICM,Len(aCols))
						MaFisAlt("IT_VALICM",(cAliasSD1)->D1_VALICM,Len(aCols))
					EndIf  
					
					If !Empty( cCpBasePIS ) .And. !Empty( cCpValPIS ) .And. !Empty( cCpAlqPIS )
						nBasePIS    := ( cAliasSD1 )->( FieldGet( (  cAliasSD1 )->( FieldPos( cCpBasePIS ) ) ) )  
						nValorPIS   := ( cAliasSD1 )->( FieldGet( (  cAliasSD1 )->( FieldPos( cCpValPIS ) ) ) )  
						nAliqPIS    := ( cAliasSD1 )->( FieldGet( (  cAliasSD1 )->( FieldPos( cCpAlqPIS ) ) ) )  
												
						If !Empty( nBasePIS ) 
							MaFisAlt("IT_BASEPS2", nBasePIS ,Len(aCols))
							MaFisAlt("IT_VALPS2" , nValorPIS,Len(aCols))
							MaFisAlt("IT_ALIQPS2" , nAliqPIS,Len(aCols))							
							
						EndIf 	
					EndIf

					If !Empty( cCpBaseCOF ) .And. !Empty( cCpValCOF ) .And. !Empty( cCpAlqCOF ) 
						nBaseCOF    := ( cAliasSD1 )->( FieldGet( (  cAliasSD1 )->( FieldPos( cCpBaseCOF ) ) ) )  
						nValorCOF   := ( cAliasSD1 )->( FieldGet( (  cAliasSD1 )->( FieldPos( cCpValCOF ) ) ) )  
						nAliqCOF    := ( cAliasSD1 )->( FieldGet( (  cAliasSD1 )->( FieldPos( cCpAlqCOF ) ) ) )  						
						If !Empty( nBaseCOF ) 
							MaFisAlt("IT_BASECF2", nBaseCOF ,Len(aCols))
							MaFisAlt("IT_VALCF2" , nValorCOF,Len(aCols))
							MaFisAlt("IT_ALIQCF2" , nAliqCOF ,Len(aCols))							
						EndIf 	
					EndIf					
					
					MaFisToCols(aHeader,aCols,Len(aCols),"MT100")					
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Integracao com o modulo de Transportes                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If IntTMS()
					dbSelectArea("SDG")
					dbSetOrder(7)
					If MsSeek(xFilial("SD1")+"SD1"+(cAliasSD1)->D1_NUMSEQ)
						If cItemSDG <> (cAliasSD1)->D1_ITEM
							cItemSDG	:= (cAliasSD1)->D1_ITEM  							
							If Empty(SDG->DG_CODVEI) .And. Empty(SDG->DG_VIAGEM) //Verifica se o Rateio foi por Veiculo/Viagem ou por Frota
								aadd(aRatFro,{cItemSDG,{},SDG->DG_CODDES})
								nItRatFro++
							Else
								aadd(aRatVei,{cItemSDG,{},SDG->DG_CODDES})
								nItRatVei++
							EndIf    						
						EndIf                             						
						Do While !Eof() .And. xFilial("SD1")+"SD1"+(cAliasSD1)->D1_NUMSEQ == DG_FILIAL+DG_ORIGEM+DG_SEQMOV
							If Empty(SDG->DG_CODVEI) .And. Empty(SDG->DG_VIAGEM) //Verifica se o Rateio foi por Veiculo/Viagem ou por Frota
								aadd(aRatFro[nItRatFro][2],{SDG->DG_ITEM, SDG->DG_TOTAL,.F.})
							Else
								If ( nPos := Ascan(aRatVei[nItRatVei][2], { |x| x[2] == SDG->DG_CODVEI } ) ) == 0
									aadd(aRatVei[nItRatVei][2],{SDG->DG_ITEM,SDG->DG_CODVEI, SDG->DG_FILORI, SDG->DG_VIAGEM, SDG->DG_TOTAL," ",0,0,.F.})
								EndIf
							EndIf   	
							dbSkip()
						EndDo
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua skip na area SD1 ( regra geral ) ou incrementa o contador ³
				//³ quando ordem por ITEM + CODIGO DE PRODUTO                        ³				
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lQuery .And. ((l103Class .And. lClassOrd).Or.lNfeOrd)
					nCounterSD1++
				Else					
					dbSelectArea(cAliasSD1)
					dbSkip()
				EndIf 	
			EndDo
			If lQuery
				dbSelectArea(cAliasSD1)
				dbCloseArea()
				dbSelectArea("SD1")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Compatibilizacao da Base X.07 p/ X.08       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(SF1->F1_RECBMTO) .And. !l103Class .And. !l103Visual
				MaFisAlt("NF_VALIRR",SF1->F1_IRRF,)
				MaFisAlt("NF_VALINS",SF1->F1_INSS,)
				MaFisAlt("NF_DESPESA",SF1->F1_DESPESA,)
				MaFisAlt("NF_FRETE",SF1->F1_FRETE,)
				MaFisAlt("NF_SEGURO",SF1->F1_SEGURO,)
			EndIf
			MaFisAlt("NF_FUNRURAL",SF1->F1_CONTSOC,)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Rateio do valores de Frete/Seguro/Despesa do PC            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aRateio[1] <> 0
				MaFisAlt("NF_SEGURO",aRateio[1])
			EndIf
			If aRateio[2] <> 0
				MaFisAlt("NF_DESPESA",aRateio[2])
			EndIf
			If aRateio[3] <> 0
				MaFisAlt("NF_FRETE",aRateio[3])
			EndIf
			If aRateio[1]+aRateio[2]+aRateio[3] <> 0
				MaFisToCols(aHeader,aCols,,"MT100")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta o Array contendo os Historico da NF                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aHistor := A103Histor(SF1->(RecNo()))
		EndIf
	EndIf	
	If l103Inclui .And. !l103Auto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PNEUAC - Ponto de Entrada definicao da Operacao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("MT103PN")
			If !Execblock("MT103PN",.F.,.F.,)
				lContinua := .F.
			EndIf
		EndIf
	EndIf
	If !l103Auto .And. !Len(aCols) > 0
		lContinua := .F.
		Help(" ",1,"RECNO")
	EndIf
	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³********************A T E N C A O ***************************³
		//³Quando for feita manutencao em alguma VALIDACAO dos GETs,    ³
		//³atualize as funcoes que se encontram no array aValidGet      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If ( l103Auto )
			If l103Inclui
				aValidGet := {}
				aVldBlock := {}
				aAdd(aVldBlock,{||NFeTipo(cTipo,@cA100For,@cLoja)})
				aAdd(aVldBlock,{||NfeFormul(cFormul,@cNFiscal,@cSerie)})
				aAdd(aVldBlock,{||NfeFornece(cTipo,@cA100For,@cLoja,,@nCombo,@oCombo,@cCodRet,@oCodRet).And.CheckSX3("F1_DOC")})
				aAdd(aVldBlock,{||NfeFornece(cTipo,@cA100For,@cLoja,,@nCombo,@oCombo,@cCodRet,@oCodRet).And.CheckSX3("F1_SERIE")})
				aAdd(aVldBlock,{||CheckSX3('F1_EMISSAO') .And. NfeEmissao(dDEmissao)})
				aAdd(aVldBlock,{||NfeFornece(cTipo,@cA100For,@cLoja,@cUfOrig,@nCombo,@oCombo,@cCodRet,@oCodRet).And.CheckSX3("F1_FORNECE",cA100For)})
				aAdd(aVldBlock,{||NfeFornece(cTipo,@cA100For,@cLoja,@cUfOrig,@nCombo,@oCombo,@cCodRet,@oCodRet).And.CheckSX3("F1_LOJA",cLoja)})
				aAdd(aVldBlock,{||CheckSX3('F1_ESPECIE',cEspecie)})
				aAdd(aVldBlock,{||CheckSX3('F1_EST',cUfOrig) .And. MaFisAlt( "NF_UFORIGEM", cUfOrig )})
				aAdd(aVldBlock,{||Vazio(cNatureza).Or.(ExistCpo('SED',cNatureza).And.NfeVldRef("NF_NATUREZA",cNatureza)) .And. If(lMt103Nat,ExecBlock("MT103NAT",.F.,.F.,cNatureza),.T.)})

				Aadd(aValidGet,{"cTipo"    ,aAutoCab[ProcH("F1_TIPO"),2],"Eval(aVldBlock[1])",.F.})
				Aadd(aValidGet,{"cFormul"  ,aAutoCab[ProcH("F1_FORMUL"),2],"Eval(aVldBlock[2])",.F.})
				Aadd(aValidGet,{"cNFiscal" ,aAutoCab[ProcH("F1_DOC"),2],"Eval(aVldBlock[3])",.F.})
				Aadd(aValidGet,{"cSerie"   ,aAutoCab[ProcH("F1_SERIE"),2],"Eval(aVldBlock[4])",.F.})
				Aadd(aValidGet,{"dDEmissao",aAutoCab[ProcH("F1_EMISSAO"),2],"Eval(aVldBlock[5])",.F.})
				Aadd(aValidGet,{"cA100For" ,aAutoCab[ProcH("F1_FORNECE"),2],"Eval(aVldBlock[6])",.F.})
				Aadd(aValidGet,{"cLoja"    ,aAutoCab[ProcH("F1_LOJA"),2],"Eval(aVldBlock[7])",.F.})
				Aadd(aValidGet,{"cEspecie" ,aAutoCab[ProcH("F1_ESPECIE"),2],"Eval(aVldBlock[8])",.F.})

				If !Empty( ProcH( "F1_EST" ) ) 
					Aadd(aValidGet,{"cUfOrig" ,aAutoCab[ProcH("F1_EST"),2],"Eval(aVldBlock[9])",.F.})
				EndIf 	
              
				If !lWhenGet
					nOpc := 1  	
				EndIf 
					
				If !SF1->(MsVldGAuto(aValidGet))
					nOpc := 0
				EndIf

				If ProcH("F1_COND") > 0
					cCondicao := aAutoCab[ProcH("F1_COND"),2]
				EndIf

				If ( nOpc == 1 .Or. lWhenGet ) .And. l103Inclui
					MaFisIni(cA100For,cLoja,IIf(cTipo$'DB',"C","F"),cTipo,Nil,MaFisRelImp("MT100",{"SF1","SD1"}),,.F.)
				EndIf
			Else
				nOpc := 1	
			EndIf
			If nOpc == 1 .Or. lWhenGet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o preenchimento do campo D1_ITEM                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cItem := StrZero(1,Len(SD1->D1_ITEM))
				For nX := 1 To Len(aAutoItens)
					nY := aScan(aAutoItens[nX],{|x| AllTrim(x[1])=="D1_ITEM"})
					If nY == 0
						aadd(aAutoItens[nX],{"D1_ITEM",cItem,Nil})
					EndIf
					cItem := Soma1(cItem)
				Next nX
				If !MsGetDAuto(aAutoItens,"A103LinOk",{|| A103TudOk()},aAutoCab,aRotina[nOpcx][4])
					If lWhenGet
						Aviso(STR0119,STR0157,{STR0148}, 2 ) 
						lProcGet := .F.
					Endif	
					nOpc := 0
				EndIf
				For nX := 1 to Len(aAutoImp)
					MaFisAlt(aAutoImp[nX][1],aAutoImp[nX][2])
				Next nX

				If ProcH("F1_COND") > 0
					cCondicao := aAutoCab[ProcH("F1_COND"),2]
				EndIf
				If ProcH("F1_DESPESA") > 0
					MaFisAlt("NF_DESPESA",aAutoCab[ProcH("F1_DESPESA"),2])
				EndIf
				If ProcH("F1_SEGURO") > 0
					MaFisAlt("NF_SEGURO",aAutoCab[ProcH("F1_SEGURO"),2])
				EndIf
				If ProcH("F1_FRETE") > 0
					MaFisAlt("NF_FRETE",aAutoCab[ProcH("F1_FRETE"),2])
				EndIf
				If ProcH("F1_BASEICM") > 0
					MaFisAlt("NF_BASEICM",aAutoCab[ProcH("F1_BASEICM"),2])
				EndIf
				If ProcH("F1_VALICM") > 0
					MaFisAlt("NF_VALICM",aAutoCab[ProcH("F1_VALICM"),2])
				EndIf
				If ProcH("F1_BASEIPI") > 0
					MaFisAlt("NF_BASEIPI",aAutoCab[ProcH("F1_BASEIPI"),2])
				EndIf
				If ProcH("F1_VALIPI") > 0
					MaFisAlt("NF_VALIPI",aAutoCab[ProcH("F1_VALIPI"),2])
				EndIf
				If ProcH("F1_BRICMS") > 0
					MaFisAlt("NF_BASESOL",aAutoCab[ProcH("F1_BRICMS"),2])
				EndIf
				If ProcH("F1_ICMSRET") > 0
					MaFisAlt("NF_VALSOL",aAutoCab[ProcH("F1_ICMSRET"),2])
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ajusta os dados de acordo com a nota fiscal original         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lWhenGet                 
					Ascan(aAutoItens,{|X| !Empty( nPosRec := Ascan(  x, { |Y| Alltrim( y[1] ) == "D1RECNO"}))} ) 
					If nPosRec > 0
						For nX := 1 to Len(aAutoItens)
							nPosRec := Ascan(aAutoItens[nX], { |y| Alltrim( y[1] ) == "D1RECNO"})						
							MaFisAlt("IT_RECORI",aAutoItens[nX,nPosRec,2],nX)
							MaFisAlt("NF_UFORIGEM",SF2->F2_EST)						
						Next
						MaFisToCols(aHeader,aCols,Len(aCols),'MT100')						
					Endif	
				Endif	

				If !Empty( ProcH( "E2_NATUREZ" ))
					cNatureza := aAutoCab[ProcH("E2_NATUREZ"),2]
					Eval(aVldBlock[10])
				EndIf

				If nOpc == 1 .Or. lWhenGet
					NfeFldFin(,l103Visual,aRecSE2,0,aRecSE1,@aHeadSE2,@aColsSE2,@aHeadSEV,@aColsSEV,@aFldCbAtu[6],NIL,@cModRetPIS,lPccBaixa)					
					Eval(aFldCbAtu[6])
					Eval(bRefresh,6,6)
				EndIf
			EndIf
			If lWhenGet
				l103Auto := .F.
			EndIf		
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da Tela da Nota fiscal de entrada                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (!l103Auto .Or. lWhenGet) .And. lProcGet		
			aObjects 	:= {}
			aSizeAut	:= MsAdvSize(,.F.,400)
			AAdd( aObjects, { 0,    41, .T., .F. } )
			AAdd( aObjects, { 100, 100, .T., .T. } )
			AAdd( aObjects, { 0,    75, .T., .F. } )

			aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }

			aPosObj := MsObjSize( aInfo, aObjects )
			aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
				{{8,35,78,128,163,200,250,270},;
				{8,35,75,108,150,174,227,260,286},;
				{5,70,160,205,295},;
				{6,34,200,215},;
				{6,34,75,103,148,164,230,253},;
				{6,34,200,218,280},;
				{11,50,150,190},;
				{273,130,190,293,205}})

			DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(STR0009) Of oMainWnd PIXEL //"Documento de Entrada"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Objeto criado para receber o foco quando pressionado o botao confirma ³
			//³ da dialog. Usado para identificar quando foi pressionado o botao      ³
			//³ confirma, atraves do parametro passado ao lostfocus                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ 100000,100000 MSGET oFoco103 VAR cVarFoco SIZE 12,09 PIXEL OF oDlg 
			oFoco103:Cargo := {.T.,.T.}
			oFoco103:Disable()			
			
			NfeCabDoc(oDlg,{aPosGet[1],aPosGet[2],aPosObj[1]},@bCabOk,l103Class.Or.l103Visual,NIL,cUfOrig,l103Class,,@nCombo,@oCombo,@cCodRet,@oCodRet)

			oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,'A103LinOk','A103TudOk','+D1_ITEM',!l103Visual,,,,IIf(l103Class,Len(aCols),999),,,,IIf(l103Class,'AllwaysFalse()',"NfeDelItem"))
			oGetDados:oBrowse:bGotFocus	:= bCabOk

			oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,aPages,oDlg,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
			oFolder:bSetOption := {|nDst| NfeFldChg(nDst,oFolder:nOption,oFolder,aFldCBAtu)}
			bRefresh := {|nX| NfeFldChg(nX,oFolder:nOption,oFolder,aFldCBAtu)}

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder dos Totalizadores                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[1]:oFont := oDlg:oFont
			NfeFldTot(oFolder:aDialogs[1],a103Var,aPosGet[3],@aFldCBAtu[1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder dos Fornecedores                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[2]:oFont := oDlg:oFont
			NfeFldFor(oFolder:aDialogs[2],aInfForn,{aPosGet[4],aPosGet[5],aPosGet[6]},@aFldCBAtu[2])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder das Despesas acessorias e descontos                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[3]:oFont := oDlg:oFont
			NfeFldDsp(oFolder:aDialogs[3],a103Var,{aPosGet[7],aPosGet[8]},@aFldCBAtu[3])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder dos Livros Fiscais                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[4]:oFont := oDlg:oFont	
			oLivro := MaFisBrwLivro(oFolder:aDialogs[4],{5,4,( aPosObj[3,4]-aPosObj[3,2] ) - 10,53},.T.,IIf(!l103Class,aRecSF3,Nil))
			aFldCBAtu[4] := {|| oLivro:Refresh()}
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder dos Impostos                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFolder:aDialogs[5]:oFont := oDlg:oFont	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder do Financeiro                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			oFolder:aDialogs[6]:oFont := oDlg:oFont			
			NfeFldFin(oFolder:aDialogs[6],l103Visual,aRecSE2,( aPosObj[3,4]-aPosObj[3,2] ) - 101,aRecSe1,@aHeadSE2,@aColsSE2,@aHeadSEV,@aColsSEV,@aFldCbAtu[6],NIL,@cModRetPIS,lPccBaixa)			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ As Notas incluidas pelo MATA100 nao terao o rodape da MATXFIS ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l103Visual .And. Empty(SF1->F1_RECBMTO)
				A103Rodape(oFolder:aDialogs[5])
			Else
				MaFisRodape(nTpRodape,oFolder:aDialogs[5],,{5,4,( aPosObj[3,4]-aPosObj[3,2] )-10,53},@bIPRefresh,l103Visual,@cFornIss,@cLojaIss,aRecSE2,@cDirf,@cCodRet,@oCodRet,@nCombo,@oCombo)				
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Folder dos historicos do Documento de entrada                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l103Visual
				oFolder:aDialogs[7]:oFont := oDlg:oFont
				@ 05,04 LISTBOX oHistor VAR cHistor ITEMS aHistor PIXEL SIZE ( aPosObj[3,4]-aPosObj[3,2] )-10,53 Of oFolder:aDialogs[7]
				Eval(bRefresh,oFolder:nOption)
			EndIf
			
			If lWhenGet .Or. l103Class
				Eval(bRefresh,oFolder:nOption)
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Transfere o foco para a getdados - nao retirar                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oFoco103:bGotFocus := { || oGetDados:oBrowse:SetFocus() }			

    		aButControl := {{ |x,y| aColsSEV := aClone( x ), aHeadSEV := aClone( y ) }, aColsSev,aHeadSEV }
					
			ACTIVATE MSDIALOG oDlg ON INIT (IIf(lWhenGet,oGetDados:oBrowse:Refresh(),Nil),;
			A103Bar(oDlg,{|| oFoco103:Enable(),oFoco103:SetFocus(),oFoco103:Disable(), IIf(((!l103Inclui.And.!l103Class).Or.( Eval(bRefresh,6) .And. NfeTotFin(aHeadSE2,aColsSE2,.F.).And.oGetDados:TudoOk())).And. oFoco103:Cargo[1] .And. NfeVldSEV(oFoco103:Cargo[2]) .And. NfeNextDoc(@cNFiscal,@cSerie,l103Inclui).And.A103TmsVld(l103Exclui),(nOpc:=1,oDlg:End()),Eval({||nOpc:=0,oFoco103:Cargo[1] :=.T.}))},;
			{||nOpc:=0,oDlg:End()},IIf(l103Inclui.Or.l103Class,aButtons,aButVisual),aButControl))

		EndIf

		If nOpc == 1 .And. (l103Inclui.Or.l103Class.Or.l103Exclui)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoIniLan("000054")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa a gravacao atraves nas funcoes MATXFIS         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisWrite(1)
			If A103Trava()

				#IFNDEF TOP 
				               
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Indregua para o PIS / COFINS / CSLL                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock( "MT103FRT" )
						aFil10925 := ExecBlock( "MT103FRT", .F., .F. ) 
					Else 
						aFil10925 := { xFilial( "SE2" ) }  				     
					EndIf				
					
					cIndex := CriaTrab(,.f.)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Carrega as filiais no filtro                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					cCond := "("                                    
					For nLoop := 1 to Len( aFil10925 ) 
						cCond  += "E2_FILIAL='" + aFil10925[ nLoop ] + "' .OR. "
					Next nLoop 						                                
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Retira o .OR. do final                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cCond  := Left( cCond, Len( cCond ) - 5 ) 
					
					cCond  += ") .AND. " 
					cCond  += "E2_FORNECE='"     + cA100For           + "' .AND. " 	
					cCond  += "E2_LOJA='"        + cLoja              + "'"
				
					IndRegua("SE2",cIndex,"DTOS(E2_VENCREA)",, cCond,OemToAnsi(""))	
					nIndexSE2 := RetIndex("SE2")+1 
				
					dbSetIndex(cIndex+OrdBagExt())
				
				#ENDIF			
				Begin Transaction
					a103Grava(l103Exclui,lGeraLanc,lDigita,lAglutina,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,nRecSF1,aRecSD1,aRecSE2,aRecSF3,aRecSC5,aHeadSDE,aColsSDE,aRecSDE,.F.,.F.,,aRatVei,aRatFro,cFornIss,cLojaIss,A103TemBlq(l103Class), l103Class,cDirf,cCodRet,cModRetPIS,nIndexSE2)
				End Transaction
    
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Apaga o arquivo da Indregua                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				#IFNDEF TOP				
					RetIndex( "SE2" )  
					FErase( cIndex+OrdBagExt() ) 
				#ENDIF		
				
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoFinLan("000054")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Template acionando ponto de entrada                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistTemplate("MT100AGR")
				ExecTemplate("MT100AGR",.F.,.F.)
			EndIf			
			If ExistBlock("MT100AGR")
				ExecBlock("MT100AGR",.F.,.F.)
			EndIf			
		EndIf
	EndIf
EndIf
MaFisEnd()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Destrava os registros na alteracao e exclusao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l103Class .Or. l103Exclui
	MsUnlockAll()
EndIf
If !l103Auto
	SetKey(VK_F4,Nil)
	SetKey(VK_F5,Nil)
	SetKey(VK_F6,Nil)
	SetKey(VK_F7,Nil)
	SetKey(VK_F8,Nil)
	SetKey(VK_F9,Nil)
	SetKey(VK_F10,Nil)
	SetKey(VK_F11,Nil)	
	SetKey(VK_F12,bKeyF12)
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna ao valor original de maxcodes ( utilizado por MayiUseCode() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetMaxCodes( nMaxCodes ) 

Return .T.

Static Function ProcH(cCampo)
Return aScan(aAutoCab,{|x|Trim(x[1])== cCampo })

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A103NFEic ³ Autor ³ Edson Maricate       ³ Data ³24.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Class/Visualizacao/Exclusao de NF SIGAEIC      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103NFEic(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103NFEic(cAlias,nReg,nOpcx)

dbSelectArea("SD1")
dbSetOrder(1)
MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a funcao utilizada ( Class/Visual/Exclusao)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
Case aRotina[nOpcx][4] == 2
	MATA100(,,2)
Case aRotina[nOpcx][4] == 4
	MATA100(,,4)
Case aRotina[nOpcx][4] == 5
	MATA100(,,5)
EndCase
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103TudOk ³ Autor ³ Edson Maricate        ³ Data ³08.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da TudoOk                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103Tudok()

Local lRet    := .T.
Local nX      := 0
Local nPosTes := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosCfo := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})
Local nPosPc  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPosItPc:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
Local nPosQtd := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
Local nPosVlr := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
Local nPosOp  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})
Local nItens  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o preenchimaneto da tes dos itens devido a importacao do pedido de compras ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nItens := 0
For nx:=1 to len(aCols)
	If !aCols[nx][Len(aCols[nx])]
		nItens ++
		If Empty(aCols[nx][nPosCFO]) .Or. Empty(aCols[nx][nPosTES])
			Help("  ",1,"A100VZ")
			lRet := .F.
			Exit
		Endif
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ha empenho da OP e dispara o Alerta para continuar. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to len(aCols)
	If !aCols[nx][Len(aCols[nx])]
		If lRet .And. !Empty(aCols[nx][nPosOp])
			lRet := A103ValSD4(nx)
		EndIf
	EndIf
Next 	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impede a inclusao de documentos sem nenhum item ativo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nItens == 0
	Help("  ",1,"A100VZ")
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o preenchimento dos campos.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(ca100For) .Or. Empty(dDEmissao) .Or. Empty(cTipo) .Or. (Empty(cNFiscal).And.cFormul<>"S")
	Help(" ",1,"A100FALTA")
	lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a condicao de pagamento.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_BASEDUP") > 0 .And. Empty(cCondicao) .And. cTipo<>"D"
	Help("  ",1,"A100COND")
	If ( Type("l103Auto") == "U" .Or. !l103Auto )
		oFolder:nOption := 6
	EndIf
	lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a natureza                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_BASEDUP") > 0 .And. Empty(MaFisRet(,"NF_NATUREZA")) .And. cTipo<>"D"
	If SuperGetMV("MV_NFENAT")
		Help("  ",1,"A103NATURE")
		If ( Type("l103Auto") == "U" .Or. !l103Auto )
			oFolder:nOption := 6
		EndIf
		lRet := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o total da NF esta negativo devido ao valor do desconto |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MaFisRet(,"NF_TOTAL")<0  .Or. (MaFisRet(,"NF_BASEDUP")>0 .And. MaFisRet(,"NF_BASEDUP")-MaFisRet(,"NF_VALIRR")-MaFisRet(,"NF_VALINS")-MaFisRet(,"NF_VALISS")<0)
	Help("  ",1,'TOTAL')
	lRet := .F.		
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
//³             MV_SIGAGSP - 0-Nao / 1-Integra                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
	lRet := GSPF030()
	If !lRet
		Return lRet		
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
//³ Pontos de Entrada 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
If (ExistTemplate("MT100TOK"))
	lRet := ExecTemplate("MT100TOK",.F.,.F.,{lRet})
EndIf
If (ExistBlock("MT100TOK"))
	lRet := ExecBlock("MT100TOK",.F.,.F.,{lRet})
EndIf

Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103LinOk  ³ Autor ³ Edson Maricate       ³ Data ³24.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de validacao da LinhaOk                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103LinOk()

Local aArea		 := GetArea()
Local aAreaSD2	 := SD2->(GetArea())
Local aAreaSF4	 := SF4->(GetArea())
Local aAreaSB6	 := SB6->(GetArea())
Local aSldSB6    := {}
Local lRet		 := .F.
Local nX         := 0
Local nPosCod    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local nPosLocal  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})
Local nPosPC     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPosQuant  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
Local nPosVUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
Local nPosTotal  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"})
Local nPValDesc  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VALDESC"})
Local nPosTes    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosCfo    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})
Local nPosItemPC := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
Local nPosOp     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})
Local nPosIdentB6:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_IDENTB6"})
Local nPosNFOri  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"})
Local nPosItmOri := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMORI"})
Local nPosSerOri := aScan(aHeader,{|x| AllTrim(x[2])=="D1_SERIORI"})
Local nPosLote   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NUMLOTE"})
Local nPosLoteCtl:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOTECTL"})
Local nPosConta  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CONTA"})
Local nPosCC     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"})
Local nPosCLVL   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLVL"})
Local nPosItemCTA:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMCTA"})
Local nQtdPoder3 := 0
Local nSldPoder3 := 0
Local nSldQtdDev := 0
Local nSldVlrDev := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica preenchimento dos campos da linha do acols      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CheckCols(n,aCols)
	SF4->(dbSetOrder(1))
	If !aCols[n][Len(aCols[n])]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o produto est  sendo inventariado.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
		Case BlqInvent(aCols[n][nPosCod],aCols[n][nPosLocal])
			Help(" ",1,"BLQINVENT",,aCols[n][nPosCod]+STR0058+aCols[n][nPosLocal],1,11) //" Almox: "
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica os campos obrigatorios                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case Empty(aCols[n][nPosCod]) .Or. ;
				(Empty(aCols[n][nPosQuant]).And.cTipo$"NDB".And.!MaTesSel(aCols[n,nPosTes])).Or. ;
				Empty(aCols[n][nPosVUnit]) .Or. ;
				Empty(aCols[n][nPosTotal]).Or. ;
				Empty(aCols[n][nPosCFO])  .Or. ;
				Empty(aCols[n][nPosLocal]).Or. ;
				Empty(aCols[n][nPosTES])
			Help("  ",1,"A100VZ")
			lRet := .F.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o codigo da TES                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case aCols[n][nPosTes] > "500"
			Help("   ",1,"A100INVTES")
			lRet := .F.		
		Case !SF4->(MsSeek(xFilial("SF4")+aCols[n][nPostes]))
			Help("   ",1,"D1_TES")
			lRet := .F.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o Pedido de compra                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case !Empty(aCols[n][nPosPc]) .And. Empty(aCols[n][nPosItemPC])
			Help("  ",1,"A100PC")
			lRet := .F.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o valor total                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case cPaisLoc <> "BRA".AND.cTipo <> "C" .And.!MaTesSel(aCols[n,nPosTes]) .And. ;
				Round(aCols[n][nPosVUnit]*aCols[n][nPosQuant],SuperGetMV("MV_RNDLOC")) <> Round(aCols[n][nPosTotal],SuperGetMV("MV_RNDLOC"))
			Help(" ",1,"A100VALOR")
			lRet := .F.		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o preenchimento da Nota Original           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case cTipo == 'D' .And. cPaisLoc <> "ARG" .And. Empty(aCols[n][nPosNFOri])
			Help("  ",1,"A100NFORI")
			lRet := .F.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica a Ratreabilidade                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case SF4->F4_ESTOQUE == "S" .And. cTipo == 'D' .And. (Rastro(aCols[n][nPosCod],"S")) .And. Empty(aCols[n][nPosLote])
			Help(" ",1,"A100S/LOT")
			lRet := .F.
		Case SF4->F4_ESTOQUE == "S" .And. cTipo == 'D' .And. (Rastro(aCols[n][nPosCod],"L")) .And. Empty(aCols[n][nPosLoteCtl])
			Help(" ",1,"A100S/LOT")
			lRet := .F.		
		Case ( !Empty(aCols[n][nPosOp]).And.(!ExistCpo("SC2",aCols[n][nPosOp],1) .or. !Empty(SC2->C2_DATRF)))
			Help(" ",1,"A100OPEND")
			lRet := .F.		
		Case cTipo $'CPI' .And. Empty(aCols[n][nPosNFOri])
			Help(" ",1,"A100COMPIP")
			lRet := .F.		
		Case SF4->F4_PODER3 == 'D' .And. Empty(aCols[n][nPosIdentB6])
			Help(" ",1,"A100USARF4")
			lRet := .F.		
		Case SF4->F4_ATUATF == 'S' .And. SF4->F4_BENSATF == "1" .And. INT(aCols[n][nPosQuant]) <> aCols[n][nPosQuant]
			Help(" ",1,"A103BENATF")
			lRet := .F.		
		Case SF4->F4_ESTOQUE == 'S' .And. !A103Alert(Acols[n][nPosCod],aCols[n][nPosLocal],( Type('l103Auto') <> 'U' .And. l103Auto ))
			lRet := .F.
		Case cTipo$'NDB' .And. !MaTesSel(aCols[n,nPosTes]) .And. (aCols[n][nPosTotal]>(aCols[n][nPosVUnit]*aCols[n][nPosQuant]+0.49);
				.Or. aCols[n][nPosTotal]<(aCols[n][nPosVUnit]*aCols[n][nPosQuant]-0.49))
			Help("  ",1,'TOTAL')
			lRet := .F.		

		Case MaTesSel(aCols[n,nPosTes]) .And. aCols[n][nPosQuant] > 0
			Help("  ",1,'TOTAL')
			lRet := .F.
		Case !CtbAmarra(aCols[n,nPosConta],aCols[n,nPosCC],aCols[n,nPosItemCTA],aCols[n,nPosCLVL])
			lRet := .F.	
		OtherWise
			lRet := .T.
		EndCase

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a quantidade e o valor devolvido                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. cTipo=="D" .And. !Empty(aCols[n][nPosNFOri])
			dbSelectArea("SD2")
			dbSetOrder(3)
			If MsSeek(xFilial("SD2")+aCols[n][nPosNFOri]+aCols[n][nPosSerOri]+cA100For+cLoja+aCols[n][nPosCod]+aCols[n][nPosItmOri])
				nSldQtdDev := SD2->D2_QUANT-SD2->D2_QTDEDEV
				nSldVlrDev := SD2->D2_TOTAL+SD2->D2_DESCON+SD2->D2_DESCZFR-SD2->D2_VALDEV
				For nX := 1 to Len(aCols)
					If !aCols[nX][Len(aCols[nX])] .And.;
							aCols[nX][nPosCod]    == SD2->D2_COD   .And. ;
							aCols[nX][nPosNfOri]  == SD2->D2_DOC   .And. ;
							aCols[nX][nPosSerOri] == SD2->D2_SERIE .And. ;
							aCols[nX][nPosItmOri] == SD2->D2_ITEM
						If n <> nX
							nSldQtdDev -= aCols[nX][nPosQuant]
							nSldVlrDev -= aCols[nX][nPosTotal]
						EndIf
					EndIf
				Next nX
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o valor devolvido                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aCols[n][nPosTotal] > nSldVlrDev
					Help(" ",1,"A410UNIDIF")
					lRet := .F.
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a quantidade                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SD2->D2_QTDEDEV == SD2->D2_QUANT  .And. SD2->D2_QUANT<>0
					lRet := .F.
					Help(" ",1,"A100QDEV")
				Else
					If aCols[n][nPosQuant] > nSldQtdDev
						lRet := .F.
						Help(" ",1,"A100DEVPAR",,Str(nSldQtdDev,18,2),4,1)
					EndIf
				EndIf
			Else
				If !Empty(aCols[n][nPosItmOri])
					lRet := .F.
					Help(" ",1,"A100QDEV")
				EndIf
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o poder de terceiro                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. SF4->F4_PODER3 == 'D'
			For nX := 1 to Len(aCols)
				If 	aCols[nX][nPosNfOri]  == aCols[n][nPosNfOri]  .And. ;
						aCols[nX][nPosSerOri] == aCols[n][nPosSerOri] .And. ;
						aCols[nX][nPosIdentB6] == aCols[n][nPosIdentB6]  .And. ;
						!aCols[nX][Len(aCols[nX])]  
					nQtdPoder3 += aCols[nX][nPosQuant]
					nSldPoder3 += aCols[nX][nPosTotal]-aCols[nX][nPValDesc]
				EndIf
			Next nX
			aSldSB6 := CalcTerc(aCols[n][nPosCod],cA100For,cLoja,aCols[n][nPosIdentB6],aCols[n][nPosTES],cTipo)
			If nQtdPoder3 > aSldSB6[1]
				Help(" ",1,"A100N/PD3")
				lRet := .F.
			ElseIf A410Arred(nSldPoder3,"D1_TOTAL") > a410Arred(aSldSB6[3]*aSldSB6[1],"D1_TOTAL")+0.01
				Help(" ",1,"A100VALOR")
				lRet := .F.
			EndIf
		EndIf           
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impede que dois identificadores sejam carregados ao mesmo tempo ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. !GDDeleted() 
			If !Empty( aCols[ n, nPosIdentB6 ] )
				lRet := MayIUseCode( "SD1_D1_IDENTB6" + aCols[ n, nPosIdentB6 ] )
			EndIf 	
			
			If !lRet                    
				Help( " ", 1, "A103P3SIM" ) // "O identificador de poder de terceiros utilizado ja esta em uso por outra estacao.Selecione outro item de NF original."
			EndIf			
		EndIf 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as validacoes do WMS                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			lRet := A103WMSOk()
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ha empenho da OP                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. !Empty(aCols[n][nPosOp])
		 	lRet := A103ValSD4(n)
        EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as validacoes da integracao com o QIE           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. Localiza(aCols[n][nPosCod])
			dbSelectArea("SB1")
			dbSetOrder(1)
			If MsSeek(xFilial()+aCols[n][nPosCod]) .And. SB1->B1_TIPOCQ == 'Q' .And. !(SuperGetMV('MV_CQ') $ SuperGetMV('MV_DISTAUT'))	
				Help(" ",1,"A103CQUALY")
				lRet:=.F. 	
			EndIf
	 	EndIf
		
	 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se Produto x Fornecedor foi Bloquedo pela Qualidade.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .and. !(cTipo$'DB')
			lRet := QieSitFornec(cA100For,cLoja,aCols[n][nPosCod],.T.)
		EndIf
		
	Else
		lRet := .T.
	EndIf
 	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Analisa os pontos de entrada                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If lRet .And. (ExistTemplate("MT100LOK"))
		lRet := ExecTemplate("MT100LOK",.F.,.F.,{lRet})
	EndIf
	If lRet .And. (ExistBlock("MT100LOK"))
		lRet := ExecBlock("MT100LOK",.F.,.F.,{lRet})
	EndIf
EndIf
RestArea(aAreaSF4)
RestArea(aAreaSB6)
RestArea(aAreaSD2)
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A103F4   ³ Autor ³ Edson Maricate        ³ Data ³26.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz a consulta aos pedidos de compra em aberto.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103F4()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103F4()
Local cVariavel	:= ReadVar()
Local bKeyF4	:=  SetKey( VK_F4 )
Local lContinua := .T.

SetKey( VK_F4,Nil )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	Do Case
	Case cVariavel == "M->D1_OP" .And. cTipo $ 'NIPBC'
		A103ShowOp()
	Case SF1->F1_IMPORT=="S"
		A103NBMItens(oGet)
	EndCase

Endif
SetKey( VK_F4,bKeyF4 )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ForF4 ³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de importacao de Pedidos de Compra.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Pedido()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function A103ForF4(lUsaFiscal)

Local nSldPed    := 0
Local nOpc       := 0
Local nx         := 0
Local cQuery     := ""
Local cAliasSC7  := "SC7"
Local lQuery     := .F.
Local bSavSetKey := SetKey(VK_F4,Nil)
Local bSavKeyF5  := SetKey(VK_F5,Nil)
Local bSavKeyF6  := SetKey(VK_F6,Nil)
Local bSavKeyF7  := SetKey(VK_F7,Nil)
Local bSavKeyF8  := SetKey(VK_F8,Nil)
Local bSavKeyF9  := SetKey(VK_F9,Nil)
Local bSavKeyF10 := SetKey(VK_F10,Nil)
Local bSavKeyF11 := SetKey(VK_F11,Nil)
Local bWhile
Local cChave     := ""
Local cCadastro  := ""
Local aArea      := GetArea()
Local aAreaSA2   := SA2->(GetArea())
Local aAreaSC7   := SC7->(GetArea())
Local aStruSC7   := SC7->(dbStruct())
Local aF4For     := {}
Local nF4For     := 0
Local oOk        := LoadBitMap(GetResources(), "LBOK")
Local oNo        := LoadBitMap(GetResources(), "LBNO")
Local aButtons   := { {'PESQUISA',{||A103VisuPC(aRecSC7[oListBox:nAt])},OemToAnsi(STR0059),OemToAnsi(STR0061)} } //"Visualiza Pedido"
Local oDlg,oListBox
Local cNomeFor   := ''
Local aRecSC7    := {}
Local aTitCampos := {}
Local aConteudos := {}
Local aUsCont    := {}
Local aUsTitu    := {}
Local bLine      := { || .T. }
Local cLine      := ""
Local lMa103F4I  := ExistBlock( "MA103F4I" )
Local nLoop      := 0
Local lMt103Vpc  := ExistBlock("MT103VPC")
Local lRet103Vpc := .T.
Local lContinua  := .T.

DEFAULT lUsaFiscal := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	If MaFisFound("NF") .Or. !lUsaFiscal
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o aCols esta vazio, se o Tipo da Nota e'     ³
		//³ normal e se a rotina foi disparada pelo campo correto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipo == "N"
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial()+cA100For+cLoja)
			cNomeFor	:= SA2->A2_NOME

			#IFDEF TOP

				dbSelectArea("SC7")
				If TcSrvType() <> "AS/400"
					SC7->( dbSetOrder( 9 ) ) 				
					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery := "SELECT SC7.*, R_E_C_N_O_ RECSC7 FROM "
					cQuery += RetSqlName("SC7") + " SC7 "
					cQuery += "WHERE "
					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "
					cQuery += "C7_FORNECE = '"+cA100For+"' AND "		    		
					cQuery += "(C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND "					
					If ( lConsLoja )		    		
						cQuery += "C7_LOJA = '"+cLoja+"' AND "		    							
					Endif						

					cQuery += "SC7.D_E_L_E_T_ = ' '"
					cQuery += "ORDER BY " + SqlOrder( SC7->( IndexKey() ) ) 					

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

					For nX := 1 To Len(aStruSC7)
						If aStruSC7[nX,2]<>"C"
							TcSetField(cAliasSC7,aStruSC7[nX,1],aStruSC7[nX,2],aStruSC7[nX,3],aStruSC7[nX,4])
						EndIf
					Next nX

					bWhile := {|| (cAliasSC7)->(!Eof())}

				Else
			#ENDIF

				dbSelectArea("SC7")
				dbSetOrder(9)
				If ( lConsLoja )
					cChave := cA100For+CLOJA
				Else
					cChave := cA100For
				EndIf
				MsSeek(xFilEnt(xFilial())+cChave,.T.)

				bWhile := {|| (cAliasSC7)->(!Eof()) .And. xFilEnt(xFilial()) == (cAliasSC7)->C7_FILENT .And. ;
					cA100For == (cAliasSC7)->C7_FORNECE .And. ;
					IIf(lConsLoja,CLOJA==(cAliasSC7)->C7_LOJA,.T.)}

				#IFDEF TOP
				Endif
				#ENDIF


			While Eval(bWhile)

				lRet103Vpc := .T.

				If lMt103Vpc
					lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
				Endif

				If lRet103Vpc
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o Saldo do Pedido de Compra                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSldPed := (cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se nao h  residuos, se possui saldo em abto e   ³
					//³ se esta liberado por alcadas se houver controle.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( Empty((cAliasSC7)->C7_RESIDUO) .And. nSldPed > 0 .And.;
							IIf(SuperGetMV("MV_RESTNFE")=="S",(cAliasSC7)->C7_CONAPRO <> "B",.T.).And.;
							(cAliasSC7)->C7_TPOP <> "P" )
						nF4For := aScan(aF4For,{|x|x[2]==(cAliasSC7)->C7_LOJA .And. x[3]==(cAliasSC7)->C7_NUM})
						If ( nF4For == 0 )

							aConteudos := {.F.,(cAliasSC7)->C7_LOJA,(cAliasSC7)->C7_NUM,DTOC((cAliasSC7)->C7_EMISSAO),IIF((cAliasSC7)->C7_TIPO==2,"AE","PC") }

							If lMa103F4I
								If ValType( aUsCont := ExecBlock( "MA103F4I", .F., .F. ) ) == "A"
									AEval( aUsCont, { |x| AAdd( aConteudos, x ) } )
								EndIf
							EndIf

							aadd(aF4For, aConteudos )
							aAdd(aRecSC7,Iif(lQuery,(cAliasSC7)->RECSC7,RecNo()))
						EndIf
					EndIf
				Endif

				(cAliasSC7)->(dbSkip())
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os dados na Tela                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( !Empty(aF4For) )

				aTitCampos := {" ",OemToAnsi(STR0060),OemToAnsi(STR0061),OemToAnsi(STR0039),OemToAnsi(STR0062)} //"Loja"###"Pedido"###"Emissao"###"Origem"

				cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5]"

				If ExistBlock( "MA103F4H" )
					If ValType( aUsTitu := ExecBlock( "MA103F4H", .F., .F. ) ) == "A"
						For nLoop := 1 To Len( aUsTitu )
							AAdd( aTitCampos, aUsTitu[ nLoop ] )
							cLine += ",aF4For[oListBox:nAT][" + AllTrim( Str( nLoop + 5 ) ) + "]"
						Next nLoop
					EndIf
				EndIf

				cLine += " } "

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta dinamicamente o bline do CodeBlock                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				bLine := &( "{ || " + cLine + " }" )


				DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi(STR0024+" - <F5> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

				oListBox := TWBrowse():New( 27,4,243,86,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
				oListBox:SetArray(aF4For)
				oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
				oListBox:bLine := bLine

				@ 15  ,4   SAY OemToAnsi(STR0028) Of oDlg PIXEL SIZE 47 ,9 //"Fornecedor"
				@ 14  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oDlg PIXEL SIZE 120,9

				ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)

                Processa({|| a103procPC(aF4For,nOpc,cA100For,cLoja,@lRet103Vpc,@lMt103Vpc,@nSldPed,lUsaFiscal)})

			Else
				Help(" ",1,"A103F4")
			EndIf
		Else
			Help('   ',1,'A103TIPON')
		EndIf
	Else
		Help('   ',1,'A103CAB')
	EndIf

Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integrida dos dados de Entrada                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	dbSelectArea(cAliasSC7)
	dbCloseArea()
	dbSelectArea("SC7")
Endif
SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)

RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ProcPC| Autor ³ Alex Lemes            ³ Data ³09/06/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa o carregamento do pedido de compras para a NFE    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os itens do pedido de compras            ³±±
±±³          ³ ExpN1 = Opcao valida                                       ³±±
±±³          ³ ExpC1 = Fornecedor                                         ³±±
±±³          ³ ExpC2 = loja fornecedor                                    ³±±
±±³          ³ ExpL1 = retorno do ponto de entrada                        ³±±
±±³          ³ ExpL2 = Uso do ponto de entrada                            ³±±
±±³          ³ ExpN2 = Saldo do pedido                                    ³±±
±±³          ³ ExpL3 = Usa funcao fiscal                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a103procPC(aF4For,nOpc,cA100For,cLoja,lRet103Vpc,lMt103Vpc,nSldPed,lUsaFiscal)

Local nx           := 0
Local cSeek        := ""
Local cItem		   := StrZero(1,Len(SD1->D1_ITEM))
Local lZeraCols	   := .T.

DEFAULT lUsaFiscal := .T.

If ( nOpc == 1 )
	For nx	:= 1 to Len(aF4For)
		If aF4For[nx][1]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona Fornecedor                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial()+cA100For+cLoja)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona Pedido de Compra                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC7")
			dbSetOrder(9)
			cSeek := ""
			cSeek += xFilEnt(xFilial())+cA100For
			cSeek += aF4For[nx][2]+aF4For[nx][3]
			MsSeek(cSeek)
			If lZeraCols
				aCols		:= {}
				lZeraCols	:= .F.
				MaFisClear()
			EndIf
			
			dbSelectArea("SC7")
			dbSetOrder(14)
			
			While ( !Eof() .And. SC7->C7_FILENT+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM==;
				cSeek )
				
				lRet103Vpc := .T.
				
				If lMt103Vpc
					lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
				Endif
				
				If lRet103Vpc
					nSldPed := SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA
					If (nSldPed > 0 .And. Empty(SC7->C7_RESIDUO) )
						NfePC2Acols(SC7->(RecNo()),,nSlDPed,cItem)
						cItem := SomaIt(cItem)
					EndIf
				Endif
				
				dbSelectArea("SC7")
				dbSkip()
			EndDo
		EndIf
	Next
	If lUsaFiscal
       Eval(bRefresh)
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ItemPC³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tela de importacao de Pedidos de Compra por Item.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103ItemPC()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103ItemPC(lUsaFiscal,aPedido,oGetDAtu)

Local cSeek      := ""
Local nOpca      := 0
Local aArea      := GetArea()
Local aAreaSA2	  := SA2->(GetArea())
Local aAreaSC7	  := SC7->(GetArea())
Local aAreaSB1	  := SB1->(GetArea())
Local aStruSC7   := SC7->(dbStruct())
Local aCab       := {}
Local aCampos    := {}
Local aNew       := {}
Local aArrSldo	  := {}
Local aArrayF4	  := {}
Local aTamCab     := {}
Local aButtons	  := { {'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},OemToAnsi(STR0059),OemToAnsi(STR0061)},; //"Visualiza Pedido"
	{'DBG10',{||A103PesqP(aCab,aCampos,aArrayF4,oQual)},OemToAnsi(STR0001)} } //"Pesquisar"
Local bSavSetKey  := SetKey(VK_F4,Nil)
Local bSavKeyF5   := SetKey(VK_F5,Nil)
Local bSavKeyF6   := SetKey(VK_F6,Nil)
Local bSavKeyF7   := SetKey(VK_F7,Nil)
Local bSavKeyF8   := SetKey(VK_F8,Nil)
Local bSavKeyF9   := SetKey(VK_F9,Nil)
Local bSavKeyF10  := SetKey(VK_F10,Nil)
Local bSavKeyF11  := SetKey(VK_F11,Nil)
Local nFreeQt     := 0
Local nPosPRD     := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
Local nPosPDD     := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO" })
Local nPosITM     := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC" })
Local nPosQTD     := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
Local cVar        := aCols[n][nPosPrd]
Local cQuery      := ""
Local cAliasSC7   := "SC7"
Local cCpoObri    := ""
Local nSavQual
Local nPed        := 0
Local nX          := 0
Local nAuxCNT     := 0
Local lMt103Vpc   :=ExistBlock("MT103VPC")
Local lMt100C7D   := ExistBlock("MT100C7D")
Local lMt100C7C   := ExistBlock("MT100C7C")
Local lRet103Vpc  := .T.
Local lContinua   := .T.
Local lQuery      := .F.
Local oQual
Local oDlg
Local bWhile
DEFAULT lUsaFiscal:= .T.
DEFAULT aPedido	  := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	If MaFisFound('NF') .Or. !lUsaFiscal
		If cTipo == 'N'
			#IFDEF TOP

				dbSelectArea("SC7")
				If TcSrvType() <> "AS/400"

					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery := "SELECT SC7.*, R_E_C_N_O_ RECSC7 FROM "
					cQuery += RetSqlName("SC7") + " SC7 "
					cQuery += "WHERE "
					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "

					If Empty(cVar)
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
						Endif	
					Else
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Endif
					Endif

					cQuery += "SC7.D_E_L_E_T_ = ' '"

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

					For nX := 1 To Len(aStruSC7)
						If aStruSC7[nX,2]<>"C"
							TcSetField(cAliasSC7,aStruSC7[nX,1],aStruSC7[nX,2],aStruSC7[nX,3],aStruSC7[nX,4])
						EndIf
					Next nX


					bWhile := {|| (cAliasSC7)->(!Eof())}

				Else
			#ENDIF			

				If Empty(cVar)
					dbSelectArea("SC7")
					dbSetOrder(9)
					If lConsLoja
						cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
						cSeek := cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_FORNECE"
						cSeek := cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				Else
					dbSelectArea("SC7")
					dbSetOrder(6)
					If lConsLoja
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"						
						cSeek := cVar+cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"							
						cSeek := cVar+cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				EndIf

				bWhile := {|| (cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond)}

				#IFDEF TOP
				EndIf
				#ENDIF

			If Empty(cVar)
				cCpoObri := "C7_LOJA|C7_PRODUTO|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Else
				cCpoObri := "C7_LOJA|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Endif				

			If (cAliasSC7)->(!Eof())

				dbSelectArea("SX3")
				dbSetOrder(2)
				MsSeek("C7_NUM")

				AAdd(aCab,x3Titulo())
				Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
				aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

				dbSelectArea("SX3")
				dbSetOrder(1)
				MsSeek("SC7")
				While !Eof() .And. SX3->X3_ARQUIVO == "SC7"
					IF ( SX3->X3_BROWSE=="S".And.X3Uso(SX3->X3_USADO).And. AllTrim(SX3->X3_CAMPO)<>"C7_PRODUTO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_NUM").Or.;
							(AllTrim(SX3->X3_CAMPO) $ cCpoObri)
						AAdd(aCab,x3Titulo())
						Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
						aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
					EndIf
					dbSkip()		
				Enddo					


				dbSelectArea(cAliasSC7)				
				While Eval(bWhile)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os Pedidos Bloqueados e Previstos.                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO == "B") .Or. (cAliasSC7)->C7_TPOP == "P"
						dbSkip()
						Loop
					EndIf

					If Empty((cAliasSC7)->C7_RESIDUO)
						nFreeQT := 0
						nPed    := aScan(aPedido,{|x| x[1] = C7_NUM+C7_ITEM})

						nFreeQT -= If(nPed>0,aPedido[nPed,2],0)

						For nAuxCNT := 1 To Len( aCols )
							If (nAuxCNT # n) .And. ;
									(aCols[ nAuxCNT,nPosPRD ] == (cAliasSC7)->C7_PRODUTO) .And. ;
									(aCols[ nAuxCNT,nPosPDD ] == (cAliasSC7)->C7_NUM) .And. ;
									(aCols[ nAuxCNT,nPosITM ] == (cAliasSC7)->C7_ITEM) .And. ;
									!ATail( aCols[ nAuxCNT ] )
								nFreeQT += aCols[ nAuxCNT,nPosQTD ]
							EndIf
						Next

						lRet103Vpc := .T.

						If lMt103Vpc
							lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
						Endif

						If lRet103Vpc
							If ((nFreeQT := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA-nFreeQT)) > 0)
								Aadd(aArrayF4,Array(Len(aCampos)))							
								For nX := 1 to Len(aCampos)

									If aCampos[nX][3] != "V"
										If aCampos[nX][2] == "N"
											If Alltrim(aCampos[nX][1]) == "C7_QUANT"
												aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,PesqPict("SC7",aCampos[nX][1]))
											Else
												aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
											Endif											
										Else
											aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))								
										Endif	
									Else
										aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
										If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
											SB1->(dbSetOrder(1))
											SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))
											aArrayF4[Len(aArrayF4)][nX] := SB1->B1_GRUPO                            									
										EndIf
										If Alltrim(aCampos[nX][1]) == "C7_CODITE"
											SB1->(dbSetOrder(1))
											SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))
											aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
										EndIf
									Endif

								Next

								AAdd( aArrSldo,{nFreeQT,Iif(lQuery,(cAliasSC7)->RECSC7,RecNo())} )
								If lMT100C7D
									aNew := ExecBlock("MT100C7D", .f., .f., aArrayF4[Len(aArrayF4)])
									If ValType(aNew) = "A"
										aArrayF4[Len(aArrayF4)] := aNew
									EndIf
								EndIf
							EndIf
						Endif
					EndIf
					(cAliasSC7)->(dbSkip())
				EndDo

				If !Empty(aArrayF4)

					DEFINE MSDIALOG oDlg FROM 30,20  TO 265,521 TITLE OemToAnsi(STR0025+" - <F6> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra ( por item )"

					If lMT100C7C
						aNew := ExecBlock("MT100C7C", .f., .f., aCab)
						If ValType(aNew) == "A"
							aCab := aNew
						EndIf
					EndIf

					oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oQual:SetArray(aArrayF4)
					oQual:bLine := { || aArrayF4[oQual:nAT] }
					OQual:nFreeze := 1

					If !Empty(cVar)
						@ 16  ,4   SAY OemToAnsi(STR0063) Of oDlg PIXEL SIZE 47 ,9 //"Produto"
						@ 15  ,30  MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oDlg PIXEL SIZE 80,9
					Else
						@ 16  ,4   SAY OemToAnsi(STR0064) Of oDlg PIXEL SIZE 120 ,9 //"Selecione o Pedido de Compra"
					EndIf


					ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nSavQual:=oQual:nAT,nOpca:=1,oDlg:End()},{||oDlg:End()},,aButtons)

					If nOpca == 1
						dbSelectArea("SC7")
						MsGoto(aArrSldo[nSavQual][2])
						NfePC2Acols(aArrSldo[nSavQual][2],n,aArrSldo[nSavQual][1])

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas. ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ValType( oGetDAtu ) == "O" 
							oGetDAtu:lNewLine := .F. 
						Else 
							If Type( "oGetDados" ) == "O" 	
								oGetDados:lNewLine:=.F.
							EndIf 	
						EndIf 
					EndIf
					If lUsaFiscal
						Eval(bRefresh)
					EndIf
				Else
					Help(" ",1,"A103F4")
				EndIf
			Else
				Help(" ",1,"A103F4")
			EndIf
		Else
			Help('   ',1,'A103TIPON')
		EndIf
	Else
		Help('   ',1,'A103CAB')
	EndIf

Endif

If lQuery
	dbSelectArea(cAliasSC7)
	dbCloseArea()
	dbSelectArea("SC7")
Endif	

SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aAreaSB1)
RestArea(aArea)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³a103PesqP ³ Autor ³ Henry Fila            ³ Data ³17.07.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Seek no browse de itens de pedidos de compra                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1 : Array das descricoes dos cabecalhos                  ³±±
±±³          ³ExpA2 : Array com os campos                                  ³±±
±±³          ³ExpA3 : Array com os conteudos                               ³±±
±±³          ³ExpO4 : Objeto do listbox                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo abrir uma janela de pesquisa   ³±±
±±³          ³em browses de getdados poisicionando na llinha caso encontre ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function a103PesqP(aCab,aCampos,aArrayF4,oQual)

Local aCpoBusca := {}
Local aCpoPict  := {}    
Local aComboBox := { AllTrim( STR0168 ) , AllTrim( STR0169 ) , AllTrim( STR0170 ) } //"Exata"###"Parcial"###"Contem"

Local bAscan		:= { || .F. }

Local cPesq   := Space(30)
Local cBusca  := ""
Local cTitulo := OemtoAnsi(STR0001)  //"Pesquisar"
Local cOpcAsc   := aComboBox[1]	//"Exata"
Local cAscan    := ""

Local nOpca   := 0
Local nPos    := 0
Local nx      := 0
Local nTipo   := 1
Local nBusca  := Iif(oQual:nAt == Len(aArrayF4) .Or. oQual:nAt == 1, oQual:nAt, oQual:nAt+1 )

Local oDlg
Local oBusca
Local oPesq1
Local oPesq2
Local oPesq3
Local oPesq4
Local oComboBox

For nX := 1 to Len(aCampos)
	AAdd(aCpoBusca,aCab[nX])
	AAdd(aCpoPict,aCampos[nX][4])
Next	

If Len(aCampos) > 0 .And. Len(aArrayF4) > 0

	DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo)  FROM 00,0 TO 100,490 OF oMainWnd PIXEL

	@ 05,05 MSCOMBOBOX oBusca VAR cBusca ITEMS aCpoBusca SIZE 206, 36 OF oDlg PIXEL ON CHANGE (nTipo := oBusca:nAt,A103ChgPic(nTipo,aCampos,@cPesq,@oPesq1,@oPesq2,@oPesq3,@oPesq4))

	@ 022,005 MSGET oPesq1 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

	@ 022,005 MSGET oPesq2 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

	@ 022,005 MSGET oPesq3 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

	@ 022,005 MSGET oPesq4 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

	oPesq1:Hide()
	oPesq2:Hide()
	oPesq3:Hide()	
	oPesq4:Hide()		

	Do Case
	Case aCampos[1][2] == "C"

		dbSelectArea("SX3")
		dbSetOrder(2)
		If MsSeek(aCampos[1][1])
			If !Empty(SX3->X3_F3)
				oPesq2:cF3 := SX3->X3_F3
				oPesq1:Hide()				
				oPesq2:Show()				
				oPesq3:Hide()
				oPesq4:Hide()
			Else	
				oPesq1:Show()			
				oPesq2:Hide()
				oPesq3:Hide()				
				oPesq4:Hide()				
			Endif
		Endif		

	Case aCampos[1][2] == "D"
		oPesq1:Hide()
		oPesq2:Hide()				
		oPesq3:Show()
		oPesq4:Hide()						
	Case aCampos[1][2] == "N"
		oPesq1:Hide()
		oPesq2:Hide()				
		oPesq3:Hide()
		oPesq4:Show()						
	EndCase

	cPesq := CriaVar(aCampos[1][1],.F.)
	cPict := aCampos[1][4]

	DEFINE SBUTTON oBut1 FROM 05, 215 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE of oDlg		 	
	DEFINE SBUTTON oBut1 FROM 20, 215 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg		

	@ 037,005 SAY OemtoAnsi(STR0035) SIZE 050,10 OF oDlg PIXEL //Tipo
	@ 037,030 MSCOMBOBOX oComboBox VAR cOpcAsc ITEMS aComboBox SIZE 050,10 OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpca == 1

		Do Case

		Case aCampos[nTipo][2] == "C"
			IF ( cOpcAsc == aComboBox[1] )	//Exata
				cAscan := Padr( Upper( cPesq ) , TamSx3(aCampos[nTipo][1])[1] )
				bAscan := { |x| cAscan == Upper( x[ nTipo ] ) }
			ElseIF ( cOpcAsc == aComboBox[2] )	//Parcial
				cAscan := Upper( AllTrim( cPesq ) )
				bAscan := { |x| cAscan == Upper( SubStr( Alltrim( x[nTipo] ) , 1 , Len( cAscan ) ) ) }
			ElseIF ( cOpcAsc == aComboBox[3] )	//Contem
				cAscan := Upper( AllTrim( cPesq ) )
				bAscan := { |x| cAscan $ Upper( Alltrim( x[nTipo] ) ) }
			EndIF
		
			nPos := Ascan( aArrayF4 , bAscan )
		Case aCampos[nTipo][2] == "N"		
			nPos := Ascan(aArrayF4,{|x| Transform(cPesq,PesqPict("SC7",aCampos[nTipo][1])) == x[nTipo]},nBusca)	
		Case aCampos[nTipo][2] == "D"
			nPos := Ascan(aArrayF4,{|x| Dtos(cPesq) == Dtos(x[nTipo])},nBusca)
		EndCase

		If nPos > 0
			oQual:bLine := { || aArrayF4[oQual:nAT] }
			oQual:nFreeze := 1
			oQual:nAt := nPos                		
			oQual:Refresh()
			oQual:SetFocus()
		Else
			Help(" ",1,"REGNOIS")	
		Endif	

	EndIf

Endif

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³a103ChgPic³ Autor ³ Henry Fila            ³ Data ³17.07.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Atualiza picture na funcao a103PespP                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 : Posicao do campo no Array                            ³±±
±±³          ³ExpA2 : Array com os dados dos campos                        ³±±
±±³          ³ExpX3 : Pesquisa                                             ³±±
±±³          ³ExpO4 : Objeto de pesquisa                                   ³±±
±±³          ³ExpO5 : Objeto de pesquisa                                   ³±±
±±³          ³ExpO6 : Objeto de pesquisa                                   ³±±
±±³          ³ExpO7 : Objeto de pesquisa                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo tratar a picture do campo sele ³±±
±±³          ³cionado na funcao GdSeek                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A103ChgPic(nTipo,aCampos,cPesq,oPesq1,oPesq2,oPesq3,oPesq4)

Local cPict   := ""
Local aArea   := GetArea()
Local aAreaSX3:= SX3->(GetArea())
Local bRefresh


dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek(aCampos[nTipo][1])

	Do case

	Case aCampos[nTipo][2] == "C"
		If !Empty(SX3->X3_F3)
			oPesq2:cF3 := SX3->X3_F3
			oPesq1:Hide()
			oPesq2:Show()			
			oPesq3:Hide()
			oPesq4:Hide()			
			bRefresh := { || oPesq2:oGet:Picture := cPict,oPesq2:Refresh() }
		Else	
			oPesq1:Show()
			oPesq2:Hide()
			oPesq3:Hide()			
			oPesq4:Hide()			                                     			
			bRefresh := { || oPesq1:oGet:Picture := cPict,oPesq1:Refresh() }		
		Endif

	Case aCampos[nTipo][2] == "D"
		oPesq1:Hide()
		oPesq2:Hide()
		oPesq3:Show()			
		oPesq4:Hide()			                                                    		
		bRefresh := { || oPesq3:oGet:Picture := cPict,oPesq3:Refresh() }				
	Case aCampos[nTipo][2] == "N"
		oPesq1:Hide()
		oPesq2:Hide()
		oPesq3:Hide()
		oPesq4:Show()
		bRefresh := { || oPesq4:oGet:Picture := cPict,oPesq4:Refresh() }				
	EndCase

Endif		

If nTipo > 0
	cPesq := CriaVar(aCampos[nTipo][1],.F.)
	cPict := aCampos[nTipo][4]
EndIf							

Eval(bRefresh)

RestArea(aAreaSX3)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A103GrvAtf³ Autor ³ Edson Maricate        ³ Data ³ 06.01.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravacao do Ativo Fixo                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nOpc    : 1 - Inclusao / 2 - Exclusao                       ³±±
±±³          ³cBase   : Codigo Base do Ativo                              ³±±
±±³          ³cItem   : Item da Nota Fiscal                               ³±±
±±³          ³cCodCiap: Codigo do Ciap Gerado                             ³±±
±±³          ³nVlrCiap: Valor do Ciap Gerado                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Este Programa grava um ativo por item de NF, alterando-se o ³±±
±±³          ³Item do ativo. Nem todos os dados do Ativo serao gravados   ³±±
±±³          ³pois nao ha todas as informacoes na nota fiscal e o classi- ³±±
±±³          ³dor da Nota Fiscal nao tem condicoes de faze-lo.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103GrvAtf(nOpc,cBase,cItem,cCodCiap,nVlrCiap)

Local aArea	   := { Alias() , IndexOrd() , RecNo() }
Local aSavaHead:= aClone(aHeader)
Local aSavaCols:= aClone(aCols)
Local nUsado   := 0
Local nCntFor  := 0
Local nVlRatF  := 0
Local lGravou  := .F.
Local lAtuSX6  := .F.
Local lIncAnt  := .F. 
Local nMoeda   := iif(cPaisLoc == "BRA",1,SF1->F1_MOEDA)
Local nAtfQtdIt:= iif(SF4->(FieldPos("F4_BENSATF")) > 0,iif(SF4->F4_BENSATF == "1",SD1->D1_QUANT,1),1)    
Local bValAtf  := { || &( GetNewPar( "MV_VLRATF", '(SD1->D1_TOTAL-SD1->D1_VALDESC)+If(SF4->F4_CREDIPI=="S",0,SD1->D1_VALIPI)-IIf(SF4->F4_CREDICM=="S",SD1->D1_VALICM,0)' ) ) } 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³A rotina a seguir e uma protecao devido a falha no dicionario padrao    ³
//³onde a expressao cadastrada no parametro MV_VLRATF foi cadastrada com   ³
//³Aspas, isso faz com que a macro do codblock retorne uma string.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nVlRatF := Eval( bValAtf )
If ValType(nVlRatF) <> "N"
   nVlRatF := (SD1->D1_TOTAL-SD1->D1_VALDESC)+If(SF4->F4_CREDIPI=="S",0,SD1->D1_VALIPI)-IIf(SF4->F4_CREDICM=="S",SD1->D1_VALICM,0)               
EndIf

If nOpc == 1
	PRIVATE uCampo	:= ""
	PRIVATE aHeader:= {}
	PRIVATE aCols	:= {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o Codigo Base do Ativo                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( Empty(cBase) )
		GetMV("MV_CBASEAF")
		If ( RecLock("SX6") )
			cBase := &(GetMV("MV_CBASEAF"))
			If ( AllTrim(cBase) $ GetMV("MV_CBASEAF") )
				lAtuSX6 := .T.
			EndIf
		EndIf
		dbSelectArea("SN1")
		dbSetOrder(1)
		While MsSeek(xFilial("SN1")+cBase)
			cBase := Soma1(cBase,Len(SN1->N1_CBASE))
		EndDo
		If ( lAtuSX6 )
			PutMV("MV_CBASEAF",'"'+Soma1(cBase,Len(SN1->N1_CBASE))+'"')
		EndIf
		SX6->(MsUnLock())
	EndIf
	If ( !Empty(cBase) ) //.And. !Empty(SD1->D1_CONTA) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa as Variaveis do SN1                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SN1")
		While ( !Eof() .And. SX3->X3_ARQUIVO == "SN1" )
			uCampo := SX3->X3_CAMPO
			M->&(uCampo) := CriaVar(SX3->X3_CAMPO,IIF(SX3->X3_CONTEXT=="V",.F.,.T.))
			dbSelectArea("SX3")
			dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa o aHeader do SN3                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SN3")
		While ( !Eof() .And. SX3->X3_ARQUIVO == "SN3" )
			If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
				Aadd(aHeader ,{ Trim(X3TITULO()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
				nUsado++
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Registros Necessarios                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1")+SD1->D1_COD)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa o aCols                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aCols,Array(nUsado+1))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Preenchimento das Variaveis referentes ao SN1                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->N1_CBASE		:= cBase
		M->N1_ITEM		:= cItem
		M->N1_AQUISIC	:= SD1->D1_DTDIGIT
		M->N1_DESCRIC	:= SB1->B1_DESC
		M->N1_QUANTD	:= SD1->D1_QUANT / nAtfQtdIt
		M->N1_FORNEC	:= SD1->D1_FORNECE
		M->N1_LOJA		:= SD1->D1_LOJA
		M->N1_NSERIE	:= SD1->D1_SERIE
		M->N1_NFISCAL	:= SD1->D1_DOC
		M->N1_CHASSI	:= SD1->D1_CHASSI
		M->N1_PLACA		:= SD1->D1_PLACA
		M->N1_PATRIM	:= "N"
		M->N1_CODCIAP	:= cCodCiap
		M->N1_ICMSAPR	:= nVlrCiap / nAtfQtdIt

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Preenchimento das Variaveis referentes ao SN3                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To nUsado
			Do Case
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_TIPO" )
				aCols[1][nCntFor] := "01"
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_BAIXA" )
				aCols[1][nCntFor] := "0"
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_CCONTAB" )
				aCols[1][nCntFor] := "" // SD1->D1_CONTA
				// Nao grava este campo em hipotese alguma
				// pois o controle de classificacao do Ativo
				// eh feito por este campo
				// Wagner Xavier e Eduardo Riera
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_CCUSTO" )		// Centro de Custo
				aCols[1][nCntFor] := SD1->D1_CC
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_SUBCCON" )		// Item Contabil
				aCols[1][nCntFor] := SD1->D1_ITEMCTA
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_CLVLCON" )		// Classe de Valor
				aCols[1][nCntFor] := SD1->D1_CLVL
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_VORIG1" )
				aCols[1][nCntFor] := xMoeda( nVlRatF,nMoeda,1,SD1->D1_EMISSAO) / nAtfQtdIt 
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_VORIG2" )
				aCols[1][nCntFor] := xMoeda( nVlRatF,nMoeda,2,SD1->D1_EMISSAO) / nAtfQtdIt
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_VORIG3" )
				aCols[1][nCntFor] := xMoeda( nVlRatF,nMoeda,3,SD1->D1_EMISSAO) / nAtfQtdIt
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_VORIG4" )
				aCols[1][nCntFor] := xMoeda( nVlRatF,nMoeda,4,SD1->D1_EMISSAO) / nAtfQtdIt
			Case ( AllTrim(aHeader[nCntFor][2]) == "N3_VORIG5" )
				aCols[1][nCntFor] := xMoeda( nVlRatF,nMoeda,5,SD1->D1_EMISSAO) / nAtfQtdIt
			OtherWise
				aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2],IIF(SX3->X3_CONTEXT=="V",.F.,.T.))
			EndCase
		Next nCntFor
		aCols[1][nUsado+1] := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa as Variaveis Privates utilizadas pela funcao af010Grava      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lCopia		:= .F.
		lContabiliza:= .F.
		lHeader		:= .F.
		lTrailler	:= .F.
		lCProva		:= .F.
		Inclui      := .T.

		dbSelectArea("SN1")
		Pergunte("AFA010",.F.)
		lGravou := Af010Grava("SN1","SN3",.F.,.T.,.F.)
		If ( lGravou )
			RecLock("SD1")
			SD1->D1_CBASEAF := cBase
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna ao Estado de Entrada                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader	:= aClone(aSavaHead)
	aCols		:= aClone(aSavaCols)
	Pergunte("MTA103",.F.)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deleta a integracao com o ativo Fixo.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( !Empty(cBase) )
		dbSelectArea("SN1")
		dbSetOrder(1)
		If ( MsSeek(xFilial("SN1")+AllTrim(cBase)))
			Af010DelAtu("SN3")
		EndIf
	EndIf
EndIf

dbSelectArea(aArea[1])
dbSetOrder(aArea[2])
MsGoto(aArea[3])

Return(lGravou)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103GrvPV ³ Autor ³ Edson Maricate        ³ Data ³ 19.01.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Gravacao dos Pedidos de Venda                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103GrvPV()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a103GrvPV(nOpc,aPedPV,aRecSC5)

Local aArea     := { Alias() , IndexOrd() , Recno() }
Local aSavaCols := aClone(aCols)
Local aSavaHead := aClone(aHeader)
Local nMaxFor   := nCntFor := 0
Local nMaxFor1  := nCntFor1:= 0
Local nPos1     := 0
Local nUsado    := 0
Local nItSC6    := 0
Local nAcols    := 0
Local lContinua := .F.
Local lPedido   := .F.
Local nParcTp9  := SuperGetMV("MV_NUMPARC")
Local nSaveSX8  := GetSX8Len()
Local cCampo    := ""
Local bCampo    := {|x| FieldName(x) }
Local nCntFor1  := 0
Local nCntFor   := 0

If nOpc == 1
	PRIVATE aCols   := {}
	PRIVATE aHeader := {}
	nMaxFor := Len(aPedPV)
	If ( nMaxFor > 0 )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta aHeader do SC6                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC6",.T.)
		While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
			If (  ((X3Uso(SX3->X3_USADO) .And. ;
					!( Trim(SX3->X3_CAMPO) == "C6_NUM" ) .And.;
					Trim(SX3->X3_CAMPO) <> "C6_QTDEMP"  .And.;
					Trim(SX3->X3_CAMPO) <> "C6_QTDENT") .And.;
					cNivel >= SX3->X3_NIVEL) )
				Aadd(aHeader,{ Trim(X3TITULO()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
		For nCntFor := 1 To nMaxFor
			lContinua := .F.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona Registros                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD2")
			dbSetOrder(3)
			MsSeek(xFilial()+aPedPV[nCntFor,2]+aPedPV[nCntFor,1]+aPedPV[nCntFor,4],.F.)

			While (     !Eof() .And. xFilial("SD2") == SD2->D2_FILIAL   .And.;
					aPedPV[nCntFor,2] == SD2->D2_DOC                                  .And.;
					aPedPV[nCntFor,1] == SD2->D2_SERIE                          .And.;
					aPedPv[nCntFor,4] == SD2->D2_CLIENTE+SD2->D2_LOJA .And.;
					!lContinua )
				If ( SD2->D2_ITEM == aPedPv[nCntFor,3] )
					lContinua := .T.
				Else
					dbSelectArea("SD2")
					dbSkip()
				EndIf
			EndDo
			If ( lContinua )
				dbSelectArea("SC5")
				dbSetOrder(1)
				MsSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
				If ( Found() )
					dbSelectArea("SC6")
					dbSetOrder(1)
					MsSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV,.F.)
					If ( !lPedido )
						lPedido := .T.
						dbSelectArea("SC5")
						nMaxFor1 := FCount()
						For nCntFor1 := 1 To nMaxFor1
							M->&(EVAL(bCampo,nCntFor1)) := CriaVar(FieldName(nCntFor1),.T.)
						Next nCntFor1
						M->C5_TIPO    := SC5->C5_TIPO
						M->C5_CLIENTE := SC5->C5_CLIENTE
						M->C5_LOJAENT := SC5->C5_LOJAENT
						M->C5_LOJACLI := SC5->C5_LOJACLI
						M->C5_TIPOCLI := SC5->C5_TIPOCLI
						M->C5_CONDPAG := SC5->C5_CONDPAG
						M->C5_TABELA  := SC5->C5_TABELA
						M->C5_DESC1   := SC5->C5_DESC1
						M->C5_DESC2   := SC5->C5_DESC2
						M->C5_DESC3   := SC5->C5_DESC3
						M->C5_DESC4   := SC5->C5_DESC4
						For nCntFor1 :=  1 To nParcTp9
							cCampo := IIF(nCntFor1<9,StrZero(nCntFor1,1),Chr(55+nCntFor1))
							cCampo := "C5_PARC"+cCampo
							nPos1 := SC5->(FieldPos(cCampo))
							M->&(cCampo) := SC5->(FieldGet(nPos1))
							cCampo := IIF(nCntFor1<9,StrZero(nCntFor1,1),Chr(55+nCntFor1))
							cCampo := "C5_DATA"+cCampo
							nPos1 := SC5->(FieldPos(cCampo))
							M->&(cCampo) := SC5->(FieldGet(nPos1))
						Next nCntFor1
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Preenche aCols                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nUsado := Len(aHeader)
					aadd(aCols,Array(nUsado+1))
					nAcols := Len(aCols)
					aCols[nAcols,nUsado+1] := .F.
					For nCntFor1 := 1 To nUsado
						Do Case
						Case ( AllTrim(aHeader[nCntFor1,2]) $ "C6_ITEM" )
							aCols[nAcols,nCntFor1] := StrZero(++nItSC6,Len(SC6->C6_ITEM))
						Case ( AllTrim(aHeader[nCntFor1,2]) $ "C6_QTDVEN" )
							aCols[naCols,nCntFor1] := aPedPv[nCntFor,5]
						Case ( AllTrim(aHeader[nCntFor1,10]) <> "V" )
							aCols[nAcols,nCntFor1] := SC6->(FieldGet(FieldPos(aHeader[nCntFor1,2])))
						Otherwise
							aCols[nAcols,nCntFor1] := CriaVar(aHeader[nCntFor1,2],.T.)
						EndCase
					Next nCntFor1
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aqui e'atualizado o numero de pedido gerado no sd1       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( lContinua )
				dbSelectArea("SD1")
				MsGoto(aPedPV[nCntFor,6])
				RecLock("SD1",.F.)
				SD1->D1_NUMPV  := M->C5_NUM
				SD1->D1_ITEMPV := StrZero(nItSC6,Len(SC6->C6_ITEM))
			EndIf
		Next nCntFor
		If ( lPedido )
			lGrade   := .F.
			cBloqc6  := ""
			PRIVATE lMTA410TE:= (ExistTemplate("MTA410")) 
			PRIVATE lMTA410  := (ExistBlock("MTA410"))
			PRIVATE lMTA410I := (ExistBlock("MTA410I"))
			PRIVATE lM410ABN := (ExistBlock("M410ABN"))
			PRIVATE lMTA410E := (ExistBlock("MTA410E"))
			PRIVATE lA410EXC := (ExistBlock("A410EXC")) 
			PRIVATE lM410LIOKT:= (ExistTemplate("M410LIOK"))
			PRIVATE lM410LIOK:= (ExistBlock("M410LIOK"))
			PRIVATE lMta410TTE:= (ExistTemplate("MTA410T")) 
			PRIVATE lMta410T := (ExistBlock("MTA410T"))
			PRIVATE l410DEL  := (ExistBlock("M410DEL"))
			a410Grava(.F.,.F.)
            While ( GetSX8Len() > nSaveSX8 )
				ConfirmSx8()
			EndDo
			MsgAlert(STR0065+M->C5_NUM) //"Gerada Ped.de Venda N.: "
		EndIf
	EndIf
	aCols   := aSavaCols
	aHeader := aSavaHead
	dbSelectArea(aArea[1])
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rotina de estorno.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndIf
dbSetOrder(aArea[2])
MsGoto(aArea[3])
Return(NIL)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103VisuPC³ Autor ³ Edson Maricate       ³ Data ³16.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama a rotina de visualizacao dos Pedidos de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Dicionario de Dados - Campo:D1_TOTAL                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103VisuPC(nRecSC7)

Local aArea			:= GetArea()
Local aAreaSC7		:= SC7->(GetArea())
Local nSavNF		:= MaFisSave()
Local cSavCadastro	:= cCadastro
Local cFilBak       := cFilAnt
Local nBack         := n
PRIVATE nTipoPed	:= 1
PRIVATE cCadastro	:= OemToAnsi(STR0066) //"Consulta ao Pedido de Compra"
PRIVATE l120Auto	:= .F.
PRIVATE aBackSC7  	:= {}  //Sera utilizada na visualizacao do pedido - MATA120
MaFisEnd()

dbSelectArea("SC7")
MsGoto(nRecSC7)

cFilAnt := SC7->C7_FILIAL

A120Pedido(Alias(),RecNo(),2)

cFilant := cFilBak

n := nBack
cCadastro	:= cSavCadastro
MaFisRestore(nSavNF)
RestArea(aAreaSC7)
RestArea(aArea)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103NFORI³ Autor ³ Edson Maricate        ³ Data ³16.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a chamada da Tela de Consulta a NF original            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103NFORI()

Local bSavKeyF4 := SetKey(VK_F4,Nil)
Local bSavKeyF5 := SetKey(VK_F5,Nil)
Local bSavKeyF6 := SetKey(VK_F6,Nil)
Local bSavKeyF7 := SetKey(VK_F7,Nil)
Local bSavKeyF8 := SetKey(VK_F8,Nil)
Local bSavKeyF9 := SetKey(VK_F9,Nil)
Local bSavKeyF10:= SetKey(VK_F10,Nil)
Local bSavKeyF11:= SetKey(VK_F11,Nil)
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_COD'})
Local nPosLocal := aScan(aHeader,{|x| AllTrim(x[2])=='D1_LOCAL'})
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_TES'})
Local nPLocal	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_LOCAL'})
Local nRecSD1   := 0
Local nRecSD2   := 0
Local lContinua := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	dbSelectArea("SF4")
	dbSetOrder(1)
	MsSeek(xFilial()+aCols[n][nPosTes])

	If MaFisFound("NF") .And. Empty(Readvar())
		Do Case
		Case cTipo =="D" .And. SF4->F4_PODER3=="N"
			If F4NFORI(,,"M->D1_NFORI",cA100For,cLoja,aCols[n][nPosCod],"A100",aCols[n][nPLocal],@nRecSD2)
				NfeNfs2Acols(nRecSD2,n)
			EndIf
		Case cTipo$"CPI"
			If F4COMPL(,,,cA100For,cLoja,aCols[n][nPosCod],"A100",@nRecSD1,"M->D1_NFORI")
				NfeNfe2ACols(nRecSD1,n)
			EndIf
		Case cTipo$"NB" .And. SF4->F4_PODER3=="D"
			If cPaisLoc=="BRA"
				If F4Poder3(aCols[n][nPosCod],aCols[n][nPosLocal],cTipo,"E",cA100For,cLoja,@nRecSD2,SF4->F4_ESTOQUE)
					NfeNfs2Acols(nRecSD2,n)
				EndIf
			Else
				If A440F4("SB6",aCols[n][nPosCod],aCols[n][nPosLocal],"B6_PRODUTO","E",cA100For,cLoja,.F.,.F.,@nRecSD2,IIF(cTipo=="N","F","C")) > 0
					NfeNfs2Acols(nRecSD2,n)
				EndIf
			EndIf
		OtherWise
            If Empty(aCols[n][nPosCod]) .Or. Empty(aCols[n][nPosTes])
				Help('   ',1,'A103TPNFOR')
            ElseIf cTipo == "D" .And. SF4->F4_PODER3 <> "N"	 
				Help('   ',1,'A103TESNFD')
            ElseIf cTipo$"NB" .And. SF4->F4_PODER3 <> "D"	 
				Help('   ',1,'A103TESNFB')
			EndIf    
		EndCase
	Else
		Help('   ',1,'A103CAB')
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PNEUAC - Ponto de Entrada,gravar na coluna Lote o numero baseado na nf Original       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("PNEU002")
		ExecBlock("PNEU002",.F.,.F.)
	EndIf

Endif

SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103LoteF4³ Autor ³ Edson Maricate       ³ Data ³16.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a chamada da Tela de Consulta a NF original            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103LoteF4()

Local bSavKeyF4 := SetKey(VK_F4,Nil)
Local bSavKeyF5 := SetKey(VK_F5,Nil)
Local bSavKeyF6 := SetKey(VK_F6,Nil)
Local bSavKeyF7 := SetKey(VK_F7,Nil)
Local bSavKeyF8 := SetKey(VK_F8,Nil)
Local bSavKeyF9 := SetKey(VK_F9,Nil)
Local bSavKeyF10:= SetKey(VK_F10,Nil)
Local bSavKeyF11:= SetKey(VK_F11,Nil)
Local lContinua := .T.
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD" })
Local nPosLocal := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL" })
PRIVATE nPosLote   := aScan(aHeader,{|x|Alltrim(x[2])=="D1_NUMLOTE"})
PRIVATE nPosLotCTL := aScan(aHeader,{|x|Alltrim(x[2])=="D1_LOTECTL"})
PRIVATE nPosDvalid := aScan(aHeader,{|x|Alltrim(x[2])=="D1_DTVALID"})
PRIVATE nPosPotenc := aScan(aHeader,{|x|Alltrim(x[2])=="D1_POTENCI"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	If MaFisFound('NF')
		If cTipo=="D"
			F4Lote(,,,"A103",aCols[n][nPosCod],aCols[n][nPosLocal])
		Else
			Help('  ',1,'A103TIPOD')
		EndIf
	Else
		Help('  ',1,'A103CAB')
	EndIf
Endif

SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FAtiva   ³ Autor ³ Edson Maricate        ³ Data ³ 18.10.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama a pergunte do mata103                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FAtiva()
Pergunte("MTA103",.T.)
If ExistBlock("MT103SX1")
	ExecBlock("MT103SX1",.F.,.F.)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103EstNCC³ Autor ³ Edson Maricate        ³ Data ³02.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Estorna os titulos de NCC gerados ao Cliente.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a103EstNCC()

Local cPref := PadR(&(SuperGetMV("MV_2DUPREF")), Len( SE1->E1_PREFIXO ) ) 
If cTipo == "D"
	dbSelectArea("SE1")
	dbSetOrder(2)
	MsSeek(xFilial()+cA100For+cLoja+cPref+cNFiscal)
	While !Eof() .And. xFilial()+cA100For+cLoja+cPref+cNFiscal ==;
			E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM
		If !(E1_TIPO $ MV_CRNEG)
			dbSelectArea("SE1")
			dbSkip()
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			If MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
				AtuSalDup("+",SE1->E1_VALOR,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO)
				dbSelectArea("SE1")
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Refaz  os valores da Comissao.               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( SuperGetMV("MV_TPCOMIS")=="O" )
				Fa440DeleE("MATA100")
			EndIf
			RecLock("SE1",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndIf
	EndDo
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ToFC030 ³Autor³ Edson Maricate        ³ Data ³06.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Compatibilizacao de variaveis utilizadas no FINC030/FINC010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103TOFC030(cOper)
Local aArea	:= GetArea()
Local nposN	:= n
Local cSavCadastro	:= cCadastro
Local aSavaCols		:= aClone(aCols)
Local aSavaHeader	:= aClone(aHeader)

cOper := IIf(cOper == Nil, "E",cOper)

If (cOper=="E".And.cTipo$'DB') .Or. (cOper=="S".And.!(cTipo$'DB'))
	dbSelectArea('SA1')
	If Pergunte("FIC010",.T.)
		Fc010Con('SA1',RecNo(),3)
	EndIf
	Pergunte("MTA103",.F.)
Else
	If	Pergunte("FIC030",.T.)
		Finc030("Fc030Con")
	EndIf
	Pergunte("MTA103",.F.)
EndIf

cCadastro	:= cSavCadastro
aCols		:= aClone(aSavaCols)
aHeader		:= aClone(aSavaHeader)
n			:= nposN
RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103Histor³ Prog. ³Edson Maricate         ³Data  ³20.05.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria uma array contendo o Historic de Opercoes da NF.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Histor(ExpN1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = 01.Registro da NF no SF1                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array contendo os Historicos                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103Histor(nRecSF1)

Local aHistor	:= {}
Local aRet		:= {}
Local aArea		:= GetArea()
Local aAreaSF1	:= SF1->(GetArea())
Local cPrefixo	:= IIf(Empty(SF1->F1_PREFIXO),&(SuperGetMV("MV_2DUPREF")),SF1->F1_PREFIXO)

dbSelectArea('SF1')
MsGoto(nRecSF1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui no historico a data de Recebimento da Mercadoria      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SF1->F1_RECBMTO)
	aAdd(aHistor,{SF1->F1_RECBMTO,"A",STR0075}) //"  Recebimento do Documento de Entrada."
Else
	aAdd(aHistor,{SF1->F1_RECBMTO,"A",STR0076}) //"  Este Documento de Entrada foi incluido em versões anteriores do sistema."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui no historico a data de Classificacao da NF            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SF1->F1_STATUS)
	aAdd(aHistor,{SF1->F1_DTDIGIT,"B",STR0077}) //"  Classificacao do Documento de Entrada."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui no historico a data de Contabilizacao da NF           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SF1->F1_DTLANC)
	aAdd(aHistor,{SF1->F1_DTLANC,"C",STR0078}) //"  Contabilizacao do Documento de Entrada."
EndIf

dbSelectArea("SD1")
dbSetOrder(1)
MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
While !Eof() .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
		xFilial()+cNFiscal+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui no historico a data de Contabilizacao da NF           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
	Case cTipo == 'N'
		If SD1->D1_QTDEDEV <> 0
			dbSelectArea("SD2")
			dbSetOrder(8)
			MsSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC+SD1->D1_SERIE)
			While !Eof() .And. xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC+SD1->D1_SERIE==;
					SD2->D2_FILIAL+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_NFORI+SD2->D2_SERIORI
				If aScan(aHistor,{|x| x[3]==STR0079+SD2->D2_DOC+"/"+SD2->D2_SERIE}) == 0 //"  Devolucao efetuada : "
					aAdd(aHistor,{SD2->D2_EMISSAO,"D",STR0079+SD2->D2_DOC+"/"+SD2->D2_SERIE}) //"  Devolucao efetuada : "
				EndIf
				dbSkip()
			End
		EndIf
	EndCase
	dbSelectArea("SD1")
	dbSkip()
EndDo

aSort(aHistor,,,{|x,y| x[2]+DTOC(x[1]) < y[2]+DTOC(y[1])})
aEval(aHistor,{|x| aAdd(aRet,DTOC(x[1])+x[3]) })

RestArea(aAreaSF1)
RestArea(aARea)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103Rodape³ Prog. ³Edson Maricate         ³Data  ³20.05.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria o Rodape compativel para NF incluidas pelo MATA100     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Rodape(ExpO1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Janela principal                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103, Compatibilizacao com Notas do MATA100             ³±±
±±³          ³          nas telas de visualizacao e exclusao.             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103Rodape(oFolderWnd)
Local nValMerc	:= SF1->F1_VALMERC
Local nFrete	:= SF1->F1_FRETE
Local nValDesp	:= SF1->F1_DESPESA
Local nDesconto	:= SF1->F1_DESCONT
Local nAcessori	:= SF1->F1_BASEFD
Local nBsIcms	:= SF1->F1_BASEICM
Local nIPI		:= SF1->F1_VALIPI
Local nIcms		:= SF1->F1_VALICM
Local nBsIcmRet	:= SF1->F1_BRICMS
Local nVIcmRet	:= SF1->F1_ICMSRET
Local nValFun	:= SF1->F1_CONTSOC

@ 5  ,5   SAY STR0080 Of oFolderWnd PIXEL SIZE 32 ,9 //'Mercadorias'
@ 4  ,45  MSGET nValMerc  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

@ 5  ,105 SAY STR0081 Of oFolderWnd PIXEL SIZE 43 ,9 //'Frete'
@ 4  ,130 MSGET nFrete  PICTURE '@E 999,999,999.99' When .F.  OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

@ 5  ,200 SAY STR0082 Of oFolderWnd PIXEL SIZE 35 ,9 //'Despesas'
@ 4  ,230 MSGET nValDesp  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

@ 20 ,6   SAY STR0083 Of oFolderWnd PIXEL SIZE 27 ,9 //'Descontos'
@ 19 ,45  MSGET nDesconto  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

@ 20 ,150 SAY STR0084 Of oFolderWnd PIXEL SIZE 95 ,9 //'Base das Despesas Acessorias'
@ 19 ,230 MSGET nAcessori  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

@ 35 ,6   SAY STR0085 Of oFolderWnd PIXEL SIZE 39 ,9 //'Base de ICMS'
@ 34 ,45  MSGET nBsIcms  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

@ 35 ,105 SAY STR0086 Of oFolderWnd PIXEL SIZE 25 ,9 //'IPI'
@ 34 ,130 MSGET nIpi  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

@ 35 ,205 SAY STR0087 Of oFolderWnd PIXEL SIZE 20 ,9 //'ICMS'
@ 34 ,230 MSGET nICMS  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

If nBsIcmRet+nVIcmRet > 0
	@ 50 ,6   SAY STR0088 Of oFolderWnd PIXEL SIZE 40 ,9 //'Bs. ICMS Ret.'
	@ 49 ,45  MSGET nBsIcmRet  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9

	@ 50 ,100 SAY STR0089 Of oFolderWnd PIXEL SIZE 24 ,9 //'ICMS Ret'
	@ 49 ,130 MSGET nVIcmRet  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9
EndIf

If nValFun > 0
	@ 50 ,194 SAY STR0090 Of oFolderWnd PIXEL SIZE 31 ,9 //'FunRural'
	@ 49 ,230 MSGET nValFun  PICTURE '@E 999,999,999.99' When .F. OF oFolderWnd PIXEL RIGHT SIZE 48 ,9
EndIf

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103Legenda³ Autor ³ Edson Maricate       ³ Data ³ 01.02.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103Legenda()
Local aLegenda := { {"ENABLE",STR0091},; //"Docto. nao Classificado"
	{"BR_LARANJA",STR0147},; //"Docto. Bloqueado"
	{"DISABLE"   ,STR0092},; //"Docto. Normal"
	{"BR_AZUL"   ,STR0093},; //"Docto. de Compl. IPI"
	{"BR_MARRON" ,STR0094},; //"Docto. de Compl. ICMS"
	{"BR_PINK"   ,STR0095},; //"Docto. de Compl. Preco/Frete"
	{"BR_CINZA"  ,STR0096},; //"Docto. de Beneficiamento"
	{"BR_AMARELO",STR0097} } //"Docto. de Devolucao"

If SuperGetMV("MV_CONFFIS") == "S"
	aAdd(aLegenda,{"BR_PRETO",STR0098}) //"Docto. em processo de conferencia"
EndIf

BrwLegenda(cCadastro,STR0008 ,aLegenda) //"Legenda"

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A103Bar  ³ Prog. ³ Sergio Silveira       ³Data  ³23/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria a enchoicebar.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103Bar( ExpO1, ExpB1, ExpB2, ExpA1 )                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto dialog                                      ³±±
±±³          ³ ExpB1 = Code block de confirma                             ³±±
±±³          ³ ExpB2 = Code block de cancela                              ³±±
±±³          ³ ExpA1 = Array com botoes ja incluidos.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Retorna o retorno da enchoicebar                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A103Bar(oDlg,bOk,bCancel,aButtonsAtu, aInfo  )

Local aUsButtons := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ExistBlock( "MA103BUT" )
	If ValType( aUsButtons := ExecBlock( "MA103BUT", .F., .F.,{aInfo} ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtonsAtu, x ) } )
	EndIf
EndIf

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtonsAtu))




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103EstDCF³ Prog. ³Fernando Joly Siquini  ³Data  ³06.09.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Efetua o estorno dos registros do DCF (Servico WMS).        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103EstDCF()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103EstDCF()


Local aAreaAnt   := GetArea()
Local cSeekDCF   := ''
Local lRet       := .T.

If !Empty(SD1->D1_SERVIC) .And. (SuperGetMV('MV_INTDL')=='S')
	dbSelectArea('DCF')
	dbSetOrder(2) //-- FILIAL+SERVIC+DOCTO+SERIE+CLIFOR+LOJA+CODPRO
	If MsSeek(cSeekDCF:=xFilial('DCF')+SD1->D1_SERVIC+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD, .F.)
		Do While !Eof() .And. cSeekDCF==DCF_FILIAL+DCF_SERVIC+DCF_DOCTO+DCF_SERIE+DCF_CLIFOR+DCF_LOJA+DCF_CODPRO
			If DCF->DCF_NUMSEQ==SD1->D1_NUMSEQ .And. DCF_STSERV=='1'
				RecLock('DCF',.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
			DCF->(dbSkip())
		EndDo
	EndIf
	RestArea(aAreaAnt)
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103Devol³ Autor ³ Henry Fila             ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Consulta de Historicos da Revisao.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                     ³±±
±±³          ³ ExpN1 = Numero do registro                                   ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function A103Devol(cAlias,nReg,nOpcx)

Local oDlgEsp
Local oLbx
Local lCliente  := .F.
Local aRotina   := {{STR0005,"A103ProcDv",0,2}} //"Retornar"
Local nOpca     := 0
Local aHSF2     := {}
Local aSF2      := {}
Local aCpoSF2   := {}
Local dDataDe   := CToD('  /  /  ')
Local dDataAte  := CToD('  /  /  ')
Local nCnt      := 0
Local nPosDoc   := 0
Local nPosSerie := 0
Local cDocSF2   := ''

Private cCliente := CriaVar("F2_CLIENTE",.F.)
Private cLoja    := CriaVar("F2_LOJA",.F.)

If Inclui
	//-- Valida filtro de retorno de doctos fiscais.
	If A103FRet(@lCliente,@dDataDe,@dDataAte)
		If lCliente
			Aadd( aHSF2, ' ' )
			SX3->(DbSetOrder(1))
			SX3->(DbSeek("SF2"))
			While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SF2" .And. SX3->X3_BROWSE == "S"
				Aadd( aHSF2, X3Titulo() )
				Aadd( aCpoSF2, SX3->X3_CAMPO )
				//-- Armazena a posicao do documento e serie
				If AllTrim(SX3->X3_CAMPO) == 'F2_DOC'
					nPosDoc := Len(aHSF2)
				ElseIf AllTrim(SX3->X3_CAMPO) == 'F2_SERIE'
					nPosSerie := Len(aHSF2)
				EndIf
				SX3->(DbSkip())
			EndDo
			//-- Retorna as notas que atendem o filtro.
	      aSF2 := A103RetNF(aCpoSF2,dDataDe,dDataAte)
			If !Empty(aSF2)
				DEFINE MSDIALOG oDlgEsp TITLE STR0099 FROM 00,00 TO 300,600 PIXEL
					oLbx:= TWBrowse():New( 012, 000, 300, 140, NIL, ;
			                                 aHSF2, NIL, oDlgEsp, NIL, NIL, NIL,,,,,,,,,, "ARRAY", .T. )
					oLbx:SetArray( aSF2 )
					oLbx:bLDblClick  := { || { aSF2[oLbx:nAT,1] := !aSF2[oLbx:nAT,1] }}
					oLbx:bLine := &('{ || A103Line(oLbx:nAT,aSF2) }')
				ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{|| nOpca := 1, oDlgEsp:End()},{||oDlgEsp:End()}) CENTERED
				//-- Processa Devolucao				
				If nOpca == 1
					ASort( aSF2,,,{|x,y| x[1] > y[1] })
					For nCnt := 1 To Len(aSF2)
						If !aSF2[nCnt,1]
							Exit
						EndIf
						#IFDEF TOP
							cDocSF2 += "( SD2.D2_DOC = '" + aSF2[nCnt,nPosDoc] + "' AND SD2.D2_SERIE = '" + aSF2[nCnt,nPosSerie] + "' ) OR "
						#ELSE
							cDocSF2 += "( SD2->D2_DOC == '" + aSF2[nCnt,nPosDoc] + "' .And. SD2->D2_SERIE == '" + aSF2[nCnt,nPosSerie] + "' ) .Or. "
						#ENDIF
					Next nCnt
					If !Empty(cDocSF2)
						#IFDEF TOP
							cDocSF2 := SubStr(cDocSF2,1,Len(cDocSF2)-3) + " )"
						#ELSE
							cDocSF2 := SubStr(cDocSF2,1,Len(cDocSF2)-5) + " )"
						#ENDIF
					EndIf
					A103ProcDv(cAlias,nReg,nOpcx,lCliente,cCliente,cLoja,cDocSF2)
				EndIf			
			EndIf
		Else
			DbSelectArea("SF2")
			cIndex := CriaTrab(NIL,.F.)
			cQuery := " SF2->F2_FILIAL == '" + xFilial("SF2") + "' "
		  	cQuery += " .And. SF2->F2_CLIENTE == '" + cCliente + "' "
		  	cQuery += " .And. SF2->F2_LOJA    == '" + cLoja    + "' "
		  	cQuery += " .And. DtoS(SF2->F2_EMISSAO) >= '" + DtoS(dDataDe)  + "'"
			cQuery += " .And. DtoS(SF2->F2_EMISSAO) <= '" + DtoS(dDataAte) + "' "
			IndRegua("SF2",cIndex,SF2->(IndexKey()),,cQuery)
			If SF2->(!Eof())
				MaWndBrowse(0,0,300,600,STR0099,"SF2",,aRotina,,,,.T.,,,,,,.F.) //"Retorno de Doctos. de Saida"
			EndIf
			RetIndex( "SF2" )  
			FErase( cIndex+OrdBagExt() )
		EndIf
	EndIf
EndIf

Inclui := !Inclui

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A103ProcDvºAutor  ³Henry Fila          º Data ³  06/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre a tela da nota fiscal de entrada de acordo com a nota º±±
±±º          ³ de saida escolhida no browse                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function A103ProcDv(cAlias,nReg,nOpcx,lCliente,cCliente,cLoja,cDocSF2)

Local aArea     := GetArea()
Local aAreaSF2  := SF2->(GetArea())
Local aCab      := {}
Local aLinha    := {}
Local aItens    := {}
Local cAliasSD2 := "SD2"
Local cAliasSF4 := "SF4"
Local cTipoNF   := ""
Local nSldDev   := 0
Local lDevolucao:= .T.
Local lQuery    := .F.
Local lPoder3   := .T.
Local lMt103FDV := ExistBlock("MT103FDV")
#IFDEF TOP
	Local aStruSD2 := {}
	Local cQuery   := ""
	Local nX       := 0
#ELSE
	Local cIndex   := ""
#ENDIF

Default lCliente := .F.
Default cCliente := SF2->F2_CLIENTE
Default cLoja    := SF2->F2_LOJA
Default cDocSF2  := ''

If SoftLock("SF2")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem dos itens da Nota Fiscal de Devolucao/Retorno          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(3)
	#IFDEF TOP
		lQuery    := .T.
		cAliasSD2 := "Oms320Dev"
		cAliasSF4 := "Oms320Dev"
		aStruSD2  := SD2->(dbStruct())
		cQuery    := "SELECT SF4.F4_CODIGO,SF4.F4_CF,SF4.F4_PODER3,SD2.*,SD2.R_E_C_N_O_ SD2RECNO "
		cQuery    += "FROM "+RetSqlName("SD2")+" SD2,"
		cQuery    += RetSqlName("SF4")+" SF4 "
		cQuery    += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
		If !lCliente
			cQuery    += "SD2.D2_DOC = '"+SF2->F2_DOC+"' AND "
			cQuery    += "SD2.D2_SERIE = '"+SF2->F2_SERIE+"' AND "
		Else
			If !Empty(cDocSF2)
				cQuery += " ( "
				cQuery += cDocSF2 + " AND "
			EndIf
		EndIf
		cQuery    += "SD2.D2_CLIENTE = '"+cCliente+"' AND "
		cQuery    += "SD2.D2_LOJA = '"+cLoja+"' AND "
		cQuery    += "SD2.D2_QTDEDEV < SD2.D2_QUANT AND "
		cQuery    += "SD2.D_E_L_E_T_=' ' AND "
		cQuery    += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery    += "SF4.F4_CODIGO=(SELECT F4_TESDV FROM "+RetSqlName("SF4")+" WHERE "
		cQuery    += "F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery    += "F4_CODIGO=SD2.D2_TES AND "
		cQuery    += "D_E_L_E_T_=' ' ) AND "
		cQuery    += "SF4.D_E_L_E_T_=' ' "
		cQuery    += "ORDER BY "+SqlOrder(SD2->(IndexKey()))	

		cQuery    := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

		For nX := 1 To Len(aStruSD2)
			If aStruSD2[nX][2]<>"C"
				TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
			EndIf
		Next nX

		If Eof()
			Help(" ",1,"DSNOTESDEV")
			lDevolucao := .F.
		EndIf
	#ELSE
		If lCliente
			cIndex := CriaTrab(NIL,.F.)
			cQuery := " SD2->D2_FILIAL == '" + xFilial("SD2") + "' "
		  	cQuery += " .And. SD2->D2_CLIENTE == '" + cCliente + "' "
		  	cQuery += " .And. SD2->D2_LOJA    == '" + cLoja    + "' "
			If !Empty(cDocSF2)
				cQuery += " .And. ( "
				cQuery += cDocSF2
			EndIf
			IndRegua("SD2",cIndex,SD2->(IndexKey()),,cQuery)
			SD2->(DbGotop())
		Else
			MsSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+cCliente+cLoja)
		EndIf
	#ENDIF
	While !Eof() .And. (cAliasSD2)->D2_FILIAL == xFilial("SD2") .And.;
			(cAliasSD2)->D2_CLIENTE == cCliente .And.;
			(cAliasSD2)->D2_LOJA == cLoja .And.;
			If(!lCliente,(cAliasSD2)->D2_DOC == SF2->F2_DOC .And.;
							 (cAliasSD2)->D2_SERIE == SF2->F2_SERIE,.T.)

		If (cAliasSD2)->D2_QTDEDEV < (cAliasSD2)->D2_QUANT		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe um tes de devolucao correspondente           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lQuery
				dbSelectArea("SF4")
				DbSetOrder(1)
				If MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)
					If Empty(SF4->F4_TESDV) .Or. !(SF4->(MsSeek(xFilial("SF4")+SF4->F4_TESDV)))
						Help(" ",1,"DSNOTESDEV")
						lDevolucao := .F.
						Exit
					EndIf
					If SF4->F4_PODER3<>"D"
						lPoder3 := .F.
					EndIf
				EndIf
			Else
				If (cAliasSD2)->F4_PODER3<>"D"
					lPoder3 := .F.
				EndIf			
			EndIf
			If !lMt103FDV .Or. ExecBlock("MT103FDV",.F.,.F.,{cAliasSD2})

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula o Saldo a devolver                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				cTipoNF := (cAliasSD2)->D2_TIPO
				If (cAliasSF4)->F4_PODER3=="D"
					nSldDev := CalcTerc((cAliasSD2)->D2_COD,(cAliasSD2)->D2_CLIENTE,(cAliasSD2)->D2_LOJA,(cAliasSD2)->D2_IDENTB6,(cAliasSD2)->D2_TES,cTipoNF)[1]
				Else
					nSldDev := (cAliasSD2)->D2_QUANT-(cAliasSD2)->D2_QTDEDEV
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua a montagem da Linha                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				If nSldDev > 0

					aLinha := {}				
					AAdd( aLinha, { "D1_COD"    , (cAliasSD2)->D2_COD    , Nil } )
					AAdd( aLinha, { "D1_QUANT"  , nSldDev, Nil } )					
					AAdd( aLinha, { "D1_VUNIT"  , ((cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR)/(cAliasSD2)->D2_QUANT, Nil })					
					If (cAliasSD2)->D2_QUANT==nSldDev
						AAdd( aLinha, { "D1_TOTAL"  , (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR,Nil } )
						AAdd( aLinha, { "D1_VALDESC", (cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR , Nil } )						
					Else
						AAdd( aLinha, { "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
						AAdd( aLinha, { "D1_VALDESC"  , A410Arred((cAliasSD2)->D2_DESCON/(cAliasSD2)->D2_QUANT*aLinha[2][2],"D1_VALDESC"),Nil } )						
					EndIf
					AAdd( aLinha, { "D1_IPI"    , (cAliasSD2)->D2_IPI    , Nil } )	
					AAdd( aLinha, { "D1_LOCAL"  , (cAliasSD2)->D2_LOCAL  , Nil } )
					AAdd( aLinha, { "D1_TES" 	, (cAliasSF4)->F4_CODIGO , Nil } )
					AAdd( aLinha, { "D1_CF" 	, SubStr("123",At(SubStr((cAliasSF4)->F4_CF,1,1),"567"),1)+SubStr((cAliasSF4)->F4_CF,2), Nil } )
					AAdd( aLinha, { "D1_UM"     , (cAliasSD2)->D2_UM , Nil } )
					If Rastro((cAliasSD2)->D2_COD)
						AAdd( aLinha, { "D1_LOTECTL", (cAliasSD2)->D2_LOTECTL, ".T." } )
						AAdd( aLinha, { "D1_NUMLOTE", (cAliasSD2)->D2_NUMLOTE, ".T." } )
						AAdd( aLinha, { "D1_DTVALID", (cAliasSD2)->D2_DTVALID, ".T." } )
						AAdd( aLinha, { "D1_POTENCI", (cAliasSD2)->D2_POTENCI, ".T." } )
					EndIf
					AAdd( aLinha, { "D1_NFORI"  , (cAliasSD2)->D2_DOC    , Nil } )
					AAdd( aLinha, { "D1_SERIORI", (cAliasSD2)->D2_SERIE  , Nil } )
					AAdd( aLinha, { "D1_ITEMORI", (cAliasSD2)->D2_ITEM   , Nil } )
					AAdd( aLinha, { "D1_ICMSRET", (cAliasSD2)->D2_ICMSRET, Nil } )					
					If (cAliasSF4)->F4_PODER3=="D"
						AAdd( aLinha, { "D1_IDENTB6", (cAliasSD2)->D2_NUMSEQ, Nil } )								
					Endif

					If ExistBlock("MT103LDV")
						aLinha := ExecBlock("MT103LDV",.F.,.F.,{aLinha,cAliasSD2})
					EndIf

					AAdd( aLinha, { "D1RECNO",    Iif(lQuery,(cAliasSD2)->SD2RECNO,(cAliasSD2)->(RECNO()) ), Nil } )

					AAdd( aItens, aLinha)
				EndIf
			Endif	
		EndIf
		dbSelectArea(cAliasSD2)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSD2)
		dbCloseArea()
	Else
		If lCliente
			RetIndex( "SD2" )
			FErase( cIndex+OrdBagExt() )
		EndIf
	EndIf
	dbSelectArea("SD2")
	If lDevolucao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do Cabecalho da Nota fiscal de Devolucao/Retorno       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AAdd( aCab, { "F1_DOC"    , CriaVar("F1_DOC",.F.)			, Nil } )	// Numero da NF : Obrigatorio
		AAdd( aCab, { "F1_SERIE"  , CriaVar("F1_SERIE",.F.)		, Nil } )	// Serie da NF  : Obrigatorio
		If !lPoder3
			AAdd( aCab, { "F1_TIPO"   , "D"                  		, Nil } )	// Tipo da NF   : Obrigatorio
		Else
			AAdd( aCab, { "F1_TIPO"   , IIF(cTipoNF=="B","N","B")	, Nil } )	// Tipo da NF   : Obrigatorio		
		EndIf
		AAdd( aCab, { "F1_FORNECE", cCliente    				, Nil } )	// Codigo do Fornecedor : Obrigatorio
		AAdd( aCab, { "F1_LOJA"   , cLoja    	   			, Nil } )	// Loja do Fornecedor   : Obrigatorio
		AAdd( aCab, { "F1_EMISSAO", dDataBase           			, Nil } )	// Emissao da NF        : Obrigatorio
		AAdd( aCab, { "F1_FORMUL" , "S"                 			, Nil } )  // Formulario
		AAdd( aCab, { "F1_ESPECIE", If(Empty(CriaVar("F1_ESPECIE",.T.)),;
			PadR("NF",Len(SF1->F1_ESPECIE)),CriaVar("F1_ESPECIE",.T.)), Nil } )  // Especie
		AAdd( aCab, { "F1_COND"   , SF2->F2_COND    	  			, Nil } )	// Condicao do Fornecedor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ha itens a serem devolvidos                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aItens)>0	
			Mata103( aCab, aItens , 3 , .T.)
		Else
			Help(" ",1,"OMS320NFD") //Nota Fiscal de devolucao ja gerada
		EndIf
	EndIf
EndIf
MsUnLockAll()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a entrada da rotina                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSF2)
RestArea(aArea)
Return(.T.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103ShowOP³ Autor ³Alexandre Inacio Lemes³ Data ³ 19/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta OP em Aberto atraves da tecla F4                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103ShowOP()      				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A103ShowOp()
Local oDlg, nOAT
Local nHdl    := GetFocus()
Local nOpt1   := 0
Local aArray  := {}
Local cAlias  := Alias()
Local nOrder  := IndexOrd()
Local nRecno  := Recno()
Local cCampo  := ReadVar()
Local cPicture:= PesqPictQt("C2_QUANT",16)
Local nOrdSC2 := SC2->(IndexOrd())
Local cMascara:= SuperGetMV("MV_MASCGRD")
Local nTamRef := Val(Substr(cMascara,1,2))
Local nPosOp  := AScan(aHeader,{|x| AllTrim(x[2])=='D1_OP'})
Local nPosCod := aScan(aHeader,{|x| AllTrim(x[2])=='D1_COD'})
Local cProdRef:= IIf(MatGrdPrrf(aCols[n][nPosCod]),Alltrim(aCols[n][nPosCod]),aCols[n][nPosCod])
Local bSavKeyF4 := SetKey(VK_F4,Nil)
Local bSavKeyF5 := SetKey(VK_F5,Nil)
Local bSavKeyF6 := SetKey(VK_F6,Nil)
Local bSavKeyF7 := SetKey(VK_F7,Nil)
Local bSavKeyF8 := SetKey(VK_F8,Nil)
Local bSavKeyF9 := SetKey(VK_F9,Nil)
Local bSavKeyF10:= SetKey(VK_F10,Nil)
Local bSavKeyF11:= SetKey(VK_F11,Nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto e' referencia (Grade)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MatGrdPrrf(aCols[n][nPosCod])
	nTamRef	 := Val(Substr(cMascara,1,2))
	cProdRef    := Alltrim(aCols[n][nPosCod])
Else
	nTamRef	 := Len(SC2->C2_PRODUTO)
	cProdRef    := aCols[n][nPosCod]
EndIf

If cCampo <> "M->D1_OP"
	SetKey(VK_F4,bSavKeyF4)
	SetKey(VK_F5,bSavKeyF5)
	SetKey(VK_F6,bSavKeyF6)
	SetKey(VK_F7,bSavKeyF7)
	SetKey(VK_F8,bSavKeyF8)
	SetKey(VK_F9,bSavKeyF9)
	SetKey(VK_F10,bSavKeyF10)
	SetKey(VK_F11,bSavKeyF11)	
	Return NIL
EndIf

dbSelectArea("SC2")
dbSetOrder(2)
If MsSeek(xFilial()+cProdRef)
	While !Eof() .And. C2_FILIAL+Substr(C2_PRODUTO,1, nTamRef) == xFilial()+cProdRef
		If Empty(C2_DATRF)
			AADD(aArray,{C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,DTOC(C2_DATPRI),DTOC(C2_DATPRF),Transform(aSC2Sld(),cPicture),C2_ITEMGRD})
		EndIf
		dbSkip()
	EndDo
EndIf

If !Empty(aArray)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0100) From 03,0 To 17,50 OF oMainWnd //"OPs em Aberto deste Produto"
	@ 0.5,  0 TO 7, 20.0 OF oDlg
	@ 1,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi(STR0101),OemToAnsi(STR0102),OemToAnsi(STR0103),OemToAnsi(STR0063),OemToAnsi(STR0104),OemToAnsi(STR0105),OemToAnsi(STR0106),OemToAnsi(STR0107)  SIZE 150,80 ON DBLCLICK (nOpt1 := 1,oDlg:End()) //"Numero"###"Item"###"Sequencia"###"Produto"###"Dt. Prev. Inicio"###"Dt. Prev. Fim"###"Saldo"###" It. Grade"
	oQual:SetArray(aArray)
	oQual:bLine := { || {aArray[oQual:nAT][1],aArray[oQual:nAT][2],aArray[oQual:nAT][3],aArray[oQual:nAT][4],aArray[oQual:nAT][5],aArray[oQual:nAT][6],aArray[oQual:nAT][7],aArray[oQual:nAT][8]}}
	DEFINE SBUTTON FROM 10  ,166  TYPE 1 ACTION (nOpt1 := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 22.5,166  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oQual:nAT, .T.)
	If nOpt1 == 1
		M->D1_OP :=aArray[nOAT][1]+aArray[nOAT][2]+aArray[nOAT][3]+aArray[nOAT][8]
		If nPosOp > 0
			aCols[n][nPosOp] := M->D1_OP
		EndIf
	EndIf
	SetFocus(nHdl)
Else
	Help(" ",1,"A250NAOOP")
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrder)
MsGoto(nRecno)
SC2->(dbSetOrder(nOrdSC2))
CheckSx3("D1_OP")
SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A103AtuSE2³ Autor ³ Edson Maricate        ³ Data ³11.10.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de integracao com o modulo financeiro                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Codigo de operacao                                    ³±±
±±³          ³       [1] Inclusao de Titulos                               ³±±
±±³          ³       [2] Exclusao de Titulos                               ³±±
±±³          ³ExpA2: Array com os recnos dos titulos financeiros. Utilizado³±±
±±³          ³       somente na exclusao                                   ³±±
±±³          ³ExpA3: AHeader dos titulos financeiros                       ³±±
±±³          ³ExpA4: ACols dos titulos financeiro                          ³±±
±±³          ³ExpA5: AHeader das multiplas naturezas                       ³±±
±±³          ³ExpA2: ACols das multiplas naturezas                         ³±±
±±³          ³ExpC6: Fornecedor dos ISS                                    ³±±
±±³          ³ExpC7: Loja do ISS                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a integracao entre o   ³±±
±±³          ³documento de entrada e os titulos financeiros.               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103AtuSE2(nOpcA,aRecSE2,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,cFornIss,cLojaIss,cDirf,cCodRet,cModRetPIS,nIndexSE2,aSEZ)

Local aArea     := GetArea()
Local aRetIrrf  := {}
Local aProp     := {}
Local cPrefixo  := SF1->F1_PREFIXO
Local cNatureza	:= MaFisRet(,"NF_NATUREZA")
Local cPrefOri  := ""
Local cNumOri   := ""
Local cParcOri  := ""
Local cTipoOri  := ""
Local cCfOri    := ""
Local cLojaOri  := ""

Local nPParcela := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_PARCELA"})
Local nPVencto  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VENCTO"})
Local nPValor   := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VALOR"})
Local nPIRRF    := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_IRRF"})
Local nPISS     := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_ISS"})
Local nPINSS    := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_INSS"})
Local nPPIS     := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_PIS"})
Local nPCOFINS  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_COFINS"})
Local nPCSLL    := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_CSLL"})
Local nBaseDup  := 0
Local nVlCruz   := MaFisRet(,"NF_BASEDUP")
Local nLoop     := 0
Local nX        := 0
Local nY        := 0
Local nZ        := 0
Local nRateio   := 0
Local nRateioSEZ:= 0
Local nMaxFor   := IIF(aColsSE2==Nil,0,Len(aColsSE2))
Local nRetOriPIS := 0
Local nRetOriCOF := 0
Local nRetOriCSLL:= 0
Local nValTot   := 0
Local nBasePis  := MaFisRet(,"NF_BASEPIS")
Local nBaseCof  := MaFisRet(,"NF_BASECOF")
Local nBaseCsl  := MaFisRet(,"NF_BASECSL")
Local nSaldoPis := nBasePis
Local nSaldoCof := nBaseCof
Local nSaldoCsl := nBaseCsl
Local nSaldoProp:= 0
Local nProp     := 0
Local nVlRetPIS := 0
Local nVlRetCOF := 0
Local nVlRetCSLL:= 0 

Local lVisDirf  := SuperGetMv("MV_VISDIRF",.F.,"2") == "1"
Local nValMinRet:= GetNewPar( "MV_VL10925", 0 ) 
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )
Local lRestValImp := .F. 				 
Local lRetParc  := .T.				 

DEFAULT cModRetPIS := "1" 


PRIVATE nValFun := MaFisRet(,"NF_FUNRURAL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o prefixo do titulo a ser gerado                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cPrefixo)
	cPrefixo := &(SuperGetMV("MV_2DUPREF"))
	cPrefixo += Space(Len(SE2->E2_PREFIXO) - Len(cPrefixo))
EndIf
If nOpcA == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona registros                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SED")
	dbSetOrder(1)
	MsSeek(xFilial("SED")+cNatureza)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o valor total das duplicatas                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	For nX := 1 To nMaxFor
		nBaseDup += aColsSE2[nX][nPValor]
	Next nX
	nBaseDup -= nValFun
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula os percentuais de raeio do SEZ                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRateioSEZ := 0
	For nZ := 1 To Len(aSEZ)
		nRateioSEZ += aSEZ[nZ][5]
	Next nZ
	For nZ := 1 To Len(aSEZ)
		aSEZ[nZ][4] := NoRound(aSEZ[nZ][5]/nRateioSEZ,TamSX3("EZ_PERC")[2])
	Next nZ
	nRateioSEZ := 0
	For nZ := 1 To Len(aSEZ)
		nRateioSEZ += aSEZ[nZ][4]
		If nZ == Len(aSEZ)
			aSEZ[nZ][4] += 1-nRateioSEZ
		EndIf
	Next nZ	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a gravacao dos titulos financeiros a pagar                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

	nValPis := 0
	nValCof := 0
	nValCsl := 0
	
	For nX := 1 to nMaxFor
		nValTot += aColsSE2[nX][nPValor]
	Next
                        
	aProp := {} 
        
	nSaldoProp := 1 

	For nX := 1 to nMaxFor 
		If nX == nMaxFor 
			nProp := nSaldoProp
		Else 			
			nProp := Round(aColsSE2[nX][nPValor] / nValTot,6)
			nSaldoProp -= nProp
		EndIf	
	   AAdd( aProp, nProp )
	Next nX
	
	For nX := 1 To nMaxFor
		If aColsSE2[nX][nPValor] > 0
			RecLock("SE2",.T.)
			SE2->E2_FILIAL  := xFilial("SE2")
			SE2->E2_PREFIXO := cPrefixo
			SE2->E2_NUM     := cNFiscal
			SE2->E2_TIPO    := MVNOTAFIS
			SE2->E2_NATUREZ := cNatureza
			SE2->E2_EMISSAO := dDEmissao
			SE2->E2_EMIS1   := dDataBase
			SE2->E2_FORNECE := SA2->A2_COD
			SE2->E2_LOJA    := SA2->A2_LOJA
			SE2->E2_NOMFOR  := SA2->A2_NREDUZ
			SE2->E2_MOEDA   := nMoedaCor
			SE2->E2_LA      := "S"
			SE2->E2_PARCELA := aColsSE2[nX][nPParcela]
			SE2->E2_VENCORI := aColsSE2[nX][nPVencto]
			SE2->E2_VENCTO  := aColsSE2[nX][nPVencto]
			SE2->E2_VENCREA := DataValida(aColsSE2[nX][nPVencto],.T.)
			SE2->E2_NATUREZ := cNatureza
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava a filial de origem quando existir o campo no SE2            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE2->(FieldPos("E2_FILORIG")) > 0
				SE2->E2_FILORIG := CriaVar("E2_FILORIG",.T.)	
			EndIf
			
			lRetParc := .T. 							
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica os impostos dos titulos financeiros                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc == "BRA"
				SE2->E2_IRRF    := aColsSE2[nX][nPIRRF]
				If SA2->A2_RECISS<>"S"
					SE2->E2_ISS     := aColsSE2[nX][nPISS]
					If SE2->(FieldPos("E2_FORNISS")) > 0 .And. SE2->(FieldPos("E2_LOJAISS")) > 0 
						If cFornIss <> Nil .And. cLojaIss <> Nil .And. aColsSE2[nX][nPISS] > 0
							SE2->E2_FORNISS := cFornIss
							SE2->E2_LOJAISS := cLojaIss
						Endif	
					Endif
				EndIf                             
				
				If lVisDirf
					SE2->E2_DIRF   := cDirf
					SE2->E2_CODRET := cCodRet
				Endif	
				
				SE2->E2_INSS    := aColsSE2[nX][nPINSS]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para calculo do IRRF                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (ExistBlock("MT100IR"))
					aRetIrrf := ExecBlock( "MT100IR",.F.,.F., {SE2->E2_IRRF,aColsSE2[nX][nPValor],nX} )
					Do Case
					Case ValType(aRetIrrf)  == "N"
						SE2->E2_IRRF := aRetIrrf
					Case ValType(aRetIrrf)  == "A"
						SE2->E2_IRRF := aRetIrrf[1]
						SE2->E2_ISS  := aRetIrrf[2]
					EndCase
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para calculo do INSS                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE2->E2_INSS > 0
					If ExistBlock("MT100INS")
						SE2->E2_INSS := ExecBlock( "MT100INS",.F.,.F.,{SE2->E2_INSS})
					EndIf
				EndIf

				If nPPIS > 0
					SE2->E2_PIS     := aColsSE2[nX][nPPIS]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para calculo do PIS                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("MT100PIS")
						SE2->E2_PIS := ExecBlock( "MT100PIS",.F.,.F.,{SE2->E2_PIS})
					EndIf					
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Proporcionalizacao da base do PIS pela duplicata                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SE2->(FieldPos("E2_BASEPIS")) > 0                    
						If nX == nMaxFor
							SE2->E2_BASEPIS := nSaldoPis						
						Else
							SE2->E2_BASEPIS := nBasePis * aProp[nX]
							nSaldoPis -= SE2->E2_BASEPIS					
						Endif	
					Endif
					
				EndIf
				
				IF nPCOFINS > 0
					SE2->E2_COFINS  := aColsSE2[nX][nPCOFINS]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para calculo do COFINS                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("MT100COF")
						SE2->E2_COFINS := ExecBlock( "MT100COF",.F.,.F.,{SE2->E2_COFINS})
					EndIf										
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Proporcionalizacao da base do COFINS pela duplicata               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SE2->(FieldPos("E2_BASECOF")) > 0                    
						If nX == nMaxFor
							SE2->E2_BASECOF := nSaldoCof
						Else
							SE2->E2_BASECOF := nBaseCof * aProp[nX]
							nSaldoCof -= SE2->E2_BASECOF
						Endif	
					Endif
					
				EndIf 
				
				If nPCSll > 0
					SE2->E2_CSLL    := aColsSE2[nX][nPCSLL]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para calculo do CSLL                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("MT100CSL")
						SE2->E2_CSLL := ExecBlock( "MT100CSL",.F.,.F.,{SE2->E2_CSLL})
					EndIf					

					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Proporcionalizacao da base do CSLL pela duplicata                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SE2->(FieldPos("E2_BASECSL")) > 0                    
						If nX == nMaxFor
							SE2->E2_BASECSL := nSaldoCsl
						Else
							SE2->E2_BASECSL := nBaseCsl * aProp[nX]
							nSaldoCsl -= SE2->E2_BASECSL
						Endif	
					Endif
					
				EndIf

				SE2->E2_VALOR   := aColsSE2[nX][nPValor]-nValFun-SE2->E2_IRRF-SE2->E2_ISS-SE2->E2_INSS
				SE2->E2_SALDO   := aColsSE2[nX][nPValor]-nValFun-SE2->E2_IRRF-SE2->E2_ISS-SE2->E2_INSS
				
				lRestValImp := .F.
				
				If lContrRet

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava a Marca de "pendente recolhimento" dos demais registros    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					If ( !Empty( SE2->E2_PIS ) .Or. !Empty( SE2->E2_COFINS ) .Or. !Empty( SE2->E2_CSLL ) ) 
						SE2->E2_PRETPIS := "1"
						SE2->E2_PRETCOF := "1"
						SE2->E2_PRETCSL := "1"
					EndIf	
					
					Do Case 
					Case cModRetPIS == "1" 

						nVlRetPIS := 0
						nVlRetCOF := 0
						nVlRetCSLL:= 0 
					
						aDadosRet := NfeCalcRet( SE2->E2_VENCREA, nIndexSE2 )
                 
						lRetParc := .F. 

						If aDadosRet[ 6 ] > nValMinRet  // PIS 
							lRetParc := .T. 
							nVlRetPIS  := aDadosRet[ 2 ] 
						EndIf 

						If aDadosRet[ 7 ] > nValMinRet  // COFINS 
							lRetParc := .T. 
							nVlRetCOF  := aDadosRet[ 3 ] 
						EndIf 
      
						If aDadosRet[ 8 ] > nValMinRet  // CSLL
							lRetParc := .T. 
							nVlRetCSLL := aDadosRet[ 4 ]
						EndIf 

						If lRetParc 							
						
							nTotARet := nVlRetPIS + nVlRetCOF + nVlRetCSLL
							
							nSobra := SE2->E2_VALOR - nTotARet
						
							If nSobra < 0                                                           

								nSavRec := SE2->( Recno() ) 
							
								nFatorRed := 1 - ( Abs( nSobra ) / nTotARet ) 
								
		 						nVlRetPIS  := NoRound( nVlRetPIS * nFatorRed, 2 ) 
		 						nVlRetCOF  := NoRound( nVlRetCOF * nFatorRed, 2 )  						
			 						
		 						nVlRetCSLL := SE2->E2_VALOR - ( nVlRetPIS + nVlRetCOF ) 

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava o valor de NDF caso a retencao seja maior   ³
								//³ que o valor do titulo                             ³							
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If FindFunction("ADUPCREDRT")								
									ADupCredRt(Abs(nSobra),"501",SE2->E2_MOEDA)
								Endif	
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Restaura o registro do titulo original            ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								SE2->( MsGoto( nSavRec ) ) 								
								
								Reclock( "SE2", .F. ) 								
							
							EndIf 

							lRestValImp := .T.

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Guarda os valores originais                           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nRetOriPIS  := SE2->E2_PIS 
							nRetOriCOF  := SE2->E2_COFINS 
							nRetOriCSLL := SE2->E2_CSLL  
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava os novos valores de retencao para este registro ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SE2->E2_PIS    := nVlRetPIS 					
							SE2->E2_COFINS := nVlRetCOF 										
							SE2->E2_CSLL   := nVlRetCSLL 										
					
							nSavRec := SE2->( Recno() ) 
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Exclui a Marca de "pendente recolhimento" dos demais registros   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aRecnos := aClone( aDadosRet[ 5 ] ) 

							cPrefOri  := SE2->E2_PREFIXO
							cNumOri   := SE2->E2_NUM
							cParcOri  := SE2->E2_PARCELA
							cTipoOri  := SE2->E2_TIPO
							cCfOri    := SE2->E2_FORNECE
							cLojaOri  := SE2->E2_LOJA
							
							For nLoop := 1 to Len( aRecnos )
							
								SE2->( dbGoto( aRecnos[ nLoop ] ) )
								
								RecLock( "SE2", .F. ) 
								
		                        If !Empty( nVlRetPIS ) 
		                           SE2->E2_PRETPIS := "2"
		                        EndIf
		
		                        If !Empty( nVlRetCOF ) 
		                           SE2->E2_PRETCOF := "2"
		                        EndIf
		
		                        If !Empty( nVlRetCSLL ) 
		                           SE2->E2_PRETCSL := "2"
		                        EndIf 
										
								SE2->( MsUnlock() )  																								

								If AliasIndic("SFQ")
									If nSavRec <> aRecnos[ nLoop ] 
										dbSelectArea("SFQ")
										RecLock("SFQ",.T.)
											SFQ->FQ_FILIAL  := xFilial("SFQ")
											SFQ->FQ_ENTORI  := "SE2"
											SFQ->FQ_PREFORI := cPrefOri
											SFQ->FQ_NUMORI  := cNumOri
											SFQ->FQ_PARCORI := cParcOri
											SFQ->FQ_TIPOORI := cTipoOri										
											SFQ->FQ_CFORI   := cCfOri
											SFQ->FQ_LOJAORI := cLojaOri
											
											SFQ->FQ_ENTDES  := "SE2"
											SFQ->FQ_PREFDES := SE2->E2_PREFIXO
											SFQ->FQ_NUMDES  := SE2->E2_NUM
											SFQ->FQ_PARCDES := SE2->E2_PARCELA                             
											SFQ->FQ_TIPODES := SE2->E2_TIPO
											SFQ->FQ_CFDES   := SE2->E2_FORNECE
											SFQ->FQ_LOJADES := SE2->E2_LOJA
											
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Grava a filial de destino caso o campo exista                    ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If !Empty( SFQ->( FieldPos( "FQ_FILDES" ) ) ) 
												SFQ->FQ_FILDES := SE2->E2_FILIAL 
											EndIf 											
											
										MsUnlock()
									Endif								
								Endif					
						
							Next nLoop 
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Retorna do ponteiro do SE1 para a parcela         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SE2->( MsGoto( nSavRec ) ) 
							Reclock( "SE2", .F. ) 
						
						Else 	
							lRetParc := .F. 							  	
						EndIf
			      
		  			Case cModRetPIS == "2" 
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Efetua a retencao                                                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lRetParc := .T.
					Case cModRetPIS == "3" 			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Nao efetua a retencao                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lRetParc := .F.
					EndCase 			
				Else 
					lRetParc := .T. 
				EndIf 					
				
				If SE2->(FieldPos("E2_PIS"))<>0 .And. lRetParc
					SE2->E2_VALOR   -= SE2->E2_PIS
					SE2->E2_SALDO   -= SE2->E2_PIS
					nVlCruz         -= SE2->E2_PIS
				EndIf
				If SE2->(FieldPos("E2_COFINS"))<>0 .And. lRetParc
					SE2->E2_VALOR   -= SE2->E2_COFINS
					SE2->E2_SALDO   -= SE2->E2_COFINS
					nVlCruz         -= SE2->E2_COFINS					
				EndIf
				If SE2->(FieldPos("E2_CSLL"))<>0 .And. lRetParc  
					SE2->E2_VALOR   -= SE2->E2_CSLL
					SE2->E2_SALDO   -= SE2->E2_CSLL
					nVlCruz         -= SE2->E2_CSLL					
				EndIf				
			Else
				SE2->E2_VALOR   := aColsSE2[nX][nPValor]
				SE2->E2_SALDO   := aColsSE2[nX][nPValor]
			EndIf
			FaAvalSE2(1,"MatA100",(nX==1),MaFisRet(,"NF_VALIRR"),MaFisRet(,"NF_VALINS"),lRetParc,MaFisRet(,"NF_VALISS"))
			
			If lRestValImp 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Restaura os valores originais de PIS / COFINS / CSLL  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SE2->E2_PIS    := nRetOriPIS 
				SE2->E2_COFINS := nRetOriCOF
				SE2->E2_CSLL   := nRetOriCSLL 
			EndIf			          
			
			SE2->E2_VLCRUZ := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,NIL,SF1->F1_TXMOEDA)
			nVlCruz -= SE2->E2_VLCRUZ+(nValFun+SE2->E2_IRRF+SE2->E2_ISS+SE2->E2_INSS)
			If nX == nMaxFor
				SE2->E2_VLCRUZ += nVlCruz
			EndIf			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ha necessidade da gravacao das multiplas naturezas    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRateio := 0
			For nY := 1 To Len(aColsSEV)
				If !aColsSEV[nY][Len(aColsSEV[1])] .And. !Empty(aColsSEV[nY][1])
					SE2->E2_MULTNAT := "1"
					RecLock("SEV", .T. )
					For nZ := 1 To Len(aHeadSEV)
						If aHeadSEV[nZ][10]<>"V"
							SEV->(FieldPut(FieldPos(aHeadSEV[nZ][2]),aColsSEV[nY][nZ]))
						EndIf
					Next nZ
					SEV->EV_FILIAL   := xFilial("SEV")
					SEV->EV_PREFIXO  := SE2->E2_PREFIXO
					SEV->EV_NUM      := SE2->E2_NUM
					SEV->EV_PARCELA  := SE2->E2_PARCELA
					SEV->EV_CLIFOR   := SE2->E2_FORNECE
					SEV->EV_LOJA     := SE2->E2_LOJA
					SEV->EV_TIPO     := SE2->E2_TIPO
					SEV->EV_VALOR    := IIf(nY==Len(aColsSEV),SE2->E2_VALOR-nValFun-nRateio,NoRound(SE2->E2_VALOR*SEV->EV_PERC/100,2))
					SEV->EV_PERC     := SEV->EV_PERC/100
					SEV->EV_RECPAG   := "P"
					SEV->EV_LA       := ""
					SEV->EV_IDENT    := "1"
					nRateio += SEV->EV_VALOR
					nRateioSEZ := 0
					For nZ := 1 To Len(aSEZ)
						SEV->EV_RATEICC := "1"
						RecLock("SEZ",.T.)
						SEZ->EZ_FILIAL := xFilial("SEZ")
						SEZ->EZ_PREFIXO:= SEV->EV_PREFIXO
						SEZ->EZ_NUM    := SEV->EV_NUM
						SEZ->EZ_PARCELA:= SEV->EV_PARCELA
						SEZ->EZ_CLIFOR := SEV->EV_CLIFOR
						SEZ->EZ_LOJA   := SEV->EV_LOJA
						SEZ->EZ_TIPO   := SEV->EV_TIPO
						SEZ->EZ_PERC   := aSEZ[nZ][4]
						SEZ->EZ_VALOR  := IIf(nZ==Len(aSEZ),SEV->EV_VALOR-nRateioSEZ,NoRound(SEV->EV_VALOR*SEZ->EZ_PERC,2))
						SEZ->EZ_NATUREZ:= SEV->EV_NATUREZ
						SEZ->EZ_CCUSTO := aSEZ[nZ][1]
						SEZ->EZ_ITEMCTA:= aSEZ[nZ][2]
						SEZ->EZ_CLVL   := aSEZ[nZ][3]
						SEZ->EZ_RECPAG := SEV->EV_RECPAG
						SEZ->EZ_LA     := ""
						SEZ->EZ_IDENT  := SEV->EV_IDENT
						SEZ->EZ_SEQ    := SEV->EV_SEQ
						SEZ->EZ_SITUACA:= SEV->EV_SITUACA
						nRateioSEZ += SEZ->EZ_VALOR
						MsUnLock()
					Next nZ					
				EndIf
			Next nY			

	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Template acionando ponto de entrada                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistTemplate("MT100GE2")
				ExecTemplate("MT100GE2",.F.,.F.)
			EndIf			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada apos a gravacao do titulo a pagar                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Existblock("MT100GE2")
				ExecBlock("MT100GE2",.F.,.F.)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ O funrural somente deve ser gerado para a primeira parcela        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			nValFun	:= 0
		EndIf
	Next nX
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorno dos titulos a pagar                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFAULT aRecSE2 := {}
	For nX := 1 To Len(aRecSE2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorno dos titulos financeiros                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")
		MsGoto(aRecSE2[nX])	

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Template acionando ponto de entrada                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistTemplate("M103DSE2")
			ExecTemplate("M103DSE2",.F.,.F.)
		EndIf			

		If (Existblock("M103DSE2"))
			ExecBlock("M103DSE2",.F.,.F.)
		EndIf
		RecLock("SE2",.F.)
		dbDelete()
		FaAvalSE2(2,"MatA100")
		FaAvalSE2(3,"MatA100")
	Next nX
EndIf
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103RatVEI³ Autor ³Patricia A. Salomao     ³ Data ³19.11.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta a tela rateios por Veiculo/Viagem                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103 / MATA240 / MATA241                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a103RatVei()

Local bSavKeyF4   := SetKey(VK_F4,Nil)
Local bSavKeyF5   := SetKey(VK_F5,Nil)
Local bSavKeyF6   := SetKey(VK_F6,Nil)
Local bSavKeyF7   := SetKey(VK_F7,Nil)
Local bSavKeyF8   := SetKey(VK_F8,Nil)
Local bSavKeyF9   := SetKey(VK_F9,Nil)
Local bSavKeyF10  := SetKey(VK_F10,Nil)
Local bSavKeyF11  := SetKey(VK_F11,Nil)
Local aSavaRotina	:= aClone(aRotina)
Local nOpc			:= 0
Local nY,nT
Local oDlg, oGetDados
Local nPosItem	
Local nPosRat		
Local nPosRatFro
Local nItem
Local nOpcx              
Local cCposSDG       := ""
Private aSavCols	   := {}
Private aSavHeader   := {}
Private nSavN		   := 0
Private nTotValor    := 0
Private M->DG_CODDES := CriaVar("DG_CODDES")  //-- Esta variavel e' utilizada pelo programa TMSA070                        

If l240 .Or. l241
	nPosItem	     := If(l241,StrZero(n,Len(SDG->DG_ITEM)),StrZero(1,Len(SDG->DG_ITEM)) )
	nPosRat	     := aScan(aRatVei,{|x| x[1] == nPosItem })
	nPosRatFro    := aScan(aRatFro,{|x| x[1] == nPosItem })		
	nItem         := nPosItem
Else
	nPosItem	     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM" })
	nPosRat	     := aScan(aRatVei,{|x| x[1] == aCols[n][nPosItem] })
	nPosRatFro    := aScan(aRatFro,{|x| x[1] == aCols[n][nPosItem] })
	nItem         := aCols[n][nPosItem]
EndIf

If !l240
	aSavCols 	:= aClone(aCols)
	aSavHeader	:= aClone(aHeader)
	nSavN	  	   := n
EndIf

If nPosRatFro > 0
	For nY := 1 To Len(aRatFro)
		If aRatFro[nY][1] == nItem
			For nT := 1 to Len(aRatFro[nY][2])
				If !aRatFro[nY][2][nT] [Len(aRatFro[nY][2][nT])] //Verifica se nao esta deletado
					Help(" ",1,"A103RATFRO") // "Foi Informado Rateio por Frota"
					SetKey(VK_F4,bSavKeyF4)
					SetKey(VK_F5,bSavKeyF5)
					SetKey(VK_F6,bSavKeyF6)
					SetKey(VK_F7,bSavKeyF7)
					SetKey(VK_F8,bSavKeyF8)
					SetKey(VK_F9,bSavKeyF9)
					SetKey(VK_F10,bSavKeyF10)
					SetKey(VK_F11,bSavKeyF11)				   					
					Return
				EndIf
			Next nT
		EndIf
	Next	
EndIf	

n        := 1
aCols	   := {}
aHeader	:= {}
aRotina[2][4]	:= 2
aRotina[3][4]	:= 3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCposSDG := "DG_ITEM|DG_CODVEI|DG_FILORI|DG_VIAGEM|DG_TOTAL"
If Inclui //-- Estes campos so' deverao ser mostrados na inclusao do Rateio
	cCposSDG += "|DG_COND|DG_NUMPARC|DG_PERVENC"
EndIf

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SDG")
While !EOF() .And. (x3_arquivo == "SDG")
	IF X3USO(x3_usado) .And. cNivel >= x3_nivel .And. Alltrim(x3_campo)$ cCposSDG
	   //-- Altera o Valid do campo DG_CODVEI
	   If AllTrim(X3_CAMPO) == 'DG_CODVEI' .And. !("TMSA070VAL"$UPPER(X3_VALID))
	      RecLock('SX3',.F.)
	      SX3->X3_VALID := "(Vazio() .Or. ExistCpo('DA3')) .And. TMSA070Val()"
	      MsUnLock()
	   EndIf   	
		AADD(aHeader,{ TRIM(x3titulo()), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo,x3_context } )
	EndIf
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do Array aRatVei:                              ³
//³ aRatVei[n,1] - Item da Nota                              ³
//³ aRatVei[n,2] - aCols do Rateio de Veiculo/Viagem         ³
//³ aRatVei[n,3] - Codigo da Despesa de Transporte           ³		 
//³ aRatVei[n,4] - Valor Total informado no Rateio           ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    	
If nPosRat > 0
	aCols	     := aClone(aRatVei[nPosRat][2])
	M->DG_CODDES := aRatVei[nPosRat][3]
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem de uma linha em branco no aCols.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCols,Array(Len(aHeader)+1))
	For ny := 1 to Len(aHeader)
		If Trim(aHeader[ny][2]) == "DG_ITEM"
			aCols[1][ny] 	:= "01"
		Else
			aCols[1][ny] := CriaVar(aHeader[ny][2])
		EndIf
		aCols[1][Len(aHeader)+1] := .F.
	Next ny
EndIf

If !(Type('l103Auto') <> 'U' .And. l103Auto)
	DEFINE MSDIALOG oDlg TITLE STR0120 Of oMainWnd PIXEL  FROM 94 ,104 TO 330,590 //'Rateio por Veiculo/Viagem'
	If l240 .Or. l241     	
		nOpcx := IIf(Inclui,3,2)		
		@ 18,3   SAY STR0121  Of oDlg PIXEL SIZE 56 ,9 //"Codigo da Despesa : "
		@ 18,60 MSGET M->DG_CODDES  Picture PesqPict("SDG","DG_CODDES") F3 CpoRetF3('DG_CODDES');
			When Inclui Valid CheckSX3('DG_CODDES',M->DG_CODDES) ; 		
			OF oDlg PIXEL SIZE 60 ,9							   		  		  	
		oGetDados := MSGetDados():New(32,2,113,243,nOpcx,'A103VeiLOK()','A103VeiTOK()','+DG_ITEM',.T.,,,,100,,,,If(nOpcx==2,"AlwaysFalse",NIL))		
	Else	
		@ 18 ,3   SAY OemToAnsi(STR0072) Of oDlg PIXEL SIZE 56 ,9 //"Documento : "
		@ 18 ,96  SAY OemToAnsi(STR0073) Of oDlg PIXEL SIZE 20 ,9 //"Item :"
		@ 18 ,36  SAY cSerie+" "+cNFiscal Of oDlg PIXEL SIZE 70 ,9
		@ 18 ,115 SAY aSavCols[nSavN][nPosItem] Of oDlg PIXEL SIZE 37 ,9
		@ 28,3   SAY STR0121  Of oDlg PIXEL SIZE 56 ,9 //"Codigo da Despesa : "
		@ 28,60 MSGET M->DG_CODDES  Picture PesqPict(STR0122,"DG_CODDES") F3 CpoRetF3('DG_CODDES'); //"SDG"
			When !l103Visual  Valid CheckSX3('DG_CODDES',M->DG_CODDES) ; 		
			OF oDlg PIXEL SIZE 60 ,9							   		  		
		oGetDados := MSGetDados():New(45,2,113,243,IIF(l103Visual,2,3),'A103VeiLOK()','A103VeiTOK()','+DG_ITEM',.T.,,,,100,,,,If(l103Visual,"AlwaysFalse",NIL))		  			
	EndIf	

	ACTIVATE MSDIALOG oDlg ON INIT (oGetdados:Refresh(),EnchoiceBar(oDlg,   {||IIF(oGetDados:TudoOk(),(nOpc:=1,oDlg:End()),(nOpc:=0))},{||oDlg:End()}) )
Else
	nOpc := 1
EndIf

If nOpc == 1 .And. IIf(l240 .Or. l241, nOpcx<>2, !l103Visual)
	If nPosRat > 0
		aRatVei[nPosRat][2]	:= aClone(aCols)
		aRatVei[nPosRat][3]	:= 	M->DG_CODDES	
	Else
		aADD(aRatVei,{ IIf( l240.Or.l241,nPosItem,aSavCols[nSavN][nPosItem] ) , aClone(aCols), M->DG_CODDES, nTotValor })
	EndIf
EndIf

aRotina	:= aClone(aSavaRotina)
aCols	   := aClone(aSavCols)
aHeader	:= aClone(aSavHeader)
n		   := nSavN

SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103VeiLOk³ Autor ³Patricia A. Salomao     ³ Data ³18.06.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a Linha Digitada                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103 / MATA240 / MATA241                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103VeiLOk()
Local lRet := .T.

If !GdDeleted(n)

	//-- Analisa se ha itens duplicados na GetDados.
	If Inclui
		lRet := GDCheckKey( { "DG_CODVEI","DG_FILORI","DG_VIAGEM" }, 4 )
	EndIf
                                       
   If lRet 
		If (Empty(GdFieldGet('DG_CODVEI',n)) .And. Empty(GdFieldGet('DG_VIAGEM',n))) .Or. ;
				Empty(GdFieldGet('DG_TOTAL',n) )
	   	Return ( .F. )
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida se o veiculo informado esta amarrado na viagem, caso a mesma seja informada. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(GdFieldGet('DG_CODVEI',n)) .And. !Empty(GdFieldGet('DG_VIAGEM',n))
			Help(' ', 1, 'A103VEISAM') // Nao podem ser informados simultaneamente  os campos de veiculo e viagem.
	   	Return ( .F. )
		EndIf
	EndIf

EndIf	

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103VeiTOk³ Autor ³Patricia A. Salomao     ³ Data ³19.11.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³TudOk da GetDados da Tela de rateios por Veiculo/Viagem      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103 / MATA240 / MATA241                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103VeiTOk()
Local nx:=0
Local nPosValor  := Ascan(aHeader,{|x| Alltrim(x[2]) == "DG_TOTAL" })
Local nPosCodVei := Ascan(aHeader,{|x| Alltrim(x[2]) == "DG_CODVEI"})
Local nPosViagem := Ascan(aHeader,{|x| Alltrim(x[2]) == "DG_VIAGEM"})
Local lRet       := .T.
Local nPosValRat := 0

nTotValor := 0
For nx := 1 to Len(aCols)
	If !GdDeleted(nx)
		nTotValor += aCols[nx][nPosValor]
	EndIf
Next                                                               
	
If !l240 .And. !l241
	nPosValRat  := Ascan(aSavHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"} )	
	If nTotValor > 0 .And. nTotValor <> aSavCols[nSavN][nPosValRat]
		Help(' ', 1, 'A103TOTRAT') // Valor a ser rateado nao confere com o total.
		lRet := .F.
	EndIf
EndIf

If lRet .And. !GdDeleted(n) .And. Empty(aCols[n][nPosCodVei]) .And. Empty(aCols[n][nPosViagem])
	Help(' ', 1, 'A103VEVIVA') // Os Campos de Veiculo e Viagem estao Vazios.
	lRet := .F.	
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103Frota ³ Autor ³Patricia A. Salomao     ³ Data ³20.11.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta a tela de rateio por Frota                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103 / MATA240 / MATA241                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function a103Frota()
Local oDlg
Local nY,nT
Local aRet          := {}
Local nOpc		     := 0
Local nPosItem		  := 0
Local nPosValor  	  := 0
Local nPosRat		  := 0
Local nPosRatVei    := 0
Local nItem         := 0
Private M->DG_CODDES:= CriaVar("DG_CODDES") //-- Esta variavel e' utilizada pelo programa TMSA070

If l240 .Or. l241
	nPosItem	     := If(l241,StrZero(n,Len(SDG->DG_ITEM)),StrZero(1,Len(SDG->DG_ITEM)) )
	nPosRat	     := aScan(aRatFro,{|x| x[1] == nPosItem })
	nPosRatVei    := aScan(aRatVei,{|x| x[1] == nPosItem })	
	nItem         := nPosItem
	nPosValor     := 100
Else
	nPosItem	     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM" })
	nPosRat	     := aScan(aRatFro,{|x| x[1] == aCols[n][nPosItem] })
	nPosRatVei    := aScan(aRatVei,{|x| x[1] == aCols[n][nPosItem]})
	nItem         := aCols[n][nPosItem]
	nPosValor     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"} )		
EndIf

If nPosRatVei > 0
	For nY := 1 To Len(aRatVei)
		If aRatVei[nY][1] == nItem
			For nT := 1 to Len(aRatVei[nY][2])
				If !aRatVei[nY][2][nT] [Len(aRatVei[nY][2][nT])] //Verifica se nao esta deletado
					Help("",1,"A103RATVEI") // "Foi Informado Rateio por Veiculo/Viagem"				
					Return
				EndIf
			Next nT
		EndIf
	Next		
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do Array aRatFro:                              ³
//³ aRatFro[n,1] - Item da Nota                              ³
//³ aRatFro[n,2] - aCols do Rateio de Frota                  ³
//³ aRatFro[n,3] - Codigo da Despesa de Transporte           ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    	
If nPosRat > 0
	aRet	 := aClone(aRatFro[nPosRat][2])
	M->DG_CODDES := aRatFro[nPosRat][3]	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem de uma linha em branco no aCols.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd(aRet,{"01",IIf(l240 .Or.  l241, nPosValor,aCols[n][nPosValor]),.F.})
EndIf

If !(Type('l103Auto') <> 'U' .And. l103Auto)
	DEFINE MSDIALOG oDlg TITLE STR0123 Of oMainWnd PIXEL FROM 94 ,104 TO 200,400 //'Rateio por Frota'
	If l240 .Or. l241	
		@ 20,3   SAY STR0121  Of oDlg PIXEL SIZE 56 ,9 //"Codigo da Despesa : "
		@ 20,60 MSGET M->DG_CODDES  Picture PesqPict("SDG","DG_CODDES") F3 CpoRetF3('DG_CODDES');
			When Inclui Valid CheckSX3('DG_CODDES',M->DG_CODDES) ; 		
			OF oDlg PIXEL SIZE 60 ,9							   		  		  	
	Else		
		@ 18 ,3   SAY OemToAnsi(STR0072) Of oDlg PIXEL SIZE 56 ,9 //"Documento : "
		@ 18 ,96  SAY OemToAnsi(STR0073) Of oDlg PIXEL SIZE 20 ,9 //"Item :"
		@ 18 ,36  SAY cSerie+" "+cNFiscal Of oDlg PIXEL SIZE 70 ,9
		@ 18 ,115 SAY aCols[n][nPosItem] Of oDlg PIXEL SIZE 37 ,9
		@ 30,3   SAY STR0121  Of oDlg PIXEL SIZE 56 ,9 //"Codigo da Despesa : "
		@ 30,60 MSGET M->DG_CODDES  Picture PesqPict("SDG","DG_CODDES") F3 CpoRetF3('DG_CODDES');
			When !l103Visual  Valid CheckSX3('DG_CODDES',M->DG_CODDES) ; 		
			OF oDlg PIXEL SIZE 60 ,9							   		  		
	EndIf	
	ACTIVATE MSDIALOG oDlg    ON INIT EnchoiceBar(oDlg,{||(nOpc:=1,oDlg:End())},{||oDlg:End()} )
Else
	nOpc := 1
EndIf
If nOpc == 1
	If nPosRat > 0
		aRatFro[nPosRat][2]	:= aClone(aRet)
		aRatFro[nPosRat][3]	:= M->DG_CODDES
	Else
		AAdd(aRatFro,{ IIf( l240.Or.l241,nPosItem,aCols[n][nPosItem] ) , aClone(aRet), M->DG_CODDES })		
	EndIf
EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103GrvSDG³ Autor ³Patricia A. Salomao     ³ Data ³20.11.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava no SDG o Rateio por Veiculo/Viagem e o Rateio por Frota³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1- Alias do Arquivo                                      ³±± 
±±³          ³ExpA1- Array contendo os Rateios informados na Tela de Rateio³±±
±±³          ³ExpC2- Tipo do Rateio (V=Veiculo/Viagem ; F=Frota)           ³±±
±±³          ³ExpC3- Item do SD1 ou SD3 que esta sendo gravado             ³±±
±±³          ³ExpL1- Lancamento Contabil OnLine (mv_par06)                 ³±±
±±³          ³ExpN1- Cabecalho do Lancamento Contabil                      ³±±
±±³          ³ExpN2- Total do Lancamento Contabil (@)                      ³±±
±±³          ³ExpC4- Lote para Lancamento Contabil                         ³±±
±±³          ³ExpC5- Programa que esta executando a funcao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103 / MATA240 / MATA241                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103GrvSDG(cAlias,aArraySDG,cTpRateio,cItem,lCtbOnLine,nHdlPrv,nTotalLcto,cLote,cProg)

Local nValRat    := 0
Local aCustoVei  := {} 
Local aRecSDGBai := {}
Local aRecSDGEmi := {}
Local nW,nT,cCodDesp,cDoc
Local aParcelas  := {}
Local nParcela   := 0
Local nPerVenc   := 0
Local dDataVenc  := dDataBase
Local nCnt       := 0
Local cCond      := ""
Local cCodVei    := ""
Local cFilOri    := ""
Local cViagem    := ""
Local lBaixa     := .F.
Local lMovim     := .F.
Local nValCob    := 0
Local nTotValCob := 0
Local nSbCusto1  := 0
Local nValTotRat := 0
Local nPerc      := 0
Local nTotPerc   := 0
Local nSbCusto2  := 0
Local nSbCusto3  := 0
Local nSbCusto4  := 0
Local nSbCusto5  := 0
Local nCntFor    := 0
Local nDecCusto1 := TamSx3("DG_CUSTO1")[2]
Local nDecCusto2 := TamSx3("DG_CUSTO2")[2]
Local nDecCusto3 := TamSx3("DG_CUSTO3")[2]
Local nDecCusto4 := TamSx3("DG_CUSTO4")[2]
Local nDecCusto5 := TamSx3("DG_CUSTO5")[2]
Local nDecValCob := TamSx3("DG_VALCOB")[2]
Local nDecPerc   := TamSx3("DG_PERC")[2]
DEFAULT aArraySDG  := {}
DEFAULT cTpRateio  := ""
DEFAULT nTotalLcto := 0 
DEFAULT lCtbOnLine := .F.
DEFAULT nHdlPrv    := 0
DEFAULT cLote      := ""
DEFAULT cProg      := "MATA103"

For nW := 1 to Len(aArraySDG)			    					        				
	cCodDesp := aArraySDG[nW][3] //-- Despesa                            
	cDoc     := NextNumero("SDG",1,"DG_DOC",.T.)	
	If cTpRateio=="V"
		nValTotRat := aArraySDG[nW][4] //-- Valor Total do Rateio
	Else
		nValTotRat := IIf(cAlias=="SD1", SD1->D1_TOTAL, SD3->D3_CUSTO1) 
	EndIf	
	For  nT:=1 to Len(aArraySDG[nW][2])
		If aArraySDG[nW][1] == cItem .And. !(aArraySDG[nW][2][nT] [Len(aArraySDG[nW][2][nT])]) // Verifica se esta deletado
			aCustoVei  := Array(6)
			If cTpRateio=="V"
				cCodVei  := aArraySDG[nW][2][nT][2] //-- Codigo Veiculo
				cFilOri  := aArraySDG[nW][2][nT][3] //-- Filial Origem
				cViagem  := aArraySDG[nW][2][nT][4] //-- Viagem
				cCond    := aArraySDG[nW][2][nT][6] //-- Condicao
				nParcela := aArraySDG[nW][2][nT][7] //-- Numero Parcelas
				nPerVenc := aArraySDG[nW][2][nT][8] //-- Periodo Vencimento
			EndIf                                                  
			If cAlias == 'SD1'
				nValRat := If(cTpRateio=="V",aArraySDG[nW][2][nT][5], SD1->D1_TOTAL ) //-- Valor do Rateio			
				lMovim  := .F.
			ElseIf cAlias == 'SD3'
				nValRat := If(cTpRateio=="V",aArraySDG[nW][2][nT][5], SD3->D3_CUSTO1 ) //-- Valor do Rateio
				lMovim  := .T.	         
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o arquivo SDG - Movim. de Custo de Transporte (Integracao TMS) ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//-- Retorna a quantidade de parcelas
			aParcelas := {}
			If cTpRateio == "V"
				If !Empty(cCond)
					aParcelas:= Condicao(nValRat,cCond)
				Else					
					nParcela  := Iif(nParcela==0,1,nParcela) //-- Inicializa o numero de parcelas
					nDataVenc := dDataBase
					For nCnt := 1 To nParcela
						dDataVenc := dDataVenc + nPerVenc	
						Aadd( aParcelas, { dDataVenc, nValRat / nParcela } )
					Next nCnt
				EndIf
			Else
				Aadd( aParcelas, { dDataBase, nValRat } )
			EndIf
                                                            
       	nPerc        := Round( (nValRat / nValTotRat) * 100, nDecPerc )    //-- Percentual Total do Item         
			aCustoVei[6] := Round( nPerc / Len(aParcelas ) , nDecPerc ) //-- Percentual de cada Parcela do item                                                                                   
                                                                                
         If cAlias == 'SD1'
				//-- Armazena o Total do custo
				nSbCusto1 := ( ( SD1->D1_CUSTO  * nPerc ) / 100 )
				nSbCusto3 := ( ( SD1->D1_CUSTO2 * nPerc ) / 100 )
				nSbCusto4 := ( ( SD1->D1_CUSTO3 * nPerc ) / 100 )
				nSbCusto5 := ( ( SD1->D1_CUSTO4 * nPerc ) / 100 )
				nSbCusto5 := ( ( SD1->D1_CUSTO5 * nPerc ) / 100 )

				//-- Rateio das parcelas
				aCustoVei[1] := Round( ( (SD1->D1_CUSTO  * nPerc) / 100 ) / Len(aParcelas), nDecCusto1 )
				aCustoVei[2] := Round( ( (SD1->D1_CUSTO2 * nPerc) / 100 ) / Len(aParcelas), nDecCusto2 )
				aCustoVei[3] := Round( ( (SD1->D1_CUSTO3 * nPerc) / 100 ) / Len(aParcelas), nDecCusto3 )
				aCustoVei[4] := Round( ( (SD1->D1_CUSTO4 * nPerc) / 100 ) / Len(aParcelas), nDecCusto4 )
				aCustoVei[5] := Round( ( (SD1->D1_CUSTO5 * nPerc) / 100 ) / Len(aParcelas), nDecCusto5 )
				
			Else 
			
				//-- Armazena o Total do custo
				nSbCusto1 := ( ( SD3->D3_CUSTO1 * nPerc ) / 100 )
				nSbCusto2 := ( ( SD3->D3_CUSTO2 * nPerc ) / 100 )
				nSbCusto3 := ( ( SD3->D3_CUSTO3 * nPerc ) / 100 )
				nSbCusto4 := ( ( SD3->D3_CUSTO4 * nPerc ) / 100 )
				nSbCusto5 := ( ( SD3->D3_CUSTO5 * nPerc ) / 100 )
	
				//-- Rateio das parcelas
				aCustoVei[1] := Round( ( (SD3->D3_CUSTO1 * nPerc)  / 100 ) / Len(aParcelas), nDecCusto1 )
				aCustoVei[2] := Round( ( (SD3->D3_CUSTO2 * nPerc)  / 100 ) / Len(aParcelas), nDecCusto2 )
				aCustoVei[3] := Round( ( (SD3->D3_CUSTO3 * nPerc)  / 100 ) / Len(aParcelas), nDecCusto3 )
				aCustoVei[4] := Round( ( (SD3->D3_CUSTO4 * nPerc)  / 100 ) / Len(aParcelas), nDecCusto4 )
				aCustoVei[5] := Round( ( (SD3->D3_CUSTO5 * nPerc)  / 100 ) / Len(aParcelas), nDecCusto5 )              			
			
			EndIf	
			                                                                                    
         nTotValCob   := nValRat  //-- Valor Total do Item 
			nValCob      := Round(nValRat / Len(aParcelas), nDecValCob ) //-- Valor de cada parcela 
			                                 			                            
         //-- E' necessario controlar a diferenca de arrendondamento no calculo do Percentual dos itens informados na Tela de Rateio 
         //-- ( a soma do percentual dos itens deve ser igual a 100%) e controlar a diferenca de arrendondamento no calculo do percentual
         //-- das parcelas de cada Item (a soma dos percentuais das parcelas tem que ser igual ao percentual Total do item)
			                            
			//-- Gravacao das parcelas
			For nCnt := 1 To Len(aParcelas)
				lBaixa := .F.
				//-- Atualiza os itens
				If Val(cNewItSDG) == 0
					cNewItSDG := aArraySDG[nW][2][nT][1] //-- Item
				Else
					cNewItSDG := Soma1(cNewItSDG)
					aArraySDG[nW][2][nT][1] := cNewItSDG
				EndIf                                                    
                                                             			                                               	 											         
				//-- Para evitar diferenca de arrendamento, armazena a sobra do rateio na ultima parcela
				If nCnt == Len(aParcelas)
					aCustoVei[1] := nSbCusto1
					aCustoVei[2] := nSbCusto2
					aCustoVei[3] := nSbCusto3
					aCustoVei[4] := nSbCusto4
					aCustoVei[5] := nSbCusto5         
					//-- Se for a Ultima Parcela do Ultimo Item
					If Len(aArraySDG[nW][2]) > 1 .And. nT == Len(aArraySDG[nW][2])                                                          	 
					   nPerc     := 100 - nTotPerc 	 					   				   
					Else
			         nTotPerc  += Round( nPerc, nDecPerc ) //-- Acumula os Percentuais calculados de todos os itens																			   
      		   EndIf					                
					aCustoVei[6] := nPerc			         		   					      		   
               nValCob      := nTotValCob
				Else
					nSbCusto1  -= aCustoVei[1]
					nSbCusto2  -= aCustoVei[2]
					nSbCusto3  -= aCustoVei[3]
					nSbCusto4  -= aCustoVei[4]
					nSbCusto5  -= aCustoVei[5]              
					nPerc      -= aCustoVei[6]              										
					nTotValCob -= nValCob                                 
		         nTotPerc += Round( aCustoVei[6], nDecPerc ) //-- Acumula os Percentuais calculados de todos os itens																			
				EndIf                
								
				//-- Grava o movimento de custo                       
				GravaSDG(cAlias,cTpRateio,aArraySDG[nW][2][nT],aCustoVei,cDoc,cCodDesp,lMovim,ProxNum(),aParcelas[nCnt,1],nValCob)
          
				If cTpRateio == "V"
					//-- Caso a viagem seja informada baixa o movimento de custo
					If !Empty(cFilOri) .And. !Empty(cViagem)
						lBaixa := .T.
					Else
						//-- Caso a veiculo seja proprio baixa o movimento de custo
						DA3->(DbSetOrder(1))
						If DA3->(MsSeek(xFilial("DA3")+cCodVei))
							If DA3->DA3_FROVEI == "1"
								lBaixa := .T.
							EndIf
						EndIf
					EndIf	
				Else
					lBaixa := .T.
				EndIf                                        
				//-- Baixa o movimento de custo de transporte
				If lBaixa
					TMSA070Bx("1",SDG->DG_NUMSEQ,SDG->DG_FILORI,SDG->DG_VIAGEM,SDG->DG_CODVEI,,,SDG->DG_VALCOB)
					If lCtbOnLine .And. SDG->(FieldPos('DG_DTLANC')) > 0  .And. SDG->DG_STATUS == StrZero(3,Len(SDG->DG_STATUS)) .And. Empty(SDG->DG_DTLANC)
						nTotalLcto += DetProva(nHdlPrv,"901",cProg,cLote)
					   AAdd(aRecSDGBai, SDG->(Recno()) )                 			
					EndIf													   								
				EndIf                                                                  
			   If lCtbOnLine .And. SDG->(FieldPos('DG_DTLAEMI')) > 0 
					nTotalLcto	+= DetProva(nHdlPrv,"903",cProg,cLote)  
				   AAdd(aRecSDGEmi, SDG->(Recno()) )                 																					 	
				EndIf	
			Next nCnt
		EndIf
	Next nT
Next nW		

For nCntFor := 1 To Len(aRecSDGBai)
	SDG->(dbGoTo(aRecSDGBai[nCntFor]))
	RecLock('SDG',.F.)
	SDG->DG_DTLANC  := dDataBase  //-- Data de lancamento contabil a partir da Baixa da Despesa
	MsUnLock()
Next

For nCntFor := 1 To Len(aRecSDGEmi)
	SDG->(dbGoTo(aRecSDGEmi[nCntFor]))
	RecLock('SDG',.F.)
	SDG->DG_DTLAEMI := dDataBase  //-- Data de lancamento contabil a partir da Inclusao da Despesa
	MsUnLock()
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³A103WMSOk ³ Autor ³Fernando Joly Siquini   ³ Data ³15.01.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida os campos referentes ao WMS na GetDados.              ³±±
±±³          ³Esta funcao tambem pode ser utilizada no X3_VALID dos campos ³±±
±±³          ³D1_SERVIC, D1_ENDER ou D1_TPESTR.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function A103WMSOk()

Local aAreaAnt   := {}
Local aAreaDC5   := {}
Local aAreaSBE   := {}
Local aAreaDC8   := {}
Local cCod       := ''
Local cArmazem   := ''
Local cServico   := ''
Local cEndereco  := ''
Local cEstrutura := ''
Local cWMSVar    := ''
Local cSeekDC8   := ''
Local cString    := ''
Local cMsg1      := STR0124 //'O campo'
Local cMsg2      := STR0125 //'deve ser preenchido'
Local cMsg3      := STR0126 //'quando se utiliza a integracao com o modulo de WMS.'
Local cMsgItem   := ''
Local cMsgItem1  := STR0127 //'(Item numero'
Local cMsgItem2  := STR0128 //'do Documento)'
Local lRet       := .T.
Local nPosCod    := 0
Local nPosArmaz  := 0
Local nPosServ   := 0
Local nPosEnd    := 0
Local nPosEst    := 0

While (IntDL().And.Type('aHeader')=='A'.And.Type('aCols')=='A'.And.Type('n')=='N'.And.!aCols[n,Len(aCols[n])])
	aAreaAnt := GetArea()
	aAreaDC5 := DC5->(GetArea())
	aAreaSBE := SBE->(GetArea())
	aAreaDC8 := DC8->(GetArea())
	cWMSVar  := ReadVar()
	cMsgItem := If(n>1,' '+cMsgItem1+' '+StrZero(n,TamSX3('D1_ITEM')[1])+' '+cMsgItem2,'')
	If !Empty(cWMSVar) .And. Upper(cWMSVar)$'M->D1_SERVIC/M->D1_ENDER/M->D1_TPESTR' //-- Quando a funcao for chamada pelo SX3
		If Empty(&(cWMSVar))
			Aviso('A103WMSOK1', cMsg1+' '+AllTrim(RetTitle(SubStr(cWMSVar,At('>',cWMSVar)+1)))+' '+cMsg2+' '+cMsg3+cMsgItem, {'Ok'})
			lRet := .F.
			Exit
		EndIf
		cCod       := If((nPosCod:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_COD'}))>0,aCols[n,nPosCod],'')
		cArmazem   := If((nPosArmaz:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_LOCAL'}))>0,aCols[n,nPosArmaz],'')
		cServico   := If('M->D1_SERVIC'$Upper(cWMSVar),&(cWMSVar),If((nPosServ:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_SERVIC'}))>0,aCols[n,nPosServ],''))
		cEndereco  := If('M->D1_ENDER'$Upper(cWMSVar),&(cWMSVar),If((nPosEnd:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_ENDER'}))>0,aCols[n,nPosEnd],''))
		cEstrutura := If('M->D1_TPESTR'$Upper(cWMSVar),&(cWMSVar),If((nPosEst:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_TPESTR'}))>0,aCols[n,nPosEst],''))
	Elseif Empty(cWMSVar) //-- Quando a funcao for chamada do A103LinOK
		cString := If((nPosCod:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_COD'}))==0.Or.(nPosCod>0.And.Empty(cCod:=aCols[n,nPosCod])),AllTrim(RetTitle('D1_COD')),'')
		cString += If((nPosArmaz:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_LOCAL'}))==0.Or.(nPosArmaz>0.And.Empty(cArmazem:=aCols[n,nPosArmaz])),If(!Empty(cString),', ','')+AllTrim(RetTitle('D1_LOCAL')),'')
		cString += If((nPosServ:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_SERVIC'}))==0.Or.(nPosServ>0.And.Empty(cServico:=aCols[n,nPosServ])),If(!Empty(cString),', ','')+AllTrim(RetTitle('D1_SERVIC')),'')
		cString += If((nPosEnd:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_ENDER'}))==0.Or.(nPosEnd>0.And.Empty(cEndereco:=aCols[n,nPosEnd])),If(!Empty(cString),', ','')+AllTrim(RetTitle('D1_ENDER')),'')
		cString += If((nPosEst:=aScan(aHeader,{|x|Alltrim(x[2])=='D1_TPESTR'}))==0.Or.(nPosEst>0.And.Empty(cEstrutura:=aCols[n,nPosEst])),If(!Empty(cString),', ','')+AllTrim(RetTitle('D1_TPESTR')),'')
		If !Empty(cServico) .And. !Empty(cString)
			If At(', ',cString) > 0
				cMsg1   := STR0129 //'Os campos'
				cMsg2   := STR0130 //'devem ser preenchidos'
				cString := Stuff(cString, RAt(', ', cString), (Len(STR0131)-1), STR0131) //' e '###' e '
			EndIf
			Aviso('A103WMSOK2', cMsg1+' '+cString+' '+cMsg2+' '+cMsg3+cMsgItem, {'Ok'})
			lRet := .F.
			Exit
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente a Prods que Controle Enderecamento e Servico atribuido³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(Localiza(cCod).And.!Empty(cServico))
		Exit
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida o Servico digitado, que deve ser do tipo "Entrada"     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cServico)
		dbSelectArea('DC5')
		dbSetOrder(1)
		If !(MsSeek(xFilial('DC5')+cServico, .F.).And.DC5_TIPO=='1')
			Aviso('A103WMSOK3', STR0132+cMsgItem, {'Ok'}) //'Somente Servicos de WMS do tipo "Entrada" podem ser utilizados.'
			lRet := .F.
			Exit
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se o Endereco digitado possui Estrura "BOX/DOCA"       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cArmazem) .And. !Empty(cEndereco)
		dbSelectArea('SBE')
		dbSetOrder(7)
		If !MsSeek(xFilial('SBE')+cArmazem+cEndereco, .F.)
			Aviso('A103WMSOK4', STR0133+AllTrim(cEndereco)+STR0134+cMsgItem, {'Ok'}) //'O Endereco '###' nao foi encontrado.'
			lRet := .F.
			Exit
		Else
			dbSelectArea('DC8')
			dbSetOrder(1)
			If !MsSeek(cSeekDC8:=xFilial('DC8')+SBE->BE_ESTFIS, .F.)
				Aviso('A103WMSOK5', STR0135+AllTrim(cEndereco)+STR0136+cMsgItem, {'Ok'}) //'A Estrutura Fisica do Endereco '###' nao foi encontrada.'
				lRet := .F.
				Exit
			Else
				Do While !Eof() .And. cSeekDC8==DC8_FILIAL+DC8_CODEST
					If DC8_LOCPAD==cArmazem .And. !(DC8_TPESTR=='5')
						Aviso('A103WMSOK6', STR0137+cMsgItem, {'Ok'}) //'Somente Enderecos pertencentes a Estruturas Fisicas do tipo BOX/DOCA podem ser utilizados.'
						lRet := .F.
						Exit
					EndIf
					dbSkip()
				EndDo
				If !lRet
					Exit
				EndIf
			EndIf
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida a Estrutura digitada, que deve ser do tipo "BOX/DOCA"  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cArmazem) .And. !Empty(cEstrutura)
		dbSelectArea('DC8')
		dbSetOrder(1)
		If !MsSeek(cSeekDC8:=xFilial('DC8')+cEstrutura, .F.)
			Aviso('A103WMSOK7', STR0138+AllTrim(cEstrutura)+STR0136+cMsgItem, {'Ok'}) //'A Estrutura Fisica '###' nao foi encontrada.'
			lRet := .F.
			Exit
		Else
			Do While !Eof() .And. cSeekDC8==DC8_FILIAL+DC8_CODEST
				If DC8_LOCPAD==cArmazem .And. !(DC8_TPESTR=='5')
					Aviso('A103WMSOK8', STR0139+cMsgItem, {'Ok'}) //'Somente Estruturas Fisicas do tipo BOX/DOCA podem ser utilizadas.'
					lRet := .F.
					Exit
				EndIf
				dbSkip()
			EndDo
			If !lRet
				Exit
			EndIf
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida a amarracao entre o Endereco e a Estrutura digitados   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cArmazem) .And. !Empty(cEndereco) .And. !Empty(cEstrutura)
		dbSelectArea('SBE')
		dbSetOrder(7)
		If !MsSeek(xFilial('SBE')+cArmazem+cEndereco+cEstrutura, .F.)
			Aviso('A103WMSOK9', STR0140+AllTrim(cEndereco)+STR0141+AllTrim(cEstrutura)+'.'+cMsgItem, {'Ok'}) //'O Endereco '###' nao faz parte da Estrutura Fisica '
			lRet := .F.
			Exit
		EndIf
	EndIf
	RestArea(aAreaDC8)
	RestArea(aAreaSBE)
	RestArea(aAreaDC5)
	RestArea(aAreaAnt)
	Exit
EndDo
Return(lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A103Impri ³ Autor ³Alexandre Inacio Lemes³ Data ³10/06/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a chamada do relatorio padrao ou do usuario         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpX1 := A103Impri( ExpC1, ExpN1, ExpN2 )                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Alias do arquivo                                  ³±±
±±³          ³ ExpN1 -> Recno do registro                                 ³±±
±±³          ³ ExpN2 -> Opcao do Menu                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpX1 -> Retorno do relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function A103Impri( cAlias, nRecno, nOpc )

Local aArea    := GetArea()
Local cPrinter := SuperGetMv("MV_PIMPNFE")
Local xRet     := .T.

If !Empty( cPrinter ) .And. Existblock( cPrinter )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a chamada do relatorio de usuario                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ExecBlock( cPrinter, .F., .F., { cAlias, nRecno, nOpc } )
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a chamada do relatorio padrao                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xRet := MATR170( cAlias, nRecno, nOpc ) 		
EndIf

RestArea( aArea )
Return( xRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A103Grava ³ Autor ³ Edson Maricate       ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravacao da Nota Fiscal de Entrada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103Grava(ExpC1,ExpN2,ExpA3)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExpC1 : Controle de Gravacao  1,                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function a103Grava(lDeleta,lCtbOnLine,lDigita,lAglutina,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,nRecSF1,aRecSD1,aRecSE2,aRecSF3,aRecSC5,aHeadSDE,aColsSDE,aRecSDE,lConFrete,lConImp,aRecSF1Ori,aRatVei,aRatFro,cFornIss,cLojaIss,lBloqueio,l103Class,cDirf,cCodRet,cModRetPIS,nIndexSE2)

Local aPedPV	:= {}
Local aCustoEnt := {}
Local aCustoSDE := {}
Local aSEZ      := {}
Local cArquivo  := ""
Local cLote     := ""
Local nHdlPrv   := 0
Local nTotalLcto:= 0
Local nV        := 0
Local nX        := 0
Local nY        := 0
Local nZ        := 0
Local nW        := 0
Local nOper     := 0
Local nUsadoSDE := Len(aHeadSDE)
Local nTaxaNCC  := 0 
Local lVer640	:= .F.
Local lVer641	:= .F.
Local lVer650	:= .F.
Local lVer651	:= .F.
Local lVer656	:= .F.
Local lVer660	:= .F.
Local lVer642	:= .F.
Local lVer655	:= .F.
Local lVer665	:= .F.
Local lVer955   := .F.
Local lVer950   := .F.
Local cBaseAtf	:= ""
Local cItemAtf	:= ""
Local nItRat    := 0
Local lCompensa := SuperGetMv("MV_CMPDEVV",.F.,.F.)
Local cAliasSE1 := "SE1"
Local aRecSe1   := {}
Local aRecNCC   := {}
Local aStruSE1  := {}
Local nTotalDev := 0
Local lQuery    := .F.
Local cQuery    := ""
Local cGrupo    := SuperGetMv("MV_NFAPROV")
Local cTipoNf   := SuperGetMv("MV_TPNRNFS")
Local nPParcela := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_PARCELA"})
Local nPVencto  := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VENCTO"})
Local nPValor   := aScan(aHeadSE2,{|x| AllTrim(x[2])=="E2_VALOR"})
Local aDadosMail:=ARRAY(6) // Doc,Serie,Fornecedor,Loja,Nome,Opcao
Local aDetalheMail:={}

Private aDupl     := {}
Private cNewItSDG := ""

DEFAULT lCtbOnLine:= .F.
DEFAULT lDeleta   := .F.
DEFAULT aHeadSE2  := {}
DEFAULT aColsSE2  := {}
DEFAULT aHeadSEV  := {}
DEFAULT aColsSEV  := {}
DEFAULT aHeadSDE  := {}
DEFAULT aColsSDE  := {}
DEFAULT nRecSF1   := 0
DEFAULT aRecSD1   := {}
DEFAULT aRecSE2   := {}
DEFAULT aRecSF3   := {}
DEFAULT aRecSC5   := {}
DEFAULT aRecSDE   := {}
DEFAULT lConFrete := .F.
DEFAULT lConImp   := .F.
DEFAULT aRecSF1Ori:= {}
DEFAULT aRatVei   := {}
DEFAULT aRatFro   := {}
DEFAULT lBloqueio := .F.
DEFAULT l103Class := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Template acionando ponto de entrada                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistTemplate("MT100GRV")
	ExecTemplate("MT100GRV",.F.,.F.,{lDeleta})
EndIf			

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada anterior a gravacao do Documento de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MT100GRV"))
	ExecBlock("MT100GRV",.F.,.F.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ha rotina automatica                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
l103Auto := If(Type("L103AUTO")=="U",.F.,l103Auto)
l103Auto := If(Type("L116AUTO")=="U",l103Auto,l116Auto)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ha contabilizacao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtbOnLine .Or. ( lDeleta .And. !Empty(SF1->F1_DTLANC))
	lCtbOnLine := .T.
	dbSelectArea("SX5")
	dbSetOrder(1)
	MsSeek(xFilial("SX5")+"09COM")
	cLote := IIf(Found(),Trim(X5DESCRI()),"COM ")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa um execblock                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At(UPPER("EXEC"),X5Descri()) > 0
		cLote := &(X5Descri())
	EndIf
	nHdlPrv := HeadProva(cLote,"MATA103",Subs(cUsuario,7,6),@cArquivo)
	If nHdlPrv <= 0
		lCtbOnLine := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica quais os lancamentos que estao habilitados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtbOnLine
	lVer640	:= VerPadrao("640") // Entrada de NF Devolucao/Beneficiamento ( Cliente ) - Itens
	lVer650	:= VerPadrao("650") // Entrada de NF Normal ( Fornecedor ) - Itens
	lVer660	:= VerPadrao("660") // Entrada de NF Normal ( Fornecedor ) - Total
	lVer642	:= VerPadrao("642") // Entrada de NF Devol.Vendas - Total (SF1)
	lVer655	:= VerPadrao("655") // Exclusao de NF ( Fornecedor ) - Itens
	lVer665	:= VerPadrao("665") // Exclusao de NF ( Fornecedor ) - Total
	lVer955 := VerPadrao("955") // Do SIGAEIC - Importacao
	lVer950 := VerPadrao("950") // Do SIGAEIC - Importacao
	lVer641	:= VerPadrao("641")	// Entrada de NF Devolucao/Beneficiamento ( Cliente ) - Itens do Rateio
	lVer651	:= VerPadrao("651")	// Entrada de NF Normal ( Fornecedor ) - Itens do Rateio
	lVer656	:= VerPadrao("656")	// Exclusao de NF ( Fornecedor ) - Itens do Rateio
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registros                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo$"DB"
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1")+cA100For+cLoja)
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+cA100For+cLoja)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a operacao a ser realizada (Inclusao ou Exclusao )  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lDeleta
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao do cabecalho do documento de entrada             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	dbSetOrder(1)
	If nRecSF1 <> 0
		MsGoto(nRecSF1)
		RecLock("SF1",.F.)
		nOper := 2
		MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",SF1->F1_VALBRUT,,,SF1->F1_APROV,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
	Else
		RecLock("SF1",.T.)
		nOper := 1
	EndIf
	SF1->F1_FILIAL  := xFilial("SF1")
	SF1->F1_DOC     := cNFiscal
	SF1->F1_STATUS  := "A"
	SF1->F1_SERIE   := cSerie
	SF1->F1_FORNECE := cA100For
	SF1->F1_LOJA    := cLoja
	SF1->F1_COND    := cCondicao
	SF1->F1_DUPL    := IIf(MaFisRet(,"NF_BASEDUP")>0,cNFiscal,"")
	SF1->F1_TXMOEDA := MaFisRet(,"NF_TXMOEDA")
	SF1->F1_EMISSAO := dDEmissao
	SF1->F1_EST     := IIF(cTipo$"DB",SA1->A1_EST,SA2->A2_EST)
	SF1->F1_TIPO    := cTipo	
	SF1->F1_DTDIGIT := dDataBase
	SF1->F1_RECBMTO := SF1->F1_DTDIGIT
	SF1->F1_FORMUL  := IIF(cFormul=="S","S"," ")
	SF1->F1_ESPECIE := cEspecie
	SF1->F1_PREFIXO := IIf(MaFisRet(,"NF_BASEDUP")>0,&(SuperGetMV("MV_2DUPREF")),"")
	SF1->F1_ORIGLAN := IIf(lConFrete,"F"+SubStr(SF1->F1_ORIGLAN,2),SF1->F1_ORIGLAN)
	SF1->F1_ORIGLAN := IIf(lConImp,SubStr(SF1->F1_ORIGLAN,1,1)+"D",SF1->F1_ORIGLAN)
	If lBloqueio
		cGrupo:= If(Empty(SF1->F1_APROV),cGrupo,SF1->F1_APROV)
		If !Empty(cGrupo)
			MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",0,,,cGrupo,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,1,SF1->F1_DOC+SF1->F1_SERIE)
			dbSelectArea("SF1")
			SF1->F1_STATUS := "B"
			SF1->F1_APROV  := cGrupo
		Else
			lBloqueio := .F.
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SF1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	SF1->(FkCommit())	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para envio de email do messenger                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aDadosMail[1]:=SF1->F1_DOC 
	aDadosMail[2]:=SF1->F1_SERIE
	aDadosMail[3]:=SF1->F1_FORNECE
	aDadosMail[4]:=SF1->F1_LOJA
	aDadosMail[5]:=If(cTipo$"DB",SA1->A1_NOME,SA2->A2_NOME)
	aDadosMail[6]:=If(lDeleta,5,If(l103Class,4,3))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao dos impostos calculados no cabecalho do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF4->(MaFisWrite(2,"SF1",Nil))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do array aDupl                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aColsSE2)
		aadd(aDupl,cSerie+"³"+cNFiscal+"³ "+aColsSE2[nX][nPParcela]+" ³"+DTOC(aColsSE2[nX][nPVencto])+"³ "+Transform(aColsSE2[nX][nPValor],PesqPict("SE2","E2_VALOR")))	
	Next nX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao dos itens do documento de entrada                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aCols)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a regua de processamento                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !aCols[nx][Len(aHeader)+1]
			dbSelectArea("SD1")
			If nX <= Len(aRecSD1)
				MsGoto(aRecSD1[nx])
				RecLock("SD1",.F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna os acumulados da Pre-Nota                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaAvalSD1(2)
			Else
				RecLock("SD1",.T.)
			EndIf
			For nY := 1 To Len(aHeader)
				If aHeader[nY][10] # "V"
					SD1->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
				EndIf
			Next nY
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza os dados padroes e dados fiscais.                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SD1->D1_FILIAL := xFilial("SD1")
			SD1->D1_FORNECE:= cA100For
			SD1->D1_LOJA   := cLoja
			SD1->D1_DOC    := cNFiscal
			SD1->D1_SERIE  := cSerie
			SD1->D1_EMISSAO:= dDEmissao
			SD1->D1_DTDIGIT:= dDataBase
			SD1->D1_TIPO   := cTipo
			SD1->D1_NUMSEQ := ProxNum()
			SD1->D1_FORMUL := IIF(cFormul=="S","S"," ")
			SD1->D1_ORIGLAN:= IIf(lConFrete,"FR",SD1->D1_ORIGLAN)
			SD1->D1_ORIGLAN:= IIf(lConImp,"DP",SD1->D1_ORIGLAN)
			SD1->D1_TIPODOC := SF1->F1_TIPODOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza as informacoes relativas aos impostos               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF4->(MaFisWrite(2,"SD1",nX))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Analisa se o documento deve ser bloqueado                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lBloqueio
				SD1->D1_TESACLA := SD1->D1_TES
				SD1->D1_TES := ""
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona registros                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+SD1->D1_COD)

			dbSelectArea("SF4")
			dbSetOrder(1)
			MsSeek(xFilial("SF4")+SD1->D1_TES)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualizacao dos arquivos vinculados ao item do documento     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
			SD1->D1_TP     := SB1->B1_TIPO
			SD1->D1_GRUPO  := SB1->B1_GRUPO	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo do custo de entrada                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCustoEnt := SB1->(A103Custo(nX,aHeadSE2,aColsSE2))
			SD1->D1_CUSTO	:= aCustoEnt[1]
			SD1->D1_CUSTO2	:= aCustoEnt[2]
			SD1->D1_CUSTO3	:= aCustoEnt[3]
			SD1->D1_CUSTO4	:= aCustoEnt[4]
			SD1->D1_CUSTO5	:= aCustoEnt[5]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualizacao dos acumulados do SD1                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaAvalSD1(If(SF1->F1_STATUS=="A",4,1),"SD1",lAmarra,lDataUcom,lPrecoDes,lAtuAmarra,aRecSF1Ori)
			If SF1->F1_STATUS == "A" //Classificada sem bloqueio (NORMAL)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualizacao do rateio dos itens do documento de entrada                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aCustoSDE := aClone(aCustoEnt)
				AFill(aCustoSDE,0)
				If (nY	:= aScan(aColsSDE,{|x| x[1] == SD1->D1_ITEM})) > 0
					For nZ := 1 To Len(aColsSDE[nY][2])
						If !aColsSDE[nY][2][nZ][nUsadoSDE+1]
							RecLock("SDE",.T.)
							For nW := 1 To nUsadoSDE
								If aHeadSDE[nW][10] <> "V"
									SDE->(FieldPut(FieldPos(aHeadSDE[nW][2]),aColsSDE[nY][2][nZ][nW]))
								EndIf
							Next nW
							SDE->DE_FILIAL	:= xFilial("SDE")
							SDE->DE_DOC		:= SD1->D1_DOC
							SDE->DE_SERIE	:= SD1->D1_SERIE
							SDE->DE_FORNECE	:= SD1->D1_FORNECE
							SDE->DE_LOJA	:= SD1->D1_LOJA
							SDE->DE_ITEMNF	:= SD1->D1_ITEM
							For nW:= 1 To Len(aCustoEnt)
								SDE->(FieldPut(FieldPos("DE_CUSTO"+Alltrim(str(nW))),aCustoEnt[nW]*(SDE->DE_PERC/100)))
								aCustoSDE[nW] += SDE->(FieldGet(FieldPos("DE_CUSTO"+Alltrim(str(nW)))))
							Next nW
							If SF4->F4_DUPLIC=="S"
								nW := aScan(aSEZ,{|x| x[1] == SDE->DE_CC .And. x[2] == SDE->DE_ITEMCTA .And. x[3] == SDE->DE_CLVL })
								If nW == 0
									aadd(aSEZ,{SDE->DE_CC,SDE->DE_ITEMCTA,SDE->DE_CLVL,0,0})
									nW := Len(aSEZ)
								EndIf
								If nZ <> Len(aColsSDE[nY][2])
									aSEZ[nW][5] += SDE->DE_CUSTO1
								EndIf
							EndIf
						EndIf
						If nZ == Len(aColsSDE[nY][2])
							For nW := 1 To Len(aCustoEnt)
								SDE->(FieldPut(FieldPos("DE_CUSTO"+Alltrim(str(nW))),FieldGet(FieldPos("DE_CUSTO"+Alltrim(str(nW))))+aCustoEnt[nW]-aCustoSDE[nW]))
							Next nW
							nW := aScan(aSEZ,{|x| x[1] == SDE->DE_CC .And. x[2] == SDE->DE_ITEMCTA .And. x[3] == SDE->DE_CLVL })
							If nW <> 0
								aSEZ[nW][5] += SDE->DE_CUSTO1
							EndIf
						EndIf				

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Ponto de Entrada para o Template                                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (ExistTemplate("SDE100I"))
							ExecTemplate("SDE100I",.F.,.F.,{lConFrete,lConImp,nOper})
			 			EndIf
						If (ExistBlock("SDE100I"))
							ExecBlock("SDE100I",.F.,.F.,{lConFrete,lConImp,nOper})
						Endif
				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Gera Lancamento contabil 641- Devolucao / Beneficiamento ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lCtbOnLine
							If cTipo $ "BD"
								If lVer641
									nTotalLcto	+= DetProva(nHdlPrv,"641","MATA103",cLote)
								EndIf
							Else
								If lVer651
									nTotalLcto	+= DetProva(nHdlPrv,"651","MATA103",cLote)
								EndIf
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Do Case
						 	Case cTipo == "B"
								PcoDetLan("000054","11","MATA103")
							Case cTipo == "D"
								PcoDetLan("000054","10","MATA103")
							OtherWise
								PcoDetLan("000054","09","MATA103")
						EndCase
					Next nZ
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento da gravacao do SDE na Integridade Referencial            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SDE->(FkCommit())			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a Gravacao do Ativo Imobilizado                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( SF4->F4_ATUATF=="S" )
					INCLUI := .T.
					ALTERA := .F.
					cBaseAtf := ""
					If ( SF4->F4_BENSATF == "1" )                        
						For nV := 1 TO Int(SD1->D1_QUANT)
							cItemAtf := StrZero(nV,Len(SN1->N1_ITEM))
							a103GrvAtf(1,@cBaseAtf,cItemAtf,SD1->D1_CODCIAP,SD1->D1_VALICM+SD1->D1_ICMSCOM)
						Next nV   
					Else
						cItemAtf := StrZero(1,Len(SN1->N1_ITEM))
						a103GrvAtf(1,@cBaseAtf,cItemAtf,SD1->D1_CODCIAP,SD1->D1_VALICM+SD1->D1_ICMSCOM)
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Integracao TMS                                                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If IntTMS() .And. (Len(aRatVei)>0  .Or. Len(aRatFro)>0)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿			
					//³Verifica se o Item da NF foi rateado por Veiculo/Viagem ou por Frota    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			                                           		
					nItRat := aScan(aRatVei,{|x| x[1] == SD1->D1_ITEM})
					If nItRat > 0
						A103GrvSDG('SD1',aRatVei,"V",SD1->D1_ITEM,lCtbOnLine,nHdlPrv,@nTotalLcto,cLote,"MATA103")
					Else
						nItRat := aScan(aRatFro,{|x| x[1] == SD1->D1_ITEM})
						If nItRat > 0
							A103GrvSDG('SD1',aRatFro,"F",SD1->D1_ITEM,lCtbOnLine,nHdlPrv,@nTotalLcto,cLote,"MATA103")				
						EndIf
					EndIf	
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponto de entrada apos a gravacao do SD1 e todas atualizacoes.           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SuperGetMV("MV_NGMNTES") == "S"
					NGSD1100I()
				EndIf			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
				//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
				//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
				If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
					GSPF160()
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponto de Entrada para o Template                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (ExistTemplate("SD1100I"))
					ExecTemplate("SD1100I",.F.,.F.,{lConFrete,lConImp,nOper})
				EndIf
				If (ExistBlock("SD1100I"))
					ExecBlock("SD1100I",.F.,.F.,{lConFrete,lConImp,nOper})
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Contabilizacao do item do documento de entrada                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCtbOnline
					If cTipo $ "BD" .And. lVer640
						nTotalLcto	+= DetProva(nHdlPrv,"640","MATA103",cLote)
					Else
						If lVer650
							nTotalLcto	+= DetProva(nHdlPrv,"650","MATA103",cLote)
						EndIf
					EndIf
				EndIf			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Do Case
				 	Case cTipo == "B"
						PcoDetLan("000054","07","MATA103")
					Case cTipo == "D"
						PcoDetLan("000054","05","MATA103")
					OtherWise
						PcoDetLan("000054","01","MATA103")
				EndCase
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Dados para envio de email do messenger                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			AADD(aDetalheMail,{SD1->D1_ITEM,SD1->D1_COD,SD1->D1_QUANT,SD1->D1_TOTAL})			
		Else
			If  nX <= Len(aRecSD1)
				MsGoto(aRecSD1[nx])
				RecLock("SD1",.F.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna os acumulados da Pre-Nota                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaAvalSD1(2)
				SD1->(dbDelete())
				SD1->(MsUnLock())
			EndIf
		EndIf
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os acumulados do Cabecalho do documento         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaAvalSF1(3)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera os titulos no Contas a Pagar SE2                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF1->F1_STATUS == "A" //Classificada sem bloqueio
		If !(cTipo$"DB")
			A103AtuSE2(1,aRecSE2,aHeadSE2,aColsSE2,aHeadSEV,aColsSEV,cFornIss,cLojaIss,cDirf,cCodRet,cModRetPIS,nIndexSE2,aSEZ )			
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera titulo de NCC ao cliente                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipo == "D" .And. MaFisRet(,"NF_BASEDUP") > 0
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera a taxa informada para geracao da NCC           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If GetMV( "MV_TXMOENC" ) == "2" 
				nTaxaNCC := MaFisRet(,"NF_TXMOEDA")
			Else 
				nTaxaNCC := 0 	
			EndIf		
		
			Aadd(aRecNCC,ADupCred(xmoeda(MaFisRet(,"NF_BASEDUP"),1,nMoedaCor,NIL,NIL,NIL,nTaxaNCC),"001",nMoedaCor,MaFisRet(,"NF_NATUREZA")))
			If lCompensa  //Compensacao automatica do titulo
				dbSelectArea("SE1")
				dbSetOrder(2)
				#IFDEF TOP
					lQuery    := .T.
					aStruSE1  := SE1->(dbStruct())
					cAliasSE1 := "A103DEV"
					cQuery    := "SELECT SE1.*,SE1.R_E_C_N_O_ SE1RECNO "
					cQuery    += "FROM "+RetSqlName("SE1")+" SE1 "
					cQuery    += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
					cQuery    += "SE1.E1_CLIENTE='"+SF1->F1_FORNECE+"' AND "
					cQuery    += "SE1.E1_LOJA='"+SF1->F1_LOJA+"' AND "
					cQuery    += "SE1.E1_PREFIXO='"+SD1->D1_SERIORI+"' AND "
					cQuery    += "SE1.E1_NUM='"+SD1->D1_NFORI+"' AND "
					cQuery    += "SE1.E1_TIPO='NF ' AND "
					cQuery    += "SE1.D_E_L_E_T_=' ' "
					cQuery    += "ORDER BY "+SqlOrder(SE1->(IndexKey()))
	
					cQuery := ChangeQuery(cQuery)
	
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
					For nX := 1 To Len(aStruSE1)
						If aStruSE1[nX][2]<>"C"
							TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
						EndIf
					Next nX
				#ELSE
					MsSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SD1->D1_SERIORI+SD1->D1_NFORI)
				#ENDIF
				While !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
					SF1->F1_FORNECE == (cAliasSE1)->E1_CLIENTE .And.;
					SF1->F1_LOJA == (cAliasSE1)->E1_LOJA .And.;
					SD1->D1_SERIORI == (cAliasSE1)->E1_PREFIXO .And.;
					SD1->D1_NFORI == (cAliasSE1)->E1_NUM
					If (cAliasSE1)->E1_TIPO == "NF "
						If !SuperGetMv("MV_CHECKNF",.F.,.F.) .Or. (cAliasSE1)->E1_SITUACA == "0"
							aadd(aRecSE1,If(lQuery,(cAliasSE1)->SE1RECNO,(cAliasSE1)->(RecNo())))
							nTotalDev += (cAliasSE1)->E1_VALOR
						Endif
					Endif
					dbSelectArea(cAliasSE1)
					dbSkip()
				EndDo
	
				//Compensacao automatica do titulo, somente para devolucao total
				If Round(MaFisRet(,"NF_BASEDUP"),2) == Round(nTotalDev,2)
					MaIntBxCR(3,aRecSe1,,aRecNcc,,{lCtbOnLine,.F.,.F.,.F.,.F.,.F.})
				EndIf
				If lQuery
					dbSelectArea(cAliasSE1)
					dbCloseArea()
					dbSelectArea("SE1")
				EndIf
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna os valores da Comissao.              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( SuperGetMV("MV_TPCOMIS")=="O" )
				Fa440CalcE("MATA100")
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
		//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF01I()
		EndIf

		If cFormul == "S" .And. cTipoNf == "2"
			While ( __lSX8 )
				ConfirmSX8()
			EndDo
	    EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pontos de Entrada 										   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (ExistTemplate("SF1100I"))
			ExecTemplate("SF1100I",.f.,.f.)
		EndIf
		If (ExistBlock("SF1100I"))
			ExecBlock("SF1100I",.f.,.f.)
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava Pedido de Venda qdo solicitado pelo campo D1_GERAPV  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		a103GrvPV(1,aPedPV)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o arquivo de Livros  (SF3)                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaFisAtuSF3(1,"E",0,"SF1")
		If nRecSf1 == 0
			nRecSF1	:= SF1->(RecNo())
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabilizacao do documento de entrada                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCtbOnLine
			If lVer660 .And. !(cTipo $"DB")
				dbSelectArea("SF1")
				MsGoto(nRecSF1)
				nTotalLcto	+= DetProva(nHdlPrv,"660","MATA103",cLote)
			EndIf
			If lVer642 .And. cTipo $"DB"
				dbSelectArea("SF1")
				MsGoto(nRecSF1)
				nTotalLcto	+= DetProva(nHdlPrv,"642","MATA103",cLote)
			EndIf
			If lVer950 .And. !Empty(SD1->D1_TEC)
				nTotalLcto +=DetProva(nHdlPrv,"950","MATA103",cLote)
			Endif
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000054","03","MATA103")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada dos execblocks no termino do documento de entrada              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If (ExistTemplate("GQREENTR"))
		ExecTemplate("GQREENTR",.F.,.F.)
	EndIf
	If (ExistBlock("GQREENTR"))
		ExecBlock("GQREENTR",.F.,.F.)
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoDetLan("000054","04","MATA103")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera Lancamento contabil 665- Exclusao - Total       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lVer665.And.!Empty(SF1->F1_DTLANC)
		nTotalLcto	+= DetProva(nHdlPrv,"665","MATA103",cLote)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o pedido de vendas quando gerado pelo D1_GERAPV      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	a103GrvPV(2,,aRecSC5)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o arquivo de Livros Fiscais (SF3)                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAtuSF3(2,"E",SF1->(RecNo()))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera os titulos no Contas a Pagar SE2                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SF1->F1_TIPO$"DB")
		A103AtuSE2(2,aRecSE2)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os acumulados do Cabecalho do documento         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaAvalSF1(4)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorna os titulos de NCC ao cliente                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A103EstNCC()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclusao do rateio dos itens do documento de entrada                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aRecSDE)
		dbSelectArea("SDE")
		SDE->(MsGoto(aRecSDE[nX]))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
		 	Case cTipo == "B"
				PcoDetLan("000054","14","MATA103")
			Case cTipo == "D"
				PcoDetLan("000054","13","MATA103")
			OtherWise
				PcoDetLan("000054","12","MATA103")
		EndCase
		RecLock("SDE")
		dbDelete()
		MsUnLock()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera Lancamento contabil 656- Exclusao - Itens de Rateio ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lVer656.And.!Empty(SF1->F1_DTLANC)
			nTotalLcto	+= DetProva(nHdlPrv,"656","MATA103",cLote)
		EndIf
	Next nX	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SDE na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SDE->(FkCommit())

	For nX := 1 to Len(aRecSD1)
		dbSelectArea("SD1")
		MsGoto(aRecSD1[nx])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera Lancamento contabil 955- Exclusao - Total EIC   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nX == 1 .And. lVer955 .And.!Empty(SD1->D1_TEC) .And. !Empty(SF1->F1_DTLANC)
			nTotalLcto +=DetProva(nHdlPrv,"955","MATA103",cLote)
		Endif
		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial()+SD1->D1_TES)

		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1")+SD1->D1_COD)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua o Estorno do Ativo Imobilizado                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If ( SF4->F4_BENSATF == "1" )                        
        	For nV := 1 TO Int(SD1->D1_QUANT)
		     	a103GrvAtf(2,Trim(SD1->D1_CBASEAF))
 	        Next nV 
 	    Else     
		  	a103GrvAtf(2,Trim(SD1->D1_CBASEAF))
        EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
		 	Case cTipo == "B"
				PcoDetLan("000054","08","MATA103")
			Case cTipo == "D"
				PcoDetLan("000054","06","MATA103")
			OtherWise
				PcoDetLan("000054","02","MATA103")
		EndCase
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera Lancamento contabil 655- Exclusao - Itens       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lVer655.And.!Empty(SF1->F1_DTLANC)
			nTotalLcto	+= DetProva(nHdlPrv,"655","MATA103",cLote)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna o Servico do WMS (DCF)                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A103EstDCF()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorna o Movimento de Custo de Transporte - Integracao TMS             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IntTMS()  .And. (Len(aRatVei)>0 .Or. Len(aRatFro)>0)
			EstornaSDG("SD1",SD1->D1_NUMSEQ,lCtbOnLine,nHdlPrv,@nTotalLcto,cLote,"MATA103")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualizacao dos acumulados do SD1                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaAvalSD1(If(SF1->F1_STATUS=="A",5,2),"SD1",lAmarra,lDataUcom,lPrecoDes)
		MaAvalSD1(If(SF1->F1_STATUS=="A",6,3),"SD1",lAmarra,lDataUcom,lPrecoDes)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui o item da NF SD1                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SuperGetMV("MV_NGMNTES") == "S"
			NGSD1100E()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
		//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF170()
		EndIf           

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
		//³ Pontos de Entrada 											 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
		If (ExistTemplate("SD1100E"))
			ExecTemplate("SD1100E",.F.,.F.,{lConFrete,lConImp})
		Endif
		If (ExistBlock("SD1100E"))
			ExecBlock("SD1100E",.F.,.F.,{lConFrete,lConImp})
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados para envio de email do messenger                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		AADD(aDetalheMail,{SD1->D1_ITEM,SD1->D1_COD,SD1->D1_QUANT,SD1->D1_TOTAL})			
			
		RecLock("SD1",.F.,.T.)
		dbDelete()
		MsUnlock()
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SD1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SD1->(FkCommit())
    
	dbSelectArea("SF1")
	MsGoto(nRecSF1)
	RecLock("SF1",.F.,.T.)
	nOper := 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
	//³ Conforme situacao do parametro abaixo, integra com o SIGAGSP ³
	//³             MV_SIGAGSP - 0-Integra / 1-Nao                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
	If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
		GSPF01E()
	EndIf
	If !Empty(SF1->F1_APROV)
		MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"NF",SF1->F1_VALBRUT,,,SF1->F1_APROV,,SF1->F1_MOEDA,SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3,SF1->F1_DOC+SF1->F1_SERIE)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Template acionando ponto de entrada           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistTemplate("SF1100E")
	   ExecTemplate("SF1100E",.F.,.F.)
	EndIf
	If (ExistBlock("SF1100E"))
		ExecBlock("SF1100E",.F.,.F.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para envio de email do messenger                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aDadosMail[1]:=SF1->F1_DOC 
	aDadosMail[2]:=SF1->F1_SERIE
	aDadosMail[3]:=SF1->F1_FORNECE
	aDadosMail[4]:=SF1->F1_LOJA
	aDadosMail[5]:=If(cTipo$"DB",SA1->A1_NOME,SA2->A2_NOME)
	aDadosMail[6]:=If(lDeleta,5,If(l103Class,4,3))

	dbDelete()
	MsUnlock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da gravacao do SF1 na Integridade Referencial            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF1->(FkCommit())

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de e-mails para o evento 030       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MEnviaMail("030",{aDadosMail[1],aDadosMail[2],aDadosMail[3],aDadosMail[4],aDadosMail[5],aDadosMail[6],aDetalheMail})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao dos dados contabeis                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCtbOnLine .And. nTotalLcto > 0
	RodaProva(nHdlPrv,nTotalLcto)
	If cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglutina)
		If !SF1->(Deleted())
			RecLock("SF1",.F.)
			SF1->F1_DTLANC := dDataBase
			MsUnLock()
		EndIf
	EndIf
EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103Custo³ Autor ³ Edson Maricate         ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula o custo de entrada do Item                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Custo(nItem)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 : Item da NF                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103 , A103Grava()                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function A103Custo(nItem,aHeadSE2,aColsSE2)

Local aCusto     := {}
Local aRet       := {}
Local nPos       := 0
Local nValIV     := 0
Local nX         := 0                       
Local nFatorPS2  := 1 
Local nFatorCF2  := 1 
Local nValPS2    := 0 
Local nValCF2    := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o percentual para credito do PIS / COFINS   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( SF4->( FieldPos( "F4_BCRDPIS" ) ) ) 
	If !Empty( SF4->F4_BCRDPIS )
		nFatorPS2 := SF4->F4_BCRDPIS / 100 
	EndIf 	
EndIf                  

If !Empty( SF4->( FieldPos( "F4_BCRDCOF" ) ) ) 
	If !Empty( SF4->F4_BCRDCOF )
		nFatorCF2 := SF4->F4_BCRDCOF / 100 
	EndIf 	
EndIf         

nValPS2 := MaFisRet(nItem,"IT_VALPS2") * nFatorPS2  
nValCF2 := MaFisRet(nItem,"IT_VALCF2") * nFatorCF2  

l103Auto := Type("l103Auto") <> "U" .And. l103Auto

If l103Auto .And. (nPos:= aScan(aAutoItens[nItem],{|x|Trim(x[1])== "D1_CUSTO" })) > 0
	aADD(aCusto,{aAutoItens[nItem,nPos,2],0.00,0.00,SF4->F4_CREDIPI,;
		SF4->F4_CREDICM,;
		MaFisRet(nItem,"IT_NFORI"),;
		MaFisRet(nItem,"IT_SERORI"),;
		SD1->D1_COD,;
		SD1->D1_LOCAL,;
		SD1->D1_QUANT,;
		If(SF4->F4_IPI=="R",MaFisRet(nItem,"IT_VALIPI"),0) ,;
		SF4->F4_CREDST,;
		MaFisRet(nItem,"IT_VALSOL"),;
		MaRetIncIV(nItem,"1"),;
		SF4->F4_PISCOF,;
		SF4->F4_PISCRED,;
		nValPS2,;
		nValCF2;
		})
Else
	nValIV	:=	MaRetIncIV(nItem,"2")
	If SD1->D1_COD == Left(SuperGetMV("MV_PRODIMP"), Len(SD1->D1_COD))
		aADD(aCusto,{MaFisRet(nItem,"IT_TOTAL")-IIF(cTipo == "P".Or.SF4->F4_IPI=="R",0,MaFisRet(nItem,"IT_VALIPI"))+MaFisRet(nItem,"IT_VALICM")+If(SF4->F4_CIAP<>"S",MaFisRet(nItem,"IT_VALCMP"),0)-If(SF4->F4_INCSOL=="S",MaFisRet(nItem,"IT_VALSOL"),0)-nValIV+IF(SF4->F4_AGREG$'A|C',MaFisRet(nItem,"IT_VALICM"),0),;
			MaFisRet(nItem,"IT_VALIPI"),;
			MaFisRet(nItem,"IT_VALICM"),;
			SF4->F4_CREDIPI,;
			SF4->F4_CREDICM,;
			MaFisRet(nItem,"IT_NFORI"),;
			MaFisRet(nItem,"IT_SERORI"),;
			SD1->D1_COD,;
			SD1->D1_LOCAL,;
			SD1->D1_QUANT,;
			If(SF4->F4_IPI=="R",MaFisRet(nItem,"IT_VALIPI"),0) ,;
			SF4->F4_CREDST,;
			MaFisRet(nItem,"IT_VALSOL"),;
			MaRetIncIV(nItem,"1"),;
			SF4->F4_PISCOF,;
			SF4->F4_PISCRED,;
			nValPS2,;
			nValCF2;
			})
	Else
		aADD(aCusto,{MaFisRet(nItem,"IT_TOTAL")-IIF(cTipo == "P".Or.SF4->F4_IPI=="R",0,MaFisRet(nItem,"IT_VALIPI"))+If(SF4->F4_CIAP<>"S",MaFisRet(nItem,"IT_VALCMP"),0)-If(SF4->F4_INCSOL=="S",MaFisRet(nItem,"IT_VALSOL"),0)-nValIV+IF(SF4->F4_AGREG$'A|C',MaFisRet(nItem,"IT_VALICM"),0),;		
			MaFisRet(nItem,"IT_VALIPI"),;
			MaFisRet(nItem,"IT_VALICM"),;
			SF4->F4_CREDIPI,;
			SF4->F4_CREDICM,;
			MaFisRet(nItem,"IT_NFORI"),;
			MaFisRet(nItem,"IT_SERORI"),;
			SD1->D1_COD,;
			SD1->D1_LOCAL,;
			SD1->D1_QUANT,;
			If(SF4->F4_IPI=="R",MaFisRet(nItem,"IT_VALIPI"),0) ,;
			SF4->F4_CREDST,;
			MaFisRet(nItem,"IT_VALSOL"),;
			MaRetIncIV(nItem,"1"),;
			SF4->F4_PISCOF,;
			SF4->F4_PISCRED,;
			nValPS2,;
			nValCF2;
			})
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao considerar o custo de uma entrada por devolucao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SD1->D1_TIPO == "D" .And. SF4->F4_DEVZERO == "2"
	aRet := {{0,0,0,0,0}}
Else
	aRet := RetCusEnt(aDupl,aCusto,cTipo)
	If SF4->F4_AGREG == "N"
		For nX := 1 to Len(aRet[1])
			aRet[1][nX] := If(aRet[1][nX]>0,aRet[1][nX],0)
		Next nX
	EndIf
EndIf
Return aRet[1]


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MyMata103 ³ Autor ³ Eduardo Riera         ³ Data ³06.11.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de teste da rotina automatica do programa MATA103     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar testes na rotina de    ³±±
±±³          ³documento de entrada                                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MyMata103()

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.
PRIVATE lMsErroAuto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ConOut(Repl("-",80))
ConOut(PadC("Teste de Inclusao de 10 documentos de entrada com 30 itens cada",80))
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "COM" TABLES "SF1","SD1","SA1","SA2","SB1","SB2","SF4"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verificacao do ambiente para teste                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
If !SB1->(MsSeek(xFilial("SB1")+"PA001"))
	lOk := .F.
	ConOut("Cadastrar produto: PA001")
EndIf
dbSelectArea("SF4")
dbSetOrder(1)
If !SF4->(MsSeek(xFilial("SF4")+"001"))
	lOk := .F.
	ConOut("Cadastrar TES: 001")
EndIf
dbSelectArea("SE4")
dbSetOrder(1)
If !SE4->(MsSeek(xFilial("SE4")+"001"))
	lOk := .F.
	ConOut("Cadastrar condicao de pagamento: 001")
EndIf
If !SB1->(MsSeek(xFilial("SB1")+"PA002"))
	lOk := .F.
	ConOut("Cadastrar produto: PA002")
EndIf
dbSelectArea("SA2")
dbSetOrder(1)
If !SA2->(MsSeek(xFilial("SA2")+"F0000101"))
	lOk := .F.
	ConOut("Cadastrar fornecedor: F0000101")
EndIf
If lOk
	ConOut("Inicio: "+Time())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Verifica o ultimo documento valido para um fornecedor        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	dbSetOrder(2)
	MsSeek(xFilial("SF1")+"F0000101z",.T.)
	dbSkip(-1)
	cDoc := SF1->F1_DOC
	For nY := 1 To 10
		aCabec := {}
		aItens := {}

		If Empty(cDoc)
			cDoc := StrZero(1,Len(SD1->D1_DOC))
		Else
			cDoc := Soma1(cDoc)
		EndIf
		aadd(aCabec,{"F1_TIPO"   ,"N"})
		aadd(aCabec,{"F1_FORMUL" ,"N"})
		aadd(aCabec,{"F1_DOC"    ,(cDoc)})
		aadd(aCabec,{"F1_SERIE"  ,"UNI"})
		aadd(aCabec,{"F1_EMISSAO",dDataBase})
		aadd(aCabec,{"F1_FORNECE","F00001"})
		aadd(aCabec,{"F1_LOJA"   ,"01"})
		aadd(aCabec,{"F1_ESPECIE","NFE"})
		aadd(aCabec,{"F1_COND","001"})
		aadd(aCabec,{"F1_DESPESA"   ,10})		
		aadd(aCabec,{"E2_NATUREZ","NAT01"})

		For nX := 1 To 30
			aLinha := {}
			aadd(aLinha,{"D1_COD"  ,"PA001",Nil})
			aadd(aLinha,{"D1_QUANT",1,Nil})
			aadd(aLinha,{"D1_VUNIT",100,Nil})
			aadd(aLinha,{"D1_TOTAL",100,Nil})
			aadd(aLinha,{"D1_TES","001",Nil})
			aadd(aItens,aLinha)
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Teste de Inclusao                                            |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MATA103(aCabec,aItens)
		If !lMsErroAuto
			ConOut("Incluido com sucesso! "+cDoc)	
		Else
			ConOut("Erro na inclusao!")
		EndIf
	Next nY
	ConOut("Fim  : "+Time())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de exclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCabec := {}
	aItens := {}
	aadd(aCabec,{"F1_TIPO"   ,"N"})
	aadd(aCabec,{"F1_FORMUL" ,"N"})
	aadd(aCabec,{"F1_DOC"    ,(cDoc)})
	aadd(aCabec,{"F1_SERIE"  ,"UNI"})
	aadd(aCabec,{"F1_EMISSAO",dDataBase})
	aadd(aCabec,{"F1_FORNECE","F00001"})
	aadd(aCabec,{"F1_LOJA"   ,"01"})
	aadd(aCabec,{"F1_ESPECIE","NFE"})

	For nX := 1 To 30
		aLinha := {}
		aadd(aLinha,{"D1_ITEM",StrZero(nX,Len(SD1->D1_ITEM)),Nil})
		aadd(aLinha,{"D1_COD","PA002",Nil})
		aadd(aLinha,{"D1_QUANT",2,Nil})
		aadd(aLinha,{"D1_VUNIT",100,Nil})
		aadd(aLinha,{"D1_TOTAL",200,Nil})
		aadd(aItens,aLinha)
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Exclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ConOut(PadC("Teste de exclusao",80))
	ConOut("Inicio: "+Time())
	MATA103(aCabec,aItens,5)
	If !lMsErroAuto
		ConOut("Exclusao com sucesso! "+cDoc)	
	Else
		ConOut("Erro na exclusao!")
	EndIf
	ConOut("Fim  : "+Time())
	ConOut(Repl("-",80))
EndIf
RESET ENVIRONMENT
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma103Track³ Autor ³ Aline Correa do Vale  ³ Data ³05/06/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A103Track()

Local aEnt     := {}
Local cKey     := cNFiscal + cSerie + cA100For + cLoja
Local nPosItem := GDFieldPos( "D1_ITEM" )
Local nPosCod  := GDFieldPos( "D1_COD"  )
Local nLoop    := 0
Local aArea    := GetArea()
Local aAreaSF1 := SF1->( GetArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aCols )
	AAdd( aEnt, { "SD1", cKey + aCols[ nLoop, nPosCod ] + aCols[ nLoop, nPosItem ] } )
Next nLoop

MaFisSave()
MaFisEnd()

MaTrkShow( aEnt )

MaFisRestore()

RestArea(aAreaSF1)
RestArea(aArea)

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AliasInDic³ Autor ³ Sergio Silveira       ³ Data ³02/01/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Indica se um determinado alias esta presente no dicionario ³±±
±±³          ³ de dados                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := AliasInDic( ExpC1, ExpL2 )                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> .T. - Tabela presente / .F. - tabela nao presente ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Alias                                             ³±±
±±³          ³ ExpL2 -> Indica se exibe help de tabela inexistente        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function AliasInDic(cAlias,lHelp) 
                         
Local aArea    := GetArea() 
Local aAreaSX2 := SX2->( GetArea() ) 
Local aAreaSX3 := SX3->( GetArea() ) 
Local lRet := .F.          

DEFAULT lHelp := .F. 

SX2->( dbSetOrder( 1 ) ) 
SX3->( dbSetOrder( 1 ) ) 

lRet := ( SX2->( dbSeek( cAlias ) ) .And. SX3->( dbSeek( cAlias ) ) )

If !lRet .And. lHelp  
	Help( "", 1, "ALIASINDIC",,cAlias )  
EndIf                   

SX3->( RestArea( aAreaSX3 ) )
SX2->( RestArea( aAreaSX2 ) ) 
RestArea( aArea ) 

Return( lRet ) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³NfeCalcRet³ Autor ³Sergio Silveira        ³ Data ³05/08/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Efetua o calculo do valor de titulos financeiros que        ³±±
±±³          ³calcularam a retencao do PIS / COGINS / CSLL e nao          ³±±
±±³          ³criaram os titulos de retencao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpA1 := NfeCalcRet( ExpD1 )                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD1 - Data de referencia                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA1 -> Array com os seguintes elementos                   ³±±
±±³          ³       1 - Valor dos titulos                                ³±±
±±³          ³       2 - Valor do PIS                                     ³±±
±±³          ³       3 - Valor do COFINS                                  ³±±
±±³          ³       4 - Valor da CSLL                                    ³±±
±±³          ³       5 - Array contendo os recnos dos registos processados³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NfeCalcRet( dReferencia, nIndexSE2 ) 

Local aAreaSE2  := SE2->( GetArea() ) 
Local aDadosRef := Array( 8 )    
Local aRecnos   := {}      

Local nAdic     := 0

Local dDataIni  := FirstDay( dReferencia ) 
Local dDataFim  := LastDay( dReferencia ) 
Local cModTot   := GetNewPar( "MV_MT10925", "1" ) 
Local lBaseImp  := ( SuperGetMv("MV_BS10925",.F.,"1") == "1")


#IFDEF TOP

	Local aStruct   := {} 
	Local aCampos   := {}  
	Local aFil10925 := {} 

	Local cAliasQry := ""  
	Local cSepNeg   := If("|"$MV_CPNEG,"|",",")
	Local cSepProv  := If("|"$MVPROVIS,"|",",")
	Local cSepRec   := If("|"$MVPAGANT,"|",",")
	Local cQuery    := ""
	Local cQryFil   := ""	

	Local nLoop     := 0 

#ENDIF 
        
AFill( aDadosRef, 0 ) 

#IFDEF TOP  

	If ExistBlock( "MT103FRT" )
		aFil10925 := ExecBlock( "MT103FRT", .F., .F. ) 
	Else 
		aFil10925 := { xFilial( "SE2" ) }  				     
	EndIf
        
	aCampos := { "E2_VALOR","E2_IRRF","E2_ISS","E2_INSS","E2_PIS","E2_COFINS","E2_CSLL","E2_VRETPIS","E2_VRETCOF","E2_VRETCSL" } 
	aStruct := SE2->( dbStruct() ) 	

	SE2->( dbCommit() ) 
   
  	cAliasQry := GetNextAlias()

	cQuery := "SELECT E2_VALOR,E2_PIS,E2_COFINS,E2_EMISSAO,E2_CSLL,E2_ISS,E2_INSS,E2_IRRF,E2_VRETPIS,E2_VRETCOF,E2_VRETCSL,E2_PRETPIS,E2_PRETCOF,E2_PRETCSL,R_E_C_N_O_ RECNO "
	
	If SE2->(FieldPos("E2_BASEPIS")) > 0 .And. SE2->(FieldPos("E2_BASECOF")) > 0 .And. SE2->(FieldPos("E2_BASECSL")) > 0
		cQuery += ",E2_BASEPIS,E2_BASECOF,E2_BASECSL "	                                                                    
		Aadd(aCampos,"E2_BASEPIS")
		Aadd(aCampos,"E2_BASECOF")
		Aadd(aCampos,"E2_BASECSL")		
	Endif
	
	cQuery += "FROM "+RetSqlName( "SE2" ) + " SE2 " 
	cQuery += "WHERE "                           
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega as filiais do filtro                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQryFil := "("

	For nLoop := 1 to Len( aFil10925 ) 
		cQryFil += "E2_FILIAL='" + aFil10925[ nLoop ] + "' OR "
	Next nLoop 						                                
	
	cQryFil := Left( cQryFil, Len( cQryFil ) - 3 ) 
	
	cQryFil  += ") AND " 
	
	cQuery += cQryFil 
	
	cQuery += "E2_FORNECE='"   + cA100For             + "' AND " 	
	cQuery += "E2_LOJA='"      + cLoja                + "' AND "
	cQuery += "E2_VENCREA>= '" + DToS( dDataIni )      + "' AND "		
	cQuery += "E2_VENCREA<= '" + DToS( dDataFim )      + "' AND " 
	cQuery += "E2_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " AND "
	cQuery += "E2_TIPO NOT IN " + FormatIn(MV_CPNEG,cSepNeg)  + " AND "
	cQuery += "E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " AND "
	cQuery += "E2_TIPO NOT IN " + FormatIn(MVPAGANT,cSepRec)  + " AND "
	
	cQuery += "D_E_L_E_T_=' '"                                             
	
	cQuery := ChangeQuery( cQuery ) 
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )
	
	For nLoop := 1 To Len( aStruct ) 
		If !Empty( AScan( aCampos, AllTrim( aStruct[nLoop,1] ) ) ) 
			TcSetField( cAliasQry, aStruct[nLoop,1], aStruct[nLoop,2],aStruct[nLoop,3],aStruct[nLoop,4])
		EndIf 			
	Next nLop 
	
	While !( cAliasQRY )->( Eof())
		
		nAdic := 0
		
		nAdic += ( ( cAliasQRY )->E2_VALOR + ( cAliasQRY )->E2_ISS + ( cAliasQRY )->E2_INSS + ( cAliasQRY )->E2_IRRF )
		
		If Empty( ( cAliasQRY )->E2_PRETPIS )
			nAdic += If( Empty( ( cAliasQRY )->E2_VRETPIS ), ( cAliasQRY )->E2_PIS, ( cAliasQRY )->E2_VRETPIS )
		EndIf
		
		If Empty( ( cAliasQRY )->E2_PRETCOF )
			nAdic += If( Empty( ( cAliasQRY )->E2_VRETCOF ), ( cAliasQRY )->E2_COFINS, ( cAliasQRY )->E2_VRETCOF )
		EndIf
		
		If Empty( ( cAliasQRY )->E2_PRETCSL )
			nAdic += If( Empty( ( cAliasQRY )->E2_VRETCSL ), ( cAliasQRY )->E2_CSLL, ( cAliasQRY )->E2_VRETCSL )
		EndIf

		If cModTot == "1"
			aDadosRef[1] += nAdic 
	
			If SE2->(FieldPos("E2_BASEPIS")) > 0 .And. SE2->(FieldPos("E2_BASECOF")) > 0 .And. SE2->(FieldPos("E2_BASECSL")) > 0  .And. lBaseImp
	
				If ( cAliasQRY )->E2_BASEPIS > 0 .Or. ( cAliasQRY )->E2_BASECOF > 0 .Or. ( cAliasQRY )->E2_BASECSL > 0
					aDadosRef[6] += ( cAliasQRY )->E2_BASEPIS 
					aDadosRef[7] += ( cAliasQRY )->E2_BASECOF 
					aDadosRef[8] += ( cAliasQRY )->E2_BASECSL 
				Else
					aDadosRef[6] += nAdic
					aDadosRef[7] += nAdic
					aDadosRef[8] += nAdic
				EndIf 
			Else
				aDadosRef[6] += nAdic
				aDadosRef[7] += nAdic
				aDadosRef[8] += nAdic
			EndIf 
		Endif

		
		If ( !Empty( ( cAliasQRY )->E2_PIS ) .Or. !Empty( ( cAliasQRY )->E2_COFINS ) .Or. !Empty( ( cAliasQRY )->E2_CSLL ) ) 
		
			If cModTot == "2"	
			
				aDadosRef[1] += nAdic 
	
				If SE2->(FieldPos("E2_BASEPIS")) > 0 .And. SE2->(FieldPos("E2_BASECOF")) > 0 .And. SE2->(FieldPos("E2_BASECSL")) > 0  .And. lBaseImp
					If ( cAliasQRY )->E2_BASEPIS > 0 .Or. ( cAliasQRY )->E2_BASECOF > 0 .Or. ( cAliasQRY )->E2_BASECSL > 0
					
						aDadosRef[6] += ( cAliasQRY )->E2_BASEPIS 
						aDadosRef[7] += ( cAliasQRY )->E2_BASECOF 
						aDadosRef[8] += ( cAliasQRY )->E2_BASECSL 
					Else
						aDadosRef[6] += nAdic
						aDadosRef[7] += nAdic
						aDadosRef[8] += nAdic
					EndIf 
				Else
					aDadosRef[6] += nAdic
					aDadosRef[7] += nAdic
					aDadosRef[8] += nAdic
				EndIf 
			Endif	
		
		
			If ( Empty( ( cAliasQRY )->E2_VRETPIS ) .Or. Empty( ( cAliasQry )->E2_VRETCOF ) .Or. Empty( ( cAliasQry )->E2_VRETCSL ) ) ;
				.And. ( ( cAliasQRY )->E2_PRETPIS == "1" .Or. ( cAliasQry )->E2_PRETCOF == "1" .Or. ( cAliasQry )->E2_PRETCSL == "1" )
			
				If Empty( ( cAliasQRY )->E2_VRETPIS ) .And. ( cAliasQRY )->E2_PRETPIS == "1"
					aDadosRef[2] += ( cAliasQRY )->E2_PIS
				EndIf
			
				If Empty( ( cAliasQRY )->E2_VRETCOF )	.And. ( cAliasQRY )->E2_PRETCOF == "1"
					aDadosRef[3] += ( cAliasQRY )->E2_COFINS
				EndIf
			
				If Empty( ( cAliasQRY )->E2_VRETCSL ) .And. ( cAliasQRY )->E2_PRETCSL == "1"
					aDadosRef[4] += ( cAliasQRY )->E2_CSLL
				EndIf
				AAdd( aRecnos, ( cAliasQRY )->RECNO )
			EndIf
			
		Endif
				
		( cAliasQRY )->( dbSkip())
		
	EndDo
	   
	// Fecha a area de trabalho da query 
   
   ( cAliasQRY )->( dbCloseArea() ) 
   dbSelectArea( "SE2" ) 

#ELSE 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
	//³ Verifica se foi criada a indregua                                   ³  
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType( nIndexSE2 ) == "N" 
	
		SE2->( dbSetOrder( nIndexSE2 ) )
		SE2->( dbSeek( DTOS( dDataIni ), .T. ) ) 
		
		While !SE2->( Eof() ) .And. SE2->E2_VENCREA >= dDataIni .And. SE2->E2_VENCREA <= dDataFim
			If !( SE2->E2_TIPO $ ( MVABATIM + "/" + MV_CPNEG + "/" + MVPROVIS + "/" + MVPAGANT ) )
		
				nAdic := 0		
				
				nAdic += ( SE2->E2_VALOR + SE2->E2_ISS + SE2->E2_INSS + SE2->E2_IRRF )
				
				If Empty( SE2->E2_PRETPIS )
					nAdic += If( Empty( SE2->E2_VRETPIS ), SE2->E2_PIS, SE2->E2_VRETPIS )
				EndIf
				
				If Empty( SE2->E2_PRETCOF )
					nAdic += If( Empty( SE2->E2_VRETCOF ), SE2->E2_COFINS, SE2->E2_VRETCOF )
				EndIf
				
				If Empty( SE2->E2_PRETCSL )
					nAdic += If( Empty( SE2->E2_VRETCSL ), SE2->E2_CSLL, SE2->E2_VRETCSL )
				EndIf
				
				If cModTot == "1"
					aDadosRef[1] += nAdic 
	
					If SE2->(FieldPos("E2_BASEPIS")) > 0 .And. SE2->(FieldPos("E2_BASECOF")) > 0 .And. SE2->(FieldPos("E2_BASECSL")) > 0  .And. lBaseImp
			
						If SE2->E2_BASEPIS > 0 .Or. SE2->E2_BASECOF > 0 .Or. SE2->E2_BASECSL > 0
							aDadosRef[6] += SE2->E2_BASEPIS 
							aDadosRef[7] += SE2->E2_BASECOF 
							aDadosRef[8] += SE2->E2_BASECSL 
						Else
							aDadosRef[6] += nAdic
							aDadosRef[7] += nAdic
							aDadosRef[8] += nAdic
						EndIf 
					Else
						aDadosRef[6] += nAdic
						aDadosRef[7] += nAdic
						aDadosRef[8] += nAdic
					EndIf 
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona ao array apenas os titulos que calcularam retencao         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If	( !Empty( SE2->E2_PIS ) .Or. !Empty( SE2->E2_COFINS ) .Or. !Empty( SE2->E2_CSLL ) )  

					If cModTot == "2"

						aDadosRef[1] += nAdic 

						If SE2->(FieldPos("E2_BASEPIS")) > 0 .And. SE2->(FieldPos("E2_BASECOF")) > 0 .And. SE2->(FieldPos("E2_BASECSL")) > 0  .And. lBaseImp
				
							If SE2->E2_BASEPIS > 0 .Or. SE2->E2_BASECOF > 0 .Or. SE2->E2_BASECSL > 0
								aDadosRef[6] += SE2->E2_BASEPIS 
								aDadosRef[7] += SE2->E2_BASECOF 
								aDadosRef[8] += SE2->E2_BASECSL 
							Else
								aDadosRef[6] += nAdic
								aDadosRef[7] += nAdic
								aDadosRef[8] += nAdic
							EndIf 

						Else

							aDadosRef[6] += nAdic
							aDadosRef[7] += nAdic
							aDadosRef[8] += nAdic
						EndIf 
					Endif		
								
				
					If ( Empty( SE2->E2_VRETPIS ) .Or. Empty( SE2->E2_VRETCOF ) .And. Empty( SE2->E2_VRETCSL ) ) .And. ;
						( SE2->E2_PRETPIS == "1" .Or. SE2->E2_PRETCOF == "1" .Or. SE2->E2_PRETCSL == "1" )
					
						If Empty( SE2->E2_VRETPIS ) .And. SE2->E2_PRETPIS == "1"
							aDadosRef[2] += SE2->E2_PIS
						EndIf
					
						If Empty( SE2->E2_VRETCOF ) .And. SE2->E2_PRETCOF == "1"
							aDadosRef[3] += SE2->E2_COFINS
						EndIf
					
						If Empty( SE2->E2_VRETCSL ) .And. SE2->E2_PRETCSL == "1"
							aDadosRef[4] += SE2->E2_CSLL
						EndIf
					
						AAdd( aRecnos, SE2->( RECNO() ) )
					EndIf
				Endif	
			EndIf
			
			SE2->( dbSkip() )
			
		EndDo
		
	EndIf 

		
#ENDIF    

aDadosRef[ 5 ] := AClone( aRecnos )            

SE2->( RestArea( aAreaSE2 ) ) 

Return( aDadosRef ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A103TmsVld³ Autor ³Eduardo de Souza       ³ Data ³ 30/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida exclusao do movimentos de custos de transporte.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1 := A103TmsVld( ExpL1 )                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD1 - Verifica se eh exclusao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SigaTMS                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A103TmsVld(l103Exclui)

Local lRet     := .T.
Local nCnt     := 0
Local aAreaSD1 := SD1->(GetArea())

If l103Exclui .And. IntTMS() // Integracao TMS
	SD1->(DbSetOrder(1))
	For nCnt := 1 To Len(aCols)	
		If SD1->(MsSeek(xFilial("SD1")+cNFiscal+cSerie+cA100For+cLoja+GDFieldGet("D1_COD",nCnt)+GDFieldGet("D1_ITEM",nCnt)))
			SDG->(DbSetOrder(7))
			If SDG->(MsSeek(xFilial("SDG")+"SD1"+SD1->D1_NUMSEQ))
				While SDG->(!Eof()) .And. SDG->DG_FILIAL + SDG->DG_ORIGEM + SDG->DG_SEQMOV == xFilial("SDG") + "SD1" + SD1->D1_NUMSEQ
					If SDG->DG_STATUS <> StrZero(1,Len(SDG->DG_STATUS)) //-- Em Aberto
						//-- Caso somente a viagem esteja informada ou Frota, estorna o movimento de custo de transporte.
						If !( Empty(SDG->DG_CODVEI) .And. Empty(SDG->DG_FILORI) .And. Empty(SDG->DG_VIAGEM) ) .And. ;
						   !( Empty(SDG->DG_CODVEI) .And. !Empty(SDG->DG_FILORI) .And. !Empty(SDG->DG_VIAGEM) )
							//-- Caso a veiculo seja proprio estorna o movimento de custo de transporte.
							If !Empty(SDG->DG_CODVEI) .And. Empty(SDG->DG_FILORI) .And. Empty(SDG->DG_VIAGEM)								
								DA3->(DbSetOrder(1))
								If DA3->(MsSeek(xFilial("DA3")+SDG->DG_CODVEI))
									If DA3->DA3_FROVEI <> "1"
										lRet := .F.
										Exit
									EndIf
								EndIf
							Else					
								lRet := .F.
								Exit
							EndIf
						EndIf
					EndIf
					SDG->(DbSkip())
				EndDo
			EndIf
		EndIf
	Next nCnt
	RestArea( aAreaSD1 )
EndIf

If !lRet
	Help(" ",1,"A103NODEL") //-- Existe movimento de custo de transporte baixado, nao sera permitida a exclusao.
EndIf

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103TemBlq³ Autor ³ Edson Maricate        ³ Data ³17.02.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da TudoOk                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A103TemBlq(l103Class)

Local aArea     := GetArea()
Local aAreaSC7  := SC7->(GetArea())
Local lRet      := .F.
Local nX        := 0
Local nPosPc    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPosItPc  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
Local nPosQtd   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
Local nPosVlr   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
Local nPosCod   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local nPosItem  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
Local nUsado    := len(aHeader)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o preenchimaneto da tes dos itens devido a importacao do pedido de compras ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (SuperGetMV("MV_RESTCLA",.F.,"2")=="1" .And. l103Class)
	dbSelectArea("SD1")
	dbSetOrder(1)
	MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
EndIf
If (SuperGetMV("MV_RESTCLA",.F.,"2")=="1" .And. l103Class .And. Empty(SD1->D1_TESACLA)) .Or. !l103Class
	For nX :=1 To Len(aCols)
		If !aCols[nx][nUsado+1]
			If !Empty(aCols[nx][nPosPc])
				If l103Class
					dbSelectArea("SD1")
					dbSetOrder(1)
					MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+aCols[nx][nPosCod]+aCols[nx][nPosItem])
				EndIf
				dbSelectArea("SC7")
				dbSetOrder(1)
				If MsSeek(xFilial("SC7")+aCols[nx][nPosPc]+aCols[nx][nPosItPc])
					lRet := MaAvalToler(SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_PRODUTO,aCols[nx][nPosQtd]+SC7->C7_QUJE+SC7->C7_QTDACLA-IIf(l103Class,SD1->D1_QUANT,0),SC7->C7_QUANT,aCols[nx][nPosVlr],SC7->C7_PRECO)[1]
					If lRet
						Exit
					EndIf
				EndIf
			EndIf
		EndIf
	Next nX
EndIf
RestArea(aAreaSC7)
RestArea(aArea)
Return ( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ValSD4³ Autor ³Alexandre Inacio Lemes ³ Data ³07/04/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a existencia de empenhos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function A103ValSD4(nItem)

Local aArea      := GetArea()
Local nPosCod    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local nPosQuant  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
Local nPosOp     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})
Local cAlerta    := ""
Local cProduto   := ""
Local lRetorno   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe empenho                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aCols[nItem][nPosOp])

	dbSelectArea("SD4")
	dbSetOrder(1)
	If !dbSeek(xFilial()+aCols[nItem][nPosCod]+aCols[nItem][nPosOp])
		dbSelectArea("SC2")
		dbSetOrder(1)
		If dbSeek(xFilial()+aCols[nItem][nPosOp])
			cProduto:=SC2->C2_PRODUTO
		EndIf
		dbSelectArea("SG1")
		dbSetOrder(2)
		If (!DbSeek(xFilial("SG1")+aCols[nItem][nPosCod]+cProduto))
			cAlerta := OemToAnsi(STR0174)+chr(13)		                  //"O produto digitado n„o faz parte da"
			cAlerta += OemToAnsi(STR0175+cProduto)+chr(13)	              //"Estrutura do Produto "
			cAlerta += OemToAnsi(STR0176+ aCols[nItem][nPosOp] )+chr(13)//"da OP - "
			cAlerta += OemToAnsi(STR0177)+chr(13)		 	              //"Confirma movimenta‡„o ?"
			If MsgYesNo(cAlerta,OemToAnsi(STR0178))			              //"ATENCAO"
				lRetorno :=.T.
 			EndIf
		Else
			lRetorno :=.T.
		EndIf
		dbSelectArea("SG1")
		dbSetOrder(1)
	Else
		If SD4->D4_QUANT < aCols[nItem][nPosQuant]
			cAlerta := OemToAnsi(STR0179+Transform(SD4->D4_QUANT,PesqPict("SD1","D1_QUANT")))+chr(13) //"A quantidade empenhada"
			cAlerta += OemToAnsi(STR0180)+chr(13)                        //"e menor que a quantidade do item"
			cAlerta += OemToAnsi(STR0177)+chr(13)	                      //"Confirma movimenta‡„o ?"
			If MsgYesNo(cAlerta,OemToAnsi(STR0178))			              //"ATENCAO"
				lRetorno :=.T.
			EndIf
		Else
			lRetorno := .T.
		EndIf                                             
	EndIf
	
EndIf

RestArea(aArea)
Return lRetorno

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A103Line  ³ Autor ³ Eduardo de Souza     ³ Data ³ 20/07/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao da bLine do documento.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103Line(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Posicao da linha no listbox                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function A103Line(nAT,aSF2)

Static oNoMarked := LoadBitmap( GetResources(),'LBNO'			)
Static oMarked	  := LoadBitmap( GetResources(),'LBOK'			)
Local abLine     := {}
Local nCnt       := 0

For nCnt := 1 To Len(aSF2[nAT])
	If nCnt == 1
		Aadd( abLine, Iif(aSF2[ nAT, nCnt ] , oMarked, oNoMarked ) )
	Else
		Aadd( abLine, aSF2[ nAT, nCnt ] )
	EndIf
Next nCnt

Return abLine

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A103RetNF ³ Autor ³ Eduardo de Souza     ³ Data ³ 20/07/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna as notas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103RetNF(ExpA1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 - Campos que deverao ser apresentados                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A103RetNF(aCpoSF2,dDataDe,dDataAte)

Local aSF2      := {}
Local aAux      := {}
Local nCnt      := 0
Local cAliasSF2 := 'SF2'
Local cQuery    := ''
Local cIndex    := ''
Local nIndexSF2 := 0

#IFDEF TOP
	cAliasSF2 := GetNextAlias()
	cQuery := " SELECT * "
  	cQuery += "   FROM " + RetSqlName("SF2")
  	cQuery += "   WHERE F2_FILIAL  = '" + xFilial("SF2") + "' "
  	cQuery += "     AND F2_CLIENTE = '" + cCliente + "' "
  	cQuery += "     AND F2_LOJA    = '" + cLoja    + "' "
  	cQuery += "     AND F2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
  	cQuery += "     AND D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasSF2, .F., .T. )
#ELSE
	DbSelectArea("SF2")
	cIndex := CriaTrab(NIL,.F.)
	cQuery := " SF2->F2_FILIAL == '" + xFilial("SF2") + "' "
  	cQuery += " .And. SF2->F2_CLIENTE == '" + cCliente + "' "
  	cQuery += " .And. SF2->F2_LOJA    == '" + cLoja    + "' "
  	cQuery += " .And. DtoS(SF2->F2_EMISSAO) >= '" + DtoS(dDataDe)  + "'"
	cQuery += " .And. DtoS(SF2->F2_EMISSAO) <= '" + DtoS(dDataAte) + "' "
	IndRegua("SF2",cIndex,"F2_DOC+F2_SERIE",,cQuery)
	SF2->(DbGotop())
#ENDIF

While (cAliasSF2)->(!Eof())
	aAux := {}
	Aadd( aAux, .F. )
	For nCnt := 1 To Len(aCpoSF2)
		Aadd( aAux, &(aCpoSF2[nCnt]) )
	Next nCnt
	aAdd( aSF2, aClone(aAux) )
	(cAliasSF2)->(DbSkip())
EndDo

#IFDEF TOP
	(cAliasSF2)->(DbCloseArea())
#ELSE
	RetIndex( "SF2" )  
	FErase( cIndex+OrdBagExt() )
#ENDIF

Return aSF2

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A103FRet ³ Autor ³ Eduardo de Souza      ³ Data ³ 20/07/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Filtro para retornar de doctos fiscais.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103FRet()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A103FRet(lCliente,dDataDe,dDataAte)

Static cTCliente := RetTitle("F2_CLIENTE")
Static cTLoja    := RetTitle("F2_LOJA")
Static cTDataDe  := STR0181
Static cTDataAte := STR0182

Local oDlgEsp
Local oCliente
Local oDocto
Local lDocto   := .F.
Local nOpcao   := 0

DEFINE MSDIALOG oDlgEsp FROM 00,00 TO 140,490 PIXEL TITLE STR0099 //-- "Retorno de Doctos. de Saida"

@ 06,05 SAY cTCliente PIXEL
@ 05,40 MSGET cCliente F3 'SA1' SIZE 65, 10 OF oDlgEsp PIXEL ;
			VALID Vazio() .Or. ExistCpo('SA1',cCliente+AllTrim(cLoja),1)

@ 06,120 SAY cTLoja PIXEL
@ 05,160 MSGET cLoja SIZE 20, 10 OF oDlgEsp PIXEL ;
			VALID Vazio() .Or. ExistCpo('SA1',cCliente+AllTrim(cLoja),1)

@ 21,05 SAY cTDataDe PIXEL
@ 20,40 MSGET dDataDe PICTURE "@D" SIZE 20, 10 OF oDlgEsp PIXEL

@ 21,120 SAY cTDataAte PIXEL
@ 20,160 MSGET dDataAte PICTURE "@D" SIZE 20, 10 OF oDlgEsp PIXEL

@ 035,003 TO 065,195 LABEL STR0185 OF oDlgEsp PIXEL // 'Tipo de Selecao'

//-- 'Cliente'
@ 45,10 CHECKBOX oCliente VAR lCliente PROMPT OemToAnsi(STR0183) SIZE 50,010 ;
	ON CLICK( lDocto := .F., oDocto:Refresh() ) OF oDlgEsp PIXEL

//-- 'Documento'
@ 45,120 CHECKBOX oDocto VAR lDocto PROMPT OemToAnsi(STR0184) SIZE 50,010 ;
	ON CLICK( lCliente := .F., oCliente:Refresh() ) OF oDlgEsp PIXEL

DEFINE SBUTTON FROM 05,215 TYPE 1 OF oDlgEsp ENABLE ;
	ACTION If(!Empty(cCliente) .And. !Empty(cLoja) .And. ;
		 		 !Empty(dDataDe) .And. !Empty(dDataAte) .And. ;
		 		 (lCliente .Or. lDocto),(nOpcao := 1,oDlgEsp:End()),.F.)

DEFINE SBUTTON FROM 20,215 TYPE 2 OF oDlgEsp ENABLE ACTION (nOpcao := 0,oDlgEsp:End())

ACTIVATE MSDIALOG oDlgEsp CENTERED

Return ( nOpcao == 1 )