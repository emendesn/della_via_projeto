#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELC001   บAutor  ณNorbert Waage Juniorบ Data ณ  09/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de pesquisa de Pecas x Veiculo, criada para facilitarบฑฑ
ฑฑบ          ณa busca de produtos pelo usuario na venda assistida, pre-   บฑฑ
ฑฑบ          ณchendo o aCols da tela principal com os produtos e todos os บฑฑ
ฑฑบ          ณkits vinculados aos mesmos.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcPar01	= Placa do veiculo                                บฑฑ
ฑฑบ          ณcPar02	= Marca do veiculo                                บฑฑ
ฑฑบ          ณcPar03	= Modelo do veiculo                               บฑฑ
ฑฑบ          ณcPar04	= Ano do veiculo                                  บฑฑ
ฑฑบ          ณcPar05	= Observacoes do veiculo                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณEsta rotina e chamada atraves da consulta SXB "FS1", vincu- บฑฑ
ฑฑบ          ณlada ao campo LR_PRODUTO na tela de venda assistida.        บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelC001(cPar01,cPar02,cPar03,cPar04,cPar05)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializacao de Variaveis                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oDlg1		:=	NIL										//Objeto dialogo (tela)
Local oButConf	:=	NIL										//Objeto botao confirma
Local oButCanc	:=	NIL										//Objeto botao cancela
Local oRadio	:=	NIL										//Objeto radio de selecao
Local aRadio	:=	{"Por Veํculo","Por Produto"}			//Opcoes do radio
Local nRadio	:=	1										//Opcao pre-selecionada do radio
Local nPos		:=	0										//Posicao do kit no array _aKits
Local lRet		:=	.F.

Private _aProds		:=	{}									//Conteudo da listbox
Private _aKits		:=	{}									//Kits de Servico
Private _nMoeda		:=	1									//Moeda utilizada na rotina
Private _oLbx		:=	NIL  								//Objeto listbox
Private _oOk		:= LoadBitmap( GetResources(), "LBOK" )	//Imagem "Marcado"
Private _oNo		:= LoadBitmap( GetResources(), "LBNO" )	//Imagem "Desmarcado"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializacao das variaveis utilizadas na pesquisa por produtoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private _oLblVei	:=	NIL									//Objeto label da selecao por veiculo
Private _oLblPro	:=	NIL									//Objeto label da selecao por produto
Private _oCombo		:=	NIL									//Combo de selecao da ordem de pesquisa de produtos
Private _cCombo		:=	Space(20)							//Texto selecionado no combo
Private _oPesq		:=	NIL									//Objeto Get da pesquisa
Private _cPesq		:=	Space(100)							//Texto da pesquisa
Private _oButPesq	:=	NIL   								//Objeto botao Pesquisar
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ_aCombo : Array manipulada pelo combo.                       ณ
//ณA primeira sub-array de _aCombo contem o texto correspondenteณ
//ณa a segunda sub-array, onde encontra-se o numero do indice   ณ
//ณno SIX                                                       ณ
//ณExemplo                                                      ณ
//ณ_aCombo[1][1] -> "Codigo"                                    ณ
//ณ_aCombo[1][2] -> 1                                           ณ
//ณ_aCombo[2][1] -> "Descricao"                                 ณ
//ณ_aCombo[2][2] -> 2                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private _aCombo		:=	{{},{}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializacao das variaveis utilizadas na pesquisa por veiculoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private _oSGrupo	:=	NIL									//Objeto Say do Grupo
Private _oGrupo		:=	NIL									//Objeto Get do Grupo
Private _cGrupo		:=	Space(TamSX3("B1_GRUPO")[1])		//Texto do Grupo
Private _oDGrupo	:=	NIL									//Objeto Get da descricao do grupo
Private _cDGrupo	:=	Space(TamSX3("BM_DESC")[1])			//Texto da descricao do grupo
Private _oSMarca	:=	NIL									//Objeto Say da marca
Private _oMarca		:=	NIL									//Objeto Get da marca
Private _cMarca		:=	Space(TamSX3("PA0_COD")[1])			//Texto da marca
Private _oDMarca	:=	NIL									//Objeto Get da descricao da marca
Private _cDMarca	:=	Space(TamSX3("PA0_DESC")[1])		//Texto da descricao da marca
Private _oSModel	:=	NIL									//Objeto Say do modelo
Private _oModel		:=	NIL									//Objeto Get do modelo
Private _cModel		:=	Space(TamSX3("PA1_COD")[1])			//Texto do modelo
Private _oDModel	:=	NIL									//Objeto Get da descricao do modelo
Private _cDModel	:=	Space(TamSX3("PA1_DESC")[1])		//Texto da descricao do modelo
Private _oSAno 		:=	NIL									//Objeto Say do ano
Private _oAno  		:=	NIL									//Objeto Get do ano
Private _cAno  		:=	Space(TamSX3("PA7_ANO")[1])			//Texto do ano
Private _oSObs 		:=	NIL									//Objeto Say da observacao
Private _oObs 		:=	NIL									//Objeto Get da observacao
Private _cObs  		:=	Space(TamSX3("PA7_OBSERV")[1]) 		//Texto da observacao
Private _oSPlaca	:=	NIL									//Objeto Say da placa
Private _oPlaca		:=	NIL									//Objeto Get da placa
Private _cPlaca		:=	Space(TamSX3("PA7_PLACA")[1])		//Texto da placa
Private _oCateg		:=	NIL									//Objeto Get da categoria
Private _cCateg		:=	Space(TamSX3("Z3_CODGRU")[1])		//Texto da categoria
Private _oSCateg	:=	NIL									//Objeto Say da categoria
Private _oDCateg	:=	NIL									//Objeto Get da descricao da categoria
Private _cDCateg	:=	Space(TamSX3("Z3_DESC")[1])			//Texto da descricao da categoria
Private _oSEspec	:=	NIL									//Objeto Say da especie
Private _oEspec		:=	NIL									//Objeto Get da especie
Private _cEspec		:=	Space(TamSX3("Z4_ESPECIE")[1])		//Texto da especie
Private _oDEspec	:=	NIL									//Objeto Get da descricao da especie
Private _cDEspec	:=	Space(TamSX3("Z4_DESC")[1])			//Texto da descricao da especie

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializacao do conteudo da listboxณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(_aProds,{.F., " "," ",0.00,0.00,0,""})
                          
//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg1 FROM 0,0 TO _CalcRes(490),_CalcRes(750) PIXEL TITLE "Pe็as x Veํculo" of oMainWnd

//ฺฤฤฤฤฤฤฟ
//ณLabelsณ
//ภฤฤฤฤฤฤู
@ _CalcRes(5), _CalcRes(5) TO _CalcRes(30),_CalcRes(150) LABEL "Tipo de pesquisa" OF oDlg1 PIXEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRadio de selecaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ _CalcRes(10),_CalcRes(10) RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2] SIZE _CalcRes(060),_CalcRes(009) ;
	PIXEL OF oDlg1 ON CHANGE _ChgPesq(@oDlg1,nRadio)                

//ฺฤฤฤฤฤฤฟ
//ณBotoesณ
//ภฤฤฤฤฤฤู
@ _CalcRes(5),_CalcRes(335) Button oButCanc Prompt "Cancelar" Size 36,10 Pixel Action(oDlg1:End()) Message "Aborta a consulta" of oDlg1
@ _CalcRes(5),_CalcRes(295) Button oButConf Prompt "Confirmar" Size 36,10 Pixel Action(lRet := P_DelC001C(.F.),Iif(lRet,oDlg1:End(),.F.)) Message "Confirma a consulta" of oDlg1

//ฺฤฤฤฤฤฤฤฟ
//ณListboxณ
//ภฤฤฤฤฤฤฤู
@ _CalcRes(85),_CalcRes(05) LISTBOX _oLbx FIELDS HEADER ;
"Ok","Codigo","Descri็ใo","Prc.Unitแrio","Total c/ Agr.","Saldo Disp.","Aplica็ใo";
SIZE _CalcRes(365),_CalcRes(150) OF oDlg1;                 
PIXEL ON dblClick(_aProds[_oLbx:nAt,1] := !_aProds[_oLbx:nAt,1],;
	IIf(_aProds[_oLbx:nAt,1],_CallTk(_oLbx:nAt),.F.),_oLbx:Refresh())  
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMetodos da ListBoxณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_oLbx:SetArray(_aProds)
_oLbx:bLine 	:= {|| {Iif(_aProds[_oLbx:nAt,1],_oOk,_oNo),;
					_aProds[_oLbx:nAt,2],;
					_aProds[_oLbx:nAt,3],;
					Transform(_aProds[_oLbx:nAt,4],"@E 9,999,999.99"),;
					Transform(_aProds[_oLbx:nAt,5],"@E 9,999,999.99"),;
					Transform(_aProds[_oLbx:nAt,6],"@E 9,999.99"),;
					_aProds[_oLbx:nAt,7]}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia objetos na tela de acordo com a op็ใo selecionadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_ChgPesq(@oDlg1,nRadio)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImporta valores recebidos via parametroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Iif(cPar01 == NIL,.F.,(_cPlaca := cPar01)) //,_VldPlaca(_cPlaca,@oDlg1)))
Iif(cPar02 == NIL,.F.,(_cMarca := cPar02,_VldMarca(_cMarca)))
Iif(cPar03 == NIL,.F.,(_cModel := cPar03,_VldModel(_cModel)))
Iif(cPar04 == NIL,.F.,(_cAno := cPar04))
Iif(cPar05 == NIL,.F.,(_cObs := cPar05))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtivacao da telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ACTIVATE MSDIALOG oDlg1 CENTERED 

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_ChgPesq  บAutor  ณNorbert Waage Juniorบ Data ณ  09/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAlterna entre os tipos de selecao, trocando os campos que   บฑฑ
ฑฑบ          ณsao utilizados em cada pesquisa.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณoDlg1 	= Objeto dialogo utilizado na tela                บฑฑ
ฑฑบ          ณnRadio	= Opcao de pesquisa selecionada pelo usuario      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina executada na troca de opcao do objeto radio.         บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _ChgPesq(oDlg1,nRadio)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSalva ambientesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aAreaSIX	:=	SIX->(GetArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConsulta por Veiculoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nRadio == 1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDesabilita objetos anterioresณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _oLblPro != NIL
	
		_oLblPro:lVisible	:=	.F.
		_oButPesq:lVisible	:=	.F.
		_oPesq:lVisible		:=	.F.
		_oCombo:lVisible	:=	.F.

		_oCombo		:=	NIL
		_oPesq		:=	NIL
		_oButPesq   :=	NIL
		_oLblPro	:=	NIL            
		
	EndIf	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria os objetos utilizados - Topoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ฺฤฤฤฤฤฟ
	//ณLabelณ
	//ภฤฤฤฤฤู
	@_CalcRes(35),_CalcRes(5)	GROUP _oLblVei To _CalcRes(65),_CalcRes(370) LABEL "Caracterํsticas do veํculo" PIXEL OF oDlg1
 
	//ฺฤฤฤฤฤฟ
	//ณPlacaณ
	//ภฤฤฤฤฤู
    @_CalcRes(44), _CalcRes(10) SAY		_oSPlaca Prompt "PLACA" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(10) MSGET	_oPlaca Var _cPlaca Size _CalcRes(40), _CalcRes(7) F3 "PA7" PICTURE PesqPict("PA7","PA7_PLACA") VALID _VldPlaca(_cPlaca,@oDlg1) PIXEL OF oDlg1

	//ฺฤฤฤฤฤฟ
	//ณMarcaณ
	//ภฤฤฤฤฤู
    @_CalcRes(44), _CalcRes(55) SAY		_oSMarca Prompt "MARCA" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(55) MSGET	_oMarca Var _cMarca Size _CalcRes(30), _CalcRes(7)	On Change _AtuMarca(3) F3 "PA0" Valid _VldMarca(_cMarca) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(85) MSGET	_oDMarca Var _cDMarca Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//ฺฤฤฤฤฤฤฟ
	//ณModeloณ
	//ภฤฤฤฤฤฤู
    @_CalcRes(44), _CalcRes(150) SAY	_oSModel Prompt "MODELO" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(150) MSGET	_oModel Var _cModel Size _CalcRes(30), _CalcRes(7) On Change _AtuMarca(2) F3 "FS2" Valid _VldModel(_cModel) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(185) MSGET	_oDModel Var _cDModel Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//ฺฤฤฤฟ
	//ณAnoณ
	//ภฤฤฤู
    @_CalcRes(44), _CalcRes(250) SAY	_oSAno Prompt "ANO" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(250) MSGET	_oAno Var _cAno On Change _AtuMarca(1) Size _CalcRes(20), _CalcRes(7)  PIXEL OF oDlg1  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณObservacoesณ
	//ภฤฤฤฤฤฤฤฤฤฤฤู
    @_CalcRes(44), _CalcRes(280) SAY	_oSObs Prompt "OBSERVAวรO" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(280) MSGET	_oObs Var _cObs Size _CalcRes(80), _CalcRes(7) READONLY PIXEL OF oDlg1  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria os objetos utilizados - Meioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ฺฤฤฤฤฤฟ
	//ณGrupoณ
	//ภฤฤฤฤฤู
    @_CalcRes(71), _CalcRes(10)	SAY		_oSGrupo Prompt "GRUPO:" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(45)	MSGET	_oGrupo Var _cGrupo Size _CalcRes(30), _CalcRes(7) F3 "SBM" Valid _VldGrupo(_cGrupo) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(80)	MSGET	_oDGrupo Var _cDGrupo Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//ฺฤฤฤฤฤฤฤฤฤฟ
	//ณCategoriaณ
	//ภฤฤฤฤฤฤฤฤฤู
    @_CalcRes(71), _CalcRes(180)	SAY		_oSCateg Prompt "CATEGORIA:" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(215)	MSGET	_oCateg Var _cCateg Size _CalcRes(30), _CalcRes(7) F3 "FS3" Valid _VldCateg(_cCateg) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(250)	MSGET	_oDCateg Var _cDCateg Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//ฺฤฤฤฤฤฤฤฟ
	//ณEspecieณ
	//ภฤฤฤฤฤฤฤู
    @_CalcRes(81), _CalcRes(10)	SAY		_oSEspec Prompt "ESPECIE:" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(80), _CalcRes(45)	MSGET	_oEspec Var _cEspec Size _CalcRes(30), _CalcRes(7) F3 "FS4" Valid _VldEspec(_cEspec) PIXEL OF oDlg1
    @_CalcRes(80), _CalcRes(80)	MSGET	_oDEspec Var _cDEspec Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณBotao Pesquisarณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ _CalcRes(80),_CalcRes(215) Button _oButPesq Prompt "Pesquisar" Size 45,10 Pixel;
		Action(	MsgRun("Selecionando registros",,{|| _ExCons(1)}));
		Message "Executa a pesquisa" of oDlg1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza tamanho da listboxณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_oLbx:nHeight	:= _CalcRes(295)
	_oLbx:nTop 		:= _CalcRes(190)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona o foco sobre o campo placaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    _oPlaca:SetFocus()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConsulta por produtoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Else	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRemove objetos anterioresณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _oLblVei != NIL
		_oLblVei:lVisible	:= .F.;	_oLblVei	:=	NIL
		_oPlaca:lVisible	:= .F.;	_oPlaca		:=	NIL
		_oSPlaca:lVisible	:= .F.;	_oSPlaca	:=	NIL
		_oSMarca:lVisible	:= .F.;	_oSMarca	:=	NIL
		_oMarca:lVisible	:= .F.;	_oMarca		:=	NIL
		_oDMarca:lVisible	:= .F.;	_oDMarca	:=	NIL
		_oSModel:lVisible	:= .F.;	_oSModel	:=	NIL
		_oModel:lVisible	:= .F.;	_oModel		:=	NIL
		_oDModel:lVisible	:= .F.;	_oDModel	:=	NIL
		_oSAno:lVisible		:= .F.;	_oSAno 		:=	NIL
		_oAno:lVisible		:= .F.;	_oAno		:=	NIL
		_oSObs:lVisible		:= .F.;	_oSObs		:=	NIL
		_oObs:lVisible		:= .F.;	_oObs		:=	NIL
		_oGrupo:lVisible 	:= .F.;	_oGrupo		:=	NIL
		_oDGrupo:lVisible 	:= .F.;	_oDGrupo	:=	NIL
	    _oSGrupo:lVisible	:= .F.;	_oSGrupo	:=	NIL
		_oSCateg:lVisible	:= .F.;	_oSCateg	:=	NIL
		_oCateg:lVisible 	:= .F.;	_oCateg		:=	NIL
		_oDCateg:lVisible 	:= .F.;	_oDCateg	:=	NIL
		_oSEspec:lVisible	:= .F.;	_oSEspec	:=	NIL
		_oEspec:lVisible 	:= .F.;	_oEspec		:=	NIL
		_oDEspec:lVisible 	:= .F.;	_oDEspec	:=	NIL		
		_oButPesq:lVisible	:= .F.;	_oButPesq	:=	NIL
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria os novos objetosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta combo com os indices para o SB1ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aCombo	:=	{{},{}}
	DbSelectArea("SIX")
	DbSetOrder(1)//INDICE+ORDEM
	DbSeek("SB1")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdiciona descricao dos indices em aCombo[1]ณ
	//ณAcidiona numero dos indices em aCombo[2]   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While !Eof() .And. SIX->INDICE == "SB1"
		AAdd(_aCombo[1],AllTrim(SIX->DESCRICAO))
		AAdd(_aCombo[2],SIX->ORDEM)
		DbSkip()
	End
	
	//ฺฤฤฤฤฤฟ
	//ณLabelณ
	//ภฤฤฤฤฤู
	_oLblPro := TGroup():New(_CalcRes(35),_CalcRes(5),_CalcRes(60),_CalcRes(370),"Chave de Pesquisa",oDlg1,,,	.T.,.F.)

	//ฺฤฤฤฤฤฟ
	//ณComboณ
	//ภฤฤฤฤฤู
	_oCombo := TComboBox():New(_CalcRes(45), _CalcRes(10),{|x|If(PCount()>0, _cCombo := x,_cCombo)},_aCombo[1],;
		_CalcRes(100),_CalcRes(10),oDlg1,,,,,,.T.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGet da pesquisaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    @_CalcRes(45), _CalcRes(115) MSGET	_oPesq Var _cPesq Size _CalcRes(130), _CalcRes(7) PICTURE "@!" PIXEL OF oDlg1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณBotao Pesquisarณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ _CalcRes(45),_CalcRes(250) Button _oButPesq Prompt "Pesquisar" Size 45,10 Pixel;
		Action(	MsgRun("Selecionando registros",,{|| _ExCons(2)}));
		Message "Executa a pesquisa" of oDlg1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza tamanho da listboxณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_oLbx:nHeight	:= _CalcRes(345)	
	_oLbx:nTop 		:= _CalcRes(143)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona o foco sobre o campo pesquisaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_oPesq:SetFocus()
	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza objeto oDlg1 para aplicar as atualiza็oes realizadasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDlg1:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura ambienteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaSIX)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldMarca บAutor  ณNorbert Waage Juniorบ Data ณ  10/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da marca digitada                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_cMarca	= Codigo da marca a ser validado                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet		= Verdadeiro caso a marca possa ser utilizada     บฑฑ
ฑฑบ          ณ            Falso se a marca nao existir ou nao for valida  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na validacao do campo Marca, executada apos  บฑฑ
ฑฑบ          ณa digitacao deste pelo operador do sistema.                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldMarca(_cMarca)

Local lRet	:=	(Empty(_cMarca) .Or. ExistCpo("PA0",_cMarca))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza conteudo do campo _cDMarcaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cDMarca	:=	Iif(lRet,GetAdvFVal("PA0","PA0_DESC",xFilial("PA0")+_cMarca,1,""),"")
_oDMarca:Refresh()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldModel บAutor  ณNorbert Waage Juniorบ Data ณ  10/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da marca digitada                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_cModel	= Codigo do modelo a ser validado                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet		= Verdadeiro caso o modelo possa ser utilizado    บฑฑ
ฑฑบ          ณ            Falso se o modelo nao existir ou for invalido   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na validacao do campo Modelo, executada apos บฑฑ
ฑฑบ          ณa digitacao deste pelo operador do sistema.                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldModel(_cModel)

Local aAreaPA1	:=	PA1->(GetArea())
Local lRet	:=	.T.

If !Empty(_cModel)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza conteudo do campo _cDModelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	If (Posicione("PA1",1,xFilial("PA1")+_cModel,"PA1_CODMAR") == _cMarca)
	
		_cDModel	:=	PA1->PA1_DESC
	
	Else

	    ApMsgInfo("O c๓digo do modelo informado nใo existe ou nใo estแ relacionado เ marca selecionada","Modelo invแlido")
	    _cDModel	:=	Space(TamSX3("PA1_DESC")[1])
		lRet := .F.
		
	EndIf
	
	_oDModel:Refresh()                   

EndIf

RestArea(aAreaPA1)

Return lRet   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldGrupo บAutor  ณNorbert Waage Juniorบ Data ณ  10/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao do grupo digitado                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_cGrupo	= Codigo do grupo a ser validado                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet		= Verdadeiro caso o grupo  possa ser utilizado    บฑฑ
ฑฑบ          ณ            Falso se o grupo  nao existir ou for invalido   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na validacao do campo Grupo , executada apos บฑฑ
ฑฑบ          ณa digitacao deste pelo operador do sistema.                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldGrupo(cGrupo)

Local lRet	:=	(Empty(cGrupo) .Or. ExistCpo("SBM",cGrupo))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza conteudo do campo _cDGrupoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cDGrupo	:=	Iif(lRet,GetAdvFVal("SBM","BM_DESC",xFilial("SBM")+cGrupo,1,""),"")
_oDGrupo:Refresh()  

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldCateg บAutor  ณNorbert Waage Juniorบ Data ณ  16/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da categoria selecionada                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_cCateg	= Codigo da categoria a ser validado              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet		= Verdadeiro caso a categ. possa ser utilizada    บฑฑ
ฑฑบ          ณ            Falso se a categ. nao existir ou for invalida   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na validacao do campo Categoria, acionada    บฑฑ
ฑฑบ          ณna digitacao deste pelo operador do sistema.                บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldCateg(cCateg)

Local lRet	:=	(Empty(cCateg) .Or. ExistCpo("SZ3",_cGrupo+cCateg))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza conteudo do campo _cDCategณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cDCateg	:=	Iif(lRet,GetAdvFVal("SZ6","Z6_DESC",xFilial("SZ6")+cCateg,1,""),"")
_oDCateg:Refresh()       

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldEspec บAutor  ณNorbert Waage Juniorบ Data ณ  16/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da categoria selecionada                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_cEspec	= Codigo da especie a ser validada                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet		= Verdadeiro caso a especie possa ser utilizada   บฑฑ
ฑฑบ          ณ            Falso se a especie nao existir ou for invalida  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na validacao do campo Especie, acionada      บฑฑ
ฑฑบ          ณna digitacao deste pelo operador do sistema.                บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldEspec(cEspec)

Local lRet	:=	(Empty(cEspec) .Or. ExistCpo("SZ4",_cCateg+cEspec))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza conteudo do campo _cDCategณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cDEspec	:=	Iif(lRet,GetAdvFVal("SZ7","Z7_DESC",xFilial("SZ7")+cEspec,1,""),"")
_oDEspec:Refresh()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldPlaca บAutor  ณNorbert Waage Juniorบ Data ณ  11/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao da placa digitada, atualizacao dos demais campos  บฑฑ
ฑฑบ          ณcom os dados do veiculo do cliente, caso este seja confimadoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_cPlaca	= Codigo da placa a ser validado                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณSempre verdadeiro: A nao existencia do cadastro do veiculo  บฑฑ
ฑฑบ          ณnao impede a consulta de produtos.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na validacao do campo Placa , executada apos บฑฑ
ฑฑบ          ณa digitacao deste pelo operador do sistema.                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldPlaca(cPlaca,oDlg)

Local aArea		:=	GetArea()
Local aAreaPA7	:=	PA7->(GetArea())
Local lRet		:=	Empty(cPlaca)

cPlaca	:=	Alltrim(Upper(cPlaca))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe o campo placa estiver preenchidoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRet	
	
	DbSelectArea("PA7")
	DbSetOrder(2)	//PA7_FILIAL+PA7_PLACA
	
	If DbSeek(xFilial("PA7")+cPlaca)    
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza conteudo das variaveisณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cMarca		:= PA7->PA7_CODMAR
		_cDMarca	:= GetAdvFVal("PA0","PA0_DESC",xFilial("PA0") + PA7->PA7_CODMAR,1,"")
		_cModel		:= PA7->PA7_CODMOD
		_cDModel	:= GetAdvFVal("PA1","PA1_DESC",xFilial("PA1")+PA7->PA7_CODMOD,1,"")
		_cAno		:= PA7->PA7_ANO
		_cObs		:= PA7->PA7_OBSERV
		
	Else
	
		ApMsgInfo("Veํculo nใo cadastrado","Aten็ใo")

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza conteudo das variaveisณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cMarca		:= Space(TamSX3("PA0_COD")[1])
		_cDMarca	:= ""
		_cModel		:= Space(TamSX3("PA1_COD")[1])
		_cDModel	:= ""
		_cAno		:= Space(TamSX3("PA7_ANO")[1])	
		_cObs		:= Space(TamSX3("PA7_OBSERV")[1])

	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza objetosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _oMarca != NIL
		_oMarca:Refresh()
		_oDMarca:Refresh()
		_oModel:Refresh()
		_oDModel:Refresh()
		_oAno:Refresh()
		_oObs:Refresh()
		oDlg:Refresh()
	EndIf
	
End

RestArea(aAreaPA7)
RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CalcRes  บAutor  ณNorbert Waage Juniorบ Data ณ  10/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para calculo de resolucao, utilizada para ajustar a  บฑฑ
ฑฑบ          ณtela de acordo com a resolucao utilizada no monitor         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnTam		= Valor de coordenada a ser convertido/ajustado   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณnTam		= Valor convertido                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณEsta rotina eh chamada para todas as coordenadas de tela u- บฑฑ
ฑฑบ          ณtilizada neste programa, viabilizando assim a sua execucao  บฑฑ
ฑฑบ          ณem qualquer resolucao de tela.                              บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _CalcRes(nTam)

Local nHRes	:=	GetScreenRes()[1]	//Resolucao horizontal do monitor

Do Case
	Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
	Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
	OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
End Case            

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
   	nTam *= 0.95
EndIf

Return Int(nTam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_ExCons   บAutor  ณNorbert Waage Juniorบ Data ณ  12/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณExecucao da consulta em ambiente SQL ou CodeBase, com o in- บฑฑ
ฑฑบ          ณtuito de selecionar somente os registros pertinentes ao     บฑฑ
ฑฑบ          ณconteudo das pesquisas.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnTipo 	= Indica se a consulta e por veiculo(1) ou por    บฑฑ
ฑฑบ          ณ            produto(2)                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada pelo botao Pesquisar, no dialogo. A rotina  บฑฑ
ฑฑบ          ณverifica o tipo de base e o tipo de pesquisa, armazenando   บฑฑ
ฑฑบ          ณno array _aProds o resultado da consulta.                   บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _ExCons(nTipo)

Local aArea		:=	GetArea()
Local aAreaPA2	:=	PA2->(GetArea())
Local aAreaPA3	:=	PA3->(GetArea())
Local aAreaSB1	:=	SB1->(GetArea())
Local aAreaSB2	:=	SB2->(GetArea())
Local aItens	:=	{}
Local nDisp		:=	0
Local nX
Local nLenCols	:=	0
Local cQuery  
Local cChave	:=	""
Local cLocal	:=	GetMv("FS_DEL028") //Local padrao para pesquisa
Local lContinua	:= .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLimpa o conteudo da listboxณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_aProds	:=	{}
_aKits	:=	{}

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrepara SB2ณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
SB2->(DbSetOrder(1))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConsulta x Veiculoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nTipo == 1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRotina para TopConnectณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	#IFDEF TOP
        
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCriacao de filtro a partir dos campos preenchidosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !Empty(_cGrupo)
		
			cChave := "AND SB1.B1_GRUPO = '" + _cGrupo + "' "
			
			If !Empty(_cCateg)
		
				cChave += " AND SB1.B1_CATEG = '" + _cCateg + "' "
		         
				If !Empty(_cEspec)
					
					cChave += " AND SB1.B1_SPECIE2 = '" + _cEspec + "' "
					
				EndIf
		
			EndIf
		
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTratamento do campo Anoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !Empty(_cAno)
			cChave	+=	" AND PA2.PA2_ANODE <= '" + _cAno + "' AND PA2.PA2_ANOATE >= '" + _cAno + "' "
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณConstrucao da queryณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery	:= "SELECT SB1.B1_COD, SB1.B1_DESC, PA2.PA2_APLIC "	+	CRLF
		cQuery	+=	"FROM " + RetSqlName("SB1") + " SB1"	+	CRLF
		cQuery	+=	"Inner Join " + RetSqlName("PA2") + " PA2 On"	+	CRLF
		cQuery	+=	IIF(xFilial("SB1") == xFilial("PA2"),"SB1.B1_FILIAL = PA2.PA2_FILIAL AND","") + " SB1.B1_COD = PA2.PA2_CODPRO"	+	CRLF
		cQuery	+=	"WHERE SB1.D_E_L_E_T_ != '*' And PA2.D_E_L_E_T_ != '*' "	+	CRLF
		cQuery	+=	" And PA2.PA2_CODMOD = '" + _cModel + "'"	+	CRLF
		cQuery	+=	cChave	+	CRLF
		cQuery	+=	"ORDER BY SB1.B1_COD"
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecucao da Queryณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPercorre o retorno da queryณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea("TMP")           
		
		If !TMP->(Eof())
			
			While !TMP->(Eof())
				
				If	SB2->(DbSeek(xFilial("SB2")+TMP->B1_COD+cLocal))
					nDisp       := P_DCalcEst(xFilial("SB2"),TMP->B1_COD,cLocal)				
				Else
					nDisp	:=	0
				EndIf

				aAdd(_aProds,;
					{.F.,;
					TMP->B1_COD,;
					AllTrim(TMP->B1_DESC),;
					0.00,;
					0.00,;
					nDisp,;
					TMP->PA2_APLIC})
					
				DbSkip()

			End      
			
		EndIf
		
		TMP->(DbCloseArea())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRotina para Codebase/Ctreeณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	#ELSE 
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona demais areas utilizadas na consultaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea("SB1")
		DbSetOrder(1)	//B1_FILIAL+B1_COD
		
		DbSelectArea("PA2")
		DbSetOrder(3)	//PA2_FILIAL+PA2_CODMOD+PA2_CODPRO 
		
		If DbSeek(xFilial("PA2")+_cModel)

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCriacao de filtro a partir dos campos preenchidosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			If !Empty(_cGrupo)    
			
				cChave := "(SB1->B1_GRUPO == _cGrupo)"
				
				If !Empty(_cCateg)
			
					cChave += " .And. (SB1->B1_CATEG == _cCateg)"
			         
					If !Empty(_cEspec)
						
						cChave += " .And. (SB1->B1_SPECIE2 == _cEspec)"
						
					EndIf
			
				EndIf
			
			Else
				
				cChave	:=	".T."
				
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVarre produtos x veiculos relacionados ao modelo ณ
			//ณespecificado                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			While !PA2->(Eof())		 			.And.;
			PA2->PA2_FILIAL == xFilial("PA2")	.And.;
			PA2->PA2_CODMOD	==	_cModel
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณTratamento do campo Anoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If (!Empty(_cAno) .And. (Val(_cAno) >= Val(PA2->PA2_ANODE)) .And.;
					(Val(_cAno) <= Val(PA2->PA2_ANOATE))) .Or. Empty(_cAno)
					
					If SB1->(DbSeek(xFilial("SB1")+PA2->PA2_CODPRO)) .And. &(cChave)
					
						If	SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+cLocal))
							nDisp       := P_DCalcEst(xFilial("SB2"),SB1->B1_COD,cLocal)				
						Else
							nDisp	:=	0
						EndIf
						
						aAdd(_aProds,;
							{.F.,;
							SB1->B1_COD,;
							AllTrim(SB1->B1_DESC),;
							0.00,;
							0.00,;
							nDisp,;
							PA2->PA2_APLIC})
														
					EndIf   
					
				EndIf
				
				PA2->(DbSkip())
				
			End
		
		EndIf
		
	#ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConsulta x Produtoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Elseif nTipo == 2                
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTrata falta de parametros, alertando o usuario quanto a aณ
	//ณprovavel demora na execucao da rotina                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(_cPesq)
		
		lContinua :=	MsgNoYes("Nenhum par๊metro foi informado para a pesquisa, o que pode fazer com que sua "+;
						"execu็ใo demore alguns minutos. Deseja prosseguir?","Aten็ao")
		
	EndIf
	
	If lContinua

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRotina para TopConnectณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		#IFDEF TOP
	
			cChave	:=	_SetChave(_cPesq,"SB1",_aCombo[2][aScan(_aCombo[1],{|x|x == _cCombo})])
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณGeracao da Queryณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQuery	:=	"SELECT SB1.B1_COD, SB1.B1_DESC " + CRLF		
			cQuery	+=	"FROM " + RetSqlName("SB1") + " SB1" + CRLF
			cQuery	+=	"WHERE SB1.D_E_L_E_T_ != '*' AND " + cChave + CRLF
			cQuery	+=	"ORDER BY SB1.B1_COD"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
		
			DbSelectArea("TMP") 
	
			If !TMP->(Eof())
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPercorre o retorno da queryณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				While !TMP->(Eof())
	
					If	SB2->(DbSeek(xFilial("SB2")+TMP->B1_COD+cLocal))
						nDisp       := P_DCalcEst(xFilial("SB2"),TMP->B1_COD,cLocal)				
					Else
						nDisp	:=	0
					EndIf
				
					aAdd(_aProds,;
						{.F.,;
						TMP->B1_COD,;
						AllTrim(TMP->B1_DESC),;
						0.00,;
						0.00,;
						nDisp,;
						""})
						
					DbSkip()
	
				End      
				
			EndIf
			
			TMP->(DbCloseArea())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRotina para Codebaseณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		#ELSE
	
			DbSelectArea("SB1")
			DbSetOrder(Val(_aCombo[2][aScan(_aCombo[1],{|x|x == _cCombo})]))
			cChave	:=	IndexKey()		
			cQuery	:=	IIf("_FILIAL" $ cChave,xFilial("SB1"),"")+ AllTrim(_cPesq)
	
			DbSeek(cQuery)
			
			While !Eof() .And.	Left(SB1->(&(cChave)),Len(cQuery)) == cQuery
			
				If	SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+cLocal))
					nDisp       := P_DCalcEst(xFilial("SB2"),SB1->B1_COD,cLocal)				
				Else
					nDisp	:=	0
				EndIf
				
				aAdd(_aProds,;
					{.F.,;
					SB1->B1_COD,;
					AllTrim(SB1->B1_DESC),;
					0.00,;
					0.00,;
					nDisp,;
					""})
	
				DbSkip()
				
			End
					
		#ENDIF	
	
	EndIf
		
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTrata resultados da pesquisaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLenCols :=	Len(_aProds)

If nLenCols == 0	
	ApMsgInfo("Nใo foram encontrados dados para sua pesquisa","Pesquisa finalizada")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza preco unitario e calcula agregados (kits de servicos)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to nLenCols       
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPreco unitarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aProds[nX][4]	:=	P_DELA027(M->LQ_CODTAB,_aProds[nX][2],1,M->LQ_CLIENTE,M->LQ_LOJA,_nMoeda,M->LQ_DTLIM)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAssocia Kitณ
	//ภฤฤฤฤฤฤฤฤฤฤฤู
	If Len(aItens := P_DELC001D(_aProds[nX][2])) > 0 
		AAdd(_aKits,{nX,aItens})
	EndIf                        

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCalcula preco com agregadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aProds[nX][5]	:=	_aProds[nX][4] + _CalcAgr(nX)

Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza ListBoxณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_oLbx:SetArray(_aProds)
_oLbx:nAt		:= 1
_oLbx:bLine 	:= {|| {Iif(_aProds[_oLbx:nAt,1],_oOk,_oNo),;
					_aProds[_oLbx:nAt,2],;
					_aProds[_oLbx:nAt,3],;
					Transform(_aProds[_oLbx:nAt,4],"@E 9,999,999.99"),;
					Transform(_aProds[_oLbx:nAt,5],"@E 9,999,999.99"),;
					Transform(_aProds[_oLbx:nAt,6],"@E 9,999.99"),;
					_aProds[_oLbx:nAt,7]}}				
_oLbx:Refresh()

RestArea(aAreaPA2)
RestArea(aAreaPA3)
RestArea(aAreaSB1)
RestArea(aAreaSB2)
RestArea(aArea) 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_SetChave บAutor  ณNorbert Waage Juniorบ Data ณ  12/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCriacao de chave de comparacao do valor pesquisado com o    บฑฑ
ฑฑบ          ณconteudo do indice selecionado no combobox _oCombo, ajustan-บฑฑ
ฑฑบ          ณdo a sintaxe para o banco DB2.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcPar  	= Chave de pesquisa informada pelo usuario        บฑฑ
ฑฑบ          ณcAlias	= Alias da tabela pesquisada                      บฑฑ
ฑฑบ          ณcOrd		= Ordem da tabela pesquisada                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณString contendo a condicao complementar da clausula WHERE,  บฑฑ
ฑฑบ          ณna Query a ser enviada para o banco de dados DB2            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina utilizada somente quando a base for TopConnect.      บฑฑ
ฑฑบ          ณSera gerada uma string, concatenando valor do indice da     บฑฑ
ฑฑบ          ณtabela recebida no parametro cAlias                         บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _SetChave(cPar,cAlias,cOrd)
            
Local aArea		:=	GetArea()
Local nPos
Local nQtd  	:=	0
Local cIndice	:=	AllTrim(GetAdvFVal("SIX","CHAVE",cAlias+cOrd,1,""))
Local cChave	:=	""
Local lSQL7		:=	AllTrim(Upper(TcGetDb())) == "MSSQL7"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa a chave do indiceณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While (nPos := AT("+",cIndice)) !=0 .Or. !Empty(cIndice)

	If nQtd++ == 0
		
		cChave := cAlias + "." + SubStr(cIndice,1,Iif(nPos == 0,Len(cIndice),nPos-1))
		
	Else
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChave para SQLณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lSql7	
			cChave += "+" + cAlias + "." + SubStr(cIndice,1,Iif(nPos == 0,Len(cIndice),nPos-1))
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChave para DB2ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Else
			cChave := "CONCAT(" + cChave + "," + cAlias + "." + SubStr(cIndice,1,Iif(nPos == 0,Len(cIndice),nPos-1)) + ")"
		EndIf
		
	EndIf
	        
	If nPos > 0
		cIndice := SubStr(cIndice,nPos+1,Len(cIndice))
	Else
		cIndice	:=	""
	EndIf

EndDo

Restarea(aArea)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRetorna a expressao a ser incluida na clausula WHEREณ
//ณda Select para DB2                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Return cChave + " LIKE '%"+ IIf("_FILIAL" $ cChave,xFilial(cAlias),"") + Alltrim(cPar) + "%'"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CallTK   บAutor  ณNorbert Waage Juniorบ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de pre-chamada a rotina DELC001E. A rotina procura   บฑฑ
ฑฑบ          ณpelo kit relacionado a posicao atual no array _aProds.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnLin  	= Numero da linha da ListBox onde o usuario clicouบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada pelo duplo click na listbox                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _CallTK(nLin)

Local nPos		:=	AScan(_aKits,{|x|x[1] == nLin })
Local nPosOk	:=	1
Local nX
Local lRet

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe existe kitณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nPos != 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe o usuario nao confirmou a telaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !P_DELC001E(@_aKits[nPos][2])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRemove todos os itens do Kitณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nX := 1 to Len(_aKits[nPos][2])
			_aKits[nPos][2][nX][nPosOk] := .F.
		Next
	
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRecalcula agregadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aProds[nLin][5] := _aProds[nLin][4] + _CalcAgr(nLin)

EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELC001E  บAutor  ณNorbert Waage Juniorบ Data ณ  12/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณInterface de exibicao dos componentes do kit de servicos    บฑฑ
ฑฑบ          ณvinculado ao produto selecionado na listbox.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaVetor	= Vetor contendo os dados do kit                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro se o usuario confirmar a selecao                 บฑฑ
ฑฑบ          ณFalso caso contrario                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina executada no duplo clique sobre a listbos e tambem   บฑฑ
ฑฑบ          ณpelo gatilho P_DELC001B                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELC001E(aVetor)

Local oDlg2	:=	NIL
Local oLbx2	:=	NIL
Local _oOk		:= LoadBitmap( GetResources(), "LBOK" )	//Imagem "Marcado"
Local _oNo		:= LoadBitmap( GetResources(), "LBNO" )	//Imagem "Desmarcado"
Local lRet	:=	.F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณA rotina aborta, caso o vetor esteja vazio    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aVetor) == 0 
	Return lRet
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg2 FROM 0,0 TO _CalcRes(160),_CalcRes(445) PIXEL TITLE "KIT SERVIวO" of oMainWnd

//ฺฤฤฤฤฤฤฤฟ
//ณListboxณ
//ภฤฤฤฤฤฤฤู
@ _CalcRes(5),_CalcRes(5) LISTBOX oLbx2 FIELDS HEADER ;
"Ok","Codigo","Descri็ใo","Prc.Unitแrio","Quant.","Vlr. Total";
SIZE _CalcRes(175),_CalcRes(70) OF oDlg2;
PIXEL ON dblClick(aVetor[oLbx2:nAt,1] := !aVetor[oLbx2:nAt,1],oLbx2:Refresh())  
          
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMetodos da ListBoxณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oLbx2:SetArray(aVetor)
oLbx2:bLine 	:= {|| {Iif(aVetor[oLbx2:nAt,1],_oOk,_oNo),;
					aVetor[oLbx2:nAt,2],;
					aVetor[oLbx2:nAt,3],;
					Transform(aVetor[oLbx2:nAt,4],"@E 9,999,999.99"),;
					Transform(aVetor[oLbx2:nAt,5],"@E 9,999.99"),;
					Transform(aVetor[oLbx2:nAt,6],"@E 9,999,999.99")}}
					
//ฺฤฤฤฤฤฤฟ
//ณBotoesณ
//ภฤฤฤฤฤฤู
@ _CalcRes(5),_CalcRes(185) Button oButConf Prompt "Confirmar" Size _CalcRes(36),_CalcRes(10) Pixel;
	Action(lRet := .T., oDlg2:End()) Message "Confirma a sele็ใo" of oDlg2
	
@ _CalcRes(20),_CalcRes(185) Button oButCanc Prompt "Cancelar" Size _CalcRes(36),_CalcRes(10) Pixel Action(oDlg2:End()) Message "Aborta a sele็ใo" of oDlg2

oButConf:SetFocus()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtivacao da telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ACTIVATE MSDIALOG oDlg2 CENTERED

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELC001D  บAutor  ณNorbert Waage Juniorบ Data ณ  12/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para leitura dos kits relacionados ao  produto       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcProd 	= Codigo do produto associado a esta linha        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณArray contendo o kit do produto recebido via parametro      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณEsta rotina retorna um array contendo os produtos do kit as-บฑฑ
ฑฑบ          ณsociado ao produto recebido em parametro.                   บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELC001D(cProd)

Local aItens	:=	{}
Local cAgreg	:=	GetAdvFVal("SB1","B1_AGREG",xFilial("SB1")+cProd,1,"")
Local nPreco	:=	0
Local _nMoeda	:=	1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAborta execucao se nao houver kit para o produtoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cAgreg)
	Return aItens
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre tabela de agregadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA3")
DbSetOrder(1)	//PA3_FILIAL+PA3_GRUPO+PA3_ITEM

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe houverem itens agregadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If DbSeek(xFilial("PA3")+cAgreg)
	
	While !Eof() .And. PA3->PA3_FILIAL == xFilial("PA3") .And.;
		PA3->PA3_GRUPO == cAgreg
		
		nPreco := P_DELA027(M->LQ_CODTAB,PA3->PA3_CODPRO,1,M->LQ_CLIENTE,M->LQ_LOJA,_nMoeda,M->LQ_DTLIM)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInsere produtos no Arrayณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		AAdd(aItens,;
			{.F.,;
			PA3->PA3_CODPRO,;
			Alltrim(Posicione("SB1",1,xFilial("SB1")+PA3_CODPRO,"B1_DESC")),;
			nPreco,;
			PA3->PA3_QUANT,;
			nPreco * PA3->PA3_QUANT})

		DbSkip()
	
	End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSenao retorna array vazioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Else          

	Return aItens	

EndIf

Return aItens

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CalcAgr  บAutor  ณNorbert Waage Juniorบ Data ณ  13/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de calculo da soma do valor dos itens do kit de ser- บฑฑ
ฑฑบ          ณvico relacionado a linha recebida em parametro              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnPos		= Numero da linha no vetor da listbox             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณnVal		= Soma do valor dos itens selecionados            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณExecutada na criacao inical do vetor principal de produtos  บฑฑ
ฑฑบ          ณe tambem a cada vez que a estrutura do kit sofre alteracao  บฑฑ
ฑฑบ          ณna sua composicao.                                          บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _CalcAgr(nLin)

Local nX
Local nLenKit	:=	0
Local nVal		:=	0
Local nPosOk	:=	1
Local nPosPrc	:=	4
Local nPos		:=	AScan(_aKits,{|x|x[1] ==  nLin})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalculo do valor do kitณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nPos != 0               
	
	nLenKit	:=	Len(_aKits[nPos][2])

	For nX	:=	1 To nLenKit
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe o item foi selecionado, seu valor eh somado ao totalณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If _aKits[nPos][2][nX][nPosOk]

			nVal += _aKits[nPos][2][nX][4] * _aKits[nPos][2][nX][5]
	
		EndIf
	
	Next nX

EndIf

Return nVal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelC001C  บAutor  ณNorbert Waage Juniorบ Data ณ  17/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina responsavel pelo preenchimento do aCols com os produ-บฑฑ
ฑฑบ          ณtos selecionados na tela de selecao de produtos             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณlGatilho	= Informa se a rotina foi chamada por gatilho     บฑฑ
ฑฑบ          ณaKitSer	= Array contendo o Kit de Servicos quando chamada บฑฑ
ฑฑบ          ณ            via gatilho                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro se houver itens                                  บฑฑ
ฑฑบ          ณFalso caso cotrario                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณExecutada na confirmacao da tela de consulta, trazendo todosบฑฑ
ฑฑบ          ณos produtos selecionados junto aos seus kits de servicos    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelC001C(lGatilho,aKitSer)

Local lRet		:=	Iif(!lGatilho,(Len(_aProds) > 0) .And. !Empty(_aProds[1][2]),.F.)
Local aColsNew	:=	{}
Local aLinha	:=	aClone(aCols[1])
Local aLinha2	:=	{}
Local nLinAnt	:=	N - IIf(!lGatilho,1,0)
Local nLinIte	:= 	0
Local nTamKit	:=	0
Local nTamCols	:=	0
Local nTamHead	:=	Len(aHeader)
Local nTamProd	:=	Iif(!lGatilho,Len(_aProds),1)
Local nTamLrIt	:=	TamSx3("L2_ITEM")[1]
Local nPos, nPos2, nPos3
Local nPosItem	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITEM"})
Local nPosCod	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_PRODUTO"})
Local nPosDesc	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_DESCRI"})
Local nPosQtd	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_QUANT"})
Local nPosPrUn	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_VRUNIT"})
Local nPosVlIt	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_VLRITEM"})
Local nPosUm	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_UM"})
Local nPosCtrl	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITREF"})
Local nLinPai	:=	IIf(!lGatilho,nLinAnt,Val(aCols[nLinAnt][nPosItem]))
Local cCodErr	:=	""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณA variavel estatica lDel001c controla a execucao da rotinaณ
//ณquando esta eh chamada via F3, ignorando a primeira vez   ณ
//ณem que o campo LR_PRODUTO eh validado quanto a a          ณ
//ณexistencia de filhos no aCols.                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static lDel001c := .F.
//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

                          
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObriga o preenchimento da tabela de precosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(M->LQ_CODTAB) .Or. Empty(M->LQ_TIPOVND)
	Aviso("Aten็ใo !!!","Preencha o Cod. da Tabela de Pre็os e o Tipo de Venda !!!",{" << Voltar"},2,"Tabela de Pre็os/Tipo de Venda !")
	Return .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica a existencia de erros na validacao de cada produtoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cCodErr := _VldProds(aKitSer))
	ApMsgAlert("O kit/produto nใo serแ preenchido pois existem erros de valida็ใo a serem verificados para o produto: " + cCodErr,"Erros encontrados" )
	Return .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAborta a rotina se nใo houver produtosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lGatilho .And. !lRet
	ApMsgInfo("Nenhum produto foi encontrado")
	Return lRet
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria uma linha de aCols padraoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nPos := 1 to nTamHead
	aLinha[nPos] := CriaVar(aHeader[nPos][2])
Next nPos

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNao deletadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
aLinha[Len(aLinha)] := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia o Array de apoio ao aCols, armazenando todos os itensณ
//ณate o elemento atual                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nPos := 1 to nLinAnt
	AAdd(aColsNew,aClone(aCols[nPos]))
Next nPos

nTamCols	:=	Len(aColsNew)  
nLinIte		:=	Iif(nTamCols == 0,1,Val(aColsNew[nTamCols][nPosItem])+1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria _aProds para compatibilidade com chamadas por gatilhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lGatilho
	_aProds := {{.F.}}
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre _aProds, adicionando os elementos ao aColsNew ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nPos :=	1 to nTamProd
	
	If _aProds[nPos][1] .Or. lGatilho
		
		If !lGatilho
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPreenche o conteudo da linhaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aLinha2 := aClone(aLinha)
			aLinha2[nPosItem]	:= StrZero(nLinIte++,nTamLrIt)
			aLinha2[nPosCod]	:= _aProds[nPos][2]
			aLinha2[nPosDesc]	:= _aProds[nPos][3]
			aLinha2[nPosQtd]	:= 1
			aLinha2[nPosPrUn]	:= _aProds[nPos][4]
			aLinha2[nPosVlIt]	:= _aProds[nPos][4]
			aLinha2[nPosUm]		:= Posicione("SB1",1,xFilial("SB1")+_aProds[nPos][2],"B1_UM")
			aLinha2[nTamHead+1]	:= .F.
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณInsere linha no aColsNew e recalcula rodapes e demais valoresณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(aColsNew,aLinha2)   
			nLinPai := Val(aLinha2[nPosItem])
			
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicia a variavel aKitSer para explosao dos kitsณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lGatilho
			If (nPos2 := AScan(_aKits,{|x|x[1] == nPos })) != 0
				aKitSer := _aKits[nPos2][2]
			Else
				aKitSer := {}
			EndIf
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExplode kit de servicosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (nTamKit := Len(aKitSer)) > 0
			
			For nPos3 := 1 To nTamKit

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณItem marcadoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤู
				If aKitSer[nPos3][1]
			                         
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณPreenche o conteudo da linhaณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aLinha2 := aClone(aLinha)
					aLinha2[nPosItem]	:= StrZero(nLinIte++,nTamLrIt)
					aLinha2[nPosCod]	:= aKitSer[nPos3][2]
					aLinha2[nPosDesc]	:= aKitSer[nPos3][3]
					aLinha2[nPosQtd]	:= aKitSer[nPos3][5]
					aLinha2[nPosPrUn]	:= aKitSer[nPos3][4]
					aLinha2[nPosVlIt]	:= aKitSer[nPos3][4] * aKitSer[nPos3][5]
					aLinha2[nPosUm]		:= Posicione("SB1",1,xFilial("SB1")+aKitSer[nPos3][2],"B1_UM")
					aLinha2[nPosCtrl]	:= StrZero(nLinPai,nTamLrIt)
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณInsere linha no aColsณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					AAdd(aColsNew,aLinha2)

				EndIf

			Next nPos3
			
		EndIf

	EndIf

Next nPos 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAborta rotina se nenhum produto foi selecionadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aLinha2) == 0
	ApMsginfo("Nenhum produto foi selecionado")
	Return .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInsere os elementos que estavam depois da linha atual no ณ
//ณaColsNew                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTamCols	:= Len(aCols)
nPos2	   	:= Len(aColsNew)

For nPos := N+1 to nTamCols

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInsere elementoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AAdd(aColsNew,aClone(aCols[nPos])) 
	nPos2++
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAjusta o controle Pai x Filhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While (nPos3:= AScan(aCols,{|x|x[nPosCtrl] == aColsNew[nPos2][nPosItem]})) != 0
		aCols[nPos3][nPosCtrl] := StrZero(nPos2,nTamLrIt)
		AAdd(aColsNew,aClone(aCols[++nPos])) 
		aColsNew[Len(aColsNew)][nPosItem] := StrZero(Len(aColsNew),nTamLrIt)
	End
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAltera numero do item do paiณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aColsNew[nPos2][nPosItem] := StrZero(nPos2,nTamLrIt)

Next nPos

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecria o aColsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCols 	 := {}
aCols 	 := aClone(aColsNew)
nTamCols := Len(aCols)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe a rotina foi chamada por gatilho:                 ณ
//ณCertifica que a linha Pai utilizada nao esta deletadaณ
//ณSenao:                                               ณ
//ณAjusta a variavel estatica de controle de execucao   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lGatilho
	If (nPos := aScan(aCols,{|x|x[nPosItem] == StrZero(nLinPai,nTamLrIt) })) != 0
		aCols[nPos][nPosQtd]	:= 1
		aCols[nPos][nTamHead+1]	:= .F.
	EndIf
Else
	lDel001c := .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza tela, valores do rodape e atualiza o valor da variavel Nณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_RefAll()
N := (nLinAnt + IIf(!lGatilho,1,0))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona SB1 para o correto retorno da pesquisa no campoณ
//ณque acionou o botao F3                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SB1")
DbSetOrder(1)	//B1_FILIAL+B1_COD
DbSeek(xFilial("SB1")+aCols[N][nPosCod])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAltera a posicao da coluna atual, para impedir que os gatilhosณ
//ณsejam executados                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetVA:oBrowse:nColPos++
oGetVA:oBrowse:Refresh() 

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelC001a  บAutor  ณNorbert Waage Juniorบ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTratamento da delecao e da recuperacao de itens no aCols da บฑฑ
ฑฑบ          ณvenda assistida, tratando produtos pais e filhos            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro caso o item possa ser deletado                   บฑฑ
ฑฑบ          ณFalso caso cotrario                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณExecutada na validacao da delecao da linha, no objeto oGetVAบฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelC001a()

Local aArea		:=	GetArea()
Local lRet		:=	.T.
Local cGrpSeg	:=	Alltrim(Upper(GetMv("FS_DEL001")))
Local nPosCtrl	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITREF"})
Local nPosCod	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_PRODUTO"})
Local nPosItem	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITEM"})
Local nPosPrUn	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_VRUNIT"})
Local nLenaCols	:=	Len(aCols)
Local nNatu		:=	N
Local nPos		:=	0  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ######################## ATENCAO #########################ณ
//ณSempre que utilizada na validacao da delecao diretamente  ณ
//ณno objeto GetDados, esta rotina eh chamada duas vezes.    ณ
//ณ----------------------------------------------------------ณ
//ณA variavel estatica _DC1Pass controla a execucao da rotinaณ
//ณDelC001a, evitando que a mesma seja executada duas        ณ
//ณvezes.                                                    ณ
//ณ----------------------------------------------------------ณ
//ณA variavel estatica _DC1Resp armazena a resposta da execu-ณ
//ณcao atual e a usa novamemte na segunda passagem, para que ณ
//ณa funcao LJ7ValDel() nao seja executada, ocasionando di-  ณ
//ณvergencia no controle de execucao desta.                  ณ
//ณ                                                          ณ
//ณ####################### IMPORTANTE #######################ณ
//ณ                                                          ณ
//ณPor este mesmo motivo, a funcao Lj7ValDel() eh chamada    ณ
//ณantes e depois da delecao da linha, pois ha uma variavel  ณ
//ณestatica de controle na funcao citada.                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static _DC1Pass := .F.
Static _DC1Resp := .T.
//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

If !_DC1Pass
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณItem ainda nao deletadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !aCols[nNatu][Len(aCols[nNatu])]
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณItem sem associacao com paiณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Empty(aCols[nNatu][nPosCtrl])
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExistencia de itens associados ao item atualณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			If (nPos := AScan(aCols,{|x|x[nPosCtrl] == aCols[nNatu][nPosItem]})) != 0
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPai deletado, com filhosณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ApMsgYesNo("Este produto possui itens associados a ele, caso o exclua, seu itens tamb้m serใo excluํdos. Confirma?")
						
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณPercorre o aCols, deletando itens associados ao item ณ
					//ณdeletado, desde que ainda nao deletados              ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					For nPos := 1 to nLenaCols
	
						If aCols[nPos][nPosCtrl] == aCols[nNatu][nPosItem] .And.;
							!aCols[nPos][Len(aCols[nPos])]
							
							N := nPos 
							Lj7ValDel()
							aCols[nPos][Len(aCols[nNatu])] := .T.
							Lj7ValDel()
							
						EndIf
	
					Next nPos
					
				Else
					lRet := .F.
				EndIf
		
			EndIf
		
		Else
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTratamento para delecao de segurosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nNatu][nPosCod],1,"") == cGrpSeg
				ApMsgAlert("Produtos do grupo seguro nใo podem ser removidos manualmente","Nใo permitido")
				lRet := .F.
			EndIf
			
		EndIf
	    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณItem previamente deletadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Else

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณItem com associacao com paiณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		If !Empty(aCols[nNatu][nPosCtrl])
		
			nPos := AScan(aCols,{|x|x[nPosItem] == aCols[nNatu][nPosCtrl]})
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTratamento para delecao de segurosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nNatu][nPosCod],1,"") == cGrpSeg
				ApMsgAlert("Produtos do grupo seguro nใo podem ser recuperados manualmente","Nใo permitido")
				lRet := .F.
			EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPai deletadoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤู
			If aCols[nPos][Len(aCols[nPos])] .And. lRet
		
				If ApMsgYesNo("Este produto estแ reladcionado ao item '" + aCols[nNatu][nPosCtrl] +;
					"', caso desfa็a sua exclusใo, o item '" + aCols[nNatu][nPosCtrl] +;
					 "' tamb้m terแ sua exclusใo desfeita. Confirma?")
	
					N := nPos
					Lj7ValDel()
					aCols[nPos][Len(aCols[nNatu])] := .F.
					Lj7ValDel()
	
	   			Else
	
					lRet := .F.
	
				EndIf
	
			EndIf
	
		EndIf
		
	EndIf
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza tela, valores do rodape e atualiza o valor da variavel Nณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_RefAll()
N := nNatu
oGetVA:oBrowse:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณComo a rotina eh executada duas vezes, a resposta anteriorณ
//ณdeve ser armazenada e recuperada posteriormente, na       ณ
//ณsegunda passagem                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !_DC1Pass	//1a. Vez
	_DC1Resp := lRet
Else 			//2a. Vez
	lRet := _DC1Resp
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza protecao contra execucao duplaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_DC1Pass := !_DC1Pass	

RestArea(aArea)
            
Return 	lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelC001b  บAutor  ณNorbert Waage Juniorบ Data ณ  19/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina  acionada no preenchimento do produto na venda assis-บฑฑ
ฑฑบ          ณtida, responsavel por apresentar os produtos que compoem o  บฑฑ
ฑฑบ          ณkit de servicos.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณCodigo do produto (M->LR_PRODUTO)                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณExecutada na validacao da delecao da linha, no objeto oGetVAบฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELC001B()
                            
Local aArea	:=	GetArea()
Local aKit 	:= P_DELC001D(M->LR_PRODUTO)
Local lRet 	:= .F. 
Local cRet	:=	M->LR_PRODUTO
Local nTamKit	:=	Len(aKit)
Local nPosItem	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITEM"})
Local nPosCtrl	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITREF"})
Local nPosCod	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_PRODUTO"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAborta se ja existe kit exibido para o produto atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If AScan(aCols,{|x|x[nPosCtrl] == aCols[N][nPosItem]}) != 0 .Or. ATail(aCols[N]) .Or.;
	nPosCod != oGetVA:oBrowse:nColPos
	
	RestArea(aArea)
	Return cRet
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDescarrega o kit no aCols se o kit existir e for selecionadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nTamKit > 0
	If P_DELC001E(@aKit)
		P_DELC001C(.T.,aKit)
	EndIf
EndIf

RestArea(aArea)
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldProds บAutor  ณNorbert Waage Juniorบ Data ณ  19/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao para os itens a serem adicionados no aCols.       บฑฑ
ฑฑบ          ณImpede a continuacao da rotina caso hajam erros no produto. บฑฑ
ฑฑบ          ณSao chamadas as validacoes do SX3 para o campo LR_PRODUTO   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaKitSer	= Array com kit de servicos enviada se for gatilhoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณCodigo do produto que nao foi aceito nas validacoes         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณExecutada apos a confirmacao da selecao dos produtos e kits บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldProds(aKitSer)

Local lRet		:=	.T.
Local lGat		:=	(aKitSer != NIL)
Local nLen		:=	Iif(!lGat,Len(_aProds),1)
Local nPos,nPos2,nPos3
Local nPosProd	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_PRODUTO"})
Local cColdBk	:=	aCols[N][nPosProd]
Local cProdBk	:=	M->LR_PRODUTO     
Local cCodErr	:=	""
Local aVldProd	:=	GetAdvFVal("SX3",{"X3_VALID","X3_VLDUSER"},"LR_PRODUTO",2,{"",""})

For nPos :=	1 to nLen
	
	If !lGat
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica os itens pais (no caso da rotina nao ser chamadaณ
		//ณpor gatilho)                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If _aProds[nPos][1]
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAltera o produto em memoria e acols atualmenteณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			M->LR_PRODUTO 		:= _aProds[nPos][2]
			aCols[N][nPosProd]	:= _aProds[nPos][2]

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta validacoesณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			lRet := Iif(!Empty(aVldProd[1]),&(aVldProd[1]),.T.) .And. Iif(!Empty(aVldProd[2]),&(aVldProd[2]),.T.)
			
			If !lRet
				Exit
			Endif
			
		EndIf   
	
	Else
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria a variavel _aKits com apenas um elemento, para execucaoณ
		//ณcom gatilhos                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		_aKits	:= {{1,aKitSer}}
		
	EndIf

	If (nPos2 := AScan(_aKits,{|x|x[1] == nPos })) != 0
	
		If (nTamKit := Len(_aKits[nPos2][2])) > 0
			
			For nPos3 := 1 To nTamKit

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณItem marcadoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤู
				If _aKits[nPos2][2][nPos3][1]

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAltera o produto em memoria e acols atualmenteณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					M->LR_PRODUTO 		:= _aKits[nPos2][2][nPos3][2]
					aCols[N][nPosProd]	:= _aKits[nPos2][2][nPos3][2]
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณExecuta validacoesณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					lRet :=	Iif(!Empty(aVldProd[1]),&(aVldProd[1]),.T.) .And.;
							Iif(!Empty(aVldProd[2]),&(aVldProd[2]),.T.)
					
					If !lRet
						nPos3 := nTamKit+1
					Endif
			
				EndIf 
				
			Next nPos3
			
		EndIf
	
	EndIf
	
Next nPos

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProduto nao validadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRet                             
	cCodErr := Alltrim(M->LR_PRODUTO)	
EndIf                       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura variaveis anterioresณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCols[N][nPosProd]	:= cColdBk
M->LR_PRODUTO		:= cProdBk

Return cCodErr

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELC001F  บAutor  ณNorbert Waage Juniorบ Data ณ  19/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao do produto digitado no aCols. Se o produto infor- บฑฑ
ฑฑบ          ณmado tiver filhos, a alteracao modifica os filhos. Se o pro-บฑฑ
ฑฑบ          ณduto for um filho, impede a alteracao.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro se o usuario puder modificar o codigo do produto บฑฑ
ฑฑบ          ณFalso caso contrario                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณExecutada apos na validacao do usuario do campo LR_PRODUTO  บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELC001F()

Local lRet 		:= .T.
Local nPosCtrl	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITREF"})
Local nPosItem	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITEM"})
Local nPosCod 	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_PRODUTO"})
Local nPosFilho	:=	aScan(aCols, {|x|x[nPosCtrl] == aCols[N][nPosItem]})
Local nPosPai	:=	aScan(aCols, {|x|x[nPosItem] == aCols[N][nPosCtrl]})
Local nPosDel	:=	0
Local nTamLrIt	:=	TamSx3("L2_ITEM")[1]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAborta caso a linha esteja deletadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aTail(aCols[N])
	Return .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe houverem filhos e a funcao DELC001C acabou de serณ
//ณexecutada                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nPosFilho != 0 .And. !lDel001c

	nPosDel := nPosFilho
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDeleta todos os filhosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While nPosDel != 0
		_DelAcols(nPosDel,.T.)
		nPosDel := aScan(aCols, {|x|x[nPosCtrl] == aCols[N][nPosItem]})
	End	

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDesarma o flag da funcao DELC001Cณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lDel001c
	lDel001c := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_DelACols บAutor  ณNorbert Waage Juniorบ Data ณ  19/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRemove definitivamente um item do aCols, atualizando o arrayบฑฑ
ฑฑบ          ณaColsDet e demais variaveis                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnItem		= Numero do elemento a ser excluido do aCols      บฑฑ
ฑฑบ          ณlPack		= Indica se o pack deve ser realizado ou nao      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณUtilizada para excluir um elemento do aCols da rotina de    บฑฑ
ฑฑบ          ณvenda assistida.                                            บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _DelACols(nItem,lPack)

Local nAtu	:=	N

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecalcula saldos apos a delecao de cada item              ณ
//ณ(A rotina Lj7ValDel eh executada duas vezes para controle ณ
//ณdas variaveis estaticas internas desta funcao)            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
N := nItem
Lj7ValDel()
aCols[N][Len(aCols[N])] := .T.
Lj7ValDel()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe os Pack's dos aCols forem necessariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lPack
	aCols	:= P_APack(aCols,.T.)
	aColsDet:= P_APack(aColsDet,.T.)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza Getdados, rodapes e restaura a variavel Nณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_RefAll()
N := IIf(nAtu > Len(aCols),Len(aCols),nAtu)

Return Nil     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณaPack     บAutor  ณNorbert Waage Juniorบ Data ณ  19/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRemove definitivamente um item de qualquer array e nao so-  บฑฑ
ฑฑบ          ณmente  o deixa como nulo, como o aDel                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_aArray	= Numero do elemento a ser excluido do vetor      บฑฑ
ฑฑบ          ณ_laCols	= Se o array tem uma estrutura de aCols           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณArray com o vetor recebido ja processado                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณUtilizada para excluir um elemento de qualquer array sem    บฑฑ
ฑฑบ          ณque permaneca um elemento "NIL"                             บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function APack(_aArray, _laCols)

Local _nCont	:=	0
Local _aRet		:=	{}

_laCols := IIf( _laCols == NIL, .F., _laCols)

If _laCols
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaPack para aColsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For _nCont := 1 to Len(_aArray)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe a linha nao foi deletadaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !ATail(_aArray[_nCont])
			aAdd(_aRet,_aArray[_nCont])
		EndIf
	Next _nCont
	
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaPack para qualquer Arrayณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For _nCont := 1 to Len(_aArray)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe o elemento nao foi deletadoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If _aArray[_nCont] <> NIL
			If ValType(_aArray[_nCont]) == "A"
				_aArray[_nCont] := P_aPack(_aArray[_nCont])
				If !Empty(_aArray[_nCont])
					aAdd(_aRet,_aArray[_nCont])
				EndIf
			Else
				aAdd(_aRet,_aArray[_nCont])
			EndIf
		EndIf
		
	Next _nCont
	
EndIf

Return _aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELC001G  บAutor  ณNorbert Waage Juniorบ Data ณ  20/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAltera a quantidade dos produtos filhos do produto contido  บฑฑ
ฑฑบ          ณna linha atual do aCols, respeitando o cadastro de Kits de  บฑฑ
ฑฑบ          ณServicos (PA3).                                             บฑฑ
ฑฑบ          ณA rotina tambem considera o produto sob o grupo de seguros, บฑฑ
ฑฑบ          ณadicionando itens no acrescimo de quantidade e removendo i- บฑฑ
ฑฑบ          ณtens na diminuicao da quantidade.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณValor digitado no campo LR_QUANT do item atual              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณGatilho do campo LR_QUANT                                   บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELC001G()

Local aArea		:=	GetArea()
Local aColsBk	:=	{}
Local nAtu,nH,nX
Local nLinSeg	:=	0
Local nMoeda	:=	1
Local nNBkp		:=	N  
Local nTamLrIt	:=	TamSx3("L2_ITEM")[1]
Local nPosCtrl	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITREF"})
Local nPosItem	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITEM"})
Local nPosQuant	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_QUANT"})
Local nPosCod	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_PRODUTO"})
Local nPosPrUn	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_VRUNIT"})
Local nPosTpOp	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_TPOPER"})
Local nLen		:=	Len(aCols)
Local nLenBK
Local nPos		:=	AScan(aCols,{|x|x[nPosCtrl] == aCols[N][nPosItem]})
Local nPos2		:=	1
Local nQtRep
Local nQtdSeg	:=	0
Local cAgreg	:=	GetAdvFVal("SB1","B1_AGREG",xFilial("SB1")+	aCols[N][nPosCod],1,"")
Local cGrpSeg	:=	Alltrim(GetMv("FS_DEL001"))
Local cRotina	:=	""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica na pilha de execucao se o gatilho nao estaณ
//ณsendo executado                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While .T.

	cRotina := ProcName(nPos2)

	If	Upper(AllTrim(cRotina))== "P_DELC001G"
			M->LR_QUANT
		Exit		
	ElseIf Empty(cRotina)
		Exit		
	Endif

	nPos2++
	
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLinha nao deletada e com filhosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nPos != 0 .And. !aTail(aCols[N])

	DbSelectArea("SB1")
	DbSetOrder(1)	//B1_FILIAL+B1_COD
	
	DbSelectArea("SX7")
	DbSetOrder(1)	//X7_CAMPO+X7_SEQUENC

	DbSelectArea("PA3")
	DbSetOrder(2)	//PA3_FILIAL+PA3_GRUPO+PA3_CODPRO
	
	For nAtu :=1 to nLen
	    
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe eh linha filha e nao deletadaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (aCols[nAtu][nPosCtrl] == aCols[nNBkp][nPosItem]) .And. !aTail(aCols[nAtu])
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe existe no PA3, a quantidade pode ser alterada e nao eh seguroณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If	PA3->(DbSeek(xFilial("PA3") + cAgreg + aCols[nAtu][nPosCod]))					.And.;
				AllTrim(PA3->PA3_ALTQTD) == "S"													.And.;
				(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nAtu][nPosCod],1,"") != cGrpSeg)
                     
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณMultiplica a quantidadeณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				aCols[nAtu][nPosQuant] := aCols[nNBkp][nPosQuant] * PA3->PA3_QUANT

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Processa Gatilho para atualizar Precosณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ! Empty(aCols[nAtu][1])
					
					N	:=	nAtu
					
					For nH := 1 To Len(aHeader)
						M->&(aHeader[nH][2]) := aCols[nAtu][nH]
					Next nH
					
					If SX7->(DbSeek("LR_QUANT"))
						RunTrigger(2,nAtu,,,SX7->X7_CAMPO)
					EndIf
							
				EndIf
			
			EndIf
			
		EndIf
		
	Next nAtu
    
	N := nNBkp

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRestaura variaveis de memoria da linha atualณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nH := 1 To Len(aHeader)
		M->&(aHeader[nH][2]) := aCols[N][nH]
	Next nH
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณReplica os segurosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nAtu := 1 to nLen

		SB1->(DbSeek(xFilial("SB1")+aCols[nAtu][nPosCod]))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe eh do grupo de seguros e eh filha da linha a ser validadaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (Alltrim(SB1->B1_GRUPO) == cGrpSeg) .And. (aCols[nAtu][nPosCtrl] == aCols[N][nPosItem])
			
			nLinSeg	:=	nAtu
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAcumula quantidade de segurosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !aTail(aCols[nAtu])
				nQtdSeg++
			EndIf
			
		EndIf
  		
    Next nAtu
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCalcula quantos seguros devem ser criados ou removidosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    nQtdRep := Int(aCols[N][nPosQuant]) - nQtdSeg	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe ha tratamento de segurosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nLinSeg != 0

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInsere Segurosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nQtdRep > 0
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCopia aColsณ
			//ภฤฤฤฤฤฤฤฤฤฤฤู
			For nAtu := 1 to nLen
				AAdd(aColsBk,aClone(aCols[nAtu]))
			Next nAtu
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAjusta os numeros dos itens do arrayณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nAtu := nLinSeg+1 to nLen
	
				aColsBK[nAtu][nPosItem] := StrZero(Val(aColsBK[nAtu][nPosItem]) + nQtdRep,nTamLrIt)
				
				If !Empty(aColsBK[nAtu][nPosCtrl]) .And. (aColsBK[nAtu][nPosCtrl] != aColsBK[N][nPosItem])
					aColsBK[nAtu][nPosCtrl] := StrZero(Val(aColsBK[nAtu][nPosCtrl]) + nQtdRep,nTamLrIt)
				EndIf
	
			Next nAtu
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณInsere segurosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nAtu := 1 to nQtdRep
	
				AAdd(aColsBk,aClone(aCols[nLinSeg]))
				nLenBK := Len(aColsBK)
				aColsBk[nLenBK][nPosItem] := StrZero(Val(aColsBk[nLenBK][nPosItem])+ nAtu,nTamLrIt)
				aColsBk[nLenBk][nPosTpOp] := ""
				aColsBk[nLenBK][Len(aColsBk[nLenBK])] := .F.
	
			Next nAtu
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณOrdena o vetor pelo campo itemณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aSort(aColsBK,,,{|x,y| x[1] < y[1] })
			
			aCols := aClone(aColsBK)
			nLen  := Len(aCols)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza getdados e rodapesณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_RefAll()
				
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRemove segurosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ElseIf nQtdRep < 0
			
			nQtdRep := Abs(nQtdRep)
			
			For nAtu := nLen to 1 Step -1
	            
				SB1->(DbSeek(xFilial("SB1")+aCols[nAtu][nPosCod]))
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณSe eh do grupo de seguros e eh filha da linha a ser validadaณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If (Alltrim(SB1->B1_GRUPO) == cGrpSeg) .And.;
					(aCols[nAtu][nPosCtrl] == aCols[N][nPosItem]) .And.;
					(!aTail(aCols[nAtu]))
					
					_DelACols(nAtu,.F.)
					nQtdRep--
					
				EndIf
							
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณSe a quantidade de seguros a ser removida jah foi atingidaณ
				//ณo laco eh abortado                                        ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If nQtdRep == 0
					nAtu := 1
				EndIf
				
			Next nAtu
	
		EndIf
	
	EndIf
	
EndIf	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura ambienteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetVa:oBrowse:nAt := N
oGetVa:oBrowse:nRowPos := N
oGetVa:oBrowse:nLen := Len(aCols)
oGetVA:oBrowse:Refresh()
N := nNBkp - (nLen - Len(aCols)) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura variaveis de memoria da linha atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nH := 1 To Len(aHeader)
	M->&(aHeader[nH][2]) := aCols[N][nH]
Next nH

RestArea(aArea)

Return M->LR_QUANT

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelC001H  บAutor  ณNorbert Waage Juniorบ Data ณ  20/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao do campo LR_QUANT, para permitir ou nao a altera- บฑฑ
ฑฑบ          ณcao da quantidade                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณTrue se o grupo for diferente do grupo seguros              บฑฑ
ฑฑบ          ณFalso se o grupo do produto for referente a seguro          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณX3_WHEN do campo LR_QUANT, permitindo ou nao a alteracao    บฑฑ
ฑฑบ          ณda quantidade, de acordo com o grupo do produto.            บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelC001H()

Local cProd		:= aCols[N][aScan(aHeader,{|x| AllTrim(x[2]) == "LR_PRODUTO"})]
Local cGrPar	:= Alltrim(GetMv("FS_DEL001"))
Local cGrAtu	:= Alltrim(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+cProd,1,""))

Return cGrPar != cGrAtu

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_RefAll   บAutor  ณNorbert Waage Juniorบ Data ณ  23/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAtualizacao dos campos dos rodapes atravez da funcao        บฑฑ
ฑฑบ          ณDELA015A e da GetDados                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณSempre que uma linha do acols for editada via codigo.       บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบNorbert   ณ24/01/06ณ------ณConsideracao do campo LR_PRODUTO como res-  บฑฑ
ฑฑบ          ณ        ณ      ณponsavel pelo acionamento desta rotina na   บฑฑ
ฑฑบ          ณ        ณ      ณutilizacao da funcao ReadVar().             บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _RefAll()

Local aArea		:=	GetArea()
Local cReadVOld	:=	ReadVar()
Local nLenC		:=	Len(aCols)
Local nLenH		:=	Len(aHeader)
Local nPosPrUn	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_VRUNIT"})
Local nNAtu		:=	N
Local nC,nH

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณForca o ReadVar(), para que as rotinas acionadas abaixoณ
//ณintepretem esta rotina como se o campo LR_PRODUTO      ณ
//ณfosse acionado                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
__readvar := "M->LR_PRODUTO"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre aColsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nC := 1 To nLenC

	N := nC
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRegistra as variaveis de memoria para a linha atualณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nH := 1 To nLenH
		M->&(aHeader[nH][2]) := aCols[nC][nH]
	Next nH

	P_DELA015A(aCols[N][nPosPrUn],.F.)

Next nC   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura valor padrao da funcao ReadVarณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
__readvar := cReadVOld

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza valores de rodape, GetDados e restaura variaveisณ
//ณde controle como estavam antes da execucao               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P_LjRodape()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza GetDados e restaura o valor de Nณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetVA:oBrowse:Refresh()
N := IIf(nNAtu > Len(aCols),Len(aCols),nNAtu)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRegistra as variaveis de memoria para a linha atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nH := 1 To nLenH
	M->&(aHeader[nH][2]) := aCols[N][nH]
Next nH

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelC001I  บAutor  ณNorbert Waage Juniorบ Data ณ  25/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLimpeza do aCols e aColsDet utilizadas na tela de venda as- บฑฑ
ฑฑบ          ณsistida                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณChamado pelo botao criado no ponto de entrada LJ0016.       บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelC001I()

Local nPos,nPos2
Local nLen
Local nLinha
Local nTamHead	:=	Len(aHeader)
Local nCont		:=	0
Local aLinha	:=	aClone(aCols[1])
Local nTamLrIt	:=	TamSx3("L2_ITEM")[1]
Local nPosItem	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITEM"})
Local nPosPrUn	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_VRUNIT"})
Local nPosCtrl	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_ITREF"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeleta itens definitivamente no aCols e no aColsDetณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCols	:=	P_aPack(aCols,.T.)		//Deleta definitivamente do aCols
aColsDet:=	P_aPack(aColsDet,.T.)	//Deleta definitivamente do aColsDet   

If (nLen := Len(aCols)) == 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria uma linha de aCols padraoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nPos := 1 to nTamHead
		aLinha[nPos] := CriaVar(aHeader[nPos][2])
	Next nPos
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAjusta o numero do item e o flag de delecaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aLinha[nPosItem]	:=	"01"
	aLinha[Len(aLinha)]	:=	.F.	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInsere a linha em brancoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCols := {}
	AAdd(aCols,aClone(aLinha))
	N := 1

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRecria controle fiscalณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If MaFisClear()
		MaFisIni(M->LQ_CLIENTE, M->LQ_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701")
	EndIf
	
	P_DELA015A(aCols[N][nPosPrUn],.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLimpa o aColsDet novamente (criado na DELA015A)ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aEval(aColsDet,{|x| x[Len(x)] := .T.})
	aColsDet:=	P_aPack(aColsDet,.T.)
	
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza coluna do itemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nPos := 1 to nLen
		
		nLinha := StrZero(nPos,nTamLrIt)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe o produto pode ser paiณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Empty(aCols[nPos][nPosCtrl])
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPercorre demais linhas do array em busca de filhosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nPos2 := nPos to nLen		

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณSe o item eh filho do produto da linha atualณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If aCols[nPos2][nPosCtrl] == aCols[nPos][nPosItem]
				
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAtualiza referencia do paiณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aCols[nPos2][nPosCtrl] := nLinha

				End		

			Next nPos2

		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza numero do itemณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aCols[nPos][nPosItem] := nLinha

	Next nPos
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza tela e valores do rodapeณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_RefAll()

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza GetDadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetVa:oBrowse:nAt	:=	1
oGetVA:oBrowse:Refresh()
N := 1

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELC001J  บAutor  ณNorbert Waage Juniorบ Data ณ  27/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณValidacao do produto digitado no aCols. Se o produto for um บฑฑ
ฑฑบ          ณfilho, a alteracao nao eh permitida.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro se o usuario puder modificar o codigo do produto บฑฑ
ฑฑบ          ณFalso caso contrario                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณExecutada na propriedade WHEN do campo LR_PRODUTO           บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelC001J()

Local cItRef	:= aCols[N][aScan(aHeader,{|x| AllTrim(x[2]) == "LR_ITREF"})]
Local lRet		:= Empty(cItRef)

If !lRet
	ApMsgInfo("Nใo ้ permitido alterar o c๓digo deste item, pois esta linha estแ vinculada ao item " + cItRef)
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_AtuMarca บAutor  ณNorbert Waage Juniorบ Data ณ  21/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAtualizacao dos campos posteriores ao campo alterado na telaบฑฑ
ฑฑบ          ณde pesquisa de produtos                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnOp - Numero que informa quais campos devem ser limpos      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณChamado pelo metodo On Change da MsGet                      บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _AtuMarca(nOp)
 
If nOp >= 1

	_cObs:= Space(TamSX3("PA7_OBSERV")[1]) 
	_oObs:Refresh()

	If nOp >= 2

		_cAno:= Space(TamSX3("PA7_ANO")[1])
		_oAno:Refresh()

		If nOp >= 3

			_cModel:= Space(TamSX3("PA1_COD")[1])
			_oModel:Refresh()

			_cDModel:= ""
			_oDModel:Refresh()

		EndIf

	EndIf

EndIf

Return Nil