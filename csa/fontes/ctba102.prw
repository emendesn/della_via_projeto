#Include "Protheus.ch"
#Include "Ctba102.ch"
#Include "Colors.ch"

STATIC __aMedias[99]
Static MAX_LINHA
Static lCT102ACAP := ExistBlock("CT102ACAP")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA102   ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclusao de Lancamento Contabeis - Manuais - Automatizado  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba102(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nulo                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTBA102(xAutoCab,xAutoItens,nOpcAuto)

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis para rotina automatica    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Private lCt102Auto  := ( ValType(xAutoCab) == "A"  .And. ValType(xAutoItens) == "A" )
Private aAutoCab  	:= {}
Private aAutoItens	:= {}

Private aRotina := { 	{OemToAnsi(STR0001) ,"AxPesqui"  , 0 , 1},; // "Pesquisar"
					 	{OemToAnsi(STR0002) ,"Ctba102Cal", 0 , 2},; // "Visualizar"
						{OemToAnsi(STR0003) ,"Ctba102Cal", 0 , 3},; // "Incluir"
						{OemToAnsi(STR0004) ,"Ctba102Cal", 0 , 4},; // "Alterar"
						{OemToAnsi(STR0005) ,"Ctba102Cal", 0 , 5},;
						{STR0029,"CtbLegenda", 0 , 5}   		 ,; //"Legenda"						
	                    {STR0046,"CtbC010Rot"	, 0 , 2} }  

Private cCadastro := OemToAnsi(STR0006)		// "Lan‡amentos Cont beis - Automaticos"
Private dDataLanc
Private cLote
Private cLoteSub := GetMv("MV_SUBLOTE")
Private cSubLote := cLoteSub
Private lSubLote := Empty(cSubLote)
Private cDoc
Private cSeqCorr := Iif( cPaisLoc="CHI", CriaVar("CT2_SEGOFI"), Space(10) )

Private __lCusto:= .F.
Private __lItem := .F.
Private __lCLVL	:= .F.

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

dbSelectArea("CT2")
dbSetOrder(1)
If lCt102Auto
	aAutoCab := xAutoCab
	aAutoItens := xAutoItens
	MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"CT2")
Else
	mBrowse(6,1,22,75,"CT2",,,,,, CtbLegenda("CT2"))
EndIf	

dbSetOrder(1)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA102Cal³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama a Capa de Lote                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctba102Cal(cAlias,nReg,nOpc)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do Registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctba102Cal(cAlias,nReg,nOpc)                
	Ctba102Cap(cAlias,nReg,nOpc,'CTBA102',@dDataLanc,@cLote,@cSubLote,@cDoc)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA102Cap³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Capa de Lote                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba102Cap(cAlias,nReg,nOpca,cProg,dDatalanc,cLote,cSubLote³±±
±±³          ³ cDoc)                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do Registro                                 ³±±
±±³          ³ ExpC1 = Numero da Opcao do menu                            ³±±
±±³          ³ ExpC2 = Nome do Programa			                          ³±±
±±³          ³ ExpD1 = Data do Lancamento		                          ³±±
±±³          ³ ExpC3 = Numero do Lote  			                          ³±±
±±³          ³ ExpC4 = Numero do Sub-Lote		                          ³±±
±±³          ³ ExpC5 = Numero do Documento		                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctba102Cap(cAlias,nReg,nOpc,cProg,dDataLanc,cLote,cSubLote,cDoc)                            

Local cPadrao 
Local oDlg
Local oDoc
Local oLote  
Local oSubLote  
Local oInf, oInfLot
Local oLinha

Local CTF_LOCK	:= 0
Local nOpca 	:= 0
Local cAliasAnt := ""                                                             
Local cLinha 	:= ""         
Local cTitulo	:= ""
Local nTotInf 	:=nTotInfLot := 0
Local lDigita	:= Iif(nOpc == 3 .Or. nOpc == 6,.T.,.F.)
Local nPosAut	:= 0
Local aCT102ACAP := {}
Local nRecCT2 := CT2->(Recno())

Private nSaida 	 := 0
Private aTotRdpe := {{0,0,0,0},{0,0,0,0}}

If nOpc # 3 .And. (Eof() .Or. Deleted())
	Help(" ",1,"A000FI")
	Return .F.
EndIf

If nOpc == 3 .Or. nOpc == 6			// Inclusao / Estorno
	dDataLanc	:= dDataBase
	cLote		:= CriaVar("CT2_LOTE")
	cSubLote 	:= If(lSubLote, CriaVar("CT2_SBLOTE"), cLoteSub)
	cDoc 		:= CriaVar("CT2_DOC")
	cPadrao		:= CriaVar("CT2_LP")
	If lCT102ACap						/// PONTO DE ENTRADA PARA GERAR NUMERO DE LOTE E SUB-LOTE ESPECIFICO (BOPS 67945)
		aCT102ACAP := ExecBlock("CT102ACAP",.F.,.F.)
		If ValType(aCT102ACAP) == "A" .and. Len(aCT102ACAP) > 0
			If !Empty(aCT102ACAP[1])
				cLote := aCT102ACAP[1]
			Endif
        
			If Len(aCT102ACAP) > 1
				If !Empty(aCT102ACAP[2])
					cSubLote := aCT102ACAP[2]
				Endif
			Endif
		Endif
	Endif        
Else
	dDataLanc	:= CT2->CT2_DATA
	cLote		:= CT2->CT2_LOTE
	cSubLote	:= CT2->CT2_SBLOTE
	cDoc 		:= CT2->CT2_DOC
	cPadrao		:= CT2->CT2_LP
EndIf	   

If nOpc == 4	.Or. nOpc == 5	//Se for alteracao ou exclusao, verifica se o reg. esta em uso. 
	If !Ctb101Doc(@dDataLanc,cLote,cSubLote,@cDoc,oDoc,@CTF_LOCK,nOpc)
		Return 	                             
	Endif   
Endif

cAliasAnt := Alias()
dbSelectArea("CT6")
dbSetOrder(1)
If MsSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+'01')
	nTotInfLot := CT6->CT6_INF		
Else
	nTotInfLot := 0
Endif           

dbSelectArea("CTC")
dbSetOrder(1)
If MsSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+cDoc+'01')
	nTotInf := CTC->CTC_INF		
Else
	nTotInf := 0
Endif           

dbSelectArea(cAliasAnt)

__lCusto	:= CtbMovSaldo("CTT")
__lItem		:= CtbMovSaldo("CTD")
__lCLVL		:= CtbMovSaldo("CTH")


If cProg == "CTBA101"
	cTitulo := OemToAnsi(STR0030)
Else
	cTitulo := OemToAnsi(STR0007)
EndIf	

If  Type('lCt102Auto')== "U" .Or. !lCt102Auto 
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 33,25 TO 240,369 PIXEL  //"Capa de Lote - Lan‡amentos Cont beis"
		@ 001,005 TO 032, 140 OF oDlg PIXEL
		@ 035,005 TO 066, 140 OF oDlg PIXEL
		@ 004,008 	SAY OemToAnsi(STR0008) SIZE 55, 7 OF oDlg PIXEL  //"Data Lan‡amento"
	
	
	@ 014,008 	MSGET oDataLanc VAR dDataLanc Picture "99/99/99" When lDigita Valid NaoVazio(dDataLanc) .And. ;
						CtbValiDt(nOpc,dDataLanc) .And.;
						If(Empty(cLote),C050Next(dDataLanc,@cLote,@cSubLote,@cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,nOpc,1),.T.) .And.;
						CtbMedias(dDataLanc) ;
						SIZE 50, 11 OF oDlg PIXEL        					
						
		@ 038,008 	SAY OemToAnsi(STR0009) SIZE 18, 7 OF oDlg PIXEL  //"Lote"
		@ 048,008 	MSGET oLote VAR cLote Picture "@!" When lDigita ;
					Valid NaoVazio(cLote) .And.;
					C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)  .And.;
					Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
					SIZE 32, 11 OF oDlg PIXEL
	
	   	@ 038,041   SAY OemToAnsi(STR0028) SIZE 25, 7 OF oDlg PIXEL  //"Sub-Lote"
	   	@ 048,041   MSGET oSubLote VAR cSubLote Picture "!!!"  F3 "SB";
					WHEN lDigita .And. lSubLote;
					VALID NaoVazio(cSubLote) .And.;
						  C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)  .And.;
						  Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
					SIZE 22, 11 OF oDlg PIXEL
	
	   	@ 038,068   SAY OemToAnsi(STR0010) SIZE 34, 7 OF oDlg PIXEL //"Documento"
		@ 048,068   MSGET oDoc VAR cDoc Picture "999999" ;
						When lDigita;            					
						Valid NaoVazio(cDoc) .And.;
						Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,@CTF_LOCK,nOpc) .And.;
						Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
						SIZE 34, 11 OF oDlg PIXEL
						
		If cProg != 'CTBA101'				
			@ 038,104   SAY OemToAnsi(STR0011) SIZE 37, 7 OF oDlg PIXEL  //"Lcto Padr„o"
	      	@ 048,104   MSGET oPadrao VAR cPadrao Pict "999" Valid ValidaLP(cPadrao) .And. cPadrao < '500' ;
			            F3 "CT5" SIZE 34, 11 OF oDlg PIXEL
			oPadrao:lReadOnly:=!lDigita
		Endif
	
	    @ 070,05 	SAY OemToAnsi(STR0034) SIZE 60, 7 OF oDlg PIXEL 	//"Total Informado Docto"
	    @ 080,05 	MSGET oInf VAR nTotInf  Picture "@E 9999999,999,999.99";
	    			When (nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 6);
		    				SIZE 66, 11 OF oDlg PIXEL                  	 
					
	    @ 070,75 	SAY OemToAnsi(STR0025) SIZE 60, 7 OF oDlg PIXEL	//"Total Informado Lote"
	    @ 080,75 	MSGET oInfLot VAR nTotInfLot Picture "@E 9999999,999,999.99";
	    			When .F. SIZE 66, 11 OF oDlg PIXEL                  	 
	
							
		DEFINE SBUTTON FROM 05, 142 TYPE 1 ACTION (nOpca := 1,;                                           
						Iif(lDigita,Iif(Ct102GrCTF(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK) .And.;
							Ctb101Lote(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK) .And.;
							Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK,nOpc) .And.;
							c102CapOk(dDataLanc,cLote,cSubLote,cDoc) .And.;
							VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc) .And.;
							CtbProxLin(dDataLanc,cLote,cSubLote,cDoc,@cLinha,@oLinha),;
							oDlg:End(),nopca:=0),;
							Iif(VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc) .and. ;
							CtbVldLP(dDataLanc,cLote,cSubLote,cDoc,nOpc) .And.;						
							CtbTmpBloq(dDataLanc,cLote,cSubLote,cDoc,nOpc,cProg) .and.;
							CtbValiDt(nOpc,dDataLanc),;
							oDlg:End(),nOpca:=0))) ENABLE OF oDlg
	                                                                              
		DEFINE SBUTTON FROM 18, 142 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg
		
	ACTIVATE MSDIALOg oDlg CENTERED
Else
	Private aValidGet 	:= {}
	
	nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "DDATALANC"})
	If nPosAut # 0
		dDataLanc	:= aAutoCab[nPosAut,2]
		Aadd(aValidGet,{"dDataLanc", aAutoCab[nPosAut,2],;
			"NaoVazio(dDataLanc) .And. CtbValiDt("+lTrim(Str(nOpc))+",dDataLanc)",.T.})
	EndIf			

	nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CLOTE"})
	If nPosAut # 0
		Aadd(aValidGet,{"cLote", aAutoCab[nPosAut,2],"NaoVazio(cLote) ",.T.})
	EndIf	
	
	nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CSUBLOTE"})
	If nPosAut # 0
		Aadd(aValidGet,{"cSubLote", aAutoCab[nPosAut,2],"NaoVazio(cSubLote) ",.T.})
    EndIf
    
	nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CDOC"})
	If nPosAut # 0	
		Aadd(aValidGet,{"cDoc", aAutoCab[nPosAut,2],"NaoVazio(cDoc)",.T.})
	EndIf

	nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CPADRAO"})
	If nPosAut # 0	
		cPadrao	:= aAutoCab[nPosAut,2]
		Aadd(aValidGet,{"cPadrao", aAutoCab[nPosAut,2],"ValidaLP(cPadrao) .And. cPadrao < '500'",.T.})
	EndIf

	nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "NTOTINF"})
	If nPosAut # 0	
		nTotInf	:= aAutoCab[nPosAut,2]
		Aadd(aValidGet,{"nTotInf", aAutoCab[nPosAut,2],".T.",.T.})
	EndIf

	nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "NTOTINFLOT"})
	If nPosAut # 0	
		nTotInfLot := aAutoCab[nPosAut,2]
		Aadd(aValidGet,{"nTotInfLot", aAutoCab[nPosAut,2],".T.",.T.})
	EndIf

	If CT2->(MsVldGAuto(aValidGet)) // Consiste os gets
		cLote 	 := Padr(cLote,TamSx3("CT2_LOTE")[1])//correcao do tamanho do campos.
		cSubLote := Padr(cSublote,TamSx3("CT2_SBLOTE")[1])
		cDoc	 := Padr(cDoc,TamSx3("CT2_DOC")[1])

		If nOpc == 3
			If Empty(cLote)
				C050Next(dDataLanc,@cLote,@cSubLote,@cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,nOpc,1)
			Endif
			CtbMedias(dDataLanc) 
			C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)
		EndIf			

		If Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,@CTF_LOCK,nOpc)
			If lDigita 
				If (Ct102GrCTF(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK) .And.;
					Ctb101Lote(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK) .And.;
					Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK,nOpc) .And.;
					c102CapOk(dDataLanc,cLote,cSubLote,cDoc) .And.;
					VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc).And.;
					CtbProxLin(dDataLanc,cLote,cSubLote,cDoc,@cLinha,))
		
					nOpca	:= 1
		
				EndIf					
				
			Else
				If (VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc) .and. ;
				CtbVldLP(dDataLanc,cLote,cSubLote,cDoc,nOpc) .And.;						
				CtbValiDt(nOpc,dDataLanc))
					
					nOpca	:= 1
					
				EndIf
			EndIf		
		Else
			Return .F.
		EndIf
	Else
		Return .F.
	EndIf		
EndIf	

If nOpca == 1
	If cProg == 'CTBA102'
		Ctba102Lan(nOpc,dDataLanc,cLote,cSubLote,cDoc,cAlias,nReg,@CTF_LOCK,;
				   cPadrao,nTotInf)
	Elseif cProg == 'CTBA101'
		Ctba101Lan(cAlias,nReg,nOpc,dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK,;
				   cPadrao,@cLinha,oLinha,oInf,nTotInf)		
	Endif
	If nOpc != 3
		nOpca := 0
	EndIf
EndIf

If CTF_LOCK > 0					/// LIBERA O REGISTRO NO CTF COM A NUMERCAO DO DOC
	dbSelectArea("CTF")
	dbGoTo(CTF_LOCK)
	CtbDestrava(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK)			
Endif

dbSelectArea("CT2")
dbSetOrder(1)

If Recno() <> nRecCT2
	MsSeek(xFilial()+Dtos(dDataLanc)+cLote+cSubLote+cDoc)
	If EOF()
		DbGoTo(nRecCT2)
	EndIF
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA102Lan³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta tela de lancamento contabil                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba102Lan(nOpc,dDatalanc,cLote,cSubLote,cDoc,cAlias,nReg, ³±±
±±³          ³ CTF_LOCK,cPadrao,nTotInf)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Numero da opcao escolhida                          ³±±
±±³          ³ ExpD1 = Data do Lancamento                                 ³±±
±±³          ³ ExpC1 = Numero do Lote                                     ³±±
±±³          ³ ExpC2 = Numero do Sub-Lote                                 ³±±
±±³          ³ ExpC3 = Numero do Documento                                ³±±
±±³          ³ ExpC4 = Alias do Arquivo                                   ³±±
±±³          ³ ExpN2 = Numero do registro                                 ³±±
±±³          ³ ExpN3 = Semaforo para proximo documento                    ³±±
±±³          ³ ExpC5 = Codigo do lancamento padrao                        ³±±
±±³          ³ ExpN4 = Valor Total infomrado                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctba102Lan(nOpc,dDataLanc,cLote,cSubLote,cDoc,cAlias,nReg,CTF_LOCK,;
					cPadrao,nTotInf)

Local aCampos		:= {}
Local aAltera		:= {}
Local aTotais 		:= {{0,0,0,0},{0,0,0,0}}
Local aButton 	:= {}

Local cArq1
Local cArq2
Local cSeqChave 	:= ""
Local cEmpOri		:= cEmpAnt
Local cFilOri		:= cFilAnt

Local lDel 	  		:= .F.
Local lRet			:= .T.
Local lCt105TOK	:= IIf(ExistBlock("CT105TOK"),.T.,.F.)
Local lCt105CHK	:= Iif(ExistBlock("CT105CHK"),.T.,.F.)
Local lAnCtb102G:= Iif(ExistBlock("ANCTB102GR"),.T.,.F.)
Local lDpCtb102G:= Iif(ExistBlock("DPCTB102GR"),.T.,.F.)
Local lCtb102Exc	:= Iif(ExistBlock("CTB102EXC"),.T.,.F.)

Local nOpcao		:= nOpc	//Variavel para carregar a GetDB

Local oDlg
Local oInf 
Local oFnt
Local cExpFil	:= ""
Local cTxtfil	:= ""
Local cLinhaAlt := "001"
                  
//Private aTELA		:= {}
//Private aGETS		:= {}
Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private oDescEnt
Private oDig
Private oDeb
Private oCred
Private aColsP		:= {}
Private oGetDB


If MAX_LINHA = Nil
	MAX_LINHA := GetMv("MV_NUMMAN")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Getdados para Lan‡amentos Cont beis                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := Ctb105Head(@aAltera)
Ctb105Cria(aCampos,@cArq1,@cArq2)

If !Empty(cPadrao) .And. nOpc == 3			// Carrega getdb com LP -> so vale na inclusao!!
	CtbEnche(cPadrao,.T.)
Else
	Ctb102Carr(nOpc,@dDataLanc,cLote,cSubLote,cDoc,@cLinhaAlt)
EndIf

If cPaisLoc == 'CHI'
	aPosCol := {00.8,03,10,12,16,19,23,25,30,34}
Else
	aPosCol := {00.8,03,11,14,21,25,32,34}
EndIf

nOpca := 0
Aadd( aButton, {"SIMULACAO",{ || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc)}, STR0041+" - <F5>", STR0015	} ) //"Totais do lote e documento (outras moedas)"	"Totais"
Aadd( aButton, {"PREV"     ,{ || CTB105Flt (oGetDb,.F.                   )}, STR0047                     	} ) //"Inconsistencia Anterior"
Aadd( aButton, {"NEXT"     ,{ || CTB105Flt (oGetDb,.T.                   )}, STR0048 						} ) //"Proxima Inconsistencia"
Aadd( aButton, {"BMPSXB"   ,{ || CTB105FtBs(oGetDb,@cExpFil,@cTxtFil     )}, STR0049 						} ) //"Localizar"
While nOpca == 0
	If Type('lCt102Auto')== "U" .Or. !lCt102Auto 
		DEFINE MSDIALOG oDlg TITLE cCadastro From 9,0 To 32,80 OF oMainWnd
		
		DEFINE FONT oFnt 	NAME "Courier New" 	SIZE 0,14	
	
		@ 01.4,aPosCol[1]	Say OemToAnsi(STR0008)					//"Data"
		@ 01.4,aPosCol[2]  	MSGET dDataLanc  Picture "99/99/9999" 	When .F.;
							SIZE 50, 11 OF oDlg
						
		@ 01.4,aPosCol[3]  	Say OemToAnsi(STR0009)					//"Lote"
		@ 01.4,aPosCol[4]	MSGET oLote VAR cLote Picture "@!" When .F. SIZE 32, 11 OF oDlg  
						
		@ 01.4,aPosCol[5]  	Say OemToAnsi(STR0028)					//"Sub-Lote"
		@ 01.4,aPosCol[6]	MSGET cSubLote Picture "!!!"  WHEN .F.;
							SIZE 32, 11 OF oDlg
							
		@ 01.4,aPosCol[7]	Say OemToAnsi(STR0010)					//"Docto"
		@ 01.4,aPosCol[8]	MSGET cDoc Picture "999999" 			When .F.;
							SIZE 34, 11 OF oDlg 
	
		If cPaisLoc == 'CHI'                                                            
			@ 01.4,aPosCol[9]	Say OemToAnsi(STR0035)		//"Correlativo"
			@ 01.4,aPosCol[10]	MSGET cSeqCorr Picture "9999999999" When .F.;
								SIZE 34, 11 OF oDlg 
		EndIf					
	
		aTotais		:= Ctb050Tot(dDataLanc,cLote,cSubLote,cDoc)
		aTotRdpe[1][2]		:= aTotais[1][2] //Valor debito
		aTotRdpe[1][3]		:= aTotais[1][3] //Valor credito	
		aTotRdpe[1][1]		:= aTotais[1][1] //Valor digitado
		
		@130,7    	SAY OemToAnsi(STR0026)	PIXEL 			//"Descri‡„o da Entidade"
		@130,80   	SAY oDescEnt PROMPT space(50) FONT oDlg:oFont PIXEL COLOR CLR_HBLUE	
		
		@12  ,00.8	SAY OemToAnsi(STR0021)  					//"Total Informado :"
		@12.6,00.8	SAY OemToAnsi(STR0022)  					//"Total Digitado  :"
		@12  ,07		SAY oInf 	VAR nTotInf 	Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
		@12.6,07		SAY oDig 	VAR aTotRdpe[1][1]	Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
		@12  ,23		SAY OemToAnsi(STR0023)  					//"Total Debito  :"
		@12.6,23		SAY OemToAnsi(STR0024)  					//"Total Credito :"
		@12  ,30		SAY oDeb 	VAR aTotRdPe[1][2]	Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
		@12.6,30		SAY oCred 	VAR aTotRdPe[1][3] Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
	    
		If nOpc == 3
			nOpcao := 4
		Endif       
	    
	   	If nOpc ==  3 .Or. nOpc == 4
	   		lDel := .T.
		Endif
	
		TMP->(dbSetOrder(0))
	
		Ctb102TamHist()	
	
		SetKey(VK_F4,{ || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc) })
		SetKey(VK_F5,{ || CTB105Flt (oGetDb,.F.                   ) })
		SetKey(VK_F6,{ || CTB105Flt (oGetDb,.T.                   ) })
		SetKey(VK_F7,{ || CTB105FtBs(oGetDb,@cExpFil,@cTxtFil     ) })

		oGetDB := 	MSGetDB():New( 034, 005, 126, 315, nOpcao,;
		 		 	"CT105LINOK", "CT105TOk", "+CT2_LINHA",;
					lDel,aAltera,,.t., MAX_LINHA,"TMP",,,,,,,"CT102DEL")
	
		Ctb102TamHist(.T.)	        
		
		If cLinhaAlt <> "001"
			oGetDB:Goto(Val(cLinhaAlt)) // Posiciona na linha a alterar/visualizar
		EndIf
		
		//Tratamento ref. o Botao para exibir os totais de lote/documento em outras moedas. 
		//SetKey( VK_F5 , { || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc) })		
		//aButton := { { "SIMULACAO" , {|| Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc)} , STR0041+" - <F5>", STR0015 } } //"Totais do lote e documento (outras moedas)"	"Totais"
					
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
		{||nOpca:=1,If(nOpc = 3 .Or. nOpc = 4,If(Ct105TOK(lCT105TOK,lCT105CHK,oGetDB:lModified,,aTotRdpe,nTotInf),oDlg:End(),nOpca:=0),oDlg:End())},;
		{||nOpca:=2,oDlg:End()},,aButton) CENTER                
                   
        If nOpca == 0
            Exit
        EndIf
        
	Else
//		Private aTela[0][0]
//		Private aGets[0]

		aTotais		:= Ctb050Tot(dDataLanc,cLote,cSubLote,cDoc)

		If nOpc <> 5   /// SE FOR INCLUSAO, ALTERACAO
			If 	MsGetDBAuto("TMP",aAutoItens,"CT105LINOK",{|| CT105TOk()},aAutoCab,nOpcao)
				nOpca 	:= 1
			Else
				nOpca 	:= -1		
			EndIf
		Else		   /// SE FOR EXCLUSAO
			If TMP->(RecCount()) > 0
				nOpca := 1    
			Else
				nOpca := -1
			EndIf
		EndIf

	EndIf		
EndDo
If nOpc == 2
	nOpca	:= 0
EndIf


//Se for exclusao de lancamento contabil
If nOpca == 1                          
	If nOpc == 5
		If lCtb102Exc
			lRet	:= ExecBlock("CTB102EXC",.F.,.F.)
			If !lRet
				nOpca := 0		
			EndIf
		EndIf
	EndIf
EndIf

//BEGIN TRANSACTION
	IF nOpcA == 1
	
		If lAnCtb102G
			ExecBlock("ANCTB102GR",.F.,.F.)
		Endif		                                                     
	
		CTBGrava(nOpc,dDataLanc,cLote,cSubLote,cDoc,.F.,cSeqChave,;
   	 		 __lCusto,__lItem,__lCLVL,nTotInf,'CTBA102',,,cEmpOri,cFilOri)			
   	 		 
		If lDpCtb102G
			ExecBlock("DPCTB102GR",.F.,.F.)
		Endif		                                                     
   	 		 
	Else
		CtbDestrava(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK)
		nOpca := 0
	Endif
//END TRANSACTION

DbSelectArea( "CT2" )
TMP->(DbCloseArea())
If Select("cArq1") = 0
	FErase( cArq1+GetDBExtension() )      
	Ferase( cArq1+OrdBagExt() )
	Ferase( cArq2+OrdBagExt() )
EndIf

SET KEY VK_F4 to
SET KEY VK_F5 to
SET KEY VK_F6 to
SET KEY VK_F7 to

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTB102Carr³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega arq. temporario com dados para MSGETDB             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB102Carr(nOpc,dDataLanc,cLote,cSubLote,cDoc)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  ExpN1 = Numero da opcao escolhida                         ³±±
±±³          ³  ExpD1 = Data do lancamento                                ³±±
±±³          ³  ExpC1 = Numero do Lote  	                              ³±±
±±³          ³  ExpC2 = Numero do Sub-Lote 	                              ³±±
±±³          ³  ExpC3 = Numero do Documento		                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB102Carr(nOpc,dDataLanc,cLote,cSubLote,cDoc,cLinhaAlt)

Local aSaveArea	:= GetArea()
Local cAlias	:= "CT2"
Local cCritConv	:= ""
Local nPos
Local cMoeda             
Local nVezes	:= 1
Local nC		:= 0
Local nTamCrit	:= Len(CriaVar("CT2_CONVER"))
Local nCont

DEFAULT cLinhaAlt := "001"  

If nOpc != 3						// Visualizacao / Alteracao / Exclusao
	dbSelectArea("CT2")
	dbSetOrder(1)                          
	
	cLinhaAlt := FieldGet(FieldPos("CT2_LINHA"))                                                               
	
	If MsSeek(xFilial()+Dtos(dDataLanc)+cLote+cSubLote+cDoc)
		If cPaisLoc = "CHI"
			cSeqCorr := CT2->CT2_SEGOFI
		EndIf
		While !Eof() .And. CT2->CT2_FILIAL == xFilial() 	.And.;
							CT2->CT2_DATA == dDataLanc		.And.;
							CT2->CT2_LOTE == cLote 		.And.;
							CT2->CT2_SBLOTE == cSubLote 	.And.;
							CT2->CT2_DOC == cDoc               
							
			//So ira mostrar na Getdb os lancamentos da moeda 01							
			If CT2->CT2_MOEDLC <> '01'
				dbSkip()
				Loop
			EndIf
							
			dbSelectArea("TMP")
			dbAppend()
			For nCont := 1 To Len(aHeader)
				nPos := FieldPos(aHeader[nCont][2])
				If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
					FieldPut(nPos,(cAlias)->(FieldGet(FieldPos(aHeader[nCont][2]))))
				EndIf
			Next nCont
			TMP->CT2_FLAG 		:= .F.
			TMP->CT2_SEQLAN		:= CT2->CT2_SEQLAN
			TMP->CT2_SEQHIS		:= CT2->CT2_SEQHIS
			TMP->CT2_EMPORI		:= CT2->CT2_EMPORI
			TMP->CT2_FILORI		:= CT2->CT2_FILORI
			TMP->CT2_KEY		:= CT2->CT2_KEY
			TMP->CT2_RECNO		:= CT2->(Recno())   
			cCritConv			:= CT2->CT2_CRCONV			
			cMoeda				:= CT2->CT2_MOEDLC                 
			
					
			dbSelectArea("CT2")
			DbSkip()     
							
			While 	! Eof() .And. CT2->CT2_FILIAL == xFilial() .And.;
					CT2->CT2_DATA == dDataLanc					.And.;
					CT2->CT2_LOTE == cLote 						.And.;
					CT2->CT2_SBLOTE == cSubLote 				.And.;
					CT2->CT2_DOC == cDoc						.And.;
					CT2->CT2_TPSALD == TMP->CT2_TPSALD 			.And.;
					CT2->CT2_EMPORI == TMP->CT2_EMPORI 			.And.;
					CT2->CT2_FILORI == TMP->CT2_FILORI			.And.;					
					CT2->CT2_LINHA  == TMP->CT2_LINHA  			.And.;
					CT2->CT2_MOEDLC <> cMoeda
					
					&("TMP->CT2_VALR"+CT2->CT2_MOEDLC) := CT2->CT2_VALOR		

					If CtbUso("CT2_DTTX"+CT2->CT2_MOEDLC)
						&("TMP->CT2_DTTX"+CT2->CT2_MOEDLC)	:= CT2->CT2_DATATX
					EndIf                           					
						
					If Len(cCritConv) <> Val(CT2->CT2_MOEDLC)-1
						nMoeAtu	:= Val(CT2->CT2_MOEDLC)-1
						For nC := Len(cCritConv)+1 to nMoeAtu
						   cCritConv += "5"
						Next
					Endif
					
					cCritConv += CT2->CT2_CRCONV
					nVezes ++
					DbSkip()                     
			EndDo

			If Len(cCritConv) < nTamCrit
				For nC	:= Len(cCritConv)+1 to nTamCrit
					cCritConv += "5"				
				Next    
    		EndIf
	
			If TMP->CT2_DC <> '4'
				TMP->CT2_CONVER	:= cCritConv
			EndIf

		EndDo
	EndIf
Else
	If cPaisLoc = "CHI"
		cSeqCorr := CTBSQCor( CTBSubToPad(cSubLote) )
	EndIf
	dbSelectArea("TMP")
	dbAppend()
	For nCont := 1 To Len(aHeader)
		If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
			nPos := FieldPos(aHeader[nCont][2])
			FieldPut(nPos,CriaVar(aHeader[nCont][2],.T.))
		EndIf
	Next nCont
	For nCont	:= 2 to __nQuantas
		If CtbUso("CT2_DTTX"+StrZero(nCont,2))
			&("TMP->CT2_DTTX"+StrZero(nCont,2))	:= dDataLanc
		EndIf                           
	Next	
	TMP->CT2_FLAG := .F.
	TMP->CT2_LINHA:= "001" 
EndIf

dbSelectArea("TMP")
dbSetOrder(2)
dbGoTop()

RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBEnche  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preenche GetDb com Lancamento Padrao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbEnche(cPadrao,lFirst)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cTipo                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Lancamento Padrao                        ³±±
±±³          ³ ExpL1 = Indica se esta entranado pela primeira vez         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTbEnche(cPadrao,lFirst)

Local aSaveArea	:= GetArea()
Local cCampoCT5
Local cCampoTMP
Local cTipo			:= ""
Local cCriter		:= ""
Local nLen			:= 0
Local nLinha		:= Val(TMP->CT2_LINHA)
Local nValor 		:= 0
Local nCont			:= 0	
Local nPosCT5		:= 0
Local nPosTMP		:= 0
Local nMoeda		:= 0

Local cDCTMP		:= ""			//// TIPO DO LANCAMENTO ADICIONADO
Local cSeqLan		:= ""			//// SEQUENCIA DE LANÇAMENTO
Local cSeqHis		:= ""			//// SEQUENCIA DE HISTORICO

If cPaisLoc == 'CHI'
	cSeqCorr := CTBSQCor( cPadrao)
EndIf

DbSelectArea("CT5")
DbSetOrder(1)
MsSeek(xFilial()+cPadrao)
While !Eof() .And. CT5->CT5_FILIAL == xFilial() .and. CT5->CT5_LANPAD == cPadrao

	DbSelectArea("TMP")
	DbSetOrder(1)
	If lFirst
		// Inclui o primeiro o registro ou substitui.
		dbAppend()      
		//Estava ocorrendo erro de refresh de tela na Getdb quando carregava o TMP com o objeto ja criado
		If oGetDb <> Nil
			oGetDb:nCount++						
		EndIf		
	EndIf
	For nCont := 1 To Len(aHeader)
		// Carrega definicao do campo do CT5 a partir da aHeader do TMP
		dbSelectArea("CT5")       
		If Alltrim(aHeader[nCont][2]) = "CT2_VALOR"	
			cCampoCT5 := "CT5_VLR01"	
		Else
			cCampoCT5 := "CT5_" + Substr(aHeader[nCont][2],5,Len(aHeader[nCont][2]))	
		Endif		
		
		// Procura posicao do campo referente no CTK
		dbSelectArea("TMP")
		If Alltrim(cCampoCT5) == "CT5_VLR01"
			cCampoTMP	:= "CT2_VALOR"
			nPosTmp		:= FieldPos(cCampoTmp)		
		Else
			cCampoTMP	:= Alltrim(aHeader[nCont][2])
			nPosTmp 	:= FieldPos(cCampoTmp)
		EndIf

		If nPosTmp > 0
			If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
				// Carrega dado do CT5
				dbSelectArea("CT5")
				nPosCT5 := FieldPos(cCampoCT5)       
				If nPosCT5 > 0
					If aHeader[nCont][08] == "N"					// Campo Numerico
						If Alltrim(cCampoTMP) == "CT2_VALOR"        
							nValor := Val(&(cCampoCT5))		
							TMP->CT2_VALOR		:= nValor                            
							If TMP->CT2_VALOR	== 0 
								cCriter	:= "5"
							Else
								cCriter	:= "1"
							EndIf
							//Atualiza os valores em outras moedas. 							
							For nMoeda	:= 2 to __nQuantas
								cCampoCT5	:= "CT5->CT5_VLR"+StrZero(nMoeda,2)													
								nValor	:= Val(&(cCampoCT5))																
								&("TMP->CT2_VALR"+StrZero(nMoeda,2)) := nValor            
								If nValor	== 0
									cCriter	+= "5"								
								Else //Criterio Informado                   	
									cCriter	+= "4"
								EndIf
							Next						
							TMP->CT2_CONVER	:= cCriter
						Else
							cValor	:= Trim(FieldGet(nPosCT5))
							dbSelectArea("TMP")
							If !Empty(cValor)
								nValor := &(cValor)
								FieldPut(nPosTMP,nValor)
							Else
								FieldPut(nPosTMP,0)
							EndIf
						EndIf
					ElseIf aHeader[nCont][08] == "C"				// Campo Caracter
						nLen := Len(CriaVar(cCampoTmp))
						cValor := Alltrim(TransLcta(FieldGet(nPosCT5),nLen))
						dbSelectArea("TMP")
						FieldPut(nPosTMP,cValor)
					ElseIf aHeader[nCont][08] == "D"				// Campo Data
						cValor := Alltrim(TransLDta(FieldGet(nPosCT5)))
						dbSelectArea("TMP")
						FieldPut(nPosTMP,cValor)
					EndIf	
				EndIf
			EndIf
		EndIf				
	Next

	If Empty(TMP->CT2_LINHA)	
		nLinha++	
		TMP->CT2_LINHA	:= StrZero(nLinha,3)
	EndIf
	TMP->CT2_FLAG 	:= .F.
	TMP->CT2_LP		:= cPadrao
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//// BLOCO PARA TRATAMENTO E GRAVACAO DO SEQLAN E SEQHIS NO TMP
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	dbSelectArea("TMP")                                                                		
	dbSetOrder(2)
	cDCTMP	:= TMP->CT2_DC
	nRecTMP	:= Recno()                                                         
	dbSkip(-1) 			//Procuro pela sequencia, para poder calcular a proxima. 
	If !Bof() .And. !Eof()   
		If cDCTMP == "4"
			cSeqHis	:= StrZero((Val(TMP->CT2_SEQHIS)+1),3)				
			cSeqLan	:= TMP->CT2_SEQLAN
		Else
			cSeqHis	:= "001"

			If TMP->CT2_DC == "4"			
				While !TMP->(Bof()) .and. TMP->CT2_DC == "4"
					dbSkip(-1)
				End           
				cSeqLan 			:= StrZero((Val(TMP->CT2_SEQLAN)+1),3)										
			Else
				cSeqLan 			:= StrZero((Val(TMP->CT2_SEQLAN)+1),3)			
			EndIf 
		EndIf
	Else 
		cSeqLan 			:= '001'
		cSeqHis 			:= '001'
	Endif			            

	dbGoto(nRecTMP)
	TMP->CT2_SEQLAN		:= cSeqLan
	TMP->CT2_SEQHIS		:= cSeqHis
	/////////////////////////////////////////////////////////////////////////////////////////
	//// FIM DO BLOCO DE GRAVACAO DO SEQLAN E SEQHIS NO TMP
	/////////////////////////////////////////////////////////////////////////////////////////
		
	// Verifica se havera quebra de historico
	dbSelectArea("CT5")
	cHistorico 	:= Alltrim(TransLcta(CT5_HIST,250))
	dbSelectArea("TMP")
	nLen			:= Len(CriaVar("CT2_HIST"))
	If Len(cHistorico) > nLen
		For nCont:= nLen+1 To Len(cHistorico) Step nLen
			cHist := Substr(cHistorico,nCont,nLen)
				cSeqHis	:= StrZero((Val(cSeqHis)+1),3)			
			nLinha++
			dbAppend()            
			If oGetdb <> Nil
				oGetDb:nCount++				
			Endif
			TMP->CT2_DC 	:= "4"
				TMP->CT2_SEQLAN	:= cSeqLan
				TMP->CT2_SEQHIS	:= cSeqHis
			TMP->CT2_HIST	:= cHist
			TMP->CT2_LINHA := StrZero(nLinha,3)
			TMP->CT2_FLAG 	:= .F.
			TMP->CT2_TPSALD	:= CT5->CT5_TPSALD				
			lCont 			:= .T.
		Next									
	EndIf

	//Indexa pela ordem 2 => TMP->CT2_LINHA
	dbSetorder(2)		
	dbSkip()
	If TMP->(Eof())	
		lFirst := .T.
	Else
		nLinha	:= Val(TMP->CT2_LINHA)
	EndIf   
	//Voltar o indice para ordem 1 
	dbSetOrder(1)
	DbSelectArea("CT5")
	dbSetOrder(1)
	DbSkip()

EndDo

dbSelectArea("TMP")
dbSetOrder(2)
//dbGoTop()
cTipo := TMP->CT2_DC    

RestArea(aSaveArea)

Return cTipo

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³C102CapOK ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida dados digitados na capa de lote                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C102CapOk(dData,cLote,cSublote,cDoc)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC1 = Lote  do Lancamento Contabil                       ³±±
±±³          ³ ExpC2 = SubLote do Lancamento Contabil                     ³±±
±±³          ³ ExpC3 = Documento do lancamento contabil                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function c102CapOk(dData,cLote,cSubLote,cDoc)

Local lRet := .T.

If Empty(dData) .Or. Empty(cLote) .Or. Empty(cSubLote) .Or. Empty(cDoc)
	Help(" ",1,"NOCAPLOTE")
	lRet := .F.
EndIf	

Return lret

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbEscPad ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Escolhe lancamento Padrao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbEscPad(lCancel)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cRet                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Define se confirmou ou cancelou                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function CtbEscPad(lCancel)

Local aSaveArea:= GetArea()
Local aPadrao 	:= {}
Local cRet		:= ""
Local cCodAnt	:= ""
Local cListBox
Local nCont		:= 0
Local nOpca 	
Local oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com Lan‡amentos Padronizados                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CT5")
MsSeek(cFilial)
While !Eof() .and. CT5->CT5_FILIAL == xFilial() .And. Val(CT5->CT5_LANPAD) < 500
	IF nCont == 0
		cCodAnt := CT5->CT5_LANPAD
		nCont := 1
		Aadd(aPadrao,CT5_LANPAD+"   "+"   "+CT5_DESC)
	EndIF 
	IF cCodAnt != CT5->CT5_LANPAD
		nCont := 0
		Loop
	EndIF
	dbSkip()
EndDO
If Len(aPadrao) == 0
	Return Nil
EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha tela para escolhida do Padronizado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cListBox := aPadrao[1]
nOpca := 0
DEFINE MSDIALOG oDlg FROM 5, 5 TO 14, 50 TITLE OemToAnsi(STR0012)		 //"Escolha Lanc Padrao"
@  .5, 2 LISTBOX cListBox ITEMS aPadrao SIZE 150 , 40 Font oDlg:oFont 
	DEFINE SBUTTON FROM 055,112   TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 055,139.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
If nOpca == 1 
	cRet:=Substr(cListBox,1,3)
Else
	lCancel := .T.
	Return Nil
Endif

RestArea(aSaveArea)

Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbEscRat ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Escolhe Rateio On-Line                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbEscRat(lCancel)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Matriz com rateios cadastrados no CT9                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Define se confirmou ou cancelou                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function CtbEscRat(lCancel)

Local aRateio	:= {}, aRatEnt := {}
Local aRat		:= {}
Local cCodAnt
Local cListBox
Local oDlg
Local nCont 	:= 0
Local nValRat	:= 0
Local nOpca		:= 0
Local nPos		:= 0
Local cTpEntida := " " 
Local lDebito	:= .F.
Local lCredito	:= .F.
Local cHistorico := CriaVar("CT2_HIST")

Local lRATONFIL := ExistBlock("RATONFIL",.T.,.F.)					////  SE EXISTIR O PE RATONFIL
Private cDebito	 := CriaVar("CT2_DEBITO")
Private cCredito := CriaVar("CT2_CREDIT") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com rateios pr‚-cadastrados                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CT9")
dbSetOrder(1)
MsSeek(xFilial())
While !Eof() .and. CT9->CT9_FILIAL == xFilial()
	IF nCont == 0
		If lRATONFIL					////  SE EXISTIR O PE RATONFIL
			If EXECBLOCK("RATONFIL",.F.,.F.)
				CT9->(dbSkip())			////  NÃO INCLUI NA SELEÇÃO DE RATEIOS
				Loop					////  PASSA PARA O PROXIMO
			Endif
		Endif
		cCodAnt	:= CT9_RAT_ON
		nCont := 1
		Aadd(aRateio, CT9_RAT_ON+" "+CT9_DESC)

		cTpEntida := " " 
		lDebito   := Ct100TpRat("1", @cTpEntida, "CT9")
		lCredito  := Ct100TpRat("2", @cTpEntida, "CT9")
		
		Aadd(aRatEnt, { cTpEntida > "0", cTpEntida })
	EndIF 

	IF cCodAnt != CT9_RAT_ON
		nCont := 0
		Loop
	EndIF
	dbSkip()
EndDO

If Len(aRateio) == 0
	lCancel := .F.
	Return aRat
EndIf	

nOpca := 0
cListBox := aRateio[1]
DEFINE MSDIALOG oDlg FROM 5, 5 TO 21, 50 TITLE OemToAnsi(STR0013)  //"Escolha Rateio"
	@  .5,2 	Say OemToAnsi(STR0014)  //"Valor a Ratear : " 
	@  .5,9.5 	MSGET nValRat Pict "@E 99999,999,999.99" Valid Positivo(nValRat)
	@  1.7, 2 	LISTBOX cListBox ITEMS aRateio SIZE 150 , 40 Font oDlg:oFont; 
				On Change CtbDigCta(aRateio, cListBox, aRatEnt, oSayDeb, oDebito, oSayCrd, oCredito) 

	@ 5.2,2 	Say oSayDeb Prompt STR0031 //"Conta a Debito"
	@ 5.2,12 	MSGET oDebito Var cDebito;
				F3 "CT1" Picture "@!" Valid Ctb105Cta(cDebito) SIZE 070,8
	@ 6.2,2 	Say oSayCrd Prompt STR0032 //"Conta a Credito"
	@ 6.2,12 	MSGET oCredito Var cCredito;
				F3 "CT1" Picture "@!" Valid Ctb105Cta(cCredito) SIZE 070,8
	@ 7.2,0.4	Say STR0033 //"Historico"
	@ 7.2,3.3  	MSGET cHistorico Picture PesqPict("CT2", "CT2_HIST") SIZE 150,8
				
	CtbDigCta(aRateio, cListBox, aRatEnt, oSayDeb, oDebito, oSayCrd, oCredito) 				

	DEFINE	SBUTTON FROM 105,110 TYPE 1;
			ACTION 	If(aRatEnt[nPos := Ascan(aRateio, cListBox)][1] .And.;
					! CtbValCta(cDebito, cCredito, aRatEnt[nPos][2]),;
					(nOpca := 0, Help(" ",1,"CT9DEBCRED")),;
					(nOpca := 1,oDlg:End())) ENABLE OF oDlg
	DEFINE 	SBUTTON FROM 105,138 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

IF nOpca != 0 .And. nValRat > 0
	AADD(aRat,Subs(cListBox,1,6))
	AADD(aRat,nValRat)
	If aRatEnt[nPos][1]
		AADD(aRat,cDebito)
		AADD(aRat,cCredito)
	Else
		AADD(aRat,"")
		AADD(aRat,"")
	Endif	
	AADD(aRat,cHistorico)
ElseIf nOpca == 0
	lCancel := .T.	
EndIF

Return aRat

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbDigCta ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 06.05.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Habilita/Desabilita objetos para digitacao da conta        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbDigCta(aRateio, cListBox, aRatEnt, oSayDeb, oDebito,    ³±±
±±³          ³ oSayCrd, oCredito)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F. = Se sim permite a digitacao das contas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aRateio  = Matriz do listbox para escolha do usuario       ³±±
±±³          ³ cListBox = Item selecionado                                ³±±
±±³          ³ aRatEnt  = Matriz indicando se permite ou nao digitar cta  ³±±
±±³          ³ oSayDeb  = Objeto say da digitacao a debito                ³±±
±±³          ³ oDebito  = Objeto da digitacao da conta a debito           ³±±
±±³          ³ oSayCrd  = Objeto say da digitacao a credito               ³±±
±±³          ³ oCredito = Objeto da digitacao da conta a credito          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Static Function CtbDigCta(aRateio, cListBox, aRatEnt, oSayDeb, oDebito, oSayCrd, oCredito)

Local nPos := Ascan(aRateio, cListBox)

If aRatEnt[nPos][1]
	oSayDeb:Enable()
	oDebito:Enable()
	oSayCrd:Enable()
	oCredito:Enable()
Else
	oSayDeb:Disable()
	oDebito:Disable()
	oSayCrd:Disable()
	oCredito:Disable()
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbValCta ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 06.05.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a digitacao das contas para rateio gerencial      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbValCta(cDebito, cCredito)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F. = Se sim permite a digitacao das contas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cDebito  = Conta digitada a debito do rateio gerencial     ³±±
±±³          ³ cCredito = Conta digitada a crebito do rateio gerencial    ³±±
±±³          ³ cTpEntida = Variavel que identifica validacao por entidade ³±±
±±³          ³ 1 = Identifica que todos os registro verificara CC         ³±±
±±³          ³ 2 = Identifica que todos os registro verificara Item       ³±±
±±³          ³ 3 = Identifica que todos os registro verificara Classe Val.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function CtbValCta(cDebito, cCredito, cTpEntida)

Local lRet := .F.

If ! Empty(cDebito) .And. CT1->(MsSeek(xFilial() + cDebito))
	If cTpEntida = "1" .And. CT1->CT1_ACCUST <> "2"
		lRet := .T.
	Endif	
	If cTpEntida = "2" .And. CT1->CT1_ACITEM <> "2"
		lRet := .T.
	Endif	
	If cTpEntida = "3" .And. CT1->CT1_ACCLVL <> "2"
		lRet := .T.
	Endif	
Endif

If ! lRet .And. ! Empty(cCredito) .And. CT1->(MsSeek(xFilial() + cCredito))
	If cTpEntida = "1" .And. CT1->CT1_ACCUST <> "2"
		lRet := .T.
	Endif	
	If cTpEntida = "2" .And. CT1->CT1_ACITEM <> "2"
		lRet := .T.
	Endif	
	If cTpEntida = "3" .And. CT1->CT1_ACCLVL <> "2"
		lRet := .T.
	Endif	
Endif

If Empty(cDebito) .And. Empty(cCredito)
	lRet := .F.
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbRateio ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula valores do rateio                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbRateio(cRateio,nValRateio,nTotalDeb,nTotalCrd,cDebito,   ³±±
±±³          ³          cCredito)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Tipo do 1o. registro do rateio                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1      = Codigo do Rateio                               ³±±
±±³          ³ExpN1      = Valor do  Rateio                               ³±±
±±³          ³ExpN2      = Valor Total debito                             ³±±
±±³          ³ExpN3      = Valor Total Credito                            ³±±
±±³          ³cDebito    = Valor Total debito                             ³±±
±±³          ³cCredito   = Valor Total Credito                            ³±±
±±³          ³cHistorico = Historico para repetir nas linhas rateio       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function CtbRateio(cRateio,nValRateio,nTotalDeb,nTotalCrd,cDebito,cCredito,cHistorico)

Local cCONVER	:= "1"
Local cValor
Local cTipoRat := "5" 			// Retorno p/ sair do loop de atualizacao da GetDb

Local dValor

Local lFirst	:= .T.
Local lDebito	:= .F.
Local lCredito	:= .F.

Local nSeq
Local nTotRegTMP	:= 0
Local nValor
Local nValLinha
Local nPerBase
Local nPosCT9
Local nDif			:= 0
Local nRecno
Local nRegDeb, nRegCrd
Local nPosTMP
Local nCont			:= 0 

Local cDCTMP		:= ""
Local cSeqLan		:= ""
Local cSeqHis		:= ""
Local nOrdTMP		:= 1
Default cDebito 	:= ""
Default cCredito	:= ""

dbSelectArea("TMP")
nTotRegTMP := RecCount()

dbGoto(nTotRegTMP)
nSeq	:= Val(TMP->CT2_LINHA)

dbSelectArea("CT9")
dbSetOrder(1)
If MsSeek(xFilial()+cRateio)
	cMoeda		:= CT9->CT9_MOEDLC
	nPerBase 	:= CT9->CT9_PERBAS
	nValRateio	:= (nValRateio * (nPerBase/100))
	nTotalDeb	:= 0
	nTotalCrd	:= 0
EndIf

While !Eof() .and. CT9->CT9_FILIAL == xFilial() .And. CT9->CT9_RAT_ON == cRateio
   If CT9->CT9_PERCEN > 0
		dbSelectArea("TMP")
		If !lFirst
			nSeq++
			dbAppend()
			oGetDb:nCount++	
		EndIf	
		                     	
		cCONVER := "1"
		// Carrega campos -> Relacao entre CT9 X TMP (CT2)
		For nPosTMP := 1 To Fcount()
			dbSelectArea("TMP")
			cCampoTMP := FieldName(nPosTMP)
	
			// Carrega definicao do campo do CT9 a partir do TMP
			dbSelectArea("CT9")
			cCampoCT9 := "CT9_" + Substr(cCampoTMP,5,Len(cCampoTMP))
	
			If cCampoTMP == "CT2_CONVER"
				If !Empty(dDataLanc)			
					For nCont := 1 to len(CT9->CT9_CRITER) 			
						aPeriodos	:= CtbPeriodos(StrZero(nCont+1,2),dDataLanc,dDataLanc,.F.,.F.) 														
						If !Empty(aPeriodos[1][1]) 
							If aPeriodos[1][4] $ "1" .AND. Empty(Substr(TMP->CT2_CONVER,nCont,1)) .and. !Substr(CT9->CT9_MOEDAS,nCont,1) $ " 2" 
								If Empty(Substr(CT9->CT9_CRITER,nCont,1))
									cCONVER += "5"
								Else
									cCONVER += Subs(CT9->CT9_CRITER,nCont,1)
								Endif
							ElseIf !Empty(Substr(TMP->CT2_CONVER,nCont,1))
								cCONVER += Substr(TMP->CT2_CONVER,nCont,1)
							Else 
								cCONVER	+= "5"
							EndIf
						Else
							cCONVER += "5"
						EndIf             
					Next
				Else
					cCONVER += &("CT9->CT9_CRITER")
				EndIf			
				dbSelectArea("TMP")
				FieldPut(nPosTMP,cCONVER)
			Else
				// Carrega dado do CT9
				dbSelectArea("CT9")
				nPosCT9 := FieldPos(cCampoCT9)
				If nPosCT9 > 0
					dbSelectArea("TMP")
					If ValType(&(cCampoTMP)) == "N"						// Campo Numerico
						dbSelectArea("CT9")
						nValor	:= FieldGet(nPosCT9)
						dbSelectArea("TMP")
						FieldPut(nPosTMP,nValor)
					ElseIf ValType(&(cCampoTMP)) == "C"				// Campo Caracter    
						dbSelectArea("CT9")
						cValor := Alltrim(FieldGet(nPosCT9))
						dbSelectArea("TMP")
						FieldPut(nPosTMP,cValor)
					ElseIf ValType(&(cCampoCTK)) == "D"				// Campo Data
						dValor := FieldGet(nPosCT5)
						dbSelectArea("TMP")
						FieldPut(nPosTMP,dValor)
					EndIf	
				EndIf
			Endif
		Next
		TMP->CT2_LINHA 	:= StrZero(nSeq,3)
		If CtbUso("CT2_DCD")						//  Digito de Controle
			If !Empty(TMP->CT2_DEBITO)
				dbSelectArea("CT1")
				dbSetOrder(1)
				If MsSeek(xFilial()+TMP->CT2_DEBITO)
					TMP->CT2_DCD	:= CT1->CT1_DC
				EndIf
				dbSelectArea("CT9")
			EndIf
		EndIf                           
		
		If CtbUso("CT2_DCC")						//  Digito de Controle							
			If !Empty(TMP->CT2_CREDIT)
				dbSelectArea("CT1")
				dbSetOrder(1)
				If MsSeek(xFilial()+TMP->CT2_CREDIT)
					TMP->CT2_DCC	:= CT1->CT1_DC
				EndIf
				dbSelectArea("CT9")		
			EndIf
		EndIf		

		If ! Empty(cDebito) .Or. ! Empty(cCredito)
			If ! Empty(cDebito) .And. ! Empty(cCredito)
				//Definido que o tipo de lancamento contabil sera definido por centro de custo, item ou classe de valor
				//na ordem hierarquica acima.	
				If !Empty(CT9->CT9_CCD) .Or. !Empty(CT9->CT9_CCC)
					If !Empty(CT9->CT9_CCD) .And. Empty(CT9->CT9_CCC)
						TMP->CT2_DC	:= "1"
					ElseIf Empty(CT9->CT9_CCD) .And. !Empty(CT9->CT9_CCC)
						TMP->CT2_DC	:= "2"
					Else	
						TMP->CT2_DC := "3"
					EndIf
				ElseIf !Empty(CT9->CT9_ITEMD) .Or. !Empty(CT9->CT9_ITEMC)
					If !Empty(CT9->CT9_ITEMD) .And. Empty(CT9->CT9_ITEMC)
						TMP->CT2_DC	:= "1"
					ElseIf Empty(CT9->CT9_ITEMD) .And. !Empty(CT9->CT9_ITEMC)
						TMP->CT2_DC	:= "2"
					Else	
						TMP->CT2_DC := "3"
					EndIf					                                                 
				ElseIf !Empty(CT9->CT9_CLVLDB) .Or. !Empty(CT9->CT9_CLVLCR)
					If !Empty(CT9->CT9_CLVLDB) .And. Empty(CT9->CT9_CLVLCR)
						TMP->CT2_DC	:= "1"
					ElseIf Empty(CT9->CT9_CLVLDB) .And. !Empty(CT9->CT9_CLVLCR)
						TMP->CT2_DC	:= "2"
					Else	
						TMP->CT2_DC := "3"
					EndIf
				Else
					TMP->CT2_DC	:= "3"				
				EndIf					
			ElseIf ! Empty(cDebito)
				TMP->CT2_DC := "1"
			Else
				TMP->CT2_DC := "2"
			Endif
			If TMP->CT2_DC	$"1/3"
				TMP->CT2_DEBITO := cDebito			
				If CtbUso("CT2_DCD")						//  Digito de Controle
					If !Empty(TMP->CT2_DEBITO)
						dbSelectArea("CT1")
						dbSetOrder(1)
						If MsSeek(xFilial()+TMP->CT2_DEBITO)
							TMP->CT2_DCD	:= CT1->CT1_DC
						EndIf
						dbSelectArea("CT9")
					EndIf
				EndIf                           
			EndIf
			     
			If TMP->CT2_DC	$ "2/3"
				TMP->CT2_CREDIT := cCredito
				If CtbUso("CT2_DCC")						//  Digito de Controle							
					If !Empty(TMP->CT2_CREDIT)
						dbSelectArea("CT1")
						dbSetOrder(1)
						If MsSeek(xFilial()+TMP->CT2_CREDIT)
							TMP->CT2_DCC	:= CT1->CT1_DC
						EndIf
						dbSelectArea("CT9")		
					EndIf
				EndIf
			EndIF
			
			If ! Empty(cDebito)
				CT1->(MsSeek(xFilial() + cDebito))
				If CT1->CT1_ACCUST = "2"
					TMP->CT2_CCD := ""
				Endif				
				If CT1->CT1_ACITEM = "2"
					TMP->CT2_ITEMD	:= ""
				Endif
				If CT1->CT1_ACCLVL = "2"
					TMP->CT2_CLVLDB	:= ""
				Endif
			Else		// Zero todas as entidades a debito caso nao digite a debito
				TMP->CT2_CCD	:= ""
				TMP->CT2_ITEMD	:= ""
				TMP->CT2_CLVLDB	:= ""
			Endif
			
			If ! Empty(cCredito)
				CT1->(MsSeek(xFilial() + cCredito))
				If CT1->CT1_ACCUST = "2"
					TMP->CT2_CCC	:= ""
				Endif				
				If CT1->CT1_ACITEM = "2"
					TMP->CT2_ITEMC	:= ""
				Endif
				If CT1->CT1_ACCLVL = "2"
					TMP->CT2_CLVLCR	:= ""
				Endif
			Else		// Zero todas as entidades a debito caso nao digite a credito
				TMP->CT2_CCC	:= ""
				TMP->CT2_ITEMC	:= ""
				TMP->CT2_CLVLCR	:= ""
			Endif
		Endif
		
		If lFirst
			cTipoRat := TMP->CT2_DC
		EndIf	
	
		//////////////////////////////////////////////////////////////////////////////////////////////////////	
		//// BLOCO PARA TRATAMENTO E GRAVACAO DO SEQLAN E SEQHIS NO TMP
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		dbSelectArea("TMP")                                                                		
		nRecTMP	:= Recno()
		nOrdTMP	:= IndexOrd()
		cDCTMP	:= TMP->CT2_DC
		dbSetOrder(2)
		dbSkip(-1) 			//Procuro pela sequencia, para poder calcular a proxima. 
		If !Bof() .And. !Eof()   
			If cDCTMP == "4"
				cSeqHis	:= StrZero((Val(TMP->CT2_SEQHIS)+1),3)				
				cSeqLan	:= TMP->CT2_SEQLAN
			Else
		   		cSeqHis	:= "001"

				If TMP->CT2_DC == "4"			
					While !TMP->(Bof()) .and. TMP->CT2_DC == "4"
						dbSkip(-1)
					End           
					cSeqLan 			:= StrZero((Val(TMP->CT2_SEQLAN)+1),3)										
				Else
					cSeqLan 			:= StrZero((Val(TMP->CT2_SEQLAN)+1),3)			
				EndIf 
			EndIf
		Else 
			cSeqLan 			:= '001'
			cSeqHis 			:= '001'
   		Endif			            

		dbGoto(nRecTMP)
		dbSetOrder(nOrdTMP)
		TMP->CT2_SEQLAN		:= cSeqLan
		TMP->CT2_SEQHIS		:= cSeqHis
		/////////////////////////////////////////////////////////////////////////////////////////
		//// FIM DO BLOCO DE GRAVACAO DO SEQLAN E SEQHIS NO TMP
		/////////////////////////////////////////////////////////////////////////////////////////
		// Carrega valor do Rateio  
		nPercentual := CT9->CT9_PERCEN
		nValLinha 	:= Round(NoRound((nValRateio * (nPercentual / 100)),3),2)
		If cMoeda ='01'	
			TMP->CT2_VALOR := nValLinha
		Else                                      
			&('TMP->CT2_VALR'+cMoeda) := nValLinha		
		EndIf		
		If ! Empty(cHistorico)
			TMP->CT2_HIST := cHistorico
		Endif
	
		If TMP->CT2_DC == "1"
			nTotalDeb	+= nValLinha
			nRegDeb 	:= TMP->(Recno())
		EndIf
		If TMP->CT2_DC =="2"
			nTotalCrd	+= nValLinha
			nRegCrd		:= TMP->(Recno())
		EndIf
		If TMP->CT2_DC =="3"
			// Neste caso nao armazeno o numero do registro, pois se houve diferenca somente
			// no debito, nao posso altera-lo uma vez que os valores sao lancados a debito e 
			// a credito.
			nTotalCrd += nValLinha
			nTotalDeb += nValLinha
		EndIf
		
		dbSelectArea("CT9")
		dbSetOrder(1)  
		dbSkip()
		nRecno := Recno()	
		lFirst := .F.
		
		IF (Eof() .Or. CT9->CT9_FILIAL != xFilial() .or. CT9->CT9_RAT_ON != cRateio)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se for o £ltimo lan‡amento, acerta arredondamento			 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("TMP")

// Bops 15589 - Testar se valor a debito ou a credito foi rateado para lancar diferenca			
			
			lDebito  := .F.
			lCredito := .F.
			If nTotalDeb # 0 .And. nTotalDeb != nValRateio
				lDebito := .T.
			EndIf
			If nTotalCrd # 0 .And. nTotalCrd != nValRateio
				lCredito := .T.
			EndIf			
			If lDebito
				nRegTmp := Recno()
				If nRegDeb <> Nil .And. TMP->CT2_DC <> '1'	// Posiciono no registro a debito
					dbGoto(nRegDeb)			// caso nao seja tipo de lacto a debito
				EndIf
				If TMP->CT2_DC <> '3'		// Bops 15303 - Nao altero o valor a debito
					nDif 		:= nValRateio - nTotalDeb	// Somente no teste a credito
					If cMoeda ='01'
						nValor 		:= Round(NoRound((TMP->CT2_VALOR + nDif),3),2)
					Else
						nValor 		:= Round(NoRound((&('TMP->CT2_VALR'+cMoeda) + nDif),3),2)					
					EndIf
					nTotalDeb   += nDif
					If cMoeda='01'                        
						TMP->CT2_VALOR := nValor					
					Else                                   					
						&('TMP->CT2_VALR'+cMoeda) := nValor
					EndIf
				Endif
				DbGoto(nRegTmp)
			EndIf	
			If lCredito
				nRegTmp := Recno()
				If nRegCrd <> Nil .And. TMP->CT2_DC <> '2'	// Posiciono no registro a credito
					dbGoto(nRegCrd)			// caso nao seja tipo de lacto a credito
				EndIf
				nDif 		:= nValRateio - nTotalCrd          
				If cMoeda = '01'                                                          
					nValor 		:= Round(NoRound((TMP->CT2_VALOR + nDif),3),2)				
					TMP->CT2_VALOR := nValor
				Else
					nValor 		:= Round(NoRound((&('TMP->CT2_VALR'+cMoeda) + nDif),3),2)
					&('TMP->CT2_VALR'+cMoeda) := nValor
				EndIf
				nTotalCrd   += nDif
				If TMP->CT2_DC = '3'
					nTotalDeb += nDif
				Endif
				DbGoto(nRegTmp)
			EndIf
		EndIf	
		dbSelectArea("CT9")
		dbGoto(nRecno)
		/// EFETUA A CONVERSÃO DOS VALORES DE OUTRAS MOEDAS
		Ctb105Conv(TMP->CT2_VALOR,TMP->CT2_CONVER)
	Else
		dbSelectArea("CT9")
		dbSkip()
	Endif	
EndDo	

Return cTipoRat

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct102VlDoc³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se existe num. lote e doc e nao deixa incluir.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct102VlDoc(dData,cLote,cSubLote,cDoc,cProg)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC1 = Lote do Lancamento Contabil                        ³±±
±±³          ³ ExpC2 = Documento do Lancamento Contabil                   ³±±
±±³          ³ ExpO1 = Objeto do documento                                ³±±
±±³          ³ ExpN1 = Semaforo para proximo documento                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct102VlDoc(dData,cLote,cSubLote,cDoc,cProg)

Local lRet 		:= .T., aArea := GetArea()
Local aSaveArea := CT2->(GetArea())

If 	dData <> Nil .And. cLote <> Nil .And. cSubLote <> Nil .And. cDoc <> Nil .And.;
	(cProg == 'CTBA102' .Or. cProg == 'CTBA105')
	dbSelectArea("CTF")
	dbSetOrder(1)
	If MsSeek(xFilial("CTF")+dtos(dData)+cLote+cSubLote+cDoc) .And. !Empty(CTF->CTF_LINHA)
		///Help("",1,"USEDCODE")
		lRet := .F.
	Endif
	
    If lRet		// Verifico tambem no arquivo de lancamentos como garantia
		dbSelectArea("CT2")
		dbSetOrder(1)
		If MsSeek(xFilial("CT2")+dtos(dData)+cLote+cSubLote+cDoc)
			///Help("",1,"USEDCODE")
			lRet := .F.
		Endif
	Endif
	
	If ! lRet
		Help(" ",1,"LOTDOCEX")
	Endif
	CT2->(RestArea(aSaveArea))
	RestArea(aArea)
Endif

Return lRet                                               

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct102GrCTF³ Autor ³ Simone Mie Sato		³ Data ³ 20.01.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava arquivo CTF.								  	 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct102GrCtf(dDataLanc,cLote,cSubLote,cDoc,CTF_LOCK)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC1 = Lote do Lancamento Contabil                        ³±±
±±³          ³ ExpC2 = Sub-Lote  do Lancamento Contabil                   ³±±
±±³          ³ ExpC3 = Documento do Lancamento Contabil                   ³±±
±±³          ³ ExpN1 = Semaforo para proximo documento                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct102GrCTF(dDataLanc,cLote,cSubLote,cDoc,CTF_LOCK) 

Local lRet 		:= .T.
Local aSaveArea := GetArea()  
Local nCT2Ind	:= CT2->(IndexOrd())
Local nCT2Rec	:= CT2->(Recno())
Local cNameFun	:= FunName()

dbSelectArea("CT2")
dbSetOrder(1)
If MsSeek(xFilial("CT2")+dtos(dDataLanc)+cLote+cSubLote+cDoc)
	If cNameFun != "CTBA101"
		lRet := .F.					/// SE ENCONTROU CT2 COM A CHAVE (JÁ RETORNA .f. NA VALIDACAO)
	Endif
Endif
            
If lRet
	dbSelectArea("CTF")			/// EFETUA NOVAMENTE A CHECAGEM DO CTF 
	dbSetOrder(1)				/// PARA GARANTIR CASO POR ALGUM MOTIVO NÃO TENHA GRAVADO O CTF
	If !MsSeek(xFilial("CTF")+dtos(dDataLanc)+cLote+cSubLote+cDoc)
		LockDoc(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK)	// Trava documento no Semaforo
	Else
		If CTF->(RLock())
			If Empty(CTF_LINHA)
				CTF_LOCK := CTF->(Recno())	/// SE NÃO ESTIVER "LOCADO" USA O NUMERO (RLOCK PARA RETORNAR .F. SE NÃO CONSEGUIU O HANDLE
			Else
				If cNameFun != "CTBA101"
					Help("",1,"EXISTCHAV")/// NÃO ESTA LOCADO MAS O NUMERO DE LINHA ESTA PREENCHIDO
					lRet := .F.  		///A chave ja existe, mostra help
				Else
					CTF_LOCK := CTF->(Recno())	/// USA O NUMERO (RLOCK PARA RETORNAR .F. SE NÃO CONSEGUIU O HANDLE				
				Endif
			Endif
		Else      
			Help("",1,"USEDCODE")/// SE ESTÁ "LOCADO" INDICA USO POR OUTRO USUARIO
			lRet := .F.  		///Se achou e esta bloqueado, mostra Help de acordo com a chave de valida‡„o 
		Endif
	Endif
Endif

CT2->(dbSetOrder(nCT2Ind))
CT2->(dbGoTo(nCT2Rec))		                    
RestArea(aSaveArea)
	
Return lRet                                               

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programaa ³C102ExbCta³Autor  ³ Simone Mie Sato		³ Data ³ 12.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe descricao da conta contabil na MSGETDB				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C102ExbCta(cConta)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Conta Contabil		                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function C102ExbCta(cConta)                                                                      
                    
Local cDesc := ""       

dbSelectArea("CT1")
dbSetOrder(1)
If MsSeek(xFilial()+cConta)
	If CT1->CT1_CLASSE == "1"  .or. cDesc == Nil
		cDesc := Space(25)
	ElseIf CT1->CT1_CLASSE == "2" 
		If cConta == Nil .Or. Empty(cConta)
			cDesc := Space(25)
		Else    
			cDesc := CT1->CT1_DESC01
		EndIf   
	EndIf   
EndIf

IF Type("oDescEnt")="O"
	oDescEnt:SetText(OemToAnsi(cDesc))
	oDescEnt:Refresh()
Endif                                   

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C102ExbCC ³Autor  ³ Simone Mie Sato		³ Data ³ 12.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe descricao do Centro de Custo na MSGETDB			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³C102ExbCC(cCusto)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Centro de Custo					      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function C102ExbCC(cCusto)                                                                      
                    
Local cDesc := ""

If CTT->CTT_CLASSE == "1"  .or. cDesc == Nil
	cDesc := Space(25)
ElseIf CTT->CTT_CLASSE == "2" 
	If cCusto == Nil .Or. Empty(cCusto)
		cDesc := Space(25)
	Else    
		cDesc := CTT->CTT_DESC01
	EndIf   
EndIf   

IF Type("oDescEnt")="O"
	oDescEnt:SetText(OemToAnsi(cDesc))
	oDescEnt:Refresh()
Endif                                   

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C102ExbIt ³Autor  ³ Simone Mie Sato		³ Data ³ 12.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe descricao do Item Contabil   na MSGETDB			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³C102ExbIt(cItem)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Item Contabil  					      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function C102ExbIt(cItem)                                                                      
                    
Local cDesc := ""

If CTD->CTD_CLASSE == "1"  .or. cDesc == Nil
	cDesc := Space(25)
ElseIf CTD->CTD_CLASSE == "2" 
	If cItem == Nil .Or. Empty(cItem)
		cDesc := Space(25)
	Else    
		cDesc := CTD->CTD_DESC01
	EndIf   
EndIf   

IF Type("oDescEnt")="O"
	oDescEnt:SetText(OemToAnsi(cDesc))
	oDescEnt:Refresh()
Endif                                   

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C102ExbCV ³Autor  ³ Simone Mie Sato		³ Data ³ 12.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe descricao da Classe de Valor na MSGETDB			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³C102ExbCV(cClVl)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Classe de Valor					      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function C102ExbCV(cClVl)                                                                      
                    
Local cDesc := ""

If CTH->CTH_CLASSE == "1"  .or. cDesc == Nil
	cDesc := Space(25)
ElseIf CTH->CTH_CLASSE == "2" 
	If cClVl == Nil .Or. Empty(cClVl)
		cDesc := Space(25)
	Else    
		cDesc := CTH->CTH_DESC01
	EndIf   
EndIf   

IF Type("oDescEnt")="O"
	oDescEnt:SetText(OemToAnsi(cDesc))
	oDescEnt:Refresh()
Endif                                   

Return(.T.)        

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C102ProxDoc³ Autor ³ Simone Mie Sato       ³ Data ³17.04.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Sugere proximo documento,quando altera o num. do lote.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³C102ProxDoc(dDataLanc,cLote,cSubLote,cDoc,oLote,oSublote,oDoc³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA102                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento                                  ³±±
±±³          ³ ExpC1 = Numero do Lote do Lancamento                        ³±±
±±³          ³ ExpC2 = Numero do Sub-Lote do Lancamento                    ³±±
±±³          ³ ExpC3 = Numero do documento do Lancamento                   ³±±
±±³          ³ ExpO1 = Objeto do Lote                                      ³±±
±±³          ³ ExpO2 = Objeto do Sub-Lote                                  ³±±
±±³          ³ ExpO3 = Objeto do Documento                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function C102ProxDoc(dDataLanc,cLote,cSubLote,cDoc,oLote,oSubLote,oDoc,CTF_LOCK)

Local aSaveArea := GetArea()
Local cKeyCTF   := ""
Local nIndCT2	:= CT2->(IndexOrd())
Local nRecCT2	:= CT2->(Recno())
dbSelectArea("CTF")
cKeyCTF := xFilial("CTF")+Dtos(dDataLanc)+cLote+cSubLote	//// CHAVE PARCIAL DO CTF
           
If CTF_LOCK > 0							/// INDICA ALTERACAO/EXCLUSAO
	DbGoto(CTF_LOCK)
	If cKeyCTF == CTF->(CTF_FILIAL+dtos(CTF_DATA)+CTF_LOTE+CTF_SBLOTE) 
		CT2->(DbSetOrder(1))
		If !CT2->(MsSeek(cKeyCTF+cDoc))		//// SE NÃO ENCONTRAR CT2 INDICA QUE NÃO HOUVE GRAVAÇÃO COM A MESMA CHAVE
			CT2->(dbSetOrder(nIndCT2))		
			CT2->(dbGoTo(nRecCT2))			
			RestArea(aSaveArea)				
			Return .T.						//// ENTÃO SÓ RETORNA .T. INDICANDO QUE A CHAVE É VALIDA
		Else
			UnLockDoc(@CTF_LOCK)			//// LIBERA O REGISTRO POIS JÁ EXISTE LANÇAMENTO NO CT2 (DE OUTRO USUÁRIO POIS AINDA ESTOU NA TELA)
		Endif
	Else
		//UnLockDoc(@CTF_LOCK)			//// SE NÃO É MAIS A MESMA CHAVE DO CTF_LOCK... LIBERA O CTF DA CAPA DE LOTE ANTERIOR
		CtbDestrava(CTF->CTF_DATA,CTF->CTF_LOTE,CTF->CTF_SBLOTE,CTF->CTF_DOC,@CTF_LOCK)		///	(MAS CHECA SE OUTRO USUÁRIO NAO GRAVOU CT2 COM O MESMO NUMERO PARA NÃO DELETAR INDEVIDO)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o Numero do Proximo documento contabil                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While !ProxDoc(dDataLanc,cLote,cSubLote,@cDoc,@CTF_LOCK)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso o N§ do Doc estourou, incrementa o lote         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLote := Soma1(cLote)
	DbSelectArea("SX5")
	MsSeek(xFilial("SX5")+"09"+If(cModulo=="CTB","CON",cModulo))
	RecLock("SX5")
	SX5->X5_DESCRI := Substr(cLote,3,4)
	MsUnlock()
Enddo
///LockDoc(dDataLanc,cLote,cSubLote,cDoc, @CTF_LOCK ) /// FOI PARA A PROXDOC
                                        
If ValType(oLote) == "O" .And. ValType(oSubLote) == "O" .And. ValType(oDoc) == "O"
	oLote:Refresh()	;oSubLote:Refresh();oDoc:Refresh()		// Atualiza a Tela
EndIf	

CT2->(dbSetOrder(nIndCT2))		//// VOLTA A POSICAO ORIGINAL NO CT2 - INDICE
CT2->(dbGoTo(nRecCT2))			//// VOLTA A POSICAO ORIGINAL NO CT2 - REGISTRO

RestArea(aSaveArea)

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VldCaplote ³ Autor ³ Simone Mie Sato       ³ Data ³17.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Para chamar o ponto de Entrada VLCPLOTE				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³VldCapLote(dDataLanc,cLote,cSubLote,cDoc,nOpc)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA102                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento                                 ³±±
±±³          ³ ExpC1 = Numero do Lote do Lancamento                       ³±±
±±³          ³ ExpC2 = Numero do Sub-Lote do Lancamento                   ³±±
±±³          ³ ExpC3 = Numero do documento do Lancamento                  ³±±
±±³          ³ ExpN1 = Numero da opcao escolhida                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/      

Function VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc)

Local lRet := .T.                                            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PONTO DE ENTRADA VLCPLOTE                            ³
//³ Criado para poder verificar se o lancamento vindo de ³
//³ outro modulo podera ser alterado ou nao. Podera ser	 ³
//³ chamado na inclusao ou alteracao.                    ³
//³ ParamIxb:Data,Lote,Sub-Lote,Doc, nOpc.   	         ³
//³ Devera retornar .T. ou .F., pois sera utilizado na   ³
//³ validacao do botao OK.                               ³	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	
If ExistBlock("VLCPLOTE")
	lRet := ExecBlock("VLCPLOTE",.F.,.F.,{dDataLanc,cLote,cSubLote,cDoc,nOpc})
Endif		                                                     
	
Return(lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontHistInt³ Autor ³ Simone Mie Sato       ³ Data ³04.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta a tela de Historico Inteligente na Getdb.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MontHistInt(cHp)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cTexto                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Historico Padrao                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/      

Function MontHistInt(cHp)

Local aSaveArea  := GetArea()
Local cTexto	 :="" 
Local oDlg 
Local oMemo2             
Local aFormat 	 := {}


	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0027) ;  // "Historico Inteligente"
							FROM 80,1 to 250,400 PIXEL 

	oMemo2:=MsHGet():New(01,01,144,80,oDlg,aFormat) 	          
		
	While !Eof() .And. CT8->CT8_HIST == cHP .And. CT8->CT8_IDENT == 'I'
		Aadd(aFormat,CT8->CT8_DESC)
		dbSkip()
	Enddo

	oMemo2:Restart(aFormat)			                                            
	oMemo2:Show()
  
	cTexto:=oMemo2:GetText() 
	
DEFINE SBUTTON FROM 05, 150 TYPE 1 ACTION (nOpca := 1,;
					Iif(GTmpHisInt(dDataLanc,cLote,cSubLote,cDoc,cHp,cTexto,oMemo2),oDlg:End(),nOpca:=0)) ENABLE OF oDlg															
  
DEFINE SBUTTON FROM 18, 150 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOg oDlg CENTERED

RestArea(aSaveArea)	
	
Return(cTexto)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GTmpHisInt ³ Autor ³ Simone Mie Sato       ³ Data ³04.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava o historico Inteligente no arq. temp. da GETDB		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GTmpHisInt(dData,cLote,cSubLote,cDoc,cHp,cTexto,oMemo2)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA102                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento                                 ³±±
±±³          ³ ExpC1 = Numero do Lote do Lancamento                       ³±±
±±³          ³ ExpC2 = Numero do Sub-Lote do Lancamento                   ³±±
±±³          ³ ExpC3 = Numero do documento do Lancamento                  ³±±
±±³          ³ ExpC4 = Codigo do Historico Padrao                         ³±±
±±³          ³ ExpC5 = Conteudo do Historico                              ³±±
±±³          ³ ExpO1 = Objeto Memo                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GTmpHisInt(dData,cLote,cSubLote,cDoc,cHp,cTexto,oMemo2)

Local nTamHist		:= Len(CriaVar("CT2_HIST"))
Local cDescricao	:= ""
Local nPasso		:= 0
Local nContaLinhas	:= 1		// Para o loop de gravacao de lancamento - Contador de linhas
Local cSeqLan 		:= ""
Local cSeqHis		:= "001"
Local cMoeda		:= TMP->CT2_MOEDLC
Local cTpSaldo		:= TMP->CT2_TPSALD
Local cSeqLanOfi 	:= ""
Local cSeqHisOfi 	:= "" 
Local nRecAnt		:= 0
Local cProxLin		:= ""
Local nRecTmp		:= 0
Local nOrdTMP		:= 1
Local nContador	:= 0

cTexto				:= oMemo2:GetText() 
nLinTotal			:= mlCount( cTexto , nTamHist)
cLinha 				:= TMP->CT2_LINHA

For nContador := 1 To nLinTotal
	cDescricao := MemoLine(cTexto, nTamHist, nContador)
	If Empty(cDescricao)
		Loop
	EndIf
	nPasso++
Next nContador

nLinTotal 	:= nPasso				// Numero total de linhas do lancamento
nPasso		:= 0

While nContaLinhas <= nLinTotal

	cDescricao := MemoLine(cTexto, nTamHist, nPasso)
	nPasso++						//  Contador para leitura do Memoline
	If Empty(cDescricao)
		Loop
	EndIf	
	
	If nContaLinhas == 1		// Grava primeira linha de informacoes -> debito/credito etc
		dbSelectArea("TMP")                                                                		
		nRecTMP	:= Recno()
		nOrdTMP := IndexOrd()
		dbSetOrder(2)
		If TMP->CT2_DC <> "4"
			dbSkip(-1) 			//Procuro pela sequencia, para poder calcular a proxima. 
			If !Bof() .And. !Eof()   
				If TMP->CT2_DC == "4"			
					While TMP->CT2_DC == "4"
						dbSkip(-1)
					End           
					cSeqLan 			:= StrZero((Val(TMP->CT2_SEQLAN)+1),3)										
				Else
					cSeqLan 			:= StrZero((Val(TMP->CT2_SEQLAN)+1),3)			
				EndIf 
				dbGoto(nRecTMP)
			Else 
				cSeqLan 			:= '001'
			Endif		
			cSeqHis	:= "001"
		Else
			cSeqLan := TMP->CT2_SEQLAN
			cSeqHis := TMP->CT2_SEQHIS
		Endif
	
		TMP->CT2_HP			:= cHp
		TMP->CT2_HIST		:= cDescricao
		TMP->CT2_SEQLAN		:= cSeqLan
		TMP->CT2_SEQHIS		:= cSeqHis
		cSeqLanOfi			:= TMP->CT2_SEQLAN	
		cSeqHisOfi			:= TMP->CT2_SEQHIS		
		dbSetOrder(nOrdTMP)
	Else		// Continuacao de historico     	
  		dbSelectArea("TMP")     
		nRecAnt := Recno()		
 		nRecTMP := TMP->(RecCount())	//Total de Reg. gravados no Arq. Temporario 		
 		
  		dbSkip()					//Pulo p/prox. p/ verificar se eh hist.complem.			
		If  !Eof() 		         	//Se nao for fim de arquivo
			If TMP->CT2_DC == '4' .And. TMP->CT2_SEQLAN == cSeqLanOfi 
				cProxLin:= TMP->CT2_LINHA
			Else
				TMP->(dbGoTo(nRecTmp))
				cProxLin := StrZero((VAL(TMP->CT2_LINHA)+1),3)																		
				dbAppend()
				oGetDb:nCount++					
			Endif
			cSeqLan := cSeqLanOfi
		Else //	Se for fim de arquivo, volto p/ o registro anterior. 
			dbSkip(-1)
			cProxLin :=StrZero((Val(TMP->CT2_LINHA)+1),3)
			dbAppend()		
			oGetDb:nCount++				
		Endif
		
		TMP->CT2_FILIAL		:= xFilial()
		TMP->CT2_DATA		:= dData
		TMP->CT2_LOTE		:= cLote
		TMP->CT2_SBLOTE		:= cSubLote
		TMP->CT2_DOC		:= cDoc
		TMP->CT2_LINHA		:= cProxLin
		TMP->CT2_FILORI		:= cFilAnt
		TMP->CT2_EMPORI		:= Substr( cNumEmp, 1, 2 )
		TMP->CT2_HIST		:= cDescricao
		TMP->CT2_DC			:= "4"				// Continuacao de Historico
		TMP->CT2_SEQHIS		:= StrZero(VAL(cSeqHis)+1,3)
		TMP->CT2_SEQLAN		:= cSeqLan
		TMP->CT2_MOEDLC		:= cMoeda
		TMP->CT2_TPSALD		:= cTpSaldo
		TMP->CT2_ROTINA		:= "CTBA102"		// Indica qual o programa gerador
		TMP->CT2_MANUAL		:= "1"				// Lancamento manual
		TMP->CT2_AGLUT		:= "2"				// Nao aglutina
		cSeqHis				:= TMP->CT2_SEQHIS
	EndIf
	
	nContaLinhas++   
	cProxLin := StrZero(Val(cProxLin)+1,3)
EndDo                                    

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ctb050ImpT ³ Autor ³ Simone Mie Sato       ³ Data ³ 09.02.01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Mostra totalizadores                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ca050ImpT()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function ctb050ImpT()

oDig:Refresh()
oDeb:Refresh()
oCred:Refresh()

Return("")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb102TamHist³ Autor ³ Wagner Mobile Costa ³ Data ³ 30.01.02³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Altera o tamanho do aHeader para montagem do GetDb          ³±±
±±³          ³Para apresentacao correta no Grid                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb102TamHist(lRestaura)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lRestaura = Indica se volta conteudo para do aHeader       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function Ctb102TamHist(lRestaura)

Local nPosHist := Ascan(aHeader,{|x|Alltrim(x[2]) = "CT2_HIST"})

DEFAULT lRestaura := .F.

If nPosHist > 0 .And. lRestaura
	aHeader[nPosHist][4] := TamSx3("CT2_HIST")[1]
ElseIf nPosHist > 0
	aHeader[nPosHist][4] += 10
Endif

Return .T.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CtbVldLP   ³ Autor ³ Simone Mie Sato       ³ Data ³ 11.12.02³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verificar se o documento eh de apuracao de lucros/perdas    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbVldLP()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function CtbVldLP(dDataLanc,cLote,cSubLote,cDoc,nOpc)

Local aSaveArea	:= GetArea()   
Local nIndCT2	:= CT2->(IndexOrd())
Local nRecCT2	:= CT2->(Recno())
Local lRet		:= .T.
Local cMensagem	:= ""


dbSelectarea("CT2")
dbSetOrder(1)
If MsSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+cDoc)
	If (nOpc = 4 .Or. nOpc = 5) .And. !Empty(CT2->CT2_DTLP)
		cMensagem	:= STR0036 //"Nao é possivel a alteracao/exclusao de documento gerado pela apuracao de lucros/perdas.."
		cMensagem	+= STR0037 //"Favor rodar a rotina de estorno de apuracao de lucros/perdas.."		
		MsgAlert(cMensagem)
		lRet	:= .F. 
	EndIf
EndIf    

dbSelectArea("CT2")
dbSetOrder(nIndCT2)
dbGoTo(nRecCT2)
RestArea(aSaveArea)
Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb102VlRt³ Autor ³ Simone Mie Sato       ³ Data ³ 06.11.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preenche com o valor a ser rateado.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb102VlRt()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Matriz com rateios cadastrados no CT9                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Define se confirmou ou cancelou                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function Ctb102VlRt()

Local aSaveArea	:= GetArea()  
Local oDlg
Local nValRat	:= 0
Local nOpca		:= 0

nOpca := 0

DEFINE MSDIALOG oDlg FROM 5, 5 TO 10, 40 TITLE OemToAnsi(STR0013)  //"Escolha Rateio"
@  .5,2 	Say OemToAnsi(STR0014)  //"Valor a Ratear : " 
@  .5,7.5 	MSGET nValRat Pict "@E 99999,999,999.99" Valid Positivo(nValRat)	

DEFINE	SBUTTON FROM 25,40 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE 	SBUTTON FROM 25,70 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oDlg
	
ACTIVATE MSDIALOG oDlg CENTERED
      
RestArea(aSaveArea)

Return(nValRat)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb102OutM³ Autor ³ Simone Mie Sato       ³ Data ³ 01.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Mostra os totais de lote/documento de outras moedas.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb102OutM()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc)

Local aSaveArea	:= GetArea()
Local nMoedas	:= 0                   
Local nDocDeb	:= 0
Local nDocCrd	:= 0 
Local nLoteDeb	:= 0
Local nLoteCrd	:= 0
Local nTotLotDeb:= 0
Local nTotLotCrd:= 0
Local nTotDocDeb:= 0
Local nTotDocCrd:= 0
Local nRegTmp	:= TMP->(Recno())

Local cPictVal	:= ""

Local oValores
Local oDlg
Local aArea:={}
Local aDecCols :={}
Local nCont:=1
Local nDecMaior := 0
Local nTamCampo:=17
Private oDescMoeda
Private oDifLote
Private oDifDoc

aArea:= GetArea()
dbSelectArea("CTO")
dbSetOrder(1)
For nCont := 1 to __nQuantas
	If dbSeek(xFilial("CTO")+StrZero(nCont,2))
		aAdd(aDecCols,CTO->CTO_DECIM)
		If nDecMaior < CTO->CTO_DECIM		
			nDecMaior := CTO->CTO_DECIM
		EndIf	
	Else  
		aAdd(aDecCols,2)	
		If nDecMaior < 2		
			nDecMaior := 2
		EndIf	
	EndIf
Next

RestArea(aArea)

cPictVal:=CTB102Pict(nTamCampo,nDecMaior)

//Na tela de totais de lote e documento de outras moedas, desabilita a tecla F5
SET KEY VK_F5 to
SET KEY VK_F4 to

For nMoedas	:= 1 to __nQuantas            

	dbSelectarea("CTC")
	dbSetOrder(1)
	If MsSeek(xFilial("CTC")+DTOS(dDataLanc)+cLote+cSubLote+cDoc+StrZero(nMoedas,2))
		nDocDeb	:= CTC->CTC_DEBITO
		nDocCrd	:= CTC->CTC_CREDIT
	Else
		nDocDeb	:= 0
		nDocCrd	:= 0
	EndIf

	dbSelectArea("CT6")
	dbSetOrder(1)
	If MsSeek(xFilial("CT6")+DTOS(dDataLanc)+cLote+cSublote+StrZero(nMoedas,2))		
		nLoteDeb	:= CT6->CT6_DEBITO
		nLoteCrd	:= CT6->CT6_CREDIT
	Else
		nLoteDeb	:= 0
		nLoteCrd	:= 0
	EndIf
	                
	//Subtrair do total do lote o valor do documento corrente, pois esse documento sera somado 
	//a partir do TMP => GetDb.
	
	nTotLotDeb	:= nLoteDeb - nDocDeb
	nTotLotCrd	:= nLoteCrd - nDocCrd
	
	dbSelectArea("TMP")
	dbGotop()
	While !Eof()
		If !TMP->CT2_FLAG	//Se a linha nao estiver deletada
			If TMP->CT2_DC $ "1/3"                   
				If StrZero(nMoedas,2) == '01'
					nTotLotDeb	+= Round(TMP->CT2_VALOR,aDecCols[nMoedas])
					nTotDocDeb	+= Round(TMP->CT2_VALOR,aDecCols[nMoedas])
				Else
					nTotLotDeb	+= Round(&("TMP->CT2_VALR"+StrZero(nMoedas,2)),aDecCols[nMoedas])
					nTotDocDeb	+= ROund(&("TMP->CT2_VALR"+StrZero(nMoedas,2)),aDecCols[nMoedas])
				EndIf
			EndIf
	
			If TMP->CT2_DC $ "2/3"
				If StrZero(nMoedas,2) == '01'
					nTotLotCrd	+= Round(TMP->CT2_VALOR,aDecCols[nMoedas])
					nTotDocCrd	+= Round(TMP->CT2_VALOR,aDecCols[nMoedas])
				Else
					nTotLotCrd	+= Round(&("TMP->CT2_VALR"+StrZero(nMoedas,2)),aDecCols[nMoedas])
					nTotDocCrd	+= Round(&("TMP->CT2_VALR"+StrZero(nMoedas,2)),aDecCols[nMoedas])				
				EndIf					
			EndIf	
		EndIf
		dbSkip()
	End	
	
	AADD(aColsP,{StrZero(nMoedas,2),nTotDocDeb,nTotDocCrd,nTotLotDeb,nTotLotCrd})
	
	nTotDocDeb	:= 0
	nTotDocCrd	:= 0
	nTotLotDeb	:= 0
	nTotLotCrd	:= 0
	nDocDeb		:= 0
	nDocCrd		:= 0
	nLoteDeb	:= 0
	nLoteCrd	:= 0
Next       

//ListBox para mostrar os valores em outras moedas
DEFINE MSDIALOG oDlg FROM	88,31 TO 300,560 TITLE STR0041 PIXEL  //"Totais do lote e documento (outras moedas)"

@ 1.4, 028 MSGET dDataLanc	When .F. SIZE 19, 10 OF oDlg PIXEL
@ 1.4, 090 MSGET cLote    	When .F. SIZE 20, 10 OF oDlg PIXEL
@ 1.4, 150 MSGET cSubLote	When .F. SIZE 10, 10 OF oDlg PIXEL
@ 1.4, 210 MSGET cDoc     	When .F. SIZE 20, 10 OF oDlg PIXEL

@ 3.8, 010 SAY STR0008+ ": "    SIZE 21, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//"Data"
@ 3.8, 075 SAY STR0009+ ": "    SIZE 22, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//"Lote"
@ 3.8, 125 SAY STR0028+ ": "    SIZE 55, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//"SubLote
@ 3.8, 190 SAY STR0010+ ": "    SIZE 23, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//"Documento"

@ 1.3,.9 LISTBOX oValores VAR cValores Fields;
	HEADER STR0019, STR0042 + STR0016,; 	//"Moeda" "Total doc. Debito"
	STR0042 + STR0017,;				//"Total doc. Credito"
	STR0043 + STR0016,;  			//"Total Lote Debito"
	STR0043 + STR0017 ;  			//"Total Lote Debito"
	COLSIZES 20, GetTextWidth(0,"BBBBBBBB"),GetTextWidth(0,"BBBBBBBB"),;
	GetTextWidth(0,"BBBBBBBB"),GetTextWidth(0,"BBBBBBBB"),;
	SIZE 270,80 	
	oValores:SetArray(aColsP)
	oValores:bLine := { || {aColsP[oValores:nAt,1],Trans(aColsP[oValores:nAt,2],cPictVal),;
						Trans(aColsP[oValores:nAt,3],cPictVal),Trans(aColsP[oValores:nAt,4],cPictVal),Trans(aColsP[oValores:nAt,5],cPictVal)}}
@ 100, 010 SAY STR0044   SIZE 100, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//"Diferenca em "
@ 100, 070 SAY STR0045   SIZE 10, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//" do "
@ 100, 085 SAY UPPER(STR0009)   + ": "SIZE 60, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//" Lote "
@ 100, 170 SAY UPPER(STR0010)   + ": "SIZE 60, 7 OF oDlg PIXEL  COLOR CLR_HBLUE//" Docto "


Ctb102AtuM(aColsP[oValores:nAt,1],oDlg,.T.,aColsP[oValores:nAt,2],;
		aColsP[oValores:nAt,3],	aColsP[oValores:nAt,4],aColsP[oValores:nAt,5])		                                                              

oValores:bChange := {|| Ctb102AtuM(aColsP[oValores:nAt,1],oDlg,.F.,aColsP[oValores:nAt,2],;
		aColsP[oValores:nAt,3],	aColsP[oValores:nAt,4],aColsP[oValores:nAt,5])}		                                                              

ACTIVATE MSDIALOG oDlg  CENTERED


dbSelectArea("TMP")
dbGoto(nRegTmp)     

aColsP	:= {}

//SetKey( VK_F5 , { || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc) })		                               
SetKey( VK_F5 , { || CTB105Flt (oGetDb,.F.                   ) })
SetKey( VK_F4 , { || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc) })		

RestArea(aSaveArea)

Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb102AtuM³ Autor ³ Simone Mie Sato       ³ Data ³ 02.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza rodape da tela de totais de lote/doc outrs moedas  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb102AtuM()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                  
Function Ctb102AtuM(cMoeda,oDlg,lInit,nDocDeb,nDocCrd,nLoteDeb,nLoteCrd)

Local aSaveArea		:= GetArea()
Local cDescMoeda	:= ""	 
Local nDifLote		:= 0
Local nDifDoc		:= 0


dbSelectArea("CTO") 
dbSetOrder(1)
If MsSeek(xFilial()+cMoeda)
    cDescMoeda	:= CTO->CTO_DESC
EndIf                   

nDifDoc	:= ABS(nDocDeb-nDocCrd)
nDifLote:= ABS(nLoteDeb-nLoteCrd)	

If lInit
	@ 100,50  SAY oDescMoeda PROMPT cDescMoeda SIZE 100, 7 OF oDlg PIXEL  COLOR CLR_RED//"Diferenca em "
	@ 100,110 SAY oDifLote PROMPT nDifLote Picture "@E 999,999,999.99" SIZE 100, 20 OF oDlg PIXEL COLOR CLR_RED
	@ 100,200 SAY oDifDoc  VAR nDifDoc  Picture "@E 999,999,999.99" SIZE 100, 20 OF oDlg PIXEL COLOR CLR_RED	
Else
	oDescMoeda:SetText(cDescMoeda)
	oDescMoeda:Refresh()
	oDifLote:SetText(nDifLote)
	oDifLote:Refresh()
	oDifDoc:SetText(nDifDoc)
	oDifDoc:Refresh()	
EndIf                   

RestArea(aSaveArea)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb102PictM³ Autor ³ Paulo Augusto        ³ Data ³ 11.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria Picture de um campo numerico                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTB102Pict(nTamCampo,nDecMaior)                             ³±±
±±³          ³nTamCampo = Tamanho Total do Campo                          ³±±
±±³          ³nDecimais = Qtd. de casas decimais                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                    

Function CTB102Pict(nTamCampo,nDecimais)

Local nTam:= nTamCampo
Local nDec:= nDecimais
Local nTamInt:= 0
Local nValInt:= 0
Local nMascInt:= 0
Local nMascPor:=0
Local cPicture :="@E " 
Local nI :=1

nTamInt:= nTam - nDec
nValInt:= nTamInt / 3
nMascInt:= Int(nValInt)
nMascPor:=Round((nValInt - nMascInt)*3,1)

If nMascPor >0      
	cPicture :=cPicture  + Replicate("9",nMascPor)+ ","
EndIf  

For nI:=1 to nMascInt            
	cPicture :=  cPicture + "999"
	If nI <> nMascInt
    	cPicture :=  cPicture + ","
	EndIf                          
Next	
If  nDec > 0
	cPicture :=  cPicture + "." + Replicate("9",nDec)
EndIf

Return(cPicture)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtbTmpBloq  ³ Autor ³ Simone Mie Sato      ³ Data ³ 23.02.2005		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verificar o bloqueio das entidades na exclusao do documento.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbTmpBloq                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCtb 			                                        			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbTmpBloq(dDataLanc,cLote,cSubLote,cDoc,nOpc)

Local aSaveArea	:= GetArea()
Local lRet		:= .T.
Local nIndCT2	:= CT2->(IndexOrd())
Local nRecCT2	:= CT2->(Recno())

If FunName() == 'CTBA102'
	If nOpc == 5
		dbSelectarea("CT2")
		dbSetOrder(1)
		If MsSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+cDoc)
			While !Eof() .And. CT2->CT2_FILIAL == xFilial() .And. DTOS(CT2->CT2_DATA) == DTOS(dDataLanc) .And.;
				CT2->CT2_LOTE == cLote .And. CT2->CT2_SBLOTE == cSubLote .And. CT2->CT2_DOC == cDoc
					If ( CT2->CT2_DC $ "13" .And.  !Ctb102Bloq("CT1",CT2->CT2_DEBITO,dDataLanc) .Or.; 
						( !Empty(CT2->CT2_CCD) .And.  !Ctb102Bloq("CTT",CT2->CT2_CCD,dDataLanc)) .Or.;
						( !Empty(CT2->CT2_ITEMD) .And.  !Ctb102Bloq("CTD",CT2->CT2_ITEMD,dDataLanc)) .Or.;
						( !Empty(CT2->CT2_CLVLDB) .And.  !Ctb102Bloq("CTH",CT2->CT2_CLVLDB,dDataLanc))) .OR.;
					    (  CT2->CT2_DC $ "23" .And.	 !Ctb102Bloq("CT1",CT2->CT2_CREDIT,dDataLanc) .Or. ;										
						(!Empty(CT2->CT2_CCC) .And.  !Ctb102Bloq("CTT",CT2->CT2_CCC,dDataLanc)) .Or. ;	
						(!Empty(CT2->CT2_ITEMC) .And.  !Ctb102Bloq("CTD",CT2->CT2_ITEMC,dDataLanc)).Or. ;
						(!Empty(CT2->CT2_CLVLCR) .And.  !Ctb102Bloq("CTH",CT2->CT2_CLVLCR,dDataLanc))) 		
						lRet	:= .F.
						Exit
					EndIf			
				dbSelectArea("CT2")
				dbSkip()
			End
		EndIf    
	EndIf
EndIf

dbSelectArea("CT2")
dbSetOrder(nIndCT2)
dbGoTo(nRecCT2)

RestArea(aSaveArea)
Return(lRet)	


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb102Bloq  ³ Autor ³ Simone Mie Sato      ³ Data ³ 22.02.2005		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verificar o bloqueio das entidades.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb102Bloq(cAlias,cCodigo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCtb => X3_WHEN=> CTBA102/CTBA105                      			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias 	   = Entidade a ser verificada.                			   	³±±
±±³          ³ cCodigo     = Codigo da entidade a ser verificada.            	    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb102Bloq(cAlias,cCodigo)

Local aSaveArea	:= GetArea()
Local lRet		:= .T.

If FunName() == 'CTBA102'                    
	//Se ira verificar somente uma determinada entidade. Campos: Conta, Centro de Custo, Item ou Classe de Valor
	If !Empty(cAlias)	
		If !ValidaBloq(cCodigo,dDataLanc,cAlias,.T.)
			lRet	:= .F.
		EndIf
	Else	//Campos: Valor, Tipo de Saldo, Criterio de Conversao, Tipo de lancamento, Moedas.	
		If ( TMP->CT2_DC $"13" .And.( !ValidaBloq(TMP->CT2_DEBITO,dDataLanc,"CT1",.T.)  .Or. ;
			( !Empty(TMP->CT2_CCD) .And.  !ValidaBloq(TMP->CT2_CCD,dDataLanc,"CTT",.T.)) .Or. ;
			( !Empty(TMP->CT2_ITEMD) .And.  !ValidaBloq(TMP->CT2_ITEMD,dDataLanc,"CTD",.T.)) .Or.;
			( !Empty(TMP->CT2_CLVLDB) .And.  !ValidaBloq(TMP->CT2_CLVLDB,dDataLanc,"CTH",.T.)))) .OR.;
			( TMP->CT2_DC $ "23" .And.(!ValidaBloq(TMP->CT2_CREDIT,dDataLanc,"CT1",.T.)	.Or. ;	
			(!Empty(TMP->CT2_CCC) .And.  !ValidaBloq(TMP->CT2_CCC,dDataLanc,"CTT",.T.)) .Or. ;			
			(!Empty(TMP->CT2_ITEMC) .And.  !ValidaBloq(TMP->CT2_ITEMC,dDataLanc,"CTD",.T.)) .Or. ;
			(!Empty(TMP->CT2_CLVLCR) .And.  !ValidaBloq(TMP->CT2_CLVLCR,dDataLanc,"CTH",.T.))))
				lRet	:= .F.       
		EndIf
	EndIf
EndIf

RestArea(aSaveArea)

Return(lRet)
