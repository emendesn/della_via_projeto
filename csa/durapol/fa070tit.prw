#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA070TIT �Autor  � Jader              � Data �  04/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na baixa confirmacao da baixa a receber   ���
���          � Usado para bloquear baixa com data de baixa ou data de     ���
���          � de credito diferente da database                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Durapol                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA070TIT()

Local _lRet := .T.
                         
// Executa somente para Durapol
If SM0->M0_CODIGO == "03"

	If Substr(cBanco,1,1) == "C" // baixa caixa "C01", "CX1", etc
		If dBaixa <> dDataBase
			MsgStop("Data da baixa nao pode ser diferente da data do dia. A baixa nao foi realizada!!! Verifique.","Atencao")
			_lRet := .F.
		Endif
		If dDtCredito <> dDataBase
			MsgStop("Data de credito nao pode ser diferente da data do dia. A baixa nao foi realizada!!! Verifique.","Atencao")
			_lRet := .F.
		Endif
	Endif

Endif

Return(_lRet)
