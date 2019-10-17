#INCLUDE "RWMAKE.CH"

User Function fContAss()
 
Local __nValAs := 0
Local __cMeses    
Local __lCont
Local __SalBase

__cMeses := RCE->RCE_MESASS
__lCont  := .f.
 
For n := 1 To Len(Alltrim(__cMeses)) Step 2
   If Substr(__cMeses,n,2) = Strzero(Month(dDataBase),2)
      __lCont := .t.
   EndIf
Next
 
If __lCont

	If  RCE->RCE_TIPASS = '1' // SALARIO BASE
    	__SalBase := SALARIO 
	Else
        __SalBase := 0
        aEval(aPd,{ |X | SomaInc(X,29,@__SalBase,,,,,,,aCodFol) }) // UTILIZADO O CAMPO DSR PROFESSOR
    EndIF      

   __nValAs :=  RCE->RCE_PERASS  *  __SALBASE  / 100 
   
   If __nValAs > RCE->RCE_TETASS 
      __nValAs := RCE->RCE_TETASS 
   EndIf

EndIf
 
Return(__nValAs)

User Function fContConf()
 
Local __nValCon := 0
Local __cMeses    
Local __lCont
Local __SalBase 

__cMeses := RCE->RCE_MESCON
__lCont  := .f.
 
For n := 1 To Len(Alltrim(__cMeses)) Step 2
   If Substr(__cMeses,n,2) = Strzero(Month(dDataBase),2)
      __lCont := .t.
   EndIf
Next
 
If __lCont

	If  RCE->RCE_TIPCON  = '1' // SALARIO BASE
    	__SalBase := SALARIO 
	Else
        __SalBase := 0
        aEval(aPd,{ |X | SomaInc(X,30,@__SalBase,,,,,,,aCodFol) }) // UTILIZADO O CAMPO HORA ATIVIDADE
    EndIF      

   __nValCon :=  RCE->RCE_PERCON  *  __SALBASE  / 100 
   
   If __nValCon > RCE->RCE_TETCON 
      __nValCon := RCE->RCE_TETCON 
   EndIf
EndIf
 
Return(__nValCon)

User Function fDiaComercio()

Local dUltDias 
Local nDiasTrb
Local nValCom := 0


dUltDia := Stod(MesAno(dDataBase)+Strzero(f_Ultdia(dDataBase),2))
nDiasTrb := dUltDia - SRA->RA_ADMISSA +1

If nDiasTrb > 90
   nValCom := SalDia 
ElseIf nDiasTrb > 180
   nValCom := SalDia * 2
EndIf

Return(nValCom)       


User Function fIndeniza()

Local nTpServ :=0

nTpServ := Year(dDataDem) - Year(sra->ra_admissa)

If Month(sra->ra_admissa) > Month(dDataDem)
   nTpServ --
EndIF

Return(nTpServ)
 

User Function FuncAlter()

Local _cUsuario := UPPER(alltrim(GetMv("MV_USURH1")))
Local lRet := .T.

if ! inclui
	iF ! (UPPER(alltrim(Substr(cUsuario,7,15)))  $  _cUsuario)
	    ALERT("Usuário não autorizado a alterar este campo")
	    lRet := .F.
	EndIf
EndIf

Return(lRet)


User Function ValidCta(cConta)

Local lRet := .t.
Local cString := Substr(cConta,1,7)

If Len(AllTrim(cString)) < 7
    lRet := .f.
    Alert('A Conta deverá conter 07 Caracteres + o Digito separado por ifem ')
EndIf

If Substr(cConta,8,1) <> '-' 
    lRet := .f.
    Alert('A Conta deverá conter 07 Caracteres + o Digito separado por ifem ')
EndIf

Return(lRet)

User Function GP450DES

Local lRet := .t.
Local cLayout := Upper(Alltrim(MV_PAR21))

IF Substr(cLayout,1,2) = 'CR'
   If Substr(SRA->RA_BCDEPSAL,1,3) <> '341' .or.  ( Substr(SRA->RA_BCDEPSAL,1,3) = '341'  .and. VAL(SRA->RA_CTDEPSA) = 0 )
      lRet := .f.
   EndIF
ElseIf Substr(cLayout,1,2) = 'DC'
   If SUBSTR(SRA->RA_BCDEPSAL,1,3) = '341' .or. (  VAL(SRA->RA_CTDEPSA) = 0 )
      lRet := .f.
   EndIF
ElseIf Substr(cLayout,1,2) = 'OP'
   If VAL(SRA->RA_CTDEPSA) > 0
      lRet := .f.
   EndIF
EndIf

Return(lRet)

User Function CONTARH(cTipoCta)

Local cTipocc
Local cConta := ''

If cTipoCta = nil
   cTipoCta := '1'
EndIf
      
cTipoCC := Posicione('CTT',1,xFilial('CTT')+SRZ->RZ_CC,'CTT_TIPOCC')

If cTipoCta = '1' // Conta Debito 

   If cTipoCC = '1'
      cConta := SRV->RV_CTADEB
   ElseIf cTipoCC = '2'
      cConta := SRV->RV_CTADEB1
   EndIF

ElseIf cTipoCta = '2'

   If cTipoCC = '1'
      cConta := SRV->RV_CTACRED
   ElseIf cTipoCC = '2'
      cConta := SRV->RV_CTACRE1
   EndIF

EndIF

Return(cConta)

User Function fAgregado()

Local nPosPd
Local nValAgr := 0

IF len(M_AGREG) = 0
    DbSelectArea('RCC')
    DbSeek(xFilial('RCC')+'U003')
    While RCC->RCC_FILIAL + RCC->RCC_CODIGO =  xFilial('RCC')+'U003' .and. !eof()
        aadd(M_AGREG,{SUBSTR(RCC->RCC_CONTEUD,1,2),;
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,3,2)),;   // 
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,5,12)),;
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,17,2)),;
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,19,12)),;
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,31,2)),;
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,33,12)),;
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,45,2)),;
        						  VAL(SUBSTR(RCC->RCC_CONTEUD,47,12));
        						  })
        DbSkip()
    EndDo
ENDIF

If ( nPosPd := Ascan(M_AGREG,{ |X| X[1] = SRA->RA_ASMEDIC})) > 0
    DbSelectArea('SRB')
    If DbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
       While SRA->RA_FILIAL+SRA->RA_MAT = SRB->RB_FILIAL+SRB->RB_MAT .AND. ! EOF()
                IF SRB->RB_DEPAM = '2'
                    nIdade := Year(dDataBase) - Year(SRB->RB_DTNASC)
                    If Month(SRB->RB_DTNASC) > Month(dDataBase)
                       nIdade --
                    EndIF
                    If nIdade <= M_AGREG[nPosPd,2]
                      nValAgr += M_AGREG[nPosPd,3]
                    ElseIf  nIdade <= M_AGREG[nPosPd,4]
                      nValAgr += M_AGREG[nPosPd,5] 
                    ElseIf  nIdade <= M_AGREG[nPosPd,6]
                      nValAgr += M_AGREG[nPosPd,7] 
                    ElseIf  nIdade <= M_AGREG[nPosPd,8]
                      nValAgr += M_AGREG[nPosPd,9] 
                    EndIF
                EndIf      
                DbSkip()
          EndDo
     EndIF     
EndIf

Return(nValAgr)

User Function Atrasos()

Local aArea := GetArea()
Private aExtras := {}

nHorasRea  := fBuscaPd("750","H")

If nHorasRea = 0
   Return
EndIF

nPosExtra := Ascan(aExtras,{|x| x[1]== SRA->RA_SINDICA })
   
If nPosExtra = 0  // Se nao existir o Sindicato 

   DbSelectArea("RCC")
   DbSeek(xFilial("RCC")+"U008")
   While RCC->RCC_CODIGO = "U008"
       If SUBSTR(RCC->RCC_CONTEUD,1,2) = SRA->RA_SINDICA
          aAdd(aExtras,{SUBSTR(RCC->RCC_CONTEUD,1,2),VAL(SUBSTR(RCC->RCC_CONTEUD,3,6)),VAL(SUBSTR(RCC->RCC_CONTEUD,9,6)),Substr(RCC->RCC_CONTEUD,15,3) } )
       ENDif
       DbSkip()
   EndDo
   
   RestArea(aArea)
    
EndIF

nHorasFixa := SRA->RA_HEXTRA1+SRA->RA_HEXTRA2
nHorasTot := nHorasRea + nHorasFixa

For nConta := Len(aExtras) to 1 Step -1
    If aExtras[nConta,1] = SRA->RA_SINDICA
       nSobra := 0
   	   If nHorasTot > aExtras[nConta,2] .and. nHorasTot > nHorasFixa
           nSobra := nHorasTot - aExtras[nConta,2] + 0.01
   		   nHorasRea := nHorasRea - nSobra
   		   nHorasTot := nHorasRea + nHorasFixa
       EndIf
       If nSobra > 0 
          fGeraVerba(aExtras[nConta,4],0,nSobra,,,"H")
       EndIF   
    EndIF
Next

Return
      