#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA044   � Autor �Norbert Waage Junior� Data �  12/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina responsavel pelo tratamento de descontos no televen- ���
���          �das, respeitando o desconto estabelecido no cadastro de     ���
���          �operadores                                                  ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - (.T.) Valida a alteracao do desconto sempre, pois    ���
���          �a negacao permite que se retorne ao valor antigo, caso o    ���
���          �usuario pressione ESC.                                      ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada apos a digitacao do desconto ou do valor do ���
���          �desconto.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA044()

Local aArea		:= GetArea()
Local lRet 		:= .T.
Local nDesc		:= 0
Local nVlrDesc	:= 0
Local nVlrItem	:= 0
Local nQuant	:= 0
Local nDescAtu	:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})]

//�����������������������Ŀ
//�Le desconto do operador�
//�������������������������
nDesc := GetAdvFVal("SU7","U7_PERDESC",xFilial("SU7")+TkOperador(),1,0)

//�����������������������������������������������Ŀ
//�Se a rotina foi acionada pelo valor de desconto�
//�������������������������������������������������
If AllTrim(ReadVar()) == "M->UB_VALDESC"

	nVlrItem	:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VLRITEM"})]
	nQuant		:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT"})]
	nVlrDesc 	:= &(ReadVar())
	
	//�������������������������������������������������������Ŀ
	//�Se o desconto for maior que o permitido, zera variaveis�
	//���������������������������������������������������������
	If !(lRet :=  (nVlrDesc/((nVlrItem + nDescAtu))) * 100 <= nDesc )
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})] := 0
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_DESC"})] := 0
		M->UB_VALDESC := 0
		TK273Calcula("UB_VALDESC")
	EndIf

//��������������������������������������������Ŀ
//�Se a rotina foi acionada pelo % de desconto �
//����������������������������������������������
ElseIf AllTrim(ReadVar()) == "M->UB_DESC"    

	//�������������������������������������������������������Ŀ
	//�Se o desconto for maior que o permitido, zera variaveis�
	//���������������������������������������������������������
	If !(lRet := &(ReadVar()) <= nDesc )
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})] := 0
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_DESC"})] := 0
		M->UB_DESC := 0
		Tk273Calcula("UB_DESC")
	EndIf

EndIf

//���������������������������������������������������������������Ŀ
//�Notifica o usuario e retorna .T.                               �
//�*NOTA: Se a rotina retornar .F., o campo selecionado permitira �
//�que pressione-se ESC, retornando ao valor de desconto anterior,�
//�porem sem que este tenha sido aplicado aos valores             �
//�����������������������������������������������������������������
If !lRet                                                                                                
	MsgAlert("O desconto aplicado � maior do que o desconto permitido para o operador atual","Desconto")
	oGetTlv:oBrowse:Refresh()
	lRet := .T.
EndIf

RestArea(aArea)

Return lRet