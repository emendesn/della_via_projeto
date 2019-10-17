
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR04 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR04   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SB1"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Pesquisa de Prdutos"
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR04"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOLR4"
	Private titulo         := "Relatorio Pesquisa de Produtos"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR04"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","Carcaça              ?"," "," ","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""          })
    aAdd(aRegs,{cPerg,"02","Tipo?MO/BN/MP/ME     ?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"03","Grupo?SERV/SC/CI/ATEC?"," "," ","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
	Pergunte(cPerg,.F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

//	Processa({|| RunReport() },Titulo,,.t.)
//Return nil
    RptStatus({||Runreport()})

Static Function RunReport()

	Cabec1:=" CARCACA         CODIGO          DESCRICAO DO SERVICO           TP GRUP FABRICANTE"

	cSql :=	"select B1_COD,B1_DESC,B1_PRODUTO,B1_TIPO,B1_GRUPO,B1_FABRIC"
    cSql += "  from " + RetSqlName("SB1")+ " SB1 "
    cSql += " where D_E_L_E_T_ = ' ' "
    cSql += "   and B1_FILIAL  = '  ' "
    cSql += "   and B1_TIPO    = '" + upper(mv_par02) + "' "
    if upper(mv_par01) # space(15)
       if upper(mv_par02) = "MO" .and. upper(mv_par03) $ "SERV/SC  "
          cSql += "   and B1_PRODUTO = '" + upper(mv_par01) + "' "     
       else
          cSql += "   and B1_COD     = '" + upper(mv_par01) + "' "   
       endif
    else
       if mv_par02 # space(2)
          cSql += "   and B1_TIPO    = '" + upper(mv_par02) + "' "
       endif
    endif    
    if mv_par03 # space(4) 
       cSql += "   and B1_GRUPO   = '" + upper(mv_par03) + "' " 
    endif  
    cSql += " order BY B1_PRODUTO,B1_DESC,B1_COD "

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

/*	TcSetField("ARQ_SQL","E2_EMISSAO","D")
	TcSetField("ARQ_SQL","E2_VENCTO", "D")
	TcSetField("ARQ_SQL","E2_VENCREA","D")
	TcSetField("ARQ_SQL","E2_SALDO",  "N",14,2)
	TcSetField("ARQ_SQL","E2_VALOR"  ,"N",14,2)       */
	
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

		lImp:=.t.
		if li>55
               LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			   LI+=2
		endif

	    @Li, 001      PSAY ARQ_SQL->B1_PRODUTO  
	    @Li, pcol()+1 PSAY ARQ_SQL->B1_COD
        @Li, pcol()+1 PSAY ARQ_SQL->B1_DESC
	    @Li, pcol()+1 PSAY ARQ_SQL->B1_TIPO
        @Li, pcol()+1 Psay ARQ_SQL->B1_GRUPO 
        @Li, pcol()+1 PSAY ARQ_SQL->B1_FABRIC
 
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
