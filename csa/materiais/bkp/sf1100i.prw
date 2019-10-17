/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1100I  ºAutor  ³Microsiga              º Data ³  07/06/05   º±±
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
Local aAreaIni := GetArea()
Local aAreaSD1 := SD1->(GetArea())
//Local aAreaPA4 := PA4->(GetArea())
Local cPrdSEPU := GetMV("FS_DEL008") + Space(TamSX3("B1_COD")[1] - Len(AllTrim(GetMV("FS_DEL008"))))
Local _cTSServ := GetMV("MV_X_TSVED") //Utilizacao na empresa Durapol
Private lMsHelpAuto := .F.   //Utilizacao na empresa Durapol
Private lMsErroAuto := .F.   //Utilizacao na empresa Durapol
Private _aSC5 := _aSC6 := {} //Utilizacao na empresa Durapol

//Nao Consideroa na empresa Durapol
IF SM0->M0_CODIGO <> "03"
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
	
	P_D21PegAva() // Pega avaliadores e grava SEPU
	
	dbSelectArea("SD1")
	dbSkip()
EndDo

Else //Tratamento de geracao de pedido de venda na Durapol
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
	
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

//	{'C5_MENNOTA',"NF DEV. REF. NFE/SERIE "+SF1->(AllTrim(F1_DOC)+"/"+AllTrim(F1_SERIE)),NIL},;
//	{'C5_BANCO',SA1->A1_PORTADO,NIL},;
//	{'C5_AGEDEP',SA1->A1_AGEDEP,NIL},;
//	{'C5_CONTA',SA1->A1_CONTA,NIL},;



	
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
				aAdd(_aLinha,{'C6_ENTREG',IIF(!Empty(SD1->D1_DTENTRE),SD1->D1_DTENTRE,dDatabase),NIL})
				aAdd(_aLinha,{'C6_SERIORI',SD1->D1_SERIE,NIL})
				aAdd(_aLinha,{'C6_ITEMORI',SD1->D1_ITEM,NIL})
				aAdd(_aLinha,{'C6_IDENTB6',SD1->D1_IDENTB6,NIL})
				aAdd(_aLinha,{'C6_TES',SF4->F4_CODIGO,NIL})
				aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
  				aAdd(_aLinha,{'C6_ITPVSRV',StrZero(Len(_aSC6)+1,2,0),NIL})				
				
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
			aAdd(_aLinha,{'C6_ENTREG',IIF(!Empty(SD1->D1_DTENTRE),SD1->D1_DTENTRE,dDatabase),NIL})
			aAdd(_aLinha,{'C6_SERIORI',SD1->D1_SERIE,NIL})
			aAdd(_aLinha,{'C6_ITEMORI',SD1->D1_ITEM,NIL})
			aAdd(_aLinha,{'C6_IDENTB6',SD1->D1_IDENTB6,NIL})
			aAdd(_aLinha,{'C6_TES',SF4->F4_CODIGO,NIL})
			aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})
			aAdd(_aLinha,{'C6_ITPVSRV',StrZero(Len(_aSC6)+1,2,0),NIL})
			
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
// Retorna ambiente
RestArea(aAreaSD1)
//RestArea(aAreaPA4)
RestArea(aAreaIni)

Return
