#INCLUDE "RWMAKE.CH"


User Function AcertaCad()

Local cArquivo
Local nOpca := 0
Local aRegs	:={}

Local aSays:={ }, aButtons:= { } //<== arrays locais de preferencia
Private lAbortPrint := .F.
cCadastro := OemToAnsi("Ajuste de Cadastros")

AADD(aSays,OemToAnsi("Este programa Ajusta Cadastros Importados"))

//AADD(aButtons, { 5,.T.,{|| Pergunte("GPEM01",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
	IF nOpca == 1
		Processa({|lEnd| GPA210Processa(),"Ajuste nos Cadastros Importados"})
	Endif
	
	Return( Nil )
	

	Static Function GPA210Processa()
	
	Set Century on
	Set epoch to 1920
/*
    aFiliais := {}
    
aAdd(aFiliais,{'01','01'})
aAdd(aFiliais,{'02','02'})   
aAdd(aFiliais,{'03','03'})   
aAdd(aFiliais,{'04','04'})   
aAdd(aFiliais,{'05','05'})   
aAdd(aFiliais,{'06','06'})   
aAdd(aFiliais,{'07','07'})   
aAdd(aFiliais,{'08','08'})   
aAdd(aFiliais,{'09','09'})   
aAdd(aFiliais,{'10','10'})   
aAdd(aFiliais,{'11','11'})   
aAdd(aFiliais,{'12','12'})   
aAdd(aFiliais,{'13','13'})   
aAdd(aFiliais,{'14','14'})   
aAdd(aFiliais,{'15','15'})   
aAdd(aFiliais,{'16','17'})   
aAdd(aFiliais,{'17','18'})   
aAdd(aFiliais,{'18','19'})   
aAdd(aFiliais,{'19','20'})   
aAdd(aFiliais,{'20','21'})   
aAdd(aFiliais,{'21','22'})   
aAdd(aFiliais,{'22','16'})   
aAdd(aFiliais,{'23','00'})   
aAdd(aFiliais,{'24','23'})
aAdd(aFiliais,{'25','24'})
aAdd(aFiliais,{'32','25'})
aAdd(aFiliais,{'33','26'})
aAdd(aFiliais,{'34','27'})
aAdd(aFiliais,{'35','28'})
aAdd(aFiliais,{'36','30'})
aAdd(aFiliais,{'37','31'})
aAdd(aFiliais,{'38','29'})
aAdd(aFiliais,{'39','32'})
aAdd(aFiliais,{'40','33'})
aAdd(aFiliais,{'41','34'})
aAdd(aFiliais,{'46','35'})
aAdd(aFiliais,{'47','37'})
aAdd(aFiliais,{'48','36'})
aAdd(aFiliais,{'49','38'})
aAdd(aFiliais,{'50','39'})
aAdd(aFiliais,{'51','40'})
aAdd(aFiliais,{'53','41'})
aAdd(aFiliais,{'54','42'})
aAdd(aFiliais,{'55','43'})
aAdd(aFiliais,{'56','44'})
aAdd(aFiliais,{'57','45'})
aAdd(aFiliais,{'61','46'})
aAdd(aFiliais,{'62','47'})
aAdd(aFiliais,{'63','48'}) 
aAdd(aFiliais,{'64','49'})
aAdd(aFiliais,{'65','50'})


aAdd(aFiliais,{'26','          0020001   
aAdd(aFiliais,{'27','          0020004   
aAdd(aFiliais,{'28','          0020002   
aAdd(aFiliais,{'29','          0020007   
aAdd(aFiliais,{'30','          0020008   
aAdd(aFiliais,{'31','          0020005   
aAdd(aFiliais,{'42','          0040001   
aAdd(aFiliais,{'43','          0030001   
aAdd(aFiliais,{'44','          0040000   
aAdd(aFiliais,{'45','          0030000   
aAdd(aFiliais,{'52','          0040002   
aAdd(aFiliais,{'58','          005000    
aAdd(aFiliais,{'59','          0050001   
aAdd(aFiliais,{'60','          0040003   
aAdd(aFiliais,{'66','          0060000   })
*/
    	
//	cArqNtx  := CriaTrab(NIL,.f.)
//	IndRegua("SRA",cArqNtx,'RA_MAT',,,"Selecionando Registros...")

    
	
	nOPc := Aviso("Atencao","Atualizar Funcionarios",{"Sim","Nao"})
	If nOPc = 1
/*
         aCC := {}
         DbSelectArea("CTT")
         While !eof()
            aAdd(aCc,{CTT->CTT_CUSTO,CTT->CTT_CCOLD})
            DbSkip()
         EndDO
            
*/         
 
		 DbSelectArea("SRA")
		 ProcRegua(RECCOUNT())
		 DbGotop()
		 While ! eof()
/*
                IncProc("Atualizando arquivo Funcionarios "+ SRA->RA_MAT)
                If ( nPos := Ascan(aCc,{ |x| x[2] = SRA->RA_CC })) > 0
                   cCcNew := aCC[nPos,1]
                Else
                   Alert('C. C. nao Cadastrado no Depara ' + SRA->RA_CC)
                   DbSkip()
                   Loop
                Endif      
              	RecLock("SRA",.f.) 	   
                SRA->RA_CC  := cCcNew
               	MsUnlock() 

*/
                IF sra->ra_sitfolh = "D"
   	    			DbSkip()
   	    	 		Loop
   	    	 	EndIF
				DbSelectArea("CTT")
				iF !DBSEEK(xFilial("CTT")+SRA->RA_CC)
				   IF SRA->RA_CC <> "000000620"
   				       Alert('c.c. nao cadastrado' + SRA->RA_FILIAL+"-"+SRA->RA_MAT)
   				   ENDIF    
				ENDiF
				dBsELECTaREA("SRA")
				dBsKIP()   
   	    	 		
    	EndDO
		
	EndIF
	
	
	nOPc := Aviso("Atencao","Atualizar Dependetes",{"Sim","Nao"})
	If nOPc = 1
		
		cArqNtx1  := CriaTrab(NIL,.f.)
		IndRegua("SRB",cArqNtx1,'RB_MAT',,,"Selecionando Registros...")
		
		DbSelectArea("SRB")
		DBGotop()
		ProcRegua(RECCOUNT())
		While !eof()
                If SRB->RB_FILIAL > '15'
                    If ( nPos := Ascan(aFiliais, { |x| x[1] = SRB->RB_FILIAL}) ) > 0
        			   cFilOk := aFiliais[nPos,2]
      	    		   RecLock("SRB",.f.)
    		           RB_FILIAL := cFilOk
	         			MsUnlock()
    		        EndIF   
                EndIf
    			DbSkip()
		EndDo
		
		fErase(cArqNtx1 + OrdBagExt())
		
	EndIF
	
	nOPc := Aviso("Atencao","Atualizar Ferias",{"Sim","Nao"})
	If nOPc = 1
		
		cArqNtx2  := CriaTrab(NIL,.f.)
		IndRegua("SRH",cArqNtx2,'RH_OBSERVA',,,"Selecionando Registros...")
		
		
		DbSelectArea("SRH")
		DBGotop()
		ProcRegua(RECCOUNT())
		While !eof()
                If SRH->RH_FILIAL > '15'
                    If ( nPos := Ascan(aFiliais, { |x| x[1] = SRH->RH_FILIAL}) ) > 0
        			   cFilOk := aFiliais[nPos,2]
      	    		   RecLock("SRH",.f.)
    		           RH_FILIAL := cFilOk
	         			MsUnlock()
    		        EndIF   
                EndIf
    			DbSkip()
		EndDo
		fErase(cArqNtx2 + OrdBagExt())
		
	EndiF
	
	nOPc := Aviso("Atencao","Atualizar F. Financeira",{"Sim","Nao"})
	If nOPc = 1
		
		cArqNtx3  := CriaTrab(NIL,.f.)
		IndRegua("SRD",cArqNtx3,'RD_MAT',,,"Selecionando Registros...")
		
		cArqDbf := "\DADOSADV\LOTES.DBF"
		DbUseArea(.T.,,cArqDbf,"TRB",.F.)
		cArqNtx4 := CriaTrab(NIL,.f.)
		IndRegua("TRB",cArqNtx4,"CVCODLOT",,,"Selecionando Registros...")  //
		
		DbSelectArea("SRD")
		DBGotop()
		ProcRegua(RECCOUNT())
		While !eof()
			nSeq := 0
			cMat := SRD->RD_MAT
			cFil := If ( SRA->(DbSeek(cMat)),SRA->RA_FILIAL,'  ')
			While cMat = SRD->RD_MAT
				IncProc("Atualizando Ficha Financeira " + srd->rd_mat)
				cLote := SRD->RD_CC
				dDataPgt := IF (TRB->(DbSeek(cLote)),TRB->CDDATPGTOL,CTOD(""))
				RecLock("SRD",.f.)
				SRD->RD_FILIAL := cFil
				SRD->RD_DATPGT := dDataPgt
				MsUnlock()
				DbSKip()
			EndDo
		EndDo
		
		Copy to "\DATA\SRD010.DBF" FOR left(RD_MAT,1) = "0" .OR. LEFT(RD_MAT,1) = "9"
		Copy to "\DATA\SRD020.DBF" FOR left(RD_MAT,1) = "3"
		Copy to "\DATA\SRD30.DBF" FOR left(RD_MAT,1) = "4"
		
		
		fErase(cArqNtx3 + OrdBagExt())
		fErase(cArqNtx4 + OrdBagExt())
		
	EndIF
	nOPc := Aviso("Atencao","Atualizar V. Transporte",{"Sim","Nao"})
	If nOPc = 1
		cArqNtx6  := CriaTrab(NIL,.f.)
		IndRegua("SR0",cArqNtx6,'R0_MAT',,,"Selecionando Registros...")
		
		
		DbSelectArea("SR0")
		DBGotop()
		ProcRegua(RECCOUNT())
		While !eof()
                If SR0->R0_FILIAL > '15'
                    If ( nPos := Ascan(aFiliais, { |x| x[1] = SR0->R0_FILIAL}) ) > 0
        			   cFilOk := aFiliais[nPos,2]
      	    		   RecLock("SR0",.f.)
    		           R0_FILIAL := cFilOk
	         			MsUnlock()
    		        EndIF   
                EndIf
    			DbSkip()
		EndDo

		fErase(cArqNtx6 + OrdBagExt())
		
	EndiF

RETURN
