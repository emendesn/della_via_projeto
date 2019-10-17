
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR06 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDGOLR06   บAutor  ณ by Golo            บ Data ณ  06/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Super Relatorio                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Della Via                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

	Private cString        := "SB1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo gerar arquivos a partir do Cadastro de Materiais-SB1"
	Private cDesc2         := "Desmarque todos os campos da pasta DICIONมRIO e selecione os desejados.             "
	Private cDesc3         := "Caso nใo deseje imprimir o cabe็alho informe (N) em parโmetros. Uso restrito        "
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR06"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOLR6"
	Private titulo         := "SB1"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR06"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {} 
   AAdd(aRegs,{cPerg,"01","Do Grupo             ?"," "," ","mv_ch1","C", 4,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
   AAdd(aRegs,{cPerg,"02","At้ o Grupo          ?"," "," ","mv_ch2","C", 4,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
   AAdd(aRegs,{cPerg,"03","Do C๓digo            ?"," "," ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
   AAdd(aRegs,{cPerg,"04","At้ o C๓digo         ?"," "," ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
 	AAdd(aRegs,{cPerg,"05","Cabe็alho (N)ใo/(S)im?"," "," ","mv_ch5","C", 1,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   AAdd(aRegs,{cPerg,"06","Bloqueado (N)ใo/(S)im?"," "," ","mv_ch6","C", 1,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})

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
    if mv_par01 # space(4) .or. mv_par02 # space(4) .or. mv_par03 # space(6) .or. mv_par04 # space(6)
	   Processa({|| RunReport() },Titulo,,.t.)
	endif
Return nil


Static Function RunReport()
	Cabec1:=" |1| Grupo de |" + mv_par01 + "| at้ |" + mv_par02 + "| Codigo|" + mv_par03 + "| at้ |" + mv_par04 + "|" 
   Cabec2:=" |2|"
/*                                                                                                           
         1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890
02=Codigo=======[x]@!===========================================ZX0_COD===015
*/
	cSql := ""
	cSql += "select B1_FILIAL"
	for  i = 9 to len(aReturn)
	    if upper(substr(aReturn[i],18,1)) = "X" .and. upper(alltrim(substr(aReturn[i],65,10))) <> "B1_FILIAL"
	       Cabec2 += substr(aReturn[i],4,13) + "|"
	       cSql   += " ,"+alltrim(substr(aReturn[i],65,10))
	    endif
    next    
    cSql += "  from " + RetSqlName("SB1")+ " SB1 "
    cSql += " where SB1.D_E_L_E_T_ = ' ' "
    cSql += "   and B1_FILIAL = '  ' " 
    if mv_par01 # space(4) .or. mv_par02 # space(4)
       cSql += "   and B1_GRUPO >= '" + mv_par01 + "' " 
       cSql += "   and B1_GRUPO <= '" + mv_par02 + "' "
    else
       cSql +="   and B1_GRUPO  >= '  ' and B1_GRUPO <= 'ZZ' " 
    endif
    if mv_par03 # space(6) .or. mv_par04 # space(6)
       cSql += "   and B1_COD   >= '" + mv_par03 + "' "
       cSql += "   and B1_COD   >= '" + mv_par04 + "' "    
    else
       cSql += "   and B1_COD   >= '      ' and B1_COD <= 'ZZZZZZ' "
    endif 
    if upper(mv_par06) # "S"
       cSql += "   and B1_MSBLQL != '1' "
    endif

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","I2_DATA","D")
	TcSetField("ARQ_SQL","I2_VALOR","N",14,2)
	
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
	
	    @ Li, 001      Psay "|3"
    	for  i = 9 to len(aReturn)
             if upper(substr(aReturn[i],18,1)) = "X" 
                variavel:=upper(alltrim(substr(aReturn[i],65,10)))
                @Li, pcol()+1 psay "|"
	            @Li, pcol()+1 psay &variavel
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
