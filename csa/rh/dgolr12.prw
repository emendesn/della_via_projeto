
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR12 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR12   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
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
	Private nomeprog       := "DGOLR12"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL12"
	Private titulo         := "Analise Consumo Medio Vendas"
	Private Li             := 99
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR12"
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
   	aAdd(aRegs,{cPerg,"05","Tabela de Preço  ?"," "," ","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"06","Cfop....9999,9999?"," "," ","mv_ch6","C",50,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"07","Filial.........de?"," "," ","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"08","Filial........até?"," "," ","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"09","Local-Armazém..de?"," "," ","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"10","Local-Armazém.até?"," "," ","mv_chA","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"11","Data Saldo.......?"," "," ","mv_chB","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"12","Produto..........?"," "," ","mv_chC","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""          })
   	aAdd(aRegs,{cPerg,"13","Tipo Relat....A/S?"," "," ","mv_chD","C",01,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
   	aAdd(aRegs,{cPerg,"14","Exporta Excel S/N?"," "," ","mv_chE","C",01,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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

	if upper(mv_par14) = "S"    // Excel = "S"
   		Cabec1 := "FL]Codigo]LA]Descricao do Produto..........]Grup]  Data  ]Sd Est An]    Vl Est An]  Cons An]  Custo Medio]  Vlr NFiscal]MBruta]DEst]Sd Est At]    Vl Est At]  Cons At]  Custo Medio]  Vlr NFiscal]MBruta]DEst]*]PRECO TAB" 
   		LI     := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)                                       
   		LI     += 2    
   		Cabec1 := ""   	
   	else                                                                                                  
    	Cabec1  := "GRUPO de:"       + mv_par01       + " até:" + mv_par02       + space(5)
      	Cabec1  += "Emissão nfs de:" + dtoc(mv_par03) + " até:" + dtoc(mv_par04) + space(5)
      	Cabec1  += "Filial de:"      + mv_par07       + " até:" + mv_par08       + space(5)
      	Cabec1  += "Local de:"       + mv_par09       + " até:" + mv_par10       + space(5)
      	Cabec1  += "Data Saldo de:"  + dtoc(mv_par11) 
     	Cabec2  := "|FL|Codigo|LA|Descricao do Produto..........|Grup|  Data  |Sd Est An|    Vl Est An|  Cons An|  Custo Medio|  Vlr NFiscal|MBruta|DEst|Sd Est At|    Vl Est At|  Cons At|  Custo Medio|  Vlr NFiscal|MBruta|DEst|*|Preco Tab"  
	endif
	if !empty(mv_par05)
    	mv_par05 := alltrim(mv_par05) 
    	vpar05   := "('"
    	virg     := at("," , mv_par05)	
   		do while virg > 0
			vpar05   := vpar05 + subs(mv_par05,1,virg-1) + "','"
       		mv_par05 := subs(mv_par05,virg+1,len(mv_par05)-virg)
       		virg     := at("," , mv_par05)
    	enddo
    	vpar05 := vpar05 + mv_par05 + "')"
   endif   
   if !empty(mv_par06)
    	mv_par06 := alltrim(mv_par06) 
    	vpar06   := "('"
    	virg     := at("," , mv_par06)	
    	do while virg > 0
	   		vpar06   := vpar06 + subs(mv_par06,1,virg-1) + "','"
       		mv_par06 := subs(mv_par06,virg+1,len(mv_par06)-virg)
       		virg = at("," , mv_par06)
    	enddo
    	vpar06 := vpar06 + mv_par06 + "')"
   endif

    
   CSQL := "SELECT SB9.B9_FILIAL, "
   CSQL += "       SB9.B9_COD, "
   CSQL += "       SBM.BM_DESC, "
   CSQL += "       SB1.B1_GRUPO, "
   CSQL += "       SB1.B1_DESC, " 
   CSQL += "       DA1.DA1_PRCVEN, "
   CSQL += "       SB9.B9_DATA, "
   CSQL += "       SB9.B9_LOCAL, "
   CSQL += "       SB9.B9_QINI, "
   CSQL += "       SB9.B9_VINI1, "
   CSQL += "       SB2.B2_QATU,SB2.B2_VATU1 "         
   CSQL += "  FROM SB9010 SB9 " 
   CSQL += "  JOIN SB1010 SB1 "
   CSQL += "    ON SB1.D_E_L_E_T_  = ' ' " 
   CSQL += "   AND SB1.B1_COD      = SB9.B9_COD " 
   CSQL += "   AND SB1.B1_GRUPO   >= '" + mv_par01       + "' " 
   CSQL += "   AND SB1.B1_GRUPO   <= '" + mv_par02       + "' " 
   CSQL += "   AND SB1.B1_TIPO     = 'ME' "
   CSQL += "  JOIN SBM010 SBM"
   CSQL += "    ON SB1.B1_GRUPO    = SBM.BM_GRUPO" 
   CSQL += "   AND SBM.D_E_L_E_T_  = ' '"
   CSQL += "  JOIN SB2010 SB2"
   CSQL += "    ON SB9.B9_FILIAL   = SB2.B2_FILIAL " 
   CSQL += "   AND SB9.B9_LOCAL    = SB2.B2_LOCAL " 
   CSQL += "   AND SB9.B9_COD      = SB2.B2_COD " 
   CSQL += "   AND SB2.D_E_L_E_T_  = ' ' "   	
   CSQL += "  LEFT JOIN DA1010 DA1"
   CSQL += "    ON DA1.D_E_L_E_T_  = ' '"
   CSQL += "   AND DA1.DA1_FILIAL  = '  '"
   CSQL += "   AND DA1.DA1_CODTAB  = '" + mv_par05       + "' "
   CSQL += "   AND DA1.DA1_CODPRO  = SB1.B1_COD "
   cSqL += " where sb9.B9_FILIAL  >= '"  + mv_par07       + "' "
   cSql += "   and sb9.B9_FILIAL  <= '"  + mv_par08       + "' "
   CSQL += "   AND SB9.D_E_L_E_T_  = ' '" 
   cSql += "   and sb9.b9_local   >= '"  + mv_par09       + "' "
   cSql += "   and sb9.b9_local   <= '"  + mv_par10       + "' " 
   CSQL += "   AND SB9.B9_DATA     = '"  + DTOS(mv_par11) + "' "
   if !empty(mv_par12)
   		CSQL += " AND SB9.B9_COD = '" + mv_par12 + "' "
   endif 
   CSQL += " ORDER BY SB9.B9_FILIAL,SB1.B1_GRUPO,SB9.B9_COD,SB9.B9_LOCAL "
   
   MsgRun("Consultado Base de Dados Della Via",,{|| cSql := ChangeQuery(cSql)})
   MsgRun("Consultado Base de Dados Della Via",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})
   
   TcSetField("ARQ_SQL","B9_DATA   ","D")
   TcSetField("ARQ_SQL","B9_QINI"   ,"N",14,2)
   TcSetField("ARQ_SQL","B9_VINI1"  ,"N",14,2)
   TcSetField("ARQ_SQL","B2_QATU"   ,"N",14,2)
   TcSetField("ARQ_SQL","B2_VATU1"  ,"N",14,2)             
   TcSetField("ARQ_SQL","DA1_PRCVEN","N",14,2)             
   
   dbSelectArea("ARQ_SQL")
   ProcRegua(0)
   vFil 	:= ""
   vGru 	:= ""
   vCod 	:= ""
   vLoc 	:= ""  
   v_desc 	:= ""
   v_GruDesc:= ""
   v_Data	:= ""
   vSc  	:= "|"

   vs01    	:= 000
   vc01 	:= 001 // FL 

   vs02 	:= 003 
   vc02 	:= 004 // CODIGO
                   
   vs03 	:= 010
   vc03 	:= 011 // LA
    
   vs04 	:= 013
   vc04 	:= 014 // Descricao do Produto
    
   vs05 	:= 044
   vc05 	:= 045 // Grupo
    
   vs06 	:= 049
   vc06 	:= 050 // Dt.Fech.
   
   vs07		:= 058
   vc07 	:= 059 // avTot[ 1] Qt.Sald.Fech
      
   vs08 	:= 068
   vc08 	:= 069 // avTot[ 2] Val.Saldo Fec.
    
   vs09 	:= 082
   vc09 	:= 083 // avTot[ 3] Qtde.Vendida F.
    
   vs10 	:= 092
   vc10 	:= 093 // avTot[ 4] Qtd.Vend.F.
    
   vs11 	:= 106
   vc11 	:= 107 // avTot[ 5] Venda Bru.Fech
    
   vs12 	:= 120
   vc12 	:= 121 // M.M.B
    
   vs13    	:= 127
   vc13    	:= 128 // Dias Est.Fech 
    
   vs14 	:= 132
   vc14 	:= 133 // avTot[ 6] Qt.Sald.Mês
    
   vs15		:= 142
   vc15		:= 143 // avTot[ 7] Vl.Sal.Mês C.
    
   vs16		:= 156
   vc16		:= 157 // avTot[ 8] Qt.Mês Corr
    
   vs17		:= 166
   vc17		:= 167 // avTot[ 9] CMV Mês Corr.
    
   vs18		:= 180
   vc18		:= 181 // avTot[10] Val.Bru.Mês 
    
   vs19		:= 194
   vc19		:= 195 // Dias Est.    
    
   vs20		:= 201
   vc20		:= 202  
    
   vs21		:= 206
   vc21		:= 207
    

   avTot 	:= {}
   aAdd(avTot,{0,0,0,0,0,0,0,0,0,0,0,0})
   aAdd(avTot,{0,0,0,0,0,0,0,0,0,0,0,0})
   aAdd(avTot,{0,0,0,0,0,0,0,0,0,0,0,0})
   aAdd(avTot,{0,0,0,0,0,0,0,0,0,0,0,0})
    
   Do While !eof()             
   		IncProc("Imprimindo ...")
	   	if lAbortPrint
			LI+=3
		   	@ LI,001 PSAY "*** Cancelado pelo Operador ***"
		   	lImp := .F.
		    return
	  	Endif
	  
	   if vFil # Arq_Sql->B9_Filial
	   		if vFil # ""
	   			vTot := 1   // Total Codigo+Armazém
	   	   		DoLinha()
	   	   		vTot := 2   // Total Grupo
	   	   		DoLinha()
	   	   		vTot := 3   // Total Filial
	   	   		DoLinha()
			endif
	   		vFil 	   	:= Arq_Sql->B9_Filial
	   		vGru 	   	:= Arq_Sql->B1_Grupo
		   	v_GruDesc  	:= Arq_Sql->BM_Desc
		   	v_DocAnt		:= ""
		   	v_ItemAnt	:= ""
		   	vCod        := Arq_Sql->B9_Cod
		   	vLoc        := Arq_Sql->B9_Local
		   	v_desc	    := Arq_Sql->B1_Desc
		   	v_data	    := Arq_Sql->B9_Data
		   	vPRCVEN     := Arq_Sql->DA1_PrcVen
		   	avTot[1,1]  := Arq_Sql->B9_Qini
		   	avTot[1,2]  := Arq_Sql->B9_Vini1
		   	avTot[1,3]  := 0
		   	avTot[1,4]  := 0
		   	avTot[1,5]  := 0 	 
		   	avTot[1,6]  := iif(empty(Arq_Sql->B2_Qatu ),0,Arq_Sql->B2_Qatu )
		   	avTot[1,7]  := iif(empty(Arq_Sql->B2_Vatu1),0,Arq_Sql->B2_Vatu1)
		   	avTot[1,8]  := 0
		   	avTot[1,9]  := 0
		   	avTot[1,10] := 0
		   	avTot[1,11] := 0
		   	avTot[1,12] := 0
		 endif
		if vGru # Arq_Sql->B1_Grupo
			vTot          := 1   
	        DoLinha()
	        vTot          := 2   
	        DoLinha()
            vGru 	      := Arq_Sql->B1_Grupo
            v_GruDesc     := Arq_Sql->BM_Desc 
		    v_DocAnt	   := ""
		    v_ItemAnt	   := ""
		    vCod          := Arq_Sql->B9_Cod
		    vLoc          := Arq_Sql->B9_Local
		    v_desc	      := Arq_Sql->B1_Desc
		    v_data	      := Arq_Sql->B9_Data   
		    vPRCVEN     := Arq_Sql->DA1_PrcVen
		    avTot[1,1]    := Arq_Sql->B9_Qini
		    avTot[1,2]    := Arq_Sql->B9_Vini1
		    avTot[1,3]    := 0
		    avTot[1,4]    := 0
		    avTot[1,5]    := 0 	 
		    avTot[1,6]    := iif(empty(Arq_Sql->B2_Qatu ),0,Arq_Sql->B2_Qatu )
		    avTot[1,7]    := iif(empty(Arq_Sql->B2_Vatu1),0,Arq_Sql->B2_Vatu1)
		    avTot[1,8]    := 0
		    avTot[1,9]    := 0
		    avTot[1,10]   := 0
		    avTot[1,11]   := 0
		   	avTot[1,12]   := 0
		endif
		if vCod+vLoc # Arq_Sql->B9_Cod+Arq_Sql->B9_Local
		    vTot 		   := 1   
	   	    DoLinha()
		    vCod       	:= Arq_Sql->B9_Cod
		    vLoc       	:= Arq_Sql->B9_Local
		    v_desc	   	:= Arq_Sql->B1_Desc
		    v_data     	:= Arq_Sql->B9_Data   
		    vPRCVEN     := Arq_Sql->DA1_PrcVen
		    avTot[1,1] 	:= Arq_Sql->B9_Qini
		    avTot[1,2] 	:= Arq_Sql->B9_Vini1
		    avTot[1,3] 	:= 0
		    avTot[1,4] 	:= 0
		    avTot[1,5] 	:= 0 	 
		    avTot[1,6] 	:= iif(empty(Arq_Sql->B2_Qatu ),0,Arq_Sql->B2_Qatu )
		    avTot[1,7] 	:= iif(empty(Arq_Sql->B2_Vatu1),0,Arq_Sql->B2_Vatu1)
		    avTot[1,8] 	:= 0
		    avTot[1,9] 	:= 0
		    avTot[1,10]	:= 0
		    avTot[1,11] := 0
		   	avTot[1,12] := 0
		endif
		if vLoc == "01"
			DSQL := "SELECT SUM(D2_QUANT)  AS MF_QUANT,"
			DSQL += "       SUM(D2_CUSTO1) AS MF_CUSTO1," 
			DSQL += "       SUM(D2_VALICM) AS MF_VALICM,"
			DSQL += "       SUM(D2_TOTAL)  AS MF_TOTAL"
			DSQL += "  FROM SD2010 NMF"
			DSQL += " WHERE D2_FILIAL      = '" + ARQ_SQL->B9_FILIAL + "'"
   			DSQL += "   AND D2_COD         = '" + ARQ_SQL->B9_COD    + "'"
   			DSQL += "   AND D2_LOCAL       = '01'"
   			DSQL += "   AND D2_EMISSAO >= '"    + dtos(mv_par03)     + "'"
   			DSQL += "   AND D2_EMISSAO <= '"    + dtos(mv_par04)     + "'"
			DSQL += "   AND D_E_L_E_T_  = ' '" 
   			if !empty(mv_par06)
    			DSQL   += "   AND D2_CF in "  + vpar06
   			endif
      		DSQL += " GROUP BY D2_COD"
   			DSQL += " ORDER BY D2_COD"  
   			dSql := ChangeQuery(dSql)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,dSql),"ARQ_NMF", .F., .T.)
	 		TcSetField("ARQ_NMF","MF_QUANT"  ,"N",14,2)
			TcSetField("ARQ_NMF","MF_CUSTO1" ,"N",14,2)
			TcSetField("ARQ_NMF","MF_VALICM" ,"N",14,2)
			TcSetField("ARQ_NMF","MF_TOTAL"  ,"N",14,2)
      		dbSelectArea("ARQ_NMF")
			if .not.eof()
				avTot[1,3] 	:= avTot[1,3]  + Arq_NMF->MF_Quant
				avTot[1,4] 	:= avTot[1,4]  + Arq_NMF->MF_Custo1
				avTot[1,5]	:= avTot[1,5]  + Arq_NMF->MF_Total
				avTot[1,11]	:= avTot[1,11] + Arq_NMF->MF_ValIcm
			endif
			dbCloseArea("ARQ_NMF")
		
			NSQL := "SELECT SUM(D2_QUANT)  AS NF_QUANT,"
			NSQL += "       SUM(D2_CUSTO1) AS NF_CUSTO1,"
			NSQL += "       SUM(D2_VALICM) AS NF_VALICM,"
			NSQL += "       SUM(D2_TOTAL)  AS NF_TOTAL"
   			NSQL += "  FROM SD2010 NFS"
   			NSQL += " WHERE D2_FILIAL   = '" + ARQ_SQL->B9_FILIAL  + "'"
   			NSQL += "   AND D2_COD      = '" + ARQ_SQL->B9_COD     + "'"
   			NSQL += "   AND D2_LOCAL    = '01'"
   			NSQL += "   AND D2_EMISSAO >= '" + str(year(date()),4) + iif(month(date())<10,"0","") + alltrim(str(month(date()),2)) + "01' "
   			NSQL += "   AND D2_EMISSAO <= '" + dtos(date())        + "' "
   			NSQL += "   AND D_E_L_E_T_ = ' '"
  			if !empty(mv_par06)
    			NSQL   += "   AND D2_CF in "  + vpar06
   			endif
   			NSQL += " GROUP BY D2_COD"
   			NSQL += " ORDER BY D2_COD" 
   	   		nSql := ChangeQuery(nSql)
   	   		dbUseArea(.T., "TOPCONN", TCGenQry(,,nSql),"ARQ_NFS", .F., .T.)
 			TcSetField("ARQ_NFS","NF_QUANT"  ,"N",14,2)
			TcSetField("ARQ_NFS","NF_CUSTO1" ,"N",14,2)
			TcSetField("ARQ_NFS","NF_VALICM" ,"N",14,2)
			TcSetField("ARQ_NFS","NF_TOTAL"  ,"N",14,2)
			dbSelectArea("ARQ_NFS")
			if .not.eof()
				avTot[1,8] 	:= avTot[1,8] + Arq_Nfs->NF_Quant
				avTot[1,9] 	:= avTot[1,9] + Arq_Nfs->NF_Custo1
				avTot[1,10]	:= avTot[1,10]+ Arq_Nfs->NF_Total
				avTot[1,12]	:= avTot[1,12]+ Arq_Nfs->NF_ValIcm
			endif
			dbCloseArea("ARQ_NFS")
		endif

		dbSelectArea("ARQ_SQL")
		dbSkip()
		
	Enddo
	vTot := 1   // Total Codigo+Armazém
	DoLinha()                                        
	vTot := 2   // Total Grupo
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
    	Li += 2
   	endif 

Return 

Static Function DoLinha

	if ((avTot[vTot,1] + avTot[vTot,3] + avTot[vTot,6] + avTot[vTot,8]) > 0) .and. (mv_par13 = "A"  .or. vTot > 1)
		DoCabec()
		@Li, vc01 psay vFil
		@Li, vS02 psay vSc
		Do Case
			Case vTot = 1
				@Li, vc02 psay subst(vCod,1,6)
				@Li, vS03 psay vSc
				@Li, vc03 psay vLoc
				@Li, vs04 psay vSc
				@Li, vc04 psay v_desc
			Case vTot = 2
			   	@Li, vS03 psay vSc
				@Li, vS04 psay vSc
				@Li, vc04 psay v_GruDesc
			Case vTot = 3
				@Li, vS03 psay vSc
				@Li, vs04 psay vSC                                            
				@Li, vc04 psay "TOTAL GERAL LOJA:"+vFil
			Case vTot = 4
				@Li, vS03 psay vSc
				@Li, vS04 psay vSc
				@Li, vc04 psay "TOTAL GERAL DELLA VIA"
		Endcase
		if vTot < 3
			@Li, vs05   psay vSc
			@Li, vc05 	psay vGru
		endif
		@Li, vS06 		psay vSc      
		@Li, vc06 		psay v_data
		@Li, vS07 		psay vSc
		@Li, vc07 		psay avTot[vTot,1] picture "@E 9,999,999"   // Qtd Fech 
		@Li, vS08 		psay vSc
		@Li, vc08 		psay avTot[vTot,2] picture "@E 99,999,999.99"   // Val Fech
		if vLoc = "01" .or. VTot > 1 	
			@Li, vS09 	psay vSc
			@Li, vc09 	psay avTot[vTot,3] picture "@E 9,999,999"   // Qtd Vend Fech
			@Li, vS10 	psay vSc
			@Li, vc10 	psay avTot[vTot,4] picture "@E 99,999,999.99"   // CMV Fech
			@Li, vS11 	psay vSc
			@Li, vc11 	psay avTot[vTot,5] picture "@E 99,999,999.99"   // Val Bruto Fech
			if avTot[vTot,4] > 0                                       
				@Li, vs12 	psay vSc
				vCalcMM := ((avTot[vTot,5] - avTot[vTot,11]) / avTot[vTot,4] - 1) * 100
			    @Li, vc12	psay vCalcMM picture "@E 999.99"           // MMB
			else
				@Li, vs12   psay vSc
			endif
			if avTot[vTot,3] > 0
				@Li, vs13  psay vSc
				vCalcDE := round(avTot[vTot,1] / avTot[vTot,3] * 30,0)
				@Li, vc13 psay vCalcDE picture "@E 9999"
			else
			    @Li, vs13  psay vSc
			endif
		else
			@Li, vS09 	psay vSc
			@Li, vS10 	psay vSc
			@Li, vS11 	psay vSc                          
			@Li, vS12   psay vSc 
			@Li, vS13   psay vSc
		endif
		@Li, vS14 		psay vSc
		@Li, vc14 		psay avTot[vTot,6]  picture "@E 9,999,999"     // Qtd Saldo Corr
		@Li, vs15  		psay vSc
		@Li, vc15 		psay avTot[vTot,7]  picture "@E 99,999,999.99" // Val Saldo Corr
		@Li, vs16		psay vSc                                       
		if vLoc = "01" .or. VTot > 1 	
			@Li, vc16	 	psay avTot[vTot,8]  picture "@E 9,999,999"     //Qtd Vend Mes Corr
			@Li, vs17		psay vSc
			@Li, vc17	 	psay avTot[vTot,9]  picture "@E 99,999,999.99" // Cust Vend Mes Corr
			@Li, vs18		psay vSc
			@Li, vc18       psay avTot[vTot,10] picture "@E 99,999,999.99" // Valor Bruto Mes Corr
			@Li, vs19		psay vSc
			if	avTot[vTot,8] > 0
				vCalcMM := ((avTot[vTot,10] - avTot[vTot,12]) / avTot[vTot,9] - 1) * 100
				@Li, vc19	psay vCalcMM picture "999.99"           
				vMediaDE := avTot[vTot,8] / day(date())
				vCalcDE  := avTot[vTot,6] / vMediaDE
				@Li, vs20  psay vSc 
		      	@Li, vc20	psay vCalcDE picture "9999"
   	   			@li, vs21  psay vSc
		    	if vCalcDE > 60
		    		@Li, vc21 psay "*|"
		    	else
		    		@Li, vc21 psay " |"
		    	endif                 
			else         
				@Li, vs20  psay vSc
			 	@Li, vs21  psay "| |"
			endif                     
			@Li,pcol()+1  psay vPRCVEN picture "@E 999999.99"
		endif   
	endif
	
	if vTot < 4
		for i = 1 to 11
			vProxTot          := vTot + 1              
			avTot[vProxTot,i] := avTot[vProxTot,i] + avTot[vTot,i]
			avTot[vTot  ,i]   := 0
		next
	endif 	

Return nil
   
