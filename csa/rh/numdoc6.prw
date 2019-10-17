#include "rwmake.ch"

User Function  NumDoc6 ()
	
	Local I  := 0
	Local Ok := .T.
	
	If Len(M->F1_DOC) = 6
		For I = 1 to 6
			If Asc(Substr(M->F1_DOC,I,1)) < 48 .or. Asc(Substr(M->F1_DOC,I,1)) > 57
				Ok := .F.
				Exit
			Endif
		EndFor
	Else
		Ok := .F.
	EndIf

Return Ok
