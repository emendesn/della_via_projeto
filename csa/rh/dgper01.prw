
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGPER01 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDGEPR01   บAutor  ณ by Golo            บ Data ณ  06/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Super Relatorio                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Della Via                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

	Private cString        := "SRA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Relatorio de Funcionarios"
	Private tamanho        := "G"
	Private nomeprog       := "DGPER01"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGPER1"
	Private titulo         := "Relatorio de Funcionarios"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGPER01"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	AAdd(aRegs,{cPerg,"01","Da Filial            ?"," "," ","mv_ch1","C", 2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AAdd(aRegs,{cPerg,"02","Ate a Filial         ?"," "," ","mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AAdd(aRegs,{cPerg,"03","Da Matricula         ?"," "," ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
    AAdd(aRegs,{cPerg,"04","Ate Matricaula       ?"," "," ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
 	AAdd(aRegs,{cPerg,"05","Cabe็alho (S)im/(N)ao?"," "," ","mv_ch5","C", 1,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
 	AAdd(aRegs,{cPerg,"06","Admitido de          ?"," "," ","mv_ch6","D", 8,0,0,"G","","mv_par06",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
    AAdd(aRegs,{cPerg,"07","Admitido At้         ?"," "," ","mv_ch7","D", 8,0,0,"G","","mv_par07",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AAdd(aRegs,{cPerg,"08","Demitido de          ?"," "," ","mv_ch8","D", 8,0,0,"G","","mv_par08",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
    AAdd(aRegs,{cPerg,"09","Demitido At้         ?"," "," ","mv_ch9","D", 8,0,0,"G","","mv_par09",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AAdd(aRegs,{cPerg,"10","Ordem                ?"," "," ","mv_chA","N",20,0,0,"C","","mv_par10","Filial+Matric","","","","","Filial+Nome   ","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    
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
	Cabec1:=" Filial de " + mv_par01 + " a " + mv_par02

/*            1         2         3         4         5         6         7         8           9        10    117            132                 
              12345678901234567890123456789012345678901234567890123456789012345678901234567890182234567890123456789012345678901234567890 
*/
	Cabec2:=" FL| "
/*                                                                                                           
         1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890
02=Codigo=======[x]@!===========================================ZX0_COD===015
*/
	cSql := ""
	cSql += "select RA_FILIAL"
	for  i = 9 to len(aReturn)
	    if upper(substr(aReturn[i],18,1)) = "X" .and. upper(alltrim(substr(aReturn[i],65,10))) <> "RA_FILIAL"
	       Cabec2 += substr(aReturn[i],4,13) + "|"
	       if upper(alltrim(substr(aReturn[i],65,10))) = "RA_CODFUNC"
	       		Cabec2 += "FUNCAO"+SPACE(24)+"|"
	       endif
	       if upper(alltrim(substr(aReturn[i],65,10))) = "RA_CC     "
	       		Cabec2 += "CC    "+SPACE(40)+"|"
	       endif
	       cSql   += " ,"+alltrim(substr(aReturn[i],65,10))
	    endif
    next
    cSql += "  from " + RetSqlName("SRA")+ " SRA "
    cSql += " where SRA.D_E_L_E_T_ = ' ' "
    cSql += "   and RA_FILIAL >= '" + mv_par01 + "' "
    cSql += "   and RA_FILIAL <= '" + mv_par02 + "' "
    cSql += "   and RA_MAT    >= '" + mv_par03 + "' " 
    cSql += "   and RA_MAT    <= '" + mv_par04 + "' "    
    if !empty(mv_par07)
    	cSql += " and RA_ADMISSA >= '" + dtos(mv_par06) + "' "
    	cSql += " and RA_ADMISSA <= '" + dtos(mv_par07) + "' " 
    endif                                                   
    if !empty(mv_par09)
		cSql += " and RA_DEMISSA >= '" + dtos(mv_par08) + "' "
    	cSql += " and RA_DEMISSA <= '" + dtos(mv_par09) + "' "
    else
    	cSql += "   and RA_DEMISSA = '' "
    endif
    if mv_par10 = 1	
    	cSql += " order by RA_FILIAL, RA_MAT "
    else
      	if mv_par10 =2 
      		cSql += " order by RA_FILIAL, RA_NOME, RA_MAT "
      	endif
    endif
    
	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","RA_NASC"   ,"D")
	TcSetField("ARQ_SQL","RA_ADMISSA","D")
	TcSetField("ARQ_SQL","RA_OPCAO"  ,"D")
	TcSetField("ARQ_SQL","RA_DEMISSA","D")
	TcSetField("ARQ_SQL","RA_OPCAO"  ,"D")
	TcSetField("ARQ_SQL","RA_VCTOEXP","D")
	TcSetField("ARQ_SQL","RA_VCTEXP2","D")
	TcSetField("ARQ_SQL","RA_EXAMEDI","D")
	TcSetField("ARQ_SQL","RA_DATAALT","D")
	TcSetField("ARQ_SQL","RA_DTVTEST","D")
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()
    LI:=iif(upper(mv_par05)="N",2,80)
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
		    if upper(mv_par05) = "S"        
			   LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			   LI+=2
		    endif
		endif
	
	    @ Li, 001      Psay RA_FILIAL 
    	for  i = 9 to len(aReturn)
             if upper(substr(aReturn[i],18,1)) = "X" .and. upper(alltrim(substr(aReturn[i],65,10))) <> "RA_FILIAL"
                variavel:=upper(alltrim(substr(aReturn[i],65,10)))
                @Li, pcol()+1 psay "|"
	            @Li, pcol()+1 psay &variavel   
	            if upper(alltrim(substr(aReturn[i],65,10))) = "RA_CODFUNC"
	                vCampo="ARQ_SQL->RA_CODFUNC"
	            	dbSelectArea("SRJ")
	            	dbSetOrder(1)
	            	dbSeek(xfilial("SRJ")+&vCampo)
	            	@Li, pcol()+1 psay "|"
	            	@Li, pcol()+1 psay SRJ->RJ_Desc
	            	dbSelectArea("ARQ_SQL")
	            endif
	            if upper(alltrim(substr(aReturn[i],65,10))) = "RA_CC"
	                vCampo="ARQ_SQL->RA_CC"
	            	dbSelectArea("CTT")
	            	dbSetOrder(1)
	            	dbSeek(xfilial("CTT")+&vCampo)
	            	@Li, pcol()+1 psay "|"
	            	@Li, pcol()+1 psay CTT->CTT_DESC01
	            	dbSelectArea("ARQ_SQL")
	            endif
	            if upper(alltrim(substr(aReturn[i],65,10))) = "RA_TNOTRAB"
	                vCampo="ARQ_SQL->RA_TNOTRAB"
	            	dbSelectArea("SR6")
	            	dbSetOrder(1)
	            	dbSeek(xfilial("SR6")+&vCampo)
	            	@Li, pcol()+1 psay "|"
	            	@Li, pcol()+1 psay SR6->R6_DESC
	            	dbSelectArea("ARQ_SQL")
	            endif
	         endif
        next

		LI++
		dbSkip()
	Enddo
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
