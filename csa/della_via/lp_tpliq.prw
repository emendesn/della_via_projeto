#Include "Dellavia.ch"

User Function LP_TPLIQ(cParTipo)
	Local cRet := ""
	
	Do Case
		Case cParTipo = "CH "      // Cheque
			cRet := "11203001001"
		Case cParTipo = "CHD"      // Cheque Devolvido
			cRet := "11203001002"
		Case cParTipo = "FI "      // Financeira
			cRet := "11204001001"
		Case cParTipo $ "CC / CD " // Cartão
			cRet := "11202001001"
		Case cParTipo $ "DP / NF " // Duplicata
			cRet := "11201001001"
	EndCase
	
Return cRet