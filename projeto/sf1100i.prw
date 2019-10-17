#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1100I  ºAutor  ³Paulo Benedet          º Data ³  07/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Nao se aplica                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Ponto de entrada do programa MATA103 (NF de entrada)          º±±
±±º          ³ apos a gravacao dos arquivos.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºBenedet   ³07/06/05³      ³Gravar SEPU.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF1100I()
Local _aArea   := {}
Local aAreaIni := {}
Local aAreaSD1 := {}
Local aAreaPA4 := {}
Local cPrdSEPU := ""
Local _cTSServ := ""
Local _i       := 0

Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.

If cEmpAnt == "01"  // DELLA VIA
	aAreaIni := GetArea()
	aAreaSA2 := SA2->(GetArea())
	aAreaSD1 := SD1->(GetArea())
	aAreaPA4 := PA4->(GetArea())
	
	cPrdSEPU := GetMV("FS_DEL008") + Space(TamSX3("B1_COD")[1] - Len(AllTrim(GetMV("FS_DEL008"))))
	
	// Escolhe indice
	PA4->(dbSetOrder(1))
	
	// Busca os produtos SEPU
	dbSelectArea("SD1")
	dbSetOrder(2) //D1_FILIAL+D1_COD+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
	dbSeek(xFilial("SD1") + cPrdSEPU + SF1->(F1_DOC + F1_SERIE))
	
	While !EOF();
		.And. D1_FILIAL == xFilial("SD1");
		.And. D1_COD == cPrdSEPU;
		.And. D1_DOC == SF1->F1_DOC;
		.And. D1_SERIE == SF1->F1_SERIE
		
		If SD1->D1_LOCAL <> GetMV("FS_DEL013") // Armazem SEPU
			dbSelectArea("SD1")
			dbSkip()
			Loop
		EndIf
		
		// Verifica se cliente/fornecedor e Della Via
		SA2->(dbSetOrder(1)) // A2_FILIAL+A2_COD+A2_LOJA
		SA2->(dbSeek(xFilial("SA2") + SD1->D1_FORNECE))
		
		If Left(SA2->A2_CGC, 8) <> "60957784"
			P_D21PegAva() // Pega avaliadores e grava SEPU
		EndIf
		
		dbSelectArea("SD1")
		dbSkip()
	EndDo
	
	If SF1->F1_FORMUL = "S" // Formulário Próprio
		Aviso("Aviso","Foi gerada NF n: "+SF1->F1_DOC+" "+SF1->F1_SERIE,{"OK"})
	Endif	
	
	// Retorna ambiente
	RestArea(aAreaSA2)
	RestArea(aAreaSD1)
	RestArea(aAreaPA4)
	RestArea(aAreaIni)
	
ElseIf cEmpAnt == "03"  // DURAPOL
	_aArea    := GetArea()
	_cTSServ  := GetMV("MV_X_TSVED") //Tes para faturamento (venda)
	_aSC5 := _aSC6 := {}
	
	IF FunName() = "MATA103" .and. SF1->F1_TIPO = "B" .and. SM0->M0_CODIGO == "03"
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+SF1->F1_COND)
		
		
		SC5->(dbSeek(xFilial("SC5")))
		SC6->(dbSeek(xFilial("SC6")))
		
		
		_aSC5	:= 	{{'C5_FILIAL',xFilial("SC5"),NIL},;
		{'C5_NUM',SF1->F1_DOC,NIL},;
		{'C5_TIPO','N',NIL},;
		{'C5_CLIENTE',SF1->F1_FORNECE,NIL},;
		{'C5_LOJACLI',SF1->F1_LOJA,NIL},;
		{'C5_TABELA',"   ",NIL},;
		{'C5_VEND3',SA1->A1_VEND3,NIL},;
		{'C5_COMIS3',SA1->A1_COMIS3,NIL},;
		{'C5_VEND4',SA1->A1_VEND4,NIL},;
		{'C5_COMIS4',SA1->A1_COMIS4,NIL},;
		{'C5_VEND5',SA1->A1_VEND5,NIL},;
		{'C5_COMIS5',SA1->A1_COMIS5,NIL},;
		{'C5_CONDPAG',iif(Empty(SF1->F1_COND),SA1->A1_COND,SF1->F1_COND),NIL}}
		
		
		
		dbSelectArea("SD1")
		SD1->(dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		Do while SD1->(!eof() .and. D1_FILIAL=xFilial("SD1") .and. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA=SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
			_aLinha := {}
			IF SD1->D1_QUANT > 1
				_nValor := SD1->D1_TOTAL/SD1->D1_QUANT
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial()+SD1->D1_TES)
				
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial()+SF4->F4_TESDV)
				//Devolucao da carca'ca
				For _i:=1 To SD1->D1_QUANT
					_aLinha := {}
					aAdd(_aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
					aAdd(_aLinha,{'C6_NUM',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_ITEM',StrZero(Len(_aSC6)+1,2,0),NIL}) //Item do pedido
					aAdd(_aLinha,{'C6_PRODUTO',SD1->D1_COD,NIL})
					aAdd(_aLinha,{'C6_QTDVEN',1,NIL})
					aAdd(_aLinha,{'C6_PRCVEN',SD1->D1_VUNIT,NIL})
					aAdd(_aLinha,{'C6_PRUNIT',SD1->D1_VUNIT,NIL})
					aAdd(_aLinha,{'C6_VALOR',_nValor,NIL})
					aAdd(_aLinha,{'C6_LOCAL',SD1->D1_LOCAL,NIL})
					aAdd(_aLinha,{'C6_NFORI',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_SERIORI',SD1->D1_SERIE,NIL})
					aAdd(_aLinha,{'C6_ITEMORI',SD1->D1_ITEM,NIL})
					aAdd(_aLinha,{'C6_IDENTB6',SD1->D1_IDENTB6,NIL})
					aAdd(_aLinha,{'C6_ENTREG',SD1->D1_DTENTRE,NIL})
					aAdd(_aLinha,{'C6_TES',SF4->F4_CODIGO,NIL})
					aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
					aAdd(_aLinha,{'C6_ITPVSRV',StrZero(Len(_aSC6)+2,2,0),NIL})
					
					aAdd(_aSC6,_aLinha)
					
					_nValor := U_BuscaPrcVenda(SD1->D1_SERVICO,SF1->F1_FORNECE,SF1->F1_LOJA)
					
					_aLinha := {}
					
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial()+_cTSServ)
					//Cobranca do servico executado
					aAdd(_aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
					aAdd(_aLinha,{'C6_NUM',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_ITEM',StrZero(Len(_aSC6)+1,2,0),NIL}) //Item do pedido
					aAdd(_aLinha,{'C6_PRODUTO',SD1->D1_SERVICO,NIL})
					aAdd(_aLinha,{'C6_QTDVEN',1,NIL})
					aAdd(_aLinha,{'C6_PRCVEN',_nValor,NIL})
					aAdd(_aLinha,{'C6_PRUNIT',_nValor,NIL})
					aAdd(_aLinha,{'C6_VALOR',_nValor,NIL})
					aAdd(_aLinha,{'C6_LOCAL',SD1->D1_LOCAL,NIL})
					aAdd(_aLinha,{'C6_NFORI',"",NIL})
					aAdd(_aLinha,{'C6_SERIORI',"",NIL})
					aAdd(_aLinha,{'C6_ITEMORI',"",NIL})
					aAdd(_aLinha,{'C6_IDENTB6',"",NIL})
					aAdd(_aLinha,{'C6_TES',_cTSServ,NIL})
					aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
					
					aAdd(_aSC6,_aLinha)
					
				Next _i
				SD1->(dbSkip())
			Else
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD1->D1_SERVICO))
				
				IF ! Alltrim(SB1->B1_GRUPO) $ Alltrim(GetMV("MV_X_GRPSC")) //Grupo de produtos de servicos que nao conterao valor agragado
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial()+SD1->D1_TES)
					
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial()+SF4->F4_TESDV)
					//Devolucao da carca'ca
					aAdd(_aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
					aAdd(_aLinha,{'C6_NUM',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_ITEM',StrZero(Len(_aSC6)+1,2,0),NIL}) //Item do pedido
					aAdd(_aLinha,{'C6_PRODUTO',SD1->D1_COD,NIL})
					aAdd(_aLinha,{'C6_QTDVEN',SD1->D1_QUANT,NIL})
					aAdd(_aLinha,{'C6_PRCVEN',SD1->D1_VUNIT,NIL})
					aAdd(_aLinha,{'C6_PRUNIT',SD1->D1_VUNIT,NIL})
					aAdd(_aLinha,{'C6_VALOR',SD1->D1_TOTAL,NIL})
					aAdd(_aLinha,{'C6_LOCAL',SD1->D1_LOCAL,NIL})
					aAdd(_aLinha,{'C6_NFORI',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_SERIORI',SD1->D1_SERIE,NIL})
					aAdd(_aLinha,{'C6_ITEMORI',SD1->D1_ITEM,NIL})
					aAdd(_aLinha,{'C6_IDENTB6',SD1->D1_IDENTB6,NIL})
					aAdd(_aLinha,{'C6_ENTREG',SD1->D1_DTENTRE,NIL})
					aAdd(_aLinha,{'C6_TES',SF4->F4_CODIGO,NIL})
					aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
					aAdd(_aLinha,{'C6_ITPVSRV',StrZero(Len(_aSC6)+2,2,0),NIL})
					
					
					aAdd(_aSC6,_aLinha)
					
					_nValor := U_BuscaPrcVenda(SD1->D1_SERVICO,SF1->F1_FORNECE,SF1->F1_LOJA)
					
					_aLinha := {}
					
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial()+_cTSServ)
					//Cobranca do servico executado
					aAdd(_aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
					aAdd(_aLinha,{'C6_NUM',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_ITEM',StrZero(Len(_aSC6)+1,2,0),NIL}) //Item do pedido
					aAdd(_aLinha,{'C6_PRODUTO',SD1->D1_SERVICO,NIL})
					aAdd(_aLinha,{'C6_QTDVEN',1,NIL})
					aAdd(_aLinha,{'C6_PRCVEN',_nValor,NIL})
					aAdd(_aLinha,{'C6_PRUNIT',_nValor,NIL})
					aAdd(_aLinha,{'C6_VALOR',_nValor,NIL})
					aAdd(_aLinha,{'C6_LOCAL',SD1->D1_LOCAL,NIL})
					aAdd(_aLinha,{'C6_NFORI',"",NIL})
					aAdd(_aLinha,{'C6_SERIORI',"",NIL})
					aAdd(_aLinha,{'C6_ITEMORI',"",NIL})
					aAdd(_aLinha,{'C6_IDENTB6',"",NIL})
					aAdd(_aLinha,{'C6_TES',_cTSServ,NIL})
					aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
					
					aAdd(_aSC6,_aLinha)
				Else
					//Produto  refe. a so conserto que sera executado internamente, por isso valor inexistente
					//Para estes servicos deverao ser inseridos materia-prima que sera consideradas na
					//cobranca
					
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial()+SD1->D1_TES)
					
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial()+SF4->F4_TESDV)
					//Devolucao da carca'ca
					aAdd(_aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
					aAdd(_aLinha,{'C6_NUM',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_ITEM',StrZero(Len(_aSC6)+1,2,0),NIL}) //Item do pedido
					aAdd(_aLinha,{'C6_PRODUTO',SD1->D1_COD,NIL})
					aAdd(_aLinha,{'C6_QTDVEN',SD1->D1_QUANT,NIL})
					aAdd(_aLinha,{'C6_PRCVEN',SD1->D1_VUNIT,NIL})
					aAdd(_aLinha,{'C6_PRUNIT',SD1->D1_VUNIT,NIL})
					aAdd(_aLinha,{'C6_VALOR',SD1->D1_TOTAL,NIL})
					aAdd(_aLinha,{'C6_LOCAL',SD1->D1_LOCAL,NIL})
					aAdd(_aLinha,{'C6_NFORI',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_SERIORI',SD1->D1_SERIE,NIL})
					aAdd(_aLinha,{'C6_ITEMORI',SD1->D1_ITEM,NIL})
					aAdd(_aLinha,{'C6_IDENTB6',SD1->D1_IDENTB6,NIL})
					aAdd(_aLinha,{'C6_ENTREG',SD1->D1_DTENTRE,NIL})
					aAdd(_aLinha,{'C6_TES',SF4->F4_CODIGO,NIL})
					aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
					aAdd(_aLinha,{'C6_ITPVSRV',StrZero(Len(_aSC6)+2,2,0),NIL})
					
					aAdd(_aSC6,_aLinha)
					
					_nValor := U_BuscaPrcVenda(SD1->D1_SERVICO,SF1->F1_FORNECE,SF1->F1_LOJA)
					
					_aLinha := {}
					
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial()+SB1->B1_TS)
					//Este servico nao sera cobrado, somente o conserto realizado
					aAdd(_aLinha,{'C6_FILIAL',xFilial("SC6"),NIL})
					aAdd(_aLinha,{'C6_NUM',SD1->D1_DOC,NIL})
					aAdd(_aLinha,{'C6_ITEM',StrZero(Len(_aSC6)+1,2,0),NIL}) //Item do pedido
					aAdd(_aLinha,{'C6_PRODUTO',SD1->D1_SERVICO,NIL})
					aAdd(_aLinha,{'C6_QTDVEN',1,NIL})
					aAdd(_aLinha,{'C6_PRCVEN',1,NIL})
					aAdd(_aLinha,{'C6_PRUNIT',10,NIL})
					aAdd(_aLinha,{'C6_VALOR',10,NIL})
					aAdd(_aLinha,{'C6_LOCAL',SD1->D1_LOCAL,NIL})
					aAdd(_aLinha,{'C6_NFORI',"",NIL})
					aAdd(_aLinha,{'C6_SERIORI',"",NIL})
					aAdd(_aLinha,{'C6_ITEMORI',"",NIL})
					aAdd(_aLinha,{'C6_IDENTB6',"",NIL})
					aAdd(_aLinha,{'C6_TES',SB1->B1_TS,NIL})
					aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
					
					aAdd(_aSC6,_aLinha)
					
				EndIF
				dbSelectArea("SD1")
				SD1->(dbSkip())
			EndIF
		Enddo
		
		//-- Chamada da rotina automatica
		MsExecAuto({|x,y,z|Mata410(x,y,z)},_aSC5,_aSC6,3)
		
		//-- Verifica se houve algum erro
		IF lmsErroAuto
			IF Aviso("Pergunta","Pedido de venda nao gerado. Deseja visualizar o log?",{"Sim","Nao"},1,"Atencao")=1
				MostraErro()
			EndIF
		EndIf
		
	EndIF
	
	RestArea(_aArea)
	
EndIf

Return
