#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFINE03    �Autor  � Marciane Gennari � Data �  29/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para determinar o digito verificador no Cod de    ���
���          � Barras no SE2                                              ���
�������������������������������������������������������������������������͹��
���Uso       � SISPAG ITAU                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Rfine03()

SetPrvt("CCAMPO,")

If     Len(Alltrim(SE2->E2_CODBAR)) < 44         // Antiga Codificacao (Numerica)
	      cCampo := Substr(SE2->E2_CODBAR,33,1)

ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47        // Nova Codificacao (Numerica)
	      cCampo := Substr(SE2->E2_CODBAR,33,1)
Else
	      cCampo := Substr(SE2->E2_CODBAR,5,1)   // Codificacao Cod. Barras
EndIf	

Return(cCampo)