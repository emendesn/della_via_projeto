#include "rwmake.ch"        

User Function FA60FIL()        

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  FA60FIL � Autor � Claudio Diniz  � Data � 30/06/05 �       ��
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtro titulos no Bordero de Cobranca                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Della Via Pneus                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
/*/

SetPrvt("_CCLI,")
_cCli:= ".T."
/*
IF SM0->M0_CODIGO=="01"
 DbSelectArea("SLJ")
 DbSetOrder(3)
 If Dbseek(SM0->M0_CODIGO+SE1->E1_FILIA)
  _cCli:= "CPORT060==SLJ->LJ_BCO1"
 End
 DbSelectArea("SE1")
End
*/
If !EMPTY(SA1->A1_BCO1)
 _cCli:= "CPORT060==SA1->A1_BCO1"
End
If !EMPTY(SE1->E1_BCO1)
  _cCli:= "CPORT060==SE1->E1_BCO1"
End
Return(_cCli)        
