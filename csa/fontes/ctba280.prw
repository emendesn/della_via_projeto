/*/PMC
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³ Nome          ³ Data     ³ PMCs ³  Detalhes                             
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³ Eduardo Nunes ³ 09/12/05 ³ 2    ³  Checagem da utilizacao do conceito de Filiais.
±±³ Eduardo Nunes ³ 09/12/05 ³ 4    ³  Garantir que todas as funcoes tenham apenas um ponto de saida.
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÅÅÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³               ³          ³      ³                                       
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÁÁÁÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#INCLUDE "ctba280.ch"
#Include "PROTHEUS.Ch"
       
#Define CODIGOMOEDA 1
#Define SALDOATUA   1
#Define SALDOS      2

STATIC MAX_LINHA

STATIC __lCusto
STATIC __lItem
STATIC __lClVL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ctba271  ³ Autor ³ Claudio D. de Souza   ³ Data ³ 20.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este programa calcula os rateios Off-Line cadastrados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba271(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCtb                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctba280(lDireto)
Local nOpc,;
		aSays    := {},;
		aButtons := {}
		
Private cCadastro := STR0001 //"Rateios Off-Line"

DEFAULT lDireto		:= .F.                     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros        ³
//³ mv_par01 // Data de Referencia              ³
//³ mv_par02 // Numero do Lote			      	³
//³ mv_par03 // Numero do SubLote		         ³
//³ mv_par04 // Numero do Documento             ³
//³ mv_par05 // Cod. Historico Padrao           ³                      0
//³ mv_par06 // Do Rateio 		        				³   
//³ mv_par07 // Ate o Rateio               		³
//³ mv_par08 // Moedas? Todas / Especifica      ³
//³ mv_par09 // Qual Moeda?                  	³
//³ mv_par10 // Tipo de Saldo 				      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If IsBlind() .Or. lDireto

	If MAX_LINHA = Nil
		MAX_LINHA := GetMv("MV_NUMMAN")
	Endif             
	
	BatchProcess( 	cCadastro, 	STR0002 + STR0003 + STR0004 +Chr(13) + Chr(10) ,"CTB280",; // "Este programa tem o objetivo de efetuar os lan‡amentos referentes aos"
					{ || Ctb280Proc(.T.) }, { || .F. }) 									//"rateios off-line pre-cadastrados. Podera ser utilizado para ratear as"
																							//"despesas dos centros de custos improdutivos nos produtivos."																															
	Return .T.
Endif             

AcertaSXD(lDireto)

Pergunte("CTB280",.F.)

AADD(aSays,STR0002 ) //"Este programa tem o objetivo de efetuar os lan‡amentos referentes aos"
AADD(aSays,STR0003 ) //"rateios off-line pre-cadastrados. Podera ser utilizado para ratear as"
AADD(aSays,STR0004) //"despesas dos centros de custos improdutivos nos produtivos."

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB280",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpc := 1, If( ConaOk(), FechaBatch(), nOpc:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
 
IF nOpc == 1

	If MAX_LINHA = Nil
		MAX_LINHA := GetMv("MV_NUMMAN")
	Endif

	Processa({|lEnd| Ctb280Proc()})
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb280Proc³ Autor ³ Claudio D. de Souza   ³ Data ³ 20.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este programa calcula os rateios Off-Line cadastrados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb280Proc()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA280                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctb280Proc(lBat)

Local lRet 			:= .F.
Local cDoc
Local CTF_LOCK		:= 0
Local cLinha 		:= "001", nLinha := 1
Local cSeqLan 		:= "000"
Local cMoeda		:= ""
Local cHistorico 	:= ""
Local bHistorico 
Local aFormat 		:= {}
Local aSaldos		:= {}
//Variavel lFirst criada para verificar se eh a primeira vez que esta incluindo o 
//lancam. contabil. Se for a primeira vez (.T.),ira trazer 001 na linha. Se nao for 
//a primeira vez e for para repetir o lancamento anterior, ira atualizar a linha 
Local lFirst 		:= .T.                              
Local lAtSldBase	:= Iif(GetMv("MV_ATUSAL")=="S",.T.,.F.)                     
Local dDataIni		:= FirstDay(mv_par01), nX, lSaldo := .F., aRateio := {}, nRecnoCtq
Local aPesos		:= {}, lPesClVl, lPesItem, lPesCC, nTipoPeso := 0
Local cTpSald		:= mv_par10
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= If(mv_par08 = 1, 1, Val(mv_par09))
Local nFinal 		:= If(mv_par08 = 1, __nQuantas, Val(mv_par09)), dMinData := Ctod("")
Local lMoedaEsp		:= If(mv_par08 = 1,.F.,.T.)
Local nMoedas
Local nPesos
Local nRateio
Local xFilSLD		:= ""
Local lMudaHist		:= .F.
Local cEntOri 		:= ""   
Local nXW			:= 1
Local lCT280FILP	:= ExistBlock("CT280FILP")
Local lCT280Hist	:= ExistBlock("CT280HIST")
Local lProc			:= .F.

PRIVATE aCols 		:= {} // Utilizada na conversao das moedas
Private cSubLote
Private dDataLanc   := mv_par01 // Utilizada na funcao CRIACONV() em CTBA101.PRW
// Sub-Lote somente eh informado se estiver em branco
mv_par03 := If(Empty(GetMV("MV_SUBLOTE")), mv_par03, GetMV("MV_SUBLOTE"))
cSubLote := MV_PAR03

DEFAULT lBat	:= .F.                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Antes de iniciar o processamento, verifico os parametros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
Case Empty(mv_par01) // Data de referencia nao preenchida.
	Help(" ",1,"NOCTBDTLP")
Case Empty(mv_par02)	// Lote nao preenchido
	Help(" ",1,"NOCT280LOT")
Case Empty(mv_par03) // Sub Lote nao preenchido
	Help(" ",1,"NOCTSUBLOT")
Case Empty(mv_par04)	// Documento nao preenchido.
	Help(" ",1,"NOCT280DOC")
Case Empty(mv_par05) // Historico Padrao nao preenchido
	Help(" ",1,"CTHPVAZIO")
Case Empty(mv_par06) .And. Empty(mv_par07)// Rateio inicial e final nao preenchidos. 	
	Help(" ",1,"NOCT280RT")
Case mv_par08 == 2 .And. Empty(mv_par09) // Moeda especifica nao preenchida
	Help(" ",1,"NOCTMOEDA")
Case Empty(mv_par10) // Tipo de saldo nao preenchido
	Help(" ",1,"NO280TPSLD")
OtherWise
	lRet := .T.	
EndCase	

If lRet
	//Verificar se o calendario da data solicitada esta encerrado
	lRet := CtbValiDt(1,mv_par01)
EndIf

If __lCusto = Nil
	__lCusto 	:= CtbMovSaldo("CTT")
Endif
If __lItem == Nil
	__lItem	  	:= CtbMovSaldo("CTD")
EndIf
If __lCLVL == Nil
	__lCLVL	  	:= CtbMovSaldo("CTH")
EndIf

If lRet // Parametros validos, posiciona o CT8 (Historico padrao)
	dbSelectArea("CT8")
	dbSetOrder(1)
	If !dbSeek(xFilial("CT8")+mv_par05)
		//Historico Padrao nao existe no cadastro.
		Help(" ",1,"CT280NOHP")	
		lRet := .F.
	Else                
		cHistorico := ""
		If CT8->CT8_IDENT == 'C'
			cHistorico := CT8->CT8_DESC
			lMudaHist := .T.
		Else
			aFormat := {}
			While !Eof() .And. CT8->CT8_HIST == mv_par05 .And. CT8->CT8_IDENT == 'I'
					Aadd(aFormat,CT8->CT8_DESC)
				dbSkip()
			Enddo
			cHistorico := MSHGetText(aFormat)
			bHistorico := {||AllTrim(cHistorico)}
		Endif	
	Endif
Endif	

If lRet
	If !lAtSldBase	//Se os saldos nao foram atualizados na dig. lancamentos 
					//Chama rotina de atualizacao de saldos basicos					
		dIniRep := ctod("")                                
  		If Need2Reproc(mv_par01,mv_par09,mv_par10,@dIniRep) 
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	CTBA190(.T.,dIniRep,mv_par01,cFilAnt,cFilAnt,mv_par10,mv_par08 == 2,mv_par09) },"","",.F.)
			oProcess:Activate()						
		EndIf	
	EndIf	

	CriaConv() // Para criar aCols que sera utilizada na conversao de moedas
    aColsM := AClone(aCols)
    aCols  := {}
	For nX := 1 To Len(aColsM)
		If ! Empty(aColsM[nX][1])
			Aadd(aCols, aColsM[nX])
		Endif
	Next
	
	DbSelectArea("CTO")
	dbSeek(xFilial()+"01",.T.)
	AADD(aCols, { "01", " ", 0.00, "2", .F. } )
	aSort(aCols,,,{|X,Y| x[1] < y[1]})

	aSaldos	:= aClone(aCols)
	For nX := 1 To Len(aCols)
		Aadd(aCols[nX], 0)
	Next 
		
	If !lBat			
		ProcRegua(CTQ->(RecCount()))
	EndIf
	DbSelectarea("CTQ")
	MsSeek(xFilial("CTQ")+mv_par06,.T.)
	// Processa os rateios selecionados
	While CTQ->(!Eof()) .And. CTQ->CTQ_FILIAL == xFilial("CTQ") .And. CTQ->CTQ_RATEIO <= mv_par07

		// Localiza conta origem para exibir descricao da conta na moeda a ser processada
		DbSelectArea("CT1")
		MsSeek(xFilial("CT1")+CTQ->CTQ_CTORI)
		DbSelectArea("CTQ")
		cCtq_Rateio	:= CTQ->CTQ_RATEIO
		If lMudaHist
			// Bloco para retornar a conta origem no historico
			cEntOri := ""
			If !Empty(CTQ->CTQ_CTORI)
				cEntOri += '+"-"+ALLTRIM(CTQ->CTQ_CTORI)'
			EndIf
			If !Empty(CTQ->CTQ_CCORI)
				cEntOri += '+"-"+ALLTRIM(CTQ->CTQ_CCORI)'
			EndIf
			If !Empty(CTQ->CTQ_ITORI)
				cEntOri += '+"-"+ALLTRIM(CTQ->CTQ_ITORI)'
			EndIf
			If !Empty(CTQ->CTQ_CLORI)
				cEntOri += '+"-"+ALLTRIM(CTQ->CTQ_CLORI)'
			EndIf			
			bHistorico := {|| Alltrim(cHistorico)+&cEntOri } 
		EndIf
		
		If mv_par08 == 2 // Moeda especifica
			IncProc(STR0005 + CTQ->CTQ_CTORI + " " + CT1->&("CT1_DESC"+mv_par09)) //"Obtendo saldo da conta: "
			aSaldos[Val(mv_par09)][3] := 0

			If !Empty(CTQ->CTQ_CTORI)
				If !Empty(CTQ->CTQ_CLORI) 
					// Saldo da conta/centro de custo/Item/Classe de Valor
					If CTQ->CTQ_TIPO = "1"
						aSaldos[Val(mv_par09)][3] := MovClass(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
																CTQ->CTQ_ITORI,CTQ->CTQ_CLORI,dDataIni,;
																mv_par01,mv_par09,mv_par10, 3)
					Else
						aSaldos[Val(mv_par09)][3] := SaldoCTI(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
																CTQ->CTQ_ITORI,CTQ->CTQ_CLORI,mv_par01,;
																mv_par09,mv_par10)[1]
					Endif
				ElseIf !Empty(CTQ->CTQ_ITORI) 
					// Saldo da conta/centro de custo/Item
					If CTQ->CTQ_TIPO = "1"
						aSaldos[Val(mv_par09)][3] := MovItem(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
																CTQ->CTQ_ITORI,dDataIni,mv_par01,mv_par09,mv_par10, 3)
					Else
						aSaldos[Val(mv_par09)][3] := SaldoCT4(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
																CTQ->CTQ_ITORI,mv_par01,mv_par09,mv_par10)[1]
					Endif
	
				ElseIf 	!Empty(CTQ->CTQ_CCORI) 
					// Saldo da conta/centro de custo
					If CTQ->CTQ_TIPO = "1"
						aSaldos[Val(mv_par09)][3]	:= MovCusto(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
																dDataIni,mv_par01,mv_par09,mv_par10, 3)
					Else
						aSaldos[Val(mv_par09)][3]	:= SaldoCT3(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
																mv_par01,mv_par09,mv_par10)[1]
					Endif
				Else
					// Saldo da conta
					If CTQ->CTQ_TIPO = "1"
						aSaldos[Val(mv_par09)][3] := MovConta(CTQ->CTQ_CTORI,dDataIni,mv_par01,mv_par09,mv_par10, 3)
					Else
						aSaldos[Val(mv_par09)][3] := SaldoCT7(CTQ->CTQ_CTORI,mv_par01,mv_par09,mv_par10)[1]
					Endif				
				EndIf
			ElseIf 	!Empty(CTQ->CTQ_CLORI) 
				aSaldos[Val(mv_par09)][3] := MovClass(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														CTQ->CTQ_ITORI,CTQ->CTQ_CLORI,dDataIni,mv_par01,;
														mv_par09,mv_par10, If(CTQ->CTQ_TIPO = "1", 3, 4))
			ElseIf	!Empty(CTQ->CTQ_ITORI) 
				aSaldos[Val(mv_par09)][3] := MovItem(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														CTQ->CTQ_ITORI,dDataIni,mv_par01,mv_par09,;
														mv_par10,If(CTQ->CTQ_TIPO = "1", 3, 4))
			ElseIf 	!Empty(CTQ->CTQ_CCORI) 
				aSaldos[Val(mv_par09)][3]	:= MovCusto(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														dDataIni,mv_par01,mv_par09,mv_par10,;
														If(CTQ->CTQ_TIPO = "1", 3, 4))
			Endif	
			aSaldos[Val(mv_par09)][3] := NoRound(aSaldos[Val(mv_par09)][3] * (CTQ->CTQ_PERBAS / 100),3)
			lSaldo := aSaldos[Val(mv_par09)][3] # 0
			aCols[Val(mv_par09)][Len(aCols[Val(mv_par09)])] := 0
			aCols[Val(mv_par09)][2] := If(mv_par09 = "01", "1", "4")
			aCols[1][2]	:= If(mv_par09 <> "01", "5", "1")
		Else
			For nX := 1 To Len(aCols)
				IncProc(STR0005+CTQ->CTQ_CTORI+; //"Obtendo saldo da conta: "
							STR0006+aCols[nX][1]+" "+aCols[nX][2]) //" moeda "
				aSaldos[nX][3] := 0
				If	!Empty(CTQ->CTQ_CTORI) 
					If !Empty(CTQ->CTQ_CLORI)
						// Saldo da conta/centro de custo/Item/Classe de Valor
						If CTQ->CTQ_TIPO = "1"
							aSaldos[nX][3] := 	MovClass(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														CTQ->CTQ_ITORI,CTQ->CTQ_CLORI,dDataIni,mv_par01,;
														aCols[nX][1],mv_par10, 3)
						Else
							aSaldos[nX][3] := 	SaldoCTI(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														CTQ->CTQ_ITORI,CTQ->CTQ_CLORI,mv_par01,;
														aCols[nX][1],mv_par10)[1]
						Endif
					ElseIf	!Empty(CTQ->CTQ_ITORI) 
						// Saldo da conta/centro de custo/Item
						If CTQ->CTQ_TIPO = "1"
							aSaldos[nX][3] := 	MovItem(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														CTQ->CTQ_ITORI,dDataIni,mv_par01,aCols[nX][1],;
														mv_par10, 3)
						Else
							aSaldos[nX][3] := 	SaldoCT4(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														CTQ->CTQ_ITORI,mv_par01,aCols[nX][1],mv_par10)[1]
						Endif
					ElseIf 	!Empty(CTQ->CTQ_CCORI) 
						// Saldo da conta/centro de custo
						If CTQ->CTQ_TIPO = "1"
							aSaldos[nX][3] := 	MovCusto(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
														dDataIni,mv_par01,aCols[nX][1],mv_par10, 3)
						Else
							aSaldos[nX][3] := 	SaldoCT3(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,mv_par01,;
														aCols[nX][1],mv_par10)[1]
						Endif
					Else
						// Saldo da conta
						If CTQ->CTQ_TIPO = "1"
							aSaldos[nX][3] := 	MovConta(CTQ->CTQ_CTORI,dDataIni,mv_par01,;
														aCols[nX][1],mv_par10, 3)
						Else
							aSaldos[nX][3] := 	SaldoCT7(CTQ->CTQ_CTORI,mv_par01,aCols[nX][1],;
														mv_par10)[1]
						Endif
					EndIf
				ElseIf 	!Empty(CTQ->CTQ_CLORI)
					aSaldos[nX][3] := 	MovClass(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
												CTQ->CTQ_ITORI,CTQ->CTQ_CLORI,dDataIni,mv_par01,;
												aCols[nX][1],mv_par10, If(CTQ->CTQ_TIPO = "1", 3, 4))
				ElseIf	!Empty(CTQ->CTQ_ITORI) 
					aSaldos[nX][3] := 	MovItem(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,;
												CTQ->CTQ_ITORI,dDataIni,mv_par01,aCols[nX][1],mv_par10,;
												If(CTQ->CTQ_TIPO = "1", 3, 4))
				ElseIf 	!Empty(CTQ->CTQ_CCORI) 
					aSaldos[nX][3] := 	MovCusto(CTQ->CTQ_CTORI,CTQ->CTQ_CCORI,dDataIni,mv_par01,;
												aCols[nX][1],mv_par10, If(CTQ->CTQ_TIPO = "1", 3, 4))
				Endif
				aSaldos[nX][3] := NoRound(aSaldos[nX][3] * (CTQ->CTQ_PERBAS / 100),3)
				lSaldo := aSaldos[nX][3] # 0 .Or. lSaldo
				aCols[nX][Len(aCols[nX])] := 0
				aCols[nX][2] := If(nX = 1, "1", "4")
			Next
			aCols[1][2]	:= If(aSaldos[1][3] = 0, "5", "1")
		Endif	
		lUltimoLanc := .F.
		IncProc(STR0007 + CTQ->CTQ_CTORI + " " + CT1->&("CT1_DESC"+aCols[1][1])) //"Rateando conta: "
		If lSaldo // Se tiver saldo, processa os rateios cadastrados
			aRateio 	:= {}
			aPesos		:= {}
			lPesCC 		:= lPesItem := lPesClvl := .F.
			nTipoPeso	:= 0
			
			If Empty(CTQ->CTQ_CTPAR)
				lPesCC 	 	:= !Empty(CTQ->CTQ_CCPAR)
				lPesItem 	:= !Empty(CTQ->CTQ_ITPAR)
				lPesClvl 	:= !Empty(CTQ->CTQ_CLPAR)
				nTipoPeso   := If(CTQ->CTQ_TIPO = "1", 3, 4)
        
				For nX := 1 To Len(aSaldos)
					aSaldos[nX][3] := 0
				Next

				For nX := 1 To Len(aCols)
		  			If mv_par08 == 2 // Moeda especifica
						nX := Val(mv_par09)
					Endif
				
					If lPesClVl
						dbSelectArea("CTI")
						dbSetOrder(4)
						cMoeda := StrZero(nX,2)
						xFilSLD:= xFilial("CTI")
						MsSeek(xFilSLD+CTQ->CTQ_CLPAR+cMoeda+mv_par10,.F.) // Posiciona na primeira Cl. de Valor
       	
						While !Eof() .And. CTI->CTI_FILIAL == xFilSLD .And. CTI->CTI_CLVL == CTQ->CTQ_CLPAR 
													 
						  	cConta := CTI->CTI_CONTA
						  	cCusto := ""
						  	cItem  := ""
							While !Eof() .AND. CTI->CTI_FILIAL == xFilSLD .And. CTI->CTI_CLVL == CTQ->CTQ_CLPAR .and.;
							 				   CTI->CTI_CONTA == cConta
								If CTI->CTI_MOEDA <> cMoeda .or. CTI->CTI_TPSALD <> cTpSald
							   		dbSkip()
							   		Loop
								Endif

								If CTQ->CTQ_TIPO = "1"				/// SE FOR RATEIO DE MOVIMENTO
									If CTI->CTI_DATA < dDataIni .or. CTI->CTI_DATA > mv_par01
										dbSkip()
										Loop
									EndIf
								Else								/// SE FOR RATEIO DE SALDO
									If CTI->CTI_DATA > mv_par01
										dbSkip()
										Loop
									EndIf								
								EndIf
			                        
							  	If CTI->CTI_CUSTO <> cCusto .or. CTI->CTI_ITEM <> cItem
							  		cCusto := CTI->CTI_CUSTO
								  	cItem  := CTI->CTI_ITEM
       	
									If (!lPesCC .or. CTI->CTI_CUSTO == CTQ->CTQ_CCPAR) .And. (!lPesITEM .or. CTI->CTI_ITEM == CTQ->CTQ_ITPAR)
										If lCT280FILP
											If !ExecBlock("CT280FILP",.f.,.f.,{"CTI"})
												dbSelectArea("CTI")
												dbSkip()
												Loop
											EndIf
										EndIf
   		   	         		            If (nPesos := Ascan(aPesos, {|x| x[3] == CTI->CTI_CLVL+CTI->CTI_CONTA+CTI_CUSTO+CTI->CTI_ITEM })) <= 0
											Aadd(aPesos, {	Array(Len(aCols)),CTI->(Recno()), CTI->CTI_CLVL+CTI_CONTA+CTI_CUSTO+CTI_ITEM ,CTI->CTI_CONTA })
											nPesos := Len(aPesos)
										Endif
										
										For nXW := 1 To Len(aCols)
											If mv_par08 == 2 // Moeda especifica
												nXW := Val(mv_par09)
											Endif
											If Empty(aPesos[nPesos][1][nXW]) .and. aPesos[nPesos][1][nXW] <> 0
												aPesos[nPesos][1][nXW] := MovClass(CTI->CTI_CONTA,CTI->CTI_CUSTO,CTI->CTI_ITEM,CTI->CTI_CLVL,dDataIni,mv_par01,aCols[nXW][1],mv_par10, nTipoPeso)
												aPesos[nPesos][1][nXW] := NoRound(aPesos[nPesos][1][nXW] * (CTQ->CTQ_PERBAS / 100),3)
												aSaldos[nXW][3] += aPesos[nPesos][1][nXW]
											Endif
											If mv_par08 == 2 // Moeda especifica
												Exit
											Endif
										Next
											
									EndIf
								Endif
							
								dbSkip()
							EndDo
						Enddo              
					ElseIf lPesItem
       	                    
						dbSelectArea("CT4")
						dbSetOrder(4)
						cMoeda := StrZero(nX,2)
						xFilSLD:= xFilial("CT4")
						MsSeek(xFilSLD+CTQ->CTQ_ITPAR+cMoeda+mv_par10,.T.) // Posiciona no primeiro Item Contabil
       	
						While !Eof() .And. CT4->CT4_FILIAL == xFilSLD .And. CT4->CT4_ITEM == CTQ->CTQ_ITPAR
								
						  	cConta := CT4->CT4_CONTA
						  	cCusto := ""
							While !Eof() .AND. CT4->CT4_FILIAL == xFilSLD .And. CT4->CT4_ITEM == CTQ->CTQ_ITPAR .and.;
							 				   CT4->CT4_CONTA == cConta

								If CT4->CT4_MOEDA <> cMoeda .or. CT4->CT4_TPSALD <> cTpSald
							   		dbSkip()
							   		Loop
								Endif
								
								If CTQ->CTQ_TIPO = "1"				/// SE FOR RATEIO DE MOVIMENTO
									If CT4->CT4_DATA < dDataIni .or. CT4->CT4_DATA > mv_par01
										dbSkip()
										Loop
									EndIf
								Else								/// SE FOR RATEIO DE SALDO
									If CT4->CT4_DATA > mv_par01
										dbSkip()
										Loop
									EndIf								
								EndIf
       	
							  	If CT4->CT4_CUSTO <> cCusto
							  		cCusto := CT4->CT4_CUSTO
								                 
									If !lPesCC .or. CT4_CUSTO == CTQ->CTQ_CCPAR
										If lCT280FILP
											If !ExecBlock("CT280FILP",.f.,.f.,{"CT4"})
												dbSelectArea("CT4")
												dbSkip()
												Loop
											EndIf
										EndIf
	    	                            If (nPesos := Ascan(aPesos, { |x| x[3] == CT4->CT4_ITEM+CT4->CT4_CONTA+CT4_CUSTO })) <= 0
											Aadd(aPesos, {Array(Len(aCols)),CT4->(Recno()), CT4_ITEM+CT4_CONTA+CT4_CUSTO , CT4->CT4_CONTA })
											nPesos := Len(aPesos)
										Endif
										For nXW := 1 To Len(aCols)
											If mv_par08 == 2 // Moeda especifica
												nXW := Val(mv_par09)
											Endif
											If Empty(aPesos[nPesos][1][nXW]) .and. aPesos[nPesos][1][nXW] <> 0
												aPesos[nPesos][1][nXW] := MovItem(CT4->CT4_CONTA,CT4->CT4_CUSTO, CT4->CT4_ITEM,dDataIni,mv_par01,aCols[nXW][1],mv_par10, nTipoPeso)
												aPesos[nPesos][1][nXW] := NoRound(aPesos[nPesos][1][nXW] * (CTQ->CTQ_PERBAS / 100),3)
												aSaldos[nXW][3] += aPesos[nPesos][1][nXW]
											Endif
											If mv_par08 == 2 // Moeda especifica
												Exit
											Endif
										Next
										
									Endif
								Endif	
								dbSkip()													
							EndDo
						EndDo
					ElseIf lPesCC
						dbSelectArea("CT3")
						dbSetOrder(6)
						cMoeda := StrZero(nX,2)
						xFilSLD := xFilial("CT3")
						MsSeek(xFilSLD+cMoeda+mv_par10+CTQ->CTQ_CCPAR,.T.) // Posiciona na primeira Conta
							cConta := ""
						While !Eof() .And. CT3->CT3_FILIAL == xFilSLD .And. CT3->CT3_MOEDA  == cMoeda .And.;
										   CT3->CT3_TPSALD == cTpSald .And. CT3->CT3_CUSTO == CTQ->CTQ_CCPAR

							If CT3->CT3_MOEDA <> cMoeda .or. CT3->CT3_TPSALD <> cTpSald
						   		dbSkip()
						   		Loop
							Endif
							If CTQ->CTQ_TIPO = "1"				/// SE FOR RATEIO DE MOVIMENTO
								If CT3->CT3_DATA < dDataIni .or. CT3->CT3_DATA > mv_par01
									dbSkip()
									Loop
								EndIf
							Else								/// SE FOR RATEIO DE SALDO
								If CT3->CT3_DATA > mv_par01
									dbSkip()
									Loop
								EndIf								
							EndIf

       	
							If CT3->CT3_CONTA <> cConta 
								cConta := CT3->CT3_CONTA
								If lCT280FILP
									If !ExecBlock("CT280FILP",.f.,.f.,{"CT3"})
										dbSelectArea("CT3")
										dbSkip()
										Loop
									EndIf
								EndIf
								If (nPesos := Ascan(aPesos, { |x| x[3] == CT3->CT3_CUSTO+CT3->CT3_CONTA })) <= 0
									Aadd(aPesos, {	Array(Len(aCols)), CT3->(Recno()), CT3_CUSTO+CT3_CONTA, CT3->CT3_CONTA })
									nPesos := Len(aPesos)
								Endif
								For nXW := 1 To Len(aCols)
									If mv_par08 == 2 // Moeda especifica
										nXW := Val(mv_par09)
									Endif
									If Empty(aPesos[nPesos][1][nXW]) .and. aPesos[nPesos][1][nXW] <> 0
										aPesos[nPesos][1][nXW] := MovCusto(CT3->CT3_CONTA,CT3->CT3_CUSTO,dDataIni,mv_par01,aCols[nXW][1],mv_par10, nTipoPeso)
										aPesos[nPesos][1][nXW] := NoRound(aPesos[nPesos][1][nXW] * (CTQ->CTQ_PERBAS / 100),3)
										aSaldos[nXW][3] += aPesos[nPesos][1][nXW]
									Endif
									If mv_par08 == 2 // Moeda especifica
										Exit
									Endif
								Next
							Endif
												
							CT3->(dbSkip())
						Enddo
					Endif
				
					If mv_par08 == 2 // Moeda especifica
						Exit
					Endif
				Next
			
			Endif
			
			
			While CTQ->(!Eof()) .And. CTQ->CTQ_FILIAL == xFilial("CTQ") .And. CTQ->CTQ_RATEIO == cCtq_Rateio
				Aadd(aRateio, CTQ->(Recno()))
				DbSelectArea("CTQ")
				DbSkip()                     		
			Enddo
			
			nRecnoCtq := CTQ->(Recno())
			For nRateio := 1 To Len(aRateio)
				CTQ->(DbGoto(aRateio[nRateio]))
				If lCT280Hist		/// P.ENTRADA PARA ALTERAÇÃO DO HISTORICO
					cHistorico := ExecBlock("CT280HIST",.F.,.F.,{cHistorico})
		 			bHistorico := {||AllTrim(cHistorico)}					
				EndIf			

				If Len(aPesos) > 0				
					For nPesos := 1 To Len(aPesos)					
						Ct280GerRat(@lFirst, @nLinha, @cLinha, @cDoc, @CTF_LOCK, @cSeqLan,;
									bHistorico, lAtSldBase, aSaldos,;
									aPesos[nPesos][4],aPesos[nPesos][4],;
 									CTQ->CTQ_CCCPAR,CTQ->CTQ_CCPAR,CTQ->CTQ_ITCPAR,;
									CTQ->CTQ_ITPAR,CTQ->CTQ_CLCPAR,CTQ->CTQ_CLPAR,;
									nRateio = Len(aRateio) .And.;
									nPesos = Len(aPesos), aPesos[nPesos][1])
											
					Next
				Else
					cCTCPAR := CTQ->CTQ_CTCPAR
					If Empty(cCTCPAR)
						If !Empty(CTQ->CTQ_CTPAR)
							cCTCPAR := CTQ->CTQ_CTPAR
						ElseIf !Empty(CTQ->CTQ_CTORI)
							cCTCPAR := CTQ->CTQ_CTORI
						Else
							CTQ->(DbGoto(nRecnoCtq))						
							Loop
						EndIf								
					EndIf

					Ct280GerRat(@lFirst, @nLinha, @cLinha, @cDoc, @CTF_LOCK, @cSeqLan,;
								bHistorico, lAtSldBase, aSaldos,;
								cCTCPAR,CTQ->CTQ_CTPAR,;
		 						CTQ->CTQ_CCCPAR,CTQ->CTQ_CCPAR,CTQ->CTQ_ITCPAR,;
								CTQ->CTQ_ITPAR,CTQ->CTQ_CLCPAR,CTQ->CTQ_CLPAR,;
								nRateio = Len(aRateio))
				EndIf 
			Next
			CTQ->(DbGoto(nRecnoCtq))
		Else
			CTQ->(MsSeek(xFilial("CTQ")+Soma1(cCtq_Rateio),.T.))
		Endif	
	Enddo
	If CTF_LOCK > 0					/// LIBERA O REGISTRO NO CTF COM A NUMERCAO DO DOC FINAL
		dbSelectArea("CTF")
		dbGoTo(CTF_LOCK)
		CtbDestrava(mv_par01,mv_par02,mv_par03,cDoc,@CTF_LOCK)			
	Endif 	
Endif
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct280GerRat³ Autor ³ Wagner Mobile Costa  ³ Data ³ 13.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava o lancamento de rateio no CT2                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct280GerRat(lFirst, nLinha, cLinha, cDoc, CTF_LOCK, cSeqLan,³±±
±±³          ³            lUltimoLanc)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lFirst   = Indica se esta efetuando o 1o Lancto.           ³±±
±±³          ³ nLinha   = Numero da linha atual que esta sendo gerado     ³±±
±±³          ³ USADA PARA COMPARACAO COM O NUMERO MAXIMO DE LINHAS P/ DOC ³±±
±±³          ³ cLinha   = Numero da linha atual utilizada para gravacao   ³±±
±±³          ³ cDoc     = Numero do Documento utilizado para gravacao     ³±±
±±³          ³ CTF_LOCK = Lock de semaforo do documento                   ³±±
±±³          ³ cSeqLan  = Sequencia do lancamento atual                   ³±±
±±³          ³ bHistorico = Historico do lancamento de rateio             ³±±
±±³          ³ lAtSldBase = Indica se devera gerar saldos basicos (CT7 ..)³±±
±±³          ³ aSaldos  = Array com os saldos por moeda                   ³±±
±±³          ³ cCt1CPar = Conta a debito do rateio						  ³±±
±±³          ³ cCt1Par = Conta a credito do rateio						  ³±±
±±³          ³ cCttCPar = Centro de custo a debito do rateio			  ³±±
±±³          ³ cCttPar = Centro de custo a credito do rateio			  ³±±
±±³          ³ cCtdCPar = Item Contabil a debito do rateio			  	  ³±±
±±³          ³ cCtdPar = Item Contabil a credito do rateio			  	  ³±±
±±³          ³ cCthCPar = Classe Valor a debito do rateio			  	  ³±±
±±³          ³ cCthPar = Classe de Valor a credito do rateio			  ³±±
±±³          ³ lUltimoL = Indica se eh a geracao do ultimo lancto rateio  ³±±
±±³          ³ aPesos   = Array com os pesos para cada moeda              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ct280GerRat(lFirst, nLinha, cLinha, cDoc, CTF_LOCK, cSeqLan, bHistorico,;
					 lAtSldBase, aSaldos, cCt1CPar, cCt1Par, cCttCPar, cCttPar,;
					 cCtdCPar, cCtdPar, cCthCPar, cCthPar, lUltimoL, aPesos)
					 
Local nX	:= 0
Local nDif
Local nSaldo
Local nValorLanc
Local lSequen := .T.
Local cGrvM1 := "3"				/// SE DEVE GRAVAR O LANCAMENTO NA MOEDA 1 (P/ PROC. ESPECIFICO) 0=Nao / 1=Vlr < 0 / 2=Vlr > 0
Local nVlrMX := 0
Local lPodeGrv := .F.		
Private cSeqCorr  := ""

While !lPodeGrv
	//Chamar a multlock	
	aTravas := {}
	IF !Empty(cCT1PAR)
	   AADD(aTravas,cCT1PAR)
	Endif
	IF !Empty(cCT1CPAR)
	   AADD(aTravas,cCT1CPAR)
	Endif
	//Chamar a multlock	
   	IF MultLock("CT1",aTravas,1)    
		lPodeGrv := .T.
	Else
		lPodeGrv := .F.
	Endif
    
    If lPodeGrv 
		BEGIN TRANSACTION
	  	If lFirst .Or. nLinha > MAX_LINHA
			Do While !ProxDoc(mv_par01,mv_par02,mv_par03,@cDoc,@CTF_LOCK)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso o N§ do Doc estourou, incrementa o lote         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cLote := strzero(Val(cLote)+1,6)
				DbSelectArea("SX5")
				MsSeek(xFilial("SX5")+"09"+If(cModulo=="CTB","CON",cModulo))
				RecLock("SX5")
				SX5->X5_DESCRI := Substr(cLote,3,4)
				MsUnlock()
			Enddo
			lFirst := .F.
			cLinha := "000"
			nLinha := 0
			cSeqLan:= "000"
		Endif		   	  			
		    
		For nX := 1 To Len(aCols)
			If (mv_par08 == 2 .And. nX <> Val(mv_par09)) .And. nX <> 1
				Loop
			Endif
			If (nSaldo := aSaldos[nX][3]) = 0 .And. nX <> 1
				Loop                                 			
			Endif
			nValorLanc := NoRound(nSaldo*(CTQ->CTQ_PERCEN/100), 3)
			
			If aPesos # Nil .and. aPesos[nX] # Nil		   		
	 	    	nValorLanc *= ABS(aPesos[nX]) / ABS(aSaldos[nX][3])
	 	   	Endif  
	
			nValorLanc := Round(nValorLanc,2)
		                        
			If aPesos <> Nil .and. aPesos[nX] <> Nil
				If ( aPesos[nX] < 0 .and. nValorLanc > 0 ) .or. (aPesos[nX] > 0 .and. nValorLanc < 0)
					nValorLanc *= -1
				EndIf
			Else
				If (nSaldo < 0 .and. nValorLanc > 0) .or. (nSaldo > 0 .and. nValorLanc < 0)
					nValorLanc *= -1			
				EndIf
			EndIf		
	
			// Calcula a diferenca de rateio e ajusta o valor do lancamento
			aCols[nX][Len(aCols[nX])] += nValorLanc // Valor Lancamento
	  		If lUltimoL
				nDif := nSaldo-aCols[nX][Len(aCols[nX])]
	  			If nDif < 0
	 	  			If nDif < nValorLanc						  /// SO RETIRA SE A DIFERENCA FOR MENOR QUE O VALOR DO LANC.
		 	  			nValorLanc -= ABS(nDif)                   /// PARA NAO GERAR LANC. COM VLR NEGATIVO
		 	  		Endif										  /// CASO CONTRARIO NAO EFETUA AJUSTE DA DIFERENCA
				Else
					nValorLanc += nDif
				Endif 			
			EndIf
	 		
	
	  		aCols[nX][3] := nValorLanc // Valor Lancamento
			// Saldo origem negativo, lanca a credito na conta partida e outro
	  		// a debito na conta rateada (contra partida)
			If (nSaldo <> 0 .and. nValorLanc <> 0) .or. (nX == 1 .and. mv_par08 == 2 .and. mv_par09 <> "01")
				If (nX == 1 .and. mv_par08 == 2 .and. mv_par09 <> "01")/// SE FOR MOEDA ESPECIFICA DIFERENTE DE MOEDA 01
	                
					nMoedaPar := val(mv_par09)
	
					nVlrMX := NoRound(aSaldos[nMoedaPar][3]*(CTQ->CTQ_PERCEN/100), 3)
	
					If aPesos # Nil .and. aPesos[nMoedaPar] # Nil		   		
						nVlrMX *=  ABS(aPesos[nMoedaPar]) / ABS(aSaldos[nMoedaPar][3])
					Endif
	
					nVlrMX := Round(nVlrMX,2)
					
					If aPesos <> Nil .and. aPesos[nMoedaPar] <> Nil
						If ( aPesos[nMoedaPar] < 0 .and. nVlrMX > 0 ) .or. (aPesos[nMoedaPar] > 0 .and. nVlrMX < 0)
							nVlrMX *= -1
						EndIf
					Else
						If (aSaldos[nMoedaPar][3] < 0 .and. nVlrMX > 0) .or. (aSaldos[nMoedaPar][3] > 0 .and. nVlrMX < 0)
							nVlrMX *= -1			
						EndIf
					EndIf		
	
					If nVlrMX < 0
						cGrvM1 := "1"	 /// SO GRAVA NA MOEDA 1 SE HOUVER SALDO NA MOEDA ESPECIFICA
					ElseIf nVlrMX > 0
						cGrvM1 := "2"	 /// SO GRAVA NA MOEDA 1 SE HOUVER SALDO NA MOEDA ESPECIFICA
					Else
						cGrvM1 := "0"	 /// CASO CONTRARIO NAO IRA GRAVAR O LANCAMENTO
					EndIf
				Else
					cGrvM1 := "3"	 /// POR DEFAULT DEVE GRAVAR O LANCAMENTO			
				Endif
				If cGrvM1 <> "0"                      
					If lSequen 
						cSeqLan := Soma1(cSeqLan)
						cLinha 	:= Soma1(cLinha)
						nLinha++
						lSequen := .F.
					EndIf
		  			aCols[nX][3] := ABS(aCols[nX][3])
					If cPaisLoc == 'CHI' .and. Val(cLinha) < 2  // a partir da segunda linha do lanc., o correlativo eh o mesmo
						cSeqCorr := CTBSqCor( CTBSubToPad(cSubLote) )
					EndIf
					If nValorLanc < 0 .or. cGrvM1 == "1"
			  			GravaLanc(	mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3",aCols[nX][1],;
	  								mv_par05,cCt1CPar, cCt1Par, cCttCPar, cCttPar,;
								 	cCtdCPar, cCtdPar, cCthCPar, cCthPar,;
	  							 	ABS(nValorLanc),Eval(bHistorico),mv_par10,cSeqLan,3,lAtSldBase,;
	  							 	aCols,cEmpAnt,cFilAnt,0)
			  		ElseIf nValorLanc > 0 .or. cGrvM1 == "2"
						GravaLanc(	mv_par01,mv_par02,mv_par03,cDoc,cLinha,"3",aCols[nX][1],;
									mv_par05,cCt1Par, cCt1CPar, cCttPar, cCttCPar,;
								 	cCtdPar, cCtdCPar, cCthPar, cCthCPar, nValorLanc,Eval(bHistorico),;
	  							 	mv_par10,cSeqLan,3,lAtSldBase,aCols,cEmpAnt,cFilAnt,0)
	 				Endif
					CtbGravSaldo(	CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,;                      							
									CT2->CT2_DATA,CT2->CT2_DC,CT2->CT2_MOEDLC,;
									CT2->CT2_DEBITO,CT2->CT2_CREDITO,;
									CT2->CT2_CCD,CT2->CT2_CCC,CT2->CT2_ITEMD,CT2->CT2_ITEMC,;
									CT2->CT2_CLVLDB,CT2->CT2_CLVLCR,ABS(nValorLanc),;
									CT2->CT2_TPSALD,3,"","","","","","","","",0," ",;
									" ", "  ", __lCusto,__lItem,__lClVL, Abs(nSaldo))
					EndIf
	 		Endif
		Next 
		END TRANSACTION
	EndIF
EndDo

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AcertaSXD ³ Autor ³ Simone Mie Sato	 	³ Data ³ 04/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria registro no Arq. SXD para execucao do Schedule   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³SIGACTB													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AcertaSXD(lAuto)
Local aArea	:= GetArea()

If !lAuto
	SXD->(DbSetOrder(1))
	If !SXD->(DbSeek("CTBA280"))
		DbSelectArea("SXD")
  		RecLock("SXD",.T.)
		Replace XD_TIPO 	with "P"
		Replace XD_FUNCAO 	with "CTBA280"
		Replace XD_PERGUNT 	with "CTB280"
		Replace XD_PROPRI 	with "S"
		Replace XD_TITBRZ 	with "Rateios Off-Line"
		Replace XD_TITSPA 	with "Prorrateos Off-Line"
		Replace XD_TITENG 	with "Off-Line Proration"
		Replace XD_DESCBRZ 	with "Rateios Off-Line"
		Replace XD_DESCSPA 	with "Prorrateos Off-Line"
		Replace XD_DESCENG 	with "Off-Line Proration"
		MsUnLock()
	EndIf	
EndIf
RestArea(aArea)								
Return