#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFINE05  �Autor  � Marciane Gennari   � Data �  29/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para retornar o campo livre do codigo de barras  ���
�������������������������������������������������������������������������͹��
���Uso       � Sispag Itau.                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function rfine05()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCAMPO,")

If Len(Alltrim(SE2->E2_CODBAR)) < 44
	cCampo := 	Substr(SE2->E2_CODBAR,5,5)+Substr(SE2->E2_CODBAR,11,10)+;
					Substr(SE2->E2_CODBAR,22,10)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47
	cCampo := Substr(SE2->E2_CODBAR,05,05)+ Substr(SE2->E2_CODBAR,11,10)+ Substr(SE2->E2_CODBAR,22,10)
Else
	cCampo := Substr(SE2->E2_CODBAR,20,25)
EndIf	


Return(cCampo)