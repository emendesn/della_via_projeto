#include "Dellavia.ch"

User Function DVLOJA02
	Private cTabela   := "ZX3"
	Private cCadastro := ""

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))

	AxCadastro(cTabela,cCadastro)	
Return nil