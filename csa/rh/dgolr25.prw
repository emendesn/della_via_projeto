#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR25 ()
/*    
	NFSDUKA
*/
	
	Private cString        := "SD2"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "G"
	Private nomeprog       := "DGOLR25"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL25"
	Private titulo         := "Nota Fiscal de Saida"
	Private Li             := 99
	Private Cabec1         := ""
	Private Cabec2         := ""                                        
	Private m_pag          := 01
	Private wnrel          := "NFSDUKA"
	Private lImp           := .F.
 	Private Cab1           := ""
 	Private Cab2           := ""
  	Private Cab3           := ""
  	Private vSoma          := 0   

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Da Data   "," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
 	aAdd(aRegs,{cPerg,"02","Ate a Data"," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB9","","","",""          })
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
	
	Cabec1 := "Período de :" + dtoc(mv_par01) + "até:" + dtoc(mv_par02)
    Cabec2 := "S |Fili|Emitente|Loja|Codigo           | It |Loca|   Quantidade | Data  NF | Numero | Ser | CFOP  |         BaseICM |          BRICMS | NFOrig |SerOr| ItOr |           Total | Cnpj           | Inscricao Estadual | P | T |    Conta             | DtUltCom |Inscricao Municipal | Nome                                     |Endereco                                  |Municipio        | UF |Pais |CEP"
    LI     := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)                                       
    LI     += 2    
    CSQL :=	"SELECT	'S' 		as NF, " 
    CSQL += "       d2_Filial  	as Filial, "
    CSQL += "       d2_Cliente	as Emitente, "
    CSQL += "       d2_loja    	as Loja, "
    CSQL += "       d2_cod     	as Cod, "
    CSQL += "       d2_Item     as Item, "
    CSQL += "       d2_Local    as Loc, "
    CSQL += "       d2_quant    as Quant, "
    CSQL += "       d2_Emissao  as DataMov, "
    CSQL += "       d2_doc      as Numero, "
    CSQL += "       d2_serie    as Serie, "
    CSQL += "       d2_cf       as CFOP, "
    CSQL += "       0           as BaseICM, "
    CSQL += "       0           as BRICMS, "
    CSQL += "       d2_nfori    as NFOri, "
    CSQL += "       d2_seriori  as SerieOri, "
    CSQL += "       d2_ItemOri  as ItemOri, "
    CSQL += "       d2_total    as Total, "
    CSQL += "       a2_cgc      as Cnpj, "
    CSQL += "       a2_inscr    as InscrEst, "
    CSQL += "       a2_Tipo     as Pessoa, "
    CSQL += "       ' '         as Tipo, "
    CSQL += "       a2_conta    as Conta, "
    CSQL += "       a2_ultcom   as UltCom, "
    CSQL += "       a2_InscrM   as InscrMun, "
    CSQL += "       a2_Nome     as Nome, "
    CSQL += "       a2_End      as Endereco, "
    CSQL += "       a2_Mun      as Municipio, "
    CSQL += "       a2_Est      as UF, "
    CSQL += "       a2_Pais     as Pais, "
    CSQL += "       a2_CEP      as CEP "
    CSQL += "  from SD2010 sd2 "
    CSQL += "  join SA2010 sa2 "
    CSQL += "       on sa2.D_E_L_E_T_ = ' ' " 
    CSQL += "   and sa2.a2_filial  = '  ' " 
    CSQL += "   and sa2.A2_COD     = sd2.D2_CLIENTE" 
    CSQL += "   and sa2.A2_LOJA    = sd2.D2_LOJA " 
    CSQL += "  join SB1010 sb1 " 
    CSQL += "    on sb1.D_E_L_E_T_ = ' ' " 
    CSQL += "   and sb1.b1_filial  = '  ' " 
    CSQL += "   and sb1.b1_cod     = sd2.d2_cod " 
    CSQL += "   and sb1.b1_grtrib  = '001' " 
    CSQL += " where sd2.D_E_L_E_T_ = ' '" 
    CSQL += "   and sd2.d2_filial  > '  '" 
    CSQL += "   and sd2.d2_EMISSAO >= '" + DTOS(mv_par01) + "' "
    CSQL += "   and sd2.d2_EMISSAO <= '" + DTOS(mv_par02) + "' "
    CSQL += " union "
    CSQL += "select 'S' 		as NF, " 
    CSQL += "        d2_filial  as Filial, " 
    CSQL += "        d2_CLIENTE as Emitente, " 
    CSQL += "        d2_loja    as Loja, " 
    CSQL += "        d2_cod     as Cod, " 
    CSQL += "        d2_Item    as Item, " 
    CSQL += "        d2_Local   as Loc, " 
    CSQL += "        d2_quant   as Quant, " 
    CSQL += "        d2_EMISSAO as DataMov, " 
    CSQL += "        d2_doc     as Numero, " 
    CSQL += "        d2_serie   as Serie, " 
    CSQL += "        d2_cf      as CFOP, " 
    CSQL += "        0          as BaseICM, " 
    CSQL += "        0          as BRICMS, " 
    CSQL += "        d2_nfori   as NFOri, " 
    CSQL += "        d2_seriori as SerieOri, " 
    CSQL += "        d2_ItemOri as ItemOri, " 
    CSQL += "        d2_total   as Total, " 
    CSQL += "        a1_cgc     as Cnpj, " 
    CSQL += "        a1_inscr   as InscrEst, " 
    CSQL += "        a1_pessoa  as Pessoa, " 
    CSQL += "        a1_tipo    as Tipo, " 
    CSQL += "        a1_conta   as Conta, " 
    CSQL += "        a1_ultcom  as UltCom, " 
    CSQL += "        a1_InscrM  as InscrMun, " 
    CSQL += "        a1_Nome    as Nome, " 
    CSQL += "        a1_End     as Endereco, " 
    CSQL += "        a1_Mun     as Municipio, " 
    CSQL += "        a1_Est     as UF, " 
    CSQL += "        a1_Pais    as Pais, " 
    CSQL += "        a1_CEP     as CEP " 
    CSQL += "   from SD2010 sd2 " 
    CSQL += "   join SA1010 sa1  " 
    CSQL += "     on sa1.D_E_L_E_T_ = ' ' " 
    CSQL += "    and sa1.a1_filial  = '  '  " 
    CSQL += "    and sa1.A1_COD     = sd2.D2_Cliente  " 
    CSQL += "    and sa1.A1_LOJA    = sd2.D2_LOJA " 
    CSQL += "   join SB1010 sb1 " 
    CSQL += "     on sb1.D_E_L_E_T_ = ' ' " 
    CSQL += "    and sb1.b1_filial  = '  ' " 
    CSQL += "    and sb1.b1_cod     = sd2.d2_cod " 
    CSQL += "    and sb1.b1_grtrib  = '001' " 
    CSQL += " where sd2.D_E_L_E_T_ = ' '"  
    CSQL += "   and sd2.d2_filial  > '  '" 
    CSQL += "   and sd2.d2_emissao >= '" + DTOS(mv_par01) + "' "
    CSQL += "   and sd2.d2_emissao <= '" + DTOS(mv_par02) + "' "
    CSQL += " order by filial, emitente, loja, DataMov, Numero , Item "
    
    MsgRun("Consultado Base de Dados Della Via",,{|| cSql := ChangeQuery(cSql)})
    MsgRun("Consultado Base de Dados Della Via",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})
   
    TcSetField("ARQ_SQL","QUANT"  ,"N",14,2)
    TcSetField("ARQ_SQL","BASEICM","N",14,2)
    TcSetField("ARQ_SQL","BRICMS" ,"N",14,2)
    TcSetField("ARQ_SQL","TOTAL"  ,"N",14,2)             
    TcSetField("ARQ_SQL","Emissao","D",)             
   
    dbSelectArea("ARQ_SQL")
    ProcRegua(0)
    vCod 	:= ""
    vSc  	:= "|"
     
	DoCabec()
   
    Do While !eof()             
   		
   		IncProc("Imprimindo ...")
	   	if lAbortPrint
			LI+=3
		   	@ LI,001 PSAY "*** Cancelado pelo Operador ***"
		   	lImp := .F.
		    return
	  	Endif
	  		
	    @Li, 000      psay Arq_Sql->NF 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Filial 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Emitente 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Loja 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Cod 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Item 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Loc 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Quant picture "@E 9,99,999,999"
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->DataMov 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Numero 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Serie 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Cfop 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->BaseIcm picture "@E 9,99,999,999.99"
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->BRIcms picture "@E 9,99,999,999.99"
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->NFOri 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->SerieOri 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->ItemOri 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Total picture "@E 9,99,999,999.99"
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->CNPJ 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->InscrEst 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Pessoa 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Tipo 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Conta 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Ultcom 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->InscrMun 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Nome 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Endereco 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Municipio 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->UF 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->Pais 
		@Li, pcol()+1 psay vSc 
    	@Li, pcol()+1 psay Arq_Sql->CEP
    	Li ++		
		dbSkip()
		
	Enddo
	

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

