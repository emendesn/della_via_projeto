#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR8A ()
	Private cString        	:= "SF1"
	Private aOrd           	:= {}
	Private cDesc1         	:= ""
	Private cDesc2         	:= ""
	Private cDesc3         	:= ""
	Private tamanho        	:= "G"
	Private nomeprog       	:= "DGOLR08"
	Private lAbortPrint    	:= .F.
	Private nTipo          	:= 15
	Private aReturn        	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       	:= 0
	Private cPerg          	:= "DGOLR8"
	Private titulo         	:= "Minhas Recapagens"
	Private Li             	:= 80
	Private Cabec1         	:= ""
	Private Cabec2         	:= ""
	Private m_pag          	:= 01
	Private wnrel          	:= "DGOLR08"
	Private lImp           	:= .F.
	Private Cab1           	:= ""
	Private Cab2           	:= ""
   	Private Cab3           	:= ""   
   	Private c01            	:= 001
    Private c02            	:= 009
    Private c03            	:= 017
    Private c04            	:= 035
    Private c05            	:= 043
    Private c06            	:= 065
    Private c07            	:= 073        
    Private c08            	:= 095
    Private c09            	:= 103
    Private c10            	:= 125
    Private c11            	:= 133
    Private c12           	:= 155
	Private c13				:= 163
	Private c14				:= 185
	Private c15				:= 193 
	cString := vTabela
	
	aRegs    := {}                                                                  

	wnrel := SetPrint(cString,NomeProg,.f.,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return nil
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return nil
	Endif
	                                                             
    RptStatus({||RunF1C2 ()})
    
    m_pag   := 01
    Li      := 80  


Return nil                   


Static Function RunF1C2 ()

	Cabec1 := ""
    Cabec2 := ""             
	
	IncProc("Imprimindo ...")
	if lAbortPrint
		LI+=3
		@ LI,001 PSAY "*** Cancelado pelo Operador ***"
		lImp := .F.
		return
	Endif
	
   	if vTabela = "SC2"
   		dbSelectArea("SC2")
   		dbSelectArea("SF1") 
   		dbSetOrder(1)
   		dbSeek(xFilial("SF1")+SC2->C2_NumD1+SC2->C2_SerieD1+SC2->C2_Fornece+SC2->C2_Loja)
   		if eof()
   			return nil
   		endif
   	endif

	lImp:=.t.
 	DoCab()  
    dbSelectArea("SF1")
    @Li, 001 psay SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
	dbSelectArea("SD1")
	dbSetOrder(1)                                      
	dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )  
	do while .T.
		if eof() .or. SF1->F1_DOC # D1_DOC .or. SF1->F1_SERIE # d1_serie .or. SF1->F1_FORNECE # d1_fornece .or. SF1->F1_LOJA # d1_loja
	 		exit
		endif
	 	DoCab() 
	 	DoCab()
   		@Li, c01		PSAY "Coleta:"
   		@Li, c02      	psay "Filial:"
   		@Li, c03		psay SF1->F1_FILIAL
   		@Li, c04		psay "Docum.:"
   		@Li, c05		psay SF1->F1_DOC
   		@Li, c06  		psay "Série :"
   		@Li, c07		psay SF1->F1_Serie
   		@Li, c08		psay "Tipo  :"
   		@Li, c09		psay SF1->F1_Tipo
	    dbSelectArea("SA1")
	    dbSetOrder(1)                                      
	    dbSeek("  " + SF1->F1_FORNECE + SF1->F1_LOJA)   		
   		DoCab()
   		@Li, c02    	psay "Item  :"
	   	@Li, c03    	PSAY SD1->D1_ITEM
	    @Li, c04    	PSAY "Dt.Emi:"
	    @Li, c05    	PSAY SF1->F1_EMISSAO PICTURE "@E 99/99/99" 
	    @Li, c06   		psay "Munic.:"
		@Li, c07		psay SA1->A1_MUN
	    @Li, c08    	PSAY "Client:"  
	    @Li, c09    	psay SF1->F1_FORNECE+"-"+SF1->F1_LOJA
	    @Li, c10      	PSAY "Nome  :" 
     	@Li, c11      	PSAY SA1->A1_NOME  
        DoCab()        
	    @Li, c02      	PSAY "Carcac:" 
	    @Li, c03      	Psay SUBST(SD1->D1_COD,1,15)
	    @Li, c04      	PSAY "N.Ser.:"
	    @Li, c05      	PSAY SUBST(SD1->D1_SERIEPN,1,15)
     	@Li, c06      	PSAY "N.Fogo:"
      	@Li, c07      	PSAY SUBST(SD1->D1_NUMFOGO,1,15)   
       	@Li, c08      	PSAY "Servic:"
	    dbSelectArea("SB1")
	    dbSetOrder(1)                                      
	    dbSeek(xFilial("SB1") + SD1->D1_SERVICO)
     	@Li, c09      	PSAY SD1->D1_SERVICO
     	@Li, c10		psay "Descr.:"
     	@Li, c11      	PSAY SB1->B1_DESC
         
      	dbselectarea("SC2")                                              
        dbsetorder(1)
        dbseek(xFilial("SC2")+SD1->D1_NumC2+SD1->D1_ItemC2) 
        if eof() 
      		DoCab()
        	@Li, c01	psay "Item de Ordem de Produção Não Gerada:" + XFILIAL("SC2")+"-"+SD1->D1_NUMC2+"-"+SD1->D1_ITEMC2
         	exit
        endif
             	
        vQtItOp := 0
        Do while .not.eof()
  		
			if	SD1->D1_NumC2 # SC2->C2_Num .or. SD1->D1_ItemC2 # SC2->C2_Item
            	exit
   			endif   
			vQtItOp++
			if vQtItOp > 1
            	DoCab()
                @Li, 001 psay "Item de Ordem de Produção Duplicada"        
			endif   
                
   			DoCab()
      		@Li, c01		psay "Ord.Pr:"
        	@Li, c02    	psay "Número:"
         	@Li, c03    	PSAY SC2->C2_Num
         	DoCab()
         	@Li, c02        psay "Item  :"
         	@Li, c03        psay SC2->C2_Item
          	@Li, c04      	PSAY "Dt.Emi:"
            @lI, c05      	psay SC2->C2_EMISSAO
            @Li, c06      	PSAY "Dt.Ent:"
            @li, c07      	psay SC2->C2_DatPrf
            @Li, c08 		psay "Client:"
            @Li, c09		psay SC2->C2_Fornece+"-"+SC2->C2_Loja
            @Li, c10      	PSAY "Situac:"  
            @Li, c11      	PSAY SC2->C2_X_STATU
            @Li, c12		PSAY "Desenh:"
            @li, c13      	psay SC2->C2_X_Desen
            DoCab()
            @Li, c02      	PSAY "Dt.Pro:"
            @li, c03      	psay SC2->C2_DatRF 
            @Li, c04      	PSAY "Dt.A.C:"
            @li, c05      	psay SC2->C2_XDtClav
            @Li, c06      	PSAY "Aut.Cl:"
            @li, c07      	psay SC2->C2_XAClave
            @Li, c08      	PSAY "Rodada:"
            @li, c09      	psay C2_XNumRod 
            @Li, c10        psay "Horar.:"
            @Li, c11		psay C2_XRodada
             	
            // Exame
            IF "EXAM" $ SC2->C2_X_DESEN
            	vExame  := SPACE(12)              
             	vOBSSYP := ""
		        IF SC2->C2_XMREPRD == "   "
		        	vExame := "Sem Laudo   "
		        ELSE
		        	IF SC2->C2_XMREFIN == "   "   
		         		vExame := "Em Aprov.Com"
		           	ELSE
		            	IF SC2->C2_XMREFIN == "   "
		             		vExame := "Em Aprov.Dir"
                 		ENDIF
                   	ENDIF
               	ENDIF
                IF SC2->C2_XMREDIR != "   "  
			       	dbSelectArea("SZS")
           			dbSetOrder(1) 
              		dbSeek("  " + SC2->C2_XMREDIR)
			       	IF SZS->ZS_TIPO == "5"
           				vExame := "Não Bonific."
               		ELSE
                 		vExame := "Bonificado  "
                   	ENDIF
			   	ENDIF                  
		    	IF SC2->C2_XMREPRD # SPACE(3)                    
       				vOBSSYP := ""
           			dbSelectArea("SZS")
              		dbSetOrder(1) 
                	dbSeek("  " + SC2->C2_XMREPRD)
			       	dbSelectArea("SYP")
           			dbSetOrder(1) 
              		dbSeek("  " + SZS->ZS_CODOBS)
                	do while .not.eof() .and. SZS->ZS_CODOBS = SYP->YP_CHAVE
                 		vX      := rtrim(SYP->YP_TEXTO)  
                   		vOBSSYP += strtran(vX,"\13\10"," ")
                     	dbskip ()
                   	enddo
                endif
		     	vCred = 0
		      	dbSelectArea("SE1")
         		dbSetOrder(1)                       
           		dbSeek("  " + "SEP" + SC2->C2_NUM + subst("ABCDEFGHIJKLMNOPQRSTUVXYWZ",VAL(SC2->C2_ITEM),1) + "NCC")
		       	if eof()
		        	dbSeek("  " + "SEP" + SC2->C2_NUM + subst("123456789ABCDEFGHIJKLMNOPQRSTUVXYWZ",VAL(SC2->C2_ITEM),1) + "NCC")
		         	if .not.eof()
		          		vCred = SE1->E1_Valor
		           	endif
		        else
		        	vCred = SE1->E1_Valor
		        endif
		        DoCab()
          		@Li,c02      PSAY "Exame :"
            	@Li,c03      psay vExame
             	@Li,c04      psay "Credit:"           
		        @Li,c05      PSAY vCred picture "@E 99,999.99"
		        @Li,c06      psay "Obs.OP:" 
		        @Li,c07      psay SC2->C2_Obs  
		        DoCab()
		        @Li,c02      psay "Laudo :"  
		        @Li,c03      psay subst(vOBSSYP,1,100)
		        if len(vObsSyp)>100
		        	DoCab()
		         	@Li,c03   psay subst(vObsSyp,101,len(vObsSyp)-100)
		        endif   
            Endif
            // Fim Exame
            
            // Apontamentos
            dbSelectArea("SD3")
            dbSetOrder(1)
            dbSeek(xFilial("SD3") + alltrim(SC2->C2_Num)+ alltrim(SC2->C2_Item) + "001")
            if eof()
            	DoCab()
            	@Li, c01 PSAY "Item OP Não Apontada"
            else
            	Do while .not.eof() .and. alltrim(SC2->C2_NUM)+alltrim(SC2->C2_ITEM)+"001" = alltrim(SD3->D3_OP) 
            		DoCab()
            		@Li, c02 psay "Apont.:"
            		@Li, c03 psay SD3->D3_TM
            		@Li, c04 psay "Código:"
            		@Li, c05 psay SD3->D3_COD
            		@Li, c06 psay "D3_CF :"
            		@Li, c07 psay SD3->D3_CF
            		@Li, c08 psay "Emiss.:"
            		@Li, c09 psay SD3->D3_Emissao
            		@Li, c10 psay "Grupo :"
            		@Li, c11 psay SD3->D3_Grupo   
            		@Li, c12 psay "Tipo  :"
            		@Li, c13 psay SD3->D3_Tipo    
            		@Li, c14 psay "Chave :"
            		@Li, c15 psay SD3->D3_Chave
            		dbSkip()
            	Enddo
            Endif		
             	
            // Item PV
            dbSelectArea("SC6")
	       	dbSetOrder(7)                                      
	        dbSeek(xFilial("SC6") + SC2->C2_NUM + SC2->C2_Item)
	        if eof()
	        	DoCab()
          		@Li, c01      PSAY "Item de Pedido de Venda Não Gerado:" + xfilial("SC6")+SC2->C2_NUM+SC2->C2_ITEM  
            else
            	// PV
				dbSelectArea("SC5")
    			dbSetOrder(1)
       			dbSeek(xFilial("SC5")+SC6->C6_NUM)
          		If eof()
            		DoCab()
              		@Li, c01      psay "Pedido de Venda Não Gerado"
           		else
           			DoCab()
              		@Li, c01      psay "Pedido:"
              		@Li, c02      psay "Número:" 
                	@Li, c03      psay SC5->C5_NUM 
                	@Li, c04      psay "Vend.1:"
                	@Li, c05      PSAY SC5->C5_VEND1
                	@Li, c06      psay "Vend.2:"
                	@Li, c07      PSAY SC5->C5_VEND2
                	@Li, c08	  psay "Client:"
                	@Li, c09      PSAY SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI
                	@Li, c10      psay "Motor.:" 
                	@Li, c11      PSAY SC5->C5_VEND3
                	@Li, c12      psay "Vend.4:"
                	@Li, c13      PSAY SC5->C5_VEND4
                	@Li, c14      psay "Indic.:"
                	@Li, c15      PSAY SC5->C5_VEND5
                	DoCab()		  
                	@Li, c02      psay "Cd.Pag:" 
                	@Li, c03      PSAY SC5->C5_CONDPAG 
                	@Li, c04      psay "Dt.Emi:
                	@Li, c05      psay SC5->C5_EMISSAO
                	@Li, c06	  psay "Mensag:"
                	@Li, c07      psay SC5->C5_MenNota
				endif
    			dbSelectArea("SC6")
             		        	
				Do while .not.eof()
					if SC2->C2_Filial # SC6->C6_Filial .or. SC2->C2_NUM # SC6->C6_NumOP .or. SC2->C2_Item # SC6->C6_ItemOP
						exit
      				endif 
          			DoCab()             
             		@Li, c02      	psay "It. PV:" 
               		@Li, c03      	psay SC6->C6_Item
               		@Li, c04        psay "Dat.Ft:"
               		@Li, c05        psay SC6->C6_DatFat
                 	@Li, c06      	psay "Produt:"
                  	@Li, c07      	psay SC6->C6_PRODUTO
                  	@Li, c08		PSAY "Quant.:"
                  	@Li, c09        psay SC6->C6_QTDVEN
                  	@Li, c10      	psay "Valor :"                     
                  	@Li, c11      	psay SC6->C6_VALOR
                  	@Li, c12      	psay "TES   :"
                  	@Li, c13      	psay SC6->C6_TES
                  	@Li, c14      	psay "Descr.:"
                  	@Li, c15		psay SC6->C6_DESCRI 
                  		 
                  	// Item NFS
        			dbSelectArea("SD2")
                  	dbSetOrder(8)                                      
                  	dbSeek(xFilial("SD2") + SC6->C6_NUM+SC6->C6_ITEM)   
                  	if eof()     
                    	DoCab()
                     	@Li, c01      psay "Item de Pedido Não Faturado"    
                  	else                                                   
                     	DoCab()
                     	@Li, c02      psay "It. NF:"
                     	@Li, c03      psay SD2->D2_Doc + "-" + SD2->D2_Item
                     	@Li, c04      psay "Dt.Emi:"
                     	@Li, c05      psay SD2->D2_Emissao
                     	@Li, c06      psay "Client:"
                     	@Li, c07      psay SD2->D2_Cliente+"-"+SD2->D2_Loja
                     	@Li, c08      psay "Qtd.Ft:"
                     	@Li, c09      psay SD2->D2_Quant
                     	@Li, c10      psay "Val.Ft:"
                     	@Li, c11      psay SD2->D2_Total
                     	@Li, c12	  psay "CFOP  :"
                     	@Li, c13      psay SD2->D2_CF 
                     	@Li, c14      psay "Produt:"
                     	@Li, c15      psay SD2->D2_COD                     			
                  	endif
					dbSelectArea("SC6")
                  	dbSkip()
				Enddo
			endif
   			dbSelectArea("SC2")           
      		dbskip()		
        Enddo
        // (3) Fim Loop Item OP
        dbSelectArea("SD1")            
        dbskip()
    Enddo        


	dbSelectArea("SF1")
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

Static function DoCab

   Li ++
   if Li>55
      LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.) 
   endif
	
Return nil     

