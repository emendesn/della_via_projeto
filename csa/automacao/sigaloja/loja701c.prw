#INCLUDE "LOJA701C.ch"
#INCLUDE "Protheus.ch"

#DEFINE _FORMAPGTO	3  //Posicao do campo Forma de Pgto no array aPgtos(Localizacoes)
#DEFINE _MOEDA		6  //Posicao do campo Moeda no array aPgtos(Localizacoes)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Este Log é um recurso a ser habilitado pelo departamento de desenvolvimento para averigua-³
//³ção de possíveis problemas de transações TEF.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE LOG_TEF 	IIf( File(GetClientDir()+"SIGALOJA.INI") .And. ;
                         GetPvProfString("Logs TEF","Habilita","01",GetClientDir()+"SIGALOJA.INI") == "01", ;
                         "\AUTOCOM\TEF"+cEmpAnt+cFilAnt+"\", ;
                         "" )

#DEFINE TEF_SEMCLIENT_DEDICADO  "2"         //Utiliza TEF Dedicado Troca de Arquivos                      
#DEFINE TEF_COMCLIENT_DEDICADO  "3"			//Utiliza TEF Dedicado com o Client
#DEFINE TEF_DISCADO             "4"			//Utiliza TEF Discado 
#DEFINE TEF_LOTE                "5"			//Utiliza TEF em Lote
#DEFINE TEF_CLISITEF			"6"			//Utiliza a DLL CLISITEF
#DEFINE _FORMATEF				"CC;CD"     //Formas de pagamento que utilizam operação TEF para validação

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7GravacaoºAutor  ³Andre Veiga        º Data ³  09/23/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chama das funcoes de gravacao.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³voi Lj7Gravacao( ExpN1, ExpN2, ExpN3 )                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpN1 - Incica se a funcao foi chamada via                  º±±
±±º          ³      1 - Salvar como orcamento                             º±±
±±º          ³      2 - Salvar como venda                                 º±±
±±º          ³      3 - Salvar como pedido                                º±±
±±º          ³ExpN2 - Incica a opcao escolhida na rotina (aRotina)        º±±
±±º          ³ExpN3 - Controle do semaforo (SX8)                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Rotina do aFuncoes via Loja701                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7Gravacao( nTipo, nOpc, nSaveSx8, lSair, nHandle )
Local lReserva 		:= .F.
Local lFinalizou 	:= .F.						// Controle para ver ser a venda foi ou nao finalizada.
Local lRet			:= .T.
Local lFinanceiro 	:= .T.
Local nPosProd		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_PRODUTO"})][2]	// Posicao da codigo do produto
Local nPosDesc		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_DESCRI"})][2]		// Posicao da Descricao do produto
Local nPosQuant		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_QUANT"})][2]		// Posicao da Quantidade
Local nPosDtReserva	:= aPosCpoDet[15][2]		// Posicao do codigo da reserva
Local nPosDtLocal  	:= aPosCpoDet[20][2]		// Posicao do local (armazem)
Local cCondPad      := GetMV( "MV_CONDPAD" )	// Condicao de pagamento padrao
Local cConfCli      := GetMV( "MV_CONFCLI" ) 	// Utiliza configuracoes do cliente
Local cCond         := ""                      	// Condicao de pagamento default utilizada
Local nX 			:= 0						// Variavel auxiliar
Local lEstNeg		:= (GetMv("MV_ESTNEG") == "S")
Local cMsg			:= ""
Local lTrocoLoc     := .F.
Local nDecsTroco    := 0
Local aAreaMAD      := {}
Local cMay          := ""
Local nTent			:= 0
Local nTotGeral     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array para tratamento de Consumidor Final - Loc. Argentina ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            
Local aDadosCF    := {}
                                                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para efetuar o fechamento da tela               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            
Default lSair	  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desabilita SetKeys      									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Lj7SetKeys(.F.)

If !LjEcfXData()
	Return NIL
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a venda seja paga com NCC cria uma linha no aPgtos soh com a  ³
//³condicao de pagamento e data (o valor fica zerado)                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aPgtos) == 1 .AND. aPgtos[1][1] == CtoD(Space(8)) .And. aPgtos[1][2] == 0 .And. Empty( aPgtos[1][3] ) .And. ( nTipo == 1 .OR. nNccUsada > 0 )

	//Utiliza a condicao de pagamento default do cliente, caso esteja habilitado para usa-lo
	If cConfCli == "S"
		cCond := Posicione("SA1",1,xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,"SA1->A1_COND")
	EndIf
	
	//Se a condicao estiver vazia, utilizar a condicao default do parametro
	If Empty(cCond) .OR. nNCCUsada > 0
		cCond := cCondPad
	EndIf
	                          
	//Atualizo campo de codigo de condicao de pagamento       
	M->LQ_CONDPG := cCond

	Lj7CondPg( 2, cCond,, ( ! nNCCUsada > 0 ))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta a variavel na tela do Troco                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Lj7AjustaTroco()	

EndIf

If cPaisLoc == "BRA"
	If nTipo == 2 .And. !lFiscal
		// "Atenção" ### "Para finalizar uma venda, é necessário que o usuário tenha permissão para usar impressora fiscal." ### "Ok"
		Aviso(STR0007, STR0043, {STR0005})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Habilita as teclas de atalho                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Lj7SetKeys(.T.)
		Return NIL
	EndIf
Else
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Estrutura do array aDadosCF     ³
   //³ 1-Numero do Doc. Cons. Final    ³   
   //³ 2-Tipo do Doc. Cons. Final      ³   
   //³ 3-Codigo da Provincia do Doc.   ³   
   //³ Carteira de Identidade(CI)      ³   
   //³ 4-Nome do cliente Cons. Final   ³   
   //³ 5-Codigo do endereco            ³   
   //³ 6-Endereco                      ³   
   //³ 7-Venda Consumidor Final(logico)³                        
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If cPaisLoc == "ARG" 
	   aDadosCF  := {Space(TamSX3("LS_DOCCF")[1]),"",Space(TamSX3("LS_TIPOCI")[1]),;
	                 Space(TamSX3("LS_CLIECF")[1]),GetSxeNum("MAD","MAD_CODEND"),;
	                 Space(TamSX3("MAD_END")[1]),.F.}		
	   // Tela para indicar tipo e numero de documento quando consumidor final e venda maior que 
	   // o determinado no parametro MV_LIMCFIS	              	                 
	   If nTipo == 2 .And. Posicione( "SA1",1,xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,"SA1->A1_TIPO" ) == "F" .And.;
	      Lj7T_Total(2) >= GetMV("MV_LIMCFIS")       
	     	
	      If !Lj7DocsCF(@aDadosCF)   
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Habilita as teclas de atalho                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Lj7SetKeys(.T.)
	   	     Return Nil
	      EndIf
	   
   		  // Gera o codigo que sera utilizado para a gravacao do endereco do 
   		  // consumidor final.
		  cMay := Alltrim(xFilial("MAD"))+aDadosCF[5]
		  FreeUsedCode()				
				
	  	  dbSelectArea("MAD")
		  aAreaMAD := GetArea()
		  dbSetOrder(1)
		  While dbSeek(xFilial("MAD")+aDadosCF[5]) .Or. !MayIUseCode(cMay)
			 If ++nTent > 20
				MsgStop(STR0035)                 //"Nao foi possivel gerar numero sequencial de endereco corretamente."
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Habilita as teclas de atalho                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Lj7SetKeys(.T.)
				Return Nil
			 Endif

			 While (GetSX8Len() > nSaveSx8)
				ConfirmSx8()
			 End
			 aDadosCF[5] := GetSxeNum("MAD","MAD_CODEND")
			 FreeUsedCode()
			 cMay := Alltrim(xFilial("MAD"))+aDadosCF[5]
		  End
		  RestArea(aAreaMAD)
		  aDadosCF[7] := .T.     
	   EndIf	   
	EndIf

	// Valida se foi utilizado o troco localizado. Caso tenha sido utilizado verifica se o troco foi atribuido
	// na sua totalidade, caso contrario não permite que a venda seja encerrada.
	If GetMV("MV_LJTRLOC")
		For nX := 1 To Len(aMoedas)
			nDecsTroco := MsDecimais(aMoedas[nX][06])
			If (aMoedas[nX][02] <> 0) .And. (Round(aMoedas[nX][02],nDecsTroco) <> Round(aMoedas[nX][05],nDecsTroco))
				MsgAlert(STR0027)  //"Para que o orcamento/venda seja concluido e necessario que o troco seja totalmente informado ou que os valores ja atribuidos sejam zerados."
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Habilita as teclas de atalho                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Lj7SetKeys(.T.)
				Return Nil
			Else
				If (aMoedas[nX][05] <> 0) .And. (aMoedas[nX][03] <> 0)
					lTrocoLoc := .T.
				EndIf
			EndIf
		Next nX
	
		If !lTrocoLoc
			For nX := 1 To Len(aPgtos)
				If aPgtos[nX][_MOEDA] <> nMoedaCor .And. Lj7T_Troco(2) > 0
					MsgAlert(STR0028) //"Existe uma ou mais parcelas com moeda diferente da moeda corrente da venda. Por favor informe o valor a ser dado como troco, para que o orcamento/venda possa ser encerrado."
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Habilita as teclas de atalho                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Lj7SetKeys(.T.)
					Return Nil
				EndIf
				
				If !IsMoney(aPgtos[nX][_FORMAPGTO]) .And. Lj7T_Troco(2) > 0
					MsgAlert(STR0029) //"Existe uma ou mais parcelas com forma de pagamento diferente de dinheiro. Por favor informe o valor a ser dado como troco, para que o orcamento/venda possa ser encerrado."
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Habilita as teclas de atalho                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Lj7SetKeys(.T.)
					Return Nil
				EndIf
			Next
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Analise de credito do cliente selecionado                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 2 .And. !LJ7AvalCred()[1]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Habilita as teclas de atalho                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Lj7SetKeys(.T.)
	Return Nil
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz as consistencias no aCols  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRecebe .And. !Lj7TudOk( nTipo )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Habilita as teclas de atalho                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Lj7SetKeys(.T.)
	Return Nil
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o caixa esta aberto, senao nao deixa finalizar a venda ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nTipo == 2 ) .And. ( !ljCxAberto(.T.,xNumCaixa()) )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Habilita as teclas de atalho                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Lj7SetKeys(.T.)
	Return Nil
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Critica se nao foi informado pagamento (qdo nao for orcamento) /   ³
//³valida tbem as notas de credito                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA" .And. Lj7T_TotPar(2) < Lj7T_Total(2)) .Or.;
   (cPaisLoc <> "BRA" .And. (nDif :=  Lj7T_Total(2) - Lj7T_TotPar(2)) > 0 .And. nDif > (1 / (10 ^ MsDecimais(nMoedaCor))))

	MsgStop( STR0001 ) //"O total de parcelas para pagamento é menor que o valor total da venda."
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Habilita as teclas de atalho                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Lj7SetKeys(.T.)
	Return Nil
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³LOG TEF                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'LOJ701C'+Replicate('-',40))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verfica se nao permite vender com o estoque negativo quando nao    ³
//³for orcamento                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRecebe .And. !lEstNeg .And. nTipo <> 1
	cMsg := ""
	For nX := 1 to Len(aCols)
		If !aCols[nX][Len(aCols[nX])]
			// Somente verifica o estoque caso nao tenha sido feita a reserva do produto
			If Empty(aColsDet[nX][nPosDtReserva])
				If !(Lj7VerEst( aCols[nX][nPosProd], aColsDet[nX][nPosDtLocal], aCols[nX][nPosQuant], .F., nX ))
					cMsg := cMsg + Alltrim(aCols[nX][nPosProd]) + "-" + Alltrim(aCols[nX][nPosDesc]) + " | "
				Endif
			Endif
		Endif
	Next nX
	
	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Verifica Estoque - N / N / ' + AllTrim(Str(nTipo)) + ' / ' + cMsg)
	EndIf
	
	If !Empty(cMsg)	
		MsgStop(STR0002 + Chr(10) +; //"Não será permitido finalizar a venda pois os produtos abaixo não possuem saldo em estoque."
				Subst(cMsg,1,Len(cMsg)-3) )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Habilita as teclas de atalho                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Lj7SetKeys(.T.)
		Return Nil
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se foi efetuada alguma reserva                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval( aColsDet, { |x| If( !Empty(x[nPosDtReserva]),(lReserva := .T.),Nil ) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Checagem do valor de credito ao cliente                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 2 .And. nNCCUsada > 0
    
    nTotGeral := 0              

    // Soma os valores colocados na condição de pagamento.
	aEval(aPgtos, { |x| nTotGeral += x[2] })
	             
	// Desconta o valor total da venda e os impostos (PIS/COFINS/CSLL).
	nTotGeral  := ( LJ7T_Total(2) - nTotGeral - ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) ) )
	
	// Calcula a nova NCC a ser gerada. Substraindo o que já foi usado de NCC com o que sobrou no nTotGeral.
	nNCCGerada := Abs(( nNCCUsada - nTotGeral ))

	If nNCCGerada > 0
		Aviso(STR0003, STR0004+GetMV("MV_SIMB1")+" "+AllTrim(Transform(nNccGerada,PesqPict("SE1","E1_VALOR"))), {STR0005}) //"Nota de Crédito ao Cliente"###"Irá restar um crédito no valor de: "###"Ok"
	Else
		nNCCGerada := 0
	EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validacao no final da venda (antes das gravacoes)  ³
//³ Envia como parametro o nTipo (1-orcamento  2-venda  3-pedido)            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("LJ7001")
	lRet := ExecBlock( "LJ7001", .F., .F., {If(nTipo==2.And.lReserva,3,nTipo)} )
	
	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'P.E. LJ7001 - ' + iIf( lRet, 'S', 'N' ))
	EndIf

	If !lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Habilita as teclas de atalho                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Lj7SetKeys(.T.)
		Return Nil
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se eh finalizacao da venda e se eh um orcamento feito por       ³
//³ outra loja. Se afirmativo fecha a venda sem gerar financeiro.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 4
	If !Empty(SL1->L1_ORCRES) .And. !Empty(SL1->L1_FILRES)
		lFinanceiro := .F.
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica qual o tipo de gravacao devera ser feito                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 2 .And. lReserva .And. lFinanceiro

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Inicio Gravação - 2 / S / S')
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Transforma o orcamento para pedido                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Lj7PrepOrc( nOpc ) .And. Lj7Pedido(aDadosCF)
		MBrChgLoop(If(nOpc==3,.T.,.F.))
		If nOpc == 3
			While (GetSX8Len() > nSaveSx8)
				ConfirmSx8()
			End
		Endif
		//oDlgVA:End()
		// Ajusta a variavel para indicar que finalizou a venda e chamar o ponto de entrada abaixo
		lSair	   := .T.
		lFinalizou := .T.
	Endif	
ElseIf nTipo == 1

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Inicio Gravação - 1')
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salvar como orcamento                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Lj7PrepOrc( nOpc )
		MBrChgLoop(If(nOpc==3,.T.,.F.))
		If nOpc == 3
			While (GetSX8Len() > nSaveSx8)
				ConfirmSx8()
			End
		Endif
//		oDlgVA:End()
		// Ajusta a variavel para indicar que finalizou a venda e chamar o ponto de entrada abaixo
		lSair	   := .T.
		lFinalizou := .T.
	Endif
ElseIf nTipo == 2

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Inicio Gravação - 2')
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salvar como venda                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Lj7PrepOrc( nOpc ) .And. Lj7GrvVenda( lFinanceiro, , aDadosCF, nHandle )
		MBrChgLoop(If(nOpc==3,.T.,.F.))
		If nOpc == 3
			While (GetSX8Len() > nSaveSx8)
				ConfirmSx8()
			End
		Endif
		//oDlgVA:End()
		// Ajusta a variavel para indicar que finalizou a venda e chamar o ponto de entrada abaixo
		lSair	   := .T.
		lFinalizou := .T.
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validacao no final da venda (apos as gravacoes)    ³
//³ Envia como parametro o nTipo (1-orcamento  2-venda  3-pedido)            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFinalizou .And. ExistBlock("LJ7002")
	ExecBlock( "LJ7002", .F., .F., {If(nTipo==2.And.lReserva,3,nTipo)} )
Endif

If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'LOJ701C'+Replicate('-',40))
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Final Gravação - ' + iIf( lFinalizou, 'S', 'N' ))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilita as teclas de atalho                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Lj7SetKeys(.T.)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ7GrvOrc ºAutor  ³Andre Veiga         º Data ³  17/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a gravacao do 'pacote' de arquivos para a rotina de     º±±
±±º          ³venda assistida                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ExpA1 := Lj7GrvOrc( ExpA2, ExpA3 [, ExpA4, ExpL1, ExpL2,    º±±
±±º          ³                    ExpC1 ] )                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA2 - Array com as informacoes do SL1 no formato          º±±
±±º          ³        [1] - Nome do campo                                 º±±
±±º          ³        [2] - Valor a ser gravado                           º±±
±±º          ³                                                            º±±
±±º          ³ExpA3 - Array com as informacoes do SL2 no formato          º±±
±±º          ³        [1] - Nome do campo                                 º±±
±±º          ³        [2] - Valor a ser gravado                           º±±
±±º          ³                                                            º±±
±±º          ³ExpA4 - Array com as informacoes do SL4 no formato          º±±
±±º          ³        [1] - Nome do campo                                 º±±
±±º          ³        [2] - Valor a ser gravado                           º±±
±±º          ³                                                            º±±
±±º          ³ExpL1 - Variavel que indica se a rotina ira ter tratamento  º±±
±±º          ³        de tela, isto e, se nao sera uma rotina automatica  º±±
±±º          ³        .T. - Mostra as mesnagens na tela                   º±±
±±º          ³        .F. - Nao mostra mensagens na tela                  º±±
±±º          ³                                                            º±±
±±º          ³ExpL2 - Indica se eh para gerar um numero de orcamento ou   º±±
±±º          ³        nao. (valor default .F.). Se esse parametro for .F. º±±
±±º          ³        o campo L1_NUM devera ser informado                 º±±
±±º          ³                                                            º±±
±±º          ³ExpC1 - Codigo da filial onde sera gravado o orcamento. Se  º±±
±±º          ³        nao for informado sera grava na filial local        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpA1 - Array contendo:                                     º±±
±±º          ³        [1] - T / F. Indica se fez ou nao a gravacao        º±±
±±º          ³        [2] - Numero do orcamento gerado                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LJ7GrvOrc( aSL1, aSL2, aSL4, lTela, lGeraNumOrc, cFilOrc )
111Local aRet 			:= { .F., Space(TamSx3("L1_NUM")[1]) }
Local nX
Local nPos 			:= 0
Local nCont 		:= 0
Local cNumOrc		:= Space(TamSX3("L1_NUM")[1])
Local cFilAux		:= ""
Local lOperacao		:= .T.					// Variavel que indicara se eh uma inclusao ou exclusao de um orcamento
Local lContinua		:= .T.
Local lRet 			:= .F.
Local lAlteraFil 	:= (cFilOrc<>Nil)
Local nTent 		:= 0
Local cMay			:= ""
Local nSaveSx8 		:= GetSx8Len()
Local nRestDiv      := 0

Default aSL4 		:= {}
Default lTela		:= .T.
Default lGeraNumOrc	:= .F.
Default cFilOrc		:= xFilial("SL1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se for informada a filial para gravacao do orcamento troca o ³
//³ valor de cFilAnt para que os semaforos possam pegar as       ³
//³ informacoes da filial correta                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAlteraFil
	cFilAux := cFilAnt
	cFilAnt := cFilOrc
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acerta o campo filial dos arrays                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos 	:= aScan( aSL1, {|x| Alltrim(Upper(x[1])) == "L1_FILIAL" } )
If nPos == 0
	aAdd( aSL1, { "L1_FILIAL", cFilOrc } )
Else
	aSL1[nPos][2] := cFilOrc
Endif

For nX := 1 to Len(aSL2)
	nPos 	:= aScan( aSL2[nX], {|x| Alltrim(Upper(x[1])) == "L2_FILIAL" } )
	If nPos == 0
		aAdd( aSL2[nX], { "L2_FILIAL", cFilOrc } )
	Else
		aSL2[nX][nPos][2] := cFilOrc
	Endif
Next nX

For nX := 1 to Len(aSL4)
	nPos 	:= aScan( aSL4[nX], {|x| Alltrim(Upper(x[1])) == "L4_FILIAL" } )
	If nPos == 0
		aAdd( aSL4[nX], { "L4_FILIAL", cFilOrc } )
	Else
		aSL4[nX][nPos][2] := cFilOrc
	Endif
	
	//Reajuste dos valores de Pis/Cofins
	If LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) > 0
		nPos 	:= aScan( aSL4[nX], {|x| Alltrim(Upper(x[1])) == "L4_VALOR" } )
		If nPos > 0
			aSL4[nX][nPos][2] -= NoRound(( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )/Len(aSL4),nDecimais)
			nRestDiv += NoRound(( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )/Len(aSL4),nDecimais)
		EndIf
		
		If Len( aSL4 ) == nX .And. ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) ) > nRestDiv
			aSL4[nX][nPos][2] -= ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) ) - nRestDiv
		EndIf
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Checar se eh para gerar um numero de orcamento               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGeraNumOrc

	// A CriaVar do L1_NUM ira chamar a GetSxeNum()
    cNumOrc := CriaVar("L1_NUM")
    
	// Caso o SXE e o SXF estejam corrompidos o numero do orcamento estava se repetindo.
	cMay := Alltrim(xFilial("SL1"))+cNumOrc
	FreeUsedCode()
	SL1->(dbSetOrder(1))
	// Se dois orcamentos iniciam ao mesmo tempo a MayIUseCode impede que ambos utilizem o mesmo numero.
	nTent := 0
	While SL1->(dbSeek(xFilial("SL1")+cNumOrc)) .Or. !MayIUseCode(cMay)
		If ++nTent > 20
			MsgStop(STR0006) //"Impossivel gerar número sequencial de orçamento correto. Informe ao administrador do sistema."
			Return aRet
		Endif
		While (GetSX8Len() > nSaveSx8)
			ConfirmSx8()
		End
		cNumOrc    := CriaVar("L1_NUM")
		FreeUsedCode()
		cMay := Alltrim(xFilial("SL1"))+cNumOrc
	End
    
    // Acerta o array aSL1
	nPos 	:= aScan( aSL1, {|x| Alltrim(Upper(x[1])) == "L1_NUM" } )
	If nPos == 0
		aAdd( aSL1, { "L1_NUM", cNumOrc } )
	Else
		aSL1[nPos][2] := cNumOrc
	Endif

    // Acerta o array aSL2
	For nX := 1 to Len(aSL2)
		nPos 	:= aScan( aSL2[nX], {|x| Alltrim(Upper(x[1])) == "L2_NUM" } )
		If nPos == 0
			aAdd( aSL2[nX], { "L2_NUM", cNumOrc } )
		Else
			aSL2[nX][nPos][2] := cNumOrc
		Endif
	Next nX

    // Acerta o array aSL4
    For nX := 1 to Len(aSL4)
		nPos 	:= aScan( aSL4[nX], {|x| Alltrim(Upper(x[1])) == "L4_NUM" } )
		If nPos == 0
			aAdd( aSL4[nX], { "L4_NUM", cNumOrc } )
		Else
			aSL4[nX][nPos][2] := cNumOrc
		Endif	
	Next nX
		
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o numero informado jah existe na base            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cNumOrc)
	nPos 	:= aScan( aSL1, {|x| Alltrim(Upper(x[1])) == "L1_NUM" } )
	If nPos > 0 .And. !Empty(aSL1[nPos][2])
		cNumOrc	:= aSL1[nPos][2]
	Endif
Endif
dbSelectArea("SL1")
dbSetOrder(1)
If dbSeek(xFilial("SL1")+cNumOrc) 
	If Empty(SL1->L1_DOC)
		lOperacao := .F.
	Else
		If lTela
			Aviso( STR0007, STR0008 + cNumOrc + STR0009, {"Ok"} ) //"Atenção"###"O orçamento informado ("###") já está vinculado a um documento fiscal."
		Else
			Conout( STR0008 + cNumOrc + STR0009, {STR0005} ) //"O orçamento informado ("###") já está vinculado a um documento fiscal."###"Ok"
		Endif
		lContinua := .F.
		
		// Se foi pedido para gerar o numero de orcamento. Tenta ateh encontrar um numero valido.
		If lGeraNumOrc
			While SL1->(dbSeek(xFilial("SL1")+cNumOrc)) .And. !Empty(SL1->L1_DOC)
				While (GetSX8Len() > nSaveSx8)
					ConfirmSx8()
				End
				cNumOrc := CriaVar("L1_NUM")
			Enddo
			lContinua := .T.
		Endif
		
	Endif
Else
	lOperacao := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a gravacao do 'pacote'                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a gravacao do SL1                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SL1")
	Lj7GeraSL( "SL1", aSL1, lOperacao, If(lAlteraFil,.T.,.F.) )
	If lOperacao
		While (GetSX8Len() > nSaveSx8)
			ConfirmSx8()
		End
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a gravacao do SL2                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SL2")
	dbSetOrder(1)
	If dbSeek(xFilial("SL2")+SL1->L1_NUM)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se for alteracao deleta o SL2 antes de fazer a gravacao      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof() .And. SL2->L2_FILIAL+SL2->L2_NUM == xFilial("SL2")+SL1->L1_NUM
			Begin Transaction 
		
			RecLock("SL2",.F.)
			dbDelete()
			MsUnlock()
			
			End Transaction
			dbSkip()          
		Enddo
	Endif
	         
	For nX := 1 to Len( aSL2 )
		Lj7GeraSL( "SL2", aSL2[nX], .T. )
	Next nX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a gravacao do SL4                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCont := 1
	dbSelectArea("SL4")
	dbSetOrder(1)
	dbSeek(xFilial("SL4")+SL1->L1_NUM)
	While !Eof() .And. SL4->L4_FILIAL+SL4->L4_NUM == xFilial("SL4")+SL1->L1_NUM
		If nCont <= Len(aSL4)
	    	Lj7GeraSL( "SL4", aSL4[nCont] )
	 	Else       
			Begin Transaction 
			
	 		RecLock("SL4",.F.)
	 		dbDelete()
	 		MsUnlock()
	 		
	 		End Transaction 
	 	Endif
    	SL4->(dbSkip())
		nCont ++
	Enddo
	For nX := nCont to Len(aSL4)
		Lj7GeraSL( "SL4", aSL4[nX], .T. )
	Next nX
	
    lRet := .T.
    cNumOrc := aSL1[aScan(aSL1,{|x|x[1]=="L1_NUM"})][2]
    
Else

	cNumOrc := Space(TamSX3("L1_NUM")[1])
	If lGeraNumOrc
		RoolBackSx8()
	Endif

Endif

aRet := { lRet, cNumOrc }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Volta o valor original da cFilAnt se necessario              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAlteraFil
	cFilAnt := cFilAux
Endif

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7PrepOrcºAutor  ³Andre Veiga         º Data ³  18/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Prepara os dados para a gravacao do orcamento               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ExpL1 := Lj7PrepOrc()                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 - .T. se a gravacao foi concluida com exito           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Loja701                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7PrepOrc( nOpc )
Local aArea			:= GetArea()
Local aSL1			:= {}
Local aSL2			:= {}
Local aSL4			:= {}
Local aAux 			:= {}
Local aCamposU		:= {}
Local aFormas       := {}             

Local nTotalDifForm := 0
Local nPosRet       := 0
Local nX	 		:= 0
Local nY	 		:= 0
Local nPos 			:= 0
Local nPosProd		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_PRODUTO"})][2]	// Posicao do Codigo do produto
Local nPosDescri	:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_DESCRI"})][2]		// Posicao da Descricao do produto
Local nPosQuant		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_QUANT"})][2]		// Posicao da Quantidade
Local nPosVrUnit	:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VRUNIT"})][2]		// Posicao do Valor unitario do item
Local nPosVlrItem   := aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VLRITEM"})][2]	    // Posicao do Valor Total do Item
Local nPosDesc		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_DESC"})][2]		// Posicao do percentual de desconto
Local nPosValDesc	:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VALDESC"})][2]	// Posicao do valor de desconto
Local nPosEntrega   := aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_ENTREGA"})][2]					// Posicao da Entrega
Local nPosDtTes		:= aPosCpoDet[03][2]				// Posicao do Codigo do TES
Local nPosDtCF		:= aPosCpoDet[04][2]				// Posicao do Codigo do CF 
Local nPosDtTabela	:= aPosCpoDet[09][2]				// Posicao da Tabela de precos
Local nPosDtDProp	:= aPosCpoDet[10][2]				// Posicao do Desconto proporcional
Local nPosDtPrcTab  := aPosCpoDet[11][2]				// Posicao do Preco de Tabela
Local nPosDtReserva	:= aPosCpoDet[15][2]				// Posicao do codigo da reserva
Local nPosDtLojaRes	:= aPosCpoDet[16][2]				// Posicao do codigo da reserva
Local nPosNumSerie	:= aPosCpoDet[21][2]				// Posicao do codigo do serial
Local nPosLoteCTL 	:= aPosCpoDet[22][2]				// Posicao do codigo do Sub Lote
Local nPosLote   	:= aPosCpoDet[23][2]				// Posicao do codigo numero do Lote
Local nPosLocaliz	:= aPosCpoDet[24][2]				// Posicao do codigo da localizacao
Local nPosDtLocal  	:= aPosCpoDet[20][2]				// Posicao do local (armazem)

Local nDinheiro		:= 0
Local nCheque 		:= 0
Local nCartao 		:= 0
Local nVlrDebi 		:= 0
Local nConveni		:= 0
Local nVales 		:= 0
Local nFinanc		:= 0
Local nOutros 		:= 0
Local nVlrEntrada 	:= 0
Local nVlrFSD		:= 0								// Valor do frete + seguro + despesas
Local nVlrTroco		:= Lj7T_Troco(2)					// Valor do troco
Local nPercProp		:= 0								// Percentual ref. a proporcao do valor do item no total da venda
Local nVlrItens		:= 0
Local nMoedaParc    := 1
Local nRestDiv      := 0                        
Local cNumOrc		:= Space(TamSx3("L1_NUM")[1])
Local cItem			:= StrZero(0,TamSx3("L2_ITEM")[1],0)
Local cCampo		:= ""
Local cCondPgto     := ""

Local dDataOrc		:= Ctod(Space(8))
Local dDataVal		:= Ctod(Space(8))
Local lReserva 		:= .F.
Local nItensRT      := 0
Local nPRT          := 0
Local nDescAcres    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a obrigatoriedade dos campos da enchoice                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRecebe .And. !Obrigatorio( aGets, aTela )

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Verificação de campos obrigatórios - N / N')
	EndIf
	
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as variaveis do cabecalho do orcamento                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRecebe

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Geração Orçamento - N')
	EndIf

	// Monta os arrays utilizados na gravacao dos impostos...
	If cPaisLoc <> "BRA"
		Lj7PrepGrvImp()
	EndIf

	cNumOrc 	:= M->LQ_NUM
	dDataOrc	:= dDatabase
	dDataVal 	:= M->LQ_DTLIM
	nVlrFSD		:= M->LQ_FRETE + M->LQ_SEGURO + M->LQ_DESPESA
	cCondPgto   := If(!lLayAway,If(Empty(M->LQ_CONDPG),"CN",M->LQ_CONDPG),"LAY")

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Geração Orçamento - N / ' + cNumOrc + ' / ' + DToC(dDataOrc))
	EndIf

	//***                                       se ecf                se nota fiscal
	//***cConfVenda :=  Subs(cConfVenda,1,7)+If(nCheck==1,"S","N")+If(nCheck==2,"S","N")+Subs(cConfVenda,10,3) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA1                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA3                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA3")
	dbSetOrder(1)
	dbSeek(xFilial("SA3")+M->LQ_VEND)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array aSL1                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDescAcres := ( Lj7T_Subtotal(2) - Lj7T_Total(2) )
	
	aAdd( aSL1, { "L1_FILIAL", 		xFilial("SL1") } )
	aAdd( aSL1, { "L1_EMISSAO", 	dDataOrc } )
	aAdd( aSL1, { "L1_NUM",	 		cNumOrc } )
	aAdd( aSL1, { "L1_COMIS",		SA3->A3_COMIS } )
	aAdd( aSL1, { "L1_VEND2",       SA3->A3_SUPER })
	aAdd( aSL1, { "L1_VEND3",       SA3->A3_GEREN })
	aAdd( aSL1, { "L1_CLIENTE",		SA1->A1_COD } )
	aAdd( aSL1, { "L1_LOJA",		SA1->A1_LOJA } )
	aAdd( aSL1, { "L1_TIPOCLI",		SA1->A1_TIPO } )
	aAdd( aSL1, { "L1_DESCONT",		iIf( nDescAcres < 0, 0, nDescAcres ) } ) // Considera tambem o desconto financeiro
	aAdd( aSL1, { "L1_DESCNF",		Lj7T_DescP(2) } )
	aAdd( aSL1, { "L1_DTLIM",		M->LQ_DTLIM } )
	aAdd( aSL1, { "L1_PARCELA",		Len(aPgtos) } )
	aAdd( aSL1, { "L1_CONDPG",		cCondPgto } )
	aAdd( aSL1, { "L1_FORMPG",		aPgtos[1][3] } )
	aAdd( aSL1, { "L1_CONFVEN",		"SSSSSSSSNSSS" } )
	aAdd( aSL1, { "L1_HORA",		Time() } )
	aAdd( aSL1, { "L1_TPFRET",		If(Empty(M->LQ_TPFRET),"",If(M->LQ_TPFRET=="1","C","F")) } )
	aAdd( aSL1, { "L1_IMPRIME",	 	"1N" } )
	aAdd( aSL1, { "L1_TIPODES", 	Str(aDesconto[1],1,0) } )
	aAdd( aSL1, { "L1_ESTACAO", 	cEstacao } )
	If cPaisLoc != "BRA"
	   aAdd( aSL1, { "L1_MOEDA", 	nMoedaCor } )	   
	   aAdd( aSL1, { "L1_TXMOEDA", 	nTxMoeda  } )	   	   
	EndIf

	//-- Se essa variavel for maior que zero, é desconto, caso contrário é acréscimo... Se for desconto, zero pq não vou
	//-- mais usá=lo como desconto, se for acréscimo eu pego o valor absoluto para somar ao total da venda.	
	nDescAcres := iIf( nDescAcres > 0, 0, Abs(nDescAcres) )
		
	If MaFisFound("NF") .And. !(nRotina == 4 .And. !Empty(SL1->L1_ORCRES))

		aAdd( aSL1, { "L1_VLRTOT",	( MaFisRet(,"NF_TOTAL") - nVlrFSD ) + nDescAcres })
		aAdd( aSL1, { "L1_VLRLIQ",	MaFisRet(,"NF_TOTAL") - nVlrFSD - Iif(cPaisLoc=="BRA",Lj7T_DescV(2),0) + nDescAcres } )
		aAdd( aSL1, { "L1_VALBRUT",	( MaFisRet(,"NF_TOTAL") - nVlrFSD + nDescAcres ) })
		aAdd( aSL1, { "L1_VALMERC",	MaFisRet(,"NF_VALMERC") } )

		If cPaisLoc == "BRA"

			aAdd( aSL1, { "L1_VALICM",	MaFisRet(,"NF_VALICM" ) } )
			aAdd( aSL1, { "L1_VALIPI",	MaFisRet(,"NF_VALIPI" ) } )
			aAdd( aSL1, { "L1_VALISS",	MaFisRet(,"NF_VALISS" ) } )
		
			If SL1->( FieldPos("L1_VALPIS")) > 0 .And. ;
		       SL1->( FieldPos("L1_VALCOFI")) > 0 .And. ;
		       SL1->( FieldPos("L1_VALCSLL")) > 0
	       
				aAdd(aSL1, {"L1_VALPIS" , iIf( LJPCCRet(1) > 0, LJPCCRet(1), MaFisRet(,'NF_VALPIS') ) })
				aAdd(aSL1, {"L1_VALCOFI", iIf( LJPCCRet(2) > 0, LJPCCRet(2), MaFisRet(,'NF_VALCOF') ) })
				aAdd(aSL1, {"L1_VALCSLL", iIf( LJPCCRet(3) > 0, LJPCCRet(3), MaFisRet(,'NF_VALCSL') ) })

		 	EndIf

		//-- Se existir o campo L1_ABTOPCC (onde é gravado o valor de abatimento de PIS/COFINS/CSLL)
		//-- grava o valor abatido do total da venda.
		If SL1->(FieldPos("L1_ABTOPCC")) > 0
			aAdd(aSL1, { "L1_ABTOPCC", LJPCCRET() })
		EndIf

			aAdd( aSL1, { "L1_BRICMS",	MaFisRet(,"NF_BASESOL" ) } )
			aAdd( aSL1, { "L1_ICMSRET",	MaFisRet(,"NF_VALSOL" ) } )

		EndIf   

	Endif

	// Valoriza os campos referentes aos impostos variáveis...
	If cPaisLoc <> "BRA"                                      
		//Realiza a gravacao do troco em sua respectiva moeda...
		For nY := 1 To Len(aMoedas)
			If ( ( nPos := aScan( aMoedas,{ |x| x[6] == nY } ) )  > 0 )
				AAdd(aSL1,{"L1_TROCO"+Alltrim(Str(nY)), aMoedas[nPos][3]})
			EndIf
		Next nY

		For nY := 1 to Len(aImpsSL1)
	    	Aadd(aSL1,{aImpsSL1[nY][2],aImpsSL1[nY][3]})   //Valor do imposto
	    	Aadd(aSL1,{aImpsSL1[nY][4],aImpsSL1[nY][5]})   //Base do imposto
	    	
			//Acerta o valor liquido abatendo o valor dos impostos...
    	  	If aImpsSL1[nY][06] == "1"
				aSL1[Ascan(aSL1,{|x| Trim(x[1]) == "L1_VLRLIQ"})][2] -= aImpsSL1[nY][3]
		  	EndIf                                                
  		Next nI   

		//Acerta o valor da mercadoria com base no valor liquido da venda...
		aSL1[Ascan(aSL1,{|x| Trim(x[1]) == "L1_VALMERC"})][2] := aSL1[Ascan(aSL1,{|x| Trim(x[1]) == "L1_VLRLIQ"})][2]
	Else
        //Para o caso do Brasil, existe apenas a gravacao do Troco em 1 moeda
		If SL1->( FieldPos( "L1_TROCO1" ) ) > 0 .AND. GetNewPar( "MV_LJTROCO", .F. ) .AND. nVlrTroco > 0 
			AAdd( aSL1, { "L1_TROCO1", nVlrTroco } )
		EndIf
	EndIf

	aAux := { "L1_VEND","L1_JUROS","L1_TIPOJUR","L1_TRANSP","L1_ENDCOB","L1_BAIRROC","L1_MUNC",;
				"L1_CEPC","L1_ESTC","L1_ENDENT","L1_BAIRROE","L1_MUNE","L1_CEPE","L1_ESTE","L1_VOLUME",;
				"L1_ESPECIE","L1_MARCA","L1_NUMERO","L1_PLIQUI","L1_PBRUTO","L1_PLACA","L1_UFPLACA",;
				"L1_FRETE","L1_SEGURO","L1_DESPESA" }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta o array aSL1                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aAux)
		cCampo := "M->LQ_"+Trim(Substr(aAux[nX],4,Len(aAux[nX])))
		aAdd( aSL1, { aAux[nX], &(cCampo) } )
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existem campos de usuario que estao sendo utilizados para    ³
	//³ gravacao do SL1                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(dbSetOrder(2))
	dbSelectArea("SL1")
	dbSetOrder(1)
	For nX := 1 to FCount()
		cCampo := FieldName(nX)
		If SX3->( dbSeek(PadR(cCampo,10," ")) )
			If SX3->X3_PROPRI $ "UT" .And. X3Uso(SX3->X3_USADO)
				cCampo := "M->LQ_"+	Trim(Substr(FieldName(nX),4,Len(FieldName(nX))))
				aAdd( aSL1, { FieldName(nX), &(cCampo) } )
			Endif
		Endif
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existem campos de usuario que estao sendo utilizados para    ³
	//³ gravacao do SL2                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCamposU := {}
	SX3->(dbSetOrder(2))
	For nX := 1 to len(aHeader)
		If SX3->(dbSeek(aHeader[nX][2]))
			If SX3->X3_PROPRI $ "UT" .And. X3Uso(SX3->X3_USADO)
				aAdd( aCamposU, SX3->X3_CAMPO )
			Endif
		Endif
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Analisa as proporcoes dos itens                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVlrItens := 0
	aEval( aCols, {|x| If(!x[Len(x)], nVlrItens += x[nPosVlrItem], Nil) } )
	
	//-- Rateio de ISS - Inicio
	nItensRT := 0
	nPRT     := 0
	
	aEval(aCols, { |x, y| iIf( ! x[Len(x)], ;
	                           iIf( Posicione("SF4", 1, xFilial("SF4") + aColsDet[y,nPosDtTes], "SF4->F4_ISS") == "S" .AND. LjAnalisaLeg(8)[1], ;
	                                nPRT += iIf( Lj7T_DescV(2) > 0, NoRound(( ( x[nPosVlrItem] / nVlrItens ) * 100 ), nDecimais), 0 ), ;
	                                nItensRT ++ ), Nil ) })

	If nPRT > 0 .AND. nItensRT > 0
		nPRT := NoRound(( nPRT / nItensRT ), nDecimais)
	Else
		nPRT := 0
	EndIf
	//-- Rateio de ISS - Final

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array aSL2                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aCols)
		If !aCols[nX][Len(aCols[nX])]

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Checa se existe reserva                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(aColsDet[nX][nPosDtReserva])
				lReserva := .T.
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona o SB1                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+aCols[nX][nPosProd]))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Checa o percentual da proporcao do item ref. ao todo.                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ! ( Posicione("SF4", 1, xFilial("SF4") + aColsDet[nX][nPosDtTes], "SF4->F4_ISS") == "S" .AND. LjAnalisaLeg(8)[1] )
				nPercProp := NoRound(( ( ( aCols[nX][nPosVlrItem] / nVlrItens ) * 100 ) + nPRT ), nDecimais )
			Else
				nPercProp := 0
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta o array aSL2                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd( aSL2, {} )
		
			cItem := SomaIt( cItem )
			aAdd( aSL2[Len(aSL2)], { "L2_FILIAL", 	xFilial("SL2") } )
			aAdd( aSL2[Len(aSL2)], { "L2_NUM", 		cNumOrc } )
			aAdd( aSL2[Len(aSL2)], { "L2_ITEM",		cItem } )
			aAdd( aSL2[Len(aSL2)], { "L2_PRODUTO",	aCols[nX][nPosProd] } )
			aAdd( aSL2[Len(aSL2)], { "L2_DESCRI", 	aCols[nX][nPosDescri] } )
			aAdd( aSL2[Len(aSL2)], { "L2_QUANT", 	aCols[nX][nPosQuant] } )
			aAdd( aSL2[Len(aSL2)], { "L2_VRUNIT", 	Iif(cPaisLoc<>"BRA".And.(aColsDet[nX][nPosDtDProp]<>0.Or.aDadosJur[1]<>0),MaFisRet(nX,"IT_PRCUNI"),aCols[nX][nPosVrUnit]) } )
			aAdd( aSL2[Len(aSL2)], { "L2_VLRITEM", 	Iif(cPaisLoc<>"BRA".And.(aColsDet[nX][nPosDtDProp]<>0.Or.aDadosJur[1]<>0),MaFisRet(nX,"IT_VALMERC"),aCols[nX][nPosVlrItem]) } )
			aAdd( aSL2[Len(aSL2)], { "L2_ENTREGA", 	aCols[nX][nPosEntrega] } )
			aAdd( aSL2[Len(aSL2)], { "L2_LOCAL", 	aColsDet[nX][nPosDtLocal] } )
			aAdd( aSL2[Len(aSL2)], { "L2_UM", 		SB1->B1_UM } )
			aAdd( aSL2[Len(aSL2)], { "L2_DESC", 	aCols[nX][nPosDesc] } )
			aAdd( aSL2[Len(aSL2)], { "L2_VALDESC", 	aCols[nX][nPosValDesc] } )
			aAdd( aSL2[Len(aSL2)], { "L2_DESCPRO", 	Iif(cPaisLoc=="BRA",Round((Lj7T_Subtotal(2) - Lj7T_Total(2)) * nPercProp / 100, nDecimais),aColsDet[nX][nPosDtDProp]) } )
			aAdd( aSL2[Len(aSL2)], { "L2_TES", 		aColsDet[nX][nPosDtTes] } )
			aAdd( aSL2[Len(aSL2)], { "L2_CF", 		aColsDet[nX][nPosDtCF] } )
			aAdd( aSL2[Len(aSL2)], { "L2_EMISSAO", 	dDataOrc } )
			aAdd( aSL2[Len(aSL2)], { "L2_GRADE", 	"N" } )
			aAdd( aSL2[Len(aSL2)], { "L2_VEND",		M->LQ_VEND } )
			aAdd( aSL2[Len(aSL2)], { "L2_TABELA",	aColsDet[nX][nPosDtTabela] } )
			aAdd( aSL2[Len(aSL2)], { "L2_PRCTAB", 	aColsDet[nX][nPosDtPrcTab] } )
			aAdd( aSL2[Len(aSL2)], { "L2_RESERVA", 	aColsDet[nX][nPosDtReserva] } )
			aAdd( aSL2[Len(aSL2)], { "L2_LOJARES", 	aColsDet[nX][nPosDtLojaRes] } )
			aAdd( aSL2[Len(aSL2)], { "L2_NSERIE", 	aColsDet[nX][nPosNumSerie] } )
			aAdd( aSL2[Len(aSL2)], { "L2_LOTECTL", 	aColsDet[nX][nPosLoteCTL] } )
			aAdd( aSL2[Len(aSL2)], { "L2_NLOTE", 	aColsDet[nX][nPosLote] } )
			aAdd( aSL2[Len(aSL2)], { "L2_LOCALIZ", 	aColsDet[nX][nPosLocaliz] } )

			If MaFisFound("IT",nX) .And. !(nRotina == 4 .And. !Empty(SL1->L1_ORCRES))

				If cPaisLoc == "BRA"

					aAdd( aSL2[Len(aSL2)], { "L2_VALIPI",	MaFisRet(nX,"IT_VALIPI") } )
					aAdd( aSL2[Len(aSL2)], { "L2_VALICM",	MaFisRet(nX,"IT_VALICM") } )
					aAdd( aSL2[Len(aSL2)], { "L2_VALISS",	MaFisRet(nX,"IT_VALISS") } )
					aAdd( aSL2[Len(aSL2)], { "L2_BASEICM",	MaFisRet(nX,"IT_BASEICM") } )

					//Caso exista os campos no Itens do orcamento, gravo seus respectivos valores
					//ref. a PIS/COFINS de Retencao ou Apuracao
					If SL2->(FieldPos("L2_VALPIS"))>0 .And. SL2->(FieldPos("L2_VALCOFI"))>0 .And. SL2->(FieldPos("L2_VALCSLL"))>0 ;
					   .And. SL2->(FieldPos("L2_VALPS2"))>0 .And. SL2->(FieldPos("L2_BASEPS2"))>0 .And. SL2->(FieldPos("L2_ALIQPS2"))>0 ;
					   .And. SL2->(FieldPos("L2_VALCF2"))>0 .And. SL2->(FieldPos("L2_BASECF2"))>0 .And. SL2->(FieldPos("L2_ALIQCF2"))>0 ;
					   .And. ( SA1->A1_RECPIS == "S" .OR. SA1->A1_RECCOFI == "S" .OR. SA1->A1_RECCSLL == "S" )

						aAdd( aSL2[Len(aSL2)], { "L2_VALPIS ", MaFisRet(nX,"IT_VALPIS") } )
						aAdd( aSL2[Len(aSL2)], { "L2_VALCOFI", MaFisRet(nX,"IT_VALCOF") } )
						aAdd( aSL2[Len(aSL2)], { "L2_VALCSLL", MaFisRet(nX,"IT_VALCSL") } )
					
						aAdd( aSL2[Len(aSL2)], { "L2_BASEPS2", MaFisRet(nX,"IT_BASECF2") } )
						aAdd( aSL2[Len(aSL2)], { "L2_BASECF2", MaFisRet(nX,"IT_BASECF2") } )
					
						aAdd( aSL2[Len(aSL2)], { "L2_VALPS2" , MaFisRet(nX,"IT_VALPS2") } )
						aAdd( aSL2[Len(aSL2)], { "L2_VALCF2" , MaFisRet(nX,"IT_VALCF2") } )
					
						aAdd( aSL2[Len(aSL2)], { "L2_ALIQPS2", MaFisRet(nX,"IT_ALIQPS2") } )
						aAdd( aSL2[Len(aSL2)], { "L2_ALIQCF2", MaFisRet(nX,"IT_ALIQCF2") } )
					
					EndIf

					aAdd( aSL2[Len(aSL2)], { "L2_BRICMS", 	MaFisRet(nX,"IT_BASESOL") } )
					aAdd( aSL2[Len(aSL2)], { "L2_ICMSRET",	MaFisRet(nX,"IT_VALSOL") } )

				EndIf	  

				aAdd( aSL2[Len(aSL2)], { "L2_VALFRE",	MaFisRet(nX,"IT_FRETE") } )
				aAdd( aSL2[Len(aSL2)], { "L2_SEGURO",	MaFisRet(nX,"IT_SEGURO") } )
				aAdd( aSL2[Len(aSL2)], { "L2_DESPESA",  MaFisRet(nX,"IT_DESPESA") } )				

			Endif
               
			If cPaisLoc <> "BRA"
		        For nY := 1 To Len(aImpsSL2[nX][3])
		        	If aImpsSL2[nX][3][nY][4] > 0 .And. aImpsSL2[nX][3][nY][3] > 0
			        	Aadd(aSL2[Len(aSL2)],{aImpsSL2[nX][3][nY][6],aImpsSL2[nX][3][nY][4]})   //Valor do imposto
		                Aadd(aSL2[Len(aSL2)],{aImpsSL2[nX][3][nY][7],aImpsSL2[nX][3][nY][3]})   //Base do imposto         
		                Aadd(aSL2[Len(aSL2)],{"L2_ALQIMP"+Substr(aImpsSL2[nX][3][nY][7],10,1),aImpsSL2[nX][3][nY][2]})   //Aliquota do imposto                           
	            	EndIf
	            Next nY
	        EndIf   
               
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica os campos de usuario ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nY := 1 to Len(aCamposU)
				nPos := aScan(aHeader,{|x| Trim(x[2])==Trim(aCamposU[nY]) })
				If nPos > 0
					aAdd( aSL2[Len(aSL2)], { "L2_"+Substr(aCamposU[nY],4,Len(aCamposU[nY])), 	aCols[nX][nPos] } )
				Endif
			Next nY

		Endif
	Next nX
EndIf
                          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe condicoes de pagamento que geram troco.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len( aPgtos )
	If IsMoney(aPgtos[nX][3]) .Or. Trim(aPgtos[nX][3]) == "VA"
		If Empty( aFormas ) .Or. aScan( aFormas, {|ExpA1| ExpA1[1] == aPgtos[nX][3] })== 0
			If cPaisLoc == "BRA"
				AAdd( aFormas , { aPgtos[nX][3] , 0 } )
			Else                                       
				AAdd( aFormas , { aPgtos[nX][3] , 0, aPgtos[nX][6] } )
			EndIf
		EndIf
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz o Rateio dos valores para geracao do troco por forma de pgto. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotalDifForm := Lj7AjustaTroco(.T.)
// Significa que o usuário utilizou o troco localizado, por isso nao deve ser realizado nenhum tipo de 
// acerto nos totais da venda.
If cPaisLoc <> "BRA" .And. nTotalDifForm == 0
	nVlrTroco := 0
EndIf
For nX := 1 To Len( aFormas )
	If nTotalDifForm > 0               
		If cPaisLoc == "BRA"
			aFormas[nX][2] := nTotalDifForm
		Else                               
			aFormas[nX][2] := Round(xMoeda(nTotalDifForm,nMoedaCor,aFormas[nX][3],dDatabase,MsDecimais(aFormas[nX][3])+1),MsDecimais(aFormas[nX][3]))
		EndIf
		nTotalDifForm -= nTotalDifForm
	EndIf
Next nX
		
//Executo o rateio dos valores de PIS/COFINS
If ( LJPCCRet() + iIf( lpTPAbISS, MaFisRet(,'NF_VALISS'), 0 ) ) > 0
	For nX := 1 to Len( aPgtos )
		aPgtos[nX][2] += NoRound(( LJPCCRet() + iIf( lpTPAbISS, MaFisRet(,'NF_VALISS'), 0 ) )/Len(aPgtos),nDecimais)
		nRestDiv += NoRound(( LJPCCRet() + iIf( lpTPAbISS, MaFisRet(,'NF_VALISS'), 0 ) )/Len(aPgtos),nDecimais)
	Next nX
	If ( LJPCCRet() + iIf( lpTPAbISS, MaFisRet(,'NF_VALISS'), 0 ) ) > nRestDiv
		aPgtos[Len(aPgtos)][2] += ( LJPCCRet() + iIf( lpTPAbISS, MaFisRet(,'NF_VALISS'), 0 ) ) - nRestDiv
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o array aSL4         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nVlrEntrada := 0
For nX := 1 to Len(aPgtos)
	// Considera a linha zerada quando for pagto com nota de credito
	If aPgtos[nX][2] <> 0 .Or. ( aPgtos[nX][2] == 0 .And. Len(aPgtos) == 1 .And. nNCCUsada > 0 )
		If !lRecebe
			aAdd( aSL4, {} )
			aAdd( aSL4[Len(aSL4)], { "L4_FILIAL",		xFilial("SL4") } )
			aAdd( aSL4[Len(aSL4)], { "L4_NUM", 			cNumOrc	} )
			aAdd( aSL4[Len(aSL4)], { "L4_DATA", 		aPgtos[nX][1] } )
		EndIf
		If IsMoney(aPgtos[nX][3]) .Or. aPgtos[nX][3] == "VA"
			If !lRecebe
				If cPaisLoc == "BRA"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Utilizado para a gravacao de troco em qualquer	|
					//³ numerario										|
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SL1->( FieldPos( "L1_TROCO1" ) ) <= 0 .AND. !GetNewPar( "MV_LJTROCO", .F. )
						aAdd( aSL4[Len( aSL4 )], { "L4_VALOR", aPgtos[nX][2] - nVlrTroco } )
					Else
						aAdd( aSL4[Len( aSL4 )], { "L4_VALOR", aPgtos[nX][2] } )
					EndIf
				Else 
					nVlrTrcAux := Round(xMoeda(nVlrTroco,nMoedaCor,aPgtos[nX][6],dDatabase,MsDecimais(aPgtos[nX][6])+1),MsDecimais(aPgtos[nX][6]))
					aAdd( aSL4[Len(aSL4)], { "L4_VALOR", 	aPgtos[nX][2] - nVlrTrcAux } )				
				EndIf
			EndIf
			
			If cPaisLoc == "BRA"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Utilizado para a gravacao de troco em qualquer	|
				//³ numerario										|
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SL1->( FieldPos( "L1_TROCO1" ) ) <= 0 .AND. GetNewPar( "MV_LJTROCO", .F. )
					nVlrParcela := aPgtos[nX][2] - nVlrTroco
				Else
					nVlrParcela := aPgtos[nX][2]
				EndIf
			Else
				nVlrParcela := aPgtos[nX][2] - nVlrTrcAux
			EndIf

			nVlrTroco   -= IIf( nVlrTroco > 0, LJ7T_Troco( 2 ), 0 )
		Else
			If !lRecebe
				aAdd( aSL4[Len(aSL4)], { "L4_VALOR", 	aPgtos[nX][2] } )
			EndIf
			nVlrParcela := aPgtos[nX][2]
		Endif
		If !lRecebe
			aAdd( aSL4[Len(aSL4)], { "L4_FORMA",		aPgtos[nX][3] } )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Guarda o valor do troco caso o campo exista na base³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If !Empty( aFormas )
				If cPaisLoc == "BRA"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Utilizado para a gravacao de troco em qualquer	|
					//³ numerario										|
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SL1->( FieldPos( "L1_TROCO1" ) ) <= 0 .AND. !GetNewPar( "MV_LJTROCO", .F. )
						nPosRet := aScan( aFormas, { |ExpA1| ExpA1[1] == aPgtos[nX][3] } )
	
						If nPosRet > 0
							AAdd( aSL4[Len( aSL4 )], { "L4_TROCO", aFormas[nPosRet][2] } )
						EndIf
					EndIf
				Else
					nPosRet := aScan( aFormas, { |ExpA1| ExpA1[1] == aPgtos[nX][3] } )

					If nPosRet > 0
						AAdd( aSL4[Len( aSL4 )], { "L4_TROCO", aFormas[nPosRet][2] } )
					EndIf
				EndIf
			Else
				AAdd( aSL4[Len(aSL4)], { "L4_TROCO", 0 } )
			EndIf

			If cPaisLoc != "BRA"
			   aAdd( aSL4[Len(aSL4)], { "L4_MOEDA",		aPgtos[nX][_MOEDA] } )			
		       nMoedaParc  := aPgtos[nX][_MOEDA]  			   
			EndIf
		EndIf	

		//Novo tratamento de visualização sintetizada
		If lVisuSint
			aAdd( aSL4[Len(aSL4)], { "L4_FORMAID",	aPgtos[nX][8] } )
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Checa os numerarios        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IsMoney(aPgtos[nX][3]) 
			nDinheiro += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		ElseIf Alltrim(aPgtos[nX][3]) == Alltrim(MVCHEQUE)
			nCheque += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		ElseIf Alltrim(aPgtos[nX][3]) == "CC"
			nCartao += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		ElseIf Alltrim(aPgtos[nX][3]) == "CD"
			nVlrDebi += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		ElseIf Alltrim(aPgtos[nX][3]) == "CO"
			nConveni += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		ElseIf Alltrim(aPgtos[nX][3]) == "VA"
			nVales += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		ElseIf Alltrim(aPgtos[nX][3]) == "FI"
			nFinanc += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		Else
			nOutros += Round(xMoeda(aPgtos[nX][2],nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o array aSL4         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aPgtos[nX][1] == dDatabase
			nVlrEntrada += Round(xMoeda(nVlrParcela,nMoedaParc,nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)
		Endif
	Endif	
Next nX

If !lRecebe
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajusta o SL1. Verifica se eh ou nao um orcamento gerado atraves da rotina de     ³
	//³reserva. Caso afirmativo nao grava os valores no SL1 para nao gerar financeiro   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nOpc <> 4) .or. (nOpc == 4 .And. Empty(SL1->L1_ORCRES) .And. Empty(SL1->L1_FILRES))
		aAdd( aSL1, { "L1_DINHEIR" ,nDinheiro } )
		aAdd( aSL1, { "L1_CHEQUES" ,nCheque } )
		aAdd( aSL1, { "L1_CARTAO"  ,nCartao } )
		aAdd( aSL1, { "L1_VLRDEBI" ,nVlrDebi } )
		aAdd( aSL1, { "L1_CONVENI" ,nConveni } )
		aAdd( aSL1, { "L1_VALES"   ,nVales } )
		aAdd( aSL1, { "L1_FINANC"  ,nFinanc } )
		aAdd( aSL1, { "L1_OUTROS"  ,nOutros } )
		aAdd( aSL1, { "L1_ENTRADA" , ( nVlrEntrada - Iif( nVlrEntrada > 0, LJPCCRet(), 0 ) ) })
		aAdd( aSL1, { "L1_CREDITO" ,If(nNCCUsada - (LJ7T_Total(2)- ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )) > 0,  (LJ7T_Total(2)- ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )), nNCCUsada) } )
		aAdd( aSL1, { "L1_RESERVA" ,If(lReserva,"S","") } )
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama as rotinas de gravacao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lGrava := Lj7GrvOrc( aSL1, aSL2, aSL4 )[1]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a funcao fiscal de finalização de Calculo              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MaFisFound("NF")
		MaFisEnd()
	Endif
Else
	lGrava := .T.
EndIf

If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Finalização Geração Orçamento - ' + iIf( lGrava, 'S', 'N' ))
EndIf

RestArea( aArea )
Return lGrava

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7GrvVendaºAutor ³Andre Veiga         º Data ³  20/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a efetivacao da venda e a impressao do cupom fiscal     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ExpL1 := Lj7GrvVenda( ExpL2, ExpL3, ExpA4 )                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpL2 - lFinanceiro - Indica se eh para gerar a movimentacaoº±±
±±º          ³        financeira ao gravar a venda                        º±±
±±º          ³ExpL3 - lRecTrib - Chama a funcao de recalculo das tributa- º±±
±±º          ³        coes.                                               º±±
±±º          ³ExpA4 - Array com os dados do consumidor Final(Loc. Arg)    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 - Indica se conseguiu ou nao fazer a gravacao         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Loja701                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7GrvVenda( lFinanceiro, lRecTrib, aDadosCF, nHandle )
Local aArea			:= Lj7GetArea( {"SL1","SL2","SL4"} )
Local aRet          := {.T.,'',''}
Local lRet 			:= .F.
Local cDoc			:= ""
Local cPdv 			:= ""
Local cSerie 		:= ""
Local aSL1			:= {}
Local aSL2			:= {}
Local aSL4			:= {}
Local aSLS          := {}
Local aMAD          := {}
Local aReservas	 	:= {}
Local aNumLay       := {}
Local i, nI, nX 	:= 0
Local nCont 		:= 0
Local nVlrTroco 	:= Lj7T_Troco(2)
Local nVlrAux 		:= 0
Local nPosLay       := 0
Local nPosItLay     := 0
Local nRecnoSL2     := 1
Local nOutros       := 0
Local nPosVlItem    := aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VLRITEM"})][2]	    // Posicao do Valor Total do Item
Local nTotalItem    := 0
Local nTotalLay     := 0
Local lTefOk	    := .F.
Local lCartao       := .F. //Uso do TEF
Local lCompensa     := .F.  //Compensacao do Lay-Away(POR|EUA)
Local lLayTotal     := .T.
Local cTotRecNFis   := GetPvProfString("Recebimento Titulos", "Totalizadores", "01", GetClientDir()+"SIGALOJA.INI")
Local cNumCupom     := Space(TamSx3("L1_NUM")[1])
Local lErroCF		:= .F.
Local lLj7019       := ExistBlock("LJ7019")                                     
Local xRet       
Local lErrCupTEF	:= .F.
Local lGaveta       := ( ! Empty(LJGetStation("GAVETA")) )
Local nRestDiv      := 0
Local lAbtoAll      := .F.
Local cMvSimb1		:= GetMv("MV_SIMB1")
Local cAdminis		:= TamSX3("L4_ADMINIS")[1]
Local lLog1       	:= Subs(LJGetProfile("LOGERRO"),1,1) == "S" // Tem Log de Erro
Local lLog4         := Subs(LJGetProfile("LOGERRO"),4,1) == "S" // Log de Recuperacao, grava as parcelas
Local nSize         := 0
Local cRBuffer      := ""
Local nPos			:= 0
Local nVlrEntrada	:= 0

Default lFinanceiro	:= .T.
Default lRecTrib 	:= .T.
Default nHandle     := -1

If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Inicio Gravação da Venda')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se foram informadas as formas de pagamento. Caso negativo nao    ³
//³permite finalizar a venda.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFinanceiro

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Gravação da Venda - S')
	EndIf

	nVlrAux := nNCCUsada
	aEval( aPgtos, {|x| nVlrAux+=x[2] } )
	If nVlrAux == 0
		Aviso( STR0007, STR0010, {STR0005} ) //"Atenção"###"Não foram informadas as formas de pagamento. Impossível fechar a venda."###"OK"
		Return lRet
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se necessario abre a tela para para pedir os dados dos       ³
	//³ cheque / financiadora                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Lj7InfPgtos()
	
		If !Empty(LOG_TEF)
			LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Tela Digitação de Dados do Pagamento - N')
		EndIf

		Return .F.
	Endif
    // Uso TEF
    // Verifica se algumas das parcelas ‚ Cartao de Cr‚dito, Cartao de d‚bito ou Cheque (TEF DISCADO)
    For nI:= 1 To Len(aPgtos)
		//Com a utilização da DLL ainda não existe a possibilidade do controle de milhas com o cartão CCS da EMS
		If cTipTef $ TEF_CLISITEF
		   If AllTrim(aPgtos[nI][3]) $ _FORMATEF .Or. ;
		   	 (AllTrim(aPgtos[nI][3]) == AllTrim(MVCHEQUE) .And. At("S",LjGetStation("TEFCONS"))<>0)
			  lCartao:= .T.
			  Exit
		   EndIf
		Else
		   If AllTrim(aPgtos[nI][3]) $ _FORMATEF .Or. AllTrim(aPgtos[nI][3]) == "MH" .Or. ;
		   	 (AllTrim(aPgtos[nI][3]) == AllTrim(MVCHEQUE) .And. (GetMV("MV_INTEEMS") .Or. At("S",LjGetStation("TEFCONS"))<>0) )
			  lCartao:= .T.
			  Exit
		   EndIf
		EndIf
    Next nI

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Tem parcelas CC/CD/MH ? - ' + iIf( lCartao, 'S', 'N' ))
	EndIf
    
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre a Gaveta de Dinheiro  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGaveta
	AbreGaveta()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa o recalculo das tributacoes da venda                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRecebe .And. lRecTrib .And. cPaisLoc == "BRA"
	Lj7RecTrib()
Endif
// Inicializa antes da Trn TEF
lCCS     := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apos ser realizado a impressao do cupom TEF, eh gerado um  |
//³ arquivo para a sua reimpressao, exceto VISANET. Este       |
//³ arquivo deve ser apagado sempre que iniciar uma nova venda |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
L010DelImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a Transacao TEF                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaTef .And. lCartao .And. cTipTEF $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO+";"+TEF_CLISITEF

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Inicio Transação TEF - S / S / ' + cTipTEF)
	EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Tratamento Parce                                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cOrcamen := SL1->L1_NUM
	aReb     := {}
	aParcTef := {}
	
	If cTipTef == TEF_CLISITEF

		//Pegando os dados totalizados de cartões a serem enviados para a transacao TEF
		For nI := 1 To Len(aPgtosSint)
			If AllTrim(aPgtosSint[nI][1]) $ _FORMATEF
			
				//Verica o valor da primeira parcela a ser enviada para a transação TEF
				nPos := Ascan(aPgtos,{|x| AllTrim(x[3])+AllTrim(x[8]) == AllTrim(aPgtosSint[nI][1])+AllTrim(aPgtosSint[nI][4]) } )
				nVlrEntrada := If(nPos>0,aPgtos[nPos][2],0)
			
		        Aadd(aReb,{ aPgtosSint[nI][5],;												//Data
			        	    Val(StrTran(StrTran(aPgtosSint[nI][3],",",""),".",""))/100,;	//Valor
			        	    aPgtosSint[nI][1],;												//Forma
			        	    aPgtosSint[nI][4],;												//ID para identificação da forma de pagamento na operação TEF
			        	    aPgtosSint[nI][2],;												//Qtde de Parcelas
							nVlrEntrada,;													//Valor Entrada
			        	    {Space(03),Space(3),Space(04),Space(10),Space(07),Space(15),Space(15)}}) //Dados do Cheque
			EndIf
		Next nI

		//Se a estação utilizar consulta de cheques pegar os dados analíticos de todos os cheques a serem consultados
		If At("S",LjGetStation("TEFCONS")) <> 0
			For nI := 1 To Len(aPgtos)
				If Alltrim(aPgtos[nI][3]) == AllTrim(MVCHEQUE)
					Aadd(aReb,{ aPgtos[nI][1],;												//Data
								aPgtos[nI][2],;												//Valor
								aPgtos[nI][3],;												//Forma
								aPgtos[nI][8],;												//ID para identificação da forma de pagamento na operação TEF
								1,;															//Quantidade de Parcelas
								0,;															//Valor de Entrada, para cheques podemos considerar o mesmo
								{aPgtos[nI][4][8],aPgtos[nI][4][4],aPgtos[nI][4][5],aPgtos[nI][4][6],aPgtos[nI][4][7],aPgtos[nI][4][9],aPgtos[nI][4][10]}}) //Dados do Cheque
				EndIf
			Next nI
	    EndIf
	Else
		For nI := 1 To Len(aPgtos)
			If AllTrim(aPgtos[nI][3]) $ _FORMATEF .Or. AllTrim(aPgtos[nI][3]) == "MH" .Or. (AllTrim(aPgtos[nI][3]) == AllTrim(MVCHEQUE) .And. (GetMV("MV_INTEEMS") .Or. At("S",LjGetStation("TEFCONS"))<>0) )
				If Alltrim(aPgtos[nI][3]) == Alltrim(MVCHEQUE)
					aadd(aReb    , {aPgtos[nI][1],aPgtos[nI][2],aPgtos[nI][3],aPgtos[nI][4][7],;
					aPgtos[nI][4][4], aPgtos[nI][4][5], aPgtos[nI][4][6],nI})
				Else
					aadd(aReb    , {aPgtos[nI][1],aPgtos[nI][2],aPgtos[nI][3],aPgtos[nI][4][5],nI,aPgtos[nI][4][7]})
				Endif
				aadd(aParcTef, {aPgtos[nI][1],aPgtos[nI][2],aPgtos[nI][3],1,aPgtos[nI][4][5]})
			EndIf
			aCartoes := Lj010LerCartao(aPgtos[nI,3])
			If Alltrim(aPgtos[nI][3]) $ _FORMATEF .Or. AllTrim(aPgtos[nI][3]) == "MH"
				cCartao := Iif(Empty(aPgtos[nI][4][5]),aCartoes[1],aPgtos[nI][4][5])
			Else
				cCartao	:= ""
			EndIf
		Next nI
	EndIf
	
	If cTipTef == TEF_CLISITEF
		oTEF:Operacoes("V",aReb)
		lTefOk := oTef:lTefOk
	Else
		lTefOk := LOJA010T( "V" , ,aReb)	
	EndIf	
	
	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Venda TEF - ' + iIf( ValType(lTefOK) == "L", iIf( lTefOK, 'S', 'N' ), lTefOk ))
	EndIf

	If !Valtype(lTefOk ) == "L"
		lTefOk := .F.
	ElseIf !lTefOk
		If cTipTef <> TEF_CLISITEF
			//HOMOLOGACAO: Enviar o desfazimento da operação TEF para impedir transações pendentes no Sitef
			If TEF_lEnvDF()
	
				If !Empty(LOG_TEF)
					LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Envio Desfazimento TEF')
				EndIf
	
				If LOJA010T("F","D")
	
					If !Empty(LOG_TEF)
						LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Transação TEF não efetuada!')
					EndIf
	
					MsgAlert(STR0047) 	//"Transação TEF não efetuada!"
	
				EndIf
	
			//Na versào 3.00 do TEF qdo quando ocorre erro nao e necessario cancelar enviei o desfazimento, respeito as versoes anteriores do Sitef
			ElseIf !(GetMV("MV_TEFVERS") == "03.00") .Or. GetNewPar("MV_TEFMULT",.F.)
				If !Empty(LOG_TEF)
					LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Envio Cancelamento TEF - ' + GetMV("MV_TEFVERS") + ' / ' + ;
					       iIf( GetNewPar("MV_TEFMULT", .F.), 'S', 'N' ))
				EndIf
	
				If LOJA010T("F","N")	//Antigamente esta função nao retornava verdadeiro ou falso
	
					If !Empty(LOG_TEF)
						LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Transação TEF não efetuada!')
					EndIf
	
					MsgAlert(STR0047) 	//"Transação TEF não efetuada!"
				EndIf				
			EndIf
		EndIf    
	
	Endif

	If !lTefOk
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se o usuario optar por nao continuar manualmente, apaga as informacoes³
		//³ de pagamento para serem informadas novamente                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Foi colocado um parâmetro para determinar se o cliente utiliza ou não esta pergunta
		If !GetNewPar("MV_TEFMANU",.F.)
			aRet[1]	:= .F. 	
		Else
			aRet[1] := LojaOk(STR0011) 	//"Continua Manualmente?"
		EndIf			
		
		If !Empty(LOG_TEF)
			LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Continua Manualmente - ' + iIf( aRet[1], 'S', 'N' ))
		EndIf
	EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a Impressao do Cheque. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(LjGetStation("IMPCHQ")) .And. !Empty(LjGetStation("PORTCHQ"))
	LJ7ImpCH()
EndIf
		
If !lRecebe
	If lFiscal
		nRet := IFPegCupom( nHdlECF, @cNumCupom )
		cNumCupom := StrZero(Val(cNumCupom)+1, 6 )
		cSerie := LjGetStation("LG_SERIE")
		// Verifica Se o Cupom Ja Foi Processado.
		SF2->(dbSetOrder(1))
		If SF2->(dbSeek(xFilial("SF2")+cNumCupom+cSerie))
			aRet[1] := .F.
			aRet[2] := " "
			aRet[3] := STR0044 +SL1->L1_NUM+Chr(10)+ STR0045 +SL1->L1_DOC+SL1->L1_SERIE       //"Orcamento: " "DOC e SERIE ja existente no SF2: "	
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a impressao do cupom fiscal                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc != "ARG"
				If aRet[1]
					Do While .T.
						LjMsgRun( STR0012,, {|| (aRet := Lj7ImpCF(lTefOk)) } ) 	//"Aguarde ... Imprimindo o cupom fiscal ...."
						lErroCF := !aRet[1]
						If lErroCF
							If Aviso(STR0031,STR0050,{STR0051,STR0052},,STR0049) == 1 // ""Atencao!" ### "Tentar imprimir novamente?" ### "&Sim" "&Não" ### "Impressora não responde!"
								Loop
							EndIf	
						EndIf
						Exit	
					EndDo
				EndIf		
	    	Else		
				If aRet[1]
				   LjMsgRun( STR0012,, {|| (aRet := Lj7ImpCFArg()) } ) //"Aguarde ... imprimindo o cupom fiscal ...."
				   lErroCF := !aRet[1]
				EndIf
			EndIf
		EndIf                          	
	EndIf	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza o(s) Recebimento Nao-Fiscal e a Autenticacao do(s) documento(s) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i := 1 To Len(aTitulo)

		If !File( GetClientDir()+"SIGALOJA.INI" )
			WritePProString("Recebimento Titulos", "Totalizadores", "01", GetClientDir()+"SIGALOJA.INI")
		EndIf

		If cPaisLoc == "BRA" .Or. (cPaisLoc <> "BRA" .And. lFiscal)
			nRet := IFRecebNFis( nHdlECF, cTotRecNFis, aTitulo[i][10], &(GetMV("MV_NATRECE")))
			
			If nRet <> 0
				MsgStop(STR0020, STR0007)	// "Erro ao efetuar o Recebimento Não-Fiscal.", "Atenção"
			Else
				// "Autenticação do documento", "Insira o " ### "o. documento, no valor de " ### " para autenticação..."
				// "Autenticar", "Ignorar"
				If Aviso(STR0021, STR0022+AllTrim(Str(i))+STR0023+GetMv("MV_SIMB1")+" "+;
						AllTrim(Transform(aTitulo[i][10], PesqPict("SE1", "E1_VALOR", 15)))+STR0024, {STR0025, STR0026}) == 1
					IFAutentic( nHdlECF, "1", "", "")
				EndIf
			EndIf
		Else          
			// Verifica se existe o PE Lj7019, atraves do qual podera ser realizada a 
			// impressão de um comprovante de pagamento do título.
			If lLj7019                                            
				xRet := ExecBlock( "LJ7019",.F.,.F.,{cTotRecNFis, aTitulo[i][10], &(GetMV("MV_NATRECE"))} )			
			         
				// Caso ocorra algum problema na impressão do comprovante o PE poderá
				// retornar .F. e a gravação do recebimento será abortada.
				If ValType(xRet) == "L"
					lRet := xRet
				EndIf
			EndIf
		EndIf
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a impressao do cupom TEF								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRecebe

	If lTefOk .And. lUsaTef .And. lCartao .And. cTipTEF $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO+";"+TEF_CLISITEF

		If lLog1 .And. lLog4 .And. nHandle >= 0
		
			nSize    := FSeek(nHandle, 0, 2)
			cRBuffer := Space(( nSize + 5 ))
			
			FSeek(nHandle, 0, 0)
			FRead(nHandle, @cRBuffer, nSize)
			
			cRBuffer := Encript(cRBuffer, 1) + "#TEF#"
			
			FSeek(nHandle, 0, 0)
			FWrite(nHandle, Encript(cRBuffer, 0))
			
			LjGrLogT(SL1->L1_NUM, aRet[02][01], xNumCaixa(), aTefDados, SL1->L1_DINHEIRO, SL1->L1_CHEQUES, SL1->L1_CARTAO, ;
			         SL1->L1_VLRDEBI, SL1->L1_CONVENI, SL1->L1_VALES, SL1->L1_FINANC, SL1->L1_OUTROS, SL1->L1_DESCONT, ;
			         SL1->L1_DESCNF, aRet[02][02], cSerie)
			         
		Endif	
	
		If !Empty(LOG_TEF)
			LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Impressão do cupom tef - N / S / S / S / ' + cTipTEF)
		EndIf

		If aRet[1]
			If cTipTef == TEF_CLISITEF
				oTEF:ImpCupTef()
				lErrCupTEF := !oTef:lImprimiu
			Else
				lErrCupTEF := If(LOJA010T("I","V"),.F.,.T.)
			EndIf
			
			If !lErrCupTEF
				If lLog1 .And. lLog4 .AND. nHandle >= 0
					nSize    := FSeek(nHandle, 0, 2)
					cRBuffer := Space(( nSize + 9 ))
			
					FSeek(nHandle, 0, 0)
					FRead(nHandle, @cRBuffer, nSize)
			
					cRBuffer := Encript(cRBuffer, 1) + "#OK#"
			
					FSeek(nHandle, 0, 0)
					FWrite(nHandle, Encript(cRBuffer, 0))			
				Endif

				If cTipTef <> TEF_CLISITEF
					lTefOk := LJ701AtCartao()
				EndIf

			EndIf
			
		EndIf

		If cTipTef == TEF_CLISITEF
			If oTef:lTefOk .And. !aRet[1] 	//Se deu problema no cupom fiscal, cancelar a transacao TEF
	   		   oTEF:FinalTrn(0) 			//Finaliza a TRN com parametro confirma = 1
   		   	   MsgInfo(STR0048) 			//"Transação TEF não efetuada, favor reter o cupom!"
			EndIf
		Else
			If !aRet[1]
				lTefOk := LOJA010T( "F", "N" )
				If lTefOk
		  		   MsgInfo(STR0048) //"Transação TEF não efetuada, favor reter o cupom!"
				EndIF		  	   
			EndIf
		EndIf
		
		If !Empty(LOG_TEF)
			LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Impressão do cupom tef - ' + iIf( aRet[1], 'S', 'N' ) + ' / ' + ;
			           iIf( lTefOk, 'S', 'N' ) + ' / ' + iIf( lErrCupTEF, 'S', 'N' ))
		EndIf

	EndIf

Else

	If lTefOk .And. lUsaTef .And. lCartao .And. cTipTEF $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO+";"+TEF_CLISITEF

		If !Empty(LOG_TEF)
			LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Impressão do cupom tef - S / S / S / S / ' + cTipTEF)
		EndIf

		If aRet[1]
			If cTipTef == TEF_CLISITEF
				oTEF:ImpCupTef()
				lErrCupTEF := !oTef:lImprimiu
			Else
				lErrCupTEF := If(LOJA010T("I","V",,,,&(GetMV("MV_NATRECE"))),.F.,.T.)
				If !lErrCupTEF
					lTefOk := LJ701AtCartao()
				EndIf
			EndIf	
		EndIf

		//Se não consegui efetuar a impressão do cupom TEF
		If !aRet[1]
			If cTipTef == TEF_CLISITEF
				If oTef:lTefOk 				 	//Se deu problema no cupom fiscal, cancelar a transacao TEF
		   		   oTEF:FinalTrn(0) 			//Finaliza a TRN com parametro confirma = 1
   			   	   MsgInfo(STR0048) 			//"Transação TEF não efetuada, favor reter o cupom!"
				EndIf
			Else
				lTefOk := LOJA010T( "F", "N" )
				If lTefOk
			  	   MsgInfo(STR0048) //"Transação TEF não efetuada, favor reter o cupom!"
				EndIF		  	   
			EndIf	
		EndIf
		
		If !Empty(LOG_TEF)
			LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Impressão do cupom tef - ' + iIf( aRet[1], 'S', 'N' ) + ' / ' + ;
			           iIf( lTefOk, 'S', 'N' ))
		EndIf

	EndIf
	
EndIf

If lRecebe
	LJGrvRec(aPgtos)
	lRet := .T.
Else
	If aRet[1]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Checa o numero do COO, do PDV e da Serie                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc == "BRA" .Or. (cPaisLoc <> "BRA" .And. lFiscal)
			cDoc 	:= aRet[2][1]
			cPdv	:= aRet[2][2]
			cSerie 	:= LjGetStation("LG_SERIE")
		Else
			If cPaisLoc == "ARG" .And. !lFiscal
				cSerie := Lj7SerArg()
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a gravacao do SL1                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( aSL1, { "L1_NUM"    ,SL1->L1_NUM } )
		aAdd( aSL1, { "L1_DOC"    ,cDoc } )
		aAdd( aSL1, { "L1_NUMCFIS",cDoc } )
		aAdd( aSL1, { "L1_PDV"    ,cPdv } )
		aAdd( aSL1, { "L1_SERIE"  ,cSerie } )
		aAdd( aSL1, { "L1_TIPO"   ,"V" } )
		aAdd( aSL1, { "L1_OPERADO",xNumCaixa() } )                
		If cPaisLoc == "BRA" .Or. (cPaisLoc <> "BRA" .And. lFiscal)
			aAdd( aSL1, { "L1_IMPRIME","1S" } ) // 1-Cupom | 2-Nota | 3-Cupom de Venda | 4-Nao Imprimir
		Else
			aAdd( aSL1, { "L1_IMPRIME","2S" } ) // 1-Cupom | 2-Nota | 3-Cupom de Venda | 4-Nao Imprimir
		EndIf
		aAdd( aSL1, { "L1_VENDTEF","N"})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso ocorra erro na transacao TEF, continua a gravacao do cupom, ³
		//³ pois o mesmo nao pode ser cancelado no ECF.                      ³
		//³ Neste caso sera necessario realizar uma NOTA DE DEVOLUCAO.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lErrCupTEF
			AAdd(aSL1, {"L1_STATUS", "T"})	
		EndIf

		If lUsaTef .And. lTefOk .And. !lErrCupTEF

			If cTipTef == TEF_CLISITEF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a alteracao das datas e conf. de ADM informadas durante o processamento do TEF		           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				LjTEFAceParc()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Gerando os dados do TEF para a tabela SL1													   		   |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aSL1 := LjTEFGeraSL(aSL1,"SL1")

			ElseIf cTipTef $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO
				aAdd( aSL1, { "L1_VENDTEF","S"})
				aAdd( aSL1, { "L1_DATATEF",aTefDados[1][2]})
				aAdd( aSL1, { "L1_HORATEF",aTefDados[1][3]})
				aAdd( aSL1, { "L1_DOCTEF" ,aTefDados[1][4]})
				aAdd( aSL1, { "L1_AUTORIZ",aTefDados[1][5]})
				aAdd( aSL1, { "L1_INSTITU",aTefDados[1][8]})
				aAdd( aSL1, { "L1_DOCCANC",aTefDados[1][6]})
				aAdd( aSL1, { "L1_DATCANC",aTefDados[1][12]})
				aAdd( aSL1, { "L1_HORCANC",aTefDados[1][7]})
				aAdd( aSL1, { "L1_NSUTEF" ,aTefDados[1][9]})
				aAdd( aSL1, { "L1_TIPCART",aTefDados[1][10]})
				If !Empty(aTefDados[1][15])
					aAdd( aSL1, { "L1_FORMPG",aTefDados[1][15]})
				EndIf
				If SL1->(FieldPos("L1_PARCTEF"))>0
					//Tipo de Parcelamento ("0" - Estabelecimento / "1" - Administradora) + Quantidade de Parcelas
					AAdd(aSL1, {"L1_PARCTEF", aTefDados[1][16]+aTefDados[1][17]})
				EndIf
			EndIf
		EndIf

		Lj7GeraSL( "SL1", aSL1, .F., .F. )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a gravacao do SL2                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SL2")
		dbSetOrder(1)
		dbSeek(xFilial("SL2")+SL1->L1_NUM)
		nRecnoSL2  := Recno()
		nOutros    := SL1->L1_OUTROS  //Valor para dar baixa no Lay-Away		
		While !Eof() .And. SL2->L2_FILIAL+SL2->L2_NUM == xFilial("SL2")+SL1->L1_NUM

			aSL2 := {}
			aAdd( aSL2, { "L2_VENDIDO", 	"S" } )	// Gravar como "S" somente quando !Empty(L1_DOC)
			aAdd( aSL2, { "L2_DOC",  		cDoc } )
			aAdd( aSL2, { "L2_SERIE", 		cSerie } )
			aAdd( aSL2, { "L2_PDV", 		cPdv } ) 
			Lj7GeraSL( "SL2", aSL2 )

			If !Empty(SL2->L2_RESERVA)
				aAdd( aReservas, { SL2->L2_RESERVA, SL2->L2_PRODUTO, SL2->L2_LOCAL } )
			Endif
		
			dbSelectArea("SL2")
			dbSkip()
		Enddo                  

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a gravacao do SL4 somente se nao for orcamento gerado de ³
		//³ um pedido                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(SL1->L1_FILRES) .And. Empty(SL1->L1_ORCRES)
		         
			// Teve abatimento total no valor da venda (PIS/COFINS/CSLL)
			If Len(aPgtos) == 1 .AND. Empty(aPgtos[01,01]) .AND. aPgtos[01,02] == ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )
				lAbtoAll := .T.
			EndIf
		
			For nX := 1 to Len( aPgtos )
				aAdd( aSL4, {} )
				aAdd( aSL4[nX], { "L4_FILIAL",	xFilial("SL4") } )
				aAdd( aSL4[nX], { "L4_NUM", 	SL1->L1_NUM	} )
				aAdd( aSL4[nX], { "L4_DATA", 	iIf( lAbtoAll, dDataBase, aPgtos[nX][1] ) })

				If IsMoney(aPgtos[nX][3]) .OR. aPgtos[nX][3] == "VA"
					If cPaisLoc == "BRA"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Utilizado para a gravacao de troco em qualquer	|
						//³ numerario										|
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SL1->( FieldPos( "L1_TROCO1" ) ) <= 0 .OR. !GetNewPar( "MV_LJTROCO", .F. )
							aAdd( aSL4[Len( aSL4 )], { "L4_VALOR", aPgtos[nX][2] - nVlrTroco } )
						Else
							aAdd( aSL4[Len( aSL4 )], { "L4_VALOR", aPgtos[nX][2] } )
						EndIf
					Else
						aAdd( aSL4[Len(aSL4)], { "L4_VALOR", 	aPgtos[nX][2] - nVlrTroco } )
					EndIf

					nVlrTroco -= If( nVlrTroco > 0, Lj7T_Troco( 2 ), 0 )
				Else
					aAdd( aSL4[nX], { "L4_VALOR", 	IIf( lAbtoAll, 0, aPgtos[nX][2] ) } )
				Endif

				aAdd( aSL4[nX], { "L4_FORMA",	IIf( lAbtoAll, cMVSimb1, aPgtos[nX][3] ) } )
				
				//Reajuste dos valores de Pis/Cofins
				If ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) ) > 0 .AND. ! lAbtoAll
					nPos 	:= aScan( aSL4[nX], {|x| Alltrim(Upper(x[1])) == "L4_VALOR" } )
					If nPos > 0
						aSL4[nX][nPos][2] -= NoRound(( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )/Len(aPgtos),nDecimais)
						nRestDiv += NoRound(( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )/Len(aPgtos),nDecimais)
					EndIf
					
					If Len( aPgtos ) == nX .And. ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) ) > nRestDiv
						aSL4[nX][nPos][2] -= ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) ) - nRestDiv
					EndIf
				EndIf				
		
				If !(IsMoney(aPgtos[nX][3])) .And. Empty(SL1->L1_FILRES) .And. Empty(SL1->L1_ORCRES) .And.;
				   !lLayAway
					If Trim(aPgtos[nX][3]) == "CH"
						aAdd( aSL4[nX], { "L4_ADMINIS",	aPgtos[nX][4][04] } )
						aAdd( aSL4[nX], { "L4_NUMCART",	aPgtos[nX][4][07] } )
						aAdd( aSL4[nX], { "L4_AGENCIA",	aPgtos[nX][4][05] } )
						aAdd( aSL4[nX], { "L4_CONTA",	aPgtos[nX][4][06] } )
						aAdd( aSL4[nX], { "L4_RG",		aPgtos[nX][4][09] } )
						aAdd( aSL4[nX], { "L4_TELEFON",	aPgtos[nX][4][10] } )
						aAdd( aSL4[nX], { "L4_COMP",	aPgtos[nX][4][08] } )
						aAdd( aSL4[nX], { "L4_TERCEIR",	aPgtos[nX][4][12] } )
					Else
						If ! lAbtoAll
							aAdd( aSL4[nX], { "L4_ADMINIS",	aPgtos[nX][4][05] } )
							aAdd( aSL4[nX], { "L4_NUMCART",	aPgtos[nX][4][04] } )
						EndIf
					Endif
				Endif
				
				aAdd( aSL4[nX], { "L4_VENDTEF","N"})

				If lUsaTef .And. lTefOk 

					If cTipTEF == TEF_CLISITEF

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Gerando os dados do TEF para a tabela SL4													   		   |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aSL4 := LjTEFGeraSL(aSL4,"SL4",aPgtos[nX][1],aPgtos[nX][3],aPgtos[nX][8],aPgtos[nX][4][07],NIL,NIL,NIL,nX)
					
					ElseIf cTipTef $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO
		                If (nPos := Ascan(aTefMult,{|x| Ascan(x[10],StrZero(nX,2))>0 }))<>0
			                If Len(aTefMult[nPos][7])>0
			    	            aTefDados:=aClone(aTefMult[nPos][7])
								aAdd( aSL4[nX], { "L4_VENDTEF","S"})
								aAdd( aSL4[nX], { "L4_DATATEF",aTefDados[1][2]})
								aAdd( aSL4[nX], { "L4_HORATEF",aTefDados[1][3]})
								aAdd( aSL4[nX], { "L4_DOCTEF" ,aTefDados[1][4]})
								aAdd( aSL4[nX], { "L4_AUTORIZ",aTefDados[1][5]})
								aAdd( aSL4[nX], { "L4_INSTITU",aTefDados[1][8]})
								aAdd( aSL4[nX], { "L4_DOCCANC",aTefDados[1][6]})
								aAdd( aSL4[nX], { "L4_DATCANC",aTefDados[1][12]})
								aAdd( aSL4[nX], { "L4_HORCANC",aTefDados[1][7]})
								aAdd( aSL4[nX], { "L4_NSUTEF" ,aTefDados[1][9]})
								aAdd( aSL4[nX], { "L4_TIPCART",aTefDados[1][10]})
								If !Empty(aTefDados[1][15])
									aAdd( aSL4[nX], { "L4_FORMPG",aTefDados[1][15]})
								EndIf
	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Antes de gravar o SL4 vou verificar se a ADM selecionada ³
								//³pelo operador e a mesma da resposta da transacao         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cAdminis := LJ7ConfAdm(aPgtos[nX][4][05],aTefDados[1][8])
								If !Empty(cAdminis)
									aAdd( aSL4[nX], { "L4_ADMINIS",	cAdminis } )
								EndIf
						
							EndIf	
						EndIf
					EndIf
				EndIf	
				
				If cPaisLoc != "BRA"
				   aAdd( aSL4[nX], { "L4_MOEDA", 	aPgtos[nX][_MOEDA] } )   
				EndIf
				
			Next nX

			nCont := 1
			dbSelectArea("SL4")
			dbSetOrder(1)
			dbSeek(xFilial("SL4")+SL1->L1_NUM)
			While !Eof() .And. SL4->L4_FILIAL+SL4->L4_NUM == xFilial("SL4")+SL1->L1_NUM
				If nCont <= Len(aSL4)
			    	Lj7GeraSL( "SL4", aSL4[nCont] )
			 	Else            
 					Begin Transaction 	 	

			 		RecLock("SL4",.F.)
			 		dbDelete()
			 		MsUnlock()

			 		End Transaction 
			 	Endif
		    	SL4->(dbSkip())
				nCont ++
			Enddo
			For nX := nCont to Len(aSL4)
				Lj7GeraSL( "SL4", aSL4[nCont], .T. )
			Next nX
		Endif	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chama a finalizacao da funcao fiscal antes da chamada da     ³
		//³ LJGrvTudo()                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MaFisFound()
			MaFisEnd(.T.)
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chama a funcao de gravacao do 'PACOTE'                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet := LjGrvTudo( .T., lFinanceiro, nNCCUsada, aNCCItens, nNCCGerada ) // .T. = Mostrar as mensagens com MsgStop ou Help / .F. Mostrar com ConOut
        
		// Grava informações referentes ao Consumidor Final - Argentina.
		If cPaisLoc == "ARG" .And. aDadosCF[7]
			aAdd( aMAD, { "MAD_FILIAL",xFilial("MAD") })
			aAdd( aMAD, { "MAD_CODEND",aDadosCF[5] })	
			aAdd( aMAD, { "MAD_END"   ,aDadosCF[6] })	
			Lj7GeraSL( "MAD", aMAD, .T., .T.)
			
			aAdd( aSLS, { "LS_FILIAL" ,xFilial("SLS") } )
			aAdd( aSLS, { "LS_SERIE"  ,SL1->L1_SERIE } )
			aAdd( aSLS, { "LS_DOC"    ,SL1->L1_DOC } )
			aAdd( aSLS, { "LS_TIPO"   ,"N" } )
			aAdd( aSLS, { "LS_DOCCF"  ,aDadosCF[1] } )
			aAdd( aSLS, { "LS_TPDOCCF",aDadosCF[2] } )
			aAdd( aSLS, { "LS_TIPOCI" ,aDadosCF[3] } )
			aAdd( aSLS, { "LS_CLIECF" ,aDadosCF[4] } ) 
			aAdd( aSLS, { "LS_CODEND" ,aDadosCF[5] } )
			Lj7GeraSL( "SLS", aSLS, .T., .T.)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Deleta as reservas qdo necessario                            ³
		//³ O SC0 esta sendo deletado aqui pq a B2AtuComD2 faz a atualiza³
		//³ cao do SB2->B2_RESERVA mas nao mata o SC0                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aReservas)
			dbSelectArea("SC0")
			dbSetOrder(1) // filial + numero + produto + local
			For nX := 1 to Len(aReservas)
				If dbSeek(xFilial("SC0")+aReservas[nX][1]+aReservas[nX][2]+aReservas[nX][3])
					Begin Transaction 
			
				    RecLock("SC0",.F.)
					dbDelete()
					MsUnlock()        
				
					End Transaction 
				Endif
			Next nx
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava a milhas do cupom para o cliente                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lUsaTef .And. GetMV("MV_TEFMILH") .And. cTipTEF $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO
			LOJA010T("P","AO",aRet)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Baixa o Lay-Away - POR|EUA                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc$"EUA|POR" .And. lLayAway
           nPosLay       := Ascan(aPosCpoDet,{|x| AllTrim(x[1]) == "LR_NUMLAY"}) 	// Posicao do numero do Lay-Away
           nPosItLay     := Ascan(aPosCpoDet,{|x| x[1] == "LR_ITEMLAY"})	        // Posicao do item do Lay-Away		
		   SL2->(dbSetOrder(1))		
		   SL2->(DbGoto(nRecnoSL2))	          			  		
		   For nX := 1 to Len(aCols)
	          If (aCols[nX][Len(aCols[nX])])
		         Loop
	          EndIf		      
			  If nPosLay > 0 .And. nPosItLay > 0 .And. !Empty(aColsDet[nX][nPosLay])
				 a800BxLay(aColsDet[nX][nPosLay],aColsDet[nX][nPosItLay],nX)  
				 lCompensa  := .T.
				 If Ascan(aNumLay,PadR(aColsDet[nX][nPosLay],TamSX3("E1_NUM")[1])) == 0
				    Aadd(aNumLay,PadR(aColsDet[nX][nPosLay],TamSX3("E1_NUM")[1])) 
				 EndIf   				 
				 nTotalItem  += aCols[nX][nPosVlItem] 
			  EndIf
	          SL2->(DbSkip())			  
		   Next nX
		   nTotalItem += Lj7T_ImpsV("1",2)
		   For nX := 1 to Len(aNumLay)
		      cNumLay    := AllTrim(aNumLay[nX])
		      nTotalLay  += a800Total(.T.)
		   Next nX
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Compara o valor da venda e do Lay-Away para verificar se tra-³
		   //³ ta de finalizacao total do Lay-Away                          ³		   
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		   		   		   
		   lLayTotal   := nTotalItem == nTotalLay .Or. !GetMV("MV_LWPARC")
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Chama a tela de compensacao quando entrega parcial ou o para-³
		   //³ metro MV_LWCPAUT = .F.(permite ou nao compensacao automatica ³		   
		   //³ na finalizacao do Lay-Away)                                  ³		   		   
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		   		   
		   If lCompensa 
		      If !GetMV("MV_LWCPAUT",,.T.) .Or. !lLayTotal
		         a800Titulo(5,nOutros,aNumLay)		   
		      Else		         
		         If !a800CompAut(aNumLay)
		            Aviso(STR0031,STR0032+chr(13)+; //"Atencao!"###"Nao foi possivel fazer a compensacao dos titulos RA "
		                  STR0033+chr(13)+;         //"gerados pelo Lay-Away. Fazer a compensacao manualmente atraves "
		                  STR0034,{STR0005})        //"da rotina Compensacao Contas a Receber."###"Ok"
		         EndIf
		      EndIf   
		   EndIf
		EndIf				    				
		     
  		// Chama rotina para impressão da Nota Fiscal
		If lRet .And. cPaisLoc <> "BRA" .And. !lFiscal .And. MsgYesNo(STR0041) //"Deseja realizar a impressao da fatura de venda?"
			LjMsgRun( STR0042,, {|| LojR110(SL1->L1_DOC,SL1->L1_SERIE) } )			 //"Aguarde ... imprimindo fatura ..."
		EndIf
	Else

		//*** Aqui podemos fazer um tratamento para cada erro encontrado.
		If Len(aRet)>2.and.!empty(aRet[3]).and.!lErroCF
			MsgStop(aRet[3])
		EndIf
		If lErroCF
			MsgStop("Houve problemas na impressão do Cupom Fiscal.")
		EndIf
		
	Endif
EndIf

If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Finalização da Gravação Venda - ' + iIf( lRet, 'S', 'N' ))
EndIf

Lj7RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7Pedido ºAutor  ³Andre Veiga         º Data ³  24/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz as gravacoes no SL1 e SL2 que transforma o orcamento    º±±
±±º          ³em pedido                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ExpL1 := Lj7Pedido()                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 - Indica se conseguiu ou nao fazer a gravacao         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7Pedido(aDadosCF)
Local lRet 			:= .T.

Local aRetCNF		:= {.T.} 
Local aArquivos 	:= {}
Local aArqAux		:= {}
Local aArqAux2		:= {}
Local aLojas		:= {}
Local aSL1			:= {}
Local aSL2			:= {}
Local aSL4			:= {}
Local aOrcLocal		:= {}
Local nI
Local nX 			:= 0
Local nY			:= 0
Local nPos 			:= 0
Local nNumPai    	:= 0						// Numero do registro no SL1 do "pedido"

Local cLojaRes 		:= ""
Local cEntregaRes   := "" 

Local lCartao 		:= .F.
Local lTefOk		:= .F.
Local nVlrEntrada	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre a tela para para pedir os dados dos cheque / financiadora           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Lj7InfPgtos()

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Transf. Orçamento em Pedido - N')
	EndIf

	Return .F.
Endif                        	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta o array com as informacoes dos orcamentos das outras lojas         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aLojas := {}
SLJ->(dbSetOrder(1))
dbSelectArea("SL2")
dbSetOrder(1)
dbSeek(xFilial("SL2")+SL1->L1_NUM)
While !Eof() .And. SL2->L2_FILIAL+SL2->L2_NUM == xFilial("SL2")+SL1->L1_NUM
	cLojaRes    := IIf(Empty(SL2->L2_LOJARES),cLojaLocal,SL2->L2_LOJARES)
	cEntregaRes := SL2->L2_ENTREGA

	SLJ->(dbSeek(xFilial("SLJ")+cLojaRes))
	nPos := aScan( aLojas, { |x| x[3]+x[6] == cLojaRes + cEntregaRes} )
	
	If nPos == 0
		aAdd( aLojas, {SL1->L1_FILIAL,;			// Filial do orcamento original (pedido)
						SL1->L1_NUM,; 			// Numero do orcamento original (pedido)
						cLojaRes,;				// Codigo da loja da reserva (SLJ)
					 	SLJ->LJ_RPCFIL,;		// Codigo da filial da reserva 
						{ SL2->L2_ITEM },;		// Array com os itens do SL2 de cada loja (filial)
						cEntregaRes	} )			// Quebra para entrega.
	Else 
		aAdd( aLojas[nPos][5], SL2->L2_ITEM )
	Endif
	SL2->(dbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera os arrays antes do recalculo dos valores                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aLojas)
	// Posiciona o orcamento no original
	SL1->(dbSeek(aLojas[nX][1]+aLojas[nX][2]))
	
	// Gera os arrays (aSL1, aSL2 e aSL4) com os dados de cada orcamento
	aArquivos := Lj7GeraOrc( aLojas[nX][5] )
	
	aAdd( aArqAux, { aClone(aLojas[nX]), aArquivos } )

Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa o recalculo das tributacoes da venda (aqui serao utilizados os    ³
//³arrays aSL1 e aSL2                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "BRA"
	Lj7RecTrib()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera os arrays depois do recalculo dos valores (aqui sera utilizado o     ³
//³array aSL4 e os aSL1 e aSL2 para gravacao do orcamento na loja onde       ³
//³originou o orcamento                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aLojas)
	// Posiciona o orcamento no original
	SL1->(dbSeek(aLojas[nX][1]+aLojas[nX][2]))
	
	// Gera os arrays (aSL1, aSL2 e aSL4) com os dados de cada orcamento
	aArquivos := Lj7GeraOrc( aLojas[nX][5] )
	
	aAdd( aArqAux2, { aClone(aLojas[nX]), aArquivos } )

Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o tratamento da variavel lCartao                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nX := 1
While nX <= Len(aPgtos) .And. !lCartao
	//Com a utilização da DLL ainda não existe a possibilidade do controle de milhas com o cartão CCS da EMS
	If cTipTef $ TEF_CLISITEF
	   If AllTrim(aPgtos[nI][3]) $ _FORMATEF .Or. ;
	   	 (AllTrim(aPgtos[nI][3]) == AllTrim(MVCHEQUE) .And. At("S",LjGetStation("TEFCONS"))<>0)
		  lCartao:= .T.
	   EndIf
	Else	   
		If AllTrim(aPgtos[nX][3]) $ _FORMATEF .Or. ;
		  (AllTrim(aPgtos[nX][3]) == AllTrim(MVCHEQUE) .And. (At("S",LjGetStation("TEFCONS"))<>0 .Or. GetMV("MV_INTEEMS")))
			lCartao := .T. 
		Endif
	EndIf		
	nX ++
Enddo

If lUsaTef .And. lCartao .And. cTipTEF $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO+";"+TEF_CLISITEF

	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Inicio Transação TEF - S / S / ' + cTipTEF)
	EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Tratamento Parce                                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lRecebe
	    cOrcamen := SL1->L1_NUM
	EndIf
	aReb     := {}
	aParcTef := {}

	If cTipTef == TEF_CLISITEF
		//Pegando os dados totalizados de cartões a serem enviados para a transacao TEF
		For nI := 1 To Len(aPgtosSint)
			If AllTrim(aPgtosSint[nI][1]) $ _FORMATEF

				//Verica o valor da primeira parcela a ser enviada para a transação TEF
				nPos := Ascan(aPgtos,{|x| AllTrim(x[3])+AllTrim(x[8]) == AllTrim(aPgtosSint[nI][1])+AllTrim(aPgtosSint[nI][4]) } )
				nVlrEntrada := If(nPos>0,aPgtos[nPos][2],0)

		        Aadd(aReb,{ aPgtosSint[nI][5],;												//Data
			        	    Val(StrTran(StrTran(aPgtosSint[nI][3],",",""),".",""))/100,;	//Valor
			        	    aPgtosSint[nI][1],;												//Forma
			        	    aPgtosSint[nI][4],;												//ID para identificação da forma de pagamento na operação TEF
			        	    aPgtosSint[nI][2],;												//Qtde de Parcelas
							nVlrEntrada,;													//Valor Entrada
			        	    {Space(03),Space(3),Space(04),Space(10),Space(07),Space(15),Space(15)}}) //Dados do Cheque
			EndIf
		Next nI
		//Se a estação utilizar consulta de cheques pegar os dados analíticos de todos os cheques a serem consultados
		If At("S",LjGetStation("TEFCONS")) <> 0
			For nI := 1 To Len(aPgtos)
				If AllTrim(aParcelas[j][3]) == AllTrim(MVCHEQUE)
					Aadd(aReb,{ aPgtos[nI][1],;												//Data
								aPgtos[nI][2],;												//Valor
								aPgtos[nI][3],;												//Forma
								aPgtos[nI][8],;												//ID para identificação da forma de pagamento na operação TEF
								1,;															//Quantidade de Parcelas
								0,;															//Valor de Entrada
								{aPgtos[nI][4][8],aPgtos[nI][4][4],aPgtos[nI][4][5],aPgtos[nI][4][6],aPgtos[nI][4][7],aPgtos[nI][4][9],aPgtos[nI][4][10]}}) //Dados do Cheque
				EndIf
			Next nI
	    EndIf

	Else

	    For nI := 1 to Len(aPgtos)
	    		If Alltrim(aPgtos[nI][3]) == Alltrim(MVCHEQUE)
			        Aadd(aReb    , {aPgtos[nI][1],aPgtos[nI][2],aPgtos[nI][3],aPgtos[nI][4][7],;
			        				aPgtos[nI][4][4], aPgtos[nI][4][5], aPgtos[nI][4][6],nI})
			    Else
			        Aadd(aReb    , {aPgtos[nI][1],aPgtos[nI][2],aPgtos[nI][3],aPgtos[nI][4][5],nI,aPgtos[nI][4][7]})
			    Endif
		        Aadd(aParcTef, {aPgtos[nI][1],aPgtos[nI][2],aPgtos[nI][3],1,aPgtos[nI][4][5]})

    	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    	//³Monta ¡tens do ComboBox  ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    		aCartoes := Lj010LerCartao(aPgtos[nI,3])
	    	If Alltrim(aPgtos[nI][3]) $ _FORMATEF
			   cCartao := Iif(Empty(aPgtos[nI][4][5]),aCartoes[1],aPgtos[nI][4][5])
		    Else
	    	   cCartao	:= ""
	        EndIf
        
    	Next nI

	EndIf

	If cTipTef == TEF_CLISITEF
		oTEF:Operacoes("V",aReb)
		lTefOk := oTef:lTefOk
	Else
		lTefOk := LOJA010T( "V" , ,aReb)
	EndIf
	
	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Venda TEF - ' + iIf( ValType(lTefOK) == "L", iIf( lTefOK, 'S', 'N' ), lTefOk ))
	EndIf
	
	If !Valtype(lTefOk ) == "L"
		lTefOk := .F.
	ElseIf !lTefOk
		If cTipTef <> TEF_CLISITEF
			//HOMOLOGACAO: Enviar o desfazimento da operação TEF para impedir transações pendentes no Sitef
			If TEF_lEnvDF()
			
				If !Empty(LOG_TEF)
					LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Envio Desfazimento TEF')
				EndIf
			
				If LOJA010T("F","D")
	
					If !Empty(LOG_TEF)
						LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Transação TEF não efetuada!')
					EndIf
	
					MsgAlert(STR0047) 	//"Transação TEF não efetuada!"
	
				EndIf
	
			//Na versào 3.00 do TEF qdo quando ocorre erro nao e necessario cancelar enviei o desfazimento, respeito as versoes anteriores do Sitef
			ElseIf !(GetMV("MV_TEFVERS") == "03.00")
			
				If !Empty(LOG_TEF)
					LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Envio Cancelamento TEF - ' + GetMV("MV_TEFVERS"))
				EndIf
	
				If LOJA010T("F","N")	//Antigamente esta função nao retornava verdadeiro ou falso
	
					If !Empty(LOG_TEF)
						LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Transação TEF não efetuada!')
					EndIf
	
					MsgAlert(STR0047) 	//"Transação TEF não efetuada!"
	
				EndIf				
	
			EndIf
		EndIf

	Endif

	If !lTefOk
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se o usuario optar por nao continuar manualmente, apaga as informacoes³
		//³ de pagamento para serem informadas novamente                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !LojaOk(STR0011) //"Continua Manualmente?"

			If !Empty(LOG_TEF)
				LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Continua Manualmente - N')
			EndIf
		
			aEval( aPgtos, { |x| x[4]:={} } )
			Return .F.
		Endif
		
		If !Empty(LOG_TEF)
			LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Continua Manualmente - S')
		EndIf
		
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a impressao do cupom nao fiscal (comprovante da venda)               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aRetCNF[1]
	LjMsgRun( STR0013,, {|| (aRetCNF := Lj7ImpCNF( lTefOk )) } ) //"Aguarde ... imprimindo o comprovante de venda ...."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a impressao do cupom tef                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaTef .And. lCartao .And. cTipTEF $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO+";"+TEF_CLISITEF
	If aRetCNF[1] .And. lTefOk
		If cTipTEF == TEF_CLISITEF
			oTEF:ImpCupTef()
		Else
			If LOJA010T( "I", "V" )
				LJ701AtCartao()
			EndIf
		EndIf
	ElseIf !lTefOk
		If cTipTEF == TEF_CLISITEF
   		   oTEF:FinalTrn(0) //Finaliza a TRN com parametro confirma = 1
  		   MsgInfo(STR0048) //"Transação TEF não efetuada, favor reter o cupom!"
		Else
			lTefOk := LOJA010T( "F", "N" )
			If lTefOk
				MsgInfo(STR0048) //"Transação TEF não efetuada, favor reter o cupom!"
			EndIF
		EndIf
	EndIf
EndIf

If !aRetCNF[1]
	Aviso( STR0007, STR0014, {STR0005} ) //"Atenção"###"Houve erros na impressão do comprovante de venda. Verifique a impressora."###"Ok"
	
	If !Empty(LOG_TEF)
		LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Erro na Impressão do Comprovante de Venda.')
	EndIf
	
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a gravacao do SL1                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSL1, {"L1_EMISNF",  dDataBase} )					// Data de Emissao do pedido
aAdd( aSL1, {"L1_TIPO",    "P"} )						// Indica que tem reserva
aAdd( aSL1, {"L1_RESERVA", "S"} )						// Indica que tem reserva
aAdd( aSL1, {"L1_OPERADO", xNumCaixa()} )				// Operador
aAdd( aSL1, {"L1_PDV",     aRetCNF[2][2]} )				// Numero do PDV
aAdd( aSL1, {"L1_DOCPED",  aRetCNF[2][1]} )				// Numero do cupom nao fiscal (pedido)
aAdd( aSL1, {"L1_SERPED",  If(Len(aRetCNF[2])==3,aRetCNF[2][3],LjGetStation("LG_SERIE")) } )	// Numero do serie do cupom nao fiscal (pedido)

If lUsaTef .And. lTefOk 
	If cTipTef == TEF_CLISITEF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua a alteracao das datas e conf. de ADM informadas durante o processamento do TEF		           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		LjTEFAceParc()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gerando os dados do TEF para a tabela SL1													   		   |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSL1 := LjTEFGeraSL(aSL1,"SL1")

	ElseIf cTipTef $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO
		aAdd( aSL1, { "L1_VENDTEF","S"})
		aAdd( aSL1, { "L1_DATATEF",aTefDados[1][2]})
		aAdd( aSL1, { "L1_HORATEF",aTefDados[1][3]})
		aAdd( aSL1, { "L1_DOCTEF" ,aTefDados[1][4]})
		aAdd( aSL1, { "L1_AUTORIZ",aTefDados[1][5]})
		aAdd( aSL1, { "L1_INSTITU",aTefDados[1][8]})
		aAdd( aSL1, { "L1_DOCCANC",aTefDados[1][6]})
		aAdd( aSL1, { "L1_DATCANC",aTefDados[1][12]})
		aAdd( aSL1, { "L1_HORCANC",aTefDados[1][7]})
		aAdd( aSL1, { "L1_NSUTEF" ,aTefDados[1][9]})
		aAdd( aSL1, { "L1_TIPCART",aTefDados[1][10]})
		If !Empty(aTefDados[1][15])
			aAdd( aSL1, { "L1_FORMPG",aTefDados[1][15]})
		EndIf
	EndIf
EndIf                                 

If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Gera SL1')
EndIf

Lj7GeraSL( "SL1", aSL1, .F., .F. )

nNumPai := SL1->L1_NUM
     
If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Gera SL4')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a gravacao do SL4                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len( aPgtos )
	aAdd( aSL4, {} )
	aAdd( aSL4[nX], { "L4_FILIAL",	xFilial("SL4") } )
	aAdd( aSL4[nX], { "L4_NUM", 	SL1->L1_NUM	} )
	aAdd( aSL4[nX], { "L4_DATA", 	aPgtos[nX][1] } )
	aAdd( aSL4[nX], { "L4_VALOR", 	aPgtos[nX][2] } )
	aAdd( aSL4[nX], { "L4_FORMA",	aPgtos[nX][3] } )

	If !IsMoney(aPgtos[nX][3]) .And. !lLayAway
		If Trim(aPgtos[nX][3]) == "CH"
			aAdd( aSL4[nX], { "L4_ADMINIS",	aPgtos[nX][4][04] } )
			aAdd( aSL4[nX], { "L4_NUMCART",	aPgtos[nX][4][07] } )
			aAdd( aSL4[nX], { "L4_AGENCIA",	aPgtos[nX][4][05] } )
			aAdd( aSL4[nX], { "L4_CONTA",	aPgtos[nX][4][06] } )
			aAdd( aSL4[nX], { "L4_RG",		aPgtos[nX][4][09] } )
			aAdd( aSL4[nX], { "L4_TELEFON",	aPgtos[nX][4][10] } )
			aAdd( aSL4[nX], { "L4_COMP",	aPgtos[nX][4][08] } )
			aAdd( aSL4[nX], { "L4_TERCEIR",	aPgtos[nX][4][12] } )
		Else
			aAdd( aSL4[nX], { "L4_ADMINIS",	aPgtos[nX][4][05] } )
			aAdd( aSL4[nX], { "L4_NUMCART",	aPgtos[nX][4][04] } )
		Endif
	Endif
	
	//****************************************************************************
	//***     ALTERACAO PARA GRAVACAO DOS DADOS DO TEF NO SL4
	//****************************************************************************
	aAdd( aSL4[nX], { "L4_VENDTEF","N" })
	
	If lUsaTef .And. lTefOk 
		If cTipTef == TEF_CLISITEF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gerando os dados do TEF para a tabela SL4													   		   |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSL4 := LjTEFGeraSL(aSL4,"SL4",aPgtos[nX][1],aPgtos[nX][3],aPgtos[nX][8],aPgtos[nX][4][07],nX)

		ElseIf cTipTef $ TEF_SEMCLIENT_DEDICADO+";"+TEF_COMCLIENT_DEDICADO+";"+TEF_DISCADO
			If (nPos := Ascan(aTefMult,{|x| Ascan(x[10],StrZero(nX,2))>0 }))<>0
				If Len(aTefMult[nPos][7])>0
					aTefDados:=aClone(aTefMult[nPos][7])
					aAdd( aSL4[nX], { "L4_VENDTEF","S"})
					aAdd( aSL4[nX], { "L4_DATATEF",aTefDados[1][2]})
					aAdd( aSL4[nX], { "L4_HORATEF",aTefDados[1][3]})
					aAdd( aSL4[nX], { "L4_DOCTEF" ,aTefDados[1][4]})
					aAdd( aSL4[nX], { "L4_AUTORIZ",aTefDados[1][5]})
					aAdd( aSL4[nX], { "L4_INSTITU",aTefDados[1][8]})
					aAdd( aSL4[nX], { "L4_DOCCANC",aTefDados[1][6]})
					aAdd( aSL4[nX], { "L4_DATCANC",aTefDados[1][12]})
					aAdd( aSL4[nX], { "L4_HORCANC",aTefDados[1][7]})
					aAdd( aSL4[nX], { "L4_NSUTEF" ,aTefDados[1][9]})
					aAdd( aSL4[nX], { "L4_TIPCART",aTefDados[1][10]})
					If !Empty(aTefDados[1][15])
						aAdd( aSL4[nX], { "L4_FORMPG",aTefDados[1][15]})
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	If cPaisLoc != "BRA"
	   aAdd( aSL4[nX], { "L4_MOEDA", 	aPgtos[nX][_MOEDA] } )   
	EndIf
	
	//****************************************************************************
	//***     FIM DA ALTERACAO PARA GRAVACAO DOS DADOS DO TEF NO SL4
	//****************************************************************************
Next nX

nCont := 1
dbSelectArea("SL4")
dbSetOrder(1)
dbSeek(xFilial("SL4")+SL1->L1_NUM)
While !Eof() .And. SL4->L4_FILIAL+SL4->L4_NUM == xFilial("SL4")+SL1->L1_NUM
	If nCont <= Len(aSL4)
    	Lj7GeraSL( "SL4", aSL4[nCont] )
 	Else       
		Begin Transaction 
		
 		RecLock("SL4",.F.)
 		dbDelete()
 		MsUnlock()
 		
		End Transaction 
 	Endif
   	SL4->(dbSkip())
	nCont ++
Enddo
For nX := nCont to Len(aSL4)
	Lj7GeraSL( "SL4", aSL4[nCont], .T. )
Next nX
                                                      
If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Gera SE1 / SE5')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gerar movimento financeiro (SE1 e SE5) referente ao PEDIDO               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LjGrvFin(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a gravacao dos orcamentos nas filiais correspondentes                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aArqAux)
	aLojas := aClone(aArqAux[nX][1])
	         
	// Pega os arrays depois do recalculo
		aArquivos := aClone(aArqAux[nX][2])
		aArquivos[3] := aClone(aArqAux2[nX][2][3])

	// Posiciona o orcamento no original
	SL1->(dbSeek(aLojas[1]+aLojas[2]))
	
	// Altera o campo L4_OBS antes de enviar o array.
    nPos := aScan( aArquivos[3][1], {|x| Alltrim(Upper(x[1]))=="L4_OBS" } )
    If nPos == 0
    	aAdd( aArquivos[3][1], { "L4_OBS", STR0018 + aRetCNF[2][1] + STR0019 + aRetCNF[2][2] } ) //"COO:"###" PDV:"
    Else
        aArquivos[3][1][nPos][2] := STR0018 + aRetCNF[2][1] + STR0019 + aRetCNF[2][2] //"COO:"###" PDV:"
    Endif
	
	// Chama a funcao para gravar os arrays gerando SL1, SL2 e SL4
	aRet := LJ7GrvOrc( aArquivos[1], aArquivos[2], aArquivos[3], .T., .T., aLojas[4] )
	
	// Trata o retorno da Lj7GrvOrc
	If aRet[1]
		dbSelectArea("SL2")
		dbSetOrder(1)	// filial + num + item + produto
		For nY := 1 to Len(aLojas[5])		
			If dbSeek(xFilial("SL2")+nNumPai+aLojas[5][nY])
				aAdd( aSL2, { "L2_ORCRES", aRet[2] } )	
				aAdd( aSL2, { "L2_FILRES", aLojas[4] } )
				Lj7GeraSL( "SL2", aSL2 )
			Endif
		Next nY
		// Ponto de controle para gerar arquivo de Log, para monitorar a impressao de cupons fiscais indevidos
		// LJ7Logcf("A",,,,,aLojas)
		If (aLojas[3] == cLojaLocal .And. IIf(SL2->(FieldPos("L2_ENTREGA"))>0,(aLojas[6] == "2"),.T.)) .or. ;
			(aLojas[3] == cLojaLocal .And. IIf(SL2->(FieldPos("L2_ENTREGA"))>0,(aLojas[6] == "1"),.T.) .And. (GetMV("MV_LJFINEN")))
				If aLojas[1] == aLojas[4]
 					aAdd( aOrcLocal, aRet[2] )
 				Endif
		Endif	
	Endif

Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama a funcao para fechamento do orcamento (filial atual)               ³
//³ (Imprime o CFiscal, gera os arquivos de notas e atualiza os estoques)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aOrcLocal)>0
	For nX := 1 to Len(aOrcLocal)
	dbSelectarea("SL1")
	dbSetOrder(1)
		If dbSeek(xFilial("SL1")+aOrcLocal[nX]).And.Empty(SL1->L1_DOC).And.Empty(SL1->L1_DOCPED)
		If MaFisFound("NF")
			MaFisEnd()	
			MaFisIni( SL1->L1_CLIENTE, SL1->L1_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701" )
			
			dbSelectArea( "SL2" )
			dbSetOrder(1)              
				dbSeek(xFilial("SL1")+aOrcLocal[nX])
			
				Do While !Eof() .And. xFilial("SL1")+aOrcLocal[nX] == SL2->L2_FILIAL+SL2->L2_NUM
					
				If MaFisFound("NF")
					MaFisAdd( SL2->L2_PRODUTO,;	// Produto
							  SL2->L2_TES   ,;	// Tes
							  SL2->L2_QUANT ,;	// Quantidade
							  SL2->L2_PRCTAB,;	// Preco unitario
							  SL2->L2_VALDESC,;	// Valor do desconto
							  "",; 						// Numero da NF original
							  "",; 						// Serie da NF original
							   0,;						// Recno da NF original
							   0,; 						// Valor do frete do item
							   0,; 						// Valor da despesa do item
							   0,; 						// Valor do seguro do item
							   0,; 						// Valor do frete autonomo
							   SL2->L2_VALDESC,;        // Valor da mercadoria
							   0 )						// Valor da embalagem			
				Endif
				dbSelectArea( "SL2" )
				dbSkip()
			EndDo
		Endif
		dbSelectArea( "SL1" )
		
		lRet := LJ7GrvVenda( .F., .T., aDadosCF )
	Endif
	Next nX
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a funcao fiscal antes da funcao de gravacao da venda para o recal- ³
	//³ culo dos impostos para o orcamento que foi gerado em outras lojas        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If MaFisFound("NF")
		MaFisEnd()	
		MaFisIni( M->LQ_CLIENTE, M->LQ_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701" )
		
		For nX := 1 to Len(aArquivos[2])
				
			If MaFisFound("NF")
				MaFisAdd( aArquivos[2][nX][aScan( aArquivos[2][nX], { |x| Alltrim(Upper(x[1])) = "L2_PRODUTO" } )][2],;			// Produto
							aArquivos[2][nX][aScan( aArquivos[2][nX], { |x| Alltrim(Upper(x[1])) = "L2_TES" } )][2],;			// Tes
							aArquivos[2][nX][aScan( aArquivos[2][nX], { |x| Alltrim(Upper(x[1])) = "L2_QUANT" } )][2],;			// Quantidade
							aArquivos[2][nX][aScan( aArquivos[2][nX], { |x| Alltrim(Upper(x[1])) = "L2_PRCTAB" } )][2],;		// Preco unitario
							aArquivos[2][nX][aScan( aArquivos[2][nX], { |x| Alltrim(Upper(x[1])) = "L2_VALDESC" } )][2],;		// Valor do desconto
							"",; 						// Numero da NF original
							"",; 						// Serie da NF original
							0,;							// Recno da NF original
							0,; 						// Valor do frete do item
							0,; 						// Valor da despesa do item
							0,; 						// Valor do seguro do item
							0,; 						// Valor do frete autonomo
							aArquivos[2][nX][aScan( aArquivos[2][nX], { |x| Alltrim(Upper(x[1])) = "L2_VLRITEM" } )][2] + aArquivos[2][nX][aScan( aArquivos[2][nX], { |x| Alltrim(Upper(x[1])) = "L2_VALDESC" } )][2],; // Valor da mercadoria
							0 )							// Valor da embalagem			
			Endif
	
		Next nX
	Endif      
EndIf

If !Empty(LOG_TEF)
	LjWriteLog(LOG_TEF + M->LQ_NUM + '.TXT', 'Finalização da Geração do Pedido - ' + iIf( lRet, 'S', 'N' ))
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7GeraSL ºAutor  ³Andre Veiga         º Data ³  28/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a gravacao dos arquivos                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Loja701                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7GeraSL( cAlias, aArray, lAppend, lUnlock )
Local cOldAlias:=Alias()
Local lRet:=.T.

Default lAppend := .F.
Default lUnlock := .T.

dbSelectArea(cAlias)

Begin Transaction

lRet := RecLock(cAlias, lAppend)
If lRet
	AEval(aArray, {|x| If( FieldPos(x[1])>0, FieldPut(FieldPos(x[1]), x[2]),Nil) })
	dbCommit()
	If lUnlock
		MsUnLock()
	Endif
EndIf 
     
End Transaction

dbSelectArea(cOldAlias)
Return(lRet)
            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7GeraOrcºAutor  ³Andre Veiga         º Data ³  24/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta os arrays para a gravacao do orcamento                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ExpA1 := LJ7GeraOrc( ExpA2 )                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpA1 - Array contendo:                                     º±±
±±º          ³        [1] - .T./.F. Se consegiu ou nao fazer a gravacao   º±±
±±º          ³        [2] - Numero do orcamento gerado                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA2 - Array unidimensional contendo os numeros dos itens  º±±
±±º          ³        (L2_ITEM) que deverao gerar os orcamentos           º±±
±±º          ³        Exemplo: {01,02,04}                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³O SL1 deve estar posicionado no orcamento pai (pedido)      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³LJ7Pedido  (Loja701)                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7GeraOrc( aItens )
Local aArea			:= Lj7GetArea({"SL1","SL2","SL4"})
Local aRet 			:= {}
Local aSL1			:= {}
Local aSL2			:= {}
Local aSL4			:= {}
Local aSL4Aux		:= {}
Local nX 			:= 0
Local nY			:= 0
Local nVlrFSD		:= 0
Local nVlrTotSl4	:= 0
Local nVlrOrcam 	:= 0 
Local nValMerc		:= 0
Local nValorTotal	:= 0
Local nVlrBrIcms	:= 0
Local nVlrIcmsRet	:= 0
Local nVlrTBrIcms	:= 0
Local nVlrTIcmsRet	:= 0
Local nVlrIcms		:= 0
Local nVlrIpi		:= 0
Local nVlrIss		:= 0
Local nVlrDescPro	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o array aSL1                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SL1")
For nX := 1 to FCount()
	aAdd( aSL1, { Trim(FieldName(nX)), FieldGet(nX) } )
Next nX

aSL1[aScan(aSL1,{|x|x[1]=="L1_FILRES" })][2]	:= cFilAnt
aSL1[aScan(aSL1,{|x|x[1]=="L1_ORCRES" })][2]	:= SL1->L1_NUM
aSL1[aScan(aSL1,{|x|x[1]=="L1_NUM"    })][2]	:= Space(TamSx3("L1_NUM")[1])
aSL1[aScan(aSL1,{|x|x[1]=="L1_DINHEIR"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_CHEQUES"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_CARTAO" })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_VLRDEBI"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_CONVENI"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_VALES"  })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_FINANC" })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_OUTROS" })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_ENTRADA"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_DOCPED" })][2]	:= Space(TamSx3("L1_NUM")[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o SL2 para gerar o array aSL2                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SL2")
dbSetOrder(1)
For nX := 1 to Len( aItens )
	If dbSeek(xFilial("SL2")+SL1->L1_NUM+aItens[nX])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SF4                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+SL2->L2_TES))
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz o tratamento dos campos do SL2                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( aSL2, {} )
		For nY := 1 to FCount()
			aAdd( aSL2[Len(aSL2)], { FieldName(nY), FieldGet(nY) } )
		Next nY
		nVlrBrIcms 	+= SL2->L2_BRICMS
		// Verifica se agrega solidario. (Se o valor do imposto incide ou nao no total da venda)
		If SF4->F4_INCSOL <> "N"
			nVlrTBrIcms 	+= SL2->L2_BRICMS
		EndIf
		nVlrIcmsRet	+= SL2->L2_ICMSRET
		// Verifica se agrega solidario. (Se o valor do imposto incide ou nao no total da venda)
		If SF4->F4_INCSOL <> "N"
			nVlrTIcmsRet	+= SL2->L2_ICMSRET
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acumula as variaveis para a gravacao do SL1                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nVlrIss		+= SL2->L2_VALISS
		nVlrIpi		+= SL2->L2_VALIPI
		nVlrIcms	+= SL2->L2_VALICM
		// Checa o SF4->F4_INCSOL - Agrega solidario (se inclui o valor do imp.solidario no total da venda)
		nVlrOrcam 	+= SL2->L2_VLRITEM + If(SF4->F4_INCSOL<>"N",SL2->L2_ICMSRET,0)
		nValMerc	+= SL2->L2_PRCTAB * SL2->L2_QUANT
		nValorTotal	+= SL2->L2_VLRITEM
		nVlrDescPro	+= SL2->L2_DESCPRO
    Endif
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterando os valores especificos para a loja destino                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nVlrFSD		:= SL1->L1_FRETE + SL1->L1_SEGURO + SL1->L1_DESPESA  // ??????

aSL1[aScan(aSL1,{|x|x[1]=="L1_FILRES" })][2]	:= cFilAnt
aSL1[aScan(aSL1,{|x|x[1]=="L1_ORCRES" })][2]	:= SL1->L1_NUM
aSL1[aScan(aSL1,{|x|x[1]=="L1_NUM"    })][2]	:= Space(TamSx3("L1_NUM")[1])
aSL1[aScan(aSL1,{|x|x[1]=="L1_DINHEIR"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_CHEQUES"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_CARTAO" })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_VLRDEBI"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_CONVENI"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_VALES"  })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_FINANC" })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_OUTROS" })][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_ENTRADA"})][2]	:= 0
aSL1[aScan(aSL1,{|x|x[1]=="L1_DESCONT"})][2]	:= nVlrDescPro
aSL1[aScan(aSL1,{|x|x[1]=="L1_VLRTOT" })][2]	:= nValorTotal - nVlrFSD + nVlrTIcmsRet
aSL1[aScan(aSL1,{|x|x[1]=="L1_VLRLIQ" })][2]	:= nValorTotal - nVlrFSD - Lj7T_DescV(2) + nVlrTIcmsRet
aSL1[aScan(aSL1,{|x|x[1]=="L1_VALBRUT"})][2]	:= nValorTotal - nVlrFSD + nVlrTIcmsRet
aSL1[aScan(aSL1,{|x|x[1]=="L1_VALMERC"})][2]	:= nValMerc
aSL1[aScan(aSL1,{|x|x[1]=="L1_VALICM" })][2]	:= nVlrIcms
aSL1[aScan(aSL1,{|x|x[1]=="L1_VALIPI" })][2]	:= nVlrIpi
aSL1[aScan(aSL1,{|x|x[1]=="L1_VALISS" })][2] 	:= nVlrIss
aSL1[aScan(aSL1,{|x|x[1]=="L1_BRICMS" })][2] 	:= nVlrBrIcms
aSL1[aScan(aSL1,{|x|x[1]=="L1_ICMSRET"})][2] 	:= nVlrIcmsRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alterando os valores especificos para a loja destino                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len( aSL2 )
	aSL2[nX][aScan(aSL2[nX],{|x|x[1]=="L2_NUM"})][2]    := Space(TamSx3("L2_NUM")[1])
	aSL2[nX][aScan(aSL2[nX],{|x|x[1]=="L2_ITEM"})][2]   := StrZero(nX,2)
	aSL2[nX][aScan(aSL2[nX],{|x|x[1]=="L2_LOJARES"})][2]:= Space(TamSx3("L2_LOJARES")[1])
Next nX     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o array aSL4  /  Faz o rateio dos valores das parcelas             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SL4")
dbSetOrder(1)
dbSeek(xFilial("SL4")+SL1->L1_NUM)
While !Eof() .And. SL4->L4_FILIAL+SL4->L4_NUM  == xFilial("SL4")+SL1->L1_NUM
	If cPaisLoc != "BRA"
	   	aAdd( aSL4Aux, { SL4->L4_DATA, SL4->L4_VALOR, SL4->L4_FORMA, 0, 0, SL4->L4_MOEDA } )
	Else
		aAdd( aSL4Aux, { SL4->L4_DATA, SL4->L4_VALOR, SL4->L4_FORMA, 0, 0 } )
	EndIf
	nVlrTotSl4 += SL4->L4_VALOR
	dbSkip()
Enddo

// Proporcionaliza os valores
For nX := 1 to Len(aSL4Aux)
	aSL4Aux[nX][4] := NoRound( aSL4Aux[nX][2] / nVlrTotSl4, 18 )
	aSL4Aux[nX][5] := NoRound( nVlrOrcam * aSL4Aux[nX][4], nDecimais )
Next nX

// Verifica se eh necessario fazer arredondamento
nVlrTotSl4 := 0
aEval( aSL4Aux, { |x| nVlrTotSl4 += x[5] } )
If nVlrOrcam <> nVlrTotSl4 .And. Len(aSL4Aux) >= 1
	aSL4Aux[1][5] += nVlrOrcam - nVlrTotSl4
Endif

// Grava os valores do aSL4
For nX := 1 to Len(aSL4Aux)
	aAdd( aSL4, {} )
	aAdd( aSL4[Len(aSL4)], { "L4_FILIAL"  ,xFilial("SL4") } )
	aAdd( aSL4[Len(aSL4)], { "L4_DATA"    ,aSL4Aux[nX][1] } )
	aAdd( aSL4[Len(aSL4)], { "L4_VALOR"   ,aSL4Aux[nX][5] } )
	aAdd( aSL4[Len(aSL4)], { "L4_FORMA"   ,aSL4Aux[nX][3] } )	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a gravacao desses campos direto do aPgtos pois a funcao Lj7GeraOrc   ³
	//³ foi chamada antes da gravação desses campos no SL4                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !IsMoney(aPgtos[Len(aSL4)][3]) 
		If Trim(aPgtos[Len(aSL4)][3]) == "CH"
			aAdd( aSL4[Len(aSL4)], { "L4_ADMINIS",	aPgtos[Len(aSL4)][4][04] } )
			aAdd( aSL4[Len(aSL4)], { "L4_NUMCART",	aPgtos[Len(aSL4)][4][07] } )
			aAdd( aSL4[Len(aSL4)], { "L4_AGENCIA",	aPgtos[Len(aSL4)][4][05] } )
			aAdd( aSL4[Len(aSL4)], { "L4_CONTA",	aPgtos[Len(aSL4)][4][06] } )
			aAdd( aSL4[Len(aSL4)], { "L4_RG",		aPgtos[Len(aSL4)][4][09] } )
			aAdd( aSL4[Len(aSL4)], { "L4_TELEFON",	aPgtos[Len(aSL4)][4][10] } )
			aAdd( aSL4[Len(aSL4)], { "L4_COMP",	aPgtos[Len(aSL4)][4][08] } )
			aAdd( aSL4[Len(aSL4)], { "L4_TERCEIR",	aPgtos[Len(aSL4)][4][12] } )
		Else
			aAdd( aSL4[Len(aSL4)], { "L4_ADMINIS",	aPgtos[Len(aSL4)][4][05] } )
			aAdd( aSL4[Len(aSL4)], { "L4_NUMCART",	aPgtos[Len(aSL4)][4][04] } )
		Endif
	Endif
	If cPaisLoc != "BRA"
	   aAdd( aSL4[Len(aSL4)], { "L4_MOEDA"   ,aSL4Aux[nX][_MOEDA] } )	
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array de retorno                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRet := { aSL1, aSL2, aSL4 }

Lj7RestArea( aArea )
Return aRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ LJ701AtCartao ³ Autor ³ Fabiano Banin ³ Data ³ 15/06/2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Atualiza a descrição da administradora de cartões em uma  ³±±
±±³           ³ transação TEF quando é selecionado um cartão e passado    ³±±
±±³           ³ outro.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Venda Assistida.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LJ701AtCartao()

Local a := 0, cCartao := "", lFound := .F.
                    
//-- Se o array aTefMult for maior que zero não preciso fazer a alteração por aqui, pois será feito na gravação do SL4.
If Len(aTefMult) > 0
	Return .T.
EndIf

For a := 1 To Len(aPgtos)

	If Alltrim(aPgtos[a,03]) $ _FORMATEF .AND. ! ( iIf( ExistBlock("LJ7022") .AND. ExecBlock("LJ7022", .F., .F.), ;
	                                                  Upper(Alltrim(aTefDados[01,08])) $ Upper(Alltrim(SubStr(aPgtos[a,04,05], 7))), ;
	                                                  Upper(Alltrim(SubStr(aPgtos[a,04,05], 7))) == Upper(Alltrim(aTefDados[01,08])) ) )

		cCartao := aPgtos[a,04,05]
		lFound  := .T.
		Exit
	
	EndIf

Next
                                             
If lFound

	SAE->(DBGoTop())
	
	While ! SAE->(EOF())
	
		If Upper(Alltrim(aTefDados[01,08])) == Upper(Alltrim(Left(SAE->AE_DESC, 16)))
			Exit
		EndIf
		
		SAE->(DBSkip())
		
	End
	
	If ! SAE->(EOF())
	
		aEval(aPgtos, { |x| Iif( x[03] $ _FORMATEF .AND. x[04,05] == cCartao, ;
		                         x[04,05] := SAE->AE_COD + " - " + SAE->AE_DESC, .T. ) })

	EndIf
	
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7RecTribºAutor  ³Fernando Salvatori  º Data ³  10/21/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recalculo dos valores totais para atualizacao do orcamento  º±±
±±º          ³e rateio dos itens                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºOBSERVACAO³Devido a essa funcao ser chamada para recalculo dos orcamen-º±±
±±ºIMPORTANTE³tos que sao finalizados pela funcao "Finaliza Venda" e tam- º±±
±±º          ³bem pela funcao que finaliza os orcamentos gerados pela     º±±
±±º          ³rotina de reservas/pedido, os valores como totais, descontosº±±
±±º          ³acrescimos, devem sempre ser lidos dos arquivos e nao da    º±±
±±º          ³memoria.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Lj7RecTrib()
Local nVlrDescTot  	:= SL1->L1_DESCONT                 	    	// Valor total do desconto
Local nVlDescProp  	:= 0                                     	// Valor do desconto proporcinal
Local nVlrSubTot   	:= 0                                     	// Valor do Subtotal
Local lCondNeg     	:= ( Trim( SL1->L1_CONDPG ) == "CN" )    	// Verifica se eh condicao negociada
Local nPos         	:= 0                                	    // Posicao do produto nos itens do MatxFis
Local nPerDescFin  	:= 0                                     	// Valor do desconto financeiro
Local nPerAcrsFin  	:= 0                                     	// Valor do acrescimo financeiro
Local nPercProduto 	:= 0                                     	// Valor em percentual do produto sobre o valor total
Local nVlrNegoc    	:= 0                                     	// Valor da taxa - condicao negociada
Local nVlUnit      	:= 0					                    // Valor do Item
Local nAcumVlRat   	:= 0                                	    // Valor acumulado do desconto para que seja
Local nVlrTot 	   	:= 0										// Valor total da venda
Local nSomItens    	:= 0										// Valor da soma dos itens para possiveis rateios
Local nX 			:= 0										// Variavel auxiliar
Local aSL1 			:= {}										// Array para gravar as informacoes no SL1
Local lAlterar		:= .F.										// Faz o controle se o vlrunit foi alterado
Local aItens		:= {}										// Array auxiliar para controlar os arredondamentos
Local nVlrFSD		:= M->LQ_FRETE + M->LQ_SEGURO + M->LQ_DESPESA	// Valor do frete + seguro + despesas acessorias
Local nVlrNCCUnit	:= 0										// Valor da NCC "por item"
Local nItensRT      := 0
Local nPRT          := 0
Local nVlrADNeg     := 0
Local nDescAcres    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega o valor total da venda                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nVlrTot	:= Round(Lj7T_Total( 2 ),nDecimais)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao faz a contagem do valor total baseado nas parcelas	|
//³ para que nao ocorra problemas caso o sistema esteja		|
//³ utilizando troco de qualquer numerario					|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*dbSelectArea("SL4")
dbSetOrder(1)
dbSeek(xFilial("SL4")+SL1->L1_NUM)
nVlrTot := 0
While SL4->(!Eof()) .And. SL4->L4_FILIAL + SL4->L4_NUM == xFilial("SL4") + SL1->L1_NUM
	nVlrTot	+= SL4->L4_VALOR
	dbSkip()
Enddo*/
nVlrTot += SL1->L1_CREDITO
nVlrTot += ( LJPCCRet() + iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retiro o SubTotal da Venda. Se for finalizacao da venda de um orcamento³
//³filho pega o valor da funcao Lj7or finalizacao da venda de um orcamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SL1->L1_ORCRES)
	nVlrSubTot   := SL1->L1_VLRTOT
Else
	If MaFisFound("NF")
		nVlrSubTot   := MaFisRet(,"NF_TOTAL")
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciono os registros e faco o calculo do acrescimo/desconto para     ³
//³a condicao de pagamento selecionada ou acrecimo                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lCondNeg
	dbSelectArea( "SE4" )
	dbSetOrder( 1 )
	dbSeek( xFilial( "SE4" ) + SL1->L1_CONDPG )
	
	nPerDescFin   := E4_DESCFIN                                    	//Valor do desconto financeiro
	nPerAcrsFin   := E4_ACRSFIN                                    	//Valor do acrescimo financeiro
Else
	nVlrNegoc := nVlrTot - ( nVlrSubTot - nVlrDescTot )
EndIf

dbSelectArea( "SL2" )
dbSetOrder( 1 )
dbSeek( xFilial( "SL2" ) + SL1->L1_NUM )

nX := 1
Do While ( !Eof() ) .And. ( xFilial( "SL2" ) + SL1->L1_NUM == L2_FILIAL + L2_NUM )
	nSomItens += L2_VLRITEM
	dbSkip()
	nX ++
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciono no 1 item do orcamento para efetuar o rateio dos calculos    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SL2" )
dbSetOrder( 1 )
DBGoTop()
dbSeek( xFilial( "SL2" ) + SL1->L1_NUM )

SL2->(DBEval( { || iIf(Posicione("SF4",1,xFilial("SF4")+SL2->L2_TES,"SF4->F4_ISS") == "S" .AND. LjAnalisaLeg(8)[1], ;
                       nPRT     += iIf( SL1->L1_DESCONT > 0, NoRound(( SL1->L1_DESCONT * ( ( L2_VLRITEM + L2_VALIPI ) / ( SL1->L1_VLRTOT + SL1->L1_CREDITO ) ) ), TamSX3("L2_DESCPRO")[2]), 0 ), ;
                       nItensRT ++ ) },, ;
              { || L2_FILIAL == xFilial("SL2") .AND. L2_NUM == SL1->L1_NUM .AND. ! EOF() },,, .T. ))

If nPRT > 0 .AND. nItensRT > 0
	nPRT := NoRound(( nPRT / nItensRT ), TamSX3("L2_DESCPRO")[2])
Else
	nPRT := 0
EndIf

dbSelectArea( "SL2" )
dbSetOrder( 1 )
DBGoTop()
dbSeek( xFilial( "SL2" ) + SL1->L1_NUM )

Do While ( !Eof() ) .And. ( xFilial("SL2") + SL1->L1_NUM == SL2->L2_FILIAL+SL2->L2_NUM )
	nPos += 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a proporcao ref. a cada item da venda                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPercProduto   := NoRound( ( SL2->L2_VLRITEM / nSomItens ) * 100,nDecimais)
	nVlUnit        := SL2->L2_VRUNIT
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a proporcao ref. a NCC utilizada (a NCC nao deverah entrar no ³
	//³calculo de juros do montante restante.)                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVlrNCCUnit := Round((nNCCUsada * nPercProduto) / 100,nDecimais)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Checa se o desconto total foi efetuado antes ou depois de informada a  ³
	//³condicao de pagamento. Para os casos de arredontamento da venda.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Val(SL1->L1_TIPODES) == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faco a proporcao do desconto no total para cada item da venda          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! ( Posicione("SF4",1,xFilial("SF4")+SL2->L2_TES,"SF4->F4_ISS") == "S" .AND. LjAnalisaLeg(8)[1] )
			nVlDescProp	:= Round((((nVlrDescTot * nPercProduto) / 100)+nPRT),nDecimais)
		Else
			nVLDescProp := 0
		EndIf
		
		nVlUnit        := (nVlUnit * SL2->L2_QUANT - nVlDescProp) / SL2->L2_QUANT
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso exista um desconto financeiro (apenas por condicao de pagamento)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nPerDescFin > 0
		nVlUnit    -= NoRound( (nVlUnit * nPerDescFin) / 100, TamSx3("L2_VRUNIT")[2] )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso exista um acrescimo financeiro (apenas por condicao de pagamento) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nPerAcrsFin > 0
		nVlUnit    += NoRound( ((nVlUnit - nVlrNCCUnit) * nPerAcrsFin) / 100, TamSx3("L2_VRUNIT")[2] )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso exista uma taxa de acrescimo na condicao de pagamento negociada   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCondNeg
		If ( nVlrADNeg := (nVlrNegoc - nNCCUsada) ) > 0
			nVlUnit    += NoRound(( ( ( nVlrADNeg * nPercProduto ) / 100 ) / SL2->L2_QUANT ), TamSx3("L2_VRUNIT")[2])
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Checa se o desconto total foi efetuado antes ou depois de informada a  ³
	//³condicao de pagamento. Para os casos de arredontamento da venda.       ³
	//³Verifica tbem se ha desconto financeiro para efetuar a proporcionaliza-³
	//³cao                                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Val(SL1->L1_TIPODES) == 2 .Or. (Lj7T_Subtotal(2) - Lj7T_Total(2) > 0)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faco a proporcao do desconto no total para cada item da venda          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! ( Posicione("SF4",1,xFilial("SF4")+SL2->L2_TES,"SF4->F4_ISS") == "S" .AND. LjAnalisaLeg(8)[1] )
			nVlDescProp	:= Round((((nVlrDescTot * nPercProduto) / 100)+nPRT),nDecimais)
		Else
			nVLDescProp := 0
		EndIf
		
		nVlUnit        := (nVlUnit * SL2->L2_QUANT - nVlDescProp) / SL2->L2_QUANT
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizo o arquivo de itens do orcamento com os novos valores          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nAcumVlRat += NoRound( nVlUnit * SL2->L2_QUANT, nDecimais )
	
	Begin Transaction 

   	lAlterar := .T.
	     
	RecLock( "SL2" , .F. )
	Replace L2_VRUNIT  With nVlUnit
	Replace L2_VLRITEM With NoRound( nVlUnit * SL2->L2_QUANT, nDecimais )
	Replace L2_DESCPRO With nVlDescProp
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizo as variaveis do matxfis para atualizacao dos impostos         ³
	//³(ICMS, ISS)                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MaFisFound("IT",nPos)
		
		dbSelectArea( "SL2" )
		
		//Apos a atualizacao, retiro os valores de ISS, ICMS e IPI para atualizacao da base
		Replace L2_VALISS  With MaFisRet(nPos,"IT_VALISS")
		Replace L2_BASEICM With MaFisRet(nPos,"IT_BASEICM")
		Replace L2_VALICM  With MaFisRet(nPos,"IT_VALICM")
		Replace L2_VALIPI  With MaFisRet(nPos,"IT_VALIPI")
		Replace L2_BRICMS  With MaFisRet(nPos,"IT_BASESOL")
		Replace L2_ICMSRET With MaFisRet(nPos,"IT_VALSOL")
		
	EndIf
	
	MsUnlock()
	
	End Transaction 	    
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui o valor do ICMS solidario na variavel nAcumVlRat                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nAcumVlRat += nVlrFSD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui o valor do ICMS solidario na variavel nAcumVlRat                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nAcumVlRat += If( MaFisFound("NF"), MafisRet(,"NF_VALSOL"), 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui o valor do IPI na variavel nAcumVlRat                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nAcumVlRat += If( MaFisFound("NF"), MafisRet(,"NF_VALIPI"), 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Vejo se ouve diferenca em centavos, pois no calculo acima,             ³
//³executo NoRound no calculo.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nAcumVlRat < nVlrTot
	lAlterar := .T.
	    
	aItens := {}
	dbSelectArea("SL2")
	dbSeek( xFilial("SL2") + SL1->L1_NUM )
	While !Eof() .And. xFilial("SL2") + SL1->L1_NUM == SL2->L2_FILIAL + SL2->L2_NUM
		aAdd( aItens, { SL2->(Recno()), SL2->L2_QUANT, SL2->L2_VRUNIT, SL2->L2_VLRITEM } )
		dbSkip()
	Enddo
	
	nDiferenca 	:= NoRound( ( nVlrTot - nAcumVlRat ) / Len(aItens) , nDecimais )
	nResto 		:= ( ( nVlrTot - nAcumVlRat ) - (nDiferenca * Len(aItens)) )
	
	For nX := 1 to Len( aItens )
		aItens[nX][4] += nDiferenca
		If nResto > 0
			aItens[nX][4] 	+= 0.01
			nResto 			-= 0.01
		Endif
		aItens[nX][3] := NoRound( aItens[nX][4] / aItens[nX][2], TamSx3("L2_VRUNIT")[2] )
	Next nX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza o SL2                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Begin Transaction 
	
	For nX := 1 to Len( aItens )
	
		dbGoTo( aItens[nX][1] )	
	
		RecLock( "SL2" , .F. )
		Replace SL2->L2_VRUNIT  With aItens[nX][3]
		Replace SL2->L2_VLRITEM With aItens[nX][4]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualizo as variaveis do matxfis para atualizacao dos impostos         ³
		//³(ICMS, ISS)                                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MaFisFound("IT",nX)
			
			dbSelectArea( "SL2" )
			
			//Apos a atualizacao, retiro os valores de ISS e ICMS para atualizacao da base
			Replace SL2->L2_VALISS  With MaFisRet(nX,"IT_VALISS")
			Replace SL2->L2_BASEICM With MaFisRet(nX,"IT_BASEICM")
			Replace SL2->L2_VALICM  With MaFisRet(nX,"IT_VALICM")
		EndIf
		
		MsUnlock()
		
	Next nX
	
	End Transaction 

EndIf

If MaFisFound("NF") // .And. lAlterar .And. !(nRotina == 4 .And. !Empty(SL1->L1_ORCRES))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a gravacao dos campos dos impostos do SL1                        ³
	//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
	//³ * * * Nao eh para atualizar o campo L1_VALMERC pois esse campo       ³
	//³devera conter somente o valor das mercadorias, sem impostos, descontos³
	//³ou acrescimos * * *                                                   ³
	//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
	//³ Nao serah preciso 'locar' o SL1 pois estah preso desde o inicio da   ³
	//³ rotina                                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//-- Se essa variavel for maior que zero, é desconto, caso contrário é acréscimo... Se for desconto, zero pq não vou
	//-- mais usá=lo como desconto, se for acréscimo eu pego o valor absoluto para somar ao total da venda.	
	nDescAcres := ( Lj7T_Subtotal(2) - Lj7T_Total(2) )
	nDescAcres := iIf( nDescAcres > 0, 0, Abs(nDescAcres) )
	
	dbSelectArea( "SL1" )
	aSL1 := {}
	aAdd( aSL1, { "L1_VLRTOT",		MaFisRet(,"NF_TOTAL") - nVlrFSD + nDescAcres } )
	aAdd( aSL1, { "L1_VLRLIQ",		MaFisRet(,"NF_TOTAL") - LJ7T_DescV(2) + nDescAcres })
	aAdd( aSL1, { "L1_VALBRUT",		MaFisRet(,"NF_TOTAL") - nVlrFSD + nDescAcres })
	aAdd( aSL1, { "L1_VALICM",		MaFisRet(,"NF_VALICM") } )
	aAdd( aSL1, { "L1_VALIPI",		MaFisRet(,"NF_VALIPI") } )
	aAdd( aSL1, { "L1_VALISS",		MaFisRet(,"NF_VALISS") } )
	aAdd( aSL1, { "L1_BRICMS",		MaFisRet(,"NF_BASESOL") } )
	aAdd( aSL1, { "L1_ICMSRET",		MaFisRet(,"NF_VALSOL") } )
	Lj7GeraSl( "SL1", aSL1, .F., .F. )
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³L7CriaCxa ³ Autor ³ Fernando Machima      ³ Data ³ 09/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se caixa existe(tratamento multi-moeda).O portador³±±
±±³          ³do titulo(caixa) e definido pela moeda                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := L7CriaCxa(ExpN1,ExpC2,ExpC3,ExpC4)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Moeda do titulo                                    ³±±
±±³          ³ ExpC2 - Codigo do Caixa logado                             ³±±
±±³          ³ ExpC3 - Codigo da agencia do Caixa                         ³±±
±±³          ³ ExpC4 - Codigo da conta do Caixa                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function L7CriaCxa(nMoeda,cCodigo,cAgencia,cConta)
Local cNome
Local cNReduz
Local cAlias := Alias()
Local nOrd   := IndexOrd()
Local nRec   := Recno()

DEFAULT cAgencia := "."
DEFAULT cConta   := "."

cNome   := SA6->A6_NOME
cNReduz := SA6->A6_NREDUZ

DbSelectArea("SA6")
DbSetOrder(1)
//Se banco nao encontrado, cria um novo caixa para a moeda do titulo
//O codigo desta caixa sera igual ao corrente com a diferenca de que
//sua agencia eh o MV_SIMB da moeda
If !DbSeek(xFilial("SA6")+cCodigo+GetMV("MV_SIMB"+AllTrim(Str(nMoeda))))
	Reclock( "SA6", .T. )
	Replace A6_FILIAL  with xFilial("SA6")
	Replace A6_COD 	  with cCodigo
	Replace A6_AGENCIA with GetMV("MV_SIMB"+AllTrim(Str(nMoeda)))
	Replace A6_NUMCON  with cConta
	Replace A6_NOME	   with cNome
	Replace A6_NREDUZ  with cNReduz
	Replace A6_MOEDA   with nMoeda
	Replace A6_DATAABR With dDatabase
	Replace A6_HORAABR With Substr(Time(),1,5)
	Replace A6_DATAFCH With CtoD("  /  /  ")
	Replace A6_HORAFCH With "  :  "
	MsUnlock()
EndIf

DbSelectArea(cAlias)
DbSetOrder(nOrd)
DbGoto(nRec)

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7PrepGrvºAutor  ³Julio Cesar         º Data ³  09/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Prepara os arrays utilizados na gravacao dos impostos      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Venda Assistida                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7PrepGrvImp()

Local aDadosImps  := {}
Local aImposto    := {}
Local nPosDtTes	  := aPosCpoDet[03][2]	// Posicao do Codigo do TES
Local nPosItem		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_ITEM"})][2]		// Posicao do numero do item
Local nPosProd		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_PRODUTO"})][2]	// Posicao do Codigo do produto
Local nPosQuant		:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_QUANT"})][2]		// Posicao da Quantidade
Local nPosVrUnit	:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VRUNIT"})][2]		// Posicao do Valor unitario do item
Local nValImp     := 0
Local nValBas     := 0
Local nTotImp     := 0
Local nX          := 0
Local nI 		  := 0
Local nE          := 0
Local nPosCpo     := 0

aImpsSL1 := {}
aImpsSL2 := {}

For nX := 1 To Len(aCols)
	If !aCols[nX][Len(aHeader)+1]
		aDadosImps := TesImpInf(aColsDet[nX][nPosDtTes])
		AAdd(aImpsSL2,{aCols[nX][nPosProd],aColsDet[nX][nPosDtTes],{}})
		For nI := 1 To Len(aDadosImps)                                                 
		  	If (nE := Ascan( aImpsSL1,{|x| x[1] == aDadosImps[nI,1]})) == 0
		       	AAdd(aImpsSL1,{aDadosImps[nI][1],"L1_"+Substr(aDadosImps[nI][6],4,7),0,"L1_"+Substr(aDadosImps[nI][8],4,7),0,aDadosImps[nI][3],aDadosImps[nI][9]})		    		    
				nE := Len(aImpsSL1)
		  	EndIf
		    cIndImp := Substr(aDadosImps[nI][2],10,1)               
		  	nPosCpo := aScan(aHeaderDet,{|x| Trim(x[2]) == "LR_VALIMP"+cIndImp})
		    nValImp := aColsDet[nX][nPosCpo]
		  	nPosCpo := aScan(aHeaderDet,{|x| Trim(x[2]) == "LR_BASIMP"+cIndImp})
		  	nValBas := aColsDet[nX][nPosCpo]
		   	Lj7GeraImp(@aImposto,aDadosImps[nI],nValImp,aCols[nX][nPosQuant],aCols[nX][nPosVrUnit],1,cIndImp,nValBas)			   
		   	AAdd(aImpsSL2[Len(aImpsSL2)][3],aClone(aImposto))
		   	nTotImp += (nValImp * aImposto[10,Val(Subs(aImposto[5],2,1))])			   
		   	aImpsSL1[ nE,3 ] += aImpsSL2[len(aImpsSL2)][3][nI][4]	//Valor do imposto no cabecalho		   			   
		   	aImpsSL1[ nE,5 ] += aImpsSL2[len(aImpsSL2)][3][nI][3]	//Base do imposto no cabecalho		   			   		   
		Next nI
		AAdd(aImpsSL2[Len(aImpsSL2)],aCols[nX][nPosItem])				
		AAdd(aImpsSL2[Len(aImpsSL2)],.F.)				   	           					      
	Else
	   AAdd(aImpsSL2,{aCols[nX][nPosProd],aColsDet[nX][nPosDtTes],{}})	
	EndIf
Next nX

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj7GeraImpºAutor  ³Julio Cesar         º Data ³  09/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o array com os dados dos impostos incidentes em um    º±±
±±º          ³ determinado produto                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Venda Assistida                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Lj7GeraImp(aImposto,aInfo,nValImp,nQuant,nVlrUnit,nX,cIndImp,nValBas)

Local cCpoVlrItem := ""
Local cCpoBaseIte := ""
Local cCpoVlrCab  := ""
Local cCpoBaseCab := ""

cCpoVlrItem := "L2_"+Subs(aInfo[2],4,7)   //Campo de gravacao do valor do imposto no item
cCpoBaseIte := "L2_"+Subs(aInfo[7],4,7)   //Campo de gravacao da base do imposto no item
cCpoVlrCab  := "L1_"+Subs(aInfo[6],4,7)   //Campo de gravacao do valor do imposto no cabecalho
cCpoBaseCab := "L1_"+Subs(aInfo[8],4,7)   //Campo de gravacao da base do imposto no cabecalho

aImposto := {}                   //Limpa o array para que armazene somente os 
 						         //dados do imposto que está sendo calculado

AAdd( aImposto, aInfo[1] )       //Codigo do imposto
AAdd( aImposto, aInfo[9] )       //Aliquota do imposto  
AAdd( aImposto, nValBas )        //Base do Imposto
AAdd( aImposto, nValImp  )                         //Valor do imposto
AAdd( aImposto, aInfo[4] + aInfo[3] + aInfo[5] )   //FC_INCDUPL/FC_INCNOTA/FC_CREDITA
AAdd( aImposto, cCpoVlrItem )
AAdd( aImposto, cCpoBaseIte )
AAdd( aImposto, cCpoVlrCab )
AAdd( aImposto, cCpoBaseCab )
AAdd( aImposto, {1,-1,0} )                
AAdd( aImposto, nQuant )  
AAdd( aImposto, nVlrUnit )

Return( Nil )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Lj7DocsCF³ Autor ³Julio Cesar             ³ Data ³ 23/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela para digitacao de documentos para clientes tipo Consu-³±±
±±³          ³ midor Final cuja venda seja superior ao determinado no pa- ³±±
±±³          ³ rametro MV_LIMCFIS                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Lj7DocsCF()                 							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Venda Assistida (Loc. Argentina)                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Lj7DocsCF(aDadosCF)   
LOCAL lRet      := .F.
LOCAL cCbxTpDoc := ""
LOCAL nPosDocCF
LOCAL aTipoDoc  := {}
Local aTipoCI   := {}
Local aAreaSX3  := {}
Local aAreaSX5  := {}
LOCAL aArea     := GetArea()
LOCAL oDlgLojaDocs
LOCAL oTipoDoc
Local oTipoCI

DbSelectArea("SX3") 
aAreaSX3 := GetArea()
DbSetOrder(2)
If DbSeek("LS_TPDOCCF")
   cCbxTpDoc  := X3CBox()  //O combo box pode variar de impressora para impressora
EndIf   
RestArea(aAreaSx3)

While .T.
   nPosDocCF  := At(";",cCbxTpDoc)
   If !Empty(cCbxTpDoc) 
      If nPosDocCF > 0  //Preenche no array aTipoDoc com as opcoes disponiveis
         Aadd(aTipoDoc,Substr(cCbxTpDoc,1,nPosDocCF-1))   
      Else //Ultimo elemento
         nPosDocCF  := Len(cCbxTpDoc)
         Aadd(aTipoDoc,Substr(cCbxTpDoc,1,nPosDocCF))         
         Exit
      EndIf   
      cCbxTpDoc  := Substr(cCbxTpDoc,nPosDocCF+1)
   Else
      Exit   
   EndIf
End

//Busca os tipos de CI na tabela "OC" do arq. SX5
DbSelectArea("SX5")
aAreaSX5 := GetArea()
If DbSeek(xFilial("SX5")+"OC")
   While xFilial("SX5")+"OC" == SX5->X5_FILIAL+AllTrim(SX5->X5_TABELA)
      If Substr(X5Descri(),4,3) == "CI "
         Aadd(aTipoCI,Substr(X5Descri(),1,2)+"-"+Substr(X5Descri(),4))
      EndIf
      DbSkip()
   End
EndIf
RestArea(aAreaSX5)

DEFINE MSDIALOG oDlgLojaDocs FROM 12, 14 TO 23, 80 TITLE STR0036; //"Dados para Consumidor Final"
STYLE nOr( DS_MODALFRAME, WS_DLGFRAME ) OF oDlgVA
												
@ 00.3 , 01 TO 5,31.2 OF oDlgLojaDocs

@ 01.0 , 01.5 SAY STR0037 //"Tipo do Documento"
@ 12.0 , 69.5 MSCOMBOBOX oTipoDoc VAR aDadosCF[2] ITEMS aTipoDoc OF oDlgLojaDocs SIZE 92,40 ON CHANGE Lj7TipoDoc(aDadosCF[2],oTipoCI) PIXEL

//Tipo CI
@ 12.0 , 163  MSCOMBOBOX oTipoCI VAR aDadosCF[3] ITEMS aTipoCI OF oDlgLojaDocs SIZE 82,40 PIXEL
oTipoCI:Hide()
						
@ 02.0 , 01.5 SAY STR0038 //"Numero do Documento"
@ 25.0 , 69.5 MSGET aDadosCF[1] RIGHT SIZE 92,10 OF oDlgLojaDocs PIXEL PICTURE PesqPict("SLS","LS_DOCCF")

@ 03.0 , 01.5 SAY STR0039 //"Nome do Cliente"
@ 37.0 , 69.5 MSGET aDadosCF[4] RIGHT SIZE 175,10 OF oDlgLojaDocs PIXEL 

@ 04.0 , 01.5 SAY STR0040 //"Endereco"
@ 49.0 , 69.5 MSGET aDadosCF[6] RIGHT SIZE 175,10 OF oDlgLojaDocs PIXEL 
					

DEFINE SBUTTON FROM 70,103 TYPE 1 ACTION (Iif(Lj7VldCF(aDadosCF),lRet := .F.,;
(lRet:= .T.,IIf(aDadosCF[2]!="6",aDadosCF[3] := "",aDadosCF[3] := Substr(aDadosCF[3],1,2));
,oDlgLojaDocs:End()))) ENABLE OF oDlgLojaDocs

DEFINE SBUTTON FROM 70,136 TYPE 2 ACTION (lRet:= .F.,oDlgLojaDocs:End()) ENABLE OF oDlgLojaDocs
						
ACTIVATE MSDIALOG oDlgLojaDocs

RestArea(aArea)

Return (lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Lj7VldCF  ³ Autor ³  Julio Cesar          ³ Data ³ 23/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se todos os dados do Cliente foram digitados na   ³±±
±±³          ³ tela quando Consumidor Final e venda > MV_LIMCFIS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Lj7VldCF()                 							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Venda Assistida (Loc. Argentina)                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Lj7VldCF(aDadosCF)

Local lRet  

lRet  := Empty(aDadosCF[2]) .Or. Empty(aDadosCF[1]) .Or. Empty(aDadosCF[4]) .Or. Empty(aDadosCF[6])

Return (lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Lj7TipoDoc³ Autor ³ Julio Cesar           ³ Data ³ 23/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tratamento para tipo de documento CI                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Lj7TipoDoc(cTipoDocCF,oTipoCI)							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Venda Assistida (Loc. Argentina)                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Lj7TipoDoc(cTipoDocCF,oTipoCI)

If cTipoDocCF == "6"  //CI
   oTipoCI:Show()              		   		   
Else
   oTipoCI:Hide()              		   		      
EndIf
oTipoCI:Refresh()		   		                   		      
   
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Lj7SerArg  ³ Autor ³  Julio Cesar            ³Data  ³29/01/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Indica a serie da fatura/cupom fiscal dependendo do tipo de   ³±±
±±³          ³ cliente(Loc. Argentina)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ExpL1 := Lj7SerArg()                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpC1 := Serie                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Venda Assistida     									     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Lj7SerArg()

Local cTipoCli   := ""
Local cSerieDoc  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Relacao Tipo de Cliente x Serie  ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Tipo Cliente      ³ Serie        ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³E(Exportacao)   	 ³ E		    ³
//³F(Cons. Final)    ³ B            ³
//³M(Monotrib.)      ³ B            ³
//³N(Resp.Nao Insc.) ³ B            ³
//³S(Nap Sujeito)    ³ B            ³
//³X(Isento) 	     ³ B            ³
//³I(Inscrito)       ³ A            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipoCli  := Posicione( "SA1",1,xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,"SA1->A1_TIPO" )
If cTipoCli == "E"	        
   cSerieDoc := "E"	   
ElseIf cTipoCli $ "F|M|N|S|X"
   cSerieDoc := "B"	   
Else
   cSerieDoc := "A"	   	      
EndIf   

Return (cSerieDoc)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ LJ7ImpCH ³ Autor ³ Cesar Eduardo Valadao ³ Data ³26/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza impressao do cheque                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function LJ7ImpCH
Local i, lTemCH:=.F., cObs:="", cVerso:=""
Local cFavorec, cCidade, cBanco, nValor, dEmissao, cAgencia, cConta, cCheque
For i := 1 To Len(aPgtos)
	If AllTrim(aPgtos[i][3]) == AllTrim(MVCHEQUE)
		lTemCH := .T.
		Exit
	EndIf
Next
	
If lTemCH
	cFavorec := SM0->M0_NOME
	cCidade  := Left(SM0->M0_CIDCOB,15)
	cCidade  := If(Empty(cCidade), "Sao Paulo", cCidade)
	For i := 1 To Len(aPgtos)
		If AllTrim(aPgtos[i][3]) == AllTrim(MVCHEQUE)
			cBanco   := Substr(aPgtos[i][4][4],1,3)
			nValor   := aPgtos[i][2]
			IF GetMV("MV_DATCHE") == "E"
				dEmissao := dDataBase
			Else
				dEmissao := aPgtos[nI][1]
			EndIf
			cAgencia := aPgtos[i][4][5]
			cConta   := aPgtos[i][4][6]
			cCheque  := aPgtos[i][4][7]
			LjImpCheque(cBanco, cAgencia, cConta, cCheque, @nValor, @cFavorec, @cCidade, @dEmissao, @cObs, @cVerso, .F.)
		EndIf
	Next
EndIf
Return(NIL)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LJ7ConfAdm  ³ Autora³ Solange Zanardi     ³ Data ³ 16.09.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza a descricao da adiministrada de cartos em uma     ³±±
±±³          ³ transacao TEF, qdo selecionada uma ADM <> da utilizada     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ LOJA701C                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LJ7ConfAdm(cAdmUti,cAdmRet)
Local aArea := GetArea(), cReturn := cAdmUti, cAdmVer := "", nPos := ( At(" - ", cAdmUti) + 3 )

cAdmVer := AllTrim(Upper(SubStr(cAdmUti, nPos)))  //-- Administradora selecionada pelo usuário.
cAdmRet := Alltrim(Upper(cAdmRet))                //-- Administradora retornada pelo TEF (que realmente foi utilizada).

If ! ( iIf( ExistBlock("LJ7022") .AND. ExecBlock("LJ7022", .F., .F.), cAdmRet $ cAdmVer, cAdmVer == cAdmRet ) )

	DBSelectArea("SAE")
	DBGoTop()
	
	While ! Eof() .AND. AE_FILIAL == xFilial("SAE")

		//-- Caso encontre a administradora retornada pelo TEF no cad. de administradora ela que será utilizada,
		//-- caso contrário fica a que o usuário escolheu.	
		If cAdmRet == AllTrim(Upper(SAE->AE_DESC))
			cReturn := SAE->AE_COD + " - " + AllTrim(Upper(SAE->AE_DESC))
			Exit
		EndIf
		
		DBSkip()

	EndDo
			
EndIf

RestArea(aArea)
Return(cReturn)
