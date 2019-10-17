#include "Rwmake.ch"

User Function DSEPUA01
	Local cTabela := "ZZ1"

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)

	axCadastro(cTabela,Capital(SX2->X2_NOME))
Return nil