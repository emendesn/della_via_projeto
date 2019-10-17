#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR28 ()
    
	Local 	i				:= 0  
  	Local 	j				:= 0
  	Local 	ArqOut			:= ""       
  	Local 	vFilial			:= ""
  	Local 	vCod			:= ""
 	Local 	vDoc			:= ""
  	Local 	vCfop			:= ""
  	Local 	vTipo			:= ""
  	Local 	vQuant			:= 0
	Local 	vData			:= ""
	Private cPerg			:= "DGOL28"
	Private Titulo      	:= "Gera Arquivo Kardex"
	Private aSays       	:= {}
	Private aButtons    	:= {}
  	
  	cPerg    := PADR(cPerg,6)
	aRegs    := {}  
	aAdd(aRegs,{cPerg,"01","Da Data     "," "," ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate a Data  "," "," ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Da Filial   "," "," ","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate a Filial"," "," ","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
                           
	aAdd(aSays,"Esta rotina gera arquivo Kardex")
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| GKardex() },Titulo,,.t.) }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)


Static Function GKardex()
    
	Local cArq	:= ""
  	Local cDad := ""
	Local cCab := ""
  	for i = val(mv_par03) to val(mv_par04)
  		vFilial = strzero(i,2)
  		for j = 1 to 3
  			
        	dbSelectArea("ZX7")
  			If AbreExcl("ZX7")
  				zap
  			Endif
  			
  			aEstru := {}
			aadd(aEstru,{"ZX7_LINHA"    ,"C",255,0})
	
			cNomTmp := CriaTrab(aEstru,.t.)
			dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)	
	
  			cArq  := "\AIB\K" + vFilial + "A" + strzero(j,2) + ".##R" 
  			dbSelectArea("TMP")
        	appe from &cArq sdf
  			goto top           
  			
  			Do while .not.eof("TMP")
  				vLINHA := TMP->ZX7_LINHA
  				Do case
					case 'GRUPO :' $ vLINHA 
	  						vCod   := subs(vLINHA,1,6)
	  						vQuant := val(strtran(strtran(strtran(subs(vLINHA,158,12),',','v'),'.',''),'v','.'))
	 						dbSelectArea("ZX7")
							If RecLock("ZX7",.T.)
								ZX7->ZX7_FILIAL := vFilial
								ZX7->ZX7_COD    := vCod
								ZX7->ZX7_DATA	:= mv_par01 
								ZX7->ZX7_DOC	:= 'QT.INI' 
								ZX7->ZX7_CFOP	:= '0000'
						   		ZX7->ZX7_Tipo	:= '0'
								ZX7->ZX7_QUANT	:= vQuant
      							MsunLock()
            				Endif
            		case subs(vLINHA,3,1) = "/"
            				vData	:= subs(vLINHA,01,8)
            				vDoc	:= subs(vLINHA,22,6)
            				if subs(vLINHA,12,3) < '500'
            					vTipo	:= 'E'
            					vQuant 	:= val(strtran(strtran(strtran(subs(vLINHA, 43,14),',','v'),'.',''),'v','.')) 
            				else
            					vTipo 	:= 'S'
            					vQuant	:= val(strtran(strtran(strtran(subs(vLINHA,112,14),',','v'),'.',''),'v','.')) 
            				endif
            				vCfop	:= subs(vLINHA,17,4)
            				dbSelectArea("ZX7")       
            				If RecLock("ZX7",.T.)
								ZX7->ZX7_FILIAL 	:= vFilial
								ZX7->ZX7_COD    	:= vCod
								ZX7->ZX7_DATA		:= CTOD(vData)
								ZX7->ZX7_DOC		:= vDoc 
								ZX7->ZX7_CFOP		:= vCfop
								ZX7->ZX7_Tipo		:= vTipo
								ZX7->ZX7_QUANT		:= vQuant
      							MsunLock()
            				Endif   
            		case 'T O T A I S  :' $ vLINHA 
	  						vQuant := val(strtran(strtran(strtran(subs(vLINHA,158,12),',','v'),'.',''),'v','.'))
	 						dbSelectArea("ZX7")
							If RecLock("ZX7",.T.)
								ZX7->ZX7_FILIAL := vFilial
								ZX7->ZX7_COD    := vCod
								ZX7->ZX7_DATA	:= mv_par02 
								ZX7->ZX7_DOC	:= 'QT.FIN' 
								ZX7->ZX7_Tipo	:= 'X'
								ZX7->ZX7_CFOP	:= '9999'
								ZX7->ZX7_QUANT	:= vQuant
      							MsunLock()
            				Endif
            		otherwise
            			// Ignora Linha
                EndCase
                dbSelectArea("TMP")
                dbSkip()
            EndDo				
  			dbCloseArea("TMP")
  			fErase(cNomTmp+GetDbExtension())
  			dbCloseArea("ZX7")

    		CSQL := "Select ZX7_FILIAL, "
    		CSQL += "		ZX7_COD, "
    		CSQL += "       ZX7_DATA, "
    		CSQL += "       ZX7_DOC,  "
    		CSQL += "       ZX7_CFOP,"
    		CSQL += "       ZX7_TIPO, "
    		CSQL += "       ZX7_QUANT "
    		CSQL += "  from ZX7010 ZX7, SB1010 sb1  "
    		CSQL += " where ZX7.d_e_l_e_t_ = ' ' "
    		CSQL += "   and SB1.d_e_l_e_t_ = ' ' "
    		CSQL += "   and b1_filial  = '  ' "  
    		CSQL += "   and ZX7_COD between '000000' and '999999' "
    		CSQL += "   and ZX7_CFOP between '0000' and '9999'"
    		CSQL += "   and ZX7_cod = SB1.b1_cod "           
    		CSQL += "   and b1_grtrib = '001' "
    		CSQL += " order by ZX7_cod, ZX7_DATA, ZX7_TIPO "

			MsgRun("Gerando Kardex Loja " + vFilial  ,,{|| cSql := ChangeQuery(cSql)})
    		MsgRun("Gerando Kardex Loja " + vFilial  ,,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)})
	
			TcSetField("ARQ_SQL","ZX7_DATA","D")  
    		TcSetField("ARQ_SQL","ZX7_QUANT","N",14,2)
    
    		ProcRegua(0)
    		vCod 	:= ""
    		vSc  	:= "|"
   	        
   	        cArq := "/AIB/K" + vFilial + "A" + strzero(j,2) + ".txt" 	
			If !File(cArq)
				nFile := fCreate(cArq)
				cCab := "FL|Codigo|  Data  |NumDoc|CFOP|T|    Quantidade"+Chr(13)+Chr(10)
				fWrite(nFile,cCab)
			Else
				nFile := fOpen(cArq,2+64)
				Fseek(nFile,0,2)
			Endif
			
			dbSelectArea("ARQ_SQL")
			Do While !eof()             
   		
	    		cDad	:= vFilial
				cDad	+= vSc 
    			cDad	+= Arq_Sql->ZX7_COD 
				cDad	+= vSc 
    			cDad	+= dtoc(Arq_Sql->ZX7_DATA) 
				cDad	+= vSc         
				cDad	+= Arq_Sql->ZX7_DOC
				cDad	+= vSc 
				cDad	+= Arq_Sql->ZX7_CFOP
				cDad	+= vSc
				cDad	+= iif(Arq_Sql->ZX7_TIPO $ "ES" , Arq_Sql->ZX7_TIPO , " ")
				cDad	+= vSc
    			cDad	+= str(Arq_Sql->ZX7_QUANT,14,2)
    			cDad	+= Chr(13)+Chr(10)
				fWrite(nFile,cDad)
    	        dbSelectArea("ARQ_SQL")
    			dbSkip()
			Enddo

			fClose(nFile)
			dbCloseArea("ARQ_SQL")
			
  		next
    next
    
Return nil
 
