#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070BXL  �Autor  �ZE MANE             � Data �  19/10/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para possibilitar ao usuario a informa�ao ���
���          � da data do credito do lote                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION FA070BXL()
LOCAL dDataCred := PARAMIXB
LOCAL nOPc1 := 1                 

RecLock("SE5",.f.)
//SE5->E5_DTDISPO := POSICIONE("SE1",1,xFilial("SE1")+SE5->E5_NUMERO,"E5_DATA")
SE5->E5_DTDISPO := SE5->E5_DATA
MsUnlock()


Return(.T.)