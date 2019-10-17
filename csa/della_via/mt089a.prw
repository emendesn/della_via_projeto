#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
User Function Mt089A()
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
PRIVATE aRotina := { { "Pesquisar",	"AxPesqui"  , 0 , 1},;
		{ "Visualizar",	"AxVisual"   , 0 , 2},;
		{ "Incluir",    "u_Mt089AInc", 0 , 3},;
		{ "Alterar",    "u_Mt089AAlt", 0 , 4},;
		{ "Excluir",    "AxDeleta"   , 0 , 5} }

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := OemtoAnsi("TES Inteligente")

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse( 6, 1,22,75,"SFM")
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A089Inclui� Autor � Aline Correa do Vale  � Data � 13/08/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Inclusao de Tes Inteligente                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA089()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Mt089AInc(cAlias,nReg,nOpc)

Local nOpca := 0
INCLUI := .T.
ALTERA := .F.

//��������������������������������������������Ŀ
//� Envia para processamento dos Gets          �
//����������������������������������������������
nOpcA:=0

Begin Transaction
	nOpcA:=AxInclui( cAlias, nReg, nOpc,,,,"u_Mt089ATudOk()")
End Transaction
	
dbSelectArea(cAlias)
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A089Altera� Autor � Aline Correa do Vale  � Data � 13/08/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de Inclusao de Tes Inteligente                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA089()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Mt089AAlt(cAlias,nReg,nOpc)

Local nOpca := 0
INCLUI := .F.
ALTERA := .T.

//��������������������������������������������Ŀ
//� Envia para processamento dos Gets          �
//����������������������������������������������
nOpcA:=0

Begin Transaction
	nOpcA:=AxAltera( cAlias, nReg, nOpc,,,,,"Mt089ATudOk()")
End Transaction
	
dbSelectArea(cAlias)
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A089TudOk � Autor � Aline Correa do Vale � Data � 13/08/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o registro esta com chave duplicada            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A089TudOk()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA089                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Programa  � MATA089  � Autor � Aline Correa do Vale  � Data � 09.08.2002 ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � MaTesInt(ExpN1,ExcC1,ExpC2,ExpC3,ExpC4,ExpC5)                ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � ExpN1 = Documento de 1-Entrada / 2-Saida                     ���
���          � ExpC1 = Tipo de Operacao Tabela "DF" do SX5                  ���
���          � ExpC2 = Codigo do Cliente ou Fornecedor                      ���
���          � ExpC3 = Codigo do gracao E-Entrada                           ���
���          � ExpC4 = Tipo de Operacao E-Entrada                           ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
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

// Grupo Tribut�rio Cliente
dbSelectArea(IIf(cTipoCF == "C","SA1","SA2"))
If cTipoCF == "C"
	cGrupo := SA1->A1_GRPTRIB
Else
	cGrupo := SA2->A2_GRPTRIB
EndIf

// Grupo Tribut�rio Produto
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