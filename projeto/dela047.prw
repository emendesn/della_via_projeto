#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA047   � Autor �Norbert Waage Junior� Data �  17/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina responsavel pelo tratamento de descontos na venda as-���
���          �sitida, respeitando o valor de desconto estabelecido no ca- ���
���          �dastrp de descontos(PAN,PAO).                               ���
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
���Norbert   �11/01/06�------�Tratamento de decimais no desconto em valor.���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA047()

Local lRet 		:= .T.
Local aOpcErr	:= {"este grupo de produto.","esta loja."}
Local cProduto	:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "LR_PRODUTO"})]
Local nVlrItem	:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "LR_VLRITEM"})]
Local cGrupo	:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SBM")+cProduto,1,"")
Local nOpcErr	:= 0
Local nPerDscLj	:= GetAdvFVal("PAN","PAN_DESCLJ",xFilial("PAN")+cFilAnt,1,0)
Local nPerDscGr	:= GetAdvFVal("PAO","PAO_DESC",xFilial("PAO")+cFilAnt+cGrupo,1,0)
Local nPerDesc	:= IIF(nPerDscGr == 0,(nOpcErr:=1,nPerDscLj),(nOpcErr:=2,nPerDscGr))
Local nVlrDesc	:= &(ReadVar())
Local nTolera	:= (1/(10 ** nDecimais))/2
Local nDif		:= 0

//���������������������������������������������������������Ŀ
//�********************** IMPORTANTE ***********************�
//�Admite-se uma tolerancia de meia unidade decimal         �
//�(0.005 p/ nDecimais = 2)                                 �
//�Usa-se somente o simbolo '<' e nao '<=' para que tenha-se�
//�certeza de que o percentual de desconto nao sera         �
//�arredondado para um decimal acima.                       �
//�����������������������������������������������������������

//�����������������������������������������������Ŀ
//�Se a rotina foi acionada pelo valor de desconto�
//�������������������������������������������������
If AllTrim(ReadVar()) == "M->LR_VALDESC"
	
	//�������������������������������������������������������Ŀ
	//�Se o desconto for maior que o permitido, zera variaveis�
	//���������������������������������������������������������
	If !(((nVlrDesc/(nVlrItem + nVlrDesc)) * 100) <= nPerDesc )

		nDif	:= Abs(nPerDesc - ((nVlrDesc/(nVlrItem + nVlrDesc)) * 100))

		//����������������������������������������������������������Ŀ
		//�Se ainda com tolerancia o desconto ultrapassa o permitido,�
		//�nao permite o desconto                                    �
		//������������������������������������������������������������
		If !(nDif < nTolera)
			lRet := .F.
			M->LR_VALDESC := 0
		Endif

	EndIf

//��������������������������������������������Ŀ
//�Se a rotina foi acionada pelo % de desconto �
//����������������������������������������������
ElseIf AllTrim(ReadVar()) == "M->LR_DESC"

	//�������������������������������������������������������Ŀ
	//�Se o desconto for maior que o permitido, zera variaveis�
	//���������������������������������������������������������            
	If !( nVlrDesc <= nPerDesc )
	
		nDif	:= Abs(nVlrDesc - nPerDesc)

		//����������������������������������������������������������Ŀ
		//�Se ainda com tolerancia o desconto ultrapassa o permitido,�
		//�nao permite o desconto                                    �
		//������������������������������������������������������������
		If !(nDif < nTolera)
			lRet := .F.
			M->LR_DESC	 := 0
		EndIf

	EndIf

EndIf

//���������������������������������������������������������������Ŀ
//�Notifica o usuario e retorna .T.                               �
//�*NOTA: Se a rotina retornar .F., o campo selecionado permitira �
//�que pressione-se ESC, retornando ao valor de desconto anterior,�
//�porem sem que este tenha sido aplicado aos valores             �
//�����������������������������������������������������������������
If !lRet                                                                                                
	aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "LR_VALDESC"})] := 0
	aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "LR_DESC"})] := 0
	oGetVA:oBrowse:Refresh()
	MsgAlert("O desconto aplicado � maior do que o desconto permitido para este grupo de produto","Desconto")
	lRet := .T.
EndIf

Return lRet