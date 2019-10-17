#include "DellaVia.ch"
#include "rwmake.ch"

User Function DGOLA32
	Private Titulo      	:= "Vendedor x Funcionario"
	Private aSays       	:= {}
	Private aButtons    	:= {}
	Private aRegs           := {}  

	aAdd(aSays,"Esta rotina faz alteração do codigo do vendedor em funcionarios")
	
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| DoProcessa() },Titulo,,.t.) }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                             }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function DoProcessa
                         
	Private cFilDV  := Space(2)
	Private cCodSRA := Space(6) 
	Private cCodNov := Space(6)

	Define Font oFontBold  Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 200,510 DIALOG oDlg1 TITLE "Acerta codigo de vendedor"
    //
	@ 005,005 TO 060,250 Title "Funcionario" PIXEL
	@ 012,010 SAY "Filial:"   Font oFontBold Pixel
	@ 010,030 GET cFilDV      Picture "!!"                 SIZE 10,10 OBJECT oGetFil
	@ 012,050 SAY "Registro:" Font oFontBold Pixel
	@ 010,080 GET cCodSRA     Picture "!!!!!!"             SIZE 60,10 VALID VLDSRA(cCodSRA)  
	@ 012,150 SAY "" PIXEL OBJECT oNomeFunc                SIZE 100,10    
	//
	@ 027,010 SAY "Atual:"    Font oFontBold Pixel
	@ 025,050 SAY "" PIXEL OBJECT oCodVend                 SIZE 60,10
	//
	@ 042,010 SAY "Novo:"     Font oFontBold Pixel
	@ 040,050 GET cCodNov     Picture "!!!!!!"             SIZE 60,10
	//
	@ 060,005 TO 080,250 PIXEL //Botões
	@ 065,185 BMPBUTTON TYPE 1 ACTION AtuSRA()
	@ 065,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
    //
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuSRA()
	                        		
	If !msgbox("Confirma alteração ?","Vendedor","YESNO")
		Return
	Endif
	dbSelectArea("SRA")
	if RecLock("SRA",.F.)
		SRA->RA_CodVend := cCodNov
		MsUnlock()
	endif
	cFilDV  			:= Space(2)
	cCodSRA 			:= Space(6) 
	cCodNov 			:= Space(6)
	oNomeFunc:cCaption  := "" 
	oCodVend :cCaption  := ""
	oGetFil:SetFocus()
Return

Static function VldSRA(cPar01)
	Local lRet := .F.     
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbGotop()
	dbSeek(cFilDV+cPar01)               
	If Found()
		lRet               := .T.
		oNomeFunc:cCaption := RA_Nome   
		oCodVend :cCaption := RA_CodVend
	Endif                
Return lRet      

