
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLA16 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolA16   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera titulos a pagar sindicato                             º±±
±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	Private cString        := "SE2"
	Private aOrd           := {}
	Private cDesc1         := "Gera títulos a pagar por filial x sindicato"
	Private cDesc2         := "Informar em parametros: Periodo da folha, prefixo, verbas, tipo do titulo, natureza da operação e portador"
	Private cDesc3         := "Informar a verba no seguinte formato: VVV,VVV,... onde VVV=verba  ex: 510,511,512"
	Private tamanho        := "G"
	Private nomeprog       := "DGOLA16"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL16"
	Private titulo         := "Gera Títulos a Pagar - Contribuição Sindical"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLA16"
	Private lImp           := .F.
	PRIVATE lMsErroAuto    := .F.
    Private vSeqTit        := 000
    PRIVATE VTOTVALBOL	  := 0
    PRIVATE VTOTVALINV	  := 0	

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Data Folha......de:"," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
 	aAdd(aRegs,{cPerg,"02","Data Folha.....ate:"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })	
    aAdd(aRegs,{cPerg,"03","Prefixo do Título.:"," "," ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Analitico....(S/N):"," "," ","mv_ch4","C",01,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Tipo Título.......:"," "," ","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SES","","","",""          })
    aAdd(aRegs,{cPerg,"06","Natureza do Título:"," "," ","mv_ch6","C",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SED","","","",""          })
    aAdd(aRegs,{cPerg,"07","Portador..........:"," "," ","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""          })
  	
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
		Return nil
	Endif                                      

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return nil
	Endif

	RptStatus({||Runreport()})
   
Return nil
 
Static Function RunReport()

	Cabec1 := " Periodo Folha:" + strzero(month(mv_par02),2) + "/" + strzero(year(mv_par02),4) + space(5)
	Cabec1 += " Prefixo:"       + mv_par03                   + space(5)
	Cabec1 += " Tipo Titulo:"   + mv_par05                   + space(5)
	Cabec1 += " Natureza:"      + mv_par06                   + space(5)
	Cabec1 += " Portador:"      + mv_par07                   
	Cabec2 := " FL CS GEP NUMTITP BOL FORNEC LJ SINDICATO                                 EMISSAO  VENCTO        VALOR  NATU POR CONTA CONT. MENSAGEM"

	CSQL := "SELECT SRC.RC_FILIAL, "
    CSQL += "       SRC.RC_VALOR, "
    CSQL += "       SRA.RA_SINDICA, "
	CSQL += "       SRC.RCE_VERBAS, "
	CSQL += "       SA2.A2_COD, "
	CSQL += "       SA2.A2_LOJA, "
	CSQL += "       SA2.A2_NOME "
	cSql += "  from " + RetSqlName("SRC") + " SRC, "
	cSql +=             RetSqlName("SRA") + " SRA, "
    cSql +=             RetSqlName("RCE") + " RCE, "
    cSql +=             RetSqlName("SA2") + " SA2  "
    cSql += " where SRC.D_E_L_E_T_ = ' ' "
	if !empty(mv_par04)                                                               
 		mv_par04 := alltrim(mv_par04) 
   	    vpar04   := "('"
    	virg     := at("," , mv_par04)	
    	do while virg > 0
	   	    Vpar04   := vpar04 + subs(mv_par04,1,virg-1) + "','"
     		mv_par04 := subs(mv_par04,virg+1,len(mv_par04)-virg)
       	    virg = at("," , mv_par04)
    	enddo
    	vpar04 := vpar04 + mv_par04 + "')" 
	    CSQL += "   and SRC.RC_PD in " + vpar04
    endif

	cSql += "   and SRA.D_E_L_E_T_ = ' ' "
	csql += "   and SRA.RA_FILIAL  = SRC.RC_FILIAL "
	CSQL += "   and SRA.RA_MAT     = SRC.RC_MAT "

	cSql += "   and RCE.D_E_L_E_T_ = ' ' "
 	cSql += "   and RCE.RCE_FILIAL = '  ' "  
	CSQL += "   and RCE.RCE_CODIGO = SRA.RA_SINDICA "

	CSQL += "   and SA2.D_E_L_E_T_ = ' ' "
 	CSQL += "   and SA2.A2_FILIAL  = '  ' "
	CSQL += "   and SA2.A2_CGC     =  RCE.RCE_CGC "
    
 	csql += " group by src.rc_filial, sra.ra_sindica, sa2.a2_cod, sa2.a2_loja, sa2.a2_nome, rce.rce_diabol "  
	cSql += " order by src.rc_filial, sra.ra_sindica "

	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","VALBOL","N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)

	Do While !eof() 
	
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			return
		Endif

		DoCab()
		
		@Li, 001      PSAY ARQ_SQL->RC_FILIAL
		
		@LI, PCOL()+1 PSAY ARQ_SQL->RA_SINDICA
		
		@LI, PCOL()+1 PSAY mv_par03
		
		vNumTitAno:= year(mv_par02)-2000
		vNumTitMes:= month(mv_par02)
		vSeqTit   := vSeqTit + 1   
	 	vNumTit   := strzero(vNumTitAno,1) + strzero(vNumTitMes,2) + strzero(vSeqTit,3)
		vParTit	 := " "             	
		@Li, pcol()+1 PSAY vNumTit + vParTit

		@Li, pcol()+1 PSAY mv_par05 
 
		@Li, pcol()+1 PSAY ARQ_SQL->A2_COD
  		@Li, pcol()+1 Psay ARQ_SQL->A2_LOJA 
    	@Li, pcol()+1 PSAY ARQ_SQL->A2_NOME

		@Li, pcol()+1 PSAY dDataBase

		if month(mv_par02) = 12
		   VDatVenTit := stod(strzero(year(mv_par02)+1,4)+"01"+strzero(ARQ_SQl->RCE_DiaBol,2))
		else
 		   VDatVenTit := stod(strzero(year(mv_par02)  ,4)+strzero(month(mv_par02)+1,2)+strzero(ARQ_SQl->RCE_DiaBol,2))
		endif		
  		@Li, pcol()+1 PSAY vDatVenTit
		
  		@Li, pcol()+1 PSAY ARQ_SQL->VALBOL PICTURE "@E 9,999,999.99"

		@Li, pcol()+1 PSAY mv_par06

		@Li, pcol()+1 PSAY mv_par07
		
		@Li, pcol()+1 PSAY "21202001008"

		dbSelectArea("SE2")
		dbSetOrder(1)
		MsSeek(xFilial("SE2")+mv_par03+VNumTit+vParTit+mv_par05+ARQ_SQL->A2_COD+ARQ_SQL->A2_LOJA)
		If ! Eof()
		   @LI, pcol()+1 PSAY "ERRO! TITULO JA CADASTRADO"
		   vTotValInv := vTotValInv + ARQ_SQL->ValBol
		else
			DoTit ()
		   If lMsErroAuto
		      @LI, PCOL()+1 PSAY "ERRO! TITULO INCONSISTENTE ... NAO CADASTRADO"
		      vTotValInv := vTotValInv + ARQ_SQL->ValBol
		   ELSE
		   	vTotValBol := vTotValBol + ARQ_SQL->ValBol
		   	@LI, PCOL()+1 PSAY "(OK)! TITULO CADASTRADO"
		   EndIf
		ENDIF
		dbSelectArea("ARQ_SQL")
	   dbSkip()
	Enddo
    DoCab()
    @LI, 001	  psay ""
	DoCab()
	@LI, 074      psay "Boletos Incluidos" 
	@Li, pcol()+1 psay vTotValBol            picture "@E 9,999,999.99"
	DoCab()
	@LI, 074      psay "Boletos Invalidos" 
	@Li, pcol()+1 psay vTotValInv            picture "@E 9,999,999.99"
	DoCab()
	@LI, 074      psay "Total Geral......" 
	@Li, pcol()+1 psay vTotValBol+vTotValInv picture "@E 9,999,999.99"

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

Static function DoCab ()
	lImp:=.t.
	if li>55
  			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)  
			LI+=2
	endif
	LI++
Return nil

Static function DoTit ()                   

	Local  _aReg		     := {} 
   
	AAdd( _aReg, { "E2_FILIAL"  , xFilial("SE2")                  , NIL } )
	AAdd( _aReg, { "E2_PREFIXO" , mv_par03                        , NIL } )
	AAdd( _aReg, { "E2_NUM"     , vNumTit                         , NIL } )
	AAdd( _aReg, { "E2_PARCELA" , vParTit                         , NIL } )
	AAdd( _aReg, { "E2_TIPO"    , mv_par05                        , NIL } )
	AAdd( _aReg, { "E2_NATUREZ" , mv_par06                        , NIL } )
	AAdd( _aReg, { "E2_PORTADO" , mv_par07                        , NIL } )
	AAdd( _aReg, { "E2_FORNECE" , ARQ_SQL->A2_COD                 , NIL } )
	AAdd( _aReg, { "E2_LOJA"    , ARQ_SQL->A2_LOJA                , NIL } )
	AAdd( _aReg, { "E2_NOMFOR"  , ARQ_SQL->A2_NOME                , NIL } )
	AAdd( _aReg, { "E2_EMISSAO" , dDataBase                       , NIL } )
	AAdd( _aReg, { "E2_VENCTO"  , VDatVenTit                      , NIL } )
	AAdd( _aReg, { "E2_VENCREA" , DataValida(VDatVenTit,.T.)      , NIL } )
	AAdd( _aReg, { "E2_VALOR"   , ARQ_SQL->VALBOL                 , NIL } )
	AAdd( _aReg, { "E2_CONTAD"  , "21202001008"                   , NIL } )
				
	MsExecAuto( {|x,y| Fina050(x,y)}, _aReg, 3 )
		
Return nil
