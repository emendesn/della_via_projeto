#include "DellaVia.ch"
#include "rwmake.ch"

User Function DGOLA20V1 ()
	Private Titulo      	:= "Vendedor x PV X NFS X Dup X SA1"
	Private aSays       	:= {}
	Private aButtons    	:= {}
	Private aRegs           := {}  

	aAdd(aSays,"Esta rotina faz alteração do codigo do vendedor da Durapol")
	
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| DoProcessa() },Titulo,,.t.) }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                             }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function DoProcessa
                         
	Private cFilDur := Space(2)
	Private cNumNFS := Space(6) 
	Private cSerNFS := Space(3) 
	Private cCodNovo:= Space(6)   
	Private cTipVend:= Space(1)

	Define Font oFontBold  Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 200,510 DIALOG oDlg1 TITLE "Acerta codigo de vendedor"
    //
	@ 005,005 TO 060,250 Title "Nota Fiscal"  	PIXEL
	@ 012,010 SAY "Filial   :" Font oFontBold 	Pixel
	@ 010,030 GET cFilDur      Picture "!!"   	SIZE 10,10 OBJECT oGetFil
	@ 012,050 SAY "NFS      :" Font oFontBold 	Pixel
	@ 010,080 GET cNumNFS      Picture "!!!!!!" SIZE 10,10 OBJECT oGetFil  
	@ 012,110 SAY "Serie    :" Font oFontBold 	Pixel
	@ 010,140 GET cSerNFS      Picture "!!!"    SIZE 10,10 VALID VLDNFS()

	@ 027,010 SAY "Vend:"      Font oFontBold 	Pixel  
	@ 027,030 GET cTipVend     Picture "!"      SIZE 10,10 valid cTipVend $  "345"  
	@ 025,050 SAY ""           Picture "!!!!!"  PIXEL OBJECT     oCodVend SIZE 60,10
	
	//
	@ 042,010 SAY "Alterar->:" Font oFontBold 	Pixel
	@ 040,050 GET cCodNovo    Picture "!!!!!!"  SIZE 60,10
	//
	@ 060,005 TO 080,250 PIXEL //Botões
	@ 065,185 BMPBUTTON TYPE 1 ACTION AtuVend()
	@ 065,215 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
    //
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function AtuVend()
	                        		
	If !msgbox("Confirma alteração ?","Vendedor","YESNO")
		Return
	Endif
	dbSelectArea("SF2")
	if RecLock("SF2",.F.)      
		Do case
			Case cTipVend="3"
				SF2->F2_Vend3 := cCodNovo
			Case cTipVend="4"            
				SF2->F2_Vend4 := cCodNovo
			Case cTipVend="5"
				SF2->F2_Vend5 := cCodNovo
		Endcase
		MsUnlock()               
	endif                        
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(cFilDur+cNumNFS+cSerNFS)
	Do While .not.eof() .and. D2_Filial = SF2->F2_Filial .and. D2_Doc = SF2->F2_Doc .and. D2_Serie = SF2->F2_Serie
		dbSelectArea("SC5") 
		dbSetOrder(1)
		dbSeek(SD2->D2_Filial+SD2->D2_Pedido)
		if found() .and. RecLock("SC5",.F.) 
			Do case
				Case cTipVend="3"
					SC5->C5_Vend3 := cCodNovo
				Case cTipVend="4"            
					SC5->C5_Vend4 := cCodNovo
				Case cTipVend="5"
					SC5->C5_Vend5 := cCodNovo
			Endcase
			MsUnlock()               
		endif
		dbSelectArea("SD2")
		dbSkip()   
	Enddo
	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek("  "+SF2->F2_Cliente+SF2->F2_Loja+"U"+SF2->F2_Filial+SF2->F2_Dupl)
	do while .not.eof() .and. E1_Filial+E1_Cliente+E1_Loja+E1_Prefixo+E1_Num="  "+SF2->F2_Cliente+SF2->F2_Loja+"U"+SF2->F2_Filial+SF2->F2_Dupl
		if RecLock("SE1",.F.)
			Do case
				Case cTipVend="3"
					SE1->E1_Vend3 := cCodNovo
				Case cTipVend="4"            
					SE1->E1_Vend4 := cCodNovo
				Case cTipVend="5"
					SE1->E1_Vend5 := cCodNovo
			Endcase
			MsUnlock()               
		endif
		dbSelectArea("SE1")
		dbSkip()
	Enddo           
	if msgbox("Altera Código do Vendedor no Cadastro de Clientes ?","Cadastro de Clientes","YESNO")
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek("  "+SF2->F2_Cliente+SF2->F2_Loja)
		if found() .and. RecLock ("SA1",.F.)
			Do case
				Case cTipVend="3"
					SA1->A1_Vend3 := cCodNovo
				Case cTipVend="4"            
					SA1->A1_Vend4 := cCodNovo
				Case cTipVend="5"
					SA1->A1_Vend5 := cCodNovo
			Endcase
			MsUnlock()               
		endif
	endif
	cFilDur  			:= Space(2)
	cNumNFS 			:= Space(6) 
	cSerNFS 			:= Space(3) 
	cCodNovo 			:= Space(6)
	cTipVend            := Space(1)
	oCodVend:cCaption   := ""
	oGetFil:SetFocus()
Return

Static function VldNFS()
	Local lRet := .F.     
	dbSelectArea("SF2")
	dbSetOrder(1)
	dbGotop()
	dbSeek(cFilDur+cNumNFS+cSerNFS)               
	If Found()
		lRet               := .T.
		oCodVend:cCaption  := alltrim(F2_Vend3)+"/"+alltrim(F2_Vend4)+"/"+ alltrim(F2_Vend5)
		dbSelectArea("SE1")
		dbSetOrder(2)
		dbSeek("  "+SF2->F2_Cliente+SF2->F2_Loja+"U"+SF2->F2_Filial+SF2->F2_Dupl)
		If SE1->E1_Saldo = 0
			lRet := .F.
			MsgAlert("Nota Fiscal Já Tem Título Quitado","SE1")
		Endif                                               
	Else
		MsgAlert("Nota Fiscal Não Encontrada","SF2")
	Endif                
Return lRet      

