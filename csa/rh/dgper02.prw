
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGPER02 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGEPR02    ºAutor  ³ by Golo           º Data ³  08/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Valores Futuro                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SRK"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Valores Futuro"
	Private tamanho        := "M"
	Private nomeprog       := "DGPER02"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGPER2"
	Private titulo         := "Valores Futuros"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGPER02"
	Private lImp           := .F.
    
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
    AAdd(aRegs,{cPerg,"01","Da Filial            ?","  ","  ","mv_ch1","C",  2,0,0,"G","","mv_par01","  ","","","","","","","","","","","","","","","","","","","","","","","",""})
    AAdd(aRegs,{cPerg,"02","Ate a Filial         ?","  ","  ","mv_ch2","C",  2,0,0,"G","","mv_par02","  ","","","","","","","","","","","","","","","","","","","","","","","",""})

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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
              XX | XXXXXX |XXX  |XXXXXXXXXXXXXXXXXXXX  |XXXXXXXXXXXX  | XX | XXXXXXXXXXXX |XXXXXXXXXXXX|XXXXXXXXXXXX|XXXXXXXXX| */
	Cabec2+=" FL|MATRIC|COD|DESCRICAO DA VERBA  |VALOR PRINC.|NP|VALOR PARCEL|PP|  VALOR PAGO|       SALDO|CCUSTO   "                                                                                                                      
	cSql  := ""
	cSql  += "select SRK.RK_FILIAL,"
	cSql  += "       SRK.RK_MAT,"
	cSql  += "       SRK.RK_PD,"
	cSql  += "       SRK.RK_VALORTO,"
	cSql  += "       SRK.RK_PARCELA,"
	cSql  += "       SRK.RK_VALORPA,"
	cSql  += "       SRK.RK_PARCPAG,"
	cSql  += "       SRK.RK_VLRPAGO,"
    cSql  += "       SRK.RK_CC,"
    cSql  += "       SRV.RV_DESC" 
    cSql  += "  from " + RetSqlName("SRK") + " SRK," 
    cSql  +=             RetSqlName("SRV") + " SRV"
    cSql  += " where SRK.D_E_L_E_T_ = ' ' "
    cSql  += "   and SRV.D_E_L_E_T_ = ' ' "
    cSql  += "   and SRK.RK_FILIAL >= '" + mv_par01 + "' "
    cSql  += "   and SRK.RK_FILIAL <= '" + mv_par02 + "' "
    cSql  += "   and RK_PD = RV_COD"
    cSql  += " order by RK_FILIAL, RK_MAT"

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
    
    TcSetField("ARQ_SQL","RK_VALORTO" ,"N",12,2) 
    TcSetField("ARQ_SQL","RK_PARCELA" ,"N",02,0)
    TcSetField("ARQ_SQL","RK_VALORPA" ,"N",12,2)
    TcSetField("ARQ_SQL","RK_PARCPAG" ,"N",02,0)
    TcSetField("ARQ_SQL","RK_VLRPAGO" ,"N",12,2)
	
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

		lImp := .t.
		if li>55
		    LI := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
		    LI += 2
		endif
	    
        IF (RK_VLRPAGO + 0) < (RK_VALORTO + 0)
	       @ LI, 001    psay RK_FILIAL   
           @ LI, pcol() psay "|"	    
           @ LI, pcol() psay RK_MAT
           @ LI, pcol() psay "|"
           @ LI, pcol() psay RK_PD
           @ LI, pcol() psay "|"
           @ LI, pcol() psay RV_DESC
           @ LI, pcol() psay "|"  
           @ LI, pcol() psay RK_VALORTO                PICTURE "999999999.99"
           @ LI, pcol() psay "|"
           @ LI, pcol() psay RK_PARCELA                PICTURE "99"
           @ LI, pcol() psay "|"
           @ LI, pcol() psay RK_VALORPA                PICTURE "999999999.99"
           @ LI, pcol() psay "|"
           @ LI, pcol() psay RK_PARCPAG                PICTURE "99"
           @ LI, pcol() psay "|"                       
           @ LI, pcol() psay RK_VLRPAGO                PICTURE "999999999.99"
           @ LI, pcol() psay "|"  
           @ LI, pcol() psay (RK_VALORTO - RK_VLRPAGO) PICTURE "999999999.99"
           @ LI, pcol() psay "|"
           @ LI, pcol() psay RK_CC  
           LI++
        ENDIF

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
