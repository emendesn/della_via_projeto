
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR20 ()

	Private cString        := "SB1"
	Private aOrd           := {}
	Private cDesc1         := "Gerar arquivos a partir do Cadastro de Materiais-SB1 / DA1 / AIB                    "
	Private cDesc2         := "Desmarque todos os campos da pasta DICIONÁRIO e selecione os desejados.             "
	Private cDesc3         := "Caso não deseje imprimir o cabeçalho informe (N) em parâmetros. Uso restrito        "
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR20"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL20"
	Private titulo         := "SB1"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR20"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {} 
   	AAdd(aRegs,{cPerg,"01","Do Grupo...............?"," "," ","mv_ch1","C", 4,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
   	AAdd(aRegs,{cPerg,"02","Até o Grupo............?"," "," ","mv_ch2","C", 4,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
   	AAdd(aRegs,{cPerg,"03","Do Código..............?"," "," ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
   	AAdd(aRegs,{cPerg,"04","Até o Código...........?"," "," ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
 	AAdd(aRegs,{cPerg,"05","Cabeçalho (N)ão/(S)im..?"," "," ","mv_ch5","C", 1,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"06","Bloqueado (N)ão/(S)im..?"," "," ","mv_ch6","C", 1,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"07","Tab.Preco (C/V)........?"," "," ","mv_ch7","C", 1,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"08","Tab.Preco (VENDA)......?"," "," ","mv_ch8","C", 3,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","DA1","","","",""})
   	AAdd(aRegs,{cPerg,"09","Tab.Preco (COMPRA).....?"," "," ","mv_ch9","C", 3,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","AIB","","","",""})
    AAdd(aRegs,{cPerg,"10","Codigo Fornecedor......?"," "," ","mv_chA","C", 6,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
    AAdd(aRegs,{cPerg,"11","Loja Fornecedor........?"," "," ","mv_chB","C", 2,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"12","Ordem(C)odigo(P)roduto.?"," "," ","mv_chA","C", 1,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
    
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

	Cabec1:=" |Grupo de |" + mv_par01 + "| até |" + mv_par02 + "| Codigo|" + mv_par03 + "| até |" + mv_par04 + "|" 
   	if upper(mv_par07) == "V" 
    	Cabec1 += " | Tabela de Venda  | " + mv_par08
	else
		Cabec1 += " | Tabela de Compra | " + mv_par09 + "| Fornecedor | " + mv_par10 + "-" + mv_par11
	endif
	 
   	Cabec2:=" | Codigo | Descricao do Produto           | "

	cSql := ""
	cSql += "select B1_FILIAL, B1_COD, B1_DESC"
	for  i = 9 to len(aReturn)
	    if upper(substr(aReturn[i],18,1)) = "X"
	       if !(upper(alltrim(substr(aReturn[i],65,10))) == "B1_FILIAL" .or. ;
	            upper(alltrim(substr(aReturn[i],65,10))) == "B1_COD" .or. ;
	            upper(alltrim(substr(aReturn[i],65,10))) == "B1_DESC")
	       		Cabec2 += substr(aReturn[i],4,13) + "|"
	       		cSql   += " ,"+alltrim(substr(aReturn[i],65,10))
	       endif
	    endif
    next 
    Cabec2 += " |    Preço |"
     
    if upper(mv_par07) == "V" 
    	cSql += " ,DA1_PRCVEN "
	else
		cSql += " ,AIB_PRCCOM "
	endif
	       
    cSql += "  from " + RetSqlName("SB1")+ " SB1, "
    
    if upper(mv_par07) == "V" 
    	cSql +=         RetSqlName("DA1")+ " DA1  "
    else
        cSql +=         RetSqlName("AIB")+ " AIB  "
    endif
    
    cSql += "  where SB1.D_E_L_E_T_ = ' ' "
    if upper(mv_par07) == "V" 
    	cSql += "and DA1.D_E_L_E_T_ = ' ' "
    else
        cSql += "and AIB.D_E_L_E_T_ = ' ' "
    endif
    
    cSql +=  "   and B1_FILIAL = '  ' "
    if upper(mv_par07) == "V" 
    	cSql += "and DA1_FILIAL = '  ' "
    else
        cSql += "and AIB_FILIAL = '  ' "
    endif
    
    if upper(mv_par07) == "V" 
    	cSql += "and DA1_CODTAB = '" + mv_par08 + "' "   
    	cSql += "and DA1_CODPRO = B1_COD "
    else
        cSql += "and AIB_CODFOR = '" + mv_par10 + "' "
        cSql += "and AIB_LOJFOR = '" + mv_par11 + "' "
        cSql += "and AIB_CODTAB = '" + mv_par09 + "' " 
        cSql += "and AIB_CODPRO = B1_COD " 
    endif
    
    
    if mv_par01 # space(4) .or. mv_par02 # space(4)
       cSql += "   and B1_GRUPO >= '" + mv_par01 + "' " 
       cSql += "   and B1_GRUPO <= '" + mv_par02 + "' "
    else
       cSql += "   and B1_GRUPO >= '  ' and B1_GRUPO <= 'ZZ' " 
    endif
    if mv_par03 # space(6) .or. mv_par04 # space(6)
       cSql += "   and B1_COD   >= '" + mv_par03 + "' "
       cSql += "   and B1_COD   <= '" + mv_par04 + "' "    
    else
       cSql += "   and B1_COD   >= '      ' and B1_COD <= 'ZZZZZZ' "
    endif 
    if upper(mv_par06) # "S"
       cSql += "   and B1_MSBLQL != '1' "
    endif
    
    if upper(mv_par12) = "C"
    	cSql += "order by B1_Cod "
    else
    	cSql += "order by B1_Desc, B1_Cod "
    endif

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","DA1_PRCVEN","N",14,2)
	TcSetField("ARQ_SQL","AIB_PRCCOM","N",14,2)

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
	
	    @ Li, 001      Psay "|"
	    @ Li, pcol()+1 psay ARQ_SQL->B1_COD
	    @ Li, pcol()+1 psay "|" 
	    @ Li, pcol()+1 psay ARQ_SQL->B1_DESC
    	for  i = 9 to len(aReturn)
             if upper(substr(aReturn[i],18,1)) = "X" 
                variavel:=upper(alltrim(substr(aReturn[i],65,10)))
                @Li, pcol()+1 psay "|"
	            @Li, pcol()+1 psay &variavel
	         endif
        next   
    	@Li, pcol()+1 psay "|"
	    if upper(mv_par07) == "V" 
    		@Li, pcol()+1 psay DA1_PRCVEN PICTURE "999,999.99"
		else
			@Li, pcol()+1 psay AIB_PRCCOM PICTURE "999,999.99"
		endif

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
