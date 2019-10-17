#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA100TOK �Autor  � Jader              � Data �  04/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no movimento a pagar e a receber          ���
���          � Utilizado para nao permitir movimentar o caixa sem saldo   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Durapol                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F100TOK()

Local _lRet    := .T.
Local _aAlias  := GetArea()
Local _nSaldo  := 0
Local _lPagar  := .F.
Local _nX      := 0
Local _cRotina := ""

While .T.

	_cRotina := ProcName(_nX)

	If Empty(_cRotina)
		Exit
	Endif	
	
	If AllTrim(Upper(_cRotina)) == "FA100PAG"
		_lPagar := .T.
		Exit
	Endif
	
    _nX ++
    
Enddo		

// Executa somente para Durapol
If SM0->M0_CODIGO == "03"
	
	If _lPagar
		
		If Substr(M->E5_BANCO,1,1) == "C" // baixa caixa "C01", "CX1", etc
			
			_nSaldo := RecSalBco(M->E5_BANCO,M->E5_AGENCIA,M->E5_CONTA,dDataBase)
			
			If ( _nSaldo - M->E5_VALOR ) < 0
				MsgStop("Nao ha saldo suficiente para realizacao desta transacao. Saldo disponivel "+Alltrim(Transform(_nSaldo,"@E 999,999,999.99"))+". Verifique.","Atencao")
				_lRet := .F.
			Endif
			
		Endif
		
	Endif
	
Endif

RestArea(_aAlias)

Return(_lRet)
