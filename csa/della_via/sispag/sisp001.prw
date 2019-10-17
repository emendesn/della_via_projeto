#include "rwmake.ch"

User Function SISP001()

Local _cReturn  := ""
Local _cReturn2 := ""
Local _cReturn3 := ""

IF AT("-",SA2->A2_NUMCON) == 0
 If SE2->E2_PORTADO=="341"
    _cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,Len(Alltrim(SA2->A2_NUMCON))-1)),12)
 Else 
    _cReturn := StrZero(Val(SA2->A2_NUMCON),10) 
 End
Else
 If SE2->E2_PORTADO=="341"
	_cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON)-1)),12)
 Else
    _cReturn :=StrZero(Val(SUBS(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON)-1)),9)
 End 
Endif

IF AT("-",SA2->A2_NUMCON) == 0
 If SE2->E2_PORTADO=="341"
	_cReturn2 := " "+SUBS( Alltrim(SA2->A2_NUMCON), len(alltrim(SA2->A2_NUMCON)),1)
 End
Else
 If SE2->E2_PORTADO=="341" 
  IF LEN(SUBSTR(Alltrim(SA2->A2_NUMCON),AT("-",SA2->A2_NUMCON)+1,2)) == 2
 		_cReturn2 :=  SUBS(SA2->A2_NUMCON,AT("-",SA2->A2_NUMCON)+1,1) + "" + SUBS(SA2->A2_NUMCON,AT("-",SA2->A2_NUMCON)+2,1)
  ELSE
		_cReturn2 :=  " " + SUBS(SA2->A2_NUMCON,AT("-",SA2->A2_NUMCON)+1,1)
  ENDIF
 Else
  _cReturn2 := SUBS(SA2->A2_NUMCON,AT("-",SA2->A2_NUMCON)+1,1)
 End

Endif

_cReturn3:= _cReturn + _cReturn2

Return(_cReturn3)
