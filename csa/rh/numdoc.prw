#include "rwmake.ch"

User Function  (NumDoc)
	
	Local I  := 0
	Local Ok := .T.
	
	If Len(NumDoc) = 6
		For I = 1 to 6
			If Asc(Substr(NumDoc,I,1)) < 48 .or. Asc(Substr(NumDoc,I,1)) > 57
				Ok := .F.
				Exit
			Endif
		EndFor
	Else
		Ok := .F.
	EndIf

Return Ok
