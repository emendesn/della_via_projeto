User Function VLDIP(cIP,cIni,cFim)
Return (NumIP(cIP) >= NumIP(cIni) .AND. NumIP(cIP) <= NumIP(cFim))

Static Function NumIP(cIP)
	Local cRet := ""
	Local cTmp := ""
	Local k    := 0

	cIP := AllTrim(cIP)

	For k=1 to Len(cIP)
		If Substr(cIP,k,1) = "."
			cRet += StrZero(Val(cTmp),3)
			cTmp := ""
		Else
			cTmp += Substr(cIP,k,1)
		Endif
	Next k
	cRet += StrZero(Val(cTmp),3)
Return cRet