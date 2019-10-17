
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR13 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR13   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	
	Private cString        := "SB9"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "G"
	Private nomeprog       := "DGOLR13"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL13"
	Private titulo         := "Pesq. SB9-SD2 Grupo de Produtos"
	Private Li             := 99
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR13"
	Private lImp           := .F.
    Private Cab1           := ""
 	Private Cab2           := ""
    Private Cab3           := ""   
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

	aAdd(aRegs,{cPerg,"01","Grupo..........de?"," "," ","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""          })
    aAdd(aRegs,{cPerg,"02","Grupo.........até?"," "," ","mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""          })
    aAdd(aRegs,{cPerg,"03","Emissâo NFS....de?"," "," ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"04","Emissão NFS...até?"," "," ","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"05","Tes............de?"," "," ","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SF4","","","",""          })
    aAdd(aRegs,{cPerg,"06","Tes...........até?"," "," ","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SF4","","","",""          })
    aAdd(aRegs,{cPerg,"07","Filial.........de?"," "," ","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"08","Filial........até?"," "," ","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"09","Local-Armazém..de?"," "," ","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"10","Local-Armazém.até?"," "," ","mv_chA","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"11","Data Saldo.....de?"," "," ","mv_ch9","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"12","Data Saldo....até?"," "," ","mv_chA","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"13","Tipo Relat..A/S/T?"," "," ","mv_chB","C",01,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    aAdd(aRegs,{cPerg,"14","Exporta Excel S/N?"," "," ","mv_chC","C",01,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   
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
    
    if upper(mv_par14) = "S"
    //	                     1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16             
    //             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
    	Cabec1 := "GRUP|CODIGO|DESCRICAO                           |FL|DT.SALD.|      QUANT.SALDO|      VALOR SALDO|QUANT.SAIDA|      CUSTO SAIDA|   VALOR SAIDA|SALDO ATUAL|      VALOR ATUAL"             
     	Cabec2 := ""
    	Cabec3 := "" 
    	LI     := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.) 
    	LI     += 2    
    	Cabec1 := ""
    else
    	Cabec1  := "GRUPO de:"       + mv_par01 + " até:" + mv_par02 + space(5)
        Cabec1  += "Emissão nfs de:" + dtoc(mv_par03) + " até:" + dtoc(mv_par04) + space(5)
        Cabec1  += "Tes de:"         + mv_par05 + " até:" + mv_par06 + space(5)
        Cabec1  += "Filial de:"      + mv_par07 + " até:" + mv_par08 + space(5)
        Cabec1  += "Local de:"       + mv_par09 + " até:" + mv_par10 + space(5)
        Cabec1  += "Data Saldo de:"  + dtoc(mv_par11) + " até:" + dtoc(mv_par12)
        Cabec2  := "FL CODIGO DESCRICAO                      GRUP LA DT.SALD.       QUANT.SALDO       VALOR SALDO QUANT.SAIDA       CUSTO SAIDA    VALOR SAIDA SALDO ATUAL       VALOR ATUAL"             
    endif
    cSql    := "SELECT sb1.B1_GRUPO,BM_DESC,SB9.B9_FILIAL,SB9.B9_COD,B1_DESC,SB9.B9_DATA,SB9.B9_LOCAL,SB9.B9_QINI,SB9.B9_VINI1,D2_EMISSAO,D2_DOC,D2_QUANT, D2_CUSTO1, D2_TOTAL,sb2.b2_qatu,sb2.b2_vatu1 "
    cSql    += "  from SB9010 SB9"
	cSql	+= "  join SB1010 SB1"
    cSql	+= "    on SB1.D_E_L_E_T_ = ' ' "
    cSql	+= "   and SB1.B1_COD     = SB9.B9_COD "
    cSql	+= "   and SB1.B1_GRUPO   >= '" + mv_par01       + "' "
    cSql    += "   and SB1.B1_GRUPO   <= '" + mv_par02       + "' "
	cSql	+= "  left join SBM010 SBM"  
    cSql	+= "    on SB1.B1_GRUPO   = SBM.BM_GRUPO"
    cSql    += "   and SBM.D_E_L_E_T_ = ' '"
	cSql	+= "  left join sd2010 sd2"
    cSql	+= "    on sd2.D_E_L_E_T_ = ' '"
    cSql	+= "   and sd2.d2_filial  = sb9.b9_filial"
    cSql	+= "   and sd2.d2_cod     = sb9.b9_cod"
    cSql	+= "   and sd2.d2_emissao >= '" + dtos(mv_par03) + "' "
    cSql    += "   and sd2.d2_emissao <= '" + dtos(mv_par04) + "' "
    cSql    += "   and sd2.d2_cliente <> '15LQFY' "
	cSql	+= "  left join sf4010 sf4 "
    cSql	+= "    on sd2.d2_tes     = sf4.f4_codigo "
    cSql	+= "   and sf4.D_E_L_E_T_ = ' ' "
    cSql 	+= "   and sf4.f4_codigo  >= '" + mv_par05       + "' "
    cSql    += "   and sf4.f4_codigo  <= '" + mv_par06       + "' "
	cSql	+= "  left join sb2010 SB2 "
    cSql	+= "    on sb9.b9_filial  = sb2.b2_filial "
    cSql	+= "   and sb9.b9_local   = sb2.b2_local "
    cSql    += "   and sb9.b9_cod     = sb2.b2_cod "
    cSql 	+= "   and sb2.D_E_L_E_T_ = ' ' "     
	cSql	+= "  where sb9.B9_FILIAL  >= '"  + mv_par07       + "' "
	cSql    += "   and sb9.B9_FILIAL  <= '"  + mv_par08       + "' "
	cSql	+= "   and sb9.D_E_L_E_T_ = ' ' "
    cSql	+= "   and sb9.b9_local   >= '"  + mv_par09       + "' "
    cSql    += "   and sb9.b9_local   <= '"  + mv_par10       + "' " 
  
    if	mv_par14 = "G"
		cSql	+= "  and sb9.b9_data >= '"  + dtos(mv_par11) + "' "
		cSql    += "  and sb9.b9_data <= '"  + dtos(mv_par12) + "' " 
	else                                                                                                         
		cSql    += "  and sb9.b9_data = '"   + dtos(mv_par11) + "' "
	endif 
  
	cSql	+= "    order by b1_grupo,b9_cod,b9_local,b9_filial,b9_data " 
	
	MsgRun("Consultando Banco de dados ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})

	TcSetField("ARQ_SQL","b9_data   ","D")
	TcSetField("ARQ_SQL","d2_emissao","D")
	TcSetField("ARQ_SQL","B9_QINI"   ,"N",14,2)
	TcSetField("ARQ_SQL","B9_VINI1"  ,"N",14,2)
	TcSetField("ARQ_SQL","D2_QUANT"  ,"N",14,2)
	TcSetField("ARQ_SQL","D2_CUSTO1" ,"N",14,2)
	TcSetField("ARQ_SQL","D2_TOTAL"  ,"N",14,2)
	TcSetField("ARQ_SQL","B2_QATU"   ,"N",14,2)
	TcSetField("ARQ_SQL","B2_VATU1"  ,"N",14,2) 
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
    vFil := ""
    vGru := ""
    vCod := ""
    vLoc := ""  
    vSc  := iif(upper(mv_par13) = "S","|"," ")
    vc01 := 000 // GRUPO
    vs02 := 004 
    vc02 := 005 // CODIGO 
    vs03 := 009
    vc03 := 011 // DESCRICAO
    vs04 := 048
    vc04 := 049 // FILIAL
    vs05 := 000 // NOP
    vc05 := 000 // NOP 
    vs06 := 051
    vc06 := 052 // DT.SALD.
    vs07 := 057
    vc07 := 064 // QUANT.SALDO
    vs08 := 075
    vc08 := 079 // VALOR SALDO
    vs09 := 093
    vc09 := 094 // QUANT.SAIDA
    vs10 := 105
    vc10 := 109 // CUSTO SAIDA
    vs11 := 123
    vc11 := 124 // VALOR SAIDA
    vs12 := 138
    vc12 := 139 // SALDO ATUAL
    vs13 := 150
    vc13 := 154 // VALOR ATUAL 
    avTot := {}
    aAdd(avTot,{0,0,0,0,0,0,0})
    aAdd(avTot,{0,0,0,0,0,0,0})
    aAdd(avTot,{0,0,0,0,0,0,0})
    aAdd(avTot,{0,0,0,0,0,0,0})
    
    Do While !eof()              
	
		IncProc("Imprimindo ...")
	   	if lAbortPrint
			LI+=3
		   	@ LI,001 PSAY "*** Cancelado pelo Operador ***"
		   	lImp := .F.
		   	return
	   	Endif
	  
	   	if vGru # Arq_Sql->B1_Grupo
	   		if vGru # ""
	   			vTot := 1   // Total Filial
	   	   		DoLinha()
	   	   		vTot := 2   // Total Produto
	   	   		DoLinha()
	   	   		vTot := 3   // Total Grupo
	   	   		DoLinha()
	   	    endif
	   	    vGru 	   := Arq_Sql->B1_Grupo
		    vCod       := Arq_Sql->B9_Cod
		    vLoc       := Arq_Sql->B9_Local
		    vFil 	   := Arq_Sql->B9_Filial
		    v_desc	   := Arq_Sql->B1_Desc
		    v_data	   := Arq_Sql->B9_Data 
		    avTot[1,1] := Arq_Sql->B9_Qini
		    avTot[1,2] := Arq_Sql->B9_Vini1
		    avTot[1,3] := 0
		    avTot[1,4] := 0
		    avTot[1,5] := 0 	 
		    avTot[1,6] := iif(empty(Arq_Sql->B2_Qatu ),0,Arq_Sql->B2_Qatu )
		    avTot[1,7] := iif(empty(Arq_Sql->B2_Vatu1),0,Arq_Sql->B2_Vatu1)
		endif
		if vCod # Arq_Sql->B9_Cod
			vTot := 1   
	   	   	DoLinha()    // Total Filial
	   	   	vTot := 2   
	   	   	DoLinha()    // Total Produto
  		    vCod    	:= Arq_Sql->B9_Cod
		    vLoc    	:= Arq_Sql->B9_Local
		    v_desc		:= Arq_Sql->B1_Desc
		    v_data		:= Arq_Sql->B9_Data 
		    avTot[1,1] 	:= Arq_Sql->B9_Qini
		    avTot[1,2] 	:= Arq_Sql->B9_Vini1
		    avTot[1,3] 	:= 0
		    avTot[1,4] 	:= 0
		    avTot[1,5] 	:= 0 	 
		    avTot[1,6] 	:= iif(empty(Arq_Sql->B2_Qatu ),0,Arq_Sql->B2_Qatu )
		    avTot[1,7] 	:= iif(empty(Arq_Sql->B2_Vatu1),0,Arq_Sql->B2_Vatu1)
		endif
		if vFil # Arq_Sql->B9_Filial
		    vTot := 1   
	   	   	DoLinha()  // Total Filial
			vFil       := Arq_Sql->B9_Filial
		    v_desc	   := Arq_Sql->B1_Desc
		    v_data     := Arq_Sql->B9_Data 
		    avTot[1,1] := Arq_Sql->B9_Qini
		    avTot[1,2] := Arq_Sql->B9_Vini1
		    avTot[1,3] := 0
		    avTot[1,4] := 0
		    avTot[1,5] := 0 	 
		    avTot[1,6] := iif(empty(Arq_Sql->B2_Qatu ),0,Arq_Sql->B2_Qatu )
		    avTot[1,7] := iif(empty(Arq_Sql->B2_Vatu1),0,Arq_Sql->B2_Vatu1)
		endif
		if !empty(Arq_Sql->D2_Doc)
			avTot[1,3] := avTot[1,3] + Arq_Sql->D2_Quant
			avTot[1,4] := avTot[1,4] + Arq_Sql->D2_Custo1
			avTot[1,5] := avTot[1,5] + Arq_Sql->D2_Total
		endif
		dbSkip()
		
	Enddo
	vTot := 1   // Total Grupo
	DoLinha()
	vTot := 2   // Total Produto
	DoLinha()
	vTot := 3   // Total Filial
	DoLinha()
 	vTot := 4   // Total Geral
 	DoLinha()
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
   	if Li>55 .and. upper(mv_par14) # "S"
    	LI := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.) 
    	LI += 2   
   	endif 

Return 

Static Function DoLinha

	if upper(mv_par13) = "A" .or.vTot > 1
		DoCabec()
		@Li, vc01 psay vGru
		@Li, vS02 psay vSc
		Do Case
			Case vTot = 1
				@Li, vc02 psay subst(vCod,1,6)
				@Li, vS03 psay vSc
				@Li, vc03 psay v_desc 
			Case vTot = 2 
				@Li, vS03 psay vSc
				@Li, vc03 psay "Total Grupo Loja:"+vFil
			Case vTot = 3
				@Li, vS03 psay vSc
				@Li, vc03 psay "Total Geral Loja:"+vFil
			Case vTot = 4
				@Li, vS03 psay vSc
				@Li, vc03 psay "Total Geral Della Via"
		Endcase
		@Li, vS04 psay vSc
		if vTot < 3
			@Li, vc04 psay vGru
		endif
		@Li, vS05 psay vSc
		if vTot = 1
			@Li, vc05 psay vLoc
		endif
		@Li, vS06 psay vSc      
		@Li, vc06 psay v_data
		@Li, vS07 psay vSc
		@Li, vc07 psay avTot[vTot,1] picture "@E 999,999,999"
		@Li, vS08 psay vSc
		@Li, vc08 psay avTot[vTot,2] picture "@E 999,999,999.99" 
		if vLoc = "01" .or. VTot > 1
		    @Li, vS09 psay vSc
			@Li, vc09 psay avTot[vTot,3] picture "@E 999,999,999"
			@Li, vS10 psay vSc
			@Li, vc10 psay avTot[vTot,4] picture "@E 999,999,999.99"
			@Li, vS11 psay vSc
			@Li, vc11 psay avTot[vTot,5] picture "@E 999,999,999.99"
		else
			@Li, vS09 psay vSc
			@Li, vS10 psay vSc
			@Li, vS11 psay vSc  
		endif
		@Li, vS12 psay vSc
		@Li, vc12 psay avTot[vTot,6] picture "@E 999,999,999"
		@Li, vS13 psay vSc
		@Li, vc13 psay avTot[vTot,7] picture "@E 999,999,999.99"	
	endif
	if vTot < 4
		for i = 1 to 7
			avTot[vTot+1,i] := avTot[vTot+1,i] + avTot[vTot,i]
			avTot[vTot  ,i] := 0
		next
	endif 	
Return nil
   
