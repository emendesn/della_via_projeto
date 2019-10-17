#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELC005  �Autor  �Anderson Kurtinaitis� Data �  04/08/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � andkurt@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Mostra informacoes da Nota Fiscal de Entrada ao usuario    ���
���          � quando a venda de um produto usado esta sendo efetuada     ���
���          � atraves da rotina de Troca                                 ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atravez de um gatilho no campo LR_LOTECTL, na      ���
���          � rotina de troca de produtos                                ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Project Function DELC005()

//Variaveis Locais da Funcao
Local cProduto	:= Space(TamSX3("L2_PRODUTO")[1])
Local cNFSerie	:= Space(TamSX3("D1_DOC")[1])+Space(1)+Space(TamSX3("D1_SERIE")[1])
Local cValorEn	:= 0
Local cDataNFE	:= Space(TamSX3("D1_EMISSAO")[1])
Local oProduto
Local oNFSerie
Local oValorEn
Local oDataNFE

// Variaveis Private da Funcao
Private _oDlg
Private INCLUI	:= .F.

// Variaveis para funcionamento da rotina
Private cQuery		:= ""
Private _cLoteCtl	:= M->LR_LOTECTL
Private _aArea		:= GetArea()
Private _aAreaSX7	:= SX7->(GetArea())
Private _aAreaSD1	:= SD1->(GetArea())

//����������������������������������������������������������Ŀ
//�A rotina aborta caso o usuario nao tenha informado um lote�
//������������������������������������������������������������
If Empty (_cLoteCtl)
	RestArea(_aArea)
	Return _cLoteCtl
EndIf

// Antes de mostrar a MSDIALOG os dados sao pesquisados e armazenados nas variaveis apropriadas
#IFDEF TOP  //Rotina para TopConnect

	//Geracao da Query
	cQuery	:=	"SELECT SD1.D1_LOTECTL, SD1.D1_NUMLOTE, SD1.D1_VUNIT, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_COD, SD1.D1_EMISSAO "
	cQuery	+=	"FROM " + RetSqlName("SD1") + " SD1 "
	cQuery	+=	"WHERE SD1.D1_LOTECTL = '" + _cLoteCTL + "' and SD1.D1_FILIAL = '" + xFilial("SD1") + "' and SD1.D_E_L_E_T_ != '*'"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
	
	DbSelectArea("TMP")
	
	If !TMP->(Eof())
		
		cProduto	:= TMP->D1_COD
		cNFSerie	:= TMP->D1_DOC+"/"+TMP->D1_SERIE
		cValorEn	:= TMP->D1_VUNIT
		cDataNFE	:= Substr(TMP->D1_EMISSAO,7,2) + "/" + Substr(TMP->D1_EMISSAO,5,2) + "/" + Substr(TMP->D1_EMISSAO,1,4)
		
	Else // Nao encontrou o LOTE
		
		MsgAlert(OemtoAnsi("O Lote informado NAO EXISTE, verifique !"), "Aviso")
		_cLoteCtl	:= Space(TamSX3("LR_LOTECTL")[1])

		RestArea(_aAreaSX7)
		RestArea(_aAreaSD1)
		RestArea(_aArea) 
		
		TMP->(DbCloseArea())
	
		Return(_cLoteCtl)
		
	EndIf
	
	TMP->(DbCloseArea())
	
#ELSE	//Rotina para Ctree
	
	//����������������������Ŀ
	//�Cria indice temporario�
	//������������������������
	cArq := CriaTrab(Nil,.F.)
	DbSelectArea("SD1")	
	IndRegua("SD1",cArq,"D1_FILIAL+D1_LOTECTL+D1_NUMLOTE")
	                         
	cChave := xFilial('SD1') + _cLoteCTL  
	
	//�����������������������������������������������������Ŀ
	//�Busca o numero/letra da ultima parcela para o tipo FI�
	//�������������������������������������������������������
	If SD1->(DbSeek(cChave))

		cProduto	:= SD1->D1_COD
		cNFSerie	:= SD1->D1_DOC+"/"+SD1->D1_SERIE
		cValorEn	:= SD1->D1_VUNIT
		cDataNFE	:= Substr(SD1->D1_EMISSAO,7,2) + "/" + Substr(SD1->D1_EMISSAO,5,2) + "/" + Substr(SD1->D1_EMISSAO,1,4)
	
	Else

		MsgAlert(OemtoAnsi("O Lote informado NAO EXISTE, verifique !"), "Aviso")
		_cLoteCtl	:= Space(TamSX3("LR_LOTECTL")[1])

		RestArea(_aAreaSX7)
		RestArea(_aAreaSD1)
		RestArea(_aArea) 
		
		TMP->(DbCloseArea())
	
		Return(_cLoteCtl)
	
	EndIf

	//������������������������Ŀ
	//�Apaga arquivo temporario�
	//��������������������������
	RetIndex("SD1")
	DbSetorder(1)
	Ferase(cArq+OrdBagExt())                                     
	RestArea(_aAreaSD1)
			
#ENDIF

// Interface com usuario
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Informacoes sobre o Lote") FROM C(284),C(203) TO C(366),C(717) PIXEL

// Cria Componentes Padroes do Sistema
@ C(002),C(030) Say "INFORMACOES SOBRE O LOTE ESCOLHIDO:" Size C(159),C(008) COLOR CLR_RED PIXEL OF _oDlg
@ C(015),C(003) Say "Produto" Size C(020),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
@ C(013),C(028) MsGet oProduto Var cProduto Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg when .F.
@ C(015),C(100) Say "Nota/Serie" Size C(028),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
@ C(013),C(132) MsGet oNFSerie Var cNFSerie Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg when .F.
@ C(030),C(003) Say "Valor" Size C(014),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
@ C(027),C(028) MsGet oValorEN Var cValorEN Size C(060),C(009) COLOR CLR_BLACK PICTURE PesqPict("SD1","D1_VUNIT") PIXEL OF _oDlg when .F.
@ C(030),C(100) Say "Data" Size C(013),C(008) COLOR CLR_BLUE PIXEL OF _oDlg
@ C(027),C(132) MsGet oDataNFE Var cDataNFE Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg when .F.
@ C(015),C(202) Button OemtoAnsi("&Sair") Size C(025),C(012) PIXEL OF _oDlg Action(Close(_oDlg))

ACTIVATE MSDIALOG _oDlg CENTERED

RestArea(_aAreaSX7)
RestArea(_aAreaSD1)
RestArea(_aArea)

Return(_cLoteCtl) // Retornando o conteudo esperado ao Campo do Gatilho

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C        �Autor  �Norbert Waage Junior� Data �  10/05/05   ���
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

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������

If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
	nTam *= 0.90
EndIf

Return Int(nTam)
