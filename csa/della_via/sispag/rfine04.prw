#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFINE04  �Autor  � Marciane Gennari   � Data �  29/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para determinar o fator de vencimento e o valor do���
���          �  titulo retirando a informacao do codigo de Barras.        ���
�������������������������������������������������������������������������͹��
���Uso       � Sispag Itau                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function rfine04()

SetPrvt("CCAMPO,")

If     Len(Alltrim(SE2->E2_CODBAR)) < 44
          cCampo := "00000000000000" //Substr(SE2->E2_CODBAR,34,5)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47        
	      cCampo := Substr(SE2->E2_CODBAR,34,14)
Else
	      cCampo := Substr(SE2->E2_CODBAR,6,14)
	//������������������������������������������������������������������������Ŀ
	//� Inclui o fator de vencimento conforme Carta-circular 002926 do Banco   �
	//� Central do Brasil, de 24/07/2000. A partir de 02/04/2001, o Banco      �
	//� acolhedor/recebedor nao sera mais responsavel  por eventuais diferen�as� 
	//� de recebimento de bloquetos fora do prazo, ou sem a indica�ao do fator �
	//� de vencimento. Forma para obten��o do Fator de Vencimento:             �
	//� Calcula-se o n�mero de dias corridos entre a data base                 �
	//� ("Fixada" em 07.10.1997) e a do Vencimento do titulo                   �
	//��������������������������������������������������������������������������
//Campo := StrZero(SE2->E2_VENCREA-Ctod("07/10/97", "dd/mm/yy"),4)+;
//		 Right(cCampo,10)
EndIf	

cCampo := Strzero(Val(cCampo),14)

Return(cCampo)