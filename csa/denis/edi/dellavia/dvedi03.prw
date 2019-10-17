#include "Dellavia.ch"

User Function DVEDI03
	Private cTabela   := "ZX8"
	Private cCadastro := ""

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))

	AxCadastro(cTabela,cCadastro)	
Return nil