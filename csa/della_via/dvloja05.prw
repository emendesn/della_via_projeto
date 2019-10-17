#include "Dellavia.ch"

User Function DVLOJA05
	Private cTabela   := "ZX6"
	Private cCadastro := ""

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))

	AxCadastro(cTabela,cCadastro)	
Return nil