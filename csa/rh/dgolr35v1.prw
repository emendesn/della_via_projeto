
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR35V1 ()

	Private cString        := "SB2"
	Private aOrd           := {}
	Private cDesc1         := "RELATORIO SALDO ESTOQUE 2 UNIDADE "
	Private cDesc2         := "              "
	Private cDesc3         := "              "
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR35V1"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL35"
	Private titulo         := "Relatorio Saldo Estoque 2 Unidades"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR35"
	Private lImp           := .F.
    Private xCusto         := 0.0
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {} 
   	AAdd(aRegs,{cPerg,"01","Produto de.........?"," "," ","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
   	AAdd(aRegs,{cPerg,"02","Até................?"," "," ","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	AAdd(aRegs,{cPerg,"03","Grupo de...........?"," "," ","mv_ch3","C",4,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"04","Até................?"," "," ","mv_ch4","C",4,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	AAdd(aRegs,{cPerg,"05","Armazem de.........?"," "," ","mv_ch5","C",2,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
   	AAdd(aRegs,{cPerg,"06","Até................?"," "," ","mv_ch6","C",2,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	AAdd(aRegs,{cPerg,"07","Imprime Zerado.....?"," "," ","mv_ch7","C",1,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
	AAdd(aRegs,{cPerg,"08","Ordem.C/G/F/L......?"," "," ","mv_ch8","C",1,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})

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

	Cabec1 := "Durapol:" + xFilial("SB2") 
   	Cabec2 := "Grupo Codigo          LO Descricao do Produto              Quantidade01 1U Quantidade02 2U Fabricante"
    //                   1         2         3         4         5         6         7         8                  10
    //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cSql := "SELECT B1_GRUPO, B2_COD, B2_LOCAL, B1_DESC, B1_UM, B2_QATU, B1_SEGUM, B1_CONV, B1_Fabric " 
  	cSql += "  FROM SB1030 SB1 " 
  	cSql += "  JOIN SB2030 SB2 "    
    cSql += "    ON SB2.D_E_L_E_T_ = '' " 
    cSql += "   AND SB2.B2_FILIAL  = '" + XFILIAL("SB2") +"' " 
	cSql += "   AND SB2.B2_COD     = B1_COD "
	cSql += "   AND SB2.B2_LOCAL   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
	If MV_PAR07 $ "nN"
		cSql += "   AND SB2.B2_QATU > 0 "  
    Endif
    cSql += " WHERE SB1.D_E_L_E_T_ = '' "          
    cSql += "   AND SB1.B1_COD     BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
    cSql += "   AND SB1.B1_GRUPO   BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "         
    cSql += "   AND SB1.B1_MSBLQL  = '2' "
    Do Case
    	case MV_PAR08 $ "Cc"
    		cSql += " ORDER BY B2_COD,B2_LOCAL "
    	case MV_PAR08 $ "Gg"
    		cSql += " ORDER BY B1_GRUPO,B2_COD,B2_LOCAL "
    	case MV_PAR08 $ "Ff"
    		cSql += " ORDER BY B1_FABRIC,B1_GRUPO,B2_COD,B2_LOCAL "
    	case MV_PAR08 $ "Ff"
    		cSql += " ORDER BY B2_LOCAL,B1_GRUPO,B2_COD "
    EndCase
    
	MsgRun("Consultando Banco de dados ... SB2",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","B2_QFIM", "N",14,4)
	TcSetField("ARQ_SQL","B1_CONV", "N",14,4)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()        
 
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
		Li++
		@Li,00 psay Arq_Sql->B1_GRUPO
		@Li,06 psay Arq_Sql->B2_COD
		@Li,22 psay Arq_Sql->B2_LOCAL
		@Li,25 psay Arq_Sql->B1_DESC
		@Li,59 psay Arq_Sql->B2_QATU    PICTURE "9,999,999.99"
		@Li,72 psay Arq_Sql->B1_UM
		if Arq_Sql->B1_CONV > 0
		    @Li,75 psay Arq_Sql->B2_QATU / Arq_Sql->B1_CONV PICTURE "9,999,999.99"        
		endif  
		@Li,88 psay Arq_Sql->B1_SEGUM       
		@Li,91 psay Arq_Sql->B1_Fabric

		dbSelectArea("ARQ_SQL")
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



