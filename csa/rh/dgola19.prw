
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLA19 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolA19   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
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
	Private nomeprog       := "DGOLA19"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL19"
	Private titulo         := "Gera Títulos a Pagar - Contribuição Sindical"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLA19"
	Private lImp           := .F.
	PRIVATE lMsErroAuto    := .F.
    Private vSeqTit        := 000
    PRIVATE VTOTVALBOL	   := 0
    PRIVATE VTOTVALINV	   := 0
    Private vFolAno        := substr(getmv("mv_folmes"),1,4)
    Private vFolMes        := substr(getmv("mv_folmes"),5,2)
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
    aAdd(aRegs,{cPerg,"01","Prefixo do Título.:"," "," ","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"02","Tipo Título.......:"," "," ","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SES","","","",""          })
    aAdd(aRegs,{cPerg,"03","Natureza do Título:"," "," ","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SED","","","",""          })
    aAdd(aRegs,{cPerg,"04","Portador..........:"," "," ","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""          })
  	
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

	Cabec1 := " Periodo Folha:" + vFolMes + "/" + vFolAno    + space(5)
	Cabec1 += " Prefixo:"       + mv_par01                   + space(5)
	Cabec1 += " Tipo Titulo:"   + mv_par02                   + space(5)
	Cabec1 += " Natureza:"      + mv_par03                   + space(5)
	Cabec1 += " Portador:"      + mv_par04                   
	Cabec2 := " FL CS VER GPE NUMTITP BOL FORNEC LJ SINDICATO                                 EMISSAO  VENCTO        VALOR  NATU POR CONTA CONT. MENSAGEM"

	dbSelectArea("ZCE")
	dbSetOrder(1)
	dbSelectArea("RCE")
	do while !eof()
		vPv := 1
		vPd := 1
		dbSelectArea("ZCE")
		for i = 1 to 5
			if i > 1
				vPv := vPv + 4
				vPd := vPd + 3
			endif
			if substr(RCE->RCE_VERBAS,vpv,3) <> space(3)
				dbseek(xfilial("ZCE")+RCE->RCE_CODIGO+substr(RCE->RCE_VERBAS,vPv,3))
				if eof()
					if RecLock("ZCE",.T.)
						ZCE->ZCE_FILIAL := "  "
						ZCE->ZCE_SINDIC := RCE->RCE_CODIGO
						ZCE->ZCE_VERBA  := substr(RCE->RCE_VERBAS,vPv,3) 
			            MsUnlock ()
			        endif
			    endif
			    if RecLock("ZCE",.F.)
			    	ZCE->ZCE_DIABOL := substr(RCE->RCE_VENCTO,vPd,2)
			    	MsUnlock ()
			    endif
			endif
		next
	    dbSelectArea("RCE")
	    dbSkip ()
	enddo
	                                                                               
	cSql :=	"select SUM(SRC.RC_VALOR) AS VALBOL, "
	CSQL += "        SRC.RC_FILIAL, "
    CSQL += "        SRA.RA_SINDICA, "
    CSQL += "        ZCE.ZCE_VERBA, "
	CSQL += "        ZCE.ZCE_DIABOL, "
	CSQL += "        SA2.A2_COD, "
	CSQL += "        SA2.A2_LOJA, "
	CSQL += "        SA2.A2_NOME "
	cSql += "  from " + RetSqlName("SRC") + " SRC, "
	cSql +=             RetSqlName("SRA") + " SRA, "
    cSql +=             RetSqlName("RCE") + " RCE, "
    cSql +=             RetSqlName("ZCE") + " ZCE, "
    cSql +=             RetSqlName("SA2") + " SA2  "
    cSql += " where SRC.D_E_L_E_T_ = ' ' "
	
	cSql += "   and SRA.D_E_L_E_T_ = ' ' "
	csql += "   and SRA.RA_FILIAL  = SRC.RC_FILIAL "
	CSQL += "   and SRA.RA_MAT     = SRC.RC_MAT "

	cSql += "   and RCE.D_E_L_E_T_ = ' ' "
 	cSql += "   and RCE.RCE_FILIAL = '  ' "  
	CSQL += "   and RCE.RCE_CODIGO = SRA.RA_SINDICA "
	
    cSql += "   and ZCE.D_E_L_E_T_ = ' ' "
 	cSql += "   and ZCE.ZCE_FILIAL = '  ' "  
	CSQL += "   and ZCE.ZCE_SINDIC = RCE.RCE_CODIGO "
	CSQL += "   and ZCE.ZCE_VERBA  = SRC.RC_PD "
	
	CSQL += "   and SA2.D_E_L_E_T_ = ' ' "
 	CSQL += "   and SA2.A2_FILIAL  = '  ' "
	CSQL += "   and SA2.A2_CGC     =  RCE.RCE_CGC "
    
 	csql += " group by src.rc_filial, sra.ra_sindica, zce.zce_verba, zce.zce_diabol, sa2.a2_cod, sa2.a2_loja, sa2.a2_nome "  
	cSql += " order by src.rc_filial, sra.ra_sindica, zce.zce_verba "

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
		
		@LI, PCOL()+1 PSAY ARQ_SQL->ZCE_VERBA
		
		@LI, PCOL()+1 PSAY mv_par01
		
		vSeqTit   := vSeqTit + 1   
	 	vNumTit   := substr(vFolAno,4,1) + vFolMes + strzero(vSeqTit,3)
		vParTit	 := " "             	
		@Li, pcol()+1 PSAY vNumTit + vParTit

		@Li, pcol()+1 PSAY mv_par02 
 
		@Li, pcol()+1 PSAY ARQ_SQL->A2_COD
  		@Li, pcol()+1 Psay ARQ_SQL->A2_LOJA 
    	@Li, pcol()+1 PSAY ARQ_SQL->A2_NOME

		@Li, pcol()+1 PSAY dDataBase

		if vFolMes == "12"
		   VDatVenTit := stod(strzero(val(vFolAno)+1,4)+"01"                     +ARQ_SQl->ZCE_DiaBol)
		else
 		   VDatVenTit := stod(vFolAno                  +strzero(val(vFolMes)+1,2)+ARQ_SQl->ZCE_DiaBol)
		endif		
  		@Li, pcol()+1 PSAY vDatVenTit
		
  		@Li, pcol()+1 PSAY ARQ_SQL->VALBOL PICTURE "@E 9,999,999.99"

		@Li, pcol()+1 PSAY mv_par03

		@Li, pcol()+1 PSAY mv_par04
		                   
		@Li, pcol()+1 PSAY "21202001008"

		dbSelectArea("SE2")
		dbSetOrder(1)
		MsSeek(xFilial("SE2")+mv_par01+VNumTit+vParTit+mv_par02+ARQ_SQL->A2_COD+ARQ_SQL->A2_LOJA)
		If ! Eof()
		   @LI, pcol()+1 PSAY "TITULO JA CADASTRADO"
		   vTotValInv := vTotValInv + ARQ_SQL->ValBol
		else
			DoTit ()
		   If lMsErroAuto
		      @LI, PCOL()+1 PSAY "ERRO! TITULO INCONSISTENTE ... NAO CADASTRADO"
		      vTotValInv := vTotValInv + ARQ_SQL->ValBol
		   ELSE
		   	vTotValBol := vTotValBol + ARQ_SQL->ValBol
		   	@LI, PCOL()+1 PSAY "TITULO CADASTRADO"
		   EndIf
		ENDIF
		dbSelectArea("ARQ_SQL")
	   dbSkip()
	Enddo
    DoCab()
    @LI, 001	  psay ""
	DoCab()
	@LI, 078      psay "Boletos Incluidos" 
	@Li, pcol()+1 psay vTotValBol            picture "@E 9,999,999.99"
	DoCab()
	@LI, 078      psay "Boletos Invalidos" 
	@Li, pcol()+1 psay vTotValInv            picture "@E 9,999,999.99"
	DoCab()
	@LI, 078      psay "Total Geral......" 
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
	AAdd( _aReg, { "E2_PREFIXO" , mv_par01                        , NIL } )
	AAdd( _aReg, { "E2_NUM"     , vNumTit                         , NIL } )
	AAdd( _aReg, { "E2_PARCELA" , vParTit                         , NIL } )
	AAdd( _aReg, { "E2_TIPO"    , mv_par02                        , NIL } )
	AAdd( _aReg, { "E2_NATUREZ" , mv_par03                        , NIL } )
	AAdd( _aReg, { "E2_PORTADO" , mv_par04                        , NIL } )
	AAdd( _aReg, { "E2_FORNECE" , ARQ_SQL->A2_COD                 , NIL } )
	AAdd( _aReg, { "E2_LOJA"    , ARQ_SQL->A2_LOJA                , NIL } )
	AAdd( _aReg, { "E2_NOMFOR"  , ARQ_SQL->A2_NOME                , NIL } )
	AAdd( _aReg, { "E2_EMISSAO" , dDataBase                       , NIL } )
	AAdd( _aReg, { "E2_VENCTO"  , VDatVenTit                      , NIL } )
	AAdd( _aReg, { "E2_VENCREA" , DataValida(VDatVenTit,.T.)      , NIL } )
	AAdd( _aReg, { "E2_VALOR"   , ARQ_SQL->VALBOL                 , NIL } )
	AAdd( _aReg, { "E2_CONTAD"  , "21202001008"                   , NIL } )
	AAdd( _aReg, { "E2_HIST"    , "CONTRIBUICAO SINDICAL"         , NIL } )
				
	MsExecAuto( {|x,y| Fina050(x,y)}, _aReg, 3 )
		
Return nil
