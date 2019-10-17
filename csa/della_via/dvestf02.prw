#include "DellaVia.ch"
#include "rwmake.ch"

User Function DVESTF02
	Private Titulo      	:= "Manutenção de Saldos"
	Private aSays       	:= {}
	Private aButtons    	:= {}
	Private cPerg           := "DEST02"   
	Private aRegs           := {}  

	aAdd(aRegs,{cPerg,"01","Tabela?"," "," ","mv_ch1","N",01,0,0,"C","","mv_par01","Saldos - SB9 ","","","","","NFS - SD2     ","","","","","Transferencias - SD3     ","","","","","Devoluções - SD1","","","","","","","","","","","","",""          })
	
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
	
	aAdd(aSays,"Esta rotina faz alteração de Saldos no SB9 e Custo em SD1 ou SD2 ou SD3")
	
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                      }})
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| DoProcessa() },Titulo,,.t.) }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                             }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function DoProcessa
                         
	if mv_par01 = 1
	    DoSB9()
	else
	 	DoSD123()
	endif      
Return nil

Static Function DoSB9

	Private cFilDV  := Space(2)
	Private cArmDV  := Space(2)
	Private cProdDV := Space(15)
	Private cData	:= ctod("  /  /  ")
	Private nSalQtd := 0
	Private nSalVal := 0                 

	Define Font oFontBold  Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 200,510 DIALOG oDlg1 TITLE "Ajusta Saldo SB9"
    //
	@ 005,005 TO 060,250 Title "Produto" PIXEL
	@ 012,010 SAY "Filial:" Font oFontBold Pixel
	@ 010,030 GET cFilDV Picture "!!" SIZE 10,10 OBJECT oGetFil
	@ 012,050 SAY "Código:" Font oFontBold Pixel
	@ 010,080 GET cProdDV Picture "!!!!!!!!!!!!!!!" F3 "SB1" SIZE 60,10 VALID VldProd(cProdDV)  
	@ 012,150 SAY "" PIXEL OBJECT oDescProd SIZE 100,10    
	//
	@ 027,010 SAY "Local:" Font oFontBold Pixel
	@ 025,050 GET cArmDV Picture "99"                SIZE 10,10
	@ 027,120 SAY "Data:" Font oFontBold Pixel
	@ 025,170 GET cData  Picture "@D" SIZE 60,10
	//
	@ 042,010 SAY "Quantidade :" Font oFontBold Pixel
	@ 040,050 GET nSalQtd  Picture "999999"            SIZE 60,10
	@ 042,120 SAY "Custo      :" Font oFontBold Pixel
	@ 040,170 GET nSalVal Picture "@e 999,999,999.9999" SIZE 60,10
	//
	@ 060,005 TO 080,250 PIXEL //Botões
	@ 065,185 BMPBUTTON TYPE 1 ACTION AtuSB9()
	@ 065,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
    //
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuSB9()
	Local cSql := ""
	                        
	if (nSalQtd = 0 .and. nSalVal <> 0) .or. (nSalQtd <> 0 .and. nSalVal = 0)     
		msgbox("Verifique Saldo Quantidade ou Valor = 0","SB9","STOP")
	 	return
	endif
	dbSelectArea("SB9")
	dbSetOrder(1)
	dbGotop()
	dbSeek(cFilDV+cProdDV+cArmDV)
	If Found()
		
		If !msgbox("Confirma alteração ?","Custo","YESNO")
			Return
		Endif
		cSql := "UPDATE "+RetSqlName("SB9")
		cSql += "   SET B9_QINI    = "  + AllTrim(Str(nSalQtd))
		cSql += " ,     B9_VINI1   = "  + AllTrim(Str(nSalVal))  
		cSql += " WHERE D_E_L_E_T_ = '' "
		cSql += "   AND B9_FILIAL  = '" + cFilDV      + "' "
		cSql += "   AND B9_COD     = '" + cProdDV     + "' "
		cSql += "   AND B9_LOCAL   = '" + cArmDV      + "' "
		cSql += "   AND B9_DATA    = '" + dtos(cDATA) + "' " 

		nUpdt := 0
		nUpdt := TcSqlExec(cSql)

		If nUpdt < 0
			MsgBox(TcSqlError(),"DVESTF02-SB9","STOP")
		Endif
	    cFilDV  			:= Space(2)
	    cArmDV  			:= Space(2)
	    cProdDV 			:= Space(15)
	    cData				:= ctod("  /  /  ")
	    nSalQtd 			:= 0
	    nSalVal  			:= 0
		oDescProd:cCaption 	:= ""
		oGetFil:SetFocus()
	Else
		msgbox("Saldo Inicio não encontrado para o produto na filial","SB9","STOP")
	Endif
Return

Static function VldProd(cVar01)
	Local lRet := .F.
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SB1")+cVar01)
	If Found()
		lRet := .T.
		oDescProd:cCaption := B1_DESC
	Endif                
Return lRet      

Static Function DoSD123

	Private cFilDV  := Space(2)
	Private cDoc    := Space(6) 
	Private cSerie  := Space(3)      
	Private cLocal  := Space(2)
	Private cProdDV := Space(15)
	Private cItem   := Space(4)
	Private nCusto  := 0

	Define Font oFontBold  Name "Arial" Size 0, -11 Bold
                                         
 	Do Case
 		Case mv_par01 = 2
 			cTitle := "Ajusta Custo Documento de Saida - SD2"	
 		Case mv_par01 = 3                         
 			cTitle := "Ajusta Custo Transferencia - SD3"
 		Otherwise
 	 		cTitle := "Ajusta Custo Devolução - SD1"
 	EndCase                                         
 	
	@ 000,000 TO 200,510 DIALOG oDlg1 TITLE cTitle
    //
	@ 005,005 TO 060,250 Title "Filial+Documento+Serie+Item+Codigo" PIXEL
	@ 012,010 SAY "Filial:"	Font oFontBold Pixel
	@ 010,030 GET cFilDV  	Picture "!!" SIZE 10,10 OBJECT oGetFil
	@ 012,050 SAY "Doc:"   	Font oFontBold Pixel
	@ 010,070 GET cDoc    	Picture "!!!!!!" SIZE 10,10 OBJECT oGetFil
	@ 012,110 SAY "Serie:"  Font oFontBold Pixel
	@ 010,130 GET cSerie  	Picture "!!!" SIZE 10,10 OBJECT oGetFil
	@ 012,170 SAY "Local:"  Font oFontBold Pixel
	@ 010,190 GET cLocal  	Picture "!!" SIZE 10,10 OBJECT oGetFil
	//
	@ 027,010 SAY "Item:"   Font oFontBold Pixel
	@ 025,030 GET cItem  	Picture "!!!!"                SIZE 10,06
	@ 027,055 SAY "Cod:" Font oFontBold Pixel
	@ 025,070 GET cProdDV 	Picture "!!!!!!!!!!!!!!!" F3 "SB1" SIZE 60,10 VALID VldProd(cProdDV)  
	@ 027,150 SAY "" 		PIXEL OBJECT oDescProd SIZE 100,10    
	//
	@ 042,010 SAY "Custo:" 	Font oFontBold Pixel
	@ 040,050 GET nCusto  	Picture "@e 999,999,999.99" SIZE 60,10   
	@ 042,150 SAY ""        PIXEL OBJECT oValCusAn SIZE 60,10
	//
	@ 060,005 TO 080,250 PIXEL //Botões
	@ 065,185 BMPBUTTON TYPE 1 ACTION AtuSD123()
	@ 065,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
    //
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuSD123()
	Local cSql := ""
 
 	Do Case
 		Case mv_par01 = 2
 				cCampo1 := "D2_Custo1"
 				cTabela := "SD2010"
 		  		cCampo2 := "D2_Filial"
 		  		cCampo3 := "D2_Doc"
 		  		cCampo4 := "D2_Serie"
 		  		cCampo5 := "D2_Item"
 		        cCampo6 := "D2_Cod"
 		        cCampo7 := "D2_Local"           
                cMsg	:= "DVESTF02-SD2"
 		Case mv_par01 = 3  
 				cCampo1 := "D3_Custo1"
 				cTabela := "SD3010"
 		  		cCampo2 := "D3_Filial"
 		  		cCampo3 := "D3_Doc"
 		  		cCampo4 := "D3_Serie"
 		  		cCampo5 := "D3_Item"
 		        cCampo6 := "D3_Cod"
 		        cCampo7 := "D3_Local"           
                cMsg	:= "DVESTF02-SD3"                       
 		Otherwise
 	 	        cCampo1 := "D1_Custo"
 				cTabela := "SD1010"
 		  		cCampo2 := "D1_Filial"
 		  		cCampo3 := "D1_Doc"
 		  		cCampo4 := "D1_Serie"
 		  		cCampo5 := "D1_Item"
 		        cCampo6 := "D1_Cod"
 		        cCampo7 := "D1_Local"           
                cMsg	:= "DVESTF02-SD1"
 	EndCase     
 	cSql :=     "Select " + cCampo1 + " as Custo "
	cSql += "      from " + cTabela
	cSql += "     where D_E_L_E_T_      = ' ' "  
	cSql += "       and " + cCampo2 + " = '" + cFilDV      + "' "
	cSql += "       and " + cCampo3 + " = '" + cDoc        + "' "
	if !empty(cSerie)
		cSql += "   and " + cCampo4 + " = '" + cSerie      + "' "
	endif
	if !empty(cItem)
		cSql += "   and " + cCampo5 + " = '" + cItem       + "' "
	endif
	cSql += "       and " + cCampo6 + " = '" + cProdDV     + "' "        
	if !empty(cLocal)
		cSql += "   and " + cCampo7 + " = '" + cLocal      +"' "
	endif
 	cSql := ChangeQuery(cSql)
  	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .F., .T.)
    TcSetField("ARQ_SQL","Custo","N",14,2)
    dbSelectArea("ARQ_SQL")
    If .not.eof()  
		oValCusAn:cCaption := TRANSFORM(ARQ_SQL->CUSTO , "@E 999,999,999.99")
		
		If !msgbox("Confirma alteração ?","Custo Venda","YESNO")  
			dbCloseArea()
			Return
		Endif
                       
		cSql := "   UPDATE " + cTabela
		cSql += "      SET " + cCampo1 + " = "  + AllTrim(Str(nCusto))  
	    cSql += "    where D_E_L_E_T_      = ' ' "  
	    cSql += "      and " + cCampo2 + " = '" + cFilDV      + "' "
	    cSql += "      and " + cCampo3 + " = '" + cDoc        + "' "
	    if !empty(cSerie)
			cSql += "  and " + cCampo4 + " = '" + cSerie      + "' "
	  	endif
	   	if !empty(cItem)
		   cSql += "   and " + cCampo5 + " = '" + cItem       + "' "
	    endif
	    cSql += "      and " + cCampo6 + " = '" + cProdDV     + "' "            
	    if !empty(cLocal)
		   cSql += "   and " + cCampo7 + " = '" + cLocal      +"' "
	    endif  	
	    
		nUpdt := 0
		nUpdt := TcSqlExec(cSql)
		If nUpdt < 0
			MsgBox(TcSqlError(),cMsg,"STOP")
		Endif
	    cFilDV   			:= Space(2)
	    cDoc     			:= Space(6) 
	    cSerie   			:= Space(3)
	    cProdDV  			:= Space(15)
	    cItem    			:= Space(2)
	    cLocal   			:= Space(2)
	    nCusto   			:= 0
		oDescProd:cCaption 	:= "" 
		oValCusAn:cCaption 	:= ""
		oGetFil:SetFocus()
	Else
		msgbox("Item documento não encontrado para o produto na filial",cMsg,"STOP")
	Endif
	dbCloseArea()  
Return nil      

	