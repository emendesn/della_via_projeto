#Include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKVFIM  ºAutor  ³Paulo Benedet          º Data ³  30/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualização de informacoes especificas na gravacao do 		 º±±
±±º          ³ Televendas  										  		 	 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cNumSUA - Numero do atendimento televendas                    º±±
±±º          ³ cNumSC5 - Numero do pedido de venda do faturamento            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nao ha                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Ponto de entrada executado apos a gravacao dos arquivos de    º±±
±±º          ³ atendimento e de pedido de vendas no Televendas.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data   ³Bops  ³Manutencao Efetuada                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºBenedet   ³30/05/05³Nao ha³Chamar rotina para gerar orcamento no          º±±
±±º          ³        ³      ³sigaloja.                                      º±±
±±ºMarcio    ³30/06/05³Nao ha³Atualizacao de campos no SC5 e SC6.            º±±
±±ºDomingos  ³        ³      ³                                               º±±
±±º			 ³        ³      ³                                               º±±
±±ºStanko	 ³04/07/05³Nao ha³Atualizacao de campos do vendedor 2 a 5 no SC5.º±±
±±º          ³        ³     ³                                                º±±
±±ºMarcio    ³22/05/06³     ³Paleativo para correção de NC dos campos        º±±
±±º          ³        ³     ³UserLgi e UserLga com WebService                º±±
±±º          ³        ³     ³                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKVFIM(cNumSUA, cNumSC5)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicialização de Variaveis.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea	:= GetArea()
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6	:= SC6->(GetArea())
Local _aAreaSUA	:= SUA->(GetArea())
Local _aAreaSUB	:= SUB->(GetArea())
Local _aAreaSA1	:= SA1->(GetArea())
Local _lLimpaSyp 	:= .F.
Local _cCliPad		:= ""

Conout("TMKVFIM linha 50 - Orcamento / Pedido  "+cNumSUA+"/"+cNumSC5+" Entrou no TMKVFIM.")

DbSelectArea("SUA")
DbSetOrder(1)
If DbSeek(xFilial("SUA")+cNumSUA)
	RecLock("SUA",.F.)
	SUA->UA_CONDPG := M->UA_CONDPG
	SUA->UA_PEDCLI := M->UA_PEDCLI
	MsUnLock()
//	dbCommit()
EndIf
// Verifica grupo de atendimento
Conout("TMKVFIM linha 62 - Orcamento / Pedido  "+cNumSUA+"/"+cNumSC5+" M->UA_LOJASL1 = "+M->UA_LOJASL1+" M->UA_OPER = "+M->UA_OPER)	
If !Empty(M->UA_LOJASL1) .And. M->UA_OPER == "2" // Integracao com sigaloja
	P_D19GrvLoja(cNumSUA, M->UA_LOJASL1)
Else   
//	If M->UA_OPER = "1"                                                                     
	Conout("TMKVFIM linha 67 - Orcamento / Pedido  "+cNumSUA+"/"+cNumSC5+" M->UA_OPER = "+M->UA_OPER)	
	If !Empty(cNumSC5)
// 	Marcio Domingos
// 	Atualiza campo Tipo de Venda

		DbSelectArea("SC5")
		_aAreaSC5	:= GetArea()
		DbSetOrder(1)                    
		DbSeek(xFilial("SC5")+cNumSC5)
		
		If !Found()	
			Conout("TMKVFIM Linha 78 - Pedido não encontrado: "+cNumSC5+" Usuário "+Substr(cUsuario,7,15)+" "+Dtoc(Date())+" "+Time())
			RestArea(_aAreaSC5)
			cNumSC5	:= SC5->C5_NUM    
			Conout("TMKVFIM Linha 81 - Pedido posicionado: "+cNumSC5+"    Usuário "+Substr(cUsuario,7,15)+" "+Dtoc(Date())+" "+Time())
			DbSeek(xFilial("SC5")+cNumSC5)
		Endif			
		
		Conout("TMKVFIM linha 085 - Pedido: "+SC5->C5_FILIAL+" "+SC5->C5_NUM+"    Usuário "+Substr(cUsuario,7,15)+" "+Dtoc(Date())+" "+Time())
		
		If Found()
			Conout("TMKVFIM linha 088 - Achou Pedido: "+SC5->C5_FILIAL+" "+SC5->C5_NUM+"    Usuário "+Substr(cUsuario,7,15)+" "+Dtoc(Date())+" "+Time())
			RecLock("SC5",.F.)
			SC5->C5_TPVEND	:= M->UA_TIPOVND
			SC5->C5_CONDPAG	:= M->UA_CONDPG
			
			//Marcelo Alcantara 08/12
			SC5->C5_PLACA 	:= M->UA_PLACA  
			SC5->C5_CODCON	:= M->UA_CODCON
			SC5->C5_ORIGEM 	:= "TMK"
			
			//Stanko
			IF SM0->M0_CODIGO == "03"
				SC5->C5_VEND2    := SUA->UA_VEND2
				SC5->C5_VEND3    := SUA->UA_VEND3
				SC5->C5_VEND4    := SUA->UA_VEND4
				SC5->C5_VEND5    := SUA->UA_VEND5
				SC5->C5_COMIS2   := SUA->UA_COMIS2
				SC5->C5_COMIS3   := SUA->UA_COMIS3
				SC5->C5_COMIS4   := SUA->UA_COMIS4
				SC5->C5_COMIS5   := SUA->UA_COMIS5
			EndIF
			// Benedet
			Conout("TMKVFIM linha 110 - Pedido  "+SC5->C5_FILIAL+" "+SC5->C5_NUM+" Conteudo do campo M->UA_BCO1 "+M->UA_BCO1)
			Conout("TMKVFIM linha 111 - Pedido  "+SC5->C5_FILIAL+" "+SC5->C5_NUM+" Conteudo do campo SUA->UA_BCO1 "+SUA->UA_BCO1)
			SC5->C5_BCO1     := M->UA_BCO1                                                                                      
			Conout("TMKVFIM linha 113 - Pedido  "+SC5->C5_FILIAL+" "+SC5->C5_NUM+" Gravou campo SC5->C5_BCO1 com "+SC5->C5_BCO1)
			SC5->C5_MENNOTA  := M->UA_MENNOTA
			MsUnlock()
//			dbCommit()                                                                                                 
			Conout("TMKVFIM linha 117 - Pedido  "+SC5->C5_FILIAL+" "+SC5->C5_NUM+" Conteudo do campo SC5->C5_BCO1 apos commit "+SC5->C5_BCO1)
		Endif
		
	Endif	
	
	//
	// Atualiza campos da Margem Média
	//
	DbSelectArea("SUB")
	DbSetOrder(1)
	DbSeek(xFilial("SUB")+cNumSUA)
	
	Do While 	SUB->UB_FILIAL	==	xFilial("SUB")	.And.;
		SUB->UB_NUM		==	cNumSua			.And. 	!Eof()
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		If DbSeek(xFilial("SC6")+cNumSC5+SUB->UB_ITEM+SUB->UB_PRODUTO)
			RecLock("SC6",.F.)
			SC6->C6_CM1		:= SUB->UB_CM1
			SC6->C6_MM		:= SUB->UB_MM
			SC6->C6_DESPMM	:= SUB->UB_DESPMM
			SC6->C6_PEDCLI	:= SUA->UA_PEDCLI
			MsUnlock()
//			dbCommit()
		Endif
		
		DbSelectArea("SUB")
		DbSkip()
		
	Enddo
	
	
	If !lTk271Auto
		If !Empty(cNumSC5)
			MsgBox("Foi gerado pedido: " +cNumSc5)
		Endif
	Endif
	// Marcio Domingos
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta funcao se encontra no DELXFUN e eh responsavel pela gravacao do numero de       ³
//³ Sequencia no arquivo SL4, ela nao deve se tirada deste Ponto de Entrada              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
P_AtuSeqL4(SUA->UA_FILIAL,SUA->UA_NUM,PadR("SIGATMK",8))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para limpeza dos registro da tabela SYP do Cliente Padrao					 ³
//³ Adcionado por Marcelo Alcantara 26/10/2005																			         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_lLimpaSyp  := GetMv("MV_TMKLSYP")  // Parametro para especificar se ira Limpar os Registro do SYP
_cCliPad	:= Alltrim(GetMv("MV_CLIPAD"))

if SUA->UA_CLIENTE = _cCliPad .AND. _lLimpaSyp
	P_DELA052("FINALIZA")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Marcio Domingos
//³Correção de não conformidade dos campos UserLGI e UserLGA com WS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

If GetMv("MV_USERWS") .And. !Empty(Mv_Par38) // Faturamento
	
	DbSelectArea("SA1")
	DbSetOrder(1)

	DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA)
	
	RecLock("SA1",.F.)            
	SA1->A1_USERLGI	:= Mv_Par38
	SA1->A1_USERLGA	:= Mv_Par39
	MsUnlock()           
	
	Mv_Par38	:= ""
	Mv_Par39	:= ""
	
Endif	                                   

If "TMKUSER" $ Upper(FunName())

	If Inclui .And. !Empty(_cCond)
	
		Conout("TMKVFIM - Linha 199 - Atendimento :"+M->UA_NUM+" "+Substr(cUsuario,7,15)+" Refaz Filtro Inicio "+Time())	
	
		bFiltraBrw := {|| FilBrowse("SUA",@aIndex,@_cCond) }
		Eval(bFiltraBrw)
			
		Conout("TMKVFIM - Linha 204 - Atendimento :"+M->UA_NUM+" "+Substr(cUsuario,7,15)+" Refaz Filtro Fim "+Time())	
	
	Endif	
	
Endif	

RestArea(_aAreaSA1)
RestArea(_aAreaSC5)
RestArea(_aAreaSC6)
RestArea(_aAreaSUA)
RestArea(_aAreaSUB)
RestArea(_aArea)

Return
