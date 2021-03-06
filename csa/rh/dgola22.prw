#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DGOLA22(cColeta)
        
// Programa		: DGOLA22			
// Autor		: Golo
// Data			: 23/10/06
// Descri��o	: Prepara Gera Pedido
//				: Deleta todos os itens de PV n�o faturados
//				: Deleta todos os itens de libera��o de PV n�o faturados
//				: Recomp�e Saldo de material de terceiro em poder da Durapol
// Uso			: Exclusivo Durapol

	Private cString        	:= "SD1"
	Private aOrd           	:= {}
	Private cDesc1         	:= ""
	Private cDesc2         	:= ""
	Private cDesc3         	:= ""
	Private tamanho        	:= "G"
	Private nomeprog       	:= "DGOLR22"
	Private lAbortPrint    	:= .F.
	Private nTipo          	:= 15
	Private aReturn        	:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       	:= 0
	Private cPerg          	:= "DGOL22"
	Private titulo         	:= "Prepara Gera Pedido"
	Private Li             	:= 80
	Private Cabec1         	:= ""
	Private Cabec2         	:= ""
	Private m_pag          	:= 01
	Private wnrel          	:= "DGOLA22"
	Private lImp           	:= .F.   
	
	/*
	cPerg    := PADR(cPerg,6)
	aRegs    := {}  

	aAdd(aRegs,{cPerg,"01","Filial       ?"," "," ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Numero Coleta?"," "," ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SD1","","","",""          })
   	aAdd(aRegs,{cPerg,"03","Serie        ?"," "," ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
    
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
	Pergunte(cPerg,.T.) 
	*/

   	dbselectarea("SC2")
   	dbsetorder(1)
   	dbseek(xFilial("SC2")+cColeta)
   	if eof()
   		//MsgAlert("Ordem de Producao ... Nao cadastrada","SC2")
   		return nil
   	endif 

	dbselectarea("SD1")                                              
   	dbsetorder(1)
   	dbseek(xFilial("SD1")+SC2->C2_NUMD1+SC2->C2_SERIED1+SC2->C2_FORNECE+SC2->C2_LOJA)
   	if eof()
   		//MsgAlert ("Coleta ... Nao Cadastrada","SD1")
   		Return nil
   	endif              
   	
	aItensB6 := {}

   	dbSelectArea("SC6")
	dbSetOrder(7)                                      
	dbSeek(SC2->C2_Filial + SC2->C2_Num)
	do while .not.eof() .and. SC6->C6_Filial == SC2->C2_Filial .and. SC6->C6_Num == SC2->C2_Num
	   if empty(C6_Nota)
	      If !Empty(C6_IDENTB6)
		      aAdd(aItensB6,C6_IDENTB6)
	      Endif
	 	  if RecLock("SC6",.F.)
	 	     delete
	 	     MsUnLock()
	 	  endif
	   endif
	   dbSkip()
	enddo
   	dbSeek(SC2->C2_Filial + SC2->C2_Num)
   	
	if eof()
	   dbSelectArea("SC5")
	   dbSetOrder(1)
	   dbSeek(SC2->C2_Filial + SC2->C2_Num)
	   if Found()
		   if RecLock("SC5",.F.)
		   	  delete
		   	  MsUnlock()
		   endif	
		Endif
   	endif
   	
   	dbSelectArea("SC9")
	dbSetOrder(1)                                      
	dbSeek(SC2->C2_Filial + SC2->C2_Num)
	do while .not.eof() .and. SC9->C9_Filial == SC2->C2_Filial .and. SC9->C9_Pedido == SC2->C2_Num
	   if Empty(C9_NFiscal)
	      if Empty(C9_BLEST) .AND. C9_GRUPO = "CARC"
	      		dbSelectArea("SB2")
	      		dbSetOrder(1)
	      		dbSeek(SC9->(C9_FILIAL+C9_PRODUTO+C9_LOCAL))
	      		If Found()
	      			If RecLock("SB2",.F.)
	      				SB2->B2_RESERVA := SB2->B2_RESERVA - SC9->C9_QTDLIB
	      				MsUnlock()
	      			Endif
	      		Endif
	      		dbSelectArea("SC9")
	      Endif
	 	  if RecLock("SC9",.F.)
	 	     delete
	 	     MsunLock()
	 	  endif
	   endif
	   dbSkip()
	enddo
	
	/*
   	dbSelectArea("SD1")
	do while .not.eof() .and. D1_Filial == upper(mv_par01) .and. D1_Doc == upper(mv_par02) .and. D1_Serie == upper(mv_par03)
	   dbSelectArea("SB6")
	   dbSetOrder(3)                                      
	   dbSeek(SD1->D1_Filial + SD1->D1_IDENTB6)  
	   if eof()
	      //MsgAlert ("Item Coleta:" + SD1->D1_DOC + "/" + SD1->D1_ITEM + " CARCACA DE TERCEIRO NAO CADASTRADO","SD1")
	   else
	   	  dbSelectArea("SC2")
	   	  dbSetOrder(1)
	   	  dbSeek(SD1->D1_Filial + SD1->D1_NumC2 + SD1->D1_ItemC2)

	   	  dbSelectArea("SC6")
	   	  dbSetOrder(7)
	   	  dbSeek(SC2->C2_FILIAL + SC2->C2_NUM + SC2->C2_ITEM)
	   	  if eof()
	   	     dbSelectArea("SB6")
	         if RecLock("SB6",.F.)
	            SB6->B6_SALDO := 1
	            SB6->B6_QULIB := 0
	            MsunLock()
	         endif
	      endif
	   endif
	   dbSelectArea("SD1")
	   dbSkip()
	enddo
	*/
    
	For jj=1 to Len(aItensB6)
	   dbSelectArea("SB6")
	   dbSetOrder(3)                                      
	   dbSeek(xFilial("SB6") + aItensB6[jj])
	   If Found()
         if RecLock("SB6",.F.)
            SB6->B6_SALDO := 1
            SB6->B6_QULIB := 0
            MsunLock()
         endif
	   Endif
	Next


	//msgbox("Ok .. Pode gerar pedido","DgolA22")
Return nil