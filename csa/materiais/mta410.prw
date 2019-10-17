#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410    º Autor ³ Geraldo Sabino     º Data ³  25/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica a Validade do Pedido de Venda (EM RELACAO AO CFOP)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Della Via                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA410()  
nPosTES := Ascan(aHeader,{ |x| Alltrim(x[2])=="C6_TES"})
nPosCFO := Ascan(aHeader,{ |x| Alltrim(x[2])=="C6_CF"})

_cMsg:=""
_lret:=.T.
For _c:=1 to Len(aCols)
	If !aCols[_c,Len(aHeader)+1]
		dBselectarea("SF4")
		dBsetorder(1)
		IF dBseek(xFilial("SF4")+aCols[_c][nPosTES])
			
			If aCols[_c][nPosCFO] # "6108"  // Venda para cliente não contribuinte fora do estado
				IF !Substr(aCols[_c][nPosCFO],2,3) = Substr(SF4->F4_CF,2,3)
					_cMsg:=_cMsg + "CFOP Divergente do Pedido de Venda com o TES "+Chr(13)+Chr(10)
					_lret:=.F.
				Endif
			Endif	
			
			_cDig:=" "
			If M->C5_TIPO $ "D/B"
				dBselectarea("SA2")
				dBsetOrder(1)
				dBseek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJAENT)
				If SA2->A2_EST == SM0->M0_ESTENT
					_cDig:="5"
				Else
					_cDig:="6"
				ENDIF
			Else
				dBselectarea("SA1")
				dBsetOrder(1)
				dBseek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT)
				If SA1->A1_EST == SM0->M0_ESTENT
					_cDig:="5"
				Else
					_cDig:="6"
				ENDIF
			Endif
			
			
			IF !Substr(aCols[_c][nPosCFO],1,1) = _cDig
				_cMsg:=_cMsg + "Digito Inicial do CFOP (Dentro ou Fora do Estado) esta Invalido !!!  "+Chr(13)+Chr(10)
				_lret:=.F.
			Endif
			
			
//			If _cDig == "6"
//				dBselectarea("SX5")
//				dBsetorder(1)
//				IF !dbseek(xFilial("SX5")+"13"+"5"+Substr(aCols[_c][nPosCFO],2,3)+Spac(2))
//					_cMsg:=_cMsg + "Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
//					_lret:=.F.
//				Endif
//			Else
				dBselectarea("SX5")
				dBsetorder(1)
				IF !dbseek(xFilial("SX5")+"13"+Substr(aCols[_c][nPosCFO],1,4)+Spac(2))
					_cMsg:=_cMsg + "Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
					_lret:=.F.
				Endif
				
//			Endif
			
		Endif
		
	Endif
	
Next


IF !_lret
	MSGSTOP(_cMsg)
Endif

Return _lRet
