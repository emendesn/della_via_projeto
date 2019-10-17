#include "Dellavia.ch"

User Function AXCAD_ZX5
	Private cTabela   := "ZX5"
	Private cCadastro := ""

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))

	AxCadastro(cTabela,cCadastro)	
Return nil