#INCLUDE "CTBA190.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE MAXPASSO 12
#DEFINE D_PRELAN		"9"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA190   ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 19.01.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reprocessamento SIGACTB                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTBA190(lDireto,dDataIni,dDataFim,cFilDe,cFilAte,cTpSald,lMoedaEsp,cMoeda)

Local aSays		:={}
Local aButtons	:={}
Local cFilBack	:= cFilAnt
Local nOpca 	:= 0
Local nReg
Local oProcess


Private cCadastro := STR0001  //"Reprocessamento"
Private aResult  := {} 
Private lCusto		:= CtbMovSaldo("CTT")
Private lItem		:= CtbMovSaldo("CTD")
Private lCLVL		:= CtbMovSaldo("CTH")
Private cMoedaEsp
Private cOperacao

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

If IsBlind() 
	BatchProcess( 	cCadastro, 	STR0002 + Chr(13) + Chr(10) +;
								STR0003 + Chr(13) + Chr(10) +;
								STR0004 + Chr(13) + Chr(10) +;
								STR0005, "CTB190",;
					{ || Ctb190Proc(,mv_par02, mv_par03,;
					mv_par04, mv_par05, mv_par06, .F., mv_par07 == 1, cFilAnt) },;
					{ || .F. }) 
	Return .T.
Endif

If !lDireto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01 // Reprocessa a partir? Da Data / Ultimo Fechamento?³
	//³ mv_par02 // Data Inicial                                     ³
	//³ mv_par03 // Data Final                                       ³
	//³ mv_par04 // Filial De?                                       ³
	//³ mv_par05 // Filial Ate?                                      ³
	//³ mv_par06 // Tipo de Saldo? Via F3 - SLD                      ³
	//³ mv_par07 // Moedas? Todas / Especifica                       ³
	//³ mv_par08 // Qual Moeda?                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("CTB190",.F.)

	AADD(aSays,STR0002 )	// "Este programa tem como objetivo recalcular os saldos de um determinado periodo."
	AADD(aSays,STR0003 )	// "Devera ser utilizado caso haja necessidade de se recalcular os saldos das entidades contabeis.
	AADD(aSays,STR0004 )	// "O Reprocessamento podera ser efetuado a partir da data do ultimo fechamento contabil ou a partir
	AADD(aSays,STR0005 )	// "de uma data informada.
	
	AADD(aButtons, { 5,.T.,{|| Pergunte("CTB190",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CTBOk(), FechaBatch(), nOpca:=0 ) }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons,, 220, 560 )
	
	If mv_par01 == 2
		MsgYesNo("Reprocessa a partir do último fechamento -> Opção Não disponível temporariamente!",;
		"ATENÇÃO")
		Return
	EndIf
	
	If Empty(mv_par02) .Or. Empty(mv_par03)
		Help(" ",1,"CTB190DATA")
		Return
	EndIf     
	
	If nOpca == 1 .and. !VlDtCal(mv_par02,mv_par03,mv_par07,mv_par08)		/// VALIDA O STATUS DO(S) CALENDÁRIOS PARA O PROCESSAMENTO
		Return
	Endif

	dDataIni	:= mv_par02
	dDataFim	:= mv_par03
	cFilde		:= mv_par04
	cFilAte		:= mv_par05
	cTpSald		:= mv_par06
	lMoedaEsp	:= Iif(mv_par07 == 1, .F., .T.)
	cMoeda		:= mv_par08
Else
	nOpca := 1	
EndIf	
If nOpca == 1                        
	
	//// FUNÇÃO PARA ATUALIZAR O CONTROLE DE LOCK DA ATUALIZAÇÃO DE SALDOS
	If !CT190ATUMV(dDataFim)
		If !lDireto
			//// SE NÃO CONSEGUIR O LOCK DO PARÂMETRO AVISA EM TELA E ABORTA.
			MsgInfo(STR0013,STR0014)
		Endif
		Return
	Endif
	
	If Empty(cTpSald)		// Caso nao informar o tipo de saldo
		Help(" ",1,"CT2_TPSALD")
		Return
	EndIf

	dbSelectArea("SM0")
	nReg := Recno()
	
	#IFNDEF TOP
		If cTpSald $ "0,*"	// Reprocessamento de Saldos Orcamentos - Rotina Especifica
			// Se o arquivo e' compartilhado, so devera ser lido apenas uma vez!!
			oProcess := MsNewProcess():New({|lEnd|Ctb390Rep(oProcess,cFilDe,cFilAte,dDataIni,dDataFim)},"","",.F.)
			oProcess:Activate()		
			DbSelectArea("CT2")
		Endif
		
		If cTpSald <> "0"
			SM0->(MsSeek(cEmpAnt+cFilDe,.T.))
			While !SM0->(Eof()) .and. SM0->M0_CODFIL <= cFilAte .and. SM0->M0_CODIGO == cEmpAnt
				cFilAnt := SM0->M0_CODFIL
				oProcess := MsNewProcess():New({|lEnd| Ctb190Proc(oProcess,dDataIni,;
				dDataFim,cFilAnt, cFilAnt,cTpSald,lMoedaEsp,cMoeda,cFilAnt)},"","",.F.)
				oProcess:Activate()		
				
				If Empty(xFilial("CT2"))//Se o arquivo e' compartilhado, so devera ser lido apenas uma vez!!
					Exit
				Endif
				
				dbSelectArea("SM0")
				dbSkip()
			Enddo
		Endif
	#ELSE                                 
		If TcSrvType() != "AS/400"
			If cTpSald $ "0,*"	// Reprocessamento de Saldos Orcamentos - Rotina Especifica
				If ExistProc('CTB001')
					lCusto		:= CtbMovSaldo("CTT")
					lItem		:= CtbMovSaldo("CTD")
					lCLVL		:= CtbMovSaldo("CTH")				
					If lMoedaEsp
						cMoedaEsp := '1'
						cMoeda := cMoeda
					Else
						cMoedaEsp := '0'
						cMoeda := '00'
					EndIf
					cOperacao := '1'
				MsgRun( STR0007+STR0008 , STR0001 , {|| aResult := TCSPEXEC( xProcedures('CTB001'),;
									Iif(lCusto,'1','0'), Iif(lItem,'1','0'),;
									Iif(lClVl,'1','0'),  cFilDe, cFilAte,;
									Dtos(dDataIni),;
									Dtos(dDataFim),      cMoedaEsp,;
								cMoeda,              cOperacao) } )
					if Empty(aResult) .or. aResult[1] = "0"
				      MsgAlert(STR0025)   //'Erro na chamada do processo - Reproc Contabil'
			    	Endif
				Else
					oProcess := MsNewProcess():New({|lEnd|Ctb390Rep(oProcess,cFilDe,cFilAte,dDataIni,dDataFim)},"","",.F.)
					oProcess:Activate()
				End
			Endif

			If cTpSald <> "0"
				If ExistProc('CTB020')
					lCusto		:= CtbMovSaldo("CTT")
					lItem		:= CtbMovSaldo("CTD")
					lCLVL		:= CtbMovSaldo("CTH")				
					SM0->(MsSeek(cEmpAnt+cFilDe,.T.))
					If SM0->M0_CODFIL <= cFilAte .and. SM0->M0_CODIGO == cEmpAnt
						lReproc := '1'
						If lMoedaEsp
							cMoedaEsp := '1'
							cMoeda := cMoeda
						Else
							cMoedaEsp := '0'
							cMoeda := '00'
						EndIf
					MsgRun( STR0007+STR0008 , STR0001 , {|| aResult := TCSPEXEC( xProcedures("CTB020"),;
										Iif(lCusto,'1','0'),;
										Iif(lItem,'1','0'), Iif(lClVl,'1','0'),;
										cFilDe,              cFilAte,;
										Dtos(dDataIni),      Dtos(dDataFim),;
										cMoedaEsp,           cMoeda,;
										cTpSald,             StrZero(Getmv("MV_SOMA"),1),;
									lReproc) } )
						if Empty(aResult) .or. aResult[1] = "0"
					      MsgAlert(STR0025)   //'Erro na chamada do processo - Reproc Contabil'
		     			Endif
		     		Endif
				Else
					SM0->(MsSeek(cEmpAnt+cFilDe,.T.))
					While !SM0->(Eof()) .and. SM0->M0_CODFIL <= cFilAte .and. SM0->M0_CODIGO == cEmpAnt
						cFilAnt := SM0->M0_CODFIL
						oProcess := MsNewProcess():New({|lEnd| Ctb190Proc(oProcess,dDataIni,;
						dDataFim,cFilAnt, cFilAnt,cTpSald,lMoedaEsp,cMoeda,cFilAnt)},"","",.F.)
						oProcess:Activate()
						If Empty(xFilial("CT2"))//Se o arquivo e' compartilhado, so devera ser lido apenas uma vez!!
							Exit
						Endif
	
		   			dbSelectArea("SM0")
						dbSkip()
					Enddo
				Endif
			Endif                  
		Else
			If cTpSald $ "0,*"	// Reprocessamento de Saldos Orcamentos - Rotina Especifica
				oProcess := MsNewProcess():New({|lEnd|Ctb390Rep(oProcess,cFilDe,cFilAte,dDataIni,dDataFim)},"","",.F.)
				oProcess:Activate()		
				// Se o arquivo e' compartilhado, so devera ser lido apenas uma vez!!
			Endif
			
			If cTpSald <> "0"
				SM0->(MsSeek(cEmpAnt+cFilDe,.T.))
				While !Eof() .and. M0_CODFIL <= cFilAte .and. M0_CODIGO == cEmpAnt
					cFilAnt := SM0->M0_CODFIL

					oProcess := MsNewProcess():New({|lEnd| Ctb190Proc(oProcess,dDataIni,;
					dDataFim,cFilAnt, cFilAnt,cTpSald,lMoedaEsp,cMoeda,cFilAnt)},"","",.F.)
					oProcess:Activate()		
					
					// Se o arquivo e' compartilhado, so devera ser lido apenas uma vez!!
					If Empty(xFilial("CT2"))
						Exit
					Endif

					dbSelectArea("SM0")
					dbSkip()
				Enddo
			Endif
		EndIf	
	#ENDIF

	dbSelectArea("SM0")
	dbGoto(nReg)
	dbSelectArea("CT1")
	cFilAnt := cFilBack
	
	CT190LIBMV()
Endif
	
dbSelectArea("CT2")	
Return
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb190Proc³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 19.01.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reprocessamento - recalcula os saldos das Entidades Conta- ³±±
±±³          ³ beis de acordo com os lancamentos contabeis                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb190Proc(oObj)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1 = Objeto p/ regua de Processamento                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb190Proc(oObj,dDataIni,dDataFim,cFilDe,cFilAte,cTpSald,lMoedaEsp,cMoeda,cFilX)

Local lFim := .F.

While !lFim			
	lFim := xCtb190Proc(oObj,dDataIni,dDataFim,cFilDe,cFilAte,cTpSald,lMoedaEsp,cMoeda,cFilX)
	IF !lFim .and. !IsBlind()
		lFim := !MsgYesNo("Atenção!Os lançamentos foram modificados durante o reprocossamento. Deseja reprocessar novamente ?")
		If lFim .And. Type('TITULO') # "U" .and. Titulo <> Nil
			If !("Rascunho"$Titulo)
				Titulo := alltrim(TITULO)+" - Rascunho"
			EndIf
		EndIf		   
	Endif
End  
Return Nil

Static Function xCtb190Proc(oObj,dDataIni,dDataFim,cFilDe,cFilAte,cTpSald,lMoedaEsp,cMoeda,cFilX)
	
Local aCtbMoeda := {}
Local nInicio
Local nFinal
Local lCusto
Local lItem
Local lCLVL
Local nx := 0
Local lRet := .t.
Local lAtSldBase	:= Iif(SuperGetMV("MV_ATUSAL")== "S",.T.,.F.) 

#IFDEF TOP
	Local nMin			:= 0
	Local nMax			:= 0
#ENDIF	

lCusto		:= CtbMovSaldo("CTT")
lItem		:= CtbMovSaldo("CTD")
lCLVL		:= CtbMovSaldo("CTH")
	
If lMoedaEsp					// Moeda especifica
	aCtbMoeda := CtbMoeda(cMoeda)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		Return
	EndIf                  
	nInicio := val(cMoeda)
	nFinal	:= val(cMoeda)
Else
	nInicio	:= 1
	nFinal	:= __nQuantas
EndIf

If !lAtSldBase
	For nx := nInicio to nFinal
		If GetCV7Date(cTpSald,StrZero(nx,2,0)) < dDataIni 
			dDataIni := GetCV7Date(cTpSald,StrZero(nx,2,0))+1
		EndIf
		PutCV7Date(cTpSald,StrZero(nx,2,0),dDataFim)
	Next nx
EndIf	

// Zera Saldos das Conta Contabeis
If Empty(xFilial("CT7"))		// Tratamento para filiais compartilhadas
	cFilDe	:= "  "
	cFilAte	:= "  "         
Else
	cFilDe	:= xFilial("CT7")
	cFilAte	:= xFilial("CT7")	
Endif                  
CtbZeraTod("CT7",lMoedaEsp,cMoeda,cTpSald,cFilDe,cFilAte,dDataIni,dDataFim,4,.f.,,oObj)
	
// Zera Saldos de Centro de Custo
If lCusto
	If Empty(xFilial("CT3"))		// Tratamento para filiais compartilhadas
		cFilDe	:= "  "
		cFilAte	:= "  "
	Else
		cFilDe	:= xFilial("CT3")
		cFilAte	:= xFilial("CT3")			
	Endif                  
	CtbZeraTod("CT3",lMoedaEsp,cMOeda,cTpSald,cFilDe,cFilAte,dDataIni,dDataFim,3,.f.,,oObj)
EndIf
	
// Zera Saldos de Item Contabil
If lItem
	If Empty(xFilial("CT4"))		// Tratamento para filiais compartilhadas
		cFilDe	:= "  "
		cFilAte	:= "  "          
	Else
		cFilDe	:= xFilial("CT4")
		cFilAte	:= xFilial("CT4")			
	Endif                  
	CtbZeraTod("CT4",lMoedaEsp,cMoeda,cTpSald,cFilDe,cFilAte,dDataIni,dDataFim,3,.f.,,oObj)
EndIf
	
// Zera Saldos de Classe de Valor
If lCLVL
	If Empty(xFilial("CTI"))		// Tratamento para filiais compartilhadas
		cFilDe	:= "  "
		cFilAte	:= "  "
	Else
		cFilDe	:= xFilial("CTI")
		cFilAte	:= xFilial("CTI")			
	Endif                  
	CtbZeraTod("CTI",lMoedaEsp,cMoeda,cTpSald,cFilDe,cFilAte,dDataIni,dDataFim,3,.f.,,oObj)
EndIf
	
// Zera Saldos dos Documentos
If Empty(xFilial("CTC"))		// Tratamento para filiais compartilhadas
	cFilDe	:= "  "
	cFilAte	:= "  "
Else
	cFilDe	:= xFilial("CTC")
	cFilAte	:= xFilial("CTC")	
Endif                  
CtbZeraTod("CTC",lMoedaEsp,cMoeda,cTpSald,cFilDe,cFilAte,dDataIni,dDataFim,1,.T.,.T.,oObj)

// Zera Saldos do Lote
If Empty(xFilial("CT6"))		// Tratamento para filiais compartilhadas
	cFilDe	:= "  "
	cFilAte	:= "  "  
Else
	cFilDe	:= xFilial("CT6")
	cFilAte	:= xFilial("CT6")		
Endif                  
CtbZeraTod("CT6",lMoedaEsp,cMoeda,cTpsald,cFilDe,cFilAte,dDataIni,dDataFim,1,.T.,.T.,oObj)

If Empty(xFilial("CT2"))		// Tratamento para filiais compartilhadas
	cFilDe	:= "  "
	cFilAte	:= "  "
Else
	cFilDe	:= xFilial("CT2")
	cFilAte	:= xFilial("CT2")		
Endif                  

#IFDEF TOP	                     
	If TcSrvType() != "AS/400"	                                                        
		//Rotina que chama a atualizacao de Saldos Basicos
		Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSald,lMoedaEsp,cFilDe,cFilAte,dDataIni,dDataFim,.F.,oObj,nMin,nMax)
		
		//Reprocessa totais por lote  => atualiza CT6
		Ctb190Lote(nInicio,nFinal,cFilDe,cFilAte,cTpSald,dDataIni,dDataFim,oObj)

		//Reprocessa totais por documento => atualiza CTC
		Ctb190Doc(nInicio,nFinal,cFilDe,cFilAte,cTpSald,dDataIni,dDataFim,oObj)
		
		//Atualiza os flags de conta ponte.
		CtbFlgPon(nInicio,nFinal,cFilDe,cFilAte,cTpSald,dDataIni,dDataFim,oObj)
		//Rotina que chama a atualizacao de Saldos Compostos
		Ct360SlCmp(nInicio,nFinal,lClvl,lItem,lCusto,cTpSald,lMoedaEsp,cFilDe,cFilAte,oObj,,cFilX,dDataIni)	
		
	Else
#ENDIF
	Ct190RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSald,dDataIni,dDataFim,oObj)	
	
	//Rotina que chama a atualizacao de Saldos Compostos	
	Ct360SlCmp(nInicio,nFinal,lClvl,lItem,lCusto,cTpSald,lMoedaEsp,cFilDe,cFilAte,oObj,,cFilX,dDataIni)	
	
#IFDEF TOP
	EndIf
#ENDIF

If !lAtSldBase
   lRet := .T.
	For nx := nInicio to nFinal
		If GetCV7Date(cTpSald,StrZero(nx,2,0)) < dDataFim
			lRet := .f.
		EndIf
	Next nx
EndIf	
	
Return lRet
	
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CtbZeraTod³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 19.01.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Zera os arquivos a serem posteriormente reprocessados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbZeraTod()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1= Alias do Arquivo                                    ³±±
±±³          ³ ExpL1= Define se eh moeda especifica                       ³±±
±±³          ³ ExpC2= Moeda                                               ³±±
±±³          ³ ExpC3= Tipo de Saldo                                       ³±±
±±³          ³ ExpC4= Filial De                                           ³±±
±±³          ³ ExpC5= Filial Ate			                              ³±±
±±³          ³ ExpN1= Ordem do Arquivo                                    ³±±
±±³          ³ ExpL2= Define se grava todos os campos                     ³±±
±±³          ³ ExpL3= Define se eh arquivo de lotes                       ³±±
±±³          ³ ExpO1= Objeto utilizado no Processamento                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbZeraTod(cAlias,lMoedaEsp,cMoeda,cTpSald,cFilDe,cFilAte,dDataIni,dDataFim,nOrder,lSoAlguns,lLote,oObj)
	
Local aSaveArea := GetArea()

#IFDEF TOP
	Local cCond		:= ""	
	Local cQuery	:= ""	
	Local cZeraTudo	:= ""	
	Local nDel		:= iif( TCGetDB() == "INFORMIX", 1024, 4096 )
#ENDIF	
	
lLote := Iif(lLote == Nil,.F.,lLote)

If ValType(oObj) == "O"
	oObj:SetRegua1(MAXPASSO)	
EndIf                      

#IFDEF TOP	
	If TcSrvType() != "AS/400"
		cInicial := cAlias + "_"
	
		If lMoedaEsp //Se for Moeda Especifica
			cCond := " AND ARQ."+cInicial+ "MOEDA ='" + cMoeda+"'" 
		Else
			cCond := ""
		Endif
		
		cZeraTudo := "cZeraTudo"
	
		cQuery := "SELECT R_E_C_N_O_ RECNO "
		cQuery += "FROM "+RetSqlName(cAlias)+ " ARQ "
		cQuery += "WHERE " 
		
		If cFilDe == cFilAte
			cQuery += "ARQ."+cInicial+ "FILIAL = '"+cFilDe+"' AND "		
		Else
			cQuery += "ARQ."+cInicial+ "FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
		EndIf

		If dDataIni == dDataFim
			cQuery += "ARQ."+cInicial+"DATA = '"+DTOS(dDataIni)+"' AND "		
		Else
			cQuery += "ARQ."+cInicial+"DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
		EndIf
		
		cQuery += "ARQ."+cInicial+"TPSALD='"+cTpSald+"'"
		cQuery += cCond
		cQuery += " ORDER BY RECNO"
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cZeraTudo" ) <> 0 )
			dbSelectArea ( "cZeraTudo" )
			dbCloseArea ()
		Endif
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cZeraTudo,.T.,.F.)
	
		dbSelectArea(cAlias)
			
		If lMoedaEsp //Se for Moeda Especifica
			cCond := " AND "+cInicial+ "MOEDA ='" + cMoeda +"' "
		Else
			cCond := ""
		Endif		
		If lSoAlguns		// Grava campos especificos
			cQuery := "UPDATE "
			cQuery += RetSqlName(cAlias)+" "	
			cQuery += "SET "+ cAlias + "_DEBITO =  0 ,"
			cQuery += cAlias + "_CREDIT = 0 "
			If lLote
				cQuery += ", " + cAlias + "_DIG = 0 "
				If cInicial = "CT6_"
					cQuery += ", " + cAlias + "_INF = 0 "
				Endif
			EndIf			
		Else
			cQuery := "DELETE FROM "
			cQuery += RetSqlName(cAlias) + " "
		Endif
		
		cQuery += "WHERE " 
		If cFilDe == cFilAte
			cQuery += cInicial+ "FILIAL = '"+cFilDe+"' AND "		
		Else
			cQuery += cInicial+ "FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
		EndIf
		
		If dDataIni == dDataFim
			cQuery += cInicial+"DATA = '"+DTOS(dDataIni)+"' "
		Else
			cQuery += cInicial+"DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
		EndIf
		
		If ! lSoAlguns		// Grava campos especificos
			cQuery += "AND "+cInicial+"TPSALD='"+cTpSald+"' "
		Endif
		cQuery += cCond
		
		While cZeraTudo->(!EOF())
	
			nMin := (cZeraTudo)->RECNO
			
			cZeraTudo->(DbSkip(nDel))

			If cZeraTudo->(Eof())
				cChave := ""
			Else
				nMax := (cZeraTudo)->RECNO
				cChave := "AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
			EndIf
			
			if TcSqlExec( cQuery + cChave ) <> 0
				UserException( STR0022 + RetSqlName(cAlias) ;
								+ CRLF + STR0023 + CRLF + TCSqlError() )
			endif  
			If ValType(oObj) == "O"
				oObj:IncRegua1(STR0012+ " - " + cAlias )//Zerando arquivos de Saldos... 
			EndIf
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³A tabela eh fechada para restaurar o buffer da aplicacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAlias)
		dbCloseArea()
		ChkFile(cAlias)		// Abrir como compartilhado para permitir acesso de outros usuarios
		
		If ( Select ( "cZeraTudo" ) <> 0 )
			dbSelectArea ( "cZeraTudo" )
			dbCloseArea ()
		Endif
	Else
#ENDIF 
	//Se for CodeBase ou AS/400
	cInicial := cAlias + "->" + cAlias + "_"
	
	dbSelectArea(cAlias)
	dbSetOrder(nOrder)
	DbSeek(xFilial()+Dtos(dDataIni),.T.)
	While !Eof() .And. &(cInicial+"FILIAL") == xFilial() .And. ;
		&(cInicial+"DATA") <= dDataFim
		
		If lMoedaEsp						// Moeda Especifica
			If &(cInicial+"MOEDA") != cMoeda
				dbSkip()
				Loop
			EndIf
		EndIf
		If cTpSald <> D_PRELAN				// Tipo do Saldo
			If &(cInicial+"TPSALD") != cTpSald
				dbSkip()
				Loop
			EndIf
		EndIf
		
		RecLock(cAlias)
		If !lSoAlguns				// Grava todos os campos
			DbDelete()
		Else
			If !lSoAlguns				// Grava todos os campos
				&(cInicial+"ANTDEB")	:= 0
				&(cInicial+"ANTCRD")	:= 0
				&(cInicial+"ATUDEB")	:= 0
				&(cInicial+"ATUCRD")	:= 0
			EndIf
			&(cInicial+"DEBITO")	:= 0
			&(cInicial+"CREDIT")	:= 0
			If lLote
				&(cInicial+"DIG")	:= 0
				If cInicial = "CT6_"
					CT6_INF	:= 0
				Endif
			EndIf
		Endif
			
		MsUnlock()
		dbSkip()
		If ValType(oObj) == "O"
			oObj:IncRegua1(STR0012+ " - " + cAlias )//Zerando arquivos de Saldos... 
		EndIf
	EndDo
	
#IFDEF TOP
	Endif
#ENDIF  

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190CrTrb³ Autor ³ Simone Mie Sato       ³ Data ³ 17.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria Arquivo de Trabalho para Gravar os movimentos.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb190CrTrb(nInicio,nFinal)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190CrTrb(nInicio,nFinal)
	
Local aCampos		:=  {}
Local cNomeArq		:= ""
Local aTamValor		:= ""	

Local cChave		:= ""
Local cArqInd		:= ""

aTamValor := TamSX3("CT7_DEBITO")
	
aCampos := {{"FILIAL","C",Len(CriaVar("CTI_FILIAL")),0},;
			{"DDATA","D",8,0},;
			{"CONTA","C",Len(CriaVar("CT7_CONTA")),0},;
			{"CUSTO","C",Len(CriaVar("CT3_CUSTO")),0},;
			{"ITEM","C",Len(CriaVar("CT4_ITEM")),0},;
			{"CLVL","C",Len(CriaVar("CTI_CLVL")),0},;             
			{"MOEDA","C",Len(CriaVar("CT2_MOEDLC")),0},;				
			{"DEBITO","N",aTamValor[1],aTamValor[2]},;				
			{"CREDITO","N",aTamValor[1],aTamValor[2]},;				
			{"DTLP","D",8},;                         				
			{"IDENT","C",3,0}}
	
If ( Select ( "TMP" ) <> 0 )
   dbSelectArea ( "TMP" )
   dbCloseArea ()
End
	
cNomeArq:=CriaTrab(aCampos)
dbUseArea( .T.,, cNomeArq, "TMP", NIL, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqInd	:= CriaTrab(Nil, .F.)
cChave   := "FILIAL+IDENT+CONTA+CUSTO+ITEM+CLVL+MOEDA+DTOS(DDATA)+DTOS(DTLP)"     
IndRegua("TMP",cArqInd,cChave,,,STR0007)  //"Selecionando Registros..."
	
dbSelectArea("TMP")
dbSetIndex(cArqInd+OrdBagExt())
dbSetOrder(1)
	
Return cNomeArq
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190GrTrb³ Autor ³ Simone Mie Sato       ³ Data ³ 17.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava Arquivo de Trabalho para Gravar os movimentos.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct190GrTrb(cAlias,nInicio,nFinal)		             		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias                                              ³±±
±±³          ³ ExpN1 = Moeda Inicial                                      ³±±
±±³          ³ ExpN2 = Moeda Final                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190GrTrb(cAlias,nInicio,nFinal,cSpacCC,cSpacIT,cSpacCL)
	
Local cChave	:= ""
Local aSaveArea := GetArea()
DEFAULT cSpacCC := Space(Len(CUSTO))
DEFAULT cSpacIT := Space(Len(ITEM))
DEFAULT cSpacCL := Space(Len(CLVL))
If cAlias == 'CTI'
	cChave	:= cAtualiza->(FILIAL+cAlias+CONTA+CUSTO+ITEM+CLVL+MOEDA+DTOS(cAtualiza->CT2_DATA)+DTOS(CT2_DTLP))	
ElseIf cAlias == 'CT4'
	cChave	:= cAtualiza->(FILIAL+cAlias+CONTA+CUSTO+ITEM+cSpacCL+MOEDA+DTOS(CT2_DATA)+DTOS(CT2_DTLP))
ElseIf cAlias == 'CT3'
	cChave	:= cAtualiza->(FILIAL+cAlias+CONTA+CUSTO+cSpacIT+cSpacCL+MOEDA+DTOS(CT2_DATA)+DTOS(CT2_DTLP))
ElseIf cAlias == 'CT7'
	cChave	:= cAtualiza->(FILIAL+cAlias+CONTA+cSpacCC+cSpacIT+cSpacCL+MOEDA+DTOS(CT2_DATA)+DTOS(CT2_DTLP))
Endif   

dbSelectArea("TMP")   
If cChave <> TMP->(FILIAL+IDENT+CONTA+CUSTO+ITEM+CLVL+MOEDA+DTOS(DDATA)+DTOS(DTLP))
	/// SE O RESULTADO DA QUERY (CT2) REFERE-SE A OUTRO GRUPO DE ENTIDADES
	dbSetOrder(1)
	If !dbSeek(cChave,.F.)
		Reclock("TMP",.T.)
		TMP->FILIAL			:= 	cAtualiza->FILIAL
		TMP->DDATA			:= 	cAtualiza->CT2_DATA
		If cAlias == 'CTI'
			TMP->CLVL	:= cAtualiza->CLVL
		EndIf
		If cAlias =='CT4' .Or. cAlias == 'CTI'
			TMP->ITEM	:= 	cAtualiza->ITEM
		EndIf
		If cAlias == 'CT3' .Or. cAlias == 'CT4' .Or. cAlias == 'CTI'
			TMP->CUSTO 	:= 	cAtualiza->CUSTO
		Endif
		TMP->CONTA		:= 	cAtualiza->CONTA
		TMP->DTLP		:=	cAtualiza->CT2_DTLP 
		TMP->IDENT		:= 	cAlias
		TMP->MOEDA		:=  cAtualiza->MOEDA	
	Else
		Reclock("TMP",.F.)	
	Endif
Else	/// SE O RESULTADO DA QUERY (CT2) REFERE-SE AO MESMO GRUPO DE ENTIDADES (APENAS D/C DIFERENTE)
	Reclock("TMP",.F.)	
EndIf

If cAtualiza->TIPO  == '1'	//Se for debito
	TMP->DEBITO		+= cAtualiza->VALOR
ElseIf cAtualiza->TIPO  == '2'//Se for credito
	TMP->CREDITO  	+= cAtualiza->VALOR
Endif
MsUnlock()	                             
RestArea(aSaveArea)
	
Return
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190GrSld³ Autor ³ Simone Mie Sato       ³ Data ³ 18.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Varre o arquivo temporario para gravar os saldos.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct190GrSld(nInicio,nFinal,cTpSald,lMoedaEsp,cFilDe,cFilAte, ³±±
±±³          ³oObj)                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial  								 	  ³±±
±±³          ³ExpN2 = Moeda Final	  									  ³±±
±±³          ³ExpC1 = Tipo de Saldo                               		  ³±±
±±³          ³ExpL1 = Define se eh moeda especifica.             		  ³±±
±±³          ³ExpC2 = Filial De                                  	 	  ³±±
±±³          ³ExpC3 = Filial Ate                                 		  ³±±
±±³          ³ExpO1 = Objeto utilizado na Regua de Processamento.		  ³±±
±±³          ³ExpL2 = Define se ira considerar os flags de saldos		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190GrSld(nInicio,nFinal,cTpSald,lMoedaEsp,cFilDe,cFilAte,oObj,lFlag)					

Local cChaveAnt	:= ""
Local aSldAnt		:= {}
Local nAntDeb		:= 0
Local nAntCrd		:= 0
Local cChave			:= ""
Local lObj			:= oObj <> Nil

If lObj
	oObj:SetRegua2(TMP->(LastRec()))
Endif	

aSldAnt := {{0,0}}

//Percorre arquivo temporario para gravar os saldos 
dbSelectArea("TMP")
dbSetOrder(1)
dbGotop()
		            
//cChaveAnt :=TMP->(FILIAL+IDENT+CONTA+CUSTO+ITEM+CLVL) //+DTOS(DDATA))
 		
While !Eof()    
	If cChaveAnt	<> TMP->(FILIAL+IDENT+CONTA+CUSTO+ITEM+CLVL+MOEDA) //+DTOS(DDATA))
		If TMP->IDENT == 'CT7'
			aSldAnt := SldAntCT7(TMP->CONTA,TMP->DDATA,TMP->MOEDA,cTpSald,TMP->FILIAL)
	   ElseIf TMP->IDENT == 'CT3'
			aSldAnt := SldAntCT3(TMP->CONTA,TMP->CUSTO,TMP->DDATA,TMP->MOEDA,cTpsald,TMP->FILIAL)	   
	   ElseIf TMP->IDENT == 'CT4'
			aSldAnt := SldAntCT4(TMP->CONTA,TMP->CUSTO,TMP->ITEM,TMP->DDATA,TMP->MOEDA,cTpSald,TMP->FILIAL)
		ElseIf TMP->IDENT == 'CTI'                                          
			aSldAnt := SldAntCTI(TMP->CONTA,TMP->CUSTO,TMP->ITEM,TMP->CLVL,TMP->DDATA,TMP->MOEDA,cTpSald,TMP->FILIAL)
		Endif  
	Endif		                           
		     
	nAntDeb := aSldAnt[1]
	nAntCrd := aSldAnt[2]
	If lFlag	//Se nao for chamado pelo Reprocessamento
		Do Case
		Case TMP->IDENT == 'CT7'
			cChave	:= (TMP->FILIAL+TMP->MOEDA+cTpSald+TMP->CONTA+DTOS(TMP->DDATA))
		Case TMP->IDENT == 'CT3'
			cChave	:= (TMP->FILIAL+TMP->MOEDA+cTpSald+TMP->CONTA+TMP->CUSTO+DTOS(TMP->DDATA))				
		Case TMP->IDENT == 'CT4'
			cChave	:= (TMP->FILIAL+TMP->MOEDA+cTpSald+TMP->CONTA+TMP->CUSTO+TMP->ITEM+DTOS(TMP->DDATA))			 
		Case TMP->IDENT == 'CTI'                                                             
			cChave	:= (TMP->FILIAL+TMP->MOEDA+cTpSald+TMP->CONTA+TMP->CUSTO+TMP->ITEM+TMP->CLVL+DTOS(TMP->DDATA))			
		EndCase
	EndIf                                                                                      
	If TMP->DEBITO > 0 .Or. TMP->CREDITO > 0
		Ct190Grava(@nAntDeb,@nAntCrd,cTpSald,lFlag,cChave)	//Grava saldos 
		aSldAnt[1]	:= nAntDeb
		aSldAnt[2]	:= nAntCrd
	EndIf
		
	//Se a data de apuracao de lucros/perdas nao estiver vazia, significa
	//que esse lancamento eh um lancamento de zeramento. 
	//Chama a rotina de atualizacao de Flag de Lucros/Perdas, para atualizar
	//os saldos com data anterior a esses lancamentos.
	If !Empty(TMP->DTLP)
		Ct190FlgLP(TMP->FILIAL, TMP->IDENT, TMP->CONTA, TMP->CUSTO, TMP->ITEM, TMP->CLVL, TMP->DDATA,cTpsald,TMP->DTLP, TMP->MOEDA)
	EndIf		

	cChaveAnt :=TMP->(FILIAL+IDENT+CONTA+CUSTO+ITEM+CLVL+MOEDA) 
	dbSelectArea("TMP")
	dbSkip()
	If lObj
		oObj:IncRegua2(STR0008)//Atualizando saldos... 
	Endif
EndDo

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190Grava³ Autor ³ Simone Mie Sato       ³ Data ³ 18.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava os saldos .							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct190Grava(nAntDeb,nAntCrd)               				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Saldo Anterior debito							  ³±±
±±³          ³ ExpN2 = Saldo Anterior credito                             ³±±
±±³          ³ ExpC1 = Tipo de Saldo                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190Grava(nAntDeb,nAntCrd,cTpSald,lFlag,cChave)
	
Local cArquivo 	:= ""
Local aSaveArea	:= GetArea()     

cArquivo 		:= TMP->IDENT			
dbSelectArea(cArquivo)//Seleciono o arquivo de saldos a ser atualizado

//Se for a Rotina de Atualizacao de Saldos Compostos, devera verificar se existe
//No Reprocessamento, nao eh necessario pq. zera as tabelas ref. o periodo solicitado.
If lFlag  
	dbSetOrder(1)	                                                                          	
	MsSeek(cChave,.F.)       
Endif

If (lFlag .And. !Found()) .Or. !lFlag 
	Reclock(cArquivo,.T.)	
	&(cArquivo+"->"+cArquivo+"_FILIAL")		:= TMP->FILIAL
	&(cArquivo+"->"+cArquivo+"_MOEDA")		:= TMP->MOEDA
	&(cArquivo+"->"+cArquivo+"_TPSALD")		:= cTpSald
	&(cArquivo+"->"+cArquivo+"_CONTA")		:= TMP->CONTA
	&(cArquivo+"->"+cArquivo+"_DATA")		:= TMP->DDATA
	&(cArquivo+"->"+cArquivo+"_STATUS")		:= '1'	
	If cArquivo== 'CTI'               
		CTI->CTI_CLVL		:= TMP->CLVL
		CTI->CTI_ITEM		:= TMP->ITEM
		CTI->CTI_CUSTO		:= TMP->CUSTO				
	ElseIf cArquivo== 'CT4'
		CT4->CT4_ITEM		:= TMP->ITEM
		CT4->CT4_CUSTO		:= TMP->CUSTO
	ElseIf cArquivo == 'CT3'
		CT3->CT3_CUSTO		:= TMP->CUSTO
	EndIf	
Else
	Reclock(cArquivo,.F.)	
EndIf	                                                

If cArquivo <> 'CT7'
	&(cArquivo+"->"+cArquivo+"_SLCOMP")		:= 'N'		
Endif
If Empty(TMP->DTLP)                                                         
	&(cArquivo+"->"+cArquivo+"_LP")			:= 'N'		
Else	//Se estiver preenchido, eh um saldo de zeramento de lucros/perdas
	&(cArquivo+"->"+cArquivo+"_LP")			:= 'Z'		
EndIf
//&(cArquivo+"->"+cArquivo+"_SLBASE")		:= 'S'		
&(cArquivo+"->"+cArquivo+"_DEBITO")		:= TMP->DEBITO
&(cArquivo+"->"+cArquivo+"_CREDIT")		:= TMP->CREDITO
&(cArquivo+"->"+cArquivo+"_ANTDEB")		:= nAntDeb
&(cArquivo+"->"+cArquivo+"_ANTCRD")		:= nAntCrd
&(cArquivo+"->"+cArquivo+"_ATUDEB")		:= nAntDeb+TMP->DEBITO
&(cArquivo+"->"+cArquivo+"_ATUCRD")		:= nAntCrd+TMP->CREDITO
		
MsUnlock()
nAntDeb	:= &(cArquivo+"->"+cArquivo+"_ATUDEB")
nAntCrd	:= &(cArquivo+"->"+cArquivo+"_ATUCRD")

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb190Lote³ Autor ³ Simone Mie Sato       ³ Data ³ 17.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reprocessamento - refaz os arquivos de saldo por lote.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb190Lote()                                  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpC1 = Filial De                                           ³±±
±±³          ³ExpC2 = Filial Ate                                          ³±±
±±³          ³ExpC3 = Tipo de Sald                                        ³±±
±±³          ³ExpD1 = Data Inicial                                        ³±±
±±³          ³ExpD2 = Data Final                                          ³±±
±±³          ³ExpO1 = Objeto utilizado na regua de Processamento          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb190Lote(nInicio,nFinal,cFilDe,cFilAte,cTpSald,dDataIni,dDataFim,oObj)
	
Local cQuery		:= ""
Local cRepLote 		:= ""
Local aStru			:= {}
Local nMvSoma		:= Getmv("MV_SOMA") //Determina se o lancam. tipo 3 ira ser somado 1 ou 2 vezes
Local ni
Local lObj 			:= ValType(oObj) == "O"

If TcSrvType() != "AS/400"           
	
	cRepLote:= "cRepLote"
	cQuery := "SELECT CT2_DC TIPO, CT2_FILIAL FILIAL,CT2_DATA, CT2_LOTE LOTE, CT2_SBLOTE SBLOTE, "
	cQuery += "SUM(CT2_VALOR) VALOR, CT2_MOEDLC MOEDA "
	cQuery += "FROM "+RetSqlName("CT2")+" CT2 "
	If cFilDe == cFilAte
		cQuery += "WHERE CT2.CT2_FILIAL = '"+cFilDe+"' AND "
	Else
		cQuery += "WHERE CT2.CT2_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
	EndIf

	If dDataIni == dDataFim
		cQuery += "CT2.CT2_DATA = '"+DTOS(dDataIni)+"' AND "		/// ORDEM ALTERADA P/ ANTENDER À CHAVE DE ÍNDICES	
	Else
		cQuery += "CT2.CT2_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "		/// ORDEM ALTERADA P/ ANTENDER À CHAVE DE ÍNDICES	
	EndIf

	cQuery += "CT2.CT2_TPSALD='"+cTpSald+"' AND "
	
	If nInicio == nFinal
		cQuery += "CT2.CT2_MOEDLC = '"+StrZero(nInicio,2)+"' AND "
	Else
		cQuery += "CT2.CT2_MOEDLC BETWEEN '"+StrZero(nInicio,2)+"' AND '"+StrZero(nFinal,2) + "' AND "
	EndIf
	cQuery += "D_E_L_E_T_<>'*'"
	cQuery += " GROUP BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DC, CT2_MOEDLC "
	cQuery += " ORDER BY "
	If Upper(TCGetDb()) == "INFORMIX"			
		cQuery += "2,3,4,5,1,7"
	Else
		cQuery += "CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DC, CT2_MOEDLC "
	EndIf
	cQuery := ChangeQuery(cQuery)
		
	dbSelectArea("CT2")
	dbCloseArea()
		
	If ( Select ( "cRepLote" ) <> 0 )
		dbSelectArea ( "cRepLote" )
		dbCloseArea ()
	Endif
			
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRepLote,.T.,.F.)
		
	aStru := CT2->(dbStruct())
		
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			If Subs(aStru[ni,1],1,9) == "CT2_VALOR"								
				TCSetField(cRepLote, "VALOR", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
			ElseIf Subs(aStru[ni,1],1,8) == "CT2_DATA" .And. Subs(aStru[ni,1],1,10) <> "CT2_DATATX"
				TCSetField(cRepLote, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			EndIf
		Endif
	Next ni
		
	dbSelectArea(cRepLote)
	//Gravacao do saldo por lote
	While !Eof()    	 
 		dbSelectArea("CT6")        
 		dbSetOrder(1)
 		If !MsSeek(cRepLote->FILIAL+DTOS(cRepLote->CT2_DATA)+cRepLote->LOTE+cRepLote->SBLOTE+cRepLote->MOEDA+cTpSald)
			Reclock("CT6",.T.)
			CT6->CT6_FILIAL 	:= cRepLote->FILIAL
			CT6->CT6_MOEDA		:= cRepLote->MOEDA
			CT6->CT6_TPSALD		:= cTpSald
			CT6->CT6_DATA		:= cRepLote->CT2_DATA
			CT6->CT6_LOTE		:= cRepLote->LOTE
			CT6->CT6_SBLOTE		:= cRepLote->SBLOTE
			CT6->CT6_STATUS	:= '1' 
			If cRepLote->TIPO $ '1/3'				
				CT6->CT6_DEBITO	:= cRepLote->VALOR
			Endif
			If cRepLote->TIPO $ '2/3'				
				CT6->CT6_CREDIT	:= cRepLote->VALOR
			EndIf
			If cRepLote->TIPO == '3' //Se o tipo do lancamento for Partida dobrada
				If nMvSoma == 1
				   	CT6->CT6_DIG := cRepLote->VALOR
			 	ElseIf nMvSoma == 2                                                     
				   	CT6->CT6_DIG := 2*(cRepLote->VALOR)			 	
				EndIf				      
			Else 
			   	CT6->CT6_DIG := cRepLote->VALOR
			EndIf
			MsUnlock()
	  	Else                                                          
	  		Reclock("CT6",.F.)   
	  		If cRepLote->TIPO $'1/3'
				CT6->CT6_DEBITO	+= cRepLote->VALOR
			EndIf
			If cRepLote->TIPO $'2/3'
				CT6->CT6_CREDIT	+= cRepLote->VALOR
			EndIf
			If cRepLote->TIPO  == '3' 
				If nMvSoma == 1
				   	CT6->CT6_DIG +=  cRepLote->VALOR
			 	ElseIf nMvSoma == 2                                                     
				   	CT6->CT6_DIG +=  2*(cRepLote->VALOR)
				EndIf				                                            					
			Else                                                          
			   	CT6->CT6_DIG +=  cRepLote->VALOR
			EndIf						
			MsUnlock()
	  	Endif	
		dbSelectArea(cRepLote)
		dbSkip()  
		If lObj
			oObj:IncRegua2(STR0010)//Atualizando saldos por lote... 		
		Endif
	EndDo
			
	If ( Select ( "cRepLote" ) <> 0 )
		dbSelectArea ( "cRepLote" )
		dbCloseArea ()
	Endif
		
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb190Doc ³ Autor ³ Simone Mie Sato       ³ Data ³ 17.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reprocessamento - refaz os arquivos de saldo por documento ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb190Doc()                                   			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpC1 = Filial De                                           ³±±
±±³          ³ExpC2 = Filial Ate                                          ³±±
±±³          ³ExpC3 = Tipo de Sald                                        ³±±
±±³          ³ExpD1 = Data Inicial                                        ³±±
±±³          ³ExpD2 = Data Final                                          ³±±
±±³          ³ExpO1 = Objeto utilizado na regua de Processamento          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb190Doc(nInicio,nFinal,cFilDe,cFilAte,cTpSald,dDataIni,dDataFim,oObj)
	
Local cQuery		:= ""
Local cRepDoc	 	:= ""
Local aStru			:= {}
Local cChave
Local nMvSoma		:= Getmv("MV_SOMA") //Determina se o lancam. tipo 3 ira ser somado 1 ou 2 vezes
Local ni
Local lObj			:= ValType(oObj) == "O"

If TcSrvType() != "AS/400"           
	
	cRepDoc:= "cRepDoc"
	cQuery := "SELECT CT2_DC TIPO, CT2_FILIAL FILIAL,CT2_DATA, CT2_LOTE LOTE, CT2_SBLOTE SBLOTE, CT2_DOC DOC, "
	cQuery += "CT2_MOEDLC MOEDA, SUM(CT2_VALOR) VALOR "
	cQuery += "FROM "+RetSqlName("CT2")+" CT2 "

	If cFilDe == cFilAte
		cQuery += "WHERE CT2.CT2_FILIAL = '"+cFilDe+"' AND "
	Else
		cQuery += "WHERE CT2.CT2_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
	EndIf

	If dDataIni == dDataFim
	cQuery += "CT2.CT2_DATA = '"+DTOS(dDataIni)+"' AND "	/// ALTERADA ORDEM P/ ATENDER INDICE 1
	Else
		cQuery += "CT2.CT2_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "	/// ALTERADA ORDEM P/ ATENDER INDICE 1
	EndIf
	cQuery += "CT2.CT2_TPSALD='"+cTpSald+"' AND "
	
	If nInicio == nFinal
		cQuery += "CT2.CT2_MOEDLC = '"+StrZero(nInicio,2)+"' AND "
	Else
		cQuery += "CT2.CT2_MOEDLC BETWEEN '"+StrZero(nInicio,2)+"' AND '"+StrZero(nFinal,2)+"' AND "	
	EndIf

	cQuery += "D_E_L_E_T_<>'*'"
	cQuery += " GROUP BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC,CT2_DC, CT2_MOEDLC"
	cQuery += " ORDER BY "
	If Upper(TCGetDb()) == "INFORMIX"		                                                      
		cQuery += "2,3,4,5,6,1,7"
	Else
		cQuery += "CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC,CT2_DC, CT2_MOEDLC"
	EndIf
	cQuery := ChangeQuery(cQuery)
		
	dbSelectArea("CT2")
	dbCloseArea()
		
	If ( Select ( "cRepDoc" ) <> 0 )
		dbSelectArea ( "cRepDoc" )
		dbCloseArea ()
	Endif
			
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRepDoc,.T.,.F.)
		
	aStru := CT2->(dbStruct())
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			Do Case
			Case Subs(aStru[ni,1],1,9) == "CT2_VALOR"								
				TCSetField(cRepDoc,"VALOR", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
			Case Subs(aStru[ni,1],1,8) == "CT2_DATA" .And. Subs(aStru[ni,1],1,10) <> "CT2_DATATX"
				TCSetField(cRepDoc, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			EndCase
		Endif
	Next ni


	dbSelectArea(cRepDoc)
	cChave	:= ""
	//Gravacao do saldo por documento
	While !Eof()     
		//So ira gravar saldo por documento para a moeda do lancamento
 		dbSelectArea("CTC")        
		dbSetOrder(1)
		If !MsSeek(cRepDoc->FILIAL+Dtos(cRepDoc->CT2_DATA)+cRepDoc->LOTE+cRepDoc->SBLOTE+cRepDoc->DOC+cRepDoc->MOEDA+cTpsald)
			Reclock("CTC",.T.)
			CTC->CTC_FILIAL 	:= cRepDoc->FILIAL
			CTC->CTC_MOEDA		:= cRepDoc->MOEDA
			CTC->CTC_TPSALD		:= cTpsald
			CTC->CTC_DATA		:= cRepDoc->CT2_DATA   
			CTC->CTC_LOTE		:= cRepDoc->LOTE
			CTC->CTC_SBLOTE		:= cRepDoc->SBLOTE
			CTC->CTC_DOC		:= cRepDoc->DOC
			CTC->CTC_STATUS	:= '1'
			If cRepDoc->TIPO $ '1/3'
				CTC->CTC_DEBITO	:= cRepDoc->VALOR
			EndIf
			If cRepDoc->TIPO $ '2/3'
				CTC->CTC_CREDIT	:= cRepDoc->VALOR
			EndIf
			If cRepDoc->TIPO == '3' 
				If nMvSoma == 1
				   	CTC->CTC_DIG := cRepDoc->VALOR
			 	ElseIf nMvSoma == 2                                                     
				   	CTC->CTC_DIG := 2*(cRepDoc->VALOR)
				EndIf				                                                         
			Else
			   	CTC->CTC_DIG := cRepDoc->VALOR
			EndIf
			MsUnlock()
	  	Else                                                          
  			Reclock("CTC",.F.)
			If cRepDoc->TIPO $ '1/3'
				CTC->CTC_DEBITO	+= cRepDoc->VALOR
			EndIf
			If cRepDoc->TIPO $ '2/3'
				CTC->CTC_CREDIT	+= cRepDoc->VALOR
			EndIf
			If cRepDoc->TIPO  == '3' 
				If nMvSoma == 1
				   	CTC->CTC_DIG += cRepDoc->VALOR
			 	ElseIf nMvSoma == 2                                                     
				   	CTC->CTC_DIG += 2*(cRepDoc->VALOR)			 	
				EndIf				                                            
			Else                                                        
			   	CTC->CTC_DIG += cRepDoc->VALOR
			EndIf
			MsUnlock()
		Endif	
		  		
  		If 	CTC->CTC_INF > 0 .And.;
  			! CT6->(MsSeek(CTC->CTC_FILIAL+Dtos(CTC->CTC_DATA)+;
  			CTC->CTC_LOTE+CTC->CTC_SBLOTE+CTC->CTC_MOEDA+CTC->CTC_TPSALD)) .And.;
  			cRepDoc->MOEDA = CTC->CTC_MOEDA .And.;
  			cChave <> cRepDoc->FILIAL+Dtos(cRepDoc->CT2_DATA)+cRepDoc->LOTE+cRepDoc->SBLOTE+cRepDoc->DOC+cRepDoc->MOEDA+cTpsald
  			
			Reclock("CT6",.T.)
			CT6->CT6_FILIAL := cRepDoc->FILIAL
			CT6->CT6_MOEDA	:= cRepDoc->MOEDA
			CT6->CT6_TPSALD	:= cTpsald
			CT6->CT6_DATA	:= cRepDoc->CT2_DATA   
			CT6->CT6_LOTE	:= cRepDoc->LOTE
			CT6->CT6_SBLOTE	:= cRepDoc->SBLOTE
			CT6->CT6_STATUS	:= '1'
			CT6->CT6_INF	+= CTC->CTC_INF
			MsUnLock()
  		ElseIf 	CTC->CTC_INF > 0 .And. cRepDoc->MOEDA = CTC->CTC_MOEDA .And.;
	  			cChave <> cRepDoc->FILIAL+Dtos(cRepDoc->CT2_DATA)+cRepDoc->LOTE+cRepDoc->SBLOTE+cRepDoc->DOC+cRepDoc->MOEDA+cTpsald
			Reclock("CT6",.F.)
			CT6->CT6_INF	+= CTC->CTC_INF
			MsUnLock()
  		Endif	
		dbSelectArea(cRepDoc)
		cChave := cRepDoc->FILIAL+Dtos(cRepDoc->CT2_DATA)+cRepDoc->LOTE+cRepDoc->SBLOTE+cRepDoc->DOC+cRepDoc->MOEDA+cTpsald
		dbSkip()
		If lObj
			oObj:IncRegua2(STR0011)//Atualizando saldos por documento... 				
		Endif
	EndDo
	
	If ( Select ( "cRepDoc" ) <> 0 )
		dbSelectArea ( "cRepDoc" )
		dbCloseArea ()
	Endif		
EndIf			

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190SlBse³ Autor ³ Simone Mie Sato       ³ Data ³ 09.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama as rotinas de atualizacao de Saldos Basicos.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct190SlBse()                                  		 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpL1 = Indica se utiliza Classe de Valor                   ³±±
±±³          ³ExpL2 = Indica se utiliza Item                              ³±±
±±³          ³ExpL3 = Indica se utiliza c.Custo	                          ³±±
±±³          ³ExpC1 = Tipo de Saldo            	                          ³±±
±±³          ³ExpL4 = Defina se eh moeda especifica                       ³±±
±±³          ³ExpC2 = Filial De                                           ³±±
±±³          ³ExpC3 = Filial Ate                                          ³±±
±±³          ³ExpD1 = Data Inicial                                        ³±±
±±³          ³ExpD2 = Data Final                                          ³±±
±±³          ³ExpL5 = Define se verifica Flag CT2_SLBASE                  ³±±
±±³          ³ExpO1 = Objeto utilizado na regua de Processamento          ³±±
±±³          ³ExpN3 = Numero do menor Recno                               ³±±
±±³          ³ExpN4 = Numero do maior Recno                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSald,lMoedaEsp,cFilDe,cFilAte,dDataIni,dDataFim,lFlag,oObj,nMin,nMax)        

Local aSaveArea	:= GetArea()
Local cArqTrb	:= ""
Local lObj		:= ValType(oObj) == "O"

If lObj
	oObj:IncRegua1(STR0028)//"Totalizando Lançamentos... CT2"
EndIf

//Cria arquivo de Trabalho
cArqTrb := Ct190CrTrb(nInicio,nFinal)
	
//Monta query do CT2 a partir do CT2
Ct190Query(	cFilDe,cFilAte,dDataIni,dDataFim,nInicio,nFinal,cTpSald,;
			lCusto,lItem,lClVl,lFlag)

If lObj
	oObj:IncRegua1(STR0009)//"Atualizando Arq. de Trabalho... "
EndIf
//Atualiza arquivo de trabalho	    
Ct190AtTrb(nInicio,nFinal,lCusto,lItem,lClVl,oObj)

If lObj
	oObj:IncRegua1(STR0026)//"Atualizando Flag Lancamentos..."
EndIf

Ct190Flag(cFilDe,cFilAte,dDataIni,dDataFim,nInicio,nFinal,cTpSald,lFlag)

If lObj
	oObj:IncRegua1(STR0027)//"Atualizando Saldos..."
EndIf
//Grava os saldos nos arquivos de saldos
Ct190GrSld(nInicio,nFinal,cTpSald,lMoedaEsp,cFilDe,cFilAte,oObj,lFlag)					

If Select("TMP") != 0
	dbSelectArea("TMP")
	dbCloseArea()
	FErase(cArqTRB + GetDbExtension())
	Ferase(cArqTrb + OrdBagExt())
EndIf

RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct190Query³ Autor ³ Simone Mie Sato       ³ Data ³ 31.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta as querys a partir do CT2.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Monta as querys a partir do CT2.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 = Filial De                                           ³±±
±±³          ³ExpC2 = Filial Ate                                          ³±±
±±³          ³ExpD1 = Data Inicial                                        ³±±
±±³          ³ExpD2 = Data Final                                          ³±±
±±³          ³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpC3 = Tipo de Saldo                                       ³±±
±±³          ³ExpL1 = Indica se utiliza Classe de Valor                   ³±±
±±³          ³ExpL2 = Indica se utiliza Item                              ³±±
±±³          ³ExpL3 = Indica se utiliza c.Custo	                          ³±±
±±³          ³ExpN3 = Numero do menor Recno                               ³±±
±±³          ³ExpN4 = Numero do maior Recno                               ³±±
±±³          ³ExpL5 = Define se verifica Flag CT2_SLBASE                  ³±±
±±³          ³ExpC4 = Condicao para flag na funcao CT190FLAG              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190Query(cFilDe,cFilAte,dDataIni,dDataFim,nInicio,nFinal,cTpSald,;
					lCusto,lItem,lClVl,lFlag)


Local cCond			:= ""

#IFDEF TOP
	Local aStru			:= ""                                      
	Local cAtualiza		:= ""       	
	Local cQuery		:= ""	
	Local ni
#ENDIF	

If !lFlag
	cCond	:=	" (CT2.CT2_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"') AND "				 
Endif

#IFDEF TOP
	If TcSrvType() != "AS/400"
	
		//Query com os lancamentos	
		cAtualiza := "cAtualiza"
		If TCGetDb() == "POSTGRES"		
			cQuery := "SELECT CHAR(1) '1' TIPO, CT2_FILIAL FILIAL, CT2_DATA, CT2_DEBITO CONTA, "		
		Else
			cQuery := "SELECT '1' TIPO, CT2_FILIAL FILIAL, CT2_DATA, CT2_DEBITO CONTA, "
		EndIF
		cQuery += "CT2_CCD CUSTO, CT2_ITEMD ITEM, CT2_CLVLDB CLVL, CT2_MOEDLC MOEDA, CT2_DTLP, SUM(CT2_VALOR) VALOR "
		cQuery += " FROM "+RetSqlName("CT2")+" CT2 "
		If cFilDe == cFilAte
			cQuery += "WHERE CT2.CT2_FILIAL = '"+cFilDe+"' AND "		
		Else
			cQuery += "WHERE CT2.CT2_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
		EndIf
		cQuery += "(CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') AND "
		cQuery += cCond
		cQuery += "CT2.CT2_TPSALD='"+cTpSald+"' AND "
		If nInicio == nFinal
			cQuery += "CT2.CT2_MOEDLC = '"+StrZero(nInicio,2)+"' AND "						
		Else
			cQuery += "CT2.CT2_MOEDLC BETWEEN '"+StrZero(nInicio,2)+"' AND '"+StrZero(nFinal,2)+"' AND "						
		EndIf
		cQuery += "D_E_L_E_T_<>'*'"
		cQuery += " GROUP BY CT2_FILIAL, CT2_DEBITO, CT2_CCD, CT2_ITEMD, CT2_CLVLDB, CT2_MOEDLC, CT2_DATA, CT2_DTLP"
		cQuery += " UNION "
		If TCGetDb() == "POSTGRES"				
			cQuery += "SELECT CHAR(1) '2' TIPO, CT2_FILIAL FILIAL, CT2_DATA, CT2_CREDIT CONTA, "		
		Else
			cQuery += "SELECT '2' TIPO, CT2_FILIAL FILIAL, CT2_DATA, CT2_CREDIT CONTA, "
		EndIf
		cQuery += "CT2_CCC CUSTO, CT2_ITEMC ITEM, CT2_CLVLCR CLVL, CT2_MOEDLC MOEDA, CT2_DTLP, SUM(CT2_VALOR) VALOR "
		cQuery += " FROM "+RetSqlName("CT2")+" CT2 "
		If cFilDe == cFilAte
			cQuery += "WHERE CT2.CT2_FILIAL = '"+cFilDe+"' AND "		
		Else
			cQuery += "WHERE CT2.CT2_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
		EndIf
		cQuery += "(CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') AND "
		cQuery += cCond
		cQuery += "CT2.CT2_TPSALD='"+cTpSald+"' AND "
		If nInicio == nFinal
			cQuery += "CT2.CT2_MOEDLC = '"+StrZero(nInicio,2)+"' AND "						
		Else
			cQuery += "CT2.CT2_MOEDLC BETWEEN '"+StrZero(nInicio,2)+"' AND '"+StrZero(nFinal,2)+"' AND "						
		EndIf
		cQuery += "D_E_L_E_T_<>'*'"
		cQuery += " GROUP BY CT2_FILIAL, CT2_CREDIT, CT2_CCC, CT2_ITEMC, CT2_CLVLCR, CT2_MOEDLC, CT2_DATA, CT2_DTLP"		
		cQuery += " ORDER BY "
		If Upper(TCGetDb()) == "INFORMIX"				
			//cQuery += "2,3,4,5,6,7"
			If cFilDe <> cFilAte
				cQuery += "2,"
			EndIf
			cQuery += "1,4,5,6,7"
			If dDataIni <> dDataFim
				cQuery += ",3"
			EndIf
		Else
			//cQuery += "FILIAL, CONTA, CUSTO, ITEM, CLVL"
			If cFilDe <> cFilAte
				cQuery += "FILIAL,"
			EndIf
			cQuery += "CONTA, CUSTO, ITEM, CLVL, TIPO"
			If dDataIni <> dDataFim
				cQuery += ",CT2_DATA"
			EndIf
		EndIf
		cQuery := ChangeQuery(cQuery)   

		dbSelectArea("CT2")
		dbCloseArea()
			
		If ( Select ( "cAtualiza" ) <> 0 )
			dbSelectArea ( "cAtualiza" )
			dbCloseArea ()
		Endif
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAtualiza,.T.,.F.)
			
		aStru := CT2->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				If Subs(aStru[ni,1],1,9) == "CT2_VALOR"								
					TCSetField(cAtualiza,"VALOR", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				ElseIf Subs(aStru[ni,1],1,8) == "CT2_DATA" .And. Subs(aStru[ni,1],1,10) <> "CT2_DATATX"
					TCSetField(cAtualiza, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				ElseIf Subs(aStru[ni,1],1,8) == "CT2_DTLP"
					TCSetField(cAtualiza, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])					
				EndIf
			EndIF
		Next ni          
	EndIf		
#ENDIF
		
Return		

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct190AtTRb³ Autor ³ Simone Mie Sato       ³ Data ³ 31.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Varre query do CT2,para chamar rotina de Grav. do TRB.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Monta as querys ref. o CT2.    .                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpL1 = Indica se utiliza c.Custo	                          ³±±
±±³          ³ExpL2 = Indica se utiliza Item                              ³±±
±±³          ³ExpL3 = Indica se utiliza Classe de Valor                   ³±±
±±³          ³ExpO1 = Objeto utilizado na regua de Processamento          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190AtTrb(nInicio,nFinal,lCusto,lItem,lClVl,oObj)

Local cSpacCC := ""
Local cSpacIT := ""
Local cSpacCL := ""
Local lObj 	  := ValType(oObj) == "O"
If lObj
	oObj:SetRegua2(cAtualiza->(LastRec()))
Endif
dbSelectArea("TMP")
dbSetOrder(1)
cSpacCC := Space(Len(CUSTO))
cSpacIT := Space(Len(ITEM))
cSpacCL := Space(Len(CLVL))

dbSelectArea("cAtualiza")
dbGoTop()
//Gravacao do arquivo temporario ref. os saldos de conta, item, c.custo e cl. valor

While !Eof()
			
	//Guarda os movimentos por Data/Conta/C.custo/Item/Cl.Valor
	If lClVl .And. !Empty(cAtualiza->CLVL)			
		Ct190GrTrb("CTI",nInicio,nFinal,cSpacCC,cSpacIT,cSpacCL)
	EndIf
			
	//Guarda os movimentos por Data/Conta/C.custo/Item
	If lItem .And. !Empty(cAtualiza->ITEM)			
		Ct190GrTrb("CT4",nInicio,nFinal,cSpacCC,cSpacIT,cSpacCL)
	Endif
			
	//Guarda os movimentos por Data/Conta/CC
	If lCusto .And. !Empty(cAtualiza->CUSTO)			
		Ct190GrTrb("CT3",nInicio,nFinal,cSpacCC,cSpacIT,cSpacCL)
	EndIf
		
	//Guarda os movimentos por Data/Conta
	Ct190GrTrb("CT7",nInicio,nFinal,cSpacCC,cSpacIT,cSpacCL)    			
			
	dbSelectArea("cAtualiza")			
	dbSkip()            
	If lObj
		oObj:IncRegua2(STR0009) //"Atualizando arq. de trabalho..."
	Endif
EndDo					                                  

If ( Select ( "cAtualiza" ) <> 0 )
	dbSelectArea ( "cAtualiza" )
	dbCloseArea ()
Endif
		
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190RDbf ³ Autor ³ Simone Mie Sato       ³ Data ³ 17.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reprocessamento - rotina para Codebase.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ct190RDbf()                                  		 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpL1 = Indica se utiliza Classe de Valor                   ³±±
±±³          ³ExpL2 = Indica se utiliza Item                              ³±±
±±³          ³ExpL3 = Indica se utiliza c.Custo	                          ³±±
±±³          ³ExpC1 = Tipo de Saldo                                       ³±±
±±³          ³ExpD1 = Data Inicial                                        ³±±
±±³          ³ExpD2 = Data Final               	                          ³±±
±±³          ³ExpO1 = Objeto utilizado no Reprocessamento                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSald,dDataIni,dDataFim,oObj)	

Local aSaveArea := GetArea()
Local lRegCTZ	:= .F.	//Verifica se existe registro no arquivo CTZ.
Local lParDob	:= .F.

If oObj <> Nil
	oObj:SetRegua2(CT2->(LastRec()))
Endif

// Inicia Reprocessamento tomando como base os lancamentos contabeis
dbSelectArea("CT2")
dbSetOrder( 1 )
dbSeek(xFilial()+DtoS(dDataIni),.T.)
While !Eof() .and. CT2->CT2_FILIAL == xFilial() .and. ;
		DTOS(CT2->CT2_DATA) <= DTOS(dDataFim)
		
	IF CT2->CT2_DC $ "4 "
		dbSkip()
		Loop
	EndIF
			
	If cTpSald <> D_PRELAN				// Tipo do Saldo
		If CT2->CT2_TPSALD != cTpsald
			dbSkip()
			Loop
		EndIf
	EndIf
			
	If (CT2->CT2_MOEDLC < StrZero(nInicio,2)) .Or. (CT2->CT2_MOEDLC > StrZero(nFinal,2))
		dbSkip()
		Loop
	EndIf			
	cMoeda := CT2->CT2_MOEDLC
	nValor := CT2->CT2_VALOR		
	// Reprocessa DEBITO
	If CT2->CT2_DC $ "13" 
		// Saldos de Lote
		If CT2->CT2_DC == "3"
			lParDob := .T.
		EndIf
		GravaCT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,"1",CT2->CT2_DATA,cMoeda,nValor,CT2->CT2_TPSALD,lParDob)
		If cMoeda == CT2->CT2_MOEDLC
			// Saldos de Documento
			GravaCTC(	CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,"1",CT2->CT2_DATA,;
						cMoeda,nValor,CT2->CT2_TPSALD,lParDob)
			If CTC->CTC_INF > 0
				CT6->(RecLock("CT6", .F.))
				CT6->CT6_INF += CTC->CTC_INF
				MsUnLock()
			Endif
		EndIf
		// Saldos do Plano de Contas
		GRAVACT7(CT2->CT2_DEBITO,"1",CT2->CT2_DATA,cMoeda,nValor,CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)		
		If !Empty(CT2->CT2_DTLP)                                                                       
			If lRegCTZ     
				//Atualiza o flag de LP nos arquivos de saldos.
				CtbFlgCTZ(cMoeda,'CT7')					
			Else				
				//Atualiza o flag de LP					
				Ct190FlgLP(xFilial(),'CT7', CT2->CT2_DEBITO,,,,CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)					
			EndIf			
		Endif						
		
		// Saldos de Centro de Custo
		If lCusto
			GravaCT3(CT2->CT2_DEBITO,CT2->CT2_CCD,"1",CT2->CT2_DATA,cMoeda,nValor,;
			CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)
			If !Empty(CT2->CT2_DTLP)
				If lRegCTZ     
					//Atualiza o flag de LP nos arquivos de saldos.
					CtbFlgCTZ(cMoeda,'CT3')					
				Else									
					//Atualiza o flag de LP
					Ct190FlgLP(xFilial(),'CT3', CT2->CT2_DEBITO,CT2->CT2_CCD,,,CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)					
				EndIf
			Endif											
		EndIf                           
		// Saldos de Item Contabil
		If lItem
			GravaCT4(CT2->CT2_DEBITO,CT2->CT2_CCD,CT2->CT2_ITEMD,"1",CT2->CT2_DATA,;
			cMoeda,nValor,CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)
			If !Empty(CT2->CT2_DTLP)
				If lRegCTZ     
					//Atualiza o flag de LP nos arquivos de saldos.
					CtbFlgCTZ(cMoeda,'CT4')					
				Else									
					//Atualiza o flag de LP                                                    
					Ct190FlgLP(xFilial(),'CT4', CT2->CT2_DEBITO,CT2->CT2_CCD,CT2->CT2_ITEMD,,CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)					
				EndIf
			Endif											
		EndIf
		// Saldos de Classe de Valor
		If lCLVL
			GravaCTI(CT2->CT2_DEBITO,CT2->CT2_CCD,CT2->CT2_ITEMD,CT2->CT2_CLVLDB,"1",;
			CT2->CT2_DATA,cMoeda,nValor,CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)
			If !Empty(CT2->CT2_DTLP)
				If lRegCTZ     
					//Atualiza o flag de LP nos arquivos de saldos.
					CtbFlgCTZ(cMoeda,'CTI')					
				Else									
					//Atualiza o flag de LP                                                    
					Ct190FlgLP(xFilial(),'CTI', CT2->CT2_DEBITO,CT2->CT2_CCD,CT2->CT2_ITEMD,CT2->CT2_CLVLDB,CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)					
				EndIf
			Endif																
		EndIf
	EndIf
				
	// Reprocessa CREDITO
	If CT2->CT2_DC $ "23" 
		// Saldos de Lote
		If CT2->CT2_DC == "3"
			lParDob := .T.
		EndIf
		GravaCT6(CT2->CT2_LOTE,CT2->CT2_SBLOTE,"2",CT2->CT2_DATA,cMoeda,nValor,CT2->CT2_TPSALD,lParDob)
		// Saldos de Documento
		If cMoeda == CT2->CT2_MOEDLC	
			GravaCTC(CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,"2",CT2->CT2_DATA,cMoeda,nValor,;
			CT2->CT2_TPSALD,lParDob)
		EndIf
		// Saldos de Conta
		GravaCT7(CT2->CT2_CREDIT,"2",CT2->CT2_DATA,cMoeda,nValor,CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)
		If !Empty(CT2->CT2_DTLP)
			If lRegCTZ     
				//Atualiza o flag de LP nos arquivos de saldos.
				CtbFlgCTZ(cMoeda,'CT7')					
			Else								
				//Atualiza o flag de LP
				Ct190FlgLP(xFilial(), 'CT7', CT2->CT2_CREDIT, ,,, CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)					
			EndIf
		EndIf		
		// Saldos de Centro de Custo
		If lCusto
			GravaCT3(CT2->CT2_CREDIT,CT2->CT2_CCC,"2",CT2->CT2_DATA,cMoeda,nValor,;
			CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)
			If !Empty(CT2->CT2_DTLP)
				//Atualiza o flag de LP
				If lRegCTZ     
					//Atualiza o flag de LP nos arquivos de saldos.
					CtbFlgCTZ(cMoeda,'CT3')					
				Else								
					Ct190FlgLP(xFilial(), 'CT3', CT2->CT2_CREDIT,CT2->CT2_CCC ,,, CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)											
				EndIf
			EndIf
		EndIf
		// Saldos de Item Contabil
		If lItem
			GravaCT4(CT2->CT2_CREDITO,CT2->CT2_CCC,CT2->CT2_ITEMC,"2",CT2->CT2_DATA,;
			cMoeda,nValor,CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)
			If !Empty(CT2->CT2_DTLP)
				If lRegCTZ     
					//Atualiza o flag de LP nos arquivos de saldos.
					CtbFlgCTZ(cMoeda,'CT4')					
				Else												
					//Atualiza o flag de LP
					Ct190FlgLP(xFilial(), 'CT4', CT2->CT2_CREDIT,CT2->CT2_CCC,CT2->CT2_ITEMC,, CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)					
				EndIf
			Endif
		EndIf
		// Saldos de Classe de Valor
		If lCLVL
			GravaCTI(CT2->CT2_CREDIT,CT2->CT2_CCC,CT2->CT2_ITEMC,CT2->CT2_CLVLCR,"2",;
			CT2->CT2_DATA,cMoeda,nValor,CT2->CT2_TPSALD,.T.,,,CT2->CT2_DTLP)
			If !Empty(CT2->CT2_DTLP)
				If lRegCTZ     
					//Atualiza o flag de LP nos arquivos de saldos.
					CtbFlgCTZ(cMoeda,'CTI')					
				Else									
					//Atualiza o flag de LP
					Ct190FlgLP(xFilial(),'CTI', CT2->CT2_CREDIT,CT2->CT2_CCC,CT2->CT2_ITEMC,CT2->CT2_CLVLCR,CT2->CT2_DATA,CT2->CT2_TPSALD,CT2->CT2_DTLP, cMoeda)					
				EndIf
			Endif						
		EndIf
	EndIf
			
	dbSelectArea("CT2")         
	//Atualiza Flag
//	Reclock("CT2",.F.)
//	CT2->CT2_SLBASE := "S"
//	MsUnlock()
	dbSkip()
	If oObj <> Nil
		oObj:IncRegua2(STR0008)//Atualizando saldos... 
	Endif
EndDo
                             
RestArea(aSaveArea)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190Flag ³ Autor ³ Simone Mie Sato       ³ Data ³ 17.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza os flags dos lancamentos contabeis.	              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ct190Flag()                                  		 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cWhere = Condicao para efetuar update CT2_SLBASE            ³±±
±±³          ³nMin   = Numero do menor Recno                              ³±±
±±³          ³nMax   = Numero do maior Recno                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                           
Function Ct190Flag(cFilDe,cFilAte,dDataIni,dDataFim,nInicio,nFinal,cTpSald,lFlag)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct190FlgLP³ Autor ³ Simone Mie Sato       ³ Data ³ 08.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza os flags dos saldos ref. lucros/perdas.	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ct190FlgLP()                                 		 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpL1 = Indica se utiliza Classe de Valor                   ³±±
±±³          ³ExpL2 = Indica se utiliza Item                              ³±±
±±³          ³ExpL3 = Indica se utiliza c.Custo	                          ³±±
±±³          ³ExpC1 = Tipo de Saldo                                       ³±±
±±³          ³ExpD1 = Data Inicial                                        ³±±
±±³          ³ExpD2 = Data Final               	                          ³±±
±±³          ³ExpO1 = Objeto utilizado no Reprocessamento                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct190FlgLP(cFilX, cAlias, cConta, cCusto, cItem, cClvl, dData,;
						  cTpsald, dDtLP, cMoeda,cIdent)
 
Local aSaveArea		:= GetArea()
Local cChave		:= ""
Local bCond			:= {||.F.}

#IFDEF TOP
	Local cCond			:= ""
	Local cQuery		:= ""              	
	Local cRegs			:= ""	
	Local nCountReg		:= 0	
	Local nMin			:= ""
	Local nMax			:= ""
	Local nDel			:= iif( TCGetDB() == "INFORMIX", 1024, 4096 )
#ENDIF	

cIdent	:= Iif(cIdent == Nil,"",cIdent)

#IFDEF TOP
	If TcSrvType() != "AS/400"		

		Do Case			
		Case cAlias == 'CT7'
			cCond	:=	" CT7_CONTA = '"+ cConta + "' AND "		
		Case cAlias == 'CT3'                                  			
			cCond	:=	" CT3_CONTA = '"+ cConta + "' AND "
			cCond	+= 	" CT3_CUSTO = '"+ cCusto + "' AND "   			
		Case cAlias == 'CT4'             
			cCond	:= " CT4_CONTA = '" + cConta + "' AND "
			cCond 	+= " CT4_CUSTO = '" + cCusto + "' AND "
			cCond 	+= " CT4_ITEM = '" + cItem + "' AND "
		Case cAlias == 'CTI'                               
			cCond	:= " CTI_CONTA = '" + cConta + "' AND "
			cCond	+= " CTI_CUSTO = '" + cCusto + "' AND "
			cCond 	+= " CTI_ITEM = '" + cItem + "' AND "
			cCond	+= " CTI_CLVL = '" + cClVl + "' AND "
		Case cAlias == 'CTU'
			If cIdent == 'CTD'   
				cCond	:= " CTU_IDENT = 'CTD' AND "
				cCond	+= 	" CTU_CODIGO = '" + cItem + "' AND " 				
			ElseIf cIdent == 'CTH'
				cCond	:= " CTU_IDENT = 'CTH' AND "			
				cCond	+= 	" CTU_CODIGO = '" + cClVl + "' AND " 							
			ElseIf cIdent == 'CTT'
				cCond	:= " CTU_IDENT = 'CTT' AND "			
				cCond	+= 	" CTU_CODIGO = '" + cCusto + "' AND " 							
			EndIf			
		Case cAlias == 'CTV'
			cCond	:=	" CTV_CUSTO = '" + cCusto + "' AND "
			cCond	+= 	" CTV_ITEM = '" + cItem + "' AND " 				
		Case cAlias == 'CTW'
			cCond	:= 	" CTW_CUSTO = '" + cCusto + "' AND " 				
			cCond	+= 	" CTW_CLVL = '" + cClVl + "' AND " 									
		Case cAlias == 'CTX'
			cCond	:= 	" CTX_ITEM = '" + cItem + "' AND " 				
			cCond	+= 	" CTX_CLVL = '" + cClVl + "' AND " 											
		Case cAlias == 'CTY'
			cCond	:= " CTY_CUSTO = '" + cCusto + "' AND "
			cCond	+= " CTY_ITEM = '" + cItem + "' AND "
			cCond	+= " CTY_CLVL = '" + cClVl + "' AND "
		EndCase
		
		cRegs 	:= "cRegs"		
		cQuery	:= "SELECT R_E_C_N_O_ RECNO "
		cQuery  += " FROM "+RetSqlName(cAlias)+" "
		cQuery  += "WHERE "+cAlias+"_FILIAL = '"+cFilX+"' AND "		
		cQuery 	+= cAlias+"_DATA <= '"+ DTOS(dDtLP)+ "' AND "
		cQuery	+= cAlias+"_MOEDA = '"+cMoeda+"' AND "
		cQuery	+= cAlias+"_TPSALD ='"+cTpSald+"' AND "
		cQuery	+= cCond
		cQuery	+= "D_E_L_E_T_<>'*' " 
		cQuery	+= "ORDER BY RECNO" 		
		cQuery	:= ChangeQuery(cQuery)   

		If ( Select ( "cRegs" ) <> 0 )
			dbSelectArea ( "cRegs" )
			dbCloseArea ()
		Endif
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRegs,.T.,.F.)
		
		cQuery 	:= "UPDATE "
		cQuery 	+= RetSqlName(cAlias)+" "	
		cQuery 	+= "SET "
		cQuery 	+= cAlias+"_LP = 'S', "+cAlias+"_DTLP = '"+ Dtos(dDtLP)+ "' "
		cQuery  += " WHERE "+cAlias+"_FILIAL = '"+cFilX+"' AND "		
		cQuery 	+= cAlias+"_DATA <= '"+ DTOS(dDtLP)+ "' AND "
		cQuery	+= cAlias+"_MOEDA = '"+cMoeda+"' AND "
		cQuery	+= cAlias+"_TPSALD ='"+cTpSald+"' AND " 
		cQuery	+= cAlias+"_LP = 'N' AND "
		cQuery	+= cCond
		cQuery	+= "D_E_L_E_T_<>'*' " 
		
		While cRegs->(!EOF())
		
			nMin := (cRegs)->RECNO
			
			cRegs->(DbSkip(nDel))

			If cRegs->(Eof())
				cChave := ""
			Else
				nMax := (cRegs)->RECNO
				cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
			EndIf
							
			if TcSqlExec( cQuery + cChave ) <> 0
				UserException( STR0024 + RetSqlName(cAlias) ;
								+ CRLF + STR0023 + CRLF + TCSqlError() )
			endif
			
		EndDo

		If ( Select ( "cRegs" ) <> 0 )
			dbSelectArea ( "cRegs" )
			dbCloseArea ()
		Endif

	Else
#ENDIF
	//Se for codebase ou AS/400	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	Do Case
	Case cAlias == 'CTI'
		cChave	:= cMoeda+cTpSald+cConta+cCusto+cItem+cClVl
		bCond 	:= { ||CTI->CTI_CLVL == cClvl .And. CTI->CTI_ITEM == cItem .And. CTI->CTI_CUSTO == cCusto .And. CTI->CTI_CONTA == cConta }
	Case cAlias == 'CT4'
		cChave	:= cMoeda+cTpSald+cConta+cCusto+cItem
		bCond	:= { ||CT4->CT4_ITEM == cItem .And. CT4->CT4_CUSTO == cCusto .And. CT4->CT4_CONTA == cConta}
	Case cAlias == 'CT3'
		cChave	:= cMoeda+cTpSald+cConta+cCusto
		bCond	:= { ||CT3->CT3_CUSTO == cCusto .And. CT3->CT3_CONTA == cConta}
	Case cAlias =='CT7'
		cChave	:= cMoeda+cTpSald+cConta
		bCond	:= { ||CT7->CT7_CONTA == cConta}
	EndCase

	If MsSeek(xFilial(cAlias)+cChave)
		While !Eof() .And. xFilial(cAlias) == (cAlias)->&(cAlias+"_FILIAL") .And. ;
			(cAlias)->&(cAlias+"_DATA") <= dDtLP .And. ;
			(cAlias)->&(cAlias+"_MOEDA") == cMoeda .And. ;
			(cAlias)->&(cAlias+"_TPSALD") == cTpSald .And.  Eval(bCond)                  
			
			If !Empty((cAlias)->&(cAlias+"_DTLP"))
				dbSkip()
				Loop
			EndIf
			
			
			If !((cAlias)->&(cAlias+"_LP") $" /N")
				dbSkip()
				Loop
			Endif
			
			Reclock(cAlias,.F.)			
			(cAlias)->&(cAlias+"_DTLP")	:= dDtLP
	     	(cAlias)->&(cAlias+"_LP") 	:= "S"
			MsUnlock()	
			dbSkip()
		End
	EndIf
#IFDEF TOP
	EndIf
#ENDIF

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CtbRegCTZ ³ Autor ³ Simone Mie Sato       ³ Data ³ 28.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se existe registro no arquivo de conta ponte       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbRegCTZ(cMoeda                              		 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbRegCTZ(cMoeda)

Local aSaveArea	:= GetArea()
Local lRet		:= .F.

dbSelectArea("CTZ")
dbSetOrder(1)
If MsSeek(xFilial()+Dtos(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_TPSALD+CT2->CT2_EMPORI+CT2->CT2_FILORI+cMoeda+CT2->CT2_LINHA)
 lRet	:= .T.
EndIf

RestArea(aSaveArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CtbFlgCTZ ³ Autor ³ Simone Mie Sato       ³ Data ³ 28.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama rotina de atualizacao de flags para as contas zeradas ³±±
±±³          ³com conta ponte.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbFlgCTZ()                                   		 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cMoeda = Moeda a ser atualizada							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbFlgCTZ(cMoeda,cAlias)

Local aSaveArea	:= GetArea()
Local nRegCTZ	:= 0

//Considerando que ja esteja posicionado no CTZ

dbSelectArea("CTZ")
dbSetOrder(1)       
nRegCTZ	:= Recno()
While !Eof() .And. CTZ->CTZ_FILIAL == xFilial() .And. Dtos(CT2->CT2_DATA) == Dtos(CTZ->CTZ_DATA) .And. ;
	CTZ->CTZ_LOTE == CT2->CT2_LOTE .And. CTZ->CTZ_SBLOTE == CT2->CT2_SBLOTE .And. CTZ->CTZ_DOC == CT2->CT2_DOC .And.;
	CTZ->CTZ_TPSALD == CT2->CT2_TPSALD .And. CTZ->CTZ_EMPORI == CT2->CT2_EMPORI .And. CTZ->CTZ_FILORI == CT2->CT2_FILORI .And. ;
	CTZ->CTZ_MOEDLC == cMoeda .And. CTZ->CTZ_LINHA == CT2->CT2_LINHA

	Ct190FlgLP(xFilial(cAlias),cAlias, CTZ->CTZ_CONTA,CTZ->CTZ_CUSTO,CTZ->CTZ_ITEM,CTZ->CTZ_CLVL,CTZ->CTZ_DATA,CTZ->CTZ_TPSALD,CT2->CT2_DTLP,cMoeda)						

	dbSkip()
End	                  
dbGoto(nRegCTZ)
RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CtbFlgPon ³ Autor ³ Simone Mie Sato       ³ Data ³ 28.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza os flags das contas zeradas com conta ponte.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbFlgPon()                                    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 = Moeda Inicial                                       ³±±
±±³          ³ExpN2 = Moeda Final                                         ³±±
±±³          ³ExpC1 = Filial De                                           ³±±
±±³          ³ExpC2 = Filial Ate                                          ³±±
±±³          ³ExpC3 = Tipo de Sald                                        ³±±
±±³          ³ExpD1 = Data Inicial                                        ³±±
±±³          ³ExpD2 = Data Final                                          ³±±
±±³          ³ExpO1 = Objeto utilizado na regua de Processamento          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbFlgPon(nInicio,nFinal,cFilDe,cFilAte,cTpSald,dDataIni,dDataFim,oObj)
	
Local cQuery		:= ""
Local cFlgPon  		:= ""
Local aStru			:= {}
Local ni
Local lObj			:= oObj <> Nil

If TcSrvType() != "AS/400"           

	cFlgPon:= "cFlgPon"
	cQuery := "SELECT CTZ_FILIAL, CTZ_DATA, CTZ_MOEDLC, CTZ_CONTA, CTZ_CUSTO, CTZ_ITEM, CTZ_CLVL "
	cQuery += "FROM "+RetSqlName("CTZ")+" CTZ "
	
	If cFilDe == cFilAte
		cQuery += "WHERE CTZ.CTZ_FILIAL = '"+cFilDe+"' AND "
	Else
		cQuery += "WHERE CTZ.CTZ_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
	EndIf
	
	If dDataIni == dDataFim
		cQuery += "CTZ.CTZ_DATA = '"+DTOS(dDataIni)+"' AND "	/// ALTERADA ORDEM P/ ATENDER INDICE 
	Else
		cQuery += "CTZ.CTZ_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "	/// ALTERADA ORDEM P/ ATENDER INDICE 
	EndIf
	cQuery += "CTZ.CTZ_TPSALD='"+cTpSald+"' AND "

	If nInicio == nFinal
		cQuery += "CTZ.CTZ_MOEDLC = '"+StrZero(nInicio,2)+"' AND "		
	Else
		cQuery += "CTZ.CTZ_MOEDLC BETWEEN '"+StrZero(nInicio,2)+"' AND '"+StrZero(nFinal,2)+"' AND "			
	EndIf

	cQuery += "D_E_L_E_T_<>'*'"
	cQuery += " ORDER BY "	
	If TCGetDb() == "INFORMIX"		
		cQuery += "1,2,3,7,6,5,4"
	Else
		cQuery += "CTZ_FILIAL, CTZ_DATA, CTZ_MOEDLC, CTZ_CLVL, CTZ_ITEM , CTZ_CUSTO, CTZ_CONTA"
	EndIf		
	
	cQuery := ChangeQuery(cQuery)
		
	dbSelectArea("CTZ")
	dbCloseArea()
		
	If ( Select ( "cFlgPon" ) <> 0 )
		dbSelectArea ( "cFlgPon" )
		dbCloseArea ()
	Endif
			
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFlgPon,.T.,.F.)
		
	aStru := CTZ->(dbStruct())
		
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			If Subs(aStru[ni,1],1,8) == "CTZ_DATA"
				TCSetField(cFlgPon, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			EndIf
		Endif
	Next ni
		
	dbSelectArea(cFlgPon)
	While !Eof()    	 
		Ct190FlgLP(xFilial("CT7"),"CT7", cFlgPon->CTZ_CONTA,,,, cFlgPon->CTZ_DATA,cTpSald,cFlgPon->CTZ_DATA,cFlgPon->CTZ_MOEDLC)						
		
		If !Empty(cFlgPon->CTZ_CUSTO)
			Ct190FlgLP(xFilial("CT3"),"CT3", cFlgPon->CTZ_CONTA,cFlgPon->CTZ_CUSTO,,,cFlgPon->CTZ_DATA,cTpSald,cFlgPon->CTZ_DATA,cFlgPon->CTZ_MOEDLC)						
		EndIf
		
		If !Empty(cFlgPon->CTZ_ITEM)
			Ct190FlgLP(xFilial("CT4"),"CT4", cFlgPon->CTZ_CONTA,cFlgPon->CTZ_CUSTO,cFlgPon->CTZ_ITEM,,cFlgPon->CTZ_DATA,cTpSald,cFlgPon->CTZ_DATA,cFlgPon->CTZ_MOEDLC)						
		EndIf
		
		If !Empty(cFlgPon->CTZ_CLVL)
			Ct190FlgLP(xFilial("CTI"),"CTI", cFlgPon->CTZ_CONTA,cFlgPon->CTZ_CUSTO,cFlgPon->CTZ_ITEM,cFlgPon->CTZ_CLVL,cFlgPon->CTZ_DATA,cTpSald,cFlgPon->CTZ_DATA,cFlgPon->CTZ_MOEDLC)						
		EndIf
		
		dbSelectArea(cFlgPon)
		dbSkip()  
		If lObj
			oObj:IncRegua2(STR0006)//Atualizando Flags de Saldos 
		Endif
	EndDo
			
	If ( Select ( "cFlgPon" ) <> 0 )
		dbSelectArea ( "cFlgPon" )
		dbCloseArea ()
	Endif
		
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT190ATUMVºAutor  ³Marcos S. Lobo      º Data ³  05/30/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Controle de Reprocessamento Exclusivo						  º±±
±±º          ³Efetua o Lock do Parâmentro para o Controle Exclusivo		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT190ATUMV(dDt2Lock)

Local cNamePar	:= "MV_CTBLOCK"
Local lOk		:= .F.				//// RETORNA .T. SE CONSEGUIU RESERVAR O REGISTRO, .F. SE O REGISTRO JÁ ESTÁ EM USO
Local cSX6Fil	:= xFilial("SX6")

If !GetNewPar("MV_CTBLCKU",.F.)
	Return(.T.)
Endif

dbSelectArea("SX6")
dbSetOrder(1)
If !MsSeek(cSX6Fil+cNamePar)
	RecLock("SX6",.T.) 	/// SE O PARÂMETRO NÃO EXISTE - CRIA E ALIMENTA A DATA
	Field->X6_FIL		:= cSX6Fil
	Field->X6_VAR		:= cNamePar
	Field->X6_TIPO		:= "D"
	Field->X6_DESCRIC   := "Controle Interno - SIGACTB - Atualizado pelo CTBA190"
	Field->X6_DSCSPA	:= "Controle Interno - SIGACTB - Atualizado pelo CTBA190"
	Field->X6_DSCENG	:= "Internal Control - SIGACTB - Up to date by CTBA190"
	Field->X6_CONTEUD	:= DTOC(Ddt2Lock)
	Field->X6_CONTSPA	:= DTOC(Ddt2Lock)
	Field->X6_CONTENG	:= DTOC(Ddt2Lock)
	SX6->(MsUnlock())
	RecLock("SX6",.F.) 	/// RESERVA O REGISTRO PARA NÃO PERMITIR A EXECUÇÃO POR OUTRO USUÁRIO
	lOk := .T.
Else                               
	/// SE O PARÂMETRO JÁ EXISTE
	If SimpleLock("SX6")		
		RecLock("SX6",.F.) 		/// SE NÃO ESTIVER RESERVADO RESERVA E RETORNA .T. POIS PODE EXECUTAR
		Field->X6_CONTEUD	:= DTOC(Ddt2Lock)
		Field->X6_CONTSPA	:= DTOC(Ddt2Lock)
		Field->X6_CONTENG	:= DTOC(Ddt2Lock)
		SX6->(MsUnlock())
		RecLock("SX6",.F.)
		lOk := .T.
	Else
		lOk := .F. 		/// SE JÁ ESTIVER RESERVADO (RETORNA .F. POIS NÃO PODE EXECUTAR)
	Endif
Endif

Return(lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA190   ºAutor  ³Marcos S. Lobo      º Data ³  05/30/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Controle de Reprocessamento Exclusivo                       º±±
±±º          ³Efetua UnLock do parâmetro liberando o processo             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT190LIBMV()
                   
Local cNamePar	:= "MV_CTBLOCK"

If !GetNewPar("MV_CTBLCKU",.F.)
	Return
Endif
                   
dbSelectArea("SX6")
dbSetOrder(1)
If MsSeek(xFilial("SX6")+cNamePar)
	#IFNDEF TOP
	RecLock("SX6",.F.)
	#ENDIF
	Field->X6_CONTEUD	:= " " /// NÃO EFETUA RECLOCK POIS O REGISTRO JÁ ESTA RESERVADO (CT190ATUMV)
	Field->X6_CONTSPA	:= " "
	Field->X6_CONTENG	:= " "
	SX6->(MsUnlock())
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT190CHKMVºAutor  ³Marcos S. Lobo      º Data ³  05/30/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Checa o parâmetro de Reserva do Reprocessamento             º±±
±±º          ³Se o registros estiver alocado, há reprocessamento em uso   º±±
±±º          ³e não deve ser permitida a confirmação de lançamento	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 - CTBA101, CTBA102, CTBA105, CTBA190                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß        
*/                      
Function CT190CHKMV(dDtLan,lRefreshDB,oGetDB)

Local aArea := GetArea()

Local cNamePar	:= "MV_CTBLOCK"
Local lOk		:= .T.

If !GetNewPar("MV_CTBLCKU",.F.)
	Return(.T.)
Endif

DEFAULT lRefreshDB := .F.
                   
dbSelectArea("SX6")
dbSetOrder(1)
If MsSeek(xFilial("SX6")+cNamePar)
	/// SE EXISTIR O PARÂMETRO
	If !SimpleLock("SX6")				//// REGISTRO EM USO RETORNA .F. (NÃO CONSEGUIU EXECUTAR O SIMPLELOCK)
		MsgInfo(STR0015,STR0014)
		If lRefreshDB .and. oGetDB <> Nil
			oGetDB:Refresh()
		Endif
		lOk := .F.
	Else
		SX6->(MsRUnlock())
	Endif
Endif

RestArea(aArea)

Return(lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlDtCal   ºAutor  ³Marcos S. Lobo      º Data ³  05/19/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a validação do intervalo de datas checando se o      º±±
±±º          ³calendario contabil esta bloqueado (conteúdo de MV_CTGBLOQ).º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ dDtIni = Data Inicial do Intervalo                         º±±
±±º          ³ dDtFim = Data Final do Intervalo                           º±±
±±º          ³ nTMoedas = 1 p/ todas as moedas / 2= Moeda Específica      º±±
±±º          ³ cMoeda = Codigo da Moeda específica                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function VlDtCal(dDtIni,dDtFim,nTMoedas,cMoeda,cStatBlq)

Local lDatasOk	:= .T.
Local aCalends	:= {}
Local nCal		:= 1
Local nQ		:= 1

DEFAULT cStatBlq	:= GetNewPar("MV_CTGBLOQ","")	/// INDICA OS STATUS DE CALENDARIO QUE NÃO PERMITEM REPROCESSAR
DEFAULT dDtIni 		:= dDataBase
DEFAULT dDtFim 		:= dDataBase
DEFAULT nTMoedas	:= 2
DEFAULT cMoeda		:= "01"

If __nQuantas == 0
	__nQuantas := CtbMoedas()
EndIf	

For nQ := 1 to __nQuantas
	If nTMoedas == 2
		nQ := Val(cMoeda)
	Else
		cMoeda := StrZero(nQ,2)
	Endif
	
	dbSelectArea("CTE")
	dbSetOrder(1)
	If MsSeek(xFilial("CTE")+cMoeda,.F.)	
		While !Eof() .and. CTE->CTE_MOEDA == cMoeda
			dbSelectArea("CTG")
			dbSetOrder(2)
			If MsSeek(xFilial("CTG")+CTE->CTE_CALEND,.F.)
				While !Eof() .and. CTG->CTG_CALEND == CTE->CTE_CALEND
					If CTG->CTG_STATUS$cStatBlq
						aAdd(aCalends,{CTG->CTG_DTINI,CTG->CTG_DTFIM,CTG->CTG_CALEND,CTG->CTG_PERIOD})
					EndIf
					CTG->(dbSkip())
				EndDo					
			EndIf
			CTE->(dbSkip())
		EndDo
	EndIf
	For nCal := 1 to Len(aCalends)
		If (dDtIni <= aCalends[nCal][1] .and. dDtFim >= aCalends[nCal][2]) .or.;
		   (dDtIni >= aCalends[nCal][1] .and. dDtFim <= aCalends[nCal][2]) .or.;
		   (dDtIni <= aCalends[nCal][1] .and. dDtFim >= aCalends[nCal][1] .and. dDtFim <= aCalends[nCal][2]) .or.;
		   (dDtIni >= aCalends[nCal][1] .and. dDtIni <= aCalends[nCal][2])  
		   
			//"O intervalo de datas informadas não poderá ser processado. "#"Verifique o intervalo de datas ou os calendários no intervalo."
			//"Moeda "#", o periodo "#" do calendario "#" está Bloqueado/Encerrado."
			MsgInfo(STR0016+STR0017,STR0018+StrZero(nQ,2)+STR0019+aCalends[nCal][4]+STR0020+aCalends[nCal][3]+STR0021)
			lDatasOk := .F.
			Exit
		EndIf
	Next	
	If nTMoedas == 2 .or. !lDatasOk
		Exit
	Endif
Next

Return(lDatasOk)