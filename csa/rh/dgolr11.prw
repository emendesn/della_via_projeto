
#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLR11 ()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGolR11   ºAutor  ³ by Golo            º Data ³  06/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Super Relatorio                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Della Via                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	
	Private cString        := "SA1"
	Private aOrd           := {}
	Private cDesc1         := " "
	Private cDesc2         := " "
	Private cDesc3         := " "
	Private tamanho        := "G"
	Private nomeprog       := "DGOLR11"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DGOL11"
	Private titulo         := "Pesquisa Cliente"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DGOLR11"
	Private lImp           := .F.
   Private Cab1           := ""
 	Private Cab2           := ""
   Private Cab3           := ""
	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

   aAdd(aRegs,{cPerg,"01","São Paulo S/N     ?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""          })
   aAdd(aRegs,{cPerg,"02","Até Ult.Com.(Dias)?"," "," ","mv_ch1","N",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
  
   m_pag   := 01
   Li      := 80  


Return nil
 
Static Function RunReport()
   Cabec1 := "  Codigo LJ  Nome                                      P  Endereco                                  UF  Bairro                          Cep       Tel              InscrM               Urg  Municipio"
   Cabec2 := "  A T E N Ç Ã O ... VERIFIQUE COLUNAS COM (?) Ult.Com.Até ( ):= Só Cadastro (1):=7 dias, (2):= 14, (3):= 28, (4):=56, (5):= 112, (6):= 224, (7):= 448 (8):= Demais"             
   dbSelectArea("SA1")
   dbSetOrder(1)                                      
	
   Do While !eof() 
	
	   IncProc("Imprimindo ...")
	   if lAbortPrint
		   LI+=3
		   @ LI,001 PSAY "*** Cancelado pelo Operador ***"
		   lImp := .F.
		   return
	   Endif
	 
	   lImp:=.t.
	
	   if mv_par01 $ "LD" 
	      	if .not.("PAULO" $ alltrim(upper(A1_Mun)))
	         	dbSkip()
	         	loop
	      	endif    
	   else	
	      	if alltrim(upper(A1_Mun)) != "SAO PAULO"  .and. upper(mv_par01) = "S" 
		      	dbSkip()
		      	loop
	    	endif
	   	endif
	            
		IF MV_PAR01 = "D"
	 		DBSELECTAREA("SF2")
	   		DBSETORDER(2)
	     	DBSEEK(XFILIAL("SF2")+SA1->A1_COD+SA1->A1_LOJA)
       		IF EOF()
         		DBSELECTAREA("SA1")
                DBSKIP()
                LOOP
             ENDIF
             DBSELECTAREA("SA1")
  		     if (date()-a1_ultcom) > mv_par_02
  		     	dbskip()
  		     	loop
  		     endif
  		ENDIF
		
	   
	   	vNome  := iif(subst(A1_Nome,1,1)=" "   .or. empty(A1_Nome) .or. LetNum(A1_Nome)      , .f. , .t.)
	   	vPessoa:= iif(empty(A1_Pessoa)         .or. (A1_Loja#'99' .and. empty(A1_InscrM))    , .f. , .t.)
	   	vEnd   := iif(subst(A1_End,1,1)=" "    .or. LetNum(A1_End)                           , .f. , .t.) 
	   	vEst   := iif(upper(A1_Est)<>"SP"                                                    , .f. , .t.)
	   	vBairro:= iif(subst(A1_Bairro,1,1)=" " .or. LetNum(A1_End)                           , .f. , .t.)
	   	vCep   := iif(empty(A1_Cep)                                                          , .f. , .t.)
	   	vCepVal:= iif((A1_CEP > "00999999" .AND. A1_CEP < "06000000") .OR. (A1_CEP > "07999999" .AND. A1_CEP < "08500000"),.t.,.f.)
	   	vTel   := iif(empty(A1_Tel)            .or. A1_Tel = "00000000"                      , .f. , .t.)       
	   	vInscrM:= iif(A1_Loja#'99' .and. subst(A1_InscrM,1,1)=" "                            , .f. , .t.)
	   	vMun   := iif(alltrim(upper(A1_Mun)) # "SAO PAULO"  .or. LetNum(A1_Mun)              , .f. , .t.)
	   	if .not.(vnome .and. vPessoa .and. vEnd .and. vEst .and. vBairro .and. vCep .and. vCepVal .and. vTel .and. vInscrM .and. vMun)
			Li ++
	      	lImp:=.t.
   		  	if Li>55
      	    	LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)    
      	     	Li+=2
   		  	endif 
           	@Li, 002 Psay SA1->A1_Cod
           	@Li, pcol()+1 Psay SA1->A1_Loja
   		  	@Li, pcol()+1 psay iif(vNome  ," "+SA1->A1_NOME  ,"?"+SA1->A1_NOME)  
   		  	@Li, pcol()+1 psay iif(vPessoa," "+SA1->A1_PESSOA,"?"+SA1->A1_PESSOA)
      	  	@Li, pcol()+1 psay IIF(vEnd   ," "+SA1->A1_END   ,"?"+SA1->A1_END)
   		  	@Li, pcol()+1 psay IIF(vEst   ," "+SA1->A1_EST   ,"?"+SA1->A1_EST)
   		  	@Li, pcol()+1 PSAY IIF(vBairro," "+SA1->A1_BAIRRO,"?"+SA1->A1_BAIRRO)
   		  	@Li, pcol()+1 PSAY Iif(vCep   ," "+SA1->A1_CEP   ,"?"+SA1->A1_CEP)                
   		  	@Li, pcol()+1 psay iif(vTel   ," "+SA1->A1_TEL   ,"?"+SA1->A1_TEL)
   		  	@Li, pcol()+1 psay iif(vInscrM," "+SA1->A1_INSCRM,"?"+SA1->A1_INSCRM)
   		  	if empty (SA1->A1_ULTCOM)
   		    	vUrg := "( )"
   		  	else
   		    	vdias:= date()-a1_ultcom
   		     	Do case
   		        	case vdias < 007
   		            		vUrg := "(1)"
   		        	case vdias < 014
   		             		vUrg := "(2)"
   		        	case vdias < 028
   		             		vUrg := "(3)"
   		        	case vdias < 056
   		             		vUrg := "(4)"
   		        	case vdias < 112
   		             		vUrg := "(5)"
   		        	case vdias < 224
   		             		vUrg := "(6)"
   		        	case vdias < 448
   		             		vUrg := "(7)"
   		        	otherwise
   		             		vUrg := "(8)"
   		     	Endcase             
   		  	endif
   		  	@Li, pcol()+1 psay vUrg           
   		  	@Li, pcol()+1 psay iif(vMun   ," "+SA1->A1_Mun,"?"+SA1->A1_Mun)
   	     	@Li, pcol()+1 psay iif(vCepVal,"","? Cep Invalido") 
   	      	
       	endif
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

Static Function LetNum (Alfa)

Local Alfa
Local SN 

SN := .F.
for i = 1 to len(Alfa)
    if .not.subst(Alfa,i,1) $ "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz/,. &*()-"
       SN = .T.
       exit
    endif
endfor

Return SN
