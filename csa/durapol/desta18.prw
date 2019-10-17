#include "Dellavia.ch"

User Function DESTA18
	Private cTabela   := "ZZ7"
	Private cCadastro := ""

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))

	AxCadastro(cTabela,cCadastro)	
Return nil