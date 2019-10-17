#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELC001   �Autor  �Norbert Waage Junior� Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina de pesquisa de Pecas x Veiculo, criada para facilitar���
���          �a busca de produtos pelo usuario na venda assistida, pre-   ���
���          �chendo o aCols da tela principal com os produtos e todos os ���
���          �kits vinculados aos mesmos.                                 ���
�������������������������������������������������������������������������͹��
���Parametros�cPar01	= Placa do veiculo                                ���
���          �cPar02	= Marca do veiculo                                ���
���          �cPar03	= Modelo do veiculo                               ���
���          �cPar04	= Ano do veiculo                                  ���
���          �cPar05	= Observacoes do veiculo                          ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Esta rotina e chamada atraves da consulta SXB "FS1", vincu- ���
���          �lada ao campo LR_PRODUTO na tela de venda assistida.        ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelC001(cPar01,cPar02,cPar03,cPar04,cPar05)

//���������������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                          �
//�����������������������������������������������������������������������
Local oDlg1		:=	NIL										//Objeto dialogo (tela)
Local oButConf	:=	NIL										//Objeto botao confirma
Local oButCanc	:=	NIL										//Objeto botao cancela
Local oRadio	:=	NIL										//Objeto radio de selecao
Local aRadio	:=	{"Por Ve�culo","Por Produto"}			//Opcoes do radio
Local nRadio	:=	1										//Opcao pre-selecionada do radio
Local nPos		:=	0										//Posicao do kit no array _aKits
Local lRet		:=	.F.

Private _aProds		:=	{}									//Conteudo da listbox
Private _aKits		:=	{}									//Kits de Servico
Private _nMoeda		:=	1									//Moeda utilizada na rotina
Private _oLbx		:=	NIL  								//Objeto listbox
Private _oOk		:= LoadBitmap( GetResources(), "LBOK" )	//Imagem "Marcado"
Private _oNo		:= LoadBitmap( GetResources(), "LBNO" )	//Imagem "Desmarcado"


//��������������������������������������������������������������Ŀ
//�Inicializacao das variaveis utilizadas na pesquisa por produto�
//����������������������������������������������������������������
Private _oLblVei	:=	NIL									//Objeto label da selecao por veiculo
Private _oLblPro	:=	NIL									//Objeto label da selecao por produto
Private _oCombo		:=	NIL									//Combo de selecao da ordem de pesquisa de produtos
Private _cCombo		:=	Space(20)							//Texto selecionado no combo
Private _oPesq		:=	NIL									//Objeto Get da pesquisa
Private _cPesq		:=	Space(100)							//Texto da pesquisa
Private _oButPesq	:=	NIL   								//Objeto botao Pesquisar
//�������������������������������������������������������������Ŀ
//�_aCombo : Array manipulada pelo combo.                       �
//�A primeira sub-array de _aCombo contem o texto correspondente�
//�a a segunda sub-array, onde encontra-se o numero do indice   �
//�no SIX                                                       �
//�Exemplo                                                      �
//�_aCombo[1][1] -> "Codigo"                                    �
//�_aCombo[1][2] -> 1                                           �
//�_aCombo[2][1] -> "Descricao"                                 �
//�_aCombo[2][2] -> 2                                           �
//���������������������������������������������������������������
Private _aCombo		:=	{{},{}}

//��������������������������������������������������������������Ŀ
//�Inicializacao das variaveis utilizadas na pesquisa por veiculo�
//����������������������������������������������������������������
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

//������������������������������������Ŀ
//�Inicializacao do conteudo da listbox�
//��������������������������������������
aAdd(_aProds,{.F., " "," ",0.00,0.00,0,""})
                          
//�����������Ŀ
//�Define tela�
//�������������
DEFINE MSDIALOG oDlg1 FROM 0,0 TO _CalcRes(490),_CalcRes(750) PIXEL TITLE "Pe�as x Ve�culo" of oMainWnd

//������Ŀ
//�Labels�
//��������
@ _CalcRes(5), _CalcRes(5) TO _CalcRes(30),_CalcRes(150) LABEL "Tipo de pesquisa" OF oDlg1 PIXEL

//����������������Ŀ
//�Radio de selecao�
//������������������
@ _CalcRes(10),_CalcRes(10) RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2] SIZE _CalcRes(060),_CalcRes(009) ;
	PIXEL OF oDlg1 ON CHANGE _ChgPesq(@oDlg1,nRadio)                

//������Ŀ
//�Botoes�
//��������
@ _CalcRes(5),_CalcRes(335) Button oButCanc Prompt "Cancelar" Size 36,10 Pixel Action(oDlg1:End()) Message "Aborta a consulta" of oDlg1
@ _CalcRes(5),_CalcRes(295) Button oButConf Prompt "Confirmar" Size 36,10 Pixel Action(lRet := P_DelC001C(.F.),Iif(lRet,oDlg1:End(),.F.)) Message "Confirma a consulta" of oDlg1

//�������Ŀ
//�Listbox�
//���������
@ _CalcRes(85),_CalcRes(05) LISTBOX _oLbx FIELDS HEADER ;
"Ok","Codigo","Descri��o","Prc.Unit�rio","Total c/ Agr.","Saldo Disp.","Aplica��o";
SIZE _CalcRes(365),_CalcRes(150) OF oDlg1;                 
PIXEL ON dblClick(_aProds[_oLbx:nAt,1] := !_aProds[_oLbx:nAt,1],;
	IIf(_aProds[_oLbx:nAt,1],_CallTk(_oLbx:nAt),.F.),_oLbx:Refresh())  
	
//������������������Ŀ
//�Metodos da ListBox�
//��������������������
_oLbx:SetArray(_aProds)
_oLbx:bLine 	:= {|| {Iif(_aProds[_oLbx:nAt,1],_oOk,_oNo),;
					_aProds[_oLbx:nAt,2],;
					_aProds[_oLbx:nAt,3],;
					Transform(_aProds[_oLbx:nAt,4],"@E 9,999,999.99"),;
					Transform(_aProds[_oLbx:nAt,5],"@E 9,999,999.99"),;
					Transform(_aProds[_oLbx:nAt,6],"@E 9,999.99"),;
					_aProds[_oLbx:nAt,7]}}

//��������������������������������������������������������Ŀ
//�Inicia objetos na tela de acordo com a op��o selecionada�
//����������������������������������������������������������
_ChgPesq(@oDlg1,nRadio)

//���������������������������������������Ŀ
//�Importa valores recebidos via parametro�
//�����������������������������������������
Iif(cPar01 == NIL,.F.,(_cPlaca := cPar01)) //,_VldPlaca(_cPlaca,@oDlg1)))
Iif(cPar02 == NIL,.F.,(_cMarca := cPar02,_VldMarca(_cMarca)))
Iif(cPar03 == NIL,.F.,(_cModel := cPar03,_VldModel(_cModel)))
Iif(cPar04 == NIL,.F.,(_cAno := cPar04))
Iif(cPar05 == NIL,.F.,(_cObs := cPar05))

//����������������Ŀ
//�Ativacao da tela�
//������������������
ACTIVATE MSDIALOG oDlg1 CENTERED 

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_ChgPesq  �Autor  �Norbert Waage Junior� Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Alterna entre os tipos de selecao, trocando os campos que   ���
���          �sao utilizados em cada pesquisa.                            ���
�������������������������������������������������������������������������͹��
���Parametros�oDlg1 	= Objeto dialogo utilizado na tela                ���
���          �nRadio	= Opcao de pesquisa selecionada pelo usuario      ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina executada na troca de opcao do objeto radio.         ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _ChgPesq(oDlg1,nRadio)

//���������������Ŀ
//�Salva ambientes�
//�����������������
Local aAreaSIX	:=	SIX->(GetArea())

//��������������������Ŀ
//�Consulta por Veiculo�
//����������������������
If nRadio == 1

	//�����������������������������Ŀ
	//�Desabilita objetos anteriores�
	//�������������������������������
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

	//���������������������������������Ŀ
	//�Cria os objetos utilizados - Topo�
	//�����������������������������������
	//�����Ŀ
	//�Label�
	//�������
	@_CalcRes(35),_CalcRes(5)	GROUP _oLblVei To _CalcRes(65),_CalcRes(370) LABEL "Caracter�sticas do ve�culo" PIXEL OF oDlg1
 
	//�����Ŀ
	//�Placa�
	//�������
    @_CalcRes(44), _CalcRes(10) SAY		_oSPlaca Prompt "PLACA" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(10) MSGET	_oPlaca Var _cPlaca Size _CalcRes(40), _CalcRes(7) F3 "PA7" PICTURE PesqPict("PA7","PA7_PLACA") VALID _VldPlaca(_cPlaca,@oDlg1) PIXEL OF oDlg1

	//�����Ŀ
	//�Marca�
	//�������
    @_CalcRes(44), _CalcRes(55) SAY		_oSMarca Prompt "MARCA" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(55) MSGET	_oMarca Var _cMarca Size _CalcRes(30), _CalcRes(7)	On Change _AtuMarca(3) F3 "PA0" Valid _VldMarca(_cMarca) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(85) MSGET	_oDMarca Var _cDMarca Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//������Ŀ
	//�Modelo�
	//��������
    @_CalcRes(44), _CalcRes(150) SAY	_oSModel Prompt "MODELO" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(150) MSGET	_oModel Var _cModel Size _CalcRes(30), _CalcRes(7) On Change _AtuMarca(2) F3 "FS2" Valid _VldModel(_cModel) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(185) MSGET	_oDModel Var _cDModel Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//���Ŀ
	//�Ano�
	//�����
    @_CalcRes(44), _CalcRes(250) SAY	_oSAno Prompt "ANO" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(250) MSGET	_oAno Var _cAno On Change _AtuMarca(1) Size _CalcRes(20), _CalcRes(7)  PIXEL OF oDlg1  

	//�����������Ŀ
	//�Observacoes�
	//�������������
    @_CalcRes(44), _CalcRes(280) SAY	_oSObs Prompt "OBSERVA��O" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(50), _CalcRes(280) MSGET	_oObs Var _cObs Size _CalcRes(80), _CalcRes(7) READONLY PIXEL OF oDlg1  

	//���������������������������������Ŀ
	//�Cria os objetos utilizados - Meio�
	//�����������������������������������
	//�����Ŀ
	//�Grupo�
	//�������
    @_CalcRes(71), _CalcRes(10)	SAY		_oSGrupo Prompt "GRUPO:" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(45)	MSGET	_oGrupo Var _cGrupo Size _CalcRes(30), _CalcRes(7) F3 "SBM" Valid _VldGrupo(_cGrupo) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(80)	MSGET	_oDGrupo Var _cDGrupo Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//���������Ŀ
	//�Categoria�
	//�����������
    @_CalcRes(71), _CalcRes(180)	SAY		_oSCateg Prompt "CATEGORIA:" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(215)	MSGET	_oCateg Var _cCateg Size _CalcRes(30), _CalcRes(7) F3 "FS3" Valid _VldCateg(_cCateg) PIXEL OF oDlg1
    @_CalcRes(70), _CalcRes(250)	MSGET	_oDCateg Var _cDCateg Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//�������Ŀ
	//�Especie�
	//���������
    @_CalcRes(81), _CalcRes(10)	SAY		_oSEspec Prompt "ESPECIE:" SIZE _CalcRes(40),_CalcRes(7) PIXEL OF oDlg1
    @_CalcRes(80), _CalcRes(45)	MSGET	_oEspec Var _cEspec Size _CalcRes(30), _CalcRes(7) F3 "FS4" Valid _VldEspec(_cEspec) PIXEL OF oDlg1
    @_CalcRes(80), _CalcRes(80)	MSGET	_oDEspec Var _cDEspec Size _CalcRes(60),_CalcRes(7) WHEN .F. PIXEL OF oDlg1

	//���������������Ŀ
	//�Botao Pesquisar�
	//�����������������
	@ _CalcRes(80),_CalcRes(215) Button _oButPesq Prompt "Pesquisar" Size 45,10 Pixel;
		Action(	MsgRun("Selecionando registros",,{|| _ExCons(1)}));
		Message "Executa a pesquisa" of oDlg1

	//���������������������������Ŀ
	//�Atualiza tamanho da listbox�
	//�����������������������������
	_oLbx:nHeight	:= _CalcRes(295)
	_oLbx:nTop 		:= _CalcRes(190)
	
	//������������������������������������Ŀ
	//�Posiciona o foco sobre o campo placa�
	//��������������������������������������
    _oPlaca:SetFocus()

//��������������������Ŀ
//�Consulta por produto�
//����������������������
Else	

	//�������������������������Ŀ
	//�Remove objetos anteriores�
	//���������������������������
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
	
	//���������������������Ŀ
	//�Cria os novos objetos�
	//�����������������������
	//�������������������������������������Ŀ
	//�Monta combo com os indices para o SB1�
	//���������������������������������������
	_aCombo	:=	{{},{}}
	DbSelectArea("SIX")
	DbSetOrder(1)//INDICE+ORDEM
	DbSeek("SB1")
	
	//�������������������������������������������Ŀ
	//�Adiciona descricao dos indices em aCombo[1]�
	//�Acidiona numero dos indices em aCombo[2]   �
	//���������������������������������������������
	While !Eof() .And. SIX->INDICE == "SB1"
		AAdd(_aCombo[1],AllTrim(SIX->DESCRICAO))
		AAdd(_aCombo[2],SIX->ORDEM)
		DbSkip()
	End
	
	//�����Ŀ
	//�Label�
	//�������
	_oLblPro := TGroup():New(_CalcRes(35),_CalcRes(5),_CalcRes(60),_CalcRes(370),"Chave de Pesquisa",oDlg1,,,	.T.,.F.)

	//�����Ŀ
	//�Combo�
	//�������
	_oCombo := TComboBox():New(_CalcRes(45), _CalcRes(10),{|x|If(PCount()>0, _cCombo := x,_cCombo)},_aCombo[1],;
		_CalcRes(100),_CalcRes(10),oDlg1,,,,,,.T.)

	//���������������Ŀ
	//�Get da pesquisa�
	//�����������������
    @_CalcRes(45), _CalcRes(115) MSGET	_oPesq Var _cPesq Size _CalcRes(130), _CalcRes(7) PICTURE "@!" PIXEL OF oDlg1

	//���������������Ŀ
	//�Botao Pesquisar�
	//�����������������
	@ _CalcRes(45),_CalcRes(250) Button _oButPesq Prompt "Pesquisar" Size 45,10 Pixel;
		Action(	MsgRun("Selecionando registros",,{|| _ExCons(2)}));
		Message "Executa a pesquisa" of oDlg1

	//���������������������������Ŀ
	//�Atualiza tamanho da listbox�
	//�����������������������������
	_oLbx:nHeight	:= _CalcRes(345)	
	_oLbx:nTop 		:= _CalcRes(143)

	//���������������������������������������Ŀ
	//�Posiciona o foco sobre o campo pesquisa�
	//�����������������������������������������
	_oPesq:SetFocus()
	
Endif

//�������������������������������������������������������������Ŀ
//�Atualiza objeto oDlg1 para aplicar as atualiza�oes realizadas�
//���������������������������������������������������������������
oDlg1:Refresh()

//�����������������Ŀ
//�Restaura ambiente�
//�������������������
RestArea(aAreaSIX)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VldMarca �Autor  �Norbert Waage Junior� Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao da marca digitada                                 ���
�������������������������������������������������������������������������͹��
���Parametros�_cMarca	= Codigo da marca a ser validado                  ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet		= Verdadeiro caso a marca possa ser utilizada     ���
���          �            Falso se a marca nao existir ou nao for valida  ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao do campo Marca, executada apos  ���
���          �a digitacao deste pelo operador do sistema.                 ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _VldMarca(_cMarca)

Local lRet	:=	(Empty(_cMarca) .Or. ExistCpo("PA0",_cMarca))

//�����������������������������������Ŀ
//�Atualiza conteudo do campo _cDMarca�
//�������������������������������������
_cDMarca	:=	Iif(lRet,GetAdvFVal("PA0","PA0_DESC",xFilial("PA0")+_cMarca,1,""),"")
_oDMarca:Refresh()

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VldModel �Autor  �Norbert Waage Junior� Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao da marca digitada                                 ���
�������������������������������������������������������������������������͹��
���Parametros�_cModel	= Codigo do modelo a ser validado                 ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet		= Verdadeiro caso o modelo possa ser utilizado    ���
���          �            Falso se o modelo nao existir ou for invalido   ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao do campo Modelo, executada apos ���
���          �a digitacao deste pelo operador do sistema.                 ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _VldModel(_cModel)

Local aAreaPA1	:=	PA1->(GetArea())
Local lRet	:=	.T.

If !Empty(_cModel)

	//�����������������������������������Ŀ
	//�Atualiza conteudo do campo _cDModel�
	//�������������������������������������	
	If (Posicione("PA1",1,xFilial("PA1")+_cModel,"PA1_CODMAR") == _cMarca)
	
		_cDModel	:=	PA1->PA1_DESC
	
	Else

	    ApMsgInfo("O c�digo do modelo informado n�o existe ou n�o est� relacionado � marca selecionada","Modelo inv�lido")
	    _cDModel	:=	Space(TamSX3("PA1_DESC")[1])
		lRet := .F.
		
	EndIf
	
	_oDModel:Refresh()                   

EndIf

RestArea(aAreaPA1)

Return lRet   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VldGrupo �Autor  �Norbert Waage Junior� Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao do grupo digitado                                 ���
�������������������������������������������������������������������������͹��
���Parametros�_cGrupo	= Codigo do grupo a ser validado                  ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet		= Verdadeiro caso o grupo  possa ser utilizado    ���
���          �            Falso se o grupo  nao existir ou for invalido   ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao do campo Grupo , executada apos ���
���          �a digitacao deste pelo operador do sistema.                 ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _VldGrupo(cGrupo)

Local lRet	:=	(Empty(cGrupo) .Or. ExistCpo("SBM",cGrupo))

//�����������������������������������Ŀ
//�Atualiza conteudo do campo _cDGrupo�
//�������������������������������������
_cDGrupo	:=	Iif(lRet,GetAdvFVal("SBM","BM_DESC",xFilial("SBM")+cGrupo,1,""),"")
_oDGrupo:Refresh()  

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VldCateg �Autor  �Norbert Waage Junior� Data �  16/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao da categoria selecionada                          ���
�������������������������������������������������������������������������͹��
���Parametros�_cCateg	= Codigo da categoria a ser validado              ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet		= Verdadeiro caso a categ. possa ser utilizada    ���
���          �            Falso se a categ. nao existir ou for invalida   ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao do campo Categoria, acionada    ���
���          �na digitacao deste pelo operador do sistema.                ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _VldCateg(cCateg)

Local lRet	:=	(Empty(cCateg) .Or. ExistCpo("SZ3",_cGrupo+cCateg))

//�����������������������������������Ŀ
//�Atualiza conteudo do campo _cDCateg�
//�������������������������������������
_cDCateg	:=	Iif(lRet,GetAdvFVal("SZ6","Z6_DESC",xFilial("SZ6")+cCateg,1,""),"")
_oDCateg:Refresh()       

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VldEspec �Autor  �Norbert Waage Junior� Data �  16/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao da categoria selecionada                          ���
�������������������������������������������������������������������������͹��
���Parametros�_cEspec	= Codigo da especie a ser validada                ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet		= Verdadeiro caso a especie possa ser utilizada   ���
���          �            Falso se a especie nao existir ou for invalida  ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao do campo Especie, acionada      ���
���          �na digitacao deste pelo operador do sistema.                ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _VldEspec(cEspec)

Local lRet	:=	(Empty(cEspec) .Or. ExistCpo("SZ4",_cCateg+cEspec))

//�����������������������������������Ŀ
//�Atualiza conteudo do campo _cDCateg�
//�������������������������������������
_cDEspec	:=	Iif(lRet,GetAdvFVal("SZ7","Z7_DESC",xFilial("SZ7")+cEspec,1,""),"")
_oDEspec:Refresh()

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VldPlaca �Autor  �Norbert Waage Junior� Data �  11/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao da placa digitada, atualizacao dos demais campos  ���
���          �com os dados do veiculo do cliente, caso este seja confimado���
�������������������������������������������������������������������������͹��
���Parametros�_cPlaca	= Codigo da placa a ser validado                  ���
�������������������������������������������������������������������������͹��
���Retorno   �Sempre verdadeiro: A nao existencia do cadastro do veiculo  ���
���          �nao impede a consulta de produtos.                          ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao do campo Placa , executada apos ���
���          �a digitacao deste pelo operador do sistema.                 ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _VldPlaca(cPlaca,oDlg)

Local aArea		:=	GetArea()
Local aAreaPA7	:=	PA7->(GetArea())
Local lRet		:=	Empty(cPlaca)

cPlaca	:=	Alltrim(Upper(cPlaca))

//�����������������������������������Ŀ
//�Se o campo placa estiver preenchido�
//�������������������������������������
If !lRet	
	
	DbSelectArea("PA7")
	DbSetOrder(2)	//PA7_FILIAL+PA7_PLACA
	
	If DbSeek(xFilial("PA7")+cPlaca)    
		
		//�������������������������������Ŀ
		//�Atualiza conteudo das variaveis�
		//���������������������������������
		_cMarca		:= PA7->PA7_CODMAR
		_cDMarca	:= GetAdvFVal("PA0","PA0_DESC",xFilial("PA0") + PA7->PA7_CODMAR,1,"")
		_cModel		:= PA7->PA7_CODMOD
		_cDModel	:= GetAdvFVal("PA1","PA1_DESC",xFilial("PA1")+PA7->PA7_CODMOD,1,"")
		_cAno		:= PA7->PA7_ANO
		_cObs		:= PA7->PA7_OBSERV
		
	Else
	
		ApMsgInfo("Ve�culo n�o cadastrado","Aten��o")

		//�������������������������������Ŀ
		//�Atualiza conteudo das variaveis�
		//���������������������������������
		_cMarca		:= Space(TamSX3("PA0_COD")[1])
		_cDMarca	:= ""
		_cModel		:= Space(TamSX3("PA1_COD")[1])
		_cDModel	:= ""
		_cAno		:= Space(TamSX3("PA7_ANO")[1])	
		_cObs		:= Space(TamSX3("PA7_OBSERV")[1])

	EndIf

	//����������������Ŀ
	//�Atualiza objetos�
	//������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_CalcRes  �Autor  �Norbert Waage Junior� Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para calculo de resolucao, utilizada para ajustar a  ���
���          �tela de acordo com a resolucao utilizada no monitor         ���
�������������������������������������������������������������������������͹��
���Parametros�nTam		= Valor de coordenada a ser convertido/ajustado   ���
�������������������������������������������������������������������������͹��
���Retorno   �nTam		= Valor convertido                                ���
�������������������������������������������������������������������������͹��
���Aplicacao �Esta rotina eh chamada para todas as coordenadas de tela u- ���
���          �tilizada neste programa, viabilizando assim a sua execucao  ���
���          �em qualquer resolucao de tela.                              ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������
If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
   	nTam *= 0.95
EndIf

Return Int(nTam)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_ExCons   �Autor  �Norbert Waage Junior� Data �  12/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Execucao da consulta em ambiente SQL ou CodeBase, com o in- ���
���          �tuito de selecionar somente os registros pertinentes ao     ���
���          �conteudo das pesquisas.                                     ���
�������������������������������������������������������������������������͹��
���Parametros�nTipo 	= Indica se a consulta e por veiculo(1) ou por    ���
���          �            produto(2)                                      ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada pelo botao Pesquisar, no dialogo. A rotina  ���
���          �verifica o tipo de base e o tipo de pesquisa, armazenando   ���
���          �no array _aProds o resultado da consulta.                   ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������Ŀ
//�Limpa o conteudo da listbox�
//�����������������������������
_aProds	:=	{}
_aKits	:=	{}

//�����������Ŀ
//�Prepara SB2�
//�������������
SB2->(DbSetOrder(1))

//������������������Ŀ
//�Consulta x Veiculo�
//��������������������
If nTipo == 1

	//����������������������Ŀ
	//�Rotina para TopConnect�
	//������������������������
	#IFDEF TOP
        
		//�������������������������������������������������Ŀ
		//�Criacao de filtro a partir dos campos preenchidos�
		//���������������������������������������������������
		If !Empty(_cGrupo)
		
			cChave := "AND SB1.B1_GRUPO = '" + _cGrupo + "' "
			
			If !Empty(_cCateg)
		
				cChave += " AND SB1.B1_CATEG = '" + _cCateg + "' "
		         
				If !Empty(_cEspec)
					
					cChave += " AND SB1.B1_SPECIE2 = '" + _cEspec + "' "
					
				EndIf
		
			EndIf
		
		EndIf

		//�����������������������Ŀ
		//�Tratamento do campo Ano�
		//�������������������������
		If !Empty(_cAno)
			cChave	+=	" AND PA2.PA2_ANODE <= '" + _cAno + "' AND PA2.PA2_ANOATE >= '" + _cAno + "' "
		EndIf

		//�������������������Ŀ
		//�Construcao da query�
		//���������������������
		cQuery	:= "SELECT SB1.B1_COD, SB1.B1_DESC, PA2.PA2_APLIC "	+	CRLF
		cQuery	+=	"FROM " + RetSqlName("SB1") + " SB1"	+	CRLF
		cQuery	+=	"Inner Join " + RetSqlName("PA2") + " PA2 On"	+	CRLF
		cQuery	+=	IIF(xFilial("SB1") == xFilial("PA2"),"SB1.B1_FILIAL = PA2.PA2_FILIAL AND","") + " SB1.B1_COD = PA2.PA2_CODPRO"	+	CRLF
		cQuery	+=	"WHERE SB1.D_E_L_E_T_ != '*' And PA2.D_E_L_E_T_ != '*' "	+	CRLF
		cQuery	+=	" And PA2.PA2_CODMOD = '" + _cModel + "'"	+	CRLF
		cQuery	+=	cChave	+	CRLF
		cQuery	+=	"ORDER BY SB1.B1_COD"
		
		//�����������������Ŀ
		//�Execucao da Query�
		//�������������������
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

		//���������������������������Ŀ
		//�Percorre o retorno da query�
		//�����������������������������
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

	//��������������������������Ŀ
	//�Rotina para Codebase/Ctree�
	//����������������������������
	#ELSE 
		
		//���������������������������������������������Ŀ
		//�Posiciona demais areas utilizadas na consulta�
		//�����������������������������������������������
		DbSelectArea("SB1")
		DbSetOrder(1)	//B1_FILIAL+B1_COD
		
		DbSelectArea("PA2")
		DbSetOrder(3)	//PA2_FILIAL+PA2_CODMOD+PA2_CODPRO 
		
		If DbSeek(xFilial("PA2")+_cModel)

			//�������������������������������������������������Ŀ
			//�Criacao de filtro a partir dos campos preenchidos�
			//���������������������������������������������������		
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

			//�������������������������������������������������Ŀ
			//�Varre produtos x veiculos relacionados ao modelo �
			//�especificado                                     �
			//���������������������������������������������������
			While !PA2->(Eof())		 			.And.;
			PA2->PA2_FILIAL == xFilial("PA2")	.And.;
			PA2->PA2_CODMOD	==	_cModel
			
				//�����������������������Ŀ
				//�Tratamento do campo Ano�
				//�������������������������
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

//������������������Ŀ
//�Consulta x Produto�
//��������������������
Elseif nTipo == 2                
	
	//���������������������������������������������������������Ŀ
	//�Trata falta de parametros, alertando o usuario quanto a a�
	//�provavel demora na execucao da rotina                    �
	//�����������������������������������������������������������
	If Empty(_cPesq)
		
		lContinua :=	MsgNoYes("Nenhum par�metro foi informado para a pesquisa, o que pode fazer com que sua "+;
						"execu��o demore alguns minutos. Deseja prosseguir?","Aten�ao")
		
	EndIf
	
	If lContinua

		//����������������������Ŀ
		//�Rotina para TopConnect�
		//������������������������
		#IFDEF TOP
	
			cChave	:=	_SetChave(_cPesq,"SB1",_aCombo[2][aScan(_aCombo[1],{|x|x == _cCombo})])
		
			//����������������Ŀ
			//�Geracao da Query�
			//������������������
			cQuery	:=	"SELECT SB1.B1_COD, SB1.B1_DESC " + CRLF		
			cQuery	+=	"FROM " + RetSqlName("SB1") + " SB1" + CRLF
			cQuery	+=	"WHERE SB1.D_E_L_E_T_ != '*' AND " + cChave + CRLF
			cQuery	+=	"ORDER BY SB1.B1_COD"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
		
			DbSelectArea("TMP") 
	
			If !TMP->(Eof())
				
				//���������������������������Ŀ
				//�Percorre o retorno da query�
				//�����������������������������
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

		//��������������������Ŀ
		//�Rotina para Codebase�
		//����������������������
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

//����������������������������Ŀ
//�Trata resultados da pesquisa�
//������������������������������
nLenCols :=	Len(_aProds)

If nLenCols == 0	
	ApMsgInfo("N�o foram encontrados dados para sua pesquisa","Pesquisa finalizada")
EndIf

//��������������������������������������������������������������Ŀ
//�Atualiza preco unitario e calcula agregados (kits de servicos)�
//����������������������������������������������������������������
For nX := 1 to nLenCols       
		
	//��������������Ŀ
	//�Preco unitario�
	//����������������
	_aProds[nX][4]	:=	P_DELA027(M->LQ_CODTAB,_aProds[nX][2],1,M->LQ_CLIENTE,M->LQ_LOJA,_nMoeda,M->LQ_DTLIM)
	
	//�����������Ŀ
	//�Associa Kit�
	//�������������
	If Len(aItens := P_DELC001D(_aProds[nX][2])) > 0 
		AAdd(_aKits,{nX,aItens})
	EndIf                        

	//���������������������������Ŀ
	//�Calcula preco com agregados�
	//�����������������������������
	_aProds[nX][5]	:=	_aProds[nX][4] + _CalcAgr(nX)

Next nX

//����������������Ŀ
//�Atualiza ListBox�
//������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_SetChave �Autor  �Norbert Waage Junior� Data �  12/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Criacao de chave de comparacao do valor pesquisado com o    ���
���          �conteudo do indice selecionado no combobox _oCombo, ajustan-���
���          �do a sintaxe para o banco DB2.                              ���
�������������������������������������������������������������������������͹��
���Parametros�cPar  	= Chave de pesquisa informada pelo usuario        ���
���          �cAlias	= Alias da tabela pesquisada                      ���
���          �cOrd		= Ordem da tabela pesquisada                      ���
�������������������������������������������������������������������������͹��
���Retorno   �String contendo a condicao complementar da clausula WHERE,  ���
���          �na Query a ser enviada para o banco de dados DB2            ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina utilizada somente quando a base for TopConnect.      ���
���          �Sera gerada uma string, concatenando valor do indice da     ���
���          �tabela recebida no parametro cAlias                         ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _SetChave(cPar,cAlias,cOrd)
            
Local aArea		:=	GetArea()
Local nPos
Local nQtd  	:=	0
Local cIndice	:=	AllTrim(GetAdvFVal("SIX","CHAVE",cAlias+cOrd,1,""))
Local cChave	:=	""
Local lSQL7		:=	AllTrim(Upper(TcGetDb())) == "MSSQL7"

//��������������������������Ŀ
//�Processa a chave do indice�
//����������������������������
While (nPos := AT("+",cIndice)) !=0 .Or. !Empty(cIndice)

	If nQtd++ == 0
		
		cChave := cAlias + "." + SubStr(cIndice,1,Iif(nPos == 0,Len(cIndice),nPos-1))
		
	Else
		
		//��������������Ŀ
		//�Chave para SQL�
		//����������������
		If lSql7	
			cChave += "+" + cAlias + "." + SubStr(cIndice,1,Iif(nPos == 0,Len(cIndice),nPos-1))
		//��������������Ŀ
		//�Chave para DB2�
		//����������������
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

//����������������������������������������������������Ŀ
//�Retorna a expressao a ser incluida na clausula WHERE�
//�da Select para DB2                                  �
//������������������������������������������������������
Return cChave + " LIKE '%"+ IIf("_FILIAL" $ cChave,xFilial(cAlias),"") + Alltrim(cPar) + "%'"    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_CallTK   �Autor  �Norbert Waage Junior� Data �  18/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina de pre-chamada a rotina DELC001E. A rotina procura   ���
���          �pelo kit relacionado a posicao atual no array _aProds.      ���
�������������������������������������������������������������������������͹��
���Parametros�nLin  	= Numero da linha da ListBox onde o usuario clicou���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica.                                              ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada pelo duplo click na listbox                 ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _CallTK(nLin)

Local nPos		:=	AScan(_aKits,{|x|x[1] == nLin })
Local nPosOk	:=	1
Local nX
Local lRet

//�������������Ŀ
//�Se existe kit�
//���������������
If nPos != 0
	
	//���������������������������������Ŀ
	//�Se o usuario nao confirmou a tela�
	//�����������������������������������
	If !P_DELC001E(@_aKits[nPos][2])
		
		//����������������������������Ŀ
		//�Remove todos os itens do Kit�
		//������������������������������
		For nX := 1 to Len(_aKits[nPos][2])
			_aKits[nPos][2][nX][nPosOk] := .F.
		Next
	
	EndIf

	//�������������������Ŀ
	//�Recalcula agregados�
	//���������������������
	_aProds[nLin][5] := _aProds[nLin][4] + _CalcAgr(nLin)

EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELC001E  �Autor  �Norbert Waage Junior� Data �  12/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Interface de exibicao dos componentes do kit de servicos    ���
���          �vinculado ao produto selecionado na listbox.                ���
�������������������������������������������������������������������������͹��
���Parametros�aVetor	= Vetor contendo os dados do kit                  ���
�������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro se o usuario confirmar a selecao                 ���
���          �Falso caso contrario                                        ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina executada no duplo clique sobre a listbos e tambem   ���
���          �pelo gatilho P_DELC001B                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELC001E(aVetor)

Local oDlg2	:=	NIL
Local oLbx2	:=	NIL
Local _oOk		:= LoadBitmap( GetResources(), "LBOK" )	//Imagem "Marcado"
Local _oNo		:= LoadBitmap( GetResources(), "LBNO" )	//Imagem "Desmarcado"
Local lRet	:=	.F.

//����������������������������������������������Ŀ
//�A rotina aborta, caso o vetor esteja vazio    �
//������������������������������������������������
If Len(aVetor) == 0 
	Return lRet
EndIf

//�����������Ŀ
//�Define tela�
//�������������
DEFINE MSDIALOG oDlg2 FROM 0,0 TO _CalcRes(160),_CalcRes(445) PIXEL TITLE "KIT SERVI�O" of oMainWnd

//�������Ŀ
//�Listbox�
//���������
@ _CalcRes(5),_CalcRes(5) LISTBOX oLbx2 FIELDS HEADER ;
"Ok","Codigo","Descri��o","Prc.Unit�rio","Quant.","Vlr. Total";
SIZE _CalcRes(175),_CalcRes(70) OF oDlg2;
PIXEL ON dblClick(aVetor[oLbx2:nAt,1] := !aVetor[oLbx2:nAt,1],oLbx2:Refresh())  
          
//������������������Ŀ
//�Metodos da ListBox�
//��������������������
oLbx2:SetArray(aVetor)
oLbx2:bLine 	:= {|| {Iif(aVetor[oLbx2:nAt,1],_oOk,_oNo),;
					aVetor[oLbx2:nAt,2],;
					aVetor[oLbx2:nAt,3],;
					Transform(aVetor[oLbx2:nAt,4],"@E 9,999,999.99"),;
					Transform(aVetor[oLbx2:nAt,5],"@E 9,999.99"),;
					Transform(aVetor[oLbx2:nAt,6],"@E 9,999,999.99")}}
					
//������Ŀ
//�Botoes�
//��������
@ _CalcRes(5),_CalcRes(185) Button oButConf Prompt "Confirmar" Size _CalcRes(36),_CalcRes(10) Pixel;
	Action(lRet := .T., oDlg2:End()) Message "Confirma a sele��o" of oDlg2
	
@ _CalcRes(20),_CalcRes(185) Button oButCanc Prompt "Cancelar" Size _CalcRes(36),_CalcRes(10) Pixel Action(oDlg2:End()) Message "Aborta a sele��o" of oDlg2

oButConf:SetFocus()

//����������������Ŀ
//�Ativacao da tela�
//������������������
ACTIVATE MSDIALOG oDlg2 CENTERED

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELC001D  �Autor  �Norbert Waage Junior� Data �  12/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para leitura dos kits relacionados ao  produto       ���
�������������������������������������������������������������������������͹��
���Parametros�cProd 	= Codigo do produto associado a esta linha        ���
�������������������������������������������������������������������������͹��
���Retorno   �Array contendo o kit do produto recebido via parametro      ���
�������������������������������������������������������������������������͹��
���Aplicacao �Esta rotina retorna um array contendo os produtos do kit as-���
���          �sociado ao produto recebido em parametro.                   ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELC001D(cProd)

Local aItens	:=	{}
Local cAgreg	:=	GetAdvFVal("SB1","B1_AGREG",xFilial("SB1")+cProd,1,"")
Local nPreco	:=	0
Local _nMoeda	:=	1

//������������������������������������������������Ŀ
//�Aborta execucao se nao houver kit para o produto�
//��������������������������������������������������
If Empty(cAgreg)
	Return aItens
EndIf

//������������������������Ŀ
//�Abre tabela de agregados�
//��������������������������
DbSelectArea("PA3")
DbSetOrder(1)	//PA3_FILIAL+PA3_GRUPO+PA3_ITEM

//���������������������������Ŀ
//�Se houverem itens agregados�
//�����������������������������
If DbSeek(xFilial("PA3")+cAgreg)
	
	While !Eof() .And. PA3->PA3_FILIAL == xFilial("PA3") .And.;
		PA3->PA3_GRUPO == cAgreg
		
		nPreco := P_DELA027(M->LQ_CODTAB,PA3->PA3_CODPRO,1,M->LQ_CLIENTE,M->LQ_LOJA,_nMoeda,M->LQ_DTLIM)
		
		//������������������������Ŀ
		//�Insere produtos no Array�
		//��������������������������		
		AAdd(aItens,;
			{.F.,;
			PA3->PA3_CODPRO,;
			Alltrim(Posicione("SB1",1,xFilial("SB1")+PA3_CODPRO,"B1_DESC")),;
			nPreco,;
			PA3->PA3_QUANT,;
			nPreco * PA3->PA3_QUANT})

		DbSkip()
	
	End

//�������������������������Ŀ
//�Senao retorna array vazio�
//���������������������������
Else          

	Return aItens	

EndIf

Return aItens

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_CalcAgr  �Autor  �Norbert Waage Junior� Data �  13/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina de calculo da soma do valor dos itens do kit de ser- ���
���          �vico relacionado a linha recebida em parametro              ���
�������������������������������������������������������������������������͹��
���Parametros�nPos		= Numero da linha no vetor da listbox             ���
�������������������������������������������������������������������������͹��
���Retorno   �nVal		= Soma do valor dos itens selecionados            ���
�������������������������������������������������������������������������͹��
���Aplicacao �Executada na criacao inical do vetor principal de produtos  ���
���          �e tambem a cada vez que a estrutura do kit sofre alteracao  ���
���          �na sua composicao.                                          ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _CalcAgr(nLin)

Local nX
Local nLenKit	:=	0
Local nVal		:=	0
Local nPosOk	:=	1
Local nPosPrc	:=	4
Local nPos		:=	AScan(_aKits,{|x|x[1] ==  nLin})

//�����������������������Ŀ
//�Calculo do valor do kit�
//�������������������������
If nPos != 0               
	
	nLenKit	:=	Len(_aKits[nPos][2])

	For nX	:=	1 To nLenKit
		
		//�������������������������������������������������������Ŀ
		//�Se o item foi selecionado, seu valor eh somado ao total�
		//���������������������������������������������������������
		If _aKits[nPos][2][nX][nPosOk]

			nVal += _aKits[nPos][2][nX][4] * _aKits[nPos][2][nX][5]
	
		EndIf
	
	Next nX

EndIf

Return nVal

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelC001C  �Autor  �Norbert Waage Junior� Data �  17/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina responsavel pelo preenchimento do aCols com os produ-���
���          �tos selecionados na tela de selecao de produtos             ���
�������������������������������������������������������������������������͹��
���Parametros�lGatilho	= Informa se a rotina foi chamada por gatilho     ���
���          �aKitSer	= Array contendo o Kit de Servicos quando chamada ���
���          �            via gatilho                                     ���
�������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro se houver itens                                  ���
���          �Falso caso cotrario                                         ���
�������������������������������������������������������������������������͹��
���Aplicacao �Executada na confirmacao da tela de consulta, trazendo todos���
���          �os produtos selecionados junto aos seus kits de servicos    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//����������������������������������������������������������Ŀ
//�A variavel estatica lDel001c controla a execucao da rotina�
//�quando esta eh chamada via F3, ignorando a primeira vez   �
//�em que o campo LR_PRODUTO eh validado quanto a a          �
//�existencia de filhos no aCols.                            �
//������������������������������������������������������������
Static lDel001c := .F.
//������������������������������������������������������������

                          
//������������������������������������������Ŀ
//�Obriga o preenchimento da tabela de precos�
//��������������������������������������������
If Empty(M->LQ_CODTAB) .Or. Empty(M->LQ_TIPOVND)
	Aviso("Aten��o !!!","Preencha o Cod. da Tabela de Pre�os e o Tipo de Venda !!!",{" << Voltar"},2,"Tabela de Pre�os/Tipo de Venda !")
	Return .F.
EndIf

//�����������������������������������������������������������Ŀ
//�Verifica a existencia de erros na validacao de cada produto�
//�������������������������������������������������������������
If !Empty(cCodErr := _VldProds(aKitSer))
	ApMsgAlert("O kit/produto n�o ser� preenchido pois existem erros de valida��o a serem verificados para o produto: " + cCodErr,"Erros encontrados" )
	Return .F.
EndIf

//��������������������������������������Ŀ
//�Aborta a rotina se n�o houver produtos�
//����������������������������������������
If !lGatilho .And. !lRet
	ApMsgInfo("Nenhum produto foi encontrado")
	Return lRet
EndIf

//������������������������������Ŀ
//�Cria uma linha de aCols padrao�
//��������������������������������
For nPos := 1 to nTamHead
	aLinha[nPos] := CriaVar(aHeader[nPos][2])
Next nPos

//������������Ŀ
//�Nao deletada�
//��������������
aLinha[Len(aLinha)] := .F.

//������������������������������������������������������������Ŀ
//�Inicia o Array de apoio ao aCols, armazenando todos os itens�
//�ate o elemento atual                                        �
//��������������������������������������������������������������
For nPos := 1 to nLinAnt
	AAdd(aColsNew,aClone(aCols[nPos]))
Next nPos

nTamCols	:=	Len(aColsNew)  
nLinIte		:=	Iif(nTamCols == 0,1,Val(aColsNew[nTamCols][nPosItem])+1)

//����������������������������������������������������������Ŀ
//�Cria _aProds para compatibilidade com chamadas por gatilho�
//������������������������������������������������������������
If lGatilho
	_aProds := {{.F.}}
EndIf

//�������������������������������������������������������Ŀ
//�Percorre _aProds, adicionando os elementos ao aColsNew �
//���������������������������������������������������������
For nPos :=	1 to nTamProd
	
	If _aProds[nPos][1] .Or. lGatilho
		
		If !lGatilho
		
			//����������������������������Ŀ
			//�Preenche o conteudo da linha�
			//������������������������������
			aLinha2 := aClone(aLinha)
			aLinha2[nPosItem]	:= StrZero(nLinIte++,nTamLrIt)
			aLinha2[nPosCod]	:= _aProds[nPos][2]
			aLinha2[nPosDesc]	:= _aProds[nPos][3]
			aLinha2[nPosQtd]	:= 1
			aLinha2[nPosPrUn]	:= _aProds[nPos][4]
			aLinha2[nPosVlIt]	:= _aProds[nPos][4]
			aLinha2[nPosUm]		:= Posicione("SB1",1,xFilial("SB1")+_aProds[nPos][2],"B1_UM")
			aLinha2[nTamHead+1]	:= .F.
			
			//�������������������������������������������������������������Ŀ
			//�Insere linha no aColsNew e recalcula rodapes e demais valores�
			//���������������������������������������������������������������
			AAdd(aColsNew,aLinha2)   
			nLinPai := Val(aLinha2[nPosItem])
			
		EndIf

		//������������������������������������������������Ŀ
		//�Inicia a variavel aKitSer para explosao dos kits�
		//��������������������������������������������������
		If !lGatilho
			If (nPos2 := AScan(_aKits,{|x|x[1] == nPos })) != 0
				aKitSer := _aKits[nPos2][2]
			Else
				aKitSer := {}
			EndIf
		EndIf

		//�����������������������Ŀ
		//�Explode kit de servicos�
		//�������������������������
		If (nTamKit := Len(aKitSer)) > 0
			
			For nPos3 := 1 To nTamKit

				//������������Ŀ
				//�Item marcado�
				//��������������
				If aKitSer[nPos3][1]
			                         
					//����������������������������Ŀ
					//�Preenche o conteudo da linha�
					//������������������������������
					aLinha2 := aClone(aLinha)
					aLinha2[nPosItem]	:= StrZero(nLinIte++,nTamLrIt)
					aLinha2[nPosCod]	:= aKitSer[nPos3][2]
					aLinha2[nPosDesc]	:= aKitSer[nPos3][3]
					aLinha2[nPosQtd]	:= aKitSer[nPos3][5]
					aLinha2[nPosPrUn]	:= aKitSer[nPos3][4]
					aLinha2[nPosVlIt]	:= aKitSer[nPos3][4] * aKitSer[nPos3][5]
					aLinha2[nPosUm]		:= Posicione("SB1",1,xFilial("SB1")+aKitSer[nPos3][2],"B1_UM")
					aLinha2[nPosCtrl]	:= StrZero(nLinPai,nTamLrIt)
					
					//���������������������Ŀ
					//�Insere linha no aCols�
					//�����������������������
					AAdd(aColsNew,aLinha2)

				EndIf

			Next nPos3
			
		EndIf

	EndIf

Next nPos 

//�����������������������������������������������Ŀ
//�Aborta rotina se nenhum produto foi selecionado�
//�������������������������������������������������
If Len(aLinha2) == 0
	ApMsginfo("Nenhum produto foi selecionado")
	Return .F.
EndIf

//���������������������������������������������������������Ŀ
//�Insere os elementos que estavam depois da linha atual no �
//�aColsNew                                                 �
//�����������������������������������������������������������
nTamCols	:= Len(aCols)
nPos2	   	:= Len(aColsNew)

For nPos := N+1 to nTamCols

	//���������������Ŀ
	//�Insere elemento�
	//�����������������
	AAdd(aColsNew,aClone(aCols[nPos])) 
	nPos2++
	
	//�����������������������������Ŀ
	//�Ajusta o controle Pai x Filho�
	//�������������������������������
	While (nPos3:= AScan(aCols,{|x|x[nPosCtrl] == aColsNew[nPos2][nPosItem]})) != 0
		aCols[nPos3][nPosCtrl] := StrZero(nPos2,nTamLrIt)
		AAdd(aColsNew,aClone(aCols[++nPos])) 
		aColsNew[Len(aColsNew)][nPosItem] := StrZero(Len(aColsNew),nTamLrIt)
	End
	
	//����������������������������Ŀ
	//�Altera numero do item do pai�
	//������������������������������
	aColsNew[nPos2][nPosItem] := StrZero(nPos2,nTamLrIt)

Next nPos

//��������������Ŀ
//�Recria o aCols�
//����������������
aCols 	 := {}
aCols 	 := aClone(aColsNew)
nTamCols := Len(aCols)

//�����������������������������������������������������Ŀ
//�Se a rotina foi chamada por gatilho:                 �
//�Certifica que a linha Pai utilizada nao esta deletada�
//�Senao:                                               �
//�Ajusta a variavel estatica de controle de execucao   �
//�������������������������������������������������������
If lGatilho
	If (nPos := aScan(aCols,{|x|x[nPosItem] == StrZero(nLinPai,nTamLrIt) })) != 0
		aCols[nPos][nPosQtd]	:= 1
		aCols[nPos][nTamHead+1]	:= .F.
	EndIf
Else
	lDel001c := .T.
EndIf

//�����������������������������������������������������������������Ŀ
//�Atualiza tela, valores do rodape e atualiza o valor da variavel N�
//�������������������������������������������������������������������
_RefAll()
N := (nLinAnt + IIf(!lGatilho,1,0))

//���������������������������������������������������������Ŀ
//�Posiciona SB1 para o correto retorno da pesquisa no campo�
//�que acionou o botao F3                                   �
//�����������������������������������������������������������
DbSelectArea("SB1")
DbSetOrder(1)	//B1_FILIAL+B1_COD
DbSeek(xFilial("SB1")+aCols[N][nPosCod])

//��������������������������������������������������������������Ŀ
//�Altera a posicao da coluna atual, para impedir que os gatilhos�
//�sejam executados                                              �
//����������������������������������������������������������������
oGetVA:oBrowse:nColPos++
oGetVA:oBrowse:Refresh() 

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelC001a  �Autor  �Norbert Waage Junior� Data �  18/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Tratamento da delecao e da recuperacao de itens no aCols da ���
���          �venda assistida, tratando produtos pais e filhos            ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica.                                              ���
�������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro caso o item possa ser deletado                   ���
���          �Falso caso cotrario                                         ���
�������������������������������������������������������������������������͹��
���Aplicacao �Executada na validacao da delecao da linha, no objeto oGetVA���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//����������������������������������������������������������Ŀ
//�######################## ATENCAO #########################�
//�Sempre que utilizada na validacao da delecao diretamente  �
//�no objeto GetDados, esta rotina eh chamada duas vezes.    �
//�----------------------------------------------------------�
//�A variavel estatica _DC1Pass controla a execucao da rotina�
//�DelC001a, evitando que a mesma seja executada duas        �
//�vezes.                                                    �
//�----------------------------------------------------------�
//�A variavel estatica _DC1Resp armazena a resposta da execu-�
//�cao atual e a usa novamemte na segunda passagem, para que �
//�a funcao LJ7ValDel() nao seja executada, ocasionando di-  �
//�vergencia no controle de execucao desta.                  �
//�                                                          �
//�####################### IMPORTANTE #######################�
//�                                                          �
//�Por este mesmo motivo, a funcao Lj7ValDel() eh chamada    �
//�antes e depois da delecao da linha, pois ha uma variavel  �
//�estatica de controle na funcao citada.                    �
//������������������������������������������������������������
Static _DC1Pass := .F.
Static _DC1Resp := .T.
//������������������������������������������������������������

If !_DC1Pass
	
	//�����������������������Ŀ
	//�Item ainda nao deletado�
	//�������������������������
	If !aCols[nNatu][Len(aCols[nNatu])]
		
		//���������������������������Ŀ
		//�Item sem associacao com pai�
		//�����������������������������
		If Empty(aCols[nNatu][nPosCtrl])
	
			//��������������������������������������������Ŀ
			//�Existencia de itens associados ao item atual�
			//����������������������������������������������			
			If (nPos := AScan(aCols,{|x|x[nPosCtrl] == aCols[nNatu][nPosItem]})) != 0
	
				//������������������������Ŀ
				//�Pai deletado, com filhos�
				//��������������������������
				If ApMsgYesNo("Este produto possui itens associados a ele, caso o exclua, seu itens tamb�m ser�o exclu�dos. Confirma?")
						
					//�����������������������������������������������������Ŀ
					//�Percorre o aCols, deletando itens associados ao item �
					//�deletado, desde que ainda nao deletados              �
					//�������������������������������������������������������
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
			
			//����������������������������������Ŀ
			//�Tratamento para delecao de seguros�
			//������������������������������������
			If GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nNatu][nPosCod],1,"") == cGrpSeg
				ApMsgAlert("Produtos do grupo seguro n�o podem ser removidos manualmente","N�o permitido")
				lRet := .F.
			EndIf
			
		EndIf
	    
	//�������������������������Ŀ
	//�Item previamente deletado�
	//���������������������������
	Else

		//���������������������������Ŀ
		//�Item com associacao com pai�
		//�����������������������������	
		If !Empty(aCols[nNatu][nPosCtrl])
		
			nPos := AScan(aCols,{|x|x[nPosItem] == aCols[nNatu][nPosCtrl]})
		
			//����������������������������������Ŀ
			//�Tratamento para delecao de seguros�
			//������������������������������������
			If GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nNatu][nPosCod],1,"") == cGrpSeg
				ApMsgAlert("Produtos do grupo seguro n�o podem ser recuperados manualmente","N�o permitido")
				lRet := .F.
			EndIf
			
			//������������Ŀ
			//�Pai deletado�
			//��������������
			If aCols[nPos][Len(aCols[nPos])] .And. lRet
		
				If ApMsgYesNo("Este produto est� reladcionado ao item '" + aCols[nNatu][nPosCtrl] +;
					"', caso desfa�a sua exclus�o, o item '" + aCols[nNatu][nPosCtrl] +;
					 "' tamb�m ter� sua exclus�o desfeita. Confirma?")
	
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

//�����������������������������������������������������������������Ŀ
//�Atualiza tela, valores do rodape e atualiza o valor da variavel N�
//�������������������������������������������������������������������
_RefAll()
N := nNatu
oGetVA:oBrowse:Refresh()

//����������������������������������������������������������Ŀ
//�Como a rotina eh executada duas vezes, a resposta anterior�
//�deve ser armazenada e recuperada posteriormente, na       �
//�segunda passagem                                          �
//������������������������������������������������������������
If !_DC1Pass	//1a. Vez
	_DC1Resp := lRet
Else 			//2a. Vez
	lRet := _DC1Resp
EndIf

//���������������������������������������Ŀ
//�Atualiza protecao contra execucao dupla�
//�����������������������������������������
_DC1Pass := !_DC1Pass	

RestArea(aArea)
            
Return 	lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelC001b  �Autor  �Norbert Waage Junior� Data �  19/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina  acionada no preenchimento do produto na venda assis-���
���          �tida, responsavel por apresentar os produtos que compoem o  ���
���          �kit de servicos.                                            ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica.                                              ���
�������������������������������������������������������������������������͹��
���Retorno   �Codigo do produto (M->LR_PRODUTO)                           ���
�������������������������������������������������������������������������͹��
���Aplicacao �Executada na validacao da delecao da linha, no objeto oGetVA���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//����������������������������������������������������Ŀ
//�Aborta se ja existe kit exibido para o produto atual�
//������������������������������������������������������
If AScan(aCols,{|x|x[nPosCtrl] == aCols[N][nPosItem]}) != 0 .Or. ATail(aCols[N]) .Or.;
	nPosCod != oGetVA:oBrowse:nColPos
	
	RestArea(aArea)
	Return cRet
	
EndIf

//������������������������������������������������������������Ŀ
//�Descarrega o kit no aCols se o kit existir e for selecionado�
//��������������������������������������������������������������
If nTamKit > 0
	If P_DELC001E(@aKit)
		P_DELC001C(.T.,aKit)
	EndIf
EndIf

RestArea(aArea)
Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VldProds �Autor  �Norbert Waage Junior� Data �  19/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao para os itens a serem adicionados no aCols.       ���
���          �Impede a continuacao da rotina caso hajam erros no produto. ���
���          �Sao chamadas as validacoes do SX3 para o campo LR_PRODUTO   ���
�������������������������������������������������������������������������͹��
���Parametros�aKitSer	= Array com kit de servicos enviada se for gatilho���
�������������������������������������������������������������������������͹��
���Retorno   �Codigo do produto que nao foi aceito nas validacoes         ���
�������������������������������������������������������������������������͹��
���Aplicacao �Executada apos a confirmacao da selecao dos produtos e kits ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	
		//���������������������������������������������������������Ŀ
		//�Verifica os itens pais (no caso da rotina nao ser chamada�
		//�por gatilho)                                             �
		//�����������������������������������������������������������
		If _aProds[nPos][1]
			
			//����������������������������������������������Ŀ
			//�Altera o produto em memoria e acols atualmente�
			//������������������������������������������������
			M->LR_PRODUTO 		:= _aProds[nPos][2]
			aCols[N][nPosProd]	:= _aProds[nPos][2]

			//������������������Ŀ
			//�Executa validacoes�
			//��������������������
			lRet := Iif(!Empty(aVldProd[1]),&(aVldProd[1]),.T.) .And. Iif(!Empty(aVldProd[2]),&(aVldProd[2]),.T.)
			
			If !lRet
				Exit
			Endif
			
		EndIf   
	
	Else
		
		//������������������������������������������������������������Ŀ
		//�Cria a variavel _aKits com apenas um elemento, para execucao�
		//�com gatilhos                                                �
		//��������������������������������������������������������������		
		_aKits	:= {{1,aKitSer}}
		
	EndIf

	If (nPos2 := AScan(_aKits,{|x|x[1] == nPos })) != 0
	
		If (nTamKit := Len(_aKits[nPos2][2])) > 0
			
			For nPos3 := 1 To nTamKit

				//������������Ŀ
				//�Item marcado�
				//��������������
				If _aKits[nPos2][2][nPos3][1]

					//����������������������������������������������Ŀ
					//�Altera o produto em memoria e acols atualmente�
					//������������������������������������������������
					M->LR_PRODUTO 		:= _aKits[nPos2][2][nPos3][2]
					aCols[N][nPosProd]	:= _aKits[nPos2][2][nPos3][2]
					
					//������������������Ŀ
					//�Executa validacoes�
					//��������������������
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

//��������������������Ŀ
//�Produto nao validado�
//����������������������
If !lRet                             
	cCodErr := Alltrim(M->LR_PRODUTO)	
EndIf                       

//�����������������������������Ŀ
//�Restaura variaveis anteriores�
//�������������������������������
aCols[N][nPosProd]	:= cColdBk
M->LR_PRODUTO		:= cProdBk

Return cCodErr

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELC001F  �Autor  �Norbert Waage Junior� Data �  19/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao do produto digitado no aCols. Se o produto infor- ���
���          �mado tiver filhos, a alteracao modifica os filhos. Se o pro-���
���          �duto for um filho, impede a alteracao.                      ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro se o usuario puder modificar o codigo do produto ���
���          �Falso caso contrario                                        ���
�������������������������������������������������������������������������͹��
���Aplicacao �Executada apos na validacao do usuario do campo LR_PRODUTO  ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//�����������������������������������Ŀ
//�Aborta caso a linha esteja deletada�
//�������������������������������������
If aTail(aCols[N])
	Return .F.
EndIf

//����������������������������������������������������Ŀ
//�Se houverem filhos e a funcao DELC001C acabou de ser�
//�executada                                           �
//������������������������������������������������������
If nPosFilho != 0 .And. !lDel001c

	nPosDel := nPosFilho
	
	//����������������������Ŀ
	//�Deleta todos os filhos�
	//������������������������
	While nPosDel != 0
		_DelAcols(nPosDel,.T.)
		nPosDel := aScan(aCols, {|x|x[nPosCtrl] == aCols[N][nPosItem]})
	End	

EndIf

//���������������������������������Ŀ
//�Desarma o flag da funcao DELC001C�
//�����������������������������������
If lDel001c
	lDel001c := .F.
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_DelACols �Autor  �Norbert Waage Junior� Data �  19/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Remove definitivamente um item do aCols, atualizando o array���
���          �aColsDet e demais variaveis                                 ���
�������������������������������������������������������������������������͹��
���Parametros�nItem		= Numero do elemento a ser excluido do aCols      ���
���          �lPack		= Indica se o pack deve ser realizado ou nao      ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Utilizada para excluir um elemento do aCols da rotina de    ���
���          �venda assistida.                                            ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _DelACols(nItem,lPack)

Local nAtu	:=	N

//����������������������������������������������������������Ŀ
//�Recalcula saldos apos a delecao de cada item              �
//�(A rotina Lj7ValDel eh executada duas vezes para controle �
//�das variaveis estaticas internas desta funcao)            �
//������������������������������������������������������������
N := nItem
Lj7ValDel()
aCols[N][Len(aCols[N])] := .T.
Lj7ValDel()

//����������������������������������������Ŀ
//�Se os Pack's dos aCols forem necessarios�
//������������������������������������������
If lPack
	aCols	:= P_APack(aCols,.T.)
	aColsDet:= P_APack(aColsDet,.T.)
EndIf

//��������������������������������������������������Ŀ
//�Atualiza Getdados, rodapes e restaura a variavel N�
//����������������������������������������������������
_RefAll()
N := IIf(nAtu > Len(aCols),Len(aCols),nAtu)

Return Nil     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �aPack     �Autor  �Norbert Waage Junior� Data �  19/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Remove definitivamente um item de qualquer array e nao so-  ���
���          �mente  o deixa como nulo, como o aDel                       ���
�������������������������������������������������������������������������͹��
���Parametros�_aArray	= Numero do elemento a ser excluido do vetor      ���
���          �_laCols	= Se o array tem uma estrutura de aCols           ���
�������������������������������������������������������������������������͹��
���Retorno   �Array com o vetor recebido ja processado                    ���
�������������������������������������������������������������������������͹��
���Aplicacao �Utilizada para excluir um elemento de qualquer array sem    ���
���          �que permaneca um elemento "NIL"                             ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function APack(_aArray, _laCols)

Local _nCont	:=	0
Local _aRet		:=	{}

_laCols := IIf( _laCols == NIL, .F., _laCols)

If _laCols
	
	//����������������Ŀ
	//�aPack para aCols�
	//������������������
	For _nCont := 1 to Len(_aArray)
		//���������������������������Ŀ
		//�Se a linha nao foi deletada�
		//�����������������������������
		If !ATail(_aArray[_nCont])
			aAdd(_aRet,_aArray[_nCont])
		EndIf
	Next _nCont
	
Else
	
	//�������������������������Ŀ
	//�aPack para qualquer Array�
	//���������������������������
	For _nCont := 1 to Len(_aArray)
		
		//������������������������������Ŀ
		//�Se o elemento nao foi deletado�
		//��������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELC001G  �Autor  �Norbert Waage Junior� Data �  20/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Altera a quantidade dos produtos filhos do produto contido  ���
���          �na linha atual do aCols, respeitando o cadastro de Kits de  ���
���          �Servicos (PA3).                                             ���
���          �A rotina tambem considera o produto sob o grupo de seguros, ���
���          �adicionando itens no acrescimo de quantidade e removendo i- ���
���          �tens na diminuicao da quantidade.                           ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Valor digitado no campo LR_QUANT do item atual              ���
�������������������������������������������������������������������������͹��
���Aplicacao �Gatilho do campo LR_QUANT                                   ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������������������������������Ŀ
//�Verifica na pilha de execucao se o gatilho nao esta�
//�sendo executado                                    �
//�����������������������������������������������������
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

//�������������������������������Ŀ
//�Linha nao deletada e com filhos�
//���������������������������������
If nPos != 0 .And. !aTail(aCols[N])

	DbSelectArea("SB1")
	DbSetOrder(1)	//B1_FILIAL+B1_COD
	
	DbSelectArea("SX7")
	DbSetOrder(1)	//X7_CAMPO+X7_SEQUENC

	DbSelectArea("PA3")
	DbSetOrder(2)	//PA3_FILIAL+PA3_GRUPO+PA3_CODPRO
	
	For nAtu :=1 to nLen
	    
		//��������������������������������Ŀ
		//�Se eh linha filha e nao deletada�
		//����������������������������������
		If (aCols[nAtu][nPosCtrl] == aCols[nNBkp][nPosItem]) .And. !aTail(aCols[nAtu])
	
			//����������������������������������������������������������������Ŀ
			//�Se existe no PA3, a quantidade pode ser alterada e nao eh seguro�
			//������������������������������������������������������������������
			If	PA3->(DbSeek(xFilial("PA3") + cAgreg + aCols[nAtu][nPosCod]))					.And.;
				AllTrim(PA3->PA3_ALTQTD) == "S"													.And.;
				(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[nAtu][nPosCod],1,"") != cGrpSeg)
                     
				//�����������������������Ŀ
				//�Multiplica a quantidade�
				//�������������������������
				aCols[nAtu][nPosQuant] := aCols[nNBkp][nPosQuant] * PA3->PA3_QUANT

				//���������������������������������������Ŀ
				//� Processa Gatilho para atualizar Precos�
				//�����������������������������������������
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

	//��������������������������������������������Ŀ
	//�Restaura variaveis de memoria da linha atual�
	//����������������������������������������������
	For nH := 1 To Len(aHeader)
		M->&(aHeader[nH][2]) := aCols[N][nH]
	Next nH
	
	//������������������Ŀ
	//�Replica os seguros�
	//��������������������
	For nAtu := 1 to nLen

		SB1->(DbSeek(xFilial("SB1")+aCols[nAtu][nPosCod]))
		
		//������������������������������������������������������������Ŀ
		//�Se eh do grupo de seguros e eh filha da linha a ser validada�
		//��������������������������������������������������������������
		If (Alltrim(SB1->B1_GRUPO) == cGrpSeg) .And. (aCols[nAtu][nPosCtrl] == aCols[N][nPosItem])
			
			nLinSeg	:=	nAtu
			
			//�����������������������������Ŀ
			//�Acumula quantidade de seguros�
			//�������������������������������
			If !aTail(aCols[nAtu])
				nQtdSeg++
			EndIf
			
		EndIf
  		
    Next nAtu
    
	//������������������������������������������������������Ŀ
	//�Calcula quantos seguros devem ser criados ou removidos�
	//��������������������������������������������������������
    nQtdRep := Int(aCols[N][nPosQuant]) - nQtdSeg	

	//���������������������������Ŀ
	//�Se ha tratamento de seguros�
	//�����������������������������
	If nLinSeg != 0

		//��������������Ŀ
		//�Insere Seguros�
		//����������������
		If nQtdRep > 0
			
			//�����������Ŀ
			//�Copia aCols�
			//�������������
			For nAtu := 1 to nLen
				AAdd(aColsBk,aClone(aCols[nAtu]))
			Next nAtu
			
			//������������������������������������Ŀ
			//�Ajusta os numeros dos itens do array�
			//��������������������������������������
			For nAtu := nLinSeg+1 to nLen
	
				aColsBK[nAtu][nPosItem] := StrZero(Val(aColsBK[nAtu][nPosItem]) + nQtdRep,nTamLrIt)
				
				If !Empty(aColsBK[nAtu][nPosCtrl]) .And. (aColsBK[nAtu][nPosCtrl] != aColsBK[N][nPosItem])
					aColsBK[nAtu][nPosCtrl] := StrZero(Val(aColsBK[nAtu][nPosCtrl]) + nQtdRep,nTamLrIt)
				EndIf
	
			Next nAtu
			
			//��������������Ŀ
			//�Insere seguros�
			//����������������
			For nAtu := 1 to nQtdRep
	
				AAdd(aColsBk,aClone(aCols[nLinSeg]))
				nLenBK := Len(aColsBK)
				aColsBk[nLenBK][nPosItem] := StrZero(Val(aColsBk[nLenBK][nPosItem])+ nAtu,nTamLrIt)
				aColsBk[nLenBk][nPosTpOp] := ""
				aColsBk[nLenBK][Len(aColsBk[nLenBK])] := .F.
	
			Next nAtu
		
			//������������������������������Ŀ
			//�Ordena o vetor pelo campo item�
			//��������������������������������
			aSort(aColsBK,,,{|x,y| x[1] < y[1] })
			
			aCols := aClone(aColsBK)
			nLen  := Len(aCols)
			
			//���������������������������Ŀ
			//�Atualiza getdados e rodapes�
			//�����������������������������
			_RefAll()
				
		//��������������Ŀ
		//�Remove seguros�
		//����������������
		ElseIf nQtdRep < 0
			
			nQtdRep := Abs(nQtdRep)
			
			For nAtu := nLen to 1 Step -1
	            
				SB1->(DbSeek(xFilial("SB1")+aCols[nAtu][nPosCod]))
				
				//������������������������������������������������������������Ŀ
				//�Se eh do grupo de seguros e eh filha da linha a ser validada�
				//��������������������������������������������������������������
				If (Alltrim(SB1->B1_GRUPO) == cGrpSeg) .And.;
					(aCols[nAtu][nPosCtrl] == aCols[N][nPosItem]) .And.;
					(!aTail(aCols[nAtu]))
					
					_DelACols(nAtu,.F.)
					nQtdRep--
					
				EndIf
							
				//����������������������������������������������������������Ŀ
				//�Se a quantidade de seguros a ser removida jah foi atingida�
				//�o laco eh abortado                                        �
				//������������������������������������������������������������
				If nQtdRep == 0
					nAtu := 1
				EndIf
				
			Next nAtu
	
		EndIf
	
	EndIf
	
EndIf	

//�����������������Ŀ
//�Restaura ambiente�
//�������������������
oGetVa:oBrowse:nAt := N
oGetVa:oBrowse:nRowPos := N
oGetVa:oBrowse:nLen := Len(aCols)
oGetVA:oBrowse:Refresh()
N := nNBkp - (nLen - Len(aCols)) 

//��������������������������������������������Ŀ
//�Restaura variaveis de memoria da linha atual�
//����������������������������������������������
For nH := 1 To Len(aHeader)
	M->&(aHeader[nH][2]) := aCols[N][nH]
Next nH

RestArea(aArea)

Return M->LR_QUANT

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelC001H  �Autor  �Norbert Waage Junior� Data �  20/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao do campo LR_QUANT, para permitir ou nao a altera- ���
���          �cao da quantidade                                           ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �True se o grupo for diferente do grupo seguros              ���
���          �Falso se o grupo do produto for referente a seguro          ���
�������������������������������������������������������������������������͹��
���Aplicacao �X3_WHEN do campo LR_QUANT, permitindo ou nao a alteracao    ���
���          �da quantidade, de acordo com o grupo do produto.            ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelC001H()

Local cProd		:= aCols[N][aScan(aHeader,{|x| AllTrim(x[2]) == "LR_PRODUTO"})]
Local cGrPar	:= Alltrim(GetMv("FS_DEL001"))
Local cGrAtu	:= Alltrim(GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+cProd,1,""))

Return cGrPar != cGrAtu

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_RefAll   �Autor  �Norbert Waage Junior� Data �  23/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Atualizacao dos campos dos rodapes atravez da funcao        ���
���          �DELA015A e da GetDados                                      ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Sempre que uma linha do acols for editada via codigo.       ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���Norbert   �24/01/06�------�Consideracao do campo LR_PRODUTO como res-  ���
���          �        �      �ponsavel pelo acionamento desta rotina na   ���
���          �        �      �utilizacao da funcao ReadVar().             ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _RefAll()

Local aArea		:=	GetArea()
Local cReadVOld	:=	ReadVar()
Local nLenC		:=	Len(aCols)
Local nLenH		:=	Len(aHeader)
Local nPosPrUn	:=	aScan(aHeader, {|x| Upper(Alltrim(x[2])) == "LR_VRUNIT"})
Local nNAtu		:=	N
Local nC,nH

//�������������������������������������������������������Ŀ
//�Forca o ReadVar(), para que as rotinas acionadas abaixo�
//�intepretem esta rotina como se o campo LR_PRODUTO      �
//�fosse acionado                                         �
//���������������������������������������������������������
__readvar := "M->LR_PRODUTO"

//��������������Ŀ
//�Percorre aCols�
//����������������
For nC := 1 To nLenC

	N := nC
	
	//���������������������������������������������������Ŀ
	//�Registra as variaveis de memoria para a linha atual�
	//�����������������������������������������������������
	For nH := 1 To nLenH
		M->&(aHeader[nH][2]) := aCols[nC][nH]
	Next nH

	P_DELA015A(aCols[N][nPosPrUn],.F.)

Next nC   

//���������������������������������������Ŀ
//�Restaura valor padrao da funcao ReadVar�
//�����������������������������������������
__readvar := cReadVOld

//���������������������������������������������������������Ŀ
//�Atualiza valores de rodape, GetDados e restaura variaveis�
//�de controle como estavam antes da execucao               �
//�����������������������������������������������������������
P_LjRodape()

//�����������������������������������������Ŀ
//�Atualiza GetDados e restaura o valor de N�
//�������������������������������������������
oGetVA:oBrowse:Refresh()
N := IIf(nNAtu > Len(aCols),Len(aCols),nNAtu)

//���������������������������������������������������Ŀ
//�Registra as variaveis de memoria para a linha atual�
//�����������������������������������������������������
For nH := 1 To nLenH
	M->&(aHeader[nH][2]) := aCols[N][nH]
Next nH

RestArea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelC001I  �Autor  �Norbert Waage Junior� Data �  25/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Limpeza do aCols e aColsDet utilizadas na tela de venda as- ���
���          �sistida                                                     ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Chamado pelo botao criado no ponto de entrada LJ0016.       ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������������������������������Ŀ
//�Deleta itens definitivamente no aCols e no aColsDet�
//�����������������������������������������������������
aCols	:=	P_aPack(aCols,.T.)		//Deleta definitivamente do aCols
aColsDet:=	P_aPack(aColsDet,.T.)	//Deleta definitivamente do aColsDet   

If (nLen := Len(aCols)) == 0

	//������������������������������Ŀ
	//�Cria uma linha de aCols padrao�
	//��������������������������������
	For nPos := 1 to nTamHead
		aLinha[nPos] := CriaVar(aHeader[nPos][2])
	Next nPos
	
	//�������������������������������������������Ŀ
	//�Ajusta o numero do item e o flag de delecao�
	//���������������������������������������������
	aLinha[nPosItem]	:=	"01"
	aLinha[Len(aLinha)]	:=	.F.	

	//������������������������Ŀ
	//�Insere a linha em branco�
	//��������������������������
	aCols := {}
	AAdd(aCols,aClone(aLinha))
	N := 1

	//����������������������Ŀ
	//�Recria controle fiscal�
	//������������������������
	If MaFisClear()
		MaFisIni(M->LQ_CLIENTE, M->LQ_LOJA, "C", "S", Nil, Nil, Nil, .F., "SB1", "LOJA701")
	EndIf
	
	P_DELA015A(aCols[N][nPosPrUn],.T.)
	
	//�����������������������������������������������Ŀ
	//�Limpa o aColsDet novamente (criado na DELA015A)�
	//�������������������������������������������������
	aEval(aColsDet,{|x| x[Len(x)] := .T.})
	aColsDet:=	P_aPack(aColsDet,.T.)
	
Else
	
	//�����������������������Ŀ
	//�Atualiza coluna do item�
	//�������������������������
	For nPos := 1 to nLen
		
		nLinha := StrZero(nPos,nTamLrIt)
		
		//�������������������������Ŀ
		//�Se o produto pode ser pai�
		//���������������������������
		If Empty(aCols[nPos][nPosCtrl])
		
			//��������������������������������������������������Ŀ
			//�Percorre demais linhas do array em busca de filhos�
			//����������������������������������������������������
			For nPos2 := nPos to nLen		

				//��������������������������������������������Ŀ
				//�Se o item eh filho do produto da linha atual�
				//����������������������������������������������
				If aCols[nPos2][nPosCtrl] == aCols[nPos][nPosItem]
				
					//��������������������������Ŀ
					//�Atualiza referencia do pai�
					//����������������������������
					aCols[nPos2][nPosCtrl] := nLinha

				End		

			Next nPos2

		EndIf
		
		//�����������������������Ŀ
		//�Atualiza numero do item�
		//�������������������������
		aCols[nPos][nPosItem] := nLinha

	Next nPos
	
	//���������������������������������Ŀ
	//�Atualiza tela e valores do rodape�
	//�����������������������������������
	_RefAll()

EndIf

//�����������������Ŀ
//�Atualiza GetDados�
//�������������������
oGetVa:oBrowse:nAt	:=	1
oGetVA:oBrowse:Refresh()
N := 1

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELC001J  �Autor  �Norbert Waage Junior� Data �  27/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao do produto digitado no aCols. Se o produto for um ���
���          �filho, a alteracao nao eh permitida.                        ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro se o usuario puder modificar o codigo do produto ���
���          �Falso caso contrario                                        ���
�������������������������������������������������������������������������͹��
���Aplicacao �Executada na propriedade WHEN do campo LR_PRODUTO           ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelC001J()

Local cItRef	:= aCols[N][aScan(aHeader,{|x| AllTrim(x[2]) == "LR_ITREF"})]
Local lRet		:= Empty(cItRef)

If !lRet
	ApMsgInfo("N�o � permitido alterar o c�digo deste item, pois esta linha est� vinculada ao item " + cItRef)
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_AtuMarca �Autor  �Norbert Waage Junior� Data �  21/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Atualizacao dos campos posteriores ao campo alterado na tela���
���          �de pesquisa de produtos                                     ���
�������������������������������������������������������������������������͹��
���Parametros�nOp - Numero que informa quais campos devem ser limpos      ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Chamado pelo metodo On Change da MsGet                      ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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