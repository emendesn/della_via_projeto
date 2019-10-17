#Include 'rwmake.ch'

User Function MT100LOK()
Local nPosTes	:= 0
Local nPosCFO	:= 0
Local lRet		:= .T.                       
Local _c
Private	_cMsg	:= ""
If FunName() == "LOJA920"

	/////////////////////////////////////////////////////
	// Validação do CFOP - Marcio Domingos - 11/07/06  //
	/////////////////////////////////////////////////////
	
	If Len(aCols) > 0       // No recebimento de titulos o array aColsDel vem vazio
	
		nPosTES := Ascan(aHeader,{ |x| Alltrim(x[2])=="D2_TES"})
		nPosCFO := Ascan(aHeader,{ |x| Alltrim(x[2])=="D2_CF"})
	
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
		
					dBselectarea("SA1")
					dBsetOrder(1)
					dBseek(xFilial("SA1")+CA920CLI+CLOJA)
					If SA1->A1_EST == SM0->M0_ESTENT
						_cDig:="5"
					Else
						_cDig:="6"
					ENDIF
		
				
					IF !Substr(aCols[_c][nPosCFO],1,1) = _cDig
						_cMsg:=_cMsg + "Digito Inicial do CFOP (Dentro ou Fora do Estado) esta Invalido !!!  "+Chr(13)+Chr(10)
						_lret:=.F.
					Endif
				
				
//					If _cDig == "6"
//						dBselectarea("SX5")
//						dBsetorder(1)
//						IF !dbseek(xFilial("SX5")+"13"+"5"+Substr(aCols[_c][nPosCFO],2,3)+Spac(2))
//							_cMsg:=_cMsg + "Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
//							_lret:=.F.
//						Endif
//					Else
						dBselectarea("SX5")
						dBsetorder(1)
						IF !dbseek(xFilial("SX5")+"13"+Substr(aCols[_c][nPosCFO],1,4)+Spac(2))
							_cMsg:=_cMsg + "Cfop Inexistente (Vide Tabela 13) !!!  "+Chr(13)+Chr(10)
							_lret:=.F.
						Endif
					
//					Endif
				
				Endif
			
			Endif
		
		Next
	
		IF !_lret
			MSGSTOP(_cMsg)    
			lRet := _lRet
		Endif
		
	Endif	             
	
Endif      

Return lRet	

