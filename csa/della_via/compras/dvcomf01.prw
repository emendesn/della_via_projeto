#Include "Dellavia.ch"

User Function DVCOMF01()
	Local aArea := GetArea()
	Local lRet  := .T.

	IF AIA->AIA_DATATE <> ctod("//") .AND. AIA->AIA_DATATE < dDataBase
		lRet := .F.
		Help(" ",1,"Tabela",,"Tabela de preço fora do periodo.",4,1)
	Endif

	RestArea(aArea)
Return lRet