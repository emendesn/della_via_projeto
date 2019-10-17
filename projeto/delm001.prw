#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DELM001         บAutor ณ Paulo Benedet       บData ณ 08/07/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Geracao dos dados de credito                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pelo menu                                      บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELM001()

//Variaveis Locais da Funcao
Local oEdit1
Local oEdit2
Local oEdit3

// Variaveis Private da Funcao
Private nEdit1	 := Val(GetSXENum("MAB", "MAB_CODIGO"))
If __lSX8
	ConfirmSX8()
EndIf
Private nEdit2	 := Val(GetSXENum("MAE", "MAE_CODIGO"))
If __lSX8
	ConfirmSX8()
EndIf
Private nEdit3	 := Val(GetSXENum("MA8", "MA8_CODEND")) 
If __lSX8
	ConfirmSX8()
EndIf

Private _oDlg
Private INCLUI := .F.

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("IMPORTANTE") FROM C(238),C(186) TO C(460),C(766) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(008),C(015) Say "ANTES DE INFORMAR  TAIS VALORES, FALE COM UM CONSULTOR DA  MICROSIGA  PARA QUE  SEJA" Size C(260),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(017),C(016) Say "VERIFICADO REALMENTE O PRำXIMO NฺMERO PARA CADA TABELA ABAIXO, ALษM DO QUE, AO FINAL" Size C(268),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(027),C(016) Say "DO PROCESSAMENTO, O CONSULTOR DEVERม EFETUAR OS AJUSTES DOS PRำXIMOS NฺMEROS NO ERP." Size C(263),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(049),C(181) Say "" Size C(002),C(002) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(050),C(016) Say "INFORME OS VALORES COMO NฺMEROS, O SISTEMA OS CONVERTERม PARA CARACTERES:" Size C(241),C(008) COLOR CLR_GREEN PIXEL OF _oDlg
	@ C(067),C(129) MsGet oEdit1 Var nEdit1 Picture "999999" Size C(044),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(069),C(016) Say "Pr๓ximo n๚mero para o campo MAB_CODIGO" Size C(110),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(080),C(129) MsGet oEdit2 Var nEdit2 Picture "999999" Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(081),C(016) Say "Pr๓ximo n๚mero para o campo MAE_CODIGO" Size C(110),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(092),C(129) MsGet oEdit3 Var nEdit3 Picture "9999999999"Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(093),C(016) Say "Pr๓ximo n๚mero para o campo MA8_CODEND" Size C(113),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
	@ C(089),C(229) Button OemtoAnsi("&OK") Size C(037),C(012) PIXEL OF _oDlg Action(Close(_oDlg))

ACTIVATE MSDIALOG _oDlg CENTERED 

If MsgNoYes(OemtoAnsi("Confirma carga inicial dos dados de crดdito?"), "Pergunta")
	Processa({|| Continua()}, "Gerando dados...")
EndIf

If MsgNoYes(OemtoAnsi("Deseja limpar os Flags de registros processados ?"), "Pergunta")
	Processa({|| LimpaFlg()}, "Limpando...")
EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ Continua        บAutor ณ Paulo Benedet       บData ณ 08/07/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Geracao dos dados de credito                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina DELM001                            บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Continua()

Local nCont		:= 0 
Local nTotSA1	:= 0
Local aPerg		:= {}
Local nTotPerg	:= 0
Local cQuest	:= GetMV("MV_QUEST") // Questionario ativo no cadastro de cliente
Local cCodMAB, cCodEnd, cCodMAE, i
Local nCodMAB	:= 0
Local nCodEnd	:= 0
Local nCodMAE	:= 0
Local cCodDoc	:= "000001" // Codigo do tipo de documento
Local cFilMA5	:= xFilial("MA5")
Local cFilMA6	:= xFilial("MA6")
Local cFilMA7	:= xFilial("MA7")
Local cFilMA8	:= xFilial("MA8")
Local cFilMAB	:= xFilial("MAB")
Local cFilMAE	:= xFilial("MAE")
Local cFilMAI	:= xFilial("MAI")
Local cFilMAP	:= xFilial("MAP")

dbSelectArea("MAP") // Cadastro de Tipos de documentos
dbSetOrder(1) // MAP_FILIAL+MAP_CODIGO
If !dbSeek(cFilMap + cCodDoc)
    dbGoTop()             
    cCodDoc  := MAP->MAP_CODIGO
EndIf    
    
dbSelectArea("MA5") // PERG Socio-Economico-Cultural 
dbSetOrder(2) // MA5_FILIAL+MA5_QUEST+MA5_PERG
dbSeek(cFilMA5 + cQuest)

While !EOF();
	.And. MA5_FILIAL == cFilMA5;
	.And. MA5_QUEST == cQuest
	
	aAdd(aPerg, {MA5->MA5_QUEST, MA5->MA5_PERG})
	
	dbSkip()
EndDo

nTotPerg := Len(aPerg)

dbSelectArea("MA6") // Cartoes                       
dbSetOrder(1) // MA6_FILIAL+MA6_NUM

dbSelectArea("MA7") // Complemento de Ficha
dbSetOrder(1) // MA7_FILIAL+MA7_CODCLI+MA7_LOJA

dbSelectArea("MA8") // Referencia de Trabalho        
dbSetOrder(3) // MA8_FILIAL+MA8_CODCLI+MA8_LOJA

dbSelectArea("MAB") // Referencias Pessoais          
dbSetOrder(2) // MAB_FILIAL+MAB_CODCLI+MAB_LOJA

dbSelectArea("MAE") // Documentos                    
dbSetOrder(2) // MAE_FILIAL+MAE_CODCLI+MAE_LOJA

dbSelectArea("MAI") // Resp. Socio Economico Social  
dbSetOrder(1) // MAI_FILIAL+MAI_CODCLI+MAI_LOJA+MAI_QUEST

dbSelectArea("SA1")
DbSetOrder(1)
nTotSA1	:=	RecCount()
//ProcRegua(LastRec())
ProcRegua(nTotSA1)
dbGoTop()

nCodMAB := nEdit1
nCodMAE := nEdit2
nCodEnd := nEdit3

While !SA1->(EOF())
	
	//Incluido por Anderson em 17/08/2005
	If !Empty(SA1->A1_IBGE) // Ja processado
		DbSelectArea("SA1")
   		SA1->(DbSkip())
   		Loop
	EndIf
	
	IncProc("Cliente/Loja :" + SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + AllTrim(Str(++nCont))+ " de " + AllTrim(Str(nTotSA1)))
	
	Begin Transaction
	
	cCodMAB := STRZERO(nCodMAB,6)
	cCodMAE := STRZERO(nCodMAE,6)
	cCodEnd := STRZERO(nCodEnd,10)

	dbSelectArea("MA6")  // Cartoes                       
	RecLock("MA6", !dbSeek(cFilMA6 + SA1->A1_CGC))
	MA6_FILIAL := cFilMA6
	MA6_CODCLI := SA1->A1_COD
	MA6_LOJA   := SA1->A1_LOJA
	MA6_NUM    := SA1->A1_CGC
	MA6_DTEVE  := dDataBase
	MA6_SITUA  := "1" // 1 = Ativo , 2 = Bloqueado , 3 - Cancelado
	msUnlock()
	
	dbSelectArea("MA7") // Complemento de Ficha
	RecLock("MA7", !dbSeek(cFilMA7 + SA1->A1_COD + SA1->A1_LOJA))
	MA7_FILIAL := cFilMA7
	MA7_CODCLI := SA1->A1_COD
	MA7_LOJA   := SA1->A1_LOJA
	MA7_TPCRED := "2"
	MA7_DATA   := dDataBase
	msUnlock()
	
	dbSelectArea("MA8") // Referencia de Trabalho        
	RecLock("MA8", !dbSeek(cFilMA8 + SA1->A1_COD + SA1->A1_LOJA))
	MA8_FILIAL := cFilMA8
	MA8_CODCLI := SA1->A1_COD
	MA8_LOJA   := SA1->A1_LOJA
	MA8_CODEND := cCodEnd
	MA8_TIPO   := "1" // 1 - Empresa Atual, 2 - Anterior , 3 = Conjuge
	MA8_EMPRES := "N/I" // Nao informado
	MA8_RENDA  := 1
	msUnlock()
	
	dbSelectArea("MAB") // Referencias Pessoais          
	RecLock("MAB", !dbSeek(cFilMAB + SA1->A1_COD + SA1->A1_LOJA))
	MAB_FILIAL := cFilMAB
	MAB_CODCLI := SA1->A1_COD
	MAB_LOJA   := SA1->A1_LOJA
	MAB_CODIGO := cCodMAB
	MAB_TEL    := "0"
	msUnlock()
	
	dbSelectArea("MAE") // Documentos                    
	RecLock("MAE", !dbSeek(cFilMAE + SA1->A1_COD + SA1->A1_LOJA))
	MAE_FILIAL := cFilMAE
	MAE_CODCLI := SA1->A1_COD
	MAE_LOJA   := SA1->A1_LOJA
	MAE_CODIGO := cCodMAE
	MAE_DESCR  := cCodDoc
	MAE_NUMDOC := "111111"
	MAE_SITUA  := "1" // 1=Entregue , 2=Pendente
	msUnlock()
	
	dbSelectArea("MAI") // Resp. Socio Economico Social  
	dbSeek(cFilMAI + SA1->A1_COD + SA1->A1_LOJA)
	
	While !EOF();
		.And. MAI_FILIAL == cFilMAI;
		.And. MAI_CODCLI == SA1->A1_COD;
		.And. MAI_LOJA == SA1->A1_LOJA
		
		RecLock("MAI", .F., .T.)
		dbDelete()
		msUnlock()
		dbSkip()
		
	EndDo
	
	For i := 1 to nTotPerg
		RecLock("MAI", .T.)
		MAI_FILIAL := cFilMAI
		MAI_CODCLI := SA1->A1_COD
		MAI_LOJA   := SA1->A1_LOJA
		MAI_QUEST  := aPerg[i][1]
		MAI_PERG   := aPerg[i][2]
		msUnlock()
	Next i
	
	End Transaction  

	//Incluido por Anderson em 17/08/2005
	//Marca o campo A1_TRANSF do SA1 indicando que o mesmo ja foi processado (Este campo eh original do Protheus e eh um Flag para transferencia de arquivos)
	//Para no caso de uma necessidade de rodar o processamento novamente os mesmos serem desprezados
	DbSelectArea("SA1")
	RecLock("SA1",.F.)
	SA1->A1_IBGE := "1" // Registro do SA1 processado
	MsUnLock()

	nCodMAB += 1
	nCodMAE += 1
	nCodEnd += 1
		
	SA1->(DbSkip())
	
EndDo

//MsgInfo("Tempo total " + AllTrim(Str(Seconds() - nSec)))

If nCont <> 0
	MsgInfo(OemtoAnsi("Foram processados " + AllTrim(Str(nCont)) + " registros."), OemtoAnsi("Informa็ใo"))
	MsgInfo(OemtoAnsi("NAO ESQUECA DE AJUSTAR O  SXE e o SXF  AGORA !!!"),OemtoAnsi("ATENCวรO"))
Else
	MsgInfo(OemtoAnsi("NAO FORAM PROCESSADOS NENHUM REGISTRO !"))
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ LimpaFlg        บAutor ณ Anderson            บData ณ 17/08/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Limpa os FLAGs de registros processados (Campo A1_TRANSF)     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pela rotina DELM001                            บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LimpaFlg()      

	// Todos os Registros do SA1 sem excessao
	
	Local cQuery	:= ""
	
	cQuery := " UPDATE " + RetSQLName("SA1") + " SET A1_TRANSF = ' ' "

	TCSQLEXEC(cQuery)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()      ณ Autor ณ Norbert Waage Junior  ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolu็ใo horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
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
   	nTam *= 0.90                                                               
EndIf                                                                           
Return Int(nTam)