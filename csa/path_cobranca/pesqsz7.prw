#INCLUDE "PROTHEUS.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PesqSzB   � Autor �Wagner Manfre       � Data �  19/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PESQSZB(ExpN1,ExpC1)                                       ���
���Uso       � ExpN1 := numero do registro do SE1                         ���
���Uso       � ExpC1 := Codigo do Cliente relacionado                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PESQSZB(nChave,cCodCli) 
Local nTipoCons := 1
Local cFuncLim := ""

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := "PS0001"
Private cCadastro := "Log de Cobranca"
//���������������������������������������������������������������������Ŀ
//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
//� que apareceram disponiveis para o usuario. Segue o padrao:          �
//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              . . .                                                  �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
//�                     duplas e pode ser uma das funcoes pre-definidas �
//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
//�                     clarar uma variavel chamada CDELFUNC contendo   �
//�                     uma expressao logica que define se o usuario po-�
//�                     dera ou nao excluir o registro, por exemplo:    �
//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
//�                     cDelFunc := ".T."                               �
//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
//�                     as aspas simples devem estar SEMPRE por fora da �
//�                     sintaxe.                                        �
//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
//�                     Por exemplo, 1 identifica que sera uma rotina de�
//�                     pesquisa, portando alteracoes nao podem ser efe-�
//�                     tuadas. 3 indica que a rotina e de inclusao, por�
//�                     tanto, a rotina sera chamada continuamente ao   �
//�                     final do processamento, ate o pressionamento de �
//�                     <ESC>. Geralmente ao se usar uma chamada de     �
//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
DEFAULT nChave    := 0
Default cCodCli   := "" 

Private aRotina   := { {"Pesquisar","AxPesqui",    0,1} ,;
 		               {"Visualizar","U_SZBVisual",0,2} }
Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   := "SZB"
Private cChavePes := ""

dbSelectArea("SZB")
dbSetOrder(1)
cPerg   := "PS0001"

//Pergunte(cPerg,.F.)
//SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������
if !empty(nChave)
	SE1->(MsGOTO(nChave))
	cChavePes := xFilial("SZB")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
	dbSelectArea(cString)
	dbSetOrder(2)
	if SZB->(dbSeek(cChavePes))
		//U_SZBVisual(cString, SZB->(Recno()), 2) 
		nTipoCons := 2
		cFuncLim := "U_LimTit"
	Else
		APMsgAlert("N�o existe log de cobranca relacionado a este titulo!")
		Return nil
	Endif
Else
	If !empty(cCodCli)
		nTipoCons := 3
		cFuncLim  := "U_LimCli"
		cChavePes := xFilial("SZB") + cCodCli
	Endif
Endif

dbSelectArea(cString) 
dbSetOrder(1)
If nTipoCons == 1
	mBrowse( 6,1,22,75,cString)
Else
	dbSetOrder(2)
	dbSeek(cChavePes)
	mBrowse( 6,1,22,75,cString,,,,,,,cFuncLim,cFuncLim)
Endif

//Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return Nil  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  SZBVisual  �Autor  �Wagner Manfre       � Data �  06/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza�ao do registro do SZB                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SZBVisual(cAlias, nReg, nOpc)
Local aAreaSave := getArea()
Local aButtons  := {}
Default nOpc := 2
Default nReg := Recno()
Default cAlias := "SZB" 
Aadd(aButtons,{"BMPUSER",{|| U_Vertit() }, "Ver Titulo", "Titulo" })

AxVisual(cAlias,nReg,nOpc,,,,,aButtons)  
restArea(aAreaSave)
return nil



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  LimCli      �Autor  �Wagner Manfre      � Data �  06/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro do cliente no MBrowse                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LimCli
return(cChavePes)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  LimTit      �Autor  �Wagner Manfre      � Data �  06/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro do Titulo no MBrowse                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LimTit
return(cChavePes)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  Vertit     �Autor  �Manfre              � Data �  06/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualizar o titulo a partir da consulta SZB               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Vertit()

Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSZB := SZB->(GetArea())
Local aSavAhead:= If(Type("aHeader")=="A",aHeader,{})
Local aSavAcol := If(Type("aCols")=="A",aCols,{})
Local nSavN    := If(Type("N")=="N",N,0)
Local cChave   := ""

dbSelectArea("SZB")
cChave := xFilial("SE1")
cChave += SZB->(ZB_CLIENTE+ZB_LOJA+ZB_PREFIXO+ZB_NUM+ZB_PARCELA+ZB_TIPO)

dbSelectArea("SE1")
dbSetOrder(2)
If dbSeek(cChave)
	SE1->(AxVisual("SE1",Recno(),2))
Else
	ApMsgAlert("Titulo nao localizado, verifique!")
Endif

//������������������������������������������������������������������������Ŀ
//�Restaura a Integridade dos Dados                                        �
//��������������������������������������������������������������������������
aHeader := aSavAHead
aCols   := aSavACol
N       := nSavN

RestArea(aAreaSZB)
RestArea(aAreaSC5)
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aArea)
Return nil
