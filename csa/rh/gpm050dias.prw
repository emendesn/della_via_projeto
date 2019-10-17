User Function GPM050DIAS
/*
nDiasVt	    := 0  	//-- Variavel para ser usada no ponto de Entrada
nDiasTrb	:= 0    //-- Variavel para ser usada no ponto de entrada
nDiasDom	:= 0	//-- Variavel para ser usada no ponto retorna numero de Domingos
nDiasSab	:= 0	//-- Variavel para ser usada no ponto retorna numero de sabados

*/

Local aArea := GetArea()

nQuantVt := 0
cDSemana := Posicione("SZ9",1,xFilial("SZ9")+SRA->RA_CODBENE,"Z9_DIASVT")
aFeriado := {}
dDataIni  := PRI_DATA

IF nPropAdm == 1 .and. SRA->RA_ADMISSA > PRI_DATA // Recalcula tabela dias se entrou depois do inicio do periodo
   dDataIni = SRA->RA_ADMISSA
ENDIF   

DbSelectArea("SP3")
DbSetOrder(1)
DbSeek(SRA->RA_FILIAL)
Do While SRA->RA_FILIAL = SP3->P3_FILIAL .AND. !eof()

   If SP3->P3_FIXO = "S"
      ddataFer := Strzero(year(dDataIni),4)+SP3->P3_MESDIA
      dDataFer := StoD(dDataFer)
   Else
      dDataFer := SP3->P3_DATA
   EndIf
   aAdd(aFeriado,{ddatafer})
   DbSkip()

EndDO


fCalcDia(dDataIni,ULT_DATA,cDSemana,@nQuantVt)  

If SRA->RA_SITFOLH $ 'A-F' .and. nDFerias == 1// Recalcula tabela dias se tiver afastamento dentro do Periodo
	nDiasAfas := 0

   DbSelectARea("SR8")
   DbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
   While SRA->RA_FILIAL+SRA->RA_MAT = sr8->r8_filial+sr8->r8_mat .and. !eof()
		If ( Empty(SR8->R8_DATAFIM) ) .or. ( SR8->R8_DATAFIM > ULT_DATA ) 
         		__dDataFimAfas := ULT_DATA 
		Else
				__dDataFimAfas := SR8->R8_DATAFIM
    	EndIf
	   	  
		If SR8->R8_DATAINI < PRI_DATA 
	 	      __dDataIniAFas := PRI_DATA 
   	 Else
 	   	      __dDataIniAFas  := SR8->R8_DATAINI
	    eNDiF
 	   	  
		If ( __dDataIniAfas > ULT_DATA ) .or. ( __dDataFimAfas < PRI_DATA )
	   	  Dbskip()
		     Loop
		EndIf   

		fCalcDia(__dDataIniAfas,__dDataFimAfas,cDSemana,@nDiasAfas)

	    DbSkip()

	EndDo   

ENDIF

nQuantVt := nQuantVt - nDiasAfas

nDiasVt  := nQuantVt
nDiasSab := 0

RestArea(aArea)

Return


Static Function fCalcDia(dDataIni,dDataFim,cDSemana,nDias)


For n := dDataIni to dDataFim
   
   If Str(Dow(dDataIni),1) $ cDSemana
      If Ascan(aFeriado,{ |x| x[1] = dDataIni } ) = 0  // se nao for feriado soma 
         nDias ++
      EndIf   
   EndIf

   dDataIni ++

Next

Return
