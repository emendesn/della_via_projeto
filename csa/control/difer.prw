#include "rwmake.ch"        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � DIFER   � Autor � EUGENIO ARCANJO        � Data � 26/10/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica diferenca entra valor e saldo no contas a receber  ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function DIFER()        
//IF (IF SE1->E1_SALDO + 0.01 > SE1->E1_VALOR,STRZERO(SE1->E1_VALOR),STRZERO(SE1->E1_SALDO*100,13,2) 
If  SE1->E1_SALDO + 0.01 > SE1->E1_VALOR        
    _iValor := STRZERO(SE1->E1_E1_VALOR*100,13)
ELSE
	_iValor := STRZERO(SE1->E1_SALDO*100,13)     
endif
Return(_iValor)       