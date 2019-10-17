#Include "Protheus.CH"
#Include "Colors.ch"
#INCLUDE "CTBA390.ch"

#DEFINE MAXPASSO 6
Static l390SLCDX := ExistBlock("CT390SLCDX")
Static l390SLSQL := ExistBlock("CT390SLSQL")
Static l390Grv 	 := ExistBlock("CTB390GRV")			
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CTBA390  ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 01.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de manutencao do cadastro de orcamentos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBA390()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCtb                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Revisoes  ³ Simone Mie Sato - Adicionadas querys para TopConnect       ³±±
±±³Revisoes  ³ Marcos S. Lobo - Normalização Cabecalho x Itens            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctba390()
Local lCt390AFil:= ExistBlock("Ct390AFil")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a	 ser efetuada                        ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE aRotina :={ { STR0001	,"Ctb390Pes" , 0, 1},; //"Pesquisar"
{ STR0002	,"Ctb390Cad(,,2)"					 , 0, 2},; //"Visualizar"
{ STR0003	,"Ctb390Cad(,,3)"					 , 0, 3},; //"Incluir"
{ STR0004	,"Ctb390Cad(,,4)"					 , 0, 4},; //"Alterar"
{ STR0005	,"Ctb390Cad(,,5)"					 , 0, 5},; //"Excluir"
{ STR0018	,"Ctb390Cad(,,6)"					 , 0, 6},; //"Revisao"
{ STR0023	,"CtbLegenda"					 	, 0 ,5},; //"Legenda"
{ STR0024	,"Ctb390Cad(,,7)"					 , 0, 7},; //"Copiar"
{ STR0019	,"Processa( { || Ct390GrSld() })", 0, 4}}   //"Gera Saldo"

If GetMV("MV_ORCAPRV") == "S"
	aAdd(aRotina,{ STR0025	,"Processa( { || Ctb390Aprv() })", 0, 0}) 	 //"Aprovar"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := STR0006 //"Atualizacao de Orcamentos"

Pergunte("CTB390", .F.)

SetKey(VK_F12,{|a,b|Pergunte("CTB390",.T.)})

dbSelectArea("CV2")
cFiltro := ""
If ExistBlock("CTB390FIL")								/// PONTO DE ENTRADA PARA A FILTRAGEM DO BROWSE
	cFiltro := ExecBlock("CTB390FIL", .F., .F.)
	If !Empty(cFiltro)									/// SE A EXPRESSÃO RETORNADA NÃO ESTIVER VAZIA
		Set Filter To &(cFiltro)						/// ACIONA A EXPRESSÃO DE FILTRO NO CV2
	Endif
Endif

If !lCt390AFil
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse(6,1,22,75,"CV2",,,,,, CtbLegenda("CV2")/*,cFilIni,cFilFim*/)

dbSelectArea("CV2")
Set Filter To
Else
	ExecBlock("CT390AFIL",.F.,.F.)
Endif

SET KEY VK_F12 to

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ctb390Cad³ Autor ³ Wagner Mobile Costa   ³ Data ³ 01.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de manutencao do cadastro de orcamentos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Ctb390Cad(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba390                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Cad(cAlias,nReg,nOpcx)

Local oDlg, nOpcA := 0, aSize := MsAdvSize(,.F.,400), aObjects := {}, aInfo, aPosObj
Local bSx3 		:= { |cCampo| (	SX3->(DbSetOrder(2)), SX3->(DbSeek(cCampo)),;
SX3->(DbSetOrder(1)), X3Titulo()) }
Local aVarTela	:= { 	{ "CV1_ORCMTO", .T. }, { "CV1_DESCRI", .T. },;
{ "CV1_STATUS", .T. }, { "CV1_REVISA", .T. },;
{ "CV1_CALEND", .T. }, { "CV1_MOEDA" , .T. } }, nVarTela
Local aSituacao	:= CTBCBOX("CV1_STATUS")
Local cArqTmp, aStru := {}, aAltera := {}
Local cPictVal 	:= PesqPict("CV1","CV1_VALOR"), cSeqAnt, nCpo, nCont //Local cPictVal 	:= X3Picture("CV1_VALOR"), cSeqAnt, nCpo, nCont
Local lRevisao	:= nOpcX == 6
Local lCopia 	:= nOpcX == 7
Local lIncSeq, nSequencia, cRevisa
Local aMemos 	:= {}
Local aButton 	:= {}
Local cTitulo
Local nPswAprPos:= 119 // Altera Orçamento Aprovado
Local lAprvMnt 	:= .T.
Local lAltValor	:= .F.
Local nSeqColsP := 1
Local nDifCols	:= 1
Local lIsAprov	:= .F.
Local cCV1APROVA:= ""
Local nLenVal := nSEQUEN := 0
Local cCV2Filial := xFilial("CV2")
Local lX3Aprova	 := .F.
Local lCtb390Psw	:= IIf(ExistBlock("CTB390PSW"),.T.,.F.)
Local lRetPsw		:= .T.
Local i
Local nRevisao         
Local lAtuSal		:= .T.
Local cDbsExt		:= GetDBExtension()

If GetMV("MV_ORCAPRV") == "S"									//// SE APROVACAO ESTIVER HABILITADA
	If !Empty(CV2->CV2_APROVA) .and. nOpcX == 4					//// SE O ORCAMENTO ESTIVER APROVADO E FOR ALTERACAO
		If !ChkPsw(nPswAprPos)									//// CHECA ACESSO DO USUÁRIO (ALTERA ORCAMENTO APROVADO)
			Return
		Endif
		lAprvMnt 	:= alltrim(CV2->CV2_APROVA) == alltrim(Subs(cUsuario, 7, 15))
		If !lAprvMnt												//// SE NAO FOR O PROPRIO APROVADOR
			Return													//// BLOQUEIA A ALTERACAO
		Endif	
	Else
		lAprvMnt := .T.
	Endif   
	lX3Aprova	:= .T.
Else																	//// SE NÃO ESTIVER HABILITADA
	lAprvMnt 	:= .T.													//// QUALQUER USUÁRIO PODE FAZER MANUTENÇÃO
Endif

Private lExecChg := .F.									//// AO INICIALIZAR O OBJETO oGet NÃO DEVE EXECUTAR O bChange (muda p/ .T. NO ACTIVATE DIALOG oGet já vai estar montado)

aAreaBrw := GetArea()
nIndCV2  := CV2->(IndexOrd())
nRecCV2  := CV2->(Recno())

DEFAULT cAlias	:= "CV1"
DEFAULT nReg	:= CV2->(Recno())

dbSelectArea("CV1")

Private oOrcado, oVlrOrc, nOrc, oTotOrc, nTotOrc
If lX3Aprova
	M->CV1_APROVA := ""
Else
	M->CV1_APROVA := cUserName
Endif

If 	(CV2->CV2_STATUS == "3" )
	//// ALTERACAO ou Exclusao e encontrou a revisao
	If 	 nOpcX = 4 .Or. (lRevisao .And. CV1->(MsSeek(CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+Soma1(CV2->CV2_REVISA)))))
		Apmsginfo(STR0007, STR0008) //"Orcamento ja revisado nao podendo ser alterado !"###"Atencao"
		CV2->(DbGoto(nReg))
		Return .F.
	Endif
	CV2->(DbGoto(nReg))
Endif

If lRevisao .and. !Empty(CV2->CV2_APROVA)			//// SE FOR REVISAO E ESTIVER APROVADO (GUARDA O APROVADOR) PARA A NOVA REVISAO
	lIsAprov	:= .T.
	cCV1APROVA	:= CV2->CV2_APROVA
Endif

//Verifica se o usuario tem permissao para Revisar orcamentos aprovados
If nOpcx == 6
	If !ChkPsw(120)
		Return .F.
	EndIf
EndIf

//Se existe o ponto de entrada CTB390PSW
If lCtb390Psw
	lRetPsw	:= ExecBlock("CTB390PSW",.F.,.F.,{nOpcX,Subs(cUsuario,7,15)})	
	If !lRetPsw	//Se o ponto de entrada retornar falso
		Return .F.		
	Endif
EndIf

cTitulo := STR0009
If lX3Aprova
	If nOpcX # 3 .And. !Empty(CV1->CV1_APROVA)
		cTitulo += STR0021 + AllTrim(CV1->CV1_APROVA) //" - Aprovado por "
	Endif
Endif

If lRevisao .Or. lCopia
	nOpcX := 3
	M->CV1_STATUS := CV2->CV2_STATUS
Endif

For nVarTela := 1 To Len(aVarTela)
	If nOpcX == 3 .And. !lRevisao .And. !lCopia // Inclusao
		_SetOwnerPrvt(aVarTela[nVarTela][1], CriaVar(aVarTela[nVarTela][1]))
	Else
		If aVarTela[nVarTela][1] == "CV1_STATUS" .and. CV2->CV2_STATUS $ '23' .and. lCopia 	/// SE O ORCAMENTO JA FOI REVISADO E FOR COPIA
			_SetOwnerPrvt(aVarTela[nVarTela][1], "1")		/// DEIXA A COPIA COM STATUS DE ABERTO
		Else
			_SetOwnerPrvt(aVarTela[nVarTela][1], &("CV1->" + aVarTela[nVarTela][1]))
		Endif
	Endif
Next

DbClearFil()

// Variaveis para controle da manutencao
INCLUI 		:= nOpcX = 3
ALTERA 		:= nOpcX = 4
EXCLUI 		:= nOpcX = 5

nTotOrc 	:= 0.00
nOrc 		:= 0.00
aHeader		:= {}		// GetDb
Private aColsP		:= { { { "  ", Ctod(""), Ctod(""), 0.00, "1", 0, 0 } } }	// ListBox
aItColsP	:= { "  ", Ctod(""), Ctod(""), 0.00, "1", 0, 0 }

// Defino aHeader

dbSelectArea("Sx3")
SX3->(DbSetOrder(1))
dbseek(cAlias)
aMemos := {}
While !EOF() .And. x3_arquivo == cAlias
	IF X3Uso(x3_usado) .AND. cNivel >= x3_nivel .And. If(X3_CAMPO = "CV1_APROVA", .F., .T.)
		
		AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid,;
		x3_usado, x3_tipo, "TMP", x3_context } )
		If Alltrim(x3_campo) <> "CV1_SEQUEN"
			Aadd(aAltera,Trim(X3_CAMPO))
		EndIf
	ENDIF
	Aadd(aStru,{ Trim(X3_CAMPO), X3_TIPO, X3_TAMANHO, X3_DECIMAL })
	If At("MSMM(", Upper(SX3->X3_RELACAO)) > 0
		cCpoSyp := Subs(SX3->X3_RELACAO, At("MSMM(", Upper(SX3->X3_RELACAO)) + 5)
		cCpoSyp := Left(cCpoSyp, At(")", cCpoSyp) - 1)
		cCpoSyp := StrTran(cCpoSyp, cAlias + "->", "")
		Aadd(aMemos, { cCpoSyp, SX3->X3_CAMPO })
	Endif
	dbSkip()
EndDO

// Crio e carrego o temporario

aadd(aStru,{"CV1_ENTIDA","N",04,0})
aadd(aStru,{"CV1_FLAG" 	 ,"L",01,0})

cArqTmp := CriaTrab(aStru,.T.)

If Select("TMP") > 0
	TMP->(DbCloseArea())
Endif

dbUseArea(.T.,,cArqTmp,"TMP",.F.,.F.)

If nOpcX != 3 .Or. lRevisao .Or. lCopia		// Visualizacao / Alteracao / Exclusao
	dbSelectArea("CV1")
	dbSetOrder(1)
	If MsSeek(CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA))
		M->CV1_ORCMTO	:= CV2->CV2_ORCMTO
		M->CV1_CALEND	:= CV2->CV2_CALEND
		M->CV1_MOEDA	:= CV2->CV2_MOEDA
		M->CV1_DESCRI   := CV2->CV2_DESCRI
		If lCopia
			M->CV1_STATUS	:= "1"
		Else
			M->CV1_STATUS	:= CV2->CV2_STATUS
		Endif
		If lRevisao .and. lIsAprov
			M->CV1_APROVA	:= cCV1APROVA
		Else
			If lCopia
				If lX3Aprova
					M->CV1_APROVA	:= ""
				Else
					M->CV1_APROVA	:= cUserName
				Endif
			Else
				M->CV1_APROVA	:= CV2->CV2_APROVA
			Endif
		Endif
		nTotOrc := 0
		nCont	:= 1
		cRevisa := CV2->CV2_REVISA
		
		If lRevisao
			MsSeek(CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA)+"ZZZ", .T.)
			DbSkip(-1)
			M->CV1_REVISA := StrZero(Val(CV1->CV1_REVISA) + 1, 3)
			MsSeek(CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA)+cRevisa)
		ElseIf lCopia
			M->CV1_REVISA := "001"
		Else
			M->CV1_REVISA := CV2->CV2_REVISA
		Endif
		
		aColsP := {}
		While CV1->(!Eof()) .And. CV1->CV1_FILIAL == xFilial("CV1") 	.And.;
			CV1->CV1_ORCMTO == M->CV1_ORCMTO	.And.;
			CV1->CV1_CALEND	== M->CV1_CALEND	.And.;
			CV1->CV1_MOEDA  == M->CV1_MOEDA	.And.;
			CV1->CV1_REVISA == cRevisa
            
			dbSelectArea("TMP")
			dbAppend()
			For nCpo := 1 To Len(aHeader)
				If (aHeader[nCpo][08] <> "M" .And. aHeader[nCpo][10] <> "V" )
					Replace &(aHeader[nCpo][2]) With &("CV1->" + aHeader[nCpo][2])
				ElseIf aHeader[nCpo][08] = "M"
					Replace &(aHeader[nCpo][2]) With CriaVar(aHeader[nCpo][2])
				EndIf
			Next

			nSeqColsP := Val(CV1->CV1_SEQUEN)		
			If Len(aColsP) < nSeqColsP-1						/// SE HOUVER FALHA NA SEQUENCIA DOS REGISTROS
				For nDifCols := Len(aColsP)+1 to nSeqColsP-1	/// CARREGA O ACOLSP ATÉ O TAMANHO DA DIFERENÇA
					AADD(aColsP, {} )
				Next				
			Endif
			cSequen   := CV1->CV1_SEQUEN
			AADD(aColsP, {} )

			While CV1->(!Eof()) .And. 		CV1->CV1_FILIAL == xFilial("CV1") 	.And.;
				CV1->CV1_ORCMTO == M->CV1_ORCMTO	.And.;
				CV1->CV1_CALEND	== M->CV1_CALEND	.And.;
				CV1->CV1_MOEDA  == M->CV1_MOEDA	.And.;
				CV1->CV1_REVISA == cRevisa .and. CV1->CV1_SEQUEN == cSequen
       	
				AADD(aColsP[nSeqColsP], {CV1->CV1_PERIOD,CV1->CV1_DTINI,CV1->CV1_DTFIM,CV1->CV1_VALOR,0,0,0 } )
                
				If lRevisao .Or. lCopia
					aColsP[nSeqColsP][Len(aColsp[nSeqColsp])][6]	:= 0
					If lRevisao
						aColsP[nSeqColsP][Len(aColsp[nSeqColsp])][7]	:= CV1->(Recno())
					Endif
				Else
					aColsP[nSeqColsP][Len(aColsp[nSeqColsp])][6]	:= CV1->(Recno())
				Endif
				
				dbSelectArea("CV1")
				dbSkip()			
			EndDo
			
			CTB390DspOrc(,,@nOrc,,@nTotOrc,nSeqColsP)
		EndDo
	Else
		ApMsgAlert("Orçamento não encontrado no CV1 !","Inconsistência !")
		Return
	EndIf
	
	dbSelectArea("TMP")
	DbGoTop()
Else
	dbSelectArea("TMP")
	dbAppend()
	For nCpo := 1 To Len(aHeader)
		If (aHeader[nCpo][08] <> "M" .And. aHeader[nCpo][10] <> "V" )
			Replace &(aHeader[nCpo][2]) With CriaVar(aHeader[nCpo][2], .T.)
		ElseIf aHeader[nCpo][08] = "M"
			Replace &(aHeader[nCpo][2]) With CriaVar(aHeader[nCpo][2])
		EndIf
	Next nCpo
	
	TMP->CV1_SEQUEN	:= STRZERO(1,Len(CV1->CV1_SEQUEN))
	M->CV1_REVISA	:= "001"
EndIf

If Empty(M->CV1_STATUS)
	M->CV1_STATUS := "1"
Endif

If Empty(M->CV1_APROVA)
	M->CV1_APROVA := " "
Endif

aAdd( aObjects, { 230 - (If(mv_par03 == 2, 30, 0)), 230 - (If(mv_par03 == 2, 30, 0)), .T., .T. } )
aAdd( aObjects, { 500, 500, .T., .T. } )
If mv_par03 = 1
	AAdd( aObjects, { 075, 075, .T., .T. } )
Endif

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects, .T. )

DEFINE FONT oFnt	NAME "Arial" Size 10,15

DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL LABEL STR0010 //"Capa do Orcamento"

@ 028,010 	SAY Eval(bSx3, "CV1_ORCMTO")	Of oDlg PIXEL COLOR CLR_HBLUE
@ 025,060 	MSGET M->CV1_ORCMTO				Of oDlg PIXEL Picture PesqPict("CV1","CV1_ORCMTO");
When nOpcX == 3 .And. ! lRevisao Valid CheckSx3("CV1_ORCMTO", M->CV1_ORCMTO,nOpcx) //.and. FreeForUse("CV1",M->CV1_ORCMTO)

@ 028,190 	SAY Eval(bSx3, "CV1_DESCRI")	Of oDlg PIXEL COLOR CLR_HBLUE
@ 025,220 	MSGET M->CV1_DESCRI				Of oDlg PIXEL Picture "@!";
When (nOpcX <> 5  .And. nOpcX <> 2) Valid Texto() SIZE 160,10

@ 043,010 	SAY Eval(bSx3, "CV1_CALEND")		Of oDlg PIXEL COLOR CLR_HBLUE
@ 040,060 	MSGET oCV1Calend VAR M->CV1_CALEND OF oDlg F3 "CTG" Valid CheckSx3("CV1_CALEND", M->CV1_CALEND,nOpcx) .And. Ctb390CarCal(1, oPeriodo,.T.,lCopia) Picture PesqPict("CV1","CV1_CALEND") PIXEL
oCV1Calend:lReadOnly := !INCLUI .or. lRevisao

@ 043,190 	SAY Eval(bSx3, "CV1_MOEDA")		Of oDlg PIXEL COLOR CLR_HBLUE
@ 040,220 	MSGET oCV1Moeda VAR M->CV1_MOEDA Of oDlg PIXEL F3 "CTO"	Valid CheckSx3("CV1_MOEDA", M->CV1_MOEDA,nOpcx) .And. Ctb390CarCal(1, oPeriodo) Picture PesqPict("CV1","CV1_MOEDA")
oCV1Moeda:lReadOnly := !INCLUI .or. lRevisao

@ 058,010 	SAY Eval(bSx3, "CV1_REVISA")	Of oDlg PIXEL COLOR CLR_HBLUE
@ 055,060 	MSGET M->CV1_REVISA				Of oDlg PIXEL Picture "!!!";
When .F. Valid CheckSx3("CV1_REVISA", M->CV1_REVISA,nOpcx)

@ 058,190 	SAY Eval(bSx3, "CV1_STATUS")	Of oDlg PIXEL
@ 055,220 	MSCOMBOBOX oCombo VAR M->CV1_STATUS ITEMS aSituacao When .F. SIZE 45,10 OF oDlg PIXEL
//oCombo:lReadOnly := .T.

oGet := MSGetDb():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4] - 150,If(nOpcX = 3, 4, nOpcX),;
"CTB390lOk",, "+CV1_SEQUEN",nOpcX<>5,aAltera,,.T.,,"TMP",,,,,.T.,, "AllWaysTrue")

@ aPosObj[2,1],aPosObj[2,4] - 145 	LISTBOX oPeriodo VAR cPeriodo Fields HEADER Left(Eval(bSx3, "CV1_PERIOD"),3),Eval(bSx3, "CV1_DTINI"),Eval(bSx3, "CV1_DTFIM"),Eval(bSx3, "CV1_VALOR") SIZES 12,30,28,20 SIZE 145,aPosObj[2,3] - aPosObj[2,1] NOSCROLL PIXEL
//oPeriodo:lReadOnly:= (nOpcx == 2 .or. nOpcx == 5)
oPeriodo:lReadOnly:= (nOpcx == 5)
oPeriodo:SetArray(aColsP[Val(TMP->CV1_SEQUEN)])
oPeriodo:bLine := { ||{ aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,1],aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,2],aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,3],Trans(aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,4], cPictVal) } }

oPeriodo:bLostFocus:=  {|| oGet:oBrowse:SetFocus() }

oPeriodo:bLDblClick := {|| Iif(val(TMP->CV1_SEQUEN)>Len(aColsP),Ctb390CarCal(VAL(TMP->CV1_SEQUEN), oPeriodo),), Ctb390Edt(@oPeriodo,aColsP,cPictVal),oPeriodo:GoRight(),;
oPeriodo:GoLeft(),CTB390DspOrc(oOrcado,oVlrOrc,@nOrc,oTotOrc,@nTotOrc)}

oGet:oBrowse:bChange := {|| ct390OnChg(oPeriodo, oOrcado, oVlrOrc, @nOrc,oTotOrc,@nTotOrc,cPictVal,lExecChg )}


If mv_par03 = 1
	@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3], aPosObj[3,4] OF oDlg PIXEL
	
	@ aPosObj[3,1]+005,	010 SAY STR0012 OF oDlg PIXEL //"Total Orcamento"
	@ aPosObj[3,1]+005,054	SAY oTotOrc VAR nTotOrc;
	PICTURE "@E 999,999,999.99" OF oDlg PIXEL FONT oFnt COLOR CLR_HBLUE
	
	@ aPosObj[3,1]+002,aPosObj[3,4] - 145	SAY oOrcado Var STR0011 SIZE 160,14 OF oDlg PIXEL //"Orcado"
	@ aPosObj[3,1]+010,aPosObj[3,4] - 145	SAY oVlrOrc Var STR0026 SIZE 160,14 OF oDlg PIXEL COLOR CLR_HBLUE //"Valor"
Endif

If mv_par03 = 1 .And. (nTotOrc > 0 .Or. !INCLUI)
	dbSelectArea("TMP")
	TMP->(dbGoTop())
	CTB390DspOrc(oOrcado,oVlrOrc,@nOrc,oTotOrc,@nTotOrc)
Endif

If INCLUI .Or. ALTERA
	SetKey( VK_F4 , { || (Ctb390Cop(aColsP[Val(TMP->CV1_SEQUEN)], oPeriodo:nAt), CTB390DspOrc(oOrcado,oVlrOrc,@nOrc,oTotOrc,@nTotOrc)) } )
	SetKey( VK_F5 , { || Ctb390xN(Val(TMP->CV1_SEQUEN),aColsP) 	 })
	aButton := { { "DBG06", {|| Ctb390Cop(aColsP[Val(TMP->CV1_SEQUEN)], oPeriodo:nAt) }, STR0022, STR0045 },; //"Replica Valor - <F4>" "Replica"
	{ "form" , {|| Ctb390xN(Val(TMP->CV1_SEQUEN),aColsP)} , STR0038+" - <F5>",STR0046 } } //"Multiplica por" "Multiplica"
Endif

ACTIVATE MSDIALOG oDlg ON INIT ( lExecChg := .t., EnchoiceBar(oDlg,;
{|| If(oGet:TudoOk() .And. Ctb390Ok(aVarTela),;
(nOpcA:=1,oDlg:End()), nOpcA := 0)}, {||oDlg:End()},, aButton))

SetKey( VK_F4 , Nil)
SetKey( VK_F5 , Nil)

If nOpcA <> 1 .or. nOpcx == 2		/// SE NÃO CONFIRMOU A TELA OU FOR VISUALIZACAO
	TMP->(DbCloseArea())
	If File( cArqTmp + cDbsExt )
		FErase( cArqTmp + cDbsExt )
	EndIf
	RetIndex("CV1")
	//CTB390Fil()
	CV2->(dbSetOrder(nIndCV2))
	CV2->(dbGoTo(nRecCV2))
	RestArea(aAreaBrw)
	//MsSeek(xFilial()+M->(CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA))
	Return(.T.)					//// RETORNA A POSICAO DO CV1 E FINALIZA
Endif

/// PROCESSO PARA A GRAVACAO DO CABECALHO DO ORCAMENTO (CV2)
nCV2Pos := CV2->(Recno())
BEGIN TRANSACTION
If nOpcx == 3
	RecLock("CV2",.T.)		/// SE FOR INCLUSAO, COPIA OU REVISAO
	Field->CV2_FILIAL	:= cCV2Filial
	Field->CV2_ORCMTO	:= M->CV1_ORCMTO
	Field->CV2_CALEND	:= M->CV1_CALEND
	Field->CV2_MOEDA	:= M->CV1_MOEDA
	Field->CV2_REVISA	:= M->CV1_REVISA
	Field->CV2_STATUS	:= M->CV1_STATUS
	CV2->(MsUnlock())
Endif

RecLock("CV2",.F.)
Field->CV2_CALEND	:= M->CV1_CALEND
Field->CV2_MOEDA	:= M->CV1_MOEDA
Field->CV2_REVISA	:= M->CV1_REVISA
Field->CV2_DESCRI	:= M->CV1_DESCRI
If lRevisao .and. lIsAprov
	If lX3Aprova
		Field->CV2_APROVA := cCV1APROVA
	Else
		Field->CV2_APROVA := cUserName
	Endif
Else
	Field->CV2_APROVA   := M->CV1_APROVA
Endif
CV2->(MsUnlock())

END TRANSACTION

FkCommit()			//// EFETIVA A TRANSAÇÃO NO BANCO PARA CONTROLE DE INTEGRIDADE

If mv_par01 == 1
	lAtuSal	:= .T.
Else
	lAtuSal	:= .F.
EndIf

If  lAtuSal .And. INCLUI .And. !lX3Aprova
	M->CV1_STATUS := "2"
Endif

DbSelectArea("TMP")
DbGoTop()
nSequencia := 1

While !Eof()
	
	lIncSeq := .F.
	If nOpcX = 3 .And. TMP->CV1_FLAG
		DbSkip()
		Loop
	Endif
	nLenVal := Len(aColsP[Val(TMP->CV1_SEQUEN)])
	nSEQUEN := Val(TMP->CV1_SEQUEN)
	For nCont := 1 To nLenVal
		DbSelectArea("CV1")
		If TMP->CV1_FLAG .And. aColsP[nSEQUEN][nCont][6] == 0
			Loop
		Endif
		
		If lRevisao .And. Len(aColsP[nSEQUEN][nCont]) > 6
			DbGoTo(aColsP[nSEQUEN][nCont][7])
		Else
			DbGoTo(aColsP[nSEQUEN][nCont][6])
		Endif
		
		BEGIN TRANSACTION
		
		If nOpcX <> 5 .And. !TMP->CV1_FLAG //.And. ! lRevisao
			TMP->CV1_VALOR := aColsP[nSEQUEN][nCont][4]
		Endif
		
		TMP->CV1_MOEDA	:= M->CV1_MOEDA
		TMP->CV1_DTFIM	:= aColsP[nSEQUEN][nCont][3]
		
		If ALTERA .And. CV1->CV1_VALOR 	<> TMP->CV1_VALOR
			lAltValor	:= .T.
		EndIf
		
		If (lRevisao .Or. (nOpcX = 5 .Or. TMP->CV1_FLAG)) .And. CV1->CV1_STATUS == "2"				// Exclusao - Saldo atualizado ou revisado
			Ctb390SlOn(nOpcx,CV1->CV1_VALOR,aColsP[nSEQUEN][nCont][4],lRevisao,lAltValor)
		ElseIf ALTERA .And. ;
			(	CV1->CV1_VALOR 	<> TMP->CV1_VALOR	.Or.;
			TMP->CV1_CT1INI	<> CV1->CV1_CT1INI 	.Or.;
			TMP->CV1_CT1FIM	<> CV1->CV1_CT1FIM 	.Or.;
			TMP->CV1_CTTINI	<> CV1->CV1_CTTINI 	.Or.;
			TMP->CV1_CTTFIM	<> CV1->CV1_CTTFIM 	.Or.;
			TMP->CV1_CTDINI	<> CV1->CV1_CTDINI 	.Or.;
			TMP->CV1_CTDFIM	<> CV1->CV1_CTDFIM 	.Or.;
			TMP->CV1_CTHINI	<> CV1->CV1_CTHINI 	.Or.;
			TMP->CV1_CTHFIM	<> CV1->CV1_CTHFIM .Or.;
			lAltValor) .and. M->CV1_STATUS == "2"   /// USADO M->CV1 NO CASO DE INCLUSÃO DE LINHA NA ALTERACAO (TMP->CV1 ESTARÁ VAZIO)
			Ctb390SlOn(nOpcx,CV1->CV1_VALOR,aColsP[nSEQUEN][nCont][4],lRevisao,lAltValor)
		Endif
		
		RecLock("CV1", aColsP[nSEQUEN][nCont][6] == 0)
		If nOpcX = 5 .Or. TMP->CV1_FLAG
			If nCont = 1
				For i := 1 to Len(aMemos)
					cVar := aMemos[i][2]
					cVar1:= aMemos[i][1]
					&("M->" + cVar) := &("TMP->" + cVar)
					&("M->" + cVar1) := &("TMP->" + cVar1)
					MSMM(&cVar1,TamSx3(aMemos[i][2])[1],,&cVar,2,,,cAlias,cVar1)
				Next i
			Endif
			
			DbDelete()
			
		Else
			CV1_FILIAL := xFilial("CV1")
			For nVarTela := 1 To Len(aVarTela)
				&("CV1->" + aVarTela[nVarTela][1]) := &("M->" + aVarTela[nVarTela][1])
			Next
			
			If nCont = 1
				For i := 1 to Len(aMemos)
					cVar := aMemos[i][2]
					cVar1:= aMemos[i][1]
					&("M->" + cVar) := &("TMP->" + cVar)
					&("M->" + cVar1) := &("TMP->" + cVar1)
					MSMM(&cVar1,TamSx3(aMemos[i][2])[1],,&cVar,1,,,cAlias,StrTran(cVar1, "TMP->", ""))
				Next i
			Endif
			
			For nCpo := 1 To Len(aHeader)
				If (aHeader[nCpo][08] <> "M" .And. aHeader[nCpo][10] <> "V" )
					Replace &(aHeader[nCpo][2]) With &("TMP->" + aHeader[nCpo][2])
				EndIf
			Next
			
			CV1->CV1_PERIOD	:= aColsP[nSEQUEN][nCont][1]
			CV1->CV1_DTINI	:= aColsP[nSEQUEN][nCont][2]
			CV1->CV1_DTFIM	:= aColsP[nSEQUEN][nCont][3]
			
			// O Valor e gravado baseado no TMP->CV1_VALOR quando for por linha
			// Porem as contas para gravacao ja devem estar preenchidas por isso multiplico o TMP
			// Por dois para que grave o valor gravado em CV1_VALOR ja que grava TMP->CV1_VALOR - CV1->CV1_VALOR
			#IFNDEF TOP
				If nOpcX = 3  .And. (TMP->CV1_CTHINI <> TMP->CV1_CTHFIM  .Or. ;
					TMP->CV1_CTDINI <> TMP->CV1_CTDFIM .Or. ;
					TMP->CV1_CTTINI <> TMP->CV1_CTTFIM .Or. ;
					TMP->CV1_CT1INI <> TMP->CV1_CT1FIM)
					TMP->CV1_VALOR	:= aColsP[nSEQUEN][nCont][4] * 2
				Endif
			#ELSE
				If TcSrvType() == "AS/400" 
					If nOpcX = 3  .And. (TMP->CV1_CTHINI <> TMP->CV1_CTHFIM  .Or. ;
						TMP->CV1_CTDINI <> TMP->CV1_CTDFIM .Or. ;
						TMP->CV1_CTTINI <> TMP->CV1_CTTFIM .Or. ;
						TMP->CV1_CT1INI <> TMP->CV1_CT1FIM)
						TMP->CV1_VALOR	:= aColsP[nSEQUEN][nCont][4] * 2
					Endif			                    
				EndIf
			#ENDIF
			
			CV1->CV1_VALOR	:= aColsP[nSEQUEN][nCont][4]
			CV1->CV1_SEQUEN := StrZero(nSequencia, LEN(CV1->CV1_SEQUEN))
			lIncSeq := .T.			
			
			If lX3Aprova
				If lRevisao .and. lIsAprov
					CV1->CV1_APROVA := cCV1APROVA
				Endif
			Else
				CV1->CV1_APROVA := cUserName
			Endif
		Endif
		
		MsUnLock()
		
		END TRANSACTION
		
		FkCommit()			//// EFETIVA A TRANSAÇÃO NO BANCO PARA CONTROLE DE INTEGRIDADE
		
		// Inclusao
		If M->CV1_STATUS == "2" .And. (	nOpcX = 3 .And. aColsP[nSEQUEN][nCont][4]<> 0 .And. !lRevisao)
			Ctb390SlOn(nOpcx,TMP->CV1_VALOR,aColsP[nSEQUEN][nCont][4],lRevisao,lAltValor)			
		Endif
	Next
	
	If lIncSeq
		nSequencia ++
	Endif
	
	DbSelectArea("TMP")
	DbSkip()
EndDo

Begin Transaction
DO CASE
	CASE nOpcX = 5								//// SE FOR EXCLUSAO
		CV2->(dbGoTo(nCV2Pos))
		If CV2->(Recno()) == nCV2Pos
			RecLock("CV2",.F.)
			dbDelete()
			CV2->(MsUnlock())
		Endif
	CASE lRevisao								//// SE FOR REVISAO MARCA O FLAG DE REVISADO (CV1 E CV2)
		DbSelectArea("CV1")
		For nRevisao  := 1 To Len(aColsP)
			For nCont := 1 To Len(aColsP[nRevisao])
				If Len(aColsP[nRevisao][nCont]) > 6 .And. aColsP[nRevisao][nCont][7] > 0
					DbGoto(aColsP[nRevisao][nCont][7])
					RecLock("CV1", .F.)
					Replace CV1_STATUS With "3"
					MsUnLock()
				Endif
			Next
		Next
		
		CV2->(dbSetOrder(1))
		CV2->(dbGoTo(nCV2Pos))
		If CV2->(Recno()) == nCV2Pos
			RecLock("CV2",.F.)
			Field->CV2_STATUS := "3"
			CV2->(MsUnlock())
		Endif
	CASE lAtuSal .And. INCLUI .And. !lX3Aprova
			RecLock("CV2",.F.)
			Field->CV2_STATUS := "2"
			CV2->(MsUnlock())			
ENDCASE
END TRANSACTION

//Caso haja algum registro com os valore debito e credito zerados nos arquivos de saldos, deletar o
//registro fisicamente.
#IFDEF TOP              
	If TcSrvType() != "AS/400" 
		Ctb390Apag("CTI",.T.,M->CV1_MOEDA,xFilial("CTI"))
	
		Ctb390Apag("CT4",.T.,M->CV1_MOEDA,xFilial("CT4"))
	    
		Ctb390Apag("CT3",.T.,M->CV1_MOEDA,xFilial("CT3"))
	
		Ctb390Apag("CT7",.T.,M->CV1_MOEDA,xFilial("CT7"))
	EndIf
#ENDIF
If l390Grv 								/// PE APOS A GRAVACAO DO ORCAMENTO
	ExecBlock("CTB390GRV", .F., .F.,{nOpcX,M->CV1_ORCMTO,M->CV1_CALEND,M->CV1_MOEDA,M->CV1_REVISA})
Endif
TMP->(DbCloseArea())
If File( cArqTmp + cDbsExt )
	FErase( cArqTmp + cDbsExt )
EndIf

RetIndex("CV1")
//CTB390Fil()
//MsSeek(xFilial()+M->(CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA))
CV2->(dbSetOrder(nIndCV2))
CV2->(dbGoTo(nRecCV2))
RestArea(aAreaBrw)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTB390Edt³ Autor ³ Wagner Mobile Costa   ³ Data ³ 02/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida confirmacao da tela de  cadastro de orcamentos	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Edt(oListBox,aColsP)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oListBox = Objeto list-box em edicao                       ³±±
±±³          ³ aColsP    = Array aColsP com dados apresentado             ³±±
±±³          ³ cPictVal = Mascara para edicao de campo de valor           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTB390Edt(oListBox,aColsP,cPictVal)

Local nClick := 0, aEdit := Aclone(aColsP)

nClick := oListBox:nAtCol(4)

If nClick <> 1
	
	CTG->(DbSeek(xFilial() + M->CV1_CALEND))
	While CTG->CTG_CALEND = M->CV1_CALEND .And. ! CTG->(Eof())
		If 	CTG->CTG_STATUS <> "1" .And.;
			aColsP[Val(TMP->CV1_SEQUEN)][oListBox:nAt][1] = CTG->CTG_PERIOD
			Help(" ",1,"CTGDTCOMP")
			Return
		Endif
		CTG->(DbSkip())
	EndDo
	
	lEditCell(aEdit[Val(TMP->CV1_SEQUEN)],oListBox,cPictVal,4)
	aColsP := aClone(aEdit)
	aColsP[Val(TMP->CV1_SEQUEN)] := aEdit[Val(TMP->CV1_SEQUEN)]
	oListBox:Refresh()
	oListBox:SetFocus()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTB390Cop³ Autor ³ Wagner Mobile Costa   ³ Data ³ 28/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida confirmacao da tela de  cadastro de orcamentos	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Cop(aColsP,nPos)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aColsP    = Array aColsP com dados apresentado             ³±±
±±³          ³ nPos      = Linha atual no list de digitacao de valores    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Ctb390Cop(aColsP,nPos)

Local nOrc

For nOrc := nPos + 1 To Len(aColsP)
	aColsP[nOrc][4] := aColsP[nPos][4]
Next

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTB390Ok ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 02/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida confirmacao da tela de  cadastro de orcamentos	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Ok(aVarTela)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Botao de confirmacao                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aVarTela = Variaveis apresentadas em tela                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB390Ok(aVarTela)

Local nVarTela, nRecTmp := TMP->(Recno())
Local cMemCV1 := M->(CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA)

If INCLUI .OR. (ALTERA .AND. cMemCV1 <> CV2->(CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA))
	nOrdCV1 := CV1->(IndexOrd())
	nRecCV1 := CV1->(Recno())
	CV1->(dbSetOrder(1))
	If CV1->(dbSeek(xFilial("CV1")+cMemCV1))
		CV1->(dbSetOrder(nOrdCV1))
		CV1->(dbGoTo(nRecCV1))
		Return .F.
	Endif
Endif

If ExistBlock("CTB390TOK") .And. ! ExecBlock("CTB390TOK", .F., .F.)
	Return .F.
Endif

If INCLUI
	If ! ExistChav("CV1", 	M->CV1_ORCMTO+M->CV1_CALEND+;
		M->CV1_MOEDA+M->CV1_REVISA)
		Return .F.
	Endif
Endif

For nVarTela := 1 To Len(aVarTela)
	If aVarTela[nVarTela][2] .And. Empty(&("M->" + aVarTela[nVarTela][1]))
		HELP("   ",1,"OBRIGAT",,STR0013+aVarTela[nVarTela][1]+SPACE(40),3,0) //"Campo : "
		Return .F.
	Endif
Next

TMP->(DbGoTop())
While ! TMP->(Eof())
	If TMP->CV1_FLAG
		TMP->(DbSkip())
		Loop
	Endif
	
	If (!Empty(TMP->CV1_CT1INI) .And. Empty(TMP->CV1_CT1FIM))	.Or.;
		(Empty(TMP->CV1_CT1INI) .And. !Empty(TMP->CV1_CT1FIM))
		Help(" ",1,"C160NOCTA")
		Return .F.
	EndIf
	
	If (!Empty(TMP->CV1_CTTINI) .And. Empty(TMP->CV1_CTTFIM)) 	.Or.;
		(Empty(TMP->CV1_CTTINI) .And. !Empty(TMP->CV1_CTTFIM))
		Help(" ",1,"C160NOCC")
		Return .F.
	EndIf
	
	If (!Empty(TMP->CV1_CTDINI) .And. Empty(TMP->CV1_CTDFIM)) 	.Or.;
		(Empty(TMP->CV1_CTDINI) .And. !Empty(TMP->CV1_CTDFIM))
		Help(" ",1,"C160NOITEM")
		Return .F.
	EndIf
	
	If (!Empty(TMP->CV1_CTHINI) .And. Empty(TMP->CV1_CTHFIM))	.Or.;
		(Empty(TMP->CV1_CTHINI) .And. !Empty(TMP->CV1_CTHFIM))
		Help(" ",1,"C160NOCLVL")
		Return .F.
	EndIf
	
	If 	Empty(TMP->CV1_CT1INI) .And. Empty(TMP->CV1_CT1FIM) .And.;
		Empty(TMP->CV1_CTTINI) .And. Empty(TMP->CV1_CTTFIM) .And.;
		Empty(TMP->CV1_CTDINI) .And. Empty(TMP->CV1_CTDFIM) .And.;
		Empty(TMP->CV1_CTHINI) .And. Empty(TMP->CV1_CTHFIM)
		Apmsginfo(STR0014, STR0008) //"Indique a entidade a ser orcada !"###"Atencao"
		Return .F.
	Endif
	
	TMP->(DbSkip())
EndDo

TMP->(DbGoto(nRecTmp))

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTB390LOk³ Autor ³ Wagner Mobile Costa   ³ Data ³ 03/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Avalia a linha da GetDb                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390LOk(aVarTela)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida Linha da GetDb                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB390LOk

If 	Empty(TMP->CV1_CT1INI) .And. Empty(TMP->CV1_CT1FIM) .And.;
	Empty(TMP->CV1_CTTINI) .And. Empty(TMP->CV1_CTTFIM) .And.;
	Empty(TMP->CV1_CTDINI) .And. Empty(TMP->CV1_CTDFIM) .And.;
	Empty(TMP->CV1_CTHINI) .And. Empty(TMP->CV1_CTHFIM) .And.;
	! TMP->CV1_FLAG
	Apmsginfo(STR0014, STR0008) //"Indique a entidade a ser orcada !"###"Atencao"
	Return .F.
Endif

If ExistBlock("CTB390LOK") .And. ! ExecBlock("CTB390LOK", .F., .F.)
	Return .F.
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTB390PES³ Autor ³ Claudio D. de Souza   ³ Data ³ 01/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pesquisa com filtro                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390PES()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Pes

AxPesqui()
//Ctb390Fil()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB390CarCal³ Autor ³ Wagner Mobile Costa ³ Data ³ 03/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Carrega definicoes do calendario atual                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390CarCal(nLinGetDb,oPeriodo)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLinGetDb = Identifica a linha atual do GetDb              ³±±
±±³          ³ oPeriodo  = ListBox que contem os periodos digitados       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390CarCal(nLinGetDb, oPeriodo, lTodas, lCopia)

Local aArea := GetArea(), nCont := 1
Local aColsPOld	 := {}
Local cPictVal 	:= ""
Local nP
Local nC

DEFAULT lTodas := .F.
DEFAULT lCopia := .F.
If nLinGetDb == 0 .or. ValType(nLinGetDb) <> "N"
	Return .T.
Endif

If Empty(M->CV1_CALEND) .Or. Empty(M->CV1_MOEDA)
	Return .T.
Endif

CTE->(DbSetOrder(1))
If ! CTE->(DbSeek(xFilial() + M->CV1_MOEDA + M->CV1_CALEND))
	Help("  ",1,"CTGNOCAD")
	Return .F.
Endif

dbSelectArea("CTG")
dbSeek(xFilial()+M->CV1_CALEND)

If lTodas .and. lCopia
	aColsPold := aClone(aColsP)
	aColsP := {}
EndIf
While !Eof() .And. xFilial() == CTG->CTG_FILIAL .And.;
	CTG->CTG_CALEND == M->CV1_CALEND
	
	If Len(aColsP) < nLinGetDb
		AADD(aColsP, {})
	Endif
	
	If Len(aColsP[nLinGetDb]) < nCont
		AADD(aColsP[nLinGetDb], Array(6) )
		aColsP[nLinGetDb][nCont][1]	:= CTG->CTG_PERIOD
		aColsP[nLinGetDb][nCont][2]	:= CTG->CTG_DTINI
		aColsP[nLinGetDb][nCont][3]	:= CTG->CTG_DTFIM
		aColsP[nLinGetDb][nCont][4]	:= 0.00
		aColsP[nLinGetDb][nCont][6]	:= 0
	ElseIf Empty(aColsP[nLinGetDb][nCont][1]) .Or. INCLUI
		aColsP[nLinGetDb][nCont][1]	:= CTG->CTG_PERIOD
		aColsP[nLinGetDb][nCont][2]	:= CTG->CTG_DTINI
		aColsP[nLinGetDb][nCont][3]	:= CTG->CTG_DTFIM
	Endif
	
	nCont++
	dbSkip()
	
EndDo

ASize(aColsP[nLinGetDb], nCont - 1)
If lTodas .and. lCopia
	For nC:= 1 to Len(aColsPOld)
		If nC <> 1
			aAdd(aColsP,aClone(aColsP[1]))
			nCont++
		EndIf
		If Len(aColsPOld) < nC
			Exit
		EndIf			
		For nP := 1 to Len(aColsP[nC])
			If Len(aColsPOld[nC]) < nP
				Exit
			EndIf			
			aColsP[nC][nP][4] := aColsPOld[nC][nP][4]
			aColsP[nC][nP][5] := 0
			aColsP[nC][nP][6] := 0
		Next
	Next
	oPeriodo:SetArray(aColsP[Val(TMP->CV1_SEQUEN)])
	cPictVal := PesqPict("CV1","CV1_VALOR")
	oPeriodo:bLine := { ||{ aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,1],aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,2],aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,3],Trans(aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,4], cPictVal) } }
EndIf

oPeriodo:Refresh()

RestArea(aArea)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTB390POrc ³ Autor ³ Wagner Mobile Costa ³ Data ³ 08/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Avalia se permite a entrada do campo de acordo com o tipo  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390PerOrc()                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390POrc

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTB390Vld  ³ Autor ³ Wagner Mobile Costa ³ Data ³ 10/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida as entidades contabeis digitadas                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Vld()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cVariavel = Nome da variavel para identificar validacao    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Vld(cVariavel)

Local lRet 		:= .T.
Local cNomeCpo	:= ReadVar()
Local cEntidade := Subs(cNomeCpo, 8, 3)
Local lGatilha	:= mv_par02 = 1 .And. cVariavel = Nil .And. Right(cNomeCpo, 3) = "INI"
Local lAlterou  := .F.

If cVariavel = Nil
	cVariavel := &(cNomeCpo)
Endif

dbSelectArea(cEntidade)
dbSetOrder(1)

If Empty(cVariavel)
	Return .T.
Endif

If cEntidade = "CT1"
	lRet := Ctb105Cta(cVariavel)
	If &("TMP->" + StrTran(cNomeCpo, "M->", "")) <> cVariavel
		lAlterou := .T.
	Endif
	If lRet
		ConvConta(@cVariavel)
		&("TMP->" + StrTran(cNomeCpo, "M->", "")) := cVariavel
	Endif
ElseIf cEntidade = "CTT"
	lRet := Ctb105Cc(cVariavel)
	If &("TMP->" + StrTran(cNomeCpo, "M->", "")) <> cVariavel
		lAlterou := .T.
	Endif
	If lRet
		ConvCusto(@cVariavel)
		&("TMP->" + StrTran(cNomeCpo, "M->", "")) := cVariavel
	Endif
ElseIf cEntidade = "CTD"
	lRet := Ctb105Item(cVariavel)
	If &("TMP->" + StrTran(cNomeCpo, "M->", "")) <> cVariavel
		lAlterou := .T.
	Endif
	If lRet
		ConvItem(@cVariavel)
		&("TMP->" + StrTran(cNomeCpo, "M->", "")) := cVariavel
	Endif
Else
	lRet := Ctb105ClVl(cVariavel)
	If &("TMP->" + StrTran(cNomeCpo, "M->", "")) <> cVariavel
		lAlterou := .T.
	Endif
	If lRet      
		ConvClvl(@cVariavel)
		&("TMP->" + StrTran(cNomeCpo, "M->", "")) := cVariavel
	Endif
Endif

If 	lRet .And. lGatilha .And. lAlterou // Se Alterou o conteudo
	&("TMP->" + StrTran(StrTran(cNomeCpo, "M->", ""), "INI", "FIM")) := cVariavel
Endif

If mv_par03 = 1 .And. lRet
	Ctb390CarCal(VAL(TMP->CV1_SEQUEN), oPeriodo)
	CTB390DspOrc(oOrcado,oVlrOrc,@nOrc,oTotOrc,@nTotOrc)
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB390DspOrc³ Autor ³ Wagner Mobile Costa ³ Data ³ 05/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para atualizar a entidade atual da GetDb            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390DspOrc(oOrcado,oVlrOrc,nOrc,oTotOrc,nTotOrc)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oOrcado   = Objeto com a descricao do tipo de orcamento    ³±±
±±³          ³ oVlrOrc   = Objeto com o valor do orcamento da linha       ³±±
±±³          ³ nOrc      = Variavel com o valor da linha atual orcamento  ³±±
±±³          ³ oTotOrc   = Objeto com o total do orcamento          	  ³±±
±±³          ³ nTotOrc   = Variavel com o valor total do orcamento  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB390DspOrc(oOrcado,oVlrOrc,nOrc,oTotOrc,nTotOrc,nSeqColsP)

Local cTitulo 		:= cF3 := "", lMostra, nCont, nCols, nRecno := TMP->(Recno())
Local nEntidades	:= Ct390CtEnt(, @cF3, @lMostra, @cTitulo)

If mv_par03 # 1
	Return .T.
Endif

If ValType(nSeqColsP) <> "N"
	nSeqColsP := Val(TMP->CV1_SEQUEN)
Endif
TMP->CV1_ENTIDA := nEntidades

If nOrc # Nil .And. nSeqColsP <= Len(aColsP)
	nOrc := 0
	For nCont := 1 To Len(aColsP[nSeqColsP])
		nOrc += aColsP[nSeqColsP][nCont][4] * TMP->CV1_ENTIDA
	Next
Endif

If oOrcado <> Nil
	If M->CV1_MOEDA > "01" .And. Empty(&(cF3 + "->" + cF3 + "_DESC" + M->CV1_MOEDA))
		oOrcado:cCaption := &(cF3 + "->" + cF3 + "_DESC01")
	Else
		oOrcado:cCaption := &(cF3 + "->" + cF3 + "_DESC" + M->CV1_MOEDA)
	Endif
	
	oOrcado:cCaption := STR0016 + AllTrim(cTitulo) + " "+ /*"Orcado "*/If(lMostra, AllTrim(oOrcado:cCaption) + " ", "")
	oVlrOrc:cCaption := AllTrim(Trans(nOrc, Tm(0, 14, 2)))
	oOrcado:Refresh()
	oVlrOrc:Refresh()
Endif

If nTotOrc <> Nil
	nTotOrc := 0
	TMP->(DbGoTop())
	While TMP->(!Eof())
		If TMP->CV1_FLAG
			TMP->(dbSkip())
			Loop
		Endif
		nSeqColsP := Val(TMP->CV1_SEQUEN)
		For nCont := 1 To Len(aColsP[nSeqColsP])
			nTotOrc += aColsP[nSeqColsP][nCont][4] * TMP->CV1_ENTIDA
		Next
		TMP->(dbSkip())
	EndDo
	TMP->(DbGoTo(nRecno))
	If oTotOrc <> Nil
		oTotOrc:Refresh()
	Endif
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CT390CtEnt ³ Autor ³ Wagner Mobile Costa ³ Data ³ 05/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que conta o numero de entidades                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CT390CtEnt(cF3,cTitulo)                      			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cF3       = Tabela do valor final do orcamento             ³±±
±±³          ³ lMostra   = Indica se apresenta descricao da entidade      ³±±
±±³          ³ cTitulo   = Titulo da entidade orcada                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CT390CtEnt(cAlias, cF3, lMostra, cTitulo)

Local nEntida1 := nEntida2 := nEntida3 := nEntida4 := nEntidades := 1, aArea := {}
Local aAlias   := If(cTitulo = Nil, GetArea(),)
Local cTabela  := If(cF3 = Nil, "", cF3), aCadastro

DEFAULT cAlias := "TMP"

If ! Empty(cTabela)
	If cTabela = "CT7"
		aCadastro := CT1->(GetArea())
	ElseIf cTabela = "CT3"
		aCadastro := CTT->(GetArea())
	ElseIf cTabela = "CT4"
		aCadastro := CTD->(GetArea())
	ElseIf cTabela = "CTI"
		aCadastro := CTH->(GetArea())
	Endif
Endif

If ! Empty((cAlias)->CV1_CTHINI)
	cF3	:= "CTH"
	DbSelectArea(cF3)
	MsSeek(xFilial() + (cAlias)->CV1_CTHINI)
	lMostra := (cAlias)->CV1_CTHINI = (cAlias)->CV1_CTHFIM
	
	If ! lMostra .Or. 	(cAlias)->CV1_CTDINI # (cAlias)->CV1_CTDFIM .Or.;
		(cAlias)->CV1_CTTINI # (cAlias)->CV1_CTTFIM .Or.;
		(cAlias)->CV1_CT1INI # (cAlias)->CV1_CT1FIM
		If ! lMostra .And. (Empty(cTabela) .Or. cTabela $ "CT7,CT3,CT4")
			aArea := GetArea()
			nEntida3 := 0
			CT390EntP("CTH", (cAlias)->CV1_CTHINI, (cAlias)->CV1_CTHFIM, @nEntida3)
			RestArea(aArea)
		Else
			nEntida3 := 1
		Endif
		
		If (cAlias)->CV1_CTDINI # (cAlias)->CV1_CTDFIM .And. (Empty(cTabela) .Or. cTabela $ "CT7,CT3")
			nEntida2 := 0
			CT390EntP("CTD", (cAlias)->CV1_CTDINI, (cAlias)->CV1_CTDFIM, @nEntida2)
		Else
			nEntida2 := 1
		Endif
		
		If (cAlias)->CV1_CTTINI # (cAlias)->CV1_CTTFIM .And. (Empty(cTabela) .Or. cTabela $ "CT7")
			nEntida1 := 0
			CT390EntP("CTT", (cAlias)->CV1_CTTINI, (cAlias)->CV1_CTTFIM, @nEntida1)
		Else
			nEntida1 := 1
		Endif
		
		If (cAlias)->CV1_CT1INI # (cAlias)->CV1_CT1FIM .And. Empty(cTabela)
			nEntidades := 0
			CT390EntP("CT1", (cAlias)->CV1_CT1INI, (cAlias)->CV1_CT1FIM, @nEntidades)
		Endif
		
		nEntidades *= nEntida1
		nEntidades *= nEntida2
		nEntidades *= nEntida3
	Endif
ElseIf ! Empty((cAlias)->CV1_CTDINI)
	cF3		:= "CTD"
	DbSelectArea(cF3)
	MsSeek(xFilial() + (cAlias)->CV1_CTDINI)
	lMostra := (cAlias)->CV1_CTDINI = (cAlias)->CV1_CTDFIM
	
	If ! lMostra .Or. 	(cAlias)->CV1_CTTINI # (cAlias)->CV1_CTTFIM .Or.;
		(cAlias)->CV1_CT1INI # (cAlias)->CV1_CT1FIM
		If ! lMostra .And. (Empty(cTabela) .Or. cTabela $ "CT7,CT3")
			aArea := GetArea()
			nEntida1 := 0
			CT390EntP("CTD", (cAlias)->CV1_CTDINI, (cAlias)->CV1_CTDFIM, @nEntida1)
			RestArea(aArea)
		Else
			nEntida1 := 1
		Endif
		
		If (cAlias)->CV1_CTTINI # (cAlias)->CV1_CTTFIM .And. (Empty(cTabela) .Or. cTabela $ "CT7")
			nEntida2 := 0
			CT390EntP("CTT", (cAlias)->CV1_CTTINI, (cAlias)->CV1_CTTFIM, @nEntida2)
		Else
			nEntida2 := 1
		Endif
		
		If (cAlias)->CV1_CT1INI # (cAlias)->CV1_CT1FIM .And. Empty(cTabela)
			nEntidades := 0
			CT390EntP("CT1", (cAlias)->CV1_CT1INI, (cAlias)->CV1_CT1FIM, @nEntidades)
		Endif
		
		nEntidades *= nEntida1
		nEntidades *= nEntida2
	Endif
ElseIf ! Empty((cAlias)->CV1_CTTINI)
	cF3		:= "CTT"
	DbSelectArea(cF3)
	MsSeek(xFilial() + (cAlias)->CV1_CTTINI)
	lMostra := (cAlias)->CV1_CTTINI = (cAlias)->CV1_CTTFIM
	If ! lMostra .Or. (cAlias)->CV1_CT1INI # (cAlias)->CV1_CT1FIM
		If ! lMostra .And. (Empty(cTabela) .Or. cTabela $ "CT7")
			aArea := GetArea()
			nEntida1 := 0
			CT390EntP("CTT", (cAlias)->CV1_CTTINI, (cAlias)->CV1_CTTFIM, @nEntida1)
			RestArea(aArea)
		Else
			nEntida1 := 1
		Endif
		
		If (cAlias)->CV1_CT1INI # (cAlias)->CV1_CT1FIM .And. Empty(cTabela)
			nEntidades := 0
			CT390EntP("CT1", (cAlias)->CV1_CT1INI, (cAlias)->CV1_CT1FIM, @nEntidades)
		Endif
		
		nEntidades *= nEntida1
	Endif
Else
	cF3		:= "CT1"
	cTitulo := STR0015 //"Conta Contabil"
	DbSelectArea(cF3)
	MsSeek(xFilial() + (cAlias)->CV1_CT1INI)
	lMostra := (cAlias)->CV1_CT1INI = (cAlias)->CV1_CT1FIM
	If ! lMostra .And. Empty(cTabela)
		aArea := GetArea()
		nEntidades := 0
		CT390EntP("CT1", (cAlias)->CV1_CT1INI, (cAlias)->CV1_CT1FIM, @nEntidades)
		RestArea(aArea)
	Endif
Endif

If cF3 # Nil .And. Empty(cTitulo)
	cTitulo := CtbSayApro(cF3)
Endif

If cTabela = "CT7" .And. aCadastro # Nil
	CT1->(RestArea(aCadastro))
ElseIf cTabela = "CT3" .And. aCadastro # Nil
	CTT->(RestArea(aCadastro))
ElseIf cTabela = "CT4" .And. aCadastro # Nil
	CTD->(RestArea(aCadastro))
ElseIf cTabela = "CTI" .And. aCadastro # Nil
	CTH->(RestArea(aCadastro))
Endif

If aAlias # Nil
	RestArea(aAlias)
Endif

Return nEntidades

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CT390CtEnt ³ Autor ³ Wagner Mobile Costa ³ Data ³ 05/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que conta o numero de entidades                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CT390EntP(cEntidade, cInicio, cFim, uRet)          		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cEntidade = Entidade para retorno das analiticas           ³±±
±±³          ³ cInicio   = Codigo inicial para retorno                    ³±±
±±³          ³ cFim      = Codigo final   para retorno                    ³±±
±±³          ³ uRet      = Array ou valor para retorno dos itens          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CT390EntP(cEntidade, cInicio, cFim, uRet)

Local aArea := (cEntidade)->(GetArea())

If cEntidade = "CTH"
	CTH->(DbSetOrder(2))
	CTH->(DbSeek(xFilial() + "2" + cInicio, .T.))
	While 	CTH->CTH_CLVL <= cFim .And. CTH->CTH_CLASSE = "2" .And.;
		! CTH->(Eof())
		If ValType(uRet) = "A"
			Aadd(uRet, CTH->CTH_CLVL)
		Else
			uRet ++
		Endif
		CTH->(DbSkip())
	EndDo
ElseIf cEntidade = "CTD"
	CTD->(DbSetOrder(2))
	CTD->(DbSeek(xFilial() + "2" + cInicio, .T.))
	While 	CTD->CTD_ITEM <= cFim .And. CTD->CTD_CLASSE = "2" .And.;
		! CTD->(Eof())
		If ValType(uRet) = "A"
			Aadd(uRet, CTD->CTD_ITEM)
		Else
			uRet ++
		Endif
		CTD->(DbSkip())
	EndDo
ElseIf cEntidade = "CTT"
	CTT->(DbSetOrder(2))
	CTT->(DbSeek(xFilial() + "2" + cInicio, .T.))
	While 	CTT->CTT_CUSTO <= cFim .And. CTT->CTT_CLASSE = "2" .And.;
		! CTT->(Eof())
		If ValType(uRet) = "A"
			Aadd(uRet, CTT->CTT_CUSTO)
		Else
			uRet ++
		Endif
		CTT->(DbSkip())
	EndDo
ElseIf cEntidade = "CT1"
	CT1->(DbSetOrder(3))
	CT1->(DbSeek(xFilial() + "2" + cInicio, .T.))
	While 	CT1->CT1_CONTA <= cFim .And. CT1->CT1_CLASSE = "2" .And.;
		! CT1->(Eof())
		If ValType(uRet) = "A"
			Aadd(uRet, CT1->CT1_CONTA)
		Else
			uRet ++
		Endif
		CT1->(DbSkip())
	EndDo
Endif

If ValType(uRet) = "A" .And. Len(uRet) = 0
	uRet := { Space(Len(cInicio)) }
Endif

(cEntidade)->(RestArea(aArea))

Return uRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB390Sal ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 08/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para geracao/atualizacao do orcamento nos saldos    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Sal(lSoLinha,lReproc)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Disponibilizar os valores orcados  para  os  balancetes  e ³±±
±±³          ³ demonstrativos contabeis                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lSoLinha = Indica se esta sendo chamada linha  a  linha  na³±±
±±³          ³            gravacao do orcamento                           ³±±
±±³          ³ lReproc  = Indica se esta efetuada chamada para reprocessar³±±
±±³          ³ cFilDe   = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ cFilAte  = Filial final para reprocessar (CTBA190)     	  ³±±
±±³          ³ dDataIni = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ dDataIni = Filial final para reprocessar (CTBA190)     	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB390Sal(lSoLinha, lReproc, cFilDe, cFilAte, dDataIni, dDataFim, nOpcx, cOperacao,lAltValor,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)

Local aArea   	:= GetArea(), lAtualizou := .F., nRecno
Local aOrcamentos, lInclui := .T., nOrcamento, nOrcados, cOrcamento := ""
Local nCont		:= 0
Local lX3Aprova := .F.
Local bCond	:= {||.F.}
Local bCondPula	:= {||.F.}
Local cKeyOrcAnt	:= ""
Local lX3STATSL		:= .F.

DEFAULT lSoLinha := .F.
DEFAULT lReproc  := .F.
DEFAULT nOpcX	 := 3
DEFAULT cOperacao:= "1"
DEFAULT cFilDe	 := cFilAnt
DEFAULT cFilAte	 := cFilAnt
DEFAULT dDataIni := CTOD("  /  /  ")
DEFAULT dDataFim := CTOD("  /  /  ")
DEFAULT lAltValor:= .F.
DEFAULT nFatorCTH := 1
DEFAULT nFatorCTHA:= 1
DEFAULT nFatorCTD := 1
DEFAULT nFatorCTDA:= 1
DEFAULT nFatorCTT := 1
DEFAULT nFatorCTTA:= 1

If GetMV("MV_ORCAPRV") == "S"
	lX3Aprova := .T.
Endif

dbSelectArea("CV2")
If FieldPos("CV2_STATSL") > 0
	lX3STATSL := .T.
EndIf

dbSelectArea("CV1")

If !lSoLinha .And. !lReproc
	If !Pergunte("CTB391", .T.)
		Pergunte("CTB390", .F.)
		Return .F.
	Endif
Endif

If !lSoLinha		//// SE NÃO FOR SOMENTE ALTERACAO DE LINHA (GERACAO NORMAL)
	
	DbSelectArea("CV1")
	DbSetOrder(1)
	
	If !lReproc			///  SE NÃO FOR REPROCESSAMENTO
		M->CV1_ORCMTO 	:= CV2->CV2_ORCMTO
		M->CV1_CALEND	:= CV2->CV2_CALEND
		M->CV1_MOEDA	:= CV2->CV2_MOEDA
		M->CV1_REVISA	:= CV2->CV2_REVISA
		
		MsSeek(xFilial("CV1")+mv_par01)		              
		
		bCond		:= 	{||(CV1->CV1_FILIAL == xFilial("CV1") .And. CV1->CV1_ORCMTO >= mv_par01 .And. CV1->CV1_ORCMTO <= mv_par02 )}		
					   
							
		bCondPula	:= 	{||(	CV1->CV1_CALEND < mv_par03 .Or. CV1->CV1_CALEND > mv_par04  .Or. ;
								CV1->CV1_MOEDA  < mv_par05 .Or. CV1->CV1_MOEDA  > mv_par06 .Or. ;
								CV1->CV1_REVISA < mv_par07 .Or. CV1->CV1_REVISA > mv_par08 )}		
	Else
		If Empty(xFilial("CV1"))
			cFilDe := cFilAte := Space(2)
		Endif
		bCond		:= 	{||(CV1->CV1_FILIAL >= cFilDe .And. CV1->CV1_FILIAL <= cFilAte)}				
						
		bCondPula	:= {||(	DTOS(CV1->CV1_DTFIM) < DTOS(dDataIni) .Or. DTOS(CV1->CV1_DTFIM) > DTOS(dDataFim).Or. ;
							 CV1->CV1_STATUS <> "2")}
	Endif
	
	DbSelectArea("CV1")
Else
	DbSelectArea("TMP")
Endif

//Begin TRANSACTION EXTENDED

While !Eof() .And. Eval(bCond)

	//Verificar os fatores de multiplicacao para cada entidade (Deve executar independente de processo)
	nFatorCTH	:= Ctb390Recn("CTH",CV1->CV1_CTHINI,CV1->CV1_CTHFIM,"CTH_CLVL")
	nFatorCTD	:= Ctb390Recn("CTD",CV1->CV1_CTDINI,CV1->CV1_CTDFIM,"CTD_ITEM")
	nFatorCTT	:= Ctb390Recn("CTT",CV1->CV1_CTTINI,CV1->CV1_CTTFIM,"CTT_CUSTO")
	
	If !lSoLinha
		If Eval(bCondPula)
			dbSelectarea("CV1")
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If !lSoLinha
		If !lReproc
			If aOrcamentos = Nil .Or. CV1->CV1_ORCMTO <> cOrcamento
				If aOrcamentos # Nil .And. lInclui
					nOrcados := Len(aOrcamento)
				Else
					nOrcados := 0
				Endif
				
				If nOrcados > 0
					nRecno := CV1->(Recno())
				Endif
				For nOrcamento := 1 To nOrcados
					CV1->(DbGoto(aOrcamento[nOrcamento]))
					lAtualizou := .F.
					CT390GrSal(@lAtualizou, lSoLinha, .T.,nOpcX,cOperacao,,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)
				Next
				If nOrcados > 0
					CV1->(DbGoto(nRecno))
				Endif
				
				If aOrcamentos = Nil
					aOrcamentos := {}
				Endif
				lInclui := .T.
			Endif
			
			If CV1->CV1_STATUS = "1" .And. If(lX3Aprova,!Empty(CV1->CV1_APROVA),.T.) .And. CV1->CV1_CT1INI = CV1->CV1_CT1FIM .And. CV1->CV1_CTTINI = CV1->CV1_CTTFIM .And. CV1->CV1_CTDINI = CV1->CV1_CTDFIM .And. CV1->CV1_CTHINI = CV1->CV1_CTHFIM
				Aadd(aOrcamentos, CV1->(Recno()))
			ElseIf CV1->CV1_STATUS != "1"
				lInclui := .F.
				nCont++		// Contador de registros lidos e nao gerados
			Else
				nCont++
			Endif
		Endif
	Endif
	
	If !lSoLinha .And. !lReproc
		cOrcamento := CV1->CV1_ORCMTO
		lAtualizou := .F.

		If CV1->CV1_STATUS # "1"		// Somente gero saldo para os nao gerados
			DbSelectArea("CV1")
			DbSkip()
			Loop
		Endif
			
		If lX3Aprova		//// SE CONTROLE DE APROVACAO ESTIVER HABILITADO (MV_ORCAPRV)
			If Empty(CV1->CV1_APROVA)
				DbSelectArea("CV1")
				DbSkip()
				Loop
			Endif
		Endif

		If lX3STATSL
			If cKeyOrcAnt <> CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA)
				If CV2->(dbSeek(CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA),.F.))
					RecLock("CV2",.F.)
					Field->CV2_STATSL := "1"
					CV2->(MsUnlock())
					cKeyOrcAnt := CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA)
				EndIf
			EndIf
		EndIf
	EndIf
	
	Begin TRANSACTION EXTENDED
	lAtualizou := .F.
	CT390GrSal(@lAtualizou, lSoLinha,,nOpcx,cOperacao,lAltValor,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)
	
	If !lSoLinha .And. lAtualizou
		DbSelectArea("CV1")
		RecLock("CV1", .F.)
		CV1_STATUS	:= "2"		// Gerado Saldo
		If !lX3Aprova .and. Empty(CV1->CV1_APROVA)
			CV1_APROVA := cUserName
		Endif
		MsUnLock()
		
		dbSelectArea("CV2")
		dbSetOrder(1)
		If MsSeek(CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA)) .and. CV2->CV2_STATUS == "1"
			RecLock("CV2",.F.)
			Field->CV2_STATUS := "2"		/// Gerado Saldo
			If !lX3Aprova .and. Empty(CV2->CV2_APROVA)
				CV2_APROVA := cUserName
			Endif
			CV2->(MsUnlock())
		Endif
		
	Endif
	
	End Transaction
	
	If lSoLinha
		Exit
	Endif
	
	DbSelectArea("CV1")
	DbSkip()
EndDo

//End Transaction


If (lReproc .Or. (! lReproc .And. ! lSoLinha)) .And. nCont > 0
	//Apmsginfo(STR0027, STR0008)
	Aviso(STR0008,STR0027,{"OK"})
EndIf

If aOrcamentos # Nil .And. lInclui
	nOrcados := Len(aOrcamento)
Else
	nOrcados := 0
Endif

For nOrcamento := 1 To nOrcados
	CV1->(DbGoto(aOrcamento[nOrcamento]))
	lAtualizou := .F.
	CT390GrSal(@lAtualizou, lSoLinha, .T.,nOpcX,cOperacao,lAltValor,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)
Next


RestArea(aArea)

If ! lSoLinha .And. ! lReproc
	Pergunte("CTB390", .F.)
Endif

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CT390GrSal³ Autor ³ Wagner Mobile Costa   ³ Data ³ 01/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para gravacao dos saldos contabeis do orcamento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CT390GrSal(lAtualizou, lSoLinha, lChkOrc)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Grava o saldo contabil para as entidades de acordo  com  o ³±±
±±³          ³ inicial/final informado no orcamento                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lAtualizou = Indica se foi gerado saldo para a linha       ³±±
±±³          ³ lSoLinha = Indica se esta sendo chamada linha  a  linha  na³±±
±±³          ³            gravacao do orcamento                           ³±±
±±³          ³ lChkOrc  = Indica se verifica o orcamento para gerar       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CT390GrSal(lAtualizou, lSoLinha, lChkOrc, nOpcx, cOperacao, lAltValor,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)

Local nDebito := nCredito := nAtuDeb := nAtuCrd := 0.00, lInclui, aSldAnt
Local aCt1, aCtt, aCtd, nLoop, nLoop2, nLoop3, nEntida, nEntida2
Local bCondCT1	:= {||.F.}
Local bCondCTT	:= {||.F.}
Local bCondCTH	:= {||.F.}
Local bCondCTD	:= {||.F.}
Local lAltEntid	:= .F.
Local lX3Aprova	:= .F.

DEFAULT lChkOrc 	:= .F.
DEFAULT nOpcX		:= 3
DEFAULT cOperacao   := "1"
DEFAULT lAltValor	:= .F.

If GetMV("MV_ORCAPRV") == "S"
	lX3Aprova := .T.
Endif

If lChkOrc
	If CV1->CV1_STATUS # "1"		// Somente gero saldo para os nao gerados
		Return
	Endif
	
	If lX3Aprova		//// SE CONTROLE DE APROVACAO ESTIVER HABILITADO (MV_ORCAPRV)
		If Empty(CV1->CV1_APROVA)
			Return
		Endif
	Endif
	
Endif

//Se for gravacao de saldos on-line, verificar se foi alterado alguma entidade para definir qual o fator de multiplicacao que
//devera ser utilizado.
If lSoLinha
	If (CV1->CV1_CTHINI <> TMP->CV1_CTHINI .Or. CV1->CV1_CTHFIM <> TMP->CV1_CTHFIM ) .Or. ;
		(CV1->CV1_CTDINI <> TMP->CV1_CTDINI .Or. CV1->CV1_CTDFIM <> TMP->CV1_CTDFIM ) .Or. ;
		(CV1->CV1_CTTINI <> TMP->CV1_CTTINI .Or. CV1->CV1_CTTFIM <> TMP->CV1_CTTFIM ) .Or. ;
		(CV1->CV1_CT1INI <> TMP->CV1_CT1INI .Or. CV1->CV1_CT1FIM <> TMP->CV1_CT1FIM )
		lAltEntid	:= .T.
	EndIf
EndIf

//If ! Empty(CV1->CV1_CTHINI) .And. ! Empty(CV1->CV1_CTHFIM)		// Orcamento de Classe de Valor
If lSolinha .And. (lAltEntid .Or. lAltValor)
	If cOperacao == "2"
		bCondCTH	:= { ||! Empty(CV1->CV1_CTHINI) .And. ! Empty(CV1->CV1_CTHFIM)}
		cAlias		:= "CV1"
	Else
		bCondCTH	:= { ||! Empty(TMP->CV1_CTHINI) .And. ! Empty(TMP->CV1_CTHFIM)}
		cAlias		:= "TMP"
	Endif
Else
	bCondCTH	:= { ||! Empty(CV1->CV1_CTHINI) .And. ! Empty(CV1->CV1_CTHFIM)}
	cAlias		:= "CV1"
EndIf

aCt1 := {}
aCtt := {}
aCtd := {}

CT390EntP("CT1", (cAlias)->CV1_CT1INI, (cAlias)->CV1_CT1FIM, aCt1)
CT390EntP("CTT", (cAlias)->CV1_CTTINI, (cAlias)->CV1_CTTFIM, aCtt)
CT390EntP("CTD", (cAlias)->CV1_CTDINI, (cAlias)->CV1_CTDFIM, aCtd)

If Eval(bCondCTH)
	CT1->(DbSetOrder(1))
	
	CTH->(MsSeek(xFilial() + (cAlias)->CV1_CTHINI))
	While 	CTH->CTH_FILIAL = xFilial("CTH") .And.;
		CTH->CTH_CLVL <= (cAlias)->CV1_CTHFIM .And. ! CTH->(Eof())
		
		DbSelectArea("CTI")
		DbSetOrder(2)
		For nLoop := 1 To Len(aCt1)
			For nLoop2 := 1 To Len(aCtt)
				For nLoop3 := 1 To Len(aCtd)
					CT1->(MsSeek(xFilial() + aCt1[nLoop]))
					
					MsSeek(	xFilial() + aCt1[nLoop] + aCtt[nLoop2] +;
					aCtd[nLoop3] + CTH->CTH_CLVL + (cAlias)->CV1_MOEDA + "0" +;
					Dtos((cAlias)->CV1_DTFIM), .T.)
					
					lInclui := .F.
					If 	! (	CTI_FILIAL = xFilial("CTI") .And. CTI_CONTA = aCt1[nLoop] .And.;
						CTI_CUSTO = aCtt[nLoop2] .And. CTI_ITEM = aCtd[nLoop3] .And.;
						CTI_CLVL = CTH->CTH_CLVL .And.;
						CTI_MOEDA = (cAlias)->CV1_MOEDA .And.;
						CTI_TPSALD = "0" .And. CTI_DATA = (cAlias)->CV1_DTFIM)
						
						RecLock("CTI", .T.)
						CTI_FILIAL 	:= xFilial()
						CTI_CLVL 	:= CTH->CTH_CLVL
						CTI_ITEM 	:= aCtd[nLoop3]
						CTI_CUSTO	:= aCtt[nLoop2]
						CTI_CONTA	:= aCt1[nLoop]
						CTI_MOEDA	:= (cAlias)->CV1_MOEDA
						CTI_TPSALD 	:= "0"
						CTI_DATA	:= (cAlias)->CV1_DTFIM
						CTI_STATUS	:= "1"
						CTI_LP 		:= "N"
						lInclui 	:= .T.
					Else
						RecLock("CTI", .F.)
					Endif
					
					CTI_SLBASE 	:= "S"
					CTI_SLCOMP	:= "N"
					
					nDebito := nCredito := 0.00
					If CT1->CT1_NORMAL = "1"
						If lSoLinha
							//							If cOperacao == "1" .Or. (TMP->CV1_VALOR <> 0 .And. lAltValor)  //Se alterou o valor, considera o valor do arquivo temporario
							If cOperacao == "1" .And. ((TMP->CV1_VALOR <> 0 .And. lAltValor) .Or. lInclui .Or. lAltEntid)  //Se alterou o valor, considera o valor do arquivo temporario
								If TMP->CV1_VALOR < 0
									nCredito := Abs(TMP->CV1_VALOR)
								Else
									nDebito  := TMP->CV1_VALOR
								Endif
							Else
								If CV1->CV1_VALOR < 0
									nCredito := Abs(CV1->CV1_VALOR)
								Else
									nDebito  := CV1->CV1_VALOR
								Endif
							EndIf
						Else
							If CV1->CV1_VALOR < 0
								nCredito := Abs(CV1->CV1_VALOR)
							Else
								nDebito  := CV1->CV1_VALOR
							Endif
						EndIf
					Else
						If lSoLinha
							If cOperacao == "1" .Or. ((TMP->CV1_VALOR <> 0 .And. lAltValor) .Or. lInclui .Or. lAltEntid)  //Se alterou o valor, considera o valor do arquivo temporario
								If TMP->CV1_VALOR < 0
									nDebito  := Abs(TMP->CV1_VALOR)
								Else
									nCredito := TMP->CV1_VALOR
								Endif
							Else
								If CV1->CV1_VALOR < 0
									nDebito  := Abs(CV1->CV1_VALOR)
								Else
									nCredito := CV1->CV1_VALOR
								Endif
							Endif
						Else
							If CV1->CV1_VALOR < 0
								nDebito  := Abs(CV1->CV1_VALOR)
							Else
								nCredito := CV1->CV1_VALOR
							Endif
						Endif
					EndIf
					/*
					If lSoLinha .And. (TMP->CV1_VALOR <> CV1->CV1_VALOR)
					If nDebito <> 0
					nDebito := Abs(Abs(TMP->CV1_VALOR) - Abs(CV1->CV1_VALOR))
					Endif
					If nCredito <> 0
					nCredito := Abs(Abs(TMP->CV1_VALOR) - Abs(CV1->CV1_VALOR))
					Endif
					Endif
					*/
					If cOperacao == "1"
						CTI_DEBITO += nDebito
						CTI_CREDIT += nCredito
					ElseIf cOperacao == "2"
						CTI_DEBITO -= nDebito
						CTI_CREDIT -= nCredito
					EndIf
					CTI_ATUDEB := CTI_ANTDEB + CTI_DEBITO
					CTI_ATUCRD := CTI_ANTCRD + CTI_CREDIT
					
					If 	CTI_DEBITO = 0 .AND. CTI_CREDIT = 0
						DbDelete()
					Endif
					
					nAtuDeb := CTI_ATUDEB
					nAtuCrd := CTI_ATUCRD
					
					MsUnLock()
					
					If lInclui
						aSldAnt 	:= SldAntCTI(aCt1[nLoop],aCtt[nLoop2],;
						aCtd[nLoop3],CTH->CTH_CLVL,;
						(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,"0",,.T.)
						nAntDeb		:= aSldAnt[1]
						nAntCrd		:= aSldAnt[2]
						RecLock("CTI", .F.)
						CTI_ANTDEB	:= nAntDeb
						CTI_ANTCRD	:= nAntCrd
						CTI_ATUDEB 	:= CTI_ANTDEB + CTI_DEBITO
						CTI_ATUCRD 	:= CTI_ANTCRD + CTI_CREDIT
						
						If 	CTI_DEBITO = 0 .AND. CTI_CREDIT = 0
							DbDelete()
						Endif
						MsUnLock()
						
						nAtuDeb := CTI_ATUDEB
						nAtuCrd := CTI_ATUCRD
					Endif
					
					DbSkip()
					
					While 	! Eof() .And. CTI_FILIAL = xFilial("CTI") .And.;
						CTI_CONTA = aCt1[nLoop] .And. CTI_CUSTO = aCtt[nLoop2] .And.;
						CTI_ITEM = aCtd[nLoop3] .And. CTI_CLVL = CTH->CTH_CLVL .And.;
						CTI_MOEDA = (cAlias)->CV1_MOEDA .And. CTI_TPSALD = "0"
						RecLock("CTI", .F.)
						CTI_SLBASE 	:= "S"
						CTI_SLCOMP	:= "N"
						CTI_ANTDEB 	:= nAtuDeb
						CTI_ANTCRD 	:= nAtuCrd
						CTI_ATUDEB := CTI_ANTDEB + CTI_DEBITO
						CTI_ATUCRD := CTI_ANTCRD + CTI_CREDIT
						
						nAtuDeb := CTI_ATUDEB
						nAtuCrd := CTI_ATUCRD
						
						If 	CTI_DEBITO = 0 .AND. CTI_CREDIT = 0
							DbDelete()
						Endif
						MsUnLock()
						DbSkip()
					EndDo
				Next
			Next
		Next
		DbSelectArea("CTH")
		DbSkip()
	EndDo
	
	lAtualizou := .T.
Endif

If lSolinha .And. lAltEntid
	If cOperacao == "2"
		bCondCTD	:= { ||! Empty(CV1->CV1_CTDINI) .And. ! Empty(CV1->CV1_CTDFIM)}
		cAlias		:= "CV1"
	Else
		bCondCTD	:= { ||! Empty(TMP->CV1_CTDINI) .And. ! Empty(TMP->CV1_CTDFIM)}
		cAlias		:= "TMP"
	EndIf
Else
	bCondCTD	:= { ||! Empty(CV1->CV1_CTDINI) .And. ! Empty(CV1->CV1_CTDFIM)}
	cAlias		:= "CV1"
EndIf


If Eval(bCondCTD)
	
	CT1->(DbSetOrder(1))
	
	CTD->(MsSeek(xFilial() + (cAlias)->CV1_CTDINI))
	While 	CTD->CTD_FILIAL = xFilial("CTD") .And.;
		CTD->CTD_ITEM <= (cAlias)->CV1_CTDFIM .And. ! CTD->(Eof())
		DbSelectArea("CT4")
		DbSetOrder(2)
		For nLoop := 1 To Len(aCt1)
			For nLoop2 := 1 To Len(aCtt)
				If lSoLinha
					nEntida  := Ct390CtEnt(, "CT4")
					nEntida2 := Ct390CtEnt("CV1", "CT4")
				Else
					nEntida  := Ct390CtEnt("CV1", "CT4")
				Endif
				
				MsSeek(	xFilial() + aCt1[nLoop] + aCtt[nLoop2] + CTD->CTD_ITEM +;
				(cAlias)->CV1_MOEDA + "0" + Dtos((cAlias)->CV1_DTFIM), .T.)
				lInclui := .F.
				If 	! (	CT4_FILIAL = xFilial("CT4") .And. CT4_CONTA = aCt1[nLoop] .And.;
					CT4_CUSTO = aCtt[nLoop2] .And. CT4_ITEM = CTD->CTD_ITEM .And.;
					CT4_MOEDA = (cAlias)->CV1_MOEDA .And.;
					CT4_TPSALD = "0" .And. CT4_DATA = (cAlias)->CV1_DTFIM)
					
					RecLock("CT4", .T.)
					CT4_FILIAL 	:= xFilial()
					CT4_ITEM 	:= CTD->CTD_ITEM
					CT4_CUSTO	:= aCtt[nLoop2]
					CT4_CONTA	:= aCt1[nLoop]
					CT4_MOEDA	:= (cAlias)->CV1_MOEDA
					CT4_TPSALD 	:= "0"
					CT4_DATA	:= (cAlias)->CV1_DTFIM
					CT4_STATUS	:= "1"
					CT4_LP 		:= "N"
					lInclui 	:= .T.
				Else
					RecLock("CT4", .F.)
				Endif
				
				CT4_SLBASE 	:= "S"
				CT4_SLCOMP	:= "N"
				
				nDebito := nCredito := 0.00
				CT1->(MsSeek(xFilial() + aCt1[nLoop]))
				If CT1->CT1_NORMAL = "1"
					If lSoLinha
						If cOperacao == "1" .And. ((TMP->CV1_VALOR <> 0 .And. lAltValor) .Or. lInclui .Or. lAltEntid) //Se alterou o valor, considera o valor do arquivo temporario
							If TMP->CV1_VALOR < 0
								nCredito := Abs(TMP->CV1_VALOR) * nFatorCTH
							Else
								nDebito  := TMP->CV1_VALOR * nFatorCTH
							Endif
						Else
							If CV1->CV1_VALOR < 0
								nCredito := Abs(CV1->CV1_VALOR) * nFatorCTHA
							Else
								nDebito  := CV1->CV1_VALOR * nFatorCTHA
							Endif
						EndIf
					Else
						If CV1->CV1_VALOR < 0
							nCredito := Abs(CV1->CV1_VALOR) * nFatorCTH
						Else
							nDebito  := CV1->CV1_VALOR * nFatorCTH
						Endif
					EndIf
				Else
					If lSoLinha
						//						If cOperacao == "1" .Or. (TMP->CV1_VALOR <> 0 .And. lAltValor)  //Se alterou o valor, considera o valor do arquivo temporario
						If cOperacao == "1" .And. ((TMP->CV1_VALOR <> 0 .And. lAltValor)  .Or. lInclui .Or. lAltEntid) //Se alterou o valor, considera o valor do arquivo temporario
							If TMP->CV1_VALOR < 0
								nDebito  := Abs(TMP->CV1_VALOR) * nFatorCTH
							Else
								nCredito := TMP->CV1_VALOR * nFatorCTH
							Endif
						Else
							If CV1->CV1_VALOR < 0
								nDebito  := Abs(CV1->CV1_VALOR) * nFatorCTHA
							Else
								nCredito := CV1->CV1_VALOR * nFatorCTHA
							Endif
						EndIf
					Else
						If CV1->CV1_VALOR < 0
							nDebito  := Abs(CV1->CV1_VALOR) * nFatorCTH
						Else
							nCredito := CV1->CV1_VALOR * nFatorCTH
						Endif
					Endif
				Endif
				/*
				If lSoLinha .And. (TMP->CV1_VALOR <> CV1->CV1_VALOR)
				If nDebito <> 0
				nDebito := Abs((Abs(TMP->CV1_VALOR) * nEntida * nFatorCTH) - (Abs(CV1->CV1_VALOR) * nEntida2 * nFatorCTHA))
				Endif
				If nCredito <> 0
				nCredito := Abs((Abs(TMP->CV1_VALOR) * nEntida * nFatorCTH) - (Abs(CV1->CV1_VALOR) * nEntida2 * nFatorCTHA))
				Endif
				EndIf
				*/
				If cOperacao == "1"
					CT4_DEBITO += nDebito
					CT4_CREDIT += nCredito
				ElseIf cOperacao == "2"
					CT4_DEBITO -= nDebito
					CT4_CREDIT -= nCredito
				EndIf
				CT4_ATUDEB := CT4_ANTDEB + CT4_DEBITO
				CT4_ATUCRD := CT4_ANTCRD + CT4_CREDIT
				
				If 	CT4_DEBITO = 0 .AND. CT4_CREDIT = 0
					DbDelete()
				Endif
				
				nAtuDeb := CT4_ATUDEB
				nAtuCrd := CT4_ATUCRD
				
				MsUnLock()
				
				If lInclui
					aSldAnt 	:= SldAntCT4(aCt1[nLoop],aCtt[nLoop2],CTD->CTD_ITEM,;
					(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,"0",,.T.)
					nAntDeb		:= aSldAnt[1]
					nAntCrd		:= aSldAnt[2]
					RecLock("CT4", .F.)
					CT4_ANTDEB	:= nAntDeb
					CT4_ANTCRD	:= nAntCrd
					CT4_ATUDEB 	:= CT4_ANTDEB + CT4_DEBITO
					CT4_ATUCRD 	:= CT4_ANTCRD + CT4_CREDIT
					
					If 	CT4_DEBITO = 0 .AND. CT4_CREDIT = 0
						DbDelete()
					Endif
					MsUnLock()
					
					nAtuDeb := CT4_ATUDEB
					nAtuCrd := CT4_ATUCRD
				Endif
				
				DbSkip()
				
				While 	! Eof() .And. CT4_FILIAL = xFilial("CT4") .And.;
					CT4_CONTA = aCt1[nLoop] .And. CT4_CUSTO = aCtt[nLoop2] .And.;
					CT4_ITEM = CTD->CTD_ITEM .And.;
					CT4_MOEDA = (cAlias)->CV1_MOEDA .And. CT4_TPSALD = "0"
					RecLock("CT4", .F.)
					CT4_SLBASE 	:= "S"
					CT4_SLCOMP	:= "N"
					CT4_ANTDEB 	:= nAtuDeb
					CT4_ANTCRD 	:= nAtuCrd
					CT4_ATUDEB := CT4_ANTDEB + CT4_DEBITO
					CT4_ATUCRD := CT4_ANTCRD + CT4_CREDIT
					
					nAtuDeb := CT4_ATUDEB
					nAtuCrd := CT4_ATUCRD
					
					If 	CT4_DEBITO = 0 .AND. CT4_CREDIT = 0
						DbDelete()
					Endif
					MsUnLock()
					DbSkip()
				EndDo
			Next
		Next
		DbSelectArea("CTD")
		DbSkip()
	EndDo
	
	lAtualizou := .T.
Endif

If lSolinha .And. lAltEntid
	If cOperacao == "2"
		bCondCTT	:= { ||! Empty(CV1->CV1_CTTINI) .And. ! Empty(CV1->CV1_CTTFIM)}
		cAlias		:= "CV1"
	Else
		bCondCTT	:= { ||! Empty(TMP->CV1_CTTINI) .And. ! Empty(TMP->CV1_CTTFIM)}
		cAlias		:= "TMP"
	EndIf
Else
	bCondCTT	:= { ||! Empty(CV1->CV1_CTTINI) .And. ! Empty(CV1->CV1_CTTFIM)}
	cAlias		:= "CV1"
EndIf

If Eval(bCondCTT)
	CT1->(DbSetOrder(1))
	
	CTT->(MsSeek(xFilial() + (cAlias)->CV1_CTTINI))
	While 	CTT->CTT_FILIAL = xFilial("CTT") .And.;
		CTT->CTT_CUSTO <= (cAlias)->CV1_CTTFIM .And. ! CTT->(Eof())
		DbSelectArea("CT3")
		DbSetOrder(2)
		For nLoop := 1 To Len(aCt1)
			If lSoLinha
				nEntida  := Ct390CtEnt(, "CT3")
				nEntida2 := Ct390CtEnt("CV1", "CT3")
			Else
				nEntida  := Ct390CtEnt("CV1", "CT3")
			Endif
			
			CT1->(MsSeek(xFilial() + aCt1[nLoop]))
			
			MsSeek(	xFilial() + aCt1[nLoop] + CTT->CTT_CUSTO + (cAlias)->CV1_MOEDA +;
			"0" + Dtos((cAlias)->CV1_DTFIM), .T.)
			lInclui := .F.
			If 	! (	CT3_FILIAL = xFilial("CT3") .And. CT3_CONTA = aCt1[nLoop] .And.;
				CT3_CUSTO = CTT->CTT_CUSTO .And. CT3_MOEDA = (cAlias)->CV1_MOEDA .And.;
				CT3_TPSALD = "0" .And. CT3_DATA = (cAlias)->CV1_DTFIM)
				
				RecLock("CT3", .T.)
				CT3_FILIAL 	:= xFilial()
				CT3_CUSTO	:= CTT->CTT_CUSTO
				CT3_CONTA	:= aCt1[nLoop]
				CT3_MOEDA	:= (cAlias)->CV1_MOEDA
				CT3_TPSALD 	:= "0"
				CT3_DATA	:= (cAlias)->CV1_DTFIM
				CT3_STATUS	:= "1"
				CT3_LP 		:= "N"
				lInclui 	:= .T.
			Else
				RecLock("CT3", .F.)
			Endif
			
			CT3_SLBASE 	:= "S"
			CT3_SLCOMP	:= "N"
			
			nDebito := nCredito := 0.00
			If CT1->CT1_NORMAL = "1"
				If lSoLinha
					//					If cOperacao == "1" .Or. (TMP->CV1_VALOR <> 0 .And. lAltValor) //Se alterou o valor, considera o valor do arquivo temporario
					If cOperacao == "1" .And. ((TMP->CV1_VALOR <> 0 .And. lAltValor)  .Or. lInclui .Or. lAltEntid)//Se alterou o valor, considera o valor do arquivo temporario
						If TMP->CV1_VALOR < 0
							nCredito := Abs(TMP->CV1_VALOR) * nFatorCTH * nFatorCTD
						Else
							nDebito  := TMP->CV1_VALOR * nFatorCTH * nFatorCTD
						Endif
					Else
						If CV1->CV1_VALOR < 0
							nCredito := Abs(CV1->CV1_VALOR) * nFatorCTHA * nFatorCTDA
						Else
							nDebito  := CV1->CV1_VALOR * nFatorCTHA * nFatorCTDA
						Endif
					EndIf
				Else
					If CV1->CV1_VALOR < 0
						nCredito := Abs(CV1->CV1_VALOR) * nFatorCTH * nFatorCTD
					Else
						nDebito  := CV1->CV1_VALOR * nFatorCTH * nFatorCTD
					Endif
				EndIf
			Else
				If lSoLinha
					//					If cOperacao == "1" .Or. (TMP->CV1_VALOR <> 0 .And. lAltValor) //Se alterou o valor, considera o valor do arquivo temporario
					If cOperacao == "1" .And. ((TMP->CV1_VALOR <> 0 .And. lAltValor) .Or. lInclui .Or. lAltEntid) //Se alterou o valor, considera o valor do arquivo temporario
						If TMP->CV1_VALOR < 0
							nDebito  := Abs(TMP->CV1_VALOR) * nFatorCTH * nFatorCTD
						Else
							nCredito := TMP->CV1_VALOR * nFatorCTH * nFatorCTD
						Endif
					Else
						If CV1->CV1_VALOR < 0
							nDebito  := Abs(CV1->CV1_VALOR) * nFatorCTHA* nFatorCTDA
						Else
							nCredito := CV1->CV1_VALOR * nFatorCTHA * nFatorCTDA
						Endif
					EndIf
				Else
					If CV1->CV1_VALOR < 0
						nDebito  := Abs(CV1->CV1_VALOR) * nFatorCTH* nFatorCTD
					Else
						nCredito := CV1->CV1_VALOR * nFatorCTH * nFatorCTD
					Endif
				EndIf
			Endif
			/*
			If lSoLinha .And. (TMP->CV1_VALOR <> CV1->CV1_VALOR)
			If nDebito <> 0
			nDebito := Abs((Abs(TMP->CV1_VALOR) * nEntida * nFatorCTH * nFatorCTD) - (Abs(CV1->CV1_VALOR) * nEntida2 * nFatorCTHA * nFatorCTDA))
			Endif
			If nCredito <> 0
			nCredito := Abs((Abs(TMP->CV1_VALOR) * nEntida * nFatorCTH * nFatorCTD) - (Abs(CV1->CV1_VALOR) * nEntida2 * nFatorCTHA * nFatorCTDA))
			Endif
			*/
			/*
			Else
			If nDebito > 0
			nDebito	*= nEntida
			Endif
			If nCredito > 0
			nCredito *= nEntida
			Endif
			
			Endif
			*/
			If cOperacao == "1"
				CT3_DEBITO += nDebito
				CT3_CREDIT += nCredito
			ElseIf cOperacao == "2"
				CT3_DEBITO -= nDebito
				CT3_CREDIT -= nCredito
			EndIf
			CT3_ATUDEB := CT3_ANTDEB + CT3_DEBITO
			CT3_ATUCRD := CT3_ANTCRD + CT3_CREDIT
			
			If 	CT3_DEBITO = 0 .AND. CT3_CREDIT = 0
				DbDelete()
			Endif
			
			nAtuDeb := CT3_ATUDEB
			nAtuCrd := CT3_ATUCRD
			
			MsUnLock()
			
			If lInclui
				aSldAnt 	:= SldAntCT3(aCt1[nLoop],CTT->CTT_CUSTO,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,"0",,.T.)
				nAntDeb		:= aSldAnt[1]
				nAntCrd		:= aSldAnt[2]
				RecLock("CT3", .F.)
				CT3_ANTDEB	:= nAntDeb
				CT3_ANTCRD	:= nAntCrd
				CT3_ATUDEB 	:= CT3_ANTDEB + CT3_DEBITO
				CT3_ATUCRD 	:= CT3_ANTCRD + CT3_CREDIT
				
				If 	CT3_DEBITO = 0 .AND. CT3_CREDIT = 0
					DbDelete()
				Endif
				MsUnLock()
				
				nAtuDeb := CT3_ATUDEB
				nAtuCrd := CT3_ATUCRD
			Endif
			
			DbSkip()
			
			While 	! Eof() .And. CT3_FILIAL = xFilial("CT3") .And.;
				CT3_CONTA = aCt1[nLoop] .And. CT3_CUSTO = CTT->CTT_CUSTO .And.;
				CT3_MOEDA = (cAlias)->CV1_MOEDA .And. CT3_TPSALD = "0"
				RecLock("CT3", .F.)
				CT3_SLBASE 	:= "S"
				CT3_SLCOMP	:= "N"
				CT3_ANTDEB 	:= nAtuDeb
				CT3_ANTCRD 	:= nAtuCrd
				CT3_ATUDEB := CT3_ANTDEB + CT3_DEBITO
				CT3_ATUCRD := CT3_ANTCRD + CT3_CREDIT
				
				nAtuDeb := CT3_ATUDEB
				nAtuCrd := CT3_ATUCRD
				
				If 	CT3_DEBITO = 0 .AND. CT3_CREDIT = 0
					DbDelete()
				Endif
				MsUnLock()
				DbSkip()
			EndDo
		Next
		DbSelectArea("CTT")
		DbSkip()
	EndDo
	
	lAtualizou := .T.
Endif

If lSolinha .And. lAltEntid
	If cOperacao == "2"
		bCondCT1	:= { ||! Empty(CV1->CV1_CT1INI) .And. ! Empty(CV1->CV1_CT1FIM)}
		cAlias		:= "CV1"
	Else
		bCondCT1	:= { ||! Empty(TMP->CV1_CT1INI) .And. ! Empty(TMP->CV1_CT1FIM)}
		cAlias		:= "TMP"
	EndIf
Else
	bCondCT1	:= { ||! Empty(CV1->CV1_CT1INI) .And. ! Empty(CV1->CV1_CT1FIM)}
	cAlias		:= "CV1"
EndIf

If Eval(bCondCT1)
	CT1->(DbSetOrder(3))
	CT1->(DbSeek(xFilial() + "2" + (cAlias)->CV1_CT1INI, .T.))
	While 	CT1->CT1_CONTA <= (cAlias)->CV1_CT1FIM .And.;
		CT1->CT1_FILIAL = xFilial("CT1") .And. ! CT1->(Eof())
		
		DbSelectArea("CT7")
		DbSetOrder(2)
		MsSeek(xFilial() + CT1->CT1_CONTA + (cAlias)->CV1_MOEDA + "0" + Dtos((cAlias)->CV1_DTFIM), .T.)
		lInclui := .F.
		If lSoLinha
			nEntida  := Ct390CtEnt(, "CT7")
			nEntida2 := Ct390CtEnt("CV1", "CT7")
		Else
			nEntida  := Ct390CtEnt("CV1", "CT7")
		Endif
		
		If 	! (	CT7_FILIAL = xFilial("CT7") .And. CT7_CONTA = CT1->CT1_CONTA .And.;
			CT7_MOEDA =(cAlias)->CV1_MOEDA .And. CT7_TPSALD = "0" .And.;
			CT7_DATA = (cAlias)->CV1_DTFIM)
			
			RecLock("CT7", .T.)
			CT7_FILIAL 	:= xFilial()
			CT7_CONTA	:= CT1->CT1_CONTA
			CT7_MOEDA	:= (cAlias)->CV1_MOEDA
			CT7_TPSALD 	:= "0"
			CT7_DATA	:= (cAlias)->CV1_DTFIM
			CT7_STATUS	:= "1"
			CT7_LP 		:= "N"
			lInclui 	:= .T.
		Else
			RecLock("CT7", .F.)
		Endif
		
		CT7_SLBASE	:= "S"
		nDebito 	:= nCredito := 0.00
		If CT1->CT1_NORMAL = "1"
			If lSoLinha		//Se for gravacao de saldos on-line
				//				If cOperacao == "1" .Or. (TMP->CV1_VALOR <> 0 .And. lAltValor) //Se alterou o valor, considera o valor do arquivo temporario
				If cOperacao == "1" .And. ((TMP->CV1_VALOR <> 0 .And. lAltValor) .Or. lInclui .Or. lAltEntid) //Se alterou o valor, considera o valor do arquivo temporario
					If TMP->CV1_VALOR < 0
						nCredito := Abs(TMP->CV1_VALOR) * nFatorCTH * nFatorCTD * nFatorCTT
					Else
						nDebito  := TMP->CV1_VALOR * nFatorCTH * nFatorCTD * nFatorCTT
					Endif
				Else
					If CV1->CV1_VALOR < 0
						nCredito := Abs(CV1->CV1_VALOR) * nFatorCTHA * nFatorCTDA * nFatorCTTA
					Else
						nDebito  := CV1->CV1_VALOR * nFatorCTHA * nFatorCTDA * nFatorCTTA
					Endif
				EndIf
			Else	//Se nao for gravacao de saldos on line
				If CV1->CV1_VALOR < 0
					nCredito := Abs(CV1->CV1_VALOR) * nFatorCTH * nFatorCTD * nFatorCTT
				Else
					nDebito  := CV1->CV1_VALOR * nFatorCTH * nFatorCTD * nFatorCTT
				Endif
			EndIf
		Else
			If lSoLinha	//Se for gravao de saldos on-line
				//				If cOperacao == "1" .Or. (lAltValor .And. TMP->CV1_VALOR <> 0)
				If cOperacao == "1" .And. ((lAltValor .And. TMP->CV1_VALOR <> 0) .Or. lInclui .Or. lAltEntid)
					If TMP->CV1_VALOR < 0
						nDebito  := Abs(TMP->CV1_VALOR) * nFatorCTH * nFatorCTD * nFatorCTT
					Else
						nCredito := TMP->CV1_VALOR * nFatorCTH * nFatorCTD * nFatorCTT
					Endif
				Else
					If CV1->CV1_VALOR < 0
						nDebito  := Abs(CV1->CV1_VALOR) * nFatorCTHA * nFatorCTDA * nFatorCTTA
					Else
						nCredito := CV1->CV1_VALOR * nFatorCTHA * nFatorCTDA * nFatorCTTA
					Endif
				EndIf
			Else
				If CV1->CV1_VALOR < 0
					nDebito  := Abs(CV1->CV1_VALOR) * nFatorCTH * nFatorCTD * nFatorCTT
				Else
					nCredito := CV1->CV1_VALOR * nFatorCTH * nFatorCTD * nFatorCTT
				Endif
			EndIf
		Endif
		/*
		If lSoLinha .And. (TMP->CV1_VALOR <> CV1->CV1_VALOR)
		If nDebito <> 0
		nDebito := Abs((Abs(TMP->CV1_VALOR) * nEntida * nFatorCTH * nFatorCTD * nFatorCTT) - (Abs(CV1->CV1_VALOR) * nEntida2 * nFatorCTHA * nFatorCTDA * nFatorCTTA))
		Endif
		If nCredito <> 0
		nCredito := Abs((Abs(TMP->CV1_VALOR) * nEntida * nFatorCTH * nFatorCTD * nFatorCTT) - (Abs(CV1->CV1_VALOR) * nEntida2 * nFatorCTHA * nFatorCTDA * nFatorCTTA))
		Endif
		EndIf
		*/
		/*		Else
		If nDebito > 0
		nDebito	*= nEntida
		Endif
		If nCredito > 0
		nCredito *= nEntida
		Endif
		Endif
		*/
		If cOperacao == "1"
			CT7_DEBITO += nDebito
			CT7_CREDIT += nCredito
		ElseIf cOperacao == "2"
			CT7_DEBITO -= nDebito
			CT7_CREDIT -= nCredito
		EndIf
		CT7_ATUDEB := CT7_ANTDEB + CT7_DEBITO
		CT7_ATUCRD := CT7_ANTCRD + CT7_CREDIT
		
		If 	CT7_DEBITO = 0 .AND. CT7_CREDIT = 0
			DbDelete()
		Endif
		
		nAtuDeb := CT7_ATUDEB
		nAtuCrd := CT7_ATUCRD
		
		MsUnLock()
		
		If lInclui
			aSldAnt 	:= SldAntCT7(CT1->CT1_CONTA,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,"0",,.T.)
			nAntDeb		:= aSldAnt[1]
			nAntCrd		:= aSldAnt[2]
			RecLock("CT7", .F.)
			CT7_ANTDEB	:= nAntDeb
			CT7_ANTCRD	:= nAntCrd
			CT7_ATUDEB 	:= CT7_ANTDEB + CT7_DEBITO
			CT7_ATUCRD 	:= CT7_ANTCRD + CT7_CREDIT
			
			If 	CT7_DEBITO = 0 .AND. CT7_CREDIT = 0
				DbDelete()
			Endif
			MsUnLock()
			
			nAtuDeb := CT7_ATUDEB
			nAtuCrd := CT7_ATUCRD
		Endif
		
		DbSkip()
		
		While 	! Eof() .And. CT7_FILIAL = xFilial("CT7") .And.;
			CT7_CONTA = CT1->CT1_CONTA .And. CT7_MOEDA = (cAlias)->CV1_MOEDA .And.;
			CT7_TPSALD = "0"
			RecLock("CT7", .F.)
			CT7_ANTDEB := nAtuDeb
			CT7_ANTCRD := nAtuCrd
			CT7_SLBASE := "S"
			CT7_ATUDEB := CT7_ANTDEB + CT7_DEBITO
			CT7_ATUCRD := CT7_ANTCRD + CT7_CREDIT
			
			nAtuDeb := CT7_ATUDEB
			nAtuCrd := CT7_ATUCRD
			
			If 	CT7_DEBITO = 0 .AND. CT7_CREDIT = 0
				DbDelete()
			Endif
			MsUnLock()
			DbSkip()
		EndDo
		DbSelectArea("CT1")
		DbSkip()
	EndDo
	
	lAtualizou := .T.
	
Endif

If lChkOrc .And. lAtualizou
	DbSelectArea("CV1")
	
	RecLock("CV1", .F.)
	CV1_STATUS	:= "2"		// Gerado Saldo
	MsUnLock()
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB390Rep ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 11/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de reprocessamento dos saldos orcamentarios         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Rep()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Reprocessar os saldos gerados (Especifico   pois  deve   se³±±
±±³          ³ basear no CV1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilDe   = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ cFilAte  = Filial final para reprocessar (CTBA190)     	  ³±±
±±³          ³ dDataIni = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ dDataIni = Filial final para reprocessar (CTBA190)     	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB390Rep(oObj,cFilDe,cFilAte,dDataIni,dDataFim,lMoedaEsp,cMoeda)

Local lFim := .F.

While !lFim			
	lFim := xCTB390Rep(oObj,cFilDe,cFilAte,dDataIni,dDataFim,lMoedaEsp,cMoeda)
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

Static Function xCTB390Rep(oObj,cFilDe,cFilAte,dDataIni,dDataFim,lMoedaEsp,cMoeda)

Local aArea     := GetArea()
Local aCtbMoeda := {}
Local nInicio	:= 0
Local nFinal	:= 0
Local nItem     := 0
Local nTotal    := 0
Local cFilBck   := cFilAnt
Local cFirst    := ""
Local cCursor   := "CV1"
Local lQuery    := .F.
Local lCusto	:= CtbMovSaldo("CTT")
Local lItem		:= CtbMovSaldo("CTD")
Local lCLVL		:= CtbMovSaldo("CTH")
Local bWhile    := {|| !Eof() }
Local lX3Aprova  := .F.
Local cDELETE	:= " AND D_E_L_E_T_ = ' ' "

Local lRet := .t.
Local lAtSldBase	:= Iif(SuperGetMV("MV_ATUSAL")== "S",.T.,.F.) 


#IFDEF TOP
	Local aField   := {}
	Local cOrderBy	:= ""	
	Local cQuery   := ""
	Local cWhere   := ""
	Local cChave	:= ""
	Local nCountReg:= 0	
	Local nMin		:= 0
	Local nMax		:= 0
#ENDIF	
Local nX			:= 0	

If GetMV("MV_ORCAPRV") == "S"
	lX3Aprova := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Regua                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMoedaEsp					// Moeda especifica
	aCtbMoeda := CtbMoeda(cMoeda)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		Return
	EndIf
	nInicio := Val(cMoeda)
	nFinal	:= Val(cMoeda)
Else
	nInicio	:= 1
	nFinal	:= __nQuantas
EndIf

If !lAtSldBase
	For nx := nInicio to nFinal
		If GetCV7Date("0",StrZero(nx,2,0)) < dDataIni 
			dDataIni := GetCV7Date("0",StrZero(nx,2,0))+1
		EndIf
		PutCV7Date("0",StrZero(nx,2,0),dDataFim)
	Next nx
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as filiais que devem ser processadas                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbSetOrder(1)
If Empty(cFilDe)
	MsSeek(cEmpAnt)
Else
	MsSeek(cEmpAnt+cFilDe)
EndIf
cFirst := SM0->M0_CODFIL
While !Eof() .And. cEmpAnt == SM0->M0_CODIGO .and. SM0->M0_CODFIL <= cFilAte
	
	If Empty(xFilial("CV1")) .And. SM0->M0_CODFIL <> cFirst
		dbSkip()
		Loop
	Endif
	
	nRecSM0 := SM0->(Recno())
	
	If oObj <> Nil
		oObj:SetRegua1(MAXPASSO)
		oObj:IncRegua1(STR0035+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)//"Rep. de Orcamentos"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Altera a Filial do Sistema                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilAnt := SM0->M0_CODFIL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Zerar os dados a ser atualizado                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (!Empty(xFilial("CT3")) .Or. cFilAnt == cFirst )
		CtbZeraOrc("CT3",lMoedaEsp,cMoeda,dDataIni,dDataFim,oObj)
	EndIf
	If (!Empty(xFilial("CT4")) .Or. cFilAnt == cFirst )
		CtbZeraOrc("CT4",lMoedaEsp,cMoeda,dDataIni,dDataFim,oObj)
	EndIf
	If (!Empty(xFilial("CT7")) .Or. cFilAnt == cFirst )
		CtbZeraOrc("CT7",lMoedaEsp,cMoeda,dDataIni,dDataFim,oObj)
	EndIf
	If (!Empty(xFilial("CTI")) .Or. cFilAnt == cFirst )
		CtbZeraOrc("CTI",lMoedaEsp,cMoeda,dDataIni,dDataFim,oObj)
	EndIf
	If oObj <> Nil
		oObj:IncRegua1(STR0035+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)//"Rep. de Orcamentos"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizar os saldos de orcamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		If TcSrvType() != "AS/400" 		
			cCursor := "cCursor"
			lQuery  := .T.
		
			cQuery := "SELECT Count(*) MAXREG "
			cQuery += "FROM "+RetSqlName("CV1")+" CV1 "
			cQuery += "WHERE CV1.CV1_FILIAL = '"+xFilial("CV1")+"' AND "
			cQuery += "CV1.CV1_DTFIM BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
			cQuery += "CV1.CV1_STATUS = '2'  AND "
			cQuery += "CV1.CV1_VALOR <> 0  AND "
			If lMoedaEsp
				cQuery	+= 	"CV1.CV1_MOEDA ='"+cMoeda+"' AND "
			EndIf
			If lX3Aprova
				cQuery	+= 	"CV1.CV1_APROVA <> '' AND "
			Endif
			cQuery += "CV1.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			
			If ( Select ( "cCursor" ) <> 0 )
				dbSelectArea ( "cCursor" )
				dbCloseArea ()
			Endif							
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor)
			
			nTotal := (cCursor)->MAXREG
			If oObj<>Nil
				oObj:SetRegua2(nTotal)
			EndIf
			
			dbSelectArea(cCursor)

			cQuery := "SELECT CV1_CT1INI, CV1_CT1FIM, CV1_CTTINI, CV1_CTTFIM, CV1_CTDINI, CV1_CTDFIM,"
			cQuery += "CV1_CTHINI, CV1_CTHFIM,  CV1_MOEDA, CV1_DTFIM, CV1_VALOR, CV1_STATUS "
			cQuery += "FROM "+RetSqlName("CV1")+" CV1 "
			cQuery += "WHERE CV1.CV1_FILIAL = '"+xFilial("CV1")+"' AND "
			cQuery += "CV1.CV1_DTFIM BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
			cQuery += "CV1.CV1_STATUS = '2'  AND "
			If lX3Aprova
				cQuery	+= 	"CV1.CV1_APROVA <> '' AND "
			Endif
			cQuery += "CV1.CV1_VALOR <> 0  AND "
			If lMoedaEsp
				cQuery	+= 	"CV1.CV1_MOEDA ='"+cMoeda+"' AND "
			EndIf
		
			cQuery += "CV1.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY CV1_CTHINI, CV1_CTDINI, CV1_CTTINI, CV1_CT1INI, CV1_MOEDA, CV1_DTFIM"
			cQuery := ChangeQuery(cQuery)

			If ( Select ( "cCursor" ) <> 0 )
				dbSelectArea ( "cCursor" )
				dbCloseArea ()
			Endif							
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor)
		
			aField := CV1->(dbStruct())
		
			For nX := 1 to Len(aField)
				If aField[nX,2] <> "C" .And. (cCursor)->(FieldPos(aField[nX,1]))<>0
					TcSetField(cCursor,aField[nX,1],aField[nX,2],aField[nX,3],aField[nX,4])
				EndIf
			Next nX
		Else
	#ENDIF
		dbSelectArea("CV1")
		dbSetOrder(2)
		MsSeek(xFilial("CV1")+Dtos(dDataIni),.T.)
		bWhile    := {|| !Eof() .And. (cCursor)->CV1_DTFIM <= dDataFim }
		nTotal := LastRec()
		If oObj<>Nil
			oObj:SetRegua2(nTotal)
		EndIf
	#IFDEF TOP		
		EndIf
	#ENDIF
	If oObj <> Nil
		oObj:IncRegua1(STR0035+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)//"Rep. de Orcamentos"
	EndIf
	nItem := 0
	
	#IFDEF TOP
		If TcSrvType() != "AS/400" 	
			dbSelectArea(cCursor)
			While Eval(bWhile)
			
				If (cCursor)->CV1_STATUS=='2' .And. (cCursor)->CV1_VALOR<>0
					Ctb390Atu(cCursor,"1")
				EndIf
				dbSelectArea(cCursor)
				dbSkip()
				nItem++
			
				If oObj <> Nil
					oObj:IncRegua2(STR0031+"("+AllTrim(Str(nItem,0))+"/"+AllTrim(Str(nTotal,0))+")") //"Atualizando saldos..."
				EndIf
			EndDo
		Else
	#ENDIF
		Ctb390Sal(.F., .T., cFilAnt, cFilAnt, dDataIni, dDataFim)
	#IFDEF TOP
		EndIf
	#ENDIF
	If lQuery
		dbSelectArea (cCursor)
		dbCloseArea()
		dbSelectArea("CV1")
	EndIf
	If oObj <> Nil
		oObj:IncRegua1(STR0035+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)//"Rep. de Orcamentos"
	EndIf
	#IFDEF TOP
		If TcSrvType() != "AS/400" 	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apaga os registros de saldos que nao possuem saldo           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (!Empty(xFilial("CT3")) .Or. cFilAnt == cFirst )
				cCursor:= "cCursor"
				
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CT3")+" "
				
				cWhere := "WHERE CT3_FILIAL = '"+xFilial("CT3")+"' AND "
				cWhere += "CT3_DEBITO = 0 AND "
				cWhere += "CT3_CREDIT = 0 AND "
				If lMoedaEsp
					cWhere +="CT3_MOEDA ='"+cMoeda+"' AND "
				EndIf
				cWhere 	+= "CT3_TPSALD  = '0' "
				cDELETE	:= " AND D_E_L_E_T_ = ' ' "
				cOrderBy:= " ORDER BY RECNO "	
			
				cQuery := ChangeQuery(cQuery+cWhere+cDELETE+cOrderBy)
				
				If ( Select ( "cCursor" ) <> 0 )
					dbSelectArea ( "cCursor" )
					dbCloseArea ()
				Endif							
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor)
				
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
			
				dbSelectArea("CT3")
				
				cQuery := "DELETE FROM "
				cQuery += RetSqlName("CT3")+" "
				cQuery += cWhere
				                                                    
				While cCursor->(!Eof())
	
					nMin := (cCursor)->RECNO
			
					nCountReg := 0
				
					While cCursor->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (cCursor)->RECNO
						nCountReg++
						cCursor->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0036)//"Eliminando residuos..."
					EndIf
		
				End
			EndIf  
			
			If (!Empty(xFilial("CT4")) .Or. cFilAnt == cFirst )
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CT4")+" "
				cWhere := "WHERE CT4_FILIAL = '"+xFilial("CT4")+"' AND "
				cWhere += "CT4_DEBITO = 0 AND "
				cWhere += "CT4_CREDIT = 0 AND "
				If lMoedaEsp
					cWhere +="CT4_MOEDA ='"+cMoeda+"' AND "
				EndIf
				cWhere += "CT4_TPSALD = '0' "
				cDELETE	:= " AND D_E_L_E_T_ = ' ' "
				cOrderBy := " ORDER BY RECNO "
			
				cQuery := ChangeQuery(cQuery+cWhere+cDELETE+cOrderBy)
				
				If ( Select ( "cCursor" ) <> 0 )
					dbSelectArea ( "cCursor" )
					dbCloseArea ()
				Endif							
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor)
			
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
				
				dbSelectArea("CT4")
				
				cQuery := "DELETE FROM "
				cQuery += RetSqlName("CT4")+" "
				cQuery += cWhere
				
				While cCursor->(!Eof())
	
					nMin := (cCursor)->RECNO
			
					nCountReg := 0
				
					While cCursor->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (cCursor)->RECNO
						nCountReg++
						cCursor->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0036)//"Eliminando residuos..."
					EndIf
			
				End			
				
			EndIf
			If (!Empty(xFilial("CT7")) .Or. cFilAnt == cFirst )
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CT7")+" "
				cWhere := "WHERE CT7_FILIAL = '"+xFilial("CT7")+"' AND "
				cWhere += "CT7_DEBITO = 0 AND "
				cWhere += "CT7_CREDIT = 0 AND "
				If lMoedaEsp
					cWhere +="CT7_MOEDA ='"+cMoeda+"' AND "
				EndIf
				cWhere		+= "CT7_TPSALD = '0' "
				cDELETE		:= " AND D_E_L_E_T_ = ' ' "
				cOrderBy	:= " ORDER BY RECNO "
				
				cQuery := ChangeQuery(cQuery+cWhere+cDELETE+cOrderBy)
				
				If ( Select ( "cCursor" ) <> 0 )
					dbSelectArea ( "cCursor" )
					dbCloseArea ()
				Endif							
			
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor)
				
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
			
				dbSelectArea("CT7")
			
				cQuery := "DELETE FROM "
				cQuery += RetSqlName("CT7")+" "
				cQuery += cWhere
				
				While cCursor->(!Eof())
	
					nMin := (cCursor)->RECNO
			
					nCountReg := 0
				
					While cCursor->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (cCursor)->RECNO
						nCountReg++
						cCursor->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0036)//"Eliminando residuos..."
					EndIf
			
				End
				
			EndIf
			If (!Empty(xFilial("CTI")) .Or. cFilAnt == cFirst )
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CTI")+ " "
				cWhere := "WHERE CTI_FILIAL = '"+xFilial("CTI")+"' AND "
				cWhere += "CTI_DEBITO = 0 AND "
				cWhere += "CTI_CREDIT = 0 AND "
				If lMoedaEsp
					cWhere +="CTI_MOEDA ='"+cMoeda+"' AND "
				EndIf
				cWhere += "CTI_TPSALD = '0' "
				cDELETE		:= " AND D_E_L_E_T_ = ' ' "
				cOrderBy := " ORDER BY RECNO "
				
				cQuery := ChangeQuery(cQuery+cWhere+cDELETE+cOrderBy)
				
				If ( Select ( "cCursor" ) <> 0 )
					dbSelectArea ( "cCursor" )
					dbCloseArea ()
				Endif							
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor)
					
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
			
				dbSelectArea("CTI")
				
				cQuery := "DELETE FROM "
				cQuery += RetSqlName("CTI")+" "
				cQuery += cWhere               
				
				While cCursor->(!Eof())
	
					nMin := (cCursor)->RECNO
			
					nCountReg := 0
				
					While cCursor->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (cCursor)->RECNO
						nCountReg++
						cCursor->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0036)//"Eliminando residuos..."
					EndIf
			
				End
								
			EndIf
		EndIf
	#ENDIF
	If oObj <> Nil
		oObj:IncRegua1(STR0035+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)//"Rep. de Orcamentos"
	EndIf
	If oObj <> Nil
		oObj:SetRegua2(2)
	EndIf
	If oObj <> Nil
		oObj:IncRegua2(STR0031)//Atualizando Saldos
	EndIf
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			//Se o arquivo CV1 for compartilhado
			If Empty(xFilial("CV1"))
				cFilDe	:= xFilial("CV1")
				cFilAte	:= xFilial("CV1")
			EndIf
			
			//Rotina que chama a atualizacao de Saldos Basicos
			//Rotina que chama a atualizacao de Saldos Compostos
			//			Ct360SlCmp(1,__nQuantas,lClvl,lItem,lCusto,"0",.F.,cFilAnt,cFilAnt,,,cFilAnt)
			Ct360SlCmp(1,__nQuantas,lClvl,lItem,lCusto,"0",.F.,cFilde,cFilAte,,,cFilAnt)
		Else
	#ENDIF
	//Rotina que chama a atualizacao de Saldos Compostos
	//		Ct360SlCmp(1,__nQuantas,lClvl,lItem,lCusto,"0",.F.,cFilAnt,cFilAnt,,,cFilAnt)
	Ct360SlCmp(1,__nQuantas,lClvl,lItem,lCusto,"0",.F.,cFilDe,cFilAte,,,cFilAnt)
	#IFDEF TOP
		EndIf
	#ENDIF
	If oObj <> Nil
		oObj:IncRegua2(STR0031)//"Atualizando Saldos
	EndIf
	
	If oObj <> Nil
		oObj:IncRegua1(STR0035+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)//"Rep. de Orcamentos"
	EndIf
	
	dbSelectArea("SM0")
	SM0->(dbGoTo(nRecSM0))
	dbSkip()
Enddo
cFilAnt := cFilBck

If !lAtSldBase
   lRet := .T.
	For nx := nInicio to nFinal
		If GetCV7Date("0",StrZero(nx,2,0)) < dDataFim
			lRet := .f.
		EndIf
	Next nx
EndIf	

RestArea(aArea)
	
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CtbZeraOrc³ Autor ³ Simone M. Sato        ³ Data ³15.04.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Zera os arquivos de saldo a serem reprocessadosessados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbZeraTod()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1= Alias do Arquivo                                    ³±±
±±³          ³ ExpL2= Define se eh moeda especifica                       ³±±
±±³          ³ ExpC3= Moeda                                               ³±±
±±³          ³ ExpD4= Data Inicial                                        ³±±
±±³          ³ ExpD5= Data Final                                          ³±±
±±³          ³ ExpO6= Objeto inicial                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbZeraOrc(cAlias,lMoedaEsp,cMoeda,dDataIni,dDataFim,oObj)

Local aSaveArea := GetArea()

#IFDEF TOP
	Local cOrderBy	:= ""
	Local cChave    := ""
	Local cWhere    := ""
	Local cQuery	:= ""
	Local CtbZeraOrc:= ""	
	Local nMax      := 0
	Local nMin      := 0
	Local nCountReg	:= 0                                   	
#ENDIF	

Do Case
	Case cAlias == "CT3"
		#IFDEF TOP
			If TcSrvType() != "AS/400" 		
				CtbZeraOrc := "CtbZeraOrc"
			
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CT3")+ " "
				cWhere := "WHERE CT3_FILIAL = '"+xFilial("CT3")+"' AND "
				If lMoedaEsp
					cWhere += "CT3_MOEDA = '"+cMoeda+"' AND "
				EndIf
				cWhere += "CT3_TPSALD='0' AND "
				cWhere += "CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
				cWhere += "D_E_L_E_T_=' ' "
				cQuery += cWhere
				
				cOrderBy	:= " ORDER BY RECNO "
				cQuery		+= cOrderBy
				
				cQuery := ChangeQuery(cQuery)
				
				If ( Select ( "CtbZeraOrc" ) <> 0 )
					dbSelectArea ( "CtbZeraOrc" )
					dbCloseArea ()
				Endif				
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),CtbZeraOrc)
				
				
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
				
				dbSelectArea("CT3")
				
				cQuery := "UPDATE "
				cQuery += RetSqlName("CT3")+" "
				cQuery += "SET CT3_DEBITO = 0,"
				cQuery += "CT3_CREDIT = 0,"
				cQuery += "CT3_ANTDEB = 0,"
				cQuery += "CT3_ANTCRD = 0,"
				cQuery += "CT3_ATUDEB = 0,"
				cQuery += "CT3_ATUCRD = 0 "
				cQuery += cWhere                   
				
				While CtbZeraOrc->(!Eof())
	
					nMin := (CtbZeraOrc)->RECNO
			
					nCountReg := 0
				
					While CtbZeraOrc->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (CtbZeraOrc)->RECNO
						nCountReg++
						CtbZeraOrc->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0037+" - "+"CT3")//"Eliminando Saldos"
					EndIf
		
				End
				
				dbSelectArea("CT3")
				MsGoto(0)
			Else
		#ENDIF
			If oObj<>Nil
				oObj:SetRegua2(CT3->(LastRec()))
			EndIf
			
			dbSelectArea("CT3")
			dbSetOrder(3)
			MsSeek(xFilial("CT3")+Dtos(dDataIni),.T.)
			While !Eof() .And. CT3->CT3_FILIAL == xFilial("CT3") .And.;
				CT3->CT3_DATA <= dDataFim
				
				If oObj<>Nil
					oObj:IncRegua2(STR0037+" - "+"CT3")//"Eliminando Saldos"
				EndIf
				
				If lMoedaEsp
					If CT3->CT3_MOEDA != cMoeda
						dbSelectArea("CT3")
						dbSkip()
						Loop
					EndIf
				EndIf
				If CT3->CT3_TPSALD == "0"
					RecLock("CT3")
					dbDelete()
					MsUnLock()
				EndIf
				
				dbSelectArea("CT3")
				dbSkip()
			EndDo
		#IFDEF TOP			
			EndIf
		#ENDIF
		
	Case cAlias == "CT4"
		#IFDEF TOP
			If TcSrvType() != "AS/400" 		
				CtbZeraOrc := "CtbZeraOrc"
			
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CT4")+ " "
				cWhere := "WHERE CT4_FILIAL = '"+xFilial("CT4")+"' AND "
				If lMoedaEsp
					cWhere += "CT4_MOEDA = '"+cMoeda+"' AND "
				EndIf
				cWhere += "CT4_TPSALD='0' AND "
				cWhere += "CT4_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
				cWhere += "D_E_L_E_T_=' ' "				
				cQuery += cWhere           
				
				cOrderBy := " ORDER BY RECNO "
				cQuery	 += cOrderBy
				
				cQuery := ChangeQuery(cQuery)

				If ( Select ( "CtbZeraOrc" ) <> 0 )
					dbSelectArea ( "CtbZeraOrc" )
					dbCloseArea ()
				Endif				
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),CtbZeraOrc)
				
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
				
				dbSelectArea("CT4")
				
				cQuery := "UPDATE "
				cQuery += RetSqlName("CT4")+" "
				cQuery += "SET CT4_DEBITO = 0,"
				cQuery += "CT4_CREDIT = 0,"
				cQuery += "CT4_ANTDEB = 0,"
				cQuery += "CT4_ANTCRD = 0,"
				cQuery += "CT4_ATUDEB = 0,"
				cQuery += "CT4_ATUCRD = 0 "
				cQuery += cWhere
				
				
				While CtbZeraOrc->(!Eof())
	
					nMin := (CtbZeraOrc)->RECNO
			
					nCountReg := 0
				
					While CtbZeraOrc->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (CtbZeraOrc)->RECNO
						nCountReg++
						CtbZeraOrc->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0037+" - "+"CT4")//"Eliminando Saldos"
					EndIf
		
				End
				
				dbSelectArea("CT4")
				MsGoto(0)
			Else
		#ENDIF
			If oObj<>Nil
				oObj:SetRegua2(CT4->(LastRec()))
			EndIf
			
			dbSelectArea("CT4")
			dbSetOrder(3)
			MsSeek(xFilial("CT4")+Dtos(dDataIni),.T.)
			While !Eof() .And. CT4->CT4_FILIAL == xFilial("CT4") .And.;
				CT4->CT4_DATA <= dDataFim
				
				If oObj<>Nil
					oObj:IncRegua2(STR0037+" - "+"CT4")//"Eliminando Saldos"
				EndIf
				
				If lMoedaEsp
					If CT4->CT4_MOEDA != cMoeda
						dbSelectArea("CT4")
						dbSkip()
						Loop
					EndIf
				EndIf
				If CT4->CT4_TPSALD == "0"
					RecLock("CT4")
					dbDelete()
					MsUnLock()
				EndIf
				dbSelectArea("CT4")
				dbSkip()
			EndDo
		#IFDEF TOP			
			Endif
		#ENDIF
	Case cAlias == "CT7"
		#IFDEF TOP
			If TcSrvType() != "AS/400" 		
				CtbZeraOrc := "CtbZeraOrc"
				
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CT7")+ " "
				cWhere := "WHERE CT7_FILIAL = '"+xFilial("CT7")+"' AND "
				If lMoedaEsp
					cWhere += "CT7_MOEDA = '"+cMoeda+"' AND "
				EndIf
				cWhere += "CT7_TPSALD='0' AND "
				cWhere += "CT7_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
				cWhere += "D_E_L_E_T_=' ' "
				cQuery += cWhere           
				
				cOrderBy	:= " ORDER BY RECNO "
				cQuery		+= cOrderBy				                                 
				
				cQuery := ChangeQuery(cQuery)      
				
				If ( Select ( "CtbZeraOrc" ) <> 0 )				
					dbSelectArea ( "CtbZeraOrc" )
					dbCloseArea ()
				Endif				
			
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),CtbZeraOrc)
				
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
			
				dbSelectArea("CT7")
				
				cQuery := "UPDATE "
				cQuery += RetSqlName("CT7")+" "
				cQuery += "SET CT7_DEBITO = 0,"
				cQuery += "CT7_CREDIT = 0,"
				cQuery += "CT7_ANTDEB = 0,"
				cQuery += "CT7_ANTCRD = 0,"
				cQuery += "CT7_ATUDEB = 0,"
				cQuery += "CT7_ATUCRD = 0 "
				cQuery += cWhere
				
				While CtbZeraOrc->(!Eof())
	
					nMin := (CtbZeraOrc)->RECNO
			
					nCountReg := 0
				
					While CtbZeraOrc->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (CtbZeraOrc)->RECNO
						nCountReg++
						CtbZeraOrc->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0037+" - "+"CT7")//"Eliminando Saldos"
					EndIf
		
				End
				
				dbSelectArea("CT7")
				MsGoto(0)
			Else
		#ENDIF
			If oObj<>Nil
				oObj:SetRegua2(CT7->(LastRec()))
			EndIf
			
			dbSelectArea("CT7")
			dbSetOrder(4)
			MsSeek(xFilial("CT7")+Dtos(dDataIni),.T.)
			While !Eof() .And. CT7->CT7_FILIAL == xFilial("CT7") .And.;
				CT7->CT7_DATA <= dDataFim
				
				If oObj<>Nil
					oObj:IncRegua2(STR0037+" - "+"CT7")//"Eliminando Saldos"
				EndIf
				
				If lMoedaEsp
					If CT7->CT7_MOEDA != cMoeda
						dbSelectArea("CT7")
						dbSkip()
						Loop
					EndIf
				EndIf
				If CT7->CT7_TPSALD == "0"
					RecLock("CT7")
					dbDelete()
					MsUnLock()
				EndIf
				dbSelectArea("CT7")
				dbSkip()
			EndDo
		#IFDEF TOP			
			EndIf
		#ENDIF
	Case cAlias == "CTI"
		#IFDEF TOP
			If TcSrvType() != "AS/400" 		
				CtbZeraOrc := "CtbZeraOrc"
				
				cQuery := "SELECT R_E_C_N_O_ RECNO "
				cQuery += "FROM "+RetSqlName("CTI")+ " "
				cWhere := "WHERE CTI_FILIAL = '"+xFilial("CTI")+"' AND "
				If lMoedaEsp
					cWhere += "CTI_MOEDA = '"+cMoeda+"' AND "
				EndIf
				cWhere += "CTI_TPSALD='0' AND "
				cWhere += "CTI_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
				cWhere += "D_E_L_E_T_=' ' "				
				cQuery += cWhere           
				
				cOrderBy	:= " ORDER BY RECNO "
				cQuery		+= cOrderBy 
				
				cQuery := ChangeQuery(cQuery)                          
				
				If ( Select ( "CtbZeraOrc" ) <> 0 )
					dbSelectArea ( "CtbZeraOrc" )
					dbCloseArea ()
				Endif								
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),CtbZeraOrc)				
				
				If oObj<>Nil
					oObj:SetRegua2((Int((nMax-nMin)/1024)))
				EndIf
				
				dbSelectArea("CTI")
				
				cQuery := "UPDATE "
				cQuery += RetSqlName("CTI")+" "
				cQuery += "SET CTI_DEBITO = 0,"
				cQuery += "CTI_CREDIT = 0,"
				cQuery += "CTI_ANTDEB = 0,"
				cQuery += "CTI_ANTCRD = 0,"
				cQuery += "CTI_ATUDEB = 0,"
				cQuery += "CTI_ATUCRD = 0 "
				cQuery += cWhere
				
				While CtbZeraOrc->(!Eof())
	
					nMin := (CtbZeraOrc)->RECNO
			
					nCountReg := 0
				
					While CtbZeraOrc->(!EOF()) .and. nCountReg <= 4096
					
						nMax := (CtbZeraOrc)->RECNO
						nCountReg++
						CtbZeraOrc->(DbSkip())

					End
				
					cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
					TcSqlExec(cQuery+cChave)
					
					If oObj<>Nil
						oObj:IncRegua2(STR0037+" - "+"CTI")//"Eliminando Saldos"
					EndIf
		
				End
				
				dbSelectArea("CTI")
				MsGoto(0)
			Else
		#ENDIF
			If oObj<>Nil
				oObj:SetRegua2(CTI->(LastRec()))
			EndIf
			dbSelectArea("CTI")
			dbSetOrder(3)
			MsSeek(xFilial("CTI")+Dtos(dDataIni),.T.)
			While !Eof() .And. CTI->CTI_FILIAL == xFilial("CTI") .And.;
				CTI->CTI_DATA <= dDataFim
				If oObj<>Nil
					oObj:IncRegua2(STR0037+" - "+"CTI")//"Eliminando Saldos"
				EndIf
				If lMoedaEsp
					If CTI->CTI_MOEDA != cMoeda
						dbSelectArea("CTI")
						dbSkip()
						Loop
					EndIf
				EndIf
				If CTI->CTI_TPSALD == "0"
					RecLock("CTI")
					dbDelete()
					MsUnLock()
				EndIf
				dbSelectArea("CTI")
				dbSkip()
			EndDo
		#IFDEF TOP			
			EndIf
		#ENDIF
EndCase                             

#IFDEF TOP			
	If TcSrvType() != "AS/400" 		
		If ( Select ( "CtbZeraOrc" ) <> 0 )
			dbSelectArea ( "CtbZeraOrc" )
			dbCloseArea ()
		Endif				
	EndIf
#ENDIF
RestArea(aSaveArea)
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb390Aprv³ Autor ³ Wagner Mobile Costa   ³ Data ³ 28.10.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de aprovacao orcamentaria                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba390                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Aprv

Local aAreaCV2 := CV2->(GetArea())
Local aAreaCV1 := CV1->(GetArea())
Local cCV2Key  := CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA)
Local cAPROVA  := Subs(cUsuario, 7, 15)

If !Empty(CV2->CV2_APROVA)
	MsgInfo(STR0020 + AllTrim(CV1->CV1_APROVA), STR0008) //"Atencao" //"Orcamento ja aprovado pelo usuario "
	Return .T.
Endif

If CV2->CV2_STATUS == "3"
	MsgInfo(STR0007, STR0008) //"Orcamento ja revisado nao podendo ser alterado !"		//"Atencao"
	Return .T.
Endif

DbSelectArea("CV1")
DbSetOrder(1)
DbClearFil()
MsSeek(cCV2Key)

BEGIN TRANSACTION
While !Eof() .And. cCV2Key == CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA)
	RecLock("CV1", .F.)		/// EFETUA A GRAVACAO DO FLAG DE APROVACAO NO ARQUIVO DETALHE
	Replace CV1_APROVA With cAPROVA
	CV1->(MsUnLock())
	CV1->(DbSkip())
EndDo

RecLock("CV2", .F.)		/// EFETUA A GRAVACAO DO FLAG DE APROVACAO NO ARQUIVO HEADER
Replace CV2_APROVA With cAPROVA
CV2->(MsUnLock())

END TRANSACTION

If l390Grv					/// PE APOS A GRAVACAO DO ORCAMENTO
	ExecBlock("CTB390GRV", .F., .F.,{0,M->CV1_ORCMTO,M->CV1_CALEND,M->CV1_MOEDA,M->CV1_REVISA})
Endif

//Ctb390Fil()
RestArea(aAreaCV1)
RestArea(aAreaCV2)

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CheckSX3 ³ Autor ³ Cristina M. Ogura	    ³ Data ³ 17/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz Validacao para campos do cabecalho dos PRGs Mod.2 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ExpL1 := CheckSX3(ExpC1)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Campo do dicionario (SX3)						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function CheckSX3(cCampo,cIniVar,nOpcx)
Local cAlias := Alias(), nRec, nOrd, cValid
Local lRet	 := .T.
DEFAULT nOpcX := 3

If nOpcX == 2 .or. nOpcX == 4 .or. nOpcX == 5 
	Return(.T.)
Endif

dbSelectArea("SX3")
nRec := Recno()
nOrd := IndexOrd()
dbSetOrder(2)
dbSeek(cCampo)
dbSetOrder(nOrd)
dbSelectArea(cAlias)

cValid := IIf(!Empty(SX3->X3_VALID),Alltrim(SX3->X3_VALID),"")
cValid += IIf(!Empty(SX3->X3_VALID).And.!Empty(SX3->X3_VLDUSER)," .And. ","")
cValid += IIf(!Empty(SX3->X3_VLDUSER),Alltrim(SX3->X3_VLDUSER),"")
cVar	 := "M->"+cCampo
If cIniVar == Nil
	&cVar  := &(ReadVar())
Else
	&cVar	 := cIniVar
EndIf

IF !Empty(cValid)
	lRet := &(cValid)
Else
	lRet := .t.
Endif
dbSelectArea("SX3")
dbGoto(nRec)
dbSelectArea(cAlias)

Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390Zera³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para zerar as tabelas de saldos.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Zera()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Zerar os valores das tabelas de saldos do tipo de saldo de ³±±
±±³          ³ orcamento.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilDe   = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ cFilAte  = Filial final para reprocessar (CTBA190)     	  ³±±
±±³          ³ dDataIni = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ dDataIni = Filial final para reprocessar (CTBA190)     	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Zera(cFilDe,cFilAte,dDataIni,dDataFim,lMoedaEsp,cMoeda,lCusto,lItem,lClVl,oObj)

Local aSaveArea	:= GetArea()
Local cFilSal	:= ""

If Empty(xFilial("CT7"))
	cFilSal := Space(2)
Else
	cFilSal := cFilAnt
Endif
CtbZeraTod("CT7",lMoedaEsp,cMoeda,"0",cFilSal,cFilSal,dDataIni,dDataFim,4,.T.,,oObj)

// Zera Saldos de Centro de Custo
If lCusto
	If Empty(xFilial("CT3"))
		cFilSal := Space(2)
	Else
		cFilSal := cFilAnt
	Endif
	CtbZeraTod("CT3",lMoedaEsp,cMoeda,"0",cFilSal,cFilSal,dDataIni,dDataFim,3,.T.,,oObj)
EndIf

// Zera Saldos de Item Contabil
If lItem
	If Empty(xFilial("CT4"))
		cFilSal := Space(2)
	Else
		cFilSal := cFilAnt
	Endif
	CtbZeraTod("CT4",lMoedaEsp,cMoeda,"0",cFilSal,cFilSal,dDataIni,dDataFim,3,.T.,,oObj)
EndIf

// Zera Saldos de Classe de Valor
If lCLVL
	If Empty(xFilial("CTI"))
		cFilSal := Space(2)
	Else
		cFilSal := cFilAnt
	Endif
	CtbZeraTod("CTI",lMoedaEsp,cMoeda,"0",cFilSal,cFilSal,dDataIni,dDataFim,3,.T.,,oObj)
EndIf

RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390Qry ³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Montar query.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Qry()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montar query.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilDe   = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ cFilAte  = Filial final para reprocessar (CTBA190)     	  ³±±
±±³          ³ dDataIni = Filial de inicio para reprocessar (CTBA190)     ³±±
±±³          ³ dDataIni = Filial final para reprocessar (CTBA190)     	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Qry(cFilSal,dDataIni,dDataFim,lMoedaEsp,cMoeda,lGeraSal)

Local lX3Aprova		:= .F.
Local lX3STATSL		:= .F.

#IFDEF TOP
	Local cCondGrSal	:= ""
	Local cCondMoeda	:= ""	 
	Local cQuery		:= ""
	Local cSelOrc		:= ""	
	Local ni
#ENDIF	


If GetMV("MV_ORCAPRV") == "S"
	lX3Aprova := .T.
Endif

dbSelectArea("CV2")
If FieldPos("CV2_STATSL") > 0
	lX3STATSL := .T.
EndIf

DEFAULT lMoedaEsp	:= .F.
DEFAULT lGeraSal	:= .F. //Indica se eh rotina de Geracao de Saldos
DEFAULT cMoeda		:= ""
DEFAULT dDataIni	:= CTOD("  /  /  ")
DEFAULT dDataFim	:= CTOD("  /  /  ")

#IFDEF TOP
	If TcSrvType() != "AS/400"
		
		If lGeraSal	//Se for Rotina de geracao de saldos
			cCondGrSal	+= " CV1.CV1_ORCMTO >= '"+ mv_par01 + "' AND CV1.CV1_ORCMTO <= '" + mv_par02 + "' AND  "
			cCondGrSal  += " CV1.CV1_CALEND >= '"+ mv_par03 + "' AND CV1.CV1_CALEND <= '" + mv_par04 + "' AND  "
			cCondGrSal  += " CV1.CV1_MOEDA  >= '"+ mv_par05 + "' AND CV1.CV1_MOEDA  <= '" + mv_par06 + "' AND  "
			cCondGrSal	+= " CV1.CV1_REVISA >= '"+ mv_par07 + "' AND CV1.CV1_REVISA <= '" + mv_par08 + "' AND  "
			cCondGrSal	+=  "CV1.CV1_STATUS = '1'  AND "
		Else			//Se for Reprocessamento
			If lMoedaEsp
				cCondMoeda	:= 	" CV1.CV1_MOEDA ='" + cMoeda+"' AND "
			Else
				cCondMoeda	:= ""
			EndIf
			cCondGrSal	:= "CV1.CV1_STATUS = '2'  AND "
			cCondGrSal  += "CV1.CV1_DTFIM BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' AND "
		EndIf
		
		cSelOrc := "cSelOrc"
		
		cQuery := "SELECT CV1_CT1INI, CV1_CT1FIM, CV1_CTTINI, CV1_CTTFIM, CV1_CTDINI, CV1_CTDFIM,"
		cQuery += "CV1_CTHINI, CV1_CTHFIM,  CV1_MOEDA, CV1_DTFIM, CV1_VALOR "
		If lX3STATSL
			cQuery += ", CV1_FILIAL, CV1_ORCMTO, CV1_CALEND, CV1_REVISA "			
		EndIf
		cQuery += " FROM "+RetSqlName("CV1")+" CV1 "
		cQuery += " WHERE CV1.CV1_FILIAL = '"+cFilSal+"' AND "
		cQuery += cCondMoeda
		cQuery += cCondGrSal
		If lX3Aprova
			cQuery += " CV1.CV1_APROVA <> '' AND "
		Endif
		cQuery += " CV1.CV1_VALOR <> 0  AND "
		cQuery += " D_E_L_E_T_<>'*'"
		cQuery += " ORDER BY "
		cQuery += " CV1_CTHINI, CV1_CTDINI, CV1_CTTINI, CV1_CT1INI, CV1_MOEDA, CV1_DTFIM"
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cSelOrc" ) <> 0 )
			dbSelectArea ( "cSelOrc" )
			dbCloseArea ()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cSelOrc,.T.,.F.)
		
		aStru := CV1->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				If Subs(aStru[ni,1],1,9) == "CV1_VALOR"
					TCSetField(cSelOrc,aStru[ni,1],aStru[ni,2],aStru[ni,3],aStru[ni,4])
				ElseIf Subs(aStru[ni,1],1,9) == "CV1_DTFIM"
					TCSetField(cSelOrc, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
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
±±³Fun‡„o    ³Ctb390Atu ³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza o arquivo de saldos.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb390Atu()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montar query.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias   = Alias do arquivo a ser consultado               ³±±
±±³          ³ cOperacao= Operacao a ser executada.(1=Soma;2=Subtracao)   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Atu(cAlias,cOperacao,oObj,nValorAnt,nOpcX,lAltValor)

Local aSaveArea	:= GetArea()
Local lCT1		:= .F.
Local lCTT		:= .F.
Local lCTD		:= .F.
Local lCTH		:= .F.
Local nFatorCTH	:= 1
Local nFatorCTHA:= 1	//Fator de multiplicacao anterior
Local nFatorCTT	:= 1
Local nFatorCTTA:= 1	//Fator de multiplicacao anterior
Local nFatorCTD	:= 1
Local nFatorCTDA:= 1	//Fator de multiplicacao anterior

DEFAULT nOpcX		:= 3
DEFAULT lAltValor	:= .F.


If (nOpcX == 3 .And. (!Empty((cAlias)->CV1_CTHINI) .Or. !Empty((cAlias)->CV1_CTHFIM))) .Or. ;
	(nOpcX == 4 .And. (!Empty((cAlias)->CV1_CTHINI) .Or. !Empty((cAlias)->CV1_CTHFIM) .Or. ;
	!Empty(CV1->CV1_CTHINI) .Or. !Empty(CV1->CV1_CTHFIM))) .Or. ;
	(nOpcX == 5 .And. (!Empty(CV1->CV1_CTHINI) .Or. !Empty(CV1->CV1_CTHFIM)))
	lCTH		:= .T.
	
	//Fator de multiplicacao anterior
	nFatorCTHA	:= Ctb390Recn("CTH",CV1->CV1_CTHINI,CV1->CV1_CTHFIM,"CTH_CLVL")
	
	//Fator de multiplicacao atual
	nFatorCTH	:= Ctb390Recn("CTH",(cAlias)->CV1_CTHINI,(cAlias)->CV1_CTHFIM,"CTH_CLVL")
EndIf

If (nOpcX == 3 .And. (!Empty((cAlias)->CV1_CTDINI) .Or. !Empty((cAlias)->CV1_CTDFIM))) .Or. ;
	(nOpcX == 4 .And. (!Empty((cAlias)->CV1_CTDINI) .Or. !Empty((cAlias)->CV1_CTDFIM) .Or. ;
	!Empty(CV1->CV1_CTDINI) .Or. !Empty(CV1->CV1_CTDFIM))) .Or. ;
	(nOpcX == 5 .And. (!Empty(CV1->CV1_CTDINI) .Or. !Empty(CV1->CV1_CTDFIM)))
	lCTD		:= .T.
	//Fator de multiplicacao anterior
	nFatorCTDA	:= Ctb390Recn("CTD",CV1->CV1_CTDINI,CV1->CV1_CTDFIM,"CTD_ITEM")
	
	//Fator de multiplicacao atual
	nFatorCTD	:= Ctb390Recn("CTD",(cAlias)->CV1_CTDINI,(cAlias)->CV1_CTDFIM,"CTD_ITEM")
EndIf

If (nOpcX == 3 .And. (!Empty((cAlias)->CV1_CTTINI) .Or. !Empty((cAlias)->CV1_CTTFIM))) .Or. ;
	(nOpcX == 4 .And. (!Empty((cAlias)->CV1_CTTINI) .Or. !Empty((cAlias)->CV1_CTTFIM) .Or. ;
	!Empty(CV1->CV1_CTTINI) .Or. !Empty(CV1->CV1_CTTFIM))) .Or. ;
	(nOpcX == 5 .And. (!Empty(CV1->CV1_CTTINI) .Or. !Empty(CV1->CV1_CTTFIM)))
	lCTT		:= .T.
	//Fator de multiplicacao anterior
	nFatorCTTA	:= Ctb390Recn("CTT",CV1->CV1_CTTINI,CV1->CV1_CTTFIM,"CTT_CUSTO")
	
	//Fator de multiplicacao atual
	nFatorCTT	:= Ctb390Recn("CTT",(cAlias)->CV1_CTTINI,(cAlias)->CV1_CTTFIM,"CTT_CUSTO")
EndIf

If (nOpcX == 3 .And. (!Empty((cAlias)->CV1_CT1INI) .Or. !Empty((cAlias)->CV1_CT1FIM))) .Or. ;
	(nOpcX == 4 .And. (!Empty((cAlias)->CV1_CT1INI) .Or. !Empty((cAlias)->CV1_CT1FIM) .Or. ;
	!Empty(CV1->CV1_CT1INI) .Or. !Empty(CV1->CV1_CT1FIM))) .Or. ;
	(nOpcX == 5 .And. (!Empty(CV1->CV1_CT1INI) .Or. !Empty(CV1->CV1_CT1FIM)))
	lCT1		:= .T.
EndIf

#IFDEF TOP      
	If TcSrvType() != "AS/400" 
		//Atualizar arquivo CTI
		If lCTH
			Ctb390CTI(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt)	//Grava os valores no CTI com Reclock(".T.")
		EndIf
	
		//Atualizar arquivo CT4
		If lCTD
			Ctb390CT4(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA)	//Grava os valores no CT4 com Reclock(".T.")
		EndIf
	
		//Atualizar arquivo CT3
		If lCTT
			Ctb390CT3(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA)	//Grava os valores no CT4 com Reclock(".T.")
		EndIf
	
		//Atualizar arquivo CT7
		If lCT1
			Ctb390CT7(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)	//Grava os valores no CT4 com Reclock(".T.")
		EndIf
	Else
#ENDIF
	If (cAlias)->CV1_CTHINI <> (cAlias)->CV1_CTHFIM  .Or. ;
		(cAlias)->CV1_CTDINI <> (cAlias)->CV1_CTDFIM .Or. ;
		(cAlias)->CV1_CTTINI <> (cAlias)->CV1_CTTFIM .Or. ;
		(cAlias)->CV1_CT1INI <> (cAlias)->CV1_CT1FIM
		
		Ctb390Sal(.T.,.F.,,,,,nOpcX,cOperacao,lAltValor,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)
		
	Else
		If lCTH
			Ctb390CTI(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt)	//Grava os valores no CTI com Reclock(".T.")
		EndIf
		
		//Atualizar arquivo CT4
		If lCTD
			Ctb390CT4(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA)	//Grava os valores no CT4 com Reclock(".T.")
		EndIf
		
		//Atualizar arquivo CT3
		If lCTT
			Ctb390CT3(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA)	//Grava os valores no CT4 com Reclock(".T.")
		EndIf
		
		//Atualizar arquivo CT7
		If lCT1
			Ctb390CT7(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)	//Grava os valores no CT4 com Reclock(".T.")
		EndIf
	Endif
#IFDEF TOP
	EndIf
#ENDIF

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390Apag³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Deleta os registros que estiverem com debito/credito zerados³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb390Apag()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montar query.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias   = Alias do arquivo a ser consultado               ³±±
±±³          ³ cOperacao= Operacao a ser executada.(1=Soma;2=Subtracao)   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390Apag(cAlias,lMoedaesp,cMoeda,cFilSal,oObj)

Local aSaveArea	:= GetARea()
Local cCond		:= ""
Local cInicial	:= cAlias + "_"
Local c390Zera	:= ""

If !GetNewPar("MV_ATUSLON",.T.)			/// DESLIGA ATUALIZAÇÃO DE SALDO ON-LINE ORCAMENTO
	RestArea(aSaveArea)
	Return
EndIf

If lMoedaEsp //Se for Moeda Especifica
	cCond :="ARQ."+cInicial+ "MOEDA ='" + cMoeda +"' AND "
Else
	cCond := ""
Endif

c390Zera := "c390Zera"

cQuery := "SELECT R_E_C_N_O_ RECNO "
cQuery += "FROM "+RetSqlName(cAlias)+ " ARQ "
cQuery += "WHERE " +"ARQ."+cInicial+ "FILIAL = '"+cFilSal+"' AND "
cQuery += "(ARQ."+cInicial+"DEBITO = 0 AND ARQ."+cInicial+"CREDIT = 0) AND "
cQuery += cCond
cQuery += "ARQ."+cInicial+"TPSALD='0' AND  "
cQuery += "ARQ.D_E_L_E_T_ = ' '"        
cQuery += " ORDER BY RECNO "
cQuery := ChangeQuery(cQuery)

If ( Select ( "c390Zera" ) <> 0 )
	dbSelectArea ( "c390Zera" )
	dbCloseArea ()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),c390Zera,.T.,.F.)

dbSelectArea(cAlias)

If lMoedaEsp //Se for Moeda Especifica
	cCond := " " + cInicial+ "MOEDA ='" + cMoeda +"' AND "
Else
	cCond := ""
Endif


cQuery := "DELETE FROM "
cQuery += RetSqlName(cAlias) + " "
cQuery += "WHERE " +cInicial+ "FILIAL = '"+cFilSal+"' AND "
cQuery += "( "+ cInicial+"DEBITO = 0 AND "+cInicial+"CREDIT = 0) AND "
cQuery += cCond
cQuery += " "+cInicial+"TPSALD='0' AND "

				
While c390Zera->(!Eof())
	
	nMin := (c390Zera)->RECNO
			
	nCountReg := 0
				
	While c390Zera->(!EOF()) .and. nCountReg <= 4096
					
		nMax := (c390Zera)->RECNO
		nCountReg++
		c390Zera->(DbSkip())

	End
				
	cChave := "R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
	TcSqlExec(cQuery+cChave)
					
	If ValType(oObj) == "O"
		oObj:IncRegua1(STR0029+ " - " + cAlias )//Zerando arquivos de Saldos...
	EndIf
		
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³A tabela eh fechada para restaurar o buffer da aplicacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbCloseArea()
ChkFile(cAlias)		// Abrir como compartilhado para permitir acesso de outros usuarios

If ( Select ( "c390Zera" ) <> 0 )
	dbSelectArea ( "c390Zera" )
	dbCloseArea ()
Endif

RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390CTI ³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava os saldos do arquivo CTI.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb390CTI()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montar query.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias   = Alias do arquivo a ser consultado               ³±±
±±³          ³ cOperacao= Operacao a ser executada.(1=Soma;2=Subtracao)   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390CTI(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt)

Local aSaveArea	:= GetArea()
Local aInclui	:= {}
Local cQuery    := ""
Local cQuery1	:= ""
Local cQueryUpd	:= ""
Local cConta	:= ""
Local cCusto	:=	""
Local cItem		:= ""
Local cClVl		:= ""
Local lQuery    := .F.
Local lInclui	:= .F.
Local cCtb390CTI:= ""
Local aSldAntCTI:= {}
Local nAntDeb	:= 0
Local nAntCrd	:= 0
Local nContador	:= 0
Local nPos		:= 0
Local cCt1Normal:= ""
Local cInclui	:= ""

DEFAULT nValorAnt	:= 0

If  ((cAlias)->CV1_CT1INI == (cAlias)->CV1_CT1FIM) .And. ((cAlias)->CV1_CTTINI == (cAlias)->CV1_CTTFIM) .And. ;
	((cAlias)->CV1_CTDINI == (cAlias)->CV1_CTDFIM) .And. ((cAlias)->CV1_CTHINI == (cAlias)->CV1_CTHFIM)
	
	If lCT1
		If cOperacao == "1"
			cConta	:= (cAlias)->CV1_CT1INI
		ElseIf cOperacao == "2"
			cConta	:= CV1->CV1_CT1INI
		EndIf
	Else
		cConta	:= Space(Len(CT1->CT1_CONTA))
	EndIf
	
	If lCTT
		If cOperacao == "1"
			cCusto	:= (cAlias)->CV1_CTTINI
		ElseIf cOperacao == "2"
			cCusto	:= CV1->CV1_CTTFIM
		EndIf
	Else
		cCusto	:= Space(Len(CTT->CTT_CUSTO))
	EndIf
	
	If lCTD
		If cOperacao == "1"
			cItem	:= 	(cAlias)->CV1_CTDINI
		ElseIf cOperacao == "2"
			cItem	:= 	CV1->CV1_CTDINI
		EndIf
	Else
		cItem	:= Space(Len(CTD->CTD_ITEM))
	Endif
	
	If lCTH
		If cOperacao == "1"
			cClVl	:= 	(cAlias)->CV1_CTHINI
		ElseIf cOperacao == "2"
			cClVl	:= 	CV1->CV1_CTHINI
		EndIf
	Else
		cClVl	:=  Space(Len(CTH->CTH_CLVL))
	EndIf
	
	If Empty(cClVl)
		RestArea(aSaveArea)
		Return
	EndIf
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
		cCt1Normal	:= CT1->CT1_NORMAL
	EndIf
	
	//Rotina para recuperar saldo anterior
	CTI->(dbCommit())
	dbSelectArea("CTI")
	#IFNDEF TOP
		dbSetOrder(1)
		MsSeek(xFilial("CTI")+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+cItem+cClVl+DTOS((cAlias)->CV1_DTFIM),.T.)
	#ELSE
		If TcSrvType() == "AS/400" 
			dbSetOrder(1)
			MsSeek(xFilial("CTI")+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+cItem+cClVl+DTOS((cAlias)->CV1_DTFIM),.T.)		
	    EndIF
	#ENDIF
	
	aSldAntCTI := SldAntCTI(cConta,cCusto,cItem,cClVl,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
	nAntDeb	:= aSldAntCTI[1]
	nAntCrd	:= aSldAntCTI[2]
	
	dbSelectArea("CTI")
	dbSetOrder(1)
	If !MsSeek(xFilial()+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+cItem+cClVl+DTOS((cAlias)->CV1_DTFIM))
		If cOperacao == "1"
			RecLock("CTI",.T.)
			CTI->CTI_FILIAL 	:= xFilial("CTI")
			CTI->CTI_CONTA		:= cConta
			CTI->CTI_CUSTO		:= cCusto
			CTI->CTI_ITEM		:= cItem
			CTI->CTI_CLVL		:= cClVl
			CTI->CTI_MOEDA		:= (cAlias)->CV1_MOEDA
			CTI->CTI_DATA		:= (cAlias)->CV1_DTFIM
			CTI->CTI_TPSALD		:= "0"
			CTI->CTI_STATUS		:= "1"					// Periodo Aberto
			CTI->CTI_SLBASE		:= "S"
			CTI->CTI_SLCOMP		:= "N"
			CTI->CTI_LP			:= "N"					// Flag indicando que ainda nao foi zerado
			If lCT1	//Se tiver conta, verificar a natureza da conta.
				If cCt1Normal = "1"
					If (cAlias)->CV1_VALOR < 0
						CTI->CTI_ANTCRD	:= nAntCrd
						CTI->CTI_CREDIT	+= Abs((cAlias)->CV1_VALOR)
						CTI->CTI_ATUCRD := CTI->CTI_ANTCRD+CTI->CTI_CREDIT
					Else
						CTI->CTI_ANTDEB	:= nAntDeb
						CTI->CTI_DEBITO	+= (cAlias)->CV1_VALOR
						CTI->CTI_ATUDEB := CTI->CTI_ANTDEB+CTI->CTI_DEBITO
					Endif
				Else
					If (cAlias)->CV1_VALOR < 0
						CTI->CTI_ANTDEB	:= nAntDeb
						CTI->CTI_DEBITO	+= Abs((cAlias)->CV1_VALOR)
						CTI->CTI_ATUDEB := CTI->CTI_ANTDEB+CTI->CTI_DEBITO
					Else
						CTI->CTI_ANTCRD	:= nAntCrd
						CTI->CTI_CREDIT	+= (cAlias)->CV1_VALOR
						CTI->CTI_ATUCRD := CTI->CTI_ANTCRD+CTI->CTI_CREDIT
					Endif
				Endif
			Else  //Se nao tiver conta no orcamento, considerar como devedor
				If (cAlias)->CV1_VALOR < 0
					CTI->CTI_ANTCRD	:= nAntCrd
					CTI->CTI_CREDIT	+= Abs((cAlias)->CV1_VALOR)
					CTI->CTI_ATUCRD := CTI->CTI_ANTCRD+CTI->CTI_CREDIT
				Else
					CTI->CTI_ANTDEB	:= nAntDeb
					CTI->CTI_DEBITO	+= (cAlias)->CV1_VALOR
					CTI->CTI_ATUDEB := CTI->CTI_ANTDEB+CTI->CTI_DEBITO
				EndIf
			EndIf
			MsUnlock()
		EndIf
	Else
		Reclock("CTI",.F.)
		If lCT1	//Se tiver conta, verificar a natureza da conta.
			If cCt1Normal = "1"
				If (cAlias)->CV1_VALOR < 0
					CTI->CTI_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CTI->CTI_CREDIT	+= Abs((cAlias)->CV1_VALOR)
					ElseIf cOperacao == "2"
						CTI->CTI_CREDIT	-= Abs(nValorAnt)
					EndIf
					CTI->CTI_ATUCRD := CTI->CTI_ANTCRD+CTI->CTI_CREDIT
				Else
					CTI->CTI_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CTI->CTI_DEBITO	+= (cAlias)->CV1_VALOR
					ElseIf cOperacao == "2"
						CTI->CTI_DEBITO	-= nValorAnt
					EndIf
					CTI->CTI_ATUDEB := CTI->CTI_ANTDEB+CTI->CTI_DEBITO
				Endif
			Else
				If (cAlias)->CV1_VALOR < 0
					CTI->CTI_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CTI->CTI_DEBITO	+= Abs((cAlias)->CV1_VALOR)
					ElseIf cOperacao == "2"
						CTI->CTI_DEBITO	-= Abs(nValorAnt)
					EndIf
					CTI->CTI_ATUDEB := CTI->CTI_ANTDEB+CTI->CTI_DEBITO
				Else
					CTI->CTI_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CTI->CTI_CREDIT	+= (cAlias)->CV1_VALOR
					ElseIf cOperacao == "2"
						CTI->CTI_CREDIT	-= nValorAnt
					EndIf
					CTI->CTI_ATUCRD := CTI->CTI_ANTCRD+CTI->CTI_CREDIT
				Endif
			Endif
		Else  //Se nao tiver conta no orcamento, considerar como devedor
			If (cAlias)->CV1_VALOR < 0
				CTI->CTI_ANTCRD	:= nAntCrd
				If cOperacao == "1"
					CTI->CTI_CREDIT	+= Abs((cAlias)->CV1_VALOR)
				ElseIf cOperacao == "2"
					CTI->CTI_CREDIT	-= Abs(nValorAnt)
				EndIf
				CTI->CTI_ATUCRD := CTI->CTI_ANTCRD+CTI->CTI_CREDIT
			Else
				CTI->CTI_ANTDEB	:= nAntDeb
				If cOperacao == "1"
					CTI->CTI_DEBITO	+= (cAlias)->CV1_VALOR
				ElseIf cOperacao == "2"
					CTI->CTI_DEBITO	-= nValorAnt
				EndIf
				CTI->CTI_ATUDEB := CTI->CTI_ANTDEB+CTI->CTI_DEBITO
			EndIf
		EndIf
		MsUnlock()
		nAntDeb	:= 0
		nAntCrd	:= 0
		//Se nao for top connect e os campos CTI_DEBITO e CTI_CREDIT estiverem zerados,
		//deletar o registro.
		#IFNDEF TOP
			If cOperacao == "1"	 .Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
				If CTI->CTI_DEBITO == 0 .And. CTI->CTI_CREDIT == 0
					Reclock("CTI",.F.)
					dbDelete()
					MsUnlock()
				EndIf
			EndIf  
		#ELSE                     
			If TcSrvType() == "AS/400" 
				If cOperacao == "1"	 .Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
					If CTI->CTI_DEBITO == 0 .And. CTI->CTI_CREDIT == 0
						Reclock("CTI",.F.)
						dbDelete()
						MsUnlock()
					EndIf
				EndIf  		
			EndIf
		#ENDIF
	EndIf
Else
	For nContador	:= 1 to 2
		cCtb390CTI	:= "cCtb390CTI"
		lQuery 		:= .T.
		If nContador == 2
			cQuery := ",CTI.R_E_C_N_O_ CTIRECNO "
		EndIf
		If lCT1
			cQuery += ",CT1_CONTA, CT1_NORMAL "
		EndIf
		If  lCTT
			cQuery += ",CTT_CUSTO "
		EndIf
		If lCTD
			cQuery += ",CTD_ITEM "
		EndIf
		If lCTH
			cQuery += ",CTH_CLVL "
		EndIf
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery += "FROM "
		If lCT1
			cQuery1 +="," + RetSqlName("CT1")+" CT1 "
		EndIf
		If lCTT
			cQuery1 +="," + RetSqlName("CTT")+" CTT "
		EndIf
		If lCTD
			cQuery1 +="," +RetSqlName("CTD")+" CTD "
		EndIf
		If lCTH
			cQuery1 += ", "+RetSqlName("CTH")+" CTH "
		EndIf
		If nContador == 2
			cQuery1 += ", "+RetSqlName("CTI")+" CTI "
		EndIf
		cQuery	+= Substr(cQuery1,2)
		cQuery += "WHERE "
		If lCT1
			cQuery += "CT1.CT1_FILIAL = '"+xFilial("CT1")+"' AND "
			cQuery += "CT1.CT1_CONTA >= '"+(cAlias)->CV1_CT1INI+"' AND "
			cQuery += "CT1.CT1_CONTA <= '"+(cAlias)->CV1_CT1FIM+"' AND "
			cQuery += "CT1.CT1_CLASSE = '2' AND "
			cQuery += "CT1.D_E_L_E_T_=' ' AND "
		EndIf
		If lCTT
			cQuery += "CTT.CTT_FILIAL = '"+xFilial("CTT")+"' AND "
			cQuery += "CTT.CTT_CUSTO >= '"+(cAlias)->CV1_CTTINI+"' AND "
			cQuery += "CTT.CTT_CUSTO <= '"+(cAlias)->CV1_CTTFIM+"' AND "
			cQuery += "CTT.CTT_CLASSE = '2' AND "
			cQuery += "CTT.D_E_L_E_T_=' ' AND "
		EndIf
		If lCTD
			cQuery += "CTD.CTD_FILIAL = '"+xFilial("CTD")+"' AND "
			cQuery += "CTD.CTD_ITEM >= '"+(cAlias)->CV1_CTDINI+"' AND "
			cQuery += "CTD.CTD_ITEM <= '"+(cAlias)->CV1_CTDFIM+"' AND "
			cQuery += "CTD.CTD_CLASSE = '2' AND "
			cQuery += "CTD.D_E_L_E_T_=' ' AND "
		EndIf
		If lCTH
			cQuery += "CTH.CTH_FILIAL = '"+xFilial("CTH")+"' AND "
			cQuery += "CTH.CTH_CLVL >= '"+(cAlias)->CV1_CTHINI+"' AND "
			cQuery += "CTH.CTH_CLVL <= '"+(cAlias)->CV1_CTHFIM+"' AND "
			cQuery += "CTH.CTH_CLASSE = '2' AND "
			cQuery += "CTH.D_E_L_E_T_=' ' AND "
		EndIf
		If nContador == 1
			cQuery += "NOT EXISTS ( "
			cQuery += "SELECT CTI_FILIAL "
			cQuery += "FROM "+RetSqlName("CTI")+" CTI "
			cQuery += "WHERE CTI.CTI_FILIAL='"+xFilial("CTI")+"' AND "
		ElseIf nContador == 2
			cQuery += "CTI.CTI_FILIAL='"+xFilial("CTI")+"' AND "
		EndIf
		If lCTH
			cQuery += "CTI.CTI_CLVL = CTH.CTH_CLVL AND "
		Else
			cQuery += "CTI.CTI_CLVL = '"+Space(Len(CTI->CTI_CLVL))+"' AND "
		EndIf
		If lCTD
			cQuery += "CTI.CTI_ITEM = CTD.CTD_ITEM AND "
		Else
			cQuery += "CTI.CTI_ITEM = '"+Space(Len(CTI->CTI_ITEM))+"' AND "
		EndIf
		If lCTT
			cQuery += "CTI.CTI_CUSTO = CTT.CTT_CUSTO AND "
		Else
			cQuery += "CTI.CTI_CUSTO = '"+Space(Len(CTI->CTI_CUSTO))+"' AND "
		EndIf
		If lCT1
			cQuery += "CTI.CTI_CONTA = CT1.CT1_CONTA AND "
		Else
			cQuery += "CTI.CTI_CONTA = '"+Space(Len(CTI->CTI_CONTA))+"' AND "
		EndIf
		cQuery += "CTI.CTI_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+"' AND "
		cQuery += "CTI.CTI_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
		cQuery += "CTI.CTI_TPSALD = '0' AND "
		If nContador == 1
			cQuery += "CTI.D_E_L_E_T_=' ' ) "
		Else
			cQuery += "CTI.D_E_L_E_T_=' ' "
		EndIf
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cCtb390CTI" ) <> 0 )
			dbSelectArea ( "cCtb390CTI" )
			dbCloseArea ()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCtb390CTI)
		
		If nContador	== 1 //GRAVAR OS REGISTROS COM RECLOCK(",T,") => VALOR NAO SERA GRAVADO
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			
			dbSelectArea("cCtb390CTI")
			
			While !Eof()
				If lCT1
					cConta	:= cCtb390CTI->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				If lCTT
					cCusto	:= 	cCtb390CTI->CTT_CUSTO
				Else
					cCusto	:= Space(Len(CTT->CTT_CUSTO))
				EndIf
				
				If lCTD
					cItem	:= 	cCtb390CTI->CTD_ITEM
				Else
					cItem	:= Space(Len(CTD->CTD_ITEM))
				Endif
				
				If lCTH
					cClVl	:= 	cCtb390CTI->CTH_CLVL
				Else
					cClVl	:=  Space(Len(CTH->CTH_CLVL))
				EndIf
				
				//Rotina para recuperar saldo anterior
				RecLock("CTI",.T.)
				CTI->CTI_FILIAL 	:= xFilial("CTI")
				CTI->CTI_CONTA		:= cConta
				CTI->CTI_CUSTO		:= cCusto
				CTI->CTI_ITEM		:= cItem
				CTI->CTI_CLVL		:= cClVl
				CTI->CTI_MOEDA		:= (cAlias)->CV1_MOEDA
				CTI->CTI_DATA		:= (cAlias)->CV1_DTFIM
				CTI->CTI_TPSALD		:= "0"
				CTI->CTI_STATUS		:= "1"					// Periodo Aberto
				CTI->CTI_LP			:= "N"					// Flag indicando que ainda nao foi zerado
				MsUnLock()
				cInclui		:=CTI->CTI_FILIAL+CTI->CTI_CONTA+CTI->CTI_CUSTO+CTI->CTI_ITEM+CTI->CTI_CLVL+CTI->CTI_MOEDA+DTOS(CTI->CTI_DATA)
				AADD(aInclui,cInclui)
				dbSelectArea("cCtb390CTI")
				dbSkip()
				If oObj <> Nil
					oObj:IncRegua2(STR0030) //"Atualizando Saldos da tabela CTI..."
				Endif
			EndDo
			cQuery	:= ""
			cQuery1	:= ""
		ElseIf nContador == 2	//Dar update nos registros
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			
			dbSelectArea("cCtb390CTI")
			While !Eof()
				
				dbSelectArea("cCtb390CTI")
				If lCT1
					cConta	:= cCtb390CTI->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				If lCTT
					cCusto	:= 	cCtb390CTI->CTT_CUSTO
				Else
					cCusto	:= Space(Len(CTT->CTT_CUSTO))
				EndIf
				
				If lCTD
					cItem	:= 	cCtb390CTI->CTD_ITEM
				Else
					cItem	:= Space(Len(CTD->CTD_ITEM))
				Endif
				
				If lCTH
					cClVl	:= 	cCtb390CTI->CTH_CLVL
				Else
					cClVl	:=  Space(Len(CTH->CTH_CLVL))
				EndIf
				nPos	:= ASCAN(aInclui,(xFilial("CTI")+cConta+cCusto+cItem+cClVl+(cAlias)->CV1_MOEDA+DTOS((cAlias)->CV1_DTFIM)))
				If nPos <> 0
					lInclui	:= .T.
				EndIf
				
				//Recuperar saldo anterior
				CTI->(dbCommit())
				aSldAntCTI := SldAntCTI(cConta,cCusto,cItem,cClVl,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
				nAntDeb	   := aSldAntCTI[1]
				nAntCrd	   := aSldAntCTI[2]
				cQueryUpd	:= "UPDATE "
				cQueryUpd	+= RetSqlName("CTI")+" "
				cQueryUpd	+= "SET "
				
				If lCT1	//Se tiver conta, verificar a natureza da conta.
					If cCtb390CTI->CT1_NORMAL = "1"
						If (cAlias)->CV1_VALOR < 0
							cQueryUpd	+= "CTI_ANTCRD  = " + (Str(nAntCrd,TAMSX3("CTI_ANTCRD")[1],TAMSX3("CTI_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CTI_CREDIT  = CTI_CREDIT + " + Str(Abs((cAlias)->CV1_VALOR),TAMSX3("CTI_CREDIT")[1],TAMSX3("CTI_CREDIT")[2])+", "
								cQueryUpd	+= "CTI_ATUCRD  = CTI_CREDIT + " + Str(nAntCrd,TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR),TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CTI_CREDIT  = CTI_CREDIT - " + Str(Abs(nValorAnt),TAMSX3("CTI_CREDIT")[1],TAMSX3("CTI_CREDIT")[2])+", "
								cQueryUpd	+= "CTI_ATUCRD  = CTI_ATUCRD - " + Str(Abs(nValorAnt),TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CTI_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CTI_ANTDEB")[1],TAMSX3("CTI_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CTI_DEBITO  = CTI_DEBITO +" + Str((cAlias)->CV1_VALOR,TAMSX3("CTI_DEBITO")[1],TAMSX3("CTI_DEBITO")[2]) +", "
								cQueryUpd	+= "CTI_ATUDEB  = CTI_DEBITO +" + Str(nAntDeb,TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR,TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2"  .And. !lInclui
								cQueryUpd	+= "CTI_DEBITO  = CTI_DEBITO -" + Str(nValorAnt,TAMSX3("CTI_DEBITO")[1],TAMSX3("CTI_DEBITO")[2]) +", "
								cQueryUpd	+= "CTI_ATUDEB  = CTI_ATUDEB -" + Str(nValorAnt,TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) +", "
							EndIf
						Endif
					Else
						If (cAlias)->CV1_VALOR < 0
							cQueryUpd	+= "CTI_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CTI_ANTDEB")[1],TAMSX3("CTI_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CTI_DEBITO  = CTI_DEBITO + " + Str(Abs((cAlias)->CV1_VALOR),TAMSX3("CTI_DEBITO")[1],TAMSX3("CTI_DEBITO")[2])+", "
								cQueryUpd	+= "CTI_ATUDEB  = CTI_DEBITO + " + Str(nAntDeb,TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) + "+" +Str(Abs((cAlias)->CV1_VALOR),TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CTI_DEBITO  = CTI_DEBITO - " + Str(Abs(nValorAnt),TAMSX3("CTI_DEBITO")[1],TAMSX3("CTI_DEBITO")[2])+", "
								cQueryUpd	+= "CTI_ATUDEB  = CTI_ATUDEB - " + Str(Abs(nValorAnt),TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CTI_ANTCRD	= " + (Str(nAntCrd,TAMSX3("CTI_ANTCRD")[1],TAMSX3("CTI_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd 	+= "CTI_CREDIT	= CTI_CREDIT + " + Str((cAlias)->CV1_VALOR,TAMSX3("CTI_CREDIT")[1],TAMSX3("CTI_CREDIT")[2])+", "
								cQueryUpd	+= "CTI_ATUCRD	= CTI_CREDIT + " + Str(nAntCrd,TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) + "+" + Str((cAlias)->CV1_VALOR,TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd 	+= "CTI_CREDIT	= CTI_CREDIT - " + Str(nValorAnt,TAMSX3("CTI_CREDIT")[1],TAMSX3("CTI_CREDIT")[2])+", "
								cQueryUpd	+= "CTI_ATUCRD	= CTI_ATUCRD - " + Str(nValorAnt,TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) +", "
							EndIf
						Endif
					Endif
				Else  //Se nao tiver conta no orcamento, considerar como devedor
					If (cAlias)->CV1_VALOR < 0
						cQueryUpd	+= "CTI_ANTCRD	= " + (Str(nAntCrd,TAMSX3("CTI_ANTCRD")[1],TAMSX3("CTI_ANTCRD")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CTI_CREDIT	= CTI_CREDIT + " + Str(Abs((cAlias)->CV1_VALOR),TAMSX3("CTI_CREDIT")[1],TAMSX3("CTI_CREDIT")[2])+", "
							cQueryUpd	+= "CTI_ATUCRD	= CTI_CREDIT + " + Str(nAntCrd,TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR),TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) +", "
						ElseIf cOperacao == "2" .And. !lInclui
							cQueryUpd	+= "CTI_CREDIT	= CTI_CREDIT - " + Str(Abs(nValorAnt),TAMSX3("CTI_CREDIT")[1],TAMSX3("CTI_CREDIT")[2])+", "
							cQueryUpd	+= "CTI_ATUCRD	= CTI_ATUCRD - " + Str(Abs(nValorAnt),TAMSX3("CTI_ATUCRD")[1],TAMSX3("CTI_ATUCRD")[2]) +", "
						EndIf
					Else
						cQueryUpd	+= "CTI_ANTDEB	= " + (Str(nAntDeb,TAMSX3("CTI_ANTDEB")[1],TAMSX3("CTI_ANTDEB")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CTI_DEBITO	= CTI_DEBITO + " + Str((cAlias)->CV1_VALOR,TAMSX3("CTI_DEBITO")[1],TAMSX3("CTI_DEBITO")[2]) +", "
							cQueryUpd	+= "CTI_ATUDEB	= CTI_DEBITO + " + Str(nAntDeb,TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR,TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) +", "
						ElseIf cOperacao == "2" .And. !lInclui
							cQueryUpd	+= "CTI_DEBITO	= CTI_DEBITO - " + Str(nValorAnt,TAMSX3("CTI_DEBITO")[1],TAMSX3("CTI_DEBITO")[2]) +", "
							cQueryUpd	+= "CTI_ATUDEB	= CTI_ATUDEB - " + Str(nValorAnt,TAMSX3("CTI_ATUDEB")[1],TAMSX3("CTI_ATUDEB")[2]) +", "
						EndIf
					EndIf
				EndIf
				cQueryUpd	+= " CTI_LP = 'N' ,"
				cQueryUpd	+= " CTI_SLBASE = 'S' "
				cQueryUpd	+= "WHERE CTI_FILIAL = '"+ xFilial("CTI")+ "' AND "
				If lCTH
					cQueryUpd	+= "CTI_CLVL = '"+ cClVl + "' AND "
				EndIf
				If lCTD
					cQueryUpd	+= "CTI_ITEM = '"+ cItem + "' AND "
				EndIf
				If lCTT
					cQueryUpd 	+= "CTI_CUSTO = '"+ cCusto + "' AND "
				EndIf
				If lCT1
					cQueryUpd	+= "CTI_CONTA = '"+ cConta + "' AND "
				EndIf
				cQueryUpd	+= "CTI_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+ "' AND "
				cQueryUpd	+= "CTI_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
				cQueryUpd	+= "CTI_TPSALD = '0' AND "
				cQueryUpd   += "R_E_C_N_O_ = "+Str((cCtb390CTI)->CTIRECNO)+" AND "
				cQueryUpd	+= "D_E_L_E_T_ = ' ' "
				
				//Nesse caso nao foi utilizado o nMin e o nMax porque existe somente um
				//registro a ser atualizado
				TcSqlExec(cQueryUpd)
				
				nAntDeb	:= 0
				nAntCrd	:= 0
				cQueryUpd	:= ""
				MsUnLock()
				dbSelectArea("cCtb390CTI")
				dbSkip()
				lInclui	:= .F.
				If oObj <> Nil
					oObj:IncRegua2(STR0030) //"Atualizando Saldos da tabela CTI..."
				Endif
			EndDo
		EndIf
	Next
EndIf
If ( Select ( "cCtb390CTI" ) <> 0 )
	dbSelectArea ( "cCtb390CTI" )
	dbCloseArea ()
EndIf
RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390CT4 ³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava os saldos do arquivo CT4.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb390CT4()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montar query.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias   = Alias do arquivo a ser consultado               ³±±
±±³          ³ cOperacao= Operacao a ser executada.(1=Soma;2=Subtracao)   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390CT4(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA)

Local aSaveArea	:= GetArea()
Local aSldAntCT4:= {}
Local aInclui	:= {}
Local cQuery    := ""
Local cQuery1	:= ""
Local cQueryUpd	:= ""
Local cConta	:= ""
Local cCusto	:=	""
Local cItem		:= ""
Local cInclui	:= ""
Local cCtb390CT4:= ""
Local cCt1Normal:= ""
Local lQuery    := .F.
Local lInclui	:= .F.
Local nAntDeb	:= 0
Local nAntCrd	:= 0
Local nContador	:= 0
Local nPos		:= 0

DEFAULT nValorAnt	:= 0
DEFAULT nFatorCTH	:= 1
DEFAULT nFatorCTHA	:= 1

If  ((cAlias)->CV1_CT1INI == (cAlias)->CV1_CT1FIM) .And. ((cAlias)->CV1_CTTINI == (cAlias)->CV1_CTTFIM) .And. ;
	((cAlias)->CV1_CTDINI == (cAlias)->CV1_CTDFIM)
	
	If lCT1
		If cOperacao == "1"
			cConta	:= (cAlias)->CV1_CT1INI
		ElseIf cOperacao == "2"
			cConta	:= CV1->CV1_CT1INI
		EndIf
	Else
		cConta	:= Space(Len(CT1->CT1_CONTA))
	EndIf
	
	If lCTT
		If cOperacao == "1"
			cCusto	:= (cAlias)->CV1_CTTINI
		ElseIf cOperacao == "2"
			cCusto	:= CV1->CV1_CTTINI
		EndIf
	Else
		cCusto	:= Space(Len(CTT->CTT_CUSTO))
	EndIf
	
	If lCTD
		If cOperacao == "1"
			cItem	:= 	(cAlias)->CV1_CTDINI
		ElseIf cOperacao == "2"
			cItem	:= CV1->CV1_CTDINI
		EndIf
	Else
		cItem	:= Space(Len(CTD->CTD_ITEM))
	Endif
	
	If Empty(cItem)
		RestArea(aSaveArea)
		Return
	EndIf
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
		cCt1Normal	:= CT1->CT1_NORMAL
	EndIf
	
	//Rotina para recuperar saldo anterior
	CT4->(dbCommit())
	dbSelectarea("CT4")
	#IFNDEF TOP
		dbSetOrder(1)
		MsSeek(xFilial("CT4")+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+cItem+DTOS((cAlias)->CV1_DTFIM),.T.)
	#ELSE
		If TcSrvType() == "AS/400" 
			dbSetOrder(1)
			MsSeek(xFilial("CT4")+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+cItem+DTOS((cAlias)->CV1_DTFIM),.T.)		
		EndIF
	#ENDIF
	aSldAntCT4 := SldAntCT4(cConta,cCusto,cItem,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
	nAntDeb	:= aSldAntCT4[1]
	nAntCrd	:= aSldAntCT4[2]
	
	dbSelectArea("CT4")
	dbSetOrder(1)
	If !MsSeek(xFilial()+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+cItem+DTOS((cAlias)->CV1_DTFIM))
		If cOperacao == "1"
			RecLock("CT4",.T.)
			CT4->CT4_FILIAL 	:= xFilial("CT4")
			CT4->CT4_CONTA		:= cConta
			CT4->CT4_CUSTO		:= cCusto
			CT4->CT4_ITEM		:= cItem
			CT4->CT4_MOEDA		:= (cAlias)->CV1_MOEDA
			CT4->CT4_DATA		:= (cAlias)->CV1_DTFIM
			CT4->CT4_TPSALD		:= "0"
			CT4->CT4_STATUS		:= "1"					// Periodo Aberto
			CT4->CT4_SLBASE		:= "S"
			CT4->CT4_SLCOMP		:= "N"
			CT4->CT4_LP			:= "N"					// Flag indicando que ainda nao foi zerado
			If lCT1	//Se tiver conta, verificar a natureza da conta.
				If cCt1Normal = "1"
					If (cAlias)->CV1_VALOR < 0
						CT4->CT4_ANTCRD	:= nAntCrd
						CT4->CT4_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH)
						CT4->CT4_ATUCRD := CT4->CT4_ANTCRD+CT4->CT4_CREDIT
					Else
						CT4->CT4_ANTDEB	:= nAntDeb
						CT4->CT4_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH)
						CT4->CT4_ATUDEB := CT4->CT4_ANTDEB+CT4->CT4_DEBITO
					Endif
				Else
					If (cAlias)->CV1_VALOR < 0
						CT4->CT4_ANTDEB	:= nAntDeb
						CT4->CT4_DEBITO	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH)
						CT4->CT4_ATUDEB := CT4->CT4_ANTDEB+CT4->CT4_DEBITO
					Else
						CT4->CT4_ANTCRD	:= nAntCrd
						CT4->CT4_CREDIT	+= ((cAlias)->CV1_VALOR*nFatorCTH)
						CT4->CT4_ATUCRD := CT4->CT4_ANTCRD+CT4->CT4_CREDIT
					Endif
				Endif
			Else  //Se nao tiver conta no orcamento, considerar como devedor
				If (cAlias)->CV1_VALOR < 0
					CT4->CT4_ANTCRD	:= nAntCrd
					CT4->CT4_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH)
					CT4->CT4_ATUCRD := CT4->CT4_ANTCRD+CT4->CT4_CREDIT
				Else
					CT4->CT4_ANTDEB	:= nAntDeb
					CT4->CT4_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH)
					CT4->CT4_ATUDEB := CT4->CT4_ANTDEB+CT4->CT4_DEBITO
				EndIf
			EndIf
			MsUnlock()
		EndIf
	Else
		Reclock("CT4",.F.)
		If lCT1	//Se tiver conta, verificar a natureza da conta.
			If cCt1Normal = "1"
				If (cAlias)->CV1_VALOR < 0
					CT4->CT4_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CT4->CT4_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH)
					ElseIf cOperacao == "2"
						CT4->CT4_CREDIT	-= (Abs(nValorAnt)*nFatorCTHA)
					EndIf
					CT4->CT4_ATUCRD := CT4->CT4_ANTCRD+CT4->CT4_CREDIT
				Else
					CT4->CT4_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CT4->CT4_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH)
					ElseIf cOperacao == "2"
						CT4->CT4_DEBITO	-= (nValorAnt*nFatorCTHA)
					EndIf
					CT4->CT4_ATUDEB := CT4->CT4_ANTDEB+CT4->CT4_DEBITO
				Endif
			Else
				If (cAlias)->CV1_VALOR < 0
					CT4->CT4_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CT4->CT4_DEBITO	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH)
					ElseIf cOperacao == "2"
						CT4->CT4_DEBITO	-= (Abs(nValorAnt)*nFatorCTHA)
					EndIf
					CT4->CT4_ATUDEB := CT4->CT4_ANTDEB+CT4->CT4_DEBITO
				Else
					CT4->CT4_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CT4->CT4_CREDIT	+= ((cAlias)->CV1_VALOR*nFatorCTH)
					ElseIf cOperacao == "2"
						CT4->CT4_CREDIT	-= (nValorAnt*nFatorCTHA)
					EndIf
					CT4->CT4_ATUCRD := CT4->CT4_ANTCRD+CT4->CT4_CREDIT
				Endif
			Endif
		Else  //Se nao tiver conta no orcamento, considerar como devedor
			If (cAlias)->CV1_VALOR < 0
				CT4->CT4_ANTCRD	:= nAntCrd
				If cOperacao == "1"
					CT4->CT4_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH)
				ElseIf cOperacao == "2"
					CT4->CT4_CREDIT	-= (Abs(nValorAnt)*	nFatorCTHA)
				EndIf
				CT4->CT4_ATUCRD := CT4->CT4_ANTCRD+CT4->CT4_CREDIT
			Else
				CT4->CT4_ANTDEB	:= nAntDeb
				If cOperacao == "1"
					CT4->CT4_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH)
				ElseIf cOperacao == "2"
					CT4->CT4_DEBITO	-= (nValorAnt*nFatorCTHA)
				EndIf
				CT4->CT4_ATUDEB := CT4->CT4_ANTDEB+CT4->CT4_DEBITO
			EndIf
		EndIf
		MsUnlock()
		nAntDeb	:= 0
		nAntCrd	:= 0
		//Se nao for top connect e os campos CTI_DEBITO e CTI_CREDIT estiverem zerados,
		//deletar o registro.
		#IFNDEF TOP
			If cOperacao == "1"	.Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
				If CT4->CT4_DEBITO == 0 .And. CT4->CT4_CREDIT == 0
					Reclock("CT4",.F.)
					dbDelete()
					MsUnlock()
				EndIf
			EndIf  
		#ELSE
			If TcSrvType() == "AS/400" 
				If cOperacao == "1"	.Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
					If CT4->CT4_DEBITO == 0 .And. CT4->CT4_CREDIT == 0
						Reclock("CT4",.F.)
						dbDelete()
						MsUnlock()
					EndIf
				EndIf  
			EndIf				
		#ENDIF
	EndIf
Else
	For nContador	:= 1 to 2
		
		cCtb390CT4	:= "cCtb390CT4"
		lQuery 		:= .T.
		If nContador == 2
			cQuery += ",CT4.R_E_C_N_O_ CT4RECNO "
		EndIf
		If lCT1
			cQuery += ",CT1_CONTA, CT1_NORMAL "
		EndIf
		If  lCTT
			cQuery += ",CTT_CUSTO "
		EndIf
		If lCTD
			cQuery += ",CTD_ITEM "
		EndIf
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery += "FROM "
		If lCT1
			cQuery1 +="," + RetSqlName("CT1")+" CT1 "
		EndIf
		If lCTT
			cQuery1 +="," + RetSqlName("CTT")+" CTT "
		EndIf
		If lCTD
			cQuery1 +="," +RetSqlName("CTD")+" CTD "
		EndIf
		If nContador == 2
			cQuery1 +="," +RetSqlName("CT4")+" CT4 "
		EndIf
		cQuery	+= Substr(cQuery1,2)
		cQuery += "WHERE "
		If lCT1
			cQuery += "CT1.CT1_FILIAL = '"+xFilial("CT1")+"' AND "
			cQuery += "CT1.CT1_CONTA >= '"+(cAlias)->CV1_CT1INI+"' AND "
			cQuery += "CT1.CT1_CONTA <= '"+(cAlias)->CV1_CT1FIM+"' AND "
			cQuery += "CT1.CT1_CLASSE = '2' AND "
			cQuery += "CT1.D_E_L_E_T_=' ' AND "
		EndIf
		If lCTT
			cQuery += "CTT.CTT_FILIAL = '"+xFilial("CTT")+"' AND "
			cQuery += "CTT.CTT_CUSTO >= '"+(cAlias)->CV1_CTTINI+"' AND "
			cQuery += "CTT.CTT_CUSTO <= '"+(cAlias)->CV1_CTTFIM+"' AND "
			cQuery += "CTT.CTT_CLASSE = '2' AND "
			cQuery += "CTT.D_E_L_E_T_=' ' AND "
		EndIf
		If lCTD
			cQuery += "CTD.CTD_FILIAL = '"+xFilial("CTD")+"' AND "
			cQuery += "CTD.CTD_ITEM >= '"+(cAlias)->CV1_CTDINI+"' AND "
			cQuery += "CTD.CTD_ITEM <= '"+(cAlias)->CV1_CTDFIM+"' AND "
			cQuery += "CTD.CTD_CLASSE = '2' AND "
			cQuery += "CTD.D_E_L_E_T_=' ' AND "
		EndIf
		If nContador == 1
			cQuery += "NOT EXISTS ( "
			cQuery += "SELECT CT4_FILIAL "
			cQuery += "FROM "+RetSqlName("CT4")+" CT4 "
			cQuery += "WHERE CT4.CT4_FILIAL='"+xFilial("CT4")+"' AND "
		ElseIf nContador == 2
			cQuery += "CT4.CT4_FILIAL='"+xFilial("CT4")+"' AND "
		EndIf
		If lCTD
			cQuery += "CT4.CT4_ITEM = CTD.CTD_ITEM AND "
		Else
			cQuery += "CT4.CT4_ITEM = '"+Space(Len(CT4->CT4_ITEM))+"' AND "
		EndIf
		If lCTT
			cQuery += "CT4.CT4_CUSTO = CTT.CTT_CUSTO AND "
		Else
			cQuery += "CT4.CT4_CUSTO = '"+Space(Len(CT4->CT4_CUSTO))+"' AND "
		EndIf
		If lCT1
			cQuery += "CT4.CT4_CONTA = CT1.CT1_CONTA AND "
		Else
			cQuery += "CT4.CT4_CONTA = '"+Space(Len(CT4->CT4_CONTA))+"' AND "
		EndIf
		cQuery += "CT4.CT4_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+"' AND "
		cQuery += "CT4.CT4_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
		cQuery += "CT4.CT4_TPSALD = '0' AND "
		If nContador == 1
			cQuery += "CT4.D_E_L_E_T_=' ' ) "
		Else
			cQuery += "CT4.D_E_L_E_T_=' ' "
		EndIf
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cCtb390CT4" ) <> 0 )
			dbSelectArea ( "cCtb390CT4" )
			dbCloseArea ()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCtb390CT4)
		
		If nContador	== 1 //GRAVAR OS REGISTROS COM RECLOCK(",T,") => VALOR NAO SERA GRAVADO
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			
			dbSelectArea("cCtb390CT4")
			
			While !Eof()
				//Rotina para recuperar saldo anterior
				If lCT1
					cConta	:= cCtb390CT4->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				If lCTT
					cCusto	:= 	cCtb390CT4->CTT_CUSTO
				Else
					cCusto	:= Space(Len(CTT->CTT_CUSTO))
				EndIf
				
				If lCTD
					cItem	:= 	cCtb390CT4->CTD_ITEM
				Else
					cItem	:= Space(Len(CTD->CTD_ITEM))
				Endif
				
				RecLock("CT4",.T.)
				CT4->CT4_FILIAL 	:= xFilial("CT4")
				CT4->CT4_CONTA		:= cConta
				CT4->CT4_CUSTO		:= cCusto
				CT4->CT4_ITEM		:= cItem
				CT4->CT4_MOEDA		:= (cAlias)->CV1_MOEDA
				CT4->CT4_DATA		:= (cAlias)->CV1_DTFIM
				CT4->CT4_TPSALD		:= "0"
				CT4->CT4_STATUS		:= "1"					// Periodo Aberto
				CT4->CT4_LP			:= "N"					// Flag indicando que ainda nao foi zerado
				MsUnLock()
				
				cInclui		:=CT4->CT4_FILIAL+CT4->CT4_CONTA+CT4->CT4_CUSTO+CT4->CT4_ITEM+CT4->CT4_MOEDA+DTOS(CT4->CT4_DATA)
				AADD(aInclui,cInclui)
				
				dbSelectArea("cCtb390CT4")
				dbSkip()
				If oObj <> Nil
					oObj:IncRegua2(STR0032) //"Atualizando Saldos da tabela CT4..."
				Endif
			EndDo
			cQuery	:= ""
			cQuery1	:= ""
		ElseIf nContador == 2	//Dar update nos registros
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			
			dbSelectArea("cCtb390CT4")
			While !Eof()
				
				dbSelectArea("cCtb390CT4")
				If lCT1
					cConta	:= cCtb390CT4->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				If lCTT
					cCusto	:= 	cCtb390CT4->CTT_CUSTO
				Else
					cCusto	:= Space(Len(CTT->CTT_CUSTO))
				EndIf
				
				If lCTD
					cItem	:= 	cCtb390CT4->CTD_ITEM
				Else
					cItem	:= Space(Len(CTD->CTD_ITEM))
				Endif
				
				nPos	:= ASCAN(aInclui,(xFilial("CT4")+cConta+cCusto+cItem+(cAlias)->CV1_MOEDA+DTOS((cAlias)->CV1_DTFIM)))
				If nPos <> 0
					lInclui	:= .T.
				EndIf
				
				//Rotina para recuperar saldo anterior
				CT4->(dbCommit())
				//Recuperar saldo anterior
				aSldAntCT4 := SldAntCT4(cConta,cCusto,cItem,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
				nAntDeb	:= aSldAntCT4[1]
				nAntCrd	:= aSldAntCT4[2]
				
				cQueryUpd	:= "UPDATE "
				cQueryUpd	+= RetSqlName("CT4")+" "
				cQueryUpd	+= "SET "
				
				If lCT1	//Se tiver conta, verificar a natureza da conta.
					If cCtb390CT4->CT1_NORMAL = "1"
						If (cAlias)->CV1_VALOR < 0
							cQueryUpd	+= "CT4_ANTCRD  = " + (Str(nAntCrd,TAMSX3("CT4_ANTCRD")[1],TAMSX3("CT4_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT4_CREDIT  = CT4_CREDIT + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH),TAMSX3("CT4_CREDIT")[1],TAMSX3("CT4_CREDIT")[2])+", "
								cQueryUpd	+= "CT4_ATUCRD  = CT4_CREDIT + " + Str(nAntCrd,TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH),TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT4_CREDIT  = CT4_CREDIT - " + Str(Abs(nValorAnt*nFatorCTHA),TAMSX3("CT4_CREDIT")[1],TAMSX3("CT4_CREDIT")[2])+", "
								cQueryUpd	+= "CT4_ATUCRD  = CT4_ATUCRD - " + Str(Abs(nValorAnt*nFatorCTHA),TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CT4_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CT4_ANTDEB")[1],TAMSX3("CT4_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT4_DEBITO  = CT4_DEBITO + " + Str((cAlias)->CV1_VALOR*nFatorCTH,TAMSX3("CT4_DEBITO")[1],TAMSX3("CT4_DEBITO")[2]) +", "
								cQueryUpd	+= "CT4_ATUDEB  = CT4_DEBITO + " + Str(nAntDeb,TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR*nFatorCTH,TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT4_DEBITO  = CT4_DEBITO - " + Str(nValorAnt*nFatorCTHA,TAMSX3("CT4_DEBITO")[1],TAMSX3("CT4_DEBITO")[2]) +", "
								cQueryUpd	+= "CT4_ATUDEB  = CT4_ATUDEB - " + Str(nValorAnt*nFatorCTHA,TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) +", "
							EndIf
						Endif
					Else
						If CV1->CV1_VALOR < 0
							cQueryUpd	+= "CT4_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CT4_ANTDEB")[1],TAMSX3("CT4_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT4_DEBITO  = CT4_DEBITO + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH),TAMSX3("CT4_DEBITO")[1],TAMSX3("CT4_DEBITO")[2])+", "
								cQueryUpd	+= "CT4_ATUDEB  = CT4_DEBITO + " + Str(nAntDeb,TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) + "+" +Str(Abs((cAlias)->CV1_VALOR*nFatorCTH),TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT4_DEBITO  = CT4_DEBITO - " + Str(Abs(nValorAnt*nFatorCTHA),TAMSX3("CT4_DEBITO")[1],TAMSX3("CT4_DEBITO")[2])+", "
								cQueryUpd	+= "CT4_ATUDEB  = CT4_ATUDEB - " + Str(Abs(nValorAnt*nFatorCTHA),TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CT4_ANTCRD	= "+ (Str(nAntCrd,TAMSX3("CT4_ANTCRD")[1],TAMSX3("CT4_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd 	+= "CT4_CREDIT	= CT4_CREDIT + " + Str((cAlias)->CV1_VALOR*nFatorCTH,TAMSX3("CT4_CREDIT")[1],TAMSX3("CT4_CREDIT")[2])+", "
								cQueryUpd	+= "CT4_ATUCRD	= CT4_CREDIT + " + Str(nAntCrd,TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) + "+" + Str((cAlias)->CV1_VALOR*nFatorCTH,TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd 	+= "CT4_CREDIT	= CT4_CREDIT - " + Str(nValorAnt*nFatorCTHA,TAMSX3("CT4_CREDIT")[1],TAMSX3("CT4_CREDIT")[2])+", "
								cQueryUpd	+= "CT4_ATUCRD	= CT4_ATUCRD - " + Str(nValorAnt*nFatorCTHA,TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) +", "
							EndIf
						Endif
					Endif
				Else  //Se nao tiver conta no orcamento, considerar como devedor
					If (cAlias)->CV1_VALOR < 0
						cQueryUpd	+= "CT4_ANTCRD	= " + (Str(nAntCrd,TAMSX3("CT4_ANTCRD")[1],TAMSX3("CT4_ANTCRD")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CT4_CREDIT	= CT4_CREDIT + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH),TAMSX3("CT4_CREDIT")[1],TAMSX3("CT4_CREDIT")[2])+", "
							cQueryUpd	+= "CT4_ATUCRD	= CT4_CREDIT + " + Str(nAntCrd,TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH),TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) +", "
						ElseIf cOperacao == "2"  .And. !lInclui
							cQueryUpd	+= "CT4_CREDIT	= CT4_CREDIT - " + Str(Abs(nValorAnt*nFatorCTHA),TAMSX3("CT4_CREDIT")[1],TAMSX3("CT4_CREDIT")[2])+", "
							cQueryUpd	+= "CT4_ATUCRD	= CT4_ATUCRD - " + Str(Abs(nValorAnt*nFatorCTHA),TAMSX3("CT4_ATUCRD")[1],TAMSX3("CT4_ATUCRD")[2]) +", "
						EndIf
					Else
						cQueryUpd	+= "CT4_ANTDEB	= " + (Str(nAntDeb,TAMSX3("CT4_ANTDEB")[1],TAMSX3("CT4_ANTDEB")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CT4_DEBITO	= CT4_DEBITO + " + Str((cAlias)->CV1_VALOR*nFatorCTH,TAMSX3("CT4_DEBITO")[1],TAMSX3("CT4_DEBITO")[2]) +", "
							cQueryUpd	+= "CT4_ATUDEB	= CT4_DEBITO + " + Str(nAntDeb,TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR*nFatorCTH,TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) +", "
						ElseIf cOperacao == "2" .And. !lInclui
							cQueryUpd	+= "CT4_DEBITO	= CT4_DEBITO - " + Str(nValorAnt*nFatorCTHA,TAMSX3("CT4_DEBITO")[1],TAMSX3("CT4_DEBITO")[2]) +", "
							cQueryUpd	+= "CT4_ATUDEB	= CT4_ATUDEB - " + Str(nValorAnt*nFatorCTHA,TAMSX3("CT4_ATUDEB")[1],TAMSX3("CT4_ATUDEB")[2]) +", "
						EndIf
					EndIf
				EndIf
				cQueryUpd	+= " CT4_LP = 'N' ,"
				cQueryUpd	+= " CT4_SLBASE = 'S' "
				cQueryUpd	+= "WHERE CT4_FILIAL = '"+ xFilial("CT4")+ "' AND "
				If lCTD
					cQueryUpd	+= "CT4_ITEM = '"+ cItem + "' AND "
				EndIf
				If lCTT
					cQueryUpd 	+= "CT4_CUSTO = '"+ cCusto + "' AND "
				EndIf
				If lCT1
					cQueryUpd	+= "CT4_CONTA = '"+ cConta + "' AND "
				EndIf
				cQueryUpd	+= "CT4_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+ "' AND "
				cQueryUpd	+= "CT4_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
				cQueryUpd	+= "CT4_TPSALD = '0' AND "
				cQueryUpd   += "R_E_C_N_O_ = "+Str((cCtb390CT4)->CT4RECNO)+" AND "
				cQueryUpd	+= "D_E_L_E_T_ =  ' ' "
				
				//Nesse caso nao foi utilizado o nMin e o nMax porque existe somente um
				//registro a ser atualizado
				TcSqlExec(cQueryUpd)
				
				nAntDeb	:= 0
				nAntCrd	:= 0
				cQueryUpd	:= ""
				MsUnLock()
				dbSelectArea("cCtb390CT4")
				dbSkip()
				lInclui	:= .F.
				If oObj <> Nil
					oObj:IncRegua2(STR0032) //"Atualizando Saldos da tabela CT4..."
				Endif
			EndDo
		EndIf
	Next
EndIf
If ( Select ( "cCtb390CT4" ) <> 0 )
	dbSelectArea ( "cCtb390CT4" )
	dbCloseArea ()
Endif
RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390CT3 ³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava os saldos do arquivo CT3.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb390CT3()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montar query.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias   = Alias do arquivo a ser consultado               ³±±
±±³          ³ cOperacao= Operacao a ser executada.(1=Soma;2=Subtracao)   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390CT3(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA)

Local aSaveArea	:= GetArea()
Local aInclui	:= {}
Local aSldAntCT3:= {}
Local cQuery    := ""
Local cQuery1	:= ""
Local cQueryUpd	:= ""
Local cConta	:= ""
Local cCusto	:=	""
Local cCt1Normal:= ""
Local cCtb390CT3:= ""
Local lQuery    := .F.
Local lInclui	:= .F.
Local nAntDeb	:= 0
Local nAntCrd	:= 0
Local nContador	:= 0
Local nPos		:= 0

DEFAULT nValorAnt	:= 0
DEFAULT nFatorCTH 	:= 1
DEFAULT nFatorCTHA	:= 1
DEFAULT nFatorCTD	:= 1
DEFAULT nFatorCTDA	:= 1

If  ((cAlias)->CV1_CT1INI == (cAlias)->CV1_CT1FIM) .And. ((cAlias)->CV1_CTTINI == (cAlias)->CV1_CTTFIM)
	
	If lCT1
		If cOperacao == "1"
			cConta	:= (cAlias)->CV1_CT1INI
		Elseif cOperacao == "2"
			cConta	:= CV1->CV1_CT1INI
		EndIf
	Else
		cConta	:= Space(Len(CT1->CT1_CONTA))
	EndIf
	
	If lCTT
		If cOperacao == "1"
			cCusto	:= (cAlias)->CV1_CTTINI
		ElseIf cOperacao == "2"
			cCusto	:= CV1->CV1_CTTINI
		EndIf
	Else
		cCusto	:= Space(Len(CTT->CTT_CUSTO))
	EndIf
	
	If Empty(cCusto)
		RestArea(aSaveArea)
		Return
	EndIf
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
		cCt1Normal	:= CT1->CT1_NORMAL
	EndIf
	
	//Rotina para recuperar saldo anterior
	CT3->(dbCommit())
	dbSelectArea("CT3")
	//Se nao for top connect, eh necessario posicionar no registro.
	#IFNDEF TOP
		dbSetOrder(1)
		MsSeek(xFilial("CT3")+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+DTOS((cAlias)->CV1_DTFIM),.T.)
	#ELSE
		If TcSrvType() == "AS/400" 
			dbSetOrder(1)
			MsSeek(xFilial("CT3")+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+DTOS((cAlias)->CV1_DTFIM),.T.)
		EndIf	
	#ENDIF
	aSldAntCT3 := SldAntCT3(cConta,cCusto,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
	nAntDeb	:= aSldAntCT3[1]
	nAntCrd	:= aSldAntCT3[2]
	
	dbSelectArea("CT3")
	dbSetOrder(1)
	If !MsSeek(xFilial()+(cAlias)->CV1_MOEDA+"0"+cConta+cCusto+DTOS((cAlias)->CV1_DTFIM))
		If cOperacao == "1"
			RecLock("CT3",.T.)
			CT3->CT3_FILIAL 	:= xFilial("CT3")
			CT3->CT3_CONTA		:= cConta
			CT3->CT3_CUSTO		:= cCusto
			CT3->CT3_MOEDA		:= (cAlias)->CV1_MOEDA
			CT3->CT3_DATA		:= (cAlias)->CV1_DTFIM
			CT3->CT3_TPSALD		:= "0"
			CT3->CT3_STATUS		:= "1"					// Periodo Aberto
			CT3->CT3_LP			:= "N"					// Flag indicando que ainda nao foi zerado
			CT3->CT3_SLBASE		:= "S"
			CT3->CT3_SLCOMP		:= "N"
			If lCT1	//Se tiver conta, verificar a natureza da conta.
				If cCt1Normal = "1"
					If (cAlias)->CV1_VALOR < 0
						CT3->CT3_ANTCRD	:= nAntCrd
						CT3->CT3_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTD*nFatorCTH)
						CT3->CT3_ATUCRD := CT3->CT3_ANTCRD+CT3->CT3_CREDIT
					Else
						CT3->CT3_ANTDEB	:= nAntDeb
						CT3->CT3_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH)
						CT3->CT3_ATUDEB := CT3->CT3_ANTDEB+CT3->CT3_DEBITO
					Endif
				Else
					If (cAlias)->CV1_VALOR < 0
						CT3->CT3_ANTDEB	:= nAntDeb
						CT3->CT3_DEBITO	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTD*nFatorCTH)
						CT3->CT3_ATUDEB := CT3->CT3_ANTDEB+CT3->CT3_DEBITO
					Else
						CT3->CT3_ANTCRD	:= nAntCrd
						CT3->CT3_CREDIT	+= ((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH)
						CT3->CT3_ATUCRD := CT3->CT3_ANTCRD+CT3->CT3_CREDIT
					Endif
				Endif
			Else  //Se nao tiver conta no orcamento, considerar como devedor
				If (cAlias)->CV1_VALOR < 0
					CT3->CT3_ANTCRD	:= nAntCrd
					CT3->CT3_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTD*nFatorCTH)
					CT3->CT3_ATUCRD := CT3->CT3_ANTCRD+CT3->CT3_CREDIT
				Else
					CT3->CT3_ANTDEB	:= nAntDeb
					CT3->CT3_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH)
					CT3->CT3_ATUDEB := CT3->CT3_ANTDEB+CT3->CT3_DEBITO
				EndIf
			EndIf
			MsUnlock()
		EndIf
	Else
		Reclock("CT3",.F.)
		If lCT1	//Se tiver conta, verificar a natureza da conta.
			If cCt1Normal = "1"
				If (cAlias)->CV1_VALOR < 0
					CT3->CT3_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CT3->CT3_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTD*nFatorCTH)
					ElseIf cOperacao == "2"
						CT3->CT3_CREDIT	-= (Abs(nValorAnt)*nFatorCTDA*nFatorCTHA)
					EndIf
					CT3->CT3_ATUCRD := CT3->CT3_ANTCRD+CT3->CT3_CREDIT
				Else
					CT3->CT3_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CT3->CT3_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH)
					ElseIf cOperacao == "2"
						CT3->CT3_DEBITO	-= (nValorAnt*nFatorCTDA*nFatorCTHA)
					EndIF
					CT3->CT3_ATUDEB := CT3->CT3_ANTDEB+CT3->CT3_DEBITO
				Endif
			Else
				If (cAlias)->CV1_VALOR < 0
					CT3->CT3_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CT3->CT3_DEBITO	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTD*nFatorCTH)
					ElseIf cOperacao == "2"
						CT3->CT3_DEBITO	-= (Abs(nValorAnt)*nFatorCTDA*nFatorCTHA)
					EndIf
					CT3->CT3_ATUDEB := CT3->CT3_ANTDEB+CT3->CT3_DEBITO
				Else
					CT3->CT3_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CT3->CT3_CREDIT	+= ((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH)
					ElseIf cOperacao == "2"
						CT3->CT3_CREDIT	-= (nValorAnt*nFatorCTDA*nFatorCTHA)
					EndIf
					CT3->CT3_ATUCRD := CT3->CT3_ANTCRD+CT3->CT3_CREDIT
				Endif
			Endif
		Else  //Se nao tiver conta no orcamento, considerar como devedor
			If (cAlias)->CV1_VALOR < 0
				CT3->CT3_ANTCRD	:= nAntCrd
				If cOperacao == "1"
					CT3->CT3_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTD*nFatorCTH)
				ElseIf cOperacao == "2"
					CT3->CT3_CREDIT	-= (Abs(nValorAnt)*nFatorCTDA*nFatorCTHA)
				EnDiF
				CT3->CT3_ATUCRD := CT3->CT3_ANTCRD+CT3->CT3_CREDIT
			Else
				CT3->CT3_ANTDEB	:= nAntDeb
				If cOperacao == "1"
					CT3->CT3_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH)
				ElseIf cOperacao == "2"
					CT3->CT3_DEBITO	-= (nValorAnt*nFatorCTDA*nFatorCTHA)
				EndIF
				CT3->CT3_ATUDEB := CT3->CT3_ANTDEB+CT3->CT3_DEBITO
			EndIf
		EndIf
		MsUnlock()
		nAntDeb	:= 0
		nAntCrd	:= 0
		//Se nao for top connect e os campos CT3_DEBITO e CT3_CREDIT estiverem zerados,
		//deletar o registro.
		#IFNDEF TOP
			If cOperacao == "1"	.Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
				If CT3->CT3_DEBITO == 0 .And. CT3->CT3_CREDIT == 0
					Reclock("CT3",.F.)
					dbDelete()
					MsUnlock()
				EndIf
			EndIf
		#ELSE
			If TcSrvType() == "AS/400" 		
				If cOperacao == "1"	.Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
					If CT3->CT3_DEBITO == 0 .And. CT3->CT3_CREDIT == 0
						Reclock("CT3",.F.)
						dbDelete()
						MsUnlock()
					EndIf
				EndIf		      
			EndIf
		#ENDIF		
	EndIf
Else
	For nContador	:= 1 to 2
		cCtb390CT3	:= "cCtb390CT3"
		lQuery 		:= .T.
		If nContador == 2
			cQuery += ",CT3.R_E_C_N_O_ CT3RECNO "
		EndIf
		If lCT1
			cQuery += ",CT1_CONTA, CT1_NORMAL "
		EndIf
		If  lCTT
			cQuery += ",CTT_CUSTO "
		EndIf
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery += "FROM "
		If lCT1
			cQuery1 +="," + RetSqlName("CT1")+" CT1 "
		EndIf
		If lCTT
			cQuery1 +="," + RetSqlName("CTT")+" CTT "
		EndIf
		If nContador == 2
			cQuery1 += "," + RetSqlName("CT3")+" CT3 "
		EndIf
		cQuery	+= Substr(cQuery1,2)
		cQuery += "WHERE "
		If lCT1
			cQuery += "CT1.CT1_FILIAL = '"+xFilial("CT1")+"' AND "
			cQuery += "CT1.CT1_CONTA >= '"+(cAlias)->CV1_CT1INI+"' AND "
			cQuery += "CT1.CT1_CONTA <= '"+(cAlias)->CV1_CT1FIM+"' AND "
			cQuery += "CT1.CT1_CLASSE = '2' AND "
			cQuery += "CT1.D_E_L_E_T_=' ' AND "
		EndIf
		If lCTT
			cQuery += "CTT.CTT_FILIAL = '"+xFilial("CTT")+"' AND "
			cQuery += "CTT.CTT_CUSTO >= '"+(cAlias)->CV1_CTTINI+"' AND "
			cQuery += "CTT.CTT_CUSTO <= '"+(cAlias)->CV1_CTTFIM+"' AND "
			cQuery += "CTT.CTT_CLASSE = '2' AND "
			cQuery += "CTT.D_E_L_E_T_=' ' AND "
		EndIf
		If nContador == 1
			cQuery += "NOT EXISTS ( "
			cQuery += "SELECT CT3_FILIAL "
			cQuery += "FROM "+RetSqlName("CT3")+" CT3 "
			cQuery += "WHERE CT3.CT3_FILIAL='"+xFilial("CT3")+"' AND "
		ElseIf nContador == 2
			cQuery += "CT3.CT3_FILIAL='"+xFilial("CT3")+"' AND "
		EndIf
		If lCTT
			cQuery += "CT3.CT3_CUSTO = CTT.CTT_CUSTO AND "
		Else
			cQuery += "CT3.CT3_CUSTO = '"+Space(Len(CT3->CT3_CUSTO))+"' AND "
		EndIf
		If lCT1
			cQuery += "CT3.CT3_CONTA = CT1.CT1_CONTA AND "
		Else
			cQuery += "CT3.CT3_CONTA = '"+Space(Len(CT3->CT3_CONTA))+"' AND "
		EndIf
		cQuery += "CT3.CT3_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+"' AND "
		cQuery += "CT3.CT3_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
		cQuery += "CT3.CT3_TPSALD = '0' AND "
		If nContador == 1
			cQuery += "CT3.D_E_L_E_T_=' ' ) "
		Else
			cQuery += "CT3.D_E_L_E_T_=' ' "
		EndIf
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cCtb390CT3" ) <> 0 )
			dbSelectArea ( "cCtb390CT3" )
			dbCloseArea ()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCtb390CT3)
		
		If nContador	== 1 //GRAVAR OS REGISTROS COM RECLOCK(",T,") => VALOR NAO SERA GRAVADO
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			dbSelectArea("cCtb390CT3")
			
			While !Eof()
				//Rotina para recuperar saldo anterior
				If lCT1
					cConta	:= cCtb390CT3->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				If lCTT
					cCusto	:= 	cCtb390CT3->CTT_CUSTO
				Else
					cCusto	:= Space(Len(CTT->CTT_CUSTO))
				EndIf
				
				RecLock("CT3",.T.)
				CT3->CT3_FILIAL 	:= xFilial("CT3")
				CT3->CT3_CONTA		:= cConta
				CT3->CT3_CUSTO		:= cCusto
				CT3->CT3_MOEDA		:= (cAlias)->CV1_MOEDA
				CT3->CT3_DATA		:= (cAlias)->CV1_DTFIM
				CT3->CT3_TPSALD		:= "0"
				CT3->CT3_STATUS		:= "1"					// Periodo Aberto
				CT3->CT3_LP			:= "N"					// Flag indicando que ainda nao foi zerado
				MsUnLock()
				cInclui		:=CT3->CT3_FILIAL+CT3->CT3_CONTA+CT3->CT3_CUSTO+CT3->CT3_MOEDA+DTOS(CT3->CT3_DATA)
				AADD(aInclui,cInclui)
				dbSelectArea("cCtb390CT3")
				dbSkip()
				If oObj <> Nil
					oObj:IncRegua2(STR0033) //"Atualizando Saldos da tabela CT3..."
				Endif
			EndDo
			cQuery	:= ""
			cQuery1	:= ""
		ElseIf nContador == 2	//Dar update nos registros
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			
			dbSelectArea("cCtb390CT3")
			While !Eof()
				
				dbSelectArea("cCtb390CT3")
				If lCT1
					cConta	:= cCtb390CT3->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				If lCTT
					cCusto	:= 	cCtb390CT3->CTT_CUSTO
				Else
					cCusto	:= Space(Len(CTT->CTT_CUSTO))
				EndIf
				
				nPos	:= ASCAN(aInclui,(xFilial("CT3")+cConta+cCusto+(cAlias)->CV1_MOEDA+DTOS((cAlias)->CV1_DTFIM)))
				If nPos <> 0
					lInclui	:= .T.
				EndIf
				
				//Recuperar saldo anterior
				CT3->(dbCommit())
				aSldAntCT3 := SldAntCT3(cConta,cCusto,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
				nAntDeb	:= aSldAntCT3[1]
				nAntCrd	:= aSldAntCT3[2]
				
				cQueryUpd	:= "UPDATE "
				cQueryUpd	+= RetSqlName("CT3")+" "
				cQueryUpd	+= "SET "
				
				If lCT1	//Se tiver conta, verificar a natureza da conta.
					If cCtb390CT3->CT1_NORMAL = "1"
						If (cAlias)->CV1_VALOR < 0
							cQueryUpd	+= "CT3_ANTCRD  = " + (Str(nAntCrd,TAMSX3("CT3_ANTCRD")[1],TAMSX3("CT3_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT3_CREDIT  = CT3_CREDIT + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH),TAMSX3("CT3_CREDIT")[1],TAMSX3("CT3_CREDIT")[2])+", "
								cQueryUpd	+= "CT3_ATUCRD  = CT3_CREDIT + " + Str(nAntCrd,TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH),TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT3_CREDIT  = CT3_CREDIT - " + Str(Abs(nValorAnt*nFatorCTDA*nFatorCTHA),TAMSX3("CT3_CREDIT")[1],TAMSX3("CT3_CREDIT")[2])+", "
								cQueryUpd	+= "CT3_ATUCRD  = CT3_ATUCRD - " + Str(Abs(nValorAnt*nFatorCTDA*nFatorCTHA),TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CT3_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CT3_ANTDEB")[1],TAMSX3("CT3_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT3_DEBITO  = CT3_DEBITO + " + Str((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH,TAMSX3("CT3_DEBITO")[1],TAMSX3("CT3_DEBITO")[2]) +", "
								cQueryUpd	+= "CT3_ATUDEB  = CT3_DEBITO + " + Str(nAntDeb,TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH,TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT3_DEBITO  = CT3_DEBITO - " + Str(nValorAnt*nFatorCTDA*nFatorCTHA,TAMSX3("CT3_DEBITO")[1],TAMSX3("CT3_DEBITO")[2]) +", "
								cQueryUpd	+= "CT3_ATUDEB  = CT3_ATUDEB - " + Str(nValorAnt*nFatorCTDA*nFatorCTHA,TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) +", "
							EndIf
						Endif
					Else
						If CV1->CV1_VALOR < 0
							cQueryUpd	+= "CT3_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CT3_ANTDEB")[1],TAMSX3("CT3_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT3_DEBITO  =  CT3_DEBITO + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH),TAMSX3("CT3_DEBITO")[1],TAMSX3("CT3_DEBITO")[2])+", "
								cQueryUpd	+= "CT3_ATUDEB  =  CT3_DEBITO + " + Str(nAntDeb,TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) + "+" +Str(Abs((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH),TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT3_DEBITO  =  CT3_DEBITO - " + Str(Abs(nValorAnt*nFatorCTDA*nFatorCTHA),TAMSX3("CT3_DEBITO")[1],TAMSX3("CT3_DEBITO")[2])+", "
								cQueryUpd	+= "CT3_ATUDEB  =  CT3_ATUDEB - " + Str(Abs(nValorAnt*nFatorCTDA*nFatorCTHA),TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CT3_ANTCRD	= " + (Str(nAntCrd,TAMSX3("CT3_ANTCRD")[1],TAMSX3("CT3_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd 	+= "CT3_CREDIT	= CT3_CREDIT + " + Str((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH,TAMSX3("CT3_CREDIT")[1],TAMSX3("CT3_CREDIT")[2])+", "
								cQueryUpd	+= "CT3_ATUCRD	= CT3_CREDIT + " + Str(nAntCrd,TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) + "+" + Str((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH,TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd 	+= "CT3_CREDIT	= CT3_CREDIT - " + Str(nValorAnt*nFatorCTDA*nFatorCTHA,TAMSX3("CT3_CREDIT")[1],TAMSX3("CT3_CREDIT")[2])+", "
								cQueryUpd	+= "CT3_ATUCRD	= CT3_ATUCRD - " + Str(nValorAnt*nFatorCTDA*nFatorCTHA,TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) +", "
							EndIf
						Endif
					Endif
				Else  //Se nao tiver conta no orcamento, considerar como devedor
					If (cAlias)->CV1_VALOR < 0
						cQueryUpd	+= "CT3_ANTCRD	= " + (Str(nAntCrd,TAMSX3("CT3_ANTCRD")[1],TAMSX3("CT3_ANTCRD")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CT3_CREDIT	= CT3_CREDIT + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH),TAMSX3("CT3_CREDIT")[1],TAMSX3("CT3_CREDIT")[2])+", "
							cQueryUpd	+= "CT3_ATUCRD	= CT3_CREDIT + " + Str(nAntCrd,TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH),TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) +", "
						ElseIf cOperacao == "2" .And. !lInclui
							cQueryUpd	+= "CT3_CREDIT	= CT3_CREDIT - " + Str(Abs(nValorAnt*nFatorCTDA*nFatorCTHA),TAMSX3("CT3_CREDIT")[1],TAMSX3("CT3_CREDIT")[2])+", "
							cQueryUpd	+= "CT3_ATUCRD	= CT3_ATUCRD - " + Str(Abs(nValorAnt*nFatorCTDA*nFatorCTHA),TAMSX3("CT3_ATUCRD")[1],TAMSX3("CT3_ATUCRD")[2]) +", "
						EndIf
					Else
						cQueryUpd	+= "CT3_ANTDEB	= " + (Str(nAntDeb,TAMSX3("CT3_ANTDEB")[1],TAMSX3("CT3_ANTDEB")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CT3_DEBITO	= CT3_DEBITO + " + Str((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH,TAMSX3("CT3_DEBITO")[1],TAMSX3("CT3_DEBITO")[2]) +", "
							cQueryUpd	+= "CT3_ATUDEB	= CT3_DEBITO + " + Str(nAntDeb,TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR*nFatorCTD*nFatorCTH,TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) +", "
						ElseIf cOperacao == "2" .And. !lInclui
							cQueryUpd	+= "CT3_DEBITO	= CT3_DEBITO - " + Str(nValorAnt*nFatorCTDA*nFatorCTHA,TAMSX3("CT3_DEBITO")[1],TAMSX3("CT3_DEBITO")[2]) +", "
							cQueryUpd	+= "CT3_ATUDEB	= CT3_ATUDEB - " + Str(nValorAnt*nFatorCTDA*nFatorCTHA,TAMSX3("CT3_ATUDEB")[1],TAMSX3("CT3_ATUDEB")[2]) +", "
						EndIf
					EndIf
				EndIf
				cQueryUpd	+= " CT3_LP = 'N' ,"
				cQueryUpd	+= " CT3_SLBASE = 'S' "
				cQueryUpd	+= "WHERE CT3_FILIAL = '"+ xFilial("CT3")+ "' AND "
				If lCTT
					cQueryUpd 	+= "CT3_CUSTO = '"+ cCusto + "' AND "
				EndIf
				If lCT1
					cQueryUpd	+= "CT3_CONTA = '"+ cConta + "' AND "
				EndIf
				cQueryUpd	+= "CT3_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+ "' AND "
				cQueryUpd	+= "CT3_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
				cQueryUpd	+= "CT3_TPSALD = '0' AND "
				cQueryUpd   += "R_E_C_N_O_ = "+Str((cCtb390CT3)->CT3RECNO)+" AND "
				cQueryUpd	+= "D_E_L_E_T_ =  ' ' "
				
				//Nesse caso nao foi utilizado o nMin e o nMax porque existe somente um
				//registro a ser atualizado
				TcSqlExec(cQueryUpd)
				
				nAntDeb	:= 0
				nAntCrd	:= 0
				cQueryUpd	:= ""
				MsUnLock()
				dbSelectArea("cCtb390CT3")
				dbSkip()
				lInclui	:= .F.
				If oObj <> Nil
					oObj:IncRegua2(STR0033) //"Atualizando Saldos da tabela CT3..."
				Endif
			EndDo
		EndIf
	Next
EndIf
If ( Select ( "cCtb390CT3" ) <> 0 )
	dbSelectArea ( "cCtb390CT3" )
	dbCloseArea ()
Endif
RestArea(aSaveArea)
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390CT7 ³ Autor ³ Simone Mie Sato       ³ Data ³ 03/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava os saldos do arquivo CT7.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb390CT7()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montar query.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias   = Alias do arquivo a ser consultado               ³±±
±±³          ³ cOperacao= Operacao a ser executada.(1=Soma;2=Subtracao)   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb390CT7(cAlias,cOperacao,lCT1,lCTT,lCTD,lCTH,oObj,nValorAnt,nFatorCTH,nFatorCTHA,nFatorCTD,nFatorCTDA,nFatorCTT,nFatorCTTA)

Local aSaveArea	:= GetArea()
Local aSldAntCT7:= {}
Local aInclui	:= {}
Local cQuery    := ""
Local cQuery1	:= ""
Local cQueryUpd	:= ""
Local cConta	:= ""
Local cCtb390CT7:= ""
Local cCt1Normal:= ""
Local cInclui	:= ""
Local lQuery    := .F.
Local lInclui	:= .F.
Local nAntDeb	:= 0
Local nAntCrd	:= 0
Local nContador	:= 0

DEFAULT nValorAnt	:= 0
DEFAULT nFatorCTH	:= 1
DEFAULT nFatorCTHA	:= 1
DEFAULT nFatorCTD	:= 1
DEFAULT nFatorCTDA	:= 1
DEFAULT nFatorCTT	:= 1
DEFAULT nFatorCTTA	:= 1

If  ((cAlias)->CV1_CT1INI == (cAlias)->CV1_CT1FIM)
	
	If lCT1
		If cOperacao == "1"
			cConta	:= (cAlias)->CV1_CT1INI
		ElseIf cOperacao == "2"
			cConta	:= CV1->CV1_CT1INI
		Endif
	Else
		cConta	:= Space(Len(CT1->CT1_CONTA))
	EndIf
	
	If Empty(cConta)
		RestArea(aSaveArea)
		Return
	Endif
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
		cCt1Normal	:= CT1->CT1_NORMAL
	EndIf
	
	//Rotina para recuperar saldo anterior
	CT7->(dbCommit())
	dbSelectArea("CT7")
	#IFNDEF TOP
		dbSetOrder(1)
		MsSeek(xFilial("CT7")+(cAlias)->CV1_MOEDA+"0"+cConta+DTOS((cAlias)->CV1_DTFIM),.T.)
	#ELSE
		If TcSrvType() == "AS/400" 			
			dbSetOrder(1)
			MsSeek(xFilial("CT7")+(cAlias)->CV1_MOEDA+"0"+cConta+DTOS((cAlias)->CV1_DTFIM),.T.)
		EndIf		
	#ENDIF
	
	aSldAntCT7 := SldAntCT7(cConta,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
	nAntDeb	:= aSldAntCT7[1]
	nAntCrd	:= aSldAntCT7[2]
	
	dbSelectArea("CT7")
	dbSetOrder(1)
	If !MsSeek(xFilial()+(cAlias)->CV1_MOEDA+"0"+cConta+DTOS((cAlias)->CV1_DTFIM))
		If cOperacao == "1"
			RecLock("CT7",.T.)
			CT7->CT7_FILIAL 	:= xFilial("CT7")
			CT7->CT7_CONTA		:= cConta
			CT7->CT7_MOEDA		:= (cAlias)->CV1_MOEDA
			CT7->CT7_DATA		:= (cAlias)->CV1_DTFIM
			CT7->CT7_TPSALD		:= "0"
			CT7->CT7_STATUS		:= "1"					// Periodo Aberto
			CT7->CT7_LP			:= "N"					// Flag indicando que ainda nao foi zerado
			CT7->CT7_SLBASE		:= "S"
			If lCT1	//Se tiver conta, verificar a natureza da conta.
				If cCt1Normal = "1"
					If (cAlias)->CV1_VALOR < 0
						CT7->CT7_ANTCRD	:= nAntCrd
						CT7->CT7_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH*nFatorCTD*nFatorCTT)
						CT7->CT7_ATUCRD := CT7->CT7_ANTCRD+CT7->CT7_CREDIT
					Else
						CT7->CT7_ANTDEB	:= nAntDeb
						CT7->CT7_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT)
						CT7->CT7_ATUDEB :=  CT7->CT7_ANTDEB+CT7->CT7_DEBITO
					Endif
				Else
					If (cAlias)->CV1_VALOR < 0
						CT7->CT7_ANTDEB	:= nAntDeb
						CT7->CT7_DEBITO	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH*nFatorCTD*nFatorCTT)
						CT7->CT7_ATUDEB :=  CT7->CT7_ANTDEB+CT7->CT7_DEBITO
					Else
						CT7->CT7_ANTCRD	:= nAntCrd
						CT7->CT7_CREDIT	+= ((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT)
						CT7->CT7_ATUCRD := CT7->CT7_ANTCRD+CT7->CT7_CREDIT
					Endif
				Endif
			Else  //Se nao tiver conta no orcamento, considerar como devedor
				If (cAlias)->CV1_VALOR < 0
					CT7->CT7_ANTCRD	:= nAntCrd
					CT7->CT7_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH*nFatorCTD*nFatorCTT)
					CT7->CT7_ATUCRD := CT7->CT7_ANTCRD+CT7->CT7_CREDIT
				Else
					CT7->CT7_ANTDEB	:= nAntDeb
					CT7->CT7_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT)
					CT7->CT7_ATUDEB :=  CT7->CT7_ANTDEB+CT7->CT7_DEBITO
				EndIf
			EndIf
		EndIf
		MsUnlock()
	Else
		Reclock("CT7",.F.)
		If lCT1	//Se tiver conta, verificar a natureza da conta.
			If cCt1Normal = "1"
				If (cAlias)->CV1_VALOR < 0
					CT7->CT7_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CT7->CT7_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH*nFatorCTD*nFatorCTT)
					ElseIf cOperacao == "2"
						CT7->CT7_CREDIT	-= (Abs(nValorAnt)*nFatorCTHA*nFatorCTDA*nFatorCTTA)
					EndIf
					CT7->CT7_ATUCRD := CT7->CT7_ANTCRD+CT7->CT7_CREDIT
				Else
					CT7->CT7_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CT7->CT7_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT)
					ElseIf cOperacao == "2"
						CT7->CT7_DEBITO	-= (nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA)
					EndIf
					CT7->CT7_ATUDEB :=  CT7->CT7_ANTDEB+CT7->CT7_DEBITO
				Endif
			Else
				If (cAlias)->CV1_VALOR < 0
					CT7->CT7_ANTDEB	:= nAntDeb
					If cOperacao == "1"
						CT7->CT7_DEBITO	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH*nFatorCTD*nFatorCTT)
					ElseIf cOperacao == "2"
						CT7->CT7_DEBITO	-= (Abs(nValorAnt)*nFatorCTHA*nFatorCTDA*nFatorCTTA)
					EndIf
					CT7->CT7_ATUDEB :=  CT7->CT7_ANTDEB+CT7->CT7_DEBITO
				Else
					CT7->CT7_ANTCRD	:= nAntCrd
					If cOperacao == "1"
						CT7->CT7_CREDIT	+= ((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT)
					ElseIf cOperacao == "2"
						CT7->CT7_CREDIT	-= (nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA)
					EndIf
					CT7->CT7_ATUCRD := CT7->CT7_ANTCRD+CT7->CT7_CREDIT
				Endif
			Endif
		Else  //Se nao tiver conta no orcamento, considerar como devedor
			If (cAlias)->CV1_VALOR < 0
				CT7->CT7_ANTCRD	:= nAntCrd
				If cOperacao == "1"
					CT7->CT7_CREDIT	+= (Abs((cAlias)->CV1_VALOR)*nFatorCTH*nFatorCTD*nFatorCTT)
				ElseIf cOperacao == "2"
					CT7->CT7_CREDIT	-= (Abs(nValorAnt)*nFatorCTHA*nFatorCTDA*nFatorCTTA)
				EndIf
				CT7->CT7_ATUCRD := CT7->CT7_ANTCRD+CT7->CT7_CREDIT
			Else
				CT7->CT7_ANTDEB	:= nAntDeb
				If cOperacao == "1"
					CT7->CT7_DEBITO	+= ((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT)
				ElseIf cOperacao == "2"
					CT7->CT7_DEBITO	-= (nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA)
				EndIf
				CT7->CT7_ATUDEB :=  CT7->CT7_ANTDEB+CT7->CT7_DEBITO
			EndIf
		EndIf
		MsUnlock()
		nAntDeb	:= 0
		nAntCrd	:= 0
		
		//Se nao for top connect e os campos CT7_DEBITO e CT7_CREDIT estiverem zerados,
		//deletar o registro.
		#IFNDEF TOP
			If cOperacao == "1" .Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
				If CT7->CT7_DEBITO == 0 .And. CT7->CT7_CREDIT == 0
					Reclock("CT7",.F.)
					dbDelete()
					MsUnlock()
				EndIf
			EndIf
		#ELSE
			If TcSrvType() == "AS/400" 		
				If cOperacao == "1" .Or. (cOperacao == "2" .And. TMP->CV1_VALOR == 0)
					If CT7->CT7_DEBITO == 0 .And. CT7->CT7_CREDIT == 0
						Reclock("CT7",.F.)
						dbDelete()
						MsUnlock()
					EndIf
				EndIf			
			EndIf		
		#ENDIF
	EndIf
Else
	For nContador	:= 1 to 2
		cCtb390CT7	:= "cCtb390CT7"
		lQuery 		:= .T.
		If nContador == 2
			cQuery += ",CT7.R_E_C_N_O_ CT7RECNO "
		EndIf
		If lCT1
			cQuery += ",CT1_CONTA, CT1_NORMAL "
		EndIf
		cQuery := "SELECT "+SubStr(cQuery,2)
		cQuery += "FROM "
		If lCT1
			cQuery1 +="," + RetSqlName("CT1")+" CT1 "
		EndIf
		If nContador == 2
			cQuery1 +="," + RetSqlName("CT7")+" CT7 "
		EndIf
		cQuery	+= Substr(cQuery1,2)
		cQuery += "WHERE "
		If lCT1
			cQuery += "CT1.CT1_FILIAL = '"+xFilial("CT1")+"' AND "
			cQuery += "CT1.CT1_CONTA >= '"+(cAlias)->CV1_CT1INI+"' AND "
			cQuery += "CT1.CT1_CONTA <= '"+(cAlias)->CV1_CT1FIM+"' AND "
			cQuery += "CT1.CT1_CLASSE = '2' AND "
			cQuery += "CT1.D_E_L_E_T_=' ' AND "
		EndIf
		If nContador == 1
			cQuery += "NOT EXISTS ( "
			cQuery += "SELECT CT7_FILIAL "
			cQuery += "FROM "+RetSqlName("CT7")+" CT7 "
			cQuery += "WHERE CT7.CT7_FILIAL='"+xFilial("CT7")+"' AND "
		ElseIf nContador == 2
			cQuery += "CT7.CT7_FILIAL='"+xFilial("CT7")+"' AND "
		EndIf
		If lCT1
			cQuery += "CT7.CT7_CONTA = CT1.CT1_CONTA AND "
		Else
			cQuery += "CT7.CT7_CONTA = '"+Space(Len(CT7->CT7_CONTA))+"' AND "
		EndIf
		cQuery += "CT7.CT7_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+"' AND "
		cQuery += "CT7.CT7_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
		cQuery += "CT7.CT7_TPSALD = '0' AND "
		If nContador == 1
			cQuery += "CT7.D_E_L_E_T_=' ' ) "
		Else
			cQuery += "CT7.D_E_L_E_T_=' ' "
		EndIf
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cCtb390CT7" ) <> 0 )
			dbSelectArea ( "cCtb390CT7" )
			dbCloseArea ()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCtb390CT7)
		If nContador	== 1 //GRAVAR OS REGISTROS COM RECLOCK(",T,") => VALOR NAO SERA GRAVADO
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			dbSelectArea("cCtb390CT7")
			
			While !Eof()
				//Rotina para recuperar saldo anterior
				If lCT1
					cConta	:= cCtb390CT7->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				RecLock("CT7",.T.)
				CT7->CT7_FILIAL 	:= xFilial("CT7")
				CT7->CT7_CONTA		:= cConta
				CT7->CT7_MOEDA		:= (cAlias)->CV1_MOEDA
				CT7->CT7_DATA		:= (cAlias)->CV1_DTFIM
				CT7->CT7_TPSALD		:= "0"
				CT7->CT7_STATUS		:= "1"					// Periodo Aberto
				CT7->CT7_LP			:= "N"					// Flag indicando que ainda nao foi zerado
				MsUnLock()
				cInclui		:=CT7->CT7_FILIAL+CT7->CT7_CONTA+CT7->CT7_MOEDA+DTOS(CT7->CT7_DATA)
				AADD(aInclui,cInclui)
				dbSelectArea("cCtb390CT7")
				dbSkip()
				If oObj <> Nil
					oObj:IncRegua2(STR0034) //"Atualizando Saldos da tabela CT7..."
				Endif
			EndDo
			cQuery	:= ""
			cQuery1	:= ""
		ElseIf nContador == 2	//Dar update nos registros
			If oObj <> Nil
				oObj:SetRegua2(MAXPASSO)
			Endif
			
			dbSelectArea("cCtb390CT7")
			While !Eof()
				
				dbSelectArea("cCtb390CT7")
				If lCT1
					cConta	:= cCtb390CT7->CT1_CONTA
				Else
					cConta	:= Space(Len(CT1->CT1_CONTA))
				EndIf
				
				nPos	:= ASCAN(aInclui,(xFilial("CT7")+cConta+(cAlias)->CV1_MOEDA+DTOS((cAlias)->CV1_DTFIM)))
				If nPos <> 0
					lInclui	:= .T.
				EndIf
				
				//Rotina para recuperar saldo anterior
				CT7->(dbCommit())
				aSldAntCT7 := SldAntCT7(cConta,(cAlias)->CV1_DTFIM,(cAlias)->CV1_MOEDA,'0',,.T.)
				nAntDeb	:= aSldAntCT7[1]
				nAntCrd	:= aSldAntCT7[2]
				
				cQueryUpd	:= "UPDATE "
				cQueryUpd	+= RetSqlName("CT7")+" "
				cQueryUpd	+= "SET "
				
				If lCT1	//Se tiver conta, verificar a natureza da conta.
					If cCtb390CT7->CT1_NORMAL = "1"
						If (cAlias)->CV1_VALOR < 0
							cQueryUpd	+= "CT7_ANTCRD  = " + (Str(nAntCrd,TAMSX3("CT7_ANTCRD")[1],TAMSX3("CT7_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT7_CREDIT  = CT7_CREDIT  + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT),TAMSX3("CT7_CREDIT")[1],TAMSX3("CT7_CREDIT")[2])+", "
								cQueryUpd	+= "CT7_ATUCRD  = CT7_CREDIT  + " + Str(nAntCrd,TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT),TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT7_CREDIT  = CT7_CREDIT  - " + Str(Abs(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA),TAMSX3("CT7_CREDIT")[1],TAMSX3("CT7_CREDIT")[2])+", "
								cQueryUpd	+= "CT7_ATUCRD  = CT7_ATUCRD  - " + Str(Abs(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA),TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CT7_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CT7_ANTDEB")[1],TAMSX3("CT7_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT7_DEBITO  = CT7_DEBITO + " + Str((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT,TAMSX3("CT7_DEBITO")[1],TAMSX3("CT7_DEBITO")[2]) +", "
								cQueryUpd	+= "CT7_ATUDEB  = CT7_DEBITO + " + Str(nAntDeb,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT7_DEBITO  = CT7_DEBITO - " + Str(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA,TAMSX3("CT7_DEBITO")[1],TAMSX3("CT7_DEBITO")[2]) +", "
								cQueryUpd	+= "CT7_ATUDEB  = CT7_ATUDEB - " + Str(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) +", "
							EndIf
						Endif
					Else
						If CV1->CV1_VALOR < 0
							cQueryUpd	+= "CT7_ANTDEB  = " + (Str(nAntDeb,TAMSX3("CT7_ANTDEB")[1],TAMSX3("CT7_ANTDEB")[2])) +", "
							If cOperacao == "1"
								cQueryUpd	+= "CT7_DEBITO  = CT7_DEBITO + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT),TAMSX3("CT7_DEBITO")[1],TAMSX3("CT7_DEBITO")[2])+", "
								cQueryUpd	+= "CT7_ATUDEB  = CT7_DEBITO + " + Str(nAntDeb,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) + "+" +Str(Abs((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT),TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) +", "
							ElseIf cOperacao == "2" .And. !lInclui
								cQueryUpd	+= "CT7_DEBITO  = CT7_DEBITO - " + Str(Abs(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA),TAMSX3("CT7_DEBITO")[1],TAMSX3("CT7_DEBITO")[2])+", "
								cQueryUpd	+= "CT7_ATUDEB  = CT7_ATUDEB - " + Str(Abs(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA),TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) +", "
							EndIf
						Else
							cQueryUpd	+= "CT7_ANTCRD	= "+ (Str(nAntCrd,TAMSX3("CT7_ANTCRD")[1],TAMSX3("CT7_ANTCRD")[2])) +", "
							If cOperacao == "1"
								cQueryUpd 	+= "CT7_CREDIT	= CT7_CREDIT + " + Str((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT,TAMSX3("CT7_CREDIT")[1],TAMSX3("CT7_CREDIT")[2])+", "
								cQueryUpd	+= "CT7_ATUCRD	= CT7_CREDIT + " + Str(nAntCrd,TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) + "+" + Str((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT,TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) +", "
							ElseIf cOperacao == "2"  .And. !lInclui
								cQueryUpd 	+= "CT7_CREDIT	= CT7_CREDIT - " + Str(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA,TAMSX3("CT7_CREDIT")[1],TAMSX3("CT7_CREDIT")[2])+", "
								cQueryUpd	+= "CT7_ATUCRD	= CT7_ATUCRD - " + Str(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA,TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) +", "
							EndIf
						Endif
					Endif
				Else  //Se nao tiver conta no orcamento, considerar como devedor
					If (cAlias)->CV1_VALOR < 0
						cQueryUpd	+= "CT7_ANTCRD	= " + (Str(nAntCrd,TAMSX3("CT7_ANTCRD")[1],TAMSX3("CT7_ANTCRD")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CT7_CREDIT	= CT7_CREDIT + " + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT),TAMSX3("CT7_CREDIT")[1],TAMSX3("CT7_CREDIT")[2])+", "
							cQueryUpd	+= "CT7_ATUCRD	= CT7_CREDIT + " + Str(nAntCrd,TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) + "+" + Str(Abs((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT),TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) +", "
						ElseIf cOperacao == "2" .And. !lInclui
							cQueryUpd	+= "CT7_CREDIT	= CT7_CREDIT - " + Str(Abs(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA),TAMSX3("CT7_CREDIT")[1],TAMSX3("CT7_CREDIT")[2])+", "
							cQueryUpd	+= "CT7_ATUCRD	= CT7_ATUCRD - " + Str(Abs(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA),TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2]) +", "
						EndIf
					Else
						cQueryUpd	+= "CT7_ANTDEB	= " + (Str(nAntDeb,TAMSX3("CT7_ANTDEB")[1],TAMSX3("CT7_ANTDEB")[2])) +", "
						If cOperacao == "1"
							cQueryUpd	+= "CT7_DEBITO	= CT7_DEBITO + " + Str((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT,TAMSX3("CT7_DEBITO")[1],TAMSX3("CT7_DEBITO")[2]) +", "
							cQueryUpd	+= "CT7_ATUDEB	= CT7_DEBITO + " + Str(nAntDeb,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) + "+" +Str((cAlias)->CV1_VALOR*nFatorCTH*nFatorCTD*nFatorCTT,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) +", "
						ElseIf cOperacao == "2" .And. !lInclui
							cQueryUpd	+= "CT7_DEBITO	= CT7_DEBITO - " + Str(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA,TAMSX3("CT7_DEBITO")[1],TAMSX3("CT7_DEBITO")[2]) +", "
							cQueryUpd	+= "CT7_ATUDEB	= CT7_ATUDEB - " + Str(nValorAnt*nFatorCTHA*nFatorCTDA*nFatorCTTA,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2]) +", "
						EndIf
					EndIf
				EndIf
				cQueryUpd	+= " CT7_LP = 'N' ,"
				cQueryUpd	+= " CT7_SLBASE = 'S' "
				cQueryUpd	+= "WHERE CT7_FILIAL = '"+ xFilial("CT7")+ "' AND "
				If lCT1
					cQueryUpd	+= "CT7_CONTA = '"+ cConta + "' AND "
				EndIf
				cQueryUpd	+= "CT7_DATA = '"+DTOS((cAlias)->CV1_DTFIM)+ "' AND "
				cQueryUpd	+= "CT7_MOEDA = '"+(cAlias)->CV1_MOEDA+"' AND "
				cQueryUpd	+= "CT7_TPSALD = '0' AND "
				cQueryUpd   += "R_E_C_N_O_ = "+Str((cCtb390CT7)->CT7RECNO)+" AND "
				cQueryUpd	+= "D_E_L_E_T_ = ' ' "
				
				//Nesse caso nao foi utilizado o nMin e o nMax porque existe somente um
				//registro a ser atualizado
				TcSqlExec(cQueryUpd)
				
				nAntDeb	:= 0
				nAntCrd	:= 0
				cQueryUpd	:= ""
				MsUnLock()
				dbSelectArea("cCtb390CT7")
				dbSkip()
				lInclui	:= .F.
				If oObj <> Nil
					oObj:IncRegua2(STR0034) //"Atualizando Saldos da tabela CT7..."
				Endif
			EndDo
		EndIf
	Next
	If ( Select ( "cCtb390CT7" ) <> 0 )
		dbSelectArea ( "cCtb390CT7" )
		dbCloseArea ()
	Endif
EndIf

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CT390GrSld³ Autor ³ Simone Mie Sato       ³ Data ³ 15/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina para geracao de saldos atraves do menu da rotina.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CT390GrSld()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geracao de saldos atraves da chamada do menu da rotina.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  														  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CT390GrSld()
                     
Local aSaveArea	:= GetArea()
Local lX3Aprova		:= .F.
Local lX3STATSL	:= .F.

#IFDEF TOP
	Local cChave	:= ""
	Local cFilSal	:= ""	    
	Local cOrderBy	:= ""
	Local cQuery	:= ""
	Local cWhere	:= ""
	Local cZeraOrc	:= ""
	Local nMin		:= 0
	Local nMax		:= 0
	Local nCountReg	:= 0	
	Local cKeyOrcAnt := ""
#ENDIF	

If GetMV("MV_ORCAPRV") == "S"
	lX3Aprova := .T.
Endif

dbSelectArea("CV2")
lX3STATSL := FieldPos("CV2_STATSL") > 0

#IFDEF TOP
	If TcSrvType() != "AS/400" 		
		If !Pergunte("CTB391", .T.)			
			Pergunte("CTB390", .F.)
			Return .F.
		Endif
	
		DbClearFil()
		
		DbSelectArea("CV1")
		DbSetOrder(1)
	
		//Verifica a filial do CV1.
		If Empty(xFilial("CV1"))
			cFilSal := Space(2)
		Else
			cFilSal := cFilAnt
		Endif
	
		//Monta query do CV1
		Ctb390Qry(cFilSal,,,,,.T.)
	
		dbSelectArea ( "cSelOrc" )
		
		While !Eof()
			If lX3STATSL
				If cKeyOrcAnt <> cSelOrc->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA)
					If CV2->(dbSeek(cSelOrc->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA),.F.))
						RecLock("CV2",.F.)
						Field->CV2_STATSL := "1"
						CV2->(MsUnlock())
						cKeyOrcAnt := cSelOrc->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA)
					EndIf
				EndIf
			EndIf
			//O segundo parametro eh passado com 1 => soma
			Ctb390Atu("cSelOrc","1")
			dbSelectArea("cSelOrc")
			dbSkip()
		EndDo
		
		If ( Select ( "cSelOrc" ) <> 0 )
			dbSelectArea ( "cSelOrc" )
			dbCloseArea ()
		Endif
		//Atualiza o flag do orcamento.
		cZeraOrc := "cZeraOrc"
		
		cWhere := "WHERE CV1_FILIAL = '"+cFilSal+"' AND "
		cWhere += " CV1_ORCMTO >= '"+ mv_par01 + "' AND CV1_ORCMTO <= '" + mv_par02 + "' AND  "
		cWhere += " CV1_CALEND >= '"+ mv_par03 + "' AND CV1_CALEND <= '" + mv_par04 + "' AND  "
		cWhere += " CV1_MOEDA  >= '"+ mv_par05 + "' AND CV1_MOEDA  <= '" + mv_par06 + "' AND  "
		cWhere += " CV1_REVISA >= '"+ mv_par07 + "' AND CV1_REVISA <= '" + mv_par08 + "' AND  "
		
		If lX3Aprova
			cWhere += " CV1_APROVA <> '' AND "
		Endif
		
		cWhere += " CV1_STATUS = '1'  AND " //// ALTERADO PARA ATENDER A EXPRESSAO DE INDICE 1
		cWhere += " D_E_L_E_T_ = ' ' "
		
		cQuery := "SELECT R_E_C_N_O_ RECNO "
		cQuery += "FROM "+RetSqlName("CV1")+"  "
		cQuery += cWhere
		cOrderBy	:= 	" ORDER BY RECNO "	
		cQuery		+= cOrderBy
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cZeraOrc" ) <> 0 )
			dbSelectArea ( "cZeraOrc" )
			dbCloseArea ()
		Endif
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cZeraOrc,.T.,.F.)		
		              
		//Atualiza o flag
		cQuery := "UPDATE "
		cQuery += RetSqlName("CV1")+" "
		cQuery += "SET CV1_STATUS = '2'"
		If !lX3Aprova
			cQuery += ",CV1_APROVA = '"+cUserName+"' "
		Endif
		cQuery += cWhere
		
		While cZeraOrc->(!Eof())
	
			nMin := (cZeraOrc)->RECNO
			
			nCountReg := 0
				
			While cZeraOrc->(!EOF()) .and. nCountReg <= 4096
			
				nMax := (cZeraOrc)->RECNO
				nCountReg++
				cZeraOrc->(DbSkip())

			End
				
			cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
			TcSqlExec(cQuery+cChave)
					
			cZeraOrc->(DbSkip())
			
		End		
	
		dbCloseArea()
		dbSelectArea("CV1")
		
		//// TRATAMENTO PARA ATUALIZAÇÃO DO FLAG DE GERACAO DE SALDOS NO CV2
		cQuery := "SELECT R_E_C_N_O_ RECNO "
		cQuery += "FROM "+RetSqlName("CV2")+"  "
		
		cWhereCV2 := " WHERE CV2_FILIAL = '"+cFilSal+"' AND "
		cWhereCV2 += " CV2_ORCMTO BETWEEN '"+ mv_par01 + "' AND '" + mv_par02 + "' AND  "
		cWhereCV2 += " CV2_CALEND BETWEEN '"+ mv_par03 + "' AND '" + mv_par04 + "' AND  "
		cWhereCV2 += " CV2_MOEDA  BETWEEN '"+ mv_par05 + "' AND '" + mv_par06 + "' AND  "
		cWhereCV2 += " CV2_REVISA BETWEEN '"+ mv_par07 + "' AND '" + mv_par08 + "' AND  "
		If lX3Aprova
			cWhereCV2 += "  CV2_APROVA <> '' AND "
		Endif
		cWhereCV2 += "  CV2_STATUS = '1'  AND " //// ALTERADO PARA ATENDER A EXPRESSAO DE INDICE 1
		cWhereCV2 += "  D_E_L_E_T_ = ' ' "
		cQuery += cWhereCV2
		
		cOrderBy	:= 	" ORDER BY RECNO "	
		cQuery		+= cOrderBy
		cQuery := ChangeQuery(cQuery)
		
		If ( Select ( "cZeraOrc" ) <> 0 )
			dbSelectArea ( "cZeraOrc" )
			dbCloseArea ()
		Endif
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cZeraOrc,.T.,.F.)
		
		
		//Atualiza o flag no CV2
		cQuery := " UPDATE "+RetSqlName("CV2")
		cQuery += " SET CV2_STATUS = '2' "
		If !lX3Aprova
			cQuery += ",CV2_APROVA = '"+cUserName+"' "
		Endif
		cQuery += cWhereCV2
		
		While cZeraOrc->(!Eof())
	
			nMin := (cZeraOrc)->RECNO
			
			nCountReg := 0
				
			While cZeraOrc->(!Eof()) .and. nCountReg <= 4096
			
				nMax := (cZeraOrc)->RECNO
				nCountReg++
				cZeraOrc->(DbSkip())

			End
				
			cChave := " AND R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
			TcSqlExec(cQuery+cChave)
			
 			cZeraOrc->(DbSkip())
		
		End
	
		If l390SLSQL 						/// PE APOS A GERACAO DE SALDO E GRAVACAO DO STATUS NO ORCAMENTO
			ExecBlock("CT390SLSQL", .F., .F.,{cWhere})
		Endif	
		
		Pergunte("CTB390", .F.)
	Else
#ENDIF
	Ctb390Sal(.F.,.F.)
	If l390SLCDX 						/// PE APOS A GERACAO DE SALDO E GRAVACAO DO STATUS NO ORCAMENTO
		ExecBlock("CT390SLCDX", .F., .F.)
	Endif	
#IFDEF TOP
	EndIf
#ENDIF

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB390SlOn³ Autor ³ Simone Mie Sato       ³ Data ³ 16/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para atualizacao de saldos on-line.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390SlOn()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Disponibilizar os valores orcados  para  os  balancetes  e ³±±
±±³          ³ demonstrativos contabeis                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOpcx =Indica qual a opcao.								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB390SlOn(nOpcX,nValorAnt,nValor,lRevisao,lAltValor)

Local aSaveArea	:= GetArea()

DEFAULT nValorAnt	:= 0
DEFAULT nValor		:= 0

If GetNewPar("MV_ATUSLON",.T.)			/// DESLIGA ATUALIZAÇÃO DE SALDO ON-LINE ORCAMENTO
	
	//Se for exclusao ou alteracao de lancamento contabil.
	If (nOpcX == 5 .Or.nOpcX == 4 .Or. (nOpcX == 3 .And. lRevisao)) .And. nValorAnt <> 0
		//If (nOpcX == 5 .Or.nOpcX == 4 .Or. (nOpcX == 3 .And. lRevisao)) .And. lAltValor
		//O segundo parametro eh passado com 2 => subtracao
		Ctb390Atu("CV1","2",,nValorAnt,nOpcX,lAltValor)
	EndIf
	
	//O segundo parametro eh passado com 1 => soma
	If (nOpcX = 3 .Or. (nOpcX == 4 .And. !TMP->CV1_FLAG)) .And. nValor <> 0
		Ctb390Atu("TMP","1",,,nOpcX,lAltValor)
	EndIf

EndIf

RestArea(aSaveArea)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb390Recn³ Autor ³ Simone Mie Sato       ³ Data ³ 22/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para saber o numero de entidades do intervalo.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390Recn()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTB390Recn(cArquivo,cEntidIni,cEntidFim,cCampo)

Local aSaveArea	:= GetArea()
Local nTotReg	:= 0

#IFDEF TOP
	Local cQuery	:= ""
#ENDIF	

#IFDEF TOP
	If TcSrvType() != "AS/400" 		
		c390Recn:= "c390Recn"
		cQuery	:= "SELECT COUNT(*) TOTAL "
		cQuery	+= "FROM "+RetSqlName(cArquivo)+" "
		cQuery  += "WHERE "+cArquivo+"_FILIAL = '"+xFilial(cArquivo)+"' AND "
		cQuery  += cCampo + " >= '" + cEntidIni + "' AND "
		cQuery  += cCampo + " <= '" + cEntidFim + "' AND "
		cQuery  += cArquivo+"_CLASSE = '2' AND "
		cQuery	+= " D_E_L_E_T_ =' '"
		cQuery  := ChangeQuery(cQuery)
		
		If ( Select ( "c390Recn" ) <> 0 )
			dbSelectArea ( "c390Recn" )
			dbCloseArea ()
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),c390Recn,.T.,.F.)
		
		nTotReg	:= (c390Recn)->TOTAL
		dbCloseArea()
	Else	
#ENDIF
	
	dbSelectArea(cArquivo)
	dbSetOrder(1)
	MsSeek(xFilial(cArquivo)+cEntidIni,.T.)
	
	While !Eof() .And. &(cCampo) <= cEntidFim
		nTotReg ++
		dbSkip()
	End
#IFDEF TOP
	EndIf	
#ENDIF

If nTotReg == 0
	nTotReg	:= 1
EndIf

RestArea(aSaveArea)
Return(nTotReg)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTB390xN  ºAutor  ³Marcos S. Lobo      º Data ³  07/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Aplica Taxa/Valor/Formula sobre o valor do orcamento        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Rotina de Orcamentos SIGACTB                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ctb390xN(nSeqORC,aColsP)

Local axNArea := GetArea()
Local nOrdTMP := TMP->(IndexOrd())
Local nRecTMP := TMP->(Recno())

Local nxNValor	:= 0
Local cxNTipo 	:= STR0039 //"1=Percentual;2=Multiplicação;3=Formula"
Local axNTIPO	:= {}//{ {"1","Percentual"},{"2","Multiplicação"},{"3","Formula"} }
Local cxNAPLIC	:= STR0040 //"1=Linha;2=Tudo"
Local axNAPLIC	:= {}//{ {"1,Linha"},{"2","Tudo"} }
Local nCont

Private oDlgxN,oValor,oCboTipo,oFormula,oCboAplic
Public cxNFML	:= GetNewPar("MV_CTB390F","VALOR*1.1")+SPACE(128)

aArray1	:= RetSx3Box(cxNTipo,,,1)
For nCont := 1 To Len(aArray1)
	AADD(axNTIPO,aArray1[nCont][1])
Next nCont

aArray1	:= RetSx3Box(cxNAPLIC,,,1)
For nCont := 1 To Len(aArray1)
	AADD(axNAPLIC,aArray1[nCont][1])
Next nCont

cxNTIPO		:= "1"
cxNAPLIC	:= "1"

DEFAULT aColsP		:= aColsP										/// ARRAY DE PERIODOS E VALORES
DEFAULT nSeqORC 	:= Val(TMP->CV1_SEQUEN)							/// POSICAO ATUAL NO ARRAY DE PERIODOS (SEQUENCIA DO ORÇAMENTO)

Public VALOR := 0
DEFINE MSDIALOG oDlgxN TITLE STR0038 From 0,0 to 115,450 of oMainWnd PIXEL//"Multiplica por - <F5>"
@ 008,005 	SAY STR0041 FONT Of oDlgxN PIXEL //"Fator"
@ 005,040 	MSGET oValor VAR nxNValor Of oDlgxN PIXEL Picture PesqPict("CV1","CV1_VALOR")
@ 020,005 	SAY STR0042 FONT Of oDlgxN PIXEL //"Usando"
@ 018,040 	MSCOMBOBOX oCboTipo VAR cxNTipo ITEMS axNTipo SIZE 45,10 OF oDlgxN PIXEL VALID If(cxNTipo$"123",.T.,.F.)
oCboTipo:bChange:= {|| xN390Fml(cxNTipo)}
@ 032,005 	SAY STR0043 FONT Of oDlgxN PIXEL //"Aplicar a"
@ 030,040 	MSCOMBOBOX oCboAplic VAR cxNAPLIC ITEMS axNAPLIC SIZE 45,10 OF oDlgxN PIXEL VALID If(cxNAPLIC$"12",.T.,.F.)
@ 044,005 	SAY STR0044 FONT Of oDlgxN PIXEL //"Formula:"
@ 042,040 	MSGET oFormula VAR cxNFML Of oDlgxN PIXEL Picture "@S" SIZE 180,10 F3 "SM4FML" VALID A370VerFor() .and. !Empty(cxNFML) .and. VALTYPE(&(cxNFML)) == "N"
oFormula:Disable()

oBtn1 				:= SBUTTON():Create(oDlgxN)
oBtn1:cName			:= "oBtn1"
oBtn1:cCaption		:= "&Ok"
//oBtn1:cMsg 			:= "O|"
oBtn1:nLeft 		:= 300
oBtn1:nTop 			:= 035
oBtn1:nWidth 		:= 52
oBtn1:nHeight 		:= 22
oBtn1:lShowHint  	:= .F.
oBtn1:lReadOnly		:= .F.
oBtn1:Align 		:= 0
oBtn1:lVisibleControl := .T.
oBtn1:nType 		:= 1
oBtn1:bAction 		:= {|| xn390Mult(nSeqOrc,aColsP,nxNValor,cxNTipo,cxNFML,cxNAPLIC) }

oBtn2 				:= SBUTTON():Create(oDlgxN)
oBtn2:cName			:= "oBtn2"
//oBtn2:cCaption		:= "X"
//oBtn2:cMsg 			:= "Cancelar"
oBtn2:nLeft 		:= 370
oBtn2:nTop 			:= 035
oBtn2:nWidth 		:= 52
oBtn2:nHeight 		:= 22
oBtn2:lShowHint  	:= .F.
oBtn2:lReadOnly		:= .F.
oBtn2:Align 		:= 0
oBtn2:lVisibleControl := .T.
oBtn2:nType 		:= 2
oBtn2:bAction 		:= {|| oDlgxN:End() }

ACTIVATE MSDIALOG oDlgxN CENTERED


TMP->(dbSetOrder(nOrdTMP))
TMP->(MsGoTo(nRecTMP))
RestArea(axNArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xN390Fml  ºAutor  ³Marcos S. Lobo      º Data ³  07/18/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Refresh de objetos na tela de Multiplicacao do Orcamento    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Rotina de Orcamentos SIGACTB                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function xN390Fml(cxNTipo)
If cxNTipo == "3"
	oValor:Disable()
	oFormula:Enable()
	oFormula:SetFocus()
	oDlgxN:Refresh()
Else
	oFormula:Disable()
	oValor:Enable()
	oDlgxN:Refresh()
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xn390Mult ºAutor  ³Marcos S. Lobo      º Data ³  07/18/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetiva a multiplicacao configurada em tela no orcamento    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Rotina de Orcamento SIGACTB                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function xn390Mult(nSeqOrc,aColsP,nxNValor,cxNTipo,cxNFML,cxNAPLIC)

Local ni

If !cxNTipo$"123"
	MsgInfo(STR0042+" ?")
	oCboTipo:SetFocus()
	Return
Endif

If !cxNAPLIC$"12"
	MsgInfo(STR0043+" ?")
	oCboAPLIC:SetFocus()
	Return
Endif

If cxNTIPO <> "3"					//// SE NÃO FOR ATRAVÉS DE FORMULA
	If nxnValor == 0
		MsgInfo(STR0041+" ?")
		oValor:SetFocus()
		Return
	Endif
	If cxNAPLIC == "1"
		For nI := 1 to Len(aColsP[nSEQORC])
			If cxNTIPO == "1"
				aColsP[nSEQORC][nI][4] += aColsP[nSEQORC][nI][4] * (nxnValor/100)
			Else
				aColsP[nSEQORC][nI][4] := aColsP[nSEQORC][nI][4] * nxnValor
			Endif
		Next
	Else
		dbSelectArea("TMP")
		TMP->(dbGoTop())
		nLINTMP := 1
		While !Eof()
			For nI := 1 to Len(aColsP[nLINTMP])
				If cxNTIPO == "1"
					aColsP[nLINTMP][nI][4] += aColsP[nLINTMP][nI][4] * (nxnValor/100)
				Else
					aColsP[nLINTMP][nI][4] := aColsP[nLINTMP][nI][4] * nxNValor
				Endif
			Next
			TMP->(dbSkip())
			nLINTMP++
		Enddo
	Endif
ElseIf cxNTIPO == "3" 					//// SE USAR O TIPO FORMULA
	If cxNAPLIC == "1"
		For nI := 1 to Len(aColsP[nSEQORC])
			VALOR := aColsP[nSEQORC][nI][4]
			aColsP[nSEQORC][nI][4] := &(cxNFML)
		Next
	Else
		dbSelectArea("TMP")
		TMP->(dbGoTop())
		nLINTMP := 1
		While !Eof()
			For nI := 1 to Len(aColsP[nLINTMP])
				VALOR := aColsP[nLINTMP][nI][4]
				aColsP[nLINTMP][nI][4] := &(cxNFML)
			Next
			TMP->(dbSkip())
			nLINTMP++
		Enddo
	Endif
Endif

oDlgxN:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA390   ºAutor  ³Microsiga           º Data ³  09/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ct390OnChg(oPeriodo, oOrcado, oVlrOrc, nOrc,oTotOrc,nTotOrc,cPictVal,lExecChg)
IF lExecChg
	Ctb390CarCal(VAL(TMP->CV1_SEQUEN), oPeriodo)
	CTB390DspOrc(oOrcado,oVlrOrc,@nOrc,oTotOrc,@nTotOrc)
	oPeriodo:SetArray(aColsP[Val(TMP->CV1_SEQUEN)])
	oPeriodo:bLine := { ||{ aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,1],aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,2],aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,3],Trans(aColsP[Val(TMP->CV1_SEQUEN)][oPeriodo:nAt,4], cPictVal) } }
	oPeriodo:Refresh()
	lExecChg := .T.
Endif
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Aj390Leg  ºAutor  ³Marcos S. Lobo      º Data ³  12/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para ajustar a legenda atualizando o campo CV2_STATSLº±±
±±º          ³que contem o flag de processmto. pela rotina de ger de saldoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Aj390Leg()

If !MsgYesNo("Prosseguir com a Atualização do Flag. Geração de Saldo ?","Atualização CV2_STATSL - Orçamento SIGACTB")
	Return
EndIf

Processa({|| ProcLeg390(.T.) },"Atualização Flag.Ger.Saldo - Orçamento")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcLeg390ºAutor  ³Marcos S. Lobo      º Data ³  12/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina chamada para atualizacao do campo CV2_STATSL         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - CTBA390 - Aj390Leg                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ProcLeg390(lRegua)

Local nLidos	:= 0
Local nGerados	:= 0
Local cKeyCV1	:= ""

DEFAULT lRegua	:= .F.

dbSelectArea("CV2")
If FieldPos("CV2_STATSL") <= 0
	MsgInfo("Crie o campo CV2_STATSL (caracter 1 em uso) !","Antes de executar a rotina...")
	Return
EndIf

If lRegua
	ProcRegua(RecCount())
EndIf

dbSelectArea("CV2")
dbGoTop()
While CV2->(!Eof())
	If lRegua
		IncProc()
	EndIf
	If CV2->CV2_STATUS <> "1"
		CV2->(dbSkip())
		Loop
	EndIf

	nLidos		:= 0
	nGerados	:= 0

	cKeyCV1 := CV2->(CV2_FILIAL+CV2_ORCMTO+CV2_CALEND+CV2_MOEDA+CV2_REVISA)
	dbSelectArea("CV1")
	dbSetOrder(1)
	If dbSeek(cKeyCV1,.F.)
		While CV1->(!Eof()) .and. CV1->(CV1_FILIAL+CV1_ORCMTO+CV1_CALEND+CV1_MOEDA+CV1_REVISA) == cKeyCV1
			nLidos++
			If CV1->CV1_STATUS == "2"
				nGerados++
			EndIf
			CV1->(dbSkip())
		EndDo	
		
		If nLidos <> nGerados .and. nGerados <> 0
			RecLock("CV2",.F.)
			Field->CV2_STATSL := "1"
			CV2->(MsUnlock())
		EndIf		
	EndIf

	dbSelectArea("CV2")
	dbSkip()
EndDo

MsgInfo("Atualização CV2_STATSL Ok !","Fim da Atualização")

Return
