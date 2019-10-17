
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR21 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR21   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	
	Private cString        := "SB9"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "G"
	Private nomeprog       := "DGOLR21"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL21"
	Private titulo         := "Analise Fechamento 2 Periodos"
	Private Li             := 99
	Private Cabec1         := ""
	Private Cabec2         := ""                                        
	Private m_pag          := 01
	Private wnrel          := "DGOLR21"
	Private lImp           := .F.
 	Private Cab1           := ""
 	Private Cab2           := ""
  	Private Cab3           := ""
  	Private vSoma          := 0   

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Periodo 1........?"," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
 	aAdd(aRegs,{cPerg,"02","Periodo 2........?"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
   aAdd(aRegs,{cPerg,"03","Local-Armazém..de?"," "," ","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"04","Local-Armazém.até?"," "," ","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   aAdd(aRegs,{cPerg,"05","Tipo Relat....A/S?"," "," ","mv_ch5","C",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
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
	
    Cabec1 := "Filial          | "
    Cabec1 += xFilial("SB9")
    Cabec1 += " |          Periodo:        "
    Cabec1 += dtoc(mv_par01)
    Cabec1 += " |          Periodo:        "
    Cabec1 +dtoc(mv_par02)
    Cabec2 := "Codigo          |Loc.|       Quantidade|            Valor|       Quantidade|           Valor" 
    LI     := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)                                       
    LI     += 2    
    CSQL := "SELECT SB1.B1_COD, "
    CSQL += "       SB1.B1_LOCPAD, "
    CSQL += "       SB9P1.B9_QINI  AS QINI1, "
    CSQL += "       SB9P1.B9_VINI1 AS VINI1, "
    CSQL += "       SB9P2.B9_QINI  AS QINI2, "
    CSQL += "       SB9P2.B9_VINI1 AS VINI2 "
    CSQL += "  FROM SB1010 SB1 " 
    CSQL += "  LEFT JOIN SB9010 SB9P1 "
    CSQL += "    ON SB9P1.D_E_L_E_T_  = ' ' " 
    cSqL += "   AND sb9P1.B9_FILIAL   = '"   + xFilial("SB9") + "' "
    CSQL += "   AND SB9P1.B9_COD      = SB1.B1_COD " 
    cSql += "   and SB9P1.B9_LOCAL   >= '"   + mv_par03       + "' "
    cSql += "   and SB9P1.B9_LOCAL   <= '"   + mv_par04       + "' " 
    CSQL += "   AND SB9P1.B9_DATA     = '"   + DTOS(mv_par01) + "' "
    CSQL += "  LEFT JOIN SB9010 SB9P2"
    CSQL += "    ON SB9P2.D_E_L_E_T_  = ' ' "
    cSqL += "   and sb9P2.B9_FILIAL   = '"   + xFilial("SB9") + "' "
    CSQL += "   AND SB9P2.B9_COD      = SB1.B1_COD " 
    cSql += "   and SB9P2.B9_LOCAL   >= '"   + mv_par03       + "' "
    cSql += "   and SB9P2.B9_LOCAL   <= '"   + mv_par04       + "' " 
    CSQL += "   AND SB9P2.B9_DATA     = '"   + DTOS(mv_par02) + "' "
    CSQL += " WHERE SB1.D_E_L_E_T_  = ' '" 
    CSQL += "   AND SB1.B1_TIPO     = 'ME' " 
    CSQL += " ORDER BY SB1.B1_COD "            
    
    MsgRun("Consultado Base de Dados Della Via",,{|| cSql := ChangeQuery(cSql)})
    MsgRun("Consultado Base de Dados Della Via",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})
   
    TcSetField("ARQ_SQL","QINI1","N",14,2)
    TcSetField("ARQ_SQL","VINI1","N",14,2)
    TcSetField("ARQ_SQL","QINI2","N",14,2)
    TcSetField("ARQ_SQL","VINI2","N",14,2)             
   
    dbSelectArea("ARQ_SQL")
    ProcRegua(0)
    vCod 	:= ""
    vSc  	:= "|"
     
    avTot 	:= {}
    aAdd(avTot,{0,0,0,0})
    aAdd(avTot,{0,0,0,0})
    
    Do While !eof()             
   		IncProc("Imprimindo ...")
	   	if lAbortPrint
			LI+=3
		   	@ LI,001 PSAY "*** Cancelado pelo Operador ***"
		   	lImp := .F.
		    return
	  	Endif
	  		
		if Arq_Sql->QINI1 == 0 .and. ;
			Arq_Sql->VINI1 == 0 .and. ;
			Arq_Sql->QINI2 == 0 .and. ;
			Arq_Sql->VINI2 == 0 
		   dbSkip()
		   loop
		endif
		
		if mv_par05 == "A"
			DoCabec()
	    	@Li, 000      psay Arq_Sql->B1_Cod
	    	@Li, pcol()+1 psay vSc 
	    	@Li, pcol()+1 psay Arq_Sql->B1_LocPad
	    	@Li, pcol()+1 psay vSc 
	    	@Li, pcol()+1 psay Arq_Sql->QINI1 picture "@E 99,999,999.9999"
			@Li, pcol()+1 psay vSc
			@Li, pcol()+1 psay Arq_Sql->VINI1 picture "@E 9,99,999,999.99"
			@Li, pcol()+1 psay vSc
			@Li, pcol()+1 psay Arq_Sql->QINI2 picture "@E 99,999,999.9999"
			@Li, pcol()+1 psay vSc
			@Li, pcol()+1 psay Arq_Sql->VINI2 picture "@E 9,99,999,999.99"                                   
		endif
		avTot[1 , 1] := avTot[1 , 1] + Arq_Sql->QINI1
		avTot[1 , 2] := avTot[1 , 2] + Arq_Sql->VINI1
		avTot[1 , 3] := avTot[1 , 3] + Arq_Sql->QINI2
		avTot[1 , 4] := avTot[1 , 4] + Arq_Sql->VINI2		
			
		dbSkip()
		
	Enddo
	
	DoCabec()
	@Li, 000      psay ""
	DoCabec()
	@Li, 000      psay "Total    Filial"
	@Li, pcol()+1 psay vSc 
	@Li, pcol()+1 psay xFilial("SB9")
	@Li, pcol()+1 psay vSc 
	@Li, pcol()+1 psay avTot[1 , 1] picture "@E 99,999,999.9999"
	@Li, pcol()+1 psay vSc
	@Li, pcol()+1 psay avTot[1 , 2] picture "@E 9,99,999,999.99"
	@Li, pcol()+1 psay vSc
	@Li, pcol()+1 psay avTot[1 , 3] picture "@E 99,999,999.9999"
	@Li, pcol()+1 psay vSc
	@Li, pcol()+1 psay avTot[1 , 4] picture "@E 9,99,999,999.99"                                   
	 	
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

