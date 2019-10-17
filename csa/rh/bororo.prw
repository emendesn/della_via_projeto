    if upper(mv_par14) = "S"
    //	                     1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16             
    //             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
    	Cabec1 := "FL|CODIGO|DESCRICAO                     |GRUP|LA|DT.SALD.|      QUANT.SALDO|      VALOR SALDO|QUANT.SAIDA|      CUSTO SAIDA|   VALOR SAIDA|SALDO ATUAL|      VALOR ATUAL"             
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
    
	CSQL := "SELECT SB9.B9_FILIAL,"
    CSQL += "       SB9.B9_COD,"
    CSQL += "       SBM.BM_DESC,"
    CSQL += "       SB1.B1_GRUPO,"
    CSQL += "       SB1.B1_DESC,"
    CSQL += "       SB9.B9_DATA,"
    CSQL += "       SB9.B9_LOCAL,"
    CSQL += "       SB9.B9_QINI,"
    CSQL += "       SB9.B9_VINI1,"
    CSQL += "       SD2.D2_EMISSAO,"
    CSQL += "       SD2.D2_DOC,"
    CSQL += "       SD2.D2_QUANT,"
    CSQL += "       SD2.D2_CUSTO1,"
    CSQL += "       SD2.D2_TOTAL,"         
    CSQL += "       SD2.D2_CF,"      
    CSQL += "       SB2.B2_QATU,SB2.B2_VATU1,"         
    CSQL += "       NFS.D2_EMISSAO AS NF_EMISSAO,"
    CSQL += "       NFS.D2_DOC     AS NF_DOC,"
    CSQL += "       NFS.D2_QUANT   AS NF_QUANT,"
    CSQL += "       NFS.D2_CUSTO1  AS NF_CUSTO1,"
    CSQL += "       NFS.D2_TOTAL   AS NF_TOTAL,"         
    CSQL += "       NFS.D2_CF      AS NF_CF"      
    CSQL += "  FROM SB9010 SB9" 
    CSQL += "  JOIN SB1010 SB1"
    CSQL += "    ON SB1.D_E_L_E_T_  = ' '" 
	CSQL += "   AND SB1.B1_COD      = SB9.B9_COD" 
    CSQL := "   AND SB1.B1_GRUPO   >= '" + mv_par01       + "'" 
    CSQL := "   AND SB1.B1_GRUPO   <= '" + mv_par02       + "'"
	CSQL += "  LEFT JOIN SBM010 SBM"
	CSQL += "    ON SB1.B1_GRUPO    = SBM.BM_GRUPO" 
	CSQL += "   AND SBM.D_E_L_E_T_  = ' '" 
	CSQL += "  LEFT JOIN SD2010 SD2"
	CSQL += "    ON SD2.D_E_L_E_T_  = ' '" 
	CSQL += "   AND SD2.D2_FILIAL   = SB9.B9_FILIAL" 
	CSQL += "   AND SD2.D2_COD      = SB9.B9_COD" 
    CSQL := "   AND SD2.D2_EMISSAO >= '" + dtos(mv_par03) + "'"
    CSQL := "   AND SD2.D2_EMISSAO <= '" + dtos(mv_par04) + "'"
     
	CSQL += "   AND SD2.D2_CLIENTE <> '15LQFY' 
	CSQL += "  LEFT JOIN SB2010 SB2
	CSQL += "    ON SB9.B9_FILIAL   = SB2.B2_FILIAL 
	CSQL += "   AND SB9.B9_LOCAL    = SB2.B2_LOCAL 
	CSQL += "   AND SB9.B9_COD      = SB2.B2_COD 
	CSQL += "   AND SB2.D_E_L_E_T_  = ' ' 
	CSQL += "  LEFT JOIN SD2010 NFS ON SD2.D_E_L_E_T_ = ' ' 
	CSQL += "   AND NFS.D2_FILIAL   = SB9.B9_FILIAL 
	CSQL += "   AND NFS.D2_COD      = SB9.B9_COD
	cSql += "   and nfs.d2_emissao >= '" + str(year(date()),4) + iif(month(date())<10,"0","") + alltrim(str(month(date()),2)) + "01' "
    cSql += "   and nfs.d2_emissao <= '" + dtos(date()-1) + "' "
    CSQL += "   AND NFS.D2_CLIENTE <> '15LQFY' 
	cSql	+= " where sb9.B9_FILIAL  >= '"  + mv_par07       + "' "
	cSql    += "   and sb9.B9_FILIAL  <= '"  + mv_par08       + "' "
	CSQL += "   AND SB9.D_E_L_E_T_  = ' ' 
    cSql	+= "   and sb9.b9_local   >= '"  + mv_par09       + "' "
    cSql    += "   and sb9.b9_local   <= '"  + mv_par10       + "' " 
    CSQL += "   AND SB9.B9_LOCAL   >= '01' 
    CSQL += "   AND SB9.B9_LOCAL   <= '99' 
    CSQL += "   AND SB9.B9_DATA     = '20060731' 
	CSQL += " ORDER BY B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA"

//    cSql	+= "  left join sf4010 sf4 "
//    cSql	+= "    on sd2.d2_tes     = sf4.f4_codigo "
//    cSql	+= "   and sf4.D_E_L_E_T_ = ' ' "
//    cSql 	+= "   and sf4.f4_codigo  >= '" + mv_par05       + "' "
//    cSql    += "   and sf4.f4_codigo  <= '" + mv_par06       + "' "
