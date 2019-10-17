#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DFATG01  �Autor  � Jader              � Data �  04/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para ser colocado nos campos do pedido de venda.   ���
���          � Usado para nao deixar alterar os campos quando vier        ���
���          � de uma OP ou poder de terceiro                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Durapol                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DFATG01()

Local _lRet   := .T.
Local _aAlias := GetArea()
Local _nPos := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_NUMOP"})
Local _cNumOP := aCols[n,_nPos]
Local _nPos := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEMOP"})
Local _cItemOP := aCols[n,_nPos]
Local _nPos := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_IDENTB6"})
Local _cIdentB6 := aCols[n,_nPos]

If SM0->M0_CODIGO == "03"  // Somente para empresa Durapol
	IF ! Upper(Alltrim(Substr(cUsuario,7,15))) $ "MARCELO.FODOR/MONICA.SILVA"
		If ALTERA
			If (! Empty(_cNumOP) .And. ! Empty(_cItemOP)) .Or. ! Empty(_cIdentB6)
				_lRet := .F.
			Endif
			IF UsrRetGrp()[1] == "000000" //Grupo de Administradores
				_lRet := .T.
			EndIF	
		Endif	
	EndIF	
Endif

RestArea(_aAlias)                          

Return(_lRet)
