#include "rwmake.ch"

User Function FA430SE2()        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  FA430SE2 � Autor � Claudio Diniz   � Data � 04/08/05 �     ��
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

dbSelectArea("SE2")
dbSetOrder(11)
IF dbSeek(cFilant+_cIdCnab)
 lHelp := .F.
Else
 lHelp := .T.
End

Return lHelp
