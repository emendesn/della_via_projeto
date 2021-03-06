#include "rwmake.ch"
/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � DFATR04  � Autor �   Microsiga       � Data � 03/08/05     ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao de nota fiscal da Durapol                        ���
��+----------+------------------------------------------------------------���
���Uso       � Durapol                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function DFatr04()
	//+--------------------------------------------------------------+
	//� Define Variaveis Ambientais                                  �
	//+--------------------------------------------------------------+
	//+--------------------------------------------------------------+
	//� Variaveis utilizadas para parametros                         �
	//� mv_par01             // Da Nota Fiscal                       �
	//� mv_par02             // Ate a Nota Fiscal                    �
	//� mv_par03             // Da Serie                             �
	//� mv_par04             // Nota Fiscal de Entrada/Saida         �
	//+--------------------------------------------------------------+
	CbTxt     :=""
	CbCont    :=""
	nOrdem    :=0
	tamanho   :="G"
	limite    :=220
	Titulo    :=PADC("Nota Fiscal Durapol",74)
	cDesc1    :=PADC("Este programa ira emitir a Nota Fiscal de Saida",74)
	cDesc2    :="contemplando a impressao dos produtos e servicos executados"
	cDesc3    :=""
	cNatureza :=""
	aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  :="DFATR04"
	cPerg     :="DFAT04"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 0
	wnrel     := "DFATR04"

	//Grupo de produtos so conserto que nao contem valor,no momento da geracao da NFE,
	//porem os produtos contidod no ajustes de empenho devem pertencer a um grupo que agrega
	//TES 902
	Private _cGrpSC := GetMV("MV_X_GRPSC")

	//Grupo de produtos que serao inseridos automaticamente no PV para faturamento a partir do ajuste de empenho
	Private _cGrpRO := GetMV("MV_X_GRPRO")

	//Codigo do TES de saida para venda de servico, quando este for um servico executado fora pacote escolhido
	//TES 901
	Private _cTESVen := GetMV("MV_X_TSVED")

	//Banco
	Private cBanco   := GetNewPar("MV_X_BCO1","")
	Private cNomeBco := ""

	Private xVolume  := 0
	Private _lFrota := .F.

	// posicoes do array de produtos
	Private _npSeq
	Private	_npCod
	Private	_npDescr
	Private	_npCF
	Private	_npUM
	Private	_npPrcVen
	Private	_npTotal
	Private	_npQuant
	Private	_npTES

	// posicoes do array de servicos
	Private _nsSeq
	Private _nsGrp
	Private _nsQuant
	Private _nsUM
	Private _nsDescr
	Private _nsPrcVen
	Private _nsTotal
	Private _nsTES
	Private _nsFrota
    
	// TOTAL CARCACA + SERVICO
	Private vTelex := 0

	//+-------------------------------------------------------------------------+
	//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
	//+-------------------------------------------------------------------------+
	_aRegs:={}
	AAdd(_aRegs,{cPerg,"01","Da Nota Fiscal?"     ,"Da Nota Fiscal?"     ,"Da Nota Fiscal?"     ,"mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{cPerg,"02","Ate Nota Fiscal?"    ,"Ate Nota Fiscal?"    ,"Ate Nota Fiscal?"    ,"mv_ch2","C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{cPerg,"03","Serie?"              ,"Ate Nota Fiscal?"    ,"Ate Nota Fiscal?"    ,"mv_ch3","C", 3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(_aRegs,{cPerg,"04","Tipo Nota?"          ,"Tipo Nota?"          ,"Tipo Nota?"          ,"mv_ch4","N", 1,0,0,"C","","mv_par04","Entrada","Entrada","Entrada","","","Saida","Saida","","","","","","","","","","","","","","","","","",""})
	ValidPerg(_aRegs,cPerg)

	Pergunte(cPerg,.F.)

	cString:="SF2"
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	VerImp()

	RptStatus({|| RptDetail()})
Return

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � RptDetail� Autor �   Microsiga       � Data � 03/08/05     ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao do detalhe de nota                               ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function RptDetail()
	If mv_par04 == 2
		dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
		dbSetOrder(1)
		dbSeek(xFilial()+mv_par01+mv_par03,.t.)

		dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
		dbSetOrder(3)
		dbSeek(xFilial()+mv_par01+mv_par03)
		cPedant := SD2->D2_PEDIDO
	Else
		dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
		DbSetOrder(1)
		dbSeek(xFilial()+mv_par01+mv_par03,.t.)

		dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
		dbSetOrder(3)
	Endif

	//+-----------------------------------------------------------+
	//� Inicializa  regua de impressao                            �
	//+-----------------------------------------------------------+
	SetRegua(Val(mv_par02)-Val(mv_par01))

	If mv_par04 == 2
		dbSelectArea("SF2")
		//Alltrim(SF2->F2_DOC) <= Alltrim(mv_par02)
		While !eof() .and. SF2->F2_FILIAL == xFilial("SF2") .and. SF2->F2_DOC <= mv_par02 .and. SF2->F2_SERIE == mv_par03
			If SF2->F2_FIMP=="S"   //.and. aReturn[5] == 3
				Aviso("Alerta","A Nota Fiscal ["+SF2->F2_DOC+"-"+SF2->F2_SERIE+"] ja foi impressa, caso deseja reimprimi-la favor contactar o suporte Durapol",{"OK"},1,"")
				DbSkip()
				Loop
			Endif

			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif

			nLinIni := nLin  // Linha Inicial da Impressao

			// * Cabecalho da Nota Fiscal
			xNUM_NF     :=SF2->F2_DOC             // Numero
			xSERIE      :='U'+SM0->M0_CODFIL      // Serie   // SF2->F2_SERIE
			xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
			xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
			if xTOT_FAT == 0
				xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
			endif
			xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
			xFRETE      :=SF2->F2_FRETE           // Frete
			xSEGURO     :=SF2->F2_SEGURO          // Seguro
			xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
			xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
			xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
			xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
			xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
			xVALISS     :=iif(SF2->F2_BASEISS>0,SF2->F2_VALISS,0) // Valor do ISS
			xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
			xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
			xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
			xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
			xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
			xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
			xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
			xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
			xVEND3      :=SF2->F2_VEND3
			xVEND4      :=SF2->F2_VEND4
			xVend5      :=SF2->F2_VEND5
			xNFFROTA    :=SF2->F2_X_NFFRT
			nD2_PRCVEN  := 0
			nD2_QUANT   := 0

			aCOD_SERV := {}
			aCOD_PROD := {}
			aFrotaTMP := {}
			xPED_VEND:={}                         // Numero do Pedido de Venda
			xITEM_PED:={}                         // Numero do Item do Pedido de Venda
			xNUM_NFDV:={}                         // Numero quando houver devolucao
			xPREF_DV :={}                         // Serie  quando houver devolucao
			xICMS    :={}                         // Porcentagem do ICMS
			xCOD_PRO :={}                         // Codigo  do Produto
			xCOD_SERV:={}                         // Codigo do Servico
			xQTD_PRO :={}                         // Peso/Quantidade do Produto
			xPRE_UNI :={}                         // Preco Unitario de Venda
			xPRE_TAB :={}                         // Preco Unitario de Tabela
			xIPI     :={}                         // Porcentagem do IPI
			xVAL_IPI :={}                         // Valor do IPI
			xDESC    :={}                         // Desconto por Item
			xVAL_DESC:={}                         // Valor do Desconto
			xVAL_MERC:={}                         // Valor da Mercadoria
			xTES     :={}                         // TES
			xCF      :={}                         // Classificacao quanto natureza da Operacao
			xICMSOL  :={}                         // Base do ICMS Solidario
			xICM_PROD:={}                         // ICMS do Produto
			xMensITem:= {}
			_aPedido := {}    
			_nAbater := 0

			//-- busca desconto ( baixa de NCC SEP para a nota ) e inlcui linhas no array de servico ( desconto SEPU ) 
			_lDesconto	:= .F.
			_aDescontos := {}
			_cCount := "00"

			// Tratamento para impressao do desconto
			dbSelectArea("SE5")
			dbSetOrder(1)                                                                              

			//-- busca registro de baixa do uma NCC com prefixo SEP
			//-- busca emissao + banco (SEP) + agencia (00001) + conta (0000000001) + numero do cheque ( serie + nota )
			dbSeek(xFilial("SE5")+DtoS(xEmissao)+"SEP000010000000001"+Alltrim(mv_par03)+Alltrim(xNum_Nf))

			While !Eof() .And. SE5->(E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+Alltrim(E5_NUMCHEQ)) == ;
				xFilial("SE5")+DtoS(xEmissao)+"SEP000010000000001"+Alltrim(mv_par03)+Alltrim(xNum_Nf)

				dbSelectArea("SE1")
				dbSetOrder(1)
				dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)

				_nPos := AScan(_aDescontos,{|x| x[1]+x[2]==SE1->E1_MOTDESC+SE1->E1_COLETA})
				If _nPos == 0
					AAdd(_aDescontos,{SE1->E1_MOTDESC,SE1->E1_COLETA,SE5->E5_VALOR})
				Else
					_aDescontos[_nPos,3] +=	SE5->E5_VALOR
				Endif

				dbSelectArea("SE5")
				dbSkip()
			Enddo

			For _nX := 1 To Len(_aDescontos)
				//_cDescr := 'DESCONTO '+AllTrim(Tabela("DV",_aDescontos[_nX,1]))+" COLETA Nr. "+_aDescontos[_nX,2]
				SZS->( dbSetOrder(1) )
				SZS->( dbSeek(xFilial("SZS")+_aDescontos[_nX,1]) )

				//_cDescr  := 'DESCONTO '+AllTrim(U_StatSEPU(SZS->ZS_TIPO))+" "+_aDescontos[_nX,2]  
				DO CASE
					CASE SZS->ZS_TIPO == "1"
						_cDescr  := "DESCONTO BONIFICACAO DE PNEU RECLAMADO " + _aDescontos[_nX,2] 
					CASE SZS->ZS_TIPO == "2"
						_cDescr  := "DESCONTO BONIFICACAO COMERCIAL COLETA Nr." + _aDescontos[_nX,2] 
					CASE SZS->ZS_TIPO == "3"
						_cDescr  := "DESCONTO BONIFICACAO CONSERTO COLETA Nr. " + _aDescontos[_nX,2] 
					CASE SZS->ZS_TIPO == "4"
						_cDescr  := "DESCONTO CREDITOS DIVERSOS COLETA Nr. " + _aDescontos[_nX,2] 
					CASE SZS->ZS_TIPO == "5"
						_cDescr  := "DESCONTO COLETA Nr. " + _aDescontos[_nX,2] 
					CASE SZS->ZS_TIPO == "6"
						_cDescr  := "DESCONTO BONIFICACAO CUPOM PIRELLI COLETA Nr. " + _aDescontos[_nX,2] 
				ENDCASE

				_cDescr  := AllTrim(_cDescr)
				_aTamSC6 := TamSX3("C6_DESCRI")
				_nTamDes := Len(_cDescr)
				_nEspaco := _aTamSC6[1] - _nTamDes

				If _nEspaco > 0
					_cDescr  := _cDescr + Space(_nEspaco)
				EndIf

				aAdd(aCOD_SERV,{"99"+Soma1(_cCount,2)," "," ","           ",_cDescr,0,(_aDescontos[_nX,3] * -1),"DES","DES"+StrZero(_nX,2)})
			Next

			If Len(_aDescontos) > 0
				_lDesconto := .T.
			Endif	

			dbSelectArea("SD2")                   // * Itens de Venda da N.F.
			dbSetOrder(3)
			dbSeek(xFilial("SD2")+xNUM_NF+mv_par03) //xSERIE
		
			cPedAtu := SD2->D2_PEDIDO
			cItemAtu := SD2->D2_ITEMPV


			While !eof() .and. SD2->D2_DOC== xNUM_NF .and. SD2->D2_SERIE == mv_par03 //xSERIE
				IF SD2->D2_SERIE != mv_par03   // Se a Serie do Arquivo for Diferente
					DbSkip()                   // do Parametro Informado !!!
					Loop
				Endif

				AADD(xPED_VEND ,SD2->D2_PEDIDO)
				AADD(xITEM_PED ,SD2->D2_ITEMPV)
				IF Alltrim(SD2->D2_TP) == "BN"
					AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
					AADD(xPREF_DV  ,SD2->D2_SERIORI)
				EndIF

				AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
				AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
				AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
				AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
				AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
				AADD(xVAL_IPI  ,SD2->D2_VALIPI)
				AADD(xDESC     ,SD2->D2_DESC)
				AADD(xVAL_MERC ,SD2->D2_TOTAL)
				AADD(xTES      ,SD2->D2_TES)
				AADD(xCF       ,SD2->D2_CF)
				AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))

				//Separacao entre mao de obra e devolucao dos produtos
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial()+SD2->D2_COD))

				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial()+SD2->D2_CLIENTE+SD2->D2_LOJA))

				IF !Empty(SA1->A1_BCO1)
					dbSelectArea("SA6")
					dbSetOrder(1)
					dbSeek(xFilial("SA6")+SA1->A1_BCO1)

					cBanco   := SA1->A1_BCO1
					cNomeBco := Alltrim(SA6->A6_NOME)			
				Else
					dbSelectArea("SA6")
					dbSetOrder(1)
					dbSeek(xFilial("SA6")+cBanco)

					cNomeBco := Alltrim(SA6->A6_NOME)				
				EndIF

				SAH->(dbSetOrder(1))
				SAH->(dbSeek(xFilial("SAH")+SD2->D2_UM))

				SC6->(dbSetOrder(1))
				SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))

				_cOP := SC6->C6_NUMOP+SC6->C6_ITEMOP+"001"

				SC2->(dbSetOrder(1))
				SC2->(dbSeek(xFilial("SC2")+_cOP))

				_cDescr := SC6->C6_DESCRI      //	_cDescri 

				_lServico := (SB1->B1_TIPO    == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO    ) .or. ;
				             (SB1->B1_TIPO    == "MO" .and. Alltrim(SB1->B1_GRUPO) $ "SERV/ATEC") .or. ;
				             (SB1->B1_TIPO    == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpSC    ) .or. ;
				             (SA1->A1_CALCCON == "S"  .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO    )

				_lProduto := ! _lServico 			 

				_lSoConserto := .F.

				// Opcao para tratar SO CONSERTO
				If _lProduto .And. At("SC ",Alltrim(SC6->C6_DESCRI)) > 0  //(Substr(SC6->C6_DESCRI,1,8) == "CONS SC "
					_lServico    := .T.
					_lSoConserto := .T.
				Endif	

				_lRecusado := (SD2->D2_TES == '903')

				// SO CONSERTO RECUSADO recusado
				If _lSoConserto
					_nPos := At("RECUSADO ",Alltrim(SC6->C6_DESCRI))
					If _nPos <> 0
						_cDescr := StrTran(SC6->C6_DESCRI,"RECUSADO ","")    //	_cDescri
						_lRecusado := .T.
					Endif
				Endif

				_cSequenc := SD2->D2_PEDIDO+SD2->D2_ITEMPV

				_nPos := AScan(_aPedido,SD2->D2_PEDIDO)
				If _nPos == 0
					AAdd(_aPedido,SD2->D2_PEDIDO)
				Endif

				If _lServico
					//-- se tiver desconto SEPU ( baixa de titulo NCC ) foi feito rateio no desconto da nota
					//-- entao tem que somar total mais desconto para sair valor bruto no item
					//-- se nao tiver imprime direto o valor liquido 
					If _lDesconto
						//-- se tem desconto tem que olhar o campo C6_VALDESC, pois o rateio do SEPU
						//-- foi feito la, se o foi dado outro desconto alterando-se o valor no SC6 
						//-- isto esta contemplado pois a rotina de SEPU rateou o valor liquido
						_nValor := SC6->C6_VALOR+SC6->C6_VALDESC //SD2->D2_TOTAL + SC6->C6_VALDESC   //SD2->D2_DESCON
						//-- acerto para quando o desconto for 100% estamos gravando 0.01 para
						//-- o item sair na nota

						If SD2->D2_PRCVEN == 0.01
							xTOT_FAT -= SD2->D2_TOTAL
							_nAbater += SD2->D2_TOTAL
						Endif	
						//--
					Else
						_nValor := SD2->D2_TOTAL
					Endif	     

					//-- nova unidade de medida 
					//_cUM      := SD2->D2_UM
					_cUM      := Substr(SAH->AH_UMRES,1,7) + " " + Alltrim(Substr(SD2->D2_COD,1,5))
					_nPrcVen  := NoRound( _nValor / SD2->D2_QUANT , 2 )
					_nTotItem := _nValor
					_cFrota   := SD2->D2_COD + SC2->C2_X_DESEN   // produto e banda iguais para juntar na nota de frota
					_cTes     := SD2->D2_TES

					If _lSoConserto 
						_cTes := "902"
					Endif

					If _lRecusado 	// recusado
						_cSequenc := "98"+SD2->D2_ITEMPV
						_cUM      := "RECUSADO   "
					Endif                      

					// posicoes do array de servicos
					_nsSeq    := 1
					_nsGrp    := 2
					_nsQuant  := 3
					_nsUM     := 4
					_nsDescr  := 5
					_nsPrcven := 6
					_nsTotal  := 7
					_nsTES    := 8
					_nsFrota  := 9

					IF SD2->D2_TIPO == "C"
						_nPrcVen := SD2->D2_TOTAL
					EndIF

					aAdd(aCOD_SERV,{_cSequenc                               ,;
					                SB1->B1_GRUPO                           ,;
					                IIF(SD2->D2_TIPO == "C",1,SD2->D2_QUANT),;
					                _cUM                                    ,;
					                _cDescr                                 ,;
					                _nPrcVen                                ,;
					                _nTotItem                               ,;
					                _cTes                                   ,;
					                _cFrota                                 })
				Endif

				If _lProduto
					// posicoes do array de produtos
					_npSeq    := 1
					_npCod	  := 2
					_npDescr  := 3
					_npCF     := 4
					_npUM     := 5
					_npPrcVen := 6
					_npTotal  := 7
					_npQuant  := 8
					_npTES    := 9

					IF SD2->D2_TIPO == "C"
						nD2_PRCVEN := SD2->D2_TOTAL
					Else
						nD2_PRCVEN := SD2->D2_PRCVEN
					EndIF

					aAdd(aCOD_PROD,{_cSequenc      ,;
					                SD2->D2_COD    ,;
					                _cDescr        ,;
					                SD2->D2_CLASFIS,;
					                SD2->D2_UM     ,;
					                nD2_PRCVEN     ,;
					                SD2->D2_TOTAL  ,;
					                SD2->D2_QUANT  ,;
					                SD2->D2_TES    })
				Endif

				DbSelectArea("SD2")                   // * Itens de Venda da N.F.
				SD2->(dbskip())
			EndDo

			// se tiver mais de um pedido considera como frota

			/*
			If Len(_aPedido) > 1
				_lFrota := .T.
			Endif
			*/

			If xNFFROTA = "S" 
				_lFrota := .T.
			Endif

			dbSelectArea("SB1")           // * Desc. Generica do Produto
			dbSetOrder(1)

			xPESO_PRO   :={}              // Peso Liquido
			xPESO_UNIT  :={}              // Peso Unitario do Produto
			xDESCRICAO  :={}              // Descricao do Produto
			xUNID_PRO   :={}              // Unidade do Produto
			xCOD_TRIB   :={}              // Codigo de Tributacao
			xMEN_TRIB   :={}              // Mensagens de Tributacao
			xCOD_FIS    :={}              // Cogigo Fiscal
			xCLAS_FIS   :={}              // Classificacao Fiscal
			xMEN_POS    :={}              // Mensagem da Posicao IPI
			xISS        :={}              // Aliquota de ISS
			xTIPO_PRO   :={}              // Tipo do Produto
			xLUCRO      :={}              // Margem de Lucro p/ ICMS Solidario
			xCLFISCAL   :={}
			xPESO_LIQ   := 0
		
			For I:=1 to Len(xCOD_PRO)
				dbSeek(xFilial()+xCOD_PRO[I])

				AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
				xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
				AADD(xPESO_UNIT , SB1->B1_PESO)
				AADD(xUNID_PRO ,SB1->B1_UM)
				AADD(xDESCRICAO ,SB1->B1_DESC)
				AADD(xCOD_TRIB ,SB1->B1_ORIGEM)

				IF Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
					AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
				Endif

				npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

				IF npElem == 0
					AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
				EndIF

				npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

				DO CASE
					CASE npElem == 1
						_CLASFIS := "A"
					CASE npElem == 2
						_CLASFIS := "B"
					CASE npElem == 3
						_CLASFIS := "C"
					CASE npElem == 4
						_CLASFIS := "D"
					CASE npElem == 5
						_CLASFIS := "E"
					CASE npElem == 6
						_CLASFIS := "F"
				ENDCASE

				nPteste := Ascan(xCLFISCAL,_CLASFIS)

				IF nPteste == 0
					AADD(xCLFISCAL,_CLASFIS)
				EndIF

				AADD(xCOD_FIS ,_CLASFIS)
				IF SB1->B1_ALIQISS > 0
					AADD(xISS ,SB1->B1_ALIQISS)
				Endif
				AADD(xTIPO_PRO ,SB1->B1_TIPO)
				AADD(xLUCRO    ,SB1->B1_PICMRET)

				xPESO_LIQUID:=0   // Peso Liquido da Nota Fiscal

				For j:=1 to Len(xPESO_PRO)
					xPESO_LIQUID := xPESO_LIQUID+xPESO_PRO[j]
				Next j
			Next I

			dbSelectArea("SC5")  // * Pedidos de Venda
			dbSetOrder(1)

			xPED        := {}
			xPESO_BRUTO := 0
			xP_LIQ_PED  := 0

			For I:=1 to Len(xPED_VEND)
				dbSeek(xFilial()+xPED_VEND[I])

				IF ASCAN(xPED,xPED_VEND[I]) == 0
					dbSeek(xFilial("SC5")+xPED_VEND[I])
					IF !Empty(SC5->C5_BANCO)
						dbSelectArea("SA6")
						dbSetOrder(1)
						dbSeek(xFilial("SA6")+SC5->C5_BANCO)

						cBanco   := SC5->C5_BANCO
						cNomeBco := Alltrim(SA6->A6_NOME)
					EndIF					

					xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
					xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
					xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
					xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
					xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
					xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
					xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
					xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
					AADD(xPED,xPED_VEND[I])
				Endif

				IF xP_LIQ_PED >0
					xPESO_LIQ := xP_LIQ_PED
				EndIF
			Next I

			dbSelectArea("SE4")                    // Condicao de Pagamento
			dbSetOrder(1)
			dbSeek(xFilial("SE4")+xCOND_PAG)

			xDESC_PAG := SE4->E4_DESCRI

			dbSelectArea("SC6")                    // * Itens de Pedido de Venda
			dbSetOrder(1)
			xPED_CLI :={}                          // Numero de Pedido
			xDESC_PRO:={}                          // Descricao aux do produto
			J:=Len(xPED_VEND)
			For I:=1 to J
				dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
				AADD(xPED_CLI ,SC6->C6_PEDCLI)
				AADD(xDESC_PRO,SC6->C6_DESCRI)
				AADD(xVAL_DESC,SC6->C6_VALDESC)
			Next j

			xCLIENTE := SF2->F2_CLIENTE
			xLOJA    := SF2->F2_LOJA

			IF xTIPO == 'N' .OR. xTIPO == 'C' .OR. xTIPO =='P' .OR. xTIPO =='I' .OR. xTIPO =='S' .OR. xTIPO =='T' .OR.;
				xTIPO == 'O'

				dbSelectArea("SA1")                // * Cadastro de Clientes
				dbSetOrder(1)
				dbSeek(xFilial()+xCLIENTE+xLOJA)
				xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
				xNOME_CLI:=SA1->A1_NOME            // Nome
				xEND_CLI :=SA1->A1_END             // Endereco
				xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
				xCEP_CLI :=SA1->A1_CEP             // CEP
				xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
				xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
				xMUN_CLI :=SA1->A1_MUN             // Municipio
				xEST_CLI :=SA1->A1_EST             // Estado
				xCGC_CLI :=SA1->A1_CGC             // CGC
				xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
				xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
				xTEL_CLI :=SA1->A1_TEL             // Telefone
				xFAX_CLI :=SA1->A1_FAX             // Fax
				xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
				xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa

				// Alteracao p/ Calculo de Suframa
				IF !empty(xSUFRAMA) .and. xCALCSUF =="S"
					IF xTIPO == 'D' .OR. xTIPO == 'B'
						zFranca := .F.
					Else
						zFranca := .T.
					Endif
				Else
					zfranca:= .F.
				EndIF
			Else
				xSUFRAMA := ""
				zFranca  :=.F.

				dbSelectArea("SA2")                // * Cadastro de Fornecedores
				dbSetOrder(1)
				dbSeek(xFilial()+xCLIENTE+xLOJA)
				xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
				xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
				xEND_CLI :=SA2->A2_END             // Endereco
				xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
				xCEP_CLI :=SA2->A2_CEP             // CEP
				xCOB_CLI :=""                      // Endereco de Cobranca
				xREC_CLI :=""                      // Endereco de Entrega
				xMUN_CLI :=SA2->A2_MUN             // Municipio
				xEST_CLI :=SA2->A2_EST             // Estado
				xCGC_CLI :=SA2->A2_CGC             // CGC
				xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
				xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
				xTEL_CLI :=SA2->A2_TEL             // Telefone
				xFAX_CLI :=SA2->A2_FAX             // Fax
			EndIF

			IF xICMS_RET >0                        // Apenas se ICMS Retido > 0
				dbSelectArea("SF3")                // * Cadastro de Livros Fiscais
				dbSetOrder(4)
				dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)

				IF Found()
					xBSICMRET:=F3_VALOBSE
				Else
					xBSICMRET:=0
				Endif
			Else
				xBSICMRET:=0
			Endif
		
			dbSelectArea("SA4")                   // * Transportadoras
			dbSetOrder(1)
			dbSeek(xFilial()+SF2->F2_TRANSP)

			xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
			xEST_TRANSP  :=SA4->A4_EST            // Estado
			xCGC_TRANSP  :=SA4->A4_CGC            // CGC
			xEND_TRANSP  :=SA4->A4_END            // Endereco
			xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
			xINS_TRANSP  :=SA4->A4_INSEST         // Inscricao estadual

			dbSelectArea("SE1")                   // * Contas a Receber
			dbSetOrder(1)
			xPARC_DUP  :={}                       // Parcela
			xVENC_DUP  :={}                       // Vencimento
			xVALOR_DUP :={}                       // Valor

			xDUPLICATAS := IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

			While !Eof() .and. SE1->E1_NUM == xNUM_DUPLIC .and. xDUPLICATAS == .T.
				IF !("NF" $ SE1->E1_TIPO)
					dbSelectArea("SE1")
					dBSkip()
					Loop
				EndIF

				AADD(xPARC_DUP ,SE1->E1_PARCELA)
				AADD(xVENC_DUP ,SE1->E1_VENCTO)
				AADD(xVALOR_DUP,SE1->E1_VALOR)        

				// TIRAR !!!! COLOCAR EM PONTO DE ENTRADA NA GERACAO DA NOTA !!!!
				IF Empty(SE1->E1_BCO1)
					if Reclock("SE1",.F.)
						SE1->E1_BCO1 := cBanco
						MsUnlock()
					Endif
				EndIF	

				// TIRAR !!!!
				dbSelectArea("SE1")
				dbSkip()
			EndDo

			//-- acerto para quando o desconto for 100% estamos gravando 0.01 para
			//-- o item sair na nota   
			If _lDesconto
				If Len(xVALOR_DUP)>0
					xVALOR_DUP[1] -= _nAbater
				Endif
			Endif	

			cSql := "SELECT DISTINCT D2_CF,F4_TEXTO"
			cSql += " FROM "+RetSqlName("SD2")+" SD2"

			cSql += " JOIN "+RetSqlName("SF4")+" SF4"
			cSql += " ON   SF4.D_E_L_E_T_ = ''"
			cSql += " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
			cSql += " AND  F4_CODIGO = D2_TES"

			cSql += " WHERE SD2.D_E_L_E_T_ = ''"
			cSql += " AND   D2_FILIAL = '"+SF2->F2_FILIAL+"'"
			cSql += " AND   D2_DOC = '"+SF2->F2_DOC+"'"
			cSql += " AND   D2_SERIE = '"+SF2->F2_SERIE+"'" 
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_TXT", .T., .T.)
			dbSelectArea("ARQ_TXT")

			nMax := 1
			xNATUREZA := ""
			cCF := ""
			Do While !Eof() .and. nMax <= 2
				xNATUREZA += AllTrim(F4_TEXTO) + "/"
				cCF += AllTrim(D2_CF) + "/"
				nMax++
				dbSkip()
			Enddo
			xNATUREZA := Substr(xNATUREZA,1,Len(xNATUREZA)-1)
			cCF       := Substr(cCF,1,Len(cCF)-1)
			dbSelectArea("ARQ_TXT")
			dbCloseArea()

			dBSelectArea("SF4")                   // * Tipos de Entrada e Saida
			dBSetOrder(1)
			dBSeek(xFilial("SF4")+xTES[1])

			//xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao


			/*************************************************************************
			Inicio altera��o Folha 2 - Denis Tofoli
			*************************************************************************/

			aFrotaTmp:= {}

			xB_ICMS_SOL:= 0          // Base  do ICMS Solidario
			xV_ICMS_SOL:= 0          // Valor do ICMS Solidario

			//Tratamento para impressao de NFS Frota - Aglutinando os itens iguais
			If _lFrota
				aFrotaTmp := aCod_Serv
				aCod_Serv := {}

				For _j := 1 To Len(aFrotaTmp)
					IF ( nPos := aScan(aCod_Serv,{|x| x[_nsFrota] == aFrotaTmp[_j,_nsFrota]})) > 0
						IF aFrotaTmp[_j,_nsTES] <> "903"
							aCod_Serv[nPos,_nsQuant] += aFrotaTmp[_j,_nsQuant]
							aCod_Serv[nPos,_nsTotal] += aFrotaTmp[_j,_nsTotal]
						EndIF
					Else
						aAdd(aCod_Serv,aFrotaTMP[_j])
					EndIF
				Next _j
			Endif

			// ordena arrays para sair na ordem do pedido
			aCOD_SERV := ASort(aCOD_SERV,,,{|x,y| x[_nsSeq]<y[_nsSeq]})

			/*************************************************************************
			Fim altera��o Folha 2 - Denis Tofoli
			*************************************************************************/
			
			nTamanho := 20
			nFolhas  := int((Len(aCOD_SERV)/nTamanho)+0.99999999999)
			nPagina  := 0

			nFolhas := iif(nFolhas=0,1,nFolhas)

			For nPagina = 1 to nFolhas
				If SM0->M0_CODFIL $ AllTrim(GetMv("MV_NOVANF"))
					Imprime()
				Else
					xImprime()
				Endif
			Next

			IncRegua()
			cBanco   := GetNewPar("MV_X_BCO1","")
			cNomeBco := ""

			dbSelectArea("SF2")
			If aReturn[5] == 3
				If RecLock("SF2",.F.)
					SF2->F2_FIMP := "S"
					MsUnlock()
				Endif
			Endif

			dbSelectArea("SF2")
			dbSkip()  // passa para a proxima Nota Fiscal
		EndDo
	Else
		dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
		dbSeek(xFilial()+mv_par01+mv_par03,.t.)

		While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
			If SF1->F1_SERIE != mv_par03    // Se a Serie do Arquivo for Diferente
				MsgBox("Nao existem notas a serem impressas. Verifique os parametros!","Atencao","INFO") // do Parametro Informado !!!
				DbSkip()
				Loop
			Endif

			//+-----------------------------------------------------------+
			//� Inicializa  regua de impressao                            �
			//+-----------------------------------------------------------+
			SetRegua(Val(mv_par02)-Val(mv_par01))

			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif

			If SF1->F1_FIMP=="S" .and. aReturn[5] == 3
				Aviso("Alerta","A Nota Fiscal ["+SF1->F1_DOC+"-"+SF1->F1_SERIE+"] ja foi impressa, caso deseja reimprimi-la favor contactar o suporte Durapol",{"OK"},1,"")
				Skip()
				Loop
			Endif

			nLinIni := nLin         // Linha Inicial da Impressao

			//+--------------------------------------------------------------+
			//� Inicio de Levantamento dos Dados da Nota Fiscal              �
			//+--------------------------------------------------------------+

			xNUM_NF     := SF1->F1_DOC             // Numero
			xSERIE      := SF1->F1_SERIE           // Serie
			xFORNECE    := SF1->F1_FORNECE         // Cliente/Fornecedor
			xEMISSAO    := SF1->F1_EMISSAO         // Data de Emissao
			xTOT_FAT    := SF1->F1_VALBRUT         // Valor Bruto da Compra
			xLOJA       := SF1->F1_LOJA            // Loja do Cliente
			xFRETE      := SF1->F1_FRETE           // Frete
			xSEGURO     := SF1->F1_DESPESA         // Despesa
			xBASE_ICMS  := SF1->F1_BASEICM         // Base   do ICMS
			xBASE_IPI   := SF1->F1_BASEIPI         // Base   do IPI
			xBSICMRET   := SF1->F1_BRICMS          // Base do ICMS Retido
			xVALOR_ICMS := SF1->F1_VALICM          // Valor  do ICMS
			xICMS_RET   := SF1->F1_ICMSRET         // Valor  do ICMS Retido
			xVALOR_IPI  := SF1->F1_VALIPI          // Valor  do IPI
			xVALOR_MERC := SF1->F1_VALMERC         // Valor  da Mercadoria
			xNUM_DUPLIC := SF1->F1_DUPL            // Numero da Duplicata
			xCOND_PAG   := SF1->F1_COND            // Condicao de Pagamento
			xTIPO       := SF1->F1_TIPO            // Tipo do Cliente
			xNFORI      := "" //SF1->F1_NFORI           // NF Original
			xPREF_DV    := "" //SF1->F1_SERIORI         // Serie Original

			dbSelectArea("SD1")                   // * Itens da N.F. de Compra
			dbSetOrder(1)
			dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)

			cPedAtu := SD1->D1_PEDIDO
			cItemAtu:= SD1->D1_ITEMPC

			xPEDIDO   := {}                         // Numero do Pedido de Compra
			xITEM_PED := {}                         // Numero do Item do Pedido de Compra
			xNUM_NFDV := {}                         // Numero quando houver devolucao
			xPREF_DV  := {}                         // Serie  quando houver devolucao
			xICMS     := {}                         // Porcentagem do ICMS
			xCOD_PRO  := {}                         // Codigo  do Produto
			xQTD_PRO  := {}                         // Peso/Quantidade do Produto
			xPRE_UNI  := {}                         // Preco Unitario de Compra
			xIPI      := {}                         // Porcentagem do IPI
			xPESOPROD := {}                         // Peso do Produto
			xVAL_IPI  := {}                         // Valor do IPI
			xDESC     := {}                         // Desconto por Item
			xVAL_DESC := {}                         // Valor do Desconto
			xVAL_MERC := {}                         // Valor da Mercadoria
			xTES      := {}                         // TES
			xCF       := {}                         // Classificacao quanto natureza da Operacao
			xICMSOL   := {}                         // Base do ICMS Solidario
			xICM_PROD := {}                         // ICMS do Produto
			xMensITem := {}

			while !eof() .and. SD1->D1_DOC==xNUM_NF
				If SD1->D1_SERIE != mv_par03  // Se a Serie do Arquivo for Diferente
					DbSkip()                  // do Parametro Informado !!!
					Loop
				Endif

				AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
				AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
				AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
				AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
				AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
				AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
				AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
				AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
				AADD(xIPI      ,SD1->D1_IPI)            // % IPI
				AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
				AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
				AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
				AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
				AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
				AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
				AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
				dbskip()
			End

			dbSelectArea("SB1")                     // * Desc. Generica do Produto
			dbSetOrder(1)
			xUNID_PRO  := {}                           // Unidade do Produto
			xDESC_PRO  := {}                           // Descricao do Produto
			xMEN_POS   := {}                           // Mensagem da Posicao IPI
			xDESCRICAO := {}                         // Descricao do Produto
			xCOD_TRIB  := {}                           // Codigo de Tributacao
			xMEN_TRIB  := {}                           // Mensagens de Tributacao
			xCOD_FIS   := {}                           // Cogigo Fiscal
			xCLAS_FIS  := {}                           // Classificacao Fiscal
			xISS       := {}                           // Aliquota de ISS
			xTIPO_PRO  := {}                           // Tipo do Produto
			xLUCRO     := {}                           // Margem de Lucro p/ ICMS Solidario
			xCLFISCAL  := {}
			xSUFRAMA   := ""
			xCALCSUF   := ""

			I:=1
			For I:=1 to Len(xCOD_PRO)
				dbSeek(xFilial()+xCOD_PRO[I])
				dbSelectArea("SB1")

				AADD(xDESC_PRO ,SB1->B1_DESC)
				AADD(xUNID_PRO ,SB1->B1_UM)
				AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
				If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
					AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
				Endif
				AADD(xDESCRICAO ,SB1->B1_DESC)
				AADD(xMEN_POS  ,SB1->B1_POSIPI)
				If SB1->B1_ALIQISS > 0
					AADD(xISS,SB1->B1_ALIQISS)
				Endif
				AADD(xTIPO_PRO ,SB1->B1_TIPO)
				AADD(xLUCRO    ,SB1->B1_PICMRET)

				npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

				if npElem == 0
					AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
				endif
				npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

				DO CASE
					CASE npElem == 1
						_CLASFIS := "A"
					CASE npElem == 2
						_CLASFIS := "B"
					CASE npElem == 3
						_CLASFIS := "C"
					CASE npElem == 4
						_CLASFIS := "D"
					CASE npElem == 5
						_CLASFIS := "E"
					CASE npElem == 6
						_CLASFIS := "F"
				EndCase

				nPteste := Ascan(xCLFISCAL,_CLASFIS)
				If nPteste == 0
					AADD(xCLFISCAL,_CLASFIS)
				Endif
				AADD(xCOD_FIS ,_CLASFIS)
			Next I

			//+---------------------------------------------+
			//� Pesquisa da Condicao de Pagto               �
			//+---------------------------------------------+

			dbSelectArea("SE4")                    // Condicao de Pagamento
			dbSetOrder(1)
			dbSeek(xFilial("SE4")+xCOND_PAG)
			xDESC_PAG := SE4->E4_DESCRI

			If xTIPO $ "B/D"
				dbSelectArea("SA1")                // * Cadastro de Clientes
				dbSetOrder(1)
				dbSeek(xFilial()+xFORNECE)
				xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
				xNOME_CLI:=SA1->A1_NOME            // Nome
				xEND_CLI :=SA1->A1_END             // Endereco
				xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
				xCEP_CLI :=SA1->A1_CEP             // CEP
				xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
				xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
				xMUN_CLI :=SA1->A1_MUN             // Municipio
				xEST_CLI :=SA1->A1_EST             // Estado
				xCGC_CLI :=SA1->A1_CGC             // CGC
				xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
				xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
				xTEL_CLI :=SA1->A1_TEL             // Telefone
				xFAX_CLI :=SA1->A1_FAX             // Fax
			Else
				dbSelectArea("SA2")                // * Cadastro de Fornecedores
				dbSetOrder(1)
				dbSeek(xFilial()+xFORNECE+xLOJA)
				xCOD_CLI  := SA2->A2_COD                // Codigo do Cliente
				xNOME_CLI := SA2->A2_NOME               // Nome
				xEND_CLI  := SA2->A2_END                // Endereco
				xBAIRRO   := SA2->A2_BAIRRO             // Bairro
				xCEP_CLI  := SA2->A2_CEP                // CEP
				xCOB_CLI  := ""                         // Endereco de Cobranca
				xREC_CLI  := ""                         // Endereco de Entrega
				xMUN_CLI  := SA2->A2_MUN                // Municipio
				xEST_CLI  := SA2->A2_EST                // Estado
				xCGC_CLI  := SA2->A2_CGC                // CGC
				xINSC_CLI := SA2->A2_INSCR              // Inscricao estadual
				xTRAN_CLI := SA2->A2_TRANSP             // Transportadora
				xTEL_CLI  := SA2->A2_TEL                // Telefone
				xFAX      := SA2->A2_FAX                // Fax
			EndIf

			dbSelectArea("SE1")                   // * Contas a Receber
			dbSetOrder(1)
			xPARC_DUP  :={}                       // Parcela
			xVENC_DUP  :={}                       // Vencimento
			xVALOR_DUP :={}                       // Valor
			xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

			while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
				AADD(xPARC_DUP ,SE1->E1_PARCELA)
				AADD(xVENC_DUP ,SE1->E1_VENCTO)
				AADD(xVALOR_DUP,SE1->E1_VALOR)
				dbSkip()
			EndDo

			dbSelectArea("SF4") // * Tipos de Entrada e Saida
			dbSetOrder(1)
			dbSeek(xFilial()+SD1->D1_TES)
			xNATUREZA    := SF4->F4_TEXTO // Natureza da Operacao
			xNOME_TRANSP := " "           // Nome Transportadora
			xEND_TRANSP  := " "           // Endereco
			xMUN_TRANSP  := " "           // Municipio
			xEST_TRANSP  := " "           // Estado
			xVIA_TRANSP  := " "           // Via de Transporte
			xCGC_TRANSP  := " "           // CGC
			xTEL_TRANSP  := " "           // Fone
			xTPFRETE     := " "           // Tipo de Frete
			xVOLUME      := 0             // Volume
			xESPECIE     := " "           // Especie
			xPESO_LIQ    := 0             // Peso Liquido
			xPESO_BRUTO  := 0             // Peso Bruto
			xCOD_MENS    := " "           // Codigo da Mensagem
			xMENSAGEM    := " "           // Mensagem da Nota
			xPESO_LIQUID := " "

			If SM0->M0_CODFIL $ AllTrim(GetMv("MV_NOVANF"))
				Imprime()
			Else
				xImprime()
			Endif

			//+--------------------------------------------------------------+
			//� Termino da Impressao da Nota Fiscal                          �
			//+--------------------------------------------------------------+

			IncRegua()                    // Termometro de Impressao

			nLin:=4

			If aReturn[5] == 3
				If RecLock("SF1",.F.)
					SF1->F1_FIMP := "S"
					MsUnlock()
				Endif
			Endif

			dbSelectArea("SF1")
			dbSkip()                     // e passa para a proxima Nota Fiscal
		EndDo
	Endif

	dbSelectArea("SF2")
	Retindex("SF2")

	dbSelectArea("SF1")
	Retindex("SF1")

	dbSelectArea("SD2")
	Retindex("SD2")

	dbSelectArea("SD1")
	Retindex("SD1")

	Set Device To Screen

	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � VERIMP   � Autor �   Microsiga       � Data � 03/08/05     ���
��+----------+------------------------------------------------------------���
���Descri��o � Verifica posicionamento de papel na Impressora             ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function VerImp()
	nLin    := 0  // Contador de Linhas
	nLinIni := 0

	IF aReturn[5]== 2
		nOpc := 1
		While .T.
			SetPrc(0,0)
			dbCommitAll()

			@ nLin ,000 PSAY " "
			@ nLin ,004 PSAY "*"
			@ nLin ,022 PSAY "."

			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif

			Do Case
				Case nOpc == 1
					lContinua:=.T.
					Exit
				Case nOpc == 2
					Loop
				Case nOpc==3
					lContinua:=.F.
					Return
			EndCase
		EndDo
	Endif
Return

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � IMPRIME  � Autor �   Microsiga           � Data � 03/08/05 ���
��+----------+------------------------------------------------------------���
���Descri��o � Imprime a Nota Fiscal de Entrada e de Saida c/ cabec       ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Imprime()
	@ 000, 000 PSAY CHR(27)+"0" // 1/8 de polegada
	nLin := 2
	@ nLin,042 PSAY CHR(15)+Capital(AllTrim(SM0->M0_ENDENT))+CHR(18)

	nLin := 3
	@ nLin,042 PSAY CHR(15)+Capital(AllTrim(SM0->M0_BAIRENT)) + " - " + Capital(AllTrim(SM0->M0_CIDENT)) + " - " + Capital(AllTrim(SM0->M0_ESTENT))+CHR(18)

	@ nLin, 100 PSAY xNUM_NF + iif(nFolhas>1," /"+AllTrim(Str(nPagina)),"")           // Numero da Nota Fiscal

	nLin+=1  //4
	@ nLin,042 PSAY CHR(15)+"Telefone: (" + SUBSTR(AllTrim(SM0->M0_TEL),Len(AllTrim(SM0->M0_TEL))-9,2) + ") " + SUBSTR(AllTrim(SM0->M0_TEL),Len(AllTrim(SM0->M0_TEL))-7,4) + "-" + SUBSTR(AllTrim(SM0->M0_TEL),Len(AllTrim(SM0->M0_TEL))-3,4)+CHR(18)
	
	If mv_par04 == 1
		@ nLin, 128 PSAY "X"
	Else
		//@ nLin, 118 PSAY "X"
	Endif

	nLin+=1  //5
	@ nLin,042 PSAY CHR(15)+"Fax: (" + SUBSTR(AllTrim(SM0->M0_FAX),Len(AllTrim(SM0->M0_FAX))-9,2) + ") " + SUBSTR(AllTrim(SM0->M0_FAX),Len(AllTrim(SM0->M0_FAX))-7,4) + "-" + SUBSTR(AllTrim(SM0->M0_FAX),Len(AllTrim(SM0->M0_FAX))-3,4) + " - CEP " + AllTrim(SM0->M0_CEPENT)+CHR(18)
	nLin+=1  //6
	@ nLin,042 PSAY CHR(15)+"E-mail: durapol@dellavia.com.br"+CHR(18)

	nLin+=1
	@ nLin, 67 PSAY SM0->M0_CGC Picture "@R 99.999.999/9999-99"

	nLin+=2   // nLin+=5
	@ nLin,021 PSAY Alltrim(xNATUREZA)                    // Texto da Natureza de Operacao

	If mv_par04 == 1
		@ nLin, 042 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
	Else
		IF Len(xCF) > 1
			IF !Empty(xCF[2]) .and. xCF[1] != xCF[2]
				//@ nLin, 042 PSAY CHR(15)+Alltrim(xCF[1])+"/"+Alltrim(xCF[2])+CHR(18) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
				@ nLin, 042 PSAY Alltrim(cCF) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
			Else
				//@ nLin, 042 PSAY Alltrim(xCF[1]) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
				@ nLin, 042 PSAY Alltrim(cCF) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
			EndIF
		Else
			//@ nLin, 042 PSAY Alltrim(xCF[1]) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
			@ nLin, 042 PSAY Alltrim(cCF) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
		EndIF
	EndIf

	@ nLin,068 PSAY Alltrim(SM0->M0_INSC)                 // Insc. Estadual

	//+-------------------------------------+
	//� Impressao dos Dados do Cliente      �
	//+-------------------------------------+

	nLin+=3
	@ nLin, 021 PSAY LEFT(xNOME_CLI,34)    //Nome do Cliente
	@ nLin, 058 PSAY xCOD_CLI              //Nome do Cliente

	IF !EMPTY(xCGC_CLI)                    // Se o C.G.C. do Cli/Forn nao for Vazio
		@ nLin, 67 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
	Else
		@ nLin, 67 PSAY " "                // Caso seja vazio
	Endif

	@ nLin, 88 PSAY xEMISSAO              // Data da Emissao do Documento

	nLin+=2

	@ nLin, 021 PSAY xEND_CLI                                 // Endereco
	@ nLin, 060 PSAY Left(xBAIRRO,14)                         // Bairro
	@ nLin, 076 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
	@ nLin, 143 PSAY " "                                      // Reservado  p/Data Saida/Entrada

	nLin+=1

	@ nLin, 021 PSAY Alltrim(xMUN_CLI)                                               // Municipio
	@ nLin, 047 PSAY IIF(Substr(xTEL_CLI,1,4) = "0000",Space(15),Alltrim(xTEL_CLI))  // Telefone/FAX
	@ nLin, 064 PSAY Alltrim(xEST_CLI)                                               // U.F.
	@ nLin, 068 PSAY Alltrim(xINSC_CLI)                                              // Insc. Estadual
	@ nLin, 080 PSAY " "                                                             // Reservado p/Hora da Saida

	If mv_par04 == 2
		//+-------------------------------------+
		//� Impressao da Fatura/Duplicata       �
		//+-------------------------------------+
	
		nLin:=18
		bb  :=1
	
		DUPLIC()
	EndIF

	nLin := 23   //18

	if nPagina = 1
		ImpDetProd() //Detalhe da NF (produtos)
	Endif

	nLin := 30   //23

	ImpDetServ() //Detalhe da NF (Servicos executados)

	//Impressao de mensagens no corpo da NF
	if nPagina = nFolhas
		IF mv_par04 == 2
			IF !Empty(xMENSAGEM)
				nLin:=51
				MensObs()             // Imprime Mensagem de Observacao
			EndIF

			IF !Empty(xCOD_MENS)
				nLin:=53
				@ nLin, 35 PSAY UPPER(SUBSTR(FORMULA(xCOD_MENS),1,45)) // Imprime Mensagem Padrao da Nota Fiscal
				nlin:=nlin+1
				IF !Empty(UPPER(SUBSTR(FORMULA(xCOD_MENS),46,45)))
					@ nLin,35 PSAY UPPER(SUBSTR(FORMULA(xCOD_MENS),46,45))
				EndIF
			Endif
		EndIF
	Endif

	//+----------------------+
	//� Prestacao de Servicos�
	//+----------------------+
	If xVALISS > 0
		if nPagina <> nFolhas
			@ 54, 064  PSAY "       ***,**"  /////"@E@Z 99,999,999.99"   // Valor do ISS
			@ 54, 084  PSAY "        ***,**" //////"@E@Z 999,999,999.99"   // Valor do Servico
		Else
			@ 54, 064  PSAY xVALISS  Picture "@E 99,999,999.99"  /////"@E@Z 99,999,999.99"   // Valor do ISS
			@ 54, 084  PSAY xTOT_FAT Picture "@E 999,999,999.99" //////"@E@Z 999,999,999.99"   // Valor do Servico
		Endif
	Endif

	//+-------------------------------------+
	//� Calculo dos Impostos                �
	//+-------------------------------------+
	if nPagina <> nFolhas
		@ 57, 021  PSAY "        ***,**"  // Base do ICMS
		@ 57, 038  PSAY "        ***,**"  // Valor do ICMS
		@ 57, 054  PSAY "        ***,**"  // Base ICMS Ret.
		@ 57, 070  PSAY "        ***,**"  // Valor  ICMS Ret.
		@ 57, 084  PSAY "        ***,**"  // Valor Tot. Prod.

		@ 59, 021  PSAY "        ***,**"  // Valor do Frete
		@ 59, 035  PSAY "        ***,**"  // Valor Seguro
		@ 59, 070  PSAY "        ***,**"  // Valor do IPI
		@ 59, 084  PSAY "        ***,**"   /////"@E@Z 999,999,999.99"  // Valor Total NF
	Else
		@ 57, 021  PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS
		@ 57, 038  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
		@ 57, 054  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
		@ 57, 070  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
		@ 57, 084  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.

		@ 59, 021  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
		@ 59, 035  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
		@ 59, 070  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI
		IF UPPER(ALLTRIM(SA1->A1_TELEX)) = "SOMANF" .AND. xVALISS > 0
		   @ 59, 084  PSAY (xTOT_FAT + xVALOR_MERC) Picture "@E 999,999,999.99"   /////"@E@Z 999,999,999.99"  // Valor Total DE MERCADORIA + SERVICO NF SOLICITADO POR ALEX
		ELSE
		   @ 59, 084  PSAY xTOT_FAT                 Picture "@E 999,999,999.99"   /////"@E@Z 999,999,999.99"  // Valor Total NF
		ENDIF
	Endif

	//+------------------------------------+
	//� Impressao Dados da Transportadora  �
	//+------------------------------------+
	@ 62, 021  PSAY xNOME_TRANSP                       // Nome da Transport.

	If xTPFRETE == 'C' .or. Empty(xTPFRETE)            // Frete por conta do
		@ 62, 064 PSAY "1"                             // Emitente (1)
	Else                                               //     ou
		@ 62, 064 PSAY "2"                             // Destinatario (2)
	Endif

	@ 62, 067 PSAY " "                                  // Res. p/Placa do Veiculo
	@ 62, 077 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

	If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
		@ 62, 082 PSAY xCGC_TRANSP Picture "@R 99.999.999/9999-99"
	Else
		@ 62, 082 PSAY " "                               // Caso seja vazio
	Endif

	@ 64, 021 PSAY xEND_TRANSP                          // Endereco Transp.
	@ 64, 057 PSAY xMUN_TRANSP                          // Municipio
	@ 64, 077 PSAY xEST_TRANSP                          // U.F.
	@ 64, 082 PSAY " "                                  // Reservado p/Insc. Estad.

	if nPagina = nFolhas
		@ 66, 019 PSAY xVOLUME  Picture "@E@Z 999,999.99"             // Quant. Volumes
		@ 66, 035 PSAY "PNEU"                                        // Especie
		@ 66, 047 PSAY "DIVERSAS"                                    // Res para Marca
		@ 66, 075 PSAY xPESO_BRUTO     Picture "@E@Z 999,999.99"      // Res para Peso Bruto

		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)

		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(xFilial("SA3")+xVEND3)

		//@ 069, 020 PSAY SE4->E4_DESCRI   // Condicao de Pagto
		@ 069, 020 PSAY  Chr(15) + AllTrim(SE4->E4_DESCRI) + " / " + Alltrim(SA3->A3_NREDUZ)+" - "+cBanco +" "+ cNomeBco + Chr(18)   // Compactado para Mensagem NF-E

		//@ 70, 020 PSAY Alltrim(SA3->A3_NREDUZ)+'     '+cBanco +' '+ cNomeBco     // Vendedor - Mensagem NF-E

		//nLin := 71
		nLin := 70 // Linha acima para mensagem NF-E

		//Imprime mensagens referente aos itens
		IMPMENSIT()

		nLin := 74 // Para mensagem NF-E
		If xVALISS > 0 .AND. Upper(AllTrim(SM0->M0_CIDENT)) = "SAO PAULO"
			MSGNFE()
		Endif

		IF Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
			@ 77, 020 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
		EndIF

		If !Empty(xSuframa)
			@ 78,21 PSAY "SUFRAMA : "+xSuframa
		EndIf
	Else
		@ 77, 020 PSAY "Continua ..."
	Endif

	@ 82, 088 PSAY xNUM_NF + iif(nFolhas>1," /"+AllTrim(Str(nPagina)),"")   // Numero da Nota Fiscal
	//nLin += 5

	//+------------------------------------+
	//� Posiciona final do formulario      �
	//+------------------------------------+
	@ 87, 000 PSAY Chr(18)

	SetPrc(0,0)                              // (Zera o Formulario)
Return

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � IMPRIME  � Autor �   Microsiga           � Data � 03/08/05 ���
��+----------+------------------------------------------------------------���
���Descri��o � Imprime a Nota Fiscal de Entrada e de Saida s/ cabec       ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function xImprime()
	@ 000, 000 PSAY CHR(27)+"0" // 1/8 de polegada
	nLin := 3
	//@ nLin, 000 PSAY Chr(15)          // Compressao de Impressao
	@ nLin, 090 PSAY xNUM_NF + iif(nFolhas>1," /"+AllTrim(Str(nPagina)),"")           // Numero da Nota Fiscal

	nLin+=1

	If mv_par04 == 1
		@ nLin, 128 PSAY "X"
	Else
		//@ nLin, 118 PSAY "X"
	Endif

	nLin+=5

	@ nLin, 021 PSAY xNATUREZA               // Texto da Natureza de Operacao

	If mv_par04 == 1
		@ nLin, 042 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
	Else
		IF Len(xCF) > 1
			IF !Empty(xCF[2]) .and. xCF[1] != xCF[2]
				//@ nLin, 042 PSAY CHR(15)+Alltrim(xCF[1])+"/"+Alltrim(xCF[2])+CHR(18) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
				@ nLin, 042 PSAY Alltrim(cCF) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
			Else
				//@ nLin, 042 PSAY Alltrim(xCF[1]) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
				@ nLin, 042 PSAY Alltrim(cCF) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
			EndIF
		Else
			//@ nLin, 042 PSAY Alltrim(xCF[1]) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
			@ nLin, 042 PSAY Alltrim(cCF) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
		EndIF
	EndIf

	//+-------------------------------------+
	//� Impressao dos Dados do Cliente      �
	//+-------------------------------------+

	nLin+=3
	@ nLin, 021 PSAY LEFT(xNOME_CLI,34)    //Nome do Cliente
	@ nLin, 058 PSAY xCOD_CLI              //Nome do Cliente

	IF !EMPTY(xCGC_CLI)                    // Se o C.G.C. do Cli/Forn nao for Vazio
		@ nLin, 67 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
	Else
		@ nLin, 67 PSAY " "                // Caso seja vazio
	Endif

	@ nLin, 88 PSAY xEMISSAO              // Data da Emissao do Documento

	nLin+=2

	@ nLin, 021 PSAY xEND_CLI                                 // Endereco
	@ nLin, 060 PSAY Left(xBAIRRO,14)                         // Bairro
	@ nLin, 076 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
	@ nLin, 143 PSAY " "                                      // Reservado  p/Data Saida/Entrada

	nLin+=1

	@ nLin, 021 PSAY Alltrim(xMUN_CLI)                                               // Municipio
	@ nLin, 047 PSAY IIF(Substr(xTEL_CLI,1,4) = "0000",Space(15),Alltrim(xTEL_CLI))  // Telefone/FAX
	@ nLin, 064 PSAY Alltrim(xEST_CLI)                                               // U.F.
	@ nLin, 068 PSAY Alltrim(xINSC_CLI)                                              // Insc. Estadual
	@ nLin, 080 PSAY " "                                                             // Reservado p/Hora da Saida

	If mv_par04 == 2
		//+-------------------------------------+
		//� Impressao da Fatura/Duplicata       �
		//+-------------------------------------+
	
		nLin:=18
		bb  :=1
	
		DUPLIC()
	EndIF

	nLin := 23   //18

	if nPagina = 1
		ImpDetProd() //Detalhe da NF (produtos)
	Endif

	nLin := 30   //23

	ImpDetServ() //Detalhe da NF (Servicos executados)

	//Impressao de mensagens no corpo da NF
	if nPagina = nFolhas
		IF mv_par04 == 2
			IF !Empty(xMENSAGEM)
				nLin:=51
				MensObs()             // Imprime Mensagem de Observacao
			EndIF

			IF !Empty(xCOD_MENS)
				nLin:=53
				@ nLin, 35 PSAY UPPER(SUBSTR(FORMULA(xCOD_MENS),1,45)) // Imprime Mensagem Padrao da Nota Fiscal
				nlin:=nlin+1
				IF !Empty(UPPER(SUBSTR(FORMULA(xCOD_MENS),46,45)))
					@ nLin,35 PSAY UPPER(SUBSTR(FORMULA(xCOD_MENS),46,45))
				EndIF
			Endif
		EndIF
	Endif

	//+----------------------+
	//� Prestacao de Servicos�
	//+----------------------+
	If xVALISS > 0
		if nPagina <> nFolhas
			@ 54, 064  PSAY "       ***,**"  /////"@E@Z 99,999,999.99"   // Valor do ISS
			@ 54, 084  PSAY "        ***,**" //////"@E@Z 999,999,999.99"   // Valor do Servico
		Else
			@ 54, 064  PSAY xVALISS  Picture "@E 99,999,999.99"  /////"@E@Z 99,999,999.99"   // Valor do ISS
			@ 54, 084  PSAY xTOT_FAT Picture "@E 999,999,999.99" //////"@E@Z 999,999,999.99"   // Valor do Servico
		Endif
	Endif

	//+-------------------------------------+
	//� Calculo dos Impostos                �
	//+-------------------------------------+
	if nPagina <> nFolhas
		@ 57, 021  PSAY "        ***,**"  // Base do ICMS
		@ 57, 038  PSAY "        ***,**"  // Valor do ICMS
		@ 57, 054  PSAY "        ***,**"  // Base ICMS Ret.
		@ 57, 070  PSAY "        ***,**"  // Valor  ICMS Ret.
		@ 57, 084  PSAY "        ***,**"  // Valor Tot. Prod.

		@ 59, 021  PSAY "        ***,**"  // Valor do Frete
		@ 59, 035  PSAY "        ***,**"  // Valor Seguro
		@ 59, 070  PSAY "        ***,**"  // Valor do IPI
		@ 59, 084  PSAY "        ***,**"   /////"@E@Z 999,999,999.99"  // Valor Total NF
	Else
		@ 57, 021  PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS
		@ 57, 038  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
		@ 57, 054  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
		@ 57, 070  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
		@ 57, 084  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.

		@ 59, 021  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
		@ 59, 035  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
		@ 59, 070  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI
		IF UPPER(ALLTRIM(SA1->A1_TELEX)) = "SOMANF" .AND. xVALISS > 0
		   @ 59, 084  PSAY (xTOT_FAT + xVALOR_MERC) Picture "@E 999,999,999.99"   /////"@E@Z 999,999,999.99"  // Valor Total DE MERCADORIA + SERVICO NF SOLICITADO POR ALEX
		ELSE
		   @ 59, 084  PSAY xTOT_FAT                 Picture "@E 999,999,999.99"   /////"@E@Z 999,999,999.99"  // Valor Total NF
		ENDIF
	Endif

	//+------------------------------------+
	//� Impressao Dados da Transportadora  �
	//+------------------------------------+
	@ 62, 021  PSAY xNOME_TRANSP                       // Nome da Transport.

	If xTPFRETE == 'C' .or. Empty(xTPFRETE)            // Frete por conta do
		@ 62, 064 PSAY "1"                             // Emitente (1)
	Else                                               //     ou
		@ 62, 064 PSAY "2"                             // Destinatario (2)
	Endif

	@ 62, 067 PSAY " "                                  // Res. p/Placa do Veiculo
	@ 62, 077 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

	If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
		@ 62, 082 PSAY xCGC_TRANSP Picture "@R 99.999.999/9999-99"
	Else
		@ 62, 082 PSAY " "                               // Caso seja vazio
	Endif

	@ 64, 021 PSAY xEND_TRANSP                          // Endereco Transp.
	@ 64, 057 PSAY xMUN_TRANSP                          // Municipio
	@ 64, 077 PSAY xEST_TRANSP                          // U.F.
	@ 64, 082 PSAY " "                                  // Reservado p/Insc. Estad.

	if nPagina = nFolhas
		@ 66, 019 PSAY xVOLUME  Picture "@E@Z 999,999.99"             // Quant. Volumes
		@ 66, 035 PSAY "PNEU"                                        // Especie
		@ 66, 047 PSAY "DIVERSAS"                                    // Res para Marca
		@ 66, 075 PSAY xPESO_BRUTO     Picture "@E@Z 999,999.99"      // Res para Peso Bruto

		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)

		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(xFilial("SA3")+xVEND3)

		//@ 069, 020 PSAY SE4->E4_DESCRI   // Condicao de Pagto
		@ 069, 020 PSAY  Chr(15) + AllTrim(SE4->E4_DESCRI) + " / " + Alltrim(SA3->A3_NREDUZ)+" - "+cBanco +" "+ cNomeBco + Chr(18)   // Compactado para Mensagem NF-E

		//@ 70, 020 PSAY Alltrim(SA3->A3_NREDUZ)+'     '+cBanco +' '+ cNomeBco     // Vendedor - Mensagem NF-E

		//nLin := 71
		nLin := 70 // Linha acima para mensagem NF-E

		//Imprime mensagens referente aos itens
		IMPMENSIT()

		nLin := 74 // Para mensagem NF-E
		If xVALISS > 0 .AND. Upper(AllTrim(SM0->M0_CIDENT)) = "SAO PAULO"
			MSGNFE()
		Endif

		IF Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
			@ 77, 020 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
		EndIF

		If !Empty(xSuframa)
			@ 78,21 PSAY "SUFRAMA : "+xSuframa
		EndIf
	Else
		@ 77, 020 PSAY "Continua ..."
	Endif

	@ 82, 088 PSAY xNUM_NF + iif(nFolhas>1," /"+AllTrim(Str(nPagina)),"")   // Numero da Nota Fiscal
	//nLin += 5

	//+------------------------------------+
	//� Posiciona final do formulario      �
	//+------------------------------------+
	@ 87, 000 PSAY Chr(18)

	SetPrc(0,0)                              // (Zera o Formulario)
Return

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � DUPLIC   � Autor �   Microsiga           � Data � 03/08/05 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao do Parcelamento das Duplicacatas                 ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function DUPLIC()
	Local BB

	nCol := 31
	nAjuste := 0
	For BB:= 1 to Len(xVALOR_DUP)
		If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
			IF BB == 3
				nLin :=nLin+1
				nCol := 31
				nAjuste := 0
			EndIF
			@ nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + xPARC_DUP[BB]
			@ nLin, nCol + 09 + nAjuste PSAY xVENC_DUP[BB]
			@ nLin, nCol + 19 + nAjuste PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
			nAjuste := nAjuste + 34
		Endif
	Next
Return


/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � ImpDetProd � Autor �   Microsiga         � Data � 03/08/05 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao de Linhas de Detalhe dos produtos                ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ImpDetProd()
	Local i          := 1
	Local _j         := 1
	Local _nTotItem  := 0
	LOCAL _nPrcVen   := 0
	Local _nTotal    := 0
	Local cCodAnter  := ""
	Local lCarcDevol := .F.  
	Local lCarcRecau := .F.

	nTamDet :=4            // Tamanho da Area de Detalhe para os produtos

	xB_ICMS_SOL:=0          // Base  do ICMS Solidario
	xV_ICMS_SOL:=0          // Valor do ICMS Solidario

	// ordena arrays para sair na ordem do pedido
	aCOD_PROD := ASort(aCOD_PROD,,,{|x,y| x[_npSeq]<y[_npSeq]})

	For _j := 1 To Len(aCOD_PROD)
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+aCOD_PROD[_j,_npTES])
		IF !Empty(SF4->F4_MSG1)
			IF cCodAnter != aCOD_PROD[_j,_npTES]
				cCodAnter := aCOD_PROD[_j,_npTES]
				aAdd(xMensITem,SF4->F4_MSG1)
			EndIF
		EndIF

		IF aCOD_PROD[_j,_npTES] !=  "503"
			_nTotal     += aCOD_PROD[_j,_npTotal]
			xVALOR_MERC := _nTotal
		EndIF

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+aCOD_PROD[_j,_npCod])
		IF Alltrim(SB1->B1_GRUPO) == "CARC"
			lCarcDevol := .T.
			lCarcRecau := .T.
			IF aCOD_PROD[_j,_npTes] == "906" // by golo
				
				xVolume := xVolume + aCOD_PROD[_j,_npQuant]
			else
			    xVolume ++
			endif 
		EndIF
	Next _j

	if lCarcDevol .and. Len(aCOD_PROD) > 0
	    IF lCarcRecau // by golo
			@ nLin, 020  PSAY Alltrim(Str(xVolume))+" CARCACA(s) PNEU"
	    else
			@ nLin, 020  PSAY Alltrim(Str(xVolume))+" PNEU(s) DEVOLUCAO"
	    endif
		@ nLin, 070  PSAY aCOD_PROD[I,_npCF]
		@ nLin, 074  PSAY aCOD_PROD[I,_npUM]
		@ nLin, 076  PSAY aCOD_PROD[I,_npPrcVen] Picture "@E 99,999.99"
		@ nLin, 086  PSAY _nTotal                Picture "@E 999,999.99"
		vTelex := vTelex + _nTotal
		nLin ++
	Endif

	For I:=1 to Len(aCOD_PROD)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+aCOD_PROD[I,_npCod])
		IF Alltrim(SB1->B1_GRUPO) <> "CARC"
			@ nLin, 023  PSAY LEFT(aCOD_PROD[I,_npDescr],18)
			@ nLin, 043  PSAY aCOD_PROD[I,_npQuant] Picture "@E 99,999.99"  // Qtd. das bandas
			@ nLin, 070  PSAY aCOD_PROD[I,_npCF]
			@ nLin, 074  PSAY aCOD_PROD[I,_npUM]
			@ nLin, 076  PSAY aCOD_PROD[I,_npPrcVen] Picture "@E 99,999.99"
			@ nLin, 086  PSAY aCOD_PROD[I,_npTotal] Picture "@E 999,999.99"
			nLin ++
		Endif
	Next
Return

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � ImpDetServ � Autor �   Microsiga         � Data � 03/08/05 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao de Linhas de Detalhe dos Servicos                ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ImpDetServ
	Local nTamDet  := nTamanho      // Tamanho da Area de Detalhe para os servicos

	// impressao dos servicos
	nLin_Serv := nLin

	For I:=1+((nPagina-1)*nTamDet) to nTamDet*nPagina //Len(aCOD_SERV)
		IF I <= Len(aCOD_SERV)
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+aCOD_SERV[i,_nsTES]))
			IF !Empty(SF4->F4_MSG1)
				IF Len(xMensITem) == 0
					aAdd(xMensITem,SF4->F4_MSG1)
				EndIF
			EndIF
			@ nLin, 019  PSAY aCOD_SERV[I,_nsQuant] // qtde
			@ nLin, 022  PSAY CHR(15)+aCOD_SERV[I,_nsUM]+CHR(18) // unidade de medida
			//@ nLin, 035  PSAY CHR(15)+aCOD_SERV[I,_nsDescr]+CHR(18) // descricao                  
			@ nLin, 040  PSAY CHR(15)+aCOD_SERV[I,_nsDescr]+CHR(18) // descricao                  

			//nao imprime valor para itens recusados e para servicos internos
			IF aCOD_SERV[I,_nsTES] <> "903" .And. aCOD_SERV[I,_nsTES] <> "902" 
				If aCOD_SERV[I,_nsTES] <> "DES"
					@ nLin, 077 PSAY aCOD_SERV[I,_nsPrcven] Picture "@E 999,999.99"
				Endif
				@ nLin, 088 PSAY aCOD_SERV[I,_nsTotal] Picture "@E 999,999.99"
			EndIF
		EndIF
		nLin ++
	Next I
	nLin := 50
Return

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � IMPMENSIT� Autor �   Microsiga           � Data � 03/08/05 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao referente aos itens da NF caso haja devolucao    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function IMPMENSIT()
	nCol    := 20
	cTesAnt := ""

	For _k := 1 To Len(xMensITem)
		IF cTesAnt <> xMensITem[_k]
			@ nLin, nCol PSAY Substr(FORMULA(xMensITem[_k]),1,38)
			nLin := nLin +1
			@ nLin, nCol PSAY Substr(FORMULA(xMensITem[_k]),39,38)
			nLin := nLin +1
			@ nLin, nCol PSAY Substr(FORMULA(xMensITem[_k]),77,38)
			nLin := nLin +1
			@ nLin, nCol PSAY Substr(FORMULA(xMensITem[_k]),115,38)
			nLin := nLin +1
			cTesAnt := xMensITem[_k]
		EndIF
	Next _k
Return

Static Function MSGNFE()
	@ nLin,20 PSAY Chr(15)+"O REGISTRO DAS OPERACOES RELATIVAS A PRESTACAO DE SERVICOS,"+Chr(18)
	nLin ++
	@ nLin,20 PSAY Chr(15)+"CONSTANTE DESTE DOCUMENTO, SERA CONVERTIDO EM NOTA FISCAL"+Chr(18)
	nLin ++
	@ nLin,20 PSAY Chr(15)+"ELETRONICA DE SERVICOS - NF-E."+Chr(18)
	nLin ++
Return nil

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � MENSOBS  � Autor �   Microsiga           � Data � 03/08/05 ���
��+----------+------------------------------------------------------------���
���Descri��o � Impressao Mensagem no Campo Observacao                     ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function MENSOBS()
	nTamObs := 45
	nCol    := 35

	@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
	nlin:=nlin+1
	@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,46,nTamObs))
Return