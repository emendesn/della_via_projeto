#include "rwmake.ch"
#include "topconn.ch"

User Function DVLOJA01
	Private cTabela   := "ZX1"
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
	aAdd(aRotina,{"Copiar"    ,"U_CopyZX1",0,3})

	dbselectarea(cTabela)
	MBrowse(,,,,cTabela)
Return

User Function NomeLoja(cVarPar)
	Local aArea := GetArea()
	Local cNome := ""
	Local cSql  := ""

	cSql := "SELECT LJ_NOME FROM "+RetSqlName("SLJ")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   LJ_FILIAL = '"+xFilial("SLJ")+"'
	cSql += " AND   LJ_RPCFIL = '"+cVarPar+"'
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	cNome := LJ_NOME
	dbCloseArea()
	RestArea(aArea)
Return cNome

User Function CopyZX1(cVar1,cVar2,cVar3)
	If Eof()
		Help(" ",1,"ARQVAZIO")
		Return
	Endif

	AxInclui("ZX1",Recno(),3,,"U_ZX1LeReg")
Return

User Function ZX1LeReg()
	Local bCampo := { |nCPO| Field(nCPO) }
	Local i      := 0

	dbSelectArea("ZX1")
	For i := 1 TO FCount()
		M->&(EVAL(bCampo,i)) := FieldGet(i)
	Next i
	M->ZX1_LOJA := Space(2)
	M->ZX1_MES  := Space(6)
Return nil