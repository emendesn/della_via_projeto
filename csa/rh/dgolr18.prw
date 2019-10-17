
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR18 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR18   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	
	Private cString        := "RC1"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "G"
	Private nomeprog       := "DGOLR18"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL18"
	Private titulo         := "Pesquisa Integração Folha x Financeiro"
	Private Li             := 99
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR18"
	Private lImp           := .F.
 	Private Cab1           := ""
 	Private Cab2           := ""
  	Private Cab3           := ""
  	Private vFil		   := ""   
	Private vTotFil		   := 0
	Private vTotEmp        := 0
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Filial Tit.....de?"," "," ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
 	aAdd(aRegs,{cPerg,"02","Filial Tit....até?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
  	aAdd(aRegs,{cPerg,"03","Codigo Tit.....de?"," "," ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Codigo Tit....até?"," "," ","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Numero Tit.....de?"," "," ","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"06","Numero Tit....ate?"," "," ","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"07","Emissao........de?"," "," ","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"08","Emissao.......até?"," "," ","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"09","Vencimento.....de?"," "," ","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"10","Vencimento....até?"," "," ","mv_chA","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"11","Fornecedor.....de?"," "," ","mv_chB","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""          })
    aAdd(aRegs,{cPerg,"12","Fornecedor....ate?"," "," ","mv_chC","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""          })
    aAdd(aRegs,{cPerg,"13","Cod Integr.....de?"," "," ","mv_chD","C",01,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"14","Cod Integr....ate?"," "," ","mv_chE","C",01,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"15","Classificacao....?"," "," ","mv_chF","C",01,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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

	Cabec1  := " Filial Tit de:"  + mv_par01       + " até:" + mv_par02       + space(5)
 	Cabec1  += "Codigo Tit de:"   + mv_par03       + " até:" + mv_par04       + space(5)
 	Cabec1  += "Numero Tit de:"   + mv_par05       + " até:" + mv_par06       + space(5)
 	Cabec1  += "Emissão de:"      + dtos(mv_par07) + " até:" + dtos(mv_par08) + space(5)
  	Cabec1  += "Vencimento de:"   + dtos(mv_par09) + " até:" + dtos(mv_par10) + space(5)
    Cabec1  += "Fornecedor de:"   + mv_par11       + " até:" + mv_par12       + space(5) 
	Cabec2  := " FL Numero Integraçao      Cod Descricao Operacao             Emissao   Vencto  Tip Natureza   Fornec        Valor 
"  
	CSQL := "SELECT RC1.RC1_FILTIT, "
 	CSQL += "       RC1.RC1_NUMTIT, "
    CSQL += "       RC1.RC1_INTEGR, "
    CSQL += "       RC1.RC1_CODTIT, "
    CSQL += "       RC1.RC1_DESCRI, "
    CSQL += "       RC1.RC1_VALOR, "
    CSQL += "       RC1.RC1_EMISSA, "
    CSQL += "       RC1.RC1_VENCTO, "
    CSQL += "       RC1.RC1_TIPO, "
    CSQL += "       RC1.RC1_NATURE, "         
    CSQL += "       RC1.RC1_FORNEC " 
    CSQL += "  FROM " + RetSqlName("RC1")+ " RC1 "
	CSQL += " WHERE RC1.D_E_L_E_T_  = ' '" 
    cSqL += "   AND RC1.RC1_FILIAL  = '  '"
    CSql += "   and RC1.RC1_FILTIT  >= '"  + mv_par01       + "' "
    cSql += "   and RC1.RC1_FILTIT  <= '"  + mv_par02       + "' "
    cSql += "   and RC1.RC1_CODTIT  >= '"  + mv_par03       + "' " 
    cSql += "   and RC1.RC1_CODTIT  <= '"  + mv_par04       + "' "
    cSql += "   and RC1.RC1_PREFIX   = 'GPE' " 
    cSql += "   and RC1.RC1_NUMTIT  >= '"  + mv_par05       + "' " 
    cSql += "   and RC1.RC1_NUMTIT  <= '"  + mv_par06       + "' "
    cSql += "   and RC1.RC1_EMISSA  >= '"  + DTOS(mv_par07) + "' "
    cSql += "   and RC1.RC1_EMISSA  <= '"  + DTOS(mv_par08) + "' " 
    cSql += "   and RC1.RC1_VENCTO  >= '"  + DTOS(mv_par09) + "' "
    cSql += "   and RC1.RC1_VENCTO  <= '"  + DTOS(mv_par10) + "' " 
    CSQL += "   AND RC1.RC1_FORNEC  >= '"  + mv_par11       + "' "
 	CSQL += "   AND RC1.RC1_FORNEC  <= '"  + mv_par12       + "' "
    cSql += "   and RC1.RC1_INTEGR  >= '"  + mv_par13       + "' " 
    cSql += "   and RC1.RC1_INTEGR  <= '"  + mv_par14       + "' "   
    CSQL += " ORDER BY RC1.RC1_FILIAL,RC1.RC1_FILTIT"
    do case
       case mv_par15 == "1"
    		CSQL += ",RC1.RC1_CODTIT,RC1.RC1_NUMTIT"
       case mv_par15 == "2"
    		CSQL += ",RC1.RC1_INTEGR,RC1.RC1_CODTIT,RC1.RC1_EMISSA,RC1.RC1_TIPO,RC1.RC1_FORNEC,RC1.RC1_NATURE"
       case mv_par15 == "3"
    		CSQL += ",RC1.RC1_EMISSA,RC1.RC1_INTEGR,RC1.RC1_CODTIT,RC1.RC1_TIPO,RC1.RC1_FORNEC,RC1.RC1_NATURE"
    endcase
    MsgRun("Consultado Base de Dados Della Via",,{|| cSql := ChangeQuery(cSql)}) 
    MsgRun("Consultado Base de Dados Della Via",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})
   
    TcSetField("ARQ_SQL","RC1_EMISSA","D")
    TcSetField("ARQ_SQL","RC1_VENCTO","D")
    TcSetField("ARQ_SQL","RC1_VALOR" ,"N",14,2)
   
    dbSelectArea("ARQ_SQL")
    ProcRegua(0)
   
    Do While !eof()
   
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		if vFil != ARQ_SQL->RC1_FILTIT
			DoTotal()
		endif
		DOCABEC()
		@LI, 001      PSAY ARQ_SQL->RC1_FILTIT
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_NUMTIT
		@LI, PCOL()+1 PSAY IIF(ARQ_SQL->RC1_INTEGR=="0","0-NAO LIBERADO ",IIF(ARQ_SQL->RC1_INTEGR=="1","1-LIBERADO     ","2-INCONSISTENTE"))
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_CODTIT
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_DESCRI
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_EMISSA
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_VENCTO
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_TIPO                             
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_NATURE
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_FORNEC
		@LI, PCOL()+1 PSAY ARQ_SQL->RC1_VALOR PICTURE "@E 9,999,999.99"
		vTotFil := vTotFil + ARQ_SQL->RC1_VALOR
		
		dbSkip()
	Enddo 

	DOTOTAL()                
	DOCABEC()
	@LI, 001      PSAY "Total Geral"
    @LI, 102      PSAY VTOTEMP PICTURE "@E 9,999,999.99"	
 	
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

Static Function Dototal
			IF VFIL != ""
				DOCABEC()
				@LI, 001      PSAY "Filial " + vFil
				@Li, 102      psay VTOTFIL PICTURE "@E 9,999,999.99"
			ENDIF
			VTOTEMP  := VTOTEMP + VTOTFIL
			VTOTFIL  := 0
			VFIL	 := ARQ_SQL->RC1_FILTIT
Return