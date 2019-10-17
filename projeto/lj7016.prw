#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Lj7016   บAutor  ณRicardo Mansano     บ Data ณ  09/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ P.E. que altera a chamada da fun็ใo Lj7Tabela para a funcaoบฑฑ
ฑฑบ          ณ Aviso() na array aFuncoes para evitar que seja acionada a  บฑฑ
ฑฑบ          ณ tela de Tabela de Pre็os em SB0 ja que esta rotina utiliza บฑฑ
ฑฑบ          ณ a Tabela de pre็os em DA0 e DA1.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ P.E. na Venda Assistida (Loja701)                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบNorbert   ณ22/07/05ณ      ณAlteracao da chamada do botao Detalhes para บฑฑ
ฑฑบ          ณ        ณ      ณatualizar a tela apos qualquer alteracao.	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function LJ7016()

Local nPosAFunc	:= aScan(aFuncoes,{ |x| AllTrim(x[3]) == "LJPRECO" })
Local nPosHist 	:= aScan(aFuncoes,{ |x| AllTrim(x[3]) == "HISTORIC" })
Local nPosEst  	:= aScan(aFuncoes,{ |x| AllTrim(upper(x[1])) == "CONSULTAR ESTOQUE" })
Local nPosDet	:= aScan(aFuncoes,{ |x| AllTrim(upper(x[3])) == "VERNOTA" })
Local nPosGrv	:= aScan(aFuncoes,{ |x| AllTrim(upper(x[3])) == "PEDIDO"  })
Local nPosDsc	:= aScan(aFuncoes,{ |x| AllTrim(x[3]) == "BUDGETY" })
Local nPosTrc	:= aScan(aFuncoes,{ |x| AllTrim(x[3]) == "PMSRRFSH" })
//Local nPoscEst	:= aScan(aFuncoes,{ |x| AllTrim(x[3]) == "CONS ESTOQUE POR PRODUTO" })
Local _aFunc 	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Esta Variavel Public determinara se foi precionado o botao  ณ
//ณ de Equipe de Montagem, foi criado pois a forma de se defi-  ณ 
//ณ nir a exclusao de uma equipe eh verificar se a Array        ณ
//ณ _DELA013B esta vazia, e ela estara vazia caso nao seja aces-ณ
//ณ sada a Tela de Equipe. Ela eh carregada em DELA013A         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Public _DELA013A	:= .F.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Esta Variavel Public contera os dados da Equipe de Montagem,ณ
//ณ sera manipulada no DELA013B() e utilizada no P.E. LJ7002    ณ 
//ณ para salvar as informacoes em PAB.                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Public _DELA013B	:= {} 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariavel publica de controle do acionamento dos botoesณ
//ณpara calculo das parcelas geradas pelo sinistro       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Public _lDELA020	:= .F.  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariavel que armazena a ultima condicao de pagamento ณ
//ณselecionada                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Public _cD020CPG	:=	""  
Public _lCPGCN		:= .t.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณA variavel publica _bLJ7016A armazena o bloco de codigoณ
//ณoriginal do padrao a ser executado ao termino da venda ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Public _bLJ7016A	:=  NIL

	_cD020CPG	:=	IIf(Altera,SL1->L1_CONDPG,"")	//Armazena condicao de pagamento
	_bLJ7016A	:=	aFuncoes[nPosGrv  ,4]			//Armazena rotina de finalizacao padrao
                                   
	aFuncoes[nPosAFunc,4] := {|| Aviso("Aten็ใo !!!","Tabela de Pre็o indisponivel !!!",{" << Voltar"},2,"Tabela de Pre็os !")}
	aFuncoes[nPosHist ,4] := {|| P_DELC004(M->LQ_CLIENTE ,M->LQ_LOJA , .T. )} // Consulta de dados historicos do cliente
	aFuncoes[nPosEst  ,4] := {|| P_DELC003A()} 
	aFuncoes[nPosDet  ,4] := {|| P_DELA038()}
	aFuncoes[nPosGrv  ,4] := bAltBloc()
//	aFuncoes[nPoscEst ,4] := U_ConsEst()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento para desabilitar descontos no total da vendaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  	If !GetMv("FS_DEL044")
		aFuncoes[nPosDsc  ,4] := {||ApMsgInfo("Funcionalidade desativada pelo Administrador. Parโmetro:FS_DEL044.","Descontos")}
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento para desabilitar o botao troca ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nPosTrc != 0
		aFuncoes[nPosTrc  ,4] := {||ApMsgInfo("Funcionalidade desativada.","Troca")}
	EndIf

    // Observa็๕es sobre Array a Funcoes
    // ---------------------------------
	// Quinto parametro : .F. = Nao Exibe botao no ToolBar lateral da tela
	//                    .T. = Exibe botao no ToolBar lateral da tela 
	// Setimo parametro : 6=Ctrl+F entao 7=Ctrl+G e assim por diante
	AADD(_aFunc,{"Equipe de Montagem","Equipe de Montagem","S4WB005N",{||P_DELA013A()},.T.,.T.,4,{6,"Ctrl+F"} })
	AADD(_aFunc,{"Limpar Deletados","Limpa produtos deletados","S4WB004N",{||P_DELC001I()},.T.,.T.,4,{12,"Ctrl+L"} })
	//AADD(_aFunc,{"Margem Media","Margem M้dia do Pedido","GRAF3D",{||P_DELA018B()},.T.,.T.,4,{13,"Ctrl+M"} })
	AADD(_aFunc,{"Visualiza Reservas","Visualiza Reservas","S4WB011N",{||P_DELA025A()},.T.,.T.,4,{14,"Ctrl+N"} })
	AADD(_aFunc,{"Relatorio Montagem","Relatorio de Montagem","FORM",{||P_DELR001()},.T.,.T.,4,{15,"Ctrl+O"} })
	AADD(_aFunc,{"Obs. Convenio","Obs. Convenio","FORM",{||P_DELA043()},.F.,.T.,4,{16,"Ctrl+P"} })
	AADD(_aFunc,{"Consulta de Estoque por Produto/Filial","Consulta Estoque","FORM",{||U_ConsEst()},.F.,.T.,3,{17,"Ctrl+Q"} })
	
Return(_aFunc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBAltBloc  บ Autor ณNorbert Waage Juniorบ Data ณ  25/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFuncao de troca da acao do botao de gravacao da venda       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณBloco de codigo contendo a rotina de liberacao de reservas  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณFuncao chamada pelo ponto de entrada LJ7016 para que a fun- บฑฑ
ฑฑบ          ณcao de liberacao de reservas seja acionada no fim da venda. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Della Via Pneus                                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                   	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function bAltBloc()
Return {|| P_DelReserv(), Eval(_bLJ7016A) }