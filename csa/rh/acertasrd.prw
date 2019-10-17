#INCLUDE "RWMAKE.CH"


User Function AcertaCad()

Local cArquivo
Local nOpca := 0
Local aRegs	:={}
Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2

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
	
	nOPc := Aviso("Atencao","Atualizar F. Financeira",{"Sim","Nao"})
	If nOPc = 1

    cArquivo := '\DATA\SRD.TXT'

    If ! File(cArquivo)
      Help(" ",1,"A210NOPEN")
	  Return
    Endif

    //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
    //� Abre arquivo texto informado �
    //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    nHandle := fOpen( cArquivo ,68)
    If Ferror() #0 .or. nHandle < 0
      Help(" ",1,"A210NOPEN")
      Return( Nil )
    Endif
    TXT := fReadStr( nHandle,1285 )
    nBytes := (At( CHR(13)+CHR(10),TXT )) + 1
    aFile   := Directory( cArquivo )
    nSize   := aFile[1,2]
    nLinhas := Int(nSize/nBytes)
    aMeses := {}
    aAdd(aMeses,{'Jan','01'})
    aAdd(aMeses,{'Feb','02'})
    aAdd(aMeses,{'Mar','03'})
    aAdd(aMeses,{'Apr','04'})
    aAdd(aMeses,{'May','05'})
    aAdd(aMeses,{'Jun','06'})
    aAdd(aMeses,{'Jul','07'})
    aAdd(aMeses,{'Aug','08'})
    aAdd(aMeses,{'Sep','09'})
    aAdd(aMeses,{'Oct','10'})
    aAdd(aMeses,{'Nov','11'})
    aAdd(aMeses,{'Dec','12'})

    fSeek( nHandle,0,0 )

    ProcRegua(nLinhas)
    dbSelectArea("SRD")
    For nCount := 1 To nLinhas

            IncProc("Importando Registros ")

            TXT := fReadStr( nHandle,nBytes )

            cFilSrd := Substr(TXT,1,2)
            cMatSrd := Substr(TXT,11,6)
            cDatarq := Substr(TXT,28,4)+Strzero(val(Substr(TXT,32,3)),2)
            cPd     := Substr(TXT,22,3)
            cMes    := Strzero(val(Substr(TXT,32,3)),2)
            cDiaPg  := Substr(TXT,49,2)
            cAnoPg  := Substr(TXT,52,4)
            cMesPg  := Substr(TXT,45,3)
            If ( nPos := Ascan(aMeses,{ |x| x[1] = cMesPg}) ) > 0
               cMesPg := aMeses[nPos,2]
            EndIf     
            dData   := CTOD(cDiaPg+'/'+cMesPg+'/'+cAnoPg)
            nHoras  := Val(Substr(TXT,58,13))
            nValor  := Val(Substr(TXT,71,12))
            
            If cFilSrd == '00'
               cFilSrd := '01'
            EndIF   
            
            cSeq := ""
			DbSelectArea('SRD')
			If DbSeek(cFilSrd+cMatSrd+cDatarq+cPd+"  "+cSeq)
  			   cSeq := Str(Val(SRD->RD_SEQ)+1,1)
  			EndIF   
  			RecLock("SRD",.t.)
			SRD->RD_FILIAL := cFilSrd
			SRD->RD_MAT    := cMatSrd
			SRD->RD_DATARQ := cDatarq
			SRD->RD_TIPO1  := PosSrv(cPd,cFilSrd,'RV_TIPO')
			SRD->RD_PD     := cPd
			SRD->RD_SEQ    := cSeq
			SRD->RD_DATPGT := dData
			SRD->RD_HORAS  := nHoras
			SRD->RD_VALOR  := nValor
			MsUnlock()
	
	Next nCount

    fclose(nHandle)
	EndIF	

RETURN

