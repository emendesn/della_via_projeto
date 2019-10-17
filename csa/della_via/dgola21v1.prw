#include "DellaVia.ch"
#include "rwmake.ch"

User Function DGOLA21V1 ()
	Private Titulo      	:= "Acerta 2a.Medida Armazem 02"
	Private aSays       	:= {}
	Private aButtons    	:= {}
	Private aRegs           := {}  

	aAdd(aSays,"Esta rotina faz alteração da segunda unidade do produto")
	
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| DoProcessa() },Titulo,,.t.) }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                             }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function DoProcessa
                         
	Private cFilDur := Space(2)

	Define Font oFontBold  Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 200,510 DIALOG oDlg1 TITLE "Acerta saldo 2 unidade"
    //
	@ 005,005 TO 060,250 Title "Armazem SB2"  	PIXEL
	@ 012,010 SAY "Filial   :" Font oFontBold 	Pixel
	@ 010,080 GET cFilDur      Picture "!!" SIZE 10,10 OBJECT oGetFil  
	@ 060,005 TO 080,250 PIXEL //Botões
	@ 065,185 BMPBUTTON TYPE 1 ACTION AtuArm02()
	@ 065,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
    //
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuArm02()
	
	Local vQtd02 := 0
	                        		
	If !msgbox("Confirma alteração ?","Armazém 02","YESNO")
		Return
	Endif     
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSelectArea("SB2")
	do while .not.eof() 
		dbSelectArea("SB1")
		dbSeek("  "+SB2->B2_Cod)
		if found()
			Do Case
				case SB1->B1_Conv > 0 .and. SB1->B1_TipConv = "D"
					vQtd02 := SB2->B2_Qatu  / SB1->B1_Conv
				case SB1->B1_Conv > 0 .and. SB1->B1_TipConv = "M"
					vQtd02 := SB2->B2_Qatu * SB1->B1_Conv
			    otherwise
					vQtd02 := 0                                     
			EndCase
			dbSelectArea("SB2")
			if RecLock("SB2",.F.) 
				SB2->B2_QtSegUM := vQtd02
		        MsUnlock()
		    endif               
	    endif
	    dbSelectArea("SB2")
	    dbSkip()                        
	enddo

	dbselectarea("SB1")
	dbsetorder(1)
	dbselectarea("SB9")
	do while .not.eof()
		dbselectarea("SB1")  
		dbseek("  "+SB1->B1_COD)
		if found() 
			Do Case
				case SB1->B1_Conv > 0 .and. SB1->B1_TipConv = "D"
					vQtd02 := SB9->B9_QINI  / SB1->B1_Conv
				case SB1->B1_Conv > 0 .and. SB1->B1_TipConv = "M"
					vQtd02 := SB9->B9_QINI  * SB1->B1_Conv
			    otherwise
					vQtd02 := 0 
			EndCase
			dbSelectArea("SB9")
			if RecLock("SB9",.F.) 
				SB9->B9_QISegUM := vQtd02
		  		MsUnlock()
		  	endif 
		endif
		dbSelectArea("SB9")
		dbSkip()              
	enddo
Return
