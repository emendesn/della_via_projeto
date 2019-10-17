#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A260LOCAL �Autor  �Reinaldo Caldas     � Data �  03/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para criacao registro no SB2 caso este    ���
���          � ainda nao exista                                           ���
�������������������������������������������������������������������������͹��
���Uso       � DellaVia/Durapol                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A260Loc(cCodOrig,cLocOrig)

Local _aArea  := GetArea()
Local _cCod   := Paramixb[1]
Local _cLocal := Paramixb[2]

dbSelectArea("SB2")
dbSetOrder(1)
IF ! (dbSeek(xFilial("SB2")+_cCod+_cLocal))
	Reclock("SB2",.T.)
		SB2->B2_FILIAL:= xFilial("SB2")
		SB2->B2_COD   := _cCod
		SB2->B2_LOCAL := _cLocal
	MsUnlock()
EndIF

RestArea(_aArea)
Return