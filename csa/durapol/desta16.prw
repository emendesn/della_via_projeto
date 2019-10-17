#include 'protheus.ch'  

User Function DESTA16 ()

	Private aRotina   := {}
	Private cPerg     := "EST16"   
	cPerg    := PADR(cPerg,6)
	aRegs    := {}	
	AADD(aRegs,{cPerg,"01","Da  Data Entrega PV?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Até Data Entrega PV?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""          ,"","","","",""       ,"","","","",""             ,"","","","",""            ,"","","","","","","","","   ","","","",""          })
		
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
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif
	// Descrição	: Zera Saldo para B6 Já Faturada	  
	MsgRun("Atualizando SB6 ... Aguarde",,{ || DST16x () })
Return

Static Function DST16x()
	dbSelectArea("SC6")  
	dbSetOrder(1)
	Do While .not.eof()   
		If C6_Entreg < mv_par01 .or. C6_Entreg > mv_par02  
			dbSelectArea("SC6")
			dbSkip()
			Loop
		EndIf
		dbSelectArea("SB6") 
		dbSetOrder(5)
		dbSeek(xFilial("SB6")+SC6->C6_NFORI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_IDENTB6)
		if found()
			If Empty(SC6->C6_Nota) .and. RecLock("SB6",.F.)
   				SB6->B6_SALDO := 1
          		MsunLock()
           	EndIf                                        
           	If !Empty(SC6->C6_Nota) .and. RecLock("SB6",.F.)
      			SB6->B6_SALDO := 0
           		MsunLock()
           	EndIf
		endif      
		dbSelectArea("SC6")
		dbSkip()
	EndDo
	dbCloseArea("SC6")
Return 
