#include "rwmake.ch"

User Function FA200FIL()        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  FA200FIL � Autor � Claudio Diniz   � Data � 16/05/05 �     ��
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtro titulos de multiplas filiais                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Della Via Pneus                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
/*/ 
Local _aArea   := GetArea()
Local cFilAnt  := Substr(cNumtit,1,2)
Local _cIdCnab := Substr(cNumTit,3,10)

dbSelectArea("SE1")
dbSetOrder(16)
IF dbSeek(cFilant+_cIdCnab)
 lHelp := .F.
Else
 lHelp := .T.
End

Return lHelp
