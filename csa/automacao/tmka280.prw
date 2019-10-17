#INCLUDE "TMKA280.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TMKDEF.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKA280   �Autor  �Armando M. Tessaroli� Data �  12/05/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pre-atendimento para Telecobranca Ativa                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������ĺ��
���Andrea F. �27/12/04�811   �- Nao permitir que operadores que possuam   ���
���          �        �      �regra de selecao para listas de cobranca    ���
���          �        �      �utilizem o pre-atendimento.                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function TMKA280()

Local cRegSel		:=TkPosto(TkOperador(),"U0_REGSEL")					// Regra de selecao do Operador 
Private aTela1[0][0]													// Utilizada na montagem da Enchoice pela funcao MsMGet()
Private aTela2[0][0]													// Utilizada na montagem da Enchoice pela funcao MsMGet()
Private cCadastro	:= STR0001											// "Pr�-atendimento da Telecobran�a Ativa"
Private aRotina		:= {	{STR0002,	"AxPesqui"		,	0,	1},;	// "Pesquisa"
							{STR0003,	"AxVisual"		,	0,	2},;	// "Visualiza"
							{STR0004,	"TK280Cobranca"	,	0,	3};		// "Cobran�a"
						}

//���������������������������������������������������Ŀ
//�Nao permite a abertura simultanea para o modelo MDI�
//�����������������������������������������������������
If !ExcProcess("TMK" + __cUserId)
	Help("  ",1,"TMKPROMDI")//"Essa rotina nao pode ser executada em conjunto com as rotinas..."
	Return(.F.)
Endif

//������������������������������������������������������������������������������Ŀ
//�Faz o tratamento para garantir a exclusividade na rotina de atualizacao do SK1�
//��������������������������������������������������������������������������������
ExcProcess("TMKSK1")

//�����������������������������������������������������������������Ŀ
//�Se o USUARIO nao estiver cadastrado em OPERADORES e nao tiver    �
//�um Grupo de Atendimento (SU0) associado ou se o Operador nao 	�
//�tiver acesso a rotina de Telecobranca ou Todas - nao entra nessa �
//�rotina                                                           �
//�������������������������������������������������������������������
If !TMKOPERADOR()
	Help("  ",1,"OPERADOR")//Esse usuario nao esta associado com um operador. Ou nao se trata de um operador valido..."
	Return(.F.)
Else     
	If	VAL(TkGetTipoAte()) == TELEVENDAS		.OR.;
		VAL(TkGetTipoAte()) == TELEMARKETING	.OR.;
		VAL(TkGetTipoAte()) == TMKTLV
		Help("  ",1,"TK280ACTLC")//"Esse operador nao possui acesso a rotina de telecobranca, definido no cadastro de operadores"
		Return(.F.)
	Endif
EndIf	

// Verifica se o Operador possui regra de selecao e de negociacao.
If Empty(TkPosto(TkOperador(),"U0_REGSEL")) .OR. Empty(TkPosto(TkOperador(),"U0_REGNEG"))
	Help("  ",1,"TK280REGRA")//"Esse operador nao possui as regras de selecao ou negociacao definidas para executar a rotina e Telecobran�a"
	Return(.F.)
Else
	DbSelectArea("SK0")
	DbSetOrder(2)
	MsSeek(xFilial("SK0")+cRegSel)
    If SK0->K0_PRAZO == "999999"		// Trabalha com lista de contato
		MsgStop("N�o � permitido executar a rotina de Pr�-Atendimento por operadores que possuam regra de sele��o de Listas de Cobran�a. Utilize a rotina Agenda do Operador para executar as Listas de Cobran�a. ","Aten��o")
		Return(.F.)
	Endif

Endif

// Verifica se o Operador realiza atendimento ATIVO
If TkPosto(TkOperador(),"U0_BOUND") == "1"		// Receptiva
	Help("  ",1,"TK280ATEND")//"Esse operador nao possui acesso para realizar essa operacao de atendimento"
	Return(.F.)
Endif

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(,,,,"ACF")

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK280Cobranca�Autor �Armando M. Tessaroli� Data �  12/05/03 ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria o objeto principal do pre-atendimento que apresentara  ���
���          �todas as informacoes necessarias para o atendimento.        ���
�������������������������������������������������������������������������͹��
���Uso       �AP8                                                         ���
�������������������������������������������������������������������������͹��
���Parametros�cAlias - Alias passado pela mBrowser                        ���
���          �nReg   - Recno passado pelo mBrowser                        ���
���          �nOpc   - Opcao de menu passado pelo mBrowser                ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������ĺ��
���Andrea F. �19/09/05�811   �- Filtrar todas as regras de selecao apenas ���
���          �        �      �da filial corrente.                         ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function TK280Cobranca(cAlias,nReg,nOpc)

Local oExplorer									// Objeto que contem o tree e os panels
Local aResource	:= {}							// Contem todos os botoes que farao parte do tool bar
Local aKey		:= {}							// Seta as teclas de atalho para os botoes da Tool Bar
Local lRet		:= .F.							// Retorno da funcao
Local cOperador	:= ""			   				// Codigo do Operador 
Local nI		:= 0 							// Contador
Local aMemory	:= {}							// array com array das variaveis de memoria para refresh
Local aPanels	:= {}							// Objs principais de todos os panels
Local aRegras	:= {}							// Todas as regras de atendimento
Local nPos		:= 0			   				// Posicao do objeto no array
Local lTK280TB	:= FindFunction("U_TK280TB")	// Ponto de entrada para incluir botoes na barra de ferramentas
Local nIni		:= 0							// Inicio do periodo de cobranca
Local nFim		:= 0							// Final do periodo de cobranca
Local lCredito	:= .F.							// Permicao de manipulacao de credito
Local cUltimo	:= GetMv("MV_TMKSK1")			// Data e hora da ultima atualizacao
Local aBotoes	:= {}
//���������������������������������������������������������������������������Ŀ
//�Carrega um array com as regras de cobranca que serao utilizadas pela rotina�
//�Filtra todas as regras de selecao apenas da filial corrente. Pois se       �
//�o cadastro de regras de selecao estiver compartilhado as regras irao  valer�
//�para todas as filiais da empresa corrente, caso contrario, se o cadastro   �
//�estiver exclusivo, cada filial ira utilizar a sua regra.                   �
//�����������������������������������������������������������������������������
DbSelectArea("SK0")
DbSetOrder(2)
MsSeek(xFilial("SK0"))
While !Eof() .AND. xFilial("SK0") == SK0->K0_FILIAL
        nIni := nFim + 1
        If SK0->K0_PRAZO == "999999"		// Trabalha com lista de contato
        	nFim := nFim + 100000
        Else
	        nFim := nFim + Val(SK0->K0_PRAZO)
		Endif
        Aadd(aRegras, {SK0->K0_REGSEL, nIni, nFim})
        DbSelectArea("SK0")
        DbSkip()
End

//����������������������������������������������Ŀ
//�Posiciona nas regras de Negociacao do operador�
//������������������������������������������������
DbSelectArea("SK2")
DbSetOrder(1)
If MsSeek(xFilial("SK2") + SU0->U0_REGNEG)
	If SK2->K2_CREDITO == "1"
		lCredito := .T.
	Endif
Endif

//������������������������������Ŀ
//�passa o nOpc para VISUALIZACAO�
//��������������������������������
nOpc := 2 //Visualizacao

//��������������������������������������������������������������������Ŀ
//�Variaveis que possuem conteudos que serao utilizados por toda rotina�
//����������������������������������������������������������������������
cOperador := TkOperador()

// Carrega as variaveis de memoria para todas as enchoices
ACF->(DbGoTo(0))
RegToMemory("ACF",.F.)
SA1->(DbGoTo(0))
RegToMemory("SA1",.F.)
SU5->(DbGoTo(0))
RegToMemory("SU5",.F.)

oExplorer := MSExplorer():New( STR0005 ) //"Telecobran�a Ativa"

Processa( {|| TK280PreTLC(oExplorer,cOperador,@aPanels,@aMemory,aRegras)}, STR0006) //"Cria��o dos Paineis"

// Define os botoes para a barra de ferramentas
Aadd( aResource, { "BMPINCLUIR"	, STR0008, {|| TK280Novo(oExplorer, cOperador, aRegras, @aPanels, @aMemory) },	STR0058,	.T. } ) //"Busca um novo Pr�-atendimento para cobran�a - (F6)", "Novo"
Aadd( aResource, { "SIMULACA"	, STR0009, {|| TK280Financ("010", oExplorer, aPanels, @aMemory) },				STR0059,	.T. } ) //"Consulta Posi��o Financeira do Cliente - (F7)", "Cliente"
Aadd( aResource, { "BUDGET"		, STR0010, {|| TK280Financ("040", oExplorer, aPanels, @aMemory) },				STR0060,	.T. } ) //"Consulta Posi��o Financeira do Titulo - (F8)", "T�tulo"
Aadd( aResource, { "BAIXATIT"	, STR0011, {|| TK280Credito(lCredito, oExplorer, aPanels, @aMemory) },			STR0061,	.T. } ) //"Manipula o Cr�dito do Cliente - (F9)", "Cr�dito"
Aadd( aResource, { "DISCAGEM"	, STR0012, {|| TK280Atend(oExplorer, @aPanels, @aRegras, cOperador, @aMemory) },	STR0062,	.T. } ) //"Executa a tela de atendimento - (F10)", "Cobrar"
Aadd( aResource, { "S4WB011N"	, STR0069, {|| Tk280Pesq(oExplorer,@aPanels, @aRegras, cOperador)},STR0069,.T.})//"Pesquisar Pend�ncia"     
Aadd( aResource, { "USER"	 	, STR0068, {|| Tk280Contato(oExplorer,@aPanels)},STR0068,.T.})//"Cadastro de Contatos"     

// Define as teclas de atalho dos botoes
Aadd(aKey, { VK_F6, {|| TK280Novo(oExplorer, cOperador, aRegras, @aPanels, @aMemory) } } )
Aadd(aKey, { VK_F7, {|| TK280Financ("010", oExplorer, aPanels, @aMemory) } } )
Aadd(aKey, { VK_F8, {|| TK280Financ("040", oExplorer, aPanels, @aMemory) } } )
Aadd(aKey, { VK_F9, {|| TK280Credito(lCredito, oExplorer, aPanels, @aMemory) } } )
Aadd(aKey, { VK_F10,{|| TK280Atend(oExplorer, @aPanels, @aRegras, cOperador, @aMemory) } } )

//Aadd( aResource, {"FINAL", "Encerra o Pr�-atendimento", {|| oExplorer:Deactivate()}})
//�����������������������������������������������������������������Ŀ
//�O ponto de entrada TK280TB tem como objetivo incluir novos botoes�
//�na barra de ferramentas superior.                                �
//�������������������������������������������������������������������
If lTK280TB
	// Recebe via ponto de entrada os novos botoes. 
 	aBotoes := U_TK280TB()
	
	// Verifica se o retorno eh um array 
	If ValType(aBotoes) <> "A" 
		Help("  ",1,"TK280PENTR")//"Ocorreu um retorno invalido no ponto de entrada TK280TB que impede a utilizacao do sistema"
		Return(.F.)
	Endif
	
	For nI := 1 To Len(aBotoes)
		If	ValType(aBotoes[nI][1]) <> "C"	.OR.;
			ValType(aBotoes[nI][2]) <> "C"	.OR.;
			ValType(aBotoes[nI][3]) <> "B"	.OR.;
			ValType(aBotoes[nI][4]) <> "C"	.OR.;
			ValType(aBotoes[nI][5]) <> "L"
			
			Help("  ",1,"TK280PENTR")//"Ocorreu um retorno invalido no ponto de entrada TK280TB que impede a utilizacao do sistema"
			Return(.F.)
		Endif
	Next nI
Endif

// Carrega todos os botoes padrao na barra de ferramentas
For nI := 1 To Len(aResource)
	If aResource[nI][5]
		oExplorer:AddDefButton( aResource[nI][1], aResource[nI][2], aResource[nI][3],,,, aResource[nI][4] )
		If nI <= 5
			SetKey(aKey[nI][1], aKey[nI][2] )
		Endif
	Endif
Next nI

// Carrega todos os botoes do ponto de entrada na barra de ferramentas
For nI := 1 To Len(aBotoes)
	If aBotoes[nI][5]
		oExplorer:AddDefButton( aBotoes[nI][1], aBotoes[nI][2], aBotoes[nI][3],,,, aBotoes[nI][4] )
	Endif
Next nI

// Este botao nao podera ser alterado
oExplorer:AddDefButton( "CANCEL_OCEAN", STR0013, {|| Tk280Fim(oExplorer, aKey) },,,, STR0063 ) //"Encerra o Pr�-atendimento - (Alt F4)", "Cancelar"

// Define a funcao que sera executada no momento da troca dos panels
oExplorer:bChange := {|| Tk280Change(oExplorer, @aPanels, @aMemory, cOperador)}

//��������������������������������������������������������������������������Ŀ
//�Limpa a enchoice dos dados cadastrais do cliente para comecar a trabalhar �
//����������������������������������������������������������������������������
Tk280Memory("SA1", @aMemory, .F.)
nPos := Ascan(aPanels, {|x| x[2]=="FOBJ02"} )
aPanels[nPos][1]:Refresh()

//���������������������������������������������������������������Ŀ
//�Atualiza o status da tabela de atendentes IN/OUT para o Monitor�
//�����������������������������������������������������������������
TkGrvSUV(__cUserId, "PRE0")

oExplorer:Activate(.T.,{|| .T. })
lRet := .T.

Return(lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK280PreTLC�Autor  �Armando M. Tessaroli� Data �  12/05/03  ���
�������������������������������������������������������������������������͹��
���Desc.     �Direciona a criacao dos paineis que conterao as informacoes ���
���          �do pre atendimento.                                         ���
�������������������������������������������������������������������������͹��
���Parametros�oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �cOperador - Codigo do operador que esta trabalhando.        ���
���          �aPanels   - Todos objetos de todos paineis.                 ���
���          �aMemory   - Vaiaveis de memoria utilizada pelas MSMGET.     ���
���          �aRegras   - Contem as regras de selecao dos titulos de todos���
���          �            os operadores para validar qual titulo o opera- ���
���          �            dor corrente podera trabalhar.                  ���
�������������������������������������������������������������������������͹��
���Uso       �AP8                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TK280PreTLC(oExplorer,cOperador,aPanels,aMemory,aRegras)

//�����������������������������Ŀ
//�Pendencias Agendadas         �
//�		Ultimo Atendimento      �
//�		Titulos Negociados      �
//�		Previsao de Cobranca    �
//�                             �
//� Cobrancas de Hoje           �
//�		Novo Atendimento        �
//�		Pendencia Telemarketing �
//�		Pedido no Televendas    �
//�                             �
//�������������������������������

ProcRegua(8)

IncProc(STR0014) //"Pend�ncias Agendadas"
Tk280TLC01(oExplorer, oExplorer:AddTree(PadR(STR0014,150),"FOLDER5","FOLDER6",PadR("TMK001",20)),@aPanels,@aMemory,cOperador,aRegras) //"Pend�ncias Agendadas"
	IncProc(STR0015) //"�ltimo Atendimento"
	Tk280TLC02(oExplorer, oExplorer:AddItem(Padr(STR0015,150),"SHORTCUTEDIT", Padr("TMK002",20)),@aPanels,@aMemory) //"�ltimo Atendimento"
	IncProc(STR0016) //"T�tulos Negociados"
	Tk280TLC03(oExplorer, oExplorer:AddItem(Padr(STR0016,150),"SHORTCUTEDIT", Padr("TMK003",20)),@aPanels) //"T�tulos Negociados"
	IncProc(STR0017) //"Previs�o de Cobran�a"
	Tk280TLC04(oExplorer, oExplorer:AddItem(Padr(STR0017,150),"SHORTCUTEDIT", Padr("TMK004",20)),@aPanels) //"Previs�o de Cobran�a"
oExplorer:EndTree()

IncProc(STR0018) //"Cobran�as de Hoje"
Tk280TLC05(oExplorer, oExplorer:AddTree(Padr(STR0018,150),"FOLDER5","FOLDER6",Padr("TMK005",20)),@aPanels,@aMemory,cOperador) //"Cobran�as de Hoje"
	IncProc(STR0019) //"Novo Pr�-atendimento"
	Tk280TLC06(oExplorer, oExplorer:AddItem(Padr(STR0019,150),"SHORTCUTNEW", Padr("TMK006",20)),@aPanels,@aMemory) //"Novo Pr�-atendimento"
	IncProc(STR0020) //"Hist�rico Telemarketing"
	Tk280TLC07(oExplorer, oExplorer:AddItem(Padr(STR0020,150),"SHORTCUTNEW", Padr("TMK008",20)),@aPanels) //"Pend�ncia Telemarketing"
	IncProc(STR0021) //"Hist�rico Televendas"
	Tk280TLC08(oExplorer, oExplorer:AddItem(Padr(STR0021,150),"SHORTCUTNEW", Padr("TMK009",20)),@aPanels) //"Pedido no Televendas"
oExplorer:EndTree()

Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Change�Autor �Armando M. Tessaroli� Data �  08/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta funcao controla as acoes que devem ser realizadas quan-���
���          �do um painel e trocado no pre-atendimento.                  ���
�������������������������������������������������������������������������͹��
���Parametros�oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �aPanels   - Todos objetos de todos paineis.                 ���
���          �aMemory   - Vaiaveis de memoria utilizada pelas MSMGET.     ���
���          �cOperador - Codigo do operador que esta trabalhando.        ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function Tk280Change(oExplorer, aPanels, aMemory, cOperador)

Local oLbx		:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]	// Objeto com os itens da agenda do operador
Local nPosObj01 := 0	// Ponteiro de array
Local nPosObj02 := 0	// Ponteiro de array
Local nPCodigo	:= 0	// Ponteiro de array
Local nPos		:= 0	// Posicao do objeto no array.
Local nPTitulo	:= 0	// Posicao do campo numero do titulo no aCols.

//��������������������������������������������������������������������Ŀ
//�Atualiza o Painel com os dados do Cabecalho do Ultimo Atendimento   �
//����������������������������������������������������������������������
If oExplorer:nPanel == 2
	If !aPanels[Ascan(aPanels, {|x| x[2]=="BOBJ01"} )][3]
		aPanels[Ascan(aPanels, {|x| x[2]=="BOBJ01"} )][3] := .T.
		DbSelectArea("ACF")
		DbSetOrder(1)
		If MsSeek(xFilial("ACF") + oLbx:aArray[oLbx:nAt][7])
			Tk280Memory("ACF", @aMemory, .T.)
			aPanels[Ascan(aPanels, {|x| x[2]=="BOBJ01"} )][1]:Refresh()
		Else
			Tk280Memory("ACF", @aMemory, .F.)
			aPanels[Ascan(aPanels, {|x| x[2]=="BOBJ01"} )][1]:Refresh()
		Endif	
			
		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1") + oLbx:aArray[oLbx:nAt][2] + oLbx:aArray[oLbx:nAt][3])
		aPanels[Ascan(aPanels, {|x| x[2]=="BOBJ02"} )][1]:bSetGet := {|U| IF( PCOUNT() == 0, MSMM(SA1->A1_CODHIST), U )}
		aPanels[Ascan(aPanels, {|x| x[2]=="BOBJ02"} )][1]:Refresh()

	Endif
Endif


//��������������������������������������������������������������������Ŀ
//�Atualiza os dados do Painel com os Titulos que foram cobrados antes �
//����������������������������������������������������������������������
If oExplorer:nPanel == 3
	If !aPanels[Ascan(aPanels, {|x| x[2]=="COBJ01"} )][3]
		aPanels[Ascan(aPanels, {|x| x[2]=="COBJ01"} )][3] := .T.
		
		Tk280ACG(@aPanels[Ascan(aPanels, {|x| x[2]=="COBJ01"} )][1]:aHeader, @aPanels[Ascan(aPanels, {|x| x[2]=="COBJ01"} )][1]:aCols, @aPanels[Ascan(aPanels, {|x| x[2]=="COBJ02"} )][1], oLbx:aArray[oLbx:nAt][7])
		aPanels[Ascan(aPanels, {|x| x[2]=="COBJ01"} )][1]:Refresh()
	Endif
Endif


//��������������������������������������������������������������������Ŀ
//�Atualiza os dados do Painel com os Titulos vencidos apos a cobranca �
//����������������������������������������������������������������������
If oExplorer:nPanel == 4
	If !aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ01"} )][3]
		aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ01"} )][3] := .T.
		DbSelectArea("ACF")
		DbSetOrder(1)
		If MsSeek(xFilial("ACF") + oLbx:aArray[oLbx:nAt][7])
		
			Tk280SK1(@aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ01"} )][1]:aHeader, @aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ01"} )][1]:aCols, @aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ02"} )][1],,,.F., ACF->ACF_DATA)
			aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ01"} )][1]:Refresh()
		Endif	
	Endif
Endif


//��������������������������������������������������������������������Ŀ
//�Atualiza os dados do Painel dos Atendimento realizados no dia       �
//����������������������������������������������������������������������
If oExplorer:nPanel == 5
	nPosObj01	:= Ascan(aPanels, {|x| x[2]=="EOBJ01"} )
	nPosObj02	:= Ascan(aPanels, {|x| x[2]=="EOBJ02"} )
	nPCodigo	:= Ascan(aPanels[nPosObj01][1]:aHeader, {|x| AllTrim(x[2])=="ACF_CODIGO"} )
	
	If !aPanels[nPosObj01][3]
		aPanels[nPosObj01][3] := .T.
		
		Tk280ACF(@aPanels[nPosObj01][1]:aHeader, @aPanels[nPosObj01][1]:aCols, cOperador)
		aPanels[nPosObj01][1]:Refresh()
		
		If !Empty(aPanels[nPosObj01][1]:aCols[1][nPCodigo])
			Tk280ACG(@aPanels[nPosObj02][1]:aHeader, @aPanels[nPosObj02][1]:aCols,{},aPanels[nPosObj01][1]:aCols[1][nPCodigo])
			aPanels[nPosObj02][1]:Refresh()
		Endif
	Endif
Endif

//�������������������������������������������������������������������������Ŀ
//�Limpa os dados do panel Novo Pre-atendimento quando ele for selecionado. �
//���������������������������������������������������������������������������
If oExplorer:nPanel == 6
	//Verifica se NAO foi solicitado uma nova cobranca
	nPos		:= Ascan(aPanels, {|x| x[2]=="FOBJ04"} )		// Titulos a serem cobrados
	nPTitulo	:= Ascan(aPanels[nPos][1]:aHeader, {|x| AllTrim(x[2])=="E1_NUM"} )
	If (Len(aPanels[nPos][1]:aCols) == 0) .OR. (Len(aPanels[nPos][1]:aCols) > 0 .AND. Empty(aPanels[nPos][1]:aCols[1][nPTitulo]))
		//�������������������������������������������������������������������������������Ŀ
		//�Limpa as enchoices da tela Novo Pr�-atendimento que se atualiza automaticamente�
		//���������������������������������������������������������������������������������
		Tk280Memory("SA1", @aMemory, .F.)
		nPos := Ascan(aPanels, {|x| x[2]=="FOBJ02"} )
		aPanels[nPos][1]:Refresh()
			
		Tk280Memory("SU5", @aMemory, .F.)
		nPos := Ascan(aPanels, {|x| x[2]=="FOBJ03"} )
		aPanels[nPos][1]:Refresh()
	Endif
Endif


//��������������������������������������������������������������������Ŀ
//�Atualiza os dados do Painel de pendencias no Telemarketing          �
//����������������������������������������������������������������������
If oExplorer:nPanel == 7
	nPosObj01	:= Ascan(aPanels, {|x| x[2]=="GOBJ01"} )
	nPosObj02	:= Ascan(aPanels, {|x| x[2]=="GOBJ02"} )
	nPCodigo	:= Ascan(aPanels[nPosObj01][1]:aHeader, {|x| AllTrim(x[2])=="UC_CODIGO"} )
	
	If !aPanels[nPosObj01][3]
		aPanels[nPosObj01][3] := .T.
		
		Tk280SUC(@aPanels[nPosObj01][1]:aHeader, @aPanels[nPosObj01][1]:aCols, M->A1_COD + M->A1_LOJA)
		aPanels[nPosObj01][1]:Refresh()
		
		If !Empty(aPanels[nPosObj01][1]:aCols[1][nPCodigo])
			Tk280SUD(@aPanels[nPosObj02][1]:aHeader, @aPanels[nPosObj02][1]:aCols, aPanels[nPosObj01][1]:aCols[1][nPCodigo])
			aPanels[nPosObj02][1]:Refresh()
		Endif
	Endif
Endif


//��������������������������������������������������������������������Ŀ
//�Atualiza os dados do Painel de pendencias no Televendas             �
//����������������������������������������������������������������������
If oExplorer:nPanel == 8
	nPosObj01	:= Ascan(aPanels, {|x| x[2]=="HOBJ01"} )
	nPosObj02	:= Ascan(aPanels, {|x| x[2]=="HOBJ02"} )
	nPCodigo	:= Ascan(aPanels[nPosObj01][1]:aHeader, {|x| AllTrim(x[2])=="UA_NUM"} )
	
	If !aPanels[nPosObj01][3]
		aPanels[nPosObj01][3] := .T.
		
		Tk280SUA(@aPanels[nPosObj01][1]:aHeader, @aPanels[nPosObj01][1]:aCols, M->A1_COD, M->A1_LOJA)
		aPanels[nPosObj01][1]:Refresh()
		
		If !Empty(aPanels[nPosObj01][1]:aCols[1][nPCodigo])
			Tk280SUB(@aPanels[nPosObj02][1]:aHeader, @aPanels[nPosObj02][1]:aCols, aPanels[nPosObj01][1]:aCols[1][nPCodigo])
			aPanels[nPosObj02][1]:Refresh()
		Endif
	Endif
Endif

Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK280Financ�Autor �Armando M. Tessaroli� Data �  07/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza uma consulta financeira disponibilizada pelo modulo ���
���          �financeiro.                                                 ���
�������������������������������������������������������������������������͹��
���Parametros�cTipo     - Tipo da consulta financeira que sera realizada. ���
���          �oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �aPanels   - Todos objetos de todos paineis.                 ���
���          �aMemory   - Vaiaveis de memoria utilizada pelas MSMGET.     ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TK280Financ(cTipo, oExplorer, aPanels, aMemory)

Local cCliente	:= ""		// Codigo do cliente
Local cLoja		:= ""		// Loja do cliente
Local nPCliente	:= 0		// Posicao de array
Local nPLoja	:= 0		// Posicao de array
Local oLbx		:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]		// Objeto com dados da agenda
Local oNGD		:= aPanels[Ascan(aPanels, {|x| x[2]=="EOBJ01"} )][1]		// GetDados local

//�������������������������������������������������������������������
//�Pega o cliente do folder relacionado e posiciona na base de dados�
//�������������������������������������������������������������������
If Str(oExplorer:nPanel,1) $ "1234"
	cCliente	:= Eval(oLbx:bLine)[2]
	cLoja		:= Eval(oLbx:bLine)[3]
Endif

If oExplorer:nPanel == 5
	nPCliente	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACF_CLIENT"} )
	nPLoja		:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACF_LOJA"} )
	cCliente	:= oNGD:aCols[oNGD:nAt][nPCliente]
	cLoja		:= oNGD:aCols[oNGD:nAt][nPLoja]
Endif

If Str(oExplorer:nPanel,1) $ "678"
	cCliente	:= M->A1_COD
	cLoja		:= M->A1_LOJA
Endif

If !Empty(cCliente) .AND. !Empty(cLoja)
	DbSelectarea("SA1")
	DbSetOrder(1)
	If !MsSeek(xFilial("SA1") + cCliente + cLoja)
		Help("  ",1,"TK280CLIEN")//"N�o h� nenhum cliente dispon�vel para realizar essa operacao no painel selecionado, no momento"
		Return(.F.)
	Endif
	
	Do Case
		Case cTipo == "010"
			Fc010Con("SA1",SA1->(Recno()),2)
		
		Case cTipo == "040"
			Fc040Con()
	Endcase
Else
	Help("  ",1,"TK280CLIEN")//"N�o h� nenhum cliente dispon�vel para realizar essa operacao no painel selecionado, no momento"
Endif
	
Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Refresh�Autor�Armando M. Tessaroli� Data �  09/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que atualiza os dados dos paineis.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�aPanels   - Todos objetos de todos paineis.                 ���
���          �cOperador - Codigo do operador que esta trabalhando.        ���
���          �oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �lForce    - Quando o refresh e disparado pelo sistema e deve���
���          �            ser forcado, mesmo com foco em outro painel.    ���
���          �aMemory   - Vaiaveis de memoria utilizada pelas MSMGET.     ���
���          �aRegras   - Contem as regras de selecao dos titulos de todos���
���          �            os operadores para validar qual titulo o opera- ���
���          �            dor corrente podera trabalhar.                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk280Refresh(aPanels, cOperador, oExplorer, lForce, aMemory, aRegras)

Local oLbx		:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]	// Objeto com as pendencias da agendoa do operador
Local oFollow	:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ02"} )][1]	// Objeto painel com os dados de follow-up
Local aAgenda	:= {}													// Conteudo da agenda do operador.
Local cAtend	:= ""													// Codigo do atendimento.

Default lForce	:= .F.

If oExplorer:nPanel <> 1 .AND. !lForce
	Return(.F.)
Endif

cAtend := oLbx:aArray[oLbx:nAt][7]

Tk280SU4(@aAgenda,cOperador, aRegras)
oLbx:SetArray(aAgenda)
oLbx:bLine:={||{	aAgenda[oLbx:nAt,1],;
					aAgenda[oLbx:nAt,2],;
					aAgenda[oLbx:nAt,3],;
					aAgenda[oLbx:nAt,4],;
					aAgenda[oLbx:nAt,5],;
					aAgenda[oLbx:nAt,6],;
					aAgenda[oLbx:nAt,7],;
					aAgenda[oLbx:nAt,8],;
					aAgenda[oLbx:nAt,9],;
					aAgenda[oLbx:nAt,10],;
					aAgenda[oLbx:nAt,11],;
					aAgenda[oLbx:nAt,12];
				}}
oLbx:nAt := 1
oLbx:Refresh()

// Se o refresh posicionou em outro atendimento, os panels abaixo deverao ser recriados
If cAtend <> oLbx:aArray[oLbx:nAt][7]
	aPanels[Ascan(aPanels, {|x| x[2]=="BOBJ01"} )][3] := .F.
	aPanels[Ascan(aPanels, {|x| x[2]=="COBJ01"} )][3] := .F.
	aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ01"} )][3] := .F.
Endif

//���������������������������������������������������������
//�Realiza um refresh no painel com data e hora de retorno�
//���������������������������������������������������������
//oFollow:cCaption	:= {||Tk280Follow(aFollow,Eval(oLbx:bLine)[5],Eval(oLbx:bLine)[11],oExplorer:GetPanel(nPanel))}
//oFollow:Refresh()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Novo �Autor  �Armando M. Tessaroli� Data �  04/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que busca os titulos e o cliente para um operador rea���
���          �lizar uma nova cobranca.                                    ���
�������������������������������������������������������������������������͹��
���Parametros�oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �cOperador - Codigo do operador que esta trabalhando.        ���
���          �aRegras   - Contem as regras de selecao dos titulos de todos���
���          �            os operadores para validar qual titulo o opera- ���
���          �            dor corrente podera trabalhar.                  ���
���          �aPanels   - Todos objetos de todos paineis.                 ���
���          �aMemory   - Variaveis de memoria utilizada pelas MSMGET.    ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������ĺ��
���Andrea F. �08/04/04�811   �- Priorizar o contato que possuir o  campo  ���
���          �        �      �U5_TIPO (Atendimento) preenchido para carre ���
���          �        �      �gar em um novo atendimento.                 ���
���Marcelo K.�02/02/05�8.11  �- Ajuste da selecado de novos titulos para  ���
���          �        �      �o Operador para evitar concorrencia.        ���
���          �        �      �- Adequacao da logica e sintaxe.            ���
���Andrea F. �07/03/05�8.11  �- Incluido ponto de entrada TK280SU5 para   ���
���          �        �      �substituir a pesquisa padrao do contato.    ���
���Andrea F. �05/07/05�8.11  �- BOPS 83837 - Criado funcao Tk280Num para  ���
���          �        �      �controle da  numeracao das listas.          ���
���Andrea F. �06/07/05�8.11  �- BOPS 83837 - Ajuste na selecao de novos   ���
���          �        �      �titulos para cobranca. Filtrar apenas os    ���
���          �        �      �titulos que nao possuem cobrador.           ���
���Andrea F. �07/07/05�8.11  �- BOPS 83837 - Incluido ponto de entrada    ���
���          �        �      �TkSeqLista para retornar o numero sequencial���
���          �        �      �das listas.							      ���
���Andrea F. �12/07/05�8.11  �- BOPS 83837 - Validar a faixa de cobranca  ���
���          �        �      �do cobrador de acordo com os titulos que    ���
���          �        �      �foram solicitados para cobranca.            ���
���Andrea F. �22/09/05�8.11  �Della Via - Criado parametro MV_TMKREGF para���
���          �        �      �permitir que o filtro dos campos da regra de���
���          �        �      �selecao seja feito como "contido".          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk280Novo(oExplorer, cOperador, aRegras, aPanels, aMemory)

Local nPos			:= 0													// Posicao do array
Local dIni			:= CtoD("//")											// Vencimento inicial dos titulos a cobrar
Local dFim			:= CtoD("//")											// Vencimento final dos titulos a cobrar
Local cOrdem		:= ""													// Ordem de prioridade dos grupos de atendimento
Local aOperad		:= {}													// Codigo e ordem dos Operadores cadastrados
Local cCliente		:= ""													// Codigo do cliente que sera selecionado para a proxima cobranca
Local cLoja			:= ""													// Loja do cliente do que sera selecionado para a proxima cobranca
Local cCliAux		:= ""													// Codigo do cliente auxiliar para avaliacao se pode ser cobrado ou nao
Local cLojAux		:= ""													// Loja do cliente auxiliar para avaliacao se pode ser cobrado ou nao
Local oLbx			:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]	// Agenda do operador
Local nI			:= 0													// Controle de laco
Local lNovo			:= .T.													// Define se o atendimetno e novo ou esta na agenda sem ligacao
Local oNGD			:= aPanels[Ascan(aPanels, {|x| x[2]=="FOBJ04"} )][1]	// Titulos que deverao ser cobrados
Local cSK1			:= "SK1"												// Alias temporario so SK1
Local cTpContat 	:= ""													// Tipo de contato 1- SAC, 2-VENDAS, 3- COBRANCA
Local cTpTel		:= GetNewPar("MV_TMKTPTE","4") 							// Tipo de telefone para geracao da pendencia de novo pre-atendimento. Se nao existir assume como padrao o Comercial1
Local lSelVal		:= GetNewPar("MV_TMKSELV",.F.)							// Indica se na solicitacao de novo pre-atendimento o sistema ira priorizar os titulos mais antigos de maior valor 
Local lRet			:= .F.													// Flag de retorno da funcao
Local nAuxLen 		:= 0	 	 											// Variavel auxiliar para ser usado com FOR - aumento de performance
Local aArea			:= {}													// Salva a area utilizada
Local cLista		:= ""													// Pendencia criada de solicitacao novo-pre atendimento
Local cContato		:= ""													// Codigo do contato para a pendencia de novo-pre atendimento
Local nLidos		:= 0                                                    // Numero de registros lidos no SK1
Local nGravados		:= 0                                                    // Numero de registros gravados com o codigo do operador no SK1
Local cPathLog		:= GetNewPar("MV_TMKDILG","")							// Indica o diretorio onde sera gravado o arquivo de log
Local cArqLog		:= ""													// Arquivo de log para controlar o cliente e loja solicitado em um novo pre-atendimento
Local nErase		:= -1												// Controla a delecao do arquivo
Local nHandle		:= 0                                                    // Controle de criacao do arquivo de log
Local lApaga		:= .F.													// Controle para permitir ou nao a delecao do arquivo
Local lTk280SU5		:= FindFunction("U_TK280SU5")							// Ponto de entrada para substituir a pesquisa do contato relacionado ao cliente na solicita��o de novo pr�-atendimento
Local cNumSU4  		:= ""													// Numero sequencial do cabecalho da lista 
Local cNumSU6   	:= ""													// Numero sequencial do item da lista
Local cMay      	:= "" 													// Variavel de controle
Local lTkSeqLista 	:= FindFunction("U_TKSeqLista")    						// Indica se a numeracao sequencial das listas (SU4-SU6) Serao geradas por funcao customizada	            
Local lForaFaixa	:= .F. 													// Indica se algum titulo da condicao para cobrar a conta que foi solicitada para o operador 
Local lCobraCli     := .F.                                                 	// Indica se o operador possui pelo menos um titulo dentro da sua faixa e pode cobrar o operador
Local nSK1			:= 0													// Numeros de titulos processados no SK1
Local nSE1			:= 0													// Numeros de titulos processados no SE1
Local cFilOrig		:= ""													// Filial de origem dos titulos
Local cPrefixo 		:= ""                      								// Prefixo do titulo da regra de selecao
Local cNaturez 		:= ""													// Natureza do titulo da regra de selecao
Local cPortado 		:= ""													// Portador do titulo da regra de selecao
Local cSituaca 		:= ""													// Situacao do titulo da regra de selecao
Local lLimpa		:= .F.													// Flag para controle de variavel
Local lRegSelFlex	:= GetNewPar("MV_TMKREGF",.F.)							// Deixa os campos da regra de selecao flexivel para filtrar a informacao que estiver contida nos campos e nao exatamente igual ao conteudo informado

#IFDEF TOP
	Local cQuery	:= ""													// Query de pesquisa no banco de dados
	Local aStruct	:= SK1->(DbStruct())									// Estrutura da tabela SK1
#ENDIF

//���������������������������������������������������������������������Ŀ
//�Avalia se o usuario esta posicionado no folder de "NOVO ATENIDIMENTO"�
//�����������������������������������������������������������������������
If oExplorer:nPanel <> 6
	//"Para solicitar uma nova cobran�a � necess�rio estar posicionado no painel Novo pr�-atendimento."
	Help("  ",1,"TK280NOVO")
	Return(lRet)
Endif

//������������������������������������������������������Ŀ
//�Valida de existem follow-ups pendentes para o Operador�
//��������������������������������������������������������
If Len(oNGD:aCols) > 0
	nPTitulo := Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_NUM"} )
	If !Empty(oNGD:aCols[1][nPTitulo])
		//"Antes de solicitar um Novo Pr�-atendimento, � necessario concluir a solicita��o que est� 
		// pendente no painel Novo Pr�-atendimento"
		Help("  ",1,"TK280NOVO2") 
		Return(lRet)
	Endif
Endif
                                                  
//�������������������������������������������������Ŀ
//�Se tiver lista pra executar, nao pega Titulo novo�
//���������������������������������������������������
If Tk280Lista(cOperador)
	//"Existe uma lista de cobran�a pendente para ser executada antes de solicitar uma nova cobran�a"
	Help("  ",1,"TK280LISTA")
	
	//�������������������������������������������������������������������������������Ŀ
	//�Limpa as enchoices da tela Novo Pr�-atendimento que se atualiza automaticamente�
	//���������������������������������������������������������������������������������
	Tk280Memory("SA1", @aMemory, .T.)
	nPos := Ascan(aPanels, {|x| x[2]=="FOBJ02"} )
	If nPos > 0
		aPanels[nPos][1]:Refresh()
	Endif	
		
	Tk280Memory("SU5", @aMemory, .T.)
	nPos := Ascan(aPanels, {|x| x[2]=="FOBJ03"} )
	If nPos > 0 
		aPanels[nPos][1]:Refresh()
	Endif	
	
	Return(lRet)
Endif

//����������������������������������������Ŀ
//�Se tiver pendencia, nao pega titulo novo�
//������������������������������������������
Tk280Refresh(	@aPanels	, cOperador	, oExplorer, .T., ;
				@aMemory	, aRegras) 

nAuxLen := Len(oLbx:aArray)				
For nI := 1 To nAuxLen
	// 7=Atendimento, 8=Data, 9=Hora, 10=Status          
		
	//��������������������������������������������������������������Ŀ
	//�Se for um follow-up e estiver com o Status (SU4) igual a ATIVO�
	//����������������������������������������������������������������
	If !Empty(oLbx:aArray[nI][7]) .AND. oLbx:aArray[nI][10] == "1"
		//Se a pendencia nao esta atrasada, pode pegar novo atendimento
		If oLbx:aArray[nI][8] <> dDataBase .OR. oLbx:aArray[nI][9] <= SubStr(Time(),1,5) 

			//"Voce tem pendencia a ser cumprida na sua agenda e nao pode solicitar uma nova cobranca" 
			Help("  ",1,"TK280PEND")
			Return(lRet)
			
		Endif
	Endif
Next nI

//����������������������������������������������������������������������Ŀ
//�Ao solicitar uma nova cobranca (Nova Solicitacao Telecobranca), se o  �
//�operador ja possuir na agenda uma solicitacao que nao tenha sido      �
//�executada, (U6_CODLIG em branco) nao disponibiliza nova conta,        �
//�e executa ela primeiro.												 �
//������������������������������������������������������������������������
// 2=Cliente, 7=Atendimento, 8=Data, 9=Hora, 10=Status
nPos := Ascan(oLbx:aArray, {|x| AllTrim(x[7])=="" .AND. x[10] == "1"})	// Pesquisa pendencia sem atendimento e com status de aberto
If nPos > 0 .AND. !Empty(oLbx:aArray[nPos][2]) .AND. oLbx:aArray[nPos][10] == "1"
	If oLbx:aArray[nPos][8] <> dDataBase .OR. oLbx:aArray[nPos][9] <= SubStr(Time(),1,5)
		cCliente	:= oLbx:aArray[nPos][2]
		cLoja		:= oLbx:aArray[nPos][3]
		lNovo		:= .F.
	Endif
Endif


//�������������������������������Ŀ
//�Muda o cursor no processamento �
//���������������������������������
CursorWait()


//�����������������������������������������������Ŀ
//�Se o operador pode pegar um novo titulo vencido�
//�������������������������������������������������
If lNovo

	//�������������������������������������������Ŀ
	//�Busca a regra de selecao do operador logado�
	//���������������������������������������������
	DbSelectArea("SU7")
	DbSetOrder(1)
	If MsSeek(xFilial("SU7") + cOperador)
	
		DbSelectArea("SU0")
		DbSetOrder(1)
		If MsSeek(xFilial("SU0") + SU7->U7_POSTO)

			DbSelectArea("SK0")
			DbSetOrder(1)
			If MsSeek(xFilial("SK0") + SU0->U0_REGSEL)
				nPos	:= Ascan(aRegras, {|x| x[1] == SU0->U0_REGSEL })
				lRet	:= .T.	
			Endif
		Endif
	Endif
	
	//�����������������������������������������������������������������������������������������������������������Ŀ
	//�Se nao encontrou o operador, o grupo e a regra - ou se a regra nao foi cadastrada - sai da rotina de busca �
	//�������������������������������������������������������������������������������������������������������������
	If (!lRet) .OR. (nPos <= 0)
		lRet := .F.
		MsgStop("O operador, o grupo de atendimento ou a regra de sele��o desse usu�rio n�o foi localizado no sistema, contacte o Supervisor","Aten��o")  
		Return(lRet)
	Endif	
	
	//��������������������������������������������������������������������������������
	//�Se encontrou a Regra de Selecao do usuario pega os dados da regra do operador �
	//��������������������������������������������������������������������������������
	If nPos > 0
		dIni		:= dDataBase - aRegras[nPos][3]		// -----60---------30--------Hoje----
		dFim		:= dDataBase - aRegras[nPos][2]		//      dIni       dFim      dDataBase
		cOrdem		:= SK0->K0_ORDEM
		cPrefixo	:= SK0->K0_PREFIXO
		cNaturez	:= SK0->K0_NATUREZ
		cPortado	:= SK0->K0_PORTADO
		cSituaca	:= SK0->K0_SITUACA
	Endif

	//�������������������������������������������������������������������������������Ŀ
	//�Se o parametro (de selecao de titulo de maior valor) estiver ligado o sistema  �	
	//�troca  a chave de indice para fazer a selecao do proximo titulo inadimplemente �
	//���������������������������������������������������������������������������������
	DbSelectArea("SK1")
	DbSetOrder(2)		// DTOS(K1_VENCREA)+K1_CLIENTE+K1_LOJA
	If lSelVal
		If Tk280Dic()//Verifica se o indice para ordenar o SK1 foi criado
			DbSelectArea("SK1")
			DbSetOrder(5)		// DTOS(K1_VENCREA)+STR(K1_SALDEC,17,0)+K1_CLIENTE+K1_LOJA
	    Else
	    	MsgStop("O parametro MV_TMKSELV esta habilitado para buscar os titulos mais antigos de maior valor na solicitacao de novo pre-atendimento, mas o dicionario de dados nao foi ajustado. Entre em contato com o administrador do sistema.","Aten��o")
	    	Final("Ajustar dicionario de dados")
	    Endif
	Endif
		    
	#IFDEF TOP
		cSK1	:= "TMPSK1"				// Alias temporario do SK1
		cQuery	:=	" SELECT	* " +;
					" FROM " +	RetSqlName("SK1") + " SK1 " +;
					" WHERE	SK1.K1_FILIAL = '" + xFilial("SK1") + "' AND" +;
					"		SK1.K1_VENCREA BETWEEN '" + DtoS(dIni) + "' AND '" + DtoS(dFim) + "' AND"
		
		If !Empty(cPrefixo) 
			If !lRegSelFlex
				cQuery += " SK1.K1_PREFIXO = '" + cPrefixo + "' AND"
			Else
				cQuery += " SK1.K1_PREFIXO LIKE ('%" + Alltrim(cPrefixo) + "%') AND"			
			Endif
		Endif
		
		If !Empty(cNaturez)
			If !lRegSelFlex
				cQuery += " SK1.K1_NATUREZ = '" + cNaturez + "' AND"
			Else
				cQuery += " SK1.K1_NATUREZ LIKE ('%" + Alltrim(cNaturez) + "%') AND"
			Endif	
		Endif
		
		If !Empty(cPortado)
			If !lRegSelFlex
				cQuery += " SK1.K1_PORTADO = '" + cPortado + "' AND"
			Else
				cQuery += " SK1.K1_PORTADO LIKE ('%" + Alltrim(cPortado) + "%') AND"
			Endif	
		Endif
		
		If !Empty(cSituaca) .AND. (cSituaca <> "7")		// Todos
			cQuery += " SK1.K1_SITUACA = '" + cSituaca + "' AND"
		Endif
		
		// Desconsidera os titulos marcados para nao serem cobrados.
		cQuery += " SK1.K1_OPERAD <> 'XXXXXX' AND"
		
		//�������������������������������������������������������������������������Ŀ
		//�Procura titulo novo apenas para os titulos que ainda nao foram cobrados. �
		//�Se a ligacao nao foi realizada ao pedir um novo nao vai passar aqui.     �
		//���������������������������������������������������������������������������
		cQuery += 	" SK1.K1_OPERAD 	= '      ' AND "
		cQuery += 	" SK1.D_E_L_E_T_ 	= ' '	" 		+;
					" ORDER BY " + SqlOrder(IndexKey())
		
		cQuery	:= ChangeQuery(cQuery)
		MemoWrite("TK280Novo.SQL", cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cSK1, .F., .T.)
	
		For nI := 1 To Len(aStruct)
			If aStruct[nI][2] $ "NDL"
				TCSetField(cSK1, aStruct[nI][1], aStruct[nI][2], aStruct[nI][3], aStruct[nI][4])
			Endif
		Next nI
	#ELSE
		MsSeek(xFilial("SK1")+DtoS(dIni), .T.)
	#ENDIF

	//������������������������������������������������������������������������������������������������������������������������Ŀ
	//�Varre os titulos selecionados do SK1 para verificar se estao dentro da regra e qual deles pode ser atribuido ao operador�
	//��������������������������������������������������������������������������������������������������������������������������
	While	!Eof()									.AND.;
			(cSK1)->K1_FILIAL == xFilial("SK1")		.AND.;
			(cSK1)->K1_VENCREA >= dIni				.AND.;
			(cSK1)->K1_VENCREA <= dFim
		
		#IFNDEF TOP
			//������������������������������������������Ŀ
			//�Se for CODEBASE valida a selecao do titulo�
			//��������������������������������������������

			// Nao carrega titulos com marcas de excecao de cobranca
			If (cSK1)->K1_OPERAD == "XXXXXX"
				DbSelectArea(cSK1)
				DbSkip()
				Loop
			Endif

			If ( !Empty(cPrefixo) ) .AND. ( (cSK1)->K1_PREFIXO <> cPrefixo )
				DbSelectArea(cSK1)
				DbSkip()
				Loop
			Endif
			
			If ( !Empty(cNaturez) ) .AND. ( (cSK1)->K1_NATUREZ <> cNaturez )
				DbSelectArea(cSK1)
				DbSkip()
				Loop
			Endif
			
			If ( !Empty(cPortado) ) .AND. ( (cSK1)->K1_PORTADO <> cPortado )
				DbSelectArea(cSK1)
				DbSkip()
				Loop
			Endif
			
			If ( !Empty(cSituaca) ) .AND. ( cSituaca <> "7" ) .AND. ( (cSK1)->K1_SITUACA <> cSituaca )
				DbSelectArea(cSK1)
				DbSkip()
				Loop
			Endif
			
			// Nao procura titulo novo se o titulo ja estiver registrado para este ou qualquer outro operador
			If ( !Empty((cSK1)->K1_OPERAD) ) .OR. ( (cSK1)->K1_OPERAD == cOperador )
				DbSelectArea(cSK1)
				DbSkip()
				Loop
			Endif
		#ENDIF
		
		//��������������������������������������������������������������������Ŀ
		//�Salva a area atual                                                  �
		//����������������������������������������������������������������������
		#IFNDEF TOP
			aArea := GetArea()					// Controle diferente para DBF por que nao utiliza arquivo temporario
		#ENDIF  

		If cCliAux == (cSK1)->K1_CLIENTE .AND. cLojAux == (cSK1)->K1_LOJA
			DbSelectArea(cSK1)
			DbSkip()
			Loop
		Else
			//��������������������������������������������������������������������Ŀ
			//�Seta um cliente pre-selecionado para validacao                      �
			//����������������������������������������������������������������������
			cCliAux	:= (cSK1)->K1_CLIENTE		
			cLojAux	:= (cSK1)->K1_LOJA			
		Endif
		
		//�������������������������������������������������������������������������������������������Ŀ
		//�Pesquisa no SK1 se todos os titulos desse cliente satisfazem a regra de selecao do operador�
		//���������������������������������������������������������������������������������������������
		DbSelectArea("SK1")
		DbSetOrder(4)		// K1_FILIAL+K1_CLIENTE+K1_LOJA+DTOS(K1_VENCREA)
		If MsSeek(xFilial("SK1") + cCliAux + cLojAux)
			cCliente	:= SK1->K1_CLIENTE
			cLoja		:= SK1->K1_LOJA
			lLimpa 		:= .F.
			
			//Verificar se ja existe o arquivo fisico para esse codigo de cliente.
			If !File(cPathLog + cCliente+cLoja+".COB") 

				While !Eof()						.AND.;
					SK1->K1_CLIENTE == cCliAux		.AND.;
					SK1->K1_LOJA   	== cLojAux  	.AND.;
	                SK1->K1_FILIAL 	== xFilial("SK1")
					                                          
					nSK1 ++
					
					// Existe algum titulo com data menor que a data inicial de cobranca
					If SK1->K1_VENCREA < dIni 
						lLimpa := .T.
						Exit
					Endif
					
					//Nao pode pegar titulo se ja existir alguem cobrando
					If !Empty(SK1->K1_OPERAD)
						lLimpa := .T.
						Exit
					Endif
													
					//������������������������������������������������������������������������������������Ŀ
					//�Verifica se os titulos do cadastro de referencia de titulos - SK1 - ja estao pagos. �
					//��������������������������������������������������������������������������������������
					If SK1->(FieldPos("K1_FILORIG") > 0)
						cFilOrig	:= SK1->K1_FILORIG
					Else	
						cFilOrig	:= xFilial("SE1")	
					Endif	
		
					DbSelectarea("SE1")
					DbSetOrder(1)
					If MsSeek(cFilOrig + SK1->K1_PREFIXO + SK1->K1_NUM + SK1->K1_PARCELA + SK1->K1_TIPO)
	
						If SE1->E1_SALDO <= 0
		                	nSE1 ++
						Else
							//�����������������������������������������������������������������������������Ŀ
							//�Se todos os titulos da condicao para o operador, pode pegar essa conta.      �
							//�A regra adotada segue o exemplo abaixo:		                                �
							//�Vencimento Real Maior (>) que dIni e Vencimento Real (<) Menor que dFim.     �
							//�-------|-------------------------|-----------|                               �
							//�		 90DD ( Vencimento Real )  30DD        Hoje                             �
							//�������������������������������������������������������������������������������
							//Se o titulo nao esta pago, verifica se o titulo da condicao para o operador cobrar
							If !lForaFaixa  
								If SK1->K1_VENCREA > dFim	
									If !lCobraCli
										lForaFaixa:= .T.  //Esse titulo esta fora da faixa, nao pode pegar essa conta.
									Endif	
								Else
									lCobraCli := .T.	
								Endif
							Endif
							
						Endif
		            Endif
		            	
					DbSelectArea("SK1")
					DbSkip()
				End
	        
	        Else
	        	lLimpa:= .T.
	        Endif
	        	   
			//��������������������������������������������������������������������������Ŀ
			//�Se o cliente nao atende as especificicacoes desse operador para a cobranca�
			//����������������������������������������������������������������������������
			If lLimpa 
				cCliente := ""
				cLoja	 := ""
			Endif	

			//����������������������������������������������������������������Ŀ
			//�Todos os titulos estao pagos, ou nao existem titulos que estejam� 
			//�na faixa do operador nao carrega essa conta para cobranca.	   �
			//������������������������������������������������������������������
			If (nSK1 == nSE1) .OR. (lForaFaixa)
				cCliente:= ""
				cLoja	:= ""
			Endif
				
		Endif
		
		nSK1		:= 0
		nSE1		:= 0
		lForaFaixa	:= .F.
		lCobraCli	:= .F.	
		
		#IFNDEF TOP
			RestArea(aArea)
		#ENDIF
		
		If !Empty(cCliente) 
			//�������������������������������������������������������������Ŀ
			//�Chegou neste ponto! O Cliente sera cobrado por este Operador.�
			//���������������������������������������������������������������
			Exit
		Endif
		
		DbSelectArea(cSK1)
		DbSkip()
	End
	
	#IFDEF TOP
		DbSelectArea(cSK1)
		DbCloseArea()
	#ENDIF 
	
	//��������������������������������������������������Ŀ
	//�Inicializa novamente a variavel apos as validacoes�
	//����������������������������������������������������
	lRet := .F.   
	
	//�����������������������������������������������������������������������������������������Ŀ
	//�A gravacao do operador no SK1 esta sendo realizada antes de gerar a pendencia para evitar�
	//�que mais de um Operador cobre o mesmo cliente.                                           �
	//�������������������������������������������������������������������������������������������
	If !Empty(cCliente) .AND. !Empty(cLoja)
	
		cArqLog := TRIM(cCliente) + TRIM(cLoja) + ".COB"
		
		//��������������������������������������������������������������������������������������������������Ŀ
		//�Ninguem pode solicitar nova cobranca enquanto o arquivo de log existir para o mesmo cliente e loja�
		//����������������������������������������������������������������������������������������������������
		If File(cPathLog + cArqLog) 
			MsgStop("Por favor, selecione novamente um novo pr�-atendimento pois o cliente " + cCliente + " - " + cLoja + " j� esta em cobran�a.","Aten��o")
			Conout(">>>> TK280NOVO -  1 "+"Por favor, selecione novamente um novo pr�-atendimento - O cliente : " + cCliente + " - " + cLoja + " ja esta em cobran�a.") 

			//�������������������������������������
			//�Volta o cursor apos o processamento�
			//�������������������������������������
			CursorArrow()
			Return(lRet)
    	Endif
		
		//����������������������������������������������������������������Ŀ
		//�Tentar criar um arquivo e valida o resultado < que 0 = insucesso�
		//������������������������������������������������������������������
		nHandle := FCREATE(cPathLog+cArqLog,1)
		If nHandle < 0
			MsgStop("Por favor, selecione novamente um novo pr�-atendimento","Aten��o")
			Conout(">>>> TK280NOVO -  2 "+"Por favor, selecione novamente um novo pr�-atendimento, NAO FOI POSSIVEL CRIAR O ARQUIVO DE LOG")  

			//�������������������������������������
			//�Volta o cursor apos o processamento�
			//�������������������������������������
			CursorArrow()
			Return(lRet)
		Endif	
		
		//�����������������������������������������������������������������������������Ŀ
		//�Fecha a criacao do arquivo e habilita o flag para apagar no final do processo�
		//�������������������������������������������������������������������������������
		lApaga := .T.
		FWrite( nHandle, cOperador )
		FClose( nHandle )

		//������������������������������������������������������������������������������������������������������������Ŀ
		//�Uma vez que o titulo sera atribuido ao operador atualiza o SK1 com essa informacao - para os outros titulos �
		//��������������������������������������������������������������������������������������������������������������
		DbSelectArea("SK1")
		DbSetOrder(4)		// K1_FILIAL+K1_CLIENTE+K1_LOJA+DTOS(K1_VENCREA)
		If MsSeek(xFilial("SK1") + cCliente + cLoja)
		
			BEGIN TRANSACTION

				nLidos    := 0 
				nGravados := 0 
				
				While	!Eof()							.AND.;
					SK1->K1_FILIAL 	== xFilial("SK1")	.AND.;
					SK1->K1_CLIENTE == cCliente			.AND.;
					SK1->K1_LOJA 	== cLoja

		            nLidos ++
		                
	                Reclock("SK1",.F.)
					SK1->K1_OPERAD := cOperador
					MsUnLock()
					DbCommit()

					nGravados ++
														
					Dbselectarea("SK1")
					Dbskip()								
				End                 
					
				//�����������������������������������������������������������������������������������������������������������������Ŀ
				//�Se para todos os registros lidos no SK1 foi gravado o codigo do operador gera a pendencia de novo pre-atendimento�
				//�������������������������������������������������������������������������������������������������������������������
				If nLidos == nGravados

					//�����������������������������������Ŀ
					//�Busca o proximo numero para a lista�
					//�������������������������������������
					DbSelectArea("SU4")
					If lTkSeqLista  
						//�����������������������������������������������������������������������������Ŀ
						//�Executa um P.E. para atualizar o semaforo por rdmake - exclusivo para DADALTO�
						//�������������������������������������������������������������������������������
						cNumSU4:= U_TkSeqLista("SU4","U4_LISTA")
					Else
						cNumSU4:= Tk280Num("SU4","U4_LISTA")
					Endif		
										
					RecLock("SU4", .T.)
					SU4->U4_FILIAL	:= xFilial("SU4")
					SU4->U4_LISTA	:= cNumSU4
					SU4->U4_DESC	:= STR0022 //"NOVO PRE-ATENDIMENTO TELECOBRANCA"
					SU4->U4_DATA	:= dDataBase
					SU4->U4_TIPO	:= "2"		//Cobranca
					SU4->U4_FORMA	:= "5"		//Pendencia
					SU4->U4_TELE	:= "3"		//Telecobranca
					SU4->U4_OPERAD	:= cOperador
					SU4->U4_TIPOTEL	:= cTpTel	//Tipo de Telefone para geracao da pendencia. 
					SU4->U4_STATUS	:= "1"		//Ativa
					MsUnLock()
		            
		            cLista := cNumSU4
		            
					//�����������������������������������Ŀ
					//�Busca o proximo numero para a lista�
					//�������������������������������������
					DbSelectArea("SU6")
					
					If lTkSeqLista                                            			
						cNumSU6:= U_TkSeqLista("SU6","U6_CODIGO")
					Else
						cNumSU6:= Tk280Num("SU6","U6_CODIGO") 
					Endif
							            
					RecLock("SU6", .T.)
					SU6->U6_FILIAL	:= xFilial("SU6")
					SU6->U6_LISTA	:= cLista
					SU6->U6_CODIGO	:= cNumSU6
					SU6->U6_FILENT	:= xFilial("SA1")
					SU6->U6_ENTIDA	:= "SA1"
					SU6->U6_CODENT	:= TRIM(cCliente) + TRIM(cLoja)
					SU6->U6_ORIGEM	:= "3"
					SU6->U6_DATA	:= dDataBase
					SU6->U6_HRINI 	:= Time()
					SU6->U6_HRFIM	:= "23:59"
					SU6->U6_STATUS	:= "1"
					MsUnLock()

				Endif	
			
			END TRANSACTION 
        
		Endif

	Endif	

Endif //lNovo
		
        
//��������������������������������������������������������������������������������Ŀ
//�Apaga o arquivo de log se ja existir gravado apenas para o operador que o gravou�
//����������������������������������������������������������������������������������
If File(cPathLog+cArqLog) .AND. lApaga
	nErase := FERASE(cPathLog+cArqLog)   
	
	While nErase = -1 
		nErase := FERASE(cPathLog+cArqLog)
	End
Endif

//�������������������������������������
//�Volta o cursor apos o processamento�
//�������������������������������������
CursorArrow()

If Empty(cCliente)
	DbSelectArea("SA1")
	DbGoTo(0)
	Help("  ",1,"TK280NCOBR")//"N�o foi poss�vel encontrar nenhuma cobran�a para voc� relizar, considerando suas regras de sele��o."
	Return(lRet)
Endif
		
//����������������������������������������������������������Ŀ
//�Atualiza os dados do cliente que sera cobrado na enchoice.�
//������������������������������������������������������������
DbSelectArea("SA1")
DbSetOrder(1)
If MsSeek(xFilial("SA1") + cCliente + cLoja)
	Tk280Memory("SA1", @aMemory, .T.)
	nPos := Ascan(aPanels, {|x| x[2]=="FOBJ02"} )
	If nPos > 0 
		aPanels[nPos][1]:Refresh()
    Endif
Endif
                       
//�����������������������������������������������������������������������������Ŀ
//�Se existir o ponto de entrada que retorna o codigo do contato para o cliente �
//�substitiu a verificacao padrao                                               �
//�������������������������������������������������������������������������������
If lTk280SU5
	cContato := U_TK280SU5(cCliente,cLoja)
	
	If !Empty(cContato)
		//���������������������������������������������������Ŀ
		//�Valido se o contato esta relacionado com o cliente.�
		//�����������������������������������������������������
		DbSelectArea("AC8")
		DbSetOrder(1)
		If !MsSeek(xFilial("AC8") + cContato + "SA1" + xFilial("SA1") + cCliente + cLoja)
			cContato := ""
		Endif		
	Endif

Else                 
	//���������������������������������������������Ŀ
	//�Atualiza os dados do contato que sera cobrado�
	//�����������������������������������������������
	DbSelectArea("AC8")
	DbSetOrder(2)
	If MsSeek(xFilial("AC8") + "SA1" + xFilial("SA1") + cCliente + cLoja)
	
		While 	!Eof() 							.AND.;
		     AC8->AC8_ENTIDA == "SA1"			.AND.;
			 AC8->AC8_FILENT == xFilial("SA1") 	.AND.;
		 	 TRIM(AC8->AC8_CODENT) == TRIM(cCliente + cLoja)
	
			DbSelectArea("SU5")
			DbSetOrder(1)
			If MsSeek(xFilial("SU5") + AC8->AC8_CODCON)
	
				//���������������������������������������������������������Ŀ
				//�Busca o contato que tenha o campo U5_TIPO preenchido com �
				//�3- COBRANCA, pois indica que o contato e de COBRANCA.    �
				//�����������������������������������������������������������
				If SU5->U5_TIPO == "3" //Cobranca
				   cTpContat:= "3"
				   cContato	:= SU5->U5_CODCONT 
				   
				   Exit
				Endif       
				
			Endif	
	
			Dbselectarea("AC8") 
			Dbskip()
		End	               
	Endif	
	
	//��������������������������������������������������������������������������������������������������������������Ŀ
	//�Se nao existirem contatos para o cliente do tipo COBRANCA, pega o primeiro cadastrado para realizar o contato �
	//����������������������������������������������������������������������������������������������������������������
	If Empty(cTpContat)
		DbSelectArea("AC8")
		DbSetOrder(2)
		If MsSeek(xFilial("AC8") + "SA1" + xFilial("SA1") + cCliente + cLoja)             
			Dbselectarea("SU5")
			DbsetOrder(1)
			If MsSeek(xFilial("SU5") + AC8->AC8_CODCON)
				cContato:= SU5->U5_CODCONT
			Endif	
		Endif	
	Endif
		
Endif	                 

//����������������������Ŀ
//�Acabaram as validacoes�
//������������������������
lRet := .T.

//����������������������������������������������������
//�Grava o codigo do contato no follow-up (pendencia)�
//����������������������������������������������������
If !Empty(cContato) 
	nPos := Ascan(oLbx:aArray, {|x| AllTrim(x[2]) + AllTrim(x[3]) == Alltrim(cCliente) + Alltrim(cLoja) })
	If nPos > 0 
		cLista:= oLbx:aArray[nPos][11]
		If Empty(oLbx:aArray[nPos][5])
			oLbx:aArray[nPos][5]:=cContato
			oLbx:aArray[nPos][6]:=Posicione("SU5",1,xFilial("SU5")+cContato,"U5_CONTAT")
			oLbx:Refresh()  
		Endif	
    Endif
    
	If !Empty(cLista)
		Dbselectarea("SU6")
		DbsetOrder(1)
		If MsSeek(xFilial("SU6") + cLista)
			Reclock("SU6",.F.)
			SU6->U6_CONTATO := cContato
			MsUnlock()
		Endif
	Endif	 
	
Endif
      
//�����������������������������������������������������������������������������Ŀ
//�Atualiza os dados do CONTATO na enchoice de acordo com o contato posicionado.�
//�������������������������������������������������������������������������������
If Empty(cContato)
	//Nao inicializa os campos de variaveis de memoria da enchoice porque nao existe um contato
	//o operador ira incluir no pre-atendimento
	Tk280Memory("SU5", @aMemory, .F.) 
Else
	DbSelectarea("SU5")
	DbSetOrder(1)
	If MsSeek(xFilial("SU5")+cContato)
		Tk280Memory("SU5", @aMemory, .T.)
	Endif	
Endif

nPos := Ascan(aPanels, {|x| x[2]=="FOBJ03"} )
If nPos > 0
	aPanels[nPos][1]:Refresh()
Endif	
		
//��������������������������������������������������������������������Ŀ
//�Atualiza os dados do browser com os Titulos que deverao ser cobrados�
//����������������������������������������������������������������������
nPos := Ascan(aPanels, {|x| x[2]=="FOBJ04"} )
If nPos > 0 
	Tk280SK1(@aPanels[nPos][1]:aHeader, @aPanels[nPos][1]:aCols, @aPanels[Ascan(aPanels, {|x| x[2]=="FOBJ05"} )][1], cCliente, cLoja)
	aPanels[nPos][1]:Refresh()
Endif

// Prepara o painel de Pendencia no Telemarketing para ser atualizado na sua selecao
nPos := Ascan(aPanels, {|x| x[2]=="GOBJ01"} )                                                           
If nPos > 0
	aPanels[nPos][3] := .F.
Endif	

// Prepara o painel de Televendas pendente para ser atualizado na sua selecao
nPos := Ascan(aPanels, {|x| x[2]=="HOBJ01"} )
If nPos > 0
	aPanels[nPos][3] := .F.
Endif	

// Atualiza a agenda do operador depois que pediu uma nova cobranca
If lNovo
	Tk280Refresh(@aPanels, cOperador, oExplorer, .T., @aMemory, aRegras)
Endif

//���������������������������������������������������������������Ŀ
//�Atualiza o status da tabela de atendentes IN/OUT para o Monitor�
//�����������������������������������������������������������������
TkGrvSUV(__cUserId, "PRE1")

//�������������������������������������
//�Volta o cursor apos o processamento�
//�������������������������������������
CursorArrow()

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK280Atend�Autor  �Armando M. Tessaroli� Data �  17/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa a tela do atendimento baseada na tela do pre-atendi-���
���          �mento.                                                      ���
���          �O atendimento podera ser novo ou retorno de agendamento.    ���
�������������������������������������������������������������������������͹��
���Parametros�oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �aPanels   - Todos objetos de todos paineis.                 ���
���          �aRegras   - Contem as regras de selecao dos titulos de todos���
���          �            os operadores para validar qual titulo o opera- ���
���          �            dor corrente podera trabalhar.                  ���
���          �cOperador - Codigo do operador que esta trabalhando.        ���
���          �aMemory   - Vaiaveis de memoria utilizada pelas MSMGET.     ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������͹��
���Andrea F. �23/08/04�811   �- Chamada da funcao TK280AtuSK1 antes de    ���
���          �        �      �executar a funcao de telefonia, para atuali-���
���          �        �      �zar o SK1 com o codigo do operador.         ���
���          �        �      �- Implementado os parametros MV_TMKENC e    ���
���          �        �      �MV_TMKMEMO utilizados no encerramento dos   ���
���          �        �      �atendimentos quando a pendencia for encerrada��
���          �        �      �- Implementado funcao de telefonia para     ���
���          �        �      �realizar a discagem.                        ���
���          �        �      �- Substituido bloco de codigo para verificar���
���          �        �      �se os titulos do cliente foram pagos antes  ���
���          �        �      �da discagem por uma funcao Tk280Pago().     ���
���          �        �      �                                            ���
���Marcelo K.�16/12/04�811   �BOPS: 77210 - Validacao de uso do Array     ���
���Andrea F. �06/07/05�811   �BOPS: 83837 - Atualizar o status de encerra-���
���          �        �      �do na pendencia existente no array.         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TK280Atend(oExplorer, aPanels, aRegras, cOperador, aMemory)

Local oLbx		:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]			// agend do operador
Local aRotAux	:= Aclone(aRotina)												// Copia do arotina
Local cTipoAte	:= TkGetTipoAte()												// Folders do atendimento
Local oNGD		:= aPanels[Ascan(aPanels, {|x| x[2]=="FOBJ04"} )][1]			// Titulo que serao cobrados
Local nPPrefixo	:= 0															// Posicao de array
Local nPTitulo	:= 0															// Posicao de array
Local nPParcela	:= 0	   														// Posicao de array
Local nPTipo	:= 0															// Posicao de array
Local aItens	:= {}															// Itens que serao enviados para o atendimento
Local nI		:= 0 															// Contador
Local cEncerra	:= GetNewPar("MV_TMKENC","")									// Codigo de Encerramento padrao para encerrar atendimentos telecobranca  
Local cMotivo	:= GetNewPar("MV_TMKMEMO","")									// Observacao padrao para motivo de encerramento 
Local cEntidade	:= "SA1"                                                       	// Entidade 
Local cItem		:= oLbx:aArray[oLbx:nAt][12]									// Codigo do item da lista (U6_CODIGO)
Local cLista    := oLbx:aArray[oLbx:nAt][11]                                  	// Codigo da lista
Local cCodCont	:= oLbx:aArray[oLbx:nAt][5]                                   	// Codigo do Contato
Local cCodCli 	:= oLbx:aArray[oLbx:nAt][2]							  	    	// Codigo do cliente
Local cLojaCli	:= oLbx:aArray[oLbx:nAt][3]										// Loja do cliente
Local cCodLig	:= oLbx:aArray[oLbx:nAt][7]										// Codigo do Atendimento 
Local cDDD     	:= ""															// DDD do telefone do contato 			
Local cDDI      := ""															// DDI do telefone do contato 
Local cTel	    := ""															// Telefone do contato de acordo com o U4_TIPOTEL 
Local nPFilOrig	:= 0                                                           	// Filial de origem
Local nPos		:= 0															// Contador auxiliar para Array
Local lRet		:= .F.															// Retorno da funcao
Local nTel		:= 0

//�����������������������������������������������������������������������������Ŀ
//�Se estiver em qualquer um dos paineis que pertenca ao de pendencias agendadas�
//�������������������������������������������������������������������������������
If Str(oExplorer:nPanel,1) $ "1234"
	// Valida se existe algum cliente para efetuar a discagem
	If Empty(cCodCli) .AND. Empty(cLojaCli)
		Help("  ",1,"TK280CLIEN")//N�o h� nenhum cliente dispon�vel para realizar esta opera��o, no painel selecionado, no momento.
		Return(lRet)
	Endif
			  
	// 10-Status
	If oLbx:aArray[oLbx:nAt][10] <> "1"		// 1 = Pendente
		Help("  ",1,"TK280REALI")//O contato para este cliente j� foi relizado.
		Return(lRet)
	Endif
	
	// 07-Atendimento em branco (U6_CODLIG) significa que foi solicitada uma nova cobranca mas nao foi executada
	If Empty(oLbx:aArray[oLbx:nAt][7])
		MsgStop(STR0066,STR0065)//"Esta agenda � referente a um novo pr�-atendimento que foi solicitado e dever� ser executada pela tela de Novo Pr�-atendimento")//Help("  ",1,"TK280TENTA")
		Return(lRet)
	Endif
	
	// 08-Data, 09-Hora
	If oLbx:aArray[oLbx:nAt][8] == dDataBase .AND. oLbx:aArray[oLbx:nAt][9] > SubStr(Time(),1,5)
		If !TMKOK(STR0023 + oLbx:aArray[oLbx:nAt][9] + STR0024 + SubStr(Time(),1,5) + STR0025) //"Este contato est� agendado para �s "###" h. e agora s�o "###" h. Deseja realizar o retorno agora."
			Return(lRet)
		Endif
	Endif
	
	nPos := Ascan(aPanels, {|x| x[2]=="FOBJ04"} )
	If Len(aPanels[nPos][1]:aCols) > 0
		If !Empty(aPanels[nPos][1]:aCols[1][Ascan(aPanels[nPos][1]:aHeader, {|x| AllTrim(x[2])=="E1_NUM"} )])
			Help("  ",1,"TK280NOVO1")//Foi solicitado um Novo Pr�-atendimento e o atendimento dever� ser executado para ele primeiro
			Return(lRet)
		Endif
	Endif
Endif

If Str(oExplorer:nPanel,1) $ "5678" .AND. Empty(M->A1_COD)
	Help("  ",1,"TK280CLIEN")//N�o h� nenhum cliente dispon�vel para realizar esta opera��o, no painel selecionado, no momento.
	Return(lRet)
	
ElseIf Str(oExplorer:nPanel,1) $ "5678" 
	//Atualiza o codigo do contato e lista para o painel de pre-atendimento
	cCodCli := M->A1_COD
	cLojaCli:= M->A1_LOJA
	cCodCont:= M->U5_CODCONT
	nPos 	:= Ascan(oLbx:aArray, {|x| ( Alltrim(x[2]) + Alltrim(x[3]) == Alltrim(cCodCli) + Alltrim(cLojaCli) ) ;
								.AND.  ( Alltrim(x[5]) == Alltrim(cCodCont) );
								.AND. x[10] == "1" .AND. Empty(x[7]) }) //Mesmo cliente/ contato/ em aberto / sem atendimento
	If nPos > 0 
		cLista 	:= oLbx:aArray[nPos][11]
		cCodLig	:= oLbx:aArray[nPos][7]
		cItem	:= oLbx:aArray[nPos][12]
	Endif	
Endif

//��������������������������������������������������������������������������������������������Ŀ
//�Pega os campos que compoem o telefones no cadastro de contatos para realizar a discagem	   �
//����������������������������������������������������������������������������������������������
IF !Empty(cCodCont)
	cDDD := AllTrim(TkDadosContato(cCodCont,8))
	cDDI := AllTrim(TkDadosContato(cCodCont,9))
	cTel := AllTrim(TkDadosContato(cCodCont,Val(Posicione("SU4",1,xFilial("SU4")+cLista,"U4_TIPOTEL"))))
Endif
		
//�������������������������������������������������������������������������������������������������������������������Ŀ
//�Se nao existir telefone cadastrado, percorre o cadastro do contato a fim de identificar um telefone para discagem. �
//���������������������������������������������������������������������������������������������������������������������
IF Empty(cTel)                                
	If !Empty(cCodCont)
		For nTel:= 1 to 5
			cTel := AllTrim(TkDadosContato(cCodCont,nTel))
			If !Empty(cTel)
				Exit
			Endif	
	    Next nTel                                          
	Endif
    
	If Empty(cTel)
		Aviso("Aten��o","O contato selecionado nao possui um telefone para efetuar a discagem. Por favor, informe um telefone no cadastro de contatos para realizar a discagem!",{"OK"})
		lRet:=.F.
		Return(lRet)
	Endif	
Endif
aRotina	:= {	{ STR0026	,"AxPesqui"        ,0,1 },; //"Pesquisar"
				{ STR0027	,"TK271CallCenter" ,0,2 },; //"Visualizar"
				{ STR0028	,"TK271CallCenter" ,0,3 },; //"Incluir"
				{ STR0028	,"TK271CallCenter" ,0,4 },; //"Incluir"
				{ STR0028	,"TK271CallCenter" ,0,5 },; //"Incluir"
				{ STR0028	,"TK271CallCenter" ,0,6 }} //"Incluir"
INCLUI := .T.

//���������������������������������������������
//� Abre somente o atendimento de Telecobranca�
//���������������������������������������������
TkGetTipoAte("3")

//�����������������������������������������������������������������������������������������Ŀ
//�Funcao para atualizar no SK1 os titulos para esse operador que ainda nao estao nomeados. �
//�������������������������������������������������������������������������������������������
Tk280AtuSK1(cCodCli,cLojaCli,cOperador,aRegras)//2-Cliente,3-Loja,Operador,Regra

//�������������������������������������������������������������������Ŀ
//�Executa a funcao para verificar se todos os titulos foram pagos	  �
//���������������������������������������������������������������������
If Tk280Pago(cCodLig,cOperador,cCodCli,cLojaCli)//Atendimento,Operador,Cliente,Loja
	MsgStop(STR0064,STR0065)//"Todos os t�tulos que foram negociados para esse cliente foram pagos. A pend�ncia e o atendimento ser�o encerrados","Aten��o"

	nPos := Ascan(oLbx:aArray, {|x| ( Alltrim(x[2]) + Alltrim(x[3]) )  == ( Alltrim(cCodCli) + Alltrim(cLojaCli) )})
    If nPos > 0
		oLbx:aArray[nPos][10] := "2" 
		oLbx:Refresh()
 	Endif
 	
	BEGIN TRANSACTION
		//�����������������������������������������������������������������������������������Ŀ
		//�Encerra a pendencia do operador para o atendimento que teve todos os titulos pagos.�
		//�������������������������������������������������������������������������������������
		DbSelectArea("SU4")
		DbSetOrder(1)
		If MsSeek(xFilial("SU4") + cLista)
			RecLock("SU4", .F.)
			SU4->U4_STATUS	:= "2"
			SU4->U4_DATA	:= dDataBase
			MsUnLock()
		Endif        
		
		DbSelectArea("SU6")
		DbSetOrder(1)
		If MsSeek(xFilial("SU6") + cLista)
			RecLock("SU6", .F.)
			SU6->U6_STATUS 	:= "3"
			SU6->U6_DATA	:= dDataBase
			MsUnLock()
		Endif
		
		//����������������������������������������������������������������Ŀ
		//�Encerra o atendimento, grava o codigo e o motivo de encerramento�
		//������������������������������������������������������������������
		If !Empty(cCodLig)
			Dbselectarea("ACF")
			DbsetOrder(1)
			If MsSeek(xFilial("ACF")+cCodLig)
				If Empty(cEncerra) .OR. Empty(cMotivo)
					//�������������������������������������������������������������������������Ŀ
					//�Exibe dialog para o operador informar o codigo de encerramento e o motivo�
					//���������������������������������������������������������������������������
					Tk274Encerra(.F.,cCodLig,@cEncerra,@cMotivo)
				Endif
				Reclock("ACF",.F.)
				ACF->ACF_STATUS := "3"		//Encerrado
				ACF->ACF_CODENC	:= cEncerra	//Codigo do Encerramento
				MSMM(,TamSx3("ACF_OBSMOT")[1],,cMotivo,1,,,"ACF","ACF_CODMOT")//Motivo do Encerramento
				MsUnlock()
			Endif	
		Endif
	END TRANSACTION
		
Else 

	//�����������������������������������������������������������������������������Ŀ
	//�Se estiver em qualquer um dos paineis que pertenca ao de pendencias agendadas�
	//�������������������������������������������������������������������������������
	If Str(oExplorer:nPanel,1) $ "1234" 
			
		//����������������������������������������������������������Ŀ
		//�Executa a funcao de telefonia antes de abrir o atendimento�
		//������������������������������������������������������������
		If Tk380Discar(cOperador,cDDI		,cDDD				,cTel,;
					   cCodCont	,cEntidade	,cCodCli+cLojaCli	,cLista,;
					   cItem)
	
			// Posiciona no Operador para ser utilizado no atendimento
			DbSelectArea("SU7")
			DbSetOrder(1)
			MsSeek(xFilial("SU7") + cOperador)
				
			// Atualiza o painel com os titulos a serem cobrados se ainda nao foi atualizado
			oExplorer:nPanel := 3
			Tk280Change(oExplorer, @aPanels, @aMemory)
				
			// Atualiza o painel com os titulos a serem cobrados se ainda nao foi atualizado
			oExplorer:nPanel := 4
			Tk280Change(oExplorer, @aPanels, @aMemory)
				
			// Devolve para o painel de origem
			oExplorer:nPanel := 1
			
			//������������������������������������������������������������������������Ŀ
			//�Monta um array a partir dos titulos que foram carregados no             �
			//�painel de titulos negociados e serao cobrados e passa para o atendimento�
			//��������������������������������������������������������������������������
			oNGD := aPanels[Ascan(aPanels, {|x| x[2]=="COBJ01"} )][1]
	
			nPPrefixo	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACG_PREFIX"} )
			nPTitulo	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACG_TITULO"} )
			nPParcela	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACG_PARCEL"} )
			nPTipo		:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACG_TIPO"} )
			If (ACG->(FieldPos("ACG_FILORI"))  > 0)			
				nPFilOrig	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACG_FILORI"} )
            Endif
	
			For nI := 1 To Len(oNGD:aCols)
				If !Empty(oNGD:aCols[nI][nPTitulo])
					Aadd(aItens, {	oNGD:aCols[nI][nPPrefixo],;
									oNGD:aCols[nI][nPTitulo],;
									oNGD:aCols[nI][nPParcela],;
									oNGD:aCols[nI][nPTipo],;
									IIf(nPFilOrig > 0,oNGD:aCols[nI][nPFilOrig],xFilial("SE1"));
									} )
				Endif
			Next nI
				
			//�������������������������������������������������������������������������Ŀ
			//�Monta um array  a partir dos titulos que foram carregados no painel de   �
			//�previsao de cobranca que tambem serao cobrados e passa para o atendimento�
			//���������������������������������������������������������������������������
			oNGD := aPanels[Ascan(aPanels, {|x| x[2]=="DOBJ01"} )][1]
	
			nPPrefixo	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_PREFIXO"} )
			nPTitulo	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_NUM"} )
			nPParcela	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_PARCELA"} )
			nPTipo		:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_TIPO"} )
			nPFilOrig	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_FILIAL"} )
	
			For nI := 1 To Len(oNGD:aCols)
				If !Empty(oNGD:aCols[nI][nPTitulo]) 
					nPos:=Ascan(aItens, {|x| (	x[1] == oNGD:aCols[nI][nPPrefixo]	) 	.AND. ;
											  (	x[2] == oNGD:aCols[nI][nPTitulo]	) 	.AND. ;
											  ( x[3] == oNGD:aCols[nI][nPParcela] 	) 	.AND. ;
											  ( x[4] == oNGD:aCols[nI][nPTipo] 	)	.AND. ;
											  ( x[5] == oNGD:aCols[nI][nPFilOrig]	)})
					If nPos == 0
						Aadd(aItens, {	oNGD:aCols[nI][nPPrefixo],;
										oNGD:aCols[nI][nPTitulo],;
										oNGD:aCols[nI][nPParcela],;
										oNGD:aCols[nI][nPTipo],;
										oNGD:aCols[nI][nPFilOrig];
										} )
					Endif					
				Endif
			Next nI
				              
			// Atendimento agendado
			DbSelectArea("ACF")
			TK271CallCenter("ACF"	,ACF->(RecNo())	,4			,Nil,;
							cCodCli	,cLojaCli		,cCodCont	,cEntidade,;
							aItens	,cLista			,.F.)
		Else
			Tk280Reagenda(@aPanels, oLbx:aArray[oLbx:nAt][11], cOperador, oExplorer, @aMemory, aRegras)
		Endif
	
	Else	//Painel de Novo Pre-Atendimento
	
		//����������������������������������������������������������Ŀ
		//�Executa a funcao de telefonia antes de abrir o atendimento�
		//������������������������������������������������������������
		If Tk380Discar(	cOperador	,cDDI	,cDDD					,cTel,;
						cCodCont	,"SA1"	,M->A1_COD + M->A1_LOJA	,cLista,;
						cItem)
		
				// Posiciona no Operador para ser utilizado no atendimento TMKA271
				DbSelectArea("SU7")
				DbSetOrder(1)
				MsSeek(xFilial("SU7") + cOperador)
			
				nPPrefixo	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_PREFIXO"} )
				nPTitulo	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_NUM"} )
				nPParcela	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_PARCELA"} )
				nPTipo		:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_TIPO"} )
				nPFilOrig	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="E1_FILIAL"} )
					
				// Monta um array com os titulos que serao cobrados e passa para o atendimento
				For nI := 1 To Len(oNGD:aCols)
					Aadd(aItens, {	oNGD:aCols[nI][nPPrefixo],;
									oNGD:aCols[nI][nPTitulo],;
									oNGD:aCols[nI][nPParcela],;
									oNGD:aCols[nI][nPTipo],;
									oNGD:aCols[nI][nPFilOrig];
									} )
				Next nI
					
				// Novo atendimento
				DbSelectArea("ACF")
				TK271CallCenter("ACF"		,ACF->(RecNo())	,3				,Nil,;
								M->A1_COD	,M->A1_LOJA		,SU5->U5_CODCONT,"SA1",;
								aItens		,cLista			,.F.) 
		Else
			Tk280Reagenda(@aPanels, cLista, cOperador, oExplorer, @aMemory, aRegras)
		Endif
	Endif
Endif

// Restaura as condicoes normais
TkGetTipoAte(cTipoAte)
aRotina	:=  Aclone(aRotAux)
INCLUI	:= .F.

// Atualiza a agenda do operador depois que executa o atendimento
Tk280Refresh(@aPanels, cOperador, oExplorer, .T., @aMemory, aRegras)

// Troca o flag do panel para ser atualizado na selecao
aPanels[Ascan(aPanels, {|x| x[2]=="EOBJ01"} )][3] := .F.


//�������������������������������������������������������������������������������Ŀ
//�Limpa as enchoices da tela Novo Pr�-atendimento que se atualiza automaticamente�
//���������������������������������������������������������������������������������
Tk280Memory("SA1", @aMemory, .F.)
nPos := Ascan(aPanels, {|x| x[2]=="FOBJ02"} )
aPanels[nPos][1]:Refresh()
	
Tk280Memory("SU5", @aMemory, .F.)
nPos := Ascan(aPanels, {|x| x[2]=="FOBJ03"} )
aPanels[nPos][1]:Refresh()
	
// Se foi executado do painel 6, entao limpa os dados do restante da tela Novo Pre-atendimento
If Str(oExplorer:nPanel,1) $ "5678"
	//��������������������������������������������������������������������Ŀ
	//�Atualiza os dados do browser com os Titulos que deverao ser cobrados�
	//����������������������������������������������������������������������
	nPos := Ascan(aPanels, {|x| x[2]=="FOBJ04"} )
	Tk280SK1(@aPanels[nPos][1]:aHeader, @aPanels[nPos][1]:aCols, @aPanels[Ascan(aPanels, {|x| x[2]=="FOBJ05"} )][1],,,.T.)
	aPanels[nPos][1]:Refresh()
	
	//��������������������������������������������������������������������Ŀ
	//�Limpa os dados do Painel de pendencias no Telemarketing             �
	//����������������������������������������������������������������������
	nPos := Ascan(aPanels, {|x| x[2]=="GOBJ01"} )
	Tk280SUC(@aPanels[nPos][1]:aHeader, @aPanels[nPos][1]:aCols, "")
	aPanels[nPos][1]:Refresh()
	
	nPos := Ascan(aPanels, {|x| x[2]=="GOBJ02"} )
	Tk280SUD(@aPanels[nPos][1]:aHeader, @aPanels[nPos][1]:aCols, "")
	aPanels[nPos][1]:Refresh()
	
	// Prepara o painel de Pendencia no Telemarketing para NAO ser atualizado na selecao
	nPos := Ascan(aPanels, {|x| x[2]=="GOBJ01"} )
	aPanels[nPos][3] := .T.
	
	//��������������������������������������������������������������������Ŀ
	//�Limpa os dados do Painel de pendencias no Televendas                �
	//����������������������������������������������������������������������
	nPos := Ascan(aPanels, {|x| x[2]=="HOBJ01"} )
	Tk280SUA(@aPanels[nPos][1]:aHeader, @aPanels[nPos][1]:aCols, "", "")
	aPanels[nPos][1]:Refresh()
	
	nPos := Ascan(aPanels, {|x| x[2]=="HOBJ02"} )
	Tk280SUB(@aPanels[nPos][1]:aHeader, @aPanels[nPos][1]:aCols, "")
	aPanels[nPos][1]:Refresh()
	
	// Prepara o painel de Televendas pendente para NAO ser atualizado na selecao
	nPos := Ascan(aPanels, {|x| x[2]=="HOBJ01"} )
	aPanels[nPos][3] := .T.
	
Endif

//���������������������������������������������������������������Ŀ
//�Atualiza o status da tabela de atendentes IN/OUT para o Monitor�
//�����������������������������������������������������������������
TkGrvSUV(__cUserId, "PRE0")
lRet := .T.

Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Reagenda�Autor�Armando M. Tessaroli� Data �  25/07/03  ���
�������������������������������������������������������������������������͹��
���Desc.     �Em caso de falha na tentativa de realizar a ligacao para o  ���
���          �contato, o atendimento podera ser reagendado para depois.   ���
�������������������������������������������������������������������������͹��
���Parametros�aPanels   - Todos objetos de todos paineis.                 ���
���          �cLista    - Codigo da lista que ficara pendente para retorno���
���          �            do operador de telecobranca.                    ���
���          �cOperador - Codigo do operador que esta trabalhando.        ���
���          �oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �aMemory   - Vaiaveis de memoria utilizada pelas MSMGET.     ���
���          �aRegras   - Contem as regras de selecao dos titulos de todos���
���          �            os operadores para validar qual titulo o opera- ���
���          �            dor corrente podera trabalhar.                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk280Reagenda(aPanels, cLista, cOperador, oExplorer, aMemory, aRegras)

// Variaveis de controle
Local aArea		:= GetArea()
Local lRet		:= .T.
Local aTel		:= {}
Local dDtRet	:= dDataBase
Local cHRet		:= PadR(Time(),5)
Local nOk		:= 0
Local nTpTel	:= 1
Local cContato	:= ""
Local cCliente	:= ""
Local cLoja		:= ""

// Objetos
Local oFonte
Local oDlg
Local oAgenda	:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]	// Objeto com os itens da agenda do operador
Local oLbx
Local oDtRet
Local oHRet
                             
DEFINE FONT oFonte NAME "Arial" SIZE 0,14 BOLD

//��������������������������������������������������������������������������������
//�Pega o cliente de acordo com o painel posicionado e pesquisa na base de dados.�
//��������������������������������������������������������������������������������
If Str(oExplorer:nPanel,1) $ "1234"
	cContato:= oAgenda:aArray[oAgenda:nAt][5]
	cCliente:= oAgenda:aArray[oAgenda:nAt][2]
	cLoja	:= oAgenda:aArray[oAgenda:nAt][3]
Else
	cContato:= M->U5_CODCONT
	cCliente:= M->A1_COD
	cLoja	:= M->A1_LOJA
Endif
		
DbSelectArea("SU5")
DbSetOrder(1)
If !MsSeek(xFilial("SU5") + cContato)
	DbSelectArea("AC8")
	DbSetOrder(2)		// AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
	MsSeek(xFilial("AC8") + "SA1" + xFilial("SA1") + cCliente + cLoja)
	
	DbSelectArea("SU5")
	DbSetOrder(1)
	If !MsSeek(xFilial("SU5") + AC8->AC8_CODCON)
		Help("  ",1,"TK280REAG")//"O cliente selecionado para cobran�a nao possui um contato relacionado para que seja efetuado o reagendamento"
		Return(.F.)
	Endif
Endif

Aadd(aTel,{STR0030,	PadR(SU5->U5_CODPAIS,3), SU5->U5_DDD, SU5->U5_FONE})		//"Residencial"
Aadd(aTel,{STR0031,	PadR(SU5->U5_CODPAIS,3), SU5->U5_DDD, SU5->U5_CELULAR})	//"Celular"
Aadd(aTel,{STR0032,	PadR(SU5->U5_CODPAIS,3), SU5->U5_DDD, SU5->U5_FAX})		//"FAX"
Aadd(aTel,{STR0033,	PadR(SU5->U5_CODPAIS,3), SU5->U5_DDD, SU5->U5_FCOM1})		//"Comercial 01"
Aadd(aTel,{STR0034,	PadR(SU5->U5_CODPAIS,3), SU5->U5_DDD, SU5->U5_FCOM2})		//"Comercial 02"

While nOk <> 1 

	DEFINE MSDIALOG oDlg TITLE STR0035 FROM 0,0 TO 230,380 PIXEL //"PRORROGACAO DE DATA E HORA DA AGENDA"
	
	EnchoiceBar(oDlg, {|| (IIF(Tk280VldTel(aTel[nTpTel][4],@nOk),oDlg:End(),"")) }, {|| oDlg:End() } )
		
		@ 020,005 ListBox oLbx Fields Header STR0036, STR0037, STR0038, STR0039 Size 180,65 OF oDlg Pixel //"Tipo"###"DDI"###"DDD"###"N�mero"
		
		oLbx:SetArray(aTel)
		oLbx:bLine := {||{	aTel[oLbx:nAt][1],;
							aTel[oLbx:nAt][2],;
							aTel[oLbx:nAt][3],;
							aTel[oLbx:nAt][4];
							}}
		oLbx:bChange := { || (nTpTel:= oLbx:nAt) }
		
		@ 92,005 SAY STR0040 FONT oFonte COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		//" Data de Retorno"
		@ 90,055 GET oDtRet VAR dDtRet OF oDlg SIZE 40,10 PIXEL VALID Tk274Penden(dDtRet,cOperador)
		
		@ 92,105 SAY STR0041 FONT oFonte COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		//" Hora de Retorno"
		@ 90,155 GET oHRet VAR cHRet OF oDlg SIZE 30,10 PIXEL VALID	(Val(SubStr(cHRet,1,2)) < 24) .AND.;
																	(Val(SubStr(cHRet,4,2)) < 60) .AND.;
																	IIF(dDtRet==dDataBase,IIF(cHRet>=PadR(Time(),5),.T.,.F.),.T.);
																	PICTURE '99:99'
		
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOk <> 1 
		Aviso(STR0065,STR0067,{"OK"})//"Aten��o","Favor informar um numero de telefone valido!"
	EndIf
	
End
If nOk == 1
	Begin Transaction
		DbSelectArea("SU4")
		DbSetOrder(1)
		If MsSeek(xFilial("SU4") + cLista)
			RecLock("SU4", .F.)
			SU4->U4_DATA	:= dDtRet
			SU4->U4_TIPOTEL	:= Str(nTpTel,1)	// 1=Residencial 2=Fax 3=Celular 4=Comercial 1 5=Comercial 2
			SU4->U4_STATUS	:= "1"				// Status da Lista 1=Pendente 2=Encerrada
			MsUnLock()
		Endif
	
		DbSelectArea("SU6")
		DbSetOrder(1)
		If MsSeek(xFilial("SU6") + cLista)
			RecLock("SU6", .F.)
			SU6->U6_DATA	:= dDtRet
			SU6->U6_HRINI	:= cHRet
			If Empty(SU6->U6_CONTATO)
				SU6->U6_CONTATO := SU5->U5_CODCONT
			Endif
			MsUnLock()
		Endif
	End Transaction

	// Atualiza a agenda do operador depois que executa o atendimento
	Tk280Refresh(@aPanels, cOperador, oExplorer, .T., @aMemory, aRegras)
Else
	lRet:= .F.
Endif
                          
RestArea(aArea)
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280VldTel�Autor  �Microsiga           � Data �  09/01/04  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validar se o numero informado na tela de reagendamento e    ���
���          �um numero valido.                                           ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Tk280VldTel(nNumTel,nOk)

Local lRet:= .T.

If Empty(nNumTel)
	lRet:= .F.
	nOk	:=	0
Else	
	nOk:=1
Endif	

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Fim  �Autor  �Armando M. Tessaroli� Data �  08/08/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Finaliza a tela de pre-atendimento e defaz as teclas de fun ���
���          �cao criadas como atalhos aos programas.                     ���
�������������������������������������������������������������������������͹��
���Parametros�oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �aKey      - Array com todas as acoes das teclas de funcao.  ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Tk280Fim(oExplorer, aKey)

Local nI	:= 1	// Controle de laco

For nI := 1 To Len(aKey)
	SetKey(aKey[nI][1], {|| AllWaysTrue() } )
Next nI

//����������������������������������������������������������������������������������������
//�Inibe o loop da dialog quando acessado um AxCadastro durante o processo de atendimento�
//����������������������������������������������������������������������������������������
If FindFunction("MBRCHGLOOP")
	MBRCHGLOOP(.F.)
Endif

//���������������������������������������������������������������Ŀ
//�Atualiza o status da tabela de atendentes IN/OUT para o Monitor�
//�����������������������������������������������������������������
TkGrvSUV(__cUserId, "")

oExplorer:Deactivate()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK280Credito�Autor�Armando M. Tessaroli� Data �  17/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta uma tela que apresenta a situacao financeira do clien-���
���          �te e permite altera-la.                                     ���
�������������������������������������������������������������������������͹��
���Parametros�lAltera   - Define se o operador podera manipular o credito ���
���          �            do cliente ou nao.                              ���
���          �oExplorer - Objeto que contem os paineis com os dados do    ���
���          �            pre-atendimento.                                ���
���          �aPanels   - Todos objetos de todos paineis.                 ���
���          �aMemory   - Vaiaveis de memoria utilizada pelas MSMGET.     ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������͹��
���Andrea F. �23/08/04�811   �- Validacao para nao permitir que seja      ���
���          �        �      �alterado o limite de credito do cliente com ���
���          �        �      �um valor superior ao ja cadastrado.         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TK280Credito(lAltera, oExplorer, aPanels, aMemory)

// Variaveis que definen os objetos e seus conteudos apresentados na tela.
Local oDlg
Local oFonte
Local oCodigo
Local cCodigo	:= ""
Local oLoja
Local cLoja		:= ""
Local oNome
Local cNome		:= ""
Local oRisco
Local cRisco	:= ""
Local aRisco	:= Tk280Box("A1_RISCO")
Local oClasse
Local cClasse	:= ""
Local aClasse	:= Tk280Box("A1_CLASSE")
Local oLC
Local nLC		:= 0
Local nLCOri	:= 0
Local oVencLC
Local dVencLC	:= CtoD("//")
Local oLCFin
Local nLCFin	:= 0
Local oMoedaLC
Local nMoedaLC	:= 0
Local oSalPedL
Local nSalPedL	:= 0
Local oSPL
Local lSPL		:= .T.
Local oSalPed
Local nSalPed	:= 0
Local oSP
Local lSP		:= .T.
Local oSalDup
Local nSalDup	:= 0
Local oSD
Local lSD		:= .T.
Local oSaldoLC
Local nSaldoLC	:= 0
Local lOk		:= .F.
Local nPCliente	:= 0
Local nPLoja	:= 0
Local oLbx		:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]	// Agenda do operador
Local oNGD		:= aPanels[Ascan(aPanels, {|x| x[2]=="EOBJ01"} )][1]	// Titulos que deverao ser cobrados

Default lAltera	:= .F.

DEFINE FONT oFonte NAME "Arial" SIZE 0,14 BOLD

//�������������������������������������������������������������������
//�Pega o cliente do folder relacionado e posiciona na base de dados�
//�������������������������������������������������������������������
If Str(oExplorer:nPanel,1) $ "1234"
	cCliente	:= Eval(oLbx:bLine)[2]
	cLoja		:= Eval(oLbx:bLine)[3]
Endif

If oExplorer:nPanel == 5
	nPCliente	:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACF_CLIENT"} )
	nPLoja		:= Ascan(oNGD:aHeader, {|x| AllTrim(x[2])=="ACF_LOJA"} )
	cCliente	:= oNGD:aCols[oNGD:nAt][nPCliente]
	cLoja		:= oNGD:aCols[oNGD:nAt][nPLoja]
Endif

If Str(oExplorer:nPanel,1) $ "678"
	cCliente	:= M->A1_COD
	cLoja		:= M->A1_LOJA
Endif

If !Empty(cCliente) .AND. !Empty(cLoja)
	DbSelectarea("SA1")
	DbSetOrder(1)
	If !MsSeek(xFilial("SA1") + cCliente + cLoja)
		Help("  ",1,"TK280CLIEN")//"Nao h� nenhum cliente disponivel para realizar essa operacao, no momento"
		Return(.F.)
	Endif
Else
	Help("  ",1,"TK280CLIEN")//"Nao h� nenhum cliente disponivel para realizar essa operacao, no momento"
	Return(.F.)
Endif

cCodigo		:= FieldGet(FieldPos("A1_COD    "))
cLoja		:= FieldGet(FieldPos("A1_LOJA   "))
cNome		:= FieldGet(FieldPos("A1_NOME   "))
cRisco		:= FieldGet(FieldPos("A1_RISCO  "))
cClasse		:= FieldGet(FieldPos("A1_CLASSE "))
nLC			:= FieldGet(FieldPos("A1_LC     "))
nLCOri		:= FieldGet(FieldPos("A1_LC     "))
dVencLC		:= FieldGet(FieldPos("A1_VENCLC "))
nLCFin		:= FieldGet(FieldPos("A1_LCFIN  "))
nMoedaLC	:= FieldGet(FieldPos("A1_MOEDALC"))
nSalPedL	:= FieldGet(FieldPos("A1_SALPEDL"))
nSalPed		:= FieldGet(FieldPos("A1_SALPED "))
nSalDup		:= FieldGet(FieldPos("A1_SALDUP "))
nSaldoLC	:= nLC - (nSalPedL + nSalPed + nSalDup)

DEFINE MSDIALOG oDlg TITLE STR0042 FROM 0,0 TO 290,600 PIXEL		// "MANIPULACAO DO CREDITO DO CLIENTE"
	
	EnchoiceBar(oDlg, {|| (lOk:=.T.,oDlg:End()) }, {|| oDlg:End() } )
	
	
	//����������������Ŀ
	//�Dados do cliente�
	//������������������
	@ 20, 05 To 45, 295 Label STR0043 Of oDlg Pixel		// "Cliente"
	
	@ 30,10 SAY STR0044 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "C�digo/Loja"
	@ 30,43 GET oCodigo VAR cCodigo OF oDlg SIZE 30,09 PIXEL WHEN .F. PICTURE PesqPict("SA1", "A1_COD")
	@ 30,75 GET oLoja VAR cLoja OF oDlg SIZE 10,09 PIXEL WHEN .F. PICTURE PesqPict("SA1", "A1_LOJA")
	
	@ 30,123 SAY STR0045 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Nome"
	@ 30,123 GET oNome VAR cNome OF oDlg SIZE 165,09 PIXEL WHEN .F. PICTURE PesqPict("SA1", "A1_NOME")
	
	
	//�����������������������������������
	//�Manipulacao do credito do cliente�
	//�����������������������������������
	@ 55, 05 To 140, 295 Label STR0046 Of oDlg Pixel		// "Cr�dito"
	
	@ 65,10 SAY STR0047 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Risco"
	@ 65,60 MSCOMBOBOX oRisco VAR cRisco ITEMS aRisco OF oDlg SIZE 60,09 PIXEL WHEN lAltera
	
	@ 65,155 SAY STR0048 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Classe"
	@ 65,205 MSCOMBOBOX oClasse VAR cClasse ITEMS aClasse OF oDlg SIZE 60,09 PIXEL WHEN lAltera
	
	@ 80,10 SAY STR0049 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Limite de Cr�dito"
	@ 80,60	GET oLC VAR nLC OF oDlg SIZE 60,09 PIXEL WHEN lAltera PICTURE PesqPict("SA1", "A1_LC");
			VALID IIF(nLC <= nLCORI,;
			(nSaldoLC	:= nLC - ( IIF(lSPL,nSalPedL,0) + IIF(lSP,nSalPed,0) + IIF(lSD,nSalDup,0) ) ),.F.) 
	
	@ 80,155 SAY STR0050 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Vencimento Limite"
	@ 80,205 GET oVencLC VAR dVencLC OF oDlg SIZE 40,09 PIXEL WHEN lAltera PICTURE PesqPict("SA1", "A1_VENCLC")
	
	@ 95,10 SAY STR0051 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Limite Secund�rio"
	@ 95,60 GET oLCFin VAR nLCFin OF oDlg SIZE 60,09 PIXEL WHEN lAltera PICTURE PesqPict("SA1", "A1_LCFIN")
	
	@ 95,155 SAY STR0052 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Moeda do Limite"
	@ 95,205 GET oMoedaLC VAR nMoedaLC OF oDlg SIZE 15,09 PIXEL WHEN lAltera PICTURE PesqPict("SA1", "A1_MOEDALC")
	
	@ 110,010 SAY STR0053 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Saldo do Pedido Lib."
	@ 110,060 GET oSalPedL VAR nSalPedL OF oDlg SIZE 60,09 PIXEL WHEN .F. PICTURE PesqPict("SA1", "A1_SALPEDL")
	@ 110,120	CHECKBOX oSPL VAR lSPL SIZE 10,10 PIXEL OF oDlg PROMPT "";
				ON CHANGE ( (nSaldoLC := nSaldoLC + IIF(lSPL,(nSalPedL*-1),nSalPedL)), (oSaldoLC:Refresh()) )
	
	@ 110,155 SAY STR0054 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Saldo do Pedido"
	@ 110,205 GET oSalPed VAR nSalPed OF oDlg SIZE 60,09 PIXEL WHEN .F. PICTURE PesqPict("SA1", "A1_SALPED")
	@ 110,265 CHECKBOX oSP VAR lSP SIZE 10,10 PIXEL OF oDlg PROMPT "";
				ON CHANGE ( (nSaldoLC := nSaldoLC + IIF(lSP,(nSalPed*-1),nSalPed)), (oSaldoLC:Refresh()) )
	
	@ 125,010 SAY STR0055 COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Saldo dos T�tulos"
	@ 125,060 GET oSalDup VAR nSalDup OF oDlg SIZE 60,09 PIXEL WHEN .F. PICTURE PesqPict("SA1", "A1_SALDUP")
	@ 125,120 CHECKBOX oSD VAR lSD SIZE 10,10 PIXEL OF oDlg PROMPT "";
				ON CHANGE ( (nSaldoLC := nSaldoLC + IIF(lSD,(nSalDup*-1),nSalDup)), (oSaldoLC:Refresh()) )
	
	@ 125,155 SAY STR0056 FONT oFonte COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		// "Saldo do Limite"
	@ 125,205 GET oSaldoLC VAR nSaldoLC OF oDlg SIZE 60,09 PIXEL WHEN .F. PICTURE PesqPict("SA1", "A1_LC")
	
ACTIVATE MSDIALOG oDlg CENTERED

If lOk .AND. lAltera
	RecLock("SA1")
	SA1->A1_RISCO	:= cRisco
	SA1->A1_CLASSE	:= cClasse
	SA1->A1_LC		:= nLC
	SA1->A1_VENCLC	:= dVencLC
	SA1->A1_LCFIN	:= nLCFin
	SA1->A1_MOEDALC	:= nMoedaLC
	MsUnLock()
Endif

Return(.T.)
                                

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Pesq �Autor  �Andrea Farias       � Data �  10/05/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa pesquisa das pendencias (follow-up) disponiveis no  ���
���          �painel de pendencias agendadas para hoje.                   ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Function Tk280Pesq(oExplorer, aPanels, aRegras, cOperador)

Local lRet		:= .T.                                                         	// Retorno da funcao
Local oLbx		:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]			// Agenda do operador
Local cCliente  := Space(06)                                                   	// Codigo do cliente
Local cLoja		:= Space(02)                                                  	// Codigo da Loja
Local cNome		:= Space(40)													// Nome do cliente
Local nPos		:= 0															// Posicao do array onde se encontra o cliente
Local oCliente,oLoja,oNome,oDlg,oFonte                                         	// Objetos da Dialog

//�����������������������������������������������������������������������������Ŀ
//�Se estiver apenas no painel de pendencias agendadas, executa a pesquisa.     �
//�������������������������������������������������������������������������������
If Str(oExplorer:nPanel,1) $ "1"

	DEFINE MSDIALOG oDlg TITLE STR0069 FROM 15,2 TO 200,300 PIXEL //"Pesquisar pend�ncia"

		@ 002,002 TO 090,148 OF oDlg  PIXEL
	
		@ 010,010 SAY STR0072 + " :" FONT oFonte COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		//"Codigo :"
		@ 010,035 GET oCliente VAR cCliente OF oDlg  Picture PesqPict("SA1", "A1_COD") SIZE 40,10 PIXEL ;
		VALID Tk280SelCli(cCliente,cLoja,@cNome,oNome)
		oCliente:cF3 := "CLT"
		
		@ 030,010 SAY STR0071 + " :" FONT oFonte COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		//"Loja    :"
		@ 030,035 GET oLoja VAR cLoja OF oDlg SIZE 20,10 PIXEL  
		
		@ 050,010 SAY STR0045 + " :" FONT oFonte COLORS CLR_BLACK, CLR_WHITE OF oDlg PIXEL		//"Nome :"
		@ 050,035 GET oNome VAR cNome OF oDlg SIZE 80,10 PIXEL WHEN .F.
					
		DEFINE SBUTTON FROM 070,090 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
		
	ACTIVATE MSDIALOG oDlg CENTERED                  
	
	nPos:= Ascan(oLbx:aArray, {|x| x[2]+x[3]== cCliente+cLoja} )
	If nPos > 0
		oLbx:nAt:=nPos
		oLbx:Refresh()
	Endif

Else
	MsgStop(STR0073,STR0065)//"Para pesquisar uma pend�ncia, � necess�rio estar posicionado no painel de pendencias agendadas!","Aten��o")
	lRet:= .F.
Endif
	          
Return(lRet)              


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280SelCli �Autor  �Microsiga         � Data �  10/15/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Posiciona no codigo do cliente e loja selecionado para      ���
���          �pesquisa e atualiza o nome do cliente.                      ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Tk280SelCli(cCliente,cLoja,cNome,oNome)

Local aArea:= GetArea()

If !Empty(cCliente) .AND. !Empty(cLoja)
	Dbselectarea("SA1")
	DbsetOrder(1)
	If Msseek(xFilial("SA1")+cCliente+cLoja)
		cNome:= SA1->A1_NOME
		oNome:bSetGet := {|| cNome }
		oNome:Refresh()	                                                  
	Endif	
Endif    

RestArea(aArea)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Contato �Autor  �Andrea Farias    � Data �  10/05/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de contatos. Disponivel para inclusao e alteracao. ���
���          �Executado atraves do botao na barra de ferramentas.         ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Function Tk280Contato(oExplorer,aPanels)

Local aArea	  	:= GetArea()													// Salva a area atual
Local oLbx		:= aPanels[Ascan(aPanels, {|x| x[2]=="AOBJ01"} )][1]			// Agenda do operador
Local cContato	:= "" 						                                   	// Codigo do Contato
Local cCliente	:= ""
Local cLoja		:= ""
Local cCad	  	:= cCadastro													// Salva o cCadastro atual
Local aRots   	:= aClone(aRotina)												// Salva o aRotinas atual
Local lInclui	:= INCLUI                                                      	// Salva a variavel de controle de inclusao
Local nOpcA	    := 0 															// Retorno da Inclusao ou Alteracao (OK - CANCELA)
Local lTMKALTA5	:= FindFunction("U_TMKALTA5")   								// P.E  Antes da alteracao do contato.
Local lTMKALTU5	:= FindFunction("U_TMKALTU5") 									// P.E  Depois da alteracao do contato.
Local lRet		:= .T.															// Retorno do P.E. 
Local aMemory	:= {}															// array com array das variaveis de memoria para refresh

aRotina	:= {	{ "Pesquisar"  	,"AxPesqui" ,0,1 },;
				{ "Visualizar" 	,"AxVisual" ,0,2 },;
				{ "Incluir"  	,"AxInclui" ,0,3 },; 
				{ "Alterar"  	,"AxAltera" ,0,4 }}  

//���������������������������������������������������������������������������Ŀ
//�Se estiver em qualquer um dos paineis que compoem o de Pendencias Agendadas�
//�����������������������������������������������������������������������������
If Str(oExplorer:nPanel,1) $ "1234"
	cContato:=	oLbx:aArray[oLbx:nAt][5]
	cCliente:= 	oLbx:aArray[oLbx:nAt][2]
	cLoja	:= 	oLbx:aArray[oLbx:nAt][3]
Else
	cContato:= M->U5_CODCONT
	cCliente:= M->A1_COD
	cLoja	:= M->A1_LOJA
Endif

If Empty(cCliente)
	Help("  ",1,"TK280CLIEN")//"N�o h� nenhum cliente dispon�vel para realizar essa operacao no painel selecionado, no momento"
	Return(.F.)
Endif
	
//����������������������������������������������������Ŀ
//�Pesquisa o contato. Se existir executa a alteracao  �
//�caso contrario executa a inclusao.                  �
//������������������������������������������������������
If !Empty(cContato)
	DbSelectArea("SU5")
	DbSetOrder(1)              
	If DbSeek(xFilial("SU5") + cContato)
		
		If lTMKALTA5
			lRet := U_TMKALTA5(SU5->(Recno()))
			
			// Se o retorno for .F. nao prossegue 
			If (ValType(lRet) <> "L")
				lRet := .F.
			Endif
		Endif
		
		If lRet
			INCLUI 	  := .F.
			cCadastro := STR0075 //"Alteracao de Contatos"
	
			nOpcA := AxAltera("SU5",SU5->(RecNo()),4)
			cContato:= SU5->U5_CODCONT	
			
			If nOpcA == 1	// OK
				//�������������������Ŀ
				//�Executa o P.E.     �
				//���������������������
				If lTMKALTU5
					U_TMKALTU5()
				Endif
			Endif
			
		Endif
	Endif	
Else
	INCLUI 	  := .T.
	cCadastro:= STR0074 //"Inclusao de Contatos"
	nOpcA:=AxInclui("SU5",1,3)
	cContato:= SU5->U5_CODCONT	
	
	If nOpcA == 1	// OK
		DbSelectarea("AC8")
		DbSetOrder(1)		// AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT
		If !MsSeek(xFilial("AC8") + cContato + "SA1" + xFilial("SA1") + cCliente+cLoja )
			DbSelectArea("AC8")
			RecLock("AC8",.T.)
			AC8->AC8_FILIAL := xFilial("AC8")              
			AC8->AC8_FILENT := xFilial("SA1")
			AC8->AC8_ENTIDA := "SA1"
			AC8->AC8_CODENT := cCliente+cLoja
			AC8->AC8_CODCON := cContato
			MsUnLock()
		Endif
	Endif
Endif			
	
If nOpcA == 1
	//���������������������������������������������������������������������������Ŀ
	//�Atualiza o painel de pendencias agendadas com dados do contato.            �
	//�����������������������������������������������������������������������������
	If Str(oExplorer:nPanel,1) $ "1234"
		oLbx:aArray[oLbx:nAt][5]:= cContato
		oLbx:aArray[oLbx:nAt][6]:= Posicione("SU5",1,xFilial("SU5")+cContato,"U5_CONTAT")
		oLbx:Refresh()
		//���������������������������������������������������������������������������Ŀ
		//�Atualiza a MSMGET do painel de Novo Pre-Atendimento com os dados do contato�
		//�����������������������������������������������������������������������������
	Else
		Tk280Memory("SU5", @aMemory, .T.)
		nPos := Ascan(aPanels, {|x| x[2]=="FOBJ03"} )
		aPanels[nPos][1]:Refresh()
	Endif
Endif

INCLUI 		:= lInclui
cCadastro	:= cCad
aRotina  	:= AClone(aRots)
RestArea(aArea)

Return(.T.) 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Dic  �Autor  �Microsiga           � Data �  10/15/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se o dicionario de dados esta preparado para       ���
���          �ordenar os titulos mais antigos de maior valor contidos na  ���
���          �tabela SK1.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA	                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Tk280Dic()

Local aArea	:= GetArea()
Local lRet	:= .F.

Dbselectarea("SIX")
DbsetOrder(1)
If MsSeek("SK1"+"5")
	If Alltrim(CHAVE) == "K1_FILIAL+DTOS(K1_VENCREA)+STR(K1_SALDEC,17,0)+K1_CLIENTE+K1_LOJA"             
		lRet:= .T.
	Endif
Endif

RestArea(aArea)	
Return(lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tk280Num  �Autor  �Andrea Farias       � Data �  07/04/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para validar o numero da lista SU4/SU6              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Function Tk280Num(cAlias,cCampo)

Local aArea		:= GetArea()    				//Salva a area atual
Local cNumAux	:= GetSxeNum(cAlias,cCampo) 	//Proximo numero da lista

cMay 	:= cAlias + ALLTRIM(xFilial(cAlias)) + cNumAux

//����������������������������������������������������������Ŀ
//�Procura um numero de lista que nao exista na base de dados�
//������������������������������������������������������������
While (MsSeek(xFilial(cAlias) + cNumAux) .OR. !MayIUseCode(cMay))
	cNumAux := Soma1(cNumAux,Len(cNumAux))
	cMay 	:= cAlias + ALLTRIM(xFilial(cAlias)) + cNumAux
End 

// Confirma o codigo da lista
If __lSX8
	ConfirmSX8()
Endif

RestArea(aArea)
Return(cNumAux)
