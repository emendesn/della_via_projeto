#include "rwmake.ch"

User Function TXTVIRG
	Local cFile  := "\DENIS\REDECARD.TXT"
	Local cBase  := "\DENIS\TESTE_TXT"

	dbUseArea(.T.,,cBase,"BUFFER",.F.,.F.)
	dbSelectArea("BUFFER")
	For k=1 to 10
		Append From &cFile Delimited with ,
	Next
	dbCloseArea()

	msgbox("Programa de teste executado com sucesso!!!","RedeCard","INFO")
Return nil