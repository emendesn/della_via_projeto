
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR33V1 ()

	Private cString        := "MAH"
	Private aOrd           := {"Periodo + Analista","Analista + Periodo"}
	Private cDesc1         := "RELATORIO CRD "
	Private cDesc2         := "              "
	Private cDesc3         := "              "
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR33V1"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL33"
	Private titulo         := "CRD"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR33"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {} 
   	AAdd(aRegs,{cPerg,"01","De.....................?"," "," ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"02","Até....................?"," "," ","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
//   	AAdd(aRegs,{cPerg,"03","Ordem 1-2..............?"," "," ","mv_ch3","C", 1,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
//   	AAdd(aRegs,{cPerg,"04","Até o Código...........?"," "," ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
// 	    AAdd(aRegs,{cPerg,"05","Cabeçalho (N)ão/(S)im..?"," "," ","mv_ch5","C", 1,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
//   	AAdd(aRegs,{cPerg,"06","Bloqueado (N)ão/(S)im..?"," "," ","mv_ch6","C", 1,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
//   	AAdd(aRegs,{cPerg,"07","Tab.Preco (C/V)........?"," "," ","mv_ch7","C", 1,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
//   	AAdd(aRegs,{cPerg,"08","Tab.Preco (VENDA)......?"," "," ","mv_ch8","C", 3,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","DA1","","","",""})
//   	AAdd(aRegs,{cPerg,"09","Tab.Preco (COMPRA).....?"," "," ","mv_ch9","C", 3,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","AIB","","","",""})
//      AAdd(aRegs,{cPerg,"10","Codigo Fornecedor......?"," "," ","mv_chA","C", 6,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
//      AAdd(aRegs,{cPerg,"11","Loja Fornecedor........?"," "," ","mv_chB","C", 2,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
//   	AAdd(aRegs,{cPerg,"12","Ordem(C)odigo(P)roduto.?"," "," ","mv_chA","C", 1,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
    
	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to len(aRegs[i])
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
    
	Processa({|| RunReport() },Titulo,,.t.)
	
Return nil


Static Function RunReport()

	Private vUsrAvl := ""
	Private vAnoMes := ""
	Private vAvl	:= 0
	Private vPer    := 0
	Private vTot    := 0   
	Private ColAten := 1
	Private ColConc := 2
	Private ColTOrc := 3
	Private ColCrAp := 4       
	Private xTot1	:= ""
    Private xTot2   := ""
    Private xTot3   := ""

    if aReturn[8] = 1
    	vPer := 1
    	vAvl := 2
    	vTot := 3
    	xTot1:= "Total Periodo"
		xTot2:= "Total Analista"
		xTot3:= "Total Geral"
    else
    	vPer := 2
    	vAvl := 1
    	vTot := 3
    	xTot2:= "Total Periodo"
		xTot1:= "Total Analista"
		xTot3:= "Total Geral"
    endif
	Cabec1 := "Periodo de:" + dtoc(mv_par01) + " ate " + dtoc(mv_par02) 
   	Cabec2 := "                                       Atendimen           Concedid            Total_Orc           Cred_Aprovado "
    //                  1         2         3         4         5         6         7         8                  10
    //         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cSql := "SELECT * FROM ("
	cSql += "SELECT MAH_CONTRA,MAH_USRAVL,SUBSTR(MAH_DATAVL,1,6) AS MAH_PERIODO,MAH_VLRFIN,"
    cSql += "       UA_DOC AS DOCNFS "   
    cSql += "FROM   MAH010 MAH, "
    cSql += "       SUA010 SUA "
    cSql += "WHERE  SUA.D_E_L_E_T_='' " 
    cSql += "AND    MAH.D_E_L_E_T_='' "
    cSql += "AND    SUA.UA_CONTRA = MAH.MAH_CONTRA "
    cSql += "AND    MAH_DATAVL BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' "  
    cSql += "AND    MAH_USRAVL   <>'' "
    cSql += "UNION " 
    cSql += "SELECT MAH_CONTRA,MAH_USRAVL,SUBSTR(MAH_DATAVL,1,6) AS MAH_PERIODO,MAH_VLRFIN, " 
    cSql += "       L1_DOC AS DOCNFS " 
    cSql += "FROM   MAH010 MAH, " 
    cSql += "       SL1010 SL1 " 
    cSql += "WHERE  SL1.D_E_L_E_T_='' "  
    cSql += "AND    MAH.D_E_L_E_T_='' "
    cSql += "AND    SL1.L1_CONTRA =MAH.MAH_CONTRA "
    cSql += "AND    MAH_DATAVL BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "' "   
    cSql += "AND    MAH_USRAVL   <>'' "
    cSql += ") AS TABMAH "
    if aReturn[8] = 1
    	cSql += "ORDER BY MAH_USRAVL,MAH_Periodo "
    else 
    	cSql += "ORDER BY MAH_Periodo,MAH_USRAVL "
    endif

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","MAH_VLRFIN","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()        
	vUsrAvl := ARQ_SQL->MAH_UsrAvl
	vAnoMes := ARQ_SQL->MAH_Periodo
	avTot 	:= {}
    aAdd(avTot,{0,0,0,0})
    aAdd(avTot,{0,0,0,0})
    aAdd(avTot,{0,0,0,0})
  
	Do While !eof() 
	
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			LI+=2
		endif

	    if aReturn[8]= 1 
	    	if vUsrAvl <> ARQ_SQL->MAH_UsrAvl    
	    		DoTotal(vPer)
	    		DoTotal(vAvl)
	    		vUsrAvl := ARQ_SQL->MAH_UsrAvl      
	    		vAnoMes := ARQ_SQL->MAH_Periodo
			endif            
	    	if vAnoMes <> ARQ_SQL->MAH_Periodo    
	    		DoTotal(vPer)  
				vAnoMes := ARQ_SQL->MAH_Periodo
	    	endif                                             
	    else
	    	if vAnoMes <> ARQ_SQL->MAH_Periodo    
	    		DoTotal(vAvl)
	    		DoTotal(vPer)  
				vAnoMes := ARQ_SQL->MAH_Periodo
				vUsrAvl := ARQ_SQL->MAH_UsrAvl
	    	endif                                             
	    	if vUsrAvl <> ARQ_SQL->MAH_UsrAVl    
	    		DoTotal(vAvl)
	    		vUsrAvl := ARQ_SQL->MAH_UsrAVl      
	    		vAnoMes := ARQ_SQL->MAH_Periodo
	    	endif                          
	    endif
	    avTot [1 , ColAten] := avTot [1 , ColAten] + 1   
	    avTot [1 , ColTOrc] := avTot [1 , ColTOrc] + ARQ_SQL->MAH_VlrFin
        if !empty(ARQ_SQL->DocNfs)
			avTot [1 , ColConc] := avTot [1 , ColConc] + 1
			avTot [1 , ColCrAp] := avTot [1 , ColCrAp] + ARQ_SQL->MAH_VlrFin
        endif
		            
		dbSelectArea("ARQ_SQL")
		dbSkip()

	enddo 
	if aReturn[8]= 1
		DoTotal(vAvl)
		DoTotal(vPer)
		DoTotal(vTot)
	else
		DoTotal(vPer)
	    DoTotal(vAvl)
	    DoTotal(vTot)
	endif
	
	dbSelectArea("ARQ_SQL")
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

Static Function DoTotal(vTipo)
	Do Case
		Case vTipo = 1
			 Dopula()
			 if aReturn[8]= 1
			 	@Li,01 psay vAnoMes
			 else
			 	@Li,01 psay vUsrAvl
			 endif
		Case vTipo = 2
			 DoPula() 
			 @Li,01 psay xTot2
			 if aReturn[8]= 1   
			 	@Li,20 psay vUsrAvl
			 else
			 	@Li,20 psay vAnoMes
			 endif
		Case vTipo = 3
		     DoPula()			 
			 @Li,01 psay xTot3
	Endcase           
	@Li,040 psay avTot [vTipo , ColAten] picture "999999"
	@Li,060 psay avTot [vTipo , ColConc] picture "999999"
	@Li,080 psay avTot [vTipo , ColTOrc] picture "@E 999,999,999.99"
	@Li,100 psay avTot [vTipo , ColCrAp] picture "@E 999,999,999.99"
	if vTipo < 3           
		for i = 1 to 4
			avTot [vTipo + 1 , i] := avTot [vTipo + 1 , i] + avTot [vTipo , i]      
			avTot [vTipo , i]     := 0
		endfor 
	endif
	
Return nil     

Static Function DoPula(vLin)        

	Li ++
	lImp:=.t.
    if Li>55 
    	LI := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
    	Li += 2
    endif 

Return nil
