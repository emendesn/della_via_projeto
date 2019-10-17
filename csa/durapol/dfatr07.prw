#Include "MSOLE.CH"
#Include "RWMAKE.CH"
#Include "FONT.CH"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)
#Define CRLF        Chr(13)+Chr(10)
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DFATR07  ºAutor  ³ Jader              º Data ³ 23/08/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de Carta de SEPU                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFATR07()
	Private aRegs     := {}
	Private cPerg     := "FATR07"
	Private cCadastro := "Emissao de Carta de SEPU"
	Private aRotina   := {}
	Private lWord     := .F. // .T. - Imprime Carta .DOT       .F. - Imprime carta em relatório
	
	
	aadd(aRotina,{"Pesquisa" ,"AxPesqui"     ,0,1})
	if lWord
		aadd(aRotina,{"Visualiza","U_DFATR07A(1)",0,2})
	Endif
	aadd(aRotina,{"Imprime"  ,"U_DFATR07A(2)",0,4})

	// Cria grupo de perguntas e chama pergunte
	aRegs := {}
	AAdd(aRegs,{cPerg,"01","Responsavel?" ,"Responsavel?" ,"Responsavel?" ,"mv_ch1","C",30,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aRegs,{cPerg,"02","Cargo?"       ,"Cargo?"       ,"Cargo?"       ,"mv_ch2","C",30,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

	ValidPerg(aRegs,cPerg)

	Pergunte(cPerg,.T.)

	dbSelectArea("SC2")
	dbSetOrder(1)
	dbGotop()
	If Bof() .Or. Eof()
		MsgBox("Atencao... Nao existem dados no arquivo")
		Return(.F.)
	Endif

	MBrowse(,,,,"SC2",,,,,,,,)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFATR07A  ºAutor  ³ Jader              º Data ³ 23/08/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenchimento das variaveis do Word e impressao            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFATR07A(nOpc)
	Local dDataEmi
	Local cOP
	Local HandleWord
	Local cArqDot := "CARTA-SEPU.DOT" //Nome do Arquivo MODELO do Word

	// PATH DO ARQUIVO MODELO WORD NO SERVIDOR CONFIGURAR PATH ABAIXO DO ROOTPATH PROTHEUS E INFORMAR NO PARAMETRO
	Local cPathDot:= Alltrim(GetMv("MV_PATWORD")) + cArqDot

	Private nTotPed := 0
	Private nCntLin := 0
	Private nCntCol := 0

	// PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO, POR EXEMPLO --> C:\WORDTMP\ ou C:\RELATO\
	Private cPathEst:= Alltrim(GetMv("MV_PATTERM"))

	//PATH ONDE ESTA INSTALADO O WORDVIEW.EXE PODE TER LETRA DO DRIVE
	Private cPathView := Alltrim(GetMv("MV_PATVIEW"))



	cDataEmi := DtExten(Month(dDataBase))
	cOP      := SC2->C2_NUM

	dbSelectArea("SF1")
	dbSetOrder(1)
	MsSeek(xFilial("SF1") + SC2->C2_NUMD1  + SC2->C2_SERIED1 + SC2->C2_FORNECE + SC2->C2_LOJA )

	dbSelectArea("SA1")
	dbSetOrder(1)
	//MsSeek(xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA )  //WGU
	MsSeek(xFilial("SA1") + SC2->C2_FORNECE + SC2->C2_LOJA )

	// Busca motivo da rejeicao/aprovacao
	dbSelectArea("SZS")
	dbSetOrder(1)
	dbSeek(xFilial("SZS")+SC2->C2_XMREDIR)
	_cMReDir := Alltrim(SZS->ZS_DESCR)

	//_cStatus := U_StatSEPU(SZS->ZS_TIPO)      //WGU
	_cStatus := IF(SZS->ZS_APROVA=="S","APROVADO","REPROVADO")


	if lWord
		//Verifica a existencia do DOT no ROOTPATH Protheus Servidor
		If !File(cPathDot)
			MsgBox(cArqDot+" nao encontrado no Servidor")
			Return NIL
		EndIf

		/*
		If File( cPathEst + cArqDot )
			// Caso encontre arquivo ja gerado na estacao com o mesmo nome,
			// apaga primeiramente antes de gerar a nova impressao.
			fErase( cPathEst + cArqDot ) WGU
		EndIf
		*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Criando link de comunicacao com o word                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		HandleWord := OLE_CreateLink()

		//CpyS2T(cPathDot,cPathEst,.T.)    WGU

		/*
		Copia do Server para o Remote, eh necessario para que o wordview e o proprio word
		possam preparar o arquivo para impressao e ou visualizacao .... 
		copia o DOT que esta no ROOTPATH Protheus para o PATH da estacao , por exemplo C:\WORDTMP
		*/

		// Cria novo arquivo no Word na estacao
		//OLE_NewFile( HandleWord, "C:\PROTHEUS\WORD\CARTA-SEPU.DOT")
		OLE_NewFile( HandleWord, cPathEst + cArqDot) //WGU

		// Salva o arquivo com o novo nome na estacao
		//OLE_SaveAsFile( HandleWord, "C:\PROTHEUS\WORD\" + "OP" + cOP + ".DOT", , , .F., oleWdFormatDocument )
		OLE_SaveAsFile( HandleWord, cPathEst + "OP" + cOP + ".DOT", , , .F., oleWdFormatDocument ) //WGU

		// Preenche emissao
		OLE_SetDocumentVar(HandleWord, "EMISSAO"    ,cDataEmi) // Emissao

		// Preenche dados do cliente
		// Verificar nomes de variaveis no .DOT via Word ... atraves da tecla ALT+F9
		OLE_SetDocumentVar(HandleWord, "A1_NOME"   ,SA1->A1_NOME)
		OLE_SetDocumentVar(HandleWord, "A1_MUN"    ,SA1->A1_MUN)
		OLE_SetDocumentVar(HandleWord, "A1_EST"    ,SA1->A1_EST)
		OLE_SetDocumentVar(HandleWord, "C2_NUM"    ,SC2->C2_NUM)

		// Preenche dados do pneu
		// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
		OLE_SetDocumentVar(HandleWord, "C2_PRODUTO"    ,SC2->C2_PRODUTO)  // Medida
		OLE_SetDocumentVar(HandleWord, "C2_NUMFOGO"    ,SC2->C2_NUMFOGO)  // Fogo
		OLE_SetDocumentVar(HandleWord, "C2_SERIEPN"    ,SC2->C2_SERIEPN)  // Serie
		OLE_SetDocumentVar(HandleWord, "C2_MARCAPN"    ,SC2->C2_MARCAPN)  // Marca

		// Preenche exame do Pneu
		// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
		OLE_SetDocumentVar(HandleWord, "C2_XMREDIR"    ,_cMReDir)  // motivo rejeicao/aprovacao
		OLE_SetDocumentVar(HandleWord, "STATUS"        ,_cStatus)  // status rejeicao/aprovacao
		OLE_SetDocumentVar(HandleWord, "C2_XCOBS3"     ,MSMM(SC2->C2_XCOBS3,,,,3))  // observacao
		OLE_SetDocumentVar(HandleWord, "C2_XVALAPR"    ,Transform(SC2->C2_XVALAPR,"@E 999,999.99"))  // valor aprovado

		// Preenche assinatura
		// Atraves da Macro gravada no documento .DOT - Ver em Word / Tool / Macros / Edit
		OLE_SetDocumentVar(HandleWord, "RESPONSAVEL"    ,PADC(Alltrim(mv_par01),30))  // responsavel
		OLE_SetDocumentVar(HandleWord, "CARGO"          ,PADC(Alltrim(mv_par02),30))  // cargo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizando as variaveis do documento do Word                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_UpdateFields(HandleWord)

		//OLE_SaveAsFile( HandleWord, cPathEst + "OP" + cOP + ".DOC", , , .F., oleWdFormatDocument )
		OLE_SaveAsFile( HandleWord, "C:\PROTHEUS\WORD\"  + "OP" + cOP + ".DOC", , , .F., oleWdFormatDocument )

		If nOpc == 1 // Visualiza
			Ole_CloseFile(HandleWord)  
			lTemExeView := .T.
			If File(cPathView+"WORDVIEW.EXE")  //WGU
			//if File("C:\PROTHEUS\OFFICE11\WORDVIEW.EXE")
				WordView := cPathView + "WORDVIEW " + cPathEst + "OP" + cOP + ".DOC"   //WGU
				//WordView := "C:\PROTHEUS\OFFICE11\WORDVIEW " + "C:\PROTHEUS\WORD\OP" + cOP + ".DOC"
			Else
				MsgBox("Atencao... WordView.Exe nao encontrado em seu equipamento verifique !!!")
				lTemExeView := .F.
			EndIf
			If lTemExeView
				WaitRun( WordView )
			Endif
		Else //Imprime
			Ole_PrintFile(HandleWord,"ALL",,,1) // Imprime o carta
			Inkey(2)
			Ole_CloseFile(HandleWord)
		EndIf                                       

		//MsgBox("Impressao realizada...!!!")

		// Fecha link com o Word
		Ole_CloseLink(HandleWord)

		If File(cPathEst + "OP" + cOP + ".DOT")     //WGU
			fErase(cPathEst + "OP" + cOP + ".DOT")  //WGU
		EndIf                                       //WGU
	Else
		RelCarta()
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DtExten  ºAutor  ³ Jader              º Data ³ 23/08/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para retornar a data por extenso                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DtExten(nMes)
	Local aMesExtenso := {}
	Local cMes := ""

	AAdd(aMesExtenso," de Janeiro de ")
	AAdd(aMesExtenso," de Fevereiro de ")
	AAdd(aMesExtenso," de Marco de ")
	AAdd(aMesExtenso," de Abril de ")
	AAdd(aMesExtenso," de Maio de ")
	AAdd(aMesExtenso," de Junho de ")
	AAdd(aMesExtenso," de Julho de ")
	AAdd(aMesExtenso," de Agosto de ")
	AAdd(aMesExtenso," de Setembro de ")
	AAdd(aMesExtenso," de Outubro de ")
	AAdd(aMesExtenso," de Novembro de ")
	AAdd(aMesExtenso," de Dezembro de ")

	cMes    := aMesExtenso[nMes]
	dDataEmi := Capital(AllTrim(SM0->M0_CIDENT))+", " + StrZero(Day(ddatabase),2,0) + cMes + Str(Year(dDataBase),4,0)
Return(dDataEmi)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ StatSEPU ºAutor  ³ Jader              º Data ³ 23/08/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para o status do motivo do SEPU                     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function StatSEPU(_cTipo)
	Local _cStatus := ""

	If _cTipo == "1"
		_cStatus := "BONIFICACAO DE PNEU RECLAMADO"
	ElseIf _cTipo == "2"
		_cStatus := "BONIFICACAO CONSERTO"
	ElseIf _cTipo == "3"
		_cStatus := "BONIFICACAO COMERCIAL"
	ElseIf _cTipo == "4"
		_cStatus := "CREDITOS DIVERSOS"
	ElseIf _cTipo == "5"
		_cStatus := "RECUSADO"
	ElseIf _cTipo == "6"
	    _cStatus := "BONIFICACAO CUPOM PIRELLI"
	Endif
Return(_cStatus)


Static Function RelCarta()
	Private cString        := ""
	Private aOrd           := {}
	Private cDesc1         := ""
	Private cDesc2         := ""
	Private cDesc3         := ""
	Private tamanho        := "M"
	Private nomeprog       := "DFATR07"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := nil
	Private titulo         := "Durapol Recapagem"
	Private Li             := 132
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR07"
	Private lImp           := .f.

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
	   Return
	Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return nil

Static Function RunReport()
	aObs := {}
	cObs := ""

	cObs := StrTran(MSMM(SZS->ZS_CODOBS,,,,3),CRLF," ")

	nLidos := 0
	Do While nLidos < Len(cObs)
		aadd(aObs,Substr(cObs,1+nLidos,100))
		nLidos += 100
	Enddo
	
	if Len(aObs) = 0
		aadd(aObs,"")
	Endif

	LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
	LI++

    @ LI,000 PSAY PosTxt(cDataEmi,130,2)
    LI+=2
	@ LI,000 PSAY "A" ;LI++
	@ LI,000 PSAY SA1->A1_NOME ;LI++
	@ LI,000 PSAY AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
	LI+=2
	@ LI,000 PSAY "Coleta Nr. "+SC2->C2_NUM
	LI+=3


	@ LI,000 PSAY " -------------------------------------------------------------------------------------------------------------------------------" ;LI++
	@ LI,000 PSAY "|"+   PosTxt("Medida",31,1)     +"|"+PosTxt("Numero de Fogo",31,1)+"|"+     PosTxt("Série",31,1)    +"|"+    PosTxt("Marca",31,1)     +"|" ;LI++
	@ LI,000 PSAY "|-------------------------------+-------------------------------+-------------------------------+-------------------------------|" ;LI++
	@ LI,000 PSAY "|                               |                               |                               |                               |" ;LI++
	@ LI,000 PSAY "|"+PosTxt(SC2->C2_PRODUTO,31,1) +"|"+PosTxt(SC2->C2_NUMFOGO,31,1) +"|"+PosTxt(SC2->C2_SERIEPN,31,1) +"|"+PosTxt(SC2->C2_MARCAPN,31,1) +"|" ;LI++
	@ LI,000 PSAY "|                               |                               |                               |                               |" ;LI++
	@ LI,000 PSAY " -------------------------------------------------------------------------------------------------------------------------------"
	LI+=3

	@ LI,000 PSAY "Exame:"
	LI++
	@ LI,000 PSAY " -------------------------------------------------------------------------------------------------------------------------------" ;LI++
	@ LI,000 PSAY "| Motivo          | "+ PosTxt(_cMReDir,107,3)                                                                                   +"|" ;LI++
	@ LI,000 PSAY "|-----------------+-------------------------------------------------------------------------------------------------------------|" ;LI++
	@ LI,000 PSAY "| Status          | "+ PosTxt(_cStatus,107,3)                                                                                   +"|" ;LI++
	@ LI,000 PSAY "|-----------------+-------------------------------------------------------------------------------------------------------------|" ;LI++
	@ LI,000 PSAY "| Observação      | "+ PosTxt(aObs[1],107,3)                                                                                    +"|" ;LI++
	For k=2 to Len(aObs)
		@ LI,000 PSAY "|                 | "+ PosTxt(aObs[k],107,3)                                                                                    +"|" ;LI++
	Next k
	@ LI,000 PSAY "|-----------------+-------------------------------------------------------------------------------------------------------------|" ;LI++
	@ LI,000 PSAY "| Valor Desconto  | "+ PosTxt("R$ "+AllTrim(Transform(SC2->C2_XVALAPR,"@E 999,999.99")),107,3)                                  +"|" ;LI++
	@ LI,000 PSAY " -------------------------------------------------------------------------------------------------------------------------------"
    LI+=3


    LI:=49
    @ LI,000 PSAY PosTxt(Replicate("_",Len(AllTrim(mv_par01))*1.2),130,2); LI++
    @ LI,000 PSAY PosTxt(Capital(AllTrim(mv_par01)),130,2); LI++
    @ LI,000 PSAY PosTxt(Capital(AllTrim(mv_par02)),130,2)
    LI+=3

	@ LI,000 PSAY IniFatLine+FimFatLine ;LI++
	@ LI,000 PSAY PosTxt(AllTrim(SM0->M0_ENDENT) + " " +;
	              AllTrim(SM0->M0_BAIRENT) + " CEP " +;
	              Substr(SM0->M0_CEPENT,1,5)+ "-" + Substr(SM0->M0_CEPENT,6,3) + " " +;
	              AllTrim(SM0->M0_CIDENT) + " - " + AllTrim(SM0->M0_ESTENT),132,1); LI++

	@ LI,000 PSAY PosTxt("Tel " + AllTrim(SM0->M0_TEL) + " - Fax " +;
	              AllTrim(SM0->M0_FAX) + " e-mail: durapol@dellavia.com.br",132,1)


	roda(0,"",Tamanho)
	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

Static Function PosTxt(cTxt,nTmh,nSet)
	Local cRet := ""
	cTxt := AllTrim(cTxt)

	If nSet = 1
		cRet := Space(int(nTmh-(Len(cTxt)-1))/2)+cTxt+Space(int(nTmh-Len(cTxt))/2)
	Elseif nSet = 2
		cRet := Space(nTmh-(Len(cTxt)-1))+cTxt
	Elseif nSet = 3
		cRet := cTxt+Space(nTmh-(Len(cTxt)-1))
	Endif
Return cRet