#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT089     �Autor  �Microsiga           � Data �  08/10/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Programa  � MATA089  � Autor � Aline Correa do Vale  � Data � 07.08.2002 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de TES Inteligente                                  ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function Mt089()
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
		{ "Visualizar",	"AxVisual"  , 0 , 2},;
		{ "Incluir",  "u_AViaInclui", 0 , 3},;
		{ "Alterar",  "u_AViaAltera", 0 , 4},;
		{ "Excluir",  "AxDeleta"  , 0 , 5} }

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
User Function AViaInclui(cAlias,nReg,nOpc)

Local nOpca := 0
INCLUI := .T.
ALTERA := .F.

//��������������������������������������������Ŀ
//� Envia para processamento dos Gets          �
//����������������������������������������������
nOpcA:=0

Begin Transaction
	nOpcA:=AxInclui( cAlias, nReg, nOpc,,,,"u_AViaTudOk()")
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
User Function AViaAltera(cAlias,nReg,nOpc)

Local nOpca := 0
INCLUI := .F.
ALTERA := .T.

//��������������������������������������������Ŀ
//� Envia para processamento dos Gets          �
//����������������������������������������������
nOpcA:=0

Begin Transaction
	nOpcA:=AxAltera( cAlias, nReg, nOpc,,,,,"A089TudOk()")
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
User Function AViaTudOk()
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
//D1        u_MaTesVia(1,      M->D1_OPER,cA100For,cLoja,If(cTipo$"DB","C","F"),M->D1_COD,"D1_TES")                   
User Function MaTesVia(nEntSai,cTpOper,   cClieFor,cLoja,cTipoCF               ,cProduto ,cCampo)

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSA2	:= SA2->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSFM	:= SFM->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())
Local aTes 		:= {}
Local aDadosCfo := {} 
Local cTesRet	:= "   "
Local cGrupo	:= ""
Local cGruProd	:= ""
Local cQuery	:= ""  
Local cProg     := "MT100"
Local cAliasSFM := "SFM"         
Local cTabela   := ""
Local lQuery	:= .F.
Local nPosCpo	:= 0
Local nPosCfo   := 0

DEFAULT cTpOper  := &(ReadVar())
DEFAULT cClieFor := ""
DEFAULT cProduto := ""
DEFAULT nEntSai  := 0
DEFAULT cTipoCF  := "C"
DEFAULT cCampo	 := ""

Private cTipoCliFor := Iif(cTipoCF == "C",;
        Iif(Empty(SA1->A1_INSCR).or."ISENT"$upper(SA1->A1_INSCR), "I", SA1->A1_TIPO) ,;
        Iif(Empty(SA2->A2_INSCR).or."ISENT"$upper(SA2->A2_INSCR), "I", SA2->A2_TIPO) )
Private cEstCliFor  := Iif(cTipoCF == "C", SA1->A1_EST , SA2->A2_EST )

If !Empty(cCampo)
	nPosCpo	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(cCampo) })
	cTabela  := aHeader[nPosCpo,9]
EndIf
//��������������������������������������������������������������Ŀ
//� Verifica o grupo de tributacao do cliente/fornecedor         �
//����������������������������������������������������������������
dbSelectArea(IIf(cTipoCF == "C","SA1","SA2"))
dbSetOrder(1)
MsSeek(xFilial()+cClieFor+cLoja)
If cTipoCF == "C"
	cGrupo := SA1->A1_GRPTRIB
Else
	cGrupo := SA2->A2_GRPTRIB
EndIf
//��������������������������������������������������������������Ŀ
//� Verifica o grupo do produto                                  �
//����������������������������������������������������������������
dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+cProduto)
cGruProd := SB1->B1_GRTRIB
//��������������������������������������������������������������Ŀ
//� Pesquisa por todas as regras validas para este caso          �
//����������������������������������������������������������������
#IFDEF TOP
	lQuery := .T.
	cAliasSFM := GetNextAlias() 
	cQuery += "SELECT * FROM " + RetSqlName("SFM") + " SFM "
	cQuery += "WHERE SFM.FM_FILIAL = '" + xFilial("SFM") + "'"
	cQuery += "AND SFM.FM_TIPO = '" + cTpOper + "'"
	cQuery += "AND SFM.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder(SFM->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFM,.T.,.T.)
#ELSE
	dbSelectArea("SFM")
	dbSetOrder(1)
	MsSeek(xFilial("SFM")+cTpOper)
#ENDIF

While !Eof() .And. (cAliasSFM)->FM_TIPO==cTpOper
	If cTipoCF == "C" 
		If (Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD+(cAliasSFM)->FM_UFDEST) .And. (cAliasSFM)->FM_TPCLFOR=="*") .Or.;
			(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
			 (cGruProd == (cAliasSFM)->FM_GRPROD .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
			 (cClieFor+cLoja == (cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI .Or. Empty((cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI)) .And.;
			 (cGrupo == (cAliasSFM)->FM_GRTRIB .Or. Empty((cAliasSFM)->FM_GRTRIB)) .And.;
			 (cTipoCliFor == (cAliasSFM)->FM_TPCLFOR .Or. (cAliasSFM)->FM_TPCLFOR=="*") .And.;
			 (cEstCliFor $ (cAliasSFM)->FM_UFDEST .Or. Empty((cAliasSFM)->FM_UFDEST)))
			aadd(aTes, {(cAliasSFM)->FM_PRODUTO, (cAliasSFM)->FM_GRPROD, (cAliasSFM)->FM_CLIENTE, (cAliasSFM)->FM_LOJACLI, (cAliasSFM)->FM_GRTRIB, (cAliasSFM)->FM_TPCLFOR, (cAliasSFM)->FM_UFDEST, (cAliasSFM)->FM_TE, (cAliasSFM)->FM_TS})
		EndIf
	Else
		If (Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD+(cAliasSFM)->FM_UFDEST) .And. (cAliasSFM)->FM_TPCLFOR=="*") .Or.;
			(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
			 (cGruProd == (cAliasSFM)->FM_GRPROD .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
			 (cClieFor+cLoja == (cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR .Or. Empty((cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR)) .And.;
			 (cGrupo == (cAliasSFM)->FM_GRTRIB .Or. Empty((cAliasSFM)->FM_GRTRIB)) .And.;
			 (cTipoCliFor == (cAliasSFM)->FM_TPCLFOR .Or. (cAliasSFM)->FM_TPCLFOR=="*") .And.;
			 (cEstCliFor $ (cAliasSFM)->FM_UFDEST .Or. Empty((cAliasSFM)->FM_UFDEST)))
			aadd(aTes, {(cAliasSFM)->FM_PRODUTO, (cAliasSFM)->FM_GRPROD, (cAliasSFM)->FM_FORNECE, (cAliasSFM)->FM_LOJAFOR, (cAliasSFM)->FM_GRTRIB, (cAliasSFM)->FM_TPCLFOR, (cAliasSFM)->FM_UFDEST, (cAliasSFM)->FM_TE, (cAliasSFM)->FM_TS})
		EndIf
	EndIf
	dbSelectArea(cAliasSFM)
	dbSkip()
EndDo
If ( lQuery )
	dbSelectArea(cAliasSFM)
	dbCloseArea()
	dbSelectArea("SFM")
EndIf
//��������������������������������������������������������������Ŀ
//� Pesquisa por todas as regras validas para este caso          �
//����������������������������������������������������������������
aSort(aTES,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7] > y[1]+y[2]+y[3]+y[4]+y[5]+y[6]+y[7]})

If Len(aTes) <> 0

	cTesRet := If(nEntSai==1,aTes[1][8],aTes[1][9])

//���������������������������������������������������Ŀ
//�Inclusao - Norbert - 01/09/05                      �
//�Tratamento para casos onde o TES nao foi encontrado�
//�����������������������������������������������������
Else
	
	//��������������������Ŀ
	//�Busca TES do produto�
	//����������������������
	If Empty(cTesRet := GetAdvFVal("SB1",IIf(nEntSai == 1,"B1_TE","B1_TS"),xFilial("SB1")+cProduto,1,""))
		
		//������������������������������������������������������Ŀ
		//�Se ainda em branco, busca TES nos parametros MV_TESENT�
		//�e MV_TESSAI                                           �
		//��������������������������������������������������������
		cTesRet	:=	AllTrim(GetMv("MV_TES" + IIf(nEntSai == 1,"ENT","SAI")))

	EndIf
	
//���������������������������������������������������Ŀ
//�Fim Inclusao - Norbert - 01/09/05                  �
//�����������������������������������������������������
EndIf


If nPosCpo > 0 .And. !Empty(cTesRet) .And. Type('aCols') <> "U"
	aCols[n][nPosCpo] := cTesRet
	Do Case
		Case cTabela == "SD1"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_CF") })
		Case cTabela == "SD2"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_CF") })
		Case cTabela == "SC6"     
			dbSelectArea("SF4")
			dbSetOrder(1)
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_CF") })
			If nPosCfo > 0 .And. MsSeek(xFilial("SF4")+cTesRet)
				aDadosCfo := {} 
			 	AAdd(aDadosCfo,{"OPERNF","S"})
			 	AAdd(aDadosCfo,{"TPCLIFOR",If(cTipoCF == "C", SA1->A1_TIPO , SA2->A2_TIPO )})
			 	AAdd(aDadosCfo,{"UFDEST"  ,If(cTipoCF == "C", SA1->A1_EST  , SA2->A2_EST  )})
			 	AAdd(aDadosCfo,{"INSCR"   ,If(cTipoCF == "C", SA1->A1_INSCR, SA2->A2_INSCR)})
				aCols[n][nPosCfo] := MaFisCfo( ,SF4->F4_CF,aDadosCfo ) 
			EndIf
			nPosCfo := 0      
		Case cTabela == "SC7"
			cProg := "MT120"
		Case cTabela == "SC8"
			cProg := "MT150"
		Case cTabela == "SUB"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_CF") })
			cProg := "TK273"
	EndCase
	If nPosCfo > 0
		aCols[n][nPosCfo] := Space(Len(aCols[n][nPosCfo]))
	EndIf
	If MaFisFound("IT",N) .and. !(funname() $ "LOJA430/")
		MaFisAlt("IT_TES",cTesRet,n)
		MaFisRef("IT_TES",cProg,cTesRet)
	EndIf
EndIf
If !Empty(cTesRet)
	dbSelectArea("SF4")
	If MsSeek(xFilial("SF4")+cTesRet)
		If !RegistroOK("SF4")
			cTesRet := Space(Len(cTesRet))
		EndIf
	EndIf
EndIf
//��������������������������������������������������������������Ŀ
//� Restaura a integridade da rotina                             �
//����������������������������������������������������������������
RestArea(aAreaSFM)
RestArea(aAreaSF4)
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aAreaSB1)
RestArea(aArea) 

Return(cTesRet) 