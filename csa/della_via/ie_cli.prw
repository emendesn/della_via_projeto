#include "rwmake.ch"
                       
// funcao para validacao do IE do cliente
// colocada no X3_VALID do campo A1_INSCR
// pois no msexecauto estava dando erro na funcao IE() pois o E1_EST estava em branco
User Function IE_Cli()

Local _lRet := .F.
Local _nX
         
If ! ( Type("l030Auto") == "U" .or. !l030Auto )
	For _nX := 1 To Len(aAuto)
		If Alltrim(Upper(aAuto[_nX,1])) == "A1_EST"
			&(aAuto[_nX,1]) := aAuto[_nX,2]
		Endif	
		If Alltrim(Upper(aAuto[_nX,1])) == "A1_INSCR"
			&(aAuto[_nX,1]) := aAuto[_nX,2]
		Endif	
	Next  
Endif	

_lRet := IE(M->A1_INSCR,M->A1_EST)

Return(_lRet)