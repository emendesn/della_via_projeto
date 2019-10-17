#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FC010CON   �Autor  �Wagner Manfre       � Data �  06/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Consulta Especifica de log de cobranca                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FC010CON  
Local aSaveArea := GetArea()
Local nRegSE1   := SE1->(Recno())
Local cChave    := ""
saveInter() 
/* guardar para utilizacao futura em outro ponto de entrada
If !SE1->(Eof())
	dbSelectArea("SE1")
	cChave := xFilial("SZB")
	cChave += SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
	U_PesqSzB(cChave,SE1->E1_CLIENTE) 
else
	U_PesqSzB(nil,SE1->E1_CLIENTE)
Endif	
*/
U_PesqSzB(nil,SA1->A1_COD)

RestInter()
RestArea(aSaveArea)
Return nil