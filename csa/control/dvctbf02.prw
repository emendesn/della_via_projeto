#include "Dellavia.ch"

/*
DVCTBF02 - Valida conta contabil ativa, e se mostra para a loja ou não
28/03/2007 - Denis Francisco Tofoli
*/

User Function DVCTBF02()
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

	lRet := (CT1->CT1_DVBLQ <> "2" .AND. ("@@" $ cFil_Filial .OR. "01" $ cFil_Filial .OR. CT1->CT1_LJVISU = "S"))

	RestArea(aArea)
Return lRet