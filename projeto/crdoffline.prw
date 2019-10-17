#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRDOFFLINE�Autor  �Norbert Waage Junior� Data �  02/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao �Ponto de entrada utilizado para obrigar o operador da rotina���
���          �de vendas a informar uma chave de liberacao caso o CRD este-���
���          �ja offline no momento da finalizacao da venda.              ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - Verdadeiro caso a venda possa ser finalizada         ���
���          �     - Negativo caso contrario                              ���
�������������������������������������������������������������������������͹��
���Aplicacao �Ponto de entrada na validacao da venda forcada, acionada se ���
���          �a rotina de venda nao conseguir acessar o CRD.              ���
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
User Function CRDOFFLINE()

Local aArea		:= GetArea()
Local lRet 		:= .F.
Local aCampos	:= {}

//����������������������������������������������Ŀ
//�Configura os parametros de acordo com a rotina�
//������������������������������������������������
If IsInCallStack("LOJA701")

	AAdd(aCampos,M->LQ_NUM)
	AAdd(aCampos,cFilAnt)
	AAdd(aCampos,M->LQ_CLIENTE)
	AAdd(aCampos,M->LQ_LOJA)
	AAdd(aCampos,Lj7T_Total(2))
	AAdd(aCampos,dDatabase)
	AAdd(aCampos,"LOJA701")
		
ElseIf IsInCallStack("TMKA271")

	AAdd(aCampos,M->UA_NUM)
	AAdd(aCampos,cFilAnt)
	AAdd(aCampos,M->UA_CLIENTE)
	AAdd(aCampos,M->UA_LOJA)
	AAdd(aCampos,aValores[6])
	AAdd(aCampos,dDatabase)
	AAdd(aCampos,"TMKA271")

EndIf

//��������������������������������������������Ŀ
//�Aciona a tela de validacao da venda off-line�
//����������������������������������������������
If Len(aCampos) > 0
	lRet := P_DELA054A(aCampos)
EndIf

RestArea(aArea)

Return lRet