/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Program   � CALCST   � Autor � Marcos / Edmar        � Data �16.12.2005	���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Programa de Calc.Base Icms Subst.Trib. N.F.Pirelli         	���
���������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            	���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   	���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                         	���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
USER FUNCTION CALCSTDV()
    //
	LOCAL nValor     := 0
	LOCAL nPosCOD    := round((aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_COD") })),2)
	LOCAL nPsBRICMS  := round((aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_BRICMS") })),2)
	LOCAL nPsBaseICM := round((aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_BASEICM") })),2)
	LOCAL nPsValIPI  := round((aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_VALIPI") })),2)
	LOCAL nPosTES    := round((aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_TES") })),2)
	LOCAL nMargem    := 0          
	//
    If aCols[n][nPosTES]=="581" // Notas Fiscais de devolu��o com Substituicao
	   // Salva Areas
	   _aArea1   := GetArea()
	   //_aArqs1   := {"SC5","SC6","SF2","SD2","SE1","SF4"}
	   _aArqs1   := {"SF2","SD2","SF1","SD1","SF4"}     
	   _aAlias1  := {}
	   For _nX1  := 1 To Len(_aArqs1)
	       dbSelectArea(_aArqs1[_nX1])
	       AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
	   Next          
	   //              
	   DbSelectArea("SB1")
	   DbSetOrder(1)
	   DbSeek(xFilial("SB1")+aCols[n][nPosCOD])
	   nMargem := SB1->B1_PICMENT
       //                   
       aCols[n, nPsBRICMS] := round(( (aCols[n][nPsBaseICM]+aCols[n][nPsValIpi]) * (1 + (nMargem / 100)) ),2)
       //
       // Restaura Areas
       For _nX1 := 1 To Len(_aAlias1)
           dbSelectArea(_aAlias1[_nX1,1])
           dbSetOrder(_aAlias1[_nX1,2])
           dbGoTo(_aAlias1[_nX1,3])
       Next
       RestArea(_aArea1)
       //
    Endif
    //
Return(.T.)
