#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GP670CPO � Autor � R.H. - Reginaldo      � Data � 15.07.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada Integracao GPE X FINANCEIRO               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���                     ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL. ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

USER FUNCTION GP670CPO()

RecLock('SE2',.F.)
SE2->E2_HIST   := RC1->RC1_DESCRI
SE2->E2_CONTAD := LEFT(Posicione('RCC',1,xFilial('RCC')+"U002"+Space(8)+RC1->RC1_CODTIT,"RCC_CONTEUD"),20)
SE2->E2_PORTADO:= 'FOL'
MSUNLOCK()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GP650CPO � Autor � R.H. - Reginaldo      � Data � 15.07.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada Gera��o Titulo no SIGAGPE                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���                     ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL. ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function GP650CPO()

Local aArea := GetArea()
Local cLoja := ""

DbSelectArea("SA2")
DbSetOrder(1)
If SA2->(DbSeek(xFilial('SA2')+RC1->RC1_FORNEC))
   cLoja := SA2->A2_LOJA
EndIF

DbSelectArea("RC1")
RC1->RC1_LOJA := cLoja

RestArea(aArea)

Return

