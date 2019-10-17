#include "Protheus.Ch"

User Function AltPar()
     //
     Local cVar      := Nil
     Local oDlg      := Nil
     Local _cMvPesos := getmv("MV_PESOS")
     Local lMark     := .F.
     Local cTitulo   := "Pesos no calculo do Consumo Medio"
     Local oOk       := LoadBitmap( GetResources(), "LBOK" )
     Local oNo       := LoadBitmap( GetResources(), "LBNO" )
     Local oChk      := Nil
     //
     Private oLbx   := Nil
     Private aVetor := {}
     //
     Private oLbx2   := Nil
     Private aVetor2 := {}
     //
     aAdd( aVetor , { Iif(Substr(_cMvPesos,01,1)=="1",.t.,lMark), "   Janeiro"   })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,02,1)=="1",.t.,lMark), "   Fevereiro" })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,03,1)=="1",.t.,lMark), "   Marco"     })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,04,1)=="1",.t.,lMark), "   Abril"     })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,05,1)=="1",.t.,lMark), "   Maio"      })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,06,1)=="1",.t.,lMark), "   Junho"     })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,07,1)=="1",.t.,lMark), "   Julho"     })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,08,1)=="1",.t.,lMark), "   Agosto"    })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,09,1)=="1",.t.,lMark), "   Setembro"  })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,10,1)=="1",.t.,lMark), "   Outubro"   })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,11,1)=="1",.t.,lMark), "   Novembro"  })
     aAdd( aVetor , { Iif(Substr(_cMvPesos,12,1)=="1",.t.,lMark), "   Dezembro"  })
     //
     DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 330,260 PIXEL
	        //  
            @ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER " ", "   Meses" ;
              SIZE 113,129 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
	        //
            oLbx:SetArray( aVetor )
            oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),aVetor[oLbx:nAt,2]}}
		    //
            DEFINE SBUTTON FROM 149,090 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
            //
	 ACTIVATE MSDIALOG oDlg CENTER
	 //
	 _cMvPesos := ""
	 //
	 For i:=1 to len(aVetor)
	     _cMvPesos += Iif(aVetor[i, 1],"1","0")
	 Next
	 //
	 PutMV("MV_PESOS", _cMvPesos)
	 //
Return
	
Static Function Marca(lMarca)
	Local i := 0
	For i := 1 To Len(aVetor)
	   aVetor[i][1] := lMarca
	Next i
	oLbx:Refresh()
Return
	