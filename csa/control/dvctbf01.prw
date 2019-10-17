#include "Dellavia.ch"

/*
DVCTBF01 - Valida centro de custos ativo, e dentro da filial do usuário
26/03/2007 - Denis Francisco Tofoli
*/

User Function DVCTBF01()
	Local aArea       := GetArea()
	Local lRet        := .F.
	Local cFil_Filial := ""
	Local aUser       := {}

	// Busca Empresas pelo ID do usuário
	// __cUserId é uma variável pública do Protheus com o ID do usuário
	PswOrder(1)
	if PswSeek(__cUserId,.T.)
		aUser := PswRet()
		For k=1 to Len(aUser[2,6])
			cFil_Filial += Substr(aUser[2,6,k],3,2)+"*"
		Next k
	Endif

	lRet := (CTT->CTT_DVBLQ <> "2" .AND. ("@@" $ cFil_Filial .OR. "01" $ cFil_Filial .OR. CTT->CTT_FILORI $ cFil_Filial))

	RestArea(aArea)
Return lRet