
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR13V1 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR13V1   ºAutor³ by Golo            º Data ³  06/06/06   º±±
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
	Private cDesc2         := "de transferencia entre armazens"
	Private cDesc3         := "Relatório de Transferencia entre Armazens"
	Private tamanho        := "M"
	Private nomeprog       := "DGOLR13V1"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOR13"
	Private titulo         := "Relatorio Transferencia entre Armazens"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR13V1"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

    aAdd(aRegs,{cPerg,"01","Filial de            ?"," "," ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"02","Filial ate           ?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"03","Grupo de             ?"," "," ","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Grupo ate            ?"," "," ","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })          
    aAdd(aRegs,{cPerg,"05","Codigo Produto de    ?"," "," ","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"06","Codigo Produto ate   ?"," "," ","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"07","Armazem de           ?"," "," ","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"08","Armazem ate          ?"," "," ","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"09","Data de              ?"," "," ","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"10","Data ate             ?"," "," ","mv_chA","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
//    aAdd(aRegs,{cPerg,"11","Ordem                ?"," "," ","mv_chB","N",01,0,0,"C","","mv_par11","Grupo     ","","","","","Codigo","","","","","Descricao ","","","","","Data","","","","","","","","","   ","","","",""          })

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

    RptStatus({||Runreport()})

Static Function RunReport()
           // xx xx/xx/xx xxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx 999,999,999,99 xx 9999.9999 999,999,999,99 xx
	Cabec1:=" FL  Data   Grup Codigo           Descricao do Produto           Ar Qt.1a U Medida 1U Conversao Qt.2a U Medida 2U"

	cSql :=	"select D3_FILIAL, D3_COD, D3_QUANT, D3_LOCAL, D3_EMISSAO, D3_GRUPO, D3_QTSEGUM, "
	cSql += "       B1_DESC,   B1_UM,  B1_SEGUM, B1_CONV " 
    cSql += "  from " + RetSqlName("SD3") + " SD3 "
    cSql += "  join " + RetSqlName("SB1") + " SB1 "
    cSql += "    on SB1.D_E_L_E_T_ = '' " 
    cSql += "   and SB1.B1_COD     = SD3.D3_COD "
    cSql += " where SD3.D_E_L_E_T_ = '' "
    cSql += "   and SD3.D3_FILIAL  between '" + mv_par01       + "' and '" + mv_par02       + "' "    
    cSql += "   and SD3.D3_GRUPO   between '" + mv_par03       + "' and '" + mv_par04       + "' "
    cSql += "   and SD3.D3_COD     between '" + mv_par05       + "' and '" + mv_par06       + "' "
    cSql += "   and SD3.D3_LOCAL   between '" + mv_par07       + "' and '" + mv_par08       + "' "
    cSql += "   and SD3.D3_Emissao between '" + dtos(mv_par09) + "' and '" + dtos(mv_par10) + "' "   
    cSql += "   and SD3.D3_CF      = 'RE4' "   
    cSql += " order by SD3.D3_FILIAL, SD3.D3_EMISSAO, SD3.D3_GRUPO, SD3.D3_COD, SD3.D3_LOCAL "
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","D3_EMISSAO","D")
	TcSetField("ARQ_SQL","E2_VENCREA","D")
	TcSetField("ARQ_SQL","D3_QUANT",  "N",14,2)
	TcSetField("ARQ_SQL","D3_QTSEGUM","N",14,2)       
	TcSetField("ARQ_SQL","B1_CONV",   "N",14,4)       
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	
	Do While !eof() 
	
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

	    @Li, 001      PSAY ARQ_SQL->D3_FILIAL
	    @Li, pcol()+1 PSAY ARQ_SQL->D3_EMISSAO 
	    @Li, pcol()+1 PSAY ARQ_SQL->D3_GRUPO
        @Li, pcol()+1 PSAY ARQ_SQL->D3_COD
	    @Li, pcol()+1 PSAY ARQ_SQL->B1_DESC
        @Li, pcol()+1 Psay ARQ_SQL->D3_LOCAL 
        @Li, pcol()+1 PSAY ARQ_SQL->D3_QUANT   PICTURE "999,999,999,99"
        @Li, pcol()+1 PSAY ARQ_SQL->B1_UM      
        @Li, pcol()+1 PSAY ARQ_SQL->B1_CONV    PICTURE "9999.9999"
        @Li, pcol()+1 PSAY ARQ_SQL->D3_QTSEGUM PICTURE "999,999,999,99"
        @Li, pcol()+1 PSAY ARQ_SQL->B1_SEGUM
 
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
