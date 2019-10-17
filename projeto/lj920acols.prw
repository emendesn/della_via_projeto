#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj920aCols� Autor �Norbert Waage Junior� Data �  04/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Ponto de entrada executado pela getdados, apos receber o fo-���
���          �co.                                                         ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada apos a alteracao do cliente ou por gatilhos. ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Lj920aCols()

Local aArea	:=	GetArea()

//Inclui a rotina DELA039a nas validacoes de linha e getdados
If !("P_DELA039a()" $ oGet:cTudoOk)
	oGet:cTudoOk 	:= "U_SMatVali() .And. P_DELA039a() .And. A100TudOk()"
	oGet:cLinhaOk	:= "U_SMatVali() .And. P_DELA039a() .And. Lj920LinOk()"
	aHeader[aScan(aHeader,{|x| AllTrim(x[2]) == "D2_TPOPER"})][6] := "P_DELA039(.T.)"
EndIf

P_DELA039a()

RestArea(aArea)

Return Nil
