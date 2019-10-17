#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A261LOCAL �Autor  �Reinaldo Caldas     � Data �  03/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para criacao registro no SB2 caso este    ���
���          � ainda nao exista                                           ���
�������������������������������������������������������������������������͹��
���Uso       � DellaVia/Durapol                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A261Loc

Local _aArea     := GetArea()
Local _nPosCod   :=  aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D3_COD"})
Local _cLocal    := M->D3_LOCAL //_nPosLocal := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D3_LOCAL"})

dbSelectArea("SB2")
dbSetOrder(1)
IF ! (dbSeek(xFilial("SB2")+aCols[n,_nPosCod]+_cLocal))
	IF !aCols[n,Len(aHeader)+1]
		Reclock("SB2",.T.)
			SB2->B2_FILIAL:= xFilial("SB2")
			SB2->B2_COD   := aCols[n,_nPosCod]
			SB2->B2_LOCAL := _cLocal
		MsUnlock()
	EndIF	
EndIF

RestArea(_aArea)
Return