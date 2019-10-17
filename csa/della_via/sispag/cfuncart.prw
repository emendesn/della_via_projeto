#include "rwmake.ch"

User Function CFUNCART()

Local _cReturn := "000"

If SEA->EA_MODELO=="41" .OR. SEA->EA_MODELO=="43"  // TED
 _cReturn := "018"
End

If SEA->EA_MODELO=="03"   // DOC 
 _cReturn := "700"
End

Return(_cReturn)
