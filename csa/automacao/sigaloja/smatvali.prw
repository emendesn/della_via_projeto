User Function SMatVali()

Local nPosTPOper	:= AScan(aHeader,{|x| AllTrim(x[2]) == "D2_TPOPER" })
Local nPosTES		:= AScan(aHeader,{|x| AllTrim(x[2]) == "D2_TES" })
Local lRet			:= .T.

If Empty(Acols[N][nPosTPOper])
	ApMsgInfo("O Tipo de Operacao vazio verifique")
	lRet:= .F.
EndIf

If Acols[N][nPosTES] $ GetMV("MV_TESVNDF")
	If AllTrim(Upper(CA920CLI)) == "15LQFY"
		ApMsgInfo("O TES " + Acols[N][nPosTES] + " e um TES de Venda e nao pode ser usado entre filiais na saida de materias")
		lRet:= .F.
	EndIf	
EndIf	

Return lRet
