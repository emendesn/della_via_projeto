#include "rwmake.ch"
#include "topconn.ch"

User Function DPGOLR02
	Private cTabela   := "SB1"
	Private cCadastro := ""
	Private aRotina   := {}

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))
	
	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxDeleta",0,5})

	dbselectarea(cTabela)
	MBrowse(,,,,cTabela)
Return
