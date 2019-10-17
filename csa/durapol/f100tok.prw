#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA100TOK ºAutor  ³ Jader              º Data ³  04/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no movimento a pagar e a receber          º±±
±±º          ³ Utilizado para nao permitir movimentar o caixa sem saldo   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
