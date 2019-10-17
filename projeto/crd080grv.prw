#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CRD080LIB � Autor � Norbert Waage Junior  � Data �18/07/2005���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Fab.Express      �Contato � norbert@microsiga.com.br       ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Ponto de entrada utilizado para gravar o motivo da liberacao���
���          �ou bloqueio do credito do cliente                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nao se aplica.                                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nao se aplica.                                              ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �Gravar o motivo do bloqueio/liberacao do credito do cliente ���
�������������������������������������������������������������������������Ĵ��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CRD080GRV()

Local aArea		:=	GetArea()
Local aAreaMAH	:=	MAH->(Getarea())
Local cMotivo	:=	Space(TamSX3("MA7_MOTIVO")[1])
Local cObs		:=	Space(TamSX3("MA7_OBS")[1])

//�����������������������������������Ŀ
//�Exige a entrada dos dados de motivo�
//�������������������������������������
While !TelaMot(@cMotivo,@cObs)
End

//�������������������������Ŀ
//�Grava dados na tabela MA7�
//���������������������������
RecLock("MA7",.F.)
MA7->MA7_MOTIVO	:= cMotivo
MA7->MA7_OBS	:= cObs
MsUnLock()
dbCommit()

//�����������������������������������������������������������Ŀ
//�Grava informacoes de liberacao/bloqueio se os campos abaixo�
//�existirem na tabela MAH                                    �
//�������������������������������������������������������������

DbSelectArea("MAH")
DbSetOrder(1) //MAH_FILIAL+MAH_CONTRA

If DbSeek(xFilial("MAH")+MA7->MA7_CONTRA)
	If	(MAH->(FieldPos("MAH_USRAVL")) > 0) .And. (MAH->(FieldPos("MAH_DATAVL")) > 0) .And.;
		(MAH->(FieldPos("MAH_HORAVL")) > 0)
		RecLock("MAH",.F.)
		MAH->MAH_USRAVL	:= cUserName
		MAH->MAH_DATAVL	:= dDataBase
		MAH->MAH_HORAVL	:= Time()
		MsUnLock()
		dbCommit()
	EndIf
EndIf

RestArea(aAreaMAH)
RestArea(aArea)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TelaMot   �Autor  �Norbert Waage Junior� Data �  18/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela de recebimento dos dados do motivo da liberacao/bloque-���
���          �io do credito do cliente                                    ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TelaMot(cMotivo,cObs)

//Variaveis Locais da Funcao
Local lRet	:=	.F.
Local oEdit1
Local oEdit2
Local _oDlg

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Motivo") FROM C(178),C(181) TO C(334),C(551) PIXEL

// Cria as Groups do Sistema
@ C(007),C(005) TO C(060),C(181) LABEL "Selecione o motivo da libera��o/bloqueio" PIXEL OF _oDlg

// Cria Componentes Padroes do Sistema
@ C(019),C(011) Say "Motivo" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(019),C(045) MsGet oEdit1 Var cMotivo F3 "PAM" Valid VldMot(cMotivo) Size C(046),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(031),C(045) MsGet oEdit2 Var cObs Size C(122),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(032),C(012) Say "Observa��o" Size C(031),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(063),C(143) Button OemtoAnsi("Ok") Size C(037),C(012) PIXEL OF _oDlg Action(lRet := .T.,_oDlg:End())

ACTIVATE MSDIALOG _oDlg CENTERED

Return(lRet)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldMot    �Autor  �Norbert Waage Junior� Data �  08/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao do motivo selecionado pelo operador               ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldMot(cMot)

Local lRet := ( GetAdvFVal("PAM","PAM_TIPO",xFilial("PAM")+cMot,1,"") == MA7->MA7_BLOQUE )

If !lRet
	ApMsgAlert("O motivo selecionado � inv�lido","Valida��o")
EndIf

Return lRet
