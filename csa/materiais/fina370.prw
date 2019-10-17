//#INCLUDE "FINA370.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FINA370	� Autor � Wagner Xavier 		  � Data � 24/08/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Lan�amentos Cont�beis Off-Line					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FINA370()																  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � SIGAFIN																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FinA370(lDireto)

//��������������������������������������������������������������Ŀ
//� Define Vari�veis 														  �
//����������������������������������������������������������������
LOCAL nOpca := 0
Local aSays:={}, aButtons:={}

DEFAULT lDireto		:= .F.
PRIVATE cCadastro 	:= "Contabilizacao Off Line"
PRIVATE LanceiCtb 	:= .F.

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros								  �
//� mv_par01 // Mostra Lan�amentos Cont�beis 						  �
//� mv_par02 // Aglutina Lan�amentos Cont�beis						  �
//� mv_par03 // Emissao / Data Base 									  �
//� mv_par04 // Data Inicio												  �
//� mv_par05 // Data Fim													  �
//� mv_par06 // Carteira : Receber / Pagar /Cheque / Ambas 		  �
//� mv_par07 // Baixas por Data de Emiss�o ou Digita��o			  �
//� mv_par08 // Considera filiais abaixo                         �
//� mv_par09 // Da Filial                                        �
//� mv_par10 // Ate a Filial                                     �
//� mv_par11 // Atualiza Sinteticas                              �
//� mv_par12 // Separa por ? (Periodo,Documento,Processo)        �
//� mv_par13 // Ctb Bordero - Total/Por Bordero                  �
//����������������������������������������������������������������


// Obs: este array aRotina foi inserido apenas para permitir o
// funcionamento das rotinas internas do advanced.
Private aRotina:={ 	{ "Localizar","AxPesqui" , 0 , 1},;  //"Localizar"
					{ "Pagar","fA100Pag" , 0 , 3},;  //"Pagar"
					{ "Receber","fA100Rec" , 0 , 3},;  //"Receber"
					{ "Excluir","fA100Can" , 0 , 5},;  //"Excluir"
					{ "Transferir","fA100Tran", 0 , 3},;  //"Transferir"
					{ "Classificar","fA100Clas", 0 , 5} }  //"Classificar"

PRIVATE lCabecalho
PRIVATE VALOR     := 0
PRIVATE VALOR6		:= 0
PRIVATE VALOR7		:= 0

// Variaveis utilizadas na contabilizacao do modulo SigaFin
// declarada neste ponto, caso o acesso seja feito via SigaAdv

Debito  	:= ""
Credito 	:= ""
CustoD		:= ""
CustoC		:= ""
ItemD 		:= ""
ItemC 		:= ""
CLVLD		:= ""
CLVLC		:= ""

Conta		:= ""
Custo 		:= ""	
Historico 	:= ""
ITEM		:= ""
CLVL		:= ""

Abatimento  := 0
REGVALOR    := 0
STRLCTPAD 	:= ""		//para contabilizar o historico do cheque
NUMCHEQUE 	:= ""		//para contabilizar o numero do cheque
ORIGCHEQ  	:= ""		//para contabilizar o Origem do cheque
cHist190La 	:= ""
Variacao	:= 0
dDataUser	:= MsDate()

If IsBlind() .Or. lDireto
	BatchProcess( 	cCadastro, "  Este programa tem como objetivo gerar Lan�amentos Cont�beis Off para t�tulos" + Chr(13) + Chr(10) +;
								"emitidos e/ou baixas efetuadas.", "FIN370",;
					{ || FA370Processa(.T.) }, { || .F. }) 
	Return .T.
Endif

pergunte("FIN370",.F.)

AADD(aSays,"  Este programa tem como objetivo gerar Lan�amentos Cont�beis Off para t�tulos")
AADD(aSays,"emitidos e/ou baixas efetuadas.")
AADD(aButtons, { 5,.T.,{|| Pergunte("FIN370",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
	Processa({|lEnd| FA370Processa()})  // Chamada da funcao de Contabilizacao Off-Line
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FA370Proc � Autor � Wagner Xavier 		  � Data � 24/08/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Lan�amentos Cont�beis Off-Line					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FINA370()																  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � SIGAFIN																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA370Processa(lBat)

//��������������������������������������������������������������Ŀ
//� Define Vari�veis 														  �
//����������������������������������������������������������������
LOCAL lPadrao,lAglut
LOCAL nTotal  :=0
LOCAL nHdlPrv :=0
LOCAL cArquivo:= ""
LOCAL cPadrao
LOCAL nValLiq	:=0
LOCAL nDescont	:=0
LOCAL nJuros	:=0
LOCAL nMulta	:=0
LOCAL nCorrec	:=0
LOCAL nVl
LOCAL nDc
LOCAL nJr
LOCAL nMt
LOCAL nCm
LOCAL lTitulo := .F.
LOCAL dDataAnt:= dDataBase
LOCAL dDataini:= dDataBase
LOCAL nPeriodo:= 0
LOCAL nLaco   := 0
LOCAL cIndex, cIndSE2
LOCAL cChave
LOCAL cFor
LOCAL nIndex, nIndSE2
LOCAL nReg
LOCAL nRegSE5 := 0
LOCAL nRegOrigSE5 := 0
LOCAL lX := .f.
LOCAL lAdiant := .F.
LOCAL nProxReg := 0
LOCAL nRegEmp  := SM0->(Recno())
LOCAL lLerSE1  := .T.
LOCAL lLerSE2  := .T.
LOCAL lLerSE5  := .T.
LOCAL lLerSEF  := .T.
LOCAL lLerSEU  := .T.
LOCAL lEstorno := .F.
LOCAL lEstRaNcc := .F.
LOCAL lEstPaNdf := .F.
LOCAL lEstCart2 := .F.
LOCAL cCtBaixa := Getmv("MV_CTBAIXA")
LOCAL nLacoTrf := 0
LOCAL aTrf	:= {}
LOCAL nValorTotal := 0
LOCAL l370E5R := Existblock("F370E5R")
LOCAL l370E5P := Existblock("F370E5P")
LOCAL l370E5T := Existblock("F370E5T")
LOCAL l370E1FIL := Existblock("F370E1F")   // Criado Ponto de Entrada
LOCAL l370E2FIL := Existblock("F370E2F")   // Criado Ponto de Entrada
LOCAL l370E5FIL := Existblock("F370E5F")   // Criado Ponto de Entrada
LOCAL l370EFFIL := Existblock("F370EFF")   // Criado Ponto de Entrada
LOCAL l370EUFIL := Existblock("F370EUF")   // Criado Ponto de Entrada
LOCAL lF370NATP := Existblock("F370EUF")   // Criado Ponto de Entrada
LOCAL nRegAnt 
Local bCampo, nOrderSEU
Local cChaveSev
Local cChaveSeZ
Local nRecSe1
Local nRecSe2
Local cNumBor, cProxBor, nBordero, nTotBord, nBordDc, nBordJr, nBordMt, nBordCm
Local nTotDoc 	:= 0
Local nTotProc 	:= 0
LOCAL lPadraoCC
LOCAL lSkipLct := .F.
LOCAL cSitOri := " "
lOCAL cSitCob := " "
Local lCtbPls := .F.
Local cSeqSE5
Local lPadraoCCE 
Local cPadraoCC

DEFAULT lBat	:= .F.

Private cCampo
Private Inclui := .T.
Private cLote	:= Space( 4)

If ! CtbInUse() .And.;
  (!(mv_par04 >= GetMv("MV_DATADE") .And. mv_par04 <= GetMv("MV_DATAATE")) .Or.;
   !(mv_par05 >= GetMv("MV_DATADE") .And. mv_par05 <= GetMv("MV_DATAATE")))
	HELP(" ",1,"DATACOMPET")
	Return .F.
Endif

cFilDe := cFilAnt
cFilAte:= cFilAnt

If mv_par08 == 1
	cFilDe := mv_par09
	cFilAte:= mv_par10
Endif

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros								  �
//� mv_par01 // Mostra Lan�amentos Cont�beis 						  �
//� mv_par02 // Aglutina Lan�amentos Cont�beis						  �
//� mv_par03 // Emissao / Data Base 									  �
//� mv_par04 // Data Inicio												  �
//� mv_par05 // Data Fim													  �
//� mv_par06 // Carteira : Receber / Pagar /Cheque / Ambas 		  �
//� mv_par07 // Baixas por Data de Emiss�o ou Digita��o			  �
//����������������������������������������������������������������
dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	cFilAnt := M0_CODFIL		// Mudar filial atual temporariamente

	If lLerSe5
		dbSelectArea("SE5")
		cIndex := CriaTrab(,.f.)
		IF  mv_par07 == 1
			cChave := "E5_FILIAL+E5_RECPAG+Dtos(E5_DATA )+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
			#IFNDEF TOP
				cFor := 'dtos(E5_DATA) >= "'+dtos(mv_par04)+'" .and. dtos(E5_DATA) <= "'+dtos(mv_par05)+'" .and. '
				cFor += 'E5_LA < "S " .and. E5_SITUACA <> "C" .and. E5_TIPODOC $ "PA/RA/BA/VL/V2/DC/D2/JR/J2/MT/M2/CM/C2/AP/EP/PE/RF/IF/CP/TL/ES/TR/DB/OD/LJ/E2/TE/PE  "'
				cFor += ' .and. E5_FILIAL == "'+xFilial("SE5")+'"'
			#ELSE
				cFor := 'DTOS(E5_DATA) >= "'+dtos(mv_par04)+'" .and. DTOS(E5_DATA) <= "'+dtos(mv_par05)+'" .and. '
				cFor += 'E5_LA < "S " .and. E5_SITUACA <> "C" .and. E5_TIPODOC $ "PA/RA/BA/VL/V2/DC/D2/JR/J2/MT/M2/CM/C2/AP/EP/PE/RF/IF/CP/TL/ES/TR/DB/OD/LJ/E2/TE/PE  "'
				cFor += ' .and. E5_FILIAL == "'+xFilial("SE5")+'"'
			#ENDIF
		Else
			cChave := "E5_FILIAL+E5_RECPAG+Dtos(E5_DTDIGIT )+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
			#IFNDEF TOP
				cFor := 'dtos(E5_DTDIGIT) >= "'+dtos(mv_par04)+'" .and. dtos(E5_DTDIGIT) <= "'+dtos(mv_par05)+'" .and. '
				cFor += 'E5_LA < "S " .and. E5_SITUACA <> "C" .and. E5_TIPODOC $ "PA/RA/BA/VL/V2/DC/D2/JR/J2/MT/M2/CM/C2/AP/EP/PE/RF/IF/CP/TL/ES/TR/DB/OD/LJ/E2/TE/PE  "'
				cFor += ' .and. E5_FILIAL == "'+xFilial("SE5")+'"'
			#ELSE
				cFor := 'DTOS(E5_DTDIGIT) >= "'+dtos(mv_par04)+'" .and. DTOS(E5_DTDIGIT) <= "'+dtos(mv_par05)+'" .and. '
				cFor += 'E5_LA < "S " .and. E5_SITUACA <> "C" .and. E5_TIPODOC $ "PA/RA/BA/VL/V2/DC/D2/JR/J2/MT/M2/CM/C2/AP/EP/PE/RF/IF/CP/TL/ES/TR/DB/OD/LJ/E2/TE/PE  "'
				cFor += ' .and. E5_FILIAL == "'+xFilial("SE5")+'"'
			#ENDIF
		Endif

		//�������������������������������������������������Ŀ
		//� Ponto de Entrada para filtrar registros do SE5. �
		//���������������������������������������������������
		If l370E5FIL
			cFor := Execblock("F370E5F",.F.,.F.,cFor)
		EndIf

		dbSelectArea("SE5")
		IndRegua("SE5",cIndex,cChave,,cFor,"Selecionando Registros...")
		nIndex := RetIndex("SE5")
		#IFNDEF TOP
			dbSetIndex(cIndex+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()
	Endif

	//�����������������������������������������������������Ŀ
	//� Contabiliza pelo E2_EMIS1 - CONTAS PAGAR   			  �
	//�������������������������������������������������������
	If (mv_par06 = 2 .Or. mv_par06 = 4) .and. lLerSe2
		cIndSE2 := CriaTrab(,.f.)
		dbSelectArea("SE2")
		cChave := "E2_FILIAL+DTOS(E2_EMIS1)+E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
		#IFNDEF TOP
			cFor := 'dtos(E2_EMIS1) >= "'+dtos(mv_par04)+'" .and. dtos(E2_EMIS1) <= "'+dtos(mv_par05)+'" .and. '
			cFor += 'E2_LA <> "S" .and. E2_FILIAL == "'+xFilial("SE2")+'"'
		#ELSE
			cFor := 'DTOS(E2_EMIS1) >= "'+dtos(mv_par04)+'" .and. DTOS(E2_EMIS1) <= "'+dtos(mv_par05)+'" .and. '
			cFor += 'E2_LA <> "S" .and. E2_FILIAL == "'+xFilial("SE2")+'"'
		#ENDIF

      //�������������������������������������������������Ŀ
      //� Ponto de Entrada para filtrar registros do SE2. �
      //���������������������������������������������������
      If l370E2FIL
         cFor := Execblock("F370E2F",.F.,.F.,cFor)
      EndIf

		dbSelectArea("SE2")
		#IFDEF TOP
			ChkFile("SE2",.f.,"TRBSE2")
			IndRegua("TRBSE2",cIndSE2,cChave,,cFor,"Selecionando Registros...")
			nIndSE2 := -1
			dbSelectArea("TRBSE2")
		#ELSE
			IndRegua("SE2",cIndSE2,cChave,,cFor,"Selecionando Registros...")
			nIndSE2 := RetIndex("SE2")
			dbSelectArea("SE2")
			dbSetIndex(cIndSE2+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndSE2+1)
		dbSeek(xFilial("SE2"))
	Endif
	
	If (mv_par06 = 3 .Or. mv_par06 = 4 ) .and. lLerSef
		//--Arquivo de Cheque SEF
		cIndSEF := CriaTrab(,.f.)
		cChave := "EF_FILIAL+EF_BANCO+EF_AGENCIA+DTOS(EF_DATA)"
		#IFNDEF TOP
			cFor := 'dtos(EF_DATA) >= "'+dtos(mv_par04)+'" .and. dtos(EF_DATA) <= "'+dtos(mv_par05)+'" .and. '
			cFor += 'EF_LA <> "S" .and. EF_FILIAL == "'+xFilial("SEF")+'"'
		#ELSE
			cFor := 'DTOS(EF_DATA) >= "'+dtos(mv_par04)+'" .and. DTOS(EF_DATA) <= "'+dtos(mv_par05)+'" .and. '
			cFor += 'EF_LA <> "S" .and. EF_FILIAL == "'+xFilial("SEF")+'"'
		#ENDIF

      //�������������������������������������������������Ŀ
      //� Ponto de Entrada para filtrar registros do SEF. �
      //���������������������������������������������������
      If l370EFFIL
         cFor := Execblock("F370EFF",.F.,.F.,cFor)
      EndIf

		dbSelectArea("SEF")
		IndRegua("SEF",cIndSEF,cChave,,cFor,"Selecionando Registros...")
		nIndSEF := RetIndex("SEF")
		#IFNDEF TOP
			dbSetIndex(cIndSEF+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndSEF+1)
		dbGoTop()
	EndIf

	//��������������������������������������������������������������Ŀ
	//� La�o da contabiliza��o dia a dia, pela emiss�o (mv_par03 = 1)�
	//� ou pela database.														  �
	//����������������������������������������������������������������
	If mv_par03 == 1
		nPeriodo := mv_par05 - mv_par04 + 1 // Data Final - Data inicial
		nPeriodo := Iif( nPeriodo == 0, 1, nPeriodo )
	Else
		nPeriodo := 1
	Endif

	dDataIni := mv_par04

	BEGIN SEQUENCE

        If ! lBat
			ProcRegua(nPeriodo)
		Endif
		For nLaco := 1 to nPeriodo

	        If ! lBat
				IncProc()
			Endif
			dbSelectArea( "SE1" )

			nTotal:=0
			nHdlPrv:=0
			lCabecalho:=.F.

			//��������������������������������������������������������������Ŀ
			//� Se a contabiliza��o for pela data de emiss�o, altera o valor �
			//� da data-base e dos par�metros, para efetuar a contabiliza��o �
			//� e a sele��o dos registros respectivamente.						  �
			//����������������������������������������������������������������
			If mv_par03 == 1
				dDataBase := dDataIni + nLaco - 1
				mv_par04 := dDataBase
				mv_par05 := dDataBase
			Endif

			//��������������������������������������������������������������Ŀ
			//� Verifica o N�mero do Lote 											  �
			//����������������������������������������������������������������
			dbSelectArea( "SX5" )
			dbSeek( cFilial+"09FIN" )
			cLote := Substr(X5Descri(),1,4)

			//������������������������������������������������������������������������Ŀ
			//� Verifica se � um EXECBLOCK e caso sendo, executa-o							�
			//��������������������������������������������������������������������������
			If At(UPPER("EXEC"),X5Descri()) > 0
				cLote := &(X5Descri())
			Endif

			If (mv_par06 == 1 .or. mv_par06 == 4) .and. lLerSe1
				//��������������������������������������������������������������Ŀ
				//� Contas a Receber - SE1990 										     �
				//����������������������������������������������������������������
				dbSelectArea( "SE1" )
				dbSetOrder( 6 )
				dbSeek( cFilial+Dtos(mv_par04),.T. )

				While !Eof() .And. cFilial == SE1->E1_FILIAL .And. ( SE1->E1_EMISSAO >= mv_par04 ;
						.And. SE1->E1_EMISSAO <= mv_par05 )

               //�������������������������������������������������Ŀ
               //� Ponto de Entrada para filtrar registros do SE1. �
               //���������������������������������������������������
               If l370E1FIL
                  If !Execblock("F370E1F",.F.,.F.)
                     dbSkip()
                     Loop
                  EndIf
               EndIf

					cPadrao := "500"

					//�����������������������������������������������������Ŀ
					//� Verifica se ser� gerado Lan�amento Cont�bil			  �
					//�������������������������������������������������������
					If SE1->E1_LA == "S" .Or. SE1->E1_TIPO $ MVPROVIS+"/"+MVIRABT
						SE1->( dbSkip())
						Loop
					Endif

					//�����������������������������������������������������Ŀ
					//� Posiciona no cliente.										  �
					//�������������������������������������������������������
					dbSelectArea( "SA1" )
					dbSeek( xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA )

					//�����������������������������������������������������Ŀ
					//� Posiciona na natureza.										  �
					//�������������������������������������������������������
					dbSelectArea( "SED" )
					dbSeek( cFilial+SE1->E1_NATUREZ )

					//�����������������������������������������������������Ŀ
					//� Posiciona na SE5,se RA										  �
					//�������������������������������������������������������
					If SE1->E1_TIPO $ MVRECANT
						dbSelectArea("SE5")
						dbSetOrder(2)
						dbSeek( xFilial()+"RA"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+DtoS(SE1->E1_EMISSAO)+SE1->E1_CLIENTE+SE1->E1_LOJA)
						dbSetOrder(1)
					Endif

					//�����������������������������������������������������Ŀ
					//� Posiciona no banco.											  �
					//�������������������������������������������������������
					dbSelectArea( "SA6" )
					dbSetOrder(1)
					dbSeek( cFilial+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA )
					// Se for um recebimento antecipado e nao encontrou o banco
					// pelo SE1, pesquisa pelo SE5.
					IF SE1->E1_TIPO $ MVRECANT
						If SA6->(Eof())
							dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA )
						Endif	
						cPadrao:="501"
					Endif

					dbSelectArea("SE1")

					lPadrao:=VerPadrao(cPadrao)
					lPadraoCc := VerPadrao("506") //Rateio por C.Custo de MultiNat C.Receber
					lCtbPls := (SE1->(FieldPos("E1_PLNUCOB")) > 0 .And.;
                               	! Empty(SE1->E1_PLNUCOB)) .Or.;
                               	(SE1->(FieldPos("E1_MATRIC")) > 0 .And.;
                               	! Empty(SE1->E1_MATRIC)) .And. FindFunction("PLSCTBSE1")
					If lCtbPls .And. FindFunction("PLSLPSE1")
						lPadrao := PlsLpSe1()
					Endif
					
					IF lPadrao
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						cChaveSev := RetChaveSev("SE1")
						cChaveSez := RetChaveSev("SE1",,"SEZ")
						DbSelectArea("SEV")
						// Se utiliza multiplas naturezas, contabiliza pelo SEV
						If ! lCtbPls .And. SE1->E1_MULTNAT=="1" .And. MsSeek(cChaveSev)
							dbSelectArea("SE1")
							nRecSe1 := Recno()
							DbGoBottom()
							DbSkip()
							DbSelectArea("SEV")
							dbSetOrder(2)
							While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
								   EV_LOJA+EV_IDENT) == cChaveSev+"1" .And. !Eof()
								If SEV->EV_LA != "S"   
									dbSelectArea( "SED" )
									MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
									dbSelectArea("SEV")
									If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao// Rateou multinat por c.custo
										dbSelectArea("SEZ")
         							dbSetOrder(4)
										MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
										While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT) == cChaveSeZ+SEV->EV_NATUREZ+"1"

											If SEZ->EZ_LA != "S"   
												nTotDoc	+=	DetProva(nHdlPrv,"506","FINA370",cLote)
			 									If LanceiCtb // Vem do DetProva
													RecLock("SEZ")
													SEZ->EZ_LA    := "S"
													MsUnlock( )
												Endif
											Endif
                                 dbSkip()
										Enddo									
										DbSelectArea("SEV")
									Else
										nTotDoc	+=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
									Endif
									If LanceiCtb // Vem do DetProva
										RecLock("SEV")
										SEV->EV_LA    := "S"
										MsUnlock( )
									Endif
								Endif	
								DbSelectArea("SEV")
								DbSkip()
							Enddo
							nTotal  	+=	nTotDoc
							nTotProc	+=	nTotDoc // Totaliza por processo

							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								nTotDoc := 0
							Endif
							
							dbSelectArea("SE1")
							DbGoto(nRecSe1)
						Endif	
						dbSelectArea("SEV")
						DbGoBottom()
						DbSkip()
	       					
						DbSelectArea("SE1")
						If lCtbPls
							nTotDoc	:= PlsCtbSe1(@nHdlPrv,cPadrao,"FINA370",cLote)
						Else
							nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
						Endif
						nTotal	+= nTotDoc
						nTotProc	+= nTotDoc //Totaliza por processo
						If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
							Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
						Endif
						//��������������������������������������������Ŀ
						//� Atualiza Flag de Lan�amento Cont�bil		  �
						//����������������������������������������������
						If LanceiCtb
							Reclock("SE1")
							REPLACE E1_LA With "S"
							MsUnlock( )
						EndIf
					Endif
					DbSelectArea("SE1")
					dbSkip()
				Enddo
				If mv_par12 == 3 .And. nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
					nTotProc := 0
				Endif
				If lLerSE5
					//��������������������������������������������������������������Ŀ
					//� Movimenta��o Banc�ria a Receber - SE5990 						  �
					//����������������������������������������������������������������
					dbSelectArea( "SE5" )
					dbSetOrder( 1 )
					dbSeek( cFilial+Dtos(mv_par04),.T. )

					While !Eof() .And. cFilial == SE5->E5_FILIAL .And. ( SE5->E5_DATA >= mv_par04 ;
							.And. SE5->E5_DATA <= mv_par05 )

						cPadrao 	:= "563"
						lX			:= .F.

						If SE5->E5_TIPODOC $ "AP/RF/PE/EP"
							lX		:= .T.
							If SE5->E5_TIPODOC $ "AP/EP"
								If ( SE5->E5_TIPODOC=="AP" .And. SE5->E5_RECPAG=="P" ) .Or.;
										( SE5->E5_TIPODOC=="EP" .And. SE5->E5_RECPAG=="R" )
									cPadrao := "580"
								Else
									cPadrao := "581"
								EndIf
							Else
								If ( SE5->E5_TIPODOC=="RF" .And. SE5->E5_RECPAG=="R" ) .Or.;
										( SE5->E5_TIPODOC=="PE" .And. SE5->E5_RECPAG=="P" )
									cPadrao := "585"
								Else
									cPadrao := "586"
								EndIf
							EndIf
							//�����������������������������������������������������Ŀ
							//� Posiciona Registros para a baixa             		  �
							//�������������������������������������������������������
							dbSelectArea("SEH")
							dbSetOrder(1)
							dbSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8))
							RecLock("SEH")
							SEH->EH_VALREG := 0
							SEH->EH_VALREG2:= 0
							SEH->EH_VALIRF := 0
							SEH->EH_VALIOF := 0
							SEH->EH_VALSWAP:= 0
							SEH->EH_VALISWP:= 0
							SEH->EH_VALOUTR:= 0
							SEH->EH_VALGAP := 0
							SEH->EH_VALCRED:= 0
							SEH->EH_VALJUR := 0
							SEH->EH_VALJUR2:= 0
							SEH->EH_VALVCLP:= 0
							SEH->EH_VALVCCP:= 0
							SEH->EH_VALVCJR:= 0
							SEH->EH_VALREG := 0
							SEH->EH_VALREG2:= 0
							MsUnlock()

							dbSelectArea("SEI")
							dbSetOrder(1)
							dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))

							If ( !VerPadrao("581") .And. cPadrao$"581#580" .And. SEI->EI_STATUS=="C" )
								dbSelectArea("SE5")
								dbSkip()
								Loop
							EndIf
							If ( !VerPadrao("586") .And. cPadrao$"586#585" .And. SEI->EI_STATUS=="C" )
								dbSelectArea("SE5")
								dbSkip()
								Loop
							EndIf

							While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
									xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
								RecLock("SEH")
								If ( SEI->EI_TIPODOC == "I1" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALIRF := SEI->EI_VALOR
								EndIf		
								If ( SEI->EI_TIPODOC == "I2" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALIOF := SEI->EI_VALOR
								EndIf		
								If ( SEI->EI_TIPODOC == "I3" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALISWP:= SEI->EI_VALOR
								EndIf		
								If ( SEI->EI_TIPODOC == "I4" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALOUTR:= SEI->EI_VALOR
								EndIf		
								If ( SEI->EI_TIPODOC == "I5" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALGAP := SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "JR" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALJUR := SEI->EI_VALOR
									SEH->EH_VALJUR2:= SEI->EI_VLMOED2
								EndIf
								If ( SEI->EI_TIPODOC == "V1" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALVCLP := SEI->EI_VALOR
								EndIf		
								If ( SEI->EI_TIPODOC == "V2" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALVCCP := SEI->EI_VALOR
								EndIf		
								If ( SEI->EI_TIPODOC == "V3" .And. SEI->EI_MOTBX=="APR" )
									SEH->EH_VALVCJR := SEI->EI_VALOR
								EndIf		
								MsUnLock()
								dbSelectArea("SEI")
								dbSkip()
							EndDo
							If ( VerPadrao("582") )
								If !lCabecalho
									a370Cabecalho(@nHdlPrv,@cArquivo)
								EndIf
								nTotDoc	:= DetProva(nHdlPrv,"582","FINA370",cLote)
								nTotal	+=	nTotDoc
								nTotProc += nTotDoc
								If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								Endif
							EndIf

							dbSelectArea("SEH")
							dbSetOrder(1)
							dbSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8))
							RecLock("SEH")
							SEH->EH_VALREG := 0
							SEH->EH_VALREG2:= 0
							SEH->EH_VALIRF := 0
							SEH->EH_VALIOF := 0
							SEH->EH_VALSWAP:= 0
							SEH->EH_VALISWP:= 0
							SEH->EH_VALOUTR:= 0
							SEH->EH_VALGAP := 0
							SEH->EH_VALCRED:= 0
							SEH->EH_VALJUR := 0
							SEH->EH_VALJUR2:= 0
							SEH->EH_VALVCLP:= 0
							SEH->EH_VALVCCP:= 0
							SEH->EH_VALVCJR:= 0
							SEH->EH_VALREG := 0
							SEH->EH_VALREG2:= 0
							MsUnlock()

							dbSelectArea("SEI")
							dbSetOrder(1)
							dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))
							While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
									xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
								RecLock("SEH")
								If ( SEI->EI_TIPODOC == "RG" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALREG := SEI->EI_VALOR
									SEH->EH_VALREG2:= SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "I1" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALIRF := SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "I2" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALIOF := SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "SW" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALSWAP:= SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "I3" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALISWP:= SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "I4" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALOUTR:= SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "I5" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALGAP := SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "VL" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALCRED:= SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "JR" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALJUR := SEI->EI_VALOR
									SEH->EH_VALJUR2:= SEI->EI_VLMOED2
								EndIf
								If ( SEI->EI_TIPODOC == "V1" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALVCLP := SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "V2" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALVCCP := SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "V3" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALVCJR := SEI->EI_VALOR
								EndIf
								If ( SEI->EI_TIPODOC == "BL" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALREG := SEI->EI_VALOR
									SEH->EH_VALREG2:= SEI->EI_VLMOED2
								EndIf
								If ( SEI->EI_TIPODOC == "BC" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALREG := SEI->EI_VALOR
									SEH->EH_VALREG2:= SEI->EI_VLMOED2
								EndIf
								If ( SEI->EI_TIPODOC == "BJ" .And. SEI->EI_MOTBX=="NOR" )
									SEH->EH_VALREG := SEI->EI_VALOR
									SEH->EH_VALREG2:= SEI->EI_VLMOED2
								EndIf
								If ( SEI->EI_TIPODOC == "BP" .And. SEI->EI_MOTBX=="NOR" )
									VALOR := SEI->EI_VALOR
								EndIf
								MsUnLock()
								dbSelectArea("SEI")
								dbSkip()
							EndDo
						EndIf

						dbSelectArea("SE5")

						//�����������������������������������������������������Ŀ
						//� Caracteriza-se lancamento os registros com :		  �
						//� E5_TIPODOC = brancos                         		  �
						//� E5_TIPODOC = "DB" // Receita Bancaria - FINA200     �
						//�������������������������������������������������������
						If ( !lX )
							If !(SE5->E5_TIPODOC $ "DB")
								If !Empty(SE5->E5_TIPODOC) .OR. SE5->E5_RECPAG == "P"
									SE5->(dbSkip())
									Loop
								Endif
							EndIf
						EndIf

						If SE5->E5_SITUACA == "C" .or. SubStr(SE5->E5_LA,1,1) == "S" ;
								.or. SE5->E5_RECPAG == "P"
							dbSkip()
							Loop
						Endif

						If SE5->E5_RATEIO == "S" .And. CtbInUse()
							cPadrao := "517"
						EndIf	

						//�����������������������������������������������������Ŀ
						//� Posiciona na natureza.										  �
						//�������������������������������������������������������
						dbSelectArea( "SED" )
						dbSeek(xFilial()+SE5->E5_NATUREZ)

						//�����������������������������������������������������Ŀ
						//� Posiciona no banco.											  �
						//�������������������������������������������������������
						dbSelectArea("SA6")
						dbSetOrder(1)
						dbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)

						dbSelectArea("SE5")
						lPadrao:=VerPadrao(cPadrao)

						If l370E5R
							Execblock("F370E5R",.F.,.F.)
						Endif

						IF lPadrao
							If SE5->E5_RATEIO != "S"
								If !lCabecalho
									a370Cabecalho(@nHdlPrv,@cArquivo)
								Endif
								nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
								nTotProc	+= nTotDoc
								nTotal	+=	nTotDoc
								If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								Endif
								//��������������������������������������������Ŀ
								//� Atualiza Flag de Lan�amento Cont�bil		  �
								//����������������������������������������������
								If LanceiCtb
									Reclock("SE5")
									REPLACE E5_LA With "S"
									MsUnlock()
								EndIf
							Else
								If CtbInUse()				// Somente para SIGACTB
									RegToMemory("SE5",.F.,.F.)
									// Devido a estrutura do programa, o rateio ja eh "quebrado"
									// por documento.
									CtbRatFin(cPadrao,"FINA370",cLote,4," ",,,,,@nHdlPrv,@nTotDoc)
									lCabecalho := .T.
									nTotProc	+= nTotDoc
									nTotal	+=	nTotDoc
									If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
									Endif
									//��������������������������������������������Ŀ
									//� Atualiza Flag de Lan�amento Cont�bil		  �
									//����������������������������������������������
									If LanceiCtb
										Reclock("SE5")
										REPLACE E5_LA With "S"
										MsUnlock()
									EndIf
									// Verifica o arquivo de rateio, e apaga o arquivo temporario
									// para que no proximo rateio seja criado novamente
									If Select("TMP1") > 0
										DbSelectArea( "TMP1" )
										cArq := DbInfo(DBI_FULLPATH)
										cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
										DbCloseArea()
										FErase(cArq)
									EndIf
								EndIf	
							Endif   
						EndIf	
						dbSelectArea("SE5")
						dbSkip()
					End
					If mv_par12 == 3 .And. nTotProc > 0 // Por processo
						Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
						nTotProc := 0
					Endif
				Endif
			Endif

			If (mv_par06 == 2 .or. mv_par06 == 4) .and. lLerSE2
				//��������������������������������������������������������������Ŀ
				//� Contas a Pagar - SE2990												  �
				//����������������������������������������������������������������
				#IFDEF TOP
					dbSelectArea( "TRBSE2" )
				#ELSE
					dbSelectArea("SE2")
				#ENDIF
				dbSetOrder(nIndSe2+1)
				dbSeek(xFilial("SE2")+DtoS(mv_par04),.T.)

				//�����������������������������������������������������Ŀ
				//� Contabiliza pelo E2_EMIS1                  			  �
				//�������������������������������������������������������
				While !Eof() .And. xFilial("SE2") == E2_FILIAL .And. E2_EMIS1 >= mv_par04 ;
						.And. E2_EMIS1 <= mv_par05
					#IFDEF TOP
						SE2->(dbGoto(TRBSE2->(Recno())))
					#ENDIF
					//�����������������������������������������������������Ŀ
					//� Verifica se ser� gerado Lan�amento Cont�bil			  �
					//�������������������������������������������������������
					If	SE2->E2_LA = "S" .Or. SE2->E2_TIPO $ MVPROVIS
						dbSkip()
						Loop
					Endif

					If	SE2->E2_TIPO $ MVTAXA+"/"+MVISS+"/"+MVINSS .And.;
					  ( AllTrim(SE2->E2_FORNECE) $ GetMv( "MV_UNIAO" ) .Or.;
					    AllTrim(SE2->E2_FORNECE) $ GetMv( "MV_MUNIC" ))
					      // Contabiliza rateio de impostos em multiplas naturezas e multiplos
					   // centros de custos.
					   lPadrao:=VerPadrao("510")
						lPadraoCC := VerPadrao("508")  // Rateio C.Custo de MultiNat Pagar
						If lPadrao
							If SE2->E2_RATEIO != "S"
								If !lCabecalho
									a370Cabecalho(@nHdlPrv,@cArquivo)
								Endif
								cChaveSev := RetChaveSev("SE2")
								cChaveSeZ := RetChaveSev("SE2",,"SEZ")
								DbSelectArea("SEV")
								// Se utiliza multiplas naturezas, contabiliza pelo SEV
								If SE2->E2_MULTNAT=="1" .And. MsSeek(cChaveSev)
									dbSelectArea("SE2")
									nRecSe2 := Recno()
									DbGoBottom()
									DbSkip()

									DbSelectArea("SEV")
									While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
										   EV_LOJA) == cChaveSev .And. !Eof()
										If SEV->EV_LA != "S"
											dbSelectArea( "SED" )
											MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
											dbSelectArea("SEV")
											If SEV->EV_RATEICC == "1" .and. lPadrao .and. lPadraoCC // Rateou multinat por c.custo
												dbSelectArea("SEZ")
												MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
												While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
														EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) == cChaveSeZ+SEV->EV_NATUREZ
													If SEZ->EZ_LA != "S"
				                              VALOR := 0      
			   	                           VALOR2 := 0
			      	                        VALOR3 := 0
			         	                     VALOR4 := 0
			            	                  Do Case
			               	               Case SEZ->EZ_TIPO $ MVTAXA 
				               	               VALOR2 := SEZ->EZ_VALOR      
														Case SEZ->EZ_TIPO $ MVISS
				                     	         VALOR3 := SEZ->EZ_VALOR      
				                        	   Case SEZ->EZ_TIPO $ MVINSS
				                           	   VALOR4 := SEZ->EZ_VALOR 
								                  EndCase
														nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote)
			 											If LanceiCtb // Vem do DetProva
															RecLock("SEZ")
															SEZ->EZ_LA    := "S"
															MsUnlock( )
														Endif
												   Endif
   	        			               	dbSkip()
												Enddo									
												DbSelectArea("SEV")
											Else
												VALOR := 0      
	   	                           VALOR2 := 0
	      	                        VALOR3 := 0
	         	                     VALOR4 := 0
	            	                  Do Case
	               	               Case SEV->EV_TIPO $ MVTAXA 
		               	               VALOR2 := SEV->EV_VALOR      
												Case SEV->EV_TIPO $ MVISS
		                     	         VALOR3 := SEV->EV_VALOR      
		                        	   Case SEV->EV_TIPO $ MVINSS
		                           	   VALOR4 := SEV->EV_VALOR 
						                  EndCase
												nTotDoc	+=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
											Endif
											If LanceiCtb // Vem do DetProva
												RecLock("SEV")
												SEV->EV_LA    := "S"
												MsUnlock( )
											Endif	
										Endif	
										dbSelectArea("SEV")
										DbSkip()
									Enddo
									dbSelectArea("SE2")
									DbGoto(nRecSe2)
									nTotal  	+=	nTotDoc
									nTotProc	+=	nTotDoc // Totaliza por processo
									If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
										If lF370NatP
											ExecBlock("F370NATP",.F.,.F.)
										Endif										
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
										nTotDoc := 0
									Endif
								Endif
								//��������������������������������������������Ŀ
								//� Atualiza Flag de Lan�amento Cont�bil 		  �
								//����������������������������������������������
								If LanceiCtb
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf
							Endif
						Endif
					   // Fim da contabilizacao de titulos de impostos por multiplas natureza
					   // e multiplos centros de custos 
  					   #IFDEF TOP
							dbSelectArea( "TRBSE2" )
						#ELSE
							dbSelectArea("SE2")
						#ENDIF
						dbSkip()
						Loop
					Endif

					nRegAnt := Recno()
					dbSkip()
					nProxReg := Recno()
					DbGoto(nRegAnt)

					cPadrao := "510"

					IF	SE2->E2_TIPO $ MVPAGANT
						cPadrao:="513"
					EndIF

					If	SE2->E2_RATEIO == "S"
						cPadrao := "511"
					EndIf

					If	SE2->E2_DESDOBR == "S"
						cPadrao := "577"
					EndIf

					//�����������������������������������������������������Ŀ
					//� Posiciona no fornecedor.									  �
					//�������������������������������������������������������
					dbSelectArea( "SA2" )
					dbSeek( xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA )

					//�����������������������������������������������������Ŀ
					//� Posiciona na natureza.										  �
					//�������������������������������������������������������
					dbSelectArea( "SED" )
					dbSeek( xFilial("SED")+SE2->E2_NATUREZ )
					dbSelectArea("SE2")

					//�����������������������������������������������������Ŀ
					//� Posiciona na SE5 e no Banco,se PA e SEF para Cheque �
					//�������������������������������������������������������
					If SE2->E2_TIPO $ MVPAGANT
						dbSelectArea("SE5")
						dbSetOrder(2)
						dbSeek( xFilial()+"PA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_EMISSAO)+SE2->E2_FORNECE+SE2->E2_LOJA)
						dbSetOrder(1)

						dbSelectArea("SEF")
						dbSetOrder(3)
						dbSeek(xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_NUMBCO)

						dbSelectArea( "SA6" )
						dbSetOrder(1)
						If SE5->(Found())
							dbSeek( xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
						Else
							dbSeek( xFilial()+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)
						Endif							
						dbSelectArea( "SE2" )
					Endif
					lPadrao:=VerPadrao(cPadrao)
					lPadraoCC := VerPadrao("508")  // Rateio C.Custo de MultiNat Pagar
					lCtbPls := (SE2->(FieldPos("E2_PLNUCOB")) > 0 .And.;
                               	! Empty(SE2->E2_PLNUCOB)) .Or.;
   	                           	(SE2->(FieldPos("E2_MATRIC")) > 0 .And.;
       	                       	! Empty(SE2->E2_MATRIC)) .Or.;
       	                       	(SE2->(FieldPos("E2_CODRDA")) > 0 .And.;
                               	! Empty(SE2->E2_CODRDA)) .Or.;
       	                       	(SE2->(FieldPos("E2_PLOPELT")) > 0 .And.;
                               	! Empty(SE2->E2_PLOPELT)) .And. FindFunction("PLSCTBSE2")
					If lCtbPls .And. FindFunction("PLSLPSE2")
						lPadrao := PlsLpSe2()
					Endif
    	                               	
					If lPadrao
						If SE2->E2_RATEIO != "S"
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							cChaveSev := RetChaveSev("SE2")
							cChaveSeZ := RetChaveSev("SE2",,"SEZ")
							DbSelectArea("SEV")
							// Se utiliza multiplas naturezas, contabiliza pelo SEV
							If ! lCtbPls .And. SE2->E2_MULTNAT=="1" .And. MsSeek(cChaveSev)
								dbSelectArea("SE2")
								nRecSe2 := Recno()
								DbGoBottom()
								DbSkip()
								DbSelectArea("SEV")
								While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
									   EV_LOJA) == cChaveSev .And. !Eof()
									If SEV->EV_LA != "S"
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEV")
										If SEV->EV_RATEICC == "1" .and. lPadrao .and. lPadraoCC // Rateou multinat por c.custo
											dbSelectArea("SEZ")
											MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
											While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
													EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) == cChaveSeZ+SEV->EV_NATUREZ
		                              If SEZ->EZ_LA != "S"
		                              	VALOR2	:= 0
			                              VALOR3	:= 0
			                              VALOR4	:= 0
			                              VALOR  	:= 0
													Do Case
			               	               Case SEZ->EZ_TIPO $ MVTAXA 
				               	               VALOR2 := SEZ->EZ_VALOR      
														Case SEZ->EZ_TIPO $ MVISS
				                     	         VALOR3 := SEZ->EZ_VALOR      
				                        	   Case SEZ->EZ_TIPO $ MVINSS
				                           	   VALOR4 := SEZ->EZ_VALOR 
				                           	Otherwise
				                           		VALOR  := SEZ->EZ_VALOR
							                  EndCase
													nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote)
			 										If LanceiCtb // Vem do DetProva
														RecLock("SEZ")
														SEZ->EZ_LA    := "S"
														MsUnlock( )
													Endif
											   Endif
   	        			               dbSkip()
											Enddo									
											DbSelectArea("SEV")
										Else
											VALOR := 0      
   	                           VALOR2 := 0
      	                        VALOR3 := 0
         	                     VALOR4 := 0
            	                  Do Case
               	               Case SEV->EV_TIPO $ MVTAXA 
	               	               VALOR2 := SEV->EV_VALOR      
											Case SEV->EV_TIPO $ MVISS
	                     	         VALOR3 := SEV->EV_VALOR      
	                        	   Case SEV->EV_TIPO $ MVINSS
	                           	   VALOR4 := SEV->EV_VALOR 
					                  EndCase
											nTotDoc	+=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
										Endif
										If LanceiCtb // Vem do DetProva
											RecLock("SEV")
											SEV->EV_LA    := "S"
											MsUnlock( )
										Endif	
									Endif	
									dbSelectArea("SEV")
									DbSkip()
								Enddo
								nTotal  	+=	nTotDoc
								nTotProc	+=	nTotDoc // Totaliza por processo
								If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
									nTotDoc := 0
								Endif
								dbSelectArea("SE2")
								DbGoto(nRecSe2)
							Endif
							dbSelectArea("SEV")
							DbGoBottom()
							DbSkip()
							dbSelectArea( "SE2" )
	       						
							If lCtbPls
								nTotDoc	:= PlsCtbSe2(nHdlPrv,cPadrao,"FINA370",cLote)
							Else
								nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
							Endif
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
							//��������������������������������������������Ŀ
							//� Atualiza Flag de Lan�amento Cont�bil 		  �
							//����������������������������������������������
							If LanceiCtb
								Reclock("SE2")
								Replace E2_LA With "S"
								SE2->(MsUnlock())
							EndIf
						Else
							If !CtbInUse()
								nTotDoc	:=	Fa370Rat(AllTrim(SE2->E2_ARQRAT),@nHdlPrv,@cArquivo)
								nTotProc	+= nTotDoc
								nTotal	+=	nTotDoc
								If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								Endif

								If nTotal != 0
									//��������������������������������������������Ŀ
									//� Atualiza Flag de Lan�amento Cont�bil		  �
									//����������������������������������������������
									dbSelectArea("SE2")
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								Endif
							Else
								// Devido a estrutura do programa, o rateio ja eh "quebrado"
								// por documento.
								RegToMemory("SE2",.F.,.F.)
								CtbRatFin(cPadrao,"FINA370",cLote,4," ",,,,,@nHdlPrv,@nTotDoc)
								lCabecalho := .T.
								nTotProc	+= nTotDoc
								nTotal	+=	nTotDoc
								If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								Endif
								//��������������������������������������������Ŀ
								//� Atualiza Flag de Lan�amento Cont�bil		  �
								//����������������������������������������������
								If LanceiCtb
									//��������������������������������������������Ŀ
									//� Atualiza Flag de Lan�amento Cont�bil		  �
									//����������������������������������������������
									dbSelectArea("SE2")
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf
								// Verifica o arquivo de rateio, e apaga o arquivo temporario
								// para que no proximo rateio seja criado novamente
								If Select("TMP1") > 0
									DbSelectArea( "TMP1" )
									cArq := DbInfo(DBI_FULLPATH)
									cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
									DbCloseArea()
									FErase(cArq)
								EndIf
							EndIf								
						Endif
					Endif
					#IFDEF TOP
						dbSelectArea("TRBSE2")
					#ELSE
						dbSelectArea("SE2")
					#ENDIF
					dbGoto(nProxReg)
				Enddo
				If mv_par12 == 3 .And. nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
					nTotProc := 0
				Endif

				#IFDEF TOP
					dbSelectArea( "TRBSE2" )
				#ENDIF

				//��������������������������������������������������������������Ŀ
				//� Movimenta��o Banc�ria a Pagar - SE5990							  �
				//����������������������������������������������������������������
				dbSelectArea( "SE5" )
				dbSetOrder( 1 )
				dbSeek( cFilial+Dtos(mv_par04),.T. )

				While !Eof() .And. cFilial == SE5->E5_FILIAL .And. ( SE5->E5_DATA >= mv_par04 ;
						.And. SE5->E5_DATA <= mv_par05 .and. lLerSE5)

					If SE5->E5_SITUACA == "C" .or. SubStr(SE5->E5_LA,1,1) == "S" .or. SE5->E5_RECPAG == "R"
						dbSkip()
						Loop
					Endif

					// Nao contabiliza movimentacao bancaria de adiantamento
					If SE5->E5_RECPAG == "P" .And. SE5->E5_TIPO	== MVPAGANT
						dbSkip()
						Loop
					Endif

					cPadrao := "562"
					lX := .f.
					If SE5->E5_TIPODOC $ "AP/RF/PE/EP"
						If SE5->E5_TIPODOC $ "AP/EP"
							If ( SE5->E5_TIPODOC=="AP" .And. SE5->E5_RECPAG=="P" ) .Or.;
									( SE5->E5_TIPODOC=="EP" .And. SE5->E5_RECPAG=="R" )
								cPadrao := "580"
							Else
								cPadrao := "581"
							EndIf
						Else
							If ( SE5->E5_TIPODOC=="RF" .And. SE5->E5_RECPAG=="R" ) .Or.;
									( SE5->E5_TIPODOC=="PE" .And. SE5->E5_RECPAG=="P" )
								cPadrao := "585"
							Else
								cPadrao := "586"
							EndIf
						EndIf
						lX := .T.
						//�����������������������������������������������������Ŀ
						//� Posiciona Registros para a baixa             		  �
						//�������������������������������������������������������
						dbSelectArea("SEH")
						dbSetOrder(1)
						dbSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8))
						RecLock("SEH")
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						SEH->EH_VALIRF := 0
						SEH->EH_VALIOF := 0
						SEH->EH_VALSWAP:= 0
						SEH->EH_VALISWP:= 0
						SEH->EH_VALOUTR:= 0
						SEH->EH_VALGAP := 0
						SEH->EH_VALCRED:= 0
						SEH->EH_VALJUR := 0
						SEH->EH_VALJUR2:= 0
						SEH->EH_VALVCLP:= 0
						SEH->EH_VALVCCP:= 0
						SEH->EH_VALVCJR:= 0
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						MsUnlock()

						dbSelectArea("SEI")
						dbSetOrder(1)
						dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))

						If ( !VerPadrao("581") .And. cPadrao$"581#580" .And. SEI->EI_STATUS=="C" )
							dbSelectArea("SE5")
							dbSkip()
							Loop
						EndIf
						If ( !VerPadrao("586") .And. cPadrao$"586#585" .And. SEI->EI_STATUS=="C" )
							dbSelectArea("SE5")
							dbSkip()
							Loop
						EndIf

						While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
								xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
							RecLock("SEH")
							If ( SEI->EI_TIPODOC == "I1" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALIRF := SEI->EI_VALOR
							EndIf		
							If ( SEI->EI_TIPODOC == "I2" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALIOF := SEI->EI_VALOR
							EndIf		
							If ( SEI->EI_TIPODOC == "I3" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALISWP:= SEI->EI_VALOR
							EndIf		
							If ( SEI->EI_TIPODOC == "I4" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALOUTR:= SEI->EI_VALOR
							EndIf		
							If ( SEI->EI_TIPODOC == "I5" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALGAP := SEI->EI_VALOR
							EndIf		
							If ( SEI->EI_TIPODOC == "JR" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALJUR := SEI->EI_VALOR
								SEH->EH_VALJUR2:= SEI->EI_VLMOED2
							EndIf
							If ( SEI->EI_TIPODOC == "V1" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALVCLP := SEI->EI_VALOR
							EndIf		
							If ( SEI->EI_TIPODOC == "V2" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALVCCP := SEI->EI_VALOR
							EndIf		
							If ( SEI->EI_TIPODOC == "V3" .And. SEI->EI_MOTBX=="APR" )
								SEH->EH_VALVCJR := SEI->EI_VALOR
							EndIf		
							MsUnLock()
							dbSelectArea("SEI")
							dbSkip()
						EndDo
						If ( VerPadrao("582") )
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							EndIf
							nTotDoc	:=	DetProva(nHdlPrv,"582","FINA370",cLote)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
						EndIf

						dbSelectArea("SEH")
						dbSetOrder(1)
						dbSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8))
						RecLock("SEH")
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						SEH->EH_VALIRF := 0
						SEH->EH_VALIOF := 0
						SEH->EH_VALSWAP:= 0
						SEH->EH_VALISWP:= 0
						SEH->EH_VALOUTR:= 0
						SEH->EH_VALGAP := 0
						SEH->EH_VALCRED:= 0
						SEH->EH_VALJUR := 0
						SEH->EH_VALJUR2:= 0
						SEH->EH_VALVCLP:= 0
						SEH->EH_VALVCCP:= 0
						SEH->EH_VALVCJR:= 0
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0

						dbSelectArea("SEI")
						dbSetOrder(1)
						dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))

						While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
								xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
							RecLock("SEH")
							If ( SEI->EI_TIPODOC == "RG" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALREG := SEI->EI_VALOR
								SEH->EH_VALREG2:= SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "I1" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALIRF := SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "I2" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALIOF := SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "SW" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALSWAP:= SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "I3" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALISWP:= SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "I4" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALOUTR:= SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "I5" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALGAP := SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "VL" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALCRED:= SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "JR" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALJUR := SEI->EI_VALOR
								SEH->EH_VALJUR2:= SEI->EI_VLMOED2
							EndIf
							If ( SEI->EI_TIPODOC == "V1" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALVCLP := SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "V2" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALVCCP := SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "V3" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALVCJR := SEI->EI_VALOR
							EndIf
							If ( SEI->EI_TIPODOC == "BL" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALREG := SEI->EI_VALOR
								SEH->EH_VALREG2:= SEI->EI_VLMOED2
							EndIf
							If ( SEI->EI_TIPODOC == "BC" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALREG := SEI->EI_VALOR
								SEH->EH_VALREG2:= SEI->EI_VLMOED2
							EndIf
							If ( SEI->EI_TIPODOC == "BJ" .And. SEI->EI_MOTBX=="NOR" )
								SEH->EH_VALREG := SEI->EI_VALOR
								SEH->EH_VALREG2:= SEI->EI_VLMOED2
							EndIf
							If ( SEI->EI_TIPODOC == "BP" .And. SEI->EI_MOTBX=="NOR" )
								VALOR := SEI->EI_VALOR
							EndIf
							MsUnLock()
							dbSelectArea("SEI")
							dbSkip()
						EndDo
					EndIf
					dbSelectArea("SE5")
					If !lX
						If !Empty(SE5->E5_TIPODOC) .Or.;
							Empty(SE5->E5_NATUREZ)	// Para nao contabilizar totalizar do bordero
															// como movimentacao bancaria a pagar.
							If !(SE5->E5_TIPODOC $ "DB/OD")
								//�����������������������������������������������������Ŀ
								//� Caracteriza-se lancamento os registros com :		  �
								//� E5_TIPODOC = brancos                         		  �
								//� E5_TIPODOC = "DB" // Desp Bancaria gerada no FINA200�
								//� E5_TIPODOC = "OD" // Outras Despesas gerada FINA200 �
								//�������������������������������������������������������
								SE5->( dbSkip())
								Loop
							EndIF
						Endif	
					Endif
                    
					If SE5->E5_RATEIO == "S" .And. CtbInUse()
						cPadrao := "516"
					EndIf	

					//�����������������������������������������������������Ŀ
					//� Posiciona na natureza.										  �
					//�������������������������������������������������������
					dbSelectArea( "SED" )
					dbSeek( cFilial+SE5->E5_NATUREZ )
					//�����������������������������������������������������Ŀ
					//� Posiciona no banco.											  �
					//�������������������������������������������������������
					dbSelectArea( "SA6" )
					dbSetOrder(1)
					dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA )

					If l370E5P
						Execblock("F370E5P",.F.,.F.)
					Endif

					lPadrao:=VerPadrao(cPadrao)
					IF lPadrao
						If SE5->E5_RATEIO != "S"
							If nHdlPrv <= 0
								a370Cabecalho(@nHdlPrv,@cArquivo)
							End
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
							//��������������������������������������������Ŀ
							//� Atualiza Flag de Lan�amento Cont�bil		  �
							//����������������������������������������������
							If LanceiCtb
								Reclock("SE5")
								REPLACE E5_LA With "S"
								MsUnlock()
							EndIf
						Else			// Rateio 516 -> somente sigactb!
							If CtbInUse()
								// Devido a estrutura do programa, o rateio ja eh "quebrado"
								// por documento.
								RegToMemory("SE5",.F.,.F.)
								CtbRatFin(cPadrao,"FINA370",cLote,4," ",,,,,@nHdlPrv,@nTotDoc)
								lCabecalho := .T.
								nTotProc	+= nTotDoc
								nTotal	+=	nTotDoc
								If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								Endif
								//��������������������������������������������Ŀ
								//� Atualiza Flag de Lan�amento Cont�bil		  �
								//����������������������������������������������
								If LanceiCtb
									Reclock("SE5")
									REPLACE E5_LA With "S"
									MsUnlock()
								EndIf
								// Verifica o arquivo de rateio, e apaga o arquivo temporario
								// para que no proximo rateio seja criado novamente
								If Select("TMP1") > 0
									DbSelectArea( "TMP1" )
									cArq := DbInfo(DBI_FULLPATH)
									cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
									DbCloseArea()
									FErase(cArq)
								EndIf
							EndIf	
						EndIf	
					End
					dbSelectArea("SE5")
					dbSkip()
				End
				If mv_par12 == 3 .And. nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
					nTotProc := 0
				Endif
			End

			If (mv_par06 == 1 .or. mv_par06 == 4) .and. lLerSE5
				//��������������������������������������������������������������Ŀ
				//� Baixas a Receber 														  �
				//����������������������������������������������������������������
				dbSelectArea( "SE5" )

				//��������������������������������������������������������������Ŀ
				//� Verifica qual a data a ser utilizada para baixa				  �
				//����������������������������������������������������������������
				cCampo:=IIF(mv_par07 == 1,"E5_DATA","E5_DTDIGIT")
				dbSetOrder( nIndex+1 )

				dbSeek( cFilial+"R"+dtos(mv_par04),.t.)

				While ! SE5->(Eof()) .and. SE5->E5_RECPAG == "R" .and. &cCampo <= mv_par05

					//���������������������������������������������������������������������������Ŀ
					//� Nao serao contabilizadas Mov. Fin. Manuais e Transf.Bancaria neste ponto  �
					//�����������������������������������������������������������������������������
					If Empty(SE5->E5_TIPODOC) .OR. SE5->E5_TIPODOC $ "TR/TE/DB/OD"
						dbSkip()
						Loop
					Endif

					lAdiant := .f.
					lEstorno := .F.
					lEstRaNcc := .F.
					lCompens := .F.
					If SE5->E5_TIPODOC == "ES"
						lEstorno := .T.
					Endif
					If SE5->E5_TIPODOC == "ES" .and. SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG
						lEstRaNcc := .T.
					Endif
					If SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG
						lAdiant := .T.
					Endif
					
					If  SE5->E5_TIPODOC == "BA" .and. SE5->E5_MOTBX == "CMP"
						lCompens := .T.
					Endif
					
					// Despreza baixas do titulo principal, para nao duplicar.
					If SE5->E5_TIPODOC == "CP" .and. SE5->E5_MOTBX == "CMP"
						dbSkip()
						Loop
					Endif

					If (lAdiant .or. lEstorno) .and. !lEstRaNcc
						dbSelectArea("SE2")
						dbSetOrder(1)
						If !(dbSeek(cFilial+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							//����������������������������������������������������������������Ŀ
							//� Localizada inconsist�ncia no arquivo SE5. A fun��o fa370conc	 �
							//� pergunta se o usu�rio quer continuar ou abandonar.				 �
							//������������������������������������������������������������������
							If FA370CONC() # 1
								Break
							Endif
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
					Else
						dbSelectArea( "SE1" )
						dbSetOrder( 2 )

						cFilorig := xFilial()
						If lCompens
							If !Empty(xFilial("SE5"))
								IF !Empty(SE5->E5_FILORIG)
									cFilOrig := SE5->E5_FILORIG
								Endif
							Endif
						Endif

						If !(dbSeek( cFilOrig +SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO ))
							//����������������������������������������������������������������Ŀ
							//� Localizada inconsist�ncia no arquivo SE5. A fun��o fa370conc	 �
							//� pergunta se o usu�rio quer continuar ou abandonar.				 �
							//������������������������������������������������������������������
							If FA370CONC() # 1
								Break
							Endif
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
					Endif

					If (lAdiant .or. lEstorno) .and. !lEstRaNcc
						nValLiq	:= SE2->E2_VALLIQ
						nDescont := SE2->E2_DESCONT
						nJuros	:= SE2->E2_JUROS
						nMulta	:= SE2->E2_MULTA
						nCorrec	:= SE2->E2_CORREC
					Else
						nValLiq	:= SE1->E1_VALLIQ
						nDescont := SE1->E1_DESCONT
						nJuros	:= SE1->E1_JUROS
						nMulta	:= SE1->E1_MULTA
						nCorrec	:= SE1->E1_CORREC
						cSitOri  := SE1->E1_SITUACA	
					Endif

					dbSelectArea( "SE5" )
					nVl:=nDc:=nJr:=nMt:=nCm:=0
					lTitulo := .F.
					cSeq	  :=	SE5->E5_SEQ
					cBanco  := " "
					nRegSE5 := 0
					nRegOrigSE5 := 0

					If (lAdiant .or. lEstorno) .and. !lEstRaNcc
						cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE2->E2_PREFIXO==SE5->E5_PREFIXO.And.SE2->E2_NUM==SE5->E5_NUMERO.And.SE2->E2_PARCELA==SE5->E5_PARCELA.And.SE2->E2_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And. SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_FORNECE+SE2->E2_LOJA"
					Else
						cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE1->E1_PREFIXO==SE5->E5_PREFIXO.And.SE1->E1_NUM==SE5->E5_NUMERO.And.SE1->E1_PARCELA==SE5->E5_PARCELA.And.SE1->E1_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And.SE5->E5_CLIFOR+SE5->E5_LOJA==SE1->E1_CLIENTE+SE1->E1_LOJA"
					Endif

					While !Eof() .And. &cChaveSe5
					
						If !(SE5->E5_RECPAG == "R" .and. &cCampo <= mv_par05)
							Exit
						Endif

						If &cCampo > mv_par05
							Exit
						Endif

						dbSelectArea("SE5")

						If  SE5->E5_TIPODOC $ "BA�VL�V2�ES/LJ"
							nVl	  := E5_VALOR
							cBanco  := SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
							nRegSE5 := SE5->(Recno())
							cSitCob := " "
							If !Empty(SE5->E5_SITCOB)
								cSitCob := SE5->E5_SITCOB
							Endif
							lMultnat := SE5->E5_MULTNAT == "1"
							cSeqSE5	:= SE5->E5_SEQ
						ElseIf SE5->E5_TIPODOC $ "DC�D2"
							nDc	  := E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						ElseIf SE5->E5_TIPODOC $ "JR�J2�TL"
							nJr	  := E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						ElseIf SE5->E5_TIPODOC $ "MT�M2"
							nMt := E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						ElseIf SE5->E5_TIPODOC $ "CM�C2"
							nCm := E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						Endif

						//��������������������������������������������Ŀ
						//� Atualiza Flag de Lan�amento Cont�bil		  �
						//����������������������������������������������
						lTitulo := .T.
						nRegAnt := SE5->(RecNo())
						SE5->(dbSkip())
						nReg := SE5->(Recno())
						SE5->(DbGoto(nRegAnt))
						Reclock("SE5")
						Replace E5_LA With "S" + SubStr( E5_LA,2,1 )
						MsUnlock()
						SE5->(dbGoto(nReg))
						dbSelectArea("SE5")
					Enddo

					If lTitulo
						If (lAdiant .or. lEstorno) .and. !lEstRaNcc
							Reclock( "SE2" )
							Replace E2_VALLIQ  With nVl
							Replace E2_DESCONT With nDc
							Replace E2_JUROS	 With nJr
							Replace E2_MULTA	 With nMt
							Replace E2_CORREC  With nCm
							SE2->(MsUnlock())
						Else
							Reclock( "SE1" )
							Replace E1_VALLIQ  With nVl
							Replace E1_DESCONT With nDc
							Replace E1_JUROS   With nJr
							Replace E1_MULTA   With nMt
							Replace E1_CORREC  With nCm
							If !Empty(cSitCob)
								Replace E1_SITUACA With cSitCob
							Endif
							SE1->( MsUnlock())
						Endif
					Endif

					//�����������������������������������������������������Ŀ
					//� Posiciona no cliente/fornecedor 						  �
					//�������������������������������������������������������
					If lTitulo
						If (lAdiant .or. lEstorno) .and. !lEstRaNcc
							dbSelectArea("SA2")
							dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
							dbSelectArea( "SED" )
							dbSeek( xFilial()+SE2->E2_NATUREZ )
						Else
							dbSelectArea( "SA1" )
							dbSeek( cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA )
							dbSelectArea( "SED" )
							dbSeek( cFilial+SE1->E1_NATUREZ )
						Endif
						//�����������������������������������������������������Ŀ
						//� Posiciona no banco. 										  �
						//�������������������������������������������������������
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						dbSeek( xFilial("SA6")+cBanco)
					Endif

					//��������������������������������������������������Ŀ
					//� Posiciona o arquivo SE5 para que os lan�amentos  �
					//� cont�beis possam localizar o motivo da baixa.	  �
					//����������������������������������������������������
					nRegOrigSE5 := 0
					if  nRegSE5 > 0
						nRegOrigSE5 := SE5->(Recno())
						SE5->(dbGoTo(nRegSE5))
					Endif
					If lAdiant
						cPadrao := "530"
					Elseif lEstorno
						cPadrao := "531"
					ElseIf lCompens
						cPadrao := "596"
					Else
						dbSelectArea( "SE1" )
						If cPaisLoc == "CHI" .And. SE5->E5_MOTBX == "DEV"
							cPadrao := "574"
						Else
							cPadrao := fa070Pad()
						EndIf							
					Endif
					lPadrao := VerPadrao(cPadrao)
					lPadraoCc := VerPadrao("536") //Rateio por C.Custo de MultiNat C.Receber
					lPadraoCcE := VerPadrao("539") //Estorno do rateio C.Custo de MultiMat CR
					IF lPadrao
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						//Contabilizando estorno de C.Pagar
						If lEstorno
							cChaveSev := RetChaveSev("SE2")+"2"+cSeqSE5
							cChaveSez := RetChaveSev("SE2",,"SEZ")
						Else
							cChaveSev := RetChaveSev("SE1")+"2"+cSeqSE5
							cChaveSez := RetChaveSev("SE1",,"SEZ")
						Endif
						DbSelectArea("SEV")
						dbSetOrder(2)
						// Se utiliza multiplas naturezas, contabiliza pelo SEV
						If lMultNat .And. MsSeek(cChaveSev)
							dbSelectArea("SE1")
							nRecSe1 := Recno()
							DbGoBottom()
							DbSkip()
							dbSelectArea("SE2")
							nRecSe2 := Recno()
							DbGoBottom()
							DbSkip()

							DbSelectArea("SEV")
				
							While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
								   EV_LOJA+EV_IDENT+EV_SEQ) == cChaveSev .And. !Eof()
								
								//Se estou contabilizando um estorno, trata-se de um C. Pagar,
								//So vou contabilizar os EV_SITUACA == E
								If (lEstorno .and. !(SEV->EV_SITUACA == "E")) .or. ;
									(!lEstorno .and. (SEV->EV_SITUACA == "E"))
									//Se nao for um estorno, nao devo contabilizar o registro se
									//EV_SITUACA == E
									dbSkip()
									Loop
								ElseIf lEstorno
									//O lancamento a ser considerado passa a ser o do estorno
									lPadraoCC := lPadraoCCE
								Endif

								If SEV->EV_LA != "S"   
									dbSelectArea( "SED" )
									MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
									dbSelectArea("SEV")
									If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao // Rateou multinat por c.custo
										dbSelectArea("SEZ")
										dbSetOrder(4)
										MsSeek(cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5) // Posiciona no arquivo de Rateio C.Custo da MultiNat
										While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT+EZ_SEQ) == cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5

											//Se estou contabilizando um estorno, trata-se de um C. Pagar,
											//So vou contabilizar os EZ_SITUACA == E
											//Se nao for um estorno, nao devo contabilizar o registro se
											//EZ_SITUACA == E
											If (lEstorno .and. !(SEZ->EZ_SITUACA == "E")) .or. ;
												(!lEstorno .and. (SEZ->EZ_SITUACA == "E"))
												dbSkip()
												Loop
											Endif
											If SEZ->EZ_LA != "S"   
												//O lacto padrao fica:
												//536 - Rateio multinat com c.custo C.Receber
												//539 - Estorno de Rat. Multinat C.Custo C.Pagar
												cPadraoCC := If(SEZ->EZ_SITUACA == "E","539","536")
												VALOR := SEZ->EZ_VALOR
												nTotDoc	+=	DetProva(nHdlPrv,cPadraoCC,"FINA370",cLote)
			 									If LanceiCtb // Vem do DetProva
													RecLock("SEZ")
													SEZ->EZ_LA    := "S"
													MsUnlock( )
												Endif
											Endif
                                 dbSkip()
										Enddo									
										DbSelectArea("SEV")
									Else
										nTotDoc	+=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
									Endif
									If LanceiCtb // Vem do DetProva
										RecLock("SEV")
										SEV->EV_LA    := "S"
										MsUnlock( )
									Endif
								Endif	
								DbSelectArea("SEV")
								DbSkip()
								VALOR := 0
							Enddo
							nTotal  	+=	nTotDoc
							nTotProc	+=	nTotDoc // Totaliza por processo
                    	
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								nTotDoc := 0
							Endif
							
							dbSelectArea("SE2")
							DbGoto(nRecSe2)

							dbSelectArea("SE1")
							DbGoto(nRecSe1)
						Else	
							dbSelectArea("SEV")
							DbGoBottom()
							DbSkip()
							DbSelectArea("SE1")
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
						Endif
					Endif
					//����������������������������������������Ŀ
					//� Devolve a posi��o original do arquivo  �
					//������������������������������������������
					If nRegOrigSE5 > 0
						SE5->(dbGoTo(nRegOrigSE5))
					Endif
					If !lAdiant .and. !lEstorno
						dbSelectArea("SE1")
						If !Eof() .And. !Bof()
							Reclock( "SE1" )
							Replace E1_VALLIQ  With nValliq
							Replace E1_DESCONT With nDescont
							Replace E1_JUROS	 With nJuros
							Replace E1_MULTA	 With nMulta
							Replace E1_CORREC  With nCorrec
							Replace E1_SITUACA With cSitOri
							SE1->( MsUnlock( ) )
						EndIF
					Else
						dbSelectArea("SE2")
						If !Eof() .And. !Bof()
							Reclock( "SE2" )
							Replace E2_VALLIQ  With nValliq
							Replace E2_DESCONT With nDescont
							Replace E2_JUROS	 With nJuros
							Replace E2_MULTA	 With nMulta
							Replace E2_CORREC  With nCorrec
							SE2->( MsUnlock())
						EndIf
	            Endif
					dbSelectArea("SE5")
				Enddo
				If mv_par12 == 3 .And. nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
					nTotProc := 0
				Endif
				dbSelectArea( "SE5" )
			Endif

			If (mv_par06 == 2 .or. mv_par06 == 4) .and. lLerSE5
				//��������������������������������������������������������������Ŀ
				//� Baixas a Pagar															  �
				//����������������������������������������������������������������
				dbSelectArea( "SE5" )

				VALOR 		:= 0
				VALOR2		:= 0
				VALOR3		:= 0
				VALOR4		:= 0
				VALOR5		:= 0
				
				nValorTotal := 0
				nBordero	:= 0
				nTotBord	:= 0
				nBordDc		:= 0
				nBordJr		:= 0
				nBordMt		:= 0
				nBordCm		:= 0
				
				//��������������������������������������������������������������Ŀ
				//� Verifica qual a data a ser utilizada para baixa				  �
				//����������������������������������������������������������������
				cCampo:=IIF(mv_par07 == 1,"E5_DATA","E5_DTDIGIT")
				dbSetOrder( nIndex+1 )
				dbSeek( cFilial +"P"+dTos(mv_par04),.T.)
				cNumBor := ""
				While !SE5->(Eof()) .And. SE5->E5_RECPAG == "P" .and. &cCampo <= mv_par05

					//���������������������������������������������������������������������������Ŀ
					//� Nao serao contabilizadas Mov. Fin. Manuais e Transf.Bancaria neste ponto  �
					//�����������������������������������������������������������������������������
					If Empty(SE5->E5_TIPODOC) .OR. SE5->E5_TIPODOC $ "TR/TE/DB/OD/LJ"
						dbSkip()
						Loop
					Endif

					lAdiant := .F.
					lEstorno := .F.
					lEstPaNdf := .F.
					lEstCart2 := .F.
					lCompens  := .F.

					IF SE5->E5_TIPODOC == "ES"
						lEstorno := .T.
					Endif

					IF SE5->E5_TIPODOC == "E2"
						lEstCart2 := .T.
					Endif

					IF SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. SE5->E5_TIPODOC == "ES"
						lEstPaNdf := .T.
					Endif

					IF SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG
						lAdiant := .T.
					Endif

					If SE5->E5_TIPODOC == "BA" .and. SE5->E5_MOTBX == "CMP"	
						lCompens := .T.
					Endif

					//��������������������������������������������������������������Ŀ
					//� Apenas contabilza se :                                       �
					//� For realmente uma baixa de contas a PAGAR                    �
					//� mv_ctbaixa diferente de "C" - Cheque
					//�_______________________________________________________________

					If !lAdiant .and. !lEstorno .and. !lEstCart2
						If cCtBaixa == "C" .And. SE5->E5_MOTBX == "NOR"
							dbSkip()
							Loop
						Endif
					Endif
					
					// A baixa de adiantamento ou estorno de baixa a receber gera registro a pagar

					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						dbSelectArea("SE1")
						dbSetOrder(2)
						If !(dbSeek(xFilial()+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
							//����������������������������������������������������������������Ŀ
							//� Localizada inconsist�ncia no arquivo SE5. A fun��o fa370conc	 �
							//� pergunta se o usu�rio quer continuar ou abandonar.				 �
							//������������������������������������������������������������������
							If FA370CONC() # 1
								Break
							Endif
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
					Else
						dbSelectArea( "SE2" )
						dbSetOrder( 1 )

						cFilorig := xFilial("SE2")
						If lCompens
							If !Empty(xFilial("SE5"))
								IF !Empty(SE5->E5_FILORIG)
									cFilOrig := SE5->E5_FILORIG
								Endif
							Endif
						Endif

						If !(dbSeek( cFilOrig +SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							//����������������������������������������������������������������Ŀ
							//� Localizada inconsist�ncia no arquivo SE5. A fun��o fa370conc	 �
							//� pergunta se o usu�rio quer continuar ou abandonar.				 �
							//������������������������������������������������������������������
							If FA370CONC() # 1
								Break
							Endif
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
					Endif

					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						nValLiq	:= SE1->E1_VALLIQ
						nDescont := SE1->E1_DESCONT
						nJuros	:= SE1->E1_JUROS
						nMulta	:= SE1->E1_MULTA
						nCorrec	:= SE1->E1_CORREC
					Else
						nValLiq	:= SE2->E2_VALLIQ
						nDescont := SE2->E2_DESCONT
						nJuros	:= SE2->E2_JUROS
						nMulta	:= SE2->E2_MULTA
						nCorrec	:= SE2->E2_CORREC
					Endif

					dbSelectArea( "SE5" )
					nVl:=nDc:=nJr:=nMt:=nCm:=0
					lTitulo := .F.
					cSeq	  :=	SE5->E5_SEQ
					cBanco  := " "
					nRegSE5 := 0
					nRegOrigSE5 := 0

					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE1->E1_PREFIXO==SE5->E5_PREFIXO.And.SE1->E1_NUM==SE5->E5_NUMERO.And.SE1->E1_PARCELA==SE5->E5_PARCELA.And.SE1->E1_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And.SE5->E5_CLIFOR+SE5->E5_LOJA==SE1->E1_CLIENTE+SE1->E1_LOJA"
					Else
						cChaveSe5 := "xFilial()==SE5->E5_FILIAL.And.SE2->E2_PREFIXO==SE5->E5_PREFIXO.And.SE2->E2_NUM==SE5->E5_NUMERO.And.SE2->E2_PARCELA==SE5->E5_PARCELA.And.SE2->E2_TIPO==SE5->E5_TIPO.And.cSeq==SE5->E5_SEQ .And. SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_FORNECE+SE2->E2_LOJA"
					Endif
					
					cNumBor := SE5->E5_DOCUMEN
					STRLCTPAD := SE5->E5_DOCUMEN
					While  !Eof() .And. &cChaveSE5

						dbSelectArea("SE5")
						
						// Se nao satisfizer a primeira condicao, Despreza o registro
						If !(SE5->E5_RECPAG == "P" .and. &cCampo <= mv_par05)
							Exit
						Endif

						If	SE5->E5_TIPODOC $ "BA�VL�V2�ES/LJ/E2"
							cBanco  := SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
							cCheque := SE5->E5_NUMCHEQ
							nVl	  := SE5->E5_VALOR
							nRegSE5 := SE5->(Recno())
							lMultnat := SE5->E5_MULTNAT == "1"
							cSeqSE5	:= SE5->E5_SEQ
						ElseIf SE5->E5_TIPODOC $ "DC�D2"
							nDc	  := SE5->E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						ElseIf SE5->E5_TIPODOC $ "JR�J2/TL"
							nJr	  := SE5->E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						ElseIf SE5->E5_TIPODOC $ "MT�M2"
							nMt := SE5->E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						ElseIf SE5->E5_TIPODOC $ "CM�C2"
							nCm := SE5->E5_VALOR
							If nRegSE5 == 0; nRegSE5 := SE5->(Recno()); Endif
						Endif

						//��������������������������������������������Ŀ
						//� Atualiza Flag de Lan�amento Cont�bil		  �
						//����������������������������������������������
						nRegAnt := SE5->(Recno())
						SE5->(dbSkip())
						cProxBor := SE5->E5_DOCUMEN
						nReg := Recno()
						SE5->(DbGoto(nRegAnt))
						Reclock("SE5")
						Replace E5_LA With "S" + SubStr( SE5->E5_LA,2,1 )
						MsUnlock()
						lTitulo := .T.
						dbGoto(nReg)
					EndDO

					If lTitulo
						If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
							Reclock( "SE1" )
							Replace E1_VALLIQ  With nVl
							Replace E1_DESCONT With nDc
							Replace E1_JUROS	 With nJr
							Replace E1_MULTA	 With nMt
							Replace E1_CORREC  With nCm
							SE1->( MsUnlock())
						Else
							Reclock( "SE2" )
							Replace E2_VALLIQ  With nVl
							Replace E2_DESCONT With nDc
							Replace E2_JUROS	 With nJr
							Replace E2_MULTA	 With nMt
							Replace E2_CORREC  With nCm
							SE2->(MsUnlock())
						Endif
					Endif

					If lTitulo
						//�����������������������������������������������������Ŀ
						//� Posiciona no fornecedor. 									  �
						//�������������������������������������������������������
						If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
							dbSelectArea( "SA1" )
							dbSeek( cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA )
							dbSelectArea( "SED" )
							dbSeek( cFilial+SE1->E1_NATUREZ )
						Else
							dbSelectArea("SA2")
							dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
							dbSelectArea( "SED" )
							dbSeek( xFilial()+SE2->E2_NATUREZ )
							nValorTotal += SE2->E2_VALLIQ
						Endif

						//�����������������������������������������������������Ŀ
						//� Posiciona no banco.											  �
						//�������������������������������������������������������
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						dbSeek( cFilial+cBanco)
						dbSelectArea( "SE5" )
					Endif

					//��������������������������������������������������Ŀ
					//� Posiciona o arquivo SE5 para que os lan�amentos  �
					//� cont�beis possam localizar o motivo da baixa. 	  �
					//����������������������������������������������������
					nRegOrigSE5 := 0
					If nRegSE5 > 0
						nRegOrigSE5 := SE5->(Recno())
						SE5->(dbGoTo(nRegSE5))
					Endif

					If lEstorno .and. lEstPaNdf
						cPadrao := "531"
					ElseIf lEstorno
						cPadrao := "527"
					Elseif lEstCart2
						cPadrao := "540"
					ElseIf lAdiant
						dbSelectArea( "SE1" )
						cPadrao := fa070Pad()
					Elseif lCompens
						cPadrao := "597"
					Else
						cPadrao := Iif(Empty(SE2->E2_NUMBOR),"530","532")

// Totalizo por Bordero

						If cPadrao = "532" .And. mv_par13 = 2
							nBordero 	+= SE2->E2_VALLIQ
							nTotBord 	+= SE2->E2_VALLIQ
							nBordDc		+= SE2->E2_DESCONT
							nBordJr		+= SE2->E2_JUROS
							nBordMt		+= SE2->E2_MULTA
							nBordCm		+= SE2->E2_CORREC
						Endif

// Disponibilizo a Variavel VALOR com o total dos borderos aglutinados
						
						If cPadrao = "532" .And. cProxBor <> cNumBor
							VALOR 		:= nBordero
							VALOR		+= nBordDc
							VALOR		-= nBordJr 
							VALOR		-= nBordMt
							VALOR		-= nBordCm
							VALOR2		:= nBordDc
							VALOR3		:= nBordJr
							VALOR4		:= nBordMt
							VALOR5		:= nBordCm
							
							nBordero 	:= 0.00
							nBordDc		:= 0
							nBordJr		:= 0
							nBordMt		:= 0
							nBordCm		:= 0
						Else
							VALOR 		:= 0.00
							VALOR2		:= 0.00
							VALOR3		:= 0.00
							VALOR4		:= 0.00
							VALOR5		:= 0.00
						Endif
					Endif
					lPadrao := VerPadrao(cPadrao)
					lPadraoCc := VerPadrao("537") //Rateio por C.Custo de MultiNat C.Pagar
					lPadraoCcE := VerPadrao("538") //Estorno do rateio C.Custo de MultiMat CR
					IF  lPadrao
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						//Contabilizando estorno de C.Receber
						If lEstorno
							cChaveSev := RetChaveSev("SE1")+"2"+cSeqSE5
							cChaveSez := RetChaveSev("SE1",,"SEZ")
						Else
							cChaveSev := RetChaveSev("SE2")+"2"+cSeqSE5
							cChaveSez := RetChaveSev("SE2",,"SEZ")
						Endif
						DbSelectArea("SEV")
						dbSetOrder(2)
						// Se utiliza multiplas naturezas, contabiliza pelo SEV
						If lMultNat .And. MsSeek(cChaveSev)

							nValorTotal -= SE2->E2_VALLIQ

							dbSelectArea("SE2")
							nRecSe2 := Recno()
							DbGoBottom()
							DbSkip()

							dbSelectArea("SE1")
							nRecSe1 := Recno()
							DbGoBottom()
							DbSkip()

							DbSelectArea("SEV")
				
							While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
								   EV_LOJA+EV_IDENT+EV_SEQ) == cChaveSev .And. !Eof()
								
								//Se estou contabilizando um estorno, trata-se de um C. Pagar,
								//So vou contabilizar os EV_SITUACA == E
								//Se nao for um estorno, nao devo contabilizar o registro se
								//EV_SITUACA == E
								If (lEstorno .and. !(SEV->EV_SITUACA == "E")) .or. ;
									(!lEstorno .and. (SEV->EV_SITUACA == "E"))								
									dbSkip()
									Loop
								ElseIf lEstorno
									//O lancamento a ser considerado passa a ser o do estorno
									lPadraoCC := lPadraoCCE
								Endif

								If SEV->EV_LA != "S"   
									dbSelectArea( "SED" )
									MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
									dbSelectArea("SEV")
									If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao // Rateou multinat por c.custo
										dbSelectArea("SEZ")
										dbSetOrder(4)
										MsSeek(cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5) // Posiciona no arquivo de Rateio C.Custo da MultiNat
										While !Eof() .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT+EZ_SEQ) == cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5

											//Se estou contabilizando um estorno, trata-se de um C. Pagar,
											//So vou contabilizar os EZ_SITUACA == E
											//Se nao for um estorno, nao devo contabilizar o registro se
											//EZ_SITUACA == E
											If (lEstorno .and. !(SEZ->EZ_SITUACA == "E")) .or. ;
												(!lEstorno .and. (SEZ->EZ_SITUACA == "E"))
												dbSkip()
												Loop
											Endif
											If SEZ->EZ_LA != "S"   
												//O lacto padrao fica:
												//537 - Rateio multinat com c.custo C.Pagar
												//538 - Estorno de Rat. Multinat C.Custo C.Receber
												cPadraoCC := If(SEZ->EZ_SITUACA == "E","538","537")
												VALOR := SEZ->EZ_VALOR
												nTotDoc	+=	DetProva(nHdlPrv,cPadraoCC,"FINA370",cLote)
			 									If LanceiCtb // Vem do DetProva
													RecLock("SEZ")
													SEZ->EZ_LA    := "S"
													MsUnlock( )
												Endif
											Endif
                                 dbSkip()
										Enddo									
										DbSelectArea("SEV")
									Else
										nTotDoc	+=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
									Endif
									If LanceiCtb // Vem do DetProva
										RecLock("SEV")
										SEV->EV_LA    := "S"
										MsUnlock( )
									Endif
								Endif	
								DbSelectArea("SEV")
								DbSkip()
								VALOR := 0
							Enddo
							nTotal  	+=	nTotDoc
							nTotProc	+=	nTotDoc // Totaliza por processo
                    	
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
								nTotDoc := 0
							Endif
							dbSelectArea("SE1")
							DbGoto(nRecSe1)
							dbSelectArea("SE2")
							DbGoto(nRecSe2)
  						Else	
							dbSelectArea("SEV")
							DbGoBottom()
							DbSkip()
							DbSelectArea("SE2")
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
						Endif
					EndIF
					//����������������������������������������Ŀ
					//� Devolve a posi��o original do arquivo  �
					//������������������������������������������
					If nRegOrigSE5 > 0
						SE5->(dbGoTo(nRegOrigSE5))
					Endif
					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						dbSelectArea("SE1")
						If !Eof() .And. !Bof()
							Reclock( "SE1" )
							Replace E1_VALLIQ  With nValliq
							Replace E1_DESCONT With nDescont
							Replace E1_JUROS	 With nJuros
							Replace E1_MULTA	 With nMulta
							Replace E1_CORREC  With nCorrec
							SE1->( MsUnlock( ) )
						EndIF
						dbSelectArea( "SE5" )
					Else
						dbSelectArea("SE2")
						If !Eof() .And. !Bof()
							Reclock( "SE2" )
							Replace E2_VALLIQ  With nValliq
							Replace E2_DESCONT With nDescont
							Replace E2_JUROS	 With nJuros
							Replace E2_MULTA	 With nMulta
							Replace E2_CORREC  With nCorrec
							SE2->( MsUnlock())
						EndIf
						dbSelectArea( "SE5" )
					Endif
				EndDO

				If nValorTotal > 0
					If !lCabecalho
						a370Cabecalho(@nHdlPrv,@cArquivo)
					EndIF
					VALOR 	:= If(mv_par13 = 1, nValorTotal, 0.00)
					VALOR2	:= VALOR3	:= VALOR4	:= VALOR5	:= 0.00
					dbSelectArea("SE2")
					dbGobottom()
					dbSkip()
					// Se estiver contabilizando carteira a Pagar apenas,
					// desposiciona E1 tambem, pois no LP podera conter
					// E1_VALLIQ e este campo retornara um valor, duplicando 
					// o LP 527. Ex. Criar um LP 527 contabilizando pelo E1_VALLIQ
					// Fazer uma Baixa e um cancelamento, contabilizar off-line
					// escolhendo apenas a carteira a Pagar
					If mv_par06 == 2 .Or. mv_par06 == 4
						dbSelectArea("SE1")
						dbGobottom()
						dbSkip()
					Endif
					nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
					nTotProc	+= nTotDoc
					nTotal	+=	nTotDoc
					If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
						Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
					Endif
				EndIF
			EndIF
			If mv_par12 == 3 .And. nTotProc > 0 // Por processo
				Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
				nTotProc := 0
			Endif
			If (mv_par06 = 3  .Or. mv_par06 = 4) .and. lLerSEF
				//��������������������������������������������������������������Ŀ
				//� Contabiliza�ao de Cheques  											  �
				//����������������������������������������������������������������
				dbSelectArea("SEF")
				dbSetOrder(1)
				dbSeek( cFilial,.T. )
				While !Eof() .And. xFilial("SEF") == SEF->EF_FILIAL

					//��������������������������������������������������������Ŀ
					//� Guarda o pr�ximo registro para IndR�gua					  �
					//����������������������������������������������������������
					nRegAnt := Recno()
					dbSkip()
					nProxReg := RecNo()
					dbGoto(nRegAnt)

					If SEF->EF_DATA >= mv_par04 .And. SEF->EF_DATA <= mv_par05 .And. !Empty(SEF->EF_NUM) .and. ;
							SubStr(SEF->EF_LA,1,1) != "S" .and. ;
						(Alltrim(SEF->EF_ORIGEM) $ "FINA050#FINA080#FINA070#FINA190#FINA090#FINA390TIT#FINA390AVU" .Or. ;
							Empty(SEF->EF_ORIGEM))

						cPadrao := "590"
						lChqSTit := .F.
						IF SEF->EF_ORIGEM == "FINA390TIT"
							cPadrao := "566"
						Endif
						IF SEF->EF_ORIGEM == "FINA390AVU"
							cPadrao := "567"
						Endif
						If !GetMv("MV_CTBAIXA") $ "AC" .and. Alltrim(SEF->EF_ORIGEM) $ "FINA050#FINA080#FINA190#FINA090#FINA390TIT"
							dbSelectArea("SEF")
							dbGoto(nProxReg)
							Loop
						Endif

						// Nao contabilizo cancelados em off-line
						If SEF->EF_IMPRESS == "C"
							dbSelectArea("SEF")
							dbGoto(nProxReg)
							Loop
						Endif

						// Nao contabilizo cheques de PA nao aglutinados
						If SEF->EF_IMPRESS != "A" .and. Alltrim(SEF->EF_ORIGEM) == "FINA050"
							dbSelectArea("SEF")
							dbGoto(nProxReg)
							Loop
						Endif


						If SEF->EF_IMPRESS $ "SN "	// Cheque impresso ou n�o
							VALOR     := SEF->EF_VALOR		// para lan�amento padr�o
							STRLCTPAD := SEF->EF_HIST
							NUMCHEQUE := SEF->EF_NUM
							ORIGCHEQ  := SEF->EF_ORIGEM
							//�����������������������������������������������������Ŀ
							//� Antes de desposicionar deve gravar flag de contabi- �
							//� lizado.                                             �
							//�������������������������������������������������������
							Reclock("SEF")
							SEF->EF_LA := "S"
							MsUnlock()
							//�����������������������������������������������������Ŀ
							//� Desposiciona propositalmente o SEF para que APENAS a�
							//� variavel VALOR esteja com conteudo. O reposicionamen�
							//� to � feito na volta do Looping.                     �
							//�������������������������������������������������������
							If Alltrim(SEF->EF_ORIGEM) == "FINA190"  // Jun��o de cheques
								dbSelectArea("SEF")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE1")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE2")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE5")
								dbGoBottom()
								dbSkip()
							Endif
							If Alltrim(SEF->EF_ORIGEM) == "FINA390TIT"  // Chq s/ Titulo
								dbSelectArea("SE1")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE2")
								dbGoBottom()
								dbSkip()
								VALOR     := 0
								lChqStit	:= .T.
							Endif
							If Alltrim(SEF->EF_ORIGEM) == "FINA390AVU"  // Cheque Avulso
								VALOR     := 0
								STRLCTPAD := ""
								NUMCHEQUE := ""
								ORIGCHEQ  := ""
								lChqStit	:= .T.
							Endif
						Elseif SEF->EF_IMPRESS == "A"	// Cheque Aglutinado
							VALOR     := 0
							STRLCTPAD := ""
							NUMCHEQUE := ""
							ORIGCHEQ  := ""
							dbSelectArea("SE5")
							dbSetOrder(2)		//posiciona no SE5 
							If !(dbSeek(xFilial()+"VL"+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+DtoS(SEF->EF_DATA)+SEF->EF_FORNECE+SEF->EF_LOJA+SEF->EF_SEQUENC))
								dbSeek(xFilial()+"BA"+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+DtoS(SEF->EF_DATA)+SEF->EF_FORNECE+SEF->EF_LOJA+SEF->EF_SEQUENC)
							Endif
							dbSetOrder(1)
						Endif

						//�����������������������������������������������������Ŀ
						//� Posiciona Registros                                 �
						//�������������������������������������������������������
						If !SEF->(EOF())
							dbSelectArea( "SA6" )
							dbSetOrder(1)
							dbSeek( cFilial+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)
							If !lChqSTit
								If SEF->EF_TIPO $ MVRECANT + "/" + MV_CRNEG
									//��������������������������������������Ŀ
									//� Neste caso o titulo veio de um Contas�
									//� a Receber (SE1)                      �
									//����������������������������������������
									dbSelectArea("SE1")
									DbSetOrder(1)
									If dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
										dbSelectArea("SED")
										dbSeek(xFilial()+SE1->E1_NATUREZ)
										dbSelectArea("SA1")
										dbSeek(xFilial()+SEF->EF_FORNECE+SEF->EF_LOJA)
									Endif
								Else
									dbSelectArea( "SE2" )
									dbSetOrder(1)
									If dbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+;
										  						     SEF->EF_PARCELA+SEF->EF_TIPO+;
																     SEF->EF_FORNECE+SEF->EF_LOJA,.F.)
										dbSelectArea("SED")
										dbSetOrder(1)
										dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
										dbSelectArea("SA2")
										dbSetOrder(1)
										dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
									EndIf
								Endif
								If Alltrim(SEF->EF_ORIGEM) == "FINA390TIT"  // Chq s/ Titulo
									//�����������������������������������������������������Ŀ
									//� Antes de desposicionar deve gravar flag de contabi- �
									//� lizado.                                             �
									//�������������������������������������������������������
									Reclock("SEF")
									SEF->EF_LA := "S"
									MsUnlock()
									dbSelectArea("SEF")
									dbGoBottom()
									dbSkip()
								Endif
							Endif
						EndIf
						dbSelectArea( "SEF" )

						lPadrao:=VerPadrao(cPadrao)
						IF lPadrao
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							End
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
							//��������������������������������������������Ŀ
							//� Atualiza Flag de Lan�amento Cont�bil		  �
							//����������������������������������������������
							If LanceiCtb .And. !(SEF->(Eof()))
								Reclock("SEF")
								SEF->EF_LA := "S"
								MsUnlock()
							EndIf
						Endif
					Endif
					dbSelectArea("SEF")
					dbGoto(nProxReg)
				Enddo
				If mv_par12 == 3 .And. nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
				Endif

				//��������������������������������������������������������������Ŀ
				//� Movimenta��o Banc�ria - Transferencia & Estorno da Transf.   �
				//����������������������������������������������������������������
				aTrf := {"TR","TE"}
				For nLacoTrf := 1 to Len(aTrf)
					dbSelectArea( "SE5" )
					dbSetOrder( 2 )
					SE5->( dbSeek( cFilial+aTrf[nLacoTrf]+Space(TamParcela("E5_PARCELA",13,14,15))+Dtos(mv_par04),.T. ))

					While SE5->( !Eof()) .And. cFilial == SE5->E5_FILIAL .And. ( SE5->E5_DATA >= mv_par04 ;
						.And. SE5->E5_DATA <= mv_par05 ) .and. SE5->E5_TIPODOC $ "TR#TE"

						If SE5->E5_RECPAG == "P"
							cPadrao := "560"
						Elseif SE5->E5_RECPAG == "R"
							cPadrao := "561"
						EndIf

						//�����������������������������������������������������Ŀ
						//� Verifica se ser� gerado Lan�amento Cont�bil			  �
						//�������������������������������������������������������
						If SubStr(SE5->E5_LA,1,1) == "S"
							SE5->( dbSkip( ) )
							Loop
						End

						If SE5->E5_SITUACA == "C"
							SE5->( dbSkip() )
							Loop
						End
						
						//Transferencia ou estorno de transferencia carteira descontada
						If SE5->E5_TIPODOC $ "TR#TE" .and. !Empty(SE5->E5_NUMERO)
							SE5->( dbSkip() )
							Loop
						Endif

						//�����������������������������������������������������Ŀ
						//� Posiciona na natureza.										  �
						//�������������������������������������������������������
						dbSelectArea( "SED" )
						SED->( dbSeek( cFilial+SE5->E5_NATUREZ ) )

						//�����������������������������������������������������Ŀ
						//� Posiciona no banco.											  �
						//�������������������������������������������������������
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						SA6->( dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA ) )

						If l370E5T
							Execblock("F370E5T",.F.,.F.)
						Endif

						dbSelectArea( "SE5" )

						lPadrao:=VerPadrao(cPadrao)
						IF lPadrao
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
							//��������������������������������������������Ŀ
							//� Atualiza Flag de Lan�amento Cont�bil		  �
							//����������������������������������������������
							If LanceiCtb
								Reclock("SE5")
								SE5->E5_LA := "S"
								MsUnlock()
							EndIf
						Endif
						SE5->( dbSkip() )
					EndDo
					If mv_par12 == 3 .And. nTotProc > 0 // Por processo
						Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
						nTotProc := 0
					Endif
				Next
			Endif

			//�����������������������������������������������Ŀ
			//� Caixinha   SEU990             				     �
			//�������������������������������������������������
			If mv_par06 != 3 .and. lLerSEU
				//��������������������������������������������������������������Ŀ
				//� Caixinha   SEU990             				  						  �
				//����������������������������������������������������������������
				dbSelectArea( "SET" )
				dbSetOrder( 1 )
				dbSeek( cFilial)
				nOrderSEU	:=	IIf(mv_par07<>1,2,4)
				bCampo		:=	IIf(mv_par07<>1,{|| EU_BAIXA },{|| EU_DTDIGIT })
				While !Eof() .And. cFilial == SET->ET_FILIAL
					dbSelectArea( "SEU" )
					dbSetOrder( nOrderSEU )
					dbSeek( cFilial + SET->ET_CODIGO + DTOS(MV_PAR04) , .F. )
					While !Eof() .And. cFilial == SEU->EU_FILIAL .And. EU_CAIXA == SET->ET_CODIGO .And. Eval(bCampo) <= mv_par05
						
	               //�������������������������������������������������Ŀ
	               //� Ponto de Entrada para filtrar registros do SEU. �
	               //���������������������������������������������������
	               If l370EUFIL
	                  If !Execblock("F370EUF",.F.,.F.)
	                     dbSkip()
	                     Loop
	                  EndIf
	               EndIf
	
						//�����������������������������������������������������Ŀ
						//� Verifica se ser� gerado Lan�amento Cont�bil			  �
						//�������������������������������������������������������
						If SEU->EU_LA == "S" 
							SEU->( dbSkip())
							Loop
						Endif

						// Tipo 00 sem Nro de adiantamento = Despesa (P)
						// Tipo 00 com Nro de adiantamento = Presta��o de contas (R)
						// Tipo 01 - Adiantamento (P)
						// Tipo 02 - Devolucao de adiantamento (R)
						// Tipo 10 - Movimento Banco -> Caixinha  (R)
						// Tipo 11 - Movimento Caixinha -> Banco (P)

						lSkipLct := .F.

						//Receber
						//Verifico se eh Despesa. Se for, ignoro			
						If mv_par06 == 1 .and. SEU->EU_TIPO $ "00" .AND. EMPTY(SEU->EU_NROADIA)
							lSkipLct := .T.					
						Endif
						//Verifico se eh um Adiantamento ou Devolucao para o banco. Se for Ignoro
						If mv_par06 == 1 .and. SEU->EU_TIPO $ "01/11"
							lSkipLct := .T.					
						Endif

						//Pagar
						//Verifico se eh Prestacao de contas de adiantamento para o caixinha. 
						//Se for, ignoro pois eh movimento de entrada
						If mv_par06 == 2 .and. SEU->EU_TIPO $ "00" .and. !EMPTY(SEU->EU_NROADIA)
							lSkipLct := .T.					
						Endif
						//Verifico se eh uma devolucao de dinheiro de adiantamento para o caixinha ou
						// se eh uma reposicao (Banco -> Caixinha).
						// Se for Ignoro pois eh movimento de entrada!!
						If mv_par06 == 2 .and. SEU->EU_TIPO $ "02/10"
							lSkipLct := .T.					
						Endif

						If lSkipLct 
							SEU->( dbSkip())
							Loop
						Endif


						//Reposicao = 10 - Devolucao de reposicao = 11
						If SEU->EU_TIPO $ "10/11"   
							//�����������������������������������������������������Ŀ
							//� Posiciona no banco.											  �
							//�������������������������������������������������������
							dbSelectArea( "SA6" )
							dbSetOrder(1)
							dbSeek( cFilial+SET->ET_BANCO+SET->ET_AGEBCO+SET->ET_CTABCO )
							cPadrao:="573"
	   				Else
							cPadrao:="572"
	   				Endif

						dbSelectArea("SEU")
						lPadrao:=VerPadrao(cPadrao)
						IF lPadrao
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 .And. nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
							Endif
							//��������������������������������������������Ŀ
							//� Atualiza Flag de Lan�amento Cont�bil		  �
							//����������������������������������������������
							If LanceiCtb
								Reclock("SEU")
								REPLACE EU_LA With "S"
								MsUnlock( )
							EndIf
						Endif
						dbSkip()
					Enddo
					DbSelectArea("SET")
					DbSkip()
				Enddo
				If mv_par12 == 3 .And. nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal)
					nTotProc := 0
				Endif
			Endif
			//�����������������������������������������������������Ŀ
			//� Grava Rodap� 													  �
			//�������������������������������������������������������
			If lCabecalho .And. nTotal > 0 .And. mv_par12 == 1 // Por periodo
				RodaProva(nHdlPrv,nTotal)
				//�����������������������������������������������������Ŀ
				//� Envia para Lan�amento Cont�bil 							  �
				//�������������������������������������������������������
				lDigita:=IIF(mv_par01==1,.T.,.F.)
				lAglut :=IIF(mv_par02==1,.T.,.F.)
				cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
			Endif

		Next 	  // final do la�o dos dias

	END SEQUENCE

	dbSelectArea("SE5")
	RetIndex("SE5")
	Ferase(cIndex+OrdBagExt())

	If mv_par06 = 2 .Or. mv_par06 = 4
		#IFDEF TOP
			IF Select("TRBSE2") > 0
				dbSelectArea( "TRBSE2" )
				dbCloseArea()
			Endif
		#ELSE
			dbSelectArea("SE2")
			RetIndex("SE2")
			Ferase(cIndSE2+OrdBagExt())
		#ENDIF
	ElseIf mv_par06 = 3 .Or. mv_par06 = 4
		dbSelectArea("SEF")
		RetIndex("SEF")
		Ferase(cIndSEF+OrdBagExt())
	EndIf

	If Empty(xFilial("SE1"))
		lLerSE1 := .F.
	Endif

	If Empty(xFilial("SE2"))
		lLerSE2 := .F.
	Endif

	If Empty(xFilial("SE5"))
		lLerSE5 := .F.
	Endif

	If Empty(xFilial("SEF"))
		lLerSEF := .F.
	Endif

	If Empty(xFilial("SEU"))
		lLerSEU := .F.
	Endif

	If !lLerSE1 .and. !lLerSE2 .and. !lLerSE5 .and. !lLerSEF .And. !lLerSEU
		Exit
	Endif

	dbSelectArea("SM0")
	dbSkip()

	//�����������������������������������������������������Ŀ
	//� Data inicial precisa ser "resetada"                 �
	//�������������������������������������������������������
	mv_par04 := mv_par04 - nLaco + 2

Enddo

//�����������������������������������������������������Ŀ
//� Recupera o valor real da data base por seguranca	  �
//�������������������������������������������������������
dDataBase := dDataAnt

//�����������������������������������������������������Ŀ
//� Recupera a filial original                      	  �
//�������������������������������������������������������
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//��������������������������������������������������������������Ŀ
//� Recupera a Integridade dos Dados									  �
//����������������������������������������������������������������
MsUnlockAll()

dbSelectArea( "SE1" )
dbSetOrder( 1 )
dbSeek(xFilial())
dbSelectArea( "SE2" )
dbSetOrder( 1 )
dbSeek(xFilial())
dbSelectArea("SEF")
dbSetOrder(1)
dbSeek(xFilial())
dbSelectArea( "SE5" )
Retindex("SE5")
dbClearFilter()

If !CtbInUse()
	If mv_par11 == 1			// Atualiza��o de Sint�ticas
		aDataIni := DataInicio()
		aDataFim := DataFinal()
		aTabela22:= DataTabela()
		If mv_par08 == 1 		// Considera filiais De/Ate
			Cona070(.T., mv_par09, mv_par10, mv_par04, mv_par05)
		Else						// Desconsidera Filiais
			Cona070(.T., NIL , NIL , mv_par04, mv_par05)
		EndIf
	EndIf
EndIf	

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA370CONC� Autor � Vinicius Barreira	  � Data � 24/08/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela de Aviso de Falha na consist�ncia do SE5				  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FA370CONC() 															  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � SIGAFIN																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
 User Function FA370CONC()
Local nOpca 	:= 0
Local aSays := {} , aButtons := {}
Local cCadast := "Contabiliza��o"

If IsBlind()
	Return 0
Endif

AADD (aSays , "     Foi encontrado  um  Registro no arquivo SE5 que n�o possui ")
AADD (aSays , "correspond�ncia nos arquivos de Contas a Receber ou Pagar. Voc� ")
AADD (aSays , "pode parar agora a contabiliza��o ou continuar assim mesmo.     ")
AADD (aSays , "Obs.: A rotina de refaz acumulados ajusta o arquivo SE5.        ")
AADD (aSays , "Arquivo : " + Iif(SE5->E5_RECPAG=="R","Receber","Pagar")) //"Arquivo : "###"Receber"###"Pagar"
AADD (aSays , "Dados do Titulo: " + SE5->E5_PREFIXO+"-"+SE5->E5_NUMERO+"-"+SE5->E5_PARCELA+"-"+SE5->E5_TIPO ) //"Dados do Titulo: "

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadast, aSays, aButtons )

Return nOpca

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � Fa370Rat � Autor � Pilar S. Albaladejo   � Data � 25/08/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava linha de rateio no arquivo de contra-prova			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � Fa370Rat()																  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � SIGAFIN																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Fa370Rat(cArqRat,nHdlPrv,cArquivo)

Local nBytes := 0
Local nHdlRateio
Local nTotal := 0
Local nTamArq
Local xBuffer, cArqOrig, cArqDest

// Abre arquivo de rateio
cArqRat		:= GetMv("MV_PROVA") + cArqRat + ".LAN"
IF !FILE(cArqRat)
	Help(" ",1,"Fa370NOARQ",,cArqRat,3,1)
	Return 0
EndIF

If nHdlPRv == 0 .or. (nHdlPrv == 65536 .and. GetHProva() < 0 )
	a370Cabecalho(@nHdlPrv,@cArquivo,.T.)
	lCabecalho := .T.
Endif
nHdlPrv  := GetHProva()
cArquivo := GetHFile()

nHdlRateio	:= Fopen(cArqRat)
nTamArq		:= FSEEK(nHdlRateio,0,2)
xBuffer		:= Space( 312 )
FSEEK(nHdlRateio,0,0)
FREAD(nHdlRateio,@xBuffer,312)

While .T.
	If nBytes < nTamArq
		xBuffer:=Space(312)
		FREAD(nHdlRateio,@xBuffer,312)
		IF  Substr(xBuffer,309,2) = "FF"     // Fim de Arquivo
			Exit
		Endif
		nTotal += Val(Substr(xBuffer,42,16))
		// Escreve no arquivo de contra-prova
		FWRITE(nHdlPrv,xBuffer,312)
		dbCommit()
		nBytes+=312
	Else
		Exit
	Endif
End

// Renomeia arquivo de rateio
Fclose(nHdlRateio)
cArqOrig:=Trim(cArqRat)
cArqDest:=Substr(cArqRat,1,Len(cArqRat)-4)+".#LA"
fRename(cArqOrig,cArqDest)
Return nTotal

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �a370Cabeca� Autor � Wagner Xavier 		  � Data � 24/08/94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta o arquivo de Contra Prova (Lancamentos off line) 	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �a370Cabeca																  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 �SIGAFIN																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function a370Cabecalho(nHdlPrv,cArquivo,lCriar)
lCriar:=if(lCriar=NIL,.f.,lCriar)
nHdlPrv:=HeadProva(cLote,"FINA370",Substr(cUsuario,7,6),@cArquivo,lCriar)
lCabecalho:=.T.
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Ca370Incl � Autor � Claudio D. de Souza	  � Data � 12/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Envia lancamentos para contabilizade.                  	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �Ca370Incl 																  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 �FINA370																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ca370Incl(cArquivo,nHdlPrv,cLote,nTotal)
Local lDigita,;
		lAglut
		
	//�����������������������������������������������������Ŀ
	//� Grava Rodap� 													  �
	//�������������������������������������������������������
	If nHdlPrv > 0
		RodaProva(nHdlPrv,nTotal)
		//�����������������������������������������������������Ŀ
		//� Envia para Lan�amento Cont�bil 							  �
		//�������������������������������������������������������
		lDigita:=IIF(mv_par01==1,.T.,.F.)
		lAglut :=IIF(mv_par02==1,.T.,.F.)
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
		lCabecalho := .F.
		nHdlPrv := 0
	Endif
	
Return Nil
