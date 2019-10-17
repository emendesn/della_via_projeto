#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DCOMV02   �Autor  �Microsiga           � Data �  01/02/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao para preenchimento do campo de servico na NFE e na���
���          �rotina de alteracao                                         ���
�������������������������������������������������������������������������͹��
���Uso       � DURAPOL                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DCOMV02

Local _aArea      := GetArea()
Local lRet := .T.
Local _nPosServ   := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_SERVICO"})
Local _nPosCod    := aScan(aHeader,{|x| Upper(alltrim(x[2])) == "D1_COD"})

IF FunName() == "U_DCOMA01"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+M->D1_SERVICO)
		
	IF aCols[n][_nPosCod] != SB1->B1_PRODUTO
		MsgInfo("A carcaca que tem amarracao com este servico e diferente da cadastrada originalmente!","Atencao!!")
		lRet := .F.
	EndIF
EndIF

Return(lRet)