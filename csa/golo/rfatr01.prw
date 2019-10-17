#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR01  ºAutor  ³ Jairo Oliveira     º Data ³  25/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de impressao de notas fiscais de entrada e saida,   º±±
±±º          ³ especificamente para o cliente DELLA VIA                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterações³ 27/05/06 Alterado para permitir reimpressao de notas do diaº±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RFATR01(cNFIni, cNFFim, cSerieNF, nTpNf)
                                               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao de variaveis            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private CbTxt     := ""
Private CbCont    := ""
Private nordem    := 0
Private cTamanho  := "G"
Private nLimite   := 220
Private cTitulo   := PADC("Nota Fiscal",74)
Private cDesc1    := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
Private cDesc2    := ""
Private cDesc3    := ""
Private aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
Private cNomeprog := "RFATR01"
Private cPerg     := "RFAR01"
Private nLastKey  := 0
Private lContinua := .T.
Private nLin      := 0
Private wnrel     := "RFATR01"                                                                               
Private cString   := "SF2"
Private nLoop1
Private nLoop2
Private nLoop3
Private nTamDet  := 15         // Tamanho da Area de Detalhe Produtos
Private nTamDet2 := 5          // Tamanho da Area de Detalhe Servicos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros do relatorio:             ³
//³mv_par01: numero da nota inicial     ³
//³mv_par02: numero da nota final       ³
//³mv_par03: serie das notas fiscais    ³
//³mv_par04: notas de entrada ou saida ?³
//³mv_par05: número do selo             ³
//³mv_par06: série do selo              ³
//³mv_par07: data de saída              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as perguntas selecionadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se eh uma impressao automatica     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cNFIni <> Nil .and. cNFFim <> Nil .and. cSerieNf <> Nil .and. nTpNf <> Nil
	MV_PAR01	:= cNfIni
	MV_PAR02	:= cNfFim
	MV_PAR03	:= cSerieNF
	MV_PAR04	:= nTpNf
//	Pergunte(cPerg,.f.) // Marcio
	cPerg		:= ""   // Marcio
Else
	Pergunte(cPerg,.F.)	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia controle para a funcao SETPRINT³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.f.)

If nLastKey == 27
	Return
Endif

//aReturn[5] := 3
//aReturn[6] := "LPT1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica Posicao do Formulario na Impressora³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RptDetail()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a impressao dos boletos bancarios   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR04 == 2 .and. aReturn[5] <> 1
	U_RFATR01(MV_PAR03, MV_PAR01, MV_PAR02)
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RptDetail ºAutor  ³ Octavio Moreira    º Data ³  03/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que efetivamente trata da impressao da nota fiscal. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RptDetail()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes das variaveis da funcao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nUltNf			:= CriaVar("F2_DOC",.F.)
Local nX					:= 0
Local lEncNfAtiva    := .F.
Local aAreaSF2			:= {}
Local lPrimeira		:= .T.
Local cQuery			:= " "
Private cPedAnt,cSerNFi,cNumNFi,dDatEmi,nTotFat,nTotFat,cCodCli,cLojCli,nTotFre,nTotDsp,nTotSeg,nBasICM,nBasIPI,nBasRet,nTotICM
Private nTotICR,nPesLto,nTotIPI,nTotMer,cNumDup,cConPag,cDesCon,nPesBru,nPesLiq,cTipNFi,cEmbEsp,nEmbVol,cPreNFi,aNumPed
Private aPedUni,aItePed,aNumNFD,aPreNFD,aPerICM,aCodPro,aQtdPro,aPreUni,aPreTab,aPerIPI,aValIPI,aPerDes,aValDes,aValMer
Private aCodTES,aCodFOp,aBasICR,aValICM,aPesPro,aPesUni,aDesPro,aUniPro,aCodTri,aClaFis,aPerISS,aTipPro,aMarLuc,aPedCli
Private aPedClu,aPedDes,aIteDes,aTexTES,aSitTri,aResCFO,aCodMen,aMenMan,aTipFre,nPBrPed,nPLqPed,cNomCli,cEndCli,cBaiCli
Private cCEPCli,cCobCli,cEntCli,cMunCli,cEstCli,cCGCCli,cInsCli,cTraCli,cTelCli,cFaxCli,cSUFRAM,lZonFra,cNomTra,cEndTra
Private cMunTra,cEstTra,cViaTra,cCGCTra,cInsTra,cTelTra,aParDup,aVenDup,aValDup,aPosIPI,aMenPro,cMenPro,nFormul,nForAtu
Private aQtdSeg,aMoeDup,aValDes,nValDes,nSemRed,aSemRed,nFreMot,aISSIte,cInscrM,nValISS,cPlaCam,cUFCami,cNumSelo
Private _nBaseIcmsRet, _nValIcmsRet, _nValIcmsDev, _aProd, nValSer, aIteNFs, aIteSrv, _cVendedores, aTES

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona os arquivos para os loops³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par04 == 2
   
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.) // doc + serie

	While !Eof() .And. SF2->F2_DOC <= mv_par02 .And. SF2->F2_FILIAL == xFilial("SF2") 
		//
		// Se ja foi impressa e estiver direto na porta bloqueia impressao
		If SF2->F2_FIMP=="S" .and. aReturn[5] == 3
        //   if SF2->F2_EMISSAO <> dDataBase // by Golo
              Aviso("Alerta","A Nota Fiscal ["+SF2->F2_DOC+"-"+SF2->F2_SERIE+"] ja foi impressa, caso deseja reimprimi-la favor contactar o suporte Della Via",{"OK"},1,"")
              Return
        //   endif   by Golo
		Endif
        DbSkip()
        //
    Enddo
	dbSeek(xFilial()+mv_par01+mv_par03,.t.) // doc + serie
    //

	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetorder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)

	cPedant := SD2->D2_PEDIDO

	dbSelectArea("SF2")
Else

	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.) // doc + serie
	
	While !Eof() .And. SF1->F1_DOC <= mv_par02 .And. SF1->F1_FILIAL == xFilial("SF1") 
		//
		// Se ja foi impressa e estiver direto na porta bloqueia impressao
		If SF1->F1_FIMP=="S" .and. aReturn[5] == 3
           Aviso("Alerta","A Nota Fiscal ["+SF1->F1_DOC+"-"+SF1->F1_SERIE+"] ja foi impressa, caso deseja reimprimi-la favor contactar o suporte Della Via",{"OK"},1,"")
           Return 
		Endif
        DbSkip()
        //
    Enddo
	dbSeek(xFilial()+mv_par01+mv_par03,.t.) // doc + serie
    //

	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetorder(1)
	dbSeek(xFilial()+mv_par01+mv_par03)

    DbSelectArea("SF1")
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona arquivos auxiliares³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SB5")
dbSetOrder(1)

dbSelectArea("SA1")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)

dbSelectArea("SA4")
dbSetOrder(1)

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SC6")
dbSetOrder(1)

dbSelectArea("DA3")
dbSetOrder(1)

dbSelectArea("DAK")
dbSetOrder(1)

dbSelectArea("SE1")
dbSetOrder(1)

dbSelectArea("SE4")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa regua de impressao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Val(mv_par02)-Val(mv_par01))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos caracteres de controle³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ nLin, 000 PSAY chr(27) + "@" + chr(27) + "P" + chr(27) + "0"  + Chr(15) // 1/8 polegada e comprime

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trata nota de saida³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cNumSelo	:=AllTrim(mv_par05)

If mv_par04 == 2
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia loop do cabecalho de notas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	While !Eof() .And. SF2->F2_DOC <= mv_par02 .And. lContinua .And. SF2->F2_FILIAL == xFilial("SF2") 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Desconsidera notas com serie diferentes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF2->F2_SERIE <> mv_par03
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Desconsidera notas com serie diferentes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Alltrim(upper(SF2->F2_ESPECIE)) == "CF"
		    Alert("Esta Nota e sobre Cupom, verifique!")
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se houve cancelamento pelo usuario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara os campos do cabecalho da nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNumNFi     := SF2->F2_DOC             // Numero
		cSerNFi     := SF2->F2_SERIE           // Serie
		cCodCli     := SF2->F2_CLIENTE         // Codigo do cliente
		cLojCli     := SF2->F2_LOJA            // Loja do Cliente
		dDatEmi     := SF2->F2_EMISSAO         // Data de Emissao
	    nTotFat     := SF2->F2_VALBRUT          // Valor Total da Fatura
		nTotFat     := If(nTotFat==0,SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE,nTotFat)
		nTotFre     := SF2->F2_FRETE           // Frete
		nTotSeg     := SF2->F2_SEGURO          // Seguro
		nTotDsp		:= SF2->F2_DESPESA			// Despesa
		nBasICM     := SF2->F2_BASEICM         // Base do ICMS
		nBasIPI     := SF2->F2_BASEIPI         // Base do IPI
		nBasRet 	:= SF2->F2_BRICMS          // Base do ICMS retido
		nTotICM     := SF2->F2_VALICM          // Valor  do ICMS
		nTotICR     := SF2->F2_ICMSRET         // Valor  do ICMS Retido
		nTotIPI     := SF2->F2_VALIPI          // Valor  do IPI
		nTotMer     := SF2->F2_VALMERC         // Valor  da Mercadoria
		cNumDup     := SF2->F2_DUPL
		cConPag     := SF2->F2_COND            // Condicao de Pagamento
		cDesCon		:= Iif(!Empty(cConPag),Iif(SE4->(dbSeek(xFilial("SE4")+cConPag)),SE4->E4_DESCRI,""),"")
		nPesBru     := 0					          // Peso Bruto
		nPesLiq     := 0					          // Peso Liquido
		cTipNFi     := SF2->F2_TIPO            // Tipo da nota fiscal
		cEmbEsp     := SF2->F2_ESPECI1         // Especie 1 no Pedido
		nEmbVol     := SF2->F2_VOLUME1         // Volume 1 no Pedido
		cPreNFi		:= SF2->F2_PREFIXO
		nPesLto     := 0                       // Peso liquido calculado pela soma dos pesos dos itens
		nValDes     := SF2->F2_DESCONT			// Desconto total
		nSemRed		:= 0						// Valor total das mercadorias sem a reducao de base de ICMS
		nFreMot		:= 0//SF2->F2_FRETMOT			// Valor total do frete do motorista
		nValISS		:= SF2->F2_VALISS			// Valor total do ISS da nota fiscal
        nValSer     := 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca placa do caminhao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF2->F2_CARGA)
			dbSelectArea("DAK")
			dbSeek(xFilial("DAK")+SF2->F2_CARGA)
			
			If !Eof()
				dbSelectArea("DA3")
				dbSeek(xFilial("DA3")+DAK->DAK_CAMINH)
				
				cPlaCam := DA3->DA3_PLACA
				cUFCami := "  "
			Else
				cPlaCam := Space(8)
				cUFCami := "  "
			EndIf
		Else
			cPlaCam := Space(8)
			cUFCami := "  "
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Levanta informacoes dos itens das notas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD2")
		dbSetorder(3)
		dbSeek(xFilial("SD2")+cNumNFi+cSerNFi)
		
		aNumPed     := {}                         // Numero do Pedido de Venda
		aPedUni		:= {}                         // Numero do Pedido nao repetido
		aItePed     := {}                         // Numero do Item do Pedido de Venda
		aNumNFD     := {}                         // Numero da nota fiscal de devolucao
		aPreNFD     := {}                         // Serie  quAndo houver devolucao
		aPerICM     := {}                         // Porcentagem do ICMS
		aCodPro     := {}                         // Codigo  do Produto
		aQtdPro     := {}                         // Peso/Quantidade do Produto
		aPreUni     := {}                         // Preco Unitario de Venda
		aPreTab     := {}                         // Preco Unitario de Tabela
		aPerIPI     := {}                         // Porcentagem do IPI
		aValIPI     := {}                         // Valor do IPI
		aPerDes     := {}                         // Desconto por Item
		aValDes     := {}                         // Valor do Desconto
		aValMer     := {}                         // Valor da Mercadoria
		aCodTES     := {}                         // TES
		aCodFOp     := {}                         // Classificacao quanto natureza da Operacao
		aBasICR     := {}                         // Base do ICMS Solidario
		aValICM     := {}                         // ICMS do Produto
		aPesPro  	:= {}                         // Peso Liquido
		aPesUni		:= {}                         // Peso Unitario do Produto
		aDesPro     := {}                         // Descricao do Produto
		aUniPro   	:= {}                         // Unidade do Produto
		aCodTri  	:= {}                         // Codigo de Tributacao
		aClaFis  	:= {}                         // Classificacao Fiscal
		aPeriSS  	:= {}                         // Aliquota de ISS
		aTipPro     := {}                         // Tipo do Produto
		aMarLuc  	:= {}                         // Margem de Lucro p/ ICMS Solidario
		aPedCli		:= {}                         // Numero do pedido do cliente
		aPedClu		:= {}                         // Numero do pedido do cliente unico
		aPedDes		:= {}                         // Descricao dos produtos lancadas no pedido de vendas
		aIteDes     := {}                         // Desconto dos produtos lancados no pedido de vendas
		aResCFO     := {}                         // Resumo dos cfos na nota fiscal
		aTexTES     := {}                         // Texto do TES
		aSitTri		:= {}                         // Situacao tributaria informada no TES
		aLotPro     := {}                         // Numero do lote do produto
		aLotVen     := {}                         // Data de validade do lote do produto
		aMenPro		:= {}                         // Mensagem no produto
		aPosIPI		:= {}                         // Posicao de IPI
		aCodMen  	:= {}                         // Codigos de mensagens dos pedidos associados a nota
		aQtdSeg		:= {}                         // Quantidade da segunda unidade de medida
		aValDes		:= {}                     	  // Valor do desconto
		aSemRed		:= {}						  // Valor dos itens sem reducao da base de ICMS 
		aISSIte		:= {}						  // Itens da NF referentes a servicos
		aMenMan  	:= {}                         // Mensagens digitadas nos pedidos associados a nota
        _nBaseIcmsRet := 0.00
        _nValIcmsRet  := 0.00
        _nValIcmsDev  := 0.00
        _aProd := {}
		aTES        := {}                         // TES diferentes na NF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicia loop dos itens da nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof() .And. SD2->D2_DOC == cNumNFi .And. SD2->D2_SERIE == cSerNFi .and. SD2->D2_FILIAL == xFilial("SD2")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica serie da nota fiscal³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SD2->D2_SERIE # mv_par03 
				dbSkip()
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o produto e o TES do item³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o lote de produto        ³  //Cristian em 15/10
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SB8->(DbSetOrder(5))
			SB8->(DbSeek(xFilial("SB8")+SD2->D2_COD+SD2->D2_LOTECTL))
							
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega os campos dos itens da nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AADD(aNumPed, SD2->D2_PEDIDO)
			If aScan(aPedUni,SD2->D2_PEDIDO) == 0
				AADD(aPedUni, SD2->D2_PEDIDO)
                SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			EndIf
			AADD(aItePed, SD2->D2_ITEMPV)
			AADD(aNumNFD, SD2->D2_NFORI)
			AADD(aPreNFD, SD2->D2_SERIORI)
			AADD(aPerICM, SD2->D2_PICM)
			AADD(aCodPro, SD2->D2_COD)
			AADD(aQtdPro, SD2->D2_QUANT)
			AADD(aPreUni, SD2->D2_PRCVEN)
			AADD(aPreTab, SD2->D2_PRCVEN)
			AADD(aPerIPI, SD2->D2_IPI)
			AADD(aValIPI, SD2->D2_VALIPI)
			AADD(aPerDes, SD2->D2_DESC)
			AADD(aValMer, SD2->D2_TOTAL)
			AADD(aCodTES, SD2->D2_TES)
			AADD(aCodFOp, SD2->D2_CF)
			AADD(aLotPro, SD2->D2_LOTECTL)
			AADD(aLotVen, SB8->B8_DTVALID)
			AADD(aPesPro, SB1->B1_PESO * SD2->D2_QUANT)
			AADD(aPesUni, SB1->B1_PESO)
			AADD(aDesPro, SB1->B1_DESC)
			AADD(aUniPro, SB1->B1_UM)
			AADD(aCodTri, SB1->B1_ORIGEM)
			AADD(aClaFis, SB1->B1_CLASFIS)
			AADD(aPerISS, SB1->B1_ALIQISS)
			AADD(aTipPro, SB1->B1_TIPO)
			AADD(aMarLuc, SB1->B1_PICMRET)
			AADD(aPosIPI, SB1->B1_POSIPI)
			AADD(aSitTri, SB1->B1_ORIGEM+SF4->F4_SITTRIB)
			AADD(aQtdSeg, SD2->D2_QTSEGUM)
			AADD(aValDes, SD2->D2_DESCON)
			AADD(aISSIte, SF4->F4_ISS)
									
			If SF4->F4_BASEICM <> 0 .And. SD2->D2_PICM <> 0
				AADD(aSemRed, Round((SD2->D2_TOTAL-SD2->D2_VALICM) / (1-SD2->D2_PICM/100),2))
				nSemRed += aSemRed[Len(aSemRed)] - SD2->D2_TOTAL
			Else
				AADD(aSemRed, SD2->D2_TOTAL)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca mensagens do TES³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SF4->F4_MSG1) .And. aScan(aCodMen,SF4->F4_MSG1) == 0
				AADD(aCodMen, SF4->F4_MSG1) // MENPAD1
			EndIf

/*			
			If !Empty(SF4->F4_MSG2) .And. aScan(aCodMen,SF4->F4_MSG2) == 0
				AADD(aCodMen, SF4->F4_MSG2)
			EndIf

			If !Empty(SF4->F4_MSG3) .And. aScan(aCodMen,SF4->F4_MSG3) == 0
				AADD(aCodMen, SF4->F4_MSG3)
			EndIf

			If !Empty(SF4->F4_MSG4) .And. aScan(aCodMen,SF4->F4_MSG4) == 0
				AADD(aCodMen, SF4->F4_MSG4)
			EndIf

			If !Empty(SF4->F4_MSG5) .And. aScan(aCodMen,SF4->F4_MSG5) == 0
				AADD(aCodMen, SF4->F4_MSG5)
			EndIf

			If !Empty(SF4->F4_MSG6) .And. aScan(aCodMen,SF4->F4_MSG6) == 0
				AADD(aCodMen, SF4->F4_MSG6)
			EndIf
*/
            // Trata Artigo 274 do RICMS - Cliente Substituido com imposto Retido
            If SD2->D2_TES $ Alltrim(GetMV('MV_TESSUBS',,'503/'))
               If Ascan(_aProd, SD2->D2_COD)==0
                  aadd(_aProd, SD2->D2_COD)
                  SelUltCompra(SD2->D2_COD, SD2->D2_QUANT, @_nBaseIcmsRet, @_nValIcmsRet, @_nValIcmsDev)
               Endif
            Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta resumo de cfos da NF³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aResCFO,SD2->D2_CF) == 0
				AADD(aResCFO, SD2->D2_CF)
				AADD(aTexTES, SF4->F4_TEXTO)
				AADD(aTES, SD2->D2_TES)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca dados dos itens do pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ:Ù
			If SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
				AADD(aPedCli, SC6->C6_PEDCLI)
				AADD(aPedDes, SC6->C6_DESCRI)
				AADD(aIteDes, SC6->C6_VALDESC)
				
				If aScan(aPedClu, SC6->C6_PEDCLI) == 0
					AADD(aPedClu, SC6->C6_PEDCLI)
				EndIf
			Else
				AADD(aPedCli, "")
				AADD(aPedDes, "")
				AADD(aIteDes, 0)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Acumula o peso total³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPesLiq	+= aPesPro[Len(aPesPro)]
			nPesBru += SB1->B1_PESBRU * SD2->D2_QUANT
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Vai para o proximo item de nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD2")
			dbSkip()
			
		Enddo
		
        //If _nBaseIcmsRet > 0 .and. _nValIcmsRet > 0
        If _nValIcmsRet > 0
           AADD(aMenMan, 'Bas.Calc.ICMS Ret Prop Fab.: '+Transform(_nBaseIcmsRet, '@E 9,999,999.99')+'                        .')
           AADD(aMenMan, 'ICMS Retido Fase Anterior  : '+Transform(_nValIcmsRet , '@E 9,999,999.99')+'                        .')
           AADD(aMenMan, 'ICMS Devido Prop.Natureza  : '+Transform(_nValIcmsDev , '@E 9,999,999.99')+'                        .')
        Endif
                  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca informacoes dos cabecalhos de pedidos da NF³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC5")
		//aMenMan  	:= {}                         // Mensagens digitadas nos pedidos associados a nota
		aTipFre  	:= {}                         // Tipo de frete dos pedidos
		nPBrPed  	:= 0                          // Peso bruto informado nos pedidos
		nPLqPed		:= 0                          // Peso liquido informado nos pedidos
        _cVendedores := SC5->C5_VEND1  //+"/"+SC5->C5_VEND2+"/"+SC5->C5_VEND3+"/"+SC5->C5_VEND4+"/"+SC5->C5_VEND5
		
		For nLoop1 :=1 to Len(aPedUni)
			
			dbSeek(xFilial("SC5")+aPedUni[nLoop1])
			
			If aScan(aCodMen,SC5->C5_MENPAD) == 0 .And. aScan(aMenPro,SC5->C5_MENPAD) == 0
				AADD(aCodMen, SC5->C5_MENPAD)
			EndIf
			AADD(aMenMan, SC5->C5_MENNOTA)
			AADD(aTipFre, SC5->C5_TPFRETE)
			nPBrPed += SC5->C5_PBRUTO
			nPLqPed += SC5->C5_PESOL
			
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca informacoes do cadastro de clientes ou fornecedores³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipNFi $ "N/C/P/I/S/T/O"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Informacoes de clientes³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSeek(xFilial("SA1")+cCodCli+cLojCli)
			
			cNomCli 	:= Left(SA1->A1_NOME,40)   // Nome do cliente
			cEndCli 	:= Left(SA1->A1_END,40)    // Endereco
			cBaiCli 	:= Left(SA1->A1_BAIRRO,30) // Bairro
			cCEPCli 	:= SA1->A1_CEP             // CEP
			cCobCli 	:= SA1->A1_ENDCOB          // Endereco de Cobranca
			cEntCli 	:= SA1->A1_ENDENT          // Endereco de Entrega
			cMunCli 	:= Left(SA1->A1_MUN,15)    // Municipio
			cEstCli 	:= SA1->A1_EST             // Estado
			cCGCCli 	:= SA1->A1_CGC             // CGC
			cInsCli 	:= SA1->A1_INSCR           // Inscricao estadual
			cTraCli 	:= SA1->A1_TRANSP          // Transportadora
			cTelCli 	:= If(!Empty(SA1->A1_DDI),SA1->A1_DDI+" ","")
			cTelCli	    += If(!Empty(SA1->A1_DDD),SA1->A1_DDD+" ","")+SA1->A1_TEL   // Telefone
			cFaxCli 	:= SA1->A1_FAX             // Fax
			cSUFRAM 	:= SA1->A1_SUFRAMA         // Codigo Suframa
			lZonFra 	:= (!Empty(cSUFRAM) .And. SA1->A1_CALCSUF == "S")
			//cInscrM		:= SA1->A1_INSCRM			// Inscricao municipal
			cInscrM		:= Iif(getmv("MV_ESTADO")=="SP",getmv("MV_MUNIC"),"") // Inscricao municipal
			/*
			If !Empty(SA1->A1_MENPAD) .And. aScan(aCodMen,SA1->A1_MENPAD) == 0
				AADD(aCodMen, SA1->A1_MENPAD)
			EndIf
         */
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Informacoes de forncedores³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSeek(xFilial("SA2")+cCodCli+cLojCli)
			
			cNomCli 	:= Left(SA2->A2_NOME,40)   // Nome do cliente
			cEndCli 	:= Left(SA2->A2_END,40)    // Endereco
			cBaiCli 	:= Left(SA2->A2_BAIRRO,30) // Bairro
			cCEPCli 	:= SA2->A2_CEP             // CEP
			cCobCli 	:= ""                      // Endereco de Cobranca
			cEntCli 	:= ""                      // Endereco de Entrega
			cMunCli 	:= Left(SA2->A2_MUN,15)   // Municipio
			cEstCli 	:= SA2->A2_EST             // Estado
			cCGCCli 	:= SA2->A2_CGC             // CGC
			cInsCli 	:= SA2->A2_INSCR           // Inscricao estadual
			cTraCli  	:= SA2->A2_TRANSP          // Transportadora
			cTelCli 	:= If(!Empty(SA1->A1_DDI),SA1->A1_DDI+" ","")
			cTelCli		+= If(!Empty(SA1->A1_DDD),SA1->A1_DDD+" ","")+SA1->A1_TEL   // Telefone
			cFaxCli  	:= SA2->A2_FAX             // Fax
			cSUFRAM 	:= ""                      // Codigo Suframa
			lZonFra 	:= .f.
			cInscrM		:= SA2->A2_INSCRM			// Inscricao municipal
						
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca informacoes da transportadora da nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA4")
		dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
		cNomTra		:= SA4->A4_NOME           // Nome Transportadora
		cEndTra		:= SA4->A4_END            // Endereco
		cMunTra		:= SA4->A4_MUN            // Municipio
		cEstTra		:= SA4->A4_EST            // Estado
		cViaTra		:= SA4->A4_VIA            // Via de Transporte
		cCGCTra		:= SA4->A4_CGC            // CGC
		cInsTra		:= SA4->A4_INSEST         // Inscricao Estadual
		cTelTra		:= SA4->A4_TEL            // Fone
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca informacoes dos titulos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSeek(xFilial("SE1")+cPreNFi+cNumDup)
		
		aParDup		:= {}                       // Parcela
		aVenDup		:= {}                       // Vencimento
		aValDup		:= {}                       // Valor
        aMoeDup     := {}                       // Moeda
		
		While !Eof() .And. SE1->E1_NUM == cNumDup .And. cPreNFi == SE1->E1_PREFIXO .and. SE1->E1_FILIAL == xFilial("SE1")
			
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			
			AADD(aParDup, SE1->E1_PARCELA)
			AADD(aVenDup, SE1->E1_VENCTO)
		    AADD(aValDup, SE1->E1_VALOR)
			AADD(aMoeDup, Iif(!Empty(SF2->F2_DUPL),SE1->E1_MOEDA,1))         

			dbSkip()
			
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara os itens da NF, para calcular a quantidade de formularios³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aIteNFs := {}
        aIteSrv := {}
		
		For nLoop1 := 1 to Len(aCodPro)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona produtos e complementos de produtos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			MsSeek(xFilial("SB1")+aCodPro[nLoop1])

			dbSelectArea("SB5")
			MsSeek(xFilial("SB5")+aCodPro[nLoop1])
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta dados de uma linha completa³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*
			AADD(aIteNFS,{aCodPro[nLoop1],;
								If(SB5->(Found()).And.!Empty(SB5->B5_CEME),Left(SB5->B5_CEME,94),aDesPro[nLoop1]),;
						  		aPosIPI[nLoop1],;
						  		aSitTri[nLoop1],;
						  		aUniPro[nLoop1],;
						  		aQtdPro[nLoop1],;
						  		aPreUni[nLoop1],;
						  		aValMer[nLoop1]+aValDes[nLoop1],;
						  		aPerICM[nLoop1],;
						  		aPerIPI[nLoop1],;
						  		aValIPI[nLoop1],;
						  		aValDes[nLoop1],;
						  		aSemRed[nLoop1],;
						  		aISSIte[nLoop1]})
			*/
			AADD(aIteNFS,{aCodPro[nLoop1],;
			If(!Empty(aPedDes[nLoop1]),Left(aPedDes[nLoop1],94),;
				If(SB5->(Found()).And.!Empty(SB5->B5_CEME),Left(SB5->B5_CEME,94),aDesPro[nLoop1])),;
						  		aSitTri[nLoop1],;
						  		aUniPro[nLoop1],;
						  		aQtdPro[nLoop1],;
						  		aPreUni[nLoop1],;
						  		aQtdPro[nLoop1]*aPreUni[nLoop1],;
						  		aPerICM[nLoop1],;
						  		aPerIPI[nLoop1],;
						  		aValIPI[nLoop1],;
						  		aValDes[nLoop1],;
						  		aSemRed[nLoop1],;
						  		aISSIte[nLoop1],;
						  		aPerDes[nLoop1],;
						  		aClaFis[nLoop1],;
						  		aLotPro[nLoop1];
						  		})
         
         	If aIteNFs[nLoop1][13] == "S"	
 	
				AADD(aIteSrv,{aCodPro[nLoop1],;
					IIf(!Empty(aPedDes[nLoop1]),Left(aPedDes[nLoop1],94),;
					IIf(SB5->(Found()).And.!Empty(SB5->B5_CEME),Left(SB5->B5_CEME,94),aDesPro[nLoop1])),;
					aSitTri[nLoop1],;
					aUniPro[nLoop1],;
					aQtdPro[nLoop1],;
					aPreUni[nLoop1],;
					aQtdPro[nLoop1]*aPreUni[nLoop1],;
					aPerICM[nLoop1],;
					aPerIPI[nLoop1],;
					aValIPI[nLoop1],;
					aValDes[nLoop1],;
					aSemRed[nLoop1],;
					aISSIte[nLoop1],;
					aPerDes[nLoop1],;
					aClaFis[nLoop1];
					})
		
			EndIf
		Next  
			   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se deve imprimir valor do desconto no corpo da nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		If nValDes <> 0
//			AADD(aIteNFS,{"","","","","",0,0,0,0,0,0,0})
//			AADD(aIteNFS,{"","Desconto: R$"+LTrim(Transform(nValDes,"@E 9,999,999.99")),"","","",0,0,0,0,0,0,0,0})
//		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se deve imprimir desconto referente a redução de base de ICMS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		If nSemRed <> 0
//			AADD(aIteNFS,{"","","","","",0,0,0,0,0,0,0})
//			AADD(aIteNFS,{"","Desconto conforme Convenio 100/97","","","",0,0,nSemRed,0,0,0,0,nSemRed})
//		EndIf		

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Calcula a quantidade de formularios necessarios³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nFormu1 := Int((Len(aIteNFs)-Len(aIteSrv))/nTamDet  + .999999999)
        nFormu2 := Int(Len(aIteSrv)/nTamDet2 + .999999999)
        nFormul := IIf(nFormu1 > nFormu2, nFormu1, nFormu2)
						  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama funcao de impressao da nota fiscal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nForAtu := 1 to nFormul
			ImpDoc(nForAtu)
		Next

		dbSelectArea("SF2")
		If aReturn[5] == 3
           If RecLock("SF2",.F.)
              SF2->F2_FIMP := "S"
              MsUnlock()
           Endif
        Endif
		
        dbSkip()                      // passa para a proxima Nota Fiscal
		IncRegua()                    // Termometro de Impressao
		
		// Incrementa número do selo
		//cNumSelo	:= Soma1(cNumSelo, Len(cNumSelo))
		
	EndDo
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia loop do cabecalho de notas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	While !Eof() .And. SF1->F1_DOC <= mv_par02 .And. lContinua .And. SF1->F1_FILIAL == xFilial("SF1") 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Desconsidera notas com serie diferentes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF1->F1_SERIE <> mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		If SF1->F1_FORMUL <> "S"    // Se o formulario nao for proprio desconsidera
			DbSkip()                // 
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se houve cancelamento pelo usuario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara os campos do cabecalho da nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNumNFi     := SF1->F1_DOC             // Numero
		cSerNFi     := SF1->F1_SERIE           // Serie
		cCodCli     := SF1->F1_FORNECE         // Codigo do fornecedor
		cLojCli     := SF1->F1_LOJA            // Loja do fornecedor
		dDatEmi     := SF1->F1_EMISSAO         // Data de Emissao
		nTotFat     := SF1->F1_VALBRUT         // Valor Total da Fatura
		nTotFat     := If(nTotFat==0,SF1->F1_VALMERC+SF1->F1_VALIPI+SF1->F1_SEGURO+SF1->F1_FRETE,nTotFat)
		nTotFre     := SF1->F1_FRETE           // Frete
		nTotSeg     := SF1->F1_SEGURO				// Seguro
		nTotDsp		:= SF1->F1_DESPESA			// Despesa
		nBasICM     := SF1->F1_BASEICM         // Base do ICMS
		nBasIPI     := SF1->F1_BASEIPI         // Base do IPI
		nBasRet 	:= SF1->F1_BRICMS          // Base do ICMS retido
		nTotICM     := SF1->F1_VALICM          // Valor  do ICMS
		nTotICR     := SF1->F1_ICMSRET         // Valor  do ICMS Retido
		nTotIPI     := SF1->F1_VALIPI          // Valor  do IPI
		//nTotMer     := SF1->F1_VALMERC         // Valor  da Mercadoria
		nTotMer     := If(nTotFat==0,SF1->F1_VALMERC+SF1->F1_VALIPI+SF1->F1_SEGURO+SF1->F1_FRETE,nTotFat)
		cNumDup     := SF1->F1_DUPL            // Numero da Duplicata
		cConPag     := SF1->F1_COND            // Condicao de Pagamento
		cDesCon		:= Iif(!Empty(cConPag),Iif(SE4->(dbSeek(xFilial("SE4")+cConPag)),SE4->E4_DESCRI,""),"")
		nPesBru     := 0                       // Peso Bruto
		nPesLiq     := 0				            // Peso Liquido
		cTipNFi     := SF1->F1_TIPO            // Tipo da nota fiscal
		cEmbEsp     := ""                      // Especie 1 no Pedido
		nEmbVol     := 0                       // Volume 1 no Pedido
		cPreNFi		:= SF1->F1_PREFIXO         // Prefixo dos titulos eventualmente gerados
		nPesLto     := 0                       // Peso liquido calculado pela soma dos pesos dos itens
		nValDes     := SF1->F1_DESCONT			// Desconto total
		nSemRed		:= 0								// Valor total das mercadorias sem a reducao de base de ICMS
		nFreMot		:= 0								// Frete do motorista
		nValISS		:= SF1->F1_ISS					// Valor total do ISS da nota fiscal
        nValSer     := 0
		cPlaCam		:= Space(8)						// Placa do caminhao
		cUFCami		:= "  "							// UF do caminhao
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Levanta informacoes dos itens das notas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetorder(1)
		dbSeek(xFilial("SF1")+cNUMNFi+cSerNFi+cCodCli+cLojCli)
		
		aNumPed     := {}                         // Numero do Pedido de Venda
		aPedUni		:= {}                         // Numero do Pedido nao repetido
		aItePed     := {}                         // Numero do Item do Pedido de Venda
		aNumNFD     := {}                         // Numero da nota fiscal de devolucao
		aPreNFD     := {}                         // Serie  quAndo houver devolucao
		aPerICM     := {}                         // Porcentagem do ICMS
		aCodPro     := {}                         // Codigo  do Produto
		aQtdPro     := {}                         // Peso/Quantidade do Produto
		aPreUni     := {}                         // Preco Unitario de Venda
		aPreTab     := {}                         // Preco Unitario de Tabela
		aPerIPI     := {}                         // Porcentagem do IPI
		aValIPI     := {}                         // Valor do IPI
		aPerDes     := {}                         // Desconto por Item
		aValDes     := {}                         // Valor do Desconto
		aValMer     := {}                         // Valor da Mercadoria
		aCodTES     := {}                         // TES
		aCodFOp     := {}                         // Classificacao quanto natureza da Operacao
		aBasICR     := {}                         // Base do ICMS Solidario
		aValICM     := {}                         // ICMS do Produto
		aPesPro  	:= {}                         // Peso Liquido
		aPesUni		:= {}                         // Peso Unitario do Produto
		aDesPro     := {}                         // Descricao do Produto
		aUniPro   	:= {}                         // Unidade do Produto
		aCodTri  	:= {}                         // Codigo de Tributacao
		aClaFis  	:= {}                         // Classificacao Fiscal
		aPeriSS  	:= {}                         // Aliquota de ISS
		aTipPro     := {}                         // Tipo do Produto
		aMarLuc  	:= {}                         // Margem de Lucro p/ ICMS Solidario
		aPedCli		:= {}                         // Numero do pedido do cliente
		aPedClu		:= {}                         // Numero do pedido do cliente unico
		aPedDes		:= {}                         // Descricao dos produtos lancadas no pedido de vendas
		aIteDes     := {}                         // Desconto dos produtos lancados no pedido de vendas
		aResCFO     := {}                         // Resumo dos cfos na nota fiscal
		aTexTES     := {}                         // Texto do TES
		aSitTri		:= {}                         // Situacao tributaria informada no TES
		aTipFre     := {}                         // Tipo de frete (ficara vazio para entrada)
		aCodMen  	:= {}                         // Codigos de mensagens dos pedidos associados a nota
		aMenMan  	:= {}                         // Mensagens digitadas nos pedidos associados a nota
		aLotPro     := {}                         // Numero do lote do produto
		aLotVen     := {}                         // Data de validade do lote do produto
		aMenPro		:= {}						  //  Mensagem no produto
		aPosIPI		:= {}						  //  Posicao de IPI
		aCodMen  	:= {}                         // Codigos de mensagens dos pedidos associados a nota
		aQtdSeg		:= {}						  // Quantidade da segunda unidade de medida
		aValDes		:= {}                  		  // Valor do desconto
		aSemRed		:= {}						  // Valor dos itens sem reducao da base de ICMS 
		aISSIte		:= {}						  // Itens da NF referentes a servicos
        _cVendedores := Space(6)
		aTES        := {}                         // TES diferentes na NF
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carrega a mensagem manual da NF  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//AADD(aMenMan,SF1->F1_XOBS)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicia loop dos itens da nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof() .And. SD1->D1_DOC == cNumNFi .and. SD1->D1_FILIAL == xFilial("SD1") .and. ;
		             SD1->D1_FORNECE == cCodCli .and. SD1->D1_LOJA == cLojCli
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica serie da nota fiscal³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SD1->D1_SERIE # mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                       // do Parametro Informado !!!
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o produto e o TES do item³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega os campos dos itens da nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AADD(aNumPed, SD1->D1_PEDIDO)
			If aScan(aPedUni,SD1->D1_PEDIDO) == 0
				AADD(aPedUni, SD1->D1_PEDIDO)
			EndIf
			AADD(aItePed, SD1->D1_ITEMPC)
			AADD(aNumNFD, SD1->D1_NFORI)
			AADD(aPreNFD, SD1->D1_SERIORI)
			AADD(aPerICM, SD1->D1_PICM)
			AADD(aCodPro, SD1->D1_COD)
			AADD(aQtdPro, SD1->D1_QUANT)
			AADD(aPreUni, SD1->D1_VUNIT)
			AADD(aPreTab, 0)
			AADD(aPerIPI, SD1->D1_IPI)
			AADD(aValIPI, SD1->D1_VALIPI)
			AADD(aPerDes, SD1->D1_DESC)
			AADD(aValMer, SD1->D1_TOTAL)
			AADD(aCodTES, SD1->D1_TES)
			AADD(aCodFOp, SD1->D1_CF)
			AADD(aLotPro, SD1->D1_LOTECTL)
			AADD(aLotVen, SD1->D1_DTVALID)
			AADD(aPesPro, SB1->B1_PESO * SD1->D1_QTSEGUM)
			AADD(aPesUni, SB1->B1_PESO)
			AADD(aDesPro, SB1->B1_DESC)
			AADD(aUniPro, SB1->B1_UM)
			AADD(aCodTri, SB1->B1_ORIGEM)
			AADD(aClaFis, SB1->B1_CLASFIS)
			AADD(aPerISS, SB1->B1_ALIQISS)
			AADD(aTipPro, SB1->B1_TIPO)
			AADD(aMarLuc, SB1->B1_PICMRET)
			AADD(aPosIPI, SB1->B1_POSIPI)
        	AADD(aSitTri, SB1->B1_ORIGEM+SF4->F4_SITTRIB) // SB1->B1_ORIGEM+VALSITTRIB(SF4->F4_SITTRIB))
			AADD(aQtdSeg, SD1->D1_QTSEGUM)
			AADD(aValDes, SD1->D1_VALDESC)
			AADD(aISSIte, SF4->F4_ISS)
			
			If SF4->F4_BASEICM <> 0 .And. SD1->D1_PICM <> 0
				AADD(aSemRed, Round((SD1->D1_TOTAL-SD1->D1_VALICM) / (1-SD1->D1_PICM/100),2))
				nSemRed += aSemRed[Len(aSemRed)] - SD1->D1_TOTAL
			Else
				AADD(aSemRed, SD1->D1_TOTAL)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca mensagem do TES³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SF4->F4_MSG1) .And. aScan(aCodMen,SF4->F4_MSG1) == 0
				AADD(aCodMen, SF4->F4_MSG1) // MENPAD1
			EndIf
/*
			If !Empty(SF4->F4_MSG2) .And. aScan(aCodMen,SF4->F4_MSG2) == 0
				AADD(aCodMen, SF4->F4_MSG2)
			EndIf

			If !Empty(SF4->F4_MSG3) .And. aScan(aCodMen,SF4->F4_MSG3) == 0
				AADD(aCodMen, SF4->F4_MSG3)
			EndIf

			If !Empty(SF4->F4_MSG4) .And. aScan(aCodMen,SF4->F4_MSG4) == 0
				AADD(aCodMen, SF4->F4_MSG4)
			EndIf

			If !Empty(SF4->F4_MSG5) .And. aScan(aCodMen,SF4->F4_MSG5) == 0
				AADD(aCodMen, SF4->F4_MSG5)
			EndIf

			If !Empty(SF4->F4_MSG6) .And. aScan(aCodMen,SF4->F4_MSG6) == 0
				AADD(aCodMen, SF4->F4_MSG6)
			EndIf
*/			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca mensagem do produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*
			If !Empty(SB1->B1_MENPAD) .And. aScan(aCodMen,SB1->B1_MENPAD) == 0 .and. SF4->F4_ESTOQUE = "S" .and. SF4->F4_TIPO = "S"
				AADD(aCodMen, SB1->B1_MENPAD)
			EndIf
			*/
			If aScan(aResCFO,SD1->D1_CF) == 0
				AADD(aResCFO, SD1->D1_CF)
				AADD(aTexTES, SF4->F4_TEXTO)
				AADD(aTES, SD1->D1_TES)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Acumula o peso total³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPesLiq	+= aPesPro[Len(aPesPro)]
	        nPesBru += SB1->B1_PESBRU * SD1->D1_QUANT
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Vai para o proximo item de nota³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD1")
			dbSkip()
			
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca informacoes do cadastro de clientes ou fornecedores³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipNFi $ "B/D"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Informacoes de clientes³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSeek(xFilial("SA1")+cCodCli+cLojCli)
			
			cNomCli 	:= Left(SA1->A1_NOME,40)   // Nome do cliente
			cEndCli 	:= Left(SA1->A1_END,40)    // Endereco
			cBaiCli 	:= Left(SA1->A1_BAIRRO,30) // Bairro
			cCEPCli 	:= SA1->A1_CEP             // CEP
			cCobCli 	:= SA1->A1_ENDCOB          // Endereco de Cobranca
			cEntCli 	:= SA1->A1_ENDENT          // Endereco de Entrega
			cMunCli 	:= Left(SA1->A1_MUN,15)    // Municipio
			cEstCli 	:= SA1->A1_EST             // Estado
			cCGCCli 	:= SA1->A1_CGC             // CGC
			cInsCli 	:= SA1->A1_INSCR           // Inscricao estadual
			cTraCli 	:= SA1->A1_TRANSP          // Transportadora
			cTelCli 	:= If(!Empty(SA1->A1_DDI),SA1->A1_DDI+" ","")
			cTelCli		+= If(!Empty(SA1->A1_DDD),SA1->A1_DDD+" ","")+SA1->A1_TEL   // Telefone
			cFaxCli 	:= SA1->A1_FAX             // Fax
			cSUFRAM 	:= SA1->A1_SUFRAMA         // Codigo Suframa
			lZonFra 	:= (!Empty(cSUFRAM) .And. SA1->A1_CALCSUF == "S")
			//cInscrM		:= SA1->A1_INSCRM			// Inscricao municipal
			cInscrM		:= Iif(getmv("MV_ESTADO")=="SP",getmv("MV_MUNIC"),"") // Inscricao municipal
			
			If !Empty(SA1->A1_MENSAGE) .And. aScan(aCodMen,SA1->A1_MENSAGE) == 0
				AADD(aCodMen, SA1->A1_MENSAGE)
			EndIf

		Else
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Informacoes de forncedores³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSeek(xFilial("SA2")+cCodCli+cLojCli)
			cNomCli 	:= Left(SA2->A2_NOME,40)   // Nome do cliente
			cEndCli 	:= Left(SA2->A2_END,40)    // Endereco
			cBaiCli 	:= Left(SA2->A2_BAIRRO,30)// Bairro
			cCEPCli 	:= SA2->A2_CEP             // CEP
			cCobCli 	:= ""                      // Endereco de Cobranca
			cEntCli 	:= ""                      // Endereco de Entrega
			cMunCli 	:= Left(SA2->A2_MUN,15)   // Municipio
			cEstCli 	:= SA2->A2_EST             // Estado
			cCGCCli 	:= SA2->A2_CGC             // CGC
			cInsCli 	:= SA2->A2_INSCR           // Inscricao estadual
			cTraCli  	:= SA2->A2_TRANSP          // Transportadora
			cTelCli 	:= If(!Empty(SA2->A2_DDI),SA2->A2_DDI+" ","")
			cTelCli		+= If(!Empty(SA2->A2_DDD),SA2->A2_DDD+" ","")+SA2->A2_TEL   // Telefone
			cFaxCli  	:= SA2->A2_FAX             // Fax
			cSUFRAM 	:= ""                      // Codigo Suframa
			lZonFra 	:= .f.
			cInscrM		:= SA2->A2_INSCRM			// Inscricao municipal
						
		Endif
		
		
		cNomTra		:= ""
		cEndTra		:= ""
		cMunTra		:= ""
		cEstTra		:= ""
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca informacoes da transportadora da nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*
		dbSelectArea("SA4")
		dbSeek(xFilial("SA4")+SF1->F1_TRANSP)
		cNomTra		:= SA4->A4_NOME           // Nome Transportadora
		cEndTra		:= SA4->A4_END            // Endereco
		cMunTra		:= SA4->A4_MUN            // Municipio
		cEstTra		:= SA4->A4_EST            // Estado
		cViaTra		:= SA4->A4_VIA            // Via de Transporte
		cCGCTra		:= SA4->A4_CGC            // CGC
		cInsTra		:= SA4->A4_INSEST         // Inscricao Estadual
		cTelTra		:= SA4->A4_TEL            // Fone
		*/
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca informacoes dos titulos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")                   // * Contas a Pagar
		dbSeek(xFilial("SE2")+cPreNFi+cNumDup)
		
		aParDup		:= {}                       // Parcela
		aVenDup		:= {}                       // Vencimento
		aValDup		:= {}                       // Valor
	 	aMoeDup     := {}                       // Moeda

		While !Eof() .And. SE2->E2_NUM == cNumDup .And. cPreNFi == SE2->E2_PREFIXO .and. SE2->E2_FILIAL == xFilial("SE2")
			
			If !("NF" $ SE2->E2_TIPO) .Or. SE2->E2_FORNECE <> cCodCli .Or. SE2->E2_LOJA <> cLojCli
				dbSkip()
				Loop
			Endif
			
			AADD(aParDup, SE2->E2_PARCELA)
			AADD(aVenDup, SE2->E2_VENCTO)
			AADD(aValDup, SE2->E2_VALOR)
	      	AADD(aMoeDup, SE2->E2_MOEDA)
			dbSkip()
			
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara os itens da NF, para calcular a quantidade de formularios³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aIteNFs := {}
        aIteSrv := {}
		
		For nLoop1 := 1 to Len(aCodPro)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona produtos e complementos de produtos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			MsSeek(xFilial("SB1")+aCodPro[nLoop1])

			dbSelectArea("SB5")
			MsSeek(xFilial("SB5")+aCodPro[nLoop1])
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta dados de uma linha completa³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AADD(aIteNFS,{aCodPro[nLoop1],;
							If(SB5->(Found()).And.!Empty(SB5->B5_CEME),Left(SB5->B5_CEME,93),aDesPro[nLoop1]),;
						  	aSitTri[nLoop1],;
						  	aUniPro[nLoop1],;
						  	aQtdPro[nLoop1],;
						  	aPreUni[nLoop1],;
						  	aValMer[nLoop1],;
						  	aPerICM[nLoop1],;
						  	aPerIPI[nLoop1],;
						  	aValIPI[nLoop1],;
						  	aValDes[nLoop1],;
						  	aSemRed[nLoop1],;
						  	aISSIte[nLoop1],;
						  	aPerDes[nLoop1],;
						  	aClaFis[nLoop1],;
						  	aLotPro[nLoop1]})
					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca demais linhas da descricao cientifica, se houver³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			If !Empty(SB5->B5_CEME) .And. Len(Trim(SB5->B5_CEME)) > 93
//				AADD(aIteNFS,{"",Subs(SB5->B5_CEME,94,93),"","","",0,0,0,0,0,0,0,0})
//
//				If !Empty(SB5->B5_CEME) .And. Len(Trim(SB5->B5_CEME)) > 186
//					AADD(aIteNFS,{"",Subs(SB5->B5_CEME,187),"","","",0,0,0,0,0,0,0,0})
//				EndIf
//			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca dados do lote, se houver³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			If !Empty(aLotPro[nLoop1])
//				AADD(aIteNFS,{"","Lote: "+aLotPro[nLoop1]+"  Validade : "+Dtoc(aLotVen[nLoop1]),"","","",0,0,0,0,0,0,0,0})
//			EndIf
         
		Next  

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Calcula a quantidade de formularios necessarios³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nFormu1 := Int(Len(aIteNFs)/nTamDet  + .999999999)
        nFormu2 := Int(Len(aIteSrv)/nTamDet2 + .999999999)
        nFormul := IIf(nFormu1 > nFormu2, nFormu1, nFormu2)
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama funcao de impressao da nota fiscal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nForAtu := 1 to nFormul
			ImpDoc(nForAtu)
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³GRAVA FLAG NOTA IMPRESSA                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF1")
		
		If aReturn[5] == 3
           If RecLock("SF1",.F.)
              SF1->F1_FIMP := "S"
              MsUnlock()
           Endif
        Endif
		
		dbSkip()
		IncRegua()

		// Incrementa número do selo
		//cNumSelo	:= Soma1(cNumSelo, Len(cNumSelo))
		
	EndDo
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime caracter de descompactacao e zera posicao do formulario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//@ 000, 000 PSAY Chr(27)+"2"           // Descompressao de Impressao Vertical
//@ 000, 000 PSAY Chr(27)+"C"+Chr(66)  // Descompressao de Impressao Vertical
@ 000, 000 PSAY Chr(18)					  // Descompressao de caracteres

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Encerra a impressao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen    

SetPgEject(.f.)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpDoc   ºAutor  ³ Octavio Moreira    º Data ³  10/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina principal de impressao da nota fiscal               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpDoc(nFor)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define variaveis locais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cNatOpe := ""              // String com todas as descricoes de operacoes da nota
Local cCfoTot := ""              // String com todos os cfops da nota
Local cTipFre := "1"             // Tipo de frete
Local cNumNFD := ""              // Numeros das notas fiscais originais, caso sejam devolucao
Private aCabNFi := {}					// Contem os dados do cabecalho da NF
Private aMenImp := {}				   // Array que tera as mensagens prontas para impressao
Private nTamObs := 66              // Tamanho da linha de observacao
Private nForAtu := nFor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa variavel que controla o numero da linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define array que compoe o cabecalho da NF³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ nLin, 001 PSAY ""

nLin := nLin + 5
If cFilAnt=="53" // Somente Filial RINI
   @ nLin,037 Psay chr(14)+"DELLA VIA PNEUS LTDA."+chr(20)
   nLin := nLin + 1
Else
   nLin := nLin + 1
Endif
If Getmv("MV_ESTADO")=="SP" // Somente para filiais de Sao Paulo
   @ nLin,037 Psay Alltrim(SM0->M0_ENDENT+SM0->M0_COMPENT)
Endif
nLin := nLin + 1
If Getmv("MV_ESTADO")=="SP" // Somente para filiais de Sao Paulo
   @ nLin,037 Psay Alltrim(SM0->M0_CIDENT)
   @ nLin,063 Psay Alltrim(SM0->M0_ESTENT)
Endif
@ nLin,131 Psay cNumNFi + If(nFormul > 1," / "+AllTrim(Str(nForAtu,6)),"") 
nLin := nLin + 1
If mv_par04 = 2
 @ nLin,093 Psay "X"
Else
 @ nLin,109 Psay "X"  
Endif
nLin := nLin + 1
If Getmv("MV_ESTADO")=="SP" // Somente para filiais de Sao Paulo
   @ nLin,037 Psay "Tel.: "+Alltrim(SM0->M0_TEL) // +"  Fax: "+Alltrim(SM0->M0_FAX)
Endif
nLin := nLin + 3
For nLoop1 := 1 to Len(aTexTES)
    //If Len(aResCFO) > 1 .and. (Alltrim(aResCFO[nLoop1]) $ "5949")
    If Len(aResCFO) > 1 .and. (Alltrim(aTES[nLoop1]) $ "900/")
       loop
    Endif
	cNatOpe += If(Len(cNatOpe)>0,"/","")+Trim(aTexTES[nLoop1])
Next
For nLoop1 := 1 to Len(aResCFO)
    //If Len(aResCFO) > 1 .and. (Alltrim(aResCFO[nLoop1]) $ "5949")
    If Len(aResCFO) > 1 .and. (Alltrim(aTES[nLoop1]) $ "900/")
       loop
    Endif
	cCfoTot += If(Len(cCfoTot)>0,"/","")+Trim(Left(aResCFO[nLoop1],1)+"."+Subs(aResCFO[nLoop1],2))
Next
If Getmv("MV_ESTADO")=="SP" // Somente para filiais de Sao Paulo
   //@ nLin,092 Psay Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
   @ nLin,005 Psay chr(14)+"AGRADECEMOS A PREFERENCIA"+chr(20)+Space(37)+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
Else
   @ nLin,005 Psay chr(14)+"AGRADECEMOS A PREFERENCIA"+chr(20)
Endif
nLin := nLin + 3
@ nLin,005 Psay cNatOpe 
@ nLin,047 Psay cCfoTot
If Getmv("MV_ESTADO")=="SP" // Somente para filiais de Sao Paulo
   @ nLin,092 Psay SM0->M0_INSC
Endif
nLin := nLin + 4
@ nLin,005 Psay cNomCli+Space(47)+If(!Empty(cCGCCli),Transform(cCGCCli,"@R 99.999.999/9999-99"),Space(18))+Space(19)+Dtoc(dDatEmi)
nLin := nLin + 3
@ nLin,005 Psay cEndCli+Space(25)+cBaiCli+"      "+Transform(cCEPCli,"@R 99999-999")
nLin := nLin + 2
@ nLin,005 Psay cMunCli+Space(50)+Left(cTelCli+Space(15),15)+Space(1)+cEstCli+Space(4)+cInsCli+Space(19)+time() //Transform(cInsCli,"@R 999.999.999.999")
nLin := nLin + 3
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o desdobramento de duplicatas, caso hajam³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ImpDup()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o cabecalho da NF e as mensagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := 1 to Len(aCabNfi)
	
	If Len(aCabNFi) >= nLoop1
      @ nLin, 005 PSAY aCabNFi[nLoop1]
	EndIf      

	nLin++
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime os itens da nota³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := 35
ImpDet()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime servicos da nota fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := 52
ImpServ()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime os valores totais da nota³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := 61
If nFormul > 1 .And. nForAtu <> nFormul
	@ nLin, 005 PSAY "**,***,***.**"
	@ nLin, 035 PSAY "**,***,***.**"
	@ nLin, 061 PSAY "**,***,***.**"
	@ nLin, 090 PSAY "**,***,***.**"
	@ nLin, 115 PSAY "**,***,***.**"
Else
	@ nLin, 005 PSAY nBasICM   Picture "@E 99,999,999.99"
	@ nLin, 035 PSAY nTotICM   Picture "@E 99,999,999.99"
	@ nLin, 061 PSAY nBasRet   Picture "@E 99,999,999.99"
	@ nLin, 090 PSAY nTotICR   Picture "@E 99,999,999.99"
	@ nLin, 115 PSAY (nTotMer-nValSer) Picture "@E 99,999,999.99"
EndIf
nLin += 3

If nFormul > 1 .And. nForAtu <> nFormul
	@ nLin, 005 PSAY "**,***,***.**"
	@ nLin, 035 PSAY "**,***,***.**"
	@ nLin, 090 PSAY "**,***,***.**"
	@ nLin, 115 PSAY "**,***,***.**"
Else
	@ nLin, 005 PSAY nTotFre   Picture "@E 99,999,999.99"
	@ nLin, 035 PSAY nTotSeg   Picture "@E 99,999,999.99"
	@ nLin, 061 PSAY nTotDsp   Picture "@E 99,999,999.99"
	@ nLin, 090 PSAY nTotIPI   Picture "@E 99,999,999.99"
	@ nLin, 115 PSAY nTotFat   Picture "@E 99,999,999.99"
EndIf

// Faz impressão do selo
//nLin += 3
If SM0->M0_ESTENT == "PE"
	nLin ++
//	@ nLin, 155 PSAY AllTrim(mv_par03)+"-"+cNumNFi
	nLin += 3
Else
	nLin += 4
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o tipo de frete³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := 1 to Len(aTipFre)
	If aTipFre[nLoop1] <> "C"
	   cTipFre := "2"
	   Exit
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime dados da transportadora³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFormul = 1 .Or. nForAtu == nFormul
	@ nLin, 005 PSAY Iif(Empty(cNomTra),".",cNomTra)
	@ nLin, 084 PSAY Iif(Empty(cTipFre),".",cTipFre)
	@ nLin, 087 PSAY Iif(Empty(cPlaCam),".",cPlaCam)
	@ nLin, 107 PSAY Iif(Empty(cUFCami),".",cUFCami)

	If !Empty(cCGCTra)
		@ nLin, 110 PSAY cCGCTra Picture"@R 99.999.999/9999-99"
	Endif
EndIf

nLin += 3

If nFormul = 1 .Or. nForAtu == nFormul
	@ nLin, 005 PSAY Iif(Empty(cEndTra),".",cEndTra)
	@ nLin, 072 PSAY Iif(Empty(cMunTra),".",cMunTra)
	@ nLin, 103 PSAY Iif(Empty(cEstTra),".",cEstTra)
	@ nLin, 110 PSAY Transform(cInsTra,"@R 999.999.999.999")
EndIf

// Faz a impressão do selo
//If SM0->M0_ESTENT == "PE"
//	@ nLin, 158 PSAY DToC(mv_par07)
//EndIf

nLin += 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime dos dados dos volumes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nFormul = 1 .Or. nForAtu == nFormul) .And. cTipNFi $ "NDB"
    If nEmbVol > 0
       @ nLin, 005 PSAY nEmbVol  Picture "@E 999,999.99"           // Quant. Volumes
    Endif
	@ nLin, 025 PSAY Iif(Empty(cEmbEsp),".",cEmbEsp)
	@ nLin, 048 PSAY "."
	@ nLin, 073 PSAY "."
	//@ nLin, 102 PSAY nPesBru  Picture"@E 999,999.99"           // Peso Bruto (do SF2)
	@ nLin, 103 PSAY nPesLiq  Picture"@E 999,999.99"           // Definido pelo Sr. Rodrigo Peso Bruto = Liquido
	@ nLin, 120 PSAY nPesLiq  Picture"@E 999,999.99"           // Peso Liquido (do SF2)
EndIf

// Faz a impressão do selo
//If SM0->M0_ESTENT == "PE"
//	@ nLin, 150 PSAY AllTrim(mv_par06)+"-"+cNumSelo
//EndIf

// Impressao do pedido do Cliente - Alexandre Martim 01/09/05
nLin += 2
If Len(aPedClu) > 0
   _cPedCli:=""
   @ nLin, 045 PSAY "Ped. Cliente: "
   For _nx:=1 to min(Len(aPedClu),3)
       _cPedCli+=Alltrim(aPedClu[_nx])+"/"
   Next
   @ nLin, 060 PSAY _cPedCli
Endif

ImpMen()

nLin += 3
@ nLin, 005 PSAY Iif("VISTA"$upper(cDesCon),"VISTA","PRAZO")
@ nLin, 013 PSAY _cVendedores

nLin += 01
For nLoop1 := 1 to Len(aMenImp)
	@ nLin, 005 PSAY aMenImp[nLoop1]
	nLin++
Next

nLin += 04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime numero da nota no canhoto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin, 070 PSAY "Filial: "+SM0->M0_CODFIL
@ nLin, 131 PSAY cNumNFi + If(nFormul > 1," / "+AllTrim(Str(nForAtu,6)),"")               // Numero da Nota Fiscal
nLin += 5

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona final do formulario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin, 000 PSAY Chr(18)+Chr(15)

SetPrc(0,0)                              // (Zera o Formulario)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpDet   ºAutor  ³ Octavio Moreira    º Data ³  10/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime itens da nota fiscal                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpDet()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime colunas dos itens da nota e incrementa linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := (nForAtu-1)*nTamDet+1 to Min(Len(aIteNFs),nForAtu*nTamDet)
	
	If aIteNFs[nLoop1][13] <> "S"  // nao e servico
		@ nLin, 005  PSAY Left(aIteNFs[nLoop1][1],10)
		@ nLin, 015  PSAY Alltrim(aIteNFs[nLoop1][2])+Iif(Empty(aIteNFs[nLoop1][16]),""," - "+aIteNFs[nLoop1][16])
		@ nLin, 068  PSAY aIteNFs[nLoop1][3]
        @ nLin, 073  PSAY aIteNFs[nLoop1][4]
		@ nLin, 078  PSAY aIteNFs[nLoop1][5] Picture "@E 9999"
        @ nLin, 090  PSAY aIteNFs[nLoop1][6] Picture "@E 9,999,999.99"
		@ nLin, 113  PSAY aIteNFs[nLoop1][7] Picture "@E 99,999,999.99"
		@ nLin, 134  PSAY aIteNFs[nLoop1][8] Picture "@E 99" // perc icms  "@E 99.99"
    	nLin++
	EndIf
		
Next
@ 050, 035  PSAY "Na compra de PNEUS acompanha certificado de garantia"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpServ  ºAutor  ³ Octavio Moreira    º Data ³  11/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime itens de servico da nota fiscal                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpServ()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa variaveis da funcao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aIteSer := {}
Local nLoop1
//Local nValSer := 0
//nValSer := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime colunas dos itens da nota e incrementa linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := (nForAtu-1)*nTamDet2+1 to Min(Len(aIteSrv),nForAtu*nTamDet2)
	
	If aIteSrv[nLoop1][13] == "S"
		aAdd(aIteSer,{aIteSrv[nLoop1][1],aIteSrv[nLoop1][2],aIteSrv[nLoop1][3],aIteSrv[nLoop1][4],aIteSrv[nLoop1][5],;
					   aIteSrv[nLoop1][6],aIteSrv[nLoop1][7],aIteSrv[nLoop1][8]})
		//nValSer += aIteSrv[nLoop1][8]
		nValSer += aIteSrv[nLoop1][7]
	EndIf
		
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Complementa array de servicos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := Len(aIteSer) + 1 to 5
	aAdd(aIteSer,{"",""})
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime os itens de servico e campos complementares³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := 1 to 5

    If nLoop1 == 1
	    @ nLin, 121 PSAY Iif(nValSer>0,cInscrM,"")
    EndIf
    
	@ nLin+nLoop1, 005 PSAY aIteSer[nLoop1][2]
	If Len(aIteSer[nLoop1]) >= 7
       @ nLin+nLoop1, 080 PSAY aIteSer[nLoop1][5] Picture "@E 999"
       @ nLin+nLoop1, 085 PSAY aIteSer[nLoop1][6] Picture "@E 9,999.99"
       @ nLin+nLoop1, 096 PSAY aIteSer[nLoop1][7] Picture "@E 99,999.99"
    Endif

	If nLoop1 == 3
	    If nValISS > 0
           If nFormul > 1 .And. nForAtu <> nFormul
              @ nLin+nLoop1, 120 PSAY nValISS Picture "***.***,**"
           Else
              @ nLin+nLoop1, 113 PSAY nValISS Picture "@E 999,999,999.99"
           Endif
        Endif
	EndIf
	                           
	If nLoop1 == 5
	    If nValSer > 0
           If nFormul > 1 .And. nForAtu <> nFormul
              @ nLin+nLoop1, 120 PSAY nValSer Picture "***.***,**"
           Else
              @ nLin+nLoop1, 113 PSAY nValSer Picture "@E 999,999,999.99"
           Endif
        Endif
	EndIf
Next
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpMen   ºAutor  ³ Octavio Moreira    º Data ³  10/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime as mensagens informadas nos pedidos da nota fiscal º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpMen()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define variaveis locais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMenFor := ""             // String com as mensagens codificadas
Local cMenMan := ""             // String com a soma das mensagens manuais
Local nLinLim := nLin + 08      // Numero da linha limite para impressao de mensagens
Local aDevolu := {}				// Notas fiscais de devolucao
Local cResDev := ""				// Detalhes das notas fiscais de devolucao
Local nICMFRe := If(cEstCli $ GetMv("MV_NORTE"),7,12)   // Percentuais de ICMS 
Local cMenFre
Local aResPar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Insere linhas em branco para ajustar preenchimento no formulario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime mensagem de calculo da base do frete³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If nTotFre <> 0
	cMenFre := "VR.PREST.SERV.R$ "+LTrim(Transform(nFreMot,"@E 999,999.99"))+;
				  " - BASE CALCULO R$ "+LTrim(Transform(Round(nFreMot/(1-nICMFre/100),2),"@E 999,999,999.99"))+;
				  " - ALIQUOTA "+LTrim(Transform(nICMFre,"@E 999.99"))+"% - VALOR ICMS R$ "+;
				  LTrim(Transform(NoRound(Round(nFreMot/(1-nICMFre/100),2)*nICMFre/100,2),"@E 999,999,999.99"))

	While Len(cMenFre) > 0
		aAdd(aMenImp,Left(cMenFre,nTamObs))
		cMenFre := Subs(cMenFre,nTamObs+1)
	Enddo

EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime as mensagens codificadas (formulas)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1	:= 1 to Len(aCodMen)
	cMenFor	:= Formula(aCodMen[nLoop1])
	
	If !Empty(cMenFor)
		
		cMenFor	:=	Trim(cMenFor)
		
		While Len(cMenFor) > 0
			aAdd(aMenImp,Left(cMenFor,nTamObs))
			cMenFor := Subs(cMenFor,nTamObs+1)
		Enddo
		
	EndIf
	
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta mensagens de devolucao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := 1 to Len(aNumNFD)
	If aScan(aDevolu,aNumNFD[nLoop1]+aPreNFD[nLoop1]) == 0 .And. !Empty(aNumNFD[nLoop1])
		aAdd(aDevolu,aNumNFD[nLoop1]+aPreNFD[nLoop1])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta a string com o sumario de devolucoes referentes a NF³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cResDev := aNumNFD[nLoop1] + "/" + aPreNFD[nLoop1] + " "
		           
		If mv_par04 == 2
			dbSelectArea("SF1")
			dbSeek(xFilial("SF1")+aNumNFD[nLoop1]+aPreNFD[nLoop1]+cCodCli+cLojCli+"D")
			
			If !Eof()
				cResDev := cResDev + "de " + Dtoc(SF1->F1_EMISSAO)
			EndIf
		Else
			dbSelectArea("SF2")
			dbSeek(xFilial("SF2")+aNumNFD[nLoop1]+aPreNFD[nLoop1]+cCodCli+cLojCli)
			
			If !Eof()
				cResDev := cResDev + "de " + Dtoc(SF2->F2_EMISSAO)
			EndIf
		EndIf
	EndIf		
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se ha devolucao para a NF, monta o array de observacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cResDev <> ""
	cResDev := "Nota(s) original(is): " + cResDev
	cResDev	:=	Trim(cResDev)
		
	While Len(cResDev) > 0 .And. nLin <= nLinLim
		aAdd(aMenImp,Left(cResDev,nTamObs))
		cResDev := Subs(cResDev,nTamObs+1)
	Enddo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se ha msg no parametro, monta o array de observacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
aRespar:={}
If ! empty(alltrim(mv_par08))
	aadd(aRespar,Alltrim(mv_par08))
	If !Empty(alltrim(mv_par09))
     aadd(aRespar,mv_par09)	
    Endif
    If ! empty(alltrim(mv_par10)) 
     aadd(aRespar,mv_par10)
    Endif
    If ! Empty(alltrim(mv_par11)) 
     aadd(aRespar,mv_par11)
    endif 
	For i:= 1 to Len(aRespar)
	 If nLin <= nLinLim
		aAdd(aMenImp, aRespar[i])
	 Endif	
	Next
EndIf
*/
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta string com a soma das mensagens manuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop1 := 1 to Len(aMenMan)
	cMenMan += Trim(aMenMan[nLoop1])
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime as mensagens manuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While Len(cMenMan) > 0 .And. nLin <= nLinLim
	aAdd(aMenImp,Left(cMenMan,nTamObs))
	cMenMan := Subs(cMenMan,nTamObs+1)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime sequencia de formularios da NF³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If nFormul > 1
//	aAdd(aMenImp,"Folha "+AllTrim(Str(nForAtu,3))+"/"+AllTrim(Str(nFormul,3))+If(nFormul==nForAtu,""," - Continua"))
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso seja Nota de Saida e Cliente com recolhimento de ISS e Nota tipo 'N' insere mensagem automatica ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par04==2 .and. cTipNFi $ "N/" .and. SA1->A1_RECISS=="1" .and. nValISS>0 .and. !(nFormul > 1 .And. nForAtu <> nFormul)
	aAdd(aMenImp,"Valor do ISS retido R$ "+AllTrim(Str(nValISS,11,2))+" conf. Lei Mun. 443/2001")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define linhas vazias para complementar o array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop1 := Len(aMenImp)+1 to 8
   aAdd(aMenImp,Space(nTamObs))
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpDup   ºAutor  ³ Octavio Moreira    º Data ³  10/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o desdobramento de duplicatas, caso existam        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpDup()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define variaveis locais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nColDup := 70             // Coluna inicial de impressao
Local nColImp := nColDup        // Coluna corrente de impressao
Local nAjuste := 45             // Salto entre uma coluna e outra
Local nParLin := 3              // Quantidade de parcelas que podem ser impressas por linha
Local nMaxPar := 9              // Numero maximo de parcelas que podem ser impressas no leiaute

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime as duplicatas ligadas a nota fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aCabNFi,"")

For nLoop1 := 1 to Min(Len(aVenDup),nMaxPar)
	aCabNFi[Len(aCabNFi)] += " "+cNumNFi + "/" + aParDup[nLoop1] + Space(7) + Dtoc(aVenDup[nLoop1]) + Space(5) + TransForm(aValDup[nLoop1],"@E 99,999,999.99") + Space(2)
	If nColImp + nAjuste < nColDup + nAjuste * nParLin
		nColImp += nAjuste
	Else
		aAdd(aCabNFi,"")
		nColImp := nColDup
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Praca de pagamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aAdd(aCabNFi,"")    
//aAdd(aCabNFi,cCobCli)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³VALIDPERG ³ Autor ³  Luiz Carlos Vieira   ³ Data ³ 03/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico                                              	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes de variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea   := GetArea()
Local aRegs   := {}

AADD(aRegs,{PADR(cPerg,6),"01","Da Nota Fiscal     ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,6),"02","Ate a Nota Fiscal  ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,6),"03","Serie da Nota      ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{PADR(cPerg,6),"04","Entrada ou Saida   ?","","","mv_ch4","N",01,0,2,"C","","mv_par04","Entrada",	"","","","","Saida",	"","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{PADR(cPerg,6),"05","Numero do Selo     ?","","","mv_ch5","C",10,0,0,"G","","mv_par05","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{PADR(cPerg,6),"06","Serie do Selo      ?","","","mv_ch6","C",03,0,0,"G","","mv_par06","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{PADR(cPerg,6),"07","Data de Saída      ?","","","mv_ch7","D",08,0,0,"G","","mv_par07","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{PADR(cPerg,6),"08","Msg. 1             ?","","","mv_ch8","C",50,0,0,"G","","mv_par07","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{PADR(cPerg,6),"09","Msg. 2             ?","","","mv_ch9","C",50,0,0,"G","","mv_par07","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{PADR(cPerg,6),"10","Msg. 3             ?","","","mv_cha","C",50,0,0,"G","","mv_par07","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{PADR(cPerg,6),"11","Msg. 4             ?","","","mv_chb","C",50,0,0,"G","","mv_par07","",			"","","","","",		"","","","","","","","","","","","","","","","","","","","","","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualizacao do SX1 com os parametros criados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX1")
DbSetorder(1)

For nLoop1 := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nLoop1,2])
		RecLock("SX1",.T.)
		
		For nLoop2 := 1 to FCount()
			FieldPut(nLoop2,aRegs[nLoop1,nLoop2])
		Next
		
		MsUnlock()
		dbCommit()
	Endif
Next
         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna ambiente original³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)

Return(Nil)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³VALSITTRIB³ Autor ³  JAIRO OLIVEIRA       ³ Data ³ 01/12/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica a Situacao tributaria no PBA              		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Nota Fiscal                                           	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VALSITTRIB(cCodSit)
Local aAreaPBA		:= {}
Local aCodF4		:= {}
Local	nX				:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ se nao é em branco retorna o proprio codigo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCodSit <> "  "
   Return(cCodSit)
EndIF

AADD(aCodF4,SF4->F4_MSG1)
AADD(aCodF4,SF4->F4_MSG2)
/*
AADD(aCodF4,SF4->F4_MSG3)
AADD(aCodF4,SF4->F4_MSG4)
AADD(aCodF4,SF4->F4_MSG5)
AADD(aCodF4,SF4->F4_MSG6)

aAreaPBA		:= PBA->(Getarea())
dbSelectArea("PBA")
dbsetorder(1)
For nX := 1 to 6
	If !empty(aCodF4) .And. DBSeek(xFilial("PBA")+aCodF4[nX]+SM0->M0_ESTENT,.F.)
  		IF PBA->PBA_SITRIB <> "  "
     		Return(PBA->PBA_SITRIB)
   	EndIf
	EndIF
Next nX   
*/
Return("  ")

Static Function SelUltCompra(_cProduto, _nQtdVendida, _nBaseIcmsRet, _nValIcmsRet, _nValIcmsDev)
       //
       Local _cAlias, _nOrder, _nRec, _nOrdSD1, _nRecSD1
       Local _nQtdEntrada, _nBIcmsRet, _nVIcmsRet, _nVIcmsDev, _nResto_da_Venda, _nSaldoEntrada, _lCompleto:=.f.
       //
       _cAlias  := Alias()
       _nOrder  := IndexOrd()
       _nRec    := Recno()
       _nOrdSD1 := SD1->(IndexOrd())
       _nRecSD1 := SD1->(Recno())
       _nBIcmsRet := 0.00
       _nVIcmsRet := 0.00
       _nVIcmsDev := 0.00
       _nSaldoEntrada := _nQtdVendida
       //
       DbSelectArea("SD1")
       DbSetOrder(7)
       DbSeek(xFilial("SD1")+Alltrim(_cProduto)+"Z",.T.) // Posiciono no proximo produto e volto um.
       DbSkip(-1)
       If SD1->D1_COD == _cProduto
          Do While !Bof() .and. SD1->D1_FILIAL==xFilial("SD1") .and. SD1->D1_COD == _cProduto
             //
             //If (SD1->D1_BRICMS+SD1->D1_ICMSRET) > 0
             If (SD1->D1_ICMSRET) > 0
                //
                _nResto_da_Venda := (_nSaldoEntrada - SD1->D1_QUANT)
                //
                If _nResto_da_Venda <= 0 .and. SD1->D1_QUANT > 0
                   _nBaseIcmsRet += (SD1->D1_BRICMS /SD1->D1_QUANT * _nSaldoEntrada) + _nBIcmsRet
                   _nValIcmsRet  += (SD1->D1_ICMSRET/SD1->D1_QUANT * _nSaldoEntrada) + _nVIcmsRet
                   _nValIcmsDev  += (SD1->D1_VALICM /SD1->D1_QUANT * _nSaldoEntrada) + _nVIcmsDev
                   _lCompleto:=.t.
                   exit
                Endif
                //
                _nSaldoEntrada := (_nSaldoEntrada - SD1->D1_QUANT)
                _nBIcmsRet += SD1->D1_BRICMS 
                _nVIcmsRet += SD1->D1_ICMSRET
                _nVIcmsDev += SD1->D1_VALICM
                //
             Endif
             //
             DbSkip(-1)
             //
          Enddo
          //
          // Nao conseguiu achar a quantidade nas Notas de Entrada, lanca-se o que conseguiu...
          //
          If !_lCompleto
              If _nSaldoEntrada > 0
                 _nBaseIcmsRet += _nBIcmsRet
                 _nValIcmsRet  += _nVIcmsRet
                 _nValIcmsDev  += _nVIcmsDev
                 // Vou Procurar nas Filiais (Mesmo Estado da Filial Atual). e Ver as compras (Completar)
                 _Dvbusca(_cProduto,_nSaldoEntrada)
              Endif
          Endif
          //
       Endif
       //
       DbSelectArea("SD1")
       DbSetOrder(_nOrdSD1)
       DbGoto(_nRecSD1)
       //
       DbSelectArea(_cAlias)
       DbSetOrder(_nOrder)
       DbGoto(_nRec)
       //
Return


Static Function _DvBusca(_cProduto,_nSaldoEntrada)
_cEst := SM0->M0_ESTENT
_cVar := "MV_DVSUB"+_cEst    
_lCompleto:=.f.

// Identifica as Filiais que o sistema podera procurar a Ultima Compra.
// Por Exemplo. Loja no Estado do PR e no Parametro Tiver 27/19/41/35.
// Entao, se na Propria filial nao encontrou compra, verificar nestas 4 lojas, onde existe uma ultima
// Compra com Substituicao Tributaria.

_cAlias:=Alias()
                       
dbSelectarea("SX6")
dBsetorder(1)
If dbseek("  "+_cVar)

   _aLoj:={}
   For _c:=1 to 500 Step 3            
       IF Substr(SX6->X6_CONTEUD,_c,1) $ "0123456789"
          AADD(_aLoj,Substr(SX6->X6_CONTEUD,_c,2) )
       ENDIF
   Next                                    

   For _c:=1 to Len(_aLoj)
       DbSelectArea("SD1")
       DbSetOrder(7)
       DbSeek(_aLoj[_c]+Alltrim(_cProduto)+"Z",.T.) // Posiciono no proximo produto e volto um.
       DbSkip(-1)  
       _nBIcmsRet :=0
       _nVIcmsRet :=0
       _nVIcmsDev :=0
            
       If SD1->D1_COD == _cProduto
          Do While !Bof() .and. SD1->D1_FILIAL==_aLoj[_c] .and. SD1->D1_COD == _cProduto
             If (SD1->D1_ICMSRET) > 0
                //
                _nResto_da_Venda := (_nSaldoEntrada - SD1->D1_QUANT)
                //
                If _nResto_da_Venda <= 0 .and. SD1->D1_QUANT > 0
                   _nBaseIcmsRet += (SD1->D1_BRICMS /SD1->D1_QUANT * _nSaldoEntrada) + _nBIcmsRet
                   _nValIcmsRet  += (SD1->D1_ICMSRET/SD1->D1_QUANT * _nSaldoEntrada) + _nVIcmsRet
                   _nValIcmsDev  += (SD1->D1_VALICM /SD1->D1_QUANT * _nSaldoEntrada) + _nVIcmsDev
                   _lCompleto:=.t.
                   exit
                Endif
                //
                _nSaldoEntrada := (_nSaldoEntrada - SD1->D1_QUANT)
                _nBIcmsRet += SD1->D1_BRICMS 
                _nVIcmsRet += SD1->D1_ICMSRET
                _nVIcmsDev += SD1->D1_VALICM
                //
             Endif
             //
             DbSkip(-1)
             //
          Enddo
          //
          // Nao conseguiu achar a quantidade nas Notas de Entrada, lanca-se o que conseguiu...
          //
          If !_lCompleto
              If _nSaldoEntrada > 0
                 _nBaseIcmsRet += _nBIcmsRet
                 _nValIcmsRet  += _nVIcmsRet
                 _nValIcmsDev  += _nVIcmsDev
              Endif
          Else
              Exit
          Endif
          //
       Endif
   Next

Endif

dBselectarea(_cAlias)



