#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR26 ()
   
//	PRODUKA
	
	Private cString        := "SB1"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "G"
	Private nomeprog       := "DGOLR26"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL26"
	Private titulo         := "Produtos"
	Private Li             := 99
	Private Cabec1         := ""
	Private Cabec2         := ""                                        
	Private m_pag          := 01
	Private wnrel          := "DGOLR26"
	Private lImp           := .F.
 	Private Cab1           := ""
 	Private Cab2           := ""
  	Private Cab3           := ""
  	Private vSoma          := 0   

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Da Data   "," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
 	aAdd(aRegs,{cPerg,"02","Ate a Data"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
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
	
    Cabec1 := "Codigo          |Descricao                       |IPI    |ICM    |ICM RET|MARKUP"
    LI     := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)                                       
    LI     += 2  
    
    CSQL :=	"SELECT	B1_COD, " 
    CSQL += "       B1_DESC, "
    CSQL += "       B1_IPI, "
    CSQL += "       B1_PICM, "
    CSQL += "       B1_PICMRET, "
    CSQL += "       B1_MARKUP "
	CSQL += "  from SB1010 "
	CSQL += " where D_E_L_E_T_ = ' ' "
	CSQL += "   and B1_GRTRIB     = '001' "
	CSQL += "   and B1_MARKUP     > 0 "
	CSQL += " order by B1_COD "
	
	MsgRun("Consultado Base de Dados Della Via",,{|| cSql := ChangeQuery(cSql)})
    MsgRun("Consultado Base de Dados Della Via",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})
 
	TcSetField("ARQ_SQL","B1_IPI"    ,"N",14,2)  
    TcSetField("ARQ_SQL","B1_PICM"   ,"N",14,2)
    TcSetField("ARQ_SQL","B1_PICMRET","N",14,2)
    TcSetField("ARQ_SQL","B1_MARKUP" ,"N",14,2)
   
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
	  		
	    @Li, 000      psay Arq_Sql->B1_COD 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B1_DESC 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B1_IPI      PICTURE "99.99"
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B1_PICM     PICTURE "99.99"
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B1_PICMRET  PICTURE "99.99"
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->B1_MARKUP   PICTURE "99.99"
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

