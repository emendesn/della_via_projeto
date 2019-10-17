User Function GPEA020()

Local nQtDepAm :=0
Local nQtDepOd :=0 
Local nQtAgrAm :=0 
Local nPos1 := GDFieldPos("RB_DEPAM")
Local nPos2 := GDFieldPos("RB_DEPODO")
Local aArea := GetArea()

For n := 1 to Len(aCols)

     If aCols[n,nPos1] = "1" // DEPENDENTE ASSISTENCIA MEDICA
        nQtDepAm ++ 
     EndIf

     If aCols[n,nPos1] = "2" // AGRAGADO ASSISTENCIA MEDICA
        nQtAgrAm ++ 
     EndIf

     If aCols[n,nPos2] = "1" // DEPENDENTE ODONTOLOGICO
        nQtDepOd ++ 
     EndIf

Next

DbSelectArea("SRA")
RecLock("SRA",.f.)
SRA->RA_DPASSME := StrZero(nQtDepAm,2)  
SRA->RA_AGASSME:= StrZero(nQtAgrAm,2)  
SRA->RA_DEPODON := StrZero(nQtDepOd,2)
MsUnlock()

RestArea(aArea)

Return

 