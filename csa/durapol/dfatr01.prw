#include "rwmake.ch"

User Function DFatr01()


//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦
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
nomeprog  :="DFATR01"
cPerg     :="DFAT01"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "DFATR01"
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
Private cBanco   := GetMV("MV_X_BCO1")
Private cNomeBco := ""
//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

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
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))

If mv_par04 == 2
	dbSelectArea("SF2")
	//Alltrim(SF2->F2_DOC) <= Alltrim(mv_par02)
	While !eof() .and. SF2->F2_FILIAL == xFilial("SF2") .and.;
		SF2->F2_DOC <= mv_par02 .and. ;
		SF2->F2_SERIE == mv_par03
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		// * Cabecalho da Nota Fiscal
		
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
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
		xVALISS     :=SF2->F2_VALISS          // Valor do ISS
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
		lDescont	:= .F.
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		
		
		aCOD_SERV := {}//0,"","",0,0,0}
		aCOD_PROD := {}//"","","","","",0,0}
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
		xSUFRAMA := ""
		While !eof() .and. SD2->D2_DOC== xNUM_NF .and. SD2->D2_SERIE == xSERIE
			
			IF SD2->D2_SERIE != mv_par03        // Se a Serie do Arquivo for Diferente
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
			
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
			
			_cOP := SC6->C6_NUMOP+SC6->C6_ITEMOP+"001"
			
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+_cOP))
			
			_cDesc := Alltrim(SC2->C2_PRODUTO)+" "+Alltrim(SC2->C2_CARCACA)+" "+IIF(Empty(SC2->C2_NUMFOGO),SC2->C2_SERIEPN,"NF-"+SC2->C2_NUMFOGO)
			
			IF SA1->A1_GRPVEN != "FROTA" //Impressao de NFS normal, ou seja conforme sequencia de producao
				IF (SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO ) .or. (SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) == "SERV") .or. ;
					(SA1->A1_CALCCON == "S" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO) .or.(SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpSC )
					IF SD2->D2_TES != '903' .OR. Alltrim(SB1->B1_GRUPO) $ 'CI/SC'
						//Tratamento para impressao do desconto
						dbSelectArea("SE1")
						dbSetOrder(1)
						IF dbSeek(xFilial("SE1")+'SEP'+SD2->D2_DOC+"A"+"NCC")
							IF !lDescont
								//Deveremos fazer o tratamento para a impressao de todos as descricoes dos descontos
								aAdd(aCOD_SERV,{'98'+Soma1(SD2->D2_ITEMPV,2),;
								'SERV',1,'UN','(-) '+'DESCONTO',SE1->E1_VALOR,SE1->E1_VALOR,;
								'902',SD2->D2_PEDIDO,SOMA1(SD2->D2_ITEMPV,2),_cOP})
								
								lDescont := .T.
							EndIF
							//Substituir estas variaveis no array abaixo
							nPrcVend := SD2->D2_TOTAL+SD2->D2_DESCON 
							nTotItem := SD2->D2_TOTAL+SD2->D2_DESCON
						Else
							nPrcVend := SD2->D2_PRCVEN
							nTotItem := SD2->D2_TOTAL
						EndIF
						IF SD2->D2_TES == '903' //.and. Alltrim(SB1->B1_GRUPO) $ 'CI/SC'
							aAdd(aCOD_SERV,{"99"+SC6->C6_ITEM,SB1->B1_GRUPO,SC2->C2_QUANT,"RECUSADO",IIF(Alltrim(SB1->B1_GRUPO) == 'SC',SB1->B1_DESC,_cDesc),;
							SD2->D2_PRCVEN,SD2->D2_TOTAL,SD2->D2_TES,SD2->D2_PEDIDO,SD2->D2_ITEMPV,""})	
						Else
							aAdd(aCOD_SERV,{SC6->C6_ITEMOP+SC6->C6_ITEM,SB1->B1_GRUPO,SD2->D2_QUANT,SD2->D2_UM,SB1->B1_DESC,nPrcVend,nTotItem,SD2->D2_TES,SD2->D2_PEDIDO,SD2->D2_ITEMPV,_cOP})
						EndIF	
					Else
						aAdd(aCOD_SERV,{"99"+SC6->C6_ITEM,SB1->B1_GRUPO,SC2->C2_QUANT,"RECUSADO",IIF(Alltrim(SB1->B1_GRUPO) == 'SC',SB1->B1_DESC,_cDesc),;
						SD2->D2_PRCVEN,SD2->D2_TOTAL,SD2->D2_TES,SD2->D2_PEDIDO,SD2->D2_ITEMPV,""})
					EndIF
				Else
					aAdd(aCOD_PROD,{SD2->D2_COD,SB1->B1_DESC,SB1->B1_CLASFIS,SD2->D2_CLASFIS,SD2->D2_UM,SD2->D2_PRCVEN,SD2->D2_TOTAL,SD2->D2_QUANT,SD2->D2_TES,_cOP,SD2->D2_PEDIDO,SD2->D2_ITEMPV,SB1->B1_GRUPO})
				EndIF
			Else //Tratamento para impressao da NFS Frota
				IF (SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO ) .or. (SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) == "SERV") .or. ;
					(SA1->A1_CALCCON == "S" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpRO) .or.(SB1->B1_TIPO == "MO" .and. Alltrim(SB1->B1_GRUPO) $ _cGrpSC )
					IF SD2->D2_TES != '903'
						aAdd(aFrotaTMP,{SD2->D2_COD+SC2->C2_X_DESEN,SB1->B1_GRUPO,SD2->D2_QUANT,SD2->D2_UM,SB1->B1_DESC,SD2->D2_PRCVEN,SD2->D2_TOTAL,SD2->D2_TES,SD2->D2_PEDIDO,SD2->D2_ITEMPV,_cOP})
					Else
						aAdd(aFrotaTMP,{SD2->D2_COD+SC2->C2_X_DESEN,SB1->B1_GRUPO,SC2->C2_QUANT,"RECUSADO",_cDesc,SD2->D2_PRCVEN,SD2->D2_TOTAL,SD2->D2_TES,SD2->D2_PEDIDO,SD2->D2_ITEMPV,""})
					EndIF
				Else
					aAdd(aCOD_PROD,{SD2->D2_COD,SB1->B1_DESC,SB1->B1_CLASFIS,SD2->D2_CLASFIS,SD2->D2_UM,SD2->D2_PRCVEN,SD2->D2_TOTAL,SD2->D2_QUANT,SD2->D2_TES,_cOP,SD2->D2_PEDIDO,SD2->D2_ITEMPV,SB1->B1_GRUPO})
				EndIF
			EndIF
			dbSelectArea("SD2")                   // * Itens de Venda da N.F.
			SD2->(dbskip())
			
		EndDo
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		
		xPESO_PRO:={}                           // Peso Liquido
		xPESO_UNIT :={}                         // Peso Unitario do Produto
		xDESCRICAO :={}                         // Descricao do Produto
		xUNID_PRO:={}                           // Unidade do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xPESO_LIQ := 0
		
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
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xPESO_BRUTO := 0
		xP_LIQ_PED  := 0
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial()+xPED_VEND[I])
			
			IF ASCAN(xPED,xPED_VEND[I]) == 0
				dbSeek(xFilial()+xPED_VEND[I])
				
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
			zFranca:=.F.
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
		
		IF xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
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
				dBSkip()
				Loop
			EndIF
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			IF Empty(SE1->E1_BCO1)
				Reclock("SE1",.F.)
					SE1->E1_BCO1 := cBanco
				Msunlock()
			EndIF	

			dbSkip()
		EndDo
		
		dBSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dBSetOrder(1)
		dBSeek(xFilial("SF4")+xTES[1])
		
		xNATUREZA := SF4->F4_TEXTO              // Natureza da Operacao
		
		
		Imprime()
		
		IncRegua()                    // Termometro de Impressao
		
		//		nLin:=16 ELY
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
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
		//¦ Inicializa  regua de impressao                            ¦
		//+-----------------------------------------------------------+
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		xNFORI      :="" //SF1->F1_NFORI           // NF Original
		xPREF_DV    :="" //SF1->F1_SERIORI         // Serie Original
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Compra
		xIPI     :={}                         // Porcentagem do IPI
		xPESOPROD:={}                         // Peso do Produto
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xMensITem       := {}
		while !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE != mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
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
		xUNID_PRO:={}                           // Unidade do Produto
		xDESC_PRO:={}                           // Descricao do Produto
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xDESCRICAO :={}                         // Descricao do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xSUFRAMA :=""
		xCALCSUF :=""
		
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
		//¦ Pesquisa da Condicao de Pagto               ¦
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
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			xEND_CLI :=SA2->A2_END                // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
			xCEP_CLI :=SA2->A2_CEP                // CEP
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			
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
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_TES)
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		xNOME_TRANSP :=" "           // Nome Transportadora
		xEND_TRANSP  :=" "           // Endereco
		xMUN_TRANSP  :=" "           // Municipio
		xEST_TRANSP  :=" "           // Estado
		xVIA_TRANSP  :=" "           // Via de Transporte
		xCGC_TRANSP  :=" "           // CGC
		xTEL_TRANSP  :=" "           // Fone
		xTPFRETE     :=" "           // Tipo de Frete
		xVOLUME      := 0            // Volume
		xESPECIE     :=" "           // Especie
		xPESO_LIQ    := 0            // Peso Liquido
		xPESO_BRUTO  := 0            // Peso Bruto
		xCOD_MENS    :=" "           // Codigo da Mensagem
		xMENSAGEM    :=" "           // Mensagem da Nota
		xPESO_LIQUID :=" "
		
		
		Imprime()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=4
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



/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMP   ¦ Autor ¦   Microsiga       ¦ Data ¦ 11/04/55     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Durapol                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
IF aReturn[5]== 2
	
	nOpc       := 1
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
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/


Static Function Imprime()
@ 000, 000 PSAY CHR(27)+"0" //1/8
nLin      := 3
//@ nLin, 000 PSAY Chr(15)                // Compressao de Impressao

@ nLin, 090 PSAY xNUM_NF                // Numero da Nota Fiscal

nLin+=1

If mv_par04 == 1
	@ nLin, 128 PSAY "X"
Else
	//   @ nLin, 118 PSAY "X"
Endif

nLin+=5

@ nLin, 021 PSAY xNATUREZA               // Texto da Natureza de Operacao

If mv_par04 == 1
	@ nLin, 042 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else
	@ nLin, 042 PSAY xCF[1] Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
EndIf


//+-------------------------------------+
//¦ Impressao dos Dados do Cliente      ¦
//+-------------------------------------+

nLin+=3

@ nLin, 021 PSAY LEFT(xNOME_CLI,34)    //Nome do Cliente
@ nLin, 058 PSAY xCOD_CLI              //Nome do Cliente

IF !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
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

@ nLin, 021 PSAY Alltrim(xMUN_CLI)                               // Municipio)
@ nLin, 047 PSAY IIF(Substr(xTEL_CLI,1,4) = "0000",Space(15),Alltrim(xTEL_CLI))                              // Telefone/FAX
@ nLin, 064 PSAY Alltrim(xEST_CLI)                               // U.F.
@ nLin, 068 PSAY Alltrim(xINSC_CLI)                              // Insc. Estadual
@ nLin, 080 PSAY " "                                    // Reservado p/Hora da Saida

If mv_par04 == 2
	
	//+-------------------------------------+
	//¦ Impressao da Fatura/Duplicata       ¦
	//+-------------------------------------+
	
	nLin:=18
	bb  :=1
	
	DUPLIC()
	
EndIF

nLin := 23//18

ImpDetProd() //Detalhe da NF (produtos)


nLin := 30  //23

ImpDetServ() //Detalhe da NF (Servicos executados)

//Impressao de mensagens no corpo da NF

IF mv_par04 == 2
	
	IF !Empty(xMENSAGEM)
		nLin:=50
		MensObs()             // Imprime Mensagem de Observacao
	EndIF
	
	IF!Empty(xCOD_MENS)
		nLin:=53
		@ nLin, 35 PSAY UPPER(SUBSTR(FORMULA(xCOD_MENS),1,45)) // Imprime Mensagem Padrao da Nota Fiscal
		nlin:=nlin+1
		IF !Empty(UPPER(SUBSTR(FORMULA(xCOD_MENS),46,45)))
			@ nLin,35 PSAY UPPER(SUBSTR(FORMULA(xCOD_MENS),46,45))
		EndIF
	Endif
EndIF

//+----------------------+
//¦ Prestacao de Servicos¦
//+----------------------+

If xVALISS > 0
	@ 54, 064  PSAY xVALISS  Picture "@E@Z 99,999,999.99"   // Valor do ISS
	@ 54, 084  PSAY xTOT_FAT Picture "@E@Z 999,999,999.99"   // Valor do Servico
Endif
//+-------------------------------------+
//¦ Calculo dos Impostos                ¦
//+-------------------------------------+

@ 57, 021  PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS
@ 57, 038  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
@ 57, 054  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
@ 57, 070  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
@ 57, 084  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.

@ 59, 021  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
@ 59, 035  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
@ 59, 070  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI
@ 59, 084  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF


//+------------------------------------+
//¦ Impressao Dados da Transportadora  ¦
//+------------------------------------+

@ 62, 021  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE == 'C' .or. Empty(xTPFRETE)            // Frete por conta do
	@ 62, 064 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 62, 064 PSAY "2"                              // Destinatario (2)
Endif

@ 62, 067 PSAY " "                                  // Res. p/Placa do Veiculo
@ 62, 077 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 62, 082 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 62, 082 PSAY " "                               // Caso seja vazio
Endif

@ 64, 021 PSAY xEND_TRANSP                          // Endereco Transp.
@ 64, 057 PSAY xMUN_TRANSP                          // Municipio
@ 64, 077 PSAY xEST_TRANSP                          // U.F.
@ 64, 082 PSAY " "                                  // Reservado p/Insc. Estad.

@ 66, 019 PSAY xVOLUME  Picture"@E@Z 999,999.99"             // Quant. Volumes
@ 66, 035 PSAY "PNEU"                                        // Especie
@ 66, 047 PSAY "DIVERSAS"                                    // Res para Marca
@ 66, 075 PSAY xPESO_BRUTO     Picture"@E@Z 999,999.99"      // Res para Peso Bruto


dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+xCOND_PAG)

@ 069, 020 PSAY SE4->E4_DESCRI   // Condicao de Pagto

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+xVEND3)

@ 70, 020 PSAY Alltrim(SA3->A3_NREDUZ)+'     '+cBanco +' '+ cNomeBco     // Vendedor

nLin := 71

//Imprime mensagens referente aos itens
IMPMENSIT()

IF Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
	@ 77, 020 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
EndIF

If !Empty(xSuframa)
	@ 78,21 PSAY "SUFRAMA : "+xSuframa
EndIf

@ 82, 088 PSAY xNUM_NF                   // Numero da Nota Fiscal
//nLin += 5

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona final do formulario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 87, 000 PSAY Chr(18)

SetPrc(0,0)                              // (Zera o Formulario)


Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ DUPLIC   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao do Parcelamento das Duplicacatas                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

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

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ImpDetProd ¦ Autor ¦   Microsiga         ¦ Data ¦ 11/04/05 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Durapol                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ImpDetProd()

Local i := _j := 1
Local _nTotItem := 0
Local _nTotal   := 0
Local cCodAnter := ""

nTamDet :=4            // Tamanho da Area de Detalhe para os produtos

xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

For I:=1 to Len(aCOD_PROD)
	IF I == 1
		For _j := 1 To Len(aCOD_PROD)
			IF aCOD_PROD[_j,9] !=  "503"
				_nTotal     += aCOD_PROD[_j,7]
				xVALOR_MERC := _nTotal
			EndIF
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4")+aCOD_PROD[_j,9])
			IF !Empty(SF4->F4_FORMULA)
				IF cCodAnter != aCOD_PROD[_j,9]
					aAdd(xMensITem,SF4->F4_FORMULA)
				EndIF
			EndIF
		Next _j
	EndIF
	
	IF xCF[I] <> "5916"	 .and. xCF[I] <> "5949"  //Caso seja NF de venda remessa para sucata
		@ nLin, 023  PSAY LEFT(aCOD_PROD[I,2],18) //  + " - " + transform(aCOD_PROD[I,8],"@E 99,999.99")
		@ nLin, 043  PSAY aCOD_PROD[I,8] Picture "@E 99,999.99"  //Qtd. das bandas
		@ nLin, 070  PSAY aCOD_PROD[I,4]
		@ nLin, 074  PSAY aCOD_PROD[I,5]
		@ nLin, 076  PSAY aCOD_PROD[I,6] Picture "@E 99,999.99"
		@ nLin, 086  PSAY aCOD_PROD[I,7] Picture "@E 999,999.99"
		J:=J+1
	ElseIF I == 1
		For _l :=1 To Len(aCOD_PROD)
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+aCOD_PROD[_l,1])
			IF Alltrim(SB1->B1_GRUPO) == "CARC"
				xVolume := xVolume +1
			EndIF
		Next _l
		@ nLin, 020  PSAY Alltrim(Str(xVolume))+" PNEU(s) DEVOLUCAO"
		@ nLin, 023  PSAY aCOD_PROD[I,3]
		@ nLin, 070  PSAY aCOD_PROD[I,4]
		@ nLin, 074  PSAY aCOD_PROD[I,5]
		@ nLin, 076  PSAY aCOD_PROD[I,6] Picture "@E 99,999.99"
		@ nLin, 086  PSAY _nTotal        Picture "@E 999,999.99"
	EndIF
	nLin :=nLin+1
Next -
Return

Static Function ImpDetServ

Local _l:=1
Local nTamDet  :=19      // Tamanho da Area de Detalhe para os servicos
Local cDesenho := ""
Local cCarcaca := ""
Local cNF_Ser  := ""
Local aNewFrota:= {}
Local lImpOk   := .F. 

xB_ICMS_SOL:= 0          // Base  do ICMS Solidario
xV_ICMS_SOL:= 0          // Valor do ICMS Solidario
aCOD_SERV  := ASORT(aCOD_SERV,,,{|X,Y| X[1] < Y[1]})

//Tratamento para impressao de NFS Frota - Aglutinando os itens iguais
aFrotaTMP  := ASORT(aFrotaTMP,,,{|X,Y| X[1] < Y[1]})

For _j := 1 To Len(aFrotaTMP)
	IF ( nPos := aScan(aNewFrota,{|x| x[1] = aFrotaTmp[_j,1]})) > 0
		aNewFrota[nPos,3] += aFrotaTmp[_j,3]
		aNewFrota[nPos,7] += aFrotaTmp[_j,7]
	Else
		aAdd(aNewFrota,{aFrotaTMP[_j,1],aFrotaTMP[_j,2],aFrotaTMP[_j,3],aFrotaTMP[_j,4],aFrotaTMP[_j,5],aFrotaTMP[_j,6],aFrotaTMP[_j,7],aFrotaTMP[_j,8]})
	EndIF
Next _j

For I:=1 to nTamDet
	IF Len(aCOD_SERV) > 0 //Significa que nao tera tratamento para Frota
		IF I <= Len(aCOD_SERV)
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+aCOD_SERV[i,8]))
			IF !Empty(SF4->F4_FORMULA)
				IF Len(xMensITem) == 0
					aAdd(xMensITem,SF4->F4_FORMULA)
				EndIF
			EndIF
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(xFilial("SC6")+aCOD_SERV[I,9]+aCOD_SERV[I,10]))//Pedido+Item
			
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+SC6->C6_NUMOP+SC6->C6_ITEMOP))//OP+Item
			cDesc    := ""
			cDesenho := Alltrim(SC2->C2_X_DESEN)
			cCarcaca := SC2->C2_CARCACA
			cNF_Ser  := IIF(!Empty(SC2->C2_SERIEPN),SC2->C2_SERIEPN,IIF(!Empty(SC2->C2_NUMFOGO),"NF-"+SC2->C2_NUMFOGO,""))
			IF ! alltrim(aCOD_SERV[I,2]) $ "CI/SC"
				_cDescr := ""
				IF At("SC",Alltrim(aCOD_SERV[i,5])) > 0
					_cDescr := Alltrim(Substr(aCOD_SERV[i,5],3,Len(aCOD_SERV[i,5])))
				EndIF
				IF aCOD_SERV[i,8] <> "903" .or. Alltrim(aCOD_SERV[i,4]) == "RECUSADO" //Produto recusado
					//Alterado 27/07/05 - Nao impressao do Desenho para Prod. recusado
					IF Alltrim(aCOD_SERV[i,4]) == "RECUSADO" .AND. aCOD_SERV[i,8]== '903'  //Produto recusado
						cDesc:= Alltrim(aCOD_SERV[I,5]) //IIF(_cDescr == Alltrim(SC2->C2_PRODUTO),""," "+Alltrim(SC2->C2_PRODUTO))+" "+
					Else
						IF Substr(aCOD_SERV[I,1],1,2) != '98' //Tratamento de desconto
							cDesc:= cDesenho+" "+Alltrim(aCOD_SERV[I,5])+IIF(_cDescr == Alltrim(SC2->C2_PRODUTO),""," "+Alltrim(SC2->C2_PRODUTO))+" "+Alltrim(cCarcaca)+" "+Alltrim(cNF_Ser)
						Else
							cDesc:= Alltrim(aCOD_SERV[I,5])
						EndIF
					EndIF
				Else
					cDesc:= cDesenho+" "+Alltrim(SC2->C2_PRODUTO)+" "+Alltrim(cCarcaca)+" "+Alltrim(cNF_Ser)
				EndIF
			Else
				//Alterado 27/07/05 - inclusao NF/Numero de Serie
				IF alltrim(aCOD_SERV[I,2]) == "SC"
					cDesc:= Alltrim(aCOD_SERV[I,5])+" "+Alltrim(cNF_Ser)
				Else
					cDesc:= Alltrim(aCOD_SERV[I,5])
				EndIF
			EndIF
			
			@ nLin, 019  PSAY aCOD_SERV[I,3]
			@ nLin, 022  PSAY aCOD_SERV[I,4]
			@ nLin, 035  PSAY cDesc
			
			IF ( (aCOD_SERV[i,8] == "902" .OR. aCOD_SERV[i,8] == "903") .AND. (alltrim(aCOD_SERV[I,2]) $ "SC/CI") ) ;
				.or. ( ( AT("CONS",Alltrim(cDesenho)) > 0 .OR. ( AT("EXAM",Alltrim(cDesenho)) > 0 .AND. aCOD_SERV[I,6] == 10) ) .AND. aCOD_SERV[i,8] == "902" )
				lImpOk := .T.
			EndIF
			//Produto recusado e produtos so conserto nao deve ser impressos os valores unitarios e totais
			IF ( (aCOD_SERV[i,8] <> "903" .AND. Alltrim(aCOD_SERV[i,4]) <> "RECUSADO") .AND.;
				Alltrim(aCOD_SERV[I,2]) <> "ECS" ) .and. !lImpOk
				@ nLin, 077 PSAY aCOD_SERV[I,6] Picture "@E 999,999.99"
				@ nLin, 088 PSAY aCOD_SERV[I,7] Picture "@E 999,999.99"
			EndIF
			lImpOk := .F. 
		EndIF
	Else
		i := 19 //Finalizo Contador principal
		For _l := 1  To Len(aNewFrota)
			@ nLin, 019  PSAY aNewFrota[_l,3] //Qtd
			@ nLin, 022  PSAY aNewFrota[_l,4] //Unidade de Medida
			@ nLin, 035  PSAY aNewFrota[_l,5] //Descricao
			IF (aNewFrota[_l,8] <> "903" .AND. Alltrim(aNewFrota[_l,4]) <> "RECUSADO") .AND.;
				Alltrim(aNewFrota[_l,2]) <> "ECS"   //Produto recusado
				@ nLin, 077 PSAY aNewFrota[_l,6] Picture "@E 999,999.99" //Unitario
				@ nLin, 088 PSAY aNewFrota[_l,7] Picture "@E 999,999.99" //Total
			EndIF
			nLin :=nLin+1
		Next _l
	EndIF
	nLin :=nLin+1
Next  i

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPMENSIT¦ Autor ¦   Microsiga           ¦ Data ¦ 27/06/05 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao referente aos itens da NF caso haja devolucao    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Durapol                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function IMPMENSIT()

nCol:= 20
cTesAnt:=""
//Alert(Len(xMensITem))
For _k := 1 To Len(xMensITem)
	IF cTesAnt <> xMensITem[_k]
		@ nLin, nCol PSAY Substr(FORMULA(xMensITem[_k]),1,38)
		nLin := nLin +1
		@ nLin, nCol PSAY Substr(FORMULA(xMensITem[_k]),39,38)
		nLin := nLin +1
		@ nLin, nCol PSAY Substr(FORMULA(xMensITem[_k]),77,38)
		nLin := nLin +1
		cTesAnt := xMensITem[_k]
	EndIF
Next _k

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MENSOBS  ¦ Autor ¦   Microsiga           ¦ Data ¦ 11/04/05 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem no Campo Observacao                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Durapol                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function MENSOBS()

nTamObs:=45     
nCol:=35        
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,46,nTamObs))
nlin:=nlin+1
@ nLin, nCol PSAY ""
nlin:=nlin+1

Return



