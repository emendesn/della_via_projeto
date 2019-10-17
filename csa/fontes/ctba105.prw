#INCLUDE "CTBA105.CH"
#INCLUDE "FONT.CH"
#INCLUDE "PROTHEUS.CH"

Static __aMedias[99]
Static aMVS[6]
Static MAX_LINHA
Static lEXELOTECTB := ExistBlock("LOTECTB")

#DEFINE MV_ALTLCTO		1
#DEFINE MV_SUBLOTE		2
#DEFINE MV_PRELAN		3
#DEFINE MV_CONTSB		4
#DEFINE MV_CONTBAT		5
#DEFINE MV_SOMA    		6

#DEFINE D_PRELAN		"9"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB_Incl  ³ Autor ³ Pilar S Albaladejo    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Programa de inclus„o de Lan‡amentos Cont beis.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1:=CTB105Incl(ExpC1,ExpN1,ExpN2,ExpC2,ExpL1,ExpL2)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Nome do arquivo                                    ³±±
±±³          ³ ExpN1 = Numero do Header                                   ³±±
±±³          ³ ExpN2 = Numero da Opcao escolhida                          ³±±
±±³          ³ ExpC2 = Numero do Lote                                     ³±±
±±³          ³ ExpL1 = Se Mostra ou nao                                   ³±±
±±³          ³ ExpL2 = Se Aglutina ou nao                                 ³±±
±±³          ³ ExpC3 = Determina se sera On Line ou pelo cProva           ³±±
±±³          ³ dData = Data para geracao dos lancamentos contabeis        ³±±
±±³          ³ dReproc = Parametro que indica que lancamentos nao atualiza³±±
±±³          ³           saldos e apos gravacao executa reprocessamento   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function CTB_Incl( 	cArquivo, nHdlPrv, nOpcx, cLoteContabil, lDigita, lAglut, cOnLine,;
					dData, dReproc )

Local aSaveArea	:= GetArea()
Local aCampos		:= {}

Local nOpca			:= 0
Local nArqAbre		:= 1

Local cArqAbre		:= "CT0"
Local CTF_LOCK		:= 0
Local cCadastro 	:= OemToAnsi(STR0001)				// Lancamentos Contabeis
Local cArq1
Local cArq2
Local cEmpOri		:= cEmpAnt
Local cFilOri		:= cFilAnt

Local oDlg
Local oLote
Local oSubLote, lSubLote
Local oDoc
Local oFnt

Local lCt105TOK		:= IIf(ExistBlock("CT105TOK"),.T.,.F.)
Local lCt105CHK		:= Iif(ExistBlock("CT105CHK"),.T.,.F.)
Local lAntCtbGrv	:= Iif(ExistBlock("ANTCTBGRV"),.T.,.F.)
Local lDepCtbGrv	:= Iif(ExistBlock("DEPCTBGRV"),.T.,.F.)
Local lAltDataL		:= Iif(ExistBlock("ALTDATAL"),.T.,.F.)
Local lFirst		:= .T.
Local lRpc			:= Type("oMainWnd") = "U"		// Chamada via Rpc nao tem tela
Local lRpcOk		:= .T.
Local nLin  		:= 0                                          
Local nRecCTK 		:= 0
Local cAliasCTK		:= "CTK"
      
// Variaveis para guardar eventuais funcoes ja atruibuidas às teclas F4 F5 F6 e F7 em outros modulos, para serem
// restauradas no final.
Local bVK_4
Local bVK_5
Local bVK_6
Local bVK_7

Local aPosCol       := {}
Local cPreLcto		:= ""
Local cRotina		:= FunName()
Local cProgName		:= ""
Local aButton 	:= {}
Local cLoteEXEC		:= ""
Local cExpFil		:= ""
Local cTxtfil		:= "" 

Local cDbsExt		:= GetDBExtension()
Local cIndExt		:= OrdBagExt()
#IFDEF TOP
	Local aStruCTK 	:= {}
	Local aStruQry		:= {}
	Local cTypDB		:= UPPER(TcGetDB())
	Local lAglByHist	:= GetNewPar("MV_AGLHIST",.F.)
	Local lOrdEnt		:= If(GetNewPar("MV_ORDLCTB","L")=="E",.T.,.F.)			/// MV_ORDLCTB : L= LP (sequen+lp)/ E = Entrada (Recno)	
	Local nMoedas		:= 0
	Local nPosQry		:= 0
	Local nY
	Local lCt105Qry		:= Iif(ExistBlock("CT105QRY"),.T.,.F.)	
#ENDIF	

Local lOrdTpSld		:= If(GetNewPar("MV_ORDLCTB","L")=="T",.T.,.F.)			/// MV_ORDLCTB : T= Tipo de Saldo
Local cSrvType		:= TcSrvType()
Local lTemIDX   	:= .F.
Local nOrdTpSld 	:= 1

Private aTELA		:= {}
Private aGETS		:= {}
Private aHeader	:= {}
Private aCols	:= Nil
Private aAltera	:= {}
Private aRotina :=	{	{ "aRotina Falso", "AxPesq",		0, 1 },;
{ "aRotina Falso", "AxVisual",	0, 2 },;
{ "aRotina Falso", "AxInclui",	0, 3 },;
{ "aRotina Falso", "AxAltera",	0, 4 }}

Private __lCusto:= .F.
Private __lItem := .F.
Private __lCLVL	:= .F.

Private dDataLanc	:= Iif(dData == Nil,dDataBase,dData)
Private nTotInf	:= 0
Private aTotRdpe := {{0,0,0,0},{0,0,0,0}}
Private nUsado		:= 0
Private nSaida		:= 0

Private oDig
Private oDeb
Private oCred
Private oInf
Private oDescEnt

Private cLote			:= cLoteContabil, cSubLote
Private cDoc			:= Space(6)

Private cSeqCorr        := Space(10)
Private cSeqCrAnt       := Space(10)

Private aColsP		:= {}
Private oGetDb	

// Carrego os MVS

If aMVS[MV_ALTLCTO] = Nil
	aMVS[MV_ALTLCTO] := GetMv("MV_ALTLCTO") == "S"
Endif

If aMVS[MV_SUBLOTE] = Nil
	aMVS[MV_SUBLOTE] := GetMv("MV_SUBLOTE")
Endif

If aMvs[MV_PRELAN] = Nil
	aMvs[MV_PRELAN] := GetMv("MV_PRELAN")
Endif

If MAX_LINHA = Nil
	MAX_LINHA := { GetMv("MV_NUMLIN"), GetMv("MV_NUMMAN") }
Endif           

//Alterar o conteudo da variavel dDataLanc, caso exista o ponto de entrada
If lAltDataL .and. !lOrdTpSld
	dDataLanc	:= 	ExecBlock("ALTDATAL",.F.,.F.,{dData,cRotina})
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a numeracao do lote foi alterada pelo PE LOTECTB³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lEXELOTECTB       		/// PONTO DE ENTRADA PARA ALTERAÇÃO NO NUMERO DO LOTE CTB.
	cLoteEXEC := EXECBLOCK("LOTECTB",.F.,.F.,{cLote})
	If ValType(cLoteEXEC) == "C" .and. !Empty(cLoteEXEC)
		cLoteContabil := cLoteEXEC
	EndIf
EndIf

cSubLote	:= aMVS[MV_SUBLOTE]
lSubLote 	:= Empty(cSubLote)
nOpc		:= 4
cLote 		:= Iif(Len(Alltrim(cLoteContabil)) < 6,;
					PADL(ALLTRIM(cLotecontabil),6,"0"),cLoteContabil)

#IFNDEF TOP
	If lOrdTpSld
		dbSelectArea("SIX")
		dbSeek("CTK")
		While !Eof() .and. SIX->INDICE == "CTK"
			//// VALIDAR SE EXISTE INDICE SEQUEN+TPSALDO NO CTK
			If ALLTRIM(SIX->NICKNAME) == "CTKTPSLD"
				lTemIDX := .T.
				If SIX->ORDEM > "9"
					nOrdTpSld := Asc(SIX->ORDEM)-55   /// asc("A") = 65 - 55 = ordem 10 / asc("B") = 66 - 55 = ordem 11
				Else
					nOrdTpSld := VAL(SIX->ORDEM)
				EndIf
			EndIf
			dbSkip()				
		EndDo
		If !lTemIDX
			lOrdTpSld := .F. /// VOLTA COMO SE FOSSE CONTABILIZAÇÃO NORMAL (QUEBRA DEFAULT)
			MsgInfo("No index nickname CTKTPSLD on table CTK","Create Index ! (CTK_SEQUEN+CTK_TPSALD) ")
		EndIf
	EndIf
#ELSE
	If cSrvType ="AS/400" 
	If lOrdTpSld
		dbSelectArea("SIX")
		dbSeek("CTK")
		While !Eof() .and. SIX->INDICE == "CTK"
			//// VALIDAR SE EXISTE INDICE SEQUEN+TPSALDO NO CTK
			If ALLTRIM(SIX->NICKNAME) == "CTKTPSLD"
				lTemIDX := .T.
				If SIX->ORDEM > "9"
					nOrdTpSld := Asc(SIX->ORDEM)-55   /// asc("A") = 65 - 55 = ordem 10 / asc("B") = 66 - 55 = ordem 11
				Else
					nOrdTpSld := VAL(SIX->ORDEM)
				EndIf
			EndIf
			dbSkip()				
		EndDo
		If !lTemIDX
			lOrdTpSld := .F. /// VOLTA COMO SE FOSSE CONTABILIZAÇÃO NORMAL (QUEBRA DEFAULT)
			MsgInfo("No index nickname CTKTPSLD on table CTK","Create Index ! (CTK_SEQUEN+CTK_TPSALD) ")
		EndIf
	EndIf
	EndIf
#ENDIF

// Calcula medias para conversao de moedas
CtbMedias(dDataLanc)

__lCusto 	:= CtbMovSaldo("CTT")
__lItem		:= CtbMovSaldo("CTD")
__lCLVL		:= CtbMovSaldo("CTH")

If nHdlPrv == 65536	.and. GetHProva() == 1024
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso houve abertura por HeadProva() ( nHdlPrv == 65536 )     ³
	//³ e houve lan‡amento cont bil (Handle Interno == 1024)         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSeqChave:= GetHFile()  // Retorna a chave dos dados gravados no CTK
Else
	RestArea(aSaveArea)
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ AQUI! Abre os Arquivos do CTB em outros m¢dulos              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nArqAbre :=1 to 20 // Arquivos CT1 a CTK
	cArqAbre := soma1(cArqAbre)
	ChkFile(cArqAbre)
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CT2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader para Lan‡amentos Cont beis                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := Ctb105Head(@aAltera)
Ctb105Cria(aCampos,@cArq1,@cArq2)

DbSelectArea( "CTK" )
DbSetOrder( 1 )

#IFDEF TOP
	If cSrvType <> "AS/400"
		CTK->(DbCommit())		// Garanto que os registros estejam no BANCO
		
		aStruCTK	:= CTK->(dbStruct())
		cAliasCTK	:= "QUERYCTK"
				
		cQuery := ""
		If lAglut
			cQuery += "	CTK_FILIAL,CTK_SEQUEN,CTK_DC,CTK_DEBITO,CTK_CREDIT,CTK_CCD,CTK_CCC,CTK_ITEMD,CTK_ITEMC, "
			cQuery +=" CTK_CLVLDB,CTK_CLVLCR,CTK_TPSALD,CTK_DATA, "		
			If lAglByHist
				cQuery += " CTK_HIST, "		
			Endif
			For nMoedas	:= 1 to __nQuantas
				cQuery += "SUM(CTK_VLR"+StrZero(nMoedas,2)+") CTK_VLR" + StrZero(nMoedas,2)
				If nMoedas < __nQuantas
					cQuery += ", "					
				EndIf
			Next			
			If !cTypDB$"MSSQL/MSSQL7/MYSQL"				//// SE NÃO FOR SQL OU MSSQL7
  				cQuery +=", MAX(CTK_LP||CTK_LPSEQ) CTKLPLPSEQ "		
			Else									//// SE FOR SQL
				If cTypDB=="MYSQL"
					cQuery +=", MAX(CONCAT(CTK_LP,CTK_LPSEQ)) CTKLPLPSEQ "
				Else
					cQuery +=", MAX(CTK_LP+CTK_LPSEQ) CTKLPLPSEQ "					
				EndIf
			Endif
			cQuery +=", MIN(CTK_ORIGEM) CTK_ORIGEM "		
			cQuery +=", MIN(R_E_C_N_O_) CTKMINRECNO "		
			cQuery +=", MIN(CTK_ROTINA) CTK_ROTINA "					
			cQuery +=", MIN(CTK_KEY) CTK_KEY "
			cQuery +=", MIN(CTK_ATIVDE) CTK_ATIVDE "
			cQuery +=", MIN(CTK_ATIVCR) CTK_ATIVCR " 
			If CTK->(FieldPos("CTK_DTVENC")) > 0 .and. CT2->(FieldPos("CT2_DTVENC")) > 0
				cQuery +=", MIN(CTK_DTVENC) CTK_DTVENC " 
			EndIf
		Else            
			For nY := 1 To Len(aStruCTK)
				cQuery += ","+aStruCTK[nY][1]
			Next nY                                               
		EndIf                        
		cQuery := "SELECT "+SubStr(cQuery,2)+" "
		cQuery += "FROM "+RetSqlName("CTK")+" CTK "
	
		cQuery += "WHERE CTK.CTK_FILIAL='"+xFilial("CTK")+"' AND "
		cQuery += "CTK.CTK_SEQUEN='"+cSeqChave+"' AND "
		cQuery += "CTK.D_E_L_E_T_=' ' "
		If lAglut
			cQuery += "GROUP BY CTK_FILIAL,CTK_SEQUEN,CTK_DC,CTK_DEBITO,CTK_CREDIT,CTK_CCD,CTK_CCC,CTK_ITEMD,CTK_ITEMC,CTK_CLVLDB,CTK_CLVLCR,CTK_TPSALD,CTK_DATA "
			If lAglByHist
				cQuery += " , CTK_HIST "		
			Endif
			cQuery += "ORDER BY  "
			If 	lOrdTpSld	/// MV_ORDLCTB : T= Tipo de Saldo
				cQuery += " CTK_TPSALD,"
			EndIf
			cQuery += "CTKMINRECNO " /// ORDEM DE RECNO DEVIDO À SEQUENCIA DOS LANÇAMENTOS bops: 64512			
		Else
			If lOrdEnt
				cQuery += "ORDER BY R_E_C_N_O_"  //"+SqlOrder(CTK->(IndexKey())) /// ORDEM DE RECNO DEVIDO À SEQUENCIA DOS LANÇAMENTOS bops: 64512
			Else
				cQuery += "ORDER BY "
				If 	lOrdTpSld	/// MV_ORDLCTB : T= Tipo de Saldo
					cQuery += " CTK_TPSALD,"
				EndIf
				cQuery += SqlOrder(CTK->(IndexKey())) /// ORDEM DE RECNO DEVIDO À SEQUENCIA DOS LANÇAMENTOS bops: 64512			
			Endif
		EndIf

        If lCt105Qry 
			cQuery 	:= 	ExecBlock("CT105QRY",.F.,.F.,{cQuery,lAglut})                
        EndIf        
        
		cQuery := ChangeQuery(cQuery)	
		
		If ( Select ( cAliasCTK ) <> 0 )
			dbSelectArea ( cAliasCTK )
			dbCloseArea ()
		Endif		
                     
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCTK,.T.,.T.)
		aStruQry	:= &(cAliasCTK)->(dbStruct())		
 		
 		For nY := 1 To Len(aStruCTK)
 			If aStruCTK[nY][2] <> "C" 
				//Verificar se o campo existe na query antes do TcSetField
 				nPosQry	:= aScan(aStruQry,{|x|(x[1])==Trim(aStruCTK[nY][1])})
				If nPosQry > 0 				
					TcSetField(cAliasCTK,aStruCTK[nY][1],aStruCTK[nY][2],aStruCTK[nY][3],aStruCTK[nY][4])
				EndIf
		    EndIf
 		Next nY
	Else
#ENDIF
	MsSeek( xFilial() + cSeqChave )
	If lOrdTpSld	/// MV_ORDLCTB : T= Tipo de Saldo
		cTpSld1 := (cAliasCTK)->CTK_TPSALD		
		dbSetOrder(nOrdTpSld)
		MsSeek( xFilial("CTK") + cSeqChave + cTpSld1 )		
	Endif
#IfDEF TOP
	Endif
#ENDIF

cProgName := (cAliasCTK)->CTK_ROTINA
If Empty(cProgName)
	cProgName := FunName()
Endif

bVK_4 := SetKey(VK_F4)
bVK_5 := SetKey(VK_F5)
bVK_6 := SetKey(VK_F6)
bVK_7 := SetKey(VK_F7)
			
Aadd( aButton, {"SIMULACAO",{ || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc)} , STR0015+" - <F5>",STR0016 } ) //"Totais do lote e documento (outras moedas)" "Totais"			
Aadd( aButton, {"PREV"     ,{ || CTB105Flt (oGetDb,.F.              ) },STR0019 } ) //"Inconsistencia Anterior"
Aadd( aButton, {"NEXT"     ,{ || CTB105Flt (oGetDb,.T.              ) },STR0020 } ) //"Proxima Inconsistencia"
Aadd( aButton, {"BMPSXB"   ,{ || CTB105FtBs(oGetDb,@cExpFil,@cTxtFil) },STR0021 } ) //"Localizar"

While (cAliasCTK)->(Ctb105Grv(	cSeqChave,lAglut,aCampos,dDataLanc,@cSubLote,@nLin,@nRecCTK, cAliasCTK))
	
	If TMP->(RecCount()) == 0
		RestArea(aSaveArea)			
		Return
	EndIf
	
	If lFirst .Or. nLin > MAX_LINHA[1]
		If CTF_LOCK > 0					/// LIBERA O REGISTRO NO CTF COM A NUMERCAO DO DOC (DEPOIS DE GRAVAR O PRIMEIRO DOC)
			dbSelectArea("CTF")
			dbGoTo(CTF_LOCK)
			CtbDestrava(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK)			
		Endif

		If lAltDataL .and. lOrdTpSld
			dDataLanc	:= 	ExecBlock("ALTDATAL",.F.,.F.,{dData,cRotina})
		EndIf

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
		lFirst := .F.  
	Endif
	
	__PreLan 	:= .F.		// Indica se tenta gravar como pre-lancamento
	
	If !lDigita										// Se altera lancamento -> visualiza!!
		If lRpc
			//Ponto de entrada criado com a funcao de alterar a filial para gravacao dos saldos e lancamentos contabeis. 
			//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
			//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
			//posteriormente. 		
			If lAntCtbGrv
				ExecBlock("ANTCTBGRV",.F.,.F.)
			Endif		                                                     
			                                               
			//Validacao 
			lRpcOk	:= CTB105Rpc(lDigita)			          
			
			If lRpcOk
				lRpcOk := Ct105TOK(lCT105TOK,lCT105CHK,.F., .F.,aTotRdpe,nTotInf)
			EndIf				
			If !lRpcOk .Or. __Prelan == .T.
				cPreLcto	:= "S"
			Else
				cPreLcto	:= "N"
			EndIf
					
			CTBGrava(3,dDatalanc,cLote,cSubLote,cDoc,lAglut,cSeqChave,;
							__lCusto,__lItem,__lCLVL,,cProgName,cPreLcto,dReproc,cEmpOri,cFilOri)					

			//Ponto de entrada criado com a funcao de voltar a filial apos a gravacao dos saldos e lancamentos contabeis. 
			//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
			//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
			//posteriormente. 
			If lDepCtbGrv
				ExecBlock("DEPCTBGRV",.F.,.F.)
			Endif		                                                     									
							
		Else					
			If aMvs[MV_ALTLCTO] .And. !(Ct105TOK(lCT105TOK,lCT105CHK,.F., .F.,aTotRdpe,nTotInf))
				lDigita := .T.
			Else
				If !CtbValiDt(nOpc,dDataLanc)//Se nao tem uma data valida
					lDigita	:= .T. //Mostra lancamento contabil				
	        	Else         
	        	                                                
					//Ponto de entrada criado com a funcao de alterar a filial para gravacao dos saldos e lancamentos contabeis. 
					//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
					//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
					//posteriormente. 		
					If lAntCtbGrv
						ExecBlock("ANTCTBGRV",.F.,.F.)
					Endif		                                                     	        	

					//Validacao 
					lRpcOk	:= CTB105Rpc(lDigita)			          
			
					If lRpcOk
						lRpcOk := Ct105TOK(lCT105TOK,lCT105CHK,.F., .F.,aTotRdpe,nTotInf)
					EndIf			
					If !lRpcOk  .Or. __Prelan == .T.
						cPreLcto	:= "S"
					Else
						cPreLcto	:= "N"
					EndIf					
					                                                       		
					CTBGrava(3,dDatalanc,cLote,cSubLote,cDoc,lAglut,cSeqChave,;
							__lCusto,__lItem,__lCLVL,,cProgName,cPreLcto,dReproc,cEmpOri,cFilOri)					
							
					//Ponto de entrada criado com a funcao de voltar a filial apos a gravacao dos saldos e lancamentos contabeis. 
					//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
					//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
					//posteriormente. 
					If lDepCtbGrv
						ExecBlock("DEPCTBGRV",.F.,.F.)
					Endif		                                                     											
							
					//Dar ZAP no arquivo temporario para nao trazer residuos do documento anterior							
					//dbSelectArea("TMP")
					//Zap
					If TMP->(RecCount()) > 0
						TMP->(DbCloseArea())
						FErase( cArq1+cDBSExt )
						Ferase( cArq1+cIndExt )
						Ferase( cArq2+cIndExt )
						cArq1 := ""
						cArq2 := ""
						Ctb105Cria(aCampos,@cArq1,@cArq2)				
					EndIf
				Endif
			EndIf
		EndIf
	Endif
	
	If lDigita
		
		If cPaisLoc == 'CHI'
			aPosCol := {00.8,03,10,12,16,19,23,25,30,34}
		Else
			aPosCol := {00.8,03,11,14,21,25,32,34}
		EndIf

		nOpca 		:= 0
		__PreLan 	:= .F.		// Indica se tenta gravar como pre-lancamento
		While nOpca == 0

			If Type("oMainWnd") = "U"
			
				//Ponto de entrada criado com a funcao de alterar a filial para gravacao dos saldos e lancamentos contabeis. 
				//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
				//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
				//posteriormente. 		
				If lAntCtbGrv
					ExecBlock("ANTCTBGRV",.F.,.F.)
				Endif		                                                     
				
				CTBGrava(3,dDatalanc,cLote,cSubLote,cDoc,lAglut,cSeqChave,;
				__lCusto,__lItem,__lCLVL, nTotInf,cProgName, If(__PreLan, aMvs[MV_PRELAN],),;
				dReproc,cEmpOri,cFilOri)

				//Ponto de entrada criado com a funcao de voltar a filial apos a gravacao dos saldos e lancamentos contabeis. 
				//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
				//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
				//posteriormente. 
				If lDepCtbGrv
					ExecBlock("DEPCTBGRV",.F.,.F.)
				Endif		                                                     									
				
				Exit
			Endif
				
			DEFINE MSDIALOG oDlg TITLE cCadastro From 9,0 To 29,80 OF oMainWnd
			
			DEFINE FONT oFnt 	NAME "Courier New" 	SIZE 0,14
			
			@ 01.4,aPosCol[1] 	Say OemToAnsi(STR0002)					//"Data"
			@ 01.4,aPosCol[3]  	Say OemToAnsi(STR0003)					//"Lote"
			@ 01.4,aPosCol[5]  	Say OemToAnsi(STR0013)					//"Sub-Lote"
			@ 01.4,aPosCol[7]	Say OemToAnsi(STR0004)					//"Docto"
			If cPaisLoc = "CHI"
				@ 01.4,aPosCol[9]	Say OemToAnsi(STR0014)			//"Correlativo"
			EndIf
			
			@ 01.4,aPosCol[2]   MSGET dDataLanc  Picture "99/99/9999" 	When aMvs[MV_ALTLCTO];
			Valid (NaoVazio(dDataLanc) .and. ;
			C050Next(dDataLanc,@cLote,@cSubLote,@cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,3,2)).And.CtbValiDt(nOpc,dDataLanc) .And.;
			Ct105AtRdp(dDataLanc,cLote,cSubLote,cDoc,@aTotais,@aTotRdPe);
			SIZE 50, 11 OF oDlg
			
			@ 01.4,aPosCol[4]	MSGET oLote VAR cLote Picture "@!" 	When aMvs[MV_ALTLCTO];
			Valid NaoVazio(cLote) .and.;
			C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK) .And.;
			Ctb101Lote(dDataLanc,cLote,cSubLote,@cDoc,;
			oDoc,@CTF_LOCK) .And.;
			Ct105AtRdp(dDataLanc,cLote,cSubLote,cDoc,@aTotais,@aTotRdPe);
			SIZE 32, 11 OF oDlg
			
			@ 01.4,aPosCol[6] 	MSGET oSubLote VAR cSubLote Picture "!!!" ;
			WHEN If( cPaisLoc <> "CHI", aMvs[MV_ALTLCTO] .And. lSubLote, .F.) F3 "SB";
			VALID NaoVazio(cSubLote) .and.;
			C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK) .And.;
			Ctb101Lote(dDataLanc,cLote,cSubLote,@cDoc,;
			oDoc,@CTF_LOCK) .And.;
			Ct105AtRdp(dDataLanc,cLote,cSubLote,cDoc,@aTotais,@aTotRdPe);
			SIZE 32, 11 OF oDlg
			
			@ 01.4,aPosCol[8]	MSGET oDoc VAR cDoc Picture "999999" When aMvs[MV_ALTLCTO];
			Valid NaoVazio(cDoc) .and.;
			Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,@CTF_LOCK,3) .And. ;
			Ct102GrCTF(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK) .And.;
			Ct105AtRdp(dDataLanc,cLote,cSubLote,cDoc,@aTotais,@aTotRdPe);
			SIZE 34, 11 OF oDlg
			If cPaisLoc == 'CHI'			
				@ 01.4,aPosCol[10]	MSGET oDoc VAR cSeqCorr Picture "9999999999";
				When .F. SIZE 34, 11 OF oDlg
			EndIf	
			
			aTotMov		:= CtbTotMov()
			aTotais     := Ctb050Tot(dDataLanc,cLote,cSubLote,cDoc)

			//Contem os saldos do CT6 + Conteudo da Tela
			aTotRdPe[1][2] := aTotais[1][2] + aTotMov[1][2]
			aTotRdPe[1][3] := aTotais[1][3] + aTotMov[1][3]
			aTotRdPe[1][1] := aTotais[1][1] + aTotMov[1][1]
			
			//Contem somente o que esta na GETDB.
			aTotRdPe[2][2] := aTotMov[1][2]
			aTotRdPe[2][3] := aTotMov[1][3]
			aTotRdPe[2][1] := aTotMov[1][1]
			
			nTotInf		:= aTotais[1][4]
			
			@120 ,7			SAY OemToAnsi(STR0012)PIXEL 			//"Descri‡„o da Entidade"
			@120 ,80		SAY oDescEnt PROMPT space(50) FONT oDlg:oFont PIXEL COLOR CLR_HBLUE
			@10  ,00.8		Say OemToAnsi(STR0006)  				//"Total Informado :"
			@10.6,00.8		SAY OemToAnsi(STR0007)  				//"Total Digitado  :"
			@10  ,07		Say oInf 	VAR nTotInf  Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
			@10.6,07		Say oDig 	VAR aTotRdPe[1][1]  Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
			@10  ,23		Say OemToAnsi(STR0008)  				//"Total Debito  :"
			@10.6,23		SAY OemToAnsi(STR0009)  				//"Total Credito :"
			@10  ,30		Say oDeb 	VAR aTotRdPe[1][2] Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
			@10.6,30		Say oCred 	VAR aTotRdPe[1][3] Picture "@E 999,999,999,999.99" FONT oFnt COLOR CLR_HBLUE
			
			TMP->(dbSetOrder(0))

			Ctb102TamHist()	                                                        
			
			SetKey(VK_F4, { || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc) })		
			SetKey(VK_F5, { || CTB105Flt (oGetDb,.F.                   ) })
			SetKey(VK_F6, { || CTB105Flt (oGetDb,.T.                   ) })
			SetKey(VK_F7, { || CTB105FtBs(oGetDb,@cExpFil,@cTxtFil     ) })
			
			If aMvs[MV_ALTLCTO]
				oGetDB := MSGetDB():New( 034, 005, 120, 315, 4,;
				"CT105LINOK", "CT105TOk", "+CT2_LINHA",;
				.t.,aAltera,,.t., MAX_LINHA[2],"TMP",,,,,,,"CT102DEL(nOpc)")
			Else
				oGetDB := MSGetDB():New( 034, 005, 120, 315, 2,;
				"AlwaysTrue", "AlwaysTrue", "+CT2_LINHA",;
				.f.,,,.t.,,"TMP",,,,,,,"CT102DEL(nOpc)")
			EndIf
            
			oGetDB:cSuperDel := "If(CT105SDEL(nOpc),oGetDb:oBrowse:Refresh(),)"

			Ctb102TamHist(.T.)	    
			
			//Tratamento ref. o Botao para exibir os totais de lote/documento em outras moedas. 
			//SetKey( VK_F5 , { || Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc) })		
			//aButton := { { "SIMULACAO" , {|| Ctb102OutM(dDataLanc,cLote,cSubLote,cDoc)} , STR0015+" - <F5>",STR0016 } } //"Totais do lote e documento (outras moedas)" "Totais"			

			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
			{||nOpca:=1,;
			If(	Ct105TOK(lCT105TOK,lCT105CHK,oGetDB:lModified,,aTotRdpe,nTotInf) .And.;
				Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK,nOpc) .And.;
				Ct102GrCTF(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK),;
			oDlg:End(), nOpca := 0)}, {||oDlg:End()},,aButton) CENTER
				
		EndDo
			
		IF nOpcA == 1
		
			//Ponto de entrada criado com a funcao de alterar a filial para gravacao dos saldos e lancamentos contabeis. 
			//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
			//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
			//posteriormente. 		
			If lAntCtbGrv
				ExecBlock("ANTCTBGRV",.F.,.F.)
			Endif		                                                     

			//Validacao 
			lRpcOk	:= CTB105Rpc(lDigita)			          
			
			If !lRpcOk .Or. __PreLan == .T.
				cPreLcto	:= "S"
			Else
				cPreLcto	:= "N"
			EndIf					
			CTBGrava(3,dDatalanc,cLote,cSubLote,cDoc,lAglut,cSeqChave,;
			__lCusto,__lItem,__lCLVL, nTotInf,cProgName,cPreLcto,dReproc,cEmpOri,cFilOri)

			//Ponto de entrada criado com a funcao de voltar a filial apos a gravacao dos saldos e lancamentos contabeis. 
			//Como exemplo, podera ser utilizado com as tabelas do financeiro compartilhadas e as tabelas do CTB exclusivas.
			//O financeiro sera consolidado e a contabilidade  nao. Na contabilidade sera executada a rotina de Consolidacao
			//posteriormente. 
			If lDepCtbGrv
				ExecBlock("DEPCTBGRV",.F.,.F.)
			Endif		                                                     									
			
			//Dar ZAP no arquivo temporario para nao trazer residuos do documento anterior
			//dbSelectArea("TMP")
			//Zap
			If TMP->(RecCount()) > 0
				TMP->(DbCloseArea())
				FErase( cArq1+cDBSExt )
				Ferase( cArq1+cIndExt )
				Ferase( cArq2+cIndExt )  
				cArq1 := ""
				cArq2 := ""
				Ctb105Cria(aCampos,@cArq1,@cArq2)				
			EndIf
		Endif
	EndIf
EndDo

If CTF_LOCK > 0					/// LIBERA O REGISTRO NO CTF COM A NUMERCAO DO DOC FINAL
	dbSelectArea("CTF")
	dbGoTo(CTF_LOCK)
	CtbDestrava(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK)			
Endif
        
#IFDEF TOP
	If Select(cAliasCTK) > 0 .And. cSrvType<>"AS/400"
		(cAliasCTK)->(DbCloseArea())
	Endif
#ENDIF

	
DbSelectArea( "CT2" )
TMP->(DbCloseArea())
If Select("cArq1") = 0
	FErase( cArq1+cDbsExt )
	Ferase( cArq1+cIndExt )
	Ferase( cArq2+cIndExt )
EndIf
  
//
// Restaurando ou Desabilitando as teclas de função utilizadas nesta função, que foram F4, F5, F6 e F7
//                 
If bVK_4 == NIL
	Set Key VK_F4 to
Else	
	SetKey(VK_F4,bVK_4)		
EndIf	
If bVK_5 == NIL
	Set Key VK_F5 to
Else	
	SetKey(VK_F5,bVK_5)		
EndIf	
If bVK_6 == NIL
	Set Key VK_F6 to
Else	
	SetKey(VK_F6,bVK_6)		
EndIf	
If bVK_7 == NIL
	Set Key VK_F7 to
Else	
	SetKey(VK_F7,bVK_7)		
EndIf	

          

If dReproc <> Nil
	CT2->(DbSetOrder(1))

	CT2->(DbSeek(Soma1(xFilial()), .T.))	// Procuro a proxima filial
	CT2->(DbSkip(-1))						// Volto para o registro anterior
	cFil190 := If(Empty(xFilial("CT2")), Space(2), cFilAnt)
				
	If CT2->CT2_FILIAL = xFilial("CT2") .And. CT2->CT2_DATA > dReproc
		CTBA190(.T.,dReproc,CT2->CT2_DATA,cFil190,cFil190,"1",.F.,"  ")
	Else                    	
		CTBA190(.T.,dReproc,dReproc,cFil190,cFil190,"1",.F.,"  ")
	Endif
Endif
	
RestArea(aSaveArea)
	
PutHFile("")

Return .T.
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CTB105Head³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Monta aHeader para MsGetDB                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³Ctb105Head(aAltera)                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ ExpA1 = Matriz com campos da MSGETDB                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Expa1 = Array de alteracao                                 ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function Ctb105Head(aAltera)
	
	Local aSaveArea:= GetArea()
	Local aFora		:= {"CT2_CALEND","CT2_DATA","CT2_LOTE", "CT2_SBLOTE", "CT2_DOC", "CT2_MOEDLC"}
	Local aCampos	:= {}

	Local lAglByHist:= GetNewPar("MV_AGLHIST",.F.)
	
	PRIVATE nUsado := 0
	
	AADD(aFora,"CT2_DTLP")
	
	// Montagem da matriz aHeader
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("CT2")
	While !EOF() .And. (x3_arquivo == "CT2")
		If Alltrim(x3_campo) == "CT2_LINHA" .Or. ;
			x3Uso(x3_usado) .and. cNivel >= x3_nivel
			If Ascan(aFora,Trim(X3_CAMPO)) <= 0
				nUsado++
				AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, x3_valid,;
				x3_usado, x3_tipo, "TMP", x3_context } )
				If Alltrim(x3_campo) <> "CT2_LINHA"
					Aadd(aAltera,Trim(X3_CAMPO))
				EndIf
			EndIF
		EndIF
		aAdd( aCampos, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL } )
		dbSkip()
	EndDO

 	#IFDEF TOP
		If UPPER(TcGetDb()) == "AS/400" .and. lAglByHist
			dbSetOrder(2)
			If MsSeek("CT2_HIST")
				aAdd(aCampos,{"CT2_TMPHIS", SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL } )
			Else
				aAdd(aCampos,{"CT2_TMPHIS", "C", 40,0 } )
			Endif
			dbSetOrder(1)
		Endif
	#ELSE
		If lAglByHist
			dbSetOrder(2)
			If MsSeek("CT2_HIST")
				aAdd(aCampos,{"CT2_TMPHIS", SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL } )
			Else
				aAdd(aCampos,{"CT2_TMPHIS", "C", 40,0 } )
			Endif
			dbSetOrder(1)
		Endif
	#ENDIF
	
	Aadd(aCampos,{"CT2_RECNO","N",9,0})
	Aadd(aCampos,{"CT2_FLAG","L",1,0})
	
	RestArea(aSaveArea)
	
	Return aCampos
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CTB105Cria³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Cria arquivo temporario e indices para MSGETDB             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintxe    ³ Ctb105Cria(aCampos,cArq1,cArq2)                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ Nenhum                                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³uso       ³Generico                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpA1 = Matriz com campos da MSGETDB                       ³±±
	±±³          ³ ExpC1 = Arquivo 1                                          ³±±
	±±³          ³ ExpC2 = Arquivo 2                                          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function Ctb105Cria(aCampos,cArq1,cArq2)
	
	Local aSaveArea := GetArea()
	Local cChave1
	Local cChave2
	Local lAglByHist		:= GetNewPar("MV_AGLHIST",.F.)
	
	cChave1 	:= "CT2_DC+CT2_DEBITO+CT2_CREDIT+CT2_CCD+CT2_CCC+CT2_ITEMD+CT2_ITEMC+CT2_CLVLDB+CT2_CLVLCR+CT2_TPSALD"	
	#IFDEF TOP
		If Upper(TcGetDb()) == "AS/400" .and. lAglByHist
			cChave1 += "+CT2_TMPHIS"
		Endif
	#ELSE
		If lAglByHist
			cChave1 += "+CT2_TMPHIS"
		Endif
	#ENDIF
	cArq1		:= CriaTrab( aCampos, .t. )
	
	dbUseArea( .t., __LocalDriver, cArq1, "TMP", .f., .f. )

	IndRegua( "TMP", cArq1, cChave1, , , OemToAnsi(STR0005) )
	dbClearIndex()
	
	cChave2 	:= "CT2_LINHA"
	cArq2 := CriaTrab(Nil,.F.)
	IndRegua( "TMP", cArq2, cChave2, , , OemToAnsi(STR0005) )
	dbClearIndex()
	
	dbSelectArea( "TMP" )
	dbSetIndex(cArq1+OrdBagExt())
	dbSetIndex(cArq2+OrdBagExt())
	dbSetOrder(1)
	
	RestArea(aSaveArea)
	
	Return
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CTB105GRV ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Carrega arq. temporario com dados para MSGETDB             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³CTB105GRV( cSeqChave, lAglut, aCampos, dDataLanc, cSubLote )³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ Nenhum                                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Contador / Flag do lancamento                      ³±±
	±±³          ³ ExpL1 = Aglutina lancamento?                               ³±±
	±±³          ³ ExpA1 = Matriz com campos do arquivo temporario            ³±±
	±±³          ³ ExpD1 = Data do lancamento                                 ³±±
	±±³          ³ ExpC2 = SubLote                                            ³±±
	±±³          ³ ExpN1 = Linha atual sendo processada                       ³±±
	±±³          ³ ExpN2 = Recno atual                                        ³±±
	±±³          ³ ExpC3 = Alias sendo processado [VIA TOP UTILIZA QUERY]     ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CTB105GRV( cSeqChave, lAglut, aCampos, dDataLanc, cSubLote,nLin,;
						nRecCtk, cAliasCTK )
	
	Local aSaveArea		:= GetArea()
	Local cMoeda		:= ""
	Local lSomaLinha	:= .t.
	Local lZero			:= .T.
	Local nLinha		:= 0
	Local nVal	 		:= 0
	Local nCont			:= 0
	Local nCont1		:= 0
	Local cSeqLan 		:= "001"
	Local nSeqHis 		:= 0
	Local lRet			:= .F.
	Local cLinha		:= "999"
	Local aPeriodos		:= {}
	Local nOrdCTK 		:= 1
	Local lOrdEnt		:= If(GetNewPar("MV_ORDLCTB","L")=="E",.T.,.F.)			/// MV_ORDLCTB : L= LP (sequen+lp)/ E = Entrada (Recno)
	Local lOrdTpSld		:= If(GetNewPar("MV_ORDLCTB","L")=="T",.T.,.F.)			/// MV_ORDLCTB : T= Tipo de Saldo
	Local lAglByHist	:= GetNewPar("MV_AGLHIST",.F.)	
	Local cCampoCtk	:= ""                           
	Local nZ
	Local cTpSald		:= ""
	Local cCt2Conv		:= ""
	Local cSrvType		:= TcSrvType()

	DbSelectArea( cAliasCTK )
	
	If nRecCTK > 0
		#IfDEF TOP
			If cSrvType="AS/400" 
		#Endif

				dbGoto(nRecCTK) 
				nRecCTK := 0

		#IfDEF TOP
			Endif
		#Endif
	Endif 

	nOrdCTK := IndexOrd()
	   
	#IFNDEF TOP
		If lOrdEnt					/// Se o Parâmetro MV_ORDLCTB == "E" (Ordem de Entrada)
			dbSetOrder(0)			/// Ordem de Entrada (para atender à sequencia de lançamentos - CODEBASE) bops: 64512
		Endif						/// Caso contrário usa a própria ordem 1
	#ELSE
		If cSrvType == "AS/400" .and. lOrdEnt
			dbSetOrder(0)
		Endif
	#ENDIF

	cTpSldAtu := (cAliasCTK)->CTK_TPSALD
                        
	While !Eof() .and. (cAliasCTK)->CTK_SEQUEN == cSeqChave .And. nLinha < MAX_LINHA[1]
		
		If lOrdTpSld			/// QUANDO ORDEM POR TIPO DE SALDO - QUEBRA DOCUMENTO POR TIPO DE SALDO
			If (cAliasCTK)->CTK_TPSALD <> cTpSldAtu
				nLin := MAX_LINHA[1]+1		/// SETA LINHA PARA QUEBRAR DOCUMENTO POR TIPO DE SALDO
				Exit
			EndIf
		EndIf
		
		// Verifica se existe algum valor <> de 0
		lZero := .F.
		For nCont1 := 1 To __nQuantas
			If &(cAliasCTK + "->CTK_VLR"+StrZero(nCont1,2)) != 0
				lZero := .F.
				Exit
			Else
				lZero := .T.
			EndIf
		Next nCont1
		
		If !lZero .Or. ((cAliasCTK)->CTK_DC == "4" .And. ! lAglut)
			DbSelectArea( "TMP" )
			DbSetOrder(1)
			If lAglut                             			
				#IFDEF TOP
					If cSrvType <> "AS/400"
						lSomaLinha	:= .T.
						dbAppend()			 
						nVal := 0						
					Else
				#ENDIF     
				
					If AMVS[3] == "S"
						cTpSald	:= "9"
					Else
						cTpSald	:= (cAliasCTK)->CTK_TPSALD					
					EndIf				
				                    			
					cSeekTMP := (cAliasCTK)->(CTK_DC+CTK_DEBITO+CTK_CREDIT+CTK_CCD+CTK_CCC+CTK_ITEMD+CTK_ITEMC+;
  					 		  CTK_CLVLDB+CTK_CLVLCR+cTpSald)
  					 		  
					If lAglByHist
						cSeekTMP += (cAliasCTK)->CTK_HIST					/// PROCURA COM O HISTORICO ORIGINAL DO CTK
					Endif
					If MsSeek(cSeekTMP)
							If TMP->CT2_DC = "4"
								nVal := 0
								dbAppend()
								lSomaLinha := .T.
							Else
								lSomaLinha := .F.
							EndIf
					Else
						nVal := 0
						dbAppend()
						lSomaLinha := .T.
					EndIf
				#IFDEF TOP 
					Endif
				#ENDIF
			Else
				dbAppend()
				lSomaLinha := .T.
			EndIf
			
			#IFDEF TOP
				If lAglut .and. cSrvType <> "AS/400"										//// SE FOR AGLUTINADO (QUERY)
					cKeyCT5 := xFilial("CT5") + (cAliasCTK)->CTKLPLPSEQ					//// USA A QUERY (MAIOR LP E SEQUENCIA)
				Else																		//// SE NAO FOR AGLUTINADO
			#ENDIF																			
				cKeyCT5 := xFilial("CT5") + (cAliasCTK)->(CTK_LP+CTK_LPSEQ)		/// USA O LP E SEQUENCIA POSICIONADOS
			#IFDEF TOP
				Endif
			#ENDIF

			CT5->(MsSeek(cKeyCT5))						
			If Empty(TMP->CT2_MOEDAS)								
				TMP->CT2_MOEDAS := CT5->CT5_MOEDAS
			Endif			
			
			For nCont := 1 To Len(aCampos)
				cCampoCTK := "CTK_" + Substr(aCampos[nCont][1],5,Len(aCampos[nCont][1]))
				nPos := FieldPos(aCampos[nCont][1])
				If AllTrim(aCampos[nCont][1]) == "CT2_VALOR"
					If Left(TMP->CT2_MOEDAS,1) == "1"
						If lAglut
							TMP->CT2_VALOR += (cAliasCTK)->CTK_VLR01				
						Else
							TMP->CT2_VALOR := (cAliasCTK)->CTK_VLR01									
						EndIf                                                                                
					EndIf
				ElseIf Subs(aCampos[nCont][1],1,8) == "CT2_VALR"
					//Verifica se existe calendario para a moeda na data do lancamento
					aPeriodos	:= CtbPeriodos(Subs(aCampos[nCont][1],9,2),dDataLanc,dDataLanc,.F.,.F.) 														
					If !Empty(aPeriodos[1][1]) .and. SubStr(TMP->CT2_MOEDAS,Val(Subs(aCampos[nCont][1],9,2)),1) == "1"
						If aPeriodos[1][4] $ "1"	//Se o calendario estiver aberto
							If lAglut
								&("TMP->CT2_VALR"+Subs(aCampos[nCont][1],9,2))	+= &(cAliasCTK+"->CTK_VLR"+Subs(aCampos[nCont][1],9,2))					
							Else
								&("TMP->CT2_VALR"+Subs(aCampos[nCont][1],9,2))	:= &(cAliasCTK+"->CTK_VLR"+Subs(aCampos[nCont][1],9,2))
							EndIf					
						Else
							Loop
						EndIf
					EndIf
				ElseIf Subs(aCampos[nCont][1],1,9) == "CT2_DTCV3" 				 
					TMP->CT2_DTCV3	:= (cAliasCTK)->CTK_DATA
				ElseIf Tmp->(FieldPos(aCampos[nCont][1])) > 0 .And. (cAliasCTK)->(FieldPos(cCampoCTK)) > 0
					FieldPut(nPos,(cAliasCTK)->(FieldGet(FieldPos(cCampoCTK))))
				EndIf
			Next nCont
			If lSomaLinha
				If nLinha > 998
					cLinha := Soma1(cLinha)
					nLinha++
					TMP->CT2_LINHA 	:= cLinha
				Else
					nLinha++
					TMP->CT2_LINHA 	:= StrZero(nLinha,3)
				Endif
			EndIf
			
			// Criterio de conversao
			If TMP->CT2_DC == "1" .Or. TMP->CT2_DC == "3"
				CarrCriter((cAliasCTK)->CTK_DEBITO,"1","TMP->CT2_CONVER",dDataLanc)
			EndIf
			If TMP->CT2_DC == "2" .Or. TMP->CT2_DC == "3"
				CarrCriter((cAliasCTK)->CTK_CREDIT,"2","TMP->CT2_CONVER",dDataLanc)
			EndIf
			
			If !lAglut			//Grava TMP->CT2_KEY
				TMP->CT2_KEY	:= (cAliasCTK)->CTK_KEY  
			Endif
			                                 
			// Valor nas outras moedas
			For  nCont := 2	To __nQuantas
				cMoeda := StrZero(nCont,2)
				// Verifica se moeda esta bloqueada ou se data esta bloqueada para a moeda
//				If (!CTBMInUse(cMoeda) .Or. !CtbDtInUse(cMoeda,dDataLanc))
				If (!CTBMInUse(cMoeda)) 
					Loop
				EndIf
				
				If Substr(TMP->CT2_MOEDAS,nCont,1) == "1"				
					cMoeda := StrZero(nCont,2)           
					aPeriodos	:= CtbPeriodos(cMoeda,dDataLanc,dDataLanc,.F.,.F.) 														
					If !Empty(aPeriodos[1][1])                       										
						If aPeriodos[1][4] $ "1"	//Se o calendario estiver aberto									
							// Converte valores
							If &((cAliasCTK) + '->CTK_VLR'+StrZero(nCont,2)) == 0 .and. Empty(&("CT5->CT5_VLR"+StrZero(nCont,2)))
								&('TMP->CT2_VALR'+StrZero(nCont,2)) := ;
								CtbConv(Substr(TMP->CT2_CONVER,nCont,1),dDataLanc,cMoeda,;								
								TMP->CT2_VALOR)                                								
							EndIf
						EndIf
					EndIf
				EndIf
				
				If CtbUso("CT2_DTTX"+cMoeda)
					&("TMP->CT2_DTTX"+cMoeda)	:= dDataLanc
				EndIf                           
				
			Next nCont

			//Atualizar o criterio de conversao apos prencher os valores em outras moedas. 
			//Se o valor na moeda 01 estiver zerado, alterar o criterio de conversao para "5". 
			//Nas outras moedas, o criterio de conversao devera ser alterado para "4". 
            cCt2Conv := TMP->CT2_CONVER
			
			For nCont := 1 to __nQuantas
				If nCont == 1      
					If TMP->CT2_VALOR == 0 
						cCt2Conv := "5" + Right(cCt2Conv,__nQuantas-1)
				    EndIf
				Else
					If !Empty(&("CT5->CT5_VLR"+StrZero(nCont,2)))
						cCt2Conv	:= Stuff(cCt2Conv,nCont,1,"4")
					ElseIf &("TMP->CT2_VALR"+Strzero(nCont,2))== 0
						cCt2Conv	:= Stuff(cCt2Conv,nCont,1,"5")
					EndIf
				EndIf
			Next	 
			
			If !Empty(cCt2Conv)		                
				// Pode ocorrer que neste momento a conta ainda esteja em branco (ver BOPS 89576). Se isso ocorrer, 
				// nao gravar no TMP o criterio de conversao. No momento que o usuario informar a conta, o sistema 
				// trara o criterio automaticamente do Plano de Contas.
				If !Empty(TMP->CT2_DEBITO) .Or. !Empty(TMP->CT2_CREDIT) 
					TMP->CT2_CONVER	:= cCt2Conv			
					cCt2Conv	:= ""
				EndIf
			EndIf											

			TMP->CT2_FLAG := .F.
			If TMP->CT2_LINHA == '001'
				cSeqLan	:= "001"
				nSeqHis	:= 1
				TMP->CT2_SEQLAN := cSeqLan
				TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
			ElseIf TMP->CT2_DC == '4' .And. TMP->CT2_LINHA != '001'
				nSeqHis ++
				TMP->CT2_SEQLAN := cSeqLan
				TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
			ElseIf TMP->CT2_DC != '4' .And. TMP->CT2_LINHA != '001'
				nSeqHis	:= 1
				cSeqLan := Soma1(cSeqLan)
				TMP->CT2_SEQLAN := cSeqLan
				TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
			Endif
			If aMvs[MV_PRELAN] = "S"		// Grava como pre lancamento se for S = Sempre
				TMP->CT2_TPSALD := D_PRELAN
			Endif

			If cPaisLoc == 'CHI'
			    cSeqCrAnt := Iif( Type("cSeqOficNFE")="C", cSeqOficNFE, ;
			    				  Iif( Type("cSeqCorr")="C", cSeqCorr, Space(10) ) )
            	#IFDEF TOP
	            	If lAglut .and. cSrvType <> "AS/400"
	            		cSeqCorr := CTBSQCor( Left((cAliasCTK)->CTKLPLPSEQ,3) )            	
	            	Else
            	#ENDIF
	            	cSeqCorr := CTBSQCor( (cAliasCTK)->CTK_LP )            	
	            #IFDEF TOP
	            	Endif
	            #ENDIF
            	If cSeqCrAnt > cSeqCorr
            	   cSeqCorr := cSeqCrAnt  // trata o caso do correlativo manual (digitado)
            	EndIf
            EndIf	

			//Grava Digito verificador das contas, caso o campo esteja em uso
			If CtbUso("CT2_DCD")						//  Digito de Controle
				If Empty(TMP->CT2_DCD)
					dbSelectArea("CT1")                
					dbSetOrder(1)
					If MsSeek(xFilial()+TMP->CT2_DEBITO)
						TMP->CT2_DCD	:= CT1->CT1_DC
					EndIf
					dbSelectArea("TMP")
				EndIf
				If Empty(TMP->CT2_DCC)
					dbSelectArea("CT1")
					dbSetOrder(1)
					If MsSeek(xFilial()+TMP->CT2_CREDIT)
						TMP->CT2_DCC	:= CT1->CT1_DC
					EndIf
					dbSelectArea("TMP")		
				EndIf		
			EndIf

			If lAglut 													//// SE FOR AGLUTINADO
				#IFDEF TOP
					If UPPER(TcGetDb()) == "AS/400" .and. lAglByHist
						TMP->CT2_TMPHIS := (cAliasCTK)->CTK_HIST		/// GRAVA ANTES DO HISTORICO POIS PODE TER VARIAS LINHAS
					Endif
				#ELSE
					If lAglByHist
						TMP->CT2_TMPHIS := (cAliasCTK)->CTK_HIST		/// GRAVA ANTES DO HISTORICO POIS PODE TER VARIAS LINHAS
					Endif
				#ENDIF
				
				If CT5->(MsSeek(cKeyCT5))
					If !Empty(CT5->CT5_HAGLUT)							/// SE O HISTORICO AGLUTINADO ESTIVER PREENCHIDO
	     	   			cTpSald 	:= TMP->CT2_TPSALD
						cHistorico 	:= AllTrim(TransLcta(CT5->CT5_HAGLUT,240))
						nLen := Len(CTK->CTK_HIST)
						For nZ := 1 To Len(cHistorico) Step nLen
							If nZ > 1
								nSeqHis ++
							Endif
							cHist := SubStr(cHistorico,nZ,nLen)
							If nZ > 1
								dbSelectArea("TMP")
								DbSetOrder(2)
								DbSkip()
								If CT2_HIST = cHist
									Loop
								Endif
							
								DbAppend()
								TMP->CT2_DC	:= "4"

	   			   				If nLinha > 998
									cLinha := Soma1(cLinha)
									nLinha++
									TMP->CT2_LINHA 	:= cLinha
								Else
									nLinha++
									TMP->CT2_LINHA 	:= StrZero(nLinha,3)
								Endif
							Endif
							
							TMP->CT2_HIST	:= cHist
							TMP->CT2_TPSALD := cTpSald
							TMP->CT2_SEQLAN := cSeqLan
							TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
							TMP->CT2_LP		:= CT5->CT5_LANPAD
							TMP->CT2_MOEDLC := CT5->CT5_MOEDLC
							TMP->CT2_MOEDAS := CT5->CT5_MOEDAS
							TMP->CT2_ORIGEM	:= (cAliasCTK)->CTK_ORIGEM
						Next nZ
					Else									//// SE O HISTORICO AGLUTINADO NAO ESTIVER PREENCHIDO
						#IFDEF TOP							//// EXECUTA O TRATAMENTO DO HISTORICO SOMENTE PARA TOP
							If cSrvType <> "AS/400"		//// E DIFERENTE DE AS/400 POIS USA A QUERY COM GROUP BY
								dbSelectArea("CTK")
								dbSetOrder(1)
								dbGoTo((cAliasCTK)->(CTKMINRECNO))
								cHistorico 	:= CTK->CTK_HIST
								CTK->(dbSkip())
								While !Eof() .and. CTK->CTK_FILIAL == xFilial("CTK") .and. CTK_SEQUEN == cSeqChave .and. CTK->CTK_DC == "4"
						        	cHistorico += CTK->CTK_HIST
   									CTK->(dbSkip())
								EndDo
								cHistorico := Rtrim(cHistorico)
								
								dbSelectArea("TMP")        
						
								cTpSald 	:= TMP->CT2_TPSALD
								nLen := Len(CTK->CTK_HIST)
								For nZ := 1 To Len(cHistorico) Step nLen
									If nZ > 1
										nSeqHis ++
									Endif
									cHist := SubStr(cHistorico,nZ,nLen)
									If nZ > 1
										dbSelectArea("TMP")
										DbSetOrder(2)
										DbSkip()
										If CT2_HIST = cHist
											Loop
										Endif
								
										DbAppend()
										TMP->CT2_DC	:= "4"
               	                     
	   		   			   				If nLinha > 998                          
											cLinha := Soma1(cLinha)
											nLinha++
											TMP->CT2_LINHA 	:= cLinha
										Else
											nLinha++
											TMP->CT2_LINHA 	:= StrZero(nLinha,3)
										Endif
									Endif
								    
									TMP->CT2_HIST	:= cHist
									TMP->CT2_TPSALD := cTpSald
									TMP->CT2_SEQLAN := cSeqLan
									TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
									TMP->CT2_LP		:= CT5->CT5_LANPAD
									TMP->CT2_MOEDLC := CT5->CT5_MOEDLC
									TMP->CT2_MOEDAS := CT5->CT5_MOEDAS
									TMP->CT2_ORIGEM	:= (cAliasCTK)->CTK_ORIGEM
								Next nZ
							Else
						#ENDIF							
			     	   			cTpSald 	:= TMP->CT2_TPSALD
								cHistorico 	:= AllTrim(CTK->CTK_HIST)
								nLen := Len(CTK->CTK_HIST)
								For nZ := 1 To Len(cHistorico) Step nLen
									If nZ > 1
										nSeqHis ++
									Endif
									cHist := SubStr(cHistorico,nZ,nLen)
									If nZ > 1
										dbSelectArea("TMP")
										DbSetOrder(2)
										DbSkip()
										If CT2_HIST = cHist
											Loop
										Endif
									
										DbAppend()
										TMP->CT2_DC	:= "4"
		
			   			   				If nLinha > 998
											cLinha := Soma1(cLinha)
											nLinha++
											TMP->CT2_LINHA 	:= cLinha
										Else
											nLinha++
											TMP->CT2_LINHA 	:= StrZero(nLinha,3)
										Endif
									Endif
									
									TMP->CT2_HIST	:= cHist
									TMP->CT2_TPSALD := cTpSald
									TMP->CT2_SEQLAN := cSeqLan
									TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
									TMP->CT2_LP		:= CT5->CT5_LANPAD
									TMP->CT2_MOEDLC := CT5->CT5_MOEDLC
									TMP->CT2_MOEDAS := CT5->CT5_MOEDAS
									TMP->CT2_ORIGEM	:= (cAliasCTK)->CTK_ORIGEM
								Next nZ		
						#IFDEF TOP							
							Endif
						#ENDIF
					Endif

					If Empty(cSubLote)
						cSubLote	:= CT5->CT5_SBLOTE
					Endif
				Endif
			Else															//// SE NÃO FOR AGLUTINADO
				If Empty(cSubLote) .and. CT5->(MsSeek(cKeyCT5))				//// SE O NUMERO DE SUB-LOTE ESTIVER EM BRANCO
					cSubLote	:= CT5->CT5_SBLOTE
				Endif
			Endif
		EndIf
		
		DbSelectArea( cAliasCTK )
		DbSkip()
		nLin ++
		lRet := .T.       
		
	EndDo
                                 
	dbSelectArea(cAliasCTK)
	dbSetOrder(nOrdCTK)
	nRecCTK := Recno()
	dbSelectArea("TMP")
	dbSetOrder(2)
	dbGoTop()
	If lAglut				// Em caso de aglutinar a sequencia de lancamento
		cSeqLan := "001"	// pode ser gerado errada, portanto eh refeita
		nSeqHis := 0
		While ! Eof()
			If TMP->CT2_LINHA == '001'
				cSeqLan	:= "001"
				nSeqHis	:= 1
				TMP->CT2_SEQLAN := cSeqLan
				TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
			ElseIf TMP->CT2_DC == '4' .And. TMP->CT2_LINHA != '001'
				nSeqHis ++
				TMP->CT2_SEQLAN := cSeqLan
				TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
			ElseIf TMP->CT2_DC != '4' .And. TMP->CT2_LINHA != '001'
				nSeqHis	:= 1
				cSeqLan := Soma1(cSeqLan)
				TMP->CT2_SEQLAN := cSeqLan
				TMP->CT2_SEQHIS := StrZero(nSeqHis,3)
			Endif
			DbSkip()
		EndDo
	Endif
	
	RestArea(aSaveArea)
	
	Return lRet
	
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CtExibeCta³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Carrega Criterio de Conversao - Validacao MSGETDB          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ CtExibeCta(cConta,cTipo)                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T.                                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³Generico                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Conta Contabil                                     ³±±
	±±³          ³ ExpC2 = Tipo do Lancamento contabil                        ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CtExibeCta(cConta,cTipo,dDataLanc)
	
	// Carrega criterio de conversao
	CarrCriter(cConta,cTipo,"TMP->CT2_CONVER",dDataLanc)
	
	Return .T.
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CarrCriter³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Carrega Criterio de Conversao para campo arq temporario    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ CarrCriter(cConta,cTipo,cCampo)                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T.                                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Conta Contabil                                     ³±±
	±±³          ³ ExpC2 = Tipo do Lancamento contabil                        ³±±
	±±³          ³ ExpC3 = Campo                                              ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CarrCriter(cConta,cTipo,cCampo,dDataLanc)
	
	Local cCriter	
	Local nCont
	Local aSaveArea := GetArea()
	Local aPeriodos	:= {}
	Local lCT1Eof
	
	DEFAULT dDataLanc := CTOD("  /  /  ")
	
	// Criterio de conversao
	If cTipo == "1" .Or. cTipo == "3"
	
		cCriter := "1"	//Ref a moeda 01
		dbSelectArea( "CT1" )
		dbSetOrder(1)
		MsSeek( xFilial() + cConta )
		lCT1Eof := CT1->( EOF() )
		If SuperGetMv("MV_CRITPLN", .F., .T.)
			For nCont := 2	To __nQuantas
				If !Empty(dDataLanc)
					aPeriodos	:= CtbPeriodos(StrZero(nCont,2),dDataLanc,dDataLanc,.F.,.F.) 														
					If !Empty(aPeriodos[1][1])                       						
						If aPeriodos[1][4] $ "1".And. (FunName() == 'CTBA102' .Or.;
							 ( FunName() <> 'CTBA102' .And. ;
							 (!Empty(TMP->CT2_MOEDAS) .And. Subs(TMP->CT2_MOEDAS,nCont,1) == "1") .Or. Empty(TMP->CT2_MOEDAS)))							 			
							cCriter += &('CT1->CT1_CVD'+StrZero(nCont,2))
						Else
							cCriter += "5"
						EndIf						
					Else
						cCriter += "5"
					EndIf
				Else
					cCriter += &('CT1->CT1_CVD'+StrZero(nCont,2))
				EndIf
			Next nCont
		Else
			cCriter := &(cCampo)
			If Empty(cCriter)
				cCriter := CriaVar(StrTran(cCampo, "TMP", "CT2"))
			Endif
		Endif            
		If Upper(cCampo) == "TMP->CT2_CONVER"
			If Empty(&(cCampo)) .and. !lCT1Eof  //  Se o campo estiver vazio e encontrou a conta no CT1
				&(cCampo) := cCriter                                        
			EndIf
		Else
			&(cCampo) := cCriter                                        
		EndIf
		
	EndIf
	
	If cTipo == "2" .Or. cTipo == "3"
		cCriter := "1"	//Ref. a moeda 01
		dbSelectArea( "CT1" )
		dbSetOrder(1)
		MsSeek( xFilial() + cConta )
		lCT1Eof := CT1->( EOF() )
		If SuperGetMv("MV_CRITPLN", .F., .T.)
			For nCont := 2	To __nQuantas
				If !Empty(dDataLanc)
					aPeriodos	:= CtbPeriodos(StrZero(nCont,2),dDataLanc,dDataLanc,.F.,.F.) 														
					If !Empty(aPeriodos[1][1])                                     
						If aPeriodos[1][4] $ "1" .And. (FunName() == 'CTBA102' .Or.;
							 ( FunName() <> 'CTBA102' .And. ;
							 (!Empty(TMP->CT2_MOEDAS) .And. Subs(TMP->CT2_MOEDAS,nCont,1) == "1") .Or. Empty(TMP->CT2_MOEDAS)))							 			
							cCriter += &('CT1->CT1_CVC'+StrZero(nCont,2))
						Else
							cCriter += "5"
						EndIf						
					Else
						cCriter += "5"
					EndIf
				Else			
					cCriter += &('CT1->CT1_CVC'+StrZero(nCont,2))
				EndIf
			Next nCont
		Else
			cCriter := &(cCampo)
			If Empty(cCriter)
				cCriter := CriaVar(StrTran(cCampo, "TMP", "CT2"))
			Endif
		Endif
		If Upper(cCampo) == "TMP->CT2_CONVER"
			If Empty(&(cCampo)) .and. !lCt1Eof  //  Se o campo estiver vazio e encontrou a conta no CT1
				&(cCampo) := cCriter                                        
			EndIf
		Else
			&(cCampo) := cCriter
		EndIf
	EndIf
	
	RestArea(aSaveArea)
	
	Return .T.
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³Ctb105Conv³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Carrega Valores de  Conversao - Validacao MSGETDB          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ Ctb105Conv(nValor,cCriter,cMoedas)						  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T.                                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³Generico                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpN1 = Valor do Lancamento Contabil                       ³±±
	±±³          ³ ExpC1 = Criterio de Conversao                              ³±±
	±±³          ³ ExpC2 = Moedas do Lancamento Contabil                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function Ctb105Conv(nValor,cCriter)
	
	Local cMoeda
	Local nValorConv
	Local nCont
	Local cCritAlt	:= ""
	
	cCriter := Iif(Empty(cCriter),TMP->CT2_CONVER,cCriter)
	nValor	:= Iif(nValor==Nil,TMP->CT2_VALOR,nValor)
	
	// Zera valor na moeda 1 -> quando CT2_CONVER,1,1 = "2"
	If Substr(cCriter,1,1) == "5" //Nao utiliza criterio de conversao
		TMP->CT2_VALOR := 0
	EndIf  
	
	//Se alterar o valor, atualiza o criterio de conversao.			
	If nValor == 0
		cCritAlt	:= "5"+Subs(cCriter,2,Len(cCriter))
		TMP->CT2_CONVER	:= cCritAlt		
	EndIf

	
	For nCont := 1 To Len(cCriter)
		cMoeda := StrZero(nCont,2)
		
		If cMoeda ='01'
			Loop
		EndIf
		
		// Verifica se moeda esta bloqueada ou se data esta bloqueada para a moeda
		If (!CTBMInUse(cMoeda) .Or. !CtbDtInUse(cMoeda,dDataLanc))
			Loop
		EndIf

		//Se alterar a taxa de conversao, atualiza os valores		
		If Substr(cCriter,nCont,1) <> "5"	//Se utiliza taxa de conversao
			If Substr(cCriter,nCont,1) <> "4"	//Se for taxa informada, nao altero o valor na outra moeda
				If CtbUso("CT2_DTTX"+cMoeda) .And. Substr(cCriter,nCont,1) == "9"
					nValorConv 	:= CtbConv("9",&("TMP->CT2_DTTX"+cMoeda),cMoeda,nValor)									
				Else			
					nValorConv 	:= CtbConv(Substr(cCriter,nCont,1),dDataLanc,cMoeda,nValor)
				EndIf
				&('TMP->CT2_VALR'+cMoeda) := nValorConv
			Endif
		Else
			&('TMP->CT2_VALR'+cMoeda) := 0
		EndIf
	Next nCont
	Return .T.
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³Ctb105Cta ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Valida conta da GetDB                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ Ctb105Cta(cConta,cTipo)                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T./.F.                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Expc1 = Conta                                              ³±±
	±±³          ³ Expc2 = Tipo da conta                                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CTB105CTA(cConta,cTipo)
	
	Local aSaveArea := GetArea()
	Local lRet		:= .T., lCtaNil
	Local lRateio	:= .F.
	Local nValRat	:= 0                        
	Local nTotalDeb	:= 0
	Local nTotalCrd	:= 0              
	Local nRecTmp	:= 0
	Local cProg		:= FunName()                                               	
	Local cRateio	:= ""                                                      
	Local cCampo	:= ReadVar()

	If (lCtaNil := cConta = Nil)
		cConta := &(ReadVar())
	Endif

	If ! CtbInUse()			  		// Compatilizacao para usar tambem com SigaCon
		Return Ca050cta(cConta, 1)	// Nao utilizo ValidaConta por ser recursiva
	Endif

	If cTipo = Nil			// Chamada externa lancamentos contabeis nao passar tipo
		dDataLanc := dDataBase
	Endif

	//Verificar se a conta possui o campo de Rateio preenchido. Valido somente para a digitacao de lancamentos contabeis
	//atraves da rotina CTBA102. Verifica se esta posicionado na Getdb, pois quando digitava a conta na tela de rateio
	//estava mostrando a tela do valor a ratear novamente. 	
	If cProg == "CTBA102" .And. (TMP->(Recno()) == TMP->(RecCount())) .And. ;
		(Subs(cCampo,4,10) == "CT2_DEBITO" .Or. Subs(cCampo,4,10) == "CT2_CREDIT")
		dbSelectArea("CT1")
		dbSetOrder(1)
		If MsSeek(xFilial()+cConta,.F.) .And. !Empty(CT1->CT1_RATEIO)
			//Mostra tela para digitacao do valor a ser rateado. Retorna o valor digitado.
			nValRat	:= Ctb102VlRt()	
			
			If nValRat > 0 
			    cRateio	:= CT1->CT1_RATEIO
				cTipo 		:= CtbRateio(cRateio,nValRat,@nTotalDeb,@nTotalCrd,"","","")			     
								
				aTotRdpe := {{0,0,0,0},{0,0,0,0}}

				nRecTmp := TMP->(Recno())
				TMP->(DbGoTop())
				While ! TMP->(Eof())		
					If Subs(cCampo,4,10) == "CT2_DEBITO" 
						lRateio	:= .T.
						If TMP->CT2_DC $ "1/3" .Or. ;
							(!Empty(TMP->CT2_CCD) .Or. !Empty(TMP->CT2_ITEMD) .Or. !Empty(TMP->CT2_CLVLDB))
							TMP->CT2_DEBITO := cConta							
						Else                                                    
							TMP->CT2_DEBITO := ""
						EndIf							
					ElseIf Subs(cCampo,4,10) == "CT2_CREDIT" 
						lRateio	:= .T.
						If TMP->CT2_DC $ "2/3" .Or. ;
							(!Empty(TMP->CT2_CCC) .Or. !Empty(TMP->CT2_ITEMC) .Or. !Empty(TMP->CT2_CLVLCR))															
							TMP->CT2_CREDIT	:= cConta												
						Else
							TMP->CT2_CREDIT	:= ""
						EndIf
					EndIf					
					If ! TMP->CT2_FLAG
						CTB102Exibe(TMP->CT2_VALOR,0,TMP->CT2_DC,TMP->CT2_DC,GetMv("MV_SOMA"))
					Endif
 					TMP->(DbSkip())		
				EndDo
				TMP->(DbGoTo(nRecTmp))			
			EndIf
		EndIf
	EndIf    
	  
	//Se nao eh rateio de conta
	If !lRateio
		ConvConta(@cConta)	
		If cTipo == '1'
			TMP->CT2_DEBITO := cConta
		ElseIf cTipo <> Nil
			TMP->CT2_CREDIT := cConta
		Endif	
	EndIf	
	
	lRET := ValidaConta(cConta,cTipo,,,.T.)
	If lRet
		If cTipo <> Nil		// Chamada externa lancamentos contabeis nao passar tipo
			If ( TMP->CT2_DC $ '1/3' .And. cTipo == "1" ) .Or. ( TMP->CT2_DC $ '2/3' .And. cTipo == "2" )		
				CTExibeCta(cConta,cTipo,dDataLanc)
				C102ExbCta(cConta)
				Ctb105Conv()                          
				// Se a conta tiver um Hist. Padrao cadastrado e o Histórico na MSGETDB estiver em branco, 
				// jogar este Hist. Padrao na MSGETDB atraves de Ctb101Hist 
				If ! Empty(CT1->CT1_HP) .And. Empty(TMP->CT2_HP)
					Ctb101Hist(CT1->CT1_HP,,,,,,,,.T.)
				EndIf
			EndIf
			If lRet 
				If !Empty(cConta) .And. TMP->CT2_DC == '4'
					Help(" ",1,"NOCTAHIS")
					lRet := .F.				
				EndIf
			EndIf				
		Endif       
		If lRet
			lRet :=	ValidaBloq(cConta,dDataLanc,"CT1")
		EndIf		
	EndIf
	

	If lRet .And. cTipo = Nil .And. lCtaNil	// Chamada externa lancamentos contabeis nao passar tipo
		&(ReadVar()) := cConta
	Endif	
	

	RestArea(aSaveArea)
	
	Return lRET
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³Ctb105CC  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Valida Centro de Custo da GetDB                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ CTB105CC(cCusto,cTipo)									  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T./.F.                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Centro de Custo                                    ³±±
	±±³          ³ ExpC2 = Tipo do centro do custo                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CTB105CC(cCusto,cTipo)
	
	Local aSaveArea := GetArea()
	Local lRet	:= .T., lCusNil
	
	If (lCusNil := cCusto = Nil)
		cCusto := &(ReadVar())
	Endif

	If ! CtbInUse()				// Compatilizacao para usar tambem com SigaCon
		Return ExistCpo("SI3",cCusto)	// Nao utilizo ValidaCusto por ser recursiva
	Endif

	If cTipo = Nil			// Chamada externa lancamentos contabeis nao passar tipo
		dDataLanc := dDataBase
	Endif

	ConvCusto(@cCusto)
	
	If cTipo == '1'
		TMP->CT2_CCD := cCusto
	ElseIf cTipo <> Nil		// Chamada externa lancamentos contabeis nao passar tipo
		TMP->CT2_CCC := cCusto	
	Endif
	
 	lRET := ValidaCusto(cCusto,cTipo,,,.T.)
	If lRet
		lRet := ValidaBloq(cCusto,dDataLanc,"CTT")
		If cTipo <> Nil // Chamada externa lancamentos contabeis nao passar tipo
			C102ExbCC(cCusto)
		Endif
	EndIf
	
	If lRet .And. cTipo = Nil .And. lCusNil		// Chamada externa lancamentos contabeis nao passar tipo
		&(ReadVar()) := cCusto
	Endif

	RestArea(aSaveArea)
	
	Return lRet
	
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³Ctb105ITEM³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Valida Item Contabil da GetDB                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³Ctb105item(cItem,ctipo)                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T./.F.                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Item Contabil                                      ³±±
	±±³          ³ ExpC2 = Tipo do Item contabil                              ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CTB105Item(cItem,cTipo)
	
	Local aSaveArea := GetArea()
	Local lRet	:= .T., lItNil
	
	If (lItNil := cItem = Nil)
		cItem := &(ReadVar())
	Endif
		
	If ! CtbInUse()				// Compatilizacao para usar tambem com SigaCon
		Return ExistCpo("SID",cItem)	// Nao utilizo ValidaCusto por ser recursiva
	Endif

	If cTipo = Nil			// Chamada externa lancamentos contabeis nao passar tipo
		dDataLanc := dDataBase
	Endif

	ConvItem(@cItem)
	
	If cTipo == '1'
		TMP->CT2_ITEMD := cItem
	ElseIf cTipo <> Nil		// Chamada externa lancamentos contabeis nao passar tipo
		TMP->CT2_ITEMC := cItem
	Endif
	
	lRet := ValidItem(cItem,cTipo,,,.T.)
	If lRet
		lRet := ValidaBloq(cItem,dDataLanc,"CTD")
		If cTipo <> Nil			// Chamada externa lancamentos contabeis nao passar tipo
			C102ExbIt(cItem)
		Endif
	EndIf
	
	If lRet .And. cTipo = Nil .And. lItNil	// Chamada externa lancamentos contabeis nao passar tipo
		&(ReadVar()) := cItem
	Endif

	RestArea(aSaveArea)
	
	Return lRET
	
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³Ctb105CLVL³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Valida Classe de Valor da GetDB                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ Ctb105Clvl(cClVl,cTipo)                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T./.F.                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = classe de valor                                    ³±±
	±±³          ³ ExpC2 = Tipo da classe de valor                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CTB105CLVL(cClvl,cTipo)
	
	Local aSaveArea := GetArea()
	Local lRet	:= .T., lClNil

	If (lClNil := cClVl = Nil)
		cClVl := &(ReadVar())
	Endif

	If cTipo = Nil			// Chamada externa lancamentos contabeis nao passar tipo
		dDataLanc := dDataBase
	Endif

	ConvCLVL(@cClvl)
	
	If cTipo == '1'
		TMP->CT2_CLVLDB := cClvl
	ElseIf cTipo <> Nil		// Chamada externa lancamentos contabeis nao passar tipo
		TMP->CT2_CLVLCR := cClvl
	Endif
	
	lRET := ValidaCLVL(cCLVL,cTipo,,,.T.)
	
	If lRet
		lRet :=	ValidaBloq(cCLVL,dDataLanc,"CTH")
		If cTipo <> Nil			// Chamada externa lancamentos contabeis nao passar tipo
			C102ExbCV(cClvl)
		Endif
	EndIf
	
	If lRet .And. cTipo = Nil .And. lClNil	// Chamada externa lancamentos contabeis nao passar tipo
		&(ReadVar()) := cClVl
	Endif

	RestArea(aSaveArea)
	
	Return lRET
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CT105LINOK³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Valida linha do lancamento na MSGETDB                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³Ct105LinOk()                                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T. / .F.                                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Nenhum                                                     ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CT105LINOK(cCampo)
	
	Local aSaveArea	:= GetArea()
	Local cDCD			:= " "
	Local cDCC			:= " "
	Local cContCCD
	Local cContCCC
	Local cItemD
	Local cItemC
	Local cCLVLD
	Local cCLVLC
	Local cHist		:= TMP->CT2_HIST
	Local cDebito  	:= TMP->CT2_DEBITO
	Local cCredito 	:= TMP->CT2_CREDIT
	Local cDC      	:= TMP->CT2_DC
	Local cCriter	:= TMP->CT2_CONVER
	Local cLinha	:= TMP->CT2_LINHA
	
	Local lRet			:= .t.
	Local lDigito		:= .F.
	Local lOutMoed		:= .T.
	Local lVlrZerado	:= .T.
	Local lConverte		:= .F.
	Local lCt105LOK		:= Iif(ExistBlock("CT105LOK"),.T.,.F.)
	
	Local nOutVlr 		:= 0
	Local cConver		:= ""
	
	Local nCont
	Local nValor   	:= TMP->CT2_VALOR
	Local lRpc		:= Type("oMainWnd") <> "U"

	Default cCampo := ""

	If TMP->CT2_FLAG							//  Linha Deletada
		Return .t.
	EndIf
	
	If __lCusto									// Centro de custo
		cContCCD	:=	TMP->CT2_CCD
		cContCCC	:=	TMP->CT2_CCC
	EndIf
	If __lITem									// Item
		cItemD 	:= TMP->CT2_ITEMD
		cItemC 	:= TMP->CT2_ITEMC
	EndIf
	If __lCLVL									// Classe de Valor
		cClVLD	:= TMP->CT2_CLVLDB
		cCLVLC   := TMP->CT2_CLVLCR
	EndIf
	If CtbUso("CT2_DCD")						//  Digito de Controle
		cDCD  	:= TMP->CT2_DCD
		cDCC  	:= TMP->CT2_DCC
		lDigito	:= .T.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Tipo nao foi preenchido                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( cDC )
		If lRpc
			Help( " ", 1, "FALTATPLAN" )
		EndIf	
		cCampo := "CT2_DC"
		lRet   := .F.               
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Valor nao preenchido                                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .and. cDC <> "4"
		For nCont  	 := 2 To __nQuantas  
			nOutVlr := &("TMP->CT2_VALR"+StrZero(nCont,2))
			cConver	:= Subs(TMP->CT2_CONVER,nCont,1)
			//Verifico se existe criterio de conversao e se o valor esta zerado.                                                    		
			If nOutVlr = 0  .And. cConver <> '5'
				lOutMoed	:= .F.
			Endif                                   
			                                                   
			//Verifico se todos os valores estao zerados
			If nOutVlr <>  0  
				lVlrZerado	:= .F.
			EndiF             		
			
			If Subs(TMP->CT2_CONVER,nCont,1) <> '5'
				lConverte := .T.			
			EndIf
		Next
			
		If lRet .and. (nValor = 0 .And. (!lOutMoed .Or. lVlrZerado .Or. !lConverte))
			If lRpc
				Help( " ", 1, "FALTAVALOR" )
			EndIf
			cCampo := "CT2_VLR01"
			lRet   := .F.
		EndIf
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Historico nao preenchido                         								³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If Empty( cHist )
			If lRpc
				Help( " ", 1, "CTB105HIST" )
			EndIf
			cCampo := "CT2_HIST"
			lRet   := .F.
		EndIf
	EndIf                            
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se eh lancamento de historico complementar, nao pode ter valor.						³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If cDC == "4" .And. TMP->CT2_VALOR <> 0 
			If lRpc
				Help ( " " ,1, "CONTHIST")
			EndIf
			cCampo := "CT2_VLR01"
			lRet   := .F.		
		EndIf
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se eh lancamento de historico complementar, nao pode ter conta prenchida.			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 If lRet
		If cDC == "4" .And. (!Empty(TMP->CT2_DEBITO) .Or. !Empty(TMP->CT2_CREDIT) .Or. !Empty(TMP->CT2_CCD) .Or.!Empty(TMP->CT2_CCC) .Or. ;
								!Empty(TMP->CT2_ITEMD) .Or. !Empty(TMP->CT2_ITEMC) .Or. !Empty(TMP->CT2_CLVLDB) .OR. !Empty(TMP->CT2_CLVLCR)  )
			If lRpc
			Help( " ",1,"HISTNOENT")								
	   	 	EndIf
	   	 	If !Empty(TMP->CT2_DEBITO)
				cCampo := "CT2_DEBITO"
			ElseIf !Empty(TMP->CT2_CREDIT)
				cCampo := "CT2_CREDIT"
			ElseIf !Empty(TMP->CT2_CCD) 
				cCampo := "CT2_CCD"
			ElseIf !Empty(TMP->CT2_CCC) 
				cCampo := "CT2_CCC"
			ElseIf !Empty(TMP->CT2_ITEMD)
				cCampo := "CT2_ITEMD"
			ElseIf !Empty(TMP->CT2_ITEMC)
				cCampo := "CT2_ITEMC"
			ElseIf !Empty(TMP->CT2_CLVLDB)
				cCampo := "CT2_CLVLDB"
			ElseIf !Empty(TMP->CT2_CLVLCR)	
				cCampo := "CT2_CLVLCR"
			Endif
			lRet	:= .F.				
	    EndIf
	 EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bloco de Valida‡oes Lancamentos a Debito                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If cDC $ "13"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CONTA CONTABIL A DEBITO                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a conta foi preenchida                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty( cDebito )
				If lRpc
					Help(" ", 1, "FALTA DEB" )
				EndIf
				cCampo := "CT2_DEBITO" 
				lRet   := .F.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a conta existe e nao e sintetica                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				lRet:= ValidaConta(cDebito,"1",,,.T.,lRpc)
				If lRet
					If FunName() <> "CTBA102"								
						lRet := ValidaBloq(cDebito,dDataLanc,"CT1",lRpc)
					EndIf
				EndIf
				If !lRet
					cCampo := "CT2_DEBITO"
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ DIGITO DE CONTROLE - CONTA DEBITO                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If lDigito
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se lan‡amento e devedor e digito da conta nao preenchido                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Empty( cDCD )
						If lRpc
							Help( " ", 1, "DIG-DEBITO" )
						EndIf
						lRet := .F.
					ElseIf cDCD != CT1->CT1_DC
						If lRpc
							Help( " ", 1, "DIGITO" )
						EndIf
						lRet := .F.
					Endif
					If !lRet
						cCampo := "CT2_DCD"
					Endif
				EndIf
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CENTRO DE CUSTO - DEBITO                                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If __lCusto
					If lRet
						lRet:= ValidaCusto(cContCCD,"1",,,.T.,lRpc)
						If lRet
							If FunName() <> "CTBA102"										
								lRet := ValidaBloq(cContCCD,dDataLanc,"CTT",lRpc)
							EndIf
						EndIf
					Endif
					If !lRet
						cCampo := "CT2_CCD"
					Endif
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ITEM - DEBITO 		                                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If __lItem
					If lRet
						lRet:= ValidItem(cItemD,"1",,,.T.,lRpc)
						If lRet               
							If FunName() <> "CTBA102"										
								lRet := ValidaBloq(cItemD,dDataLanc,"CTD",lRpc)
							EndIf
						EndIf
					Endif
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CLASSE VALOR - DEBITO 		                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If __lCLVL
					If lRet
						lRet:= ValidaCLVL(cCLVLD,"1",,,.T.,lRpc)
						If lRet  
							If FunName() <> "CTBA102"										
								lRet := ValidaBloq(cCLVLD,dDataLanc,"CTH",lRpc)
						    EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se as amarracoes estao corretas                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				lRet := CtbAmarra(cDebito,cContCCD,cItemD,cCLVLD,.T.,lRpc)
			EndIf
			
   			// Valida Entidades Obrigatorias -> Ligacao entre Conta e demais entidades
			If lRet
				lRet := CtbObrig(cDebito,cContCCD,cItemD,cCLVLD,.T.,"1",lRpc)
			EndIf	

		Endif
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bloco de Valida‡oes Lancamentos a Credito                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If cDC $ "23"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CONTA CONTABIL A CREDITO                                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a conta foi preenchida                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty( cCredito )
				If lRpc
					Help( " ", 1, "FALTA CRD" )
				EndIf
				cCampo := "CT2_CREDIT"
				lRet   := .F.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a conta existe e nao e sintetica                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				lRet := ValidaConta(cCredito,"2",,,.T.,lRpc)
				If lRet          
					If FunName() <> "CTBA102"								
						lRet := ValidaBloq(cCredito,dDataLanc,"CT1",lRpc)
					EndIf
				EndIf
				If !lRet
					cCampo := "CT2_CREDIT"
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ DIGITO DE CONTROLE - CONTA CREDITO                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If lDigito
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se lan‡amento ‚ credor e digito da conta nao preenchido                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Empty( cDCC )
						If lRpc
							Help( " ", 1, "DIG-CREDIT" )
						EndIf
						lRet := .F.
					ElseIf cDCC != CT1->CT1_DC
						If lRpc
							Help( " ", 1, "DIGITO" )
						EndIf
						lRet := .F.
					Endif
					If !lRet
						cCampo := "CT2_DCC"
					Endif
				Endif
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CENTRO DE CUSTO - CREDITO                                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If __lCusto
					If lRet
						lRet:= ValidaCusto(cContCCC,"2",,,.T.,lRpc)
						If lRet
							If FunName() <> "CTBA102"										
								lRet := ValidaBloq(cContCCC,dDataLanc,"CTT",lRpc)
							EndIf
						EndIf
					Endif
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ITEM - CREDITO		                                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If __lItem
					If lRet
						lRet:= ValidItem(cItemC,"2",,,.T.,lRpc)
						If lRet               
							If FunName() <> "CTBA102"							   				
								lRet := ValidaBloq(cItemC,dDataLanc,"CTD",lRpc)
							EndIf
						EndIf
					Endif
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CLASSE VALOR - CREDITO		                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If __lCLVL
					If lRet
						lRet:= ValidaCLVL(cCLVLC,"2",,,.T.,lRpc)
						If lRet  
							If FunName() <> "CTBA102"										
								lRet := ValidaBloq(cCLVLC,dDataLanc,"CTH",lRpc)
							EndIf							
						EndIf
					EndIf
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se as amarracoes estao corretas                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				lRet := CtbAmarra(cCredito,cContCCC,cItemC,cCLVLC,.T.,lRpc)
			EndIf
			
			// Valida Entidades Obrigatorias -> Ligacao entre Conta e demais entidades
			If lRet
				lRet := CtbObrig(cCredito,cContCCC,cItemC,cCLVLC,.T.,"2",lRpc)
			EndIf	

		Endif
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se as moedas foram informados corretamente ( 1=S ou 2=N )                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lRet
		If SubStr( cCriter, 1, 1 ) = "5"
			For nCont := 2 to __nQuantas
				cSuf := StrZero(nCont,2)
				If SubStr( cCriter, nCont, 1 ) == "1" .and. cDC != "4" .and. &( 'TMP->CT2_VALR'+cSuf ) > 0
					If &( 'TMP->CT2_VALR'+cSuf ) == 0
						If lRpc
							Help( " ", 1, "SEMVALUS$" )
						EndIf
						lRet := .F.
					Endif
				Endif
			Next
		Endif
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validar Lancamentos com Contas Credito/Debito Iguais                                ³
	//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If (cDebito == cCredito) .And. cDC == "3"
			If __lCusto .And. __lItem .And. __lCLVL
				If (cContCCD == cContCCC) .And. (cItemD == cItemC) .And. ;
					(cCLVLD == cCLVLC)
					If lRpc
						Help(" ",1,"CTAEQUA123")
					EndIf
					lRet := .F.
				EndIf
			ElseIf (__lCusto .And. __lItem)
				If (cContCCD == cContCCC) .And. (cItemD == cItemC)
					If lRpc
						Help(" ",1,"CTAEQUA123")
					EndIf
					lRet := .F.
				EndIf
			ElseIf (__lCusto .And. __lCLVL)
				If (cContCCD == cContCCC) .And. (cCLVLD == cCLVLC)
					If lRpc
						Help(" ",1,"CTAEQUA123")
					EndIf
					lRet := .F.
				EndIf
			ElseIf ( __lItem .And. __lCLVL)
				If (cItemD == cItemC) .And. (cCLVLD == cCLVLC)
					If lRpc
						Help(" ",1,"CTAEQUA123")
					EndIf
					lRet := .F.
				EndIf
			ElseIf __lCusto
				If (cContCCD == cContCCC)
					If lRpc
						Help(" ",1,"CTAEQUA123")
					EndIf
					lRet := .F.					
				EndIf
			ElseIf __lItem
				If (cItemD == cItemC)
					If lRpc
						Help(" ",1,"CTAEQUA123")
					Endif
					lRet := .F.					
				EndIf
			ElseIf __lCLVL
				If (cCLVLD == cCLVLC)
					If lRpc
				 		Help(" ",1,"CTAEQUA123")
					EndIf
					lRet := .F.					
				EndIf
			EndIf
		EndIf
	Endif
	
	If lRet
		
		// Valida Debito
		If cDC == "1"
			If !Empty(cDebito) .And. (Empty(cContCCD) .And. !Empty(cContCCC))
				If lRpc
					Help(" ",1,"NOCTADEB")
				EndIf
				lRet := .F.
			EndIf
			If lRet
				If !Empty(cDebito) .And. (Empty(cItemD) .And. !Empty(cItemC))
					If lRpc
						Help(" ",1,"NOCTADEB")
					EndIf
					lRet := .F.
				EndIf
			EndIf
			If lRet
				If !Empty(cDebito) .And. (Empty(cClVlD) .And. !Empty(cClVlC))
					If lRpc
						Help(" ",1,"NOCTADEB")
					EndIf
					lRet := .F.
				EndIf
			EndIf
			If !lRet
				cCampo := "CT2_DEBITO"
			Endif
		EndIf
		
		// Valida credito
		If cDC == "2"
			If !Empty(cCredito) .And. (Empty(cContCCC) .And. !Empty(cContCCD))
				If lRpc
					Help(" ",1,"NOCTACRD")
				EndIf
				lRet := .F.
			EndIf
			If lRet
				If !Empty(cCredito) .And. (Empty(cItemC) .And. !Empty(cItemD))
					If lRpc
						Help(" ",1,"NOCTACRD")
					Endif
					lRet := .F.
				EndIf
			EndIf
			If lRet
				If !Empty(cCredito) .And. (Empty(cClVlC) .And. !Empty(cClVlD))
					If lRpc
						Help(" ",1,"NOCTACRD")
					EndIf
					lRet := .F.
				EndIf
			EndIf
			If !lRet
				cCampo := "CT2_CREDIT"
			Endif
		EndIf
	EndIf
	
	If lRet	
		If lCt105LOK
			lRet := ExecBlock("CT105LOK",.F.,.F.)
		Endif		                                                     
	EndIf

	
	
	RestArea(aSaveArea)
	
	Return lRet
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CTB105TOK ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Valida toda MSGETDB                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ CT105TOk(lCT105TOK,lCT105CHK,lModified,lDigitacao)   	  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T./.F.                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpL1    =                                                  ³±±
	±±³          ³ExpL2    =                                                  ³±±
	±±³          ³ExpL3    = Se alterou                                       ³±±
	±±³          ³ExpL4    = Se apresenta mensagem de confirmacao             ³±±
	±±³          ³aTotRdpe = Array com os totais de rodape                    ³±±
	±±³          ³nTotInf  = Valor informado no total do documento            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CT105TOk(lCT105TOK,lCT105CHK,lModified,lConfirma,aTotRdpe,nTotInf)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis.                                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aSaveArea		:= GetArea()
	Local lRet			:= .T.
	Local uTot 			:= CtbTotMov(.T.)
	Local nValDeb		:= 0
	Local nValCrd		:= 0
	Local lCt105OutM    := IIf(ExistBlock("CTB105OUTM"),.T.,.F.)
	Local aDebCrd		:= {}
	Local nPosTPSLD		:= 1
	DEFAULT lConfirma 	:= .T.

	If ValType(uTot) = "L"
		lRet := uTot
	Else
		nValDeb := uTot[1][2]
		nValCrd := uTot[1][3]
	Endif
	
	If lRet
		If Empty(cSubLote)
			MsgAlert(STR0018)	//"O Sublote nao pode ficar em branco. Favor preenche-lo."
			lRet	:= .F.
		EndIf
	Endif
	
	If lRet
		IF NoRound(Round(nValDeb,3)) != NoRound(Round(nValCrd,3))
			If aMvs[MV_CONTSB] = Nil
				aMvs[MV_CONTSB] 	:= GetMv("MV_CONTSB") == "N"
				aMvs[MV_CONTBAT] 	:= GetMv("MV_CONTBAT") == "S"
			Endif
			If aMvs[MV_CONTSB]
				If aMvs[MV_CONTBAT]		// So grava quando DOC batido
					If lConfirma
						Help(" ",1,"DOCNOBAT")
					Endif
					lRet := .F.
				Else
					If !lCT105TOK
						If lConfirma
							lRet := MsgYesNo(OemToAnsi(STR0010),OemToAnsi(STR0011))   //"D‚bito e Cr‚dito n„o conferem !, Aceita Lan‡amento "###"Aten‡„o"
						Else
							lRet := .F.
						Endif
					Else
						CT6->(MsSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+"01"))
						lRet := ExecBlock("CT105TOK",.f.,.f.,{nValDeb,nValCrd,;
																aTotRdpe[1][1],;
																nTotInf })
					Endif
					If lRet .And. aMvs[MV_PRELAN] = "D"
						__PreLan := .T.	// Caso MV_PRELAN estiver indicado para
					Endif					// Documentos inconsistentes
				EndIf
			EndIf
		EndIf
	EndIf
	
	If lRet .and. GetNewPar("MV_CONTSLD","S") == "S"
		dbSelectArea("TMP")
		nRecTMP := TMP->(Recno())
		dbGoTop()
		While TMP->(!Eof())
			If !TMP->CT2_FLAG .and. TMP->CT2_DC <> "4"	/// SE NÃO ESTIVER DELETADO E NAO FOR HIST.
				If TMP->CT2_DC$"13"
					nVLRDEB	:= TMP->CT2_VALOR
				Else
					nVLRDEB	:= 0				
				Endif
				If TMP->CT2_DC$"23"
					nVLRCRD	:= TMP->CT2_VALOR
				Else
					nVLRCRD	:= 0
				Endif
				nPosTPSLD := Ascan(aDebCrd,{|x| x[1] == TMP->CT2_TPSALD})
				If nPosTpSLD > 0
					aDebCrd[nPosTpSLD][2] := aDebCrd[nPosTpSLD][2] + nVLRDEB
					aDebCrd[nPosTpSLD][3] := aDebCrd[nPosTpSLD][3] + nVLRCRD
				Else
					aAdd(aDebCrd,{TMP->CT2_TPSALD,nVLRDEB,nVLRCRD})
				Endif
			Endif
			TMP->(dbSkip())
		EndDo
		TMP->(MsGoTo(nRecTMP))
		For nPosTPSLD := 1 to Len(aDebCrd)
			If NoRound(Round(aDebCrd[nPosTPSLD,2],3)) != NoRound(Round(aDebCrd[nPosTPSLD,3],3))		
				lRet := .F.
			Endif						
		Next
		If !lRet
			If aMvs[MV_CONTSB] = Nil
				aMvs[MV_CONTSB] 	:= GetMv("MV_CONTSB") == "N"
				aMvs[MV_CONTBAT] 	:= GetMv("MV_CONTBAT") == "S"
			Endif
			If aMvs[MV_CONTSB]
				If aMvs[MV_CONTBAT]		// So grava quando DOC batido
					If lConfirma
						Help(" ",1,"DOCNOBAT")
					Endif
					lRet := .F.
				Else   
					If !lCT105TOK
						If lConfirma
							lRet := MsgYesNo(OemToAnsi(STR0010),OemToAnsi(STR0011))   //"D‚bito e Cr‚dito n„o conferem !, Aceita Lan‡amento "###"Aten‡„o"
						Else
							lRet := .F.
						Endif
					Endif
					If lRet .And. aMvs[MV_PRELAN] = "D"
						__PreLan := .T.	// Caso MV_PRELAN estiver indicado para
					Endif					// Documentos inconsistentes
				EndIf
			Else
				lRet := .T.
			EndIf
		EndIf
	Endif
	
	If lRET
//		If lModified
			If lCT105CHK
				lRet := ExecBlock("CT105CHK",.F.,.F.,{lModified})
			EndIf
//		EndIf
	EndIf
	
	If lRet
		If lCt105OutM		
			lRet := ExecBlock("CTB105OUTM",.F.,.F.,{dDataLanc,cLote,cSubLote,cDoc})		
		EndIf
	EndIf
	
	If !CtbValiDt(3,dDataLanc)
		lRet	:= .F.
	EndIf
		
	If FunName() == "CTBA102" // No caso de lancamento manual, DEVE sempre manipular a getdados
		aMVS[MV_ALTLCTO] := .T.
	EndIf	            
	
	If ! lRet .And. ! aMVS[MV_ALTLCTO]		// Caso lancamento invalido mas nao poder
		__PreLan := .T.						// alterar, retorno verdadeiro para gravar
		Return .T.							// como pre-lancamento
	Endif									
	
	RestArea(aSaveArea)
	
	Return lRet

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CTBTotMov ³ Autor ³ Simone Mie Sato       ³ Data ³ 06.04.01 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Soma o valor do temporario de digitacao (Baseado no CTK)   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³CtbTotMov()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³aTotMov                                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function CTBTotMov(lTudoOk)
	
	Local aSaveArea	:= GetArea()
	Local aTotMov 	:= {{0,0,0}}
	Local lPartDob 	:= .T.
	Local nRecTmp	:= 0
	
	DEFAULT lTudoOk := .F.

	If aMvs[MV_SOMA] = Nil	 //Determina se o lancam. tipo 3 ira ser somado 1 ou 2 vezes
		aMvs[MV_SOMA] := GetMv("MV_SOMA")
	Endif
	
	dbSelectArea("TMP")
	nRecTmp	:= Recno()	
	DbGoTop()
	While ! Eof()
		If CT2_FLAG		// Nao le lancamentos deletados
			DbSkip()
			Loop
		Endif

		If lTudoOk .And. ! CT105LINOK()	// Valida a Linha do Lan‡amento pela CT105LinOk()
			Return .F.
		Endif
	
		If CT2_DC == '3' .OR. CT2_DC == '1'
			aTotMov[1][2] += CT2_VALOR		 		// Valor a Debito
		Endif
		If CT2_DC == '3' .OR. CT2_DC == '2'
			aTotMov[1][3] += CT2_VALOR				// Valor a Credito
		Endif

		//Se o tipo do lancamento e 3, verifica o parametro MV_SOMA:caso seja 1, soma 1 vez
		//Se for igual a 2, soma 2 vezes no valor digitado.
		If CT2_DC == '3'
			lPartDob := .T.
		Endif
		If lPartDob
			If aMvs[MV_SOMA] == 1
				aTotMov[1][1]+= CT2_VALOR
			Elseif aMvs[MV_SOMA] == 2
				aTotMov[1][1]+= (CT2_VALOR * 2)
			EndIf
		Else
			aTotMov[1][1]+= CT2_VALOR
		Endif
		dbSkip()
	End

	dbSelectArea("TMP")
	dbGoto(nRecTmp)	
	RestArea(aSaveArea)
	
	Return aTotMov
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Program   ³CT105ATRDP³ Autor ³ Simone Mie Sato       ³ Data ³ 28.05.01 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Atualizacao do Rodape, quando altera lote, data ou doc.	  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³Ct105AtRdp(dDataLanc,cLote,cSubLote,cDoc,aTotais,aTotRdPe)  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ .T./.F.		                                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³uso       ³ Generico                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpD1 = data do lancamento                                 ³±±
	±±³          ³ ExpC1 = Lote                                               ³±±
	±±³          ³ ExpC2 = SubLote                                            ³±±
	±±³          ³ ExpC3 = Documento                                          ³±±
	±±³          ³ ExpA1 = Array com os totais                                ³±±
	±±³          ³ ExpA2 = Array com os totais do rodape                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Function Ct105AtRdp(dDataLanc,cLote,cSubLote,cDoc,aTotais,aTotRdPe)
	
	Local aSaveArea := GetArea()
	Local lRet 		:= .T.
	
	aTotais         := Ctb050Tot(dDataLanc,cLote,cSubLote,cDoc)
	aTotRdPe[2]		:= CTBTotMov()[1]

	aTotRdPe[1][2] := aTotais[1][2] + aTotRdPe[2][2]
	aTotRdPe[1][3] := aTotais[1][3] + aTotRdPe[2][3]
	aTotRdPe[1][1] := aTotais[1][1] + aTotRdPe[2][1]
	
	//Atualiza o rodape (refresh)
	ctb050ImpT()
	
	RestArea(aSaveArea)
	
	Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTB105Rpc ³ Autor ³ Simone Mie Sato       ³ Data ³ 22.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida toda MSGETDB                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTB105RPC(lCT105TOK,lCT105CHK,lModified,lDigitacao)   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1    =                                                  ³±±
±±³          ³ExpL2    =                                                  ³±±
±±³          ³ExpL3    = Se alterou                                       ³±±
±±³          ³ExpL4    = Se apresenta mensagem de confirmacao             ³±±
±±³          ³aTotRdpe = Array com os totais de rodape                    ³±±
±±³          ³nTotInf  = Valor informado no total do documento            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB105Rpc(lDigita)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis.                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSaveArea		:= GetArea()
Local lRet			:= .T.
Local lCusto		:= CtbMovSaldo("CTT")
Local lItem 		:= CtbMovSaldo("CTD")
Local lClVl 		:= CtbMovSaldo("CTH")
Local lHelp			:= lDigita	
	
//Verificar se as contas existem
dbSelectArea("TMP")
dbGotop()	

While TMP->(!Eof())
	If TMP->CT2_FLAG		// Nao le lancamentos deletados
		TMP->(DbSkip())
		Loop
	Endif
		
	If TMP->CT2_DC $ "13"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CONTA CONTABIL A DEBITO                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a conta foi preenchida                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( TMP->CT2_DEBITO )
			lRet := .F.
		Endif           
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a conta existe e nao e sintetica                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			lRet:= ValidaConta(TMP->CT2_DEBITO,"1",,,.T.,.F.,lHelp)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CENTRO DE CUSTO - DEBITO                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			If lCusto
				lRet:= ValidaCusto(TMP->CT2_CCD,"1",,,.T.,.F.,lHelp)
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ITEM - DEBITO 		                                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			If lItem
				lRet:= ValidItem(TMP->CT2_ITEMD,"1",,,.T.,.F.,lHelp)
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CLASSE VALOR - DEBITO 		                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			If lCLVL
				lRet:= ValidaCLVL(TMP->CT2_CLVLDB,"1",,,.T.,.F.,lHelp)
			EndIf
		EndIf
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bloco de Valida‡oes Lancamentos a Credito                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If TMP->CT2_DC $ "23"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CONTA CONTABIL A CREDITO                                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a conta foi preenchida                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty( TMP->CT2_CREDIT )
				lRet := .F.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a conta existe e nao e sintetica                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				lRet := ValidaConta(TMP->CT2_CREDIT,"2",,,.T.,.F.,lHelp)
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CENTRO DE CUSTO - CREDITO                                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If lCusto
					lRet:= ValidaCusto(TMP->CT2_CCC,"2",,,.T.,.F.,lHelp)
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ITEM - CREDITO		                                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If lItem
					lRet:= ValidItem(TMP->CT2_ITEMC,"2",,,.T.,.F.,lHelp)
				EndIf
			EndIf                    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ CLASSE VALOR - CREDITO		                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet
				If lCLVL
					lRet:= ValidaCLVL(TMP->CT2_CLVLCR,"2",,,.T.,.F.,lHelp)
				EndIf
			EndIf
	
		EndIf	
	EndIf
	If !lRet 
		__PreLan := .T.						
		Return .F.							
	Endif												
	TMP->(dbSkip())
EndDo
	
	
RestArea(aSaveArea)
	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT105SDEL ºAutor  ³Marcos S. Lobo      º Data ³  04/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa a deleção de todas as linhas da tela de lancamentos º±±
±±º          ³contabeis (lancamento automatico).                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT105SDEL(nOpc)
Local lRet := .F.

If ValType(nOpc) <> "N" .or. nOpc == 2
	Return(lRet)
Endif

If MsgYesNo(STR0017)///"Deseja realmente deletar todas as linhas ?"
	dbSelectArea("TMP")
	dbGoTop()
	While !Eof()
		CT102DEL(nOpc)
		TMP->CT2_FLAG := .T.
		TMP->(dbSkip())
	EndDo
	dbSelectArea("TMP")
	dbGoTop()
	lRet := .T.
Endif
	
Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTB105Flt ³ Autor ³ Cristiano Denardi     ³ Data ³ 28.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca inconsistencias na GetDB e posiciona cursor          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTBA105                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB105Flt(oGetDb,lAvan)

Local nColPos 	:= oGetDb:oBrowse:nColPos
Local nRowPos	:= oGetDb:oBrowse:nAt
Local nMaxPos	:= oGetDb:oBrowse:nLen   
Local cCampo 	:=	""                                       
Local nLimite	:= 0
Local nSkip		:= 0
Local cMsg		:= ""

Default lAvan	:= .T.

nSkip	:= If(lAvan,1      ,-1)
nLimite := If(lAvan,nMaxPos, 1)

While ( lOk := CT105LINOK(@cCampo) )
	If ( oGetDb:oBrowse:nAt == nLimite )
		Exit
	Endif
	oGetDb:oBrowse:SKIP( nSkip )     
	oGetDb:oBrowse:Refresh()
Enddo

If lOk
	oGetDb:GoTo(nRowPos)	
	cMsg := STR0022 + If( lAvan, STR0023, STR0024 ) //"Nenhuma inconsistencia "###"abaixo"###"acima"
	MsgInfo( cMsg )
Else
	nColPos	:=	Ascan(aHeader,{|x| alltrim(x[2])==cCampo})
	If nColPos > 0
		oGetDb:oBrowse:nColPos := nColPos
	Endif
Endif
oGetDb:oBrowse:Refresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTB105FtBs³ Autor ³ Cristiano Denardi     ³ Data ³ 28.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtro generico para posicionar o cursor no registro exato ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTBA105                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB105FtBs(oGetDb,cFiltro,cTexto)

Local nColPos 	 := oGetDb:oBrowse:nColPos
Local nColPosOri := nColPos
Local nRowPos	 := oGetDb:oBrowse:nAt
Local nMaxPos	 := oGetDb:oBrowse:nLen   
Local cMsg		 := ""
Local cCampo 	 :=	""                                       
Local lFind		 := .F.
Local nOpc		 :=	1
Local aOpcoes	 :=	{STR0025,STR0026,STR0027,STR0028} //"Nova"###"Anterior"###"Proxima"###"Cancela"
					 
If !Empty(cFiltro)
	nOpc	:=	Aviso('Pesquisa',cTexto,aOpcoes)
Endif
If nOpc <> 4
	If Empty(cFiltro).Or. nOpc == 1
		aFiltro := CTB105FlTl("TMP",@cFiltro,@cTexto)
		cFiltro	:=	aFiltro[1]
		cTexto	:=	aFiltro[2]
		nOpc	:=	aFiltro[3]
	Endif
	If nOpc == 2
		nSkip	:=	-1
		nLimite	:=	1
	ElseIf nOpc == 3
		nSkip	:=	1
		nLimite	:=	nMaxPos
	ElseIf nOpc == 4
		Return
	Endif		
	
	If !Empty( cFiltro )
		oGetDb:oBrowse:SKIP(nSkip)
		While  !(lFind := &cFiltro)
			If oGetDb:oBrowse:nAt==nLimite
				Exit
			Endif	
			oGetDb:oBrowse:SKIP(nSkip)               
			oGetDb:oBrowse:Refresh()
		Enddo
	
		If !lFind    
			cMsg := STR0029 //"Nenhum lancamento encontrado "
			If nOpc == 2
				cMsg += STR0024 //"acima" 
			ElseIf nOpc == 3
				cMsg += STR0023 //"abaixo"
			Endif
			MsgInfo( cMsg ) 
			oGetDb:GoTo(nRowPos)
			oGetDb:oBrowse:nColPos := nColPosOri
		Else
			nColPos	:=	Ascan(aHeader,{|x| alltrim(x[2])==Alltrim(Left(cFiltro,10))})
			If nColPos > 0
				oGetDb:oBrowse:nColPos := nColPos
			Endif
		Endif
		oGetDb:oBrowse:Refresh()
	Endif
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTB105FlTl³ Autor ³ Cristiano Denardi     ³ Data ³ 28.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtro parecido com BuildExpr()							  ³±±
±±³          ³ Criado pela necessidade de se trabalhar com o Arq. TMP     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTBA105 e CTBA102                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTB105FlTl(cAl,cExpFil,cTxtFil)

Local oDlgPesq
Local oBtna , oBtn  , oBtnOp, oBtne, oBtnOu
Local oMatch, oCampo, oOper , oExpr, oTxtFil
Local aCpos		:= {}
Local aCampo	:= {}
Local aStrOp	:= {}
Local aStru		:= {}
Local cTitulo	:= ""
Local cCampo	:= ""
Local cExpr		:= ""
Local cOper		:= ""
Local nMatch 	:= 0
Local nA		:= 0
Local nOpc		:= 4

Private cAlias2	:= ""
Private cAlias	:= ""

Default cTxtFil := ""
Default cExpFil := ""
Default cAl		:= "TMP"
		cAlias	:= cAl
		cAlias2 := cAlias + "->"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Campos do Localizador ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nA := 1 to Len(aHeader)
	AADD( aCpos , aHeader[nA][1] )
	AADD( aCampo,{aHeader[nA][2],aHeader[nA][1],.T.,"01",aHeader[nA][4],If(Empty(aHeader[nA][3]),Space(45),aHeader[nA][3]),aHeader[nA][8],aHeader[nA][5]})
Next nA

cTitulo := STR0021 //"Localizar"

DEFINE MSDIALOG oDlgPesq TITLE OemToAnsi(cTitulo) FROM 000,000 TO 250,405 PIXEL

	aStrOp := { OemToAnsi(STR0030),OemToAnsi(STR0031),OemToAnsi(STR0032),OemToAnsi(STR0033),OemToAnsi(STR0034),OemToAnsi(STR0035),OemToAnsi(STR0036),OemToANsi(STR0037),OemToANsi(STR0038),OemToAnsi(STR0039)}	 
	//"Igual a"###"Diferente de"###"Menor que"###"Menor ou igual a"###"Maior que"###"Maior ou igual a"###"Cont‚m a express„o"###"N„o cont‚m"###"Est  contido em"###"N„o est  contido em"

	@ 05,005 SAY OemToAnsi(STR0040) SIZE 20,8 PIXEL OF oDlgPesq //"Campo:"
	@ 05,060 SAY OemToAnsi(STR0041) SIZE 30,8 PIXEL OF oDlgPesq //"Operador:"
	@ 05,115 SAY OemToAnsi(STR0042) SIZE 30,8 PIXEL OF oDlgPesq //"Express„o:"
	@ 50,005 SAY OemToAnsi(STR0043) SIZE 20,8 PIXEL OF oDlgPesq //"Filtro:"
	
	@ 35,005 BUTTON oBtna PROMPT OemToAnsi(STR0044) SIZE 35,10 OF oDlgPesq PIXEL ; //"&Adiciona"
		ACTION (cTxtFil := BuildTxt(cTxtFil,Trim(cCampo),cOper,cExpr,.t.,@cExpFil,aCampo,oCampo:nAt,oOper:nAt),cExpr := CalcField(oCampo:nAt,aCampo),BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlgPesq),oTxtFil:Refresh(),oBtne:Enable(),oBtnOp:Disable(),oBtnOu:Enable(),oBtna:Disable(),oBtne:Refresh(),oBtnou:Refresh(),oBtna:Refresh()) ;
		FONT oDlgPesq:oFont
	
	@ 35,45 BUTTON oBtn PROMPT OemToAnsi(STR0045) SIZE 35,10 OF oDlgPesq PIXEL ; //"&Limpa Filtro"
		ACTION (cTxtFil := "",cExpFil := "",nMatch := 0,oTxtFil:Refresh(),oBtnA:Enable(),oBtnE:Disable(),oBtnOu:Disable(),oMatch:Disable(),oBtnOp:Enable()) ;
		FONT oDlgPesq:oFont
	
	@ 30,175 BUTTON oBtnOp PROMPT OemToAnsi("(") SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont ;
		ACTION (If(nMatch==0,oMatch:Enable(),nil),nMatch++,cTxtFil+= " ( ",cExpFil+="(",oTxtFil:Refresh()) ;
	
	@ 30,190 BUTTON oMatch PROMPT OemToAnsi(")") SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont;
		ACTION (nMatch--,cTxtFil+= " ) ",cExpFil+=")",If(nMatch==0,oMatch:Disable(),nil),oTxtFil:Refresh()) ;
	
	@ 45,175 BUTTON oBtne PROMPT OemToAnsi(STR0046) SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont; //" E "
		ACTION (cTxtFil+=STR0046,cExpFil += ".and.",oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtna:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtna:Refresh(),oBtnOp:Enable()) ; //" e "
	
	@ 45,190 BUTTON oBtnOu PROMPT OemToAnsi(STR0047) SIZE 12,12 OF oDlgPesq PIXEL FONT oDlgPesq:oFont; //" OU "
		ACTION (cTxtFil+=STR0047,cExpFil += ".or.",oTxtFil:Refresh(),oBtne:Disable(),oBtnou:Disable(),oBtna:Enable(),oBtne:Refresh(),oBtnou:Refresh(),oBtna:Refresh(),oBtnOp:Enable()) //" ou "
	oMatch:Disable()
	
	cCampo := aCpos[1]
	@ 15,05 COMBOBOX oCampo VAR cCampo ITEMS aCpos SIZE 50,50 OF oDlgPesq PIXEL;
		ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlgPesq,,oOper:nAt)
	cExpr := CalcField(oCampo:nAt,aCampo)
	cOper := aStrOp[1]
	
	@ 15,60 COMBOBOX oOper VAR cOper ITEMS aStrOp SIZE 50,50 OF oDlgPesq PIXEL;
		ON CHANGE BuildGet(oExpr,@cExpr,aCampo,oCampo,oDlgPesq,,oOper:nAt)
	
`	@ 15,115 MSGET oExpr VAR cExpr SIZE 85,10 PIXEL OF oDlgPesq PICTURE AllTrim(aCampo[oCampo:nAt,6]) FONT oDlgPesq:oFont
	
	@ 60,05 GET oTxtFil VAR cTxtFil MEMO SIZE 195,40 PIXEL OF oDlgPesq READONLY
	oTxtFil:bRClicked := {||AlwaysTrue()}
	
	If Empty(cExpFil) .And. Empty(cTxtFil)
		oBtne:Disable()
		oBtnou:Disable() 
	Else
		oBtna:Disable()
		oBtnOp:Disable()
		oMatch:Disable()
	Endif
	
	DEFINE SBUTTON o1 FROM 113,115  TYPE 20  ACTION (nOpc:=2,ValidText(@cExpFil,@cTxtFil),oDlgPesq:End()) OF oDlgPesq When .T.
	DEFINE SBUTTON o2 FROM 113,145  TYPE 19  ACTION (nOpc:=3,ValidText(@cExpFil,@cTxtFil),oDlgPesq:End()) OF oDlgPesq When .T.
	DEFINE SBUTTON o3 FROM 113,175  TYPE 02  ACTION (nOpc:=4                              ,oDlgPesq:End()) OF oDlgPesq When .T.
	
	o1:cToolTip := STR0048 //"Localizar Anterior"
	o2:cToolTip := STR0049 //"Localizar Proximo"

ACTIVATE MSDIALOG oDlgPesq CENTERED

Return {cExpFil,cTxtFil,nOpc }

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³BuildTxt  ³ Autor ³ Cristiano Denardi     ³ Data ³ 28.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTB105FlTl                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BuildTxt(cTxtFil,cCampo,cOper,xExpr,lAnd,cExpFil,aCampo,nCpo,nOper)
Local cChar := OemToAnsi(CHR(39))
Local cType := ValType(xExpr)
Local aOper := { "==","!=","<","<=",">",">=","..","!.","$","!x"}

cTxtFil += cCampo+" "+cOper+" "+If(cType=="C",cChar,"")+cValToChar(xExpr)+If(cType=="C",cChar,"")

If cType == "C"
	#ifndef TOP
	If aOper[nOper] == "!."    //  Nao Contem
		cExpFil += '!('+'"'+AllTrim(cValToChar(xExpr))+'"'+' $ AllTrim('+aCampo[nCpo,1]+'))'   // Inverte Posicoes
	ElseIf aOper[nOper] == "!x"   // Nao esta contido
		cExpFil += '!(AllTrim('+aCampo[nCpo,1]+") $ " + '"'+AllTrim(cValToChar(xExpr))+'")'
	ElseIf aOper[nOper]	== ".."  // Contem a Expressao
		cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'+" $ AllTrim("+aCampo[nCpo,1] +" )"   // Inverte Posicoes
	#else
	If  aOper[nOper] == "!."    //  Nao Contem
		cExpFil += '!('+'"'+AllTrim(cValToChar(xExpr))+'"'+' $ '+aCampo[nCpo,1]+')'   // Inverte Posicoes
	ElseIf aOper[nOper] == "!x"   // Nao esta contido
		cExpFil += '!('+aCampo[nCpo,1]+" $ " + '"'+AllTrim(cValToChar(xExpr))+'")'
	ElseIf aOper[nOper]	== ".."  // Contem a Expressao
		cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'+" $ "+aCampo[nCpo,1] +" "   // Inverte Posicoes
	#endif
	Else
		#ifndef TOP
			If (aOper[nOper]=="==")
				cExpFil += aCampo[nCpo,1] +aOper[nOper]+" "
				cExpFil += '"'+cValToChar(xExpr)+'"'
			Else
				cExpFil += 'Alltrim('+aCampo[nCpo,1] +')' +aOper[nOper]+" "
				cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'
			EndIf
		#else
			If (aOper[nOper]=="==")
				cExpFil += aCampo[nCpo,1] +aOper[nOper]+" "
				cExpFil += '"'+cValToChar(xExpr)+'"'
			Else
				cExpFil += 'Alltrim('+aCampo[nCpo,1] +')' +aOper[nOper]+" "
				cExpFil += '"'+AllTrim(cValToChar(xExpr))+'"'
			EndIf
		#endif
	EndIf
ElseIf cType == "D"
	// Nao Mexer, deixar dToS pois e'a FLAG Para Limpeza do Filtro
	// 						 
	cExpFil += "dToS("+aCampo[nCpo,1]+") "+aOper[nOper]+' "'
	cExpFil += Dtos(CTOD(cValToChar(xExpr)))+'"'
Else
	cExpFil += aCampo[nCpo,1]+" "+aOper[nOper]+" "
	cExpFil += cValToChar(xExpr)
EndIf

Return cTxtFil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CalcField ³ Autor ³ Cristiano Denardi     ³ Data ³ 28.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTB105FlTl                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CalcField(nAt,aCampo)

Local cRet

If aCampo[nAt,7] == "C"
	cRet := Space(aCampo[nAt,5])
ElseIf aCampo[nAt,7] == "N"
	cRet := 0
ElseIf aCampo[nAt,7] == "D"
	cRet := CTOD("  /  /  ")
EndIf

Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ValidText ³ Autor ³ Cristiano Denardi     ³ Data ³ 28.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta experessao de busca para que nao gere error.log     ³±±
±±³          ³ de Invalid Macro por inconsistencia.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTB105FlTl                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidText(cExp,cTxt)

Local lValid := .F.	

Default cExp := ""
Default cTxt := ""

If !Empty(cExp) .And. !Empty(cTxt)
	While !lValid
		Do Case
			Case Right(cTxt,2) == "( "  
				cTxt := Left( cTxt, Len(cTxt)-3 )
			Case Right(cTxt,2) == "E "
				cTxt := Left( cTxt, Len(cTxt)-3 )
			Case Right(cTxt,3) == "OU "
				cTxt := Left( cTxt, Len(cTxt)-4 )
			Case Right(cExp,1) == "("
				cExp := Left( cExp, Len(cExp)-1 )
			Case Right(cExp,5) == ".and."	
				cExp := Left( cExp, Len(cExp)-5 )
			Case Right(cExp,4) == ".or."	
				cExp := Left( cExp, Len(cExp)-4 )
			Otherwise
				lValid := .T.
		End Case
	EndDo
Endif

Return
