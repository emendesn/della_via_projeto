/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ020SD1  �Autor  �Marcelo Alcantara   � Data �  11/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para embutir o desconto da vebda no valor  ���
���          �da mercadoria                                               ���
�������������������������������������������������������������������������͹��
���Uso       �Della Via                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function LJ020SD1
Local _aArea
Local _nDecs     := MsDecimais(IIf(Type("nMoedaTr")=="N",nMoedaTr,1))

SD1->D1_VUNIT	:= SD1->D1_VUNIT - Round(SD1->D1_VALDESC / SD1->D1_QUANT, _nDecs)	// Grava os Campo do Valor Unitario ja com desconto
SD1->D1_TOTAL	:= Round(SD1->D1_VUNIT * SD1->D1_QUANT,_nDecs)			  			// Totaliza novamente
SD1->D1_DESC	:= 0.00																//Zera o Desconto
SD1->D1_VALDESC	:= 0.00																//Zera o Valor do Desconto

// Vai Ate a tabela SF1
_aArea:= GetArea()
RECLOCK("SF1",.F.)
SF1->F1_VALMERC	:= SF1->F1_VALMERC - SF1->F1_DESCONT 					//Grava os Campo do Valor Unitario ja com desconto
SF1->F1_DESCONT	:= 0.00													//Zera o Valor do Desconto

SF1->(MSUNLOCK())
RestArea( _aArea )

Return
