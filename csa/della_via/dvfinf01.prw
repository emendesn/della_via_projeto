#include "DellaVia.ch"

/*
Programa: DVFINF01 - Função chamada pelo PE SACI008 para efetuar a transferencia no momento da baixa.
Autor   : Denis Francisco Tofoli
Data    : 08/06/2006
*/

User Function DVFINF01()
	Local cBcoOrig	  := CriaVar("E5_BANCO")
	Local cBcoDest	  := CriaVar("E5_BANCO")
	Local cAgenOrig   := CriaVar("E5_AGENCIA")
	Local cAgenDest   := CriaVar("E5_AGENCIA")
	Local cCtaOrig	  := CriaVar("E5_CONTA")
	Local cCtaDest	  := CriaVar("E5_CONTA")
	Local cNaturOri   := CriaVar("E5_NATUREZ")
	Local cNaturDes   := CriaVar("E5_NATUREZ")
	Local cDocTran    := CriaVar("E5_NUMCHEQ")
	Local cHist100    := CriaVar("E5_HISTOR")
	Local nValorTran  := 0
	Local nOpcA       := 0
	Local cBenef100   := Space(30)
	Local aValores    := {}
	Local lGrava      := .F.
	Local lSpbInUse   := SpbInUse()
	Local aModalSPB	  := {"1=TED","2=CIP","3=COMP"}
	Local aTrfPms     := {}
	Local lEstorno    := .F.
	Local nA,cMoedaTx
	Local oDlg
	Local oModSpb
	Local cModSpb
	Local oBcoOrig
	Local oBcoDest

	Private nTotal    := 0
	Private cTipoTran := Space(3)

	/*
	Deleta a Ocorrencia "EST" no SX5 para forçar o usuario a utilizar a
	OPCAO Estorno para que o saldo bancario seja tratado corretamente
	*/
	dbSelectArea("SX5")
	If dbSeek(xFilial()+"14"+"EST")
		if Reclock("SX5")
			dbDelete()
			MsUnlock()
		Endif
	Endif


	// Verifica se data do movimento não é menor que data limite de movimentacao no financeiro
	If !DtMovFin()
		Return
	Endif

	While .T.
		dbSelectArea("SE5")
		cBcoOrig	:= CriaVar("E5_BANCO")
		cBcoOrig    := SE5->E5_BANCO
		cBcoDest	:= CriaVar("E5_BANCO")
		cAgenOrig   := CriaVar("E5_AGENCIA")
		cAgenOrig   := SE5->E5_AGENCIA
		cAgenDest   := CriaVar("E5_AGENCIA")
		cCtaOrig	:= CriaVar("E5_CONTA")
		cCtaOrig	:= SE5->E5_CONTA
		cCtaDest	:= CriaVar("E5_CONTA")
		cNaturOri   := CriaVar("E5_NATUREZ")
		cNaturDes   := CriaVar("E5_NATUREZ")
		cDocTran    := CriaVar("E5_NUMCHEQ")
		cHist100    := CriaVar("E5_HISTOR")
		nValorTran  := SE5->E5_VALOR
		cBenef100   := Space(30)
		cTipoTran   := CriaVar("E5_MOEDA")
		If lSpbInUse
			cModSpb := "1"
		Endif
		nOpcA := 0

		// Recebe dados a serem digitados
		If lSpbInUse
			DEFINE MSDIALOG oDlg FROM 032,113 TO 416,517 TITLE OemToAnsi("Movimentação Bancária") PIXEL
		Else
			DEFINE MSDIALOG oDlg FROM 032,113 TO 356,517 TITLE OemToAnsi("Movimentação Bancária") PIXEL
		Endif

		@ 006,004 TO 036,165 OF oDlg PIXEL
		@ 044,004 TO 074,165 OF oDlg PIXEL
		@ 085,004 TO 159,165 OF oDlg PIXEL

		@ 001,004 SAY OemToAnsi("Origem")        SIZE 025,007 OF oDlg PIXEL
		@ 013,008 SAY OemToAnsi("Banco")         SIZE 019,007 OF oDlg PIXEL
		@ 013,036 SAY OemToAnsi("Agência")       SIZE 025,007 OF oDlg PIXEL
		@ 013,115 SAY OemToAnsi("Natureza")      SIZE 028,007 OF oDlg PIXEL
		@ 013,065 SAY OemToAnsi("Conta")         SIZE 020,007 OF oDlg PIXEL
		@ 040,004 SAY OemToAnsi("Destino")       SIZE 025,007 OF oDlg PIXEL
		@ 052,008 SAY OemToAnsi("Banco")         SIZE 023,007 OF oDlg PIXEL
		@ 052,036 SAY OemToAnsi("Agência")       SIZE 027,007 OF oDlg PIXEL
		@ 052,065 SAY OemToAnsi("Conta")         SIZE 018,007 OF oDlg PIXEL
		@ 052,115 SAY OemToAnsi("Natureza")      SIZE 028,007 OF oDlg PIXEL
		@ 079,004 SAY OemToAnsi("Identificação") SIZE 041,007 OF oDlg PIXEL
		@ 093,008 SAY OemToAnsi("Tipo Mov.")     SIZE 031,007 OF oDlg PIXEL
		@ 093,042 SAY OemToAnsi("Número Doc.")   SIZE 043,007 OF oDlg PIXEL
		@ 093,099 SAY OemToAnsi("Valor")         SIZE 017,007 OF oDlg PIXEL
		@ 115,009 SAY OemToAnsi("Histórico")     SIZE 028,007 OF oDlg PIXEL
		@ 136,009 SAY OemToAnsi("Beneficiário")  SIZE 040,007 OF oDlg PIXEL

		@ 022,009 GET cBcoOrig   SIZE 010,010 F3 "SA6" Picture "@S3" Valid CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.) OBJECT oBcoOrig When .F.
		@ 022,036 GET cAgenOrig  SIZE 020,010 Picture "@S5" Valid CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.) When .F.
		@ 022,065 GET cCtaOrig   SIZE 045,010 Picture "@S10" Valid If(CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.T.),.T.,oBcoOrig:SetFocus()) When .F.
		@ 022,115 GET cNaturOri  SIZE 030,010 F3 "SED" Valid ExistCpo("SED",@cNaturOri)
		@ 060,009 GET cBcoDest   SIZE 010,010 F3 "SA6" Picture "@S3"  Valid CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.) OBJECT oBcoDest
		@ 060,036 GET cAgenDest  SIZE 020,010 Picture "@S5" Valid CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.)
		@ 060,065 GET cCtaDest   SIZE 045,010 Picture "@S10" Valid IF(CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.,@cBenef100,.T.) .and. ( cBcoDest != cBcoOrig .or. cAgenDest != cAgenOrig .or.	cCtaDest != cCtaOrig),.T.,oBcoDest:SetFocus())
		@ 060,115 GET cNaturDes  SIZE 030,010 F3 "SED" Valid ExistCpo("SED",@cNaturDes)
		@ 102,009 GET cTipoTran  SIZE 015,010 F3 "14"  Picture "!!!"  Valid (!Empty(cTipoTran) .And. ExistCpo("SX5","14"+cTipoTran)) .and. Iif(cTipoTran="CH",fa050Cheque(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran),.T.)
		@ 102,042 GET cDocTran   SIZE 047,010 Picture PesqPict("SE5", "E5_NUMCHEQ") Valid !Empty(cDocTran).and.fa100doc(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran)
		@ 102,099 GET nValorTran SIZE 054,010 Picture PesqPict("SE5","E5_VALOR",15) Valid nValorTran > 0
		@ 123,009 GET cHist100   SIZE 144,010 Picture "@S22" Valid !Empty(cHist100)
		@ 144,009 GET cBenef100  SIZE 144,010 Picture "@S21" Valid !Empty(cBenef100)

		If lSpbInUse
			@ 162,004 TO 188,165 OF oDlg PIXEL
			@ 165,009 SAY "Modalidade SPB" SIZE 060,007 OF oDlg PIXEL
			@ 173,009 COMBOBOX cModSpb ITEMS aModalSpb SIZE 056,047 OF oDlg PIXEL VALID SpbTipo("SE5",cModSpb,cTipoTran,"TR") OBJECT oModSPB
		Endif

		@ 010,168 BMPBUTTON TYPE 1 ACTION (nOpca:=1,oDLg:End())
		@ 023,168 BMPBUTTON TYPE 2 ACTION (nOpca:=0,oDlg:End())

		If IntePms()
			aTrfPms := {CriaVar("E5_PROJPMS"),CriaVar("E5_TASKPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_EDTPMS"),CriaVar("E5_TASKPMS")}
			@ 036,168 BUTTON "Projetos..." SIZE 29 ,14   ACTION {||F100PmsTrf(aTrfPms)	}
		EndIf

		ACTIVATE MSDIALOG oDlg CENTERED VALID  (iif(nOpca==1, CarregaSa6(cBcoOrig,cAgenOrig,cCtaOrig,.T.,,.T.) .and. ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )

		IF nOpcA == 1
			Begin Transaction
				lGrava := .T.
				If ExistBlock("FA100TRF")
					lGrava := ExecBlock("FA100TRF", .F., .F., { cBcoOrig, cAgenOrig, cCtaOrig, cBcoDest, cAgenDest, cCtaDest, cTipoTran, cDocTran, nValorTran, cHist100, cBenef100,cNaturOri, cNaturDes , cModSpb, lEstorno})
				Endif
				IF lGrava
					fa100grava( cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri, cBcoDest,cAgenDest,cCtaDest,cNaturDes, cTipoTran,cDocTran,nValorTran,cHist100,cBenef100,,cModSpb,aTrfPms)
				ENDIF		
			End Transaction
			If ExistBlock("A100BL01")
				aValores := {cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest, cCtaDest,cNaturDes,cTipoTran,nValorTran,cDocTran,cBenef100,cHist100,cModSpb}
				ExecBlock("A100BL01",.F.,.F.,aValores)
			EndIf
		Endif
		Exit
	Enddo
Return

Static Function fa100grava(cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest,cCtaDest,cNaturDes,cTipoTran,cDocTran,nValorTran,cHist100,cBenef100,lEstorno,cModSpb,aTrfPms)
	Local lPadrao1  := .F.
	Local lPadrao2  := .F.
	Local cPadrao   := "560"
	Local lA100TR01	:= ExistBlock("A100TR01")
	Local lA100TR02	:= ExistBlock("A100TR02")
	Local lA100TR03	:= ExistBlock("A100TR03")
	Local nRegSEF   := 0
	Local nMoedOrig := 1
	Local nMoedTran	:=	1
	Local lSpbInUse	:= SpbInUse()
	Local lMostra,lAglutina
	lEstorno := IIF (lEstorno == NIL , .F., lEstorno)

	DEFAULT aTrfPms	 := {}
	DEFAULT lExterno := .F.

	STRLCTPAD := " "

	If !(Empty(cBcoOrig+cAgenOrig+cCtaOrig))
		/*
		Atencao!, neste programa será utilizado 2 lançamentos padronizados,
		pois o mesmo gera 2 registros na movimentacao bancaria
		1. registro para a saida  (Banco Origem ) ->Padrao "560"
		2. registro para a entrada(Banco Destino) ->Padrao "561"
		*/
		dbSelectArea( "SA6" )
		dbSeek( cFilial + cBcoOrig + cAgenOrig + cCtaOrig )

		// Atualiza movimentacao bancaria c/ referencia a saida
		if Reclock("SE5",.T.)
			SE5->E5_FILIAL  := xFilial()
			SE5->E5_DATA	:= dDataBase
			SE5->E5_BANCO	:= cBcoOrig
			SE5->E5_AGENCIA := cAgenOrig
			SE5->E5_CONTA	:= cCtaOrig
			SE5->E5_RECPAG  := "P"
			SE5->E5_NUMCHEQ := cDocTran
			SE5->E5_HISTOR  := cHist100
			SE5->E5_TIPODOC := "TR"
			SE5->E5_MOEDA	:= cTipoTran
			SE5->E5_VALOR   := nValorTran
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_BENEF   := cBenef100
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_NATUREZ := cNaturOri
			SE5->E5_FILORIG := cFilAnt
			If lSpbInUse
				SE5->E5_MODSPB := cModSpb
			Endif
			MsUnLock()
		Endif

		If !Empty(aTrfPms) .And. !Empty(aTrfPms[1])
			nRecNo := SE5->(RecNo())
			cID	   := STRZERO(SE5->(RecNo()),10)
			cStart := "AA"
	 		dbSelectArea("SE5")
			dbSetOrder(9)
			While dbSeek(xFilial()+cID)
				cID    := STRZERO(nRecNo,8)+cStart
	 			cStart := SomaIt(cStart)
	 		End
			SE5->(dbGoto(nRecNo))
			if RecLock("SE5",.F.)
				SE5->E5_PROJPMS	:= cId
				MsUnlock()
			Endif
			if RecLock("AJE",.T.)
				AJE->AJE_FILIAL := xFilial("AJE")
				AJE->AJE_VALOR 	:= SE5->E5_VALOR
				AJE->AJE_DATA	:= SE5->E5_DATA
				AJE->AJE_HISTOR	:= SE5->E5_HISTOR
				AJE->AJE_PROJET	:= aTrfPms[1]
				AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[1])
				AJE->AJE_TAREFA	:= aTrfPms[2]
				AJE->AJE_ID		:= cID
				MsUnlock()
			Endif
		EndIf
		If (Alltrim(cTipoTran) == "TB" .or. (Alltrim(cTipoTran) == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. !lEstorno
			nRegSEF := Fa100Cheq("FINA100TRF")
		Endif

		If lA100TR01
			ExecBlock("A100TR01",.F.,.F.,lEstorno)
		EndIf

		/*
		Só atualiza do saldo se for R$,DO,TB,TC ou se for CH e o banco
		origem não for um caixa do loja, pois este foi gerado no SE1
		e somente sera atualizado na baixa do titulo.
		Aclaracao: Foi incluido o tipo $ para os movimentos em dinheiro
		em QUALQUER moeda, pois o R$ nao e representativo fora do BRASIL.
		Bruno 07/12/2000 Paraguai
		*/
		If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ")) .or. (SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. !(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
			/*
			Atualiza saldo bancario.
			Passo o E5_VALOR pois fora do Brasil a conta pode ser em moeda
			diferente da moea Oficial.
			*/
			AtuSalBco(cBcoOrig,cAgenOrig,cCtaOrig,dDataBase,SE5->E5_VALOR,"-")
		Endif

		If !lExterno
			// Lançamento Contabil - 1. registro do SE5
			lPadrao1  := VerPadrao(cPadrao)
			STRLCTPAD := cBcoDest+"/"+cAgenDest+"/"+cCtaDest
			IF lPadrao1 .and. mv_par04 == 1
				nHdlPrv:=HeadProva(cLote,"FINA100",Substr(cUsuario,7,6),@cArquivo)
			Endif

			IF lPadrao1 .and. mv_par04 == 1
				nTotal+=DetProva(nHdlPrv,cPadrao,"FINA100",cLote)
			Endif

			IF lPadrao1 .and. mv_par04 == 1  // On Line
				if Reclock("SE5")
					Replace E5_LA With "S"
					MsUnlock()
				Endif
			EndIf

			/*
			Conforme situação do parâmetro abaixo, integra com o SIGAGSP
			MV_SIGAGSP - 0-Não / 1-Integra
			e-mail de Fernando Mazzarolo de 08/11/2004
			*/
			If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
				GSPF380(3) 
			EndIf
		Endif
	Endif

	If !(Empty(cBcoDest+cAgenDest+cCtaDest))
		// Atualiza movimentacao bancaria c/ referencia a entrada
		dbSelectArea( "SA6" )
		dbSeek( cFilial + cBcoDest + cAgenDest + cCtaDest )
		if Reclock("SE5",.T.)
			SE5->E5_FILIAL  := xFilial()
			SE5->E5_DATA    := dDataBase
			SE5->E5_BANCO   := cBcoDest
			SE5->E5_AGENCIA := cAgenDest
			SE5->E5_CONTA   := cCtaDest
			SE5->E5_RECPAG  := "R"
			SE5->E5_DOCUMEN := cDocTran
			SE5->E5_HISTOR  := cHist100
			SE5->E5_TIPODOC := "TR"
			SE5->E5_MOEDA   := cTipoTran
			If cPaisLoc == "BRA"
				SE5->E5_VALOR := nValorTran
			Else
				SE5->E5_VALOR := IIf(lEstorno,nValorTran,Round(xMoeda(nValorTran,nMoedOrig,Max(SA6->A6_MOEDA,1),dDataBase,MsDecimais(Max(SA6->A6_MOEDA,1))+1,aTxMoedas[nMoedOrig][2],aTxMoedas[Max(SA6->A6_MOEDA,1)][2]),MsDecimais(Max(SA6->A6_MOEDA,1))))
				/*
				Gravo o valor na moeda 1 para nao ter problemas na hora da conversao por casas
				decimais perdidas na contabilidade... Bruno.
				*/
				SE5->E5_VLMOED2 := IIf(lEstorno,xMoeda(nValorTran,Max(SA6->A6_MOEDA,1),1,,,nTxEstR),xMoeda(nValorTran,nMoedOrig,1,,,aTxMoedas[nMoedOrig][2]))
			Endif
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_BENEF   := cBenef100
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_NATUREZ := cNaturDes
			SE5->E5_FILORIG := cFilAnt
			If (SE5->(FieldPos("E5_TXMOEDA")) > 0) .And. (cPaisLoc <> "BRA")
				E5_TXMOEDA := If( lEstorno, nTxEstR, aTxMoedas[nMoedTran][2] )
			Endif
			If lSpbInUse
				SE5->E5_MODSPB := cModSpb
			Endif
			MsUnLock()
		Endif
		If !Empty(aTrfPms) .And. !Empty(aTrfPms[3])
			nRecNo := SE5->(RecNo())
			cID    := STRZERO(SE5->(RecNo()),10)
			cStart := "AA"
			dbSelectArea("SE5")
			dbSetOrder(9)
			While dbSeek(xFilial()+cID)
				cID    := STRZERO(nRecNo,8)+cStart
				cStart := SomaIt(cStart)
			End
			SE5->(dbGoto(nRecNo))
			if RecLock("SE5",.F.)
				SE5->E5_PROJPMS	:= cId
				MsUnlock()
			Endif
			if RecLock("AJE",.T.)
				AJE->AJE_FILIAL := xFilial("AJE")
				AJE->AJE_VALOR 	:= SE5->E5_VALOR
				AJE->AJE_DATA	:= SE5->E5_DATA
				AJE->AJE_HISTOR	:= SE5->E5_HISTOR
				AJE->AJE_PROJET	:= aTrfPms[3]
				AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[3])
				AJE->AJE_EDT	:= aTrfPms[4]
				AJE->AJE_TAREFA	:= aTrfPms[5]
				AJE->AJE_ID		:= cID
				MsUnlock()
			Endif
		EndIf

		If lA100TR02
			ExecBlock("A100TR02",.F.,.F.,lEstorno)
		EndIf

		/*
		So atualiza do saldo se for R$,DO,TB,TC ou se for CH e o banco
		origem não for um caixa do loja, pois este foi gerado no SE1 e
		somente sera atualizado na baixa do titulo.
		O teste do caixa ‚ exatamente para o banco origem Mesmo.
		Aclaracao: Foi incluido o tipo $ para os movimentos em dinheiro
		em QUALQUER moeda, pois o R$ nao e representativo fora do BRASIL.
		Bruno 07/12/2000 Paraguai
		*/
		If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ") ) .or. (SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. !(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
			/*
			Atualiza saldo bancario.
			Paso o E5_VALOR pois fora do Brasil a conta pode ser em moeda
			diferente da moea Oficial.
			*/
			AtuSalBco(cBcoDest,cAgenDest,cCtaDest,dDataBase,SE5->E5_VALOR,"+")
		Endif

		If !lExterno
			// Lançamento Contabil - 2. registro do SE5
			cPadrao :="561"
			lPadrao2:=VerPadrao(cPadrao)
			STRLCTPAD := cBcoOrig+"/"+cAgenOrig+"/"+cCtaOrig
			IF lPadrao2 .and. !lPadrao1 .and. mv_par04 == 1
				nHdlPrv:=HeadProva(cLote,"FINA100",Substr(cUsuario,7,6),@cArquivo)
			Endif

			IF lPadrao2 .and. mv_par04 == 1
				nTotal+=DetProva(nHdlPrv,cPadrao,"FINA100",cLote)
			Endif

			IF ( lPadrao1 .or. lPadrao2) .and. mv_par04 == 1
				RodaProva(nHdlPrv,nTotal)
				lAglutina := Iif(mv_par01==1,.T.,.F.)
				lMostra   := Iif(mv_par02==1,.T.,.F.)

				// Envia para Lancamento Contabil
				cA100Incl(cArquivo,nHdlPrv,3,cLote,lMostra,lAglutina)
				If lPadrao1 .and. nRegSEF > 0
					/*
					Se contabilizou a Saida, e Foi uma TB  / CH, então
					marca no cheque que já foi contabilizado.
					*/
					DbSelectArea("SEF")
					DbGoto(nRegSEF)
					if Reclock("SEF")
						SEF->EF_LA := "S"
						MsUnlock()
					Endif
				Endif
			Endif
			/*
			Conforme situação do parâmetro abaixo, integra com o SIGAGSP ³
			MV_SIGAGSP - 0-Não / 1-Integra
			e-mail de Fernando Mazzarolo de 08/11/2004
			*/
			If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
				GSPF380(4)
			EndIf
		Endif
	Endif

	If lA100TR03
		ExecBlock("A100TR03",.F.,.F.,lEstorno)
	EndIf

	IF !lExterno .and. lPadrao2 .and. mv_par04 == 1  // On Line
		if Reclock("SE5")
			Replace E5_LA With "S"
			MsUnlock()
		Endif
	EndIf
Return