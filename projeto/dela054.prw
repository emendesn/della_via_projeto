#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA054   บAutor  ณNorbert Waage Juniorบ Data ณ  02/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณmBrowse da tabela de liberacoes (PAQ) de venda offline      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada atraves do menu especifico                  บฑฑ
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
Project Function DELA054

Private aRotina := {}
Private cCadastro := "Libera็ao de vendas Off-Line"

aAdd(aRotina, {"Pesquisar" , "axPesqui"  		, 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual"			, 0, 2})
aAdd(aRotina, {"Liberar"   , "P_DELA054A(,.T.)"	, 0, 3})

dbSelectArea("PAQ")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,75,"PAQ")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA054A  บAutor  ณNorbert Waage Juniorบ Data ณ  02/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTela de solicitacao/liberacao de chave para venda offline   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaCampos  - Vetor com os campos que participam do calculo da บฑฑ
ฑฑบ          ณ           chave.                                           บฑฑ
ฑฑบ          ณlFornece - Indica se a funcao foi acionada com a finalidade บฑฑ
ฑฑบ          ณ           de fornecer ou solicitar a chave de liberacao.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet - Na liberacao, retorna .T. caso a chave seja gerada e บฑฑ
ฑฑบ          ณ       gravada e .F. se a tela foi cancelada. Na solicitacaoบฑฑ
ฑฑบ          ณ       retorna .T. se a chave foi informada corretamente.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada pelo menu especifico ou no P.E. CRDOFFLINE  บฑฑ
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
Project Function DELA054A(aCampos,lFornece)

Local aArea		:= GetArea()
Local cTip		:= ""
Local lRet 		:= .F.
Local bFinaliza
Local oOrca
Local oFilOrc
Local oFilial
Local oLoja
Local oCliente
Local oValor
Local oData 
Local oOrigem
Local oChvRec
Local _oDlg
Local aOrigem		:= {"Venda Assistida","Televendas"}
Local cChave		:= ""
Local cChvRec		:= Space(15)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis privates com os dados necessarios para a chaveณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cOrca		:= Space(TamSx3("LQ_NUM")[1])
Private cFilOrc		:= Space(TamSx3("LQ_FILIAL")[1])
Private cLoja		:= Space(TamSx3("LQ_LOJA")[1])
Private cCliente	:= Space(TamSx3("LQ_CLIENTE")[1])
Private nValor		:= 0
Private dData		:= dDatabase
Private cOrigem		:= ""

Default lFornece := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefina acao do botao 'OK'ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lFornece
	bFinaliza := {|x,y,z|GrvChv(@x,z)}
Else
	bFinaliza := {|x,y,z|VldChv(y)}
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtribui valores aos camposณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lFornece

	cOrca 	:= aCampos[1]
	cFilOrc	:= aCampos[2]
	cCliente:= aCampos[3]
	cLoja	:= aCampos[4]
	nValor	:= aCampos[5]
	dData	:= aCampos[6]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine origemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aCampos[7] == "LOJA701"
		cOrigem	:=aOrigem[1]
	Else
		cOrigem	:=aOrigem[2]
	EndIf

EndIf

DEFINE MSDIALOG _oDlg TITLE "Chave de libera็ใo" FROM C(314),C(294) TO C(520),C(746);
PIXEL STYLE DS_MODALFRAME STATUS

	//Caixa de agrupamento
	@ C(013),C(001) TO C(076),C(222) LABEL "Dados necessแrios para a libera็ใo" PIXEL OF _oDlg
	
	//Mensagem no topo da janela
	If lFornece
		cTip := "Preencha os campos abaixo para gerar uma chave de libera็ใo"
	Else
		cTip := "Informe os campos abaixo เ matriz para obter uma chave de libera็ใo"
    EndIf    
	
	//Numero do orcamento
	@ C(003),C(039) Say cTip  Size C(153),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(026),C(005) Say "N๚mero do or็amento" Size C(054),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(026),C(064) MsGet oOrca Var cOrca Size C(050),C(009) COLOR CLR_BLACK When lFornece PIXEL OF _oDlg

	//Filial onde foi feita a venda
	@ C(026),C(118) Say "Filial" Size C(012),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(026),C(160) MsGet oFilOrc Var cFilOrc F3 "SM0" Valid(ExistCpo("SM0",cEmpAnt+cFilOrc)) Size C(051),C(009) COLOR CLR_BLACK When lFornece PIXEL OF _oDlg

	//Cliente e loja
	@ C(039),C(005) Say "Cliente/Loja" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(039),C(093) Say "/" Size C(004),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(039),C(064) MsGet oCliente Var cCliente F3 "SA1" Valid(Vazio() .Or. ExistCpo("SA1",cCliente)) Size C(028),C(009) COLOR CLR_BLACK When lFornece PIXEL OF _oDlg
	@ C(039),C(098) MsGet oLoja Var cLoja Valid(Vazio() .Or. ExistCpo("SA1",cCliente+cLoja)) Size C(015),C(009) COLOR CLR_BLACK When lFornece PIXEL OF _oDlg
	
	//Valor da operacao
	@ C(039),C(118) Say "Valor (R$)" Size C(025),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(039),C(160) MsGet oValor Var nValor Picture("@E 999,999,999.99") Size C(051),C(009) COLOR CLR_BLACK When lFornece PIXEL OF _oDlg
	
	//Origem (TMK, LOJA, etc..)
	@ C(052),C(118) Say "Origem" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(052),C(160) ComboBox oOrigem VAR cOrigem ITEMS aOrigem SIZE C(050),C(010) When lFornece PIXEL OF _oDlg

	//Data da venda
	@ C(052),C(005) Say "Data" Size C(013),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(052),C(064) MsGet oData Var dData Size C(051),C(009) COLOR CLR_BLACK When lFornece PIXEL OF _oDlg
	
	If !lFornece
 		@ C(081),C(004) Say "Chave de libera็ใo: " Size C(051),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(081),C(059) MsGet oChvRec Var cChvRec Picture "@!" Size C(091),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	EndIf

	DEFINE SBUTTON FROM C(082),C(196) TYPE 1 ENABLE OF _oDlg ACTION Iif(lRet := Eval(bFinaliza,@cChave,cChvRec,lFornece),_oDlg:End(),.F.)
	DEFINE SBUTTON FROM C(082),C(163) TYPE 2 ENABLE OF _oDlg ACTION _oDlg:End()																				

ACTIVATE MSDIALOG _oDlg CENTERED 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInforma a chave ao usuario que a gerouณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cChave)
	ApMsgInfo("Informe a chave abaixo ao operador:" + CRLF + cChave,"Libera็ใo off-line")
EndIf

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerChMD5  บAutor  ณNorbert Waage Juniorบ Data ณ  28/04/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera chave MD5 para a sequencia contida no vetor aStrings   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerChMD5(aStrings,cSep,cTerm)

Local aArea		:= GetArea()
Local cPermStr	:= "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
Local cTmp		:= ""
Local cChr		:= ""
Local cRet		:= ""
Local nX		:= 0
Local nTam		:= TamSx3("PAQ_CHAVE")[1]

Default cSep	:= "|"
Default cTerm	:= "||"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConcatena vetor de stringsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cTmp := cTerm
For nX := 1 to Len(aStrings)
	cTmp += AllTrim(aStrings[nX]) + cSep
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAltera codificacao e aplica o algoritmo MD5 sobre a stringณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cTmp := Upper(ENCODE64(MD5(ENCODEUTF8(cTmp),1)))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEnquanto nao atingir o comprimento correto, o retorno acumulaณ
//ณos caracteres aceitos contidos na variavel cPermStr          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(cTmp)

	cChr := SubStr(cTmp,nX,1)

	If cChr $ cPermStr
		cRet += cChr
	EndIf
	
	If Len(cRet) == nTam
		Exit
	EndIf
		
Next nX

RestArea(aArea)

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvChv    บAutor  ณNorbert Waage Juniorบ Data ณ  28/04/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina que verifica se todos os campos foram preenchidos e  บฑฑ
ฑฑบ          ณexecuta o calculo da chave                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvChv(cChave,lGrava)

Local aArea		:= GetArea()
Local lRet 		:= .T.

Default lGrava	:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se os campos foram preenchidos corretamenteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cOrca) .Or. Empty(cFilOrc) .Or.;
	Empty(cCliente) .Or. Empty(cLoja) .Or.;
	Empty(dData) .Or. Empty(cOrigem) .Or. (nValor == 0)
	
	lRet := .F.
	ApMsgInfo("Todos os campos devem ser informados","Aten็ใo")
	
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGera a chaveณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤู
	cChave := 	GerChMD5({cOrca		,; //Orcamento
						cFilOrc		,; //Filial
						cCliente	,; //Cliente
						cLoja		,; //Loja
						Str(nValor)	,; //Valor
						cOrigem		,; //Origem
						Dtos(dData)	}) //Data
						
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณNa geracao, efetua a gravacao dos detalhes da liberacaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 	If lGrava
		RecLock("PAQ",.T.)
		PAQ->PAQ_FILIAL	:= xFilial("PAQ")
		PAQ->PAQ_ORIGEM	:= cOrigem
		PAQ->PAQ_NUMERO	:= cOrca
		PAQ->PAQ_FIL	:= cFilOrc
		PAQ->PAQ_CLIENT	:= cCliente
		PAQ->PAQ_LOJA	:= cLoja
		PAQ->PAQ_DTOPER	:= dData
		PAQ->PAQ_VALOR	:= nValor
		PAQ->PAQ_CHAVE	:= cChave
		PAQ->PAQ_USER	:= cUserName
		PAQ->PAQ_DTLIB	:= dDataBase
		PAQ->PAQ_HORA	:= Time()
		MsUnLock()
	EndIf

EndIf 

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldChv    บAutor  ณNorbert Waage Juniorบ Data ณ  28/04/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina que valida a chave informada, comparando-a com a     บฑฑ
ฑฑบ          ณmesma chave, gerada localmente                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldChv(cChvInfo)

Local lRet := .T.
Local cChvReal := GerChMD5({cOrca		,; //Orcamento
							cFilOrc		,; //Filial
							cCliente	,; //Cliente
							cLoja		,; //Loja
							Str(nValor)	,; //Valor
							cOrigem		,; //Origem
							Dtos(dData)	}) //Data


If !(lRet := (AllTrim(Upper(cChvInfo)) == cChvReal))
	ApMsgInfo("A chave informada nใo ้ vแlida","Aten็ใo")
EndIf

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
	//ณTratamento para tema "Flat"ณ                                               
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                