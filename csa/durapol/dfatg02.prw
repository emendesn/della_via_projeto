/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DFATG02  ºAutor  ³ Reinaldo           º Data ³  04/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para preenchimento do valor de desconto ou OVNI.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFATG02(cCampo)

Local _nRet   := 0
Local _aAlias := GetArea()
Local _nPos   := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ACP_CODPRO"})
Local cProd   := aCols[n,_nPos]
Local _nPos   := AScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ACP_PRCVEN"})
Local _nPreco := aCols[n,_nPos]
Local _nPrTab := 0

If SM0->M0_CODIGO == "03"  // Somente para empresa Durapol

	DA1->( dbSetOrder(2) )
	DA1->( dbSeek(xFilial("DA1") + cProd) )
	
	_nPrTab := DA1->DA1_PRCVEN
	
	//Se _nRet  < 0 = Desconto, Acrescimo
	_nRet := ((_nPreco/_nPrTab)-1)*100
	
	IF Alltrim(cCampo) == "ACP_PERDES" .and. _nRet < 0
		_nRet := _nRet * (-1)
	ElseIF Alltrim(cCampo) == "ACP_PERACR" .and. _nRet > 0
		_nRet := _nRet
	Else	
		_nRet := 0
	EndIF	
Endif

RestArea(_aAlias)                          

Return(_nRet)
