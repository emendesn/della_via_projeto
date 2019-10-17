#INCLUDE "rwmake.ch"

User Function DESTALP()

	Local	cProgram	   	:= "DESTALP"
	Local   cAlias			:= ""
	Local	cPerg			:= ""   
	Local 	cTitulo			:= ""
	Local	cDesc1			:= ""
	Local 	cDesc2			:= ""
	Local	cDesc3			:= ""
	local 	lDic			:= .F.
	Local	lCompress		:= .F.
	Local	cTam			:= "G"
	Private m_pag			:= 1
	Private	aReturn			:={"Especial", 1,"Administracao", 1, 2, 1,"",1 }
	Private wRel			
	Private aOrd            := {}
	
	If !isprinter("LPT1",,1,)
		MsgStop("LPT1 indisponível..." , "Impressora")
		return
	Else
		MsgStop("Impressora Pronta...", "Impressora")
	endif
	
	//cal aRegs				:= {}
	//wRel:=SetPrint(cAlias,cProgram,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,lDic,aOrd,lCompress,cTam)
    
	
	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cAlias)

	If nLastKey == 27
		Return
	Endif

	RptStatus({|| RunRelat ()})        
	

Return

Static Function RunRelat

	Local nLin := 0

	@ nLin,000 PSAY chr(18)

   		nLin := nLin + 1
   		
		
		@ nLin,010 PSAY "Cliente"
		@ nLin,050 PSAY "Cod.Cliente"
		nLin:= nLin + 1
		
		@ nLin,010 PSAY "Coleta"
		@ nLin,030 PSAY "Data Emissao"
	
		nLin:= nLin + 1
	
		@ nLin,010 PSAY "Medida"
		@ nLin,035 PSAY "Num.Serie/Numero Fogo"
	
		nLin:= nLin + 1
		@ nLin,010 PSAY "Numero da Ficha"
		
		nLin:= nLin + 17   //17
	
		@ nLin,012 PSAY "Obs"
		@ nLin,070 PSAY "DESENHO"
	
	
		nLin:=nLin+ 3 //22
   		@ nLin,010 psay "Cliente"
	
		@ nLin,039 PSAY "Banda"
	
		nLin:= nLin + 1
	
		@ nLin,010 PSAY "Coleta"
		@ nLin,036 PSAY "Data Emissao"
		@ nLin,058 PSAY "Medida chr(255)+Chr(14)"
		nLin:= nLin + 1
	
		@ nLin,010 PSAY  "Medida"
		@ nLin,042 PSAY  "Num.Serie/Numero Fogo"
	
    	nlin := nLin + 1
    	@ nLin,010 PSAY  "Numero da Ficha+Item da Ficha"
    
		nlin := nLin + 1
	
		@ nLin,018 PSAY "Banda"       
		nlin := nLin + 2				

		nLin := nLin+6  //
    Set Device to Screen 
	If aReturn[5]==1
		Set Printer to
		dbCommitAll()
		OurSpool(wRel)
	EndIf

	MS_FLUSH()
Return

