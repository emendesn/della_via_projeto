#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �CRD004    �Autor  �Norbert Waage Junior   � Data �  04/09/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para retornar o CNPJ/CPF do cliente atual    ���
����������������������������������������������������������������������������͹��
���Parametros� Nao se Aplica                                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � cRet - CNPJ ou CPF do cliente                                 ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada na montagem da tela de selecao de dados para ���
���          � consulta do cliente no CRD, onde retorna-se o CNPJ/CPF        ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���			 �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function CRD004()

Local aArea		:= GetArea()
Local cCliente  := ""
Local cRet		:= ""

//������������������������������������������������������������������Ŀ
//�Verifica qual a rotina atual para ler valores corretos de memoria.�
//�Se a rotina nao foi acionada pelo televendas e nem pelo           �
//�venda assistida, assume os valores do SA1                         �
//��������������������������������������������������������������������

If P_NaPilha("LOJA701")		//Venda Assistida
	cCliente := M->LQ_CLIENTE+M->LQ_LOJA
ElseIf P_NaPilha("TMKA271")	//Televendas
	cCliente := M->UA_CLIENTE+M->UA_LOJA
Else						//Demais processos
	cCliente := SA1->(A1_COD+A1_LOJA)
EndIf

//Retorno do CNPJ/CPF
cRet := GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+cCliente,1,"")

RestArea(aArea)

Return cRet