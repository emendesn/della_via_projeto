#include "rwmake.ch"
#include "topconn.ch"

User Function DGOLA01 () 
	 Private nomeprog       := "DGOLA01"
	 Private cPerg          := "DGOLA1A"
	
	 cPerg    := PADR(cPerg,6)
	 aRegs    := {}  

     aAdd(aRegs,{cPerg,"01","Setor Inspeção (I)nicial (F)inal ?"," "," ","mv_ch1","C",01,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    
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
	 Pergunte(cPerg,.T.) 

     Do Case
    	case upper(mv_par01) = "C"
    			vTabela := "SF1"
    	case upper(mv_par01) = "F"
    			vTabela := "SC2"
    	otherwise
    			return nil
    Endcase


	Private cCadastro := "Hiper Pesquisa Durapol"
	Private aRotina   := {	{ "Pesquisar"   ,"AxPesqui" 		        	,0,1},;
	                        { "Visualizar"  ,"U_DGOLR08(vTabela)"	        ,0,2}}
    mBrowse(,,,,vTabela,,,,,,)

Return nil
 
