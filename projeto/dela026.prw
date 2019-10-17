#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA026   บAutor  ณNorbert Waage Junior   บ Data ณ  17/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de troca dos vendendores associados ao cliente          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo menu SIGALOJA.XNU especifico.             บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelA026()

Local aAreaSX3	:=	SX3->(GetArea())
Local aSay		:=	{}
Local aButton	:=	{}
Local aCombo	:=	{{},{}}
Local cTpVend	:=	""
Local cCodAtu	:=	Space(TamSx3("A1_VEND")[1])
Local cCodNovo	:=	cCodAtu
Local cSolic	:=	Space(TamSx3("PAE_SOLIC")[1]) 
Local lOk		:=	.F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona SX3ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
SX3->(DbSetOrder(2))
SX3->(DbSeek("A1_VEND"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta combo com campos de vendedores, caracterizadosณ
//ณpela mascara A1_VEND                                ณ
//ณ----------------------------------------------------ณ
//ณEstrutura do aCombo:                                ณ
//ณaCombo[1] - > Nome dos campos que contem "A1_VEND"  ณ
//ณaCombo[2] - > Descricao dos campos do 1o. vetor.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !SX3->(Eof()) .And. "A1_VEND" $ Alltrim(Upper(SX3->X3_CAMPO))
	AAdd(aCombo[1],SX3->X3_CAMPO)
	AAdd(aCombo[2],SX3->X3_TITULO)
	SX3->(DbSkip())
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTexto explicativo da rotinaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aSay, "Esta rotina tem por objetivo efetuar a troca do vendedor selecionado, baseando- " )
aAdd( aSay, "se nos parโmetros informados pelo usuario.                                      " )
aAdd( aSay, "Toda altera็ใo gerarแ um registro na tabela de hist๓rico de troca de vendedores," )
aAdd( aSay, "para controle de altera็๕es executadas.                                         " )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBotoes da tela principalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Parametros
aAdd( aButton, { 5,.T.,	{|| lOk := _TelaPar(aCombo,@cTpVend,@cCodAtu,@cCodNovo,@cSolic)}} )
//Confirma
aAdd( aButton, { 1,.T.,	{|| Iif(lOk,FechaBatch(),MsgInfo("Confirme os parโmetros antes de prosseguir"))}} )
//Cancela
aAdd( aButton, { 2,.T.,	{|| (lOk := .F.,FechaBatch())}} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre a telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
FormBatch( "Troca de Vendedores", aSay, aButton )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAcao executada caso o usuario confirme a telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lOk
	Processa({|lEnd|_TrocaVnd(aCombo,cTpVend,cCodAtu,cCodNovo,cSolic,@lEnd)},"Aguarde","Selecionando registros...",.T.)
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA026A  บAutor  ณNorbert Waage Junior   บ Data ณ  17/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณmBrowse de exibicao do historico de troca de vendedores        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo menu SIGALOJA.XNU especifico.           บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelA026A()

Private cCadastro := "Hist๓rico de troca de vendedores"

Private aRotina :=	{{"Pesquisar","AxPesqui",0,1},;
					{"Visualizar","AxVisual",0,2}}

dbSelectArea("PAE")
dbSetOrder(1)
mBrowse( 6,1,22,75,"PAE")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_TelaPar  บAutor  ณNorbert Waage Junior   บ Data ณ  17/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela de recebimento dos parametros da alteracao do vendedor    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaCombo    - Array composto pelos sub-arrays descritos abaixo   บฑฑ
ฑฑบ          ณaCombo[1] - Nomes dos campos no SX3 relacionados a vendendores บฑฑ
ฑฑบ          ณaCombo[2] - Descricao dos campos do aCombo[1], relacao 1-1.    บฑฑ
ฑฑบ          ณcTpVend   - Tipo de vendedor selecionado                       บฑฑ
ฑฑบ          ณcCodAtu   - Codigo atual                                       บฑฑ
ฑฑบ          ณcCodNovo  - Codigo a ser gravado                               บฑฑ
ฑฑบ          ณcSolic    - Nome do responsavel pela troca dos vendedores      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet(.T.) - Usuario confirmou a tela                           บฑฑ
ฑฑบ          ณlRet(.F.) - Usuario cancelou a tela                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada pelo botao de parametros da tela de troca.     บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _TelaPar(aCombo,cTpVend,cCodAtu,cCodNovo,cSolic)

Local oDlg1		:=	NIL
Local oCombo	:=	NIL
Local lOk := .F.

//Monta a tela
DEFINE MSDIALOG oDlg1 TITLE "Troca de Vendedores" FROM 0,0 TO 215,380 PIXEL OF oMainWnd

//Label
@ 05,05 TO 85,180 LABEL "" OF oDlg1 PIXEL

//Campo Tipo de Vendedor
@ 15,15 SAY "Vendedor"	SIZE 70,7 PIXEL OF oDlg1
@ 15,80 COMBOBOX oCombo VAR cTpVend ITEMS aCombo[2] SIZE 45,30 PIXEL OF oDlg1

//Campo Codigo Atual
@ 30,15 SAY "C๓digo Atual"	SIZE 70,7 PIXEL OF oDlg1
@ 30,80 MSGET cCodAtu F3 "SA3" Valid (Empty(cCodAtu) .Or. ExistCpo("SA3",cCodAtu)) SIZE 45,10 PIXEL OF oDlg1

//Campo Codigo Novo
@ 45,15 SAY "C๓digo Novo"	SIZE 70,7 PIXEL OF oDlg1
@ 45,80 MSGET cCodNovo F3 "SA3" Valid (Empty(cCodNovo) .Or. ExistCpo("SA3",cCodNovo)) SIZE 45,10 PIXEL OF oDlg1

//Campo Solicitante
@ 60,15 SAY "Solicitante"	SIZE 70,7 PIXEL OF oDlg1
@ 60,80 MSGET cSolic PICTURE "@!" SIZE 90,10 PIXEL OF oDlg1

//Botao Confirma
DEFINE SBUTTON 	FROM 90,120 TYPE 1 ENABLE OF oDlg1;
ACTION (Iif( (!Empty(cTpVend) .And. !Empty(cCodAtu) .And. !Empty(cCodNovo) .And. !Empty(cSolic)) ,;
	(lOk := .T., oDlg1:End()),;
	ApMsgAlert("Preencha todos os campos antes de prosseguir","Parโmetros")))

//Botao Cancela
DEFINE SBUTTON 	FROM 90,155 TYPE 2 ENABLE OF oDlg1 ACTION oDlg1:End()

//Abre a tela
Activate MsDialog oDlg1 Centered

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_TrocaVnd บAutor  ณNorbert Waage Junior   บ Data ณ  17/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de substituicao de vendedores do cadastro de clientes   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaCombo    - Array composto pelos sub-arrays descritos abaixo   บฑฑ
ฑฑบ          ณaCombo[1] - Nomes dos campos no SX3 relacionados a vendendores บฑฑ
ฑฑบ          ณaCombo[2] - Descricao dos campos do aCombo[1], relacao 1-1.    บฑฑ
ฑฑบ          ณcTpVend   - Tipo de vendedor selecionado                       บฑฑ
ฑฑบ          ณcCodAtu   - Codigo atual                                       บฑฑ
ฑฑบ          ณcCodNovo  - Codigo a ser gravado                               บฑฑ
ฑฑบ          ณcSolic    - Nome do responsavel pela troca dos vendedores      บฑฑ
ฑฑบ          ณlEnd      - Tratamento para cancelamento da rotina             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada pelo botao de confirmacao da tela de troca.    บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _TrocaVnd(aCombo,cTpVend,cCodAtu,cCodNovo,cSolic,lEnd)

Local cArq
Local nPos                   
Local lMark		:=	.T.
Local lRec		:=	.F.
Local aClientes	:=	{}
Local cCampo	:=	Alltrim(aCombo[1][AScan(aCombo[2],cTpVend)])
Local cFilSA1	:=	xFilial("SA1")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o usuario selecionou os mesmos codigos,ณ
//ณtornando rotina sem efeito                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If cCodAtu == cCodNovo
	ApMsgAlert("Os codigos de origem e destino sใo id๊nticos!","Abortando rotina")
	Return .F.
EndIf

DbSelectArea("SA1")	

//Atualiza texto da regua de processamento
IncProc("Selecionando registros...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria arquivo temporario, ordenando pelo vendedorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArq := CriaTrab(Nil,.F.)
IndRegua("SA1",cArq,"A1_FILIAL+" + cCampo)
DbSeek(cFilSA1+cCodAtu)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณArmazena clientes que atendem os parametrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !Eof() .And. SA1->A1_FILIAL == cFilSA1 .And. SA1->&(cCampo) == cCodAtu
	AAdd(aClientes,{lMark,SA1->A1_CGC,SA1->A1_NOME,SA1->(Recno())})
	DbSkip()
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณApaga arquivo temporarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RetIndex("SA1")
DbSetorder(1)
Ferase(cArq+OrdBagExt()) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe ha clientes para a troca, ordena por Nome/Razao Socialณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotCli := Len(aClientes)

If nTotCli > 0

	aSort(aClientes,,,{|x,y| x[3] < y[3]})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama a rotina _TelaSCli para a selecao final dos clientesณ
	//ณa terem o vendedor trocado                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !_TelaSCli(@aClientes,cTpVend)	
		ApMsgInfo("Rotina abortada","Troca de vendedores")
		Return Nil
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza o tamanho da Regua de processamentoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ProcRegua(nTotCli)
	
	Begin Transaction
	
	For nPos := 1 to nTotCli

		IncProc("Atualizando clientes")
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCaso o cliente esteja marcado, o codigo do vendedor ehณ
		//ณsubstituido                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If aClientes[nPos][1]
			
			SA1->(dbGoTo(aClientes[nPos][4]))
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTroca do vendedorณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			RecLock("SA1",.F.)
			SA1->&(cCampo) := cCodNovo
			MsUnLock() 
			lRec :=	.T.
			
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTratamento para o botao cancelaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lEnd .And. (lEnd := ApMsgNoYes("Deseja cancelar a execu็ใo do processo?","Interromper"))
			nPos := nTotCli + 1
			DisarmTransaction()
		EndIf
		
	Next nPos
	
	End Transaction
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe houve alguma alteracao, o log eh geradoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lRec

		IncProc("Gravando Log de altera็ใo...")

		DbSelectArea("PAE")
		RecLock("PAE",.T.)
		
		PAE->PAE_FILIAL	:=	xFilial("PAE")
		PAE->PAE_USER	:=	cUsername
		PAE->PAE_SOLIC	:=	cSolic
		PAE->PAE_DATA	:=	dDataBase
		PAE->PAE_HORA	:=	Time()
		PAE->PAE_TPVEND	:=	cTpVend
		PAE->PAE_VENDO	:=	cCodAtu
		PAE->PAE_VENDD	:=	cCodNovo		
		
		MsUnLock()
		
		ApMsgInfo("Altera็ใo realizada com sucesso","Troca de Vendedores")
	
	Else
	
		ApMsgInfo("Nenhum cliente foi selecionado para altera็ใo","Troca de Vendedores")
	
	EndIf   
	
Else
	
	MsgAlert("Nenhum cliente sofreu altera็ใo","Sem ocorrสncias")

EndIf
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_TelaSCli บAutor  ณNorbert Waage Junior   บ Data ณ  17/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela de selecao dos clientes contidos nos parametros iniciais, บฑฑ
ฑฑบ          ณpara a troca de vendedores                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaClientes - Array que contem os clientes pre-selecionados      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet(.T.) - Confirmacao da tela                                บฑฑ
ฑฑบ          ณlRet(.F.) - Cancelamento da tela                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada apos a confirmacao dos parametros iniciais da   บฑฑ
ฑฑบ          ณtela de troca de vendedores                                    บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _TelaSCli(aClientes)

Local oDlg2		:=	Nil
Local oLbx		:=	Nil
Local oOk		:= LoadBitmap( GetResources(), "LBOK" )		//Imagem "Marcado"
Local oNo		:= LoadBitmap( GetResources(), "LBNO" )		//Imagem "Desmarcado"
Local _oButMarc	:=	Nil										//Objeto Botao Marca
Local _oButDmrc	:=	Nil										//Objeto Botao Desmarca
Local _oButInve	:=	Nil										//Objeto Botao Inverte selecao
Local lRet		:=	.F.

//Define tela
DEFINE MSDIALOG oDlg2 FROM 0,0 TO 290,490 PIXEL TITLE "Confirma็ใo dos clientes" of oMainWnd
     
//Label
@ 04,03 TO 124,210 LABEL "Confirme a sele็ใo" OF oDlg2 PIXEL

//ListBox
@ 10,06 LISTBOX oLbx FIELDS HEADER " ","CNPJ/CPF","NOME";
SIZE 200,110 OF oDlg2 PIXEL ON dblClick(aClientes[oLbx:nAt,1] := !aClientes[oLbx:nAt,1],oLbx:Refresh())

//Metodos da ListBox
oLbx:SetArray(aClientes)
oLbx:bLine 	:= {|| {Iif(aClientes[oLbx:nAt,1],oOk,oNo),;
						aClientes[oLbx:nAt,2],;
						aClientes[oLbx:nAt,3]}}
                     
//Botoes
@ 125,005 Button _oButMarc Prompt "&Marcar Todos" 		Size 50,10 Pixel Action _Marca(1,@oLbx,@aClientes) Message "Selecionar todos os produtos" Of oDlg2
@ 125,055 Button _oButDmrc Prompt "&Desmarcar Todos"	Size 50,10 Pixel Action _Marca(2,@oLbx,@aClientes) Message "Desmarcar todos os produtos" Of oDlg2
@ 125,105 Button _oButInve Prompt "Inverter sele็ใo"	Size 50,10 Pixel Action _Marca(3,@oLbx,@aClientes) Message "Inverte a sele็ใo atual" Of oDlg2

//Botoes graficos
DEFINE SBUTTON 	FROM 10,215 TYPE 1 ENABLE OF oDlg2 ACTION(lRet := .T.,oDlg2:End())
DEFINE SBUTTON 	FROM 30,215 TYPE 2 ENABLE OF oDlg2 ACTION(oDlg2:End())

ACTIVATE MSDIALOG oDlg2	CENTERED

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Marca    บAutor  ณNorbert Waage Junior   บ Data ณ  17/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de marcacao ou nao do primeiro elemento do array recebi-บฑฑ
ฑฑบ          ณdo                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnOp  - Numero da opcao(1-Marca,2-Desmarca,3-Inverte)           บฑฑ
ฑฑบ          ณoLbx - Listbox a ser atualizada                                บฑฑ
ฑฑบ          ณaVet - Vetor a ser trabalhado pela rotina                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelos botoes da tela de selecao dos clientes    บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _Marca(nOp,oLbx,aVet)

Local lMarca,i

If nOp == 1 		//Marca todos
	lMarca	:=	.T.
ElseIf nOp == 2		//Desmarca Todos
	lMarca	:=	.F.
Endif

If lMarca != NIL
	For i := 1 To Len(aVet)
		aVet[i][1] := lMarca
	Next i
Else	//Inverte Selecao
	For i := 1 To Len(aVet)
		aVet[i][1] := !aVet[i][1]
	Next i
EndIf

oLbx:Refresh()	//Atualiza Listbox

Return Nil