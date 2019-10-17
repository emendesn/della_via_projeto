#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SX5NOTA   �Autor  �Reinaldo Caldas     � Data �  03/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para todas as series cadastradas e que    ���
���          � serao consideradas validas                                 ���
�������������������������������������������������������������������������͹��
���Uso       � DellaVia/Durapol                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SX5NOTA

Local _aArea     := GetArea()
Local _lRet      := .T.
Local _cSeries   := GetMV("MV_X_SERIE",.F.,"SEM_PARAMETRO") //Parametro que contem as series validas por filial separados por /

IF SM0->M0_CODIGO == "03"  //Considero somente para a empresa 03
	IF _cSeries != "SEM_PARAMETRO"
		IF ! Alltrim(SX5->X5_CHAVE) $ _cSeries
			_lRet := .F.
		EndIF
	EndIF
EndIF	
RestArea(_aArea)
Return(_lRet)