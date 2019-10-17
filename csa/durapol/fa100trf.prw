#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA100TRF ºAutor  ³ Jader              º Data ³  04/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na transferencia bancaria                 º±±
±±º          ³ Utilizado para nao permitir movimentar o caixa sem saldo   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA100TRF()

Local _lRet     := .T.
Local _aAlias   := GetArea()
Local _nSaldo   := 0
Local _lTransf  := .F.
Local _nX       := 0
Local _cRotina  := ""  
Local _cBcoOrig := ParamIxb[1]
Local _cAgeOrig := ParamIxb[2]
Local _cCtaOrig := ParamIxb[3]
Local _cTipoTran:= ParamIxb[7] 
Local _nValor   := ParamIxb[9]

If Alltrim(_cTipoTran) $ "R$,TB"
	_lTransf := .T.
Endif	

// Executa somente para Durapol
If SM0->M0_CODIGO == "03"
	
	If _lTransf
		
		If Substr(_cBcoOrig,1,1) == "C" // baixa caixa "C01", "CX1", etc
			
			_nSaldo := RecSalBco(_cBcoOrig,_cAgeOrig,_cCtaOrig,dDataBase)
			
			If ( _nSaldo - _nValor ) < 0
				MsgStop("Nao ha saldo suficiente para realizacao desta transacao. Saldo disponivel "+Alltrim(Transform(_nSaldo,"@E 999,999,999.99"))+". Verifique.","Atencao")
				_lRet := .F.
			Endif
			
		Endif
		
	Endif
	
Endif

RestArea(_aAlias)

Return(_lRet)
