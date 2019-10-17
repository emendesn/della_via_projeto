#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
User Function Mt089A()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := { { "Pesquisar",	"AxPesqui"  , 0 , 1},;
		{ "Visualizar",	"AxVisual"   , 0 , 2},;
		{ "Incluir",    "u_Mt089AInc", 0 , 3},;
		{ "Alterar",    "u_Mt089AAlt", 0 , 4},;
		{ "Excluir",    "AxDeleta"   , 0 , 5} }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemtoAnsi("TES Inteligente")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,"SFM")
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A089Inclui³ Autor ³ Aline Correa do Vale  ³ Data ³ 13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Inclusao de Tes Inteligente                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA089()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mt089AInc(cAlias,nReg,nOpc)

Local nOpca := 0
INCLUI := .T.
ALTERA := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia para processamento dos Gets          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpcA:=0

Begin Transaction
	nOpcA:=AxInclui( cAlias, nReg, nOpc,,,,"u_Mt089ATudOk()")
End Transaction
	
dbSelectArea(cAlias)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A089Altera³ Autor ³ Aline Correa do Vale  ³ Data ³ 13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Inclusao de Tes Inteligente                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA089()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mt089AAlt(cAlias,nReg,nOpc)

Local nOpca := 0
INCLUI := .F.
ALTERA := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia para processamento dos Gets          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpcA:=0

Begin Transaction
	nOpcA:=AxAltera( cAlias, nReg, nOpc,,,,,"Mt089ATudOk()")
End Transaction
	
dbSelectArea(cAlias)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A089TudOk ³ Autor ³ Aline Correa do Vale ³ Data ³ 13/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o registro esta com chave duplicada            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A089TudOk()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA089                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mt089aTudOk()
Local lRet      := .T.

If INCLUI .And. dbSeek(xFilial("SFM")+M->FM_TIPO+M->FM_PRODUTO+M->FM_CLIENTE+M->FM_LOJACLI+M->FM_FORNECE+M->FM_LOJAFOR)
	While !Eof() .And. SFM->(FM_FILIAL+FM_TIPO+FM_PRODUTO+M->FM_CLIENTE+FM_LOJACLI) ==;
		(xFilial("SFM")+M->FM_TIPO+M->FM_PRODUTO+M->FM_CLIENTE+M->FM_LOJACLI)
		If SFM->(FM_FORNECE+FM_LOJAFOR+FM_GRPROD+FM_GRTRIB+FM_TPCLFOR+FM_UFDEST) == M->(FM_FORNECE+FM_LOJAFOR+FM_GRPROD+FM_GRTRIB+FM_TPCLFOR+FM_UFDEST)
			Help(" ",1,"JAGRAVADO")
			lRet := .F.
			Exit
		EndIf
		dbSkip()
	EndDo
Endif

If !Empty(M->FM_CLIENTE) .Or. !Empty(M->FM_LOJACLI)
	SA1->(dbSetOrder(1))
	If !SA1->(MsSeek(xFilial("SA1")+M->FM_CLIENTE+M->FM_LOJACLI ))
		Help(" ",1,"'FT089CLI")
		lRet := .F.
	Endif
Endif

If lRet

	If !Empty(M->FM_FORNECE) .Or. !Empty(M->FM_LOJAFOR)
		SA2->(dbSetOrder(1))
		If !SA2->(MsSeek(xFilial("SA2")+M->FM_FORNECE+M->FM_LOJAFOR ))
			Help(" ",1,"FT089FOR")
			lRet := .F.
		Endif
	Endif
	
Endif

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA089  ³ Autor ³ Aline Correa do Vale  ³ Data ³ 09.08.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MaTesInt(ExpN1,ExcC1,ExpC2,ExpC3,ExpC4,ExpC5)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExpN1 = Documento de 1-Entrada / 2-Saida                     ³±±
±±³          ³ ExpC1 = Tipo de Operacao Tabela "DF" do SX5                  ³±±
±±³          ³ ExpC2 = Codigo do Cliente ou Fornecedor                      ³±±
±±³          ³ ExpC3 = Codigo do gracao E-Entrada                           ³±±
±±³          ³ ExpC4 = Tipo de Operacao E-Entrada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/       
// u_MaTesVia          (1,     M->D1_OPER,cA100For,cLoja,If(cTipo$"DB","C","F"),M->D1_COD,"D1_TES")       
            
User Function MaTesGol(nEntSai,cTpOper,   cClieFor,cLoja,cTipoCF,              cProduto,   cCampo)
                                                                                                         
//Local aArea		:= GetArea()
//Local aAreaSA1	:= SA1->(GetArea())
//Local aAreaSA2	:= SA2->(GetArea())
//Local aAreaSB1	:= SB1->(GetArea())
//Local aAreaSFM	:= SFM->(GetArea())
//Local aAreaSF4	:= SF4->(GetArea())
//Local aTes 		:= {}
//Local aDadosCfo := {} 
Local cTesRet	:= "   "
//Local cGrupo	:= ""
//Local cGruProd	:= ""
Local cQuery	:= ""  
Local cProg     := "MT100"
Local cAliasSFM := "SFM"         
//Local cTabela   := ""
Local lQuery	:= .F.
//Local nPosCpo	:= 0
//Local nPosCfo   := 0
Local cUF := ""

//DEFAULT cTpOper := &(ReadVar())
DEFAULT cClieFor:= ""
DEFAULT cProduto:= ""
DEFAULT nEntSai := 0
DEFAULT cTipoCF := "C"
DEFAULT cCampo	:= ""

Private cTipoCliFor := Iif(cTipoCF == "C",;
        Iif(Empty(SA1->A1_INSCR).or."ISENT"$upper(SA1->A1_INSCR), "I", SA1->A1_TIPO) ,;
        Iif(Empty(SA2->A2_INSCR).or."ISENT"$upper(SA2->A2_INSCR), "I", SA2->A2_TIPO) )

Private cEstCliFor  := Iif(cTipoCF == "C", SA1->A1_EST , SA2->A2_EST )

// Grupo Tributário Cliente
dbSelectArea(IIf(cTipoCF == "C","SA1","SA2"))
If cTipoCF == "C"
	cGrupo := SA1->A1_GRPTRIB
Else
	cGrupo := SA2->A2_GRPTRIB
EndIf

// Grupo Tributário Produto
dbSelectArea("SB1")
cGruProd := SB1->B1_GRTRIB

cQuery += "SELECT " + iif(cTipoCF == "C","FM_TS","FM_TE") 
cQuery += "  FROM " + RetSqlName("SFM") + " SFM "  
cQuery += " WHERE SFM.D_E_L_E_T_ = '' "                           
cQuery += "   AND SFM.FM_FILIAL  = '' "
cQuery += "   AND SFM.FM_EST     = '" + SM0->M0_EstEnt + "' "
cQuery += "   AND SFM.FM_TIPO    = '" + cTpOper        + "' "
cQuery += "   AND (SFM.FM_GRPROD = '" + cGruProd       + "' OR SFM.FM_GRPROD = '') "    
cQuery += "   AND (SFM.FM_GRTRIB = '" + cGrupo         + "' OR SFM.FM_GRTRIB = '') "     
cQuery += "   AND SFM.FM_UFDEST LIKE '%" + iif(cTipoCF == "C",SA1->A1_Est,SA2->A2_Est) + "%' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cSQL",.T.,.T.)

dbSelectArea("cSQL")
if !eof()
	cTesRet := iif(cTipoCF == "C", cSQL->FM_TS, cSQL->FM_TE)
endif
dbCloseArea()

Return(cTesRet) 