#include "topconn.ch"
#include "RWMAKE.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPEM002  ³ Autor ³ Microsiga      ³ Data ³ 22/11/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ geracao arquivo VB Servicos - Vale Transporte              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GPEM002

Local aSays:={ }, aButtons:= { },aRegs := {} //<== arrays locais de preferencia
Private cCadastro := OemToAnsi("Geracao Arquivo VB Servico") 

nOpca := 0

Aadd(aRegs,{"GPEM07","01","Nome Arquivo ?","","","mv_ch1","C",030,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPEM07","02","Data Emissao ?","","","mv_ch2","D",008,6,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPEM07","03","Filial de ?","","","mv_ch3","C",002,6,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPEM07","04","Filial Ate ?","","","mv_ch4","C",002,6,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPEM07","05","Fil.+Mat. Contato ?","","","mv_ch5","C",008,6,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPEM07","06","E-mail Contato ?","","","mv_ch6","C",050,6,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPEM07","07","DDD Contato ?","","","mv_ch7","C",002,6,0,"G","","mv_par07","","","","","","","","","","","","","","",""})  
Aadd(aRegs,{"GPEM07","08","Telefone Contato ?","","","mv_ch8","C",010,6,0,"G","","mv_par08","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,"GPEM02") // monta as perguntas (como se fosse no SX1) com o nome GPEM07

Pergunte("GPEM02",.F.)

AADD(aSays,OemToAnsi("Este programa gera arquivo VB Servico ") ) 

AADD(aButtons, { 5,.T.,{|| Pergunte("GPEM02",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpconfOK(),FechaBatch(),nOpca:=0) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpca == 1
	Processa({|lEnd| GPM007Processa(),"Gerando Arquivo"})  
Endif

Return

*-------------------------------*
Static FUNCTION Gpm007Processa()
*-------------------------------*   

cNome      := space(060)
cSexo      := space(001)
cData_Aniv := space(006)
cEmail     := space(050)
cArquivo   := space(030)
cEmissao   := space(006)
cDDD       := space(002)
cTelefone  := space(010)

dbSelectArea("SRA")
dbSetOrder(1)
iF dBseek(MV_PAR05,.T.)
   cNome      := SRA->RA_NOME
   cSexo      := SRA->RA_SEXO
   cData_Aniv := Substr(Dtos(SRA->RA_NASC),7,2)+Substr(Dtos(SRA->RA_NASC),5,2)+Substr(Dtos(SRA->RA_NASC),3,2)
ENDIF

cArquivo := mv_par01
cEmissao := Substr(Dtos(mv_par02),7,2)+Substr(Dtos(mv_par02),5,2)+Substr(Dtos(mv_par02),3,2)
cEmail   := mv_par06
cDDD     := mv_par07
cTelefone:= mv_par08
cFilDe   := mv_par03
cFilAte  := mv_par04
nHandle  := MSFCREATE(cArquivo)

If FERROR() # 0 .Or. nHandle < 0
	Help("",1,"GPM600HAND")
	FClose(nHandle)
	Return Nil
EndIf

cQuery := "Select RA_FILIAL,RA_MAT,RA_NOME,RA_NASC,RA_CEP,RA_ESTCIVI,RA_CIC,RA_RG,"
cQuery += "RJ_DESCCMP,R0_MEIO,R0_QDIACAL,R0_VALCAL,RN_ITEMPED,RN_DESC,CTT_DESC01"
cQuery += " FROM " + RETSQLNAME("SRA")+ " , " +  RETSQLNAME("SRJ")+ " , " +  RETSQLNAME("SR0")+ " , " +  RETSQLNAME("SRN")+ " , " +  RETSQLNAME("CTT")
cQuery += " Where RA_CODFUNC = RJ_FUNCAO and RA_SITFOLH <> 'D'" 
cQuery += " and "+RETSQLNAME("SRA")+".D_E_L_E_T_ <> '*'"
cQuery += " and "+RETSQLNAME("SRJ")+".D_E_L_E_T_ <> '*'"
cQuery += " and "+RETSQLNAME("SR0")+".D_E_L_E_T_ <> '*'"
cQuery += " and "+RETSQLNAME("SRN")+".D_E_L_E_T_ <> '*'"
cQuery += " and "+RETSQLNAME("CTT")+".D_E_L_E_T_ <> '*'"
cQuery += " and RA_FILIAL >='"+cFilDe+"' and RA_FILIAL <='"+cFilAte+"'"
cQuery += " and RA_FILIAL = R0_FILIAL and RA_MAT = R0_MAT"
cQuery += " and RN_COD = R0_MEIO and R0_QDIACAL > 0"   
cQuery += " and RA_CC  = CTT_CUSTO"
cQuery += " ORDER BY R0_FILIAL,R0_MAT,R0_MEIO"
cQuery := ChangeQuery(cQuery)

If Select("SR0NEW") > 0
   DbSelectArea("SR0NEW")
   DbCloseArea("SR0NEW")
EndIf   

TcQuery cQuery new Alias "SR0NEW"

DbSelectArea("SR0NEW")
DbGotop()               

cCab1 := space(600)
cCab2 := space(600)
cCab3 := space(600)

nReg    := 1           
nQtdEmp := 0
nQtdEnd := 0
nQtdFun := 0
nQtdBnf := 0
nQtdVtr := 0

SM0->(DBSEEK(cEmpAnt+'01'))
cCgc := SM0->M0_CGC
cEmpresa := Left(SM0->M0_NOMECOM+SPACE(60),60)
cInscricao := Left(SM0->M0_INSC+Space(20),20)
cInscMun   := Space(20)
cCep    := SM0->M0_CEPENT
cCab1 := "00100"+CEmissao+cCgc+cEmpresa+;
         SPACE(509)+strzero(nReg,6)
cConvenio := LEFT(GetMv("MV_CONVVB")+SPACE(9),9)   // 010042164
FWrite( nHandle,cCab1+chr(13)+chr(10))         

nReg    := nReg + 1                                      
nQtdEmp := nQtdEmp + 1
cCab2 := "1"+cConvenio+cCgc+cEmpresa+;
         Left(cEmpresa,40)+cInscricao+cInscMun+"0007"+;
         LEFT(cDDD+SPACE(2),2)+LEFT(cTelefone+SPACE(10),10)+SPACE(10)+LEFT(cNome+SPACE(60),60)+"0015"+"0002"+cSexo+cData_Aniv+;
         LEFT(cEmail+SPACE(50),50)+SPACE(279)+strzero(nReg,6)         
FWrite( nHandle,cCab2+chr(13)+chr(10))

// Endereco Entrega VT

nReg    += 1      
nQtdEnd += 1                                

cCab3 := "2"+cCgc+"0001"+"1"+cCep+LEFT(SM0->M0_ENDENT+SPACE(60),60)+;
        '0000000164'+LEFT(SM0->M0_COMPENT+SPACE(40),40)+LEFT(cNome+SPACE(60),60)+;    
        SPACE(396)+strzero(nReg,6)        
FWrite( nHandle,cCab3+chr(13)+chr(10))
   

DbSelectArea("SR0NEW")
While ! eof()           

   cEstCivi := space(01) 
   IF SR0NEW->RA_ESTCIVI = "C" 
      cEstCivi := "2"
   ELSEIF SR0NEW->RA_ESTCIVI = "D" 
      cEstCivi := "4"
   ELSEIF SR0NEW->RA_ESTCIVI = "Q" 
      cEstCivi := "3"
   ELSEIF SR0NEW->RA_ESTCIVI = "S" 
      cEstCivi := "1"              
   ELSEIF SR0NEW->RA_ESTCIVI = "V" 
      cEstCivi := "5"         
   ENDIF

   nReg    := nReg + 1
   nQtdFun := nQtdFun + 1                                
   cLin1 := space(600)                                                                  
   cEndVT := "0001"
   cLin1 := "3"+cCgc+cEndVT+LEFT(SR0NEW->RA_MAT+SPACE(15),15)+'001'+;
            LEFT(SR0NEW->RA_NOME+SPACE(40),40)+LEFT(SR0NEW->CTT_DESC01+SPACE(40),40)+;
            LEFT(SR0NEW->RJ_DESCCMP+SPACE(30),30)+SUBSTR(SR0NEW->RA_NASC,7,2)+SUBSTR(SR0NEW->RA_NASC,5,2)+;
            SUBSTR(SR0NEW->RA_NASC,3,2)+SR0NEW->RA_CEP+cEstCivi+LEFT(SR0NEW->RA_CIC+SPACE(14),14)+;
            SUBSTR(SR0NEW->RA_RG,1,14)+SPACE(404)+strzero(nReg,6);
   
   FWrite( nHandle,cLin1+chr(13)+chr(10))

   cFilial_Ant := SR0NEW->RA_FILIAL
   cMat_Ant    := SR0NEW->RA_MAT
   
   While ! eof() .AND. cFilial_Ant = SR0NEW->RA_FILIAL .AND. cMat_Ant = SR0NEW->RA_MAT
   
      cTpoFrn := "000001"
 
      nReg    ++
      nQtdVtr ++
      cLin2 := "5"+cCgc+LEFT(SR0NEW->RA_MAT+SPACE(15),15)+;
               SUBSTR(SR0NEW->RN_ITEMPED,1,15)+LEFT(SR0NEW->RN_DESC+SPACE(60),60)+; 
               STRZERO(SR0NEW->R0_QDIACAL,14)+STRZERO(SR0NEW->R0_VALCAL*100,14)+;
               "000000"+SPACE(10)+"N"+cTpoFrn+SPACE(438)+strzero(nReg,6)
      FWrite( nHandle,cLin2+chr(13)+chr(10))
         
      DbSkip()
     
   EndDo

EndDo   

nReg  := nReg + 1
cRod1 := space(600)

cRod1 := "9"+strzero(nReg,6)+strzero(nQtdEmp,6)+strzero(nQtdEnd,6)+strzero(nQtdFun,6)+;
         strzero(nQtdBnf,6)+strzero(nQtdVtr,6)+SPACE(557)+strzero(nReg,6)
FWrite( nHandle,cRod1+chr(13)+chr(10))

FClose(nHandle)

Return
