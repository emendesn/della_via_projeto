User Function GP210SAL

If SRA->RA_CATFUNC = 'H'

   SR6->(DbSeek(xFilial('SR6')+sra->ra_tnotrab))
   nFator :=  SR6->R6_HRNORMA + SR6->R6_HRDESC
  
   If nFator = 0
      nFator := SRA->RA_HRSMES
   EndIf   

   nSalMes := SRA->RA_SALARIO * nFator

EndIf

Return   