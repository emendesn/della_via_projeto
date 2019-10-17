#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidaD3  �Autor  �Marcelo Alcantara   � Data �  16/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao do Campo D3_COD da Tela de Tranf entre armazens  ���
���          � MATA261 para nao deixar o usuario trocar codigo de destino ���
�������������������������������������������������������������������������͹��
���Parametros�  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - D3_COD da origem = D3_COD Destino             ���
���          �        .F. - D3_COD da origem <> D3_COD Destino            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Validacao de Usuario do campo SD3->D3_COD                  ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                          	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ValidaD3()
Local aArea		:= GetArea()
Local lRet		:= .T.
Local nPosd3	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D3_COD") }) //Posicao do campo D3_COD

If FunName() = "MATA261"					//Se For MATA261
	If oGet:oBrowse:ColPos <> nPosd3		//Pega Posicao da coluna no acols atual		
		If &(Readvar()) <> acols[n][nPosd3]	//Se o valor digitado no cod de destino for <> na origem 
			msgBox(" O Codigo de Origem e Destino nao podem ser diferentes ")
			lRet:= .F.
		ENDIF
	Else
		acols[n][6]:= &(Readvar())			//Preenche o Acols de Codigo de Destino com o mesmo valod do de origem
	EndIf
EndIf

RestArea(aArea)		//Restaura area
Return lRet
