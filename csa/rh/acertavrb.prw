#INCLUDE "RWMAKE.CH"


User Function AcertaVrb()

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
    
	aFuncoes := {}
    aAdd(aFuncoes,{'00022'})
    aAdd(aFuncoes,{'00024'})
    aAdd(aFuncoes,{'00025'})
    aAdd(aFuncoes,{'00115'})
    aAdd(aFuncoes,{'00127'})
    aAdd(aFuncoes,{'00128'})
    aAdd(aFuncoes,{'00148'})
    aAdd(aFuncoes,{'00153'})
    aAdd(aFuncoes,{'00154'})
    aAdd(aFuncoes,{'00924'})

	nOPc := Aviso("Atencao","Atualizar Funcionarios",{"Sim","Nao"})
	If nOPc = 1
    	   cFiltro := "RD_PD = '032' .OR. RD_PD = '033' .OR. RD_PD = '048'"
    	   cArqNtx := CriaTrab(NIL,.f.)
	       IndRegua("SRD",cArqNtx,"RD_FILIAL+RD_MAT",,cFiltro,"Selecionando Registros...")  //

           DbSelectArea('SRA')
           DbGotop()
           While !eof()

                IF sra->ra_sitfolh = "D"
           		   DbSkip()
        	 	   Loop
        	 	EndIF   

                If ( Ascan(aFuncoes,{ |x| x[1] = SRA->RA_CODFUNC } )) = 0
             		DbSkip()
   	       		    Loop
        	 	EndIF
     
                DbSelectArea('SRD')
                IF DbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
                   While SRA->RA_FILIAL+SRA->RA_MAT == SRD->RD_FILIAL+SRD->RD_MAT 
                       If SRD->RD_DATARQ < '200509'
                          DbSkip()
                          Loop
                       EndIf   

        			   IncProc("Atualizando Registros " + SRD->RD_FILIAL+'-'+SRD->RD_MAT+'-'+SRD->RD_DATARQ+'-'+SRD->RD_PD)
		
                       RecLock('SRD',.F.)
                       IF SRD->RD_PD = '032'
 			              RD_PD := '171'
                       ElseIf SRD->RD_PD = '033'
   			              RD_PD := '170'
                       ElseIf SRD->RD_PD = '048'
   			              RD_PD := '172'
		               EndIf
		               MSUNLOCK()
		               DbSkip()
       		       EndDo
                EndIf
                DbSelectArea('SRA')
                DbSkip()
           EndDO
	EndIF
	

RETURN
