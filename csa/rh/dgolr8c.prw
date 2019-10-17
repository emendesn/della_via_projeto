#include "rwmake.ch"
#include "topconn.ch"

User Function DGOLR8A () 
	Private cString        := "SC7"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR8A"
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOLR8"
	Private wnrel          := "DGOLR8"
	
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","Tabela (C)oleta (F)icha OP (N)ota Fiscal ?"," "," ","mv_ch1","C",01,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    
 	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.F.) 
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
	   Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif







	Private cCadastro := "Pesquisa Coleta"
	Private aRotina   := {	{ "Pesquisar"   ,"AxPesqui" 			,0,1},;
	                        { "Visualizar"  ,"U_DGOLR08()"	        ,0,2}}
    mBrowse(,,,,"SF1",,,,,,)

Return nil
 
