#include "rwmake.ch"

User Function FR650FIL()        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  FR650FIL � Autor � Claudio Diniz   � Data � 16/05/05 �     ��
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtro titulos de multiplas filiais                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Della Via Pneus                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
/*/ 


Return dbSeek(Substr(cNumtit,1,12))
