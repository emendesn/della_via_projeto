#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Lj7016   �Autor  �Ricardo Mansano     � Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � P.E. que altera a chamada da fun��o Lj7Tabela para a funcao���
���          � Aviso() na array aFuncoes para evitar que seja acionada a  ���
���          � tela de Tabela de Pre�os em SB0 ja que esta rotina utiliza ���
���          � a Tabela de pre�os em DA0 e DA1.                           ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � P.E. na Venda Assistida (Loja701)                          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���Norbert   �22/07/05�      �Alteracao da chamada do botao Detalhes para ���
���          �        �      �atualizar a tela apos qualquer alteracao.	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//�������������������������������������������������������������Ŀ
//� Esta Variavel Public determinara se foi precionado o botao  �
//� de Equipe de Montagem, foi criado pois a forma de se defi-  � 
//� nir a exclusao de uma equipe eh verificar se a Array        �
//� _DELA013B esta vazia, e ela estara vazia caso nao seja aces-�
//� sada a Tela de Equipe. Ela eh carregada em DELA013A         �
//���������������������������������������������������������������
Public _DELA013A	:= .F.
//�������������������������������������������������������������Ŀ
//� Esta Variavel Public contera os dados da Equipe de Montagem,�
//� sera manipulada no DELA013B() e utilizada no P.E. LJ7002    � 
//� para salvar as informacoes em PAB.                          �
//���������������������������������������������������������������
Public _DELA013B	:= {} 
//������������������������������������������������������Ŀ
//�Variavel publica de controle do acionamento dos botoes�
//�para calculo das parcelas geradas pelo sinistro       �
//��������������������������������������������������������
Public _lDELA020	:= .F.  
//�����������������������������������������������������Ŀ
//�Variavel que armazena a ultima condicao de pagamento �
//�selecionada                                          �
//�������������������������������������������������������
Public _cD020CPG	:=	""  
Public _lCPGCN		:= .t.
//�������������������������������������������������������Ŀ
//�A variavel publica _bLJ7016A armazena o bloco de codigo�
//�original do padrao a ser executado ao termino da venda �
//���������������������������������������������������������
Public _bLJ7016A	:=  NIL

	_cD020CPG	:=	IIf(Altera,SL1->L1_CONDPG,"")	//Armazena condicao de pagamento
	_bLJ7016A	:=	aFuncoes[nPosGrv  ,4]			//Armazena rotina de finalizacao padrao
                                   
	aFuncoes[nPosAFunc,4] := {|| Aviso("Aten��o !!!","Tabela de Pre�o indisponivel !!!",{" << Voltar"},2,"Tabela de Pre�os !")}
	aFuncoes[nPosHist ,4] := {|| P_DELC004(M->LQ_CLIENTE ,M->LQ_LOJA , .T. )} // Consulta de dados historicos do cliente
	aFuncoes[nPosEst  ,4] := {|| P_DELC003A()} 
	aFuncoes[nPosDet  ,4] := {|| P_DELA038()}
	aFuncoes[nPosGrv  ,4] := bAltBloc()
//	aFuncoes[nPoscEst ,4] := U_ConsEst()
	
	//�������������������������������������������������������Ŀ
	//�Tratamento para desabilitar descontos no total da venda�
	//���������������������������������������������������������
  	If !GetMv("FS_DEL044")
		aFuncoes[nPosDsc  ,4] := {||ApMsgInfo("Funcionalidade desativada pelo Administrador. Par�metro:FS_DEL044.","Descontos")}
	EndIf

	//������������������������������������������Ŀ
	//�Tratamento para desabilitar o botao troca �
	//��������������������������������������������
	If nPosTrc != 0
		aFuncoes[nPosTrc  ,4] := {||ApMsgInfo("Funcionalidade desativada.","Troca")}
	EndIf

    // Observa��es sobre Array a Funcoes
    // ---------------------------------
	// Quinto parametro : .F. = Nao Exibe botao no ToolBar lateral da tela
	//                    .T. = Exibe botao no ToolBar lateral da tela 
	// Setimo parametro : 6=Ctrl+F entao 7=Ctrl+G e assim por diante
	AADD(_aFunc,{"Equipe de Montagem","Equipe de Montagem","S4WB005N",{||P_DELA013A()},.T.,.T.,4,{6,"Ctrl+F"} })
	AADD(_aFunc,{"Limpar Deletados","Limpa produtos deletados","S4WB004N",{||P_DELC001I()},.T.,.T.,4,{12,"Ctrl+L"} })
	//AADD(_aFunc,{"Margem Media","Margem M�dia do Pedido","GRAF3D",{||P_DELA018B()},.T.,.T.,4,{13,"Ctrl+M"} })
	AADD(_aFunc,{"Visualiza Reservas","Visualiza Reservas","S4WB011N",{||P_DELA025A()},.T.,.T.,4,{14,"Ctrl+N"} })
	AADD(_aFunc,{"Relatorio Montagem","Relatorio de Montagem","FORM",{||P_DELR001()},.T.,.T.,4,{15,"Ctrl+O"} })
	AADD(_aFunc,{"Obs. Convenio","Obs. Convenio","FORM",{||P_DELA043()},.F.,.T.,4,{16,"Ctrl+P"} })
	AADD(_aFunc,{"Consulta de Estoque por Produto/Filial","Consulta Estoque","FORM",{||U_ConsEst()},.F.,.T.,3,{17,"Ctrl+Q"} })
	
Return(_aFunc)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BAltBloc  � Autor �Norbert Waage Junior� Data �  25/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Funcao de troca da acao do botao de gravacao da venda       ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   �Bloco de codigo contendo a rotina de liberacao de reservas  ���
�������������������������������������������������������������������������͹��
���Aplicacao �Funcao chamada pelo ponto de entrada LJ7016 para que a fun- ���
���          �cao de liberacao de reservas seja acionada no fim da venda. ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function bAltBloc()
Return {|| P_DelReserv(), Eval(_bLJ7016A) }