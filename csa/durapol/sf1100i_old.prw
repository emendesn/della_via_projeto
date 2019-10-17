#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Reinaldo Caldas     º Data ³  20/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1100I()

Local _aArea      := GetArea()
Local _aAreaSD1   := SD1->(GetArea())
Local _aAreaSF4   := SF4->(GetArea())
Local _aAreaSA1   := SA1->(GetArea())
Local _aAreaSA2   := SA2->(GetArea())
Local _aAreaSE4   := SE4->(GetArea())
Local _aAreaSB2   := SB2->(GetArea())
Local _cTSServ    := GetMV("MV_X_TSVED") //Tes para faturamento (venda)
Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.
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
			dbSeek(xFilial("SF4")+SD1->D1_TES)
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4")+SF4->F4_TESDV)
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
				
				
				_cDoc    := SD1->D1_DOC
				_cITOrig := Substr(SD1->D1_ITEM,3,2)
				
				_nValor := U_BuscaPrcVenda(SD1->D1_SERVICO,SF1->F1_FORNECE,SF1->F1_LOJA)
			 	
			 	_aLinha := {}
			 	
			 	dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4")+_cTSServ)
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
				
				aAdd(_aLinha,{'C6_NUMOP',SD1->D1_DOC,NIL})
				aAdd(_aLinha,{'C6_ITEMOP',_cITOrig,NIL})
				
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
				dbSeek(xFilial("SF4")+SD1->D1_TES)
			
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4")+SF4->F4_TESDV)
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
				
				_cDoc    := SD1->D1_DOC
				_cITOrig := Substr(SD1->D1_ITEM,3,2)
			
				_nValor := U_BuscaPrcVenda(SD1->D1_SERVICO,SF1->F1_FORNECE,SF1->F1_LOJA)
				
				_aLinha := {}
			
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4")+_cTSServ)
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
				aAdd(_aLinha,{'C6_NUMOP',SD1->D1_DOC,NIL})
				aAdd(_aLinha,{'C6_ITEMOP',_cITOrig,NIL})				
				aAdd(_aLinha,{'C6_TES',_cTSServ,NIL}) 
				aAdd(_aLinha,{'C6_CF',SF4->F4_CF,NIL})

	
				aAdd(_aSC6,_aLinha)
			Else
				//Produto  refe. a so conserto que sera executado internamente, por isso valor inexistente
				//Para estes servicos deverao ser inseridos materia-prima que sera consideradas na
				//cobranca
				
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4")+SD1->D1_TES)
			
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4")+SF4->F4_TESDV)
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
				
				_cDoc    := SD1->D1_DOC
				_cITOrig := Substr(SD1->D1_ITEM,3,2)
				
				_aLinha := {}
				
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4")+SB1->B1_TS)
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
				aAdd(_aLinha,{'C6_NUMOP',SD1->D1_DOC,NIL})
				aAdd(_aLinha,{'C6_ITEMOP',_cITOrig,NIL})
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

SD1->(RestArea(_aAreaSD1))
SB2->(RestArea(_aAreaSB2))
SF4->(RestArea(_aAreaSF4))
SA1->(RestArea(_aAreaSA1))
SA2->(RestArea(_aAreaSA2))
SE4->(RestArea(_aAreaSE4))
RestArea(_aArea)
Return
