#INCLUDE "protheus.ch"

#DEFINE DESCONTO		2	// Valor total do desconto
#DEFINE TOTAL			6	// Total do Pedido

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �TKM271DesRod�Autor  �Norbert Waage Junior � Data �  04/09/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para validar o desconto no total da venda.   ���
����������������������������������������������������������������������������͹��
���Parametros� Nao se Aplica                                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - (.T.)Se o desconto estiver ok, (.F.) caso contrario.   ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado apos o preenchimento do descono no ���
���          � rodape do televendas.                                         ���
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
User Function TK271DesRod()

Local aArea		:= GetArea()
Local nPerDesc	:= GetAdvFVal("SU7","U7_PERDESC",xFilial("SU7")+TkOperador(),1,0)	//% de desconto do Operador
Local lRet 		:= ((( aValores[DESCONTO]/aValores[TOTAL]) * 100 ) <= nPerDesc )		//Calculo do retorno

//�������������������������������������������������������������Ŀ
//�Notifica o usuario caso o desconto seja maior que o permitido�
//���������������������������������������������������������������
If !lRet
	ApMsgAlert("O desconto informado � maior que o desconto permitido no cadastro de operadores","Inv�lido")
Else
	P_TmRodape()
EndIf

RestArea(aArea)

Return lRet