#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DESTV01   �Autor  �Microsiga           � Data �  12/14/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DESTV01

Local _aArea := GetArea()
Local lRet   := .T.
Local cOP    := M->D3_OP
Local cProd  := M->D3_X_PROD

SD3->( dbSetOrder (12) )
IF SD3->( dbSeek(xFilial("SD3") +cOP+ cProd ) )
	While !Eof() .and.  xFilial("SD3")  + cOP + cProd == xFilial("SD3")  + SD3->D3_OP + SD3->D3_X_PROD .and. lRet
		IF SD3->D3_ESTORNO <> 'S'
			lRet := .F.
			Aviso("Atencao","Este produto j� foi apontado nesta Ordem de produ��o !!!",{"OK"})
		EndIF
		SD3->(dbSkip() )
	EndDo	
EndIF  
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek("  "+M->D3_X_PROD)
If Found() 
	If SB1->B1_GRUPO = "BAND"
		If AllTrim(SB1->B1_XDESENH) <> Alltrim(SC2->C2_X_DESEN)
			Aviso("Des OP:" + AllTrim(SC2->C2_X_DESEN) + "Dif Lan�:" + AllTrim(SB1->B1_XDESENH) , "BANDA",{"OK"})
			lret := .f.
		EndIf
	Endif
Else
	Aviso("Produto N�o Cadastrado","Material",{"OK"})
	lret := .f.
Endif

RestArea(_aArea)
Return(lRet)
