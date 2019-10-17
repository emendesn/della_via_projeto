#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR27 ()
/*    
	INVDUKA
*/
	
	Private cString        := "SB9"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "P"
	Private nomeprog       := "DGOLR27"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL27"
	Private titulo         := "Inventario"
	Private Li             := 99
	Private Cabec1         := ""
	Private Cabec2         := ""                                        
	Private m_pag          := 01
	Private wnrel          := "INVDUKA"
	Private lImp           := .F.
 	Private Cab1           := ""
 	Private Cab2           := ""
  	Private Cab3           := ""
  	Private vSoma          := 0   
  	
  	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Da Data      "," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Data   "," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Armazém   "," "," ","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Ate o Armazém"," "," ","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
 
    
    dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		if !dbSeek(cPerg+aRegs[i,2])
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
	   Return nil
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
	   Return nil
	Endif

  	RptStatus({||Runreport()})
  
Return nil
 
Static Function RunReport()
	
    Cabec1 := "   Data   |Fili| Codigo          |Quantidade"
    LI     := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)                                       
    LI     += 2  
    
    CSQL := "Select B9_DATA, "
    CSQL += "       b9_filial, "
    CSQL += "       B9_COD,  "
    CSQL += "       sum(B9_QINI) AS B9_QINI"
    CSQL += "  from SB9010 sb9, SB1010 sb1  "
    CSQL += " where sb9.d_e_l_e_t_ = ' ' "
    CSQL += "   and sb1.d_e_l_e_t_ = ' ' "
    CSQL += "   and sb9.b9_filial  > '  ' "
    CSQL += "   and sb1.b1_filial  = '  ' "
    CSQL += "   and sb9.b9_cod     = sb1.b1_cod "
    CSQL += "   and b9_data       >= '" + DTOS(MV_PAR01) + "' "
    CSQL += "   and b9_data       <= '" + DTOS(MV_PAR02) + "' "
    CSQL += "   and B9_local      >= '" + MV_PAR03       + "' "
    CSQL += "   and b9_local      <= '" + MV_PAR04       + "' "
    CSQL += "   and b1_grtrib      = '001' "
    CSQL += " group by b9_data, b9_filial, B9_COD "
    CSQL += " order by b9_filial,b9_cod "

	MsgRun("Consultado Base de Dados Della Via",,{|| cSql := ChangeQuery(cSql)})
    MsgRun("Consultado Base de Dados Della Via",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})
	
	TcSetField("ARQ_SQL","B9_DATA","D")  
    TcSetField("ARQ_SQL","B9_QINI","N",14,2)
    
    dbSelectArea("ARQ_SQL")
    ProcRegua(0)
    vCod 	:= ""
    vSc  	:= "|"
     
	DoCabec()
                                                                 
    Do While !eof()             
   		
   		IncProc("Imprimindo ...")
	   	if lAbortPrint
			LI+=3
		   	@ LI,001 PSAY "*** Cancelado pelo Operador ***"
		   	lImp := .F.
		    return
	  	Endif
	  		
	    @Li, 001      psay Arq_Sql->B9_DATA 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B9_FILIAL 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B9_COD 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B9_QINI PICTURE "9999999"
    	Li ++		
		dbSkip()
		
	Enddo
	

 	dbCloseArea()

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()                    
Return nil

Static Function DoCabec

	Li ++
	lImp:=.t.
   if Li>55 
    	LI := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
    	Li += 2
   endif 

Return 

