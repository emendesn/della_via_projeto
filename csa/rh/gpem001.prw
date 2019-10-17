#include "protheus.ch"


User Function GPEM001()

Local nOpca := 0
Local aRegs	:={}

Local aSays:={ }, aButtons:= { } //<== arrays locais de preferencia

cCadastro := OemToAnsi("Geração do Arquivo Visa Vale") 

Aadd(aRegs,{"GPMXVT","01","Mes/Ano        ?","","","mv_cha","C",006,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","02","Data Credito   ?","","","mv_chb","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","03","Nome Arquivo   ?","","","mv_chc","C",030,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","04","Filial de      ?","","","mv_chd","C",002,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","05","Filial ate     ?","","","mv_che","C",002,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","06","Matricula de   ?","","","mv_chf","C",006,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","07","Matricula Ate  ?","","","mv_chg","C",006,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","08","Categorias     ?","","","mv_chh","C",012,0,0,"G","fCategoria","mv_par08","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","09","Responsalvel   ?","","","mv_chi","C",040,0,0,"G","","mv_par09","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPMXVT","10","Telefone       ?","","","mv_chj","C",012,0,0,"G","","mv_par10","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,"GPMXVT")

Pergunte("GPMXVT",.F.)

AADD(aSays,OemToAnsi("Este programa gera arquivo do VISA VALE") )   

AADD(aButtons, { 5,.T.,{|| Pergunte("GPMXVT",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

IF nOpca == 1
		Processa({|lEnd| GPCRIAARQ(),"Gerando Arquivo"})
Endif

Return( Nil )

Static Function GPCRIAARQ()

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2

cArqTxt := alltrim(mv_par03)
nRecno  := Recno()
nHandle := MSFCREATE(cArqTXT)
cCatFun := mv_par07
If FERROR() # 0 .Or. nHandle < 0
	Help("",1,"GPM600HAND")
	FClose(nHandle)
	Return Nil
EndIf


cFilDe     := mv_par04
cFilAte    := mv_par05
cMatDe     := mv_par06
cMatAte    := mv_par07
Set Century On
DBSELECTAREA('SM0')
DBSEEK(cEmpAnt + '01')

cAnoMes    := substr(MV_PAR01,3,4)+substr(MV_PAR01,1,2)

If Substr(cAnoMes,3,2) < '01' .or. Substr(cAnoMes,3,2) > '12'
   Alert('Mês de refência inválido')
   Return
EndIf   

cCgc       := left(SM0->M0_CGC+space(14),14)
cData      := Dtos(ddatabase)
cData      := Substr(cData,7,2)+Substr(cData,5,2)+Substr(cData,1,4)
cContrato  := StrZero(Val(GetMv("MV_VISAVAL")),11)
cDescEmp   := LEFT(SM0->M0_NOMECOM+Space(35),35)
cDescFil   := LEFT(SM0->M0_FILIAL+Space(35),35)
cDataCred  := Dtos(mv_par02)
cDataCred  := Substr(cDataCred,7,2)+Substr(cDataCred,5,2)+Substr(cDataCred,1,4)
cResp      := Left(mv_par08+space(35),35)
aFunc      := {}
cTelefone  := Strzero(val(mv_par09),12)
//Registro 0
fWrite(nHandle,'0'+cData+"A001"+cDescEmp+cCgc+REPLICATE('0',11)+cContrato+'000000'+cDataCred+"11"+;
				cAnoMes+Space(18)+'007'+Space(267)+'000001'+Space(50)+chr(13)+chr(10))
//Registro 1
fWrite(nHandle,'1'+cCGC+REPLICATE('0',10)+cDescFil+'0021'+cResp+Space(40)+;
				cTelefone+REPLICATE('0',6)+Space(75)+REPLICATE('0',12)+;
				REPLICATE('0',6)+Space(75)+REPLICATE('0',12)+REPLICATE('0',6)+Space(51)+'000002'+Space(50)+chr(13)+chr(10))

               

//Registro 5				                                         
nSeq      := 3
nTotVt    := 0
nTotvalor := 0
nValTot := 0
nTotal := 0
aCesta   := {}
fCarCesta(@aCesta)
cFilAnte_ := 'xfc'
DbSelectArea("SRA")       
ProcRegua(RecCount())
DbSeek(cFilDe+cMatDe,.t.)
While SRA->RA_FILIAL+SRA->RA_MAT <= cFilate+cMatAte .and. ! EOF()

     IncProc('Gerando Arquivo')
     
     If SRA->RA_SITFOLH ='D' .OR. SRA->RA_CESTAB # "S"
        DbSkip()
        Loop
     EndIf        
     
	 If Sra->ra_catfunc $ cCatfun
	    DbSkip()
	    Loop
	 EndIF        

     If cFilAnte_ <> SRA->RA_FILIAL
	     If ( nPos := Ascan(aCesta,{|x| x[1] = SRA->RA_FILIAL } )) > 0
    	    nTotal := aCesta[nPos,2]
	     ELse
	    	 If ( nPos := Ascan(aCesta,{|x| x[1] = '  ' } )) > 0
    	    	nTotal := aCesta[nPos,2]
	    	 Else
	    	    nTotal := 0
	    	 EndIf
	     EndIF	 
	     cFilAnte_ := sra->ra_filial
     EndIF                          
     
     cNasc := Dtos(SRA->RA_NASC)
     cNasc := Substr(cnasc,7,2)+Substr(cNasc,5,2)+Substr(cNasc,1,4)
     cCPF  := SRA->RA_CIC
     cNome := left(SRA->RA_NOME+Space(40),40)
	 
  	 nValTot += nTotal
	 fGravaDet()
 	 nSeq ++ 
     aAdd(aFunc,{SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_NOME,1,nTotal,nTotal})
     DbSkip()
        
EndDo	    
        
   

fWrite(nHandle,'9'+STRZERO(nSeq-3,6)+STRZERO(nvalTot * 100 ,15)+Space(372)+STRZERO(nSeq,6)+chr(13)+chr(10))

FClose(nHandle)

Set Century Off

DbGoto(nRecno)

fImprime()

Return nil

Static Function fGravaDet()

fWrite(nHandle,'5'+STRZERO(nTotal * 100,11)+Space(68)+cNasc+cCpf+Space(40)+Replicate('0',15)+' 0'+;
   				  Space(45)+Replicate('0',13)+Space(96)+Replicate('0',28)+space(1)+;
   				  Replicate('0',8)+' '+cNome+Space(6)+STRZERO(nSeq,6)+Space(50)+chr(13)+chr(10))

Return


Static Function fImprime()

cDesc1  := 'Log de Geracao do Arquivo de Vale Refeição' 
cDesc2  := ''
cDesc3  := ''
cString := 'SX1'
aOrd    := {}
aReturn  := { 'Zebrado',1,'Administra‡„o',1,2,1,'',1 }
NomeProg := 'GPEXVR'
At_Prg   := 'GPEXVR'
nLastKey := 0
nTamanho := "P"
Li       := 0
ContFl   := 1

cTit := 'Log do Arquivo de Vale Refeição'
wCabec0 := 1
wCabec1 := 'Fl Matric Nome                              Qtda.  Valor  Total'

WnRel  :='GPEXVR'       //-- Nome Default do relatorio em Disco.
WnRel  :=SetPrint(cString,WnRel,,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd)
//rdem := aReturn[8]

Titulo := 'Arquivo Visa Vale '+MesExtenso(dDataBase)+"/"+Transf(Year(dDataBase),"9999")

If nLastKey == 27
   Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return Nil
Endif

RptStatus({|| IMP_REL1() })

STATIC Function IMP_REL1()

Local nTotFun          := 0
Local nTotValor := 0

SetRegua(Len(aFunc))

For n := 1 to Len(aFunc)
  IncRegua()
  Impr(aFunc[n,1] + ' ' + aFunc[n,2] + ' ' + aFunc[n,3] + '   ' + Transform(aFunc[n,4], '@e 999') + '   ' + Transform(aFunc[n,5], '@e 999.99') + '   '+ Transform(aFunc[n,6], '@e 999,999.99'))
  nTotfun ++
  nTotValor += aFunc[n,6]
Next

Impr('')
IMPR(REPLICATE('-',80))
Impr('Total de Funcionarios ' + Transform(nTotFun , '9999') + ' -  Valor Total  ' + Transform(nTotVALOR, "@e 999,999.99"))
IMPR(REPLICATE('-',80))

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(WnRel)
Endif

MS_Flush()

Return

Static Function fCarCesta(aCesta)

Local aArea := GetArea()

DbSelectArea("SRX")
DbSeek(xFilial('SRX')+"35")
While xFilial('SRX')+"35" = SRX->RX_FILIAL+SRX->RX_TIP .AND. !EOF()
     If Substr(SRX->RX_COD,3,1) <> '1'
       DbSkip()
       Loop
     EndIf
     aAdd(aCesta,{Substr(SRX->RX_COD,1,2),VAL(SUBSTR(SRX->RX_TXT,1,12))})
     DbSkip()
EndDo

RestArea(aArea)

Return